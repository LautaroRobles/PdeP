class Caminante
{
    var property sed_de_sangre
    var property somnoliento
    var property cantidad_dientes
    method poder_corrosivo() = 2 * sed_de_sangre + cantidad_dientes
    method esta_debil() = (sed_de_sangre < 15) and somnoliento
}
 
class Sobreviviente
{
    var property resistencia
    var property carisma
    var property estado
    var property armas
    var property puntos_base
    method puede_atacar() = resistencia > 12
    method afectar_resistencia(valor){resistencia += valor}
    method afectar_carisma(valor){carisma += valor}
    method modificar_estado(nuevo_estado){estado = nuevo_estado}
    method atacar(caminante)
    {
        self.afectar_resistencia(-2)
        estado.atacar(self)
    }
    method comer()
    {
        estado.comer(self)
    }
    method tomar_armas(armamento)
    {
        armas.addAll(armamento)
    }
    method perder_arma(arma)
    {
        armas.remove(arma)
    }
    method poder_propio() = puntos_base * (1 + carisma/100)
    method poder_ofensivo() = armas.anyOne().poder_ofensivo() + self.poder_propio()
}
 
class Predador inherits Sobreviviente
{
    var property caminantes_esclavizados
    override method atacar(caminante)
    {
        super(caminante)
        if(caminante.esta_debil())
        {
            caminantes_esclavizados.add(caminante)
        }
    }
    override method poder_ofensivo() = (super() / 2) + caminantes_esclavizados.sum({caminante => caminante.poder_corrosivo()})
}
 
class Arma
{
    var property ruidosa
    var property calibre
    var property potencia_destructiva
    method poder_ofensivo() = 2 * calibre + potencia_destructiva
}
 
class Grupo
{
    var property integrantes
    var property ubicacion
    method atacantes() = integrantes.filter({integrante => integrante.puede_atacar()})
    method poder_ofensivo() = self.atacantes().sum({atacante => atacante.poder_ofensivo()}) * self.lider().carisma()
    method lider()
    {
        return integrantes.max({integrante => integrante.carisma()})
    }
    method integrante_mas_debil()
    {
        return integrantes.min({integrante => integrante.poder_ofensivo()})
    }
    method integrantes_jodidos()
    {
    	return integrantes.filter({integrante => integrante.resistencia() < 40})
    }
    method puede_tomar(lugar)
    {
        return lugar.puede_tomarse(self)
    }
    method tomar_lugar(lugar)
    {
    	if(self.puede_tomar(lugar))
    	{
    		ubicacion = lugar
    		lugar.tomado_por(self)
    	}
    }
}
 
class Saludable
{
    method atacar(sobreviviente){}
    method comer(sobreviviente){}
}
 
class Arrebatado
{
    method atacar(sobreviviente)
    {
        sobreviviente.afectar_carisma(1)
    }
    method comer(sobreviviente)
    {
        sobreviviente.afectar_resistencia(50)
        sobreviviente.afectar_carisma(20)
    }
}
 
class Infectado
{
    var property ataques_realizados = 0
    method atacar(sobreviviente)
    {
        ataques_realizados++
       
        if(ataques_realizados >= 5)
        {
            sobreviviente.estado(new Desmayado())
        }
        sobreviviente.afectar_resistencia(-3)
    }
    method comer(sobreviviente)
    {
        if(ataques_realizados > 3)
        {
            ataques_realizados = 0
        }
        else
        {
            sobreviviente.estado(new Saludable())
        }
        sobreviviente.afectar_resistencia(40)
    }
}
 
class Desmayado
{
    method atacar(sobreviviente){}
    method comer(sobreviviente){sobreviviente.estado(new Saludable())}
}
 
class Lugar
{
    var property caminantes
    method poder_corrosivo() = caminantes.sum({caminante => caminante.poder_corrosivo()})
    method puede_tomarse(grupo)
    {
    	return self.poder_corrosivo() < grupo.poder_ofensivo() and self.puede_tomarse_especifico(grupo)
    }
    method puede_tomarse_especifico(grupo) // Abstract
	method tomado_por(grupo)
	{
		if(grupo.integrantes().all({integrante => integrante.puede_atacar()}))
		{
			caminantes.forEach({caminante => 
				grupo.integrantes().anyOne().atacar(caminante)
			})
		}
		else
		{
			grupo.integrantes().remove(grupo.integrante_mas_debil())
			grupo.integrantes_jodidos().forEach({integrante_jodido => grupo.integrantes().remove(integrante_jodido)})
		}
		self.tomado_por_especifico(grupo)
		
	}
	method tomado_por_especifico(grupo) // Abstract
}
 
class Prision inherits Lugar
{
    var property pabellones
    var property armas
   
    override method puede_tomarse_especifico(grupo) = grupo.poder_ofensivo() > 2 * pabellones
   
    override method tomado_por_especifico(grupo)
    {
        grupo.integrante_mas_debil().tomar_armas(armas)
    }
}
 
class Granja inherits Lugar
{
    override method puede_tomarse_especifico(grupo) = true
    
    override method tomado_por_especifico(grupo)
    {
        grupo.integrantes().forEach({integrante => integrante.comer()})
    }
}
 
class Bosque inherits Lugar
{
    var property tiene_niebla
   
    override method puede_tomarse_especifico(grupo) = not(grupo.integrantes().any({integrante => integrante.armas().any({arma => arma.ruidosa()})}))
    
    override method tomado_por_especifico(grupo)
    {
        if(tiene_niebla)
        {
            var unIntegrante = grupo.integrantes().anyOne()
            unIntegrante.perder_arma(unIntegrante.armas().anyOne())
        }
    }
}