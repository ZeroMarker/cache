/// creator:lulin
/// createdate:2020-04-18
/// description:医嘱执行记录表
Class DHCNS.Config.NsAutoOrderExec Extends %Persistent
{

Relationship Parref As DHCNS.Config.NsAutoOrder [ Cardinality = parent, Inverse = ChildSub ];

/// 执行日期
Property OrderExecDate As %Date [ SqlColumnNumber = 2, SqlFieldName = OrderExecDate ];

/// 执行时间
Property OrderExecTime As %Time [ SqlColumnNumber = 3, SqlFieldName = OrderExecTime ];

/// 病区（执行人所在病区，如果不存就取患者所在）
Property OrderExecWard As %Integer [ SqlColumnNumber = 4, SqlFieldName = OrderExecWard ];

/// 患者EpisodeID
Property EpisodeID As %String [ SqlColumnNumber = 5, SqlFieldName = EpisodID ];

/// 患者姓名
Property PatName As %String [ SqlColumnNumber = 6, SqlFieldName = PatName ];

/// 医嘱子项Id
Property ArcimID As %String [ SqlColumnNumber = 7, SqlFieldName = ArcimID ];

/// 医嘱执行记录Id
Property ArcimExecID As %String [ SqlColumnNumber = 8, SqlFieldName = ArcimExecID ];

/// 医嘱名称
Property ArcimDesc As %String [ SqlColumnNumber = 9, SqlFieldName = ArcimDesc ];

/// 执行人姓名
Property ExecPerName As %String [ SqlColumnNumber = 10, SqlFieldName = ExecPerName ];

/// 执行人id---CTCareProv
Property ExecPerUserId As %String [ SqlColumnNumber = 11, SqlFieldName = ExecPerUserId ];

/// 执行人工号
Property ExecPerUserNo As %String [ SqlColumnNumber = 12, SqlFieldName = ExecPerUserNo ];

/// 医嘱开始日期
Property ArcimStartDate As %Date [ SqlColumnNumber = 13, SqlFieldName = ArcimStartDate ];

/// 医嘱开始时间
Property ArcimStartTime As %Time [ SqlColumnNumber = 14, SqlFieldName = ArcimStartTime ];

/// 更新日期
Property UpdateDate As %Date [ SqlColumnNumber = 15, SqlFieldName = UpdateDate ];

/// 患者出院日期
Property PatDisDate As %Date [ SqlColumnNumber = 16, SqlFieldName = PatDisDate ];

Index Index On (ArcimExecID, Parref);

Index PatNum On (OrderExecDate, ArcimID, EpisodeID, Parref);

Index ARCIM On (OrderExecWard, ArcimID, OrderExecDate, EpisodeID, Parref);

Index ExecDate On (Parref, OrderExecDate);

Storage Default
{
<Data name="NsAutoOrderExecDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>OrderExecDate</Value>
</Value>
<Value name="3">
<Value>OrderExecTime</Value>
</Value>
<Value name="4">
<Value>OrderExecWard</Value>
</Value>
<Value name="5">
<Value>EpisodeID</Value>
</Value>
<Value name="6">
<Value>PatName</Value>
</Value>
<Value name="7">
<Value>ArcimID</Value>
</Value>
<Value name="8">
<Value>ArcimExecID</Value>
</Value>
<Value name="9">
<Value>ArcimDesc</Value>
</Value>
<Value name="10">
<Value>ExecPerName</Value>
</Value>
<Value name="11">
<Value>ExecPerUserId</Value>
</Value>
<Value name="12">
<Value>ExecPerUserNo</Value>
</Value>
<Value name="13">
<Value>ArcimStartDate</Value>
</Value>
<Value name="14">
<Value>ArcimStartTime</Value>
</Value>
<Value name="15">
<Value>UpdateDate</Value>
</Value>
<Value name="16">
<Value>PatDisDate</Value>
</Value>
</Data>
<DataLocation>^DHCNS.Config.NsAutoOrderExecD</DataLocation>
<DefaultData>NsAutoOrderExecDefaultData</DefaultData>
<IdLocation>{%%PARENT}("ChildSub")</IdLocation>
<IndexLocation>^DHCNS.Config.NsAutoOrderExecI</IndexLocation>
<StreamLocation>^DHCNS.Config.NsAutoOrderExecS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
