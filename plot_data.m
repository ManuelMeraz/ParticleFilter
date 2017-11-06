function plot_data(particles, weighted_mean)
    scatter(particles.poses(1,:), particles.poses(2,:), 3, 'r');
    hold on;

    scatter(weighted_mean(1,:),weighted_mean(2,:),10,'b','filled')

    xlim([-4, 6]);
    ylim([-3, 10]);
    drawnow;
    pause(0.001);
    clf;
end
