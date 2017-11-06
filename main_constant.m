% Manuel Meraz
% EECS 270 Robot Algorithms
% Simple Particle Filter

inputs = read_files();

% Number of particles
% Minimum is 64 due to cube rooting
M = 64;

% Increase M until weighted mean moves
clear init;
init.condition = false;
init.num_particles = M;

% Set to true to indefinitely pause plot
done = false;

% Uniform importance sampling means that given
% all the fit particles, sample particles from the fit
% set of particles with equal probability
resampling.method = 'uniform';

% Weighted importance sampling samples
% and acquired particles based off of their weights
% i.e. the fittest weights get picked
%resampling.method = 'weighted';

% Sometimes all the weights approach a probability of zero
% Throw some particles outside of weighted mean to not
% get completely lost and diversify the particles

% The ratio of particles not sampled from the importance
% distribution. 
resampling.exploratory_ratio = 0.01;

% Initialize continuous state space ranges
% Each row represents a dimension for the state
C = [-4, 6; -3, 10; 0, 2*pi];

% Each particle will be a column vector such that
% particles.poses(:,i) = [x; y; theta]
% particles.weights(:,i) = 0 < w < 1;
% Adjust M for actual number of particles after initialized
weighted_mean = [0; 0];
time = 0;
[M, particles] = initialize_particles(weighted_mean, M, C, time, time);

% For the motion model
dt = 0.5;

for k = 1:length(inputs.commands)

    % Action command
    u = inputs.commands(k,:).';

    % Sensor reading
    z = inputs.sensor_readings(k,:).';

    % Time since last sensor reading
    time = k * dt;
    particles.time_since_reading = time - particles.last_sensor_reading;
    particles.last_sensor_reading = time;

    % Count the number of particles that survive
    clear fit_particles;
    fit_particles.poses = [];
    fit_particles.weights = [];
    fit_particles.time_since_reading = particles.time_since_reading;
    fit_particles.last_sensor_reading = particles.last_sensor_reading;
    for m = 1:length(particles.weights)

        particle = particles.poses(:,m);
        weight = particles.weights(1,m);

        % Predict particle motion
        particle = sample_motion_model_velocity(u, particle, dt);

        % Weight of the new particle position
        weight =  weight * beam_range_finder_model(z, particle);

        % The particle is useful
        if weight > 0
                fit_particles.poses = [fit_particles.poses, particle];
                fit_particles.weights = [fit_particles.weights, weight];
        end

    end

    % Compute the weighted mean of particles
    weighted_mean = compute_mean(particles);

    % Normalized and Resmaples particles if necessary
    [M, particles, init] = adjust_particles(weighted_mean, fit_particles, resampling, M, C, init);

    plot_data(particles, weighted_mean, done);
end

% Final plot
done = true;
plot_data(particles, weighted_mean, done);
