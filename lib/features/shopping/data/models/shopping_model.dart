import '../../domain/entities/shopping.dart';

class ShoppingModel extends Shopping {
  const ShoppingModel({
    required super.id,
    required super.invoiceNumber,
    required super.providerId,
    super.providerName,
    required super.products,
    required super.total,
    required super.estado,
    super.purchaseDate,
    required super.createdAt,
    super.infoAnulacion,
  });

  factory ShoppingModel.fromJson(Map<String, dynamic> json) {
    String provId = '';
    String? provName;
    
    if (json['providerId'] != null) {
      if (json['providerId'] is Map) {
        provId = json['providerId']['_id'] ?? '';
        provName = json['providerId']['providerName']; 
      } else {
        provId = json['providerId'];
      }
    }

    return ShoppingModel(
      id: json['_id'] ?? '',
      invoiceNumber: json['invoiceNumber'] ?? '',
      providerId: provId,
      providerName: provName,
      
      products: (json['products'] as List? ?? [])
          .map((e) => ShoppingProductModel.fromJson(e))
          .toList(),
      
      total: double.parse((json['total'] ?? 0).toString()),
      estado: json['estado'] ?? 'ACTIVA',
      purchaseDate: json['purchaseDate'],
      
      createdAt: json['createdAt'] != null 
          ? DateTime.parse(json['createdAt']) 
          : DateTime.now(),
          
      infoAnulacion: json['infoAnulacion'] != null
          ? InfoAnulacionModel.fromJson(json['infoAnulacion'])
          : null,
    );
  }
}

class ShoppingProductModel extends ShoppingProduct {
  const ShoppingProductModel({
    required super.productId,
    super.productName,
    required super.quantity,
    required super.purchasePrice,
    required super.salePrice,
    required super.useSuggestedPrice,
  });

  factory ShoppingProductModel.fromJson(Map<String, dynamic> json) {
    String prodId = '';
    String? prodName;
    
    if (json['productId'] != null) {
      if (json['productId'] is Map) {
        prodId = json['productId']['_id'] ?? '';
        prodName = json['productId']['name'];
      } else {
        prodId = json['productId'];
      }
    }

    return ShoppingProductModel(
      productId: prodId,
      productName: prodName,
      quantity: json['quantity'] ?? 0,
      purchasePrice: double.parse((json['purchasePrice'] ?? 0).toString()),
      salePrice: double.parse((json['salePrice'] ?? 0).toString()),
      useSuggestedPrice: json['useSuggestedPrice'] ?? false,
    );
  }
}

class InfoAnulacionModel extends InfoAnulacion {
  const InfoAnulacionModel({super.motivo, super.fechaAnulacion});

  factory InfoAnulacionModel.fromJson(Map<String, dynamic> json) {
    return InfoAnulacionModel(
      motivo: json['motivo'],
      fechaAnulacion: json['fechaAnulacion'] != null
          ? DateTime.parse(json['fechaAnulacion'])
          : null,
    );
  }
}