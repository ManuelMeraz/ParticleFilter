function plot_data(particles, weighted_mean, done)
    scatter(particles.poses(1,:), particles.poses(2,:), 3, 'r', 'filled');
    hold on;

    scatter(weighted_mean(1,:),weighted_mean(2,:),10,'b','filled')
    legend('Particles', 'Weighted Mean');
    text(4,7.8, 'Estimated Pose');
    text(4.6, 6.6, num2str(weighted_mean));
    text(4.5,5.4, 'Particles');
    text(4.8, 4.8, num2str(length(particles.poses)));
    text(4.2,4.0, 'Time since reading');
    text(4.3, 3.2, num2str(particles.time_since_reading));
    text(4.9,3.2, ' seconds ago');

    xlim([-4, 6]);
    ylim([-3, 10]);
    drawnow;

    if ~done
        pause(0.001);
    else
        pause();
    end
    clf;
end
