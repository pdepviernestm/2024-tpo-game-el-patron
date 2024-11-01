// pepita.wlk
object pepita {
  var position = game.origin()
  var imagen = "barra.png"
  
  method position() = position
  
  method position(newPos) {
    position = newPos
  }
  
  method spawnea() {
    const x = (game.width() / 2) - 5
    const y = 5
    position = game.at(x, y)
  }
  
  method image() = imagen
  
  method cambiarImagen(img) {
    imagen = img
  }
}


class Enemigo {
  var imagen = "barra_enemig.png"
  var position = game.origin()
  
  method position() = position
  
  method position(newPos) {
    position = newPos
  }
  
  method spawnea() {
    const x = (game.width() / 2)
    const y = (game.height() / 2)
    
    position = game.at(x,y)
  }
  
  method image() = imagen
  
  method cambiarImagen(img) {
    imagen = img
  }
}


class Hitbox_enemigo{
    var contador = 0

    var position = game.origin()

    method position(){
    if(contador == 0){
    const x = Enemigo.position().x() + 1
    const y = Enemigo.position().y() 
    position = game.at(x,y)
    contador = contador + 1
    }
    if(contador == 1){
    const x = Enemigo.position().x() - 1
    const y = Enemigo.position().y() 
    position = game.at(x,y)
    contador = contador + 1
    }
    if(contador == 2){
    const x = Enemigo.position().x()
    const y = Enemigo.position().y() + 1 
    position = game.at(x,y)
    contador = contador + 1
    }
      if(contador == 3){
    const x = Enemigo.position().x()
    const y = Enemigo.position().y() - 1 
    position = game.at(x,y)
    contador = contador + 1
    
    } 
    return position 
    }
}