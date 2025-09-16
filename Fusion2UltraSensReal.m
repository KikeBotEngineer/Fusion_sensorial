%% Ejecucion continua
%Fusion sensorial en tiempo real de 2 sensores ultrasónicos
clear; close all; clc;

% Conexión serial
porta = 'COM8'; % Puerto de Arduino
baudrate = 9600; 
arduino = serialport(porta, baudrate);

% Parámetros iniciales de los sensores
sigma_sensor1 = 1.1036;  % Desviación estándar sensor 1
sigma_sensor2 = 0.6881;  % Desviación estándar sensor 2
var_sensor1 = sigma_sensor1^2;
var_sensor2 = sigma_sensor2^2;

figure;
hold on;

while true
    if arduino.NumBytesAvailable > 0
        % Datos en formato "d1,d2"
        data = readline(arduino);
        sensores = str2double(split(data, ',')); % Separar y convertir a números

        % Mediciones
        d1 = sensores(1); % Sensor 1
        d2 = sensores(2); % Sensor 2

        % Mediciones no válidas
        if d1 == -1 || d2 == -1 || isnan(d1) || isnan(d2)
%             disp('Medición no válida, ignorando...');
            continue;
        end

        % Fusión sensorial
        mu_fusionada = (var_sensor2 * d1 + var_sensor1 * d2) / (var_sensor1 + var_sensor2);
        var_fusionada = (var_sensor2 * var_sensor1) / (var_sensor1 + var_sensor2);
        sigma_fusionada = sqrt(var_fusionada);

        % Graficar
        x = linspace(mu_fusionada - 3 * sigma_fusionada, mu_fusionada + 3 * sigma_fusionada, 100);
        pdf1 = normpdf(x, d1, sqrt(var_sensor1));
        pdf2 = normpdf(x, d2, sqrt(var_sensor2));
        pdf_f = normpdf(x, mu_fusionada, sigma_fusionada);

        plot(x, pdf1, 'b');
        hold on;
        plot(x, pdf2, 'r');
        plot(x, pdf_f, 'k');
        legend('Sensor 1', 'Sensor 2', 'Fusión');
        pause(0.1);
        hold off;

        % Resultados 
         disp(['Medición sensor 1: ', num2str(d1), ' cm']);
         disp(['Medición sensor 2: ', num2str(d2), ' cm']);
        disp(['Fusión - media: ', num2str(mu_fusionada), ...
              ', varianza: ', num2str(var_fusionada), ...
              ', sigma: ', num2str(sigma_fusionada)]);
    else
        disp('Esperando datos del sensor...');
        pause(0.1);
    end
end

% Cerrar conexión 
clear arduino;

%% Ejecución finita
% Fusión sensorial en tiempo real de 2 sensores ultrasónicos
clear; close all; clc;

% Configuración de conexión serial
porta = 'COM8'; % Puerto de Arduino
baudrate = 9600; 
arduino = serialport(porta, baudrate);

% Parámetros iniciales de los sensores
sigma_sensor1 = 1.1036;  % Desviación estándar sensor 1
sigma_sensor2 = 0.6881;  % Desviación estándar sensor 2
var_sensor1 = sigma_sensor1^2;
var_sensor2 = sigma_sensor2^2;

figure;
hold on;
n = 60; % Número de muestras
contador = 0; % Contador de muestras
tic

while toc < n
    if arduino.NumBytesAvailable > 0
        % Datos en formato "d1,d2"
        data = readline(arduino);
        sensores = str2double(split(data, ',')); 

        % Verificar datos 
        if numel(sensores) < 2 || any(isnan(sensores))
            disp('Datos no válidos, ignorando...');
            continue;
        end

        % Mediciones
        d1 = sensores(1); % Sensor 1
        d2 = sensores(2); % Sensor 2

        % Mediciones no válidas
        if d1 == -1 || d2 == -1
            disp('Medición no válida, ignorando...');
            continue;
        end
        contador = contador + 1;

        % Fusión sensorial
        mu_fusionada = (var_sensor2 * d1 + var_sensor1 * d2) / (var_sensor1 + var_sensor2);
        var_fusionada = (var_sensor2 * var_sensor1) / (var_sensor1 + var_sensor2);
        sigma_fusionada = sqrt(var_fusionada);

        % Graficar
        x = linspace(mu_fusionada - 3 * sigma_fusionada, mu_fusionada + 3 * sigma_fusionada, 100);
        pdf1 = normpdf(x, d1, sqrt(var_sensor1));
        pdf2 = normpdf(x, d2, sqrt(var_sensor2));
        pdf_f = normpdf(x, mu_fusionada, sigma_fusionada);

        plot(x, pdf1, 'b', 'Linewidth',3);
        hold on;
        plot(x, pdf2, 'r', 'Linewidth',3);
        plot(x, pdf_f, 'k', 'Linewidth',3);
        legend('Sensor 1', 'Sensor 2', 'Fusión');
        pause(0.5);
        hold off;

        % Resultados
        disp(['Fusión - media: ', num2str(mu_fusionada), ...
              ', varianza: ', num2str(var_fusionada), ...
              ', sigma: ', num2str(sigma_fusionada)]);
    else
        disp('Esperando datos del sensor...');
        pause(0.2);
    end
end

% Cerrar conexión 
clear arduino;
disp('Ejecución completada.');

