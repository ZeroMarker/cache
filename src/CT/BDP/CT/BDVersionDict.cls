/// 名称:版本字典表
/// 创建人:陈莹
/// 创建日期:2022年10月23日
Class CT.BDP.CT.BDVersionDict Extends (%Persistent, User.Abstract) [ SqlTableName = BDVersionDict ]
{

/// 类型
Property Type As %String [ Required, SqlColumnNumber = 2 ];

/// 版本代码
Property VersionCode As %String [ Required, SqlColumnNumber = 3 ];

/// 版本名称
Property VersionName As %String [ Required, SqlColumnNumber = 4 ];

/// 开始日期
Property DateFrom As %Date [ SqlColumnNumber = 5 ];

/// 结束日期
Property DateTo As %Date [ SqlColumnNumber = 6 ];

/// 同步到病案系统(Y/N)
Property IsSyncToMr As %String [ SqlColumnNumber = 7 ];

/// 中医数据标识(Y/N)
Property IsChineseMedicineFlag As %String [ SqlColumnNumber = 8 ];

/// 医保数据标识(Y/N)
Property IsInsuFlag As %String [ SqlColumnNumber = 9 ];

/// 名称索引
Index NameIndex On VersionName;

/// 代码索引
Index CodeIndex On VersionCode;

/// 类型索引
Index TypeIndex On Type As Exact;

Storage Default
{
<Data name="BDVersionDictDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Type</Value>
</Value>
<Value name="3">
<Value>VersionCode</Value>
</Value>
<Value name="4">
<Value>VersionName</Value>
</Value>
<Value name="5">
<Value>DateFrom</Value>
</Value>
<Value name="6">
<Value>DateTo</Value>
</Value>
<Value name="7">
<Value>IsSyncToMr</Value>
</Value>
<Value name="8">
<Value>IsChineseMedicineFlag</Value>
</Value>
<Value name="9">
<Value>IsInsuFlag</Value>
</Value>
</Data>
<DataLocation>^CT.BDP.CT.BDVersionDictD</DataLocation>
<DefaultData>BDVersionDictDefaultData</DefaultData>
<IdLocation>^CT.BDP.CT.BDVersionDictD</IdLocation>
<IndexLocation>^CT.BDP.CT.BDVersionDictI</IndexLocation>
<StreamLocation>^CT.BDP.CT.BDVersionDictS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
