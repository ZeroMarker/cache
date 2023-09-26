/// CTOR: QP
/// DATE: 2020-09-08
/// DESC: 项目
Class DHCDoc.GCPSW.CFG.Prj Extends %RegisteredObject [ ProcedureBlock ]
{

/// CTOR: QP
/// DATE: 2020-09-08
/// DESC: 保存
/// IN  : 
/// OUT : 
/// EXEC: w ##class(DHCDoc.GCPSW.CFG.Prj).Save("903||1")
ClassMethod Save(mList)
{
	s mRtn=0
	s id=$p(mList,"^",1)
	s code=$p(mList,"^",2)
	s desc=$p(mList,"^",3)
	s note=$p(mList,"^",4)
	s user=$p(mList,"^",5)
	s startDate=$p(mList,"^",6)
	s endDate=$p(mList,"^",7)
	s PPRowId=$p(mList,"^",8)
	s startDate=##class(DHCDoc.GCPSW.COM.Func).DateHtmlToLogical(startDate)
	s endDate=##class(DHCDoc.GCPSW.COM.Func).DateHtmlToLogical(endDate)
	s isDateOK=..IsDateOK(startDate,endDate)
	q:isDateOK=0 "-3"
	i id="" {
		s a=##class(User.GCPSWPrj).%New()
		d a.PAddUserSetObjectId(user)
		d a.PPPRowIdSetObjectId(PPRowId)
		s a.PAddDate=+$h
		s a.PAddTime=$p($h,",",2)
		i $d(^CF.DOC.GCPSW.PrjI("Prj","PCode",code)) {
			;Q -2
		}
	} else {
		s a=##class(User.GCPSWPrj).%OpenId(id)
		s oldCode=a.PCode
		i $d(^CF.DOC.GCPSW.PrjI("Prj","PCode",code)) {
			i oldCode'=code {
				;Q -2	
			}
		}
	}
	s a.PCode=code
	s a.PDesc=desc
	s a.PNote=note
	s a.PStartDate=startDate
	s a.PEndDate=endDate
	s sc=a.%Save()
	If $$$ISERR(sc) {
		//d $system.OBJ.DisplayError(sc) 
		s mRtn=-101
	} else {
		s mRtn=a.%Id()
	}
	d a.%Close()
	
	Q mRtn
}

/// CTOR: QP
/// DATE: 2020-11-18
/// DESC: 判断日期是否满足要求
/// / 		目前规定：筛选日期控制半年
/// IN  : 
/// OUT : 1 满足要求，0不满足要求
/// EXEC: w ##class(DHCDoc.GCPSW.CFG.Prj).DeleteTPL("")
ClassMethod IsDateOK(startDate, endDate)
{
	s OK=1,NO=0	
	Q:(startDate="")||(endDate="") NO
	Q:(startDate>endDate) NO
	i ((endDate-startDate)>182) {
		Q NO	
	}
	
	Q OK
}

/// CTOR: QP
/// DATE: 2020-09-08
/// DESC: 删除
/// IN  : 
/// OUT : 
/// EXEC: w ##class(DHCDoc.GCPSW.CFG.Prj).DeleteTPL("")
ClassMethod Delete(PID As %String)
{
	Q:PID="" 0
	&SQL(DELETE FROM SQLUser.GCPSW_Prj WHERE P_ID=:PID)
	Q:SQLCODE'=0 -102
	
	Q 0
}

/// CTOR: QP
/// DATE: 2020-09-08
/// DESC: 完成项目
/// IN  : 
/// OUT : 
/// EXEC: w ##class(DHCDoc.GCPSW.CFG.Prj).DeleteTPL("")
ClassMethod OKProject(PID As %String)
{
	Q:PID="" 0
	s status="U"
	&SQL(UPDATE SQLUser.GCPSW_Prj SET P_Status=:status WHERE P_ID=:PID)
	Q:SQLCODE'=0 -103
	
	Q 0
}

