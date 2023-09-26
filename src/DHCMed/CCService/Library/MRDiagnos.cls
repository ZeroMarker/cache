/// 名称: DHCMed.CCService.Library.MRDiagnos
/// 描述: 与诊断相关的函数库
/// 编写者：zhufei
/// 编写日期: 2014-04-13
Class DHCMed.CCService.Library.MRDiagnos Extends DHCMed.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// w ##Class(DHCMed.CCService.Library.MRDiagnos).Test()
ClassMethod Test()
{
	New
	Set %FromDate=""
	Set %ToDate=""
	
	Set %EpisodeID=3996218
	Set %ExtraData=""
	Set %ErrorData=""
	Set return=..CheckDiagnos("","糖尿病")
	Write "%ExtraData="_##Class(DHCMed.CCService.Lib.Common).GetListToString(%ExtraData,"///"),!
	Write "%ErrorData="_##Class(DHCMed.CCService.Lib.Common).GetListToString(%ErrorData,"///"),!
	Write "return="_return,!
	
	Set %EpisodeID=3957473
	Set %ExtraData=""
	Set %ErrorData=""
	Set return=..CheckDiagnosToEPD()
	Write "%ExtraData="_##Class(DHCMed.CCService.Lib.Common).GetListToString(%ExtraData,"///"),!
	Write "%ErrorData="_##Class(DHCMed.CCService.Lib.Common).GetListToString(%ErrorData,"///"),!
	Write "return="_return,!
	
	Set %EpisodeID=3957473
	Set %ExtraData=""
	Set %ErrorData=""
	Set return=..CheckDiagnosToCD()
	Write "%ExtraData="_##Class(DHCMed.CCService.Lib.Common).GetListToString(%ExtraData,"///"),!
	Write "%ErrorData="_##Class(DHCMed.CCService.Lib.Common).GetListToString(%ErrorData,"///"),!
	Write "return="_return,!
	
	Quit "Over"
}

