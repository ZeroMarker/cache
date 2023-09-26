/// 名称:DHCHAI.DPS.LabTCMapSrv
/// 描述: 常规检验项目服务
/// 编写者：pylian
/// 编写日期: 2017-08-14
Class DHCHAI.DPS.LabTCMapSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhufei
/// CreatDate：   2017-11-19
/// Description:  查询常规检验项目对照
/// Table：       DHCHAI.DP.LabTCMap
/// Input：       
/// do ##class(%Library.ResultSet).RunQuery("DHCHAI.DPS.LabTCMapSrv","QryLabTCMapToCombo","")
Query QryLabTCMapToCombo(aActive As %String = "") As %Query(ROWSPEC = "ID:%String,FieldDesc:%String,TestCode:%String,TestDesc:%String,RstFormat:%String,AbFlagS:%String") [ SqlProc ]
{
}

ClassMethod QryLabTCMapToComboExecute(ByRef qHandle As %Binary, aActive As %String = "") As %Status
{

	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)

	Set xID = ""
	For {
		Set xID = $o(^DHCHAI.DP.LabTCMapD(xID))
		Quit:xID=""
		
		Set objTCMap=##class(DHCHAI.DP.LabTCMap).GetObjById(xID)
		Continue:'$Isobject(objTCMap)
		
		Set IsActive  = objTCMap.BTIsActive
		Continue:(aActive'="")&&(IsActive'=aActive)
		Set IsActDesc = $s(IsActive=1:"是",1:"否")
		
		Set TestCode  = objTCMap.BTTestCode 
		Set TestDesc  = objTCMap.BTTestDesc //检验项目名称
		Set RstFormat = objTCMap.BTRstFormat
		Set AbFlagS   = objTCMap.BTAbFlagS
		
		Set FieldDesc=TestCode_" "_TestDesc
		
		Set Data = $lb(xID,FieldDesc,TestCode,TestDesc,RstFormat,AbFlagS)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	Quit $$$OK
}

