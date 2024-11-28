import config.iu.*

// pepita.wlk
class Entidad {
  var property position = game.at(-1, -1)
  var property image = void
  const property hitsound = game.sound("hit.mp3")
  
  // method hitSound() = game.sound("hit.mp3")
  
  method soyJugador() = false
  
  method soyEnemigo() = false
  
  method soyHitbox() = false
  
  method soyProyectil() = false
  
  method golpe() {
    const sound = hitsound
    sound.play()
    game.schedule(500, { sound.stop() })
  }
}

object default {
  /* Valores por defecto. Se pueden cambiar para realizar pruebas */
  // const property filas = 3
  // const property columnas = 7
  // const property vidasJugador = 3
  // const property vidasValla = 10

  const property filas = 3
  const property columnas = 7
  const property vidasJugador = 3
  const property vidasValla = 10
}