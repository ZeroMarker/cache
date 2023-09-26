Include webimport

IncludeGenerator webimport

Class web.RBResource Extends (%Library.RegisteredObject, websys.Abstract) [ Not Abstract, ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 2505;

Parameter SQLDATEFROM;

Parameter SQLDATETO = "RES_DateTo";

Parameter SQLCODE = "RES_Code";

Parameter SQLDESCRIPTION = "RES_Desc";

Parameter SQLROWID = "RES_RowId";

Property dummy As %String(TRUNCATE = 1);

ClassMethod CheckServiceAgainstResource(ArcimID As %String, RescID As %String, CurrDate As %String) As %Boolean
{
}

ClassMethod CheckDatesAgainstResource(RescID As %Library.String = "", TargetDate As %Library.String = "") As %Boolean
{
}

ClassMethod FindOPResourcesByLocResClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindOPResourcesByLocResFetch ]
{
}

ClassMethod FindOPResourcesByLocResExecute(ByRef QHandle As %Library.Binary, locDesc As %Library.String = "", resList As %Library.String = "", adate As %Library.String = "", OPStatus As %Library.String = "") As %Library.Status
{
}

ClassMethod FindOPResourcesByLocResFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = FindOPResourcesByLocResExecute ]
{
}

/// w ##Class(web.RBResource).GetByPartialCareProv("398||3")
ClassMethod GetByPartialCareProv(TransID As %Library.String) As %Library.String
{
	Q "^^^^"
}

ClassMethod GetDescFromCode(code As %String) As %Library.String
{
}

/// Returns a message to warn the user that this Resource is end dated
ClassMethod GetEndDatedMessage(ResID As %Library.String = "") As %Library.String
{
}

ClassMethod GetIdFromLocationAndRes(LocRowID As %Library.String, ResDesc As %Library.String) As %Library.String
{
}

ClassMethod GetResource(resc As %String, loc As %String, serv As %String, inquire As %String, compref As %Library.String = "", type As %Library.String = "", SSFlag As %String) As %Integer
{
}

ClassMethod GetService(PatientID As %String = "", LocationID As %String = "", ResourceID As %String = "", code As %String = "", ndate As %String = "", TransApptId As %String = "") As %Library.String
{
}

/// Called by the web broker.
/// The main purpose is to convert from code to description dynamically.
/// itmjs - javascript function e.g. Location_lookupsel
/// itmjsex - extended javascript function
ClassMethod zzLookUpActiveBroker(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "") As %Library.Boolean
{
}

/// Called by the web broker.
/// The main purpose is to convert from code to description dynamically.
/// itmjs - javascript function e.g. Location_lookupsel
/// itmjsex - extended javascript function
/// loc - location description
/// loctype - location type
ClassMethod LookUpBrokerByLocationType(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "", loc As %Library.String = "", loctype As %Library.String = "", dtto As %Library.String = "") As %Library.Boolean
{
}

/// Called by the web broker.
/// The main purpose is to convert from code to description dynamically.
/// itmjs - javascript function e.g. Location_lookupsel
/// itmjsex - extended javascript function
ClassMethod LookUpBrokerByMultiLocs(itmjs As %Library.String = "", itmjsex As %Library.String = "", valresc As %Library.String = "", locs As %Library.String = "", rescType As %Library.String = "") As %Library.Boolean
{
}

ClassMethod zzLookUpBrokerByPartialCareP(itmjs As %Library.String = "", itmjsex As %Library.String = "", docDesc As %Library.String = "", locDesc As %Library.String = "", conFlag As %Library.String = "", date As %Library.String = "")
{
}

