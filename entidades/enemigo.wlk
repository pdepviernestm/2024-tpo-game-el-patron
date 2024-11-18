import entidades.base.*

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
  
  method image() = imagen
  
  method cambiarImagen(img) {
    imagen = img
  }
  
  override method soyEnemigo() = true
}