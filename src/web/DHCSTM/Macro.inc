ROUTINE web.DHCSTM.Macro [Type=INC]
#; DHCSTM-内部宏
#; 格式化时间
#define zd(%date,%format) ##class(web.DHCSTM.StkTypeM).ZD(%date,%format)
#define ZD(%date,%format) ##class(web.DHCSTM.StkTypeM).ZD(%date,%format)
