function [M, particles] = adjust_particles(particles, resampling, M, C)
    if sum(particles.weights) == 0
        [M, particles] = initialize_particles(M, C);
        return;
    end

    % Normalize the fit particles
    particles.weights = particles.weights./sum(particles.weights);

    % How useful are they?
    effective_sample_size = 1/sum(particles.weights.^2)

    if effective_sample_size <= 1
        'resampling'

        switch resampling.method
            case 'uniform'
                particles = uniform_sampling(particles, M);
            case 'weighted'
                particles = weighted_sampling(particles, M);
        end

    end
end

function particles = uniform_sampling(particles, M)
    new_particles.poses = [];
    new_particles.weights = [];

    while length(new_particles.weights) < M

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

function particles = weighted_sampling(particles, M)
    particles.weights = [particles.weights, zeros(1 ,M - length(particles.weights))];
    with_replacement = true;

    % Indeces of high weight samples 
    samples = randsample(1:M, M, with_replacement, particles.weights);
    particles.poses = particles.poses(:, samples);
    particles.weights = repmat(1/M, 1, M);
end
