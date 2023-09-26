/// 名称: DHCHAI.BTS.HospGroupSrv
/// 描述: 医院分组相关服务
/// 编写者：chenjb
/// 编写日期: 2017-03-20
Class DHCHAI.BTS.HospGroupSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     chenjb
/// CreatDate：   2017-03-20
/// Description:  查询医院分组列表
/// Table：       DHCHAI.BT.HospGroup
/// Input：       aCode : 代码
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCHAI.BTS.HospGroupSrv","QueryHospGroup")
Query QueryHospGroup() As %Query(ROWSPEC = "ID:%String,BTCode:%String,BTDesc:%String") [ SqlProc ]
{
}

ClassMethod QueryHospGroupExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
	
 	Set xID=0
 	For {
	 	Set xID=$o(^DHCHAI.BT.HospGroupD(xID))
	 	Quit:xID=""
	 	
	 	Set obj=##class(DHCHAI.BT.HospGroup).GetObjById(xID)
	 	Continue:'$IsObject(obj)
	 	Set Code=obj.BTCode
		Set Desc=obj.BTDesc
		set Data=$lb(xID,Code,Desc)
        Set ^CacheTemp(repid,ind)=Data
        Set ind=ind+1
	}
	Quit $$$OK
}

ClassMethod QueryHospGroupClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryHospGroupExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QueryHospGroupFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryHospGroupExecute ]
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

/// do ##class(%ResultSet).RunQuery("DHCHAI.BTS.HospGroupSrv","QueryHospGroupRow",ID)
Query QueryHospGroupRow(aID As %String) As %Query(ROWSPEC = "ID:%String,BTCode:%String,BTDesc:%String") [ SqlProc ]
{
}

ClassMethod QueryHospGroupRowExecute(ByRef qHandle As %Binary, aID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	Set obj=##class(DHCHAI.BT.HospGroup).GetObjById(aID)
 	Quit:'$IsObject(obj) $$$OK
 	Set Code=obj.BTCode
	Set Desc=obj.BTDesc
	set Data=$lb(xID,Code,Desc)
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
 	
	Quit $$$OK
}

ClassMethod QueryHospGroupRowClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryHospGroupRowExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QueryHospGroupRowFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryHospGroupRowExecute ]
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

/// Creator：     pylian
/// CreatDate：   2017-03-22
/// Description:  医院分组关联医院
/// Input：       ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.BTS.HospGroupSrv).AddHospGrpCfg("ZY^DHSZHYY","^")
ClassMethod AddHospGrpCfg(aInputStr As %String, aSeparate As %String) As %String
{
	New (aInputStr,aSeparate)
	Set return=0
	Quit:aInputStr="" return
	
	Set HospGrpCode = $p(aInputStr,aSeparate,1)
	Set HospCode = $p(aInputStr,aSeparate,2)
	Quit:(HospGrpCode="")||(HospCode="") return
	
	Set HospGrpID=""
	Set HospGrpID=$o(^DHCHAI.BT.HospGroupI("IdxofCode",HospGrpCode,0))
	Quit:HospGrpID="" return
	Set HospID=$o(^DHCHAI.BT.HospitalI("IndexHospCode",HospCode,0))
	Quit:HospID="" return
	
	Set obj=##class(DHCHAI.BT.Hospital).%OpenId(HospID)
	Quit:'$IsObject(obj) return

	Set objGroup=##class(DHCHAI.BT.HospGroup).GetObjById(HospGrpID)
	Set obj.BTGroupDr=objGroup

	Set sc=obj.%Save()	
	if $system.Status.IsError(sc) {        //检查Save是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	}else{
		Set return=obj.%Id()
	}
	Do obj.%Close()
	
	Quit return
}

/// Creator：     pylian
/// CreatDate：   2017-03-22
/// Description:  删除医院分组关联
/// Input：       ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.BTS.HospGroupSrv).DelHospGrpCfg("ZY^DJSZHYYFY","^")
ClassMethod DelHospGrpCfg(aInputStr As %String, aSeparate As %String) As %String
{
	New (aInputStr,aSeparate)
	Set return=0
	Quit:aInputStr="" return
	
	Set HospGrpCode = $p(aInputStr,aSeparate,1)
	Set HospCode = $p(aInputStr,aSeparate,2)
	Quit:(HospGrpCode="")||(HospCode="") return
	
	Set HospGrpID=$o(^DHCHAI.BT.HospGroupI("IdxofCode",HospGrpCode,0))
	Quit:HospGrpID="" return
	Set HospID=$o(^DHCHAI.BT.HospitalI("IndexHospCode",HospCode,0))
	Quit:HospID="" return
	
	Set obj=##class(DHCHAI.BT.Hospital).%OpenId(HospID)
	Quit:'$IsObject(obj) return
	Set obj.BTGroupDr = ""
	
	Set sc=obj.%Save()
	if $system.Status.IsError(sc) {        //检查Save是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	}else{
		Set return=obj.%Id()
	}
	Do obj.%Close()
	
	Quit return
}

