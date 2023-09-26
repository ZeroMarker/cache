/// CTOR: QP
/// DATE: 2021-07-08
/// DESC: 医生交班本班次时间表
Class User.DHCDocPassWorkBCTime Extends (%Persistent, User.Abstract)
{

Relationship BCParRef As User.DHCDocPassWorkBCMain [ Cardinality = parent, Inverse = ChildTime, Required, SqlFieldName = BC_ParRef ];

/// BC_Code 班次代码
Property BCCode As %String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = BC_Code ];

/// BC_Name 班次名称
Property BCName As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = BC_Name ];

/// BC_STime 开始时间
Property BCSTime As %Time [ SqlColumnNumber = 4, SqlFieldName = BC_STime ];

/// BC_ETime 结束时间
Property BCETime As %Time [ SqlColumnNumber = 5, SqlFieldName = BC_ETime ];

/// BC_IsNextDay 是否跨日
Property BCIsNextDay As %String(COLLATION = "Exact", MAXLEN = 1, TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = BC_IsNextDay ];

/// BC_Note 备注
Property BCNote As %String(COLLATION = "Exact", MAXLEN = 1000, TRUNCATE = 1) [ SqlColumnNumber = 7, SqlFieldName = BC_Note ];

/// BC_Active 是否激活
Property BCActive As %String(COLLATION = "Exact", MAXLEN = 1, TRUNCATE = 1) [ SqlColumnNumber = 8, SqlFieldName = BC_Active ];

/// BC_Seqno 第几班
Property BCSeqno As %String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 1) [ SqlColumnNumber = 9, SqlFieldName = BC_Seqno ];

Index BCCode On BCCode As Exact;

Index BCSeqno On BCSeqno As Exact;

Storage Default
{
<Data name="DHCDocPassWorkBCTimeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BCCode</Value>
</Value>
<Value name="3">
<Value>BCName</Value>
</Value>
<Value name="4">
<Value>BCSTime</Value>
</Value>
<Value name="5">
<Value>BCETime</Value>
</Value>
<Value name="6">
<Value>BCIsNextDay</Value>
</Value>
<Value name="7">
<Value>BCNote</Value>
</Value>
<Value name="8">
<Value>BCActive</Value>
</Value>
<Value name="9">
<Value>BCSeqno</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("ChildTime")</DataLocation>
<DefaultData>DHCDocPassWorkBCTimeDefaultData</DefaultData>
<IdLocation>^User.DHCDocPassWorkBCMainC("ChildTime")</IdLocation>
<IndexLocation>^User.DHCDocPassWorkBCTimeI</IndexLocation>
<StreamLocation>^User.DHCDocPassWorkBCTimeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
