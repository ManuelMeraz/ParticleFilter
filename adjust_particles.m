function [M, particles, init] = adjust_particles(weighted_mean, particles, resampling, M, C, init)
    if sum(particles.weights) == 0

        if ~init
            % Keep doubling until good size of particles found
            M = 3 * M;
            [M, particles] = initialize_particles([0; 0], M, C);
        else

            % Check all particles around weighted mean for 
            % Possible location
            C = [-1, 1; -1, 1; 0, 2*pi];
            [M, particles] = initialize_particles(weighted_mean, M, C);
        end
        return;
    end

    % Good size of particles found
    if ~init
        'init!'
        init = true;
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
            [~, exploratory_particles] = initialize_particles(weighted_mean, num_exploratory_particles, C);
            particles.poses = [particles.poses, exploratory_particles.poses];
            particles.weights = [particles.weights, exploratory_particles.weights];
            M = length(particles.weights);
        else
            M = num_importance_particles;
        end

        particles.weights = repmat(1/M, 1, M);

    end
end

function particles = uniform_sampling(particles, num_particles)
    new_particles.poses = [];
    new_particles.weights = [];

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
