import entidades.base.*

class Valla inherits Entidad(image = "valla192.png", hitsound = game.sound("hit_valla.mp3")) {
  var property vidas = totalVidas
  const totalVidas = default.vidasValla()

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
  var property valla = -1
  
  override method soyHitbox() = true

}