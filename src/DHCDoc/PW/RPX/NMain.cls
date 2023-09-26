/// CTOR: QP
/// DATE: 2021-07-15
/// DESC: 交班本主界面润乾工具类
Class DHCDoc.PW.RPX.NMain Extends DHCDoc.Util.RegisteredObject [ ProcedureBlock ]
{

/// CTOR: QP
/// DATE: 2021-07-20
/// DESC: 查询统计值
/// IN  : 
/// OUT : id,text
/// EXEC: d ##Class(%ResultSet).RunQuery("DHCDoc.PW.RPX.NMain","QryPrintData","4","113","2021-08-30","M")
Query QryPrintData(NID = "", LocId, BCDate, InBCCode) As %Query(ROWSPEC = "mDate,OutHospNum,PreSum,InHospNum,OutWardNum,InWardNum,OperNum,SeverityNum,CritiNum,DeathNum,NowSum,SubmitUser,AcceptUser") [ SqlProc ]
{
}

ClassMethod QryPrintDataExecute(ByRef qHandle As %Binary, NID = "", LocId, BCDate, InBCCode) As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	s ^QP("QryPrintData")=$LB(NID="",LocId, BCDate, InBCCode)
 	s BCDateHtml = BCDate
 	s BCDate = ##class(websys.Conversions).DateHtmlToLogical(BCDate)
 	;s BCDateHtml = ##class(websys.Conversions).DateLogicalToHtml(BCDate)
	i NID="" s NID=##class(DHCDoc.PW.COM.Method).GetNID(LocId,BCDate,InBCCode)
	i (NID="") {
	 	 Set qHandle=$lb(0,repid,0)
		 Quit $$$OK
	}
	s NXML = $lg(^User.DHCDocPassWorkNMainD(NID),7) 
	s BCName = $lg(^User.DHCDocPassWorkNMainD(NID),10) 
	s SubmitUser = $lg(^User.DHCDocPassWorkNMainD(NID),6) 
	s AcceptUser = $lg(^User.DHCDocPassWorkNMainD(NID),17) 
	i SubmitUser'="" s SubmitUser=$P(^SSU("SSUSR",SubmitUser),"^",2)
	i AcceptUser'="" s AcceptUser=$P(^SSU("SSUSR",AcceptUser),"^",2)
	s SubmitUser="交班人："_SubmitUser
	s AcceptUser="接班人："_AcceptUser
	s mDate=BCDateHtml_" "_BCName_"交班明细"
	d ##class(DHCDoc.PW.COM.Method).ParseXML(NXML,.XMList)
	s elements=##class(DHCDoc.PW.CFG.BCPatType).GetActiveTypeStr("",LocId)
	s (OutHospNum,PreSum,InHospNum,OutWardNum,InWardNum,OperNum,SeverityNum,CritiNum,DeathNum,NowSum)=""
	s Len = $l(elements,"^")
	f i=1:1:Len  {
		s record=$p(elements,"^",i)
		s cName=$p(record,":",1)
		s cDesc=$p(record,":",2)
		s cValue=0
		i $d(XMList(cName)) s cValue=XMList(cName)
		s cContent=cDesc_": "_cValue
		i cName="OutHospNum" s OutHospNum=cContent
		i cName="PreSum" s PreSum=cContent
		i cName="InHospNum" s InHospNum=cContent
		i cName="OutWardNum" s OutWardNum=cContent
		i cName="InWardNum" s InWardNum=cContent
		i cName="OperNum" s OperNum=cContent
		i cName="SeverityNum" s SeverityNum=cContent
		i cName="CritiNum" s CritiNum=cContent
		i cName="DeathNum" s DeathNum=cContent
		i cName="NowSum" s NowSum=cContent
	}
	d OutwardRow
	
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutwardRow
	set Data=$lb(mDate,OutHospNum,PreSum,InHospNum,OutWardNum,InWardNum,OperNum,SeverityNum,CritiNum,DeathNum,NowSum,SubmitUser,AcceptUser)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod QryPrintDataFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryPrintDataExecute ]
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

