Import SQLUser

Class web.DHCEQDeviceMap Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

ClassMethod GetDeviceMapClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDeviceMapExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// modified by czf 397032 增加TRow并输出
ClassMethod GetDeviceMapExecute(ByRef qHandle As %Binary, DeviceSourceDR As %String = "", DeviceID As %String = "", EquipDR As %String = "", QXType As %String = "") As %Status
{
	new repid, index, rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s TRow=1
	s rowid=0
	d BuildDataGetDeviceMap
	Quit $$$OK
BuildDataGetDeviceMap
	f  s rowid=$o(^DHCEQDeviceMap(rowid))  quit:rowid=""  d
	.d ResetVariablesGetDeviceMap
	.s TRowID = rowid	//rowid
	.s InvalidFlag=$p($g(^DHCEQDeviceMap(rowid)),"^",5)
	.q:InvalidFlag="Y"
	.s TEquip=$p($g(^DHCEQDeviceMap(rowid)),"^",1)
	.s TEquipDR=$p($g(^DHCEQDeviceMap(rowid)),"^",1)		//czf 1789983 2021-03-09
	.q:(EquipDR'="")&&(TEquip'=EquipDR)
	.s TDeviceSource=$p($g(^DHCEQDeviceMap(rowid)),"^",2)
	.q:(DeviceSourceDR'="")&&(TDeviceSource'=DeviceSourceDR)
	.s TDeviceID=$p($g(^DHCEQDeviceMap(rowid)),"^",3)
	.q:(DeviceID'="")&&(TDeviceID'=DeviceID)
	.s Find=0 //2010-10-29 DJ
	.i TEquip'=""  d
	..s TEquipNo=$p($g(^DHCEQEquip(TEquip)),"^",71)
	..s StoreLoc=$p($g(^DHCEQEquip(TEquip)),"^",67) //2010-10-29 DJ
	..i StoreLoc'=""  d
	...s Find=##class(web.DHCEQCommon).LocIsInEQ(QXType,StoreLoc)
	..s TEquip=$p($g(^DHCEQEquip(TEquip)),"^",1)
	.q:Find'=0 //2010-10-29 DJ
	.s TRemark=$p($g(^DHCEQDeviceMap(rowid)),"^",4)
	.s TDeviceDesc=$p($g(^DHCEQDeviceMap(rowid)),"^",6)
	.d OutputRowGetDeviceMap
	quit
OutputRowGetDeviceMap
	s Data=$lb(TRowID,TEquip,TDeviceID,TDeviceSource,TRemark,TDeviceDesc,TEquipNo,TRow,TEquipDR)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	s TRow=TRow+1
	quit
ResetVariablesGetDeviceMap
	s (TRowID,TEquip,TDeviceID,TDeviceSource,TRemark,TDeviceDesc,TEquipNo,TEquipDR)=""
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

Query GetDeviceMap(DeviceSourceDR As %String = "", DeviceID As %String = "", EquipDR As %String = "", QXType As %String = "") As %Query(ROWSPEC = "TRowID:%String,TEquip:%String,TDeviceID:%String,TDeviceSource:%String,TRemark:%String,TDeviceDesc:%String,TEquipNo:%String,TRow:%String,TEquipDR:%String")
{
}

ClassMethod GetDocByID(itmjs As %Library.String = "", itmjsex As %Library.String = "", rowid As %Library.String = "")
{
	new result,resultex
	s (result,resultex)=""
	s result= $g(^DHCEQDeviceMap(rowid))
	s resultex=resultex_"^"
	i $p(result,"^",1)'=""  d
	.s resultex=resultex_$p($g(^DHCEQEquip($p(result,"^",1))),"^",1)
	s resultex=result_resultex
	s resultex=##class(web.DHCEQCommon).Replace(resultex,$C(13,10),"\n") //回车符转换为"\n"
	q rowid_"^"_resultex
}

ClassMethod SaveData(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "", isDel As %Library.String = "")
{
 k PLIST,rowid
 s rowid=$p(val,"^",1)
 i (+isDel=1)
 {
 	//删除按钮操作,更新InvalidFlag标识.
 	s PLIST(12)="Y"
 	&SQL(Update SQLUSER.DHC_EQDeviceMap Values :PLIST() where DM_RowID = :rowid) 
 	if SQLCODE  q SQLCODE
 	q rowid
 }
 s PLIST(2)=$P(val,"^",2) //EquipDR
 s EquipDR=$P(val,"^",2)
 s PLIST(3)=$P(val,"^",3) //DeviceID
 s DeviceID=$P(val,"^",3)
 s PLIST(4)=$P(val,"^",4) //DeviceSource
 s DeviceSource=$p(val,"^",4)
 s PLIST(5)=$P(val,"^",5) //Remark
 s PLIST(12)="N"
 s PLIST(13)=$P(val,"^",6) //DeviceDesc
 i (rowid="")  //新增按钮操作
 {
	 //检测当前记录是否已经存在
	 &SQL(select DM_RowID into :Find from DHC_EQDeviceMap where DM_InvalidFlag='N' and DM_DeviceSource=:DeviceSource and DM_DeviceID=:DeviceID)
	 i (Find="")
	 {
		 &SQL(Insert Into SQLUSER.DHC_EQDeviceMap Values :PLIST())
	 }
 }
 else  //更新按钮操作
 {
	 &SQL(select DM_RowID into :RowidFind from DHC_EQDeviceMap where DM_InvalidFlag='N' and DM_EquipDR=:EquipDR)
	 &SQL(select DM_RowID into :Find from DHC_EQDeviceMap where DM_InvalidFlag='N' and DM_DeviceSource=:DeviceSource and DM_DeviceID=:DeviceID)
	 i (RowidFind="")||(Find="")
	 {
		 &SQL(Update SQLUSER.DHC_EQDeviceMap Values :PLIST() where DM_RowID = :rowid)
	 }
	 else
	 {
		 i (Find=rowid)
		 {
			 &SQL(Update SQLUSER.DHC_EQDeviceMap Values :PLIST() where DM_RowID = :rowid) 	 
		 }
	 }
 }
 if (SQLCODE'=0)&&(SQLCODE'=100)  q SQLCODE
 Set ID=$g(%ROWID)
 q ID
}

/// Modify By QW 2018-10-08 HISUI改造：自定义下拉列表显示格式错误
ClassMethod DeviceSource(name, width, type) As %String
{
	s No=1
	s Rtn=""
	w ##class(web.DHCEQCommon).GetDefaultStyle(name,"")
	w "<option value=>  </option>"
	do
	{
		s Rtn=##Class(web.DHCEQCommon).GetInterfaceInfo(No,type)
		s No=No+1
		i (Rtn'=-1)&&(Rtn'="")
		{
			w "<option value="_Rtn_">"_Rtn_"</option>"
		}
	}while(Rtn'=-1)
	w "</select>",!
}

ClassMethod DeviceClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = DeviceExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
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
	zn "DHC-PACS" //modify by wl 2020-02-28 WL0057 
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
	..zn "DHC-PACS"  //modify by wl 2020-02-28 WL0057
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

/// modify by ZY0226 2020-04-29 输出列增加汉字输出
/// d ##class(%ResultSet).RunQuery("web.DHCEQDeviceMap","Device","","DHC-RIS")
/// modify by wl 2020-02-28 WL0057 修改字段名
Query Device(DeviceDesc As %String = "", DeviceSourceDR As %String = "") As %Query(ROWSPEC = "TName:%String:名称,TRowID:%String:ID") [ SqlProc ]
{
}

/// Add By DJ 2018-03-25
/// 描述:判断设备与第三方仪器是否存在一对多的情况
ClassMethod CheckEQSource(vRowID As %String = "", vSourceType As %String = "", vSourceID As %String = "", vEQRowID As %String = "")
{
	i (vSourceType="")||(vSourceID="")||(vEQRowID="")  q "-2001"
	
	s FindFlag=0
	s DMRowID=0
	f  s DMRowID=$o(^DHCEQDeviceMap(0,"Device",vSourceType,vSourceID,DMRowID))  q:(DMRowID="")||(FindFlag'=0)  d
	.s DMInvalidFlag=$p($g(^DHCEQDeviceMap(DMRowID)),"^",5)
	.q:DMInvalidFlag="Y"
	.q:(vRowID'="")&&(DMRowID=vRowID)
	.s FindFlag=-2002			//第三方仪器对照关系已存在
	i FindFlag'=0 q FindFlag

	s DMSourceType=""
	f  s DMSourceType=$o(^DHCEQDeviceMap(0,"Equip",vEQRowID,DMSourceType))  q:(DMSourceType="")||(FindFlag'=0)  d
	.i DMSourceType'=vSourceType s FindFlag=-2003		//同一设备不能与多个第三方关联
	.q:FindFlag'=0
	.s DMRowID=0
	.f  s DMRowID=$o(^DHCEQDeviceMap(0,"Equip",vEQRowID,DMSourceType,DMRowID))  q:(DMRowID="")||(FindFlag'=0)  d
	..s DMInvalidFlag=$p($g(^DHCEQDeviceMap(DMRowID)),"^",5)
	..q:DMInvalidFlag="Y"
	..i DMSourceType'=vSourceType s FindFlag=-2003		//同一设备不能与多个第三方关联  Modified BY QW20181031 需求号:628770 只判断未被删除对照
	..i vRowID="" s FindFlag=-2004	//同一设备与多个第三方仪器关联
	..i (vRowID'="")&&(DMRowID'=vRowID) s FindFlag=-2004
	
	i FindFlag'=0 q FindFlag
	
	q 0
}

Storage Default
{
<Data name="DHCEQDeviceMapDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCEQDeviceMapD</DataLocation>
<DefaultData>DHCEQDeviceMapDefaultData</DefaultData>
<IdLocation>^web.DHCEQDeviceMapD</IdLocation>
<IndexLocation>^web.DHCEQDeviceMapI</IndexLocation>
<StreamLocation>^web.DHCEQDeviceMapS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
