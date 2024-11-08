import wollok.game.*
import nivel.*
import pantallas.*
import iu.*

object controles {

var proyectilj1 = nivel.getProyectil(1)
var proyectilj2 = nivel.getProyectil(2)

method cargarControles () {
  self.controlesMenu()
}

method cargarControlesJuego () {
  self.controlesj1()
  self.controlesj2()
}

var pepita = nivel.getPlayer(1)
var pepita2 = nivel.getPlayer(2)

var enMenu = true

 method controlesj1 () {
    keyboard.d().onPressDo({
      if(pepita.position().x() < game.width() - 12) {
        pepita.position(pepita.position().right(4)) }
      })
    keyboard.a().onPressDo({ 
      if(pepita.position().x() > 8){
      pepita.position(pepita.position().left(4)) }})
      
    keyboard.space().onPressDo(
      { if (nivel.checkYaColisiono(1) && !nivel.checkMuerto(1)) {
          nivel.setYaColisiono(1,false)

          // proyectilj1 = new Proyectil()

          game.addVisual(proyectilj1)
          proyectilj1.spawnea(pepita.position())
          proyectilj1.lanzar()
    
        } }
    ) 
}

method controlesj2 () {
  keyboard.right().onPressDo({
      if(pepita2.position().x() < game.width() - 12) {
        pepita2.position(pepita2.position().right(4)) }
      })
      
    keyboard.left().onPressDo({ 
      if(pepita2.position().x() > 8){
      pepita2.position(pepita2.position().left(4)) }})
      
    keyboard.enter().onPressDo(
      { if (nivel.checkYaColisiono(2) && !nivel.checkMuerto(2)) {
          nivel.setYaColisiono(2,false)

          game.addVisual(proyectilj2)
          proyectilj2.spawnea(pepita2.position())
          proyectilj2.lanzar()

        } }
    ) 
}

method controlesMenu() {
  
  keyboard.up().onPressDo({
      if(!pantallas.juegoIniciado() && seleccionador.seleccion() > 0 && !pantallas.enControles() && pantallas.estadoJuego()){
        // seleccionador.position(55,80)
        seleccionador.arriba()
      }
    })
    keyboard.down().onPressDo({
      if(!pantallas.juegoIniciado() && seleccionador.seleccion() < 2 && !pantallas.enControles() && pantallas.estadoJuego()){
        // seleccionador.position(55,67)
        seleccionador.abajo()
      }
    })
    keyboard.enter().onPressDo({
      if (!pantallas.juegoIniciado() && pantallas.estadoJuego()){
        if(pantallas.enControles()){
          pantallas.opciones().cambiarImagen("opciones2.png")
          pantallas.setEnControles(false)
        }
        else if(seleccionador.seleccion() == 0){
          nivel.setJugadores(1)
          pantallas.setJuegoPorArrancar(true)
        }
        else if(seleccionador.seleccion() == 1){
          nivel.setJugadores(2)
          pantallas.setJuegoPorArrancar(true)
        }
        else{
          pantallas.setEnControles(true)
           pantallas.opciones().cambiarImagen("controles2.png")
         }
        if(pantallas.juegoPorArrancar()){
          game.removeVisual(pantallas.opciones())
          game.removeVisual(seleccionador)
          game.removeVisual(foto_Inicio)
          pantallas.setJuegoIniciado(true)
          self.cargarControlesJuego()
          nivel.start()
        }
      }
    })
}

}