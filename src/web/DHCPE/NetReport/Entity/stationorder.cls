Class web.DHCPE.NetReport.Entity.stationorder Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter XMLIGNOREINVALIDTAG = 1;

Property hisstation As %String(TRUNCATE = 1);

Property orders As list Of web.DHCPE.NetReport.Entity.order;

Storage Default
{
<Data name="stationorderDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCPE.NetR94C.stationorderD</DataLocation>
<DefaultData>stationorderDefaultData</DefaultData>
<IdLocation>^web.DHCPE.NetR94C.stationorderD</IdLocation>
<IndexLocation>^web.DHCPE.NetR94C.stationorderI</IndexLocation>
<StreamLocation>^web.DHCPE.NetR94C.stationorderS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
