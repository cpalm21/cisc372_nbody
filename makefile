FLAGS= -DDEBUG
LIBS= -lm
ALWAYS_REBUILD=makefile

nbody: nbody.o compute.o
	gcc $(FLAGS) $^ -o $@ $(LIBS)
nbody.o: nbody.c planets.h config.h vector.h $(ALWAYS_REBUILD)
	gcc $(FLAGS) -c $< 
compute.o: compute.c config.h vector.h $(ALWAYS_REBUILD)
	gcc $(FLAGS) -c $< 



nbody_cuda: nbody_cuda.o compute_cuda.o
	nvcc $(FLAGS) $^ -o $@ $(LIBS)

nbody_cuda.o: nbody.cu planets.h config.h vector.h compute.h $(ALWAYS_REBUILD)
	nvcc $(FLAGS) -c $< -o $@

compute_cuda.o: compute.cu config.h vector.h compute.h $(ALWAYS_REBUILD)
	nvcc $(FLAGS) -c $< -o $@


clean:
	rm -f *.o nbody nbody_cuda