/// Creator：     zhufei
/// CreatDate：   2014-04-13
/// Description:  根据关键词筛查诊断
/// Table：       MR_Diagnos
/// Input：       aICD10 诊断ICD编码；aKeyWord 关键词
/// Return：      返回诊断数量  ret=-1:Error
/// w ##class(DHCMed.CCService.Library.MRDiagnos).CheckDiagnos("","破伤风")
ClassMethod CheckDiagnos(aICD10 As %String, aKeyWord As %String = "") As %String
{
	New (aICD10,aKeyWord,%EpisodeID,%FromDate,%ToDate,%ExtraData,%ErrorData)
	Set return=0,Count=0
	Quit:(aICD10="")&&(aKeyWord="") return
	
	Set %EpisodeID=$g(%EpisodeID)
	Quit:%EpisodeID="" return
	Set %FromDate=$g(%FromDate)
	Set %ToDate=$g(%ToDate)
	Set %ExtraData=$g(%ExtraData)
	Set %ErrorData=$g(%ErrorData)
	
	Set $ZT="CheckDiagnosErr"
	
	Set aICD10=$zcvt(aICD10,"U"),aICD10=$tr(aICD10," ","")
	Set aKeyWord=$zcvt(aKeyWord,"U"),aKeyWord=$tr(aKeyWord," ","")
	
	Set arrRec=##Class(DHCMed.DPCustom.Data.MRDiagnos).GetDataByAdm(%EpisodeID,%FromDate,%ToDate)
	Set Num=arrRec.Count()
	For indRec=1:1:Num {
		Set objRec=arrRec.GetAt(indRec)
		Continue:'$IsObject(objRec)
		
		Set ICD10=objRec.ICD10
		Set ICD10=$zcvt(ICD10,"U"),ICD10=$tr(ICD10," ","")
		Continue:(aICD10'="")&&(ICD10'[aICD10)
		Set ICDDesc=objRec.ICDDesc
		Set Comments=objRec.Comments
		Set:Comments'="" ICDDesc=ICDDesc_";"_Comments
		Set ICDDesc=$zcvt(ICDDesc,"U"),ICDDesc=$tr(ICDDesc," ","")
		Continue:(aKeyWord'="")&&(ICDDesc'[aKeyWord)
		
		Set ActDate=objRec.ActDate
		Set ActTime=objRec.ActTime
		Continue:(ActDate="")||(ActTime="")
		
		Set Count=Count+1
		
		Set Summary=objRec.ICDDesc
		Set:objRec.ICD10'="" Summary="【"_objRec.ICD10_"】"_Summary
		Set:objRec.Comments'="" Summary=Summary_";"_objRec.Comments
		
		Set DataValue=aKeyWord
		Set:aICD10'="" DataValue="【"_aICD10_"】"_DataValue
		
		Set TempData=""
		Set $p(TempData,$c(3),1)=Summary
		Set $p(TempData,$c(3),2)=objRec.ActDate
		Set $p(TempData,$c(3),3)=objRec.ActTime
		Set $p(TempData,$c(3),4)=DataValue
		Set $p(TempData,$c(3),5)=objRec.RecordID
		Set $p(TempData,$c(3),6)=objRec.ActUser
		Set $p(TempData,$c(3),7)="aICD10="_aICD10_"&aKeyWord="_aKeyWord
		Set $p(TempData,$c(3),8)=objRec.ActDate
		Set $p(TempData,$c(3),9)=objRec.ActTime
		Set $p(TempData,$c(3),10)="MRICD"
		Set $p(TempData,$c(3),11)=""
		Set $p(TempData,$c(3),12)=""
		Set $p(TempData,$c(3),13)=""
		Set $p(TempData,$c(3),14)=""
		Set %ExtraData=%ExtraData_$lb(TempData)
	}
	
	Set return=Count
	Quit return
	
CheckDiagnosErr
	Set Error=$ZERROR
	Set %ErrorData=%ErrorData_$lb(Error)
	Quit -1
}

/// Creator：     zhufei
/// CreatDate：   2014-04-13
/// Description:  筛查传染病诊断
/// Table：       MR_Diagnos
/// Input：       
/// Return：      返回诊断数量  ret=-1:Error
/// w ##class(DHCMed.CCService.Library.MRDiagnos).CheckDiagnosToEPD()
ClassMethod CheckDiagnosToEPD(aEpdAlias As %String = "") As %String
{
	New (aEpdAlias,%EpisodeID,%FromDate,%ToDate,%ExtraData,%ErrorData)
	Set return=0,Count=0
	
	Set %EpisodeID=$g(%EpisodeID)
	Quit:%EpisodeID="" return
	Set %FromDate=$g(%FromDate)
	Set %ToDate=$g(%ToDate)
	Set %ExtraData=$g(%ExtraData)
	Set %ErrorData=$g(%ErrorData)
	
	Set $ZT="CheckDiagnosToEPDErr"
	
	Set AFPAgeMax=##class(DHCMed.SSService.ConfigSrv).GetValueByKeyHosp("EpidemicAFPAgeMax","")
	Set PatientID=$p($g(^PAADM(%EpisodeID)),"^",1)
	set PatAge=##class(DHCMed.SSIO.FromHisSrv).GetPapmiAge(PatientID,%EpisodeID,"","")
	
	Set arrRec=##Class(DHCMed.DPCustom.Data.MRDiagnos).GetDataByAdm(%EpisodeID,%FromDate,%ToDate)
	Set Num=arrRec.Count()
	For indRec=1:1:Num {
		Set objRec=arrRec.GetAt(indRec)
		Continue:'$IsObject(objRec)
		
		Set ActDate=objRec.ActDate
		Set ActTime=objRec.ActTime
		Continue:(ActDate="")||(ActTime="")
		
		Set ICD10=objRec.ICD10
		Set ICDDesc=objRec.ICDDesc
		Set Comments=objRec.Comments
		
		Set flg=..CheckIsEPD(ICD10,ICDDesc,Comments)
		Continue:flg=""
		Set EPDDiagnos=flg
		
		Set EpdICDs=""
		For indEpd=1:1:$l(EPDDiagnos,",") {
			Set xEpdICD=$p(EPDDiagnos,",",indEpd)
			Continue:xEpdICD=""
			Set tmpEpdICD=$p($g(^DHCMed.EPDC("IF",+xEpdICD)),"^",2)
			Continue:tmpEpdICD=""
			Continue:(aEpdAlias'="")&&(tmpEpdICD'=aEpdAlias)
			
			Set IFRank=$p($g(^DHCMed.EPDC("IF",+xEpdICD)),"^",4)
			Set objIFRank=##Class(DHCMed.SS.Dictionary).GetByTypeCode("EPIDEMICRANK",+IFRank,"")
			Continue:'$IsObject(objIFRank)
			Set IFRankDesc=objIFRank.Description
			Continue:(IFRankDesc["AFP")&&((+PatAge)>(+AFPAgeMax)) //AFP年龄限制			
			Set:IFRankDesc["AFP" tmpEpdICD="(AFP)"_tmpEpdICD
			
			Set EpdICDs=EpdICDs_"、"_tmpEpdICD
		}
		Set:EpdICDs'="" EpdICDs=$e(EpdICDs,2,$l(EpdICDs))
		Continue:EpdICDs=""
		
		Set Summary=objRec.ICDDesc
		Set:objRec.ICD10'="" Summary="【"_objRec.ICD10_"】"_Summary
		Set:objRec.Comments'="" Summary=Summary_";"_objRec.Comments
		Set Summary=EpdICDs_" "_Summary
		
		Set Count=Count+1
		
		//modify by mxp 20160511 直接输入诊断注释 录入非标准诊断时取诊断备注
		Set EPDDiagnos=ICDDesc
		Set:(Comments'="")&&(EPDDiagnos'="") EPDDiagnos=EPDDiagnos_"("_Comments_")"
		Set:(Comments'="")&&(EPDDiagnos="") EPDDiagnos=EPDDiagnos_Comments
		
		Set TempData=""
		Set $p(TempData,$c(3),1)=Summary
		Set $p(TempData,$c(3),2)=objRec.ActDate
		Set $p(TempData,$c(3),3)=objRec.ActTime
		Set $p(TempData,$c(3),4)=EPDDiagnos		//EPDDiagnos 传染病监控页面显示诊断 2015-03-16
		Set $p(TempData,$c(3),5)=objRec.RecordID
		Set $p(TempData,$c(3),6)=objRec.ActUser
		Set $p(TempData,$c(3),7)=""
		Set $p(TempData,$c(3),8)=objRec.ActDate
		Set $p(TempData,$c(3),9)=objRec.ActTime
		Set $p(TempData,$c(3),10)="MRICD"
		Set $p(TempData,$c(3),11)=""
		Set $p(TempData,$c(3),12)=""
		Set $p(TempData,$c(3),13)=""
		Set $p(TempData,$c(3),14)=""
		Set %ExtraData=%ExtraData_$lb(TempData)
	}
	
	Set return=Count
	Quit return
	
CheckDiagnosToEPDErr
	Set Error=$ZERROR
	Set %ErrorData=%ErrorData_$lb(Error)
	Quit -1
}

/// Creator：     zhufei
/// CreatDate：   2014-04-13
/// Description:  筛查慢病诊断
/// Table：       MR_Diagnos
/// Input：       
/// Return：      返回诊断数量  ret=-1:Error
/// w ##class(DHCMed.CCService.Library.MRDiagnos).CheckDiagnosToCD()
ClassMethod CheckDiagnosToCD(aCDAlias As %String = "") As %String
{
	New (aCDAlias,%EpisodeID,%FromDate,%ToDate,%ExtraData,%ErrorData)
	Set return=0,Count=0
	
	Set %EpisodeID=$g(%EpisodeID)
	Quit:%EpisodeID="" return
	Set %FromDate=$g(%FromDate)
	Set %ToDate=$g(%ToDate)
	Set %ExtraData=$g(%ExtraData)
	Set %ErrorData=$g(%ErrorData)
	
	Set $ZT="CheckDiagnosToCDErr"
	
	Set arrRec=##Class(DHCMed.DPCustom.Data.MRDiagnos).GetDataByAdm(%EpisodeID,%FromDate,%ToDate)
	Set Num=arrRec.Count()
	For indRec=1:1:Num {
		Set objRec=arrRec.GetAt(indRec)
		Continue:'$IsObject(objRec)
		
		Set ActDate=objRec.ActDate
		Set ActTime=objRec.ActTime
		Continue:(ActDate="")||(ActTime="")
		
		Set ICD10=objRec.ICD10
		Set ICDDesc=objRec.ICDDesc
		Set Comments=objRec.Comments
		
		Set flg=..CheckIsCD(ICD10,ICDDesc,Comments)
		Continue:flg=""
		Set CDDiagnos=flg
		
		Set CDICDs=""
		For indCD=1:1:$l(CDDiagnos,",") {
			Set xCDICD=$p(CDDiagnos,",",indCD)
			Continue:xCDICD=""
			Set tmpFormICD=$g(^DHCMed.CD.CRFormD(+xCDICD,"ICD",+$p(xCDICD,"||",2)))
			Continue:tmpFormICD=""
			Set tmpCDICD=$list(tmpFormICD,6)
			Continue:tmpCDICD=""
			Continue:(aCDAlias'="")&&(tmpCDICD'=aCDAlias)
			Set CDICDs=CDICDs_"、"_tmpCDICD
		}
		Set:CDICDs'="" CDICDs=$e(CDICDs,2,$l(CDICDs))
		Continue:CDICDs=""
		
		Set Summary=objRec.ICDDesc
		Set:objRec.ICD10'="" Summary="【"_objRec.ICD10_"】"_Summary
		Set:objRec.Comments'="" Summary=Summary_";"_objRec.Comments
		Set Summary=CDICDs_" "_Summary
		
		Set Count=Count+1
		
		Set TempData=""
		Set $p(TempData,$c(3),1)=Summary
		Set $p(TempData,$c(3),2)=objRec.ActDate
		Set $p(TempData,$c(3),3)=objRec.ActTime
		Set $p(TempData,$c(3),4)=CDDiagnos
		Set $p(TempData,$c(3),5)=objRec.RecordID
		Set $p(TempData,$c(3),6)=objRec.ActUser
		Set $p(TempData,$c(3),7)=""
		Set $p(TempData,$c(3),8)=objRec.ActDate
		Set $p(TempData,$c(3),9)=objRec.ActTime
		Set $p(TempData,$c(3),10)="MRICD"
		Set $p(TempData,$c(3),11)=""
		Set $p(TempData,$c(3),12)=""
		Set $p(TempData,$c(3),13)=""
		Set $p(TempData,$c(3),14)=""
		Set %ExtraData=%ExtraData_$lb(TempData)
	}
	
	Set return=Count
	Quit return
	
CheckDiagnosToCDErr
	Set Error=$ZERROR
	Set %ErrorData=%ErrorData_$lb(Error)
	Quit -1
}

/// 判断是否传染病诊断
ClassMethod CheckIsEPD(aICD10 As %String, aICDDesc As %String, aComments As %String) As %String
{
	New (aICD10,aICDDesc,aComments)
	Set return=""
	Quit:(aICD10="")&&(aICDDesc="")&&(aComments="") return
	
	Set aICD10=$zcvt(aICD10,"U"),aICD10=$tr(aICD10," ","")
	Set tmpICDDesc=aICDDesc
	Set:aComments'="" tmpICDDesc=tmpICDDesc_";"_aComments
	Set tmpICDDesc=$zcvt(tmpICDDesc,"U")
	Set tmpICDDesc=$tr(tmpICDDesc," ","")
	
	Set CtlEpdRstList="",CtlEpdICDList=""
	Set xID=0
	For {
		Set xID=$o(^DHCMed.EPDC("IF",xID))
		Quit:xID=""
		
		//add by pylian 20160317 是否有效数据
		Set IsActive=$p($g(^DHCMed.EPDC("IF",xID)),"^",12)
		Continue:IsActive'="Y"
		
		If aICD10'="" {
			//通过传染病诊断ICD判断
			Set IFICD=$p($g(^DHCMed.EPDC("IF",xID)),"^",1)
			Set IFICD=$zcvt(IFICD,"U"),IFICD=$tr(IFICD," ","")
			If aICD10=IFICD {
				Set CtlEpdRstList=CtlEpdRstList_$lb(xID)
				Set CtlEpdICDList=CtlEpdICDList_$lb(xID_"||"_xAlias)
			}
			Continue:$listfind(CtlEpdRstList,xID)>0
			
			//通过传染病诊断ICD列表检索(别名表,类型为2)
			Set xAlias=0
			For {
				Set xAlias=$o(^DHCMed.EPDC("IF",xID,"InfAlias",xAlias))
				Quit:xAlias=""
				Quit:$listfind(CtlEpdRstList,xID)>0
				
				Set AliasType=+$p($g(^DHCMed.EPDC("IF",xID,"InfAlias",xAlias)),"^",2)
				Continue:AliasType'=2
				Set IFICD=$p($g(^DHCMed.EPDC("IF",xID,"InfAlias",xAlias)),"^",1)
				Set IFICD=$zcvt(IFICD,"U"),IFICD=$tr(IFICD," ","")
				If aICD10=IFICD {
					Set CtlEpdRstList=CtlEpdRstList_$lb(xID)
					Set CtlEpdICDList=CtlEpdICDList_$lb(xID_"||"_xAlias)
				}
			}
			Continue:$listfind(CtlEpdRstList,xID)>0
		}
		
		If tmpICDDesc'="" {
			//通过传染病诊断关键字列表检索(别名表,类型为1)
			Set xAlias=0,flg=0
			For {
				Set xAlias=$o(^DHCMed.EPDC("IF",xID,"InfAlias",xAlias))
				Quit:xAlias=""
				Quit:$listfind(CtlEpdRstList,xID)>0
				
				Set AliasType=+$p($g(^DHCMed.EPDC("IF",xID,"InfAlias",xAlias)),"^",2)
				Continue:AliasType'=1
				Set IFKey1=$p($g(^DHCMed.EPDC("IF",xID,"InfAlias",xAlias)),"^",1)
				Set IFKey1=$zcvt(IFKey1,"U"),IFKey1=$tr(IFKey1," ","")
				Continue:IFKey1=""
				If tmpICDDesc[IFKey1 {
					Set yAlias=0,flg=0
					For {
						Set yAlias=$o(^DHCMed.EPDC("IF",xID,"InfAlias",yAlias))
						Quit:yAlias=""
						Set AliasType=+$p($g(^DHCMed.EPDC("IF",xID,"InfAlias",yAlias)),"^",2)
						Continue:AliasType'=3
						Set IFKey0=$p($g(^DHCMed.EPDC("IF",xID,"InfAlias",yAlias)),"^",1)
						Set IFKey0=$zcvt(IFKey0,"U"),IFKey0=$tr(IFKey0," ","")
						Continue:IFKey0=""
						Set:tmpICDDesc[IFKey0 flg=1
					}
					Continue:flg=1
					Set CtlEpdRstList=CtlEpdRstList_$lb(xID)
					Set CtlEpdICDList=CtlEpdICDList_$lb(xID_"||"_xAlias)
				}
			}
			Continue:$listfind(CtlEpdRstList,xID)>0
		}
	}
	
	For indICD=1:1:$listlength(CtlEpdICDList) {
		Set EpdICDId=$list(CtlEpdICDList,indICD)
		Continue:EpdICDId=""
		Set return=return_","_EpdICDId
	}
	Set:return'="" return=$e(return,2,$l(return))
	
	Quit return
}

/// 判断是否慢病诊断
ClassMethod CheckIsCD(aICD10 As %String, aICDDesc As %String, aComments As %String) As %String
{
	New (aICD10,aICDDesc,aComments)
	Set return=""
	Quit:(aICD10="")&&(aICDDesc="")&&(aComments="") return
	
	Set aICD10=$zcvt(aICD10,"U"),aICD10=$tr(aICD10," ","")
	Set tmpICDDesc=aICDDesc
	Set:aComments'="" tmpICDDesc=tmpICDDesc_";"_aComments
	Set tmpICDDesc=$zcvt(tmpICDDesc,"U")
	Set tmpICDDesc=$tr(tmpICDDesc," ","")
	
	Set CtlCDRstList="",CtlCDICDList=""
	Set xID=0
	For {
		Set xID=$o(^DHCMed.CD.CRFormD(xID))
		Quit:xID=""
		
		Set xICD=0
		For {
			Set xICD=$o(^DHCMed.CD.CRFormD(xID,"ICD",xICD))
			Quit:xICD=""
			Quit:$listfind(CtlCDRstList,xID)>0
			
			Set tmpICD=$g(^DHCMed.CD.CRFormD(xID,"ICD",xICD))
			//通过诊断ICD判断慢病诊断
			If aICD10'="" {
				Set CDICD=$list(tmpICD,2)
				Set CDICD=$zcvt(CDICD,"U"),CDICD=$tr(CDICD," ","")
				If aICD10=CDICD {
					Set CtlCDRstList=CtlCDRstList_$lb(xID)
					Set CtlCDICDList=CtlCDICDList_$lb(xID_"||"_xICD)
				}
			}
			//通过诊断关键字判断慢病诊断
			If tmpICDDesc'="" {
				Set CDKey1=$list(tmpICD,3)
				Set CDKey1=$zcvt(CDKey1,"U"),CDKey1=$tr(CDKey1," ","")
				Set CDKey0=$list(tmpICD,4)
				Set CDKey0=$zcvt(CDKey0,"U"),CDKey0=$tr(CDKey0," ","")
				If (CDKey1'="")&&(tmpICDDesc[CDKey1) {
					If (CDKey0'="") {
						If (tmpICDDesc'[CDKey0) {
							Set CtlCDRstList=CtlCDRstList_$lb(xID)
							Set CtlCDICDList=CtlCDICDList_$lb(xID_"||"_xICD)
						}
					} Else {
						Set CtlCDRstList=CtlCDRstList_$lb(xID)
						Set CtlCDICDList=CtlCDICDList_$lb(xID_"||"_xICD)
					}
				}
			}
			
		}
	}
	
	For indICD=1:1:$listlength(CtlCDICDList) {
		Set CDICDId=$list(CtlCDICDList,indICD)
		Continue:CDICDId=""
		Set return=return_","_CDICDId
	}
	Set:return'="" return=$e(return,2,$l(return))
	
	Quit return
}

}
