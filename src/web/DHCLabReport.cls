Class web.DHCLabReport Extends %Persistent
{

ClassMethod GetLabTestNo(LabRowidStr As %String) As %String
{
 if LabRowidStr="" q "-1"
 Set RetStr=""
 Set StrLen=$l(LabRowidStr,"^")
 For i=1:1:StrLen d
 .Set LabRowid=$P(LabRowidStr,"^",i)
 .Set OeordRowid=$P(LabRowid,"||",1)
 .Set OEORIChildsub=$P(LabRowid,"||",2)
 .Set LabTestSetRow=$p($G(^OEORD(OeordRowid,"I",OEORIChildsub,3)),"^",35)
 .Q:LabTestSetRow=""
 .Set Status=""
 .Zn "LABDATA"
 .Set Status=$P(^TEPI($P(LabTestSetRow,"||",1),1,$P(LabTestSetRow,"||",2),$P(LabTestSetRow,"||",3)),"\",31)
 .Zn "DHC-APP"
 .Q:Status'="A"
 .Set RetStr=RetStr_"^"_LabTestSetRow
 if RetStr="" Q "-2"
 Zn "LABDATA"
 Set ReLabNo=$$SaveLabRowid^CHDhcLabReport(RetStr)
 Q ReLabNo
}

ClassMethod SaveLabRowid(LabRowidStr As %String) As %String
{
	s LabRowidStr=$g(LabRowidStr)
	S Config=##Class(websys.Configuration).%OpenId(1)
 	S WebConnString=Config.LayoutManager
	q WebConnString
}

Storage Default
{
<Data name="DHCLabReportDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCLabReportD</DataLocation>
<DefaultData>DHCLabReportDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^web.DHCLabReportD</IdLocation>
<IndexLocation>^web.DHCLabReportI</IndexLocation>
<StreamLocation>^web.DHCLabReportS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
