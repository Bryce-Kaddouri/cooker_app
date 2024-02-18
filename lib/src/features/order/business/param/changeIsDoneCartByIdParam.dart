class ChangeIsDoneCartByIdParam {
  final DateTime date;
  final int orderId;
  final int cartId;
  final int productId;
  final bool isDone;

  ChangeIsDoneCartByIdParam({
    required this.date,
    required this.orderId,
    required this.cartId,
    required this.productId,
    required this.isDone,
  });
}
