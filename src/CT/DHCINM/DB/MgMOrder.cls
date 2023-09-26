/// Creater:zhengzhong
/// Descriptions:医嘱配置
/// Date:2021-06-15
Class CT.DHCINM.DB.MgMOrder Extends %Persistent
{

Relationship ChildSub As CT.DHCINM.DB.MgMOrderSub [ Cardinality = children, Inverse = Parref ];

/// 项目名称
Property WorkItm As %String [ SqlColumnNumber = 2, SqlFieldName = WorkItm ];

/// 项目代码 唯一 不可修改
Property WorkCode As %String [ SqlColumnNumber = 3, SqlFieldName = WorkCode ];

/// 颜色
Property WorkColor As %String [ SqlColumnNumber = 4, SqlFieldName = WorkColor ];

Index WorkCode On WorkCode [ Unique ];

Storage Default
{
<Data name="MgMOrderDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>WorkItm</Value>
</Value>
<Value name="3">
<Value>WorkCode</Value>
</Value>
<Value name="4">
<Value>WorkColor</Value>
</Value>
</Data>
<DataLocation>^CT.DHCINM.DB.MgMOrderD</DataLocation>
<DefaultData>MgMOrderDefaultData</DefaultData>
<IdLocation>^CT.DHCINM.DB.MgMOrderD</IdLocation>
<IndexLocation>^CT.DHCINM.DB.MgMOrderI</IndexLocation>
<StreamLocation>^CT.DHCINM.DB.MgMOrderS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
