/// 名称: web.DHCCPW.MRC.PathWEpStepItemLnk
/// 描述: 表单项目关联诊疗护理项目字典
/// 编写者：zhufei
/// 编写日期: 2012-02-08
Class web.DHCCPW.MRC.PathWEpStepItemLnk Extends DHCMed.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhufei
/// CreatDate：   2012-02-08
/// Description:  查询关联项目大类信息
/// Table：       User.DHCMRCBaseLinkItemCat
/// Input：       
/// d ##class(%ResultSet).RunQuery("web.DHCCPW.MRC.PathWEpStepItemLnk","QryCNLinkByStepItem","70||1||1||1")
Query QryCNLinkByStepItem(argItemID As %String) As %Query(ROWSPEC = "ItemID:%String,ItemNo:%String,ItemCategID:%String,ItemCateg:%String,ItemDicID:%String,ItemDic:%String,GroupNo:%String,IsActive:%String,UpdateUser:%String,UpdateDate:%String,UpdateTime:%String")
{
}

ClassMethod QryCNLinkByStepItemExecute(ByRef qHandle As %Binary, argItemID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Set objItem=##class(web.DHCCPW.MRC.PathWEpStepItem).GetObjById(argItemID)
	If $IsObject(objItem){
		Set countLnkItem=objItem.CPWSIBLItmList.Count()
		For indLnkItem=1:1:countLnkItem {
			Set objLnkItem=objItem.CPWSIBLItmList.GetAt(indLnkItem)
			Continue:'$IsObject(objLnkItem)
			Set ItemID=indLnkItem
			Set ItemNo=objLnkItem.ITMNo
			Continue:ItemNo=""
			Set ItemCategID=""
			Set ItemCateg=""
			Set ItemDicID=""
			Set ItemDic=""
			If $IsObject(objLnkItem.ITMBLItmDR)
			{
				Set ItemDicID=objLnkItem.ITMBLItmDR.%Id()
				Set ItemDic=objLnkItem.ITMBLItmDR.BLIDDesc
				If $IsObject(objLnkItem.ITMBLItmDR.BLIDSubCatDr)
				{
					If $IsObject(objLnkItem.ITMBLItmDR.BLIDSubCatDr.BLISCCatDr)
					{
						Set ItemCategID=objLnkItem.ITMBLItmDR.BLIDSubCatDr.BLISCCatDr.%Id()
						Set ItemCateg=objLnkItem.ITMBLItmDR.BLIDSubCatDr.BLISCCatDr.BLICDesc
					}
				}
			}
			Set GroupNo=objLnkItem.ITMGroupNo
			Set IsActive=objLnkItem.ITMIsActive
			Set IsActive=$s(IsActive["Y":"Yes",1:"No")
			Set UpdateUser=objLnkItem.ITMUpdateUser
			Set UpdateDate=objLnkItem.ITMUpdateDate
			Set UpdateTime=objLnkItem.ITMUpdateTime
			
			Set Data=$lb(ItemID,ItemNo,ItemCategID,ItemCateg,ItemDicID,ItemDic,GroupNo,IsActive,UpdateUser,UpdateDate,UpdateTime)
		 	Set ^CacheTemp(repid,ind)=Data
		 	Set ind=ind+1
		}
	}
	
	Quit $$$OK
}

ClassMethod QryCNLinkByStepItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryCNLinkByStepItemExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryCNLinkByStepItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryCNLinkByStepItemExecute ]
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

