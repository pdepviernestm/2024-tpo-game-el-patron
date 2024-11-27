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

  const property filas = 3
  const property columnas = 7
  const property vidasJugador = 3
  const property vidasValla = 10

  // method filas() = 1
  // method columnas() = 1
  // method vidasJugador() = 1
  // method vidasValla() = 1
}