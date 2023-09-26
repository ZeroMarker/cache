Class DHCMA.IMP.BTS.IMPCateReasonSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhangdc
/// CreatDate：   2020-05-20
/// Description:  根据重点患者分类查询重点患者特因信息
/// Table：       DHCMA.IMP.BT.IMPCateReason      
/// d ##class(%ResultSet).RunQuery("DHCMA.IMP.BTS.IMPCateReasonSrv","QryIMPCateReason",6)
Query QryIMPCateReason(aParRef As %String, aKey As %String = "") As %Query(ROWSPEC = "BTID:%String,aParRef:%String,BTCode:%String,BTDesc:%String,BTIsActive:%String,ID:%String,ActDate:%String,ActTime:%String,ActUserID:%String,xChildID:%String")
{
}

ClassMethod QryIMPCateReasonExecute(ByRef qHandle As %Binary, aParRef As %String, aKey As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	Quit:aParRef="" $$$OK	
 	Set xChildID=""	
 	For
 	{	
 		Set xChildID = $o(^CT.MA.IMP.BTIMPCategoryD(aParRef,"Reason",xChildID))
 		Quit:xChildID=""
 		
 		Set obj = ##class(DHCMA.IMP.BT.IMPCateReason).GetObjById(aParRef_"||"_xChildID)
		Continue:'$IsObject(obj)
 		
 		Set Reason          = obj.BTReasonDr
 		Continue:'$IsObject(Reason)
 		Set (ID,Code,Desc,BTIsActive)=""
 		
 		Set Code             = Reason.BTCode
	 	Set Desc             = Reason.BTDesc 
	 	Set IsActive         = Reason.BTIsActive
	 	Set ID               = Reason.%Id()
	 	//特因字典无效
	 	Continue:(IsActive=0)
 		Continue:(aKey'="")&&(Code'[aKey)&&(Desc'[aKey)
 		Set BTIsActive      = obj.BTIsActive
 		Set BTIsActive=$s(BTIsActive=1:"是",1:"否")
 		Set ActDate      = obj.BTActDate
 		Set ActTime      = obj.BTActTime
 		Set ActUserID    = obj.BTActUserID
 		
		Set Data=$lb(aParRef_"||"_xChildID,aParRef,Code,Desc,BTIsActive,ID,ActDate,ActTime,ActUserID,xChildID)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
 	}
	Quit $$$OK
}

ClassMethod QryIMPCateReasonClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryIMPCateReasonExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryIMPCateReasonFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryIMPCateReasonExecute ]
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

/// Creator：     zhangdc
/// CreatDate：   2020-05-20
/// Description:  取重点患者特因字典信息
/// Table：       DHCMA.IMP.BT.IMPReasonDic
/// Input：       
/// D ##class(%ResultSet).RunQuery("DHCMA.IMP.BTS.IMPCateReasonSrv","QryIMPReasonDic")
Query QryIMPReasonDic(aIsActive As %String = "") As %Query(ROWSPEC = "BTID:%String,ReasCode:%String,ReasDesc:%String,BTIsActive:%String,ActDate:%String,ActTime:%String,ActUserID:%String")
{
}

ClassMethod QryIMPReasonDicExecute(ByRef qHandle As %Binary, aIsActive As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	Set xRowID=0
 	For
 	{
	 	Set xRowID        = $o(^CT.MA.IMP.BTIMPReasonDicD(xRowID))
	 	Quit:xRowID=""
	 	Set objReasonDic     = ##class(DHCMA.IMP.BT.IMPReasonDic).GetObjById(xRowID)
	 	Set Code             = objReasonDic.BTCode
	 	Set Desc             = objReasonDic.BTDesc 
	 	Set IsActive         = objReasonDic.BTIsActive
	 	Continue:(aIsActive'="")&&(IsActive'=1)
	 	Set IsActive = $s(IsActive=1:"是",1:"否")
	 	Set ActDate          = objReasonDic.BTActDate 
	 	Set ActTime          = objReasonDic.BTActTime 
	 	Set ActUserID        = objReasonDic.BTActUserID 
	 	
		Set Data=$lb(xRowID,Code,Desc,IsActive,ActDate,ActTime,ActUserID)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
 	}	
	Quit $$$OK
}

ClassMethod QryIMPReasonDicClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryIMPReasonDicExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryIMPReasonDicFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryIMPReasonDicExecute ]
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
/// CreatDate：   2020-10-13
/// Description:  导入重点患者特因维护
/// return： 	  成功：-1，失败：返回空
/// w ##class(DHCMA.IMP.BTS.IMPCateReasonSrv).ImportIMPCateReason()
ClassMethod ImportIMPCateReason(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=-1
	Quit:aInputStr="" return		
	Set:$g(aSeparete)="" aSeparete="^"
	Set ParrefDesc		 = $p(aInputStr,aSeparete,1)
	Set ChildSub		 = $p(aInputStr,aSeparete,2)
	Set ReasonDesc     	 = $p(aInputStr,aSeparete,3)
	Set IsActive         = +$p(aInputStr,aSeparete,4)
	Set BTActDate		 = +$h
	Set BTActTime		 = +$p($h,",",2)
	Set BTActUserID		 = ""
	
	Set Parref=##class(DHCMA.IMP.BT.IMPCategory).GetObjByDesc(ParrefDesc)
	Set:$IsObject(Parref) Parref=Parref.%Id()
	Quit:Parref="" return
	
	Set ReasonDic=##class(DHCMA.IMP.BT.IMPReasonDic).GetObjByDesc(ReasonDesc)	
	Set:$IsObject(ReasonDic) ReasonDic=ReasonDic.%Id()
	
	Set inputStr=Parref_"^"_ChildSub_"^"_ReasonDic_"^"_IsActive_"^"_BTActDate_"^"_BTActTime_"^"_BTActUserID
	Set return=##class(DHCMA.IMP.BT.IMPCateReason).Update(inputStr)
	//Set:+return<1 return=""
	Quit return
}

}
