/// add by ZY0208 2020-02-27
Class web.DHCEQ.BA.BUSDeviceMap Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// d ##class(%ResultSet).RunQuery("web.DHCEQ.BA.BUSDeviceMap","GetDeviceMap","")
Query GetDeviceMap(EquipDR As %String = "") As %Query(ROWSPEC = "DMRowID:%String,DMDeviceSource:%String,DMDeviceID:%String,DMDeviceDesc:%String,DMRemark:%String")
{
}

ClassMethod GetDeviceMapExecute(ByRef qHandle As %Binary, EquipDR As %String = "") As %Status
{
	new repid, index, rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	i EquipDR="" Quit $$$OK
	s DeviceSource=0
	f  s DeviceSource=$o(^DHCEQDeviceMap(0,"Equip",EquipDR,DeviceSource))  quit:DeviceSource=""  d
	.s rowid=0
	.f  s rowid=$o(^DHCEQDeviceMap(0,"Equip",EquipDR,DeviceSource,rowid))  quit:rowid=""  d
	..s (DMRowID,DMDeviceSource,DMDeviceID,DMDeviceDesc,DMRemark)=""
	..s DMRowID = rowid
	..q:$p($g(^DHCEQDeviceMap(rowid)),"^",5)="Y"
	..s DMDeviceSource=DeviceSource
	..s DMDeviceID=$p($g(^DHCEQDeviceMap(rowid)),"^",3)
	..s DMRemark=$p($g(^DHCEQDeviceMap(rowid)),"^",4)
	..s DMDeviceDesc=$p($g(^DHCEQDeviceMap(rowid)),"^",6)
	..d OutputRowGetDeviceMap
	Quit $$$OK
OutputRowGetDeviceMap
	s Data=$lb(DMRowID,DMDeviceSource,DMDeviceID,DMDeviceDesc,DMRemark)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
}

ClassMethod GetDeviceMapFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDeviceMapExecute ]
{
	
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 		}
 	Else      {
 		Set Row=^CacheTemp(repid,ind)
 		}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetDeviceMapClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDeviceMapExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// d ##class(%ResultSet).RunQuery("web.DHCEQ.BA.BUSDeviceMap","DeviceSource","2")
Query DeviceSource(type As %String = "2") As %Query(ROWSPEC = "DeviceSource:%String") [ SqlProc ]
{
}

ClassMethod DeviceSourceExecute(ByRef qHandle As %Binary, type) As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s DeviceSource=""
	s No=1
	do
	{
		s DeviceSource=##Class(web.DHCEQCommon).GetInterfaceInfo(No,type)
		s No=No+1
		i (DeviceSource'=-1)&&(DeviceSource'="")
		{
			d OutputRowGetDeviceSource
		}
	}while(DeviceSource'=-1)
	Quit $$$OK
OutputRowGetDeviceSource
   s Data=$lb(DeviceSource)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
}

ClassMethod DeviceSourceFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = DeviceSourceExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 		}
 	Else      {
 		Set Row=^CacheTemp(repid,ind)
 		}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod DeviceSourceClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = DeviceSourceExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// d ##class(%ResultSet).RunQuery("web.DHCEQ.BA.BUSDeviceMap","Device","","DHC-RIS")
Query Device(DeviceDesc As %String = "", DeviceSourceDR As %String = "") As %Query(ROWSPEC = "Name:%String,RowID:%String") [ SqlProc ]
{
}

ClassMethod DeviceExecute(ByRef qHandle As %Binary, DeviceDesc As %String = "", DeviceSourceDR As %String = "") As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s rowid=0
	s rowid1=0
	if (DeviceSourceDR="DHC-LIS")	
	{d BuildDataLabDevice}
	elseif(DeviceSourceDR="DHC-RIS")
	//add by zy 2014-11-04 ZY0143  ris4.0借口设备对照取pacs新设备表的数据
	//{d BuildDataMedDevice}
	{d BuildDataPACSDevice}
	elseif(DeviceSourceDR="锐珂Pacs")	;add by zy 2011-11-11 ZY0085 地坛锐珂Pacs
	{d BuildDataPacsDevice}
	elseif(DeviceSourceDR="KY-RIS")		;卡易RIS	Add By DJ 2017-07-21 龙岩二院
	{d BuildDataKYRISDevice}
	elseif(DeviceSourceDR="Pacs")	;add by zy 2017-02-24
	{d BuildDataThirdDevice}
	
	Quit $$$OK
