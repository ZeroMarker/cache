/// Function: 别名配置表
/// Creator: sunfengchao
/// CreateDate:2017-07-10
Class User.BDPAliasConfigure Extends (%Persistent, User.Abstract) [ ClassType = persistent, SqlTableName = BDP_AliasConfigure ]
{

/// 用户
Property UserID As %String(MAXLEN = "") [ Required ];

/// 表名称
Property TableName As %String(MAXLEN = "") [ Required ];

/// 别名配置
Property AliasConfig As %String(MAXLEN = "") [ Required ];

Index AliasConfigRef On (UserID As Exact, TableName As Exact, AliasConfig As Exact);

Storage Default
{
<Data name="BDPAliasConfigureDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>UserID</Value>
</Value>
<Value name="3">
<Value>TableName</Value>
</Value>
<Value name="4">
<Value>AliasConfig</Value>
</Value>
</Data>
<DataLocation>^User.BDPAliasConfigureD</DataLocation>
<DefaultData>BDPAliasConfigureDefaultData</DefaultData>
<IdLocation>^User.BDPAliasConfigureD</IdLocation>
<IndexLocation>^User.BDPAliasConfigureI</IndexLocation>
<StreamLocation>^User.BDPAliasConfigureS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
