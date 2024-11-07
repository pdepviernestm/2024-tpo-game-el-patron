class IndicadorVida {
    var position = game.origin()
    var imagen = "piluso2x.png"

    method image() = imagen
    method position() = position

    method position(x) {
        position = game.at(x, 2)
    }
}