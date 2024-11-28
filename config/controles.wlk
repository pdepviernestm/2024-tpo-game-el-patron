import wollok.game.*
import config.cargar.*
import config.pantallas.*
import entidades.chiqui.*
import iu.*
import nivel.*

class Controles {
  method cargar() {
    self.controles()
  }
  
  method controles() {
    
  }
}

object controlesJuego inherits Controles {
  /* Variable para evitar que el segundo jugador dispare al elegir una opcion*/
  var wait = false
  
  method handleWait() {
    wait = true
    game.schedule(1, { wait = false })
  }
  
  method _derecha(j) {
    if ((j <= cargar.jugadores().size()) && (!p_Pausa.actual())) {
      const jugador = cargar.jugador(j)
      if (jugador.position().x() < (game.width() - 12)) jugador.position(
          jugador.position().right(4)
        )
    }
  }
  
  method _izquierda(j) {
    if ((j <= cargar.jugadores().size()) && (!p_Pausa.actual())) {
      const jugador = cargar.jugador(j)
      if (jugador.position().x() > 8) jugador.position(
          jugador.position().left(4)
        )
    }
  }
  
  method _disparo(j) {
    if (((j <= cargar.jugadores().size()) && p_Juego.actual()) && (!p_Pausa.actual())) {
      const jugador = cargar.jugador(j)
      const proyectil = cargar.proyectil(j)
      if (proyectil.yaColisiono() && (!jugador.muerto())) {
        proyectil.yaColisiono(false)
        
        jugador.image(("j" + j) + "_tirar.png")
        game.schedule(250, { jugador.image(("j" + j) + ".png") })
        
        proyectil.spawnea(jugador.position())
      }
    }
  }
  
  override method controles() {
    /* Jugador 1 */
    
    keyboard.a().onPressDo({ self._izquierda(1) })
    
    keyboard.d().onPressDo({ self._derecha(1) })
    
    keyboard.space().onPressDo({ self._disparo(1) }) 
    
    /* Jugador 2*/
    
    keyboard.left().onPressDo({ self._izquierda(2) })
    
    keyboard.right().onPressDo({ self._derecha(2) })
    
    keyboard.enter().onPressDo({ if (!wait) self._disparo(2) })
  }
}

object controlesMenu inherits Controles {
  override method controles() {
    keyboard.p().onPressDo({ if (p_Juego.actual()) p_Pausa.toggle() })
    
    keyboard.up().onPressDo(
      { if ((!p_Juego.actual()) || p_Pausa.actual())
          selector.arriba() }
    )
    keyboard.down().onPressDo(
      { if ((!p_Juego.actual()) || p_Pausa.actual())
          selector.abajo() }
    )
    keyboard.enter().onPressDo({ pantalla.actual().seleccionar() })
  }
}

object misterio inherits Controles {
  override method controles() {
    keyboard.t().onPressDo(
      { if (p_Juego.actual() && (!p_Pausa.actual())) chiqui.incrementar() }
    )
  }
}