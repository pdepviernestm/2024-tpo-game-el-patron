import example.*
import wollok.game.*
import proyectil.*
import iu.*

object nivel {
  var estadoJuego = true
  var yaJugo = false
  var jugadores = 1
  method configurate() {
    game.title("BARRA INVADERS")
    game.cellSize(8)
    game.height(160)
    game.width(160)
    game.boardGround("calle__.png")

    self.menu()
  }

  method setJugadores(j) {
    jugadores = j
  }

  method jugadores () = jugadores

  method gameover() {
    estadoJuego = false
    // var opciones = new Opciones()
    // opciones.cambiarImagen("reintentar.png")
    // opciones.position(65,30)

    // seleccionador.position(game.at(55,38))
    
    game.addVisual(foto_gameOver)
    // game.addVisual(opciones)
    // game.addVisual(seleccionador)

    // var reintentado = false


    // keyboard.up().onPressDo({
    //   if(!reintentado && seleccionador.seleccion() > 0){
    //     // seleccionador.position(55,80)
    //     seleccionador.arriba()
    //   }
    // })
    // keyboard.down().onPressDo({
    //   if(!reintentado && seleccionador.seleccion() < 1){
    //     // seleccionador.position(55,67)
    //     seleccionador.abajo()
    //   }
    // })
    // keyboard.enter().onPressDo({
    //   if (!reintentado){
    //     if(seleccionador.seleccion() == 0){
    //       game.removeVisual(opciones)
    //       game.removeVisual(seleccionador)
    //       game.removeVisual(foto_gameOver)
    //       reintentado = true
    //       estadoJuego = true
    //       self.start()
    //     }
    //     else{
    //       game.stop()
    //     }
    //   }
    // })
  }

