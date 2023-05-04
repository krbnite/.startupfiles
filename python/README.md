


```python
import numpy as np
import pandas as pd

arr1 = np.random.randn(10,2)
df1  = pd.DataFrame(arr1, columns=['a','b'])
df2  = pd.DataFrame({'a':np.random.randn(10),'b':np.random.randn(10)})
arr2 = np.asarray(df2)
df3 = df1

#--Shape, Size, Dims
arr1.shape, arr1.size, arr1.ndim
df1.shape, df1.size, df1.ndim
#---IS
df3 is df1 # true

#-- change arr elements 
arr1[...,1:] *= 2


```
