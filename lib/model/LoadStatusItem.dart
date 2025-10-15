class LoadStatusItem {
  String productId;
  int orderedQuantity;
  int loadedQuantity;
  int remainingQuantity;
  String status;

  LoadStatusItem({
    required this.productId,
    required this.orderedQuantity,
    required this.loadedQuantity,
    required this.remainingQuantity,
    required this.status,
  });

  factory LoadStatusItem.fromJson(Map<String, dynamic> json) {
    return LoadStatusItem(
      productId: json['productId'],
      orderedQuantity: json['orderedQuantity'],
      loadedQuantity: json['loadedQuantity'],
      remainingQuantity: json['remainingQuantity'],
      status: json['status'],
    );
  }
}
