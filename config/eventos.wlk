import wollok.game.*

import config.cargar.*
import config.pantallas.*
import entidades.chiqui.*
import nivel.*

object eventos {
  var enemigos = []
  const jugadores = cargar.jugadores()
  var i_rotacion = 0
  var derecha = true
  var step = 4
  var enemigosVivos = 0
  
  method cargarEventos() {
    // self._setEnemigos()
    self.chiqui()
    self.movimientoEnemigo()
    self.disparoEnemigo()
    self.rotacionProyectil()
    self.movimientoProyectiles()
    self.verificarPosicionEnemigos()
    self.colisionDisparo()
  }

  method setEnemigos(){
    enemigos = cargar.enemigos()
    enemigosVivos = enemigos.count({e => !e.muerto()})
  }
  
  // Jugador 0: Enemigo
  // Jugador 1: J1
  // Jugador 2: J2
  method colisionDisparo() {
    // console.println(nivel.cargar.proyectiles()())

      game.whenCollideDo(
        cargar.proyectil(1),
        { elemento => self._handleDisparo(elemento, 1) }
      )
      
      game.whenCollideDo(
        cargar.proyectil(2),
        { elemento => self._handleDisparo(elemento, 2) }
      )
  }
  
  method _handleDisparo(elemento, jugador) {
    const proyectil = cargar.proyectil(jugador)

    if (elemento.soyEnemigo()) {
      if(elemento.enFrente()){
        const e_vivos = enemigos.filter({e => !e.muerto()})
        const nuevoFrente = e_vivos.findOrDefault({e => e.fila() != elemento.fila() && e.col() == elemento.col()},elemento)
          nuevoFrente.enFrente(true)
      }

      elemento.morir()
      enemigosVivos -= 1
      proyectil.destruir()
      nivel.setYaColisiono(jugador, true)

      
      if (enemigos.all({e => e.muerto()})) p_youWin.actual(true)
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
      { if (p_Juego.actual() && !p_Pausa.actual()) {
          if (nivel.checkYaColisiono(0)) {
            nivel.setYaColisiono(0, false)
            
            const e_vivos = enemigos.filter({e => !e.muerto() && e.enFrente()})
            const indice = 0.randomUpTo(e_vivos.size()).truncate(0)
            const enemigo = e_vivos.get(indice)
            
            enemigo.cambiarImagen("enemigo_tirar.png")
            game.schedule(500, { enemigo.cambiarImagen("enemigo.png") })
            
            // game.addVisual(cargar.proyectil(0))
            cargar.proyectil(0).spawnea(enemigo.position())
            // cargar.proyectil(0).lanzar()
            // cargar.proyectil(0).reproducir()
          }
        } }
    )
    game.whenCollideDo(
      cargar.proyectil(0),
      { elemento => 
      if (elemento.soyJugador()) {
          cargar.proyectil(0).destruir()
          // game.removeVisual(cargar.proyectil(0))
          elemento.vidas(elemento.vidas() - 1)
          
          if (elemento.vidas() < 1) {
            game.removeVisual(elemento)
            elemento.muerto(true)
          }
          
          elemento.cambiarImagen(("j" + elemento.jugador()) + "_hit.png")
          game.schedule(
            300,
            { elemento.cambiarImagen(("j" + elemento.jugador()) + ".png") }
          )
          
          const indicadores = elemento.indicadores()
          game.removeVisual(indicadores.get(elemento.vidas()))
          // indicadores.remove(indicadores.get(indicadores.size() - 1))
          
          nivel.setYaColisiono(0, true)
          
          if (jugadores.all ({ j => j.muerto()})) {
            // game.removeVisual(elemento)
            // enemigos.forEach({ enemigo => game.removeVisual(enemigo) })
            // enemigos.clear()
            p_gameOver.actual(true)
          }
        } 
        else if (elemento.soyProyectil()) {
          elemento.golpe()
          cargar.proyectil(0).destruir()
          // game.removeVisual(cargar.proyectil(0))
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
    const valla = cargar.vallas().get(elemento.valla()-1)
    if (valla.vidas() >= 1) {
      valla.sacarVida()
      // game.removeVisual(cargar.proyectil(jugador))
      cargar.proyectil(jugador).destruir()
      nivel.setYaColisiono(jugador, true)
      // Debug
    // valla.cambiarImagen("valla_hit.png")
    //       game.schedule(
    //         300,
    //       { valla.cambiarImagen("valla192.png") }
    //   )
      // console.println("Vidas de la valla " + elemento.valla() + ": " + valla.getVidas())
    }
    //  if (valla.vidas() < 1) {
    //   game.removeVisual(valla)
    // }
  }
  
  method _criterio(i) {
    const y = cargar.proyectil(i).position().y()
    return (y < 0) || (y > game.height())
  }
  
  method _handleProyectilMovimiento(i, criterio) {
    cargar.proyectil(i).lanzar()
    if (criterio) {
      // game.removeVisual(cargar.proyectil(i))
      cargar.proyectil(i).destruir()
      nivel.setYaColisiono(i, true)
    }
  }
  
  method movimientoProyectiles() {
    game.onTick(
      1,
      "movimientoProyectiles",
      { if (p_Juego.actual() && !p_Pausa.actual()) cargar.proyectiles().size().times(
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
      { if (p_Juego.actual() && !p_Pausa.actual()) {
          cargar.proyectiles().forEach(
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

  //   var derecha = true
  //   var step = 4

  var moverHaciaAbajo = false
  var nuevaDireccion = derecha

  method reiniciarMovimiento(){
    derecha = true
    moverHaciaAbajo = false
    nuevaDireccion = derecha
    step = 4
  }
  
  method _movimiento() {
    if (p_Juego.actual() && !p_Pausa.actual()){
      moverHaciaAbajo = false
      nuevaDireccion = derecha
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
      var chiquiCounter = 0
      var yaDetono = false
      const player = cargar.jugador(1)
    
      keyboard.t().onPressDo({
        if (chiquiCounter < 3 && p_Juego.actual() && !p_Pausa.actual()) {chiquiCounter += 1} })
    
      game.onTick(
        1000,
        "chiquiMafia",
        { if ((p_Juego.actual() || p_Pausa.actual()) && (!yaDetono)) {
            if (chiquiCounter >= 3) {
              const chiquiSong = game.sound("chiquiSong.mp3")
              chiquiSong.play()
              yaDetono = true
              game.addVisual(chiquiTapia)
              chiquiTapia.spawnear(player.position().x()-16, game.height())
              game.onTick(
                1,
                "Detonar",
                { 
                  if(p_Juego.actual() || p_Pausa.actual()){
                    chiquiTapia.position(game.at(player.position().x()-16,chiquiTapia.position().y()))
                    chiquiTapia.detonar()
                    if (chiquiTapia.position().y() < player.position().y()) {
                      game.removeVisual(chiquiTapia)
                      chiquiCounter = 0
                      chiquiSong.stop()
                      p_gameOver.actual(true)
                    }
                  }
                }
              )
            }
          }
          }
      )}
  
  method verificarPosicionEnemigos() {
    game.onTick(
      1000,
      "verificarPosicionEnemigos",
      { if (p_Juego.actual()) {
        const e_vivos = enemigos.filter({e => !e.muerto()})
          if (e_vivos.any({ enemigo => enemigo.position().y() < 35 }))
            p_gameOver.actual(true)
        } }
    )
  }

  
}