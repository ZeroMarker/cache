/// 调用计费组第三方交易接口使用
Class web.DHCOPAdmRegPay Extends DHCDoc.Util.RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// 获取挂号所在的挂号发票
ClassMethod GetRegInvoiceId(RegfeeRowId As %String) As %String
{
	s InvoiceId=""
	s obj=##class(User.DHCRegistrationFee).%OpenId(RegfeeRowId)
	if $IsObject(obj){
		s InvoiceId=obj.Regfeetemp1.%Id()
		d obj.%Close()
	}
	Q InvoiceId
}

/// 获取挂号对应的发票信息
ClassMethod GetMisposINVIdStr(RegfeeId As %String, Flag As %String = "") As %String
{
	Q:RegfeeId="" ""
	s RtnStr=""
	s INVRowId=$List(^User.DHCRegistrationFeeD(RegfeeId),11)
	;wangjian 2019-01-16 商保挂号表发票ID被赋值空尝试通过就诊找最新挂号正票
	If (INVRowId=""){
		s PAAdm=$List(^User.DHCRegistrationFeeD(RegfeeId),2)
		s BCIRowID=""
		f  s BCIRowID=$o(^DHCBCI(0,"ADM",PAAdm,BCIRowID)) q:BCIRowID=""  d
		.s BCIInvDR=$p(^DHCBCI(BCIRowID),"^",1)
		.s InitDr=$p(^DHCINVPRT(BCIInvDR),"^",13)
		.q:InitDr'="" ;负的过滤
		.s PrtFairType=$p(^DHCINVPRT(BCIInvDR),"^",34)
		.q:PrtFairType'="R"
		.s INVRowId=BCIInvDR
	}
	Q:INVRowId="" ""
	if Flag=1 {
		s OrgPrtRowID=##class(DHCDoc.OPAdm.Common).GetOrgPrtRowID("",INVRowId,"")
		if OrgPrtRowID="" {
			b ;说明没有红冲过
			s AbortPrtRowID=$o(^DHCINVPRT(0,"InitInvDR",INVRowId,""))
			s RtnStr=INVRowId_"^"_AbortPrtRowID_"^"
		}else{
			b ;有红冲
			s LastPrtRowid=$p(^DHCINVPRT(INVRowId),"^",29)
			s AbortPrtRowID=$o(^DHCINVPRT(0,"InitInvDR",LastPrtRowid,""))
			s RtnStr=OrgPrtRowID_"^"_AbortPrtRowID_"^"_INVRowId
		}
	}else{
		s AbortPrtRowID=$o(^DHCINVPRT(0,"InitInvDR",INVRowId,""))
		s RtnStr=INVRowId_"^"_AbortPrtRowID_"^"
	}
	Q RtnStr
}

/// 插入日志消息信息
ClassMethod SetLogMesage(ID As %String, IDTypeDesc As %String, PayMesage As %String, PayRtn As %String, Note As %String, Logmesg As %String, Statu As %String) As %String
{
	s userID=$P(Logmesg,"^",1)
	s LogId=$P(Logmesg,"^",2)
	s Ip=$P(Logmesg,"^",3)
	s Mac=$P(Logmesg,"^",4)
	
	s nowDate=..%SysDate()
	s nowTime=..%SysTime()
	&SQL(insert SQLUser.DHCOPAdmRegPayLoc(
		OnlyID,OnlyTypeDesc,InsertDate,InsertTime,InsertUser,InsertLoc,InsertIP,InsertMac,
		PayMesage,PayRtn,PayNote,Statu
	)values(:ID,:IDTypeDesc,:nowDate,:nowTime,:userID,:LogId,:Ip,:Mac,
		:PayMesage,:PayRtn,:Note,:Statu
	))
	q SQLCODE
}

