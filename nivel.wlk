import example.*
import wollok.game.*
import proyectil.*
import iu.*
import eventos.*
import controles.*
import pantallas.*

object nivel {

  var jugadores = []
  var enemigos = []
  var proyectiles = []
  var vallas = []
  var hitboxes = []

  var yaColisionoj1 = true
  var yaColisionoj2 = true
  var yaColisionoEnemigo = true

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


  method setJugadores(j) = j.times({i => jugadores.add(new JugadorPrincipal())})

  method getPlayer(jugador) = jugadores.get(jugador - 1)

  method jugadores () = jugadores

  method checkMuerto(jugador) = jugadores.get(jugador-1).getVidas() < 1

  method setProyectiles(j) = j.times({i => proyectiles.add(new Proyectil())})

  method getProyectil(jugador) = proyectiles.get(jugador - 1)

  method proyectiles() = proyectiles

  method vallas () = vallas

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

  method start() {
    
    self.setProyectiles(jugadores.size())
    self.cargarModulos()

    // var indicadores = []
    // var indicadoresj2 = []

    const jugador1 = jugadores.get(0)

    jugador1.setJugador(1)
    jugador1.cargarIndicadores()
    game.addVisual(jugador1)

    if (jugadores.size() == 2){
      const jugador2 = jugadores.get(1)
      jugador2.cambiarImagen("j2.png")
      jugador2.setJugador(2)
      jugador2.cargarIndicadores()
      game.addVisual(jugador2)

      jugador1.spawnea(-(game.width()/4)) // spawnear personajes
      jugador2.spawnea((game.width()/4))
    }
    else {
      jugador1.spawnea(0) // spawnear enemigos
    }
    
    4.times({v => 
        var valla = new Valla()
        valla.spawnea(40*v-32,36)
        var d = -8
          5.times({c => 
            var hitbox = new Hitbox()
            hitbox.position(game.at((40*(v)-24)+ d,36))
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