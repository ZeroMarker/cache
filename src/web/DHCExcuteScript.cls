/// 名称: web.DHCExcuteScript
/// 描述: 用于执行脚本的类
Class web.DHCExcuteScript Extends %Persistent [ Not ProcedureBlock ]
{

/// 描述:  执行脚本并返回结果
/// 入参：    script：脚本
/// Return：  脚本执行的结果
ClassMethod ExcuteScript(script As %String)
{
		new result
		set result = ""
		s script = "set result= "_script
		Xecute script
		quit result
}

Storage Default
{
<Data name="DHCExcuteScriptDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCExcuteScriptD</DataLocation>
<DefaultData>DHCExcuteScriptDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^web.DHCExcuteScriptD</IdLocation>
<IndexLocation>^web.DHCExcuteScriptI</IndexLocation>
<StreamLocation>^web.DHCExcuteScriptS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
