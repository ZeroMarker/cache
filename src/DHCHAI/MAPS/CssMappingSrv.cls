/// 名称: DHCHAI.MAPS.CssMappingSrv
/// 描述: 横断面字典映射服务类
/// 编写者: chenjb
/// 编写日期: 2022-08-24
Class DHCHAI.MAPS.CssMappingSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhoubo
/// CreatDate：   2021-04-19
/// Description:  自动更新值域字典对照
/// Table：       DHCHAI.MAP.BaseMapping
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.MAPS.BaseMappingSrv).GetBaseMapDesc("性别","F","男")
ClassMethod GetBaseMapDesc(aTypeCode As %String, aPhraseCode As %String, aPhraseDesc As %String) As %String
{
	New (aTypeCode,aPhraseCode,aPhraseDesc)
	Set return=""

	Quit:(aTypeCode="")||(aPhraseCode="")||(aPhraseDesc="") return
	Set ID=$o(^MA.HAI.DP.CssMappingI("IndexTypeVal",aTypeCode,aPhraseCode,0))
	If (ID'=""){
		Set BMData = $g(^MA.HAI.DP.CssMappingD(ID))
		If (BMData'=""){
			Set RangeDr  = +$li(BMData,5)
			Set BaseData = $g(^MA.HAI.DP.CssRangeD(RangeDr))
			Set:BaseData'="" return = $li(BaseData,4)
		}
	}Else{
		Set InputStr = ID_"^"_aTypeCode_"^"_aPhraseCode_"^"_aPhraseDesc_"^^1^^^"
		Set BaseMID  = ##class(DHCHAI.MAP.CssMapping).Update(InputStr)
	}
	
	Quit return
}

/// Creator：     zhoubo
/// CreatDate：   2021-04-19
/// Description:  自动更新值域字典对照
/// Table：       DHCHAI.MAP.BaseMapping
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.MAPS.BaseMappingSrv).GetBaseMapDesc("性别","F","男")
ClassMethod GetBaseMapDescV2(aTypeCode As %String, aPhraseCode As %String, aPhraseDesc As %String) As %String
{
	New (aTypeCode,aPhraseCode,aPhraseDesc)
	Set return=""

	Quit:(aTypeCode="")||(aPhraseCode="")||(aPhraseDesc="") return
	Set ID=$o(^MA.HAI.DP.CssMappingI("IndexTypeVal",aTypeCode,aPhraseCode,0))
	If (ID'=""){
		Set BMData = $g(^MA.HAI.DP.CssMappingD(ID))
		If (BMData'=""){
			Set RangeDr  = +$li(BMData,5)
			Set BaseData = $g(^MA.HAI.DP.CssRangeD(RangeDr))
			Set:BaseData'="" return = $li(BaseData,3)_"^"_$li(BaseData,4)
		}
	}Else{
		Set InputStr = ID_"^"_aTypeCode_"^"_aPhraseCode_"^"_aPhraseDesc_"^^1^^^"
		Set BaseMID  = ##class(DHCHAI.MAP.CssMapping).Update(InputStr)
	}
	
	Quit return
}