/// by wuqk 2011-06-23
ClassMethod LookUpBrokerByPartialCareProv(itmjs As %String = "", itmjsex As %String = "", docDesc As %String = "", locDesc As %String = "", conFlag As %String = "", date As %String = "", userFlag As %String = "", Hospitals As %String = "", LocIDs As %String = "", admtype As %String = "", locType As %String = "", prompttime As %String = "", intType As %String = "", HOSPDesc As %String = "", flags As %String = "") As %Library.Boolean
{
	set rs=##Class(%ResultSet).%New("web.RBResource.LookUpByPartialCareProv")
	quit:'$IsObject(rs) 0
	do rs.Execute(docDesc, locDesc, conFlag, date, userFlag, Hospitals, LocIDs, admtype, locType, prompttime, intType, HOSPDesc, flags)
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

ClassMethod LookUpBrokerCareProv(itmjs As %Library.String = "", itmjsex As %Library.String = "", resDesc As %Library.String = "", locDesc As %Library.String = "", conFlag As %Library.String = "")
{
}

ClassMethod LookUpBrokerEquipment(itmjs As %Library.String = "", itmjsex As %Library.String = "", resdesc As %Library.String = "", locdesc As %Library.String = "")
{
}

ClassMethod zzLookUpBrokerLoc(itmjs As %Library.String = "", itmjsex As %Library.String = "", resDesc As %Library.String = "", locDesc As %Library.String = "", locType As %Library.String = "")
{
}

ClassMethod LookUpBrokerLocByRes(itmjs As %String, itmjsex As %String, rescDesc As %String = "", locDesc As %String = "", locType As %String = "", admType As %String = "", admDate As %String = "", Hospitals As %String = "", HospDesc As %String = "", userFlag As %String = "", RestrictDept As %String = "", EpisodeID As %String = "") As %Library.Boolean
{
}

ClassMethod LookUpBrokerLocByResAdmType(itmjs As %Library.String, itmjsex As %Library.String, rescDesc As %Library.String = "", locDesc As %Library.String = "", locType As %Library.String = "", admType As %Library.String = "", admDate As %Library.String = "", Hospitals As %String = "", HospDesc As %String = "") As %Library.Boolean
{
}

/// wanghc
/// Delete an instance - this is provided as a wrapper for %DeleteId functionality.
ClassMethod websysDelete(id As %Library.String)
{
	i ##class(web.SSUser).IsValidUser(%request.Get("UserCode"),%request.Get("PIN"))>0 d
	.&sql(DELETE FROM RB_Resource WHERE RES_RowId=:id)
	e  d msg.AddItem("E",$g(t("PIN"),"密码"),"输入错误!",1679,"PIN") q 0	;用户或密码不正确
}

ClassMethod zzLookUpBrokerLocRes(itmjs As %Library.String, itmjsex As %Library.String, resDesc As %Library.String, locDesc As %Library.String, locType As %Library.String)
{
}

ClassMethod LookUpBrokerOPRes(itmjs As %Library.String = "", itmjsex As %Library.String = "", rescDesc As %Library.String = "", locDesc As %Library.String = "", date As %Library.String = "", surgeon As %Library.String = "", anaeth As %Library.String = "", ignore As %Library.String = "") As %Library.Boolean
{
}

ClassMethod zzLookUpBrokerRadLoc(itmjs As %Library.String = "", itmjsex As %Library.String = "", resDesc As %Library.String = "", locDesc As %Library.String = "")
{
}

ClassMethod LookUpBrokerRes(itmjs As %String = "", itmjsex As %String = "", resDesc As %String = "", locDesc As %String = "", date As %String = "", HCARowID As %String = "", HospIDs As %String = "", PatientID As %String = "", QLDOutChk As %String = "", locids As %String = "", TransAppt As %String = "") As %Library.Boolean
{
}

/// Called by the web broker.
/// The main purpose is to convert from code to description dynamically.
/// itmjs - javascript function e.g. Location_lookupsel
/// itmjsex - extended javascript function
ClassMethod zzLookUpBrokerWLByLocation(itmjs As %Library.String, itmjsex As %Library.String, val As %Library.String, loc As %Library.String, conFlag As %Library.String, activedate As %Library.String = "") As %Library.Boolean
{
}

/// Log 51697 YC - Copied from LookUpBrokerByPartialCareProv and modified so that if there is a restricted 
/// care provider list defined in: CT->System Management->Users->Result Entry Care Provider Restrictions
/// then only those in the list will be returned by the broker.
/// Used By: OETextResult.Edit -> Reporting Care Provider (TRCareProviderReportedDR) lookup
ClassMethod LookUpBrokerByRestrCareProv(itmjs As %String = "", itmjsex As %String = "", docDesc As %String = "", locDesc As %String = "", conFlag As %String = "", date As %String = "", userFlag As %String = "", Hospitals As %String = "", LocIDs As %String = "", admtype As %String = "", locType As %String = "", prompttime As %String = "", intType As %String = "", HOSPDesc As %String = "", flags As %String = "") As %Library.Boolean
{
}

ClassMethod LookUpAvailClinicsClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = LookUpAvailClinicsFetch ]
{
}

ClassMethod LookUpAvailClinicsExecute(ByRef QHandle As %Binary) As %Status
{
}

ClassMethod LookUpAvailClinicsFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = LookUpAvailClinicsExecute ]
{
}

ClassMethod LookUpByMultiLocsClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = LookUpByMultiLocsFetch ]
{
}

/// Author - John Hart
/// Input - Care Provider, Delimited string of locations
/// Purpose - To find care providers that belong to all specified locations
/// Used by - OEOrdItem.PrePostExam
/// 
/// 20/3/02 - Modified to add a parameter to check equipment type resources
/// else default to care provider resources.
ClassMethod LookUpByMultiLocsExecute(ByRef QHandle As %Library.Binary, rescdesc As %Library.String = "", locs As %Library.String = "", rescType As %Library.String = "") As %Library.Status
{
}

ClassMethod LookUpByMultiLocsFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = LookUpByMultiLocsExecute ]
{
}

ClassMethod LookUpByLocationClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = LookUpByLocationFetch ]
{
}

ClassMethod LookUpByLocationExecute(ByRef QHandle As %Library.Binary, rescDesc As %String = "", locDesc As %String = "", locType As %String = "", date As %String = "", OPFlag As %String = "", IPFlag As %String = "") As %Library.Status
{
}

ClassMethod LookUpByLocationFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = LookUpByLocationExecute ]
{
}

ClassMethod LookUpByPartialCareProvClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = LookUpByPartialCareProvFetch ]
{
	Set repid=$LIST(QHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// by wuqk 2011-06-23 未完成，部分条件未判断
/// 仅判断 rescDesc、locDesc、date
ClassMethod LookUpByPartialCareProvExecute(ByRef QHandle As %Library.Binary, rescDesc As %String = "", locDesc As %String = "", conFlag As %String = "", date As %String = "", userFlag As %String = "", Hospitals As %String = "", LocIDs As %String = "", admtype As %String = "", locType As %String = "", prompttime As %String = "", intType As %String = "", HOSPDesc As %String = "", flags As %String = "") As %Library.Status
{
	n repid
	s repid=$I(^CacheTemp)
	s ind=1
	s QHandle=$lb(0,repid,0)
	//s outFlg=0
	//^RB("RES",0,"LocDesc",{RES_CTLOC_DR},$$ALPHAUP({RES_Desc}),{RES_RowId})
	//locDesc ^CTLOC(0,"Desc",$$ALPHAUP({CTLOC_Desc}),{CTLOC_RowID})
	//Condition
	if date'="" s date=##class(websys.Conversions).DateHtmlToLogical(date)
	if locDesc'=""{
		s locDesc=$zu(28,locDesc,6)
		s ctlocId=$o(^CTLOC(0,"Desc",locDesc,0))
		quit:ctlocId="" $$$OK
		quit:'$d(^RB("RES",0,"LocDesc",ctlocId)) $$$OK
		do BuildByDocDesc
	}else{
		s ctlocId=$o(^RB("RES",0,"LocDesc",0))
		while ctlocId'="" {
			do BuildByDocDesc
			s ctlocId=$o(^RB("RES",0,"LocDesc",ctlocId))
		}
	}
	quit $$$OK
BuildByDocDesc
	Set rescChar = $e(rescDesc,1)
	Set rescChar = $ascii(rescChar)
	;A-Z,a-z  CTPCP_OtherName  拼音查询  wanghc 2015-03-22
	if ((rescChar>64)&&(rescChar<91))||((rescChar>96)&&(rescChar<123)){
		Set tmpRescDesc = $zcvt(rescDesc,"U")
		set resId = $o(^RB("RES",0))
		while (resId'=""){
			 set resId = $o(^RB("RES",resId))
			 set objRBResource = ##class(User.RBResource).%OpenId(resId,0)
			 continue:'$IsObject(objRBResource)
			 Set ReSourceLocDr = objRBResource.RESCTLOCDRGetObjectId()
			 continue:(ctlocId'="")&&(ctlocId'=ReSourceLocDr)
			 set OtherName = objRBResource.RESCTPCPDR.CTPCPOtherName
			 continue:($zcvt($e(OtherName,1,$l(rescDesc)),"U")'=tmpRescDesc)&&(tmpRescDesc'="")
			 do BulidData 
		}
	}else{
		s rescDesc=$zu(28,rescDesc,6)
		s tempDesc=rescDesc
		s:tempDesc="" tempDesc=$o(^RB("RES",0,"LocDesc",ctlocId,tempDesc))
		while (tempDesc'="")&&($e(tempDesc,1,$l(rescDesc))=rescDesc){
			s resId=$o(^RB("RES",0,"LocDesc",ctlocId,tempDesc,0))
			while resId'=""{
				do BulidData
				s resId=$o(^RB("RES",0,"LocDesc",ctlocId,tempDesc,resId))
			}
			s tempDesc=$o(^RB("RES",0,"LocDesc",ctlocId,tempDesc))
		
		}
	}
	quit
