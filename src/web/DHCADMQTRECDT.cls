Import SQLUser

Class web.DHCADMQTRECDT Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// 取体温单事件维护
/// 2010-11-15
ClassMethod GetQtTyp(funname As %String) As %String
{
	s rw=0  f  s rw=$o(^DHCQTRECTYP("typ",rw)) q:rw=""  d
	.s typ=$P(^DHCQTRECTYP("typ",rw),"^",2)
 	.s rtnval=funname_"('"_$ZCVT($g(rw),"O","JS")_"','"_$ZCVT($g(typ),"O","JS")_"');"
 	.&javascript<#(rtnval)#>
 	q 0
}

/// Creator: LiuLei
/// CreatDate: 2009-10-26
/// Description: 生命体征自动添加入院时间
/// Table：DHC_QTRECTYP,DHC_ADMQTREC
/// Input：Adm: 病人就诊ID
/// Return:
ClassMethod QtPatAdmDate(Adm As %String) As %String
{
	s ret=1
	s user=""
	s rw=0  f  s rw=$O(^DHCADMQTREC("adm",Adm,rw)) q:(rw="")!(ret=0)  d
	.s TypDr=$P(^DHCADMQTREC("QTREC",rw),"^",4)
	.i TypDr'="" s Typ=$p(^DHCQTRECTYP("typ",TypDr),"^",2)
	.i Typ["入院" s ret=0
	i ret'=0 d
	.s ADate=$ZD($p(^PAADM(Adm),"^",6),3)
	.s ATime=$ZT($p(^PAADM(Adm),"^",7))
	.s Typ=1
	.s user=..PACInPatDateBed(Adm)
	.d ##class(web.DHCADMQTREC).QtInsert(Adm,ADate,ATime,Typ,user)
	s insertOpOrder=..QtPatOpDate(Adm)
	s insertCYOrder=..QtPatCYDate(Adm)
	s insertTransOrder=..QtPatTransDate(Adm)
	q ""
}

ClassMethod QtPatAdmDate2(Adm As %String) As %String
{
	//自动加入入住时间
	s ret=1
	s user=""
	s rw=0  f  s rw=$O(^DHCADMQTREC("adm",Adm,rw)) q:(rw="")!(ret=0)  d
	.s TypDr=$P(^DHCADMQTREC("QTREC",rw),"^",4)
	.i TypDr'="" s Typ=$p(^DHCQTRECTYP("typ",TypDr),"^",2)
	.i Typ["入住" s ret=0
	i ret'=0 d
	.s transc=0,chd=0 f  s transc=$o(^PAADM(Adm,"TRANS",transc)) q:(transc="")  d
	  ..q:chd'=0
	  ..s ttype=$p(^PAADM(Adm,"TRANS",transc),"^",21)
	  ..i ttype'="" s chd=transc
	.s sdate=$p(^PAADM(Adm,"TRANS",chd),"^",1)
	.s stime=$p(^PAADM(Adm,"TRANS",chd),"^",2)
	.s ADate=$zd(sdate,3)
	.s ATime=$zt(stime,2)
	.s Typ=8
	.s user=..PACInPatDateBed(Adm)
	.d ##class(web.DHCADMQTREC).QtInsert(Adm,ADate,ATime,Typ,user)
	s insertOpOrder=..QtPatOpDate(Adm)
	s insertCYOrder=..QtPatCYDate(Adm)
	s insertTransOrder=..QtPatTransDate(Adm)
	q ""
}

ClassMethod PACInPatDateBed(EpisodeID As %String = "") As %String
{
    q:EpisodeID="" ""
    s ret=""
    s TRANSChildsub=0,Flag=0
    f  s TRANSChildsub=$o(^PAADM(EpisodeID,"TRANS",TRANSChildsub)) q:(TRANSChildsub="")!(Flag=1)  d
    .s TRANBed=$p(^PAADM(EpisodeID,"TRANS",TRANSChildsub),"^",8)
    .q:TRANBed=""
    .i TRANBed'="" s Flag=1
    .//s TRANDate=$p(^PAADM(EpisodeID,"TRANS",TRANSChildsub),"^",1)
    .//s TRANTime=$p(^PAADM(EpisodeID,"TRANS",TRANSChildsub),"^",2)
    .s userDr=$p(^PAADM(EpisodeID,"TRANS",TRANSChildsub),"^",16)
    .//s ret=TRANDate_"^"_TRANTime_"^"_userDr
    .s ret=userDr
    q ret
}

/// 自动添加出院时间
ClassMethod QtPatCYDate(Adm As %String) As %String
{
	//w ##class(web.DHCADMQTREC).QtPatCYDate(1806)
	q:Adm="" ""
	//判断是否有"出院"或"呼吸心跳停止"医嘱
	k OArcim
	s OArcim("20172||1")="",OArcim("20131||1")=""
	s oeordId=$o(^OEORD(0,"Adm",Adm,0)) 
    q:oeordId="" ""
    s arcimId=""  f  s arcimId=$O(OArcim(arcimId)) q:arcimId=""  d
	.s curSttDate="" f  s curSttDate=$O(^OEORDi(0,"ARCIM",oeordId,arcimId,curSttDate)) q:curSttDate=""  d
	..s oeoriSub="" f  s oeoriSub=$O(^OEORDi(0,"ARCIM",oeordId,arcimId,curSttDate,oeoriSub)) q:oeoriSub=""  d
	...s ordStatId=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",13)  //OEORI_ItemStat_DR
    ...s ordStatCode=$p($g(^OEC("OSTAT",+ordStatId)),"^") 
    ...q:ordStatCode'="V"	//非核实退出
    ...q:$D(^TMP("DHCNurInsertFinal",oeordId,oeoriSub))>0
    ...s sttDate=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",9)
    ...s sttTime=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",10)
    ...b ;01
    ...i sttDate'="" s sttDate=$ZD(sttDate,3)
    ...i sttTime'="" s sttTime=$ZT(sttTime)
    ...s user=""
    ...s arcimDr=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",2)
	...s oeoreSub=0 f  s oeoreSub=$o(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub)) q:(oeoreSub="")  d
 	....s execCpcpId=$p($g(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub)),"^",15)	//执行人
 	....i execCpcpId'="" s user=$O(^SSU("SSUSR",0,"CTPCP",execCpcpId,0)) 
 	...i arcimDr="20172||1" d
	....s Typ=95	//事件维护中出院的RowID
	....d ##class(web.DHCADMQTREC).QtInsert(Adm,sttDate,sttTime,Typ,user)
 	...s Typ=7	//事件维护中出院的RowID
	...i arcimDr'="20172||1" d ##class(web.DHCADMQTREC).QtInsert(Adm,sttDate,sttTime,Typ,user)
	...s ^TMP("DHCNurInsertFinal",oeordId,oeoriSub)=""
	q ""
}

