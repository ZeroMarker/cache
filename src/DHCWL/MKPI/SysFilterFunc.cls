/// 	指标系统4.1新增。指标数据过滤中使用到的过滤函数配置表
/// 	DHCWL_MKPI.SysFilterFunc	k ^DHCWL.MKPI.SysFilterFuncI  d ##class(DHCWL.MKPI.SysFilterFunc).%BuildIndices()
Class DHCWL.MKPI.SysFilterFunc Extends %Persistent [ ClassType = persistent, SqlTableName = SysFilterFunc ]
{

/// 		过滤函数代码
Property FilterFuncCode As %String [ SqlColumnNumber = 2, SqlFieldName = FilterFunc_Code ];

/// 		函数原型
Property FilterFuncPrototype As %String [ SqlColumnNumber = 3, SqlFieldName = FilterFunc_Prototype ];

/// 	执行代码
Property FilterFuncExecCode As %String(MAXLEN = 100) [ SqlColumnNumber = 4, SqlFieldName = FilterFunc_ExecCode ];

/// 	功能描述
Property FilterFuncFuncDesc As %String [ SqlColumnNumber = 5, SqlFieldName = FilterFunc_FuncDesc ];

Index Code On FilterFuncCode;

Index ExecCode On FilterFuncExecCode;

//Index CodeExecCodeProI On (FilterFuncCode, FilterFuncExecCode, FilterFuncPrototype);

Storage Default
{
<Data name="SysFilterFuncDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>FilterFuncCode</Value>
</Value>
<Value name="3">
<Value>FilterFuncPrototype</Value>
</Value>
<Value name="4">
<Value>FilterFuncExecCode</Value>
</Value>
<Value name="5">
<Value>FilterFuncFuncDesc</Value>
</Value>
</Data>
<DataLocation>^DHCWL.MKPI.SysFilterFuncD</DataLocation>
<DefaultData>SysFilterFuncDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCWL.MKPI.SysFilterFuncD</IdLocation>
<IndexLocation>^DHCWL.MKPI.SysFilterFuncI</IndexLocation>
<StreamLocation>^DHCWL.MKPI.SysFilterFuncS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
