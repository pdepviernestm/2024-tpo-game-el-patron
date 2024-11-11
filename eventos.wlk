import wollok.game.*
import example.*
import nivel.*
import iu.*
import proyectil.*
import pantallas.*

object eventos {
  const enemigos = nivel.getEnemigos()
  const proyectiles = [new ProyectilEnemigo(), nivel.getProyectil(1), nivel.getProyectil(2)]
  var i_rotacion = 0
  
  method cargarEventos() {
    self.chiqui()
    self.movimientoEnemigo()
    self.colisionDisparo()
    self.disparoEnemigo()
    self.rotacionProyectil()
    self.movimientoProyectiles()
    self.verificarPosicionEnemigos()
  }
  
  // Jugador 0: Enemigo
  // Jugador 1: J1
  // Jugador 2: J2
  method colisionDisparo() {
    game.whenCollideDo(
      proyectiles.get(1),
      { elemento => self._handleDisparo(elemento,proyectiles.get(1)) }
    )
    game.whenCollideDo(
      proyectiles.get(2),
      { elemento => self._handleDisparo(elemento,proyectiles.get(2)) }
    )
  }
  
  method _handleDisparo(elemento,proyectil) {
    if (elemento.soyEnemigo()) {
      game.removeVisual(proyectil)
      game.removeVisual(elemento)
      enemigos.remove(elemento)
      
      proyectil.destruir()
      nivel.setYaColisiono(1, true)
      
      if (enemigos == []) pantallas.youwin()
    }
  }
  
  method disparoEnemigo() {
    game.onTick(
      1,
      "disparoEnemigo",
      { if (pantallas.estadoJuego()) {
          if (nivel.checkYaColisiono(0)) {
            nivel.setYaColisiono(0, false)
            
            const indice = 0.randomUpTo(enemigos.size()).truncate(0)
            const enemigo = enemigos.get(indice)

            enemigo.cambiarImagen("enemigo_tirar.png")
            game.schedule(500, { enemigo.cambiarImagen("enemigo.png") })
            
            game.addVisual(proyectiles.get(0))
            proyectiles.get(0).spawnea(enemigo.position())
            proyectiles.get(0).lanzar()
          }
        } }
    )
    game.whenCollideDo(
      proyectiles.get(0),
      { elemento => 
      if (elemento.soyPepita()) {
          game.removeVisual(proyectiles.get(0))
          elemento.setVidas(elemento.getVidas() - 1)
          
          elemento.cambiarImagen("j" + elemento.jugador() + "_hit.png")
          game.schedule(300, { elemento.cambiarImagen("j" + elemento.jugador() + ".png") })
          
          if (elemento.getVidas() < 1) {
            game.removeVisual(elemento)
            nivel.setMuerto(elemento.jugador())
          }

          
          const indicadores = elemento.indicadores()
          game.removeVisual(indicadores.get(indicadores.size() - 1))
          indicadores.remove(indicadores.get(indicadores.size() - 1))
          
          nivel.setYaColisiono(0, true)
          
          if (nivel.checkMuerto(1) && nivel.checkMuerto(2)) {
            game.removeVisual(elemento)
            enemigos.forEach({ enemigo => game.removeVisual(enemigo) })
            enemigos.clear()
            pantallas.gameover()
          }
        } }
    )
  }

  method _criterio(i) {
    const y = proyectiles.get(i).position().y()
    return  y < 0 || y > game.height()
  }

  method _handleProyectilMovimiento(i, criterio){
    proyectiles.get(i).lanzar()
          if (criterio) {
            game.removeVisual(proyectiles.get(i))
            nivel.setYaColisiono(i, true)
          }
  }
  
  method movimientoProyectiles() {
    game.onTick(
      1,
      "movimientoProyectiles",
      { if (pantallas.estadoJuego()) {
          3.times({ i => 
            self._handleProyectilMovimiento(i-1 , self._criterio(i-1))
          })
        } }
    )
  }
  method rotacionProyectil() {
    game.onTick(
      1,
      "rotacionProyectil",
      { if (pantallas.estadoJuego()) {
        proyectiles.forEach(
          { proyectil => proyectil.cambiarImagen(i_rotacion) })
          
          i_rotacion += 1
          if (i_rotacion > 7) {
            i_rotacion = 0
          }
        } }
    )
  }
  
  method movimientoEnemigo() {
    var derecha = true
    var step = 4
    
    game.onTick(
      1000,
      "movimientoEnemigo",
      { if (pantallas.estadoJuego()) {
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
    var player = nivel.getPlayer(1)
    
    keyboard.t().onPressDo({ if (chiquiCounter < 3) {chiquiCounter += 1} })
    
    game.onTick(
      1000,
      "chiquiMafia",
      { if (pantallas.estadoJuego() && (!yaDetono)) {
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
                  pantallas.gameover()
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
      { if (pantallas.estadoJuego()) {
          if (enemigos.any({ enemigo => enemigo.position().y() < 35 }))
            pantallas.gameover()
        } }
    )
  }
}