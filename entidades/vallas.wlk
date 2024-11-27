import entidades.base.*

class Valla inherits Entidad {
  var property image = "valla192.png"
  const totalVidas = default.vidasValla()
  var vidas = totalVidas
  
  override method hitSound() = game.sound("hit_valla.mp3")
  
  method position() = position
  
  method position(newPos) {
    position = newPos
  }
  
  
  method vidas() = vidas
  
  method vidas(newVidas) {
    vidas = newVidas
  }
  
  method sacarVida() {
    vidas -= 1
    self.golpe()
    image = "valla_hit.png"
    game.schedule(300, { image = "valla192.png" })
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
  
  method image(img) {
    imagen = img
  }
}