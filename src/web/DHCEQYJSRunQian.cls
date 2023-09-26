Class web.DHCEQYJSRunQian Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Add By DJ 2014-04-19
/// 弋矶山设备快照查询
ClassMethod SnapEquipClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SnapEquipExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)

    Quit $$$OK
}

ClassMethod SnapEquipExecute(ByRef qHandle As %Binary, MonthStr As %String = "", QXType As %String = "", vUseLoc As %String = "", vUseLocDR As %String = "", EquipType As %String = "", EquipTypeDR As %String = "", FundsType As %String = "", FundsTypeDR As %String = "", OutLayType As %String = "", OutLayTypeDR As %String = "", vStatus As %String = "", EquipNo As %String = "", OldEquipNo As %String = "", CurGroupID As %String = "", CurLocID As %String = "", DisUseFlag As %String = "", DisUseSDate As %String = "", DisUseEDate As %String = "", vEquipName As %String = "", vModel As %String = "", vUnit As %String = "", vOriginalFee As %String = "") As %Status
{
    new repid, index,rowid
    Set repid=$I(^CacheTemp)
    Set qHandle=$lb(0,repid,0)
    s index=1
    
    i DisUseFlag'="" s MonthStr=$E($ZD(+$H,3),1,7)
    i (MonthStr="") Quit $$$OK
    i EquipType="" s EquipTypeDR=""
    //i vUseLoc="" s vUseLocDR=""
    i FundsType="" s FundsTypeDR=""
    i OutLayType="" s OutLayTypeDR=""
    i DisUseSDate=""  d
    .s vDisUseSDate=0
    e  d
    .;s vDisUseSDate=$ZDH(DisUseSDate,3)
    .;日期格式统一调整    Modify by CSY 2017-03-02
    .s vDisUseSDate=##Class(web.DHCEQCommon).TransValueFromPage(DisUseSDate,"date")
    i DisUseEDate=""  d
    .s vDisUseEDate=+$H
    e  d
    .;s vDisUseEDate=$ZDH(DisUseEDate,3)
    .;日期格式统一调整    Modify by CSY 2017-03-02
    .s vDisUseEDate=##Class(web.DHCEQCommon).TransValueFromPage(DisUseEDate,"date")
    
    s SnapID=##Class(web.DHCEQSnapShot).GetSnapIDByMonth(MonthStr)
    i DisUseFlag'="" s SnapID=""
    s RowID=0
    i SnapID=""  d
    .f  s RowID=$o(^DHCEQEquip(RowID))  q:RowID=""  d
    ..d ResetVariablesGetSnapEquip
    ..s InvalidFlag=$p($g(^DHCEQEquip(RowID)),"^",59)
    ..q:InvalidFlag="Y"
    ..s EQStoreLocDR=$p($g(^DHCEQEquip(RowID)),"^",67)  //设备库房
    ..q:(vUseLocDR'="")&&(EQStoreLocDR'=vUseLocDR)
    ..s EQEquipTypeDR=$p($g(^DHCEQEquip(RowID)),"^",63) //设备类组
    ..q:(EquipTypeDR'="")&&(EquipTypeDR'=EQEquipTypeDR)
    ..q:(##Class(web.DHCEQCommon).EquipTypeIsIn(EQEquipTypeDR,CurGroupID))
    ..s EQOriginalFee=$p($g(^DHCEQEquip(RowID)),"^",27) //设备原值
    ..q:(vOriginalFee'="")&&(vOriginalFee'=$FN(EQOriginalFee,"",2))  //modify by GBX 2015-02-26 10:10:38
    ..s EQStatus=$p($g(^DHCEQEquip(RowID)),"^",38)
    ..s EQStockStatus=$p($g(^DHCEQEquip(RowID)),"^",60)
    ..q:'((EQStockStatus="1")&&(EQStatus<=2))&&(DisUseFlag="")
    ..q:(DisUseFlag'="")&&(EQStatus'=3)
    ..s TDisUseDate=$p($g(^DHCEQEquip(RowID)),"^",89)
    ..q:(DisUseFlag'="")&&(vDisUseSDate'="")&&(TDisUseDate<vDisUseSDate)
    ..q:(DisUseFlag'="")&&(vDisUseEDate'="")&&(TDisUseDate>vDisUseEDate)
    ..q:(vStatus=1)&&(EQStatus'=1)
    ..q:(vStatus=2)&&(EQStatus=1)
    ..;i TDisUseDate'="" s TDisUseDate=$ZD(TDisUseDate,3)
    ..;日期格式统一调整    Modify by CSY 2017-03-02
    ..s TDisUseDate=##Class(web.DHCEQCommon).TransValueToPage(TDisUseDate,"date")
    ..s TRowID=RowID
    ..s TEQNo=$p($g(^DHCEQEquip(RowID)),"^",71)     //设备编号
    ..q:(EquipNo'="")&&(TEQNo'=EquipNo)
    ..s TOldEquipNo=$p($g(^DHCEQEquip(RowID)),"^",91)
    ..q:(OldEquipNo'="")&&(TOldEquipNo'=OldEquipNo)
    ..s TBrandDR=$p($g(^DHCEQEquip(RowID)),"^",94)
    ..i TBrandDR'="" s TBrand=$p($g(^DHCEQCCode("DHCEQCBrand",TBrandDR)),"^",3)
    ..s TOutLayTypeDR=$p($g(^DHCEQEquip(RowID)),"^",95)
    ..q:(OutLayTypeDR'="")&&(TOutLayTypeDR'=OutLayTypeDR)
    ..i TOutLayTypeDR'="" s TOutLayType=$p($g(^DHCEQCCode("DHCEQCOutLayType",TOutLayTypeDR)),"^",2)
    ..s TEquipName=$p($g(^DHCEQEquip(RowID)),"^",1) //设备名称
    ..q:(vEquipName'="")&&(vEquipName'=TEquipName)  //modify by GBX 2015-02-26 10:10:38
    ..s TModel=$p($g(^DHCEQEquip(RowID)),"^",3)     //规格型号
    ..i TModel'="" s TModel=$p($g(^DHCEQCCode("DHCEQCModel",TModel)),"^",2)
    ..q:(vModel'="")&&(vModel'=TModel)  //modify by GBX 2015-02-26 10:10:38
    ..s TUseLoc=$p($g(^DHCEQEquip(RowID)),"^",67)   //使用科室
    ..q:(vUseLocDR'="")&&(vUseLocDR'=TUseLoc)
    ..;i TUseLoc'="" s TUseLocCode=$p($g(^CTLOC(TUseLoc)),"^",1)   //modify by jyp 2019-10-18 CTLOC调整
    ..i TUseLoc'="" s TUseLocCode=##class(web.DHCEQCommon).GetTrakNameByID("deptcode",TUseLoc)  //modify by jyp 2019-10-18 CTLOC调整
    ..i TUseLoc'="" s TUseLoc=##class(web.DHCEQCommon).GetTrakNameByID("dept",TUseLoc)
    ..q:(vUseLoc'="")&&(vUseLoc'=TUseLoc)
    ..s TOriginalFee=$fn($p($g(^DHCEQEquip(RowID)),"^",27),"",2) //设备原值
    ..s TStatCatDR=$p($g(^DHCEQEquip(RowID)),"^",75)        //设备类型
    ..i TStatCatDR'="" s TStatCat=$p($g(^DHCEQCCode("DHCEQCStatCat",TStatCatDR)),"^",2)
    ..;s TEquipCatDR=$p($g(^DHCEQEquip(RowID)),"^",4)       //设备分类
    ..;i TEquipCatDR'=""  d
    ..;.s TEquipCatCode=$p($g(^DHCEQCCode("DHCEQCEquipeCat",TEquipCatDR)),"^",1)
    ..;.s TEquipCat=$p($g(^DHCEQCCode("DHCEQCEquipeCat",TEquipCatDR)),"^",2)
    ..s ItemDR=$p($g(^DHCEQEquip(RowID)),"^",7)
    ..s TEquipCatDR=$p($g(^DHCEQCCode("DHCEQCMasterItem",ItemDR)),"^",10)
    ..i TEquipCatDR'=""  d
    ...s TNewEquipCatCode=$p($g(^DHCEQCCode("DHCEQCEquipeCat",TEquipCatDR)),"^",1)
    ...s TNewEquipCat=$p($g(^DHCEQCCode("DHCEQCEquipeCat",TEquipCatDR)),"^",2)
    ...s TEquipCatCode=$p($g(^DHCEQCCode("DHCEQCTree",TEquipCatDR)),"^",2)
    ...s TEquipCat=$p($g(^DHCEQCCode("DHCEQCTree",TEquipCatDR)),"^",3)
    ..i EQEquipTypeDR'="" s TEquipType=$p($g(^DHCEQCCode("DHCEQCEquipType",EQEquipTypeDR)),"^",2)
    ..s TLimitYearsNum=$p($g(^DHCEQEquip(RowID)),"^",31)    //使用年限
    ..s TNetFee=$fn($p($g(^DHCEQEquip(RowID)),"^",28),"",2)     //净值
    ..s TDepreTotalFee=$fn($p($g(^DHCEQEquip(RowID)),"^",35),"",2)  //累计折旧
    ..s TManuFactoryDR=$p($g(^DHCEQEquip(RowID)),"^",26)    //生产厂家
    ..i TManuFactoryDR'=""  d
    ...s TManuFactory=$p($g(^DHCEQCCode("DHCEQCManufacturer",TManuFactoryDR)),"^",1)
    ...s TManuFactory=##Class(web.DHCEQCommon).GetSplitDataByFlag(TManuFactory,"-")
    ..s TUnitDR=$p($g(^DHCEQEquip(RowID)),"^",5)            //单位
    ..i TUnitDR'="" s TUnit=##Class(web.DHCEQCommon).GetTrakNameByID("uom",TUnitDR)
    ..q:(vUnit'="")&&(vUnit'=TUnit)  //modify by GBX 2015-02-26 10:10:38
    ..s TProviderDR=$p($g(^DHCEQEquip(RowID)),"^",25)   //供应商
    ..i TProviderDR'=""  d
    ...s TProvider=##Class(web.DHCEQCommon).GetTrakNameByID("prov",TProviderDR)
    ...s TProvider=##Class(web.DHCEQCommon).GetSplitDataByFlag(TProvider,"-")
    ..i EQStatus=0 s TStatus="新增"
    ..i EQStatus=1 s TStatus="启用"
    ..i EQStatus=2 s TStatus="封存"
    ..s TCode=$p($g(^DHCEQEquip(RowID)),"^",6)      //编码(拼音码)
    ..s TLeaveFactoryNo=$p($g(^DHCEQEquip(RowID)),"^",10)   //出厂编号
    ..s TLeaveFactoryDate=$p($g(^DHCEQEquip(RowID)),"^",11) //出厂日期
    ..;i TLeaveFactoryDate'="" s TLeaveFactoryDate=$ZD(TLeaveFactoryDate,3)
    ..;日期格式统一调整    Modify by CSY 2017-03-02
    ..s TLeaveFactoryDate=##Class(web.DHCEQCommon).TransValueToPage(TLeaveFactoryDate,"date")
    ..s TOpenCheckDate=$p($g(^DHCEQEquip(RowID)),"^",12)        //开箱日期
    ..;i TOpenCheckDate'="" s TOpenCheckDate=$ZD(TOpenCheckDate,3)
    ..;日期格式统一调整    Modify by CSY 2017-03-02
    ..s TOpenCheckDate=##Class(web.DHCEQCommon).TransValueToPage(TOpenCheckDate,"date")
    ..s TCheckDate=$p($g(^DHCEQEquip(RowID)),"^",13)            //验收日期
    ..;i TCheckDate'="" s TCheckDate=$ZD(TCheckDate,3)
    ..;日期格式统一调整    Modify by CSY 2017-03-02
    ..s TCheckDate=##Class(web.DHCEQCommon).TransValueToPage(TCheckDate,"date")
    ..s TCountryDR=$p($g(^DHCEQEquip(RowID)),"^",16)            //国别
    ..i TCountryDR'="" s TCountry=##Class(web.DHCEQCommon).GetTrakNameByID("cou",TCountryDR)
    ..s TOriginDR=$p($g(^DHCEQEquip(RowID)),"^",20)         //来源
    ..i TOriginDR'="" s TOrigin=$p($g(^DHCEQCCode("DHCEQCOrigin",TOriginDR)),"^",2)
    ..s TRemark=$p($g(^DHCEQEquip(RowID)),"^",34)           //备注
    ..s TDepreMethodDR=$p($g(^DHCEQEquip(RowID)),"^",33)        //折旧方法
    ..i TDepreMethodDR'="" s TDepreMethod=$p($g(^DHCEQCCode("DHCEQCDepreMethod",TDepreMethodDR)),"^",2)
    ..s TManageUserDR=$p($g(^DHCEQEquip(RowID)),"^",39)     //管理员
    ..i TManageUserDR'="" s TManageUser=##Class(web.DHCEQCommon).GetTrakNameByID("user",TManageUserDR)
    ..s TStartDate=$p($g(^DHCEQEquip(RowID)),"^",44)            //启用日期
    ..;i TStartDate'="" s TStartDate=$ZD(TStartDate,3)
    ..;日期格式统一调整    Modify by CSY 2017-03-02
    ..s TStartDate=##Class(web.DHCEQCommon).TransValueToPage(TStartDate,"date")
    ..s TTransAssetDate=$p($g(^DHCEQEquip(RowID)),"^",45)   //转资日期
    ..;i TTransAssetDate'="" s TTransAssetDate=$ZD(TTransAssetDate,3)
    ..;日期格式统一调整    Modify by CSY 2017-03-02
    ..s TTransAssetDate=##Class(web.DHCEQCommon).TransValueToPage(TTransAssetDate,"date")
    ..s TKeeperDR=$p($g(^DHCEQEquip(RowID)),"^",66)         //保管人
    ..i TKeeperDR'="" s TKeeper=##Class(web.DHCEQCommon).GetTrakNameByID("user",TKeeperDR)
    ..s TQuantityNum="1"
    ..s FTRowID=0
    ..f  s FTRowID=$o(^DHCEQCCode("DHCEQCFundsType",FTRowID))  q:FTRowID=""  d
    ...s TFundsType=$p($g(^DHCEQCCode("DHCEQCFundsType",FTRowID)),"^",2)
    ...s TFundsFee=$fn(##Class(web.DHCEQFunds).GetFundsAmountByFromID(1,RowID,FTRowID,""),"",2)
    ...q:TFundsFee<=0
    ...d OutputRowGetSnapEquip
    e  d
    .f  s RowID=$o(^DHCEQSnapShot(SnapID,"Equip",RowID))  q:RowID=""  d
    ..d ResetVariablesGetSnapEquip
    ..s InvalidFlag=$p($g(^DHCEQSnapShot(SnapID,"Equip",RowID)),"^",59)
    ..q:InvalidFlag="Y"
    ..s EQStoreLocDR=$p($g(^DHCEQSnapShot(SnapID,"Equip",RowID)),"^",67)    //设备库房
    ..q:(vUseLocDR'="")&&(EQStoreLocDR'=vUseLocDR)
    ..s EQEquipTypeDR=$p($g(^DHCEQSnapShot(SnapID,"Equip",RowID)),"^",63)   //设备类组
    ..q:(EquipTypeDR'="")&&(EquipTypeDR'=EQEquipTypeDR)
    ..q:(##Class(web.DHCEQCommon).EquipTypeIsIn(EQEquipTypeDR,CurGroupID))
    ..s EQOriginalFee=$p($g(^DHCEQSnapShot(SnapID,"Equip",RowID)),"^",27)   //设备原值
    ..q:(vOriginalFee'="")&&(vOriginalFee'=$FN(EQOriginalFee,"",2))  //modify by GBX 2015-02-26 10:10:38
    ..s EQStatus=$p($g(^DHCEQSnapShot(SnapID,"Equip",RowID)),"^",38)
    ..s EQStockStatus=$p($g(^DHCEQSnapShot(SnapID,"Equip",RowID)),"^",60)
    ..q:'((EQStockStatus="1")&&(EQStatus<=2))
    ..q:(vStatus=1)&&(EQStatus'=1)
    ..q:(vStatus=2)&&(EQStatus=1)
    ..s TRowID=RowID
    ..s TEQNo=$p($g(^DHCEQSnapShot(SnapID,"Equip",RowID)),"^",71)       //设备编号
    ..q:(EquipNo'="")&&(TEQNo'=EquipNo)
    ..s TOldEquipNo=$p($g(^DHCEQSnapShot(SnapID,"Equip",RowID)),"^",91)
    ..q:(OldEquipNo'="")&&(TOldEquipNo'=OldEquipNo)
    ..s TBrandDR=$p($g(^DHCEQSnapShot(SnapID,"Equip",RowID)),"^",94)
    ..i TBrandDR'="" s TBrand=$p($g(^DHCEQCCode("DHCEQCBrand",TBrandDR)),"^",3)
    ..s TOutLayTypeDR=$p($g(^DHCEQSnapShot(SnapID,"Equip",RowID)),"^",95)
    ..q:(OutLayTypeDR'="")&&(TOutLayTypeDR'=OutLayTypeDR)
    ..i TOutLayTypeDR'="" s TOutLayType=$p($g(^DHCEQCCode("DHCEQCOutLayType",TOutLayTypeDR)),"^",2)
    ..s TEquipName=$p($g(^DHCEQSnapShot(SnapID,"Equip",RowID)),"^",1)   //设备名称
    ..q:(vEquipName'="")&&(vEquipName'=TEquipName)  //modify by GBX 2015-02-26 10:10:38
    ..s TModel=$p($g(^DHCEQSnapShot(SnapID,"Equip",RowID)),"^",3)       //规格型号
    ..i TModel'="" s TModel=$p($g(^DHCEQSnapShot(SnapID,"Equip",RowID,"EX")),"^",2)
    ..q:(vModel'="")&&(vModel'=TModel)  //modify by GBX 2015-02-26 10:10:38
    ..s TUseLoc=$p($g(^DHCEQSnapShot(SnapID,"Equip",RowID)),"^",67) //使用科室
    ..q:(vUseLocDR'="")&&(vUseLocDR'=TUseLoc)
    ..;i TUseLoc'="" s TUseLocCode=$p($g(^CTLOC(TUseLoc)),"^",1)   //modify by jyp 2019-10-18 CTLOC调整
    ..i TUseLoc'="" s TUseLocCode=##class(web.DHCEQCommon).GetTrakNameByID("deptcode",TUseLoc)   //modify by jyp 2019-10-18 CTLOC调整
    ..i TUseLoc'="" s TUseLoc=##class(web.DHCEQCommon).GetTrakNameByID("dept",TUseLoc)
    ..q:(vUseLoc'="")&&(vUseLoc'=TUseLoc)
    ..s TOriginalFee=$fn($p($g(^DHCEQSnapShot(SnapID,"Equip",RowID)),"^",27),"",2) //设备原值
    ..s TStatCatDR=$p($g(^DHCEQSnapShot(SnapID,"Equip",RowID)),"^",75)      //设备类型
    ..i TStatCatDR'="" s TStatCat=$p($g(^DHCEQCCode("DHCEQCStatCat",TStatCatDR)),"^",2)
    ..;s TEquipCatDR=$p($g(^DHCEQSnapShot(SnapID,"Equip",RowID)),"^",4)     //设备分类
    ..;i TEquipCatDR'=""  d
    ..;.s TEquipCatCode=$p($g(^DHCEQCCode("DHCEQCEquipeCat",TEquipCatDR)),"^",1)
    ..;.s TEquipCat=$p($g(^DHCEQCCode("DHCEQCEquipeCat",TEquipCatDR)),"^",2)
    ..s ItemDR=$p($g(^DHCEQSnapShot(SnapID,"Equip",RowID)),"^",7)
    ..s TEquipCatDR=$p($g(^DHCEQCCode("DHCEQCMasterItem",ItemDR)),"^",10)
    ..i TEquipCatDR'=""  d
    ...s TNewEquipCatCode=$p($g(^DHCEQCCode("DHCEQCEquipeCat",TEquipCatDR)),"^",1)
    ...s TNewEquipCat=$p($g(^DHCEQCCode("DHCEQCEquipeCat",TEquipCatDR)),"^",2)
    ...s TEquipCatCode=$p($g(^DHCEQCCode("DHCEQCTree",TEquipCatDR)),"^",2)
    ...s TEquipCat=$p($g(^DHCEQCCode("DHCEQCTree",TEquipCatDR)),"^",3)
    ..i EQEquipTypeDR'="" s TEquipType=$p($g(^DHCEQCCode("DHCEQCEquipType",EQEquipTypeDR)),"^",2)
    ..s TLimitYearsNum=$p($g(^DHCEQSnapShot(SnapID,"Equip",RowID)),"^",31)  //使用年限
    ..s TNetFee=$fn($p($g(^DHCEQSnapShot(SnapID,"Equip",RowID)),"^",28),"",2)       //净值
    ..s TDepreTotalFee=$fn($p($g(^DHCEQSnapShot(SnapID,"Equip",RowID)),"^",35),"",2)    //累计折旧
    ..s TManuFactoryDR=$p($g(^DHCEQSnapShot(SnapID,"Equip",RowID)),"^",26)  //生产厂家
    ..i TManuFactoryDR'=""  d
    ...s TManuFactory=$p($g(^DHCEQCCode("DHCEQCManufacturer",TManuFactoryDR)),"^",1)
    ...s TManuFactory=##Class(web.DHCEQCommon).GetSplitDataByFlag(TManuFactory,"-")
    ..s TUnitDR=$p($g(^DHCEQSnapShot(SnapID,"Equip",RowID)),"^",5)          //单位
    ..i TUnitDR'="" s TUnit=##Class(web.DHCEQCommon).GetTrakNameByID("uom",TUnitDR)
    ..q:(vUnit'="")&&(vUnit'=TUnit)  //modify by GBX 2015-02-26 10:10:38
    ..s TProviderDR=$p($g(^DHCEQSnapShot(SnapID,"Equip",RowID)),"^",25) //供应商
    ..i TProviderDR'=""  d
    ...s TProvider=##Class(web.DHCEQCommon).GetTrakNameByID("prov",TProviderDR)
    ...s TProvider=##Class(web.DHCEQCommon).GetSplitDataByFlag(TProvider,"-")
    ..i EQStatus=0 s TStatus="新增"
    ..i EQStatus=1 s TStatus="启用"
    ..i EQStatus=2 s TStatus="封存"
    ..s TCode=$p($g(^DHCEQSnapShot(SnapID,"Equip",RowID)),"^",6)        //编码(拼音码)
    ..s TLeaveFactoryNo=$p($g(^DHCEQSnapShot(SnapID,"Equip",RowID)),"^",10) //出厂编号
    ..s TLeaveFactoryDate=$p($g(^DHCEQSnapShot(SnapID,"Equip",RowID)),"^",11)   //出厂日期
    ..;i TLeaveFactoryDate'="" s TLeaveFactoryDate=$ZD(TLeaveFactoryDate,3)
    ..;日期格式统一调整    Modify by CSY 2017-03-02
    ..s TLeaveFactoryDate=##Class(web.DHCEQCommon).TransValueToPage(TLeaveFactoryDate,"date")
    ..s TOpenCheckDate=$p($g(^DHCEQSnapShot(SnapID,"Equip",RowID)),"^",12)      //开箱日期
    ..;i TOpenCheckDate'="" s TOpenCheckDate=$ZD(TOpenCheckDate,3)
    ..;日期格式统一调整    Modify by CSY 2017-03-02
    ..s TOpenCheckDate=##Class(web.DHCEQCommon).TransValueToPage(TOpenCheckDate,"date")
    ..s TCheckDate=$p($g(^DHCEQSnapShot(SnapID,"Equip",RowID)),"^",13)          //验收日期
    ..;i TCheckDate'="" s TCheckDate=$ZD(TCheckDate,3)
    ..;日期格式统一调整    Modify by CSY 2017-03-02
    ..s TCheckDate=##Class(web.DHCEQCommon).TransValueToPage(TCheckDate,"date")
    ..s TCountryDR=$p($g(^DHCEQSnapShot(SnapID,"Equip",RowID)),"^",16)          //国别
    ..i TCountryDR'="" s TCountry=##Class(web.DHCEQCommon).GetTrakNameByID("cou",TCountryDR)
    ..s TOriginDR=$p($g(^DHCEQSnapShot(SnapID,"Equip",RowID)),"^",20)           //来源
    ..i TOriginDR'="" s TOrigin=$p($g(^DHCEQCCode("DHCEQCOrigin",TOriginDR)),"^",2)
    ..s TRemark=$p($g(^DHCEQSnapShot(SnapID,"Equip",RowID)),"^",34)         //备注
    ..s TDepreMethodDR=$p($g(^DHCEQSnapShot(SnapID,"Equip",RowID)),"^",33)      //折旧方法
    ..i TDepreMethodDR'="" s TDepreMethod=$p($g(^DHCEQCCode("DHCEQCDepreMethod",TDepreMethodDR)),"^",2)
    ..s TManageUserDR=$p($g(^DHCEQSnapShot(SnapID,"Equip",RowID)),"^",39)       //管理员
    ..i TManageUserDR'="" s TManageUser=##Class(web.DHCEQCommon).GetTrakNameByID("user",TManageUserDR)
    ..s TStartDate=$p($g(^DHCEQSnapShot(SnapID,"Equip",RowID)),"^",44)          //启用日期
    ..;i TStartDate'="" s TStartDate=$ZD(TStartDate,3)
    ..;日期格式统一调整    Modify by CSY 2017-03-02
    ..s TStartDate=##Class(web.DHCEQCommon).TransValueToPage(TStartDate,"date")
    ..s TTransAssetDate=$p($g(^DHCEQSnapShot(SnapID,"Equip",RowID)),"^",45) //转资日期
    ..;i TTransAssetDate'="" s TTransAssetDate=$ZD(TTransAssetDate,3)
    ..;日期格式统一调整    Modify by CSY 2017-03-02
    ..s TTransAssetDate=##Class(web.DHCEQCommon).TransValueToPage(TTransAssetDate,"date")
    ..s TKeeperDR=$p($g(^DHCEQSnapShot(SnapID,"Equip",RowID)),"^",66)           //保管人
    ..i TKeeperDR'="" s TKeeper=##Class(web.DHCEQCommon).GetTrakNameByID("user",TKeeperDR)
    ..s TQuantityNum="1"
    ..s FRowID=0
    ..f  s FRowID=$o(^DHCEQSnapShot(SnapID,"Funds",RowID,FRowID))  q:FRowID=""  d
    ...s FTFundsType=$p($g(^DHCEQSnapShot(SnapID,"Funds",RowID,FRowID)),"^",2)
    ...i FTFundsType'="" s TFundsType=$p($g(^DHCEQCCode("DHCEQCFundsType",FTFundsType)),"^",2)
    ...s TFundsFee=$p($g(^DHCEQSnapShot(SnapID,"Funds",RowID,FRowID)),"^",3)
    ...q:TFundsFee<=0
    ...d OutputRowGetSnapEquip

    Quit $$$OK
OutputRowGetSnapEquip
    s Data=$lb(TRowID,TEQNo,TEquipName,TModel,TUseLoc,TEquipType,TStatCat,TEquipCatCode,TEquipCat,TOriginalFee,TLimitYearsNum,TNetFee,TDepreTotalFee,TManuFactory,TUnit,TProvider,TStatus,TCode,TLeaveFactoryNo,TLeaveFactoryDate,TOpenCheckDate,TCheckDate,TCountry,TOrigin,TRemark,TDepreMethod,TManageUser,TStartDate,TTransAssetDate,TKeeper,TQuantityNum,TOldEquipNo,TBrand,TOutLayType,TFundsType,TFundsFee,TDisUseDate,TNewEquipCatCode,TNewEquipCat,EQEquipTypeDR,TUseLocCode)
    Set ^CacheTemp(repid,index)=Data
    Set index=index+1
    quit
ResetVariablesGetSnapEquip
    s (TRowID,TInStockListDR,TEQNo,TEquipName,TModel,TUseLoc,TEquipType,TStatCat,TEquipCatCode,TEquipCat,TOriginalFee,TLimitYearsNum,TNetFee,TDepreTotalFee,TManuFactory,TUnit,TProvider,TStatus,TCode,TLeaveFactoryNo,TLeaveFactoryDate,TOpenCheckDate,TCheckDate,TCountry,TOrigin,TRemark,TDepreMethod,TManageUser,TStartDate,TTransAssetDate,TKeeper,TQuantityNum,TOldEquipNo,TBrand,TOutLayType,TFundsType,TFundsFee,TDisUseDate,TNewEquipCatCode,TNewEquipCat,EQEquipTypeDR,TUseLocCode)=""
    quit
}

ClassMethod SnapEquipFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SnapEquipExecute ]
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

Query SnapEquip(MonthStr As %String = "", QXType As %String = "", UseLoc As %String = "", UseLocDR As %String = "", EquipType As %String = "", EquipTypeDR As %String = "", FundsType As %String = "", FundsTypeDR As %String = "", OutLayType As %String = "", OutLayTypeDR As %String = "", vStatus As %String = "", EquipNo As %String = "", OldEquipNo As %String = "", CurGroupID As %String = "", CurLocID As %String = "", DisUseFlag As %String = "", DisUseSDate As %String = "", DisUseEDate As %String = "", vEquipName As %String = "", vModel As %String = "", vUnit As %String = "", vOriginalFee As %String = "") As %Query(ROWSPEC = "TRowID:%String,TEQNo:%String,TEquipName:%String,TModel:%String,TUseLoc:%String,TEquipType:%String,TStatCat:%String,TEquipCatCode:%String,TEquipCat:%String,TOriginalFee:%String,TLimitYearsNum:%String,TNetFee:%String,TDepreTotalFee:%String,TManuFactory:%String,TUnit:%String,TProvider:%String,TStatus:%String,TCode:%String,TLeaveFactoryNo:%String,TLeaveFactoryDate:%String,TOpenCheckDate:%String,TCheckDate:%String,TCountry:%String,TOrigin:%String,TRemark:%String,TDepreMethod:%String,TManageUser:%String,TStartDate:%String,TTransAssetDate:%String,TKeeper:%String,TQuantityNum:%String,TOldEquipNo:%String,TBrand:%String,TOutLayType:%String,TFundsType:%String,TFundsFee:%String,TDisUseDate:%String,TNewEquipCatCode:%String,TNewEquipCat:%String,EQEquipTypeDR:%String,TUseLocCode:%String") [ SqlProc ]
{
}

/*****************************************************************/
/// ADD By DJ 2014-04-19
/// 入库明细
ClassMethod InStockDetailClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = InStockDetailExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)

    Quit $$$OK
}

ClassMethod InStockDetailExecute(ByRef qHandle As %Binary, vStartDate As %String = "", vEndDate As %String = "", QXType As %String = "", EquipType As %String = "", EquipTypeDR As %String = "", CurGroupID As %String = "", CurLocID As %String = "") As %Status
{
    new repid, index,rowid
    Set repid=$I(^CacheTemp)
    Set qHandle=$lb(0,repid,0)
    s index=1
    
    i ((vStartDate="")&&(vEndDate="")) Quit $$$OK
    
    i EquipType="" s EquipTypeDR=""
    i vStartDate=""  d
    .s BeginDate=0
    e  d
    .;s BeginDate=$ZDH(vStartDate,3)-1
    .;日期格式统一调整    Modify by CSY 2017-03-02
    .s BeginDate=##Class(web.DHCEQCommon).TransValueFromPage(vStartDate,"date")-1
    i vEndDate=""  d
    .s EndDate=+$H
    e  d
    .;s EndDate=$ZDH(vEndDate,3)
    .;日期格式统一调整    Modify by CSY 2017-03-02
    .s EndDate=##Class(web.DHCEQCommon).TransValueFromPage(vEndDate,"date")
   
    s StockDate=BeginDate
    f  s StockDate=$o(^DHCEQInStock(0,"BillDate",StockDate)) q:((StockDate="")||(StockDate>EndDate))  d
    .s StatCatDR=""
    .f  s StatCatDR=$o(^DHCEQInStock(0,"BillDate",StockDate,StatCatDR)) q:StatCatDR=""  d
    ..s ISRowID=0       //入库单rowID
    ..f  s ISRowID=$o(^DHCEQInStock(0,"BillDate",StockDate,StatCatDR,ISRowID)) q:ISRowID=""  d
    ...d ResetVariablesGetInStockDetail
    ...s InStockNo=$p($g(^DHCEQInStock(ISRowID)),"^",14)
    ...q:InStockNo=""
    ...s vendorid=$p($g(^DHCEQInStock(ISRowID)),"^",17)
    ...q:vendorid=""
    ...s ISStatus=$p($g(^DHCEQInStock(ISRowID)),"^",10)
    ...q:ISStatus'=2
    ...s TEquipTypeDR=$p($g(^DHCEQInStock(ISRowID)),"^",20)
    ...q:(##Class(web.DHCEQCommon).EquipTypeIsIn(TEquipTypeDR,CurGroupID))
    ...s TInStockNo=$p($g(^DHCEQInStock(ISRowID)),"^",14)
    ...s TInDate=$p($g(^DHCEQInStock(ISRowID)),"^",1)
    ...;i TInDate'="" s TInDate=$ZD(TInDate,3)
    ...;日期格式统一调整    Modify by CSY 2017-03-02
    ...s TInDate=##Class(web.DHCEQCommon).TransValueToPage(TInDate,"date")
    ...s TActDate=$p($g(^DHCEQInStock(ISRowID)),"^",13)
    ...;i TActDate'="" s TActDate=$ZD(TActDate,3)
    ...;日期格式统一调整    Modify by CSY 2017-03-02
    ...s TActDate=##Class(web.DHCEQCommon).TransValueToPage(TActDate,"date")
    ...s TStorLocDR=$p($g(^DHCEQInStock(ISRowID)),"^",2)
    ...;i TStorLocDR'="" s TStorLoc=##Class(web.DHCEQCommon).GetSplitDataByFlag($p($g(^CTLOC(TStorLocDR)),"^",2),"-")  //modify by jyp 2019-10-18 CTLOC调整
    ...i TStorLocDR'="" s TStorLoc=##class(web.DHCEQCommon).GetTrakNameByID("dept",TStorLocDR)  //modify by jyp 2019-10-18 CTLOC调整
    ...s TRemark=$p($g(^DHCEQInStock(ISRowID)),"^",11)
    ...s TProvider=##class(web.DHCEQCommon).GetTrakNameByID("prov",vendorid)    //供应商
    ...i TEquipTypeDR'="" s TEquipType=$p($g(^DHCEQCCode("DHCEQCEquipType",TEquipTypeDR)),"^",2)
    ...s ISLRowID=0
    ...f  s ISLRowID=$o(^DHCEQInStockList(0,"InStock",ISRowID,ISLRowID))  q:ISLRowID=""  d
    ....s TRowID=ISLRowID
    ....s TInvoice=##Class(web.DHCEQInvoice).GetInvoiceInfos(1,ISLRowID)
    ....s TInvoiceNo=$p(TInvoice,"^",1)
    ....s TEquipName=$p($g(^DHCEQInStockList(ISLRowID)),"^",5)
    ....s TModelDR=$p($g(^DHCEQInStockList(ISLRowID)),"^",9)
    ....i TModelDR'="" s TModel=$p($g(^DHCEQCCode("DHCEQCModel",TModelDR)),"^",2)
    ....s TUnitDR=$p($g(^DHCEQInStockList(ISLRowID)),"^",10)
    ....i TUnitDR'="" s TUnit=##Class(web.DHCEQCommon).GetTrakNameByID("uom",TUnitDR)
    ....s TStatCatDR=$p($g(^DHCEQInStockList(ISLRowID)),"^",17)
    ....i TStatCatDR'="" s TStatCat=$p($g(^DHCEQCCode("DHCEQCStatCat",TStatCatDR)),"^",2)
    ....s TEquipCatDR=$p($g(^DHCEQInStockList(ISLRowID)),"^",14)
    ....i TEquipCatDR'=""  d
    .....s TEquipCat=$p($g(^DHCEQCCode("DHCEQCEquipeCat",TEquipCatDR)),"^",2)
    .....s TEquipCatCode=$p($g(^DHCEQCCode("DHCEQCEquipeCat",TEquipCatDR)),"^",1)
    ....;s ItemDR=$p($g(^DHCEQInStockList(ISLRowID)),"^",16)
    ....;s TEquipCatDR=$p($g(^DHCEQCCode("DHCEQCMasterItem",ItemDR)),"^",10)
    ....;i TEquipCatDR'=""  d
    ....;.s TEquipCatCode=$p($g(^DHCEQCCode("DHCEQCTree",TEquipCatDR)),"^",2)
    ....;.s TEquipCat=$p($g(^DHCEQCCode("DHCEQCTree",TEquipCatDR)),"^",3)
    ....;.s TEquipCat=..GetOldECCode(TEquipCatCode)
    ....s TQuantity=$p($g(^DHCEQInStockList(ISLRowID)),"^",8)
    ....s TOriginalFee=$fn($p($g(^DHCEQInStockList(ISLRowID)),"^",7),"",2)
    ....s TAmount=$fn(TQuantity*TOriginalFee,"",2)
    ....s TEquipNos=##Class(web.DHCEQCommon).GetEquipNos(ISLRowID,1)
    ....d OutputRowGetInStockDetail
    
    ;红冲记录显示 //2014-05-19 DJ
    s StockDate=BeginDate
    f  s StockDate=$o(^DHCEQReturn(0,"AckDateStat",2,StockDate)) q:((StockDate="")||(StockDate>EndDate))  d
    .s StatCatDR=""
    .f  s StatCatDR=$o(^DHCEQReturn(0,"AckDateStat",2,StockDate,StatCatDR)) q:StatCatDR=""  d
    ..s RRowID=0
    ..f  s RRowID=$o(^DHCEQReturn(0,"AckDateStat",2,StockDate,StatCatDR,RRowID)) q:RRowID=""  d
    ...d ResetVariablesGetInStockDetail
    ...s InvalidFlag=$p($g(^DHCEQReturn(RRowID)),"^",28)
    ...q:InvalidFlag="Y"
    ...s TEquipTypeDR=$p($g(^DHCEQReturn(RRowID)),"^",15)
    ...q:(##Class(web.DHCEQCommon).EquipTypeIsIn(TEquipTypeDR,CurGroupID))
    ...s TInStockNo=$p($g(^DHCEQReturn(RRowID)),"^",1)
    ...s TProvider=$p($g(^DHCEQReturn(RRowID)),"^",3)
    ...i TProvider'="" s TProvider=##class(web.DHCEQCommon).GetTrakNameByID("prov",TProvider)
    ...s TInDate=$p($g(^DHCEQReturn(RRowID)),"^",6)
    ...;i TInDate'="" s TInDate=$ZD(TInDate,3)
    ...;s TActDate=$ZD(StockDate,3)
    ...;日期格式统一调整    Modify by CSY 2017-03-02
    ...s TInDate=##Class(web.DHCEQCommon).TransValueToPage(TInDate,"date")
    ...s TActDate=##Class(web.DHCEQCommon).TransValueToPage(StockDate,"date")
    ...s RLRowID=0
    ...f  s RLRowID=$o(^DHCEQReturnList(0,"Return",RRowID,RLRowID))  q:RLRowID=""  d
    ....s TRowID=$p($g(^DHCEQReturnList(RLRowID)),"^",3)
    ....i TRowID=""  d
    .....s EQRowID=$p($g(^DHCEQReturnList(RLRowID)),"^",4)
    .....s TRowID=$p($g(^DHCEQEquip(EQRowID)),"^",70)
    .....s TEquipName=$p($g(^DHCEQEquip(EQRowID)),"^",1)
    .....s TModelDR=$p($g(^DHCEQEquip(EQRowID)),"^",3)
    .....i TModelDR'="" s TModel=$p($g(^DHCEQCCode("DHCEQCModel",TModelDR)),"^",2)
    .....s TUnitDR=$p($g(^DHCEQEquip(EQRowID)),"^",5)
    .....i TUnitDR'="" s TUnit=##Class(web.DHCEQCommon).GetTrakNameByID("uom",TUnitDR)
    .....s TEquipCatDR=$p($g(^DHCEQEquip(EQRowID)),"^",4)
    .....;s ItemDR=$p($g(^DHCEQEquip(EQRowID)),"^",7)
    .....;s TEquipCatDR=$p($g(^DHCEQCCode("DHCEQCMasterItem",ItemDR)),"^",10)
    ....e  d
    .....s TEquipName=$p($g(^DHCEQInStockList(TRowID)),"^",5)
    .....s TModelDR=$p($g(^DHCEQInStockList(TRowID)),"^",9)
    .....i TModelDR'="" s TModel=$p($g(^DHCEQCCode("DHCEQCModel",TModelDR)),"^",2)
    .....s TUnitDR=$p($g(^DHCEQInStockList(TRowID)),"^",10)
    .....i TUnitDR'="" s TUnit=##Class(web.DHCEQCommon).GetTrakNameByID("uom",TUnitDR)
    .....s TEquipCatDR=$p($g(^DHCEQInStockList(TRowID)),"^",14)
    .....;s ItemDR=$p($g(^DHCEQInStockList(TRowID)),"^",16)
    .....;s TEquipCatDR=$p($g(^DHCEQCCode("DHCEQCMasterItem",ItemDR)),"^",10)
    ....i TRowID="" s TRowID=0
    ....s TOriginalFee=$fn($p($g(^DHCEQReturnList(RLRowID)),"^",6),"",2)
    ....s TQuantity=0-$p($g(^DHCEQReturnList(RLRowID)),"^",5)
    ....s TAmount=$fn(TQuantity*TOriginalFee,"",2)
    ....s TRemark=$p($g(^DHCEQReturnList(RLRowID)),"^",9)
    ....i TEquipCatDR'=""  d
    .....s TEquipCat=$p($g(^DHCEQCCode("DHCEQCEquipeCat",TEquipCatDR)),"^",2)
    .....s TEquipCatCode=$p($g(^DHCEQCCode("DHCEQCEquipeCat",TEquipCatDR)),"^",1)
    .....;s TEquipCatCode=$p($g(^DHCEQCCode("DHCEQCTree",TEquipCatDR)),"^",2)
    .....;s TEquipCat=$p($g(^DHCEQCCode("DHCEQCTree",TEquipCatDR)),"^",3)
    .....;s TEquipCat=..GetOldECCode(TEquipCatCode)
    ....s EQRowIDs=$g(^DHCEQReturnList(RLRowID,"EX","RowIDs"))
    ....s TEquipNos=##Class(web.DHCEQCommon).GetEquipNos(EQRowIDs,0)
    ....d OutputRowGetInStockDetail
    
    Quit $$$OK
OutputRowGetInStockDetail
    s Data=$lb(TRowID,TInStockNo,TProvider,TInDate,TActDate,TEquipName,TModel,TUnit,TOriginalFee,TQuantity,TAmount,TEquipCatCode,TEquipType,TRemark,TInvoiceNo,TStoreLoc,TStatCat,TEquipCat,TEquipNos)
    Set ^CacheTemp(repid,index)=Data
    Set index=index+1
    quit
ResetVariablesGetInStockDetail
    s (TRowID,TInStockNo,TProvider,TInDate,TActDate,TEquipName,TModel,TUnit,TOriginalFee,TQuantity,TAmount,TEquipCatCode,TEquipType,TRemark,TInvoiceNo,TStoreLoc,TStatCat,TEquipCat,TEquipNos)=""
    quit
}

ClassMethod InStockDetailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = InStockDetailExecute ]
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

Query InStockDetail(vStartDate As %String = "", vEndDate As %String = "", QXType As %String = "", EquipType As %String = "", EquipTypeDR As %String = "", CurGroupID As %String = "", CurLocID As %String = "") As %Query(ROWSPEC = "TRowID:%String,TInStockNo:%String,TProvider:%String,TInDate:%String,TActDate:%String,TEquipName:%String,TModel:%String,TUnit:%String,TOriginalFee:%String,TQuantity:%String,TAmount:%String,TEquipCatCode:%String,TEquipType:%String,TRemark:%String,TInvoiceNo:%String,TStoreLoc:%String,TStatCat:%String,TEquipCat:%String,TEquipNos:%String") [ SqlProc ]
{
}

/***************************************************************************/
/// ADD By DJ 2014-04-19
/// 转移明细
ClassMethod StoreMoveDetailClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = StoreMoveDetailExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)

    Quit $$$OK
}

ClassMethod StoreMoveDetailExecute(ByRef qHandle As %Binary, vStartDate As %String = "", vEndDate As %String = "", MoveType As %String = "", QXType As %String = "", EquipType As %String = "", EquipTypeDR As %String = "", CurGroupID As %String = "", CurLocID As %String = "", vEquipName As %String = "", vModel As %String = "", vUnit As %String = "", vOriginalFee As %String = "") As %Status
{
    new repid, index,rowid
    Set repid=$I(^CacheTemp)
    Set qHandle=$lb(0,repid,0)
    s index=1
    
    i ((vStartDate="")&&(vEndDate="")) Quit $$$OK
    
    i EquipType="" s EquipTypeDR=""
    i vStartDate=""  d
    .s BeginDate=0
    e  d
    .;s BeginDate=$ZDH(vStartDate,3)-1
    .;日期格式统一调整    Modify by CSY 2017-03-02
    .s BeginDate=##Class(web.DHCEQCommon).TransValueFromPage(vStartDate,"date")-1
    i vEndDate=""  d
    .s EndDate=+$H
    e  d
    .;s EndDate=$ZDH(vEndDate,3)
    .;日期格式统一调整    Modify by CSY 2017-03-02
    .s EndDate=##Class(web.DHCEQCommon).TransValueFromPage(vEndDate,"date")

    s StockDate=BeginDate
    f  s StockDate=$o(^DHCEQStoreMove(0,"InAckDateStat",2,StockDate)) q:((StockDate="")||(StockDate>EndDate))  d
    .s StatCatDR=""
    .f  s StatCatDR=$o(^DHCEQStoreMove(0,"InAckDateStat",2,StockDate,StatCatDR)) q:StatCatDR=""  d
    ..s MoveTypeDR=""
    ..f  s MoveTypeDR=$o(^DHCEQStoreMove(0,"InAckDateStat",2,StockDate,StatCatDR,MoveTypeDR))  q:MoveTypeDR=""  d
    ...q:(MoveType'="")&&(MoveType'=MoveTypeDR)
    ...s SMRowID=0
    ...f  s SMRowID=$o(^DHCEQStoreMove(0,"InAckDateStat",2,StockDate,StatCatDR,MoveTypeDR,SMRowID)) q:SMRowID=""  d
    ....d ResetVariablesGetStoreMoveDetail
    ....s TEquipTypeDR=$p($g(^DHCEQStoreMove(SMRowID)),"^",16)
    ....q:(##Class(web.DHCEQCommon).EquipTypeIsIn(TEquipTypeDR,CurGroupID))
    ....s TStoreMoveNo=$p($g(^DHCEQStoreMove(SMRowID)),"^",1)
    ....s TFromLocDR=$p($g(^DHCEQStoreMove(SMRowID)),"^",2)
    ....i TFromLocDR'="" s TFromLoc=##class(web.DHCEQCommon).GetTrakNameByID("dept",TFromLocDR)
    ....s TToLocDR=$p($g(^DHCEQStoreMove(SMRowID)),"^",3)
    ....i TToLocDR'="" s TToLoc=##class(web.DHCEQCommon).GetTrakNameByID("dept",TToLocDR)
    ....s TInDate=$p($g(^DHCEQStoreMove(SMRowID)),"^",5)
    ....;i TInDate'="" s TInDate=$ZD(TInDate,3)
    ....;日期格式统一调整    Modify by CSY 2017-03-02
    ....s TInDate=##Class(web.DHCEQCommon).TransValueToPage(TInDate,"date")
    ....s TActDate=$p($g(^DHCEQStoreMove(SMRowID)),"^",10)
    ....;i TActDate'="" s TActDate=$ZD(TActDate,3)
    ....;日期格式统一调整    Modify by CSY 2017-03-02
    ....s TActDate=##Class(web.DHCEQCommon).TransValueToPage(TActDate,"date")
    ....s TReciverDR=$p($g(^DHCEQStoreMove(SMRowID)),"^",15)
    ....i TReciverDR'="" s TReciver=##Class(web.DHCEQCommon).GetTrakNameByID("user",TReciverDR)
    ....i TEquipTypeDR'="" s TEquipType=$p($g(^DHCEQCCode("DHCEQCEquipType",TEquipTypeDR)),"^",2)
    ....s SMLRowID=0
    ....f  s SMLRowID=$o(^DHCEQStoreMoveList(0,"StoreMove",SMRowID,SMLRowID))  q:SMLRowID=""  d
    .....s TRowID=SMLRowID
    .....s TEquipName=$p($g(^DHCEQStoreMoveList(SMLRowID)),"^",5)
    .....q:(vEquipName'="")&(TEquipName'=vEquipName)  //modify BY GBX 2015-03-05 11:43:51
    .....s TModelDR=$p($g(^DHCEQStoreMoveList(SMLRowID)),"^",9)
    .....i TModelDR'="" s TModel=$p($g(^DHCEQCCode("DHCEQCModel",TModelDR)),"^",2)
    .....q:(vModel'="")&(TModel'=vModel)  //modify BY GBX 2015-03-05 11:43:51
    .....s TUnitDR=$p($g(^DHCEQStoreMoveList(SMLRowID)),"^",10)
    .....i TUnitDR'="" s TUnit=##Class(web.DHCEQCommon).GetTrakNameByID("uom",TUnitDR)
    .....q:(vUnit'="")&(vUnit'=TUnit)
    .....s EquipDR=$p($g(^DHCEQStoreMoveList(SMLRowID)),"^",2)
    .....s InStockListDR=$p($g(^DHCEQStoreMoveList(SMLRowID)),"^",4)
    .....i EquipDR'=""  d
    ......s TStatCatDR=$p($g(^DHCEQEquip(EquipDR)),"^",75)
    ......s ItemDR=$p($g(^DHCEQEquip(EquipDR)),"^",7)
    ......s TEquipCatDR=$p($g(^DHCEQEquip(EquipDR)),"^",4)
    ......s InStockListDR=$p($g(^DHCEQEquip(EquipDR)),"^",70)
    .....e  d
    ......s TStatCatDR=$p($g(^DHCEQInStockList(InStockListDR)),"^",17)
    ......s ItemDR=$p($g(^DHCEQInStockList(InStockListDR)),"^",16)
    ......s TEquipCatDR=$p($g(^DHCEQInStockList(InStockListDR)),"^",14)
    .....i TStatCatDR'="" s TStatCat=$p($g(^DHCEQCCode("DHCEQCStatCat",TStatCatDR)),"^",2)
    .....;s TEquipCatDR=$p($g(^DHCEQCCode("DHCEQCMasterItem",ItemDR)),"^",10)
    .....;i TEquipCatDR'=""  d
    .....;.s TEquipCatCode=$p($g(^DHCEQCCode("DHCEQCTree",TEquipCatDR)),"^",2)
    .....;.s TEquipCat=$p($g(^DHCEQCCode("DHCEQCTree",TEquipCatDR)),"^",3)
    .....i TEquipCatDR'=""  d
    ......s TEquipCat=$p($g(^DHCEQCCode("DHCEQCEquipeCat",TEquipCatDR)),"^",2)
    ......s TEquipCatCode=$p($g(^DHCEQCCode("DHCEQCEquipeCat",TEquipCatDR)),"^",1)
    .....i InStockListDR'=""  d  //modify by GBX 2015-5-15 10:36:20修正错误
    ......s InStockID=$p($g(^DHCEQInStockList(InStockListDR)),"^",1)  
    ......s InStockNo=$p($g(^DHCEQInStock(InStockID)),"^",14)  //入库单号
    .....s TQuantity=$p($g(^DHCEQStoreMoveList(SMLRowID)),"^",8)
    .....s TOriginalFee=$fn($p($g(^DHCEQStoreMoveList(SMLRowID)),"^",7),"",2)
    .....q:(vOriginalFee'="")&(vOriginalFee'=$FN(TOriginalFee,"",2))
    .....s TAmount=$fn(TQuantity*TOriginalFee,"",2)
    .....s EQRowIDs=$g(^DHCEQStoreMoveList(SMLRowID,"EX","RowIDs"))
    .....s TEquipNos=##Class(web.DHCEQCommon).GetEquipNos(EQRowIDs,0)
    .....d OutputRowGetStoreMoveDetail
    
    Quit $$$OK
OutputRowGetStoreMoveDetail
    s Data=$lb(TRowID,TStoreMoveNo,TFromLoc,TToLoc,TInDate,TActDate,TReciver,TEquipName,TModel,TUnit,TOriginalFee,TQuantity,TAmount,TEquipCatCode,TEquipType,TStatCat,TEquipCat,TEquipNos,InStockNo)
    Set ^CacheTemp(repid,index)=Data
    Set index=index+1
    quit
ResetVariablesGetStoreMoveDetail
    s (TRowID,TStoreMoveNo,TFromLoc,TToLoc,TInDate,TActDate,TReciver,TEquipName,TModel,TUnit,TOriginalFee,TQuantity,TAmount,TEquipCatCode,TEquipType,TStatCat,TEquipCat,TEquipNos,InStockID,InStockNo)=""
    quit
}

ClassMethod StoreMoveDetailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = StoreMoveDetailExecute ]
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

Query StoreMoveDetail(vStartDate As %String = "", vEndDate As %String = "", MoveType As %String = "", QXType As %String = "", EquipType As %String = "", EquipTypeDR As %String = "", CurGroupID As %String = "", CurLocID As %String = "", vEquipName As %String = "", vModel As %String = "", vUnit As %String = "", vOriginalFee As %String = "") As %Query(ROWSPEC = "TRowID:%String,TStoreMoveNo:%String,TFromLoc:%String,TToLoc:%String,TInDate:%String,TActDate:%String,TReciver:%String,TEquipName:%String,TModel:%String,TUnit:%String,TOriginalFee:%String,TQuantity:%String,TAmount:%String,TEquipCatCode:%String,TEquipType:%String,TStatCat:%String,TEquipCat:%String,TEquipNos:%String,InStockNo:%String") [ SqlProc ]
{
}

/*************************************************************************************************/
/// Add By DJ 2014-04-19
/// 医疗设备应付款报账封面
ClassMethod VendorStatClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = VendorStatExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)

    Quit $$$OK
}

