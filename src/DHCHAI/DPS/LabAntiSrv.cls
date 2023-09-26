/// 名称: DHCHAI.DPS.LabAntiSrv
/// 描述: 抗生素相关服务
/// 编写者：pylian
/// 编写日期: 2017-05-09
Class DHCHAI.DPS.LabAntiSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     pylian
/// CreatDate：   2017-05-09
/// Description:  查询抗生素分类
/// Table：       DHCHAI.DP.LabAntiCat
/// Input：       
/// do ##class(%Library.ResultSet).RunQuery("DHCHAI.DPS.LabAntiSrv","QryLabAntiCat")
Query QryLabAntiCat() As %Query(ROWSPEC = "ID:%String,ACCode:%String,ACDesc:%String") [ SqlProc ]
{
}

ClassMethod QryLabAntiCatExecute(ByRef qHandle As %Binary) As %Status
{

	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)

	Set xID = ""
	For {
		Set xID = $o(^DHCHAI.DP.LabAntiCatD(xID))
		Quit:xID=""
	  
		Set objAntiCat = ##class(DHCHAI.DP.LabAntiCat).GetObjById(xID)
		Continue:'$Isobject(objAntiCat)
			
		Set ACCode  = objAntiCat.BTCode  
		Set ACDesc  = objAntiCat.BTDesc 
				
		Set Data = $lb(xID,ACCode,ACDesc)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	Quit $$$OK
}

ClassMethod QryLabAntiCatClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryLabAntiCatExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryLabAntiCatFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryLabAntiCatExecute ]
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
/// CreatDate：   2017-08-15
/// Description:  查询抗生素分类(下拉框使用)
/// Table：       DHCHAI.DP.LabAntiCat
/// Input：       
/// do ##class(%Library.ResultSet).RunQuery("DHCHAI.DPS.LabAntiSrv","QryLabAntiCatSrv")
Query QryLabAntiCatSrv() As %Query(ROWSPEC = "ID:%String,ACCode:%String,ACDesc:%String") [ SqlProc ]
{
}

ClassMethod QryLabAntiCatSrvExecute(ByRef qHandle As %Binary) As %Status
{

	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)

    Set Data= $lb("0","All","全部")
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	
	Set xID = ""
	For {
		Set xID = $o(^DHCHAI.DP.LabAntiCatD(xID))
		Quit:xID=""
	  
		Set objAntiCat = ##class(DHCHAI.DP.LabAntiCat).GetObjById(xID)
		Continue:'$Isobject(objAntiCat)
			
		Set ACCode  = objAntiCat.BTCode  
		Set ACDesc  = objAntiCat.BTDesc 
				
		Set Data = $lb(xID,ACCode,ACDesc)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
		
	Quit $$$OK
}

ClassMethod QryLabAntiCatSrvClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryLabAntiCatSrvExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryLabAntiCatSrvFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryLabAntiCatSrvExecute ]
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
/// Description:  根据分类代码查询抗生素分类
/// Table：       DHCHAI.DP.LabAntiCat
/// Input：       
/// do ##class(%Library.ResultSet).RunQuery("DHCHAI.DPS.LabAntiSrv","QryAntiCatByCode","ANT001")
Query QryAntiCatByCode(aCode As %String) As %Query(ROWSPEC = "CatID:%String,ACCode:%String,ACDesc:%String")
{
}

ClassMethod QryAntiCatByCodeExecute(ByRef qHandle As %Binary, aCode As %String) As %Status
{
	
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:(aCode="") $$$OK
	Set xID = ""
	For {
		Set xID = $o(^DHCHAI.DP.LabAntiCatI("IndexCode",aCode,xID))
		Quit:xID=""
		
		Set objAntiCat = ##class(DHCHAI.DP.LabAntiCat).GetObjById(xID)
		Continue:'$Isobject(objAntiCat)
			
		Set ACCode  = objAntiCat.BTCode  
		Set ACDesc  = objAntiCat.BTDesc 
				
		Set Data = $lb(xID,ACCode,ACDesc)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	Quit $$$OK
}

ClassMethod QryAntiCatByCodeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryAntiCatByCodeExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryAntiCatByCodeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryAntiCatByCodeExecute ]
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

