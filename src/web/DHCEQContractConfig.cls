Class web.DHCEQContractConfig Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// w ##Class(web.DHCEQContractConfig).UpdateData("",1)
ClassMethod UpdateData(val, AppType)
{
	new CCRowID,User,Date,Time,SQLCODE
	
	s SQLCODE=0
	k PLIST
	s CCRowID=$p(val,"^",1)
	s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))	; Mozy0234	2019-11-26
	s Date=+$H
	s Time=$P($H,",",2)
	if +AppType=0
	{
		s PLIST(2) = $p(val,"^",2)	;ContractListDR
 		s PLIST(3) = $p(val,"^",3)	;Type
 		s PLIST(4) = $p(val,"^",4)	;ItemDR
 		s PLIST(5) = $p(val,"^",5)	;Item
 		s PLIST(6) = $p(val,"^",6)	;Price
 		s PLIST(7) = $p(val,"^",7)	;QuantityNum
 		s PLIST(8) = $p(val,"^",8)	;UnitDR
 		s PLIST(9) = $p(val,"^",9)	;BrandDR
 		s PLIST(10) = $p(val,"^",10)	;VendorDR
 		s PLIST(11) = $p(val,"^",11)	;ManuFactoryDR
 		s PLIST(12) = $p(val,"^",12)	;PartSpec
 		s PLIST(13) = $p(val,"^",13)	;PartModel
 		s PLIST(14) = $p(val,"^",14)	;Parameters
 		s PLIST(15) = $p(val,"^",15)	;CountryDR
 		s PLIST(16) = $p(val,"^",16)	;GuaranteePeriodNum
 		s PLIST(17) = $p(val,"^",17)	;Remark
 		s PLIST(18) = User //$p(val,"^",6)	;UpdateUserDR
 		s PLIST(19) = Date //$p(val,"^",7)	;UpdateDate
 		s PLIST(20) = Time //$p(val,"^",8)	;UpdateTime
 		//Mozy	2019-10-04
 		s PLIST(21) = $p(val,"^",18)	;LeaveFacNo
 		s PLIST(22) = ##class(web.DHCEQCommon).TransValueFromPage($p(val,"^",19),"date")	;LeaveDate
 		s PLIST(23) = $p(val,"^",20)	;ReceiverDR
 		s PLIST(24) = $p(val,"^",21)	;RegistrationNo
 		s PLIST(25) = $p(val,"^",22)	;InvoiceNo
 		s PLIST(26) = ##class(web.DHCEQCommon).TransValueFromPage($p(val,"^",23),"date")	;GuaranteeStartDate
 		s PLIST(27) = ##class(web.DHCEQCommon).TransValueFromPage($p(val,"^",24),"date")	;GuaranteeEndDate
 		
 		if CCRowID=""
 		{
	 		&SQL(insert into sqluser.DHC_EQContractConfig values :PLIST())
	 		s CCRowID=$G(%ROWID)
 		}
 		else
 		{
	 		&SQL(update sqluser.DHC_EQContractConfig values :PLIST() where CC_RowID=:CCRowID)
 		}
	}
	if +AppType=2
	{
		&SQL(delete from sqluser.DHC_EQContractConfig where CC_RowID=:CCRowID)
	}
	i SQLCODE q SQLCODE
	q CCRowID
}

