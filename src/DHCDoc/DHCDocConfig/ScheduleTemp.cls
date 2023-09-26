Class DHCDoc.DHCDocConfig.ScheduleTemp Extends DHCDoc.Util.RegisteredObject
{

Query FindScheduleTemp(LocRowid, UserRowid, DocRowid, ZoneID As %String = "", ScheduleLinesRowId As %String = "", ILocDesc As %String = "", IDocDesc As %String = "", HospId As %String = "") As %Query(ROWSPEC = "LocDesc:%String:科室,ResDesc:%String:医生,TimeRange:%String:时段,Week1:%String:星期一,Week2:%String:星期二,Week3:%String:星期三,Week4:%String:星期四,Week5:%String:星期五,Week6:%String:星期六,Week7:%String:星期天,Room:%String:诊室,RowId:%String:HIDDEN,LocRowid:%String:HIDDEN,DocRowid:%String:HIDDEN,TimeRangeDr:%String:HIDDEN,Invalid:%String:HIDDEN") [ SqlProc ]
{
}

/// d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.ScheduleTemp","FindScheduleTemp","",1,"","")
ClassMethod FindScheduleTempExecute(ByRef qHandle As %Binary, LocRowid = "", UserRowid = "", DocRowid = "", ZoneID As %String = "", ScheduleLinesRowId As %String = "", ILocDesc As %String = "", IDocDesc As %String = "", HospId As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s ^Tempqujian("FindScheduleTemp")=LocRowid_","_UserRowid_","_DocRowid_","_ZoneID_","_ScheduleLinesRowId_","_ILocDesc_","_IDocDesc_","_HospId
	s HospId=##class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(HospId)
	s ILocDesc=$ZCVT(ILocDesc,"U")
	s:UserRowid="" UserRowid=%session.Data("LOGON.USERID")
	s User=" "_UserRowid
	s Type=" "_"REG" ;护士加号权限与排班权限使用同一存储结构，以类型字段区分
	i LocRowid="" d
	.s LocID=""
	.f  s LocID=$O(^User.DHCUserGroupI("UserLocDoc",Type,User,LocID)) q:LocID=""  d OneLoc
	e  d
	.s LocID=" "_LocRowid
	.d OneLoc
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OneLoc
	s mLocID=$TR(LocID," ")
	s LocHospId=$P(^CTLOC(mLocID),"^",22)
	;Q:(HospId'="")&&(HospId'=LocHospId)
	Q:"N"=##class(DHCDoc.Common.Hospital).GetHospShowDataFlag("CT_Loc",mLocID,HospId)
	s Find=0
	if (ZoneID'="") {
		s ID=0
		for {
			s ID=$o(^User.DHCExaBorDepI("BordBorDrIndex",ZoneID,ID)) Q:(ID="")||(Find=1)
			s BordDepDr=$lg(^User.DHCExaBorDepD(ID),7)
			if (BordDepDr=mLocID) s Find=1
		}
	}
	Q:(Find=0)&&(ZoneID'="")
	//Q:(ZoneID'="")&&('$d(^User.DHCExaBorDepI("BordBorDrIndex",ZoneID,mLocID)))
	s LocDesc=$P(^CTLOC(mLocID),"^",2)
	s:LocDesc["-" LocDesc=$P(LocDesc,"-",2)
	q:(ILocDesc'="")&&('##class(web.DHCOPAdmReg).CheckLocDesc(mLocID,ILocDesc))
	i DocRowid="" d
	.s DocID=""
	.f  s DocID=$O(^User.DHCUserGroupI("UserLocDoc",Type,User,LocID,DocID)) q:DocID=""  d
	..s mDocID=$TR(DocID," ")
	..q:mDocID=""
	..d OneDoc
	e  d
	.s mDocID=DocRowid
	.d OneDoc
	Q
OneDoc
	Q:"N"=##class(DHCDoc.Common.Hospital).GetHospShowDataFlag("CT_CarePrv",mDocID,HospId)
	s doctorstr=$P($g(^CTPCP(mDocID,"1")),"^",2)
	q:doctorstr=""
	q:((IDocDesc'="")&&(doctorstr'[IDocDesc))
	s ResRowid=$o(^RB("RES",0,"CTPCP",mDocID,mLocID,0))
	q:ResRowid=""
	s StopFlag="N"
	s ScheSt=$p(^RB("RES",ResRowid),"^",6)
	i ScheSt'="Y" s StopFlag="Y"
	s DateFrom=$p(^RB("RES",ResRowid),"^",22)
	s DateTo=$p(^RB("RES",ResRowid),"^",23)
	i (DateFrom'="")&&(DateFrom>+$h) s StopFlag="Y"
	i (DateTo'="")&&(DateTo<=+$h) s StopFlag="Y"
	
	s RESDateActiveFrom=$p($g(^RB("RES",ResRowid)),"^",22)
	s RESDateActiveTo=$p($g(^RB("RES",ResRowid)),"^",23)
	s RESScheduleRequired=$p($g(^RB("RES",ResRowid)),"^",6)
	if $g(RESScheduleRequired)="N" s StopFlag="Y"
	if (RESDateActiveFrom'="")&&(RESDateActiveFrom>+$h) s StopFlag="Y"
	if (RESDateActiveTo'="")&&(RESDateActiveTo<=+$h) s StopFlag="Y"
	
	s CTPCPActiveFlag=$P($G(^CTPCP(mDocID,1)),"^",9)
	s CTPCPActiveDateF=$P($G(^CTPCP(mDocID,2)),"^",14)
	s CTPCPActiveDateT=$P($G(^CTPCP(mDocID,2)),"^",15)
	if (CTPCPActiveFlag="N") s StopFlag="Y"
	if (CTPCPActiveDateF'="")&&(CTPCPActiveDateF>+$h) s StopFlag="Y"
	if (CTPCPActiveDateT'="")&&(CTPCPActiveDateT<=+$h) s StopFlag="Y"
	s Userdr=$O(^SSU("SSUSR",0,"CTPCP",mDocID,"0"))
	if Userdr'="" {
		s UserActive=$P(^SSU("SSUSR",Userdr),"^",19)
		if UserActive'="Y" s StopFlag="Y"
		s UserActiveDateF=$P(^SSU("SSUSR",Userdr),"^",96)
		s UserActiveDateT=$P(^SSU("SSUSR",Userdr),"^",97)
		if (UserActiveDateF'="")&&(UserActiveDateF>+$h) s StopFlag="Y"
		if (UserActiveDateT'="")&&(UserActiveDateT<=+$h) s StopFlag="Y"
	}
	
	s ResDesc=$P(^RB("RES",ResRowid),"^",17)
	if (ScheduleLinesRowId'=""){
		q:'$d(^RB("RES",ResRowid,"DATE",0,"RSL",ScheduleLinesRowId))
		s DateSub=$O(^RB("RES",ResRowid,"DATE",0,"RSL",ScheduleLinesRowId,""),-1)
	}else{
		s DateSub=$O(^RB("RES",ResRowid,"DATE",""),-1)
	}
	q:DateSub=""
	s DateRowid=ResRowid_"||"_DateSub
	d OneDateSess
	Q
OneDateSess
	k DOWList,RoomList
	s SessSub=0
	f  s SessSub=$O(^RB("RES",ResRowid,"DATE",DateSub,"SESS",SessSub)) q:SessSub=""  d
	.s SessNo=$P(^RB("RES",ResRowid,"DATE",DateSub,"SESS",SessSub),"^",3)
	.q:SessNo=""
	.s DOWDR=$P(^RB("RES",ResRowid,"DATE",DateSub,"SESS",SessSub),"^",2)
	.q:DOWDR=""
	.s DOW=$P(^CT("DOW",1,DOWDR),"^",2)
	.s Load=+$P(^RB("RES",ResRowid,"DATE",DateSub,"SESS",SessSub),"^",8)
	.s NoLimitLoadFlag=$P($g(^RB("RES",ResRowid,"DATE",DateSub,"SESS",SessSub)),"^",43)
	.;q:Load=0
	.s GenerFlag=$P(^RB("RES",ResRowid,"DATE",DateSub,"SESS",SessSub),"^",16)
	.;q:GenerFlag'="Y"
	.;s:GenerFlag'="Y" Load=""	;"<font color='red'>"_Load_"</font>"
	.s Load=Load_"^"_GenerFlag
	.s RoomLocId=$P(^RB("RES",ResRowid,"DATE",DateSub,"SESS",SessSub),"^",19)
	.i $G(RoomList(SessNo))="" s RoomList(SessNo)=RoomLocId
	.s DOWList(SessNo,DOW)=Load
	Q:'$D(DOWList)
	
	s SessNo=0
	f  s SessNo=$O(DOWList(SessNo)) q:SessNo=""  d
	.s TimeRange=$P(^DHCTimeRange(SessNo),"^",2)
	.s TimeRangeDr=SessNo
	.;if (StopFlag=1) s ResDesc=ResDesc_"(已停用)"
	.s Data=$lb(LocDesc,ResDesc,TimeRange)
	.f DOW=1:1:7 d
	..s val=$G(DOWList(SessNo,DOW))
	..s Data=Data_$LB(val)
	.s Room=$G(RoomList(SessNo))
	.s:Room'="" Room=$P(^CTLOC(Room),"^",2)
	.s:Room["-" Room=$P(Room,"-",2)
	.s RowId=DateRowid_"^"_SessNo
	.s Data=Data_$LB(Room,RowId,mLocID,mDocID,TimeRangeDr,StopFlag)
	.d OutputRow
	Q
OutputRow
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
    quit
}

ClassMethod FindScheduleTempFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindScheduleTempExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {            
	 Set AtEnd=1
	 Set Row=""
	}
	Else      {        
	 Set Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
    Quit $$$OK
}

ClassMethod FindScheduleTempClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindScheduleTempFetch ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod GetResDateKeyNew(ResDateRowid)
{
	k UsingTempList
	s ResRowid=+ResDateRowid,DateSub=$P(ResDateRowid,"||",2)
	s SessSub=0
	f  s SessSub=$O(^RB("RES",ResRowid,"DATE",DateSub,"SESS",SessSub)) q:SessSub=""  d
	.s DOWDr=$P(^RB("RES",ResRowid,"DATE",DateSub,"SESS",SessSub),"^",2)
	.s DOWSeq=$P($G(^CT("DOW",1,+DOWDr)),"^",2)
	.q:DOWSeq=""
	.s TimeRange=+$P(^RB("RES",ResRowid,"DATE",DateSub,"SESS",SessSub),"^",3)
	.q:TimeRange=0
	.s UsingTempList(DOWSeq,TimeRange)=^RB("RES",ResRowid,"DATE",DateSub,"SESS",SessSub)
	
	s nowkey=""
	f DOWSeq=1:1:7 d
	.s TimeRange="",oneKey=""
	.f  s TimeRange=$O(UsingTempList(DOWSeq,TimeRange)) q:TimeRange=""  d
	..s val=UsingTempList(DOWSeq,TimeRange)
	..s $P(oneKey,"#",TimeRange)=val
	.s $P(nowkey,"!",DOWSeq)=oneKey
	Q nowkey
}

ClassMethod SaveGeneSchedSess(TempName, UserID As %String = "")
{
	s:UserID="" UserID=%session.Data("LOGON.USERID")
	s newNod=$O(^DHCSessTempList(""),-1)+1
	s ^DHCSessTempList(newNod,"SESS")=TempName_"^"_UserID_"^"_$H
	s ResRowid=0	;^TMPCreatedSess(UserID,ResRowId,DateRowId,SessRowId)
	f  s ResRowid=$O(^TMPCreatedSess(UserID,ResRowid)) q:ResRowid=""  d
	.s DateRowId=$O(^TMPCreatedSess(UserID,ResRowid,""),-1) 
	.q:DateRowId=""
	.s ^DHCSessTempList(newNod,"SESS",ResRowid)=..GetResDateKeyNew(ResRowid_"||"_DateRowId)
	Q 0
}

ClassMethod GetNowTempKeyNew(ResRowid)
{
	s DateSub=$O(^RB("RES",ResRowid,"DATE",""),-1)
	Q:DateSub="" ""
	Q ..GetResDateKeyNew(ResRowid_"||"_DateSub)
}

ClassMethod CopySchedSessTemp(TempID)
{
	Q:(TempID="")!('$D(^DHCSessTempList(TempID))) -1
	s ResRowid=0
	for{
		s ResRowid=$O(^DHCSessTempList(TempID,"SESS",ResRowid)) 
		Quit:ResRowid=""
		s NowKey=..GetNowTempKeyNew(ResRowid)
		s TempKey=$G(^DHCSessTempList(TempID,"SESS",ResRowid))
		;模板与当前正在使用排班模板相同 不用复制
		continue:NowKey=TempKey 		
		s ResDateRowid=..NewResDateRowid(ResRowid)
		continue:ResDateRowid=""
		s SessStr=^DHCSessTempList(TempID,"SESS",ResRowid)
		d ..InsertTempSess(ResDateRowid, SessStr)
	}
	Q 0
}

ClassMethod InsertTempSess(ResDateRowid, SessStr)
{
	f i=1:1:$L(SessStr,"!"){
		s oneDay=$P(SessStr,"!",i)
		continue:oneDay=""
		f j=1:1:$L(oneDay,"#"){
			s oneSessStr=$P(oneDay,"#",j)
			continue:oneSessStr=""
			k PList
			s PList(0)=ResDateRowid
			s PList(3)=$P(oneSessStr,"^",3)
			s PList(4)=$P(oneSessStr,"^",4)
			s PList(5)=$P(oneSessStr,"^",5)
			s PList(6)=$P(oneSessStr,"^",6)
			s PList(7)=$P(oneSessStr,"^",7)
			s PList(8)=$P(oneSessStr,"^",8)
			s PList(9)=$P(oneSessStr,"^",1)
			s PList(10)=$P(oneSessStr,"^",2)
			s PList(11)=$P(oneSessStr,"^",9)
			s PList(12)=$P(oneSessStr,"^",10)
			s PList(13)=$P(oneSessStr,"^",11)
			s PList(14)=$P(oneSessStr,"^",12)
			s PList(15)=$P(oneSessStr,"^",13)
			s PList(16)=$P(oneSessStr,"^",14)
			s PList(17)=$P(oneSessStr,"^",15)
			s PList(18)=$P(oneSessStr,"^",16)
			s PList(19)=$P(oneSessStr,"^",17)
			s PList(20)=$P(oneSessStr,"^",18)
			s PList(21)=$P(oneSessStr,"^",19)
			s PList(22)=$P(oneSessStr,"^",20)
			s PList(23)=$P(oneSessStr,"^",21)
			s PList(24)=$P(oneSessStr,"^",22)
			s PList(25)=$P(oneSessStr,"^",23)
			s PList(26)=$P(oneSessStr,"^",24)
			s PList(27)=$P(oneSessStr,"^",25)
			s PList(28)=$P(oneSessStr,"^",26)
			s PList(29)=$P(oneSessStr,"^",27)
			s PList(30)=$P(oneSessStr,"^",28)
			s PList(31)=$P(oneSessStr,"^",29)
			s PList(32)=$P(oneSessStr,"^",30)
			s PList(33)=$P(oneSessStr,"^",31)
			s PList(34)=$P(oneSessStr,"^",32)
			s PList(35)=$P(oneSessStr,"^",33)
			s PList(36)=$P(oneSessStr,"^",34)
			s PList(37)=$P(oneSessStr,"^",35)
			s PList(38)=$P(oneSessStr,"^",36)
			s PList(39)=$P(oneSessStr,"^",37)
			s PList(40)=$P(oneSessStr,"^",38)
			s PList(41)=$P(oneSessStr,"^",39)
			s PList(42)=$P(oneSessStr,"^",40)
			s PList(43)=$P(oneSessStr,"^",41)
			&SQL(Insert into SQLUser.RB_ResEffDateSession Values :PList())
			s:SQLCODE ^Wqy("Insert",ResDateRowid)=SQLCODE
		}
	}
	Q
}

ClassMethod NewResDateRowid(ResRowid)
{
	s ResDateRowid=""
	s DateSub=$O(^RB("RES",ResRowid,"DATE",""),-1)
	if (DateSub'="")&($O(^RB("RES",ResRowid,"DATE",DateSub,"SESS",0))=""){
		s ResDateRowid=ResRowid_"||"_DateSub
	}else{
		s ret=##class(web.DHCRBResSession).InsertEffDate(ResRowid,$ZD(+$H,4))
		if $P(ret,"^")=0{
			s ResDateRowid=$P(ret,"^",2)
			s DateSub=$P(ResDateRowid,"||",2)
		}
	}
	Q ResDateRowid
}

Query QuerySchedSessTemp(UserID) As %Query(ROWSPEC = "TempID:%String,TempName:%String") [ SqlProc ]
{
}

/// d ##class(%ResultSet).RunQuery("DHCDoc.Common.Schedule.ScheduleTemplate","QuerySchedSessTemp")
ClassMethod QuerySchedSessTempExecute(ByRef qHandle As %Binary, UserID = "") As %Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s TempID=0
	f  s TempID=$O(^DHCSessTempList(TempID)) q:TempID=""  d
	.s user=$P(^DHCSessTempList(TempID,"SESS"),"^",2)
	.q:(UserID'="")&(UserID'=user)
	.s TempName=$P(^DHCSessTempList(TempID,"SESS"),"^",1)
    .d OutputRow    
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK

OutputRow
    set Data=$lb(TempID,TempName)
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod QuerySchedSessTempFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QuerySchedSessTempExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {            
	 Set AtEnd=1
	 Set Row=""
	}
	Else      {        
	 Set Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
    Quit $$$OK
}

ClassMethod QuerySchedSessTempClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QuerySchedSessTempFetch ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetDefGenDate(UserRowid)
{
	s DefSttDat=##class(web.DHCOPRegTime).GetdefineStartDate(UserRowid)
	i DefSttDat="" s DefSttDat=..%SysDate()
	e  d
	.i DefSttDat["-" s DefSttDat=$ZDH(DefSttDat,3)
	.i DefSttDat["/" s DefSttDat=$ZDH(DefSttDat,4)
	s DefEndDat=DefSttDat+13	;默认生成两周
	s DefSttDat=$ZD(DefSttDat,3)
	s DefEndDat=$ZD(DefEndDat,3)
	Q DefSttDat_"^"_DefEndDat
}

Query QueryLocList(UserID, ZoneID As %String = "", HospId As %String = "") As %Query(ROWSPEC = "rowid:%String,desc:%String,code:%String") [ SqlProc ]
{
}

/// d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.ScheduleTemp","QueryLocList",1,17)
ClassMethod QueryLocListExecute(ByRef qHandle As %Binary, UserID = "", ZoneID As %String = "", HospId As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s:UserID="" UserID=%session.Data("LOGON.USERID")
	s DHCExaBorDepStr=""
	if (ZoneID'="") {
		s rowid=0
		for {
			s rowid=$o(^User.DHCExaBorDepI("BordBorDrIndex",ZoneID,rowid))
			Q:rowid=""
			s depDr=$lg(^User.DHCExaBorDepD(rowid),7)
			i DHCExaBorDepStr="" s DHCExaBorDepStr=depDr
			e  s DHCExaBorDepStr=DHCExaBorDepStr_"^"_depDr
		}
		i DHCExaBorDepStr'="" s DHCExaBorDepStr="^"_DHCExaBorDepStr_"^"
	}
	s Type=" "_"REG" ;护士加号权限与排班权限使用同一存储结构，以类型字段区分
	s LocID=""
	f  s LocID=$O(^User.DHCUserGroupI("UserLocDoc",Type," "_UserID,LocID)) q:LocID=""  d
	.s rowid=$TR(LocID," ")
	.s desc=$P(^CTLOC(rowid),"^",2)
	.s code=$P(^CTLOC(rowid),"^",43)
	.s hosp=$P(^CTLOC(rowid),"^",22)
	.Q:(HospId'="")&&(HospId'=hosp)
	.Q:(ZoneID'="")&&(DHCExaBorDepStr'[("^"_rowid_"^"))
	.q:($P(^CTLOC(rowid),"^",14)'="Y")
	.s StartDate=$P(^CTLOC(rowid),"^",24)
	.s EndDate=$P(^CTLOC(rowid),"^",25)
	.q:(StartDate'="")&&(StartDate>+$h)
	.q:(EndDate'="")&&(EndDate<+$h)
    .d OutputRow    
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK

OutputRow
    set Data=$lb(rowid,desc,code)
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod QueryLocListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryLocListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {            
	 Set AtEnd=1
	 Set Row=""
	}
	Else      {        
	 Set Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
    Quit $$$OK
}

ClassMethod QueryLocListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryLocListFetch ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

Query QueryDocList(LocID, UserID) As %Query(ROWSPEC = "rowid:%String,desc:%String,code:%String") [ SqlProc ]
{
}

/// d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.ScheduleTemp","QueryDocList",115,1)
ClassMethod QueryDocListExecute(ByRef qHandle As %Binary, LocID = "", UserID = "") As %Status
{
	s ^Wqy("QueryDocList")=LocID_","_UserID
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	if LocID=""{
		Set qHandle=$lb(0,repid,0)
    	Quit $$$OK
	}
	s:UserID="" UserID=%session.Data("LOGON.USERID")
	s Type=" "_"REG" ;护士加号权限与排班权限使用同一存储结构，以类型字段区分
	//s rowid="",desc="全部医生"
	//d OutputRow
	s DocID=""
	f  s DocID=$O(^User.DHCUserGroupI("UserLocDoc",Type," "_UserID," "_LocID,DocID)) q:DocID=""  d
	.s rowid=$TR(DocID," ")
	.s desc=$P($G(^CTPCP(rowid,1)),"^",2)
	.q:desc=""
	.s CTPCPActiveFlag=$P($G(^CTPCP(rowid,1)),"^",9)
	.Q:CTPCPActiveFlag="N"
	.s DateActiveFrom=$P($G(^CTPCP(rowid,2)),"^",14)
	.Q:(DateActiveFrom'="")&&(DateActiveFrom>+$h)
	.s DateActiveTo=$P($G(^CTPCP(rowid,2)),"^",15)
	.Q:(DateActiveTo'="")&&(DateActiveTo<+$h)
	.s UserActive="Y"
	.set Userdr=$O(^SSU("SSUSR",0,"CTPCP",rowid,"0"))
	.if Userdr'="" d
	..s UserActive=$P(^SSU("SSUSR",Userdr),"^",19)
	..s UserActiveDateF=$P(^SSU("SSUSR",Userdr),"^",96)
	..s UserActiveDateT=$P(^SSU("SSUSR",Userdr),"^",97)
	..if (UserActiveDateF'="")&&(UserActiveDateF>+$h) s UserActive="N"
	..if (UserActiveDateT'="")&&(UserActiveDateT<=+$h) s UserActive="N"
	.q:UserActive'="Y"
	.s RESDateActiveFrom="",RESDateActiveTo=""
	.//s RESRowId=$o(^RB("RES",0,"CTPCP",rowid,LocID,""))
	.s RESRowId=..GetResRowID(rowid,LocID)
	.if RESRowId'="" d
	..s RESDateActiveFrom=$p($g(^RB("RES",RESRowId)),"^",22)
	..s RESDateActiveTo=$p($g(^RB("RES",RESRowId)),"^",23)
	..s RESScheduleRequired=$p($g(^RB("RES",RESRowId)),"^",6)
	.Q:$g(RESScheduleRequired)="N"
	.Q:(RESDateActiveFrom'="")&&(RESDateActiveFrom>+$h)
	.Q:(RESDateActiveTo'="")&&(RESDateActiveTo<+$h)
	.s DocType=..GetDocType(rowid)
	.s:DocType'="" desc=desc_"-"_DocType
	.s code=$P($G(^CTPCP(rowid,3)),"^",28)
    .d OutputRow    
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK

OutputRow
    set Data=$lb(rowid,desc,code)
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod QueryDocListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryDocListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {            
	 Set AtEnd=1
	 Set Row=""
	}
	Else      {        
	 Set Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
    Quit $$$OK
}

ClassMethod QueryDocListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryDocListFetch ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetDocType(DocID)
{
	Q:DocID="" ""
	s DocTypeDr=$P($G(^CTPCP(DocID,1)),"^",4)
	Q:DocTypeDr="" ""
	Q $P(^CT("CPT",DocTypeDr),"^",2)
}

ClassMethod GetResDataWeeks(DateRowid, DOWNo = "", TimeRange = "")
{
	s ResRowid=+DateRowid
	s DateSub=$P(DateRowid,"||",2)
	Q:DateSub="" ""
	k DOWList
	s ret=""
	s SessSub=0
	f  s SessSub=$O(^RB("RES",ResRowid,"DATE",DateSub,"SESS",SessSub)) q:SessSub=""  d
	.s DOWDR=$P(^RB("RES",ResRowid,"DATE",DateSub,"SESS",SessSub),"^",2)
	.q:DOWDR=""
	.s DOWSeq=$P(^CT("DOW",1,DOWDR),"^",2)
	.s SessNo=$P(^RB("RES",ResRowid,"DATE",DateSub,"SESS",SessSub),"^",3)
	.s SessRowid=ResRowid_"||"_DateSub_"||"_SessSub
	.s DOWList(DOWSeq)=$P($G(^CT("DOW",1,+DOWDR)),"^",1)
	.s DOWList(DOWSeq,SessNo)=SessRowid
	Q:(DOWNo'="")&(TimeRange'="") $G(DOWList(DOWNo,TimeRange))
	s DOWSeq=""
	f  s DOWSeq=$O(DOWList(DOWSeq)) q:DOWSeq=""  d
	.s SessNo="",oneday=""
	.f  s SessNo=$O(DOWList(DOWSeq,SessNo)) q:SessNo=""  d
	..s TimeRange=$P($G(^DHCTimeRange(+SessNo)),"^",2)
	..s SessRowid=DOWList(DOWSeq,SessNo)
	..i oneday="" s oneday=TimeRange_"@"_SessRowid
	..e  s oneday=oneday_"#"_TimeRange_"@"_SessRowid
	.q:oneday=""
	.s DOW=DOWList(DOWSeq)
	.i ret="" s ret=DOW_":"_oneday
	.e  s ret=ret_"^"_DOW_":"_oneday
	Q ret
}

ClassMethod GetSessData(SessRowid)
{
	if SessRowid=""{
		s $P(ret,"^",50)=""
		Q ret_"!"
	}
	s Str=$G(^RB("RES",+SessRowid,"DATE",$P(SessRowid,"||",2),"SESS",$P(SessRowid,"||",3)))
	s SttTime=$P(Str,"^",4)
	s:SttTime'="" SttTime=..%ZT(SttTime,1)
	s EndTime=$P(Str,"^",5)
	s:EndTime'="" EndTime=..%ZT(EndTime,1)
	s $P(Str,"^",4)=SttTime
	s $P(Str,"^",5)=EndTime
	s TRStr=$G(^RB("RES",+SessRowid,"DATE",$P(SessRowid,"||",2),"SESS",$P(SessRowid,"||",3),"DHC"))
	s ResLocid=$p($g(^RB("RES",+SessRowid)),"^",1)
	Q Str_"!"_TRStr_"!"_ResLocid
}

// w ##class(DHCDoc.DHCDocConfig.ScheduleTemp).CheckBeforeSaveSess("",1,104,1,1,2)

ClassMethod CheckBeforeSaveSess(SessRowid, LocId, DocId, DOW, TimeRange, ScheduleLinesRowId As %String = "")
{
	Q:(DOW="")!(TimeRange="") "-1^星期和时段不能为空"
	s ResRowid="",DateSub="",oldSessSub=""
	if (SessRowid'=""){
		s ResRowid=+SessRowid
		s DateSub=$P(SessRowid,"||",2)
		Q:DateSub="" "-1^模版ID错误"
		s oldSessSub=$P(SessRowid,"||",3)
		Q:oldSessSub="" "-1^模版ID错误"
	}else{
		Q:(LocId="")!(DocId="") "-1^科室医生不能为空"
		//s ResRowid=$O(^RB("RES",0,"CTPCP",DocId,LocId,0))
		s ResRowid=..GetResRowID(DocId,LocId)
		Q:ResRowid="" "-1^未分配医生到科室"
		if (ScheduleLinesRowId'=""){
			q:'$d(^RB("RES",ResRowid,"DATE",0,"RSL",ScheduleLinesRowId)) 0
			s DateSub=$O(^RB("RES",ResRowid,"DATE",0,"RSL",ScheduleLinesRowId,""),-1)
		}else{
			s DateSub=$O(^RB("RES",ResRowid,"DATE",""),-1)
		}
		Q:DateSub="" 0
	}
	s TRSttTime=$P(^DHCTimeRange(TimeRange),"^",3)
	s TREndTime=$P(^DHCTimeRange(TimeRange),"^",4)
	s SessSub=0,ret=0
	f{
		s SessSub=$O(^RB("RES",ResRowid,"DATE",DateSub,"SESS",SessSub)) 
		q:SessSub=""
		continue:oldSessSub=SessSub
		s DOWDR=$P(^RB("RES",ResRowid,"DATE",DateSub,"SESS",SessSub),"^",2)
		continue:DOWDR'=DOW
		s SessNo=$P(^RB("RES",ResRowid,"DATE",DateSub,"SESS",SessSub),"^",3)
		continue:SessNo=""
		s mSttTime=$P(^DHCTimeRange(SessNo),"^",3)
		s mEndTime=$P(^DHCTimeRange(SessNo),"^",4)
		if (TimeRange=SessNo){
			s DOWDesc=$P(^CT("DOW",1,DOWDR),"^",1)
			s TRDesc=$P(^DHCTimeRange(SessNo),"^",2)
			s ret="1^与现有模板:"_DOWDesc_TRDesc_"冲突"
			Q
			}
		/*if (mSttTime'>TRSttTime)&(mEndTime'<TREndTime) {
			s DOWDesc=$P(^CT("DOW",1,DOWDR),"^",1)
			s TRDesc=$P(^DHCTimeRange(SessNo),"^",2)
			s ret="1^与现有模板:"_DOWDesc_TRDesc_"冲突"
			Q
		}*/
	}
	Q ret
}

// w ##class(DHCDoc.DHCDocConfig.ScheduleTemp).GetDocDateRowid(7,1,2)

ClassMethod GetDocDateRowid(LocId, DocId, ScheduleLinesRowId As %String = "")
{
	Q:(LocId="")!(DocId="") "-1^科室医生不能为空"
	s ResRowid=..GetResRowID(DocId,LocId)
	Q:ResRowid="" "-1^未分配医生到科室"
	
	if (ScheduleLinesRowId'=""){
		s DateSub=$O(^RB("RES",ResRowid,"DATE",0,"RSL",ScheduleLinesRowId,""),-1)
	}else{
		s DateSub=$O(^RB("RES",ResRowid,"DATE",""),-1)
	}
	if DateSub="" s ResEffDate=##class(web.DHCRBResSession).InsertEffDate(ResRowid,$zd(+$h,4),ScheduleLinesRowId)
	e  s ResEffDate="0^"_ResRowid_"||"_DateSub
	Q ResEffDate
}

ClassMethod ActiveSess(DateRowid, DOW, TimeRange)
{
	s SessRowid=..GetResDataWeeks(DateRowid,DOW,TimeRange)
	Q:SessRowid="" -1
	s ResRowid=+SessRowid,DateSub=$P(SessRowid,"||",2),SessSub=$P(SessRowid,"||",3)
	s GenerFlag=$P(^RB("RES",ResRowid,"DATE",DateSub,"SESS",SessSub),"^",16)
	i GenerFlag="Y" s GenerFlag="N"
	e  s GenerFlag="Y"
	&SQL(UPDATE SQLUser.RB_ResEffDateSession SET SESS_ScheduleGenerFlag=:GenerFlag WHERE SESS_RowId=:SessRowid)
	Q SQLCODE
}

// SELECT TR_RowId As TRRowid,TR_Desc As TRDesc FROM SQLUser.DHC_TimeRange

/*
Query QueryTimeRange() As %SQLQuery
{
	SELECT TR_Desc As TRDesc,TR_Code As code,TR_RowId As TRRowid FROM SQLUser.DHC_TimeRange 
		WHERE ((TR_ValidStartDate <= +$h) OR (TR_ValidStartDate IS NULL))
		AND  ((TR_ValidEndDate>= +$h) OR (TR_ValidEndDate IS NULL) )
}
*/
Query QueryTimeRange(date As %String = "", HospId As %String = "") As %Query(ROWSPEC = "TRDesc:%String,code:%String,TRRowid:%String")
{
}

// D ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.ScheduleTemp","QueryTimeRange","","")

ClassMethod QueryTimeRangeExecute(ByRef qHandle As %Binary, date As %String = "", HospId As %String = "") As %Status
{
	s ^tempnk("LookUpSessionType")=date_"^"_HospId
	s repid=$I(^CacheTemp)
	s ind=1
	i date="" s date=..%SysDate()
	i ($g(HospId)="")&&($d(%session)) s HospId=%session.Get("LOGON.HOSPID")
	s RowId=""
	f  s RowId=$O(^DHCTimeRange(RowId)) q:RowId=""  d
	.s Code=$P(^DHCTimeRange(RowId),"^",1)
	.s Desc=$P(^DHCTimeRange(RowId),"^",2)
	.s ValidStartDate=$P(^DHCTimeRange(RowId),"^",7)
	.s ValidEndDate=$P(^DHCTimeRange(RowId),"^",8)
	.q:((ValidStartDate >date)&&(ValidStartDate'=""))
	.q:((ValidEndDate <date)&&(ValidEndDate'=""))
	.Q:##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag("DHC_TimeRange",RowId,HospId)="N"
	.d OutputTimeRange
	
	s qHandle=$lb(0,repid,0) 
	Quit $$$OK
	
OutputTimeRange
	set Data=$lb(Desc,Code,RowId)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod QueryTimeRangeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryTimeRangeExecute ]
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
	 s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod QueryTimeRangeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryTimeRangeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query QuerySessType() As %SQLQuery
{
	SELECT SESS_RowId AS SessRowid, SESS_Desc AS SessDesc FROM SQLUser.RBC_SessionType
	WHERE ((SESS_DateFrom <= +$h) OR (SESS_DateFrom IS NULL))
		AND  ((SESS_DateTo>= +$h) OR (SESS_DateTo IS NULL) )
}

// SELECT CLGRP_RowId AS CGRowid, CLGRP_Desc AS CGDesc FROM SQLUser.RBC_ClinicGroup

Query QueryClinicGroup(LocId As %String = "") As %SQLQuery
{
	select distinct A.CLGRP_RowId AS CGRowid,A.CLGRP_Desc AS CGDesc, A.CLGRP_Code AS CGCode from SQLUser.RBC_ClinicGroup A,SQLUser.DHC_LocSpec B
		WHERE ((A.CLGRP_DateFrom <= +$h) OR (A.CLGRP_DateFrom IS NULL))
		AND  ((A.CLGRP_DateTo>= +$h) OR (A.CLGRP_DateTo IS NULL) )
		AND ((A.CLGRP_RowId=B.DHCLS_CG_DR)AND(B.DHCLS_Loc_DR=:LocId) )
}

/*Query QueryRoom() As %SQLQuery
{
	SELECT CTLOC_RowID AS RoomRowid,CTLOC_Desc AS RoomDesc FROM SQLUser.CT_Loc WHERE CTLOC_Type='OR'
}*/
ClassMethod QueryRoomBroker(desc As %String = "", UserId As %String = "", loc As %String = "")
{
	s ret=""
	Set rset=##class(%ResultSet).%New("DHCDoc.DHCDocConfig.ScheduleTemp:QueryRoom")
	do rset.Execute(desc,UserId,loc)
	While (rset.Next()) {
		s RoomRowid=rset.GetData(3)
		if ret="" s ret=RoomRowid
		else  s ret=ret_"^"_RoomRowid
	}
	d rset.Close()
	Q ret
}

Query QueryRoom(desc As %String = "", UserId As %String = "", loc As %String = "") As %Query(ROWSPEC = "RoomDesc:%String,Code:%String,RoomRowid:%String")
{
}

// D ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.ScheduleTemp","QueryRoom","","1","219")

ClassMethod QueryRoomExecute(ByRef qHandle As %Binary, desc As %String = "", UserId As %String = "", loc As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	if (loc=""){
		s qHandle=$lb(0,repid,0) 
		Quit $$$OK
	}
	s LocHospDr=$p(^CTLOC(loc),"^",22)
	//挂号设置->排班诊室允许跨诊区
	s AllowOpenAllRoms=##class(web.DHCOPRegConfig).GetSpecConfigNode("AllowOpenAllRoms",LocHospDr)
	s ExaRowidStr=##class(web.DHCApptScheduleNew).GetExaRowidStrByLoc(loc)
	s desc=$$ALPHAUP^SSUTIL4(desc)
	s RowId=0
	f  s RowId=$o(^CTLOC(0,"LocType","OR",RowId)) q:RowId=""  d
	.s RoomHospDr=$p(^CTLOC(RowId),"^",22)
	.Q:(RoomHospDr'=LocHospDr)
	.s Desc=$p(^CTLOC(RowId),"^",2)
	.s Code=$p(^CTLOC(RowId),"^",1)
	.Q:($$ALPHAUP^SSUTIL4(Desc)'[desc)&&($$ALPHAUP^SSUTIL4(Code)'[desc)&&(desc'="")
	.s id=$o(^User.DHCBorExaRoomI("BordExaRoomDrIndex"," "_RowId,""))
	.q:(id="")&&(ExaRowidStr'="")&&(AllowOpenAllRoms=0)
	.s LocAreaExamRowid=""
	.i id'="" s LocAreaExamRowid=$list(^User.DHCBorExaRoomD(id),5)
	.q:("^"_ExaRowidStr_"^")'[("^"_LocAreaExamRowid_"^")&&(ExaRowidStr'="")&&(AllowOpenAllRoms=0)
	.q:($P(^CTLOC(RowId),"^",14)'="Y")
	.d OutputRowDoc
	s qHandle=$lb(0,repid,0) 
	Quit $$$OK
OutputRowDoc
    set Data=$lb(Desc,Code,RowId)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod QueryRoomFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryRoomExecute ]
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
	 s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod QueryRoomClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryRoomExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query QueryDOW() As %SQLQuery
{
	SELECT DOW_RowId AS DOWRowid, DOW_Name AS DOWDesc FROM SQLUser.CT_DayOfWeek ORDER BY DOW_Sequence
}

Query QueryZoneList(HospId As %String = "") As %Query(ROWSPEC = "rowid:%String,desc:%String,code:%String") [ SqlProc ]
{
}

/// d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.ScheduleTemp","QueryZoneList")
ClassMethod QueryZoneListExecute(ByRef qHandle As %Binary, HospId As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s rowid=0
	f  s rowid=$o(^User.DHCExaBoroughD(rowid)) q:rowid=""  d
	.s hosp=$list(^User.DHCExaBoroughD(rowid),13)
	.Q:(HospId'="")&&(HospId'=hosp)
	.s desc=$list(^User.DHCExaBoroughD(rowid),5)
	.s code=$list(^User.DHCExaBoroughD(rowid),2)
    .d OutputRow 
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK

OutputRow
    set Data=$lb(rowid,desc,code)
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod QueryZoneListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryZoneListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {            
	 Set AtEnd=1
	 Set Row=""
	}
	Else      {        
	 Set Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
    Quit $$$OK
}

ClassMethod QueryZoneListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryZoneListFetch ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

// 查询班次

Query RBScheduleLinesList(HospId As %String = "") As %Query(ROWSPEC = "RSLRowId:%String,Code:%String,Desc:%String,StartDate:%String,EndDate:%String,Notes:%String,AddUser:%String,AddLoc:%String,AddDate:%String,AddTime:%String,Default:%String")
{
}

ClassMethod RBScheduleLinesListExecute(ByRef qHandle As %Binary, HospId As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s HospId=##class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(HospId)
	s RSLRowId=0
	f  s RSLRowId=$o(^RB("RSL",RSLRowId)) q:RSLRowId=""  d
	.s Code=$p(^RB("RSL",RSLRowId),"^",1)
	.s Desc=$p(^RB("RSL",RSLRowId),"^",2)
	.s ShowDataFlag=##class(DHCDoc.Common.Hospital).GetHospShowDataFlag("RB_ResScheduleLines",RSLRowId,HospId)
	.Q:(HospId'="")&&(ShowDataFlag="N")
	.s StartDate=$p(^RB("RSL",RSLRowId),"^",3)
	.q:(StartDate'="")&&(StartDate>+$h)
	.s EndDate=$p(^RB("RSL",RSLRowId),"^",4)
	.q:(EndDate'="")&&(EndDate<+$h)
	.s Notes=$p(^RB("RSL",RSLRowId),"^",5)
	.s AddUserDr=$p(^RB("RSL",RSLRowId),"^",6)
	.s AddUser=$p($g(^SSU("SSUSR",AddUserDr)),"^",2)
	.s AddLocDr=$p(^RB("RSL",RSLRowId),"^",7)
	.s AddLoc=$p(^CTLOC(AddLocDr),"^",2)
	.s AddDate=..%ZD($p(^RB("RSL",RSLRowId),"^",8))
	.s AddTime=..%ZT($p(^RB("RSL",RSLRowId),"^",9),1)
	.s Default=$p(^RB("RSL",RSLRowId),"^",10)
	.d OutputRow
	s qHandle=$lb(0,repid,0) 
	Quit $$$OK
OutputRow
    set Data=$lb(RSLRowId,Code,Desc,StartDate,EndDate,Notes,AddUser,AddLoc,AddDate,AddTime,Default)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod RBScheduleLinesListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = RBScheduleLinesListExecute ]
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
	 s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod RBScheduleLinesListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = RBScheduleLinesListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query FindScheduleTempExport(LocRowid, UserRowid, DocRowid, ZoneID As %String = "", ScheduleLinesRowId As %String = "", ILocDesc As %String = "", IDocDesc As %String = "", HospId As %String = "") As %Library.Query(ROWSPEC = "LocDesc:%String:科室,ResDesc:%String:医生,TimeRange:%String:时段,Week1:%String:星期一,Week2:%String:星期二,Week3:%String:星期三,Week4:%String:星期四,Week5:%String:星期五,Week6:%String:星期六,Week7:%String:星期天")
{
}

/// d ##class(%ResultSet).RunQuery("web.DHCExamPatList","FindScheduleTempExport","2019-12-30","2020-01-20","","","","",10209,2,"")
ClassMethod FindScheduleTempExportExecute(ByRef qHandle As %Library.Binary, LocRowid, UserRowid, DocRowid, ZoneID As %String = "", ScheduleLinesRowId As %String = "", ILocDesc As %String = "", IDocDesc As %String = "", HospId As %String = "") As %Library.Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s rset=##class(%ResultSet).%New("DHCDoc.DHCDocConfig.ScheduleTemp:FindScheduleTemp")
	d rset.Execute(LocRowid, UserRowid, DocRowid, ZoneID, ScheduleLinesRowId, ILocDesc, IDocDesc, HospId)
	While (rset.Next()) {
		s LocDesc=rset.Data("LocDesc")
		s ResDesc=rset.Data("ResDesc")
		s TimeRange=rset.Data("TimeRange")
		s Week1=$p(rset.Data("Week1"),"^")
		s Week2=$p(rset.Data("Week2"),"^")
		s Week3=$p(rset.Data("Week3"),"^")
		s Week4=$p(rset.Data("Week4"),"^")
		s Week5=$p(rset.Data("Week5"),"^")
		s Week6=$p(rset.Data("Week6"),"^")
		s Week7=$p(rset.Data("Week7"),"^")
		s Room="" ;rset.Data("Room")
		s RowId="" ;$replace(rset.Data("RowId"),"^","||")
		s OutputList=$lb(LocDesc,ResDesc,TimeRange,Week1,Week2,Week3,Week4,Week5,Week6,Week7)
		d OutputRow14
	}
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
OutputRow14
	set Data=OutputList
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
}

ClassMethod FindScheduleTempExportFetch(ByRef qHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = FindScheduleTempExportExecute ]
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

ClassMethod FindScheduleTempExportClose(qHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindScheduleTempExportFetch ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod GetResRowID(CTPCPDR, LocID)
{
	s FindResRowID=""
	s ResRowID=0
	for {
		s ResRowID=$o(^RB("RES",0,"CTPCP",CTPCPDR,LocID,ResRowID)) Q:(ResRowID="")||(FindResRowID'="")
		s ScheSt=$p(^RB("RES",ResRowID),"^",6)
		continue:ScheSt'="Y"
		s DateFrom=$p(^RB("RES",ResRowID),"^",22)
		continue:(DateFrom'="")&&(DateFrom>+$h)
		s DateTo=$p(^RB("RES",ResRowID),"^",23)
		continue:(DateTo'="")&&(DateTo<=+$h)
		s FindResRowID=ResRowID
	}
	Q FindResRowID
}

/// 导出明细(竖向按星期输出)
Query FindScheDetialsTemp(LocRowid, UserRowid, DocRowid, ZoneID As %String = "", ScheduleLinesRowId As %String = "", ILocDesc As %String = "", IDocDesc As %String = "", HospId As %String = "") As %Query(ROWSPEC = "LocDesc:%String:科室,ResDesc:%String:医生,TimeRange:%String:时段,Week:%String:星期,Room:%String:诊室,RowId:%String:HIDDEN,LocRowid:%String:HIDDEN,DocRowid:%String:HIDDEN,TimeRangeDr:%String:HIDDEN,LocSortNum:%String:HIDDEN") [ SqlProc ]
{
}

/// d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.ScheduleTemp","FindScheduleTemp","","1","","","12","","","2")
ClassMethod FindScheDetialsTempExecute(ByRef qHandle As %Binary, LocRowid = "", UserRowid = "", DocRowid = "", ZoneID As %String = "", ScheduleLinesRowId As %String = "", ILocDesc As %String = "", IDocDesc As %String = "", HospId As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s ^tmp("FindScheDetialsTemp")=$lb(LocRowid,UserRowid,DocRowid,ZoneID,ScheduleLinesRowId,ILocDesc,IDocDesc,HospId)
	s HospId=##class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(HospId)
	s ILocDesc=$ZCVT(ILocDesc,"U")
	s:UserRowid="" UserRowid=%session.Data("LOGON.USERID")
	s User=" "_UserRowid
	s Type=" "_"REG" ;护士加号权限与排班权限使用同一存储结构，以类型字段区分
	i LocRowid="" d
	.s LocID=""
	.f  s LocID=$O(^User.DHCUserGroupI("UserLocDoc",Type,User,LocID)) q:LocID=""  d OneLoc
	e  d
	.s LocID=" "_LocRowid
	.d OneLoc
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OneLoc
	s mLocID=$TR(LocID," ")
	s LocHospId=$P(^CTLOC(mLocID),"^",22)
	;Q:(HospId'="")&&(HospId'=LocHospId)
	Q:"N"=##class(DHCDoc.Common.Hospital).GetHospShowDataFlag("CT_Loc",mLocID,HospId)
	s Find=0
	if (ZoneID'="") {
		s ID=0
		for {
			s ID=$o(^User.DHCExaBorDepI("BordBorDrIndex",ZoneID,ID)) Q:(ID="")||(Find=1)
			s BordDepDr=$lg(^User.DHCExaBorDepD(ID),7)
			if (BordDepDr=mLocID) s Find=1
		}
	}
	Q:(Find=0)&&(ZoneID'="")
	//Q:(ZoneID'="")&&('$d(^User.DHCExaBorDepI("BordBorDrIndex",ZoneID,mLocID)))
	Q:(##class(web.DHCDTHealthCommon).CheckLocValid(mLocID)="N")	//过滤无效科室
	s LocDesc=$P(^CTLOC(mLocID),"^",2)
	s:LocDesc["-" LocDesc=$P(LocDesc,"-",2)
	q:(ILocDesc'="")&&('##class(web.DHCOPAdmReg).CheckLocDesc(mLocID,ILocDesc))
	i DocRowid="" d
	.s DocID=""
	.f  s DocID=$O(^User.DHCUserGroupI("UserLocDoc",Type,User,LocID,DocID)) q:DocID=""  d
	..s mDocID=$TR(DocID," ")
	..q:mDocID=""
	..d OneDoc
	e  d
	.s mDocID=DocRowid
	.d OneDoc
	Q
OneDoc
	Q:"N"=##class(DHCDoc.Common.Hospital).GetHospShowDataFlag("CT_CarePrv",mDocID,HospId)
	s doctorstr=$P($g(^CTPCP(mDocID,"1")),"^",2)
	q:doctorstr=""
	q:((IDocDesc'="")&&(doctorstr'[IDocDesc))
	s ResRowid=$O(^RB("RES",0,"CTPCP",mDocID,mLocID,""),-1)
	q:ResRowid=""
	s ResDesc=$P(^RB("RES",ResRowid),"^",17)
	if (ScheduleLinesRowId'=""){
		q:'$d(^RB("RES",ResRowid,"DATE",0,"RSL",ScheduleLinesRowId))
		s DateSub=$O(^RB("RES",ResRowid,"DATE",0,"RSL",ScheduleLinesRowId,""),-1)
	}else{
		s DateSub=$O(^RB("RES",ResRowid,"DATE",""),-1)
	}
	q:DateSub=""
	s DateRowid=ResRowid_"||"_DateSub
	d OneDateSess
	Q
OneDateSess
	k DOWList,RoomList
	s SessSub=0
	f  s SessSub=$O(^RB("RES",ResRowid,"DATE",DateSub,"SESS",SessSub)) q:SessSub=""  d
	.s SessNo=$P(^RB("RES",ResRowid,"DATE",DateSub,"SESS",SessSub),"^",3)
	.q:SessNo=""
	.s DOWDR=$P(^RB("RES",ResRowid,"DATE",DateSub,"SESS",SessSub),"^",2)
	.q:DOWDR=""
	.s DOW=$P(^CT("DOW",1,DOWDR),"^",2)
	.s week=$P(^CT("DOW",1,DOWDR),"^",1)
	.s Load=+$P(^RB("RES",ResRowid,"DATE",DateSub,"SESS",SessSub),"^",8)
	.s GenerFlag=$P(^RB("RES",ResRowid,"DATE",DateSub,"SESS",SessSub),"^",16)
	.s Load=Load_"^"_GenerFlag
	.s RoomLocId=$P(^RB("RES",ResRowid,"DATE",DateSub,"SESS",SessSub),"^",19)
	.i $G(RoomList(SessNo))="" s RoomList(SessNo)=RoomLocId
	.s WinMethodID=$o(^RBC("APTM",0,"Code","WIN",0))
	.s WebMethodID=$o(^RBC("APTM",0,"Code","WEB",0))
	.s WINMaxQty=""
	.s WEBMaxQty=""
	.s SessionTypeDR=$p(^RB("RES",ResRowid,"DATE",DateSub,"SESS",SessSub),"^",9)
	.s SessionType=$p(^RBC("SESS",SessionTypeDR),"^",2)
	.s SttTime=$p(^RB("RES",ResRowid,"DATE",DateSub,"SESS",SessSub),"^",4)
	.s SttTime=$zt(SttTime,2)
	.s EndTime=$p(^RB("RES",ResRowid,"DATE",DateSub,"SESS",SessSub),"^",5)
	.s EndTime=$zt(EndTime,2)
	.s SessLoad=$p(^RB("RES",ResRowid,"DATE",DateSub,"SESS",SessSub),"^",8)
	.s SessNoApptSlot=$p(^RB("RES",ResRowid,"DATE",DateSub,"SESS",SessSub),"^",1)
	.;s DOWList(SessNo,DOW)=week_"^"_Load_"^"_WINMaxQty_"^"_WEBMaxQty_"^"_SessionType_"^"_SttTime_"^"_EndTime_"^"_SessLoad_"^"_SessNoApptSlot
	.s DOWList(DOW,SessNo)=week_"^"_Load_"^"_WINMaxQty_"^"_WEBMaxQty_"^"_SessionType_"^"_SttTime_"^"_EndTime_"^"_SessLoad_"^"_SessNoApptSlot
	Q:'$D(DOWList)
	b ;DOWList
	
	s cnt=0
	f DOW=1:1:7 d
	.s SessNo=0
	.f  s SessNo=$O(DOWList(DOW,SessNo)) q:SessNo=""  d
	..s TimeRange=$P(^DHCTimeRange(SessNo),"^",2)
	..s TimeRangeDr=SessNo
	..s LocDesc=$P(^CTLOC(mLocID),"^",2)
	..s:LocDesc["-" LocDesc=$P(LocDesc,"-",2)
	..;i cnt'=0 d
	...;s LocDesc="-"
	...;s ResDesc="-"
	..s Data=$lb(LocDesc,ResDesc,TimeRange)
	..s val=$G(DOWList(DOW,SessNo))
	..s Data=Data_$LB(val)
	..s Room=$G(RoomList(SessNo))
	..s:Room'="" Room=$P(^CTLOC(Room),"^",2)
	..s:Room["-" Room=$P(Room,"-",2)
	..s RowId=DateRowid_"^"_SessNo
	..;此处需要对科室进行排序
	..s LocSortNum=##class(web.DHCBL.BDP.BDPSort).GetSortNum("User.CTLoc","坐诊信息",mLocID)
	..if (+LocSortNum=0) s LocSortNum="A99999"
	..else  s LocSortNum=$e("000000",1,6-$l(LocSortNum))_LocSortNum
	..s LocSortNum=LocSortNum_mLocID
	..s OutSortNum=LocSortNum_mLocID_mDocID_DOW_TimeRangeDr_RowId 	// 星期 上下午
	..s Data=Data_$LB(Room,RowId,mLocID,mDocID,TimeRangeDr,LocSortNum)
	..d OutputRow
	..s cnt=cnt+1
	
	Q
OutputRow
	;Set ^CacheTemp(repid,ind)=Data
	Set ^CacheTemp(repid,OutSortNum)=Data
	Set ind=ind+1
	q
}

ClassMethod FindScheDetialsTempFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindScheDetialsTempExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {            
	 Set AtEnd=1
	 Set Row=""
	}
	Else      {        
	 Set Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
    Quit $$$OK
}

ClassMethod FindScheDetialsTempClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindScheDetialsTempFetch ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

}
