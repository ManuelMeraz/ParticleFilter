function [M, particles, init] = adjust_particles(weighted_mean, particles, resampling, M, C, init)

    t1 = particles.time_since_reading;
    t2 = particles.last_sensor_reading;
    if sum(particles.weights) == 0

        if ~init.condition
            % Keep doubling until good size of particles found
            M = 2 * M;
            [M, particles] = initialize_particles([0; 0], M, C, t1, t2);
        else

            % Check all particles around weighted mean for 
            % Possible location
            C = [-1, 1; -1, 1; 0, 2*pi];

            % Scale up exploratory range by time since last sensor reading
            C = C.*t1;
            [init.num_parrticles, particles] = initialize_particles(weighted_mean, t1 * M, C, t1, t2);
        end
        return;
    end

    % Good size of particles found
    if ~init.condition
        init.condition = true;
        init.num_particles = M;
    end

    % Anything less than this causes funky errors
    if M < 100
        M = 100;
    end

    % Normalize the fit particles
    particles.weights = particles.weights./sum(particles.weights);

    % How useful are they?
    effective_sample_size = 1/sum(particles.weights.^2);

    if effective_sample_size <= 1
        num_exploratory_particles = floor(resampling.exploratory_ratio * M);

        num_importance_particles = M - num_exploratory_particles;
        switch resampling.method
            case 'uniform'
                particles = uniform_sampling(particles, num_importance_particles);
            case 'weighted'
                particles = weighted_sampling(particles, num_importance_particles);
        end

        if num_exploratory_particles > 4
            weighted_mean = compute_mean(particles);
            [~, exploratory_particles] = initialize_particles(weighted_mean, num_exploratory_particles, C, t1, t2);
            particles.poses = [particles.poses, exploratory_particles.poses];
            particles.weights = [particles.weights, exploratory_particles.weights];
            M = length(particles.poses);
        else
            M = num_importance_particles;
        end

        particles.weights = repmat(1/M, 1, M);

    end
end

function particles = uniform_sampling(particles, num_particles)
    new_particles.poses = [];
    new_particles.weights = [];
    new_particles.time_since_reading = particles.time_since_reading;
    new_particles.last_sensor_reading = particles.last_sensor_reading;

    while length(new_particles.weights) < num_particles

        % Pick a random index of the fit particles
        % with a uniform probability 
        sample = randsample(1:length(particles.weights), 1);

        % Append to list of new samples
        new_particles.poses = [new_particles.poses, particles.poses(:, sample)];
        new_particles.weights = [new_particles.weights, particles.weights(:, sample)];
    end

    particles = new_particles;
    particles.weights = particles.weights./sum(particles.weights);
end

function particles = weighted_sampling(particles, num_particles)
    if num_particles > length(particles.weights) 
        particles.weights = [particles.weights, zeros(1 ,num_particles - length(particles.weights))];
    else
        num_particles = length(particles.weights);
    end
    with_replacement = true;

    % Indeces of high weight samples 
    samples = randsample(1:num_particles, num_particles, with_replacement, particles.weights);
    particles.poses = particles.poses(:, samples);
    particles.weights = repmat(1/num_particles, 1, num_particles);
end
