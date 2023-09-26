/// 菜单与国家标准编码类别对照
/// 用户只能看到自己所能查看页面涉及的该类别的国家标准编码
/// 2016-04-12 谷雪萍
Class User.BDPMenuNATDataType Extends (%Persistent, User.Abstract) [ ClassType = persistent, SqlTableName = BDP_MenuNATDataType ]
{

Property Menu As %String [ Required ];

/// 国家标准编码类别
Property NATDataType As %String [ Required ];

Index contrast On (Menu, NATDataType) [ Unique ];

Storage Default
{
<Data name="BDPMenuNATDataTypeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Menu</Value>
</Value>
<Value name="3">
<Value>NATDataType</Value>
</Value>
</Data>
<DataLocation>^User.BDPMenuNATDataTypeD</DataLocation>
<DefaultData>BDPMenuNATDataTypeDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.BDPMenuNATDataTypeD</IdLocation>
<IndexLocation>^User.BDPMenuNATDataTypeI</IndexLocation>
<StreamLocation>^User.BDPMenuNATDataTypeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
