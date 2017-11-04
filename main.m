% Manuel Meraz
% EECS 270 Robot Algorithms
% Simple Particle Filter

inputs = read_files();

% Number of particles 
M = 9;

% Initialize continuous state space ranges
% Each row represents a dimension for the state
C = [-4, 6; -3, 10; 0, 2*pi];

% Each particle will be a column vector such that
% particle = [x; y; theta; probability]
particles = initialize_particles(M, C);

% Initialize random state within state space
for i = 1:size(C)(1,1)
    x(i) = rand * ( C(i, 2) - C(i, 1) ) + C(i, 1);
end

