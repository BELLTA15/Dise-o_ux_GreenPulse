import 'package:shelf_router/shelf_router.dart';

import '../controllers/ajustes_controller.dart';

Router buildAjustesRoutes() {
  final router = Router()
    ..get('/', obtenerAjustes)
    ..put('/', actualizarAjustes)
    ..patch('/', actualizarAjustes);

  return router;
}
