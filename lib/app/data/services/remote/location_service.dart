class LocationService {
  Future<Map<String, dynamic>> getLocations() async {
    // Aqui se deberia simular el llamado al api de locations, se deja un json qumado
    return {
      "Colombia": {
        "Antioquia": ["Medellín", "Envigado", "Bello"],
        "Cundinamarca": ["Bogotá", "Soacha", "Zipaquirá"],
        "Valle del Cauca": ["Cali", "Palmira", "Buenaventura"],
      },
      "Argentina": {
        "Buenos Aires": ["La Plata", "Mar del Plata", "Bahía Blanca"],
        "Córdoba": ["Córdoba", "Villa Carlos Paz", "Río Cuarto"],
        "Santa Fe": ["Rosario", "Santa Fe", "Rafaela"],
      },
      "México": {
        "Jalisco": ["Guadalajara", "Puerto Vallarta", "Tlaquepaque"],
        "Nuevo León": ["Monterrey", "San Nicolás de los Garza", "Guadalupe"],
        "Ciudad de México": ["Benito Juárez", "Iztapalapa", "Coyoacán"],
      },
      "Ecuador": {
        "Pichincha": ["Quito", "Cayambe", "Machachi"],
        "Guayas": ["Guayaquil", "Daule", "Samborondón"],
        "Azuay": ["Cuenca", "Gualaceo", "Paute"],
      },
    };
  }
}
