import proyectil.*
import iu.*
// pepita.wlk
class Entidad {
  method soyPepita() = false
  method soyEnemigo() = false
  method soyHitbox() = false
  method soyProyectil() = false
}

class JugadorPrincipal inherits Entidad {
  var imagen = "j1.png"
  var position = game.origin()

  var vidas = 1
  var jugador = 1

  var indicadores = []

  method jugador() = jugador

  method image() = imagen

  method cambiarImagen(img) {
    imagen = img
  }

  method position() = position

  method position(newPos) {
    position = newPos
  }

  method cargarIndicadores() {
    vidas.times({
      x => 
      var indicador = new IndicadorVida()
      if(jugador == 1){
        indicador.position(12*x-9)
        indicador.cambiarImagen("piluso2x.png")
      }
      else if(jugador == 2){
        indicador.position(game.width() - 12*x)
        indicador.cambiarImagen("piluso2xj2_.png")
      }
      indicadores.add(indicador)
      game.addVisual(indicador)
    })

  }

  method setJugador(numero){
    jugador = numero
  }

  method indicadores() = indicadores

  method spawnea(offset) {
    position = game.at(game.width()/2+offset, 12)
  }

  method getVidas() = vidas
  method setVidas(newVidas) {
    vidas = newVidas
  }

  override method soyPepita() = true
}

class Hitbox inherits Entidad{

  var imagen = "j2.png"
  var position = game.origin()

  method position() = position

  method position(newPos) {
    position = newPos
  }
  
  var index = -1

  method valla() = index

  method valla(index_1){
    index = index_1
  }

  method sacarVida(valla){
    valla.setVidas(valla.getVidas()-1) 
  }
  
  override method soyHitbox() = true

  // method soyHitbox(bool){
  //   soyHitbox = bool
  // }

  method image() = imagen
  
  method cambiarImagen(img) {
    imagen = img
  }


}

class Enemigo inherits Entidad {
  var imagen = "enemigo.png"
  var position = game.origin()
  
  method position() = position
  
  method position(newPos) {
    position = newPos
  }
  
  method spawnea(x,y) {
    position = game.at(x,y)
  }
  
  method image() = imagen
  
  method cambiarImagen(img) {
    imagen = img
  }

  override method soyEnemigo() = true
}

class Valla{
  var imagen = "valla192.png"
  var position = game.origin()
  var vidas = 3
  
  method position() = position
  
  method position(newPos) {
    position = newPos
  }
  
  method image() = imagen
  
  method cambiarImagen(img) {
    imagen = img
  }

  method getVidas() = vidas
  method setVidas(newVidas) {
    vidas = newVidas
  }

  method spawnea(x,y) {
    position = game.at(x, y)
  }
}