  method menu() {

    var opciones = new Opciones()
    var juegoIniciado = false
    var juegoPorArrancar = false
    var enControles = false
    opciones.position(65,30)

    game.addVisual(foto_Inicio)
    game.addVisual(opciones)
    game.addVisual(seleccionador)

    keyboard.up().onPressDo({
      if(!juegoIniciado && seleccionador.seleccion() > 0 && !enControles && estadoJuego){
        // seleccionador.position(55,80)
        seleccionador.arriba()
      }
    })
    keyboard.down().onPressDo({
      if(!juegoIniciado && seleccionador.seleccion() < 2 && !enControles && estadoJuego){
        // seleccionador.position(55,67)
        seleccionador.abajo()
      }
    })
    keyboard.enter().onPressDo({
      if (!juegoIniciado && estadoJuego){
        if(enControles){
          opciones.cambiarImagen("opciones2.png")
          enControles = false
        }
        else if(seleccionador.seleccion() == 0){
          self.setJugadores(1)
          juegoPorArrancar = true
        }
        else if(seleccionador.seleccion() == 1){
          self.setJugadores(2)
          juegoPorArrancar = true
        }
        else{
           enControles = true
           opciones.cambiarImagen("controles2.png")
         }
        if(juegoPorArrancar){
          game.removeVisual(opciones)
          game.removeVisual(seleccionador)
          game.removeVisual(foto_Inicio)
          juegoIniciado = true
          self.start()
        }
      }
    })
  
  }
  method start() {
    var pepita = new JugadorPrincipal()
    var pepita2 = new JugadorPrincipal()

    pepita.setJugador(1)
    pepita2.setJugador(2)

    var proyectil = new Proyectil()
    var proyectilj2 = new Proyectil()
    var proyectilEnemigo = new ProyectilEnemigo()

    var yaColisionoj1 = true
    var yaColisionoj2 = true
    var yaColisionoEnemigo = true

    var enemigos = []
    // var indicadores = []
    // var indicadoresj2 = []
    var vallas = []
    var hitboxes = []

    var i = 0
    var derecha = true
    var step = 4
    var chiquiCounter = 0

    var j1muerto = false
    var j2muerto = false
    if (jugadores == 1){
      j2muerto = true
    }

    pepita2.cambiarImagen("j2.png")
    
    4.times({v => 
        var valla = new Valla()
        valla.spawnea(40*v-32,35)
        var d = -8
          5.times({c => 
            var hitbox = new Hitbox()
            hitbox.position(game.at((40*(v)-24)+ d,35))
            hitbox.valla(v)
            game.addVisual(hitbox)
            hitboxes.add(hitbox)
            d += 4
            game.say(hitbox,"ESTOY ACA")
          })
        game.addVisual(valla)
        vallas.add(valla)
      })
    

    game.addVisual(pepita)

    if (jugadores == 2){
      pepita.spawnea(-8) // spawnear enemigos
      pepita2.spawnea(8)
    }
    else {
      pepita.spawnea(0) // spawnear enemigos
    }
    
    if(jugadores == 2){
      
      game.addVisual(pepita2)
      

       keyboard.right().onPressDo({
      if(pepita2.position().x() < game.width() - 12) {
        pepita2.position(pepita2.position().right(4)) }
      })
      
    keyboard.left().onPressDo({ 
      if(pepita2.position().x() > 8){
      pepita2.position(pepita2.position().left(4)) }})
      
    keyboard.enter().onPressDo(
      { if (yaColisionoj2 && !j2muerto) {
          yaColisionoj2 = false

          proyectilj2 = new Proyectil()

          game.addVisual(proyectilj2)
          proyectilj2.spawnea(pepita2.position())
          proyectilj2.lanzar()

          game.onCollideDo(
            proyectilj2,
            { elemento => if (elemento.soyEnemigo()) {
                game.removeVisual(proyectilj2)
                game.removeVisual(elemento)
                enemigos.remove(elemento)

                yaColisionoj2 = true
              } }
          )
        } }
    ) 
    }

    keyboard.t().onPressDo({
      chiquiCounter += 1
    })

    game.onTick(1000,"chiquiMafia",
     {
      if(estadoJuego){
      if(chiquiCounter >= 3){
        game.addVisual(chiquiTapia)
        chiquiTapia.spawnear(pepita.position().x(),game.height())
        game.onTick(1,"Detonar",{
          pepita.position(game.at(chiquiTapia.position().x(),pepita.position().y()))
          chiquiTapia.detonar()
          if(chiquiTapia.position().y()< pepita.position().y()){
            game.say(chiquiTapia,"No trates de entenderla, disfrutala")
            game.removeVisual(chiquiTapia)
            chiquiCounter = 0
            // self.gameover()
          }
        })
      }
      }
     })
    keyboard.d().onPressDo({
      if(pepita.position().x() < game.width() - 12) {
        pepita.position(pepita.position().right(4)) }
      })
    keyboard.a().onPressDo({ 
      if(pepita.position().x() > 8){
      pepita.position(pepita.position().left(4)) }})
      
    keyboard.space().onPressDo(
      { if (yaColisionoj1 && !j1muerto) {
          yaColisionoj1 = false

          proyectil = new Proyectil()

          game.addVisual(proyectil)
          proyectil.spawnea(pepita.position())
          proyectil.lanzar()

          game.onCollideDo(
            proyectil,
            { elemento => if (elemento.soyEnemigo()) {
                game.removeVisual(proyectil)
                game.removeVisual(elemento)
                enemigos.remove(elemento)

                yaColisionoj1 = true
              } }
          )
        } }
    ) 

    // Crear enemigos
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

    pepita.cargarIndicadores()
    if (jugadores == 2){
      pepita2.cargarIndicadores()
    }



    game.onTick(
    1000,
    "movimientoEnemigo",
    { 
        if(estadoJuego){
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
    }
)


    game.onTick(
      1000,
      "disparoEnemigo",{
        if(estadoJuego){
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
                  elemento.setVidas(elemento.getVidas() - 1)
                  if(elemento.getVidas()<1){
                    game.removeVisual(elemento)
                   if(elemento.jugador() == 1){
                      j1muerto = true

                    }
                    if(elemento.jugador() == 2){
                      j2muerto = true
                    }
                 
                  }

                var indicadores = elemento.indicadores()
                game.removeVisual(indicadores.get(indicadores.size() - 1))
                indicadores.remove(indicadores.get(indicadores.size() - 1))
                yaColisionoEnemigo = true

                if(j1muerto && j2muerto){
                  game.removeVisual(elemento)
                  game.removeVisual(proyectil)
                  enemigos.forEach({ enemigo =>
                    game.removeVisual(enemigo)
                  })
                  enemigos.clear()
                  self.gameover()
                }
              }
                else if(elemento.soyHitbox()){
                    game.stop()
                    var index = elemento.valla()
                    var valla = vallas.get(index)
                    if(valla.getVidas()> 0){
                      elemento.sacarVida(valla)
                      game.removeVisual(proyectilEnemigo)
                    }else{
                      game.removeVisual(valla)
                      elemento.soyHitbox(false)
                      } 
            }
            })
          
          
        }
        }
    })

    
    game.onTick(
      1,
      "movimientoProyectil",
      { 
        if(estadoJuego){
        proyectil.lanzar()
        if (proyectil.position().y() > game.height()) {
          game.removeVisual(proyectil)
          yaColisionoj1 = true
        }
        }
      }
    )

    game.onTick(
      1,
      "movimientoProyectilj2",
      { 
        if(estadoJuego){
        proyectilj2.lanzar()
        if (proyectilj2.position().y() > game.height()) {
          game.removeVisual(proyectilj2)
          yaColisionoj2 = true
        }
        }
      }
    )

    game.onTick(
      1,
      "movimientoProyectilEnemigo",
      { 
        if(estadoJuego){
        proyectilEnemigo.lanzar()
        if (proyectilEnemigo.position().y() < 0) {
          game.removeVisual(proyectilEnemigo)
          yaColisionoEnemigo = true
        }
        }
      }
    )
    
    game.onTick(
      1,
      "rotacionProyectil",
      { 
        if(estadoJuego){
        proyectil.cambiarImagen(i)
        proyectilj2.cambiarImagen(i)
        proyectilEnemigo.cambiarImagen(i)
        i += 1
        if (i > 7) {
          i = 0
        }
        }
      }
    )
    game.onTick(
    1000,
    "verificarPosicionEnemigos",
    {
      if(estadoJuego){
        if (enemigos.any({ enemigo => enemigo.position().y() < 35 })) {
            game.stop()
        }
      }
    }
  )
  
  }
}