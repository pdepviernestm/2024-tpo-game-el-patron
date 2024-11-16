import wollok.game.*
import entidades.*
import nivel.*
import iu.*
import proyectil.*
import pantallas.*

object eventos {
  var enemigos = []
  const jugadores = nivel.jugadores()
  var i_rotacion = 0
  var derecha = true
  var step = 4
  var enemigosVivos = 0
  
  method cargarEventos() {
    self._setEnemigos()
    self.chiqui()
    self.movimientoEnemigo()
    self.disparoEnemigo()
    self.rotacionProyectil()
    self.movimientoProyectiles()
    self.verificarPosicionEnemigos()
    self.colisionDisparo()
  }

  method _setEnemigos(){
    enemigos = nivel.enemigos()
    enemigosVivos = enemigos.count({e => !e.muerto()})
  }
  
  // Jugador 0: Enemigo
  // Jugador 1: J1
  // Jugador 2: J2
  method colisionDisparo() {
    // console.println(nivel.nivel.proyectiles()())

      game.whenCollideDo(
        nivel.proyectil(1),
        { elemento => self._handleDisparo(elemento, 1) }
      )
      
      game.whenCollideDo(
        nivel.proyectil(2),
        { elemento => self._handleDisparo(elemento, 2) }
      )
  }
  
  method _handleDisparo(elemento, jugador) {
    const proyectil = nivel.proyectil(jugador)

    if (elemento.soyEnemigo()) {
      // enemigos.remove(elemento)
      // game.removeVisual(proyectil)
      if(elemento.enFrente()){
        const e_vivos = enemigos.filter({e => !e.muerto()})
        const nuevoFrente = e_vivos.findOrDefault({e => e.fila() != elemento.fila() && e.col() == elemento.col()},elemento)
        // const nuevoIndice = (elemento.col()*elemento.fila())+7
        // if (nuevoIndice < elemento.col()*elemento.fila()){
        //   const nuevoFrente = enemigos.get(nuevoIndice)
          nuevoFrente.enFrente(true)
          console.println("Nueva fila: "+ nuevoFrente.fila())
          console.println("Nueva columna: "+nuevoFrente.col())
        // }
        // console.println(elemento.fila())
        // console.println("EL QUE LE PEGASTE:")
        // console.println(elemento.col()*(elemento.fila()))
        // console.println("EL DE ARRIBA:")
        // console.println()

      }

      elemento.morir()
      enemigosVivos -= 1
      proyectil.destruir()
      nivel.setYaColisiono(jugador, true)

      
      if (enemigos.all({e => e.muerto()})) pantallas.youwin()
    }
    else if (elemento.soyProyectil()){
      elemento.golpe()
      elemento.destruir()
      proyectil.destruir()
      // game.removeVisual(proyectil)
      // game.removeVisual(elemento)
      nivel.setYaColisiono(0, true)
    }
    else if (elemento.soyHitbox()){
      self._handleHitbox(elemento, jugador)    
    }
  }
  
  method disparoEnemigo() {
    game.onTick(
      1,
      "disparoEnemigo",
      { if (p_Juego.actual()) {
          if (nivel.checkYaColisiono(0)) {
            nivel.setYaColisiono(0, false)
            
            const e_vivos = enemigos.filter({e => !e.muerto() && e.enFrente()})
            const indice = 0.randomUpTo(e_vivos.size()).truncate(0)
            const enemigo = e_vivos.get(indice)
            
            enemigo.cambiarImagen("enemigo_tirar.png")
            game.schedule(500, { enemigo.cambiarImagen("enemigo.png") })
            
            game.addVisual(nivel.proyectil(0))
            nivel.proyectil(0).spawnea(enemigo.position())
            // nivel.proyectil(0).lanzar()
            nivel.proyectil(0).reproducir()
          }
        } }
    )
    game.whenCollideDo(
      nivel.proyectil(0),
      { elemento => 
      if (elemento.soyPepita()) {
          nivel.proyectil(0).destruir()
          // game.removeVisual(nivel.proyectil(0))
          elemento.setVidas(elemento.getVidas() - 1)
          
          elemento.cambiarImagen(("j" + elemento.jugador()) + "_hit.png")
          game.schedule(
            300,
            { elemento.cambiarImagen(("j" + elemento.jugador()) + ".png") }
          )
          
          if (elemento.getVidas() < 1) {
            game.removeVisual(elemento)
          }
          
          
          const indicadores = elemento.indicadores()
          game.removeVisual(indicadores.get(indicadores.size() - 1))
          indicadores.remove(indicadores.get(indicadores.size() - 1))
          
          nivel.setYaColisiono(0, true)
          
          if (jugadores.all ({ j => j.muerto()})) {
            // game.removeVisual(elemento)
            // enemigos.forEach({ enemigo => game.removeVisual(enemigo) })
            // enemigos.clear()
            pantallas.gameover()
          }
        } 
        else if (elemento.soyProyectil()) {
          elemento.golpe()
          nivel.proyectil(0).destruir()
          // game.removeVisual(nivel.proyectil(0))
          // game.removeVisual(elemento)
          elemento.destruir()
          nivel.setYaColisiono(0, true)
        }
        else if (elemento.soyHitbox()){
          self._handleHitbox(elemento, 0)
        }
        }
    )
  }

