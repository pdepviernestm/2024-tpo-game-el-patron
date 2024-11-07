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

    var opciones = new Opciones()
    var juegoIniciado = false
    var jugadores = 1
    var juegoPorArrancar = false
    var enControles = false
    opciones.position(65,30)

    game.addVisual(foto_Inicio)
    game.addVisual(opciones)
    game.addVisual(seleccionador)

    keyboard.up().onPressDo({
      if(!juegoIniciado && seleccionador.seleccion() > 0 && !enControles){
        // seleccionador.position(55,80)
        seleccionador.arriba()
      }
    })
    keyboard.down().onPressDo({
      if(!juegoIniciado && seleccionador.seleccion() < 2 && !enControles){
        // seleccionador.position(55,67)
        seleccionador.abajo()
      }
    })
    keyboard.enter().onPressDo({
      if (!juegoIniciado){
        if(enControles){
          opciones.cambiarImagen("opciones2.png")
          enControles = false
        }
        else if(seleccionador.seleccion() == 0){
          jugadores = 1
          juegoPorArrancar = true
        }
        else if(seleccionador.seleccion() == 1){
          jugadores = 2
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
          self.start(jugadores)
        }
      }
    })
  
  }
  method start(jugadores) {

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

    pepita2.cambiarImagen("j2.png")

    game.addVisual(pepita)
    pepita.spawnea() // spawnear enemigos
    
    4.times({
      v => 
      var valla = new Valla()
      valla.spawnea(24*v,35)
      var d = -8
      3.times({
        c => 
      var hitbox = new Hitbox()
      hitbox.position(game.at((12*(v))+ d,35))
      hitbox.valla(v)
      game.addVisual(hitbox)
      hitboxes.add(hitbox)
      d += 8
      game.say(hitbox,"ESTOY ACA")
      })
      game.addVisual(valla)
      vallas.add(valla)
      })
    

    
    if(jugadores == 2){
      
      game.addVisual(pepita2)
      pepita2.spawnea()

       keyboard.right().onPressDo({
      if(pepita2.position().x() < game.width() - 12) {
        pepita2.position(pepita2.position().right(4)) }
      })
      
    keyboard.left().onPressDo({ 
      if(pepita2.position().x() > 8){
      pepita2.position(pepita2.position().left(4)) }})
      
    keyboard.enter().onPressDo(
      { if (yaColisionoj2) {
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
      if(chiquiCounter >= 3){
        game.addVisual(chiquiTapia)
        chiquiTapia.spawnear(pepita.position().x(),game.height())
        game.onTick(1,"Detonar",{
          pepita.position(game.at(chiquiTapia.position().x(),pepita.position().y()))
          chiquiTapia.detonar()
          if(chiquiTapia.position().y()< pepita.position().y()){
            game.say(chiquiTapia,"No trates de entenderla, disfrutala")
            game.stop()
          }
        })
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
      { if (yaColisionoj1) {
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

    // Poner grafico de vidas en la esquina inferior izquierda
    // 3.times({
    //   x => 
    //   var indicador = new IndicadorVida()
    //   indicador.position(12*x-9)
    //   indicadores.add(indicador)
    //   return game.addVisual(indicador)
    // })

    // if(jugadores == 2){
    //   3.times({
    //   x => 
    //   var indicador = new IndicadorVidaJ2()
    //   indicador.position(12*x+1)
    //   indicadoresj2.add(indicador)
    //   return game.addVisual(indicador)
    // })
    // }

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
                var indicadores = elemento.indicadores()
                game.removeVisual(indicadores.get(indicadores.size() - 1))
                indicadores.remove(indicadores.get(indicadores.size() - 1))
                yaColisionoEnemigo = true
                }
                else if(elemento.soyHitbox()){
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
          yaColisionoj1 = true
        }
      }
    )

    game.onTick(
      1,
      "movimientoProyectilj2",
      { 
        proyectilj2.lanzar()
        if (proyectilj2.position().y() > game.height()) {
          game.removeVisual(proyectilj2)
          yaColisionoj2 = true
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
        proyectilj2.cambiarImagen(i)
        proyectilEnemigo.cambiarImagen(i)
        i += 1
        if (i > 7) {
          i = 0
        }
      }
    )
    game.onTick(
    1000,
    "verificarPosicionEnemigos",
    {
        if (enemigos.any({ enemigo => enemigo.position().y() < 35 })) {
            game.stop()
        }
    }
  )
  
    
  }
}