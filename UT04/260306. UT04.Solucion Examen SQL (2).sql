-- EXAMEN UT4 BASES DE DATOS, A 6 DE MARZO DE 2026

-- 1. Mostrar todas las películas que cuesten entre 25€ y 30€ ambos incluidos.
-- PUNTUACION: 0,25

  -- SOLUCION 1.1 
      SELECT *
      FROM peliculas
      WHERE precio BETWEEN 25 AND 30;

  -- SOLUCION 1.2
      SELECT * 
      FROM peliculas 
      WHERE precio>=25 and precio<=30;

-- 2. Mostrar el nombre de todos los clientes cuyo nombre tenga como segunda letra la ‘a’.
--    Añadir un alias al campo nombre llamado: Nombres filtrados.
-- PUNTUACION: 0,25

  -- SOLUCION 2.1 
      SELECT nombre AS "Nombres filtrados"
      FROM clientes
      WHERE nombre LIKE '_a%';

-- 3. Mostrar todos los municipios (sin repetir) en las que hay registrados clientes.
-- PUNTUACION: 0,25

  -- SOLUCION 3.1
      SELECT DISTINCT municipio
      FROM clientes;

-- 4. Muestra el nombre de las películas que se han dado de alta entre 1990 y 1999,
--    y que no cuesten 39,95€.
-- PUNTUACION: 0,50

  -- SOLUCIÓN 4.1
      SELECT nombre
      FROM peliculas
      WHERE fechaAlta BETWEEN DATE '1990-01-01' AND DATE '1999-12-31'
        AND precio <> 39.95;

-- 5. Mostrar los nombres de las películas que contengan ‘Harry’ en el título de la película
--    y que exista más de 12 películas en su stock.
-- PUNTUACION: 0,50

-- SOLUCIÓN 5.1
      SELECT nombre
      FROM peliculas
      WHERE nombre LIKE '%Harry%'
        AND stock > 12;

-- 6. Obtener el total del precio de todas las películas por director (código),
--    de los directores que sumen más de 250€.
-- PUNTUACION: 0,50

  -- SOLUCIÓN 6.1
      SELECT codDirector, SUM(precio) AS total_precio
      FROM peliculas
      GROUP BY codDirector
      HAVING SUM(precio) > 250;

-- 7. Obtener el número de clientes por municipio de los municipios con más de 1 cliente.
--    Mostrar el alias: “N.º Clientes”.
-- PUNTUACION: 0,75

-- SOLUCIÓN 7.1
      SELECT municipio, COUNT(*) AS "N.º Clientes"
      FROM clientes
      GROUP BY municipio
      HAVING COUNT(*) > 1;

-- SOLUCIÓN 7.2
      SELECT municipio, COUNT(dniCliente) as "N.º Clientes" 
      FROM Clientes
	    GROUP BY municipio 
      HAVING COUNT(dniCliente) > 1;

-- 8. Obtener el año de nacimiento y el número de directores que hayan nacido entre 1960 y 1965.
--    Ordenados por fecha de nacimiento de más antigua a más reciente.
-- PUNTUACION: 0,50

-- SOLUCIÓN 8.1
      SELECT EXTRACT(YEAR FROM fechaNac)::INT AS anio_nacimiento,
            COUNT(*) AS num_directores
      FROM directores
      WHERE fechaNac BETWEEN DATE '1960-01-01' AND DATE '1965-12-31'
      GROUP BY EXTRACT(YEAR FROM fechaNac)
      ORDER BY anio_nacimiento ASC;

-- SOLUCIÓN 8.2
      SELECT EXTRACT(YEAR FROM fechaNac), count(nombre) 
      FROM directores
      WHERE fechaNac BETWEEN '1960-01-01' and '1965-12-31'
      GROUP BY fechaNac
      ORDER BY fechaNac;

-- 9. Obtener la media de los precios correspondientes a las películas del director con el código 3.
-- PUNTUACION: 0,25

-- SOLUCIÓN 9.1
      SELECT AVG(precio) AS media_precio
      FROM peliculas
      WHERE codDirector = 3;

-- 10. Mostrar el nombre y el stock de las dos películas más caras.
-- PUNTUACION: 0,25

-- SOLUCIÓN 10.1
      SELECT nombre, stock
      FROM peliculas
      ORDER BY precio DESC
      LIMIT 2;

-- 11. Mostrar el nombre, el stock, el precio y el año que se dio de alta la primera película de la BBDD.
-- PUNTUACION: 0,50

