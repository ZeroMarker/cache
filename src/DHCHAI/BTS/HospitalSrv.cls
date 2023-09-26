/// 名称: DHCHAI.BTS.HospitalSrv
/// 描述: 医院信息相关服务
/// 编写者：chenjb
/// 编写日期: 2017-03-20
Class DHCHAI.BTS.HospitalSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhufei
/// CreatDate：   2017-05-04
/// Description:  根据EpisodeID取医院ID
/// Table：       DHCHAI.BT.Hospital
/// Input：       aEpisodeID:    DHCHAI.DP.PAAdm.ID
/// Return：      返回Object
/// w ##class(DHCHAI.BTS.HospitalSrv).GetHospitalID(1)
ClassMethod GetHospitalID(aLocID As %String, aEpisodeID As %String = "") As %String
{
	New (aLocID,aEpisodeID)
	Set return=""
	Quit:(aLocID="")&&(aEpisodeID="") return
	
	If aLocID="" {
		Set objEpisode=##class(DHCHAI.DP.PAAdm).GetObjById(aEpisodeID)
		Quit:'$IsObject(objEpisode) return
		Set LocID=objEpisode.PAAdmLocDr
	} Else {
		Set LocID=aLocID
	}
	Quit:LocID="" return
	
	Set objLoc=##class(DHCHAI.BT.Location).GetObjById(LocID)
	Quit:'$IsObject(objLoc) return
	Quit:'$IsObject(objLoc.BTHospDr) return
	Set return=objLoc.BTHospDr.%Id()
	Quit return
}

/// Creator：     chenjb
/// CreatDate：   2017-03-20
/// Description:  查询医院列表
/// Table：       DHCHAI.BT.Hospital
/// Input：       aCode : 代码
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCHAI.BTS.HospitalSrv","QryHospital")
Query QryHospital() As %Query(ROWSPEC = "ID:%String,BTCode:%String,BTDesc:%String,BTDesc2:%String,BTGroupDr:%String,BTGroupDesc:%String,BTXCode:%String,BTIsActive:%String,BTActDate:%String,BTActTime:%String,BTActUserDr:%String,BTActUser:%String") [ SqlProc ]
{
}

ClassMethod QryHospitalExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
	
 	Set xID=0
 	For {
	 	Set xID=$o(^DHCHAI.BT.HospitalD(xID))
	 	Quit:xID=""
	 	
	 	Set objHosp=##class(DHCHAI.BT.Hospital).GetObjById(xID)
	 	Continue:'$IsObject(objHosp)
	 	
	 	Set Code=objHosp.BTCode
		Set Desc=objHosp.BTDesc
		Set Desc2=objHosp.BTDesc2
		If $IsObject(objHosp.BTGroupDr){
			Set GroupDr=objHosp.BTGroupDr.%Id()
			Set GroupDesc=objHosp.BTGroupDr.BTDesc
		} Else {
			Set GroupDr="",GroupDesc=""
		}
		Set XCode = objHosp.BTXCode
		Set IsActive=objHosp.BTIsActive
		Continue:IsActive'="1"
		Set ActDate=objHosp.BTActDate
		Set:ActDate'="" ActDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(ActDate)
		Set ActTime=objHosp.BTActTime
		Set:ActTime'="" ActTime=$zt(ActTime,1)
		If $IsObject(objHosp.BTActUserDr) {
			Set ActUserDr=objHosp.BTActUserDr.%Id()
			Set ActUser=objHosp.BTActUserDr.BTDesc
		} Else {
			Set ActUserDr="",ActUser=""
		}
		
		set Data=$lb(xID,Code,Desc,Desc2,GroupDr,GroupDesc,XCode,IsActive,ActDate,ActTime,ActUserDr,ActUser)
        Set ^CacheTemp(repid,ind)=Data
        Set ind=ind+1
	}
	
	Quit $$$OK
}

ClassMethod QryHospitalClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryHospitalExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryHospitalFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryHospitalExecute ]
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
/// CreatDate：   2018-05-09
/// Description:  查询医院列表(下拉框)  //20220930新增按医院分组查询
/// Table：       DHCHAI.BT.Hospital
/// Input：       aCode : 代码
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCHAI.BTS.HospitalSrv","QryHospitalToSelect")
Query QryHospitalToSelect(aLogonHospID As %String = "") As %Query(ROWSPEC = "ID:%String,BTCode:%String,BTDesc:%String,BTDesc2:%String,BTGroupDr:%String,BTGroupDesc:%String,BTXCode:%String,BTIsActive:%String,BTActDate:%String,BTActTime:%String,BTActUserDr:%String,BTActUser:%String") [ SqlProc ]
{
}