ClassMethod VendorStatExecute(ByRef qHandle As %Binary, vStartDate As %String = "", vEndDate As %String = "", QXType As %String = "", EquipType As %String = "", EquipTypeDR As %String = "", CurGroupID As %String = "", CurLocID As %String = "", vProviderDR As %String = "", vMonthStr As %String = "") As %Status
{
    new repid, index,rowid
    Set repid=$I(^CacheTemp)
    Set qHandle=$lb(0,repid,0)
    s index=1
    i vMonthStr="" Quit $$$OK
    s vStartDate=vMonthStr_"-01"
    s vEndDate=$ZD(##Class(web.DHCEQReport).GetReportDate(vMonthStr,"2",""),3)
    
    i ((vStartDate="")||(vEndDate="")) Quit $$$OK
    
    i EquipType="" s EquipTypeDR=""
    i vStartDate=""  d
    .s BeginDate=0
    e  d
    .;s BeginDate=$ZDH(vStartDate,3)-1
    .;日期格式统一调整    Modify by CSY 2017-03-02
    .s BeginDate=##Class(web.DHCEQCommon).TransValueFromPage(vStartDate,"date")-1
    i vEndDate=""  d
    .s EndDate=+$H
    e  d
    .;s EndDate=$ZDH(vEndDate,3)
    .;日期格式统一调整    Modify by CSY 2017-03-02
    .s EndDate=##Class(web.DHCEQCommon).TransValueFromPage(vEndDate,"date")
    //入库
    s StockDate=BeginDate
    f  s StockDate=$o(^DHCEQInStock(0,"BillDate",StockDate)) q:((StockDate="")||(StockDate>EndDate))  d
    .s StatCatDR=""
    .f  s StatCatDR=$o(^DHCEQInStock(0,"BillDate",StockDate,StatCatDR)) q:StatCatDR=""  d
    ..s ISRowID=0
    ..f  s ISRowID=$o(^DHCEQInStock(0,"BillDate",StockDate,StatCatDR,ISRowID)) q:ISRowID=""  d
    ...d ResetVariablesGetVendorStat
    ...s InStockNo=$p($g(^DHCEQInStock(ISRowID)),"^",14)
    ...q:InStockNo=""
    ...s vendorid=$p($g(^DHCEQInStock(ISRowID)),"^",17)
    ...q:vendorid=""
    ...q:(vProviderDR'="")&&(vendorid'=vProviderDR)
    ...s ISStatus=$p($g(^DHCEQInStock(ISRowID)),"^",10)
    ...q:ISStatus'=2
    ...s TEquipTypeDR=$p($g(^DHCEQInStock(ISRowID)),"^",20)
    ...q:(##Class(web.DHCEQCommon).EquipTypeIsIn(TEquipTypeDR,CurGroupID))
    ...s TRowID=vendorid
    ...s TVendorCode=$p($g(^DHCEQCCode("DHCEQCVendor",vendorid)),"^",1)
    ...s TBankNo=$p($g(^DHCEQCCode("DHCEQCVendor",vendorid)),"^",14)
    ...s TBank=$p($g(^DHCEQCCode("DHCEQCVendor",vendorid)),"^",13)
    ...s TVendor=##class(web.DHCEQCommon).GetTrakNameByID("prov",vendorid)  //供应商
    ...i TEquipTypeDR'="" s TEquipType=$p($g(^DHCEQCCode("DHCEQCEquipType",TEquipTypeDR)),"^",2)
    ...s ISLRowID=0
    ...f  s ISLRowID=$o(^DHCEQInStockList(0,"InStock",ISRowID,ISLRowID))  q:ISLRowID=""  d
    ....s TQuantity=$p($g(^DHCEQInStockList(ISLRowID)),"^",8)
    ....s TOriginalFee=$fn($p($g(^DHCEQInStockList(ISLRowID)),"^",7),"",2)
    ....s TAmount=$fn(TQuantity*TOriginalFee,"",2)
    ....s TEquipName=$p($g(^DHCEQInStockList(ISLRowID)),"^",5)  //Add By DJ 2014-11-25
    ....d OutputRowGetVendorStat
    
    //退货记录
    s StockDate=BeginDate
    f  s StockDate=$o(^DHCEQReturn(0,"AckDateStat",2,StockDate)) q:((StockDate="")||(StockDate>EndDate))  d
    .s StatCatDR=""
    .f  s StatCatDR=$o(^DHCEQReturn(0,"AckDateStat",2,StockDate,StatCatDR)) q:StatCatDR=""  d
    ..s RRowID=0        
    ..f  s RRowID=$o(^DHCEQReturn(0,"AckDateStat",2,StockDate,StatCatDR,RRowID)) q:RRowID=""  d
    ...s vendorid=$p($g(^DHCEQReturn(RRowID)),"^",3)
    ...q:vendorid=""
    ...q:(vProviderDR'="")&&(vendorid'=vProviderDR)
    ...s RType=$p($g(^DHCEQReturn(RRowID)),"^",17)
    ...q:RType'=1
    ...s TEquipTypeDR=$p($g(^DHCEQReturn(RRowID)),"^",15)
    ...q:(##Class(web.DHCEQCommon).EquipTypeIsIn(TEquipTypeDR,CurGroupID))
    ...s TRowID=vendorid
    ...s TBankNo=$p($g(^DHCEQCCode("DHCEQCVendor",vendorid)),"^",14)
    ...s TBank=$p($g(^DHCEQCCode("DHCEQCVendor",vendorid)),"^",13)
    ...s TVendor=##class(web.DHCEQCommon).GetTrakNameByID("prov",vendorid)  //供应商
    ...s TVendorCode=$p($g(^DHCEQCCode("DHCEQCVendor",vendorid)),"^",1)
    ...s RLRowID=0
    ...f  s RLRowID=$o(^DHCEQReturnList(0,"Return",RRowID,RLRowID))  q:RLRowID=""  d
    ....s TQuantity=0-$p($g(^DHCEQReturnList(RLRowID)),"^",5)
    ....s TOriginalFee=$fn($p($g(^DHCEQReturnList(RLRowID)),"^",6),"",2)
    ....s TAmount=$fn(TQuantity*TOriginalFee,"",2)
    ....s RLInStockListDR=$p($g(^DHCEQReturnList(RLRowID)),"^",3)   //Add By DJ 2014-11-25 begin
    ....s RLEquipDR=$p($g(^DHCEQReturnList(RLRowID)),"^",4)
    ....i RLInStockListDR'=""  d
    .....s TEquipName=$p($g(^DHCEQInStockList(RLInStockListDR)),"^",5)
    ....e  d
    .....s TEquipName=$p($g(^DHCEQEquip(RLEquipDR)),"^",1)  //Add By DJ 2014-11-25 end
    ....d OutputRowGetVendorStat
    
    Quit $$$OK
OutputRowGetVendorStat
    s Data=$lb(TRowID,TVendorCode,TVendor,TBankNo,TBank,TAmount,TEquipName)
    Set ^CacheTemp(repid,index)=Data
    Set index=index+1
    quit
ResetVariablesGetVendorStat
    s (TRowID,TVendorCode,TVendor,TBankNo,TBank,TAmount,TEquipName)=""
    quit
}

ClassMethod VendorStatFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = VendorStatExecute ]
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

Query VendorStat(vStartDate As %String = "", vEndDate As %String = "", QXType As %String = "", EquipType As %String = "", EquipTypeDR As %String = "", CurGroupID As %String = "", CurLocID As %String = "", vProviderDR As %String = "", vMonthStr As %String = "") As %Query(ROWSPEC = "TRowID:%String,TVendorCode:%String,TVendor:%String,TBankNo:%String,TBank:%String,TAmount:%String,TEquipName:%String") [ SqlProc ]
{
}

/************************************************************************/
/// ADD By DJ 2014-04-21
/// 固定资产付款记录
ClassMethod PayRecordClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = PayRecordExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)

    Quit $$$OK
}