/// CTOR: QP
/// DATE: 2020-09-08
/// DESC: 设置团队成员可见
/// IN  : 
/// OUT : 
/// EXEC: w ##class(DHCDoc.GCPSW.CFG.Prj).DeleteTPL("")
ClassMethod TeamView(PID As %String, TeamView)
{
	Q:PID="" 0
	&SQL(UPDATE SQLUser.GCPSW_Prj SET P_TeamView=:TeamView WHERE P_ID=:PID)
	Q:SQLCODE'=0 -104
	
	Q 0
}

/// CTOR: QP
/// DATE: 2020-09-03
/// DESC: 查询模板类型
/// IN  : 
/// OUT :    
/// EXEC: d ##class(%ResultSet).RunQuery("DHCDoc.GCPSW.CFG.Prj","QryPrj",716)
Query QryPrj(UserID = "") As %Query(ROWSPEC = "id,code,desc,note,startDate,endDate,PPRowId,addDate,gcpName,statusCode,status,teamView,addUser,isEdit")
{
}

ClassMethod QryPrjExecute(ByRef qHandle As %Binary, UserID = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	Set ind=1
 	s id=""
 	f  s id=$o(^CF.DOC.GCPSW.PrjD(id),-1) q:id=""  d
 	.s code=$p(^CF.DOC.GCPSW.PrjD(id),"^",1)
 	.s desc=$p(^CF.DOC.GCPSW.PrjD(id),"^",2)
 	.s startDate=$p(^CF.DOC.GCPSW.PrjD(id),"^",3)
 	.s endDate=$p(^CF.DOC.GCPSW.PrjD(id),"^",4)
 	.s PPRowId=$p(^CF.DOC.GCPSW.PrjD(id),"^",5)
 	.s teamView=$p(^CF.DOC.GCPSW.PrjD(id),"^",11)
 	.s addUser=$p(^CF.DOC.GCPSW.PrjD(id),"^",8)
 	.s isEdit=##class(DHCDoc.GCPSW.COM.Func).IsEdit(UserID,addUser)
 	.s flag=##class(DHCDoc.GCPSW.COM.Func).IsPITeam(UserID,PPRowId,teamView,addUser)
 	.q:flag=0
 	.i addUser'="" s addUser=$p(^SSU("SSUSR",addUser),"^",2)
 	.s gcpName=$p(^DHCDocPP(PPRowId),"^",2)
 	.s addDate=$p(^CF.DOC.GCPSW.PrjD(id),"^",6)
 	.s addTime=$p(^CF.DOC.GCPSW.PrjD(id),"^",7)
 	.s addDate=##class(DHCDoc.GCPSW.COM.Func).DateLogicalToHtml(addDate)
 	.s startDate=##class(DHCDoc.GCPSW.COM.Func).DateLogicalToHtml(startDate)
 	.s endDate=##class(DHCDoc.GCPSW.COM.Func).DateLogicalToHtml(endDate)
 	.s note=$p(^CF.DOC.GCPSW.PrjD(id),"^",9)
 	.s statusCode=$p(^CF.DOC.GCPSW.PrjD(id),"^",10)
 	.s status=..GetStatusDesc(statusCode)
 	
 	.d output1
 	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
output1
	Set Data=$lb(id,code,desc,note,startDate,endDate,PPRowId,addDate,gcpName,statusCode,status,teamView,addUser,isEdit)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Quit $$$OK
}

ClassMethod QryPrjClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryPrjExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryPrjFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryPrjExecute ]
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
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// CTOR: QP
/// DATE: 2020-12-16
/// DESC: 得到项目状态
/// IN  : 
/// OUT : 
/// EXEC: w ##class(DHCDoc.GCPSW.CFG.Prj).DeleteTPL("")
ClassMethod GetStatusDesc(code As %String)
{
	s mRtn="未完成"
	i code="U" s mRtn="完成"
	
	Q mRtn
}

}
