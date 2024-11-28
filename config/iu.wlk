class IndicadorVida inherits Visual (
  position = game.at(-1, -1),
  image = "piluso2x.png"
) {
  override method position(x) {
    position = game.at(x, 2)
  }
}

object selector inherits Visual (
  position = game.at(
    opciones.position().x() - 10,
    opciones.position().y() + 18
  ),
  image = "balboa6.png"
) {
  var property seleccion = 0
  var property maxOpciones = 2
  const elegir = game.sound("lanzar.mp3")
  const entrar = game.sound("hit_valla.mp3")
  
  method reproducir(sonido) {
    // if (!sonido.played()) {
    sonido.play()
    game.schedule(400, { sonido.stop() }) // }
  }
  
  override method mostrarExtra() {
    game.removeTickEvent("idleSelector")
    var dir = 1
    position = fondoOpciones.position().right(2).up(19)
    game.onTick(
      1000,
      "idleSelector",
      { 
        self.position(self.position().right(dir))
        dir *= -1
      }
    )
  }

  method mover(num) {
    seleccion -= (1*num)
    self.position(self.position().up(num*8))
    self.reproducir(elegir)
  }
  
  method abajo() {
    if (seleccion < maxOpciones) self.mover(-1)
  }
  
  method arriba() {
    if (seleccion > 0) self.mover(1)
  }
  
  method seleccionar() {
    self.reproducir(entrar)
  }
}

object fondoOpciones inherits Visual (
  image = "rectangulo3.png",
  position = game.at(52, 43)
) {
  method mostrar(n) {
    image = ("rectangulo" + n) + ".png"
    if (!game.hasVisual(self)) game.addVisual(self)
  }
}

object opciones inherits Visual (
  position = fondoOpciones.position().right(1),
  image = "o_menu__.png"
) {
  method mostrar(img, n) {
    fondoOpciones.mostrar(n)
    position = fondoOpciones.position().right(1)
    selector.mostrar()
    image = img
    self.mostrar()
  }
  
  override method ocultarExtra() {
    selector.ocultar()
    fondoOpciones.ocultar()
  }
}

class Visual {
  var property position
  var property image
  
  method mostrar() {
    if (!game.hasVisual(self)) game.addVisual(self)
    self.mostrarExtra()
  }
  
  method ocultar() {
    if (game.hasVisual(self)) game.removeVisual(self)
    self.ocultarExtra()
  }
  
  method ocultarExtra() {
    
  }
  
  method mostrarExtra() {
    
  }
}