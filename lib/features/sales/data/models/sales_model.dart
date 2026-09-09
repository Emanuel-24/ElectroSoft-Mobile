import '../../domain/entities/sale.dart';

class SaleModel extends Sale {
  const SaleModel({
    required super.id,
    required super.numeroFactura,
    required super.clienteId,
    super.clienteName,
    super.clienteTipoDocumento,
    super.clienteDocumento,
    required super.productos,
    required super.total,
    required super.estado,
    super.fechaVenta,
    required super.fechaCreacion,
    super.infoAnulacion,
  });

  factory SaleModel.fromJson(Map<String, dynamic> json) {
    String clientId = '';
    String? clientName;
    String? clientDocumentType;
    String? clientDocument;

    if (json['clienteId'] != null) {
      if (json['clienteId'] is Map) {
        final client = json['clienteId'] as Map;
        clientId = client['_id']?.toString() ?? '';
        final firstName = client['firstName'] ?? '';
        final lastName = client['lastName'] ?? '';
        clientName = '$firstName $lastName'.trim();
        clientDocument = client['documentNumber']?.toString();

        final documentType = client['documentType'];
        if (documentType is Map) {
          clientDocumentType =
              (documentType['abbreviation'] ?? documentType['name'])
                  ?.toString();
        } else {
          clientDocumentType = documentType?.toString();
        }
      } else {
        clientId = json['clienteId'].toString();
      }
    }

    return SaleModel(
      id: json['_id'] ?? '',
      numeroFactura: json['numeroFactura'] ?? '',
      clienteId: clientId,
      clienteName: clientName,
      clienteTipoDocumento: clientDocumentType,
      clienteDocumento: clientDocument,
      productos: (json['productos'] as List? ?? [])
          .map((e) => SaleProductModel.fromJson(e))
          .toList(),
      total: double.parse((json['total'] ?? 0).toString()),
      estado: json['estado'] ?? 'Vigente',
      fechaVenta: json['fechaVenta'],
      fechaCreacion: json['fechaCreacion'] != null
          ? DateTime.parse(json['fechaCreacion'])
          : DateTime.now(),
      infoAnulacion: json['infoAnulacion'] != null
          ? InfoAnulacionModel.fromJson(json['infoAnulacion'])
          : null,
    );
  }
}

class SaleProductModel extends SaleProduct {
  const SaleProductModel({
    required super.productoId,
    super.productName,
    required super.quantity,
    required super.precioUnitario,
  });

  factory SaleProductModel.fromJson(Map<String, dynamic> json) {
    String prodId = '';
    String? prodName;

    if (json['productoId'] != null) {
      if (json['productoId'] is Map) {
        prodId = json['productoId']['_id'] ?? '';
        prodName = json['productoId']['name'];
      } else {
        prodId = json['productoId'];
      }
    }

    return SaleProductModel(
      productoId: prodId,
      productName: prodName,
      quantity: json['cantidad'] ?? 0,
      precioUnitario: double.parse((json['precioUnitario'] ?? 0).toString()),
    );
  }
}

class SaleDevolutionModel {
  final String id;
  final String saleId;
  final List<SaleDevolutionProduct> productos;
  final String estadoResolucion;
  final String fechaDevolucion;
  final bool anulada;

  const SaleDevolutionModel({
    required this.id,
    required this.saleId,
    required this.productos,
    required this.estadoResolucion,
    required this.fechaDevolucion,
    required this.anulada,
  });

  factory SaleDevolutionModel.fromJson(Map<String, dynamic> json) {
    return SaleDevolutionModel(
      id: json['_id'] ?? '',
      saleId: json['saleId'] ?? '',
      productos: (json['productos'] as List? ?? [])
          .map((p) => SaleDevolutionProduct.fromJson(p))
          .toList(),
      estadoResolucion: json['estadoResolucion'] ?? 'CREADA',
      fechaDevolucion: json['fechaDevolucion'] ?? '',
      anulada: json['anulada'] == true,
    );
  }
}

class SaleDevolutionProduct {
  final String productoId;
  final String nombre;
  final int cantidad;
  final String motivo;
  final String descripcion;
  final String condicionProducto;
  final String gestion;

  const SaleDevolutionProduct({
    required this.productoId,
    required this.nombre,
    required this.cantidad,
    required this.motivo,
    required this.descripcion,
    required this.condicionProducto,
    required this.gestion,
  });

  factory SaleDevolutionProduct.fromJson(Map<String, dynamic> json) {
    return SaleDevolutionProduct(
      productoId: json['productoId']?.toString() ?? '',
      nombre: json['nombre'] ?? 'Producto',
      cantidad: int.tryParse((json['cantidad'] ?? 0).toString()) ?? 0,
      motivo: json['motivo'] ?? '',
      descripcion: json['descripcion'] ?? '',
      condicionProducto: json['condicionProducto'] ?? '',
      gestion: json['gestion'] ?? '',
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
