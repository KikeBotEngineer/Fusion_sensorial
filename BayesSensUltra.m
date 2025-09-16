clear; close; clc;
% Configuración de conexión serial
porta = 'COM8'; % Cambia 'COM3' al puerto donde esté conectado tu Arduino
baudrate = 9600; % Asegúrate de que coincida con la velocidad configurada en Arduino
arduino = serialport(porta, baudrate);

% Configuración inicial de creencias
mu_apriori = 2.00;
sigma_apriori = 1.60;
sigma_medicion = 0.2887;
n = 200;

figure;
hold on;

for i = 1:n
    % Esperar hasta que haya datos disponibles
    if arduino.NumBytesAvailable > 0
        % Leer la distancia del sensor desde Arduino
        data = readline(arduino);
%         disp(['Dato recibido: ', data]); % Imprimir el dato recibido para depuración
        
        mu_medicion = str2double(data); % Convertir el dato de texto a número
        
        % Filtrar valores no válidos
         if mu_medicion == -1 || isnan(mu_medicion)   
            %disp('Medición no válida, ignorando esta lectura.');
            continue; % Saltar esta iteración si la lectura no es válida
        end

        % Actualización bayesiana
        mu_posterior=(sigma_apriori^2*mu_medicion+sigma_medicion^2*mu_apriori)/(sigma_apriori^2+sigma_medicion^2);
        sigma_posteriori=sqrt((sigma_apriori^2*sigma_medicion^2)/(sigma_apriori^2+sigma_medicion^2));
        % Graficar distribución posterior en cada iteración
        x = linspace(0, 2, 100);
        P_posteriori = normpdf(x, mu_posterior, sigma_posteriori);
        plot(x, P_posteriori);
        pause(0.5);

        % Mostrar en consola la información de la creencia actualizada
        disp(['Medicion ', num2str(i), ': ', num2str(mu_medicion), ' m']);
        disp(['Creencia Actualizada - media: ', num2str(mu_posterior), ...
              ', Sigma: ', num2str(sigma_posteriori)]);

        % Actualizar creencias
        mu_apriori = mu_posterior;
        sigma_apriori = sigma_posteriori;
    else
        disp('Esperando datos del sensor...');
        pause(0.1); % Pausa breve para evitar iteraciones vacías si no hay datos
    end
end

% Cerrar la conexión serial al finalizar
clear arduino;
