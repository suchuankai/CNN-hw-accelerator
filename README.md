# CNN-accelerator
This is a CNN accelerator design for NCKU AOC (Team 9) final project.  
  
In this project, we train a model for **Fashion MNIST**, then quantize it with PyTorch to achieve hardware acceleration using **8-bit weights**.  
In hardware design, we also consider the differences in scaling factors between different layers.  
## Software design
![software drawio](https://github.com/suchuankai/CNN-accelerator/assets/69788052/be76b08b-2dc2-4682-8b18-fe30c27d9d7f)  
- Use a CNN model similar to LeNet-5, but replace the convolutional part with 3x3 convolutions.
- Use post-training quantization to quantize the model.
- Hardware implement first layer with a 3x3 convolution, ReLU activation, and max-pooling, using 8-bit computation.
### Quantilize result:  
- Using FashionMNIST dataset with PyTorch, the images in this dataset are 28x28 grayscale images. And we have padded it to a size of 30x30 using our program. It consists of 60,000 training samples and 10,000 
  test samples.  
  The quantized model size is approximately one-fourth of the original size, while the accuracy only slightly decreases. Following table presents the actual results:  
  
  |                  | Before    | After     | 
  |  ----            | ----      | -----     |
  | Model size (MB)  |0.327587   | 0.088283  |
  | Accuracy         |9048/10000 | 9024/10000|
- During the quantization in software, each layer has its own scaling factor and zero point. But for hardware computation, after each layer a dequantization process is performed to match the input of the next layer. In this project, we have only implemented the first layer, so we need to dequantize the computed results to match the input of the second layer. The following are the parameters table for calculating bias and shift:
    
  |                          | Quantize per tensor  | conv1    | pool    | conv2  | pool_1  | fc1     | fc2     | fc3    |
  |  ----                    | ----                 | -----   | -----   | -----   | -----   | -----   | -----   | -----  |
  | Scaling factor (weight)  |                      |0.01744  |         |0.00857  |         |0.00454  |0.00531  |0.00615 |
  | Zeropoint (weight)       |                      |0        |         |0        |         |0        |0        |0       |
  | Scaling factor (IA)      | 0.00392              |0.0087   |0.0087   |0.02115  |0.02115  |0.03913  |0.05797  |0.22862 |
  | Zeropoint(IA)            |    0                 |0        |0        |0        |0        |0        |0        |175     |  
  > ![Equation](https://latex.codecogs.com/svg.image?\text{Bias}&space;=&space;\frac{{\text{{bias}}}}{{\text{{input&space;scale}}&space;\cdot&space;\text{{weight&space;scale}}}}&space;=&space;\frac{{0.031352922}}{{0.00392&space;\cdot&space;0.01744}}&space;\approx&space;459&space;&space;)    
  > ![Equation](https://latex.codecogs.com/svg.image?&space;\text{shift&space;bit}&space;=&space;\frac{{\text{outputscale}}}{{\text{inputscale}&space;\cdot&space;\text{weightscale}}}&space;=&space;\frac{{0.0087}}{{0.00392&space;\cdot&space;0.01744}}&space;\approx&space;127.28&space;\approx&space;\text{right&space;shift&space;7&space;bit}&space;)  
- In this project, we have only completed the computation of one kernel. For detailed information, please refer to `./software`.
## Hardware design overview
<img src="https://github.com/suchuankai/CNN-accelerator/assets/69788052/51b1f17f-5ad2-4f5c-94c1-2fdd4bb84c82" width="800" height="350" alt="Top design"/>  
    
We implemented this simple CNN accelerator based on Eeyriss. Basically, there are four important parts in our design.  
### FIFO
![mem (2) drawio](https://github.com/suchuankai/CNN-accelerator/assets/69788052/f5097358-ebe4-448c-9f06-379a00af8a4e)  
When designing the accelerator, size of the input feature map is 30x30. Therefore, each ifmap buffer requires 30 data entries. Considering that each input is 64 bits, there will be cases where the input data spans two rows. To address this issue, we have designed a FIFO (First-In-First-Out) module to handle situations. The FIFO module outputs 2 control signals:
  - canWrite : control signal is set to 1 when the index is less than or equal to 64. When "canWrite" is high, tb can write a new data entry into the FIFO.
  - canRead : The "canRead" control signal is set to 1 when the index is greater than or equal to 64. When "canRead" is high, it signifies that the data can be read out.
### PE array
<img src="https://github.com/suchuankai/CNN-accelerator/assets/69788052/86b5e841-b06f-4112-9758-7eacdc282bf2" width="800" height="500" alt="PE array"/> 
  
During data input to PE array, the kernel will be broadcasted to the entire row of PEs at once. As for the input feature map, the data will be simultaneously transmitted diagonally to 3 PEs. This allows for the sharing of the input feature map and kernel.

### Psum buffer
<img src="https://github.com/suchuankai/CNN-accelerator/assets/69788052/06a03950-56d1-4291-b702-2e268143c365" width="550" height="380" alt="Psum buffer"/> 
  
This processing includes ReLU activation and quantization. Based on the calculations during numerical preprocessing, we determined that the quantization requires a right shift of 7 bits. At this stage, we perform pairwise horizontal comparisons, achieving partial max-pooling. Therefore, each time, we will output 4 8-bit computation results.

### Conv buffer
<img src="https://github.com/suchuankai/CNN-accelerator/assets/69788052/f1fbd144-bd6e-4d41-8a03-e1c1f3611455" width="550" height="360" alt="Conv buffer"/>  
  
Conv buffer receives 4 sets of 8-bit values from the psum buffer each time. In this process, we buffer the results of the first row. When we receive the values of the second row, we can immediately compare them vertically with the results of the previous row to obtain the max-pooling result.
