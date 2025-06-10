import numpy as np

def calculate_curvature(points):
    """
    Calculate the curvature of a set of 2D points.

    Parameters:
    points (np.ndarray): An Nx2 array of points, where each row is (x, y).

    Returns:
    np.ndarray: An array of curvature values at each point.
    """
    # Ensure the input is a NumPy array
    points = np.array(points)

    # Number of points
    n = len(points)

    # Derivatives
    dx = np.gradient(points[:, 0])
    dy = np.gradient(points[:, 1])
    d2x = np.gradient(dx)
    d2y = np.gradient(dy)

    # Curvature calculation
    curvature = (d2y * dx - d2x * dy) / (dx**2 + dy**2)**(3/2)

    return curvature

# Example usage:
points = np.array([[0, 0,0], [1, 1,.5], [2, 3, 1], [8, 6, 1.5], [12, 10, 2]])
#curvature_values = calculate_curvature(points)
#print(curvature_values)

def getAcceleration(points):

    #points should be np.array with time as well
    
    #dx = np.gradient(points[:,0])
    #dy = np.gradient(points[:,1])
    #dt = np.gradient(points[:,2])

    #dx_dt = dx/dt
    #dy_dt = dy/dt
    points[:,0] = points[:,0] / 10
    points[:,1] = points[:,1] / 10 
    dx_dt = np.gradient(points[:,0],points[:,2])  #trying to use time in points[:,2] to calculate dx_dt right off the bat
    dy_dt = np.gradient(points[:,1],points[:,2])

    velocity = np.array([dx_dt,dy_dt]).transpose()
    print(velocity)

    ds_dt = np.sqrt(dx_dt*dx_dt + dy_dt*dy_dt)

    Tangent = velocity/np.array([ds_dt]*2).transpose()

    dTx_dt = np.gradient(Tangent[:,0],points[:,2])
    dTy_dt = np.gradient(Tangent[:,1],points[:,2])
    
    T_Norm = np.sqrt(dTx_dt*dTx_dt + dTy_dt*dTy_dt)

    Normal = np.array([dTx_dt,dTy_dt]).transpose() / np.array([T_Norm] * 2).transpose()
    print(Normal)
    d2x_dt = np.gradient(dx_dt, points[:,2])
    d2y_dt = np.gradient(dy_dt, points[:,2])
    d2s_dt = np.gradient(ds_dt,points[:,2])

    curvature = np.abs((d2y_dt * dx_dt - d2x_dt * dy_dt)) / (dx_dt**2 + dy_dt**2)**(3/2)

    a_t = np.array([d2s_dt]*2).transpose() * Tangent
    a_n = np.array([curvature]*2).transpose() * np.array([ds_dt**2]*2).transpose() * Normal
    a_tn = a_t + a_n
    a = np.sqrt(a_tn[:,0]*a_tn[:,0] + a_tn[:,1]*a_tn[:,1])

    ret = [a_t,a_n,a]

    return ret


#a = np.array([ [  0.  ,   0.  ,0],[  0.3 ,   0.  ,.5],[  1.25,  -0.1 ,1],
#              [  2.1 ,  -0.9 ,1.5],[  2.85,  -2.3 ,2],[  3.8 ,  -3.95,2.5],
#              [  5.  ,  -5.75,3],[  6.4 ,  -7.8 ,3.5],[  8.05,  -9.9 ,4],
#              [  9.9 , -11.6 ,4.5],[ 12.05, -12.85,5],[ 14.25, -13.7 ,5.5],
#              [ 16.5 , -13.8 ,6],[ 19.25, -13.35,6.5],[ 21.3 , -12.2 ,7],
#              [ 22.8 , -10.5 ,7.5],[ 23.55,  -8.15,8],[ 22.95,  -6.1 ,8.5],
#              [ 21.35,  -3.95,9],[ 19.1 ,  -1.9 ,9.5]])
#accel = getAcceleration(a)
#print(accel[0])
#print(accel[1])
