import iu.*

// pepita.wlk
class Entidad {
  var position = game.at(-1, -1)
  
  method hitSound() = game.sound("hit.mp3")
  
  method soyJugador() = false
  
  method soyEnemigo() = false
  
  method soyHitbox() = false
  
  method soyProyectil() = false
  
  method golpe() {
    const sound = self.hitSound()
    sound.play()
    game.schedule(500, { sound.stop() })
  }
}

object default {
  /* Valores por defecto. Se pueden cambiar para realizar pruebas */

  // method filas() = 3
  // method columnas() = 7
  // method vidasJugador() = 3
  // method vidasValla() = 10

  method filas() = 3
  method columnas() = 7
  method vidasJugador() = 3
  method vidasValla() = 10
}