BulidData
	set objRBResource=##class(User.RBResource).%OpenId(resId,0)
	quit:'$IsObject(objRBResource)
	;CS程序维护数据截止时间记录在.RESDateTo字段上
	;quit:(date'="")&&(objRBResource.RESDateActiveTo'="")&&(objRBResource.RESDateActiveTo<date)
	quit:(date'="")&&(objRBResource.RESDateActiveFrom'="")&&(objRBResource.RESDateActiveFrom>date)
	quit:(date'="")&&(objRBResource.RESDateTo'="")&&(objRBResource.RESDateTo<date)
	set admright = objRBResource.RESAdmittingRights
	quit:(admright'="Y")
	s data=$lb()
	s $li(data,1)=objRBResource.RESDesc
	s $li(data,2)=objRBResource.RESCode
	s $li(data,3)=$s($IsObject(objRBResource.RESCTLOCDR):objRBResource.RESCTLOCDR.CTLOCDesc,1:"")
	s $li(data,4)=objRBResource.%Id()
	s $li(data,5)=$s($IsObject(objRBResource.RESCTLOCDR):objRBResource.RESCTLOCDR.%Id(),1:"")
	//s $li(data,6)=objRBResource.RESRefHospDR
	//s $li(data,7)=objRBResource.RESCTLOCDR
	//s $li(data,8)=objRBResource.RESCTLOCDR
	s $li(data,9)=$s($IsObject(objRBResource.RESCTPCPDR):objRBResource.RESCTPCPDR.%Id(),1:"")
	//s $li(data,10)=objRBResource.RESCTPCPDR
	s $li(data,11)=$s($IsObject(objRBResource.RESCTPCPDR):objRBResource.RESCTPCPDR.CTPCPCarPrvTpDR.CTCPTDesc,1:"")
	s ^CacheTemp(repid,ind)=data
	s ind=ind+1
	q $$$OK
}

ClassMethod LookUpByPartialCareProvFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = LookUpByPartialCareProvExecute ]
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

/// JW: used in PAADM to limit the careprovider search to selected location and location type
Query LookUpByPartialCareProv(docDesc As %String, locDesc As %String, conFlag As %String, date As %Date, userFlag As %String, Hospitals As %String, LocIDs As %String, admtype As %String, locType As %String, time As %String, intType As %String, HOSPDesc As %String, flags As %String) As %Library.Query(CONTAINID = 0, ROWSPEC = "RESDesc:%String,code:%String,Location:%String,HIDDEN:%String,HIDDEN:%String,Hospital:%String,Responsible Unit:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String")
{
}

ClassMethod LookUpByResIDsClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = LookUpByResIDsFetch ]
{
}

ClassMethod LookUpByResIDsExecute(ByRef QHandle As %Library.Binary, ResIDs As %Library.String, ClinicDates As %Library.String) As %Library.Status
{
}

ClassMethod LookUpByResIDsFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = LookUpByResIDsExecute ]
{
}

/// RQG 12.02.03 LOG30883: Called from PATumor.Edit component
ClassMethod zzLookUpCPBroker(itmjs As %Library.String = "", itmjsex As %Library.String = "", docDesc As %Library.String = "", locDesc As %Library.String = "") As %Library.Boolean
{
}

ClassMethod LookUpCareProvClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = LookUpCareProvFetch ]
{
}

ClassMethod LookUpCareProvExecute(ByRef QHandle As %Library.Binary, doc As %Library.String, loc As %Library.String, ADMAdmDate As %Library.String, ADMTime As %Library.String) As %Library.Status
{
}

ClassMethod LookUpCareProvFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = LookUpCareProvExecute ]
{
}

