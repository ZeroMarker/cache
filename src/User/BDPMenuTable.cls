/// 菜单与菜单对应页面操作时涉及到的User表 中间表
/// 用户只能看到自己所能查看页面涉及的表的日志
/// 2015-07-6 chenying
Class User.BDPMenuTable Extends (%Persistent, User.Abstract) [ ClassType = persistent, SqlTableName = BDP_MenuTable ]
{

Property Menu As %String [ Required ];

/// 表名称 例:User.DHCTarCate
Property TableName As %String [ Required ];

Index mt On (Menu, TableName) [ Unique ];

Storage Default
{
<Data name="BDPMenuTableDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Menu</Value>
</Value>
<Value name="3">
<Value>TableName</Value>
</Value>
</Data>
<DataLocation>^User.BDPMenuTableD</DataLocation>
<DefaultData>BDPMenuTableDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.BDPMenuTableD</IdLocation>
<IndexLocation>^User.BDPMenuTableI</IndexLocation>
<StreamLocation>^User.BDPMenuTableS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
