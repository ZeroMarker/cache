/// 名称:版本字典表与医保对照的关联表
/// 创建人:陈莹
/// 创建日期:2022年10月23日
Class CT.BDP.CT.BDVersionDictInsu Extends (%Persistent, User.Abstract) [ SqlTableName = BDVersionDictInsu ]
{

/// 版本字典表字段dr
Property VersionDictDr As CT.BDP.CT.BDVersionDict [ Required, SqlColumnNumber = 2 ];

/// 医保版本dr
Property VersionInsuDr As CT.BDP.CT.BDVersionDict [ Required, SqlColumnNumber = 3 ];

/// 开始日期
Property DateFrom As %Date [ SqlColumnNumber = 4 ];

/// 结束日期
Property DateTo As %Date [ SqlColumnNumber = 5 ];

/// 同步到病案系统(Y/N)
Property IsSyncToMr As %String [ SqlColumnNumber = 6 ];

/// 索引-版本字典表字段dr+医保版本dr
Index IndexDictInsu On (VersionDictDr, VersionInsuDr);

/// 索引-医保版本dr版本字典表字段dr+
Index IndexInsuDict On (VersionInsuDr, VersionDictDr);

Storage Default
{
<Data name="BDVersionDictInsuDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>VersionDictDr</Value>
</Value>
<Value name="3">
<Value>VersionInsuDr</Value>
</Value>
<Value name="4">
<Value>DateFrom</Value>
</Value>
<Value name="5">
<Value>DateTo</Value>
</Value>
<Value name="6">
<Value>IsSyncToMr</Value>
</Value>
</Data>
<DataLocation>^CT.BDP.CT.BDVersionDictInsuD</DataLocation>
<DefaultData>BDVersionDictInsuDefaultData</DefaultData>
<IdLocation>^CT.BDP.CT.BDVersionDictInsuD</IdLocation>
<IndexLocation>^CT.BDP.CT.BDVersionDictInsuI</IndexLocation>
<StreamLocation>^CT.BDP.CT.BDVersionDictInsuS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
