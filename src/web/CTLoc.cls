Include webimport

IncludeGenerator webimport

Class web.CTLoc Extends (%Library.RegisteredObject, websys.Abstract) [ Not Abstract, ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 1135;

Parameter SQLCODE = "CTLOC_Code";

Parameter SQLDATEFROM = "CTLOC_NatCodeDateFrom";

Parameter SQLDESCRIPTION = "CTLOC_Desc";

Parameter SQLDATETO = "CTLOC_NatCodeDateTo";

Parameter SQLFILTER = "((CTLOC_DateActiveFrom <= CURRENT_DATE) AND ((CTLOC_DateActiveTo IS NULL) OR (CTLOC_DateActiveTo >= CURRENT_DATE)))";

Parameter SQLROWID = "CTLOC_RowID";

Property dummy As %String(TRUNCATE = 1);

ClassMethod GetCodeFromDesc(desc As %String = "") As %String
{
	;wanghc
	n zcode
	s zcode=""
	&SQL(SELECT CTLOC_Code INTO :zcode FROM CT_LOC WHERE  CTLOC_DESC = UCASE(:desc))
	q zcode
}

ClassMethod GetIDFromDescAndHospitalID(desc As %String = "", HospID As %String = "") As %String
{
	;wanghc
	n zID
	s zID=""
	&sql(
		SELECT CTLOC_ROWID INTO :zID 
		FROM CT_LOC
		WHERE ( (CTLOC_DESC=UCASE(:desc)) AND ( (CTLOC_Hospital_DR=:HospID)  OR (:HospID IS NULL) ) ) 
	)
	q zID
}

ClassMethod GetIdFromCodeDescriptionHosp(val As %String = "", HospID As %String = "") As %String
{
	n zID
	s zID=""
	&sql(
		SELECT CTLOC_ROWID INTO :zID 
		FROM CT_LOC
		WHERE ( ((CTLOC_Code=UCASE(:val)) OR (CTLOC_DESC=UCASE(:val))) AND ((CTLOC_Hospital_DR=:HospID)  OR (:HospID IS NULL) ) ) 
	)
	q zID
}

ClassMethod GetDepartmentGroup(Loc As %String = "") As %String
{
	n depgroupid
	&SQL(select CTLOC_Dep_DR into :depgroupid from SQLUser.CT_Loc Where CTLOC_RowId=:Loc)
	if SQLCOCDE=0 q depgroupid
	Q ""
}

ClassMethod GetDeptFromRowID(LocID As %String = "") As %String
{
	quit:LocID="" ""
	;wanghc
	n objLoc
	set objLoc=##class(User.CTLoc).%OpenId(LocID)
	quit:'$IsObject(objLoc) ""
	q:$IsObject(objLoc.CTLOCDepDR) objLoc.CTLOCDepDR.DEPDesc
}

/// by wuqk 2011-06-02
ClassMethod GetDescFromRowId(LocID As %String = "") As %String
{
	quit:LocID="" ""
	quit:'$d(^CTLOC(LocID)) ""
	quit $p(^CTLOC(LocID),"^",2)
}

/// externalInfoSystem
ClassMethod GetExtFromLocId(LocID As %String = "") As %String
{
	quit:LocID="" ""
	;wanghc
	set objLoc=##class(User.CTLoc).%OpenId(LocID)
	quit:'$IsObject(objLoc) ""
	q objLoc.CTLOCExternalInfoSystem
}

/// KM 16-Jan-2002: Called from epr.floorplan.csp
ClassMethod GetFloorplanLayout(LocID As %String = "") As %String
{
}

/// input locid 
/// return hospital desc
ClassMethod GetHospital(Loc As %String = "") As %String
{
	;wanghc
	n objLoc
	set objLoc=##class(User.CTLoc).%OpenId(Loc)
	quit:$IsObject(objLoc) objLoc.CTLOCHospitalDRGetObjectId()	
	;q:$IsObject(objLoc.CTLOCHospitalDR) objLoc.CTLOCHospitalDR.HOSPDesc
	Q ""
}

/// by wuqk 2011-06-02
ClassMethod GetLogonHosp(locID As %String = "") As %String
{
	quit:locID="" ""
	Quit $p(^CTLOC(locID),"^",22)
	;quit:hospId="" ""
	;quit ##class(web.CTHospital).GetDescFromRowId(hospId)
}

/// Log59264 TedT 06/2006
/// zhouzq 2011.08.12
ClassMethod GetRequestLoc() As %String
{
	n LocID,objLoc
	;前面应该有一段取%request中LocID的处理,目前还不清楚下标名
	s LocID=%Session.Data("LOGON.CTLOCID")
	s objLoc=##class(User.CTLoc).%OpenId(LocID)
	Q:$IsObject(objLoc) objLoc.CTLOCDesc
	Q ""
}

/// zhouzq 2011.08.12
ClassMethod GetDefaultLoc() As %String
{
	n LocID,objLoc
	s LocID=%Session.Data("LOGON.CTLOCID")
	s objLoc=##class(User.CTLoc).%OpenId(LocID)
	Q:$IsObject(objLoc) objLoc.CTLOCDesc
	Q ""
}

ClassMethod GetTelFromLocId(LocID As %String = "") As %String
{
	;wanghc
	set objLoc=##class(User.CTLoc).%OpenId(LocID)
	quit:'$IsObject(objLoc) ""	
	q objLoc.CTLOCTelephone
}

ClassMethod GetSNAPFlag(Loc As %String = "", flag1 As %String = "") As %String
{
	set objLoc=##class(User.CTLoc).%OpenId(Loc)
	quit:'$IsObject(objLoc) ""	
	q objLoc.CTLOCSNAPFlag
}

/// zhouzq 2012.05.17
/// w ##class(web.CTLoc).IsValidCode("1290021")
ClassMethod IsValidCode(code As %String = "") As %String
{
	Quit:code="" ""
	Quit $O(^CTLOC(0,"Code",$zu(28,code,6),0))
}

/// zhouzq 2012.05.17
/// w ##class(web.CTLoc).IsValidDesc("XGWKJZ-血管外科急诊")
ClassMethod IsValidDesc(desc As %String = "") As %String
{
	Quit:desc="" ""
	Quit $O(^CTLOC(0,"Desc",$zu(28,desc,6),0))
}

/// ab 23.02.04 - 42479 - standard location lookup
/// flags: 
/// cpflag = limit only to locations with care providers attached
/// rbflag = checks SSGroupRBRestrictions and returns resource/service if one is attached
/// dateflag = if you use date to, assumes the date to is blank instead of equal to date from
/// mrflag = limit by CTLOC_MRRequestMoveValid	
/// 
/// by wuqk 2011-05-27 未完成，仅判断了第一个参数
ClassMethod LookUpLocExecute(ByRef QHandle As %Binary, val As %String = "", date As %Date = "", type As %String = "", admtype As %String = "", hosps As %String = "", hospdesc As %String = "", flags As %String = "", dateto As %String = "", depcode As %String = "", resource As %String = "", hca As %String = "", signif As %String = "") As %Status
{
	n repid
	s repid=$I(^CacheTemp)
	s ind=1
	s QHandle=$lb(0,repid,0)
	//^CTLOC(0,"Desc",alphaUp(desc),id)
	set alias=$zu(28,val,6)
	set tmpAlias=alias
	do:tmpAlias'="" GetByAlias
	set tmpAlias=$o(^CTLOC(0,"Desc",alias))
	while (tmpAlias'="")&((tmpAlias[alias)||(alias="")) {
		do GetByAlias
		set tmpAlias=$o(^CTLOC(0,"Desc",tmpAlias))
	}
	quit $$$OK
GetByAlias
	set ctlocId=$o(^CTLOC(0,"Desc",tmpAlias,0))
	while ctlocId'="" {
		
		do BuildLookUpLoc
		set ctlocId=$o(^CTLOC(0,"Desc",tmpAlias,ctlocId))
	}
	quit
BuildLookUpLoc
	set objLoc=##class(User.CTLoc).%OpenId(ctlocId)
	quit:'$IsObject(objLoc)
	//
	/*date
	 type
	 admtype
	 hosps
	 hospdesc
	 flags
	 dateto
	 depcode
	 resource
	 hca
	 signif
	 */
	s hospDr=objLoc.CTLOCHospitalDRGetObjectId()
	q:(hosps'="")&&(hospDr'=hosps)
	set data=$lb()
	
	//BAS-病案室:106:病案室:O:::1*1:::0106:
	//"Description:%String,HIDDEN:%String,
	//Code:%String,HIDDEN(Type):%String,Hospital:%String,
	//HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,
	//HIDDEN(TelephoneExt):%String")
	set $li(data,1)=objLoc.CTLOCDesc
	set $li(data,2)=ctlocId
	set $li(data,3)=objLoc.CTLOCCode
	set $li(data,4)=objLoc.CTLOCType
	set $li(data,5)=$s($IsObject(objLoc.CTLOCHospitalDR):objLoc.CTLOCHospitalDR.HOSPDesc,1:"")
	set $li(data,10)=objLoc.CTLOCTelephoneExt
	set ^CacheTemp(repid,ind)=data
	set ind=ind+1
	quit
}

