/// 名称: DHCWMR.FPService.FPMappingSrv
/// 描述: 编目诊断对照相关服务
/// 编写者：liyi
/// 编写日期: 2015-12-21
Class DHCWMR.FPService.FPMappingSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     liyi
/// CreatDate：   2015-12-21
/// Description:  审核编目对照
/// Table：       DHCWMR.FP.FPMapping
/// Input：       aInput : 对照信息
/// 			  aSeparate ：分隔符
/// Return：      返回String
/// w ##class(DHCWMR.FPService.FPMappingSrv).SynCodingInfo(1,"F",9,2)
ClassMethod CheckMapping(aInput As %String, aSeparate As %String)
{
	New (aInput,aSeparate)
	Set return=0
	Quit:(aInput="")||(aSeparate="") return
	
	Set MappingID=$p(aInput,aSeparate,1)
	Set MRICD10=$p(aInput,aSeparate,2)
	Set MRICDDesc=$p(aInput,aSeparate,3)
	Set FPICD10=$p(aInput,aSeparate,4)
	Set FPICDDesc=$p(aInput,aSeparate,5)
	Set UserID=$p(aInput,aSeparate,6)
	Set IsActive=$p(aInput,aSeparate,7)
	Set Resume=$p(aInput,aSeparate,8)
	Set objMapping = ##Class(DHCWMR.FP.FPMapping).GetObjById(MappingID)
	Quit:'$IsObject(objMapping) return
	
	Set InputStr=""
	Set $p(InputStr,"^",1)=MappingID
	Set $p(InputStr,"^",2)=objMapping.FPMFPType
	Set $p(InputStr,"^",3)=objMapping.FPMFPMark
	Set $p(InputStr,"^",4)=MRICD10
	Set $p(InputStr,"^",5)=MRICDDesc
	Set $p(InputStr,"^",6)=FPICD10
	Set $p(InputStr,"^",7)=FPICDDesc
	Set $p(InputStr,"^",8)=objMapping.FPMBuildDate
	Set $p(InputStr,"^",9)=objMapping.FPMBuildTime
	Set $p(InputStr,"^",10)=objMapping.FPMBuildUser
	Set $p(InputStr,"^",11)=+$H
	Set $p(InputStr,"^",12)=+$P($h,",",2)
	Set $p(InputStr,"^",13)=UserID
	Set $p(InputStr,"^",14)=IsActive
	Set $p(InputStr,"^",15)=Resume
	Set ret= ##class(DHCWMR.FP.FPMapping).Update(InputStr,"^")
	Set return = ret
	
	Quit return
}

