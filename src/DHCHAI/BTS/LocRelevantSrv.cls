/// 名称: DHCHAI.BTS.LocRelevantSrv
/// 描述: 相关科室相互关联服务类
/// 编写者: mayanpeng
/// 编写日期: 2018-07-10
Class DHCHAI.BTS.LocRelevantSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     mayanpeng
/// CreatDate：   2018-07-10
/// Description:  查询相互关联科室
/// Table：       DHCHAI.BT.LocRelevant,DHCHAI.BT.Location
/// Input：       aTypeID:DHCHAI.BT.Dictionary.ID(字典类型LocRelevant);aIsActive:DHCHAI.BT.LocRelevant.BTIsActive
/// do ##class(%Library.ResultSet).RunQuery("DHCHAI.BTS.LocRelevantSrv","QryLocRelev","399")
Query QryLocRelev(aTypeID As %String, aIsActive As %String = "") As %Query(ROWSPEC = "ID:%String,Name:%String,TypeID:%String,TypeDesc:%String,LocIDList:%String,LocDescList:%String,IsActive:%String,ActDate:%String,ActTime:%String,ActUserDr:%String,ActUser:%String") [ SqlProc ]
{
}

ClassMethod QryLocRelevExecute(ByRef qHandle As %Binary, aTypeID As %String, aIsActive As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:(aTypeID="") $$$OK
	
	Set xRelevID = ""
	For {
    	Set xRelevID =$o(^DHCHAI.BT.LocRelevantI("IndexTypeDr",aTypeID,xRelevID))
    	Quit:xRelevID=""
		
		Set obj = ##class(DHCHAI.BT.LocRelevant).GetObjById(xRelevID)
		Continue:'$IsObject(obj)
	    Continue:(aIsActive'="")&&(aIsActive'=obj.BTIsActive)
	    
	    Set TypeDesc   = obj.BTTypeDr.BTDesc
		Set Name	   = obj.BTName
		Set LocList    = obj.BTLocList
		Set IsActive   = obj.BTIsActive
		Set ActDate    = obj.BTActDate
		Set:ActDate'="" ActDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(ActDate)
		Set ActTime    = obj.BTActTime
		Set:ActTime'="" ActTime=$zt(ActTime,1)
		Set ActUserDr  = obj.BTActUserDr
		Set (ActUserID,ActUser)=""
		If $IsObject(ActUserDr){
			Set ActUserID=ActUserDr.%Id()
			Set ActUser=ActUserDr.BTDesc
		}
		Set:$IsObject(ActUserDr) ActUser=ActUserDr.BTDesc
		
		Set tempLocIDList=""
		Set tempLocDescList=""
		For index=1:1:$Length(LocList,"|") {
			Set LocID = $p(LocList,"|",index)
			Set objLoc=##class(DHCHAI.BT.Location).GetObjById(LocID)
			Continue:'$IsObject(objLoc)
			Set LocDesc=objLoc.BTDesc
			Set LocDesc2=objLoc.BTDesc2
			Set:LocDesc2="" LocDesc2 = LocDesc
			Set:$p(LocDesc2,"-",2)'="" LocDesc2=$p(LocDesc2,"-",2)
			
			Set:tempLocIDList'="" tempLocIDList=tempLocIDList_","_LocID
			Set:tempLocIDList="" tempLocIDList=LocID
			
			Set:tempLocDescList'="" tempLocDescList=tempLocDescList_","_LocDesc2
			Set:tempLocDescList="" tempLocDescList=LocDesc2
		}
		
		Set Data = $lb(xRelevID,Name,aTypeID,TypeDesc,tempLocIDList,tempLocDescList,IsActive,ActDate,ActTime,ActUserID,ActUser)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	Quit $$$OK
}

ClassMethod QryLocRelevClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryLocRelevExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryLocRelevFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryLocRelevExecute ]
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

/// Creator：     mayanpeng
/// CreatDate：   2018-07-11
/// Description:  查询科室
/// Table：       DHCHAI.BT.LocRelevant,DHCHAI.BT.Location
/// Input：       aRelev:DHCHAI.BT.LocRelevant.ID
/// do ##class(%Library.ResultSet).RunQuery("DHCHAI.BTS.LocRelevantSrv","QryLoc","","","","","","1")
Query QryLoc(aHospIDs As %String = "", aAlias As %String = "", aLocCate As %String = "", aLocType As %String = "", aIsActive As %String = "", aRelev As %String = "") As %Query(ROWSPEC = "ID:%String,LocCode:%String,LocDesc:%String,LocDesc2:%String,IsRelev:%String") [ SqlProc ]
{
}

