/// 名称: DHCHAI.DPS.NoMapCountSrv
/// 描述: 未对照内容数量统计相关服务
/// 编写者：wpl
/// 编写日期: 2020-06-02
Class DHCHAI.DPS.NoMapCountSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     wpl
/// CreatDate：   2020-06-02
/// Description:  细菌字典未对照内容数量统计
/// Table：       DHCHAI.DP.LabBactMap
/// Return：      返回Count
/// w ##class(DHCHAI.DPS.NoMapCountSrv).NoLabBactMap()
ClassMethod NoLabBactMap() As %String
{
	Set Count = 0
	
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
		
		Set IsActive = objMap.BTIsActive
		Continue:IsActive'=1 //未对照不统计
		
		Set MapItemID=""
		If $IsObject(objMap.BTMapItemDr){
			Set MapItemID   = objMap.BTMapItemDr.%Id()
			Set objBact=##class(DHCHAI.DP.LabBacteria).GetObjById(MapItemID)
			Continue:'$Isobject(objBact)
		}
		
		
		Set:MapItemID="" Count=Count+1	
	}
	Quit Count
}

/// Creator：     wpl
/// CreatDate：   2020-06-02
/// Description:  抗生素字典未对照内容数量统计
/// Table：       DHCHAI.DP.LabAntiMap
/// Return：      返回Count
/// w ##class(DHCHAI.DPS.NoMapCountSrv).NoLabAntiMap()
ClassMethod NoLabAntiMap() As %String
{
	Set Count=0
	
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
		
		Set IsActive = objMap.BTIsActive
		Continue:IsActive'=1
		
		Set MapItemID=""
		If $IsObject(objMap.BTMapItemDr){
			Set MapItemID   = objMap.BTMapItemDr.%Id()
			Set objAnti=##class(DHCHAI.DP.LabAntibiotic).GetObjById(MapItemID)
			Continue:'$Isobject(objAnti)
		}
		
		 
		Set:MapItemID="" Count=Count+1	
	}
	Quit Count
}

/// Creator：     wpl
/// CreatDate：   2020-06-02
/// Description:  抗菌药物字典未对照内容数量统计
/// Table：       DHCHAI.DP.OEItmMastMap
/// Return：      返回Count
/// w ##class(DHCHAI.DPS.NoMapCountSrv).NoOEItmMastMap()
ClassMethod NoOEItmMastMap() As %String
{
	Set Count=0
	Set xBTSCode=""
	For {
		Set xBTSCode=$o(^DHCHAI.DP.OEAntiMastMapI("IndexSCodeAnitDesc",xBTSCode))
		Quit:xBTSCode=""
		
		Set xItemAnit=""
		For {
			Set xItemAnit=$o(^DHCHAI.DP.OEAntiMastMapI("IndexSCodeAnitDesc",xBTSCode,xItemAnit))
			Quit:xItemAnit=""
		
			Set xID=""
			For {
				Set xID=$o(^DHCHAI.DP.OEAntiMastMapI("IndexSCodeAnitDesc",xBTSCode,xItemAnit,xID))
				Quit:xID=""
	 	
	 			Set obj=##class(DHCHAI.DP.OEAntiMastMap).GetObjById(xID)
				Continue:'$IsObject(obj)
				
				Set IsActive=obj.BTIsActive
				Continue:IsActive'=1 //未对照不显示无效项目
					
				Set BTMapItemDr=""
				If $IsObject(obj.BTMapItemDr) {
					Set BTMapItemDr=obj.BTMapItemDr.%Id()					
					Set objMast=##class(DHCHAI.DP.OEItmMast).GetObjById(BTMapItemDr)
					Continue:'$IsObject(objMast)
				}
				
				Set:BTMapItemDr="" Count=Count+1	
			}
		}
	}
	Quit Count
}

