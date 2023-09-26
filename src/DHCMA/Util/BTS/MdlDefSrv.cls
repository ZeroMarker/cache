/// 名称: DHCMA.Util.BTS.MdlDefSrv
/// 描述: 系统模块定义
/// 编写者：liuzhenhe
/// 编写日期: 2018-11-27
/// 编写目的:查询DHCMA.Util.BT.MdlDef(产品模块定义表)
Class DHCMA.Util.BTS.MdlDefSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     liuzhenhe
/// CreatDate：   2018-011-27
/// Description:  更新时判断Code是否重复
/// Table：       DHCMA.Util.BT.MdlDef
/// Input：       aCode：    代码
/// Return：      重复：ID，不重复：0
/// w ##class(DHCMA.Util.BTS.MdlDefSrv).CheckPTCode("",)
ClassMethod CheckPTCode(aCode As %String, aID As %String = "") As %String
{
	New (aCode,aID)
	Set return=""
	Quit:(aCode="") return
	
	If ($d(^DHCMA.Util.BT.MdlDefI("IdxofCode"," "_$zcvt(aCode,"U"))))
	{
		Set ID=$o(^DHCMA.Util.BT.MdlDefI("IdxofCode"," "_$zcvt(aCode,"U"),0))
		Set return=ID
		Set:(aID'="")&&(aID=ID) return=0
	}else{
		set return=0
	}
	
	Quit return
}

/// Creator：     liuzhenhe
/// CreatDate：   2018-11-27
/// Description:  查询系统字典类型
/// Table：       DHCMA.Util.BT.MdlDef
/// Input：       aProCode
/// Output:		  BTID,BTCode,BTDesc,BTTypeID,BTTypeDesc
/// D ##class(%ResultSet).RunQuery("DHCMA.Util.BTS.MdlDefSrv","QryMdlDef","CPW")
Query QryMdlDef(aProCode As %String = "") As %Query(ROWSPEC = "BTID:%String,BTCode:%String,BTDesc:%String,BTTypeID:%String,BTTypeDesc:%String")
{
}

ClassMethod QryMdlDefExecute(ByRef qHandle As %Binary, aProCode As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	Set xID=""
 	if (aProCode'=""){
 		For{
	 		Set xID=$o(^DHCMA.Util.BT.MdlDefD(xID))
	 		Quit:xID=""
	 		
	 		Set obj=##class(DHCMA.Util.BT.MdlDef).GetObjById(xID)
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
 	} else {
	 	For {
	 		Set xID=$o(^DHCMA.Util.BT.MdlDefD(xID))
	 		Quit:xID=""
	 	
	 		Set obj=##class(DHCMA.Util.BT.MdlDef).GetObjById(xID)
	 		Continue:'$IsObject(obj)
	 		Set Code     = obj.BTCode
	 		Set Desc     = obj.BTDesc
	 		Set ProductID="",ProductCode="",BTProductDesc =""
	 		If $IsObject(obj.BTProductDr){
	    		Set ProductID   = obj.BTProductDr.%Id()
		 		Set ProductCode = obj.BTProductDr.ProCode
	    		Set ProductDesc = obj.BTProductDr.ProDesc
	 		}
			Set Data=$lb(xID,Code,Desc,ProductID,ProductDesc)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
 	}
	 	
	 	
 	}	
	Quit $$$OK
}

ClassMethod QryMdlDefClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryMdlDefExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryMdlDefFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryMdlDefExecute ]
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
