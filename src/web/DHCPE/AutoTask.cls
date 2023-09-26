Class web.DHCPE.AutoTask Extends %Persistent
{

/// Description:自动回传体检结果，包括检查和检验结果	
/// Table：        DHC_PE_Result
/// Input：      BD 向前一天
/// Output：    无
/// Return：    0 正常 -1失败
/// Others：    
ClassMethod AutoTransResult(BD As %Library.String = "")
{
	//d ##class(web.DHCPE.AutoTask).AutoTransResult(1)
	s $ZT="AutoTransResultErr"
	i BD="" s BD=5 ;1天前
	s Date=+$H-BD
	f  s Date=$O(^DHCPEIADM(0,"AdmDateTime",Date))  q:((Date="")||(Date>+$H))  d
	.s Time=""  f  s Time=$O(^DHCPEIADM(0,"AdmDateTime",Date,Time))  q:Time=""  d
	..s IADM="" f  s IADM=$O(^DHCPEIADM(0,"AdmDateTime",Date,Time,IADM))  q:IADM=""  d
	...s PAADM=$P(^DHCPEIADM(IADM),"^",1)
	...q:PAADM=""
	...s Status=$P(^DHCPEIADM(IADM),"^",8)
	...q:Status'="ARRIVED"
	...d ##class(web.DHCPE.TransResult).TransMain(PAADM)
	q "0"

AutoTransResultErr
	q "-1^"_$ZE
}

Storage Default
{
<Data name="AutoTaskDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCPE.AutoTaskD</DataLocation>
<DefaultData>AutoTaskDefaultData</DefaultData>
<IdLocation>^web.DHCPE.AutoTaskD</IdLocation>
<IndexLocation>^web.DHCPE.AutoTaskI</IndexLocation>
<StreamLocation>^web.DHCPE.AutoTaskS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