/// Creator：     pylian
/// CreatDate：   2017-03-22
/// Description:  根据分组代码查询医院分组
/// Table：       DHCHAI.BT.HospGroup
/// Input：       
/// do ##class(%Library.ResultSet).RunQuery("DHCHAI.BTS.HospGroupSrv","QryGroupByCode","ZY")
Query QryGroupByCode(aCode As %String) As %Query(ROWSPEC = "ID:%String,Code:%String,Desc:%String") [ SqlProc ]
{
}

ClassMethod QryGroupByCodeExecute(ByRef qHandle As %Binary, aCode As %String) As %Status
{
	
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Set xID = ""
	For {
		Set xID = $o(^DHCHAI.BT.HospGroupI("IdxofCode",aCode,xID))
		Quit:xID=""
	
		Set objHospGroup = ##class(DHCHAI.BT.HospGroup).GetObjById(xID)
		Continue:'$isobject(objHospGroup)
		
		Set Code = objHospGroup.BTCode
		Set Desc = objHospGroup.BTDesc
				
		Set Data = $lb(xID,Code,Desc)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	Quit $$$OK
}

ClassMethod QryGroupByCodeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryGroupByCodeExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryGroupByCodeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryGroupByCodeExecute ]
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
/// CreatDate：   2017-03-22
/// Description:  根据分组代码查询医院列表
/// Table：       DHCHAI.BT.HospGroup,DHCHAI.BT.Hospital
/// Input：       
/// do ##class(%Library.ResultSet).RunQuery("DHCHAI.BTS.HospGroupSrv","QryHospListByCode","ZY")
Query QryHospListByCode(aCode As %String) As %Query(ROWSPEC = "HospID:%String,HospCode:%String,HospDesc:%String,GroupCode:%String,GroupDesc:%String,CTHospCode:%String,Active:%String,ActiveDesc:%String,ActDate:%String,ActTime:%String,ActUserCode:%String,ActUser:%String") [ SqlProc ]
{
}

ClassMethod QryHospListByCodeExecute(ByRef qHandle As %Binary, aCode As %String) As %Status
{
	
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Set xID = ""
	For {
		Set xID = $o(^DHCHAI.BT.HospGroupI("IdxofCode",aCode,xID))
		Quit:xID=""
	
		Set objHospGroup = ##class(DHCHAI.BT.HospGroup).GetObjById(xID)
		Continue:'$isobject(objHospGroup)
		
		Set xHospID=0	
		For {
			Set xHospID=$o(^DHCHAI.BT.HospitalI("IndexHospGroupDr",xID,xHospID))
			Quit:xHospID=""
			Set objHosp = ##class(DHCHAI.BT.Hospital).GetObjById(xHospID)
			Continue:'$isobject(objHosp)
			
			Set HospCode 		= objHosp.BTCode	   
		    Set HospDesc 		= objHosp.BTDesc	
		    Set GroupCode="",GroupDesc=""
			If $IsObject(objHosp.BTGroupDr) {
				Set GroupCode	= objHosp.BTGroupDr.BTCode
				Set GroupDesc	= objHosp.BTGroupDr.BTDesc	
			}   	
		    Set CTHospCode 		= objHosp.BTXCode		
		    Set Active 			= objHosp.BTIsActive
			Set:+Active=1 ActiveDesc = "是"
			Set:+Active=0 ActiveDesc = "否"	
		    Set ActDate 		= objHosp.BTActDate	
		    Set:ActDate'="" ActDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(ActDate)
		    Set ActTime 		= objHosp.BTActTime	
		    Set:ActTime'="" ActTime=$zt(ActTime,1)

			Set ActUser="",ActUserDesc=""
			If $IsObject(objHosp.BTActUserDr) {
				Set ActUser     = objHosp.BTActUserDr.BTCode
				Set ActUserDesc = objHosp.BTActUserDr.BTDesc
			}
			Set Data=$lb(xHospID,HospCode,HospDesc,GroupCode,GroupDesc,CTHospCode,Active,ActiveDesc,ActDate,ActTime,ActUser,ActUserDesc)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
	}
	Quit $$$OK
}

ClassMethod QryHospListByCodeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryHospListByCodeExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryHospListByCodeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryHospListByCodeExecute ]
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
/// CreatDate：   2017-03-22
/// Description:  根据分组ID查询医院列表
/// Table：       DHCHAI.BT.HospGroup,DHCHAI.BT.Hospital
/// Input：       
/// do ##class(%Library.ResultSet).RunQuery("DHCHAI.BTS.HospGroupSrv","QryHospListByID","1")
Query QryHospListByID(aHospGrpID As %String) As %Query(ROWSPEC = "HospID:%String,HospCode:%String,HospDesc:%String,GroupCode:%String,GroupDesc:%String,CTHospCode:%String,Active:%String,ActiveDesc:%String,ActDate:%String,ActTime:%String,ActUserCode:%String,ActUser:%String") [ SqlProc ]
{
}

