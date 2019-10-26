class Personaje
{
	var saludMental = 0
	var influenciaMental = 0
	method influenciaMental() = influenciaMental
	method irDeAventuras(companiero)
	{
		companiero.modificarSaludMental(influenciaMental)
		return true
	}
}
class Rick inherits Personaje
{	
	override method irDeAventuras(companiero)
	{
		if(!companiero.irDeAventuras(self))
		{
			self.convertirseEnPepinillo()
			
			return false
		}
		
		if(saludMental > 100)
		{
			self.convertirseEnPepinillo()
			
			return false
		}
		
		return true
	}
	
	method modificarSaludMental(influenciaMental)
	{
		saludMental += influenciaMental
	}
	
	method convertirseEnPepinillo()
	{
		//Rick no puede ir de aventuras
		//Se convierte en un pepinillo
		saludMental /= 2
	}
}

class Morty inherits Personaje
{	
	override method irDeAventuras(companiero)
	{
		influenciaMental = 50
		saludMental -= 30
		
		super(companiero)
		
		return true
	}
}
class Beth inherits Personaje
{
	var afectoPorPadre = 0
	
	override method irDeAventuras(companiero)
	{
		influenciaMental = -20
		afectoPorPadre += 10
		
		super(companiero)
		
		return true
	}
}
class Summer inherits Personaje
{
	var afectoPorPadre = 0
	
	override method irDeAventuras(companiero)
	{
		var dia = new Date().internalDayOfWeek()
		if(dia == 3)
		{
			influenciaMental = -20
			afectoPorPadre += 10
			
			super(companiero)
			
			return true
		}
		else 
		{
			return false
		}
	}
}
class Jerry inherits Personaje
{
	override method irDeAventuras(companiero)
	{
		return false
	}
}