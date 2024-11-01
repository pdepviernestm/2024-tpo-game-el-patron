object pepita {
  var position = game.origin()
  var imagen = "barra.png"
  
  method position() = position
  
  method position(newPos) {
    position = newPos
  }
  
  method spawnea() {
    const x = (game.width() / 2) - 5
    const y = 5
    position = game.at(x, y)
  }
  
  method image() = imagen
  
  method cambiarImagen(img) {
    imagen = img
  }
}


class Proyectil {
  var imagen = "balboa0.png"
  var position = game.origin()
  
  method position() = position
  
  method position(newPos) {
    position = newPos
  }
  
  method spawnea() {
    position = pepita.position()
  }
  
  method lanzar() {
    self.position(self.position().up(4))
  }
  
  method image() = imagen
  
  method cambiarImagen(img) {
    imagen = "balboa".concat(img).concat(".png")
  }
}