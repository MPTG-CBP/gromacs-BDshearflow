# gromacs-BDshearflow

the BD euler equation has an extra term to account for the shear flow.

x(t+dt)=x(t)+gamma*(z(t) - z0)*dt + inv_fric*f(t)*dt + random_noise

the extra term is:

gamma*(z(t) - z0)*dt

where gamma is the shear flow along the z axis and z0 is the z value for which the velocity is 0.  This extra term is only applied on the x coordinate.

- The modification has been included in  the do_update_bd function of 
src/gromacs/mdlib/update.cpp


- bd_gamma and bd_z0 options have been added in

inputrec.h,

inputrec.ccp, 

tpr.cpp

readir.cpp

simulationdatabase.cpp

tpxio.cpp

so they can be read from the mdp file

