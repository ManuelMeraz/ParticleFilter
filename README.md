![Constant Readings](https://github.com/ManuelMeraz/ParticleFilter/blob/master/particle_filter_contant_readings.gif)

run main_constant.m for constant sensor readings
run main_sporadic.m for sporadic sensor readings

This program dynamically calculates the minimum number of particles 
to use based off of their fitness. 

As I was playing around with resampling, I experimented with
2 types if resampling. 

1) Given a set of fit particles, sample from the set 
   using a uniform random probability to generate a new particle

2) Given a set of fit particles, sample from the set
   using a weighted random probability to generate a new particle

I realize that the particle filter algorithm prefers
weighted sampling, but after playing around with both uniform 
and weighted, I prefer uniform because you have a more diverse
set of particles preventing the robot from getting lost.

During this process I thought of a cool idea, because the sensor
is so accurate, and the motion model might not be the best
the partices might eventually diverge. Hence, in the case
of resampling a certain percentage of them, relative to
the total particles are exploratory particles.

Essentially, yes, we keep most of the important particles, but
to prevent diverging, we throw some particles all over the
state space uniformly to see if they survive through the next
generation. If they do and the robots motion model diverges, then
we can jump to those exploratory particles to relocalize. 

In case the robot gets completely lost, I keep track of the previous 
weighted mean of the robot and I check particles all over the position
scaled up by the time since the last sensor reading. Both in terms 
of number of particles and in terms of distance outwards from the robot.

How the program works

The minimum number of particles we can start with is 64, just due
to the way i programmed my initialization function.

As time goes on, the number of particles keeps doubling until 
a fit particle is found (i.e. the weight is > 0) and we keep
track of this number of particles.

The next generation of particles are created based off of these
new fit particles. For every particle in the next iteration,
we apply the dynamics model and the ones that survive move forward.

Since my program is dynamic, the number of fit particles is the new M
and therefore the optimal M for any given situation. If the robot gets lost,
then M becomes the initial M based off the initial state scaled by time since
the last sensor reading.

For example, if we had to generate 1000 particles in the beginning to 
find a fit particle, and the last sensor reading was 3 seconds ago.

Then we generate 3 * 1000 = 3000 particles around the current weighted mean
scaled by a square area of 3 * 2 m^2. So if it has been a long time
since the sensor reading has come in, then it would use more particles further
out to find itself.

I did not account for the case where it is possible that a sensor reading will 
never come again.