ClassMethod LookUpLocFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = LookUpLocExecute ]
{
	n repid
	Set AtEnd=$LIST(QHandle,1)
 	Set repid=$LIST(QHandle,2)
 	Set ind=$LIST(QHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s QHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod LookUpLocClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = LookUpLocFetch ]
{
	n repid
	Set repid=$LIST(QHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query LookUpLoc(val As %String, date As %Date, type As %String, admtype As %String, hosps As %String, hospdesc As %String, flags As %String, dateto As %String, depcode As %String, resource As %String, hca As %String, signif As %String) As %Query(CONTAINID = 2, ROWSPEC = "Description:%String,HIDDEN:%String,Code:%String,HIDDEN:%String,Hospital:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String")
{
}

/// ab 23.02.04 - 42479 - standard location lookup broker
/// by wuqk 2011-06-23
ClassMethod LookUpLocBroker(itmjs As %String = "", itmjsex As %String = "", val As %String = "", date As %Date = "", type As %String = "", admtype As %String = "", hosps As %String = "", hospdesc As %String = "", flags As %String = "", dateto As %String = "", depcode As %String = "", resource As %String = "", hca As %String = "", signif As %String = "")
{
	set rs=##Class(%ResultSet).%New("web.CTLoc.LookUpLoc")
	quit:'$IsObject(rs) 0
	do rs.Execute(val, date, type, admtype, hosps, hospdesc, flags, dateto, depcode, resource, hca, signif)
	set cols=rs.GetColumnCount()
	set rows=0
	set retval=""
	while rs.Next() {
		set rows=rows+1
		quit:rows>1
		set firstVal=rs.GetData(1)
		for colIndex=1:1:cols{
			set retval=retval_rs.GetData(colIndex)_"^"
		}
	}
 	d rs.%Close() k rs
 	quit:rows'=1 0
 	set:itmjs'="" fn=itmjs_"('"_firstVal_"');"
 	set:itmjsex'="" fn=fn_itmjsex_"('"_retval_"');"
	&javascript<#(fn)#>
 	quit $$$OK
}

ClassMethod LookUpBrokerReceiving(itmjs As %String = "", itmjsex As %String = "", ARCIMDesc As %String = "", EpisodeID As %String = "", Location As %String = "") As %Boolean
{
}

ClassMethod LookUpBrokerMRLocValid(itmjs As %Library.String = "", itmjsex As %Library.String = "", locDesc As %Library.String = "", HospitalDR As %Library.String = "") As %Library.Boolean
{
}

Query FindMRLocationValid(LocDesc As %String, HospitalDR As %String) As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "CTLOCDesc:%String,HIDDEN:%String,CTLOCCode:%String,HIDDEN:%String,HIDDEN:%String")
{
SELECT CTLOC_Desc,CTLOC_Telephone,CTLOC_Code,CTLOC_RowID,CTLOC_TelephoneExt
FROM SQLUser.CT_Loc
WHERE ((CTLOC_Desc %STARTSWITH :LocDesc) AND ((CTLOC_TYPE='W') OR (CTLOC_TYPE='EM') OR (CTLOC_TYPE='DS') OR (CTLOC_TYPE='MR') OR (CTLOC_TYPE='OR') OR (CTLOC_TYPE='E') OR (CTLOC_TYPE='O')) AND ((CTLOC_Hospital_DR=:HospitalDR) OR (:HospitalDR IS NULL)))
AND ((CTLOC_DateActiveFrom IS NULL) OR (Current_Date>=CTLOC_DateActiveFrom))
AND ((CTLOC_DateActiveTo IS NULL) OR (Current_Date<=CTLOC_DateActiveTo))
AND CTLOC_RowID IN (SELECT TYP_CTLOC_DR 
FROM SQLUser.RTC_MRecordType)
ORDER BY CTLOC_Code
}

ClassMethod LookUpBrokerRestrType(itmjs As %Library.String = "", itmjsex As %Library.String = "", locDesc As %Library.String = "", locType As %Library.String = "", date As %String = "") As %Library.Boolean
{
}

ClassMethod LookUpReceivingClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = LookUpReceivingFetch ]
{
}

ClassMethod LookUpReceivingExecute(ByRef QHandle As %Library.Binary, arcim As %String = "", episID As %String = "", locdesc As %String = "", catDesc As %Library.String = "", itemDesc As %Library.String = "") As %Library.Status
{
}

ClassMethod LookUpReceivingFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = LookUpReceivingExecute ]
{
}

