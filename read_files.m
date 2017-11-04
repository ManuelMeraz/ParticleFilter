function inputs = read_files()

    file = fopen('inputs.txt');
    commands = cell2mat(textscan(file, '%f %f'));
    fclose(file);

    file = fopen('sensor_readings.txt');
    sensor_readings = cell2mat(textscan(file, '%f %f %f'));
    fclose(file);

    file = fopen('sporadic_sensor_readings.txt');
    sporadic_sensor_readings = cell2mat(textscan(file, '%f %f %f %f'));
    fclose(file);

    inputs.commands = commands;
    inputs.sensor_readings = sensor_readings;
    inputs.sporadic_sensor_readings = sporadic_sensor_readings;

end
