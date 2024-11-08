import iu.*
import controles.*

object pantallas {
    var juegoIniciado = false
    var juegoPorArrancar = false
    var opciones = new Opciones()
    var enControles = false
    var estadoJuego = true

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
    
    opciones.position(65,30)

    game.addVisual(foto_Inicio)
    game.addVisual(opciones)
    game.addVisual(seleccionador)

    // controles.cargarControles()
  
  }
  method gameover() {
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
    //       game.removeVisual(opciones)
    //       game.removeVisual(seleccionador)
    //       game.removeVisual(foto_gameOver)
    //       reintentado = true
    //       estadoJuego = true
    //       self.start()
    //     }
    //     else{
    //       game.stop()
    //     }
    //   }
    // })
  }

  method youwin() {
    estadoJuego = false
    game.addVisual(foto_youWin)
  }

}