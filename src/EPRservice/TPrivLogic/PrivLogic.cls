Class EPRservice.TPrivLogic.PrivLogic Extends %RegisteredObject [ ProcedureBlock ]
{

//"查看"操作的标志

Parameter ACTIONVIEW = "READ";

/// Creator: 陈文俊
/// CreatDate: 2008-05-12
/// Description：取出适用于EpisodeID的某一个Category下的第一个符合规则的模板
/// Table:
/// Input: EpisodeID--病人就诊号;parOthers--用于扩展的信息串（未用）;parCategoryID--Category的ID
/// Output:
/// Return:第一个符合规则的模板ID
ClassMethod GetTempForView(EpisodeID As %String, parOthers As %String, parCategoryID As %String) As %String
{
	 s privateActivity = "Y" //系统参数是否启用了模板权限
	 s resultTemplateID = "" //第一个符合规则的模板ID
	 s result = privateActivity_"^"_resultTemplateID
	 
	 q:(($d(EpisodeID)=0) || (EpisodeID = "")) result
	 q:(($d(parCategoryID)=0) || (parCategoryID = "")) result
	 
	 //取出参数设置，确认权限控制是否启动
	 s privateActivity = "Y"
	 s privateActivity = ..CheckTPrivActivity()
	 
	 if (privateActivity = "N")
	 {
		 s result = privateActivity_"^"_resultTemplateID
		 q result
	 }
	 
	 //取出病人的信息
	 s curPatInfo = ..GetPatInfo(EpisodeID)
	 q:(($d(curPatInfo)=0) || (curPatInfo = "")) ""

	 //取出第一个用于显示的模板
	 s resultTemplateID = ##class(EPRservice.TPrivLogic.CategoryActLogic).GetTempByCacAndAct(curPatInfo, parCategoryID, ..#ACTIONVIEW)
	 
	 //返回
	 s result = privateActivity_"^"_resultTemplateID
	 q result
}

/// Creator: 陈文俊
/// CreatDate: 2008-05-12
/// Description：判断某个EpisodeID是否适用某个TemplateId
/// Table:
/// Input: EpisodeID--病人就诊号;parOthers--用于扩展的信息串（未用）;parTemplateID--模板的ID
/// Output:
/// Return:是否适用  1--适用  0--不适用
ClassMethod CheckTempValid(EpisodeID As %String, parOthers As %String, parTemplateID As %String) As %Status
{
	 q:(($d(EpisodeID)=0) || (EpisodeID = "")) 0
	 q:(($d(parTemplateID)=0) || (parTemplateID = "")) 0
	 
	 //取出病人的信息
	 s curPatInfo = ..GetPatInfo(EpisodeID)
	 q:(($d(curPatInfo)=0) || (curPatInfo = "")) ""

	 //判断该病人是否适用parTemplateID
	 s result = ##class(EPRservice.TPrivLogic.TempActLogic).CanTempAct(parTemplateID, ..#ACTIONVIEW, curPatInfo)
	 
	 q result
}

/// Creator: 陈文俊
/// CreatDate: 2008-05-12
/// Description：取出病人信息
/// Table:
/// Input: EpisodeID--病人就诊号
/// Output:
/// Return:病人的信息,包括性别、当前科室、病人类型等
ClassMethod GetPatInfo(EpisodeID As %String) As %Library.List
{
	 q:(($d(EpisodeID)=0) || (EpisodeID = "")) ""
	 
	 s objPatInfo = ##class(EPRservice.TPrivLogic.PatientInfoAssist).%New()
	 s objPatInfo.AdmId = EpisodeID
	 
	 s patSex = objPatInfo.PatSex //性别
	 s patDept = objPatInfo.PatDept //当前科室
	 s patWard = objPatInfo.PatWard //当前病区
	 s patType = objPatInfo.PatType //病人类型
	 s patPriv = objPatInfo.PatPriv //所有权限
     
     q $lb(patSex,patDept,patWard,patType,patPriv)
}

//

/// Creator: 陈文俊
/// CreatDate: 2008-05-12
/// Description：系统参数是否设置为开启模板权限控制
/// Table:
/// Input:
/// Output:
/// Return:是否开启  Y--是  N--否
ClassMethod CheckTPrivActivity() As %String
{
	 s templatePrivActivityStr = "N"
	 s templatePrivActivityRowId = ""
	 
     s templatePrivActivityRowId = $o(^DHCEPRM.SysOptionI("NameIndex"," TPRIVACTIVITY",""))
	 if templatePrivActivityRowId'=""
	 {
		s templatePrivActivityStr=$li(^DHCEPRM.SysOptionD(templatePrivActivityRowId),4)	
	 }
	 
	 if templatePrivActivityStr '= "Y"
	 {
		s templatePrivActivityStr = "N"
	 }
	 
	 q templatePrivActivityStr
}

}
