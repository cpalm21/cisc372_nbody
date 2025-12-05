#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include "vector.h"
#include "config.h"


//compute: Updates the positions and locations of the objects in the system based on gravity.
//Parameters: None
//Returns: None
//Side Effect: Modifies the hPos and hVel arrays with the new positions and accelerations after 1 INTERVAL





__global__ 
void compute(vector3 *accels, double *mass, vector3 *d_hVel, vector3 *d_hPos){
	//make an acceleration matrix which is NUMENTITIES squared in size;
	int i,j,k;

    //get i and j values
    i = blockIdx.x * blockDim.x + threadIdx.x;
    j = blockIdx.y * blockDim.y + threadIdx.y;

	if (i >= NUMENTITIES || j >= NUMENTITIES) return;


    

    //index for accels array
    int idx = i * NUMENTITIES + j;

	
    //first compute the pairwise accelerations.  Effect is on the first argument.

	if (i==j) {
		FILL_VECTOR(accels[idx],0,0,0);
	}else{
		vector3 distance;
		for (k=0;k<3;k++) distance[k]=d_hPos[i][k]-d_hPos[j][k];
		double magnitude_sq=distance[0]*distance[0]+distance[1]*distance[1]+distance[2]*distance[2];
		double magnitude=sqrt(magnitude_sq);
		double accelmag=-1*GRAV_CONSTANT*mass[j]/magnitude_sq;
		FILL_VECTOR(accels[idx],accelmag*distance[0]/magnitude,accelmag*distance[1]/magnitude,accelmag*distance[2]/magnitude);
	}


	

}






__global__ void updateValues(vector3 *accels, vector3 *d_hVel, vector3 *d_hPos){
	
	  //sum up the rows of our matrix to get effect on each entity, then update velocity and position.
	vector3 accel_sum={0,0,0};
	int i = blockIdx.x * blockDim.x + threadIdx.x;
    if(i >= NUMENTITIES){
        return;
    }
	for(int j = 0; j < NUMENTITIES; j++){

		for (int k=0;k<3;k++){
        	accel_sum[k]+=accels[i * NUMENTITIES + j][k];
		}

	}
	

	
		

    for (int k=0;k<3;k++){
            
		d_hVel[i][k]+=accel_sum[k]*INTERVAL;
		d_hPos[i][k]+=d_hVel[i][k]*INTERVAL;

    }


}





