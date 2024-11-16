import proyectil.*
import iu.*

// pepita.wlk
class Entidad {
  var position = game.at(-1,-1)
  method hitSound() = game.sound("hit.mp3")
  
  method soyPepita() = false
  
  method soyEnemigo() = false
  
  method soyHitbox() = false
  
  method soyProyectil() = false
  
  method golpe() {
    const sound = self.hitSound()
    sound.play()
    game.schedule(500, { sound.stop() })
  }
}

class JugadorPrincipal inherits Entidad {
  var imagen = "j1.png"
  var vidas = 3
  var muerto = true

  const jugador
  const indicadores = []

  method muerto() = muerto
  method muerto(bool){
    muerto = bool
    if(muerto) self.position(game.at(-1,-1))
  }
  
  method jugador() = jugador
  
  method image() = imagen
  
  method cambiarImagen(img) {
    imagen = img
  }
  
  method position() = position
  
  method position(newPos) {
    position = newPos
  }
  
  method cargarIndicadores() {
    vidas.times(
      { _ =>
        const indicador = new IndicadorVida()
        // if (jugador == 1) {
        //   indicador.position((12 * x) - 9)
        //   indicador.cambiarImagen("piluso2x.png")
        // } else {
        //   if (jugador == 2) {
        //     indicador.position(game.width() - (12 * x))
        //     indicador.cambiarImagen("piluso2xj2_.png")
        //   }
        // }
        indicadores.add(indicador)
        // return game.addVisual(indicador)
      }
    )
  }

  method spawnIndicadores () {
    vidas.times(
      { x =>
        const indicador = indicadores.get(x - 1)
        if (jugador == 1) {
          indicador.position((12 * x) - 9)
          indicador.cambiarImagen("piluso2x.png")
        } else {
          if (jugador == 2) {
            indicador.position(game.width() - (12 * x))
            indicador.cambiarImagen("piluso2xj2_.png")
          }
        }
        // indicadores.add(indicador)
        game.addVisual(indicador)
      }
    )
  }
  
  method indicadores() = indicadores
  
  method spawnea(offset) {
    position = game.at((game.width() / 2) + offset, 12)
  }
  
  method vidas() = vidas
  
  method vidas(newVidas) {
    vidas = newVidas
    self.golpe()
  }
  
  override method soyPepita() = true
}

class Enemigo inherits Entidad {
  var imagen = "enemigo.png"
  var muerto = false
  var enFrente = false

  const fila
  const col

  method fila() = fila
  method col() = col

  method enFrente() = enFrente
  method enFrente(bool) {
    enFrente = bool
  }

  method muerto() = muerto
  method muerto(bool) {
    muerto = bool
  }
  
  method position() = position
  
  method position(newPos) {
    position = newPos
  }
  
  method spawnea(x, y) {
    position = game.at(x, y)
  }
  
  method morir() {
    self.enFrente(false)
    self.muerto(true)
    game.removeVisual(self)
    self.golpe()
  }
  
  method image() = imagen
  
  method cambiarImagen(img) {
    imagen = img
  }
  
  override method soyEnemigo() = true
}

class Hitbox inherits Entidad {
  var imagen = "j2.png" // Para visualizar la hitbox
  var index = -1
  
  override method hitSound() = game.sound("hit_valla.mp3")
  
  method position() = position
  
  method position(newPos) {
    position = newPos
  }
  
  method valla() = index
  
  method valla(index_1) {
    index = index_1
  }
  
  method sacarVida(valla) {
    valla.vidas(valla.vidas() - 1)
    self.golpe()
  }
  
  override method soyHitbox() = true // method soyHitbox(bool){
  
  //   soyHitbox = bool
  // }
  // method image() = imagen
  method cambiarImagen(img) {
    imagen = img
  }
}

class Valla inherits Entidad {
  var imagen = "valla192.png"
  var vidas = 10
  
  method position() = position
  
  method position(newPos) {
    position = newPos
  }
  
  method image() = imagen
  
  method cambiarImagen(img) {
    imagen = img
  }
  
  method vidas() = vidas
  
  method vidas(newVidas) {
    vidas = newVidas
  }
  
  method spawnea(x, y) {
    position = game.at(x, y)
  }
}