Include webimport

IncludeGenerator webimport

Class web.DHCUserGroup Extends (DHCDoc.Util.RegisteredObject, websys.Abstract) [ Inheritance = right ]
{

Parameter BUILD = 135;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "ID";

Parameter SQLDESCRIPTION = "ID";

Parameter SQLROWID = "ID";

ClassMethod QueryLocClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = QueryLocExecute ]
{
 // Clean up by purging the temporary node in ^CacheTemp global
 ;New repid
 Set repid=$li(QHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod QueryLocExecute(ByRef QHandle As %Binary, depname As %String, UserID As %String = "") As %Status
{
	;New repid, ind
	;New CTCode1,CTDesc1
 	Set repid=$I(^CacheTemp)
 	Set depname=$ZCVT(depname,"U")
 	s LogHospId=%session.Get("LOGON.HOSPID")
	s ind=1
	set myrowid=0
 	for  s myrowid=$o(^PAC("ADMLOC",0,"AdmType","O",myrowid)) q:myrowid=""  d
 	   .;q:(UserID'="")&&('$D(^User.DHCUserGroupI("UserLocDoc"," "_UserID," "_myrowid)))
 	   .;q:(UserID'="")&&('##class(web.DHCUserGroup).UserCanDo(UserID,myrowid))
 	   .s CTCode1=myrowid ;CTCode CTDesc
 	   .s CTDesc1=$p($g(^CTLOC(myrowid)),"^",2)
 	   .q:CTDesc1=""
 	   .//Quit:(CTDesc1'[depname)&&(depname'="")
 	   .s DepHosDr=##class(web.UDHCHospitalGroup).GetHospitalIDByLocID(myrowid)
	   .q:((LogHospId'=DepHosDr)&&(LogHospId'=""))
 	   .q:##class(web.DHCOPAdmReg).CheckLocDesc(myrowid,depname)'=1 
	    .s CTLocContactName=$P(^CTLOC(myrowid),"^",43)
 	   .Do OutputRow
 	for  s myrowid=$o(^PAC("ADMLOC",0,"AdmType","E",myrowid)) q:myrowid=""  d
 	   .;q:(UserID'="")&&('$D(^User.DHCUserGroupI("UserLocDoc"," "_UserID," "_myrowid)))
 	   .;q:(UserID'="")&&('##class(web.DHCUserGroup).UserCanDo(UserID,myrowid))
 	   .s DepHosDr=##class(web.UDHCHospitalGroup).GetHospitalIDByLocID(myrowid)
	   .q:((LogHospId'=DepHosDr)&&(LogHospId'=""))
 	   .s CTCode1=myrowid ;CTCode CTDesc
 	   .s CTDesc1=$p($g(^CTLOC(myrowid)),"^",2)
 	   .q:CTDesc1=""
 	   .//Quit:(CTDesc1'[depname)&&(depname'="")
 	   .q:##class(web.DHCOPAdmReg).CheckLocDesc(myrowid,depname)'=1 
	   .s CTLocContactName=$P(^CTLOC(myrowid),"^",43)
 	   .Do OutputRow
 	Set QHandle=$lb(0,repid,0)
 	
	Quit $$$OK
OutputRow
    s CTDesc1=##class(web.DHCOPAdmReg).LocDescFormate(CTDesc1)
	set Data=$lb(CTDesc1,CTCode1,CTLocContactName)
 	Set ^CacheTemp(repid,CTDesc1)=Data	
 	Set ind=ind+1
	quit
ResetVariables
	///set (repid)=0
	set (CTDesc1,CTCode1)=""
	quit
}

ClassMethod QueryLocFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryLocExecute ]
{
 ;New repid,ind
 Set AtEnd=$li(QHandle,1)
 Set repid=$li(QHandle,2)
 Set ind=$li(QHandle,3)

 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {	// if there are no more rows, finish fetching
 Set AtEnd=1
 Set Row=""
 }
 Else      {	// fetch row
 Set Row=^CacheTemp(repid,ind)
 }
 s QHandle=$lb(AtEnd,repid,ind)
 Quit $$$OK
}

ClassMethod delusr(name, group As %String, type As %Library.String = "") As %String
{
 	&sql(delete from DHCUserGroup
 	where UsegUsername=:name and UsegUsergroup=:group and UsegType=:type)

 	q:SQLCODE'=0 ""
 	q SQLCODE
}

ClassMethod delu(itmjs As %Library.String = "", itmjsex As %Library.String = "", name As %Library.String = "", group As %Library.String = "", type As %Library.String = "")
{

 	&sql(delete from DHCUserGroup where UsegUsername=:name and UsegUsergroup=:group and UsegType=:type)
	i SQLCODE=100 s SQLCODE=0

	if itmjs'=""{
		s retval=itmjs_"('"_$ZCVT(SQLCODE,"O","JS")_"');"
	    i itmjsex'="""" s retval=retval_itmjsex_"('"_$ZCVT(SQLCODE,"O","JS")_"');"
	    &javascript<#(retval)#>
	}
	q SQLCODE
}

ClassMethod insu(itmjs As %Library.String = "", itmjsex As %Library.String = "", name As %Library.String = "", group As %Library.String = "", doc As %Library.String = "", type As %Library.String = "")
{
	s ^insudhc=name_","_group_","_doc
 	&sql(insert into DHCUserGroup
 		(UsegUsername,UsegUsergroup,UsegFlag,UsegDoc,UsegType)
  		values(:name,:group,'0',:doc,:type)) 
  	if itmjs'=""{
		s retval=itmjs_"('"_$ZCVT(SQLCODE,"O","JS")_"');"
    	i itmjsex'="""" s retval=retval_itmjsex_"('"_$ZCVT(SQLCODE,"O","JS")_"');"
    	&javascript<#(retval)#>
  	}
	q SQLCODE
}

ClassMethod inusr(name, group, doc As %String, type As %Library.String = "") As %String
{
	&sql(insert into DHCUserGroup
 	(UsegUsername,UsegUsergroup,UsegFlag,UsegDoc,UsegType)
  	values(:name,:group,'0',:doc,:type)) 
 
 	q:SQLCODE'=0 ""
 	q SQLCODE
}

ClassMethod Fu(id, group, doc As %String) As %String
{
 &sql(select %id into 
 :docid from DHCUserGroup where 
 UsegUsername=:id and UsegUsergroup=:group and UsegDoc=:doc) 
 
 q:SQLCODE'=0 ""
 q docid
}

Query QueryLoc(depname As %String, UserID As %String = "") As %Query(ROWSPEC = "name:%String,id:%String,code:%String") [ SqlProc ]
{
}

Query Finduse() As %SQLQuery(CONTAINID = 1, ROWSPEC = "SSUSR_RowId:%String,SSUSR_Name:%String")
{

select SSUSR_RowId,SSUSR_Name from SS_User where 
 SSUSR_Group='6'
}

Query Finduse1OLD(Desc As %String = "") As %SQLQuery(CONTAINID = 1, ROWSPEC = "SSUSR_Name:%String,SSUSR_RowId:%String,SSUSR_Initials:%String")
{

select SSUSR_Name,SSUSR_RowId ,SSUSR_Initials from SS_User where 
 ((SSUSR_Name like '%'||:Desc||'%') or (:Desc is null) or (SSUSR_Initials =:Desc) or (SSUSR_Initials like '%'||:Desc||'%'))
}

Query Findusedoc(id) As %SQLQuery(CONTAINID = 1, ROWSPEC = "CTLOC_RowId:%String,CTLOC_Desc:%String")
{
select  distinct CTLOC_RowId,CTLOC_Desc
 from CT_Loc,DHCUserGroup where 
CTLOC_RowId=DHCUserGroup.UsegUsergroup and 
DHCUserGroup.UsegUsername=:id
}

Query Fusedoc(id, group) As %SQLQuery(CONTAINID = 1, ROWSPEC = "UsegDoc:%String")
{
select UsegDoc into 
 :docid from DHCUserGroup where 
 UsegUsername=:id and UsegUsergroup=:group
}

// w ##class(web.DHCUserGroup).GetLocInfo(1,"","USE","REG",3)

ClassMethod GetLocInfo(User, Desc, Type, license As %String = "", loghosp As %String = "")
{
	s ^TempGetLocInfoSub=User_","_Desc_","_Type_","_license_","_loghosp
	s ret=""
	s loghosp=##class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(loghosp)
	i Desc'="" s Desc=$ZCVT(Desc,"U")
	i license'="" s license=$ZCVT(license,"U")
	else  s license="REG"
	if Type="ALL" {
		d GetAllDep
	}else{
		s locid=" "
		f  s locid=$O(^User.DHCUserGroupI("UserLocDoc"," "_license," "_User,locid)) q:locid=""  d
		.s loc=$P(locid," ",2)
		.s cthosp=$P(^CTLOC(loc),"^",22)
		.Q:cthosp'=loghosp
		.s locDesc=$P(^CTLOC(loc),"^",2)
		.q:(locDesc'[Desc)&&(Desc'="")
		.i ret="" d
		..s ret=locDesc_$C(1)_loc_$C(1)_"0"
		.e  d
		..s ret=ret_$C(2)_locDesc_$C(1)_loc_$C(1)_"0"
	}

	q ret
	//过滤已有权限科室
GetAllDep
		s locid=0	
		f  s locid=$o(^PAC("ADMLOC",0,"AdmType","O",locid)) q:locid=""  d
		.q:(##class(web.DHCUserGroup).UserCanDo(User,locid,"","ALL",license))
		.s cthosp=$P(^CTLOC(locid),"^",22)
		.q:(loghosp'="")&&(loghosp'=cthosp)
		.s locDesc=$P(^CTLOC(locid),"^",2)
		.s OrtherName=$P(^CTLOC(locid),"^",43)
		.s HospId=$P(^CTLOC(locid),"^",22)
		.q:(locDesc'[Desc)&&(OrtherName'[Desc)&&(Desc'="")
		.//q:HospId'=$p(^SSU("SSUSR",User),"^",98)
		.i ret="" d
		..s ret=locDesc_$C(1)_locid_$C(1)_"0"
		.e  d
		..s ret=ret_$C(2)_locDesc_$C(1)_locid_$C(1)_"0"
		s locid=0	
		f  s locid=$o(^PAC("ADMLOC",0,"AdmType","E",locid)) q:locid=""  d
		.q:(##class(web.DHCUserGroup).UserCanDo(User,locid,"","ALL",license))
		.s cthosp=$P(^CTLOC(locid),"^",22)
		.q:(loghosp'="")&&(loghosp'=cthosp)
		.s locDesc=$P(^CTLOC(locid),"^",2)
		.q:(locDesc'[Desc)&&(Desc'="")
		.i ret="" d
		..s ret=locDesc_$C(1)_locid_$C(1)_"0"
		.e  d
		..s ret=ret_$C(2)_locDesc_$C(1)_locid_$C(1)_"0"
        q ""
}

// w ##class(web.DHCUserGroup).GetDocInfo("1952","1","res")

ClassMethod GetDocInfo(UserID As %Library.String = "", LocID As %Library.String = "", QType As %String = "", Type As %String = "", HospID = "")
{
	
	s HospID=##class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(HospID)
	;s ^UserGetDocInfo=UserID_","_LocID_","_type
	s ret=""
	set RowId=0
	f  Set RowId=$o(^RB("RES",0,"CTLOC",LocID,RowId)) quit:RowId=""  d
	.Set DocDr=$p(^RB("RES",RowId),"^",2)
	.q:DocDr=""
	.q:'$d(^CTPCP(DocDr,1))
	.Q:"N"=##class(DHCDoc.Common.Hospital).GetHospShowDataFlag("CT_CareProv",DocDr,HospID)
	.s DateActiveFrom=$p(^RB("RES",RowId),"^",22)
	.Q:(DateActiveFrom'="")&&(DateActiveFrom>+$h)
	.s DateActiveTo=$p(^RB("RES",RowId),"^",23)
	.Q:(DateActiveTo'="")&&(DateActiveTo<=..%SysDate())
	.set ActiveFlag=$p($g(^CTPCP(DocDr,1)),"^",9)
	.q:ActiveFlag'="Y"
	.set ScheSt=$p(^RB("RES",RowId),"^",6)
	.set desc=$p(^RB("RES",RowId),"^",17)
	.if (ScheSt'="Y") Quit
	.s flag=0
	.s:##class(web.DHCUserGroup).UserCanDo(UserID,LocID,DocDr,"",Type) flag=1
 	.i ret=""  d 
 	..s ret=desc_$C(1)_DocDr_$C(1)_flag
	.e  d 
 	..s ret=ret_$C(2)_desc_$C(1)_DocDr_$C(1)_flag
	
	s ^tmpgry("GetDocInfo")=ret
	q ret
}

/// ##class(web.DHCUserGroup).UserCanDo(user,loc,doc)
ClassMethod UserCanDo(UserID As %String = "", LocID As %String = "", DocID As %String = "", QType As %String = "", Type As %String = "")
{
	s UCret=1
	if Type="" s Type="REG"
	s Type=$zcvt(Type,"U")
	q:(QType="ALL")&&($d(^User.DHCUserGroupD("super",UserID))) 0
	q:$d(^User.DHCUserGroupD("super",UserID)) 1
	q:UserID="" UCret
	i DocID="" d
	.s UCret=$D(^User.DHCUserGroupI("UserLocDoc"," "_Type," "_UserID," "_LocID))
	e  d
	.s UCret=$D(^User.DHCUserGroupI("UserLocDoc"," "_Type," "_UserID," "_LocID," "_DocID))
	q UCret
}

/// 保存为超级权限
/// 护士加号权限配置数据与排班权限管理配置数据 存储到User.DHCUserGroup.cls 表中，以UsegType做区分
/// 超级权限请做本地化处理
ClassMethod SaveForSuper(UserID, Type As %String = "")
{
	s ^SaveForSuper=UserID
	q:UserID=""

	i $d(^User.DHCUserGroupD("super",UserID)){ 
		k ^User.DHCUserGroupD("super",UserID)
		q ""
	}
	s:$d(^User.DHCUserGroupD("super",UserID))=0 ^User.DHCUserGroupD("super",UserID)=""
	q ""
}

/// 是否为超级权限
/// 护士加号权限配置数据与排班权限管理配置数据 存储到User.DHCUserGroup.cls 表中，以UsegType做区分
/// 超级权限请做本地化处理
ClassMethod IsSuperConfig(UserID, Type As %String = "")
{
	s ^IsSuperConfig=UserID_","_Type
	q:UserID=""
	q $d(^User.DHCUserGroupD("super",UserID))
}

/*Query Finduse1(Desc As %String = "", HOSPID As %String = "") As %SQLQuery(CONTAINID = 1, ROWSPEC = "SSUSR_Name:%String,SSUSR_RowId:%Integer,SSUSR_Initials:%String")
{

select SSUSR_Name,SSUSR_RowId ,SSUSR_Initials from SS_User where 
 ((SSUSR_Name like '%'||:Desc||'%') or (:Desc is null) or (SSUSR_Initials =:Desc) or (SSUSR_Initials like '%'||:Desc||'%')) and SSUSR_Active='Y' and (SSUSR_Hospital_DR=:HOSPID or (:HOSPID is null))
}*/
ClassMethod Finduse1Close(ByRef qHandle As %Binary) As %Status [ PlaceAfter = Finduse1Execute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod Finduse1Execute(ByRef qHandle As %Binary, Desc As %String = "", HOSPID As %String = "") As %Status
{
 	Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1
    s HOSPID=##class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(HOSPID)
	s USRName="",USRRowId="",USRInitials=""
	//Do OutputRow3
	s USRRowId=""
	f  s USRRowId=$o(^SSU("SSUSR",USRRowId)) q:USRRowId=""  d
	.s SSUSRHospitalDR=$p($g(^SSU("SSUSR",USRRowId)),"^",98)
	.Q:"N"=##class(DHCDoc.Common.Hospital).GetHospShowDataFlag("SS_User",USRRowId,HOSPID)
	.s USRActive=$p(^SSU("SSUSR",USRRowId),"^",19)
	.q:USRActive'="Y"
	.s Datefrom=$p(^SSU("SSUSR",USRRowId),"^",96)
	.s DateTo=$p(^SSU("SSUSR",USRRowId),"^",97)
	.q:(Datefrom'="")&&(Datefrom>+$H)
	.q:(DateTo'="")&&(DateTo<+$H)
	.s USRName=$p(^SSU("SSUSR",USRRowId),"^",2)
	.s USRInitials=$p(^SSU("SSUSR",USRRowId),"^",1)
	.q:(Desc'="")&(USRName'[Desc)&(USRInitials'[Desc)
 	.Do OutputRow3
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
OutputRow3   
	set Data=$lb(USRName,USRRowId,USRInitials)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod Finduse1Fetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = Finduse1Execute ]
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

Query Finduse1(Desc, HOSPID As %String = "") As %Query(ROWSPEC = "SSUSR_Name:%String,SSUSR_RowId:%Integer,SSUSR_Initials:%String")
{
}

/// d ##class(%ResultSet).RunQuery("web.DHCUserGroup","FindLogonLocDoc","63")
Query FindLogonLocDoc(LogLoc As %String, Desc As %String = "") As %SQLQuery(CONTAINID = 1, ROWSPEC = "CTPCPDesc:%String,CTPCPDr:%String,Alias:%String")
{
	SELECT SSUSR_CareProv_DR->CTPCP_Desc, SSUSR_CareProv_DR->CTPCP_RowId,SSUSR_Initials FROM SS_User 
	WHERE SSUSR_RowId IN (
		SELECT OTHLL_ParRef FROM SS_UserOtherLogonLoc WHERE OTHLL_CTLOC_DR=:LogLoc 
			and (OTHLL_StartDate is null or OTHLL_StartDate <= {fn CURDATE()})
			and (OTHLL_EndDate is null or OTHLL_EndDate >= {fn CURDATE()})
		union
		SELECT SSUSR_RowId FROM SS_User WHERE SSUSR_DefaultDept_DR=:LogLoc
	) AND SSUSR_CareProv_DR IS NOT null and :LogLoc  is not null
	and (
	((SSUSR_Name like '%'||:Desc||'%') or (:Desc is null) or (SSUSR_Initials =:Desc) or (SSUSR_Initials like '%'||:Desc||'%'))
	)
}

ClassMethod FindLogonLocDocNewClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = FindLogonLocDocNewExecute ]
{
	// Clean up by purging the temporary node in ^CacheTemp global
	//New repid
	Set repid=$li(QHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// d ##class(%ResultSet).RunQuery("web.DHCUserGroup","FindLogonLocDocNew","27","")
ClassMethod FindLogonLocDocNewExecute(ByRef QHandle As %Binary, LogLoc As %String, Desc As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	s ^tempqujian("FindLogonLocDocNew")=$LB(LogLoc, Desc)
	if (LogLoc=""){
		Set QHandle=$lb(0,repid,0)
		Quit $$$OK	
	}
	Set langid=..%LanguageID()
	s ind=1
	s USRRowId=""
	for {
		s USRRowId=$O(^SSU("SSUSR",USRRowId))
		q:USRRowId=""
		s LocFlag=0
		s SubOTHLLRowid=""
		for {
			s SubOTHLLRowid=$O(^SSU("SSUSR",USRRowId,"OTHLL",SubOTHLLRowid))
			q:SubOTHLLRowid=""
			s OTHLLCTLOCDR=$P(^SSU("SSUSR",USRRowId,"OTHLL",SubOTHLLRowid),"^",1)
			s StartDate=$P(^SSU("SSUSR",USRRowId,"OTHLL",SubOTHLLRowid),"^",4)
			s EndDate=$P(^SSU("SSUSR",USRRowId,"OTHLL",SubOTHLLRowid),"^",5)
			continue:((StartDate'="")&&(StartDate>+$H))
			continue:((EndDate'="")&&(EndDate<+$H))
			if (OTHLLCTLOCDR=LogLoc) s LocFlag=1
		}
		continue:LocFlag=0
		s CareProvDr=$P(^SSU("SSUSR",USRRowId),"^",14)
		continue:CareProvDr=""
		s CTPCPDesc=$p($g(^CTPCP(CareProvDr,1)),"^",2)
		s SSUSRInitials=$P(^SSU("SSUSR",USRRowId),"^",1)
		continue:((Desc'="")&&(CTPCPDesc'[Desc)&&(SSUSRInitials'[Desc))
		Set CTPCPDesc= ##class(User.CTCareProv).GetTranByDesc("CTPCPDesc",CTPCPDesc,langid)
		set Data=$lb(CTPCPDesc,CareProvDr,SSUSRInitials)
		Set ^CacheTemp(repid,ind)=Data	
		Set ind=ind+1 
	}
	
	Set QHandle=$lb(0,repid,0)
	Quit $$$OK
}

ClassMethod FindLogonLocDocNewFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindLogonLocDocNewExecute ]
{
	//New repid,ind
	Set AtEnd=$li(QHandle,1)
	Set repid=$li(QHandle,2)
	Set ind=$li(QHandle,3)
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {	// if there are no more rows, finish fetching
		 Set AtEnd=1
		 Set Row=""
	}
	Else      {	// fetch row
		Set Row=^CacheTemp(repid,ind)
	}
	s QHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

Query FindLogonLocDocNew(LogLoc As %String, Desc As %String = "") As %Query(ROWSPEC = "CTPCPDesc:%String,CTPCPDr:%String,Alias:%String") [ SqlProc ]
{
}

ClassMethod QryLocInfoClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = QryLocInfoExecute ]
{
	// Clean up by purging the temporary node in ^CacheTemp global
	//New repid
	Set repid=$li(QHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// d ##class(%ResultSet).RunQuery("web.DHCUserGroup","QryLocInfo","1","","ALL","res",2)
ClassMethod QryLocInfoExecute(ByRef QHandle As %Binary, User As %String, Desc As %String, Type As %String, license As %String = "", loghosp As %String = "") As %Status
{
	s ^tmpnk("QryLocInfoExecute")=User_","_Desc_","_Type_","_license_","_loghosp
	Set repid=$I(^CacheTemp)
	if (User=""){
		Set QHandle=$lb(0,repid,0)
		Quit $$$OK	
	}
	s ind=1
	s ret=..GetLocInfo(User,Desc,Type,license,loghosp)	
	s retlen=$l(ret,$c(2))
	for myic=1:1:retlen{
		d ResetVariables1
		s oneret=$p(ret,$c(2),myic)
		s RowId=$p(oneret,$c(1),2)
		s DeptDesc=$p(oneret,$c(1),1)
		s DeptDescPY=##class(web.DHCINSUPort).GetCNCODE(DeptDesc,4,"")
		s OutputBeforeSort(DeptDescPY,RowId)=DeptDesc
	}
	s DeptDescPY=""
	f  s DeptDescPY=$o(OutputBeforeSort(DeptDescPY)) q:DeptDescPY=""  d
	.s RowId=""
	.f  s RowId=$o(OutputBeforeSort(DeptDescPY,RowId)) q:RowId=""  d
	..s DeptDesc=OutputBeforeSort(DeptDescPY,RowId)
	..d OutputRow1
	Set QHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow1
	set Data=$lb(DeptDesc,RowId)
	Set ^CacheTemp(repid,ind)=Data	
	Set ind=ind+1
	quit
ResetVariables1
	set (DeptDesc,RowId)=""
	quit
}

ClassMethod QryLocInfoFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryLocInfoExecute ]
{
	//New repid,ind
	Set AtEnd=$li(QHandle,1)
	Set repid=$li(QHandle,2)
	Set ind=$li(QHandle,3)
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {	// if there are no more rows, finish fetching
		 Set AtEnd=1
		 Set Row=""
	}
	Else      {	// fetch row
		Set Row=^CacheTemp(repid,ind)
	}
	s QHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

Query QryLocInfo(User As %String, Desc As %String, Type As %String, license As %String = "", loghosp As %String = "") As %Query(ROWSPEC = "Desc:%String,RowID:%String") [ SqlProc ]
{
}

ClassMethod Finduse2Close(ByRef qHandle As %Binary) As %Status [ PlaceAfter = Finduse2Execute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod Finduse2Execute(ByRef qHandle As %Binary, Desc As %String = "", loghosp As %String = "") As %Status
{
 	Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1
	s USRName="",USRRowId="",USRInitials=""
	s USRRowId=""
	f  s USRRowId=$o(^SSU("SSUSR",USRRowId)) q:USRRowId=""  d
	.s USRActive=$p(^SSU("SSUSR",USRRowId),"^",19)
	.Q:USRActive'="Y"
	.s USRName=$p(^SSU("SSUSR",USRRowId),"^",2)
	.s USRInitials=$p(^SSU("SSUSR",USRRowId),"^",1)
	.Q:(USRName'="")&(USRName'[Desc)&(USRInitials'[Desc)
	.s findhosp=0
	.s OTHLLChildsub=""
	.for  s OTHLLChildsub=$O(^SSU("SSUSR",USRRowId,"OTHLL",OTHLLChildsub)) q:(OTHLLChildsub="")!(findhosp=1)  D
	..s OTHLLHospitalDR=$p(^SSU("SSUSR",USRRowId,"OTHLL",OTHLLChildsub),"^",3)
	..if OTHLLHospitalDR=loghosp s findhosp=1
	.Q:(loghosp'="")&&(findhosp=0)
 	.Do OutputRow3
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow3   
	set Data=$lb(USRName,USRRowId,USRInitials)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod Finduse2Fetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = Finduse2Execute ]
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

Query Finduse2(Desc As %String = "", loghosp As %String = "") As %Query(ROWSPEC = "SSUSR_Name:%String,SSUSR_RowId:%Integer,SSUSR_Initials:%String")
{
}

/// d ##class(%ResultSet).RunQuery("web.DHCUserGroup","QueryScheduleGranted","238","","")
Query QueryScheduleGranted(UserId As %String, LocId As %String, MarkId As %String) As websys.Query(CONTAINID = 0, ROWSPEC = "id:%String,userId:%String,userName:%String,locId:%String,locDesc:%String,docId:%String,docDesc:%String")
{
}

ClassMethod QueryScheduleGrantedExecute(ByRef qHandle As %Binary, UserId As %String, LocId As %String, MarkId As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	if (UserId="")&&(LocId="")&&(MarkId=""){
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	if (UserId'="") {
		s id=0
		for {
			s id=$o(^User.DHCUserGroupI("UserNamedr"," "_UserId,id)) Q:id=""
			d GetOutPutData(UserId,id)
		}		
	}else{
		s userId=0
		for {
			s userId=$o(^SSU("SSUSR",userId)) Q:userId=""
			s id=0
			for {
				s id=$o(^User.DHCUserGroupI("UserNamedr"," "_UserId,id)) Q:id=""
				d GetOutPutData(UserId,id)
			}
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
OutputRow21
	Set ^CacheTemp(repid,ind)=$LB(id,userId,userName,locId,locDesc,docId,docDesc)
	Set ind=ind+1
	quit
GetOutPutData(userId,id)
  s userName=$p(^SSU("SSUSR",userId),"^",2)
  s docId=$lg(^User.DHCUserGroupD(id),2)
  Q:(MarkId'="")&&(docId'=MarkId)
  s docDesc=$p(^CTPCP(docId,1),"^",2)
  s locId=$lg(^User.DHCUserGroupD(id),4)
  Q:(LocId'="")&&(locId'=LocId)
  s locDesc=$p(^CTLOC(locId),"^",2)
  s type=$lg(^User.DHCUserGroupD(id),6)
  Q:type'="REG"
  d OutputRow21
  Q
}

ClassMethod SaveScheduleGranted(id As %Library.String = "", userid As %Library.String = "", locid As %Library.String = "", docid As %Library.String = "", type As %Library.String = "")
{
	s UsegType="REG"
	if (type="Add") {
		&sql(select * from DHCUserGroup where UsegUsername=:userid and UsegUsergroup=:locid and UsegDoc=:docid and UsegType=:UsegType)
	  	Q:SQLCODE=0 "-2"
		&sql(insert into DHCUserGroup
	 		(UsegUsername,UsegUsergroup,UsegFlag,UsegDoc,UsegType)
	  		values(:userid,:locid,'0',:docid,:UsegType)) 
	}else{
		&sql(delete DHCUserGroup where ID=:id) 
	}
 	q SQLCODE
}

}
