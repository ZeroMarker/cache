Class DHCMA.IMP.BTS.SemanticWordSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhangdc
/// CreatDate：   2020-07-31
/// Description:  根据关键词Code取语义词
/// Table：       DHCMA.IMP.BT.SemanticWord
/// Input：       
/// D ##class(%ResultSet).RunQuery("DHCMA.IMP.BTS.SemanticWordSrv","QrySemanticWByKeyW","NPRH-1")
Query QrySemanticWByKeyW(aCode As %String, aIsActive As %String = "", aKey As %String = "") As %Query(ROWSPEC = "BTID:%String,BTDesc:%String,BTKeyWordDr:%String,BTIsActive:%String")
{
}

ClassMethod QrySemanticWByKeyWExecute(ByRef qHandle As %Binary, aCode As %String, aIsActive As %String = "", aKey As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	Quit:aCode="" $$$OK
 	Set objKeyWord = ##class(DHCMA.IMP.BT.IMPKeyword).GetObjByCode(aCode)
 	
 	Quit:'$Isobject(objKeyWord) $$$OK
 	Set KeyWordDr = objKeyWord.%Id()
 	
 	Set xSemaWord = ""
 	For {
	 	Set xSemaWord= $o(^CT.MA.IMP.BTSemanticWordI("IdxofKeySemaWord",KeyWordDr,xSemaWord))
	 	Quit:xSemaWord=""
	 	
	 	Set RowID = ""
	 	For {
		   	Set RowID= $o(^CT.MA.IMP.BTSemanticWordI("IdxofKeyWordDrCode",KeyWordDr,xSemaWord,RowID))
		   	Quit:RowID=""
	 	
		 	Set BTObj= ##class(DHCMA.IMP.BT.SemanticWord).GetObjById(RowID)
		 	Continue:'$IsObject(BTObj)
		 	//Set Code         = BTObj.BTCode
		 	Set Desc         = BTObj.BTSemaWord
		 	continue:(aKey'="")&&(Desc'[aKey)
		    Set BTKeyWordDr     = BTObj.BTKeywordDr.BTDesc
		    Set IsActive	 = BTObj.BTIsActive
		 	Continue:(aIsActive'="")&&(IsActive'=1)
		 	
			Set Data=$lb(RowID,Desc,BTKeyWordDr,IsActive)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
	 	
 	}	
	Quit $$$OK
}

ClassMethod QrySemanticWByKeyWClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QrySemanticWByKeyWExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QrySemanticWByKeyWFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QrySemanticWByKeyWExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：     zhangdc
/// CreatDate：   2020-08-3
/// Description:  根据重点患者分类取语义词
/// Table：       DHCMA.IMP.BT.SemanticWord	  
/// w ##class(DHCMA.IMP.BTS.SemanticWordSrv).QrySemanticWByCategory(9)
ClassMethod QrySemanticWByCategory(aCategory As %String) As %String
{
	New (aCategory)
	Set return=""
	Quit:(aCategory="") return
	
	Set xChildID = ""
	Set xId = ""
	For {
		Set xChildID= $o(^CT.MA.IMP.BTIMPCategoryD(aCategory,"Keys",xChildID))
		Quit:xChildID=""
		Set obj = ##class(DHCMA.IMP.BT.IMPCateKeys).GetObjById(aCategory_"||"_xChildID)
		Continue:'$IsObject(obj)
		Set xId=obj.BTKeywordDr.%Id()
		
		Set RowID = ""
		For {
			Set RowID= $o(^CT.MA.IMP.BTSemanticWordI("IdxofKeywordDr",xId,RowID))
			Quit:RowID=""
			
			Set BTObj= ##class(DHCMA.IMP.BT.SemanticWord).GetObjById(RowID)
			Continue:'$IsObject(BTObj)
			
			Set Desc         = BTObj.BTSemaWord
			Set BTKeyWordDr  = BTObj.BTKeywordDr.BTDesc
			Set IsActive	 = BTObj.BTIsActive
			Continue:(IsActive'=1)
			Set:Desc'="" return=return_","_Desc
		}
	}
	Set:return'="" return=$e(return,2,$l(return))
	Quit return
}

/// Creator：     zhangdc
/// CreatDate：   2020-10-12
/// Description:  根据关键词id取语义词
/// Table：       DHCMA.IMP.BT.SemanticWord
/// Input：       
/// D ##class(%ResultSet).RunQuery("DHCMA.IMP.BTS.SemanticWordSrv","QrySemanticWByKeyI","1")
Query QrySemanticWByKeyI(aParRef As %String, aIsActive As %String = "", aKey As %String = "") As %Query(ROWSPEC = "BTID:%String,BTDesc:%String,BTKeyWordDr:%String,BTIsActive:%String")
{
}

ClassMethod QrySemanticWByKeyIExecute(ByRef qHandle As %Binary, aParRef As %String, aIsActive As %String = "", aKey As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	Quit:aParRef="" $$$OK
 	Set objKeyWord = ##class(DHCMA.IMP.BT.IMPKeyword).GetObjById(aParRef)
 	
 	Quit:'$Isobject(objKeyWord) $$$OK
 	Set KeyWordDr = objKeyWord.%Id()
 
 	Set xSemaWord = ""
 	For {
	 	Set xSemaWord= $o(^CT.MA.IMP.BTSemanticWordI("IdxofKeySemaWord",KeyWordDr,xSemaWord))
	 	Quit:xSemaWord=""
	 	
	 	Set RowID = ""
	 	For {
		   	Set RowID= $o(^CT.MA.IMP.BTSemanticWordI("IdxofKeySemaWord",KeyWordDr,xSemaWord,RowID))
		   	Quit:RowID=""
	 		
		 	Set BTObj= ##class(DHCMA.IMP.BT.SemanticWord).GetObjById(RowID)
		 	Continue:'$IsObject(BTObj)
		 	//Set Code         = BTObj.BTCode
		 	Set Desc         = BTObj.BTSemaWord
		 	continue:(aKey'="")&&(Desc'[aKey)
		    Set BTKeyWordDr     = BTObj.BTKeywordDr.BTDesc
		    Set IsActive	 = BTObj.BTIsActive
		 	Continue:(aIsActive'="")&&(IsActive'=1)
		 	Set IsActive = $s(IsActive=1:"是",1:"否")
		 	
			Set Data=$lb(RowID,Desc,BTKeyWordDr,IsActive)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
	 	
 	}	
	Quit $$$OK
}

ClassMethod QrySemanticWByKeyIClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QrySemanticWByKeyIExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QrySemanticWByKeyIFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QrySemanticWByKeyIExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

}
