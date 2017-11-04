function x = sample_motion_model_velocity(u, x, dt)
    % Alpha 1-4
    a_1_4 = 0.01;

    % Alpha 4-5
    a_4_5 = 0.0005;    

    v = u(1);
    omega = u(2);

    v = v + rand * (a_1_4 * v + a_1_4 * omega);
    omega = omega + rand * (a_1_4 * v + a_1_4 * omega);
    gamma =  rand * (a_4_5 * v + a_4_5 * omega);

    weight = v / omega;

    x(1) = x(1) + weight * ( -sin(x(3)) + sin(x(3) + omega * dt) );
    x(2) = x(2) + weight * ( cos(x(3)) - cos(x(3) + omega * dt) );
    x(3) = x(3) + dt * (gamma + omega);
end
