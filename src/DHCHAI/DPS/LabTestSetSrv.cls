/// 名称: DHCHAI.DPS.LabTestSrv
/// 描述: 常规检验项目服务
/// 编写者：pylian
/// 编写日期: 2017-05-10
Class DHCHAI.DPS.LabTestSetSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     pylian
/// CreatDate：   2017-07-20
/// Description:  检验医嘱分类
/// Table：       DHCHAI.DP.LabTestSetCat
/// Input：       
/// do ##class(%Library.ResultSet).RunQuery("DHCHAI.DPS.LabTestSetSrv","QryLabSetCat")
Query QryLabSetCat() As %Query(ROWSPEC = "ID:%String,BTCode:%String,BTDesc:%String") [ SqlProc ]
{
}

ClassMethod QryLabSetCatExecute(ByRef qHandle As %Binary) As %Status
{

	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)

	Set xID = ""
	For {
		Set xID = $o(^DHCHAI.DP.LabTestSetCatD(xID))
		Quit:xID=""
	  
		Set objSetCat = ##class(DHCHAI.DP.LabTestSetCat).GetObjById(xID)
		Continue:'$Isobject(objSetCat)
			
		Set BTCode  = objSetCat.BTCode  
		Set BTDesc  = objSetCat.BTDesc 
				
		Set Data = $lb(xID,BTCode,BTDesc)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	Quit $$$OK
}

ClassMethod QryLabSetCatClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryLabSetCatExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryLabSetCatFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryLabSetCatExecute ]
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
/// CreatDate：   2017-05-10
/// Description:  查询检验医嘱
/// Table：       DHCHAI.DP.LabTest
/// Input：       
/// do ##class(%Library.ResultSet).RunQuery("DHCHAI.DPS.LabTestSetSrv","QryLabTestSet")
Query QryLabTestSet(aActive As %String = "", aAlias As %String = "", aCatCode As %String = "", aIsSubItem As %String = "") As %Query(ROWSPEC = "ID:%String,TSCode:%String,TestSet:%String,CatID:%String,CatCode:%String,CatDesc:%String,IsActive:%String,IsActDesc:%String,Note:%String,IsSubItem:%String,IsSubItemDesc:%String,IsVirus:%String,IsVirusDesc:%String") [ SqlProc ]
{
}

