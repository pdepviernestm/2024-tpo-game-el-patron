class IndicadorVida {
  var position = game.origin()
  var imagen = "piluso2x.png"
  
  method image() = imagen
  
  method cambiarImagen(img) {
    imagen = img
  }
  
  method position() = position
  
  method position(x) {
    position = game.at(x, 2)
  }
}

class IndicadorVidaJ2 inherits IndicadorVida {
  override method image() = "piluso2xj2_.png"
  
  override method position(x) {
    position = game.at(game.width() - x, 2)
  }
}



object selector {
  var position = game.at(opciones.position().x()-10, opciones.position().y()+18)
  var imagen = "balboa6.png"
  var seleccion = 0
  var maxOpciones = 2
  const elegir = game.sound("lanzar.mp3")
  const entrar = game.sound("hit_valla.mp3")
  
  method reproducir(sonido) {
    // if (!sonido.played()) {
      sonido.play()
      game.schedule(400, { sonido.stop() })
    // }
  }
  
  method image() = imagen
  
  method position() = position

  method position(newPos) {
    position = newPos
  }

  method actualizarPos(){
    position = game.at(opciones.position().x()-10, opciones.position().y()+18)
  }

  method seleccion() = seleccion
  method seleccion(s){
    seleccion = s
  }
  
  method setMaxOpciones(max) {
    maxOpciones = max
  }

  method abajo() {
    if (seleccion < maxOpciones) {
      seleccion += 1
      self.position(self.position().down(9))
      self.reproducir(elegir)
    }
  }
  
  method arriba() {
    if (seleccion > 0) {
      seleccion -= 1
      self.position(self.position().up(9))
      self.reproducir(elegir)
    }
  }
  
  method seleccionar() {
    self.reproducir(entrar)
  }
  
}

object opciones {
  var position = game.at(65, 30)
  var imagen = "opciones2.png"
  
  method image() = imagen
  
  method position() = position
  
  method position(x, y) {
    position = game.at(x, y)
  }
  
  method cambiarImagen(img) {
    imagen = img
  }
}

object chiquiTapia {
  var position = game.origin()
  var imagen = "chiquiMafia.png"
  
  method image() = imagen
  
  method position() = position
  
  method spawnear(x, y) {
    position = game.at(x, y)
  }
  
  method position(newPos) {
    position = newPos
  }
  
  method detonar() {
    self.position(self.position().down(4))
  }
}