ClassMethod LookUpLocationByResClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = LookUpLocationByResFetch ]
{
	n repid
	Set repid=$LIST(QHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// ##class(%ResultSet).RunQuery("web.RBResource","LookUpLocationByRes","","","E","I","2017-08-16","","",1,"")
ClassMethod LookUpLocationByResExecute(ByRef QHandle As %Library.Binary, rescDesc As %String = "", locDesc As %String = "", locType As %String = "", admType As %String = "", admDate As %String = "", Hospitals As %String = "", HospDesc As %String = "", userFlag As %String = "", RestrictDept As %String = "", EpisodeID As %String = "") As %Library.Status
{
    n repid,ctlocId
	s repid=$I(^CacheTemp)
	s ind=1
	s QHandle=$lb(0,repid,0)
    
	if locDesc'=""{
		s locDesc=$zu(28,locDesc,6)		
		set tmpAlias=locDesc
		do:tmpAlias'="" GetByAlias
		set tmpAlias=$o(^CTLOC(0,"Desc",locDesc))
#;#;	while (tmpAlias'="")&((tmpAlias[locDesc)||(locDesc="")) {
#;#;		//do GetByAlias
#;#;		set tmpAlias=$o(^CTLOC(0,"Desc",tmpAlias))
#;#;	}
		quit $$$OK
	}else{
		s ctlocId=$o(^RB("RES",0,"LocDesc",0))
		while ctlocId'="" {
			s activeToDate=$p($g(^CTLOC(ctlocId)),"^",25)
			i (($p($g(^CTLOC(ctlocId)),"^",13)="E")&&((activeToDate>+$h)||(activeToDate=""))) d
#;			.s locType = $p($g(^PAC("ADMLOC",ctlocId)),"^",1)
#;			.PAC_AdmTypeLocation
#;			.转科时应只能取住院的科室,门诊科室不用显示
            .s admLocRowid=$o(^PAC("ADMLOC",0,"AdmType",admType,ctlocId,0)) ; 
            .q:admLocRowid=""
            .s:admLocRowid'="" locType=$p($g(^PAC("ADMLOC",admLocRowid)),"^",1)
			.s admCurrLocID=""
			.s:EpisodeID'="" admCurrLocID = $p($g(^PAADM(EpisodeID)),"^",4)
#;			.不显示当前所在科室
 			.q:(locType'=admType)!((admCurrLocID'="")&&(ctlocId=admCurrLocID))
			.d Buildlocdesc
			s ctlocId=$o(^RB("RES",0,"LocDesc",ctlocId))
		}
	}
	quit $$$OK
GetByAlias
	s curDesc=tmpAlias
	i curDesc'="" s curDesc=$o(^CTLOC(0,"Desc",curDesc),-1)
	f  s curDesc=$o(^CTLOC(0,"Desc",curDesc)) q:curDesc=""  d
	.;q:(desc'="")&&($p(curDesc,desc)'="")
	.s ctlocId=$o(^CTLOC(0,"Desc",curDesc,""))
	.q:'$d(^CTLOC(ctlocId))
	.;s locType = $p($g(^PAC("ADMLOC",ctlocId)),"^",1)
    .s admLocRowid=$o(^PAC("ADMLOC",0,"AdmType",admType,ctlocId,0))
    .q:admLocRowid=""
    .s:admLocRowid'="" locType=$p($g(^PAC("ADMLOC",admLocRowid)),"^",1)
	.s admCurrLocID=""
	.s:EpisodeID'="" admCurrLocID = $p($g(^PAADM(EpisodeID)),"^",4)
 	.q:(locType'=admType)!((admCurrLocID'="")&&(ctlocId=admCurrLocID))
	.s ctlocDesc=$p(^CTLOC(ctlocId),"^",2)
	.s CTLocCode= $p($g(^CTLOC(ctlocId)),"^",43)
	.q:(CTLocCode'[tmpAlias)&&(ctlocDesc'[tmpAlias)
	.set outCTLocType=$o(^PAC("ADMLOC",0,"AdmType","O",ctlocId,""))
	.set inCTLocType=$o(^PAC("ADMLOC",0,"AdmType","E",ctlocId,""))
	.set emergencyType=$o(^PAC("ADMLOC",0,"AdmType","I",ctlocId,""))
	.set activeToDate=$p($g(^CTLOC(ctlocId)),"^",25)
	.if '$d(^RB("RES",0,"LocDesc",ctlocId))||(outCTLocType'="") d
	..do:(($p($g(^CTLOC(ctlocId)),"^",13)="E")&&((activeToDate>+$h)||(activeToDate=""))) Buildlocdesc
	..set ctlocId=$o(^CTLOC(0,"Desc",tmpAlias,ctlocId))
	.else  d
	..do:(($p($g(^CTLOC(ctlocId)),"^",13)="E")&&((activeToDate>+$h)||(activeToDate=""))) Buildlocdesc
	..set ctlocId=$o(^CTLOC(0,"Desc",tmpAlias,ctlocId))
	
	quit	
Buildlocdesc
	;CTLOCCode,CTLOCDesc,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,Hospital:%String,HIDDEN:%String
	&SQL(select CTLOC_Code,CTLOC_Desc,CTLOC_RowId into :CTLOCCode,:CTLOCDesc,:CTLOCRowId From SQLUser.CT_Loc Where CTLoc_RowId=:ctlocId)
	s ^CacheTemp(repid,ind)=$Lb(CTLOCCode,CTLOCDesc,"",CTLOCRowId)
	s ind=ind+1
	q $$$OK
}

ClassMethod LookUpLocationByResFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = LookUpLocationByResExecute ]
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

ClassMethod zLookUpLocByResAdmTypeClose(QHandle As %Library.Binary) As %Library.Status
{
}

ClassMethod zLookUpLocByResAdmTypeExecute(ByRef QHandle As %Library.Binary, rescDesc As %Library.String = "", locDesc As %Library.String = "", locType As %Library.String = "", admType As %Library.String = "", admDate As %Library.String = "", Hospitals As %Library.String = "") As %Library.Status
{
}

ClassMethod zLookUpLocByResAdmTypeFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status
{
}

ClassMethod LookUpLocationWLActiveClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = LookUpLocationWLActiveFetch ]
{
}

ClassMethod LookUpLocationWLActiveExecute(ByRef QHandle As %Library.Binary, rescDesc As %Library.String = "", locDesc As %Library.String = "", activedate As %Library.Date = "", hospDesc As %Library.String = "") As %Library.Status
{
}

ClassMethod LookUpLocationWLActiveFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = LookUpLocationWLActiveExecute ]
{
}

ClassMethod LookUpLocationWLClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = LookUpLocationWLFetch ]
{
}

ClassMethod LookUpLocationWLExecute(ByRef QHandle As %Library.Binary, rescDesc As %Library.String = "", locDesc As %Library.String = "") As %Library.Status
{
}

ClassMethod LookUpLocationWLFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = LookUpLocationWLExecute ]
{
}

