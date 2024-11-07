import example.*

class Proyectil {
  var imagen = "balboa0.png"
  var position = game.origin()
  
  method position() = position
  
  method position(newPos) {
    position = newPos
  }
  
  method spawnea() {
    position = pepita.position()
  }
  
  method lanzar() {
    self.position(self.position().up(4))
  }
  
  method image() = imagen
  
  method cambiarImagen(img) {
    imagen = "balboa".concat(img).concat(".png")
  }

  method soyPepita() = false

  method soyEnemigo() = false

}

class ProyectilEnemigo inherits Proyectil{

  method spawnea(x){
    position = x
  }

  override method lanzar(){
    self.position(self.position().down(4))
  }

}