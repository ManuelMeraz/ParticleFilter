function weighted_mean = compute_mean(particles)
    % Sum of weight * pose of particles
    weighted_mean = particles.poses(:,1).*particles.weights(:,1);
    for i = 2:length(particles.weights)
        weight = particles.weights(:,i);
        particle = particles.poses(:,i);
        weighted_mean = weighted_mean + particle.*weight;
    end
end
