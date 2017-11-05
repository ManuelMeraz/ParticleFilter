function particles = initialize_particles(M, C)
    % Imlemented with 3 dimensions in mind, but 
    
    % To acquire M particles in the end, we're going to distribute
    % the state space over such that dimensions_root(num_particles^dimensions) = num_particles

    % dimensions = number of rows in C
    M = floor(nthroot(M,2));


    x_space = linspace(-4,6,M);
    y_space = linspace(-3,10,M);

    for i = length(x_space)
        x_space(1,i) = x_space(1,i) + (rand * M);
        y_space(1,i) = y_space(1,i) + (rand * M);
    end

    % (0, 2 * pi]
    %theta_space = linspace(2 * pi / M, 2 * pi, M);

    % Adjust yaw range to not include 2 * pi
    % [0, 2 * pi)
    %for i=1:length(theta_space)
        %theta_space(i) = theta_space(i) - 2 * pi / M;
    %end

    [x_space, y_space] = meshgrid(x_space, y_space);

    particles = [reshape(x_space, 1, numel(x_space));
                   reshape(y_space, 1, numel(y_space))];

    % Now we add in an even distribution to the particles
    % Each particle will be a column vector such that
    % particle = [x; y; theta; probability]

    probability = 1 / length(particles);
    probabilities = ones(1,length(particles)) * probability;
    thetas = zeros(1,length(particles));


    % Particles initialized 
    particles = [particles; thetas; probabilities];

end
