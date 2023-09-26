Import sqluser

/// Lid
/// 2010-02-22
/// 实现个人关联到集团账户
Class web.DHCOPBillAccLink Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 27;

ClassMethod FindGroupAccDetailsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindGroupAccDetailsExecute ]
{
   //住院收费员查询
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator：      Lid
/// CreatDate：    2010-02-22
/// Description:   根据登记号查询给病人对应的集团账户所关联的个人信息
/// Input：        登记号,账户ID
/// Return：       
/// Other：  	
ClassMethod FindGroupAccDetailsExecute(ByRef qHandle As %Binary, AccRowid As %String = "", AGABeginDate, AGAEndDate) As %Status
{
    Set repid=$I(^CacheTemp)
    s ind=1
    
    s AGABeginDate=##class(websys.Conversions).DateHtmlToLogical(AGABeginDate)
    s AGAEndDate=##class(websys.Conversions).DateHtmlToLogical(AGAEndDate)
    i (+AccRowid=0)&(AGABeginDate="")&(AGAEndDate="") Set qHandle=$lb(0,repid,0) Quit $$$OK
    i (+AccRowid'=0) d
   	  .d GetAccDetail(AccRowid)
    e  d
    .f Date=AGABeginDate:1:AGAEndDate d
    ..s AccRowid=""
    ..f  s AccRowid=$o(^DHCACDi("AccM",0,"GA","AddDate",Date,AccRowid)) q:AccRowid=""  d
    ...d GetAccDetail(AccRowid)
    
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow1
	set Data=$lb(AGAPAPMIDR,PapmiNo,PapmiName,AGAPrior,AGABeginDate,AGABeginTime,AGAEndDate,AGAEndTime,AGASub,AGAPriorDesc,AGAPriorNote2,TAddUser,TAddDate,TAccPapNo,TAccCardNo)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
	Quit $$$OK
GetAccDetail(AccRowid)
    s TAccPapNo=$p(^DHCACD("AccM",AccRowid),"^",3)
    s TAccCardNo=$p(^DHCACD("AccM",AccRowid),"^",4)
	s AGASub=0
   	f  s AGASub=$o(^DHCACD("AccM",AccRowid,"A",AGASub)) q:AGASub=""  d
	.s AGAstr=^DHCACD("AccM",AccRowid,"A",AGASub)
   	.s AGAPAPMIDR=$p(AGAstr,"^",6)
   	.s PapmiNo=$p(^PAPER(AGAPAPMIDR,"PAT",1),"^",1)
   	.s PapmiName=$p(^PAPER(AGAPAPMIDR,"ALL"),"^",1)
   	.s AGABeginDate=##class(websys.Conversions).DateLogicalToHtml($p(AGAstr,"^",2))
	.s AGABeginTime=##class(websys.Conversions).TimeLogicalToHtml($p(AGAstr,"^",3),1)
    .s AGAEndDate=##class(websys.Conversions).DateLogicalToHtml($p(AGAstr,"^",4))
    .s AGAEndTime=##class(websys.Conversions).TimeLogicalToHtml($p(AGAstr,"^",5),1)
    .s AGAPrior=$p(AGAstr,"^",7)
    .s AGAPriorDesc=$s(AGAPrior="P":"个人",AGAPrior="G":"团队")
    .s AGAPriorNote2=$p(AGAstr,"^",11)
    .s TAddUser=$p(AGAstr,"^",10)
    .s TAddUser=$p(^SSU("SSUSR",TAddUser),"^",2)
    .s TAddDate=$p(AGAstr,"^",12),TAddDate=##class(websys.Conversions).DateLogicalToHtml(TAddDate)
    .s TAddTime=$p(AGAstr,"^",13),TAddTime=##class(websys.Conversions).TimeLogicalToHtml(TAddTime,1)
    .s TAddDate=TAddDate_" "_TAddTime
    .d OutputRow1
}

ClassMethod FindGroupAccDetailsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindGroupAccDetailsExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
	Quit $$$OK
}

Query FindGroupAccDetails(AccRowid As %String = "", AGABeginDate, AGAEndDate) As %Query(ROWSPEC = "TPAPERDR:%String,TPatRegNo:%String,TName:%String,TPrior:%String,TBeginDate:%String,TBeginTime:%String,TEndDate:%String,TEndTime:%String,TAGARowid:%String,TPriorDesc:%String,TAGAActiveFlag:%String,TAddUser,TAddDate,TAccPapNo,TAccCardNo")
{
}

/// /input:  登记号
/// /output: AccRowid^AccPAPMINo^AccAccountNo^AccCardNo^AccName^AccStatus 
/// /desc:   根据登记号获取病人账户信息 
/// /Table:  User.DHCAccManager
ClassMethod GetAccInfoByRegNO(regno)
{
    new (regno)
    s regno=##Class(web.DHCOPCashier).FormatPatientNo(regno) //转成正常长度
    s regno=$$ALPHAUP^SSUTIL4(regno)
    s papmiDr="",rtnStr=""
    f  s papmiDr=$o(^PAPERi("PAPMI_PatNo",regno,papmiDr)) q:papmiDr=""  d
    .s accMDr=""
    .s name=$p(^PAPER(papmiDr,"ALL"),"^",1)
    .f  s accMDr=$o(^DHCACDi("AccM",0,"PAPMI",papmiDr,accMDr)) q:accMDr=""  d
    ..q:'$d(^DHCACD("AccM",accMDr))
    ..s str=^DHCACD("AccM",accMDr)
    ..s accMType=$p(str,"^",16)  		;账户类型（P:个人账户，C:集团账户）
    ..s accStatus=$p(str,"^",13) 		;账户状态(N:激活,F:结算,S:挂起)
    ..q:accMType'="C"
    ..q:accStatus'="N"
    ..s accountNo = $p(str,"^",1)
    ..s cardNo = $p(str,"^",4)
    ..s rtnStr=accMDr_"^"_regno_"^"_accountNo_"^"_cardNo_"^"_name_"^"_accStatus
    q rtnStr
}

/// /input:  登记号
/// /output: paRowid^regno^name
/// /desc:   根据登记号获取病人信息 
/// /Table:  User.PaPatMas
ClassMethod GetPatInfoByRegNO(regno)
{
	n (regno)
    s regno=##Class(web.DHCOPCashier).FormatPatientNo(regno) //转成正常长度
    s regno=$$ALPHAUP^SSUTIL4(regno)
    s papmiDr="",rtnStr=""
    s papmiDr=$o(^PAPERi("PAPMI_PatNo",regno,papmiDr))
    q:+papmiDr=0 rtnStr
    s name=$p(^PAPER(papmiDr,"ALL"),"^",1)
    s rtnStr=papmiDr_"^"_regno_"^"_name
    q rtnStr
}

/// /save record to User.DHCAccGroupAccredit
/// /input:AGA_AccM_ParRef^AGA_PAPMI_DR^AGAPrior^AGA_BeginDate^AGA_BeginTime^AGA_EndDate^AGA_EndTime^UserIdNote1^activateFlagNote2
/// /2^1^P^25/02/2010^00:00^25/02/2010^00:00
ClassMethod InsertAccGroupAccredit(str)
{
	;1^65527^P^20/04/2010^^01/04/2011^^11327^Activate
	;w ##class(web.DHCOPBillAccLink).InsertAccGroupAccredit("1^65527^P^20/04/2010^^01/04/2011^^11327^Activate")
	new (str)
	s AGAAccMParRef=$p(str,"^",1)
	s AGAAccMParRef=$p(AGAAccMParRef,$c(1),1)
	s PAPMIDr=$p(str,"^",2)
	q:AGAAccMParRef="" "10"
	q:PAPMIDr="" "11"
	b ;
	;S AGAObject = ##class(User.DHCAccGroupAccredit).%New(AGAAccMParRef)
	;S AGAObject = ##class(User.DHCAccGroupAccredit).%New()
	;b ;1
	;d AGAObject.AGAAccMParRefSetObjectId(patAGAObject.%ID)
	;d AGAObject.AGAPAPMIDRSetObjectId(PAPMIDr)
	;b ;2
	;s AGAObject.AGAPrior=$p(str,"^",3)
	;s AGAObject.AGABeginDate=$zdh($p(str,"^",4),4)
	;s AGAObject.AGABeginTime=$zth($p(str,"^",5),4)
	;s AGAObject.AGAEndDate=$zdh($p(str,"^",6),4)
	;s AGAObject.AGAEndTime=$zth($p(str,"^",7),4)
	;s AGAObject.AGANote1=$p(str,"^",8)
	;s AGAObject.AGANote2=$p(str,"^",9)
	;s sc=AGAObject.%Save()
	;If $$$ISERR(sc) {
		;Do $System.Status.DisplayError(sc)
		;Q ""
	;}
	;d AGAObject.%Close()
	;d patAGAObject.%Close()
	s retcode=0
	TSTART
	k PLIST
	s PLIST(0)=AGAAccMParRef
	s PLIST(8)=PAPMIDr
	s PLIST(3)="Y"
	s PLIST(9)=$p(str,"^",3)
	s STDate=$p(str,"^",4)
	i STDate'=""  d
	.s STDate=$zdh(STDate,4)
	s PLIST(4)=STDate
	s STTime=$p(str,"^",5)
	i STTime'=""  d
	.s STTime=$zth(STTime,1) 
	s PLIST(5)=STTime
	s EndDate=$p(str,"^",6)
	i EndDate'=""  d
	.s EndDate=$zdh(EndDate,4)
	s PLIST(6)=EndDate
	s EndTime=$p(str,"^",7)
	i EndTime'=""  d
	.s EndTime=$zth(EndTime,1) 
	s PLIST(7)=EndTime
	s PLIST(12)=$p(str,"^",8)
	s PLIST(13)=$p(str,"^",9)
	s PLIST(14)=+$H
	S PLIST(15)=$p($h,",",2)
	&sql(INSERT INTO DHC_AccGroupAccredit Values PLIST())
	s retcode=SQLCODE
	i retcode=0  d
	.Tcommit
	e  d
	.Trollback
	q retcode
}

/// Update record to User.DHCAccGroupAccredit
/// input:AGA_AccM_ParRef^AGA_Rowid^AGA_PAPMI_DR^AGAPrior^AGA_BeginDate^AGA_BeginTime^AGA_EndDate^AGA_EndTime^UserIdNote1^activateFlagNote2
ClassMethod UpdateAccGroupAccredit(str)
{
	new (str)
	s ^TMP("wanghc")=str 
	s AGAAccMParRef=$p(str,"^",1)
	s AGARowid=$p(str,"^",2)
	s PAPMIDr=$p(str,"^",3)
	q:AGAAccMParRef="" "10"
	q:PAPMIDr="" "11"
	q:AGARowid="" "12"
	S AGAObject = ##class(User.DHCAccGroupAccredit).%OpenId(AGAAccMParRef_"||"_AGARowid)
	///d AGAObject.AGAAccMParRefSetObjectId(AGAAccMParRef)
	d AGAObject.AGAPAPMIDRSetObjectId(PAPMIDr)
	s AGAObject.AGAPrior=$p(str,"^",4)
	s AGAObject.AGABeginDate=$zdh($p(str,"^",5),4)
	s AGAObject.AGABeginTime=$zth($p(str,"^",6),4)
	s AGAObject.AGAEndDate=$zdh($p(str,"^",7),4)
	s AGAObject.AGAEndTime=$zth($p(str,"^",8),4)
	s AGAObject.AGANote1=$p(str,"^",9)
	s AGAObject.AGANote2=$p(str,"^",10)
	s sc=AGAObject.%Save()
	If $$$ISERR(sc) {
		Do $System.Status.DisplayError(sc)
		Q ""
	}
	d AGAObject.%Close()
	q 1
}

}
