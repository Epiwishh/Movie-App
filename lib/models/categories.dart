class Category {
  final String? categorName;

  Category(
    this.categorName,
  );
}

//// Using `categoriesData` with Map. So, we can call category name just like [categories.categoryName]

List<Category> categories = categoriesData
    .map((item) => Category(item['categoryName'] as String))
    .toList();

var categoriesData = [
  {
    "categoryName": "In Theater",
  },
  {
    "categoryName": "Box Office",
  },
  {
    "categoryName": "Coming Soon",
  },
];
