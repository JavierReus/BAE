select * from ciclista;
select * from equipo;
select * from etapa;
select * from llevar;
select * from maillot;
select * from puerto;


-- 1) Obtener el código, el tipo, el color y el premio de todos los maillots que hay.
select codigo, tipo, color, premio from maillot;
-- 2) Obtener el dorsal y el nombre de los ciclistas cuya edad sea menor o igual que 25 años.
select dorsal, nombre from ciclista where edad <= 25;
-- 3) Obtener el nombre y la altura de todos los puertos de categoría 'E' (Especial).
select nompuerto, altura from puerto where categoria = 'E';
-- 4) Obtener el valor del atributo netapa de aquellas etapas con salida y llegada en la misma ciudad.
select netapa from etapa where llegada = salida;
-- 5) ¿Cuántos ciclistas hay?
select count(*) from ciclista;
-- 6) ¿Cuántos ciclistas hay con edad superior a 25 años?
select count(*) as ciclistas from ciclista where edad > 25;
-- 7) ¿Cuántos equipos hay?
select count(*) as equipos from equipo;
-- 8) Obtener la media de edad de los ciclistas.
select round(avg(edad)::numeric, 2) from ciclista;
-- 9) Obtener la altura mínima y máxima de los puertos de montaña.
select min(altura) as alturaMinima, max(altura) as alturaMaxima from puerto;
-- 10) Obtener el nombre de cada ciclista junto con el nombre del equipo al que pertenece
select nombre, nomeq from ciclista;
-- 11) Obtener el nombre de los ciclistas que sean de Banesto.
select nombre from ciclista where nomeq = 'Banesto';
-- 12) ¿Cuántos ciclistas pertenecen al equipo Amore Vita?
select count(*) as ciclistas from ciclista where nomeq = 'Amore Vita';
-- 13) Edad media de los ciclistas del equipo TVM.
select round(avg(edad)::numeric, 2) as ciclistas from ciclista where nomeq = 'TVM';
-- 14) Nombre de los ciclistas que pertenezcan al mismo equipo que Miguel Indurain
select nombre from ciclista where nomeq = 'Banesto';
-- 15) Nombre de los ciclistas que han ganado alguna etapa.
select  distinct ciclista.nombre
from ciclista 
inner join etapa on ciclista.dorsal =  etapa.dorsal;
-- 16) Nombre de los ciclistas que han llevado el maillot General.
select nombre 
from ciclista
inner join llevar on llevar.dorsal = ciclista.dorsal
where codigo = 'MGE';
-- 17) Obtener el nombre del ciclista más joven
select nombre, min(edad) from ciclista where edad = (select min(edad) from ciclista) group by nombre;
-- 18) Obtener el número de ciclistas de cada equipo.
select nomeq, count(*) as numCiclista from ciclista group by nomeq;
-- 19) Obtener el nombre de los equipos que tengan más de 5 ciclistas.
select nomeq, count(*) as ciclistas from ciclista group by nomeq  having count(*) > 5;
-- 20) Obtener el número de puertos que ha ganado cada ciclista.
select ciclista.nombre, count(*) as numPuertos 
from ciclista
inner join puerto on puerto.dorsal = ciclista.dorsal
group by ciclista.nombre;
-- 21) Obtener el nombre de los ciclistas que han ganado más de un puerto.
select ciclista.nombre, count(*) as numPuerto
from ciclista
inner join puerto on puerto.dorsal = ciclista.dorsal
group by ciclista.nombre
having count(*) > 1;
-- 22) Obtener el nombre y el director de los equipos a los que pertenezca algún ciclista mayor de 33 años.
select nombre, director 
from equipo
inner join ciclista on equipo.nomeq = ciclista.nomeq
where edad > 33;
-- 23) Nombre de los ciclistas que no pertenezcan a Kelme
select  distinct nombre from ciclista where not nomeq <> 'Kelme';
-- 24) Nombre de los ciclistas que no hayan ganado ninguna etapa.
select distinct ciclista.nombre 
from ciclista
left join etapa on ciclista.dorsal = etapa.dorsal
where etapa.dorsal is  null;
-- 25) Nombre de los ciclistas que no hayan ganado ningún puerto de montaña.
select distinct nombre 
from ciclista 
left join puerto on puerto.dorsal = ciclista.dorsal
where puerto.dorsal is  null;
-- 26) Nombre de los ciclistas que hayan ganado más de un puerto de montaña.
select ciclista.nombre, count(*) as numPuerto
from ciclista
inner join puerto on ciclista.dorsal = puerto.dorsal
group by ciclista.nombre
having count(*) > 1;

-- 27) ¿Qué ciclistas han llevado el mismo maillot que Miguel Indurain?


