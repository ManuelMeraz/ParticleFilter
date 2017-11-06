function plot_data(particles, weighted_mean, done)
    scatter(particles.poses(1,:), particles.poses(2,:), 3, 'r', 'filled');
    hold on;

    scatter(weighted_mean(1,:),weighted_mean(2,:),10,'b','filled')
    legend('Particles', 'Weighted Mean');
    text(3,7.8, 'Estimated Pose');
    text(3.6, 6.6, num2str(weighted_mean));
    text(3.5,5.5, 'Particles');
    text(3.8, 4.8, num2str(length(particles.poses)));

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
