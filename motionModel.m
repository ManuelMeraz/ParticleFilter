function muBar = motionModel(mu, u , dt)
    muBar = [mu(1,1) + u(1,1) * dt * cos(mu(3,1));
             mu(2,1) + u(1,1) * dt * sin(mu(3,1));
             mu(3,1) + u(2,1)];
end