/// 自动添加转科事件
ClassMethod QtPatTransDate(Adm As %String) As %String
{
	q:Adm="" ""
	s oeordId=$o(^OEORD(0,"Adm",Adm,0)) 
    q:oeordId="" ""
    s oeoriSub="0"  f  s oeoriSub=$O(^OEORD(oeordId,"I",oeoriSub))  q:(oeoriSub="")!(oeoriSub="0")  d
	.s ordStatId=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",13)  //OEORI_ItemStat_DR
    .s ordStatCode=$p($g(^OEC("OSTAT",+ordStatId)),"^") 
    .q:ordStatCode'="V"	//非核实退出
    .s ArcimDR=$P($G(^OEORD(oeordId,"I",oeoriSub,1)),"^",2)
    .s ARCIMRowid=$P(ArcimDR,"||",1)
	.s ARCIMSub=$P(ArcimDR,"||",2)  
	.s ArcimDesc=$P($G(^ARCIM(ARCIMRowid,ARCIMSub,1)),"^",2)
	.s ItemCatDR=$P($G(^ARCIM(ARCIMRowid,ARCIMSub,1)),"^",10)
	.q:ItemCatDR'=152  //152为 无费用嘱托(转科)类
	.b ;01
    .q:$D(^TMP("DHCNurInsertTrans",oeordId,oeoriSub))>0
    .s sttDate=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",9)
    .s sttTime=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",10)
    .i sttDate'="" s sttDate=$ZD(sttDate,3)
    .i sttTime'="" s sttTime=$ZT(sttTime)
    .s user=""
	.s oeoreSub=0 f  s oeoreSub=$o(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub)) q:(oeoreSub="")  d
 	..s execCpcpId=$p($g(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub)),"^",15)	//执行人
 	..i execCpcpId'="" s user=$O(^SSU("SSUSR",0,"CTPCP",execCpcpId,0))
 	.s Typ=..GetQtIdByDesc(ArcimDesc)
 	.b ;02
 	.q:Typ="" 
	.d ##class(web.DHCADMQTREC).QtInsert(Adm,sttDate,sttTime,Typ,user)
	.s ^TMP("DHCNurInsertTrans",oeordId,oeoriSub)=""
	.b ;03
	q ""
}

