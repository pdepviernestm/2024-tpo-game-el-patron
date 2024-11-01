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
    var enemigo = new Enemigo()
    var yaColisiono = true
    var i = 0
    
    pepita.spawnea()
    
    game.addVisual(enemigo)
    enemigo.spawnea()
    
    keyboard.right().onPressDo({ pepita.position(pepita.position().right(4)) })
    
    keyboard.left().onPressDo({ pepita.position(pepita.position().left(4)) })
    
    keyboard.space().onPressDo(
      { if (yaColisiono) {
          proyectil = new Proyectil()
          game.addVisual(proyectil)
          proyectil.spawnea()
          proyectil.lanzar()
          yaColisiono = false
          game.onCollideDo(proyectil,
            { elemento =>
              game.say(pepita, "Le di al enemigo")
              game.removeVisual(proyectil)
              game.removeVisual(elemento)
              yaColisiono = true
            }
          )
        } }
    )
    
    game.onTick(4000,"movimientoEnemigo",{ enemigo.position(enemigo.position().right(2))})
    
    game.onTick(300,"movimientoProyectil",
      { 
        proyectil.lanzar()
        if (proyectil.position().y() > game.height()) {
          game.removeVisual(proyectil)
          yaColisiono = true
        }
      })
    
    game.onTick(600,"rotacionProyectil",{ proyectil.cambiarImagen(i)
        i += 1
        if (i > 7) {
          i = 0
        }
      })
  }
}