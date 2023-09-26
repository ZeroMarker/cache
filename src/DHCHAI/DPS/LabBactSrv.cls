/// 名称: DHCHAI.DPS.LabBactSrv
/// 描述: 细菌相关服务
/// 编写者：pylian
/// 编写日期: 2017-05-09
Class DHCHAI.DPS.LabBactSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     pylian
/// CreatDate：   2017-05-09
/// Description:  查询细菌分类
/// Table：       DHCHAI.DP.LabBactCat
/// Input：       
/// do ##class(%Library.ResultSet).RunQuery("DHCHAI.DPS.LabBactSrv","QryLabBactCat")
Query QryLabBactCat() As %Query(ROWSPEC = "ID:%String,BCCode:%String,BCDesc:%String") [ SqlProc ]
{
}

ClassMethod QryLabBactCatExecute(ByRef qHandle As %Binary) As %Status
{

	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)

	Set xID = ""
	For {
		Set xID = $o(^DHCHAI.DP.LabBactCatD(xID))
		Quit:xID=""
	  
		Set objBactCat = ##class(DHCHAI.DP.LabBactCat).GetObjById(xID)
		Continue:'$Isobject(objBactCat)
			
		Set BCCode  = objBactCat.BTCode  
		Set BCDesc  = objBactCat.BTDesc 
				
		Set Data = $lb(xID,BCCode,BCDesc)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	Quit $$$OK
}

ClassMethod QryLabBactCatClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryLabBactCatExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryLabBactCatFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryLabBactCatExecute ]
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
/// CreatDate：   2017-05-20
/// Description:  查询细菌类型
/// Table：       DHCHAI.DP.LabBactType
/// Input：       
/// do ##class(%Library.ResultSet).RunQuery("DHCHAI.DPS.LabBactSrv","QryLabBactType")
Query QryLabBactType() As %Query(ROWSPEC = "ID:%String,BCCode:%String,BCDesc:%String") [ SqlProc ]
{
}

ClassMethod QryLabBactTypeExecute(ByRef qHandle As %Binary) As %Status
{

	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)

	Set xID = ""
	For {
		Set xID = $o(^DHCHAI.DP.LabBactTypeD(xID))
		Quit:xID=""
	  
		Set objBactType = ##class(DHCHAI.DP.LabBactType).GetObjById(xID)
		Continue:'$Isobject(objBactType)
			
		Set BCCode  = objBactType.BTCode  
		Set BCDesc  = objBactType.BTDesc 
				
		Set Data = $lb(xID,BCCode,BCDesc)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	Quit $$$OK
}

ClassMethod QryLabBactTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryLabBactCatExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryLabBactTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryLabBactCatExecute ]
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
/// CreatDate：   2020-07-28
/// Description:  查询细菌菌属
/// Table：       DHCHAI.DP.LabBactGenus
/// Input：       
/// do ##class(%Library.ResultSet).RunQuery("DHCHAI.DPS.LabBactSrv","QryLabBactGenus")
Query QryLabBactGenus() As %Query(ROWSPEC = "ID:%String,BCCode:%String,BCDesc:%String") [ SqlProc ]
{
}

ClassMethod QryLabBactGenusExecute(ByRef qHandle As %Binary) As %Status
{

	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)

	Set xID = ""
	For {
		Set xID = $o(^CT.MA.HAI.DP.LabBactGenusD(xID))
		Quit:xID=""
	  
		Set objGenus = ##class(DHCHAI.DP.LabBactGenus).GetObjById(xID)
		Continue:'$Isobject(objGenus)
			
		Set BCCode  = objGenus.BTCode  
		Set BCDesc  = objGenus.BTDesc 
				
		Set Data = $lb(xID,BCCode,BCDesc)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	Quit $$$OK
}