/// Creator：     liyi
/// CreatDate：   2015-12-21
/// Description:  通过编目主记录ID同步编目诊断对照表
/// Table：       DHCWMR.FP.FPMapping
/// Input：       FrontPageID : 编目主记录ID
/// 				  aFPType ：编目类型
///               aUserID : 编码员
/// 				  aHospID : 医院ID
/// Return：      返回String
/// w ##class(DHCWMR.FPService.FPMappingSrv).SynCodingInfo(1,"F",9,2)
ClassMethod SynCodingInfo(aFrontPageID As %String, aFPType As %String, aUserID As %String, aHospID As %String) As %String
{
	New (aFrontPageID,aFPType,aUserID,aHospID)
	Set return = 0
	Quit:aFrontPageID="" return
	Quit:'$d(^DHCWMR.FP.FrontPageD(aFrontPageID)) return
	
	Set IsCheckFPMapping = ##class(DHCWMR.SSService.ConfigSrv).GetValueByKeyHosp("IsCheckFPMapping",aHospID)	//编目对照是否需要审核
	Quit:+IsCheckFPMapping=0 1
	
	//诊断
	IF $d(^DHCWMR.FP.FrontPageD(aFrontPageID,"D")){
		Set xDiagSubID=""
		For {
			Set xDiagSubID=$o(^DHCWMR.FP.FrontPageD(aFrontPageID,"D",xDiagSubID))
			Quit:xDiagSubID=""
			
			Set DiagnoseID = aFrontPageID_"||"_xDiagSubID
			Set objDiagnose=##class(DHCWMR.FP.FPDiagnos).GetObjById(DiagnoseID)
			Continue:'$IsObject(objDiagnose)
			
			Set MRDataSource = objDiagnose.FPDDataSource
			Continue:MRDataSource=""
			
			Set MRICD10 = $p(MRDataSource,"#",3)
			Set MRICDDesc = $p(MRDataSource,"#",4)
			Continue:MRICDDesc=""
			
			Set objICD = objDiagnose.FPDICDDr
			Continue:'$IsObject(objICD)
			
			Set FPICD10 =objICD.IDICD10
			Set FPICDDesc =objICD.IDDesc
			Continue:(FPICD10=MRICD10)&&(FPICDDesc=MRICDDesc)	//编码，名称完全相同无需对照
			
			Set MappingID = $o(^DHCWMR.FP.FPMappingI("IndexMarkMRICDDesc"," "_"D"," "_$zcvt(MRICDDesc,"U"),""))			
			If MappingID'=""
			{
				Set objMapping = ##class(DHCWMR.FP.FPMapping).GetObjById(MappingID)
				Continue:'$IsObject(objMapping)
				Continue:objMapping.FPMFPICD10=FPICD10
				Continue:objMapping.FPMFPICDDesc=FPICDDesc		//已有对照如果编目结果一致无需对照
			}
			Set InputStr=""
			Set $p(InputStr,"^",1)=MappingID
			Set $p(InputStr,"^",2)=aFPType
			Set $p(InputStr,"^",3)="D"
			Set $p(InputStr,"^",4)=MRICD10
			Set $p(InputStr,"^",5)=MRICDDesc
			Set $p(InputStr,"^",6)=FPICD10
			Set $p(InputStr,"^",7)=FPICDDesc
			Set $p(InputStr,"^",8)=+$h
			Set $p(InputStr,"^",9)=+($p($h,",",2))
			Set $p(InputStr,"^",10)=aUserID
			Set $p(InputStr,"^",11)=""
			Set $p(InputStr,"^",12)=""
			Set $p(InputStr,"^",13)=""
			Set $p(InputStr,"^",14)=$s(IsCheckFPMapping=1:1,1:0)
			Set $p(InputStr,"^",15)=""
			Do ##class(DHCWMR.FP.FPMapping).Update(InputStr,"^")
		}
	}
	//手术
	IF $d(^DHCWMR.FP.FrontPageD(aFrontPageID,"O")){
		Set xOperSubID=""
		For {
			Set xOperSubID=$o(^DHCWMR.FP.FrontPageD(aFrontPageID,"O",xOperSubID))
			Quit:xOperSubID=""
			
			Set OperID = aFrontPageID_"||"_xOperSubID
			Set objOper=##class(DHCWMR.FP.FPOperation).GetObjById(OperID)
			Continue:'$IsObject(objOper)
			
			Set MRDataSource = objOper.FPODataSource
			Continue:MRDataSource=""
			
			Set MRICD10 = $p(MRDataSource,"#",3)
			Set MRICDDesc = $p(MRDataSource,"#",4)
			Continue:MRICDDesc=""

			Set objICD = objOper.FPOICDDr
			Continue:'$IsObject(objICD)
			
			Set FPICD10 =objICD.IDICD10
			Set FPICDDesc =objICD.IDDesc
			Continue:(FPICD10=MRICD10)&&(FPICDDesc=MRICDDesc)	//编码，名称完全相同无需对照
			
			Set MappingID = $o(^DHCWMR.FP.FPMappingI("IndexMarkMRICDDesc"," "_"O"," "_$zcvt(MRICDDesc,"U"),""))
			If MappingID'=""
			{
				Set objMapping = ##class(DHCWMR.FP.FPMapping).GetObjById(MappingID)
				Continue:'$IsObject(objMapping)
				Continue:objMapping.FPMFPICD10=FPICD10
				Continue:objMapping.FPMFPICDDesc=FPICDDesc 		//已有对照如果编目结果一致无需对照
			}
			Set InputStr=""
			Set $p(InputStr,"^",1)=MappingID
			Set $p(InputStr,"^",2)=aFPType
			Set $p(InputStr,"^",3)="O"
			Set $p(InputStr,"^",4)=MRICD10
			Set $p(InputStr,"^",5)=MRICDDesc
			Set $p(InputStr,"^",6)=FPICD10
			Set $p(InputStr,"^",7)=FPICDDesc
			Set $p(InputStr,"^",8)=+$h
			Set $p(InputStr,"^",9)=+($p($h,",",2))
			Set $p(InputStr,"^",10)=aUserID
			Set $p(InputStr,"^",11)=""
			Set $p(InputStr,"^",12)=""
			Set $p(InputStr,"^",13)=""
			Set $p(InputStr,"^",14)=$s(IsCheckFPMapping=1:1,1:0)
			Set $p(InputStr,"^",15)=""
			Do ##class(DHCWMR.FP.FPMapping).Update(InputStr,"^")
		}
	}
	Quit 1
}