  method _handleHitbox(elemento, jugador) {
    const valla = nivel.vallas().get(elemento.valla()-1)
    if (valla.getVidas() >= 1) {
      elemento.sacarVida(valla)
      // game.removeVisual(nivel.proyectil(jugador))
      nivel.proyectil(jugador).destruir()
      nivel.setYaColisiono(jugador, true)
      // Debug
    valla.cambiarImagen("valla_hit.png")
          game.schedule(
            300,
          { valla.cambiarImagen("valla192.png") }
      )
      console.println("Vidas de la valla " + elemento.valla() + ": " + valla.getVidas())
    } if (valla.getVidas() < 1) {
      game.removeVisual(valla)
    }
  }
  
  method _criterio(i) {
    const y = nivel.proyectil(i).position().y()
    return (y < 0) || (y > game.height())
  }
  
  method _handleProyectilMovimiento(i, criterio) {
    nivel.proyectil(i).lanzar()
    if (criterio) {
      // game.removeVisual(nivel.proyectil(i))
      nivel.proyectil(i).destruir()
      nivel.setYaColisiono(i, true)
    }
  }
  
  method movimientoProyectiles() {
    game.onTick(
      1,
      "movimientoProyectiles",
      { if (p_Juego.actual()) nivel.proyectiles().size().times(
            { i => 
            self._handleProyectilMovimiento(
                i - 1,
                self._criterio(i - 1)
              ) }
          ) }
    )
  }
  
  method rotacionProyectil() {
    game.onTick(
      1,
      "rotacionProyectil",
      { if (p_Juego.actual()) {
          nivel.proyectiles().forEach(
            { proyectil => proyectil.cambiarImagen(i_rotacion) }
          )
          
          i_rotacion += 1
          if (i_rotacion > 7) {
            i_rotacion = 0
          }
        } }
    )
  }

  method movimientoEnemigo() {
    /*
    Por cada 7 enemigos, se van moviendo mas rápido.
    Y cuando queda uno solo, se mueve a la velocidad máxima.
    */
    
    game.onTick(
      2000,
      "movimientoEnemigo1",
      { if(enemigosVivos > 14 && enemigosVivos <= 21)
          self._movimiento() }
    )
    game.onTick(
      1500,
      "movimientoEnemigo2",
      { if (enemigosVivos > 7 && enemigosVivos <= 14)
          self._movimiento() }
    )
    game.onTick(
      1000,
      "movimientoEnemigo3",
      { if (enemigosVivos > 1 && enemigosVivos <= 7)
          self._movimiento() }
    )
    game.onTick(
      500,
      "movimientoEnemigo4",
      { if (enemigosVivos <= 1)
          self._movimiento() }
    )
  }
  
  method _movimiento() {
    if (p_Juego.actual()){
    var moverHaciaAbajo = false
    var nuevaDireccion = derecha
    const e_vivos = enemigos.filter({e => !e.muerto()})
    
    e_vivos.forEach(
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
    }
  }
  
  method chiqui() {
    if (p_Juego.actual()){
    var chiquiCounter = 0
    var yaDetono = false
    const player = nivel.jugador(1)
    
    keyboard.t().onPressDo({ if (chiquiCounter < 3) {chiquiCounter += 1} })
    
    game.onTick(
      1000,
      "chiquiMafia",
      { if (p_Juego.actual() && (!yaDetono)) {
          if (chiquiCounter >= 3) {
            const chiquiSong = game.sound("chiquiSong.mp3")
            chiquiSong.play()
            yaDetono = true
            game.addVisual(chiquiTapia)
            chiquiTapia.spawnear(player.position().x(), game.height())
            game.onTick(
              1,
              "Detonar",
              { 
                if(p_Juego.actual()){
                  player.position(
                    game.at(chiquiTapia.position().x(), player.position().y())
                  )
                  chiquiTapia.detonar()
                  if (chiquiTapia.position().y() < player.position().y()) {
                    game.removeVisual(chiquiTapia)
                    chiquiCounter = 0
                    chiquiSong.stop()
                    pantallas.gameover()
                  }
                }
              }
            )
          }
        }
         }
    )}
  }
  
  method verificarPosicionEnemigos() {
    game.onTick(
      1000,
      "verificarPosicionEnemigos",
      { if (p_Juego.actual()) {
        const e_vivos = enemigos.filter({e => !e.muerto()})
          if (e_vivos.any({ enemigo => enemigo.position().y() < 35 }))
            pantallas.gameover()
        } }
    )
  }

  
}