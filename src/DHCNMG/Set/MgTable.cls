/// 表格管理
Class DHCNMG.Set.MgTable Extends %Persistent
{

Relationship ColChildSub As DHCNMG.Set.MgColumns [ Cardinality = children, Inverse = Parref ];

/// 表头
Property TableTitle As %String [ SqlColumnNumber = 2, SqlFieldName = Table_Title ];

/// 代码
Property TableCode As %String [ SqlColumnNumber = 3, SqlFieldName = Table_Code ];

/// 关联菜单
Property TableMenu As DHCNMG.Set.MgMenu [ SqlColumnNumber = 4, SqlFieldName = Table_Menu ];

/// 关联类型 Method Query
Property LinkType As %String [ SqlColumnNumber = 5, SqlFieldName = Link_Type ];

/// 关联类
Property LinkClass As %String [ SqlColumnNumber = 6, SqlFieldName = Link_Class ];

/// 关联方法
Property LinkMethod As %String [ SqlColumnNumber = 7, SqlFieldName = Link_Method ];

/// 返回值类型 1：Json 2：Query 3：RecQuery 
Property ReturnType As %String [ SqlColumnNumber = 8, SqlFieldName = Return_Type ];

/// 默认参数
Property DefaultParams As %String [ SqlColumnNumber = 9, SqlFieldName = Default_Params ];

Index Code On TableCode;

Storage Default
{
<Data name="MgTableDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>TableTitle</Value>
</Value>
<Value name="3">
<Value>TableCode</Value>
</Value>
<Value name="4">
<Value>TableMenu</Value>
</Value>
<Value name="5">
<Value>LinkType</Value>
</Value>
<Value name="6">
<Value>LinkClass</Value>
</Value>
<Value name="7">
<Value>LinkMethod</Value>
</Value>
<Value name="8">
<Value>ReturnType</Value>
</Value>
<Value name="9">
<Value>DefaultParams</Value>
</Value>
</Data>
<DataLocation>^DHCNMG.Set.MgTableD</DataLocation>
<DefaultData>MgTableDefaultData</DefaultData>
<IdLocation>^DHCNMG.Set.MgTableD</IdLocation>
<IndexLocation>^DHCNMG.Set.MgTableI</IndexLocation>
<StreamLocation>^DHCNMG.Set.MgTableS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
