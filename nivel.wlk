import example.*
import wollok.game.*
import proyectil.*
import iu.*
import eventos.*

object nivel {
  var estadoJuego = true
  var yaJugo = false
  var jugadores = 1
  method configurate() {
    game.title("BARRA INVADERS")
    game.cellSize(8)
    game.height(160)
    game.width(160)
    game.boardGround("calle__.png")

    self.menu()
  }

  method estadoJuego() = estadoJuego

  method setJugadores(j) {
    jugadores = j
  }

  method jugadores () = jugadores

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

  method menu() {

    var opciones = new Opciones()
    var juegoIniciado = false
    var juegoPorArrancar = false
    var enControles = false
    opciones.position(65,30)

    game.addVisual(foto_Inicio)
    game.addVisual(opciones)
    game.addVisual(seleccionador)

    keyboard.up().onPressDo({
      if(!juegoIniciado && seleccionador.seleccion() > 0 && !enControles && estadoJuego){
        // seleccionador.position(55,80)
        seleccionador.arriba()
      }
    })
    keyboard.down().onPressDo({
      if(!juegoIniciado && seleccionador.seleccion() < 2 && !enControles && estadoJuego){
        // seleccionador.position(55,67)
        seleccionador.abajo()
      }
    })
    keyboard.enter().onPressDo({
      if (!juegoIniciado && estadoJuego){
        if(enControles){
          opciones.cambiarImagen("opciones2.png")
          enControles = false
        }
        else if(seleccionador.seleccion() == 0){
          self.setJugadores(1)
          juegoPorArrancar = true
        }
        else if(seleccionador.seleccion() == 1){
          self.setJugadores(2)
          juegoPorArrancar = true
        }
        else{
           enControles = true
           opciones.cambiarImagen("controles2.png")
         }
        if(juegoPorArrancar){
          game.removeVisual(opciones)
          game.removeVisual(seleccionador)
          game.removeVisual(foto_Inicio)
          juegoIniciado = true
          self.start()
        }
      }
    })
  
  }

  var pepita = new JugadorPrincipal()
  var pepita2 = new JugadorPrincipal()
  var enemigos = []

  var j1muerto = false
  var j2muerto = false

  method getPlayer() {
      return pepita
  } 


  method setMuerto(jugador){
    if(jugador == 1){
      j1muerto = true
    }
    else if(jugador == 2){
      j2muerto = true
    }
  }

  method checkMuerto(jugador){
    if(jugador == 1){
      return j1muerto
    } 
    else if (jugador == 2){
      return j2muerto
    }
    else return false
  }

  method checkYaColisiono(jugador) {
    if(jugador == 0){
      return yaColisionoEnemigo
    }
    else if(jugador == 1){
      return yaColisionoj1
    }
    else if(jugador == 2){
      return yaColisionoj2
    }
    else return true
  }

  method setYaColisiono(jugador,bool){
     if(jugador == 0){
      yaColisionoEnemigo = bool
    }
    else if(jugador == 1){
      yaColisionoj1 = bool
    }
    else if(jugador == 2){
      yaColisionoj2 = bool
    }
  }

  method getEnemigos() = enemigos

  var yaColisionoj1 = true
  var yaColisionoj2 = true
  var yaColisionoEnemigo = true

  var proyectilj1 = new Proyectil()
  var proyectilj2 = new Proyectil()

  method getProyectil(jugador){
    if(jugador == 1){
      return proyectilj1
    }
    else if (jugador == 2){
      return proyectilj2
    }
    else return 0
  }
    
  method start() {

    eventos.cargarEventos()

    pepita.setJugador(1)
    pepita2.setJugador(2)


    // var indicadores = []
    // var indicadoresj2 = []
    var vallas = []
    var hitboxes = []



    if (jugadores == 1){
      self.setMuerto(2)
    }

    pepita2.cambiarImagen("j2.png")
    
    4.times({v => 
        var valla = new Valla()
        valla.spawnea(40*v-32,35)
        var d = -8
          5.times({c => 
            var hitbox = new Hitbox()
            hitbox.position(game.at((40*(v)-24)+ d,35))
            hitbox.valla(v)
            game.addVisual(hitbox)
            hitboxes.add(hitbox)
            d += 4
          })
        game.addVisual(valla)
        vallas.add(valla)
      })
    

    game.addVisual(pepita)

    if (jugadores == 2){
      pepita.spawnea(-8) // spawnear enemigos
      pepita2.spawnea(8)
    }
    else {
      pepita.spawnea(0) // spawnear enemigos
    }
    
    if(jugadores == 2){
      
      game.addVisual(pepita2)
      

       keyboard.right().onPressDo({
      if(pepita2.position().x() < game.width() - 12) {
        pepita2.position(pepita2.position().right(4)) }
      })
      
    keyboard.left().onPressDo({ 
      if(pepita2.position().x() > 8){
      pepita2.position(pepita2.position().left(4)) }})
      
    keyboard.enter().onPressDo(
      { if (yaColisionoj2 && !self.checkMuerto(2)) {
          yaColisionoj2 = false

          game.addVisual(proyectilj2)
          proyectilj2.spawnea(pepita2.position())
          proyectilj2.lanzar()

          game.onCollideDo(
            proyectilj2,
            { elemento => if (elemento.soyEnemigo()) {
                game.removeVisual(proyectilj2)
                game.removeVisual(elemento)
                enemigos.remove(elemento)

                yaColisionoj2 = true
                if (enemigos == []){
                  self.youwin()
                }
              } }
          )
        } }
    ) 
    }


    
    keyboard.d().onPressDo({
      if(pepita.position().x() < game.width() - 12) {
        pepita.position(pepita.position().right(4)) }
      })
    keyboard.a().onPressDo({ 
      if(pepita.position().x() > 8){
      pepita.position(pepita.position().left(4)) }})
      
    keyboard.space().onPressDo(
      { if (yaColisionoj1 && !self.checkMuerto(1)) {
          yaColisionoj1 = false

          // proyectilj1 = new Proyectil()

          game.addVisual(proyectilj1)
          proyectilj1.spawnea(pepita.position())
          proyectilj1.lanzar()

          game.onCollideDo(
            proyectilj1,
            { elemento => if (elemento.soyEnemigo()) {
                game.removeVisual(proyectilj1)
                game.removeVisual(elemento)
                enemigos.remove(elemento)

                yaColisionoj1 = true

                if (enemigos == []){
                  self.youwin()
                }
              } }
          )
        } }
    ) 

    // Crear enemigos
    // 3 filas, 7 columnas
    3.times(
      { y => 7.times(
          { x =>
            var enemigo = new Enemigo()
            enemigos.add(enemigo)
            enemigo.spawnea((16 * x) - 8, (y * 20) + (game.height() / 2))
            return game.addVisual(enemigo)
          }
        ) }
    ) 
    
    /*Todos los enemigos van a la derecha y cuando se llega al borde
    de la derecha, todos los enemigos van para abajo. 
    Todos van a la izquierda y cuando llegan al borde bajan.
    */

    pepita.cargarIndicadores()
    if (jugadores == 2){
      pepita2.cargarIndicadores()
    }

    

  
  }
}