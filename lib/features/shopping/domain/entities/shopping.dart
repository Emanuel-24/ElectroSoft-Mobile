// --- Entidad Principal de Compra ---
class Shopping {
  final String id;
  final String invoiceNumber;
  final String providerId;
  final String? providerName;
  final List<ShoppingProduct> products;
  final double total;
  final String estado;
  final String? purchaseDate;
  final DateTime createdAt;
  final InfoAnulacion? infoAnulacion;

  const Shopping({
    required this.id,
    required this.invoiceNumber,
    required this.providerId,
    this.providerName,
    required this.products,
    required this.total,
    required this.estado,
    this.purchaseDate,
    required this.createdAt,
    this.infoAnulacion,
  });

  bool get isAnulada => estado == 'ANULADA';
}

class ShoppingProduct {
  final String productId;
  final String? productName;
  final int quantity;
  final double purchasePrice;
  final double salePrice;
  final bool useSuggestedPrice;

  const ShoppingProduct({
    required this.productId,
    this.productName,
    required this.quantity,
    required this.purchasePrice,
    required this.salePrice,
    required this.useSuggestedPrice,
  });
}

class InfoAnulacion {
  final String? motivo;
  final DateTime? fechaAnulacion;

  const InfoAnulacion({
    this.motivo,
    this.fechaAnulacion,
  });
}