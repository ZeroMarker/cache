/// 代码执行的支持
Class ext.websys.Broker Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// 类方法执行
ClassMethod CMExecute(classname As %String, classmethod As %String) As %String
{
}

/// String to execute to run the desired method.
/// [Previously private]
ClassMethod XecuteStr(ByRef code As %String, cls As %String, method As %String, wantreturnval As %Boolean) As %String
{
}

ClassMethod GetCMInParaList(ClassName As %String = "", ClassMethod As %String = "", ExpStr As %String) As %String
{
}

}
