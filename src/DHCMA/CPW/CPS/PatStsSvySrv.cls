Class DHCMA.CPW.CPS.PatStsSvySrv Extends %RegisteredObject [ Abstract, ClassType = "", Not ProcedureBlock ]
{

/// Table：       DHCMA.CPW.CP.PatStsSvy
/// Input：                 
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCMA.CPW.CPS.PatStsSvySrv","QrySurByDate","2021-12-21","2021-12-23","")
Query QrySurByDate(aDateFrom As %String, aDateTo As %String, aLocID As %String, aHospID As %String) As %Query(ROWSPEC = "ID:%String,EpisodeID:%String,AdmLocDesc:%String,TotalScore:%String,LocDesc:%String,UserDesc:%String,ActDTime:%String,Code:%String,Title:%String,PatientID:%String,PapmiNo:%String,MrNo:%String,PatName:%String,PatSex:%String,PatAge:%String,AdmDate:%String,DischDate:%String,CPWID:%String,CPWDesc:%String,EpisDesc:%String,ExecDescList:%String,CPWStatus:%String,InDtime:%String,InUserDesc:%String,InLocDesc:%String,OutDtime:%String,OutUserDesc:%String,OutLocDesc:%String") [ SqlProc ]
{
}

ClassMethod QrySurByDateExecute(ByRef qHandle As %Binary, aDateFrom As %String, aDateTo As %String, aLocID As %String, aHospID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	Quit:(aDateFrom="")||(aDateTo="") $$$OK
 	
	Set SYSDr=##class(DHCMA.Util.BTS.SYSTEMSrv).GetSYSDr("")
 	Set:(aLocID'="")&&(aLocID'["!!") aLocID=aLocID_"!!"_SYSDr
 	Set:(aHospID'="")&&(aHospID'["!!") aHospID=aHospID_"!!"_SYSDr
 	Set aDateFrom=##Class(DHCMA.Util.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
 	Set aDateTo=##Class(DHCMA.Util.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
 	Set xDate=aDateFrom-1
 	For{
	 	Set xDate=$o(^DHCMA.CPW.CP.PatStsSvyI("IdxofActDate",xDate))
	 	Quit:xDate=""
		Quit:xDate>aDateTo
		if ($d(^DHCMA.CPW.CP.PatStsSvyI("IdxofActDate",xDate))){
			Set xID=""
			For{
				Set xID=$o(^DHCMA.CPW.CP.PatStsSvyI("IdxofActDate",xDate,xID))
				Quit:xID=""
				Set objPatSts=##class(DHCMA.CPW.CP.PatStsSvy).GetObjById(xID)
				Continue:'$IsObject(objPatSts)
				Set AdmLocID=objPatSts.SSAdmLocID		
				Continue:(aLocID'="")&&(aLocID'=AdmLocID)
				Set xHospID=+$p($g(^CTLOC(($p(AdmLocID,"!!",1)))),"^",22)
		 		Continue:(aHospID'="")&&($p(aHospID,"!!",1)'=xHospID)
				Set AdmLocDesc=""
				Set AdmobjLoc=##class(DHCMA.Util.EP.Location).GetObjByOID(AdmLocID)
				Set:$IsObject(AdmobjLoc) AdmLocDesc=AdmobjLoc.BTDesc		//就诊科室
				Set:AdmLocDesc["-" AdmLocDesc=$p(InLocDesc,"-",2)
				Set EpisodeID=objPatSts.SSEpisodeID		//就诊号
				Set QuestionDr=objPatSts.SSQuestionDr
				Continue:'$IsObject(QuestionDr)
				Set Code=QuestionDr.SQCode
				Set SurId=##class(DHCMA.CPW.BT.Survey).CheckSQCode(Code)
				Set Sobj=##class(DHCMA.CPW.BT.Survey).GetObjById(SurId)
				Quit:'$IsObject(Sobj)
				Set Title=Sobj.SQTitle
				Set TotalScore=objPatSts.SSTotalScore	//得分
				Set LocID=objPatSts.SSLocID				
				Set LocDesc=""							
				Set objLoc=##class(DHCMA.Util.EP.Location).GetObjByOID(LocID)
				Set:$IsObject(objLoc) LocDesc=objLoc.BTDesc		//更新科室
				Set:LocDesc["-" LocDesc=$p(InLocDesc,"-",2)
				Set UserID=objPatSts.SSUserID
				Set UserDesc=""							/// 更新用户
				Set objUser=##class(DHCMA.Util.EP.SSUser).GetObjByOID(UserID)
				Set:$IsObject(objUser) UserDesc=objUser.BTDesc
				Set ActDate=objPatSts.SSActDate			/// 更新日期
				Set ActDate=##Class(DHCMA.Util.IO.FromHisSrv).DateLogicalToHtml(ActDate)
				Set ActTime=objPatSts.SSActTime			//更新时间
				Set ActTime=$zt(ActTime,1)
				Set ActDTime=ActDate_" "_ActTime
				Set CPWData=..GetCPWData(EpisodeID)
				Set PatData=..GetPatData(EpisodeID)
				Set Data=$lb(xID,EpisodeID,AdmLocDesc,TotalScore,LocDesc,UserDesc,ActDTime,Code,Title)
				Set Data=Data_PatData_CPWData
				Set ^CacheTemp(repid,ind)=Data
				Set ind=ind+1
			}
		}	
	 }
	
 	Quit $$$OK
}

ClassMethod QrySurByDateClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QrySurByDateExnmecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QrySurByDateFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QrySurByDateExecute ]
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

/// Return：      返回List
/// w ##class(DHCMA.CPW.CPS.PathwaySrv).GetPatData("895!!1")
ClassMethod GetPatData(aEpisodeID As %String) As %List
{
	New (aEpisodeID)
	Set return=$Lb("")
	Quit:aEpisodeID="" return
	
	set objPat=##class(DHCMA.Util.EP.Episode).GetObjByOID(aEpisodeID)
	Quit:'$IsObject(objPat) return
	
	Set PatientID=objPat.PAPatientID
	Set PapmiNo=objPat.PAPapmiNo
	Set MrNo=objPat.PAMrNo
	Set PatName=objPat.PAPatName
	Set PatSex=objPat.PASex
	Set PatSex=$Case(PatSex,"F":"女","M":"男",:"")
	Set PatAge=objPat.PAAge
	Set AdmDate=objPat.PAAdmDate
	Set DischDate=objPat.PADischDate
	Set InHospDate=$Case(DischDate'="",1: DischDate-AdmDate,0:+$H-AdmDate)   //住院天数
	Set:InHospDate=0 InHospDate=1
	Set InHospDate=InHospDate_"(天)"
	Set AdmDate=##Class(DHCMA.Util.IO.FromHisSrv).DateLogicalToHtml(AdmDate)
	Set DischDate=##Class(DHCMA.Util.IO.FromHisSrv).DateLogicalToHtml(DischDate)
	
	Set paadm=$p(aEpisodeID,"!!",1)
	Set Feestr=##class(web.DHCCPW.MR.Interface).GetAdmCateFee(paadm)
	Set PatCost=$p(Feestr,"^",1)_"元"		//住院总费用。。。
	//增加过滤门诊
	Set PAAdmType=objPat.PAAdmType

	Set Data=$lb(PatientID,PapmiNo,MrNo,PatName,PatSex,PatAge,AdmDate,DischDate)
	Set return=Data
	
	Quit return
}

/// Return：      返回List
/// w ##class(DHCMA.CPW.CPS.PathwaySrv).GetCPWData("895!!1")
ClassMethod GetCPWData(aEpisodeID As %String) As %List
{
	New (aEpisodeID)
	Set return=$Lb("")
	Quit:aEpisodeID="" return
	
	Set xCPWID=$o(^DHCMA.CPW.CP.PathwayI("IdxofEpisodeID",aEpisodeID,""),-1)
	Quit:xCPWID="" return
	Set objPathway=##class(DHCMA.CPW.CP.Pathway).GetObjById(xCPWID)
	Quit:'$IsObject(objPathway)
	Set CPWID=objPathway.%Id()
	Set CPWDesc=objPathway.CPFormDr.FormPathDr.BTDesc		//当前路径名称
	Set EpisDesc=objPathway.CPEpisDr.CPFormEpDr.EpDesc		//当前阶段
	Set ExecDescList=""										//切换路径名称^
	Set xExecID=""
	For {
		Set xExecID=$o(^DHCMA.CPW.CP.PathwayI("EXEC","IdxofParRef",CPWID,xExecID))
		Quit:xExecID=""
		Set objExec=##class(DHCMA.CPW.CP.PathwayExec).GetObjById(CPWID_"||"_xExecID)
		Continue:'$IsObject(objExec)
		
		Set ExecDesc=objExec.CPFormDr.FormPathDr.BTDesc		//切换前路径名称
		Set ExecDescList=ExecDescList_"^"_ExecDesc
	}
	Set:ExecDescList'="" ExecDescList=$e(ExecDescList,2,$l(ExecDescList))
	Set CPWStatus=objPathway.CPStatus
	Set CPWStatus=$Case(CPWStatus,"I":"入径","O":"出径","C":"完成","U":"作废","P":"预约","A":"申请",:"")
	
	Set InDate=objPathway.CPInDate
	Set InDate=##Class(DHCMA.Util.IO.FromHisSrv).DateLogicalToHtml(InDate)
	Set InTime=objPathway.CPInTime
	Set:InTime'="" InTime=$zt(InTime,1)
	Set InUserID=objPathway.CPInUserID
	Set InUserDesc=""
	If ((InUserID="")||(InUserID="undefined")) {
		set objPat=##class(DHCMA.Util.EP.Episode).GetObjByOID(objPathway.CPEpisodeID)
		Set InUserID=objPat.PAAdmDocID	//不明原因，申请人为空
		Set objUser=##class(DHCMA.Util.EP.CareProv).GetObjByOID(InUserID)
		Set:$IsObject(objUser) InUserDesc=objUser.BTDesc
	} Else {
		Set objUser=##class(DHCMA.Util.EP.SSUser).GetObjByOID(InUserID)
		Set:$IsObject(objUser) InUserDesc=objUser.BTDesc
	}
	Set InLocID=objPathway.CPInLocID
	Set:((InLocID="")||(InLocID="undefined")) InLocID=objPat.PAAdmLocID	//不明原因，申请科室为空
	Set InLocDesc=""
	Set objLoc=##class(DHCMA.Util.EP.Location).GetObjByOID(InLocID)
	Set:$IsObject(objLoc) InLocDesc=objLoc.BTDesc
	Set:InLocDesc["-" InLocDesc=$p(InLocDesc,"-",2)
	
	Set OutDate=objPathway.CPOutDate
	Set OutDate=##Class(DHCMA.Util.IO.FromHisSrv).DateLogicalToHtml(OutDate)
	Set OutTime=objPathway.CPOutTime
	Set:OutTime'="" OutTime=$zt(OutTime,1)
	Set OutUserID=objPathway.CPOutUserID
	Set OutUserDesc=""
	Set objUser=##class(DHCMA.Util.EP.SSUser).GetObjByOID(OutUserID)
	Set:$IsObject(objUser) OutUserDesc=objUser.BTDesc
	Set OutLocID=objPathway.CPOutLocID
	Set OutLocDesc=""
	Set objLoc=##class(DHCMA.Util.EP.Location).GetObjByOID(OutLocID)
	Set:$IsObject(objLoc) OutLocDesc=objLoc.BTDesc
	Set:OutLocDesc["-" OutLocDesc=$p(OutLocDesc,"-",2)
	Set InDtime=InDate_" "_InTime
	Set OutDtime=OutDate_" "_OutTime
	Set Data=$lb(CPWID,CPWDesc,EpisDesc,ExecDescList,CPWStatus)
	Set Data=Data_$lb(InDtime,InUserDesc,InLocDesc,OutDtime,OutUserDesc,OutLocDesc)
	
	Set return=Data
	Quit return
}

/// w ##class(DHCMA.CPW.CPS.PatStsSvySrv).ImportQuestion("Question^1^1. 住院期间您对医师、护士的服务态度是否满意?^10^Radio^")
ClassMethod ImportQuestion(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete,ret,flag,Qret)
	Set return=-1
	b ;0
	Quit:aInputStr="" return		
	Set Type		 = $p(aInputStr,aSeparete,1)
	Set Code         = $p(aInputStr,aSeparete,2)
	Set Title        = $p(aInputStr,aSeparete,3)
	Set Score        = $p(aInputStr,aSeparete,4)
	Set QuesType   	 = $p(aInputStr,aSeparete,5)
	Set Resume   	 = $p(aInputStr,aSeparete,6)
	Set Question   	 = $p(aInputStr,aSeparete,7)
	if (Type="Title"){
		Set flag=##class(DHCMA.CPW.BT.Survey).CheckSQCode(Code)
		if (flag'="0"){
			Set obj=##class(DHCMA.CPW.BT.Survey).%OpenId(flag)
			Set obj.SQTitle     = Title
			Set sc=obj.%Save()
			If $system.Status.IsError(sc) {        //检查Save是否成功
		   		Do $system.OBJ.DisplayError(sc) 
		   		Set return=-1
			}Else{
				Set return=1
			}
			Do obj.%Close()
		}else{
			Set ret=##class(DHCMA.CPW.BT.Survey).Update(""_"^"_Code_"^"_Title,aSeparete)
			Quit:ret<=0 return
			Set return=1
		}
	}
	if (Type="Question"){
		Set Dobj=##class(DHCMA.Util.BT.Dictionary).GetObjByCode("CPWQuesType",QuesType)
		Quit:'$IsObject(Dobj) return
		Set flag=##class(DHCMA.CPW.BT.Survey).CheckSQCode(Question)
		if ($d(^DHCMA.CPW.BT.SurveyI("QST","IdxofPItemNo",flag,Code))){
			Set QID=$o(^DHCMA.CPW.BT.SurveyI("QST","IdxofPItemNo",flag,Code,""),-1)
			Set Qret=##class(DHCMA.CPW.BT.SurveyQuestion).Update(flag_"^"_QID_"^"_Code_"^"_Title_"^"_Dobj.%Id()_"^"_Score_"^"_Resume,aSeparete)
			Quit:'$IsObject(Qret) return
		}else{
			Set Qret=##class(DHCMA.CPW.BT.SurveyQuestion).Update(flag_"^"_""_"^"_Code_"^"_Title_"^"_Dobj.%Id()_"^"_Score_"^"_Resume,aSeparete)
			Quit:'$IsObject(Qret) return
		}
		
	}
	if (Type="Answer"){
		Set flag=##class(DHCMA.CPW.BT.Survey).CheckSQCode(Question)
		Set Qret=$o(^DHCMA.CPW.BT.SurveyI("QST","IdxofPItemNo",flag,QuesType,""),-1)
		if ($d(^DHCMA.CPW.BT.SurveyI("OPT","IdxofPOptionNo",flag,Qret,Code))){
			Set OID=$o(^DHCMA.CPW.BT.SurveyI("OPT","IdxofPOptionNo",flag,Qret,Code,""),-1)
			Set Parref=flag_"||"_Qret
			Set Oret=##class(DHCMA.CPW.BT.SurveyOption).Update(Parref_"^"_OID_"^"_Code_"^"_Title_"^"_Score,aSeparete)
			Quit:'$IsObject(Oret) return
		}else{
			Set Parref=flag_"||"_Qret
			Set Oret=##class(DHCMA.CPW.BT.SurveyOption).Update(Parref_"^"_""_"^"_Code_"^"_Title_"^"_Score,aSeparete)
			Quit:'$IsObject(Oret) return
		}
		
	}
	Quit return
}

}
