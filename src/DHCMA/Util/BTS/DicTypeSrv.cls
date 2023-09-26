/// 名称: DHCMA.Util.BTS.DicTypeSrv
/// 描述: 系统字典类型 服务类
/// 编写者：刘贞贺   
/// 编写日期: 2018-08-30
Class DHCMA.Util.BTS.DicTypeSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     liuzhenhe
/// CreatDate：   2018-09-21
/// Description:  更新时判断Code是否重复
/// Table：       DHCMA.Util.BT.DicType
/// Input：       aCode：    代码
/// Return：      重复：ID，不重复：0
/// w ##class(DHCMA.Util.BTS.DicTypeSrv).CheckPTCode("11",)
ClassMethod CheckPTCode(aCode As %String, aID As %String = "") As %String
{
	New (aCode,aID)
	Set return=""
	Quit:(aCode="") return
	
	If ($d(^DHCMA.Util.BT.DicTypeI("IdxofCode"," "_$zcvt(aCode,"U"))))
	{
		Set ID=$o(^DHCMA.Util.BT.DicTypeI("IdxofCode"," "_$zcvt(aCode,"U"),0))
		Set return=ID
		Set:(aID'="")&&(aID=ID) return=0
	}else{
		set return=0
	}
	
	Quit return
}

/// Creator：     liuzhenhe
/// CreatDate：   2018-09-4
/// Description:  查询系统字典类型
/// Table：       DHCMA.Util.BT.DicType
/// Input：       
/// D ##class(%ResultSet).RunQuery("DHCMA.Util.BTS.DicTypeSrv","QryDicType","CPW")
Query QryDicType(aProCode As %String) As %Query(ROWSPEC = "BTID:%String,BTCode:%String,BTDesc:%String,BTTypeID:%String,BTTypeDesc:%String")
{
}

ClassMethod QryDicTypeExecute(ByRef qHandle As %Binary, aProCode As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	Set xID=""
 	For{
	 	Set xID=$o(^DHCMA.Util.BT.DicTypeD(xID))
	 	Quit:xID=""
	 	
	 	Set obj=##class(DHCMA.Util.BT.DicType).GetObjById(xID)
	 	Continue:'$IsObject(obj)
	 	Set Code     = obj.BTCode
	 	Set Desc     = obj.BTDesc
	 	Set ProductID="",ProductCode="",BTProductDesc =""
	 	If $IsObject(obj.BTProductDr){
	    	Set ProductID   = obj.BTProductDr.%Id()
		 	Set ProductCode = obj.BTProductDr.ProCode
	    	Set ProductDesc = obj.BTProductDr.ProDesc
	 	}
	 	Continue:(aProCode'="")&&(aProCode'=ProductCode)
	    
		Set Data=$lb(xID,Code,Desc,ProductID,ProductDesc)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
 	}	
	Quit $$$OK
}

ClassMethod QryDicTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryDicTypeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryDicTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryDicTypeExecute ]
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

/// Creator：     fcz
/// CreatDate：   2019-11-01
/// Description:  导入字典类型
/// Table：       DHCMA.Util.BT.DicType
/// Input： 
/// 
ClassMethod ImportDicType(aInputStr As %String, aSeparate As %String) As %String
{
	New (aInputStr,aSeparate)
	Set return=-1
	Quit:(aInputStr="")||(aSeparate="") return	
	
	Set Code     = $p(aInputStr,aSeparate,2)
	Set Desc     = $p(aInputStr,aSeparate,3)
	Set ProductCode= $p(aInputStr,aSeparate,4)
	
	Set objProduct=##class(DHCMA.Util.BT.Product).GetObjByCode(ProductCode)
	Quit:'$IsObject(objProduct) return
	
	Set ProductID=objProduct.%Id()
	
	Set ID=$o(^DHCMA.Util.BT.DicTypeI("IdxofCode"," "_$zcvt(Code,"U"),0))
	
	Set InputStr=ID
	Set InputStr=InputStr_"^"_Code
	Set InputStr=InputStr_"^"_Desc
	Set InputStr=InputStr_"^"_ProductID
	set return=##class(DHCMA.Util.BT.DicType).Update(InputStr,aSeparate)
	Quit return
}

}