ClassMethod QryLabTestSetExecute(ByRef qHandle As %Binary, aActive As %String = "", aAlias As %String = "", aCatCode As %String = "", aIsSubItem As %String = "") As %Status
{

	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)

	Set xID = ""
	For {
		Set xID = $o(^DHCHAI.DP.LabTestSetD(xID))
		Quit:xID=""
	  
		Set objLabTest = ##class(DHCHAI.DP.LabTestSet).GetObjById(xID)
		Continue:'$Isobject(objLabTest)
			
		Set TSCode    = objLabTest.BTTSCode
		Set TestSet   = objLabTest.BTTestSet
		//多语言
		Set TestSet   = ##Class(DHCHAI.Abstract).HAIGetTranByDesc("BTTestSet",TestSet,"DHCHAI.DP.LabTestSet")
		Set CatID="",CatCode="",CatDesc=""
		If $IsObject(objLabTest.BTCatDr){
			Set CatID   = objLabTest.BTCatDr.%Id()
			Set CatCode = objLabTest.BTCatDr.BTCode
			Set CatDesc = objLabTest.BTCatDr.BTDesc
		}
		Continue:(aAlias'="")&&(TestSet'[aAlias)&&(TSCode'[aAlias)
		Continue:(aCatCode'="")&&(aCatCode'=CatCode)
		Set IsActive  = objLabTest.BTIsActive
		Set IsActDesc = $s(IsActive=1:"是",1:"否")
		Continue:(aActive'="")&&(IsActive'=aActive) 
		Set Note      = objLabTest.BTNote		
				
		Set IsSubItem =objLabTest.BTIsSubItem
		Continue:(aIsSubItem'="")&&(aIsSubItem'=IsSubItem)
		Set IsSubItemDesc = $s(IsSubItem=1:"是",1:"否")
		Set IsVirus =objLabTest.BTIsVirus
		Set IsVirusDesc = $s(IsVirus=1:"是",1:"否")
			
		Set Data = $lb(xID,TSCode,TestSet,CatID,CatCode,CatDesc,IsActive,IsActDesc,Note,IsSubItem,IsSubItemDesc,IsVirus,IsVirusDesc)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	Quit $$$OK
}

ClassMethod QryLabTestSetClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryLabTestSetExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryLabTestSetFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryLabTestSetExecute ]
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
/// CreatDate：   2021-05-27
/// Description:  查询常规检验医嘱（包括病毒支原体）
/// Table：       DHCHAI.DP.LabTest
/// Input：       
/// do ##class(%Library.ResultSet).RunQuery("DHCHAI.DPS.LabTestSetSrv","QryRuleTestSet")
Query QryRuleTestSet(aActive As %String = "") As %Query(ROWSPEC = "ID:%String,TSCode:%String,TestSet:%String,CatID:%String,CatCode:%String,CatDesc:%String,IsActive:%String,IsActDesc:%String,Note:%String") [ SqlProc ]
{
}

ClassMethod QryRuleTestSetExecute(ByRef qHandle As %Binary, aActive As %String = "") As %Status
{

	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)

	Set xID = ""
	For {
		Set xID = $o(^DHCHAI.DP.LabTestSetD(xID))
		Quit:xID=""
	  
		Set objLabTest = ##class(DHCHAI.DP.LabTestSet).GetObjById(xID)
		Continue:'$Isobject(objLabTest)
			
		Set TSCode    = objLabTest.BTTSCode
		Set TestSet   = objLabTest.BTTestSet
		Set CatID="",CatCode="",CatDesc=""
		If $IsObject(objLabTest.BTCatDr){
			Set CatID   = objLabTest.BTCatDr.%Id()
			Set CatCode = objLabTest.BTCatDr.BTCode
			Set CatDesc = objLabTest.BTCatDr.BTDesc
		}
		Continue:(CatDesc'="常规检验")&&((CatDesc'="生化免疫检测"))   //update 20211129  病毒支原体检测修改为生化免疫检测

		
		Set IsActive  = objLabTest.BTIsActive
		Set IsActDesc = $s(IsActive=1:"是",1:"否")
		Continue:(aActive'="")&&(IsActive'=aActive) 
		Set Note      = objLabTest.BTNote
				
		Set Data = $lb(xID,TSCode,TestSet,CatID,CatCode,CatDesc,IsActive,IsActDesc,Note)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	Quit $$$OK
}

ClassMethod QryRuleTestSetClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryRuleTestSetExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryRuleTestSetFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryRuleTestSetExecute ]
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
/// CreatDate：   2021-05-27
/// Description:  查询常规病毒支原体
/// Table：       DHCHAI.DP.LabTest
/// Input：       
/// do ##class(%Library.ResultSet).RunQuery("DHCHAI.DPS.LabTestSetSrv","QryTestSetVirus")
Query QryTestSetVirus(aActive As %String = "") As %Query(ROWSPEC = "ID:%String,TSCode:%String,TestSet:%String,CatID:%String,CatCode:%String,CatDesc:%String,IsActive:%String,IsActDesc:%String,Note:%String") [ SqlProc ]
{
}

