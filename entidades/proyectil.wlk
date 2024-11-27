import entidades.base.*

class Proyectil inherits Entidad {
  var property image = "balboa0.png"
  var property step = 4
  var property yaColisiono = true
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
  
  method spawnea(newPos) {
    yaColisiono = false
    game.addVisual(self)
    position = newPos
    self.reproducir()
  }
  
  method lanzar() {
    self.position(self.position().up(step))
  }

  method image(img) {
    image = "balboa".concat(img).concat(".png")
  }
  
  // Evita que el proyectil siga actuando de manera invisible
  method destruir() {
    self.yaColisiono(true)
    game.removeVisual(self)
    self.position(game.at(-1, game.height()))
  }
  
  override method soyProyectil() = true
}