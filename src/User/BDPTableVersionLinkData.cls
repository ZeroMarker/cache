/// 名称: User.BDPTableVersionLinkData
/// 描述: 基础数据平台-版本号与数据关联
/// 编写者：chenying
/// 编写日期: 2019-12-11
Class User.BDPTableVersionLinkData Extends (%Persistent, User.Abstract) [ ClassType = persistent, SqlTableName = BDP_TableVersionLinkData ]
{

/// 表名称（MRC_ICDDx)
Property TableName As %String(MAXLEN = 50) [ Required ];

/// 版本号
Property Version As %String(MAXLEN = 50) [ Required ];

/// 数据rowid
Property DataId As %String [ Required ];

/// 表名称+版本号+数据rowid生成的索引(有空格）
Index UniqueTableNameVersionIndex On (TableName, Version, DataId) [ Unique ];

/// 表名称+数据rowid生成的索引(去掉空格)
Index TableNameIndex On (TableName As Exact, DataId As Exact);

Storage Default
{
<Data name="BDPTableVersionLinkDataDefaultData">
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
<Value>DataId</Value>
</Value>
</Data>
<DataLocation>^User.BDPTableVersionLinkDataD</DataLocation>
<DefaultData>BDPTableVersionLinkDataDefaultData</DefaultData>
<IdLocation>^User.BDPTableVersionLinkDataD</IdLocation>
<IndexLocation>^User.BDPTableVersionLinkDataI</IndexLocation>
<StreamLocation>^User.BDPTableVersionLinkDataS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
