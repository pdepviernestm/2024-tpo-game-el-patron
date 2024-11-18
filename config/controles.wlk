import wollok.game.*
import config.cargar.*
import config.pantallas.*
import iu.*
import nivel.*

object controles {
  method cargarControlesJuego() {
    self.controlesj1()
    self.controlesj2()
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
    if ((j <= cargar.jugadores().size()) && p_Juego.actual()) {
      const jugador = cargar.jugador(j)
      const proyectil = cargar.proyectil(j) // console.println(proyectil)
      if (proyectil.yaColisiono() && (!jugador.muerto())) {
        proyectil.yaColisiono(false)
        
        jugador.cambiarImagen(("j" + j) + "_tirar.png")
        game.schedule(250, { jugador.cambiarImagen(("j" + j) + ".png") })
        
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
}

object controlesMenu {
  var enControles = false
  
  method enControles() = enControles
  
  method setEnControles(bool) {
    enControles = bool
  }

  method cargar() {
    self.controles()
  }

  method controles() {
    var dir = 1
    game.onTick(
      1000,
      "idleSelector",
      { 
        selector.position(selector.position().left(2 * dir))
        dir *= -1
      }
    )

    keyboard.p().onPressDo({
      if(p_Juego.actual()){
        p_Pausa.toggle()
      }
    })

    keyboard.up().onPressDo(
      { if (!p_Juego.actual()) // selector.position(55,80)
          selector.arriba() }
    )
    keyboard.down().onPressDo(
      { if (!p_Juego.actual()) // selector.position(55,67)
          selector.abajo() }
    )
    keyboard.enter().onPressDo(
      { if (p_Menu.actual()) {
          selector.seleccionar()
          if (selector.seleccion() == 2){
            enControles = true
            selector.seleccion(0)
            selector.setMaxOpciones(0)
            opciones.cambiarImagen("controles2.png")
          }
          else if (enControles){
            enControles = false
            selector.seleccion(2)
            selector.setMaxOpciones(2)
            opciones.cambiarImagen("opciones2.png")
          }
          else {
            cargar.cargarJuego(selector.seleccion()+1)
          }
        }
        else if (p_gameOver.actual() || p_youWin.actual()){
          if (selector.seleccion() == 0){
            // console.println(nivel.jugadores().size())
            // nivel.restart()
            cargar.cargarJuego(nivel.cantJugadores())
            p_Menu.playTema()
            
          } else {
            game.stop()
          }
        } }
    )
  }
}