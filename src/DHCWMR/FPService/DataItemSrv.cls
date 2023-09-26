/// 名称: DHCWMR.FPService.DataItemSrv
/// 描述: 数据项定义服务
/// 编写者：zhufei
/// 编写日期: 2014-08-18
Class DHCWMR.FPService.DataItemSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// w ##Class(DHCWMR.FPService.DataItemSrv).GetEPRData(10084376,"HDSD00.11.407")
ClassMethod GetEPRData(aEpisodeID As %String, aElCode As %String, aVType As %String = "", ByRef ArrGlossary As %ArrayOfDataTypes) As %String
{
	New (aEpisodeID,aElCode,aVType,ArrGlossary)
	Set return=""
	Quit:(aEpisodeID="")||(aElCode="") return
	
	Set ItemID=$o(^DHCWMR.FP.DataItemI("IndexCode"," "_aElCode,0))
	Quit:ItemID="" return
	
	Set xSubID=0
	For {
		Set xSubID=$o(^DHCWMR.FP.DataItemD(ItemID,"L",xSubID))
		Quit:xSubID=""
		Quit:return'=""
		
		Set objItemLnk=##class(DHCWMR.FP.DataItemLnk).GetObjById(ItemID_"||"_xSubID)
		Continue:'$IsObject(objItemLnk)
		Continue:'$IsObject(objItemLnk.DILItemDr)
		Continue:objItemLnk.DILItemDr.IsActive'=1
		Set ElementCode=objItemLnk.DILItemDr.ElementCode
		Continue:ElementCode=""
		
		If $l(ElementCode)>20 {
			//模板单元代码
			Set:aVType="C" ElementCode=$e(ElementCode,1,$l(ElementCode)-1)_"C"
			Set:aVType="V" ElementCode=$e(ElementCode,1,$l(ElementCode)-1)_"V"
		} Else {
			//术语集
		}
		
		Set return=##class(DHCWMR.IO.FromEprSrv).GetEPRData(aEpisodeID,ElementCode,.ArrGlossary) //获取EPR数据
	}
	
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2014-08-18
/// Description:  查询数据项定义列表
/// Table：       DHCWMR.FP.DataItem
/// Input：       aDesc : 名称
/// Return：      
/// D ##class(%ResultSet).RunQuery("DHCWMR.FPService.DataItemSrv","QryItemList","手术")
Query QryItemList(aDesc As %String) As %Query(ROWSPEC = "ID:%String,DICode:%String,DIDesc:%String,DIResume:%String") [ SqlProc ]
{
}

ClassMethod QryItemListExecute(ByRef qHandle As %Binary, aDesc As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	Set xId = ""
 	For {
	 	Set xId = $o(^DHCWMR.FP.DataItemD(xId))
	 	Quit:xId=""
	 	
	 	Set objItem = ##class(DHCWMR.FP.DataItem).GetObjById(xId)
	 	Continue:'$IsObject(objItem)
	 	
	 	Set RowID  = objItem.%Id()
	 	Set DICode = objItem.DICode
	 	Set DIDesc = objItem.DIDesc
	 	Set Resume = objItem.DIResume
	 	Continue:(aDesc'="")&&(DICode'[aDesc)&&(DIDesc'[aDesc)
	 	
	 	Set Data = $LB(RowID,DICode,DIDesc,Resume)
	 	Set ^CacheTemp(repid,ind)=Data
	 	Set ind=ind +1	
 	}
 	
	Quit $$$OK
}

ClassMethod QryItemListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryItemListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryItemListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryItemListExecute ]
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

/// Creator：     zhouruimeng
/// CreatDate：   2014-08-28
/// Description:  查询数据项关联代码列表
/// Table：       DHCWMR.FP.DataItemLnk
/// Input：       Parref
/// Return：      
/// D ##class(%ResultSet).RunQuery("DHCWMR.FPService.DataItemSrv","QryDataItemLnk","1","0","","")
Query QryDataItemLnk(aItemID As %String, aViewFlag As %String, aElDesc As %String, aElCode As %String) As %Query(ROWSPEC = "MRItemID:%String,MRItemDesc:%String,ElementCode:%String,ElementDesc:%String,ItemLnkID:%String,LnkFlag:%String,FPItemCode:%String,FPItemDesc:%String")
{
}

ClassMethod QryDataItemLnkExecute(ByRef qHandle As %Binary, aItemID As %String, aViewFlag As %String, aElDesc As %String, aElCode As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	Quit:aItemID="" $$$OK
 	
 	Set aViewFlag=+aViewFlag
 	If aViewFlag=1 {
	 	Set xItemCat=""
	 	For {
			Set xItemCat=$o(^DHCWMR.MQ.DataItemsI("IndexDataSrcCatDesc"," EPR",xItemCat))
			Quit:xItemCat=""
			Set xItemDesc=""
			For {
				Set xItemDesc=$o(^DHCWMR.MQ.DataItemsI("IndexDataSrcCatDesc"," EPR",xItemCat,xItemDesc))
				Quit:xItemDesc=""
				Set xID=0
				For {
					Set xID=$o(^DHCWMR.MQ.DataItemsI("IndexDataSrcCatDesc"," EPR",xItemCat,xItemDesc,xID))
					Quit:xID=""
					
					Set objEPRItem=##Class(DHCWMR.MQ.DataItems).GetObjById(xID)
					Continue:'$IsObject(objEPRItem)
					Continue:objEPRItem.IsActive'=1
					
				 	Set MRItemID=objEPRItem.%Id()
				 	Set MRItemDesc=objEPRItem.MRItemDesc
				 	Set ElementCode=objEPRItem.ElementCode
				 	Set ElementDesc=objEPRItem.ElementDesc
				 	Continue:(aElCode'="")&&(ElementCode'[aElCode)
				 	Continue:(aElDesc'="")&&(ElementDesc'[aElDesc)
				 	
				 	Set LnkFlag=0,ItemLnkID=""
				 	If $d(^DHCWMR.FP.DataItemI("DIL","IndexItemDr",MRItemID)){
				 		Set SubID=$o(^DHCWMR.FP.DataItemI("DIL","IndexItemDr",MRItemID,aItemID,0))
				 		If SubID="" {
					 		Set LnkFlag=-1
					 	} Else {
				 			Set LnkFlag=1
				 			Set ItemLnkID=aItemID_"||"_SubID
						}
				 	}
				 	
				 	Set FPItemCode="",FPItemDesc=""
				 	Set FPItemID=$o(^DHCWMR.FP.DataItemI("DIL","IndexItemDr",MRItemID,0))
				 	If FPItemID'="" {
					 	Set objFPItem=##class(DHCWMR.FP.DataItem).GetObjById(FPItemID)
					 	If $IsObject(objFPItem){
						 	Set FPItemCode=objFPItem.DICode
						 	Set FPItemDesc=objFPItem.DIDesc
						}
					}
				 	
				 	Set Data=$LB(MRItemID,MRItemDesc,ElementCode,ElementDesc,ItemLnkID,LnkFlag,FPItemCode,FPItemDesc)
				 	Set ^CacheTemp(repid,ind)=Data
				 	Set ind=ind+1
				}
			}
		}
	} Else {
		Set xSubID=""
	 	For {
		 	Set xSubID=$o(^DHCWMR.FP.DataItemD(aItemID,"L",xSubID))
		 	Quit:xSubID=""
	 		
		 	Set objSub = ##class(DHCWMR.FP.DataItemLnk).GetObjById(aItemID_"||"_xSubID)
		 	Continue:'$IsObject(objSub)
		 	Continue:'$IsObject(objSub.DILItemDr)
		 	Continue:objSub.DILItemDr.IsActive'=1
		 	
			Set FPItemCode=objSub.Parref.DICode
			Set FPItemDesc=objSub.Parref.DIDesc
		 	
		 	Set ItemLnkID=objSub.%Id()
		 	Set LnkFlag=1
		 	Set MRItemID=objSub.DILItemDr.%Id()
		 	Set MRItemDesc=objSub.DILItemDr.MRItemDesc
		 	Set ElementCode=objSub.DILItemDr.ElementCode
		 	Set ElementDesc=objSub.DILItemDr.ElementDesc
		 	Continue:(aElCode'="")&&(ElementCode'[aElCode)
		 	Continue:(aElDesc'="")&&(ElementDesc'[aElDesc)
	 		
		 	Set Data=$LB(MRItemID,MRItemDesc,ElementCode,ElementDesc,ItemLnkID,LnkFlag,FPItemCode,FPItemDesc)
		 	Set ^CacheTemp(repid,ind)=Data
		 	Set ind=ind+1
	 	}
	}
 	
	Quit $$$OK
}

ClassMethod QryDataItemLnkClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryDataItemLnkExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryDataItemLnkFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryDataItemLnkExecute ]
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