ClassMethod LookUpOpResClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = LookUpOpResFetch ]
{
}

ClassMethod LookUpOpResExecute(ByRef QHandle As %Library.Binary, rescDesc As %Library.String = "", locDesc As %Library.String = "", date As %Library.String = "", surgeon As %Library.String = "", anaeth As %Library.String = "", ignore As %Library.String = "") As %Library.Status
{
}

ClassMethod LookUpOpResFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = LookUpOpResExecute ]
{
}

ClassMethod LookUpRadLocClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = LookUpRadLocFetch ]
{
}

ClassMethod LookUpRadLocExecute(ByRef QHandle As %Library.Binary, rescDesc As %Library.String = "", locDesc As %Library.String = "", BookingType As %Library.String = "", Date As %Library.String = "") As %Library.Status
{
}

ClassMethod LookUpRadLocFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = LookUpRadLocExecute ]
{
}

ClassMethod LookUpResClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = LookUpResFetch ]
{
}

ClassMethod LookUpResExecute(ByRef QHandle As %Library.Binary, rescDesc As %String = "", locDesc As %Library.String = "", date As %String = "", HCARowID As %String = "", HospIDs As %String = "", PatientID As %String = "", QLDOutChk As %String = "", locids As %String = "", TransAppt As %String = "") As %Library.Status
{
}

ClassMethod LookUpResFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = LookUpResExecute ]
{
}

ClassMethod LookUpByRestrCareProvClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = LookUpByPartialCareProvFetch ]
{
}

/// Log 51697 YC - Copied from LookUpByPartialCareProv and modified so that the lookup is restricted by
/// Restricted Care Providers from VB: CT->System Management->Users->Result Entry Care Provider Restrictions
/// Care providers are filtered by Location
/// If the code table does not have restricted care providers then it will do the same query as LookUpByPartialCareProvider
/// Used By: OETextResult.Edit -> Reporting Care Provider (TRCareProviderReportedDR) Lookup
ClassMethod LookUpByRestrCareProvExecute(ByRef QHandle As %Library.Binary, rescDesc As %String = "", locDesc As %String = "", conFlag As %String = "", date As %String = "", userFlag As %String = "", Hospitals As %String = "", LocIDs As %String = "", admtype As %String = "", locType As %String = "", prompttime As %String = "", intType As %String = "", HOSPDesc As %String = "", flags As %String = "") As %Library.Status
{
}

ClassMethod LookUpByRestrCareProvFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = LookUpByPartialCareProvExecute ]
{
}

/// Called by the web broker.
/// The main purpose is to convert from code to description dynamically.
/// itmjs - javascript function e.g. Location_lookupsel
/// itmjsex - extended javascript function
ClassMethod LookUpWLLocationBroker(itmjs As %Library.String, itmjsex As %Library.String, rescDesc As %Library.String = "", locDesc As %Library.String = "", activedate As %Library.Date = "", hospDesc As %Library.String = "") As %Library.Boolean
{
}

/// Log 56831 - 15.01.2007
ClassMethod LookUpResourceByLocExecute(ByRef QHandle As %Binary, Res As %String = "", Loc As %String = "") As %Status
{
}

ClassMethod LookUpResourceByLocClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = LookUpResourceBtLocExecute ]
{
}

ClassMethod LookUpResourceByLocFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = LookUpResourceBtLocExecute ]
{
}

/// KM 10-Sept-2001: Used in Component RBDeptFuncPreferences.Custom
ClassMethod getDeptFuncExtraClinics(Clinics As %Library.String, dfrom As %Library.Date, dto As %Library.Date)
{
}

/// KM 10-Sept-2001: Used in Component RBDeptFuncPreferences.Custom
ClassMethod getDeptFuncPrefernce()
{
}

ClassMethod RetainValues()
{
}

/// wanghc
/// Invoked before websysSave - can be used to cancel the save.<br>
ClassMethod websysBeforeSave(compref As %String, ByRef id As %String) As %Boolean
{
	i ##class(web.SSUser).IsValidUser(%request.Get("UserCode"),%request.Get("PIN"))>0 q 1
	e  d msg.AddItem("E",$g(t("PIN"),"密码"),"输入错误!",+$e(compref,2,),"PIN") q 0	;用户或密码不正确
}

/// KM 10-Sept-2001: Used on the update of Component RBDeptFuncPreferences.Custom
ClassMethod websysSaveDeptFuncPref()
{
}

/// Called by the web broker.
/// The main purpose is to convert from code to description dynamically.
/// itmjs - javascript function e.g. Location_lookupsel
/// itmjsex - extended javascript function
ClassMethod zLookUpBrokerByLocation(itmjs As %Library.String, itmjsex As %Library.String, val As %Library.String, loc As %Library.String) As %Library.Boolean
{
}

Query Find(loc As %String, resc As %String) As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID,RESDesc:%String,CTLOCDesc:%String,RESCTLOCDR:%String,RESCTPCPDR:%String,RESEQDR:%String")
{
SELECT RES_RowID, RES_Desc, RES_CTLOC_DR->CTLOC_Desc, RES_CTLOC_DR, RES_CTPCP_DR, RES_EQ_DR
FROM RB_Resource
WHERE (RES_CTLOC_DR->CTLOC_Desc = :loc) AND (%ALPHAUP RES_Desc = %ALPHAUP :resc)
}

Query FindByDoc(docID As %String) As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID,CTPCPCode:%String,CTPCPDesc:%String,CTLOCCode:%String,CTLOCDesc:%String")
{
SELECT RES_ROWID, RES_CTPCP_DR->CTPCP_Code, RES_CTPCP_DR->CTPCP_Desc, RES_CTLOC_DR->CTLOC_Code, RES_CTLOC_DR->CTLOC_Desc
FROM RB_Resource
WHERE (RES_CTPCP_DR->CTPCP_RowId = :docID)
}

