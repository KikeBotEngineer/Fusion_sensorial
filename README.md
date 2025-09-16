# Static sensory fusion
This repository presents a project on static sensor fusion to improve distance measurement by combining two ultrasonic sensors. The implementation is carried out using MATLAB and an Arduino Uno board, with the goal of correcting and optimizing the individual readings from each sensor.
The Arduino code is designed for connecting two HC-SR04 ultrasonic sensors to the Arduino UNO board, which communicates with MATLAB through serial communication.
The script Fusion2UltraSensReal.m requires knowledge of the standard deviations of sensors 1 and 2, which are calculated using the files DistSerial.ino and BayesSensUltra.m (also included).
The static sensor fusion process is carried out with the files MedirDist2Sens.ino and Fusion2UltraSensReal.m.
