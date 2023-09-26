Class web.DHCOPPatTran Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// 201210+dyl：科室等
/// 获取病人基本信息
/// w ##class(web.Exam).GetPatInfoByAdmId(11420522)
ClassMethod GetPatInfoByAdmId(admId As %String = "") As %String
{
	s ret=""
	s $p(ret,"^",6)=""
	;s adm=$P(^PAADM(admId),"^",61)	;真正的就诊号
	s papmiId=$p($g(^PAADM(admId)),"^",1) //PAADM_PAPMI_DR，就诊的索引号
	s paadmtype=$p($g(^PAADM(admId)),"^",2)	;病人类型
	i (paadmtype="O")&($d(^DHCANOPArrange(0,"Adm",admId))<1)  d
		.s admId=""
		.f  s admId=$o(^PAPERdr(papmiId,"ADM","I",admId)) q:admId=""  d
			..q:$d(^PAADM(admId))<1
			..s VisitStatus=$p(^PAADM(admId),"^",20)
			..q:VisitStatus'="A"
			..s adm=admId
			..s WardDes=""
			..s curWardId=$p($g(^PAADM(adm)),"^",70)
			..i curWardId'="" s WardDes=$P(^PAWARD(curWardId),"^",1)
			..s patLocId=$p(^PAADM(adm),"^",4)
			..i WardDes="" s WardDes=$p(^CTLOC(patLocId),"^",2)
			..s medCareNo=$p($g(^PAPER(papmiId,"PAT",1)),"^",22) //病案号：可以选择
			..s patName=$p($g(^PAPER(papmiId,"ALL")),"^",1) //病人的基本信息
			..s birth=$p($g(^PAPER(papmiId,"ALL")),"^",6)
			..s age=##class(web.UDHCANOPArrange).CalAge(birth,$h) //调用CalAge方法
			..s sex=$p($g(^CT("SEX",$p($g(^PAPER(papmiId,"ALL")),"^",7))),"^",2)
			..s ret=adm_"^"_WardDes_"^"_medCareNo_"^"_patName_"^"_age_"^"_sex
	e  d
		.s adm=admId
		.s WardDes=""
		.s curWardId=$p($g(^PAADM(adm)),"^",70) 
		.;w curWardId_"/"
		.i curWardId'="" s WardDes=$P(^PAWARD(curWardId),"^",1)
		.s patLocId=$p(^PAADM(adm),"^",4)
		.i WardDes="" s WardDes=$p(^CTLOC(patLocId),"^",2)
		.s medCareNo=$p($g(^PAPER(papmiId,"PAT",1)),"^",22) //病案号：可以选择
		.s patName=$p($g(^PAPER(papmiId,"ALL")),"^",1) //病人的基本信息
		.s birth=$p($g(^PAPER(papmiId,"ALL")),"^",6)
		.s age=##class(web.UDHCANOPArrange).CalAge(birth,$h) //调用CalAge方法
		.s sex=$p($g(^CT("SEX",$p($g(^PAPER(papmiId,"ALL")),"^",7))),"^",2)
		.s ret=adm_"^"_WardDes_"^"_medCareNo_"^"_patName_"^"_age_"^"_sex
	q ret
}

/// 如果对应admId的手术没有,但是住院对应有
/// w ##class(web.Exam).GetOpaIdByAdmIdOld("11420522")
ClassMethod GetOpaIdByAdmIdOld(admId As %String = "") As %String
{
	s papmiId=$p($g(^PAADM(admId)),"^",1) //PAADM_PAPMI_DR，就诊的索引号
	s paadmtype=$p($g(^PAADM(admId)),"^",2)	;病人类型
	s opaIdOld=""

	s type="" f  s type=$o(^PAPERdr(papmiId,"ADM",type)) q:type=""  d
			.s adm=""
			.f  s adm=$o(^PAPERdr(papmiId,"ADM",type,adm)) q:adm=""  d
				..q:$d(^PAADM(adm))<1
				..s VisitStatus=$p(^PAADM(adm),"^",20)
				..;q:VisitStatus'="A"
				..s opaId="" f  s opaId=$O(^DHCANOPArrange(0,"Adm",adm,opaId)) q:opaId=""  d
					...q:$d(^DHCANOPArrange(opaId))<1
					...i opaIdOld'="" s opaIdOld=opaId_"^"_opaIdOld
					...e  s opaIdOld=opaId

	i opaIdOld="" s opaIdOld="病人目前没有手术"
	q opaIdOld
}

