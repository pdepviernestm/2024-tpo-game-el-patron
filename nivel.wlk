import wollok.game.*

import config.cargar.*
import config.spawn.*

object nivel {
  
  var yaColisionoj1 = true
  var yaColisionoj2 = true
  var yaColisionoEnemigo = true
  
  var cantJugadores = 1

  method checkYaColisiono(jugador) {
    if (jugador == 0) {
      return yaColisionoEnemigo
    } else {
      if (jugador == 1) {
        return yaColisionoj1
      } else {
        if (jugador == 2) {
          return yaColisionoj2
        } else {
          return true
        }
      }
    }
  }
  
  method setYaColisiono(jugador, bool) {
    if (jugador == 0) {
      yaColisionoEnemigo = bool
    } else {
      if (jugador == 1) {
        yaColisionoj1 = bool
      } else {
        if (jugador == 2) {
          yaColisionoj2 = bool
        }
      }
    }
  }
  
  method cantJugadores() = cantJugadores
  
  method start(j) {
    cantJugadores = j
    
    const jugador1 = cargar.jugador(1)
    if (j == 2) {
      const jugador2 = cargar.jugador(2)
      jugador2.cambiarImagen("j2.png")
      
      jugador1.spawnea(-(game.width() / 4))
      jugador2.spawnea(game.width() / 4)
    } else {
      jugador1.spawnea(0)
    }
    
    spawn.entidades()
  }
}