/// DHCWL_CodeCfg.DHCWLCodeCfgInterface  d ##class(DHCWL.CodeCfg.Interface).%BuildIndices()
Class DHCWL.CodeCfg.Interface Extends %Persistent [ ClassType = persistent, Not ProcedureBlock, SqlTableName = DHCWLCodeCfgInterface ]
{

/// 代码
Property InterCode As %String [ SqlColumnNumber = 2, SqlFieldName = Inter_Code ];

/// 描述
Property InterDesc As %String [ SqlColumnNumber = 3, SqlFieldName = Inter_Desc ];

/// 接口执行代码
Property InterExtCode As %String [ SqlColumnNumber = 4, SqlFieldName = Inter_ExtCode ];

/// 日期
Property InterCreateDate As %Date [ SqlColumnNumber = 5, SqlFieldName = Inter_CreateDate ];

/// 时间
Property InterCreateTime As %Time [ SqlColumnNumber = 6, SqlFieldName = Inter_CreateTime ];

/// 创建人
Property InterCreateUse As %String [ SqlColumnNumber = 7, SqlFieldName = Inter_CreateUse ];

Index Code On InterCode;

Index Desc On InterDesc;

Storage Default
{
<Data name="InterfaceDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>InterCode</Value>
</Value>
<Value name="3">
<Value>InterCreateDate</Value>
</Value>
<Value name="4">
<Value>InterCreateTime</Value>
</Value>
<Value name="5">
<Value>InterCreateUse</Value>
</Value>
<Value name="6">
<Value>InterDesc</Value>
</Value>
<Value name="7">
<Value>InterExtCode</Value>
</Value>
</Data>
<DataLocation>^DHCWL.CodeCfg.InterfaceD</DataLocation>
<DefaultData>InterfaceDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCWL.CodeCfg.InterfaceD</IdLocation>
<IndexLocation>^DHCWL.CodeCfg.InterfaceI</IndexLocation>
<StreamLocation>^DHCWL.CodeCfg.InterfaceS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
