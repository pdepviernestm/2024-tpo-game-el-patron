import config.pantallas.p_gameOver
import config.pantallas.p_Juego
import config.cargar.*
import entidades.base.Entidad

object chiqui inherits Entidad(position = game.at(-1, game.height()), image = "chiquiMafia.png"){
  const tema = game.sound("chiquiSong.mp3")
  var counter = 0
  const detonante = 3
  
  method incrementar() {
    if (counter < detonante) {
      counter += 1
      if (counter >= detonante) {
        const jugador = cargar.jugador(1)
        self.spawnear(jugador)
      }
    }
  }
  
  method spawnear(jugador) {
    game.addVisual(self)
    position = game.at(jugador.position().x() - 16, game.height())
    tema.play()
    game.onTick(1, "Detonar", {
      if(p_Juego.actual()) self.detonar(jugador)
    })
  }
  
  method despawnear() {
    counter = 0
    game.removeVisual(self)
    tema.stop()
    game.removeTickEvent("Detonar")
  }
  
  method detonar(jugador) {
    self.position(
      game.at(jugador.position().x() - 16, self.position().y()).down(4)
    )
    
    if (self.position().y() < jugador.position().y()) {
      self.despawnear()
      p_gameOver.actual(true)
    }
  }
}