-- SOLUCIÓN 11.1
      SELECT nombre,
            stock,
            precio,
            EXTRACT(YEAR FROM fechaAlta)::INT AS anio_alta
      FROM peliculas
      ORDER BY fechaAlta ASC NULLS LAST, codPelicula ASC
      LIMIT 1;

-- SOLUCIÓN 11.2
      SELECT nombre, stock, precio, fechaAlta 
      FROM peliculas
	    WHERE fechaAlta = (SELECT min(fechaAlta) 
                         FROM peliculas);                                                      

-- 12. Mostrar el precio medio gastado en películas de todos los clientes residentes en Las Palmas de Gran Canaria.
-- PUNTUACION: 0,75

-- SOLUCIÓN 12.1
      SELECT AVG(p.precio) AS precio_medio_gastado
      FROM compras co
      INNER JOIN clientes c  ON c.dniCliente = co.dniCliente
      INNER JOIN peliculas p ON p.codPelicula = co.codPelicula
      WHERE c.municipio = 'Las Palmas de Gran Canaria';

-- SOLUCIÓN 12.2
      SELECT AVG(p.precio) AS precio_medio_gastado
      FROM peliculas p
      WHERE p.codPelicula IN (
        SELECT co.codPelicula
        FROM compras co
        WHERE co.dniCliente IN (
          SELECT c.dniCliente
          FROM clientes c
          WHERE c.municipio = 'Las Palmas de Gran Canaria'
        )
      );

-- 13. Mostrar el nombre de los clientes por orden alfabético que hayan comprado alguna película.
-- PUNTUACION: 0,50

-- SOLUCIÓN 13.1
      SELECT DISTINCT c.nombre
      FROM clientes c
      INNER JOIN compras co ON co.dniCliente = c.dniCliente
      ORDER BY c.nombre;

-- SOLUCIÓN 13.2
      SELECT nombre
      FROM clientes
      WHERE dniCliente IN (SELECT dniCliente 
                           FROM compras)
      ORDER BY nombre;

-- 14. Mostrar el nombre de los clientes que hayan comprado la última película registrada en el sistema.
-- PUNTUACION: 0,75

-- SOLUCIÓN 14.1
      SELECT DISTINCT c.nombre
      FROM clientes c
      INNER JOIN compras co ON co.dniCliente = c.dniCliente
      INNER JOIN peliculas p ON p.codPelicula = co.codPelicula
      WHERE p.codPelicula = (SELECT MAX(fechaAlta) FROM peliculas);

-- SOLUCIÓN 14.2
      SELECT DISTINCT c.nombre
      FROM clientes c
      WHERE c.dniCliente IN (
        SELECT co.dniCliente
        FROM compras co
        WHERE co.codPelicula = (SELECT MAX(fechaAlta) 
                                FROM peliculas)
);

-- SOLUCIÓN 14.3
      SELECT nombre FROM clientes
        WHERE dniCliente IN 
          (SELECT dniCliente FROM compras 
            WHERE codPelicula = 
              (SELECT codPelicula FROM peliculas 
                WHERE fechaAlta = (SELECT max(fechaAlta) FROM peliculas)));

-- 15. Mostrar el nombre de las películas que haya comprado el cliente más joven.
-- PUNTUACION: 0,75

-- SOLUCIÓN 15.1
      SELECT DISTINCT p.nombre
      FROM peliculas p
      INNER JOIN compras co  ON co.codPelicula = p.codPelicula
      INNER JOIN clientes c  ON c.dniCliente = co.dniCliente
      WHERE c.fechaNac IS NOT NULL
        AND c.dniCliente = (
          SELECT dniCliente
          FROM clientes
          WHERE fechaNac IS NOT NULL
          ORDER BY fechaNac DESC
          LIMIT 1
        );

-- SOLUCIÓN 15.2
      SELECT DISTINCT p.nombre
      FROM peliculas p
      WHERE p.codPelicula IN (
        SELECT co.codPelicula
        FROM compras co
        WHERE co.dniCliente = (
          SELECT dniCliente
          FROM clientes
          WHERE fechaNac IS NOT NULL
          ORDER BY fechaNac DESC
          LIMIT 1
        )
      );

-- 16. Mostrar el nombre de todos los directores junto con el nombre de sus películas.
--     Aunque haya directores sin películas en la BBDD también se deben mostrar.
-- OJO: aquí NO puede ser INNER JOIN si hay que mostrar directores sin películas.
-- PUNTUACION: 0,50

