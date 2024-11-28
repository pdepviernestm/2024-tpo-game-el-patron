import wollok.game.*
import config.cargar.*
import config.pantallas.*
import nivel.*

object eventos {
  var enemigos = []
  const jugadores = cargar.jugadores()
  var i_rotacion = 0
  var derecha = true
  var step = 4
  var enemigosVivos = 0
  var moverHaciaAbajo = false
  var nuevaDireccion = derecha
  
  method cargarEventos() {
    self.movimientoEnemigo()
    self.disparoEnemigo()
    self.rotacionProyectil()
    self.movimientoProyectiles()
    self.verificarPosicionEnemigos()
    self.colisionDisparo()
  }
  
  method setEnemigos() {
    enemigos = cargar.enemigos()
    enemigosVivos = enemigos.count({ e => !e.muerto() })
    self.movimientoEnemigo()
  }
  
  // Jugador 0: Enemigo
  // Jugador 1: J1
  // Jugador 2: J2
  method colisionDisparo() {
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
      if (elemento.enFrente()) {
        const e_vivos = enemigos.filter({ e => !e.muerto() })
        const nuevoFrente = e_vivos.findOrDefault(
          { e => (e.fila() != elemento.fila()) && (e.col() == elemento.col()) },
          elemento
        )
        nuevoFrente.enFrente(true)
      }
      
      elemento.morir()
      enemigosVivos -= 1
      self.movimientoEnemigo()
      proyectil.destruir()
      
      if (enemigos.all({ e => e.muerto() })) p_youWin.actual(true)
    } else {
      if (elemento.soyProyectil()) {
        elemento.golpe()
        elemento.destruir()
        proyectil.destruir()
      } else {
        if (elemento.soyHitbox()) self._handleHitbox(elemento, jugador)
      }
    }
  }
  
  method disparoEnemigo() {
    const proyectil = cargar.proyectil(0)
    game.onTick(
      1,
      "disparoEnemigo",
      { if (p_Juego.actual() && (!p_Pausa.actual())) {
          if (proyectil.yaColisiono()) {
            const e_vivos = enemigos.filter(
              { e => (!e.muerto()) && e.enFrente() }
            )
            const indice = 0.randomUpTo(e_vivos.size()).truncate(0)
            const enemigo = e_vivos.get(indice)
            
            enemigo.image("enemigo_tirar.png")
            game.schedule(500, { enemigo.image("enemigo.png") })
            proyectil.spawnea(enemigo.position())
          }
        } }
    )
    game.whenCollideDo(
      proyectil,
      { elemento => if (elemento.soyJugador()) {
          proyectil.destruir()
          elemento.sacarVida()
          
          if (elemento.vidas() < 1) elemento.muerto(true)
          
          elemento.image(("j" + elemento.jugador()) + "_hit.png")
          game.schedule(
            300,
            { elemento.image(("j" + elemento.jugador()) + ".png") }
          )
          
          const indicadores = elemento.indicadores()
          game.removeVisual(indicadores.get(elemento.vidas()))
          if (jugadores.all({ j => j.muerto() })) p_gameOver.actual(true)
        } else {
          if (elemento.soyProyectil()) {
            elemento.golpe()
            cargar.proyectil(0).destruir()
            elemento.destruir()
          } else {
            if (elemento.soyHitbox()) self._handleHitbox(elemento, 0)
          }
        } }
    )
  }
  
  method _handleHitbox(elemento, jugador) {
    const valla = elemento.valla()
    if (valla.vidas() >= 1) {
      valla.sacarVida()
      cargar.proyectil(jugador).destruir()
    }
  }
  
  method _criterio(i) {
    const y = cargar.proyectil(i).position().y()
    return (y < 0) || (y > game.height())
  }
  
  method _handleProyectilMovimiento(i, criterio) {
    cargar.proyectil(i).lanzar()
    if (criterio) cargar.proyectil(i).destruir()
  }
  
  method movimientoProyectiles() {
    game.onTick(
      1,
      "movimientoProyectiles",
      { if (p_Juego.actual() && (!p_Pausa.actual()))
          cargar.proyectiles().size().times(
            { i => self._handleProyectilMovimiento(
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
      { if (p_Juego.actual() && (!p_Pausa.actual())) {
          cargar.proyectiles().forEach(
            { proyectil => proyectil.image(i_rotacion) }
          )
          
          i_rotacion += 1
          if (i_rotacion > 7) {
            i_rotacion = 0
          }
        } }
    )
  }
  
  method movimientoEnemigo() {
    // Por cada 7 enemigos, se van moviendo mas rápido.
    // Y cuando queda uno solo, se mueve a la velocidad máxima.
    game.removeTickEvent("movimientoEnemigo")
    game.onTick(
      (100 * enemigosVivos) + 400,
      "movimientoEnemigo",
      { self._movimiento() }
    )
  }
  
  method reiniciarMovimiento() {
    derecha = true
    moverHaciaAbajo = false
    nuevaDireccion = derecha
    step = 4
  }
  
  method _movimiento() {
    if (p_Juego.actual() && (!p_Pausa.actual())) {
      moverHaciaAbajo = false
      nuevaDireccion = derecha
      const e_vivos = enemigos.filter({ e => !e.muerto() })
      
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
  
  method verificarPosicionEnemigos() {
    game.onTick(
      1000,
      "verificarPosicionEnemigos",
      { if (p_Juego.actual()) {
          const e_vivos = enemigos.filter({ e => !e.muerto() })
          if (e_vivos.any({ enemigo => enemigo.position().y() < 35 }))
            p_gameOver.actual(true)
        } }
    )
  }
}