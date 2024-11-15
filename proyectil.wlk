import entidades.*

class Proyectil inherits Entidad {
  var imagen = "balboa0.png"
  var position = game.at(-1, -1)
  var i_rotacion = 0
  var step = 4
  const sonido = game.sound("lanzar.mp3")
  
  override method hitSound() = game.sound("hit_botella.mp3")
  
  method reproducir() {
    sonido.play()
    game.schedule(500, { sonido.stop() })
  }
  
  method position() = position
  
  method position(newPos) {
    position = newPos
  }
  
  method spawnea(x) {
    position = x
  }
  
  method step() = step
  
  method step(nuevo) {
    step = nuevo
  }
  
  method lanzar() {
    self.position(self.position().up(step))
  }
  
  method image() = imagen
  
  method cambiarImagen(img) {
    imagen = "balboa".concat(img).concat(".png")
  }
  
  // Evita que el proyectil siga actuando de manera invisible
  method destruir() {
    game.removeVisual(self)
    self.position(game.at(-1, game.height()))
  }
  
  override method soyProyectil() = true
}

class ProyectilEnemigo inherits Proyectil {
  override method lanzar() {
    self.position(self.position().down(4))
  }
}