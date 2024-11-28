import entidades.base.*

class Enemigo inherits Entidad(image = "enemigo.png") {
  var property muerto = false
  var property enFrente = false
  
  const property fila
  const property col
  
  method spawnea(x, y) {
    game.addVisual(self)
    enFrente = false
    muerto = false
    position = game.at(x, y)
  }
  
  method morir() {
    enFrente = false
    muerto = true
    game.removeVisual(self)
    self.golpe()
  }
  
  override method soyEnemigo() = true
}