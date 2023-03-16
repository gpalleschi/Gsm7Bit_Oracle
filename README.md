# Gsm7Bit_Oracle

Oracle PLSQL Package for GSM 7bit with encode and decode functions.  

- Description of Gsm 7Bit https://en.wikipedia.org/wiki/GSM_03.38 

Examples :  

```
SCKTOOL_CONV.GSM7BIT2ASCII('C769F3264C52414F27E8290D0E9945')
--------------------------------------------------------------------------------
GSM7BIT ON ORACLE

SCKTOOL_CONV.GSM7BIT2ASCII('E8329BFD4697D9EC37')
--------------------------------------------------------------------------------
hellohello

SCKTOOL_CONV.ASCII2GSM7BIT('HELLOWORLD')
--------------------------------------------------------------------------------
C8329BFD065DDF723619

SCKTOOL_CONV.ASCII2GSM7BIT('GSM7BITONORACLE')
--------------------------------------------------------------------------------
C769F3264C52414F27E8290D0E9945
```


## Built With :

Visual Code Editor  

## Authors

* **Giovanni Palleschi** - [gpalleschi](https://github.com/gpalleschi)   

## Prerequisites :

Tested with Oracle 12.1.0  

## License :

This project is licensed under the GNU GENERAL PUBLIC LICENSE 3.0 License - see the [LICENSE](LICENSE) file for details

