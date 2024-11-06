#include <../lib/BMP.hpp>

#define BMP280_ADDRESS 0x76
// Create an instance of BMP280Sensor
float altitude;
float pressure;
float temperature;

void setup() {
    // Start serial communication for output
    Serial.begin(9600);
    delay(1000); // Small delay to allow serial monitor to open

    // Initialize the BMP280 sensor
    if (!bmp.startup()) {
        Serial.println("BMP280 initialization failed!");
        while (1);  // Halt if initialization fails
    } else {
        Serial.println("BMP280 initialized successfully.");
    }
}

void loop() {
    // Read pressure and altitude from the BMP280 sensor
    float pressure = bmp.readPressure();
    float altitude = bmp.readAltitude();
    float temperature = bmp.readTemperature();
    delay(200);
    // Print the pressure and altitude values to Serial Monitor
    Serial.printf("Pressure: ");
    Serial.printf(pressure);
    Serial.printf(" Pa");

    Serial.printf("Altitude: ");
    Serial.printf(altitude);
    Serial.printf(" m");

    Serial.printf("Temperature: ");
    Serial.printf(temperature);
    Serial.printf(" *C");


    // Wait a second between readings
    delay(1000);
}

