/// 名称: DHCHAI.IRS.CCDiagnosSrv
/// 描述: 出院感染诊断服务类
/// 编写者: zhoubo
/// 编写日期: 2018-03-29
Class DHCHAI.IRS.CCDiagnosSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhoubo
/// CreatDate：   2018-03-29
/// Description:  保存处置状态
/// Input：       
/// Return:		  return>0:成功、return<1:失败 
/// w ##class(DHCHAI.IRS.CCDiagnosSrv).SaveCCDiagnos("22^1^dsfgsgsegse^12")
ClassMethod SaveCCDiagnos(aInputInfo As %String, separete As %String = "^") As %String
{
	New (aInputInfo,separete)
	Set return="-1"
	Quit:(aInputInfo="") return
	
	Set EpisodeDr = $p(aInputInfo,separete,1)
	Set Status    = $p(aInputInfo,separete,2)
	Set Opinion   = $p(aInputInfo,separete,3)
	Set ActUserDr = $p(aInputInfo,separete,4)
	
	Quit:(EpisodeDr="")||(Status="") return
	Set objAdm = ##class(DHCHAI.DP.PAAdm).GetObjById(EpisodeDr)
	Quit:'$IsObject(objAdm) return
	
	Set ID=$o(^DHCHAI.IR.CCDiagnosI("IndexEpisodeDr",EpisodeDr,0))
	
	Set InputStr = ID
	Set InputStr = InputStr_"^"_EpisodeDr
	Set InputStr = InputStr_"^"_Status
	Set InputStr = InputStr_"^"_Opinion
	Set InputStr = InputStr_"^"_""
	Set InputStr = InputStr_"^"_""
	Set InputStr = InputStr_"^"_ActUserDr
	
	Set flg = ##class(DHCHAI.IR.CCDiagnos).Update(InputStr,"^")
	if flg>0{
		Set return = 1
	}
	Quit return
}

}
