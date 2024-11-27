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

  method controles() {}
}

object controlesJuego inherits Controles{
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
        
        proyectil.spawnea(jugador.position()) // proyectil.lanzar()
      }
    }
  }
  
  override method controles() {
    // Jugador 1
    keyboard.a().onPressDo({ self._izquierda(1) })
    
    keyboard.d().onPressDo({ self._derecha(1) })
    
    keyboard.space().onPressDo({ self._disparo(1) })

    // Jugador 2
    keyboard.left().onPressDo({ self._izquierda(2) })
    
    keyboard.right().onPressDo({ self._derecha(2) })
    
    keyboard.enter().onPressDo({ if (!wait) self._disparo(2) })
  }
}

object controlesMenu inherits Controles{
  var enControles = false
  
  override method controles() {
    var dir = 1
    game.onTick(
      1000,
      "idleSelector",
      { 
        selector.position(selector.position().right(dir))
        dir *= -1
      }
    )
    
    keyboard.p().onPressDo({ if (p_Juego.actual()) p_Pausa.toggle() })
    
    keyboard.up().onPressDo(
      { if ((!p_Juego.actual()) || p_Pausa.actual()) // selector.position(55,80)
          selector.arriba() }
    )
    keyboard.down().onPressDo(
      { if ((!p_Juego.actual()) || p_Pausa.actual()) // selector.position(55,67)
          selector.abajo() }
    )
    keyboard.enter().onPressDo(
      { if (p_Menu.actual()) {
          controlesJuego.handleWait()
          selector.seleccionar()
          if (selector.seleccion() == 2) {
            enControles = true
            selector.seleccion(0)
            selector.maxOpciones(0)
            fondoOpciones.position(fondoOpciones.position().down(24).left(13))
            opciones.mostrar("o_controles_.png", 1)
            selector.position(fondoOpciones.position().up(4).right(7))
          } else {
            if (enControles) {
              enControles = false
              selector.seleccion(2)
              selector.maxOpciones(2)
              fondoOpciones.position(
                fondoOpciones.position().down(-24).left(-13)
              )
              opciones.mostrar("o_menu__.png", 3)
              selector.position(selector.position().down(16))
            } else {
              cargar.cargarJuego(selector.seleccion() + 1)
            }
          }
        } else {
          if (p_gameOver.actual() || p_youWin.actual()) {
            controlesJuego.handleWait()
            if (selector.seleccion() == 0) {
              cargar.cargarJuego(nivel.cantJugadores())
              p_Menu.playTema()
            } else {
              p_Menu.actual(true)
            }
          } else {
            if (p_Pausa.actual()) {
              controlesJuego.handleWait()
              if (selector.seleccion() == 0) {
                p_Pausa.toggle()
              } else {
                if (selector.seleccion() == 1) {
                  p_Menu.togglePauseTema()
                  cargar.cargarJuego(nivel.cantJugadores())
                } else {
                  p_Menu.togglePauseTema()
                  p_Menu.actual(true)
                }
              }
            }
          }
        } }
    )
  }
}

object misterio inherits Controles {
  override method controles() {
    keyboard.t().onPressDo(
      { if (p_Juego.actual() && (!p_Pausa.actual())) chiqui.incrementar() }
    )
  }
}