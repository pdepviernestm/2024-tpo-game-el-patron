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