/// w ##Class(web.DHCEQContractConfig).GetOneConfig(1)
ClassMethod GetOneConfig(rowid)
{
	new result,resultex
	s (result,resultex)=""
	s result= ^DHCEQContractConfig(rowid)
	s resultex=resultex_"^"	;Type
	i $p(result,"^",2)'=""  d
	.s resultex=resultex_$case($p(result,"^",2),0:"附件",1:"附属设备",2:"文件",3:"硬件配置",4:"软件配置","":"")
	s resultex=resultex_"^"	;UnitDR
	i $p(result,"^",7)'=""  d
	.s resultex=resultex_##Class(web.DHCEQCommon).GetTrakNameByID("uom",$p(result,"^",7))
	s resultex=resultex_"^"	;BrandDR
	i $p(result,"^",8)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCBrand",$p(result,"^",8))),"^",3)
	s resultex=resultex_"^"	;VendorDR
	i $p(result,"^",9)'=""  d
	.s resultex=resultex_##Class(web.DHCEQCommon).GetTrakNameByID("prov",$p(result,"^",9))
	s resultex=resultex_"^"	;ManuFactoryDR
	i $p(result,"^",10)'=""  d
	.s resultex=resultex_##Class(web.DHCEQCommon).GetTrakNameByID("manufacturer",$p(result,"^",10))
	s resultex=resultex_"^"	;CountryDR
	i $p(result,"^",14)'=""  d
	.s resultex=resultex_##Class(web.DHCEQCommon).GetTrakNameByID("cou",$p(result,"^",14))
	s resultex=resultex_"^"	;UpdateUserDR
	i $p(result,"^",17)'=""  d
	.s resultex=resultex_##Class(web.DHCEQCommon).GetTrakNameByID("user",$p(result,"^",17))
	s $p(result,"^",18)=##Class(web.DHCEQCommon).TransValueToPage($p(result,"^",18),"date")	;UpdateDate
	s $p(result,"^",19)=##Class(web.DHCEQCommon).TransValueToPage($p(result,"^",19),"time")	;UpdateTime
	s resultex=resultex_"^"	;ItemDR		//Mozy	798040	2019-1-7
	i $p(result,"^",3)'="" d
	.i $p(result,"^",2)="1" d
	..s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCMasterItem",$p(result,"^",3))),"^",1)
	.i ($p(result,"^",2)="3")||($p(result,"^",2)="4") d
	..s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCConfigItem",$p(result,"^",3))),"^",2)
	//Mozy	2019-10-04
	s $p(result,"^",21)=##Class(web.DHCEQCommon).TransValueToPage($p(result,"^",21),"date")	;LeaveDate
	s resultex=resultex_"^"	;
	i $p(result,"^",22)'=""  d
	.s resultex=resultex_##Class(web.DHCEQCommon).GetTrakNameByID("user",$p(result,"^",22))
	s $p(result,"^",25)=##Class(web.DHCEQCommon).TransValueToPage($p(result,"^",25),"date")	;GuaranteeStartDate
	s $p(result,"^",26)=##Class(web.DHCEQCommon).TransValueToPage($p(result,"^",26),"date")	;GuaranteeEndDate
	
	s result=##class(web.DHCEQCommon).Replace(result,$C(13,10),"\n")
	q result_resultex
}

/// w ##Class(web.DHCEQContractConfig).GetContractStatus(96)
ClassMethod GetContractStatus(CTLRowID)
{
	i CTLRowID="" q ""
	s CTRowID=$p(^DHCEQContractList(CTLRowID),"^",1)
	s Status=$p(^DHCEQContract(CTRowID),"^",24)
	q Status
}

/// Created By ZY 2018-5-2
/// Desc:查找合同明细对应的配置清单
/// d ##Class(%ResultSet).RunQuery("web.DHCEQContractConfig","GetConfig","37")
Query GetConfig(ContractListDR) As %Query(ROWSPEC = "TRowID:%String,TType:%String,TTypeDesc:%String,TItemDR:%String,TName:%String,TPrice:%String,TQuantityNum:%String,TUnitDR:%String,TUnit:%String,TBrandDR:%String,TBrand:%String,TProviderDR:%String,TProvider:%String,TManuFactoryDR:%String,TManuFactory:%String,TSpec:%String,TModel:%String,TParameters:%String,TGuaranteePeriodNum:%String,TCountryDR:%String,TCountry:%String,TRemark:%String,TItem:%String")
{
}

