/// 名称: DHCHAI.BTS.InfSubSrv
/// 描述: 感染诊断分类业务处理
/// 编写者：zhoubo
/// 编写日期: 2017-05-04
Class DHCHAI.BTS.InfSubSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhoubo
/// CreatDate：   2017-05-04
/// Description:  查询感染诊断分类信息
/// Table：       DHCHAI.BT.InfSub
/// Input：       
/// do ##class(%Library.ResultSet).RunQuery("DHCHAI.BTS.InfSubSrv","QryInfSub")
Query QryInfSub() As %Query(ROWSPEC = "ID:%String,Code:%String,Desc:%String,IsActive:%String")
{
}

ClassMethod QryInfSubExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Set xCode = ""
	For {
		Set xCode = $o(^DHCHAI.BT.InfSubI("IdxofCode",xCode))
		Quit:xCode=""
		Set xID = ""
		For {
			Set xID = $o(^DHCHAI.BT.InfSubI("IdxofCode",xCode,xID))
			Quit:xID=""
			Set objInfSub = ##class(DHCHAI.BT.InfSub).GetObjById(xID)
			Continue:'$isobject(objInfSub)
			
			Set Code     = objInfSub.BTCode
			Set Desc     = objInfSub.BTDesc
			Set IsActive = objInfSub.BTIsActive
			Set IsActive = $s(IsActive=1:"是",1:"否")	
			
			Set Data = $lb(xID,Code,Desc,IsActive)
			Set ^CacheTemp(repid,ind) = Data
			Set ind = ind+1
		}
	}
	Quit $$$OK
}

ClassMethod QryInfSubClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryInfSubExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryInfSubFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryInfSubExecute ]
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

/// Creator：     zhoubo
/// CreatDate：   2017-05-04
/// Description:  通过感染诊断ID查询感染诊断分类信息
/// Table：       DHCHAI.BT.InfSub
/// Input：       DHCHAI.BT.InfPos.%Id() 
/// do ##class(%Library.ResultSet).RunQuery("DHCHAI.BTS.InfSubSrv","QryInfSubByPosID","3","1")
Query QryInfSubByPosID(aPosID As %String, aCheckAll As %String) As %Query(ROWSPEC = "ID:%String,Code:%String,Desc:%String,IsActive:%String,IsChecked:%String")
{
}

ClassMethod QryInfSubByPosIDExecute(ByRef qHandle As %Binary, aPosID As %String, aCheckAll As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	Set NIndex="QryInfSubByPosID"
	Kill ^TMP($zn,$j,NIndex)
	If (aCheckAll=1){
		Set xCode = ""
		For {
			Set xCode = $o(^DHCHAI.BT.InfSubI("IdxofCode",xCode))
			Quit:xCode=""
			Set xID = ""
			For {
				Set xID = $o(^DHCHAI.BT.InfSubI("IdxofCode",xCode,xID))
				Quit:xID=""
				Set objInfSub = ##class(DHCHAI.BT.InfSub).GetObjById(xID)
				Continue:'$isobject(objInfSub)
				
				Set Code     = objInfSub.BTCode
				Set Desc     = objInfSub.BTDesc
				Set IsActive = objInfSub.BTIsActive
				Set IsActive = $s(IsActive=1:"是",1:"否")
				Set IsChecked=0	
				If (aPosID'=""){
					Set MapID=$o(^DHCHAI.BT.InfPosI("EXT","IdxofInfSubDr",xID,aPosID,0))
					Set:MapID'="" IsChecked=1
				}
				Set Data = $lb(xID,Code,Desc,IsActive,IsChecked)
				
				Set ^TMP($zn,$j,NIndex,Code)=Data
			}
		}
	}Else{
		Quit:aPosID="" $$$OK
		Set xID = ""
		For {
			Set xID = $o(^DHCHAI.BT.InfPosI("EXT","IdxofParRef",aPosID,xID))
			Quit:xID=""
			
			Set objInfPosExt = ##class(DHCHAI.BT.InfPosExt).GetObjById(aPosID_"||"_xID)
			Continue:'$IsObject(objInfPosExt)
			Continue:'$IsObject(objInfPosExt.BTInfSubDr)
			Set Code     = objInfPosExt.BTInfSubDr.BTCode
			Set Desc     = objInfPosExt.BTInfSubDr.BTDesc
			Set IsActive = objInfPosExt.BTInfSubDr.BTIsActive
			Set IsActive = $s(IsActive=1:"是",1:"否")	
			Set IsChecked=1
			
			Set Data = $lb(objInfPosExt.BTInfSubDr.%Id(),Code,Desc,IsActive,IsChecked)
			Set ^TMP($zn,$j,NIndex,Code)=Data
		}
	}
	Set xCode = ""
	For {
		Set xCode = $o(^TMP($zn,$j,NIndex,xCode))
		Quit:xCode=""
		Set Data = $g(^TMP($zn,$j,NIndex,xCode))
		Continue:Data=""
		Set ^CacheTemp(repid,ind) = Data
		Set ind = ind+1
	}
	Quit $$$OK
}

ClassMethod QryInfSubByPosIDClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryInfSubByPosIDExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryInfSubByPosIDFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryInfSubByPosIDExecute ]
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

/// Creator：     pylian
/// CreatDate：   2018-01-11
/// Description:  通过感染诊断代码查询感染诊断分类信息
/// Table：       DHCHAI.BT.InfPos、DHCHAI.BT.InfPosExt
/// Input：       DHCHAI.BT.InfPos.BTDesc
/// do ##class(%Library.ResultSet).RunQuery("DHCHAI.BTS.InfSubSrv","QryInfPosExt","新生儿感染","1")
Query QryInfPosExt(aInfPos As %String, aIsActive As %String) As %Query(ROWSPEC = "ID:%String,InfSubID:%String,InfSubCode:%String,InfSub:%String,IsActive:%String")
{
}

ClassMethod QryInfPosExtExecute(ByRef qHandle As %Binary, aInfPos As %String, aIsActive As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:aInfPos="" $$$OK
	Set xID = ""
	For {
		Set xID = $o(^DHCHAI.BT.InfPosI("IdxofDesc",aInfPos,xID))
		Quit:xID=""
		Set xSubID=""
		For {
			Set xSubID = $o(^DHCHAI.BT.InfPosI("EXT","IdxofParRef",xID,xSubID))
			Quit:xSubID=""
			
			Set objInfPosExt = ##class(DHCHAI.BT.InfPosExt).GetObjById(xID_"||"_xSubID)
			Continue:'$IsObject(objInfPosExt)
			Continue:'$IsObject(objInfPosExt.BTInfSubDr)
			Set InfSubID  =objInfPosExt.BTInfSubDr.%Id()
			Set Code     = objInfPosExt.BTInfSubDr.BTCode
			Set Desc     = objInfPosExt.BTInfSubDr.BTDesc
			Set IsActive = objInfPosExt.BTInfSubDr.BTIsActive
			Continue:(aIsActive'="")&&(aIsActive'=IsActive)
			Set IsActive = $s(IsActive=1:"是",1:"否")	
			
			Set Data = $lb(xID_"||"_xSubID,InfSubID,Code,Desc,IsActive)
			Set ^CacheTemp(repid,ind) = Data
			Set ind = ind+1
		}
	}
	
	Quit $$$OK
}

ClassMethod QryInfPosExtClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryInfPosExtExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryInfPosExtFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryInfPosExtExecute ]
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
