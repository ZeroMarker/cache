/// 名称: web.DHCCPW.MRC.DeptPahtWay
/// 描述：给临床路径指定科室
/// 编写者：李宇峰
/// 编写日期：2010-04-29
Class web.DHCCPW.MRC.DeptPahtWay Extends web.DHCCPW.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhufei
/// CreatDate：   2011-01-18
/// Description:  根据ID取科室路径
/// Table：       User.DHCMRCDeptClinicalPathWays
/// Input：       ID:    User.DHCMRCDeptClinicalPathWays.Id
/// Return：      返回object
/// w ##class(web.DHCCPW.MRC.DeptPahtWay).GetObjById(1)
ClassMethod GetObjById(argId As %String) As User.DHCMRCDeptClinicalPathWays
{
	New (argId)
	Set return=##Class(User.DHCMRCDeptClinicalPathWays).%OpenId(argId)
	Do:return'="" return.%Close()
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2011-01-30
/// Description:  取科室字典
/// Table：       CT_Loc
/// d ##Class(%ResultSet).RunQuery("web.DHCCPW.MRC.DeptPahtWay","GetDept","")
Query GetDept(argAlias As %String, argType As %String, argLocID As %String) As %Query(ROWSPEC = "Rowid:%String,code:%String,desc:%String")
{
}

ClassMethod GetDeptExecute(ByRef qHandle As %Binary, argAlias As %String, argType As %String, argLocID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$LB(0,repid,0)
	
	Set tmp=argLocID
	Set argLocID=$p(tmp,"-",1)
	Set argHospID=$p(tmp,"-",2)
	
	Set:argAlias'="" argAlias=$$ALPHAUP^SSUTIL4(argAlias)
	Set LocID=0
	For {
		Set LocID=$o(^CTLOC(LocID))
		Quit:LocID=""
		
		Set LocInfo=$g(^CTLOC(LocID))
		Set LocCode=$p(LocInfo,"^",1)
		Set LocDesc=$p(LocInfo,"^",2)
		Set LocType=$p(LocInfo,"^",13)
		Set LocCode1=$$ALPHAUP^SSUTIL4(LocCode)
		Set LocDesc1=$$ALPHAUP^SSUTIL4(LocDesc)
		Continue:(argAlias'="")&&(LocCode1'[argAlias)&&(LocDesc1'[argAlias)
		Continue:(argType'="")&&(argType'=LocType)
		Continue:(argLocID'="")&&('$d(^CTLOC(+argLocID,"LINK",0,"Loc",LocID)))
		Continue:(argType="E")&&('$d(^PAC("ADMLOC",0,"AdmType","I",LocID)))&&('$d(^PAC("ADMLOC",0,"AdmType","O",LocID)))
		Set HospID=$p(LocInfo,"^",22)	// 医院判断
		Continue:(argHospID'="")&&(HospID'=argHospID)
		/*
		Set LocType=$p($g(^CTLOC(LocID)),"^",13)
		Continue:LocType'="E"
		Set LocCode=$p($g(^CTLOC(LocID)),"^",1)
		Set LocDesc=$p($g(^CTLOC(LocID)),"^",2)
		Set LocCode1=$$ALPHAUP^SSUTIL4(LocCode)
		Set LocDesc1=$$ALPHAUP^SSUTIL4(LocDesc)
		Continue:(argAlias'="")&&(LocCode1'[argAlias)&&(LocDesc1'[argAlias)
		Continue:LocDesc1["门诊"
		*/
		Set Data=$lb(LocID,LocCode,LocDesc)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	
	Quit $$$OK
}

ClassMethod GetDeptFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDeptExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {				// if there are no more rows, finish fetching
		Set AtEnd=1
		Set Row=""
	}Else{				// fetch row
		Set Row=^CacheTemp(repid,ind)
	}
	Set qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetDeptClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDeptExecute ]
{
	Set repid=$LIST($g(qHandle),2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator：     zhufei
/// CreatDate：   2011-01-30
/// Description:  取路径对应常用科室
/// Table：       CT_Loc,User.DHCMRCDeptClinicalPathWays
/// d ##Class(%ResultSet).RunQuery("web.DHCCPW.MRC.DeptPahtWay","GetPathToDept","")
Query GetPathToDept(argCPWDicID As %String) As %Query(ROWSPEC = "Rowid:%String,code:%String,desc:%String")
{
}

ClassMethod GetPathToDeptExecute(ByRef qHandle As %Binary, argCPWDicID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$LB(0,repid,0)
	
	Quit:argCPWDicID="" $$$OK
	Set DepCPWID=0
	For {
		Set DepCPWID=$o(^DHCMRC("DEPCPW",DepCPWID))
		Quit:DepCPWID=""
		Set objDepCPW=..GetObjById(DepCPWID)
		If $IsObject(objDepCPW){
			Set CPWDicID=""
			If $IsObject(objDepCPW.DCPWCPWDR){
				Set CPWDicID=objDepCPW.DCPWCPWDR.%Id()
			}
			Continue:(argCPWDicID'="")&&(CPWDicID'=argCPWDicID)
			Set CPWLocID=objDepCPW.DCPWCTLOCDR
			Set LocCode=$p($g(^CTLOC(+CPWLocID)),"^",1)
			Set LocDesc=$p($g(^CTLOC(+CPWLocID)),"^",2)
			Set Data=$lb(CPWLocID,LocCode,LocDesc)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
	}
	
	Quit $$$OK
}

ClassMethod GetPathToDeptFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPathToDeptExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {				// if there are no more rows, finish fetching
		Set AtEnd=1
		Set Row=""
	}Else{				// fetch row
		Set Row=^CacheTemp(repid,ind)
	}
	Set qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetPathToDeptClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPathToDeptExecute ]
{
	Set repid=$LIST($g(qHandle),2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator：     zhufei
/// CreatDate：   2011-01-30
/// Description:  取科室对应常用路径
/// Table：       CT_Loc,User.DHCMRCDeptClinicalPathWays
/// d ##Class(%ResultSet).RunQuery("web.DHCCPW.MRC.DeptPahtWay","GetDeptPathWays","")
Query GetDeptPathWays(argLocID As %String) As %Query(ROWSPEC = "Rowid:%String,code:%String,desc:%String,active:%String,dateFrom:%String,dateTo:%String,typeDesc:%String")
{
}

ClassMethod GetDeptPathWaysExecute(ByRef qHandle As %Binary, argLocID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$LB(0,repid,0)
	
	Quit:argLocID="" $$$OK
	Set DepCPWID=0
	For {
		Set DepCPWID=$o(^DHCMRC("DEPCPW",DepCPWID))
		Quit:DepCPWID=""
		Set objDepCPW=..GetObjById(DepCPWID)
		If $IsObject(objDepCPW){
			Set CPWLocID=objDepCPW.DCPWCTLOCDR
			Continue:(argLocID'="")&&(CPWLocID'=argLocID)
			If $IsObject(objDepCPW.DCPWCPWDR){
				Set CPWDID=objDepCPW.DCPWCPWDR.%Id()
				Set CPWDCode=objDepCPW.DCPWCPWDR.CPWDCode
				Set CPWDDesc=objDepCPW.DCPWCPWDR.CPWDDesc
				Set CPWDActive=objDepCPW.DCPWCPWDR.CPWDActive
				Set CPWDDateFrom=objDepCPW.DCPWCPWDR.CPWDDateFrom
				Set CPWDDateTo=objDepCPW.DCPWCPWDR.CPWDDateTo
				Set CPWDType=objDepCPW.DCPWCPWDR.CPWDCPWTypeDR
				Set CPWDTypeDesc=objDepCPW.DCPWCPWDR.CPWDCPWTypeDR.CLPTDesc
				
				Set Data=$lb(CPWDID,CPWDCode,CPWDDesc,CPWDActive,CPWDDateFrom,CPWDDateTo,CPWDTypeDesc)
				Set ^CacheTemp(repid,ind)=Data
				Set ind=ind+1
			}
			
		}
	}
	
	Quit $$$OK
}

ClassMethod GetDeptPathWaysFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDeptPathWaysExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {				// if there are no more rows, finish fetching
		Set AtEnd=1
		Set Row=""
	}Else{				// fetch row
		Set Row=^CacheTemp(repid,ind)
	}
	Set qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetDeptPathWaysClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDeptPathWaysExecute ]
{
	Set repid=$LIST($g(qHandle),2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator：     zhufei
/// CreatDate：   2011-01-30
/// Description:  取科室对应常用路径
/// Table：       CT_Loc,User.DHCMRCDeptClinicalPathWays
/// d ##Class(%ResultSet).RunQuery("web.DHCCPW.MRC.DeptPahtWay","GetPathWays","3")
Query GetPathWays(argLocID As %String) As %Query(ROWSPEC = "Rowid:%String,code:%String,desc:%String,active:%String,dateFrom:%String,dateTo:%String,typeDesc:%String")
{
}

ClassMethod GetPathWaysExecute(ByRef qHandle As %Binary, argLocID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$LB(0,repid,0)
	
	Quit:argLocID="" $$$OK
	Set DepCPWID=0
	For {
		Set DepCPWID=$o(^DHCMRC("DEPCPW",DepCPWID))
		Quit:DepCPWID=""
		Set objDepCPW=..GetObjById(DepCPWID)
		If $IsObject(objDepCPW){
			Set CPWLocID=objDepCPW.DCPWCTLOCDR
			Continue:(argLocID'="")&&(CPWLocID'=argLocID)
			If $IsObject(objDepCPW.DCPWCPWDR){
				Set CPWDID=objDepCPW.DCPWCPWDR.%Id()
				Set CPWDCode=objDepCPW.DCPWCPWDR.CPWDCode
				Set CPWDDesc=objDepCPW.DCPWCPWDR.CPWDDesc
				Set CPWDActive=objDepCPW.DCPWCPWDR.CPWDActive
				Continue:CPWDActive'="Y"                         //add by wuqk 2011-11-17
				Set CPWDActive=$s(CPWDActive["Y":"Yes",1:"No")
				Set CPWDDateFrom=objDepCPW.DCPWCPWDR.CPWDDateFrom
				Set CPWDDateTo=objDepCPW.DCPWCPWDR.CPWDDateTo
				Continue:(CPWDDateFrom'="")&&(CPWDDateFrom>+$h)
				Continue:(CPWDDateTo'="")&&(CPWDDateTo<+$h)
				Set:CPWDDateFrom'="" CPWDDateFrom=$zd(CPWDDateFrom,3)
				Set:CPWDDateTo'="" CPWDDateTo=$zd(CPWDDateTo,3)
				Set CPWDType=objDepCPW.DCPWCPWDR.CPWDCPWTypeDR
				Set CPWDTypeDesc=objDepCPW.DCPWCPWDR.CPWDCPWTypeDR.CLPTDesc
				
				Set Data=$lb(CPWDID,CPWDCode,CPWDDesc,CPWDActive,CPWDDateFrom,CPWDDateTo,CPWDTypeDesc)
				Set ^CacheTemp(repid,ind)=Data
				Set ind=ind+1
			}
			
		}
	}
	
	Quit $$$OK
}

ClassMethod GetPathWaysFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPathWaysExecute ]
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

ClassMethod GetPathWaysClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPathWaysExecute ]
{
	Set repid=$LIST($g(qHandle),2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

/// w ##Class(web.DHCCPW.MRC.DeptPahtWay).CheckDeptPath(3,3)
ClassMethod CheckDeptPath(argLocID As %String, argCPWDicID As %String)
{
	New (argLocID,argCPWDicID)
	Set return=0
	Quit:(argLocID="")||(argCPWDicID="") $$$OK
	
	Set DepCPWID=0
	For {
		Set DepCPWID=$o(^DHCMRC("DEPCPW",DepCPWID))
		Quit:(DepCPWID="")||(return=1)
		Set objDepCPW=..GetObjById(DepCPWID)
		If $IsObject(objDepCPW){
			Set CPWLocID=objDepCPW.DCPWCTLOCDR
			Continue:(argLocID'="")&&(CPWLocID'=argLocID)
			If $IsObject(objDepCPW.DCPWCPWDR){
				Set CPWDID=objDepCPW.DCPWCPWDR.%Id()
				Continue:(argCPWDicID'="")&&(argCPWDicID'=CPWDID)
				Set return=1
			}
			
		}
	}
	
	Quit return
}

/// w ##Class(web.DHCCPW.MRC.DeptPahtWay).AddDeptPath(3,10)
ClassMethod AddDeptPath(argLocID As %String, argCPWDicID As %String)
{
	New (argLocID,argCPWDicID)
	Set return=-1
	Quit:(argLocID="")||(argCPWDicID="") return
	
	Set obj=##class(User.DHCMRCDeptClinicalPathWays).%New()
	Set objCPWDic=##class(web.DHCCPW.MRC.ClinPathWaysDicSrv).GetObjById(argCPWDicID)
	Quit:'$IsObject(objCPWDic) return
	Set obj.DCPWCPWDR=objCPWDic
	Set obj.DCPWCTLOCDR=argLocID
	Set sc=obj.%Save()
	If $System.Status.IsError(sc) {          //检查Save是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	} Else {
		Set return=obj.%Id()
	}
	Do obj.%Close()
	
	Quit return
}

/// w ##Class(web.DHCCPW.MRC.DeptPahtWay).DeleteDeptPath(3,10)
ClassMethod DeleteDeptPath(argLocID As %String, argCPWDicID As %String)
{
	New (argLocID,argCPWDicID)
	Set return=-1
	Quit:(argLocID="")||(argCPWDicID="") return
	
	Set return=0
	Set DepCPWID=0
	For {
		Set DepCPWID=$o(^DHCMRC("DEPCPW",DepCPWID))
		Quit:(DepCPWID="")||(return=1)
		Set objDepCPW=..GetObjById(DepCPWID)
		If $IsObject(objDepCPW){
			Set CPWLocID=objDepCPW.DCPWCTLOCDR
			Continue:(argLocID'="")&&(CPWLocID'=argLocID)
			If $IsObject(objDepCPW.DCPWCPWDR){
				Set CPWDID=objDepCPW.DCPWCPWDR.%Id()
				Continue:(argCPWDicID'="")&&(argCPWDicID'=CPWDID)
				
				Set sc = ##class(User.DHCMRCDeptClinicalPathWays).%DeleteId(DepCPWID)
				If $system.Status.IsError(sc) {         //检查删除是否成功
			   		Do $system.OBJ.DisplayError(sc) 
			   		Set return=-1
				}
			}
		}
	}
	
	Quit return
}

/// by wuqk 
/// 2011-11-17
/// for 路径字典页面通过路径查询常用科室
Query QueryDepByCPW(CPWDicID As %String, argType As %String, argLocID As %String) As %Query(ROWSPEC = "Rowid:%String,CTLocId:%String,CTLocDesc:%String,checked:%String")
{
}

ClassMethod QueryDepByCPWExecute(ByRef qHandle As %Binary, CPWDicID As %String, argType As %String, argLocID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$LB(0,repid,0)
	
	Set tmp=argLocID
	Set argLocID=$p(tmp,"-",1)
	Set argHospID=$p(tmp,"-",2)
	Set objCPWDic=##class(web.DHCCPW.MRC.ClinPathWaysDicSrv).GetObjById(CPWDicID)
	Quit:'$IsObject(objCPWDic) $$$OK
	Set IsOpCPW=$s(objCPWDic.CPWDIsOpCPW["Y":"O",1:"I")
	
	Set LocID=0
	For {
		Set LocID=$o(^CTLOC(LocID))
		Quit:LocID=""
		
		Set LocInfo=$g(^CTLOC(LocID))
		Set LocCode=$p(LocInfo,"^",1)
		Set LocDesc=$p(LocInfo,"^",2)
		Set LocType=$p(LocInfo,"^",13)
		Continue:(argType'="")&&(argType'=LocType)
		Continue:(argLocID'="")&&('$d(^CTLOC(+argLocID,"LINK",0,"Loc",LocID)))
		Continue:(argType="E")&&('$d(^PAC("ADMLOC",0,"AdmType",IsOpCPW,LocID)))
		Set HospID=$p(LocInfo,"^",22)	// 医院判断
		Continue:(argHospID'="")&&(HospID'=argHospID)
		/*
		Set LocType=$p($g(^CTLOC(LocID)),"^",13)
		Continue:LocType'="E"
		Set LocCode=$p($g(^CTLOC(LocID)),"^",1)
		Set LocDesc=$p($g(^CTLOC(LocID)),"^",2)
		Set LocCode1=$$ALPHAUP^SSUTIL4(LocCode)
		Set LocDesc1=$$ALPHAUP^SSUTIL4(LocDesc)
		Continue:LocDesc1["门诊"
		*/
		//^DHCMRCi("DEPCPW",0,"IndexCPW",1," 1",7)=""
		if $d(^DHCMRCi("DEPCPW",0,"IndexCPW",CPWDicID," "_LocID)){
			Set checked=1
			Set RowId=$o(^DHCMRCi("DEPCPW",0,"IndexCPW",CPWDicID," "_LocID,""))
		}
		else{
			Set checked=0
			Set RowId=""
		}
		Set Data=$lb(RowId,LocID,LocDesc,checked)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	Quit $$$OK
}

ClassMethod QueryDepByCPWClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryDepByCPWExecute ]
{
	Set repid=$LIST($g(qHandle),2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QueryDepByCPWFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryDepByCPWExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {				// if there are no more rows, finish fetching
		Set AtEnd=1
		Set Row=""
	}Else{				// fetch row
		Set Row=^CacheTemp(repid,ind)
	}
	Set qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// by wuqk 
/// 2011-11-17
/// for 路径字典页面通过设置路径常用科室
ClassMethod SaveDepCPW(dicID, locList)
{
	new (dicID,locList)
	quit:dicID="" -1
	quit:locList="" -2
	set cnt=$l(locList,"^")
	for index=1:1:cnt {
		set depcpw=$p(locList,"^",index)
		continue:depcpw=""
		set rowid=$p(depcpw,"|",1)
		set ctloc=$p(depcpw,"|",2)
		if rowid'="" {
			set flg=..DeleteDeptPath(ctloc,dicID)
		}
		else {
			set flg=..AddDeptPath(ctloc,dicID)
		}
	}
	
	quit 1
}

}
