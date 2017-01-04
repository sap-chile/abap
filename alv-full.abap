REPORT  ZALV04.
* Cargamos los datos tipo slis
TYPE-POOLS SLIS.
DATA: G_INT_fieldcat TYPE slis_t_fieldcat_alv,
      G_ST_fieldcat TYPE slis_fieldcat_alv.
* Creamos la estructura de la tabla MARAV
TABLES: MARAV.
DATA: BEGIN OF ST_MARAV.
      INCLUDE STRUCTURE MARAV.
DATA END OF ST_MARAV.
* Creamos la tabla interna con cabecera
DATA INT_MARAV LIKE TABLE OF ST_MARAV WITH HEADER LINE.
* Copiamos los datos tabla MARAV a la tabla interna INT_MARAV
SELECT * FROM MARAV INTO TABLE INT_MARAV UP TO 100 ROWS.
* Llamamos la función para saber todos los campos de la tabla.
DATA: BEGIN OF INT_TAB OCCURS 100.
        INCLUDE STRUCTURE DFIES.
DATA: END OF INT_TAB.
      call function 'DDIF_FIELDINFO_GET'
        exporting
          tabname              = 'MARAV'
*         FIELDNAME            = ' '
          LANGU                = SY-LANGU
*         LFIELDNAME           = ' '
*         ALL_TYPES            = ' '
*       IMPORTING
*         X030L_WA             = WATAB
*         DDOBJTYPE            =
*         DFIES_WA             =
*         LINES_DESCR          =
        TABLES
        DFIES_TAB            = INT_TAB
*       FIXED_VALUES         =
        EXCEPTIONS
        NOT_FOUND            = 1
        INTERNAL_ERROR       = 2
        OTHERS               = 3.
if sy-subrc <> 0.
   WRITE:/ 'No se encuentra los campos'.
 endif.
* Imprimimos en pantalla los valores. Fieldcat
LOOP AT INT_TAB.
G_ST_fieldcat-fieldname = INT_TAB-FIELDNAME.
G_ST_fieldcat-seltext_m = INT_TAB-FIELDTEXT. 
G_ST_fieldcat-seltext_s = INT_TAB-FIELDNAME. 
APPEND G_ST_fieldcat TO G_INT_fieldcat.
ENDLOOP.

* Función para mostrar el ALV
CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
  EXPORTING
    it_fieldcat   = G_INT_fieldcat[]
I_GRID_TITLE  = 'ZALV01/Titulo ALV'
  TABLES
    t_outtab      = INT_MARAV[]
  EXCEPTIONS
    program_error = 1
    OTHERS        = 2.
