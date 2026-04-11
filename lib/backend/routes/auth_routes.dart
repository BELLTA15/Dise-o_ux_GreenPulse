import 'package:shelf_router/shelf_router.dart';

import '../controllers/auth_controller.dart';

Router buildAuthRoutes() {
  final router = Router();

  router.post('/registro', registroUsuario);
  router.post('/login', loginUsuario);
  router.post('/refresh', refreshToken);

  return router;
}

Router buildAuthProtectedRoutes() {
  final router = Router();

  router.get('/perfil', obtenerPerfil);
  router.put('/perfil', actualizarPerfil);
  router.patch('/contrasena', cambiarContrasena);

  return router;
}
