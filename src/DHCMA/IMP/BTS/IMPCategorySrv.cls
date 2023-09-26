Class DHCMA.IMP.BTS.IMPCategorySrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhangdc
/// CreatDate：   2020-05-20
/// Description:  查询重点患者分类信息
/// Table：       DHCMA.IMP.BT.IMPCategory     
/// d ##class(%ResultSet).RunQuery("DHCMA.IMP.BTS.IMPCategorySrv","QryIMPCategory")
Query QryIMPCategory(aIsActive As %String) As %Query(ROWSPEC = "BTID:%String,CateCode:%String,CateDesc:%String,CateFlag:%String,BTIsActive:%String,ActDate:%String,ActTime:%String,ActUserID:%String,BTIsEnd:%String,BTIsOper:%String,BTIsManMark:%String,BTIsReMark:%String")
{
}

ClassMethod QryIMPCategoryExecute(ByRef qHandle As %Binary, aIsActive As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	Set xRowID=0
 	For
 	{
	 	Set xRowID        = $o(^CT.MA.IMP.BTIMPCategoryD(xRowID))
	 	Quit:xRowID=""
	 	Set objCategory      = ##class(DHCMA.IMP.BT.IMPCategory).GetObjById(xRowID)
	 	Set Code             = objCategory.BTCode
	 	Set Desc             = objCategory.BTDesc  
		Set:Desc'="" Desc = ##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("DHCMA.IMP.BT.IMPCategory","BTDesc","",Desc) 
	 	Set Flag             = objCategory.BTCateFlag
	 	Set IsActive         = objCategory.BTIsActive
	 	Continue:(aIsActive'="")&&(IsActive'=1)
	 	Set IsActive = $s(IsActive=1:"是",1:"否")
	 	Set ActDate          = objCategory.BTActDate
	 	Set ActTime          = objCategory.BTActTime
	 	Set ActUserID        = objCategory.BTActUserID
	 	Set IsEnd            = objCategory.BTIsEnd
	 	Set IsEnd = $s(IsEnd=1:"是",1:"否")
	 	Set IsOper         = objCategory.BTIsOper
	 	Set IsOper = $s(IsOper=1:"是",1:"否")
	 	Set IsManMark         = objCategory.BTIsManMark
	 	Set IsManMark = $s(IsManMark=1:"是",1:"否")
	 	Set IsReMark         = objCategory.BTIsReMark
	 	Set IsReMark = $s(IsReMark=1:"是",1:"否")
	 	
		Set Data=$lb(xRowID,Code,Desc,Flag,IsActive,ActDate,ActTime,ActUserID,IsEnd,IsOper,IsManMark,IsReMark)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
 	}	
	Quit $$$OK
}

ClassMethod QryIMPCategoryClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryIMPCategoryExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryIMPCategoryFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryIMPCategoryExecute ]
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

/// d ##class(%ResultSet).RunQuery("DHCMA.IMP.BTS.IMPCategorySrv","QryCategoryTree")
Query QryCategoryTree(EntityID As %String) As %Query(ROWSPEC = "id:%String,code:%String,text:%String,iconCls:%String,checked:%String,state:%String,attributes:%String")
{
}

ClassMethod QryCategoryTreeExecute(ByRef qHandle As %Binary, EntityID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	Set xRowID=0
 	For
 	{
	 	Set xRowID        = $o(^CT.MA.IMP.BTIMPCategoryD(xRowID))
	 	Quit:xRowID=""
	 	Set objCategory      = ##class(DHCMA.IMP.BT.IMPCategory).GetObjById(xRowID)
	 	Set Code             = objCategory.BTCode
	 	Set Desc             = objCategory.BTDesc 
	 	
		Set Data=$lb(xRowID,Code,Desc,"","","","")
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
 	}
	Quit $$$OK
}

ClassMethod QryCategoryTreeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryCategoryTreeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryCategoryTreeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryCategoryTreeExecute ]
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