ClassMethod PayRecordExecute(ByRef qHandle As %Binary, vStartDate As %String = "", vEndDate As %String = "", QXType As %String = "", EquipType As %String = "", EquipTypeDR As %String = "", CurGroupID As %String = "", CurLocID As %String = "", vProviderDR As %String = "", vMonthStr As %String = "") As %Status
{
    new repid, index,rowid
    Set repid=$I(^CacheTemp)
    Set qHandle=$lb(0,repid,0)
    s index=1
    
    i vMonthStr="" Quit $$$OK
    s vStartDate=vMonthStr_"-01"
    s vEndDate=$ZD(##Class(web.DHCEQReport).GetReportDate(vMonthStr,"2",""),3)
    i ((vStartDate="")||(vEndDate="")) Quit $$$OK
    
    i EquipType="" s EquipTypeDR=""
    i vStartDate=""  d
    .s BeginDate=0
    e  d
    .;s BeginDate=$ZDH(vStartDate,3)
    .;日期格式统一调整    Modify by CSY 2017-03-02
    .s BeginDate=##Class(web.DHCEQCommon).TransValueFromPage(vStartDate,"date")
    i vEndDate=""  d
    .s EndDate=+$H
    e  d
    .;s EndDate=$ZDH(vEndDate,3)
    .;日期格式统一调整    Modify by CSY 2017-03-02
    .s EndDate=##Class(web.DHCEQCommon).TransValueFromPage(vEndDate,"date")
    
    s PRRowID=0
    f  s PRRowID=$o(^DHCEQPayRecord(0,"Status",2,PRRowID))  q:PRRowID=""  d
    .d ResetVariablesGetPayRecord
    .q:(($p($g(^DHCEQPayRecord(PRRowID)),"^",29))="Y")
    .s TPayRecordNo=$p($g(^DHCEQPayRecord(PRRowID)),"^",5)
    .i TPayRecordNo'=""  d
    ..s TPayRecordNo=$p($g(^DHCEQPayRecord(TPayRecordNo)),"^",1)
    .s TPayAuditDate=$p($g(^DHCEQPayRecord(PRRowID)),"^",23)
    .q:(TPayAuditDate<BeginDate)
    .q:(TPayAuditDate>EndDate)
    .s TSourceTypeDR=$p($g(^DHCEQPayRecord(PRRowID)),"^",15)
    .s TSourceID=$p($g(^DHCEQPayRecord(PRRowID)),"^",16)
    .s TAmount=$p($g(^DHCEQPayRecord(PRRowID)),"^",3)
    .i TSourceTypeDR=11 s TAmount=0-TAmount
    .s PRDRowID=$o(^DHCEQPayRecordDetail(0,"SourceID",TSourceTypeDR,TSourceID,0))
    .i PRDRowID'=""  d
    ..s TEquipTypeDR=$p($g(^DHCEQPayRecordDetail(PRDRowID)),"^",8)
    ..q:(##Class(web.DHCEQCommon).EquipTypeIsIn(TEquipTypeDR,CurGroupID))
    ..s TProviderDR=$p($g(^DHCEQPayRecordDetail(PRDRowID)),"^",5)
    ..q:(vProviderDR'="")&&(TProviderDR'=vProviderDR)
    ..s TRowID=TProviderDR
    ..s TVendorCode=$p($g(^DHCEQCCode("DHCEQCVendor",TProviderDR)),"^",1)
    ..s TBankNo=$p($g(^DHCEQCCode("DHCEQCVendor",TProviderDR)),"^",14)
    ..s TBank=$p($g(^DHCEQCCode("DHCEQCVendor",TProviderDR)),"^",13)
    ..s TVendor=##class(web.DHCEQCommon).GetTrakNameByID("prov",TProviderDR)    //供应商
    ..s TEquipName=$p($g(^DHCEQPayRecordDetail(PRDRowID)),"^",7)
    ..i $L(TEquipName,"[")>=2  d
    ...s TEquipName=$p(TEquipName,"[",2)
    ...s TEquipName=$p(TEquipName,"]",1)
    ..d OutputRowGetPayRecord
        
    Quit $$$OK
OutputRowGetPayRecord
    s Data=$lb(TRowID,TVendorCode,TVendor,TBankNo,TBank,TAmount,TEquipName)
    Set ^CacheTemp(repid,index)=Data
    Set index=index+1
    quit
ResetVariablesGetPayRecord
    s (TRowID,TVendorCode,TVendor,TBankNo,TBank,TAmount,TEquipName)=""
    quit
}

ClassMethod PayRecordFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = PayRecordExecute ]
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

Query PayRecord(vStartDate As %String = "", vEndDate As %String = "", QXType As %String = "", EquipType As %String = "", EquipTypeDR As %String = "", CurGroupID As %String = "", CurLocID As %String = "", vProviderDR As %String = "", vMonthStr As %String = "") As %Query(ROWSPEC = "TRowID:%String,TVendorCode:%String,TVendor:%String,TBankNo:%String,TBank:%String,TAmount:%String,TEquipName:%String") [ SqlProc ]
{
}

/******************************************************/
/// Add By DJ 2014-04-22
/// 弋矶山固定资产汇总表2
ClassMethod EquipSumYJSClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = EquipSumYJSExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)

    Quit $$$OK
}