/// w ##class(web.DHCCPW.MRC.PathWEpStepItemLnk).InsertLinkCN("70||1||1||1","1^1^^Yes^9^^")
ClassMethod InsertLinkCN(aItemID As %String, aLinkCNStr As %String)
{
	New (aItemID,aLinkCNStr)
	Set return=0
	Quit:(aItemID="")||(aLinkCNStr="") return
	
	Set obj=##class(User.DHCMRCClinPathWaysEpStepItem).%OpenId(aItemID)
	Quit:'$IsObject(obj) return
	
	Set LinkItemNo=$p(aLinkCNStr,"^",1)
	Quit:(+LinkItemNo)<1 return
	Set ItmInd=""
	Set LinkItemListCount=obj.CPWSIBLItmList.Count()
	For Ind=1:1:LinkItemListCount {
		Quit:ItmInd'=""
		Set objLinkCNTMP=obj.CPWSIBLItmList.GetAt(Ind)
		Continue:'$IsObject(objLinkCNTMP)
		Set tmpItmNo=objLinkCNTMP.ITMNo
		If LinkItemNo=tmpItmNo {
			Set ItmInd=Ind
		}
	}
	Set:ItmInd="" ItmInd=LinkItemNo
	If ItmInd>LinkItemListCount {
		For tmpItmInd=1:1:(ItmInd-LinkItemListCount) {
			Do obj.CPWSIBLItmList.Insert("")
		}
	}
	
	Set LinkItemID=$p(aLinkCNStr,"^",2)
	Set objLinkItem=##class(User.DHCMRCBaseLinkItemDic).GetObjById(LinkItemID)
	Quit:'$IsObject(objLinkItem)
	
	Set objLinkCN=##class(User.DHCMRCClinPathWaysBLITM).%New()
	Quit:'$IsObject(objLinkCN)
	Set objLinkCN.ITMNo=LinkItemNo                    //序号
	Set objLinkCN.ITMBLItmDR=objLinkItem              //基础关联项
	Set objLinkCN.ITMGroupNo=$p(aLinkCNStr,"^",3)     //分组编号
	Set objLinkCN.ITMIsActive=$s($p(aLinkCNStr,"^",4)["Y":"Y",1:"N")    //是否有效
	Set objLinkCN.ITMUpdateUser=$p(aLinkCNStr,"^",5)  //修改人
	Set UpdateDate=$p(aLinkCNStr,"^",6)
	Set:UpdateDate["-" UpdateDate=$zdh(UpdateDate,3)
	Set:UpdateDate["/" UpdateDate=$zdh(UpdateDate,4)
	Set:UpdateDate="" UpdateDate=+$h
	Set objLinkCN.ITMUpdateDate=UpdateDate            //修改日期
	Set UpdateTime=$p(aLinkCNStr,"^",7)
	Set:UpdateTime[":" UpdateTime=$zth(UpdateTime,1)
	Set objLinkCN.ITMUpdateTime=UpdateTime            //修改时间
	
	//Set objLinkCNTMP=obj.CPWSIBLItmList.GetAt(ItmInd)
	//If $IsObject(objLinkCNTMP) {
		Do obj.CPWSIBLItmList.SetAt(objLinkCN,ItmInd)
	//}
	
	Set sc=obj.%Save()
	If $System.Status.IsError(sc) {                      //检查Save是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	} Else {
		Set return=ItmInd
	}
	Do obj.%Close()
	
	Quit return
}

/// w ##class(web.DHCCPW.MRC.PathWEpStepItemLnk).DeleteLinkCN("70||1||1||1","5")
ClassMethod DeleteLinkCN(ItemRowID As %String, ItmNo As %String)
{
	New (ItemRowID,ItmNo)
	Set return=0
	Quit:(ItemRowID="")||(ItmNo="") return
	
	Set obj=##class(User.DHCMRCClinPathWaysEpStepItem).%OpenId(ItemRowID)
	Quit:'$IsObject(obj) return
	
	For Ind=1:1:obj.CPWSIBLItmList.Count() {
		Set objLinkCNTMP=obj.CPWSIBLItmList.GetAt(Ind)
		Continue:'$IsObject(objLinkCNTMP)
		Set tmpItmNo=objLinkCNTMP.ITMNo
		Continue:tmpItmNo'=ItmNo
		//Do obj.CPWSIBLItmList.RemoveAt(Ind)
		Do obj.CPWSIBLItmList.SetAt("",Ind)
	}
	
	Set sc=obj.%Save()
	If $System.Status.IsError(sc) {                      //检查Save是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	} Else {
		Set return=ItmNo
	}
	Do obj.%Close()
	
	Quit return
}

}
