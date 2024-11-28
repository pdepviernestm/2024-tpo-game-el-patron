import config.controles.*
import config.eventos.*
import config.pantallas.*
import entidades.base.default
import entidades.enemigo.*
import entidades.jugador.*
import entidades.proyectil.*
import entidades.vallas.*
import iu.*
import nivel.*

object cargar {
  const property jugadores = []
  const property enemigos = []
  const property proyectiles = []
  const property vallas = []
  const property hitboxes = []
  const property dimensiones = [default.filas(), default.columnas()]
  
  method jugador(jugador) = jugadores.get(jugador - 1)
  
  method proyectil(jugador) = proyectiles.get(jugador)
  
  method modulos() {
    self.entidades()
    controlesMenu.cargar()
    controlesJuego.cargar()
    misterio.cargar()
    eventos.cargarEventos() // controles.cargarControles()
    
    p_Menu.actual(true)
  }
  
  method entidades() {
    self.cargarEnemigos()
    self.cargarProyectiles()
    self.cargarVallas()
    self.cargarJugadores()
  }
  
  method cargarProyectiles() {
    3.times(
      { i =>
        const proyectil = new Proyectil()
        if (i == 1) proyectil.step(proyectil.step() * (-1))
        return proyectiles.add(proyectil)
      }
    )
  }
  
  method cargarEnemigos() {
    dimensiones.get(0).times(
      { i => dimensiones.get(1).times(
          { j =>
            const enemigo = new Enemigo(fila = i, col = j)
            return enemigos.add(enemigo)
          }
        ) }
    )
  }
  
  method cargarVallas() {
    4.times(
      { v =>
        const valla = new Valla()
        5.times(
          { c =>
            const hitbox = new Hitbox(valla=valla)
            return hitboxes.add(hitbox)
          }
        )
        return vallas.add(valla)
      }
    )
  }
  
  method cargarJugadores() {
    2.times(
      { i =>
        const jugador = new JugadorPrincipal(jugador = i)
        jugador.cargarIndicadores()
        return jugadores.add(jugador)
      }
    )
  }
  
  method cargarJuego(nJug) {
    p_Juego.actual(true)
    nivel.start(nJug)
  }
}