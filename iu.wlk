class IndicadorVida {
  var position = game.at(-1, -1)
  var imagen = "piluso2x.png"
  
  method image() = imagen
  
  method cambiarImagen(img) {
    imagen = img
  }
  
  method position() = position
  
  method position(x) {
    position = game.at(x, 2)
  }
}

object selector {
  var position = game.at(
    opciones.position().x() - 10,
    opciones.position().y() + 18
  )
  const imagen = "balboa6.png"
  var seleccion = 0
  var maxOpciones = 2
  const elegir = game.sound("lanzar.mp3")
  const entrar = game.sound("hit_valla.mp3")
  
  method reproducir(sonido) {
    // if (!sonido.played()) {
    sonido.play()
    game.schedule(400, { sonido.stop() }) // }
  }
  
  method image() = imagen
  
  method position() = position
  
  method position(newPos) {
    position = newPos
  }
  
  method mostrar() {
    if(!game.hasVisual(self)) game.addVisual(self)
    // position = game.at(fondoOpciones.position().x()+2, fondoOpciones.position().y() + 19)
    position = fondoOpciones.position().right(2).up(19)
  }
  
  method ocultar() {
    game.removeVisual(self)
  }
  
  method seleccion() = seleccion
  
  method seleccion(s) {
    seleccion = s
  }
  
  method setMaxOpciones(max) {
    maxOpciones = max
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
  var imagen = "rectangulo3.png"
  const position = game.at(52, 43)
  
  method image() = imagen
  
  method position() = position
  
  method image(nueva) {
    imagen = nueva
  }
  
  method mostrar(n) {
    imagen = ("rectangulo" + n) + ".png"
    if(!game.hasVisual(self)) game.addVisual(self)
  }
  
  method ocultar() {
    game.removeVisual(self)
  }
}

object opciones {
  var position = fondoOpciones.position().right(1)
  var imagen = "o_menu__.png"
  
  method image() = imagen
  
  method position() = position
  
  method position(x, y) {
    position = game.at(x, y)
  }
  
  method cambiarImagen(img) {
    imagen = img
  }
  
  method mostrar(img, n) {
    fondoOpciones.mostrar(n)
    selector.mostrar()
    imagen = img
    if(!game.hasVisual(self)) game.addVisual(self)
  }
  
  method ocultar() {
    game.removeVisual(self)
    selector.ocultar()
    fondoOpciones.ocultar()
  }
}