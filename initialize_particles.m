function [M, particles] = initialize_particles(M, C)
    % To acquire M particles in the end, we're going to distribute
    % the state space over such that dimensions_root(num_particles^dimensions) = num_particles

    % dimensions = number of rows in C
    M = floor(nthroot(M,2));


    x_space = linspace(-4,6,M);
    y_space = linspace(-3,10,M);

    [x_space, y_space] = meshgrid(x_space, y_space);

    particles.poses = [reshape(x_space, 1, numel(x_space));
                 reshape(y_space, 1, numel(y_space))];

    % Readjust M to actual number of particles
    M = length(particles.poses);

    % Initialize heading to 0
    thetas = zeros(1,M);

    % Now we add in an even distribution to the particles
    % Each particle will contain a pose such that
    % pose = [x; y; theta]
    % with an associated weight 0 < weight < 1

    weight = 1 / M;
    weights = ones(1, M) * weight;


    % Particles initialized 
    particles.poses = [particles.poses; thetas];
    particles.weights = weights;

end
