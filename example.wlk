import proyectil.*
// pepita.wlk
object pepita {
  var position = game.origin()
  var imagen = "barra.png"
  var vidas = 3
  
  method position() = position
  
  method position(newPos) {
    position = newPos
  }
  
  method spawnea() {
    const x = (game.width() / 2)
    const y = 4
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
  var imagen = "barra_enemig.png"
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