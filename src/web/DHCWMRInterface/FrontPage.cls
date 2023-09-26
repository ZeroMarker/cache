Import SQLUser

Class web.DHCWMRInterface.FrontPage Extends (%Library.RegisteredObject, websys.Abstract) [ Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 40;

ClassMethod QryFrontPageClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryFrontPageExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryFrontPageExecute(ByRef qHandle As %Binary, DateFrom As %String, DateTo As %String) As %Status
{
    Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	s:DateFrom["/" DateFrom=$zdh(DateFrom,4)
	s:DateFrom["-" DateFrom=$zdh(DateFrom,3)
	s:DateTo["/" DateTo=$zdh(DateTo,4)
	s:DateTo["-" DateTo=$zdh(DateTo,3)
	q:(DateFrom="")||(DateTo="") $$$OK
	
	//^DHCWMRFP(0,"DateTime",{RepDate},{RepTime},{RowId})
	f tmpDate=DateFrom:1:DateTo d
	.s tmpTime=0
	.f  s tmpTime=$o(^DHCWMRFP(0,"DateTime",tmpDate,tmpTime)) q:tmpTime=""  d
	..s FPRowid=0
	..f  s FPRowid=$o(^DHCWMRFP(0,"DateTime",tmpDate,tmpTime,FPRowid)) q:FPRowid=""  d
	...s FPInfo=$g(^DHCWMRFP(FPRowid))
	...s VolID=$p(FPInfo,"^",1)
	...q:VolID=""
	...s FPResume=$p(FPInfo,"^",2)
	...s FPUserID=$p(FPInfo,"^",3)
	...s:FPUserID'="" FPUserDesc=$p($g(^SSU("SSUSR",+FPUserID)),"^",2)
	...s FPDate=$p(FPInfo,"^",4)
	...s:FPDate'="" FPDate=$zd(FPDate,3)
	...s FPTime=$p(FPInfo,"^",5)
	...s:FPTime'="" FPTime=$zt(FPTime,2)
	...s VolInfo=$g(^DHCWMRVOL(+VolID))
	...s MainID=$p(VolInfo,"^",1)
	...s Paadm=$p(VolInfo,"^",2)
	...s VolIsActive=$p(VolInfo,"^",7)
	...q:VolIsActive'="Y"           //卷无效退出
	...s MainInfo=$g(^DHCWMRMAIN(+MainID))
	...q:$p(MainInfo,"^",6)'="Y"    //病案无效退出
	...
	...s Data=$lb(FPRowid,VolID,FPDate,FPTime,FPUserID,FPUserDesc,FPResume,Paadm)
	...s ^CacheTemp(repid,ind)=Data
	...s ind=ind+1
	
	
	Quit $$$OK
}

ClassMethod QryFrontPageFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryFrontPageExecute ]
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

/// ****************************************************************
/// 功能说明   : 查询已编目病案
/// 入参       : 
/// DateFrom   : 开始日期(编目日期)
/// DateTo     : 结束日期(编目日期)
/// 备注       : 
/// 程序调试   : d ##Class(%ResultSet).RunQuery("web.DHCWMRInterface.FrontPage","QryFrontPage",DateFrom,DateTo)
/// ****************************************************************
Query QryFrontPage(DateFrom As %String, DateTo As %String) As %Query(ROWSPEC = "FPRowid:%String,VolID:%String,FPDate:%String,FPTime:%String,FPUserID:%String,FPUserDesc:%String,FPResume:%String,Paadm:%String")
{
}

/// w ##Class(web.DHCWMRInterface.FrontPage).GetFPPaadmList(DateFrom,DateTo)
ClassMethod GetFPPaadmList(DateFrom As %String, DateTo As %String) As %Status
{
	n (DateFrom,DateTo)
	s Count=0
	
	s ds = ##class(%Library.ResultSet).%New("web.DHCWMRInterface.FrontPage:QryFrontPage")
	d ds.Execute(DateFrom,DateTo)
	while(ds.Next())
	{
		s Paadm=ds.Data("Paadm")           //就诊号
		s FPDate=ds.Data("FPDate")         //编码日期 2009-01-01
		q:FPDate=""
		s:FPDate'="" FPDate=$zdh(FPDate,3)
		s FPTime=ds.Data("FPTime")         //编码时间
		s FPUserID=ds.Data("FPUserID")     //编码员ID
		s FPUserDesc=ds.Data("FPUserDesc") //编码员
		
		s ^DHCStatInFace("StatInFace",FPDate,Paadm)=""    //统计组用Global,不允许修改
		s Count=Count+1
	}
	d ds.Close()
	
	q Count
}

}
