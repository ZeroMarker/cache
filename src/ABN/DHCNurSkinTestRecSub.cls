Class ABN.DHCNurSkinTestRecSub Extends %Persistent
{

Relationship SkinParef As ABN.DHCNurSkinTestRec [ Cardinality = parent, Inverse = ChildSub, Required ];

//组别

Property SkinTestGroup As %String(TRUNCATE = 1);

//  医嘱 

Property ArcimId As %String(TRUNCATE = 1);

Property OrdRowId As %String(TRUNCATE = 1);

//风团 

Property MissionWind1 As %String(TRUNCATE = 1);

Property MissionWind2 As %String(TRUNCATE = 1);

//红晕 

Property Blushes1 As %String(TRUNCATE = 1);

Property Blushes2 As %String(TRUNCATE = 1);

//伪足 

Property Pseudopodia As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 6, SELECTIVITY = "25.0000%", TRUNCATE = 1, VALUELIST = ",Y,N");

//备注 

Property Memo As %String(TRUNCATE = 1);

Index ArcimId On ArcimId;

Index OrdRowId On OrdRowId;

Method IsExec()
{
	if (i%OrdRowId){
		s oeori = i%OrdRowId
		s oeore = $o(^OEORD(+oeori,"I",$p(oeori,"||",2),"X",0))
		q:oeore="" 0
		s OEOREOrderStatusDR = $p(^OEORD(+oeori,"I",$p(oeori,"||",2),"X",oeore),"^",16)
		q:OEOREOrderStatusDR="" 0
		s StatusCode = $p(^OEC("STAT",OEOREOrderStatusDR),"^",1)
		q:StatusCode="F" 1
	}
	q 0
}

Method OrderStatus()
{
	if (i%OrdRowId){
		s oeori = i%OrdRowId
		s OEORIItemStatDR = $p(^OEORD(+oeori,"I",$p(oeori,"||",2),1),"^",13)
		q:OEORIItemStatDR="" ""
		s StatusCode = $p(^OEC("OSTAT",OEORIItemStatDR),"^",1)
		q StatusCode
	}
	q ""
}

Storage Default
{
<Data name="DHCNurSkinTestRecSubDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>SkinTestGroup</Value>
</Value>
<Value name="3">
<Value>ArcimId</Value>
</Value>
<Value name="4">
<Value>OrdRowId</Value>
</Value>
<Value name="5">
<Value>MissionWind1</Value>
</Value>
<Value name="6">
<Value>MissionWind2</Value>
</Value>
<Value name="7">
<Value>Blushes1</Value>
</Value>
<Value name="8">
<Value>Blushes2</Value>
</Value>
<Value name="9">
<Value>Pseudopodia</Value>
</Value>
<Value name="10">
<Value>Memo</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("ChildSub")</DataLocation>
<DefaultData>DHCNurSkinTestRecSubDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^ABN.DHCNurSkinTestRecSubD</IdLocation>
<IndexLocation>^ABN.DHCNurSkinTestRecSubI</IndexLocation>
<StreamLocation>^ABN.DHCNurSkinTestRecSubS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
