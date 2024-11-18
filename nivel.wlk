import wollok.game.*
import config.cargar.*
import config.spawn.*

object nivel {
  var cantJugadores = 1
  
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