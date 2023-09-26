/// 名称: DHCMed.NINFService.Rep.InfReport
/// 描述: 医院感染报告
/// 编写者：zhufei
/// 编写日期: 2012-06-20
Class DHCMed.NINFService.Rep.InfReport Extends DHCMed.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhufei
/// CreatDate：   2012-06-21
/// Description:  取医院感染报告
/// Table：       DHCMed.NINF.Rep.InfReport
/// Input：       DHCMed.NINF.Rep.InfReport.ID
/// Return：      返回obj
/// w ##class(DHCMed.NINFService.Rep.InfReport).GetRepObj(1)
ClassMethod GetRepObj(aId As %String) As DHCMed.NINF.Rep.InfReport
{
	New (aId)
	Set return=""
	
	Set obj=##Class(DHCMed.NINF.Rep.InfReport).GetObjById(aId)
	If $IsObject(obj) {
		Set return=obj
	} Else {
		Set obj=##Class(DHCMed.NINF.Rep.InfReport).%New()
		If obj'="" Do obj.%Close()
		set return=obj
	}
	
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2012-06-26
/// Description:  保存医院感染报告
/// Table：       DHCMed.NINF.Rep.InfReport
/// Input：       
/// Return：      返回ID
/// w ##Class(DHCMed.NINFService.Rep.InfReport).SaveRepRec("","")
ClassMethod SaveRepRec(aInput As %String, aSeparate As %String) As %String
{
	New (aInput,aSeparate)
	Set return=0
	Set $ZT="SaveRepRecErr"
	
	Set CHR1=$p(aSeparate,",",1)
	Set CHR2=$p(aSeparate,",",2)
	Quit:(CHR1="")||(CHR2="") return
	
	Set ReportDate=$p(aInput,CHR1,7)                      //ReportDate
	;Set:ReportDate["-" ReportDate=$zdh(ReportDate,3)
	Set:ReportDate'="" ReportDate=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(ReportDate)
	Set:ReportDate="" ReportDate=+$h
	Set ReportTime=$p(aInput,CHR1,8)                      //ReportTime
	Set:ReportTime[":" ReportTime=$zth(ReportTime,1)
	Set:ReportTime="" ReportTime=$p($h,",",2)
	
	Set $p(aInput,CHR1,7)=ReportDate
	Set $p(aInput,CHR1,8)=ReportTime
	
	Set return=##Class(DHCMed.NINF.Rep.InfReport).Update(aInput,CHR1_","_CHR2)
	Quit return
	
SaveRepRecErr
	Quit -999
}

/// Creator：     zhufei
/// CreatDate：   2012-08-08
/// Description:  保存医院感染报告(只报告更新状态)
/// Table：       DHCMed.NINF.Rep.InfReport
/// Input：       
/// Return：      返回ID
/// w ##Class(DHCMed.NINFService.Rep.InfReport).SaveRepStatus("","")
ClassMethod SaveRepStatus(aInput As %String, aSeparate As %String) As %String
{
	New (aInput,aSeparate)
	Set return=0
	Set $ZT="SaveRepStatusErr"
	
	Set RepordID=$p(aInput,aSeparate,1)
	Set LogLoc=$p(aInput,aSeparate,2)
	Set LogUser=$p(aInput,aSeparate,3)
	Set RepStatus=$p(aInput,aSeparate,4)
	Set LogResume=$p(aInput,aSeparate,5)
	
	Set objStatus=##class(DHCMed.SS.Dictionary).GetObjById(RepStatus)
	Quit:'$IsObject(objStatus) return
	Set StatusCode=objStatus.Code
	
	Set obj=##class(DHCMed.NINF.Rep.InfReport).%OpenId(RepordID)
	Quit:'$IsObject(obj) return
	Set obj.ReportStatus=objStatus
	Set sc=obj.%Save()
	If $System.Status.IsError(sc) {  //检查Save是否成功
   		Do $System.OBJ.DisplayError(sc)
   		Set return=-1
	} Else {
		Set return=obj.%Id()
		Set RepTypeCode=obj.ReportType.Code
		
		//更新日志
		Set flg=##Class(DHCMed.NINF.Rep.InfReportLog).Update(aInput,aSeparate)
		
		//退回操作，往消息平台发消息
		If (LogResume'="")&&(StatusCode="5")&&(RepTypeCode="COMP") {
			//是否启用消息平台消息发送功能
			Set IsSendMsg=##class(DHCMed.SSService.ConfigSrv).GetValueByKeyHosp("SS-IsSendMessage","")
			If (+IsSendMsg)=1 {
				Set tmpOpinion="感染报告退回："_LogResume
				Set ReportID=obj.%Id()
				Set EpisodeID=obj.EpisodeID
				Set ReportUser=obj.ReportUser
				Set LnkJson="{""link"": ""dhcmed.ninf.rep.infreport.csp?1=1&ReportID="_ReportID_"&AdminPower=0&2=2""}"
				Set flg=##class(DHCMed.SSService.CommonCls).SendMsg(tmpOpinion,"1012",LogUser,EpisodeID,ReportUser,LnkJson)
			}
		}
	}
	Do obj.%Close()
	
	Quit return
	
SaveRepStatusErr
	Quit -999
}

/// Creator：     zhufei
/// CreatDate：   2012-07-01
/// Description:  查询医院感染报告信息
/// Table：       DHCMed.NINF.Rep.InfReport
/// Input:        
/// do ##class(%ResultSet).RunQuery("DHCMed.NINFService.Rep.InfReport","QryReportByAdm",340545)
Query QryReportByAdm(EpisodeID As %String, RepTypeCode As %String = "") As %Query(ROWSPEC = "ReportID:%String,EpisodeID:%String,TransID:%String,ReportTypeID:%String,ReportTypeCode:%String,ReportTypeDesc:%String,ReportLocID:%String,ReportLocDesc:%String,ReportUserID:%String,ReportUserDesc:%String,ReportDate:%String,ReportTime:%String,ReportStatusID:%String,ReportStatusDesc:%String,PatientID:%String,RegNo:%String,PatName:%String,Sex:%String,Age:%String,InfPos:%String,InfDate:%String,InfDiag:%String,Specimen:%String,TestResults:%String,LogResume:%String,EncryptLevel:%String,PatLevel:%String")
{
}

ClassMethod QryReportByAdmExecute(ByRef qHandle As %Binary, EpisodeID As %String, RepTypeCode As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:EpisodeID="" $$$OK
	
	Set xRepID=0
	For {
		Set xRepID=$o(^DHCMed.NINFi("InfRep",0,"IndexPaadm",EpisodeID,xRepID))
		Quit:xRepID=""
		
		Set objReport=##class(DHCMed.NINF.Rep.InfReport).GetObjById(xRepID)
		Continue:'$IsObject(objReport)
		
		Set (PatientID,PapmiNo,PatientName,PatientSex,PatientAge)=""
		Set (Paadm,TransID,ReportTypeID,ReportTypeCode,ReportTypeDesc)=""
		Set (ReportLocID,ReportLocDesc,ReportUserID,ReportUserDesc)=""
		Set (ReportDate,ReportTime,ReportStatusID,ReportStatusDesc)=""
		Set (InfPosDesc,InfDateDesc,InfDiagDesc,SpecimenDesc,TestResults)=""
		Set (LogResume)=""
		
		Set Paadm=objReport.EpisodeID
		If Paadm'="" {
			Set PatientID=$p($g(^PAADM(Paadm)),"^",1)
			Set objPatient=##class(DHCMed.Base.Patient).GetObjById(PatientID)
			If $IsObject(objPatient){
				Set PapmiNo=objPatient.PapmiNo              //登记号
				Set PatientName=objPatient.PatientName      //姓名
				Set PatientSex=objPatient.Sex               //性别
				Set PersonalID=objPatient.PersonalID        //身份证号
			}
			//统一调用年龄计算方法
			//upadte by pylian 2016-02-18 修改入院时间取值方式
    		Set AdmDateTime=##Class(DHCMed.SSIO.FromAdmSrv).GetAdmDateTime(Paadm)
			Set AdmDate=$p(AdmDateTime,"^",1)
			Set AdmTime=$p(AdmDateTime,"^",2)
			Set PatientAge=##class(DHCMed.SSIO.FromHisSrv).GetPapmiAge(PatientID,Paadm,AdmDate,AdmTime)
			;Set:AdmDate'="" AdmDate=$zd(AdmDate,3)
			Set:AdmDate'="" AdmDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(AdmDate)
			Set:AdmTime'="" AdmTime=$zt(AdmTime,2)

			Set (EncryptLevel,PatLevel)=""
			Set SecretStr=##class(DHCMed.SSIO.FromSecSrv).GetPatEncryptLevel(PatientID,.ErrMsg)
			Set:SecretStr'="" EncryptLevel=$p(SecretStr,"^",1)   //病人密级
			Set:SecretStr'="" PatLevel=$p(SecretStr,"^",2)		//病人级别
		}
		
		If $IsObject(objReport.ReportType) {
			Set ReportTypeID=objReport.ReportType.%Id()
			Set ReportTypeCode=objReport.ReportType.Code
			Set ReportTypeDesc=objReport.ReportType.Description
			Continue:(RepTypeCode'="")&&(RepTypeCode'=ReportTypeCode)
		}
		Set ObjectID=objReport.ObjectID
		Set ReportLoc=objReport.ReportLoc
		Set objRepLoc=##class(DHCMed.Base.Ctloc).GetObjById(ReportLoc)
		If $IsObject(objRepLoc) {
			Set ReportLocID=objRepLoc.Rowid
			Set ReportLocDesc=objRepLoc.Descs
		}
		Set ReportUser=objReport.ReportUser
		Set objRepUser=##class(DHCMed.Base.SSUser).GetObjById(ReportUser)
		If $IsObject(objRepUser) {
			Set ReportUserID=objRepUser.Rowid
			Set ReportUserDesc=objRepUser.Name
		}
		Set ReportDate=objReport.ReportDate
		;Set:ReportDate'="" ReportDate=$zd(ReportDate,3)
		Set:ReportDate'="" ReportDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(ReportDate)
		Set ReportTime=objReport.ReportTime
		Set:ReportTime'="" ReportTime=$zt(ReportTime,2)
		If $IsObject(objReport.ReportStatus) {
			Set ReportStatusID=objReport.ReportStatus.%Id()
			Set ReportStatusDesc=objReport.ReportStatus.Description
		}
		
		Set xLogID=""
		For {
			Set xLogID=$o(^DHCMed.NINF("InfRep",xRepID,"Log",xLogID),-1)
			Quit:xLogID=""
			Set objLog=##class(DHCMed.NINF.Rep.InfReportLog).GetObjById(xRepID_"||"_xLogID)
			Continue:'$IsObject(objLog)
			Continue:'$IsObject(objLog.LogStatus)
			Set LogStatusID=objLog.LogStatus.%Id()
			Continue:LogStatusID'=ReportStatusID
			
			Set LogResume=objLog.LogResume
			Quit
		}
		
		Set InfPosList=""
		Set InfDiagList=""
		Set InfDateList=""
		Set SubID=0
		For {
			Set SubID=$o(^DHCMed.NINF("InfRep",xRepID,"InfPos",SubID))
			Quit:SubID=""
			Set objInfPos=##class(DHCMed.NINF.Rep.InfReportInfPos).GetObjById(xRepID_"||"_SubID)
			Continue:'$IsObject(objInfPos)
			Set InfDate=objInfPos.InfDate
			;Set:InfDate'="" InfDate=$zd(InfDate,3)
			Set:InfDate'="" InfDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(InfDate)
			If $listfind(InfDateList,InfDate)<1 {
				Set InfDateList=InfDateList_$lb(InfDate)
				Set InfDateDesc=InfDateDesc_","_InfDate
			}
			If $IsObject(objInfPos.InfPos) {
				Set xInfPosDesc=objInfPos.InfPos.IPDesc
				If xInfPosDesc'="" {
					If $listfind(InfPosList,xInfPosDesc)<1 {
						Set InfPosList=InfPosList_$lb(xInfPosDesc)
						Set InfPosDesc=InfPosDesc_","_xInfPosDesc
					}
				}
			}
			Set xInfDiagDesc=""
		    If $IsObject(objInfPos.InfDiag) {
				Set xInfDiagDesc=objInfPos.InfDiag.IDDesc
		    }
			Set xInfDiagCatDesc=""
			If $IsObject(objInfPos.InfDiagCat) {
				Set xInfDiagCatDesc=objInfPos.InfDiagCat.Description
				Set xInfDiagDesc=xInfDiagDesc_"【"_xInfDiagCatDesc_"】"
		    }
			If xInfDiagDesc'="" {
				If $listfind(InfDiagList,xInfDiagDesc)<1 {
					Set InfDiagList=InfDiagList_$lb(xInfDiagDesc)
					Set InfDiagDesc=InfDiagDesc_","_xInfDiagDesc
				}
			}
		}
		
		Set SpecimenList=""
		Set TestResultsList=""
		Set SubID=0
		For {
			Set SubID=$o(^DHCMed.NINF("InfRep",xRepID,"Lab",SubID))
			Quit:SubID=""
			Set objLab=##class(DHCMed.NINF.Rep.InfReportLab).GetObjById(xRepID_"||"_SubID)
			Continue:'$Isobject(objLab)
			If $IsObject(objLab.Specimen){
				Set xSpecimenDesc=objLab.Specimen.Description
				If xSpecimenDesc'="" {
					If $listfind(SpecimenList,xSpecimenDesc)<1 {
						Set SpecimenList=SpecimenList_$lb(xSpecimenDesc)
						Set SpecimenDesc=SpecimenDesc_","_xSpecimenDesc
					}
				}
			}
			For indTestRst=1:1:objLab.TestResults.Count() {
				Set objTestRst=objLab.TestResults.GetAt(indTestRst)
				Continue:'$IsObject(objTestRst)
				Set xPathogenyDesc=objTestRst.PathogenyDesc
				Continue:xPathogenyDesc=""
				If $listfind(TestResultsList,xPathogenyDesc)<1 {
					Set TestResultsList=TestResultsList_$lb(xPathogenyDesc)
					Set TestResults=TestResults_","_xPathogenyDesc
				}
			}
		}
		
		//三管相关
		Set SubID=0
		For {
			Set SubID=$o(^DHCMed.NINF("InfRep",xRepID,"ICU",SubID))
			Quit:SubID=""
			Set objICU=##class(DHCMed.NINF.Rep.InfReportICU).GetObjById(xRepID_"||"_SubID)
			Continue:'$Isobject(objICU)
			Set InfDate=objICU.InfDate
			Continue:InfDate=""
			;Set:InfDate'="" InfDate=$zd(InfDate,3)
			Set:InfDate'="" InfDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(InfDate)
			If $listfind(InfDateList,InfDate)<1 {
				Set InfDateList=InfDateList_$lb(InfDate)
				Set InfDateDesc=InfDateDesc_","_InfDate
			}
			
			If $IsObject(objICU.IntubateType){
				Set IntubateTypeDesc=objICU.IntubateType.Description
				If $listfind(InfPosList,IntubateTypeDesc)<1 {
					Set InfPosList=InfPosList_$lb(IntubateTypeDesc)
					Set InfPosDesc=InfPosDesc_","_IntubateTypeDesc
				}
			}
		}
		
		//手术相关
		Set SubID=0
		For {
			Set SubID=$o(^DHCMed.NINF("InfRep",xRepID,"Opr",SubID))
			Quit:SubID=""
			Set objOper=##class(DHCMed.NINF.Rep.InfReportOpr).GetObjById(xRepID_"||"_SubID)
			Continue:'$Isobject(objOper)
			If $IsObject(objOper.OperInfType){
				Set OperInfTypeDesc=objOper.OperInfType.Description
				If $listfind(InfPosList,OperInfTypeDesc)<1 {
					Set InfPosList=InfPosList_$lb(OperInfTypeDesc)
					Set InfPosDesc=InfPosDesc_","_OperInfTypeDesc
				}
			}
		}
		Set:InfDateDesc'="" InfDateDesc=$e(InfDateDesc,2,$l(InfDateDesc))
		Set:InfPosDesc'="" InfPosDesc=$e(InfPosDesc,2,$l(InfPosDesc))
		Set:InfDiagDesc'="" InfDiagDesc=$e(InfDiagDesc,2,$l(InfDiagDesc))
		Set:SpecimenDesc'="" SpecimenDesc=$e(SpecimenDesc,2,$l(SpecimenDesc))
		Set:TestResults'="" TestResults=$e(TestResults,2,$l(TestResults))
		
		Set Data=$lb(xRepID,Paadm,ObjectID,ReportTypeID,ReportTypeCode,ReportTypeDesc)
		Set Data=Data_$lb(ReportLocID,ReportLocDesc,ReportUserID,ReportUserDesc)
		Set Data=Data_$lb(ReportDate,ReportTime,ReportStatusID,ReportStatusDesc)
		Set Data=Data_$lb(PatientID,PapmiNo,PatientName,PatientSex,PatientAge)
		Set Data=Data_$lb(InfPosDesc,InfDateDesc,InfDiagDesc,SpecimenDesc,TestResults)
		Set Data=Data_$lb(LogResume,EncryptLevel,PatLevel)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	Quit $$$OK
}

