/// 	指标系统4.1新增。系统参数配置表，用来记录一些全局的系统参数配置信息，诸如全局的日志记录行为，
/// 	指标任务添加时的默认值，某个指标任务出错挂起时是否挂起整个指标任务等等
/// 	DHCWL_MKPI.SysVariables		k ^DHCWL.MKPI.SysVariablesI  d ##class(DHCWL_MKPI.SysVariables).%BuildIndices()
Class DHCWL.MKPI.SysVariables Extends %Persistent [ ClassType = persistent, SqlTableName = SysVariables ]
{

/// 	代码
Property SysVarCode As %String [ SqlColumnNumber = 2, SqlFieldName = SysVar_Code ];

/// 	描述
Property SysVarDesc As %String [ SqlColumnNumber = 3, SqlFieldName = SysVar_Desc ];

/// 	值
Property SysVarValue As %String [ SqlColumnNumber = 4, SqlFieldName = SysVar_Value ];

/// 	创建/更新日期
Property SysVarDate As %Date [ SqlColumnNumber = 5, SqlFieldName = SysVar_Date ];

/// 	创建/更新时间
Property SysVarTime As %Time [ SqlColumnNumber = 6, SqlFieldName = SysVar_Time ];

/// 	创建/更新用户
Property SysVarUser As %String [ SqlColumnNumber = 7, SqlFieldName = SysVar_User ];

Index CodeDateTime On (SysVarCode As AlphaUp, SysVarDate, SysVarTime);

Storage Default
{
<Data name="SysVariablesDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>SysVarCode</Value>
</Value>
<Value name="3">
<Value>SysVarDesc</Value>
</Value>
<Value name="4">
<Value>SysVarValue</Value>
</Value>
<Value name="5">
<Value>SysVarDate</Value>
</Value>
<Value name="6">
<Value>SysVarTime</Value>
</Value>
<Value name="7">
<Value>SysVarUser</Value>
</Value>
</Data>
<DataLocation>^DHCWL.MKPI.SysVariablesD</DataLocation>
<DefaultData>SysVariablesDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCWL.MKPI.SysVariablesD</IdLocation>
<IndexLocation>^DHCWL.MKPI.SysVariablesI</IndexLocation>
<StreamLocation>^DHCWL.MKPI.SysVariablesS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
