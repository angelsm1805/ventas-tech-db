-- ============================================================
-- M4 - CONSULTAS SQL DE NEGOCIO
-- Base de datos: Ventas_Tech_DB
-- Tabla utilizada: ventas
-- ============================================================

USE Ventas_Tech_DB;
GO

-- ============================================================
-- CONSULTA 1 — RESUMEN EJECUTIVO MENSUAL
-- Total facturado, cantidad de pedidos y ticket promedio por mes.
--
-- Nota: la consigna solicita EXTRACT(MONTH FROM fecha_venta),
-- pero la base está creada en SQL Server, donde EXTRACT no existe.
-- MONTH(fecha_venta) es su equivalente en SQL Server.
-- ============================================================

SELECT
    MONTH(fecha_venta) AS mes,
    SUM(cantidad * precio_unitario) AS total_facturado,
    COUNT(*) AS cantidad_pedidos,
    AVG(cantidad * precio_unitario) AS ticket_promedio
FROM ventas
GROUP BY MONTH(fecha_venta)
ORDER BY mes;
GO


-- ============================================================
-- CONSULTA 2 — RANKING DE PRODUCTOS
-- Top 5 de productos por total facturado.
-- ============================================================

SELECT TOP 5
    id_producto,
    SUM(cantidad) AS unidades_vendidas,
    SUM(cantidad * precio_unitario) AS total_generado
FROM ventas
GROUP BY id_producto
ORDER BY total_generado DESC;
GO


-- ============================================================
-- CONSULTA 3 — CLIENTES RECURRENTES
-- Clientes con más de un pedido, mostrando cantidad de pedidos
-- y total gastado.
-- ============================================================

SELECT
    id_cliente,
    COUNT(*) AS cantidad_pedidos,
    SUM(cantidad * precio_unitario) AS total_gastado
FROM ventas
GROUP BY id_cliente
HAVING COUNT(*) > 1
ORDER BY total_gastado DESC;
GO


-- ============================================================
-- CONSULTA 4 — MESES POR ENCIMA / POR DEBAJO DEL PROMEDIO
-- Se calcula primero el total facturado por mes y luego el
-- promedio mensual general.
--
-- Como todos los registros de esta base corresponden a marzo,
-- marzo coincide exactamente con el promedio mensual.
-- Por eso se contempla también la categoría 'Igual al promedio'.
-- ============================================================

WITH facturacion_mensual AS (
    SELECT
        MONTH(fecha_venta) AS mes,
        SUM(cantidad * precio_unitario) AS total_facturado
    FROM ventas
    GROUP BY MONTH(fecha_venta)
)
SELECT
    mes,
    total_facturado,
    CASE
        WHEN total_facturado > (SELECT AVG(total_facturado) FROM facturacion_mensual)
            THEN 'Por encima'
        WHEN total_facturado < (SELECT AVG(total_facturado) FROM facturacion_mensual)
            THEN 'Por debajo'
        ELSE 'Igual al promedio'
    END AS comparacion_promedio
FROM facturacion_mensual
ORDER BY mes;
GO


-- ============================================================
-- HALLAZGOS
-- ============================================================

-- 1. La facturación total registrada en la base es de $6.444,
--    concentrada íntegramente en marzo de 2024.

-- 2. El producto 1 es el principal generador de facturación,
--    con $3.600, equivalente al 55,87% de la facturación total.

-- 3. Los 5 clientes registrados realizaron más de un pedido,
--    por lo que todos califican como clientes recurrentes según
--    el criterio solicitado (COUNT(*) > 1).
