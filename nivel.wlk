import example.*
import wollok.game.*
import proyectil.*
import iu.*
import eventos.*
import controles.*
import pantallas.*

object nivel {
  var jugadores = 1

  var pepita = new JugadorPrincipal()
  var pepita2 = new JugadorPrincipal()
  var enemigos = []

  var j1muerto = false
  var j2muerto = false

  var yaColisionoj1 = true
  var yaColisionoj2 = true
  var yaColisionoEnemigo = true

  // var proyectilj1 = new Proyectil()
  // var proyectilj2 = new Proyectil()
  const proyectiles = [new Proyectil(), new Proyectil()]

  method configurate() {
    game.title("BARRA INVADERS")
    game.cellSize(8)
    game.height(160)
    game.width(160)
    game.boardGround("calle__.png")

    controles.cargarControles()
    pantallas.menu()
  }

  method cargarModulos() {
    eventos.cargarEventos()
    // controles.cargarControles()
  }
  
  method jugadores () = jugadores

  method setJugadores(j) {
    jugadores = j
  }

  method getPlayer(jugador) {
    if(jugador == 1){
      return pepita
    }
    else if (jugador == 2){
      return pepita2
    }
    else return 0
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

  method getProyectil(jugador){
    // if(jugador == 1){
    //   return proyectilj1
    // }
    // else if (jugador == 2){
    //   return proyectilj2
    // }
    // else return 0
    return proyectiles.get(jugador - 1)
  }
    
  method start() {

    self.cargarModulos()

    // var indicadores = []
    // var indicadoresj2 = []
    var vallas = []
    var hitboxes = []

    pepita.setJugador(1)
    pepita.cargarIndicadores()
    game.addVisual(pepita)

    if (jugadores == 2){
      pepita2.cambiarImagen("j2.png")
      pepita2.setJugador(2)
      pepita2.cargarIndicadores()
      game.addVisual(pepita2)

      pepita.spawnea(-8) // spawnear personajes
      pepita2.spawnea(8)
    }
    else {
      self.setMuerto(2)
      pepita.spawnea(0) // spawnear enemigos
    }
    
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

  }
}