ClassMethod QryLocExecute(ByRef qHandlex As %Binary, aHospIDs As %String = "", aAlias As %String = "", aLocCate As %String = "", aLocType As %String = "", aIsActive As %String = "", aRelev As %String = "") As %Status
{
	Set repidx=$I(^CacheTemp)
	Set indx=1
	Set qHandlex=$lb(0,repidx,0)
	
	Set flag=..BuildLoc(aHospIDs,aAlias,aLocCate,aLocType,aIsActive,aRelev)
	Set NIndex="BuildLocRelevant"
	Set Count=""
	For {
		Set Count=$o(^TMP(NIndex,Count))
		Quit:Count=""
		Continue:$g(^TMP(NIndex,Count))=""
		
		Set Data=$g(^TMP(NIndex,Count))
		Set ^CacheTemp(repidx,indx)=Data
		Set indx=indx+1
	}
	Kill ^TMP(NIndex)
	Quit $$$OK
}

ClassMethod QryLocClose(ByRef qHandlex As %Binary) As %Status [ PlaceAfter = QryLocExecute ]
{
	set repidx=$LIST(qHandlex,2)
 	Kill ^CacheTemp(repidx)
	Quit $$$OK
}

ClassMethod QryLocFetch(ByRef qHandlex As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryLocExecute ]
{
	set AtEnd=$LIST(qHandlex,1)
 	set repidx=$LIST(qHandlex,2)
 	set indx=$LIST(qHandlex,3)
 	set indx=$o(^CacheTemp(repidx,indx))
 	If indx="" {				// if there are no more rows, finish fetching
 		set AtEnd=1
 		set Row=""
 	}
 	Else      {				// fetch row
 		set Row=^CacheTemp(repidx,indx)
 	}
 	// Save qHandlex
 	s qHandlex=$lb(AtEnd,repidx,indx)
	Quit $$$OK
}

ClassMethod BuildLoc(aHospIDs As %String = "", aAlias As %String = "", aLocCate As %String = "", aLocType As %String = "", aIsActive As %String = "", aRelev As %String = "") As %String
{
	New (aHospIDs,aAlias,aLocCate,aLocType,aIsActive,aRelev)
	Set return=""
	Set NIndex="BuildLocRelevant"
	Kill ^TMP(NIndex)
	Set Count=1
	
	Set LocList=""
	If aRelev'=""{
		Set LocList=##class(DHCHAI.BT.LocRelevant).GetLocListById(aRelev)
	}
	
	Set rs=##Class(%ResultSet).%New("DHCHAI.BTS.LocationSrv:QryLoc")
  	Set sc=rs.Execute(aHospIDs,aAlias,aLocCate,aLocType,aIsActive)
  	If $$$ISERR(sc) {
	  	Do $System.Status.DisplayError(sc)
	  	Quit $$$OK
  	}  	    
    While (rs.Next()) {
	    Set LocID=rs.Data("ID")
		Set LocCode=rs.Data("LocCode")
		Set LocDesc=rs.Data("LocDesc")
		Set LocDesc2=rs.Data("LocDesc2")
				
		Set IsRelev=0
		If (LocList'="")&&($ListFind(LocList,LocID)>0) {
			Set IsRelev=1
		}
		Set ^TMP(NIndex,Count) = $lb(LocID,LocCode,LocDesc,LocDesc2,IsRelev)
		Set Count=Count+1
	}
	Do rs.Close()
	Quit 1
}

