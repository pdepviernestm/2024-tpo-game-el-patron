class IndicadorVida {
  var position = game.at(-1, -1)
  var property image = "piluso2x.png"
  
  method position() = position
  
  method position(x) {
    position = game.at(x, 2)
  }
}

object selector {
  var property position = game.at(
    opciones.position().x() - 10,
    opciones.position().y() + 18
  )
  const property image = "balboa6.png"
  var property seleccion = 0
  var property maxOpciones = 2
  const elegir = game.sound("lanzar.mp3")
  const entrar = game.sound("hit_valla.mp3")
  
  method reproducir(sonido) {
    // if (!sonido.played()) {
    sonido.play()
    game.schedule(400, { sonido.stop() }) // }
  }
  
  method mostrar() {
    if (!game.hasVisual(self)) game.addVisual(self)
    position = fondoOpciones.position().right(2).up(19)
  }
  
  method ocultar() {
    game.removeVisual(self)
  }
  
  method abajo() {
    if (seleccion < maxOpciones) {
      seleccion += 1
      self.position(self.position().down(8))
      self.reproducir(elegir)
    }
  }
  
  method arriba() {
    if (seleccion > 0) {
      seleccion -= 1
      self.position(self.position().up(8))
      self.reproducir(elegir)
    }
  }
  
  method seleccionar() {
    self.reproducir(entrar)
  }
}

object fondoOpciones {
  var property image = "rectangulo3.png"
  var property position = game.at(52, 43)
  
  method mostrar(n) {
    image = ("rectangulo" + n) + ".png"
    if (!game.hasVisual(self)) game.addVisual(self)
  }
  
  method ocultar() {
    game.removeVisual(self)
  }
}

object opciones {
  var property position = fondoOpciones.position().right(1)
  var property image = "o_menu__.png"
  
  method mostrar(img, n) {
    fondoOpciones.mostrar(n)
    position = fondoOpciones.position().right(1)
    selector.mostrar()
    image = img
    if (!game.hasVisual(self)) game.addVisual(self)
  }
  
  method ocultar() {
    game.removeVisual(self)
    selector.ocultar()
    fondoOpciones.ocultar()
  }
}