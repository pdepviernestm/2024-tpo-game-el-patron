import example.*
import wollok.game.*
import proyectil.*
import iu.*

object nivel {
  method configurate() {
    game.title("BARRA INVADERS")
    game.cellSize(8)
    game.height(160)
    game.width(160)
    game.boardGround("calle.png")
    
    game.addVisual(pepita)
    
    var proyectil = new Proyectil()
    var proyectilEnemigo = new ProyectilEnemigo()
    

    var yaColisiono = true
    var yaColisionoEnemigo = true

    var enemigos = []
    var indicadores = []
    var i = 0
    var derecha = true
    var step = 4
    
    pepita.spawnea() // spawnear enemigos
    
    3.times(
      { y => 7.times(
          { x =>
            var enemigo = new Enemigo()
            enemigos.add(enemigo)
            enemigo.spawnea((16 * x) - 8, (y * 20) + (game.height() / 2))
            return game.addVisual(enemigo)
          }
        ) }
    ) 
    
    /*Todos los enemigos van a la derecha y cuando se llega al borde
    de la derecha, todos los enemigos van para abajo. 
    Todos van a la izquierda y cuando llegan al borde bajan.
    */

    // Poner grafico de vidas en la esquina inferior izquierda
    3.times({
      x => 
      var indicador = new IndicadorVida()
      indicador.position(12*x-9)
      indicadores.add(indicador)
      return game.addVisual(indicador)
    })

    game.onTick(
    1000,
    "movimientoEnemigo",
    { 
        var moverHaciaAbajo = false
        var nuevaDireccion = derecha

        enemigos.forEach({ enemigo =>
            if (enemigo.position().x() > (game.width() - 16) && derecha) {
                moverHaciaAbajo = true
                nuevaDireccion = false
            }
            else if (enemigo.position().x() <  12 && !derecha) {
                moverHaciaAbajo = true
                nuevaDireccion = true
            }
        })

        if (moverHaciaAbajo) {
            enemigos.forEach({ enem =>
                enem.position(enem.position().down(8))
            })
            derecha = nuevaDireccion
            step *= -1
        } else {
            enemigos.forEach({ enemigo =>
                enemigo.position(enemigo.position().right(step))
            })
        }
    }
)
    
    keyboard.right().onPressDo({
      if(pepita.position().x() < game.width() - 12) {
        pepita.position(pepita.position().right(4)) }
      })
    keyboard.left().onPressDo({ 
      if(pepita.position().x() > 8){
      pepita.position(pepita.position().left(4)) }})
      
    keyboard.space().onPressDo(
      { if (yaColisiono) {
          yaColisiono = false

          proyectil = new Proyectil()

          game.addVisual(proyectil)
          proyectil.spawnea()
          proyectil.lanzar()

          game.onCollideDo(
            proyectil,
            { elemento => if (elemento.soyEnemigo()) {
                game.removeVisual(proyectil)
                game.removeVisual(elemento)
                enemigos.remove(elemento)

                yaColisiono = true
              } }
          )
        } }
    ) 
    
    /*
    TODO hacer que los enemigos disparen
    cambiar las texturas
    agregar vallas 
    menu 
    2000 de ping
    2 tomatess 1 lechuga 1 queso
    
    */
    game.onTick(
      1000,
      "disparoEnemigo",{
        if(yaColisionoEnemigo){
          yaColisionoEnemigo = false

          const indice =  0.randomUpTo(enemigos.size())
          const enemigo = enemigos.get(indice)
          proyectilEnemigo = new ProyectilEnemigo()

          game.addVisual(proyectilEnemigo)
          proyectilEnemigo.spawnea(enemigo.position())
          proyectilEnemigo.lanzar()

          game.onCollideDo(proyectilEnemigo,
            { elemento =>
              if(elemento.soyPepita()){
                 game.removeVisual(proyectilEnemigo)
                 if(elemento.getVidas() > 1){
                   elemento.setVidas(elemento.getVidas() - 1)
                   
                 }
                 else{
                  game.removeVisual(elemento)
                  // game.stop()
                 }
                game.removeVisual(indicadores.get(indicadores.size() - 1))
                indicadores.remove(indicadores.get(indicadores.size() - 1))
                yaColisionoEnemigo = true
                }
            }
          )
        }
      
    })
    game.onTick(
      1,
      "movimientoProyectil",
      { 
        proyectil.lanzar()
        if (proyectil.position().y() > game.height()) {
          game.removeVisual(proyectil)
          yaColisiono = true
        }
      }
    )

    game.onTick(
      1,
      "movimientoProyectilEnemigo",
      { 
        proyectilEnemigo.lanzar()
        if (proyectilEnemigo.position().y() < 0) {
          game.removeVisual(proyectilEnemigo)
          yaColisionoEnemigo = true
        }
      }
    )
    
    game.onTick(
      1,
      "rotacionProyectil",
      { 
        proyectil.cambiarImagen(i)
        proyectilEnemigo.cambiarImagen(i)
        i += 1
        if (i > 7) {
          i = 0
        }
      }
    )
  }
}