/// Creator：     mayanpeng
/// CreatDate：   2018-07-11
/// Description:  关联或取消关联科室
/// Table：       DHCHAI.BT.LocRelevant
/// Input：       aRelevID:DHCHAI.BT.LocRelevant.ID   aLocID:DHCHAI.BT.Location.ID
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.BTS.LocRelevantSrv).relateRelevLoc("1","2331")
ClassMethod relateRelevLoc(aRelevID As %String, aLocID As %String, aUserID As %String = "") As %String
{
	New (aRelevID,aLocID,aUserID)
	Set return=-1
	Quit:(aRelevID="")||(aLocID="") return
	
	Set objRelev=##class(DHCHAI.BT.LocRelevant).GetObjById(aRelevID)
	Quit:'$IsObject(objRelev) return
	
	//包含即存在该科室，进行取消关联操作
	If ("|"_objRelev.BTLocList_"|") [ ("|"_aLocID_"|"){
		Set tempLocList=##class(DHCHAI.Utils.CommonSrv).Replace(objRelev.BTLocList,aLocID,"")
	} Else {
		//关联操作
		set tempLocList=objRelev.BTLocList_"|"_aLocID
	}
	Set InputStr=aRelevID_"^"_objRelev.BTName_"^"_objRelev.BTTypeDr.%Id()_"^"_tempLocList_"^1^^^"_aUserID
	Set return=##class(DHCHAI.BT.LocRelevant).Update(InputStr)
	Quit return
}

/// Creator：     mayanpeng
/// CreatDate：   2018-07-11
/// Description:  通过科室获取其他关联科室,若无关联，则返回$lb(aLocID)
/// Table：       DHCHAI.BT.LocRelevant
/// Input：       aTypeCode:DHCHAI.BT.Dictionary.BTCode(字典类型LocRelevant);aLocID:DHCHAI.BT.Location.ID
/// 			  aFormat:0代表List格式(默认) 1字符串格式
/// Return：      成功：返回list，失败：返回<0的代码
/// w ##class(DHCHAI.BTS.LocRelevantSrv).GetLocListByLoc("WestEstLocRelev","439")
ClassMethod GetLocListByLoc(aTypeCode As %String, aLocID As %String, aFormat As %String = "0") As %String
{
	New (aTypeCode,aLocID,aFormat)
	Set return=""
	Quit:(aTypeCode="")||(aLocID="") return
	
	Set objLoc=##class(DHCHAI.BT.Location).GetObjById(aLocID)
	Quit:'$IsObject(objLoc) return
	Set objDic=##class(DHCHAI.BT.Dictionary).GetObjByCode("LocRelevant",aTypeCode)
	Quit:'$IsObject(objDic) $lb(aLocID)
	
	Set IsRelev=0
	Set xReleveID=""
	For {
		Set xReleveID=$o(^DHCHAI.BT.LocRelevantI("IndexTypeDr",objDic.%Id(),xReleveID))
		Quit:xReleveID=""
		
		Set objRelev=##class(DHCHAI.BT.LocRelevant).GetObjById(xReleveID)
		Continue:'$IsObject(objRelev)
		Continue:objRelev.BTIsActive'=1
		
		Set LocList=##class(DHCHAI.Utils.CommonSrv).ListFromString(objRelev.BTLocList,"|")
		If ($ListFind(LocList,aLocID)>0){
			Set IsRelev=1
			Set return=LocList
			Quit
		}
	}
	Set:IsRelev=0 return=$lb(aLocID)
	Set:aFormat="1" return=##class(DHCHAI.Utils.CommonSrv).ListToString(return,"|")
	Quit return
}

/// Creator：     mayanpeng
/// CreatDate：   2018-07-17
/// Description:  通过科室获取有权限的其他关联科室,若无关联，则返回$lb(aLocID)
/// 			  权限：越排在前面的科室权限越高(维护时由高到低维护科室)
/// Table：       DHCHAI.BT.LocRelevant
/// Input：       aTypeCode:DHCHAI.BT.Dictionary.BTCode(字典类型LocRelevant);aLocID:DHCHAI.BT.Location.ID
/// 			  aFormat:0代表List格式(默认) 1字符串格式
/// Return：      成功：返回list，失败：返回<0的代码
/// w ##class(DHCHAI.BTS.LocRelevantSrv).GetPowerLocList("WestEstLocRelev","439")
ClassMethod GetPowerLocList(aTypeCode As %String, aLocID As %String, aFormat As %String = "0") As %String
{
	New (aTypeCode,aLocID,aFormat)
	Set return=""
	Quit:(aTypeCode="")||(aLocID="") return
	
	Set objLoc=##class(DHCHAI.BT.Location).GetObjById(aLocID)
	Quit:'$IsObject(objLoc) return
	Set objDic=##class(DHCHAI.BT.Dictionary).GetObjByCode("LocRelevant",aTypeCode)
	Quit:'$IsObject(objDic) $lb(aLocID)
	
	Set IsRelev=0
	Set xReleveID=""
	For {
		Set xReleveID=$o(^DHCHAI.BT.LocRelevantI("IndexTypeDr",objDic.%Id(),xReleveID))
		Quit:xReleveID=""
		
		Set objRelev=##class(DHCHAI.BT.LocRelevant).GetObjById(xReleveID)
		Continue:'$IsObject(objRelev)
		Continue:objRelev.BTIsActive'=1
		
		Set LocList=##class(DHCHAI.BT.LocRelevant).GetLocListById(xReleveID)
		If ($ListFind(LocList,aLocID)>0){
			Set tempLoc="",flag=0
			For ind=1:1:$ListLength(LocList) {
				Set tempLoc=$List(LocList,ind)
				Set:tempLoc=aLocID flag=1
				If (flag=1){
					Set return=return_$lb(tempLoc)
				}
			}
			Set IsRelev=1
			Quit
		}
	}
	Set:IsRelev=0 return=$lb(aLocID)
	Set:aFormat="1" return=##class(DHCHAI.Utils.CommonSrv).ListToString(return,"|")
	Quit return
}

/// Creator：     mayanpeng
/// CreatDate：   2018-07-13
/// Description:  通过科室获取主科室ID(规定LocList字段的第一个科室为主科室),无关联时返回aLocID
/// Table：       DHCHAI.BT.LocRelevant
/// Input：       aTypeCode:DHCHAI.BT.Dictionary.BTCode(字典类型LocRelevant);aLocID:DHCHAI.BT.Location.ID
/// Return：      成功：返回科室ID，失败：返回<0的代码
/// w ##class(DHCHAI.BTS.LocRelevantSrv).GetMainLocByLocID("WestEstLocRelev","434")
ClassMethod GetMainLocByLocID(aTypeCode As %String, aLocID As %String) As %String
{
	New (aTypeCode,aLocID)
	Set return=""
	Quit:(aTypeCode="")||(aLocID="") return
	
	Set objLoc=##class(DHCHAI.BT.Location).GetObjById(aLocID)
	Quit:'$IsObject(objLoc) return
	Set objDic=##class(DHCHAI.BT.Dictionary).GetObjByCode("LocRelevant",aTypeCode)
	Quit:'$IsObject(objDic) aLocID
	
	Set IsRelev=0
	Set xReleveID=""
	For {
		Set xReleveID=$o(^DHCHAI.BT.LocRelevantI("IndexTypeDr",objDic.%Id(),xReleveID))
		Quit:xReleveID=""
		
		Set objRelev=##class(DHCHAI.BT.LocRelevant).GetObjById(xReleveID)
		Continue:'$IsObject(objRelev)
		Continue:objRelev.BTIsActive'=1
		
		If ("|"_objRelev.BTLocList_"|") [ ("|"_aLocID_"|") {
			Set IsRelev=1
			Set return=$p(objRelev.BTLocList,"|",1) //返回第一个关联科室
			Quit
		}
	}
	Set:IsRelev=0 return=aLocID
	Quit return
}

/// Creator：     mayanpeng
/// CreatDate：   2018-07-13
/// Description:  通过科室获取新关联的名称(DHCHAI.BT.LocRelevant.BTName),无关联时返回aLocID的科室名称
/// Table：       DHCHAI.BT.LocRelevant
/// Input：       aTypeCode:DHCHAI.BT.Dictionary.BTCode(字典类型LocRelevant);aLocID:DHCHAI.BT.Location.ID
/// Return：      成功：返回新关联的名称，失败：返回<0的代码
/// w ##class(DHCHAI.BTS.LocRelevantSrv).GetNameByLocID("WestEstLocRelev","434")
ClassMethod GetNameByLocID(aTypeCode As %String, aLocID As %String) As %String
{
	New (aTypeCode,aLocID)
	Set return=""
	Quit:(aTypeCode="")||(aLocID="") return
	
	Set objLoc=##class(DHCHAI.BT.Location).GetObjById(aLocID)
	Quit:'$IsObject(objLoc) return
	Set LocDesc=objLoc.BTDesc
	Set LocDesc2=objLoc.BTDesc2
	Set:LocDesc2="" LocDesc2 = LocDesc
	Set:$p(LocDesc2,"-",2)'="" LocDesc2=$p(LocDesc2,"-",2)
	
	Set objDic=##class(DHCHAI.BT.Dictionary).GetObjByCode("LocRelevant",aTypeCode)
	Quit:'$IsObject(objDic) LocDesc2
	
	Set IsRelev=0
	Set xReleveID=""
	For {
		Set xReleveID=$o(^DHCHAI.BT.LocRelevantI("IndexTypeDr",objDic.%Id(),xReleveID))
		Quit:xReleveID=""
		
		Set obj=##class(DHCHAI.BT.LocRelevant).GetObjById(xReleveID)
		Continue:'$IsObject(obj)
		Continue:obj.BTIsActive'=1
		
		Set LocList=##class(DHCHAI.Utils.CommonSrv).ListFromString(obj.BTLocList,"|")
		If ($ListFind(LocList,aLocID)>0){
			Set IsRelev=1
			Set return=obj.BTName
			Quit
		}
	}
	//无关联时
	Set:IsRelev=0 return=LocDesc2
	Quit return
}

}
