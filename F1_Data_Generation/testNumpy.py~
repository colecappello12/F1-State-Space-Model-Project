import numpy as np

li = [1,2,3,4,5,6]
li2 = [2,3,4,5,6,7]
lin = np.array(li)
lin2 = np.array(li2)
li3 = np.array(lin2/lin).transpose()
tan = np.array([li] * 2).transpose()
lin4 = np.array([lin,lin2]).transpose()

x = np.array([886.4102329,886,877,869.3510324,857])
y = np.array([602.1924781,605,668,722.6436876,811])
t = np.array([3.568,3.579,3.759,3.848,3.979])

dx_dt = np.gradient(x,t)
dy_dt = np.gradient(y,t)
ds_dt = np.sqrt(dx_dt*dx_dt + dy_dt*dy_dt)

d2s_dt2 = np.gradient(ds_dt,t)
print(ds_dt)
