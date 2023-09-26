/// 医呼通设备发放
/// 基础数据平台-likefan
/// 2022-08-21
/// table: CT_HCCSEquipLinkContList
Class web.DHCBL.CT.CTHCCSEquipDistribute Extends %RegisteredObject
{

/// 医呼通设备发放
/// 基础数据平台-likefan
/// 2022-08-21
/// table: CT_HCCSEquipLinkContList
/// d ##class(%ResultSet).RunQuery("web.DHCBL.CT.CTHCCSEquipDistribute","GetList","","","","","","","")
Query GetList(rowid As %String, loc As %String, equipcode As %String, equipid As %String, status As %String, hospid As %String, isaccepted As %String) As %Query(ROWSPEC = "ELCLRowId,ELCLEquipmentDR,EQCode,EQId,ELCLContactListDR,ELCLContactListCode,ELCLContactListName,ELCLAcceptLocationDR,ELCLAcceptLocationCode,ELCLAcceptLocationDesc,ELCLDeliverTime,ELCLStatus,ELCLIsAcceptedByLoc,ELCLAcceptTime,ELCLAcceptUserDR,AcceptUserCode,AcceptUserName,ELCLUseMode,ELCLEquipUserDR,ELCLEquipUserCode,ELCLEquipUserName")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, loc As %String, equipcode As %String, equipid As %String, status As %String, hospid As %String, isaccepted As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	if (rowid'="") //根据rowid返回该条记录
	{
		s ELCLRowId = rowid
		
		s ELCLEquipmentDR=$p($g(^CT("HCCSELCL",ELCLRowId)),"^",1)		//医呼通设备DR
		s EQCode="",EQId=""
		s:ELCLEquipmentDR'="" EQCode=$p($g(^CT("HCCSEQ",ELCLEquipmentDR)),"^",1)	//设备编码
		s:ELCLEquipmentDR'="" EQId=$p($g(^CT("HCCSEQ",ELCLEquipmentDR)),"^",2)		//设备ID
		
		s ELCLContactListDR=$p($g(^CT("HCCSELCL",ELCLRowId)),"^",2)		//科室领用人DR
		s ELCLContactListCode="",ELCLContactListName=""
		s:ELCLContactListDR'="" ELCLContactListCode=$p($g(^CT("HCCSCL",ELCLContactListDR)),"^",1)		//用户代码
		s:ELCLContactListDR'="" ELCLContactListName=$p($g(^CT("HCCSCL",ELCLContactListDR)),"^",6)		//用户名
		
		//s ELCLDateFrom = $p($g(^CT("HCCSELCL",ELCLRowId)),"^",3)		//关联开始日期
		//s:ELCLDateFrom'="" ELCLDateFrom=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(ELCLDateFrom)
		//s ELCLDateTo = $p($g(^CT("HCCSELCL",ELCLRowId)),"^",4)		//关联结束日期
		//s:ELCLDateTo'="" ELCLDateTo=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(ELCLDateTo)
		
		s ELCLAcceptLocationDR=$p($g(^CT("HCCSELCL",ELCLRowId)),"^",5)	//领用科室DR
		s ELCLAcceptLocationCode="",ELCLAcceptLocationDesc=""
		s:ELCLAcceptLocationDR'="" ELCLAcceptLocationCode=$p($g(^CT("HCCSLOC",ELCLAcceptLocationDR)),"^",1)			//科室代码
		s:ELCLAcceptLocationDR'="" ELCLAcceptLocationDesc=$p($g(^CT("HCCSLOC",ELCLAcceptLocationDR)),"^",2)			//科室名
		
		s ELCLDeliverTime=$p($g(^CT("HCCSELCL",ELCLRowId)),"^",6)		//发放时间 %TimeStamp
		s ELCLStatus=$p($g(^CT("HCCSELCL",ELCLRowId)),"^",7)			//状态（Y启用，N停用）
		s ELCLIsAcceptedByLoc=$p($g(^CT("HCCSELCL",ELCLRowId)),"^",8)	//科室是否接收(Y/N)
		s ELCLAcceptTime=$p($g(^CT("HCCSELCL",ELCLRowId)),"^",9)		//设备接收时间 %TimeStamp
		
		s ELCLAcceptUserDR=$p($g(^CT("HCCSELCL",ELCLRowId)),"^",10)		//设备接收人DR SS_User
		s AcceptUserCode="",AcceptUserName=""
		s:ELCLAcceptUserDR'="" AcceptUserCode=$p($g(^SSU("SSUSR",ELCLAcceptUserDR)),"^",1)		//用户代码
		s:ELCLAcceptUserDR'="" AcceptUserName=$p($g(^SSU("SSUSR",ELCLAcceptUserDR)),"^",2)		//用户名
		
		s ELCLUseMode=$p($g(^CT("HCCSELCL",ELCLRowId)),"^",11)			//使用模式（全科共用A、单人专用U）
		s ELCLUseMode=$case(ELCLUseMode,"A":"全科共用","U":"单人专用",:ELCLUseMode)
		
		s ELCLEquipUserDR=$p($g(^CT("HCCSELCL",ELCLRowId)),"^",12)		//使用人DR 个人通讯录
		s ELCLEquipUserCode="",ELCLEquipUserName=""
		s:ELCLEquipUserDR'="" ELCLEquipUserCode=$p($g(^CT("HCCSCL",ELCLEquipUserDR)),"^",1)		//用户代码
		s:ELCLEquipUserDR'="" ELCLEquipUserName=$p($g(^CT("HCCSCL",ELCLEquipUserDR)),"^",6)		//用户名
		
		d OutputRow
	}
	else
	{
		//转换成大写
		s:loc'="" loc=$ZCONVERT(loc,"U")
		s:equipcode'="" equipcode=$ZCONVERT(equipcode,"U")
		s:equipid'="" equipid=$ZCONVERT(equipid,"U")
		
		s ELCLRowId=0
		for 
		{
			s ELCLRowId=$o(^CT("HCCSELCL",ELCLRowId)) q:ELCLRowId=""
			
			s ELCLEquipmentDR=$p($g(^CT("HCCSELCL",ELCLRowId)),"^",1)		//医呼通设备DR
			
			s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag("CT_HCCSEquipment",ELCLEquipmentDR,hospid)
			continue:showflag="N"
			
			s EQCode="",EQId=""
			s:ELCLEquipmentDR'="" EQCode=$p($g(^CT("HCCSEQ",ELCLEquipmentDR)),"^",1)	//设备编码
			s:ELCLEquipmentDR'="" EQId=$p($g(^CT("HCCSEQ",ELCLEquipmentDR)),"^",2)		//设备ID
			
			s ELCLContactListDR=$p($g(^CT("HCCSELCL",ELCLRowId)),"^",2)		//科室领用人DR
			s ELCLContactListCode="",ELCLContactListName=""
			s:ELCLContactListDR'="" ELCLContactListCode=$p($g(^CT("HCCSCL",ELCLContactListDR)),"^",1)		//用户代码
			s:ELCLContactListDR'="" ELCLContactListName=$p($g(^CT("HCCSCL",ELCLContactListDR)),"^",6)		//用户名
			
			//s ELCLDateFrom = $p($g(^CT("HCCSELCL",ELCLRowId)),"^",3)		//关联开始日期
			//s:ELCLDateFrom'="" ELCLDateFrom=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(ELCLDateFrom)
			//s ELCLDateTo = $p($g(^CT("HCCSELCL",ELCLRowId)),"^",4)		//关联结束日期
			//s:ELCLDateTo'="" ELCLDateTo=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(ELCLDateTo)
			
			s ELCLAcceptLocationDR=$p($g(^CT("HCCSELCL",ELCLRowId)),"^",5)	//领用科室DR
			s ELCLAcceptLocationCode="",ELCLAcceptLocationDesc=""
			s:ELCLAcceptLocationDR'="" ELCLAcceptLocationCode=$p($g(^CT("HCCSLOC",ELCLAcceptLocationDR)),"^",1)			//科室代码
			s:ELCLAcceptLocationDR'="" ELCLAcceptLocationDesc=$p($g(^CT("HCCSLOC",ELCLAcceptLocationDR)),"^",2)			//科室名
			
			s ELCLDeliverTime=$p($g(^CT("HCCSELCL",ELCLRowId)),"^",6)		//发放时间 %TimeStamp
			s ELCLStatus=$p($g(^CT("HCCSELCL",ELCLRowId)),"^",7)			//状态（Y启用，N停用）
			s ELCLIsAcceptedByLoc=$p($g(^CT("HCCSELCL",ELCLRowId)),"^",8)	//科室是否接收(Y/N)
			s ELCLAcceptTime=$p($g(^CT("HCCSELCL",ELCLRowId)),"^",9)		//设备接收时间 %TimeStamp
			
			s ELCLAcceptUserDR=$p($g(^CT("HCCSELCL",ELCLRowId)),"^",10)		//设备接收人DR SS_User
			s AcceptUserCode="",AcceptUserName=""
			s:ELCLAcceptUserDR'="" AcceptUserCode=$p($g(^SSU("SSUSR",ELCLAcceptUserDR)),"^",1)		//用户代码
			s:ELCLAcceptUserDR'="" AcceptUserName=$p($g(^SSU("SSUSR",ELCLAcceptUserDR)),"^",2)		//用户名
			
			s ELCLUseMode=$p($g(^CT("HCCSELCL",ELCLRowId)),"^",11)			//使用模式（全科共用A、单人专用U）
			s ELCLUseMode=$case(ELCLUseMode,"A":"全科共用","U":"单人专用",:ELCLUseMode)
			
			s ELCLEquipUserDR=$p($g(^CT("HCCSELCL",ELCLRowId)),"^",12)		//使用人DR 个人通讯录
			s ELCLEquipUserCode="",ELCLEquipUserName=""
			s:ELCLEquipUserDR'="" ELCLEquipUserCode=$p($g(^CT("HCCSCL",ELCLEquipUserDR)),"^",1)		//用户代码
			s:ELCLEquipUserDR'="" ELCLEquipUserName=$p($g(^CT("HCCSCL",ELCLEquipUserDR)),"^",6)		//用户名
			
			//根据入参过滤
			if (($ZCONVERT(ELCLAcceptLocationCode,"U")[loc)||($ZCONVERT(ELCLAcceptLocationDesc,"U")[loc))&&($ZCONVERT(EQCode,"U")[equipcode)&&($ZCONVERT(EQId,"U")[equipid)&&((status="")||(status=ELCLStatus))&&((isaccepted="")||(isaccepted=ELCLIsAcceptedByLoc))
			{
				d OutputRow
			}
			
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(ELCLRowId,ELCLEquipmentDR,EQCode,EQId,ELCLContactListDR,ELCLContactListCode,ELCLContactListName,ELCLAcceptLocationDR,ELCLAcceptLocationCode,ELCLAcceptLocationDesc,ELCLDeliverTime,ELCLStatus,ELCLIsAcceptedByLoc,ELCLAcceptTime,ELCLAcceptUserDR,AcceptUserCode,AcceptUserName,ELCLUseMode,ELCLEquipUserDR,ELCLEquipUserCode,ELCLEquipUserName)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	
	Set ind=$o(^CacheTemp(repid,ind))
	If ind=""
	{
		//if there are no more rows,finish fetching...
		Set AtEnd=1
		Set Row=""
	}
	Else
	{
		Set Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// 查询医呼通科室，提供给下拉框
/// 基础数据平台-likefan
/// 2022-08-21
/// table: CT_HCCSLocation
/// Other:d ##class(%ResultSet).RunQuery("web.DHCBL.CT.CTHCCSEquipDistribute","GetLocForCmb","","")
Query GetLocForCmb(rowid As %String, q As %String, hospid As %String) As %Query(ROWSPEC = "LOCRowId,LOCCode,LOCDesc")
{
}

ClassMethod GetLocForCmbExecute(ByRef qHandle As %Binary, rowid As %String, q As %String, hospid As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	if (rowid'="")
	{
		s LOCRowId=rowid
		s LOCCode=$p($g(^CT("HCCSLOC",LOCRowId)),"^",1)			//科室代码
		s LOCDesc=$p($g(^CT("HCCSLOC",LOCRowId)),"^",2)			//科室名
		s LOCDesc=LOCCode_"-"_LOCDesc
		d OutputLocCmb
	}
	else
	{
		s:q'="" q=$ZCONVERT(q,"U")
		s LOCRowId=0
		for
		{
			s LOCRowId=$o(^CT("HCCSLOC",LOCRowId)) q:LOCRowId=""
			s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag("CT_HCCSLocation",LOCRowId,hospid)
			continue:showflag="N"
			s LOCCode=$p($g(^CT("HCCSLOC",LOCRowId)),"^",1)			//科室代码
			s LOCDesc=$p($g(^CT("HCCSLOC",LOCRowId)),"^",2)			//科室名
			s LOCDesc=LOCCode_"-"_LOCDesc
			s LOCDateFrom=$p($g(^CT("HCCSLOC",LOCRowId)),"^",3)		//开始日期
			s LOCDateTo=$p($g(^CT("HCCSLOC",LOCRowId)),"^",4)		//结束日期
			continue:(LOCDateFrom'="")&&(LOCDateFrom>+$h)
			continue:(LOCDateTo'="")&&(LOCDateTo<+$h)
			s PINYINDesc=""
			s:q'="" PINYINDesc=##class(web.DHCBL.BDP.FunLib).GetPYCODE(LOCDesc)
			if ($ZCONVERT(LOCCode,"U")[q)||($ZCONVERT(LOCDesc,"U")[q)||(PINYINDesc[q)
			{
				d OutputLocCmb
			}
		}
	}
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputLocCmb
    set Data=$lb(LOCRowId,LOCCode,LOCDesc)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetLocForCmbClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetLocForCmbExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetLocForCmbFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetLocForCmbExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	
	Set ind=$o(^CacheTemp(repid,ind))
	If ind=""
	{
		//if there are no more rows,finish fetching...
		Set AtEnd=1
		Set Row=""
	}
	Else
	{
		Set Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// 查询个人通讯录，提供给下拉框
/// 基础数据平台-likefan
/// 2022-08-21
/// table: CT_HCCSContactList
/// Other:d ##class(%ResultSet).RunQuery("web.DHCBL.CT.CTHCCSEquipDistribute","GetConForCmb","","")
Query GetConForCmb(rowid As %String, q As %String, hospid As %String) As %Query(ROWSPEC = "HCCSCLRowId,HCCSCLUserCode,HCCSCLUserDesc")
{
}

ClassMethod GetConForCmbExecute(ByRef qHandle As %Binary, rowid As %String, q As %String, hospid As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	if (rowid'="") //根据rowid返回该条记录
	{
		s HCCSCLRowId = rowid
		s HCCSCLUserCode=$p($g(^CT("HCCSCL",HCCSCLRowId)),"^",1)	//用户代码
		s HCCSCLUserDesc=$p($g(^CT("HCCSCL",HCCSCLRowId)),"^",6)	//用户描述
		s HCCSCLUserDesc=HCCSCLUserCode_"-"_HCCSCLUserDesc
		d OutputConCmb
	}
	else
	{
		
		s:q'="" q=$ZCONVERT(q,"U") //转换成大写
		s HCCSCLRowId=0
		for 
		{
			s HCCSCLRowId=$o(^CT("HCCSCL",HCCSCLRowId)) q:HCCSCLRowId=""
			s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag("CT_HCCSContactList",HCCSCLRowId,hospid)
			continue:showflag="N"
			s HCCSCLUserCode=$p($g(^CT("HCCSCL",HCCSCLRowId)),"^",1)	//用户代码
			s HCCSCLUserDesc=$p($g(^CT("HCCSCL",HCCSCLRowId)),"^",6)	//用户描述
			s HCCSCLUserDesc=HCCSCLUserCode_"-"_HCCSCLUserDesc
			s HCCSCLDateFrom=$p($g(^CT("HCCSCL",HCCSCLRowId)),"^",4)	//开始日期
			s HCCSCLDateTo=$p($g(^CT("HCCSCL",HCCSCLRowId)),"^",5)		//结束日期
			continue:(HCCSCLDateFrom'="")&&(HCCSCLDateFrom>+$h)
			continue:(HCCSCLDateTo'="")&&(HCCSCLDateTo<+$h)
			s PINYINDesc=""
			s:q'="" PINYINDesc=##class(web.DHCBL.BDP.FunLib).GetPYCODE(HCCSCLUserDesc)
			if ($ZCONVERT(HCCSCLUserCode,"U")[q)||($ZCONVERT(HCCSCLUserDesc,"U")[q)||(PINYINDesc[q)
			{
				d OutputConCmb
			}
		}
	}
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputConCmb
    set Data=$lb(HCCSCLRowId,HCCSCLUserCode,HCCSCLUserDesc)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetConForCmbClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetConForCmbExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetConForCmbFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetConForCmbExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	
	Set ind=$o(^CacheTemp(repid,ind))
	If ind=""
	{
		//if there are no more rows,finish fetching...
		Set AtEnd=1
		Set Row=""
	}
	Else
	{
		Set Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// 查询医呼通设备，提供给下拉框
/// 基础数据平台-likefan
/// 2022-08-21
/// table: CT_HCCSEquipment
/// Other:d ##class(%ResultSet).RunQuery("web.DHCBL.CT.CTHCCSEquipDistribute","GetEquipForCmb","","")
Query GetEquipForCmb(rowid As %String, q As %String, hospid As %String) As %Query(ROWSPEC = "EQRowId,EQCode,EQId")
{
}

ClassMethod GetEquipForCmbExecute(ByRef qHandle As %Binary, rowid As %String, q As %String, hospid As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	if (rowid'="")
	{
		s EQRowId=rowid
		s EQCode=$p($g(^CT("HCCSEQ",EQRowId)),"^",1)			//设备编码
		s EQId=$p($g(^CT("HCCSEQ",EQRowId)),"^",2)				//设备ID
		d OutputEquipCmb
	}
	else
	{
		s:q'="" q=$ZCONVERT(q,"U")
		s EQRowId=0
		for
		{
			s EQRowId=$o(^CT("HCCSEQ",EQRowId)) q:EQRowId=""
			s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag("CT_HCCSEquipment",EQRowId,hospid)
			continue:showflag="N"
			
			//下拉设备框只显示未发放的设备	2022-12-13
			if $d(^CT("HCCSELCL",0,"Equipment",EQRowId))
			{
				s ELCLRowId=$o(^CT("HCCSELCL",0,"Equipment",EQRowId,0))
				s ELCLStatus=$p($g(^CT("HCCSELCL",ELCLRowId)),"^",7)			//状态（Y启用，N停用）
				continue:ELCLStatus'="N"
			}
			
			s EQCode=$p($g(^CT("HCCSEQ",EQRowId)),"^",1)			//设备编码
			s EQId=$p($g(^CT("HCCSEQ",EQRowId)),"^",2)				//设备ID
			s EQActiveFlag=$p($g(^CT("HCCSEQ",EQRowId)),"^",3)		//是否启用
			continue:EQActiveFlag="N"
			if ($ZCONVERT(EQCode,"U")[q)||($ZCONVERT(EQId,"U")[q)
			{
				d OutputEquipCmb
			}
		}
	}
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputEquipCmb
    set Data=$lb(EQRowId,EQCode,EQId)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetEquipForCmbClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetEquipForCmbExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetEquipForCmbFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetEquipForCmbExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	
	Set ind=$o(^CacheTemp(repid,ind))
	If ind=""
	{
		//if there are no more rows,finish fetching...
		Set AtEnd=1
		Set Row=""
	}
	Else
	{
		Set Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// 医呼通设备发放，删除方法
/// 基础数据平台-likefan
/// 2022-08-21
/// table: CT_HCCSEquipLinkContList
/// Input：id
/// w ##class(web.DHCBL.CT.CTHCCSEquipDistribute).DeleteData("")
ClassMethod DeleteData(id) As %String
{
	s result=""
	s pobj = ##class(User.CTHCCSEquipLinkContList).%OpenId(id)
	s eobj = ##class(web.Entity.CT.CTHCCSEquipLinkContList).%New()
	
	s:pobj.ELCLEquipmentDR'="" eobj.ELCLEquipmentDR = pobj.ELCLEquipmentDR.%Id()	//医呼通设备
	s:pobj.ELCLContactListDR'="" eobj.ELCLContactListDR = pobj.ELCLContactListDR.%Id()	//科室领用人
	s eobj.ELCLDateFrom = pobj.ELCLDateFrom		//关联开始日期
	s eobj.ELCLDateTo = pobj.ELCLDateTo			//关联结束日期
	s:pobj.ELCLAcceptLocationDR'="" eobj.ELCLAcceptLocationDR = pobj.ELCLAcceptLocationDR.%Id()	//领用科室
	s eobj.ELCLDeliverTime = pobj.ELCLDeliverTime		//发放时间
	s eobj.ELCLStatus = pobj.ELCLStatus		//状态
	s eobj.ELCLIsAcceptedByLoc = pobj.ELCLIsAcceptedByLoc		//科室是否接收
	s eobj.ELCLAcceptTime = pobj.ELCLAcceptTime		//设备接收时间
	s:pobj.ELCLAcceptUserDR'="" eobj.ELCLAcceptUserDR = pobj.ELCLAcceptUserDR.%Id()	//设备接收人
	s eobj.ELCLUseMode = pobj.ELCLUseMode		//使用模式
	s:pobj.ELCLEquipUserDR'="" eobj.ELCLEquipUserDR = pobj.ELCLEquipUserDR.%Id()	//使用人
	
	d pobj.%Close()
	k pobj
	Ts
	s sc=##class(User.CTHCCSEquipLinkContList).%DeleteId(id)
	IF $$$ISOK(sc){
		Tc
		s result="{success:'true',info:'删除成功！'}"
		s HCCSCLUserCode="",EQId=""
		s:eobj.ELCLContactListDR'="" HCCSCLUserCode=$p($g(^CT("HCCSCL",eobj.ELCLContactListDR)),"^",1)     //用户代码
		s:eobj.ELCLEquipmentDR'="" EQId=$p($g(^CT("HCCSEQ",eobj.ELCLEquipmentDR)),"^",2)		//设备ID
		d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_HCCSEquipLinkContList","User.CTHCCSEquipLinkContList","医呼通设备发放",id,HCCSCLUserCode_"-"_EQId,"D",eobj)
	}
	else{
		Tro
		s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("医呼通设备发放","web.DHCBL.CT.CTHCCSEquipDistribute","DeleteData",eobj)
		s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
		s result= "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
	}
	q result
}

/// 批量新增发放设备到科室
/// 基础数据平台-likefan
/// 2022-08-21
/// input: 领用科室id, 领用人id, 设备id串(id^id^id)
/// w ##class(web.DHCBL.CT.CTHCCSEquipDistribute).AddData("1","1","1^2^3")
ClassMethod AddData(locid As %String, contactid As %String, equipids As %String) As %String
{
	q:locid="" ""
	q:contactid="" ""
	q:equipids="" ""
	
	s errorflag=0
	for i=1:1:$l(equipids,"^")
	{
		s equipid=$p(equipids,"^",i)
		s eobj=##class(web.Entity.CT.CTHCCSEquipLinkContList).%New()
	    s eobj.ELCLEquipmentDR=equipid			//医呼通设备
		s eobj.ELCLContactListDR=contactid		//科室领用人
		s eobj.ELCLAcceptLocationDR=locid		//领用科室
		s eobj.ELCLDeliverTime=$zdt($h,3)		//发放时间，默认当天
		s eobj.ELCLStatus="Y"					//状态，默认Y
		s eobj.ELCLIsAcceptedByLoc="N"			//科室是否接收，默认N
		s re=..SaveEntity(eobj)
		s:(re["success:'false'") errorflag=1	//存在失败数据
	}
	//q:(errorflag=1) "-1"
	q "1"
}

/// 医呼通设备发放，保存方法
/// 基础数据平台-likefan
/// 2022-08-21
/// table: CT_HCCSEquipLinkContList
/// w ##class(web.DHCBL.CT.CTHCCSEquipDistribute).SaveEntity(eobj)
ClassMethod SaveEntity(eobj As web.Entity.CT.CTHCCSEquipLinkContList) As %String
{
	s result=""
	if $IsObject(eobj)
	{
		s flag=..FormValidate(eobj.ELCLRowId,eobj.ELCLEquipmentDR)
		if flag=1
		{
			q "{success:'false',errorinfo:'数据已存在！'}"
		}
		if (eobj.ELCLRowId="")
		{
			s obj=##class(User.CTHCCSEquipLinkContList).%New()
		}
		else
		{
			s obj=##class(User.CTHCCSEquipLinkContList).%OpenId(eobj.ELCLRowId)
			s bobj=##class(web.Entity.CT.CTHCCSEquipLinkContList).%New()
			
			s:obj.ELCLEquipmentDR'="" bobj.ELCLEquipmentDR = obj.ELCLEquipmentDR.%Id()	//医呼通设备
			s:obj.ELCLContactListDR'="" bobj.ELCLContactListDR = obj.ELCLContactListDR.%Id()	//科室领用人
			s:obj.ELCLAcceptLocationDR'="" bobj.ELCLAcceptLocationDR = obj.ELCLAcceptLocationDR.%Id()	//领用科室
			s bobj.ELCLDeliverTime = obj.ELCLDeliverTime		//发放时间
			s bobj.ELCLStatus = obj.ELCLStatus		//状态
			s bobj.ELCLIsAcceptedByLoc = obj.ELCLIsAcceptedByLoc		//科室是否接收
		}
		d obj.ELCLEquipmentDRSetObjectId(eobj.ELCLEquipmentDR)		//医呼通设备
		d obj.ELCLContactListDRSetObjectId(eobj.ELCLContactListDR)	//个人通讯录
		d obj.ELCLAcceptLocationDRSetObjectId(eobj.ELCLAcceptLocationDR)	//领用科室
		s obj.ELCLDeliverTime = eobj.ELCLDeliverTime		//发放时间
		s obj.ELCLStatus = eobj.ELCLStatus		//状态
		s obj.ELCLIsAcceptedByLoc = eobj.ELCLIsAcceptedByLoc		//科室是否接收
		
		TS
		s sc=obj.%Save()
		if (sc=1)
		{
			TC
			s id=obj.%Id()
			s result="{success:'true',id:'"_id_"'}"
			s HCCSCLUserCode="",EQId=""
			s:eobj.ELCLContactListDR'="" HCCSCLUserCode=$p($g(^CT("HCCSCL",eobj.ELCLContactListDR)),"^",1)     //用户代码
			s:eobj.ELCLEquipmentDR'="" EQId=$p($g(^CT("HCCSEQ",eobj.ELCLEquipmentDR)),"^",2)		//设备ID
			d:eobj.ELCLRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_HCCSEquipLinkContList","User.CTHCCSEquipLinkContList","医呼通设备发放",eobj.ELCLRowId,HCCSCLUserCode_"-"_EQId,"U",eobj,bobj)
    		d:eobj.ELCLRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_HCCSEquipLinkContList","User.CTHCCSEquipLinkContList","医呼通设备发放",id,HCCSCLUserCode_"-"_EQId,"A",eobj)
		}
		else
		{
			TRO
			s result="{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}" //保存错误日志信息
			s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("医呼通设备发放","web.DHCBL.CT.CTHCCSEquipDistribute","SaveEntity",eobj)
      		s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
		}
		
	}
	else
	{
		s result = "{success:'false',errorinfo:'对象不存在！'}"
	}	
	q result
}

/// 校验设备id串是否有重复数据
/// 基础数据平台-likefan
/// 2022-08-21
/// Input: 设备id串
/// Return:1 有重复	0 不无重复
/// Other:w ##class(web.DHCBL.CT.CTHCCSEquipDistribute).IsValidate("3^4^5")
ClassMethod IsValidate(equipids As %String) As %String
{
	q:equipids="" ""
	s flag=0
	
	for i=1:1:$l(equipids,"^")
	{
		s equipid=$p(equipids,"^",i)
		s re=..FormValidate("",equipid)
		if (re=1)
		{
			s flag=1
			q
		}
	}
	q flag
}

/// 重复校验 一个设备，只能有一条状态为启用的数据
/// 基础数据平台-likefan
/// 2022-08-21
/// Input: rowid, 设备id
/// Return:1 重复	0 不重复
/// Other:w ##class(web.DHCBL.CT.CTHCCSEquipDistribute).FormValidate("","3")
ClassMethod FormValidate(rowid As %String, equipid As %String) As %String
{
	q:equipid="" ""
	s flag=0
	
	s ELCLRowId=0
	for
	{
		s ELCLRowId=$o(^CT("HCCSELCL",0,"Equipment",equipid,ELCLRowId)) q:ELCLRowId=""
		s ELCLStatus=$p($g(^CT("HCCSELCL",ELCLRowId)),"^",7)			//状态
		s:(ELCLStatus="Y")&&(ELCLRowId'=rowid) flag=1
	}
	
	q flag
}

/// 截止一条医呼通设备发放数据
/// 基础数据平台-likefan
/// 2022-08-21
/// input: id
/// w ##class(web.DHCBL.CT.CTHCCSEquipDistribute).EndData("4")
ClassMethod EndData(id) As %String
{
	q:id="" "{success:'false',info:'id is null'"
	s result=""
	
	s obj=##class(User.CTHCCSEquipLinkContList).%OpenId(id)
	s eobj=##class(web.Entity.CT.CTHCCSEquipLinkContList).%New()
	s bobj=##class(web.Entity.CT.CTHCCSEquipLinkContList).%New()
	//老数据
	s bobj.ELCLRowId=id
	s:obj.ELCLEquipmentDR'="" bobj.ELCLEquipmentDR = obj.ELCLEquipmentDR.%Id()	//医呼通设备
	s:obj.ELCLContactListDR'="" bobj.ELCLContactListDR = obj.ELCLContactListDR.%Id()	//科室领用人
	s bobj.ELCLStatus = obj.ELCLStatus		//状态
	//新数据
	s eobj.ELCLRowId=id
	s:obj.ELCLEquipmentDR'="" eobj.ELCLEquipmentDR = obj.ELCLEquipmentDR.%Id()	//医呼通设备
	s:obj.ELCLContactListDR'="" eobj.ELCLContactListDR = obj.ELCLContactListDR.%Id()	//科室领用人
	s eobj.ELCLStatus = "N"		//状态
	//保存数据
	s obj.ELCLStatus = eobj.ELCLStatus		//状态
	
	TS
	s sc=obj.%Save()
	if (sc=1)
	{
		TC
		s id=obj.%Id()
		s result="{success:'true',id:'"_id_"'}"
		s HCCSCLUserCode="",EQId=""
		s:eobj.ELCLContactListDR'="" HCCSCLUserCode=$p($g(^CT("HCCSCL",eobj.ELCLContactListDR)),"^",1)     //用户代码
		s:eobj.ELCLEquipmentDR'="" EQId=$p($g(^CT("HCCSEQ",eobj.ELCLEquipmentDR)),"^",2)		//设备ID
		d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_HCCSEquipLinkContList","User.CTHCCSEquipLinkContList","医呼通设备发放",id,HCCSCLUserCode_"-"_EQId,"U",eobj,bobj)
	}
	else
	{
		TRO
		s result="{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}" //保存错误日志信息
		s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("医呼通设备发放","web.DHCBL.CT.CTHCCSEquipDistribute","SaveEntity",eobj)
  		s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
	}
	q result
}

/// 批量截止医呼通设备发放数据
/// 基础数据平台-likefan
/// 2022-08-21
/// input: id^id^id...
/// w ##class(web.DHCBL.CT.CTHCCSEquipDistribute).EndAll("2^3^4")
ClassMethod EndAll(idstr) As %String
{
	q:idstr="" ""
	s errorflag=0
	for i=1:1:$l(idstr,"^")
	{
		s id=$p(idstr,"^",i)
		s re=..EndData(id)
		s:(re["success:'false'") errorflag=1	//存在失败数据
	}
	q:(errorflag=0) "1"
	q:(errorflag=1) "-1"
	q ""
}

/// 批量删除医呼通设备发放数据
/// 基础数据平台-likefan
/// 2022-08-21
/// input: id^id^id...
/// w ##class(web.DHCBL.CT.CTHCCSEquipDistribute).DeleteAll("3^4")
ClassMethod DeleteAll(idstr) As %String
{
	q:idstr="" ""
	s errorflag=0
	for i=1:1:$l(idstr,"^")
	{
		s id=$p(idstr,"^",i)
		s re=..DeleteData(id)
		s:(re["success:'false'") errorflag=1	//存在失败数据
	}
	q:(errorflag=0) "0"
	q:(errorflag=1) "-1"
	q ""
}

/// 停用时，判断设备是否已归还
/// 基础数据平台-likefan
/// 2023-02-10
/// input: id^id^id...
/// output: 0 都归还了	1 还有没归还的，不许停用
/// w ##class(web.DHCBL.CT.CTHCCSEquipDistribute).EndAllCheck("2^3^4")
ClassMethod EndAllCheck(idstr) As %String
{
	q:idstr="" ""
	s errorflag=0
	for i=1:1:$l(idstr,"^")
	{
		s id=$p(idstr,"^",i)
		s ELCLIsAcceptedByLoc=$p($g(^CT("HCCSELCL",id)),"^",8)	//科室是否接收(Y/N)
		if (ELCLIsAcceptedByLoc="Y")
		{
			s errorflag=1
			q
		}
	}
	q errorflag
}

}
