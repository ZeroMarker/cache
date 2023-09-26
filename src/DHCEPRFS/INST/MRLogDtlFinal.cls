Class DHCEPRFS.INST.MRLogDtlFinal Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Property DetailNum As %Integer;

Property PrevStatus As %String(TRUNCATE = 1);

Property PostStatus As %String(TRUNCATE = 1);

Property MRAction As %String(TRUNCATE = 1);

Property ActDate As %Date;

Property ActTime As %Time;

Property CreateDate As %Date;

Property CreateTime As %Time;

Property ActUserID As %String(TRUNCATE = 1);

Property ActPages As %Integer;

Property ActPrice As %Float;

Property ActSchemeID As %String(TRUNCATE = 1);

Property Remark As %String(TRUNCATE = 1);

Property TheMRLogID As %String(TRUNCATE = 1);

Property MREpisodeID As %String(TRUNCATE = 1);

Property MRMedRecordID As %String(TRUNCATE = 1);

Relationship TheMRLogDtlFinalSub As DHCEPRFS.INST.MRLogDtlFinalSub [ Cardinality = children, Inverse = TheMRLogDtlFinal ];

Index IdxUnique On (MRAction, MREpisodeID, MRMedRecordID) [ Unique ];

Index IdxMain On (MREpisodeID, MRAction);

Index IdxMRMedRecord On (MRMedRecordID, MRAction);

Index IdxUserMREpisode On (ActUserID, MREpisodeID, MRAction, ActDate, ActTime);

Index IdxDetailNum On (MREpisodeID, DetailNum, MRAction);

Index IdxMRAction On (MRAction, ActDate, ActTime);

Index IdxActUserID On (ActUserID, ActDate, ActTime);

Index IdxMRActUserID On (MRAction, ActUserID, ActDate, ActTime);

Index IdxActDateTime On (ActDate, ActTime);

Index IdxMRLogID On (TheMRLogID, DetailNum);

Storage Default
{
<Data name="MRLogDtlFinalDefaultData">
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
<Value>TheMRLogID</Value>
</Value>
<Value name="13">
<Value>MREpisodeID</Value>
</Value>
<Value name="14">
<Value>Remark</Value>
</Value>
<Value name="15">
<Value>DetailType</Value>
</Value>
<Value name="16">
<Value>DetailID</Value>
</Value>
<Value name="17">
<Value>CreateDate</Value>
</Value>
<Value name="18">
<Value>CreateTime</Value>
</Value>
<Value name="19">
<Value>MRMedRecordID</Value>
</Value>
</Data>
<DataLocation>^DHCEPRFS.INST.MRLogDtlFinalD</DataLocation>
<DefaultData>MRLogDtlFinalDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEPRFS.INST.MRLogDtlFinalD</IdLocation>
<IndexLocation>^DHCEPRFS.INST.MRLogDtlFinalI</IndexLocation>
<StreamLocation>^DHCEPRFS.INST.MRLogDtlFinalS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