/// Creator：     wpl
/// CreatDate：   2020-06-02
/// Description:  查询短语分类信息
/// Table：       DHCHAI.DP.PhraseType
/// Return：      返回Count
/// w ##class(DHCHAI.DPS.NoMapCountSrv).PhraseType()
ClassMethod PhraseType() As %Library.ArrayOfDataTypes
{
	Set return=##Class(%Library.ArrayOfDataTypes).%New()
	Set Count=0
	Set xCode = ""
	For {
		Set xCode = $o(^DHCHAI.DP.PhraseTypeI("IndexCode",xCode))
		Quit:xCode=""
		Set xID = ""
		For {
			Set xID = $o(^DHCHAI.DP.PhraseTypeI("IndexCode",xCode,xID))
			Quit:xID=""
			Set objPType = ##class(DHCHAI.DP.PhraseType).GetObjById(xID)
			Continue:'$isobject(objPType)
			
			Set Code        = objPType.BTCode
			Set Desc        = objPType.BTDesc
			Set DicTypeCode = objPType.BTDicType
			Set objDicType  = ##class(DHCHAI.BT.DicType).GetObjByCode(DicTypeCode)
			Set (DicTypeDesc,DicTypeID) = ""
			If ($IsObject(objDicType)) {
				Set DicTypeDesc = objDicType.BTDesc
				Set DicTypeID   = objDicType.%Id()
			}
			Set Count=Count+1
			Set Data = $lb(xID,Code,Desc,DicTypeID,DicTypeCode,DicTypeDesc)
			Do return.SetAt(Data,Count)
		}
	}
	Quit return
}

/// Creator：     guojun
/// CreatDate：   2023-02-27
/// Description:  标本未对照内容数量统计
/// Table：       DHCHAI.DP.LabSpecMap
/// Return：      返回Count
/// w ##class(DHCHAI.DPS.NoMapCountSrv).NoLabSpecMap()
ClassMethod NoLabSpecMap() As %String
{
	set Count=0
	Set xID = ""
	For {
		Set xID = $o(^DHCHAI.DP.LabSpecMapD(xID))
		Quit:xID=""
		Set objMap = ##class(DHCHAI.DP.LabSpecMap).GetObjById(xID)
		Continue:'$Isobject(objMap)
		Set MapItemID=""
		If $IsObject(objMap.BTMapItemDr){
			Set MapItemID   = objMap.BTMapItemDr.%Id()
		}	
		Continue:(MapItemID'="")
		set Count=Count+1
	}
	Quit Count
}

/// Creator：     wpl
/// CreatDate：   2020-06-02
/// Description:  未对照内容数量
/// Input：       无
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCHAI.DPS.NoMapCountSrv","QryNoMapCount")
Query QryNoMapCount() As %Query(ROWSPEC = "TypeDesc:%String,PhraseDesc:%String,Count:%String") [ SqlProc ]
{
}

ClassMethod QryNoMapCountExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
	
	//Set ZIndex=$zn,JIndex=$j,NIndex="QryNoMapCount"
	//Kill ^TMP(ZIndex,JIndex,NIndex)
	
	//细菌对照
	Set NoBactCount=..NoLabBactMap()
	If (NoBactCount'=0){
		set Data=$lb("检验信息维护","细菌对照",NoBactCount)
    	Set ^CacheTemp(repid,ind)=Data
   		Set ind=ind+1
	}
	
	//抗生素对照
	Set NoAntiCount=..NoLabAntiMap()
	If (NoAntiCount'=0){
		set Data=$lb("检验信息维护","抗生素对照",NoAntiCount)
    	Set ^CacheTemp(repid,ind)=Data
   		Set ind=ind+1
	}
	//抗菌药物对照
	Set NoOEItmCount=..NoOEItmMastMap()
	If (NoOEItmCount'=0){
		set Data=$lb("医嘱信息维护","抗菌药物对照",NoOEItmCount)
    	Set ^CacheTemp(repid,ind)=Data
   		Set ind=ind+1
	}
 	
 	// add 2023-02-28 guojun  标本对照
 	Set NoSpecCount=..NoLabSpecMap()
	If (NoSpecCount'=0){
		set Data=$lb("检验信息维护","标本对照",NoSpecCount)
    	Set ^CacheTemp(repid,ind)=Data
   		Set ind=ind+1
	}
 	
 	
 	Set ListTypeArray=..PhraseType()
    For index1=1:1:ListTypeArray.Count() {
		Set TypeInfo=ListTypeArray.GetAt(index1)
		Continue:TypeInfo=""

		Set aTypeID		= $LIST(TypeInfo,1)
		Set PhraseDesc	= $LIST(TypeInfo,3)
		
		Set Count=0
		Set xSCode=""
	    For {
		 	Set xSCode=$o(^DHCHAI.DP.PhraseMapI("IndexTypeCode",xSCode))
		 	Quit:xSCode=""
		
		 	Set xCode=""
		 	For {
			 	Set xCode=$o(^DHCHAI.DP.PhraseMapI("IndexTypeCode",xSCode,aTypeID,xCode))
			 	Quit:xCode=""
			 	
			 	Set xID=0
			 	For {
				 	Set xID=$o(^DHCHAI.DP.PhraseMapI("IndexTypeCode",xSCode,aTypeID,xCode,xID))
				 	Quit:xID=""
			 		
				 	Set obj=##class(DHCHAI.DP.PhraseMap).GetObjById(xID)
				 	Continue:'$IsObject(obj)
				 	
				 	Set IsActive = obj.BTIsActive
				 	Continue:IsActive'=1
				 	
					If $IsObject(obj.BTMapDicDr) {
						Set MapDicDr = obj.BTMapDicDr.%Id()		
					} Else {
						Set MapDicDr = ""
					}
				 	
					Set:MapDicDr="" Count=Count+1
				}
		 	}
		 	
	    }
	    Continue:Count=0
	    set Data=$lb("常用短语对照",PhraseDesc,Count)
    	Set ^CacheTemp(repid,ind)=Data
   		Set ind=ind+1
    }
	Quit $$$OK
}