/// w ##class(web.Exam).GetOpaIdByAdmIdNew("11420522")
ClassMethod GetOpaIdByAdmIdNew(admId As %String = "") As %String
{
	s papmiId=$p($g(^PAADM(admId)),"^",1) //PAADM_PAPMI_DR，就诊的索引号
	s paadmtype=$p($g(^PAADM(admId)),"^",2)	;病人类型
	s opaIdOld=""

	s type="" f  s type=$o(^PAPERdr(papmiId,"ADM",type)) q:type=""  d
			.s adm=""
			.f  s adm=$o(^PAPERdr(papmiId,"ADM",type,adm)) q:adm=""  d
				..q:$d(^PAADM(adm))<1
				..s VisitStatus=$p(^PAADM(adm),"^",20)
				..;q:VisitStatus'="A"
				..s opaId="" f  s opaId=$O(^DHCANOPArrange(0,"Adm",adm,opaId)) q:opaId=""  d
					...q:$d(^DHCANOPArrange(opaId))<1
					...i opaIdOld'="" s opaIdOld=opaId_"^"_opaIdOld
					...e  s opaIdOld=opaId

	q opaIdOld
}

//d ##class(%ResultSet).RunQuery("web.DHCOPPatTran","FindopaIdListByAdm","")

Query FindopaIdListByAdm(admId As %String) As %Query(ROWSPEC = "opaId:%String,opaIdDesc:%String") [ SqlProc ]
{
}

ClassMethod FindopaIdListByAdmExecute(ByRef qHandle As %Binary, admId As %String) As %Status
{
	s repid=$i(^CacheTemp)
	i $g(ind)="" s ind=1
	s papmiId=$p($g(^PAADM(admId)),"^",1) //PAADM_PAPMI_DR，就诊的索引号
	s paadmtype=$p($g(^PAADM(admId)),"^",2)	;病人类型
	s type="" 
	f  s type=$o(^PAPERdr(papmiId,"ADM",type)) q:type=""  d
		.s adm=""
		.f  s adm=$o(^PAPERdr(papmiId,"ADM",type,adm)) q:adm=""  d
		..q:$d(^PAADM(adm))<1
		..s VisitStatus=$p(^PAADM(adm),"^",20)
		..;q:VisitStatus'="A"
		..s opaId="" f  s opaId=$O(^DHCANOPArrange(0,"Adm",adm,opaId)) q:opaId=""  d
					...q:$d(^DHCANOPArrange(opaId))<1
					...i opaId'="" s opaIdDesc=opaId
	...d OutputLocRow
	s qHandle=$lb(0,repid,0)
	q $$$OK

OutputLocRow
	s Data=$lb(opaId,opaIdDesc)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

ClassMethod FindopaIdListByAdmFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindopaIdListByAdmExecute ]
{
	s AtEnd=$li(qHandle,1)
	s repid=$li(qHandle,2)
	s ind=$li(qHandle,3)
	//
	s ind=$o(^CacheTemp(repid,ind))
	i ind="" {				// if there are no more rows, finish fetching
	s AtEnd=1
	s Row=""
	}
	else      {				// fetch row
	s Row=^CacheTemp(repid,ind)
	}
	// Save QHandle
	s qHandle=$lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod FindopaIdListByAdmClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindopaIdListByAdmExecute ]
{
	s repid=$li(qHandle,2)
	k ^CacheTemp(repid)
	q $$$OK
}

/// 201210+dyl:页面选中，后台传入1，反之传入0
/// 病人相关勾选的数据
ClassMethod SavePatInfoByAdmId(admId, opaId, Str As %String = "", type As %String = "", userId As %String = "") As %String
{
	q:admId="" "就诊号不能为空"
	q:opaId="" "手术Id不能为空"
	s date=$h
	s time=$p($h,",",2)
	s ^PatTranLog("ConInfo",admId,opaId,type,date,time)=userId
	s date=+date
	//不根据admId走了，全部根据opaId
	s ret=0
	;s adm=$P(^PAADM(admId),"^",61)	;真正的就诊号
	s ^PatTran("Info",opaId,type)=Str
	q ret
}

