Class DHCEPRFS.INST.MRLogDetailSub Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Property DetailNum As %Integer;

Property DetailType As %String(TRUNCATE = 1);

Property DetailID As %String(TRUNCATE = 1);

Property DetailVersion As %String(TRUNCATE = 1);

Property PageRange As %String(TRUNCATE = 1);

Property CreateDate As %Date;

Property CreateTime As %Time;

Property MREpisodeID As %String(TRUNCATE = 1);

Property ActUserID As %String(TRUNCATE = 1);

Property MRAction As %String(TRUNCATE = 1);

Property MRMedRecordID As %String(TRUNCATE = 1);

Relationship TheMRLogDetail As DHCEPRFS.INST.MRLogDetail [ Cardinality = parent, Inverse = TheMRLogDetailSub ];

Index IdxMain On (TheMRLogDetail, DetailNum) [ Unique ];

Index IdxDetail On (TheMRLogDetail, DetailType, DetailID, DetailVersion);

//增加CreateDate索引 by yangpeng 2015.9.13

Index IdxCreateDate On (MRAction, CreateDate);

Storage Default
{
<Data name="MRLogDetailSubDefaultData">
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
<Value>ActUserID</Value>
</Value>
<Value name="9">
<Value>MRAction</Value>
</Value>
<Value name="10">
<Value>DetailVersion</Value>
</Value>
<Value name="11">
<Value>Flag</Value>
</Value>
<Value name="12">
<Value>ActPageList</Value>
</Value>
<Value name="13">
<Value>PageRange</Value>
</Value>
<Value name="14">
<Value>MRMedRecordID</Value>
</Value>
</Data>
<DataLocation>^DHCEPRFS.INST.MRLogDetailSubD</DataLocation>
<DefaultData>MRLogDetailSubDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEPRFS.INST.MRLogDetailSubD</IdLocation>
<IndexLocation>^DHCEPRFS.INST.MRLogDetailSubI</IndexLocation>
<StreamLocation>^DHCEPRFS.INST.MRLogDetailSubS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