/// Creator：     liyi
/// CreatDate：   2015-12-21
/// Description:  通过首页诊断/手术描述 取对照诊断/手术，ICD/描述
/// Table：       DHCWMR.FP.FPMapping
/// Input：       aEpisodeID : 就诊ID
/// 				  aMark ：诊断/手术标记
/// 				  aICDVerID：诊断/手术库版本ID
///               aICD10 : 首页诊断/手术 ICD
/// 				  aICDDesc : 首页诊断/手术 描述
/// Return：      $lb(对照后ICD,对照后描述)
/// w ##class(DHCWMR.FPService.FPMappingSrv).GetMapString(216,"D","E10.901","1型糖尿病1")
ClassMethod GetMapString(aEpisodeID As %String, aMark As %String, aICDVerID As %String, aICD10 As %String, aICDDesc As %String) As DHCWMR.FP.ICDDx
{
	New (aEpisodeID,aMark,aICDVerID,aICD10,aICDDesc)
	Set return=""
	Quit:(aEpisodeID="")||(aMark="")||(aICDVerID="") return
	Quit:(aICD10="")&&(aICDDesc="") return
	
	Set AdmLoc = +$P($g(^PAADM(aEpisodeID)),"^",4)
	Set AdmHospID = ##class(DHCWMR.SSService.HospitalSrv).GetCTHospID(AdmLoc)
	Set IsCheckFPMapping = ##class(DHCWMR.SSService.ConfigSrv).GetValueByKeyHosp("IsCheckFPMapping",AdmHospID)	//编目对照是否需要审核
	Quit:+IsCheckFPMapping=0 return
	
	Set MappingID = ""
	For {
		Set MappingID = $o(^DHCWMR.FP.FPMappingI("IndexMarkMRICDDesc"," "_aMark," "_$zcvt(aICDDesc,"U"),MappingID))
		Quit:MappingID=""
		
		Set objMapping = ##class(DHCWMR.FP.FPMapping).GetObjById(MappingID)
		Quit:'$IsObject(objMapping)
		Continue:objMapping.FPMIsActive=0
		
		Set FPICD10 = objMapping.FPMFPICD10
		Set FPICDDesc = objMapping.FPMFPICDDesc
		Continue:FPICD10=""
		
		Set objICD=##class(DHCWMR.FP.ICDDx).GetObjByICD10(aICDVerID,FPICD10)
		Continue:'$IsObject(objICD)
		
		Set return = objICD
	}
	Quit return
}

/// Creator：     liyi
/// CreatDate：   2015-12-21
/// Description:  诊断对照查询
/// Table：       DHCWMR.FP.FPMapping
/// Input：       aMark ：诊断/手术标记(D)
///               aDateFrom ：对照开始时间
/// 				  aDateTo：对照结束时间
///               aBuildUser ：对照用户
///               aAlias ：对照前关键字
/// do ##class(%Library.ResultSet).RunQuery("DHCWMR.FPService.FPMappingSrv","QueryMapping","D","2015-12-22","2015-12-28","","糖3")
Query QueryMapping(aMark As %String, aDateFrom As %String, aDateTo As %String, aBuildUser As %String, aAlias As %String, aIsActive As %String = "") As %Query(ROWSPEC = "ID:%String,FPType:%String,Mark:%String,MarkDesc:%String,MRICD10:%String,MRICDDesc:%String,FPICD10:%String,FPICDDesc:%String,BuildDate:%String,BuildTime:%String,BuildUser:%String,CheckDate:%String,CheckTime:%String,CheckUser:%String,IsActive:%String,Resume:%String")
{
}