ClassMethod GetConfigExecute(ByRef qHandle As %Binary, ContractListDR) As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s RowID=0	
	f  s RowID=$o(^DHCEQContractConfig(0,"ContractList",ContractListDR,RowID)) q:RowID=""  d
	.d ResetVariablesGetConfig
	.s DataList=$g(^DHCEQContractConfig(RowID))
	.s TRowID=RowID
	.s TType = $p(DataList,"^",2)
	.s TTypeDesc=$case(TType,0:"附件",1:"附属设备",2:"文件",3:"硬件配置",4:"软件配置")
	.s TItemDR = $p(DataList,"^",3)
	.//Mozy	798040	2019-1-7
	.i TItemDR '=""  d
	..i TType="1" d
	...s TItem = $p($g(^DHCEQCCode("DHCEQCMasterItem",TItemDR)),"^",1)
	..i (TType="3")||(TType="4") d
	...s TItem = $p($g(^DHCEQCCode("DHCEQCConfigItem",TItemDR)),"^",2)
	.s TName = $p(DataList,"^",4)
	.s TPrice=$p(DataList,"^",5)
	.s TQuantityNum=$p(DataList,"^",6)
	.s TUnitDR=$p(DataList,"^",7)
	.s TUnit=##Class(web.DHCEQCommon).GetTrakNameByID("uom",TUnitDR)
	.s TBrandDR=$p(DataList,"^",8)
	.i TBrandDR '=""  d
	..s TBrand=$p($g(^DHCEQCCode("DHCEQCBrand",TBrandDR)),"^",3)
	.s TProviderDR=$p(DataList,"^",9)
	.s TProvider=##Class(web.DHCEQCommon).GetTrakNameByID("prov",TProviderDR)
	.i TBrandDR '=""  d
	..s TBrand=$p($g(^DHCEQCCode("DHCEQCBrand",TBrandDR)),"^",3)
	.s TManuFactoryDR=$p(DataList,"^",10)
	.s TManuFactory=##Class(web.DHCEQCommon).GetTrakNameByID("manufacturer",TManuFactoryDR)
	.s TSpec = $p(DataList,"^",11)
	.s TModel = $p(DataList,"^",12)
    .s TParameters = $p(DataList,"^",13)
    .s TCountryDR = $p(DataList,"^",14)
    .s TCountry=##class(web.DHCEQCommon).GetTrakNameByID("cou",TCountryDR)
    .s TGuaranteePeriodNum = $p(DataList,"^",15)
    .s TRemark = $p(DataList,"^",16)
	.d OutputRowGetConfig
	Quit $$$OK
OutputRowGetConfig
	Set Data=$lb(TRowID,TType,TTypeDesc,TItemDR,TName,TPrice,TQuantityNum,TUnitDR,TUnit,TBrandDR,TBrand,TProviderDR,TProvider,TManuFactoryDR,TManuFactory,TSpec,TModel,TParameters,TGuaranteePeriodNum,TCountryDR,TCountry,TRemark,TItem)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetConfig
	//Mozy	798040	2019-1-7
	Set (TRowID,TType,TTypeDesc,TItemDR,TName,TPrice,TQuantityNum,TUnitDR,TUnit,TBrandDR,TBrand,TProviderDR,TProvider,TManuFactoryDR,TManuFactory,TSpec,TModel,TParameters,TGuaranteePeriodNum,TCountryDR,TCountry,TRemark,TItem)=""
	quit
}

ClassMethod GetConfigFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetConfigExecute ]
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

ClassMethod GetConfigClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetConfigExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod ConfigTypeList(name, width, Type) As %String
{
	;;下拉列表
	w "<select name='"_name_"' id='"_name_"' style='width:"_width_"' HEIGHT=0>"
	w "<option value=0>附件</option>"
	w "<option value=1>附属设备</option>"
	w "<option value=2>文件</option>"
	w "<option value=3>硬件配置</option>"
	w "<option value=4>软件配置</option>"
	w "</select>",!
}

/// w ##Class(web.DHCEQContractConfig).SaveConfigBySource(95,354)
ClassMethod SaveConfigBySource(ContractListID, CheckListID)
{
	new User,CCRowID
 	s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))	; Mozy0234	2019-11-26
 	s Date=+$H
	s Time=$P($H,",",2)
	i '$Data(^DHCEQContractConfig(0,"ContractList",ContractListID)) q 0
	s CCRowID=0	
	f  s CCRowID=$o(^DHCEQContractConfig(0,"ContractList",ContractListID,CCRowID)) q:CCRowID=""  d
	.s DataList=$g(^DHCEQContractConfig(CCRowID))
	.s TRowID=CCRowID
	.s TType = $p(DataList,"^",2)
	.s TItemDR = $p(DataList,"^",3)
	.s TItem=$p(DataList,"^",4)
	.s TPrice=$p(DataList,"^",5)
	.s TQuantityNum=$p(DataList,"^",6)
	.s TUnitDR=$p(DataList,"^",7)
	.s TBrandDR=$p(DataList,"^",8)
	.s TProviderDR=$p(DataList,"^",9)
	.s TManuFactoryDR=$p(DataList,"^",10)
	.s TSpec = $p(DataList,"^",11)
	.s TModel = $p(DataList,"^",12)
    .s TParameters = $p(DataList,"^",13)
    .s TCountryDR = $p(DataList,"^",14)
    .s TCountry=##class(web.DHCEQCommon).GetTrakNameByID("cou",TCountryDR)
    .s TGuaranteePeriodNum = $p(DataList,"^",15)
    .s TRemark = $p(DataList,"^",16)
	.i TType=0 d
	..d SaveAffix
	.e  i TType=1 d
	..d SaveConfig
	.e  i TType=2 d
	..d SaveDoc
	.e  i TType=3 d
	..d SaveConfig
	.e  i TType=4 d
	..d SaveConfig
	
	q SQLCODE
	
