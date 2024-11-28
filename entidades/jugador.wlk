import entidades.base.*
import config.iu.IndicadorVida

class JugadorPrincipal inherits Entidad(image = "j1.png") {
  const property jugador = 1
  const property indicadores = []
  var property vidas = totalVidas
  var property muerto = true
  const totalVidas = default.vidasJugador()
  
  method muerto(bool) {
    muerto = bool
    if (muerto) {
      game.removeVisual(self)
      self.position(game.at(-1, -1))
      indicadores.forEach({ i => if (game.hasVisual(i)) game.removeVisual(i) })
    }
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
          i.image(archivo + ".png")
          game.addVisual(i)
          x += 1
        } }
    )
  }
  
  method spawnea(offset) {
    image = ("j" + jugador) + ".png"
    muerto = false
    position = game.at((game.width() / 2) + offset, 12)
    vidas = totalVidas
    if (!game.hasVisual(self)) game.addVisual(self)
    self.spawnIndicadores()
  }
  
  method vidas(newVidas) {
    vidas = newVidas
    self.golpe()
  }

  method sacarVida(){
    vidas -= 1
    self.golpe()
  }
  
  override method soyJugador() = true
}