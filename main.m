% Manuel Meraz
% EECS 270 Robot Algorithms
% Simple Particle Filter
%pkg load statistics

inputs = read_files();

% Number of particles
% Minimum is 9
M = 20000;

% Initialize continuous state space ranges
% Each row represents a dimension for the state
C = [-4, 6; -3, 10; 0, 2*pi];

% Each particle will be a column vector such that
% particle = [x; y; theta; probability]
% Adjust M for actual number of particles after initialized
[M, particles] = initialize_particles(M, C);

% For the motion model
dt = 0.5;

good_particles_found = false;

%%for i = 1:length(inputs.commands)
for k = 1:100

    % Action command
    u = inputs.commands(k,:).';

    % Sensor reading
    z = inputs.sensor_readings(k,:).';

    % Count the number of particles that survive
    for m = 1:M

        particle = particles.poses(:,m);
        weight = particles.weights(1,m);

        particle = sample_motion_model_velocity(u, particle, dt);

        weight =  weight * beam_range_finder_model(z, particle);

        particles.poses(:,m) = particle;
        particles.weights(1,m) = weight;

    end

    [M, particles] = adjust_particles(particles, M, C);

    % Plot Settings
    scatter(particles.poses(1,:), particles.poses(2,:), 3, 'r');
    hold on;

    scatter(mean(particles.poses(1,:)), mean(particles.poses(2,:)),5,'b','filled')

    xlim([-10, 10]);
    ylim([-5, 20]);
    drawnow;
    pause(0.00001);
    clf;
end
