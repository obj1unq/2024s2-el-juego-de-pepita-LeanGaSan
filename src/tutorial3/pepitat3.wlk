import wollok.game.*
import posiciones.*
import extras.*
import comidas.*

object pepita {
	var energia = 100
	var property position = game.at(3,5)
	var property estado = viva

	method comer(comida) {
		energia = energia + comida.energiaQueOtorga()
	}

	method ganar() {
        game.say(self, "Gané :)")
    }
    
    method perder() {
        game.say(self, "Perdí :(")
    }

	// Tutorial 3, colisiones
	method comerVisual(comida) {
		game.removeVisual(comida)
		self.comer(comida)
	}
 
	method energiaParaVolar(kms) {
		return 10 + kms
	}

	method puedeVolar(kms) {
		return energia >= self.energiaParaVolar(kms)
	}

	method volar(kms) {
		self.validarVolar(kms)
		energia = energia - self.energiaParaVolar(kms)
        if (not self.puedeVolar(1)) {
            self.perder()
        }
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

	method fondo() {
		1
	}
}

object muerta {
	method puedeMover() {
		return false
	}

	method fondo() {
		0
	}
}

object victoriosa {
	method puedeMover() {
		return false
	}

	method fondo() {
		1
	}
}