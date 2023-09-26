Class web.DHCRBResSession Extends DHCDoc.Util.RegisteredObject [ ClassType = "", ProcedureBlock ]
{

Parameter dhtmlXListSplitStr = "$C(1)";

Parameter dhtmlXValueSplitStr = "^";

ClassMethod Delete(Rowid As %String, DelSchedule As %String = "") As %String
{
	;w ##class(web.DHCRBResSession).Delete("1526||1||1","Y")
	;s ^tmpnk("Delete")=Rowid_"^"_DelSchedule
	s Flag=..GetSubmitFlag(Rowid)
	q:Flag="S" "-1^HandSubmit"
	set OldDataJson=##class(web.DHCDocDataChangeLog).GetLogJsonData("User.RBResEffDateSession"_$c(2)_Rowid)
	s ASDesc=$p($g(^RB("RES",+Rowid)),"^",17)
	&SQL(Delete From SQLUser.RB_ResEffDateSession Where SESS_RowId=:Rowid )
	set ret=##class(web.DHCDocDataChangeLog).SaveLog("User.RBResEffDateSession","User.RBResEffDateSession","排班模板信息","User.RBResEffDateSession_"_Rowid,ASDesc,"D","",OldDataJson)
	if 'SQLCODE{
		;是否删除相应的排班，需判断操作日期之后有无挂号记录及预约记录
		if DelSchedule="Y"{
			s ASDate=..%SysDate()-1
			s ResRowID=+Rowid
			for  s ASDate=$o(^RBAS(ResRowID,0,"DateSess",ASDate)) q:ASDate=""  d
			.s ASStartTime=""
			.for  s ASStartTime=$o(^RBAS(ResRowID,0,"DateSess",ASDate,Rowid,ASStartTime)) q:ASStartTime=""  d
			..s ASChild=0
			..for  s ASChild=$o(^RBAS(ResRowID,0,"DateSess",ASDate,Rowid,ASStartTime,ASChild)) q:ASChild=""  d
			...s QuitFlag=0
			...s ASRowId=ResRowID_"||"_ASChild
			...s RegistRowID=$o(^User.DHCRegistrationFeeI("RBASDr",ASRowId,0))
			...if RegistRowID'="" s QuitFlag=1
			...s AppChild=$o(^RBAS(ResRowID,ASChild,"APPT",0))
			...if AppChild'="" s QuitFlag=1
			...Q:QuitFlag=1
			...;&SQL(Delete From SQLUser.RB_ApptSchedule Where AS_RowId=:ASRowId )
			...s rtn=##class(web.DHCRBApptSchedule).DelectOneSchedule(ASRowId)
		}	
	}
	Q SQLCODE
}

ClassMethod DeleteEffDate(ResDateRowId As %String) As %String
{
	&SQL(Delete From SQLUser.RB_ResEffDate Where DATE_RowId=:ResDateRowId)
	Q SQLCODE
}

ClassMethod FindLocBroker(itmjs As %Library.String = "", itmjsex As %Library.String = "", Loc As %String) As %String
{
	Set rset=##class(%ResultSet).%New("web.DHCRBResSession:FindLoc")
	do rset.Execute(Loc)
	Set columns = rset.GetColumnCount()
	set row=0
	set ret=""
	While (rset.Next()) {
	    For col = 1:1:columns {
		   i ret="" s ret=rset.GetData(col)
	       e  s ret= ret_"^"_rset.GetData(col)
	    }
	    s row=row+1
	    If row=1 Quit
	}
	d rset.Close()
	if row>0 {
		s retval=itmjs_"('"_$ZCVT(ret,"O","JS")_"');"
		i itmjsex'="""" s retval=retval_itmjsex_"('"_$ZCVT(ret,"O","JS")_"');"
		&javascript<#(retval)#>
	}
	Q row
}