ClassMethod QryNoMapCountClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryNoMapCountExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryNoMapCountFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryNoMapCountExecute ]
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

/// Creator：     wpl
/// CreatDate：   2020-06-02
/// Description:  未对照内容数量
/// Input：       无
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCHAI.DPS.NoMapCountSrv","QryNoMapSumCount")
Query QryNoMapSumCount() As %Query(ROWSPEC = "SumCount:%String") [ SqlProc ]
{
}

ClassMethod QryNoMapSumCountExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
	Set SumCount=0
	//细菌对照
	Set NoBactCount=..NoLabBactMap()
	Set SumCount=SumCount+NoBactCount
	//抗生素对照
	Set NoAntiCount=..NoLabAntiMap()
	Set SumCount=SumCount+NoAntiCount
	//抗菌药物对照
	Set NoOEItmCount=..NoOEItmMastMap()
	Set SumCount=SumCount+NoOEItmCount
	
 	// add 2023-02-28 guojun  标本对照
 	Set NoSpecCount=..NoLabSpecMap()
	Set SumCount=SumCount+NoSpecCount
	
 	Set ListTypeArray=..PhraseType()
    For index1=1:1:ListTypeArray.Count() {
		Set TypeInfo=ListTypeArray.GetAt(index1)
		Continue:TypeInfo=""

		Set aTypeID		= $LIST(TypeInfo,1)
		Set PhraseDesc	= $LIST(TypeInfo,3)
		
		Set Count=0
		Set xSCode=""
	    For {
		 	Set xSCode=$o(^DHCHAI.DP.PhraseMapI("IndexTypeCode",xSCode))
		 	Quit:xSCode=""
		
		 	Set xCode=""
		 	For {
			 	Set xCode=$o(^DHCHAI.DP.PhraseMapI("IndexTypeCode",xSCode,aTypeID,xCode))
			 	Quit:xCode=""
			 	
			 	Set xID=0
			 	For {
				 	Set xID=$o(^DHCHAI.DP.PhraseMapI("IndexTypeCode",xSCode,aTypeID,xCode,xID))
				 	Quit:xID=""
			 		
				 	Set obj=##class(DHCHAI.DP.PhraseMap).GetObjById(xID)
				 	Continue:'$IsObject(obj)
				 	
				 	Set IsActive = obj.BTIsActive
				 	Continue:IsActive'=1
				 	
					If $IsObject(obj.BTMapDicDr) {
						Set MapDicDr = obj.BTMapDicDr.%Id()		
					} Else {
						Set MapDicDr = ""
					}
				 	
					Set:MapDicDr="" Count=Count+1
				}
		 	}
		 	
	    }
	    Set SumCount=SumCount+Count
	    
    }
    set Data=$lb(SumCount)
    Set ^CacheTemp(repid,ind)=Data
   	Set ind=ind+1
	Quit $$$OK
}

ClassMethod QryNoMapSumCountClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryNoMapSumCountExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryNoMapSumCountFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryNoMapSumCountExecute ]
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
