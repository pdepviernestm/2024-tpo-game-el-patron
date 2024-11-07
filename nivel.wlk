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

    self.menu()
  }

  method menu() {
    var jugador1 = new JugadorOpcion(imagen = "1_Jugador.png")
    var jugador2= new JugadorOpcion(imagen = "2_Jugadores.png")
    var juegoIniciado = false
    var jugadores = 1
    var iniciado = false
    
    jugador1.position(80,80)
    jugador2.position(80,60)
    seleccionador.position(75,80)

    game.addVisual(seleccionador)
    game.addVisual(jugador1)
    game.addVisual(jugador2)

    keyboard.up().onPressDo({
      seleccionador.position(75,80) 
    })
    keyboard.down().onPressDo({
      seleccionador.position(75,60)
    })
    keyboard.enter().onPressDo({
      if (!iniciado){
        if(seleccionador.position().y() == 80){
          jugadores = 1
        }
        else{
          jugadores = 2
        }
        game.removeVisual(jugador1)
        game.removeVisual(jugador2)
        game.removeVisual(seleccionador)
        iniciado = true
        self.start(jugadores)
      }
    })
  }


  method start(jugadores) {

    
    var pepita = new JugadorPrincipal()
    if(jugadores == 2){
      var pepita2 = new JugadorPrincipal()
      game.addVisual(pepita2)
       keyboard.right().onPressDo({
      if(pepita.position().x() < game.width() - 12) {
        pepita.position(pepita.position().right(4)) }
      })
    keyboard.left().onPressDo({ 
      if(pepita.position().x() > 8){
      pepita.position(pepita.position().left(4)) }})
      
    keyboard.enter().onPressDo(
      { if (yaColisiono) {
          yaColisiono = false

          proyectil = new Proyectil()

          game.addVisual(proyectil)
          proyectil.spawnea(pepita.position().x())
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
    
    }
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
    game.onTick(
    2000,
    "verificarPosicionEnemigos",
    {
        if (enemigos.any({ enemigo => enemigo.position().y() < 35 })) {
            game.stop()
        }
    }
  )
  }
}