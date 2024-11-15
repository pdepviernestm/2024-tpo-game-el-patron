import entidades.*
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

  const c_enem = 7
  const f_enem = 3


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
    self.cargarVallas()
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

  method cargarVallas() {
    4.times({v => 
        const valla = new Valla()
          5.times({c => 
            const hitbox = new Hitbox()
            hitbox.valla(v)
            hitboxes.add(hitbox)
          })
        vallas.add(valla)
      })
  }

  method spawnEnemigos() {
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
  }

  method spawnVallas() {
    var i = 0
    4.times({v => 
        const valla = vallas.get(v-1)
        console.println(valla)
        valla.spawnea(40*v-32,36)
        var d = -8
          5.times({c => 
            const hitbox = hitboxes.get(i)
            hitbox.position(game.at((40*(v)-24)+ d,36))
            game.addVisual(hitbox)
            d += 4
            i += 1
          })
        game.addVisual(valla)
      })
  }

  method jugadores(j) = j.times({_ => jugadores.add(new JugadorPrincipal())})

  method jugador(jugador) = jugadores.get(jugador - 1)

  method jugadores () = jugadores

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
    self.spawnEnemigos()
    self.spawnVallas()

    const jugador1 = self.jugador(1)

    jugador1.setJugador(1)
    jugador1.cargarIndicadores()
    game.addVisual(jugador1)

    if (jugadores.size() == 2){
      const jugador2 = self.jugador(2)
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

  }
}