ClassMethod QryTestSetVirusExecute(ByRef qHandle As %Binary, aActive As %String = "") As %Status
{

	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)

	Set xID = ""
	For {
		Set xID = $o(^DHCHAI.DP.LabTestSetD(xID))
		Quit:xID=""
	  
		Set objLabTest = ##class(DHCHAI.DP.LabTestSet).GetObjById(xID)
		Continue:'$Isobject(objLabTest)
			
		Set TSCode    = objLabTest.BTTSCode
		Set TestSet   = objLabTest.BTTestSet
		Set CatID="",CatCode="",CatDesc=""
		If $IsObject(objLabTest.BTCatDr){
			Set CatID   = objLabTest.BTCatDr.%Id()
			Set CatCode = objLabTest.BTCatDr.BTCode
			Set CatDesc = objLabTest.BTCatDr.BTDesc
		}
		Continue:(CatDesc'="生化免疫检测")   //update 20211129  病毒支原体检测修改为生化免疫检测
		//add 20211201 过滤病毒项目标志
		Set IsVirus =objLabTest.BTIsVirus
		Continue:IsVirus'=1
		Set IsActive  = objLabTest.BTIsActive
		Set IsActDesc = $s(IsActive=1:"是",1:"否")
		Continue:(aActive'="")&&(IsActive'=aActive) 
		Set Note      = objLabTest.BTNote
				
		Set Data = $lb(xID,TSCode,TestSet,CatID,CatCode,CatDesc,IsActive,IsActDesc,Note)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	Quit $$$OK
}

ClassMethod QryTestSetVirusClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryTestSetVirusExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryTestSetVirusFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryTestSetVirusExecute ]
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
/// CreatDate：   2017-07-20
/// Description:  通过医嘱分类查询检验医嘱
/// Table：       DHCHAI.DP.LabTestSetCat、DHCHAI.DP.LabTest
/// Input：       
/// do ##class(%Library.ResultSet).RunQuery("DHCHAI.DPS.LabTestSetSrv","QryLabSetByCat")
Query QryLabSetByCat(aCatID As %String, aActive As %String = "", aAlias As %String = "") As %Query(ROWSPEC = "ID:%String,TSCode:%String,TestSet:%String,CatID:%String,CatCode:%String,CatDesc:%String,IsActive:%String,IsActDesc:%String,Note:%String,IsSubItem:%String,IsSubItemDesc:%String,IsVirus:%String,IsVirusDesc:%String") [ SqlProc ]
{
}

