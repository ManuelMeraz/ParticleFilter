function [M, particles] = adjust_particles(particles, M, C)
    % Normalize weights and resample if necessary
    if sum(particles.weights) == 0
        [M, particles] = initialize_particles(M, C);
        return;
    end

    % Normalize
    particles.weights = particles.weights./sum(particles.weights);

    effective_sample_size = 1/sum(particles.weights.^2);

    resample_percentage = 0.5;
    resample_threshold = resample_percentage * length(particles.weights);

    if effective_sample_size < resample_threshold
        new_particles.poses = [];
        new_particles.weights = [];

        while length(new_particles.poses) < M
            sample = randsample(1:length(particles.weights), 1);
            new_particles.poses = [new_particles.poses, particles.poses(:, sample)];
            new_particles.weights = [new_particles.weights, particles.weights(:, sample)];
        end

        particles = new_particles;
        particles.weights = particles.weights./sum(particles.weights);
    end
    %if effective_sample_size < resample_threshold
        %'resampling'
        %new_particles.poses = [];
        %new_particles.weights = [];

        %while length(new_particoes.poses < M) {
        %sample = randsample(1:length(particles.weights), 1);
        %particles.poses = particles.poses(:, samples);
        %particles.weights = repmat(1/M, 1, M);
    %end
end
