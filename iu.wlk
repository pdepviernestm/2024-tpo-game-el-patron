class IndicadorVida {
    var position = game.origin()

    method image() = "piluso2x.png"
    method position() = position

    method position(x) {
        position = game.at(x, 2)
    }
}

class IndicadorVidaJ2 inherits IndicadorVida {
    override method image() = "piluso2xj2_.png"

    override method position(x){
        position = game.at(game.width()-x, 2)
    }
}

object foto_Inicio{

var position = game.origin()
    var imagen = "menu.png"

    method image() = imagen
    method position() = position

    method position(x,y){
        position= game.at(x,y)
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

object chiquiTapia{
    var position = game.origin()
    var imagen = "chiquiMafia.png"

    method image() = imagen
    method position() = position

    method spawnear(x,y){
        position= game.at(x,y)
    }

    method position(newPos){
        position= newPos
    }

    method detonar(){
   self.position(self.position().down(4))
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