Query FindByDocLoc(doc As %String, loc As %String) As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID,CTPCPDesc:%String,CTLOCDesc:%String")
{
SELECT RES_RowID, RES_CTPCP_DR->CTPCP_Desc, RES_CTLOC_DR->CTLOC_Desc
FROM RB_Resource
WHERE (RES_CTPCP_DR = :doc) AND (RES_CTLOC_DR = :loc)
}

Query FindByID(rescID As %Library.String) As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "RESDesc:%String")
{
SELECT RES_Desc
FROM RB_Resource
WHERE RES_RowID = :rescID
}

Query FindByLoc(LocID As %String) As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID,CTLOCCode:%String,CTPCPId:%String,CTPCPDesc:%String")
{
SELECT RES_ROWID, RES_CTLOC_DR->CTLOC_Code, RES_CTPCP_DR->CTPCP_RowId, RES_CTPCP_DR->CTPCP_Desc
FROM RB_Resource
WHERE (RES_CTLOC_DR = :LocID) AND (RES_CTPCP_DR->CTPCP_RowId > 0)
ORDER BY RES_CTPCP_DR->CTPCP_Desc
}

Query FindEquipment(locdesc As %Library.String = "") As %Library.SQLQuery(CONTAINID = 1, ROWSPEC = "RescID:%String,RESDesc:%String")
{
SELECT  RES_RowID,RES_EQ_DR->EQ_Desc
FROM SQLUser.RB_Resource
WHERE (RES_CTLOC_DR->CTLOC_Desc %STARTSWITH :locdesc) AND (RES_EQ_DR->EQ_Desc %STARTSWITH %ALPHAUP null)
ORDER BY RES_CTLOC_DR->CTLOC_Desc, RES_EQ_DR->EQ_Desc
}

Query FindAllResByLoc(locdesc As %String) As %SQLQuery(CONTAINID = 1, ROWSPEC = "RescID:%String,RESDesc:%String")
{
SELECT RES_RowID, RES_Desc
FROM RB_Resource
WHERE (RES_CTLOC_DR->CTLOC_Desc %STARTSWITH :locdesc)
ORDER BY RES_Desc
}

Query FindResByLoc(LocRowID As %String, ResDesc As %String) As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "ID:%String")
{
select RES_RowId from RB_Resource
where (RES_CTLOC_DR=:LocRowID AND RES_Desc=:ResDesc)
}

/// Log 51815 02/05/05 Chandana - Returns Resource descriptions by selected location and resources
Query FindOPResourcesByLocRes(locDesc As %String = "", resList As %String = "", adate As %String = "", OPStatus As %Library.String = "") As %Library.Query(CONTAINID = 0, ROWSPEC = "ID:%String,RESDesc:%String,LocId:%String,SelDate:%Date")
{
}

Query FindTheatre(locdesc As %Library.String = "") As %Library.SQLQuery(CONTAINID = 1, ROWSPEC = "RescID:%String,RESDesc:%String")
{
SELECT  RES_RowID,RES_EQ_DR->EQ_Desc
FROM SQLUser.RB_Resource
WHERE RES_CTLOC_DR->CTLOC_Type='OP'
AND 	((RES_CTLOC_DR->CTLOC_Desc %Startswith :locdesc) OR (RES_CTLOC_DR = :locdesc))
ORDER BY RES_CTLOC_DR->CTLOC_Desc, RES_EQ_DR->EQ_Desc
}

Query LookUpAvailClinics() As %Library.Query(CONTAINID = 1, ROWSPEC = "HIDDEN,resDesc,HIDDEN,locDesc")
{
}

/// SB 29/04/02: This query is no longer in use. Either use LookUpByLocation, 
/// LookUpLocationByRes OR LookUpDoc
/// 
/// AmiN: 22 July 2002  This query is used by LookUpByMultiLocsExecute for lookups 
/// and brokers for OEOrdItem.PostExam
/// log 62295 include rowid, and match by doc code
Query LookUpByCareProvider(docDesc As %String, locDesc As %String) As %SQLQuery(CONTAINID = 0, ROWSPEC = "Doc:%String,Loc:%String,HIDDEN:%String")
{
SELECT RES_CTPCP_DR->CTPCP_Desc, RES_CTLOC_DR->CTLOC_Desc, RES_RowID
FROM RB_Resource
WHERE ((RES_CTPCP_DR->CTPCP_Desc %STARTSWITH :docDesc) OR (RES_CTPCP_DR->CTPCP_Code %STARTSWITH :docDesc))
AND (RES_CTLOC_DR->CTLOC_Desc %STARTSWITH :locDesc)
ORDER BY RES_CTPCP_DR->CTPCP_Desc
}

/// KM 19-Oct-2001: Updated this LookUp so that you can  now filter on Location Type 
/// (done for LookUp on RBDeptFuncPreferences.Custom which only wishes to show Location types that are Executed)
Query LookUpByLocation(rescDesc As %String, locDesc As %String, locType As %String, date As %String, OPFlag As %String, IPFlag As %String) As %Library.Query(CONTAINID = 0, ROWSPEC = "CTLOCDesc:%String,RESDesc:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String")
{
}

