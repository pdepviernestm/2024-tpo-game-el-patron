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

object seleccionador {
  var position = game.at(55,48)
  var imagen = "balboa6.png"
  var seleccion = 0
  
  method image() = imagen
  
  method position() = position

// Para debugear
//   method text() = "Seleccion: " + seleccion
//   method textColor() = "000000"

  method seleccion() = seleccion

  method abajo(){
    seleccion += 1
    self.position(self.position().down(9))
  }

  method arriba(){
    seleccion -= 1
    self.position(self.position().up(9))
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