Import SQLUser

Class web.DHCANOPCom Extends %Library.RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// ck 20100812
/// 
/// 
/// 通过医生 护士 ID取得姓名 若ID中有~,则到CTPCP中取值(本院人员),否则到DHC_CL_CareProv中取(进修 实习)
ClassMethod GetNameById(docdr As %String) As %String
{
	q:(docdr="")!(docdr=0) ""
	s len=$l(docdr,"~")
	q:(len'=1)&(len'=2) "用户ID不正确!"
	s docName=""
	i len=1 d
	.s docName=$tr($p($g(^CTPCP(+docdr,1)),"^",2)," ","")
	.i $l(docName,"-")>1 s docName=$p(docName,"-",1)
	i len=2 d
	.s clcpRowId=$p(docdr,"~",2)
	.i $g(^DHCCLCP(+clcpRowId))'="" s docName=$li(^DHCCLCP(+clcpRowId),2)
	.e  s docName=""
	;i docName="" q "用户不存在!"
	q docName
}

ClassMethod GetShiftCtcpList(shiftCtcpList)
{
 k shiftCtcpList
 s tDPArrangeId=0
 f  s tDPArrangeId=$o(^User.DHCMGPersonArrangeD(tDPArrangeId))  q:tDPArrangeId=""  d
 .S tARRPerDR=$li(^User.DHCMGPersonArrangeD(tDPArrangeId),5)
 .q:tARRPerDR=""
 .;i tARRPerDR'="" S tARRPerDRDesc=$p(^CTPCP(tARRPerDR,1),"^",2)
 .S tARRPostDR=$li(^User.DHCMGPersonArrangeD(tDPArrangeId),6)
 .q:tARRPostDR=""
 .s tARRMem=$li(^User.DHCMGPersonArrangeD(tDPArrangeId),4)
 .S tARRPostDRDesc=##class(web.DHCCLCom).GetComDescByCode("ShiftType",tARRPostDR)
 .q:tARRPostDRDesc=""
 .q:$g(shiftCtcpList(tARRPostDR))[("("_tARRPostDRDesc_")")
 .i tARRMem'="" s shiftCtcpList(tARRPerDR)=$g(shiftCtcpList(tARRPerDR))_"("_tARRPostDRDesc_")"_"("_tARRMem_")"
 .e  s shiftCtcpList(tARRPerDR)=$g(shiftCtcpList(tARRPerDR))_"("_tARRPostDRDesc_")"
 .;w tARRPerDR_"/"_shiftCtcpList(tARRPerDR),!
}

/// 根据出生日计算年龄
ClassMethod CalAge(IBirth As %String, IToday As %String) As %String
{
    s IBirth=$g(IBirth),IToday=$g(IToday)
    i IBirth>2980000 s IBirth=""
    i IBirth<0 s IBirth=""
    q:'$G(IBirth) ""
    s XBirth=$ZD(IBirth)
    s XToday=$ZD(IToday)
    s AgeMth=XToday-XBirth
    s AgeDay=$p(XToday,"/",2)-$p(XBirth,"/",2)
    s CurrYear=$p(XToday,"/",3) s:CurrYear<100 CurrYear=CurrYear+1900
    s BirthYear=$p(XBirth,"/",3) s:BirthYear<100 BirthYear=BirthYear+1900
    s AgeYear=CurrYear-BirthYear
    i AgeDay<0 d
        . s AgeMth=AgeMth-1
	    . s AgeDay=AgeDay+$p("31,31,28,31,30,31,30,31,31,30,31,30,31",",",+XToday)
	    . q:XToday'=2
	    . s:((CurrYear#4)=0)&(((CurrYear#100)'=0)!((CurrYear#400)=0)) AgeDay=AgeDay+1
	i AgeMth<0 s AgeMth=AgeMth+12,AgeYear=AgeYear-1
	s $P(AgeYr,"|",12)=AgeYear
	//s reage=$p(AgeYr,"|",12)_"Y "_AgeMth_"M "_AgeDay_"D"
	i $p(AgeYr,"|",12)>0 s reage=$p(AgeYr,"|",12)_"岁"
	e  d
	.i AgeMth>0 s reage=AgeMth_"月"
	.e  d
	..s reage=AgeDay_"天"
	q reage
}

// 取组合的麻醉方法,用delimStr分割

ClassMethod GetAnMethodDescById(anmthId, delimStr) As %String
{
	q:anmthId="" ""
	s anmetDesc=""
	f i=1:1:$l(anmthId,"|") d
		.s curAnmetId=$p(anmthId,"|",i)
		.q:+curAnmetId=0
		.s curAnmetDesc=$p($g(^ORC("ANMET",curAnmetId)),"^",2)
		.q:curAnmetDesc=""
		.//i $P(curAnmetDesc,"-",2)'="" s curAnmetDesc=$P(curAnmetDesc,"-",2)
		.i anmetDesc'="" s anmetDesc=anmetDesc_delimStr
		.s anmetDesc=anmetDesc_curAnmetDesc
	q anmetDesc
}

// 根据以"+"分割组合的麻醉方法名，或ID，转换为以"|"分割麻醉方法ID

ClassMethod ConvertToAnMethodId(anmetDesc, delimStr) As %String
{
	s anmetId=""
	s num=$l(anmetDesc,delimStr)
	f i=1:1:num d
		.s curAnmetDesc=$p(anmetDesc,delimStr,i)
		.q:curAnmetDesc=""
		.i curAnmetDesc=+curAnmetDesc,curAnmetDesc>0 s curAnmetId=curAnmetDesc
		.e  s curAnmetId=$o(^ORC("ANMET",0,"Desc",$$ALPHAUP^SSUTIL4(curAnmetDesc),""))
		.q:curAnmetId=""
		.q:("|"_anmetId_"|")[("|"_curAnmetId_"|")
		.i anmetId'="" s anmetId=anmetId_"|"
		.s anmetId=anmetId_curAnmetId
	q anmetId
}

/// attAnaopSub_$c(4)_anaopOperType_$c(4)_attOperId_$c(4)_attOperDesc_$c(4)_bldtpId_$c(4)_opLevelId_$c(3)_....
ClassMethod UpdateAttOperationOld(anaId, attAnaopStr, ifAll = "N") As %String
{
	s err=0
	s EpisodeID=$p(anaId,"||",1)
	s anaSub=$p(anaId,"||",2)
	s num=$l(attAnaopStr,$c(3))
	s retStr=0
	f i=1:1:num d
		.s anaopStr=$p(attAnaopStr,$c(3),i)
		.q:anaopStr=""
		.k PLIST
		.q:(+$p(anaopStr,$c(4),3)'=$p(anaopStr,$c(4),3))&($p(anaopStr,$c(4),4)="")	//手术Id或手术名为空退出
		.q:"MS"'[$p(anaopStr,$c(4),2)
		.s anaopSub=$p(anaopStr,$c(4),1)
		.q:anaopSub=1
		.s SQLCODE=0
		.i anaopSub'="" d
			..s anaopId=EpisodeID_"||"_anaSub_"||"_anaopSub
			..&sql(Select * INTO :PLIST() From sqluser.OR_Anaest_Operation where ANAOP_RowId=:anaopId)
		.q:SQLCODE
		.s PLIST(14)=$p(anaopStr,$c(4),2) //ypz 070530
		.;s PLIST(9)=$p(anaopStr,$c(4),3)
		.i $p(anaopStr,$c(4),3)=+$p(anaopStr,$c(4),3) d
		..s PLIST(9)=$p(anaopStr,$c(4),3)
		.e  s PLIST(9)=""
		.s orcOperId=PLIST(9)
		.s PLIST(8)=$lb($p(anaopStr,$c(4),4))  //UPDATE BY LYN 标准库手术备注无法正常保存bug修正，20160928
		.//s PLIST(8)=$p(anaopStr,$c(4),4)
		.s PLIST(0)=anaId
		.i ifAll="Y" d
		..s bldtpId=$p(anaopStr,$c(4),5)
		..s PLIST(12)=bldtpId
		.s anaopSub=$p(anaopStr,$c(4),1)
		.i anaopSub="" d
			..&sql(INSERT INTO sqluser.OR_Anaest_Operation Values :PLIST())
			..i SQLCODE'=0 s retStr="插入数据失败!Code="_SQLCODE
		.e  d
		    ..s ANAOPRowId=EpisodeID_"||"_anaSub_"||"_anaopSub
			..s PLIST(1)=anaopId
			..s PLIST(2)=anaopSub
			..&sql(Update sqluser.OR_Anaest_Operation Values :PLIST() where ANAOP_RowId=:anaopId)
			..i SQLCODE'=0 s retStr="修改数据失败!Code="_SQLCODE
		.q:SQLCODE'=0
		.i anaopSub="" s ANAOPRowId=%ROWID
		.s chl=$P(ANAOPRowId,"||",3)
		.s anchl=$P(ANAOPRowId,"||",2)
		.s adm=$P(ANAOPRowId,"||",1)
		.//s ^OR(adm,"ANA",anchl,"OP",chl,"REM",1)=$p(anaopStr,$c(4),?) //note?
		.i $p(anaopStr,$c(4),3)'=+$p(anaopStr,$c(4),3) d
			..s ^OR(adm,"ANA",anchl,"OP",chl,"REM",0)=2
        	..s ^OR(adm,"ANA",anchl,"OP",chl,"REM",2)=$p(anaopStr,$c(4),3)
        .i ifAll="Y" d
        	..s $p(^OR(adm,"ANA",anchl,"OP",chl,"DHC"),"^",1)=$p(anaopStr,$c(4),6)
        	..//i ($p($p(anaopStr,$c(4),7),"#",1)'="")&($p($p(anaopStr,$c(4),7),"#",2)'="") d   //zhangtao 2010.10.12
				..//.s arcimDr=$p($p(anaopStr,$c(4),7),"#",1)_"||"_$p($p(anaopStr,$c(4),7),"#",2)
			..//e  s arcimDr=""
			..//s $p(^OR(adm,"ANA",anchl,"OP",chl,"DHC"),"^",3)=arcimDr

	q retStr
}

ClassMethod UpdateAttOperation(anaId, attAnaopStr, ifAll = "N") As %String
{
	s err=0
	s EpisodeID=$p(anaId,"||",1)
	s anaSub=$p(anaId,"||",2)
	s numA=$l(attAnaopStr,$c(3))
	;s ^tmpDyl("Subo")=attAnaopStr
	s retStr=0
	f i=1:1:numA d
		.s anaopStr=$p(attAnaopStr,$c(3),i)
		.q:anaopStr=""
		.k PLIST
		.q:(+$p(anaopStr,$c(4),3)'=$p(anaopStr,$c(4),3))&($p(anaopStr,$c(4),4)="")	//手术Id或手术名为空退出
		.q:"MS"'[$p(anaopStr,$c(4),2)
		.s anaopSub=$p(anaopStr,$c(4),1)
		.
		.q:anaopSub=1
		.s SQLCODE=0
		.i anaopSub'="" d
			..s anaopId=EpisodeID_"||"_anaSub_"||"_anaopSub
			..&sql(Select * INTO :PLIST() From sqluser.OR_Anaest_Operation where ANAOP_RowId=:anaopId)
		.q:SQLCODE
		.s PLIST(14)=$p(anaopStr,$c(4),2) //ypz 070530
		.;s PLIST(9)=$p(anaopStr,$c(4),3)
		.i $p(anaopStr,$c(4),3)=+$p(anaopStr,$c(4),3) d
		..s PLIST(9)=$p(anaopStr,$c(4),3)
		.e  s PLIST(9)=""
		.s orcOperId=PLIST(9)
		.s PLIST(8)=$lb($p(anaopStr,$c(4),4))  //UPDATE BY LYN 标准库手术备注无法正常保存bug修正，20160928
		.//s PLIST(8)=$p(anaopStr,$c(4),4)
		.s PLIST(0)=anaId
		.s bldtpId=$p(anaopStr,$c(4),5)
		.
		.s PLIST(12)=bldtpId	;切口
		.s PLIST(11)=$p(anaopStr,$c(4),8)	//20180118主刀
		.s anaopSub=$p(anaopStr,$c(4),1)
		.i anaopSub="" d
			..&sql(INSERT INTO sqluser.OR_Anaest_Operation Values :PLIST())
			..i SQLCODE'=0 s retStr="插入数据失败!Code="_SQLCODE
			..;s ANAOPRowId=%ROWID
		.e  d
		    ..s ANAOPRowId=EpisodeID_"||"_anaSub_"||"_anaopSub
			..s PLIST(1)=anaopId
			..s PLIST(2)=anaopSub
			..
			..&sql(Update sqluser.OR_Anaest_Operation Values :PLIST() where ANAOP_RowId=:anaopId)
			..i SQLCODE'=0 s retStr="修改数据失败!Code="_SQLCODE
		.q:SQLCODE'=0
		.i anaopSub="" s ANAOPRowId=%ROWID
		.s chl=$P(ANAOPRowId,"||",3)
		.s anchl=$P(ANAOPRowId,"||",2)
		.s adm=$P(ANAOPRowId,"||",1)
		.s Ret3=ANAOPRowId
		.s catgId=$p(anaopStr,$c(4),6)
		.s $p(^OR(adm,"ANA",anchl,"OP",chl,"DHC"),"^",1)=catgId
		.s doclocId=$p(anaopStr,$c(4),7)
		.s $p(^OR(adm,"ANA",anchl,"OP",chl,"DHC"),"^",7)=doclocId
		.s assnum=0
		.s ass=$p(anaopStr,$c(4),9)	;助手
		.s numt1=$L(ass,"@")
		.i anaopSub="" s anaopSub=$p(ANAOPRowId,"||",3)
		.i anaopSub'="" d
			..q:$p(^OR(adm,"ANA",anchl,"OP",anaopSub),"^",12)'="S" 
			..i $d(^OR(adm,"ANA",anchl,"OP",anaopSub,"ASS"))>0 k ^OR(adm,"ANA",anchl,"OP",chl,"ASS")
	        ..for ti=1:1:numt1 d
	            ...i $p(ass,"@",ti)'=""  d
	           	 ....s assnum=assnum+1
	            ....s ^OR(adm,"ANA",anchl,"OP",chl,"ASS",ti)=$P(ass,"@",ti)
	            ...e  d
	            	....s ^OR(adm,"ANA",anchl,"OP",chl,"ASS",ti)=""
	    	..s ^OR(adm,"ANA",anchl,"OP",anaopSub,"ASS",0)=assnum
		.;
		.i $p(anaopStr,$c(4),3)'=+$p(anaopStr,$c(4),3) d
			..s ^OR(adm,"ANA",anchl,"OP",chl,"REM",0)=2
        	..s ^OR(adm,"ANA",anchl,"OP",chl,"REM",2)=$p(anaopStr,$c(4),3)
        .b ;end
	q retStr
}

/// 根据排班状态调整拟施手术(Id或自定义描述)
ClassMethod AdjustPlanOperation(opaId, anaId) As %String
{
	s retStr=0
	q:(opaId="")&(anaId="") retStr
	i opaId="" d
		.s curOpaId=""
		.f  s curOpaId=$o(^DHCANOPArrange(0,"Adm",+anaId,curOpaId)) q:curOpaId=""  d
			..i $p($g(^DHCANOPArrange(curOpaId)),"^",2)=anaId s opaId=curOpaId
	q:opaId="" retStr
	s anaId=$p($g(^DHCANOPArrange(opaId)),"^",2)
	s EpisodeID=$p(anaId,"||",1)
	s anaSub=$p(anaId,"||",2)
	q:anaSub="" retStr
	s opaStatus=$p($g(^DHCANOPArrange(opaId)),"^",27) //申请和未审核的
    s anaopSub=0
	f  s anaopSub=$o(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub)) q:(anaopSub="")  d
		.//q:($p(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub,"DHC"),"^",2)'="")&("A"'[opaStatus)
		.s operId=$p(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub),"^",6)   ;ANAOP_Type_DR 
		.s operDesc=$p(^ORC("OPER",+operId),"^",2)
		.//i operDesc="" s operId=$g(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub,"REM",2)) //自定义
		.//s $p(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub,"DHC"),"^",2)=operId
		.s operNote=$g(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub,"REM",2))
		.i (opaStatus="")!(opaStatus="A")!($g(^DHCCLSet("AnOp","OneOperName"))="Y") d   //yq 20190110 申请手术或者拟施手术实施手术名称设置一致时拟施手术同步实施手术
		..s $p(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub,"DHC"),"^",2)=operId   //拟施手术
		..s $p(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub,"DHC"),"^",5)=operNote //拟施手术备注
	q retStr
}

ClassMethod UpdateOperationCtcp(anaopId, node, ctcpIdStr, delimStr, opaOpDocNote = "") As %String
{
	
	s EpisodeID=$p(anaopId,"||",1)
	s anaSub=$p(anaopId,"||",2)
	s anaopSub=$p(anaopId,"||",3)
	k ^TMPCCQ(EpisodeID,"ANA",anaSub,"OP",anaopSub,node)
	s ^TMPCCQ(EpisodeID,"ANA",anaSub,"OP",anaopSub,node)=anaopId_"^"_node_"^"_ctcpIdStr_"^"_opaOpDocNote
	q:anaopSub="" 0
	q:delimStr="" 0
	k ^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub, node)
	s count=0
	f i=1:1:$l(ctcpIdStr,delimStr) d
		.s ctcpId=$p(ctcpIdStr,delimStr,i)
		.q:ctcpId=""
		.s count=count+1
		.i (+ctcpId>0)!($l(ctcpId,"~")>1) d
			..s $P(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub,node,count),"^",1)=ctcpId
		.e  d
			..s $P(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub,node,count),"^",1)=""
	s ^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub,node,0)=count
	q 0
}