ClassMethod QryHospitalToSelectExecute(ByRef qHandle As %Binary, aLogonHospID As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
	
 	Set xID=0
 	For {
	 	Set xID=$o(^DHCHAI.BT.HospitalD(xID))
	 	Quit:xID=""
	 	
	 	Set objHosp=##class(DHCHAI.BT.Hospital).GetObjById(xID)
	 	Continue:'$IsObject(objHosp)
	 	
	 	Set Code=objHosp.BTCode
		Set Desc=objHosp.BTDesc
		Set Desc2=objHosp.BTDesc2
		If $IsObject(objHosp.BTGroupDr){
			Set GroupDr=objHosp.BTGroupDr.%Id()
			Set GroupDesc=objHosp.BTGroupDr.BTDesc
            if (aLogonHospID'="")&& (GroupDr'="")
            {
               Continue:'$d(^DHCHAI.BT.HospitalI("IndexHospGroupDr",GroupDr,aLogonHospID))
            }
		} Else {
			Set GroupDr="",GroupDesc=""
		}
		Set XCode = objHosp.BTXCode
		Set IsActive=objHosp.BTIsActive
		Continue:IsActive=0  // 过滤有效性
		Set ActDate=objHosp.BTActDate
		Set:ActDate'="" ActDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(ActDate)
		Set ActTime=objHosp.BTActTime
		Set:ActTime'="" ActTime=$zt(ActTime,1)
		If $IsObject(objHosp.BTActUserDr) {
			Set ActUserDr=objHosp.BTActUserDr.%Id()
			Set ActUser=objHosp.BTActUserDr.BTDesc
		} Else {
			Set ActUserDr="",ActUser=""
		}
		
		set Data=$lb(xID,Code,Desc,Desc2,GroupDr,GroupDesc,XCode,IsActive,ActDate,ActTime,ActUserDr,ActUser)
        Set ^CacheTemp(repid,ind)=Data
        Set ind=ind+1
	}
	
	Quit $$$OK
}

ClassMethod QryHospitalToSelectClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryHospitalToSelectExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryHospitalToSelectFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryHospitalToSelectExecute ]
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
/// Description:  根据医院ID获取医院编码及名称
/// Table：       DHCHAI.BT.Hospital
/// Input：       aHospID  : 医院ID（DHCHAI.BT.Hospital.ID）
/// Return：      返回医院编码及医院列表
/// w ##class(DHCHAI.BTS.HospitalSrv).GetHospCode("1")
ClassMethod GetHospCode(aHospID As %String)
{
	New (aHospID)
	Set return=""
	Quit:(aHospID="") return
	
	Set xHospID=0	
	For {
		Set xHospID=$o(^DHCHAI.BT.HospitalD(xHospID))
		Quit:xHospID=""
		
		Set objHosp = ##class(DHCHAI.BT.Hospital).GetObjById(xHospID)
		Continue:'$isobject(objHosp)
		Set HospCode = objHosp.BTCode	   
	    Set HospDesc = objHosp.BTDesc
	    Set return =HospCode_"^"_HospDesc
	}
	Quit return
}

/// Creator：     pylian
/// CreatDate：   2017-03-22
/// Description:  根据医院代码取医院列表
/// Table：       DHCHAI.BT.Hospital
/// Input：       
/// d ##class(%ResultSet).RunQuery("DHCHAI.BTS.HospitalSrv","QryHospByCode","DJSZHYYFY")
Query QryHospByCode(aHospCode As %String) As %Query(ROWSPEC = "ID:%String,HospCode:%String,HospDesc:%String,GroupCode:%String,GroupDesc:%String,CTHospCode:%String,Active:%String,ActiveDesc:%String,ActDate:%String,ActTime:%String,ActUserCode:%String,ActUser:%String") [ SqlProc ]
{
}

