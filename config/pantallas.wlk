import iu.*
import config.cargar.*

object p_Menu {
  var actual = false
  const tema = game.sound("main_loop.mp3")
  
  method actual() = actual
  
  method actual(bool) {
    actual = bool
    if (actual) {
      p_gameOver.actual(false)
      p_youWin.actual(false)
      p_Pausa.actual(false)
      p_Juego.actual(false)
      self.playTema()
      game.addVisual(self)
      
      selector.seleccion(0)
      selector.setMaxOpciones(2)
      opciones.mostrar("o_menu__.png", 3)
    } else {
      if (game.hasVisual(self)) game.removeVisual(self)
      opciones.ocultar()
    }
  }
  
  method image() = "menu_.png"
  
  method position() = game.origin()
  
  method tema() = tema
  
  method playTema() {
    console.println(1)
    tema.shouldLoop(true)
    console.println(2)
    tema.volume(0.5)
    console.println(3)
    if(!tema.played()) tema.play()
    console.println(4)
  }
  
  method stopTema() = tema.stop()
  
  method togglePauseTema() {
    if (tema.paused()) tema.resume() else tema.pause()
  }
}

object p_gameOver {
  var actual = false
  const tema = game.sound("game_over.mp3")
  
  method actual() = actual
  
  method actual(bool) {
    actual = bool
    if (actual) {
      // Eliminar proyectiles en pantalla
      // const jugadores = cargar.jugadores()
      // jugadores.forEach({ j => cargar.proyectil(j.jugador()).destruir() })
      // cargar.proyectil(0).destruir()
      
      if (p_Pausa.actual()) p_Menu.togglePauseTema()
      p_Menu.stopTema()
      p_Pausa.actual(false)
      p_Juego.actual(false)
      self.playTema()
      
      game.addVisual(self) // opciones.position(52,43)
      
      opciones.mostrar("o_reintentar_.png", 2)
      selector.position(selector.position().down(8).right(0))
      
      selector.seleccion(0)
      selector.setMaxOpciones(1)
    } else {
      if (game.hasVisual(self)) game.removeVisual(self)
      opciones.ocultar()
    }
  }
  
  method image() = "gameover.png"
  
  method position() = game.origin()
  
  method tema() = tema
  
  method playTema() {
    tema.volume(0.5)
    tema.play()
    game.schedule(4000, { tema.stop() })
  }
  
  method stopTema() = tema.stop()
}

object p_youWin {
  var actual = false
  const tema = game.sound("victory.mp3")
  
  method actual() = actual
  
  method actual(bool) {
    actual = bool
    if (actual) {
      // const jugadores = cargar.jugadores()
      // jugadores.forEach({ j => cargar.proyectil(j.jugador()).destruir() })
      // cargar.proyectil(0).destruir()
      
      p_Juego.actual(false)
      p_Menu.stopTema()
      self.playTema()
      game.addVisual(self)

      opciones.mostrar("o_reintentar_.png", 2)
      selector.position(selector.position().down(8).right(0))

      selector.seleccion(0)
      selector.setMaxOpciones(1)
    } else {
      if (game.hasVisual(self)) game.removeVisual(self)
      opciones.ocultar()
      if (tema.played()) tema.stop()
    }
  }
  
  method image() = "youwin_.png"
  
  method position() = game.origin()
  
  method tema() = tema
  
  method playTema() {
    tema.volume(0.5)
    tema.play()
  }
  
  method stopTema() = tema.stop()
}

object p_Juego {
  var actual = false
  
  method actual() = actual
  
  method actual(bool) {
    actual = bool
    if (actual) {
      const jugadores = cargar.jugadores()
      jugadores.forEach({ j => cargar.proyectil(j.jugador()).destruir() })
      cargar.proyectil(0).destruir()

      p_Menu.actual(false)
      p_gameOver.actual(false)
      p_youWin.actual(false)
      p_Pausa.actual(false)
      opciones.ocultar()
    }
  }
}

object p_Pausa {
  var actual = false
  const tema = game.sound("pausa.mp3")
  var wait = true // Variable para no spamear la pausa
  
  method image() = "pausa.png"
  
  method actual() = actual
  
  method actual(bool) {
    actual = bool
    if (actual) {
      game.addVisual(self)
      opciones.mostrar("o_pausa_.png", 3)
      selector.seleccion(0)
      selector.setMaxOpciones(2)
    } else {
      if (game.hasVisual(self)) game.removeVisual(self)
      opciones.ocultar()
    }
  }
  
  method toggle() {
    if (wait) {
      wait = false
      p_Menu.togglePauseTema()
      self.actual(!actual)
      tema.play()
      game.schedule(2000, {   tema.stop()wait = true})
    }
  }
  
  method position() = game.origin()
  
  method tema() = tema
  
  method playTema() {
    tema.play()
  }
  
  method stopTema() = tema.stop()
}