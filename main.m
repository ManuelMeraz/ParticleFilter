% Manuel Meraz
% EECS 270 Robot Algorithms
% Simple Particle Filter
pkg load statistics

inputs = read_files();

% Number of particles
% Minimum is 9
M = 100;

% Initialize continuous state space ranges
% Each row represents a dimension for the state
C = [-4, 6; -3, 10; 0, 2*pi];

% Each particle will be a column vector such that
% particle = [x; y; theta; probability]
particles = initialize_particles(M, C);

% For the motion model
dt = 1;

%for i = 1:length(inputs.commands)
for i = 1:100

    u = inputs.commands(i,:).';
    z = inputs.sensor_readings(i,:).';

    for i = 1:length(particles)

        particles(1:3,i) = sample_motion_model_velocity(u, particles(1:3,i), dt);

        particles(4,i) =  particles(4,i) * beam_range_finder_model(z, particles(:,i));

    end

    particles(4,:) = particles(4,:)./sum(particles(4,:));

    effective_sample_size = 1/sum(particles(4,:).^2);
    resample_percentage = 0.50;
    resample_threshold = resample_percentage * M;

    if effective_sample_size < resample_threshold
        sample = randsample(1:length(particles), length(particles), true, particles(4,:));
        particles = particles(:, sample);
        particles(4,:) = particles(4,:)./sum(particles(4,:));
    end


    %plot(1:length(particles),particles(4,:))
    % Plot Settings
    %hold on;
    
    scatter(particles(1,:), particles(2,:), 3, 'r');
    xlim([-10, 10]);
    ylim([-5, 20]);
    %drawnow;
    pause(0.1);

end
