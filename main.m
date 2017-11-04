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

% Print out inital state
x = x

data(1,1) = x(1);
data(1,2) = x(2);

% For the motion model
dt = 1;

for i = 1:length(inputs.commands)

    u = inputs.commands(i,:).';
    z = inputs.sensor_readings(i,:).';

    x = sample_motion_model_velocity(u, x, dt)

    data(i,1) = x(1);
    data(i,2) = x(2);

    % Plot Settings
    scatter(data(1:i,1), data(1:i,2), 5, 'b');
    drawnow;
    pause(0.1);

end
