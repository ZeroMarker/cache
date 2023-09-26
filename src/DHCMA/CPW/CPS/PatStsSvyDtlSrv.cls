Class DHCMA.CPW.CPS.PatStsSvyDtlSrv Extends %RegisteredObject [ Abstract, ClassType = "", Not ProcedureBlock ]
{

/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCMA.CPW.CPS.PatStsSvyDtlSrv","QryOptin","33")
Query QryOptin(aParRef As %String) As %Query(ROWSPEC = "ID:%String,Item:%String,Option:%String,AnswerTxt:%String,Type:%String") [ SqlProc ]
{
}

ClassMethod QryOptinExecute(ByRef qHandle As %Binary, aParRef As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	Quit:aParRef="" $$$OK
 	Set xID=""
 	For{
	 	Set xID=$o(^DHCMA.CPW.CP.PatStsSvyI("DTL","IdxofParref",aParRef,xID))
	 	Quit:xID=""
	 	Set obj=##class(DHCMA.CPW.CP.PatStsSvyDtl).GetObjById(aParRef_"||"_xID)
	 	Quit:'$Isobject(obj)
	 	Set ItemDr=obj.SSItemDr
	 	Quit:'$Isobject(ItemDr)
	 	Set Item=ItemDr.%Id()
	 	Set Type=ItemDr.SQItemType.BTCode
	 	Set Option=obj.SSOptionDr
	 	Set AnswerTxt=obj.SSAnswerTxt
	 	Set Data=$lb(xID,Item,Option,AnswerTxt,Type)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	 }
	
 	Quit $$$OK
}

ClassMethod QryOptinClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryOptinExnmecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryOptinFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryOptinExecute ]
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

/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCMA.CPW.CPS.PatStsSvyDtlSrv","QryReport","30")
Query QryReport(aParRef As %String) As %Query(ROWSPEC = "Option:%String,Desc:%String,flag:%String,Score:%String") [ SqlProc ]
{
}

