/// 医呼通设备管理（科室级）
/// 基础数据平台-李可凡
/// 2022-08-21
/// table: CT_HCCSEquipLinkContList
Class web.DHCBL.CT.CTHCCSEquipReceive Extends %RegisteredObject
{

/// 医呼通设备管理，查询已接收的设备
/// 基础数据平台-likefan
/// 2022-08-21
/// input:locid(当前登录科室id，非前台查询项),equipcode(设备编码),equipid(设备ID),usemode(使用模式),user(使用人)
/// table: CT_HCCSEquipLinkContList
/// d ##class(%ResultSet).RunQuery("web.DHCBL.CT.CTHCCSEquipReceive","GetList","","","","","")
Query GetList(rowid As %String, locid As %String, equipcode As %String, equipid As %String, usemode As %String, user As %String) As %Query(ROWSPEC = "ELCLRowId,ELCLEquipmentDR,EQCode,EQId,ELCLAcceptLocationDR,ELCLAcceptTime,ELCLAcceptUserDR,ELCLUseMode,ELCLEquipUserDR")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, locid As %String, equipcode As %String, equipid As %String, usemode As %String, user As %String) As %Status
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
		s ELCLAcceptLocationDR=$p($g(^CT("HCCSELCL",ELCLRowId)),"^",5)	//领用科室DR
		s:ELCLAcceptLocationDR'="" ELCLAcceptLocationDR=$p($g(^CT("HCCSLOC",ELCLAcceptLocationDR)),"^",2)			//科室名
		s ELCLIsAcceptedByLoc=$p($g(^CT("HCCSELCL",ELCLRowId)),"^",8)	//科室是否接收(Y/N)
		s ELCLAcceptTime=$p($g(^CT("HCCSELCL",ELCLRowId)),"^",9)		//设备接收时间 %TimeStamp
		s ELCLAcceptUserDR=$p($g(^CT("HCCSELCL",ELCLRowId)),"^",10)		//设备接收人DR SS_User
		s:ELCLAcceptUserDR'="" ELCLAcceptUserDR=$p($g(^SSU("SSUSR",ELCLAcceptUserDR)),"^",2)		//用户名
		s ELCLUseMode=$p($g(^CT("HCCSELCL",ELCLRowId)),"^",11)			//使用模式（全科共用A、单人专用U）
		s ELCLEquipUserDR=$p($g(^CT("HCCSELCL",ELCLRowId)),"^",12)		//使用人DR 个人通讯录
		s:ELCLEquipUserDR'="" ELCLEquipUserDR=$p($g(^CT("HCCSCL",ELCLEquipUserDR)),"^",6)		//用户名
		
		d OutputRow
	}
	else
	{
		s locid=""	//s locid=1	//测试过滤用
		//转换成大写
		s:equipcode'="" equipcode=$ZCONVERT(equipcode,"U")
		s:equipid'="" equipid=$ZCONVERT(equipid,"U")
		
		s ELCLRowId=0
		for 
		{
			s ELCLRowId=$o(^CT("HCCSELCL",ELCLRowId)) q:ELCLRowId=""
			
			s ELCLEquipmentDR=$p($g(^CT("HCCSELCL",ELCLRowId)),"^",1)		//医呼通设备DR
			s EQCode="",EQId=""
			s:ELCLEquipmentDR'="" EQCode=$p($g(^CT("HCCSEQ",ELCLEquipmentDR)),"^",1)	//设备编码
			s:ELCLEquipmentDR'="" EQId=$p($g(^CT("HCCSEQ",ELCLEquipmentDR)),"^",2)		//设备ID
			s ELCLAcceptLocationDR=$p($g(^CT("HCCSELCL",ELCLRowId)),"^",5)	//领用科室DR
			
			if (locid'="")	//按登录科室过滤
			{
				s CTLOCStr=##class(web.DHCBL.CT.HCCSLocationLinkLoc).GetHISCodeByLocationId(ELCLAcceptLocationDR)
				s continueflag=1
				for i=1:1:$l(CTLOCStr,"^")
				{
					s LocCode=$p(CTLOCStr,"^",i)
					continue:LocCode=""
					s LocId=$o(^CTLOC(0,"Code",$$ALPHAUP^SSUTIL4(LocCode),0))
					continue:LocId=""
					s:LocId=locid continueflag=0
				}
				continue:continueflag=1
			}
			
			s:ELCLAcceptLocationDR'="" ELCLAcceptLocationDR=$p($g(^CT("HCCSLOC",ELCLAcceptLocationDR)),"^",2)			//科室名
			s ELCLIsAcceptedByLoc=$p($g(^CT("HCCSELCL",ELCLRowId)),"^",8)	//科室是否接收(Y/N)
			s ELCLAcceptTime=$p($g(^CT("HCCSELCL",ELCLRowId)),"^",9)		//设备接收时间 %TimeStamp
			s ELCLAcceptUserDR=$p($g(^CT("HCCSELCL",ELCLRowId)),"^",10)		//设备接收人DR SS_User
			s:ELCLAcceptUserDR'="" ELCLAcceptUserDR=$p($g(^SSU("SSUSR",ELCLAcceptUserDR)),"^",2)		//用户名
			s ELCLUseMode=$p($g(^CT("HCCSELCL",ELCLRowId)),"^",11)			//使用模式（全科共用A、单人专用U）
			s ELCLEquipUserDR=$p($g(^CT("HCCSELCL",ELCLRowId)),"^",12)		//使用人DR 个人通讯录
			s TextELCLEquipUserDR=ELCLEquipUserDR
			s:ELCLEquipUserDR'="" ELCLEquipUserDR=$p($g(^CT("HCCSCL",ELCLEquipUserDR)),"^",6)		//用户名
			continue:ELCLIsAcceptedByLoc'="Y"
			
			//根据入参过滤
			if ($ZCONVERT(EQCode,"U")[equipcode)&&($ZCONVERT(EQId,"U")[equipid)&&((usemode="")||(usemode=ELCLUseMode))&&((user="")||(user=TextELCLEquipUserDR))
			{
				d OutputRow
			}
			
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(ELCLRowId,ELCLEquipmentDR,EQCode,EQId,ELCLAcceptLocationDR,ELCLAcceptTime,ELCLAcceptUserDR,ELCLUseMode,ELCLEquipUserDR)
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

/// 查询个人通讯录，提供给下拉框
/// 基础数据平台-likefan
/// 2022-08-21
/// input:locid(当前登录科室id，非前台查询项)
/// table: CT_HCCSContactList
/// Other:d ##class(%ResultSet).RunQuery("web.DHCBL.CT.CTHCCSEquipReceive","GetConForCmb","","")
Query GetConForCmb(rowid As %String, q As %String, locid As %String) As %Query(ROWSPEC = "HCCSCLRowId,HCCSCLUserCode,HCCSCLUserDesc")
{
}

ClassMethod GetConForCmbExecute(ByRef qHandle As %Binary, rowid As %String, q As %String, locid As %String) As %Status
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
		s locid=""	//s locid=1	//测试过滤用
		s:q'="" q=$ZCONVERT(q,"U") //转换成大写
		s HCCSCLRowId=0
		for 
		{
			s HCCSCLRowId=$o(^CT("HCCSCL",HCCSCLRowId)) q:HCCSCLRowId=""
			//s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag(..#SQLTableName,HCCSCLRowId,hospid)
			//continue:showflag="N"
			if (locid'="")	//按登录科室过滤
			{
				s CTLOCCode=$p($g(^CTLOC(locid)),"^",1)        //科室Code
				if (CTLOCCode'="")
				{
					continue:'$d(^CT("HCCSCL",0,"Loc",CTLOCCode,HCCSCLRowId))
				}
			}
			
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

/// 查询可接收的医呼通设备，提供给下拉框
/// 基础数据平台-likefan
/// 2022-08-21
/// input:locid(当前登录科室id，非前台查询项)
/// table: CT_HCCSEquipLinkContList
/// Other:d ##class(%ResultSet).RunQuery("web.DHCBL.CT.CTHCCSEquipReceive","GetEquipForCmb","","","")
Query GetEquipForCmb(rowid As %String, q As %String, locid As %String) As %Query(ROWSPEC = "ELCLRowId,EQCode,EQId")
{
}

ClassMethod GetEquipForCmbExecute(ByRef qHandle As %Binary, rowid As %String, q As %String, locid As %String) As %Status
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
		s ELCLAcceptLocationDR=$p($g(^CT("HCCSELCL",ELCLRowId)),"^",5)	//领用科室DR
		s:ELCLAcceptLocationDR'="" ELCLAcceptLocationDR=$p($g(^CT("HCCSLOC",ELCLAcceptLocationDR)),"^",2)			//科室名
		s ELCLStatus=$p($g(^CT("HCCSELCL",ELCLRowId)),"^",7)			//状态（Y启用，N停用）
		s ELCLIsAcceptedByLoc=$p($g(^CT("HCCSELCL",ELCLRowId)),"^",8)	//科室是否接收(Y/N)
		
		d OutputEquipCmb
	}
	else
	{
		s locid=""	//s locid=1	//测试过滤用
		s:q'="" q=$ZCONVERT(q,"U") //转换成大写
		
		s ELCLRowId=0
		for 
		{
			s ELCLRowId=$o(^CT("HCCSELCL",ELCLRowId)) q:ELCLRowId=""
			
			s ELCLEquipmentDR=$p($g(^CT("HCCSELCL",ELCLRowId)),"^",1)		//医呼通设备DR
			s EQCode="",EQId=""
			s:ELCLEquipmentDR'="" EQCode=$p($g(^CT("HCCSEQ",ELCLEquipmentDR)),"^",1)	//设备编码
			s:ELCLEquipmentDR'="" EQId=$p($g(^CT("HCCSEQ",ELCLEquipmentDR)),"^",2)		//设备ID
			s ELCLAcceptLocationDR=$p($g(^CT("HCCSELCL",ELCLRowId)),"^",5)	//领用科室DR
			if (locid'="")	//按登录科室过滤
			{
				s CTLOCCode=$p($g(^CTLOC(locid)),"^",1)        //科室Code
				s Location=##class(web.DHCBL.CT.HCCSLocationLinkLoc).GetLinkLocationByHISCode(CTLOCCode)	//根据his科室找医呼通科室
				if (Location'="")
				{
					s LocationDR=$p(Location,"^",1)
					continue:ELCLAcceptLocationDR'=LocationDR
				}
			}
			
			s:ELCLAcceptLocationDR'="" ELCLAcceptLocationDR=$p($g(^CT("HCCSLOC",ELCLAcceptLocationDR)),"^",2)			//科室名
			s ELCLStatus=$p($g(^CT("HCCSELCL",ELCLRowId)),"^",7)			//状态（Y启用，N停用）
			s ELCLIsAcceptedByLoc=$p($g(^CT("HCCSELCL",ELCLRowId)),"^",8)	//科室是否接收(Y/N)
			continue:ELCLStatus="N"
			continue:ELCLIsAcceptedByLoc="Y"
			
			//根据入参过滤
			if ($ZCONVERT(EQCode,"U")[q)||($ZCONVERT(EQId,"U")[q)
			{
				d OutputEquipCmb
			}
			
		}
	}
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputEquipCmb
    set Data=$lb(ELCLRowId,EQCode,EQId)
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

/// 批量接收设备（批量将已发放设备置接收）
/// 基础数据平台-likefan
/// 2022-08-21
/// input: 领用科室id, 领用人id, 设备id串(id^id^id)
/// w ##class(web.DHCBL.CT.CTHCCSEquipReceive).ReceiveAll("11^12^13")
ClassMethod ReceiveAll(ids As %String) As %String
{
	q:ids="" ""
	
	s errorflag=0
	for i=1:1:$l(ids,"^")
	{
		s id=$p(ids,"^",i)
		s re=..ReceiveData(id)
		s:(re["success:'false'") errorflag=1	//存在失败数据
	}
	//q:(errorflag=1) "-1"
	q "1"
}

/// 接收设备（将已发放设备置接收）
/// 基础数据平台-likefan
/// 2022-08-21
/// input: 已发放设备id
/// w ##class(web.DHCBL.CT.CTHCCSEquipReceive).ReceiveData("1")
ClassMethod ReceiveData(id As %String) As %String
{
	q:id="" "{success:'false',info:'id is null'"
	s result=""
	
	s obj=##class(User.CTHCCSEquipLinkContList).%OpenId(id)
	s eobj=##class(web.Entity.CT.CTHCCSEquipLinkContList).%New()
	s bobj=##class(web.Entity.CT.CTHCCSEquipLinkContList).%New()
	//老数据
	s bobj.ELCLRowId = id		//rowid
	s bobj.ELCLIsAcceptedByLoc = obj.ELCLIsAcceptedByLoc		//科室是否接收
	s bobj.ELCLAcceptTime = obj.ELCLAcceptTime		//接收时间
	s:obj.ELCLAcceptUserDR'="" bobj.ELCLAcceptUserDR = obj.ELCLAcceptUserDR.%Id()		//接收人
	s bobj.ELCLUseMode = obj.ELCLUseMode		//使用模式
	s:obj.ELCLEquipUserDR'="" bobj.ELCLEquipUserDR = obj.ELCLEquipUserDR.%Id()		//使用人
	//新数据
	s eobj.ELCLRowId = id		//rowid
	s eobj.ELCLIsAcceptedByLoc="Y"		//科室是否接收
	s eobj.ELCLAcceptTime=$zdt($h,3)		//接收时间
	s:$d(%session) eobj.ELCLAcceptUserDR=$Get(%session.Data("LOGON.USERID"))		//接收人
	s:'$d(%session) eobj.ELCLAcceptUserDR=1		//后台保存视为demo
	s eobj.ELCLUseMode=""		//使用模式，发放时清空
	s eobj.ELCLEquipUserDR=""		//使用人，发放时清空
	//保存数据
	s obj.ELCLIsAcceptedByLoc = eobj.ELCLIsAcceptedByLoc		//科室是否接收
	s obj.ELCLAcceptTime = eobj.ELCLAcceptTime		//接收时间
	d obj.ELCLAcceptUserDRSetObjectId(eobj.ELCLAcceptUserDR)	//接收人
	s obj.ELCLUseMode = eobj.ELCLUseMode		//使用模式
	d obj.ELCLEquipUserDRSetObjectId(eobj.ELCLEquipUserDR)	//使用人
	TS
	s sc=obj.%Save()
	if (sc=1)
	{
		TC
		s id=obj.%Id()
		s result="{success:'true',id:'"_id_"'}"
		s AcceptLocation="",Equipment=""
		s:obj.ELCLEquipmentDR'="" Equipment=obj.ELCLEquipmentDR.%Id()	//医呼通设备
		s:obj.ELCLAcceptLocationDR'="" AcceptLocation=obj.ELCLAcceptLocationDR.%Id()	//领用科室
		s:Equipment'="" Equipment=$p($g(^CT("HCCSEQ",Equipment)),"^",1)		//设备编码
		s:AcceptLocation'="" AcceptLocation=$p($g(^CT("HCCSLOC",AcceptLocation)),"^",2)			//领用科室名
		d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_HCCSEquipLinkContList","User.CTHCCSEquipLinkContList","医呼通设备管理",eobj.ELCLRowId,AcceptLocation_"-"_Equipment,"U",eobj,bobj)
	}
	else
	{
		TRO
		s result="{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}" //保存错误日志信息
		s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("医呼通设备管理","web.DHCBL.CT.CTHCCSEquipReceive","ReceiveData",eobj)
  		s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
	}
	q result
}

/// 批量设置共用
/// 基础数据平台-likefan
/// 2022-08-21
/// input: id^id^id...
/// w ##class(web.DHCBL.CT.CTHCCSEquipReceive).ShareAll("11^12^13")
ClassMethod ShareAll(idstr) As %String
{
	q:idstr="" ""
	s errorflag=0
	for i=1:1:$l(idstr,"^")
	{
		s id=$p(idstr,"^",i)
		s re=..ShareData(id)
		s:(re["success:'false'") errorflag=1	//存在失败数据
	}
	//q:(errorflag=1) "-1"
	q "1"
}

/// 将一条已接收的医呼通设备数据设置共用
/// 基础数据平台-likefan
/// 2022-08-21
/// input: id
/// w ##class(web.DHCBL.CT.CTHCCSEquipReceive).ShareData("11")
ClassMethod ShareData(id) As %String
{
	q:id="" "{success:'false',info:'id is null'"
	s result=""
	
	s obj=##class(User.CTHCCSEquipLinkContList).%OpenId(id)
	s eobj=##class(web.Entity.CT.CTHCCSEquipLinkContList).%New()
	s bobj=##class(web.Entity.CT.CTHCCSEquipLinkContList).%New()
	//老数据
	s bobj.ELCLRowId = id		//rowid
	s bobj.ELCLUseMode = obj.ELCLUseMode		//使用模式
	s:obj.ELCLEquipUserDR'="" bobj.ELCLEquipUserDR = obj.ELCLEquipUserDR.%Id()		//使用人
	//新数据
	s eobj.ELCLRowId = id		//rowid
	s eobj.ELCLUseMode="A"		//使用模式
	s bobj.ELCLEquipUserDR=""		//使用人
	//保存数据
	s obj.ELCLUseMode = eobj.ELCLUseMode		//使用模式
	d obj.ELCLEquipUserDRSetObjectId(eobj.ELCLEquipUserDR)	//使用人
	TS
	s sc=obj.%Save()
	if (sc=1)
	{
		TC
		s id=obj.%Id()
		s result="{success:'true',id:'"_id_"'}"
		s AcceptLocation="",Equipment=""
		s:obj.ELCLEquipmentDR'="" Equipment=obj.ELCLEquipmentDR.%Id()	//医呼通设备
		s:obj.ELCLAcceptLocationDR'="" AcceptLocation=obj.ELCLAcceptLocationDR.%Id()	//领用科室
		s:Equipment'="" Equipment=$p($g(^CT("HCCSEQ",Equipment)),"^",1)		//设备编码
		s:AcceptLocation'="" AcceptLocation=$p($g(^CT("HCCSLOC",AcceptLocation)),"^",2)			//领用科室名
		d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_HCCSEquipLinkContList","User.CTHCCSEquipLinkContList","医呼通设备管理",eobj.ELCLRowId,AcceptLocation_"-"_Equipment,"U",eobj,bobj)
	}
	else
	{
		TRO
		s result="{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}" //保存错误日志信息
		s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("医呼通设备管理","web.DHCBL.CT.CTHCCSEquipReceive","ShareData",eobj)
  		s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
	}
	q result
}

/// 批量归还设备
/// 基础数据平台-likefan
/// 2022-08-21
/// input: id^id^id...
/// w ##class(web.DHCBL.CT.CTHCCSEquipReceive).ReturnAll("11^12^13")
ClassMethod ReturnAll(idstr) As %String
{
	q:idstr="" ""
	s errorflag=0
	for i=1:1:$l(idstr,"^")
	{
		s id=$p(idstr,"^",i)
		s re=..ReturnData(id)
		s:(re["success:'false'") errorflag=1	//存在失败数据
	}
	//q:(errorflag=1) "-1"
	q "1"
}

/// 将一条已接收的医呼通设备数据归还
/// 基础数据平台-likefan
/// 2022-08-21
/// input: id
/// w ##class(web.DHCBL.CT.CTHCCSEquipReceive).ReturnData("11")
ClassMethod ReturnData(id) As %String
{
	q:id="" "{success:'false',info:'id is null'"
	s result=""
	
	s obj=##class(User.CTHCCSEquipLinkContList).%OpenId(id)
	s eobj=##class(web.Entity.CT.CTHCCSEquipLinkContList).%New()
	s bobj=##class(web.Entity.CT.CTHCCSEquipLinkContList).%New()
	//老数据
	s bobj.ELCLRowId = id		//rowid
	s bobj.ELCLIsAcceptedByLoc = obj.ELCLIsAcceptedByLoc		//科室是否接收
	//新数据
	s eobj.ELCLRowId = id		//rowid
	s eobj.ELCLIsAcceptedByLoc="N"		//科室是否接收
	//保存数据
	s obj.ELCLIsAcceptedByLoc = eobj.ELCLIsAcceptedByLoc		//科室是否接收
	TS
	s sc=obj.%Save()
	if (sc=1)
	{
		TC
		s id=obj.%Id()
		s result="{success:'true',id:'"_id_"'}"
		s AcceptLocation="",Equipment=""
		s:obj.ELCLEquipmentDR'="" Equipment=obj.ELCLEquipmentDR.%Id()	//医呼通设备
		s:obj.ELCLAcceptLocationDR'="" AcceptLocation=obj.ELCLAcceptLocationDR.%Id()	//领用科室
		s:Equipment'="" Equipment=$p($g(^CT("HCCSEQ",Equipment)),"^",1)		//设备编码
		s:AcceptLocation'="" AcceptLocation=$p($g(^CT("HCCSLOC",AcceptLocation)),"^",2)			//领用科室名
		d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_HCCSEquipLinkContList","User.CTHCCSEquipLinkContList","医呼通设备管理",eobj.ELCLRowId,AcceptLocation_"-"_Equipment,"U",eobj,bobj)
	}
	else
	{
		TRO
		s result="{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}" //保存错误日志信息
		s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("医呼通设备管理","web.DHCBL.CT.CTHCCSEquipReceive","ReturnData",eobj)
  		s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
	}
	q result
}

/// 医呼通设备管理，点击修改查询数据
/// 基础数据平台-likefan
/// 2022-08-21
/// Table：CT_HCCSEquipLinkContList
/// Input：id
/// Others：w ##class(web.DHCBL.CT.CTHCCSEquipReceive).OpenData(11)
ClassMethod OpenData(id As %String) As %String
{
	 s str=""
	 s obj = ##class(User.CTHCCSEquipLinkContList).%OpenId(id)
	 s eobj = ##class(web.Entity.CT.CTHCCSEquipLinkContList).%New()
	 s eobj.ELCLRowId = id
	 s:obj.ELCLEquipmentDR'="" eobj.ELCLEquipmentDR=obj.ELCLEquipmentDR.%Id()	//医呼通设备
	 s:eobj.ELCLEquipmentDR'="" eobj.ELCLEquipmentDR=$p($g(^CT("HCCSEQ",eobj.ELCLEquipmentDR)),"^",1)		//设备编码
	 s eobj.ELCLUseMode = obj.ELCLUseMode	//使用模式
	 s:obj.ELCLEquipUserDR'="" eobj.ELCLEquipUserDR=obj.ELCLEquipUserDR.%Id()	//使用人
	 d obj.%Close()
	 k obj
	 s str = eobj.JsonS()
	 //s str = "{list:["_str_"]}"
	 q str
}

/// 医呼通设备管理，修改时的保存方法
/// 基础数据平台-likefan
/// 2022-08-21
/// table: CT_HCCSEquipLinkContList
/// w ##class(web.DHCBL.CT.CTHCCSEquipReceive).SaveEntity(eobj)
ClassMethod SaveEntity(eobj As web.Entity.CT.CTHCCSEquipLinkContList) As %String
{
	s result=""
	if $IsObject(eobj)&&(eobj.ELCLRowId'="")
	{
		s obj=##class(User.CTHCCSEquipLinkContList).%OpenId(eobj.ELCLRowId)
		s bobj=##class(web.Entity.CT.CTHCCSEquipLinkContList).%New()
		//原数据
		s bobj.ELCLRowId = eobj.ELCLRowId
		s bobj.ELCLUseMode = obj.ELCLUseMode		//使用模式
		s:obj.ELCLEquipUserDR'="" bobj.ELCLEquipUserDR = obj.ELCLEquipUserDR.%Id()		//使用人
		//保存数据
		s obj.ELCLUseMode = eobj.ELCLUseMode		//使用模式
		d obj.ELCLEquipUserDRSetObjectId(eobj.ELCLEquipUserDR)	//使用人
		
		TS
		s sc=obj.%Save()
		if (sc=1)
		{
			TC
			s id=obj.%Id()
			s result="{success:'true',id:'"_id_"'}"
			s AcceptLocation="",Equipment=""
			s:obj.ELCLEquipmentDR'="" Equipment=obj.ELCLEquipmentDR.%Id()	//医呼通设备
			s:obj.ELCLAcceptLocationDR'="" AcceptLocation=obj.ELCLAcceptLocationDR.%Id()	//领用科室
			s:Equipment'="" Equipment=$p($g(^CT("HCCSEQ",Equipment)),"^",1)		//设备编码
			s:AcceptLocation'="" AcceptLocation=$p($g(^CT("HCCSLOC",AcceptLocation)),"^",2)			//领用科室名
			d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_HCCSEquipLinkContList","User.CTHCCSEquipLinkContList","医呼通设备管理",eobj.ELCLRowId,AcceptLocation_"-"_Equipment,"U",eobj,bobj)
		}
		else
		{
			TRO
			s result="{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}" //保存错误日志信息
			s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("医呼通设备管理","web.DHCBL.CT.CTHCCSEquipDistribute","SaveEntity",eobj)
      		s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
		}
		
	}
	else
	{
		s result = "{success:'false',errorinfo:'对象不存在！'}"
	}	
	q result
}

/// Creator：基础数据平台-李可凡
/// CreatDate: 2022-09-13
/// function:通过设备号获取登录人员信息
/// input:设备ID
/// Output:人员信息json数据
/// w ##class(web.DHCBL.CT.CTHCCSEquipReceive).GetContactByEquipID("HMCS01UDU0027")
ClassMethod GetContactByEquipID(equipid) As %String
{
	q:equipid="" ""
	s EquipRowId=$o(^CT("HCCSEQ",0,"Id",equipid,0))
	q:EquipRowId="" ""
	s ELCLRowId=$o(^CT("HCCSELCL",0,"Equipment",EquipRowId,0))
	q:ELCLRowId="" ""
	s ELCLUseMode=$p($g(^CT("HCCSELCL",ELCLRowId)),"^",11)			//使用模式（全科共用A、单人专用U）
	q:ELCLUseMode="" ""
	s result=""
	//b ;1
	if (ELCLUseMode="U")	//单人专用
	{
		s ELCLAcceptLocationDR=$p($g(^CT("HCCSELCL",ELCLRowId)),"^",5)	//领用科室DR
		s ELCLEquipUserDR=$p($g(^CT("HCCSELCL",ELCLRowId)),"^",12)		//使用人DR 个人通讯录
		q:ELCLEquipUserDR="" ""
		s userCode=$p($g(^CT("HCCSCL",ELCLEquipUserDR)),"^",1)		//用户代码
		s userName=$p($g(^CT("HCCSCL",ELCLEquipUserDR)),"^",6)     //用户描述
		s userType=$p($g(^CT("HCCSCL",ELCLEquipUserDR)),"^",9)     //人员分类	(医生D、护士N、其他O、虚拟账户V)
		s userType=$case(userType,"D":"医生","N":"护士","O":"其他","V":"虚拟账户",:"")
		s userVoipNo=$p($g(^CT("HCCSCL",ELCLEquipUserDR)),"^",3)   //VOIP号码
		s userLoc=$p($g(^CT("HCCSCL",ELCLEquipUserDR)),"^",2)		//科室代码
		s result=result_"{""userCode"":"""_userCode_""",""userName"":"""_userName_""",""userType"":"""_userType_""",""userVoipNo"":"""_userVoipNo_""",""userLoc"":"""_userLoc_"""}"
	}
	if (ELCLUseMode="A")	//全科共用
	{
		s ELCLAcceptLocationDR=$p($g(^CT("HCCSELCL",ELCLRowId)),"^",5)	//领用科室DR
		s CTLOCStr=##class(web.DHCBL.CT.HCCSLocationLinkLoc).GetHISCodeByLocationId(ELCLAcceptLocationDR)	//his科室代码1^his科室代码2
		
		for i=1:1:$l(CTLOCStr,"^")
		{
			s userLoc=$p(CTLOCStr,"^",i)
			continue:userLoc=""
			s CTLOCRowId=$o(^CTLOC(0,"Code",$$ALPHAUP^SSUTIL4(userLoc),0))
			continue:CTLOCRowId=""
			
			s HCCSCLRowId=0
			for 
			{
				s HCCSCLRowId=$o(^CT("HCCSCL",0,"Loc",userLoc,HCCSCLRowId)) q:HCCSCLRowId=""
				s userCode=$p($g(^CT("HCCSCL",HCCSCLRowId)),"^",1)     //用户代码
				s userName=$p($g(^CT("HCCSCL",HCCSCLRowId)),"^",6)     //用户描述
				s userType=$p($g(^CT("HCCSCL",HCCSCLRowId)),"^",9)     //人员分类	(医生D、护士N、其他O、虚拟账户V)
				s userType=$case(userType,"D":"医生","N":"护士","O":"其他","V":"虚拟账户",:"")
				s userVoipNo=$p($g(^CT("HCCSCL",HCCSCLRowId)),"^",3)   //VOIP号码
				s HCCSCLDateFrom=$p($g(^CT("HCCSCL",HCCSCLRowId)),"^",4)		//开始日期
				s HCCSCLDateTo=$p($g(^CT("HCCSCL",HCCSCLRowId)),"^",5)		//结束日期
				continue:((HCCSCLDateFrom'="")&&(HCCSCLDateFrom>+$h))
				continue:((HCCSCLDateTo'="")&&(HCCSCLDateTo<+$h))
				
				s:result'="" result=result_","
				s result=result_"{""userCode"":"""_userCode_""",""userName"":"""_userName_""",""userType"":"""_userType_""",""userVoipNo"":"""_userVoipNo_""",""userLoc"":"""_userLoc_"""}"
			}
		}
	}
	s result="{""userList"":["_result_"]}"
	q result
}

}
