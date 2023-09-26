Class DHCMed.CCService.Warning.WarningControl Extends DHCMed.Abstract [ Not ProcedureBlock ]
{

/*
ClassMethod Init(SubjectCode As %String, GermKeywordCode As %String, TempKeywordCode As %String)
{
	n (SubjectCode)
	Set objSubject=##class(DHCMed.CC.Subject).GetObjByCode(SubjectCode)
	Quit:$IsObject(objSubject)=0 -1
	Set ControlDate=$o(^DHCMed.CC.CtlResultI("Detail","IndexActDateEpisodeID",""),-1)+1
	Set GermRepid=##class(DHCMed.CCService.Warning.Lib.LisLib).GetHasGermEpisodeID(ControlDate,ControlDate)
	Set Paadm=""
	//Set GermKeywordCode=""
	Set GermSubCateCode=""
	//Set TempKeywordCode=""
	Set TempSubCateCode=""
	For {
		Set Paadm=$o(^CacheTemp(GermRepid,Paadm))
		Quit:Paadm=""
		Set ret=##class(DHCMed.CCService.AutoProcess.CoreVM).Process(objSubject.%Id(),ControlDate,ControlDate,Paadm,GermSubCateCode,GermKeyWordCode)
	}
	Set ret=##class(DHCMed.CCService.AutoProcess.CoreVM).Process(objSubject.%Id(),ControlDate,ControlDate,"",GermSubCateCode,GermKeyWordCode)
	Set ret=##class(DHCMed.CCService.AutoProcess.CoreVM).Process(objSubject.%Id(),ControlDate,ControlDate,"",TempSubCateCode,TempKeywordCode)
	Quit 1
}
*/
/// 获取最后被排除的日期，在此之前的结果全部忽略
ClassMethod GetLastRejectDate(EpisodeID, SubjectID)
{
	n (EpisodeID,SubjectID)
	Set ret=0
	Set flag=0
	Set tmpDate=""
	For {
		Set tmpDate=$o(^DHCMed.CC.CtlResultI("Summary","IndexEpisodeSubjectActDate",EpisodeID,SubjectID,tmpDate),-1)
		Quit:tmpDate=""
		Set ret=tmpDate
		Set SummaryID=""
		For {
			Set SummaryID=$o(^DHCMed.CC.CtlResultI("Summary","IndexEpisodeSubjectActDate",EpisodeID,SubjectID,tmpDate,SummaryID))
			Quit:SummaryID=""
			Set objSum=##class(DHCMed.CC.CtlSummary).GetObjById(SummaryID)
			Do objSum.%Close()
			If ((objSum.Status=9)&&(objSum.TotalScore>0)) {
				Set flag=1
				Set ret=tmpDate
			}
		}
		Quit:flag=1
	}
	//w EpisodeID_"----"_tmpDate,!
	Quit ret
}

/// 查询细菌信息
ClassMethod QueryGermData(repid, FromDate, ToDate, SubjectCode, KeywordCode)
{
	n (repid,FromDate,ToDate,KeywordCode,SubjectCode)
	Set objSubject=##class(DHCMed.CC.Subject).GetObjByCode(SubjectCode)
	Quit:$IsObject(objSubject)=0 -1
	Set MinGermKindCnt=+$g(MinGermKindCnt)
	Do objSubject.%Close()
	Set SubjectID=objSubject.%Id()
	Set KeywordID=##class(DHCMed.CC.KeyWord).GetIDByCode(KeywordCode)
	For tmpDate=FromDate:1:ToDate {
		Set ResultID=""
		For {
			Set ResultID=$o(^DHCMed.CC.CtlResultI("Detail","IndexSubjectKeyword",SubjectID,KeywordID,tmpDate,ResultID))
			Quit:ResultID=""
			Set objResult=##class(DHCMed.CC.CtlResult).GetObjById(ResultID)
			Continue:$IsObject(objResult)=0
			Do objResult.%Close()
			Continue:objResult.ActDate'>..GetLastRejectDate(objResult.EpisodeID,SubjectID) //忽略在排除日期之前的记录
			Set tmpData=##class(DHCMed.CCService.Lib.CommonLis).GetBugList(objResult.ObjectID)
			Continue:tmpData=""
			//个人培养出细菌种类
			Set GermCnt=$l(tmpData,$c(1))
			Set ^CacheTemp(repid,"Index","GermCnt","EpisodeID",objResult.EpisodeID)=GermCnt
			For i=1:1:GermCnt {
				Continue:$p(tmpData,$c(1),i)=""
				Set ^CacheTemp(repid,"Index","GermCnt","EpisodeID",objResult.EpisodeID,$p(tmpData,$c(1),i))=""
			}
			//科室培养出细菌人数
			Set objAdm=##class(DHCMed.Base.PatientAdm).GetObjById(objResult.EpisodeID)
			Do objAdm.%Close()
			Set ^CacheTemp(repid,"Index","DepGerm",+objAdm.DepartmentID,objResult.EpisodeID)=""
			Set ^CacheTemp(repid,"Index","EpisodeKeywordActDate",objResult.EpisodeID,KeywordCode,objResult.ActDate)=""
			//科室培养出细菌种类数
			For i=1:1:$l(tmpData,$c(1)) {
				Set tmp=$p(tmpData,$c(1),i)
				Continue:tmp=""
				Set ^CacheTemp(repid,"Index","DepGermKind",+objAdm.DepartmentID,tmp,objResult.EpisodeID)=""
			}
		}
	}
	
	Set DepID=""
	For {
		Set DepID=$o(^CacheTemp(repid,"Index","DepGerm",DepID))
		Quit:DepID=""
		Set EpisodeID=""
		For {
			Set EpisodeID=$o(^CacheTemp(repid,"Index","DepGerm",DepID,EpisodeID))
			Quit:EpisodeID=""
			Set Cnt=$g(^CacheTemp(repid,"Index","DepGerm",DepID))
			Set Cnt=Cnt+1
			Set ^CacheTemp(repid,"Index","DepGerm",DepID)=Cnt			
		}
	}	
	Set DepID=""
	For {
		Set DepID=$o(^CacheTemp(repid,"Index","DepGermKind",DepID))
		Quit:DepID=""
		Set Germ=""
		For {
			Set Germ=$o(^CacheTemp(repid,"Index","DepGermKind",DepID,Germ))
			Quit:Germ=""
			//计算【科室病原体种类】数量
			Set Cnt=$g(^CacheTemp(repid,"Index","DepGermKind",DepID))
			Set Cnt=Cnt+1
			Set ^CacheTemp(repid,"Index","DepGermKind",DepID)=Cnt	
			//计算【科室感染 某病原体的患者数量】		
			Set EpisodeID=""
			For {
				Set EpisodeID=$o(^CacheTemp(repid,"Index","DepGermKind",DepID,Germ,EpisodeID))
				Quit:EpisodeID=""
				Set Cnt=$g(^CacheTemp(repid,"Index","DepGermKind",DepID,Germ))
				Set Cnt=Cnt+1
				Set ^CacheTemp(repid,"Index","DepGermKind",DepID,Germ)=Cnt
			}
		}
	}		
	
	
	Quit "OK"
}

/// 查询体温信息
ClassMethod QueryTemperatureData(repid, FromDate, ToDate, SubjectCode, KeywordCode)
{
	n (repid,FromDate,ToDate,KeywordCode,SubjectCode)
	Set objSubject=##class(DHCMed.CC.Subject).GetObjByCode(SubjectCode)
	Quit:$IsObject(objSubject)=0 -1
	Do objSubject.%Close()
	Set SubjectID=objSubject.%Id()
	Set KeywordID=##class(DHCMed.CC.KeyWord).GetIDByCode(KeywordCode)
	For tmpDate=FromDate:1:ToDate {
		Set ResultID=""
		For {
			Set ResultID=$o(^DHCMed.CC.CtlResultI("Detail","IndexSubjectKeyword",SubjectID,KeywordID,tmpDate,ResultID))
			Quit:ResultID=""
			Set objResult=##class(DHCMed.CC.CtlResult).GetObjById(ResultID)
			Do objResult.%Close()
			Continue:objResult.ActDate'>..GetLastRejectDate(objResult.EpisodeID,SubjectID) //忽略在排除日期之前的记录
			Set objAdm=##class(DHCMed.Base.PatientAdm).GetObjById(objResult.EpisodeID)	
			Do objAdm.%Close()
			Set ^CacheTemp(repid,"Index","PersonalTemp",objResult.EpisodeID)=""
			Set ^CacheTemp(repid,"Index","DepTemp",+objAdm.DepartmentID,objResult.EpisodeID)=""
			Set ^CacheTemp(repid,"Index","EpisodeKeywordActDate",objResult.EpisodeID,KeywordCode,objResult.ActDate)=""
		}
	}
	Set DepID=""
	For {
		Set DepID=$o(^CacheTemp(repid,"Index","DepTemp",DepID))
		Quit:DepID=""
		Set EpisodeID=""
		For {
			Set EpisodeID=$o(^CacheTemp(repid,"Index","DepTemp",DepID,EpisodeID))
			Quit:EpisodeID=""
			Set Cnt=$g(^CacheTemp(repid,"Index","DepTemp",DepID))
			Set Cnt=Cnt+1
			Set ^CacheTemp(repid,"Index","DepTemp",DepID)=Cnt			
		}
	}
	
	Quit "OK"
}

Query QryWarnPatient(FromDate As %String, ToDate As %String, SubjectCode As %String, Args As %String, Ctolc As %String) As %Query(ROWSPEC = "EpisodeID:%String,PatientID:%String,PatNo:%String,PatientName:%String,Sex:%String,Age:%String,AdmitDate:%String,Department:%String,Ward:%String,Diagnose:%String,Doctor:%String,SummaryID:%String")
{
}

ClassMethod QryWarnPatientExecute(ByRef qHandle As %Binary, FromDate As %String, ToDate As %String, SubjectCode As %String, Args As %String, Ctloc As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)	
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)	
	Set:FromDate["/" FromDate=$zdh(FromDate,4)
	Set:FromDate["-" FromDate=$zdh(FromDate,3)
	Set:ToDate["/" ToDate=$zdh(ToDate,4)
	Set:ToDate["-" ToDate=$zdh(ToDate,3)
	Quit:Ctloc="" $$$OK
	Set objSubject=##class(DHCMed.CC.Subject).GetObjByCode(SubjectCode)
	Quit:$IsObject(objSubject)=0 $$$OK
	For i=1:1:$l(Args,$c(1)) {
		Set tmpArg=$p(Args,$c(1),i)
		Continue:tmpArg=""
		Set Code=$p(tmpArg,"^",1)
		Set Keyword=$p(tmpArg,"^",2)
		Set MinNum=$p(tmpArg,"^",3)
		
		//个人细菌类别 或者 同科室检出微生物者
		if (Code="PersonalGermKind") { 
			Set tmp=..QueryGermData(repid,FromDate,ToDate,SubjectCode,Keyword)
			Set Cnt=0
			Set EpisodeID=""
			For {
				Set EpisodeID=$o(^CacheTemp(repid,"Index","GermCnt","EpisodeID",EpisodeID))
				Quit:EpisodeID=""
				Set Cnt=$g(^CacheTemp(repid,"Index","GermCnt","EpisodeID",EpisodeID))
				Continue:(Cnt'>MinNum)
				Set objAdm=##class(DHCMed.Base.PatientAdm).GetObjById(EpisodeID)
				Do objAdm.%Close()
				Continue:((objAdm.DepartmentID'=Ctloc)&&(Ctloc'=""))
				Set data=$$BuildData(EpisodeID)
				Set ^CacheTemp(repid,ind)=data
				Set ind=ind+1
			}
			Kill ^CacheTemp(repid,"Index")
		}
		if (Code="DepGermCnt") {
			Set tmp=..QueryGermData(repid,FromDate,ToDate,SubjectCode,Keyword)
			Set Cnt=0
			Set EpisodeID=""
			For {
				Set EpisodeID=$o(^CacheTemp(repid,"Index","GermCnt","EpisodeID",EpisodeID))
				Quit:EpisodeID=""
				Set Cnt=$g(^CacheTemp(repid,"Index","GermCnt","EpisodeID",EpisodeID))
				Set objAdm=##class(DHCMed.Base.PatientAdm).GetObjById(EpisodeID)
				Continue:((objAdm.DepartmentID'=Ctloc)&&(Ctloc'=""))
				Set data=$$BuildData(EpisodeID)
				Set ^CacheTemp(repid,ind)=data
				Set ind=ind+1
			}
			Kill ^CacheTemp(repid,"Index")			
		}
		If (Code="DepTemp") { //查询科室体温异常者
			Set tmp=..QueryTemperatureData(repid,FromDate,ToDate,SubjectCode,Keyword)
			Set EpisodeID=""
			For {
				Set EpisodeID=$o(^CacheTemp(repid,"Index","PersonalTemp",EpisodeID))
				Quit:EpisodeID=""
				Set objAdm=##class(DHCMed.Base.PatientAdm).GetObjById(EpisodeID)
				Continue:((objAdm.DepartmentID'=Ctloc)&&(Ctloc'=""))				
				Set data=$$BuildData(EpisodeID)
				Set ^CacheTemp(repid,ind)=data
				Set ind=ind+1				 
			}
			Kill ^CacheTemp(repid,"Index")
		}
		IF (Code="DepGermKind") { //查询科室感染病原体数量
			Set tmp=..QueryGermData(repid,FromDate,ToDate,SubjectCode,Keyword)
			Set Cnt=0
			Set Germ=""
			For {
				Set Germ=$o(^CacheTemp(repid,"Index","DepGermKind",Ctloc,Germ))
				Quit:Germ=""
				Set Cnt=$g(^CacheTemp(repid,"Index","DepGermKind",Ctloc,Germ))
				//w Cnt,!
				Continue:(Cnt'>MinNum)
				Set EpisodeID=""
				For {
					Set EpisodeID=$o(^CacheTemp(repid,"Index","DepGermKind",Ctloc,Germ,EpisodeID))
					Quit:EpisodeID=""
					Set ^CacheTemp(repid,"Index","tmp","DepGermKind",EpisodeID)=""
				}
			}
			Set EpisodeID=""
			For {
				Set EpisodeID=$o(^CacheTemp(repid,"Index","tmp","DepGermKind",EpisodeID))
				Quit:EpisodeID=""
				Set objAdm=##class(DHCMed.Base.PatientAdm).GetObjById(EpisodeID)
				Set data=$$BuildData(EpisodeID)
				Set ^CacheTemp(repid,ind)=data
				Set ind=ind+1
				//w EpisodeID,!
			}			
			Kill ^CacheTemp(repid,"Index")	
		}		
	}
	
	Quit $$$OK
	
	

BuildData(EpisodeID)
	n (EpisodeID,objSubject,Keyword,repid)
	//Diagnose:%String,Doctor:%String
	Set data=$lb("")
	Set objAdm=##class(DHCMed.Base.PatientAdm).GetObjById(EpisodeID)
	Do objAdm.%Close()
	Set objPatient=##class(DHCMed.Base.Patient).GetObjById(objAdm.PatientID)
	Do objPatient.%Close()
	Set $li(data,1)=EpisodeID	//EpisodeID:%String
	Set $li(data,2)=objPatient.Papmi //PatientID:%String
	Set $li(data,3)=objPatient.PapmiNo //PatNo:%String
	Set $li(data,4)=objPatient.PatientName //PatientName:%String
	Set $li(data,5)=objPatient.Sex //Sex:%String
	Set $li(data,6)=objPatient.Age //Age:%String
	Set $li(data,7)=objAdm.AdmitDate //AdmitDate:%String
	Set $li(data,8)=objAdm.Department //Department:%String,
	Set:$li(data,8)["-" $li(data,8)=$p($li(data,8),"-",2)
	Set $li(data,9)=objAdm.Ward //Ward:%String,
	Set:$li(data,9)["-" $li(data,9)=$p($li(data,9),"-",2)
	Set Diagnose=##class(DHCMed.Base.MRDiagnose).GetByPaadm(EpisodeID)
	Set Diagnose=$p(Diagnose,$c(1),1)
	Set $li(data,10)=$p(Diagnose,..#SEPARATE,14) //Diagnose:%String	
	Set $li(data,11)=objAdm.DoctorName //Doctor:%String
	Set $li(data,12)=""
	Set ActDate=$o(^CacheTemp(repid,"Index","EpisodeKeywordActDate",EpisodeID,Keyword,""),-1)
	Set:ActDate'="" $li(data,12)=$o(^DHCMed.CC.CtlResultI("Summary","IndexEpisodeSubjectActDate",EpisodeID,objSubject.%Id(),ActDate,""))
	Quit data
}

ClassMethod QryWarnPatientClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryWarnPatientExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryWarnPatientFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryWarnPatientExecute ]
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

ClassMethod Test()
{
	//w ##class(DHCMed.CCService.Warning.WarningControl).Test()
	Set SubjectCode="INTCC"
	Set arg="DepGermKind^Bacteria^1" //DepTemp^OutOfTemperature^1"_$c(1)_"DepGermCnt^Bacteria^1"_$c(1)_"PersonalGermKind^Bacteria^1"
	Set FromDate="2008-1-1"
	Set ToDate="2012-12-31"
	Do ##class(%Library.ResultSet).RunQuery("DHCMed.CCService.Warning.WarningControl","QueryDepWarning",FromDate,ToDate,SubjectCode,arg)
	w "--------------",!
	Do ##class(%Library.ResultSet).RunQuery("DHCMed.CCService.Warning.WarningControl","QryWarnPatient",FromDate,ToDate,SubjectCode,arg,1)
	Quit "OK"
}

Query QueryDepWarning(FromDate As %String, ToDate As %String, SubjectCode As %String, Args As %String) As %Query(ROWSPEC = "Ctloc:%String,Department:%String,Count:%Integer,TypeCode:%String,Keyword:%String,TypeDesc:%String,MinNum:%String")
{
}

ClassMethod QueryDepWarningExecute(ByRef qHandle As %Binary, FromDate As %String, ToDate As %String, SubjectCode As %String, Args As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)	
	Set:FromDate["/" FromDate=$zdh(FromDate,4)
	Set:FromDate["-" FromDate=$zdh(FromDate,3)
	Set:ToDate["/" ToDate=$zdh(ToDate,4)
	Set:ToDate["-" ToDate=$zdh(ToDate,3)
	Set objSubject=##class(DHCMed.CC.Subject).GetObjByCode(SubjectCode)
	Quit:$IsObject(objSubject)=0 $$$OK
	
	For i=1:1:$l(Args,$c(1)) {
		Set tmpArg=$p(Args,$c(1),i)
		Continue:tmpArg=""
		Set Code=$p(tmpArg,"^",1)
		Set Keyword=$p(tmpArg,"^",2)
		Set MinNum=$p(tmpArg,"^",3)
		if ($d(^DHCMed.CC.CtlResultI("Summary","IndexSubjectRecDate",+$h,objSubject.%Id()))=0) //检测是否当日已经进行过监控，如果没有，则进行监控（仅监控某些关键字的）
		{
			//Set ret=##class(DHCMed.CCService.AutoProcess.CoreVM).Process(objSubject.%Id(),+$h,+$h,"","",Keyword)
		}
		//个人细菌类别
		if (Code="PersonalGermKind") { 
			Set tmp=..QueryGermData(repid,FromDate,ToDate,SubjectCode,Keyword)
			Set Cnt=0
			Set EpisodeID=""
			For {
				Set EpisodeID=$o(^CacheTemp(repid,"Index","GermCnt","EpisodeID",EpisodeID))
				Quit:EpisodeID=""
				Set Cnt=$g(^CacheTemp(repid,"Index","GermCnt","EpisodeID",EpisodeID))
				Continue:(Cnt'>MinNum)
				Set objAdm=##class(DHCMed.Base.PatientAdm).GetObjById(EpisodeID)
				set tmp=$g(^CacheTemp(repid,"Index","PersonalGermKindDepCnt",objAdm.DepartmentID))
				Set tmp=tmp+1
				Set ^CacheTemp(repid,"Index","PersonalGermKindDepCnt",objAdm.DepartmentID)=tmp
			}
			Set DepID=""
			For {
				Set DepID=$o(^CacheTemp(repid,"Index","PersonalGermKindDepCnt",DepID))
				Quit:DepID=""
				Set Cnt=$g(^CacheTemp(repid,"Index","PersonalGermKindDepCnt",DepID))
				
				Set data=$lb("")
				Set $li(data,1)=DepID
				Set objCtloc=##class(DHCMed.Base.Ctloc).GetObjById(DepID)
				Set $li(data,2)=objCtloc.Descs
				Set $li(data,3)=Cnt
				Set $li(data,4)="PersonalGermKind"
				Set $li(data,5)=Keyword
				Set $li(data,6)="单次就诊病原体培养细菌种类>"_MinNum_"种："_Cnt_"人"
				Set $li(data,7)=MinNum
				Set ^CacheTemp(repid,ind)=data
				Set ind=ind+1
			}
			Kill ^CacheTemp(repid,"Index")
		}
		if (Code="DepGermCnt") { //同科室检出微生物者>
			Set tmp=..QueryGermData(repid,FromDate,ToDate,SubjectCode,Keyword)
			Set DepID=""
			For {
				Set DepID=$o(^CacheTemp(repid,"Index","DepGerm",DepID))
				Quit:DepID=""
				Set Cnt=$g(^CacheTemp(repid,"Index","DepGerm",DepID))
				Continue:(Cnt'>MinNum)
				Set data=$lb("")
				Set $li(data,1)=DepID
				Set objCtloc=##class(DHCMed.Base.Ctloc).GetObjById(DepID)
				Set $li(data,2)=objCtloc.Descs
				Set $li(data,3)=Cnt
				Set $li(data,4)="DepGermCnt"
				Set $li(data,5)=Keyword
				Set $li(data,6)="同科室检出微生物者："_Cnt_"人"
				Set $li(data,7)=MinNum
				Set ^CacheTemp(repid,ind)=data
				Set ind=ind+1
			}
			Kill ^CacheTemp(repid,"Index")
		}
		If (Code="DepTemp") { //查询科室体温异常者
			Set tmp=..QueryTemperatureData(repid,FromDate,ToDate,SubjectCode,Keyword)
			Set DepID=""
			For {
				Set DepID=$o(^CacheTemp(repid,"Index","DepTemp",DepID))
				Quit:DepID=""
				Set Cnt=$g(^CacheTemp(repid,"Index","DepTemp",DepID))
				Continue:Cnt<MinNum
				Set data=$lb("")
				Set $li(data,1)=DepID
				Set objCtloc=##class(DHCMed.Base.Ctloc).GetObjById(DepID)
				Set $li(data,2)=objCtloc.Descs
				Set $li(data,3)=Cnt
				Set $li(data,4)="DepTemp"
				Set $li(data,5)=Keyword
				Set $li(data,6)="科室在院患者体温异常者："_Cnt_"人"
				Set $li(data,7)=MinNum
				Set ^CacheTemp(repid,ind)=data
				Set ind=ind+1					
			}
			Kill ^CacheTemp(repid,"Index")
		}
		IF (Code="DepGermKind") { //查询科室同时感染病某种原体的人员数量
			Set tmp=..QueryGermData(repid,FromDate,ToDate,SubjectCode,Keyword)
			Set DepID=""
			For {
				Set DepID=$o(^CacheTemp(repid,"Index","DepGermKind",DepID))
				Quit:DepID=""
				Set Germ=""
				Set KindCnt=0
				Set GermStr=""
				For {
					Set Germ=$o(^CacheTemp(repid,"Index","DepGermKind",DepID,Germ))
					Quit:Germ=""
					Set Cnt=$g(^CacheTemp(repid,"Index","DepGermKind",DepID,Germ))
					Continue:(Cnt'>MinNum)
					Set:GermStr'="" GermStr=GermStr_","
					Set GermStr=GermStr_$p(Germ,"^",2)_"："_Cnt_"人"
					Set KindCnt=KindCnt+1
				}
				Continue:KindCnt=0
				Set data=$lb("")
				Set $li(data,1)=DepID
				Set objCtloc=##class(DHCMed.Base.Ctloc).GetObjById(DepID)
				Set $li(data,2)=objCtloc.Descs
				Set $li(data,3)=KindCnt
				Set $li(data,4)="DepGermKind"
				Set $li(data,5)=Keyword
				Set $li(data,6)="同科室检出微生物类别："_GermStr
				Set $li(data,7)=MinNum
				Set ^CacheTemp(repid,ind)=data
				Set ind=ind+1				
			}
			Kill ^CacheTemp(repid,"Index")			
		}
	}
	Quit $$$OK
}

ClassMethod QueryDepWarningClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryDepWarningExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QueryDepWarningFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryDepWarningExecute ]
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

/// 通过EpisodeID，Keyword查询监控结果
/// do ##class(%Library.ResultSet).RunQuery("DHCMed.CCService.Warning.WarningControl","QryCtlResultByEpisode","2008-1-1","2012-12-31",223,"INTCC","Bacteria")
Query QryCtlResultByEpisode(FromDate As %String, ToDate As %String, EpisodeID As %String, SubjectID As %String, Keyword As %String) As %Query(ROWSPEC = "RowID:%String,ActDate:%String,ActTime:%String,Summary:%String,UserName:%String,ObjectID:%String")
{
}

ClassMethod QryCtlResultByEpisodeExecute(ByRef qHandle As %Binary, FromDate As %String, ToDate As %String, EpisodeID As %String, SubjectID As %String, Keyword As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)	
	Quit:SubjectID="" $$$OK
	Set:FromDate["/" FromDate=$zdh(FromDate,4)
	Set:FromDate["-" FromDate=$zdh(FromDate,3)
	Set:ToDate["/" ToDate=$zdh(ToDate,4)
	Set:ToDate["-" ToDate=$zdh(ToDate,3)

	Set arryResult=##class(DHCMed.CCService.Feedback.ResultService).GetCtlResultListByKeyword(EpisodeID,SubjectID,Keyword)
	Set Cnt=arryResult.Count()
	For i=1:1:Cnt {
		Set objResult=arryResult.GetAt(i)
		Continue:objResult.ActDate<FromDate
		Continue:objResult.ActDate>ToDate
		Set data=$lb("")
		Set $li(data,1)=objResult.%Id() //RowID:%String,
		Set $li(data,2)=$zd(objResult.ActDate,3) //ActDate:%String,
		Set $li(data,3)=$zt(objResult.ActTime,1) //ActTime:%String,
		Set $li(data,4)=objResult.Summary //Summary:%String,
		Set objUser=##class(DHCMed.Base.SSUser).GetObjById(objResult.UserID)
		Set:$IsObject(objUser)=0 objUser=##class(DHCMed.Base.SSUser).%New()
		Do objUser.%Close()
		Set $li(data,5)=objUser.Name  //UserName:%String,
		Set $li(data,6)=objResult.ObjectID //ObjectID:%String
		Set ^CacheTemp(repid,ind)=data
		Set ind=ind+1
	}
	Quit $$$OK
}

ClassMethod QryCtlResultByEpisodeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryCtlResultByEpisodeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryCtlResultByEpisodeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryCtlResultByEpisodeExecute ]
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
