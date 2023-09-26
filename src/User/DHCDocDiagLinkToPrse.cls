Class User.DHCDocDiagLinkToPrse Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = DHCDocDiagLinkToPrse ]
{

Index Presc On PrescNum;

/// 处方号
Property PrescNum As %String(COLLATION = "EXACT", TRUNCATE = 1);

/// 诊断
Property DiagList As %String(COLLATION = "Exact", MAXLEN = 10000, TRUNCATE = 1);

/// 插入日期
Property IsertDate As %Date;

/// 插入时间
Property IsertTime As %Time;

/// 插入人
Property IsertUser As SSUser;

/// 无效标志
Property Active As %String;

Storage Default
{
<Data name="DHCDocDiagLinkToPrseDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>PrescNum</Value>
</Value>
<Value name="3">
<Value>DiagList</Value>
</Value>
<Value name="4">
<Value>IsertDate</Value>
</Value>
<Value name="5">
<Value>IsertTime</Value>
</Value>
<Value name="6">
<Value>IsertUser</Value>
</Value>
<Value name="7">
<Value>Active</Value>
</Value>
</Data>
<DataLocation>^User.DHCDocDiagLinkToPrseD</DataLocation>
<DefaultData>DHCDocDiagLinkToPrseDefaultData</DefaultData>
<IdLocation>^User.DHCDocDiagLinkToPrseD</IdLocation>
<IndexLocation>^User.DHCDocDiagLinkToPrseI</IndexLocation>
<StreamLocation>^User.DHCDocDiagLinkToPrseS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