-- SOLUCION 16.1
      SELECT d.nombre AS director,
            p.nombre AS pelicula
      FROM directores d
      LEFT JOIN peliculas p ON p.codDirector = d.codDirector
      ORDER BY d.nombre, p.nombre;

-- 17. Obtener el número de películas que ha comprado cada cliente (nombre y dni)
--     de Las Palmas de Gran Canaria o Arucas. Mostrar solo los que han comprado
--     más de 3 películas y ordenado de menor a mayor número de películas.
-- PUNTUACION: 0,75

-- SOLUCIÓN 17.1
      SELECT c.dniCliente,
             c.nombre,
             COUNT(*) AS num_peliculas
      FROM clientes c
        INNER JOIN compras co ON co.dniCliente = c.dniCliente
      WHERE c.municipio IN ('Las Palmas de Gran Canaria', 'Arucas')
      GROUP BY c.dniCliente, c.nombre
      HAVING COUNT(*) > 3
      ORDER BY num_peliculas ASC;

-- SOLUCIÓN 17.2
      SELECT c.dniCliente,
            c.nombre,
            (SELECT COUNT(*)
              FROM compras co
              WHERE co.dniCliente = c.dniCliente) AS num_peliculas
      FROM clientes c
      WHERE c.municipio IN ('Las Palmas de Gran Canaria', 'Arucas')
        AND (SELECT COUNT(*) 
             FROM compras co 
            WHERE co.dniCliente = c.dniCliente) > 3
      ORDER BY num_peliculas ASC;

-- 18. Mostrar todas las películas compradas por Raquel, así como su fecha de compra.
-- PUNTUACION: 0,50

-- SOLUCIÓN 18.1
      SELECT p.nombre AS pelicula,
            co.fechaCompra
      FROM compras co
        INNER JOIN clientes c  ON c.dniCliente = co.dniCliente
        INNER JOIN peliculas p ON p.codPelicula = co.codPelicula
      WHERE c.nombre = 'Raquel'
      ORDER BY co.fechaCompra;

-- SOLUCIÓN 18.2
      SELECT p.nombre AS pelicula,
            co.fechaCompra
      FROM compras co
        INNER JOIN peliculas p ON p.codPelicula = co.codPelicula
      WHERE co.dniCliente IN (SELECT dniCliente
                              FROM clientes
                              WHERE nombre = 'Raquel')
      ORDER BY co.fechaCompra;

-- 19. Mostrar el nombre de los clientes (por orden alfabético) que hayan comprado
--     alguna película de Quentin Tarantino.
-- PUNTUACION: 0,50

-- SOLUCIÓN 19.1     
      SELECT DISTINCT c.nombre
      FROM clientes c
        INNER JOIN compras co    ON co.dniCliente = c.dniCliente
        INNER JOIN peliculas p   ON p.codPelicula = co.codPelicula
        INNER JOIN directores d  ON d.codDirector = p.codDirector
      WHERE d.nombre = 'Quentin Tarantino'
      ORDER BY c.nombre;

-- SOLUCIÓN 19.2
      SELECT DISTINCT c.nombre
      FROM clientes c
      WHERE c.dniCliente IN (
            SELECT co.dniCliente
            FROM compras co
            WHERE co.codPelicula IN (
                  SELECT p.codPelicula
                  FROM peliculas p
                  WHERE p.codDirector IN (
                        SELECT d.codDirector
                        FROM directores d
                        WHERE d.nombre = 'Quentin Tarantino'
                  )     
            )
      )
      ORDER BY c.nombre;

-- 20. Mostrar el nombre de la última película comprada en el sistema.
-- PUNTUACION: 0,50

-- SOLUCIÓN 20.1
      SELECT p.nombre
      FROM compras co
        INNER JOIN peliculas p ON p.codPelicula = co.codPelicula
      ORDER BY co.fechaCompra DESC
      LIMIT 1;

-- SOLUCIÓN 20.2
      SELECT nombre
      FROM peliculas
      WHERE codPelicula = (
            SELECT co.codPelicula
            FROM compras co
            ORDER BY co.fechaCompra DESC
            LIMIT 1
         );

-- SOLUCION 20.3
      SELECT nombre 
      FROM peliculas 
      WHERE codPelicula IN 
            (SELECT codPelicula 
            FROM compras 
            WHERE fechaCompra = (SELECT max(fechaCompra) 
                                 FROM compras));