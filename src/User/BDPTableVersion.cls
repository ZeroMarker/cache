/// 名称: User.BDPTableVersion
/// 描述: 基础数据平台-数据版本定义
/// 编写者：chenying
/// 编写日期: 2019-12-11
Class User.BDPTableVersion Extends (%Persistent, User.Abstract) [ ClassType = persistent, SqlTableName = BDP_TableVersion ]
{

/// 表名称（MRC_ICDDx)
Property TableName As %String(MAXLEN = 50) [ Required ];

/// 版本号
Property Version As %String(MAXLEN = 50) [ Required ];

/// 是否启用（Y/N)
Property ActiveFlag As %String;

/// 备注
Property Remarks As %String(MAXLEN = 9999);

/// 表名称+版本号生成的索引(有空格）
Index UniqueTableNameVersionIndex On (TableName, Version) [ Unique ];

/// 表名称生成的索引(去掉空格)
Index TableNameIndex On TableName As Exact;

Storage Default
{
<Data name="BDPTableVersionDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>TableName</Value>
</Value>
<Value name="3">
<Value>Version</Value>
</Value>
<Value name="4">
<Value>ActiveFlag</Value>
</Value>
<Value name="5">
<Value>Remarks</Value>
</Value>
</Data>
<DataLocation>^User.BDPTableVersionD</DataLocation>
<DefaultData>BDPTableVersionDefaultData</DefaultData>
<IdLocation>^User.BDPTableVersionD</IdLocation>
<IndexLocation>^User.BDPTableVersionI</IndexLocation>
<StreamLocation>^User.BDPTableVersionS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