/// 获取消息
/// d ##class(%ResultSet).RunQuery("web.DHCOPAdmRegPay","FindLogMes",+$H,+$H,"","","","")
Query FindLogMes(Stdate As %String, EndDate As %String, PatNo As %String, MySelf As %String, OnlyError As %String, LogOnUser As %String) As %Query(ROWSPEC = "rowid:%String,OnlyID:%String,OnlyTypeDesc:%String,InsertDate:%String,InsertTime:%String,UserName:%String,LocDesc:%String,InsertIP:%String,InsertMac:%String,PayMesage:%String,PayRtn:%String,PayNote:%String,Statu:%String,PatName:%String,PatNoFind:%String")
{
}

ClassMethod FindLogMesExecute(ByRef qHandle As %Binary, Stdate As %String, EndDate As %String, PatNo As %String, MySelf As %String, OnlyError As %String, LogOnUser As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
	
	s Stdate=..%ZDH(Stdate)
	s EndDate=..%ZDH(EndDate)
	for date=Stdate:1:EndDate  d
	.s time=0
	.f  s time=$O(^User.DHCOPAdmRegPayLocI("InsertDateTime",date,time)) Q:time=""  d
	..s rowid=0
	..f  s rowid=$O(^User.DHCOPAdmRegPayLocI("InsertDateTime",date,time,rowid)) Q:rowid=""  d
	...s OnlyID=$listget(^User.DHCOPAdmRegPayLocD(rowid),2)
	...s OnlyTypeDesc=$listget(^User.DHCOPAdmRegPayLocD(rowid),3)
	...s InsertDate=$listget(^User.DHCOPAdmRegPayLocD(rowid),4)
	...s InsertTime=$listget(^User.DHCOPAdmRegPayLocD(rowid),5)
	...s InsertUser=$listget(^User.DHCOPAdmRegPayLocD(rowid),6)
	...s InsertLoc=$listget(^User.DHCOPAdmRegPayLocD(rowid),7)
	...s InsertIP=$listget(^User.DHCOPAdmRegPayLocD(rowid),8)
	...s InsertMac=$listget(^User.DHCOPAdmRegPayLocD(rowid),9)
	...s PayMesage=$listget(^User.DHCOPAdmRegPayLocD(rowid),10)
	...s PayRtn=$listget(^User.DHCOPAdmRegPayLocD(rowid),11)
	...s PayNote=$listget(^User.DHCOPAdmRegPayLocD(rowid),12)
	...s Statu=$listget(^User.DHCOPAdmRegPayLocD(rowid),13)
	...s InsertDate=..%ZD(InsertDate)
	...s InsertTime=..%ZT(InsertTime,2)
	...s UserName=$p($g(^SSU("SSUSR",InsertUser)),"^",2)
	...s LocDesc=$P(^CTLOC(InsertLoc),"^",2)
	...s:LocDesc["-" LocDesc=$P(LocDesc,"-",2)
	...s patID=""
	...s:OnlyTypeDesc["PatDr" patID=OnlyID
	...s:OnlyTypeDesc["挂号表ID" AdmDr=$listget(^User.DHCRegistrationFeeD(OnlyID),2),patID=$P(^PAADM(AdmDr),"^",1)
	...s PatName="",PatNoFind=""
	...s:patID'="" PatName=$p(^PAPER(patID,"ALL"),"^",1)
	...;取登记号
	...s:patID'="" PatNoFind=$p(^PAPER(patID,"PAT",1),"^",2)
	...Q:((MySelf="Y")&&(InsertUser'=LogOnUser))
	...Q:((OnlyError="Y")&&(Statu=0))
	...Q:((PatNo'="")&&(PatNo'=PatNoFind))
    ...Do OutputRow
    
    
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set Data=$lb(rowid,OnlyID,OnlyTypeDesc,InsertDate,InsertTime,UserName,LocDesc,InsertIP,InsertMac,PayMesage,PayRtn,PayNote,Statu,PatName,PatNoFind)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindLogMesFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindLogMesExecute ]
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
}

ClassMethod FindLogMesClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindLogMesExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

}
