Class EMRservice.HISInterface.BaseServiceTool Extends %RegisteredObject
{

/// Create:	liuyunfei 
/// Output:	入院时间
/// Desc:	IP地址^会话ID^在线状态^计算机名^计算机MAC
/// Debug:	w ##class(EMRservice.HISInterface.BaseServiceTool).GetClientInfo()
ClassMethod GetClientInfo() As %String
{
	s clientInfo = ""
	q:(##class(%Dictionary.CompiledClass).%ExistsId("User.DHCClientLogin") = "0") clientInfo
	q:(##class(%Dictionary.CompiledMethod).%ExistsId("User.DHCClientLogin||GetInfo") = "0") clientInfo
	s clientInfo = ##Class(User.DHCClientLogin).GetInfo()
	q clientInfo
}

}
