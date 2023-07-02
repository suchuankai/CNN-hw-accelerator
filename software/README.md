# Software part
Software part needs to quantize the model into 8 bits and extract data from first layer and second layer of model as inputs and golden data for hardware design.  

**Following is the execution sequence of the program:**
1. Execute the "quantilize.ipynb" notebook to generate an input feature map of size 28x28 and a max-pooling result of size 14x14.  
   You can check each layer weight and bias in `./model/layer`.  
2. Use "padding.py" program to transform the input feature map into a size of 30x30 by adding padding.  
3. Use "gen.py" program to organize the data into groups of 8 and format them as rows of 64-bit data.
  
![image](https://github.com/suchuankai/CNN-accelerator/assets/69788052/66f176c6-4517-4ede-be00-c86595419c8f)  

