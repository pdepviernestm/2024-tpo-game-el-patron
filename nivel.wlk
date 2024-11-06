import example.*
import wollok.game.*
import proyectil.*

object nivel {
  method configurate() {
    game.title("Pepita")
    game.cellSize(10)
    game.height(160)
    game.width(120)
    game.boardGround("calle.png")
    
    game.addVisual(pepita)
    
    var proyectil = new Proyectil()
    var enemigos = []
    var yaColisiono = true
    var i = 0
    var proyectilEnemigo = new ProyectilEnemigo()
    var derecha = true
    var step = 4
    
    pepita.spawnea() // spawnear enemigos
    
    
    3.times(
      { y => 6.times(
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
            else if (enemigo.position().x() <  8 && !derecha) {
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
      if(pepita.position().x() < game.width() - 16) {
        pepita.position(pepita.position().right(4)) }
      })
    keyboard.left().onPressDo({ 
      if(pepita.position().x() > 8){
      pepita.position(pepita.position().left(4)) }})
      
    keyboard.space().onPressDo(
      { if (yaColisiono) {
          proyectil = new Proyectil()
          game.addVisual(proyectil)
          proyectil.spawnea()
          proyectil.lanzar()
          yaColisiono = false
          game.onCollideDo(
            proyectil,
            { elemento => if (elemento.soyEnemigo()) {
                game.removeVisual(proyectil)
                game.removeVisual(elemento)
                yaColisiono = true
                enemigos.remove(elemento)
              } }
          )
        } }
    ) // game.onTick(
    
    
    /*
    TODO hacer que los enemigos disparen
    cambiar las texturas
    agregar vallas 
    menu 
    2000 de ping
    2 tomatess 1 lechuga 1 queso
    
    */
    
    //   8000,
    //   "movimientoEnemigo",
    //   { enemigo.position(enemigo.position().right(4)) }
    // )
    // game.onTick(
    //   100,
    //   "disparoEnemigo",{
    //   proyectilEnemigo = new ProyectilEnemigo()
    //   game.addVisual(proyectilEnemigo)
    //   const indice =  0.randomUpTo(enemigos.size())
    //   const enemigo = enemigos.get(indice)
    //   proyectilEnemigo.spawnea(enemigo.position())
    //   game.onTick(
    //   1,
    //   "movimientoProyectil",
    //   { 
    //     proyectilEnemigo.lanzar()
    //     if (proyectil.position().y() > game.height()) {
    //       game.removeVisual(proyectil)
    //     }
    //   })
    //   game.onTick(
    //   100,
    //   "rotacionProyectil",
    //   { 
    //     proyectilEnemigo.cambiarImagen(i)
    //     i += 1
    //     if (i > 7) {
    //       i = 0
    //     }
    //   })
    //       game.onCollideDo(proyectilEnemigo,
    //         { elemento =>
    //         if(elemento.soyPepita()){
    //           game.say(enemigo, "Toma ñero")
    //           game.removeVisual(proyectilEnemigo)
    //           game.removeVisual(elemento)
    //           yaColisiono = true
    //         }
    //         }
    //       )
    // })
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
      "rotacionProyectil",
      { 
        proyectil.cambiarImagen(i)
        i += 1
        if (i > 7) {
          i = 0
        }
      }
    )
  }
}