// 返回病人第指定时间科室、病区、房间、床位

ClassMethod GetTransInfoByTime(EpisodeID, date = "", time = "") As %String
{
	s date=##class(web.DHCCLCom).ConvertToDateH(date)
	s time=##class(web.DHCCLCom).ConvertToTimeH(time)
  	s curCtlocId=$p(^PAADM(EpisodeID),"^",4)
  	s curRoomId=$p(^PAADM(EpisodeID),"^",69)
  	s curWardId=$p($g(^PAADM(EpisodeID)),"^",70)
  	s curBedId=$p($g(^PAADM(EpisodeID)),"^",73)
  	s needDateTime=date+(time/100000)
  	s i=0
  	s preLocId=""
  	s stdate=$P(^PAADM(EpisodeID),"^",6)
  	s transSub=0,quitMark=0
  	f  s transSub=$O(^PAADM(EpisodeID,"TRANS",transSub)) q:(transSub="")!(quitMark)  d
  	    .s startDate=$P(^PAADM(EpisodeID,"TRANS",transSub),"^",1)
  	    .s startTime=$P(^PAADM(EpisodeID,"TRANS",transSub),"^",2)
  	    .s startDateTime=startDate+(startTime/100000)
  	    .i startDateTime>needDateTime s quitMark=1 q
  	    .
  	    .s transLocId=$P(^PAADM(EpisodeID,"TRANS",transSub),"^",6)
  	    .i transLocId'="" s curCtlocId=transLocId
        .s transWardId=$P(^PAADM(EpisodeID,"TRANS",transSub),"^",9)
        .i transWardId'="" s curWardId=transWardId
        .s transBedId=$P(^PAADM(EpisodeID,"TRANS",transSub),"^",8)
        .i transBedId'="" s curBedId=transBedId
        .s transRoomId=$P(^PAADM(EpisodeID,"TRANS",transSub),"^",7)
        .i transRoomId'="" s curRoomId=transRoomId
  	q curCtlocId_"^"_curWardId_"^"_curRoomId_"^"_curBedId
}

Query GetANOPArrange(monitorID As %String) As %SQLQuery(CONTAINID = 1)
{
	SELECT * FROM SQLUser.DHC_AN_OPArrange Where %ID=:monitorID
}

Query GetANAnaestItem(parref As %String) As %SQLQuery(CONTAINID = 1)
{
	SELECT * FROM SQLUser.DHC_AN_AnaestItem Where ANI_Parref=:parref
}

Query GetAnalgesia(parref As %String) As %SQLQuery(CONTAINID = 1)
{
	SELECT * FROM SQLUser.DHC_AN_Analgesia Where PAA_Parref=:parref
}

Query GetAnalgesiaDrug(parref As %String) As %SQLQuery(CONTAINID = 1)
{
	SELECT * FROM SQLUser.DHC_AN_AnalgesiaDrug Where PAAD_Parref=:parref
}

Query GetPostAnaVisit(parref As %String) As %SQLQuery(CONTAINID = 1)
{
	SELECT * FROM SQLUser.DHC_AN_PostAnaVisit Where PAV_Parref=:parref
}

Query GetANShift(parref As %String) As %SQLQuery(CONTAINID = 1)
{
	SELECT * FROM SQLUser.DHC_AN_Shift Where ANS_Parref=:parref
}

Query FindANCodeByNode(type) As %Query(ROWSPEC = "tCode:%String,tDesc:%String")
{
}