ClassMethod QryHospListByIDExecute(ByRef qHandle As %Binary, aHospGrpID As %String) As %Status
{
	
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)	
		
	Set xHospID=0	
	For {
		Set xHospID=$o(^DHCHAI.BT.HospitalI("IndexHospGroupDr",aHospGrpID,xHospID))
		Quit:xHospID=""
		Set objHosp = ##class(DHCHAI.BT.Hospital).GetObjById(xHospID)
		Continue:'$isobject(objHosp)
		
		Set HospCode 		= objHosp.BTCode	   
	    Set HospDesc 		= objHosp.BTDesc	
	    Set GroupCode="",GroupDesc=""
		If $IsObject(objHosp.BTGroupDr) {
			Set GroupCode	= objHosp.BTGroupDr.BTCode
			Set GroupDesc	= objHosp.BTGroupDr.BTDesc	
		}   	
	    Set CTHospCode 		= objHosp.BTXCode		
	    Set Active 			= objHosp.BTIsActive
		Set:+Active=1 ActiveDesc = "是"
		Set:+Active=0 ActiveDesc = "否"	
	    Set ActDate 		= objHosp.BTActDate	
	    Set:ActDate'="" ActDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(ActDate)
	    Set ActTime 		= objHosp.BTActTime	
	    Set:ActTime'="" ActTime=$zt(ActTime,1)

		Set ActUser="",ActUserDesc=""
		If $IsObject(objHosp.BTActUserDr) {
			Set ActUser     = objHosp.BTActUserDr.BTCode
			Set ActUserDesc = objHosp.BTActUserDr.BTDesc
		}
		Set Data=$lb(xHospID,HospCode,HospDesc,GroupCode,GroupDesc,CTHospCode,Active,ActiveDesc,ActDate,ActTime,ActUser,ActUserDesc)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
		
	}
	Quit $$$OK
}

ClassMethod QryHospListByIDClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryHospListByIDExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryHospListByIDFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryHospListByIDExecute ]
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
/// CreatDate：   2017-03-22
/// Description:  获得医院分组下的医院列表
/// Table：       DHCHAI.BT.Hospital
/// w ##Class(DHCHAI.BTS.HospGroupSrv).GetHospListByGroup(1)
ClassMethod GetHospListByGroup(aHospGrpID As %String) As %String
{
	New (aHospGrpID)
	Set return=""
	Quit:aHospGrpID="" return

	Set xHospID=0	
	For {
		Set xHospID=$o(^DHCHAI.BT.HospitalD(xHospID))
		Quit:xHospID=""
		
		Set objHosp = ##class(DHCHAI.BT.Hospital).GetObjById(xHospID)
		Continue:'$isobject(objHosp)
		Set HospCode = objHosp.BTCode	   
	    Set HospDesc = objHosp.BTDesc	   
		Set GroupID="",GroupCode="",GroupDesc=""
		If $IsObject(objHosp.BTGroupDr) {
			Set GroupID = objHosp.BTGroupDr.%Id()
			Set GroupCode = objHosp.BTGroupDr.BTCode
			Set GroupDesc = objHosp.BTGroupDr.BTDesc	
		}   
		Continue:("|"_GroupID_"|")'[("|"_aHospGrpID_"|")
		
		Set return=return_HospCode_"|"
	}
	Set:return'="" return=$e(return,2,$l(return))
	Quit return
}

/// Creator：     pylian
/// CreatDate：   2021-07-20
/// Description:  获得医院分组下的医院列表
/// Table：       DHCHAI.BT.Hospital
/// w ##Class(DHCHAI.BTS.HospGroupSrv).GetHospIDsByGroup(1)
ClassMethod GetHospIDsByGroup(aHospGrpID As %String) As %String
{
	New (aHospGrpID)
	Set return=""
	Quit:aHospGrpID="" return

	Set xHospID=0	
	For {
		Set xHospID=$o(^DHCHAI.BT.HospitalD(xHospID))
		Quit:xHospID=""
		
		Set objHosp = ##class(DHCHAI.BT.Hospital).GetObjById(xHospID)
		Continue:'$isobject(objHosp)   
	    Set HospDesc = objHosp.BTDesc	   
		Set GroupID="",GroupCode="",GroupDesc=""
		If $IsObject(objHosp.BTGroupDr) {
			Set GroupID = objHosp.BTGroupDr.%Id()
			Set GroupCode = objHosp.BTGroupDr.BTCode	
		}   
		Continue:("|"_GroupID_"|")'[("|"_aHospGrpID_"|")
		
		Set return=return_xHospID_"|"
	}
	Set:return'="" return=$e(return,0,$l(return)-1)
	Quit return
}

}
