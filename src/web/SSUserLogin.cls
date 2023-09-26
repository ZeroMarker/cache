/// webimport
Class web.SSUserLogin Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 115;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "LOG_RowId";

Parameter SQLDESCRIPTION = "LOG_RowId";

Parameter SQLROWID = "LOG_RowId";

Property dummy As %String(TRUNCATE = 1);

ClassMethod GetLastLogon(userid As %Library.String, ByRef date As %Library.Date, ByRef time As %Library.Time)
{
}

/// by wuqk 2011-06-30
ClassMethod Insert(userid As %Library.String, locid As %Library.String = "", groupid As %Library.String = "", postid = "") As %Library.String
{
	n obj
	if (groupid=""),$d(%session),$d(%session.Data("LOGON.GROUPID")){ //wanghc 增加默认值,增加功能不用修改登录类2019-03-26
		Set groupid = $g(%session.Data("LOGON.GROUPID"))
	}
	s obj=##class(User.SSUserLogin).%New()
	D obj.LOGUserDRSetObjectId(userid)
	s obj.LOGLogonDate=+$h
	s obj.LOGLogonTime=$p($h,",",2)
	if groupid>0,$d(^SSU("SSGRP",groupid)) d obj.LOGGroupDRSetObjectId(groupid)  //cryze 2018-2-26
	do obj.%Save()
	if obj.%Id()>0 {
		s $p(^SST("LOG",obj.%Id()),"^",7) = locid	;增加登陆科室的信息 周志强 2013.04.12
		//s $p(^SST("LOG",obj.%Id()),"^",10) = groupid	;增加登陆安全组的信息 2017-11-1  //2018-2-26 group做索引，所以不能通过此种方式了
		s $p(^SST("LOG",obj.%Id()),"^",11) = postid	; 增加登录岗位id wanghc 2022.12.27
	}
	quit obj.%Id()
}

/// by wuqk 2011-06-30
ClassMethod SaveLogoffDateTime(id As %Library.String)
{
	n obj
	s obj=##class(User.SSUserLogin).%OpenId(id)
	q:'$IsObject(obj)
	s obj.LOGLogoffDate=+$h
	s obj.LOGLogoffTime=$p($h,",",2)
	do obj.%Save()
	q
}

/// rqg,Log23367: Query to select location and Group using Username
Query LookUpSelectedUser(User As %Library.String) As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "Loc:%String,Group:%String")
{
SELECT  OTHLL_CTLOC_DR->CTLOC_Desc, OTHLL_UserGroup_DR->SSGRP_Desc
FROM  SQLUser.SS_UserOtherLogonLoc
WHERE  (%ALPHAUP OTHLL_ParRef->SSUSR_Name [ %ALPHAUP :User) 
ORDER BY OTHLL_CTLOC_DR->CTLOC_Desc
}

/// d ##class(%ResultSet).RunQuery("web.SSUserLogin","FindUser","2016-12-28")
Query FindUser(IndexDate As %String) As %Query(ROWSPEC = "UserName:%String,Date:%String,Time:%String")
{
}

ClassMethod FindUserExecute(ByRef qHandle As %Binary, IndexDate As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	
	Set ^qinhao=IndexDate
   	if IndexDate="" Set IndexDate=+$h
   	//else  Set IndexDate=$ZDH(IndexDate,3)
   	
   	Set UserDr="" 
   	For  Set UserDr=$o(^SST("LOG",0,"Date",IndexDate,UserDr)) Quit:UserDr=""  do
   	.Set LogRowId=""
   	.For  Set LogRowId=$o(^SST("LOG",0,"Date",IndexDate,UserDr,LogRowId)) Quit:LogRowId=""  do
   	..Set LogInfo=$g(^SST("LOG",LogRowId))
   	..Set UserDr=$p(LogInfo,"^",1)
   	..Set UserName=$p(^SSU("SSUSR",UserDr),"^",2)
   	..Set Date=$p(LogInfo,"^",3)
   	..Set Time=$p(LogInfo,"^",4)
   	..Set data = $lb(UserName,$ZD(Date,3),$ZT(Time))
   	..d outputrow
	
	s qHandle=$lb(0,repid,0)
	Quit $$$OK
outputrow
	
	set ^CacheTemp(repid,ind)=data
	set ind=ind+1
	q
}

ClassMethod FindUserFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindUserExecute ]
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
	 s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindUserClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindUserExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

}
