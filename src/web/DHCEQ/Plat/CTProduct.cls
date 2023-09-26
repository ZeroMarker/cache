/// modified by ZY 20220926  2826780  
/// add by zy 20180814  ZY0171
/// 产品库功能代码
Class web.DHCEQ.Plat.CTProduct Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// w ##Class(web.DHCEQ.Plat.CTProduct).SaveData("","",3,1)
ClassMethod SaveData(data, DelIs As %String = "", SourceType As %String = "", SourceID As %String = "", EquipAttribute As %String = "")
{
    s $ZT="ERRORSave"
    k PLIST,MPLIST,RowID
    //s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
    s Date=+$H
    s Time=$Piece($H,",",2)
    TSTART
    if DelIs=1
    {
        s RowID=data
        &SQL(Update SQLUSER.DHC_EQPLATProductMap set PM_InvalidFlag='Y' where PM_ProductDR = :RowID)
        i SQLCODE=100 s SQLCODE=0
        &SQL(Update SQLUSER.DHC_EQPLATCProduct set P_InvalidFlag='Y' where P_RowID = :RowID)
        s RowID=""
    }
    else
    {
        s JsonData = ##Class(web.DHCEQ.Plat.LIBCommon).StringToJson(data)
        s PLIST=##Class(web.DHCEQ.Plat.LIBCommon).JsonToPlist("User.DHCEQPLATCProduct",JsonData,.PLIST)
        s RowID = JsonData.PRowID
        s PLIST(28) = "N"   ;
        s PDesc=JsonData.PDesc
        s PModels=JsonData.PModels
        i PModels="" s PModels=0
        s PManufactoryDR=+JsonData.PManufactoryDR
    ///modified by ZY 20221115 3073936
        s findflag=""
        s vPDesc=0
        f  s vPDesc=$o(^DHCEQCTPLAT("Product",0,"Unique",vPDesc))  q:(vPDesc="")||(findflag'="")  d
        .q:vPDesc'=PDesc
        .s vPManufactoryDR=""
        .f  s vPManufactoryDR=$o(^DHCEQCTPLAT("Product",0,"Unique",vPDesc,vPManufactoryDR))  q:(vPManufactoryDR="")||(findflag'="")  d
        ..q:vPManufactoryDR'=PManufactoryDR
        ..s vPModels=""
        ..f  s vPModels=$o(^DHCEQCTPLAT("Product",0,"Unique",vPDesc,vPManufactoryDR,vPModels))  q:(vPModels="")||(findflag'="")  d
        ...q:vPModels'=PModels
        ...s tmpid=""
        ...f  s tmpid=$o(^DHCEQCTPLAT("Product",0,"Unique",vPDesc,vPManufactoryDR,vPModels,"N",tmpid))  q:(tmpid="")||(findflag'="")  d
        ....s findflag=tmpid
        if findflag'=""
        {
            if (RowID="")
            {
                TCOMMIT
                q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(0,findflag)
            }
            else
            {
                if (findflag'=RowID)
                {
                    TCOMMIT
                    q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(0,findflag)
                }
            }
        }
        else
        {
            i RowID=""
            {
                &SQL(Insert into SQLUser.DHC_EQPLATCProduct values :PLIST())
                s RowID=$g(%ROWID)
            }
            else
            {
                &SQL(Update sqluser.DHC_EQPLATCProduct values :PLIST() where P_RowID=:RowID)
                i SQLCODE=100 s SQLCODE=0
            }
            if SQLCODE
            {
                TROLLBACK
                Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
            }
            if (SourceType'="")&&(SourceID'="")
            {
                s findflag=""
                s PMRowID=0
                f  s PMRowID=$o(^DHCEQPLATProductMap(0,"Product",RowID,SourceType,SourceID,PMRowID))  q:(PMRowID="")||(findflag'="")  d
                .q:$p($g(^DHCEQPLATProductMap(PMRowID)),"^",5)="Y"
                .s findflag=PMRowID
                if findflag=""
                {
                    s PMList(2)=RowID
                    s PMList(3)=SourceType
                    s PMList(4)=SourceID
                    s PMList(5)=""
                    s PMList(6)="N"
                    s PMList(7)=""
                    s PMList(8)=""
                    s PMList(9)=""
                    &SQL(Insert into SQLUser.DHC_EQPLATProductMap values :PMList())
                    i SQLCODE q SQLCODE
                }
            }
            if SQLCODE
            {
                TROLLBACK
                Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
            }
            i EquipAttribute'=""
            {
                ;设备属性相关调整
                Set SQLCODE=##Class(web.DHCEQ.EM.BUSEquipAttribute).SaveOpenCheckEquipAttribute(5,RowID,EquipAttribute)
                if SQLCODE
                {
                    TROLLBACK
                    Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
                }
            }
        }
    }
    If SQLCODE
    {
        TROLLBACK
        Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
    }
    TCOMMIT
    q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(0,RowID)
    
ERRORSave
    TROLLBACK
    s ErrorMsg=$ZE
    Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(ErrorMsg)
}

/// modified by ZY20230209 bug:3191388
/// w ##Class(web.DHCEQ.Plat.CTProduct).SaveProductDataBySource(2,62)
ClassMethod SaveProductDataBySource(SourceType, SourceID)
{
    new rowid,DataList,result
    s result=""
    k PList
    s (DataList,DataListEX,Code,Desc,DrugFlag,MedicalDeviceFlag,MeterageFlag,CycleNum,CycleUnitDR,UnitDR,RadiationFlag,Remark,DateFrom,DateTo,InvalidFlag,InfectionFlag)=""
    s (EquipTypeID,BrandDR,Models,Specs,ManuFactoryDR,CountryDR,Area,EnglishName,TradeName,IntoMarketDate,EquipCatDR,TreeDR,ClassABDR,StatCatDR,TechnologyLevel,WorkLoadNum)=""
    s (WorkLoadNum,WorkLoadUnitDR,CustomServiceTel,QuotePrice,ReserveFlag,RegistrationNo,MedicalCatDR)=""
    if SourceType=1
    {
        s DataList=$g(^DHCEQEquip(SourceID))
        s DataListEX=$g(^DHCEQEquip(SourceID,"OtherInfo"))
        s Code=$p(DataList,"^",6)
        s Desc=$p(DataList,"^",1)
        s MedicalDeviceFlag=$p(DataList,"^",49)
        s MeterageFlag=$p(DataList,"^",15)
        s UnitDR=$p(DataList,"^",5)
        s RadiationFlag=$p(DataListEX,"^",7)
        s EquipTypeID=$p(DataList,"^",63)
        s BrandDR=$p(DataList,"^",94)
        s Models=$p(DataList,"^",3)  //modify by mwz0065 20221202
        s ManuFactoryDR=$p(DataList,"^",26)
        s CountryDR=$p(DataList,"^",16)
        s EquipCatDR=$p(DataList,"^",4)
        s StatCatDR=$p(DataList,"^",75)
        s RegistrationNo=$p(DataList,"^",92)
        s VendorDR=$p(DataList,"^",25)
        i ManuFactoryDR="" q "-1^生产厂家信息不能为空!"
        i VendorDR="" q "-1^供应商信息不能为空!"
        //add by mwz 20200512 MWZ0038 begin
        s EALRowID=0
        for  s EALRowID=$o(^DHCEQEquipAttributeList(EALRowID)) quit:EALRowID=""  d  
        .s AttributeDR="",EQSubInfoDR="",IHTHold1="",EQCode=""
        .q:$p($g(^DHCEQEquipAttributeList(EALRowID)),"^",2)'="3"  //取来源为设备的属性
        .q:$p($g(^DHCEQEquipAttributeList(EALRowID)),"^",3)'=SourceID  //取当前设备属性
        .s AttributeDR=$p($g(^DHCEQEquipAttributeList(EALRowID)),"^",1)  //设备属性
        .s EQCode=$p($g(^DHCEQCCode("DHCEQCEquipAttribute",AttributeDR)),"^",1)
        .s EQSubInfoDR=$p($g(^DHCEQEquipAttributeList(EALRowID)),"^",4)  //设备属性子分类
        .i EQSubInfoDR'="" s IHTHold1=$p($g(^DHCEQCCode("DHCEQCInHospitalType",EQSubInfoDR)),"^",5)  //设备子分类二级子分类
        .i EQCode="11"  s MeterageFlag="Y" 
        .i (EQCode="51")&&(EQSubInfoDR'="") s ClassABDR=IHTHold1   //甲乙类分类
        //add by mwz 20200512 MWZ0038 end

        //add by ZY20230209 bug:3191388
        s EQItemDR=$p(DataList,"^",7)
	    s MedicalCatDR=$p($g(^DHCEQCCode("DHCEQCMasterItem",EQItemDR)),"^",9)
    }elseif (SourceType=2)
    {
        s CheckListDR=$o(^DHCEQOpenCheckList(0,"OpenCheckRequest",SourceID,0))
        i CheckListDR="" q ""
        s DataList=$g(^DHCEQOpenCheckList(CheckListDR))
        s DataListEX=$g(^DHCEQOpenCheckRequest(SourceID))
        s Code=$p(DataList,"^",8)
        s Desc=$p(DataList,"^",2)
        s MedicalDeviceFlag=$p(DataList,"^",38)
        s MeterageFlag=$p(DataList,"^",39)
        s UnitDR=$p(DataList,"^",7)
        s RadiationFlag=$p(DataList,"^",72)
        s EquipTypeID=$p(DataList,"^",3)
        s BrandDR=$p(DataList,"^",58)
        s Models=$p(DataList,"^",5)  //modify by mwz0065 20221202
        s ManuFactoryDR=$p(DataList,"^",15)
        s CountryDR=$p(DataList,"^",11)
        s EquipCatDR=$p(DataList,"^",6)
        s StatCatDR=$p(DataList,"^",28)
        s RegistrationNo=$p(DataList,"^",56)
        //add by mwz 20200512 MWZ0038 begin
        s EALRowID=0
        for  s EALRowID=$o(^DHCEQEquipAttributeList(EALRowID)) quit:EALRowID=""  d  
        .s AttributeDR="",EQSubInfoDR="",IHTHold1="",EQCode=""
        .q:$p($g(^DHCEQEquipAttributeList(EALRowID)),"^",2)'="2"  //取来源为验收的属性
        .q:$p($g(^DHCEQEquipAttributeList(EALRowID)),"^",3)'=SourceID  //取当前设备属性
        .s AttributeDR=$p($g(^DHCEQEquipAttributeList(EALRowID)),"^",1)  //设备属性
        .s EQCode=$p($g(^DHCEQCCode("DHCEQCEquipAttribute",AttributeDR)),"^",1)
        .s EQSubInfoDR=$p($g(^DHCEQEquipAttributeList(EALRowID)),"^",4)  //设备属性子分类
        .i EQSubInfoDR'="" s IHTHold1=$p($g(^DHCEQCCode("DHCEQCInHospitalType",EQSubInfoDR)),"^",5)  //设备子分类二级子分类
        .i EQCode="11"  s MeterageFlag="Y" 
        .i (EQCode="51")&&(EQSubInfoDR'="") s ClassABDR=IHTHold1   //甲乙类分类
        //add by mwz 20200512 MWZ0038 end

        //add by ZY20230209 bug:3191388
        s EQItemDR=$p(DataList,"^",9)
	    s MedicalCatDR=$p($g(^DHCEQCCode("DHCEQCMasterItem",EQItemDR)),"^",9)
    }
    
    s AssetItemInfo="^"_Code_"^"_Desc_"^"_DrugFlag_"^"_MedicalDeviceFlag_"^"_MeterageFlag_"^"_CycleNum_"^"_CycleUnitDR_"^"_UnitDR
    s AssetItemInfo=AssetItemInfo_"^"_RadiationFlag_"^"_Remark_"^"_DateFrom_"^"_DateTo_"^"_InvalidFlag_"^"_InfectionFlag
    s result=##Class(web.DHCEQ.Plat.CTAssetItem).SaveData(AssetItemInfo,0)
    s SQLCODE=$p(result,"^",1)
    if SQLCODE=0
    {
        s AssetItemID=$p(result,"^",2)
        s tmpid=""
        &SQL(select AC_RowID into :tmpid from sqluser.DHC_EQPLATCAssetClass where AC_EXType='DHC_EQEM' and AC_EXID=:EquipTypeID and AC_InvalidFlag<>'Y')
        if tmpid=""
        {
            s ACList(2)=$p($g(^DHCEQCCode("DHCEQCEquipType",EquipTypeID)),"^",1)
            s ACList(3)=$p($g(^DHCEQCCode("DHCEQCEquipType",EquipTypeID)),"^",2)
            s ACList(4)="1"
            s ACList(5)=""
            s ACList(6)=""
            s ACList(7)=""
            s ACList(8)="DHC_EQEM"
            s ACList(9)=EquipTypeID
            s ACList(10)="N"
            &SQL(Insert into SQLUser.DHC_EQPLATCAssetClass values :ACList())
            s AssetClassID=$g(%ROWID)
            i SQLCODE q SQLCODE
        }
        else
        {
            s AssetClassID=tmpid
        }
        s tmpid=""
        &SQL(select ACM_RowID into :tmpid from sqluser.DHC_EQPLATCAssetClassMap where ACM_AssetClassDR=:AssetClassID and ACM_SourceType='1' and ACM_SourceID=:AssetItemID and ACM_InvalidFlag<>'Y')
        if tmpid=""
        {
            s ACMList(2)=AssetClassID
            s ACMList(3)="1"
            s ACMList(4)=AssetItemID
            s ACMList(5)=""
            s ACMList(6)=""
            s ACMList(7)=""
            s ACMList(8)="N"
            s ACMList(9)=""
            s ACMList(10)=""
            s ACMList(11)=""
            &SQL(Insert into SQLUser.DHC_EQPLATCAssetClassMap values :ACMList())
            i SQLCODE q SQLCODE
        }
    }
    else
    {
        q SQLCODE
    }
    
    //s ProductInfo="^"_Code_"^"_Desc_"^"_AssetItemID_"^"_BrandDR_"^"_Models_"^"_Specs_"^"_ManuFactoryDR_"^"_CountryDR_"^"_Area
    //s ProductInfo=ProductInfo_"^"_EnglishName_"^"_TradeName_"^"_IntoMarketDate_"^"_EquipCatDR_"^"_TreeDR_"^"_ClassABDR_"^"_StatCatDR
    //s ProductInfo=ProductInfo_"^"_TechnologyLevel_"^"_WorkLoadNum_"^"_WorkLoadUnitDR_"^"_CustomServiceTel_"^"_QuotePrice_"^"_ReserveFlag
    //s ProductInfo=ProductInfo_"^"_RegistrationNo_"^"_Remark_"^"_DateFrom_"^"_DateTo_"^"_InvalidFlag
    //s result=##Class(web.DHCEQ.Plat.CTProduct).SaveData(ProductInfo,0)
    
    s ProductInfo=##class(web.DHCEQ.Plat.JsonObject).%New()
    d ProductInfo.%Set("PCode",Code)
    d ProductInfo.%Set("PDesc",Desc)
    d ProductInfo.%Set("PAssetItemDR",AssetItemID)
    d ProductInfo.%Set("PBrandDR",BrandDR)
    d ProductInfo.%Set("PModels",Models)
    d ProductInfo.%Set("PSpecs",Specs)
    d ProductInfo.%Set("PManufactoryDR",ManuFactoryDR)
    d ProductInfo.%Set("PCountryDR",CountryDR)
    d ProductInfo.%Set("PArea",Area)
    d ProductInfo.%Set("PEnglishName","")
    d ProductInfo.%Set("PTradeName",TradeName)
    d ProductInfo.%Set("PIntoMarketDate",IntoMarketDate)
    d ProductInfo.%Set("PEquipCatDR",EquipCatDR)
    //add by ZY20230209 bug:3191388
    d ProductInfo.%Set("PMedicalCatDR",MedicalCatDR)
    d ProductInfo.%Set("PClassAB",ClassABDR)
    d ProductInfo.%Set("PStatCatDR",StatCatDR)
    d ProductInfo.%Set("PTechnologyLevel",TechnologyLevel)
    d ProductInfo.%Set("PWorkLoadNum",WorkLoadNum)
    d ProductInfo.%Set("PWorkLoadUnitDR","")
    d ProductInfo.%Set("PCustomServiceTel",CustomServiceTel)
    d ProductInfo.%Set("PQuotePrice",QuotePrice)
    d ProductInfo.%Set("PReserveFlag",ReserveFlag)
    d ProductInfo.%Set("PRegistrationNo",RegistrationNo)
    d ProductInfo.%Set("PRemark",Remark)
    d ProductInfo.%Set("PDateFrom",DateFrom)
    d ProductInfo.%Set("PDateTo",DateTo)
    s ProductInfo=ProductInfo.%ToJSON()
    s result=##Class(web.DHCEQ.Plat.CTProduct).SaveData(ProductInfo,0,SourceType,SourceID)
    s result = ##Class(web.DHCEQ.Plat.LIBCommon).StringToJson(result)
    s SQLCODE=result.SQLCODE
    q result.SQLCODE_"^"_result.Data
}

/// do ##Class(%ResultSet).RunQuery("web.DHCEQ.Plat.CTProduct","GetProduct","单扇门","","")
/// modify by mwz 2020-04-13 MWZ0034
Query GetProduct(vData, SourceType As %String = "", SourceID As %String = "") As %Query(ROWSPEC = "TRowID,TCode,TDesc,TAssetItemDR,TAssetItem,TBrandDR,TBrand,TModel,TSpecs,TCompanyDR,TCompany,TCountryDR,TCountry,TArea,TEnglishName,TTradeName,TIntoMarketDate,TEquipCatDR,TEquipCat,TTreeDR,TTree,TClassABDR,TClassAB,TStatCatDR,TStatCat,TTechnologyLevelDR,TTechnologyLevel,TWorkLoadUnitDR,TWorkLoadNum,TWorkLoadUnit,TCustomServiceTel,TQuotePrice,TReserveFlag,TRegistrationNo,TRemark,TDateFrom,TDateTo,TMeterageFlag,TDrugFlag,TMedicalDeviceFlag,TRadiationFlag,TInfectionFlag,TVendorDR,TVendor")
{
}

ClassMethod GetProductExecute(ByRef qHandle As %Binary, vData, SourceType, SourceID) As %Status
{
    new repid, index,rowid,PMRowID,EQrowid
    s (PMRowID,EQrowid)=""
    Set repid=$I(^CacheTemp)
    Set qHandle=$lb(0,repid,0)
    Set index=1
    
    s PDesc=##class(web.DHCEQCommon).GetDataByName(vData,"PDesc")
    s PManufactoryDR=##class(web.DHCEQCommon).GetDataByName(vData,"PManufactoryDR")
    s PModels=##class(web.DHCEQCommon).GetDataByName(vData,"PModels")
    s AssetItemID=##class(web.DHCEQCommon).GetDataByName(vData,"AssetItemID")
    //Desc, AssetItemID, BrandID
    if (SourceType'="")&&(SourceID'="")
    {
        s PMRowID=0
        f  s PMRowID=$O(^DHCEQPLATProductMap(0,"Source",SourceType,SourceID,PMRowID)) q:PMRowID=""  d
        .q:$p($g(^DHCEQPLATProductMap(PMRowID)),"^",5)="Y"
        .s rowid=$p($g(^DHCEQPLATProductMap(PMRowID)),"^",1)
        .d BuildProductInfo
    }else
    {
        s rowid=0
        f  s rowid=$O(^DHCEQCTPLAT("Product",rowid)) q:rowid=""  d
        .d BuildProductInfo
    }
    Quit $$$OK
    
BuildProductInfo
    s (TRowID,TCode,TDesc,TAssetItemDR,TAssetItem,TBrandDR,TBrand,TModelDR,TModel,TCompanyDR,TCompany,TCountryDR,TCountry,TArea,TEnglishName,TTradeName,TIntoMarketDate,TClassABDR,TClassAB,TTechnologyLevelDR,TTechnologyLevel,TWorkLoadUnitDR,TWorkLoadNum,TWorkLoadUnit,TCustomServiceTel,TQuotePrice,TReserveFlag,TRegistrationNo,TRemark,TDateFrom,TDateTo,TMeterageFlag,TDrugFlag,TMedicalDeviceFlag,TRadiationFlag,TInfectionFlag,TVendorDR,TVendor)=""
    s ProductInfo=$g(^DHCEQCTPLAT("Product",rowid))
    q:$P(ProductInfo,"^",27)="Y"
    s TRowID=rowid
    s TCode=$P(ProductInfo,"^",1)
    s TDesc=$P(ProductInfo,"^",2)
    q:(PDesc'="")&(TDesc'[PDesc)
    s TAssetItemDR=$P(ProductInfo,"^",3)
    i SourceType=1
    {
        ;add by wy 2020-6-24 通过产品库与台账对照取产品库设备项 需求1382081
        s PMRowID=$O(^DHCEQPLATProductMap(0,"Product",rowid,1,""))  
        i PMRowID'="" d
        .s EQrowid=$P($g(^DHCEQPLATProductMap(PMRowID)),"^",3)
        .i EQrowid'="" d
        ..s TAssetItem=##class(web.DHCEQCommon).GetTrakNameByID("masteritem",$P($g(^DHCEQEquip(EQrowid)),"^",7))
        
    }
    q:(AssetItemID'="")&&(TAssetItem'[AssetItemID)  //MODIFY BY MWZ 2021-05-18 MWZ0049
    i TAssetItemDR'=""  d
    .s TMeterageFlag=$P($g(^DHCEQCTPLAT("AssetItem",TAssetItemDR)),"^",5)
    .s TDrugFlag=$P($g(^DHCEQCTPLAT("AssetItem",TAssetItemDR)),"^",3)
    .s TMedicalDeviceFlag=$P($g(^DHCEQCTPLAT("AssetItem",TAssetItemDR)),"^",4)
    .s TRadiationFlag=$P($g(^DHCEQCTPLAT("AssetItem",TAssetItemDR)),"^",9)
    .s TInfectionFlag=$P($g(^DHCEQCTPLAT("AssetItem",TAssetItemDR)),"^",14)
    s TBrandDR=$P(ProductInfo,"^",4)
    //q:(BrandID'="")&(TBrandDR'=BrandID)
    i TBrandDR'="" s TBrand=##class(web.DHCEQCommon).GetTrakNameByID("brand",TBrandDR)  // modify by mwz 20221228 mwz0066
    s TModels=$P(ProductInfo,"^",5)
    s TModels=##class(web.DHCEQCommon).GetTrakNameByID("model",TModels)  // add by mwz0065 20221201
    q:(PModels'="")&(TModels'[PModels)
    s TSpecs=$P(ProductInfo,"^",6)
    s TCompanyDR=$P(ProductInfo,"^",7)
    q:(PManufactoryDR'="")&(TCompanyDR'=PManufactoryDR)
    i TCompanyDR'="" s TCompany=##class(web.DHCEQCommon).GetTrakNameByID("manufacturer",TCompanyDR) //MODIFY BY MWZ 2020-04-09 MWZ0033
    s TCountryDR=$P(ProductInfo,"^",8)
    s TCountry=##Class(web.DHCEQCommon).GetTrakNameByID("cou",TCountryDR)
    s TArea=$P(ProductInfo,"^",9)
    s TEnglishName=$P(ProductInfo,"^",10)
    s TTradeName=$P(ProductInfo,"^",11)
    s TIntoMarketDate=##Class(web.DHCEQCommon).TransValueToPage($P(ProductInfo,"^",12),"date")
    s TEquipCatDR=$P(ProductInfo,"^",13)
    s TEquipCat=##Class(web.DHCEQCommon).GetTrakNameByID("equipcat",TEquipCatDR)
    s TTreeDR=$P(ProductInfo,"^",14)
    if (TTreeDR'="")
    {
        s TTree=$P(^DHCEQCCode("DHCEQCTree",TTreeDR),"^",3)   
    }
    s TClassABDR=$P(ProductInfo,"^",15)
    i TClassABDR'="" s TClassAB=$CASE(TClassABDR,"":"","1":"甲类","2":"乙类",:"")
    s TStatCatDR=$P(ProductInfo,"^",16)
    s TStatCat=##Class(web.DHCEQCommon).GetTrakNameByID("statcat",TStatCatDR)
    s TTechnologyLevelDR=$P(ProductInfo,"^",17)
    i TTechnologyLevelDR'="" s TTechnologyLevel=$CASE(TTechnologyLevelDR,"":"","1":"一级","2":"二级","3":"三级",:"")
    s TWorkLoadNum=$P(ProductInfo,"^",18)
    s TWorkLoadUnitDR=$P(ProductInfo,"^",19)
    s TWorkLoadUnit=##Class(web.DHCEQCommon).GetTrakNameByID("uom",TWorkLoadUnitDR)
    s TCustomServiceTel=$P(ProductInfo,"^",20)
    s TQuotePrice=$P(ProductInfo,"^",21)
    s TReserveFlag=$P(ProductInfo,"^",22)
    s TRegistrationNo=$P(ProductInfo,"^",23)
    s TRemark=$P(ProductInfo,"^",24)
    s TDateFrom=##Class(web.DHCEQCommon).TransValueToPage($P(ProductInfo,"^",25),"date")
    s TDateTo=##Class(web.DHCEQCommon).TransValueToPage($P(ProductInfo,"^",26),"date")
    //供应商 add by txr 20230104
    s PMSourceType=SourceType
    s PMSourceID=SourceID
    i (PMSourceType="")||(PMSourceID="") d
    .s PMSourceType=$O(^DHCEQPLATProductMap(0,"Product",rowid,""))
    .s PMSourceID=$O(^DHCEQPLATProductMap(0,"Product",rowid,PMSourceType,""))
    .s PMRowID=$O(^DHCEQPLATProductMap(0,"Product",rowid,PMSourceType,PMSourceID,""))
    i PMSourceType=1  d  //和台账对照取供应商
    .i PMRowID'="" d
    ..s EQrowid=$P($g(^DHCEQPLATProductMap(PMRowID)),"^",3)
    ..i EQrowid'=""  d
    ...s TVendorDR=$P($g(^DHCEQEquip(EQrowid)),"^",25)
    ...s TVendor=##class(web.DHCEQCommon).GetTrakNameByID("prov",TVendorDR)
    i (PMSourceType=2)&&(PMSourceID'="")  d  //和验收对照取供应商
    .s TVendorDR=$P($g(^DHCEQOpenCheckRequest(PMSourceID)),"^",5)
    .s TVendor=##class(web.DHCEQCommon).GetTrakNameByID("prov",TVendorDR)
    //供应商 end add by txr 20230104
    
    s Data=$lb(TRowID,TCode,TDesc,TAssetItemDR,TAssetItem,TBrandDR,TBrand,TModels,TSpecs,TCompanyDR,TCompany,TCountryDR,TCountry,TArea,TEnglishName,TTradeName,TIntoMarketDate,TEquipCatDR,TEquipCat,TTreeDR,TTree,TClassABDR,TClassAB,TStatCatDR,TStatCat,TTechnologyLevelDR,TTechnologyLevel,TWorkLoadUnitDR,TWorkLoadNum,TWorkLoadUnit,TCustomServiceTel,TQuotePrice,TReserveFlag,TRegistrationNo,TRemark,TDateFrom,TDateTo,TMeterageFlag,TDrugFlag,TMedicalDeviceFlag,TRadiationFlag,TInfectionFlag,TVendorDR,TVendor)
    Set ^CacheTemp(repid,index)=Data
    Set index=index+1
    quit
}

ClassMethod GetProductClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetProductExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod GetProductFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetProductExecute ]
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

/// 移动端产品库文件查询调用
/// do ##Class(%ResultSet).RunQuery("web.DHCEQ.Plat.CTProduct","GetProductAppendFile","31667")
Query GetProductAppendFile(EquipDR) As %Query(ROWSPEC = "TRowID:%String,TSourceTypeDesc:%String,TAppendFileTypeDR:%String,TAppendFileTypeDesc:%String,TDocName:%String,TFileName:%String,TFilePath:%String,TFileType:%String,TRemark:%String,TToSwfFlag:%String,TFtpStreamSrc:%String")
{
}

ClassMethod GetProductAppendFileExecute(ByRef qHandle As %Binary, EquipDR) As %Status
{
    new repid, index,rowid
    Set repid=$I(^CacheTemp)
    Set qHandle=$lb(0,repid,0)
    Set index=1
    
    i EquipDR="" q $$$OK
    s Models=$p($g(^DHCEQEquip(EquipDR)),"^",3)  //modify by mwz0065 20221202
    s Name=$p($g(^DHCEQEquip(EquipDR)),"^",1)
    s pmrowid=0
    f  s pmrowid=$O(^DHCEQCTPLAT("Product",pmrowid)) q:pmrowid=""  d
    .q:$p($g(^DHCEQCTPLAT("Product",pmrowid)),"^",27)="Y"
    .q:$p($g(^DHCEQCTPLAT("Product",pmrowid)),"^",2)'=Name
    .q:$P($g(^DHCEQCTPLAT("Product",pmrowid)),"^",5)'=Models
    .s arowid=0
    .f  s arowid=$O(^DHCEQAppendFile(0,"SourceType",96,pmrowid,arowid)) q:arowid=""  d
    ..d ResetVariableGetProductAppendFile
    ..q:$p($g(^DHCEQAppendFile(arowid)),"^",19)="Y" 
    ..s TRowID=arowid
    ..s TSourceTypeDesc="产品资料"
    ..s TAppendFileTypeDR=$p($g(^DHCEQAppendFile(TRowID)),"^",3)
    ..i TAppendFileTypeDR'=""  s TAppendFileTypeDesc=$p($g(^DHCEQCCode("DHCEQCAppendFileType",TAppendFileTypeDR)),"^",2)
    ..s TDocName=$p($g(^DHCEQAppendFile(TRowID)),"^",4)
    ..s TFileName=$p($g(^DHCEQAppendFile(TRowID)),"^",5)
    ..s TFilePath=$p($g(^DHCEQAppendFile(TRowID)),"^",6)
    ..s TFileType=$p($g(^DHCEQAppendFile(TRowID)),"^",7)
    ..s TRemark=$p($g(^DHCEQAppendFile(TRowID)),"^",8)
    ..s TToSwfFlag=$p($g(^DHCEQAppendFile(TRowID)),"^",20) //Y
    ..;s TFtpStreamSrc=##Class(web.DHCEQ.Process.DHCEQAppendFile).GetFtpStreamSrcByAFRowID(TRowID)
    ..d OutputRowGetProductAppendFile
    Quit $$$OK
OutputRowGetProductAppendFile
    s Data=$lb(TRowID,TSourceTypeDesc,TAppendFileTypeDR,TAppendFileTypeDesc,TDocName,TFileName,TFilePath,TFileType,TRemark,TToSwfFlag,TFtpStreamSrc)
    Set ^CacheTemp(repid,index)=Data
    Set index=index+1
    quit
ResetVariableGetProductAppendFile
    s (TRowID,TSourceTypeDesc,TAppendFileTypeDR,TAppendFileTypeDesc,TDocName,TFileName,TFilePath,TFileType,TRemark,TToSwfFlag,TFtpStreamSrc)=""
    quit
}

ClassMethod GetProductAppendFileFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetProductAppendFileExecute ]
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

ClassMethod GetProductAppendFileClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetProductAppendFileExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod SaveProductMap(data, dataList, deletePARowID)
{
    s $ZT="ERRORProductMap"
    k PMPLIST,PMRowID
    s SQLCODE=0
    TSTART
    s ProductDR=$p(data,"^",1)
    s SourceType=$p(data,"^",2)
    if deletePARowID'=""
    {
        s Length=$L(deletePARowID,",")
        for i=1:1:Length
        {
            q:SQLCODE'=0
            s PARowID=  $p(deletePARowID,",",i)
            &SQL(delete from SQLUSER.DHC_EQPLATProductMap where PM_ProductDR = :ProductDR and PM_SourceType = :SourceType and PM_SourceID = :PARowID and PM_InvalidFlag<>'Y')
            i SQLCODE=100 s SQLCODE=0
            q:SQLCODE'=0
            &SQL(delete from SQLUSER.DHC_EQProxyAuthorization where PA_RowID = :PARowID)
            i SQLCODE=100 s SQLCODE=0
        }
    }
    
        s PMPLIST(2) = ProductDR
        s PMPLIST(3) = $p(data,"^",2)
        s PMPLIST(6) = "N"
        
        Set SplitRowCode=##class(web.DHCEQCommon).GetSysInfo("990025")  //add by zx 2019-07-24 分隔符号处理
        s Length=$L(dataList,SplitRowCode)
        for i=1:1:Length
        {
            q:SQLCODE'=0
            s valList=  $p(dataList,SplitRowCode,i)  //add by zx 2019-07-24 分隔符号处理
            q:valList=""
            s PMSourceID=""
            s result=##Class(web.DHCEQ.Plat.CTProduct).SaveProxyAuthorization(valList)
            i result<0  d
            .s SQLCODE=result
            e  d
            .s PMSourceID=result
            q:SQLCODE'=0
            s PMPLIST(4) = PMSourceID
            s tmp=""
            &SQL(select PM_RowID into :tmp from SQLUSER.DHC_EQPLATProductMap  where PM_ProductDR = :PMPLIST(2) and PM_SourceType = :PMPLIST(3) and PM_SourceID = :PMPLIST(4) and PM_InvalidFlag = :PMPLIST(6))
            
            if tmp'=""
            {
                &SQL(Update SQLUSER.DHC_EQPLATProductMap Values :PMPLIST() where PM_RowID = :tmp)
            }
            else
            {
                &SQL(insert into SQLUSER.DHC_EQPLATProductMap Values :PMPLIST())
                s PMRowID=$g(%ROWID)
            }
        }
    i SQLCODE
    {
        TROLLBACK
        q SQLCODE
    }
    TCOMMIT
    q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
    
ERRORProductMap
    TROLLBACK
    s ErrorMsg=$ZE
    Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-1300",ErrorMsg)
}

ClassMethod SaveProxyAuthorization(dataList)
{
    new SQLCODE,PARowID,JsonData
    s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
    s Date=+$H
    s Time=$P($H,",",2)
    s SQLCODE=0
    k PLIST
    s JsonData = ##Class(web.DHCEQ.Plat.LIBCommon).StringToJson(dataList)
    s PLIST=##Class(web.DHCEQ.Plat.LIBCommon).JsonToPlist("User.DHCEQProxyAuthorization",JsonData,.PLIST)
    s PARowID = JsonData.PARowID
    s PLIST(14)="N"
    s PLIST(15)=User
    s PLIST(16)=Date
    s PLIST(17)=Time
    s PLIST(18)=2
    if PARowID'=""
    {
        &SQL(Update SQLUSER.DHC_EQProxyAuthorization Values :PLIST() where PA_RowID = :PARowID)
        i SQLCODE=100 s SQLCODE=0
    }
    else
    {
        &SQL(insert into SQLUSER.DHC_EQProxyAuthorization Values :PLIST())
        s PARowID=$g(%ROWID)
    }
    i SQLCODE'=0 q SQLCODE
    q PARowID
}

/// w ##class(web.DHCEQ.Plat.CTProduct).GetProxyAuthorizationByProductDR(1)
ClassMethod GetProxyAuthorizationByProductDR(ProductDR)
{
    s $ZT="ERRORGetProxyAuth"
    //^DHCEQPLATProductMap(0,"Product",ProductDR,SourceType,SourceID
    s level=0
    s ProxyAuthorization=##class(web.DHCEQ.Plat.JsonObject).%New()
    s SourceID=0
    f  s SourceID=$o(^DHCEQPLATProductMap(0,"Product",ProductDR,4,SourceID))  q:SourceID=""  d
    .s PMRowID=$o(^DHCEQPLATProductMap(0,"Product",ProductDR,4,SourceID,0))
    .q:$P($g(^DHCEQPLATProductMap(PMRowID)),"^",5)="Y"
    .s level=level+1
    .s Obj=##Class(User.DHCEQProxyAuthorization).%OpenId(SourceID)
    .s OneList=##Class(web.DHCEQ.Lib.Common).GetJsonTableRecord(Obj)
    .d ProxyAuthorization.%Set("PARowID"_level,SourceID)
    .d ProxyAuthorization.%Set("PAManuFactoryDR"_level,OneList.PAManuFactoryDR)
    .d ProxyAuthorization.%Set("PAAuthorizer"_level,OneList.PAAuthorizer)
    .d ProxyAuthorization.%Set("PAAuthorized"_level,OneList.PAAuthorized)
    .d ProxyAuthorization.%Set("PADesc"_level,OneList.PADesc)
    .d ProxyAuthorization.%Set("PANo"_level,OneList.PANo)
    .d ProxyAuthorization.%Set("PAAuthorizDate"_level,OneList.PAAuthorizDate)
    .d ProxyAuthorization.%Set("PAAvailableFromDate"_level,OneList.PAAvailableFromDate)
    .d ProxyAuthorization.%Set("PAAvailableToDate"_level,OneList.PAAvailableToDate)
    .d ProxyAuthorization.%Set("PAContext"_level,OneList.PAContext)
    .d ProxyAuthorization.%Set("PARemark"_level,OneList.PARemark)
    .d ProxyAuthorization.%Set("PALimitFlag"_level,OneList.PALimitFlag)
    .d ProxyAuthorization.%Set("PAActiveFlag"_level,OneList.PAActiveFlag)
    .d ProxyAuthorization.%Set("PAInvalidFlag"_level,OneList.PAInvalidFlag)
    .d ProxyAuthorization.%Set("PAUpdateUserDR"_level,OneList.PAUpdateUserDR)
    .d ProxyAuthorization.%Set("PAUpdateDate"_level,OneList.PAUpdateDate)
    .d ProxyAuthorization.%Set("PAUpdateTime"_level,OneList.PAUpdateTime)
    .d ProxyAuthorization.%Set("PAStatus"_level,OneList.PAStatus)
    .d ProxyAuthorization.%Set("PAHold1"_level,OneList.PAHold1)
    .d ProxyAuthorization.%Set("PAHold2"_level,OneList.PAHold2)
    .d ProxyAuthorization.%Set("PAHold3"_level,OneList.PAHold3)
    .d ProxyAuthorization.%Set("PAHold4"_level,OneList.PAHold4)
    .d ProxyAuthorization.%Set("PAHold5"_level,OneList.PAHold5)
    .
    .d ProxyAuthorization.%Set("PAManuFactory_VDesc"_level,##class(web.DHCEQCommon).GetTrakNameByID("manufacturer",OneList.PAManuFactoryDR))
    .d ProxyAuthorization.%Set("PAAuthorizer_VDesc"_level,##class(web.DHCEQCommon).GetTrakNameByID("manufacturer",OneList.PAAuthorizer))
    .d ProxyAuthorization.%Set("PAAuthorized_VDesc"_level,##class(web.DHCEQCommon).GetTrakNameByID("manufacturer",OneList.PAAuthorized))
    .d ProxyAuthorization.%Set("PAUpdateUser_SSUSRName"_level,##class(web.DHCEQCommon).GetTrakNameByID("user",OneList.PAUpdateUserDR))
    //s ProxyAuthorization=ProxyAuthorization.%ToJSON()
    
    d ProxyAuthorization.%Set("curLevel",level)
    q ##Class(web.DHCEQ.Lib.Common).ReturnJson(0,ProxyAuthorization)
ERRORGetProxyAuth
    s ErrorMsg=$ZE
    Quit ##Class(web.DHCEQ.Lib.Common).ReturnJson("-1300",ErrorMsg)
}

/// w ##class(web.DHCEQ.Plat.CTProduct).GetProxyInfo(2,9)
ClassMethod GetProxyInfo(PMSourceType, PMSourceID)
{
    new Level,PMRowID,PMProductDR
    i (PMSourceType="")||(PMSourceID="") q 0
    s Level=0
    s PMRowID=0
    f  s PMRowID=$o(^DHCEQPLATProductMap(0,"Source",PMSourceType,PMSourceID,PMRowID))  q:(PMRowID="")||(Level'=0)  d
    .q:$p($g(^DHCEQPLATProductMap(PMRowID)),"^",5)="Y"
    .s PMProductDR=$p($g(^DHCEQPLATProductMap(PMRowID)),"^",1)
    .s Level=##class(web.DHCEQ.Plat.CTProduct).GetLevel(PMProductDR,4)
    q Level
}

/// w ##class(web.DHCEQ.Plat.CTProduct).GetLevel(6)
ClassMethod GetLevel(ProductDR, SourceType As %String = "4")
{
    new SourceID,Level
    s (SourceID,Level)=0
    f  s SourceID=$o(^DHCEQPLATProductMap(0,"Product",ProductDR,4,SourceID))  q:SourceID=""  d
    .s PMRowID=$o(^DHCEQPLATProductMap(0,"Product",ProductDR,4,SourceID,0))
    .q:$P($g(^DHCEQPLATProductMap(PMRowID)),"^",5)="Y"
    .q:$p($g(^DHCEQProxyAuthorization(SourceID)),"^",13)="Y"
    .s Level=Level+1
    q Level
}

/// w ##class(web.DHCEQ.Plat.CTProduct).GetProductList("ceshi","173","173","2")
ClassMethod GetProductList(nodestr As %String = "", vManufactoryDR As %String = "", vAuthorizer As %String = "", vAuthorized As %String = "")
{
    new ManufactoryDR,Authorizer,Authorized,PARowID,PMRowID
    k ^TempDHCEQ(nodestr)
    s ManufactoryDR=0
    f  s ManufactoryDR=$o(^DHCEQProxyAuthorization(0,"ProxyAuthoriz",ManufactoryDR))  q:ManufactoryDR=""  d
    .q:(vManufactoryDR'="")&&(ManufactoryDR'=vManufactoryDR)
    .s Authorizer=0
    .f  s Authorizer=$o(^DHCEQProxyAuthorization(0,"ProxyAuthoriz",ManufactoryDR,Authorizer))  q:Authorizer=""  d
    ..q:(vAuthorizer'="")&&(Authorizer'=vAuthorizer)
    ..s Authorized=0
    ..f  s Authorized=$o(^DHCEQProxyAuthorization(0,"ProxyAuthoriz",ManufactoryDR,Authorizer,Authorized))  q:Authorized=""  d
    ...q:(vAuthorized'="")&&(Authorized'=vAuthorized)
    ...s PARowID=0
    ...f  s PARowID=$o(^DHCEQProxyAuthorization(0,"ProxyAuthoriz",ManufactoryDR,Authorizer,Authorized,PARowID))  q:PARowID=""  d
    ....q:$p($g(^DHCEQProxyAuthorization(PARowID)),"^",13)="Y"
    ....s PMRowID=0
    ....f  s PMRowID=$o(^DHCEQPLATProductMap(0,"Source",4,PARowID,PMRowID))  q:PMRowID=""  d
    .....q:$p($g(^DHCEQPLATProductMap(PMRowID)),"^",5)="Y"
    .....s PMProductDR=$p($g(^DHCEQPLATProductMap(PMRowID)),"^",1)
    .....s ^TempDHCEQ(nodestr,PMProductDR)=""
    q ""
}

/// 移动端产品库文件查询调用
/// do ##Class(%ResultSet).RunQuery("web.DHCEQ.Plat.CTProduct","GetProxyAuthorizationList","173","2")
Query GetProxyAuthorizationList(ManufactoryDR, VendorDR) As %Query(ROWSPEC = "ManufactoryDR:%String,Manufactory:%String,VendorDR:%String,Vendor:%String,ProductDR:%String,Product:%String,Level:%String,PARowID:%String,PALevel:%String,PAManufactory:%String,PAAuthorizer:%String,PAAuthorized:%String,PADesc:%String,PANo:%String,PAAuthorizDate:%String,PAAvailableDate:%String,PAContext:%String,PARemark:%String,PALimitFlag:%String,PAActiveFlag:%String")
{
}

ClassMethod GetProxyAuthorizationListExecute(ByRef qHandle As %Binary, ManufactoryDR, VendorDR) As %Status
{
    new repid, index,rowid,Node
    Set repid=$I(^CacheTemp)
    Set qHandle=$lb(0,repid,0)
    Set index=1
    
    i (ManufactoryDR="") q $$$OK
    i '$Data(^DHCEQProxyAuthorization(0,"ProxyAuthoriz",ManufactoryDR)) q $$$OK
    
    s nodestr="ProxyAuthorization"
    s Date=+$h
    s Job=$J
    s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
    
    s Node=nodestr_","_Date_","_Job_","_User
    d ##class(web.DHCEQ.Plat.CTProduct).GetProductList(Node,ManufactoryDR,"",VendorDR)
    
    s Manufactory=##class(web.DHCEQCommon).GetTrakNameByID("manufacturer",ManufactoryDR)
    s Vendor=##class(web.DHCEQCommon).GetTrakNameByID("manufacturer",VendorDR)
    
    s ProductDR=0
    f  s ProductDR=$o(^TempDHCEQ(Node,ProductDR))  q:ProductDR=""  d
    .s Level=##class(web.DHCEQ.Plat.CTProduct).GetLevel(ProductDR)
    .s Product=$P($g(^DHCEQCTPLAT("Product",ProductDR)),"^",2)
    .s (PARowID,PALevel)=0
    .f  s PARowID=$o(^DHCEQPLATProductMap(0,"Product",ProductDR,4,PARowID))  q:PARowID=""  d
    ..s PMRowID=$o(^DHCEQPLATProductMap(0,"Product",ProductDR,4,PARowID,0))
    ..q:$P($g(^DHCEQPLATProductMap(PMRowID)),"^",5)="Y"
    ..s DataList=$g(^DHCEQProxyAuthorization(PARowID))
    ..q:$p(DataList,"^",13)="Y"
    ..s PALevel=PALevel+1
    ..s PAManufactoryDR=$p(DataList,"^",1)
    ..s PAManufactory=##class(web.DHCEQCommon).GetTrakNameByID("manufacturer",PAManufactoryDR)
    ..s PAAuthorizer=$p(DataList,"^",2)
    ..s PAAuthorizer=##class(web.DHCEQCommon).GetTrakNameByID("manufacturer",PAAuthorizer)
    ..s PAAuthorized=$p(DataList,"^",3)
    ..s PAAuthorized=##class(web.DHCEQCommon).GetTrakNameByID("manufacturer",PAAuthorized)
    ..s PADesc=$p(DataList,"^",4)
    ..s PANo=$p(DataList,"^",5)
    ..s PAAuthorizDate=##class(web.DHCEQCommon).TransValueToPage($p(DataList,"^",6),"date")
    ..s PAAvailableFromDate=##class(web.DHCEQCommon).TransValueToPage($p(DataList,"^",7),"date")
    ..s PAAvailableToDate=##class(web.DHCEQCommon).TransValueToPage($p(DataList,"^",8),"date")
    ..s PAAvailableDate=PAAvailableFromDate_"~"_PAAvailableToDate
    ..s PAContext=$p(DataList,"^",9)
    ..s PARemark=$p(DataList,"^",10)
    ..s PALimitFlag=$p(DataList,"^",11)
    ..s PAActiveFlag=$p(DataList,"^",12)
    ..s PAStatus=$p(DataList,"^",17)
    ..s PAHold1=$p(DataList,"^",18)
    ..s PAHold2=$p(DataList,"^",19)
    ..s PAHold3=$p(DataList,"^",20)
    ..s PAHold4=$p(DataList,"^",21)
    ..s PAHold5=$p(DataList,"^",22)
    ..d OutputRowGetProxyAuthorizationList
    k ^TempDHCEQ(nodestr)
    Quit $$$OK
OutputRowGetProxyAuthorizationList
    s Data=$lb(ManufactoryDR,Manufactory,VendorDR,Vendor,ProductDR,Product,Level,PARowID,PALevel,PAManufactory,PAAuthorizer,PAAuthorized,PADesc,PANo,PAAuthorizDate,PAAvailableDate,PAContext,PARemark,PALimitFlag,PAActiveFlag)
    Set ^CacheTemp(repid,index)=Data
    Set index=index+1
    quit
}

ClassMethod GetProxyAuthorizationListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetProxyAuthorizationListExecute ]
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

ClassMethod GetProxyAuthorizationListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetProxyAuthorizationListExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// 移动端产品库文件查询调用
/// do ##Class(%ResultSet).RunQuery("web.DHCEQ.Plat.CTProduct","GetProductMap","104","2",4,1)
Query GetProductMap(PAAuthorizer, PAAuthorized, SourceType As %String = "", SourceID As %String = "", Desc As %String = "") As %Query(ROWSPEC = "PARowID:%String,PRowID:%String,PDesc:%String,PModels:%String,PSpecs:%String")
{
}

ClassMethod GetProductMapExecute(ByRef qHandle As %Binary, PAAuthorizer, PAAuthorized, SourceType, SourceID, Desc) As %Status
{
    new repid, index,rowid
    Set repid=$I(^CacheTemp)
    Set qHandle=$lb(0,repid,0)
    Set index=1
    
    i (PAAuthorizer="")||(PAAuthorized="") q $$$OK
    
    s ManufactoryDR=0
    f  s ManufactoryDR=$o(^DHCEQProxyAuthorization(0,"ProxyAuthoriz",ManufactoryDR))  q:ManufactoryDR=""  d
    .s PARowID=0
    .f   s PARowID=$o(^DHCEQProxyAuthorization(0,"ProxyAuthoriz",ManufactoryDR,PAAuthorizer,PAAuthorized,PARowID))  q:PARowID=""  d
    ..q:$p($g(^DHCEQProxyAuthorization(PARowID)),"^",13)="Y"
    ..q:(SourceID'="")&&(SourceID'=PARowID)
    ..s PMRowID=0
    ..f  s PMRowID=$o(^DHCEQPLATProductMap(0,"Source",SourceType,PARowID,PMRowID))  q:PMRowID=""  d
    ...q:$p($g(^DHCEQPLATProductMap(PMRowID)),"^",5)="Y"
    ...s PMProductDR=$p($g(^DHCEQPLATProductMap(PMRowID)),"^",1)
    ...q:PMProductDR=""
    ...s ProductInfo=$g(^DHCEQCTPLAT("Product",PMProductDR))
    ...q:$P(ProductInfo,"^",27)="Y"
    ...s PRowID=PMProductDR
    ...s PDesc=$P(ProductInfo,"^",2)
    ...q:(Desc'="")&(PDesc'[Desc)
    ...s PModels=$P(ProductInfo,"^",5)
    ...s PModels=##class(web.DHCEQCommon).GetTrakNameByID("model",PModels)  //modified by ZY20230320 bug:3251581
    ...s PSpecs=$P(ProductInfo,"^",5)
    ...d OutputRowGetProductMap
    Quit $$$OK
OutputRowGetProductMap
    s Data=$lb(PARowID,PRowID,PDesc,PModels,PSpecs)
    Set ^CacheTemp(repid,index)=Data
    Set index=index+1
    quit
}

ClassMethod GetProductMapFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetProductMapExecute ]
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

ClassMethod GetProductMapClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetProductMapExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// modified by ZY20230201 bug:3190947、3191169、3191286、3191319、3191388、3200510
/// Creator：      ZX
/// CreatDate：    2018-08-22
/// Description:   解析单条台账信息
/// Table：        DHC_EQEquip
/// Input：        RowID:台账ID
/// Return：       表数据解析 json返回
/// w ##Class(web.DHCEQ.Plat.CTProduct).GetOneProduct(1)
ClassMethod GetOneProduct(RowID As %Library.String = "")
{
    s $ZT="ERRORGetOneProduct"
    s ObjProduct=##Class(User.DHCEQPLATCProduct).%OpenId(RowID)
    s ProductInfo=##Class(web.DHCEQ.Plat.LIBCommon).GetJsonTableRecord(ObjProduct)
    d ProductInfo.%Set("PRowID",RowID)
    d ProductInfo.%Set("PAssetItemDR_AIDesc",ObjProduct.PAssetItemDR.AIDesc)
    d ProductInfo.%Set("PBrandDR_BDesc",ObjProduct.PBrandDR.BDesc)
    d ProductInfo.%Set("PModels_MDesc",##class(web.DHCEQCommon).GetTrakNameByID("model",ObjProduct.PModels))
    d ProductInfo.%Set("PManufactoryDR_VName",ObjProduct.PManufactoryDR.VName)
    d ProductInfo.%Set("PStatCatDR_SCDesc",ObjProduct.PStatCatDR.SCDesc)
    d ProductInfo.%Set("PCountryDR_CTCOUDesc",##class(web.DHCEQCommon).GetTrakNameByID("country",ObjProduct.PCountryDR))
    
    d ProductInfo.%Set("PWorkLoadUnitDR_UOMDesc",ObjProduct.PWorkLoadUnitDR.UOMDesc)
    d ProductInfo.%Set("PEquipCatDR_ECDesc",ObjProduct.PEquipCatDR.ECDesc)
    if (ObjProduct.PMedicalCatDR'="")
    {
        s TreeDesc=$P(^DHCEQCCode("DHCEQCTree",ObjProduct.PMedicalCatDR),"^",3)   
    }
    else 
    {
        s TreeDesc=""
    }
    d ProductInfo.%Set("PMedicalCatDR_MCDesc",TreeDesc)
    d ProductInfo.%Set("PClassAB_Desc",$CASE(ObjProduct.PAssetItemDR,"":"","1":"甲类","2":"乙类",:""))
    s AssetItemDR=$p($g(^DHCEQCTPLAT("Product",RowID)),"^",3)
    i AssetItemDR'=""  d
    .s ObjAssetItem=##Class(User.DHCEQPLATCAssetItem).%OpenId(AssetItemDR)
    .s AssetItemInfo=##Class(web.DHCEQ.Plat.LIBCommon).GetJsonTableRecord(ObjAssetItem)
    .
    .d ProductInfo.%Set("AIMeterageFlag",AssetItemInfo.AIMeteregeFlag)
    .d ProductInfo.%Set("AIDrugFlag",AssetItemInfo.AIDrugFlag)
    
    q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(0,ProductInfo)
ERRORGetOneProduct
    s ErrorMsg=$ZE
    Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-9012",ErrorMsg)
}

/*
/// modified by zy20221206 bug:3131911
/// modify by mwz0065 20221202
///   产品信息获取
/// 入参:产品ID
/// 输出：产品信息拼串(多表)
/// w ##class(web.DHCEQ.Plat.CTProduct).GetOneProductInfo(24)
ClassMethod GetOneProductInfo(RowID)
{
    Set resultex=""
    s (MasterItem,MasterItemDR,EquipName,Model,ManuFactory,AllowFlag,Price,Brand,Country,AreaDR,EnglishName,EquipCat,MedicalCat,MedicalCatDR,ClassAB,StatCat,RegistrationNo,Remark,DateFrom,DateTo,Area)=""
    s result=$g(^DHCEQCTPLAT("Product",RowID))
    s TAssetItemDR=$p(result,"^",3)
    s PMRowID=$O(^DHCEQPLATProductMap(0,"Product",RowID,1,""))  
    i PMRowID'="" d
    .s EQRowID=$P($g(^DHCEQPLATProductMap(PMRowID)),"^",3)
    .i EQRowID'="" d
    ..///modified by ZY20221206 bug:3131911
    ..s MasterItemDR=$P($g(^DHCEQEquip(EQRowID)),"^",7)
    ..s MasterItem=##class(web.DHCEQCommon).GetTrakNameByID("masteritem",MasterItemDR)
    ..s TAssetItem=##class(web.DHCEQCommon).GetTrakNameByID("masteritem",MasterItemDR)
    i TAssetItemDR'=""  d
    .s MeterageFlag=$P($g(^DHCEQCTPLAT("AssetItem",TAssetItemDR)),"^",5)
    .s DrugFlag=$P($g(^DHCEQCTPLAT("AssetItem",TAssetItemDR)),"^",3)
    .s MedicalDeviceFlag=$P($g(^DHCEQCTPLAT("AssetItem",TAssetItemDR)),"^",4)
    .s RadiationFlag=$P($g(^DHCEQCTPLAT("AssetItem",TAssetItemDR)),"^",9)
    .s InfectionFlag=$P($g(^DHCEQCTPLAT("AssetItem",TAssetItemDR)),"^",14)
    //s MasterItemDR=$P($g(^DHCEQEquip(EQRowID)),"^",7)
    //i MasterItemDR'="" s MasterItem=##class(web.DHCEQCommon).GetTrakNameByID("masteritem",MasterItemDR)
    s EquipName=$p(result,"^",2)
    s ModelDR=$p(result,"^",5)
    i ModelDR'="" s Model = $p($g(^DHCEQCCode("DHCEQCModel",ModelDR)),"^",2)
    s ManuFactoryDR=$p(result,"^",7)
    i ManuFactoryDR'="" s ManuFactory=##class(web.DHCEQCommon).GetTrakNameByID("manufacturer",ManuFactoryDR)
    s AllowFlag=$p(result,"^",28)
    s Price=$p(result,"^",21)
    s BrandDR=$p(result,"^",4)
    i BrandDR'="" s Brand=##class(web.DHCEQCommon).GetTrakNameByID("brand",BrandDR)
    s CountryDR=$p(result,"^",8)
    i CountryDR'="" s Country=##Class(web.DHCEQCommon).GetTrakNameByID("cou",CountryDR)
    s AreaDR=$p(result,"^",9)
    i AreaDR'="" s Area=##Class(web.DHCEQCommon).GetTrakNameByID("cou",AreaDR)
    s EnglishName=$p(result,"^",10)
    s EquipCatDR=$p(result,"^",13)
    i EquipCatDR'="" s EquipCat=##Class(web.DHCEQCommon).GetTrakNameByID("equipcat",EquipCatDR)
    s MedicalCatDR=$p(result,"^",14)
    i MedicalCatDR'="" s MedicalCat=##Class(web.DHCEQCommon).GetTrakNameByID("equipcat",MedicalCatDR)
    s ClassAB=$p(result,"^",15)
    s StatCatDR=$p(result,"^",16)
    i StatCatDR'="" s StatCat=##Class(web.DHCEQCommon).GetTrakNameByID("equipcat",StatCatDR)
    s RegistrationNo=$p(result,"^",23)
    s Remark=$p(result,"^",24)
    s DateFrom=##Class(web.DHCEQCommon).TransValueToPage($P(result,"^",25),"date")
    s DateTo=##Class(web.DHCEQCommon).TransValueToPage($P(result,"^",26),"date")
    s resultex=MasterItemDR_"^"_MasterItem_"^"_EquipName_"^"_Model_"^"_ModelDR_"^"_ManuFactory_"^"_ManuFactoryDR_"^"_AllowFlag_"^"_Price_"^"_Brand_"^"_BrandDR_"^"_Country_"^"_CountryDR_"^"_AreaDR_"^"_EnglishName_"^"_EquipCat_"^"_EquipCatDR_"^"_MedicalCat_"^"_MedicalCatDR_"^"_ClassAB_"^"_StatCat_"^"_StatCatDR_"^"_RegistrationNo_"^"_Remark_"^"_DateFrom_"^"_DateTo_"^"_Area_"^"_MeterageFlag_"^"_DrugFlag
    Set resultex=##class(web.DHCEQCommon).Replace(resultex,$C(13,10),"\n")
    Quit resultex
}*/
/// modified by ZY20230201 bug:3190947、3191169、3191286、3191319、3191388、3200510  多余代码
/// modified by ZY20230201 bug:3190947、3191169、3191286、3191319、3191388、3200510
/// add by mwz0065 20221202
/// 入参:data：产品编辑信息   IsDel:1 删除 , 其他：新增或更新  exdata:非数据传入
/// 输出：产品信息拼串(多表)
/// 产品编辑信息保存
/// w ##class(web.DHCEQ.Plat.CTProduct).SaveProductEditInfo("{""MasterItem"":""微量泵"",""EquipName"":""微量泵"",""Model"":""LX3"",""ManuFactory"":"""",""Price"":"""",""Brand"":"""",""Country"":"""",""Area"":""中国"",""EnglishName"":"""",""EquipCat"":""房屋建筑物"",""MedicalCat"":"""",""StatCat"":""航运用房"",""RegistrationNo"":""9.0"",""Remark"":"""",""DateFrom"":"""",""MeterageFlag"":false,""DateTo"":"""",""DrugFlag"":false,""RowID"":""24"",""EquipCatDR"":""1"",""MasterItemDR"":""4"",""ModelDR"":""1"",""StatCatDR"":""20"",""ManuFactoryDR"":"""",""CountryDR"":"""",""BrandDR"":"""",""MedicalCatDR"":"""",""AreaDR"":""1""}",0)
ClassMethod SaveProductEditInfo(data, IsDel)
{
    new PRowID,AIRowID
    s $ZT="ERRORProductEdit"
    k PLIST,AIPLIST
    s SQLCODE=0
    TSTART
    if IsDel=1
    {
        s PRowID=data
        &SQL(Update sqluser.DHC_EQPLATCProduct set P_InvalidFlag='Y' where P_RowID=:PRowID)
        If SQLCODE
        {
            TROLLBACK
            Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
        }
    }
    else
    {
        s JsonData = ##Class(web.DHCEQ.Plat.LIBCommon).StringToJson(data)
        s PRowID=JsonData.RowID
        s PAssetItemDR=JsonData.PAssetItemDR
        s PLIST=##Class(web.DHCEQ.Plat.LIBCommon).JsonToPlist("User.DHCEQPLATCProduct",JsonData,.PLIST)
        
        &SQL(Update sqluser.DHC_EQPLATCProduct values :PLIST() where P_RowID=:PRowID)
        i SQLCODE=100 s SQLCODE=0
        If SQLCODE
        {
            TROLLBACK
            Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
        }
        
        s AIPLIST=##Class(web.DHCEQ.Plat.LIBCommon).JsonToPlist("User.DHCEQPLATCAssetItem",JsonData,.AIPLIST)
        &SQL(Update sqluser.DHC_EQPLATCAssetItem values :AIPLIST() where AI_RowID=:PAssetItemDR)
        i SQLCODE=100 s SQLCODE=0
        If SQLCODE
        {
            TROLLBACK
            Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
        }
    }
        TCOMMIT
    q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(0,PRowID)
    
ERRORProductEdit
    TROLLBACK
    s ErrorMsg=$ZE
    Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(ErrorMsg)
}

/// add by mwz0065 20221202
/// 入参:Desc：产品名称   ModelDR:机型ID  ManufactoryDR：厂商ID
/// 输出：AllowFlag ：0 允许 其他：不允许
/// 黑白名单控制
/// w ##class(web.DHCEQ.Plat.CTProduct).CheckAllowFlag("微量泵",338,5)
ClassMethod CheckAllowFlag(Desc, ModelDR, ManufactoryDR)
{
    s IfAllowFlag=##class(web.DHCEQCommon).GetSysInfo("201018")  //黑白名单 启用1   停用0或空  

    &SQL(select P_AllowFlag into :AllowFlag from sqluser.DHC_EQPLATCProduct where P_Desc=:Desc  and (P_ManufactoryDR=:ManufactoryDR or P_ManufactoryDR is null ) and (P_Models=:ModelDR or P_Models is null ) and P_InvalidFlag<>'Y')  //MODIFY BY MWZ10 MWZ0068
    if (IfAllowFlag=1)&&(AllowFlag'=0)
    {
        i AllowFlag
        q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(-1,"仅允许录入白名单设备!")
    }
    else
    {  
        
        q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(0,AllowFlag)
    }
}

/// add by mwz0065 20221202
/// 入参:Desc：产品名称   ModelDR:机型ID  ManufactoryDR：厂商ID
/// 输出：限定单价
/// 产品单价限制
/// w ##class(web.DHCEQ.Plat.CTProduct).CheckPriceFlag(24)
ClassMethod CheckPriceFlag(Desc, ModelDR, ManufactoryDR)
{
    s PriceFlag=##class(web.DHCEQCommon).GetSysInfo("201019")  //限制单价 限制1   不限制0或空  

    &SQL(select P_QuotePrice into :Price from sqluser.DHC_EQPLATCProduct where P_Desc=:Desc  and (P_ManufactoryDR=:ManufactoryDR or P_ManufactoryDR is null ) and (P_Models=:ModelDR or P_Models is null ) and P_InvalidFlag<>'Y')  //MODIFY BY MWZ10 MWZ0068
    if (PriceFlag=1)&&(Price="")
    {
        i Price
        q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(-1,"请在产品库界面维护单价!")
    }
    else
    {  
    
        q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(0,Price)
    }
}

/// add by mwz0065 20221202
/// 入参:Desc：产品名称   ModelDR:机型ID  ManufactoryDR：厂商ID
/// 输出：产品ID
/// 查找产品
/// w ##class(web.DHCEQ.Plat.CTProduct).GetProductInfo("微量泵","1","3")
ClassMethod GetProductInfo(Desc, ModelDR, ManufactoryDR)
{
    s rowid=""
    &SQL(select P_RowID into :rowid from sqluser.DHC_EQPLATCProduct where P_Desc=:Desc  and (P_ManufactoryDR=:ManufactoryDR or P_ManufactoryDR is null ) and (P_Models=:ModelDR or P_Models is null ) and P_InvalidFlag<>'Y')  //MODIFY BY MWZ 2020-04-13 MWZ0034
    if (rowid="")
    {
        q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(-1,"没有找到产品")
    }
    else
    {  
        q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(0,rowid)
    }
}

/// add by mwz0065 20221202
/// 入参:PRowID 产品ID
/// 输出：产品限价
/// 获取产品限价
/// w ##class(web.DHCEQ.Plat.CTProduct).GetQuotePrice("3")
ClassMethod GetQuotePrice(PRowID)
{
   s QuotePrice=$P($g(^DHCEQCTPLAT("Product",PRowID)),"^",21)
   q QuotePrice
}

}
