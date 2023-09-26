/// 皮肤试验
Class ABN.DHCNurSkinTestRec Extends %Persistent
{

Relationship ChildSub As ABN.DHCNurSkinTestRecSub [ Cardinality = children, Inverse = SkinParef ];

Property PapmiID As %String;

Property PAAdm As %String;

//皮试类型 (皮内，点刺，SigE)

Property SkinTestType As %Library.String(DISPLAYLIST = ",Skin,Prick,LabSigE", MAXLEN = 6, SELECTIVITY = "25.0000%", TRUNCATE = 1, VALUELIST = ",S,P,L");

//检查日期

Property CheckDate As %Library.Date(FORMAT = 1);

//检查时间

Property CheckTime As %Library.Time;

//检查者 

Property CheckUser As %String(TRUNCATE = 1);

Property IsExec As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 6, SELECTIVITY = "25.0000%", TRUNCATE = 1, VALUELIST = ",Y,N");

// ss_user

Property ApplyDoctor As %String;

Property ApplyDate As %Library.Date;

Property ApplyTime As %Library.Time;

Index papmiPaadm On (PapmiID, PAAdm);

Index ApplyDate On ApplyDate;

Method GetDesc()
{
	q:i%SkinTestType="P" "食物过敏原点刺试验"
	q:i%SkinTestType="S" "吸入过敏原皮内试验"
	q "食物过敏原点刺试验"
}

Method IsSkin()
{
	q $s(i%SkinTestType="S":1,1:0)
}

Method IsPrick()
{
	q $s(i%SkinTestType="P":1,1:0)
}

Storage Default
{
<Data name="DHCNurSkinTestRecDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>IsExec</Value>
</Value>
<Value name="3">
<Value>CheckDate</Value>
</Value>
<Value name="4">
<Value>CheckTime</Value>
</Value>
<Value name="5">
<Value>CheckUser</Value>
</Value>
<Value name="6">
<Value>PapmiID</Value>
</Value>
<Value name="7">
<Value>PAAdm</Value>
</Value>
<Value name="8">
<Value>SkinTestType</Value>
</Value>
<Value name="9">
<Value>ApplyDoctor</Value>
</Value>
<Value name="10">
<Value>ApplyDate</Value>
</Value>
<Value name="11">
<Value>ApplyTime</Value>
</Value>
</Data>
<DataLocation>^ABN.DHCNurSkinTestRecD</DataLocation>
<DefaultData>DHCNurSkinTestRecDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^ABN.DHCNurSkinTestRecD</IdLocation>
<IndexLocation>^ABN.DHCNurSkinTestRecI</IndexLocation>
<StreamLocation>^ABN.DHCNurSkinTestRecS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