/// Creator：     zhoubo
/// CreatDate：   2021-04-15
/// Description:  更新对照
/// Table：       DHCHAI.MAP.BaseMapping
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.MAPS.CssMappingSrv).UpdateMap("2","7","8")
ClassMethod UpdateMap(ID As %String, RangeID As %String, UserDr As %String) As %String
{
	New (ID,RangeID,UserDr)
	Set return=0
	
	Quit:(ID="")||(RangeID="") return
	Set objUser = ##class(DHCHAI.BT.SysUser).GetObjById(UserDr)
	Set objRange = ##class(DHCHAI.MAP.CssRange).GetObjById(RangeID)
	
	Set obj=##class(DHCHAI.MAP.CssMapping).%OpenId(ID)
	Quit:'$IsObject(obj) return
	Set obj.BMRangeDr = objRange
	Set:$IsObject(objUser) obj.BMActUserDr = objUser
	
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

/// Creator：     zhoubo
/// CreatDate：   2021-04-15
/// Description:  删除分类对照关系
/// Table：       DHCHAI.MAP.BaseMapping
/// Input：       Id
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCHAI.MAPS.BaseMappingSrv).DeleteMapById("2")
ClassMethod DeleteMapById(Id) As %String
{
	New (Id)
    Set return = 0
	Set obj=##class(DHCHAI.MAP.CssMapping).%OpenId(Id)
	Quit:'$IsObject(obj) return
	Set obj.BMRangeDr = ""
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

/// Creator：     zhoubo
/// CreatDate：   2021-04-14
/// Description:  查询基础字典映射
/// Table：       DHCHAI.MAP.BaseMapping
/// Input：       aType:分类编码
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCHAI.MAPS.BaseMappingSrv","QryBaseMapping","",1)
Query QryBaseMapping(aType As %String = "", aNoMapFlg As %String = "") As %Query(ROWSPEC = "ID:%String,Type:%String,KeyVal:%String,KeyText:%String,RangeDr:%String,BRCode:%String,BRDesc:%String,IsActive:%String,IsActDesc:%String,ActDate:%String,ActTime:%String,ActUserDr:%String,UserDesc:%String") [ SqlProc ]
{
}

ClassMethod QryBaseMappingExecute(ByRef qHandle As %Binary, aType As %String = "", aNoMapFlg As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
	
	If (aType'=""){
		Set xID=""
		For {
			Set xID=$o(^MA.HAI.DP.CssMappingI("IndexType"," "_aType,xID))
			Quit:xID=""
			do BuildData
		}
	}Else{
		Set xID=0
	 	For {
		 	Set xID=$o(^MA.HAI.DP.CssMappingD(xID))
		 	Quit:xID=""
		 	do BuildData
		}
	}
	Quit $$$OK
	
BuildData
 	Set BMData=$g(^MA.HAI.DP.CssMappingD(xID))
 	Quit:BMData=""
 	Set ID        = xID
 	Set Type      = $li(BMData,2)
 	Set KeyVal    = $li(BMData,3)
 	Set KeyText   = $li(BMData,4)
 	Set RangeDr   = $li(BMData,5)
 	Set IsActive  = $li(BMData,6)
 	Set ActDate   = $li(BMData,7)
 	Set ActTime   = $li(BMData,8)
 	Set ActUserDr = $li(BMData,9)
	Set IsActDesc = $s(IsActive=1:"是",1:"否")
	Quit:((aNoMapFlg=1)&&(RangeDr'=""))
	Set BRData="",BRDesc="",BRCode=""
	Set:RangeDr'="" BRData=$g(^MA.HAI.DP.CssRangeD(RangeDr))
	If (BRData'=""){
		Set BRCode = $li(BRData,3)
		Set BRDesc = $li(BRData,4)
	}
	Set UserData="",UserDesc=""
	Set:ActUserDr'="" UserData=$g(^DHCHAI.BT.SysUserD(ActUserDr))
	If (UserData'=""){
		Set UserDesc = $li(UserData,3)
	}
	Set:ActDate'="" ActDate=##class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(ActDate)
	Set:ActTime'="" ActTime=$zt(ActTime,1)
		
	Set Data=$lb(ID,Type,KeyVal,KeyText,RangeDr,BRCode,BRDesc,IsActive,IsActDesc,ActDate,ActTime,ActUserDr,UserDesc)
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    
    Quit
}

ClassMethod QryBaseMappingClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryBaseMappingExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryBaseMappingFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryBaseMappingExecute ]
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
/// CreatDate：   2021-04-14
/// Description:  查询基础值域字典
/// Table：       DHCHAI.MAP.BaseRange
/// Input：       aType:分类编码
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCHAI.MAPS.BaseMappingSrv","QryBaseRange","证件类型")
Query QryBaseRange(aType As %String = "", aAlis As %String = "") As %Query(ROWSPEC = "ID:%String,Type:%String,BRCode:%String,BRDesc:%String,IsActive:%String,IsActDesc:%String") [ SqlProc ]
{
}

ClassMethod QryBaseRangeExecute(ByRef qHandle As %Binary, aType As %String = "", aAlis As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
	
	If (aType'=""){
		Set xID=""
		For {
			Set xID=$o(^MA.HAI.DP.CssRangeI("IndexType"," "_aType,xID))
			Quit:xID=""
			do BuildMBData
		}
	}Else{
		Set xID=""
	 	For {
		 	Set xID=$o(^MA.HAI.DP.CssRangeD(xID))
		 	Quit:xID=""
		 	do BuildMBData
		}
	}
	Quit $$$OK
	
BuildMBData
 	Set BMData=$g(^MA.HAI.DP.CssRangeD(xID))
 	Quit:BMData=""
 	Set ID        = xID
 	Set Type      = $li(BMData,2)
 	Set BRCode    = $li(BMData,3)
 	Set BRDesc    = $li(BMData,4)
 	Set IsActive  = +$li(BMData,5)
	Set IsActDesc = $s(IsActive=1:"是",1:"否")
	Quit:(aAlis'="")&&(BRDesc'[aAlis)
	Set Data=$lb(ID,Type,BRCode,BRDesc,IsActive,IsActDesc)
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    
    Quit
}

ClassMethod QryBaseRangeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryBaseRangeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryBaseRangeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryBaseRangeExecute ]
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
/// CreatDate：   2021-04-14
/// Description:  查询分类/项目编码
/// Table：       DHCHAI.MAP.BaseRange
/// Input：       aType:分类编码
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCHAI.MAPS.BaseMappingSrv","QryBMType")
Query QryBMType() As %Query(ROWSPEC = "ind:%String,xType:%String") [ SqlProc ]
{
}

ClassMethod QryBMTypeExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
	
	Set xType=""
 	For {
	 	Set xType=$o(^MA.HAI.DP.CssRangeI("IndexType",xType))
		Quit:xType=""
		Set Type=$tr(xType," ","")
		Set Data=$lb(ind,Type)
	    Set ^CacheTemp(repid,ind)=Data
	    Set ind=ind+1
	}
	Quit $$$OK
}

ClassMethod QryBMTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryBMTypeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryBMTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryBMTypeExecute ]
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
