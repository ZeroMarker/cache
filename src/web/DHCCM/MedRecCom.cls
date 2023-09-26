Import SQLUser

/// Creator: 	bianshuai
/// CreateDate: 2016-12-30
/// Descript: 	电子药历公共类
Class web.DHCCM.MedRecCom Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Descript:	计数器
ClassMethod NewPid() As %String
{
	Q $I(^DHCST("MedRecCom"))
}

}
