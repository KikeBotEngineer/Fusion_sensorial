#define TRIGGER1 2 // Pin Trigger del Sensor 1
#define ECHO1 3    // Pin Echo del Sensor 1
#define TRIGGER2 4 // Pin Trigger del Sensor 2
#define ECHO2 5    // Pin Echo del Sensor 2

void setup() {
  pinMode(TRIGGER1, OUTPUT);
  pinMode(ECHO1, INPUT);
  pinMode(TRIGGER2, OUTPUT);
  pinMode(ECHO2, INPUT);
  Serial.begin(9600);
}

void loop() {
  // Medir distancia del Sensor 1
  long duration1 = medirDistancia(TRIGGER1, ECHO1);
  int distancia1 = calcularCM(duration1);

  // Medir distancia del Sensor 2
  long duration2 = medirDistancia(TRIGGER2, ECHO2);
  int distancia2 = calcularCM(duration2);

  // Validar y enviar datos
  if (distancia1 > 0 && distancia2 > 0) {
    Serial.print(distancia1);
    Serial.print(",");
    Serial.println(distancia2);
  } else {
    Serial.println("-1,-1"); // Valores no válidos
  }

  delay(100); // Pausa de 100 ms entre lecturas
}

long medirDistancia(int triggerPin, int echoPin) {
  // Generar pulso en Trigger
  digitalWrite(triggerPin, LOW);
  delayMicroseconds(2);
  digitalWrite(triggerPin, HIGH);
  delayMicroseconds(10);
  digitalWrite(triggerPin, LOW);

  // Leer duración del pulso en Echo
  return pulseIn(echoPin, HIGH, 30000); // 30 ms timeout
}

int calcularCM(long duration) {
  // Convertir duración en distancia en cm
  return duration * 0.034 / 2; //
}
