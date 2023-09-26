/// 名称: web.DHCEQ.Plat.CTEquipType
/// 描述: 设备类组
/// 编写者：ZC
/// 编写日期: 2018-09-20
/// 产品组：设备管理
Class web.DHCEQ.Plat.CTEquipType Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：      ZC
/// CreatDate：    2018-09-20
/// Description:   设备类组LookUp所需Query
/// Table：        DHC_EQCEquipType
/// Input：        Desc:资金来源描述
/// 				   GroupID:安全组ID
///                Flag:是否包含无效类组	0:不包含  其他:包含
///                FacilityFlag:是否包含简易台账资产类组0  和 空 在账资产类组;  1  简易资产类组;  2  全部类组
/// modified by wy 2021-6-2 1967835新增入参QXType 0 库房限制类组    1 所有在账资产类组
Query GetEquipType(Desc, GroupID As %Library.String = "", Flag As %Library.String = "0", FacilityFlag As %String = "0", gHospId As %Library.String = "", BDPHospId As %Library.String = "", QXType As %String = "0", ManageLocID As %String = "") As %Query(ROWSPEC = "TName:%String,TRowID:%String,TCode:%String") [ SqlProc ]
{
}

ClassMethod GetEquipTypeExecute(ByRef qHandle As %Binary, Desc, GroupID As %Library.String = "", Flag As %Library.String = "0", FacilityFlag As %String = "0", gHospId As %Library.String = "", BDPHospId As %Library.String = "", QXType As %String = "0", ManageLocID As %String = "") As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s rowid=0
	s vEquipTypeIDs=""
	//s CurLocID=##Class(web.DHCEQCommon).getMapIDBySource("dept",%session.Get("LOGON.CTLOCID"))
	s sHospID=##class(web.DHCEQ.Util.BDPCommonUtil).GetBDPHospId(BDPHospId,gHospId)	//CZF0138 2021-05-26
	
	d BuildDataGetEquipType
	Quit $$$OK
BuildDataGetEquipType
	i Flag="1"  s vEquipTypeIDs=##class(web.DHCEQCommon).GetSysInfo("990024")  
	i ""'=vEquipTypeIDs s vEquipTypeIDs=","_vEquipTypeIDs_","   //2014-9-10 HZY0060 
	s Type=##class(web.DHCEQCommon).GetEquipTypesByGroup(GroupID,"",FacilityFlag) //add by zx 2017-03-20 BUG ZX0036
	if (Type="")  //所有类组
	{
		q
	}
	else  //可访问类组
	{
		s len=$l(Type,"^")
		for j=1:1:len
		{
			s rowid=$p(Type,"^",j)
			//add by wy 2021-5-31 库房限制类组 1945634
			//czf 2021-06-17 根据安全组访问类组控制 1969255 可根据管理科室控制可访问类组
			//s LOCFlag=0
			//s LocType=$o(^DHCEQCCode("DHCEQCLocGroupType",0,"Code","0101",0))
		  	//i '$d(^DHCEQCCode("DHCEQCLocType",0,"LocType",LocType,CurLocID)) s LOCFlag=1   //判断当前科室类型是否属于库房
			s CheckFLag=##Class(web.DHCEQ.Plat.CTStoreEquipType).CheckEquipTypeByStoreLocDR(ManageLocID,rowid)
			i CheckFLag'=0 continue
			d ResetVariablesGetEquipType
			d GetOneEquipType
		}
	}
	quit
GetOneEquipType
	q:##class(web.DHCEQ.Util.BDPCommonUtil).GetHospShowDataFlag("DHC_EQCEquipType",rowid,sHospID)'="Y"		//CZF0138 2021-05-26
	s TRowID=rowid
	s TName=$p(^DHCEQCCode("DHCEQCEquipType",TRowID),"^",2)
	s TCode=$p(^DHCEQCCode("DHCEQCEquipType",TRowID),"^",1)
	s Invaild=$p(^DHCEQCCode("DHCEQCEquipType",TRowID),"^",4)
	q:Invaild="Y"
	q:(TName'[Desc)&&(TCode'[Desc)
	q:(vEquipTypeIDs'="")&&(vEquipTypeIDs'[(","_TRowID_","))
	d OutputRowGetEquipType
	quit
OutputRowGetEquipType
	s Data=$lb(TName,TRowID,TCode)
  	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetEquipType
	s (TName,TRowID,TCode)=""
	quit
}

ClassMethod GetEquipTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetEquipTypeExecute ]
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

ClassMethod GetEquipTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetEquipTypeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

}
