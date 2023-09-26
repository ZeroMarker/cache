Class DHCEPRFS.Util.ClassHelper Extends %RegisteredObject [ ProcedureBlock ]
{

/// Desc: 获取方法的参数数量
/// Input: ClassName - 类名, MethodName - 方法名
/// Return: 参数数量
/// Debug: w ##class(DHCEPRFS.Util.ClassHelper).GetParamsNum("","")
ClassMethod GetParamsNum(AClassName As %String, AMethodName As %String) As %Integer
{
	s paramsNum = 0
	q:(AClassName = "")||(AMethodName = "") paramsNum
	s methodParams = $g(^oddCOM(AClassName,"m",AMethodName,60))
	s paramsNum = $ll(methodParams)
	q paramsNum
}

}
