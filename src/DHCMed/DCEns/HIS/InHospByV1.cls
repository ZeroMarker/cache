/// 名称: DHCMed.DCEns.HIS.InHospByV1
/// 描述: 在院患者列表数据输入服务类（东华HIS）
/// 编写者：zhufei
/// 编写日期: 2016-04-14
Class DHCMed.DCEns.HIS.InHospByV1 Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// *********************************************************************************
/// 以下内容为：同步在院患者列表数据方法
/// *********************************************************************************
/// Creator：     zhufei
/// CreatDate：   2016-04-14
/// Description:  根据起止日期同步在院患者列表数据
/// Table：       DHCMed.DC.HIS.InHospital
/// Input：       FromDate:开始日期
///               ToDate:结束日期
///               HospCode:医院缩写码（DHCMed_DC_SYS.BTHospital.SCode）
/// Return：      OK
/// w ##class(DHCMed.DCEns.HIS.InHospByV1).SyncInHospByDate("2014-01-01","2015-12-31","HIS01")
ClassMethod SyncInHospByDate(aFromDate As %String, aToDate As %String, aHospCode As %String, aInitFlag As %String = "0") As %String
{
	New (aFromDate,aToDate,aHospCode,aInitFlag)
	Set return="0^入参错误",Count=0
	Quit:(aFromDate="")||(aToDate="")||(aHospCode="") return
	
	Set $ZT="SyncInHospByDateErr"
	
	Set return="-1^医院缩写码维护错误"
	Set flg=##class(DHCMed.DC.BTHospital).GetIDBySCode(aHospCode)
	Quit:flg="" return
	
	Set:aFromDate["-" aFromDate=$zdh(aFromDate,3)
	Set:aToDate["-" aToDate=$zdh(aToDate,3)
	
	If aInitFlag=1 {
		//在院患者列表数据
		Kill ^DHCMed.DC.HIS.InHospitalD
		Kill ^DHCMed.DC.HIS.InHospitalI
	}
	
	//处理住院病人列表
	Set ret=..SyncInHospByIP(aFromDate,aToDate,aHospCode)
	Set:ret>0 Count=Count+ret
	
	//处理急诊病人列表
	Set ret=..SyncInHospByEP(aFromDate,aToDate,aHospCode)
	Set:ret>0 Count=Count+ret
	
	Set return=Count_"^住在病人列表数据同步完成"
	Quit return
	
SyncInHospByDateErr
	Quit "-999^"_$ZError
}

ClassMethod SyncInHospByIP(aFromDate As %String, aToDate As %String, aHospCode As %String) As %String
{
	New (aFromDate,aToDate,aHospCode)
	Set return=0,Count=0
	Quit:(aFromDate="")||(aToDate="")||(aHospCode="") return
	
	//在院患者列表
	Set xWardID=""
	For {
		Set xWardID=$o(^PAADMi("CurrWard",xWardID))
		Quit:xWardID=""
		
		Set xRoomID=""
		For {
			Set xRoomID=$o(^PAADMi("CurrWard",xWardID,xRoomID))
			Quit:xRoomID=""
			
			Set xPaadm=""
			For {
				Set xPaadm=$o(^PAADMi("CurrWard",xWardID,xRoomID,xPaadm))
				Quit:xPaadm=""
				
				Set AdmInfo=$g(^PAADM(xPaadm))
				Continue:$p(AdmInfo,"^",2)'="I"      //就诊类型过滤
				
				Set flg=..UpdatePaadm(xPaadm,aHospCode)
				If flg>0 {
					Set Count=Count+1
				}
			}
		}
	}
	
	//出院患者列表
	Set DischDateIndex=##Class(DHCMed.SSIO.FromAdmSrv).GetDischDateIndex()
	For xDate=aFromDate:1:aToDate {
		Set xPaadm=0
		For {
			Set xPaadm=$o(^PAADMi(DischDateIndex,xDate,xPaadm))
			Quit:xPaadm=""
			
			Set AdmInfo=$g(^PAADM(xPaadm))
			Continue:$p(AdmInfo,"^",2)'="I"      //就诊类型过滤
			
			Set flg=..UpdatePaadm(xPaadm,aHospCode)
			If flg>0 {
				Set Count=Count+1
			}
		}
	}
	Set return=Count
	Quit return
}

ClassMethod SyncInHospByEP(aFromDate As %String, aToDate As %String, aHospCode As %String) As %String
{
	New (aFromDate,aToDate,aHospCode)
	Set return=0,Count=0
	Quit:(aFromDate="")||(aToDate="")||(aHospCode="") return
	
	//急诊就诊患者列表
	For xDate=aFromDate:1:aToDate {
		Set xPaadm=0
		For {
			Set xPaadm=$o(^PAADMi("PAADM_AdmDate",xDate,xPaadm))
			Quit:xPaadm=""
			
			Set AdmInfo=$g(^PAADM(xPaadm))
			Continue:($p(AdmInfo,"^",2)'="E")&&($p(AdmInfo,"^",2)'="EP")      //就诊类型过滤
			
			Set flg=..UpdatePaadm(xPaadm,aHospCode)
			If flg>0 {
				Set Count=Count+1
			}
		}
	}
	
	//急诊留观患者列表
	Set xWardID=""
	For {
		Set xWardID=$o(^PAADMi("CurrWard",xWardID))
		Quit:xWardID=""
		
		Set xRoomID=""
		For {
			Set xRoomID=$o(^PAADMi("CurrWard",xWardID,xRoomID))
			Quit:xRoomID=""
			
			Set xPaadm=""
			For {
				Set xPaadm=$o(^PAADMi("CurrWard",xWardID,xRoomID,xPaadm))
				Quit:xPaadm=""
				
				Set AdmInfo=$g(^PAADM(xPaadm))
				Continue:($p(AdmInfo,"^",2)'="E")&&($p(AdmInfo,"^",2)'="EP")      //就诊类型过滤
				
				Set flg=..UpdatePaadm(xPaadm,AdmType,aHospCode)
				If flg>0 {
					Set Count=Count+1
				}
			}
		}
	}
	
	//急诊留观出院患者列表
	Set DischDateIndex=##Class(DHCMed.SSIO.FromAdmSrv).GetDischDateIndex()
	For xDate=aFromDate:1:aToDate {
		Set xPaadm=0
		For {
			Set xPaadm=$o(^PAADMi(DischDateIndex,xDate,xPaadm))
			Quit:xPaadm=""
			
			Set AdmInfo=$g(^PAADM(xPaadm))
			Continue:($p(AdmInfo,"^",2)'="E")&&($p(AdmInfo,"^",2)'="EP")      //就诊类型过滤
			
			Set flg=..UpdatePaadm(xPaadm,aHospCode)
			If flg>0 {
				Set Count=Count+1
			}
		}
	}
	Set return=Count
	
	Quit return
}

/// w ##Class(DHCMed.DCEns.HIS.InHospByV1).UpdatePaadm(206,"HIS01")
ClassMethod UpdatePaadm(aPaadm As %String, aHospCode As %String) As %String
{
	New (aPaadm,aHospCode)
	Set return=0
	Quit:(aPaadm="")||(aHospCode="") return
	
	Set PatientID=$p($g(^PAADM(aPaadm)),"^",1)
	Set AdmType=$p($g(^PAADM(aPaadm)),"^",2)
	Set AdmDateTime=##Class(DHCMed.SSIO.FromAdmSrv).GetAdmDateTime(aPaadm)
	Set AdmDate=$p(AdmDateTime,"^",1)
	Set AdmTime=$p(AdmDateTime,"^",2)
	Set DischDateTime=##Class(DHCMed.SSIO.FromAdmSrv).GetDischDateTime(aPaadm)
	Set DischDate=$p(DischDateTime,"^",1)
	Set DischTime=$p(DischDateTime,"^",2)
	If DischDate'="" {
		Set AdmDays=DischDate-AdmDate+1
		Set:AdmDays<1 AdmDays=1
	} Else {
		Set AdmDays=-1
	}
	Set VisitStatus=$p($g(^PAADM(aPaadm)),"^",20)
	Set IsActive=$s(VisitStatus="C":0,VisitStatus="P":0,1:1)
	
	If (AdmType="E")&&(DischDate="") {
		Set xAdmVisitStatus=0
		For {
			Set xAdmVisitStatus=$o(^DHCADMVisitStatus(0,"PAADM",aPaadm,xAdmVisitStatus))
			Quit:xAdmVisitStatus=""
			Set VisitStatusID=$p($g(^DHCADMVisitStatus(xAdmVisitStatus)),"^",2)
			Set VisitStatusCode=$p($g(^DHCPACVisitStatus(VisitStatusID)),"^",1)
			Set VisitStatusDesc=$p($g(^DHCPACVisitStatus(VisitStatusID)),"^",2)
			Continue:(VisitStatusCode'="Stay")&&(VisitStatusDesc'="留观")
			Set AdmType="EP"
		}
	}
	
	Set InputStr=aPaadm
	Set InputStr=InputStr_"^"_PatientID
	Set InputStr=InputStr_"^"_AdmType
	Set InputStr=InputStr_"^"_aHospCode
	Set InputStr=InputStr_"^"_AdmDate
	Set InputStr=InputStr_"^"_AdmTime
	Set InputStr=InputStr_"^"_DischDate
	Set InputStr=InputStr_"^"_DischTime
	Set InputStr=InputStr_"^"_AdmDays
	Set InputStr=InputStr_"^"_IsActive
	Set return=##class(DHCMed.DC.HIS.InHospital).Update(InputStr)
	Quit return
}

}
