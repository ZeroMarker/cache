/// 名称: DHCHAI.DPS.LabBactAntiIntSrv
/// 描述: 细菌天然耐药相关服务
/// 编写者：pylian
/// 编写日期: 2021-03-22
Class DHCHAI.DPS.LabBactAntiIntSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     pylian
/// CreatDate：   2021-03-22
/// Description:  查询细菌天然耐药
/// Table：       DHCHAI.DP.LabBactAntiInt
/// Input：       
/// do ##class(%Library.ResultSet).RunQuery("DHCHAI.DPS.LabBactAntiIntSrv","QryLabBactAntiInt")
Query QryLabBactAntiInt(aIsActive As %String = "") As %Query(ROWSPEC = "ID:%String,BactDesc:%String,BactDr:%String,AntDesc:%String,AntDr:%String,IsActive:%String,IsActDesc:%String,Note:%String,ActDate:%String,ActTime:%String") [ SqlProc ]
{
}

ClassMethod QryLabBactAntiIntExecute(ByRef qHandle As %Binary, aIsActive As %String = "") As %Status
{

	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)

	Set xID = ""
	For {
		Set xID = $o(^CT.MA.HAI.DP.LabBactAntiIntD(xID))
		Quit:xID=""
	  
		Set obj = ##class(DHCHAI.DP.LabBactAntiInt).GetObjById(xID)
		Continue:'$Isobject(obj)
		Continue:'$Isobject(obj.BTBactDr)
		Continue:'$Isobject(obj.BTAntiDr)
			
		Set BactDesc = obj.BTBactDesc
		Set BactDr	 = obj.BTBactDr.%Id()	
		Set AntDesc	 = obj.BTAntiDesc	
		Set AntDr	 = obj.BTAntiDr.%Id()	
		Set IsActive = obj.BTIsActive
		Continue:(aIsActive'="")&&(aIsActive'=IsActive)
		Set IsActDesc=$s(IsActive=1:"是",1:"否")
		Set Note     = obj.BTNote
		Set ActDate	 = obj.BTActDate	
		Set ActTime  = obj.BTActTime
		Set:ActDate'="" ActDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(ActDate)
	    Set:ActTime'="" ActTime=$zt(ActTime,1)
		
		Set Data = $lb(xID,BactDesc,BactDr,AntDesc,AntDr,IsActive,IsActDesc,Note,ActDate,ActTime)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	Quit $$$OK
}

ClassMethod QryLabBactAntiIntClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryLabBactAntiIntExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryLabBactAntiIntFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryLabBactAntiIntExecute ]
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
/// CreatDate：   2021-03-22
/// Description:  查询细菌天然耐药
/// Table：       DHCHAI.DP.LabBactAntiInt
/// Input：       
/// do ##class(%Library.ResultSet).RunQuery("DHCHAI.DPS.LabBactAntiIntSrv","QryBactAntiInt","鲍曼","1")
Query QryBactAntiInt(aKeyDesc As %String = "", aIsActive As %String = "") As %Query(ROWSPEC = "ID:%String,BactDesc:%String,BactDr:%String,AntDesc:%String,AntDr:%String,IsActive:%String,IsActDesc:%String,Note:%String,ActDate:%String,ActTime:%String") [ SqlProc ]
{
}

ClassMethod QryBactAntiIntExecute(ByRef qHandle As %Binary, aKeyDesc As %String = "", aIsActive As %String = "") As %Status
{

	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)

	Set xBactDesc = ""
	For {
		Set xBactDesc = $o(^CT.MA.HAI.DP.LabBactAntiIntI("IndexBactAntDesc",xBactDesc))
		Quit:xBactDesc=""
	  	    
	  	Set xAntDesc = ""
		For {
			Set xAntDesc = $o(^CT.MA.HAI.DP.LabBactAntiIntI("IndexBactAntDesc",xBactDesc,xAntDesc))
			Quit:xAntDesc=""
			Continue:(aKeyDesc'="")&&(xAntDesc'[aKeyDesc)&&(xBactDesc'[aKeyDesc)
			Set xID = ""
			For {
				Set xID = $o(^CT.MA.HAI.DP.LabBactAntiIntI("IndexBactAntDesc",xBactDesc,xAntDesc,xID))
				Quit:xID=""		
		
				Set obj = ##class(DHCHAI.DP.LabBactAntiInt).GetObjById(xID)
				Continue:'$Isobject(obj)
				Continue:'$Isobject(obj.BTBactDr)
				Continue:'$Isobject(obj.BTAntiDr)
					
				Set BactDr	 = obj.BTBactDr.%Id()	
				Set AntDr	 = obj.BTAntiDr.%Id()	
				Set IsActive = obj.BTIsActive
				Continue:(aIsActive'="")&&(aIsActive'=IsActive)
				Set IsActDesc=$s(IsActive=1:"是",1:"否")
				Set Note     = obj.BTNote
				Set ActDate	 = obj.BTActDate	
				Set ActTime  = obj.BTActTime
				Set:ActDate'="" ActDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(ActDate)
			    Set:ActTime'="" ActTime=$zt(ActTime,1)
				
				Set Data = $lb(xID,xBactDesc,BactDr,xAntDesc,AntDr,IsActive,IsActDesc,Note,ActDate,ActTime)
				Set ^CacheTemp(repid,ind)=Data
				Set ind=ind+1
			}
		}
	}
	Quit $$$OK
}

ClassMethod QryBactAntiIntClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryBactAntiIntExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryBactAntiIntFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryBactAntiIntExecute ]
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
