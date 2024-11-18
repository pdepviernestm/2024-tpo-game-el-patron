import iu.*

object p_Menu {
  var actual = false
  const tema = game.sound("main_loop.mp3")

  method actual() = actual
  method actual(bool) {
    actual = bool
    if(actual){
      // p_Menu.tema().shouldLoop(true)
      self.playTema()
      game.addVisual(self)
      
      opciones.position(65,30)
      opciones.mostrar("opciones2.png")
    } else {
      if(game.hasVisual(self)) game.removeVisual(self) 
      opciones.ocultar()
    }
  }

  method image() = "menu_.png"
  method position() =  game.origin()
  method tema() = tema
  method playTema() {
    tema.shouldLoop(true)
    tema.volume(0.5)
    tema.play()
  }
  method stopTema() = tema.stop()
  method togglePauseTema(){
    if(tema.paused()) tema.resume() else tema.pause()
  }
}

object p_gameOver {
  var actual = false
  const tema = game.sound("game_over.mp3")

  method actual() = actual
  method actual(bool) {
    actual = bool
    if(actual){
      if(p_Pausa.actual()) p_Menu.togglePauseTema()
      p_Menu.stopTema()
      p_Pausa.actual(false)
      p_Juego.actual(false)
      self.playTema()

      game.addVisual(self)
      opciones.position(65,30)
      opciones.mostrar("reintentar.png")

      selector.seleccion(0)
      selector.setMaxOpciones(1)
    } else {
      if(game.hasVisual(self)) game.removeVisual(self) 
      opciones.ocultar()
    }
  }

  method image() = "gameover.png"
  method position() =  game.origin()
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
    if(actual){
      p_Juego.actual(false)
      p_Menu.stopTema()
      self.playTema()
      game.addVisual(self)
      opciones.mostrar("reintentar.png")
    } else {
      if(game.hasVisual(self)) game.removeVisual(self) 
      opciones.ocultar()
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
    if(actual){
      p_Menu.actual(false)
      p_gameOver.actual(false)
      p_youWin.actual(false)
      opciones.ocultar()
    }
  }

}

object p_Pausa {
  var actual = false
  method image() = "pausa.png"
  const tema = game.sound("pausa.mp3")

  method actual() = actual
  method actual(bool) {
    actual = bool
    if(actual){
      game.addVisual(self)
      opciones.mostrar("reintentar.png")
    } else {
      if(game.hasVisual(self)) game.removeVisual(self) 
      opciones.ocultar()
    }
  }

  // Variable para no spamear la pausa
  var wait = true
  method toggle() {
    if(wait){
      wait = false
      p_Menu.togglePauseTema()
      self.actual(!actual)
      tema.play()
      game.schedule(3000,{
        tema.stop()
        wait = true
        })
    }
  }

  method position() = game.origin()
  method tema() = tema
  method playTema() {
    tema.play()
  }
  method stopTema() = tema.stop()
}