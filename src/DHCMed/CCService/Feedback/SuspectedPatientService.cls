/// 查询疑似病例统计列表
Class DHCMed.CCService.Feedback.SuspectedPatientService Extends DHCMed.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// Do ##Class(DHCMed.CCService.Feedback.SuspectedPatientService).Test()
ClassMethod Test()
{
	d ##class(%Library.ResultSet).RunQuery("DHCMed.CCService.Feedback.SuspectedPatientService","QryWardSummaryGrpByDate","2013-04-11","2013-04-14","INTCCS","227")
	//d ##class(%Library.ResultSet).RunQuery("DHCMed.CCService.Feedback.SuspectedPatientService","QryWardSummaryGrpByWard","2013-04-11","2013-04-14","INTCCS","","0")
}

/// 查询病区摘要
/// d ##class(%Library.ResultSet).RunQuery("DHCMed.CCService.Feedback.SuspectedPatientService","QryWardSummaryGrpByDate","2013-04-27","2013-04-27","","INTCCS","","")
/// Modified By LiYang 2013-05-23增加现患数量
Query QryWardSummaryGrpByDate(FromDate As %String, ToDate As %String, WardID As %String, ViewConfigCode As %String, Status As %String, Adm48Hour As %String) As %Query(ROWSPEC = "CurrDate:%String,InPatientNumber:%Integer,SuspectNumber:%Integer,InfNumber:%Integer,CurrInfNumber:%Integer") [ SqlProc ]
{
}

