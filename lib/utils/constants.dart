// Server configuration
const String THING_API_URL = "http://localhost:3001/api/v1/";  // Base API URL

// Supported device types [{"type": "api_id", "name": "display_text"}]
final sensorTypes = [
  {"type": "temperature_sensor", "name": "Temp Sensor"},
  {"type": "my_thing", "name": "Smart Home"},
];
