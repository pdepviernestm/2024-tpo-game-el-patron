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
  const jugadores = []
  const enemigos = []
  const proyectiles = []
  const vallas = []
  const hitboxes = []
  const dim = [default.filas(), default.columnas()]
  
  method dimensiones() = dim
  
  method jugador(jugador) = jugadores.get(jugador - 1)
  
  method jugadores() = jugadores
  
  method proyectil(jugador) = proyectiles.get(jugador)
  
  method proyectiles() = proyectiles
  
  method vallas() = vallas
  
  method enemigos() = enemigos
  
  method hitboxes() = hitboxes
  
  method modulos() {
    self.entidades()
    controlesMenu.cargar()
    controlesJuego.cargar()
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
    dim.get(0).times(
      { i => dim.get(1).times(
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
            const hitbox = new Hitbox()
            hitbox.valla(v)
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