select distinct c2.nombre
from ciclista c1
inner join llevar l1 on c1.dorsal = l1.dorsal
inner join llevar l2 on l1.codigo = l2.codigo
inner join ciclista c2 on l2.dorsal = c2.dorsal
where c1.nombre = 'Miguel Indurain'
  and c2.nombre <> 'Miguel Indurain';
-- 28) De cada equipo obtener la edad media, la máxima edad y la mínima edad.
select * from llevar;
select nomeq, avg(edad), max(edad), min(edad)
from ciclista
group by nomeq;
-- 29) Nombre de aquellos ciclistas que tengan una edad entre 25 y 30 años y que no pertenezcan a los equipos Kelme y Banesto.
select * from ciclista;
select nombre
from ciclista
where nomeq not in ('kelme', 'Banesto')
and edad between 25 and 30;
-- 30) Nombre de los ciclistas que han ganado la etapa que comienza en Zamora.
select * from etapa;
select nombre
from ciclista 
inner  join etapa on ciclista.dorsal = etapa.dorsal
where etapa.salida = 'Zamora';
-- 31) Obtén el nombre y la categoría de los puertos ganados por ciclistas del equipo 'Banesto'.
select puerto.nompuerto, puerto.categoria, ciclista.nombre
from ciclista
inner join puerto on puerto.dorsal = ciclista.dorsal
where ciclista.nomeq = 'Banesto';
-- 32) Obtener el nombre de cada puerto indicando el número (netapa) y los kilómetros de la etapa en la que se encuentra el puerto.
select puerto.nompuerto, puerto.netapa, etapa.km
from puerto
left join etapa on etapa.netapa = puerto.netapa;
-- 33) Obtener el nombre de los ciclistas con el color de cada maillot que hayan llevado.
select * from ciclista;
select * from llevar;
select * from maillot;

select ciclista.nombre, maillot.color
from ciclista
inner join llevar on llevar.dorsal = ciclista.dorsal
inner join maillot on maillot.codigo = llevar.codigo;
-- 34) Obtener el valor del atributo netapa de las etapas que no comienzan en la misma ciudad en que acabó la anterior etapa.
select e2.netapa
from etapa e1
inner join etapa e2 on e2.netapa = e1.netapa + 1
where e2.salida <> e1.llegada;
-- 35) Obtener el valor del atributo netapa y la ciudad de salida de aquellas etapas que no tengan puertos de montaña.
select etapa.netapa, etapa.salida
from etapa
left join puerto on etapa.netapa = puerto.netapa
where puerto.netapa is null;
-- 36) Obtener la edad media de los ciclistas que han ganado alguna etapa.
select avg(ciclista.edad) as edad_media
from ciclista
inner join etapa on ciclista.dorsal = etapa.dorsal;

-- 37) Selecciona el nombre de los puertos con una altura superior a la altura media de todos los puertos.

-- 38) Obtener el nombre de la ciudad de salida y de llegada de las etapas donde estén los puertos con mayor pendiente.

-- 39) Obtener el dorsal y el nombre de los ciclistas que han ganado los puertos de mayor altura.

-- 40) Obtener el nombre del ciclista más joven que ha ganado al menos una etapa.

-- 41) Obtener el nombre y el director de los equipos tales que todos sus ciclistas son mayores de 20 años.

-- 42) Obtener el dorsal y el nombre de los ciclistas tales que todas las etapas que han ganado tienen al menos 150 km (es decir que sólo han ganado etapas de más o igual a 150 km).

-- 43) Obtener el nombre de los ciclistas que han ganado una etapa y algún puerto de esa misma etapa.

-- 44) Obtener el nombre de todos los equipos indicando cuántos ciclistas tiene cada uno.

-- 45) Obtener el director y el nombre de los equipos que tengan más de 3 ciclistas y cuya edad media sea igual o inferior a 30 años.

-- 46) Obtener el nombre de los ciclistas que pertenezcan a un equipo que tenga más de cinco corredores y que hayan ganado alguna etapa indicando cuántas etapas ha ganado.

-- 47) Obtener el nombre de los equipos y la edad media de sus ciclistas de aquellos equipos que tengan la media de edad máxima de todos los equipos.

-- 48) Obtener el código y el color del maillot que ha sido llevado por algún ciclista que no ha ganado ninguna etapa.

-- 49) Obtener el valor del atributo netapa, la ciudad de salida y la ciudad de llegada de las etapas de más de 190 km y que tengan por lo menos dos puertos.

-- 50) Obtener el dorsal y el nombre de los ciclistas que no han llevado todos los maillots que ha llevado el ciclista de dorsal 2.

-- 51) Obtener el dorsal y el nombre del ciclista que ha llevado durante más kilómetros un mismo maillot e indicar también el color de dicho maillot.

-- 52) Obtener el dorsal y el nombre de los ciclistas que han llevado dos tipos de maillot menos de los que ha llevado el ciclista de dorsal 3.

-- 53) Obtener el valor del atributo netapa y los km de las etapas que tienen puertos de montaña.