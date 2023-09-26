/// 名称: DHCMed.DCEns.HospitalSrv
/// 描述: 数据池医院相关服务类
/// 编写者：zhufei
/// 编写日期: 2016-04-28
Class DHCMed.DCEns.HospitalSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhufei
/// CreatDate：   2016-04-28
/// Description:  根据数据池系统缩写码
/// Table：       DHCMed.SS.Hospital、CT_Hospital、DHCMed.DC.BTHospital
/// Input：       aEpisodeID  : 就诊号
///               aSProCode   : 子系统代码
/// Return：      返回%List
/// w ##class(DHCMed.DCEns.HospitalSrv).GetHospCode("LIS","11-AZ")
ClassMethod GetHospCode(aSProCode As %String, aSSHospCode As %String) As %List
{
	New (aSProCode,aSSHospCode)
	Set return=""
	Quit:(aSProCode="")||(aSSHospCode="") return
	
	Set SCodeList=""
	Set xSCode=""
	For {
		Set xSCode=$o(^DHCMed.DC.BTHospitalI("IndexSCode",xSCode))
		Quit:xSCode=""
		Continue:$e(xSCode,2,$l(aSProCode)+1)'=aSProCode
		Set xID=0
		For {
			Set xID=$o(^DHCMed.DC.BTHospitalI("IndexSCode",xSCode," "_$zcvt(aSSHospCode,"U"),xID))
			Quit:xID=""
			Set obj=##class(DHCMed.DC.BTHospital).GetObjById(xID)
			Continue:'$IsObject(obj)
			Set Active=obj.Active
			Continue:Active'=1
			Set SCode=obj.SCode
			Continue:$listfind(SCodeList,SCode)>0
			Set SCodeList=SCodeList_$lb(SCode)
		}
	}
	Set return=SCodeList
	
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2016-03-29
/// Description:  根据代码或缩写码取医院字典
/// Table：       DHCMed.DC.BTHospital
/// Input：       SCode : DHCMed.DC.BTHospital.SCode
/// Return：      返回%List
/// w ##class(DHCMed.DCEns.HospitalSrv).GetCodeBySCode("LIS01")
ClassMethod GetCodeBySCode(aSCode As %String) As %List
{
	New (aSCode)
	Set return=""
	Quit:aSCode="" return
	
	Set CodeList=""
	Set xCode=""
	For {
		Set xCode=$o(^DHCMed.DC.BTHospitalI("IndexSCode"," "_$zcvt(aSCode,"U"),xCode))
		Quit:xCode=""
		
		Set xID=$o(^DHCMed.DC.BTHospitalI("IndexSCode"," "_$zcvt(aSCode,"U"),xCode,0))
		Continue:xID=""
		
		Set obj=##class(DHCMed.DC.BTHospital).GetObjById(xID)
		Continue:'$IsObject(obj)
		Continue:obj.Active'=1
		Set Code=obj.Code
		Continue:$listfind(CodeList,Code)>0
		Set CodeList=CodeList_$lb(Code)
	}
	Set return=CodeList
	
	Quit return
}

}
