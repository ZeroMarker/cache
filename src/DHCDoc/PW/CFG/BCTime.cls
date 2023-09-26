/// CTOR: QP
/// DATE: 2021-07-08
/// DESC: 医生站交班本班次操作类
Class DHCDoc.PW.CFG.BCTime Extends DHCDoc.Util.RegisteredObject [ ProcedureBlock ]
{

/// CTOR: QP
/// DATE: 2021-07-08
/// DESC: 保存/更新交班本班次信息
/// IN  : 
/// OUT : 
/// TABL: 
/// EXEC: w ##class(DHCDoc.PW.CFG.BCTime).Save("","1^PreSum^12^1^21^12^12")
ClassMethod Save(ID = "", inPara = "") As %String
{
	s ^QP("TH",1)=$LB(ID,inPara)
	s MID =			$P(inPara,"^",1)
	s code = 		$P(inPara,"^",2)	//$zcvt($p(inPara,"^",2),"U")
	s name = 		$p(inPara,"^",3)
	s stime = 		$p(inPara,"^",4)
	s etime = 		$p(inPara,"^",5)
	s nextday = 	$p(inPara,"^",6)
	s active = 		$p(inPara,"^",7)
	s note = 		$p(inPara,"^",8)
	s seqno = 		$p(inPara,"^",9)
	i stime'="" s stime = ..%ZTH(stime,2)
	i etime'="" s etime = ..%ZTH(etime,2)
	
	Q:MID="" "-1^父表ID为空！"
	Q:code="" "-1^代码为空！"
	Q:name="" "-1^描述为空！"
	s HasFlag=..IsAdd(ID,inPara)
	Q:+HasFlag<0 HasFlag
	i ID = "" s SaveOBJ = ##class(User.DHCDocPassWorkBCTime).%New(MID)
	e  s SaveOBJ = ##class(User.DHCDocPassWorkBCTime).%OpenId(ID)
	d SaveOBJ.BCParRefSetObjectId(MID)
	s SaveOBJ.BCActive=active
	s SaveOBJ.BCCode=code
	s SaveOBJ.BCETime=etime
	s SaveOBJ.BCIsNextDay=nextday
	s SaveOBJ.BCName=name
	s SaveOBJ.BCNote=note
	s SaveOBJ.BCSeqno=seqno
	s SaveOBJ.BCSTime=stime
	s sc = SaveOBJ.%Save()
	If $$$ISERR(sc) {
		//d $system.OBJ.DisplayError(sc) 
		Quit "-1^保存班次信息失败！"
	}
		
	q 1_"^"
}

/// CTOR: QP
/// DATE: 2021-07-08
/// DESC: 判断能否添加
/// IN  : 
/// OUT : 
/// TABL: 
/// EXEC: w ##class(DHCDoc.PW.CFG.BCTime).Save("","1^1")
ClassMethod IsAdd(ID = "", inPara = "") As %String
{
	s MID=$P(inPara,"^",1)
	s code=$P(inPara,"^",2)
	//s codeUP=$$ALPHAUP^SSUTIL4(code)    
	i ID="" {
		i $d(^User.DHCDocPassWorkBCTimeI("BCCode",code,MID)) {
			Q "-1^配置已存在！"
		}
	} else {
		s sub=$p(ID,"||",2)
		s oldCode=$lg(^User.DHCDocPassWorkBCMainD(MID,"ChildTime",sub),2)
		i $d(^User.DHCDocPassWorkBCTimeI("BCCode",code,MID)) {
			i oldCode'=code {
				Q "-1^配置已存在！"
			}
		}
	}
	
	Q 0
}

/// CTOR: QP
/// DATE: 2021-07-13
/// DESC: 根据代码获取班次信息
/// IN  : 
/// OUT : 
/// TABL: 
/// EXEC: w ##class(DHCDoc.PW.CFG.BCTime).GetBCInfoByCode("113","D")
ClassMethod GetBCInfoByCode(LocID, Code) As %String
{
	s mRtn=""
	//s codeUP=$$ALPHAUP^SSUTIL4(Code) 
	s MID=##class(DHCDoc.PW.COM.Method).GetMIDByLoc(LocID)
	Q:MID="" mRtn
	s ID=$O(^User.DHCDocPassWorkBCTimeI("BCCode",Code,MID,""))
	Q:ID="" mRtn
	s mRtn=^User.DHCDocPassWorkBCMainD(MID,"ChildTime",ID)
	Q mRtn
}

/// CTOR: QP
/// DATE: 2021-07-08
/// DESC: 查询类型
/// IN  : 
/// OUT : 
/// EXEC: d ##class(%ResultSet).RunQuery("DHCDoc.PW.CFG.BCTime","QryBCTime",1)
Query QryBCTime(InMID = "") As %Library.Query(ROWSPEC = "rowid,code,name,sTime,eTime,nextDay,note,active,seqno")
{
}

