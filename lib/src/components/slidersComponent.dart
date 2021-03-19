class SliderComponent {
  String imagePath;
  String title;
  String description;

  SliderComponent(this.imagePath, this.title, this.description);

  SliderComponent.fromJson(Map<String, dynamic> json) {
    imagePath = json['imagePath'];
    title = json['title'];
    description = json['description'];
  }
}