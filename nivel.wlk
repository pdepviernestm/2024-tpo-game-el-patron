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

  const f_enem = 7
  const c_enem = 3


  method configurate() {
    game.title("BARRA INVADERS")
    game.cellSize(8)
    game.height(160)
    game.width(160)
    game.boardGround("calle__.png")

    self.cargarModulos()
    pantallas.menu()
  }

  method cargarModulos() {
    self.cargarEntidades()
    pantallas.cargarControles()
    controles.cargarControlesJuego()
    eventos.cargarEventos()
    // controles.cargarControles()
  }

  method cargarEntidades(){
    self.cargarEnemigos()
    self.cargarProyectiles()
  }

  method cargarProyectiles() {
    3.times({i => 
    const proyectil = new Proyectil()
    if(i == 1) proyectil.step(proyectil.step()*(-1))
    proyectiles.add(proyectil)})
  }

  method cargarEnemigos() {
    (f_enem*c_enem).times(
      { _ => 
          const enemigo = new Enemigo()
          enemigos.add(enemigo)
      }
    ) 
  }
  method jugadores(j) = j.times({i => jugadores.add(new JugadorPrincipal())})

  method jugador(jugador) = jugadores.get(jugador - 1)

  method jugadores () = jugadores

  method checkMuerto(jugador) = jugadores.get(jugador-1).getVidas() < 1


  method proyectil(jugador) = proyectiles.get(jugador)

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

  method enemigos() = enemigos


  method start(j) {
    self.jugadores(j)
    console.println(jugadores)
    console.println(proyectiles)
    // self.cargarModulos()

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
    var i = 0
    f_enem.times(
      { y => c_enem.times(
          { x =>
            const enemigo = enemigos.get(i)
            enemigo.spawnea((16 * x) - 8, (y * 20) + (game.height() / 2))
            game.addVisual(enemigo)
            i += 1
          }
        ) }
    ) 
    
    /*Todos los enemigos van a la derecha y cuando se llega al borde
    de la derecha, todos los enemigos van para abajo. 
    Todos van a la izquierda y cuando llegan al borde bajan.
    */

  }
}