/// TP 26-Nov-2001: Created this LookUp so that you can  now filter on Location Type 
/// (done for LookUp on webcommon.DateFromTo.Custom) 
/// TP 19-Feb-2002: Modified this LookUp so that you can  now filter on multiple Location 
/// Types. LocationType must be passed like ^E^W^
/// (done for LookUp on webcommon.DateFromTo.Custom) 
/// KK 27/May/2003 Log 34893 - Modified partial match to exact mach of location in filter criteria . 
Query LookUpByLocationType(resdesc As %String, locdesc As %String, loctype As %String) As %SQLQuery(CONTAINID = 2, ROWSPEC = "RESDesc:%String,HIDDEN:%String,CTLOCDesc:%String,HIDDEN:%String")
{
SELECT RES_Desc, RES_RowId, RES_CTLOC_DR->CTLOC_Desc, RES_CTLOC_DR
FROM RB_Resource
WHERE (%ALPHAUP RES_Desc [%ALPHAUP :resdesc) 
AND ((%UPPER RES_CTLOC_DR->CTLOC_Desc = %UPPER :locdesc) OR (:locdesc IS NULL))
AND ((:loctype [ {fn CONCAT( '^', {fn CONCAT((RES_CTLOC_DR->CTLOC_Type),'^')})}) OR (:loctype IS NULL) OR (:loctype=(RES_CTLOC_DR->CTLOC_Type)))
ORDER BY RES_CTLOC_DR->CTLOC_Desc
}

/// Log 65441 - 14.11.2007: Created this LookUp so that you can  now filter on Location Type also considering the Date From/To
Query LookUpByLocTypeDate(resdesc As %String, locdesc As %String, loctype As %String, dtto As %String) As %SQLQuery(CONTAINID = 2, ROWSPEC = "RESDesc:%String,HIDDEN:%String,CTLOCDesc:%String,HIDDEN:%String")
{
SELECT RES_Desc, RES_RowId, RES_CTLOC_DR->CTLOC_Desc, RES_CTLOC_DR
FROM RB_Resource
WHERE (%ALPHAUP RES_Desc [%ALPHAUP :resdesc) 
AND ((%UPPER RES_CTLOC_DR->CTLOC_Desc = %UPPER :locdesc) OR (:locdesc IS NULL))
AND ((:loctype [ {fn CONCAT( '^', {fn CONCAT((RES_CTLOC_DR->CTLOC_Type),'^')})}) OR (:loctype IS NULL) OR (:loctype=(RES_CTLOC_DR->CTLOC_Type)))
AND ((RES_DateTo >= :dtto) OR (RES_DateTo IS NULL))
ORDER BY RES_CTLOC_DR->CTLOC_Desc
}

/// Author - John Hart
/// Input - Care Provider, Delimited string of locations
/// Purpose - To find care providers that belong to all specified locations
/// Used by - OEOrdItem.PrePostExam
/// 
/// 20/3/02 - Modified to add a parameter to check equipment type resources
/// else default to care provider resources.
Query LookUpByMultiLocs(rescdesc As %Library.String, locs As %Library.String, rescType As %Library.String) As %Library.Query(CONTAINID = 0, ROWSPEC = "Resc:%String,Code:%String")
{
}

/// JW: used in PAADM to limit the careprovider search to selected location and location type
Query LookUpByPartialCareProvider(docDesc As %String, locDesc As %String, conFlag As %String) As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "RESDesc:%String,code:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String")
{
SELECT DISTINCT BY (RES_CTPCP_DR) RES_CTPCP_DR->CTPCP_Desc,RES_CTPCP_DR->CTPCP_Code,RES_CTLOC_DR->CTLOC_Desc, 
RES_RowId, RES_CTLOC_DR->CTLOC_RowId
FROM RB_Resource
WHERE (%ALPHAUP RES_CTPCP_DR->CTPCP_Desc [%ALPHAUP :docDesc)
AND ((%ALPHAUP RES_CTLOC_DR->CTLOC_Desc %STARTSWITH %ALPHAUP :locDesc) OR (:locDesc IS NULL))
AND (RES_CTPCP_DR->CTPCP_SpecialistYN ='Y' OR :conFlag IS NULL)
ORDER BY RES_CTPCP_DR->CTPCP_Desc
}

/// KM 11-Sept-2001: For Dept Function preferences
Query LookUpByResIDs(ResIDs As %Library.String, ClinicDates As %Library.String) As %Library.Query(CONTAINID = 1, ROWSPEC = "ID:%String,Desc:%String")
{
}

Query LookUpCareProv(doc As %Library.String, loc As %Library.String, ADMAdmDate As %Library.String, ADMTime As %Library.String) As %Library.Query(CONTAINID = 0, ROWSPEC = "dept:%String,doc:%String,HIDDEN:%String")
{
}

/// returns the careproviders linked to a location
Query zzLookUpCUS(desc As %String) As %SQLQuery(CONTAINID = 1, ROWSPEC = "Description:%String,hidden:%String,Code:%String")
{
Select	RES_Desc,RES_RowId,RES_Code
From	SQLUser.RB_Resource
Where	((%UPPER RES_Desc %STARTSWITH %UPPER :desc)
Or	(%UPPER RES_Code = %UPPER :desc))
}

Query zzLookUpDoc(docDesc As %Library.String, locDesc As %Library.String, hospdesc As %Library.String) As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "Doc:%String,Loc:%String,hidden")
{
SELECT RES_CTPCP_DR->CTPCP_Desc, RES_CTLOC_DR->CTLOC_Desc,RES_CTPCP_DR->CTPCP_RowId
FROM RB_Resource
WHERE (%ALPHAUP RES_CTPCP_DR->CTPCP_Desc %STARTSWITH %ALPHAUP :docDesc) 
AND 	(RES_CTLOC_DR->CTLOC_Desc %STARTSWITH :locDesc)
AND 	((RES_CTLOC_DR->CTLOC_Hospital_DR->HOSP_Desc = :hospdesc) OR (:hospdesc IS NULL))
ORDER BY RES_CTPCP_DR->CTPCP_Desc
}

/// log 62295 search by code too
Query LookUpEquipment(resdesc As %String, locdesc As %String) As %SQLQuery(CONTAINID = 0, ROWSPEC = "RESDesc:%String,CTLOCDesc:%String,HIDDEN:%String")
{
SELECT  RES_EQ_DR->EQ_Desc, RES_CTLOC_DR->CTLOC_Desc, RES_RowID
FROM SQLUser.RB_Resource
WHERE ((RES_EQ_DR->EQ_Desc %STARTSWITH %ALPHAUP :resdesc) OR (RES_EQ_DR->EQ_Code %STARTSWITH %ALPHAUP :resdesc))
AND (RES_CTLOC_DR->CTLOC_Desc %STARTSWITH :locdesc)
ORDER BY RES_CTLOC_DR->CTLOC_Desc, RES_EQ_DR->EQ_Desc
}

Query LookUpLocationByRes(rescDesc As %String, locDesc As %String, locType As %String, admType As %String, admDate As %String, Hospitals As %String, HospDesc As %String, userFlag As %String, RestrictDept As %String = "", EpisodeID As %String = "") As %Library.Query(CONTAINID = 0, ROWSPEC = "CTLOCCode:%String,CTLOCDesc:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,Hospital:%String,HIDDEN:%String")
{
}

Query zLookUpLocByResAdmType(rescDesc As %Library.String, locDesc As %Library.String, locType As %Library.String, admType As %String, admDate As %String, Hospitals As %String) As %Library.Query(CONTAINID = 0, ROWSPEC = "CTLOCCode:%Library.String,CTLOCDesc:%Library.String,HIDDEN:%Library.String,HIDDEN:%Library.String,HIDDEN:%Library.String,HIDDEN:%String")
{
}

Query LookUpLocationWL(rescDesc As %Library.String, locDesc As %Library.String) As %Library.Query(CONTAINID = 0, ROWSPEC = "CTLOCCode:%Library.String,CTLOCDesc:%Library.String,HIDDEN:%Library.String,HIDDEN:%Library.String")
{
}

/// AJI log 37966: needs to filter by hospDesc
Query LookUpLocationWLActive(rescDesc As %Library.String, locDesc As %Library.String, activedate As %Library.Date, hospDesc As %Library.String) As %Library.Query(CONTAINID = 0, ROWSPEC = "CTLOCCode:%Library.String,CTLOCDesc:%Library.String,HIDDEN:%Library.String,HIDDEN:%Library.String")
{
}

/// KM 19-Oct-2001: Updated this LookUp so that you can  now filter on Location Type 
/// (done for LookUp on RBDeptFuncPreferences.Custom which only wishes to show Location types that are Executed)
/// 
/// 
/// LOG 26886 BC 15-8-2002 Checking if the Resource had been end dated
/// 
/// This query has been changed from an SQL query to a fetch/Execute type query to allow 
/// for greater flexibility.  The date is now fed into the query to check that the doctor is
/// still assigned to the location.  If no date is fed in it assumes today's date.
Query LookUpOpRes(rescDesc As %String, locDesc As %String, date As %Date, surgeon As %String, anaeth As %String, ignore As %String) As %Library.Query(CONTAINID = 3, ROWSPEC = "RESDesc:%String,RESCode:%String,HIDDEN:%String,LOCDesc:%String,Hidden:%String")
{
}

/// one of many places used, but this is the lookup for pawaitinglist.edit and pawaitinglistinquiry.find 
/// rqg,Log29049: Fixed the query to include activedate.
/// KK 31/Oct/2002 Log 29266: included admitting rights  to filter criteria
Query LookUpPartialDoc(docDesc As %Library.String, locDesc As %Library.String, conFlag As %String, activedate As %Library.Date) As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "Doc:%String,Loc:%String")
{
SELECT RES_CTPCP_DR->CTPCP_Desc, RES_CTLOC_DR->CTLOC_Desc
FROM RB_Resource
WHERE (%ALPHAUP RES_CTPCP_DR->CTPCP_Desc [ %ALPHAUP :docDesc) 
AND (RES_CTLOC_DR->CTLOC_Desc %STARTSWITH :locDesc)
AND (RES_CTPCP_DR->CTPCP_SpecialistYN ='Y' OR :conFlag IS NULL)
AND ((RES_DateTo >= :activedate) OR (RES_DateTo IS NULL) OR (:activedate IS NULL))
AND ((RES_AdmittingRights ='Y') OR (RES_AdmittingRights IS NULL))
AND	((RES_CTPCP_DR->CTPCP_DateActiveTo >= :activedate) OR (RES_CTPCP_DR->CTPCP_DateActiveTo IS NULL) OR (:activedate IS NULL))
ORDER BY RES_CTPCP_DR->CTPCP_Desc
}

Query LookUpRadLoc(rescDesc As %Library.String, locDesc As %Library.String, BookingType As %Library.String) As %Library.Query(CONTAINID = 0, ROWSPEC = "RESDesc:%Library.String,CTLOCDesc:%Library.String,HIDDEN:%Library.String,HIDDEN:%Library.String")
{
}

/// KM 19-Oct-2001: Updated this LookUp so that you can  now filter on Location Type 
/// (done for LookUp on RBDeptFuncPreferences.Custom which only wishes to show Location types that are Executed)
/// 
/// 
/// LOG 26886 BC 15-8-2002 Checking if the Resource had been end dated
/// 
/// This query has been changed from an SQL query to a fetch/Execute type query to allow 
/// for greater flexibility.  The date is now fed into the query to check that the doctor is
/// still assigned to the location.  If no date is fed in it assumes today's date.
Query LookUpRes(rescDesc As %String, locDesc As %String, date As %Date, HCARowID As %String, HospIDs As %String, PatientID As %String, QLDOutChk As %String, locids As %String, TransAppt As %String) As %Query(CONTAINID = 3, ROWSPEC = "RESDesc:%String,RESCode:%String,HIDDEN:%String,HIDDEN:%String")
{
}

/// Log 51697 YC - Copied from LookUpByPartialCareProv and modified so that the lookup is restricted by
/// Restricted Care Providers from VB: CT->System Management->Users->Result Entry Care Provider Restrictions
/// Care providers are filtered by Location
/// If the code table does not have restricted care providers then it will do the same query as LookUpByPartialCareProvider
/// Used By: OETextResult.Edit -> Reporting Care Provider (TRCareProviderReportedDR) Lookup
Query LookUpByRestrCareProv(docDesc As %String, locDesc As %String, conFlag As %String, date As %Date, userFlag As %String, Hospitals As %String, LocIDs As %String, admtype As %String, locType As %String, time As %String, intType As %String, HOSPDesc As %String, flags As %String) As %Library.Query(CONTAINID = 0, ROWSPEC = "RESDesc:%String,code:%String,Location:%String,HIDDEN:%String,HIDDEN:%String,Hospital:%String,Responsible Unit:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String")
{
}

/// Log 56831 - 15.01.2007 
Query LookUpResourceByLoc(Res As %String, Loc As %String) As %Query(ROWSPEC = "RESDesc:%String,RESCode:%String,HIDDEN:%String")
{
}

}
