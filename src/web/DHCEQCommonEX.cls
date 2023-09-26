Class web.DHCEQCommonEX Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

ClassMethod GetComponentID(name As %Library.String) As %String
{
	s CopmponentName=""
	&sql(select ID into :CopmponentName from websys.Component where name = :name)
	q CopmponentName
}

/// w ##Class(web.DHCEQCommonEX).GetMenuCaptionByID(id)
ClassMethod GetMenuCaptionByID(Id As %Library.String = "")
{
	s MenuCaption=""
	if Id="" q ""
	&sql(select Caption into :MenuCaption from websys.Menu where ID = :Id)
	q MenuCaption
}

/// Add by JDL 2010-11-24
/// 根据描述获取相应的ID
/// 入参：TableName：表名,不带下划线的表名
/// 		 Desc:描述
/// 返回：相应的ID
/// w ##Class(web.DHCEQCommonEX).GetIDByDesc("DHCEQOpenCheckRequest","YS2022070012")
ClassMethod GetIDByDesc(TableName, Desc, ParaDR As %String = "")
{
	new ID
	i TableName="" q ""
	i Desc="" q ""
	s ID=""
	if TableName="DHCEQCOrigin"
	{
		&SQL(Select O_RowID into :ID from SQLUser.DHC_EQCOrigin where O_Desc=:Desc)
	}
	elseif TableName="CTCountry"
	{
		&SQL(Select CTCOU_RowID into :ID from SQLUser.CT_Country where CTCOU_Desc like '%'||nvl(:Desc,''))
	}
	elseif TableName="DHCEQCPurchaseType"
	{
		&SQL(Select PT_RowID into :ID from SQLUser.DHC_EQCPurchaseType where PT_Desc=:Desc)
	}
	elseif TableName="DHCEQCPurposeType"
	{
		&SQL(Select PT_RowID into :ID from SQLUser.DHC_EQCPurposeType where PT_Desc=:Desc)
	}
	elseif TableName="DHCEQCBuyType"
	{
		&SQL(Select BT_RowID into :ID from SQLUser.DHC_EQCBuyType where BT_Desc=:Desc)
	}
	elseif TableName="CTLoc"
	{
		// MZY0058	1549254		2020-10-18
		;&SQL(Select CTLOC_RowID into :ID from SQLUser.CT_Loc where CTLOC_Desc=:Desc)
		&SQL(Select Dept_RowID into :ID from SQLUser.DHC_EQCDepartment where Dept_Desc=:Desc and Dept_InvalidFlag='N')
	}
	elseif TableName="DHCEQCEquipType"
	{
		&SQL(Select ET_RowID into :ID from SQLUser.DHC_EQCEquipType where ET_Desc=:Desc and ET_InvalidFlag='N')		// Mozy		2019-10-04
	}
	elseif TableName="DHCEQCStatCat"
	{
		&SQL(Select SC_RowID into :ID from SQLUser.DHC_EQCStatCat where SC_Desc=:Desc)
	}
	elseif TableName="DHCEQCOrigin"
	{
		&SQL(Select O_RowID into :ID from SQLUser.DHC_EQCOrigin where O_Desc=:Desc)
	}
	elseif TableName="DHCEQCExpenditures"
	{
		&SQL(Select E_RowID into :ID from SQLUser.DHC_EQCExpenditures where E_Desc=:Desc)
	}
	elseif TableName="DHCEQCMasterItem"
	{
		&SQL(Select MI_RowID into :ID from SQLUser.DHC_EQCMasterItem where MI_Desc=:Desc and MI_InvalidFlag='N' and MI_EquipTypeDR=:ParaDR)	// Mozy		2019-10-04
	}
	elseif TableName="SSUser"		//add by CZF0073 2020-02-24
	{
		&SQL(Select SSUSR_rowid into :ID from sqluser.ss_user where SSUSR_Name=:Desc)
	}
	elseif TableName="DHCEQMCMaintMode"
	{
		&SQL(Select MM_RowID into :ID from sqluser.DHC_EQMCMaintMode where MM_Desc=:Desc)
	}
	elseif TableName="DHCEQCUser"		//czf 2021-06-08 begin
	{
		&SQL(Select U_RowID into :ID from SQLUser.DHC_EQCUser where U_Name=:Desc)
	}
	elseif TableName="DHCEQCLocation"	//czf 2021-06-08 end
	{
		&SQL(Select L_RowID into :ID from SQLUser.DHC_EQCLocation where L_Desc=:Desc)
	}
	elseif TableName="EquipCat"
	{
		&SQL(Select EC_RowID into :ID from SQLUser.DHC_EQCEquipeCat where EC_Desc=:Desc)
	}
	elseif TableName="FromToDept"
	{
		&SQL(Select FTD_RowID into :ID from SQLUser.DHC_EQCFromToDept where FTD_Desc=:Desc)
	}
	elseif TableName="BuyType"
	{
		&SQL(Select BT_RowID into :ID from SQLUser.DHC_EQCBuyType where BT_Desc=:Desc)
	}
	elseif (TableName="Provider")||(TableName="Manufacturer")||(TableName="Service")
	{
		&SQL(Select V_RowID into :ID from SQLUser.DHC_EQCVendor where V_Name=:Desc)
	}
	elseif TableName="DepreMethod"
	{
		&SQL(Select DM_RowID into :ID from SQLUser.DHC_EQCDepreMethod where DM_Desc=:Desc)
	}
	elseif TableName="PurchaseType"
	{
		&SQL(Select PT_RowID into :ID from SQLUser.DHC_EQCPurchaseType where PT_Desc=:Desc)
	}
	elseif TableName="PurposeType"
	{
		&SQL(Select PT_RowID into :ID from SQLUser.DHC_EQCPurposeType where PT_Desc=:Desc)
	}
	elseif TableName="Brand"
	{
		&SQL(Select B_RowID into :ID from SQLUser.DHC_EQCBrand where B_Desc=:Desc)
	}
	elseif TableName="DHCEQCUOM"
	{
		&SQL(Select UOM_RowID into :ID from SQLUser.DHC_EQCUOM where UOM_Desc=:Desc)
	}
	elseif TableName="DHCEQCResourceType"	//modified ZY0285 20211206
	{
		&SQL(Select RT_RowID into :ID from SQLUser.DHC_EQCResourceType where RT_Desc=:Desc)
	}
	elseif TableName="DHCEQCEquipeCat"  //add by wy 2021-9-2 WY0096设备分类
	{
		&SQL(Select EC_RowID into :ID from SQLUser.DHC_EQCEquipeCat where EC_Desc=:Desc)
	}
	elseif TableName="DHCEQCMaintType"  //add by wy 2022-3-4 WY0097计量，巡检，保养类型
	{
		&SQL(Select MT_RowID into :ID from SQLUser.DHC_EQCMaintType where MT_Desc=:Desc)
	}
	elseif TableName="DHCEQCVendor"  //add by ZY0306
	{
		&SQL(Select V_RowID into :ID from SQLUser.DHC_EQCVendor where V_Name=:Desc)
	}
	elseif TableName="DHCEQOpenCheckRequest"  //add by ZY0306
	{
		s FindRequestNo=" "_Desc
		s ID=$Order(^DHCEQOpenCheckRequest(0,"RequestNo",FindRequestNo,0))
		s OCRFlag=$p($g(^DHCEQOpenCheckRequest(ID)),"^",45) //无效
		i OCRFlag="Y"
		{
			s ID=""
		}
	 	else
	 	{
		 	s ID=$o(^DHCEQOpenCheckList(0,"OpenCheckRequest",ID,0))
		}
	}

	q ID
}

