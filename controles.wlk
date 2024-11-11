import wollok.game.*
import nivel.*
import pantallas.*
import iu.*

object controles {
  const proyectiles = nivel.proyectiles()
  const jugadores = nivel.jugadores()
  var enMenu = true
  
  method cargarControles() {
    self.controlesMenu()
  }
  
  method cargarControlesJuego() {
    self.controlesj1()
    self.controlesj2()
  }
  
  method _derecha(j) {
    if (j <= nivel.jugadores().size()) {
      const jugador = jugadores.get(j - 1)
      if (jugador.position().x() < (game.width() - 12)) jugador.position(
          jugador.position().right(4)
        )
    }
  }
  
  method _izquierda(j) {
    if (j <= nivel.jugadores().size()) {
      const jugador = jugadores.get(j - 1)
      if (jugador.position().x() > 8) jugador.position(
          jugador.position().left(4)
        )
    }
  }
  
  method _disparo(j) {
    if (j <= nivel.jugadores().size()) {
      const jugador = jugadores.get(j - 1)
      const proyectil = proyectiles.get(j - 1)
      if (nivel.checkYaColisiono(j) && (!nivel.checkMuerto(j))) {
        nivel.setYaColisiono(j, false)
        
        jugador.cambiarImagen(("j" + j) + "_tirar.png")
        game.schedule(250, { jugador.cambiarImagen(("j" + j) + ".png") })
        
        game.addVisual(proyectil)
        proyectil.spawnea(jugador.position()) // proyectil.lanzar()
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
  
  method controlesMenu() {
    keyboard.up().onPressDo(
      { if ((((!pantallas.juegoIniciado()) && (seleccionador.seleccion() > 0)) && (!pantallas.enControles())) && pantallas.estadoJuego())
          // seleccionador.position(55,80)
          seleccionador.arriba() }
    )
    keyboard.down().onPressDo(
      { if ((((!pantallas.juegoIniciado()) && (seleccionador.seleccion() < 2)) && (!pantallas.enControles())) && pantallas.estadoJuego())
          // seleccionador.position(55,67)
          seleccionador.abajo() }
    )
    keyboard.enter().onPressDo(
      { if ((!pantallas.juegoIniciado()) && pantallas.estadoJuego()) {
          if (pantallas.enControles()) {
            pantallas.opciones().cambiarImagen("opciones2.png")
            pantallas.setEnControles(false)
          } else {
            if (seleccionador.seleccion() == 0) {
              nivel.setJugadores(1)
              pantallas.setJuegoPorArrancar(true)
            } else {
              if (seleccionador.seleccion() == 1) {
                nivel.setJugadores(2)
                // nivel.setProyectiles(jugadores.size())
                pantallas.setJuegoPorArrancar(true)
              } else {
                pantallas.setEnControles(true)
                pantallas.opciones().cambiarImagen("controles2.png")
              }
            }
          }
          if (pantallas.juegoPorArrancar()) {
            pantallas.setJuegoPorArrancar(false)
            game.removeVisual(pantallas.opciones())
            game.removeVisual(seleccionador)
            game.removeVisual(foto_Inicio)
            pantallas.setJuegoIniciado(true)
            self.cargarControlesJuego()
            nivel.start()
          }
        } }
    )
  }
}