ClassMethod QryPrintDataClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryPrintDataExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// CTOR: QP
/// DATE: 2021-07-20
/// DESC: 查询科室班次情况
/// IN  : 
/// OUT : id,text
/// EXEC: d ##Class(%ResultSet).RunQuery("DHCDoc.PW.RPX.NMain","QryLocBC","8","113","2021-07-16","D")
Query QryLocBC(LocId, BCDate) As %Query(ROWSPEC = "mDate,OutHospNum,PreSum,InHospNum,OutWardNum,InWardNum,OperNum,SeverityNum,CritiNum,DeathNum,NowSum,SubmitUser,AcceptUser") [ SqlProc ]
{
}

ClassMethod QryLocBCExecute(ByRef qHandle As %Binary, LocId, BCDate) As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	s ^QP("QryLocBC")=$LB(NID="",LocId, BCDate, InBCCode)
 	s BCDateHtml = BCDate
 	s BCDate = ##class(websys.Conversions).DateHtmlToLogical(BCDate)
 	;s BCDateHtml = ##class(websys.Conversions).DateLogicalToHtml(BCDate)
	i NID="" s NID=##class(DHCDoc.PW.COM.Method).GetNID(LocId,BCDate,InBCCode)
	i (NID="") {
	 	 Set qHandle=$lb(0,repid,0)
		 Quit $$$OK
	}
	s NXML = $lg(^User.DHCDocPassWorkNMainD(NID),7) 
	s BCName = $lg(^User.DHCDocPassWorkNMainD(NID),10) 
	s SubmitUser = $lg(^User.DHCDocPassWorkNMainD(NID),6) 
	s AcceptUser = $lg(^User.DHCDocPassWorkNMainD(NID),17) 
	i SubmitUser'="" s SubmitUser=$P(^SSU("SSUSR",SubmitUser),"^",2)
	i AcceptUser'="" s AcceptUser=$P(^SSU("SSUSR",AcceptUser),"^",2)
	s SubmitUser="交班人："_SubmitUser
	s AcceptUser="接班人："_AcceptUser
	s mDate=BCDateHtml_" "_BCName_"交班明细"
	d ##class(DHCDoc.PW.COM.Method).ParseXML(NXML,.XMList)
	s elements=##class(DHCDoc.PW.CFG.BCPatType).GetActiveTypeStr("",LocId)
	s (OutHospNum,PreSum,InHospNum,OutWardNum,InWardNum,OperNum,SeverityNum,CritiNum,DeathNum,NowSum)=""
	s Len = $l(elements,"^")
	f i=1:1:Len  {
		s record=$p(elements,"^",i)
		s cName=$p(record,":",1)
		s cDesc=$p(record,":",2)
		s cValue=0
		i $d(XMList(cName)) s cValue=XMList(cName)
		s cContent=cDesc_": "_cValue
		i cName="OutHospNum" s OutHospNum=cContent
		i cName="PreSum" s PreSum=cContent
		i cName="InHospNum" s InHospNum=cContent
		i cName="OutWardNum" s OutWardNum=cContent
		i cName="InWardNum" s InWardNum=cContent
		i cName="OperNum" s OperNum=cContent
		i cName="SeverityNum" s SeverityNum=cContent
		i cName="CritiNum" s CritiNum=cContent
		i cName="DeathNum" s DeathNum=cContent
		i cName="NowSum" s NowSum=cContent
	}
	d OutwardRow
	
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutwardRow
	set Data=$lb(mDate,OutHospNum,PreSum,InHospNum,OutWardNum,InWardNum,OperNum,SeverityNum,CritiNum,DeathNum,NowSum,SubmitUser,AcceptUser)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod QryLocBCFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryLocBCExecute ]
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