ClassMethod QryReportByAdmClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryReportByAdmExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryReportByAdmFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryReportByAdmExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：     zhufei
/// CreatDate：   2012-07-01
/// Description:  查询医院感染报告信息
/// Table：       DHCMed.NINF.Rep.InfReport
/// Input:        
/// do ##class(%ResultSet).RunQuery("DHCMed.NINFService.Rep.InfReport","QryRepInfoByDateLoc","1","2014-04-01","2014-05-05","","","","","","","")
Query QryRepInfoByDateLoc(aDateType As %String, aDateFrom As %String, aDateTo As %String, aRepLoc As %String, aRepStatus As %String, aRepType As %String, aRegNo As %String, aMrNo As %String, aPatName As %String, aHospital As %String) As %Query(ROWSPEC = "ReportID:%String,EpisodeID:%String,TransID:%String,TransLocID:%String,TransLocDesc:%String,ReportTypeID:%String,ReportTypeDesc:%String,ReportLocID:%String,ReportLocDesc:%String,ReportUserID:%String,ReportUserDesc:%String,ReportDate:%String,ReportTime:%String,ReportStatusID:%String,ReportStatusCode:%String,ReportStatusDesc:%String,AdmitDate:%String,DischDate:%String,AdmLoc:%String,AdmWard:%String,AdmBed:%String,PatientID:%String,PapmiNo:%String,PatName:%String,PatSex:%String,PatMrNo:%String,PatAge:%String,InfPos:%String,InfDiag:%String,InfDiagCatID:%String,InfDiagCatCode:%String,InfDiagCatDesc:%String,Specimen:%String,InfPath:%String,IsHaveHisRep:%String,EncryptLevel:%String,PatLevel:%String")
{
}

