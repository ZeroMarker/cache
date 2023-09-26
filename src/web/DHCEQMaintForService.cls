Class web.DHCEQMaintForService Extends %Persistent [ ClassType = "", Not ProcedureBlock ]
{

/// add by zx 2015-06-18
/// 根据设备编号获取设备信息
/// w ##class(web.DHCEQMaintForService).GetEquipByEquipNo("322070200025036")
ClassMethod GetEquipByEquipNo(EquipNo)
{
	s (TRowID,TName,TModel,TModelDR,TLeaveFactoryNo,TUseLocDR,TUseLoc,TOriginalFeeTNo,TFileNo,TNo,TEquipTypeDR,TStatCatDR)=""
	s EquipNo=$ZCONVERT(EquipNo,"U")
	if EquipNo="" q "-1"
	s rowid=0
	Set rowid = $Order(^DHCEQEquip(0,"No",EquipNo,0))
	if rowid=""  q "-2"
	s TRowID = rowid
	s TName = $p($g(^DHCEQEquip(TRowID)),"^",1)
	s TModelDR = $p($g(^DHCEQEquip(TRowID)),"^",3)
	i TModelDR '=""  d
	.s TModel = $p($g(^DHCEQCCode("DHCEQCModel",TModelDR)),"^",2)
	s TLeaveFactoryNo = $p($g(^DHCEQEquip(TRowID)),"^",10)
	s TUseLocDR = $p($g(^DHCEQEquip(TRowID)),"^",19)
	i TUseLocDR '="" s TUseLoc=##class(web.DHCEQCommon).GetTrakNameByID("dept",TUseLocDR)
	s TOriginalFee = $p($g(^DHCEQEquip(TRowID)),"^",27)
	s TNo = $p($g(^DHCEQEquip(TRowID)),"^",71)
	s TFileNo=$p($g(^DHCEQEquip(TRowID)),"^",85)
	s TEquipTypeDR=$p($g(^DHCEQEquip(TRowID)),"^",63)
	s TStatCatDR=$p($g(^DHCEQEquip(TRowID)),"^",75)

    q TRowID_"^"_TName_"^"_TNo_"^"_TModel_"^"_TLeaveFactoryNo_"^"_TUseLoc_"^"_TUseLocDR_"^"_TOriginalFee_"^"_TFileNo_"^"_TEquipTypeDR_"^"_TStatCatDR
}

/// w ##class(web.DHCEQMaintForService).GetMaintRequestInfo(4)
ClassMethod GetMaintRequestInfo(RequestID)
{
	i RequestID="" q:"-1001"
	s RequestNo=""
	s MaintRequestInfo=$g(^DHCEQMMaintRequest(RequestID))
	q MaintRequestInfo
}

/// add by zx 2015-06-23
/// 获取基础数据信息
/// w ##class(web.DHCEQMaintForService).GetMaintBasisData("DHC_EQMCMaintMode")
ClassMethod GetMaintBasisData(TableName As %String)
{
	i TableName="" q "-1001"
	s (TRowID,TDesc)=""
	s Info="0-未知"
	s rowid=0
	f  s rowid=$o(^DHCEQCCode(TableName,rowid)) q:rowid=""  d
	.q:($p($g(^DHCEQCCode(TableName,rowid)),"^",4)'="N")&&(TableName'="DHCEQMCMaintMode")
	.q:($p($g(^DHCEQCCode(TableName,rowid)),"^",5)'="N")&&(TableName="DHCEQMCMaintMode")
	.s TRowID=rowid
	.s TDesc=$p($g(^DHCEQCCode(TableName,rowid)),"^",2)
	.s Info=Info_"&"_TRowID_"-"_TDesc
	
	q Info
}

}
