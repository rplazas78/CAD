/
SET SERVEROUTPUT ON;
CLEAR SCREEN;
VARIABLE emp_data REFCURSOR;
EXECUTE PAQUETE_ACTUALIZACION_PREDIOS.SP_ACTUALIZAR_PREDIOS_1('AAA0140KKBS', 1,:emp_data);
PRINT :emp_data;
SELECT T.* FROM TBL_TEMP_RESULTADO_PREDIOS T ORDER BY NUM_CONSECUTIVO;
SELECT T.* FROM TBL_TEMP_RESULTADO_ANALISIS_GEOMETRIA_PREDIOS T ORDER BY NUM_CONSECUTIVO;
SELECT T.* FROM TBL_DATOS_URBANISTICOS T

----------------------

SET SERVEROUTPUT OFF;
CLEAR SCREEN;


DECLARE
    -- Declarar un cursor explícito para iterar sobre los datos de la tabla
    CURSOR chip_cursor IS
        SELECT DISTINCT CHIP FROM TBL_DATOS_URBANISTICOS ORDER BY CHIP;
    
    -- Variable para almacenar el valor actual del chip
    chip_value TBL_DATOS_URBANISTICOS.CHIP%TYPE;
    
    -- REFCURSOR para el procedimiento
    emp_data SYS_REFCURSOR;
    
    -- Variables para medir el tiempo
    start_time TIMESTAMP;
    end_time TIMESTAMP;
    elapsed_minutes NUMBER;
BEGIN
    -- Captura el tiempo de inicio
    start_time := SYSTIMESTAMP;


    -- Abrir el cursor
    OPEN chip_cursor;
    LOOP
        -- Recuperar cada fila del cursor
        FETCH chip_cursor INTO chip_value;
        
        -- Salir del ciclo cuando no haya más filas
        EXIT WHEN chip_cursor%NOTFOUND;
        
        DBMS_OUTPUT.PUT_LINE('Procesando CHIP: ' || chip_value);
        
        
        -- Llamar al procedimiento con el chip actual
        PAQUETE_ACTUALIZACION_PREDIOS.SP_ACTUALIZAR_PREDIOS_1(chip_value, emp_data);
        
        -- Opcional: Realizar alguna acción con el ref cursor emp_data
        -- Por ejemplo, consumir los datos del REFCURSOR (esto depende del caso de uso)
        IF emp_data%ISOPEN THEN
            CLOSE emp_data;
        END IF;
    END LOOP;
    
    -- Cerrar el cursor
    CLOSE chip_cursor;
    
    
    -- Captura el tiempo de fin
    end_time := SYSTIMESTAMP;

    -- Calcula el tiempo transcurrido en minutos
    elapsed_minutes := EXTRACT(MINUTE FROM (end_time - start_time)) +
                       EXTRACT(SECOND FROM (end_time - start_time)) / 60;

    -- Imprime el tiempo transcurrido
    DBMS_OUTPUT.PUT_LINE('Tiempo transcurrido: ' || elapsed_minutes || ' minutos');
    
    
END;
/
