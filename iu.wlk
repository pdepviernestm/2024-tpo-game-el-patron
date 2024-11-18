class IndicadorVida {
  var position = game.at(-1,-1)
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
  var position = game.at(opciones.position().x()-10, opciones.position().y()+18)
  const imagen = "balboa6.png"
  var seleccion = 0
  var maxOpciones = 2
  const elegir = game.sound("lanzar.mp3")
  const entrar = game.sound("hit_valla.mp3")
  
  method reproducir(sonido) {
    // if (!sonido.played()) {
      sonido.play()
      game.schedule(400, { sonido.stop() })
    // }
  }
  
  method image() = imagen
  
  method position() = position

  method position(newPos) {
    position = newPos
  }

  method mostrar(){
    game.addVisual(self)
    position = game.at(opciones.position().x()-10, opciones.position().y()+18)
  }

  method ocultar() {
    game.removeVisual(self)
  }

  method seleccion() = seleccion
  method seleccion(s){
    seleccion = s
  }
  
  method setMaxOpciones(max) {
    maxOpciones = max
  }

  method abajo() {
    if (seleccion < maxOpciones) {
      seleccion += 1
      self.position(self.position().down(9))
      self.reproducir(elegir)
    }
  }
  
  method arriba() {
    if (seleccion > 0) {
      seleccion -= 1
      self.position(self.position().up(9))
      self.reproducir(elegir)
    }
  }
  
  method seleccionar() {
    self.reproducir(entrar)
  }
  
}

object opciones {
  var position = game.at(65, 30)
  var imagen = "opciones2.png"
  
  method image() = imagen
  
  method position() = position
  
  method position(x, y) {
    position = game.at(x, y)
  }
  
  method cambiarImagen(img) {
    imagen = img
  }

  method mostrar(img) {
    selector.mostrar()
    imagen = img
    game.addVisual(self)
  }

  method ocultar() {
    game.removeVisual(self)
    selector.ocultar()
  }
}