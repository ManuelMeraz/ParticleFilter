% Manuel Meraz
% EECS 270 Robot Algorithms
% Simple EKF


file = fopen('inputs.txt');
inputs = cell2mat(textscan(file, '%f %f'));
fclose(file);

file = fopen('sensor_readings.txt');
sensorReadings = cell2mat(textscan(file, '%f %f %f'));
fclose(file);

file = fopen('sporadic_sensor_readings.txt');
sporadicSensorReadings = cell2mat(textscan(file, '%f %f %f %f'));
fclose(file);

% Part 1
mu = [0; 0; 0];
dt = 0.5;
sigmaNaught = eye(3,3) * 0.001;
landmarks = [5, 5;  4, 7; -3, 2];

data(1,1) = mu(1,1);
data(1,2) = mu(2,1);


for i = 1:size(inputs)

    u = inputs(i,:).';
    z = sensorReadings(i, :).';

    % Prediction
    time = i * dt
    muBar = motionModel(mu, u, dt);
    sigmaBar = adjustSigma(muBar, u, dt, sigmaNaught);

    % Correction
    [K, H] = computeKalmanGain(muBar, sigmaBar, landmarks);
    mu = correction(muBar, K, z, landmarks)
    sigmaNaught = correctSigma(K, H, sigmaBar)

    data(i,1) = mu(1,1);
    data(i,2) = mu(2,1);

    % Plot Settings
    scatter(data(1:i,1), data(1:i,2),1,'b');
    hold on;

    % Plot ellipsoid on top of point
    ellipsoidMatrix = sigmaNaught(1:2,1:2);
    error_elipse(ellipsoidMatrix, mu(1:2));
    drawnow;
    pause(0.2);

end

pause()
clf

% Part 2
mu = [0; 0; 0]
sigmaNaught = eye(3,3) * 0.001

sporadicData(1,1) = mu(1,1);
sporadicData(1,2) = mu(2,1);

sporadicCounter = 1;
for i = 1:size(inputs)

    u = inputs(i,:).';

    % Prediction
    muBar = motionModel(mu, u, dt);
    mu = muBar
    sigmaBar = adjustSigma(muBar, u, dt, sigmaNaught);
    sigmaNaught = sigmaBar

    % Correction
    time = i * dt
    if time == sporadicSensorReadings(sporadicCounter,1)

        z = sporadicSensorReadings(sporadicCounter,2:4).';
        [K, H] = computeKalmanGain(muBar, sigmaBar, landmarks);

        mu = correction(muBar, K, z, landmarks)
        sigmaNaught = correctSigma(K, H, sigmaBar)

        sporadicCounter = sporadicCounter + 1;

    end

    sporadicData(i,1) = mu(1,1);
    sporadicData(i,2) = mu(2,1);

    % Plot Settings
    scatter(sporadicData(1:i,1), sporadicData(1:i,2),1,'b');
    hold on;

    % Elipsoid Plot
    ellipsoidMatrix = sigmaNaught(1:2,1:2);
    error_elipse(ellipsoidMatrix, mu(1:2));
    drawnow;
    pause(0.2);

end
