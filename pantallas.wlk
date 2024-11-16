import iu.*
import controles.*
import nivel.*

object pantallas {
  var enControles = false
  
  method enControles() = enControles
  
  method setEnControles(bool) {
    enControles = bool
  }
  
  method cargarControles() {
    self.controlesMenu()
  }
  
  method menu() {
    p_Menu.actual(true)
    
    p_Menu.tema().shouldLoop(true)
    // p_Menu.tema().volume(0.5)
    // game.schedule(500, { p_Menu.tema().play() })
    p_Menu.playTema()
    
    // opciones.position(65, 30)
    
    // game.addVisual(p_Menu)
    // game.addVisual(opciones)
    // game.addVisual(selector) // controles.cargarControles()
  }
  
  method gameover() {
    // pantallaActual = p_gameOver
    // if(p_Pausa.actual()) p_Pausa.toggle()
    if(p_Pausa.actual()) p_Menu.togglePauseTema()
    p_Menu.stopTema()
    p_Pausa.actual(false)
    p_Juego.actual(false)
    p_gameOver.actual(true)
    p_gameOver.playTema()

  
    // nivel.getEnemigos()
    // console.println(nivel.jugadores())
    // console.println(nivel.proyectiles())
    // const enemigos = nivel.getEnemigos()
    // const jugadores = nivel.jugadores()
    // const proyectiles = nivel.proyectiles()
    // console.println("echo variables")
    // jugadores.forEach({ jugador => game.removeVisual(jugador) })
    // enemigos.forEach({ enemigo => game.removeVisual(enemigo) })
    // proyectiles.forEach(({ proyectil => game.removeVisual(proyectil) }))
    // console.println("foreach")
    // enemigos.clear()
    // jugadores.clear()
    // proyectiles.clear()
    // console.println("clear")
    // var opciones = new Opciones()
    opciones.cambiarImagen("reintentar.png")
    opciones.position(65,30)

    selector.seleccion(0)
    selector.setMaxOpciones(1)

    // game.addVisual(opciones)
    // game.addVisual(selector)
    
  }
  
  method youwin() {
    p_Juego.actual(false)
    p_youWin.actual(true)
    p_Menu.stopTema()
    p_youWin.playTema()
  }
  
  method controlesMenu() {
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
            self.arrancar(selector.seleccion()+1)
          }
        }
        else if (p_gameOver.actual()){
          if (selector.seleccion() == 0){
            // console.println(nivel.jugadores().size())
            self.arrancar(nivel.jugadores().size())
            p_Menu.playTema()
            
          }
        } }
    )
  }

  method arrancar(jugadores){
    game.removeVisual(opciones)
    game.removeVisual(selector)
    game.removeVisual(p_Menu)
    game.removeVisual(p_gameOver)
    p_Menu.actual(false)
    p_gameOver.actual(false)
    p_Juego.actual(true)
    nivel.start(jugadores)
  }
}

object p_Menu {
  var actual = false
  const tema = game.sound("main_loop.mp3")

  method actual() = actual
  method actual(bool) {
    actual = bool
    if(actual){
      game.addVisual(self)
      game.addVisual(opciones)
      game.addVisual(selector) // controles.cargarControles()
    } else {
      game.removeVisual(self) 
      game.removeVisual(opciones)
      game.removeVisual(selector) // controles.cargarControles()
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
      game.addVisual(self)
      game.addVisual(opciones)
      game.addVisual(selector) // controles.cargarControles()
    } else {
      game.removeVisual(self) 
      game.removeVisual(opciones)
      game.removeVisual(selector) // controles.cargarControles()
    }
  }

  method image() = "gameover.png"
  method position() =  game.origin()
  method tema() = tema
  method playTema() {
    tema.volume(0.5)
    tema.play()
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
      game.addVisual(self)
      game.addVisual(opciones)
      game.addVisual(selector) // controles.cargarControles()
    } else {
      game.removeVisual(self) 
      game.removeVisual(opciones)
      game.removeVisual(selector) // controles.cargarControles()
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
      game.addVisual(opciones)
      game.addVisual(selector) // controles.cargarControles()
      selector.actualizarPos()
    } else {
      game.removeVisual(self) 
      game.removeVisual(opciones)
      game.removeVisual(selector) // controles.cargarControles()
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