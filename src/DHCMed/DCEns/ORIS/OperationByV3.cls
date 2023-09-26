/// 名称: DHCMed.DCEns.ORIS.OperationByV3
/// 描述: 手麻系统数据输入服务类（安贞手麻接口,麦迪斯顿）
/// 编写者：zhufei
/// 编写日期: 2016-04-19
Class DHCMed.DCEns.ORIS.OperationByV3 Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
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
/// w ##class(DHCMed.DCEns.ORIS.OperationByV3).SyncOperByDate("2016-04-25","2016-04-28","ORIS01","1")
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

/// w ##Class(DHCMed.DCEns.ORIS.OperationByV3).UpdateOperation(21977096,"","61037","64037")
ClassMethod UpdateOperation(aPaadm As %String, aHospCode As %String, aFromDate As %String, aToDate As %String) As %String
{
	New (aPaadm,aHospCode,aFromDate,aToDate)
	Set return=0
	Quit:(aPaadm="") return
	
	Set xOpeschi=""
    For {
		Set xOpeschi=$o(^opeschi(0,"ADM",aPaadm,xOpeschi))
		Quit:(xOpeschi="")||(xOpeschi="room")
		
		Set OperStatus=$p($g(^opesch(xOpeschi)),"^",28)
		Set IsActive=$s(OperStatus'="完成":OperStatus=0,1:1)
		Set OperICD9=""
		Set OperDesc=$p($g(^opesch(xOpeschi,"ADD",6)),"^",1)     //手术名称，多个手术用分号(;)串写起来）
		Set OperDateTime=$p($g(^opesch(xOpeschi,"ADD",6)),"^",8) //手术开始时间(2001-01-01 12:00:00)
		Set OperDate=$p(OperDateTime," ",1)
		Set:OperDate["-" OperDate=$zdh(OperDate,3)
		Continue:(OperDate'="")&&(OperDate>aToDate)
		
		Set OperSttTime=$p(OperDateTime," ",2)
		Set:OperSttTime[":" OperSttTime=$zth(OperSttTime,1)
		Set OperEndDateTime=$p($g(^opesch(xOpeschi,"ADD",6)),"^",9) //手术结束时间(2001-01-01 12:00:00)
		Set OperEndDate=$p(OperEndDateTime," ",1)
		Set:OperEndDate["-" OperEndDate=$zdh(OperEndDate,3)
		Set OperEndTime=$p(OperEndDateTime," ",2)
		Set:OperEndTime[":" OperEndTime=$zth(OperEndTime,1)
		Continue:(OperEndDate'="")&&(OperEndDate<aFromDate)
		
		Set Operator=$p($g(^opesch(xOpeschi,"ADD",6)),"^",5) //手术医生（多个手术医生用分号(;)串写起来）
		Set Assistant1=$p($g(^opesch(xOpeschi)),"^",5)
		Set Assistant2=$p($g(^opesch(xOpeschi)),"^",6)
		Set AnesMethod=$p($g(^opesch(xOpeschi,"ADD",5)),"^",2) //实际麻醉方式（多个麻醉方式用分号(;)串写起来）
		Set Anesthesia=$p($g(^opesch(xOpeschi,"ADD",5)),"^",1) //麻醉医生（多个麻醉师用分号(;)串写起来）
		
		//手术类型（急诊、择期、损伤）
		Set OperTypeDesc = ""
		Set OperTypeDR=""
		Set OperTypeDR=##class(DHCMed.DC.ORIS.BTOperType).GetIDByCodeDesc("",OperTypeDesc)
		If OperTypeDR="" {
			Set OperTypeDR=##class(DHCMed.DC.ORIS.BTOperType).Update(OperTypeDesc_"^"_OperTypeDesc_"^^1")
			Set:OperTypeDR<1 OperTypeDR=""
		}
		
		//手术科室
		Set OperLocDR=$p($g(^opesch(xOpeschi)),"^",25)
		Set OperLocDesc=""
		
		//切口等级（Ⅰ、Ⅱ、Ⅲ、Ⅳ、无）
		Set IncisionDesc=$p($g(^opesch(xOpeschi)),"^",50) 			//切口类型
		Set IncisionDR=##class(DHCMed.DC.ORIS.BTIncision).GetIDByCodeDesc("",IncisionDesc)
		If IncisionDR="" {
			Set IncisionDR=##class(DHCMed.DC.ORIS.BTIncision).Update(IncisionDesc_"^"_IncisionDesc_"^^1")
			Set:IncisionDR<1 IncisionDR=""
		}
		
		//愈合情况(甲、乙、丙、无)
		Set HealingDesc=""										
		Set HealingDR=""
		Set HealingDR=##class(DHCMed.DC.ORIS.BTHealing).GetIDByCodeDesc("",HealingDesc)
		If HealingDR="" {
			Set HealingDR=##class(DHCMed.DC.ORIS.BTHealing).Update(HealingDesc_"^"_HealingDesc_"^^1")
			Set:HealingDR<1 HealingDR=""
		}
		
		//麻醉ASA评分（P1、P2、P3、P4、P5）
		Set ASAScore=$p($g(^opesch(xOpeschi,"ADD",5)),"^",3)
		//安贞医院接口返回评分是罗马数字，特殊处理
		Set:ASAScore["Ⅰ" ASAScore="P1"
		Set:ASAScore["Ⅱ" ASAScore="P2"
		Set:ASAScore["Ⅲ" ASAScore="P3"
		Set:ASAScore["Ⅳ" ASAScore="P4"
		Set:ASAScore["Ⅴ" ASAScore="P5"
		Set ASAScoreDR=##class(DHCMed.DC.ORIS.BTASAScore).GetIDByCodeDesc("",ASAScore)
		If ASAScoreDR="" {
			Set ASAScoreDR=##class(DHCMed.DC.ORIS.BTASAScore).Update(ASAScore_"^"_ASAScore_"^^1")
			Set:ASAScoreDR<1 ASAScoreDR=""
		}
		
		//NNIS分级 （0、1、2、3）
		Set NNISGrade=$p($g(^opesch(xOpeschi,"ADD",6)),"^",6)
		Set NNISGradeDR=##class(DHCMed.DC.ORIS.BTNNISGrade).GetIDByCodeDesc(NNISGrade,"")
		If NNISGradeDR="" {
			Set NNISGradeDR=##class(DHCMed.DC.ORIS.BTNNISGrade).Update(NNISGrade_"^"_NNISGrade_"^^1")
			Set:NNISGradeDR<1 NNISGradeDR=""
		}
		
		//手术持续时间（小时）
		Set OperHour=""
		if (+OperEndDate'=0)&&(+OperDate'=0)&&(+OperEndTime'=0)&&(+OperSttTime'=0)
		{
			If OperEndDate=OperDate	//当天手术
			{
				Set OperHour=(OperEndTime-OperSttTime)/3600
			}else{		//跨天手术
				Set OperHour=((86400-OperSttTime)+OperEndTime)/3600
			}
		}
		Set InputStr=xOpeschi
		Set InputStr=InputStr_"^"_aPaadm
		Set InputStr=InputStr_"^"_OperICD9
		Set InputStr=InputStr_"^"_OperDesc
		Set InputStr=InputStr_"^"_OperTypeDR
		Set InputStr=InputStr_"^"_OperDate
		Set InputStr=InputStr_"^"_OperSttTime
		Set InputStr=InputStr_"^"_OperEndDate
		Set InputStr=InputStr_"^"_OperEndTime
		Set InputStr=InputStr_"^"_OperLocDR
		Set InputStr=InputStr_"^"_Operator
		Set InputStr=InputStr_"^"_Assistant1
		Set InputStr=InputStr_"^"_Assistant2
		Set InputStr=InputStr_"^"_IncisionDR
		Set InputStr=InputStr_"^"_HealingDR
		Set InputStr=InputStr_"^"_AnesMethod
		Set InputStr=InputStr_"^"_Anesthesia
		Set InputStr=InputStr_"^"_ASAScoreDR
		Set InputStr=InputStr_"^"_NNISGradeDR
		Set InputStr=InputStr_"^"_$s(OperHour'="":$fn(OperHour,"",1),OperHour="":"")
		Set InputStr=InputStr_"^"_IsActive
		Set return=##class(DHCMed.DC.ORIS.Operation).Update(InputStr)
    }
	
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
/// w ##class(DHCMed.DCEns.ORIS.OperationByV3).ProcBaseData("ORIS01",1)
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

ClassMethod ChangeBTASAScore() As %String
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
