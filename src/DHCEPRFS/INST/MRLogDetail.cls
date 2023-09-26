Class DHCEPRFS.INST.MRLogDetail Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

/// 2
Property DetailNum As %Integer;

/// 3
Property PrevStatus As %String(TRUNCATE = 1);

/// 4
Property PostStatus As %String(TRUNCATE = 1);

/// 5
Property MRAction As %String(TRUNCATE = 1);

/// 6
Property ActDate As %Date;

/// 7
Property ActTime As %Time;

/// 8
Property ActUserID As %String(TRUNCATE = 1);

/// 9
Property ActPages As %Integer;

/// 10
Property ActPrice As %Float;

/// 11
Property ActSchemeID As %String(TRUNCATE = 1);

/// 12
Property Remark As %String(TRUNCATE = 1);

Property MREpisodeID As %String(TRUNCATE = 1);

Property MRMedRecordID As %String(TRUNCATE = 1);

Property IP As %String(TRUNCATE = 1);

Relationship TheMRLog As DHCEPRFS.INST.MRLog [ Cardinality = parent, Inverse = TheMRLogDetail ];

Relationship TheMRLogDetailSub As DHCEPRFS.INST.MRLogDetailSub [ Cardinality = children, Inverse = TheMRLogDetail ];

Index IdxMain On (TheMRLog, DetailNum) [ Unique ];

Index IdxUserMREpisode On (ActUserID, MREpisodeID, MRAction, ActDate, ActTime);

Index IdxMainAction On (TheMRLog, MRAction);

Index IdxActDateTime On (ActDate, ActTime);

Index IdxMRAction On (MRAction, ActDate, ActTime);

Index IdxActUserID On (ActUserID, ActDate, ActTime);

Index IdxMRActUserID On (MRAction, ActUserID, ActDate, ActTime);

Index IdxIP On (IP, ActDate, ActTime);

Index IdxMREpisodeID On (MREpisodeID, MRAction);

Storage Default
{
<Data name="MRLogDetailDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DetailNum</Value>
</Value>
<Value name="3">
<Value>PrevStatus</Value>
</Value>
<Value name="4">
<Value>PostStatus</Value>
</Value>
<Value name="5">
<Value>MRAction</Value>
</Value>
<Value name="6">
<Value>ActDate</Value>
</Value>
<Value name="7">
<Value>ActTime</Value>
</Value>
<Value name="8">
<Value>ActUserID</Value>
</Value>
<Value name="9">
<Value>ActPages</Value>
</Value>
<Value name="10">
<Value>ActPrice</Value>
</Value>
<Value name="11">
<Value>ActSchemeID</Value>
</Value>
<Value name="12">
<Value>Remark</Value>
</Value>
<Value name="13">
<Value>MREpisodeID</Value>
</Value>
<Value name="14">
<Value>DetailType</Value>
</Value>
<Value name="15">
<Value>DetailID</Value>
</Value>
<Value name="16">
<Value>MRMedRecordID</Value>
</Value>
<Value name="17">
<Value>IP</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("TheMRLogDetail")</DataLocation>
<DefaultData>MRLogDetailDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>{%%PARENT}("TheMRLogDetail")</IdLocation>
<IndexLocation>^DHCEPRFS.INST.MRLogDetailI</IndexLocation>
<StreamLocation>^DHCEPRFS.INST.MRLogDetailS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
