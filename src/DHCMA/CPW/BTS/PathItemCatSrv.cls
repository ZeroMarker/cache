/// 名称: DHCMA.CPW.BTS.PathItemCatSrv
/// 描述: 项目分类 服务类
/// 编写者：liuzhenhe
/// 编写日期: 2018-08-28
Class DHCMA.CPW.BTS.PathItemCatSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     liuzhenhe
/// CreatDate：   2018-08-27
/// Description:  查询临床路径项目分类字典
/// Table：       DHCMA.CPW.BT.PathItemCat
/// Input：   
/// output:    BTCode As %String BTDesc As %String BTTypeDr As DHCMA.Util.BT.Dictionary
/// D ##class(%ResultSet).RunQuery("DHCMA.CPW.BTS.PathItemCatSrv","QryPathItemCat")
Query QryPathItemCat(aHospID As %String = "") As %Query(ROWSPEC = "BTID:%String,BTCode:%String,BTDesc:%String,BTTypeID:%String,BTTypeDesc:%String,BTPowerID:%String,BTPowerCode:%String,BTPowerDesc:%String")
{
}

ClassMethod QryPathItemCatExecute(ByRef qHandle As %Binary, aHospID As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	Set IsOpen=##class(DHCMA.Util.BT.Config).GetValueByCode("SYSIsOpenMultiHospMode",aHospID)
 	Set xID=""
 	For {
	 	Set xID=$o(^DHCMA.CPW.BT.PathItemCatD(xID))
	 	Quit:xID=""
	 	
	 	Set obj=##class(DHCMA.CPW.BT.PathItemCat).GetObjById(xID)
	 	Continue:'$IsObject(obj)
	 	If (IsOpen="Y")&&(aHospID'=""){
		 	Set retFlg=##class(DHCMA.Util.IO.MultiHospInterface).IsShowOneDataByHosp("DHCMA_CPW_BT.PathItemCat",xID,aHospID)
		 	Continue:retFlg'="Y"
		}
	 	
	 	Set Code         = obj.BTCode
	 	Set Desc         = obj.BTDesc
	 	Set TypeID="",TypeDesc=""
	 	If $IsObject(obj.BTTypeDr) {
			Set TypeID  =obj.BTTypeDr.%Id()
	 		Set TypeDesc=obj.BTTypeDr.BTDesc
		}
		
		Set PowerCode="",PowerDesc="",PowerID=""
		If $IsObject(obj.BTPowerDr){
			Set PowerID = obj.BTPowerDr.%Id()
			Set PowerCode = obj.BTPowerDr.BTCode
			Set PowerDesc = obj.BTPowerDr.BTDesc	
		}
		
		Set Data=$lb(xID,Code,Desc,TypeID,TypeDesc,PowerID,PowerCode,PowerDesc)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
 	}
	Quit $$$OK
}

ClassMethod QryPathItemCatClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryPathItemCatExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryPathItemCatFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryPathItemCatExecute ]
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

/// Creator：     chenjb
/// CreatDate：   2018-08-27
/// Description:  查询临床路径项目分类字典
/// Table：       DHCMA.CPW.BT.PathItemCat
/// Input：   
/// output:    BTCode As %String BTDesc As %String BTTypeDr As DHCMA.Util.BT.Dictionary
/// D ##class(%ResultSet).RunQuery("DHCMA.CPW.BTS.PathItemCatSrv","QryPathItemCatByD")
Query QryPathItemCatByD(aDicCode As %String, aHospID As %String = "") As %Query(ROWSPEC = "BTID:%String,BTCode:%String,BTDesc:%String,BTTypeID:%String,BTTypeDesc:%String")
{
}

ClassMethod QryPathItemCatByDExecute(ByRef qHandle As %Binary, aDicCode As %String, aHospID As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	Set IsOpen=##class(DHCMA.Util.BT.Config).GetValueByCode("SYSIsOpenMultiHospMode",aHospID)
 	Set objDicType = ##class(DHCMA.Util.BT.DicType).GetObjByCode("CPWFormItemType")
 	Set xID=""
 	For {
	 	Set xID=$o(^DHCMA.CPW.BT.PathItemCatD(xID))
	 	Quit:xID=""
	 	
	 	Set obj=##class(DHCMA.CPW.BT.PathItemCat).GetObjById(xID)
	 	Continue:'$IsObject(obj)
	 	If (IsOpen="Y")&&(aHospID'=""){
		 	Set retFlg=##class(DHCMA.Util.IO.MultiHospInterface).IsShowOneDataByHosp("DHCMA_CPW_BT.PathItemCat",xID,aHospID)
		 	Continue:retFlg'="Y"
		}
	 	
	 	Set Code         = obj.BTCode
	 	Set Desc         = obj.BTDesc
	 	Set TypeID="",TypeDesc=""
	 	If $IsObject(obj.BTTypeDr) {
			Set TypeID  =obj.BTTypeDr.%Id()
			Set TypeGrpDr =obj.BTTypeDr.BTTypeDr.%Id()
			Set TypeCode =obj.BTTypeDr.BTCode
	 		Set TypeDesc=obj.BTTypeDr.BTDesc
	 		Continue:(TypeGrpDr'=objDicType.%Id())
	 		Continue:(aDicCode'="")&(TypeCode'=aDicCode)
		}
		
		Set Data=$lb(xID,Code,Desc,TypeID,TypeDesc)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
 	}
	Quit $$$OK
}

ClassMethod QryPathItemCatByDClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryPathItemCatByDExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryPathItemCatByDFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryPathItemCatByDExecute ]
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