ClassMethod EquipSumYJSExecute(ByRef qHandle As %Binary, vEndDate As %String = "", QXType As %String = "", vUseLoc As %String = "", vUseLocDR As %String = "", EquipType As %String = "", EquipTypeDR As %String = "", FundsType As %String = "", FundsTypeDR As %String = "", CurGroupID As %String = "", CurLocID As %String = "") As %Status
{
    new repid, index,rowid
    Set repid=$I(^CacheTemp)
    Set qHandle=$lb(0,repid,0)
    s index=1
    i (vEndDate="") Quit $$$OK
    i EquipType="" s EquipTypeDR=""
    i vUseLoc="" s vUseLocDR=""
    i FundsType="" s FundsTypeDR=""
    s MonthStr=$E(vEndDate,1,7)
    s SnapID=##Class(web.DHCEQSnapShot).GetSnapIDByMonth(MonthStr)
    
    s RowID=0
    i SnapID=""  d
    .f  s RowID=$o(^DHCEQEquip(RowID))  q:RowID=""  d
    ..d ResetVariablesGetEquipSumYJS
    ..s TRowID=RowID
    ..s InvalidFlag=$p($g(^DHCEQEquip(RowID)),"^",59)
    ..s EQStoreLocDR=$p($g(^DHCEQEquip(RowID)),"^",67)  //设备库房
    ..s EQEquipTypeDR=$p($g(^DHCEQEquip(RowID)),"^",63) //设备类组
    ..q:(EquipTypeDR'="")&&(EquipTypeDR'=EQEquipTypeDR)
    ..q:(##Class(web.DHCEQCommon).EquipTypeIsIn(EQEquipTypeDR,CurGroupID))
    ..s EQStatus=$p($g(^DHCEQEquip(RowID)),"^",38)
    ..s EQStockStatus=$p($g(^DHCEQEquip(RowID)),"^",60)
    ..q:(EQStatus=0)&&(EQStockStatus=0)
    ..s TTransAssetDate=$p($g(^DHCEQEquip(RowID)),"^",45)   //转资日期
    ..;q:(vEndDate'="")&&(TTransAssetDate>$ZDH(vEndDate,3))
    ..;日期格式统一调整    Modify by CSY 2017-03-02
    ..q:(vEndDate'="")&&(TTransAssetDate>##Class(web.DHCEQCommon).TransValueFromPage(vEndDate,"date"))
    ..i (EQStatus=0)&&(EQStockStatus=1) s Flag=1    //新增入库
    ..i (EQStatus=2)&&(EQStockStatus=1) s Flag=1 //封存入库
    ..i (EQStatus=1) s Flag=2   //在用设备
    ..i (EQStatus=2)&&(EQStockStatus=3)  d  //出库设备
    ...s Flag=4
    ...i EQStoreLocDR=594  s Flag=3
    ..i (EQStatus=3)&&(EQStockStatus=1)  d  //报废设备
    ...s Flag=4
    ...i EQStoreLocDR=594  s Flag=3
    ..i (InvalidFlag="Y")  d    //无效设备
    ...s Flag=4
    ...i EQStoreLocDR=594  s Flag=3
    ..s TEquipNo=$p($g(^DHCEQEquip(RowID)),"^",71)      //设备编号
    ..s TEquipName=$p($g(^DHCEQEquip(RowID)),"^",1) //设备名称
    ..s TOriginalFee=$fn($p($g(^DHCEQEquip(RowID)),"^",27),"",2) //设备原值
    ..s TStatCatDR=$p($g(^DHCEQEquip(RowID)),"^",75)        //设备类型
    ..i TStatCatDR'="" s TStatCat=$p($g(^DHCEQCCode("DHCEQCStatCat",TStatCatDR)),"^",2)
    ..i EQEquipTypeDR'="" s TEquipType=$p($g(^DHCEQCCode("DHCEQCEquipType",EQEquipTypeDR)),"^",2)
    ..s TStartDate=$p($g(^DHCEQEquip(RowID)),"^",44)            //启用日期
    ..;i TStartDate'="" s TStartDate=$ZD(TStartDate,3)
    ..;i TTransAssetDate'="" s TTransAssetDate=$ZD(TTransAssetDate,3)
    ..;日期格式统一调整    Modify by CSY 2017-03-02
    ..s TStartDate=##Class(web.DHCEQCommon).TransValueToPage(TStartDate,"date")
    ..s TTransAssetDate=##Class(web.DHCEQCommon).TransValueToPage(TTransAssetDate,"date")
    ..s FTRowID=0
    ..f  s FTRowID=$o(^DHCEQCCode("DHCEQCFundsType",FTRowID))  q:FTRowID=""  d
    ...s TFundsType=$p($g(^DHCEQCCode("DHCEQCFundsType",FTRowID)),"^",2)
    ...s TFundsFee=$fn(##Class(web.DHCEQFunds).GetFundsAmountByFromID(1,RowID,FTRowID,""),"",2)
    ...q:TFundsFee<=0
    ...i Flag=1 s TStock=TFundsFee
    ...i Flag=2 s TUsed=TFundsFee
    ...i Flag=3 s TStockDisuse=TFundsFee
    ...i Flag=4 s TUsedDisuse=TFundsFee
    ...d OutputRowGetEquipSumYJS
    e  d
    .f  s RowID=$o(^DHCEQSnapShot(SnapID,"Equip",RowID))  q:RowID=""  d
    ..d ResetVariablesGetEquipSumYJS
    ..s TRowID=RowID
    ..s InvalidFlag=$p($g(^DHCEQSnapShot(SnapID,"Equip",RowID)),"^",59)
    ..s EQStoreLocDR=$p($g(^DHCEQSnapShot(SnapID,"Equip",RowID)),"^",67)    //设备库房
    ..s EQEquipTypeDR=$p($g(^DHCEQSnapShot(SnapID,"Equip",RowID)),"^",63)   //设备类组
    ..q:(EquipTypeDR'="")&&(EquipTypeDR'=EQEquipTypeDR)
    ..q:(##Class(web.DHCEQCommon).EquipTypeIsIn(EQEquipTypeDR,CurGroupID))
    ..s EQStatus=$p($g(^DHCEQSnapShot(SnapID,"Equip",RowID)),"^",38)
    ..s EQStockStatus=$p($g(^DHCEQSnapShot(SnapID,"Equip",RowID)),"^",60)
    ..q:(EQStatus=0)&&(EQStockStatus=0)
    ..s TTransAssetDate=$p($g(^DHCEQSnapShot(SnapID,"Equip",RowID)),"^",45) //转资日期
    ..;q:(vEndDate'="")&&(TTransAssetDate>$ZDH(vEndDate,3))
    ..;日期格式统一调整    Modify by CSY 2017-03-02
    ..q:(vEndDate'="")&&(TTransAssetDate>##Class(web.DHCEQCommon).TransValueFromPage(vEndDate,"date"))
    ..i (EQStatus=0)&&(EQStockStatus=1) s Flag=1    //新增入库
    ..i (EQStatus=2)&&(EQStockStatus=1) s Flag=1 //封存入库
    ..i (EQStatus=1) s Flag=2   //在用设备
    ..i (EQStatus=2)&&(EQStockStatus=3)  d  //出库设备
    ...s Flag=4
    ...i EQStoreLocDR=594  s Flag=3
    ..i (EQStatus=3)&&(EQStockStatus=1)  d  //报废设备
    ...s Flag=4
    ...i EQStoreLocDR=594  s Flag=3
    ..i (InvalidFlag="Y")  d    //无效设备
    ...s Flag=4
    ...i EQStoreLocDR=594  s Flag=3
    ..s TEquipNo=$p($g(^DHCEQSnapShot(SnapID,"Equip",RowID)),"^",71)        //设备编号
    ..s TEquipName=$p($g(^DHCEQSnapShot(SnapID,"Equip",RowID)),"^",1)   //设备名称
    ..s TOriginalFee=$fn($p($g(^DHCEQSnapShot(SnapID,"Equip",RowID)),"^",27),"",2) //设备原值
    ..s TStatCatDR=$p($g(^DHCEQSnapShot(SnapID,"Equip",RowID)),"^",75)      //设备类型
    ..i TStatCatDR'="" s TStatCat=$p($g(^DHCEQCCode("DHCEQCStatCat",TStatCatDR)),"^",2)
    ..i EQEquipTypeDR'="" s TEquipType=$p($g(^DHCEQCCode("DHCEQCEquipType",EQEquipTypeDR)),"^",2)
    ..;i TTransAssetDate'="" s TTransAssetDate=$ZD(TTransAssetDate,3)
    ..;日期格式统一调整    Modify by CSY 2017-03-02
    ..s TTransAssetDate=##Class(web.DHCEQCommon).TransValueToPage(TTransAssetDate,"date")
    ..s FRowID=0
    ..f  s FRowID=$o(^DHCEQSnapShot(SnapID,"Funds",RowID,FRowID))  q:FRowID=""  d
    ...s FTFundsType=$p($g(^DHCEQSnapShot(SnapID,"Funds",RowID,FRowID)),"^",2)
    ...i FTFundsType'="" s TFundsType=$p($g(^DHCEQCCode("DHCEQCFundsType",FTFundsType)),"^",2)
    ...s TFundsFee=$p($g(^DHCEQSnapShot(SnapID,"Funds",RowID,FRowID)),"^",3)
    ...q:TFundsFee<=0
    ...i Flag=1 s TStock=TFundsFee
    ...i Flag=2 s TUsed=TFundsFee
    ...i Flag=3 s TStockDisuse=TFundsFee
    ...i Flag=4 s TUsedDisuse=TFundsFee
    ...d OutputRowGetEquipSumYJS

    Quit $$$OK
OutputRowGetEquipSumYJS
    s Data=$lb(TRowID,TEquipNo,TEquipType,TStatCat,TFundsType,TStock,TUsed,TStockDisuse,TUsedDisuse)
    Set ^CacheTemp(repid,index)=Data
    Set index=index+1
    quit
ResetVariablesGetEquipSumYJS
    s (TRowID,TEquipNo,TEquipType,TStatCat,TFundsType,TStock,TUsed,TStockDisuse,TUsedDisuse)=""
    quit
}

ClassMethod EquipSumYJSFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = EquipSumYJSExecute ]
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

Query EquipSumYJS(vEndDate As %String = "", QXType As %String = "", UseLoc As %String = "", UseLocDR As %String = "", EquipType As %String = "", EquipTypeDR As %String = "", FundsType As %String = "", FundsTypeDR As %String = "", CurGroupID As %String = "", CurLocID As %String = "") As %Query(ROWSPEC = "TRowID:%String,TEquipNo:%String,TEquipType:%String,TStatCat:%String,TFundsType:%String,TStock:%String,TUsed:%String,TStockDisuse:%String,TUsedDisuse:%String") [ SqlProc ]
{
}

/***************************************************************************/
ClassMethod GetVendorClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetVendorExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)

    Quit $$$OK
}

ClassMethod GetVendorExecute(ByRef qHandle As %Binary) As %Status
{
    new repid, index,rowid
    Set repid=$I(^CacheTemp)
    Set qHandle=$lb(0,repid,0)
    s index=1
    s rowid=0
    d BuildDataGetVendorInfo
    Quit $$$OK
BuildDataGetVendorInfo
    f  s rowid=$o(^DHCEQCCode("DHCEQCVendor",rowid))  quit:rowid=""  d
    .d ResetVariablesGetVendorInfo
    .s TRowID = rowid   //rowid
    .s InvalidFlag=$p($g(^DHCEQCCode("DHCEQCVendor",rowid)),"^",19)
    .q:InvalidFlag="Y"
    .s TCode=$p($g(^DHCEQCCode("DHCEQCVendor",rowid)),"^",1)
    .s TName=$p($g(^DHCEQCCode("DHCEQCVendor",rowid)),"^",2)
    .s TName=TCode_"-"_TName
    .d OutputRowGetVendorInfo
    quit
OutputRowGetVendorInfo
   s Data=$lb(TName,TRowID,TCode)
    Set ^CacheTemp(repid,index)=Data
    Set index=index+1
    quit
ResetVariablesGetVendorInfo
    s (TName,TRowID,TCode)=""
    quit
}

ClassMethod GetVendorFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetVendorExecute ]
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

Query GetVendor() As %Query(ROWSPEC = "TName:%String,TRowID:%String,TCode:%String") [ SqlProc ]
{
}

/***********************************************************************/

/*
ClassMethod GetAdjustDatalose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAdjustDataExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)

    Quit $$$OK
}

ClassMethod GetAdjustDataExecute(ByRef qHandle As %Binary, vStartDate As %String = "", vEndDate As %String = "", QXType As %String = "", vUseLoc As %String = "", vUseLocDR As %String = "", EquipType As %String = "", EquipTypeDR As %String = "", CurGroupID As %String = "", CurLocID As %String = "") As %Status
{
    new repid, index,rowid
    Set repid=$I(^CacheTemp)
    Set qHandle=$lb(0,repid,0)
    s index=1
    s rowid=0
    i ((vStartDate="")&&(vEndDate="")) Quit $$$OK
    
    i EquipType="" s EquipTypeDR=""
    i vStartDate=""  d
    .s BeginDate=0
    e  d
    .s BeginDate=$ZDH(vStartDate,3)-1
    i vEndDate=""  d
    .s EndDate=+$H
    e  d
    .s EndDate=$ZDH(vEndDate,3)
    d BuildDataGetAdjustDataInfo
    Quit $$$OK
BuildDataGetAdjustDataInfo
    s Date=0
    f  s Date=$o(^DHCEQAdjustData(0,"TypeDate",3,Date))  quit:Date=""  d
    .q:((BeginDate'="")&&(BeginDate>Date))
    .q:((EndDate'="")&&(EndDate<Date))
    .s rowid=0
    .f  s rowid=$o(^DHCEQAdjustData(0,"TypeDate",3,Date,rowid))  quit:rowid=""  d
    ..d ResetVariablesGetAdjustDataInfo
    ..q:(rowid=8)
    ..s Status=$p($g(^DHCEQAdjustData(rowid)),"^",11)
    ..q:(Status'=1)
    ..s TRowID = rowid  //rowid
    ..s AdjustDataListID=0
    ..f  s AdjustDataListID=$o(^DHCEQAdjustDataList(0,"AdjustData",rowid,AdjustDataListID))  quit:AdjustDataListID=""  d
    ...s TDate=##Class(web.DHCEQCommon).TransValueToPage(Date,"date")  //下账日期
    ...s EquipID=$p($g(^DHCEQAdjustDataList(AdjustDataListID)),"^",2)
    ...s TEquipName=$p($g(^DHCEQEquip(EquipID)),"^",1)  //设备名称
    ...s TModelDR=$p($g(^DHCEQEquip(EquipID)),"^",3)  //规格型号
    ...i TModelDR'=""  d
    ....s TModel = $p($g(^DHCEQCCode("DHCEQCModel",TModelDR)),"^",2)
    ...s TUnitDR=$p($g(^DHCEQEquip(EquipID)),"^",5)  //单位
    ...i TUnitDR '=""  d
    ....s TUnit = ##Class(web.DHCEQCommon).GetTrakNameByID("uom",TUnitDR)
    ...s TEquipTypeDR=$p($g(^DHCEQEquip(EquipID)),"^",63)  //类组
    ...q:(##Class(web.DHCEQCommon).EquipTypeIsIn(TEquipTypeDR,CurGroupID))
    ...i TEquipTypeDR '=""  d
    ....s TEquipType = $p($g(^DHCEQCCode("DHCEQCEquipType",TEquipTypeDR)),"^",2)
    ...s TEquipNo=$p($g(^DHCEQEquip(EquipID)),"^",71)  //设备编号
    ...s TStatCatDR=$p($g(^DHCEQEquip(EquipID)),"^",75)  //类型
    ...i TStatCatDR'="" d
    ....s TStatCat=$p($g(^DHCEQCCode("DHCEQCStatCat",TStatCatDR)),"^",2)
    ...s TEquipCatDR=$p($g(^DHCEQEquip(EquipID)),"^",4)  //分类
    ...i TEquipCatDR'="" d
    ....s TEquipCat=$p($g(^DHCEQCCode("DHCEQCEquipeCat",TEquipCatDR)),"^",2)
    ...s TOriginalFee=$p($g(^DHCEQEquip(EquipID)),"^",27)  //原值
    ...s TOriginalFee=$FN(TOriginalFee,"",2)
    ...s TQuantity=1
    ...s TLimitYearNum=$p($g(^DHCEQEquip(EquipID)),"^",31)
    ...s TStoreLocDR=$p($g(^DHCEQEquip(EquipID)),"^",19)  //使用科室
    ...q:(vUseLocDR'="")&&(vUseLocDR'=TStoreLocDR)
    ...i TStoreLocDR'=""  d
    ....s TStoreLoc = ##class(web.DHCEQCommon).GetTrakNameByID("dept",TStoreLocDR)
    ....;##class(web.DHCEQCommon).GetTrakNameByID("dept",TStoreLocDR)
    ....s TStoreLocCode=$p($g(^CTLOC(TStoreLocDR)),"^",1)
    ...s TManuFactoryDR=$p($g(^DHCEQEquip(EquipID)),"^",26)  //生产厂商
    ...i TManuFactoryDR '=""  d
    ....s TManuFactory = $p($g(^DHCEQCCode("DHCEQCManufacturer",TManuFactoryDR)),"^",1)
    ...s TProviderDR=$p($g(^DHCEQEquip(EquipID)),"^",25)  //供应商
    ...i TProviderDR '=""  d
    ....s TProvider =##Class(web.DHCEQCommon).GetTrakNameByID("prov",TProviderDR)
    ...s TStartDate=$p($g(^DHCEQEquip(EquipID)),"^",44)  //启用日期
    ...Set TStartDate=##Class(web.DHCEQCommon).TransValueToPage(TStartDate,"date")
    ...s TTransAssetDate=$p($g(^DHCEQEquip(EquipID)),"^",45)  //转资日期
    ...Set TTransAssetDate=##Class(web.DHCEQCommon).TransValueToPage(TTransAssetDate,"date")
    ...s TLeaveFeactoryNo=$p($g(^DHCEQEquip(EquipID)),"^",10)  //出厂编号
    ...d OutputRowGetAdjustDataInfo
    quit
OutputRowGetAdjustDataInfo
   s Data=$lb(TRowID,TEquipName,TModel,TUnit,TEquipType,TStatCat,TEquipCat,TEquipNo,TOriginalFee,TStoreLoc,TManuFactory,TProvider,TStartDate,TTransAssetDate,TLeaveFeactoryNo,TQuantity,TStoreLocCode,TDate,TLimitYearNum)
    Set ^CacheTemp(repid,index)=Data
    Set index=index+1
    quit
ResetVariablesGetAdjustDataInfo
    s (TRowID,TEquipName,TModel,TModelDR,TUnit,TUnitDR,TEquipType,TEquipTypeDR,TEquipCatDR,TEquipCat,TStatCat,TStatCatDR,TEquipNo,TOriginalFee,TStoreLoc,TStoreLocDR,TManuFactory,TManuFactoryDR,TProvider,TProviderDR,TStartDate,TTransAssetDate,TLeaveFeactoryNo,TQuantity,TStoreLocCode,TDate,TLimitYearNum)=""
    quit
}

ClassMethod GetAdjustDataFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAdjustDataExecute ]
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

Query GetAdjustData(vStartDate As %String = "", vEndDate As %String = "", QXType As %String = "", vUseLoc As %String = "", vUseLocDR As %String = "", EquipType As %String = "", EquipTypeDR As %String = "", CurGroupID As %String = "", CurLocID As %String = "") As %Query(ROWSPEC = "TRowID:%String,TEquipName:%String,TModel:%String,TUnit:%String,TEquipType:%String,TStatCat:%String,TEquipCat:%String,TEquipNo:%String,TOriginalFee:%String,TStoreLoc:%String,TManuFactory:%String,TProvider:%String,TStartDate:%String,TTransAssetDate:%String,TLeaveFeactoryNo:%String,TQuantity:%String,TStoreLocCode:%String,TDate:%String,TLimitYearNum:%String") [ SqlProc ]
{
}
*/
ClassMethod GetAdjustDataClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAdjustDataExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)

    Quit $$$OK
}

ClassMethod GetAdjustDataExecute(ByRef qHandle As %Binary, vStartDate As %String = "", vEndDate As %String = "", QXType As %String = "", vUseLoc As %String = "", vUseLocDR As %String = "", EquipType As %String = "", EquipTypeDR As %String = "", CurGroupID As %String = "", CurLocID As %String = "") As %Status
{
    new repid, index,rowid
    Set repid=$I(^CacheTemp)
    Set qHandle=$lb(0,repid,0)
    s index=1
    s rowid=0
    i ((vStartDate="")&&(vEndDate="")) Quit $$$OK
    
    i EquipType="" s EquipTypeDR=""
    i vStartDate=""  d
    .s BeginDate=0
    e  d
    .;s BeginDate=$ZDH(vStartDate,3)-1
    .;日期格式统一调整    Modify by CSY 2017-03-02
    .s BeginDate=##Class(web.DHCEQCommon).TransValueFromPage(vStartDate,"date")-1
    i vEndDate=""  d
    .s EndDate=+$H
    e  d
    .;s EndDate=$ZDH(vEndDate,3)
    .;日期格式统一调整    Modify by CSY 2017-03-02
    .s EndDate=##Class(web.DHCEQCommon).TransValueFromPage(vEndDate,"date")
    d BuildDataGetAdjustDataInfo
    Quit $$$OK
BuildDataGetAdjustDataInfo
    s Date=0
    f  s Date=$o(^DHCEQAdjustData(0,"TypeDate",3,Date))  quit:Date=""  d
    .q:((BeginDate'="")&&(BeginDate>Date))
    .q:((EndDate'="")&&(EndDate<Date))
    .s rowid=0
    .f  s rowid=$o(^DHCEQAdjustData(0,"TypeDate",3,Date,rowid))  quit:rowid=""  d
    ..d ResetVariablesGetAdjustDataInfo
    ..q:(rowid=8)
    ..s Status=$p($g(^DHCEQAdjustData(rowid)),"^",11)
    ..q:(Status'=1)
    ..s TRowID = rowid  //rowid
    ..s AdjustDataListID=0
    ..f  s AdjustDataListID=$o(^DHCEQAdjustDataList(0,"AdjustData",rowid,AdjustDataListID))  quit:AdjustDataListID=""  d
    ...s TDate=##Class(web.DHCEQCommon).TransValueToPage(Date,"date")  //下账日期
    ...s EquipID=$p($g(^DHCEQAdjustDataList(AdjustDataListID)),"^",2)
    ...s TEquipName=$p($g(^DHCEQEquip(EquipID)),"^",1)  //设备名称
    ...s TModelDR=$p($g(^DHCEQEquip(EquipID)),"^",3)  //规格型号
    ...i TModelDR'=""  d
    ....s TModel = $p($g(^DHCEQCCode("DHCEQCModel",TModelDR)),"^",2)
    ...s TUnitDR=$p($g(^DHCEQEquip(EquipID)),"^",5)  //单位
    ...i TUnitDR '=""  d
    ....s TUnit = ##Class(web.DHCEQCommon).GetTrakNameByID("uom",TUnitDR)
    ...s TEquipTypeDR=$p($g(^DHCEQEquip(EquipID)),"^",63)  //类组
    ...q:(##Class(web.DHCEQCommon).EquipTypeIsIn(TEquipTypeDR,CurGroupID))
    ...i TEquipTypeDR '=""  d
    ....s TEquipType = $p($g(^DHCEQCCode("DHCEQCEquipType",TEquipTypeDR)),"^",2)
    ...s TEquipNo=$p($g(^DHCEQEquip(EquipID)),"^",71)  //设备编号
    ...s TStatCatDR=$p($g(^DHCEQEquip(EquipID)),"^",75)  //类型
    ...i TStatCatDR'="" d
    ....s TStatCat=$p($g(^DHCEQCCode("DHCEQCStatCat",TStatCatDR)),"^",2)
    ...s TEquipCatDR=$p($g(^DHCEQEquip(EquipID)),"^",4)  //分类
    ...i TEquipCatDR'="" d
    ....s TEquipCat=$p($g(^DHCEQCCode("DHCEQCEquipeCat",TEquipCatDR)),"^",2)
    ...s TOriginalFee=$p($g(^DHCEQEquip(EquipID)),"^",27)  //原值
    ...s TOriginalFee=$FN(TOriginalFee,"",2)
    ...s TQuantity=1
    ...s TLimitYearNum=$p($g(^DHCEQEquip(EquipID)),"^",31)
    ...s TStoreLocDR=$p($g(^DHCEQEquip(EquipID)),"^",19)  //使用科室
    ...q:(vUseLocDR'="")&&(vUseLocDR'=TStoreLocDR)
    ...i TStoreLocDR'=""  d
    ....s TStoreLoc = ##class(web.DHCEQCommon).GetTrakNameByID("dept",TStoreLocDR)
    ....;##class(web.DHCEQCommon).GetTrakNameByID("dept",TStoreLocDR)
    ....;s TStoreLocCode=$p($g(^CTLOC(TStoreLocDR)),"^",1)   //modify by jyp 2019-10-18 CTLOC调整
    ....s TStoreLocCode=##class(web.DHCEQCommon).GetTrakNameByID("deptcode",TStoreLocDR)   //modify by jyp 2019-10-18 CTLOC调整
    ...s TManuFactoryDR=$p($g(^DHCEQEquip(EquipID)),"^",26)  //生产厂商
    ...i TManuFactoryDR '=""  d
    ....s TManuFactory = $p($g(^DHCEQCCode("DHCEQCManufacturer",TManuFactoryDR)),"^",1)
    ...s TProviderDR=$p($g(^DHCEQEquip(EquipID)),"^",25)  //供应商
    ...i TProviderDR '=""  d
    ....s TProvider =##Class(web.DHCEQCommon).GetTrakNameByID("prov",TProviderDR)
    ...s TStartDate=$p($g(^DHCEQEquip(EquipID)),"^",44)  //启用日期
    ...Set TStartDate=##Class(web.DHCEQCommon).TransValueToPage(TStartDate,"date")
    ...s TTransAssetDate=$p($g(^DHCEQEquip(EquipID)),"^",45)  //转资日期
    ...Set TTransAssetDate=##Class(web.DHCEQCommon).TransValueToPage(TTransAssetDate,"date")
    ...s TLeaveFeactoryNo=$p($g(^DHCEQEquip(EquipID)),"^",10)  //出厂编号
    ...//modify by GBX 2016-01-07  国资办需求新增截止2015-12-31的已提折旧和未提折旧
    ...;s DepreInfo=..GetDepreInfo(EquipID)
    ...s DepreInfo=##Class(web.DHCEQMonthDepre).GetDepreSetInfo(EquipID,"63917","1","1")
    ...;63917
    ...s TDepreFee=$p(DepreInfo,"^",3)  //已计提折旧
    ...s TDepreFee=$FN(TDepreFee,"",2)
    ...s TNetFee=TOriginalFee-TDepreFee  //未提折旧
    ...//modify by GBX 2016-01-07  国资办需求新增截止2015-12-31的已提折旧和未提折旧
    ...d OutputRowGetAdjustDataInfo
    quit
OutputRowGetAdjustDataInfo
   s Data=$lb(TRowID,TEquipName,TModel,TUnit,TEquipType,TStatCat,TEquipCat,TEquipNo,TOriginalFee,TStoreLoc,TManuFactory,TProvider,TStartDate,TTransAssetDate,TLeaveFeactoryNo,TQuantity,TStoreLocCode,TDate,TLimitYearNum,TDepreFee,TNetFee)
    Set ^CacheTemp(repid,index)=Data
    Set index=index+1
    quit
ResetVariablesGetAdjustDataInfo
    s (TRowID,TEquipName,TModel,TModelDR,TUnit,TUnitDR,TEquipType,TEquipTypeDR,TEquipCatDR,TEquipCat,TStatCat,TStatCatDR,TEquipNo,TOriginalFee,TStoreLoc,TStoreLocDR,TManuFactory,TManuFactoryDR,TProvider,TProviderDR,TStartDate,TTransAssetDate,TLeaveFeactoryNo,TQuantity,TStoreLocCode,TDate,TLimitYearNum,TDepreFee,TNetFee)=""
    quit
}

ClassMethod GetAdjustDataFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAdjustDataExecute ]
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

Query GetAdjustData(vStartDate As %String = "", vEndDate As %String = "", QXType As %String = "", vUseLoc As %String = "", vUseLocDR As %String = "", EquipType As %String = "", EquipTypeDR As %String = "", CurGroupID As %String = "", CurLocID As %String = "") As %Query(ROWSPEC = "TRowID:%String,TEquipName:%String,TModel:%String,TUnit:%String,TEquipType:%String,TStatCat:%String,TEquipCat:%String,TEquipNo:%String,TOriginalFee:%String,TStoreLoc:%String,TManuFactory:%String,TProvider:%String,TStartDate:%String,TTransAssetDate:%String,TLeaveFeactoryNo:%String,TQuantity:%String,TStoreLocCode:%String,TDate:%String,TLimitYearNum:%String,TDepreFee:%String,TNetFee:%String") [ SqlProc ]
{
}

/****************************************************************/
/// w ##Class(web.DHCEQYJSRunQian).GetOldECCode("633600")
ClassMethod GetOldECCode(vECCode As %String = "")
{
    s return=""
    i vECCode="" q ""
    s ECTRowID=$o(^DHCEQCCode("DHCEQCTree",0,"TypeCode",1,vECCode,0))
    s PreRowID=$p($g(^DHCEQCCode("DHCEQCTree",ECTRowID)),"^",4)
    i PreRowID=0
    {
        s return=$p($g(^DHCEQCCode("DHCEQCTree",ECTRowID)),"^",2)
        s return=$e(return,2,3)
    }
    else
    {
        s PreCode=$p($g(^DHCEQCCode("DHCEQCTree",PreRowID)),"^",2)
        d ..GetOldECCode(PreCode)
    }
    q return
}

/*************************************************************/
/// Add By GBX 2014-09-21
/// 描述:配件供应商供货统计
ClassMethod AccessoryVendorStatClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = AccessoryVendorStatExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)

    Quit $$$OK
}

ClassMethod AccessoryVendorStatExecute(ByRef qHandle As %Binary, vStartDate As %String = "", vEndDate As %String = "", QXType As %String = "", EquipType As %String = "", EquipTypeDR As %String = "", CurGroupID As %String = "", CurLocID As %String = "", vProviderDR As %String = "", vMonthStr As %String = "") As %Status
{
    ;new repid, index,rowid
    Set repid=$I(^CacheTemp)
    Set qHandle=$lb(0,repid,0)
    s index=1
    
    i ((vStartDate="")&&(vEndDate="")) Quit $$$OK
    
    i EquipType="" s EquipTypeDR=""
    i vStartDate=""  d
    .s BeginDate=0
    e  d
    .;s BeginDate=$ZDH(vStartDate,3)-1
    .;日期格式统一调整    Modify by CSY 2017-03-02
    .s BeginDate=##Class(web.DHCEQCommon).TransValueFromPage(vStartDate,"date")-1
    i vEndDate=""  d
    .s EndDate=+$H
    e  d
    .;s EndDate=$ZDH(vEndDate,3)
    .;日期格式统一调整    Modify by CSY 2017-03-02
    .s EndDate=##Class(web.DHCEQCommon).TransValueFromPage(vEndDate,"date")
    k ^GBX

    //入库
    s ProviderID=""
    f  s ProviderID=$o(^DHCEQAInStock(0,"Provider",ProviderID)) q:(ProviderID="")  d
    .q:(vProviderDR'="")&&(ProviderID'=vProviderDR)
    .s ISRowID=0
    .f  s ISRowID=$o(^DHCEQAInStock(0,"Provider",ProviderID,ISRowID)) q:ISRowID=""  d
    ..d ResetVariablesGetAccessoryVendorStat
    ..s InStockNo=$p($g(^DHCEQAInStock(ISRowID)),"^",6)  //入库单号
    ..q:InStockNo=""
    ..s ISStatus=$p($g(^DHCEQAInStock(ISRowID)),"^",16)  //状态
    ..q:ISStatus'=2
    ..s AuditDate=$p($g(^DHCEQAInStock(ISRowID)),"^",24)  //审核日期
    ..q:(AuditDate="")
    ..q:((BeginDate'="")&&(BeginDate>AuditDate))
    ..q:((EndDate'="")&&(EndDate<AuditDate))
    ..s TEquipTypeDR=$p($g(^DHCEQAInStock(ISRowID)),"^",2)  //配件类组
    ..q:(##Class(web.DHCEQACommon).AccessoryTypeIsIn(TEquipTypeDR,CurGroupID))
    ..s TRowID=ProviderID
    ..s TVendorCode=$p($g(^DHCEQCCode("DHCEQCVendor",ProviderID)),"^",1)
    ..s TBankNo=$p($g(^DHCEQCCode("DHCEQCVendor",ProviderID)),"^",14)
    ..s TBank=$p($g(^DHCEQCCode("DHCEQCVendor",ProviderID)),"^",13)
    ..s TVendor=##class(web.DHCEQCommon).GetTrakNameByID("prov",ProviderID) //供应商
    ..i TEquipTypeDR'="" s TEquipType=$p($g(^DHCEQCCode("DHCEQCEquipType",TEquipTypeDR)),"^",2)
    ..s ISLRowID=0 
    ..f  s ISLRowID=$o(^DHCEQAInStockList(0,"AInStock",ISRowID,ISLRowID)) q:ISLRowID=""  d
    ...s TQuantity=$p($g(^DHCEQAInStockList(ISLRowID)),"^",9)
    ...s TOriginalFee=$fn($p($g(^DHCEQAInStockList(ISLRowID)),"^",8),"",2)
    ...s TAmount=$fn(TQuantity*TOriginalFee,"",2)
    ...s TEquipName=$p($g(^DHCEQAInStockList(ISLRowID)),"^",4)
    ...d OutputRowGetAccessoryVendorStat
    
    //退货
    s RRowID=0
    f  s RRowID=$o(^DHCEQAReduce(RRowID)) q:RRowID=""  d
    .d ResetVariablesGetAccessoryVendorStat
    .s vendorid=$p($g(^DHCEQAReduce(RRowID)),"^",6) //供应商
    .q:vendorid=""
    .q:(vProviderDR'="")&&(vendorid'=vProviderDR)
    .s RType=$p($g(^DHCEQAReduce(RRowID)),"^",3)  //减少类型
    .q:RType'=1
    .s Status=$p($g(^DHCEQAReduce(RRowID)),"^",23)  //状态
    .q:Status'=2
    .s AuditDate=$p($g(^DHCEQAReduce(RRowID)),"^",16) //审核日期
    .q:AuditDate=""
    .q:((BeginDate'="")&&(BeginDate>AuditDate))
    .q:((EndDate'="")&&(EndDate<AuditDate))
    .s TEquipTypeDR=$p($g(^DHCEQAReduce(RRowID)),"^",2)  //配件类组
    .q:(##Class(web.DHCEQACommon).AccessoryTypeIsIn(TEquipTypeDR,CurGroupID))
    .s TRowID=vendorid
    .s TBankNo=$p($g(^DHCEQCCode("DHCEQCVendor",vendorid)),"^",14)
    .s TBank=$p($g(^DHCEQCCode("DHCEQCVendor",vendorid)),"^",13)
    .s TVendor=##class(web.DHCEQCommon).GetTrakNameByID("prov",vendorid)    //供应商
    .s TVendorCode=$p($g(^DHCEQCCode("DHCEQCVendor",vendorid)),"^",1)
    .s RLRowID=0
    .f  s RLRowID=$o(^DHCEQAReduceList(0,"Reduce",RRowID,RLRowID))  q:RLRowID=""  d
    ..s TQuantity=0-$p($g(^DHCEQAReduceList(RLRowID)),"^",10)
    ..s TOriginalFee=$fn($p($g(^DHCEQAReduceList(RLRowID)),"^",9),"",2)
    ..s TAmount=$fn(TQuantity*TOriginalFee,"",2)
    ..s TItemDR=$p($g(^DHCEQAReduceList(RLRowID)),"^",2)
    ..s TEquipName=$p($g(^DHCEQCCode("DHCEQCAccessory",TItemDR)),"^",2)
    ..d OutputRowGetAccessoryVendorStat

    Quit $$$OK
OutputRowGetAccessoryVendorStat
    s Data=$lb(TRowID,TVendorCode,TVendor,TBankNo,TBank,TAmount,TEquipName)
    s ^GBX(TRowID)=Data
    Set ^CacheTemp(repid,index)=Data
    Set index=index+1
    quit
ResetVariablesGetAccessoryVendorStat
    s (TRowID,TVendorCode,TVendor,TBankNo,TBank,TAmount,TEquipName)=""
    quit
}

ClassMethod AccessoryVendorStatFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = AccessoryVendorStatExecute ]
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

/// d ##class(%ResultSet).RunQuery("web.DHCEQYJSRunQian","AccessoryVendorStat","2014-09-01","2014-09-15")
Query AccessoryVendorStat(vStartDate As %String = "", vEndDate As %String = "", QXType As %String = "", EquipType As %String = "", EquipTypeDR As %String = "", CurGroupID As %String = "", CurLocID As %String = "", vProviderDR As %String = "", vMonthStr As %String = "") As %Query(ROWSPEC = "TRowID:%String,TVendorCode:%String,TVendor:%String,TBankNo:%String,TBank:%String,TAmount:%String,TEquipName:%String") [ SqlProc ]
{
}

/*********************************************************************************************************************************/
/// add BY:GBX 2014-9-16 14:43:31
/// 配件过期预警
/// d ##class(%ResultSet).RunQuery("web.DHCEQYJSRunQian","AccessoryWarning","2014-09-01","")
Query AccessoryWarning(vStartDate As %String = "", vEndDate As %String = "", vItemDR As %String = "", vProviderDR As %String = "", vAccessoryTypeDR As %String = "", QXType As %String = "", CurGroupID As %String = "", CurLocID As %String = "") As %Query(ROWSPEC = "TRowID:%String,TDesc:%String,TCode:%String,TModel:%String,TProveder:%String,TSerialNo:%String,ProDate:%String,ExpiryDate:%String,TExpiredDays:%String,TWarningDays:%String") [ SqlProc ]
{
}

ClassMethod AccessoryWarningExecute(ByRef qHandle As %Binary, vStartDate As %String = "", vEndDate As %String = "", vItemDR As %String = "", vProviderDR As %String = "", vAccessoryTypeDR As %String = "", QXType As %String = "", CurGroupID As %String = "", CurLocID As %String = "") As %Status
{
    ;new repid,index
    Set repid=$I(^CacheTemp)
    Set qHandle=$lb(0,repid,0)
    s index=1
    i ((vStartDate="")&&(vEndDate="")) Quit $$$OK
    
    i vStartDate=""  d
    .s BeginDate=0
    e  d
    .;s BeginDate=$ZDH(vStartDate,3)-1
    .;日期格式统一调整    Modify by CSY 2017-03-02
    .s BeginDate=##Class(web.DHCEQCommon).TransValueFromPage(vStartDate,"date")-1
    i vEndDate=""  d
    .s EndDate=+$H
    e  d
    .;s EndDate=$ZDH(vEndDate,3)
    .;日期格式统一调整    Modify by CSY 2017-03-02
    .s EndDate=##Class(web.DHCEQCommon).TransValueFromPage(vEndDate,"date")

    S ItemDR=""
    f  s ItemDR=$o(^DHCEQAStockDetail(0,"Accessory",ItemDR)) q:ItemDR=""  d
    .d ResetVariablesAccessoryWarning
    .s AccessoryTypeDR=$p($g(^DHCEQCCode("DHCEQCAccessory",ItemDR)),"^",14)  //配件类组
    .q:(vAccessoryTypeDR'="")&&(AccessoryTypeDR'=vAccessoryTypeDR)
    .q:(##Class(web.DHCEQACommon).AccessoryTypeIsIn(AccessoryTypeDR,CurGroupID))
    .s ExpiredFlag=$p($g(^DHCEQCCode("DHCEQCAccessory",ItemDR)),"^",32)  //是否有保质期
    .q:(ExpiredFlag'="Y")
    .s TExpiredDays=$p($g(^DHCEQCCode("DHCEQCAccessory",ItemDR)),"^",33)  //保质期月数
    .s TWarningDays=$p($g(^DHCEQCCode("DHCEQCAccessory",ItemDR)),"^",34)  //保质期预警天数
    .s TDesc=$p($g(^DHCEQCCode("DHCEQCAccessory",ItemDR)),"^",2)  //配件名称
    .s TCode=$p($g(^DHCEQCCode("DHCEQCAccessory",ItemDR)),"^",1)  //编码
    .q:(vItemDR'="")&&(TDesc'[vItemDR)&&(TCode'[vItemDR)
    .s TModel=$p($g(^DHCEQCCode("DHCEQCAccessory",ItemDR)),"^",4)  //规格
    .s StockDetailID=""
    .f  s StockDetailID=$o(^DHCEQAStockDetail(0,"Accessory",ItemDR,StockDetailID)) q:StockDetailID=""  d
    ..s TStatus=$p($g(^DHCEQAStockDetail(StockDetailID)),"^",12)  //状态
    ..q:(TStatus'=0)
    ..s LocDR=$p($g(^DHCEQAStockDetail(StockDetailID)),"^",1)  //科室
    ..q:(##Class(web.DHCEQCommon).CheckLocType("0101",LocDR)'=0)
    ..s TRowID=StockDetailID
    ..s AInStockListID=$p($g(^DHCEQAStockDetail(StockDetailID)),"^",3)  //入库详细ID
    ..s ProDate=$p($g(^DHCEQAInStock(AInStockListID)),"",17)  //生产日期
    ..q:(ProDate="")
    ..;s TExpiryDate=##class(web.DHCEQCommon).DateAdd("M",TExpiredDays,$ZD(ProDate,4))  //过期日期
    ..;s ExpiryDate=$ZDATEH(TExpiryDate,4)
    ..;日期格式统一调整    Modify by CSY 2017-03-02
    ..s ProDate=##Class(web.DHCEQCommon).TransValueToPage(ProDate,"date")
    ..s ExpiryDate=##Class(web.DHCEQCommon).DateAdd("M",TExpiredDays,ProDate)  //过期日期
    ..s ExpiryWarningDate=TExpiryDate-TWarningDays
    ..q:(BeginDate'="")&&(BeginDate<ExpiryWarningDate)&&(EndDate'="")&&(EndDate>ExpiryWarningDate)
    ..s TProvederDR=$p($g(^DHCEQAStockDetail(StockDetailID)),"^",16)
    ..q:(vProviderDR'="")&&(TProvederDR'=vProviderDR)
    ..i TProvederDR'="" s TProvider =##class(web.DHCEQCommon).GetTrakNameByID("prov",TProvederDR)
    ..s TSerialNo=$p($g(^DHCEQAStockDetail(StockDetailID)),"^",9)
    ..s ProDate=##Class(web.DHCEQCommon).TransValueToPage(ProDate,"date")
    ..s ExpiryDate=##Class(web.DHCEQCommon).TransValueToPage(ExpiryDate,"date")
    ..d OutputRowAccessoryWarning
    
    Quit $$$OK
OutputRowAccessoryWarning
    s Data=$lb(TRowID,TDesc,TCode,TModel,TProveder,TSerialNo,ProDate,ExpiryDate,TExpiredDays,TWarningDays)
    Set ^CacheTemp(repid,index)=Data
    Set index=index+1
    quit
 
ResetVariablesAccessoryWarning  
    s (ExpiredFlag,TExpiredDays,TWarningDays,TDesc,TCode,TModel,TStatus,TRowID,AInStockListID,ProDate,ExpiryDate,TProvederDR,TProvider,TSerialNo,ExpiredFlag,ExpiryWarningDate)=""
    quit
}

ClassMethod AccessoryWarningFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = AccessoryWarningExecute ]
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

ClassMethod AccessoryWarningClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = AccessoryWarningExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

/********************************************************************************************************/
/// add BY:GBX 2014-9-16 14:46:30
/// 库存预警
/// d ##class(%ResultSet).RunQuery("web.DHCEQYJSRunQian","AccessoryStockWarning")
Query AccessoryStockWarning(vItemDR As %String = "", vAccessoryTypeDR As %String = "", vMinPrice As %String = "", vMaxPrice As %String = "", MinStock As %String = "", MaxStock As %String = "", QXType As %String = "", CurGroupID As %String = "", CurLocID As %String = "") As %Query(ROWSPEC = "TRowID:%String,TDesc:%String,TCode:%String,TAccessoryType:%String,TPrice:%String,TLoc:%String,TStock:%String,TDetailStock:%String,MinQty:%String,MaxQty:%String") [ SqlProc ]
{
}

ClassMethod AccessoryStockWarningExecute(ByRef qHandle As %Binary, vItemDR As %String = "", vAccessoryTypeDR As %String = "", vMinPrice As %String = "", vMaxPrice As %String = "", MinStock As %String = "", MaxStock As %String = "", QXType As %String = "", CurGroupID As %String = "", CurLocID As %String = "") As %Status
{
    ;new repid,index
    Set repid=$I(^CacheTemp)
    Set qHandle=$lb(0,repid,0)
    s index=1
    s ItemDR=""
    f  s ItemDR=$o(^DHCEQAStock(0,"Accessory",ItemDR)) q:ItemDR=""  d
    .d ResetVariablesAccessoryStockWarning
    .s AccessoryTypeDR=$p($g(^DHCEQCCode("DHCEQCAccessory",ItemDR)),"^",14)  //配件类组
    .q:(vAccessoryTypeDR'="")&&(vAccessoryTypeDR'=AccessoryTypeDR)
    .q:(##Class(web.DHCEQACommon).AccessoryTypeIsIn(AccessoryTypeDR,CurGroupID))
    .s TAccessoryType=$p($g(^DHCEQCCode("DHCEQCAccessoryType",AccessoryTypeDR)),"^",2)
    .s MinQty=$p($g(^DHCEQCCode("DHCEQCAccessory",ItemDR)),"^",48)  //最小库存量
    .q:(MinStock'="")&&(MinStock>MinQty)
    .s MaxQty=$p($g(^DHCEQCCode("DHCEQCAccessory",ItemDR)),"^",49)  //最大库存量
    .q:(MaxStock'="")&&(MaxStock<MaxQty)
    .s TDesc=$p($g(^DHCEQCCode("DHCEQCAccessory",ItemDR)),"^",2)  //名称
    .s TCode=$p($g(^DHCEQCCode("DHCEQCAccessory",ItemDR)),"^",1)  //编码
    .q:(vItemDR'="")&&(TDesc'[vItemDR)&&(TCode'[vItemDR)
    .s TPrice=$p($g(^DHCEQCCode("DHCEQCAccessory",ItemDR)),"^",7) //单价
    .S TPrice=$fn(TPrice,"",2)
    .q:(vMinPrice'="")&&(vMinPrice>TPrice)
    .q:(vMaxPrice'="")&&(vMaxPrice<TPrice)
    .s AStockID=""
    .f  s AStockID=$o(^DHCEQAStock(0,"Accessory",ItemDR,AStockID)) q:AStockID=""  d
    ..s LocDR=$p($g(^DHCEQAStock(AStockID)),"^",1)  //科室
    ..q:(##Class(web.DHCEQCommon).CheckLocType("0101",LocDR)'=0)
    ..s TLoc=##class(web.DHCEQCommon).GetTrakNameByID("dept",LocDR)
    ..s TLoc=##Class(web.DHCEQCommon).GetSplitDataByFlag(TLoc,"-")
    ..s TStock=$p($g(^DHCEQAStock(AStockID)),"^",10)  //库存量
    ..q:(MinQty'="")&&(MinQty<TStock)&&(MaxQty'="")&&(TStock<MaxQty)  //过滤不在正常库存的配件
    ..s TRowID=AStockID
    ..d OutputRowAccessoryStockWarning
    Quit $$$OK
 
OutputRowAccessoryStockWarning
    s Data=$lb(TRowID,TDesc,TCode,TAccessoryType,TPrice,TLoc,TStock,TDetailStock,MinQty,MaxQty)
    Set ^CacheTemp(repid,index)=Data
    Set index=index+1
    quit
 
ResetVariablesAccessoryStockWarning 
    s (TRowID,TDesc,TCode,TAccessoryType,TPrice,TLoc,TProvider,TStock,MinQty,MaxQty,ProviderDR,TDetailStock)=""
    quit
}

ClassMethod AccessoryStockWarningFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = AccessoryStockWarningExecute ]
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

ClassMethod AccessoryStockWarningClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = AccessoryStockWarningExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

/************************************************************************/
/// Add By DJ 2014-09-26
/// 描述:评价详细信息
Query EvaluateDetail(vSourceType As %String = "", vSourceID As %String = "", vApproveRole As %String = "") As %Query(ROWSPEC = "TRowID:%String,TSourceType:%String,TSourceID:%String,TEvaluateType:%String,TEvaluateTypeDR:%String,TScore:%String,TUser:%String,TDate:%String,TTime:%String,TApproveRole:%String") [ SqlProc ]
{
}

ClassMethod EvaluateDetailExecute(ByRef qHandle As %Binary, vSourceType As %String = "", vSourceID As %String = "", vApproveRole As %String = "") As %Status
{
    new repid, index,rowid
    Set repid=$I(^CacheTemp)
    Set qHandle=$lb(0,repid,0)
    
    i ((vSourceType="")&&(vSourceID="")) Quit $$$OK
    
    s index=1
    s rowid=0
    f  s rowid=$o(^DHCEQMEvaluate(0,"SourceID",vSourceType,vSourceID,rowid))  quit:rowid=""  d
    .d ResetVariablesEvaluateDetail
    .s TApproveRole=$p($g(^DHCEQMEvaluate(rowid)),"^",6)
    .q:(vApproveRole'="")&&(TApproveRole'=vApproveRole)
    .i TApproveRole'="" s TApproveRole=$p($g(^DHCEQCCode("DHCEQCApproveRole",TApproveRole)),"^",2)
    .s TRowID=rowid
    .s TSourceType=vSourceType
    .s TSourceID=vSourceID
    .s TEvaluateTypeDR=$p($g(^DHCEQMEvaluate(TRowID)),"^",3)
    .i TEvaluateTypeDR'="" s TEvaluateType=$p($g(^DHCEQCCode("DHCEQMCEvaluateType",TEvaluateTypeDR)),"^",2)
    .s TScore=$p($g(^DHCEQMEvaluate(TRowID)),"^",4)
    .s TUser=$p($g(^DHCEQMEvaluate(TRowID)),"^",7)
    .i TUser'="" s TUser=##class(web.DHCEQCommon).GetTrakNameByID("user",TUser)
    .s TDate=$p($g(^DHCEQMEvaluate(TRowID)),"^",8)
    .;i TDate'="" s TDate=$ZD(TDate,3)
    .;日期格式统一调整    Modify by CSY 2017-03-02
    .s TDate=##Class(web.DHCEQCommon).TransValueToPage(TDate,"date")
    .s TTime=$p($g(^DHCEQMEvaluate(TRowID)),"^",9)
    .;i TTime'="" s TTime=$ZT(TTime,1)
    .;日期格式统一调整    Modify by CSY 2017-03-02
    .i TTime'="" s TTime=##Class(web.DHCEQCommon).TransValueToPage(TTime,"time")
    .d OutputRowEvaluateDetail
    Quit $$$OK
OutputRowEvaluateDetail
    s Data=$lb(TRowID,TSourceType,TSourceID,TEvaluateType,TEvaluateTypeDR,TScore,TUser,TDate,TTime,TApproveRole)
    Set ^CacheTemp(repid,index)=Data
    Set index=index+1
    quit
ResetVariablesEvaluateDetail
    Set (TRowID,TSourceType,TSourceID,TEvaluateType,TEvaluateTypeDR,TScore,TUser,TDate,TTime,TApproveRole)=""
    quit
}

ClassMethod EvaluateDetailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = EvaluateDetailExecute ]
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

ClassMethod EvaluateDetailClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = EvaluateDetailExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

/****************************************************************************/
/// 设备科室设备领用汇总  modify BY:GBX 2014-10-30 20:24:28
/// d ##class(%ResultSet).RunQuery("web.DHCEQYJSRunQian","StoreMoveNew","08/2014","","","")
Query StoreMoveNew(vMonthStr As %String = "", QXType As %String = "", CurGroupID As %String = "", CurLocID As %String = "") As %Query(ROWSPEC = "TLocName:%String,TLocCode:%String,TEquipName:%String,TEquipDR:%String,TEquipNo:%String,TItemID:%String,TEquipCode:%String,TEquipCatDR:%String,TCatCode:%String,TUnit:%String,TModel:%String,TQuantity:%String,TOriginFee:%String,TRemark:%String,TStoreMoveNo:%String,TLimitYearsNum:%String") [ SqlProc ]
{
}

ClassMethod StoreMoveNewExecute(ByRef qHandle As %Binary, vMonthStr As %String = "", QXType As %String = "", CurGroupID As %String = "", CurLocID As %String = "") As %Status
{
    ;new repid, index,rowid
    Set repid=$I(^CacheTemp)
    Set qHandle=$lb(0,repid,0)
    s index=1

    i (vMonthStr="") Quit $$$OK
    ;s Year=$p(vMonthStr,"/",2)
    ;s Month=$p(vMonthStr,"/",1)
    ;s vMonthStr=Year_"-"_Month
    i vMonthStr'="" d
    .s vStartDate=##Class(web.DHCEQReport).GetMonthDate(vMonthStr,1)
    .s vEndDate=##Class(web.DHCEQReport).GetMonthDate(vMonthStr,2)
    .;s StartDate=$zdh(vStartDate,4)
    .;s EndDate=$zdh(vEndDate,4)
    .;日期格式统一调整    Modify by CSY 2017-03-02
    .s StartDate=##Class(web.DHCEQCommon).TransValueFromPage(vStartDate,"date")
    .s EndDate=##Class(web.DHCEQCommon).TransValueFromPage(vEndDate,"date")
    ;s MonthStr=$E($ZD(+$H,3),1,7)

    //科室领用
    s LocID=0
    f  s LocID=$o(^DHCEQStoreMove(0,"ToLocInDate",LocID)) q:LocID=""  d
    .s InAckDate=StartDate-1
    .f  s InAckDate=$o(^DHCEQStoreMove(0,"ToLocInDate",LocID,InAckDate)) q:((InAckDate="")||(InAckDate>EndDate))  d
    ..s rowid=0
    ..f  s rowid=$o(^DHCEQStoreMove(0,"ToLocInDate",LocID,InAckDate,0,2,rowid)) q:rowid=""  d
    ...s StoreMoveListID=0
    ...f  s StoreMoveListID=$o(^DHCEQStoreMoveList(0,"StoreMove",rowid,StoreMoveListID)) q:StoreMoveListID=""  d
    ....;s TLocName=##Class(web.DHCEQCommon).GetSplitDataByFlag($p($g(^CTLOC(LocID)),"^",2),"-")  //科室名称  //modify by jyp 2019-10-18 CTLOC调整
    ....s TLocName=##class(web.DHCEQCommon).GetTrakNameByID("dept",LocID)   //modify by jyp 2019-10-18 CTLOC调整
    ....q:(TLocName="")
    ....;s TLocCode=$p($g(^CTLOC(LocID)),"^",1)  //科室代码   //modify by jyp 2019-10-18 CTLOC调整
    ....s TLocCode=##class(web.DHCEQCommon).GetTrakNameByID("deptcode",LocID)  //modify by jyp 2019-10-18 CTLOC调整
    ....s TEquipDRs=$g(^DHCEQStoreMoveList(StoreMoveListID,"EX","RowIDs"))  //设备台帐ID
    ....S Lenth=$L(TEquipDRs,",")
    ....For i=1:1:Lenth Do
    .....d ResetVariablesStoreMoveNew
    .....s TEquipDR=$Piece(TEquipDRs,",",i)
    .....s TEquipNo=$p($g(^DHCEQEquip(TEquipDR)),"^",71)  //设备编号
    .....s TLimitYearsNum=$p($g(^DHCEQEquip(TEquipDR)),"^",31)  //折旧年限
    .....s TEquipTypeDR=$p($g(^DHCEQEquip(TEquipDR)),"^",63)  //设备类组  modify by GBX 2015-5-15 11:09:52
    .....q:(##Class(web.DHCEQCommon).EquipTypeIsIn(TEquipTypeDR,CurGroupID))  //  modify by GBX 2015-5-15 11:09:52
    .....s TItemID=$p($g(^DHCEQEquip(TEquipDR)),"^",7)  //设备项ID
    .....i TItemID'=""  d
    ......s TEquipCode=$p($g(^DHCEQCCode("DHCEQCMasterItem",TItemID)),"^",2)  //设备编码
    ......s TEquipCatDR=$p($g(^DHCEQCCode("DHCEQCMasterItem",TItemID)),"^",4)
    ......i TEquipCatDR'=""  d
    .......s TCatCode=$p($g(^DHCEQCCode("DHCEQCEquipeCat",TEquipCatDR)),"^",1)  //国标码
    .....s TEquipName=$p($g(^DHCEQStoreMoveList(StoreMoveListID)),"^",5)  //设备名称
    .....s TUnitDR=$p($g(^DHCEQStoreMoveList(StoreMoveListID)),"^",10)  //设备单位
    .....i TUnitDR'="" s TUnit=##Class(web.DHCEQCommon).GetTrakNameByID("uom",TUnitDR)
    .....s TModelDR=$p($g(^DHCEQStoreMoveList(StoreMoveListID)),"^",9)  //设备规格
    .....i TModelDR'="" s TModel=$p($g(^DHCEQCCode("DHCEQCModel",TModelDR)),"^",2)
    .....s TQuantity=1   //数量
    .....s TOriginFee=$p($g(^DHCEQStoreMoveList(StoreMoveListID)),"^",7)  //原值
    .....s TRemark=$p($g(^DHCEQStoreMoveList(StoreMoveListID)),"^",11)  //备注
    .....s TStoreMoveNo=$p($g(^DHCEQStoreMove(rowid)),"^",1)  //转移单号
    .....d OutputRowStoreMoveNew
    Quit $$$OK
    
ResetVariablesStoreMoveNew
    s (TEquipName,TEquipDR,TEquipNo,TItemID,TEquipCode,TEquipCatDR,TCatCode,TUnitDR,TUnit,TModelDR,TModel,TQuantity,TOriginFee,TRemark,TStoreMoveNo,TLimitYearsNum,TEquipTypeDR)=""
    quit        
OutputRowStoreMoveNew
    s Data=$lb(TLocName,TLocCode,TEquipName,TEquipDR,TEquipNo,TItemID,TEquipCode,TEquipCatDR,TCatCode,TUnit,TModel,TQuantity,TOriginFee,TRemark,TStoreMoveNo,TLimitYearsNum)
    Set ^CacheTemp(repid,index)=Data
    Set index=index+1
    quit
}

ClassMethod StoreMoveNewFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = StoreMoveNewExecute ]
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

ClassMethod StoreMoveNewClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = StoreMoveNewExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)

    Quit $$$OK
}

/// 配件科室领用汇总  modify BY:GBX 2014年10月30日20:24:44
/// d ##class(%ResultSet).RunQuery("web.DHCEQDJ","AStockMoveList")
Query AStockMoveList(vStartDate As %String = "", vEndDate As %String = "", QXType As %String = "", CurGroupID As %String = "", CurLocID As %String = "") As %Query(ROWSPEC = "TRowID:%String,TLocName:%String,TLocCode:%String,Amont:%String") [ SqlProc ]
{
}

ClassMethod AStockMoveListExecute(ByRef qHandle As %Binary, vStartDate As %String = "", vEndDate As %String = "", QXType As %String = "", CurGroupID As %String = "", CurLocID As %String = "") As %Status
{
    ;new repid, index,rowid
    Set repid=$I(^CacheTemp)
    Set qHandle=$lb(0,repid,0)
    s index=1
    
    i ((vStartDate="")&&(vEndDate="")) Quit $$$OK   
    i vStartDate=""  d
    .s BeginDate=0
    e  d
    .;s BeginDate=$ZDH(vStartDate,3)
    .;日期格式统一调整    Modify by CSY 2017-03-02
    .s BeginDate=##Class(web.DHCEQCommon).TransValueFromPage(vStartDate,"date")
    i vEndDate=""  d
    .s EndDate=+$H
    e  d
    .;s EndDate=$ZDH(vEndDate,3)
    .;日期格式统一调整    Modify by CSY 2017-03-02
    .s EndDate=##Class(web.DHCEQCommon).TransValueFromPage(vEndDate,"date")
    
    Set MoveStockID=0
    For  Set MoveStockID=$Order(^DHCEQAMoveStock(MoveStockID)) Quit:MoveStockID=""  Do
    .Do ResetVariablesAStockMoveList
    .s TRowID=MoveStockID
    .s TMoveType=$p($g(^DHCEQAMoveStock(MoveStockID)),"^",14)
    .q:TMoveType'=0
    .s TStatus=$p($g(^DHCEQAMoveStock(MoveStockID)),"^",28)
    .q:(TStatus'=2)
    .s TAuditDate=$p($g(^DHCEQAMoveStock(MoveStockID)),"^",17)
    .q:((TAuditDate>EndDate)||(TAuditDate<BeginDate))
    .s TAccessoryTypeDR=$p($g(^DHCEQAMoveStock(MoveStockID)),"^",2)
    .q:(##Class(web.DHCEQACommon).AccessoryTypeIsIn(TAccessoryTypeDR,CurGroupID))
    .s TToLocDR=$p($g(^DHCEQAMoveStock(MoveStockID)),"^",5)
    .i TToLocDR'=""  d
    ..s TLocName=##class(web.DHCEQCommon).GetTrakNameByID("dept",TToLocDR)  //科室名称
    ..;s TLocCode=$p($g(^CTLOC(TToLocDR)),"^",1)  //科室代码   //modify by jyp 2019-10-18 CTLOC调整
    ..s TLocCode=##class(web.DHCEQCommon).GetTrakNameByID("deptcode",TToLocDR)   //modify by jyp 2019-10-18 CTLOC调整
    .s MoveStockListID=0
    .f  s MoveStockListID=$Order(^DHCEQAMoveStockList(0,"MoveStock",MoveStockID,MoveStockListID)) q:MoveStockListID=""  d
    ..s Amont=$p($g(^DHCEQAMoveStockList(MoveStockListID)),"^",12)
    ..s Amont=$fn(Amont,"",2)
    ..d OutputRowAStockMoveList
    
    Quit $$$OK

ResetVariablesAStockMoveList
    s (TRowID,TLocName,TLocCode,Amont)=""
    quit
OutputRowAStockMoveList
    s Data=$lb(TRowID,TLocName,TLocCode,Amont)
    Set ^CacheTemp(repid,index)=Data
    Set index=index+1
    quit
}

ClassMethod AStockMoveListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = AStockMoveListExecute ]
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

ClassMethod AStockMoveListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = AStockMoveListExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)

    Quit $$$OK
}

/// 设备库存汇总  modify BY:GBX 2014-10-30 20:25:32
/// d ##class(%ResultSet).RunQuery("web.DHCEQYJSRunQian","InStockHZ","2014-07","","90","410")
Query InStockHZ(vMonthStr As %String = "", QXType As %String = "", CurGroupID As %String = "", CurLocID As %String = "") As %Query(ROWSPEC = "TEquipName:%String,TUnitDR:%String,TUnit:%String,TQuantity:%String,TAmount:%String,TTQuantity:%String,TTAmount:%String,TTTQuantity:%String,TTTAmount:%String") [ SqlProc ]
{
}

ClassMethod InStockHZExecute(ByRef qHandle As %Binary, vMonthStr As %String = "", QXType As %String = "", CurGroupID As %String = "", CurLocID As %String = "") As %Status
{
    ;new repid, index,rowid
    Set repid=$I(^CacheTemp)
    Set qHandle=$lb(0,repid,0)
    s index=1
    
    ;s vMonthStr=$E($ZD(+$H-50,3),1,7)
    i (vMonthStr="") Quit $$$OK
    ;s Year=$p(vMonthStr,"/",2)
    ;s Month=$p(vMonthStr,"/",1)
    ;s vMonthStr=Year_"-"_Month
    i vMonthStr'="" d
    .s vStartDate=##Class(web.DHCEQReport).GetMonthDate(vMonthStr,1)
    .s vEndDate=##Class(web.DHCEQReport).GetMonthDate(vMonthStr,2)
    .;s StartDate=$zdh(vStartDate,4)
    .;s EndDate=$zdh(vEndDate,4)
    .;日期格式统一调整    Modify by CSY 2017-03-02
    .s StartDate=##Class(web.DHCEQCommon).TransValueFromPage(vStartDate,"date")
    .s EndDate=##Class(web.DHCEQCommon).TransValueFromPage(vEndDate,"date")
    s MonthStr=$E($ZD(+$H,3),1,7)
    i ((MonthStr<vMonthStr)||(vMonthStr=MonthStr)) Quit $$$OK  //不能查询当月和之后月份的汇总
    s SnapID=##Class(web.DHCEQSnapShot).GetSnapIDByMonth(vMonthStr)
    i SnapID="" Quit $$$OK  //快照为空时不能出报表
    //入库
    d ResetVariablesInStockHZ
    s EquipType=0
    f  s EquipType=$o(^DHCEQInStock(0,"TypeDate",EquipType)) q:EquipType=""  d
    .s BillAuditDate=StartDate-1
    .f  s BillAuditDate=$o(^DHCEQInStock(0,"TypeDate",EquipType,BillAuditDate)) q:((BillAuditDate="")||(BillAuditDate>EndDate))  d
    ..s rowid=0
    ..f  s rowid=$o(^DHCEQInStock(0,"TypeDate",EquipType,BillAuditDate,rowid)) q:rowid=""  d
    ...s InStockListID=0
    ...f  s InStockListID=$o(^DHCEQInStockList(0,"InStock",rowid,InStockListID)) q:InStockListID=""  d
    ....s TStatus=$p($g(^DHCEQInStock(rowid)),"^",10)
    ....q:((TStatus'="")&&(TStatus'=2))
    ....s TEquipName=$p($g(^DHCEQInStockList(InStockListID)),"^",5)  //设备名称
    ....s TOriginFee=$p($g(^DHCEQInStockList(InStockListID)),"^",7)  //设备原值
    ....s TUnitDR=$p($g(^DHCEQInStockList(InStockListID)),"^",10)  ///单位
    ....i TUnitDR'="" s TUnit=##Class(web.DHCEQCommon).GetTrakNameByID("uom",TUnitDR) 
    ....s TQuantity=$p($g(^DHCEQInStockList(InStockListID)),"^",8)  //数量
    ....s TAmount=TOriginFee*TQuantity
    ....d OutputRowInStockHZ
    
    //出库
    d ResetVariablesInStockHZ
    s EquipType=0
    f  s EquipType=$o(^DHCEQStoreMove(0,"TypeDate",EquipType)) q:EquipType=""  d
    .s BillAuditDate=StartDate-1
    .f  s BillAuditDate=$o(^DHCEQStoreMove(0,"TypeDate",EquipType,BillAuditDate)) q:((BillAuditDate="")||(BillAuditDate>EndDate))  d
    ..s rowid=0
    ..f  s rowid=$o(^DHCEQStoreMove(0,"TypeDate",EquipType,BillAuditDate,rowid)) q:rowid=""  d
    ...s StoreMoveListID=0
    ...f  s StoreMoveListID=$o(^DHCEQStoreMoveList(0,"StoreMove",rowid,StoreMoveListID)) q:StoreMoveListID=""  d
    ....s TStatus=$p($g(^DHCEQStoreMove(rowid)),"^",13)
    ....q:((TStatus'="")&&(TStatus'=2))
    ....s MoveType=$p($g(^DHCEQStoreMove(rowid)),"^",12)
    ....q:((MoveType'="")&&(MoveType'=0))
    ....s TEquipName=$p($g(^DHCEQStoreMoveList(StoreMoveListID)),"^",5)  //设备名称
    ....s TOriginFee=$p($g(^DHCEQStoreMoveList(StoreMoveListID)),"^",7)  //设备原值
    ....s TUnitDR=$p($g(^DHCEQStoreMoveList(StoreMoveListID)),"^",10)  ///单位
    ....i TUnitDR'="" s TUnit=##Class(web.DHCEQCommon).GetTrakNameByID("uom",TUnitDR) 
    ....s TTQuantity=$p($g(^DHCEQStoreMoveList(StoreMoveListID)),"^",8)  //数量
    ....s TTAmount=TOriginFee*TTQuantity
    ....d OutputRowInStockHZ    

    //库房库存
    d ResetVariablesInStockHZ
    s RowID=0
    f  s RowID=$o(^DHCEQSnapShot(SnapID,"Equip",RowID))  q:RowID=""  d
    .s TStatus=$p($g(^DHCEQSnapShot(SnapID,"Equip",RowID)),"^",38)  //状态
    .q:((TStatus'=0)&&(TStatus'=2))
    .s TEquipName=$p($g(^DHCEQSnapShot(SnapID,"Equip",RowID)),"^",1)  //设备名称
    .s TUnitDR=$p($g(^DHCEQSnapShot(SnapID,"Equip",RowID)),"^",5)  //设备单位
    .i TUnitDR'="" s TUnit=##Class(web.DHCEQCommon).GetTrakNameByID("uom",TUnitDR) 
    .s TTTQuantity=1
    .s TTTAmount=$p($g(^DHCEQSnapShot(SnapID,"Equip",RowID)),"^",27)  //原值
    .d OutputRowInStockHZ
    
    Quit $$$OK
ResetVariablesInStockHZ
    s (TEquipName,TUnitDR,TUnit,TQuantity,TOriginFee,TStatus,TAddDate,TStartDate,TAmount,TTQuantity,TTAmount,TTTQuantity,TTTAmount)=""
    quit
OutputRowInStockHZ
    ;s (TUnitDR,TUnit)=""
    s Data=$lb(TEquipName,TUnitDR,TUnit,TQuantity,TAmount,TTQuantity,TTAmount,TTTQuantity,TTTAmount)
    Set ^CacheTemp(repid,index)=Data
    Set index=index+1
    quit
}

ClassMethod InStockHZFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = InStockHZExecute ]
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

ClassMethod InStockHZClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = InStockHZExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)

    Quit $$$OK
}

/// w ##Class(web.DHCEQYJSRunQian).AAA()
ClassMethod AAA()
{
    s Count=0
    s rowid=0
    f  s rowid=$o(^DHCEQEquip(rowid))  q:rowid=""  d
    .s EQStatus=$p($g(^DHCEQEquip(rowid)),"^",38)
    .s EQStockStatus=$p($g(^DHCEQEquip(rowid)),"^",60)
    .q:'((EQStatus<=2)&&(EQStockStatus=1))
    .s EQEquipTypeDR=$p($g(^DHCEQEquip(rowid)),"^",63)
    .q:EQEquipTypeDR<6
    .q:EQEquipTypeDR>8
    .s EQInvalidFlag=$p($g(^DHCEQEquip(rowid)),"^",59)
    .q:EQInvalidFlag="Y"
    .s Count=Count+1
    
    q Count
}

/***************************************************/
/// w ##Class(web.DHCEQYJSRunQian).ImportMasterItemA()
/// 说明:导入弋矶山医工部数据，转换:房屋建筑物(器械)，一般设备(器械)，其他固定资产(器械)三个类组的设备项为专用设备
/// modify by GBX 2015-09-07 
ClassMethod ImportMasterItemA()
{
    s Count=0
    k PLIST
    k PMODELIST
    n EquipTypeDR,Code,Desc,CatDR,StatCatDR,UnitDR,OldCatDR,ModelCode,ModelDesc
    s rowid=0
    s SQLCODE=0
    b  //1
    f  s rowid=$o(^DHCEQCCode("DHCEQCMasterItem",rowid))  q:((rowid="")||(SQLCODE'=0))  d
    .q:(rowid="")
    .s EquipTypeDR=$p($g(^DHCEQCCode("DHCEQCMasterItem",rowid)),"^",3)
    .q:(EquipTypeDR'=6)&(EquipTypeDR'=7)&(EquipTypeDR'=8)
    .s Code=$p($g(^DHCEQCCode("DHCEQCMasterItem",rowid)),"^",2)  //代码
    .s Desc=$p($g(^DHCEQCCode("DHCEQCMasterItem",rowid)),"^",1)  //名称
    .;s EquipTypeDR=2  类组
    .s CatDR=$p($g(^DHCEQCCode("DHCEQCMasterItem",rowid)),"^",4) //分类
    .s StatCatDR=$p($g(^DHCEQCCode("DHCEQCMasterItem",rowid)),"^",5) //类型
    .s UnitDR=$p($g(^DHCEQCCode("DHCEQCMasterItem",rowid)),"^",7)  //单位
    .s OldCatDR=$p($g(^DHCEQCCode("DHCEQCMasterItem",rowid)),"^",10)  //老编码
    .s Count=Count+1
    .s PLIST(2)=Desc
    .s PLIST(3)=Code
    .s PLIST(4)="2"
    .s PLIST(5)=CatDR
    .s PLIST(6)=StatCatDR
    .s PLIST(8)=UnitDR
    .s PLIST(9)="N"
    .s PLIST(11)=OldCatDR
    .;s PLIST(2)=Desc
    .;s PLIST(2)=Desc
    .;b  //3
    .&SQL(Insert Into SQLUSER.DHC_EQCMasterItem Values :PLIST())
    .q:(SQLCODE'=0)
    .;q:Count>200
    .s NewRowID=$G(%ROWID)
    .s ModelDR=0
    .;s Num=0
    .;b  //4
    .f  s ModelDR=$o(^DHCEQCCode("DHCEQCModel",0,"MItemDR",rowid,ModelDR)) q:(ModelDR="")||(SQLCODE'=0)  d
    ..q:(ModelDR="")
    ..s ModelCode=$p($g(^DHCEQCCode("DHCEQCModel",ModelDR)),"^",1)
    ..s ModelDesc=$p($g(^DHCEQCCode("DHCEQCModel",ModelDR)),"^",2)
    ..s PMODELIST(2)=ModelCode
    ..s PMODELIST(3)=ModelDesc
    ..s PMODELIST(5)=NewRowID
    ..s PMODELIST(6)="N"
    ..;s Num=Num+1
    ..;b  //5
    ..&SQL(Insert Into SQLUSER.DHC_EQCModel Values :PMODELIST())
    ..q:(SQLCODE'=0)
    ..;q:(Num>30)

    b  //1
    q Count
}

/***************************************************/
/// 处理弋矶山老数据下账的问题
/// 下账2014年导入的设备数据
/// w ##Class(web.DHCEQYJSRunQian).AdjustDataA()
ClassMethod AdjustDataA()
{
    s Count=0
    n InputFlag
    K PLIST
    s EquipID=0
    s SQLCODE=0
    f  s EquipID=$o(^DHCEQEquip(EquipID)) q:(EquipID="")||(SQLCODE'=0)  d
    .s InputFlag=$p($g(^DHCEQEquip(EquipID)),"^",47)  //导入标志
    .q:(InputFlag'="Y")
    .s EquipTypeDR=$p($g(^DHCEQEquip(EquipID)),"^",63)
    .q:(EquipTypeDR'=2)
    .s Count=Count+1
    .s PLIST(2)="8"  //调账单id
    .s PLIST(3)=EquipID  //设备ID
    .s PLIST(4)=$p($g(^DHCEQEquip(EquipID)),"^",67)   //ADL_FromLocDR
    .s PLIST(5)=$p($g(^DHCEQEquip(EquipID)),"^",63)   //ADL_FromEquipTypeDR
    .s PLIST(6)=$p($g(^DHCEQEquip(EquipID)),"^",75)   //ADL_FromStatCatDR
    .s PLIST(7)=$p($g(^DHCEQEquip(EquipID)),"^",20)   //ADL_FromOriginDR
    .;s PLIST(14)="0"  //
    .s PLIST(14)=$p($g(^DHCEQEquip(EquipID)),"^",38)   //ADL_EQStatus
    .s PLIST(15)=$p($g(^DHCEQEquip(EquipID)),"^",27)   //ADL_OriginalFee
    .s PLIST(16)=$p($g(^DHCEQEquip(EquipID)),"^",35)   //ADL_DepreTotal
    .s PLIST(17)=$p($g(^DHCEQEquip(EquipID)),"^",28)   //ADL_NetFee
    .&SQL(insert into sqluser.DHC_EQAdjustDataList values :PLIST())
    .q:SQLCODE'=0
    
    
    
    q Count
}

/// 处理弋矶山项目新导入数据
/// 导入2015新整理的数据
/// w ##Class(web.DHCEQYJSRunQian).AdjustDataB()
ClassMethod AdjustDataB()
{
    s Count=0
    n InputFlag
    K PLIST
    s EquipID=0
    s SQLCODE=0
    f  s EquipID=$o(^DHCEQEquip(EquipID)) q:(EquipID="")||(SQLCODE'=0)  d
    .q:EquipID<39150
    .s InputFlag=$p($g(^DHCEQEquip(EquipID)),"^",47)  //导入标志
    .q:(InputFlag'="Y")
    .s EquipTypeDR=$p($g(^DHCEQEquip(EquipID)),"^",63)
    .q:(EquipTypeDR'=2)
    .s Count=Count+1
    .s PLIST(2)="10"  //调账单id
    .s PLIST(3)=EquipID  //设备ID
    .s PLIST(9)=$p($g(^DHCEQEquip(EquipID)),"^",67)   //ADL_FromLocDR
    .s PLIST(10)=$p($g(^DHCEQEquip(EquipID)),"^",63)   //ADL_FromEquipTypeDR
    .s PLIST(11)=$p($g(^DHCEQEquip(EquipID)),"^",75)   //ADL_FromStatCatDR
    .s PLIST(12)=$p($g(^DHCEQEquip(EquipID)),"^",20)   //ADL_FromOriginDR
    .;s PLIST(14)="0"  //
    .s PLIST(14)=$p($g(^DHCEQEquip(EquipID)),"^",38)   //ADL_EQStatus
    .s PLIST(15)=$p($g(^DHCEQEquip(EquipID)),"^",27)   //ADL_OriginalFee
    .s PLIST(16)=$p($g(^DHCEQEquip(EquipID)),"^",35)   //ADL_DepreTotal
    .s PLIST(17)=$p($g(^DHCEQEquip(EquipID)),"^",28)   //ADL_NetFee
    .&SQL(insert into sqluser.DHC_EQAdjustDataList values :PLIST())
    .q:SQLCODE'=0
    
    q Count
}

/// 处理专用设备低值数据
/// w ##Class(web.DHCEQYJSRunQian).DeleteYGBdata()
ClassMethod DeleteYGBdata()
{
    s Num=0
    s GNum=0
    s SumFee=0
    s SumGFee=0
    k PLIST
    s SQLCODE=0
    n EquipTypeDR,InvalidFlag,StockStatus,OriginalFee,EquiCatDR,EquipCatCode,FirstCode
    s EquipID=0
    f  s EquipID=$o(^DHCEQEquip(EquipID)) q:(EquipID="")||(SQLCODE'=0)  d
    .s EquipTypeDR=$p($g(^DHCEQEquip(EquipID)),"^",63)  //设备类组
    .q:(EquipTypeDR'=2)
    .s InvalidFlag=$p($g(^DHCEQEquip(EquipID)),"^",59)  //无效标志
    .q:(InvalidFlag="Y")
    .s StockStatus=$p($g(^DHCEQEquip(EquipID)),"^",60)  //库存状态
    .q:(StockStatus'=1)
    .s OriginalFee=$p($g(^DHCEQEquip(EquipID)),"^",27)
    .s PLIST(2)="11"  //调账单id
    .s PLIST(3)=EquipID  //设备ID
    .s PLIST(4)=$p($g(^DHCEQEquip(EquipID)),"^",67)   //ADL_FromLocDR
    .s PLIST(5)=$p($g(^DHCEQEquip(EquipID)),"^",63)   //ADL_FromEquipTypeDR
    .s PLIST(6)=$p($g(^DHCEQEquip(EquipID)),"^",75)   //ADL_FromStatCatDR
    .s PLIST(7)=$p($g(^DHCEQEquip(EquipID)),"^",20)   //ADL_FromOriginDR
    .;s PLIST(14)="0"  //
    .s PLIST(14)=$p($g(^DHCEQEquip(EquipID)),"^",38)   //ADL_EQStatus
    .s PLIST(15)=$p($g(^DHCEQEquip(EquipID)),"^",27)   //ADL_OriginalFee
    .s PLIST(16)=$p($g(^DHCEQEquip(EquipID)),"^",35)   //ADL_DepreTotal
    .s PLIST(17)=$p($g(^DHCEQEquip(EquipID)),"^",28)   //ADL_NetFee
    .s EquiCatDR=$p($g(^DHCEQEquip(EquipID)),"^",4)  //国标分类
    .q:(EquiCatDR="")
    .s EquipCatCode=$p($g(^DHCEQCCode("DHCEQCEquipeCat",EquiCatDR)),"^",1)  //国标编码
    .s FirstCode=$e(EquipCatCode,1)
    .i FirstCode=3 d
    ..q:OriginalFee>1500
    ..&SQL(insert into sqluser.DHC_EQAdjustDataList values :PLIST())
    ..q:(SQLCODE'=0)
    .e  d
    ..q:(OriginalFee>1000)
    ..&SQL(insert into sqluser.DHC_EQAdjustDataList values :PLIST())
    ..q:(SQLCODE'=0)
    
    q Num_"^"_SumFee_"%"_GNum_"^"_SumGFee
}

/// 处理报废的设备
/// w ##Class(web.DHCEQYJSRunQian).DisuseData()
ClassMethod DisuseData()
{
    s Num=0
    s GNum=0
    s SumFee=0
    s SumGFee=0
    s SQLCODE=0
    k ^GBX
    n EquipTypeDR,InputFlag,Remark,OriginalFee,UseLocDR
    new EquipRowIDs,Len,OriginalFee,Result
    s EquipID=0
    f  s EquipID=$o(^DHCEQEquip(EquipID)) q:(EquipID="")||(SQLCODE'=0)  d
    .s EquipTypeDR=$p($g(^DHCEQEquip(EquipID)),"^",63)  //设备类组
    .q:(EquipTypeDR'=2)
    .s InvalidFlag=$p($g(^DHCEQEquip(EquipID)),"^",59)  //无效标志
    .q:(InvalidFlag="Y")
    .s InputFlag=$p($g(^DHCEQEquip(EquipID)),"^",47)  //无效标志
    .q:(InputFlag'="Y")
    .s Remark=$p($g(^DHCEQEquip(EquipID)),"^",34)
    .q:(Remark="")
    .q:(Remark'["报废")
    .s UseLocDR=$p($g(^DHCEQEquip(EquipID)),"^",19)
    .q:(UseLocDR="")
    .s Num=Num+1
    .if $g(^GBX("Disuse",0,+$j,+$h,EquipTypeDR,UseLocDR))'="" d
    ..s ^GBX("Disuse",0,+$j,+$h,EquipTypeDR,UseLocDR)=^GBX("Disuse",0,+$j,+$h,EquipTypeDR,UseLocDR)_"^"_EquipID
    .e  d
    ..s ^GBX("Disuse",0,+$j,+$h,EquipTypeDR,UseLocDR)=EquipID
    
    /*
    "^^"+"1"+"^"+EquipID+"^"+"1"+"^^^^^"+OriginalFee+"^^^^^";
    */

    s Date="18/09/2015"
    s i=0
    s EquipTypeID=0
    s LocdID=0
    f  s EquipTypeID=$o(^GBX("Disuse",0,+$j,+$h,EquipTypeID)) q:(EquipTypeID="")||(SQLCODE'=0)  d
    .f  s LocdID=$o(^GBX("Disuse",0,+$j,+$h,EquipTypeID,LocdID)) q:(LocdID="")||(SQLCODE'=0)  d
    ..s EquipRowIDs=$g(^GBX("Disuse",0,+$j,+$h,EquipTypeID,LocdID))
    ..s Len=$L(EquipRowIDs,"^")
    ..s ListVal=""
    ..s ReqVal=""
    ..f i=1:1:Len  d
    ...s EquipRowID=$p(EquipRowIDs,"^",i)
    ...s SOriginalFee=$p($g(^DHCEQEquip(EquipRowID)),"^",27)
    ...i ListVal'="" d
    ....s ListVal=ListVal_"&"_"^^"_"0"_"^"_EquipRowID_"^"_"1"_"^^^^^"_SOriginalFee_"^^^^^"
    ...e  d
    ....s ListVal="^^"_"0"_"^"_EquipRowID_"^"_"1"_"^^^^^"_SOriginalFee_"^^^^^"
    ..s ReqVal="^^^"_"594"_"^"_Date_"^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^"_LocdID_"^^^^^^^^^"_"2"_"^^^^"_EquipTypeID
    ..s SResult=##class(web.DHCEQBatchDisuseRequest).SaveDisuseRequest(ReqVal, ListVal,"","0")
    ..s SQLCODE=$p(SResult,"^",1)
    ..q:(SQLCODE'=0)

    q Num
}

/***************************************************/

/***********************************************************************************/
/// Add BY  GBX 2015-11-20
/// 弋矶山配件库存表
ClassMethod AccessoryKCClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = AccessoryKCExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)

    Quit $$$OK
}

ClassMethod AccessoryKCExecute(ByRef qHandle As %Binary, MonthStr As %String = "", QXType As %String = "", EquipType As %String = "", EquipTypeDR As %String = "", StartDate As %String = "", EndDate As %String = "", CurGroupID As %String = "", CurLocID As %String = "") As %Status
{
    new repid, index,rowid
    Set repid=$I(^CacheTemp)
    Set qHandle=$lb(0,repid,0)
    s index=1

    i ((StartDate="")&&(EndDate="")) Quit $$$OK
    
    i StartDate=""  d
    .s vBeginDate=0
    e  d
    .;s vBeginDate=$ZDH(StartDate,3)
    .;日期格式统一调整    Modify by CSY 2017-03-02
    .s vBeginDate=##Class(web.DHCEQCommon).TransValueFromPage(StartDate,"date")
    i EndDate=""  d
    .s vEndDate=+$H
    e  d
    .;s vEndDate=$ZDH(EndDate,3)
    .;日期格式统一调整    Modify by CSY 2017-03-02
    .s vEndDate=##Class(web.DHCEQCommon).TransValueFromPage(EndDate,"date")
    
    
    s AInStockID=0
    f  s AInStockID=$o(^DHCEQAInStock(AInStockID)) q:(AInStockID="")  d 
    .d ResetVariablesGetAccessoryKC
    .s AccessoryTypeDR=$p($g(^DHCEQAInStock(AInStockID)),"^",2)
    .q:(##Class(web.DHCEQACommon).AccessoryTypeIsIn(AccessoryTypeDR,CurGroupID))
    .s Status=$p($g(^DHCEQAInStock(AInStockID)),"^",16)
    .
    .q:Status'=2
    .s AuditDate=$p($g(^DHCEQAInStock(AInStockID)),"^",24)
    .q:(vBeginDate>AuditDate)
    .q:(vEndDate<AuditDate)
    .s AInStockListID=0
    .f  s AInStockListID=$o(^DHCEQAInStockList(0,"AInStock",AInStockID,AInStockListID)) q:(AInStockListID="")  d 
    ..s AccessoryName=$p($g(^DHCEQAInStockList(AInStockListID)),"^",4)
    ..s AccessoryCode=$p($g(^DHCEQAInStockList(AInStockListID)),"^",3)
    ..s UnitDR=$p($g(^DHCEQAInStockList(AInStockListID)),"^",6)
    ..i UnitDR'="" d
    ...s Unit=##Class(web.DHCEQCommon).GetTrakNameByID("uom",UnitDR)
    ..s RKQuantity=$p($g(^DHCEQAInStockList(AInStockListID)),"^",9)
    ..s RKAmount=$p($g(^DHCEQAInStockList(AInStockListID)),"^",10)
    ..d OutputRowGetAccessoryKC 
    
    
    s MoveStockID=0
    f  s MoveStockID=$o(^DHCEQAMoveStock(MoveStockID)) q:(MoveStockID="")  d 
    .d ResetVariablesGetAccessoryKC
    .s AccessoryTypeDR=$p($g(^DHCEQAMoveStock(MoveStockID)),"^",2)
    .q:(##Class(web.DHCEQACommon).AccessoryTypeIsIn(AccessoryTypeDR,CurGroupID))
    .s Status=$p($g(^DHCEQAMoveStock(MoveStockID)),"^",28)
    .q:Status'=2
    .s AuditDate=$p($g(^DHCEQAMoveStock(MoveStockID)),"^",17)
    .q:(vBeginDate>AuditDate)
    .q:(vEndDate<AuditDate)
    .s MoveType=$p($g(^DHCEQAMoveStock(MoveStockID)),"^",14)
    .q:(MoveType'=0)
    .s MoveStockListID=0
    .f  s MoveStockListID=$o(^DHCEQAMoveStockList(0,"MoveStock",MoveStockID,MoveStockListID)) q:(MoveStockListID="")  d 
    ..s AccessoryName=$p($g(^DHCEQAMoveStockList(MoveStockListID)),"^",4)
    ..s AccessoryCode=$p($g(^DHCEQAMoveStockList(MoveStockListID)),"^",3)
    ..s UnitDR=$p($g(^DHCEQAMoveStockList(MoveStockListID)),"^",6)
    ..i UnitDR'="" d
    ...s Unit=##Class(web.DHCEQCommon).GetTrakNameByID("uom",UnitDR)
    ..s CKQuantity=$p($g(^DHCEQAMoveStockList(MoveStockListID)),"^",11)
    ..s CKAmount=$p($g(^DHCEQAMoveStockList(MoveStockListID)),"^",12)
    ..d OutputRowGetAccessoryKC
    
    
    s AReudceID=0
    f  s AReudceID=$o(^DHCEQAReduce(AReudceID)) q:(AReudceID="")  d 
    .d ResetVariablesGetAccessoryKC
    .s AccessoryTypeDR=$p($g(^DHCEQAReduce(AReudceID)),"^",2)
    .q:(##Class(web.DHCEQACommon).AccessoryTypeIsIn(AccessoryTypeDR,CurGroupID))
    .s Status=$p($g(^DHCEQAReduce(AReudceID)),"^",23)
    .q:Status'=2
    .s AuditDate=$p($g(^DHCEQAReduce(AReudceID)),"^",16)
    .q:(vBeginDate>AuditDate)
    .q:(vEndDate<AuditDate)
    .s AReudceListID=0
    .f  s AReudceListID=$o(^DHCEQAReduceList(0,"Reduce",AReudceID,AReudceListID)) q:(AReudceListID="")  d 
    ..s AccessoryItemDR=$p($g(^DHCEQAReduceList(AReudceListID)),"^",2)
    ..s AccessoryName=$p($g(^DHCEQCCode("DHCEQCAccessory",AccessoryItemDR)),"^",2)  
    ..s AccessoryCode=$p($g(^DHCEQCCode("DHCEQCAccessory",AccessoryItemDR)),"^",1) 
    ..s UnitDR=$p($g(^DHCEQCCode("DHCEQCAccessory",AccessoryItemDR)),"^",5) 
    ..i UnitDR'="" d
    ...s Unit=##Class(web.DHCEQCommon).GetTrakNameByID("uom",UnitDR)
    ..s THQuantity=$p($g(^DHCEQAReduceList(AReudceListID)),"^",10)
    ..s THAmount=$p($g(^DHCEQAReduceList(AReudceListID)),"^",11)
    ..d OutputRowGetAccessoryKC

    s AStockDetailID=0
    f  s AStockDetailID=$o(^DHCEQAStockDetail(AStockDetailID)) q:(AStockDetailID="")  d 
    .d ResetVariablesGetAccessoryKC
    .s AccessoryTypeDR=$p($g(^DHCEQAStockDetail(AStockDetailID)),"^",11)
    .q:(##Class(web.DHCEQACommon).AccessoryTypeIsIn(AccessoryTypeDR,CurGroupID))
    .s Status=$p($g(^DHCEQAStockDetail(AStockDetailID)),"^",12)
    .q:Status'=0
    .s AccessoryName=$p($g(^DHCEQAStockDetail(AStockDetailID)),"^",5)
    .s AccessoryCode=$p($g(^DHCEQAStockDetail(AStockDetailID)),"^",4)
    .s UnitDR=$p($g(^DHCEQAStockDetail(AStockDetailID)),"^",13)
    .i UnitDR'="" d
    ..s Unit=##Class(web.DHCEQCommon).GetTrakNameByID("uom",UnitDR)
    .s KCQuantity=$p($g(^DHCEQAStockDetail(AStockDetailID)),"^",17)
    .s KCPrice=$p($g(^DHCEQAStockDetail(AStockDetailID)),"^",8)
    .s KCAmount=KCPrice*KCQuantity
    .d OutputRowGetAccessoryKC

    
    Quit $$$OK
OutputRowGetAccessoryKC
    s Data=$lb(AccessoryTypeDR,AccessoryCode,AccessoryName,Unit,RKQuantity,RKAmount,CKQuantity,CKAmount,THQuantity,THAmount,KCQuantity,KCAmount)
    Set ^CacheTemp(repid,index)=Data
    Set index=index+1
    quit
ResetVariablesGetAccessoryKC
    s (AccessoryTypeDR,Status,AccessoryName,KCPrice,AccessoryCode,UnitDR,RKQuantity,RKAmount,CKQuantity,CKAmount,KCQuantity,Price,KCAmount,Unit,THQuantity,THAmount,AccessoryItemDR)=""
    quit
}

ClassMethod AccessoryKCFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = AccessoryKCExecute ]
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

/// d ##class(%ResultSet).RunQuery("web.DHCEQYJSRunQian","AccessoryKC","")
Query AccessoryKC(MonthStr As %String = "", QXType As %String = "", EquipType As %String = "", EquipTypeDR As %String = "", StartDate As %String = "", EndDate As %String = "", CurGroupID As %String = "", CurLocID As %String = "") As %Query(ROWSPEC = "AccessoryTypeDR:%String,AccessoryCode:%String,AccessoryName:%String,Unit:%String,RKQuantity:%String,RKAmount:%String,CKQuantity:%String,CKAmount:%String,THQuantity:%String,THAmount:%String,KCQuantity:%String,KCAmount:%String") [ SqlProc ]
{
}

/********************************************************************************************/

/*******************************************************************************************/
/// add by GBX 2015-12-24
/// d ##class(%ResultSet).RunQuery("web.DHCEQYJSRunQian","GetAStockMoveDetail","","","","","2013-11-01","","","")
/// 配件出库明细单
Query GetAStockMoveDetail(MonthStr As %String = "", QXType As %String = "", EquipType As %String = "", EquipTypeDR As %String = "", StartDate As %String = "", EndDate As %String = "", CurGroupID As %String = "", CurLocID As %String = "") As %Query(ROWSPEC = "TRowID:%String,TNo:%String,TTLoc:%String,TTLocCode:%String,TAccessoryType:%String,TDate:%String,TAccessoryName:%String,TAccessoryModel:%String,TPrice:%String,TQuantity:%String,TAmount:%String") [ SqlProc ]
{
}

ClassMethod GetAStockMoveDetailExecute(ByRef qHandle As %Binary, MonthStr As %String = "", QXType As %String = "", EquipType As %String = "", EquipTypeDR As %String = "", StartDate As %String = "", EndDate As %String = "", CurGroupID As %String = "", CurLocID As %String = "") As %Status
{
    
    new repid, index,rowid
    Set repid=$I(^CacheTemp)
    Set qHandle=$lb(0,repid,0)
    s index=1

    i ((StartDate="")&&(EndDate="")) Quit $$$OK
    
    i StartDate=""  d
    .s vBeginDate=0
    e  d
    .;s vBeginDate=$ZDH(StartDate,3)-1
    .;日期格式统一调整    Modify by CSY 2017-03-02
    .s vBeginDate=##Class(web.DHCEQCommon).TransValueFromPage(StartDate,"date")-1
    i EndDate=""  d
    .s vEndDate=+$H
    e  d
    .;s vEndDate=$ZDH(EndDate,3)
    .;日期格式统一调整    Modify by CSY 2017-03-02
    .s vEndDate=##Class(web.DHCEQCommon).TransValueFromPage(EndDate,"date")

    Set MoveStockID=0
    For  Set MoveStockID=$Order(^DHCEQAMoveStock(MoveStockID)) Quit:MoveStockID=""  Do
    .Do ResetVariablesGetAStockMoveDetail
    .s TStatus=$p($g(^DHCEQAMoveStock(MoveStockID)),"^",28)
    .q:(TStatus'=2)
    .s TMoveType=$p($g(^DHCEQAMoveStock(MoveStockID)),"^",14)
    .q:TMoveType'=0
    .s TAuditDate=$p($g(^DHCEQAMoveStock(MoveStockID)),"^",17)
    .q:((TAuditDate>vEndDate)||(TAuditDate<vBeginDate))
    .;s TDate=$ZD(TAuditDate,3)
    .;日期格式统一调整    Modify by CSY 2017-03-02
    .s TDate=##Class(web.DHCEQCommon).TransValueToPage(TAuditDate,"date")
    .s TAccessoryTypeDR=$p($g(^DHCEQAMoveStock(MoveStockID)),"^",2)
    .q:(##Class(web.DHCEQACommon).AccessoryTypeIsIn(TAccessoryTypeDR,CurGroupID))
    .s TAccessoryType=$p($g(^DHCEQCCode("DHCEQCAccessoryType",TAccessoryTypeDR)),"^",2)
    .s TNo=$p($g(^DHCEQAMoveStock(MoveStockID)),"^",1)
    .s TToLocDR=$p($g(^DHCEQAMoveStock(MoveStockID)),"^",5)
    .i TToLocDR'=""  d
    ..s TTLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept",TToLocDR)
    ..s TTLocCode=##Class(web.DHCEQCommon).GetTrakNameByID("deptcode",TToLocDR)
    .s MoveStockListID=0
    .f  s MoveStockListID=$Order(^DHCEQAMoveStockList(0,"MoveStock",MoveStockID,MoveStockListID)) q:MoveStockListID=""  d
    ..s TRowID=MoveStockListID
    ..s TAccessoryName=$p($g(^DHCEQAMoveStockList(MoveStockListID)),"^",4)
    ..s TAccessoryModel=$p($g(^DHCEQAMoveStockList(MoveStockListID)),"^",5)
    ..s TPrice=$p($g(^DHCEQAMoveStockList(MoveStockListID)),"^",10)
    ..s TQuantity=$p($g(^DHCEQAMoveStockList(MoveStockListID)),"^",11)
    ..s TAmount=$p($g(^DHCEQAMoveStockList(MoveStockListID)),"^",12)
    ..d OutputRowGetAStockMoveDetail
        
    Quit $$$OK
OutputRowGetAStockMoveDetail
    Set Data=$lb(TRowID,TNo,TTLoc,TTLocCode,TAccessoryType,TDate,TAccessoryName,TAccessoryModel,TPrice,TQuantity,TAmount)
    Set ^CacheTemp(repid,index)=Data
    Set index=index+1
    
    Quit
ResetVariablesGetAStockMoveDetail
    Set (TRowID,TNo,TTLoc,TTLocCode,TAccessoryType,TDate,TAccessoryName,TAccessoryModel,TPrice,TQuantity,TAmount)=""
    Quit
}

ClassMethod GetAStockMoveDetailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAStockMoveDetailExecute ]
{
    Set AtEnd=$LIST(qHandle,1)
    Set repid=$LIST(qHandle,2)
    Set ind=$LIST(qHandle,3)
    Set ind=$o(^CacheTemp(repid,ind))
    If ind=""
    {
        Set AtEnd=1
        Set Row=""
    }
    Else
    {
        Set Row=^CacheTemp(repid,ind)
    }
    Set qHandle=$lb(AtEnd,repid,ind)
    Quit $$$OK
}

ClassMethod GetAStockMoveDetailClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAStockMoveDetailExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// add by GBX 2015-12-24
/// d ##class(%ResultSet).RunQuery("web.DHCEQYJSRunQian","GetAInStockDetail","","","","","2013-11-01","","","")
/// 配件入库明细单
Query GetAInStockDetail(MonthStr As %String = "", QXType As %String = "", EquipType As %String = "", EquipTypeDR As %String = "", StartDate As %String = "", EndDate As %String = "", CurGroupID As %String = "", CurLocID As %String = "") As %Query(ROWSPEC = "TRowID:%String,TNo:%String,TProvider:%String,TAccessoryType:%String,TAccessoryName:%String,TAccessoryModel:%String,TPrice:%String,TQuantity:%String,TAmount:%String,TInvoiceNos:%String") [ SqlProc ]
{
}

ClassMethod GetAInStockDetailExecute(ByRef qHandle As %Binary, MonthStr As %String = "", QXType As %String = "", EquipType As %String = "", EquipTypeDR As %String = "", StartDate As %String = "", EndDate As %String = "", CurGroupID As %String = "", CurLocID As %String = "") As %Status
{
    
    new repid, index,rowid
    Set repid=$I(^CacheTemp)
    Set qHandle=$lb(0,repid,0)
    s index=1
    
    i ((StartDate="")&&(EndDate="")) Quit $$$OK
    
    i StartDate=""  d
    .s vBeginDate=0
    e  d
    .;s vBeginDate=$ZDH(StartDate,3)
    .;日期格式统一调整    Modify by CSY 2017-03-02
    .s vBeginDate=##Class(web.DHCEQCommon).TransValueFromPage(StartDate,"date")
    i EndDate=""  d
    .s vEndDate=+$H
    e  d
    .;s vEndDate=$ZDH(EndDate,3)
    .;日期格式统一调整    Modify by CSY 2017-03-02
    .s vEndDate=##Class(web.DHCEQCommon).TransValueFromPage(EndDate,"date")
    
    Set AInStockID=0
    For  Set AInStockID=$Order(^DHCEQAInStock(AInStockID)) Quit:AInStockID=""  Do
    .Do ResetVariablesGetAInStockDetail
    .s TStatus=$p($g(^DHCEQAInStock(AInStockID)),"^",16)
    .q:(TStatus'=2)
    .s TAuditDate=$p($g(^DHCEQAInStock(AInStockID)),"^",24)
    .q:((TAuditDate>vEndDate)||(TAuditDate<vBeginDate))
    .;s TDate=$ZD(TAuditDate,3)
    .;日期格式统一调整    Modify by CSY 2017-03-02
    .s TDate=##Class(web.DHCEQCommon).TransValueToPage(TAuditDate,"date")
    .s TAccessoryTypeDR=$p($g(^DHCEQAInStock(AInStockID)),"^",2)
    .q:(##Class(web.DHCEQACommon).AccessoryTypeIsIn(TAccessoryTypeDR,CurGroupID))
    .s TAccessoryType=$p($g(^DHCEQCCode("DHCEQCAccessoryType",TAccessoryTypeDR)),"^",2)
    .s TNo=$p($g(^DHCEQAInStock(AInStockID)),"^",6)
    .s TProviderDR=$p($g(^DHCEQAInStock(AInStockID)),"^",8)
    .i TProviderDR'=""  s TProvider=##Class(web.DHCEQCommon).GetTrakNameByID("prov",TProviderDR)
    .s AInStockListID=0
    .f  s AInStockListID=$Order(^DHCEQAInStockList(0,"AInStock",AInStockID,AInStockListID)) q:AInStockListID=""  d
    ..s TRowID=AInStockListID
    ..s TAccessoryName=$p($g(^DHCEQAInStockList(AInStockListID)),"^",4)
    ..s TAccessoryModel=$p($g(^DHCEQAInStockList(AInStockListID)),"^",5)
    ..s TPrice=$p($g(^DHCEQAInStockList(AInStockListID)),"^",8)
    ..s TQuantity=$p($g(^DHCEQAInStockList(AInStockListID)),"^",9)
    ..s TAmount=$p($g(^DHCEQAInStockList(AInStockListID)),"^",10)
    ..s TInvoiceNos=$p($g(^DHCEQAInStockList(AInStockListID)),"^",19)
    ..d OutputRowGetAInStockDetail
        
    Quit $$$OK
OutputRowGetAInStockDetail
    Set Data=$lb(TRowID,TNo,TProvider,TAccessoryType,TAccessoryName,TAccessoryModel,TPrice,TQuantity,TAmount,TInvoiceNos)
    Set ^CacheTemp(repid,index)=Data
    Set index=index+1
    
    Quit
ResetVariablesGetAInStockDetail
    Set (TRowID,TNo,TProvider,TAccessoryType,TAccessoryName,TAccessoryModel,TPrice,TQuantity,TAmount,TInvoiceNos,TAuditDate)=""
    Quit
}

ClassMethod GetAInStockDetailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAInStockDetailExecute ]
{
    Set AtEnd=$LIST(qHandle,1)
    Set repid=$LIST(qHandle,2)
    Set ind=$LIST(qHandle,3)
    Set ind=$o(^CacheTemp(repid,ind))
    If ind=""
    {
        Set AtEnd=1
        Set Row=""
    }
    Else
    {
        Set Row=^CacheTemp(repid,ind)
    }
    Set qHandle=$lb(AtEnd,repid,ind)
    Quit $$$OK
}

ClassMethod GetAInStockDetailClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAInStockDetailExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

/**************************************************************************************************/
/// ADD By DJ 2014-04-19
/// 入库明细
ClassMethod InStockDetailGZClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = InStockDetailGZExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)

    Quit $$$OK
}

ClassMethod InStockDetailGZExecute(ByRef qHandle As %Binary, vStartDate As %String = "", vEndDate As %String = "", QXType As %String = "", EquipType As %String = "", EquipTypeDR As %String = "", CurGroupID As %String = "", CurLocID As %String = "") As %Status
{
    new repid, index,rowid
    Set repid=$I(^CacheTemp)
    Set qHandle=$lb(0,repid,0)
    s index=1
    
    i ((vStartDate="")&&(vEndDate="")) Quit $$$OK
    
    i EquipType="" s EquipTypeDR=""
    i vStartDate=""  d
    .s BeginDate=0
    e  d
    .;s BeginDate=$ZDH(vStartDate,3)-1
    .;日期格式统一调整    Modify by CSY 2017-03-02
    .s BeginDate=##Class(web.DHCEQCommon).TransValueFromPage(vStartDate,"date")-1
    i vEndDate=""  d
    .s EndDate=+$H
    e  d
    .;s EndDate=$ZDH(vEndDate,3)
    .;日期格式统一调整    Modify by CSY 2017-03-02
    .s EndDate=##Class(web.DHCEQCommon).TransValueFromPage(vEndDate,"date")
    k ^GBX
    s StockDate=BeginDate
    f  s StockDate=$o(^DHCEQInStock(0,"BillDate",StockDate)) q:((StockDate="")||(StockDate>EndDate))  d
    .s StatCatDR=""
    .f  s StatCatDR=$o(^DHCEQInStock(0,"BillDate",StockDate,StatCatDR)) q:StatCatDR=""  d
    ..s ISRowID=0       //入库单rowID
    ..f  s ISRowID=$o(^DHCEQInStock(0,"BillDate",StockDate,StatCatDR,ISRowID)) q:ISRowID=""  d
    ...d ResetVariablesGetInStockDetailGZ
    ...s InStockNo=$p($g(^DHCEQInStock(ISRowID)),"^",14)
    ...q:InStockNo=""
    ...s vendorid=$p($g(^DHCEQInStock(ISRowID)),"^",17)
    ...q:vendorid=""
    ...s ISStatus=$p($g(^DHCEQInStock(ISRowID)),"^",10)
    ...q:ISStatus'=2
    ...s TEquipTypeDR=$p($g(^DHCEQInStock(ISRowID)),"^",20)
    ...q:(##Class(web.DHCEQCommon).EquipTypeIsIn(TEquipTypeDR,CurGroupID))
    ...s TInStockNo=$p($g(^DHCEQInStock(ISRowID)),"^",14)
    ...s TInDate=$p($g(^DHCEQInStock(ISRowID)),"^",1)
    ...;i TInDate'="" s TInDate=$ZD(TInDate,3)
    ...;日期格式统一调整    Modify by CSY 2017-03-02
    ...s TInDate=##Class(web.DHCEQCommon).TransValueToPage(TInDate,"date")
    ...s TActDate=$p($g(^DHCEQInStock(ISRowID)),"^",13)
    ...;i TActDate'="" s TActDate=$ZD(TActDate,3)
    ...;日期格式统一调整    Modify by CSY 2017-03-02
    ...s TActDate=##Class(web.DHCEQCommon).TransValueToPage(TActDate,"date")
    ...s TStorLocDR=$p($g(^DHCEQInStock(ISRowID)),"^",2)
    ...;i TStorLocDR'="" s TStorLoc=##Class(web.DHCEQCommon).GetSplitDataByFlag($p($g(^CTLOC(TStorLocDR)),"^",2),"-")   //modify by jyp 2019-10-18 CTLOC调整
    ...i TStorLocDR'="" s TStorLoc=##class(web.DHCEQCommon).GetTrakNameByID("dept",TStorLocDR)   //modify by jyp 2019-10-18 CTLOC调整
    ...s TRemark=$p($g(^DHCEQInStock(ISRowID)),"^",11)
    ...s TProvider=##class(web.DHCEQCommon).GetTrakNameByID("prov",vendorid)    //供应商
    ...i TEquipTypeDR'="" s TEquipType=$p($g(^DHCEQCCode("DHCEQCEquipType",TEquipTypeDR)),"^",2)
    ...s ISLRowID=0
    ...f  s ISLRowID=$o(^DHCEQInStockList(0,"InStock",ISRowID,ISLRowID))  q:ISLRowID=""  d
    ....s TRowID=ISLRowID
    ....s TInvoice=##Class(web.DHCEQInvoice).GetInvoiceInfos(1,ISLRowID)
    ....s TInvoiceNo=$p(TInvoice,"^",1)
    ....s TEquipName=$p($g(^DHCEQInStockList(ISLRowID)),"^",5)
    ....s TModelDR=$p($g(^DHCEQInStockList(ISLRowID)),"^",9)
    ....i TModelDR'="" s TModel=$p($g(^DHCEQCCode("DHCEQCModel",TModelDR)),"^",2)
    ....s TUnitDR=$p($g(^DHCEQInStockList(ISLRowID)),"^",10)
    ....i TUnitDR'="" s TUnit=##Class(web.DHCEQCommon).GetTrakNameByID("uom",TUnitDR)
    ....s TStatCatDR=$p($g(^DHCEQInStockList(ISLRowID)),"^",17)
    ....i TStatCatDR'="" s TStatCat=$p($g(^DHCEQCCode("DHCEQCStatCat",TStatCatDR)),"^",2)
    ....s TEquipCatDR=$p($g(^DHCEQInStockList(ISLRowID)),"^",14)
    ....i TEquipCatDR'=""  d
    .....s TEquipCat=$p($g(^DHCEQCCode("DHCEQCEquipeCat",TEquipCatDR)),"^",2)
    .....s TEquipCatCode=$p($g(^DHCEQCCode("DHCEQCEquipeCat",TEquipCatDR)),"^",1)
    ....;s ItemDR=$p($g(^DHCEQInStockList(ISLRowID)),"^",16)
    ....;s TEquipCatDR=$p($g(^DHCEQCCode("DHCEQCMasterItem",ItemDR)),"^",10)
    ....;i TEquipCatDR'=""  d
    ....;.s TEquipCatCode=$p($g(^DHCEQCCode("DHCEQCTree",TEquipCatDR)),"^",2)
    ....;.s TEquipCat=$p($g(^DHCEQCCode("DHCEQCTree",TEquipCatDR)),"^",3)
    ....;.s TEquipCat=..GetOldECCode(TEquipCatCode)
    ....s TQuantity=$p($g(^DHCEQInStockList(ISLRowID)),"^",8)
    ....s TOriginalFee=$fn($p($g(^DHCEQInStockList(ISLRowID)),"^",7),"",2)
    ....s TAmount=$fn(TQuantity*TOriginalFee,"",2)
    ....//modify by GBX 20160107   设备编号分开打印
    ....s StoreLocID=0
    ....f  s StoreLocID=$o(^DHCEQEquip(0,"InStockList",ISLRowID,StoreLocID))  q:StoreLocID=""  d
    .....s EquipID=0
    .....f  s EquipID=$o(^DHCEQEquip(0,"InStockList",ISLRowID,StoreLocID,EquipID))  q:EquipID=""  d
    ......s TEquipNos=$p($g(^DHCEQEquip(EquipID)),"^",71)
    ......s TNum=1
    ......//modify by GBX 20160107   设备编号分开打印
    ......;s TEquipNos=##Class(web.DHCEQCommon).GetEquipNos(ISLRowID,1)
    ......d OutputRowGetInStockDetailGZ
    
    ;红冲记录显示 //2014-05-19 DJ
    s StockDate=BeginDate
    f  s StockDate=$o(^DHCEQReturn(0,"AckDateStat",2,StockDate)) q:((StockDate="")||(StockDate>EndDate))  d
    .s StatCatDR=""
    .f  s StatCatDR=$o(^DHCEQReturn(0,"AckDateStat",2,StockDate,StatCatDR)) q:StatCatDR=""  d
    ..s RRowID=0
    ..f  s RRowID=$o(^DHCEQReturn(0,"AckDateStat",2,StockDate,StatCatDR,RRowID)) q:RRowID=""  d
    ...d ResetVariablesGetInStockDetailGZ
    ...s InvalidFlag=$p($g(^DHCEQReturn(RRowID)),"^",28)
    ...q:InvalidFlag="Y"
    ...s TEquipTypeDR=$p($g(^DHCEQReturn(RRowID)),"^",15)
    ...q:(##Class(web.DHCEQCommon).EquipTypeIsIn(TEquipTypeDR,CurGroupID))
    ...s TInStockNo=$p($g(^DHCEQReturn(RRowID)),"^",1)
    ...s TProvider=$p($g(^DHCEQReturn(RRowID)),"^",3)
    ...i TProvider'="" s TProvider=##class(web.DHCEQCommon).GetTrakNameByID("prov",TProvider)
    ...s TInDate=$p($g(^DHCEQReturn(RRowID)),"^",6)
    ...;i TInDate'="" s TInDate=$ZD(TInDate,3)
    ...;s TActDate=$ZD(StockDate,3)
    ...;日期格式统一调整    Modify by CSY 2017-03-02
    ...s TInDate=##Class(web.DHCEQCommon).TransValueToPage(TInDate,"date")
    ...s TActDate=##Class(web.DHCEQCommon).TransValueToPage(StockDate,"date")
    ...s RLRowID=0
    ...f  s RLRowID=$o(^DHCEQReturnList(0,"Return",RRowID,RLRowID))  q:RLRowID=""  d
    ....s TRowID=$p($g(^DHCEQReturnList(RLRowID)),"^",3)
    ....i TRowID=""  d
    .....s EQRowID=$p($g(^DHCEQReturnList(RLRowID)),"^",4)
    .....s TRowID=$p($g(^DHCEQEquip(EQRowID)),"^",70)
    .....s TEquipName=$p($g(^DHCEQEquip(EQRowID)),"^",1)
    .....s TModelDR=$p($g(^DHCEQEquip(EQRowID)),"^",3)
    .....i TModelDR'="" s TModel=$p($g(^DHCEQCCode("DHCEQCModel",TModelDR)),"^",2)
    .....s TUnitDR=$p($g(^DHCEQEquip(EQRowID)),"^",5)
    .....i TUnitDR'="" s TUnit=##Class(web.DHCEQCommon).GetTrakNameByID("uom",TUnitDR)
    .....s TEquipCatDR=$p($g(^DHCEQEquip(EQRowID)),"^",4)
    .....;s ItemDR=$p($g(^DHCEQEquip(EQRowID)),"^",7)
    .....;s TEquipCatDR=$p($g(^DHCEQCCode("DHCEQCMasterItem",ItemDR)),"^",10)
    ....e  d
    .....s TEquipName=$p($g(^DHCEQInStockList(TRowID)),"^",5)
    .....s TModelDR=$p($g(^DHCEQInStockList(TRowID)),"^",9)
    .....i TModelDR'="" s TModel=$p($g(^DHCEQCCode("DHCEQCModel",TModelDR)),"^",2)
    .....s TUnitDR=$p($g(^DHCEQInStockList(TRowID)),"^",10)
    .....i TUnitDR'="" s TUnit=##Class(web.DHCEQCommon).GetTrakNameByID("uom",TUnitDR)
    .....s TEquipCatDR=$p($g(^DHCEQInStockList(TRowID)),"^",14)
    .....;s ItemDR=$p($g(^DHCEQInStockList(TRowID)),"^",16)
    .....;s TEquipCatDR=$p($g(^DHCEQCCode("DHCEQCMasterItem",ItemDR)),"^",10)
    ....i TRowID="" s TRowID=0
    ....s TOriginalFee=$fn($p($g(^DHCEQReturnList(RLRowID)),"^",6),"",2)
    ....s TQuantity=0-$p($g(^DHCEQReturnList(RLRowID)),"^",5)
    ....s TAmount=$fn(TQuantity*TOriginalFee,"",2)
    ....s TRemark=$p($g(^DHCEQReturnList(RLRowID)),"^",9)
    ....i TEquipCatDR'=""  d
    .....s TEquipCat=$p($g(^DHCEQCCode("DHCEQCEquipeCat",TEquipCatDR)),"^",2)
    .....s TEquipCatCode=$p($g(^DHCEQCCode("DHCEQCEquipeCat",TEquipCatDR)),"^",1)
    .....;s TEquipCatCode=$p($g(^DHCEQCCode("DHCEQCTree",TEquipCatDR)),"^",2)
    .....;s TEquipCat=$p($g(^DHCEQCCode("DHCEQCTree",TEquipCatDR)),"^",3)
    .....;s TEquipCat=..GetOldECCode(TEquipCatCode)
    ....s EQRowIDs=$g(^DHCEQReturnList(RLRowID,"EX","RowIDs"))
    ....s Count=0
    ....s Count=$L(EQRowIDs,",")
    ....s CurRowID=""
    ....q:((Count=0)||(Count=""))
    ....f i=1:1:Count  d
    .....s CurRowID=$p(EQRowIDs,",",i)
    .....s TEquipNos=$p($g(^DHCEQEquip(CurRowID)),"^",71)
    .....s TNum=-1
    .....d OutputRowGetInStockDetailGZ
    .....;s TEquipNos=##Class(web.DHCEQCommon).GetEquipNos(EQRowIDs,0)
    .....;d OutputRowGetInStockDetailGZ
    
    Quit $$$OK
OutputRowGetInStockDetailGZ
    s Data=$lb(TRowID,TInStockNo,TProvider,TInDate,TActDate,TEquipName,TModel,TUnit,TOriginalFee,TQuantity,TAmount,TEquipCatCode,TEquipType,TRemark,TInvoiceNo,TStoreLoc,TStatCat,TEquipCat,TEquipNos,TNum)
    Set ^CacheTemp(repid,index)=Data
    Set index=index+1
    quit
ResetVariablesGetInStockDetailGZ
    s (TRowID,TInStockNo,TProvider,TInDate,TActDate,TEquipName,TModel,TUnit,TOriginalFee,TQuantity,TAmount,TEquipCatCode,TEquipType,TRemark,TInvoiceNo,TStoreLoc,TStatCat,TEquipCat,TEquipNos,TNum)=""
    quit
}

ClassMethod InStockDetailGZFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = InStockDetailGZExecute ]
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

Query InStockDetailGZ(vStartDate As %String = "", vEndDate As %String = "", QXType As %String = "", EquipType As %String = "", EquipTypeDR As %String = "", CurGroupID As %String = "", CurLocID As %String = "") As %Query(ROWSPEC = "TRowID:%String,TInStockNo:%String,TProvider:%String,TInDate:%String,TActDate:%String,TEquipName:%String,TModel:%String,TUnit:%String,TOriginalFee:%String,TQuantity:%String,TAmount:%String,TEquipCatCode:%String,TEquipType:%String,TRemark:%String,TInvoiceNo:%String,TStoreLoc:%String,TStatCat:%String,TEquipCat:%String,TEquipNos:%String,TNum:%String") [ SqlProc ]
{
}

/// ADD By DJ 2014-04-19
/// 转移明细
ClassMethod StoreMoveDetailGZClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = StoreMoveDetailGZExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)

    Quit $$$OK
}

ClassMethod StoreMoveDetailGZExecute(ByRef qHandle As %Binary, vStartDate As %String = "", vEndDate As %String = "", MoveType As %String = "", QXType As %String = "", EquipType As %String = "", EquipTypeDR As %String = "", CurGroupID As %String = "", CurLocID As %String = "", vEquipName As %String = "", vModel As %String = "", vUnit As %String = "", vOriginalFee As %String = "") As %Status
{
    new repid, index,rowid
    Set repid=$I(^CacheTemp)
    Set qHandle=$lb(0,repid,0)
    s index=1
    
    i ((vStartDate="")&&(vEndDate="")) Quit $$$OK
    
    i EquipType="" s EquipTypeDR=""
    i vStartDate=""  d
    .s BeginDate=0
    e  d
    .;s BeginDate=$ZDH(vStartDate,3)-1
    .;日期格式统一调整    Modify by CSY 2017-03-02
    .s BeginDate=##Class(web.DHCEQCommon).TransValueFromPage(vStartDate,"date")-1
    i vEndDate=""  d
    .s EndDate=+$H
    e  d
    .;s EndDate=$ZDH(vEndDate,3)
    .;日期格式统一调整    Modify by CSY 2017-03-02
    .s EndDate=##Class(web.DHCEQCommon).TransValueFromPage(vEndDate,"date")

    s StockDate=BeginDate
    f  s StockDate=$o(^DHCEQStoreMove(0,"InAckDateStat",2,StockDate)) q:((StockDate="")||(StockDate>EndDate))  d
    .s StatCatDR=""
    .f  s StatCatDR=$o(^DHCEQStoreMove(0,"InAckDateStat",2,StockDate,StatCatDR)) q:StatCatDR=""  d
    ..s MoveTypeDR=""
    ..f  s MoveTypeDR=$o(^DHCEQStoreMove(0,"InAckDateStat",2,StockDate,StatCatDR,MoveTypeDR))  q:MoveTypeDR=""  d
    ...q:(MoveType'="")&&(MoveType'=MoveTypeDR)
    ...s SMRowID=0
    ...f  s SMRowID=$o(^DHCEQStoreMove(0,"InAckDateStat",2,StockDate,StatCatDR,MoveTypeDR,SMRowID)) q:SMRowID=""  d
    ....d ResetVariablesGetMoveDetailGZ
    ....s TEquipTypeDR=$p($g(^DHCEQStoreMove(SMRowID)),"^",16)
    ....q:(##Class(web.DHCEQCommon).EquipTypeIsIn(TEquipTypeDR,CurGroupID))
    ....s TStoreMoveNo=$p($g(^DHCEQStoreMove(SMRowID)),"^",1)
    ....s TFromLocDR=$p($g(^DHCEQStoreMove(SMRowID)),"^",2)
    ....i TFromLocDR'="" s TFromLoc=##class(web.DHCEQCommon).GetTrakNameByID("dept",TFromLocDR)
    ....s TToLocDR=$p($g(^DHCEQStoreMove(SMRowID)),"^",3)
    ....i TToLocDR'="" s TToLoc=##class(web.DHCEQCommon).GetTrakNameByID("dept",TToLocDR)
    ....s TInDate=$p($g(^DHCEQStoreMove(SMRowID)),"^",5)
    ....;i TInDate'="" s TInDate=$ZD(TInDate,3)
    ....;日期格式统一调整    Modify by CSY 2017-03-02
    ....s TInDate=##Class(web.DHCEQCommon).TransValueToPage(TInDate,"date")
    ....s TActDate=$p($g(^DHCEQStoreMove(SMRowID)),"^",10)
    ....;i TActDate'="" s TActDate=$ZD(TActDate,3)
    ....;日期格式统一调整    Modify by CSY 2017-03-02
    ....s TActDate=##Class(web.DHCEQCommon).TransValueToPage(TActDate,"date")
    ....s TReciverDR=$p($g(^DHCEQStoreMove(SMRowID)),"^",15)
    ....i TReciverDR'="" s TReciver=##Class(web.DHCEQCommon).GetTrakNameByID("user",TReciverDR)
    ....i TEquipTypeDR'="" s TEquipType=$p($g(^DHCEQCCode("DHCEQCEquipType",TEquipTypeDR)),"^",2)
    ....s SMLRowID=0
    ....f  s SMLRowID=$o(^DHCEQStoreMoveList(0,"StoreMove",SMRowID,SMLRowID))  q:SMLRowID=""  d
    .....s TRowID=SMLRowID
    .....s TEquipName=$p($g(^DHCEQStoreMoveList(SMLRowID)),"^",5)
    .....q:(vEquipName'="")&(TEquipName'=vEquipName)  //modify BY GBX 2015-03-05 11:43:51
    .....s TModelDR=$p($g(^DHCEQStoreMoveList(SMLRowID)),"^",9)
    .....i TModelDR'="" s TModel=$p($g(^DHCEQCCode("DHCEQCModel",TModelDR)),"^",2)
    .....q:(vModel'="")&(TModel'=vModel)  //modify BY GBX 2015-03-05 11:43:51
    .....s TUnitDR=$p($g(^DHCEQStoreMoveList(SMLRowID)),"^",10)
    .....i TUnitDR'="" s TUnit=##Class(web.DHCEQCommon).GetTrakNameByID("uom",TUnitDR)
    .....q:(vUnit'="")&(vUnit'=TUnit)
    .....s EquipDR=$p($g(^DHCEQStoreMoveList(SMLRowID)),"^",2)
    .....s InStockListDR=$p($g(^DHCEQStoreMoveList(SMLRowID)),"^",4)
    .....i EquipDR'=""  d
    ......s TStatCatDR=$p($g(^DHCEQEquip(EquipDR)),"^",75)
    ......s ItemDR=$p($g(^DHCEQEquip(EquipDR)),"^",7)
    ......s TEquipCatDR=$p($g(^DHCEQEquip(EquipDR)),"^",4)
    ......s InStockListDR=$p($g(^DHCEQEquip(EquipDR)),"^",70)
    .....e  d
    ......s TStatCatDR=$p($g(^DHCEQInStockList(InStockListDR)),"^",17)
    ......s ItemDR=$p($g(^DHCEQInStockList(InStockListDR)),"^",16)
    ......s TEquipCatDR=$p($g(^DHCEQInStockList(InStockListDR)),"^",14)
    .....i TStatCatDR'="" s TStatCat=$p($g(^DHCEQCCode("DHCEQCStatCat",TStatCatDR)),"^",2)
    .....;s TEquipCatDR=$p($g(^DHCEQCCode("DHCEQCMasterItem",ItemDR)),"^",10)
    .....;i TEquipCatDR'=""  d
    .....;.s TEquipCatCode=$p($g(^DHCEQCCode("DHCEQCTree",TEquipCatDR)),"^",2)
    .....;.s TEquipCat=$p($g(^DHCEQCCode("DHCEQCTree",TEquipCatDR)),"^",3)
    .....i TEquipCatDR'=""  d
    ......s TEquipCat=$p($g(^DHCEQCCode("DHCEQCEquipeCat",TEquipCatDR)),"^",2)
    ......s TEquipCatCode=$p($g(^DHCEQCCode("DHCEQCEquipeCat",TEquipCatDR)),"^",1)
    .....i InStockListDR'=""  d  //modify by GBX 2015-5-15 10:36:20修正错误
    ......s InStockID=$p($g(^DHCEQInStockList(InStockListDR)),"^",1)  
    ......s InStockNo=$p($g(^DHCEQInStock(InStockID)),"^",14)  //入库单号
    .....s TQuantity=$p($g(^DHCEQStoreMoveList(SMLRowID)),"^",8)
    .....s TOriginalFee=$fn($p($g(^DHCEQStoreMoveList(SMLRowID)),"^",7),"",2)
    .....q:(vOriginalFee'="")&(vOriginalFee'=$FN(TOriginalFee,"",2))
    .....s TAmount=$fn(TQuantity*TOriginalFee,"",2)
    .....s EQRowIDs=$g(^DHCEQStoreMoveList(SMLRowID,"EX","RowIDs"))
    .....s Count=0
    .....s Count=$L(EQRowIDs,",")
    .....s CurRowID=""
    .....q:((Count=0)||(Count=""))
    .....f i=1:1:Count  d
    ......s CurRowID=$p(EQRowIDs,",",i)
    ......s TEquipNos=$p($g(^DHCEQEquip(CurRowID)),"^",71)
    ......s TNum=1
    ......d OutputRowGetStoreMoveDetailGZ
    ......;s TEquipNos=##Class(web.DHCEQCommon).GetEquipNos(EQRowIDs,0)
    ......;d OutputRowGetStoreMoveDetail
    
    Quit $$$OK
OutputRowGetStoreMoveDetailGZ
    s Data=$lb(TRowID,TStoreMoveNo,TFromLoc,TToLoc,TInDate,TActDate,TReciver,TEquipName,TModel,TUnit,TOriginalFee,TQuantity,TAmount,TEquipCatCode,TEquipType,TStatCat,TEquipCat,TEquipNos,InStockNo,TNum)
    Set ^CacheTemp(repid,index)=Data
    Set index=index+1
    quit
ResetVariablesGetMoveDetailGZ
    s (TRowID,TStoreMoveNo,TFromLoc,TToLoc,TInDate,TActDate,TReciver,TEquipName,TModel,TUnit,TOriginalFee,TQuantity,TAmount,TEquipCatCode,TEquipType,TStatCat,TEquipCat,TEquipNos,InStockID,InStockNo,TNum)=""
    quit
}

ClassMethod StoreMoveDetailGZFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = StoreMoveDetailGZExecute ]
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

Query StoreMoveDetailGZ(vStartDate As %String = "", vEndDate As %String = "", MoveType As %String = "", QXType As %String = "", EquipType As %String = "", EquipTypeDR As %String = "", CurGroupID As %String = "", CurLocID As %String = "", vEquipName As %String = "", vModel As %String = "", vUnit As %String = "", vOriginalFee As %String = "") As %Query(ROWSPEC = "TRowID:%String,TStoreMoveNo:%String,TFromLoc:%String,TToLoc:%String,TInDate:%String,TActDate:%String,TReciver:%String,TEquipName:%String,TModel:%String,TUnit:%String,TOriginalFee:%String,TQuantity:%String,TAmount:%String,TEquipCatCode:%String,TEquipType:%String,TStatCat:%String,TEquipCat:%String,TEquipNos:%String,InStockNo:%String,TNum:%String") [ SqlProc ]
{
}

/***************************************************************************/
/// Add By DJ 2016-05-06
/// 描述:获取当前用户某一时间段内审核的有效单据
/// 返回:业务类型,业务单号,设备类组,业务明细DR,设备编号,设备名称,规格,数量,单位,金额,审核人,审核日期
/// d ##class(%ResultSet).RunQuery("web.DHCEQYJSRunQian","GetAuditBussList",5,"2016-04-25","2016-04-25")
Query GetAuditBussList(vBussTypeDR As %String, vStartDate As %String = "", vEndDate As %String = "", CurUserDR As %String = "", CurGroupID As %String = "", CurLocID As %String = "", QXType As %String = "") As %Query(ROWSPEC = "TBussType:%String,TBussNo:%String,TEquipTypeDR:%String,TEquipType:%String,TBussListDR:%String,TEquipNo:%String,TEquipName:%String,TModel:%String,TQty:%String,TUnit:%String,TOriginalFee:%String,TAmount:%String,TAuditUser:%String,TAuditDate:%String,TAuditTime:%String") [ SqlProc ]
{
}

ClassMethod GetAuditBussListExecute(ByRef qHandle As %Binary, vBussTypeDR As %String, vStartDate As %String = "", vEndDate As %String = "", CurUserDR As %String = "", CurGroupID As %String = "", CurLocID As %String = "", QXType As %String = "") As %Status
{
    new repid, index,rowid
    Set repid=$I(^CacheTemp)
    Set qHandle=$lb(0,repid,0)
    s index=1
    s rowid=0
    i ((vStartDate="")&&(vEndDate=""))  Quit $$$OK
    s BeginDate=+$H
    s EndDate=+$H
    ;i vStartDate'="" s BeginDate=$ZDH(vStartDate,3)
    ;i vEndDate'="" s EndDate=$ZDH(vEndDate,3)
    ;日期格式统一调整    Modify by CSY 2017-03-02
    i vStartDate'="" s BeginDate=##Class(web.DHCEQCommon).TransValueFromPage(vStartDate,"date")
    i vEndDate'="" s EndDate=##Class(web.DHCEQCommon).TransValueFromPage(vEndDate,"date")
    
    s ApproveDate=BeginDate-1
    f  s ApproveDate=$o(^DHCEQApproveList(0,"DateUser",ApproveDate))  q:(ApproveDate="")||(ApproveDate>EndDate)  d
    .s ApproveUser=0
    .f  s ApproveUser=$o(^DHCEQApproveList(0,"DateUser",ApproveDate,ApproveUser))  q:ApproveUser=""  d
    ..q:(CurUserDR'="")&&(ApproveUser'=CurUserDR)
    ..s ApproveTypeDR=0
    ..f  s ApproveTypeDR=$o(^DHCEQApproveList(0,"DateUser",ApproveDate,ApproveUser,ApproveTypeDR))  q:ApproveTypeDR=""  d
    ...q:(vBussTypeDR'="0")&&(ApproveTypeDR'=vBussTypeDR)
    ...s ALRowID=0
    ...f  s ALRowID=$o(^DHCEQApproveList(0,"DateUser",ApproveDate,ApproveUser,ApproveTypeDR,ALRowID))  q:ALRowID=""  d
    ....s ALInvalidFlag=$p($g(^DHCEQApproveList(ALRowID)),"^",10)
    ....q:ALInvalidFlag="Y"
    ....s ALFlowStep=$p($g(^DHCEQApproveList(ALRowID)),"^",9)       //过滤提交审批
    ....q:ALFlowStep=0
    ....d ResetVariablesGetAuditBussList
    ....s ALOption=$p($g(^DHCEQApproveList(ALRowID)),"^",3)
    ....s ALTime=$p($g(^DHCEQApproveList(ALRowID)),"^",8)
    ....;i ALTime'="" s TAuditTime=$ZT(ALTime,1)
    ....;s TAuditDate=$ZD(ApproveDate,3)
    ....;日期格式统一调整    Modify by CSY 2017-03-02
    ....s TAuditTime=##Class(web.DHCEQCommon).TransValueToPage(ALTime,"time")
    ....s TAuditDate=##Class(web.DHCEQCommon).TransValueToPage(ApproveDate,"date")
    ....s TAuditUser=##Class(web.DHCEQCommon).GetTrakNameByID("user",ApproveUser)
    ....s TBussType=$p($g(^DHCEQCCode("DHCEQCApproveType",ApproveTypeDR)),"^",2)
    ....s ALSouceID=$p($g(^DHCEQApproveList(ALRowID)),"^",2)
    ....d BussOtherInfo
    
    Quit $$$OK
BussOtherInfo
    /*
    i ApproveTypeDR=5       //报废
    {
        s TInvalidFlag=$p($g(^DHCEQDisuseRequest(ALSouceID)),"^",53)
        q:TInvalidFlag="Y"
        s TBussNo=$p($g(^DHCEQDisuseRequest(ALSouceID)),"^",33)
        s TEquipTypeDR=$p($g(^DHCEQDisuseRequest(ALSouceID)),"^",43)
        q:(##Class(web.DHCEQCommon).EquipTypeIsIn(TEquipTypeDR,CurGroupID))
        s TEquipType=##Class(web.DHCEQCommon).GetTrakNameByID("equiptype",TEquipTypeDR)
        s DRLRowID=0
        f  s DRLRowID=$o(^DHCEQDisuseRequestList(0,"DisuseRequest",ALSouceID,DRLRowID))  q:DRLRowID=""  d
        .s TBussListDR=DRLRowID
        .s EQRowID=$p($g(^DHCEQDisuseRequestList(DRLRowID)),"^",2)
        .i EQRowID'=""  d
        ..s TEquipNo=$p($g(^DHCEQEquip(EQRowID)),"^",71)
        ..s TEquipName=$p($g(^DHCEQEquip(EQRowID)),"^",1)
        ..s TModelDR=$p($g(^DHCEQEquip(EQRowID)),"^",3)
        ..s TQty=1
        ..s TUnitDR=$p($g(^DHCEQEquip(EQRowID)),"^",5)
        ..s TOriginalFee=$fn($p($g(^DHCEQEquip(EQRowID)),"^",27),"",2)
        ..s TAmount=$fn(TQty*TOriginalFee,"",2)
        ..d OutputRowGetAuditBussList
    }
    */  
    i ApproveTypeDR=7       //验收
    {
        s TInvalidFlag=$p($g(^DHCEQOpenCheckRequest(ALSouceID)),"^",45)
        q:TInvalidFlag="Y"
        s TBussNo=$p($g(^DHCEQOpenCheckRequest(ALSouceID)),"^",37)
        s TEquipTypeDR=$p($g(^DHCEQOpenCheckRequest(ALSouceID)),"^",2)
        q:(##Class(web.DHCEQCommon).EquipTypeIsIn(TEquipTypeDR,CurGroupID))
        s TEquipType=##Class(web.DHCEQCommon).GetTrakNameByID("equiptype",TEquipTypeDR)
        s TBussListDR=$o(^DHCEQOpenCheckList(0,"OpenCheckRequest",ALSouceID,0))
        s TEquipNo=""
        s TEquipName=$p($g(^DHCEQOpenCheckList(TBussListDR)),"^",2)
        s TModelDR=$p($g(^DHCEQOpenCheckList(TBussListDR)),"^",5)
        i TModelDR'="" s TModel=##Class(web.DHCEQCommon).GetTrakNameByID("model",TModelDR)
        s TQty=$p($g(^DHCEQOpenCheckList(TBussListDR)),"^",16)
        s TUnitDR=$p($g(^DHCEQOpenCheckList(TBussListDR)),"^",7)
        i TUnitDR'="" s TUnit=##Class(web.DHCEQCommon).GetTrakNameByID("uom",TUnitDR)
        s TOriginalFee=$fn($p($g(^DHCEQOpenCheckList(TBussListDR)),"^",17),"",2)
        s TAmount=$fn(TQty*TOriginalFee,"",2)
        d OutputRowGetAuditBussList
    }
    /*
    i ApproveTypeDR=13      //入库
    {
        s TInvalidFlag=$p($g(^DHCEQInStock(ALSouceID)),"^",25)
        q:TInvalidFlag="Y"
        s TBussNo=$p($g(^DHCEQInStock(ALSouceID)),"^",14)
        s TEquipTypeDR=$p($g(^DHCEQInStock(ALSouceID)),"^",20)
        q:(##Class(web.DHCEQCommon).EquipTypeIsIn(TEquipTypeDR,CurGroupID))
        s TEquipType=##Class(web.DHCEQCommon).GetTrakNameByID("equiptype",TEquipTypeDR)
        s ISLRowID=0
        f  s ISLRowID=$o(^DHCEQInStockList(0,"InStock",ALSouceID,ISLRowID))  q:ISLRowID=""  d
        .s TBussListDR=ISLRowID
        .s TEquipNo=""
        .s TEquipName=$p($g(^DHCEQInStockList(ISLRowID)),"^",5)
        .s TModelDR=$p($g(^DHCEQInStockList(ISLRowID)),"^",9)
        .i TModelDR'="" s TModel=##Class(web.DHCEQCommon).GetTrakNameByID("model",TModelDR)
        .s TQty=$p($g(^DHCEQInStockList(ISLRowID)),"^",8)
        .s TUnitDR=$p($g(^DHCEQInStockList(ISLRowID)),"^",10)
        .i TUnitDR'="" s TUnit=##Class(web.DHCEQCommon).GetTrakNameByID("uom",TUnitDR)
        .s TOriginalFee=$fn($p($g(^DHCEQInStockList(ISLRowID)),"^",7),"",2)
        .s TAmount=$fn(TQty*TOriginalFee,"",2)
        .d OutputRowGetAuditBussList
    }
    i ApproveTypeDR=14      //转移
    {
        s TInvalidFlag=$p($g(^DHCEQStoreMove(ALSouceID)),"^",27)
        q:TInvalidFlag="Y"
        s TBussNo=$p($g(^DHCEQStoreMove(ALSouceID)),"^",1)
        s TEquipTypeDR=$p($g(^DHCEQStoreMove(ALSouceID)),"^",16)
        q:(##Class(web.DHCEQCommon).EquipTypeIsIn(TEquipTypeDR,CurGroupID))
        s TEquipType=##Class(web.DHCEQCommon).GetTrakNameByID("equiptype",TEquipTypeDR)
        s SMLRowID=0
        f  s SMLRowID=$o(^DHCEQStoreMoveList(0,"StoreMove",ALSouceID,SMLRowID))  q:SMLRowID=""  d
        .s TBussListDR=SMLRowID
        .s TEquipNo=""
        .s TEquipName=$p($g(^DHCEQStoreMoveList(SMLRowID)),"^",5)
        .s TModelDR=$p($g(^DHCEQStoreMoveList(SMLRowID)),"^",9)
        .i TModelDR'="" s TModel=##Class(web.DHCEQCommon).GetTrakNameByID("model",TModelDR)
        .s TQty=$p($g(^DHCEQStoreMoveList(SMLRowID)),"^",8)
        .s TUnitDR=$p($g(^DHCEQStoreMoveList(SMLRowID)),"^",10)
        .i TUnitDR'="" s TUnit=##Class(web.DHCEQCommon).GetTrakNameByID("uom",TUnitDR)
        .s TOriginalFee=$fn($p($g(^DHCEQStoreMoveList(SMLRowID)),"^",7),"",2)
        .s TAmount=$fn(TQty*TOriginalFee,"",2)
        .d OutputRowGetAuditBussList
    }
    
    i ApproveTypeDR=15      //退货,减少
    {
        s TInvalidFlag=$p($g(^DHCEQReturn(ALSouceID)),"^",28)
        q:TInvalidFlag="Y"
        s TBussNo=$p($g(^DHCEQReturn(ALSouceID)),"^",1)
        s TEquipTypeDR=$p($g(^DHCEQReturn(ALSouceID)),"^",15)
        q:(##Class(web.DHCEQCommon).EquipTypeIsIn(TEquipTypeDR,CurGroupID))
        s TOutTypeDR=$p($g(^DHCEQReturn(ALSouceID)),"^",17)
        s TOutTypeCode=$p($g(^DHCEQCCode("DHCEQCOutType",TOutTypeDR)),"^",2)
        s TBussType="退货"
        i TOutTypeCode'="TH" s TBussType="减少"
        s TEquipType=##Class(web.DHCEQCommon).GetTrakNameByID("equiptype",TEquipTypeDR)
        s RLRowID=0
        f  s RLRowID=$o(^DHCEQReturnList(0,"Return",ALSouceID,RLRowID))  q:RLRowID=""  d
        .s TBussListDR=RLRowID
        .s TEquipNo=""
        .s TEquipDR=$p($g(^DHCEQReturnList(RLRowID)),"^",4)
        .s TInStockListDR=$p($g(^DHCEQReturnList(RLRowID)),"^",3)
        .i TEquipDR'=""  d
        ..s TEquipName=$p($g(^DHCEQEquip(TEquipDR)),"^",1)
        ..s TModelDR=$p($g(^DHCEQEquip(TEquipDR)),"^",3)
        ..s TUnitDR=$p($g(^DHCEQEquip(TEquipDR)),"^",5)
        .e  d
        ..s TEquipName=$p($g(^DHCEQInStockList(TInStockListDR)),"^",5)
        ..s TModelDR=$p($g(^DHCEQInStockList(TInStockListDR)),"^",9)
        ..s TUnitDR=$p($g(^DHCEQInStockList(TInStockListDR)),"^",10)
        .i TModelDR'="" s TModel=##Class(web.DHCEQCommon).GetTrakNameByID("model",TModelDR)
        .s TQty=$p($g(^DHCEQReturnList(RLRowID)),"^",5)
        .i TUnitDR'="" s TUnit=##Class(web.DHCEQCommon).GetTrakNameByID("uom",TUnitDR)
        .s TOriginalFee=$fn($p($g(^DHCEQReturnList(RLRowID)),"^",6),"",2)
        .s TAmount=$fn(TQty*TOriginalFee,"",2)
        .d OutputRowGetAuditBussList
    }
    i ApproveTypeDR=25      //维修
    {
        s TInvalidFlag=$p($g(^DHCEQMMaintRequest(ALSouceID)),"^",57)
        q:TInvalidFlag="Y"
        s TBussNo=$p($g(^DHCEQMMaintRequest(ALSouceID)),"^",1)
        s TEquipTypeDR=$p($g(^DHCEQMMaintRequest(ALSouceID)),"^",3)
        q:(##Class(web.DHCEQCommon).EquipTypeIsIn(TEquipTypeDR,CurGroupID))
        s TEquipType=##Class(web.DHCEQCommon).GetTrakNameByID("equiptype",TEquipTypeDR)
        s TBussListDR=ALSouceID
        s TEquipNo=""
        s TSourceTypeDR=$p($g(^DHCEQMMaintRequest(ALSouceID)),"^",63)
        s TExObjDR=$p($g(^DHCEQMMaintRequest(ALSouceID)),"^",5)
        i TExObjDR'=""  d
        .i TSourceTypeDR=1  d
        ..s EQRowID=$Piece($Get(^DHCEQMExObj(TExObjDR)),"^",5)
        ..i EQRowID'=""  d
        ...s TEquipName=$p($g(^DHCEQEquip(EQRowID)),"^",1)
        ...s TModelDR=$p($g(^DHCEQEquip(EQRowID)),"^",3)
        ...s TUnitDR=$p($g(^DHCEQEquip(EQRowID)),"^",5)
        ...s TOriginalFee=$fn($p($g(^DHCEQEquip(EQRowID)),"^",27),"",2)
        e  d
        .s TEquipName=$p($g(^DHCEQMExObj(TExObjDR)),"^",1)
        .s TOriginalFee=0
        i TModelDR'="" s TModel=##Class(web.DHCEQCommon).GetTrakNameByID("model",TModelDR)
        s TQty=1
        i TUnitDR'="" s TUnit=##Class(web.DHCEQCommon).GetTrakNameByID("uom",TUnitDR)
        s TAmount=$fn(TQty*TOriginalFee,"",2)
        d OutputRowGetAuditBussList
    }
    */
    
    quit
OutputRowGetAuditBussList
    s Data=$lb(TBussType,TBussNo,TEquipTypeDR,TEquipType,TBussListDR,TEquipNo,TEquipName,TModel,TQty,TUnit,TOriginalFee,TAmount,TAuditUser,TAuditDate,TAuditTime)
    Set ^CacheTemp(repid,index)=Data
    Set index=index+1
    quit
ResetVariablesGetAuditBussList
    s (TBussType,TBussNo,TEquipTypeDR,TEquipType,TBussListDR,TEquipNo,TEquipName,TModel,TQty,TUnit,TOriginalFee,TAmount,TAuditUser,TAuditDate,TAuditTime)=""
    quit
}

ClassMethod GetAuditBussListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAuditBussListExecute ]
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

ClassMethod GetAuditBussListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAuditBussListExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// d ##class(%ResultSet).RunQuery("web.DHCEQYJSRunQian","GetCAList")
Query GetCAList(vEquipNo As %String = "", vStartDate As %String = "", vEndDate As %String = "", CurGroupID As %String = "", CurLocID As %String = "", QXType As %String = "") As %Query(ROWSPEC = "TCARowID:%String,TEQRowID:%String,TEquipNo:%String,TEquipName:%String,TEQModel:%String,TEquipType:%String,TStatCat:%String,TLocDesc:%String,TFOriginalFee:%String,TFNetFee:%String,TChangeFee:%String,TTOriginalFee:%String,TTNetFee:%String,TRemark:%String,TChangeReason:%String,TChangeUser:%String,TChangeDate:%String,TChangeTime:%String") [ SqlProc ]
{
}

ClassMethod GetCAListExecute(ByRef qHandle As %Binary, vEquipNo As %String = "", vStartDate As %String = "", vEndDate As %String = "", CurGroupID As %String = "", CurLocID As %String = "", QXType As %String = "") As %Status
{
    new repid, index,rowid
    Set repid=$I(^CacheTemp)
    Set qHandle=$lb(0,repid,0)
    s index=1
    
    s BeginDate=0
    s EndDate=+$H
    ;i vStartDate'="" s BeginDate=$ZDH(vStartDate,3)
    ;i vEndDate'="" s EndDate=$ZDH(vEndDate,3)
    ;日期格式统一调整    Modify by CSY 2017-03-02
    i vStartDate'="" s BeginDate=##Class(web.DHCEQCommon).TransValueFromPage(vStartDate,"date")
    i vEndDate'="" s EndDate=##Class(web.DHCEQCommon).TransValueFromPage(vEndDate,"date")
    
    s CAETRowID=0
    f  s CAETRowID=$o(^DHCEQChangeAccount(0,"TypeDate",CAETRowID))  q:CAETRowID=""  d
    .q:(##Class(web.DHCEQCommon).EquipTypeIsIn(CAETRowID,CurGroupID))
    .s AuditDate=BeginDate-1
    .f  s AuditDate=$o(^DHCEQChangeAccount(0,"TypeDate",CAETRowID,AuditDate))  q:(AuditDate="")||(AuditDate>EndDate)  d
    ..s CARowID=0
    ..f  s CARowID=$o(^DHCEQChangeAccount(0,"TypeDate",CAETRowID,AuditDate,CARowID))  q:CARowID=""  d
    ...d ResetVariablesGetCAListInfo
    ...s TCARowID=CARowID
    ...s TEQRowID=$p($g(^DHCEQChangeAccount(TCARowID)),"^",1)
    ...s TEquipNo=$p($g(^DHCEQEquip(TEQRowID)),"^",71)
    ...q:(vEquipNo'="")&&(TEquipNo'=vEquipNo)
    ...s CAStatus=$p($g(^DHCEQChangeAccount(TCARowID)),"^",11)
    ...q:CAStatus'=2
    ...s TEquipName=$p($g(^DHCEQEquip(TEQRowID)),"^",1)
    ...s TEQModel=$p($g(^DHCEQEquip(TEQRowID)),"^",3)
    ...i TEQModel'="" s TEQModel=$p($g(^DHCEQCCode("DHCEQCModel",TEQModel)),"^",2)
    ...s TEquipType=$p($g(^DHCEQCCode("DHCEQCEquipType",CAETRowID)),"^",2)
    ...s TStatCat=$p($g(^DHCEQChangeAccount(TCARowID)),"^",31)
    ...i TStatCat'="" s TStatCat=$p($g(^DHCEQCCode("DHCEQCStatCat",TStatCat)),"^",2)
    ...s TLocDesc=$p($g(^DHCEQChangeAccount(TCARowID)),"^",28)
    ...;i TLocDesc'="" s TLocDesc=$p($g(^CTLOC(TLocDesc)),"^",2)   //modify by jyp 2019-10-18 CTLOC调整
    ...i TLocDesc'="" s TLocDesc=##class(web.DHCEQCommon).GetTrakNameByID("dept",TLocDesc)  //modify by jyp 2019-10-18 CTLOC调整
    ...s TFOriginalFee=$fn($p($g(^DHCEQChangeAccount(TCARowID)),"^",24),"",2)
    ...s TFNetFee=$fn($p($g(^DHCEQChangeAccount(TCARowID)),"^",25),"",2)
    ...s TChangeFee=$fn($p($g(^DHCEQChangeAccount(TCARowID)),"^",2),"",2)
    ...s TTOriginalFee=$fn($p($g(^DHCEQChangeAccount(TCARowID)),"^",3),"",2)
    ...s TTNetFee=$fn($p($g(^DHCEQChangeAccount(TCARowID)),"^",4),"",2)
    ...s TRemark=$p($g(^DHCEQChangeAccount(TCARowID)),"^",10)
    ...s TChangeReason=$p($g(^DHCEQChangeAccount(TCARowID)),"^",8)
    ...s TChangeUser=$p($g(^DHCEQChangeAccount(TCARowID)),"^",21)
    ...i TChangeUser'="" s TChangeUser=##class(web.DHCEQCommon).GetTrakNameByID("user",TChangeUser)
    ...;s TChangeDate=$ZD(AuditDate,3)
    ...;日期格式统一调整    Modify by CSY 2017-03-02
    ...s TChangeDate=##Class(web.DHCEQCommon).TransValueToPage(AuditDate,"date")
    ...s TChangeTime=$p($g(^DHCEQChangeAccount(TCARowID)),"^",23)
    ...;i TChangeTime'="" s TChangeTime=$ZT(TChangeTime,1)
    ...;日期格式统一调整    Modify by CSY 2017-03-02
    ...i TChangeTime'="" s TChangeTime=##Class(web.DHCEQCommon).TransValueToPage(TChangeTime,"time")
    ...d OutputRowGetCAListInfo
    
    Quit $$$OK
    
OutputRowGetCAListInfo
   s Data=$lb(TCARowID,TEQRowID,TEquipNo,TEquipName,TEQModel,TEquipType,TStatCat,TLocDesc,TFOriginalFee,TFNetFee,TChangeFee,TTOriginalFee,TTNetFee,TRemark,TChangeReason,TChangeUser,TChangeDate,TChangeTime)
    Set ^CacheTemp(repid,index)=Data
    Set index=index+1
    quit
ResetVariablesGetCAListInfo
    s (TCARowID,TEQRowID,TEquipNo,TEquipName,TEQModel,TEquipType,TStatCat,TLocDesc,TFOriginalFee,TFNetFee,TChangeFee,TTOriginalFee,TTNetFee,TRemark,TChangeReason,TChangeUser,TChangeDate,TChangeTime)=""
    quit
}

ClassMethod GetCAListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetCAListExecute ]
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

ClassMethod GetCAListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetCAListExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)

    Quit $$$OK
}

/***********************************************************************************/
}
