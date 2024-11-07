import proyectil.*
// pepita.wlk
class JugadorPrincipal {
  var position = game.origin()
  var imagen = "j1.png"
  var vidas = 3

  method position() = position
  
  method position(newPos) {
    position = newPos
  }
  
  method spawnea() {
    const x = (game.width() / 2)
    const y = 12
    position = game.at(x, y)
  }
  
  method image() = imagen
  
  method cambiarImagen(img) {
    imagen = img
  }

  method getVidas() = vidas
  method setVidas(newVidas) {
    vidas = newVidas
  }

  method soyPepita() = true

  method soyEnemigo() = false
}


class Enemigo {
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

  method soyPepita() = false

  method soyEnemigo() = true
}

class Valla{
  var imagen = "valla192.png"
  var position = game.origin()
  const x
  const y
  method position() = position
  
  method position(newPos) {
    position = newPos
  }
  
  method image() = imagen
  
  method cambiarImagen(img) {
    imagen = img
  }

  method soyPepita() = true

  method soyEnemigo() = false

  method spawnea() {
    position = game.at(x, y)
  }
}
