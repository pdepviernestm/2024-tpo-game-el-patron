import example.*

class Proyectil {
  var imagen = "balboa0.png"
  var position = game.origin()
  
  method position() = position
  
  method position(newPos) {
    position = newPos
  }
  
  method spawnea(x) {
    position = x
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

  method soyHitbox()= false
}

class ProyectilEnemigo inherits Proyectil{
  
  override method lanzar(){
    self.position(self.position().down(4))
  }

}