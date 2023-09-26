Class ABN.DHCNurPatchTestSub Extends %Persistent
{

//	组别

Relationship SkinParef As ABN.DHCNurPatchTest [ Cardinality = parent, Inverse = ChildSub, Required ];

Property SkinTestGroup As %String(TRUNCATE = 1);

//	医嘱

Property ArcimID As %String(TRUNCATE = 1);

Property OrdRowId As %String(TRUNCATE = 1);

//	48小时反应

Property Hours48 As %String(TRUNCATE = 1);

//	72小时反应

Property Hours72 As %String(TRUNCATE = 1);

//	其他间隔时间

Property OtherHours As %String(TRUNCATE = 1);

//	其他间隔反应

Property OtherResponse As %String(TRUNCATE = 1);

//	备注

Property FirstDate As %Library.Date(FORMAT = 1);

Property UpdDate As %Library.Date(FORMAT = 1);

Property FirstTime As %Library.Time;

Property UpdTime As %Library.Time;

//	检查者 

Property CheckUser As %String(TRUNCATE = 1);

Property UpdUser As %String(TRUNCATE = 1);

Property Memo As %String(TRUNCATE = 1);

Index ArcimID On ArcimID;

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
<Data name="DHCNurPatchTestSubDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>SkinTestGroup</Value>
</Value>
<Value name="3">
<Value>OrdRowId</Value>
</Value>
<Value name="4">
<Value>Hours48</Value>
</Value>
<Value name="5">
<Value>Hours72</Value>
</Value>
<Value name="6">
<Value>OtherHours</Value>
</Value>
<Value name="7">
<Value>OtherResponse</Value>
</Value>
<Value name="8">
<Value>Memo</Value>
</Value>
<Value name="9">
<Value>ArcimID</Value>
</Value>
<Value name="10">
<Value>FirstDate</Value>
</Value>
<Value name="11">
<Value>UpdDate</Value>
</Value>
<Value name="12">
<Value>FirstTime</Value>
</Value>
<Value name="13">
<Value>UpdTime</Value>
</Value>
<Value name="14">
<Value>CheckUser</Value>
</Value>
<Value name="15">
<Value>UpdUser</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("ChildSub")</DataLocation>
<DefaultData>DHCNurPatchTestSubDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^ABN.DHCNurPatchTestSubD</IdLocation>
<IndexLocation>^ABN.DHCNurPatchTestSubI</IndexLocation>
<StreamLocation>^ABN.DHCNurPatchTestSubS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