ClassMethod QryBCTimeExecute(ByRef qHandle As %Library.Binary, InMID = "") As %Library.Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	if (InMID="") {
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	s sub=""
	f  s sub=$o(^User.DHCDocPassWorkBCMainD(InMID,"ChildTime",sub)) Q:sub=""  d
	.s code=$lg(^User.DHCDocPassWorkBCMainD(InMID,"ChildTime",sub),2)
	.s name=$lg(^User.DHCDocPassWorkBCMainD(InMID,"ChildTime",sub),3)
	.s sTime=$lg(^User.DHCDocPassWorkBCMainD(InMID,"ChildTime",sub),4)
	.s eTime=$lg(^User.DHCDocPassWorkBCMainD(InMID,"ChildTime",sub),5)
	.i sTime'="" s sTime=..%ZT(sTime,2)
	.i eTime'="" s eTime=..%ZT(eTime,2)
	.s nextDay=$lg(^User.DHCDocPassWorkBCMainD(InMID,"ChildTime",sub),6)
	.s note=$lg(^User.DHCDocPassWorkBCMainD(InMID,"ChildTime",sub),7)
	.s active=$lg(^User.DHCDocPassWorkBCMainD(InMID,"ChildTime",sub),8)
	.s seqno=$lg(^User.DHCDocPassWorkBCMainD(InMID,"ChildTime",sub),9)
	.s rowid=InMID_"||"_sub
	.d OuputRow1
	
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OuputRow1
	set Data=$lb(rowid,code,name,sTime,eTime,nextDay,note,active,seqno)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
}

ClassMethod QryBCTimeFetch(ByRef qHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = QryBCTimeExecute ]
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

ClassMethod QryBCTimeClose(qHandle As %Library.Binary) As %Library.Status [ PlaceAfter = QryBCTimeFetch ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

/// CTOR: QP
/// DATE: 2021-07-08
/// DESC: 根据LocID查询类型
/// IN  : 
/// OUT : 
/// EXEC: d ##class(%ResultSet).RunQuery("DHCDoc.PW.CFG.BCTime","QryBCTimeByLocID",113)
Query QryBCTimeByLocID(LocID = "") As %Library.Query(ROWSPEC = "rowid,code,name,sTime,eTime,nextDay,note,active,seqno,bcText")
{
}

ClassMethod QryBCTimeByLocIDExecute(ByRef qHandle As %Library.Binary, LocID = "") As %Library.Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	if (LocID="") {
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	s InMID=##class(DHCDoc.PW.COM.Method).GetMIDByLoc(LocID)
	if (InMID="") {
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	s langid=##class(DHCDoc.PW.COM.Method).%LanguageID()
	s sub=""
	f  s sub=$o(^User.DHCDocPassWorkBCMainD(InMID,"ChildTime",sub)) Q:sub=""  d
	.s code=$lg(^User.DHCDocPassWorkBCMainD(InMID,"ChildTime",sub),2)
	.s name=$lg(^User.DHCDocPassWorkBCMainD(InMID,"ChildTime",sub),3)
	.s sTime=$lg(^User.DHCDocPassWorkBCMainD(InMID,"ChildTime",sub),4)
	.s eTime=$lg(^User.DHCDocPassWorkBCMainD(InMID,"ChildTime",sub),5)
	.i sTime'="" s sTime=..%ZT(sTime,2)
	.i eTime'="" s eTime=..%ZT(eTime,2)
	.s nextDay=$lg(^User.DHCDocPassWorkBCMainD(InMID,"ChildTime",sub),6)
	.s note=$lg(^User.DHCDocPassWorkBCMainD(InMID,"ChildTime",sub),7)
	.s active=$lg(^User.DHCDocPassWorkBCMainD(InMID,"ChildTime",sub),8)
	.q:active'=1
	.s seqno=$lg(^User.DHCDocPassWorkBCMainD(InMID,"ChildTime",sub),9)
	.;s name=##class(websys.Translation).Get("dhcdoc.passwork.nmain.resubmit.csp",name)
	.s name= ##class(User.DHCDocPassWorkBCTime).GetTranByDesc("BCName",name,langid)
	.s bcText=name_"("_sTime_":"_eTime_")"
	.s rowid=InMID_"||"_sub
	.d OuputRow2
	
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OuputRow2
	set Data=$lb(rowid,code,name,sTime,eTime,nextDay,note,active,seqno,bcText)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
}

ClassMethod QryBCTimeByLocIDFetch(ByRef qHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = QryBCTimeByLocIDExecute ]
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

ClassMethod QryBCTimeByLocIDClose(qHandle As %Library.Binary) As %Library.Status [ PlaceAfter = QryBCTimeByLocIDFetch ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

}
