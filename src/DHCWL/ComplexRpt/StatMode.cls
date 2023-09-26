/// DHCWL_ComplexRpt.StatMode   d ##class(DHCWL.ComplexRpt.StatMode).%BuildIndices()
/// 统计模式表
Class DHCWL.ComplexRpt.StatMode Extends %Persistent [ ClassType = persistent, SqlTableName = StatMode ]
{

/// 代码
Property StModeCode As %String(MAXLEN = 100) [ SqlColumnNumber = 2, SqlFieldName = StMode_Code ];

/// 描述
Property StModeDesc As %String(MAXLEN = 100) [ SqlColumnNumber = 3, SqlFieldName = StMode_Desc ];

/// 执行代码
Property StModeExcCode As %String(MAXLEN = 250) [ SqlColumnNumber = 4, SqlFieldName = StMode_ExcCode ];

/// 有效标示
Property StModeFlag As %String(MAXLEN = 2) [ SqlColumnNumber = 5, SqlFieldName = StMode_Flag ];

/// 更新时间
Property StModeUpdateDate As %String [ SqlColumnNumber = 6, SqlFieldName = StMode_UpdateDate ];

Index StModeCode On StModeCode;

//[ Unique ]

Index StModeFlag On StModeFlag;

Storage Default
{
<Data name="StatModeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>StModeCode</Value>
</Value>
<Value name="3">
<Value>StModeDesc</Value>
</Value>
<Value name="4">
<Value>StModeExcCode</Value>
</Value>
<Value name="5">
<Value>StModeUpdateDate</Value>
</Value>
<Value name="6">
<Value>StModeFlag</Value>
</Value>
</Data>
<DataLocation>^DHCWL.ComplexRpt.StatModeD</DataLocation>
<DefaultData>StatModeDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCWL.ComplexRpt.StatModeD</IdLocation>
<IndexLocation>^DHCWL.ComplexRpt.StatModeI</IndexLocation>
<StreamLocation>^DHCWL.ComplexRpt.StatModeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