ClassMethod GetQtIdByDesc(QtDesc As %String) As %String
{
	//w ##class(web.DHCADMQTREC).GetQtIdByDesc("转入")
	s TypDr=""
	s flag=0
	s rtn=""
	
	f  s TypDr=$o(^DHCQTRECTYP("typ",TypDr)) q:(TypDr="")!(flag=1)  d
	.s TypDesc=$P(^DHCQTRECTYP("typ",TypDr),"^",2)
	.//b ;001
	.q:($$ALPHAUP^SSUTIL4(TypDesc)'=$$ALPHAUP^SSUTIL4(QtDesc))
	.b ;002
	.s flag=1,rtn=TypDr
	
	q rtn
}

ClassMethod QtListExecute(ByRef qHandle As %Binary, Adm As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
	s rw=0  f  s rw=$O(^DHCADMQTREC("adm",Adm,rw)) q:rw=""  d
	.s ADate=$P(^DHCADMQTREC("QTREC",rw),"^",2)
	.if ADate'="" s ADate=$ZD(ADate,3)
	.s ATime=$P(^DHCADMQTREC("QTREC",rw),"^",3)
	.if ATime'="" s ATime=$ZT(ATime,2)
	.s TypDr=$P(^DHCADMQTREC("QTREC",rw),"^",4)
	.if TypDr'="" s Typ=$P($g(^DHCQTRECTYP("typ",TypDr)),"^",2)
	.s UserDr=$p(^DHCADMQTREC("QTREC",rw),"^",7)
    .if UserDr'="" s User=$p(^SSU("SSUSR",UserDr),"^",2)
	.d outqt
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
outqt
	//set Data=$lb(ADate,ATime,Typ,User,rw,TypDr)
	set Data=$lb(ADate,ATime,Typ,$G(User),rw,TypDr)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod QtListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QtListExecute ]
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

Query QtList(Adm As %String) As %Query(ROWSPEC = "ADate,ATime,Typ,User,rw,TypDr")
{
}

ClassMethod QtListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QtListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod QtUpdate(rowid As %String, ADate As %String, ATime As %String, Typ As %String, user As %String) As %String
{
	&sql(select *  into PLIST() from DHC_ADMQTREC where QTREC_ROWID=:rowid)
  s PLIST(3)=$ZDH(ADate,3)
  s PLIST(4)=$ZTH(ATime)
  s PLIST(5)=Typ
  s PLIST(6)=$P($H,",")
  s PLIST(7)=$P($H,",",2)
  s PLIST(8)=user
  &sql(update DHC_ADMQTREC values PLIST() where QTREC_ROWID=:rowid)
  q SQLCODE
}

/// 自动添加手术事件
ClassMethod QtPatOpDate(Adm As %String) As %String
{
	//w ##class(web.DHCADMQTREC).QtPatOpDate(1806)
	q:Adm="" ""
	//判断是否有"手术排斥"或"手术不排斥"医嘱
	k OpArcim
	s OpArcim("25946||1")="",OpArcim("30139||1")=""
	s oeordId=$o(^OEORD(0,"Adm",Adm,0)) 
    q:oeordId="" ""
    s arcimId=""  f  s arcimId=$O(OpArcim(arcimId)) q:arcimId=""  d
	.s curSttDate="" f  s curSttDate=$O(^OEORDi(0,"ARCIM",oeordId,arcimId,curSttDate)) q:curSttDate=""  d
	..s oeoriSub="" f  s oeoriSub=$O(^OEORDi(0,"ARCIM",oeordId,arcimId,curSttDate,oeoriSub)) q:oeoriSub=""  d
	...s ordStatId=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",13)  //OEORI_ItemStat_DR
    ...s ordStatCode=$p($g(^OEC("OSTAT",+ordStatId)),"^") 
    ...q:ordStatCode'="V"	//非核实退出
    ...q:$D(^TMP("DHCNurInsertOp",oeordId,oeoriSub))>0
    ...s sttDate=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",9)
    ...s sttTime=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",10)
    ...i sttDate'="" s sttDate=$ZD(sttDate,3)
    ...i sttTime'="" s sttTime=$ZT(sttTime)
    ...s user=""
	...s oeoreSub=0 f  s oeoreSub=$o(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub)) q:(oeoreSub="")  d
 	....s execCpcpId=$p($g(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub)),"^",15)	//执行人
 	....i execCpcpId'="" s user=$O(^SSU("SSUSR",0,"CTPCP",execCpcpId,0))
 	...s Typ=3	//事件维护中手术的RowID
	...d ##class(web.DHCADMQTREC).QtInsert(Adm,sttDate,sttTime,Typ,user)
	...s ^TMP("DHCNurInsertOp",oeordId,oeoriSub)=""
	q ""
}

}