ClassMethod FindANCodeByNodeExecute(ByRef qHandle As %Binary, type) As %Status
{
	s repid=$I(^CacheTemp)	
	s ind=1
	i type="" s type="Default"
	s codeId=0
	f  s codeId=$o(^DHCANC(type,codeId)) q:codeId=""  d
		.s tDesc=$p(^DHCANC(type,codeId),"^",2)
		.s tCode=$p(^DHCANC(type,codeId),"^",1)
		.d OutputRow
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
    
OutputRow
	set Data=$lb(tCode,tDesc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindANCodeByNodeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindANCodeByNodeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindANCodeByNodeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindANCodeByNodeExecute ]
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

ClassMethod ConvertToDate(dateVal As %String, defaultStr As %String = "$H") As %String
{
	s dateformatnum=##class(websys.Conversions).DateFormat()	//20170302+dyl
	q:((+dateVal=0)!(dateVal<0)!(dateVal>2980013))&(defaultStr="") ""
	q:(+dateVal=0)!(dateVal<0)!(dateVal>2980013) $zd($h,dateformatnum)
	q $zd(dateVal,dateformatnum)
}

ClassMethod ConvertToDateH(dateStr As %String, defaultVal As %String = "$H") As %String
{
	q:((dateStr="")!(dateStr<0))&(defaultVal="") ""
	q:(dateStr="")!(dateStr<0) +$h
	s $zt="ERROR"
	i ($l(dateStr,"/")>2)&(dateStr>1900) s dateStr=$tr(dateStr,"/","-")
	i $l(dateStr,"/")>2 q $zdh(dateStr,4)
	i $l(dateStr,"-")>2 q $zdh(dateStr,3)
	
    q +dateStr
ERROR	; 
    q:(defaultVal="") ""
    q +$h
}

ClassMethod ConvertToTimeH(timeStr As %String, defaultVal As %String = "$H") As %String
{
    //q:timeStr="" $p($h,",",2)
	//i $l(timeStr,":")>1 q $zth(timeStr,3)
    //q +timeStr
	q:((timeStr="")!(timeStr<0)!(timeStr>86399))&(defaultVal="") ""
	q:((timeStr="")!(timeStr<0)!(timeStr>86399))&(defaultVal="0") 0
	q:((timeStr="")!(timeStr<0)!(timeStr>86399)) $p($h,",",2)
	i $l(timeStr,":")>1 d
        .s tmpHour=+$p(timeStr,":")
        .s tmpHour=$p(tmpHour,".")
        .q:(tmpHour<0)!(tmpHour>23)
        .s $p(timeStr,":")=tmpHour
        .s tmpMinute=+$p(timeStr,":",2)
        .s tmpMinute=$p(tmpMinute,".")
        .q:(tmpMinute<0)!(tmpMinute>59)
        .s $p(timeStr,":",2)=tmpMinute
        .s tmpSecond=+$p(timeStr,":",3)
        .s tmpSecond=$p(tmpSecond,".")
        .q:(tmpSecond<0)!(tmpSecond>59)
        .
		.s timeStr=$ZTH(tmpHour_":"_tmpMinute_":"_tmpSecond,3)
	q +timeStr
}

ClassMethod ConvertToTime(dateVal As %String, defaultStr As %String = "$H") As %String
{
	q:((+dateVal=0)!(dateVal>86399)!(dateVal<0))&(defaultStr="") ""
	q:(+dateVal=0)!(dateVal>86399)!(dateVal<0) $zt($p($h,",",2))
	q $zt(dateVal)
}

ClassMethod ConvertToDateTime(dateVal As %String, timeVal As %String, defaultStr As %String = "$H") As %String
{
	q (..ConvertToDate(dateVal,defaultStr))_" "_(..ConvertToTime(timeVal, defaultStr))
}

ClassMethod PatInfo(curId, transLocNum = "") As %String
{
	//取病人第transLocNum次转科的基本信息;
	//入参:1. "^"分隔第二部分为admId，第一个分隔部分为登记号或OEORI_ROWID
	//2. 如果admId为空,按登记号或OEORI_ROWID取
	//3. 登记号根据最后一个ADM取信息；
    //n (curId,transLocNum)
    q:curId="" ""
    s admId=$p(curId,"^",2)
    s curId=$p(curId,"^")
    q:(curId="")&(admId="")
    i admId="" d
    	.s oriSub=$p(curId,"||",2)
    	.i oriSub'="" d //医嘱项
	    	..s oeordId=$p(curId,"||",1)
	    	..s admId=$p($g(^OEORD(oeordId)),"^",1)
    	.e  d  ;登记号
        	..s papmiId=""
	    	..s papmiId=$o(^PAPERi("PAPMI_PatNo",$$ALPHAUP^SSUTIL4(curId),"")) 
	    	..i papmiId="" s admId="" q
	    	..
	    	..s admType="",preAdm=""
        	..f  s admType=$o(^PAPERdr(papmiId,"ADM",admType),-1) q:admType=""  d
            	...s admId="" f  s admId=$o(^PAPERdr(papmiId,"ADM",admType,admId),-1) q:(admId="")  d
                	....s pavisit=$p($g(^PAADM(admId)),"^",20)
                	....q:(pavisit'="A")&(pavisit'="D")
                	....s preAdm=admId
                	....s admId=0,admType=0
        	..s admId=preAdm  //重置admId
    q:admId="" ""  //ypz 060516
   
    s papmiId=+$g(^PAADM(+admId))
    q:papmiId=0 ""
    s ctlocId=$p(^PAADM(admId),"^",4)
    s curWardId=$p($g(^PAADM(admId)),"^",70)  
    s bedId=$p($g(^PAADM(admId)),"^",73)
    s roomId=$p(^PAADM(admId),"^",69)
    s transInfo=$$GetTransInfo(admId,transLocNum) //ypz 080709
    i +transLocNum'=0 d
        .s ctlocId=$p(transInfo,"^") //ypz 080709
        .s curWardId=$p(transInfo,"^",2) //ypz 080709
        .s bedId=$p(transInfo,"^",4) //ypz 080709
        .s roomId=$p(transInfo,"^",3) //ypz 080709
    s ctlocDesc=$p(^CTLOC(+ctlocId),"^",2)	
    i $p(ctlocDesc,"-",2)'="" s ctlocDesc=$p(ctlocDesc,"-",2)
    s wardDesc=$p($g(^PAWARD(+curWardId)),"^",2)
    i $p(wardDesc,"-",2)'="" s wardDesc=$P(wardDesc,"-",2)
    s bedSub=$p(bedId,"||",2)
    s bedCode=""
    i bedSub'="" s bedCode=$p($g(^PAWARD(curWardId,"BED",bedSub)),"^",1)
    s room=$p($g(^PAROOM(+roomId)),"^",2)	
	s doc=$p(^PAADM(admId),"^",9)
	i doc'="" s DocDes=$P($g(^CTPCP(doc,1)),"^",2)
    s regNo=##class(web.DHCCLCom).GetRegNobyEpisodeID(admId)
    //s medicareNo=$p($g(^PAPER(papmiId,"PAT",1)),"^",22)
    s dhcwmrmainId=$o(^DHCWMRMAIN(0,"PAPMI",papmiId,-1))
    //s medicareNo=$p($g(^DHCWMRMAIN(+dhcwmrmainId)),"^",2)
	s paadmtype=$p($g(^PAADM(admId)),"^",2)
	s medicareNo=##Class(DHCWMR.IO.OutService).IGetMrNoByEpisodeID(admId,paadmtype,.ErrMsg)
    s patName=$p($g(^PAPER(papmiId,"ALL")),"^",1)
    i $d(^PAPER(papmiId,"PAT",3)) s safetyNetCardNo=$p(^PAPER(papmiId,"PAT",3),"^",4) ;病案号
    e  s safetyNetCardNo=""
    i medicareNo="" s medicareNo=safetyNetCardNo
    s sex=$p($g(^CT("SEX",$p($g(^PAPER(papmiId,"ALL")),"^",7))),"^",2)
    S homeAddres=$g(^PAPER(papmiId,"PER","ADD",1))     // 住址
    s homeTel=$p($g(^PAPER(papmiId,"PER",1)),"^",11)   //家庭电话
    s workTel=$p($g(^PAPER(papmiId,"PER",1)),"^",9)    //工作电话
    s handtel=$p($g(^PAPER(papmiId,"PER",4)),"^",21)   //手机
    s NationDr=$p($g(^PAPER(papmiId,"PER",2)),"^",1)
    i NationDr'="" d
    .s Nation=$P(^CT("NAT",NationDr),"^",2)
    e  d
    .s Nation=""                                       //民族
    s paersonLX=$p($g(^PAPER(papmiId,"PER",2)),"^",13) //联系人
    s birth=$p($g(^PAPER(papmiId,"ALL")),"^",6)
    s age=..CalAge(birth,+$h)
    //s age=$p(age,"Y",1)_"岁"_$p(age,"Y",2)
    //s age=$p(age,"M",1)_"月"_$p(age,"M",2)
    //s age=$p(age,"D",1)_"天"_$p(age,"D",2)
    //i age>2 s age=$p(age," ",1)
    //i (age>1)&(age<3) s age=$p(age," ",1,2)
    //i age<1 d
    //.s age=$p(age," ",2,3)
    //.i age<1 s age=$p(age," ",2) q
    //.i age>5 s age=$p(age," ",1)
    i $p(ctlocDesc,"-",2)'="" s ctlocDesc=$p(ctlocDesc,"-",2)
    s MRDiagnos=""
  	s mradmId=$P(^PAADM(admId),"^",61)
  	i mradmId'="" d
		.s diagInfoStr=##class(web.DHCANAdaptor).GetDiagInfoByAdmId(mradmId)
		.s digStrLength=$l(diagInfoStr,"^")
		.f dnum=1:1:digStrLength d
			..s curDiagStr=$p(diagInfoStr,"^",dnum)
			..s curDigDesc=$p(curDiagStr,"&&",1)
			..s curDigId=$p(curDiagStr,"&&",2)
			..s curDigNote=$p(curDiagStr,"&&",3)
			..s curPreFix=$p(curDiagStr,"&&",4)
			..s curDigType=$p(curDiagStr,"&&",5)
			..s curDigMainFlag=$p(curDiagStr,"&&",6)
			..q:curDigType'="出院诊断"
			..s newDiagStr=curPreFix_curDigDesc_curDigNote
			..i MRDiagnos'="" s MRDiagnos=MRDiagnos_","_newDiagStr
			..e  s MRDiagnos=newDiagStr

  	/*
  	s mrdiaSub=0
  	f  s mrdiaSub=$O(^MR(mradmId,"DIA",mrdiaSub)) q:(mrdiaSub="")  d
  	.s typSub=0  f  s typSub=$O(^MR(mradmId,"DIA",mrdiaSub,"TYP",typSub)) q:(typSub="")   d
  	..s dtypId=$P(^MR(mradmId,"DIA",mrdiaSub,"TYP",typSub),"^",1)
  	..q:dtypId=""
  	..s TypCode=$p($G(^MRC("DTYP",dtypId)),"^",1)
  	..q:TypCode'="OUT"
  	..s MRDIAICDCodeDR=$p($G(^MR(mradmId,"DIA",mrdiaSub)),"^",1)
  	..q:MRDIAICDCodeDR=""
  	..i MRDiagnos="" d
  	...s MRDiagnos=$p($G(^MRC("ID",MRDIAICDCodeDR)),"^",2)
  	..e  d
  	...s MRDiagnos=MRDiagnos_","_$p($G(^MRC("ID",MRDIAICDCodeDR)),"^",2)
    */
    s DrugCell=""
    s DrugCell=$p($G(^PAPER(papmiId,"DHC")),"^",5)  //药柜号
    s birthDate=$p($g(^PAPER(papmiId,"ALL")),"^",6) //出生日期
    i birthDate'="" s birthDate=$zd(birthDate,3)
    s patWordUnit=$p($G(^PAPER(papmiId,"PER",4)),"^",18)  //工作单位
    s PersonID=$p($G(^PAPER(papmiId,"ALL")),"^",9)  //身份证
    s BloodType=##class(web.DHCCLCom).GetBloodType(regNo) //取血型
    s AdmReason=$P($g(^PAADM(admId,1)),"^",7)
	i AdmReason'="" s PAAdmReasonDesc=$P($g(^PAC("ADMREA",AdmReason)),"^",2)
	e  s PAAdmReasonDesc=""                     //病人身份
	s AdmDocID=$P($g(^PAADM(admId)),"^",79)
	i AdmDocID'="" s AdmDoc=$P($g(^CTPCP(AdmDocID,1)),"^",2)
	e  s AdmDoc=""                              //办理出院医生
	s DHCAdmId=$o(^DHCPAAdm(0,"PAAdm",admId,"")) 			//主管护士
    i DHCAdmId'="" d
    .s MainNurseDr=$p(^DHCPAAdm(DHCAdmId),"^",2)
    .i MainNurseDr'="" d
    ..s MainNurse=$P($g(^CTPCP(MainNurseDr,1)),"^",2)
    .e  d
    ..s MainNurse=""
    e  s MainNurse="" 
    s AdmDate=$P(^PAADM(admId),"^",6) 						//入院日期
    i AdmDate'="" d
  	 .s admStayDay=$P($h,"^",1)-AdmDate+1
  	 .s admStayDay=admStayDay_"天"
  	 e  d
  	 .s admStayDay=""
        s Complaints=""
    s retStr=regNo_"^"_ctlocDesc_"^"_$g(room)_"^"_$g(sex)_"^"_$g(patName)_"^"_$g(safetyNetCardNo)_"^"_$g(bedCode)_"^"_$g(age)_"^"_$g(wardDesc)_"^"_homeAddres_"^"_homeTel_"  "_workTel_"  "_handtel_"^"_$G(DocDes)_"^"_medicareNo_"^"_MRDiagnos_"^"_Nation_"^"_paersonLX_"^"_DrugCell_"^"_$G(birthDate)_"^"_$G(patWordUnit)_"^"_$G(PersonID)_"^"_BloodType_"^"_PAAdmReasonDesc_"^"_AdmDoc_"^"_MainNurse_"^"_admStayDay_"^"_AdmReason_"^"_Complaints
    q retStr
GetTransInfo(EpisodeID,transLocNum)  //返回病人第transLocNum次转科的科室、病区、房间、床位
  	//n (EpisodeID,transLocNum)
  	s curCtlocId=$p(^PAADM(EpisodeID),"^",4)
  	s curRoomId=$p(^PAADM(EpisodeID),"^",69)
  	s curWardId=$p($g(^PAADM(EpisodeID)),"^",70)
  	s curBedId=$p($g(^PAADM(EpisodeID)),"^",73)
  	s retStr=curCtlocId_"^"_curWardId_"^"_curRoomId_"^"_curBedId
  	i +transLocNum=0 q retStr
  	s i=0
  	s preLocId=""
  	s stdate=$P(^PAADM(EpisodeID),"^",6)
  	s transSub=0 f  s transSub=$O(^PAADM(EpisodeID,"TRANS",transSub)) q:transSub=""  d
  	    .s transLocId=$P(^PAADM(EpisodeID,"TRANS",transSub),"^",6)
  	    .i (transLocId'="")&(transLocId'=preLocId) d
  	        ..s i=i+1
  	        ..s preLocId=transLocId
  	        ..i i=transLocNum s curCtlocId=transLocId
  	s i=0,preLocId=""
  	s transSub=0 f  s transSub=$O(^PAADM(EpisodeID,"TRANS",transSub)) q:transSub=""  d
  	    .s transLocId=$P(^PAADM(EpisodeID,"TRANS",transSub),"^",6)
  	    .i (transLocId'="")&(transLocId'=preLocId) d
  	        ..s i=i+1
  	        ..s preLocId=transLocId
        .//w "transSub="_transSub_"/i="_i_"/num="_transLocNum_"/ctlocId="_curCtlocId,!
        .i i'>transLocNum d
            ..s transWardId=$P(^PAADM(EpisodeID,"TRANS",transSub),"^",9)
            ..i transWardId'="" d
                ...s transWardLocId=$p($g(^PAWARD(transWardId)),"^",5)
                ...i (+curCtlocId'=0)&('$d(^CTLOC(transWardLocId,"LINK",0,"Loc",+curCtlocId))) s transWardId="" q
                ...s curWardId=transWardId
            ..//w "transSub="_transSub_"/i="_i_"/num="_transLocNum_"/ctlocId="_curCtlocId_" curWardId="_curWardId,"/"_transWardId,!
            ..q:transWardId=""
            ..s transBedId=$P(^PAADM(EpisodeID,"TRANS",transSub),"^",8)
            ..i transWardId'=+transBedId q
            ..i transBedId'="" s curBedId=transBedId
            ..s transRoomId=$P(^PAADM(EpisodeID,"TRANS",transSub),"^",7)
            ..i transRoomId'="" s curRoomId=transRoomId
            ..//w "transSub="_transSub_"/warid="_curWardId_"/curRoomId="_curRoomId,!
  	s retStr=curCtlocId_"^"_curWardId_"^"_curRoomId_"^"_curBedId
  	q retStr
}

// ck 20100914 通过本机ip获取手术间 

// 返回 手术间ID^手术间Desc

ClassMethod GetRoomIdByIp(ipConfig) As %String
{
	s retStr=""
	s roomId="" f  s roomId=$o(^DHCANRoomEquip(0,"Room",roomId)) q:roomId=""  d
		.s anreId="" f  s anreId=$o(^DHCANRoomEquip(0,"Room",roomId,anreId)) q:anreId=""  d
			..s anreETAddress=$p($g(^DHCANRoomEquip(anreId)),"^",7)
			..q:anreETAddress=""
			..i ("|"_anreETAddress_"|")[("|"_ipConfig_"|") s retStr=roomId_"^"_$p($g(^DHCANC("OPRoom",roomId)),"^",2)
	q retStr
}

// w ##class("web.DHCANOPCom").GetOperDate("")

ClassMethod GetOperDateOld(date = "") As %String
{
	i date="" s date=+$h
	s curDate=date
	f i=1:1:14 d
		.q:date'=curDate
		.s curDay=$zd(date+i,10)
		.i ((curDay=6)!(curDay=0))&($d(^DHCANCAPPDATE(curDate+i))>0) s date=curDate+i
		.i ("12345"[curDay)&($d(^DHCANCAPPDATE(curDate+i))=0) s date=curDate+i
	q date
}

/// 返回值：holidayFlag
/// holidayFlag: 节日2/假日1/非节假日0 /错误 -1
/// w ##class(web.DHCANOPCom).GetOperDateNew()
ClassMethod GetOperDate(date2 = "") As %String
{
	
	s format=##class(websys.Conversions).DateFormat()
	i date2'="" s date=$zdh(date2,format)
	i date2="" s date=+$h
	s curDate=date
	s byHisFlag="Y"
	//20180315+dyl
	s newdate=0,find=0
	i byHisFlag="Y" d
		.f i=1:1:14 d
			..q:find=1
			..s flag=##class(web.DHCBL.CT.BDPHoliday).IsHolidayDate($zd(date+i,format),"","")
			..s curDay=$zd(date+i,10)
			..i flag=0 s find=1,date=date+i
	e  d
		.f i2=1:1:14 d
			..q:date'=curDate
			..s curDay=$zd(date+i2,10)
			..i ((curDay=6)!(curDay=0))&($d(^DHCANCAPPDATE(curDate+i2))>0) s date=curDate+i2
			..i ("12345"[curDay)&($d(^DHCANCAPPDATE(curDate+i2))=0) s date=curDate+i2

	q date
}

// 20170302+dyl

ClassMethod GetInitialDateOld(userId, userGroupId = "", ctlocId = "") As %String
{
  	s format=##class(websys.Conversions).DateFormat()
	s date=..GetOperDate("")	
	i userId'="",$p(^CTLOC(+ctlocId),"^",13)="OP" d
		.s ctcpId=$p($g(^SSU("SSUSR",userId)),"^",14)
		.q:ctcpId=""
		.s ctcptId=$p($g(^CTPCP(ctcpId,1)),"^",4)
		.q:ctcptId=""
		.s ctcptType=$p(^CT("CPT",ctcptId),"^",4)
		.i ctcptType="DOCTOR" s date=+$h
	q $ZD(date,format)
}

// 20170302+dyl

ClassMethod GetInitialDate(userId, userGroupId = "", ctlocId = "") As %String
{
	s format=##class(websys.Conversions).DateFormat()
 	s date=$h
	q $ZD(date,format)
}

ClassMethod GetInitialDateTow(userId, userGroupId = "", ctlocId = "") As %String
{
  	s date=$h	
	q $ZD(date+1,4)
}

// 根据就诊号、日期，取小于等于日期(之前)的一个手术排班ID,重症用

ClassMethod GetPreviousOpaId(EpisodeID, date = "") As %String
{
	s date=..ConvertToDateH(date)
 	s opaId=""
 	s preOpaId=0,isFind="N"
 	f  s opaId=$o(^DHCANOPArrange(0,"Adm",EpisodeID,opaId),-1) q:(opaId="")!(isFind="Y")  d
 		.q:'$d(^DHCANOPArrange(opaId))
 		.s opaStatus=$p($g(^DHCANOPArrange(opaId)),"^",27)
 		.q:(opaStatus="")!("AD"[opaStatus)
 		.s anaId=$p(^DHCANOPArrange(opaId),"^",2)
 		.s opaStartDate="" //$p(^OR(+anaId,"ANA",$p(anaId,"||",2)),"^",39)
 		.i opaStartDate="" s opaStartDate=$p($g(^DHCANOPArrange(+opaId)),"^",14)
 		.q:(date'="")&(opaStartDate>date)
 		.s preOpaId=opaId
 		.s isFind="Y"
	q preOpaId
}

/// 根据手术ID取手术描述，delimiter为手术ID分割符，returnDelimiter为返回串中手术分割符
ClassMethod GetOperationDescById(operIdStr, delimiter = "^", returnDelimiter = "^") As %String
{
	i delimiter="" s delimiter="^"
	s retStr=""
	s num=$l(operIdStr,delimiter)
	f i=1:1:num d
		.s curOperId=$p(operIdStr,delimiter,i)
		.q:curOperId=""
		.s curOperDesc=$p($g(^ORC("OPER",curOperId)),"^",2)
		.i retStr'="" s retStr=retStr_returnDelimiter
		.s retStr=retStr_curOperDesc
	q retStr
}

/// 按时间找当前病区的最早转入时间，110803改后暂未用
ClassMethod GetWardInDateTime(EpisodeID, date = "", time = "") As %String
{
	q:(EpisodeID="") "^"
	s needWardId=""
	i date="" d
		.s date=+$h,time=$p($h,",",2)
	s dateTime=date+(time/100000)

	s transDate="",transTime="",startDate="",startTime=""
	s transSub="",exitMark=0,needWardId=""
  	f  s transSub=$O(^PAADM(EpisodeID,"TRANS",transSub),-1) q:(+transSub=0)!(exitMark)  d
  		.s transWardId=$P(^PAADM(EpisodeID,"TRANS",transSub),"^",9)
  		.q:(transWardId="")
  		.s transDate=$p(^PAADM(EpisodeID,"TRANS",transSub),"^",1)
  		.s transTime=$p(^PAADM(EpisodeID,"TRANS",transSub),"^",2)
  		.s transDateTime=transDate+(transTime/100000)
  		.q:dateTime<transDateTime
  		.i needWardId="" s needWardId=transWardId
  		.i transWardId'=needWardId s exitMark=1 q
  		.s startDate=transDate,startTime=transTime
	//q:(startDate="")!(startTime="") "该病人转病区信息有误!"
	;q startDate_"^"_startTime
	q ..ConvertToDateTime(startDate,startTime)
}

// 通过transWardList传返回转病区数组

ClassMethod GetAdmTransWardList(EpisodeID, transWardList) As %String
{
	k transWardList
	q:EpisodeID="" "就诊号为空!"
	s preWardId="",transSub=0,preDateTime=0
	f  s transSub=$O(^PAADM(EpisodeID,"TRANS",transSub)) q:transSub=""  d
    	.s transWardId=$P(^PAADM(EpisodeID,"TRANS",transSub),"^",9)
    	.q:(transWardId="")!(transWardId=preWardId)
    	.s dateTime=^PAADM(EpisodeID,"TRANS",transSub)+($p(^PAADM(EpisodeID,"TRANS",transSub),"^",2)/100000)
    	.i preDateTime>dateTime s dateTime=preDateTime+0.00001
    	.s transWardList(dateTime)=transWardId
    	.//w transWardList(dateTime)_"/"_dateTime,!
    	.s preWardId=transWardId
    	.s preDateTime=dateTime
	q 0
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

Query FindAnaOEOrdItem(opaId As %String, userId As %String, ctlocId As %String) As %Query(ROWSPEC = "arcimDesc:%String,arcimId:%String,qtyNum:%String,price:%String,sumPrice:%String,ctuomDesc:%String,oeoriId:%String,reLocDesc:%String,oeoriDate:%String,oeoriTime:%String,oeoriUserDesc:%String,priceStatus:%String,priceCode:%String,exRowId:%String,userId:%String")
{
}

ClassMethod FindAnaOEOrdItemExecute(ByRef qHandle As %Binary, opaId As %String, userId As %String, ctlocId As %String) As %Status
{
	Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1
    
	k TempOrdItem("OrdCatId")
	s count=0
	s priceCode=""
	s EpisodeID=$P(^DHCANOPArrange(+opaId),"^",1)
	s needAnaId=$P(^DHCANOPArrange(+opaId),"^",2)
	s oeordId=$O(^OEORD(0,"Adm",+EpisodeID,-1))
	s otherOperAppNo=$P(^DHCANOPArrange(opaId),"^",41) //海泰手术流水号
	//w oeordId_"/"_needAnaId_"/"_otherOperAppNo,!
	i (oeordId="")!(needAnaId="")!(otherOperAppNo="") s qHandle=$lb(0,repid,0) Quit $$$OK
	s oeoriSub=0 f  s oeoriSub=$O(^OEORD(oeordId,"I",oeoriSub)) q:oeoriSub=""  d
		.s anaId=$P($G(^OEORD(oeordId,"I",oeoriSub,4)),"^",9)
		.s count=count+1
		.q:anaId'=needAnaId
		.s arcimId=$P($G(^OEORD(oeordId,"I",oeoriSub,1)),"^",2)
		.q:$p($G(^OEORD(oeordId,"I",oeoriSub,1)),"^",13)=4
		.s arcimDesc=$P(^ARCIM($P(arcimId,"||",1),$P(arcimId,"||",2),1),"^",2)
		.s ItmCode=$P(^ARCIM($P(arcimId,"||",1),$P(arcimId,"||",2),1),"^",1)
		.s UserDepartme=$P($G(^OEORD(oeordId,"I",oeoriSub,7)),"^",2)
		.s AppointmentDate=$P($G(^OEORD(oeordId,"I",oeoriSub,1)),"^",9)
		.s sttdate=AppointmentDate
		.i (AppointmentDate'="") s AppointmentDate=$ZD(AppointmentDate,3)
		.s AppointmentTime=$P($G(^OEORD(oeordId,"I",oeoriSub,1)),"^",10)
		.i AppointmentTime'="" s AppointmentTime=$ZT(AppointmentTime,3)
		.s TDate=$P($G(^OEORD(oeordId,"I",oeoriSub,3)),"^",7)
		.i TDate'="" s TDate=$ZD(TDate,3)
		.s TTime=$P($G(^OEORD(oeordId,"I",oeoriSub,1)),"^",17)
		.i TTime'="" s TTime=$ZT(TTime,3)
		.s AdmType=$P(^PAADM(EpisodeID),"^",2)
		.i AdmType="O" s AdmType="门诊"
		.i AdmType="I" s AdmType="住院"
		.i AdmType="E" s AdmType="急诊"
		.s AdmReason=$P($G(^PAADM(EpisodeID),1),"^",7)
		.;仅限湘雅用 YuanLin 20170912
		.;s CheckPrice=##class(web.DHCOperPrice).CheckTar(oeordId,oeoriSub,EpisodeID,arcimId,"1","",userId,otherOperAppNo)
		.s price=##class(web.DHCDocOrderEntry).GetOrderPrice("", AdmReason, arcimId, "", "", "", "", "") 
		.s price=$P(price,"^",1)
		.s price=$j(price,3,2)
		.s qtyNum=$P($G(^OEORD(oeordId,"I",oeoriSub,1)),"^",12)
		.s priceStatus=##class(web.DHCOperPrice).CheckStatus(oeordId,oeoriSub,EpisodeID)
		.s sumPrice=qtyNum*price
		.s sumPrice=$j(sumPrice,3,2)
		.s ChangePrice="修改"
		.s oeoriId=oeordId_"||"_oeoriSub
		.s exId=$O(^DHCEXDE(0,"OEORI",EpisodeID,oeoriId,-1))
		.q:exId=""
		.i exId'="" d
			..s price=##class(web.DHCOperPrice).GetPrice(EpisodeID,oeoriId)
			..s sumPrice=price*qtyNum
			..s sumPrice=$j(sumPrice,3,2)
		.s oeoriId=oeordId_"||"_oeoriSub
		.s doseUOM=$p($g(^OEORD(oeordId,"I",oeoriSub,2)),"^",3)
		.s ctuomDesc=$p(^CT("UOM",+doseUOM),"^",2)
		.s reLocId=$p($g(^OEORD(oeordId,"I",oeoriSub,3)),"^",6)
		.q:ctlocId'=reLocId
		.s reLocDesc=$p($g(^CTLOC(reLocId)),"^",2)
		.s reLocDesc=$p(reLocDesc,"-",2)
		.s oeoriDate=$p($G(^OEORD(oeordId,"I",oeoriSub,11)),"^",4)
		.s oeoriDate=$Zd(oeoriDate,3)
		.s oeoriTime=$p($G(^OEORD(oeordId,"I",oeoriSub,11)),"^",5)
		.s oeoriTime=$ZT(oeoriTime,1)
		.s oeoriUserId=$p($g(^OEORD(oeordId,"I",oeoriSub,7)),"^",1)
		.s userLocId=$p($g(^OEORD(oeordId,"I",oeoriSub,7)),"^",2)
		.q:userLocId=""
		.;q:ctlocId'=userLocId
		.s userLocDesc=$p($g(^CTLOC(userLocId)),"^",2)
		.s userLocDesc=$p(userLocDesc,"-",2)
		.s oeoriUserDesc=$p($P(^SSU("SSUSR",oeoriUserId),"^",2),"-",1)
		.i (priceStatus'="")&(exId'="") Do
			..i $P($G(^DHCEXDE(exId)),"^",11)'="" s OEORDDate=$ZD($P($G(^DHCEXDE(exId)),"^",11),3)
			..i $P($G(^DHCEXDE(exId)),"^",12)'="" s OEORDTime=$ZT($P($G(^DHCEXDE(exId)),"^",12),1)
		.s priceStatus=$P($G(^DHCEXDE(exId)),"^",17)
		.i priceStatus="" s priceStatus="未划价"
		.i (priceStatus="0") s priceStatus="已划价"
		.i priceStatus=1 s priceStatus="已收费"
		.i priceStatus="F" s priceStatus="退费"
		.s ordCatId=##class(web.DHCClinicCom).GetOrdCatId(oeoriId)
		.s ordCatDesc=$p(^OEC("ORCAT",ordCatId),"^",2)
		.s temp=""
		.i ordCatId="7" s temp=1  //F—手术
		.e  i ordCatId="3" s temp=3  //A—西药
		.e  s temp=2
		.s TempOrdItem("OrdCatId",temp,exId)=$lb(arcimDesc,arcimId,qtyNum,price,sumPrice,ctuomDesc,oeoriId,reLocDesc,oeoriDate,oeoriTime,oeoriUserDesc,priceStatus,priceCode,exId,oeoriUserId)
	s ordno="" f  s ordno=$o(TempOrdItem("OrdCatId",ordno)) q:ordno=""  d
		.s exId="" f  s exId=$o(TempOrdItem("OrdCatId",ordno,exId)) q:exId=""  d
			..s data=TempOrdItem("OrdCatId",ordno,exId)
			..Do OutputOeordItem	 	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
    
OutputOeordItem
	//set Data=$lb(i,opname)
 	Set ^CacheTemp(repid,ind)=data //^TempOEORD("OrdCatId",ordno,exId)
 	Set ind=ind+1
	quit
}

ClassMethod FindAnaOEOrdItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindAnaOEOrdItemExecute ]
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

ClassMethod FindAnaOEOrdItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindAnaOEOrdItemExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod IfEffectOrd(oeoriId, arcimId) As %String
{
	q:(oeoriId="")&(arcimId="") ""
	s oeordId=+oeoriId,oeoriSub=$p(oeoriId,"||",2)
	s sttDate=""
   	i oeoriSub'="" d
		.s sttDate=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",9)
		.s arcimId=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",2)
	q:arcimId="" ""
    s arcimEffDateTo=$p($g(^ARCIM(+arcimId,$p(arcimId,"||",2),7)),"^")
    q:arcimEffDateTo="" "Y"
    i sttDate="" s sttDate=+$h
    i (arcimEffDateTo<sttDate) q "N"
	q "Y"
}

/// 数值时间比较，source晚于target返回1，小于返回-1，相等返回0
ClassMethod CompareDateTime(sourceDate, sourceTime, targetDate, targetTime) As %String
{
	s sourceDateTime=sourceDate+(sourceTime/100000)
	s targetDateTime=targetDate+(targetTime/100000)
	q:sourceDateTime>targetDateTime 1
	q:sourceDateTime<targetDateTime -1
	q 0
}

/// 查找诊断，返回诊断表childSub和描述:mrdiaSub_"|"_mrcidDesc_"^"_...
ClassMethod GetPatDiagnosis(EpisodeID As %String, icuaId As %String = "") As %String
{
	q:(+icuaId=0)&(EpisodeID="") ""
	i EpisodeID="" s EpisodeID=$p($g(^DHCICUArrange(+icuaId)),"^",1)
	q:EpisodeID="" ""
 	i +icuaId=0 s icuaId=##class(web.DHCICUCom).GetIcuaId(EpisodeID,"","")
	s mradmId=$P(^PAADM(EpisodeID),"^",61)
	s mrdiaSub=0,retStr=""
	f  s mrdiaSub=$O(^MR(mradmId,"DIA",mrdiaSub)) q:(mrdiaSub="")  d
		.s mrcidId=$p(^MR(mradmId,"DIA",mrdiaSub),"^")
		.i mrcidId'="" s mrcidDesc=$p($g(^MRC("ID",+mrcidId)),"^",2)
		.e  s mrcidDesc=$g(^MR(mradmId,"DIA",mrdiaSub,"DES",1))
		.q:mrcidDesc=""
		.i retStr'="" s retStr=retStr_$c(3)
		.s retStr=retStr_mrdiaSub_"|"_mrcidDesc
	s retStr=$p(^DHCICUArrange(+icuaId),"^",20)_"^"_retStr
	q retStr
}

/// 保存ICU诊断
ClassMethod SaveRelatedDiagnosis(icuaId As %String = "", mrdiaSubStr As %String) As %String
{
	q:(+icuaId=0) -1
	q:mrdiaSubStr="" -2
	q:'$d(^DHCICUArrange(+icuaId))
	s $p(^DHCICUArrange(+icuaId),"^",20)=mrdiaSubStr
	q 0
}

/// 20120424
/// w ##class(web.DHCANOPCom).GetLabInfo("^38")
/// 20120529+dyl
/// w ##class(web.DHCANOPCom).GetLabInfo("^77152")
ClassMethod GetLabInfo(admId = "") As %String
{
	s $p(retStr,"^",15)=""
    q:admId="" retStr
    s admId=$p(admId,"^",2)
    q:$o(^OEORD(0,"Adm",admId,""))="" retStr
    s labInfoStr=""
    s papmiId=$p($g(^PAADM(admId)),"^",1)
    s regNo=$p($g(^PAPER(papmiId,"PAT",1)),"^",1)
	s TCSync0="ABO",TCSync1="RH",TCSync6="ALT",TCSync8="HBSAG",TCSync12="ANTIHCV",TCSync13="ANTIHIV",TCSync14="TPHA"
	S BloodTypeStr=##class(LabService.TCResult).GetTCResultByRegNo(regNo,"ABO")
	s BloodType=$p(BloodTypeStr,$c(2),3)
	//i BloodType="" s BloodType=$p(BloodType1,"RH",1)
	S RHBloodTypeStr=##class(LabService.TCResult).GetTCResultByRegNo(regNo,"RH")
	s RHBloodType=$p(RHBloodTypeStr,$c(2),3)
	i RHBloodType["阴性" s RHBloodType="阴性(-)"
	e  i RHBloodType'="" s RHBloodType="阳性(+)"
	s LabALTStr=##class(LabService.TCResult).GetTCReesultByAdmNo(admId,"ALT")
	s LabALT=$p(LabALTStr,$c(2),3)
	;乙肝
	s LabHBSAG=""
	s LabHBSAGStr=##class(LabService.TCResult).GetTCReesultByAdmNo(admId,"HBsAg")
	s LabHBSAGValue=$p(LabHBSAGStr,$c(2),3)
	s LabHBSAGRange=$p(LabHBSAGStr,$c(2),6)
	S maxLabHBSAG=$p(LabHBSAGRange,"-",2)
	;i $p(LabHBSAGRange,"~",1)="" s maxLabHBSAG=$p(LabHBSAGRange,"~",2)
	i maxLabHBSAG="" s LabHBSAG=LabHBSAGValue
	e  i ((LabHBSAGValue'="")&(maxLabHBSAG'="")) d
		.i (LabHBSAGValue>maxLabHBSAG) s LabHBSAG="阳性(+)"
		.e  s LabHBSAG="阴性(-)"
	;丙肝
	s LabHCVAB=""	
	s LabHCVABStr=##class(LabService.TCResult).GetTCReesultByAdmNo(admId,"HCV-Ab")
	s LabHCVABValue=$p(LabHCVABStr,$c(2),3)
	s LabHCVABRange=$p(LabHCVABStr,$c(2),6)
	S maxLabHCVAB=$p(LabHCVABRange,"-",2)
	;i $p(LabHBSAGRange,"~",1)="" s maxLabHBSAG=$p(LabHBSAGRange,"~",2)
	i maxLabHCVAB="" s LabHCVAB=LabHCVABValue
	e  i ((LabHCVABValue'="")&(maxLabHCVAB'="")) d
		.i (LabHCVABValue>maxLabHCVAB) s LabHCVAB="阳性(+)"
		.e  s LabHCVAB="阴性(-)"
	;HIV
	s LabHIVABStr=##class(LabService.TCResult).GetTCReesultByAdmNo(admId,"HIV-Ab")
	s LabHIVAB=$p(LabHIVABStr,$c(2),3)
	i ((LabHIVAB["大于临界值")!(LabHIVAB["阳性")) s LabHIVAB="阳性(+)"
	e  i LabHIVAB'="" s LabHIVAB="阴性(-)"
	;梅毒
	s Labchmd=""
	s LabchmdStr=##class(LabService.TCResult).GetTCReesultByAdmNo(admId,"TPAb")
	s LabchmdValue=$p(LabchmdStr,$c(2),3)
	s LabchmdRange=$p(LabchmdStr,$c(2),6)
	S maxLabchmd=$p(LabchmdRange,"-",2)
	;i $p(LabchmdRange,"~",1)="" s maxLabchmd=$p(LabchmdRange,"~",2)
	i maxLabchmd="" s Labchmd=LabchmdValue
	e  i ((LabchmdValue'="")&(maxLabchmd'="")) d
		.i (LabchmdValue>maxLabchmd) s Labchmd="阳性(+)"
		.e  s Labchmd="阴性(-)"


	s labInfoStr=BloodType_"^"_RHBloodType_"^"_LabALT_"^"_LabHBSAG_"^"_LabHCVAB_"^"_LabHIVAB_"^"_Labchmd
	q labInfoStr
}

ClassMethod GetUserType(userId As %String) As %String
{
	//取用户的类别:医生还是护士
	q:userId="" "用户有误!"
	s ctpcpId=$p($g(^SSU("SSUSR",userId)),"^",14)
	q:ctpcpId="" "该用户未关联医护人员!"
	s ctcptId=$P($g(^CTPCP(ctpcpId,1)),"^",4)  ;CTPCP_CarPrvTp_DR
	q:ctcptId="" "该医护人员未定义医护类型!"
    s ctcptInternalType=$P($g(^CT("CPT",ctcptId)),"^",4)  ;CT_CarPrvTp:CTCPT_InternalType
	q:ctcptInternalType="" "医护人员类型定义有误!"
	q ctcptInternalType
}

ClassMethod IsPacuSumByArcimId(ArcimId As %String) As %String
{
	//w ##class(web.DHCANOPCom).IsPacuSumByArcimId("2804||1")
	q:ArcimId="" "ArcimId不能为空!"
	s retStr="-1"
	s ARCIMBillSubDR=$p(^ARCIM($p(ArcimId,"||",1),$p(ArcimId,"||",2),1),"^",9)
	s ARCSGCode=$p(^ARCBG($p(ARCIMBillSubDR,"||",1),"SG",$p(ARCIMBillSubDR,"||",2)),"^",1)
	;q ARCSGCode
	i ARCSGCode="PacuSum" s retStr="0"
	e  s retStr="-1"
	q retStr
}

ClassMethod GetAdmType(admId = "") As %String
{
	i admId="" q ""
	q $p(^PAADM(admId),"^",2)
}

/// 第一级以"^"分割,分为医嘱串,药学串,等效单位串,常用医嘱串;第二级以$c(3)分割。
/// 医嘱串：1-10:arcimId,代码,名称,缩写名,子分类Id,账单子组Id,整包装单位Id,单价,有效期开始,有效期截止,
/// 	   11-20:接收科室,外部代码
/// 药学串：通用名,默认频率Id,默认用法Id,基本单位Id
/// 等效单位串：等效单位串(以#c(3)分割多条，每条以"|"分割:等效单位Id,转换因子,缺省数量),
/// 常用医嘱串:ancoId
ClassMethod GetArcim(arcimId, EpisodeID = "", date = "") As %String
{
	q:arcimId="" ""
	//q:##class(web.DHCANOPCom).IfEffectOrd("",arcimId)'="Y" ""
	i date="" s date=+$h
	
	s lAncoId=0,ancoId=""
	f  s lAncoId=$o(^DHCANC("ComOrd",lAncoId)) q:(lAncoId="")!(ancoId>0)  d
		.i arcimId=$p(^DHCANC("ComOrd",lAncoId),"^",4) s ancoId=lAncoId
	s arcimCode=$p($g(^ARCIM(+arcimId,+$p(arcimId,"||",2),1)),"^",1)
	s arcimDesc=$p($g(^ARCIM(+arcimId,+$p(arcimId,"||",2),1)),"^",2)
	s arcimAbbrev=$p($g(^ARCIM(+arcimId,+$p(arcimId,"||",2),1)),"^",3)
	s arcicId=$p($g(^ARCIM(+arcimId,+$p(arcimId,"||",2),1)),"^",10)
	s arcsgId=$p($g(^ARCIM(+arcimId,+$p(arcimId,"||",2),1)),"^",9)
	s packUomId=$p($g(^ARCIM(+arcimId,+$p(arcimId,"||",2),8)),"^",14)
	s itemPrice=+##Class(web.DHCDocOrderEntry).GetOrderPrice("","",arcimId,date,"","","","") //+##CLASS(UDHCJFPRICE).GetOrderPrice("","",arcimId,date,"","","","")
	s arcimEffDate=$zd(+$p($g(^ARCIM(+arcimId,+$p(arcimId,"||",2),1)),"^",13),3)
	s arcimEffDateTo=$zd($p($g(^ARCIM(+arcimId,+$p(arcimId,"||",2),7)),"^",1),3)
	s retStr=arcimId_$c(3)_arcimCode_$c(3)_arcimDesc_$c(3)_arcimAbbrev_$c(3)_arcicId_$c(3)_arcsgId_$c(3)_packUomId_$c(3)_itemPrice_$c(3)_arcimEffDate_$c(3)_arcimEffDateTo
    
	s extCode=""
    s extSub="" f  s extSub=$o(^ARCIM(+arcimId,+$p(arcimId,"||",2),"EXT",extSub)) q:extSub=""  d
    	.s extDateTo=$p(^ARCIM(+arcimId,+$p(arcimId,"||",2),"EXT",extSub),"^",2)
    	.q:(extDateTo'="")&(extDateTo<+$h)
    	.s extCode=$p(^ARCIM(+arcimId,+$p(arcimId,"||",2),"EXT",extSub),"^",4)
	s recLocId=+##class(web.DHCANCall).GetOrderItemRecloc("",arcimId,EpisodeID)
    s retStr=retStr_$c(3)_recLocId_$c(3)_extCode
	
	s retStr=retStr_"^"_..GetPhcdfInfo(arcimId)
	s retStr=retStr_"^"_ancoId
	q retStr
}

/// 第一级以"^"分割,药学串，等效单位串;第二级以$c(3)分割。
/// 药学串：通用名,默认频率Id,默认用法Id,基本单位Id
/// 等效单位串：等效单位串(以#c(3)分割多条，每条以"|"分割等效单位Id,转换因子,缺省数量),
ClassMethod GetPhcdfInfo(arcimId) As %String
{
	s eqUomIdStr="",eqDefDoseStr=1,baseUomId="",eqQtyStr=1,volume=1
	q:arcimId="" eqUomIdStr_"^"_eqDefDoseStr_"^"_baseUomId_"^"_eqQtyStr_"^"_volume
	s baseUomId=$p($g(^ARCIM(+arcimId,$p(arcimId,"||",2),8)),"^",14)
	s eqUomIdStr=baseUomId
	s phcdfId=$p($g(^ARCIM(+arcimId,$p(arcimId,"||",2),1)),"^",12)
	q:phcdfId="" eqUomIdStr_"^"_eqDefDoseStr_"^"_baseUomId_"^"_eqQtyStr_"^"_volume
	s phcdId=+phcdfId,phcdfSub=$p(phcdfId,"||",2)
	q:phcdfSub="" eqUomIdStr_"^"_eqDefDoseStr_"^"_baseUomId_"^"_eqQtyStr_"^"_volume
	s baseUomId=$p($g(^PHCD(phcdId,"DF",phcdfSub,2)),"^",4)
	s phcgeId=$p($g(^ARCIM(+arcimId,+$p(arcimId,"||",2),8)),"^",20) // ARCIM_Generic_DR
	s phcgeName=$p(^PHCGE("GE",+phcgeId),"^",2)
	
	s volume=""
	s volUomId=$o(^CT("UOM",0,"Code","ML",""))
	s eqStr=""
	s eqId=0,haveData=0
	f  s eqId=$o(^PHCD(phcdId,"DF",phcdfSub,"EQ",eqId)) q:eqId=""  d
		.s eqUomId=+^PHCD(phcdId,"DF",phcdfSub,"EQ",eqId)
		.s eqQty=$p(^PHCD(phcdId,"DF",phcdfSub,"EQ",eqId),"^",2)
		.s eqDefDose=$p(^PHCD(phcdId,"DF",phcdfSub,"EQ",eqId),"^",3)
		.i eqQty=0 s eqQty=1
		.i $p(eqQty,".",1)="" s eqQty=0_eqQty
		.i $p(eqDefDose,".",1)="" s eqDefDose=0_eqDefDose
		.//i eqDefDose<1 s eqDefDose=eqQty
		.//i eqDefDose<1 s eqDefDose=1
		.q:(eqUomId="")!(eqQty=0)
		.i +eqDefDose=0 s eqDefDose=eqQty
		.
		.i eqStr'="" s eqStr=eqStr_$c(3)
		.s eqStr=eqStr_eqUomId_"|"_eqQty_"|"_eqDefDose
		.i volUomId=eqUomId d
		    ..s volume=eqQty
		    ..i +volume=0 s volume=1
		.s haveData=1
	s defPhcinId=""
	s phcdfId=$p($g(^ARCIM(+arcimId,+$p(arcimId,"||",2),1)),"^",12)
	s phcdId=+phcdfId,phcdfSub=+$p(phcdfId,"||",2)

	i phcdfSub'="" d
		.s defPhcfrId=$p($g(^PHCD(phcdId,"DF",phcdfSub,1)),"^",4)
		.s defPhcinId=$p($g(^PHCD(phcdId,"DF",phcdfSub,1)),"^",5)
	q phcgeName_$c(3)_defPhcfrId_$c(3)_defPhcinId_$c(3)_baseUomId_"^"_eqStr //_"^"_volume
}

/// 第一级以"^"分割多个频率串;第二级以$c(3)分割:频率Id,频率Code,频率因子,频率描述1,频率描述2,时间串(以"|"分割)
ClassMethod GetPhcFreqInfo() As %String
{
	s phcfrId=0,retStr=""
	f  s phcfrId=$o(^PHCFR(phcfrId)) q:phcfrId=""  d
		.s phcfrCode=$p(^PHCFR(phcfrId),"^",1)
		.s phcfrFactor=$p(^PHCFR(phcfrId),"^",2)
		.s phcfrDesc1=$p(^PHCFR(phcfrId),"^",3)
		.s phcfrDesc2=$p(^PHCFR(phcfrId),"^",4)
		.s phcdtSub=0,phcdtTimeStr=""
		.f  s phcdtSub=$o(^PHCFR(phcfrId,"DT",phcdtSub)) q:phcdtSub=""  d
			..i phcdtTimeStr'="" s phcdtTimeStr=phcdtTimeStr_"|"
			..s phcdtTimeStr=phcdtTimeStr_$zt(^PHCFR(phcfrId,"DT",phcdtSub))
		.i retStr'="" s retStr=retStr_"^"
		.s retStr=retStr_phcfrId_$c(3)_phcfrCode_$c(3)_phcfrFactor_$c(3)_phcfrDesc1_$c(3)_phcfrDesc2_$c(3)_phcdtTimeStr
	q retStr
}

ClassMethod GetPatientEpisodeID(regNo, papmiId = "", fromDate = "", toDate = "") As %String
{
	q:(regNo="")&(papmiId="") ""
	s fromDate=..ConvertToDateH(fromDate,"")
	s toDate=..ConvertToDateH(toDate,"")
	i papmiId="" s papmiId=$o(^PAPERi("PAPMI_PatNo",$$ALPHAUP^SSUTIL4(regNo),""))
	q:papmiId="" ""
	s EpisodeID="",EpisodeIDList=""
	f  s EpisodeID=$o(^PAPERdr(papmiId,"ADM","I",EpisodeID),-1) q:EpisodeID=""  d  
		.s paadmVisitStatus=$p($g(^PAADM(EpisodeID)),"^",20)
		.q:(paadmVisitStatus'="A")&(paadmVisitStatus'="D")
		.s admDate=$p($g(^PAADM(EpisodeID)),"^",6)
		.q:(fromDate'="")&(admDate<fromDate)
		.q:(toDate'="")&(admDate>toDate)
		.i EpisodeIDList'="" s EpisodeIDList=EpisodeIDList_"^"
		.s EpisodeIDList=EpisodeIDList_EpisodeID
	q EpisodeIDList
}

/// Creator：      	ypz
/// CreatDate：    	2011-12-22
/// Description： 	根据排班Id或麻醉Id，取一次手术申请的全部手术和主刀医生//原为GetAnaIdAndAnaopId
/// Table：        	DHC_AN_Oparrange,OR_Anaesthesia,OR_Anaest_Operation
/// Input：        	opaId手术排班Id,麻醉表Id
/// Return：       	返回:第一级用"^"分割，第二级以$c(3)分割:手术Id,手术码表Id,手术名,主/从手术(M/S),主刀ctcpId,主刀医生名
ClassMethod GetAnaOperationItem(opaId, anaId = "") As %String
{
	q:(+opaId=0)&(+anaId=0) "手术申请号和麻醉Id不能同为空!"
	i opaId="",anaId'="" d
		.s curOpaId=""
		.f  s curOpaId=$o(^DHCANOPArrange(0,"Adm",+anaId,curOpaId)) q:curOpaId=""  d
			..i anaId=$p(^DHCANOPArrange(curOpaId),"^",2) s opaId=curOpaId
	q:$d(^DHCANOPArrange(+opaId))<1 "申请号有误！"
	q:$p($g(^DHCANOPArrange(opaId)),"^",27)="D" "手术已停止!"
	s anaId=$p(^DHCANOPArrange(opaId),"^",2) //OPA_Anaest_dr
	s EpisodeID=+anaId
	s anaSub=$p(anaId,"||",2)
	q:anaSub="" "^"
	s retStr="",mainSurgId="",mainSurgDesc=""
	
	s anaopSub=0
	f  s anaopSub=$O(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub)) q:(anaopSub="")  d
		.s anaopOperType=$P(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub),"^",12)
		.s operId=$P(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub),"^",6)       ;ANAOP_Type_DR     ；手术名称
		.s operDesc=$P(^ORC("OPER",+operId),"^",2)
		.i operDesc="" s operDesc=$g(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub,"REM",2))
		.q:(operId="")&(operDesc="")
		.//s planOperId=$p($g(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub,"DHC")),"^",2)
		.//s planOperDesc=$P(^ORC("OPER",+planOperId),"^",2)
		.s surgId=$P(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub),"^",8)   ;ANAOP_Surgeon_DR  ；手术医师
		.s surgDesc=##class(web.DHCANOPCom).GetNameById(surgId)
		.i surgId="" s surgDesc=$p($p(^DHCANOPArrange(opaId),"^",42),"|",2)
		.i anaopOperType="M" s mainSurgId=surgId,mainSurgDesc=surgDesc
		.i surgId="" s surgId=mainSurgId,surgDesc=mainSurgDesc
		.i retStr'="" s retStr=retStr_"^"
		.s retStr=retStr_EpisodeID_"||"_anaSub_"||"_anaopSub_$c(3)_operId_$c(3)_operDesc_$c(3)_anaopOperType_$c(3)_surgId_$c(3)_surgDesc
	q retStr
}

/// Creator：      	ypz
/// CreatDate：    	2012-01-12
/// Description： 	修改麻醉科医生、麻醉科护士、手术室护士录医嘱标记
/// Table：        	DHC_AN_Oparrange,OR_Anaesthesia,CT_CareProv
/// Input：        	手术排班表Id,麻醉表Id,用户Id,科室类型("AN"为麻醉科,"OP"为手术室),修改值(Y/N)
/// Return：       	返回:成功0，否则提示信息。
ClassMethod UpdateAnOpOrdered(opaId, anaId, userId, locType, isOrdered = "Y") As %String
{
	q:(+opaId=0)&(+anaId=0) "手术申请Id和麻醉Id不能同为空!"
	i opaId="",anaId'="" d
		.s curOpaId=""
		.f  s curOpaId=$o(^DHCANOPArrange(0,"Adm",+anaId,curOpaId)) q:curOpaId=""  d
			..i anaId=$p(^DHCANOPArrange(curOpaId),"^",2) s opaId=curOpaId
	q:+opaId<1 "手术申请Id和麻醉Id错!"
	q:$d(^DHCANOPArrange(+opaId))<1 "申请号有误!"
	q:$p($g(^DHCANOPArrange(+opaId)),"^",27)="D" "手术已停止!"
	q:"YN"'[isOrdered "录医嘱标识不对!"
	
	s ctcpId=$p($g(^SSU("SSUSR",+userId)),"^",14)
	s ctcptId=$p($g(^CTPCP(+ctcpId,1)),"^",4)
	s ctcptType=$p(^CT("CPT",+ctcptId),"^",4)
	q:(ctcptType'="DOCTOR")&(ctcptType'="NURSE") "非医护人员!"
	s delimPos=0
	i ctcptType="DOCTOR",locType="AN" s delimPos=48
	i ctcptType="NURSE" d
		.i locType="AN" s delimPos=49
		.e  s delimPos=50
	q:delimPos=0 "科室类型有误!"
	//wull130315
	i delimPos=50 d
	.i ($p($g(^DHCANOPArrange(opaId)),"^",79)="") d
	..s $p(^DHCANOPArrange(opaId),"^",79)=+$h
	..s $p(^DHCANOPArrange(opaId),"^",80)=$p($h,",",2)
	s $p(^DHCANOPArrange(opaId),"^",delimPos)=isOrdered
	q 0
}

ClassMethod GetCtlocDescById(ctlocId = "") As %String
{
	q $p($g(^CTLOC(+ctlocId)),"^",2)
}

ClassMethod GetCurentDate(ifDisbled As %String = "") As %String
{
	s date=$h
	s dateformatnum=##class(websys.Conversions).DateFormat()
	i dateformatnum="" s dateformatnum=4
	i ifDisbled'="" s date=$zd($h,dateformatnum)
	q date
}

// 20161214+dyl+撤销手术

// w ##class(web.DHCANOPCom).UpdateReasSusp(66,2,1)

ClassMethod UpdateReasSusp(opaId As %String = "", suspId As %String = "", userId As %String) As %String
{
	q:opaId="" "手术申请Id必须非空!"
	q:suspId="" "手术撤销原因必须非空!"
	s retStr=""
	//&sql(update SQLUSER.DHC_AN_OPArrange set OPA_ReturnReason_Dr=:suspId,OPA_Status="C" where opa_rowid=:opaId)
	//i SQLCODE'=0 s retStr="更新手术撤销原因失败!"
	//i SQLCODE=0 d
	s anaId=$P(^DHCANOPArrange(opaId),"^",2)
	s ordId=$o(^OEORDi(0,"Ana",anaId,""))
	s ordSubId=$o(^OEORDi(0,"Ana",anaId,ordId,""))
	s orderId=ordId_"||"_ordSubId
	s ordStat=""
	s ordEctStatCode=""
	s ordEctStatId=$p(^OEORD(ordId,"I",ordSubId,"X",1),"^",16)
	i ordEctStatId'="" d
		.s ordEctStatCode=$p(^OEC("STAT",ordEctStatId),"^",1)
		.i ordEctStatCode="F" s retStr="该医嘱已执行,无法取消申请"
	i retStr="" d
		.s ret=##class(appcom.OEOrdItem).CancelMulti(orderId,userId,"","N")
		.TSTART
		.&sql(select * into :PLIST() from SQLUSER.DHC_AN_OPArrange where opa_rowid=:opaId)
		.&sql(update SQLUSER.DHC_AN_OPArrange set OPA_ReturnReason_Dr=:suspId,OPA_Status="C" where opa_rowid=:opaId)
		.i SQLCODE'=0 s retStr="更新手术撤销原因失败!" TROLLBACK
		.i SQLCODE=0 TCOMMIT
	q retStr
}

ClassMethod ChangeAnopStat(stat, opaId, patstatus) As %String
{
	q:(opaId="")!(stat="") "手术申请Id和手术状态必须非空!"
	TSTART
  //改变状态
	&sql(select * into :PLIST() from SQLUSER.DHC_AN_OPArrange where opa_rowid=:opaId)
	s PLIST(20)=stat
	s PLIST(11)=patstatus
	&sql(update SQLUSER.DHC_AN_OPArrange Values :PLIST() where opa_rowid=:opaId)
	i SQLCODE'=0 TROLLBACK  q "err"_""_SQLCODE
	//s $p(^DHCANOPArrange(opaId),"^",27)=stat
	
	s retStr=""
	s (opaRoom,opaSeq,ctcpAnDoc,ctcpAnNur,ctcpDevNur,ctcpTourNur,opstTime)=""
	s opId=opaId
	//s retStrMessage=##class(web.DHCANArrange).SendMessage(opId,opaRoom,opaSeq,ctcpAnDoc,ctcpAnNur,ctcpDevNur,ctcpTourNur,opstTime)
	//i retStrMessage="-1" s retStr="发送消息失败！"
	//i retStrMessage="-1" TROLLBACK
	//i retStrMessage="0" s retStr=""
	i retStr="" TCOMMIT
	q retStr
}

Query GetSpeedUnitList() As %SQLQuery(CONTAINID = 1)
{
	SELECT %ID As Id,
	   ANCSU_Code As Code,
	   ANCSU_Desc As Description,
	   ANCSU_Type As Type,
	   ANCSU_Uom_Dr As UomId,
	   ANCSU_Factor As Factor,
	   ANCSU_ByPatWeight As ByPatWeight,
	   ANCSU_BaseSpeedUnit_Dr As BaseSpeedUnitId,
	   ANCSU_BaseUomFactor As BaseUomFactor FROM DHC_ANC_SpeedUnit
}

ClassMethod GetAncoIdByAncvcCode(ancvcCodeList) As %String
{
	s ancoIdList=""
	i ancvcCodeList'="" d
		.s ancvcIdList=""
		.f i=1:1:$l(ancvcCodeList) d
			..s ancvcCode=$p(ancvcCodeList,"^",i)
			..s ancvcId=""
			..i ancvcCode'="" s ancvcId=$o(^DHCANC("ViewCat",0,ancvcCode,""))
			..q:ancvcId=""
			..i ancvcIdList'="" s ancvcIdList=ancvcIdList_"^"
			..s ancvcIdList=ancvcIdList_ancvcId
		.q:ancvcIdList=""
		.s ancoId="5000"
		.f  s ancoId=$o(^DHCANC("ComOrd",ancoId)) q:ancoId=""  d
			..s ancvcId=$p($g(^DHCANC("ComOrd",ancoId)),"^",5)
			..q:("^"_ancvcIdList_"^")'[("^"_ancvcId_"^")
			..i ancoIdList'="" s ancoIdList=ancoIdList_"^"
			..s ancoIdList=ancoIdList_ancoId
	q ancoIdList
}

/// 20120717+dyl
/// d ##class(%ResultSet).RunQuery("web.DHCANOPCom","FindUserByLoc",42)
Query FindUserByLoc(locId) As %Query(ROWSPEC = "CareprovId,CareprovDesc,Id,Name,Account,GroupId")
{
}

ClassMethod FindUserByLocExecute(ByRef qHandle As %Binary, locId) As %Status
{
	s repid=$I(^CacheTemp)	
	s ind=1
	i locId="" Set qHandle=$lb(0,repid,0) Quit $$$OK

	s locIdList=locId_"^"_##class(web.DHCClinicCom).GetLinkLocId(locId)
	f i=1:1:$l(locIdList,"^") d
		.s curLocId=$p(locIdList,"^",i)
		.q:+curLocId=0
		.s resId=""
		.f  s resId=$O(^RB("RES",0,"CTLOC",curLocId,resId))  q:resId=""  d
			..;医护人员Id
			..q:($p(^RB("RES",resId),"^",19)'="")&($p(^RB("RES",resId),"^",19)<$h)
			..s ctcpId=$P(^RB("RES",resId),"^",2)
			..q:ctcpId=""
			..s ctcptDesc=$p($g(^CTPCP(+ctcpId,1)),"^",2)
			..;医护人员类型
			..//s ctcptId=$p($g(^CTPCP(ctcpId,1)),"^",4)
			..//q:ctcptId=""
			..//s ctcptType=$p($g(^CT("CPT",ctcptId)),"^",4)
			..;UserId
			..s userId=$o(^SSU("SSUSR",0,"CTPCP",ctcpId,""))
			..q:userId=""
			..s userName=$p($g(^SSU("SSUSR",userId)),"^",2)
			..;登录号？
			..;s ssusrInitials=$o(^SSU("SSUSR",0,"SSUSR_Initials",ctcpId,""))
			..s ssusrInitials=$p($g(^SSU("SSUSR",userId)),"^",1)
			..;默认登录安全组Id
			..s groupId=$p($g(^SSU("SSUSR",userId)),"^",5)
			..s tmpLId=""
			..;其他登录安全组
			..f  s tmpLId=$o(^SSU("SSUSR",userId,"OTHLL",tmpLId))   q:tmpLId=""  d
				...q:$d(^SSU("SSUSR",userId,"OTHLL",tmpLId))<1
				...;登录科室Id
				...s tmpLocId=$p(^SSU("SSUSR",userId,"OTHLL",tmpLId),"^",1)
				...q:tmpLocId'=curLocId
				...;登录安全组Id
				...s tmpGroupId=$p($g(^SSU("SSUSR",userId,"OTHLL",tmpLId)),"^",2)
				...i (tmpGroupId'="")&(("^"_groupId_"^")'[("^"_tmpGroupId_"^")) d
					....i groupId'="" s groupId=groupId_"^"
					....s groupId=groupId_tmpGroupId
			..d OutputRow
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
    
OutputRow
	set Data=$lb(ctcpId,ctcptDesc,userId,userName,ssusrInitials,groupId)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindUserByLocClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindUserByLocExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindUserByLocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindUserByLocExecute ]
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

/// 取医嘱信息：
/// 入参：医嘱表RowId或医嘱执行表RowId
/// 返回值：用"^"分割的几部分：oecprType:Y/N/"",Y长嘱，N临嘱，""不应执行的医嘱(取药、出院带药);oecprCode:医嘱优先级代码;
///         phcinId:用法指针;phcinCode:用法代码;phcinDesc：用法描述,mainOeoriId:主医嘱RowId;subOeoriId:从医嘱RowId,
///         defPhcinId:缺省用法指针;defPhcinCode:缺省用法代码;defPhcinDesc：缺省用法描述;用"!"分割
///         oriQty:医嘱药品为剂量，非药品其它为数量;unitUomId:医嘱单位。
///         注：如果医嘱是从医嘱mainOeoriId有值，如果是主医嘱，从医嘱subOeoriId有值。
ClassMethod GetOeorditemInfo(oeoriId As %String) As %String
{
	//w ##class(web.DHCICUOrder).GetOeorditemInfo("911637||7")
	s oeoriSub=$p(oeoriId,"||",2)
	q:oeoriSub="" ""
	s oeordId=+oeoriId
	s oeoriId=oeordId_"||"_oeoriSub
	s ordStatCode=##Class(web.DHCClinicCom).GetOrdStatCode(oeoriId)
    q:("VED"'[ordStatCode)&("TPD"'[ordStatCode) ""
    s oecprId=$p(^OEORD(oeordId,"I",oeoriSub,1),"^",8)
    s oecprCode=""
    i oecprId>0 s oecprCode=$p($g(^OECPR(+oecprId)),"^",1)
    s oecprDesc=$p($g(^OECPR(+oecprId)),"^",2)
    s oecprType=""
    i (oecprCode="S")!(oecprCode="OMST") s oecprType="Y" //长期医嘱
    i ((oecprCode="NORM")!(oecprCode="OM")!(oecprCode="STAT")!(oecprCode="PRN")) s oecprType="N" //临时医嘱
    s phcinId=$p($g(^OEORD(oeordId,"I",oeoriSub,2)),"^",7) //医嘱用法指针
    s phcinCode="",phcinDesc="" 
    i phcinId'="" s phcinCode=$p($g(^PHCIN(phcinId)),"^",1),phcinDesc=$p($g(^PHCIN(phcinId)),"^",2)
	s mainOeoriId=$p($g(^OEORD(oeordId,"I",oeoriSub,11)),"^",39)
	s subOeoriId=""
	i oeoriSub'="" d
	    .s curOriSub=""
	    .f  s curOriSub=$o(^OEORDi(0,"OEORI",oeordId,oeoriId,curOriSub)) q:(curOriSub="")  d
		    ..i subOeoriId'="" s subOeoriId=subOeoriId_"!"
		    ..s subOeoriId=subOeoriId_oeordId_"||"_curOriSub
	
	//for 第三方HIS begin
	s EpisodeID=+^OEORD(+oeoriId)
	s lhnOrderNo=$o(^DHCLHN(0,"OEORI",EpisodeID,oeoriId,""))
	i lhnOrderNo'="" d //以此为标志
	    .s mainOeoriId=""
	    .s subOeoriId=""
	    .s mainLhnId=$o(^DHCLHN(0,"PAADM",EpisodeID,lhnOrderNo,1,""))
	    .q:mainLhnId=""
	    .q:'$d(^DHCLHN(mainLhnId))
	    .i oeoriId'=$p(^DHCLHN(mainLhnId),"^",4) s mainOeoriId=$p(^DHCLHN(mainLhnId),"^",4)
	    .q:mainOeoriId'="" //找到了主医嘱，是从医嘱
	    .s lhnOrderSubNo=1
	    .f  s lhnOrderSubNo=$o(^DHCLHN(0,"PAADM",EpisodeID,lhnOrderNo,lhnOrderSubNo)) q:lhnOrderSubNo=""  d
	        ..s lhnId=""
	        ..f  s lhnId=$o(^DHCLHN(0,"PAADM",EpisodeID,lhnOrderNo,lhnOrderSubNo,lhnId)) q:lhnId=""  d
	        	...q:'$d(^DHCLHN(lhnId)) 
	        	...i subOeoriId'="" s subOeoriId=subOeoriId_"!"
	        	...s subOeoriId=subOeoriId_$p(^DHCLHN(lhnId),"^",4)
	//w mainOeoriId_"/"_subOeoriId,!
	//for 第三方HIS end
	
	s arcimId=$p(^OEORD(oeordId,"I",oeoriSub,1),"^",2)
	s phcdfId=$p($g(^ARCIM(+arcimId,$p(arcimId,"||",2),1)),"^",12)
    s phcdId=+phcdfId,phcdfSub=+$p(phcdfId,"||",2)
    s defPhcinId=+$p($g(^PHCD(phcdId,"DF",phcdfSub,1)),"^",5)
    s defPhcinCode=$p($g(^PHCIN(defPhcinId)),"^",1),defPhcinDesc=$p($g(^PHCIN(defPhcinId)),"^",2)
    s phcfrId=$p($g(^OEORD(oeordId,"I",oeoriSub,2)),"^",4)
	s prcfrDesc=$p($g(^PHCFR(+phcfrId)),"^",3)
	s phcfrFactor=$p(^PHCFR(+phcfrId),"^",2)

    s doseQty=$p($g(^OEORD(oeordId,"I",+oeoriSub,2)),"^",1)
	s unitUomId=$p($g(^OEORD(oeordId,"I",+oeoriSub,2)),"^",3)
	s phOrdQty=$p($g(^OEORD(oeordId,"I",+oeoriSub,1)),"^",12)
	i doseQty="",phOrdQty="" s unitUomId=""
	i (doseQty'="")&($p(doseQty,".")="") s doseQty="0"_doseQty
	s oriQty=doseQty
	i oriQty="" s oriQty=phOrdQty
	s oriNote=$g(^OEORD(oeordId,"I",+oeoriSub,"DEP",1))
    
    q oecprType_"^"_oecprCode_"^"_phcinId_"^"_phcinCode_"^"_phcinDesc_"^"_mainOeoriId_"^"_subOeoriId_"^"_defPhcinId_"^"_defPhcinCode_"^"_defPhcinDesc_"^"_oriQty_"^"_unitUomId_"^"_oecprDesc_"^"_phcfrId_"^"_prcfrDesc_"^"_phcfrFactor_"^"_oriNote
}

ClassMethod GetOeoriGroupDesc(oeoriId) As %String
{
	s oeordId=+oeoriId,oeoriSub=$p(oeoriId,"||",2)
	q:oeoriSub="" ""
	//q:$p($g(^OEORD(oeordId,"I",oeoriSub,11)),"^",39)'="" ""
	s oeoriId=oeordId_"||"_oeoriSub
	s arcimId=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",2)
	s retStr=$p($g(^ARCIM(+arcimId,+$p(arcimId,"||",2),1)),"^",2)
	s oeoriStr=..GetOeorditemInfo(oeoriId)
	s arcicOrderType=##Class(web.DHCClinicCom).GetOrdSubCatType(oeoriId)
	i arcicOrderType="R" s retStr=retStr_" "_$p(oeoriStr,"^",11)_$P($g(^CT("UOM",+$p(oeoriStr,"^",12))),"^",2)
	e  s retStr=retStr_" "_$P($g(^CT("UOM",+$p(oeoriStr,"^",12))),"^",2)
	q:retStr="" ""
	q:(arcicOrderType'="R") retStr
	s curOriSub=""
	f  s curOriSub=$o(^OEORDi(0,"OEORI",oeordId,oeoriId,curOriSub)) q:(curOriSub="")  d
		.s curArcimId=$p(^OEORD(oeordId,"I",curOriSub,1),"^",2)
		.s arcimDesc=$p($g(^ARCIM(+curArcimId,+$p(curArcimId,"||",2),1)),"^",2)
		.q:arcimDesc=""
		.q:(arcicOrderType="R")&(##Class(web.DHCClinicCom).GetOrdSubCatType(oeordId_"||"_curOriSub)'=arcicOrderType) //与华西不同!!!!
		.s subOeoriStr=..GetOeorditemInfo(oeordId_"||"_curOriSub)
		.s retStr=retStr_$c(13)_$c(10)_arcimDesc
		.s retStr=retStr_" "_$p(subOeoriStr,"^",11)_$p($g(^CT("UOM",+$p(subOeoriStr,"^",12))),"^",2)
	i $p(oeoriStr,"^",5)'="" s retStr=retStr_"("_$p(oeoriStr,"^",5)_")"
	q retStr
}

ClassMethod GetServerDateTime() As %String
{
	s date=$zd(+$h,3)
	s time=$zt($p($h,",",2))
	q date_"^"_time
}

ClassMethod GetVolumeCtuomId() As %String
{
	q $o(^CT("UOM",0,"Code","ML",""))
}

ClassMethod GetVolume(oeoriId) As %String
{
	q:oeoriId="" 0
	
	s volumeCtuomId=..GetVolumeCtuomId()
	q:volumeCtuomId="" 0
	
	s oeordId=$p(oeoriId,"||",1),oeoriSub=$p(oeoriId,"||",2)
	q:oeoriSub="" 0
	s arcimId=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",2)
	q:arcimId="" 0
	
	s phOrdQty=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",12)
	s arcicOrderType=##Class(web.DHCClinicCom).GetOrdSubCatType(oeoriId)
	q:arcicOrderType'="R" 0
		
	s phcdfId=$p($g(^ARCIM(+arcimId,$p(arcimId,"||",2),1)),"^",12)
	q:phcdfId="" 0
	s phcdId=+phcdfId,phcdfSub=$p(phcdfId,"||",2)
	s baseUomId=$p($g(^PHCD(phcdId,"DF",phcdfSub,2)),"^",4)
		
	s doseQty=$p($g(^OEORD(oeordId,"I",oeoriSub,2)),"^",1)
	q:doseQty="" 0
	s unitUomId=$p($g(^OEORD(oeordId,"I",oeoriSub,2)),"^",3)
	q:unitUomId="" 0
	q:unitUomId=volumeCtuomId doseQty

	s eqId=0,volumeEqQty=0
	f  s eqId=$o(^PHCD(phcdId,"DF",phcdfSub,"EQ",eqId)) q:eqId=""  d
		.s eqUomId=+^PHCD(phcdId,"DF",phcdfSub,"EQ",eqId)
		.i eqUomId=volumeCtuomId s volumeEqQty=$p(^PHCD(phcdId,"DF",phcdfSub,"EQ",eqId),"^",2)
	q:volumeEqQty=0 0
	
	s baseVolume=doseQty*volumeEqQty
	q:unitUomId=baseUomId baseVolume
	
	s eqId=0,baseEqQty=0
	f  s eqId=$o(^PHCD(phcdId,"DF",phcdfSub,"EQ",eqId)) q:eqId=""  d
		.s eqUomId=+^PHCD(phcdId,"DF",phcdfSub,"EQ",eqId)
		.i eqUomId=unitUomId s baseEqQty=$p(^PHCD(phcdId,"DF",phcdfSub,"EQ",eqId),"^",2)
	q:baseEqQty=0 0
	q baseVolume/baseEqQty
}

ClassMethod GetCtcptType(userId As %String) As %String
{
	q:userId="" ""
	s ctctId=$p(^SSU("SSUSR",userId),"^",14)
	q:ctctId="" ""
	s ctcptId=$P(^CTPCP(ctctId,1),"^",4)
	q:ctcptId="" ""
	s ctcptType=$P(^CT("CPT",ctcptId),"^",4)
	q ctcptType
}

ClassMethod GetBloodType(regNo As %String) As %String
{
	;w ##class(web.DHCCLCom).GetBloodType("01539993")
    ;n (regNo)
  	q:regNo="" ""
  	s bldGpId=""
  	i $d(^TDEB(regNo)) d
  	.s bldGpId=$p($G(^TDEB(regNo)),"\",4)
  	.i '$l(bldGpId) d
  	..s bldGpId=$p($g(^TDEB(regNo)),"\",10)
  	s BG="",Rh=""
  	i $l(bldGpId) d
  	.s BG=$p(^TTAB("BB-BG",bldGpId),"\",2)_"型"
  	.;i $p(^TTAB("BB-BG",bldGpId),"\",3)="P" s Rh="阳性(+)"
  	.;i $p(^TTAB("BB-BG",bldGpId),"\",3)="N" s Rh="阴性(-)"
  	s BGRh=BG_Rh
  	q BGRh
}

/// 计算整包装数量，非药品返回0
ClassMethod CaculatePackQty(arcimId, orderUomId, orderUomQty) As %String
{
	q:arcimId="" 0
	q:+orderUomId=0 0
	s phcdfId=$p($g(^ARCIM(+arcimId,+$p(arcimId,"||",2),1)),"^",12)
	q:phcdfId="" 0
	s phcdId=+phcdfId,phcdfSub=$p(phcdfId,"||",2)
	s baseUomId=$p($g(^PHCD(phcdId,"DF",phcdfSub,2)),"^",4)

	s packUomId=$p($g(^ARCIM(+arcimId,$p(arcimId,"||",2),8)),"^",14)
	s packDoseQty=0
	s factor=1
	i packUomId'="" d
		.i baseUomId'=packUomId d
			..s ctcfId=$o(^CT("CTCF",0,"UOM",packUomId,baseUomId,""))
			..i ctcfId'="" s factor=$p(^CT("CTCF",ctcfId),"^",3)
		.q:+factor=0
		.//s packDoseQty=qtyPackUom*factor ;;dQty/factor  ;包装单位转换
		.//i $p(packDoseQty,".",2)>0 s packDoseQty=$p(packDoseQty,".",1)+1
	i factor=0 q 0

	s eqQty=1
	i baseUomId'=orderUomId d
		.s eqId=0,eqQty=0
		.f  s eqId=$o(^PHCD(phcdId,"DF",phcdfSub,"EQ",eqId)) q:eqId=""  d
			..s eqUomId=+^PHCD(phcdId,"DF",phcdfSub,"EQ",eqId)
			..i eqUomId=orderUomId s eqQty=$p(^PHCD(phcdId,"DF",phcdfSub,"EQ",eqId),"^",2)
	i eqQty=0 q 0
	s qty=orderUomQty/eqQty/factor
	i $p(qty,".",2)>0 s qty=$p(qty,".",1)+1
	q qty
}

ClassMethod GetAnaOperationDoc(AnaesthesiaID As %String)
{
	//w ##class(web.DHCANOPCom).GetAnaOperationDoc("3182598||1")
	Set retStr=""
	Set ret=..GetAnaOperationItem("",AnaesthesiaID)
	Quit:ret'[($c(3)) ""
	For i=1:1:$l(ret,"^") do
	.Set DocRowid=$p($p(ret,"^",i),$c(3),5)
	.Quit:'$d(^CTPCP(DocRowid))
	.Set DocDesc=$p($p(ret,"^",i),$c(3),6)
	.Set DocCode=$p(^CTPCP(DocRowid,1),"^",1)
	.if retStr="" do
	..Set retStr=DocCode_"^"_DocDesc
	.else  do
	..Set retStr=retStr_","_DocCode_"^"_DocDesc
	Quit retStr
}

ClassMethod GetUomDescById(UomId) As %String
{
	q $p(^CT("UOM",UomId),"^",2)
}

ClassMethod GetOpaIdCountStr(EpisodeID) As %String
{
 s ^TMPzt("OnstepAdm")=EpisodeID
 s opaId=""
 s opaIdStr=""
 f  s opaId=$O(^DHCANOPArrange(0,"Adm",EpisodeID,opaId)) q:opaId=""  d
 .q:$d(^DHCANOPArrange(opaId))<1
 .s Stat=$P(^DHCANOPArrange(opaId),"^",27)
 .q:(Stat'="L")&&(Stat'="F")
 
 .s opStopStatus=$P($g(^DHCANOPArrange(opaId)),"^",23)
 .q:opStopStatus'=""										;手术未进行
 
 .i opaIdStr="" s opaIdStr=opaId
 .e  s opaIdStr=opaIdStr_"^"_opaId
 q opaIdStr
}

ClassMethod GetOpaIdStr(EpisodeID) As %String
{
 s ^TMPzt("OnstepAdm")=EpisodeID
 s opaId=""
 s opaIdStr=""
 f  s opaId=$O(^DHCANOPArrange(0,"Adm",EpisodeID,opaId)) q:opaId=""  d
 .q:$d(^DHCANOPArrange(opaId))<1
 .s Stat=$P(^DHCANOPArrange(opaId),"^",27)
 .;q:"LF"'[Stat
 .q:(Stat'="L")&&(Stat'="F")
 .s opStopStatus=$P($g(^DHCANOPArrange(opaId)),"^",23)
 .q:opStopStatus'=""
 .;s AnIn=##Class(web.DHCANAdaptor).GetIfAnInRoom(opaId)
 .;q:AnIn'="1" 
 .i opaIdStr="" s opaIdStr=opaId
 .e  s opaIdStr=opaIdStr_"^"_opaId
 q opaIdStr
}

/// Desc:	就诊号下有手术清点单的手术id
/// Debug:	w ##Class(web.DHCANOPCom).OpaIdStrByOPCount("16871487")
ClassMethod OpaIdStrByOPCount(AEpisodeID) As %String
{
	s OpaIdStr = ##Class(web.DHCANOPCom).GetOpaIdCountStr(AEpisodeID)
	q:(OpaIdStr = "")
	s count = $L(OpaIdStr, "^")
	s ret=""
	for i=1:1:count
	{
		s ret1=""
		s OpaId = $P(OpaIdStr, "^", i)
		continue:(OpaId = "")
		s OPCount=$g(^DHCANOPArrange(OpaId,"OPCount",0))
		continue:(OPCount < 1)
	  	s ret1=OpaId
		i ret="" d
		.s ret=ret1
		e  d
		.i ret1'="" d
		..s ret=ret_"^"_ret1
	}
	q ret
}

Storage Default
{
<Data name="DHCANOPComDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCANOPComD</DataLocation>
<DefaultData>DHCANOPComDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^web.DHCANOPComD</IdLocation>
<IndexLocation>^web.DHCANOPComI</IndexLocation>
<StreamLocation>^web.DHCANOPComS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

/// w ##class(web.DHCANOPCom).GetOpSetInfo()
ClassMethod GetOpSetInfo() As %String
{
	//是否发送消息
	s SendMessage=$g(^DHCCLSet("AnOp","SendMessage"))
	//是否自动带入检验结果
	s InsertLabInfo=$g(^DHCCLSet("AnOp","InsertLabInfo"))
	q SendMessage_"^"_InsertLabInfo
}

}
