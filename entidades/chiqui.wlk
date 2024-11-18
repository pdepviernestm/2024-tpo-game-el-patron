object chiquiTapia {
  var position = game.at(-1, -1)
  const imagen = "chiquiMafia.png"
  
  method image() = imagen
  
  method position() = position
  
  method spawnear(x, y) {
    position = game.at(x, y)
  }
  
  method position(newPos) {
    position = newPos
  }
  
  method detonar() {
    self.position(self.position().down(4))
  }
}