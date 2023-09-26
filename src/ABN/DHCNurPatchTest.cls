Class ABN.DHCNurPatchTest Extends %Persistent
{

//斑贴实验 patch test

//	检查日期

Relationship ChildSub As ABN.DHCNurPatchTestSub [ Cardinality = children, Inverse = SkinParef ];

Property PapmiID As %String;

Property PAAdm As %String;

Property CheckDate As %Library.Date(FORMAT = 1);

//	检查者 

Property CheckUser As %String(TRUNCATE = 1);

//	简要病史

Property CaseHistory As %String(TRUNCATE = 1);

//	皮疹特征

Property RashChar As %String(TRUNCATE = 1);

//	可能诱因 

Property Cause As %String(TRUNCATE = 1);

//	治疗反应 

Property Response As %String(TRUNCATE = 1);

Property IsExec As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 6, SELECTIVITY = "25.0000%", TRUNCATE = 1, VALUELIST = ",Y,N");

Property ApplyDoctor As %String;

Property ApplyDate As %Library.Date;

Property ApplyTime As %Library.Time;

Property CheckTime As %Library.Time;

Index papmi On PapmiID;

Index ApplyDate On ApplyDate;

Method GetDesc()
{
	q "斑贴试验报告单"
}

Storage Default
{
<Data name="DHCNurPatchTestDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CheckDate</Value>
</Value>
<Value name="3">
<Value>CheckUser</Value>
</Value>
<Value name="4">
<Value>CaseHistory</Value>
</Value>
<Value name="5">
<Value>RashChar</Value>
</Value>
<Value name="6">
<Value>Cause</Value>
</Value>
<Value name="7">
<Value>Response</Value>
</Value>
<Value name="8">
<Value>PapmiID</Value>
</Value>
<Value name="9">
<Value>PAAdm</Value>
</Value>
<Value name="10">
<Value>IsExec</Value>
</Value>
<Value name="11">
<Value>ApplyDoctor</Value>
</Value>
<Value name="12">
<Value>ApplyDate</Value>
</Value>
<Value name="13">
<Value>ApplyTime</Value>
</Value>
<Value name="14">
<Value>CheckTime</Value>
</Value>
</Data>
<DataLocation>^ABN.DHCNurPatchTestD</DataLocation>
<DefaultData>DHCNurPatchTestDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^ABN.DHCNurPatchTestD</IdLocation>
<IndexLocation>^ABN.DHCNurPatchTestI</IndexLocation>
<StreamLocation>^ABN.DHCNurPatchTestS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
