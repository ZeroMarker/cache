Class web.DHCPE.EkgInterface.Main Extends %Persistent
{

/// w ##class(web.DHCPE.EkgInterface.Main).GetEkgImgSrc("13250793||9")
ClassMethod GetEkgImgSrc(OEID)
{
	q ##class(web.DHCEkgInternalService).GetEKGReportImg(OEID,"")
	
	s $ZT="EkgErrInfo"
	s PAADM=$P(^OEORD(+OEID),"^",1)
	s AdmDate=$P(^PAADM(+PAADM),"^",6)
	q:AdmDate<63277 "NONE"
	s obj=##class(EkgImgReport1Soap).%New()
	q obj.getEkgImgReport(OEID)
EkgErrInfo
	q "NONE"
}

Storage Default
{
<Data name="MainDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCPE.EkgInterface.MainD</DataLocation>
<DefaultData>MainDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^web.DHCPE.EkgInterface.MainD</IdLocation>
<IndexLocation>^web.DHCPE.EkgInterface.MainI</IndexLocation>
<StreamLocation>^web.DHCPE.EkgInterface.MainS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