/// w ##class(DHCHAI.DPS.LabAntiSrv).GetAntiDescByID(420)
ClassMethod GetAntiDescByID(id As %String) As %String
{
	New (id)
	Set return=""
	Quit:id="" return
	Quit:'##class(DHCHAI.DP.LabAntibiotic).%ExistsId(+id) return
	
	Set obj=##Class(DHCHAI.DP.LabAntibiotic).%OpenId(+id)
	Set return=obj.BTAntDesc
	Do obj.%Close()
	Quit return
}

/// Creator：     pylian
/// CreatDate：   2017-05-09
/// Description:  查询抗生素
/// Table：       DHCHAI.DP.LabAntibiotic
/// Input：       
/// do ##class(%Library.ResultSet).RunQuery("DHCHAI.DPS.LabAntiSrv","QryLabAntibiotic")
Query QryLabAntibiotic(aAlias As %String = "") As %Query(ROWSPEC = "ID:%String,AntCode:%String,AntDesc:%String,CatID:%String,CatCode:%String,CatDesc:%String,WCode:%String,IsActive:%String,IsActDesc:%String") [ SqlProc ]
{
}

ClassMethod QryLabAntibioticExecute(ByRef qHandle As %Binary, aAlias As %String = "") As %Status
{

	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)

	Set xID = ""
	For {
		Set xID = $o(^DHCHAI.DP.LabAntibioticD(xID))
		Quit:xID=""
	  
		Set objAnti = ##class(DHCHAI.DP.LabAntibiotic).GetObjById(xID)
		Continue:'$Isobject(objAnti)
			
		Set AntCode  = objAnti.BTAntCode
		Set AntDesc  = objAnti.BTAntDesc
		Continue:(aAlias'="")&&('(AntCode[aAlias))&&('(AntDesc[aAlias))
		
		Set AntCatDr = objAnti.BTAntCatDr
		Set AntCatID="",AntCatCode="",AntCatDesc=""
		If $IsObject(objAnti.BTAntCatDr){
			Set AntCatID   = objAnti.BTAntCatDr.%Id()
			Set AntCatCode = objAnti.BTAntCatDr.BTCode
			Set AntCatDesc = objAnti.BTAntCatDr.BTDesc
		}
		Set WCode    = objAnti.BTWCode
		Set IsActive = objAnti.BTIsActive
		Set IsActDesc=$s(IsActive=1:"是",1:"否")
				
		Set Data = $lb(xID,AntCode,AntDesc,AntCatID,AntCatCode,AntCatDesc,WCode,IsActive,IsActDesc)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	Quit $$$OK
}

ClassMethod QryLabAntibioticClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryLabAntibioticExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryLabAntibioticFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryLabAntibioticExecute ]
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
/// Description:  根据抗生素分类查询抗生素
/// Table：       DHCHAI.DP.LabAntibiotic
/// Input：       
/// do ##class(%Library.ResultSet).RunQuery("DHCHAI.DPS.LabAntiSrv","QryAntibioticByCate","1")
Query QryAntibioticByCate(aCateID As %String) As %Query(ROWSPEC = "ID:%String,AntCode:%String,AntDesc:%String,CatID:%String,CatCode:%String,CatDesc:%String,WCode:%String,IsActive:%String,IsActDesc:%String") [ SqlProc ]
{
}

ClassMethod QryAntibioticByCateExecute(ByRef qHandle As %Binary, aCateID As %String) As %Status
{

	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
    
    Quit:(aCateID="") $$$OK
    
    Set xID = ""
	For {
		Set xID = $o(^DHCHAI.DP.LabAntibioticI("IndexAntCatDr",aCateID,xID))
		Quit:xID="" 

		Set objAnti = ##class(DHCHAI.DP.LabAntibiotic).GetObjById(xID)
		Continue:'$Isobject(objAnti)
			
		Set AntCode  = objAnti.BTAntCode
		Set AntDesc  = objAnti.BTAntDesc
		Set AntCatDr = objAnti.BTAntCatDr
		Set AntCatID="",AntCatCode="",AntCatDesc=""
		If $IsObject(objAnti.BTAntCatDr){
			Set AntCatID   = objAnti.BTAntCatDr.%Id()
			Set AntCatCode = objAnti.BTAntCatDr.BTCode
			Set AntCatDesc = objAnti.BTAntCatDr.BTDesc
		}
		Set WCode    = objAnti.BTWCode
		Set IsActive = objAnti.BTIsActive
		Set IsActDesc=$s(IsActive=1:"是",1:"否")
				
		Set Data = $lb(xID,AntCode,AntDesc,AntCatID,AntCatCode,AntCatDesc,WCode,IsActive,IsActDesc)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}

	Quit $$$OK
}

ClassMethod QryAntibioticByCateClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryAntibioticByCateExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryAntibioticByCateFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryAntibioticByCateExecute ]
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
/// CreatDate：   2017-08-15
/// Description:  根据抗生素分类查询抗生素(下拉框使用)
/// Table：       DHCHAI.DP.LabAntibiotic
/// Input：       
/// do ##class(%Library.ResultSet).RunQuery("DHCHAI.DPS.LabAntiSrv","QryAntiByCate","0")
Query QryAntiByCate(aCateID As %String) As %Query(ROWSPEC = "ID:%String,AntCode:%String,AntDesc:%String,CatID:%String,CatCode:%String,CatDesc:%String,WCode:%String,IsActive:%String,IsActDesc:%String") [ SqlProc ]
{
}

