/// 名称: web.DHCEQ.EM.BUSVehicle
/// 描述: 车辆信息
/// 编写者：LMM
/// 编写日期: 2020-07-23
/// 产品组：设备管理
Class web.DHCEQ.EM.BUSVehicle Extends %Library.RegisteredObject [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

ClassMethod GetOneVehicle(VRowID As %Library.String = "")
{
	i VRowID="" q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("","")
	s $ZT="ERRORGetOneVehicle"
	s ObjVehicle=##Class(User.DHCEQVehicle).%OpenId(VRowID)
	s VehicleInfo=##Class(web.DHCEQ.Plat.LIBCommon).GetJsonTableRecord(ObjVehicle)
	s EQName=ObjVehicle.VEquipDR.EQName
    s SourceType=ObjVehicle.VSourceType
    s SourceID=ObjVehicle.VSourceID
    i (SourceType=0)&&(SourceID'="") s EQName=$p($g(^DHCEQOpenCheckList(SourceID)),"^",2)
    i (SourceType=1)&&(SourceID'="") s EQName=$p($g(^DHCEQEquip(SourceID)),"^",1)
	d VehicleInfo.%Set("VEquipDR_EQName",EQName)
	d VehicleInfo.%Set("VRowID",VRowID)
	q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(0,VehicleInfo)
ERRORGetOneVehicle
	s ErrorMsg=$ZE
	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-9012",ErrorMsg)
}

/// Creator：      ZX
/// CreatDate：    2019-07-03
/// Description:   数据保存
/// Input：        data:前台获取字符串 field:value,filed:vale
/// Return：       ID
ClassMethod SaveData(Data)
{
	k PLIST,RowID
	s JsonData = ##Class(web.DHCEQ.Plat.LIBCommon).StringToJson(Data)
	s PLIST=##Class(web.DHCEQ.Plat.LIBCommon).JsonToPlist("User.DHCEQVehicle",JsonData,.PLIST)
	s RowID = JsonData.VRowID
    if RowID'=""
    {
		&SQL(Update SQLUSER.DHC_EQVehicle Values :PLIST() where V_RowID = :RowID)
	}
	else
	{
		&SQL(insert into SQLUSER.DHC_EQVehicle Values :PLIST())
		s RowID=$g(%ROWID)
	}
	if SQLCODE
	{
		Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,"-9012")
	}
	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,RowID)
}

/// Creator：      ZX
/// CreatDate：    2020-07-23
/// Description:   车辆信息
Query GetVehicleList(Desc As %String = "", EquipDR As %String = "") As %Query(ROWSPEC = "TRowID:%String,TEquipDR:%String,TStructDR:%String,TVehicleArea:%String,TUtilizationArea:%String,TSubArea:%String,TPlace:%String,TOwnerFlag:%String,TSelfUseArea:%String,TLendingArea:%String,TRentArea:%String,TWorkArea:%String,TIdleArea:%String,TOtherArea:%String,TLendCompany:%String,TRentCompany:%String,TOwnerCertificate:%String,TCertificateNo:%String,TCertificateDate:%String,TFloorNum:%String,TUnderFloorNum:%String")
{
}

ClassMethod GetVehicleListExecute(ByRef qHandle As %Binary, Desc As %String = "", EquipDR As %String = "") As %Status
{
 	New repid, index,rowid,CurRole
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	Set index=1
	Set rowid=0
	
	If EquipDR'="" Do
	.For  Set rowid=$Order(^DHCEQVehicle(0,"EquipDR",EquipDR,rowid)) Quit:rowid=""  Do
	..Do BuildDataGetVehicleList
	Else  Do
	.For  Set rowid=$Order(^DHCEQVehicle(rowid)) Quit:rowid=""  Do
	..Do BuildDataGetVehicleList
	Quit $$$OK
BuildDataGetVehicleList
    Do ResetVariablesGetVehicleList
	Set TRowID=rowid
	Set TEquipDR=$Piece($Get(^DHCEQVehicle(rowid)),"^",1)
	Set TStructDR=$Piece($Get(^DHCEQVehicle(rowid)),"^",2)
	Set TVehicleArea=$Piece($Get(^DHCEQVehicle(rowid)),"^",3)
	Set TUtilizationArea=$Piece($Get(^DHCEQVehicle(rowid)),"^",4)
	Set TSubArea=$Piece($Get(^DHCEQVehicle(rowid)),"^",5)
	Set TPlace=$Piece($Get(^DHCEQVehicle(rowid)),"^",6)
	Set TOwnerFlag=$Piece($Get(^DHCEQVehicle(rowid)),"^",7)
	Set TSelfUseArea=$Piece($Get(^DHCEQVehicle(rowid)),"^",8)
	Set TLendingArea=$Piece($Get(^DHCEQVehicle(rowid)),"^",9)
	Set TRentArea=$Piece($Get(^DHCEQVehicle(rowid)),"^",10)
	Set TWorkArea=$Piece($Get(^DHCEQVehicle(rowid)),"^",11)
	Set TIdleArea=$Piece($Get(^DHCEQVehicle(rowid)),"^",12)
	Set TOtherArea=$Piece($Get(^DHCEQVehicle(rowid)),"^",13)
	Set TLendCompany=$Piece($Get(^DHCEQVehicle(rowid)),"^",14)
	Set TRentCompany=$Piece($Get(^DHCEQVehicle(rowid)),"^",15)
	Set TOwnerCertificate=$Piece($Get(^DHCEQVehicle(rowid)),"^",16)
	Set TCertificateNo=$Piece($Get(^DHCEQVehicle(rowid)),"^",17)
	Set TCertificateDate=$Piece($Get(^DHCEQVehicle(rowid)),"^",18)
	Set TFloorNum=$Piece($Get(^DHCEQVehicle(rowid)),"^",19)
	Set TUnderFloorNum=$Piece($Get(^DHCEQVehicle(rowid)),"^",20)
 	
	Quit
OutputRowGetVehicleList
	Set Data=$ListBuild(TRowID,TEquipDR,TStructDR,TVehicleArea,TUtilizationArea,TSubArea,TPlace,TOwnerFlag,TSelfUseArea,TLendingArea,TRentArea,TWorkArea,TIdleArea,TOtherArea,TLendCompany,TRentCompany,TOwnerCertificate,TCertificateNo,TCertificateDate,TFloorNum,TUnderFloorNum)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	Set TRow=TRow+1
	Quit
ResetVariablesGetVehicleList
	Set (TRowID,TEquipDR,TStructDR,TVehicleArea,TUtilizationArea,TSubArea,TPlace,TOwnerFlag,TSelfUseArea,TLendingArea,TRentArea,TWorkArea,TIdleArea,TOtherArea,TLendCompany,TRentCompany,TOwnerCertificate,TCertificateNo,TCertificateDate,TFloorNum,TUnderFloorNum)=""
	Quit
}

ClassMethod GetVehicleListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetVehicleListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$Order(^CacheTemp(repid,ind))
 	If ind=""
 	{
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else
 	{
 		Set Row=^CacheTemp(repid,ind)
 	}
	Set qHandle=$ListBuild(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetVehicleListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetVehicleListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

}
