import iu.*
import controles.*

object pantallas {
    var juegoIniciado = false
    var juegoPorArrancar = false
    var opciones = new Opciones()
    var enControles = false
    var estadoJuego = true
    const temaPrincipal = game.sound("main_loop.mp3")
    const temaGameOver = game.sound("game_over.mp3")

method juegoIniciado() = juegoIniciado
method juegoPorArrancar() = juegoPorArrancar
method opciones() = opciones
method estadoJuego() = estadoJuego
method enControles() = enControles
method setEnControles(bool){
    enControles = bool
}
method setJuegoPorArrancar(bool){
    juegoPorArrancar = bool
}
method setJuegoIniciado(bool){
    juegoIniciado = bool
}

  method menu() {
    
    temaPrincipal.shouldLoop(true)
    temaPrincipal.volume(0.5)
    game.schedule(500, { temaPrincipal.play()} )
    
    opciones.position(65,30)

    game.addVisual(foto_Inicio)
    game.addVisual(opciones)
    game.addVisual(seleccionador)

    // controles.cargarControles()
  
  }
  method gameover() {
    temaPrincipal.stop()
    temaGameOver.volume(0.5)
    temaGameOver.play()
    // console.println("entro a gameover")
    // nivel.getEnemigos()
    // console.println(nivel.jugadores())
    // console.println(nivel.proyectiles())

    // var enemigos = nivel.getEnemigos()
    // var jugadores = nivel.jugadores()
    // var proyectiles = nivel.proyectiles()
    
    // console.println("echo variables")
    
    // jugadores.forEach({ jugador => game.removeVisual(jugador) })
    // enemigos.forEach({ enemigo => game.removeVisual(enemigo) })
    // proyectiles.forEach(({ proyectil => game.removeVisual(proyectil) }))

    // console.println("foreach")
    
    // enemigos.clear()
    // jugadores.clear()
    // proyectiles.clear()
    
    // console.println("clear")

    estadoJuego = false
    // var opciones = new Opciones()
    // opciones.cambiarImagen("reintentar.png")
    // opciones.position(65,30)

    // seleccionador.position(game.at(55,38))
    
    game.addVisual(foto_gameOver)
    // game.addVisual(opciones)
    // game.addVisual(seleccionador)

    // var reintentado = false


    // keyboard.up().onPressDo({
    //   if(!reintentado && seleccionador.seleccion() > 0){
    //     // seleccionador.position(55,80)
    //     seleccionador.arriba()
    //   }
    // })
    // keyboard.down().onPressDo({
    //   if(!reintentado && seleccionador.seleccion() < 1){
    //     // seleccionador.position(55,67)
    //     seleccionador.abajo()
    //   }
    // })
    // keyboard.enter().onPressDo({
    //   if (!reintentado){
    //     if(seleccionador.seleccion() == 0){
    //       self.setJuegoPorArrancar(true)
    //     }
    //     else{
    //       game.stop()
    //     }
    //     reintentado = true
    //   }
    //   if (self.juegoPorArrancar()){
    //     self.setJuegoPorArrancar(false)
    //     game.removeVisual(self.opciones())
    //     game.removeVisual(seleccionador)
    //     game.removeVisual(foto_gameOver)
    //     self.setJuegoIniciado(true)
    //     controles.cargarControlesJuego()
    //     nivel.start()
    //   }
    // })
  }

  method youwin() {
    estadoJuego = false
    game.addVisual(foto_youWin)
  }

}