ClassMethod QryRepInfoByDateLocExecute(ByRef qHandle As %Binary, aDateType As %String, aDateFrom As %String, aDateTo As %String, aRepLoc As %String, aRepStatus As %String, aRepType As %String, aRegNo As %String, aMrNo As %String, aPatName As %String, aHospital As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:(aDateFrom="")||(aDateTo="")||(aDateType="") $$$OK
	
	;Set:aDateFrom["-" aDateFrom=$zdh(aDateFrom,3)
	;Set:aDateTo["-" aDateTo=$zdh(aDateTo,3)
	Set aDateFrom=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(aDateTo)
	
	//按报告日期查询
	If aDateType=1 {
		Set xDate=aDateFrom-1
		For {
			Set xDate=$o(^DHCMed.NINFi("InfRep",0,"IndexRepDateLoc",xDate))
			Quit:xDate=""
			Quit:xDate>aDateTo
			
			//update by liuyh 2013-05-09 考虑到 报告时间 为 0 的情况
			Set xTime=""
			For {
				Set xTime=$o(^DHCMed.NINFi("InfRep",0,"IndexRepDateLoc",xDate,xTime))
				Quit:xTime=""
				
				Set xLoc=0
				For {
					Set xLoc=$o(^DHCMed.NINFi("InfRep",0,"IndexRepDateLoc",xDate,xTime,xLoc))
					Quit:xLoc=""
					Continue:(aRepLoc'="")&&(aRepLoc'=xLoc)
					
					Set xRepID=0
					For {
						Set xRepID=$o(^DHCMed.NINFi("InfRep",0,"IndexRepDateLoc",xDate,xTime,xLoc,xRepID))
						Quit:xRepID=""
						Set ReportID=xRepID
						Do BuildReportData
					}
				}
			}
		}
	}
	//按入院日期查询
	If aDateType=2 {
		//^PAADMi("PAADM_AdmDate",{PAADM_AdmDate},{PAADM_RowID})
		//upadte by pylian 2016-02-18 修改入院时间索引
		Set AdmDateIndex=##Class(DHCMed.SSIO.FromAdmSrv).GetAdmDateIndex()
		For xDate=aDateFrom:1:aDateTo {
			Set xPaadm=0
			For {
				Set xPaadm=$o(^PAADMi(AdmDateIndex,xDate,xPaadm))
				Quit:xPaadm=""
				Set AdmInfo=$g(^PAADM(xPaadm))
				Continue:$p(AdmInfo,"^",2)'="I"           //就诊类型过滤
				Continue:$p(AdmInfo,"^",20)="C"           //就诊状态过滤
				
				Set xRepID=0
				For {
					Set xRepID=$o(^DHCMed.NINFi("InfRep",0,"IndexPaadm",xPaadm,xRepID))
					Quit:xRepID=""
					Set ReportID=xRepID
					Do BuildReportData
				}
			}
		}
	}
	//按出院日期查询
	If aDateType=3 {
		//^PAADMi("DischDate",{PAADM_DischgDate},{PAADM_RowID})
		Set DischDateIndex=##Class(DHCMed.SSIO.FromAdmSrv).GetDischDateIndex()  //update by pylian 2016-01-21取出院时间索引	
		For xDate=aDateFrom:1:aDateTo {
			Set xPaadm=0
			For {
				Set xPaadm=$o(^PAADMi(DischDateIndex,xDate,xPaadm))
				Quit:xPaadm=""
				Set AdmInfo=$g(^PAADM(xPaadm))
				Continue:$p(AdmInfo,"^",2)'="I"           //就诊类型过滤
				Continue:$p(AdmInfo,"^",20)="C"           //就诊状态过滤
				
				Set xRepID=0
				For {
					Set xRepID=$o(^DHCMed.NINFi("InfRep",0,"IndexPaadm",xPaadm,xRepID))
					Quit:xRepID=""
					Set ReportID=xRepID
					Do BuildReportData
				}
			}
		}
	}
	//按感染日期查询          add by yk 2016-06-15
	If aDateType=4 {
		Set RepList=""
		Set xDate=aDateFrom-1
		For {
			Set xDate=$o(^DHCMed.NINFi("InfRep",0,"InfPos","IndexInfDate",xDate))
			Quit:xDate=""
			Quit:xDate>aDateTo
			Set xRepID=0
			For {
				Set xRepID=$o(^DHCMed.NINFi("InfRep",0,"InfPos","IndexInfDate",xDate,xRepID))
				Quit:xRepID=""
				Continue:$listfind(RepList,xRepID)>0
				Set RepList=RepList_$lb(xRepID)
				Set ReportID=xRepID
				Do BuildReportData
			}
		}
	}
	
	Quit $$$OK
	
BuildReportData
	Set (AdmitDate,AdmitTime,DischDate,AdmLoc,AdmWard,AdmBed,PatientID,PapmiNo,PatName,PatSex,PatMrNo,PatAge)=""
	Set (EpisodeID,TransID,TransLocID,TransLocDesc,ReportTypeID,ReportTypeDesc)=""
	Set (ReportLocID,ReportLocDesc,ReportUserID,ReportUserDesc)=""
	Set (ReportDate,ReportTime,ReportStatusID,ReportStatusCode,ReportStatusDesc)=""
	Set (InfPosDesc,InfDiagDesc,InfDiagCatID,InfDiagCatCode,InfDiagCatDesc,SpecimenDesc,TestResults)=""
	Set (EncryptLevel,PatLevel)=""
	Set objReport=##class(DHCMed.NINF.Rep.InfReport).GetObjById(ReportID)
	Quit:'$IsObject(objReport)
	
	If $IsObject(objReport.ReportType) {
		Set ReportTypeID=objReport.ReportType.%Id()
		Set ReportTypeDesc=objReport.ReportType.Description
	}
	Quit:(aRepType'="")&&(ReportTypeID'=aRepType)
	
	If $IsObject(objReport.ReportStatus) {
		Set ReportStatusID=objReport.ReportStatus.%Id()
		Set ReportStatusCode=objReport.ReportStatus.Code
		Set ReportStatusDesc=objReport.ReportStatus.Description
	}
	Quit:(aRepStatus'="")&&(ReportStatusID'=aRepStatus)
	
	Set ReportLoc=objReport.ReportLoc
	Set objRepLoc=##class(DHCMed.Base.Ctloc).GetObjById(ReportLoc)
	If $IsObject(objRepLoc) {
		Set ReportLocID=objRepLoc.Rowid
		Set ReportLocDesc=objRepLoc.Descs
	}
	Quit:(aRepLoc'="")&&(ReportLocID'=aRepLoc)
	if aHospital'="" {
		set flg=##class(DHCMed.SSService.HospitalSrv).CheckHospital(ReportLocID,aHospital)
		Quit:flg<1
	}
	
	
	Set EpisodeID=objReport.EpisodeID  //就诊号
	Set objPaadm=##class(DHCMed.Base.PatientAdm).GetObjById(EpisodeID)
	Quit:'$IsObject(objPaadm)
	Set AdmitDate=objPaadm.AdmitDate
	Set AdmitTime=objPaadm.AdmitTime
	Set DischDate=objPaadm.DisDate
	Set AdmLoc=objPaadm.Department
	Set AdmWard=objPaadm.Ward
	Set AdmBed=objPaadm.Bed
	Set PatientID=objPaadm.PatientID
	Set objPatient=##class(DHCMed.Base.Patient).GetObjById(PatientID)
	Quit:'$IsObject(objPatient)
	//***************
	//update 2013/01/15
	Set PapmiNo=objPatient.PapmiNo
	Set:aRegNo'="" aRegNo=$ZCVT($g(aRegNo),"W")	//登记号大小写转换---201404299 yanjifu
	Quit:(aRegNo'="")&&(PapmiNo'=aRegNo)
	
	Set PatName=objPatient.PatientName
	Quit:(aPatName'="")&&(PatName'=aPatName)
		 
	Set MrNo=##class(DHCMed.NINFService.Srv.CommonSrv).GetMrNoByAdm(EpisodeID)	
	Set PatMrNo=objPatient.InPatientMrNo
	Set:(PatMrNo="") PatMrNo=MrNo
	Set:aMrNo'="" aMrNo=$ZCVT($g(aMrNo),"W")	//病案号大小写转换---201404299 yanjifu
	Quit:(aMrNo'="")&&(PatMrNo'=aMrNo)
	//****************
	//统一调用年龄计算方法
	Set PatAge=##class(DHCMed.SSIO.FromHisSrv).GetPapmiAge(PatientID,EpisodeID,AdmitDate,AdmitTime)
	
	Set PatSex=objPatient.Sex
	Set SecretStr=##class(DHCMed.SSIO.FromSecSrv).GetPatEncryptLevel(PatientID,.ErrMsg)
	Set:SecretStr'="" EncryptLevel=$p(SecretStr,"^",1)   //病人密级
	Set:SecretStr'="" PatLevel=$p(SecretStr,"^",2)		//病人级别
	
	Set InfPosList=""
	Set InfDiagList=""
	Set SubID=0
	For {
		Set SubID=$o(^DHCMed.NINF("InfRep",ReportID,"InfPos",SubID))
		Quit:SubID=""
		Set objInfPos=##class(DHCMed.NINF.Rep.InfReportInfPos).GetObjById(ReportID_"||"_SubID)
		Continue:'$IsObject(objInfPos)
		If $IsObject(objInfPos.InfPos) {
			Set xInfPosDesc=objInfPos.InfPos.IPDesc
			If xInfPosDesc'="" {
				If $listfind(InfPosList,xInfPosDesc)<1 {
					Set InfPosList=InfPosList_$lb(xInfPosDesc)
					Set InfPosDesc=InfPosDesc_","_xInfPosDesc
				}
			}
		}
	    If $IsObject(objInfPos.InfDiag) {
			Set xInfDiagDesc=objInfPos.InfDiag.IDDesc
			If xInfDiagDesc'="" {
				If $listfind(InfDiagList,xInfDiagDesc)<1 {
					Set InfDiagList=InfDiagList_$lb(xInfDiagDesc)
					Set InfDiagDesc=InfDiagDesc_","_xInfDiagDesc
				}
			}
	    }
	    If $IsObject(objInfPos.InfDiagCat) {
			Set InfDiagCatID=objInfPos.InfDiagCat.%Id()
			Set InfDiagCatCode=objInfPos.InfDiagCat.Code
			Set InfDiagCatDesc=objInfPos.InfDiagCat.Description
		}
	}
	Set:InfPosDesc'="" InfPosDesc=$e(InfPosDesc,2,$l(InfPosDesc))
	Set:InfDiagDesc'="" InfDiagDesc=$e(InfDiagDesc,2,$l(InfDiagDesc))
	
	Set SpecimenList=""
	Set TestResultsList=""
	Set SubID=0
	For {
		Set SubID=$o(^DHCMed.NINF("InfRep",ReportID,"Lab",SubID))
		Quit:SubID=""
		Set objLab=##class(DHCMed.NINF.Rep.InfReportLab).GetObjById(ReportID_"||"_SubID)
		Continue:'$Isobject(objLab)
		If $IsObject(objLab.Specimen){
			Set xSpecimenDesc=objLab.Specimen.Description
			If xSpecimenDesc'="" {
				If $listfind(SpecimenList,xSpecimenDesc)<1 {
					Set SpecimenList=SpecimenList_$lb(xSpecimenDesc)
					Set SpecimenDesc=SpecimenDesc_","_xSpecimenDesc
				}
			}
		}
		For indTestRst=1:1:objLab.TestResults.Count() {
			Set objTestRst=objLab.TestResults.GetAt(indTestRst)
			Continue:'$IsObject(objTestRst)
			Set xPathogenyDesc=objTestRst.PathogenyDesc
			Continue:xPathogenyDesc=""
			If $listfind(TestResultsList,xPathogenyDesc)<1 {
				Set TestResultsList=TestResultsList_$lb(xPathogenyDesc)
				Set TestResults=TestResults_","_xPathogenyDesc
			}
		}
	}
	Set:SpecimenDesc'="" SpecimenDesc=$e(SpecimenDesc,2,$l(SpecimenDesc))
	Set:TestResults'="" TestResults=$e(TestResults,2,$l(TestResults))
	
	Set TransID=objReport.ObjectID  //转科记录ID
	
	Set ReportUser=objReport.ReportUser
	Set objRepUser=##class(DHCMed.Base.SSUser).GetObjById(ReportUser)
	If $IsObject(objRepUser) {
		Set ReportUserID=objRepUser.Rowid
		Set ReportUserDesc=objRepUser.Name
	}
	Set ReportDate=objReport.ReportDate
	;Set:ReportDate'="" ReportDate=$zd(ReportDate,3)
	Set:ReportDate'="" ReportDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(ReportDate)
	Set ReportTime=objReport.ReportTime
	Set:ReportTime'="" ReportTime=$zt(ReportTime,2)
	
	Set SummID=$o(^DHCMed.NINF("InfRep",+ReportID,"Summ",0))
	If SummID'="" {
		Set objSumm=##class(DHCMed.NINF.Rep.InfReportSumm).GetObjById(ReportID_"||"_SummID)
		If $IsObject(objSumm) {
			Set TransLoc=objSumm.TransLoc
			Set objTransLoc=##class(DHCMed.Base.Ctloc).GetObjById(TransLoc)
			If $IsObject(objTransLoc) {
				Set TransLocID=objTransLoc.Rowid
				Set TransLocDesc=objTransLoc.Descs
			}
		}
	}
	
	//判断是否有历史报告
	Set IsHaveHisRep="N"
	Set yRepID=ReportID
	For {
		Set yRepID=$o(^DHCMed.NINFi("InfRep",0,"IndexPaadm",EpisodeID,yRepID),-1)
		Quit:yRepID=""
		Quit:IsHaveHisRep="Y"
		
		Set objRep=##class(DHCMed.NINF.Rep.InfReport).GetObjById(yRepID)
		Continue:'$IsObject(objRep)
		Continue:'$IsObject(objRep.ReportStatus)
		Set RepStatus=objRep.ReportStatus.Description
		Continue:RepStatus="删除"
		
		Continue:'$IsObject(objRep.ReportType)
		Set RepTypeID=objRep.ReportType.%Id()
		Continue:(aRepType'="")&&(RepTypeID'=aRepType)
		
		Set IsHaveHisRep="Y"
	}
	
	Set Data=$lb(ReportID,EpisodeID,TransID,TransLocID,TransLocDesc,ReportTypeID,ReportTypeDesc)
	Set Data=Data_$lb(ReportLocID,ReportLocDesc,ReportUserID,ReportUserDesc)
	Set Data=Data_$lb(ReportDate,ReportTime,ReportStatusID,ReportStatusCode,ReportStatusDesc)
	Set Data=Data_$lb(AdmitDate,DischDate,AdmLoc,AdmWard,AdmBed,PatientID,PapmiNo,PatName,PatSex,PatMrNo,PatAge)
	Set Data=Data_$lb(InfPosDesc,InfDiagDesc,InfDiagCatID,InfDiagCatCode,InfDiagCatDesc,SpecimenDesc,TestResults,IsHaveHisRep)
	Set Data=Data_$lb(EncryptLevel,PatLevel)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	
	Quit
}

ClassMethod QryRepInfoByDateLocClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryRepInfoByDateLocExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryRepInfoByDateLocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryRepInfoByDateLocExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：     zhufei
/// CreatDate：   2012-07-01
/// Description:  查询日期类型
/// Table：       
/// Input:        
/// do ##class(%ResultSet).RunQuery("DHCMed.NINFService.Rep.InfReport","QryDateType")
Query QryDateType(aRepType As %String) As %Query(ROWSPEC = "TypeCode:%String,TypeDesc:%String")
{
}

ClassMethod QryDateTypeExecute(ByRef qHandle As %Binary, aRepType As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	If (aRepType="COMP")||(aRepType="NCOM") {
		Set DateTypeList=$lb($lb(1,"报告日期"),$lb(2,"入院日期"),$lb(3,"出院日期"),$lb(4,"感染日期"))
	}
	else{
		Set DateTypeList=$lb($lb(1,"报告日期"),$lb(2,"入院日期"),$lb(3,"出院日期"))
	}
		
	For indType=1:1:$listlength(DateTypeList)
	{
		Set Data=$list(DateTypeList,indType)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	
	Quit $$$OK
}

ClassMethod QryDateTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryDateTypeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryDateTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryDateTypeExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：     zhufei
/// CreatDate：   2012-12-25
/// Description:  取目标性监测IDList
/// Table：       DHCMed.NINF.Rep.InfReport
/// Input：       
/// Return：      返回IDList
/// w ##Class(DHCMed.NINFService.Rep.InfReport).GetIDList("","","","")
ClassMethod GetIDList(aReportID As %String, aEpisodeID As %String, aRepTypeID As %String, aObjectID As %String) As %List
{
	New (aReportID, aEpisodeID, aRepTypeID, aObjectID)
	Set return=""
	
	Set (ReportID,EpisodeID,RepTypeID,ObjectID,ReportLoc)=""
	If aReportID'="" {
		Set objReport=##Class(DHCMed.NINF.Rep.InfReport).GetObjById(aReportID)
		If $IsObject(objReport) {
			Set ReportID=objReport.%Id()
			Set EpisodeID=objReport.EpisodeID
			Set ObjectID=objReport.ObjectID
			If ObjectID="" {
				Set ObjectID=objReport.TransID
			}
			Set RepTypeID=objReport.ReportType.%Id()
			Set ReportLoc=objReport.ReportLoc
		}
	} Else {
		Set EpisodeID=aEpisodeID
		Set objRepType=##class(DHCMed.SS.Dictionary).GetObjById(aRepTypeID)
		If $IsObject(objRepType) {
			Set RepTypeID=objRepType.%Id()
		}
		If aObjectID'="" {
			Set ObjectID=aObjectID
		} Else {
			If (EpisodeID'="")&&(RepTypeID'="") {
				Set ObjectID=+$o(^DHCMed.NINFi("InfRep",0,"IndexTypeAdmTrans",RepTypeID,EpisodeID,""),-1)
				Set ObjectID=ObjectID+1
			}
		}
		If (EpisodeID'="")&&(RepTypeID'="")&&(ObjectID'="") {
			Set ReportID=$o(^DHCMed.NINFi("InfRep",0,"IndexTypeAdmTrans",RepTypeID,EpisodeID,ObjectID,""))
		} Else {
			Set ReportID=""
		}
	}
	Quit:((EpisodeID="")||(RepTypeID="")||(ObjectID="")) return
	
	Set return=$lb(ReportID,EpisodeID,RepTypeID,ObjectID,ReportLoc)
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2012-07-01
/// Description:  查询手术切口监测登记表
/// Table：       DHCMed.NINF.Rep.InfReport
/// Input:        
/// do ##class(%ResultSet).RunQuery("DHCMed.NINFService.Rep.InfReport","QryOprRepByDate","1","2013-01-01","2014-01-20","","","1479")
Query QryOprRepByDate(aDateType As %String, aDateFrom As %String, aDateTo As %String, aRepLoc As %String, aRepStatus As %String, aRepType As %String) As %Query(ROWSPEC = "ReportID:%String,EpisodeID:%String,ObjectID:%String,ReportTypeID:%String,ReportTypeDesc:%String,ReportLocID:%String,ReportLocDesc:%String,ReportUserID:%String,ReportUserDesc:%String,ReportDate:%String,ReportTime:%String,ReportStatusID:%String,ReportStatusCode:%String,ReportStatusDesc:%String,AdmitDate:%String,DischDate:%String,AdmLoc:%String,AdmWard:%String,AdmBed:%String,PatientID:%String,PapmiNo:%String,PatName:%String,PatSex:%String,PatMrNo:%String,PatAge:%String,EncryptLevel:%String,PatLevel:%String,RecordID:%String,OperationID:%String,OperationDesc:%String,OperDocID:%String,OperDocDesc:%String,OperStartDate:%String,OperStartTime:%String,OperStartDateTime:%String,OperEndDate:%String,OperEndTime:%String,OperEndDateTime:%String,OperationTypeID:%String,OperationTypeDesc:%String,AnesthesiaID:%String,AnesthesiaDesc:%String,CuteTypeID:%String,CuteTypeDesc:%String,CuteHealingID:%String,CuteHealingDesc:%String,CuteInfFlagID:%String,CuteInfFlagDesc:%String,OperInfTypeID:%String,OperInfTypeDesc:%String,InHospInfFlagID:%String,InHospInfFlagDesc:%String,ASAScoreID:%String,ASAScoreDesc:%String,DataSource:%String,PreoperWBC:%String,CuteNumberID:%String,CuteNumberDesc:%String,EndoscopeFlagID:%String,EndoscopeFlagDesc:%String,ImplantFlagID:%String,ImplantFlagDesc:%String,PreoperAntiFlagID:%String,PreoperAntiFlagDesc:%String,BloodLossFlagID:%String,BloodLossFlagDesc:%String,BloodLoss:%String,BloodTransFlagID:%String,BloodTransFlagDesc:%String,BloodTrans:%String,PostoperComps:%String,PostoperCompsDesc:%String,OperTimes:%String,NNISScore:%String")
{
}

