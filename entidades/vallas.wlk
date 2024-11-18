import entidades.base.*

class Valla inherits Entidad {
  var imagen = "valla192.png"
  const totalVidas = default.vidasValla()
  var vidas = totalVidas
  
  override method hitSound() = game.sound("hit_valla.mp3")
  
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
  
  method sacarVida() {
    vidas -= 1
    self.golpe()
    imagen = "valla_hit.png"
    game.schedule(300, { imagen = "valla192.png" })
    if (vidas < 1) game.removeVisual(self)
  }
  
  method spawnea(x, y) {
    vidas = totalVidas
    if (!game.hasVisual(self)) game.addVisual(self)
    position = game.at(x, y)
  }
}

class Hitbox inherits Entidad {
  var imagen = "j2.png" // Para visualizar la hitbox
  var index = -1
  
  method position() = position
  
  method position(newPos) {
    position = newPos
  }
  
  method valla() = index
  
  method valla(index_1) {
    index = index_1
  }
  
  override method soyHitbox() = true
  
  method cambiarImagen(img) {
    imagen = img
  }
}