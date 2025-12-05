__global__ void compute(vector3 *accels, double *mass, vector3 *d_hVel, vector3 *d_hPos);
__global__ void updateValues(vector3 *accels, vector3 *d_hVel, vector3 *d_hPos);