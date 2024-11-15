import wollok.game.*
import nivel.*
import pantallas.*
import iu.*

object controles {
 
  method cargarControlesJuego() {
    self.controlesj1()
    self.controlesj2()
  }
  
  method _derecha(j) {
    if (j <= nivel.jugadores().size()) {
      const jugador = nivel.jugador(j)
      if (jugador.position().x() < (game.width() - 12)) jugador.position(
          jugador.position().right(4)
        )
    }
  }
  
  method _izquierda(j) {
    if (j <= nivel.jugadores().size()) {
      const jugador = nivel.jugador(j)
      if (jugador.position().x() > 8) jugador.position(
          jugador.position().left(4)
        )
    }
  }
  
  method _disparo(j) {
    if (j <= nivel.jugadores().size()) {
      const jugador = nivel.jugador(j)
      const proyectil = nivel.proyectil(j)
      if (nivel.checkYaColisiono(j) && (!nivel.checkMuerto(j))) {
        nivel.setYaColisiono(j, false)
        
        jugador.cambiarImagen(("j" + j) + "_tirar.png")
        game.schedule(250, { jugador.cambiarImagen(("j" + j) + ".png") })
        
        game.addVisual(proyectil)
        proyectil.spawnea(jugador.position()) // proyectil.lanzar()
        proyectil.reproducir()
      }
    }
  }
  
  method controlesj1() {
    keyboard.a().onPressDo({ self._izquierda(1) })
    
    keyboard.d().onPressDo({ self._derecha(1) })
    
    keyboard.space().onPressDo({ self._disparo(1) })
  }
  
  method controlesj2() {
    keyboard.left().onPressDo({ self._izquierda(2) })
    
    keyboard.right().onPressDo({ self._derecha(2) })
    
    keyboard.enter().onPressDo({ self._disparo(2) })
  }
  
}