SaveAffix
	k APLIST
	s APLIST(5) = TItem		;PartSpec
	s APLIST(6) = TModel		;PartModel
	s APLIST(7) = TManuFactoryDR		;ManuFactoryDR
	s APLIST(8) = TQuantityNum	;QuantityNum
	s APLIST(12) = TPrice				;PriceFee
	s APLIST(13) = TRemark		;Remark
	i TGuaranteePeriodNum'="" s APLIST(13) = TRemark_",保修期是"_TGuaranteePeriodNum		;Remark
	s APLIST(15) = "N"			;AF_DisuseFlag
	s APLIST(16) = "N"			;AF_InvalidFlag
	s APLIST(20) = CheckListID  ;AF_CheckListDR
	// Mozy		2019-10-04
	s APLIST(9) = $p(DataList,"^",22)
	s APLIST(10) = $p(DataList,"^",20)
	s APLIST(14) = TUnitDR
	s APLIST(25) = TProviderDR
	s APLIST(26) = $p(DataList,"^",25)
	s APLIST(27) = $p(DataList,"^",26)
	s APLIST(29) = $p(DataList,"^",24)
	s APLIST(30) = $p(DataList,"^",21)
	s APLIST(31) = $p(DataList,"^",23)
	
	s tmp=""
	&SQL(select AF_RowID into :tmp from SQLUSER.DHC_EQAffix where AF_PartSpec=:APLIST(5) and AF_CheckListDR=:APLIST(20) and AF_InvalidFlag<>'Y')
	if tmp'=""
	{
		&SQL(update SQLUSER.DHC_EQAffix Values :APLIST() where AF_RowID=:tmp)
	}
	else
	{
		&SQL(Insert Into SQLUSER.DHC_EQAffix Values :APLIST())
	}
	
	q SQLCODE
SaveDoc
	K DPLIST
	s DPLIST(2) = 3	;DocOriginalDR
	s DPLIST(3) = TItem	;DocName
	s DPLIST(6) = TQuantityNum	;ShareNum
	s DPLIST(8) = TRemark	;Remark
	s DPLIST(16) = 1  ;DocTypeDR
	s DPLIST(17) = CheckListID   ;CheckListDR
	s DPLIST(9) = User
	s DPLIST(10) = Date
	s DPLIST(11) = Time
	s tmp=""
	&SQL(select DOC_RowID into :tmp from SQLUSER.DHC_EQDoc where DOC_DocName=:DPLIST(3) and DOC_CheckListDR=:DPLIST(17))
	if tmp'=""
	{
		&SQL(update SQLUSER.DHC_EQDoc Values :DPLIST() where DOC_RowID=:tmp)
	}
	else
	{
		&SQL(Insert Into SQLUSER.DHC_EQDoc Values :DPLIST())
	}
	q SQLCODE