ClassMethod QryWardSummaryGrpByDateExecute(ByRef qHandle As %Binary, FromDate As %String, ToDate As %String, WardID As %String, ViewConfigCode As %String, Status As %String, Adm48Hour As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Set:FromDate["/" FromDate=$zdh(FromDate,4)
	Set:ToDate["/" ToDate=$zdh(ToDate,4)
	Set:FromDate["-" FromDate=$zdh(FromDate,3)
	Set:ToDate["-" ToDate=$zdh(ToDate,3)
	Quit:(FromDate="")||(ToDate="") $$$OK
	Set FromDate=ToDate-7
	
	Set objConfig=##class(DHCMed.CC.SubjectConfig).GetObjByCode(ViewConfigCode)
	Quit:'$IsObject(objConfig) $$$OK
	Set SubjectCode=objConfig.SubjectCode
	
	Set objSubject=##class(DHCMed.CC.Subject).GetObjByCode(SubjectCode)
	Quit:'$IsObject(objSubject) $$$OK
	Set SubjectID=objSubject.%Id()
	
	Set %ZIndex=$zn,%JIndex=$j,%NIndex="QryWardSummaryGrpByDate"
	Kill ^TMP(%ZIndex,%JIndex,%NIndex)
	
	Set cnt=##class(DHCMed.CCService.Lib.Common).PrepareSubjectItem(SubjectCode,ViewConfigCode)
	
	//计算科室在院人数及取这段时期住院患者列表
	For xDate=FromDate:1:(ToDate+10) {
		Set xLocID=0
		For {
			Set xLocID=$o(^DHCMed.CC.CtlResultI("AdmTrans",0,"IndexOutDateLoc",xDate,xLocID))
			Quit:xLocID=""
			
			//过滤非病区科室
			Set xWardID=$o(^PAWARD(0,"WARD_LocationDR",xLocID,0))
			Continue:xWardID=""
			Continue:(WardID'="")&&(WardID'=xWardID)
			
			Set xPaadm=0
			For {
				Set xPaadm=$o(^DHCMed.CC.CtlResultI("AdmTrans",0,"IndexOutDateLoc",xDate,xLocID,xPaadm))
				Quit:xPaadm=""
				
				Set objAdm=##class(DHCMed.Base.PatientAdm).GetObjById(xPaadm)
				Continue:'$IsObject(objAdm)
				If objAdm'="" Do objAdm.%Close()
				If Adm48Hour=1 {
					Set AdmitDate=objAdm.AdmitDate
					Set AdmitDate=$zdh(AdmitDate,3)
					Set AdmitTime=objAdm.AdmitTime
					Set AdmitTime=$zdt(AdmitTime,1)
					Set CurrDate=+$h
					Set CurrTime=$p($h,",",2)
					Continue:(((CurrDate-AdmitDate)*24)+((CurrTime-AdmitTime)\3600))<48
				}
				
				Set xAimTransID=0
				For {
					Set xAimTransID=$o(^DHCMed.CC.CtlResultI("AdmTrans",0,"IndexOutDateLoc",xDate,xLocID,xPaadm,xAimTransID))
					Quit:xAimTransID=""
					
					Set objAimTrans=##class(DHCMed.CC.CtlAdmTrans).GetObjById(xAimTransID)
					Continue:'$IsObject(objAimTrans)
					If objAimTrans.LinkID'="" {
						Set tmpAimTransID=objAimTrans.LinkID
						Set objAimTrans=##class(DHCMed.CC.CtlAdmTrans).GetObjById(tmpAimTransID)
						Continue:'$IsObject(objAimTrans)
					} Else {
						Set tmpAimTransID=objAimTrans.%Id()
					}
					Continue:$d(^TMP(%ZIndex,%JIndex,%NIndex,"AdmTrans",tmpAimTransID))
					Set ^TMP(%ZIndex,%JIndex,%NIndex,"AdmTrans",tmpAimTransID)=""
					Set TransInDate=objAimTrans.TransInDate
					Set TransOutDate=objAimTrans.TransOutDate
					Continue:TransInDate>ToDate
					Continue:TransOutDate<FromDate
					
					//在院患者，出院、死亡算当天在院，当天入院也算
					For indDate=TransInDate:1:TransOutDate
					{
						Continue:indDate<FromDate
						Quit:indDate>ToDate
						Set num=$i(^TMP(%ZIndex,%JIndex,%NIndex,"Data",indDate,"InHospPat"))
					}
				}
			}
		}
	}
	
	For xDate=FromDate:1:ToDate {
		Set SummaryID=""
		For	{
			Set SummaryID=$o(^DHCMed.CC.CtlResultI("Summary","IndexSubjectRecDate",xDate,SubjectID,SummaryID))
			Quit:SummaryID=""
			
			Set objSumm=##class(DHCMed.CC.CtlSummary).GetObjById(SummaryID)
			Continue:'$IsObject(objSumm)
			Continue:((objSumm.Status'=Status)&&(Status'="")) //过滤状态
			Continue:(objSumm.LnkSummaryID'="")&&(objSumm.LnkSummaryID'=SummaryID)  //过滤重复记录	
			Set xPaadm=objSumm.EpisodeID
			Continue:xPaadm=""
			Set xWardID=$p($g(^PAADM(xPaadm)),"^",70)
			Continue:(WardID'="")&&(WardID'=xWardID)
			
			Set objAdm=##class(DHCMed.Base.PatientAdm).GetObjById(xPaadm)
			Continue:'$IsObject(objAdm)
			If objAdm'="" Do objAdm.%Close()
			Continue:((objAdm.Status="D")||(objAdm.Status="C"))
			If Adm48Hour=1 {
				Set AdmitDate=objAdm.AdmitDate
				Set AdmitDate=$zdh(AdmitDate,3)
				Set AdmitTime=objAdm.AdmitTime
				Set AdmitTime=$zdt(AdmitTime,1)
				Set CurrDate=+$h
				Set CurrTime=$p($h,",",2)
				Continue:(((CurrDate-AdmitDate)*24)+((CurrTime-AdmitTime)\3600))<48
			}
			
			//计算确诊病例数量
			If '$d(^TMP(%ZIndex,%JIndex,%NIndex,"InfAdmList",xPaadm))
			{
				Set ^TMP(%ZIndex,%JIndex,%NIndex,"InfAdmList",xPaadm)=""
				Set arryINFRep=##class(DHCMed.NINF.Srv.InfReport).GetInfRepByAdm(xPaadm)
				Set Cnt=arryINFRep.Count()
				For i=1:1:Cnt {
					Set objRep=arryINFRep.GetAt(i)
					Set ReportDate=objRep.ReportDate
					Continue:ReportDate=""
					Set RepDate=$zdh(objRep.ReportDate,3)
					Set num=$i(^TMP(%ZIndex,%JIndex,%NIndex,"Data",RepDate,"InfPat"))
				}
			}
			
			//计算现患人数 Add By LiYang 2013-05-24
			Set IsCurrInf=##class(DHCMed.NINF.Srv.InfReport).IsCurrentInfection(xPaadm,FromDate,xDate)
			Set:IsCurrInf>0 ^TMP(%ZIndex,%JIndex,%NIndex,"Data",xDate,"CurrInfPat",xPaadm)=""
			
			
			If '$d(^TMP(%ZIndex,%JIndex,%NIndex,"SummAdmList",xPaadm,xDate))
			{
				Set ^TMP(%ZIndex,%JIndex,%NIndex,"SummAdmList",xPaadm,xDate)=""
				Set FeedBackID="",Flag=0
				For {
					Set FeedBackID=$o(^DHCMed.CC.CtlResultI("CtlFeedback",xPaadm,SubjectID))
					Quit:FeedBackID=""
				
					Set objFeed=##class(DHCMed.CC.CtlFeedback).GetObjById(FeedBackID)
					Continue:'$IsObject(objFeed)
					Continue:objFeed.ReceiveDate<xDate  //日期在监控日期之前
					Set:objFeed.Status=2 Flag=1         //医师拒绝
				}
				Continue:((objSumm.Status=1)&&(Flag=1)) //已通知医师并且医师拒绝
				
				Set ResultID="",Fired=0
				For {
					Set ResultID=$o(^DHCMed.CC.CtlResultI("Detail","IndexSubjectEpisodeActDate",objSumm.ActDate,xPaadm,SubjectID,ResultID))
					Quit:ResultID=""
				
					Set objResult=##class(DHCMed.CC.CtlResult).GetObjById(ResultID)
					Continue:'$IsObject(objResult)
					Continue:$d(^TMP(%ZIndex,%JIndex,%NIndex,"SubjectItem",objResult.ItemId))=0
					Set Fired=1
				}
				Continue:Fired=0 //没有显示配置中要求的触发项目
				
				Set num=$i(^TMP(%ZIndex,%JIndex,%NIndex,"Data",xDate,"SummPat"))
			}
		}
	}
	
	For xDate=FromDate:1:ToDate
	{
		Set InHospPat=+$g(^TMP(%ZIndex,%JIndex,%NIndex,"Data",xDate,"InHospPat"))  //在院患者
		Set SummPat=+$g(^TMP(%ZIndex,%JIndex,%NIndex,"Data",xDate,"SummPat"))      //疑似病例
		Set InfPat=+$g(^TMP(%ZIndex,%JIndex,%NIndex,"Data",xDate,"InfPat"))        //确诊病例
		
		Set CurrInfPat=0        //现患病例 Add By LiYang 2013-05-24
		Set xPaadm=""
		Set Cnt=0
		For {
			Set xPaadm=$o(^TMP(%ZIndex,%JIndex,%NIndex,"Data",xDate,"CurrInfPat",xPaadm))
			Quit:xPaadm=""
			Set Cnt=Cnt+1
		}
		;b:Cnt>0
		Set CurrInfPat=Cnt
		
		Set tmpDate=$zd(xDate,3)
		Set tmpDate=$e(tmpDate,6,$l(tmpDate))
		Set Data=$lb(tmpDate,InHospPat,SummPat,InfPat,CurrInfPat)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	Kill ^TMP(%ZIndex,%JIndex,%NIndex)
	
	Quit $$$OK
}

ClassMethod QryWardSummaryGrpByDateClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryWardSummaryGrpByDateExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryWardSummaryGrpByDateFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryWardSummaryGrpByDateExecute ]
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

/// 查询病区摘要(按病房分组)
/// d ##class(%Library.ResultSet).RunQuery("DHCMed.CCService.Feedback.SuspectedPatientService","QryWardSummaryGrpByWard","2013-04-27","2013-04-28","INTCCS","","")
/// Modified By LiYang 增加现患人数
Query QryWardSummaryGrpByWard(FromDate As %String, ToDate As %String, WardID As %String, ViewConfigCode As %String, Status As %String, Adm48Hour As %String) As %Query(ROWSPEC = "WardID:%String,WardDesc:%String,InPatientNumber:%Integer,SuspectNumber:%Integer,InfNumber:%Integer,CurrNumber:%Integer") [ SqlProc ]
{
}

ClassMethod QryWardSummaryGrpByWardExecute(ByRef qHandle As %Binary, FromDate As %String, ToDate As %String, WardID As %String, ViewConfigCode As %String, Status As %String, Adm48Hour As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Set:FromDate["/" FromDate=$zdh(FromDate,4)
	Set:ToDate["/" ToDate=$zdh(ToDate,4)
	Set:FromDate["-" FromDate=$zdh(FromDate,3)
	Set:ToDate["-" ToDate=$zdh(ToDate,3)
	Quit:(FromDate="")||(ToDate="") $$$OK
	
	Set objConfig=##class(DHCMed.CC.SubjectConfig).GetObjByCode(ViewConfigCode)
	Quit:'$IsObject(objConfig) $$$OK
	Set SubjectCode=objConfig.SubjectCode
	
	Set objSubject=##class(DHCMed.CC.Subject).GetObjByCode(SubjectCode)
	Quit:'$IsObject(objSubject) $$$OK
	Set SubjectID=objSubject.%Id()
	
	Set %ZIndex=$zn,%JIndex=$j,%NIndex="QryWardSummaryGrpByWard"
	Kill ^TMP(%ZIndex,%JIndex,%NIndex)
	
	Set cnt=##class(DHCMed.CCService.Lib.Common).PrepareSubjectItem(SubjectCode,ViewConfigCode)
	
	//计算科室在院人数
	For xDate=FromDate:1:(ToDate+10) {
		Set xLocID=0
		For {
			Set xLocID=$o(^DHCMed.CC.CtlResultI("AdmTrans",0,"IndexOutDateLoc",xDate,xLocID))
			Quit:xLocID=""
			
			//过滤非病区科室
			Set xWardID=$o(^PAWARD(0,"WARD_LocationDR",xLocID,0))
			Continue:xWardID=""
			Continue:(WardID'="")&&(WardID'=xWardID)
			
			Set xPaadm=0
			For {
				Set xPaadm=$o(^DHCMed.CC.CtlResultI("AdmTrans",0,"IndexOutDateLoc",xDate,xLocID,xPaadm))
				Quit:xPaadm=""
				
				Set objAdm=##class(DHCMed.Base.PatientAdm).GetObjById(xPaadm)
				Continue:'$IsObject(objAdm)
				If objAdm'="" Do objAdm.%Close()
				If Adm48Hour=1 {
					Set AdmitDate=objAdm.AdmitDate
					Set AdmitDate=$zdh(AdmitDate,3)
					Set AdmitTime=objAdm.AdmitTime
					Set AdmitTime=$zdt(AdmitTime,1)
					Set CurrDate=+$h
					Set CurrTime=$p($h,",",2)
					Continue:(((CurrDate-AdmitDate)*24)+((CurrTime-AdmitTime)\3600))<48
				}
				
				Set xAimTransID=0
				For {
					Set xAimTransID=$o(^DHCMed.CC.CtlResultI("AdmTrans",0,"IndexOutDateLoc",xDate,xLocID,xPaadm,xAimTransID))
					Quit:xAimTransID=""
					
					Set objAimTrans=##class(DHCMed.CC.CtlAdmTrans).GetObjById(xAimTransID)
					Continue:'$IsObject(objAimTrans)
					If objAimTrans.LinkID'="" {
						Set tmpAimTransID=objAimTrans.LinkID
						Set objAimTrans=##class(DHCMed.CC.CtlAdmTrans).GetObjById(tmpAimTransID)
						Continue:'$IsObject(objAimTrans)
					} Else {
						Set tmpAimTransID=objAimTrans.%Id()
					}
					Continue:$d(^TMP(%ZIndex,%JIndex,%NIndex,"AdmTrans",tmpAimTransID))
					Set ^TMP(%ZIndex,%JIndex,%NIndex,"AdmTrans",tmpAimTransID)=""
					Set TransInDate=objAimTrans.TransInDate
					Set TransOutDate=objAimTrans.TransOutDate
					Continue:TransInDate>ToDate
					Continue:TransOutDate<FromDate
					
					Continue:$d(^TMP(%ZIndex,%JIndex,%NIndex,"Data",xWardID,"InHospPat",xPaadm))
					Set num=$i(^TMP(%ZIndex,%JIndex,%NIndex,"Data",xWardID,"InHospPat"))
					Set ^TMP(%ZIndex,%JIndex,%NIndex,"Data",xWardID,"InHospPat",xPaadm)=""
				}
			}
		}
	}
	
	For xDate=FromDate:1:ToDate {
		Set SummaryID=""
		For	{
			Set SummaryID=$o(^DHCMed.CC.CtlResultI("Summary","IndexSubjectRecDate",xDate,SubjectID,SummaryID))
			Quit:SummaryID=""
			
			Set objSumm=##class(DHCMed.CC.CtlSummary).GetObjById(SummaryID)
			Continue:'$IsObject(objSumm)
			Continue:((objSumm.Status'=Status)&&(Status'="")) //过滤状态
			Continue:(objSumm.LnkSummaryID'="")&&(objSumm.LnkSummaryID'=SummaryID)  //过滤重复记录	
			Set xPaadm=objSumm.EpisodeID
			Continue:xPaadm=""
			Set xWardID=$p($g(^PAADM(xPaadm)),"^",70)
			Continue:xWardID=""
			Continue:(WardID'="")&&(WardID'=xWardID)
			
			Set objAdm=##class(DHCMed.Base.PatientAdm).GetObjById(xPaadm)
			Continue:'$IsObject(objAdm)
			If objAdm'="" Do objAdm.%Close()
			Continue:((objAdm.Status="D")||(objAdm.Status="C"))
			If Adm48Hour=1 {
				Set AdmitDate=objAdm.AdmitDate
				Set AdmitDate=$zdh(AdmitDate,3)
				Set AdmitTime=objAdm.AdmitTime
				Set AdmitTime=$zdt(AdmitTime,1)
				Set CurrDate=+$h
				Set CurrTime=$p($h,",",2)
				Continue:(((CurrDate-AdmitDate)*24)+((CurrTime-AdmitTime)\3600))<48
			}
			
			//计算确诊病例数量
			If '$d(^TMP(%ZIndex,%JIndex,%NIndex,"InfAdmList",xPaadm))
			{
				Set ^TMP(%ZIndex,%JIndex,%NIndex,"InfAdmList",xPaadm)=""
				Set arryINFRep=##class(DHCMed.NINF.Srv.InfReport).GetInfRepByAdm(xPaadm)
				Set Cnt=arryINFRep.Count()
				For i=1:1:Cnt {
					Set objRep=arryINFRep.GetAt(i)
					Set ReportDate=objRep.ReportDate
					Continue:ReportDate=""
					Set RepDate=$zdh(objRep.ReportDate,3)
					Set num=$i(^TMP(%ZIndex,%JIndex,%NIndex,"Data",xWardID,"InfPat"))
				}
			}
			
			//计算现患人数 Add By LiYang 2013-05-23
			Set IsCurrInf=##class(DHCMed.NINF.Srv.InfReport).IsCurrentInfection(xPaadm,FromDate,ToDate)
			Set:IsCurrInf>0 ^TMP(%ZIndex,%JIndex,%NIndex,"Data",xWardID,"CurrInfPat",xPaadm)=""
			
			
			If '$d(^TMP(%ZIndex,%JIndex,%NIndex,"SummAdmList",xPaadm,xWardID))
			{
				Set ^TMP(%ZIndex,%JIndex,%NIndex,"SummAdmList",xPaadm,xWardID)=""
				Set FeedBackID="",Flag=0
				For {
					Set FeedBackID=$o(^DHCMed.CC.CtlResultI("CtlFeedback",xPaadm,SubjectID))
					Quit:FeedBackID=""
				
					Set objFeed=##class(DHCMed.CC.CtlFeedback).GetObjById(FeedBackID)
					Continue:'$IsObject(objFeed)
					Continue:objFeed.ReceiveDate<xDate  //日期在监控日期之前
					Set:objFeed.Status=2 Flag=1         //医师拒绝
				}
				Continue:((objSumm.Status=1)&&(Flag=1)) //已通知医师并且医师拒绝
				
				Set ResultID="",Fired=0
				For {
					Set ResultID=$o(^DHCMed.CC.CtlResultI("Detail","IndexSubjectEpisodeActDate",objSumm.ActDate,xPaadm,SubjectID,ResultID))
					Quit:ResultID=""
				
					Set objResult=##class(DHCMed.CC.CtlResult).GetObjById(ResultID)
					Continue:'$IsObject(objResult)
					Continue:$d(^TMP(%ZIndex,%JIndex,%NIndex,"SubjectItem",objResult.ItemId))=0
					Set Fired=1
				}
				Continue:Fired=0 //没有显示配置中要求的触发项目
				
				Set num=$i(^TMP(%ZIndex,%JIndex,%NIndex,"Data",xWardID,"SummPat"))
			}
		}
	}
	
	
	Set xWardID=0
	For {
		Set xWardID=$o(^TMP(%ZIndex,%JIndex,%NIndex,"Data",xWardID))
		Quit:xWardID=""
		
		Set InHospPat=+$g(^TMP(%ZIndex,%JIndex,%NIndex,"Data",xWardID,"InHospPat"))  //在院患者
		Set SummPat=+$g(^TMP(%ZIndex,%JIndex,%NIndex,"Data",xWardID,"SummPat"))      //疑似病例
		Set InfPat=+$g(^TMP(%ZIndex,%JIndex,%NIndex,"Data",xWardID,"InfPat"))        //确诊病例
		Set CurrInfPat=0        //现患病例 Add By LiYang 2013-05-24
		Set xPaadm=""
		Set Cnt=0
		For {
			Set xPaadm=$o(^TMP(%ZIndex,%JIndex,%NIndex,"Data",xWardID,"CurrInfPat",xPaadm))
			Quit:xPaadm=""
			Set Cnt=Cnt+1
		}
		;b:Cnt>0
		Set CurrInfPat=Cnt
		Continue:(SummPat=0)&&(InfPat=0)
		
		Set xWardDesc=$p($g(^PAWARD(xWardID)),"^",2)
		Set:$p(xWardDesc,"-",2)'="" xWardDesc=$p(xWardDesc,"-",2)
		Set:xWardDesc="" xWardDesc="其它"
		
		Set Data=$lb(xWardID,xWardDesc,InHospPat,SummPat,InfPat,CurrInfPat) //Modified By LiYang 2013-05-24   现患病例 
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	Kill ^TMP(%ZIndex,%JIndex,%NIndex)
	
	Quit $$$OK
}

ClassMethod QryWardSummaryGrpByWardClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryWardSummaryGrpByWardExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryWardSummaryGrpByWardFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryWardSummaryGrpByWardExecute ]
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

/// d ##class(%Library.ResultSet).RunQuery("DHCMed.CCService.Feedback.SuspectedPatientService","QryNumberByDate","2013-04-27","2013-04-27",1,"10","INTCCS")
Query QryNumberByDate(FromDate As %String, ToDate As %String, WardID As %String, ViewConfigCode As %String, Status As %String, Adm48Hour As %String) As %Query(ROWSPEC = "CurrDate:%String,Code:%String,Title:%String,Number:%Integer,WardID:%String,WardDesc:%String") [ SqlProc ]
{
}

ClassMethod QryNumberByDateExecute(ByRef qHandle As %Binary, FromDate As %String, ToDate As %String, WardID As %String, ViewConfigCode As %String, Status As %String, Adm48Hour As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Set:FromDate["/" FromDate=$zdh(FromDate,4)
	Set:ToDate["/" ToDate=$zdh(ToDate,4)
	Set:FromDate["-" FromDate=$zdh(FromDate,3)
	Set:ToDate["-" ToDate=$zdh(ToDate,3)
	Quit:(FromDate="")||(ToDate="") $$$OK
	Set FromDate=ToDate-7
	
	Set objConfig=##class(DHCMed.CC.SubjectConfig).GetObjByCode(ViewConfigCode)
	Quit:'$IsObject(objConfig) $$$OK
	Set SubjectCode=objConfig.SubjectCode
	
	Set objSubject=##class(DHCMed.CC.Subject).GetObjByCode(SubjectCode)
	Quit:'$IsObject(objSubject) $$$OK
	Set SubjectID=objSubject.%Id()
	
	Set %ZIndex=$zn,%JIndex=$j,%NIndex="QryNumberByDate"
	Kill ^TMP(%ZIndex,%JIndex,%NIndex)
	
	Set cnt=##class(DHCMed.CCService.Lib.Common).PrepareSubjectItem(SubjectID,ViewConfigCode)
	
	For xDate=FromDate:1:ToDate {
		Set SummaryID=""
		For	{
			Set SummaryID=$o(^DHCMed.CC.CtlResultI("Summary","IndexSubjectRecDate",xDate,SubjectID,SummaryID))
			Quit:SummaryID=""
			
			Set objSumm=##class(DHCMed.CC.CtlSummary).GetObjById(SummaryID)
			Continue:'$IsObject(objSumm)
			Continue:((objSumm.Status'=Status)&&(Status'="")) //过滤状态
			Continue:(objSumm.LnkSummaryID'="")&&(objSumm.LnkSummaryID'=SummaryID)  //过滤重复记录	
			Set xPaadm=objSumm.EpisodeID
			Continue:xPaadm=""
			Set xWardID=$p($g(^PAADM(xPaadm)),"^",70)
			Continue:(WardID'="")&&(WardID'=xWardID)
			
			Set objAdm=##class(DHCMed.Base.PatientAdm).GetObjById(xPaadm)
			Continue:'$IsObject(objAdm)
			If objAdm'="" Do objAdm.%Close()
			Continue:((objAdm.Status="D")||(objAdm.Status="C"))
			If Adm48Hour=1 {
				Set AdmitDate=objAdm.AdmitDate
				Set AdmitDate=$zdh(AdmitDate,3)
				Set AdmitTime=objAdm.AdmitTime
				Set AdmitTime=$zdt(AdmitTime,1)
				Set CurrDate=+$h
				Set CurrTime=$p($h,",",2)
				Continue:(((CurrDate-AdmitDate)*24)+((CurrTime-AdmitTime)\3600))<48
			}
			
			Set ResultID=""
			For {
				Set ResultID=$o(^DHCMed.CC.CtlResultI("Detail","IndexSubjectEpisodeActDate",objSumm.ActDate,xPaadm,SubjectID,ResultID))
				Quit:ResultID=""
				
				Set objResult=##class(DHCMed.CC.CtlResult).GetObjById(ResultID)
				Continue:'$IsObject(objResult)
				Continue:'$d(^TMP(%ZIndex,%JIndex,%NIndex,"SubjectItem",objResult.ItemId))
				Set SubCatID=$g(^TMP(%ZIndex,%JIndex,%NIndex,"SubjectItem",objResult.ItemId))
				Continue:$d(^TMP(%ZIndex,%JIndex,%NIndex,"Data",xWardID,xDate,"SubCat",SubCatID,xPaadm))
				Set num=$i(^TMP(%ZIndex,%JIndex,%NIndex,"Data",xWardID,xDate,"SubCat",SubCatID))
				Set ^TMP(%ZIndex,%JIndex,%NIndex,"Data",xWardID,xDate,"SubCat",SubCatID,xPaadm)=""
			}
		}
	}
	
	Set xWardID=0
	For {
		Set xWardID=$o(^TMP(%ZIndex,%JIndex,%NIndex,"Data",xWardID))
		Quit:xWardID=""
		
		Set xWardDesc=$p($g(^PAWARD(xWardID)),"^",2)
		Set:$p(xWardDesc,"-",2)'="" xWardDesc=$p(xWardDesc,"-",2)
		Set:xWardDesc="" xWardDesc="其它"
		
		Set xDate=0
		For {
			Set xDate=$o(^TMP(%ZIndex,%JIndex,%NIndex,"Data",xWardID,xDate))
			Quit:xDate=""
			
			Set tmpDate=$zd(xDate,3)
			Set tmpDate=$e(tmpDate,6,$l(tmpDate))
			
			Set xSubCatID=""
			For {
				Set xSubCatID=$o(^TMP(%ZIndex,%JIndex,%NIndex,"Data",xWardID,xDate,"SubCat",xSubCatID))
				Quit:xSubCatID=""
				
				Set objSubCat=##class(DHCMed.CC.ItemSubCat).GetObjById(xSubCatID)
				Continue:'$IsObject(objSubCat)
				Set ISCCode=objSubCat.ISCCode
				Set ISCDesc=objSubCat.ISCDesc
				Set SubCatCnt=+$g(^TMP(%ZIndex,%JIndex,%NIndex,"Data",xWardID,xDate,"SubCat",SubCatID))
				
				Set Data=$lb(tmpDate,ISCCode,ISCDesc,SubCatCnt,xWardID,xWardDesc)
				Set ^CacheTemp(repid,ind)=Data
				Set ind=ind+1
			}
		}
	}
	Kill ^TMP(%ZIndex,%JIndex,%NIndex)
	
	Quit $$$OK
}

ClassMethod QryNumberByDateClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryNumberByDateExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryNumberByDateFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryNumberByDateExecute ]
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

/// do ##class(%Library.ResultSet).RunQuery("DHCMed.CCService.Feedback.SuspectedPatientService","QryNumberByWard","2013-04-27","2013-04-28",1,"","INTCCS")
Query QryNumberByWard(FromDate As %String, ToDate As %String, WardID As %String, ViewConfigCode As %String, Status As %String, Adm48Hour As %String) As %Query(ROWSPEC = "Code:%String,Title:%String,Number:%Integer,WardID:%String,WardDesc:%String") [ SqlProc ]
{
}

ClassMethod QryNumberByWardExecute(ByRef qHandle As %Binary, FromDate As %String, ToDate As %String, WardID As %String, ViewConfigCode As %String, Status As %String, Adm48Hour As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Set:FromDate["/" FromDate=$zdh(FromDate,4)
	Set:ToDate["/" ToDate=$zdh(ToDate,4)
	Set:FromDate["-" FromDate=$zdh(FromDate,3)
	Set:ToDate["-" ToDate=$zdh(ToDate,3)
	Quit:(FromDate="")||(ToDate="") $$$OK
	
	Set objConfig=##class(DHCMed.CC.SubjectConfig).GetObjByCode(ViewConfigCode)
	Quit:'$IsObject(objConfig) $$$OK
	Set SubjectCode=objConfig.SubjectCode
	
	Set objSubject=##class(DHCMed.CC.Subject).GetObjByCode(SubjectCode)
	Quit:'$IsObject(objSubject) $$$OK
	Set SubjectID=objSubject.%Id()
	
	Set %ZIndex=$zn,%JIndex=$j,%NIndex="QryNumberByWard"
	Kill ^TMP(%ZIndex,%JIndex,%NIndex)
	
	Set cnt=##class(DHCMed.CCService.Lib.Common).PrepareSubjectItem(SubjectID,ViewConfigCode)
	
	For xDate=FromDate:1:ToDate {
		Set SummaryID=""
		For	{
			Set SummaryID=$o(^DHCMed.CC.CtlResultI("Summary","IndexSubjectRecDate",xDate,SubjectID,SummaryID))
			Quit:SummaryID=""
			
			Set objSumm=##class(DHCMed.CC.CtlSummary).GetObjById(SummaryID)
			Continue:'$IsObject(objSumm)
			Continue:((objSumm.Status'=Status)&&(Status'="")) //过滤状态
			Continue:(objSumm.LnkSummaryID'="")&&(objSumm.LnkSummaryID'=SummaryID)  //过滤重复记录	
			Set xPaadm=objSumm.EpisodeID
			Continue:xPaadm=""
			Set xWardID=$p($g(^PAADM(xPaadm)),"^",70)
			Continue:(WardID'="")&&(WardID'=xWardID)
			
			Set objAdm=##class(DHCMed.Base.PatientAdm).GetObjById(xPaadm)
			Continue:'$IsObject(objAdm)
			If objAdm'="" Do objAdm.%Close()
			Continue:((objAdm.Status="D")||(objAdm.Status="C"))
			If Adm48Hour=1 {
				Set AdmitDate=objAdm.AdmitDate
				Set AdmitDate=$zdh(AdmitDate,3)
				Set AdmitTime=objAdm.AdmitTime
				Set AdmitTime=$zdt(AdmitTime,1)
				Set CurrDate=+$h
				Set CurrTime=$p($h,",",2)
				Continue:(((CurrDate-AdmitDate)*24)+((CurrTime-AdmitTime)\3600))<48
			}
			
			Set ResultID=""
			For {
				Set ResultID=$o(^DHCMed.CC.CtlResultI("Detail","IndexSubjectEpisodeActDate",objSumm.ActDate,xPaadm,SubjectID,ResultID))
				Quit:ResultID=""
				
				Set objResult=##class(DHCMed.CC.CtlResult).GetObjById(ResultID)
				Continue:'$IsObject(objResult)
				Continue:'$d(^TMP(%ZIndex,%JIndex,%NIndex,"SubjectItem",objResult.ItemId))
				Set SubCatID=$g(^TMP(%ZIndex,%JIndex,%NIndex,"SubjectItem",objResult.ItemId))
				Continue:$d(^TMP(%ZIndex,%JIndex,%NIndex,"Data",xWardID,"SubCat",SubCatID,xPaadm))
				Set num=$i(^TMP(%ZIndex,%JIndex,%NIndex,"Data",xWardID,"SubCat",SubCatID))
				Set ^TMP(%ZIndex,%JIndex,%NIndex,"Data",xWardID,"SubCat",SubCatID,xPaadm)=""
			}
		}
	}
	
	Set xWardID=0
	For {
		Set xWardID=$o(^TMP(%ZIndex,%JIndex,%NIndex,"Data",xWardID))
		Quit:xWardID=""
		
		Set xWardDesc=$p($g(^PAWARD(xWardID)),"^",2)
		Set:$p(xWardDesc,"-",2)'="" xWardDesc=$p(xWardDesc,"-",2)
		Set:xWardDesc="" xWardDesc="其它"
		
		Set xSubCatID=""
		For {
			Set xSubCatID=$o(^TMP(%ZIndex,%JIndex,%NIndex,"Data",xWardID,"SubCat",xSubCatID))
			Quit:xSubCatID=""
			
			Set objSubCat=##class(DHCMed.CC.ItemSubCat).GetObjById(xSubCatID)
			Continue:'$IsObject(objSubCat)
			Set ISCCode=objSubCat.ISCCode
			Set ISCDesc=objSubCat.ISCDesc
			Set SubCatCnt=+$g(^TMP(%ZIndex,%JIndex,%NIndex,"Data",xWardID,"SubCat",SubCatID))
			
			Set Data=$lb(ISCCode,ISCDesc,SubCatCnt,xWardID,xWardDesc)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
	}
	Kill ^TMP(%ZIndex,%JIndex,%NIndex)
	
	Quit $$$OK
}

ClassMethod QryNumberByWardClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryNumberByWardExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryNumberByWardFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryNumberByWardExecute ]
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

}