ClassMethod CheckEquipInfoByID(EquipID, desc, value)
{
	s flag=0
	s value=##Class(web.DHCEQCommon).Trim(value)
	i value="" q 1
	if desc="Loc"
	{
		s UseLoc=$p($g(^DHCEQEquip(EquipID)),"^",19)
		s UseLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept",UseLoc)
		if (UseLoc=value) s flag=1
	}
	elseif desc="StoreLoc"
	{
		s StoreLoc=$p($g(^DHCEQEquip(EquipID)),"^",67)
		s StoreLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept",StoreLoc)
		if (StoreLoc=value) s flag=1
	}
	elseif desc="EquipType"
	{
		s EquipType=$p($g(^DHCEQEquip(EquipID)),"^",63)
		s EquipType=##Class(web.DHCEQCommon).GetTrakNameByID("equiptype",EquipType)
		if (EquipType=value) s flag=1
	}
	elseif desc="StatCat"
	{
		s StatCat=$p($g(^DHCEQEquip(EquipID)),"^",75)
		s StatCat=##Class(web.DHCEQCommon).GetTrakNameByID("statcat",StatCat)
		if (StatCat=value) s flag=1
	}
	elseif desc="Origin"
	{
		s StatCat=$p($g(^DHCEQEquip(EquipID)),"^",20)
		s StatCat=##Class(web.DHCEQCommon).GetTrakNameByID("origin",StatCat)
		if (StatCat=value) s flag=1
	}
	elseif desc="OriginalFee"
	{
		s OriginalFee=$p($g(^DHCEQEquip(EquipID)),"^",27)
		if (OriginalFee=value) s flag=1
	}
	elseif desc="DepreTotal"
	{
		s DepreTotal=$p($g(^DHCEQEquip(EquipID)),"^",35)
		if (DepreTotal=value) s flag=1
	}
	elseif desc="NetFee"
	{
		s NetFee=$p($g(^DHCEQEquip(EquipID)),"^",28)
		if (NetFee=value) s flag=1
	}
	elseif desc="Status"
	{
		s Status=$p($g(^DHCEQEquip(EquipID)),"^",38)
		s Status=##class(web.DHCEQEquip).GetEquipStatusDisplay(Status)
		if (Status=value) s flag=1
	}
	q flag
}

/// Add By DJ 2015-08-21 DJ0157
/// 描述:获取采购申请中科室同类台数,科室为空时获取同类台数
ClassMethod GetCountInLoc(vItemDR, vLocDR)
{
	n (vItemDR,vLocDR,Count)
	i vItemDR="" q 0
	s Count=0
	s StoreLocDR=0
	f  s StoreLocDR=$o(^DHCEQEquip(0,"StoreLocItem",StoreLocDR))  q:StoreLocDR=""  d
	.q:((vLocDR'="")&&(StoreLocDR'=vLocDR))
	.s EQRowID=0
	.f  s EQRowID=$o(^DHCEQEquip(0,"StoreLocItem",StoreLocDR,vItemDR,EQRowID))  q:EQRowID=""  d
	..s EQInvalidFlag=$p($g(^DHCEQEquip(EQRowID)),"^",59)
	..q:EQInvalidFlag="Y"
	..s EQStatus=$p($g(^DHCEQEquip(EQRowID)),"^",38)
	..s EQStockStatus=$p($g(^DHCEQEquip(EQRowID)),"^",60)
	..q:'((EQStatus<=2)&&(EQStockStatus=1))
	..s EQEquipCatDR=$p($g(^DHCEQEquip(EQRowID)),"^",4)
	..s Count=Count+1
	
	q Count
}

}
