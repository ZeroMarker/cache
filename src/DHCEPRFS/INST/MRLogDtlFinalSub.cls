Class DHCEPRFS.INST.MRLogDtlFinalSub Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Property DetailNum As %Integer;

Property DetailType As %String(TRUNCATE = 1);

Property DetailID As %String(TRUNCATE = 1);

Property DetailVersion As %String(TRUNCATE = 1);

Property PageRange As %String(TRUNCATE = 1);

Property CreateDate As %Date;

Property CreateTime As %Time;

Property ModifyDate As %Date;

Property ModifyTime As %Time;

Property MREpisodeID As %String(TRUNCATE = 1);

Property ActUserID As %String(TRUNCATE = 1);

Property MRAction As %String(TRUNCATE = 1);

Property MRMedRecordID As %String(TRUNCATE = 1);

Property TheMRLogDetailID As %String(TRUNCATE = 1);

Relationship TheMRLogDtlFinal As DHCEPRFS.INST.MRLogDtlFinal [ Cardinality = parent, Inverse = TheMRLogDtlFinalSub ];

Index IdxMain On (TheMRLogDtlFinal, MRAction, DetailType, DetailID);

Index IdxMRLogDetail On (TheMRLogDetailID, DetailNum);

Storage Default
{
<Data name="MRLogDtlFinalSubDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DetailNum</Value>
</Value>
<Value name="3">
<Value>DetailType</Value>
</Value>
<Value name="4">
<Value>DetailID</Value>
</Value>
<Value name="5">
<Value>CreateDate</Value>
</Value>
<Value name="6">
<Value>CreateTime</Value>
</Value>
<Value name="7">
<Value>MREpisodeID</Value>
</Value>
<Value name="8">
<Value>TheMRLogDetailID</Value>
</Value>
<Value name="9">
<Value>ActUserID</Value>
</Value>
<Value name="10">
<Value>MRAction</Value>
</Value>
<Value name="11">
<Value>ModifyDate</Value>
</Value>
<Value name="12">
<Value>ModifyTime</Value>
</Value>
<Value name="13">
<Value>DetailVersion</Value>
</Value>
<Value name="14">
<Value>ActPageList</Value>
</Value>
<Value name="15">
<Value>PageRange</Value>
</Value>
<Value name="16">
<Value>MRMedRecordID</Value>
</Value>
</Data>
<DataLocation>^DHCEPRFS.INST.MRLogDtlFSubD</DataLocation>
<DefaultData>MRLogDtlFinalSubDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEPRFS.INST.MRLogDtlFSubD</IdLocation>
<IndexLocation>^DHCEPRFS.INST.MRLogDtlFSubI</IndexLocation>
<StreamLocation>^DHCEPRFS.INST.MRLogDtlFSubS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
