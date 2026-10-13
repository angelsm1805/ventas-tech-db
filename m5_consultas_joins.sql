```sql
-- ============================================================
-- M5 - CONSULTAS SQL CON JOINS Y UNION ALL
-- Base de datos: Ventas_Tech_DB
-- Proyecto: Ventas Tech
-- Motor: Microsoft SQL Server
-- ============================================================

USE Ventas_Tech_DB;
GO


-- ============================================================
-- CONSULTA 1: VISTA BASE DEL PROYECTO (INNER JOIN)
-- Ventas enriquecidas con datos de clientes, productos
-- y categorias para su posterior analisis en Power BI.
-- ============================================================

SELECT
    v.fecha_venta,
    c.id_cliente,
    c.nombre AS nombre_cliente,
    c.email,
    c.ciudad,
    p.id_producto,
    p.nombre_producto,
    cat.nombre_categoria AS categoria,
    v.cantidad,
    v.precio_unitario,
    v.cantidad * v.precio_unitario AS total_venta
FROM ventas v
INNER JOIN clientes c
    ON v.id_cliente = c.id_cliente
INNER JOIN productos p
    ON v.id_producto = p.id_producto
INNER JOIN categorias cat
    ON p.id_categoria = cat.id_categoria
ORDER BY v.fecha_venta;
GO


-- ============================================================
-- CONSULTA 2: CLIENTES SIN VENTAS (LEFT JOIN)
-- Identifica clientes registrados que nunca realizaron compras.
-- Muestra nombre, email y fecha de registro.
-- ============================================================

SELECT
    c.nombre AS nombre_cliente,
    c.email,
    c.fecha_registro
FROM clientes c
LEFT JOIN ventas v
    ON c.id_cliente = v.id_cliente
WHERE v.id_venta IS NULL
ORDER BY c.nombre;
GO


-- ============================================================
-- CONSULTA 3: PRODUCTOS SIN VENTAS (LEFT JOIN)
-- Identifica productos del catalogo que no registran ventas.
-- Muestra nombre, categoria y precio.
-- ============================================================

SELECT
    p.nombre_producto,
    cat.nombre_categoria AS categoria,
    p.precio
FROM productos p
INNER JOIN categorias cat
    ON p.id_categoria = cat.id_categoria
LEFT JOIN ventas v
    ON p.id_producto = v.id_producto
WHERE v.id_venta IS NULL
ORDER BY p.nombre_producto;
GO


-- ============================================================
-- CONSULTA 4: CONSOLIDADO POR CANAL (UNION ALL)
-- Se utilizan dos periodos no superpuestos como origenes
-- de ejemplo: hasta el 10/03/2024 y desde el 11/03/2024.
-- Cada venta queda asignada a un unico grupo.
-- ============================================================

SELECT
    canal,
    SUM(total) AS total_canal
FROM (
    SELECT
        fecha_venta,
        cantidad * precio_unitario AS total,
        'Hasta el 10 de marzo' AS canal
    FROM ventas
    WHERE fecha_venta < '2024-03-11'

    UNION ALL

    SELECT
        fecha_venta,
        cantidad * precio_unitario AS total,
        'Desde el 11 de marzo' AS canal
    FROM ventas
    WHERE fecha_venta >= '2024-03-11'
) AS consolidado
GROUP BY canal
ORDER BY canal;
GO


-- ============================================================
-- FIN DEL ARCHIVO M5
-- ============================================================
```
