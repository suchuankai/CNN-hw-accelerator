# AI-accelerator
This is a CNN Accelerator design for the NCKU AOC (Team 9) final project.  
  
In this project, we train a model for **Fashion MNIST**, then quantize it with PyTorch to achieve hardware acceleration using **8-bit weights**.  
In hardware design, we also consider the differences in scaling factors between different layers.  
## Software design
![software drawio](https://github.com/suchuankai/CNN-accelerator/assets/69788052/be76b08b-2dc2-4682-8b18-fe30c27d9d7f)  
- Use a CNN model similar to LeNet-5, but replace the convolutional part with 3x3 convolutions.
- Use post-training quantization to quantize the model.
- Hardware implement first layer with a 3x3 convolution, ReLU activation, and max-pooling, using 8-bit computation.

## Hardware design Overview
![top drawio](https://github.com/suchuankai/CNN-accelerator/assets/69788052/51b1f17f-5ad2-4f5c-94c1-2fdd4bb84c82)  
  
We implemented this simple CNN accelerator based on the Eeyriss. Basically, there are five parts in our design.

