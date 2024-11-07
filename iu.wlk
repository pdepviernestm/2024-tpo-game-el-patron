class IndicadorVida {
    var position = game.origin()
    var imagen = "piluso2x.png"

    method image() = imagen
    method position() = position

    method position(x) {
        position = game.at(x, 2)
    }
}


class JugadorOpcion{

    var position = game.origin()
    var imagen

    method image() = imagen
    method position() = position

    method position(x,y){
        position= game.at(x,y)
    }
}


object seleccionador{
    
    var position = game.origin()
    var imagen = "Seleccionador.png"

    method image() = imagen
    method position() = position


  method position(x,y){
    


  position = game.at(x,y)
    }

}