ClassMethod QryLocBCClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryLocBCExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// CTOR: QP
/// DATE: 2021-09-07
/// DESC: 根据类型得到加载的模板
/// IN  : 
/// OUT : 
/// EXEC: w ##class(DHCDoc.PW.RPX.NMain).GetTPLName(113,"")
ClassMethod GetRpxName(LocID, PType)
{
	s mRtn=""
	s MID=##class(DHCDoc.PW.COM.Method).GetMIDByLoc(LocID)
	i PType="" s PType="ALL"
	s SUB=$O(^User.DHCDocPassWorkBCPatTypeI("BPCode",PType,MID,""))
	s URL=$lg(^User.DHCDocPassWorkBCMainD(MID,"ChildPatType",SUB),7)
	Q:URL="" mRtn
	s ID=$O(^User.DHCDocPassWorkBCTplI("TPLURL",URL,MID,""))
	Q:ID="" mRtn
	s mRtn=$lg(^User.DHCDocPassWorkBCMainD(MID,"ChildTPL",ID),5)
	
	Q mRtn
}

/// CTOR: QP
/// DESC: RPX日报表表头
/// IN  : 
/// OUT : id,text
/// EXEC: d ##Class(%ResultSet).RunQuery("DHCDoc.PW.RPX.NMain","Title")
Query Title(InMID = "") As %Query(ROWSPEC = "locdesc,item1,item2,item3,item4,item5,item6,item7,item8,item9,item10,item11,item12,item13,item14,item15,item16") [ SqlProc ]
{
}

ClassMethod TitleExecute(ByRef qHandle As %Binary, InMID = "") As %Status
{
    Set repid=$I(^CacheTemp)
    s ind=1
    i (InMID="") {
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK 
	}
	k TList
	d ..GetDayColumns(InMID,.TList)
	s locdesc="科室"
	s (item1,item2,item3,item4)="NO"
	s (item5,item6,item7,item8)="NO"
	s (item9,item10,item11,item12)="NO"
	s (item13,item14,item15,item16)="NO"
	
	i $d(TList(1)) s item1=$lg(TList(1),3)_"("_$lg(TList(1),4)_"~"_$lg(TList(1),5)_")"
	i $d(TList(2)) s item2=$lg(TList(2),3)_"("_$lg(TList(2),4)_"~"_$lg(TList(2),5)_")"
	i $d(TList(3)) s item3=$lg(TList(3),3)_"("_$lg(TList(3),4)_"~"_$lg(TList(3),5)_")"
	i $d(TList(4)) s item4=$lg(TList(4),3)_"("_$lg(TList(4),4)_"~"_$lg(TList(4),5)_")"
	
	i $d(TList(5)) s item1=$lg(TList(5),3)_"("_$lg(TList(5),4)_"~"_$lg(TList(5),5)_")"
	i $d(TList(6)) s item2=$lg(TList(6),3)_"("_$lg(TList(6),4)_"~"_$lg(TList(6),5)_")"
	i $d(TList(7)) s item3=$lg(TList(7),3)_"("_$lg(TList(7),4)_"~"_$lg(TList(7),5)_")"
	i $d(TList(8)) s item4=$lg(TList(8),3)_"("_$lg(TList(8),4)_"~"_$lg(TList(8),5)_")"
	
	i $d(TList(9)) s item1=$lg(TList(9),3)_"("_$lg(TList(9),4)_"~"_$lg(TList(9),5)_")"
	i $d(TList(10)) s item2=$lg(TList(10),3)_"("_$lg(TList(10),4)_"~"_$lg(TList(10),5)_")"
	i $d(TList(11)) s item3=$lg(TList(11),3)_"("_$lg(TList(11),4)_"~"_$lg(TList(11),5)_")"
	i $d(TList(12)) s item4=$lg(TList(12),3)_"("_$lg(TList(12),4)_"~"_$lg(TList(12),5)_")"
	
	i $d(TList(13)) s item1=$lg(TList(13),3)_"("_$lg(TList(13),4)_"~"_$lg(TList(13),5)_")"
	i $d(TList(14)) s item2=$lg(TList(14),3)_"("_$lg(TList(14),4)_"~"_$lg(TList(14),5)_")"
	i $d(TList(15)) s item3=$lg(TList(15),3)_"("_$lg(TList(15),4)_"~"_$lg(TList(15),5)_")"
	i $d(TList(16)) s item4=$lg(TList(16),3)_"("_$lg(TList(16),4)_"~"_$lg(TList(16),5)_")"
	
    d output8
    
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
output8
    set Data=$lb(locdesc,item1,item2,item3,item4,item5,item6,item7,item8,item9,item10,item11,item12,item13,item14,item15,item16)
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1   
    quit
}

