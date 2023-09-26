Class web.DHCCPW.MR.BuildSimpleJson Extends web.DHCCPW.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// d ##Class(%ResultSet).RunQuery("web.DHCCPW.MR.BuildSimpleJson","BuildJosonQryByStr","76,88")
Query BuildJosonQryByStr(CPWIDStr As %String) As %Query(ROWSPEC = "ID:%String,Code:%String:代码,Desc:%String:描述,CLPOSRowId:%String,CLPOSDesc:%String,ShootFlag:%String")
{
}

ClassMethod BuildJosonQryByStrExecute(ByRef qHandle As %Binary, CPWIDStr As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	s ^LYHab=CPWIDStr
	Quit:CPWIDStr="" $$$OK
	Set IsActive=$g(IsActive)
	Set StrLen=$l(CPWIDStr,",")

	For indMy=1:1:StrLen{
		Set CPWID=$p(CPWIDStr,",",indMy)
		Continue:CPWID=""
		Set objCPW=##Class(web.DHCCPW.MRC.CliPathWay).GetObjById(CPWID)
		Continue:'$IsObject(objCPW)
		
		Set CPWOffShoot=objCPW.CPWOffShoot
		Set Code=objCPW.CPWCode
		Set Desc=objCPW.CPWDesc
		
		/*if (CPWOffShoot="Y")	//分支型路径
		{
			Continue:'$d(^DHCMRCi("CLPOS",0,"IndexFormDR",CPWID))
			Set CLPOSRowId=""
			For {
				Set CLPOSRowId=$o(^DHCMRCi("CLPOS",0,"IndexFormDR",CPWID,CLPOSRowId))
				Quit:CLPOSRowId=""
				
				Set CLPOSObj=##class(web.DHCCPW.MRC.OffShoot).GetObjById(CLPOSRowId)
				Continue:'$IsObject(CLPOSObj)
		
				Set CLPOSAFlag=CLPOSObj.CLPOSAFlag
				Continue:CLPOSAFlag=0
				
				Set CLPOSDesc=CLPOSObj.CLPOSDesc
				Set Data=$lb(CPWID,Code,Desc,CLPOSRowId,CLPOSDesc,"Y")
				Set ^CacheTemp(repid,ind)=Data
				Set ind=ind+1
			}	
		}else{*/
			Set Data=$lb(CPWID,Code,Desc)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		//}
	}
	
	Quit $$$OK
}

ClassMethod BuildJosonQryByStrClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = BuildJosonQryByStrExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod BuildJosonQryByStrFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = BuildJosonQryByStrExecute ]
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

}