ClassMethod QueryMappingExecute(ByRef qHandle As %Binary, aMark As %String, aDateFrom As %String, aDateTo As %String, aBuildUser As %String, aAlias As %String, aIsActive As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	Quit:(aMark="") $$$OK
	
	Set:aDateFrom["/" aDateFrom=$zdh(aDateFrom,4)
	Set:aDateFrom["-" aDateFrom=$zdh(aDateFrom,3)
	Set:aDateFrom'="" aDateFrom=+aDateFrom
	Set:aDateTo["/" aDateTo=$zdh(aDateTo,4)
	Set:aDateTo["-" aDateTo=$zdh(aDateTo,3)
	Set:aDateTo'="" aDateTo=+aDateTo
	For xDate = aDateFrom:1:aDateTo
	{
		Set xMappingID=""
		For {
			Set xMappingID=$o(^DHCWMR.FP.FPMappingI("IndexMarkBuildDate"," "_aMark,xDate,xMappingID))
			Quit:xMappingID=""
			
			Set objMapping = ##class(DHCWMR.FP.FPMapping).GetObjById(xMappingID)
			Continue:'$IsObject(objMapping)
			
			
			Set BuildUser=objMapping.FPMBuildUser
			Set BuildUser=$p($g(^SSU("SSUSR",+BuildUser)),"^",2)
			Continue:(aBuildUser'="")&&(BuildUser'="")&&(BuildUser'=aBuildUser)
			
			Set MRICD10=objMapping.FPMMRICD10
			Set MRICDDesc=objMapping.FPMMRICDDesc
			Continue:(aAlias'="")&&((MRICD10'[aAlias)&&(MRICDDesc'[aAlias))
			
			Set FPType = objMapping.FPMFPType
			Set MarkDesc = $s(aMark="D":"诊断",aMark="O":"手术")
			Set FPICD10=objMapping.FPMFPICD10
			Set FPICDDesc=objMapping.FPMFPICDDesc
			Set BuildDate=objMapping.FPMBuildDate
			;Set:BuildDate'="" BuildDate=$zd(BuildDate,3)
			Set:BuildDate'="" BuildDate=##Class(DHCWMR.SSService.CommonSrv).DateLogicalToHtml(BuildDate)
			Set BuildTime=objMapping.FPMBuildTime
			Set:BuildTime'="" BuildTime=$zt(BuildTime)
			Set CheckDate=objMapping.FPMCheckDate
			;Set:CheckDate'="" CheckDate=$zd(CheckDate,3)
			Set:CheckDate'="" CheckDate=##Class(DHCWMR.SSService.CommonSrv).DateLogicalToHtml(CheckDate)
			Set CheckTime=objMapping.FPMCheckTime
			Set:CheckTime'="" CheckTime=$zt(CheckTime)
			Set CheckUser=objMapping.FPMCheckUser
			Set CheckUser=$p($g(^SSU("SSUSR",+CheckUser)),"^",2)
			Set IsActive=objMapping.FPMIsActive
			Continue:(aIsActive'="")&&(aIsActive'=IsActive)
			
			Set IsActive = $s(IsActive=1:"是",IsActive=0:"否")
			Set Resume=objMapping.FPMResume
			Set Data=$lb(xMappingID,FPType,aMark,MarkDesc,MRICD10,MRICDDesc,FPICD10,FPICDDesc,BuildDate,BuildTime,BuildUser,CheckDate,CheckTime,CheckUser,IsActive,Resume)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
	}
	
	Quit $$$OK
}

ClassMethod QueryMappingClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryMappingExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QueryMappingFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryMappingExecute ]
{
	set AtEnd=$LIST(qHandle,1)
 	set repid=$LIST(qHandle,2)
 	set ind=$LIST(qHandle,3)
 	set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		set AtEnd=1
 		set Row=""
 	}
 	Else      {				// fetch row
 		set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

}
