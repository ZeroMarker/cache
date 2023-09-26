/// 名称: DHCWMR.SSService.GroupReceiptSrv
/// 描述: 病案分类相关服务
/// 编写者：liyi
/// 编写日期: 2014-08-29
Class DHCWMR.SSService.MrTypeSrv Extends DHCWMR.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhufei
/// CreatDate：   2014-09-30
/// Description:  查询病案类型
/// Table：       DHCWMR.SS.MrType
/// Input：    	  MrClass : 病案分类
///               HospIDs ：医院ID（CT_Hospital.ID） 多值逗号分隔
/// Return：      返回Query
/// D ##class(%ResultSet).RunQuery("DHCWMR.SSService.MrTypeSrv","QueryMrType","I","2")
Query QueryMrType(aMrClass As %String, aHospIDs As %String) As %Query(ROWSPEC = "MrTypeID:%String,MrTypeDesc:%String,NoFiled:%String,GetWayTp:%String")
{
}

ClassMethod QueryMrTypeExecute(ByRef qHandle As %Binary, aMrClass As %String, aHospIDs As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	//Set ^ZF=$lb(aMrClass,aHospIDs)
 	
 	Set xID=""
 	For {
	 	Set xID=$o(^DHCWMR.SS.MrTypeD(xID))
	 	Quit:xID=""
	 	
	 	Set obj=##class(DHCWMR.SS.MrType).GetObjById(xID)
	 	Continue:'$IsObject(obj)
	 	
	 	Set MrTypeID=xID
	 	Set MrTypeDesc=obj.MTDesc
	 	Continue:'$IsObject(obj.MTMrClass)
	 	Continue:(aMrClass'="")&&(obj.MTMrClass.MCCode'=aMrClass)
	 	Set HospIDs=obj.MTHospIDs
	 	Set HospIDs="#"_HospIDs_"#"
	 	
	 	Set IsHospAct=0
	 	For indHosp=1:1:$l(aHospIDs,",") {
		 	Set xHospID=$p(aHospIDs,",",indHosp)
		 	Continue:xHospID=""
		 	Set xHospID="#"_xHospID_"#"
		 	Continue:HospIDs'[xHospID
		 	Set IsHospAct=1
		}
		Continue:IsHospAct=0
	 	
		Set NoFiled=""
		If $IsObject(obj.MTNoFiled){
			Set NoFiled=obj.MTNoFiled.SDCode
		}
		Set GetWayTp=""
		If $IsObject(obj.MTGetWay){
			Set GetWayTp=obj.MTGetWay.SDCode
		}
	 	
		Set Data=$lb(MrTypeID,MrTypeDesc,NoFiled,GetWayTp)
	 	Set ^CacheTemp(repid,ind)=Data
	 	Set ind=ind+1
	}
	
 	Quit $$$OK
}

ClassMethod QueryMrTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryMrTypeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QueryMrTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryMrTypeExecute ]
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

/// 导入病案类型数据
/// w ##Class(DHCWMR.SSService.MrTypeSrv).ImportMrType("")
ClassMethod ImportMrType(aInputStr As %String) As %String
{
	New (aInputStr)
	Set return=0
	Quit:(aInputStr="") return
	
	Set strID = +$p(aInputStr,"^",1)
	Set strMrTypeDesc = $p(aInputStr,"^",2)
	Set strMrClassCode = $p(aInputStr,"^",3)
	Set strMrClassDesc = $p(aInputStr,"^",4)
	Set strResume = $p(aInputStr,"^",5)
	
	Set objMrClass=##class(DHCWMR.SS.MrClass).GetObjByCode(strMrClassCode)
	Quit:'$IsObject(objMrClass) ""
	Set MrClassID=objMrClass.%Id()
	Set MTHospIDs=""
	Set MTReceiptType=""
	Set MTGetWay=""
	Set MTRecycleType=""
	Set MTNoFiled=""
	Set objMrType=##class(DHCWMR.SS.MrType).GetObjById(strID)
	If '$IsObject(objMrType) {
		Set ^DHCWMR.SS.MrTypeD=strID-1
		Set InputStr=""
		Set InputStr=InputStr_"^"_MrClassID
		Set InputStr=InputStr_"^"_strMrTypeDesc
		Set InputStr=InputStr_"^"_MTHospIDs
		Set InputStr=InputStr_"^"_MTReceiptType
		Set InputStr=InputStr_"^"_MTGetWay
		Set InputStr=InputStr_"^"_MTRecycleType
		Set InputStr=InputStr_"^"_MTNoFiled
		Set InputStr=InputStr_"^"_""
		Set InputStr=InputStr_"^"_"0"
		Set InputStr=InputStr_"^"_""
		Set InputStr=InputStr_"^"_strResume
		Set flg=##class(DHCWMR.SS.MrType).Update(InputStr,"^")
	}
	
	Quit return
}

}