ClassMethod QryHospByCodeExecute(ByRef qHandle As %Binary, aHospCode As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Set xHospID=0	
	For {
		Set xHospID=$o(^DHCHAI.BT.HospitalI("IndexHospCode",aHospCode,xHospID))
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

ClassMethod QryHospByCodeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryHospByCodeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryHospByCodeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryHospByCodeExecute ]
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

/// Creator：     zhufei
/// CreatDate：   2017-08-09
/// Description:  根据登录医院找对应医院分组下的医院列表
/// Table：       DHCHAI.BT.Hospital、DHCHAI.BT.HospGroup
/// Input：       LogonHospID : 登录医院ID(DHCHAI.BT.Hospital.ID)
/// d ##class(%ResultSet).RunQuery("DHCHAI.BTS.HospitalSrv","QryHospListByLogon","1")
Query QryHospListByLogon(aLogonHospID As %String, aIsShowAll As %String = "1") As %Query(ROWSPEC = "ID:%String,HospDesc:%String") [ SqlProc ]
{
}

ClassMethod QryHospListByLogonExecute(ByRef qHandle As %Binary, aLogonHospID As %String, aIsShowAll As %String = "1") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:aLogonHospID="" $$$OK
	Set objHosp=##class(DHCHAI.BT.Hospital).GetObjById(aLogonHospID)
	Quit:'$IsObject(objHosp) $$$OK
	Quit:'$IsObject(objHosp.BTGroupDr) $$$OK
	Set HospGrpID=objHosp.BTGroupDr.%Id()
	Set HospGrpDesc=objHosp.BTGroupDr.BTDesc
	Quit:HospGrpID="" $$$OK
	
	Kill arrResult
	Set HospIDs=""
	Set xID=0
	For {
		Set xID=$o(^DHCHAI.BT.HospitalI("IndexHospGroupDr",HospGrpID,xID))
		Quit:xID=""
		
		Set objHosp=##class(DHCHAI.BT.Hospital).GetObjById(xID)
		Continue:'$IsObject(objHosp)
		Continue:objHosp.BTIsActive'=1
		Set HospCode=objHosp.BTCode
	    Set HospDesc=objHosp.BTDesc
	    Set HospDesc2=objHosp.BTDesc2
		Set:HospDesc2'="" HospDesc=HospDesc2
		//多语言处理
		//Set HospDesc=##Class(DHCHAI.Abstract).HAIGetTranByDesc("BTDesc",HospDesc,"DHCHAI.BT.Hospital")
		//以HIS下数据为准
		Set HospDesc=##Class(DHCHAI.Abstract).HAIGetTranByDesc("HOSPDesc",HospDesc,"User.CTHospital")
		Set HospIDs=$s(HospIDs="":xID,1:HospIDs_"|"_xID)
		Set arrResult(xID)=$lb(xID,HospDesc)
	}
	
	If (HospIDs'=aLogonHospID)&(aIsShowAll'=0) {
		Set AllDataDesc= ##class(websys.Translation).Get("dhcma.hai.ir.handhy.reg.csp","全部院区")
		Set Data=$lb(HospIDs,AllDataDesc)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	Set xID=0
	For {
		Set xID=$o(arrResult(xID))
		Quit:xID=""
		Set Data=$g(arrResult(xID))
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	Kill arrResult
	
	Quit $$$OK
}

ClassMethod QryHospListByLogonClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryHospListByLogonExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryHospListByLogonFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryHospListByLogonExecute ]
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

/// Creator：     chenjb
/// CreatDate：   2017-08-09
/// Description:  根据登录医院His代码找对应医院分组下的医院列表
/// Table：       DHCHAI.BT.Hospital、DHCHAI.BT.HospGroup
/// Input：       LogonHospID : 登录医院ID(DHCHAI.BT.Hospital.ID)
/// d ##class(%ResultSet).RunQuery("DHCHAI.BTS.HospitalSrv","QryHospListByHis","1")
Query QryHospListByHis(aLogonHospID As %String) As %Query(ROWSPEC = "ID:%String,HospDesc:%String") [ SqlProc ]
{
}

ClassMethod QryHospListByHisExecute(ByRef qHandle As %Binary, aLogonHospID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:aLogonHospID="" $$$OK
	Set objHosp=##class(DHCHAI.BT.Hospital).GetObjById(aLogonHospID)
	Quit:'$IsObject(objHosp) $$$OK
	Quit:'$IsObject(objHosp.BTGroupDr) $$$OK
	Set HospGrpID=objHosp.BTGroupDr.%Id()
	Set HospGrpDesc=objHosp.BTGroupDr.BTDesc
	Quit:HospGrpID="" $$$OK
	
	Kill arrResult
	Set HospIDs=""
	Set xID=0
	For {
		Set xID=$o(^DHCHAI.BT.HospitalI("IndexHospGroupDr",HospGrpID,xID))
		Quit:xID=""
		
		Set objHosp=##class(DHCHAI.BT.Hospital).GetObjById(xID)
		Continue:'$IsObject(objHosp)
		Continue:objHosp.BTIsActive'=1
		Set HospCode=objHosp.BTCode
	    Set HospDesc=objHosp.BTDesc
	    Set HospDesc2=objHosp.BTDesc2
		Set:HospDesc2'="" HospDesc=HospDesc2
		
		Set HospIDs=$s(HospIDs="":xID,1:HospIDs_"|"_xID)
		Set arrResult(xID)=$lb(xID,HospDesc)
	}
	
	If HospIDs'=aLogonHospID {
		Set Data=$lb(HospIDs,"全部院区")
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	Set xID=0
	For {
		Set xID=$o(arrResult(xID))
		Quit:xID=""
		Set Data=$g(arrResult(xID))
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	Kill arrResult
	
	Quit $$$OK
}

ClassMethod QryHospListByHisClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryHospListByHisExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryHospListByHisFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryHospListByHisExecute ]
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

}
