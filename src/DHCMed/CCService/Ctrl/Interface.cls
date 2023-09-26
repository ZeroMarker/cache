/// 名称: DHCMed.CCService.Ctrl.Interface
/// 描述: 住院患者监控公共接口
/// 编写者：zhufei
/// 编写日期: 2011-10-31
Class DHCMed.CCService.Ctrl.Interface Extends DHCMed.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// w ##Class(DHCMed.CCService.Ctrl.Interface).iconEval("",537)
ClassMethod iconEval(argSubjectID As %String, argPaadm As %String) As %String
{
	New (argSubjectID,argPaadm)
	Set return=##Class(DHCMed.CCService.Ctrl.Evaluation).iconEvaluation(argSubjectID,argPaadm)
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2011-10-31
/// Description:  就诊号取监控数据
/// Return:       String 或 ""
/// w ##class(DHCMed.CCService.Ctrl.Interface).GetInfCtrlResult(74362,1)
ClassMethod GetInfCtrlResult(argPaadm As %String, argSubjectID As %String) As %String
{
	New (argPaadm,argSubjectID)
	Set return=""
	
	Set $ZT="GetInfCtrlResultErr"
	Set %ZIndex=$zn,%JIndex=$j
	Kill ^TMP(%ZIndex,%JIndex,"DHCMedCCExpList")
	
	Set flg=##class(DHCMed.CCService.Sys.CtrlProcess).GetDHCMedCCExpList(argSubjectID,"")
	Quit:flg<1 $$$OK
	Set ctrlDtls=##class(DHCMed.CCService.Sys.CtrlProcess).Main(argPaadm)
	For index=1:1:$listlength(ctrlDtls) {
		Set ctrlDtl=$list(ctrlDtls,index)
		Set ItemDesc=$list(ctrlDtl,1)
		Set Score=$list(ctrlDtl,2)
		Set Result=$list(ctrlDtl,3)
		Set ExtraData=$list(ctrlDtl,4)   //$lb()
		Set ErrorData=$list(ctrlDtl,5)   //$lb()
		//w ItemDesc,!
		//w $listtostring(ExtraData,"---"),!
		//w $listtostring(ErrorData,"---"),!
		Set return=return_ItemDesc_":"
		For indexExtra=1:1:$listlength(ExtraData) {
			Set return=return_" "_$list(ExtraData,indexExtra)
		}
	}
	Kill ^TMP(%ZIndex,%JIndex,"DHCMedCCExpList")
	
	Quit return
	
GetInfCtrlResultErr
	Kill ^TMP($zn,$j,"DHCMedCCExpList")
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2011-10-31
/// Description:  就诊号取监控数据
/// Return:       String 或 ""
/// w ##class(DHCMed.CCService.Ctrl.Interface).GetEpdCtrlResult(1877,3)
ClassMethod GetEpdCtrlResult(argPaadm As %String, argSubjectID As %String) As %String
{
	New (argPaadm,argSubjectID)
	Set return=""
	
	Set $ZT="GetEpdCtrlResultErr"
	Set %ZIndex=$zn,%JIndex=$j
	Kill ^TMP(%ZIndex,%JIndex,"DHCMedCCExpList")
	
	set ret=##class(DHCMed.EPDService.Service).GetEpdNotRepDiagnos(argPaadm)
	quit ret
	
	Set flg=##class(DHCMed.CCService.Sys.CtrlProcess).GetDHCMedCCExpList(argSubjectID,"")
	Quit:flg<1 $$$OK
	Set ctrlDtls=##class(DHCMed.CCService.Sys.CtrlProcess).Main(argPaadm)
	Set repDia=##class(DHCMed.EPDService.Service).GetEpdRepDiagnos(argPaadm) //Add By LiYang 2012-04-12获取已经上报的疾病
	Set repDia=$p($p(repDia,"[",2),"]",1)
	For index=1:1:$listlength(ctrlDtls) {
		Set ctrlDtl=$list(ctrlDtls,index)
		Set ItemDesc=$list(ctrlDtl,1)
		Set Score=$list(ctrlDtl,2)
		Set Result=$list(ctrlDtl,3)
		Set ExtraData=$list(ctrlDtl,4)   //$lb()
		Set ErrorData=$list(ctrlDtl,5)   //$lb()
		Set Resume=$list(ctrlDtl,6) //Add By LiYang 2012-04-12 传出的附加项目，可以用来和其他系统进行关联
		//Continue:(repDia[Resume)&&(Resume'="") //Modified By LiYang 2012-04-12 如果已经在已上报列表中，就不提示了！
		//update by pylian 2015-11-24  //fix bug 150532传染病已报仍有未报的图标
		For indexExtra=1:1:$listlength(ExtraData) {
			Set Data=$listtostring(ExtraData,"^")
			Set Data=$p($p(Data,"^",indexExtra),"】",2)
			Continue:(repDia[Data)&&(Data'="")
			Set return=return_" "_$list(ExtraData,indexExtra)
		}
		Set:return'="" return=ItemDesc_":" _return
	}
	Kill ^TMP(%ZIndex,%JIndex,"DHCMedCCExpList")
	Quit return
	
GetEpdCtrlResultErr
	Kill ^TMP($zn,$j,"DHCMedCCExpList")
	Quit return
}

}