/// 201210+dyl:存入的是非勾选的内容
ClassMethod SavePatOtherInfoByAdmId(admId, opaId, Str As %String = "", type As %String = "", userId As %String = "", temp As %String = "") As %String
{
	q:admId="" ""
	s ret=0
	s date=$h
	s time=$p($h,",",2)

	i (type="OB")&&(temp'="Y") d
		.i $p(Str,"^",13)="" s $p(Str,"^",13)=$zd(date,3)_" "_$zt(time,2)
	i type="OI" d
		.i $p(Str,"^",8)="" s $p(Str,"^",8)=$zd(date,3)_" "_$zt(time,2)
	i type="OO" d
		.i $p(Str,"^",12)="" s $p(Str,"^",12)=$zd(date,3)_" "_$zt(time,2)
	s ^PatTran("OtherInfo",opaId,type)=Str
	q ret
}

/// 勾选内容，传入前台，js做判断
/// w ##class(web.Exam).GetPatOtherInfoById(12068241,91176,"OB")
ClassMethod GetPatInfoById(AdmId, OpaId, type) As %String
{
	q:AdmId="" ""
	q:OpaId="" ""
	s PatTran=""
	s PatTran=$g(^PatTran("Info",OpaId,type))
	q PatTran
}

/// 手写内容传入前台
ClassMethod GetPatOtherInfoById(AdmId, OpaId, type) As %String
{
	q:AdmId="" ""
	q:OpaId="" ""
	s PatTran=""

	s PatTran=$g(^PatTran("OtherInfo",OpaId,type))
	q PatTran
}

/// 审核确认
ClassMethod PatInfoConfirm(AdmId, OpaId, type, UserId, UserName) As %String
{
	q:AdmId="" ""
	q:OpaId="" ""
    s date=$h
	s time=$p($h,",",2)	
    s ^PatTran("ConfirmFlag",OpaId,type)="Y"
    s ^PatTran("ConfirmTime",OpaId,type)=$zd(date,3)_" "_$zt(time,2)	;审核时间
    s ^PatTran("ConfirmUser",OpaId,type)=UserName_"^"_UserId
    s ^PatTranLog("ConTime",OpaId,type,date,time)=UserId
	q 0
}

//加载审核时间操作人等信息

ClassMethod GetConfirmTime(AdmId, OpaId, type) As %String
{
	q:AdmId="" ""
	q:OpaId="" ""

		s ret=0
		;操作时间
	    s Time=$g(^PatTran("OperateTime",OpaId,type))
	    i Time'="" d
		    .s d=$zd($p(Time,"^",1),3)
		    .s t=$zt($p(Time,"^",2),2)
		    .s Time=d_" "_t
	   ;审核时间
	   s CheckTime=$g(^PatTran("ConfirmTime",OpaId,type))
		;审核用户
		s UserInfo=$g(^PatTran("ConfirmUser",OpaId,type))
		i $p(UserInfo,"^",2)'="" s $p(UserInfo,"^",1)=$p(^SSU("SSUSR",$p(UserInfo,"^",2)),"^",2)
		s ret=Time_"^"_CheckTime_"^"_UserInfo
	q ret
}

//是否审核标志

ClassMethod PatInfoConfirmFlag(AdmId, OpaId, type) As %String
{
	q:AdmId="" ""
	q:OpaId="" ""
	s ret=0
	s papmiId=$p($g(^PAADM(AdmId)),"^",1) //PAADM_PAPMI_DR，就诊的索引号
	s paadmtype=$p($g(^PAADM(AdmId)),"^",2)	;病人类型
	s ret=$g(^PatTran("ConfirmFlag",OpaId,type))
	i ret="" s ret=0
	q ret
}

Query FindCtcp(needCtcpDesc As %String, locDescOrId As %String = "") As %Query(ROWSPEC = "ctcpId,ctcpDesc,ctcpAlias")
{
}

ClassMethod FindCtcpExecute(ByRef qHandle As %Binary, needCtcpDesc As %String, locDescOrId As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	k ^TMPCTCP($j)
	s needCtcpDesc=$$ALPHAUP^SSUTIL4(needCtcpDesc)
	i locDescOrId'="" d
		.i locDescOrId=+locDescOrId s ctlocId=locDescOrId
		.e  d
			..s locDesc=$$ALPHAUP^SSUTIL4(locDescOrId)
			..s ctlocId=$o(^CTLOC(0,"Desc",locDesc,""))
	s ctlocId=%session.Data("LOGON.CTLOCID")
	s resId=""
	f  s resId=$O(^RB("RES",0,"CTLOC",ctlocId,resId))  q:resId=""  d
		.s ctcpId=$P(^RB("RES",resId),"^",2)
		.q:ctcpId=""
		.s ctcptId=$p($g(^CTPCP(ctcpId,1)),"^",4)
		.q:ctcptId=""
		.s ctcptType=$p($g(^CT("CPT",ctcptId)),"^",4)
		.s ctcpDesc=##class(web.DHCANOPCom).GetNameById(ctcpId)
		.q:($p(ctcpDesc,needCtcpDesc)'="")&(needCtcpDesc'="")&(..MatchName(ctcpId,needCtcpDesc)=0)
		.s ^TMPCTCP($j,1,ctcpId)=$lb(ctcpId,ctcpDesc,ctcpAlias)
		.d Outputcpt
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK

Outputcpt
 set Data=$lb(ctcpId,ctcpDesc,ctcpAlias)
 Set ^CacheTemp(repid,ind)=^TMPCTCP($j,1,ctcpId)
 Set ind=ind+1
 quit
}

ClassMethod FindCtcpFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindCtcpExecute ]
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

