class ExpenseCategory {
  final String id;
  final String name;
  final bool isDefault; // To identify if it's a system default or user-added

  ExpenseCategory({
    required this.id,
    required this.name,
    this.isDefault = false,
  });

  // Factory constructor to create an ExpenseCategory from JSON
  factory ExpenseCategory.fromJson(Map<String, dynamic> json) {
    return ExpenseCategory(
      id: json['id'] as String,
      name: json['name'] as String,
      isDefault: json['isDefault'] as bool? ?? false, // Default to false if null
    );
  }

  // Method to convert an ExpenseCategory to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'isDefault': isDefault,
    };
  }
}