ClassMethod QryLabSetByCatExecute(ByRef qHandle As %Binary, aCatID As %String, aActive As %String = "", aAlias As %String = "") As %Status
{

	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
    Quit:(aCatID="") $$$OK
	Set xID = ""
	For {
		Set xID = $o(^DHCHAI.DP.LabTestSetI("IndexType",aCatID,xID))
		Quit:xID=""
	  
		Set objLabTest = ##class(DHCHAI.DP.LabTestSet).GetObjById(xID)
		Continue:'$Isobject(objLabTest)
			
		Set TSCode    = objLabTest.BTTSCode
		Set TestSet   = objLabTest.BTTestSet
		Continue:(aAlias'="")&&('(TestSet[aAlias))&&('(TSCode[aAlias))
		Set objLabCat = ##class(DHCHAI.DP.LabTestSetCat).GetObjById(aCatID)
		Continue:'$Isobject(objLabCat)
		Set CatCode = objLabCat.BTCode
		Set CatDesc = objLabCat.BTDesc

		Set IsActive  = objLabTest.BTIsActive
		Set IsActDesc = $s(IsActive=1:"是",1:"否")
		Continue:(aActive'="")&&(IsActive'=aActive) 
		Set Note      = objLabTest.BTNote
		
		Set IsSubItem =objLabTest.BTIsSubItem
		Set IsSubItemDesc = $s(IsSubItem=1:"是",1:"否")
		Set IsVirus =objLabTest.BTIsVirus
		Set IsVirusDesc = $s(IsVirus=1:"是",1:"否")
		
		Set Data = $lb(xID,TSCode,TestSet,aCatID,CatCode,CatDesc,IsActive,IsActDesc,Note,IsSubItem,IsSubItemDesc,IsVirus,IsVirusDesc)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	Quit $$$OK
}

ClassMethod QryLabSetByCatClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryLabSetByCatExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryLabSetByCatFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryLabSetByCatExecute ]
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
/// CreatDate：   2017-05-10
/// Description:  查询检验医嘱对照
/// Table：       DHCHAI.DP.LabTestSetMap
/// Input：       
/// do ##class(%Library.ResultSet).RunQuery("DHCHAI.DPS.LabTestSetSrv","QryLabTestSetMap")
Query QryLabTestSetMap(aFlg As %String = "", aActive As %String = "", aAlias As %String = "") As %Query(ROWSPEC = "ID:%String,TestSet:%String,OrdDesc:%String,MapItemID:%String,MapItemCode:%String,MapItemDesc:%String,MapNote:%String,SCode:%String,IsActive:%String,IsActDesc:%String,ActDate:%String,ActTime:%String,ActUser:%String,HospGroup:%String,TestSet2:%String") [ SqlProc ]
{
}

ClassMethod QryLabTestSetMapExecute(ByRef qHandle As %Binary, aFlg As %String = "", aActive As %String = "", aAlias As %String = "") As %Status
{

	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Set xID = ""
	For {
		Set xID = $o(^DHCHAI.DP.LabTestSetMapD(xID))
		Quit:xID=""
		
		Set objMap = ##class(DHCHAI.DP.LabTestSetMap).GetObjById(xID)
		Continue:'$Isobject(objMap)
		
		Set TestSet   = objMap.BTTestSet
		Set TestSet2  = TestSet
		Set OrdDesc   = objMap.BTOrdDesc
		Continue:(aAlias'="")&&('(TestSet[aAlias))&&('(OrdDesc[aAlias))
		Set MapItemID="",MapItemCode="",MapItemDesc=""
		If $IsObject(objMap.BTMapItemDr){
			Set MapItemID   = objMap.BTMapItemDr.%Id()
			Set MapItemCode = objMap.BTMapItemDr.BTTSCode
			Set MapItemDesc = objMap.BTMapItemDr.BTTestSet
		}
		Continue:(aFlg=0)&&(MapItemID'="")
		Continue:(aFlg=1)&&(MapItemID="")
		Set MapNote   = objMap.BTMapNote
		Set SCode     = objMap.BTSCode
		Set HospGroup=""
		Set objSystem=##class(DHCHAI.BT.SystemMap).GetObjByCode(SCode)
		If $IsObject(objSystem) {
			Set HospGroup=objSystem.BTHospDr.BTGroupDr.BTDesc
		}
		
		Set IsActive  = objMap.BTIsActive
		Continue:(aActive'="")&&(IsActive'=aActive)
		Continue:(aFlg=0)&&(IsActive'=1) //未对照不显示无效项目
		//Continue:objMap.BTMapItemDr.BTCatDr.BTDesc'="微生物送检"
		Set IsActDesc = $s(IsActive=1:"是",1:"否") 
		Set ActDate   = objMap.BTActDate
		Set:ActDate'="" ActDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(ActDate)
		Set ActTime   = objMap.BTActTime
	    Set:ActTime'="" ActTime=$zt(ActTime,1)
		Set ActUser   = objMap.BTActUser
		
		If $d(^DHCHAI.DP.LabVisitTestSetI("IndexTestSetDesc"," "_TestSet)){
			Set TestSet=TestSet_"[√]"
		}
		
		Set Data = $lb(xID,TestSet,OrdDesc,MapItemID,MapItemCode,MapItemDesc,MapNote,SCode,IsActive,IsActDesc,ActDate,ActTime,ActUser,HospGroup,TestSet2)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	Quit $$$OK
}

ClassMethod QryLabTestSetMapClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryLabTestSetMapExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryLabTestSetMapFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryLabTestSetMapExecute ]
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
/// CreatDate：   2017-05-10
/// Description:  根据检验医嘱查询检验医嘱对照
/// Table：       DHCHAI.DP.LabTestSetMap
/// Input：       
/// do ##class(%Library.ResultSet).RunQuery("DHCHAI.DPS.LabTestSetSrv","QryTestMapByItem","1")
Query QryTestMapByItem(aItemID As %String) As %Query(ROWSPEC = "ID:%String,TestSet:%String,OrdDesc:%String,MapItemID:%String,MapItemCode:%String,MapItemDesc:%String,MapNote:%String,SCode:%String,IsActive:%String,IsActDesc:%String,ActDate:%String,ActTime:%String,ActUser:%String,HospGroup:%String") [ SqlProc ]
{
}

ClassMethod QryTestMapByItemExecute(ByRef qHandle As %Binary, aItemID As %String) As %Status
{

	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
    
    Quit:(aItemID="") $$$OK
    
    Set xID = ""
	For {
		Set xID = $o(^DHCHAI.DP.LabTestSetMapI("IndexMapItemDr",aItemID,xID))
		Quit:xID="" 
		
		Set objMap = ##class(DHCHAI.DP.LabTestSetMap).GetObjById(xID)
		Continue:'$Isobject(objMap)
		
		Set TestSet   = objMap.BTTestSet
		Set OrdDesc   = objMap.BTOrdDesc
		Set objTest = ##class(DHCHAI.DP.LabTestSet).GetObjById(aItemID)
		Continue:'$Isobject(objTest)
		Set MapItemCode = objTest.BTTSCode
		Set MapItemDesc = objTest.BTTestSet
		
		Set MapNote   = objMap.BTMapNote
		Set SCode     = objMap.BTSCode
		Set HospGroup=""
		Set objSystem=##class(DHCHAI.BT.SystemMap).GetObjByCode(SCode)
		If $IsObject(objSystem) {
			Set HospGroup=objSystem.BTHospDr.BTGroupDr.BTDesc
		}
		Set IsActive  = objMap.BTIsActive
		Set IsActDesc = $s(IsActive=1:"是",1:"否") 
		Set ActDate   = objMap.BTActDate
		Set:ActDate'="" ActDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(ActDate)
		Set ActTime   = objMap.BTActTime
	    Set:ActTime'="" ActTime=$zt(ActTime,1)
		Set ActUser   = objMap.BTActUser
				
		Set Data = $lb(xID,TestSet,OrdDesc,aItemID,MapItemCode,MapItemDesc,MapNote,SCode,IsActive,IsActDesc,ActDate,ActTime,ActUser,HospGroup)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}

	Quit $$$OK
}

ClassMethod QryTestMapByItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryTestMapByItemExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryTestMapByItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryTestMapByItemExecute ]
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

/// Creator：     zhoubo
/// CreatDate：   2017-07-28
/// Description:  导入检验医嘱字典
/// Table：       DHCHAI.DP.LabTestSet
/// Input：       
/// w ##class("DHCHAI.DPS.LabTestSetSrv").ImportTestSet("","^")
ClassMethod ImportTestSet(aInputStr As %String, aSeparate As %String = "^") As %String
{
	New (aInputStr,aSeparate)
	Set return=-1
	Quit:(aInputStr="")||(aSeparate="") return
	
	Set TestSetDr=""
	Set Code = $p(aInputStr,aSeparate,4)
	Set:Code'="" TestSetDr=$o(^DHCHAI.DP.LabTestSetCatI("IndexCode",Code,0)) 
	Set $p(aInputStr,aSeparate,4) = TestSetDr 
	
	Set return=##Class(DHCHAI.DP.LabTestSet).Update(aInputStr,aSeparate)
	Quit return
}

/// Creator：     pylian
/// CreatDate：   2017-08-04
/// Description:  更新检验医嘱对照
/// Table：       DHCHAI.DP.LabTestSetMap
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.DPS.LabTestSetSrv).UpdateMap("1","1","med")
ClassMethod UpdateMap(ID As %String, SetID As %String, UsersName As %String) As %String
{
	New (ID,SetID,UsersName)
	Set return=0
	Quit:(ID="")||(SetID="") return
	
	Set objMapItem = ##class(DHCHAI.DP.LabTestSet).GetObjById(SetID)
	
	Set obj=##class(DHCHAI.DP.LabTestSetMap).%OpenId(ID)
	Quit:'$IsObject(obj) return
	Set obj.BTMapItemDr	= objMapItem
	Set obj.BTActUser = UsersName
	Set sc=obj.%Save()
	if $system.Status.IsError(sc) {        //检查Save是否成功
		Do $system.OBJ.DisplayError(sc)
		Set return=-1
	}else{
		Set return=obj.%Id()
	}
	Do obj.%Close()
	
	Quit return
}

/// Creator：     pylian
/// CreatDate：   2017-08-04
/// Description:  自动匹配对照规则
/// Table：       DHCHAI.DP.DataMapRule,DHCHAI.DP.LabTestSet,DHCHAI.DP.LabTestSetMap
/// Input：		  aCatDesc：匹配规则表分类描述
/// Return：      正常：处理数据条数
/// w ##Class(DHCHAI.DPS.LabTestSetSrv).SynMapRule("检验医嘱")
ClassMethod SynMapRule(aCatDesc As %String) As %String
{
	New (aCatDesc)
	Set return=""
	Quit:(aCatDesc="") return
	
	Set aCatID=""
	Set objDic  = ##class(DHCHAI.BT.Dictionary).GetObjByDesc("MapRule",aCatDesc)
	If $Isobject(objDic) {
		Set aCatID = objDic.%Id()
	}
	Quit:(aCatID="") return
	
	Set Count=0	
    Set xSCode =""
    For {
	    Set xSCode=$o(^DHCHAI.DP.LabTestSetMapI("IndexSCodeTestSet",xSCode))
	    Quit:xSCode=""
	    
	    Set xTestSet=""
	    For {  
			Set xTestSet=$o(^DHCHAI.DP.LabTestSetMapI("IndexSCodeTestSet",xSCode,xTestSet))
		    Quit:xTestSet=""
			
		    Set xMapID=""
		    For {  
				Set xMapID=$o(^DHCHAI.DP.LabTestSetMapI("IndexSCodeTestSet",xSCode,xTestSet,xMapID))
			    Quit:xMapID=""
				
				Set objMap=##class(DHCHAI.DP.LabTestSetMap).GetObjById(xMapID)
				Continue:'$Isobject(objMap)
				Set MapNote  = objMap.BTMapNote
				Continue:objMap.BTMapItemDr'=""  //已经存在不再同步匹配
				Set SCode    = objMap.BTSCode
				Set IsActive = objMap.BTIsActive
				Set OrdDesc  = objMap.BTOrdDesc
				Set TestSet = objMap.BTTestSet
				Continue:TestSet=""
			    
			    Set SetID = $o(^DHCHAI.DP.LabTestSetI("IndexTestSet",TestSet,0)) //名称一样可直接匹配
			    If (SetID="") {
			     	Set Desc = ""
					Set MapRuleID=$o(^DHCHAI.DP.DataMapRuleI("IndexCatMapDesc",aCatID,0,TestSet,0))  //匹配
					If MapRuleID'="" {
						Set objRule = ##class(DHCHAI.DP.DataMapRule).GetObjById(MapRuleID)
						Continue:'$Isobject(objRule)
						Set Desc   = objRule.BTDesc 
					} Else  {
						Set xMapDesc=""   // 包含（排除）规则
						For {
							Set xMapDesc = $o(^DHCHAI.DP.DataMapRuleI("IndexCatMapDesc",aCatID,1,xMapDesc))
							Quit:xMapDesc=""
							
							Continue:TestSet'[xMapDesc
							Set MapRuleID=$o(^DHCHAI.DP.DataMapRuleI("IndexCatMapDesc",aCatID,1,xMapDesc,0))
							Set objRule=##class(DHCHAI.DP.DataMapRule).GetObjById(MapRuleID)
							Continue:'$Isobject(objRule)
							Set tDesc=objRule.BTDesc
							
							Set xExID="",Flg=0 
							For {
								Set xExID=$o(^DHCHAI.DP.DataMapRuleI("IndexDesc",tDesc,xExID))
								Quit:xExID=""
								
								Set objExRule = ##class(DHCHAI.DP.DataMapRule).GetObjById(xExID)
								Continue:'$Isobject(objExRule)
								Set Type =	objExRule.BTType
								Continue:Type'=2
								Set ExMapDesc = objExRule.BTMapDesc
								Continue:TestSet'[ExMapDesc
								Set Flg=1
								Quit
							}
							Continue:Flg>0
							Set Desc=tDesc
							Quit
						}
					}
					
					Continue:Desc=""
					Set SetID = $o(^DHCHAI.DP.LabTestSetI("IndexTestSet",Desc,0))
					Continue:SetID=""
			    }
				Set InputStr=xMapID
				Set InputStr=InputStr_"^"_TestSet
				Set InputStr=InputStr_"^"_OrdDesc
				Set InputStr=InputStr_"^"_SetID
				Set InputStr=InputStr_"^"_MapNote
				Set InputStr=InputStr_"^"_SCode
				Set InputStr=InputStr_"^"_(+IsActive)
		        Set flg=##class(DHCHAI.DP.LabTestSetMap).Update(InputStr,"^")
		        If flg>0{
					Set Count=Count+1
				}
		    }
	    }
    }
	Quit Count
}

}
