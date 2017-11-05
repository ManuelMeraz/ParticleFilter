function [M, particles] = adjust_particles(particles, M, C)
    % Normalize weights and resample if necessary
    particles.weights = particles.weights./sum(particles.weights);
    M = length(particles.weights);

    effective_sample_size = 1/sum(particles.weights.^2)

    resample_percentage = 0.30;
    resample_threshold = resample_percentage * M;

    if effective_sample_size < resample_threshold
        'resampling'
        samples = randsample(1:M, M, true, particles.weights);
        particles.poses = particles.poses(:, samples);
        particles.weights = particles.weights(:, samples);
        particles.weights = particles.weights./sum(particles.weights);
        effective_sample_size = 1/sum(particles.weights.^2)
    end

end
