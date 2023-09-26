Class DHCMed.CCService.Feedback.WarnService Extends DHCMed.Abstract [ ClassType = "", Not ProcedureBlock ]
{

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
ClassMethod QueryGermData(FromDate, ToDate, SubjectCode, KeywordCode, GroupType)
{
	New (FromDate,ToDate,KeywordCode,SubjectCode,GroupType,%ZIndex,%JIndex,%NIndex)
	Set return=-1
	
	Set objSubject=##class(DHCMed.CC.Subject).GetObjByCode(SubjectCode)
	Quit:'$IsObject(objSubject) return
	Set SubjectID=objSubject.%Id()
	
	Set MinGermKindCnt=+$g(MinGermKindCnt)
	Set KeywordCode=$ZConvert(KeywordCode,"U")
	Set KeywordID=##class(DHCMed.CC.KeyWord).GetIDByCode(KeywordCode)
	Quit:KeywordID="" return

	For tmpDate=FromDate:1:ToDate {
		Set ResultID=""
		For {
			Set ResultID=$o(^DHCMed.CC.CtlResultI("Detail","IndexSubjectKeyword",SubjectID,KeywordID,tmpDate,ResultID))
			Quit:ResultID=""
			
			Set objResult=##class(DHCMed.CC.CtlResult).GetObjById(ResultID)
			Continue:'$IsObject(objResult)
			//忽略在排除日期之前的记录
			Continue:objResult.ActDate'>..GetLastRejectDate(objResult.EpisodeID,SubjectID)
			Set tmpData=##class(DHCMed.CCService.Lib.CommonLis).GetBugList(objResult.ObjectID)
			Continue:tmpData=""
			
			//个人培养出细菌种类
			Set GermCnt=$l(tmpData,$c(1))
			Set ^TMP(%ZIndex,%JIndex,%NIndex,"Index","GermCnt","EpisodeID",objResult.EpisodeID)=GermCnt
			Set ^TMP(%ZIndex,%JIndex,%NIndex,"Index","GermCnt","EpisodeID",objResult.EpisodeID,"ResultID",ResultID)=""
			For i=1:1:GermCnt {
				Continue:$p(tmpData,$c(1),i)=""
				Set ^TMP(%ZIndex,%JIndex,%NIndex,"Index","GermCnt","EpisodeID",objResult.EpisodeID,$p(tmpData,$c(1),i))=""
			}
			
			//科室培养出细菌人数
			Set objAdm=##class(DHCMed.Base.PatientAdm).GetObjById(objResult.EpisodeID)
			Do objAdm.%Close()
			Set ^TMP(%ZIndex,%JIndex,%NIndex,"Index","DepGerm",+objAdm.DepartmentID,objResult.EpisodeID)=""
			Set ^TMP(%ZIndex,%JIndex,%NIndex,"Index","WardGerm",+objAdm.WardID,objResult.EpisodeID)=""
			Set ^TMP(%ZIndex,%JIndex,%NIndex,"Index","EpisodeKeywordActDate",objResult.EpisodeID,KeywordCode,objResult.ActDate)=""
			
			//科室培养出细菌种类数
			For i=1:1:$l(tmpData,$c(1)) {
				Set tmp=$p(tmpData,$c(1),i)
				Continue:tmp=""
				Set ^TMP(%ZIndex,%JIndex,%NIndex,"Index","DepGermKind",+objAdm.DepartmentID,tmp,objResult.EpisodeID)=""
				Set ^TMP(%ZIndex,%JIndex,%NIndex,"Index","WardGermKind",+objAdm.WardID,tmp,objResult.EpisodeID)=""
			}
		}
	}
	
	Set Index="DepGerm"
	Set:GroupType=2 Index="WardGerm"
	
	Set DepID=""
	For {
		Set DepID=$o(^TMP(%ZIndex,%JIndex,%NIndex,"Index",Index,DepID))
		Quit:DepID=""
		Set EpisodeID=""
		For {
			Set EpisodeID=$o(^TMP(%ZIndex,%JIndex,%NIndex,"Index",Index,DepID,EpisodeID))
			Quit:EpisodeID=""
			Set Cnt=$g(^TMP(%ZIndex,%JIndex,%NIndex,"Index",Index,DepID))
			Set Cnt=Cnt+1
			Set ^TMP(%ZIndex,%JIndex,%NIndex,"Index",Index,DepID)=Cnt			
		}
	}	
	Set Index="DepGermKind"
	Set:GroupType=2 Index="WardGermKind"	
	
	Set DepID=""
	For {
		Set DepID=$o(^TMP(%ZIndex,%JIndex,%NIndex,"Index",Index,DepID))
		Quit:DepID=""
		Set Germ=""
		For {
			Set Germ=$o(^TMP(%ZIndex,%JIndex,%NIndex,"Index",Index,DepID,Germ))
			Quit:Germ=""
			
			//计算【科室病原体种类】数量
			Set Cnt=$g(^TMP(%ZIndex,%JIndex,%NIndex,"Index",Index,DepID))
			Set Cnt=Cnt+1
			Set ^TMP(%ZIndex,%JIndex,%NIndex,"Index",Index,DepID)=Cnt
				
			//计算【科室感染 某病原体的患者数量】		
			Set EpisodeID=""
			For {
				Set EpisodeID=$o(^TMP(%ZIndex,%JIndex,%NIndex,"Index",Index,DepID,Germ,EpisodeID))
				Quit:EpisodeID=""
				Set Cnt=$g(^TMP(%ZIndex,%JIndex,%NIndex,"Index",Index,DepID,Germ))
				Set Cnt=Cnt+1
				Set ^TMP(%ZIndex,%JIndex,%NIndex,"Index",Index,DepID,Germ)=Cnt
			}
		}
	}
	
	Quit "OK"
}

/// 查询体温信息
ClassMethod QueryTemperatureData(FromDate, ToDate, SubjectCode, KeywordCode, GroupType)
{
	New (FromDate,ToDate,KeywordCode,SubjectCode,GroupType,%ZIndex,%JIndex,%NIndex)
	Set return=-1
	
	Set objSubject=##class(DHCMed.CC.Subject).GetObjByCode(SubjectCode)
	Quit:'$IsObject(objSubject) return
	Set SubjectID=objSubject.%Id()
	
	Set KeywordCode=$ZConvert(KeywordCode,"U")
	Set KeywordID=##class(DHCMed.CC.KeyWord).GetIDByCode(KeywordCode)
	Quit:KeywordID="" return

	For tmpDate=FromDate:1:ToDate {
		Set ResultID=""
		For {
			Set ResultID=$o(^DHCMed.CC.CtlResultI("Detail","IndexSubjectKeyword",SubjectID,KeywordID,tmpDate,ResultID))
			Quit:ResultID=""
			
			Set objResult=##class(DHCMed.CC.CtlResult).GetObjById(ResultID)
			Continue:objResult.ActDate'>..GetLastRejectDate(objResult.EpisodeID,SubjectID) //忽略在排除日期之前的记录
			Set objAdm=##class(DHCMed.Base.PatientAdm).GetObjById(objResult.EpisodeID)	
			Do objAdm.%Close()
			Set ^TMP(%ZIndex,%JIndex,%NIndex,"Index","PersonalTemp",objResult.EpisodeID)=""
			Set ^TMP(%ZIndex,%JIndex,%NIndex,"Index","PersonalTemp",objResult.EpisodeID,"ResultID",ResultID)=""
			Set ^TMP(%ZIndex,%JIndex,%NIndex,"Index","DepTemp",+objAdm.DepartmentID,objResult.EpisodeID)=""
			Set ^TMP(%ZIndex,%JIndex,%NIndex,"Index","WardTemp",+objAdm.WardID,objResult.EpisodeID)=""
			Set ^TMP(%ZIndex,%JIndex,%NIndex,"Index","EpisodeKeywordActDate",objResult.EpisodeID,KeywordCode,objResult.ActDate)=""
		}
	}
	
	Set Index="DepTemp"
	Set:GroupType=2 Index="WardTemp"
	Set DepID=""
	For {
		Set DepID=$o(^TMP(%ZIndex,%JIndex,%NIndex,"Index",Index,DepID))
		Quit:DepID=""
		
		Set EpisodeID=""
		For {
			Set EpisodeID=$o(^TMP(%ZIndex,%JIndex,%NIndex,"Index",Index,DepID,EpisodeID))
			Quit:EpisodeID=""
			Set Cnt=$g(^TMP(%ZIndex,%JIndex,%NIndex,"Index",Index,DepID))
			Set Cnt=Cnt+1
			Set ^TMP(%ZIndex,%JIndex,%NIndex,"Index",Index,DepID)=Cnt		
		}
	}
	
	Quit "OK"
}

Query QryWarnPatient(FromDate As %String, ToDate As %String, SubjectID As %String, Args As %String, Ctolc As %String, WardID As %String) As %Query(ROWSPEC = "EpisodeID:%String,PatientID:%String,PatNo:%String,PatientName:%String,Sex:%String,Age:%String,AdmitDate:%String,Department:%String,Ward:%String,Diagnose:%String,Doctor:%String,SummaryID:%String,LnkSummaryIDs:%String,DepID:%String,WardID:%String")
{
}

ClassMethod QryWarnPatientExecute(ByRef qHandle As %Binary, FromDate As %String, ToDate As %String, SubjectID As %String, Args As %String, Ctloc As %String, WardID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Set:FromDate["/" FromDate=$zdh(FromDate,4)
	Set:FromDate["-" FromDate=$zdh(FromDate,3)
	Set:ToDate["/" ToDate=$zdh(ToDate,4)
	Set:ToDate["-" ToDate=$zdh(ToDate,3)
	Quit:((Ctloc="")&&(WardID="")) $$$OK
	
	Set objSubject=##class(DHCMed.CC.Subject).GetObjById(SubjectID)
	Quit:'$IsObject(objSubject) $$$OK
	Set SubjectCode=objSubject.Code
	
	Set %ZIndex=$zn,%JIndex=$j,%NIndex="QryWarnPatient"
	Kill ^TMP(%ZIndex,%JIndex,%NIndex)
	
	Set GroupType=2
	For i=1:1:$l(Args,$c(1)) {
		Set tmpArg=$p(Args,$c(1),i)
		Continue:tmpArg=""
		Set Code=$p(tmpArg,"^",1)
		Set Keyword=$p(tmpArg,"^",2)
		Set MinNum=$p(tmpArg,"^",3)
		
		//个人细菌类别 或者 同科室检出微生物者
		If (Code="PersonalGermKind") { 
			Set tmp=..QueryGermData(FromDate,ToDate,SubjectCode,Keyword,GroupType)
			Set EpisodeID="",Cnt=0
			For {
				Set EpisodeID=$o(^TMP(%ZIndex,%JIndex,%NIndex,"Index","GermCnt","EpisodeID",EpisodeID))
				Quit:EpisodeID=""
				
				Set Cnt=$g(^TMP(%ZIndex,%JIndex,%NIndex,"Index","GermCnt","EpisodeID",EpisodeID))
				Continue:(Cnt'>MinNum)
				Set objAdm=##class(DHCMed.Base.PatientAdm).GetObjById(EpisodeID)
				Do objAdm.%Close()
				Continue:((objAdm.DepartmentID'=Ctloc)&&(Ctloc'=""))
				Continue:((objAdm.WardID'=WardID)&&(WardID'=""))
				
				Set ResultID=$o(^TMP(%ZIndex,%JIndex,%NIndex,"Index","GermCnt","EpisodeID",EpisodeID,"ResultID",""),-1)
				Set data=$$BuildData(EpisodeID,ResultID)
				Set num=$i(^TMP(%ZIndex,%JIndex,%NIndex,"Data"))
				Set ^TMP(%ZIndex,%JIndex,%NIndex,"Data",num)=data
			}
			Kill ^TMP(%ZIndex,%JIndex,%NIndex,"Index")
		}
		
		If (Code="DepGermCnt") {
			Set tmp=..QueryGermData(FromDate,ToDate,SubjectCode,Keyword,GroupType)
			Set EpisodeID="",Cnt=0
			For {
				Set EpisodeID=$o(^TMP(%ZIndex,%JIndex,%NIndex,"Index","GermCnt","EpisodeID",EpisodeID))
				Quit:EpisodeID=""
				
				Set Cnt=$g(^TMP(%ZIndex,%JIndex,%NIndex,"Index","GermCnt","EpisodeID",EpisodeID))
				Set objAdm=##class(DHCMed.Base.PatientAdm).GetObjById(EpisodeID)
				Continue:((objAdm.DepartmentID'=Ctloc)&&(Ctloc'=""))
				Continue:((objAdm.WardID'=WardID)&&(WardID'=""))
				
				Set ResultID=$o(^TMP(%ZIndex,%JIndex,%NIndex,"Index","GermCnt","EpisodeID",EpisodeID,"ResultID",""),-1)
				Set data=$$BuildData(EpisodeID,ResultID)
				Set num=$i(^TMP(%ZIndex,%JIndex,%NIndex,"Data"))
				Set ^TMP(%ZIndex,%JIndex,%NIndex,"Data",num)=data
			}
			Kill ^TMP(%ZIndex,%JIndex,%NIndex,"Index")
		}
		
		If (Code="DepTemp") { //查询科室体温异常者
			Set tmp=..QueryTemperatureData(FromDate,ToDate,SubjectCode,Keyword,GroupType)
			Set EpisodeID=""
			For {
				Set EpisodeID=$o(^TMP(%ZIndex,%JIndex,%NIndex,"Index","PersonalTemp",EpisodeID))
				Quit:EpisodeID=""
				
				Set objAdm=##class(DHCMed.Base.PatientAdm).GetObjById(EpisodeID)
				Continue:((objAdm.DepartmentID'=Ctloc)&&(Ctloc'=""))	
				Continue:((objAdm.WardID'=WardID)&&(WardID'=""))	
				
				Set ResultID=$o(^TMP(%ZIndex,%JIndex,%NIndex,"Index","PersonalTemp",EpisodeID,"ResultID",""),-1)
				Set data=$$BuildData(EpisodeID,ResultID)
				Set num=$i(^TMP(%ZIndex,%JIndex,%NIndex,"Data"))
				Set ^TMP(%ZIndex,%JIndex,%NIndex,"Data",num)=data			 
			}
			Kill ^TMP(%ZIndex,%JIndex,%NIndex,"Index")
		}
		
		Set DepID=Ctloc
		Set:DepID="" DepID=WardID
		IF (Code="DepGermKind") { //查询科室感染病原体数量
			Set tmp=..QueryGermData(FromDate,ToDate,SubjectCode,Keyword,GroupType)
			Set Germ="",Cnt=0
			For {
				Set Germ=$o(^TMP(%ZIndex,%JIndex,%NIndex,"Index","WardGermKind",DepID,Germ))
				Quit:Germ=""
				
				Set Cnt=$g(^TMP(%ZIndex,%JIndex,%NIndex,"Index","WardGermKind",DepID,Germ))
				Continue:(Cnt'>MinNum)
				
				Set EpisodeID=""
				For {
					Set EpisodeID=$o(^TMP(%ZIndex,%JIndex,%NIndex,"Index","WardGermKind",DepID,Germ,EpisodeID))
					Quit:EpisodeID=""
					Set ^TMP(%ZIndex,%JIndex,%NIndex,"Index","tmp","WardGermKind",EpisodeID)=""
				}
			}
			Set EpisodeID=""
			For {
				Set EpisodeID=$o(^TMP(%ZIndex,%JIndex,%NIndex,"Index","tmp","WardGermKind",EpisodeID))
				Quit:EpisodeID=""
				
				Set objAdm=##class(DHCMed.Base.PatientAdm).GetObjById(EpisodeID)
				Set data=$$BuildData(EpisodeID)
				Set num=$i(^TMP(%ZIndex,%JIndex,%NIndex,"Data"))
				Set ^TMP(%ZIndex,%JIndex,%NIndex,"Data",num)=data
			}
			Kill ^TMP(%ZIndex,%JIndex,%NIndex,"Index")
		}
	}
	
	Set num=""
	For {
		Set num=$o(^TMP(%ZIndex,%JIndex,%NIndex,"Data",num))
		Quit:num=""
		Set data=$g(^TMP(%ZIndex,%JIndex,%NIndex,"Data",num))
		Set EpisodeID=$li(data,1)
		Set ^TMP(%ZIndex,%JIndex,%NIndex,"EpisodeID",EpisodeID)=data
	}
	
	Set EpisodeID=""
	For {
		Set EpisodeID=$o(^TMP(%ZIndex,%JIndex,%NIndex,"EpisodeID",EpisodeID))
		Quit:EpisodeID=""
		Set data=$g(^TMP(%ZIndex,%JIndex,%NIndex,"EpisodeID",EpisodeID))
		Set ^CacheTemp(repid,ind)=data
		Set ind=ind+1
	}
	Kill ^TMP(%ZIndex,%JIndex,%NIndex)
	
	Quit $$$OK
	
BuildData(EpisodeID,ResultID)
	n (EpisodeID,objSubject,Keyword,repid,ResultID)
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
	Set $li(data,13)=""
	if (ResultID'="")
	{
		Set objResult=##class(DHCMed.CC.CtlResult).GetObjById(ResultID)
		Do objResult.%Close()
		Set SummaryID=$o(^DHCMed.CC.CtlResultI("Summary","IndexEpisodeSubjectActDate",EpisodeID,objSubject.%Id(),objResult.ActDate,""),-1)
		Set $li(data,12)=SummaryID
		Set objSummary=##class(DHCMed.CC.CtlSummary).GetObjById(SummaryID)
		Do objSummary.%Close()
		Set $li(data,13)=$s(+objSummary.LnkSummaryID=0:SummaryID,1:objSummary.LnkSummaryID)
	}
	Set $li(data,14)=objAdm.DepartmentID
	Set $li(data,15)=objAdm.WardID
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
	
	Set %ZIndex=$zn,%JIndex=$j,%NIndex="QueryDepWarning"
	Kill ^TMP(%ZIndex,%JIndex,%NIndex)
	
	Set GroupType=2 //按病区分组
	
	For i=1:1:$l(Args,$c(1)) {
		Set tmpArg=$p(Args,$c(1),i)
		Continue:tmpArg=""
		Set Code=$p(tmpArg,"^",1)
		Set Keyword=$p(tmpArg,"^",2)
		Set MinNum=$p(tmpArg,"^",3)
		
		//检测是否当日已经进行过监控，如果没有，则进行监控（仅监控某些关键字的）
		If $d(^DHCMed.CC.CtlResultI("Summary","IndexSubjectRecDate",+$h,objSubject.%Id()))
		{
			//update by zf 2013-04-12
			//不能实时执行自动任务
			//Set ret=##class(DHCMed.CCService.AutoProcess.CoreVM).Process(objSubject.%Id(),+$h,+$h,"","",Keyword)
		}
		
		//个人细菌类别
		if (Code="PersonalGermKind") { 
			Set tmp=..QueryGermData(FromDate,ToDate,SubjectCode,Keyword,GroupType)
			
			Set EpisodeID="",Cnt=0
			For {
				Set EpisodeID=$o(^TMP(%ZIndex,%JIndex,%NIndex,"Index","GermCnt","EpisodeID",EpisodeID))
				Quit:EpisodeID=""
				
				Set Cnt=$g(^TMP(%ZIndex,%JIndex,%NIndex,"Index","GermCnt","EpisodeID",EpisodeID))
				Continue:(Cnt'>MinNum)
				Set objAdm=##class(DHCMed.Base.PatientAdm).GetObjById(EpisodeID)
				set tmp=$g(^TMP(%ZIndex,%JIndex,%NIndex,"Index","PersonalGermKindDepCnt",+objAdm.WardID))
				Set tmp=tmp+1
				Set ^TMP(%ZIndex,%JIndex,%NIndex,"Index","PersonalGermKindDepCnt",+objAdm.WardID)=tmp
			}
			
			Set DepID=""
			For {
				Set DepID=$o(^TMP(%ZIndex,%JIndex,%NIndex,"Index","PersonalGermKindDepCnt",DepID))
				Quit:DepID=""
				
				Set Cnt=$g(^TMP(%ZIndex,%JIndex,%NIndex,"Index","PersonalGermKindDepCnt",DepID))
				
				Set data=$lb("")
				Set $li(data,1)=DepID
				Set objCtloc=##class(DHCMed.Base.PacWard).GetObjById(DepID)
				Set $li(data,2)=objCtloc.Descs
				Set $li(data,3)=Cnt
				Set $li(data,4)="PersonalGermKind"
				Set $li(data,5)=Keyword
				Set $li(data,6)="单次就诊病原体培养细菌种类>"_MinNum_"种："_Cnt_"人"
				Set $li(data,7)=MinNum
				Set ^CacheTemp(repid,ind)=data
				Set ind=ind+1
			}
			Kill ^TMP(%ZIndex,%JIndex,%NIndex,"Index")
		}
		if (Code="DepGermCnt") { //同科室检出微生物者>
			Set tmp=..QueryGermData(FromDate,ToDate,SubjectCode,Keyword,GroupType)
			Set DepID=""
			For {
				Set DepID=$o(^TMP(%ZIndex,%JIndex,%NIndex,"Index","WardGerm",DepID))
				Quit:DepID=""
				
				Set Cnt=$g(^TMP(%ZIndex,%JIndex,%NIndex,"Index","WardGerm",DepID))
				Continue:(Cnt'>MinNum)
				
				Set data=$lb("")
				Set $li(data,1)=DepID
				Set objCtloc=##class(DHCMed.Base.PacWard).GetObjById(DepID)
				Set $li(data,2)=objCtloc.Descs
				Set $li(data,3)=Cnt
				Set $li(data,4)="DepGermCnt"
				Set $li(data,5)=Keyword
				Set $li(data,6)="同科室检出微生物者："_Cnt_"人"
				Set $li(data,7)=MinNum
				Set ^CacheTemp(repid,ind)=data
				Set ind=ind+1
			}
			Kill ^TMP(%ZIndex,%JIndex,%NIndex,"Index")
		}
		If (Code="DepTemp") { //查询科室体温异常者
			Set tmp=..QueryTemperatureData(FromDate,ToDate,SubjectCode,Keyword,GroupType)
			Set DepID=""
			For {
				Set DepID=$o(^TMP(%ZIndex,%JIndex,%NIndex,"Index","WardTemp",DepID))
				Quit:DepID=""
				
				Set Cnt=$g(^TMP(%ZIndex,%JIndex,%NIndex,"Index","WardTemp",DepID))
				Continue:Cnt<MinNum
				
				Set data=$lb("")
				Set $li(data,1)=DepID
				Set objCtloc=##class(DHCMed.Base.PacWard).GetObjById(DepID)
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
			Set tmp=..QueryGermData(FromDate,ToDate,SubjectCode,Keyword,GroupType)
			
			Set DepID=""
			For {
				Set DepID=$o(^TMP(%ZIndex,%JIndex,%NIndex,"Index","DepGermKind",DepID))
				Quit:DepID=""
				
				Set Germ=""
				Set KindCnt=0
				Set GermStr=""
				For {
					Set Germ=$o(^TMP(%ZIndex,%JIndex,%NIndex,"Index","WardGermKind",DepID,Germ))
					Quit:Germ=""
					
					Set Cnt=$g(^TMP(%ZIndex,%JIndex,%NIndex,"Index","WardGermKind",DepID,Germ))
					Continue:(Cnt'>MinNum)
					Set:GermStr'="" GermStr=GermStr_","
					Set GermStr=GermStr_$p(Germ,"^",2)_"："_Cnt_"人"
					Set KindCnt=KindCnt+1
				}
				Continue:KindCnt=0
				
				Set data=$lb("")
				Set $li(data,1)=DepID
				Set objCtloc=##class(DHCMed.Base.PacWard).GetObjById(DepID)
				Set $li(data,2)=objCtloc.Descs
				Set $li(data,3)=KindCnt
				Set $li(data,4)="DepGermKind"
				Set $li(data,5)=Keyword
				Set $li(data,6)="同科室检出微生物类别："_GermStr
				Set $li(data,7)=MinNum
				Set ^CacheTemp(repid,ind)=data
				Set ind=ind+1
			}
			Kill ^TMP(%ZIndex,%JIndex,%NIndex,"Index")			
		}
	}
	Kill ^TMP(%ZIndex,%JIndex,%NIndex)
	
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

ClassMethod GetWarnCtlInfo(FromDate As %String, ToDate As %String, SubjectCode As %String, Args As %String)
{
	New (FromDate,ToDate,SubjectCode,Args,%ZIndexA,%JIndexA,%NIndexA)
	
	Set objResultSet=##class(%ResultSet).%New("DHCMed.CCService.Feedback.WarnService"_":"_"QueryDepWarning")
	Set ret=objResultSet.Execute(FromDate,ToDate,SubjectCode,Args)
	Set Cnt=1,%sc1=""
	For {
		Quit:objResultSet.Next(.%sc1)=0
		
		Set WardID=+objResultSet.Get("Ctloc")
		Set TypeDesc=objResultSet.Get("TypeDesc")
		Set TypeCode=objResultSet.Get("TypeCode")
		Set MinNum=objResultSet.Get("MinNum")
		Set Keyword=objResultSet.Get("Keyword")
		
		Set ^TMP(%ZIndexA,%JIndexA,%NIndexA,"WarnCtl","WardID",WardID,Cnt)=$lb(WardID,TypeCode,TypeDesc,MinNum,Keyword)
		Set Cnt=Cnt+1
	}
	Do objResultSet.%Close()
	Quit "OK"
}

}