SaveConfig
	k CPLIST
	s CPLIST(2) = TType	;SourceType
	s CPLIST(3) = "1"	;SourceType
	s CPLIST(4) = CheckListID	;SourceID
	s CPLIST(5) = TItemDR	;ConfigItemDR
	s CPLIST(6) = TItem	;ConfigItem
	s CPLIST(7) = TPrice	;Price
	s CPLIST(8) = TQuantityNum	;QuantityNum
	s CPLIST(9) = TUnitDR	;UnitDR
	s CPLIST(10) = TBrandDR	;BrandDR
	s CPLIST(11) = TProviderDR	;ProviderDR
	s CPLIST(12) = TManuFactoryDR	;ManuFactoryDR
	s CPLIST(13) = TSpec	;PartSpec
	s CPLIST(14) = TModel	;PartModel
	s CPLIST(15) = TParameters	;PartDetail
	s CPLIST(16) = TGuaranteePeriodNum	;GuaranteePeriodNum
	s CPLIST(17) = TCountryDR	;CountryDR
	//s CPLIST(13) = 	;GuaranteeStartDate
	//s CPLIST(14) = 	;GuaranteeEndDate
	s CPLIST(28) = "Y"	;OpenFlag
	s CPLIST(29) = TRemark	;Remark
	s CPLIST(30) = "0"
	s CPLIST(31) = User
	s CPLIST(32) = Date
	s CPLIST(33) = Time
	s tmp=""
	&SQL(select C_RowID into :tmp from SQLUSER.DHC_EQConfig where C_SourceType="1" and C_SourceID=:CPLIST(3) and C_Item=:CPLIST(5))
	if tmp'=""
	{
		&SQL(update SQLUSER.DHC_EQConfig Values :CPLIST() where C_RowID=:tmp)
	}
	else
	{
		&SQL(Insert Into SQLUSER.DHC_EQConfig Values :CPLIST())
	}
	q SQLCODE
}

/// Mozy	2019-4-30
/// w ##Class(web.DHCEQContractConfig).GetOneConfigNew(8)
ClassMethod GetOneConfigNew(RowID As %Library.String = "")
{
	s $ZT="ERRORGetOneConfigNew"
	// CC_RowID	CC_ContractListDR	CC_Type	CC_ItemDR	CC_Item	CC_Price	CC_QuantityNum	CC_UnitDR	CC_BrandDR	CC_VendorDR	CC_ManuFactoryDR
	// CC_Spec	CC_Model	CC_Parameters	CC_CountryDR	CC_GuaranteePeriodNum	CC_Remark	CC_UpdateUserDR	CC_UpdateDate	CC_UpdateTime
	s ObjConfig=##Class(User.DHCEQContractConfig).%OpenId(RowID)
	s ConfigInfo=##Class(web.DHCEQ.Lib.Common).GetJsonTableRecord(ObjConfig)
	
	d ConfigInfo.%Set("CType_Desc",$CASE(ObjConfig.CCType,"0":"附件","1":"附属设备","2":"文件","3":"硬件配置","4":"软件配置",:" "))
	s CItemDRDesc=""
	i ObjConfig.CCType=1 s CItemDRDesc=##class(web.DHCEQCommon).GetTrakNameByID("masteritem",ObjConfig.CCItemDR)
	i ObjConfig.CCType>2 s CItemDRDesc=$p($g(^DHCEQCCode("DHCEQCConfigItem",+ObjConfig.CCItemDR)),"^",2)
	d ConfigInfo.%Set("CCItemDR_Desc",CItemDRDesc)
	d ConfigInfo.%Set("CCUnitDR_UOMDesc",ObjConfig.CCUnitDR.UOMDesc)
	d ConfigInfo.%Set("CCBrandDR_Desc",ObjConfig.CCBrandDR.BDesc)
	d ConfigInfo.%Set("CCVendorDR_VDesc",ObjConfig.CCVendorDR.VName)
	d ConfigInfo.%Set("CCManuFactoryDR_MDesc",ObjConfig.CCManuFactoryDR.VName)		//modified by CZF0103 20200408
	//s CCManuFactoryDR=ObjConfig.CCManuFactoryDRGetObjectId()		//modified by CZF0093 2020-03-17
	//d ConfigInfo.%Set("CCManuFactoryDR_MDesc",##class(web.DHCEQCommon).GetTrakNameByID("manufacturer",CCManuFactoryDR))
	d ConfigInfo.%Set("CCCountryDR_CDesc",ObjConfig.CCCountryDR.CTCOUDesc)
	d ConfigInfo.%Set("CCReceiverDR_SSUSRName",##Class(web.DHCEQCommon).GetTrakNameByID("user",ObjConfig.CCReceiverDR))	//Mozy	2019-10-04
	
	Quit ##Class(web.DHCEQ.Lib.Common).ReturnJson(0,ConfigInfo)
ERRORGetOneConfigNew
	Set ErrorMsg=$ZE
	TROLLBACK
	Quit ##Class(web.DHCEQ.Lib.Common).ReturnJson("-9000",ErrorMsg)
}

}
