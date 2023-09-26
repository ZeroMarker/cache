/// 名称: DHCWMR.MRService.ImportDataByFP
/// 描述: 导入东华病案编目数据接口服务
/// 编写者：zhufei
/// 编写日期: 2015-08-27
Class DHCWMR.MRService.ImportDataByFP Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhufei
/// CreatDate：   2015-08-27
/// Description:  导入病案编目数据接口服务
/// Table：       
/// Input：       aFromDate ：开始日期
///               aToDate ：结束日期
/// Return：      return=0:失败，return=1:成功
/// w ##class(DHCWMR.MRService.ImportDataByFP).Task()
ClassMethod Task(aMrTypeID As %String, aDateFrom As %String, aDateTo As %String) As %String
{
	New (aMrTypeID,aDateFrom,aDateTo)
	Set return=0
	Quit:(aMrTypeID="")||(aDateFrom="")||(aDateTo="") return
	
	Set xIsFinish="",Count=0
	For {
		Set xIsFinish=$o(^DHCWMR.FP.FrontPageI("IndexUpdateDate",xIsFinish))
		Quit:xIsFinish=""
		Continue:xIsFinish=0
		
		Set xDate=aDateFrom-1
		For {
			Set xDate=$o(^DHCWMR.FP.FrontPageI("IndexUpdateDate",xIsFinish,xDate))
			Quit:xDate=""
			Quit:xDate>aDateTo
			
			Set xTime=""
			For {
				Set xTime=$o(^DHCWMR.FP.FrontPageI("IndexUpdateDate",xIsFinish,xDate,xTime))
				Quit:xTime=""
				
				Set xFpID=0
				For {
					Set xFpID=$o(^DHCWMR.FP.FrontPageI("IndexUpdateDate",xIsFinish,xDate,xTime,xFpID))
					Quit:xFpID=""
					
					Set objFP=##class(DHCWMR.FP.FrontPage).GetObjById(xFpID)
					Continue:'$IsObject(objFP)
					Continue:'$IsObject(objFP.FPVolumeDr)
					If aMrTypeID'="" {
						Continue:objFP.FPVolumeDr.SVMainDr.SMMrType.%Id()'=aMrTypeID
					}
					Set VolumeID=objFP.FPVolumeDr.%Id()
					Set EpisodeID=##Class(DHCWMR.SS.Volume).GetEpisodeID(VolumeID)
					Continue:EpisodeID=""
					
					Set InputStr=""
					Set $p(InputStr,"^",1)=EpisodeID
					Set $p(InputStr,"^",11)=objFP.FPUpdateDate
					Set $p(InputStr,"^",12)=objFP.FPUpdateTime
					Set $p(InputStr,"^",13)=1
					Set MRFpID=##class(DHCWMR.MRService.FrontPageSrv).Save(InputStr)
					If MRFpID<1 {
						Set ErrCode="-100"
						Set ErrText="主记录更新错误"
						Set Error="##class(DHCWMR.MRService.FrontPageSrv).Save("""_InputStr_""")"
						Set flg=##class(DHCWMR.MR.FPErrorLog).Save(ErrCode,ErrText,Error,"")
						Continue
					}
					
					Set Count=Count+1
					Set flg=..SaveRowData(MRFpID,xFpID)
				}
			}
		}
	}
	
	Quit Count
}

ClassMethod SaveRowData(aMRFPageID As %String, aFpID As %String) As %String
{
	new (aMRFPageID,aFpID)
	Set return=0
	Quit:(aMRFPageID="")||(aFpID="") return
	
	//初始化诊断记录
	Set flg=##class(DHCWMR.MRService.FrontPageSrv).InitICD(aMRFPageID)
	If flg<0 {
		Set ErrCode="-201"
		Set ErrText="初始化诊断记录错误"
		Set Error="##class(DHCWMR.MRService.FrontPageSrv).InitICD("""_aMRFPageID_""")"
		Set flg=##class(DHCWMR.MR.FPErrorLog).Save(ErrCode,ErrText,Error,aMRFPageID)
	}
	
	Set xIndex=0
	For {
		Set xIndex=$o(^DHCWMR.FP.FrontPageI("FPD","IndexFPDIndex",aFpID,xIndex))
		Quit:xIndex=""
		
		Set xSub=0
		For {
			Set xSub=$o(^DHCWMR.FP.FrontPageI("FPD","IndexFPDIndex",aFpID,xIndex,xSub))
			Quit:xSub=""
			
			Set objDiagnos=##class(DHCWMR.FP.FPDiagnos).GetObjById(aFpID_"||"_xSub)
			Continue:'$IsObject(objDiagnos)
			Continue:'$IsObject(objDiagnos.FPDType)
			Set TypeDesc=objDiagnos.FPDType.SDDesc
			
			//诊断ICD
			If $IsObject(objDiagnos.FPDICDDr) {
				Set ICD10=objDiagnos.FPDICDDr.IDICD10
				Set ICDDesc=objDiagnos.FPDICDDr.IDDesc
			}
			//入院病情
			If $IsObject(objDiagnos.FPDAdmitCond) {
				Set AdmitCondCode=objDiagnos.FPDAdmitCond.SDCode
				Set AdmitCondDesc=objDiagnos.FPDAdmitCond.SDDesc
			}
			//出院情况
			If $IsObject(objDiagnos.FPDDischCond) {
				Set DischCondCode=objDiagnos.FPDDischCond.SDCode
				Set DischCondDesc=objDiagnos.FPDDischCond.SDDesc
			}
			//是否确诊
			If $IsObject(objDiagnos.FPDIsDefinite) {
				Set IsDefiniteCode=objDiagnos.FPDIsDefinite.SDCode
				Set IsDefiniteDesc=objDiagnos.FPDIsDefinite.SDDesc
			}
			
			Set InputStr=""
			Set $p(InputStr,"^",1)=aMRFPageID
			Set $p(InputStr,"^",2)=""
			Set $p(InputStr,"^",3)=TypeDesc
			Set $p(InputStr,"^",4)=""
			Set $p(InputStr,"^",5)=""
			Set $p(InputStr,"^",6)=ICDDesc
			Set $p(InputStr,"^",7)=ICD10
			Set $p(InputStr,"^",8)=AdmitCondDesc
			Set $p(InputStr,"^",9)=AdmitCondCode
			Set $p(InputStr,"^",10)=DischCondDesc
			Set $p(InputStr,"^",11)=DischCondCode
			Set flg=##class(DHCWMR.MRService.FrontPageSrv).SaveICD(InputStr)
			If flg<0 {
				Set ErrCode="-200"
				Set ErrText="诊断记录更新错误"
				Set Error="##class(DHCWMR.MRService.FrontPageSrv).SaveICD("""_InputStr_""")"
				Set flg=##class(DHCWMR.MR.FPErrorLog).Save(ErrCode,ErrText,Error,aMRFPageID)
			}
		}
	}
	
	
	//初始化手术记录
	Set flg=##class(DHCWMR.MRService.FrontPageSrv).InitOper(aMRFPageID)
	If flg<0 {
		Set ErrCode="-301"
		Set ErrText="初始化手术记录错误"
		Set Error="##class(DHCWMR.MRService.FrontPageSrv).InitOper("""_aMRFPageID_""")"
		Set flg=##class(DHCWMR.MR.FPErrorLog).Save(ErrCode,ErrText,Error,aMRFPageID)
	}
	
	Set xIndex=0
	For {
		Set xIndex=$o(^DHCWMR.FP.FrontPageI("FPO","IndexFPOIndex",aFpID,xIndex))
		Quit:xIndex=""
		
		Set xSub=0
		For {
			Set xSub=$o(^DHCWMR.FP.FrontPageI("FPO","IndexTypeIndex",aFpID,xIndex,xSub))
			Quit:xSub=""
			
			Set objOperation=##class(DHCWMR.FP.FPOperation).GetObjById(aFpID_"||"_xSub)
			Continue:'$IsObject(objOperation)
			Continue:'$IsObject(objOperation.FPOType)
			Set TypeCode=objOperation.FPOType.SDCode
			Set TypeDesc=objOperation.FPOType.SDDesc
			
			If $IsObject(objOperation.FPOICDDr) {
				Set ICD10=objOperation.FPOICDDr.IDICD10	//手术ICD
				Set ICDDesc=objOperation.FPOICDDr.IDDesc  //手术名称
			}
			Set SttDate=objOperation.FPOSttDate  //手术日期
			Set SttTime=objOperation.FPOSttTime
			Set EndDate=objOperation.FPOEndDate
			Set EndTime=objOperation.FPOEndTime
			Set Operator=objOperation.FPOOperator  //术者
			Set OperatorTxt=objOperation.FPOOperatorTxt
			Set Assistant1=objOperation.FPOAssistant1  //1助
			Set Assistant1Txt=objOperation.FPOAssistant1Txt
			Set Assistant2=objOperation.FPOAssistant2  //2助
			Set Assistant2Txt=objOperation.FPOAssistant2Txt
			If $IsObject(objOperation.FPONarcosisType) {
				Set NarcosisTypeCode=objOperation.FPONarcosisType.SDCode	//麻醉方式
				Set NarcosisTypeDesc=objOperation.FPONarcosisType.SDDesc
			}
			Set NarcosisDoc=objOperation.FPONarcosisDoc  //麻醉医师
			Set NarcosisDocTxt=objOperation.FPONarcosisDocTxt
			If $IsObject(objOperation.FPOCutType) {
				Set CutTypeCode=objOperation.FPOCutType.SDCode	//切口类型
				Set CutTypeDesc=objOperation.FPOCutType.SDDesc
				
				If $IsObject(objOperation.FPOHealing) {
					Set HealingCode=objOperation.FPOHealing.SDCode	//愈合情况
					Set HealingDesc=objOperation.FPOHealing.SDDesc
					Set CutTypeCode=CutTypeCode_"/"_HealingCode
					Set CutTypeDesc=CutTypeDesc_"/"_HealingDesc
				} Else {
					Set CutTypeCode=CutTypeCode_"/"_"无"
					Set CutTypeDesc=CutTypeDesc_"/"_"无"
				}
			}
			If $IsObject(objOperation.FPOOperLevel) {
				Set OperLevelCode=objOperation.FPOOperLevel.SDCode	//手术级别
				Set OperLevelDesc=objOperation.FPOOperLevel.SDDesc
			}
			
			Set InputStr=""
			Set $p(InputStr,"^",1)=aMRFPageID
			Set $p(InputStr,"^",2)=""
			Set $p(InputStr,"^",3)=TypeDesc
			Set $p(InputStr,"^",4)=""
			Set $p(InputStr,"^",5)=""
			Set $p(InputStr,"^",6)=ICDDesc
			Set $p(InputStr,"^",7)=ICD10
			Set $p(InputStr,"^",8)=SttDate
			Set $p(InputStr,"^",9)=OperLevelDesc
			Set $p(InputStr,"^",10)=OperLevelCode
			Set $p(InputStr,"^",11)=OperatorTxt
			Set $p(InputStr,"^",12)=Assistant1Txt
			Set $p(InputStr,"^",13)=Assistant2Txt
			Set $p(InputStr,"^",14)=NarcosisTypeDesc
			Set $p(InputStr,"^",15)=NarcosisTypeCode
			Set $p(InputStr,"^",16)=CutTypeDesc
			Set $p(InputStr,"^",17)=CutTypeCode
			Set $p(InputStr,"^",18)=NarcosisDocTxt
			Set flg=##class(DHCWMR.MRService.FrontPageSrv).SaveOper(InputStr)
			If flg<0 {
				Set ErrCode="-300"
				Set ErrText="手术记录更新错误"
				Set Error="##class(DHCWMR.MRService.FrontPageSrv).SaveOper("""_InputStr_""")"
				Set flg=##class(DHCWMR.MR.FPErrorLog).Save(ErrCode,ErrText,Error,aMRFPageID)
			}
		}
	}
	
	Quit return
}

}
