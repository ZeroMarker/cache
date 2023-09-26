ROUTINE web.DHCSTPIVAS.Base [Type=INC]
#define MaxStr "￿"
#define PIVASVAR %zPHAPIVAS
#define pivasError4Sql(%tmpError) ##class(web.DHCSTPIVAS.Exception).Error4Sql(%tmpError) 