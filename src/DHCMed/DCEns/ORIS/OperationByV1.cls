/// 名称: DHCMed.DCEns.ORIS.OperationByV1
/// 描述: 手麻系统数据输入服务类（东华手麻系统V1.0）
/// 编写者：zhufei
/// 编写日期: 2016-04-19
Class DHCMed.DCEns.ORIS.OperationByV1 Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// *********************************************************************************
/// 以下内容为：同步手麻系统数据方法
/// *********************************************************************************
/// Creator：     zhufei
/// CreatDate：   2016-04-19
/// Description:  根据起止日期同步手麻系统数据
/// Table：       DHCMed.DC.ORIS.Operation
/// Input：       FromDate:开始日期
///               ToDate:结束日期
///               HospCode:医院缩写码（DHCMed_DC_SYS.BTHospital.SCode）
/// Return：      OK
/// w ##class(DHCMed.DCEns.ORIS.OperationByV1).SyncOperByDate("2015-03-10","2015-03-20","ORIS01")
ClassMethod SyncOperByDate(aFromDate As %String, aToDate As %String, aHospCode As %String, aInitFlag As %String = "0") As %String
{
	New (aFromDate,aToDate,aHospCode,aInitFlag)
	Set return="0^入参错误",Count=0
	Quit:(aFromDate="")||(aToDate="")||(aHospCode="") return
	
	Set:aFromDate["-" aFromDate=$zdh(aFromDate,3)
	Set:aToDate["-" aToDate=$zdh(aToDate,3)
	
	If aInitFlag=1 {
		//手麻系统数据
		Kill ^DHCMed.DC.ORIS.OperationD
		Kill ^DHCMed.DC.ORIS.OperationI
	}
	
	Set return="-1^医院缩写码维护错误"
	Set SSHospCodeList=##class(DHCMed.DCEns.HospitalSrv).GetCodeBySCode(aHospCode)
	Quit:SSHospCodeList="" return
	
	Set xHospCode=""
	For {
		Set xHospCode=$o(^DHCMed.DC.HIS.InHospitalI("IndexInHospital",xHospCode))
		Quit:xHospCode=""
		
		Set tHospCode=$tr(xHospCode," ","")
		Set tSSHospCodeList=##class(DHCMed.DCEns.HospitalSrv).GetCodeBySCode(tHospCode)
		Continue:tSSHospCodeList=""
		
		Set HospCodeFlag=0
		For indHosp=1:1:$ll(tSSHospCodeList) {
			Set tSSHospCode=$list(tSSHospCodeList,indHosp)
			Continue:tSSHospCode=""
			Continue:$listfind(SSHospCodeList,tSSHospCode)<1
			Set HospCodeFlag=1
			Quit
		}
		Continue:HospCodeFlag<1
		
		Set xAdmType=""
		For {
			Set xAdmType=$o(^DHCMed.DC.HIS.InHospitalI("IndexInHospital",xHospCode,xAdmType))
			Quit:xAdmType=""
			
			Continue:(xAdmType'="I")&&(xAdmType'="E")&&(xAdmType'="EP")
			
			Set xAdmDays=""
			For {
				Set xAdmDays=$o(^DHCMed.DC.HIS.InHospitalI("IndexInHospital",xHospCode,xAdmType,xAdmDays))
				Quit:xAdmDays=""
				
				Set xDate=$s(xAdmDays>0:aFromDate-xAdmDays,1:"")
				For {
					Set xDate=$o(^DHCMed.DC.HIS.InHospitalI("IndexInHospital",xHospCode,xAdmType,xAdmDays,xDate))
					Quit:xDate=""
					
					Quit:(xAdmDays>0)&&(xDate>(aToDate-xAdmDays+1))
					Quit:(xAdmDays<0)&&(xDate>aToDate)
					
					Set xID=0
					For {
						Set xID=$o(^DHCMed.DC.HIS.InHospitalI("IndexInHospital",xHospCode,xAdmType,xAdmDays,xDate,xID))
						Quit:xID=""
						
						Set objAdm=##class(DHCMed.DC.HIS.InHospital).GetObjById(xID)
						Continue:'$IsObject(objAdm)
						Continue:objAdm.IsActive'=1
						Set EpisodeID=objAdm.EpisodeID
						
						Set Count=Count+1
						W:(Count#100)=0 "已处理 "_Count_" 条数据!",!
						
						Set flg=..UpdateOperation(EpisodeID,aHospCode,aFromDate,aToDate)
					}
				}
			}
		}
	}
	
	Quit "OK"
}

/// w ##Class(DHCMed.DCEns.ORIS.OperationByV1).UpdateOperation(206,"ORIS01")
ClassMethod UpdateOperation(aPaadm As %String, aHospCode As %String, aFromDate As %String, aToDate As %String) As %String
{
	New (aPaadm,aHospCode,aFromDate,aToDate)
	Set return=0
	Quit:(aPaadm="") return
	
	Quit return
}

/// *********************************************************************************
/// 以下内容为：同步检验基础数据方法
/// *********************************************************************************
/// Creator：     zhufei
/// CreatDate：   2016-04-19
/// Description:  手麻系统基础数据同步
/// Table：       DHCMed.DC.ORIS.*
/// Input：       HospCode ：医院缩写码（DHCMed_DC_SYS.BTHospital.SCode）
/// Return：      OK
/// w ##class(DHCMed.DCEns.ORIS.OperationByV1).ProcBaseData("ORIS01")
ClassMethod ProcBaseData(aHospCode As %String, aInitFlag As %String = "0") As %String
{
	New (aHospCode,aInitFlag)
	Set return="0^入参为空"
	Quit:aHospCode="" return
	
	Set $ZT="ProcBaseDataErr"
	
	Set return="-1^医院缩写码维护错误"
	Set flg=##class(DHCMed.DC.BTHospital).GetIDBySCode(aHospCode)
	Quit:flg="" return
	
	//处理【基础字典】ASA评分
	If aInitFlag=1 {
		Kill ^DHCMed.DC.ORIS.BTASAScoreD
		Kill ^DHCMed.DC.ORIS.BTASAScoreI
	}
	Set flg=..ChangeBTASAScore()
	
	//处理【基础字典】愈合情况
	If aInitFlag=1 {
		Kill ^DHCMed.DC.ORIS.BTHealingD
		Kill ^DHCMed.DC.ORIS.BTHealingI
	}
	Set flg=..ChangeBTHealing()
	
	//处理【基础字典】切口等级
	If aInitFlag=1 {
		Kill ^DHCMed.DC.ORIS.BTIncisionD
		Kill ^DHCMed.DC.ORIS.BTIncisionI
	}
	Set flg=..ChangeBTIncision()
	
	//处理【基础字典】手术风险分级
	If aInitFlag=1 {
		Kill ^DHCMed.DC.ORIS.BTNNISGradeD
		Kill ^DHCMed.DC.ORIS.BTNNISGradeI
	}
	Set flg=..ChangeBTNNISGrade()
	
	//处理【基础字典】手术类型
	If aInitFlag=1 {
		Kill ^DHCMed.DC.ORIS.BTOperTypeD
		Kill ^DHCMed.DC.ORIS.BTOperTypeI
	}
	Set flg=..ChangeBTOperType()
	
	Quit "OK"
	
ProcBaseDataErr
	Quit "-999^"_$ZError
}

ClassMethod ChangeBTASAScore(aHospCode As %String) As %String
{
	New
	Set flg=##class(DHCMed.DC.ORIS.BTASAScore).Update("1^P1^^1")
	Set flg=##class(DHCMed.DC.ORIS.BTASAScore).Update("2^P2^^1")
	Set flg=##class(DHCMed.DC.ORIS.BTASAScore).Update("3^P3^^1")
	Set flg=##class(DHCMed.DC.ORIS.BTASAScore).Update("4^P4^^1")
	Set flg=##class(DHCMed.DC.ORIS.BTASAScore).Update("5^P5^^1")
	Quit 1
}

ClassMethod ChangeBTHealing() As %String
{
	New
	Set flg=##class(DHCMed.DC.ORIS.BTHealing).Update("1^甲^^1")
	Set flg=##class(DHCMed.DC.ORIS.BTHealing).Update("2^乙^^1")
	Set flg=##class(DHCMed.DC.ORIS.BTHealing).Update("3^丙^^1")
	Set flg=##class(DHCMed.DC.ORIS.BTHealing).Update("0^无^^1")
	Quit 1
}

ClassMethod ChangeBTIncision() As %String
{
	New
	Set flg=##class(DHCMed.DC.ORIS.BTIncision).Update("1^Ⅰ^^1")
	Set flg=##class(DHCMed.DC.ORIS.BTIncision).Update("2^Ⅱ^^1")
	Set flg=##class(DHCMed.DC.ORIS.BTIncision).Update("3^Ⅲ^^1")
	Set flg=##class(DHCMed.DC.ORIS.BTIncision).Update("4^Ⅳ^^1")
	Set flg=##class(DHCMed.DC.ORIS.BTIncision).Update("0^无^^1")
	Quit 1
}

ClassMethod ChangeBTNNISGrade() As %String
{
	New
	Set flg=##class(DHCMed.DC.ORIS.BTNNISGrade).Update("0^0^^1")
	Set flg=##class(DHCMed.DC.ORIS.BTNNISGrade).Update("1^1^^1")
	Set flg=##class(DHCMed.DC.ORIS.BTNNISGrade).Update("2^2^^1")
	Set flg=##class(DHCMed.DC.ORIS.BTNNISGrade).Update("3^3^^1")
	Quit 1
}

ClassMethod ChangeBTOperType() As %String
{
	New
	Set flg=##class(DHCMed.DC.ORIS.BTOperType).Update("E^急诊^^1")
	Set flg=##class(DHCMed.DC.ORIS.BTOperType).Update("S^择期^^1")
	Quit 1
}

}
