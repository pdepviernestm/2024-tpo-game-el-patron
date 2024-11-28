import wollok.game.*
import config.cargar.*
import config.spawn.*

object nivel {
  var cantJugadores = 1
  
  method cantJugadores() = cantJugadores
  
  method start(j) {
    cantJugadores = j
    spawn.entidades(j)
  }
}