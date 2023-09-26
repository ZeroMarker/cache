/// 名称: CT.IPMR.FPS.DataItemSrv
/// 描述: 编目数据项相关服务方法
/// 创建者：liyi
/// 创建日期: 2019-09-17
Class CT.IPMR.FPS.DataItemSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     liyi
/// CreatDate：   2019-10-08
/// Description:  查询编目数据项
/// Table：       CT.IPMR.FP.DataItem
/// Input：       aFPTypeID：首页类型
///               aAlias：关键字
/// 		      aMapped：已对照1,未对照0,全部’空‘
/// output:       符合条件的编目数据项
/// D ##class(%ResultSet).RunQuery("CT.IPMR.FPS.DataItemSrv","QueryDataItem","","")
Query QueryDataItem(aFPTypeID As %String, aAlias As %String, aMapped As %String = "") As %Query(ROWSPEC = "ID:%String,FPTypeID:%String,FPTypeDesc:%String,Code:%String,Desc:%String,CatCode:%String,CatDesc:%String,CatID:%String,Resume:%String")
{
}

ClassMethod QueryDataItemExecute(ByRef qHandle As %Binary, aFPTypeID As %String, aAlias As %String, aMapped As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 
	Set xCode = ""
 	For {
		Set xCode = $o(^CT.IPMR.FP.DataItemI("IndexCode",xCode))
		Quit:xCode=""
		
		Set xID = ""
		For {
			Set xID = $o(^CT.IPMR.FP.DataItemI("IndexCode",xCode,xID))
			Quit:xID=""
			Set objDataItem = ##class(CT.IPMR.FP.DataItem).GetObjById(xID)
			Continue:'$ISObject(objDataItem)
			Set objListFPType = objDataItem.FDFPType
			if aFPTypeID'="" {
				Set objDic = ##class(CT.IPMR.BT.Dictionary).GetObjById(aFPTypeID)
				Continue:'$isobject(objDic)
				Continue:'(objListFPType.FindObjectId(aFPTypeID)>0)
			}
			Set Code = objDataItem.FDCode
			Set Desc = objDataItem.FDDesc
			Set objDateItemCat = objDataItem.FDCatDr
			Set (CatCode,CatID,CatDesc)=""
			if $isobject(objDateItemCat) {
				Set CatCode = objDateItemCat.FDCode
				Set CatDesc = objDateItemCat.FDDesc
				Set CatID = objDateItemCat.%Id()
			}
			Set Resume = objDataItem.FDResume
			IF aAlias'="" {
				Continue:'((Code[aAlias)||(Desc[aAlias))
			}
			Set (FPTypeID,FPTypeDesc)=""
			For xInd=1:1:objListFPType.Count() {
				Set objDic = objListFPType.GetAt(xInd)
				if $isobject(objDic) {
					if FPTypeID="" {
						Set FPTypeID   = objDic.%Id()
						Set FPTypeDesc = objDic.BDDesc
					}else{
						Set FPTypeID   = FPTypeID_","_objDic.%Id()
						Set FPTypeDesc = FPTypeDesc_","_objDic.BDDesc
					}
				}
			}
			Set MapBGCode="",MapBGDesc="",Mapped=0
			Set objDataItemMap=##class(CT.IPMR.FP.DataItemMap).GetObjByDataItem(xID,FPTypeID)
			If $IsObject(objDataItemMap){
				If $IsObject(objDataItemMap.FDGlossaryDr){
					Set Mapped		= 1	;已对照
				}
			}
			if aMapped'=""{
				Continue:aMapped'=Mapped
			}
			Set Data=$lb(xID,FPTypeID,FPTypeDesc,Code,Desc,CatCode,CatDesc,CatID,Resume)
   	 		Set ^CacheTemp(repid,ind)=Data
    		Set ind=ind+1
		} 
	}
	Quit $$$OK
}

ClassMethod QueryDataItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryDataItemExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QueryDataItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryDataItemExecute ]
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

/// Creator：     liyi
/// CreatDate：   2019-10-08
/// Description:  导入编目数据项
/// Table：       CT.IPMR.FP.DataItem
/// Input：       编目数据项
/// w ##class("CT.IPMR.FPS.DataItemSrv").ImportDataItem("^西医首页^P01.001.01^医疗付费方式^P01.001^")
ClassMethod ImportDataItem(aInput As %String) As %String
{
	New (aInput)
	Set return = 0
	Quit:aInput="" return
	Set FPTypeDescs = $p(aInput,"^",2)
	Set FPTypeIDs=""
	For ind=1:1:$length(FPTypeDescs,"/") {
		Set TypeDesc = $p(FPTypeDescs,"/",ind)
		Continue:TypeDesc=""
		Set objDic = ##class(CT.IPMR.BT.Dictionary).GetByTypeDesc("FrontPageType",TypeDesc)
		Continue:'$IsObject(objDic)
		If FPTypeIDs="" {
			Set FPTypeIDs = objDic.%Id()
		}else{
			Set FPTypeIDs = FPTypeIDs_","_objDic.%Id()
		}
	}
	Set DatItemCat = $p(aInput,"^",5)
	Set objItemCat = ##class(CT.IPMR.FP.DataItemCat).GetObjByCode(DatItemCat)
	Set DataItemCatID=""
	Set:$isobject(objItemCat) DataItemCatID=objItemCat.%Id()
	Set $p(aInput,"^",2)=FPTypeIDs
	Set $p(aInput,"^",5)=DataItemCatID
	Set return = ##class(CT.IPMR.FP.DataItem).Update(aInput,"^")
	Quit return
}

}
