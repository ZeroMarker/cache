/// 名称: DHCMA.Util.BT.DeleteControl
/// 描述: 基础字典删除权限控制表服务
/// 编写者：pylian
/// 编写日期: 2020-08-12
Class DHCMA.Util.BTS.DeleteControlSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     pylian
/// CreatDate：   2020-08-12
/// Description:  查询基础字典删除权限控制表
/// Table：       DHCMA.Util.BT.DeleteControl
/// Input：       
/// do ##class(%Library.ResultSet).RunQuery("DHCMA.Util.BTS.DeleteControlSrv","QryDeleteControl")
Query QryDeleteControl(aKeyWords As %String = "") As %Query(ROWSPEC = "ID:%String,ProCode:%String,ProDesc:%String,TableCode:%String,TableDesc:%String,AllowDel:%String,AllowDelDesc:%String") [ SqlProc ]
{
}

ClassMethod QryDeleteControlExecute(ByRef qHandle As %Binary, aKeyWords As %String = "") As %Status
{

	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)

	Set xID = ""
	For {
		Set xID = $o(^CT.MA.Util.BT.DeleteControlD(xID))
		Quit:xID=""
	  
		Set objDel = ##class(DHCMA.Util.BT.DeleteControl).GetObjById(xID)
		Continue:'$Isobject(objDel)
			
		Set ProCode    = objDel.ProCode  
		Set objPro=##class(DHCMA.Util.BT.Product).GetObjByCode(ProCode)
		Continue:'$IsObject(objPro)
		Set ProDesc    = objPro.ProDesc 
		Set TableCode  = objDel.TableCode  
		Set TableDesc  = objDel.TableDesc
		Continue:(aKeyWords'="")&&(ProDesc'[aKeyWords)&&(TableDesc'[aKeyWords) 
		Set AllowDel   = objDel.TableAllowDel 
	    Set AllowDelDesc = $s(AllowDel=1:"是",1:"否")	
		Set Data = $lb(xID,ProCode,ProDesc,TableCode,TableDesc,AllowDel,AllowDelDesc)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	Quit $$$OK
}

ClassMethod QryDeleteControlClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryDeleteControlExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryDeleteControlFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryDeleteControlExecute ]
{
	set AtEnd=$LIST(qHandle,1)
 	set repid=$LIST(qHandle,2)
 	set ind=$LIST(qHandle,3)
 	set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		set AtEnd=1
 		set Row=""
 	}
 	Else      {				// fetch row
 		set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

}
