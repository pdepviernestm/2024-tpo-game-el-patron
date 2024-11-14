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

object foto_Inicio {
  var position = game.origin()
  var imagen = "menu.png"
  
  method image() = imagen
  
  method position() = position
  
  method position(x, y) {
    position = game.at(x, y)
  }
}

object foto_gameOver {
  var position = game.origin()
  var imagen = "gameover.png"
  
  method image() = imagen
  
  method position() = position
  
  method position(x, y) {
    position = game.at(x, y)
  }
}

object foto_youWin {
  var position = game.origin()
  var imagen = "youwin_.png"
  
  method image() = imagen
  
  method position() = position
  
  method position(x, y) {
    position = game.at(x, y)
  }
}

object seleccionador {
  var position = game.at(55, 48)
  var imagen = "balboa6.png"
  var seleccion = 0
  const elegir = game.sound("lanzar.mp3")
  const entrar = game.sound("hit_valla.mp3")
  
  method reproducir(sonido) {
    sonido.play()
    game.schedule(400, { sonido.stop() })
  }
  
  method image() = imagen
  
  method position() = position
  
  // Para debugear
  //   method text() = "Seleccion: " + seleccion
  //   method textColor() = "000000"
  method seleccion() = seleccion
  
  method abajo() {
    seleccion += 1
    self.position(self.position().down(9))
    self.reproducir(elegir)
  }
  
  method arriba() {
    seleccion -= 1
    self.position(self.position().up(9))
    self.reproducir(elegir)
  }
  
  method seleccionar() {
    self.reproducir(entrar)
  }
  
  method position(newPos) {
    position = newPos
  }
}

class Opciones {
  var position = game.origin()
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

object fondoOpciones {
  var position = game.origin()
  var imagen = "rectangulo.png"
  
  method image() = imagen
  
  method position() = position
  
  method position(x, y) {
    position = game.at(x, y)
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