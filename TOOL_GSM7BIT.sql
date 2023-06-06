CREATE OR REPLACE PACKAGE TOOL_GSM7BIT AS

    FUNCTION dec2bin (N IN NUMBER) RETURN VARCHAR2;
    FUNCTION bin2dec (p_binary VARCHAR2) RETURN NUMBER;
    FUNCTION gsm7bit2ascii( inputValue IN VARCHAR2 ) RETURN VARCHAR2;
    FUNCTION ascii2gsm7bit( inputValue IN VARCHAR2 ) RETURN VARCHAR2;

END TOOL_GSM7BIT;
/

CREATE OR REPLACE PACKAGE BODY TOOL_GSM7BIT AS
    
    FUNCTION dec2bin (N IN NUMBER) RETURN VARCHAR2 
    IS
             binval VARCHAR2(64);
             N2 NUMBER := N;
    BEGIN
         WHILE ( N2 > 0 ) LOOP
               binval := MOD(N2, 2) || binval;
               N2 := TRUNC( N2 / 2 );
         END LOOP;
         RETURN binval;
    END dec2bin;

    FUNCTION bin2dec(p_binary varchar2) RETURN NUMBER
    IS
             l_mynumber NUMBER:=0;
             l_mybinary VARCHAR2(2048):=p_binary;
             i number :=0;
    BEGIN
         WHILE length(l_mybinary) > 0 LOOP
           l_mynumber:=l_mynumber+(substr(l_mybinary,-1,1)*power(2,i));
           l_mybinary:=substr(l_mybinary,1,length(l_mybinary)-1);
           i:=i+1;
         END LOOP;
         RETURN l_mynumber;
    END;

    FUNCTION gsm7bit2ascii( inputValue IN VARCHAR2 ) RETURN varchar2 
    IS
             ResultString varchar2(1280); -- 160 x 8
             -- FOR DEBUG
             OctectString varchar2(1280); -- 160 x 8
             AsciiString varchar2(1280); -- 160 x 8
             TempBinary number;
             bitToExtr number;
             appoBits  varchar2(8);
    BEGIN

         FOR i IN 1..LENGTH( inputValue ) LOOP
             TempBinary := dec2bin ( to_number( substr( inputValue,i,1 ),'x' ) );
             ResultString := ResultString || LPAD(NVL(TempBinary,'0'),4,'0');
         END LOOP;

         -- OCTECT
         bitToExtr := 0;
         appoBits := '';
         FOR i IN 1..LENGTH(ResultString)/8 LOOP
             bitToExtr := bitToExtr + 1;
             --OctectString := OctectString || '[' || SUBSTR(ResultString,8*(i-1),8) || ']-';
             IF bitToExtr >= 8 THEN
                bitToExtr := 1;
                OctectString := OctectString || SUBSTR(ResultString,bitToExtr+8*(i-2),8-bitToExtr);
                appoBits := '';
             END IF;
             OctectString := OctectString || SUBSTR(ResultString,bitToExtr+1+8*(i-1),8-bitToExtr) || appoBits;
             appoBits := SUBSTR(ResultString,8*(i-1)+1,bitToExtr);
         END LOOP;

         OctectString := OctectString || appoBits;

         -- SEPTET
         FOR i IN 1..LENGTH(OctectString)/7 LOOP
--             AsciiString := AsciiString || '[' || SUBSTR(OctectString,7*(i-1)+1,7) || ']{' || CHR(bin2dec(SUBSTR(OctectString,7*(i-1)+1,7))) || ']';
             AsciiString := AsciiString || CHR(bin2dec(SUBSTR(OctectString,7*(i-1)+1,7)));
         END LOOP;

         return AsciiString;
    END gsm7bit2ascii;

    FUNCTION ascii2gsm7bit( inputValue IN VARCHAR2 ) RETURN varchar2 
    IS
       AsciiString varchar2(1280); -- 160 x 8
       ResultString varchar2(1280); -- 160 x 8
       TempBinary number;
       bitToExtr number;
       appoBits  varchar2(8);
       jump number;
       OctectString varchar2(1280); -- 160 x 8

    BEGIN
         FOR i IN 1..LENGTH( inputValue ) LOOP
             TempBinary := dec2bin ( ASCII(substr( inputValue,i,1 )) );
--             ResultString := ResultString || '[' || ASCII(substr( inputValue,i,1 )) || ']' || LPAD(NVL(TempBinary,'0'),7,'0');
             ResultString := ResultString || LPAD(NVL(TempBinary,'0'),7,'0');
         END LOOP;

         -- SEPTET
         bitToExtr := 0;
         jump := 0; 
         appoBits := '';
         FOR i IN 1..LENGTH(ResultString)/7-1 LOOP
             bitToExtr := bitToExtr + 1;
             IF bitToExtr > 7 THEN
                bitToExtr := 1;
                jump := jump + 1;
             END IF;
             appoBits := SUBSTR(ResultString,7*(i)+7-bitToExtr+1+7*jump,bitToExtr);
--             OctectString := OctectString || '[' || LPAD(NVL(appoBits,'0'),bitToExtr,'0') || ']' || SUBSTR(ResultString,1+7*(i-1)+7*jump,7-bitToExtr+1);
             OctectString := OctectString || LPAD(NVL(appoBits,'0'),bitToExtr,'0') || SUBSTR(ResultString,1+7*(i-1)+7*jump,7-bitToExtr+1);
         END LOOP;

         FOR i IN 1..LENGTH(OctectString)/8 LOOP
             AsciiString := AsciiString || TO_CHAR(bin2dec(SUBSTR(OctectString,8*(i-1)+1,8)),'0X');
         END LOOP;

         return REPLACE(AsciiString,' ');
    END ascii2gsm7bit;

END TOOL_GSM7BIT;
/

-- TEST EXAMPLE 
--select scktool_conv.gsm7bit2ascii('CDB27C1C26BF9969BBBC0C') from dual;
--select scktool_conv.gsm7bit2ascii('E8329BFD4697D9EC37') from dual;
--select scktool_conv.ascii2gsm7bit('MercadoLivre') from dual;
--select scktool_conv.ascii2gsm7bit('MIINFINITY') from dual;
