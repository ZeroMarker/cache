/// 自动提交状态表
Class DHCEPRFS.INST.AutoCompleteStatus Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

/// 就诊号
Property EpisodeID As %String(TRUNCATE = 1);

Property ActDate As %Date;

Property ActTime As %Time;

/// 提交次数
Property ActCount As %Integer;

/// 出院日期
Property DisDateTime As %Date;

Index IdxEpisodeID On EpisodeID [ Unique ];

Index IdxMain On (ActCount, DisDateTime);

Storage Default
{
<Data name="AutoCompleteStatusDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>EpisodeID</Value>
</Value>
<Value name="3">
<Value>ActDate</Value>
</Value>
<Value name="4">
<Value>ActTime</Value>
</Value>
<Value name="5">
<Value>ActCount</Value>
</Value>
<Value name="6">
<Value>DisDateTime</Value>
</Value>
</Data>
<DataLocation>^DHCEPRFS.INST.AutoCompleteD</DataLocation>
<DefaultData>AutoCompleteStatusDefaultData</DefaultData>
<IdLocation>^DHCEPRFS.INST.AutoCompleteD</IdLocation>
<IndexLocation>^DHCEPRFS.INST.AutoCompleteI</IndexLocation>
<StreamLocation>^DHCEPRFS.INST.AutoCompleteS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