ClassMethod FindLocClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = FindLocExecute ]
{
	// Clean up by purging the temporary node in ^CacheTemp global
	//New repid
	Set repid=$li(QHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindLocExecute(ByRef QHandle As %Binary, Loc As %String, UserID As %String = "", HospitalDr As %String = "") As %Status
{
	//New repid, ind
	//New CTCode,CTDesc
	;d ##class(%ResultSet).RunQuery("web.DHCRBResSession","FindLoc","zl")
	Set repid=$I(^CacheTemp)
	s ind=1
	s Loc=$ZCVT(Loc,"U")
	
	s AdmType=""
	Set rset=##class(%ResultSet).%New("web.DHCOPAdmReg:OPDeptList")
	do rset.Execute(UserID,AdmType,"",HospitalDr)
	Set columns = rset.GetColumnCount()
	set row=0
	While (rset.Next()) {
		s rowid=rset.GetData(1)
		s CTDesc=$p($g(^CTLOC(rowid)),"^",2)
		s CTDesc=$ZCVT(CTDesc,"U")
		s CTCode=$p($g(^CTLOC(rowid)),"^",1)
		s CTContactNameTem=""
		i $L(CTDesc,"-")>1 s CTContactNameTem=$P(CTDesc,"-",1) s CTDesc=$P(CTDesc,"-",2,$L(CTDesc,"-"))
		s CTDesc=$TR(CTDesc,"-")
		;用作放助记码的地方
		s CTContactName=$p($g(^CTLOC(rowid)),"^",43)
		s CTContactName=$ZCVT(CTContactName,"U")
		i CTContactName="" s CTContactName=CTContactNameTem
		s QuitFlag=0
		if (Loc'="")&&((CTDesc'[(Loc))&&(CTContactName'[(Loc))) s QuitFlag=1
		if (UserID'="")&&('##class(web.DHCUserGroup).UserCanDo(UserID,rowid)) s QuitFlag=1
		
		if QuitFlag=0 Do OutputRow
	}
	
	Set QHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set Data=$lb(CTDesc,CTCode,rowid,CTContactName)
	Set ^CacheTemp(repid,ind)=Data	
	Set ind=ind+1
	quit
ResetVariables
	///set (repid)=0
	set (CTDesc,CTCode,rowid,CTContactName)=""
	quit
}

ClassMethod FindLocFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindLocExecute ]
{
	//New repid,ind
	Set AtEnd=$li(QHandle,1)
	Set repid=$li(QHandle,2)
	Set ind=$li(QHandle,3)
	
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {	// if there are no more rows, finish fetching
		 Set AtEnd=1
		 Set Row=""
	}
	Else      {	// fetch row
		Set Row=^CacheTemp(repid,ind)
	}
	s QHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindResDocClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = FindResDocExecute ]
{
	// Clean up by purging the temporary node in ^CacheTemp global
	//New repid
	Set repid=$li(QHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindResDocExecute(ByRef QHandle As %Binary, DepID As %String, Type As %String = "", UserID As %String = "", Group As %String = "", MarkCodeName As %String = "", HospID = "") As %Status
{
	s HospID=##class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(HospID)
	Set repid=$I(^CacheTemp)
	s ind=1
	Set langid=..%LanguageID()
	s AllRegDocString=##class(web.DHCOPAdmReg).GetAllRegDocString(Group)
	if Type'="EQ" {
		if (DepID=""){
			k tmpDocListArr($j)
	        s RowId=0
	        f  s RowId=$o(^RB("RES",RowId)) q:RowId=""  d
	        .s LocId=$p(^RB("RES",RowId),"^",1)
	        .Q:'$d(^PAC("ADMLOC",0,"AdmType","O",LocId))&&('$d(^PAC("ADMLOC",0,"AdmType","E",LocId)))
	        .Q:'$d(^RB("RES",0,"CTLOC",LocId))
	        .Q:'($D(^RB("RES",RowId)))
	        .Q:"N"=##class(DHCDoc.Common.Hospital).GetHospShowDataFlag("RB_Resource",RowId,HospID)
	        .s ActiveFrom=$p(^RB("RES",RowId),"^",22)
	        .Q:(ActiveFrom'="")&&(ActiveFrom>+$h)
	        .s ActiveTo=$p(^RB("RES",RowId),"^",23)
	        .Q:(ActiveTo'="")&&(ActiveTo<=+$h)
			.set ScheSt=$p(^RB("RES",RowId),"^",6)
			.Q:(ScheSt'="Y")
			.S DocID=$p(^RB("RES",RowId),"^",2)
			.Q:DocID=""
			.q:(AllRegDocString'="")&&(AllRegDocString'[("^"_DocID_"^"))
			.q:('$d(^CTPCP(DocID,1)))
			.Q:$d(tmpDocListArr($j,DocID))
			.s tmpDocListArr($j,DocID)=1
			.s DocCode=$p(^CTPCP(DocID,1),"^",1)
			.s OtherDesc=$p(^CTPCP(DocID,3),"^",28)
			.Q:##class(DHCDoc.Util.Base).CheckCTCareName("CT_CareProv",DocID,MarkCodeName)'="1"
			.s UserActive="Y"
			.set Userdr=$O(^SSU("SSUSR",0,"CTPCP",DocID,"0"))
			.if Userdr'="" d
			..s UserActive=$P(^SSU("SSUSR",Userdr),"^",19)
			.q:UserActive'="Y"
			.s DocDesc=$p(^CTPCP(DocID,1),"^",2) //_"-"_OtherDesc
			.Set DocDesc= ##class(User.CTCareProv).GetTranByDesc("CTPCPDesc",DocDesc,langid)
			.Do OutputRow1
			k tmpDocListArr($j)
		}else{
			s RowId=0 f  S RowId=$o(^RB("RES",0,"CTLOC",DepID,RowId)) Q:RowId=""  d
			.Q:'($D(^RB("RES",RowId)))
			.set ScheSt=$p(^RB("RES",RowId),"^",6)
			.Q:(ScheSt'="Y")
			.Q:"N"=##class(DHCDoc.Common.Hospital).GetHospShowDataFlag("RB_Resource",RowId,HospID)
			.s ActiveFrom=$p(^RB("RES",RowId),"^",22)
	        .Q:(ActiveFrom'="")&&(ActiveFrom>+$h)
	        .s ActiveTo=$p(^RB("RES",RowId),"^",23)
	        .Q:(ActiveTo'="")&&(ActiveTo<=+$h)
			.S DocID=$p(^RB("RES",RowId),"^",2)
			.Q:DocID=""
			.Q:##class(DHCDoc.Util.Base).CheckCTCareName("CT_CareProv",DocID,MarkCodeName)'="1"
			.q:(AllRegDocString'="")&&(AllRegDocString'[("^"_DocID_"^"))
			.;q:(UserID'="")&&('$D(^User.DHCUserGroupI("UserLocDoc"," "_UserID," "_DepID," "_DocID)))
			.q:(UserID'="")&&('##class(web.DHCUserGroup).UserCanDo(UserID,DepID,DocID))
			.q:('$d(^CTPCP(DocID,1)))
			.s UserActive="Y"
			.set Userdr=$O(^SSU("SSUSR",0,"CTPCP",DocID,"0"))
			.if Userdr'="" d
			..s UserActive=$P(^SSU("SSUSR",Userdr),"^",19)
			.q:UserActive'="Y"
			.s DocCode=$p(^CTPCP(DocID,1),"^",1)
			.s OtherDesc=$p(^CTPCP(DocID,3),"^",28)
			.s DocDesc=$p(^CTPCP(DocID,1),"^",2) //_"-"_OtherDesc
			.Set DocDesc= ##class(User.CTCareProv).GetTranByDesc("CTPCPDesc",DocDesc,langid)
			.Do OutputRow1
		}
		
	}else{
		s RowId=0 f  S RowId=$o(^RB("RES",0,"CTLOC",DepID,RowId)) Q:RowId=""  d
		.Q:'($D(^RB("RES",RowId)))
		.s ScheSt=$p(^RB("RES",RowId),"^",6)
		.Q:(ScheSt'="Y")
		.Q:"N"=##class(DHCDoc.Common.Hospital).GetHospShowDataFlag("RB_Resource",RowId,HospID)
		.s ActiveFrom=$p(^RB("RES",RowId),"^",22)
        .Q:(ActiveFrom'="")&&(ActiveFrom>+$h)
        .s ActiveTo=$p(^RB("RES",RowId),"^",23)
        .Q:(ActiveTo'="")&&(ActiveTo<=+$h)
		.s DocID=$p(^RB("RES",RowId),"^",2)
		.q:(AllRegDocString'="")&&(AllRegDocString'[("^"_DocID_"^"))
		.S EQID=$p(^RB("RES",RowId),"^",3)
		.Q:EQID=""
		.Q:'$D(^RBC("EQ",EQID))
		.s EQCode=$p(^RBC("EQ",EQID),"^",1)
		.s EQDesc=$p(^RBC("EQ",EQID),"^",2)
		.Set EQDesc= ##class(User.CTCareProv).GetTranByDesc("CTPCPDesc",EQDesc,langid)
		.Do OutputRow2
	}
	Set QHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow1
	set Data=$lb(DocDesc,DocCode,DocID,RowId)
	Set ^CacheTemp(repid,ind)=Data	
	Set ind=ind+1
	quit
OutputRow2
	set Data=$lb(EQDesc,EQCode,EQID,RowId)
	Set ^CacheTemp(repid,ind)=Data	
	Set ind=ind+1
	quit
ResetVariables1
	///set (repid)=0
	set (DocDesc,DocCode,DocID,RowId)=""
	quit
}

ClassMethod FindResDocFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindResDocExecute ]
{
	//New repid,ind
	Set AtEnd=$li(QHandle,1)
	Set repid=$li(QHandle,2)
	Set ind=$li(QHandle,3)
	
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {	// if there are no more rows, finish fetching
		 Set AtEnd=1
		 Set Row=""
	}
	Else      {	// fetch row
		Set Row=^CacheTemp(repid,ind)
	}
	s QHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindResEffectDateClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = FindResEffectDateExecute ]
{
	// Clean up by purging the temporary node in ^CacheTemp global
	//New repid
	Set repid=$li(QHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindResEffectDateExecute(ByRef QHandle As %Binary, ResRowId As %String) As %Status
{
	//New repid, ind
	//New CTCode,CTDesc
	
 Set repid=$I(^CacheTemp)
 /*
 s Flag=0
 s LocID=$P(^RB("RES",val),"^",1)
 s n=$O(^DHCOPResEffDate(LocID,""),-1)
 i n="" d
 .s ^DHCOPResEffDate(LocID,1)=..%SysDate()
 .s n=1
 s Date=$G(^DHCOPResEffDate(LocID,n))
 s Date=$ZD(Date,4)
 s ResEffDateID=""*/
	s ind=1
 Set DateRowId=0 f  s DateRowId=$O(^RB("RES",ResRowId,"DATE",DateRowId)) q:(DateRowId="")  d
	.Set DateFrom=$P(^RB("RES",ResRowId,"DATE",DateRowId),"^",1)
	.;s:DateFrom=Date Flag=1
	.Set DateFromStr=$ZD(DateFrom)
	.Set RowId=ResRowId_"||"_DateRowId
	.;s ResEffDateID=RowId
	.Do OutputRow2
	;if Flag=0 s ret=##class(web.DHCRBResSession2).CopyResEffDate(ResEffDateID,Date,ResRowId)
 Set QHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow2
	set Data=$lb(DateFromStr,RowId)
 Set ^CacheTemp(repid,ind)=Data	
 Set ind=ind+1
	quit
ResetVariables2
	///set (repid)=0
	set (DateFromStr,RowId)=""
	quit
}

ClassMethod FindResEffectDateFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindResEffectDateExecute ]
{
	//New repid,ind
	Set AtEnd=$li(QHandle,1)
	Set repid=$li(QHandle,2)
	Set ind=$li(QHandle,3)
	
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {	// if there are no more rows, finish fetching
		 Set AtEnd=1
		 Set Row=""
	}
	Else      {	// fetch row
		Set Row=^CacheTemp(repid,ind)
	}
	s QHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// 判断同时段是否存在相同的诊室
ClassMethod FindSessionByWeekTRRoom(FindDOWRowId, FindTRRowId As %String, FindRoomRowId As %String, ExcludeSessRowid As %String = "", ScheduleLinesId As %String = "")
{
	Q:FindRoomRowId="" ""
	s ^zhou("FindSessionByWeekTRRoom")=FindDOWRowId_","_FindTRRowId_","_FindRoomRowId_","_ExcludeSessRowid_","_ScheduleLinesId
	;w ##class(web.DHCRBResSession).FindSessionByWeekTRRoom(1,1,188,"")
	//根据分诊区设置 ，同一个诊室在同一天同一诊不能同时被安排两次
	s BordExaID=$O(^User.DHCBorExaRoomI("BordExaRoomDrIndex"," "_FindRoomRowId,0))
	s ChecBordForOne="Y"
	if (BordExaID'=""){
		s ChecBordForOne=$lg(^User.DHCBorExaRoomD(BordExaID),10)
	}
	Q:ChecBordForOne'="Y" ""
	s ret=""
	s ResRowId=0 f  s ResRowId=$O(^RB("RES",0,"SESSRoom",FindRoomRowId,ResRowId)) Q:ResRowId=""  d
	.s DateChild=0 f  s DateChild=$O(^RB("RES",0,"SESSRoom",FindRoomRowId,ResRowId,DateChild)) Q:DateChild=""  d
	..s sessScheduleLinesId=$p(^RB("RES",ResRowId,"DATE",DateChild),"^",2)
	..Q:(ScheduleLinesId'="")&&(sessScheduleLinesId'=ScheduleLinesId)
	..s SESSChild=0 f  s SESSChild=$O(^RB("RES",0,"SESSRoom",FindRoomRowId,ResRowId,DateChild,SESSChild)) Q:SESSChild=""  d
	...Q:'$d(^RB("RES",ResRowId,"DATE",DateChild,"SESS",SESSChild))
	...s SessTimeStartNum=$p(^RB("RES",ResRowId,"DATE",DateChild,"SESS",SESSChild),"^",4)
	...S SessDOWRowid=$p(^RB("RES",ResRowId,"DATE",DateChild,"SESS",SESSChild),"^",2)
	...;s TRRowId=..GetTimeRangeByTime(SessTimeStartNum)
	...s TRRowId=$p(^RB("RES",ResRowId,"DATE",DateChild,"SESS",SESSChild),"^",3)  //guorongyong 2008-04-21
	...s SessRoomRowId=$p(^RB("RES",ResRowId,"DATE",DateChild,"SESS",SESSChild),"^",19)
	...s SessScheduleGenerFlag=$p(^RB("RES",ResRowId,"DATE",DateChild,"SESS",SESSChild),"^",16)
	...Q:SessScheduleGenerFlag="N"
	...Q:FindRoomRowId'=SessRoomRowId
	...Q:(SessDOWRowid'=FindDOWRowId)&&(FindDOWRowId<=7)
	...S SessHoliRowid=$p(^RB("RES",ResRowId,"DATE",DateChild,"SESS",SESSChild),"^",41)
	...Q:(SessHoliRowid'=FindDOWRowId)&&(FindDOWRowId>7)
	...Q:TRRowId'=FindTRRowId
	...s SessRowId=ResRowId_"||"_DateChild_"||"_SESSChild
	...Q:(ExcludeSessRowid=SessRowId)
	...i ret="" s ret=SessRowId
	...e  s ret=ret_"^"_SessRowId
	Q ret
}

ClassMethod GetClinicGroupStr(DepRowid As %String) As %String
{
	Q:DepRowid="" ""
	;w ##class(web.DHCRBResSession).GetClinicGroupStr(28)
	s LocHospDr=$p(^CTLOC(DepRowid),"^",22)
	s ret=""
	S RowId=0 f  s RowId=$O(^DHCLocSubject(RowId)) Q:(RowId="")  d
	.s LocRowid=$P(^DHCLocSubject(RowId),"^",1)
	.Q:LocRowid'=DepRowid
	.s CLGRPRowId=$P(^DHCLocSubject(RowId),"^",2)
	.Q:('$d(^RBC("CLGRP",CLGRPRowId)))
	.Q:("N"=##class(DHCDoc.Common.Hospital).GetHospShowDataFlag("RBC_ClinicGroup",CLGRPRowId,LocHospDr))
	.s DateFrom=$p($g(^RBC("CLGRP",CLGRPRowId)),"^",3)
	.s DateTo=$p(^RBC("CLGRP",CLGRPRowId),"^",4)
	.q:((DateFrom="")||(DateFrom>+$H))
	.q:((DateTo'="")&&(DateTo<+$H))
	.s Desc=$P(^RBC("CLGRP",CLGRPRowId),"^",2)
	.q:(ret[(CLGRPRowId_$C(1)_Desc))
	.i ret="" s ret=CLGRPRowId_$C(1)_Desc
	.e  s ret=ret_"^"_CLGRPRowId_$C(1)_Desc
	Q ret
}

ClassMethod GetClinicStr(val As %String) As %String
{
	;w ##class(web.DHCRBResSession).GetClinicStr("")
	s dhtmlXValueSplitStr=$C(1)
	s dhtmlXListSplitStr="^"
	s ret1=""_dhtmlXValueSplitStr_"-"
	Set rset=##class(%ResultSet).%New("web.DHCClinicDiagnosSign:LookupClinic")
	do rset.Execute(val)
	While (rset.Next()) {
		s Desc=rset.GetData(1)
		s RowId=rset.GetData(2)
		s Code=rset.GetData(3)
		s Desc=Desc    ;_"-"_Code
		s ret=RowId_dhtmlXValueSplitStr_Desc
	    i ret1="" s ret1=ret
	    e  s ret1=ret1_dhtmlXListSplitStr_ret
	}
	d rset.Close()
	Q ret1
}

ClassMethod GetDaysOfWeek() As %String
{
	n
	s ret=""
	S RowId=0 f  s RowId=$O(^CT("DOW",1,RowId)) Q:(RowId="")  d
	.s DOW=$P(^CT("DOW",1,RowId),"^",1)
	.i ret="" s ret=RowId_$C(1)_DOW
	.e  s ret=ret_"^"_RowId_$C(1)_DOW
	Q ret
}

// w ##class(web.DHCRBResSession).GetOPDeptStr("3144")

ClassMethod GetOPDeptStr(UserID As %String = "", Desc As %String = "", SubmitFlag As %String = "", LogonHospId As %String = "") As %String
{
	s ret1=""
	Set rset=##class(%ResultSet).%New("web.DHCRBResSession:FindLoc")
	do rset.Execute(Desc,UserID)
	Set columns = rset.GetColumnCount()
	set row=0
	While (rset.Next()) {
		s LocID=rset.GetData(3)
		if SubmitFlag="Y"{
			s SubmitInfo=$G(^CTLOC(LocID,"RBSSubmit")) //Flag_"^"_Date,Time_"^"_User
			s Flag=$P(SubmitInfo,"^",1)
			continue:Flag'="S"
		}
		s CTLocHospDr=$p(^CTLOC(LocID),"^",22)
	    continue:(LogonHospId'="")&&(CTLocHospDr'=LogonHospId)
		set ret=LocID_$C(1)_rset.GetData(1)_"-"_rset.GetData(4)
	    i ret1="" s ret1=ret
	    e  s ret1=ret_"^"_ret1
	}
	d rset.Close()
	Q ret1
}

ClassMethod GetOPEQDeptStr() As %String
{
	;w ##class(web.DHCRBResSession).GetOPEQDeptStr()
	s ret1=""
	s eq=0  f  s eq=$O(^RB("RES",0,"EQ",eq)) Q:eq=""  d
	.s loc=0  f  s loc=$O(^RB("RES",0,"EQ",eq,loc)) Q:loc=""  d
	..i '$d(CacheTemp(loc)) d
	...s CacheTemp(loc)=loc
	...s CTAlias=$P(^CTLOC(loc),"^",43)
	...s CTDesc=$P(^CTLOC(loc),"^",2)
	...s ret=loc_$C(1)_CTDesc_"-"_CTAlias
	...i ret1="" s ret1=ret
	...e  s ret1=ret1_"^"_ret
	Q ret1
}

ClassMethod GetResDetail(ResRowId As %String) As %String
{
	;w ##class(web.DHCRBResSession).GetResDetail("1")
	s ClinicGroupDR="",SessionTypeDR=""
	s SessLoad="",SessNoApptSlot="",SessNumberOfWeeks="",SessNoOverbookAll=""
	s TRFlag=""
	s TRLength=""
	s TRRegNum=""
	s object=##class(User.DHCRBResource).%OpenId(ResRowId)
	if $IsObject(object){
		if $IsObject(object.RESClinicGroupDR) s ClinicGroupDR=object.RESClinicGroupDR.%Id() //亚专业
		if $IsObject(object.RESSessionTypeDR) s SessionTypeDR=object.RESSessionTypeDR.%Id() //出诊级别
		s SessLoad=object.RESLoad //正号限额
		s SessNoApptSlot=object.RESAppLoad //预约限额
		s SessNoOverbookAll=object.RESAddLoad //加号限额
		s SessNumberOfWeeks=object.RESAppStartNum //预约开始号
		s TRFlag=object.RESTimeRangeFlag
		s TRLength=object.RESTimeRangeLength
		s TRRegNum=object.RESTimeRangeRegNum
	}
	;亚专业^号别^正号限额^预约限额^预约开始号^加号限额^分时段标志^时常^时段号数
	Q ClinicGroupDR_"^"_SessionTypeDR_"^"_SessLoad_"^"_SessNoApptSlot_"^"_SessNumberOfWeeks_"^"_SessNoOverbookAll_"^"_TRFlag_"^"_TRLength_"^"_TRRegNum
	
	s DateRowId=$O(^RB("RES",ResRowId,"DATE",""),-1)
	Q:DateRowId="" ""_"^"_""_"^"_""_"^"_""_"^"_""_"^"_""
	S SessRowId=$O(^RB("RES",ResRowId,"DATE",DateRowId,"SESS",0))
	
	i SessRowId'="" d
	.Q:$D(^RB("RES",ResRowId,"DATE",DateRowId,"SESS",SessRowId))=10
	.S SessLoad=+$p(^RB("RES",ResRowId,"DATE",DateRowId,"SESS",SessRowId),"^",8)
	.S SessNoApptSlot=+$p(^RB("RES",ResRowId,"DATE",DateRowId,"SESS",SessRowId),"^",1)
	.S SessNumberOfWeeks=+$p(^RB("RES",ResRowId,"DATE",DateRowId,"SESS",SessRowId),"^",21)
	.S SessNoOverbookAll=+$p(^RB("RES",ResRowId,"DATE",DateRowId,"SESS",SessRowId),"^",14)
	Q ClinicGroupDR_"^"_SessionTypeDR_"^"_SessLoad_"^"_SessNoApptSlot_"^"_SessNumberOfWeeks_"^"_SessNoOverbookAll
}

ClassMethod GetResDetailFromDepDoc(DepRowId As %String, DocRowId As %String) As %String
{
	set ResRowId=$Order(^RB("RES",0,"CTPCP",DocRowId,DepRowId,0))
	Q ..GetResDetail(ResRowId)
}

/// 返回给医生Combo的值(挂号,排班调整)
ClassMethod GetResDocBroker(DepRowId As %String, Type As %String = "", AdmDate As %String = "", UserID As %String = "", Flag As %String = "", HospID As %String = "") As %String
{
	s ^zhou("GetResEQBroker")=DepRowId_","_Type_","_AdmDate
	;w ##class(web.DHCRBResSession).GetResDocBroker("","")
	s ret1=""
	;s Type="EQ"
	i AdmDate="" s AdmDate=..%SysDate()
	e  s AdmDate=$zdh(AdmDate,4)
	if DepRowId'="" {
		Set rset=##class(%ResultSet).%New("web.DHCRBResSession:FindResDoc")
		do rset.Execute(DepRowId,Type,UserID)
	}else{
		Set rset=##class(%ResultSet).%New("web.DHCRBResSession:FindAllResDoc")
		do rset.Execute()
	}
	k TempResDocArr($j)
	While (rset.Next()) {
		s DocDesc=rset.GetData(1)
		s DocCode=rset.GetData(2)
		s DocID=rset.GetData(3)
		s ResRowid=rset.GetData(4)
		s DepID=$p(^RB("RES",ResRowid),"^")
		continue:DocID=""
		continue:##Class(DHCDoc.Common.Hospital).GetHospShowDataFlag("RB_Resource",ResRowid,HospID)="N"
		continue:((UserID'="")&&('##class(web.DHCUserGroup).UserCanDo(UserID,DepID,DocID))&&(Type'="EQ"))
		if (Flag="")&&('$D(^RBAS(ResRowid,0,"DateSTime",AdmDate))) continue
		if Type'="EQ" {
			s DocOtherName="" 
			i DocID'="" {
				i $d(^CTPCP(DocID,3)) s DocOtherName=$p(^CTPCP(DocID,3),"^",28)
			}
			///如果没有维护别名，那么自动获取简拼；加点是为了在前台区分
			if DocOtherName="" s DocOtherName=##class(ext.util.String).ToChineseSpell(DocDesc)_"."   
			i DocOtherName'="" s DocDesc=DocDesc_"-"_DocOtherName
		}
		continue:$d(TempResDocArr($j,DocID))
		s TempResDocArr($j,DocID)=1
		s ret=DocID_$C(1)_DocDesc
	   i ret1="" s ret1=ret
	   e  s ret1=ret1_"^"_ret
	}
	k TempResDocArr($j)
	d rset.Close()
	Q ret1
}

ClassMethod GetResSessionsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetResSessionsExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetResSessionsExecute(ByRef qHandle As %Binary, ResDateRowId As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	if ResDateRowId="" {
		do ResetVariables3
		Do OutputRow3
	}else{
		do ResetVariables3
		;sessRowid,SessDOW,SessTimeStart,SessTimeEnd,SessSlotLength,
		;SessLoad,SessNoSlots,SessNoApptSlot,SessNumberOfWeeks,
		;SessNoOverbookAll,SessRoom,SessType,SessClinicGroup,
		;SessPatientType,SessRoomRowid,SessTypeRowid,SessClinicGroupRowid
		S ResRowId=$P(ResDateRowId,"||",1)
		S DateRowId=$P(ResDateRowId,"||",2)
		S SessRowId=0 f  s SessRowId=$O(^RB("RES",ResRowId,"DATE",DateRowId,"SESS",SessRowId)) Q:(SessRowId="")  d
		.Q:$D(^RB("RES",ResRowId,"DATE",DateRowId,"SESS",SessRowId))=10
		.S SessRowid=ResDateRowId_"||"_SessRowId
		.S SessDOWRowid=$p(^RB("RES",ResRowId,"DATE",DateRowId,"SESS",SessRowId),"^",2)
		.i SessDOWRowid'="" s SessDOW=$P(^CT("DOW",1,SessDOWRowid),"^",1)
		.S SessTimeStart=$p(^RB("RES",ResRowId,"DATE",DateRowId,"SESS",SessRowId),"^",4)
		.s SessTimeStartNum=SessTimeStart
		.i SessTimeStart'="" s SessTimeStart=..%ZT(SessTimeStart)
		.S SessTimeEnd=$p(^RB("RES",ResRowId,"DATE",DateRowId,"SESS",SessRowId),"^",5)
		.i SessTimeEnd'="" s SessTimeEnd=..%ZT(SessTimeEnd)
		.S SessSlotLength=+$p(^RB("RES",ResRowId,"DATE",DateRowId,"SESS",SessRowId),"^",7)
		.S SessLoad=+$p(^RB("RES",ResRowId,"DATE",DateRowId,"SESS",SessRowId),"^",8)
		.S SessNoSlots=+$p(^RB("RES",ResRowId,"DATE",DateRowId,"SESS",SessRowId),"^",6)
		.S SessNoApptSlot=+$p(^RB("RES",ResRowId,"DATE",DateRowId,"SESS",SessRowId),"^",1)
		.S SessNumberOfWeeks=+$p(^RB("RES",ResRowId,"DATE",DateRowId,"SESS",SessRowId),"^",21)
		.S SessNoOverbookAll=+$p(^RB("RES",ResRowId,"DATE",DateRowId,"SESS",SessRowId),"^",14)
		.s SessRoom=""
		.S SessRoomRowid=$p(^RB("RES",ResRowId,"DATE",DateRowId,"SESS",SessRowId),"^",19)
		.i SessRoomRowid'="" s SessRoom=$p(^CTLOC(SessRoomRowid),"^",2)
		.s SessType=""
		.S SessTypeRowid=$p(^RB("RES",ResRowId,"DATE",DateRowId,"SESS",SessRowId),"^",9)
		.i SessTypeRowid'="" s SessType=$P(^RBC("SESS",SessTypeRowid),"^",2)
		.s SessClinicGroup=""
		.S SessClinicGroupRowid=$p(^RB("RES",ResRowId,"DATE",DateRowId,"SESS",SessRowId),"^",35)
		.i SessClinicGroupRowid'="" s SessClinicGroup=$P($g(^RBC("CLGRP",SessClinicGroupRowid)),"^",2)
		.S SessPatientType=+$p(^RB("RES",ResRowId,"DATE",DateRowId,"SESS",SessRowId),"^",11)
		.;SessNo代表上午,下午,晚上等的时间分段
		.;S TRRowId=..GetTimeRangeByTime(SessTimeStartNum)
		.s TRRowId=$p(^RB("RES",ResRowId,"DATE",DateRowId,"SESS",SessRowId),"^",3)
		.if TRRowId'="" s TRDesc=$P(^DHCTimeRange(TRRowId),"^",2)
		.e  s TRDesc="其他"
		.S SessScheduleGenerFlag=$p(^RB("RES",ResRowId,"DATE",DateRowId,"SESS",SessRowId),"^",16)
		.d OutputRow3

 } 	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow3
	set Data=$lb(SessRowid,SessDOW,SessTimeStart,SessTimeEnd,SessSlotLength,SessLoad,SessNoSlots,SessNoApptSlot,SessNumberOfWeeks,SessNoOverbookAll,SessRoom,SessType,SessClinicGroup,SessPatientType,SessRoomRowid,SessTypeRowid,SessClinicGroupRowid,SessDOWRowid,TRDesc,TRRowId,SessScheduleGenerFlag)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Quit
ResetVariables3
	set (SessRowid,SessDOW,SessTimeStart,SessTimeEnd,SessSlotLength,SessLoad,SessNoSlots,SessNoApptSlot,SessNumberOfWeeks,SessNoOverbookAll,SessRoom,SessType,SessClinicGroup,SessPatientType,SessRoomRowid,SessTypeRowid,SessClinicGroupRowid,SessDOWRowid,TRDesc,TRRowId,SessScheduleGenerFlag)=""
	quit
}

ClassMethod GetResSessionsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetResSessionsExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	//
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

ClassMethod GetRoomStr() As %String
{
	Set rset=##class(%ResultSet).%New("web.DHCRBResSession:LookUpRoom")
	do rset.Execute("")
	Set columns = rset.GetColumnCount()
	set ret=""_$C(1)_"-"
	While (rset.Next()) {
		s RowId=rset.GetData(3)
		s Alias=$P(^CTLOC(RowId),"^",43)
		s Desc=rset.GetData(1)
		s AliasW=""
		i $l(Desc,"-")>1 s AliasW=$P(Desc,"-",1) s Desc=$P(Desc,"-",2)
		i AliasW'="" s Alias=AliasW
		s TRData=RowId_$C(1)_Desc_"-"_Alias
		i ret="" s ret=TRData
		e  s ret=ret_"^"_TRData
	}
	Q ret
}

ClassMethod GetSessPrice(ResSessRowId As %String, CPRowId As %String) As %Float
{
	//CPRowId:CT_CareProvid,医生的Rowid
	s TotalPrice=0
	i ResSessRowId'="" {
		s ResRowId=$P(ResSessRowId,"||",1)
		s DateRowId=$P(ResSessRowId,"||",2)
		s SessRowId=$P(ResSessRowId,"||",3)
		//s SerRowId=0  f  s SerRowId=$O(^RB("RES",ResRowId,"DATE",DateRowId,"SESS",SessRowId,"SER",SerRowId)) Q:SerRowId=""  d
		.//s SERRBCServiceDR=$P(^RB("RES",ResRowId,"DATE",DateRowId,"SESS",SessRowId,"SER",SerRowId),"^",1)
		s SERRBCServiceDR=$P(^RB("RES",ResRowId,"DATE",DateRowId,"SESS",SessRowId),"^",1)
		i SERRBCServiceDR'="" d
		.s ArcimRowid=$P(^RBC("SER",SERRBCServiceDR),"^",1)
		.i ArcimRowid'="" d
		..s SttDate=..%SysDate()
		..s retPrice=##class(web.UDHCJFPRICE).GetOrderPrice("", "", ArcimRowid, SttDate, "", "", "", "")
		..s Price=$P(retPrice,"^",1)
		..s TotalPrice=TotalPrice+Price 
	}else{
		s SerRowid=0  f  s SerRowid=$O(^RBC("SER",0,"CTCP",CPRowId,SerRowid)) q:SerRowid=""  d
		.s ARCIMRowid=$P(^RBC("SER",SerRowid),"^",1)
		.s ARCOSRowid=$P(^RBC("SER",SerRowid),"^",2)
		.i ARCIMRowid'="" d
		..s SttDate=..%SysDate()
		..s retPrice=##class(web.UDHCJFPRICE).GetOrderPrice("", "", ARCIMRowid, SttDate, "", "", "", "")
		..s Price=$P(retPrice,"^",1)
		..s TotalPrice=TotalPrice+Price 
	}
	Q $fn(TotalPrice,"",4)
}

ClassMethod GetSessionTimeRange(Code As %String) As %String
{
	s Desc=""
	i (Code=1) s Desc="上午"
	i (Code=2) s Desc="下午"
	i (Code=3) s Desc="晚上"
	Q Desc
}

ClassMethod GetSessionTypeStr() As %String
{
	s ret=""
	S RowId=0 f  s RowId=$O(^RBC("SESS",RowId)) Q:(RowId="")  d
	.s Desc=$P(^RBC("SESS",RowId),"^",2)
	.i ret="" s ret=RowId_$C(1)_Desc
	.e  s ret=ret_"^"_RowId_$C(1)_Desc
	Q ret
}

ClassMethod GetTRTimeStrByRowId(TRRowId As %String) As %String
{
	s TRStartTime=$P(^DHCTimeRange(TRRowId),"^",3)
	i TRStartTime'="" s TRStartTime=..%ZT(TRStartTime)
	s TREndTime=$P(^DHCTimeRange(TRRowId),"^",4)
	i TREndTime'="" s TREndTime=..%ZT(TREndTime)
	Q TRStartTime_"^"_TREndTime
}

ClassMethod GetTimeRangeByCode(FindCode As %String) As %String
{
	;w ##class(web.DHCRBResSession).GetTimeRangeByCode(1)
	s find=0,ret=""
	s TRRowId=0  f  s TRRowId=$O(^DHCTimeRange(TRRowId)) Q:(TRRowId="")!(find=1)  d
	.s TRCode=$P(^DHCTimeRange(TRRowId),"^",1)
	.i (TRCode=FindCode) d
	..s find=1
	..s ret=TRRowId
	.Q:find=1
	Q ret
}

ClassMethod GetTimeRangeByTimeBak(SessTime As %String) As %String
{
	Q ..GetTimeRangeByTime(SessTime)
}

ClassMethod GetTimeRangeByTime(SessTime As %String = "", HospId As %String = "") As %String
{
	s HospId=##Class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(HospId)
	 S TimeRangStr=##class(web.DHCRBApptSchedule).GetTimeRangeStrByTime(SessTime,HospId)
	 b ;0934
	 s RangeLong=$L(TimeRangStr,"!")
	 for i=1:1:RangeLong
	 {
		 s RangeID=$P(TimeRangStr,"!",i)
		 continue:RangeID=""
		 s StartTime=$P(^DHCTimeRange(RangeID),"^",3)
		 s EndTime=$P(^DHCTimeRange(RangeID),"^",4)
		 s sub=(EndTime-StartTime)
		 s TempTimRang(sub)=RangeID
	 }
	 s myTimeRangeID=""
	 s SubID=$O(TempTimRang(0))
	 i SubID'="" s myTimeRangeID=$G(TempTimRang(SubID))
	 Q myTimeRangeID
}

/// zzz 20160816 获取当前时间对应的时段串
ClassMethod GetTimeRangeStrByTime(SessTime As %String = "") As %String
{
	
	 S TimeRangStr=##class(web.DHCRBApptSchedule).GetTimeRangeStrByTime(SessTime)
	 s RangeLong=$L(TimeRangStr,"!")
	 for i=1:1:RangeLong
	 {
		 s RangeID=$P(TimeRangStr,"!",i)
		 continue:RangeID=""
		 s StartTime=$P(^DHCTimeRange(RangeID),"^",3)
		 s EndTime=$P(^DHCTimeRange(RangeID),"^",4)
		 s sub=(EndTime-StartTime)
		 s TempTimRang(sub)=RangeID
	 }
	 s myTimeRangeID=""
	 s SubID=0 f  s SubID=$O(TempTimRang(SubID)) q:SubID=""  do
	 .if myTimeRangeID="" s myTimeRangeID=$G(TempTimRang(SubID))
	 .else  s myTimeRangeID=myTimeRangeID_"^"_$G(TempTimRang(SubID))
	 Q myTimeRangeID
}

/// /只给预约挂号用
ClassMethod GetTimeRangeStr(HospID = "") As %String
{
	s HospID=##class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(HospID)
	s ret=""
	s TRRowId=0  f  s TRRowId=$O(^DHCTimeRange(TRRowId)) Q:(TRRowId="")  d
	.s TRDesc=$P(^DHCTimeRange(TRRowId),"^",2)
	.s TRCode=$P(^DHCTimeRange(TRRowId),"^",1)
	.s UseStDate=$P(^DHCTimeRange(TRRowId),"^",7)
	.Q:(UseStDate>+$H)&&(UseStDate'="")
	.s UseEndDate=$P(^DHCTimeRange(TRRowId),"^",8)
	.Q:(UseEndDate<+$H)&&(UseEndDate'="")
	.Q:"N"=##class(DHCDoc.Common.Hospital).GetHospShowDataFlag("DHC_TimeRange",TRRowId,HospID)
	.s TRStartTime=$P(^DHCTimeRange(TRRowId),"^",3)
	.i TRStartTime'="" s TRStartTime=..%ZT(TRStartTime)
	.s TREndTime=$P(^DHCTimeRange(TRRowId),"^",4)
	.i TREndTime'="" s TREndTime=..%ZT(TREndTime)
	.s TRData=TRRowId_$C(1)_TRDesc_"-"_TRCode
	.;s TRData=TRRowId_$C(2)_TRStartTime_$C(2)_TREndTime_$C(1)_TRDesc_"-"_TRCode
	.i ret="" s ret=TRData
	.e  s ret=ret_"^"_TRData
	Q ret
}

ClassMethod GetValidEffectDateRowId(ResRowId As %String) As %String
{
	s ValidDateFrom=0
	s ValidRowid=""
 	Set DateRowId=0 f  s DateRowId=$O(^RB("RES",ResRowId,"DATE",DateRowId)) q:(DateRowId="")  d
	.Set DateFrom=$P($G(^RB("RES",ResRowId,"DATE",DateRowId)),"^",1)
	.Quit:DateFrom=""
	.Set RowId=ResRowId_"||"_DateRowId
	.if DateFrom>ValidDateFrom d
	..Set ValidDateFrom=DateFrom
	..Set ValidRowid=RowId
	Q ValidRowid
}

ClassMethod Insert(ResDateRowid As %String, Para As %String) As %String
{
	;s ^zhou("insert")=ResDateRowid_","_Para
	;w ##class(web.DHCRBResSession).Insert("832||1","^1"_$C(1)_"星期一^08:00:00^11:00:00^^0^0^0^^^550"_$C(1)_"结核科病房01诊室^1"_$C(1)_"主治医师^43"_$C(1)_"呼吸内科^O^7"_$C(1)_"上午^Y")
	;n (ResDateRowid,Para)
	k PLIST
	s Flag=..GetSubmitFlag(ResDateRowid)
	q:Flag="S" "-1^HandSubmit"
	//s ResDateRowid=^zhou("insert1")
	//s Para=^zhou("insert2")
	Set TempStr=$P(Para,"^",2)
	Set SessDOWRowid=$P(TempStr,$C(1),1)
	Set SessDOW=$P(TempStr,$C(1),2)
	
	Set SessTimeStart=$P(Para,"^",3)
	if SessTimeStart'="" s SessTimeStart=..%ZTH(SessTimeStart)
	Set SessTimeEnd=$P(Para,"^",4)
	if SessTimeEnd'="" s SessTimeEnd=..%ZTH(SessTimeEnd)
	Set SessSlotLength=$P(Para,"^",5)
	Set SessLoad=$P(Para,"^",6)
	Set SessNoSlots=$P(Para,"^",7)
	Set SessNoApptSlot=$P(Para,"^",8)
	Set SessNumberOfWeeks=$P(Para,"^",9)
	Set SessNoOverbookAllowed=$P(Para,"^",10)

	Set TempStr=$P(Para,"^",11)
	Set SessRoomRowid=$P(TempStr,$C(1),1)
	Set SessRoom=$P(TempStr,$C(1),2)

	Set TempStr=$P(Para,"^",12)
	Set SessTypeRowid=$P(TempStr,$C(1),1)
	Set SessType=$P(TempStr,$C(1),2)
	Set TempStr=$P(Para,"^",13)
	Set SessClinicGroupRowid=$P(TempStr,$C(1),1)
	Set SessClinicGroup=$P(TempStr,$C(1),2)

	Set SessPatientType=$P(Para,"^",14)
	
	Set TempStr=$P(Para,"^",15)
	Set TRRowId=$P(TempStr,$C(1),1)
	Set TRDesc=$P(TempStr,$C(1),2)
	
	Set SessScheduleGenerFlag=$P(Para,"^",16)
	Set SESSNoLimitLoadFlag=$P(Para,"^",26)
	;if SessScheduleGenerFlag="Y" s SessScheduleGenerFlag="Yes"
	;if SessScheduleGenerFlag="N" s SessScheduleGenerFlag="No"
	i TRRowId'="" d
    .i SessTimeStart=""  s SessStartTime=$P(^DHCTimeRange(TRRowId),"^",3)
	.i SessTimeEnd=""    s SessEndTime=$P(^DHCTimeRange(TRRowId),"^",4)
	s ResRowId=+ResDateRowid
	s obj=##class(User.RBResource).%OpenId(ResRowId)
	s ResType=obj.RESType
	d obj.%Close()
	s ScheduleLinesId=$p(^RB("RES",ResRowId,"DATE",$p(ResDateRowid,"||",2)),"^",2)
	s sameroom=""
	if ResType'="Equipment" {
		s RowIdStr=..FindSessionByWeekTRRoom(SessDOWRowid,TRRowId,SessRoomRowid,"",ScheduleLinesId)
		if (RowIdStr'="")&&(SessScheduleGenerFlag'="N") {
			f roomSeq=1:1:$l(RowIdStr,"^"){
				s DulSessRowId=$P(RowIdStr,"^",roomSeq)
				s DulResRowId=$P(DulSessRowId,"||",1)
				s DulResDocRowId=$p(^RB("RES",DulResRowId),"^",2)
				s DulResLocRowId=$p(^RB("RES",DulResRowId),"^",1)
				s DulResDocDesc=$p(^CTPCP(DulResDocRowId,1),"^",2)
				s DulResLocDesc=$p($g(^CTLOC(DulResLocRowId)),"^",2)
				//Q "-201"_"^"_DulResLocDesc_DulResDocDesc
				i sameroom="" s sameroom=DulResLocDesc_DulResDocDesc
				e  s sameroom=sameroom_$c(13)_DulResLocDesc_DulResDocDesc
			}
		}
	}
	Q:sameroom'="" "-201^"_sameroom
	// SessDOWRowid 代表节假日模板
	Set SessDOWHoliRowid=SessDOWRowid
	if (SessDOWRowid>7){
		Set SessDOWRowid=""
	}
	Set PLIST(0)=ResDateRowid
	Set PLIST(10)=SessDOWRowid
	Set PLIST(4)=SessTimeStart
	Set PLIST(5)=SessTimeEnd
	Set PLIST(7)=SessSlotLength
	Set PLIST(8)=SessLoad
	Set SessNoSlots=SessLoad-SessNoApptSlot
	Set PLIST(6)=SessNoSlots
	Set PLIST(9)=SessNoApptSlot
	Set PLIST(23)=SessNumberOfWeeks
	Set PLIST(16)=SessNoOverbookAllowed
	Set PLIST(21)=SessRoomRowid
	Set PLIST(11)=SessTypeRowid
	if +SessClinicGroupRowid>0 Set PLIST(37)=+SessClinicGroupRowid
	Set PLIST(13)=SessPatientType
	Set PLIST(18)=SessScheduleGenerFlag
	Set PLIST(3)=TRRowId
	Set PLIST(43)=SessDOWHoliRowid //假日模板
	Set PLIST(44)=SessClinicGroupRowid 
	Set PLIST(45)=SESSNoLimitLoadFlag 
	
	&SQL(Insert Into SQLUser.RB_ResEffDateSession values :PLIST())
	s RowId=""
	i SQLCODE=0 {
		s RowId=%ROWID
		s length=$L(Para,"^")
		s ^RB("RES",+RowId,"DATE",$P(RowId,"||",2),"SESS",$P(RowId,"||",3),"DHC")=$P(Para,"^",17,25)
		;医生站业务数据修改日志
		set NewDataJson=##class(web.DHCDocDataChangeLog).GetLogJsonData("User.RBResEffDateSession"_$c(2)_RowId)
		set ret=##class(web.DHCDocDataChangeLog).SaveLog("User.RBResEffDateSession","User.RBResEffDateSession","排班模板信息","User.RBResEffDateSession_"_RowId,$p($g(^RB("RES",+RowId)),"^",17),"A",NewDataJson,"")

	}
	s rtnCode=SQLCODE
	if (rtnCode=0) {
		//自动插入实名制医生号别对照
		d ##class(DHCDoc.DHCDocConfig.CommonFunction).AutoInsertMarkDoc(+RowId)
		//自动插入分诊区号别对照号别对照
		d ##class(DHCDoc.DHCDocConfig.CommonFunction).AutoInsertDepMark(+RowId)
	}
 	Q rtnCode_"^"_RowId_"^"_sameroom
}

ClassMethod InsertEffDate(ResRowId As %String, Para As %String, ScheduleLinesRowId As %String = "") As %String
{
	;w ##class(web.DHCRBResSession).InsertEffDate(1095,"12/11/2007")
	;n (ResDateRowid,Para)
	k PLIST
	set EffDate=$ZDH(Para,4)
	Set PLIST(0)=ResRowId
	Set PLIST(3)=EffDate
	Set PLIST(4)=ScheduleLinesRowId
	&SQL(Insert Into SQLUser.RB_ResEffDate values :PLIST())
	Q SQLCODE_"^"_%ROWID
}

ClassMethod LookUpRoomBroker(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "") As %Library.Boolean
{
	Set rset=##class(%ResultSet).%New("web.DHCRBResSession:LookUpRoom")
	do rset.Execute(val)
	Set columns = rset.GetColumnCount()
	set row=0
	set ret=""
	While (rset.Next()) {
	    For col = 1:1:columns {
		   i ret="" s ret=rset.GetData(col)
	       e  s ret= ret_"^"_rset.GetData(col)
	    }
	    s row=row+1
	    If row=1 Quit
	}
	d rset.Close()
	if row>0 {
		s retval=itmjs_"('"_$ZCVT(ret,"O","JS")_"');"
		i itmjsex'="""" s retval=retval_itmjsex_"('"_$ZCVT(ret,"O","JS")_"');"
		&javascript<#(retval)#>
	}
	Q row
}

ClassMethod ResDocListBroker(itmjs As %Library.String = "", val As %Library.String = "", Type As %String = "", UserID As %String = "", DataType As %String = "ResID")
{
	;w ##class(web.DHCRBResSession).ResDocListBroker("",82,"EQ")
	s desc=""
	Set rs=##Class(%ResultSet).%New("web.DHCRBResSession:FindResDoc")
	If rs.QueryIsValid() { 
		 Set Status=rs.Execute(val,Type,UserID)
		 If 'Status Quit
		 While rs.Next() {
			 Set DocCode=rs.GetData(2)
			 Set DocRowid=rs.GetData(3)
			 Set DocDesc=rs.GetData(1)
			 Set ResRowid=rs.GetData(4)
			 i DataType = "ResID" d
			 .If desc="" Set desc=ResRowid_$c(1)_DocDesc
			 .Else  Set desc=desc_"^"_ResRowid_$c(1)_DocDesc
			 e  d
			 .If desc="" Set desc=DocRowid_$c(1)_DocDesc
			 .Else  Set desc=desc_"^"_DocRowid_$c(1)_DocDesc
		 }
	}
	Q:desc="" 1
	s retval=itmjs_"('"_$ZCVT(desc,"O","JS")_"');"
	&javascript<#(retval)#>
	Q desc
}

ClassMethod ResEffectDateListBroker(itmjs As %Library.String = "", val As %Library.String = "")
{
	s desc=""
	Set rs=##Class(%ResultSet).%New("web.DHCRBResSession:FindResEffectDate")
	If rs.QueryIsValid() { 
		 Set Status=rs.Execute(val)
		 If 'Status Quit
		 While rs.Next() {
			 Set DateDesc=$zd($zdh(rs.GetData(1)),4)
			 Set ResDateRowid=rs.GetData(2)
			 If desc="" Set desc=ResDateRowid_$c(1)_DateDesc
			 Else  Set desc=desc_"^"_ResDateRowid_$c(1)_DateDesc
		 }
	}
	//Q:desc="" 1
	if desc=""{
		;ResRowId
		s LocID=$P(^RB("RES",val),"^",1)
		s n=$O(^DHCOPLocResEffDate(LocID,""),-1)
		i n="" d
		.s ^DHCOPLocResEffDate(LocID,1)=..%SysDate()_"^N"
		.s n=1
		
		s Date=$G(^DHCOPResEffDate(LocID,n))
		s Date=$P(Date,"^",1)
		i +Date=0 s Date=..%SysDate()
		s Date=$ZD(Date,4)
		s ret=..InsertEffDate(val,Date)
		;i ret=0{
		s ResDateRowid=$P(ret,"^",2)
		s desc=ResDateRowid_$c(1)_Date
		;}
		
	}
	
	s retval=itmjs_"('"_$ZCVT(desc,"O","JS")_"');"
	&javascript<#(retval)#>
	Q desc
}

ClassMethod ResSessionListBroker(itmjs As %Library.String = "", val As %Library.String = "")
{
	s ^zhou("val")=val
	;w ##class(web.DHCRBResSession).ResSessionListBroker("","244||1")
	s desc=""
	Set rs=##Class(%ResultSet).%New("web.DHCRBResSession:GetResSessions")
	If rs.QueryIsValid() { 
		 Set Status=rs.Execute(val)
		 If 'Status Quit
		 While rs.Next() {
			;sessRowid,SessDOW,SessTimeStart,SessTimeEnd,SessSlotLength,
			;SessLoad,SessNoSlots,SessNoApptSlot,SessNumberOfWeeks,
			;SessNoOverbookAll,SessRoom,SessType,SessClinicGroup,
			;SessPatientType,SessRoomRowid,SessTypeRowid,SessClinicGroupRowid
			Set SessRowid=rs.GetData(1)
			Set SessDOW=rs.GetData(2)
			Set SessTimeStart=rs.GetData(3)
			Set SessTimeEnd=rs.GetData(4)
			Set SessSlotLength=rs.GetData(5)
			Set SessLoad=rs.GetData(6)
			Set SessNoSlots=rs.GetData(7)
			Set SessNoApptSlot=rs.GetData(8)
			Set SessNumberOfWeeks=rs.GetData(9)
			Set SessNoOverbookAll=rs.GetData(10)
			Set SessRoom=rs.GetData(11)
			Set SessType=rs.GetData(12)
			Set SessClinicGroup=rs.GetData(13)
			Set SessPatientType=rs.GetData(14)
			Set SessRoomRowid=rs.GetData(15)
			Set SessTypeRowid=rs.GetData(16)
			Set SessClinicGroupRowid=rs.GetData(17)
			Set SessDOWRowid=rs.GetData(18)
			Set SessNo=rs.GetData(19)
			Set SessNoCode=rs.GetData(20)
			Set SessScheduleGenerFlag=rs.GetData(21)

			Set SessDOW=SessDOWRowid_$C(1)_SessDOW
			Set SessRoom=SessRoomRowid_$C(1)_SessRoom
			Set SessType=SessTypeRowid_$C(1)_SessType
			Set SessClinicGroup=SessClinicGroupRowid_$C(1)_SessClinicGroup
			Set SessNo=SessNoCode_$C(1)_SessNo
			
			s val=SessRowid_"^"_SessDOW_"^"_SessTimeStart_"^"_SessTimeEnd_"^"_SessSlotLength_"^"_SessLoad_"^"_SessNoSlots_"^"_SessNoApptSlot_"^"_SessNumberOfWeeks_"^"_SessNoOverbookAll_"^"_SessRoom_"^"_SessType_"^"_SessClinicGroup_"^"_SessPatientType_"^"_SessNo_"^"_SessScheduleGenerFlag
			s TRInfo=$G(^RB("RES",+SessRowid,"DATE",$P(SessRowid,"||",2),"SESS",$P(SessRowid,"||",3),"DHC"))
			s:TRInfo="" TRInfo="^^^^^^"
			s val=val_"^"_TRInfo
			s retval=itmjs_"('"_$ZCVT(val,"O","JS")_"');"
			&javascript<#(retval)#>
			 ;If desc="" Set desc=ResDateRowid_$c(1)_DateDesc
			 ;Else  Set desc=desc_"^"_ResDateRowid_$c(1)_DateDesc
		 }
	}
	Q 1
}

ClassMethod SessionListBroker(itmjs As %Library.String = "", val As %Library.String = "")
{
	s desc=""
	Set rs=##Class(%ResultSet).%New("web.DHCRBResSession:FindResEffectDate")
	If rs.QueryIsValid() { 
		 Set Status=rs.Execute(val)
		 If 'Status Quit
		 While rs.Next() {
			 Set ResDateRowid=rs.GetData(2)
		 }
		Set rs=##Class(%ResultSet).%New("web.DHCRBResSession:GetResSessions")
		If rs.QueryIsValid() { 
			 Set Status=rs.Execute(ResDateRowid)
			 If 'Status Quit
			 While rs.Next() {
				 Set SessionRowId=rs.GetData(1)
				 Set SessionDOW=rs.GetData(2)
				 If desc="" Set desc=SessionRowId_$c(1)_SessionDOW
				 Else  Set desc=desc_"^"_SessionRowId_$c(1)_SessionDOW
			 }
			 
		}
	}
	Q:desc="" 1
	s retval=itmjs_"('"_$ZCVT(desc,"O","JS")_"');"
	&javascript<#(retval)#>
	Q 1
}

ClassMethod Update(Para As %String) As %String
{
	Set SessRowid=$P(Para,"^",1)
	Q:SessRowid="" 100
	s Flag=..GetSubmitFlag(SessRowid)
	q:Flag="S" "-1^HandSubmit"
	
	s ret=0
	Set TempStr=$P(Para,"^",13)
	Set SessClinicGroupRowid=$P(TempStr,$C(1),1)
	Set SessClinicGroup=$P(TempStr,$C(1),2)
	s ResRowid=+SessRowid,DateSub=$P(SessRowid,"||",2),SessSub=$P(SessRowid,"||",3)
	s TRSub=0 f {
		s TRSub=$O(^RB("RES",ResRowid,"DATE",DateSub,"SESS",SessSub,"TR",TRSub))
		q:TRSub=""
		s TRAMSub=0 f  {
			s TRAMSub=$O(^RB("RES",ResRowid,"DATE",DateSub,"SESS",SessSub,"TR",TRSub,"TRCG",TRAMSub)) 
			Q:TRAMSub=""
			s ClinicDr=$p(^(TRAMSub),"^",1)
			if (","_SessClinicGroupRowid_",")'[(","_ClinicDr_",") {
				s ret="-206"
				q
			}
		}
	}
	q:ret'=0 ret
	
	
	Set TempStr=$P(Para,"^",2)
	Set SessDOWRowid=$P(TempStr,$C(1),1)
	Set SessDOW=$P(TempStr,$C(1),2)
	
	Set SessTimeStart=$P(Para,"^",3)
	if SessTimeStart'="" s SessTimeStart=..%ZTH(SessTimeStart)
	Set SessTimeEnd=$P(Para,"^",4)
	if SessTimeEnd'="" s SessTimeEnd=..%ZTH(SessTimeEnd)
	Set SessSlotLength=$P(Para,"^",5)
	Set SessLoad=$P(Para,"^",6)
	Set SessNoSlots=$P(Para,"^",7)
	Set SessNoApptSlot=$P(Para,"^",8)
	Set SessNumberOfWeeks=$P(Para,"^",9)
	Set SessNoOverbookAllowed=$P(Para,"^",10)

	Set TempStr=$P(Para,"^",11)
	Set SessRoomRowid=$P(TempStr,$C(1),1)
	Set SessRoom=$P(TempStr,$C(1),2)

	Set TempStr=$P(Para,"^",12)
	Set SessTypeRowid=$P(TempStr,$C(1),1)
	Set SessType=$P(TempStr,$C(1),2)

	Set SessPatientType=$P(Para,"^",14)
	
	Set TempStr=$P(Para,"^",15)
	Set TRRowId=$P(TempStr,$C(1),1)
	Set TRDesc=$P(TempStr,$C(1),2)
    i TRRowId'="" d                                                         //add by 20110716
     .i SessTimeStart=""  s SessTimeStart=$P(^DHCTimeRange(TRRowId),"^",3)   //add by 20110716
	 .i SessTimeEnd=""    s SessTimeEnd=$P(^DHCTimeRange(TRRowId),"^",4)      //add by 20110716
	Set SessScheduleGenerFlag=$P(Para,"^",16)
	Set SESSNoLimitLoadFlag=$P(Para,"^",26)
	set OldDataJson=##class(web.DHCDocDataChangeLog).GetLogJsonData("User.RBResEffDateSession"_$c(2)_SessRowid)
	s ResRowId=+SessRowid
	s obj=##class(User.RBResource).%OpenId(ResRowId)
	s ResType=obj.RESType
	d obj.%Close()
	s ScheduleLinesId=$p(^RB("RES",ResRowId,"DATE",$p(SessRowid,"||",2)),"^",2)
	s sameroom=""
	if ResType'="Equipment" {
		s RowIdStr=..FindSessionByWeekTRRoom(SessDOWRowid,TRRowId,SessRoomRowid,SessRowid,ScheduleLinesId)
		if (RowIdStr'="")&&(SessScheduleGenerFlag'="N") {
			f roomSeq=1:1:$l(RowIdStr,"^"){
				s DulSessRowId=$P(RowIdStr,"^",roomSeq)
				s DulResRowId=$P(DulSessRowId,"||",1)
				s DulResDocRowId=$p(^RB("RES",DulResRowId),"^",2)
				s DulResLocRowId=$p(^RB("RES",DulResRowId),"^",1)
				s DulResDocDesc=$p(^CTPCP(DulResDocRowId,1),"^",2)
				s DulResLocDesc=$p($g(^CTLOC(DulResLocRowId)),"^",2)
				//Q "-201"_"^"_DulResLocDesc_DulResDocDesc
				i sameroom="" s sameroom=DulResLocDesc_DulResDocDesc
				e  s sameroom=sameroom_$c(13)_DulResLocDesc_DulResDocDesc
			}
		}
	}
	Q:sameroom'="" "-201^"_sameroom
	Set SessDOWHoliRowid=SessDOWRowid
	if (SessDOWRowid>7){
		Set SessDOWRowid=""
	}
	Set SessNoSlots=SessLoad-SessNoApptSlot
	Set object = ##class(User.RBResEffDateSession).%OpenId(SessRowid)
	 Do object.SESSDOWDRSetObjectId(SessDOWRowid)
	 Do object.SESSRoomDRSetObjectId(SessRoomRowid)
	 Do object.SESSSessionTypeDRSetObjectId(SessTypeRowid)
	 if +SessClinicGroupRowid>0{
	 	Do object.SESSClinicGroupDRSetObjectId(+SessClinicGroupRowid)
	 }
	 s object.SESSClinicGroupDRStr=SessClinicGroupRowid
	 s object.SESSTimeStart=SessTimeStart
	 s object.SESSTimeEnd=SessTimeEnd
	 s object.SESSSlotLength=SessSlotLength
	 s object.SESSLoad=SessLoad
	 s object.SESSNoSlots=SessNoSlots
	 s object.SESSNoApptSlot=SessNoApptSlot
	 s object.SESSNumberOfWeeks=SessNumberOfWeeks
	 s object.SESSNoOverbookAllowed=SessNoOverbookAllowed
	 s object.SESSPatientType=SessPatientType
	 s object.SESSSessionNo=TRRowId
	 s object.SESSScheduleGenerFlag=SessScheduleGenerFlag
	 s object.SESSHolidayWeek=SessDOWHoliRowid
	 s object.SESSNoLimitLoadFlag=SESSNoLimitLoadFlag
	 Set sc = object.%Save()
	 If $$$ISERR(sc) {
		 Do $System.Status.DisplayError(sc)
		 Quit 100
	 }
	 set NewDataJson=##class(web.DHCDocDataChangeLog).GetLogJsonData("User.RBResEffDateSession"_$c(2)_SessRowid)
	 set ret=##class(web.DHCDocDataChangeLog).SaveLog("User.RBResEffDateSession","User.RBResEffDateSession","排班模板信息","User.RBResEffDateSession_"_SessRowid,$p($g(^RB("RES",+SessRowid)),"^",17),"U",NewDataJson,OldDataJson)
	 s length=$L(Para,"^")
	 s ^RB("RES",+SessRowid,"DATE",$P(SessRowid,"||",2),"SESS",$P(SessRowid,"||",3),"DHC")=$P(Para,"^",17,25)
	 Q 0_"^"_sameroom
	;&SQL(Select * Into :PLIST() From )
	;&SQL(UpDate SQLUser.RB_ResEffDateSession set  From  Where SESS_RowId=:Rowid )
}

Query FindAllResDoc() As %Library.SQLQuery(CONTAINID = 3, ROWSPEC = "Desc:%String,Code:%String,HIDDEN:%String,HIDDEN:%String")
{
	SELECT RES_CTPCP_DR->CTPCP_Desc ,RES_CTPCP_DR->CTPCP_Code,RES_CTPCP_DR->CTPCP_RowId,RES_RowId FROM SQLUser.RB_Resource
	Where RES_ScheduleRequired='Y' AND (RES_DateActiveTo is null OR RES_DateActiveTo>=+$H) AND (RES_DateActiveFrom is null OR RES_DateActiveFrom<=+$H)
}

Query FindLoc(Loc As %String, UserID As %String = "", HospitalDr As %String = "") As %Query(ROWSPEC = "Desc:%String,Code:%String,Hidden:%String,Alias:%String") [ SqlProc ]
{
}

Query FindResDoc(DepID As %String, Type As %String = "", UserID As %String = "", Group As %String = "", MarkCodeName As %String = "", HospID = "") As %Query(ROWSPEC = "Desc:%String,Code:%String,Hidden1:%String,Hidden2:%String") [ SqlProc ]
{
}

Query FindResEffectDate(ResRowId As %String) As %Query(ROWSPEC = "Desc:%String,Hidden:%String") [ SqlProc ]
{
}

Query GetResSessions(ResDateRowId As %String) As %Library.Query(CONTAINID = "", ROWSPEC = "SessRowid:%String,SessDOW:%String,SessTimeStart:%String,SessTimeEnd:%String,SessSlotLength:%String,SessLoad:%String,SessNoSlots:%String,SessNoApptSlot:%String,SessNumberOfWeeks:%String,SessNoOverbookAll:%String,SessRoom:%String,SessType:%String,SessClinicGroup:%String,SessPatientType:%String,SessRoomRowid:%String,SessTypeRowid:%String,SessClinicGroupRowid:%String,SessDOWRowid:%String,SessNo:%String,SessNoCode:%String,SessScheduleGenerFlag:%String")
{
}

Query LookUpRoom(desc As %String, HospRowId As %String = "") As %Library.SQLQuery(CONTAINID = 3, ROWSPEC = "Desc:%String,Code:%String,HIDDEN:%String")
{
	SELECT CTLOC_Desc,CTLOC_Code,CTLOC_RowId FROM SQLUser.CT_LOC 
	WHERE ((:desc is null) or(CTLOC_Desc like '%'_:desc_'%') or (CTLOC_Code like '%'_:desc_'%' )) and CTLOC_Type='OR'
	and ((CTLOC_DateActiveFrom is null) or((CTLOC_DateActiveFrom is not null) and (CTLOC_DateActiveFrom<=+$h)))
	and ((CTLOC_DateActiveTo is null) or((CTLOC_DateActiveTo is not null) and (CTLOC_DateActiveTo>+$h)))
	and (CTLOC_Hospital_DR=:HospRowId or :HospRowId is null) and (CTLOC_ActiveFlag='Y')
	ORDER BY CTLOC_Code
}

/// w ##class(web.DHCRBResSession).TRInfoCalculate("06:30:00","13:00:00",30,20)
ClassMethod TRInfoCalculate(StartDate, EndDate, TimeLength, RegNum)
{
	
	s ret=..CheckTRInfoCalculate(StartDate, EndDate, TimeLength, RegNum)
	i $P(ret,"^",1)'=-2 q ret
	s RegStr=""
	f i=1:1:60 d
	.s ret=..CheckTRInfoCalculate(StartDate, EndDate, i, RegNum)
	.i $P(ret,"^",1)=0 d
	..s RegStr=$case(RegStr,"":i,:RegStr_","_i)
	if RegStr="" q "-2^"_"无满足条件的时段间隔，请修改时段或时段起始时间后再试！"
	s RegStr="<font style=""color:red"">"_RegStr_"</font>"
	q "-2^"_"可以输入的时段间隔为："_RegStr_"；如需特定间隔分钟，请修改时段或时段起始时间后再试！"
}

// w ##class(web.DHCRBResSession).TRInfoCalculate("06:30:00","13:00:00",30,20)

ClassMethod CheckTRInfoCalculate(StartDate, EndDate, TimeLength, RegNum)
{
    q:(+TimeLength=0)||(+RegNum=0) "0^^"
	s StartDate=..%ZTH(StartDate,3)
	s EndDate=..%ZTH(EndDate,3)
	s TimeLength=TimeLength*60
	s TimeInterval=EndDate-StartDate
	q:TimeInterval<=0 "-1^分时段开始时间不小于结束时间"
	s mod=TimeInterval#TimeLength
	q:mod>0 "-2^分时段时间间隔数不是整数"
	s Step=TimeInterval/TimeLength
	q:Step>RegNum "-3^分时段时间间隔数不能大于分时段号数"
	s mod=RegNum#Step
	s OneStepNum=RegNum\Step
	s RegNumInfo="",TimeRangeInfo=""
	s One=1
	s OneNum=0		
	f i=1:1:Step
	{
		i i<=mod{
			s OneNum=OneNum+OneStepNum+1
		}else{
			s OneNum=OneNum+OneStepNum
		}
		s time=StartDate+((i-1)*TimeLength)
		s time2=StartDate+((i)*TimeLength)
		i RegNumInfo="" d
		.s RegNumInfo=One_"-"_OneNum
		.s TimeRangeInfo=$P(..%ZT(time,1),":",1,2)_"-"_$P(..%ZT(time2,1),":",1,2)
		e  d
		.s RegNumInfo=RegNumInfo_","_One_"-"_OneNum
		.s TimeRangeInfo=TimeRangeInfo_","_$P(..%ZT(time,1),":",1,2)_"-"_$P(..%ZT(time2,1),":",1,2)
		s One=1+OneNum
	}
	q "0^"_RegNumInfo_"^"_TimeRangeInfo
}

// S已提交

ClassMethod GetSubmitFlag(ID)
{
	s ID=+ID
	s LocID=$P(^RB("RES",ID),"^",1)
	s SubmitInfo=$G(^CTLOC(LocID,"RBSSubmit"))
	q $P(SubmitInfo,"^",1)
}

// zlj --------------------2012-12-02---------------add 得到时间段字符串

// w ##class(web.DHCRBResSession).GetTRStr()

ClassMethod GetTRStr() As %String
{
	
	s count=0
	s ret=""
	s TRRowID=""
	f  s TRRowID=$O(^DHCTempTitle("TimeRange",TRRowID)) Q:TRRowID=""  d
	.i ret=""  d
	..s ret=$G(^DHCTempTitle("TimeRange",TRRowID))
	.e  d
	..s ret=ret_"^"_$G(^DHCTempTitle("TimeRange",TRRowID))
	.s count=count+1
	s ret=count_"^"_ret
	q ret
}

// zlj --------------------2012-12-02---------------add 得到日期字符串

// w ##class(web.DHCRBResSession).GetDateStr()

ClassMethod GetDateStr() As %String
{
	
	s ret=""
	s DateRowID=""
	f  s DateRowID=$O(^DHCTempTitle("Date",DateRowID)) Q:DateRowID=""  d
	.i ret=""  d
	..s ret=$G(^DHCTempTitle("Date",DateRowID))
	.e  d
	..s ret=ret_"^"_$G(^DHCTempTitle("Date",DateRowID))	
	q ret
}

// zlj --------------------2012-12-02---------------add 得到星期字符串

// w ##class(web.DHCRBResSession).GetWeekStr()

ClassMethod GetWeekStr() As %String
{
		
	s ret=""
	s WeekRowID=""
	f  s WeekRowID=$O(^DHCTempTitle("Week",WeekRowID)) Q:WeekRowID=""  d
	.i ret=""  d
	..s ret=$G(^DHCTempTitle("Week",WeekRowID))
	.e  d
	..s ret=ret_"^"_$G(^DHCTempTitle("Week",WeekRowID))	
	q ret
}

// w ##class(web.DHCRBResSession).GetDateWeekLocation(5)

/// Creator:      张立军
/// CreatDate:    2012.12.02
/// Description:  得到日期和星期在Excel中的列坐标
/// Table:        
/// Input:        TRCount 时间段数目
/// Return:       列坐标字符串
/// Others:       列坐标初始(CurrentCol)为2前两列固定为科室、级别,通过能否被整除(Divide)判断奇偶
ClassMethod GetDateWeekLocation(TRCount As %String) As %String
{
	s CurrentCol=2
	s ret=""	
	s Divide=TRCount/2
	i $p(Divide,".",2)'=""  d
	.f i=1:1:7 d
	..s EndCol=CurrentCol+TRCount
	..s Col=EndCol+CurrentCol+1
	..s LocationCol=Col/2
	..i ret=""  d
	...s ret=LocationCol
	..e  d
	...s ret=ret_"^"_LocationCol
	..s CurrentCol=EndCol
	e  d
	.f i=1:1:7 d
	..s EndCol=CurrentCol+TRCount
	..s Col=EndCol+CurrentCol
	..s LocationCol=Col/2
	..i ret=""  d
	...s ret=LocationCol
	..e  d
	...s ret=ret_"^"_LocationCol
	..s CurrentCol=EndCol
	q ret
}

// zlj --------------------2012-12-02---------------add 得到周排版记录ID

ClassMethod GetWeekScheduleRowIDStr() As %String
{
	s count=0
	s ret=""
	s WeekScheduleRowID=""
	f  s WeekScheduleRowID=$O(^DHCTempBody("WeekSchedule",WeekScheduleRowID)) Q:WeekScheduleRowID=""  d
	.i ret=""  d
	..s ret=WeekScheduleRowID
	.e  d
	..s ret=ret_"^"_WeekScheduleRowID
	.s count=count+1
	s ret=count_"^"_ret
	q ret
}

// zlj --------------------2012-12-02---------------add 得到周排版记录串

ClassMethod GetWeekSchedule(WeekScheduleRowID As %String) As %String
{
	q $G(^DHCTempBody("WeekSchedule",WeekScheduleRowID))
}

/// w ##class(web.DHCRBResSession).TRInfoCalculateNew("08:00","12:00",60)
ClassMethod TRInfoCalculateNew(StartTime, EndTime, RegNum, StartNum)
{
	q:+RegNum=0 "0^^"
	if (+StartNum=0) Set StartNum=1
	s StartTime=..%ZTH(StartTime,3)
	s EndTime=..%ZTH(EndTime,3)
	s TimeInterval=EndTime-StartTime
	q:TimeInterval<=0 "-1^分时段开始时间不小于结束时间"
	s TimeLength=TimeInterval/(RegNum)
	Set RegNumInfo="",TimeRangeInfo=""
	s One=1
	s OneNum=0	
	Set sttime=StartTime
	Set EndNum=	RegNum+StartNum-1
	f i=StartNum:1:EndNum
	{
		s endtime=sttime+$Justify((TimeLength),1,0)	
		if i=EndNum Set endtime=EndTime
		i RegNumInfo="" d
		.s RegNumInfo=i_"-"_i
		.s TimeRangeInfo=$P(..%ZT(sttime,1),":",1,2)_"-"_$P(..%ZT(endtime,1),":",1,2)
		e  d
		.s RegNumInfo=RegNumInfo_","_i_"-"_i
		.s TimeRangeInfo=TimeRangeInfo_","_$P(..%ZT(sttime,1),":",1,2)_"-"_$P(..%ZT(endtime,1),":",1,2)
		//s One=1+OneNum
		Set sttime=endtime
	}
	q "0^"_RegNumInfo_"^"_TimeRangeInfo
}

Query LookUpRoomByUser(desc As %String, USERID As %String) As %Library.SQLQuery(CONTAINID = 3, ROWSPEC = "Desc:%String,Code:%String,HIDDEN:%String")
{
	
	SELECT CTLOC_Desc,CTLOC_Code,CTLOC_RowId FROM SQLUser.CT_LOC 
	WHERE (CTLOC_Desc %STARTSWITH :desc or CTLOC_Code=:desc ) and CTLOC_Type='OR' and 
	ctloc_rowid in(select BorExaRoomDr from SQLUser.DHCBorExaRoom where BorDr in(select BoruBorDr from SQLUser.DHCBorUser  where BoruUseDr=:USERID  ) )
	ORDER BY CTLOC_Code

/*
	SELECT CTLOC_Desc ,CTLOC_Code
    FROM SQLUser.CT_LOC 
	WHERE (CTLOC_Desc %STARTSWITH :desc) and CTLOC_Type='OR'
	ORDER BY CTLOC_Code
	*/
}

/// w ##class(web.DHCRBResSession).UpdateTimeRange()
/// 时段里的开始时间和结束时间变化的话，需要更新排班模板里的开始时间和结束时间，分时段信息
ClassMethod UpdateTimeRange()
{
	//&Sql(update SQLUSER.RB_ResEffDateSession set SESS_TimeStart=:StartTime,SESS_TimeEnd=:EndTime where sess_rowid=:SESSRowid )
	Set ResRowid=0
	Set num=0
	for  Set ResRowid=$o(^RB("RES",ResRowid)) Quit:ResRowid=""  do
	.Set DateSub=0
	.for  Set DateSub=$o(^RB("RES",ResRowid,"DATE",DateSub)) Quit:DateSub=""  do
	..Set SessSub=0
	..for  Set SessSub=$o(^RB("RES",ResRowid,"DATE",DateSub,"SESS",SessSub)) Quit:SessSub=""  do
	...Set TimeRangeId=$p(^RB("RES",ResRowid,"DATE",DateSub,"SESS",SessSub),"^",3)
	...Quit:TimeRangeId=""
	...//Quit:TimeRangeId'=2
	...Set StartTime=$p(^DHCTimeRange(TimeRangeId),"^",3)
	...Set EndTime=$p(^DHCTimeRange(TimeRangeId),"^",4)
	...//Set TRFlag=
	...Set TRInfo=^RB("RES",ResRowid,"DATE",DateSub,"SESS",SessSub,"DHC")
	...Set TRFlag=$p(TRInfo,"^",1)
	...//Quit:(TimeRangeId'=2)&&(TRFlag="Y")
	...//Quit:TRFlag'="Y"
	...//if TRFlag'="Y" w TRInfo,!
	...Set SESSRowid=ResRowid_"||"_DateSub_"||"_SessSub
	...Set RegNum=$p(TRInfo,"^",5)
	...if +RegNum=0 Set RegNum=+$p(^RB("RES",ResRowid,"DATE",DateSub,"SESS",SessSub),"^",1)
	...Set StartNum=$p(^RB("RES",ResRowid,"DATE",DateSub,"SESS",SessSub),"^",21)
	...if +RegNum=0 do
	....//w SESSRowid,!
	...//Quit:+RegNum=0
	...s info=..TRInfoCalculateNew(..%ZT(StartTime,1),..%ZT(EndTime,1),RegNum,StartNum)
	...s TRFlag="Y"
	...Set TRStartTime=..%ZT(StartTime,1)
	...Set TREndTime=..%ZT(EndTime,1)
	...Set TRTimeLen=""
	...Set TRRegNum=RegNum
	...Set TRRegNumInfo=$p(info,"^",2)
	...Set TRTimeRangeInfo=$p(info,"^",3)
	...q:TRRegNum'[":"
	...s asload=$p(^RB("RES",ResRowid,"DATE",DateSub,"SESS",SessSub),"^",8)
	...s startnum=$p(^RB("RES",ResRowid,"DATE",DateSub,"SESS",SessSub),"^",21)
	...s num=num+1
	...s TRRegNum=asload-startnum+1
	...//s $p(^RB("RES",ResRowid,"DATE",DateSub,"SESS",SessSub,"DHC"),"^",5)=TRRegNum
	...Set TRAllInfo=TRFlag_"^"_TRStartTime_"^"_TREndTime_"^"_TRTimeLen_"^"_TRRegNum_"^"_TRRegNumInfo_"^"_TRTimeRangeInfo
	...s ^tempUpdateTimeRange(SESSRowid)=TRAllInfo
	...//s ^RB("RES",ResRowid,"DATE",DateSub,"SESS",SessSub,"DHC")=TRAllInfo
	...//if $p(info,"^",1) w info,!
	b ;434
	q num
	//RegNumInfo_"^"_TimeRangeInfo
}

ClassMethod UpdateGenerFlag(SessRowidAll As %String, ScheduleGenerFlag As %String) As %String
{
	q:($g(SessRowidAll)="")||($g(ScheduleGenerFlag)="") 100
	s UpdateFlag=0
	TStart
	f SessRowidSeq=1:1:$l(SessRowidAll,"^") {
		s SessRowid=$p(SessRowidAll,"^",SessRowidSeq)
		&SQL(Update SQLUser.RB_ResEffDateSession Set SESS_ScheduleGenerFlag=:ScheduleGenerFlag Where SESS_RowId=:SessRowid )
		s UpdateFlag=UpdateFlag+SQLCODE
	}
	i UpdateFlag TRO
	e  TCommit
	q UpdateFlag
}

Query GetClinicGroupByLoc(LocRowId As %String) As %Library.SQLQuery(CONTAINID = 3, ROWSPEC = "CLGRPRowId:%String,CLGRPDesc:%String")
{
	
	SELECT DISTINCT(DHCLS_CG_DR) DHCLS_CG_DR,DHCLS_CG_DR->CLGRP_Desc FROM SQLUser.DHC_LocSpec
	WHERE ((DHCLS_Loc_DR=:LocRowId) OR (:LocRowId is null))
	and (DHCLS_CG_DR->CLGRP_DateFrom<=current_date) and ((DHCLS_CG_DR->CLGRP_DateTo>=current_date) or (DHCLS_CG_DR->CLGRP_DateTo is null))
}

Query GetClinicGroupByLocNew(LocRowId As %String = "", HospID = "") As %Query(ROWSPEC = "CLGRPRowId,CLGRPDesc")
{
}

/// d ##class(%ResultSet).RunQuery("web.DHCRBResSession","GetClinicGroupByLocNew",10)
ClassMethod GetClinicGroupByLocNewExecute(ByRef qHandle As %Binary, LocRowId As %String = "", HospID = "") As %Status
{
	;Q:LocRowId="" $$$OK
	s HospID=##class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(HospID)
	s ID=0 for{
		s ID=$O(^DHCLocSubject(ID)) Q:ID=""
		s CLGRPRowId=$P(^DHCLocSubject(ID),"^",2)
		s CLGRPLoc=$P(^DHCLocSubject(ID),"^",1)
		continue:($p($g(^CTLOC(CLGRPLoc)),"^",22)'=HospID)
		continue:$d(ClinicGroupList(CLGRPRowId))
		continue:((LocRowId'="")&&(LocRowId'=CLGRPLoc))
		continue:(HospID'="")&&("N"=##class(DHCDoc.Common.Hospital).GetHospShowDataFlag("RBC_ClinicGroup",CLGRPRowId,HospID))
		s DateTo=$P(^RBC("CLGRP",CLGRPRowId),"^",4)
		continue:(DateTo'="")&&(DateTo<=..%SysDate())
		s DateFrom=$P(^RBC("CLGRP",CLGRPRowId),"^",3)
		continue:(DateFrom="")||(DateTo>+$H)
		s CLGRPDesc=$P(^RBC("CLGRP",CLGRPRowId),"^",2)
		s ClinicGroupList(CLGRPRowId)=""
		s qHandle($I(ind))=$LB(CLGRPRowId,CLGRPDesc)
	}
	Quit $$$OK
}

ClassMethod GetClinicGroupByLocNewFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetClinicGroupByLocNewExecute ]
{
	s ind=$O(qHandle(0))
	if ind'=""{
		s Row=qHandle(ind)
		k qHandle(ind)
	}else{
		s AtEnd=1
	}
	Quit $$$OK
}

Query GetClinicServiceGroupByLoc(LocRowId As %String) As %Library.SQLQuery(CONTAINID = 3, ROWSPEC = "CLSGRPRowId:%String,CLSGRPDesc:%String")
{
	
	SELECT DISTINCT(DHCLS_CGS_DR) DHCLS_CGS_DR,DHCLS_CGS_DR->CLSGRP_Desc FROM SQLUser.DHC_LocSpec
	WHERE ((DHCLS_Loc_DR=:LocRowId) OR (:LocRowId is null))
	and (DHCLS_CGS_DR->CLSGRP_DateFrom<=current_date) and ((DHCLS_CGS_DR->CLSGRP_DateTo>=current_date) or (DHCLS_CGS_DR->CLSGRP_DateTo is null))
}

Query GetClinicServiceGroupByLocNew(LocRowId As %String, HospID = "") As %Query(ROWSPEC = "CLSGRPRowId,CLSGRPDesc")
{
}

/// d ##class(%ResultSet).RunQuery("web.DHCRBResSession","GetClinicServiceGroupByLocNew",10)
ClassMethod GetClinicServiceGroupByLocNewExecute(ByRef qHandle As %Binary, LocRowId As %String, HospID = "") As %Status
{
	s HospID=##class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(HospID)
	s CLSGRPRowIdStr=""
	s ID=0 for{
		s ID=$O(^DHCLocSubject(ID)) Q:ID=""
		s CLGRPRowId=$P(^DHCLocSubject(ID),"^",3)
		s CLGRPLoc=$P(^DHCLocSubject(ID),"^",1)
		continue:((LocRowId'="")&&(LocRowId'=CLGRPLoc))
		s HospDr=$P(^CTLOC(CLGRPLoc),"^",22)
		continue:HospDr'=HospID
		Continue:(("^"_CLSGRPRowIdStr_"^")[("^"_CLGRPRowId_"^"))
		s CLSGRPRowIdStr=CLSGRPRowIdStr_"^"_CLGRPRowId
		continue:(HospID'="")&&("N"=##class(DHCDoc.Common.Hospital).GetHospShowDataFlag("RBC_ClinicServiceGroup",CLGRPRowId,HospID))
		s DateTo=$P(^RBC("CLSGRP",CLGRPRowId),"^",4)
		continue:(DateTo'="")&&(DateTo<=..%SysDate())
		s DateFrom=$P(^RBC("CLSGRP",CLGRPRowId),"^",3)
		continue:(DateFrom="")||(DateTo>+$H)
		s CLSGRPDesc=$P(^RBC("CLSGRP",CLGRPRowId),"^",2)
		s qHandle($I(ind))=$LB(CLGRPRowId,CLSGRPDesc)
	}
	Quit $$$OK
}

ClassMethod GetClinicServiceGroupByLocNewFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetClinicServiceGroupByLocNewExecute ]
{
	s ind=$O(qHandle(0))
	if ind'=""{
		s Row=qHandle(ind)
		k qHandle(ind)
	}else{
		s AtEnd=1
	}
	Quit $$$OK
}

ClassMethod GetClinicGroupStrByLoc(LocRowId As %String) As %String
{
	s ret1=""
	if LocRowId'="" {
		Set rset=##class(%ResultSet).%New("web.DHCRBResSession:GetClinicGroupByLoc")
		do rset.Execute(LocRowId)
		While (rset.Next()) {
			s CLGRPRowId=rset.GetData(1)
			s CLGRPDesc=rset.GetData(2)
			s ret=CLGRPRowId_$C(1)_CLGRPDesc
			i ret1="" s ret1=ret
	        e  s ret1=ret1_"^"_ret
		}
		d rset.Close()
	}
	Q ret1
}

Query FindHospital(LogonHospId As %String = "") As %Query(ROWSPEC = "Desc:%String,Code:%String,id:%String") [ SqlProc ]
{
}

ClassMethod FindHospitalClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = FindLocExecute ]
{
	// Clean up by purging the temporary node in ^CacheTemp global
	//New repid
	Set repid=$li(QHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindHospitalExecute(ByRef QHandle As %Binary, LogonHospId As %String = "") As %Status
{
	//New repid, ind
	//New CTCode,CTDesc
	;d ##class(%ResultSet).RunQuery("web.DHCRBResSession","FindHospital","")
	Set repid=$I(^CacheTemp)
	s ind=0
	s HosRowid=""
	for {
		s HosRowid=$o(^CT("HOSP",HosRowid))
		q:HosRowid=""
		s HosDesc=$P(^CT("HOSP",HosRowid),"^",2)
		s HosCode=$P(^CT("HOSP",HosRowid),"^",1)
		d OutputHosRow
	}
	
	Set QHandle=$lb(0,repid,0)
	Quit $$$OK
OutputHosRow
	set Data=$lb(HosDesc,HosCode,HosRowid)
	Set ^CacheTemp(repid,ind)=Data	
	Set ind=ind+1
	quit
}

ClassMethod FindHospitalFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindHospitalExecute ]
{
	//New repid,ind
	Set AtEnd=$li(QHandle,1)
	Set repid=$li(QHandle,2)
	Set ind=$li(QHandle,3)
	
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {	// if there are no more rows, finish fetching
		 Set AtEnd=1
		 Set Row=""
	}
	Else      {	// fetch row
		Set Row=^CacheTemp(repid,ind)
	}
	s QHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

Query LookUpTimeRange(date As %String = "") As %Library.SQLQuery(CONTAINID = 3, ROWSPEC = "Desc:%String,Code:%String,RowId:%String")
{
	SELECT TR_Desc,TR_Code,TR_RowId FROM SQLUser.DHC_TimeRange
	WHERE ((TR_ValidStartDate <= :date) OR (TR_ValidStartDate IS NULL))
		AND  ((TR_ValidEndDate>= :date) OR (TR_ValidEndDate IS NULL) )
}

Query LookUpTimeRangeNew(HospID = "") As %Query(ROWSPEC = "RowId,Code,Desc")
{
}

ClassMethod LookUpTimeRangeNewExecute(ByRef qHandle As %Binary, HospID = "") As %Status
{
	s rows=[]
	s qHandle=rows.%GetIterator()
	s HospID=##class(DHCDoc.Common.Hospital).GetDefHospIdByTableName("DHC_TimeRange",HospID)
	s RowId=0 for{
		s RowId=$O(^DHCTimeRange(RowId)) Q:RowId=""
		continue:"N"=##class(DHCDoc.Common.Hospital).GetHospShowDataFlag("DHC_TimeRange",RowId,HospID)
		s ValidSttDate=$P(^DHCTimeRange(RowId),"^",7)
		continue:(ValidSttDate="")||(ValidSttDate>+$H)
		s ValidEndDate=$P(^DHCTimeRange(RowId),"^",8)
		continue:(ValidEndDate'="")&&(ValidEndDate<=..%SysDate())
		s Code=$P(^DHCTimeRange(RowId),"^",1)
		s Desc=$P(^DHCTimeRange(RowId),"^",2)
		d rows.%Push($LB(RowId,Code,Desc)) 
	}
	Quit $$$OK
}

ClassMethod LookUpTimeRangeNewFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = LookUpTimeRangeNewExecute ]
{
	if 'qHandle.%GetNext(.key,.Row) s AtEnd=1
	Quit $$$OK
}

}