ClassMethod QryLabTCMapToComboClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryLabTCMapToComboExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryLabTCMapToComboFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryLabTCMapToComboExecute ]
{
	set AtEnd=$LIST(qHandle,1)
 	set repid=$LIST(qHandle,2)
 	set ind=$LIST(qHandle,3)
 	set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		set AtEnd=1
 		set Row=""
 	}
 	Else      {				// fetch row
 		set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：     pylian
/// CreatDate：   2017-08-14
/// Description:  查询常规检验项目对照
/// Table：       DHCHAI.DP.LabTCMap
/// Input：       
/// do ##class(%Library.ResultSet).RunQuery("DHCHAI.DPS.LabTCMapSrv","QryLabTCMap","")
Query QryLabTCMap(aActive As %String = "") As %Query(ROWSPEC = "ID:%String,TestCode:%String,TestDesc:%String,TestSetList:%String,RstFormat:%String,AbFlagS:%String,SCode:%String,HospGroup:%String,IsActive:%String,IsActDesc:%String,ActDate:%String,ActTime:%String,ActUser:%String") [ SqlProc ]
{
}

ClassMethod QryLabTCMapExecute(ByRef qHandle As %Binary, aActive As %String = "") As %Status
{

	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)

	Set xID = ""
	For {
		Set xID = $o(^DHCHAI.DP.LabTCMapD(xID))
		Quit:xID=""
		
		Set objTCMap=##class(DHCHAI.DP.LabTCMap).GetObjById(xID)
		Continue:'$Isobject(objTCMap)
		
		Set IsActive  = objTCMap.BTIsActive
		Continue:(aActive'="")&&(IsActive'=aActive)
		Set IsActDesc = $s(IsActive=1:"是",1:"否")
		
		Set TestCode  = objTCMap.BTTestCode 
		Set TestDesc  = objTCMap.BTTestDesc //检验项目名称
		Set RstFormat = objTCMap.BTRstFormat
		Set AbFlagS   = objTCMap.BTAbFlagS
		Set SCode     = objTCMap.BTSCode
		Set HospGroup=""
		Set objSystem=##class(DHCHAI.BT.SystemMap).GetObjByCode(SCode)
		If $IsObject(objSystem) {
			Set HospGroup=objSystem.BTHospDr.BTGroupDr.BTDesc
		}
		Set ActDate   = objTCMap.BTActDate
		Set:ActDate'="" ActDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(ActDate)
		Set ActTime   = objTCMap.BTActTime
	    Set:ActTime'="" ActTime=$zt(ActTime,1)
		Set ActUser   = objTCMap.BTActUser
		
		//取值检验项目对应医嘱
		Set TestSetList=""
		Set xTSMapID=0
		For {
			Set xTSMapID=$o(^DHCHAI.DP.LabTCMapTSI("IndexTCMapTSMap",xID,xTSMapID))
			Quit:xTSMapID=""
			
			Set objTSMap=##class(DHCHAI.DP.LabTestSetMap).GetObjById(xTSMapID)
			Continue:'$IsObject(objTSMap)
			Set TestSetDesc=objTSMap.BTTestSet
			Continue:TestSetDesc=""
			Set TestSetList=TestSetList_","_TestSetDesc
		}
		Set:TestSetList'="" TestSetList=$e(TestSetList,2,$l(TestSetList))
		
		If $d(^DHCHAI.DP.LabVisitRepResultI("IndexTestDesc"," "_TestDesc)){
			Set TestDesc=TestDesc_"[√]"
		}
		
		Set Data = $lb(xID,TestCode,TestDesc,TestSetList,RstFormat,AbFlagS,SCode,HospGroup,IsActive,IsActDesc,ActDate,ActTime,ActUser)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	Quit $$$OK
}

ClassMethod QryLabTCMapClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryLabTCMapExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryLabTCMapFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryLabTCMapExecute ]
{
	set AtEnd=$LIST(qHandle,1)
 	set repid=$LIST(qHandle,2)
 	set ind=$LIST(qHandle,3)
 	set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		set AtEnd=1
 		set Row=""
 	}
 	Else      {				// fetch row
 		set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：     pylian
/// CreatDate：   2017-08-14
/// Description:  查询检验项目定值结果
/// Table：       DHCHAI.DP.LabTCMapRst
/// Input：       
/// do ##class(%Library.ResultSet).RunQuery("DHCHAI.DPS.LabTCMapSrv","QryMapRst","1")
Query QryMapRst(aActive As %String = "") As %Query(ROWSPEC = "ID:%String,TestRes:%String,MapText:%String,MapNote:%String,IsActive:%String,IsActDesc:%String,ActDate:%String,ActTime:%String,ActUser:%String") [ SqlProc ]
{
}

ClassMethod QryMapRstExecute(ByRef qHandle As %Binary, aActive As %String = "") As %Status
{

	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Set xID = ""
	For {
		Set xID = $o(^DHCHAI.DP.LabTCMapRstD(xID))
		Quit:xID=""
  
		Set objRst = ##class(DHCHAI.DP.LabTCMapRst).GetObjById(xID)
		Continue:'$Isobject(objRst)

		Set TestRes  = objRst.BTTestRes
		Set MapText  = objRst.BTMapText
		Set MapNote  = objRst.BTMapNote	
		Set IsActive = objRst.BTIsActive
		Set IsActDesc=$s(IsActive=1:"是",1:"否")
		Set ActDate  = objRst.BTActDate
		Set:ActDate'="" ActDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(ActDate)
		Set ActTime  = objRst.BTActTime
	    Set:ActTime'="" ActTime=$zt(ActTime,1)
		Set ActUser  = objRst.BTActUser
	
		Set Data = $lb(xID,TestRes,MapText,MapNote,IsActive,IsActDesc,ActDate,ActTime,ActUser)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	
	Quit $$$OK
}

ClassMethod QryMapRstClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryMapRstExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryMapRstFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryMapRstExecute ]
{
	set AtEnd=$LIST(qHandle,1)
 	set repid=$LIST(qHandle,2)
 	set ind=$LIST(qHandle,3)
 	set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		set AtEnd=1
 		set Row=""
 	}
 	Else      {				// fetch row
 		set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：     pylian
/// CreatDate：   2017-08-14
/// Description:  根据检验项目查询检验项目定值结果
/// Table：       DHCHAI.DP.LabTCMapRst
/// Input：       
/// do ##class(%Library.ResultSet).RunQuery("DHCHAI.DPS.LabTCMapSrv","QryMapRstByTC","1")
Query QryMapRstByTC(aMapID As %String) As %Query(ROWSPEC = "ID:%String,MapID:%String,TestRes:%String,MapText:%String,MapNote:%String,IsActive:%String,IsActDesc:%String,ActDate:%String,ActTime:%String,ActUser:%String") [ SqlProc ]
{
}

ClassMethod QryMapRstByTCExecute(ByRef qHandle As %Binary, aMapID As %String) As %Status
{

	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
    Quit:aMapID="" $$$OK
	
	Set xTest =""
	For {
		Set xTest = $o(^DHCHAI.DP.LabTCMapRstI("IndexTCMapTestRes",aMapID,xTest))
		Quit:xTest=""
		
		Set xID = ""
		For {
			Set xID = $o(^DHCHAI.DP.LabTCMapRstI("IndexTCMapTestRes",aMapID,xTest,xID))
			Quit:xID=""
	  
			Set objRst = ##class(DHCHAI.DP.LabTCMapRst).GetObjById(xID)
			Continue:'$Isobject(objRst)
	
			Set TestRes  = objRst.BTTestRes
			Set MapText  = objRst.BTMapText
			Set MapNote  = objRst.BTMapNote	
			Set IsActive = objRst.BTIsActive
			Set IsActDesc=$s(IsActive=1:"是",1:"否")
			Set ActDate  = objRst.BTActDate
			Set:ActDate'="" ActDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(ActDate)
			Set ActTime  = objRst.BTActTime
		    Set:ActTime'="" ActTime=$zt(ActTime,1)
			Set ActUser  = objRst.BTActUser
		
			Set Data = $lb(xID,aMapID,TestRes,MapText,MapNote,IsActive,IsActDesc,ActDate,ActTime,ActUser)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
	}
	Quit $$$OK
}

ClassMethod QryMapRstByTCClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryMapRstByTCExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryMapRstByTCFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryMapRstByTCExecute ]
{
	set AtEnd=$LIST(qHandle,1)
 	set repid=$LIST(qHandle,2)
 	set ind=$LIST(qHandle,3)
 	set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		set AtEnd=1
 		set Row=""
 	}
 	Else      {				// fetch row
 		set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：     pylian
/// CreatDate：   2017-08-14
/// Description:  查询检验项目定值结果
/// Table：       DHCHAI.DP.LabTCMapAb
/// Input：       
/// do ##class(%Library.ResultSet).RunQuery("DHCHAI.DPS.LabTCMapSrv","QryMapAb","1")
Query QryMapAb(aActive As %String = "") As %Query(ROWSPEC = "ID:%String,AbFlag:%String,MapText:%String,MapNote:%String,IsActive:%String,IsActDesc:%String,ActDate:%String,ActTime:%String,ActUser:%String") [ SqlProc ]
{
}

ClassMethod QryMapAbExecute(ByRef qHandle As %Binary, aActive As %String = "") As %Status
{

	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
  
	Set xID = ""
	For {
		Set xID = $o(^DHCHAI.DP.LabTCMapAbD(xID))
		Quit:xID=""
  
		Set objAb = ##class(DHCHAI.DP.LabTCMapAb).GetObjById(xID)
		Continue:'$Isobject(objAb)

		Set AbFlag  = objAb.BTAbFlag
		Set MapText  = objAb.BTMapText
		Set MapNote  = objAb.BTMapNote	
		Set IsActive = objAb.BTIsActive
		Set IsActDesc=$s(IsActive=1:"是",1:"否")
		Set ActDate  = objAb.BTActDate
		Set:ActDate'="" ActDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(ActDate)
		Set ActTime  = objAb.BTActTime
	    Set:ActTime'="" ActTime=$zt(ActTime,1)
		Set ActUser  = objAb.BTActUser
	
		Set Data = $lb(xID,AbFlag,MapText,MapNote,IsActive,IsActDesc,ActDate,ActTime,ActUser)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	
	Quit $$$OK
}

ClassMethod QryMapAbClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryMapAbExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryMapAbFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryMapAbExecute ]
{
	set AtEnd=$LIST(qHandle,1)
 	set repid=$LIST(qHandle,2)
 	set ind=$LIST(qHandle,3)
 	set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		set AtEnd=1
 		set Row=""
 	}
 	Else      {				// fetch row
 		set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：     pylian
/// CreatDate：   2017-08-14
/// Description:  根据检验项目查询检验项目定值结果
/// Table：       DHCHAI.DP.LabTCMapAb
/// Input：       
/// do ##class(%Library.ResultSet).RunQuery("DHCHAI.DPS.LabTCMapSrv","QryMapAbByTC","1")
Query QryMapAbByTC(aMapID As %String) As %Query(ROWSPEC = "ID:%String,MapID:%String,AbFlag:%String,MapText:%String,MapNote:%String,IsActive:%String,IsActDesc:%String,ActDate:%String,ActTime:%String,ActUser:%String") [ SqlProc ]
{
}

ClassMethod QryMapAbByTCExecute(ByRef qHandle As %Binary, aMapID As %String) As %Status
{

	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
    Quit:aMapID="" $$$OK
	
	Set xAbFlag =""
	For {
		Set xAbFlag = $o(^DHCHAI.DP.LabTCMapAbI("IndexTCMapAbFlag",aMapID,xAbFlag))
		Quit:xAbFlag=""
		
		Set xID = ""
		For {
			Set xID = $o(^DHCHAI.DP.LabTCMapAbI("IndexTCMapAbFlag",aMapID,xAbFlag,xID))
			Quit:xID=""
	  
			Set objAb = ##class(DHCHAI.DP.LabTCMapAb).GetObjById(xID)
			Continue:'$Isobject(objAb)
	
			Set AbFlag  = objAb.BTAbFlag
			Set MapText  = objAb.BTMapText
			Set MapNote  = objAb.BTMapNote	
			Set IsActive = objAb.BTIsActive
			Set IsActDesc=$s(IsActive=1:"是",1:"否")
			Set ActDate  = objAb.BTActDate
			Set:ActDate'="" ActDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(ActDate)
			Set ActTime  = objAb.BTActTime
		    Set:ActTime'="" ActTime=$zt(ActTime,1)
			Set ActUser  = objAb.BTActUser
		
			Set Data = $lb(xID,aMapID,AbFlag,MapText,MapNote,IsActive,IsActDesc,ActDate,ActTime,ActUser)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
	}
	Quit $$$OK
}

ClassMethod QryMapAbByTCClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryMapAbByTCExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryMapAbByTCFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryMapAbByTCExecute ]
{
	set AtEnd=$LIST(qHandle,1)
 	set repid=$LIST(qHandle,2)
 	set ind=$LIST(qHandle,3)
 	set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		set AtEnd=1
 		set Row=""
 	}
 	Else      {				// fetch row
 		set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：     luotiantian
/// CreatDate：   2020-04-08
/// Description:  查询常规检验项目对照(树形网络)
/// Table：       DHCHAI.DP.LabTCMap
/// Input：       
/// do ##class(%Library.ResultSet).RunQuery("DHCHAI.DPS.LabTCMapSrv","QryLabTCMapInfo","")
Query QryLabTCMapInfo(aAlias As %String = "") As %Query(ROWSPEC = "ID:%String,TestCode:%String,TestDesc:%String,TestSetList:%String,RstFormat:%String,AbFlagS:%String,SCode:%String,HospGroup:%String,IsActive:%String,IsActDesc:%String,ActDate:%String,ActTime:%String,ActUser:%String") [ SqlProc ]
{
}

ClassMethod QryLabTCMapInfoExecute(ByRef qHandle As %Binary, aAlias As %String = "") As %Status
{

	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)

    Set xTestDr = ""
	For {
		Set xTestDr = $o(^DHCHAI.DP.LabTCMapD(xTestDr))
		Quit:xTestDr=""
		
		Set objTCMap=##class(DHCHAI.DP.LabTCMap).GetObjById(xTestDr)
		Continue:'$Isobject(objTCMap)
		
		Set TestCode=objTCMap.BTTestCode
		Set TestDesc=objTCMap.BTTestDesc
		Continue:(aAlias'="")&&(TestDesc'[aAlias)
		
		Set IsActive  = objTCMap.BTIsActive
		Set IsActDesc = $s(IsActive=1:"是",1:"否")
		
		Set RstFormat = objTCMap.BTRstFormat
		Set AbFlagS   = objTCMap.BTAbFlagS
		Set SCode     = objTCMap.BTSCode
		Set HospGroup=""
		Set objSystem=##class(DHCHAI.BT.SystemMap).GetObjByCode(SCode)
		If $IsObject(objSystem) {
			Set HospGroup=objSystem.BTHospDr.BTGroupDr.BTDesc
		}
		Set ActDate   = objTCMap.BTActDate
		Set:ActDate'="" ActDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(ActDate)
		Set ActTime   = objTCMap.BTActTime
	    Set:ActTime'="" ActTime=$zt(ActTime,1)
		Set ActUser   = objTCMap.BTActUser
		Set FieldDesc=TestCode_" "_TestDesc
			
		//取值检验项目对应医嘱
		Set TestSetList=""
		Set xTSMapID=0
		For {
			Set xTSMapID=$o(^DHCHAI.DP.LabTCMapTSI("IndexTCMapTSMap",xTestDr,xTSMapID))
			Quit:xTSMapID=""
			
			Set objTSMap=##class(DHCHAI.DP.LabTestSetMap).GetObjById(xTSMapID)
			Continue:'$IsObject(objTSMap)
			Set TestSetDesc=objTSMap.BTTestSet
			Continue:TestSetDesc=""
			Set TestSetList=TestSetList_","_TestSetDesc
		}
		Set:TestSetList'="" TestSetList=$e(TestSetList,2,$l(TestSetList))
		
		If $d(^DHCHAI.DP.LabVisitRepResultI("IndexTestDesc"," "_TestDesc)){
			Set TestDesc=TestDesc_"[√]"
		}
		
		Set Data = $lb(xTestDr,TestCode,TestDesc,TestSetList,RstFormat,AbFlagS,SCode,HospGroup,IsActive,IsActDesc,ActDate,ActTime,ActUser)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	Quit $$$OK
}

ClassMethod QryLabTCMapInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryLabTCMapInfoExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryLabTCMapInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryLabTCMapInfoExecute ]
{
	set AtEnd=$LIST(qHandle,1)
 	set repid=$LIST(qHandle,2)
 	set ind=$LIST(qHandle,3)
 	set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		set AtEnd=1
 		set Row=""
 	}
 	Else      {				// fetch row
 		set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：     luotiantian
/// CreatDate：   2020-04-09
/// Description:  查询常规检验项目结果(树形网络)
/// Table：       DHCHAI.DP.LabTCMapRst
/// Input：       
/// do ##class(%Library.ResultSet).RunQuery("DHCHAI.DPS.LabTCMapSrv","QryMapRstByTCInfo","")
Query QryMapRstByTCInfo(aMapID As %String, aAlias As %String = "") As %Query(ROWSPEC = "ID:%String,MapID:%String,TestRes:%String,MapText:%String,MapNote:%String,IsActive:%String,IsActDesc:%String,ActDate:%String,ActTime:%String,ActUser:%String") [ SqlProc ]
{
}

ClassMethod QryMapRstByTCInfoExecute(ByRef qHandle As %Binary, aMapID As %String, aAlias As %String = "") As %Status
{

	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	Quit:aMapID="" $$$OK

    Set xTest =""
	For {
		Set xTest = $o(^DHCHAI.DP.LabTCMapRstI("IndexTCMapTestRes",aMapID,xTest))
		Quit:xTest=""
		
		Set xID = ""
		For {
			Set xID = $o(^DHCHAI.DP.LabTCMapRstI("IndexTCMapTestRes",aMapID,xTest,xID))
			Quit:xID=""
	  
			Set objRst = ##class(DHCHAI.DP.LabTCMapRst).GetObjById(xID)
			Continue:'$Isobject(objRst)
			
			Set TestRes  = objRst.BTTestRes
			Set MapText  = objRst.BTMapText
			Continue:(aAlias'="")&&(TestRes'[aAlias)
			Set MapNote  = objRst.BTMapNote	
			Set IsActive = objRst.BTIsActive
			Set IsActDesc=$s(IsActive=1:"是",1:"否")
			Set ActDate  = objRst.BTActDate
			Set:ActDate'="" ActDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(ActDate)
			Set ActTime  = objRst.BTActTime
		    Set:ActTime'="" ActTime=$zt(ActTime,1)
			Set ActUser  = objRst.BTActUser
			
			Set Data = $lb(xID,aMapID,TestRes,MapText,MapNote,IsActive,IsActDesc,ActDate,ActTime,ActUser)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		
		}
	}
			
	Quit $$$OK
}

ClassMethod QryMapRstByTCInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryMapRstByTCInfoExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryMapRstByTCInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryMapRstByTCInfoExecute ]
{
	set AtEnd=$LIST(qHandle,1)
 	set repid=$LIST(qHandle,2)
 	set ind=$LIST(qHandle,3)
 	set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		set AtEnd=1
 		set Row=""
 	}
 	Else      {				// fetch row
 		set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：     luotiantian
/// CreatDate：   2020-04-09
/// Description:  查询常规检验项目定值结果(树形网络)
/// Table：       DHCHAI.DP.LabTCMapAb
/// Input：       
/// do ##class(%Library.ResultSet).RunQuery("DHCHAI.DPS.LabTCMapSrv","QryMapAbByTCInfo",2,"")
Query QryMapAbByTCInfo(aMapID As %String, aAlias As %String = "") As %Query(ROWSPEC = "ID:%String,MapID:%String,AbFlag:%String,MapText:%String,MapNote:%String,IsActive:%String,IsActDesc:%String,ActDate:%String,ActTime:%String,ActUser:%String") [ SqlProc ]
{
}

ClassMethod QryMapAbByTCInfoExecute(ByRef qHandle As %Binary, aMapID As %String, aAlias As %String = "") As %Status
{

	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	Quit:aMapID="" $$$OK

    Set xAbFlag =""
	For {
		Set xAbFlag = $o(^DHCHAI.DP.LabTCMapAbI("IndexTCMapAbFlag",aMapID,xAbFlag))
		Quit:xAbFlag=""
		
		Set xID = ""
		For {
			Set xID = $o(^DHCHAI.DP.LabTCMapAbI("IndexTCMapAbFlag",aMapID,xAbFlag,xID))
			Quit:xID=""
	  
			Set objAb = ##class(DHCHAI.DP.LabTCMapAb).GetObjById(xID)
			Continue:'$Isobject(objAb)
			Set AbFlag  = objAb.BTAbFlag
			Set MapText  = objAb.BTMapText
			Continue:(aAlias'="")&&(AbFlag'[aAlias)
			
			Set MapNote  = objAb.BTMapNote	
			Set IsActive = objAb.BTIsActive
			Set IsActDesc=$s(IsActive=1:"是",1:"否")
			Set ActDate  = objAb.BTActDate
			Set:ActDate'="" ActDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(ActDate)
			Set ActTime  = objAb.BTActTime
		    Set:ActTime'="" ActTime=$zt(ActTime,1)
			Set ActUser  = objAb.BTActUser
		
			Set Data = $lb(xID,aMapID,AbFlag,MapText,MapNote,IsActive,IsActDesc,ActDate,ActTime,ActUser)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1		
		}
	}
			
	Quit $$$OK
}

ClassMethod QryMapAbByTCInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryMapAbByTCInfoExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryMapAbByTCInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryMapAbByTCInfoExecute ]
{
	set AtEnd=$LIST(qHandle,1)
 	set repid=$LIST(qHandle,2)
 	set ind=$LIST(qHandle,3)
 	set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		set AtEnd=1
 		set Row=""
 	}
 	Else      {				// fetch row
 		set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：     pylian
/// CreatDate：   2021-03-30
/// Description:  查询检验项目与医嘱对照
/// Table：       DHCHAI.DP.LabTCMap
/// Input：       
/// do ##class(%Library.ResultSet).RunQuery("DHCHAI.DPS.LabTCMapSrv","QryMapTestCode","","","C反应")
Query QryMapTestCode(aFlg As %String = "", aActive As %String = "", aAlias As %String = "") As %Query(ROWSPEC = "ID:%String,MapItemID:%String,MapItemCode:%String,MapItemDesc:%String,TestCode:%String,TestDesc:%String,IsActive:%String,IsActDesc:%String,RstFormat:%String,AbFlagS:%String,SCode:%String,TestSetList:%String") [ SqlProc ]
{
}

ClassMethod QryMapTestCodeExecute(ByRef qHandle As %Binary, aFlg As %String = "", aActive As %String = "", aAlias As %String = "") As %Status
{

	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Set xSCode = ""
	For {
		Set xSCode = $o(^DHCHAI.DP.LabTCMapI("IndexSCodeTestCode",xSCode))
		Quit:xSCode=""
		
		Set xTestCode = ""
		For {
			Set xTestCode = $o(^DHCHAI.DP.LabTCMapI("IndexSCodeTestCode",xSCode,xTestCode))
			Quit:xTestCode=""
			
			Set xID = ""
			For {
				Set xID = $o(^DHCHAI.DP.LabTCMapI("IndexSCodeTestCode",xSCode,xTestCode,xID))
				Quit:xID=""

				Set objTCMap = ##class(DHCHAI.DP.LabTCMap).GetObjById(xID)
				Continue:'$Isobject(objTCMap)
			
				Set IsActive  = objTCMap.BTIsActive
				Continue:(aActive'="")&&(IsActive'=aActive)
				Set IsActDesc = $s(IsActive=1:"是",1:"否")
				
				Set TestCode  = objTCMap.BTTestCode 
				Set TestDesc  = objTCMap.BTTestDesc //检验项目名称
				Set RstFormat = objTCMap.BTRstFormat
				Set AbFlagS   = objTCMap.BTAbFlagS
				Set SCode     = objTCMap.BTSCode
				Set (MapItemID,MapItemCode,MapItemDesc) ="" 
				If $Isobject(objTCMap.BTMapItemDr) {
					Set MapItemID = objTCMap.BTMapItemDr.%Id()
					Set MapItemCode = objTCMap.BTMapItemDr.BTTSCode
					Set MapItemDesc = objTCMap.BTMapItemDr.BTTestSet
				}
				//取值检验项目对应医嘱
				Set TestSetList=""
				Set xTSMapID=0
				For {
					Set xTSMapID=$o(^DHCHAI.DP.LabTCMapTSI("IndexTCMapTSMap",xID,xTSMapID))
					Quit:xTSMapID=""
					
					Set objTSMap=##class(DHCHAI.DP.LabTestSetMap).GetObjById(xTSMapID)
					Continue:'$IsObject(objTSMap)
					Set TestSetDesc=objTSMap.BTTestSet
					Continue:TestSetDesc=""
					Set TestSetList=TestSetList_","_TestSetDesc
				}
				Set:TestSetList'="" TestSetList=$e(TestSetList,2,$l(TestSetList))
				
				If $d(^DHCHAI.DP.LabVisitRepResultI("IndexTestDesc"," "_TestDesc)){
					Set TestDesc=TestDesc_"[√]"
				}
	
				Continue:(aAlias'="")&&(TestCode'[aAlias)&&(TestDesc'[aAlias)&&(TestSetList'[aAlias)
				Continue:(aFlg=0)&&(MapItemID'="")
				Continue:(aFlg=1)&&(MapItemID="")
				Continue:(aFlg=0)&&(IsActive'=1) //未对照不显示无效项目
			
				If $d(^DHCHAI.DP.LabVisitTestSetI("IndexTestSetDesc"," "_TestDesc)){
					Set TestDesc=TestDesc_"[√]"
				}
				
				Set Data = $lb(xID,MapItemID,MapItemCode,MapItemDesc,TestCode,TestDesc,IsActive,IsActDesc,RstFormat,AbFlagS,SCode,TestSetList)
				Set ^CacheTemp(repid,ind)=Data
				Set ind=ind+1
			}
		}
		
	}
	Quit $$$OK
}

ClassMethod QryMapTestCodeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryMapTestCodeExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryMapTestCodeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryMapTestCodeExecute ]
{
	set AtEnd=$LIST(qHandle,1)
 	set repid=$LIST(qHandle,2)
 	set ind=$LIST(qHandle,3)
 	set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		set AtEnd=1
 		set Row=""
 	}
 	Else      {				// fetch row
 		set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

}