ClassMethod FindCtcpClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindCtcpExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod test(OpaIdStr) As %String
{
	q:+OpaIdStr=0 "NoData"
	s retstr=""
	i OpaIdStr'="" d
		.s opaIdNum=$l(OpaIdStr,"^")
		.f i=1:1:opaIdNum d
		..s curId=$p(OpaIdStr,"^",i)
		..q:curId=""
		..s stDate=$P(^DHCANOPArrange(curId),"^",14)
		..i stDate'="" s stDate=$ZD(stDate,3)
		..i retstr'="" s retstr=retstr_" "_curId_":"_stDate
		..e  s retstr=curId_":"_stDate
	q retstr
}

ClassMethod SpecialSave(OpaId, obCheckTime, oiCheckTime, ooCheckTime, UserId) As %String
{
	s date=$h
	s time=$p($h,",",2)
	s ^PatTranLog("SConTime",OpaId,date,time)=UserId
	s ^PatTran("ConfirmTime",OpaId,"OB")=obCheckTime
	s ^PatTran("ConfirmTime",OpaId,"OI")=oiCheckTime
	s ^PatTran("ConfirmTime",OpaId,"OO")=ooCheckTime
	q 0
}

ClassMethod MatchName(ctcpId As %String, name As %String, exact As %Boolean = 1)
{
	q:(ctcpId="")!(name="") 0
	s userEmailName = ..GetCtcpUserEmailName(ctcpId)
	s userEmailName = $p(userEmailName,"-",1)
	s userInitials=..GetCtcpUserInitials(ctcpId)
	s ctcpAlias=$p($g(^CTPCP(ctcpId,3)),"^",28)
	s ctcpAlias=$$ALPHAUP^SSUTIL4(ctcpAlias)
	if exact
	{
		q (userEmailName=name)||(userInitials=name)||(ctcpAlias=name)
	}
	else 
	{
		q (userEmailName_$c(3)_userInitials_$c(3)_ctcpAlias)[name
	}
}

ClassMethod GetCtcpUserEmailName(ctcpId) As %String
{
	q:ctcpId="" ""
	s userId=$o(^SSU("SSUSR",0,"CTPCP",ctcpId,""))
	q:userId="" ""
	q $p($g(^SSU("SSUSR",userId)),"^",11)   //SSUSR_EMailName
}

ClassMethod GetCtcpUserInitials(ctcpId) As %String
{
	q:ctcpId="" ""
	s userId=$o(^SSU("SSUSR",0,"CTPCP",ctcpId,""))
	q:userId="" ""
	q $p($g(^SSU("SSUSR",userId)),"^",1) //SSUSR_Initials
}

/// w ##class(web.Exam).GetNameInfoByCode("SSS001")
/// 通过编号查找名字SSS001
ClassMethod GetNameInfoByCode(UserCode) As %String
{
	q:UserCode="" ""
	s UserCode=$$ALPHAUP^SSUTIL4(UserCode)
	s userId=$o(^SSU("SSUSR",0,"SSUSR_Initials",UserCode,""))
	q:userId="" "1"
	s userName=$p(^SSU("SSUSR",userId),"^",2)
	q userName
}

ClassMethod CheckIfCanSee(OpaId) As %String
{
	s ret=""
	q:OpaId="" ""
	s stDate=$P(^DHCANOPArrange(OpaId),"^",14)
	s curDate=+$h
	i curDate-stDate>2 s ret=1
	e  s ret=0
	q ret
}

ClassMethod WardNoteConfirm(OpaId, type, note) As %String
{
	s ret=""
	q:OpaId="" ""
	s ^PatTran("Note",OpaId,type)=note
	q ret
}

ClassMethod GetWardNote(OpaId, type) As %String
{
	s ret=""
	q:OpaId="" ""
	s ret=$g(^PatTran("Note",OpaId,type))
	q ret
}

//护士长修改操作日期

ClassMethod SavePatOtherInfoByopaId(opaId, type, date, time) As %String
{
	
	q:opaId="" "手术ID为空"
	q:date="" "日期不能为空"
	q:time="" "时间不能为空"
	q:type="" "-1"
	s ret=0,Str=""
	s Str=^PatTran("OtherInfo",opaId,type)
	q:Str="" "病人没有操作的数据"
	i type="OB" d
	.s $p(^PatTran("OtherInfo",opaId,type),"^",13)=date_" "_time
	i type="OI" d
	.s $p(^PatTran("OtherInfo",opaId,type),"^",8)=date_" "_time
	i type="OO" d
	.s $p(^PatTran("OtherInfo",opaId,type),"^",12)=date_" "_time
	q ret
}

//护士长修改操作人

ClassMethod updateOperator(opaId, type, UserIdCode) As %String
{
	
	q:opaId="" "手术ID为空"
	q:UserIdCode="" "操作人工号不能为空"
	q:type="" "-1"
	s ret=0,Str=""
	s Str=$g(^PatTran("OtherInfo",opaId,type))
	q:Str="" "病人没有操作的数据"
	s UserName=##class(web.DHCOPPatTran).GetNameInfoByCode(UserIdCode)
	s UserCode=$$ALPHAUP^SSUTIL4(UserIdCode)
	s UserId=$o(^SSU("SSUSR",0,"SSUSR_Initials",UserCode,""))
	i type="OB" d
	.s $p(^PatTran("OtherInfo",opaId,type),"^",7)=UserName
	.s $p(^PatTran("OtherInfo",opaId,type),"^",8)=UserId
	i type="OI" d
	.s $p(^PatTran("OtherInfo",opaId,type),"^",4)=UserName
	.s $p(^PatTran("OtherInfo",opaId,type),"^",5)=UserId
	i type="OO" d
	.s $p(^PatTran("OtherInfo",opaId,type),"^",8)=UserName
	.s $p(^PatTran("OtherInfo",opaId,type),"^",9)=UserId
	q ret
}

//护士长修改审核日期

ClassMethod PatInfoConfirmbyOpaId(OpaId, type, date, time) As %String
{
	q:date="" ""
	q:OpaId="" ""
    q:time="" ""
    s ret=0,Str=""
	s Str=^PatTran("ConfirmTime",OpaId,type)
	q:Str="" "没有审核的数据"
    s ^PatTran("ConfirmTime",OpaId,type)=date_" "_time	;审核时间
	q ret
}

//护士长修改审核人

ClassMethod updateHandoverperson(OpaId, type, UserIdCode) As %String
{
	q:OpaId="" ""
    q:UserIdCode="" ""
    s ret=0,Str=""
	s Str=$g(^PatTran("ConfirmUser",OpaId,type))
	q:Str="" "没有审核的数据"
	s UserName=##class(web.DHCOPPatTran).GetNameInfoByCode(UserIdCode)
	s UserCode=$$ALPHAUP^SSUTIL4(UserIdCode)
	s UserId=$o(^SSU("SSUSR",0,"SSUSR_Initials",UserCode,""))
    s ^PatTran("ConfirmUser",OpaId,type)=UserName_"^"_UserId	;审核人ID
	q ret
}

ClassMethod RecordTime2(timeStart, timeEnd, userId)
{
	s date=$p($h,",",1)
	s time=$p($h,",",2)
	
	s ^tempWq("timeStart",date,time)=$p($g(timeStart),"^",1)_"^"_$p($g(timeStart),"^",2)_"^"_userId
	s ^tempWq("timeEnd",date,time)=$p($g(timeEnd),"^",1)_"^"_$p($g(timeEnd),"^",2)_"^"_userId
	 
	q 0
}

ClassMethod GetOperArrangeInfo(OpaIdStr) As %String
{
	q:+OpaIdStr=0 "NoData"
	s retstr="",oproomdes="",opordno="",oproomdr=""
	i OpaIdStr'="" d
		.s opaIdNum=$l(OpaIdStr,"^")
		.f i=1:1:opaIdNum d
		..s curId=$p(OpaIdStr,"^",i)
		..q:curId=""
		..s stDate=$P(^DHCANOPArrange(curId),"^",14)
		..s oproomdr=$P(^DHCANOPArrange(curId),"^",20)
	   	..if oproomdr'="" s oproomdes=$p($g(^DHCANC("OPRoom",oproomdr)),"^",2)
		..s opordno=$P(^DHCANOPArrange(curId),"^",26)
		..i stDate'="" s stDate=$ZD(stDate,3)
		..i retstr'="" s retstr=retstr_" "_curId_":"_stDate_",手术间:"_oproomdes_",台次:"_opordno
		..e  s retstr=curId_":"_stDate_",手术间:"_oproomdes_",台次:"_opordno
	q retstr
}

}
