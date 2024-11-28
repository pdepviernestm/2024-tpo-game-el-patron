import iu.*
import config.cargar.*
import config.controles.controlesJuego

object pantalla {
  var property actual = p_Menu
}

class Pantalla {
  const property image = void
  const property tema = void
  const property position = game.origin()
  var property actual = false
  
  method actual(bool) {
    actual = bool
    if (actual) {
      pantalla.actual(self)
      self.mostrar()
    } else {
      self.ocultar()
    }
  }
  
  method mostrar() {
    game.addVisual(self)
    self.playTema()
  }
  
  method ocultar() {
    if (game.hasVisual(self)) game.removeVisual(self)
    opciones.ocultar()
  }
  
  method stopTema() = tema.stop()
  
  method playTema() {
    if (!tema.played()) tema.play()
    tema.volume(0.5)
    self.playExtra()
  }
  
  method playExtra() {
    
  }
}

object p_Menu inherits Pantalla (
  image = "menu_.png",
  tema = game.sound("main_loop.mp3")
) {
  var enControles = false
  
  override method mostrar() {
    super()
    p_gameOver.actual(false)
    p_youWin.actual(false)
    p_Pausa.actual(false)
    p_Juego.actual(false)
    
    selector.seleccion(0)
    selector.maxOpciones(2)
    opciones.mostrar("o_menu__.png", 3)
  }
  
  method togglePauseTema() {
    if (tema.paused()) tema.resume() else tema.pause()
  }
  
  method seleccionar() {
    controlesJuego.handleWait()
    selector.seleccionar()
    if (selector.seleccion() == 2) {
      enControles = true
      selector.seleccion(0)
      selector.maxOpciones(0)
      opciones.mostrar("o_controles_.png", 1)
      fondoOpciones.position(fondoOpciones.position().down(24).left(13))
      selector.position(fondoOpciones.position().up(4).right(7))
    } else {
      if (enControles) {
        enControles = false
        selector.seleccion(2)
        selector.maxOpciones(2)
        fondoOpciones.position(fondoOpciones.position().down(-24).left(-13))
        opciones.mostrar("o_menu__.png", 3)
        selector.position(selector.position().down(16))
      } else {
        cargar.cargarJuego(selector.seleccion() + 1)
      }
    }
  }
  
  override method playExtra() {
    tema.shouldLoop(true)
  }
}

object p_gameOver inherits Pantalla (
  image = "gameover.png",
  tema = game.sound("game_over.mp3")
) {
  override method mostrar() {
    super()
    if (p_Pausa.actual()) p_Menu.togglePauseTema()
    p_Menu.stopTema()
    p_Pausa.actual(false)
    p_Juego.actual(false)
    
    opciones.mostrar("o_reintentar_.png", 2)
    selector.position(selector.position().down(8).right(0))
    
    selector.seleccion(0)
    selector.maxOpciones(1)
  }
  
  override method playExtra() {
    game.schedule(4000, { tema.stop() })
  }
}

object p_youWin inherits Pantalla (
  image = "youwin_.png",
  tema = game.sound("victory.mp3")
) {
  override method mostrar() {
    super()
    p_Juego.actual(false)
    p_Menu.stopTema()
    
    opciones.mostrar("o_reintentar_.png", 2)
    selector.position(selector.position().down(8).right(0))
    
    selector.seleccion(0)
    selector.maxOpciones(1)
  }
  
  override method ocultar() {
    super()
    if (tema.played()) tema.stop()
  }
}

object p_Juego inherits Pantalla {
  override method mostrar() {
    const jugadores = cargar.jugadores()
    jugadores.forEach({ j => cargar.proyectil(j.jugador()).destruir() })
    cargar.proyectil(0).destruir()
    
    p_Menu.actual(false)
    p_gameOver.actual(false)
    p_youWin.actual(false)
    p_Pausa.actual(false)
    opciones.ocultar()
  }
  
  override method ocultar() {
    
  }
}

object p_Pausa inherits Pantalla (
  image = "pausa.png",
  tema = game.sound("pausa.mp3")
) {
  var wait = true // Variable para no spamear la pausa
  
  override method mostrar() {
    game.addVisual(self)
    opciones.mostrar("o_pausa_.png", 3)
    selector.seleccion(0)
    selector.maxOpciones(2)
  }
  
  method toggle() {
    if (wait) {
      wait = false
      p_Menu.togglePauseTema()
      self.actual(!actual)
      tema.play()
      game.schedule(2000, {   tema.stop() wait = true})
    }
  }
}