ClassMethod QryAntiByCateExecute(ByRef qHandle As %Binary, aCateID As %String) As %Status
{

	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
    
    Quit:(aCateID="") $$$OK
    
    If (aCateID = 0) { 
	    Set xID = ""
		For {
			Set xID = $o(^DHCHAI.DP.LabAntibioticD(xID))
			Quit:xID="" 
			Set objAnti = ##class(DHCHAI.DP.LabAntibiotic).GetObjById(xID)
			Continue:'$Isobject(objAnti)
				
			Set AntCode  = objAnti.BTAntCode
			Set AntDesc  = objAnti.BTAntDesc
			Set AntCatDr = objAnti.BTAntCatDr
			Set AntCatID="",AntCatCode="",AntCatDesc=""
			If $IsObject(objAnti.BTAntCatDr){
				Set AntCatID   = objAnti.BTAntCatDr.%Id()
				Set AntCatCode = objAnti.BTAntCatDr.BTCode
				Set AntCatDesc = objAnti.BTAntCatDr.BTDesc
			}
			Set WCode    = objAnti.BTWCode
			Set IsActive = objAnti.BTIsActive
			Set IsActDesc=$s(IsActive=1:"是",1:"否")
					
			Set Data = $lb(xID,AntCode,AntDesc,AntCatID,AntCatCode,AntCatDesc,WCode,IsActive,IsActDesc)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
		
    }else {
	    Set xID = ""
		For {
			Set xID = $o(^DHCHAI.DP.LabAntibioticI("IndexAntCatDr",aCateID,xID))
			Quit:xID="" 

			Set objAnti = ##class(DHCHAI.DP.LabAntibiotic).GetObjById(xID)
			Continue:'$Isobject(objAnti)
				
			Set AntCode  = objAnti.BTAntCode
			Set AntDesc  = objAnti.BTAntDesc
			Set AntCatDr = objAnti.BTAntCatDr
			Set AntCatID="",AntCatCode="",AntCatDesc=""
			If $IsObject(objAnti.BTAntCatDr){
				Set AntCatID   = objAnti.BTAntCatDr.%Id()
				Set AntCatCode = objAnti.BTAntCatDr.BTCode
				Set AntCatDesc = objAnti.BTAntCatDr.BTDesc
			}
			Set WCode    = objAnti.BTWCode
			Set IsActive = objAnti.BTIsActive
			Set IsActDesc=$s(IsActive=1:"是",1:"否")
					
			Set Data = $lb(xID,AntCode,AntDesc,AntCatID,AntCatCode,AntCatDesc,WCode,IsActive,IsActDesc)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
    }

	Quit $$$OK
}

ClassMethod QryAntiByCateClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryAntiByCateExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryAntiByCateFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryAntiByCateExecute ]
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
/// Description:  查询抗生素字典对照
/// Table：       DHCHAI.DP.LabAntiMap
/// Input：       aFlg:是否关联抗生素字典标志,"":查询全部,0:查询未关联,1:查询已关联
/// do ##class(%Library.ResultSet).RunQuery("DHCHAI.DPS.LabAntiSrv","QryLabAntiMap","")
Query QryLabAntiMap(aFlg As %String = "", LabAnti As %String = "") As %Query(ROWSPEC = "ID:%String,AntiDesc:%String,MapItemID:%String,MapItemCode:%String,MapItemDesc:%String,MapCatID:%String,MapCatCode:%String,MapCatDesc:%String,MapNote:%String,SCode:%String,IsActive:%String,IsActDesc:%String,ActDate:%String,ActTime:%String,ActUser:%String,HospGroup:%String") [ SqlProc ]
{
}

ClassMethod QryLabAntiMapExecute(ByRef qHandle As %Binary, aFlg As %String = "", LabAnti As %String = "") As %Status
{

	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)

	Set MapRuleCatDr=""
	Set objMapRuleCat=##class(DHCHAI.BT.Dictionary).GetObjByDesc("MapRule","检验抗生素")
	If $Isobject(objMapRuleCat) {
		Set MapRuleCatDr=objMapRuleCat.%Id()
	}
	
	Set xID = ""
	For {
		Set xID = $o(^DHCHAI.DP.LabAntiMapD(xID))
		Quit:xID=""
	  
		Set objMap = ##class(DHCHAI.DP.LabAntiMap).GetObjById(xID)
		Continue:'$Isobject(objMap)
		
		Set AntiDesc  = objMap.BTAntiDesc
		Set MapItemID="",MapItemCode="",MapItemDesc=""
		Set MapCatID="",MapCatCode="",MapCatDesc=""
		If $IsObject(objMap.BTMapItemDr){
			Set MapItemID   = objMap.BTMapItemDr.%Id()
			Set MapItemCode = objMap.BTMapItemDr.BTAntCode
			Set MapItemDesc = objMap.BTMapItemDr.BTAntDesc
			Set objAnti=##class(DHCHAI.DP.LabAntibiotic).GetObjById(MapItemID)
			Continue:'$Isobject(objAnti)
			If $IsObject(objAnti.BTAntCatDr){
				Set MapCatID   = objAnti.BTAntCatDr.%Id()
				Set MapCatCode = objAnti.BTAntCatDr.BTCode
				Set MapCatDesc = objAnti.BTAntCatDr.BTDesc
			}
		} Else {
					Set MapCatID="",MapCatCode="",MapItemDesc=""
			/*Set AntiID=$o(^DHCHAI.DP.LabAntibioticI("IndexDesc",AntiDesc,0)) //名称一样可直接匹配
			If AntiID'="" {
				Set objAnti=##class(DHCHAI.DP.LabAntibiotic).GetObjById(AntiID)
				If $IsObject(objAnti){
					Set MapItemDesc=objAnti.BTAntDesc
				}
			} Else {
				Set MapItemDesc=##Class(DHCHAI.DPS.DataMapRuleSrv).GetRuleByMapDesc(MapRuleCatDr,AntiDesc)
				Set:MapItemDesc["^" MapItemDesc=$tr(MapItemDesc,"^","、")
			}
			Set:MapItemDesc'="" MapItemDesc=MapItemDesc_"[!!]"*/
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
		Set IsActDesc=$s(IsActive=1:"是",1:"否")
		Continue:(aFlg=0)&&(IsActive'=1) //未对照不显示无效项目
		Set ActDate  = objMap.BTActDate
		Set:ActDate'="" ActDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(ActDate)
		Set ActTime  = objMap.BTActTime
	    Set:ActTime'="" ActTime=$zt(ActTime,1)
		Set ActUser  = objMap.BTActUser
		
		If $d(^DHCHAI.DP.LabVisitRepRstSenI("IndexAntDesc"," "_AntiDesc)){
			Set AntiDesc=AntiDesc_"[√]"
		}
		Continue:((LabAnti'="")&(AntiDesc'[LabAnti)&(MapItemDesc'[LabAnti)&(MapCatDesc'[LabAnti)&(AntiDesc'[LabAnti))			//过滤搜索条件
		Set Data = $lb(xID,AntiDesc,MapItemID,MapItemCode,MapItemDesc,MapCatID,MapCatCode,MapCatDesc,MapNote,SCode,IsActive,IsActDesc,ActDate,ActTime,ActUser,HospGroup)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	Quit $$$OK
}

ClassMethod QryLabAntiMapClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryLabAntiMapExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryLabAntiMapFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryLabAntiMapExecute ]
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
/// Description:  根据标准抗生素名称查询抗生素字典对照
/// Table：       DHCHAI.DP.LabAntiMap
/// Input：       
/// do ##class(%Library.ResultSet).RunQuery("DHCHAI.DPS.LabAntiSrv","QryAntiMapByItem","1")
Query QryAntiMapByItem(aItemID As %String) As %Query(ROWSPEC = "ID:%String,AntiDesc:%String,MapItemID:%String,MapItemCode:%String,MapItemDesc:%String,MapCatID:%String,MapCatCode:%String,MapCatDesc:%String,MapNote:%String,SCode:%String,IsActive:%String,IsActDesc:%String,ActDate:%String,ActTime:%String,ActUser:%String,HospGroup:%String") [ SqlProc ]
{
}

ClassMethod QryAntiMapByItemExecute(ByRef qHandle As %Binary, aItemID As %String) As %Status
{

	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
    Quit:aItemID="" $$$OK
	Set xID = ""
	For {
		Set xID = $o(^DHCHAI.DP.LabAntiMapD(xID))
		Quit:xID=""
	  
		Set objMap = ##class(DHCHAI.DP.LabAntiMap).GetObjById(xID)
		Continue:'$Isobject(objMap)
			
		Set AntiDesc  = objMap.BTAntiDesc
		Set MapItemDr = objMap.BTMapItemDr
		Set MapItemID="",MapItemCode="",MapItemDesc=""
		Set MapCatID="",MapCatCode="",MapCatDesc=""
		If $IsObject(objMap.BTMapItemDr){
			Set MapItemID   = objMap.BTMapItemDr.%Id()
			Set MapItemCode = objMap.BTMapItemDr.BTAntCode
			Set MapItemDesc = objMap.BTMapItemDr.BTAntDesc
			Set objAnti=##class(DHCHAI.DP.LabAntibiotic).GetObjById(MapItemID)
			Continue:'$Isobject(objAnti)
			If $IsObject(objAnti.BTAntCatDr){
				Set MapCatID   = objAnti.BTAntCatDr.%Id()
				Set MapCatCode = objAnti.BTAntCatDr.BTCode
				Set MapCatDesc = objAnti.BTAntCatDr.BTDesc
			}
		}
		Continue:(aItemID'="")&&(aItemID'=MapItemID)

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

ClassMethod QryAntiMapByItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryAntiMapByItemExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryAntiMapByItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryAntiMapByItemExecute ]
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
/// CreatDate：   2017-08-04
/// Description:  更新抗生素对照
/// Table：       DHCHAI.DP.LabAntiMap
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.DPS.LabAntiSrv).UpdateMap("1","1","med")
ClassMethod UpdateMap(ID As %String, AntiID As %String, UsersName As %String) As %String
{
	New (ID,AntiID,UsersName)
	Set return=0
	Quit:(ID="")||(AntiID="") return
	
	Set objMapItem = ##class(DHCHAI.DP.LabAntibiotic).GetObjById(AntiID)
	Set obj=##class(DHCHAI.DP.LabAntiMap).%OpenId(ID)
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
/// Table：       DHCHAI.DP.DataMapRule,DHCHAI.DP.LabAntibiotic,DHCHAI.DP.LabAntiMap
/// Input：		  aCatID：匹配规则表DHCHAI.DP.DataMapRule.ID
/// Return：      正常：处理数据条数
/// w ##Class(DHCHAI.DPS.LabAntiSrv).SynMapRule("检验抗生素")
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
	    Set xSCode=$o(^DHCHAI.DP.LabAntiMapI("IndexSCodeAntiDesc",xSCode))
	    Quit:xSCode=""
	    
	    Set xAntibiotic=""
	    For {  
			Set xAntibiotic=$o(^DHCHAI.DP.LabAntiMapI("IndexSCodeAntiDesc",xSCode,xAntibiotic))
		    Quit:xAntibiotic=""
		   
		    Set xMapID=""
		    For {  
				Set xMapID=$o(^DHCHAI.DP.LabAntiMapI("IndexSCodeAntiDesc",xSCode,xAntibiotic,xMapID))
			    Quit:xMapID=""
				
				Set objMap=##class(DHCHAI.DP.LabAntiMap).GetObjById(xMapID)
				Continue:'$Isobject(objMap)	
				Set MapNote  = objMap.BTMapNote
				Continue:objMap.BTMapItemDr'=""  //已经存在不再同步匹配
				Set SCode    = objMap.BTSCode
				Set IsActive = objMap.BTIsActive
				
				Set Antibiotic=objMap.BTAntiDesc
				Continue:Antibiotic=""
				Set AntiID=$o(^DHCHAI.DP.LabAntibioticI("IndexDesc",Antibiotic,0)) //名称一样可直接匹配
		     	If AntiID="" {
		     		Set RuleDesc=##Class(DHCHAI.DPS.DataMapRuleSrv).GetRuleByMapDesc(aCatID,Antibiotic)
					Continue:RuleDesc=""
					Continue:$l(RuleDesc,"^")>1
					Set AntiID=$o(^DHCHAI.DP.LabAntibioticI("IndexDesc",RuleDesc,0))
					Continue:AntiID=""
		     	}
				Set InputStr=xMapID
				Set InputStr=InputStr_"^"_Antibiotic
				Set InputStr=InputStr_"^"_AntiID
				Set InputStr=InputStr_"^"_MapNote
				Set InputStr=InputStr_"^"_SCode
				Set InputStr=InputStr_"^"_(+IsActive)
		        Set flg=##class(DHCHAI.DP.LabAntiMap).Update(InputStr,"^")
		        If flg>0{
					Set Count=Count+1
				}
		    }
	    }
    }
	Quit Count
}

/// Creator：     pylian
/// CreatDate：   2017-08-15
/// Description:  根据抗生素获得抗生素分类信息
/// w ##Class(DHCHAI.DPS.LabAntiSrv).GetCatByAnti(1)
ClassMethod GetCatByAnti(aAntiID As %String) As %String
{
	New (aAntiID)
	Set return=""
	Quit:aAntiID="" return
	
	Set objAnti=##class(DHCHAI.DP.LabAntibiotic).GetObjById(aAntiID)
	Set AntCatID="",AntCatCode="",AntCatDesc=""
	If $IsObject(objAnti.BTAntCatDr){
		Set AntCatID   = objAnti.BTAntCatDr.%Id()
		Set AntCatCode = objAnti.BTAntCatDr.BTCode
		Set AntCatDesc = objAnti.BTAntCatDr.BTDesc
	}
	Set return=AntCatID_"^"_AntCatCode_"^"_AntCatDesc
	
	Quit return
}

}