ClassMethod QryReportExecute(ByRef qHandle As %Binary, aParRef As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	Quit:aParRef="" $$$OK
 	Set xobj=##class(DHCMA.CPW.CP.PatStsSvy).GetObjById(aParRef)
 	Quit:'$Isobject(xobj)
 	
 	Set Score=xobj.SSTotalScore
 	Set xID=""
 	For{
	 	Set xID=$o(^DHCMA.CPW.CP.PatStsSvyI("DTL","IdxofParref",aParRef,xID))
	 	Quit:xID=""
	 	Set obj=##class(DHCMA.CPW.CP.PatStsSvyDtl).GetObjById(aParRef_"||"_xID)
	 	Quit:'$Isobject(obj)
	 	Set ItemDr=obj.SSItemDr		//SurveyQuestion	//题目
	 	Quit:'$Isobject(ItemDr)
	 	Set Item=ItemDr.%Id()
	 	Set Option=obj.SSOptionDr	//选项
	 	If (Option'=""){
			 	Set Sur=$p(Item,"||",1)
			 	Set Ques=$p(Item,"||",2)
			 	Set xOption=""
			 	For{
				 	Set xOption=$o(^DHCMA.CPW.BT.SurveyI("OPT","IdxofPQst",Sur,Ques,xOption))
				 	Quit:xOption=""
				 	Set flag=0	
				 	Set:Option[(Sur_"||"_Ques_"||"_xOption) flag=1
				 	Set Oobj=##class(DHCMA.CPW.BT.SurveyOption).GetObjById(Sur_"||"_Ques_"||"_xOption)
				 	Set Desc=Oobj.SQOptionDesc
				 	Set Data=$lb(Sur_"||"_Ques_"||"_xOption,Desc,flag,Score)
		 			Set ^CacheTemp(repid,ind)=Data
					Set ind=ind+1
				}
		 }else{
			Set Option=Item
			Set Desc=obj.SSAnswerTxt
	 		Set Data=$lb(Option,Desc,flag,Score)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
	 	
	 
	 }
	
 	Quit $$$OK
}

ClassMethod QryReportClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryReportExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryReportFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryReportExnmecute ]
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

/// Description:  取患者信息
/// Table：       
/// Input：       EpisodeID
/// Return：      返回List
/// D ##class(%ResultSet).RunQuery("DHCMA.CPW.CPS.PatStsSvyDtlSrv","QryReportPat","899!!1")
Query QryReportPat(aEpisodeID As %String) As %Query(ROWSPEC = "EpisodeID:%String,PatientID:%String,PapmiNo:%String,MrNo:%String,PatName:%String,PatSex:%String,PatAge:%String,AdmDate:%String,DischDate:%String,InHospDate:%String,PatCost:%String,PAAdmType:%String,AdmLoc:%String,AdmLocDesc:%String,AdmNo:%String,AdmWardDesc:%String,AdmRoom:%String,AdmBed:%String,HospDesc:%String") [ SqlProc ]
{
}

ClassMethod QryReportPatExecute(ByRef qHandle As %Binary, aEpisodeID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	Set return=0
	Quit:aEpisodeID="" return
	Set objPat=##class(DHCMA.Util.EP.Episode).GetObjByOID(aEpisodeID)
	Quit:'$IsObject(objPat) return
	
	Set PatientID=objPat.PAPatientID	//病人ID
	Set PapmiNo=objPat.PAPapmiNo		//登记号
	Set MrNo=objPat.PAMrNo				//病案号
	Set PatName=objPat.PAPatName		//姓名
	Set PatSex=objPat.PASex				//性别
	Set PatSex=$Case(PatSex,"F":"女","M":"男",:"")
	Set PatAge=objPat.PAAge				//年龄
	Set AdmDate=objPat.PAAdmDate		//入院日期
	Set DischDate=objPat.PADischDate	//出院日期
	Set AdmLoc=objPat.PAAdmLocID		//就诊科室
	Set AdmHospID=$p($g(^CTLOC($p(AdmLoc,"!!",1))),"^",22)
	Set objHosp=##class(DHCMA.Util.EP.Hospital).GetObjByOID(AdmHospID_"!!1")
	Set HospDesc=""
	Set:$IsObject(objHosp) HospDesc=objHosp.BTDesc
	Set AdmLocDesc=objPat.PAAdmLocDesc	//就诊科室Desc					
	Set objLoc=##class(DHCMA.Util.EP.Location).GetObjByOID(AdmLoc)
	Set:(AdmLocDesc="")&&($IsObject(objLoc)) AdmLocDesc=objLoc.BTDesc	
	Set AdmNo=objPat.PAAdmNo			//住院号
	Set AdmWardID=objPat.PAAdmWardID
	Set AdmWardDesc=objPat.PAAdmWardDesc //病区Desc
	Set objWard=##class(DHCMA.Util.EP.Location).GetObjByOID(AdmWardID)
	Set:(AdmWardDesc="")&&($IsObject(objWard)) AdmWardDesc=objWard.BTDesc
	Set AdmRoom=objPat.PAAdmRoom	//就诊房间
	Set AdmBed=objPat.PAAdmBed		//床位
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
	
	Set Data=$lb(aEpisodeID,PatientID,PapmiNo,MrNo,PatName,PatSex,PatAge,AdmDate,DischDate,InHospDate,PatCost,PAAdmType,AdmLoc,AdmLocDesc,AdmNo,AdmWardDesc,AdmRoom,AdmBed,HospDesc)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
 		
	Quit $$$OK
}

ClassMethod QryReportPatClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryReportPatExnmecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryReportPatFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryReportPatExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Description:  取入经信息
/// Table：       
/// Input：       EpisodeID
/// Return：      返回List
/// D ##class(%ResultSet).RunQuery("DHCMA.CPW.CPS.PatStsSvyDtlSrv","QryReportCPWData","895!!1")
Query QryReportCPWData(aEpisodeID As %String) As %Query(ROWSPEC = "CPWID:%String,CPWDesc:%String,EpisDesc:%String,ExecDescList:%String,CPWStatus:%String,InDate:%String,InTime:%String,InUserDesc:%String,InLocDesc:%String,OutDate:%String,OutTime:%String,OutUserDesc:%String,OutLocDesc:%String") [ SqlProc ]
{
}

ClassMethod QryReportCPWDataExecute(ByRef qHandle As %Binary, aEpisodeID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	Set return=0
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
	
	Set Data=$lb(CPWID,CPWDesc,EpisDesc,ExecDescList,CPWStatus)
	Set Data=Data_$lb(InDate,InTime,InUserDesc,InLocDesc,OutDate,OutTime,OutUserDesc,OutLocDesc)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Quit $$$OK
}

ClassMethod QryReportCPWDataClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryReportCPWDataExnmecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryReportCPWDataFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryReportCPWDataExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

}
