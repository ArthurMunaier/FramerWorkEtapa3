class Pedido {
  int? id;
  String cliente;
  String prato;
  int quantidade;
  double valorUnitario;
  double total;
  String status;

  Pedido({
    this.id,
    required this.cliente,
    required this.prato,
    required this.quantidade,
    required this.valorUnitario,
    required this.total,
    required this.status,
  });

  String get classificacao {
    if (quantidade >= 5) {
      return 'PEDIDO GRANDE';
    } else {
      return 'PEDIDO NORMAL';
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'cliente': cliente,
      'prato': prato,
      'quantidade': quantidade,
      'valorUnitario': valorUnitario,
      'total': total,
      'status': status,
    };
  }

  factory Pedido.fromMap(Map<String, dynamic> map) {
    return Pedido(
      id: map['id'],
      cliente: map['cliente'],
      prato: map['prato'],
      quantidade: map['quantidade'],
      valorUnitario: map['valorUnitario'],
      total: map['total'],
      status: map['status'],
    );
  }
}
