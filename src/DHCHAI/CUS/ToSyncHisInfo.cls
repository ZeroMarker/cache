/// 名称: DHCHAI.CUS.ToSyncHisInfo
/// 描述: HIS数据同步个性化服务
/// 编写者：zhufei
/// 编写日期: 2018-01-10
Class DHCHAI.CUS.ToSyncHisInfo Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// 通过特殊科室设置转换就诊类型
/// w ##class(DHCHAI.CUS.ToSyncHisInfo).GetAdmType("I",2)
ClassMethod GetAdmType(aAdmType As %String, aAdmLocDr As %String) As %String
{
	New (aAdmType,aAdmLocDr)
	Set return=""
	Quit:(aAdmType="") return
	
	Set return=aAdmType
	Set IsChangeAdmTypeByLoc=##class(DHCHAI.BT.Config).GetValByCode("CUS-IsChangeAdmTypeByLoc")
	If IsChangeAdmTypeByLoc=1 {
		//例：安贞急诊科急诊留观走住院流程
		//    急诊流水病人 AdmType="E"
		Set ChangeAdmTypeByEPLoc=##class(DHCHAI.BT.Config).GetValByCode("CUS-ChangeAdmTypeByEPLoc")
		/*Set ChangeAdmTypeByEPLoc="|"_ChangeAdmTypeByEPLoc_"|"
		Set aAdmLocDr="|"_aAdmLocDr_"|"
		If ChangeAdmTypeByEPLoc[aAdmLocDr {  //多值|分割 ： 2/急诊科
			Set return="EP"
		}
		*/
		For indId=1:1:$l(ChangeAdmTypeByEPLoc,"|"){
			Set ELocDr=+$p(ChangeAdmTypeByEPLoc,"|",indId)
			Continue:ELocDr=0
			Set:aAdmLocDr=ELocDr return="EP"
		}
		
		
	} Else {
		//例：协和急诊科急诊留观走急诊留观流程 AdmType="EP"
		//    急诊流水病人 AdmType="E"
	}
	Quit return
}

}
