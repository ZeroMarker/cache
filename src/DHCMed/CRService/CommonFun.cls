Import SQLUser

Class DHCMed.CRService.CommonFun Extends (%Persistent, DHCMed.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 11;

ClassMethod admdeplookupClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = admdeplookupExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod admdeplookupExecute(ByRef qHandle As %Binary, desc As %String) As %Status
{
    Set repid=$I(^CacheTemp)
	s ind=1
	Set qHandle=$lb(0,repid,0)
	s desc=$$ALPHAUP^SSUTIL4(desc)   //$$ALPHAUP^SSUTIL4(desc)
	s rowid=0
	f  s rowid=$o(^CTLOC(rowid)) q:rowid=""  d
    .q:$p($g(^CTLOC(rowid)),"^",13)'="E"
    .s Desc=$p($g(^CTLOC(rowid)),"^",2)
    .q:(desc'="")&&(Desc'[desc)
    .s ContactName=$p($g(^CTLOC(rowid)),"^",43)
    .s:ContactName["-" ContactName=$p(ContactName,"-",1)
    .d OutputRow
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set Data=$lb(rowid,Desc,ContactName)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod admdeplookupFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = admdeplookupExecute ]
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

/// Creator：    cjb
/// CreatDate：  2010-02-24
/// Description：查询科室Query
/// Table：      
/// Input：  	 desc：科室描述  
/// Output：     dep,depid,ContactName
Query admdeplookup(desc As %String) As %Query(ROWSPEC = "depid:%String,dep:%String,ContactName:%String")
{
}

ClassMethod ClinStatusClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = ClinStatusExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod ClinStatusExecute(ByRef qHandle As %Binary) As %Status
{
    Set repid=$I(^CacheTemp)
	s ind=1
	Set qHandle=$lb(0,repid,0)
	s Rowid=0
	s s="D^待审^"
    d BuildData
    s s="Y^已审^"
    d BuildData
    s s="R^退回^"
    d BuildData
	Quit $$$OK
BuildData
	//set Data=$lb(Rowid,code,desc)
	set Data=$lb("")
 	f iBuild=1:1:3 d
 	.s $li(Data,iBuild)=$p(s,"^",iBuild)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod ClinStatusFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = ClinStatusExecute ]
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

/// Creator：    cjb
/// CreatDate：  2010-02-24
/// Description：查临床报告状态字典
/// Table：      
/// Input：  	  
/// Output：     depid,RepStatus，checked
Query ClinStatus() As %Query(ROWSPEC = "Rowid:%String,RepStatus:%String,checked:%String")
{
}

/// Trakcare用户可以有多个安全组,不使用默认安全组登陆
/// 取登陆人员信息
/// 参数：
/// UserId=xUserId
/// 或
/// UserId=xUserId^xGroupId^xCtlocId
/// 
/// xUserId    登陆人员Rowid
/// xGroupId   登陆安全组Rowid
/// xCtlocId   登陆科室Rowid
ClassMethod GetLogUserInfo(UserId) As %String
{
	n (UserId)
	s ret=""
	s xUserId=+$p(UserId,"^",1)
	s xGroupId=+$p(UserId,"^",2)
	s xCtlocId=+$p(UserId,"^",3)
	q:'$d(^SSU("SSUSR",+xUserId)) ret
	s s=$g(^SSU("SSUSR",+xUserId))
	s Code=$p(s,"^",1)
	s Desc=$p(s,"^",2)
	s ctloc=+$p(s,"^",4)
	s:xCtlocId'=0 ctloc=xCtlocId
	s ctlocCode=$p($g(^CTLOC(+ctloc)),"^",1)
	s ctlocDesc=$p($g(^CTLOC(+ctloc)),"^",2)
	s ctloc=ctloc_"/"_ctlocCode_"/"_ctlocDesc
	s sGroup=+$p(s,"^",5)
	s:xGroupId'=0 sGroup=xGroupId
	s grpCode=$p($g(^SSU("SSGRP",sGroup)),"^",1)
	s grpDesc=$p($g(^SSU("SSGRP",sGroup)),"^",2)
	s sGroup=sGroup_"/"_grpCode_"/"_grpDesc
	s dep=+$p($g(^CTLOC(+ctloc)),"^",19)
	s depCode=$p($g(^RBC("DEP",dep)),"^",1)
	s depDesc=$p($g(^RBC("DEP",dep)),"^",2)
	s dep=dep_"/"_depCode_"/"_depDesc
	s:$p(##Class(web.DHCMedBase01).GetDefaultHosp(),"/",2)=1 dep=ctloc
	s ret=xUserId_"^"_Code_"^"_Desc_"^"_ctloc_"^"_dep_"^"_sGroup
    s ret=..ReplaceString(ret,$c(13),"") //add by LiYang 2009-2-2 替换字符串中的回车符
    s ret=..ReplaceString(ret,$c(10),"") //add by LiYang 2009-2-2 替换字符串中的回车符	
	q ret
}

ClassMethod ReplaceString(Str, OldStr, NewStr)
{
	n (Str, OldStr, NewStr)
	set intCounter = 1
	while (1)
	{
		set tmp =$e(Str, intCounter, intCounter + $l(OldStr) - 1) 
		if (tmp = OldStr)
		{
			 set $e(Str, intCounter, intCounter + $l(OldStr) - 1) = NewStr
			 set intCounter = intCounter + $l(NewStr) - $l(OldStr)
		}
		quit:intCounter>=$l(Str)
		set intCounter = intCounter + 1
	}
	quit Str
}

/// 获取Http服务器信息
/// Trakcare的服务器，不是Medtrak的
ClassMethod GetSerInfo()
{
	n 
	s args=1
    Set CurrentNS=$ZNSPACE
	Set Config=##Class(websys.Configuration).%OpenId(1)
    Set MEDDATA=Config.DataNamespace
    Set LABDATA=Config.LabDataNamespace
    //Set Server=Config.WebServer
    Set Server=$p(Config.LayoutManager,":",2)
    Set Path=Config.PathToReports
    Set LayOutManager=Config.LayoutManager
    Set WebServerAppURL = "http://"_Config.WebServer_Config.PathToApp //Modified By LiYang 2008-10-08 获取CSP服务器的IP地址以及程序路径
   // Set WebServerAppURL = "http://127.0.0.1"_Config.PathToApp //Modified By LiYang 2008-10-08 获取CSP服务器的IP地址以及程序路径
    d Config.%Close()
    s s=CurrentNS_$c(1)_MEDDATA_$c(1)_LABDATA_$c(1)_Server_$c(1)_Path_$c(1)_LayOutManager_$C(1)_WebServerAppURL
	q s
}

}
