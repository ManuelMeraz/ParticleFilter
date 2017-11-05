function q = beam_range_finder_model(z, particle)

    landmarks = [5, 5; 4, 7; -3, 2];
    q = 1;

    for i = 1:length(landmarks)
       d = distance(particle(1:2),landmarks(i,:).');
       sensor_reading = z(i);
       p = normpdf(d - z(i), 0, 2);
       q = q * p;
    end

end

function d = distance(p1, p2) 
    xDiff = p1(1,1) - p2(1,1);
    yDiff = p1(2,1) - p2(2,1);
    
    d = sqrt(xDiff^2 + yDiff^2);
end
