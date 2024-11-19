import config.cargar.*
import config.eventos.*

object spawn {
  var enemigos = []
  var hitboxes = []
  var vallas = []
  var jugadores = []
  const dim = cargar.dimensiones()
  
  method cargarListas() {
    enemigos = cargar.enemigos()
    hitboxes = cargar.hitboxes()
    vallas = cargar.vallas()
    jugadores = cargar.jugadores()
  }
  
  method entidades(j) {
    self.cargarListas()
    self.spawnEnemigos()
    self.spawnVallas()
    self.spawnJugadores(j)
  }

  method spawnJugadores(j) {
    var n = -1
    jugadores.forEach({i => i.muerto(true)})
    j.times({
      i => 
      const jugador = cargar.jugador(i)
      jugador.spawnea((game.width() / 4)*n)
      n *= -1
      if(j == 1) jugador.spawnea(0)
    })
  }
  
  method spawnEnemigos() {
    // Crear enemigos
    // 3 filas, 7 columnas
    eventos.reiniciarMovimiento()
    var i = 0
    dim.get(0).times(
      { y => dim.get(1).times(
          { x =>
            const enemigo = enemigos.get(i) // Reinicio
            if (game.hasVisual(enemigo)) game.removeVisual(enemigo)
            enemigo.spawnea((16 * x) - 8, (y * 20) + (game.height() / 2))
            if (enemigo.fila() == 1) enemigo.enFrente(true)
            i += 1
          }
        ) }
    )
    
    eventos.setEnemigos()
  }
  
  method spawnVallas() {
    var i = 0
    4.times(
      { v =>
        const valla = vallas.get(v - 1)
        valla.spawnea((40 * v) - 32, 36)
        var d = -8
        return 5.times(
          { c =>
            const hitbox = hitboxes.get(i)
            hitbox.position(game.at(((40 * v) - 24) + d, 36))
            if (!game.hasVisual(hitbox)) game.addVisual(hitbox)
            d += 4
            i += 1
          }
        )
      }
    )
  }
}