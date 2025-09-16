#include <math.h>

const int trigPin = 9;
const int echoPin = 10;

void setup() {
  Serial.begin(9600);
  pinMode(trigPin, OUTPUT);
  pinMode(echoPin, INPUT);
}

void loop() {
  // Obtener distancia del sensor ultrasónico
  float distancia = leerDistancia();

  // Enviar solo valores válidos o -1 si no hay detección
  if (distancia > 0) { 
    Serial.println(distancia);
  } else {
    Serial.println(-1);  // Valor especial para indicar "sin detección"
  }
  
  delay(30); // Frecuencia de muestreo de 30 ms (puedes ajustarla)
}

float leerDistancia() {
  digitalWrite(trigPin, LOW);
  delayMicroseconds(2);
  digitalWrite(trigPin, HIGH);
  delayMicroseconds(10);
  digitalWrite(trigPin, LOW);

  long duracion = pulseIn(echoPin, HIGH, 20000); // Timeout de 20 ms

  // Calcular la distancia en metros si la duración es mayor que cero
  if (duracion > 0) {
    float distancia = (duracion * 0.0343) / 2.0;
    distancia=distancia/100.0;
    return distancia;
  } else {
    return -1; // Valor especial si no se detectó el eco
  }
}