ClassMethod TitleClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = TitleExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod TitleFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = TitleExecute ]
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

/// CTOR: QP
/// DESC: 日报表
/// IN  : 
/// OUT : id,text
/// EXEC: d ##Class(%ResultSet).RunQuery("DHCDoc.PW.RPX.NMain","DayQry","","2021-12-26",2,"1")
Query DayQry(InLocId = "", InBCDate = "", InHosp = "", InMID = "", IsRpx = "") As %Query(ROWSPEC = "locdesc,item1,item2,item3,item4,item5,item6,item7,item8,item9,item10,item11,item12,item13,item14,item15,item16") [ SqlProc ]
{
}

ClassMethod DayQryExecute(ByRef qHandle As %Binary, InLocId = "", InBCDate = "", InHosp = "", InMID = "", IsRpx = "") As %Status
{
    Set repid=$I(^CacheTemp)
    s ind=1
    S ^temp("wnx")=$lb(InLocId,InBCDate,InHosp,InMID)
    i (InBCDate="")||(InMID="") {
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK 
	}
	K TList,LOCList
	d ..GetDayColumns(InMID,.TList)
	d ..GetBCOtherLoc(InMID,.LOCList)
	s langid=..%LanguageID()
	s valOK="已交班",valNO="未交班"
	s valOK=##class(websys.Translation).Get("dhcdoc.passwork.rpx.day.csp",valOK)
	s valNO=##class(websys.Translation).Get("dhcdoc.passwork.rpx.day.csp",valNO)
	if (IsRpx=1) {
		
	} else {
		s valOK="<span class='c-ok'>"_valOK_"</span>"
		s valNO="<span class='c-no'>"_valNO_"</span>"
	}
	s (locdesc,item1,item2,item3,item4)=valNO
	s (item5,item6,item7,item8)=valNO
	s (item9,item10,item11,item12)=valNO
	s (item13,item14,item15,item16)=valNO
	
 	s InBCDate = ##class(websys.Conversions).DateHtmlToLogical(InBCDate)
 	s locid=""
    f  s locid=$o(^CTLOC(locid))  q:locid=""  d
    .q:(InLocId'="")&&(InLocId'=locid)
   	.s (item1,item2,item3,item4)=valNO
	.s (item5,item6,item7,item8)=valNO
	.s (item9,item10,item11,item12)=valNO
	.s (item13,item14,item15,item16)=valNO
	.q:(LOCList("type")="L")&&('$D(LOCList(locid)))
	.q:(LOCList("type")="C")&&($D(LOCList(locid)))
    .s locdesc=$p(^CTLOC(locid),"^",2)
    .s hospid=$p(^CTLOC(locid),"^",22)
    .q:(InHosp'="")&&(hospid'=InHosp)
    .i locdesc["-"  s locdesc=$p(locdesc,"-",2)
    .s type=$p(^CTLOC(locid),"^",13)
    .s code=$p(^CTLOC(locid),"^",43)
    .s dateFrom=$p(^CTLOC(locid),"^",24)
    .s dateTo=$p(^CTLOC(locid),"^",25)
    .q:(dateFrom'="")&&(dateFrom>+$h)
    .q:(dateTo'="")&&(dateTo<+$h)
    .s code=$zcvt(code,"U")
    .s locType=##class(DHCDoc.PW.COM.Method).GetDepType(locid)
    .q:(locType'="I")
    .q:(type'="E")&&(type'="EM")
	.i $d(TList(1)) d
	..i $d(^User.DHCDocPassWorkNMainI("MLocMBCDateCode",locid,InBCDate,$lg(TList(1),2))) s item1=valOK
	.i $d(TList(2)) d
	..i $d(^User.DHCDocPassWorkNMainI("MLocMBCDateCode",locid,InBCDate,$lg(TList(2),2))) s item2=valOK
	.i $d(TList(3)) d
	..i $d(^User.DHCDocPassWorkNMainI("MLocMBCDateCode",locid,InBCDate,$lg(TList(3),2))) s item3=valOK
	.i $d(TList(4)) d
	..i $d(^User.DHCDocPassWorkNMainI("MLocMBCDateCode",locid,InBCDate,$lg(TList(4),2))) s item4=valOK
	.i $d(TList(5)) d
	..i $d(^User.DHCDocPassWorkNMainI("MLocMBCDateCode",locid,InBCDate,$lg(TList(5),2))) s item5=valOK
	.i $d(TList(6)) d
	..i $d(^User.DHCDocPassWorkNMainI("MLocMBCDateCode",locid,InBCDate,$lg(TList(6),2))) s item6=valOK
	.i $d(TList(7)) d
	..i $d(^User.DHCDocPassWorkNMainI("MLocMBCDateCode",locid,InBCDate,$lg(TList(7),2))) s item7=valOK
	.i $d(TList(8)) d
	..i $d(^User.DHCDocPassWorkNMainI("MLocMBCDateCode",locid,InBCDate,$lg(TList(8),2))) s item8=valOK
	.i $d(TList(9)) d
	..i $d(^User.DHCDocPassWorkNMainI("MLocMBCDateCode",locid,InBCDate,$lg(TList(9),2))) s item9=valOK
	.i $d(TList(10)) d
	..i $d(^User.DHCDocPassWorkNMainI("MLocMBCDateCode",locid,InBCDate,$lg(TList(10),2))) s item10=valOK
	.i $d(TList(11)) d
	..i $d(^User.DHCDocPassWorkNMainI("MLocMBCDateCode",locid,InBCDate,$lg(TList(11),2))) s item11=valOK
	.i $d(TList(12)) d
	..i $d(^User.DHCDocPassWorkNMainI("MLocMBCDateCode",locid,InBCDate,$lg(TList(12),2))) s item12=valOK
	.i $d(TList(13)) d
	..i $d(^User.DHCDocPassWorkNMainI("MLocMBCDateCode",locid,InBCDate,$lg(TList(13),2))) s item13=valOK
	.i $d(TList(14)) d
	..i $d(^User.DHCDocPassWorkNMainI("MLocMBCDateCode",locid,InBCDate,$lg(TList(14),2))) s item14=valOK
	.i $d(TList(15)) d
	..i $d(^User.DHCDocPassWorkNMainI("MLocMBCDateCode",locid,InBCDate,$lg(TList(15),2))) s item15=valOK
	.i $d(TList(16)) d
	..i $d(^User.DHCDocPassWorkNMainI("MLocMBCDateCode",locid,InBCDate,$lg(TList(16),2))) s item16=valOK
	.d output7
    
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
output7
	s locdesc= ##class(User.CTLoc).GetTranByDesc("CTLOCDesc",locdesc,langid)
    set Data=$lb(locdesc,item1,item2,item3,item4,item5,item6,item7,item8,item9,item10,item11,item12,item13,item14,item15,item16)
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1   
    quit
}

ClassMethod DayQryClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = DayQryExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod DayQryFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = DayQryExecute ]
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

/// CTOR: QP
/// DATE: 2020-12-23
/// DESC: 得到日报表列
/// IN  : 
/// OUT :
/// TABL: 
/// EXEC: w ##class(DHCDoc.PW.RPX.NMain).GetDayColumns(1)
ClassMethod GetDayColumns(InMID, ByRef TList)
{
	s mRtn="[{""field"":""locdesc"",""title"":""科室"",""width"":170}"
	s formatter = "function(value,row,index){"
    s formatter = formatter_"if (value == '已交班') {"
    s formatter = formatter_	"return ""<span class='c-ok'>已交班</span>"""
    s formatter = formatter_"} else {"
    s formatter = formatter_"return ""<span class='c-no'>未交班</span>"""
    s formatter = formatter_"}"
    s formatter = formatter_"}"
    s langid=..%LanguageID() 
	s seqno="",num=0
    f  s seqno=$o(^User.DHCDocPassWorkBCTimeI("BCSeqno",seqno)) q:seqno=""  d
    .s bcid=$o(^User.DHCDocPassWorkBCTimeI("BCSeqno",seqno,InMID,""))
    .q:bcid=""
    .s code=$lg(^User.DHCDocPassWorkBCMainD(InMID,"ChildTime",bcid),2)
	.s name=$lg(^User.DHCDocPassWorkBCMainD(InMID,"ChildTime",bcid),3)
	.s name= ##class(User.DHCDocPassWorkBCTime).GetTranByDesc("BCName",name,langid)
	.s sTime=$lg(^User.DHCDocPassWorkBCMainD(InMID,"ChildTime",bcid),4)
	.s eTime=$lg(^User.DHCDocPassWorkBCMainD(InMID,"ChildTime",bcid),5)
	.s active=$lg(^User.DHCDocPassWorkBCMainD(InMID,"ChildTime",bcid),8)
	.q:active'=1
	.i sTime'="" s sTime=$zt(sTime,2)
	.i eTime'="" s eTime=$zt(eTime,2)
	.s num=num+1
	.s TList(num)=$lb(bcid,code,name,sTime,eTime)
	.s colName="item"_num
	.s colTitle=name_"("_sTime_" ~ "_eTime_")"
	.;s record="{""field"":"""_colName_""",""title"":"""_colTitle_""",""width"":250,""formatter"":"_formatter_"}"
	.s record="{""field"":"""_colName_""",""title"":"""_colTitle_""",""width"":250}"
	.s mRtn=mRtn_","_record
	s mRtn=mRtn_"]"
	q mRtn
}

/// CTOR: QP
/// DATE: 2021-12-27
/// DESC: 获取页面静态属性值
/// IN  : 
/// OUT :
/// TABL: 
/// EXEC: w ##class(DHCDoc.PW.RPX.NMain).GetPageGloabl(2)
ClassMethod GetPageGloabl(InHosp = "")
{
	s dynObj={
		"DefaultDate":"",
		"DefaultType":""
	}
	Q:InHosp="" dynObj.%ToJSON()
	s CDate=+$H,CTime=$p($H,",",2)
	s DefaultDate=##class(websys.Conversions).DateLogicalToHtml(CDate)
	s DefaultType=$o(^User.DHCDocPassWorkBCMainI("BMHospType",InHosp,"C",""))
	do dynObj.%Set("DefaultDate",DefaultDate)
	do dynObj.%Set("DefaultType",DefaultType)
	
	Q dynObj.%ToJSON()
}

/// CTOR: QP
/// DATE: 2021-12-27
/// DESC: 获取关联科室
/// IN  : 
/// OUT :
/// TABL: 
/// EXEC: w ##class(DHCDoc.PW.RPX.NMain).GetBCOtherLoc(2)
ClassMethod GetBCOtherLoc(InMID = "", ByRef TMPList)
{
	s type=$lg(^User.DHCDocPassWorkBCMainD(InMID),3)
	s hosp=$lg(^User.DHCDocPassWorkBCMainD(InMID),2)
	s TMPList("type")=type
	i type="L" {
		s sub=""
		f  s sub=$o(^User.DHCDocPassWorkBCMainD(InMID,"ChildLoc",sub)) Q:sub=""  d
		.s locid=$lg(^User.DHCDocPassWorkBCMainD(InMID,"ChildLoc",sub),2)
		.q:locid=""
		.s TMPList(locid)=""
	} else {
		s MID=""
		f  s MID=$O(^User.DHCDocPassWorkBCMainI("BMHospType",hosp,"L",MID)) Q:MID=""  D
		.s sub=""
		.s active=$lg(^User.DHCDocPassWorkBCMainD(MID),5)
		.q:active'=1
		.f  s sub=$o(^User.DHCDocPassWorkBCMainD(MID,"ChildLoc",sub)) Q:sub=""  d
		..s locid=$lg(^User.DHCDocPassWorkBCMainD(MID,"ChildLoc",sub),2)
		..q:locid=""
		..s TMPList(locid)=""
	}
	Q ""
}

}