ClassMethod QryOprRepByDateExecute(ByRef qHandle As %Binary, aDateType As %String, aDateFrom As %String, aDateTo As %String, aRepLoc As %String, aRepStatus As %String, aRepType As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:(aDateFrom="")||(aDateTo="")||(aDateType="") $$$OK
	;Set:aDateFrom["-" aDateFrom=$zdh(aDateFrom,3)
	;Set:aDateTo["-" aDateTo=$zdh(aDateTo,3)
	Set aDateFrom=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(aDateTo)
	
	If aRepType="" {
		Set objRepType=##class(DHCMed.SS.Dictionary).GetByTypeCode("NINFInfReportType","OPR","")
		If $IsObject(objRepType) {
			Set aRepType=objRepType.%Id()
		}
	}
	Quit:aRepType="" $$$OK
	
	//按报告日期查询
	If aDateType=1 {
		Set xDate=aDateFrom-1
		For {
			Set xDate=$o(^DHCMed.NINFi("InfRep",0,"IndexRepDateLoc",xDate))
			Quit:xDate=""
			Quit:xDate>aDateTo
			
			Set xTime=0
			For {
				Set xTime=$o(^DHCMed.NINFi("InfRep",0,"IndexRepDateLoc",xDate,xTime))
				Quit:xTime=""
				
				Set xLoc=0
				For {
					Set xLoc=$o(^DHCMed.NINFi("InfRep",0,"IndexRepDateLoc",xDate,xTime,xLoc))
					Quit:xLoc=""
					Continue:(aRepLoc'="")&&(aRepLoc'=xLoc)
					
					Set xRepID=0
					For {
						Set xRepID=$o(^DHCMed.NINFi("InfRep",0,"IndexRepDateLoc",xDate,xTime,xLoc,xRepID))
						Quit:xRepID=""
						
						Set flg=..CheckRepDataToOpr(xRepID,aRepType,aRepStatus,aRepLoc)
						Continue:flg<1
						Set RepData=..BuildRepData(xRepID)
						Continue:RepData=""
						
						Set xSubID=0
						For {
							Set xSubID=$o(^DHCMed.NINF("InfRep",xRepID,"Opr",xSubID))
							Quit:xSubID=""
							Set SubData=..BuildOprData(xRepID,xSubID)
							Continue:SubData=""
							Set ^CacheTemp(repid,ind)=RepData_SubData
							Set ind=ind+1
						}
					}
				}
			}
		}
	}
	//按入院日期查询
	If aDateType=2 {
		//^PAADMi("PAADM_AdmDate",{PAADM_AdmDate},{PAADM_RowID})
		//upadte by pylian 2016-02-18 修改入院时间索引
		Set AdmDateIndex=##Class(DHCMed.SSIO.FromAdmSrv).GetAdmDateIndex()
		For xDate=aDateFrom:1:aDateTo {
			Set xPaadm=0
			For {
				Set xPaadm=$o(^PAADMi(AdmDateIndex,xDate,xPaadm))
				Quit:xPaadm=""
				Set AdmInfo=$g(^PAADM(xPaadm))
				Continue:$p(AdmInfo,"^",2)'="I"           //就诊类型过滤
				Continue:$p(AdmInfo,"^",20)="C"           //就诊状态过滤
				
				Set xRepID=0
				For {
					Set xRepID=$o(^DHCMed.NINFi("InfRep",0,"IndexPaadm",xPaadm,xRepID))
					Quit:xRepID=""
					
					Set flg=..CheckRepDataToOpr(xRepID,aRepType,aRepStatus,aRepLoc)
					Continue:flg<1
					Set RepData=..BuildRepData(xRepID)
					Continue:RepData=""
					
					Set xSubID=0
					For {
						Set xSubID=$o(^DHCMed.NINF("InfRep",xRepID,"Opr",xSubID))
						Quit:xSubID=""
						Set SubData=..BuildOprData(xRepID,xSubID)
						Continue:SubData=""
						Set ^CacheTemp(repid,ind)=RepData_SubData
						Set ind=ind+1
					}
				}
			}
		}
	}
	//按出院日期查询
	If aDateType=3 {
		//^PAADMi("DischDate",{PAADM_DischgDate},{PAADM_RowID})
		Set DischDateIndex=##Class(DHCMed.SSIO.FromAdmSrv).GetDischDateIndex()  //update by pylian 2016-01-21取出院时间索引	
		For xDate=aDateFrom:1:aDateTo {
			Set xPaadm=0
			For {
				Set xPaadm=$o(^PAADMi(DischDateIndex,xDate,xPaadm))
				Quit:xPaadm=""
				Set AdmInfo=$g(^PAADM(xPaadm))
				Continue:$p(AdmInfo,"^",2)'="I"           //就诊类型过滤
				Continue:$p(AdmInfo,"^",20)="C"           //就诊状态过滤
				
				Set xRepID=0
				For {
					Set xRepID=$o(^DHCMed.NINFi("InfRep",0,"IndexPaadm",xPaadm,xRepID))
					Quit:xRepID=""
					
					Set flg=..CheckRepDataToOpr(xRepID,aRepType,aRepStatus,aRepLoc)
					Continue:flg<1
					Set RepData=..BuildRepData(xRepID)
					Continue:RepData=""
					
					Set xSubID=0
					For {
						Set xSubID=$o(^DHCMed.NINF("InfRep",xRepID,"Opr",xSubID))
						Quit:xSubID=""
						Set SubData=..BuildOprData(xRepID,xSubID)
						Continue:SubData=""
						Set ^CacheTemp(repid,ind)=RepData_SubData
						Set ind=ind+1
					}
				}
			}
		}
	}
	
	Quit $$$OK
}

ClassMethod QryOprRepByDateClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryOprRepByDateExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryOprRepByDateFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryOprRepByDateExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// 检查手术切口报告
ClassMethod CheckRepDataToOpr(aReportID As %String, aRepType As %String, aRepStatus As %String, aRepLoc As %String)
{
	New (aReportID,aRepType,aRepStatus,aRepLoc)
	Set return=0
	
	Set objReport=##class(DHCMed.NINF.Rep.InfReport).GetObjById(aReportID)
	Quit:'$IsObject(objReport) return
	
	If $IsObject(objReport.ReportType) {
		Set ReportTypeID=objReport.ReportType.%Id()
		Set ReportTypeDesc=objReport.ReportType.Description
	}
	Quit:(aRepType'="")&&(ReportTypeID'=aRepType) return
	
	If $IsObject(objReport.ReportStatus) {
		Set ReportStatusID=objReport.ReportStatus.%Id()
		Set ReportStatusCode=objReport.ReportStatus.Code
		Set ReportStatusDesc=objReport.ReportStatus.Description
	}
	Quit:(aRepStatus'="")&&(ReportStatusID'=aRepStatus) return
	
	Set ReportLoc=objReport.ReportLoc
	Set objRepLoc=##class(DHCMed.Base.Ctloc).GetObjById(ReportLoc)
	If $IsObject(objRepLoc) {
		Set ReportLocID=objRepLoc.Rowid
		Set ReportLocDesc=objRepLoc.Descs
	}
	Quit:(aRepLoc'="")&&(ReportLocID'=aRepLoc) return
	
	Set return=1
	Quit return
}

/// 取手术切口信息
/// 取手术风险评估信息
ClassMethod BuildOprData(aRepID As %String, aSubID As %String) As %List
{
	New (aRepID,aSubID)
	Set return=""
	
	Set objSub=##class(DHCMed.NINF.Rep.InfReportOpr).GetObjById(aRepID_"||"_aSubID)
	Quit:'$IsObject(objSub) return
	
	Set (OperationID,OperationDesc,OperDocID,OperDocDesc)=""
	Set (OperStartDate,OperStartTime,OperStartDateTime,OperEndDate,OperEndTime,OperEndDateTime)=""
	Set (OperationTypeID,OperationTypeDesc,AnesthesiaID,AnesthesiaDesc)=""
	Set (CuteTypeID,CuteTypeDesc,CuteHealingID,CuteHealingDesc)=""
	Set (CuteInfFlagID,CuteInfFlagDesc,OperInfTypeID,OperInfTypeDesc,InHospInfFlagID,InHospInfFlagDesc)=""
	Set (ASAScoreID,ASAScoreDesc,DataSource)=""
	Set (PreoperWBC,CuteNumberID,CuteNumberDesc)=""
	Set (EndoscopeFlagID,EndoscopeFlagDesc,ImplantFlagID,ImplantFlagDesc,PreoperAntiFlagID,PreoperAntiFlagDesc)=""
	Set (BloodLossFlagID,BloodLossFlagDesc,BloodLoss,BloodTransFlagID,BloodTransFlagDesc,BloodTrans,PostoperComps,PostoperCompsDesc)=""
	Set (OperTimes,NNISScore)=0
	
	Set OperationID=objSub.OperationID
	Set OperationDesc=objSub.OperationDesc
	
	Set OperStartDate=objSub.OperStartDate
	Set OperStartTime=objSub.OperStartTime
	Set OperEndDate=+objSub.OperEndDate
	Set OperEndTime=+objSub.OperEndTime
	If (OperStartDate'="")&&(OperEndDate'="") {
		Set OperTimes=((OperEndDate-OperStartDate)*24*60)+((OperEndTime-OperEndTime)/60)
		Set OperTimes=$fn(OperTimes/60,"",1)
		Set:OperTimes>3 NNISScore=NNISScore+1
	}
	If (OperStartDate'="") {
		;Set OperStartDate=$zd(OperStartDate,3)
		Set OperStartDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(OperStartDate)
		Set OperStartTime=$zt(+OperStartTime,2)
		Set OperStartDateTime=OperStartDate_" "_OperStartTime
	}
	If (OperEndDate'="") {
		;Set OperEndDate=$zd(OperEndDate,3)
		Set OperEndDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(OperEndDate)
		Set OperEndTime=$zt(+OperEndTime,2)
		Set OperEndDateTime=OperEndDate_" "_OperEndTime
	}
	
	Set OperDoc=objSub.OperDoc
	Set objSSUser=##class(DHCMed.Base.SSUser).GetObjById(OperDoc)
	If $IsObject(objSSUser) {
		Set OperDocID=objSSUser.Rowid
		Set OperDocDesc=objSSUser.Name
	}
	If $IsObject(objSub.OperationType) {
		Set OperationTypeID=objSub.OperationType.%Id()
		Set OperationTypeDesc=objSub.OperationType.Description
	}
	If $IsObject(objSub.Anesthesia) {
		Set AnesthesiaID=objSub.Anesthesia.%Id()
		Set AnesthesiaDesc=objSub.Anesthesia.Description
	}
	If $IsObject(objSub.CuteType) {
		Set CuteTypeID=objSub.CuteType.%Id()
		Set CuteTypeDesc=objSub.CuteType.Description
		Set CuteTypeCode=objSub.CuteType.Code
		If (CuteTypeCode="3")||(CuteTypeCode="4") {
			Set NNISScore=NNISScore+1
		}
	}
	If $IsObject(objSub.CuteHealing) {
		Set CuteHealingID=objSub.CuteHealing.%Id()
		Set CuteHealingDesc=objSub.CuteHealing.Description
	}
	If $IsObject(objSub.CuteInfFlag) {
		Set CuteInfFlagID=objSub.CuteInfFlag.%Id()
		Set CuteInfFlagDesc=objSub.CuteInfFlag.Description
	}
	If $IsObject(objSub.OperInfType) {
		Set OperInfTypeID=objSub.OperInfType.%Id()
		Set OperInfTypeDesc=objSub.OperInfType.Description
	}
	If $IsObject(objSub.InHospInfFlag) {
		Set InHospInfFlagID=objSub.InHospInfFlag.%Id()
		Set InHospInfFlagDesc=objSub.InHospInfFlag.Description
	}
	If $IsObject(objSub.ASAScore) {
		Set ASAScoreID=objSub.ASAScore.%Id()
		Set ASAScoreDesc=objSub.ASAScore.Description
		Set ASAScoreCode=objSub.ASAScore.Code
		If (ASAScoreCode="3")||(ASAScoreCode="4")||(ASAScoreCode="5")||(ASAScoreCode="6") {
			Set NNISScore=NNISScore+1
		}
	}
	Set DataSource=objSub.DataSource
	Set PreoperWBC=objSub.PreoperWBC
	If $IsObject(objSub.CuteNumber) {
		Set CuteNumberID=objSub.CuteNumber.%Id()
		Set CuteNumberDesc=objSub.CuteNumber.Description
	}
	If $IsObject(objSub.EndoscopeFlag) {
		Set EndoscopeFlagID=objSub.EndoscopeFlag.%Id()
		Set EndoscopeFlagDesc=objSub.EndoscopeFlag.Description
	}
	If $IsObject(objSub.ImplantFlag) {
		Set ImplantFlagID=objSub.ImplantFlag.%Id()
		Set ImplantFlagDesc=objSub.ImplantFlag.Description
	}
	If $IsObject(objSub.PreoperAntiFlag) {
		Set PreoperAntiFlagID=objSub.PreoperAntiFlag.%Id()
		Set PreoperAntiFlagDesc=objSub.PreoperAntiFlag.Description
	}
	If $IsObject(objSub.BloodLossFlag) {
		Set BloodLossFlagID=objSub.BloodLossFlag.%Id()
		Set BloodLossFlagDesc=objSub.BloodLossFlag.Description
	}
	Set BloodLoss=objSub.BloodLoss
	If $IsObject(objSub.BloodTransFlag) {
		Set BloodTransFlagID=objSub.BloodTransFlag.%Id()
		Set BloodTransFlagDesc=objSub.BloodTransFlag.Description
	}
	Set BloodTrans=objSub.BloodTrans
	For indPC=1:1:objSub.PostoperComps.Count() {
		Set objPC=objSub.PostoperComps.GetAt(indPC)
		Continue:'$IsObject(objPC)
		Set PostoperComps=PostoperComps_","_objPC.%Id()
		Set PostoperCompsDesc=PostoperCompsDesc_","_objPC.Description
	}
	Set:PostoperComps'="" PostoperComps=$e(PostoperComps,2,$l(PostoperComps))
	Set:PostoperCompsDesc'="" PostoperCompsDesc=$e(PostoperCompsDesc,2,$l(PostoperCompsDesc))
	
	Set Data=$lb(aRepID_"||"_aSubID,OperationID,OperationDesc,OperDocID,OperDocDesc)
	Set Data=Data_$lb(OperStartDate,OperStartTime,OperStartDateTime,OperEndDate,OperEndTime,OperEndDateTime)
	Set Data=Data_$lb(OperationTypeID,OperationTypeDesc,AnesthesiaID,AnesthesiaDesc)
	Set Data=Data_$lb(CuteTypeID,CuteTypeDesc,CuteHealingID,CuteHealingDesc)
	Set Data=Data_$lb(CuteInfFlagID,CuteInfFlagDesc,OperInfTypeID,OperInfTypeDesc,InHospInfFlagID,InHospInfFlagDesc)
	Set Data=Data_$lb(ASAScoreID,ASAScoreDesc,DataSource)
	Set Data=Data_$lb(PreoperWBC,CuteNumberID,CuteNumberDesc)
	Set Data=Data_$lb(EndoscopeFlagID,EndoscopeFlagDesc,ImplantFlagID,ImplantFlagDesc,PreoperAntiFlagID,PreoperAntiFlagDesc)
	Set Data=Data_$lb(BloodLossFlagID,BloodLossFlagDesc,BloodLoss,BloodTransFlagID,BloodTransFlagDesc,BloodTrans,PostoperComps,PostoperCompsDesc)
	Set Data=Data_$lb(OperTimes,NNISScore)
	
	Quit Data
}

/// Creator：     zhufei
/// CreatDate：   2012-07-01
/// Description:  查询ICU监测登记表
/// Table：       DHCMed.NINF.Rep.InfReport
/// Input:        
/// do ##class(%ResultSet).RunQuery("DHCMed.NINFService.Rep.InfReport","QryICURepByDate","1","2013-01-01","2013-01-21","","","1478")
Query QryICURepByDate(aDateType As %String, aDateFrom As %String, aDateTo As %String, aRepLoc As %String, aRepStatus As %String, aRepType As %String) As %Query(ROWSPEC = "ReportID:%String,EpisodeID:%String,ObjectID:%String,ReportTypeID:%String,ReportTypeDesc:%String,ReportLocID:%String,ReportLocDesc:%String,ReportUserID:%String,ReportUserDesc:%String,ReportDate:%String,ReportTime:%String,ReportStatusID:%String,ReportStatusCode:%String,ReportStatusDesc:%String,AdmitDate:%String,DischDate:%String,AdmLoc:%String,AdmWard:%String,AdmBed:%String,PatientID:%String,PapmiNo:%String,PatName:%String,PatSex:%String,PatMrNo:%String,PatAge:%String,EncryptLevel:%String,PatLevel:%String,RecordID:%String,BornWeight:%String,IntubateTypeID:%String,IntubateTypeDesc:%String,IntubateDate:%String,IntubateTime:%String,IntubateDateTime:%String,ExtubateDate:%String,ExtubateTime:%String,ExtubateDateTime:%String,IntubatePlaceID:%String,IntubatePlaceDesc:%String,IntubateUserTypeID:%String,IntubateUserTypeDesc:%String,IntubateUserID:%String,IntubateUserDesc:%String,InfDate:%String,InfPathogenys:%String,InfPathogenysDesc:%String,PICCIntubatePosID:%String,PICCIntubatePosDesc:%String,PICCIntubateSizeID:%String,PICCIntubateSizeDesc:%String,PICCIntubateTypeID:%String,PICCIntubateTypeDesc:%String,PICCIntubateNumID:%String,PICCIntubateNumDesc:%String,PICCIntubateRegionID:%String,PICCIntubateRegionDesc:%String,PICCExtubateReasonID:%String,PICCExtubateReasonDesc:%String,UCUrineBagTypeID:%String,UCUrineBagTypeDesc:%String,VAPIntubateTypeID:%String,VAPIntubateTypeDesc:%String")
{
}

ClassMethod QryICURepByDateExecute(ByRef qHandle As %Binary, aDateType As %String, aDateFrom As %String, aDateTo As %String, aRepLoc As %String, aRepStatus As %String, aRepType As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:(aDateFrom="")||(aDateTo="")||(aDateType="") $$$OK
	;Set:aDateFrom["-" aDateFrom=$zdh(aDateFrom,3)
	;Set:aDateTo["-" aDateTo=$zdh(aDateTo,3)
	Set aDateFrom=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(aDateTo)
	
	Quit:aRepType="" $$$OK
	
	//按报告日期查询
	If aDateType=1 {
		Set xDate=aDateFrom-1
		For {
			Set xDate=$o(^DHCMed.NINFi("InfRep",0,"IndexRepDateLoc",xDate))
			Quit:xDate=""
			Quit:xDate>aDateTo
			
			Set xTime=0
			For {
				Set xTime=$o(^DHCMed.NINFi("InfRep",0,"IndexRepDateLoc",xDate,xTime))
				Quit:xTime=""
				
				Set xLoc=0
				For {
					Set xLoc=$o(^DHCMed.NINFi("InfRep",0,"IndexRepDateLoc",xDate,xTime,xLoc))
					Quit:xLoc=""
					Continue:(aRepLoc'="")&&(aRepLoc'=xLoc)
					
					Set xRepID=0
					For {
						Set xRepID=$o(^DHCMed.NINFi("InfRep",0,"IndexRepDateLoc",xDate,xTime,xLoc,xRepID))
						Quit:xRepID=""
						
						Set flg=..CheckRepDataToICU(xRepID,aRepType,aRepStatus,aRepLoc)
						Continue:flg<1
						Set RepData=..BuildRepData(xRepID)
						Continue:RepData=""
						
						Set xSubID=0
						For {
							Set xSubID=$o(^DHCMed.NINF("InfRep",xRepID,"ICU",xSubID))
							Quit:xSubID=""
							Set SubData=..BuildICUData(xRepID,xSubID)
							Continue:SubData=""
							Set ^CacheTemp(repid,ind)=RepData_SubData
							Set ind=ind+1
						}
					}
				}
			}
		}
	}
	//按入院日期查询
	If aDateType=2 {
		//^PAADMi("PAADM_AdmDate",{PAADM_AdmDate},{PAADM_RowID})
		//upadte by pylian 2016-02-18 修改入院时间索引
		Set AdmDateIndex=##Class(DHCMed.SSIO.FromAdmSrv).GetAdmDateIndex()
		For xDate=aDateFrom:1:aDateTo {
			Set xPaadm=0
			For {
				Set xPaadm=$o(^PAADMi(AdmDateIndex,xDate,xPaadm))
				Quit:xPaadm=""
				Set AdmInfo=$g(^PAADM(xPaadm))
				Continue:$p(AdmInfo,"^",2)'="I"           //就诊类型过滤
				Continue:$p(AdmInfo,"^",20)="C"           //就诊状态过滤
				
				Set xRepID=0
				For {
					Set xRepID=$o(^DHCMed.NINFi("InfRep",0,"IndexPaadm",xPaadm,xRepID))
					Quit:xRepID=""
					
					Set flg=..CheckRepDataToICU(xRepID,aRepType,aRepStatus,aRepLoc)
					Continue:flg<1
					Set RepData=..BuildRepData(xRepID)
					Continue:RepData=""
					
					Set xSubID=0
					For {
						Set xSubID=$o(^DHCMed.NINF("InfRep",xRepID,"ICU",xSubID))
						Quit:xSubID=""
						Set SubData=..BuildICUData(xRepID,xSubID)
						Continue:SubData=""
						Set ^CacheTemp(repid,ind)=RepData_SubData
						Set ind=ind+1
					}
				}
			}
		}
	}
	//按出院日期查询
	If aDateType=3 {
		//^PAADMi("DischDate",{PAADM_DischgDate},{PAADM_RowID})
		Set DischDateIndex=##Class(DHCMed.SSIO.FromAdmSrv).GetDischDateIndex()  //update by pylian 2016-01-21取出院时间索引	
		For xDate=aDateFrom:1:aDateTo {
			Set xPaadm=0
			For {
				Set xPaadm=$o(^PAADMi(DischDateIndex,xDate,xPaadm))
				Quit:xPaadm=""
				Set AdmInfo=$g(^PAADM(xPaadm))
				Continue:$p(AdmInfo,"^",2)'="I"           //就诊类型过滤
				Continue:$p(AdmInfo,"^",20)="C"           //就诊状态过滤
				
				Set xRepID=0
				For {
					Set xRepID=$o(^DHCMed.NINFi("InfRep",0,"IndexPaadm",xPaadm,xRepID))
					Quit:xRepID=""
					
					Set flg=..CheckRepDataToICU(xRepID,aRepType,aRepStatus,aRepLoc)
					Continue:flg<1
					Set RepData=..BuildRepData(xRepID)
					Continue:RepData=""
					
					Set xSubID=0
					For {
						Set xSubID=$o(^DHCMed.NINF("InfRep",xRepID,"ICU",xSubID))
						Quit:xSubID=""
						Set SubData=..BuildICUData(xRepID,xSubID)
						Continue:SubData=""
						Set ^CacheTemp(repid,ind)=RepData_SubData
						Set ind=ind+1
					}
				}
			}
		}
	}
	
	Quit $$$OK
}

ClassMethod QryICURepByDateClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryICURepByDateExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryICURepByDateFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryICURepByDateExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// 检查ICU监测报告
ClassMethod CheckRepDataToICU(aReportID As %String, aRepType As %String, aRepStatus As %String, aRepLoc As %String)
{
	New (aReportID,aRepType,aRepStatus,aRepLoc)
	Set return=0
	
	Set objReport=##class(DHCMed.NINF.Rep.InfReport).GetObjById(aReportID)
	Quit:'$IsObject(objReport) return
	
	If $IsObject(objReport.ReportType) {
		Set ReportTypeID=objReport.ReportType.%Id()
		Set ReportTypeDesc=objReport.ReportType.Description
	}
	Quit:(aRepType'="")&&(ReportTypeID'=aRepType) return
	
	If $IsObject(objReport.ReportStatus) {
		Set ReportStatusID=objReport.ReportStatus.%Id()
		Set ReportStatusCode=objReport.ReportStatus.Code
		Set ReportStatusDesc=objReport.ReportStatus.Description
	}
	Quit:(aRepStatus'="")&&(ReportStatusID'=aRepStatus) return
	
	Set ReportLoc=objReport.ReportLoc
	Set objRepLoc=##class(DHCMed.Base.Ctloc).GetObjById(ReportLoc)
	If $IsObject(objRepLoc) {
		Set ReportLocID=objRepLoc.Rowid
		Set ReportLocDesc=objRepLoc.Descs
	}
	Quit:(aRepLoc'="")&&(ReportLocID'=aRepLoc) return
	
	Set return=1
	Quit return
}

/// 取ICU监测信息
ClassMethod BuildICUData(aRepID As %String, aSubID As %String) As %List
{
	New (aRepID,aSubID)
	Set return=""
	
	Set BornWeight=""
	Set SummID=$o(^DHCMed.NINF("InfRep",aRepID,"Summ",""),-1)
	If SummID'="" {
		Set objSumm=##class(DHCMed.NINF.Rep.InfReportSumm).GetObjById(aRepID_"||"_SummID)
		If $IsObject(objSumm) {
			Set BornWeight=objSumm.BornWeight
		}
	}
	
	Set objSub=##class(DHCMed.NINF.Rep.InfReportICU).GetObjById(aRepID_"||"_aSubID)
	Quit:'$IsObject(objSub) return
	
	Set (IntubateTypeID,IntubateTypeDesc)=""
	Set (IntubateDate,IntubateTime,IntubateDateTime,ExtubateDate,ExtubateTime,ExtubateDateTime)=""
	Set (IntubatePlaceID,IntubatePlaceDesc,IntubateUserTypeID,IntubateUserTypeDesc,IntubateUserID,IntubateUserDesc)=""
	Set (InfDate,InfPathogenys,InfPathogenysDesc)=""
	Set (PICCIntubatePosID,PICCIntubatePosDesc,PICCIntubateSizeID,PICCIntubateSizeDesc,PICCIntubateTypeID,PICCIntubateTypeDesc)=""
	Set (PICCIntubateNumID,PICCIntubateNumDesc,PICCIntubateRegionID,PICCIntubateRegionDesc,PICCExtubateReasonID,PICCExtubateReasonDesc)=""
	Set (UCUrineBagTypeID,UCUrineBagTypeDesc)=""
	Set (VAPIntubateTypeID,VAPIntubateTypeDesc)=""
	
	If $IsObject(objSub.IntubateType) {
		Set IntubateTypeID=objSub.IntubateType.%Id()
		Set IntubateTypeDesc=objSub.IntubateType.Description
	}
	Set IntubateDate=objSub.IntubateDate
	Set IntubateTime=objSub.IntubateTime
	If (IntubateDate'="") {
		;Set IntubateDate=$zd(IntubateDate,3)
		Set IntubateDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(IntubateDate)
		Set IntubateTime=$zt(+IntubateTime,2)
		Set IntubateDateTime=IntubateDate_" "_IntubateTime
	}
	Set ExtubateDate=objSub.ExtubateDate
	Set ExtubateTime=objSub.ExtubateTime
	If (ExtubateDate'="") {
		;Set ExtubateDate=$zd(ExtubateDate,3)
		Set ExtubateDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(ExtubateDate)
		Set ExtubateTime=$zt(+ExtubateTime,2)
		Set ExtubateDateTime=ExtubateDate_" "_ExtubateTime
	}
	If $IsObject(objSub.IntubatePlace) {
		Set IntubatePlaceID=objSub.IntubatePlace.%Id()
		Set IntubatePlaceDesc=objSub.IntubatePlace.Description
	}
	If $IsObject(objSub.IntubateUserType) {
		Set IntubateUserTypeID=objSub.IntubateUserType.%Id()
		Set IntubateUserTypeDesc=objSub.IntubateUserType.Description
	}
	Set IntubateUser=objSub.IntubateUser
	Set objSSUser=##class(DHCMed.Base.SSUser).GetObjById(IntubateUser)
	If $IsObject(objSSUser) {
		Set IntubateUserID=objSSUser.Rowid
		Set IntubateUserDesc=objSSUser.Name
	}
	Set InfDate=objSub.InfDate
	If (InfDate'="") {
		;Set InfDate=$zd(InfDate,3)
		Set InfDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(InfDate)
	}
	For indInfPy=1:1:objSub.InfPathogeny.Count() {
		Set objInfPy=objSub.InfPathogeny.GetAt(indInfPy)
		Continue:'$IsObject(objInfPy)
		Set InfPathogenys=InfPathogenys_","_objInfPy.PathogenyID
		Set InfPathogenysDesc=InfPathogenysDesc_","_objInfPy.PathogenyDesc
	}
	Set:InfPathogenys'="" InfPathogenys=$e(InfPathogenys,2,$l(InfPathogenys))
	Set:InfPathogenysDesc'="" InfPathogenysDesc=$e(InfPathogenysDesc,2,$l(InfPathogenysDesc))
	
	If $IsObject(objSub.PICCIntubatePos) {
		Set PICCIntubatePosID=objSub.PICCIntubatePos.%Id()
		Set PICCIntubatePosDesc=objSub.PICCIntubatePos.Description
	}
	If $IsObject(objSub.PICCIntubateSize) {
		Set PICCIntubateSizeID=objSub.PICCIntubateSize.%Id()
		Set PICCIntubateSizeDesc=objSub.PICCIntubateSize.Description
	}
	If $IsObject(objSub.PICCIntubateType) {
		Set PICCIntubateTypeID=objSub.PICCIntubateType.%Id()
		Set PICCIntubateTypeDesc=objSub.PICCIntubateType.Description
	}
	If $IsObject(objSub.PICCIntubateNum) {
		Set PICCIntubateNumID=objSub.PICCIntubateNum.%Id()
		Set PICCIntubateNumDesc=objSub.PICCIntubateNum.Description
	}
	If $IsObject(objSub.PICCIntubateRegion) {
		Set PICCIntubateRegionID=objSub.PICCIntubateRegion.%Id()
		Set PICCIntubateRegionDesc=objSub.PICCIntubateRegion.Description
	}
	If $IsObject(objSub.PICCExtubateReason) {
		Set PICCExtubateReasonID=objSub.PICCExtubateReason.%Id()
		Set PICCExtubateReasonDesc=objSub.PICCExtubateReason.Description
	}
	If $IsObject(objSub.UCUrineBagType) {
		Set UCUrineBagTypeID=objSub.UCUrineBagType.%Id()
		Set UCUrineBagTypeDesc=objSub.UCUrineBagType.Description
	}
	If $IsObject(objSub.VAPIntubateType) {
		Set VAPIntubateTypeID=objSub.VAPIntubateType.%Id()
		Set VAPIntubateTypeDesc=objSub.VAPIntubateType.Description
	}
	
	Set Data=$lb(aRepID_"||"_aSubID,BornWeight,IntubateTypeID,IntubateTypeDesc)
	Set Data=Data_$lb(IntubateDate,IntubateTime,IntubateDateTime,ExtubateDate,ExtubateTime,ExtubateDateTime)
	Set Data=Data_$lb(IntubatePlaceID,IntubatePlaceDesc,IntubateUserTypeID,IntubateUserTypeDesc,IntubateUserID,IntubateUserDesc)
	Set Data=Data_$lb(InfDate,InfPathogenys,InfPathogenysDesc)
	Set Data=Data_$lb(PICCIntubatePosID,PICCIntubatePosDesc,PICCIntubateSizeID,PICCIntubateSizeDesc,PICCIntubateTypeID,PICCIntubateTypeDesc)
	Set Data=Data_$lb(PICCIntubateNumID,PICCIntubateNumDesc,PICCIntubateRegionID,PICCIntubateRegionDesc,PICCExtubateReasonID,PICCExtubateReasonDesc)
	Set Data=Data_$lb(UCUrineBagTypeID,UCUrineBagTypeDesc)
	Set Data=Data_$lb(VAPIntubateTypeID,VAPIntubateTypeDesc)
	
	Quit Data
}

/// 取报告基本信息
ClassMethod BuildRepData(aReportID As %String) As %List
{
	New (aReportID)
	Set return=""
	
	Set objReport=##class(DHCMed.NINF.Rep.InfReport).GetObjById(aReportID)
	Quit:'$IsObject(objReport) return
	
	Set (EpisodeID,ObjectID,ReportTypeID,ReportTypeDesc)=""
	Set (ReportLocID,ReportLocDesc,ReportUserID,ReportUserDesc)=""
	Set (ReportDate,ReportTime,ReportStatusID,ReportStatusCode,ReportStatusDesc)=""
	Set (AdmitDate,DischDate,AdmLoc,AdmWard,AdmBed,PatientID,PapmiNo,PatName,PatSex,PatMrNo,PatAge)=""
	Set (EncryptLevel,PatLevel)=""
	If $IsObject(objReport.ReportType) {
		Set ReportTypeID=objReport.ReportType.%Id()
		Set ReportTypeDesc=objReport.ReportType.Description
	}
	
	If $IsObject(objReport.ReportStatus) {
		Set ReportStatusID=objReport.ReportStatus.%Id()
		Set ReportStatusCode=objReport.ReportStatus.Code
		Set ReportStatusDesc=objReport.ReportStatus.Description
	}
	
	Set ReportLoc=objReport.ReportLoc
	Set objRepLoc=##class(DHCMed.Base.Ctloc).GetObjById(ReportLoc)
	If $IsObject(objRepLoc) {
		Set ReportLocID=objRepLoc.Rowid
		Set ReportLocDesc=objRepLoc.Descs
	}
	
	Set EpisodeID=objReport.EpisodeID  //就诊号
	Set objPaadm=##class(DHCMed.Base.PatientAdm).GetObjById(EpisodeID)
	Quit:'$IsObject(objPaadm)
	Set AdmitDate=objPaadm.AdmitDate
	Set AdmitTime=objPaadm.AdmitTime
	Set DischDate=objPaadm.DisDate
	Set AdmLoc=objPaadm.Department
	Set AdmWard=objPaadm.Ward
	Set AdmBed=objPaadm.Bed
	Set PatientID=objPaadm.PatientID
	Set objPatient=##class(DHCMed.Base.Patient).GetObjById(PatientID)
	Quit:'$IsObject(objPatient)
	Set PapmiNo=objPatient.PapmiNo
	Set PatName=objPatient.PatientName
	Set PatSex=objPatient.Sex
	Set PatMrNo=objPatient.InPatientMrNo
	
	//统一调用年龄计算方法
	Set PatAge=##class(DHCMed.SSIO.FromHisSrv).GetPapmiAge(PatientID,"",AdmitDate,AdmitTime)
	
	Set SecretStr=##class(DHCMed.SSIO.FromSecSrv).GetPatEncryptLevel(PatientID,.ErrMsg)
	Set:SecretStr'="" EncryptLevel=$p(SecretStr,"^",1)   //病人密级
	Set:SecretStr'="" PatLevel=$p(SecretStr,"^",2)		//病人级别
	
	Set ObjectID=objReport.ObjectID  //转科记录ID
	
	Set ReportUser=objReport.ReportUser
	Set objRepUser=##class(DHCMed.Base.SSUser).GetObjById(ReportUser)
	If $IsObject(objRepUser) {
		Set ReportUserID=objRepUser.Rowid
		Set ReportUserDesc=objRepUser.Name
	}
	Set ReportDate=objReport.ReportDate
	;Set:ReportDate'="" ReportDate=$zd(ReportDate,3)
	Set:ReportDate'="" ReportDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(ReportDate)
	Set ReportTime=objReport.ReportTime
	Set:ReportTime'="" ReportTime=$zt(ReportTime,2)
	
	Set Data=$lb(aReportID,EpisodeID,ObjectID,ReportTypeID,ReportTypeDesc)
	Set Data=Data_$lb(ReportLocID,ReportLocDesc,ReportUserID,ReportUserDesc)
	Set Data=Data_$lb(ReportDate,ReportTime,ReportStatusID,ReportStatusCode,ReportStatusDesc)
	Set Data=Data_$lb(AdmitDate,DischDate,AdmLoc,AdmWard,AdmBed,PatientID,PapmiNo,PatName,PatSex,PatMrNo,PatAge,EncryptLevel,PatLevel)
	
	Quit Data
}

/// 获取ObjectID
ClassMethod GetObjectID(aEpisodeID As %String, aRepTypeID As %String, aObjectID As %String = "") As %String
{
	New (aEpisodeID, aRepTypeID, aObjectID)
	Set return=""
	Quit:(aEpisodeID="")||(aRepTypeID="") return
	
	Set objRepType=##class(DHCMed.SS.Dictionary).GetObjById(aRepTypeID)
	Quit:'$IsObject(objRepType) return
	Set RepTypeCode=objRepType.Code
	
	If (RepTypeCode="ICU")||(RepTypeCode="NICU") {
		Set ObjectID=aObjectID   //TransID   ICU和NICU 一次转科填写一份报告
	} Else {                     //顺序号    感染报告和手术调查报告 使用顺序号
		Set ObjectID=+$o(^DHCMed.NINFi("InfRep",0,"IndexTypeAdmTrans",aRepTypeID,aEpisodeID,""),-1)
		Set ObjectID=ObjectID+1
	}
	Quit ObjectID
}

/// 检查报告是否已存在
ClassMethod GetReportID(aEpisodeID As %String, aRepTypeID As %String, aObjectID As %String) As %String
{
	New (aEpisodeID, aRepTypeID, aObjectID)
	Set return=""
	Quit:(aEpisodeID="")||(aRepTypeID="")||(aObjectID="") return
	
	Set ReportID=$o(^DHCMed.NINFi("InfRep",0,"IndexTypeAdmTrans",aRepTypeID,aEpisodeID,aObjectID,""))
	Quit ReportID
}

}