Query LookUpReceiving(arcim As %String, episID As %String, locdesc As %String, catDesc As %String, itemDesc) As %Query(CONTAINID = 0, ROWSPEC = "CTLOCDesc:%String,Code:%String,HIDDEN:%String,HIDDEN:%String")
{
}

ClassMethod LookUpRestrTypeClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = LookUpRestrTypeFetch ]
{
	Set repid=$LIST(QHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

// d ##class(%ResultSet).RunQuery("web.CTLoc:LookUpRestrType","","","")

ClassMethod LookUpRestrTypeExecute(ByRef QHandle As %Library.Binary, Desc As %String, locType As %Library.String, tdate As %String = "") As %Library.Status
{
	s ^TEMP("LookUpRestrType")=Desc_","_locType_","_tdate
	s (VisitFr,VisitTo,RestFr,RestTo,VisitRange)=""
	s Desc=$$ALPHAUP^SSUTIL4(Desc)
	s repid=$I(^CacheTemp)
	s ind=1
	s QHandle=$lb(0,repid,0)
	//s locRowid=$o(^CTLOC(0,"Desc",Desc,""))
	s locRowid=0
	f  s locRowid=$o(^CTLOC(locRowid)) q:locRowid=""  d
	.s CTLOCDesc=$p(^CTLOC(locRowid),"^",2)
	.q:$Find(CTLOCDesc,Desc)'=($l(Desc)+1)
	.//q:locType'[CTLocType
	.s CTLocType=$p(^CTLOC(locRowid),"^",13)
	.s CTLOCCode=$p(^CTLOC(locRowid),"^",1)
	.s dateFrom=$p(^CTLOC(locRowid),"^",24)
	.s dateTo=$p(^CTLOC(locRowid),"^",25)
	.q:((dateFrom'="")&&(dateFrom>+$h))!((dateTo'="")&&(dateTo<+$h))
	.s Data=$lb(CTLOCDesc,"",CTLOCCode,"",VisitFr,VisitTo,RestFr,RestTo,VisitRange,"")
	.s ^CacheTemp(repid,ind)=Data
	.s ind=ind+1
	Set QHandle=$lb(0,repid,0)
	Quit $$$OK
}

ClassMethod LookUpRestrTypeFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = LookUpRestrTypeExecute ]
{
	Set AtEnd=$LIST(QHandle,1)
 	Set repid=$LIST(QHandle,2)
 	Set ind=$LIST(QHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s QHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

Query LookUpRestrType(Desc As %String, locType As %String, date As %String) As %Library.Query(CONTAINID = 0, ROWSPEC = "CTLOCDesc:%String,HIDDEN:%String,CTLOCCode:%String,HIDDEN:%String,VisitFr:%String,VisitTo:%String,RestFr:%String,RestTo:%String,VisitRange:%String,HIDDEN:%String")
{
}

}
