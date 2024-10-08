
import wollok.game.*
import posiciones.*
import extras.*
import comidas.*

object pepita {
	var energia = 100
	var property position = game.at(3,5)
	const destino = nido
	const cazador = silvestre

	method comer(comida) {
		energia = energia + comida.energiaQueOtorga()
	}

	// Etsa es la versión para trabajar apretando la tecla
	method comerAhi() {
		const comida = game.uniqueCollider(self)
		self.comer(comida)
		game.removeVisual(comida)
	}

	// Tutorial 3, colisiones
	method comerVisual(comida) {
		self.comer(comida)
		game.removeVisual(comida)
	}
 
	method energiaParaVolar(kms) {
		return 10 + kms
	}

	method puedeVolar(kms) {
		return energia >= self.energiaParaVolar(kms)
	}

	method volar(kms) {
		self.validarVolar(kms)
		energia = energia - 10 - kms 
	}

	method validarVolar(kms) {
		if (self.energia() < self.energiaParaVolar(kms)) {
			self.error("no tengo energia para volar " + kms + " kms")
		}
	}


	
	method energia() {
		return energia
	}

	method image() {
		return "pepita-" + self.estado() + ".png"
	}

	/* Este es el método sin colisiones
	method estado() {
		return if (self.estaEnDestino()) {
			victoriosa
		} else if (self.muerta()) {
			muerta
		} else {
			viva
		}
	} */

	method 

	method muerta() {
		return self.estaAtrapada() or not self.puedeMover()
	}

	method text() {
		return self.energia().toString()
	} 

	method textColor() {
		return "FF000FF"
	}

	method mover(direccion) {
		self.validarMover(direccion)
		self.volar(1)
		self.desplazar(direccion)
		
	}

	method desplazar(direccion) {
		self.validarMover(direccion)
		position = direccion.siguiente(self.position())
		self.estado().comprobarFinDeJuego()
	}

	method validarMover(direccion) {
		self.capacidadMovimiento()
		const siguiente = direccion.siguiente(self.position())
		self.validarAtravesables(posicion)
		tablero.estaDentro(direccion.siguiente(self.position()))
		/*const siguiente = direccion.siguiente(self.position())
		if (not tablero.estaDentro(siguiente)) {
			self.error("No puedo moverme fuera")
		}*/
		self.validarAtravesables(siguiente)
	}

	method validarAtravesables(direccion) {
		if (self.haySolido(position)) {
			self.error("No puedo ir ahí")
		}
	} 

	method haySolido(_position) {
		return game.getObjectsIn(_position)
	}

	method capacidadMovimiento() {
		if (not self.estado().puedeMover()) {
			self.error("No puedo ir ahí")
		}
	}

	method estaEnDestino() {
		return position == destino.position()
	}

	method estaAtrapada() {
		return position == cazador.position()
	}

	method caer() {
		self.validarMover(abajo)
		self.desplazar(abajo)
	}

	// IDEA DE QUE PEPITA NO PUEDA ATRAVEZAR UN OBJETO
	method solida() {
		return false
	}
}

object viva {
	method puedeMover() {
		return 	true
	}

	method comprobarFinDeJuego(personaje) {
		
	}

	method fondo() {
		1
	}
}

object muerta {
	method puedeMover() {
		return false
	}

	method comprobarFinDeJuego(personaje) {
		game.say(personaje, "Perdí! :(") 
		game.schedule(500, { game.stop() })
	}

	method fondo() {
		0
	}
}

object victoriosa {
	method puedeMover() {
		return false
	}

	method comprobarFinDeJuego(personaje) {
		game.say(personaje, "Gané! :D") 
		game.schedule(500, { game.stop() })
	}

	method fondo() {
		1
	}
}