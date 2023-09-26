Import SQLUser

/// 修改：Mozy 2009-10-13
/// 修改方法：GetAccessoryList
/// 描述:查询配件明细列表数据
/// ---------------------------------------------
/// 创建:2009-08-25 党军 DJ0029
/// 描述:设备配件信息维护(新增,修改,删除,查询)
/// 操作表:DHC_EQCAccessory
/// ---------------------------------------------
Class web.DHCEQCAccessory Extends %Library.RegisteredObject [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 100;

Parameter SQLDATEFROM;

Parameter SQLDATETO = "A_EffDateTo";

Parameter SQLCODE = "A_RowID";

Parameter SQLDESCRIPTION = "A_RowID";

Parameter SQLROWID = "A_RowID";

/// 需求：415037	20170801	取消TExtendCode隐藏设置
/// 2014-4-3 11:55:08 BY：GBX
/// 增加单位和生产厂商的DR
/// d ##class(%ResultSet).RunQuery("web.DHCEQCAccessory","GetAccessory","","","","","","","30")
Query GetAccessory(Code As %String = "", Desc As %String = "", ExtendCode As %String = "", TypeDR As %String = "", CatDR As %String = "", CurBPrice As %String = "", CurBPriceTo As %String = "", ShortDesc As %String = "", Model As %String = "", SortFlag As %String = "", CheckPrice As %String = "") As %Query(ROWSPEC = "TRowID:%String, TCode:%String, TDesc:%String, TShortDesc:%String, TModel:%String, TBaseUOM:%String, Hidden:%String,TBillUOM:%String, TStdSPrice:%String, Hidden:%String, Hidden:%String, TCurBPrice:%String, Hidden:%String, Hidden:%String, Hidden:%String, TType:%String, TCat:%String, TCountry:%String, TPlaceOfProduction:%String, Hidden:%String, TCommercialName:%String, Hidden:%String, Hidden:%String, Hidden:%String, Hidden:%String, Hidden:%String, Hidden:%String, Hidden:%String, TManuFactory:%String, Hidden:%String, Hidden:%String, Hidden:%String, Hidden:%String, Hidden:%String, Hidden:%String, Hidden:%String, Hidden:%String, Hidden:%String, Hidden:%String, Hidden:%String, Hidden:%String, Hidden:%String, Hidden:%String, Hidden:%String, Hidden:%String, Hidden:%String, Hidden:%String, Hidden:%String, Hidden:%String, Hidden:%String, Hidden:%String, Hidden:%String, Hidden:%String, Hidden:%String, Hidden:%String, Hidden:%String, Hidden:%String, Hidden:%String, Hidden:%String, Hidden:%String, Hidden:%String, Hidden:%String, Hidden:%String, Hidden:%String, Hidden:%String, Hidden:%String, Hidden:%String, Hidden:%String, TExtendCode:%String, Hidden:%String, Hidden:%String, Hidden:%String, TRemark:%String,TRow:%String,THold1:%String,THold2:%String,Hidden:%String,Hidden:%String,Hidden:%String")
{
}

ClassMethod GetAccessoryExecute(ByRef qHandle As %Binary, Code As %String = "", Desc As %String = "", ExtendCode As %String = "", TypeDR As %String = "", CatDR As %String = "", CurBPrice As %String = "", CurBPriceTo As %String = "", ShortDesc As %String = "", Model As %String = "", SortFlag As %String = "", CheckPrice As %String = "") As %Status
{
	new repid, index, rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s Sort=0
	s TRow=0
	s Job=$j
	k ^DHCEQTemp("GetAccessory",Job)
	s rowid=""
	f  s rowid=$o(^DHCEQCCode("DHCEQCAccessory",rowid),-1)  quit:(rowid="")||(rowid=0)  d
	.s InvalidFlag=$p($g(^DHCEQCCode("DHCEQCAccessory",rowid)),"^",77)
	.q:InvalidFlag="Y"
	.q:(CheckPrice=1)&&($p($g(^DHCEQCCode("DHCEQCAccessory",rowid)),"^",80)'="")	; MZY0029	1340070		2020-05-29	增加配件项价格审核标识处理
	.s TCode = $p($g(^DHCEQCCode("DHCEQCAccessory",rowid)),"^",1)
	.q:(Code'="")&&($ZCONVERT(TCode,"U")'[$ZCONVERT(Code,"U"))
	.s TDesc = $p($g(^DHCEQCCode("DHCEQCAccessory",rowid)),"^",2)
	.// Mozy		2019-10-18
	.q:(Desc'="")&&($ZCONVERT(TDesc,"U")'[$ZCONVERT(Desc,"U"))
	.s TExtendCode = $p($g(^DHCEQCCode("DHCEQCAccessory",rowid)),"^",66)
	.q:(ExtendCode'="")&&($ZCONVERT(TExtendCode,"U")'[$ZCONVERT(ExtendCode,"U"))
	.s TType = $p($g(^DHCEQCCode("DHCEQCAccessory",rowid)),"^",14)
	.// Mozy	2016-10-21
	.Quit:##Class(web.DHCEQACommon).AccessoryTypeIsIn(TType)
	.q:(TypeDR'="")&&(TType'=TypeDR)
	.i TType'="" s TType=$p($g(^DHCEQCCode("DHCEQCAccessoryType",TType)),"^",2)
	.s TCat = $p($g(^DHCEQCCode("DHCEQCAccessory",rowid)),"^",15)
	.q:(CatDR'="")&&(TCat'=CatDR)
	.i TCat'="" s TCat=$p($g(^DHCEQCCode("DHCEQCAccessoryCat",TCat)),"^",3)
	.s TCurBPrice = +$p($g(^DHCEQCCode("DHCEQCAccessory",rowid)),"^",10)
	.q:(CurBPrice'="")&&(TCurBPrice<CurBPrice)
	.q:(CurBPriceTo'="")&&(TCurBPrice>CurBPriceTo)			//Add By DJ 2016-12-05
	.i TCurBPrice'="" s TCurBPrice=##Class(web.DHCEQCommon).FormatNumber(TCurBPrice,"",2)	// Mozy		2019-10-18
	.;q:(CurBPrice'="")&&((TCurBPrice="")||(TCurBPrice<##Class(web.DHCEQCommon).FormatNumber(CurBPrice,"",4)))
	.;q:(CurBPriceTo'="")&&((TCurBPrice="")||(TCurBPrice<##Class(web.DHCEQCommon).FormatNumber(CurBPriceTo,"",4)))
	.s TShortDesc = $p($g(^DHCEQCCode("DHCEQCAccessory",rowid)),"^",3)
	.q:(ShortDesc'="")&&($ZCONVERT(TShortDesc,"U")'[$ZCONVERT(ShortDesc,"U"))
	.s TModel = $p($g(^DHCEQCCode("DHCEQCAccessory",rowid)),"^",4)
	.q:(Model'="")&&(TModel'[Model)
	.i TModel=""  s TModel="/"    ;add by czf 2011-11-17 需求号：281647
	.If SortFlag="" Do
	..Set Sort=Sort+1
	..Set ^DHCEQTemp("GetAccessory",Job,Sort,0,rowid)=""	;默认配件项倒序输出
	.e  d
	..Set ^DHCEQTemp("GetAccessory",Job,TShortDesc,TModel,rowid)=""		;按名称和规格排序输出
	
	//// Mozy	输出
	Set desc=""
	f  s desc=$o(^DHCEQTemp("GetAccessory",Job,desc)) quit:(desc="")  d
	.Set model=""
	.f  s model=$o(^DHCEQTemp("GetAccessory",Job,desc,model),-1) quit:(model="")  d
	..Set rowid=""
	..f  s rowid=$o(^DHCEQTemp("GetAccessory",Job,desc,model,rowid)) quit:(rowid="")  d
	...d ResetVariablesGetGetAccessory
	...s TRowID = rowid	//rowid
	...s InvalidFlag=$p($g(^DHCEQCCode("DHCEQCAccessory",rowid)),"^",77)
	...s TCode = $p($g(^DHCEQCCode("DHCEQCAccessory",rowid)),"^",1)
	...s TDesc = $p($g(^DHCEQCCode("DHCEQCAccessory",rowid)),"^",2)
	...s TExtendCode = $p($g(^DHCEQCCode("DHCEQCAccessory",rowid)),"^",66)
	...s TType = $p($g(^DHCEQCCode("DHCEQCAccessory",rowid)),"^",14)
	...i TType'="" s TType=$p($g(^DHCEQCCode("DHCEQCAccessoryType",TType)),"^",2)
	...s TCat = $p($g(^DHCEQCCode("DHCEQCAccessory",rowid)),"^",15)
	...i TCat'="" s TCat=$p($g(^DHCEQCCode("DHCEQCAccessoryCat",TCat)),"^",3)
	...s TCurBPrice = $p($g(^DHCEQCCode("DHCEQCAccessory",rowid)),"^",10)
	...i TCurBPrice'="" s TCurBPrice=##Class(web.DHCEQCommon).FormatNumber(TCurBPrice,"",4)
	...s TShortDesc = $p($g(^DHCEQCCode("DHCEQCAccessory",rowid)),"^",3)
	...s TModel = $p($g(^DHCEQCCode("DHCEQCAccessory",rowid)),"^",4)
	...s TBaseUOMDR = $p($g(^DHCEQCCode("DHCEQCAccessory",rowid)),"^",5)
	...i TBaseUOMDR'="" s TBaseUOM=##Class(web.DHCEQCommon).GetTrakNameByID("uom",TBaseUOMDR)
	...s TBillUOM = $p($g(^DHCEQCCode("DHCEQCAccessory",rowid)),"^",6)
	...i TBillUOM'="" s TBillUOM=##Class(web.DHCEQCommon).GetTrakNameByID("uom",TBillUOM)
	...s TStdSPrice = $p($g(^DHCEQCCode("DHCEQCAccessory",rowid)),"^",7)
	...i TStdSPrice'="" s TStdSPrice=##Class(web.DHCEQCommon).FormatNumber(TStdSPrice,"",4)
	...s TMinSPrice = $p($g(^DHCEQCCode("DHCEQCAccessory",rowid)),"^",8)
	...i TMinSPrice'="" s TMinSPrice=##Class(web.DHCEQCommon).FormatNumber(TMinSPrice,"",4)
	...s TMaxSPrice = $p($g(^DHCEQCCode("DHCEQCAccessory",rowid)),"^",9)
	...i TMaxSPrice'="" s TMaxSPrice=##Class(web.DHCEQCommon).FormatNumber(TMaxSPrice,"",4)
	...s TMinBPrice = $p($g(^DHCEQCCode("DHCEQCAccessory",rowid)),"^",11)
	...i TMinBPrice'="" s TMinBPrice=##Class(web.DHCEQCommon).FormatNumber(TMinBPrice,"",4)
	...s TMaxBPrice = $p($g(^DHCEQCCode("DHCEQCAccessory",rowid)),"^",12)
	...i TMaxBPrice'="" s TMaxBPrice=##Class(web.DHCEQCommon).FormatNumber(TMaxBPrice,"",4)
	...s TFeeRules = $p($g(^DHCEQCCode("DHCEQCAccessory",rowid)),"^",13)
	...i TFeeRules'="" s TFeeRules=$p($g(^DHCEQCCode("DHCEQCFeeRules",TFeeRules)),"^",2)
	...s TCountry = $p($g(^DHCEQCCode("DHCEQCAccessory",rowid)),"^",16)
	...i TCountry'="" s TCountry=##Class(web.DHCEQCommon).GetTrakNameByID("cou",TCountry)
	...s TPlaceOfProduction = $p($g(^DHCEQCCode("DHCEQCAccessory",rowid)),"^",17)
	...s TGeneralName = $p($g(^DHCEQCCode("DHCEQCAccessory",rowid)),"^",18)
	...s TCommercialName = $p($g(^DHCEQCCode("DHCEQCAccessory",rowid)),"^",19)
	...s TBrand = $p($g(^DHCEQCCode("DHCEQCAccessory",rowid)),"^",20)
	...s TBrandCertificate = $p($g(^DHCEQCCode("DHCEQCAccessory",rowid)),"^",21)
	...s TRegisterNo = $p($g(^DHCEQCCode("DHCEQCAccessory",rowid)),"^",22)
	...s TCertificateNo = $p($g(^DHCEQCCode("DHCEQCAccessory",rowid)),"^",23)
	...s TProductionLicence = $p($g(^DHCEQCCode("DHCEQCAccessory",rowid)),"^",24)
	...s TImportNo = $p($g(^DHCEQCCode("DHCEQCAccessory",rowid)),"^",25)
	...s TImportRegisterNo = $p($g(^DHCEQCCode("DHCEQCAccessory",rowid)),"^",26)
	...s TManuFactoryDR = $p($g(^DHCEQCCode("DHCEQCAccessory",rowid)),"^",27)
	...i TManuFactoryDR'="" s TManuFactory=##Class(web.DHCEQCommon).GetTrakNameByID("manufacturer",TManuFactoryDR) //CZF0093
	...s TPakageType = $p($g(^DHCEQCCode("DHCEQCAccessory",rowid)),"^",28)
	...s TWastageRate = ##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQCCode("DHCEQCAccessory",rowid)),"^",29),"",4)
	...s TSolitudeFlag = $p($g(^DHCEQCCode("DHCEQCAccessory",rowid)),"^",30)
	...s TBarCode = $p($g(^DHCEQCCode("DHCEQCAccessory",rowid)),"^",31)
	...s TExpiredFlag = $p($g(^DHCEQCCode("DHCEQCAccessory",rowid)),"^",32)
	...s TExpiredDays = $p($g(^DHCEQCCode("DHCEQCAccessory",rowid)),"^",33)
	...s TWarningDays = $p($g(^DHCEQCCode("DHCEQCAccessory",rowid)),"^",34)
	...s TSerialFlag = $p($g(^DHCEQCCode("DHCEQCAccessory",rowid)),"^",35)
	...s TMinOrderQty = $p($g(^DHCEQCCode("DHCEQCAccessory",rowid)),"^",36)
	...s TMaxOrderQty = $p($g(^DHCEQCCode("DHCEQCAccessory",rowid)),"^",37)
	...s TABCType = $p($g(^DHCEQCCode("DHCEQCAccessory",rowid)),"^",38)
	...s TOverStock = $p($g(^DHCEQCCode("DHCEQCAccessory",rowid)),"^",39)
	...s TSelfMakeFlag = $p($g(^DHCEQCCode("DHCEQCAccessory",rowid)),"^",40)
	...s TSaleFlag = $p($g(^DHCEQCCode("DHCEQCAccessory",rowid)),"^",41)
	...s TVirtualFlag = $p($g(^DHCEQCCode("DHCEQCAccessory",rowid)),"^",42)
	...s TPurchaseFlag = $p($g(^DHCEQCCode("DHCEQCAccessory",rowid)),"^",43)
	...s TFixPreDays = $p($g(^DHCEQCCode("DHCEQCAccessory",rowid)),"^",44)
	...s TExpSaleRate = ##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQCCode("DHCEQCAccessory",rowid)),"^",45),"",4)
	...s TWorthQty = $p($g(^DHCEQCCode("DHCEQCAccessory",rowid)),"^",46)
	...s TSafeQty = $p($g(^DHCEQCCode("DHCEQCAccessory",rowid)),"^",47)
	...s TMinQty = $p($g(^DHCEQCCode("DHCEQCAccessory",rowid)),"^",48)
	...s TMaxQty = $p($g(^DHCEQCCode("DHCEQCAccessory",rowid)),"^",49)
	...s TStockEnabledFlag = $p($g(^DHCEQCCode("DHCEQCAccessory",rowid)),"^",50)
	...s TVolume = $p($g(^DHCEQCCode("DHCEQCAccessory",rowid)),"^",51)
	...s TVolumeUOM = $p($g(^DHCEQCCode("DHCEQCAccessory",rowid)),"^",52)
	...i TVolumeUOM'="" s TVolumeUOM=##Class(web.DHCEQCommon).GetTrakNameByID("uom",TVolumeUOM)
	...s TWeight = $p($g(^DHCEQCCode("DHCEQCAccessory",rowid)),"^",53)
	...s TWeightUOM = $p($g(^DHCEQCCode("DHCEQCAccessory",rowid)),"^",54)
	...i TWeightUOM'="" s TWeightUOM=##Class(web.DHCEQCommon).GetTrakNameByID("uom",TWeightUOM)
	...s TRequireNote = $p($g(^DHCEQCCode("DHCEQCAccessory",rowid)),"^",55)
	...s TShowMessage = $p($g(^DHCEQCCode("DHCEQCAccessory",rowid)),"^",56)
	...s TNeedTest = $p($g(^DHCEQCCode("DHCEQCAccessory",rowid)),"^",57)
	...s TAllowOrderNoStock = $p($g(^DHCEQCCode("DHCEQCAccessory",rowid)),"^",58)
	...s TEffDate = $p($g(^DHCEQCCode("DHCEQCAccessory",rowid)),"^",59)
	...;i TEffDate'="" s TEffDate = $ZD(TEffDate,4)
	...;日期格式统一调整
	...s TEffDate=##Class(web.DHCEQCommon).TransValueFromPage(TEffDate,"date")
	...s TEffTime = $p($g(^DHCEQCCode("DHCEQCAccessory",rowid)),"^",60)
	...;i TEffTime'="" s TEffTime = $ZT(TEffTime,4)
	...;日期格式统一调整
	...s TEffTime=##Class(web.DHCEQCommon).TransValueFromPage(TEffTime,"time")
	...s TEffDateTo = $p($g(^DHCEQCCode("DHCEQCAccessory",rowid)),"^",61)
	...;i TEffDateTo'="" s TEffDateTo=$ZD(TEffDateTo,4)
	...;日期格式统一调整
	...s TEffDateTo=##Class(web.DHCEQCommon).TransValueFromPage(TEffDateTo,"date")
	...s TEffTimeTo = $p($g(^DHCEQCCode("DHCEQCAccessory",rowid)),"^",62)
	...;i TEffTimeTo'="" s TEffTimeTo=$ZT(TEffTimeTo,4)
	...;日期格式统一调整
	...s TEffTimeTo=##Class(web.DHCEQCommon).TransValueFromPage(TEffTimeTo,"time")
	...s TVisibleInOrderList = $p($g(^DHCEQCCode("DHCEQCAccessory",rowid)),"^",63)
	...s TServMaterial = $p($g(^DHCEQCCode("DHCEQCAccessory",rowid)),"^",64)
	...s TVersion = $p($g(^DHCEQCCode("DHCEQCAccessory",rowid)),"^",65)	
	...s TReturnableFlag = $p($g(^DHCEQCCode("DHCEQCAccessory",rowid)),"^",67)
	...s TReturnInspectRequirement = $p($g(^DHCEQCCode("DHCEQCAccessory",rowid)),"^",68)
	...s TPickingRule = $p($g(^DHCEQCCode("DHCEQCAccessory",rowid)),"^",69)
	...s TRemark = $p($g(^DHCEQCCode("DHCEQCAccessory",rowid)),"^",70)
	...s THold1 = $p($g(^DHCEQCCode("DHCEQCAccessory",rowid)),"^",78)
	...s THold2 = $p($g(^DHCEQCCode("DHCEQCAccessory",rowid)),"^",79)
	...s THold3 = $p($g(^DHCEQCCode("DHCEQCAccessory",rowid)),"^",80)
	...s THold4 = $p($g(^DHCEQCCode("DHCEQCAccessory",rowid)),"^",81)
	...s THold5 = $p($g(^DHCEQCCode("DHCEQCAccessory",rowid)),"^",82)
	...d OutputRowGetGetAccessory
	k ^DHCEQTemp("GetAccessory",Job)
	Quit $$$OK
OutputRowGetGetAccessory
	s TRow=TRow+1
	s Data=$lb(TRowID,TCode,TDesc,TShortDesc,TModel,TBaseUOM,TBaseUOMDR,TBillUOM,TStdSPrice,TMinSPrice,TMaxSPrice,TCurBPrice,TMinBPrice,TMaxBPrice,TFeeRules,TType,TCat,TCountry,TPlaceOfProduction,TGeneralName,TCommercialName,TBrand,TBrandCertificate,TRegisterNo,TCertificateNo,TProductionLicence,TImportNo,TImportRegisterNo,TManuFactory,TManuFactoryDR,TPakageType,TWastageRate,TSolitudeFlag,TBarCode,TExpiredFlag,TExpiredDays,TWarningDays,TSerialFlag,TMinOrderQty,TMaxOrderQty,TABCType,TOverStock,TSelfMakeFlag,TSaleFlag,TVirtualFlag,TPurchaseFlag,TFixPreDays,TExpSaleRate,TWorthQty,TSafeQty,TMinQty,TMaxQty,TStockEnabledFlag,TVolume,TVolumeUOM,TWeight,TWeightUOM,TRequireNote,TShowMessage,TNeedTest,TAllowOrderNoStock,TEffDate,TEffTime,TEffDateTo,TEffTimeTo,TVisibleInOrderList,TServMaterial,TVersion,TExtendCode,TReturnableFlag,TReturnInspectRequirement,TPickingRule,TRemark,TRow,THold1,THold2,THold3,THold4,THold5)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetGetAccessory
	s (TRowID,TCode,TDesc,TShortDesc,TModel,TBaseUOM,TBaseUOMDR,TBillUOM,TStdSPrice,TMinSPrice,TMaxSPrice,TCurBPrice,TMinBPrice,TMaxBPrice,TFeeRules,TType,TCat,TCountry,TPlaceOfProduction,TGeneralName,TCommercialName,TBrand,TBrandCertificate,TRegisterNo,TCertificateNo,TProductionLicence,TImportNo,TImportRegisterNo,TManuFactory,TManuFactoryDR,TPakageType,TWastageRate,TSolitudeFlag,TBarCode,TExpiredFlag,TExpiredDays,TWarningDays,TSerialFlag,TMinOrderQty,TMaxOrderQty,TABCType,TOverStock,TSelfMakeFlag,TSaleFlag,TVirtualFlag,TPurchaseFlag,TFixPreDays,TExpSaleRate,TWorthQty,TSafeQty,TMinQty,TMaxQty,TStockEnabledFlag,TVolume,TVolumeUOM,TWeight,TWeightUOM,TRequireNote,TShowMessage,TNeedTest,TAllowOrderNoStock,TEffDate,TEffTime,TEffDateTo,TEffTimeTo,TVisibleInOrderList,TServMaterial,TVersion,TExtendCode,TReturnableFlag,TReturnInspectRequirement,TPickingRule,TRemark,THold1,THold2,THold3,THold4,THold5)=""
	quit
}

ClassMethod GetAccessoryFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAccessoryExecute ]
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

ClassMethod GetAccessoryClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAccessoryExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod SaveData(val As %Library.String = "", isDel As %Library.String = "")
{
 k PLIST,rowid
 s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
 s Date=+$H
 s Time=$p($H,",",2)
 s rowid=$p(val,"^",1)
 i (+isDel=1)
 {
 	//删除按钮操作,更新InvalidFlag标识.
 	s PLIST(78)="Y"
 	&SQL(Update SQLUSER.DHC_EQCAccessory Values :PLIST() where A_RowID = :rowid) 
 	if SQLCODE  q SQLCODE
 	q rowid
 }
 s PLIST(2) = $p(val,"^",2) //编码
 s Code = PLIST(2)
 s PLIST(3) = $p(val,"^",3) //名称
 s Desc = PLIST(3)
 s PLIST(4) = $p(val,"^",4) //简称
 s PLIST(5) = $p(val,"^",5) //规格
 s Model = PLIST(5)
 s PLIST(6) = $p(val,"^",6) //基本单位
 s PLIST(7) = $p(val,"^",7)
 s PLIST(8) = $p(val,"^",8)
 s PLIST(9) = ##Class(web.DHCEQCommon).FormatNumber($p(val,"^",9),"",4)
 s PLIST(10) = ##Class(web.DHCEQCommon).FormatNumber($p(val,"^",10),"",4)
 s PLIST(11) = ##Class(web.DHCEQCommon).FormatNumber($p(val,"^",11),"",4)
 s CurBPrice=PLIST(11)
 s PLIST(12) = ##Class(web.DHCEQCommon).FormatNumber($p(val,"^",12),"",4)
 s PLIST(13) = ##Class(web.DHCEQCommon).FormatNumber($p(val,"^",13),"",4)
 s PLIST(14) = $p(val,"^",14)
 s PLIST(15) = $p(val,"^",15)
 s PLIST(16) = $p(val,"^",16)
 s PLIST(17) = $p(val,"^",17)
 s PLIST(18) = $p(val,"^",18)
 s PLIST(19) = $p(val,"^",19)
 s PLIST(20) = $p(val,"^",20)
 s PLIST(21) = $p(val,"^",21)
 s PLIST(22) = $p(val,"^",22)
 s PLIST(23) = $p(val,"^",23)
 s PLIST(24) = $p(val,"^",24)
 s PLIST(25) = $p(val,"^",25)
 s PLIST(26) = $p(val,"^",26)
 s PLIST(27) = $p(val,"^",27)
 s PLIST(28) = $p(val,"^",28)
 s ManuFactoryDR=$p(val,"^",28)
 s PLIST(29) = $p(val,"^",29)
 s PLIST(30) = $p(val,"^",30)
 i $p(val,"^",31)'="" s PLIST(31) = ##Class(web.DHCEQCommon).TransValueFromPage($p(val,"^",31),"bool") ;
 s PLIST(32) = $p(val,"^",32)
 i $p(val,"^",33)'="" s PLIST(33) = ##Class(web.DHCEQCommon).TransValueFromPage($p(val,"^",33),"bool") ;
 s PLIST(34) = $p(val,"^",34)
 s PLIST(35) = $p(val,"^",35)
 i $p(val,"^",36)'="" s PLIST(36) = ##Class(web.DHCEQCommon).TransValueFromPage($p(val,"^",36),"bool") ;
 s PLIST(37) = ##Class(web.DHCEQCommon).FormatNumber($p(val,"^",37),"",4)
 s PLIST(38) = ##Class(web.DHCEQCommon).FormatNumber($p(val,"^",38),"",4)
 s PLIST(39) = $p(val,"^",39)
 s PLIST(40) = ##Class(web.DHCEQCommon).FormatNumber($p(val,"^",40),"",4)
 i $p(val,"^",41)'="" s PLIST(41) = ##Class(web.DHCEQCommon).TransValueFromPage($p(val,"^",41),"bool") ;
 i $p(val,"^",42)'="" s PLIST(42) = ##Class(web.DHCEQCommon).TransValueFromPage($p(val,"^",42),"bool") ;
 i $p(val,"^",43)'="" s PLIST(43) = ##Class(web.DHCEQCommon).TransValueFromPage($p(val,"^",43),"bool") ;
 i $p(val,"^",44)'="" s PLIST(44) = ##Class(web.DHCEQCommon).TransValueFromPage($p(val,"^",44),"bool") ;
 s PLIST(45) = $p(val,"^",45)
 s PLIST(46) = $p(val,"^",46)
 s PLIST(47) = ##Class(web.DHCEQCommon).FormatNumber($p(val,"^",47),"",4)
 s PLIST(48) = ##Class(web.DHCEQCommon).FormatNumber($p(val,"^",48),"",4)
 s PLIST(49) = ##Class(web.DHCEQCommon).FormatNumber($p(val,"^",49),"",4)
 s PLIST(50) = ##Class(web.DHCEQCommon).FormatNumber($p(val,"^",50),"",4)
 i $p(val,"^",51)'="" s PLIST(51) = ##Class(web.DHCEQCommon).TransValueFromPage($p(val,"^",51),"bool") ;
 s PLIST(52) = ##Class(web.DHCEQCommon).FormatNumber($p(val,"^",52),"",4)
 s PLIST(53) = $p(val,"^",53)
 s PLIST(54) = ##Class(web.DHCEQCommon).FormatNumber($p(val,"^",54),"",4)
 s PLIST(55) = $p(val,"^",55)
 s PLIST(56) = $p(val,"^",56)
 s PLIST(57) = $p(val,"^",57)
 i $p(val,"^",58)'="" s PLIST(58) = ##Class(web.DHCEQCommon).TransValueFromPage($p(val,"^",58),"bool") ;
 i $p(val,"^",59)'="" s PLIST(59) = ##Class(web.DHCEQCommon).TransValueFromPage($p(val,"^",59),"bool") ;
 i $p(val,"^",60)'="" s PLIST(60) = ##Class(web.DHCEQCommon).TransValueFromPage($p(val,"^",60),"date") ;
 ;i $p(val,"^",61)'="" s PLIST(61) = $ZTH($p(val,"^",61),4) ;
 ;日期格式统一调整
 s PLIST(61) = ##Class(web.DHCEQCommon).TransValueFromPage($p(val,"^",61),"time") ;
 i $p(val,"^",62)'="" s PLIST(62) = ##Class(web.DHCEQCommon).TransValueFromPage($p(val,"^",62),"date") ;
 ;i $p(val,"^",63)'="" s PLIST(63) = $ZTH($p(val,"^",63),4) ;
 ;日期格式统一调整
 s PLIST(63) = ##Class(web.DHCEQCommon).TransValueFromPage($p(val,"^",63),"time") ;
 i $p(val,"^",64)'="" s PLIST(64) = ##Class(web.DHCEQCommon).TransValueFromPage($p(val,"^",64),"bool") ;
 s PLIST(65) = $p(val,"^",65)
 s PLIST(66) = $p(val,"^",66)
 s PLIST(67) = $ZCONVERT($p(val,"^",67),"U")
 i $p(val,"^",68)'="" s PLIST(68) = ##Class(web.DHCEQCommon).TransValueFromPage($p(val,"^",68),"bool") ;
 s PLIST(69) = $p(val,"^",69)
 s PLIST(70) = $p(val,"^",70)
 s PLIST(71) = $p(val,"^",71)
 i $p(val,"^",72)'="" s PLIST(89) = ##Class(web.DHCEQCommon).TransValueFromPage($p(val,"^",72),"bool") ;
 Set PLIST(79) = $Piece(val,"^",73)		;Hold1		账页
 Set PLIST(80) = $Piece(val,"^",74)		;Hold2		货位
 ;Set PLIST(81) = $Piece(val,"^",75)		;Hold3	MZY0029	1340070		2020-05-29
 Set PLIST(82) = $Piece(val,"^",76)		;Hold4
 Set PLIST(83) = $Piece(val,"^",77)		;Hold5
 Set PLIST(84) = $Piece(val,"^",78)		;Hold6
 Set PLIST(85) = $Piece(val,"^",79)		;Hold7
 Set PLIST(86) = $Piece(val,"^",80)		;Hold8
 Set PLIST(87) = $Piece(val,"^",81)		;Hold9
 Set PLIST(88) = $Piece(val,"^",82)		;Hold10
 Set AutoSaveProvider = ##Class(web.DHCEQCommon).TransValueFromPage($p(val,"^",83),"bool")
 
 i (rowid="")  //新增按钮操作
 {
	 //检测当前记录是否已经存在
	 s PLIST(72)=User
	 s PLIST(73)=Date
	 s PLIST(74)=Time
	 s PLIST(78)="N"
	 &SQL(select A_RowID into :RowidFind from DHC_EQCAccessory where A_Code=:Code and A_Desc=:Desc and A_Model=:Model and A_CurBPrice=:CurBPrice and A_ManuFactoryDR=:ManuFactoryDR and A_InvalidFlag='N')
	 i (RowidFind="") //当前记录为新记录,否则已经存在
	 {
		 &SQL(Insert Into SQLUSER.DHC_EQCAccessory Values :PLIST())
         //modified by ZY20230328 bug:3372930
         Set ID=$g(%ROWID)
     }
     else
     {
         q -1
	 }
 }
 else  //更新按钮操作
 {
	 s PLIST(75)=User
	 s PLIST(76)=Date
	 s PLIST(77)=Time
	 &SQL(select A_RowID into :RowidFind from DHC_EQCAccessory where A_Code=:Code and A_Desc=:Desc and A_Model=:Model and A_CurBPrice=:CurBPrice and A_ManuFactoryDR=:ManuFactoryDR and A_InvalidFlag='N')
	 i (RowidFind="")
	 {
		 &SQL(Update SQLUSER.DHC_EQCAccessory Values :PLIST() where A_RowID = :rowid)
         //modified by ZY20230328 bug:3372930
         Set ID=rowid
	 }
	 else
	 {
		 i (RowidFind=rowid)
		 {
			 &SQL(Update SQLUSER.DHC_EQCAccessory Values :PLIST() where A_RowID = :rowid) 	 
             //modified by ZY20230328 bug:3372930  
             Set ID=rowid
		 }
		 else
		 {
             q -1   //modified by ZY20230328 bug:3372930
		 }
	 }
 }
 if SQLCODE  q SQLCODE
 //modified by ZY20230328 bug:3372930
 //Set ID=$g(%ROWID)
 
 //// 自动把生产厂商生成供应商
 If (AutoSaveProvider="Y")&&($p(val,"^",28)'="")
 {
	 //modified by CZF0093 begin
	 s ManuFactory=##Class(web.DHCEQCommon).GetTrakNameByID("manufacturer",$p(val,"^",28)) //$p($g(^DHCEQCCode("DHCEQCManufacturer",$p(val,"^",28))),"^",1)
	 s MFCode=##Class(web.DHCEQCommon).GetTrakNameByID("manufacturercode",$p(val,"^",28)) //$p($g(^DHCEQCCode("DHCEQCManufacturer",$p(val,"^",28))),"^",2)
	 &SQL(select V_RowID into :tmpid from DHC_EQCVendor where V_Name=:ManuFactory and V_Hold3='2')
 	 i (tmpid="")
 	 {
	 	 &SQL(Insert Into SQLUSER.DHC_EQCVendor (V_Code, V_Name, V_ShName, V_InvalidFlag, V_Remark,V_Hold3) Values (:MFCode,:ManuFactory,:MFCode,'N','来自配件项自动生成.','2'))
	 } 
	 else
	 {
		 &SQL(Update SQLUSER.DHC_EQCVendor Set V_InvalidFlag='N', V_ShName=:MFCode, V_Remark='来自配件项自动生成.' where V_RowID = :tmpid) 	 
	 }
	 //modified by CZF0093 end
 }
 q ID
}

/// w ##class(web.DHCEQCAccessory).GetDocByID(1)
ClassMethod GetDocByID(rowid As %Library.String = "")
{
	new result,resultex
	s (result,resultex)=""
	s result= ^DHCEQCCode("DHCEQCAccessory",rowid)
	s resultex=rowid
	s resultex=resultex_"^"
	i $p(result,"^", 5)'="" d
	.s resultex=resultex_##Class(web.DHCEQCommon).GetTrakNameByID("uom",$p(result,"^",5))
	s resultex=resultex_"^"
	i $p(result,"^", 6)'="" d
	.s resultex=resultex_##Class(web.DHCEQCommon).GetTrakNameByID("uom",$p(result,"^",6))
	i $p(result,"^", 10)'="" d                                                     ;add by kdf 2017-11-14 需求号：467824
	.s $p(result,"^", 10)=##Class(web.DHCEQCommon).FormatNumber($p(result,"^", 10))
	s resultex=resultex_"^"
	i $p(result,"^", 13)'="" d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCFeeRules",$p(result,"^",13))),"^",2)
	s resultex=resultex_"^"
	i $p(result,"^", 14)'="" d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCAccessoryType",$p(result,"^",14))),"^",2)
	s resultex=resultex_"^"
	i $p(result,"^", 15)'="" d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCAccessoryCat",$p(result,"^",15))),"^",3)
	s resultex=resultex_"^"
	i $p(result,"^", 16)'="" d
	.s resultex=resultex_##Class(web.DHCEQCommon).GetTrakNameByID("cou",$p(result,"^",16))
	s resultex=resultex_"^"
	i $p(result,"^", 27)'="" d
	.s resultex=resultex_##Class(web.DHCEQCommon).GetTrakNameByID("manufacturer",$p(result,"^", 27))
	s resultex=resultex_"^"
	i $p(result,"^", 52)'="" d
	.s resultex=resultex_##Class(web.DHCEQCommon).GetTrakNameByID("uom",$p(result,"^",52))
	s resultex=resultex_"^"
	i $p(result,"^", 54)'="" d
	.s resultex=resultex_##Class(web.DHCEQCommon).GetTrakNameByID("uom",$p(result,"^",54))
	s resultex=resultex_"^"
	i $p(result,"^", 60)'="" d
	.;s resultex=resultex_$ZT($p(result,"^", 60),4)
	.;日期格式统一调整
    .s resultex=resultex_##Class(web.DHCEQCommon).TransValueFromPage($p(result,"^", 60),"time") ;
	s resultex=resultex_"^"
	i $p(result,"^", 62)'="" d
	.;s resultex=resultex_$ZT($p(result,"^", 62),4)
	.;日期格式统一调整
    .s resultex=resultex_##Class(web.DHCEQCommon).TransValueFromPage($p(result,"^", 62),"time") ;
	s resultex=resultex_"^"_##class(web.DHCEQCommon).TransValueToPage($p(result,"^",59),"date")
	s resultex=resultex_"^"_##class(web.DHCEQCommon).TransValueToPage($p(result,"^",61),"date")
	s resultex=resultex_"^"_##class(web.DHCEQCommon).TransValueToPage($p(result,"^",30),"bool")
	s resultex=resultex_"^"_##class(web.DHCEQCommon).TransValueToPage($p(result,"^",32),"bool")
	s resultex=resultex_"^"_##class(web.DHCEQCommon).TransValueToPage($p(result,"^",35),"bool")
	s resultex=resultex_"^"_##class(web.DHCEQCommon).TransValueToPage($p(result,"^",40),"bool")
	s resultex=resultex_"^"_##class(web.DHCEQCommon).TransValueToPage($p(result,"^",41),"bool")
	s resultex=resultex_"^"_##class(web.DHCEQCommon).TransValueToPage($p(result,"^",42),"bool")
	s resultex=resultex_"^"_##class(web.DHCEQCommon).TransValueToPage($p(result,"^",43),"bool")
	s resultex=resultex_"^"_##class(web.DHCEQCommon).TransValueToPage($p(result,"^",50),"bool")
	s resultex=resultex_"^"_##class(web.DHCEQCommon).TransValueToPage($p(result,"^",57),"bool")
	s resultex=resultex_"^"_##class(web.DHCEQCommon).TransValueToPage($p(result,"^",58),"bool")
	s resultex=resultex_"^"_##class(web.DHCEQCommon).TransValueToPage($p(result,"^",63),"bool")
	s resultex=resultex_"^"_##class(web.DHCEQCommon).TransValueToPage($p(result,"^",67),"bool")
	s resultex=resultex_"^"_##class(web.DHCEQCommon).TransValueToPage($p(result,"^",88),"bool")
	i $p(result,"^", 80)'="" s $p(result,"^", 80)="已审核"		;MZY0029	1340070		2020-05-29
	s result=result_"^"_resultex
	s result=##class(web.DHCEQCommon).Replace(result,$C(13,10),"\n") //回车符转换为"\n"
	q result
}

/******************************************************************************/
ClassMethod GetFeeRulesClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetFeeRulesExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod GetFeeRulesExecute(ByRef qHandle As %Binary, code As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
	s rowid=0
	f  s rowid=$o(^DHCEQCCode("DHCEQCFeeRules",rowid)) q:rowid=""  d
	.s Desc=$p(^DHCEQCCode("DHCEQCFeeRules",rowid),"^",2)
	.q:Desc'[code
	.s rowid0=rowid
 	.Do OutputRowGetFeeRules	 	
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
    
OutputRowGetFeeRules
	set Data=$lb(Desc,rowid0)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetFeeRulesFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetFeeRulesExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

Query GetFeeRules(code As %String) As %Query(ROWSPEC = "FR_Desc:%String,FR_RowID:%String")
{
}

/// MZY0081	1970747		2021-06-30	调整输出列名称
Query GetAccessoryCat(desc As %Library.String = "") As %Query(ROWSPEC = "Desc:%String:描述,HIDDEN:%String,Code:%String:编码")
{
}

ClassMethod GetAccessoryCatExecute(ByRef qHandle As %Binary, desc As %Library.String = "") As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
	s rowid=""
	f  s rowid=$o(^DHCEQCCode("DHCEQCAccessoryCat",rowid),-1) q:rowid=""  d
	.q:$p(^DHCEQCCode("DHCEQCAccessoryCat",rowid),"^",5)'="N"
	.s TCode=$p(^DHCEQCCode("DHCEQCAccessoryCat",rowid),"^",2)
	.s TDesc=$p(^DHCEQCCode("DHCEQCAccessoryCat",rowid),"^",3)
	.;q:(desc'="")&&(($ZCONVERT(TCode ,"U")'[$ZCONVERT(desc,"U"))&&($ZCONVERT(TDesc,"U")'[$ZCONVERT(desc,"U")))
	.s TRowid=rowid
 	.Do OutputRowGetAccessoryCat	 	
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
    
OutputRowGetAccessoryCat
	set Data=$lb(TDesc,TRowid,TCode)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetAccessoryCatFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAccessoryCatExecute ]
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
 	{				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	Set qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetAccessoryCatClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAccessoryCatExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/*******************************************************************************/
/// 修改：Mozy 2009-10-13
/// 修改方法：GetAccessoryList
/// 描述:查询配件明细列表数据
/// d ##class(%ResultSet).RunQuery("web.DHCEQCAccessory","GetAccessoryList","")
Query GetAccessoryList(ShortDesc As %String = "", TypeDR As %String = "") As %Query(ROWSPEC = "Hidden:%String,Hidden:%String,TDesc:%String,TShortDesc:%String,TModel:%String,Hidden:%String,Hidden:%String,TManuFactory:%String,Hidden:%String,Hidden:%String,TBaseUOM:%String,Hidden:%String,TType:%String")
{
}

ClassMethod GetAccessoryListExecute(ByRef qHandle As %Binary, ShortDesc As %String = "", TypeDR As %String = "") As %Status
{
	New repid, index,rowid
	Set repid=$Increment(^CacheTemp)
 	Set qHandle=$ListBuild(0,repid,0)
	Set index=1
	Set rowid=0
	Set ShortDesc=$ZCONVERT(ShortDesc ,"U")

	Do BuildDataGetAccessoryList
	Quit $$$OK
BuildDataGetAccessoryList
	For  Set rowid=$Order(^DHCEQCCode("DHCEQCAccessory",rowid))  Quit:rowid=""  Do
	.Do ResetVariablesGetAccessoryList
	.Set TRowID=rowid
	.Set TCode=$Piece($Get(^DHCEQCCode("DHCEQCAccessory",rowid)),"^",1)
	.Set TDesc=$Piece($Get(^DHCEQCCode("DHCEQCAccessory",rowid)),"^",2)
	.Set TShortDesc=$Piece($Get(^DHCEQCCode("DHCEQCAccessory",rowid)),"^",3)
	.;Quit:(ShortDesc'="")&($ZCONVERT(TShortDesc,"U")'[ShortDesc)
	.Quit:(ShortDesc'="")&&(($ZCONVERT(TDesc ,"U")'[ShortDesc)&&($ZCONVERT(TShortDesc,"U")'[ShortDesc))
	.Set TModel=$Piece($Get(^DHCEQCCode("DHCEQCAccessory",rowid)),"^",4)
	.Set TBaseUOMDR=$Piece($Get(^DHCEQCCode("DHCEQCAccessory",rowid)),"^",5)
	.If TBaseUOMDR'="" Set TBaseUOM=##class(web.DHCEQCommon).GetTrakNameByID("uom",(TBaseUOMDR))	;Modified By jdl 20150906 v4.1.0 规范单位取值
	.Set TTypeDR=$Piece($Get(^DHCEQCCode("DHCEQCAccessory",rowid)),"^",14)
	.If TTypeDR'="" Set TType=$Piece($Get(^DHCEQCCode("DHCEQCAccessoryType",TTypeDR)),"^",2)
	.Quit:(TypeDR'="")&&(TTypeDR'=TypeDR)
	.Set TManuFactoryDR=$Piece($Get(^DHCEQCCode("DHCEQCAccessory",rowid)),"^",27)
	.If TManuFactoryDR'="" Set TManuFactory=##Class(web.DHCEQCommon).GetTrakNameByID("manufacturer",TManuFactoryDR)		//CZF0093
	.Set TSerialFlag=$Piece($Get(^DHCEQCCode("DHCEQCAccessory",rowid)),"^",35)
	.Set TInvalidFlag=$Piece($Get(^DHCEQCCode("DHCEQCAccessory",rowid)),"^",77)
	.Quit:TInvalidFlag="Y"
	.Set TBatchFlag=$Piece($Get(^DHCEQCCode("DHCEQCAccessory",rowid)),"^",88)
	.Do OutputRowGetAccessoryList
	Quit
OutputRowGetAccessoryList
    Set Data=$ListBuild(TRowID,TCode,TDesc,TShortDesc,TModel,TBaseUOMDR,TManuFactoryDR,TManuFactory,TSerialFlag,TBatchFlag,TBaseUOM,TTypeDR,TType)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	Quit
ResetVariablesGetAccessoryList
	Set (TRowID,TCode,TDesc,TShortDesc,TModel,TBaseUOMDR,TManuFactoryDR,TManuFactory,TSerialFlag,TBatchFlag,TBaseUOM,TTypeDR,TType)=""
	Quit
}

ClassMethod GetAccessoryListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAccessoryListExecute ]
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

ClassMethod GetAccessoryListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAccessoryListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)

	Quit $$$OK
}

/// 2016-3-24	Mozy	南方医院
/// 原有配件名称选项重写
/// d ##class(%ResultSet).RunQuery("web.DHCEQCAccessory","GetAccessoryNew","")
Query GetAccessoryNew(Desc As %String = "", TypeDR As %String = "") As %Query(ROWSPEC = "Hidden:%String,TRow:%String,Hidden:%String,TDesc:%String,Hidden:%String,TModel:%String,Hidden:%String,Hidden:%String,TPrice:%String,Hidden:%String,TManuFactory:%String,Hidden:%String,THold1:%String,THold2:%String,Hidden:%String,Hidden:%String,Hidden:%String,TType:%String,Hidden:%String")
{
}

ClassMethod GetAccessoryNewExecute(ByRef qHandle As %Binary, Desc As %String = "", TypeDR As %String = "") As %Status
{
	new repid, index, rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s TRow=0
	s rowid=""  
	f  s rowid=$o(^DHCEQCCode("DHCEQCAccessory",rowid),-1)  quit:(rowid=0)||(rowid="")  d
	.d ResetVariablesGetAccessoryNew
	.s TRowID = rowid	//rowid
	.s InvalidFlag=$p($g(^DHCEQCCode("DHCEQCAccessory",rowid)),"^",77)
	.q:InvalidFlag="Y"
	.s TCode = $p($g(^DHCEQCCode("DHCEQCAccessory",rowid)),"^",1)
	.s TDesc = $p($g(^DHCEQCCode("DHCEQCAccessory",rowid)),"^",2)
	.s TShortDesc = $p($g(^DHCEQCCode("DHCEQCAccessory",rowid)),"^",3)
	.;q:(Desc'="")&&(($ZCONVERT(TCode ,"U")'[$ZCONVERT(Desc,"U"))&($ZCONVERT(TDesc,"U")'[$ZCONVERT(Desc,"U"))&($ZCONVERT(TShortDesc,"U")'[$ZCONVERT(Desc,"U")))
	.q:(Desc'="")&($ZCONVERT(TShortDesc,"U")'[$ZCONVERT(Desc,"U"))&($ZCONVERT(TDesc,"U")'[$ZCONVERT(Desc,"U"))
	.s TType = $p($g(^DHCEQCCode("DHCEQCAccessory",rowid)),"^",14)
	.// Mozy	2016-10-21
	.q:(TypeDR'="")&&(TypeDR'=TType)
	.Quit:##Class(web.DHCEQACommon).AccessoryTypeIsIn(TType)
	.i TType'="" s TType=$p($g(^DHCEQCCode("DHCEQCAccessoryType",TType)),"^",2)
	.s TCat = $p($g(^DHCEQCCode("DHCEQCAccessory",rowid)),"^",15)
	.i TCat'="" s TCat=$p($g(^DHCEQCCode("DHCEQCAccessoryCat",TCat)),"^",3)
	.s TCurBPrice = $p($g(^DHCEQCCode("DHCEQCAccessory",rowid)),"^",10)
	.i TCurBPrice'="" s TCurBPrice=##Class(web.DHCEQCommon).FormatNumber(TCurBPrice,"",4)
	.s TModel = $p($g(^DHCEQCCode("DHCEQCAccessory",rowid)),"^",4)
	.s TBaseUOMDR = $p($g(^DHCEQCCode("DHCEQCAccessory",rowid)),"^",5)
	.i TBaseUOMDR'="" s TBaseUOM=##Class(web.DHCEQCommon).GetTrakNameByID("uom",TBaseUOMDR)
	.s TManuFactoryDR = $p($g(^DHCEQCCode("DHCEQCAccessory",rowid)),"^",27)
	.i TManuFactoryDR'="" s TManuFactory=##Class(web.DHCEQCommon).GetTrakNameByID("manufacturer",TManuFactoryDR)		//CZF0093
	.s TSerialFlag = ##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQCCode("DHCEQCAccessory",rowid)),"^",35),"bool")	//需求: 282773	Mozy	20161111
	.s TRemark = $p($g(^DHCEQCCode("DHCEQCAccessory",rowid)),"^",70)
	.s THold1 = $p($g(^DHCEQCCode("DHCEQCAccessory",rowid)),"^",78)
	.s THold2 = $p($g(^DHCEQCCode("DHCEQCAccessory",rowid)),"^",79)
	.s THold3 = $p($g(^DHCEQCCode("DHCEQCAccessory",rowid)),"^",80)
	.s THold4 = $p($g(^DHCEQCCode("DHCEQCAccessory",rowid)),"^",81)
	.s THold5 = $p($g(^DHCEQCCode("DHCEQCAccessory",rowid)),"^",82)
	.d OutputRowGetAccessory
	Quit $$$OK
OutputRowGetAccessory
	s TRow=TRow+1
	s Data=$lb(TRowID,TRow,TCode,TDesc,TShortDesc,TModel,TBaseUOM,TBaseUOMDR,TCurBPrice,TCat,TManuFactory,TManuFactoryDR,THold1,THold2,THold3,THold4,THold5,TType,TSerialFlag)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetAccessoryNew
	s (TRowID,TCode,TDesc,TShortDesc,TModel,TBaseUOM,TBaseUOMDR,TCurBPrice,TCat,TManuFactory,TManuFactoryDR,THold1,THold2,THold3,THold4,THold5,TType,TSerialFlag)=""
	quit
}

ClassMethod GetAccessoryNewFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAccessoryNewExecute ]
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

ClassMethod GetAccessoryNewClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAccessoryNewExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// MZY0029	1340070		2020-05-29	更新审核价格信息
ClassMethod UpdateHold3(RowID As %Library.String = "")
{
	i (RowID="") q 0
	k PLIST
	s PLIST(81)=$H		;A_Hold3
	&SQL(Update SQLUSER.DHC_EQCAccessory Values :PLIST() where A_RowID = :RowID) 	 
	q RowID
}

}
