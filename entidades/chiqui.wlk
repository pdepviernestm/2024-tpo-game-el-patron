import config.pantallas.p_gameOver

object chiqui {
  var position = game.at(-1, game.height())
  const imagen = "chiquiMafia.png"
  const tema = game.sound("chiquiSong.mp3")
  var counter = 0
  var detono = false
  const detonante = 3
  
  method detono() = detono
  
  method detono(bool) {
    detono = bool
  }
  
  method image() = imagen
  
  method position() = position
  
  method incrementar() {
    if (counter < detonante) {
      counter += 1
    }
  }
  
  method spawnear(x) {
    if ((counter >= 3) && (!detono)) {
      detono = true
      game.addVisual(self)
      position = game.at(x, game.height())
      tema.play()
    }
  }
  
  method despawnear() {
    counter = 0
    detono = false
    game.removeVisual(self)
    tema.stop()
  }
  
  method position(newPos) {
    position = newPos
  }
  
  method detonar(player) {
    if (detono) {
      self.position(
        game.at(player.position().x() - 16, self.position().y()).down(4)
      )
      
      if (self.position().y() < player.position().y()) {
        self.despawnear()
        p_gameOver.actual(true)
      }
    }
  }
}