BuildDataMedDevice //RBC_Equipment
	f  s rowid=$o(^RBC("EQ",rowid))  quit:rowid=""  d
	.d ResetVariablesGetDevice
	.s LTRowID = rowid	//rowid
	.s LName=$p($g(^RBC("EQ",rowid)),"^",2)
	.q:(DeviceDesc'="")&&(LName'[DeviceDesc)
	.d OutputRowGetDevice
	quit
BuildDataLabDevice
#;	//老版检验
#;	f  s rowid=$o(^TMIF(rowid))  quit:rowid=""  d
#;	.d ResetVariablesGetDevice
#;	.s LTRowID = rowid	//rowid
#;	.s LName=$p($g(^TMIF(rowid)),"\",1)
#;	.q:(DeviceDesc'="")&&(LName'[DeviceDesc)
#;	.d OutputRowGetDevice
#;	quit
	//新版检验
	f  s rowid=$o(^dbo.BTMIMachineParameterD(rowid)) q:rowid=""  d
	.s strData=$g(^dbo.BTMIMachineParameterD(rowid))
	.s LName=$lg(strData,5)
	.s Sname=$lg(strData,3)
	.s LTRowID = rowid
	.;q:$lg(strData,24)'=1
	.q:(DeviceDesc'="")&&(LName'[DeviceDesc)
	.d OutputRowGetDevice
	quit
BuildDataPacsDevice
	;...
	quit
	//add by zy 2014-11-04 ZY0143 ris4.0借口设备对照取pacs新设备表的数据
BuildDataPACSDevice //MODALITY
	zn "DHC-PACS"	//modify by wl 2020-03-05 WL0057 
	s Code=0
	f  s Code=$o(^User.MODALITYI("MDLCODEIndex",Code))  quit:Code=""  d
	.s rowid=0
	.f  s rowid=$o(^User.MODALITYI("MDLCODEIndex",Code,rowid))  quit:rowid=""  d
	..s DataList=$g(^User.MODALITYD(rowid))
	..d ResetVariablesGetDevice
	..;s LTRowID = rowid	//rowid
	..s LTRowID=$LIST(DataList,7)
	..s LName=$LIST(DataList,5)
	..q:(DeviceDesc'="")&&(LName'[DeviceDesc)
	..zn "DHC-APP"
	..d OutputRowGetDevice
	..zn "DHC-PACS"	//modify by wl 2020-03-05 WL0057 
	zn "DHC-APP"
	quit
BuildDataKYRISDevice
	;卡易RIS
	s objService=##class(web.DHCEQ.Interface.Outer.HistorySearchWebServiceSoap).%New()
	s objDataSet=objService.DHCEQIDevice()	
	s reader = ##class(%XML.Reader).%New()
	s sc=reader.OpenStream(objDataSet)
	d reader.Correlate("DHC_EQIDevice","web.DHCEQ.Interface.OuterTableProperty.DHCEQIDeviceProperty")
	while(reader.Next(.object,.sc))
	{
		s LName=object.DDeviceDesc
		q:(DeviceDesc'="")&&(LName'[DeviceDesc)
		s LTRowID=object.DDeviceID
		d OutputRowGetDevice
	}
	quit
	//add by zy 2017-02-24  zy0160  增加仪器中间表
BuildDataThirdDevice
	s DeviceID=0
	f  s DeviceID=$o(^DHCEQDevice(0,"SysName",DeviceSourceDR,DeviceID))  quit:DeviceID=""  d
	.s rowid=0
	.f  s rowid=$o(^DHCEQDevice(0,"SysName",DeviceSourceDR,DeviceID,rowid))  quit:rowid=""  d
	..d ResetVariablesGetDevice
	..q:$p($g(^DHCEQDevice(rowid)),"^",7)="Y"
	..;s LTRowID =$p($g(^DHCEQDevice(rowid)),"^",3)	//rowid
	..s LTRowID =$p($g(^DHCEQDevice(rowid)),"^",4)	//rowid
	..s LName=$p($g(^DHCEQDevice(rowid)),"^",4)
	..q:LName=""
	..q:(DeviceDesc'="")&&(LName'[DeviceDesc)
	..d OutputRowGetDevice
	quit
OutputRowGetDevice
   s Data=$lb(LName,LTRowID)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetDevice
   
	s (LName,LTRowID)=""
	quit
	Quit $$$OK
}

ClassMethod DeviceFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = DeviceExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 		}
 	Else      {
 		Set Row=^CacheTemp(repid,ind)
 		}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod DeviceClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = DeviceExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// w ##Class(web.DHCEQ.BA.BUSBenefitEquipList).SaveDeviceMapDataList(1,"")
ClassMethod SaveDeviceMapDataList(dataList, EquipID)
{
	new Find,SQLCODE
	s SQLCODE=0
	Set SplitRowCode=##class(web.DHCEQCommon).GetSysInfo("990025")
	s Length=$L(dataList,SplitRowCode)
	for i=1:1:Length
	{
		q:SQLCODE'=0
		s valList=$p(dataList,SplitRowCode,i)
		q:valList=""
		s SQLCODE=##Class(web.DHCEQ.BA.BUSDeviceMap).SaveData(valList,EquipID,0)
	}
	q SQLCODE
}

/// w ##Class(web.DHCEQ.BA.BUSDeviceMap).SaveData(valList, EquipID,DelIs)
ClassMethod SaveData(valList, EquipID, DelIs)
{
	new JsonData,DeviceSourceType,DeviceSourceID,Find,DMRowID,SQLCODE
	s SQLCODE=0
	if (DelIs=1)
	{
	 	&SQL(Update SQLUSER.DHC_EQDeviceMap Set DM_InvalidFlag='Y' where DM_RowID = :valList) 
	}
	else
	{
		k DMPLIST
		s JsonData = ##Class(web.DHCEQ.Plat.LIBCommon).StringToJson(valList)
		s DMPLIST=##Class(web.DHCEQ.Plat.LIBCommon).JsonToPlist("User.DHCEQDeviceMap",JsonData,.DMPLIST)
		s DMPLIST(2)=EquipID
		s DMRowID = JsonData.DMRowID
		s DeviceSourceType=JsonData.DMDeviceSource
		s DeviceSourceID=JsonData.DMDeviceID
		///本信息对照在其他设备上,不能重复对照.
		s Find=##Class(web.DHCEQ.BA.BUSDeviceMap).CheckDeviceSource(EquipID, DeviceSourceType, DeviceSourceID)
		// modified by ZY0217 2020-04-08
		i Find=0 s SQLCODE="-1000^"_DeviceSourceID
		i SQLCODE'=0 q SQLCODE
		
		if (DMRowID="")
		{
			i (Find="")
			{
				&SQL(Insert Into SQLUSER.DHC_EQDeviceMap Values :DMPLIST())
			}
			else
			{
				&SQL(Update SQLUSER.DHC_EQDeviceMap Values :DMPLIST() where DM_RowID = :Find) 
			}
		}
		else
		{
			i (Find="")||(Find=DMRowID)
			{
				&SQL(Update SQLUSER.DHC_EQDeviceMap Values :DMPLIST() where DM_RowID = :DMRowID) 	 
			}
			else
			{
				///重复记录
				s SQLCODE="-1001^"_DeviceSourceID
			}
		}
	}
	q SQLCODE
}

/// modified by ZY0217 2020-04-08
/// 返回值："":没有对照任何设备上,0:已经与其他设备对照,>0:当前设备的已经对照的记录ID
/// w ##Class(web.DHCEQ.BA.BUSDeviceMap).CheckDeviceSource(1, "DHC-LIS", 2)
ClassMethod CheckDeviceSource(EquipID, SourceType, SourceID)
{
	new findFlag,rowid
	s findFlag=""
	s rowid=0
	f  s rowid=$o(^DHCEQDeviceMap(0,"Device",SourceType,SourceID,rowid))  q:(rowid="")||(findFlag'="")  d
	.q:$p($g(^DHCEQDeviceMap(rowid)),"^",5)="Y"
	.i EquipID'=$p($g(^DHCEQDeviceMap(rowid)),"^",1) d
	..s findFlag="0"
	.e  d
	..s findFlag=rowid
	q findFlag
}

/// add by ZY0247 2020-12-22
/// 根据仪器及设备对照表，获取对应的设备系统的设备
/// w ##Class(web.DHCEQ.BA.BUSDeviceMap).GetEquipByDevice("DHC-RIS",19)
ClassMethod GetEquipByDevice(ExType, Device)
{
	n EquipDR,MapID
	s EquipDR=""
	i ExType="" q ""
	i Device="" q ""
	s MapID=0
	f  s MapID=$o(^DHCEQDeviceMap(0,"Device",ExType,Device,MapID)) q:(MapID="")  d
	.q:$p($g(^DHCEQDeviceMap(MapID)),"^",5)'="N"
	.s EquipDR=$p($g(^DHCEQDeviceMap(MapID)),"^",1)
	q EquipDR
}

Storage Default
{
<Data name="BUSDeviceMapDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCEQ.BA.BUSDeviceMapD</DataLocation>
<DefaultData>BUSDeviceMapDefaultData</DefaultData>
<IdLocation>^web.DHCEQ.BA.BUSDeviceMapD</IdLocation>
<IndexLocation>^web.DHCEQ.BA.BUSDeviceMapI</IndexLocation>
<StreamLocation>^web.DHCEQ.BA.BUSDeviceMapS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