ClassMethod QryLabBactGenusClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryLabBactGenusExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryLabBactGenusFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryLabBactGenusExecute ]
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
/// CreatDate：   2017-05-09
/// Description:  根据分类代码查询细菌分类
/// Table：       DHCHAI.DP.LabBactCat
/// Input：       
/// do ##class(%Library.ResultSet).RunQuery("DHCHAI.DPS.LabBactSrv","QryBactCatByCode","TJ")
Query QryBactCatByCode(aCode As %String) As %Query(ROWSPEC = "ID:%String,BCCode:%String,BCDesc:%String")
{
}

ClassMethod QryBactCatByCodeExecute(ByRef qHandle As %Binary, aCode As %String) As %Status
{
	
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:(aCode="") $$$OK
	Set xID = ""
	For {
		Set xID = $o(^DHCHAI.DP.LabBactCatI("IndexCode",aCode,xID))
		Quit:xID=""
		
		Set objBactCat = ##class(DHCHAI.DP.LabBactCat).GetObjById(xID)
		Continue:'$Isobject(objBactCat)
			
		Set BCCode  = objBactCat.BTCode  
		Set BCDesc  = objBactCat.BTDesc 
				
		Set Data = $lb(xID,BCCode,BCDesc)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	Quit $$$OK
}

ClassMethod QryBactCatByCodeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryBactCatByCodeExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryBactCatByCodeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryBactCatByCodeExecute ]
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
/// CreatDate：   2017-05-09
/// Description:  查询细菌
/// Table：       DHCHAI.DP.LabBacteria
/// Input：       
/// do ##class(%Library.ResultSet).RunQuery("DHCHAI.DPS.LabBactSrv","QryLabBacteria","312")
Query QryLabBacteria(aAlias As %String = "", aIsCommon As %String = "") As %Query(ROWSPEC = "ID:%String,BacCode:%String,BacDesc:%String,BacName:%String,TypeID:%String,TypeCode:%String,TypeDesc:%String,CatID:%String,CatCode:%String,CatDesc:%String,WCode:%String,IsActive:%String,IsActDesc:%String,GenusID:%String,GenusCode:%String,GenusDesc:%String,IsCommon:%String,IsCommonDesc:%String,IsSkinBact:%String,IsSkinBactDesc:%String") [ SqlProc ]
{
}

