function [M, particles] = initialize_particles(weighted_mean, M, C)
    % To acquire M particles in the end, we're going to distribute
    % the state space over such that dimensions_root(num_particles^dimensions) = num_particles

    % dimensions = number of rows in C
    M = floor(nthroot(M,3));


    x_space = linspace(C(1,1),C(1,2),M);
    x_space = x_space + weighted_mean(1);
    y_space = linspace(C(2,1),C(2,2),M);
    y_space = y_space + weighted_mean(2);
    theta_space = linspace(2*pi/M, 2*pi,M);

    [x_space, y_space, theta_space] = meshgrid(x_space, y_space, theta_space);

    particles.poses = [reshape(x_space, 1, numel(x_space));
                       reshape(y_space, 1, numel(y_space));
                       reshape(theta_space, 1, numel(theta_space))];

    % Readjust M to actual number of particles
    M = length(particles.poses);

    % Now we add in an even distribution to the particles
    % Each particle will contain a pose such that
    % pose = [x; y; theta]
    % with an associated weight 0 < weight < 1

    weight = 1 / M;
    weights = ones(1, M).* weight;

    % Particles initialized 
    particles.weights = weights;

end
