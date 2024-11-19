import entidades.base.*
import iu.IndicadorVida

class JugadorPrincipal inherits Entidad {
  var imagen = "j1.png"
  const totalVidas = default.vidasJugador()
  var vidas = totalVidas
  var muerto = true
  const jugador = 1
  const indicadores = []
  
  method muerto() = muerto
  
  method muerto(bool) {
    muerto = bool
    if (muerto) {
      game.removeVisual(self)
      self.position(game.at(-1, -1))
      indicadores.forEach({ i => if (game.hasVisual(i)) game.removeVisual(i) })
    }
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
    totalVidas.times(
      { _ =>
        const indicador = new IndicadorVida()
        return indicadores.add(indicador)
      }
    )
  }
  
  method spawnIndicadores() {
    var x = 1
    indicadores.forEach(
      { i => if (!game.hasVisual(i)) {
          var archivo = "piluso2x"
          if (jugador == 1) {
            i.position((12 * x) - 9)
          } else {
            i.position(game.width() - (12 * x))
            archivo += "j2_"
          }
          // indicadores.add(indicador)
          i.cambiarImagen(archivo + ".png")
          game.addVisual(i)
          x += 1
        } }
    )
  }
  
  method indicadores() = indicadores
  
  method spawnea(offset) {
    imagen = ("j" + jugador) + ".png"
    muerto = false
    position = game.at((game.width() / 2) + offset, 12)
    vidas = totalVidas
    if (!game.hasVisual(self)) game.addVisual(self)
    self.spawnIndicadores()
  }
  
  method vidas() = vidas
  
  method vidas(newVidas) {
    vidas = newVidas
    self.golpe()
  }
  
  override method soyJugador() = true
}