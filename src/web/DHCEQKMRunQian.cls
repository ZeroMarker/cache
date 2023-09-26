Class web.DHCEQKMRunQian Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/*************************************************************************/
/// Add By DJ 2014-02-28
/// 韶关设备快照查询
ClassMethod SnapEquipClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SnapEquipExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)

    Quit $$$OK
}

ClassMethod SnapEquipExecute(ByRef qHandle As %Binary, MonthStr As %String = "", QXType As %String = "", vUseLoc As %String = "", vUseLocDR As %String = "", EquipType As %String = "", EquipTypeDR As %String = "", FundsType As %String = "", FundsTypeDR As %String = "", OutLayType As %String = "", OutLayTypeDR As %String = "", vStatus As %String = "", EquipNo As %String = "", OldEquipNo As %String = "", CurGroupID As %String = "", CurLocID As %String = "", DisUseFlag As %String = "", DisUseSDate As %String = "", DisUseEDate As %String = "", vHospital As %String = "") As %Status
{
    new repid, index,rowid
    Set repid=$I(^CacheTemp)
    Set qHandle=$lb(0,repid,0)
    s index=1
    
    i DisUseFlag'="" s MonthStr=$E($ZD(+$H,3),1,7)
    i (MonthStr="") Quit $$$OK
    i EquipType="" s EquipTypeDR=""
    i vUseLoc="" s vUseLocDR=""
    i FundsType="" s FundsTypeDR=""
    i OutLayType="" s OutLayTypeDR=""
    i DisUseSDate=""  d
    .s vDisUseSDate=0
    e  d
    .s vDisUseSDate=##class(web.DHCEQCommon).TransValueFromPage(DisUseSDate,"date")  ;Modified by QW20170302日期格式统一调整 原$ZDH(DisUseSDate,3)
    i DisUseEDate=""  d
    .s vDisUseEDate=+$H
    e  d
    .s vDisUseEDate=##class(web.DHCEQCommon).TransValueFromPage(DisUseEDate,"date")  ;Modified by QW20170302日期格式统一调整 原$ZDH(DisUseEDate,3)
    quit $$$OK
    s SnapID=##Class(web.DHCEQSnapShot).GetSnapIDByMonth(MonthStr)
    i DisUseFlag'="" s SnapID=""
    s RowID=0
    i SnapID=""  d
    .f  s RowID=$o(^DHCEQEquip(RowID))  q:RowID=""  d
    ..d ResetVariablesGetSnapEquip
    ..q:RowID>20
    ..s InvalidFlag=$p($g(^DHCEQEquip(RowID)),"^",59)
    ..q:InvalidFlag="Y"
    ..s EQStoreLocDR=$p($g(^DHCEQEquip(RowID)),"^",67)  //设备库房
    ..q:(vUseLocDR'="")&&(EQStoreLocDR'=vUseLocDR)
    ..s EQEquipTypeDR=$p($g(^DHCEQEquip(RowID)),"^",63) //设备类组
    ..q:(EquipTypeDR'="")&&(EquipTypeDR'=EQEquipTypeDR)
    ..;q:(##Class(web.DHCEQCommon).EquipTypeIsIn(EQEquipTypeDR,CurGroupID))
    ..s EQOriginalFee=$p($g(^DHCEQEquip(RowID)),"^",27) //设备原值
    ..s EQStatus=$p($g(^DHCEQEquip(RowID)),"^",38)
    ..s EQStockStatus=$p($g(^DHCEQEquip(RowID)),"^",60)
    ..q:'((EQStockStatus="1")&&(EQStatus<=2))&&(DisUseFlag="")
    ..q:(DisUseFlag'="")&&(EQStatus'=3)
    ..s TDisUseDate=$p($g(^DHCEQEquip(RowID)),"^",89)
    ..q:(DisUseFlag'="")&&(vDisUseSDate'="")&&(TDisUseDate<vDisUseSDate)
    ..q:(DisUseFlag'="")&&(vDisUseEDate'="")&&(TDisUseDate>vDisUseEDate)
    ..s TDisUseDate=##class(web.DHCEQCommon).TransValueToPage(TDisUseDate,"date") ;Modified by QW20170302日期格式统一调整 原i TDisUseDate'="" s TDisUseDate=$ZD(TDisUseDate,3)
    ..s TRowID=RowID
    ..s TEQNo=$p($g(^DHCEQEquip(RowID)),"^",71)     //设备编号
    ..q:(EquipNo'="")&&(TEQNo'=EquipNo)
    ..s TOldEquipNo=$p($g(^DHCEQEquip(RowID)),"^",91)
    ..q:(OldEquipNo'="")&&(TOldEquipNo'=OldEquipNo)
    ..;s TBrandDR=$p($g(^DHCEQEquip(RowID)),"^",94)
    ..;i TBrandDR'="" s TBrand=$p($g(^DHCEQCCode("DHCEQCBrand",TBrandDR)),"^",3)
    ..s TBrand=$p($g(^DHCEQEquip(RowID)),"^",94)
    ..;s TOutLayTypeDR=$p($g(^DHCEQEquip(RowID)),"^",95)
    ..;q:(OutLayTypeDR'="")&&(TOutLayTypeDR'=OutLayTypeDR)
    ..;i TOutLayTypeDR'="" s TOutLayType=$p($g(^DHCEQCCode("DHCEQCOutLayType",TOutLayTypeDR)),"^",2)
    ..s TEquipName=$p($g(^DHCEQEquip(RowID)),"^",1) //设备名称
    ..s TModel=$p($g(^DHCEQEquip(RowID)),"^",3)     //规格型号
    ..i TModel'="" s TModel=$p($g(^DHCEQCCode("DHCEQCModel",TModel)),"^",2)
    ..s TUseLoc=$p($g(^DHCEQEquip(RowID)),"^",67)   //使用科室
    ..;s THospital=$p($g(^CTLOC(TUseLoc)),"^",22)  //modify by jyp 2019-10-18 CTLOC调整
    ..s THospital=##Class(web.DHCEQ.Plat.LIBCommon).GetHospitalByDeptID(TUseLoc)  //modify by jyp 2019-10-18 CTLOC调整
    ..q:(vHospital'="")&&(THospital'=vHospital) 
    ..i TUseLoc'="" s TUseLoc=##class(web.DHCEQCommon).GetTrakNameByID("dept",TUseLoc)
    ..s TOriginalFee=$fn($p($g(^DHCEQEquip(RowID)),"^",27),"",2) //设备原值
    ..s TStatCatDR=$p($g(^DHCEQEquip(RowID)),"^",75)        //设备类型
    ..i TStatCatDR'="" s TStatCat=$p($g(^DHCEQCCode("DHCEQCStatCat",TStatCatDR)),"^",2)
    ..s TEquipCatDR=$p($g(^DHCEQEquip(RowID)),"^",4)        //设备分类
    ..i TEquipCatDR'=""  d
    ...s TEquipCatCode=$p($g(^DHCEQCCode("DHCEQCEquipeCat",TEquipCatDR)),"^",1)
    ...s TEquipCat=$p($g(^DHCEQCCode("DHCEQCEquipeCat",TEquipCatDR)),"^",2)
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
    ..s TLeaveFactoryDate=##class(web.DHCEQCommon).TransValueToPage(TLeaveFactoryDate,"date") ;Modified by QW20170302日期格式统一调整 原 i TLeaveFactoryDate'="" s TLeaveFactoryDate=$ZD(TLeaveFactoryDate,3)
    ..s TOpenCheckDate=$p($g(^DHCEQEquip(RowID)),"^",12)        //开箱日期
    ..s TOpenCheckDate=##class(web.DHCEQCommon).TransValueToPage(TOpenCheckDate,"date") ;Modified by QW20170302日期格式统一调整 原 i TOpenCheckDate'="" s TOpenCheckDate=$ZD(TOpenCheckDate,3)
    ..s TCheckDate=$p($g(^DHCEQEquip(RowID)),"^",13)            //验收日期
    ..s TCheckDate=##class(web.DHCEQCommon).TransValueToPage(TCheckDate,"date") ;Modified by QW20170302日期格式统一调整 原 i TCheckDate'="" s TCheckDate=$ZD(TCheckDate,3)
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
    ..s TStartDate=##class(web.DHCEQCommon).TransValueToPage(TStartDate,"date") ;Modified by QW20170302日期格式统一调整 原 i TStartDate'="" s TStartDate=$ZD(TStartDate,3)
    ..s TTransAssetDate=$p($g(^DHCEQEquip(RowID)),"^",45)   //转资日期
    ..s TTransAssetDate=##class(web.DHCEQCommon).TransValueToPage(TTransAssetDate,"date") ;Modified by QW20170302日期格式统一调整 原 i TTransAssetDate'="" s TTransAssetDate=$ZD(TTransAssetDate,3)
    ..s TKeeperDR=$p($g(^DHCEQEquip(RowID)),"^",66)         //保管人
    ..i TKeeperDR'="" s TKeeper=##Class(web.DHCEQCommon).GetTrakNameByID("user",TKeeperDR)
    ..s TInStockListDR=$p($g(^DHCEQEquip(RowID)),"^",70)
    ..i TInStockListDR'=""  d
    ...s TInStockDR=$p($g(^DHCEQInStockList(TInStockListDR)),"^",1)
    ...s TInStockNo=$p($g(^DHCEQInStock(TInStockDR)),"^",14)
    ..s TQuantityNum="1"
    ..s FTRowID=0
    ..f  s FTRowID=$o(^DHCEQCCode("DHCEQCFundsType",FTRowID))  q:FTRowID=""  d
    ...s TFundsType=$p($g(^DHCEQCCode("DHCEQCFundsType",FTRowID)),"^",2)
    ...s TFundsFee=$fn(##Class(web.DHCEQFunds).GetFundsAmountByFromID(1,RowID,FTRowID,""),"",2)
    ...q:TFundsFee<=0
    ...s FRowID=$o(^DHCEQFunds("0","EquipType",RowID,FTRowID,0))
    ...i FRowID'="" s TFDepreTotal=$fn($p($g(^DHCEQFunds(FRowID)),"^",13),"",2)
    ...s TFNetFee=$fn(TFundsFee-TFDepreTotal,"",2)
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
    ..;q:(##Class(web.DHCEQCommon).EquipTypeIsIn(EQEquipTypeDR,CurGroupID))
    ..s EQOriginalFee=$p($g(^DHCEQSnapShot(SnapID,"Equip",RowID)),"^",27)   //设备原值
    ..s EQStatus=$p($g(^DHCEQSnapShot(SnapID,"Equip",RowID)),"^",38)
    ..s EQStockStatus=$p($g(^DHCEQSnapShot(SnapID,"Equip",RowID)),"^",60)
    ..q:'((EQStockStatus="1")&&(EQStatus<=2))
    ..s TRowID=RowID
    ..s TEQNo=$p($g(^DHCEQSnapShot(SnapID,"Equip",RowID)),"^",71)       //设备编号
    ..q:(EquipNo'="")&&(TEQNo'=EquipNo)
    ..s TOldEquipNo=$p($g(^DHCEQSnapShot(SnapID,"Equip",RowID)),"^",91)
    ..;q:(OldEquipNo'="")&&(TOldEquipNo'=OldEquipNo)
    ..;s TBrandDR=$p($g(^DHCEQSnapShot(SnapID,"Equip",RowID)),"^",94)
    ..;i TBrandDR'="" s TBrand=$p($g(^DHCEQCCode("DHCEQCBrand",TBrandDR)),"^",3)
    ..s TBrand=$p($g(^DHCEQSnapShot(SnapID,"Equip",RowID)),"^",94)
    ..;s TOutLayTypeDR=$p($g(^DHCEQSnapShot(SnapID,"Equip",RowID)),"^",95)
    ..;q:(OutLayTypeDR'="")&&(TOutLayTypeDR'=OutLayTypeDR)
    ..;i TOutLayTypeDR'="" s TOutLayType=$p($g(^DHCEQCCode("DHCEQCOutLayType",TOutLayTypeDR)),"^",2)
    ..s TEquipName=$p($g(^DHCEQSnapShot(SnapID,"Equip",RowID)),"^",1)   //设备名称
    ..s TModel=$p($g(^DHCEQSnapShot(SnapID,"Equip",RowID)),"^",3)       //规格型号
    ..i TModel'="" s TModel=$p($g(^DHCEQSnapShot(SnapID,"Equip",RowID,"EX")),"^",2)
    ..s TUseLoc=$p($g(^DHCEQSnapShot(SnapID,"Equip",RowID)),"^",67) //使用科室
    ..;s THospital=$p($g(^CTLOC(TUseLoc)),"^",22)   //modify by jyp 2019-10-18 CTLOC调整
    ..s THospital=##Class(web.DHCEQ.Plat.LIBCommon).GetHospitalByDeptID(TUseLoc)   //modify by jyp 2019-10-18 CTLOC调整
    ..q:(vHospital'="")&&(THospital'=vHospital)
    ..i TUseLoc'="" s TUseLoc=##class(web.DHCEQCommon).GetTrakNameByID("dept",TUseLoc)
    ..s TOriginalFee=$fn($p($g(^DHCEQSnapShot(SnapID,"Equip",RowID)),"^",27),"",2) //设备原值
    ..s TStatCatDR=$p($g(^DHCEQSnapShot(SnapID,"Equip",RowID)),"^",75)      //设备类型
    ..i TStatCatDR'="" s TStatCat=$p($g(^DHCEQCCode("DHCEQCStatCat",TStatCatDR)),"^",2)
    ..s TEquipCatDR=$p($g(^DHCEQSnapShot(SnapID,"Equip",RowID)),"^",4)      //设备分类
    ..i TEquipCatDR'=""  d
    ...s TEquipCatCode=$p($g(^DHCEQCCode("DHCEQCEquipeCat",TEquipCatDR)),"^",1)
    ...s TEquipCat=$p($g(^DHCEQCCode("DHCEQCEquipeCat",TEquipCatDR)),"^",2)
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
    ..s TLeaveFactoryDate=##class(web.DHCEQCommon).TransValueToPage(TLeaveFactoryDate,"date") ;Modified by QW20170302日期格式统一调整 原 i TLeaveFactoryDate'="" s TLeaveFactoryDate=$ZD(TLeaveFactoryDate,3)
    ..s TOpenCheckDate=$p($g(^DHCEQSnapShot(SnapID,"Equip",RowID)),"^",12)      //开箱日期
    ..s TOpenCheckDate=##class(web.DHCEQCommon).TransValueToPage(TOpenCheckDate,"date") ;Modified by QW20170302日期格式统一调整 原 i TOpenCheckDate'="" s TOpenCheckDate=$ZD(TOpenCheckDate,3)
    ..s TCheckDate=$p($g(^DHCEQSnapShot(SnapID,"Equip",RowID)),"^",13)          //验收日期
    ..s TCheckDate=##class(web.DHCEQCommon).TransValueToPage(TCheckDate,"date") ;Modified by QW20170302日期格式统一调整 原 i TCheckDate'="" s TCheckDate=$ZD(TCheckDate,3)
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
    ..s TStartDate=##class(web.DHCEQCommon).TransValueToPage(TStartDate,"date") ;Modified by QW20170302日期格式统一调整 原 i TStartDate'="" s TStartDate=$ZD(TStartDate,3)
    ..s TTransAssetDate=$p($g(^DHCEQSnapShot(SnapID,"Equip",RowID)),"^",45) //转资日期
    ..s TTransAssetDate=##class(web.DHCEQCommon).TransValueToPage(TTransAssetDate,"date") ;Modified by QW20170302日期格式统一调整 原 i TTransAssetDate'="" s TTransAssetDate=$ZD(TTransAssetDate,3)
    ..s TKeeperDR=$p($g(^DHCEQSnapShot(SnapID,"Equip",RowID)),"^",66)           //保管人
    ..i TKeeperDR'="" s TKeeper=##Class(web.DHCEQCommon).GetTrakNameByID("user",TKeeperDR)
    ..s TInStockListDR=$p($g(^DHCEQSnapShot(SnapID,"Equip",RowID)),"^",70)
    ..i TInStockListDR'=""  d
    ...s TInStockDR=$p($g(^DHCEQInStockList(TInStockListDR)),"^",1)
    ...s TInStockNo=$p($g(^DHCEQInStock(TInStockDR)),"^",14)
    ..s TQuantityNum="1"
    ..s FRowID=0
    ..s Find=0
    ..f  s FRowID=$o(^DHCEQSnapShot(SnapID,"Funds",RowID,FRowID))  q:FRowID=""  d
    ...s Find=1
    ...s FTFundsType=$p($g(^DHCEQSnapShot(SnapID,"Funds",RowID,FRowID)),"^",2)
    ...i FTFundsType'="" s TFundsType=$p($g(^DHCEQCCode("DHCEQCFundsType",FTFundsType)),"^",2)
    ...s TFundsFee=$fn($p($g(^DHCEQSnapShot(SnapID,"Funds",RowID,FRowID)),"^",3),"",2)
    ...q:TFundsFee<=0
    ...s TFDepreTotal=$fn($p($g(^DHCEQSnapShot(SnapID,"Funds",RowID,FRowID)),"^",13),"",2)
    ...s TFNetFee=$fn(TFundsFee-TFDepreTotal,"",2)
    ...d OutputRowGetSnapEquip
    ..i Find=0  d
    ...d OutputRowGetSnapEquip
    
    
    Quit $$$OK
OutputRowGetSnapEquip
    s Data=$lb(TRowID,TEQNo,TEquipName,TModel,TUseLoc,TEquipType,TStatCat,TEquipCatCode,TEquipCat,TOriginalFee,TLimitYearsNum,TNetFee,TDepreTotalFee,TManuFactory,TUnit,TProvider,TStatus,TCode,TLeaveFactoryNo,TLeaveFactoryDate,TOpenCheckDate,TCheckDate,TCountry,TOrigin,TRemark,TDepreMethod,TManageUser,TStartDate,TTransAssetDate,TKeeper,TQuantityNum,TOldEquipNo,TBrand,TOutLayType,TFundsType,TFundsFee,TDisUseDate,TFDepreTotal,TFNetFee,TInStockNo)
    Set ^CacheTemp(repid,index)=Data
    Set index=index+1
    quit
ResetVariablesGetSnapEquip
    s (TRowID,TInStockListDR,TEQNo,TEquipName,TModel,TUseLoc,TEquipType,TStatCat,TEquipCatCode,TEquipCat,TOriginalFee,TLimitYearsNum,TNetFee,TDepreTotalFee,TManuFactory,TUnit,TProvider,TStatus,TCode,TLeaveFactoryNo,TLeaveFactoryDate,TOpenCheckDate,TCheckDate,TCountry,TOrigin,TRemark,TDepreMethod,TManageUser,TStartDate,TTransAssetDate,TKeeper,TQuantityNum,TOldEquipNo,TBrand,TOutLayType,TFundsType,TFundsFee,TDisUseDate,TFDepreTotal,TFNetFee,TInStockNo)=""
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

Query SnapEquip(MonthStr As %String = "", QXType As %String = "", UseLoc As %String = "", UseLocDR As %String = "", EquipType As %String = "", EquipTypeDR As %String = "", FundsType As %String = "", FundsTypeDR As %String = "", OutLayType As %String = "", OutLayTypeDR As %String = "", vStatus As %String = "", EquipNo As %String = "", OldEquipNo As %String = "", CurGroupID As %String = "", CurLocID As %String = "", DisUseFlag As %String = "", DisUseSDate As %String = "", DisUseEDate As %String = "", vHospital As %String = "") As %Query(ROWSPEC = "TRowID:%String,TEQNo:%String,TEquipName:%String,TModel:%String,TUseLoc:%String,TEquipType:%String,TStatCat:%String,TEquipCatCode:%String,TEquipCat:%String,TOriginalFee:%String,TLimitYearsNum:%String,TNetFee:%String,TDepreTotalFee:%String,TManuFactory:%String,TUnit:%String,TProvider:%String,TStatus:%String,TCode:%String,TLeaveFactoryNo:%String,TLeaveFactoryDate:%String,TOpenCheckDate:%String,TCheckDate:%String,TCountry:%String,TOrigin:%String,TRemark:%String,TDepreMethod:%String,TManageUser:%String,TStartDate:%String,TTransAssetDate:%String,TKeeper:%String,TQuantityNum:%String,TOldEquipNo:%String,TBrand:%String,TOutLayType:%String,TFundsType:%String,TFundsFee:%String,TDisUseDate:%String,TFDepreTotal:%String,TFNetFee:%String,TInStockNo:%String") [ SqlProc ]
{
}

/*************************************************************************/
/// Add By DJ 2014-02-28
ClassMethod FundsLocTypeDepreClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FundsLocTypeDepreExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)

    Quit $$$OK
}

ClassMethod FundsLocTypeDepreExecute(ByRef qHandle As %Binary, MonthStr As %String = "", QXType As %String = "", UseLoc As %String = "", UseLocDR As %String = "", EquipType As %String = "", EquipTypeDR As %String = "", FundsType As %String = "", FundsTypeDR As %String = "", CurGroupID As %String = "", CurLocID As %String = "", YearsFlag As %String = "") As %Status
{
    new repid, index,rowid
    Set repid=$I(^CacheTemp)
    Set qHandle=$lb(0,repid,0)
    Set job=$J
    s SelfFundsFlag=##class(web.DHCEQCommon).GetSysInfo("990015")
    i ((MonthStr="")||(SelfFundsFlag="")) Quit $$$OK
    i UseLoc="" s UseLocDR=""
    i EquipType="" s EquipTypeDR=""
    i FundsType="" s FundsTypeDR=""
    s index=1
    s MonthNum=1
    s MonthCount=1
    
    i YearsFlag="Y" s MonthCount=12
    
    for MonthNum=1:1:MonthCount  d
    .i YearsFlag="Y"  d
    ..i MonthNum<10  d
    ...s MonthStr=$p(MonthStr,"-",1)_"-0"_MonthNum
    ..e  d
    ...s MonthStr=$p(MonthStr,"-",1)_"-"_MonthNum
    .s CurYear=$p(MonthStr,"-",1)
    .s CurMonth=+$p(MonthStr,"-",2)
    .i CurMonth=1  d
    ..s PreYear=CurYear-1
    ..s PreMonth=12
    .e  d
    ..s PreYear=CurYear
    ..s PreMonth=CurMonth-1
    .s SnapID=##Class(web.DHCEQSnapShot).GetSnapIDByMonth(PreYear_"-"_PreMonth)
    .q:SnapID=""
    .s MDRowID=0
    .f  s MDRowID=$o(^DHCEQMonthDepre(0,"Month",MonthStr,MDRowID))  quit:MDRowID=""  d
    ..d ResetVariablesGetFundsLocTypeDepre
    ..s EQRowID=$p($g(^DHCEQMonthDepre(MDRowID)),"^",1)
    ..s TEquipTypeDR=$p($g(^DHCEQSnapShot(SnapID,"Equip",EQRowID)),"^",63)
    ..q:(EquipTypeDR'="")&&(TEquipTypeDR'=EquipTypeDR)
    ..s result=##class(web.DHCEQCommon).EquipTypeIsIn(TEquipTypeDR,CurGroupID)
    ..q:+result'=0
    ..s TEQRowID=EQRowID
    ..i TEquipTypeDR'=""  d
    ...s TEquipType=$p($g(^DHCEQCCode("DHCEQCEquipType",TEquipTypeDR)),"^",2)
    ...s TCostItemCode=$p($g(^DHCEQCCode("DHCEQCEquipType",TEquipTypeDR)),"^",3)
    ..s TStatCatDR=$p($g(^DHCEQSnapShot(SnapID,"Equip",EQRowID)),"^",75)
    ..i TStatCatDR'="" s TStatCat=$p($g(^DHCEQCCode("DHCEQCStatCat")),"^",2)
    ..s TOriginalFee=$fn($p($g(^DHCEQSnapShot(SnapID,"Equip",EQRowID)),"^",27),"",2)
    ..s TTransAssetDate=$p($g(^DHCEQSnapShot(SnapID,"Equip",EQRowID)),"^",45)
    ..s TTransAssetDate=##class(web.DHCEQCommon).TransValueToPage(TTransAssetDate,"date") ;Modified by QW20170302日期格式统一调整 原 s TTransAssetDate=$ZD(TTransAssetDate,3)
    ..s TEQRowID=EQRowID
    ..s TEQNo=$p($g(^DHCEQSnapShot(SnapID,"Equip",EQRowID)),"^",71)     //设备编号
    ..s TOldEQNo=$p($g(^DHCEQSnapShot(SnapID,"Equip",EQRowID)),"^",91)
    ..s TEquipName=$p($g(^DHCEQSnapShot(SnapID,"Equip",EQRowID)),"^",1) //设备名称
    ..s TModelDR=$p($g(^DHCEQSnapShot(SnapID,"Equip",EQRowID)),"^",3)       //规格型号
    ..i TModelDR'="" s TModel=$p($g(^DHCEQSnapShot(SnapID,"Equip",EQRowID,"EX")),"^",2)
    ..i TEquipTypeDR=1 s TModel=+TModel //房屋面积
    ..;s TBrandDR=$p($g(^DHCEQSnapShot(SnapID,"Equip",EQRowID)),"^",94)
    ..;i TBrandDR'="" s TBrand=$p($g(^DHCEQCCode("DHCEQCBrand",TBrandDR)),"^",3)
    ..;s TOutLayTypeDR=$p($g(^DHCEQSnapShot(SnapID,"Equip",EQRowID)),"^",95)
    ..;i TOutLayTypeDR'="" s TOutLayType=$p($g(^DHCEQCCode("DHCEQCOutLayType",TOutLayTypeDR)),"^",2)
    ..s TLimitYearsNum=$p($g(^DHCEQSnapShot(SnapID,"Equip",EQRowID)),"^",31)    //使用年限
    ..s TNetFee=$fn($p($g(^DHCEQSnapShot(SnapID,"Equip",EQRowID)),"^",28),"",2)     //净值
    ..s TDepreTotalFee=$fn($p($g(^DHCEQSnapShot(SnapID,"Equip",EQRowID)),"^",35),"",2)  //累计折旧
    ..s TStartDate=$p($g(^DHCEQSnapShot(SnapID,"Equip",EQRowID)),"^",44)            //启用日期
    ..s TStartDate=##class(web.DHCEQCommon).TransValueToPage(TStartDate,"date") ;Modified by QW20170302日期格式统一调整 原 i TStartDate'="" s TStartDate=$ZD(TStartDate,3)
    ..s EQStatus=$p($g(^DHCEQSnapShot(SnapID,"Equip",EQRowID)),"^",38)
    ..i EQStatus=0 s TStatus="新增"
    ..i EQStatus=1 s TStatus="启用"
    ..i EQStatus=2 s TStatus="封存"
    ..s CADRowID=0
    ..f  s CADRowID=$o(^DHCEQCostAllotDetail(0,"SourceID",MDRowID,CADRowID))  q:CADRowID=""  d
    ...s CADLoc=$P($g(^DHCEQCostAllotDetail(CADRowID)),"^",3)
    ...q:(UseLocDR'="")&&(CADLoc'=UseLocDR)
    ...s CADFundsType=$P($g(^DHCEQCostAllotDetail(CADRowID)),"^",7)
    ...s TFundsTypeDR=CADFundsType
    ...q:(FundsTypeDR'="")&&(CADFundsType'=FundsTypeDR)
    ...;i CADLoc'="" s TUseLoc=##Class(web.DHCEQCommon).GetSplitDataByFlag($p($g(^CTLOC(CADLoc)),"^",2),"-")   //modify by jyp 2019-10-18 CTLOC调整
    ...i CADLoc'="" s TUseLoc=##class(web.DHCEQCommon).GetTrakNameByID("dept",CADLoc)   //modify by jyp 2019-10-18 CTLOC调整
    ...s TDepre=$fn($P($g(^DHCEQCostAllotDetail(CADRowID)),"^",5),"",2)
    ...i CADFundsType'="" s TFundsType=$p($g(^DHCEQCCode("DHCEQCFundsType",CADFundsType)),"^",2)
    ...s LTRowID=$o(^DHCEQCCode("DHCEQCLocType",0,"LocType",1,CADLoc,0))
    ...i LTRowID="" s LTRowID=$o(^DHCEQCCode("DHCEQCLocType",0,"LocType",2,CADLoc,0))
    ...i LTRowID'="" s TCostCheckCode=$p($g(^DHCEQCCode("DHCEQCLocType",LTRowID)),"^",5)
    ...d OutputRowGetFundsLocTypeDepre
    
    Quit $$$OK
OutputRowGetFundsLocTypeDepre
    s Data=$lb(TEQRowID,TEQNo,TOldEQNo,TEquipName,TBrand,TModel,TEquipType,TStatCat,TUseLoc,TFundsTypeDR,TFundsType,TOriginalFee,TDepre,TLimitYearsNum,TDepreTotalFee,TNetFee,TStatus,TTransAssetDate,TStartDate,TOutLayType,TCostItemCode,TCostCheckCode)
    Set ^CacheTemp(repid,index)=Data
    Set index=index+1
    quit
ResetVariablesGetFundsLocTypeDepre
    s (TEQRowID,TEQNo,TOldEQNo,TEquipName,TBrand,TModel,TEquipType,TStatCat,TUseLoc,TFundsTypeDR,TFundsType,TOriginalFee,TDepre,TLimitYearsNum,TDepreTotalFee,TNetFee,TStatus,TTransAssetDate,TStartDate,TOutLayType,TCostItemCode,TCostCheckCode)=""
    quit
}

ClassMethod FundsLocTypeDepreFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FundsLocTypeDepreExecute ]
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

Query FundsLocTypeDepre(MonthStr As %String = "", QXType As %String = "", UseLoc As %String = "", UseLocDR As %String = "", EquipType As %String = "", EquipTypeDR As %String = "", FundsType As %String = "", FundsTypeDR As %String = "", CurGroupID As %String = "", CurLocID As %String = "", YearsFlag As %String = "") As %Query(ROWSPEC = "TEQRowID:%String,TEQNo:%String,TOldEQNo:%String,TEquipName:%String,TBrand:%String,TModel:%String,TEquipType:%String,TStatCat:%String,TUseLoc:%String,TFundsTypeDR:%String,TFundsType:%String,TOriginalFee:%String,TDepre:%String,TLimitYearsNum:%String,TDepreTotalFee:%String,TNetFee:%String,TStatus:%String,TTransAssetDate:%String,TStartDate:%String,TOutLayType:%String,TCostItemCode:%String,TCostCheckCode:%String") [ SqlProc ]
{
}

/*****************************************************/
}
