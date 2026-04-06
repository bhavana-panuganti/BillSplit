List<Map<String, dynamic>> users = [
  
  
];
List<Map<String, dynamic>> groups = [];

List<Map<String, dynamic>> allExpenses = [];
String getName(String id) {
  return users.firstWhere(
    (u) => u["id"] == id,
    orElse: () => {"name": "Unknown"},
  )["name"];
}