ClassMethod QryLabBacteriaExecute(ByRef qHandle As %Binary, aAlias As %String = "", aIsCommon As %String = "") As %Status
{

	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)

	Set xID = ""
	For {
		Set xID = $o(^DHCHAI.DP.LabBacteriaD(xID))
		Quit:xID=""
	  
		Set objBact = ##class(DHCHAI.DP.LabBacteria).GetObjById(xID)
		Continue:'$Isobject(objBact)
			
		Set BacCode  = objBact.BTBacCode
		Set BacDesc  = objBact.BTBacDesc
		
        Set ChineseSpell=##class(DHCHAI.Utils.CommonSrv).ToChineseSpell(BacDesc)
        Continue:(aAlias'="")&&('(BacCode[aAlias))&&('(BacDesc[aAlias))&&('(ChineseSpell[$ZCONVERT(aAlias,"U")))
		Set TypeID="",TypeCode="",TypeDesc=""
		If $IsObject(objBact.BTTypeDr){
			Set TypeID   = objBact.BTTypeDr.%Id()
			Set TypeCode = objBact.BTTypeDr.BTCode
			Set TypeDesc = objBact.BTTypeDr.BTDesc
		}
		Set BacCatID="",BacCatCode="",BacCatDesc=""
		If $IsObject(objBact.BTCatDr){
			Set BacCatID   = objBact.BTCatDr.%Id()
			Set BacCatCode = objBact.BTCatDr.BTCode
			Set BacCatDesc = objBact.BTCatDr.BTDesc
		}
		Set WCode    = objBact.BTWCode
		Set BacName  = objBact.BTBacName
		Set IsActive = objBact.BTIsActive
		Set IsActDesc=$s(IsActive=1:"是",1:"否")
		
		Set GenusID="",GenusCode="",GenusDesc=""
		If $IsObject(objBact.BTGenusDr){
			Set GenusID   = objBact.BTGenusDr.%Id()
			Set GenusCode = objBact.BTGenusDr.BTCode
			Set GenusDesc = objBact.BTGenusDr.BTDesc
		}
		Set IsCommon = objBact.BTIsCommon
		Continue:(aIsCommon'="")&&(IsCommon'=aIsCommon)
		Set IsCommonDesc=$s(IsCommon=1:"是",1:"否")
		
		Set IsSkinBact = objBact.BTIsSkinBact
		Set IsSkinBactDesc=$s(IsSkinBact=1:"是",1:"否")
		
		Set:BacDesc["\" BacDesc=$tr(BacDesc,"\","")
		Set:BacName["\" BacName=$tr(BacName,"\","")	
		Set Data = $lb(xID,BacCode,BacDesc,BacName,TypeID,TypeCode,TypeDesc,BacCatID,BacCatCode,BacCatDesc,WCode,IsActive,IsActDesc,GenusID,GenusCode,GenusDesc,IsCommon,IsCommonDesc,IsSkinBact,IsSkinBactDesc)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	Quit $$$OK
}

ClassMethod QryLabBacteriaClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryLabBacteriaExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryLabBacteriaFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryLabBacteriaExecute ]
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
/// CreatDate：   2017-05-09
/// Description:  根据细菌分类查询细菌
/// Table：       DHCHAI.DP.LabBacteria
/// Input：       
/// do ##class(%Library.ResultSet).RunQuery("DHCHAI.DPS.LabBactSrv","QryBacteriaByCate","1")
Query QryBacteriaByCate(aCateID As %String) As %Query(ROWSPEC = "ID:%String,BacCode:%String,BacDesc:%String,BacName:%String,CatID:%String,CatCode:%String,CatDesc:%String,WCode:%String,IsActive:%String,IsActDesc:%String") [ SqlProc ]
{
}

ClassMethod QryBacteriaByCateExecute(ByRef qHandle As %Binary, aCateID As %String) As %Status
{

	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
    
    Quit:(aCateID="") $$$OK
    
    Set xID = ""
	For {
		Set xID = $o(^DHCHAI.DP.LabBacteriaI("IndexBacCatDr",aCateID,xID))
		Quit:xID="" 

		Set objBact = ##class(DHCHAI.DP.LabBacteria).GetObjById(xID)
		Continue:'$Isobject(objBact)
			
		Set BacCode  = objBact.BTBacCode
		Set BacDesc  = objBact.BTBacDesc
		Set BacCatDr = objBact.BTBacCatDr
		Set BacCatID="",BacCatCode="",BacCatDesc=""
		If $IsObject(objBact.BTBacCatDr){
			Set BacCatID   = objBact.BTBacCatDr.%Id()
			Set BacCatCode = objBact.BTBacCatDr.BTCode
			Set BacCatDesc = objBact.BTBacCatDr.BTDesc
		}
		Set WCode    = objBact.BTWCode
		Set BacName  = objBact.BTBacName
		Set IsActive = objBact.BTIsActive
		Set IsActDesc=$s(IsActive=1:"是",1:"否")
				
		Set Data = $lb(xID,BacCode,BacDesc,BacName,BacCatID,BacCatCode,BacCatDesc,WCode,IsActive,IsActDesc)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}

	Quit $$$OK
}

ClassMethod QryBacteriaByCateClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryBacteriaByCateExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryBacteriaByCateFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryBacteriaByCateExecute ]
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
/// CreatDate：   2017-05-09
/// Description:  细菌字典对照
/// Table：       DHCHAI.DP.LabBactMap
/// Input：       aFlg:是否关联细菌字典标志,"":查询全部,0:查询未关联,1:查询已关联
/// do ##class(%Library.ResultSet).RunQuery("DHCHAI.DPS.LabBactSrv","QryLabBactMap","")
Query QryLabBactMap(aFlg As %String = "") As %Query(ROWSPEC = "ID:%String,Bacteria:%String,MapItemID:%String,MapItemCode:%String,MapItemDesc:%String,MapCatID:%String,MapCatCode:%String,MapCatDesc:%String,MapNote:%String,SCode:%String,IsActive:%String,IsActDesc:%String,ActDate:%String,ActTime:%String,ActUser:%String,HospGroup:%String") [ SqlProc ]
{
}

ClassMethod QryLabBactMapExecute(ByRef qHandle As %Binary, aFlg As %String = "") As %Status
{

	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Set MapRuleCatDr=""
	Set objMapRuleCat=##class(DHCHAI.BT.Dictionary).GetObjByDesc("MapRule","检验细菌")
	If $Isobject(objMapRuleCat) {
		Set MapRuleCatDr=objMapRuleCat.%Id()
	}
	
	Set xID = ""
	For {
		Set xID = $o(^DHCHAI.DP.LabBactMapD(xID))
		Quit:xID=""
	  
		Set objMap = ##class(DHCHAI.DP.LabBactMap).GetObjById(xID)
		Continue:'$Isobject(objMap)
			
		Set Bacteria  = objMap.BTBacteria
		Set MapItemDr = objMap.BTMapItemDr
		Set MapItemID="",MapItemCode="",MapItemDesc=""
		Set MapCatID="",MapCatCode="",MapCatDesc=""
		If $IsObject(objMap.BTMapItemDr){
			Set MapItemID   = objMap.BTMapItemDr.%Id()
			Set MapItemCode = objMap.BTMapItemDr.BTBacCode
			Set MapItemDesc = objMap.BTMapItemDr.BTBacDesc
			Set objBact=##class(DHCHAI.DP.LabBacteria).GetObjById(MapItemID)
			Continue:'$Isobject(objBact)
			If $IsObject(objBact.BTCatDr){
				Set MapCatID   = objBact.BTCatDr.%Id()
				Set MapCatCode = objBact.BTCatDr.BTCode
				Set MapCatDesc = objBact.BTCatDr.BTDesc
			}
		} Else {
			Set BactID=$o(^DHCHAI.DP.LabBacteriaI("IndexDesc",Bacteria,0)) //名称一样可直接匹配
			If BactID'="" {
				Set objBact=##class(DHCHAI.DP.LabBacteria).GetObjById(BactID)
				If $IsObject(objBact){
					Set MapItemDesc=objBact.BTBacDesc
				}
			} Else {
				Set MapItemDesc=##Class(DHCHAI.DPS.DataMapRuleSrv).GetRuleByMapDesc(MapRuleCatDr,Bacteria)
				Set:MapItemDesc["^" MapItemDesc=$tr(MapItemDesc,"^","、")
			}
			Set:MapItemDesc'="" MapItemDesc=MapItemDesc_"[!!]"
		}
		Continue:(aFlg=0)&&(MapItemID'="")
		Continue:(aFlg=1)&&(MapItemID="")
		
		Set MapNote  = objMap.BTMapNote
		Set SCode    = objMap.BTSCode
		Set HospGroup=""
		Set objSystem=##class(DHCHAI.BT.SystemMap).GetObjByCode(SCode)
		If $IsObject(objSystem) {
			Set HospGroup=objSystem.BTHospDr.BTGroupDr.BTDesc
		}
		
		Set IsActive = objMap.BTIsActive
		Continue:(aFlg=0)&&(IsActive'=1) //未对照不显示无效项目
		Set IsActDesc=$s(IsActive=1:"是",1:"否")
		Set ActDate  = objMap.BTActDate
		Set:ActDate'="" ActDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(ActDate)
		Set ActTime  = objMap.BTActTime
	    Set:ActTime'="" ActTime=$zt(ActTime,1)
		Set ActUser  = objMap.BTActUser
		
		If $d(^DHCHAI.DP.LabVisitRepResultI("IndexRstFormatResult"," V"," "_Bacteria))
			||$d(^DHCHAI.DP.LabVisitRepResultI("IndexRstFormatResult"," M"," "_Bacteria))
		{
			Set Bacteria=Bacteria_"[√]"
		}
		
		Set Data=$lb(xID,Bacteria,MapItemID,MapItemCode,MapItemDesc,MapCatID,MapCatCode,MapCatDesc,MapNote,SCode,IsActive,IsActDesc,ActDate,ActTime,ActUser,HospGroup)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	Quit $$$OK
}

ClassMethod QryLabBactMapClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryLabBactMapExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryLabBactMapFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryLabBactMapExecute ]
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
/// CreatDate：   2017-05-09
/// Description:  根据标准细菌名称细菌字典对照
/// Table：       DHCHAI.DP.LabBactMap
/// Input：       
/// do ##class(%Library.ResultSet).RunQuery("DHCHAI.DPS.LabBactSrv","QryBactMapByItem","1")
Query QryBactMapByItem(aItemID As %String) As %Query(ROWSPEC = "ID:%String,Bacteria:%String,MapItemID:%String,MapItemCode:%String,MapItemDesc:%String,MapCatID:%String,MapCatCode:%String,MapCatDesc:%String,MapNote:%String,SCode:%String,IsActive:%String,IsActDesc:%String,ActDate:%String,ActTime:%String,ActUser:%String,HospGroup:%String") [ SqlProc ]
{
}

ClassMethod QryBactMapByItemExecute(ByRef qHandle As %Binary, aItemID As %String) As %Status
{

	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
    Quit:aItemID="" $$$OK
    
	Set xID = ""
	For {
		Set xID = $o(^DHCHAI.DP.LabBactMapD(xID))
		Quit:xID=""
	  
		Set objMap = ##class(DHCHAI.DP.LabBactMap).GetObjById(xID)
		Continue:'$Isobject(objMap)
			
		Set Bacteria  = objMap.BTBacteria
		Set MapItemDr = objMap.BTMapItemDr
		Set MapItemID="",MapItemCode="",MapItemDesc=""
		If $IsObject(objMap.BTMapItemDr){
			Set MapItemID   = objMap.BTMapItemDr.%Id()
			Set MapItemCode = objMap.BTMapItemDr.BTBacCode
			Set MapItemDesc = objMap.BTMapItemDr.BTBacDesc
		}
		Continue:(aItemID'="")&&(aItemID'=MapItemID)
		Set MapCatDr = objMap.BTMapCatDr
		Set MapCatID="",MapCatCode="",MapCatDesc=""
		If $IsObject(objMap.BTMapCatDr){
			Set MapCatID   = objMap.BTMapCatDr.%Id()
			Set MapCatCode = objMap.BTMapCatDr.BTCode
			Set MapCatDesc = objMap.BTMapCatDr.BTDesc
		}
		Set MapNote  = objMap.BTMapNote
		Set SCode    = objMap.BTSCode
		Set HospGroup=""
		Set objSystem=##class(DHCHAI.BT.SystemMap).GetObjByCode(SCode)
		If $IsObject(objSystem) {
			Set HospGroup=objSystem.BTHospDr.BTGroupDr.BTDesc
		}
		Set IsActive = objMap.BTIsActive
		Set IsActDesc=$s(IsActive=1:"是",1:"否")
		Set ActDate  = objMap.BTActDate
		Set:ActDate'="" ActDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(ActDate)
		Set ActTime  = objMap.BTActTime
	    Set:ActTime'="" ActTime=$zt(ActTime,1)
		Set ActUser  = objMap.BTActUser
		
				
		Set Data = $lb(xID,AntiDesc,MapItemID,MapItemCode,MapItemDesc,MapCatID,MapCatCode,MapCatDesc,MapNote,SCode,IsActive,IsActDesc,ActDate,ActTime,ActUser,HospGroup)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	Quit $$$OK
}

ClassMethod QryBactMapByItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryBactMapByItemExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryBactMapByItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryBactMapByItemExecute ]
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
/// CreatDate：   2017-08-02
/// Description:  更新细菌分类对照
/// Table：       DHCHAI.DP.LabBactMap
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.DPS.LabBactSrv).UpdateMap("1","1","med")
ClassMethod UpdateMap(ID As %String, BactID As %String, UsersName As %String) As %String
{
	New (ID,BactID,UsersName)
	Set return=0
	Quit:(ID="")||(BactID="") return
	
	Set objMapItem = ##class(DHCHAI.DP.LabBacteria).GetObjById(BactID)

	Set obj=##class(DHCHAI.DP.LabBactMap).%OpenId(ID)
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
/// Table：       DHCHAI.DP.DataMapRule,DHCHAI.DP.LabBacteria,DHCHAI.DP.LabBactMap
/// Input：		  aCatID：匹配规则表DHCHAI.DP.DataMapRule.ID
/// Return：      正常：处理数据条数
/// w ##Class(DHCHAI.DPS.LabBactSrv).SynMapRule("116")
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
	    Set xSCode=$o(^DHCHAI.DP.LabBactMapI("IndexSCodeBacteria",xSCode))
	    Quit:xSCode=""
	    
	    Set xBacteria=""
	    For {  
			Set xBacteria=$o(^DHCHAI.DP.LabBactMapI("IndexSCodeBacteria",xSCode,xBacteria))
		    Quit:xBacteria=""
		   
		    Set xMapID=""
		    For {  
				Set xMapID=$o(^DHCHAI.DP.LabBactMapI("IndexSCodeBacteria",xSCode,xBacteria,xMapID))
			    Quit:xMapID=""
				
				Set objMap=##class(DHCHAI.DP.LabBactMap).GetObjById(xMapID)
				Continue:'$Isobject(objMap)	
				Set MapNote  = objMap.BTMapNote
				Continue:objMap.BTMapItemDr'=""  //已经存在不再同步匹配
				Set SCode    = objMap.BTSCode
				Set IsActive = objMap.BTIsActive
				
				Set Bacteria = objMap.BTBacteria
				Continue:Bacteria=""
				Set BactID=$o(^DHCHAI.DP.LabBacteriaI("IndexDesc",Bacteria,0)) //名称一样可直接匹配
				If BactID="" {
		     		Set RuleDesc=##Class(DHCHAI.DPS.DataMapRuleSrv).GetRuleByMapDesc(aCatID,Bacteria)
					Continue:RuleDesc=""
					Continue:$l(RuleDesc,"^")>1
					Set BactID=$o(^DHCHAI.DP.LabBacteriaI("IndexDesc",RuleDesc,0))
					Continue:BactID=""
		     	}
				Set InputStr=xMapID
				Set InputStr=InputStr_"^"_Bacteria
				Set InputStr=InputStr_"^"_BactID
				Set InputStr=InputStr_"^"_MapNote
				Set InputStr=InputStr_"^"_SCode
				Set InputStr=InputStr_"^"_(+IsActive)
		        Set flg=##class(DHCHAI.DP.LabBactMap).Update(InputStr,"^")
		        If flg>0{
					Set Count=Count+1
				}
		    }
	    }
    }
	Quit Count
}

/// Creator：     ShenC
/// CreatDate：   2020-04-20
/// Description:  根据ID取细菌名称(横断面)
/// Table：       DHCHAI.DP.DataMapRule,DHCHAI.DP.LabBacteria,DHCHAI.DP.LabBactMap
/// Input：		  aBacId
/// Return：      
/// w ##class(DHCHAI.DPS.LabBactSrv).GetBacteriaById(312)
ClassMethod GetBacteriaById(BacId As %String) As %String
{
	new (BacId)
	Set BacDesc=""
	Set xID = ""
	For {
		Set xID = $o(^DHCHAI.DP.LabBacteriaD(xID))
		Quit:xID=""
	  
		Set objBact = ##class(DHCHAI.DP.LabBacteria).GetObjById(xID)
		Continue:'$Isobject(objBact)
		
		Set BacDesc  = objBact.BTBacDesc
		Quit:BacId=xID 
	}
	Quit BacDesc
}

}
