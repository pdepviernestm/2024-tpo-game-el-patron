import wollok.game.*
import example.*
import nivel.*
import iu.*
import proyectil.*

object eventos {
  var enemigos = nivel.getEnemigos()
  var proyectilEnemigo = new ProyectilEnemigo()
  var proyectilj1 = nivel.getProyectil(1)
  var proyectilj2 = nivel.getProyectil(2)

  var i_rotacion = 0
  
  method cargarEventos() {
    self.chiqui()
    self.movimientoEnemigo()
    self.disparoEnemigo()
    self.rotacionProyectil()
    self.movimientoProyectil()
    self.movimientoProyectilEnemigo()
    self.verificarPosicionEnemigos()
  }
  
    // Jugador 0: Enemigo
    // Jugador 1: J1
    // Jugador 2: J2

  method disparoEnemigo() {
    game.onTick(
      1,
      "disparoEnemigo",
      { if (nivel.estadoJuego()) {
          if (nivel.checkYaColisiono(0)) {
            nivel.setYaColisiono(0,false)
            
            const indice = 0.randomUpTo(enemigos.size())
            const enemigo = enemigos.get(indice)
            
            game.addVisual(proyectilEnemigo)
            proyectilEnemigo.spawnea(enemigo.position())
            proyectilEnemigo.lanzar()
          }
        } }
    )
    game.whenCollideDo(
      proyectilEnemigo,
      { elemento => if (elemento.soyPepita()) {
          game.removeVisual(proyectilEnemigo)
          elemento.setVidas(elemento.getVidas() - 1)
          if (elemento.getVidas() < 1) {
            game.removeVisual(elemento)
            if (elemento.jugador() == 1) nivel.setMuerto(1)
            if (elemento.jugador() == 2) nivel.setMuerto(2)
          }
          
          var indicadores = elemento.indicadores()
          game.removeVisual(indicadores.get(indicadores.size() - 1))
          indicadores.remove(indicadores.get(indicadores.size() - 1))
          nivel.setYaColisiono(0, true)
          
          if (nivel.checkMuerto(1) && nivel.checkMuerto(2)) {
            game.removeVisual(elemento)
            enemigos.forEach({ enemigo => game.removeVisual(enemigo) })
            enemigos.clear()
            nivel.gameover()
          }
        } }
    )
  }
  
  method movimientoProyectilEnemigo() {
    game.onTick(
      1,
      "movimientoProyectilEnemigo",
      { if (nivel.estadoJuego()) {
          proyectilEnemigo.lanzar()
          if (proyectilEnemigo.position().y() < 0) {
            game.removeVisual(proyectilEnemigo)
            nivel.setYaColisiono(0,true)
          }
        } }
    )
  }
  
  method rotacionProyectil() {
    game.onTick(
      1,
      "rotacionProyectil",
      { if (nivel.estadoJuego()) {
          
          proyectilj1.cambiarImagen(i_rotacion)
          proyectilj2.cambiarImagen(i_rotacion)
          //   proyectilj2.cambiarImagen(i_rotacion)
          
          proyectilEnemigo.cambiarImagen(i_rotacion)
          i_rotacion += 1
          if (i_rotacion > 7) {
            i_rotacion = 0
          }
        } }
    )
  }

  method movimientoProyectil() {
     game.onTick(
      1,
      "movimientoProyectil",
      { 
        if(nivel.estadoJuego()){
        proyectilj1.lanzar()
        if (proyectilj1.position().y() > game.height()) {
          game.removeVisual(proyectilj1)
          nivel.setYaColisiono(1,true)
        }
        }
      }
    )
    
    game.onTick(
      1,
      "movimientoProyectilj2",
      { 
        if(nivel.estadoJuego()){
        proyectilj2.lanzar()
        if (proyectilj2.position().y() > game.height()) {
          game.removeVisual(proyectilj2)
          nivel.setYaColisiono(2,true)
        }
        }
      }
    )
  }
  
  method movimientoEnemigo() {
    var derecha = true
    var step = 4
    
    game.onTick(
      1000,
      "movimientoEnemigo",
      { if (nivel.estadoJuego()) {
          var moverHaciaAbajo = false
          var nuevaDireccion = derecha
          
          enemigos.forEach(
            { enemigo =>
              if ((enemigo.position().x() > (game.width() - 16)) && derecha) {
                moverHaciaAbajo = true
                nuevaDireccion = false
              } else {
                if ((enemigo.position().x() < 12) && (!derecha)) {
                  moverHaciaAbajo = true
                  nuevaDireccion = true
                }
              } }
          )
          
          if (moverHaciaAbajo) {
            enemigos.forEach({ enem => enem.position(enem.position().down(8)) })
            derecha = nuevaDireccion
            step *= -1
          } else {
            enemigos.forEach(
              { enemigo => enemigo.position(enemigo.position().right(step)) }
            )
          }
        } }
    )
  }
  
  method chiqui() {
    var chiquiCounter = 0
    var yaDetono = false
    var player = nivel.getPlayer()
    
    keyboard.t().onPressDo({ if (chiquiCounter < 3) {chiquiCounter += 1} })
    
    game.onTick(
      1000,
      "chiquiMafia",
      { if (nivel.estadoJuego() && (!yaDetono)) {
          if (chiquiCounter >= 3) {
            yaDetono = true
            game.addVisual(chiquiTapia)
            chiquiTapia.spawnear(player.position().x(), game.height())
            game.onTick(
              1,
              "Detonar",
              { 
                player.position(
                  game.at(chiquiTapia.position().x(), player.position().y())
                )
                chiquiTapia.detonar()
                if (chiquiTapia.position().y() < player.position().y()) {
                  game.say(chiquiTapia, "No trates de entenderla, disfrutala")
                  game.removeVisual(chiquiTapia)
                  chiquiCounter = 0
                  nivel.gameover()
                }
              }
            )
          }
        } }
    )
  }
  
  method verificarPosicionEnemigos() {
    game.onTick(
      1000,
      "verificarPosicionEnemigos",
      { if (nivel.estadoJuego()) {
          if (enemigos.any({ enemigo => enemigo.position().y() < 35 }))
            nivel.gameover()
        } }
    )
  }
}