Import sqluser

/// Descript:	同第三方物资管理软件间的接口类
/// 	1.涉及第三方单据明细id的记录,需注意入库/出库/退货/调整-(如果用到)等接口的特殊处理.
/// Creator:	wangjiabin
/// CreateDate:	2021-10-04
Class web.DHCSTMService.HRPJson.STM2HRPServiceImpl Extends (%RegisteredObject, web.DHCSTMHUI.StkTypeM, %XML.Adaptor) [ Not ProcedureBlock ]
{

Parameter ServiceType [ Final ] = "HRP";

/// Description:所有业务接口(制单等),均调用此类
/// Creator:	wangjiabin
/// CreateDate:	2021-11-04
/// Input:		OperateCode-业务代码, Input(主参数,json,支持Stream), 医院Code
/// Output: 
/// Return:		Json格式字符串 {"success":0,"msg":"操作成功"} {"success":-1,"msg":"操作失败"}
/// 			success-0成功,其他失败; msg:返回信息
/// w ##class(web.DHCSTMService.HRPJson.STM2HRPServiceImpl).Main("SaveInitIngrt",^tmpbin(27,"2021-12-23 16:11:10",2),"BJAZYY")
/// w ##class(web.DHCSTMService.HRPJson.STM2HRPServiceImpl).Main("SaveIngdRet",^tmpbin(27,"2021-12-22 20:26:16",2),"BJAZYY")
/// w ##class(web.DHCSTMService.HRPJson.STM2HRPServiceImpl).Main("SaveIngrInit","[{""VenCode"":""qx407"",""RecLocCode"":""210"",""UserCode"":""7111"",""ToLocCode"":""153"",""SpdIngrNo"":""BHBHCK202100131--bulu001"",""List"":[{""ThirdId"":""HCJOBS000000009999996167"",""InciCode"":""1500161006590312"",""StockDetailId"":""HCJOBS000000000000006158"",""Qty"":""1"",""UomDesc"":""盒"",""Rp"":""4938"",""BatchNo"":""ZMB00"",""ExpDate"":""2022-12-31"",""ManfCode"":""SPD10112"",""ProduceDate"":""2021-11-01"",""InvNo"":"""",""InvDate"":"""",""OriginalCode"":"""",""HVBarCode"":""L150016100659031220211215003""}]}]","BJAZYY")
/// w ##class(web.DHCSTMService.HRPJson.STM2HRPServiceImpl).Main("SynInvInfo","[{""ThirdId"":""LCJOBS000000000000000290"",""Type"":""G"",""InvNo"":""96963212"",""InvCode"":""12345678"",""InvDate"":""2021-10-21""}]","BJAZYY")
/// w ##class(web.DHCSTMService.HRPJson.STM2HRPServiceImpl).Main("SaveManfData","[{""ManfCode"":""test010101"",""ManfDesc"":""安贞器械供应商"",""UseFlag"":""Y"",""Tel"":""18689895656"",""Address"":""北京市朝阳区安贞里100号""}]","BJAZYY")
/// w ##class(web.DHCSTMService.HRPJson.STM2HRPServiceImpl).Main("SaveAdj","[{""SPDNo"":""20211205001-adj"",""LocCode"":163,""UserCode"":""dthealth"",""Remarks"":"""",""List"":[{""ThirdId"":""adjitm20211205-001"",""StockDetailId"":""spddetail20211205-01"",""HVBarCode"":""SPD20211205-0101"",""Qty"":1,""UomDesc"":"""",""OriginalCode"":""018989898989891725010121ABC-1"",""VenCode"":""AM00003"",""InciCode"":""GZ00015"",""BatchNo"":""Bat-01"",""ExpDate"":""2025-01-01"",""Rp"":1010,""Sp"":1010}]}]","DHSZHYYZY")
/// w ##class(web.DHCSTMService.HRPJson.STM2HRPServiceImpl).Main("SynInvInfo","[{""ThirdId"":""LCJOBS000000000000004480"",""Type"":""G"",""InvNo"":""20211214"",""InvCode"":""202112140001"",""InvDate"":""2021/12/140:00:00""}]","BJAZYY")
/// w ##class(web.DHCSTMService.HRPJson.STM2HRPServiceImpl).Main("SaveInciData",##class(web.DHCSTMHUI.DHCDataExchangeLog).Get(27),"XFXZYYY")
/// w ##class(web.DHCSTMService.HRPJson.STM2HRPServiceImpl).Main("SynPriceData",##class(web.DHCSTMHUI.DHCDataExchangeLog).Get(125),"XFXZYYY")
ClassMethod Main(OperateCode As %String, Input, HospCode) As %String
{
	n (OperateCode,Input,HospCode)
	
	s RtnObj=##class(web.DHCSTMHUI.RtnObj).%New()
	s ServiceType=..%GetParameter("ServiceType")		;接口类型代码
	
	s RtnStr=""
	d ##class(web.DHCSTMHUI.DHCDataExchangeLog).Log(.LogId,"",ServiceType,$ZNAME,OperateCode,Input)
	
	s $ZT=..sssError()
	
	s HospId=##class(web.DHCSTMService.HRPJson.CommonInfo).ComHosp(HospCode)
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Input)
	
	i OperateCode="" d
	.s RtnStr="业务代码不明!"
	e  i HospId="" d
	.s RtnStr="医院代码错误!"
	e  i Sc'=0 d
	.s RtnStr="主参数解析错误,请核实!"
	i RtnStr'="" d ##class(web.DHCSTMHUI.DHCDataExchangeLog).Log(.LogId,RtnStr) q RtnObj.Err(-1,"",RtnStr,"",0).Json()
	
	s UseFlag=##class(web.DHCSTMHUI.ServiceConfig).GetSerUseFlag(ServiceType,HospId)
	i UseFlag'="Y" d ##class(web.DHCSTMHUI.DHCDataExchangeLog).Log(.LogId,ServiceType_"接口未启用") q RtnObj.Err(0,"","接口未启用","",0).Json()
	
	if (OperateCode="SaveInciData") {
		;库存项信息
		s RtnObj=..SaveData(Input,HospId)
	} elseif (OperateCode="SynPriceData") {
		;调价
		s RtnObj=..SynPriceData(Input,HospId)
	} elseif(OperateCode="SynPriceBatch") {
		;批次调价
		s RtnObj=..SynPriceBatch(Input,HospId)
	} elseif (OperateCode="SynIncscData") {
		;同步库存分类
		s RtnObj=..SynIncscData(Input,HospId)
	} elseif (OperateCode="SaveVendorData") {
		;同步供应商
		s RtnObj=..SaveVendorData(Input,HospId)
	} elseif (OperateCode="SaveManfData") {
		;同步生产厂家
		s RtnObj=..SaveManfData(Input,HospId)
	} elseif (OperateCode="SaveInGdRec") {
		;同步入库单
		s RtnObj=..SaveInGdRec(Input)
	} elseif (OperateCode="SaveInIsTrf") {
		;同步出库单
		s RtnObj=..SaveInIsTrf(Input)
	} elseif (OperateCode="SaveIngdRet") {
		;同步退货单
		s RtnObj=..SaveIngdRet(Input)
	} elseif (OperateCode="SaveAdj") {
		;同步调整单
		s RtnObj=..SaveAdj(Input)
	} elseif (OperateCode="SynInvInfo") {
		;同步发票
		s RtnObj=..SynInvInfo(Input)
	} elseif (OperateCode="SaveIngrInit") {
		;同步高值补录的入库单和出库单
		s RtnObj=..SaveIngrInit(Input)
	} elseif (OperateCode="SaveInitIngrt") {
		;同步高值补录的退库单和退货单
		s RtnObj=..SaveInitIngrt(Input)
	} else {
		d RtnObj.Err(-100,"","接口代码错误","",0)
	}
	s RtnStr=RtnObj.Json()
	d ##class(web.DHCSTMHUI.DHCDataExchangeLog).Log(.LogId,RtnStr)
	q RtnStr
}

/// Description:查询数据,调用此类
/// Creator:	wangjiabin
/// CreateDate:	2021-11-26
/// Input:		OperateCode-业务代码, Input(主参数,json,支持Stream), 医院Code
/// Output: 
/// Return:		Json格式字符串 {"success":0,"msg":"操作成功"} {"success":-1,"msg":"操作失败"}
/// 			success-0成功,其他失败; msg:返回信息
/// w ##class(web.DHCSTMService.HRPJson.STM2HRPServiceImpl).GetBussinessData("GetLocStock","{}","DHSZHYYZY")
ClassMethod GetData(OperateCode As %String, Input, HospCode)
{
	n (OperateCode,Input,HospCode)
	s RtnObj=##class(web.DHCSTMHUI.RtnObj).%New()
	s ServiceType=..%GetParameter("ServiceType")		;接口类型代码
	
	s RtnStr=""
	d ##class(web.DHCSTMHUI.DHCDataExchangeLog).Log(.LogId,"",ServiceType,$ZNAME,OperateCode,Input)
	
	s HospId=##class(web.DHCSTMService.HRPJson.CommonInfo).ComHosp(HospCode)
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Input)
	
	i OperateCode="" d
	.s RtnStr="业务代码不明!"
	e  i HospId="" d
	.s RtnStr="医院代码错误!"
	e  i Sc'=0 d
	.s RtnStr="主参数解析错误,请核实!"
	i RtnStr'="" d ##class(web.DHCSTMHUI.DHCDataExchangeLog).Log(.LogId,RtnStr) q RtnObj.Err(-1,"",RtnStr,"",0).Json()
	
	s UseFlag=##class(web.DHCSTMHUI.ServiceConfig).GetSerUseFlag(ServiceType,HospId)
	i UseFlag'="Y" d ##class(web.DHCSTMHUI.DHCDataExchangeLog).Log(.LogId,ServiceType_"接口未启用") q RtnObj.Err(0,"","接口未启用","",0).Json()
	
	if (OperateCode="GetLocStock") {
		;查询科室库存数据
		s Result=..GetLocStock(Input,HospId)
	} elseif (OperateCode="GetIntrInfo") {
		;查询科室台帐数据
		s Result=..GetIntrInfo(Input)
	}
	
	q Result
}

/// 判断库存项是否在使用范围内
/// [各方法统一调用]
ClassMethod GetInciFlag(Inci) As %String [ Private ]
{
	q:Inci="" ""
	s Flag="N"
	s StkType=..sssCode()
	s IncscId=$p(^INCI(Inci,2),"^",2)	;库存分类id
	q:IncscId="" Flag
	s ScgInfo=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncStkCatGrp(Inci)
	s ScgType=$p(ScgInfo,"^",3)			;类组(M表示物资)
	s ScgId=$p(ScgInfo,"^",5)			;类组rowid
	s ScgSet=$p(ScgInfo,"^",7)			;类组集合(MM,MO,MR等)
	q:(ScgType'=StkType) Flag
	;q:IncscId'=** Flag					;条件不满足的及时退出
	
	s Flag="Y"
	q Flag
}

/// w ##class(web.DHCSTMService.HRPJson.STM2HRPServiceImpl).GetMapArcDesc()
ClassMethod GetMapArcDesc(ArcCatInfo, ObjName)
{
	n (ArcCatInfo, ObjName)
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(ArcCatInfo)
	i Sc'=0 q ""
	s MapArcbox=PJObj.%Get(ObjName)
	i '$ISOBJECT(MapArcbox) q MapArcbox
	s MapArcboxjson=MapArcbox.%ToJSON()
	s PJObj1=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc1=PJObj1.%FromJSON(MapArcboxjson)
	i Sc1'=0 q ""
	s desc=PJObj1.%Get("Description")
	q desc
}

/// Descript:	同步基础数据
/// CreateDate:	2021-11-21
/// Input:		[{},{}]
/// Return:		[0:"",1:失败信息]
ClassMethod SaveData(Input, HospId) As web.DHCSTMHUI.RtnObj
{
	n (Input,HospId)

	s RtnObj=##class(web.DHCSTMHUI.RtnObj).%New()
	s Array=[].%FromJSON(Input)
	
	s Size=Array.%Size()
	i Size=0 q RtnObj.Err(-1,"","入参为空!","",0)
	
	ts
	f i=1:1:Size q:RtnObj.success<0  d
	.s ItmObj=Array.%Get(i-1)
	.
	.s LocCode=ItmObj.%Get("LocCode")
	.s UserCode=ItmObj.%Get("UserCode")
	.
	.s InciCode=ItmObj.%Get("InciCode")
	.s InciDesc=ItmObj.%Get("InciDesc")
	.s PUomDesc=ItmObj.%Get("PUomDesc")
	.s BUomDesc=ItmObj.%Get("BUomDesc")
	.s PFac=ItmObj.%Get("PFac")
	.s IncscDesc=ItmObj.%Get("IncscDesc")		;库存分类信息
	.s Spec=ItmObj.%Get("Spec")
	.s Brand=ItmObj.%Get("Brand")
	.s Model=ItmObj.%Get("Model")
	.s Abbrev=ItmObj.%Get("Abbrev")
	.
	.s ChargeFlag=ItmObj.%Get("ChargeFlag")
	.s Sp=ItmObj.%Get("Sp")
	.s Rp=ItmObj.%Get("Rp")
	.
	.s RegCertNo=ItmObj.%Get("RegCertNo")
	.s RegCertExpDate=ItmObj.%Get("RegCertExpDate")
	.s RegCertItmDesc=ItmObj.%Get("RegCertItmDesc")
	.s VenCode=ItmObj.%Get("VenCode")
	.s ManfCode=ItmObj.%Get("ManfCode")
	.s MatInsuCode=ItmObj.%Get("MatInsuCode")
	.
	.s HVFlag=ItmObj.%Get("HVFlag")
	.;s TableFlag=ItmObj.%Get("TableFlag")
	.s ImplantFlag=ItmObj.%Get("ImplantFlag")
	.s ImportFlag=ItmObj.%Get("ImpFlag")
	.s Supervision=ItmObj.%Get("Supervision")
	.s UseFlag=ItmObj.%Get("UseFlag")
	.
	.s ArcInfoObj=ItmObj.%Get("ArcInfo")				;医嘱项部分
	.
	.s LocId=##class(web.DHCSTMService.HRPJson.CommonInfo).GetLocId(LocCode)
	.s UserId=##class(web.DHCSTMService.HRPJson.CommonInfo).GetUserId(UserCode)
	.s Inci=##class(web.DHCSTMService.HRPJson.CommonInfo).GetInciId(InciCode)
	.s IncscId=##class(web.DHCSTMService.HRPJson.CommonInfo).GetIncscId(IncscDesc)
	.s VendorId=##class(web.DHCSTMService.HRPJson.CommonInfo).GetVendorId(VenCode)
	.s ManfId=##class(web.DHCSTMService.HRPJson.CommonInfo).GetManfId(ManfCode)
	.s BUomId=##class(web.DHCSTMService.HRPJson.CommonInfo).GetUomId(BUomDesc)
	.s PUomId=##class(web.DHCSTMService.HRPJson.CommonInfo).GetUomId(PUomDesc)
	.
	.s ScgId=""
	.&sql(SELECT SCGR_SCG_Parref into :ScgId FROM DHC_StkCatGrpRelations WHERE SCGR_StkCat_DR=:IncscId AND SCGR_SCG_Parref->scg_type='M')
	.i SQLCODE s ScgId=""
	.
	.i (ChargeFlag="Y")&&(ArcInfoObj="") d RtnObj.Err(-1,"","第"_i_"条,收费耗材医嘱项信息为空!","",0) q
	.i InciCode="" d RtnObj.Err(-1,"","第"_i_"条,代码为空!","",0) q
	.i UserId="" d RtnObj.Err(-1,"","第"_i_"条,用户为空!","",0) q
	.i LocCode="" d RtnObj.Err(-1,"","第"_i_"条,科室为空!","",0) q
	.i IncscDesc="" d RtnObj.Err(-1,"","第"_i_"条,库存分类为空!","",0) q
	.i (VenCode'="")&&(VendorId="") d RtnObj.Err(-1,"","第"_i_"条,供应商无效!","",0) q
	.i (ManfCode'="")&&(ManfId="") d RtnObj.Err(-1,"","第"_i_"条,厂商无效!","",0) q
	.i (UserCode'="")&&(UserId="") d RtnObj.Err(-1,"","第"_i_"条,用户无效!","",0) q
	.i (LocCode'="")&&(LocId="") d RtnObj.Err(-1,"","第"_i_"条,科室无效!","",0) q
	.i (IncscId="")||(ScgId="") d RtnObj.Err(-1,"","第"_i_"条,库存分类无效!","",0) q
	.i (Supervision'="")&&'$lf($lb("I","II","III"),Supervision) d RtnObj.Err(-1,"","第"_i_"条,监管级别无效!","",0) q
	.i (BUomId="")||(PUomId="") d RtnObj.Err(-1,"","第"_i_"条,单位无效!","",0) q
	.
	.;s RegCertExpDateH=$zdh(RegCertExpDate,3)
	.s NotUseFlag=$s(UseFlag="N":"Y",1:"N")
	.s ImpFlag=$s(ImportFlag="1":"进口",ImportFlag="2":"国产",1:"")
	.s HospId=$p(^CTLOC(LocId),"^",22)
	.
	.;已经存在的,不允许修改 物资名称/规格/型号
	.i Inci'="" d
	..;s InciDesc=$p(^INCI(Inci,1),"^",2)
	..;s Spec=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetSpec("",Inci)
	..;s Model=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetModel(Inci)
	.
	.s InciObj={}
	.
	.d InciObj.%Set("gUserId",UserId)
	.d InciObj.%Set("gLocId",LocId)
	.d InciObj.%Set("gHospId",HospId)
	.
	.d InciObj.%Set("Inci",Inci)
	.d InciObj.%Set("InciCode",InciCode)
	.d InciObj.%Set("InciDesc",InciDesc)
	.d InciObj.%Set("StkCat",IncscId)
	.d InciObj.%Set("StkGrp",ScgId)
	.
	.d InciObj.%Set("BUom",BUomId)
	.d InciObj.%Set("PUom",PUomId)
	.d InciObj.%Set("Spec",Spec)
	.d InciObj.%Set("Brand",Brand)
	.d InciObj.%Set("Model",Model)
	.d InciObj.%Set("Abbrev",Abbrev)
	.d InciObj.%Set("Supervision",Supervision)
	.
	.s PreExeDate=$zd($h,3)
	.d InciObj.%Set("PreExeDate",PreExeDate)
	.d InciObj.%Set("RpPUom",Rp)
	.d InciObj.%Set("SpPUom",Sp)
	.
	.d InciObj.%Set("RegCertNo",RegCertNo)
	.d InciObj.%Set("RegCertExpDate",RegCertExpDate)
	.d InciObj.%Set("PbVendor",VendorId)
	.d InciObj.%Set("Manf",ManfId)
	.d InciObj.%Set("MatInsuCode",MatInsuCode)
	.
	.d InciObj.%Set("BatchNoReq","R")
	.d InciObj.%Set("ExpDateReq","R")
	.d InciObj.%Set("NotUseFlag",NotUseFlag)
	.d InciObj.%Set("HighPrice",HVFlag)
	.d InciObj.%Set("ImplantationMat",ImplantFlag)
	.d InciObj.%Set("ImpFlag",ImpFlag)
	.d InciObj.%Set("ChargeFlag",ChargeFlag)
	.
	.s ArcObj={}
	.i (ChargeFlag="Y") d
	..s ArcCode=ArcInfoObj.%Get("ArcCode")					;代码
	..s ArcDesc=ArcInfoObj.%Get("ArcDesc")					;描述
	..s BillUomDesc=ArcInfoObj.%Get("BillUomDesc")			;账单单位
	..s OrdSubCat=ArcInfoObj.%Get("OrdSubCat")				;医嘱子类
	..s BillSubCat=ArcInfoObj.%Get("BillSubCat")			;费用子类
	..s OwnFlag=ArcInfoObj.%Get("OwnFlag")					;独立医嘱标志
	..s Priority=ArcInfoObj.%Get("Priority")				;默认医嘱优先级
	..s WoStock=ArcInfoObj.%Get("WoStock")					;无库存医嘱标志
	..;s FeeFlag=ArcInfoObj.%Get("FeeFlag")
	..s TarSubCat=ArcInfoObj.%Get("TarSubCat")				;子分类
	..s TarInpatCat=ArcInfoObj.%Get("TarInpatCat")			;住院子分类
	..s TarOutpatCat=ArcInfoObj.%Get("TarOutpatCat")		;门诊子分类
	..s TarEMCCat=ArcInfoObj.%Get("TarEMCCat")				;核算子分类
	..s TarAcctCat=ArcInfoObj.%Get("TarAcctCat")			;会计子分类
	..s TarMRCat=ArcInfoObj.%Get("TarMRCat")				;病例首页
	..s TarNewMRCat=ArcInfoObj.%Get("TarNewMRCat")			;新病历首页分类
	..s TariCode=ArcInfoObj.%Get("TariCode")				;收费项代码
	..s TariDesc=ArcInfoObj.%Get("TariDesc")				;收费项名称
	..s ChargeBasis=ArcInfoObj.%Get("ChargeBasis")			;收费依据
	..s TarInsuCode=ArcInfoObj.%Get("TarInsuCode")
	..s TarInsuName=ArcInfoObj.%Get("TarInsuName")
	..
	..
	..;s OwnFlag="N"		;新建时,默认独立医嘱标记为N; 修改时,使用原字段值
	..s ArcimId=""
	..s ArcSub=$o(^ARCIM(0,"Code",$$ALPHAUP^SSUTIL4(ArcCode),0))
	..i ArcSub'="" d
	...s ArcVer=$o(^ARCIM(0,"Code",$$ALPHAUP^SSUTIL4(ArcCode),ArcSub,0))
	...s ArcimId=ArcSub_"||"_ArcVer
	...;s OwnFlag=$p(^ARCIM(ArcSub,ArcVer,7),"^",13)
	..
	..s BillCatId=$p(BillSubCatId,"||",1)
	..s FeeFlag="N"		;不维护收费项(为N表示-维护收费项)
	..
	..;根据配置取医嘱收费分类 IncscId HVFlag
	..s ScMap=##class(web.DHCSTMHUI.Common.AppCommon).GetAppPropValue("DHCSTDRUGMAINTAINM","ScMap","")
	..s ArcCatInfo="{}"
	..if ScMap="Y" d
	...s ArcCatInfo=##class(web.DHCSTMHUI.DrugInfoMaintain).MapArc(IncscId)
	..if ScMap="G" d
	...s MapArcByHvParams="{""gHospId"":""""""}"
	...s ArcCatInfo=##class(web.DHCSTMHUI.DrugInfoMaintain).MapArcByHv(HVFlag,MapArcByHvParams)
	..i (ArcimId="")&&(ArcCatInfo'="{}") d
	...s OrdSubCat=..GetMapArcDesc(ArcCatInfo,"OrdSubCat")
	...s BillSubCat=..GetMapArcDesc(ArcCatInfo,"BillSubCat")
	...s OwnFlag=..GetMapArcDesc(ArcCatInfo,"OwnFlag")
	...s:OwnFlag="" OwnFlag="N"
	...s Priority=..GetMapArcDesc(ArcCatInfo,"Priority")
	...s TarSubCat=..GetMapArcDesc(ArcCatInfo,"TarSubCat")
	...s TarInpatCat=..GetMapArcDesc(ArcCatInfo,"TarInpatCat")
	...s TarOutpatCat=..GetMapArcDesc(ArcCatInfo,"TarOutpatCat")
	...s TarEMCCat=..GetMapArcDesc(ArcCatInfo,"TarEMCCat")
	...s TarAcctCat=..GetMapArcDesc(ArcCatInfo,"TarAcctCat")
	...s TarMRCat=..GetMapArcDesc(ArcCatInfo,"TarMRCat")
	...s TarNewMRCat=..GetMapArcDesc(ArcCatInfo,"TarNewMRCat")
	..
	..
	..s BillUomId=##class(web.DHCSTMService.HRPJson.CommonInfo).GetUomId(BillUomDesc)
	..s OrdSubCatId=##class(web.DHCSTMService.HRPJson.CommonInfo).GetOrdSubCatId(OrdSubCat)
	..s BillSubCatId=##class(web.DHCSTMService.HRPJson.CommonInfo).GetBillSubCatId(BillSubCat)
	..s Priority="临时医嘱"
	..s PriorId=##class(web.DHCSTMService.HRPJson.CommonInfo).GetPriorityId(Priority)
	..
	..s TarSubCatId=##class(web.DHCSTMService.HRPJson.CommonInfo).GetTarSubCatId(TarSubCat)
	..s TarInpatCatId=##class(web.DHCSTMService.HRPJson.CommonInfo).GetTarInpatCatId(TarInpatCat)
	..s TarOutpatCatId=##class(web.DHCSTMService.HRPJson.CommonInfo).GetTarOutpatCatId(TarOutpatCat)
	..s TarEMCCatId=##class(web.DHCSTMService.HRPJson.CommonInfo).GetTarEMCCatId(TarEMCCat)
	..s TarAcctCatId=##class(web.DHCSTMService.HRPJson.CommonInfo).GetTarAcctCatId(TarAcctCat)
	..s TarMRCatId=##class(web.DHCSTMService.HRPJson.CommonInfo).GetTarMRCatId(TarMRCat)
	..s TarNewMRCatId=##class(web.DHCSTMService.HRPJson.CommonInfo).GetTarNewMRSubCatId(TarNewMRCat)
	..
	..i (OrdSubCat="")||(OrdSubCatId="") d RtnObj.Err(-1,"","医嘱子类为空或无效!","",0) q
	..i (BillSubCat="")||(BillSubCatId="") d RtnObj.Err(-1,"","费用子类为空或无效!","",0) q
	..i (TarSubCat="")||(TarSubCatId="") d RtnObj.Err(-1,"","子分类为空或无效!","",0) q
	..i (TarInpatCat="")||(TarInpatCatId="") d RtnObj.Err(-1,"","住院子分类为空或无效!","",0) q
	..i (TarOutpatCat="")||(TarOutpatCatId="") d RtnObj.Err(-1,"","门诊子分类为空或无效!","",0) q
	..i (TarEMCCat="")||(TarEMCCatId="") d RtnObj.Err(-1,"","核算子分类为空或无效!","",0) q
	..i (TarAcctCat="")||(TarAcctCatId="") d RtnObj.Err(-1,"","会计子分类为空或无效!","",0) q
	..i (TarMRCat="")||(TarMRCatId="") d RtnObj.Err(-1,"","病案子分类为空或无效!","",0) q
	..i (TarNewMRCat="")||(TarNewMRCatId="") d RtnObj.Err(-1,"","新病案子分类为空或无效!","",0) q
	..
	..
	..d ArcObj.%Set("Arc",ArcimId)
	..d ArcObj.%Set("ArcCode",ArcCode)
	..d ArcObj.%Set("ArcDesc",ArcDesc)
	..d ArcObj.%Set("BillUom",BillUomId)
	..d ArcObj.%Set("OrdSubCat",OrdSubCatId)
	..d ArcObj.%Set("BillCat",BillCatId)
	..d ArcObj.%Set("BillSubCat",BillSubCatId)
	..d ArcObj.%Set("OwnFlag",OwnFlag)
	..d ArcObj.%Set("Priority",PriorId)
	..d ArcObj.%Set("WoStock",WoStock)
	..d ArcObj.%Set("FeeFlag",FeeFlag)
	..d ArcObj.%Set("TarSubCat",TarSubCatId)
	..d ArcObj.%Set("TarInpatCat",TarInpatCatId)
	..d ArcObj.%Set("TarOutpatCat",TarOutpatCatId)
	..d ArcObj.%Set("TarEMCCat",TarEMCCatId)
	..d ArcObj.%Set("TarAcctCat",TarAcctCatId)
	..d ArcObj.%Set("TarMRCat",TarMRCatId)
	..d ArcObj.%Set("TarNewMRCat",TarNewMRCatId)
	..d ArcObj.%Set("TariCode",TariCode)
	..d ArcObj.%Set("TariDesc",TariDesc)
	..d ArcObj.%Set("ChargeBasis",ChargeBasis)
	..d ArcObj.%Set("TarInsuCode",MatInsuCode)
	..d ArcObj.%Set("TarInsuName",RegCertItmDesc)
	.q:RtnObj.success<0
	.
	.s IncData=InciObj.%ToJSON()
	.s ArcData=ArcObj.%ToJSON()
	.;i Inci'="" s ArcData=""				;医嘱项收费项不允许修改
	.s RetStr=##class(web.DHCSTMHUI.DrugInfoMaintain).SaveData(ArcData,IncData)
	.s RetObj={}.%FromJSON(RetStr)
	.s RtnObj.success=RetObj.success,RtnObj.rowid=RetObj.rowid,RtnObj.msg=RetObj.msg
	
	i RtnObj.success<0 tro  q RtnObj
	
	tc
	q RtnObj
}

/// w ##class(web.DHCSTMService.HRPJson.STM2HRPServiceImpl).SaveAdj("[{""SPDNo"":""20211205001-adj"",""LocCode"":163,""UserCode"":""dthealth"",""Remarks"":"""",""List"":[{""ThirdId"":""adjitm20211205-001"",""StockDetailId"":""spddetail20211205-01"",""HVBarCode"":""SPD20211205-0101"",""Qty"":1,""UomDesc"":"""",""OriginalCode"":""018989898989891725010121ABC-1"",""VenCode"":""AM00003"",""InciCode"":""GZ00015"",""BatchNo"":""Bat-01"",""ExpDate"":""2025-01-01"",""Rp"":1010,""Sp"":1010}]}]")
/// zw ##class(web.DHCSTMService.HRPJson.STM2HRPServiceImpl).SaveAdj("[{""SPDNo"":""SPDAdj20220630-001"",""LocCode"":163,""UserCode"":""dthealth"",""Remarks"":""备注spd"",""List"":[{""ThirdId"":""spd-adj-1001"",""StockDetailId"":"""",""HVBarCode"":"""",""Qty"":10,""UomDesc"":"""",""OriginalCode"":"""",""VenCode"":""AM00020"",""InciCode"":""DZ01194"",""BatchNo"":""abcd01"",""ExpDate"":""2029-01-31"",""Rp"":100,""Sp"":110}]}]")
ClassMethod SaveAdj(Input) As web.DHCSTMHUI.RtnObj
{
	/*
[{
	SPDNo: SPD调整单号,
	LocCode:  科室代码(调整科室),
	UserCode: 人员代码(工号),
	Remarks: 备注,
	List:[
		{
			StockDetailId: 第三方批次ID, 其他物资代码,批号效期等均不需传递,以此DetailId为准.
			Qty: 入库数量,
			UomDesc: 单位描述(如约定单位规则,可传空),
			HVBarCode: 高值条码,
			如果是新批次,支持传入批号/效期等信息
		},
		{其他单据明细},
		...
	]
},
{其他单据...}]
	*/
	n (Input)
	s ServiceType=..%GetParameter("ServiceType")
	s RtnObj=##class(web.DHCSTMHUI.RtnObj).%New()
	s BillArray=[].%FromJSON(Input)
	
	s Size=BillArray.%Size()
	i Size=0 q RtnObj.Err(-1,"","入参为空!","",0)
	
	ts
	f i=1:1:Size q:RtnObj.success<0  d
	.s BillObj=BillArray.%Get(i-1)
	.
	.s SPDNo=BillObj.%Get("SPDNo")
	.s LocCode=BillObj.%Get("LocCode")
	.s UserCode=BillObj.%Get("UserCode")
	.s Remarks=BillObj.%Get("Remarks")
	.s AdjType=BillObj.%Get("AdjType")		;"AdjTo"表示"调整到"
	.i AdjType="AdjTo" s Remarks="AdjTo:"_Remarks
	.
	.s SPDNoUpper=$$ALPHAUP^SSUTIL4(SPDNo)
	.s LocId=##class(web.DHCSTMService.HRPJson.CommonInfo).GetLocId(LocCode)
	.s UserId=##class(web.DHCSTMService.HRPJson.CommonInfo).GetUserId(UserCode)
	.
	.i SPDNo="" d RtnObj.Err(-1,"","第"_i_"个单据,单号为空!","",0) q
	.i $d(^DHCINAD(0,"No",SPDNoUpper)) d RtnObj.Err(-1,"","第"_i_"个单据,单号重复处理!","",0) q
	.i LocId="" d RtnObj.Err(-1,"","第"_i_"个单据,科室无效!","",0) q
	.i UserId="" d RtnObj.Err(-1,"","第"_i_"个单据,人员无效!","",0) q
	.s HospId=$p(^CTLOC(LocId),"^",22)
	.
	.s MainObj={}
	.d MainObj.%Set("AdjLoc",LocId)
	.d MainObj.%Set("gUserId",UserId)
	.d MainObj.%Set("Remark",Remarks)
	.d MainObj.%Set("Complate","Y")		;保存为"完成"状态
	.
	.
	.;批次调价单单号
	.s AdjBatchAppName=##class(web.DHCSTMHUI.INAdjPriceBatch).%GetParameter("AppName")
	.s AdjBatchNo=##class(web.DHCSTMHUI.Common.AppCommon).GetAppNo(AdjBatchAppName,"",LocId)
	.
	.s ItmArray=[]
	.
	.s ListArr=BillObj.%Get("List")
	.s ListSize=ListArr.%Size()
	.i ListSize=0 d RtnObj.Err(-1,"","第"_i_"个单据,单据明细为空!","",0) q
	.
	.f j=ListSize:-1:1 q:RtnObj.success<0  d
	..s PItmObj=ListArr.%Get(j-1)
	..s DetailId=PItmObj.%Get("StockDetailId")
	..s Qty=PItmObj.%Get("Qty")
	..s UomDesc=PItmObj.%Get("UomDesc")
	..s HVBarCode=PItmObj.%Get("HVBarCode")
	..s ThirdId=PItmObj.%Get("ThirdId")
	..s OriginalCode=PItmObj.%Get("OriginalCode")
	..s VenCode=PItmObj.%Get("VenCode")
	..s InciCode=PItmObj.%Get("InciCode")
	..s BatchNo=PItmObj.%Get("BatchNo")
	..s ExpDate=PItmObj.%Get("ExpDate")
	..s Rp=PItmObj.%Get("Rp")
	..s Sp=PItmObj.%Get("Sp")
	..
	..s ExpDateH=$s(ExpDate'="":$zdh(ExpDate,3),1:"")
	..s VendorId=##class(web.DHCSTMService.HRPJson.CommonInfo).GetVendorId(VenCode)
	..s InciId=##class(web.DHCSTMService.HRPJson.CommonInfo).GetInciId(InciCode)
	..;i DetailId="" d RtnObj.Err(-21,"","第"_i_"单第"_j_"条,批次Id为空!","",0) q
	..i InciId="" d RtnObj.Err(-1,"","第"_i_"单第"_j_"条,库存项为空","",0) q
	..i (VenCode'="")&&(VendorId="") d RtnObj.Err(-21,"","第"_i_"单第"_j_"条,供应商无效!","",0) q
	..i (InciCode'="")&&(InciId="") d RtnObj.Err(-21,"","第"_i_"单第"_j_"条,库存项无效!","",0) q
	..i (Rp="")||(Sp="") d RtnObj.Err(-21,"","第"_i_"单第"_j_"条,价格信息为空!","",0) q
	..
	..s (Incib,Inclb)=""
	..;获取已有的批次
	..i DetailId'="" d
	...s Incib=..GetIncibByDetailId(DetailId)
	...q:Incib=""
	...i $p(Incib,"||",1)'=InciId d RtnObj.Err(-1,"第"_i_"单第"_j_"条,StockDetailId入参错误,与库存项不符!","",0) q
	...;自动生成Inclb
	...s Inclb=..GetInclbByIncibAndLoc(Incib,LocId,"Y")
	..q:RtnObj.success<0
	..
	..;如果Incib为空,说明是新批次,需要生成Incib
	..i Incib="" d
	...;新建批次
	...s InciCode=$p(^INCI(InciId,1),"^",1)
	...s Paramstr=DetailId_"^"_InciId_"^"_LocId_"^"_ExpDateH_"^"_BatchNo_"^"_Rp_"^"_Sp_"^"_VendorId_"^"_UserId
	...s RtnObj=..GetIncib(Paramstr,AdjBatchNo)
	...i RtnObj.success<0 d RtnObj.Err(-1,"","第"_i_"单第"_j_"条,生成批次失败:"_RtnObj.msg,"",0) q
	...s Incib=RtnObj.rowid
	...s Inclb=..GetInclbByIncibAndLoc(Incib,LocId,"Y")
	...i +Inclb<0 d RtnObj.Err(-1,"","第"_i_"单第"_j_"条,生成批次失败","",0) q
	..q:RtnObj.success<0
	..i (Incib="")||(Inclb="") d RtnObj.Err(-21,"","第"_i_"单第"_j_"条,获取批次失败!","",0) q
	..
	..s BUomId=$p(^INCI(InciId,1),"^",10)
	..s UomId=BUomId
	..s Rp=##class(web.DHCSTMHUI.Common.PriceCommon).GetClbRp(Inclb,UomId,HospId)
	..s Sp=##class(web.DHCSTMHUI.Common.PriceCommon).GetPriceElse(Inclb,+$h,UomId,HospId)
	..s HVFlag=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncHighValueFlag(InciId)
	..i (HVFlag="Y")&&(HVBarCode="") d RtnObj.Err(-1,"","第"_i_"单第"_j_"条,高值条码为空!","",0) q
	..i ((HVBarCode'="")&&((Qty'=1)&&(Qty'=-1))) d RtnObj.Err(-1,"","第"_i_"单第"_j_"条,高值条码数量不符","",0) q
	..
	..i (HVBarCode'="")&&(AdjType="AdjTo") d RtnObj.Err(-1,"","第"_i_"单第"_j_"条,高值不允许使用调整到模式","",0) q
	..
	..s DHCIT=$s(HVBarCode'="":$o(^DHCIT(0,"LABEL",HVBarCode,0)),1:"")
	..i (HVBarCode'="")&&(DHCIT'="") d
	...s BarCodeInfo=##class(web.DHCSTMHUI.DHCItmTrack).GetItmByBarcode(HVBarCode)
	...s BarCodeObj={}.%FromJSON(BarCodeInfo)
	...s BarCodeStatus=BarCodeObj.Status
	...i (Qty=1)&&(BarCodeStatus'="InAdj") d RtnObj.Err(-1,"","第"_i_"单第"_j_"条,条码状态不符","",0) q
	...i (Qty=-1)&&(BarCodeStatus'="Enable") d RtnObj.Err(-1,"","第"_i_"单第"_j_"条,条码状态不符","",0) q
	...
	...s DHCITInclb=$p(^DHCIT(DHCIT),"^",12)
	...;如果调整减少,用的不是一个批次,报错;
	...i (Qty=-1)&&(DHCITInclb'=Inclb) d RtnObj.Err(-1,"","第"_i_"单第"_j_"条,"_HVBarCode_"批次不符!","",0) q
	...;如果调整增加,可以更新dhc_itmtrack的批次;
	...i (Qty=1)&&(DHCITInclb'=Inclb) d
	....&sql(update dhc_itmtrack set DHCIT_INCIB_DR=:Incib,DHCIT_INCLB_DR=:Inclb where DHCIT_Rowid=:DHCIT)
	....i SQLCODE<0 d RtnObj.Err(-1,"","第"_i_"单第"_j_"条,"_HVBarCode_"更新批次失败!","",0) q
	...
	..e  i (HVBarCode'="")&&(DHCIT="") d
	...i Qty'=1 d RtnObj.Err(-1,"","第"_i_"单第"_j_"条,新条码只能调整增加,请核实数量!","",0) q
	...;注册条码
	...s ManfInfo=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetPbManf(InciId)
	...s ManfId=$p(ManfInfo,"^",1)
	...s RegStr=HVBarCode_"^"_InciId_"^"_Rp_"^"_BatchNo_"^"_ExpDateH_"^"_VendorId_"^"_ManfId_"^"_UserId_"^"_LocId_"^"_OriginalCode_"^"_Inclb
	...s TrackId=..RegBarCode(RegStr,.ErrMsg)
	...i TrackId="" d RtnObj.Err(-1,"","第"_i_"单第"_j_"条,"_ErrMsg) q
	..q:RtnObj.success<0
	..
	..s InclbQty=##class(web.DHCSTMHUI.Common.DrugStkCommon).QtyINCLB(Inclb,+$h)
	..i AdjType="AdjTo" s Qty=Qty-InclbQty
	..
	..s ItmObj={}
	..d ItmObj.%Set("Inclb",Inclb)
	..d ItmObj.%Set("Qty",Qty)
	..d ItmObj.%Set("UomId",UomId)
	..d ItmObj.%Set("Rp",Rp)
	..d ItmObj.%Set("Sp",Sp)
	..d ItmObj.%Set("HvBarCode",HVBarCode)
	..d ItmObj.%Set("ThirdCode",ServiceType)
	..d ItmObj.%Set("ThirdId",ThirdId)
	..
	..d ItmArray.%Push(ItmObj)
	.q:RtnObj.success<0
	.i ItmArray.%Size()=0 d RtnObj.Err(-21,"","第"_i_"单,明细为空!","",0) q
	.
	.s MainInfo=MainObj.%ToJSON()
	.s ListData=ItmArray.%ToJSON()
	.s RtnObj=##class(web.DHCSTMHUI.DHCINAdj).SaveAdj(MainInfo,ListData)
	.i RtnObj.success<0 s RtnObj.msg="第"_i_"单,保存失败:"_RtnObj.msg q
	.s INAdjId=RtnObj.rowid
	.
	.&sql(UPDATE DHC_INAdj SET INAD_No=:SPDNo WHERE INAD_RowId=:INAdjId)
	.
	.;自动审核
	.s ParamObj={},ParamObj.gUserId=UserId
	.s ParamStr=ParamObj.%ToJSON()
	.s RtnObj=##class(web.DHCSTMHUI.DHCINAdj).Audit(INAdjId,ParamStr)
	.i RtnObj.success<0 s RtnObj.msg="第"_i_"单,保存失败:"_RtnObj.msg q
	
	i RtnObj.success<0 tro  q RtnObj
	
	tc
	q RtnObj
}

/// Descript:	根据第三方批次id等信息获取已有批次,或新建批次信息
/// Creator:	wangjiabin
/// CreateDate:	2017-07-26
/// Input:		StrParam(DetailId^InciCode^LocCode^ExpDate^BatchNo^Rp^Sp)
/// 					第三方批次Id^库存项代码^科室代码^效期(Y-m-d)^批号^进价^售价
/// 			AdjBatchNo批次调价表单号
/// Return:		incib:成功, <0:失败
/// w ##class(web.DHCSTMService.HRPJson.STM2HRPServiceImpl).GetIncib("296^11051000519^1002110103^2018-12-31^^137.0300^137.0300","20170001")
ClassMethod GetIncib(StrParam As %String, AdjBatchNo As %String) As web.DHCSTMHUI.RtnObj [ Private ]
{
	n (StrParam,AdjBatchNo)
	s RtnObj=##class(web.DHCSTMHUI.RtnObj).%New()
	s DetailId=$p(StrParam,"^",1)
	s Inci=$p(StrParam,"^",2)
	s LocId=$p(StrParam,"^",3)
	s ExpDate=$p(StrParam,"^",4)
	s BatchNo=$p(StrParam,"^",5)
	s Rp=$p(StrParam,"^",6)
	s Sp=$p(StrParam,"^",7)
	s VendorId=$p(StrParam,"^",8)
	s UserId=$p(StrParam,"^",9)
	i (Inci="")||(LocId="") q RtnObj.Err(-1,"","批次生成参数错误!","",0)
	
	s HospId=$p(^CTLOC(LocId),"^",22)
	
	s Incib=""
	s orginRp=0
	i DetailId'="" d
	.s DHCIncib=$o(^DHCINCIB(0,"DetailId",DetailId,0))
	.q:DHCIncib=""
	.s Incib=$p(^DHCINCIB(DHCIncib),"^",1)
	.s orginRp=$p(^DHCINCIB(DHCIncib),"^",3)
	
	i (orginRp'=Rp)&&(Incib'="") d
	.s Incib=""
	
	ts
	
	;按基本单位处理
	s BUomId=$p(^INCI(Inci,1),"^",10)		;基本单位
	s ManfInfo=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetPbManf(Inci)
	s ManfId=$p(ManfInfo,"^",1)
	;(资金来源,具体规格,赠送,调价换票,灭菌批次,税率,生产日期,批次码)
	s (SourceOfFund,SpecDesc,GiftFlag,AdjCheque,SterilizedBat,Tax,ProduceDate,HVBarCode)=""
	s IncibParamObj={}
	d IncibParamObj.%Set("Inci",Inci).%Set("BatchNo",BatchNo).%Set("ExpDate",ExpDate).%Set("Rp",Rp).%Set("Sp",Sp)
	d IncibParamObj.%Set("UomId",BUomId).%Set("ManfId",ManfId).%Set("VendorId",VendorId).%Set("SourceOfFund",SourceOfFund).%Set("SpecDesc",SpecDesc)
	d IncibParamObj.%Set("GiftFlag",GiftFlag).%Set("AdjCheque",AdjCheque).%Set("SterilizedBat",SterilizedBat).%Set("DetailId",DetailId).%Set("Tax",Tax)
	d IncibParamObj.%Set("ProduceDate",ProduceDate).%Set("HVBarCode",HVBarCode)
	s NewIncibFlag="N"					;是否生成新批次
	s RtnObj=##class(web.DHCSTMHUI.DHCINGdRec).GetIncib(IncibParamObj,NewIncibFlag,"")
	i RtnObj.success<0 tro  q RtnObj
	s Incib=RtnObj.rowid
	
	;处理批次调价表
	s PriceInfo=##class(web.DHCSTMHUI.Common.PriceCommon).GetPriceByIncib(Incib,+$h,BUomId,HospId)
	s PriorRp=$p(PriceInfo,"^",1)
	s PriorSp=$p(PriceInfo,"^",2)
	
	i (PriorRp'=Rp)||(PriorSp'=Sp) {
		s PreExecuteDate=+$h
		s Remark="",AdjReasonId=""
		s AdjSPCat=$p(^INCI(Inci,2),"^",2)
		s DetailData=Incib_"^"_PreExecuteDate_"^"_Inci_"^"_BUomId_"^"_Sp_"^"_Rp_"^"_UserId_"^"_AdjReasonId_"^"_HospId_"^接口生成^"_PriorRp_"^"_PriorSp_"^"_AdjSPCat
		s DetailTitle="Incib^PreExecuteDate^Inci^AspUomId^ResultSpUom^ResultRpUom^gUserId^AdjReasonId^gHospId^Remark^PriorRpUom^PriorSpUom^AdjSPCat"
		s Detail=##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(DetailData,DetailTitle)
		s Detail="["_Detail_"]"
		
		s MainData=AdjBatchNo_"^"_LocId_"^"_UserId_"^"_HospId
		s MainTitle="AspNo^gLocId^gUserId^gHospId"
		s Main=##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(MainData,MainTitle)
		s RtnObj=##class(web.DHCSTMHUI.INAdjPriceBatch).Save(Main,Detail)
		i RtnObj.success'=0 tro  q RtnObj
		s AspBatId=RtnObj.rowid
		
		s Params=UserId_"^^"_LocId
		s RtnObj=##class(web.DHCSTMHUI.INAdjPriceBatch).Audit(AspBatId,Params)
		i RtnObj.success'=0 tro  q RtnObj
	}
	tc
	s RtnObj.rowid=Incib
	q RtnObj
}

/// Descript:	同步价格
/// Input:		
/// Output:		RtnObj
/// Return：
/// w ##class(web.DHCSTMService.HRPJson.STM2HRPServiceImpl).SynPriceData()
ClassMethod SynPriceData(Input, HospId) As web.DHCSTMHUI.RtnObj
{
	n (Input,HospId)
	
	s RtnObj=##class(web.DHCSTMHUI.RtnObj).%New()
	s BillArray=[].%FromJSON(Input)
	
	s Size=BillArray.%Size()
	i Size=0 q RtnObj.Err(-1,"","入参为空!","",0)
	
	ts
	f i=1:1:Size q:RtnObj.success<0  d
	.s ItmObj=BillArray.%Get(i-1)
	.s SPDNo=ItmObj.%Get("SPDNo")
	.s LocCode=ItmObj.%Get("LocCode")
	.s UserCode=ItmObj.%Get("UserCode")
	.
	.s LocId=##class(web.DHCSTMService.HRPJson.CommonInfo).GetLocId(LocCode)
	.s UserId=##class(web.DHCSTMService.HRPJson.CommonInfo).GetUserId(UserCode)
	.
	.i (SPDNo="")||($$ALPHAUP^SSUTIL4(SPDNo)="") d RtnObj.Err(-1,"","第"_i_"个单据,SPDNo为空","",0) q
	.i $d(^INASP(0,"ASPNO",$$ALPHAUP^SSUTIL4(SPDNo))) d RtnObj.Err(-1,"","第"_i_"个单据,该单据重复处理:"_SPDNo,"",0) q
	.i LocId="" d RtnObj.Err(-1,"","第"_i_"个单据,科室无效","",0) q
	.i UserId="" d RtnObj.Err(-1,"","第"_i_"个单据,人员无效","",0) q
	.s gHospId=$p(^CTLOC(LocId),"^",22)
	.i gHospId'="" s HospId=gHospId
	.
	.s MainObj={}
	.d MainObj.%Set("AdjspNo",SPDNo)
	.d MainObj.%Set("gLocId",LocId)
	.d MainObj.%Set("gHospId",HospId)
	.d MainObj.%Set("gUserId",UserId)
	.
	.s ListArr=ItmObj.%Get("List")
	.i ListArr="" d RtnObj.Err(-1,"","第"_i_"个单据,单据明细为空!","",0) q
	.s ListSize=ListArr.%Size()
	.i ListSize=0 d RtnObj.Err(-1,"","第"_i_"个单据,单据明细为空!","",0) q
	.
	.s DetailArr=[]
	.
	.f j=ListSize:-1:1 q:RtnObj.success<0  d
	..s PItmObj=ListArr.%Get(j-1)
	..
	..s InciCode=PItmObj.%Get("InciCode")
	..s UomDesc=PItmObj.%Get("UomDesc")
	..s PreExecuteDate=PItmObj.%Get("PreExecuteDate")
	..s PriorRp=PItmObj.%Get("PriorRp")
	..s PriorSp=PItmObj.%Get("PriorSp")
	..s ResultRp=PItmObj.%Get("ResultRp")
	..s ResultSp=PItmObj.%Get("ResultSp")
	..s WarrentNo=PItmObj.%Get("WarrentNo")
	..s WnoDate=PItmObj.%Get("WnoDate")
	..s Remarks=PItmObj.%Get("Remarks")
	..
	..s PreExeDateH=$zdh(PreExecuteDate,3)
	..s Inci=##class(web.DHCSTMService.HRPJson.CommonInfo).GetInciId(InciCode)
	..i Inci="" d RtnObj.Err(-1,"","第"_i_"单第"_j_"条,InciCode无效!","",0) q
	..
	..s BUomId=$p(^INCI(Inci,1),"^",10)
	..s PUomId=$p(^INCI(Inci,3),"^",6)
	..s InciDesc=$p(^INCI(Inci,1),"^",2)
	..s UomId=BUomId
	..i UomDesc'="" d
	...s UomId=##class(web.DHCSTMService.HRPJson.CommonInfo).GetUomId(UomDesc)
	..i (UomId'=BUomId)&&(UomId'=PUomId) d RtnObj.Err(-1,"","第"_i_"单第"_j_"条,单位与字典不符!","",0) q
	..
	..i PreExeDateH="" d RtnObj.Err(-1,"","第"_i_"单第"_j_"条,生效日期为空!","",0) q
	..i PreExeDateH<+$h d RtnObj.Err(-1,"","第"_i_"单第"_j_"条,生效日期不能小于当天!","",0) q
	..
	..s Rp=##class(web.DHCSTMHUI.Common.PriceCommon).GetInciBasicRp(Inci,+$h,UomId,HospId)
	..s Sp=##class(web.DHCSTMHUI.Common.PriceCommon).GetPriceElse(Inci,+$h,UomId,HospId)
	..;i (+Rp'=+PriorRp) d RtnObj.Err(-1,"","第"_i_"单第"_j_"条,调前进价不等!","",0) q
	..;i (+Sp'=+PriorSp) d RtnObj.Err(-1,"","第"_i_"单第"_j_"条,调前售价不等!","",0) q
	..
	..s DetailObj={}
	..d DetailObj.%Set("Inci",Inci)
	..d DetailObj.%Set("AspUomId",UomId)
	..d DetailObj.%Set("Description",InciDesc)
	..d DetailObj.%Set("AdjSPCat","接口调价")
	..d DetailObj.%Set("PreExecuteDate",PreExecuteDate)
	..d DetailObj.%Set("PriorRpUom",PriorRp)
	..d DetailObj.%Set("PriorSpUom",PriorSp)
	..d DetailObj.%Set("ResultRpUom",ResultRp)
	..d DetailObj.%Set("ResultSpUom",ResultSp)
	..d DetailObj.%Set("WarrentNo",WarrentNo)
	..d DetailObj.%Set("WnoDate",WnoDate)
	..d DetailObj.%Set("Remark",Remarks)
	..
	..d DetailArr.%Push(DetailObj)
	.q:RtnObj.success<0
	.
	.s MainStr=MainObj.%ToJSON()
	.s DetailStr=DetailArr.%ToJSON()
	.s RtnObj=##class(web.DHCSTMHUI.INAdjSalePrice).Update(MainStr,DetailStr)
	.i RtnObj.success<0 s RtnObj.msg="第"_i_"单,"_RtnObj.msg
	.q:RtnObj.success<0
	.
	.s AspIdStr=RtnObj.rowid
	.s AspIdStrLen=$l(AspIdStr,",")
	.f i=1:1:AspIdStrLen q:RtnObj.success'=0  d
	..s ExecuteDate=$p(^INASP(AspId),"^",2)
	..s AdjUserId=$p(^INASP(AspId),"^",3)
	..s RtnObj=##class(web.DHCSTMHUI.INAdjSalePrice).Audit(AspId,AdjUserId)
	.q:RtnObj.success<0
	
	i RtnObj.success<0 tro  q RtnObj
	
	tc
	q RtnObj
}

/// Description:批次价-调价方法
/// Input:		
/// Output:		RtnObj
/// Return：
/// zw ##class(web.DHCSTMService.HRPJson.STM2HRPServiceImpl).SynPriceBatch("[{""SPDNo"":""spdasp002"",""LocCode"":""163"",""UserCode"":""dthealth"",""List"":[{""StockDetailId"":""third-bat-2022-001"",""UomDesc"":""块"",""PreExecuteDate"":""2021-11-29"",""PriorRp"":1000,""PriorSp"":1000,""ResultRp"":1100,""ResultSp"":1200,""WarrentNo"":""20220601"",""WnoDate"":""2022-06-02"",""Remarks"":""testremarks""}]}]",2)
ClassMethod SynPriceBatch(Input, HospId) As web.DHCSTMHUI.RtnObj
{
	n (Input,HospId)
	s RtnObj=##class(web.DHCSTMHUI.RtnObj).%New()
	s BillArray=[].%FromJSON(Input)
	
	s Size=BillArray.%Size()
	i Size=0 q RtnObj.Err(-1,"","入参为空!","",0)
	
	ts
	f i=1:1:Size q:RtnObj.success<0  d
	.s ItmObj=BillArray.%Get(i-1)
	.s SPDNo=ItmObj.%Get("SPDNo")
	.s LocCode=ItmObj.%Get("LocCode")
	.s UserCode=ItmObj.%Get("UserCode")
	.
	.s LocId=##class(web.DHCSTMService.HRPJson.CommonInfo).GetLocId(LocCode)
	.s UserId=##class(web.DHCSTMService.HRPJson.CommonInfo).GetUserId(UserCode)
	.
	.i (SPDNo="")||($$ALPHAUP^SSUTIL4(SPDNo)="") d RtnObj.Err(-1,"","第"_i_"个单据,SPDNo为空","",0) q
	.i $d(^INASP(0,"ASPNO",$$ALPHAUP^SSUTIL4(SPDNo))) d RtnObj.Err(-1,"","第"_i_"个单据,该单据重复处理:"_SPDNo,"",0) q
	.i LocId="" d RtnObj.Err(-1,"","第"_i_"个单据,科室无效","",0) q
	.i UserId="" d RtnObj.Err(-1,"","第"_i_"个单据,人员无效","",0) q
	.s gHospId=$p(^CTLOC(LocId),"^",22)
	.i gHospId'="" s HospId=gHospId
	.
	.s MainObj={}
	.d MainObj.%Set("AspNo",SPDNo)
	.d MainObj.%Set("gLocId",LocId)
	.d MainObj.%Set("gHospId",HospId)
	.d MainObj.%Set("gUserId",UserId)
	.
	.s ListArr=ItmObj.%Get("List")
	.i ListArr="" d RtnObj.Err(-1,"","第"_i_"个单据,单据明细为空!","",0) q
	.s ListSize=ListArr.%Size()
	.i ListSize=0 d RtnObj.Err(-1,"","第"_i_"个单据,单据明细为空!","",0) q
	.
	.s DetailArr=[]
	.
	.f j=ListSize:-1:1 q:RtnObj.success<0  d
	..s PItmObj=ListArr.%Get(j-1)
	..
	..s DetailId=PItmObj.%Get("StockDetailId")
	..s UomDesc=PItmObj.%Get("UomDesc")
	..s PreExecuteDate=PItmObj.%Get("PreExecuteDate")
	..s PriorRp=PItmObj.%Get("PriorRp")
	..s PriorSp=PItmObj.%Get("PriorSp")
	..s ResultRp=PItmObj.%Get("ResultRp")
	..s ResultSp=PItmObj.%Get("ResultSp")
	..s WarrentNo=PItmObj.%Get("WarrentNo")
	..s WnoDate=PItmObj.%Get("WnoDate")
	..s Remarks=PItmObj.%Get("Remarks")
	..
	..s Incib=..GetIncibByDetailId(DetailId)
	..s PreExeDateH=$zdh(PreExecuteDate,3)
	..i Incib="" d RtnObj.Err(-1,"","第"_i_"单第"_j_"条,StockDetailId无效!","",0) q
	..i PreExeDateH="" d RtnObj.Err(-1,"","第"_i_"单第"_j_"条,生效日期为空!","",0) q
	..i PreExeDateH<+$h d RtnObj.Err(-1,"","第"_i_"单第"_j_"条,生效日期不能小于当天!","",0) q
	..
	..s Inci=$p(Incib,"||",1)
	..s BUomId=$p(^INCI(Inci,1),"^",10)
	..s PUomId=$p(^INCI(Inci,3),"^",6)
	..s InciDesc=$p(^INCI(Inci,1),"^",2)
	..
	..s UomId=BUomId
	..i UomDesc'="" d
	...s UomId=##class(web.DHCSTMService.HRPJson.CommonInfo).GetUomId(UomDesc)
	..i (UomId'=BUomId)&&(UomId'=PUomId) d RtnObj.Err(-1,"","第"_i_"单第"_j_"条,单位与字典不符!","",0) q
	..
	..;s Rp=##class(web.DHCSTMHUI.Common.PriceCommon).GetInciBasicRp(Inci,+$h,UomId,HospId)
	..;s Sp=##class(web.DHCSTMHUI.Common.PriceCommon).GetPriceElse(Inci,+$h,UomId,HospId)
	..;i (+Rp'=+PriorRp) d RtnObj.Err(-1,"","第"_i_"单第"_j_"条,调前进价不等!","",0) q
	..;i (+Sp'=+PriorSp) d RtnObj.Err(-1,"","第"_i_"单第"_j_"条,调前售价不等!","",0) q
	..
	..s DetailObj={}
	..d DetailObj.%Set("Incib",Incib)
	..d DetailObj.%Set("Inci",Inci)
	..d DetailObj.%Set("AspUomId",UomId)
	..d DetailObj.%Set("AdjSPCat","接口调价")
	..d DetailObj.%Set("PreExecuteDate",PreExecuteDate)
	..d DetailObj.%Set("PriorRpUom",PriorRp)
	..d DetailObj.%Set("PriorSpUom",PriorSp)
	..d DetailObj.%Set("ResultRpUom",ResultRp)
	..d DetailObj.%Set("ResultSpUom",ResultSp)
	..d DetailObj.%Set("WarrentNo",WarrentNo)
	..d DetailObj.%Set("WnoDate",WnoDate)
	..d DetailObj.%Set("Remark",Remarks)
	..
	..d DetailArr.%Push(DetailObj)
	.q:RtnObj.success<0
	.
	.s MainStr=MainObj.%ToJSON()
	.s DetailStr=DetailArr.%ToJSON()
	.s RtnObj=##class(web.DHCSTMHUI.INAdjPriceBatch).Save(MainStr,DetailStr)
	.i RtnObj.success<0 s RtnObj.msg="第"_i_"单,"_RtnObj.msg
	.q:RtnObj.success<0
	
	i RtnObj.success<0 tro  q RtnObj
	
	tc
	q RtnObj
}

/// Descript:	同步分类(库存分类)
/// Creator:	housc
/// CreateDate:	20220307
/// Input:	[{},{}]	
/// Return:	[0:"",1:失败信息]
/// w ##class(web.DHCSTMService.HRPJson.STM2HRPServiceImpl).SynIncscData("[{""IncscCode"":""测试01"",""IncscDesc"":""测试01""},{""IncscCode"":""测试02"",""IncscDesc"":""测试02""}]",2)
ClassMethod SynIncscData(Input, HospId) As web.DHCSTMHUI.RtnObj
{
	n (Input,HospId)

	s RtnObj=##class(web.DHCSTMHUI.RtnObj).%New()
	s Array=[].%FromJSON(Input)
	
	s Size=Array.%Size()
	i Size=0 q RtnObj.Err(-1,"","入参为空!","",0)
	
	ts
	f i=1:1:Size q:RtnObj.success<0  d
	.s ItmObj=Array.%Get(i-1)
	.s IncscCode=ItmObj.%Get("IncscCode")
	.s IncscDesc=ItmObj.%Get("IncscDesc")
	.i IncscCode="" d RtnObj.Err(-1,"","第"_i_"个单据,代码无效","",0) q
	.i IncscDesc="" d RtnObj.Err(-2,"","第"_i_"个单据,名称无效","",0) q
	.s scgdr=..validScg(HospId)
	.i scgdr="" d RtnObj.Err(-2,"","第"_i_"个单据,顶级类组生成失败","",0) q
	.s stkcatDr=..validStkCat(IncscCode,IncscDesc,HospId,scgdr)
	.i stkcatDr="" d RtnObj.Err(-2,"","第"_i_"个单据,分类生成失败","",0) q
	i RtnObj.success<0 tro  q RtnObj
	tc
	q RtnObj
}

/// 验证类组(大类)
ClassMethod validScg(hospId As %String) As %String
{
	n (hospId)
	s code="HRPSCG"
	s desc="HRP耗材"
	s type="M"
	s rowid=""
	&sql(select scg_rowid into :scg from dhc_stkcatgroup where SCG_Code=:code and scg_type=:type)
	i SQLCODE d
	.;调用公共生成类组方法
	.s StrParam="SCG"_"^"_code_"^"_desc_"^"_""_"^"_"M"
	.s data=hospId_"^"_hospId
	.s title="gHospId^BDPHospital"
	.s HospObj=##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(data,title)
	.s ret=##class(web.DHCSTMHUI.MulStkCatGroup).Add(StrParam,HospObj)
	.q:ret'="" 
	.&sql(select scg_rowid into :nscg from dhc_stkcatgroup where SCG_Code=:code and scg_type=:type)
	.i SQLCODE d
	..s rowid=""
	.e  d
	..s rowid=nscg
	e  d
	.s rowid=+scg
	q rowid
}

/// 验证分类
ClassMethod validStkCat(code As %String, desc As %String, hospId As %String, scgdr As %String) As %String
{
	n (code,desc,hospId,scgdr)
	s type="M"
	s rowid=""
	&sql(select incsc_rowid into :scid from inc_stkcat where incsc_code=:code and INCSC_StkType=:type)
	i SQLCODE d
	.;调用公共生成分类方法
	.s StrParam="INCSC"_"^"_code_"^"_desc_"^"_scgdr_"^"_"M"
	.s data=hospId_"^"_hospId
	.s title="gHospId^BDPHospital"
	.s HospObj=##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(data,title)
	.s ret=##class(web.DHCSTMHUI.MulStkCatGroup).Add(StrParam,HospObj)
	.q:ret'="" 
	.&sql(select incsc_rowid into :nstkcat from inc_stkcat where incsc_code=:code and INCSC_StkType=:type)
	.i SQLCODE d
	..s rowid=""
	.e  d
	..s rowid=nstkcat
	e  d
	.&sql(update inc_stkcat set incsc_desc=:desc where incsc_code=:code)
	.s rowid=+scid
	q rowid
}

/// Descript:	同步供应商
/// CreateDate:	2021-11-18
/// Input:		[{},{}]
/// Return:		web.DHCSTMHUI.RtnObj
ClassMethod SaveVendorData(Input, HospId) As web.DHCSTMHUI.RtnObj
{
	n (Input,HospId)
	
	s RtnObj=##class(web.DHCSTMHUI.RtnObj).%New()
	s Array=[].%FromJSON(Input)
	
	s Size=Array.%Size()
	i Size=0 q RtnObj.Err(-1,"","入参为空!","",0)
	
	ts
	f i=1:1:Size q:RtnObj.success<0  d
	.s VendorObj=Array.%Get(i-1)
	.
	.s VenCode=VendorObj.%Get("VenCode")
	.s VenDesc=VendorObj.%Get("VenDesc")
	.s UseFlag=VendorObj.%Get("UseFlag")
	.s Abbrev=VendorObj.%Get("Abbrev")
	.s Tel=VendorObj.%Get("Tel")
	.s Address=VendorObj.%Get("Address")
	.
	.i VenCode="" d RtnObj.Err(-1,"","第"_i_"个供应商,代码为空!","",0) q
	.i VenDesc="" d RtnObj.Err(-1,"","第"_i_"个供应商,名称为空!","",0) q
	.
	.s VendorId=##class(web.DHCSTMService.HRPJson.CommonInfo).GetVendorId(VenCode)
	.s Status=$s(UseFlag="Y":"A",1:"S")
	.
	.s MainObj={}
	.d MainObj.%Set("RowId",VendorId)
	.d MainObj.%Set("VendorCode",VenCode)
	.d MainObj.%Set("VendorDesc",VenDesc)
	.d MainObj.%Set("Status",Status)
	.d MainObj.%Set("BDPHospital",HospId)
	.d MainObj.%Set("Abbrev",Abbrev)
	.d MainObj.%Set("Address",Address)
	.d MainObj.%Set("Tel",Tel)
	.
	.s BasicInfo=MainObj.%ToJSON()
	.s CheckInfo="{}"					;资质部分
	.s Ret=##class(web.DHCSTMHUI.APCVenNew).Save(BasicInfo,CheckInfo)
	.s RetObj={}.%FromJSON(Ret)
	.s RtnObj.success=RetObj.success,RtnObj.rowid=RetObj.rowid,RtnObj.msg=RetObj.msg
	
	i RtnObj.success<0 tro  q RtnObj
	
	tc
	q RtnObj
}

/// Descript:	同步生产厂家
/// Input:		[{},{}]	
/// Return:		RtnObj
/// 
ClassMethod SaveManfData(Input, HospId) As web.DHCSTMHUI.RtnObj
{
	n (Input,HospId)
	
	s RtnObj=##class(web.DHCSTMHUI.RtnObj).%New()
	s Array=[].%FromJSON(Input)
	
	s Size=Array.%Size()
	i Size=0 q RtnObj.Err(-1,"","入参为空!","",0)
	
	ts
	f i=1:1:Size q:RtnObj.success<0  d
	.s VendorObj=Array.%Get(i-1)
	.
	.s ManfCode=VendorObj.%Get("ManfCode")
	.s ManfDesc=VendorObj.%Get("ManfDesc")
	.s UseFlag=VendorObj.%Get("UseFlag")
	.s Tel=VendorObj.%Get("Tel")
	.s Address=VendorObj.%Get("Address")
	.
	.i ManfCode="" d RtnObj.Err(-1,"","第"_i_"个生产厂家,代码为空!","",0) q
	.i ManfDesc="" d RtnObj.Err(-1,"","第"_i_"个生产厂家,名称为空!","",0) q
	.
	.s ManfId=##class(web.DHCSTMService.HRPJson.CommonInfo).GetManfId(ManfCode)
	.s Status=$s(UseFlag="Y":"Y",1:"N")
	.
	.s MainObj={}
	.d MainObj.%Set("RowId",ManfId)
	.d MainObj.%Set("ManfCode",ManfCode)
	.d MainObj.%Set("ManfDesc",ManfDesc)
	.d MainObj.%Set("Status",Status)
	.d MainObj.%Set("BDPHospital",HospId)
	.d MainObj.%Set("Address",Address)
	.d MainObj.%Set("Tel",Tel)
	.
	.s MainInfo=MainObj.%ToJSON()
	.s Ret=##class(web.DHCSTMHUI.ItmManfNew).Save(MainInfo)
	.s RetObj={}.%FromJSON(Ret)
	.s RtnObj.success=RetObj.success,RtnObj.rowid=RetObj.rowid,RtnObj.msg=RetObj.msg
	
	i RtnObj.success<0 tro  q RtnObj
	
	tc
	q RtnObj
}

/// 生成入库单
/// w ##class(web.DHCSTMService.HRPJson.STM2HRPServiceImpl).SaveInGdRec
ClassMethod SaveInGdRec(Input) As web.DHCSTMHUI.RtnObj
{
	/*
[{
	VenCode: 供应商代码,
	RecLocCode: 入库科室代码,
	UserCode: 入库人员代码(工号),
	ToLocCode: 接收科室代码(如无可传空),
	SpdIngrNo: 入库单号,
	List:[
		{
			InciCode: 物资代码,
			StockDetailId: 第三方批次ID,
			Qty: 入库数量,
			UomDesc: 单位描述(如约定单位规则,可传空),
			Rp: 单价(可约定按基本单位),
			BatchNo: 批号,
			ExpDate: 效期(YYYY-mm-dd),
			ManfCode: 生产厂家代码,
			ProduceDate: 生产日期(YYYY-mm-dd),
			InvNo: 发票号,
			InvDate: 发票日期(YYYY-mm-dd)
		},
		{其他单据明细},
		...
	]
},{其他单据...}]
*/
	n (Input)
	
	s ServiceType=..%GetParameter("ServiceType")
	s RtnObj=##class(web.DHCSTMHUI.RtnObj).%New()
	s BillArray=[].%FromJSON(Input)
	
	s Size=BillArray.%Size()
	i Size=0 q RtnObj.Err(-1,"","入参为空!","",0)
	
	ts
	f i=1:1:Size q:RtnObj.success<0  d
	.s BillObj=BillArray.%Get(i-1)
	.
	.s VenCode=BillObj.%Get("VenCode")
	.s RecLocCode=BillObj.%Get("RecLocCode")
	.s UserCode=BillObj.%Get("UserCode")
	.s ToLocCode=BillObj.%Get("ToLocCode")
	.s SpdIngrNo=BillObj.%Get("SpdIngrNo")
	.s Remarks=BillObj.%Get("Remarks")
	.
	.s SpdIngrNoUpper=$$ALPHAUP^SSUTIL4(SpdIngrNo)
	.s VendorId=##class(web.DHCSTMService.HRPJson.CommonInfo).GetVendorId(VenCode)
	.s RecLocId=##class(web.DHCSTMService.HRPJson.CommonInfo).GetLocId(RecLocCode)
	.s UserId=##class(web.DHCSTMService.HRPJson.CommonInfo).GetUserId(UserCode)
	.s ToLocId=##class(web.DHCSTMService.HRPJson.CommonInfo).GetLocId(ToLocCode)
	.
	.i SpdIngrNoUpper="" d RtnObj.Err(-1,"","第"_i_"个单据,单号为空!","",0) q
	.i $d(^DHCINGR(0,"No",SpdIngrNoUpper)) d RtnObj.Err(-1,"","第"_i_"个单据,单号重复处理!","",0) q
	.i VendorId="" d RtnObj.Err(-1,"","第"_i_"个单据,供应商无效!","",0) q
	.i RecLocId="" d RtnObj.Err(-1,"","第"_i_"个单据,入库科室无效!","",0) q
	.i (UserCode'="")&&(UserId="") d RtnObj.Err(-1,"","第"_i_"个单据,入库人员无效!","",0) q
	.i (ToLocCode'="")&&(ToLocId="") d RtnObj.Err(-1,"","第"_i_"个单据,接收科室无效!","",0) q
	.s HospId=$p(^CTLOC(RecLocId),"^",22)
	.
	.s MainObj={}
	.d MainObj.%Set("Vendor",VendorId)
	.d MainObj.%Set("RecLoc",RecLocId)
	.d MainObj.%Set("ReqLocId",ToLocId)
	.d MainObj.%Set("InGrRemarks",Remarks)
	.d MainObj.%Set("SynBarcode",SpdIngrNo)
	.d MainObj.%Set("gUserId",UserId)
	.d MainObj.%Set("gHospId",HospId)
	.
	.s ItmArray=[]
	.
	.s ListArr=BillObj.%Get("List")
	.s ListSize=ListArr.%Size()
	.i ListSize=0 d RtnObj.Err(-1,"","第"_i_"个单据,单据明细为空!","",0) q
	.
	.f j=ListSize:-1:1 q:RtnObj.success<0  d
	..s PItmObj=ListArr.%Get(j-1)
	..s InciCode=PItmObj.%Get("InciCode")
	..s DetailId=PItmObj.%Get("StockDetailId")
	..s HVBarCode=PItmObj.%Get("HVBarCode")
	..s OriginalCode=PItmObj.%Get("OriginalCode")
	..s Qty=PItmObj.%Get("Qty")
	..s UomDesc=PItmObj.%Get("UomDesc")
	..s Rp=PItmObj.%Get("Rp")
	..s BatchNo=PItmObj.%Get("BatchNo")
	..s ExpDate=PItmObj.%Get("ExpDate")
	..s ManfCode=PItmObj.%Get("ManfCode")
	..s ProduceDate=PItmObj.%Get("ProduceDate")
	..s InvNo=PItmObj.%Get("InvNo")
	..s InvDate=PItmObj.%Get("InvDate")
	..s ThirdId=PItmObj.%Get("ThirdId")
	..
	..s ExpDateH=$s(ExpDate'="":$zdh(ExpDate,3),1:"")
	..s InciId=##class(web.DHCSTMService.HRPJson.CommonInfo).GetInciId(InciCode)
	..s ManfId=##class(web.DHCSTMService.HRPJson.CommonInfo).GetManfId(ManfCode)
	..i ThirdId="" d RtnObj.Err(-21,"","第"_i_"单第"_j_"条,单据明细ThirdId为空!","",0) q
	..i DetailId="" d RtnObj.Err(-21,"","第"_i_"单第"_j_"条,批次Id为空!","",0) q
	..i InciId="" d RtnObj.Err(-21,"","第"_i_"单第"_j_"条,InciCode无效!","",0) q
	..i (ManfCode'="")&&(ManfId="") d RtnObj.Err(-21,"","第"_i_"单第"_j_"条,生产厂家无效!","",0) q
	..s HVFlag=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncHighValueFlag(InciId)
	..i (HVFlag="Y")&&(HVBarCode="") d RtnObj.Err(-1,"","第"_i_"单第"_j_"条,高值条码为空!","",0) q
	..
	..s BUomId=$p(^INCI(InciId,1),"^",10)
	..s UomId=BUomId
	..
	..i HVBarCode'="" d
	...s RegStr=HVBarCode_"^"_InciId_"^"_Rp_"^"_BatchNo_"^"_ExpDateH_"^"_VendorId_"^"_ManfId_"^"_UserId_"^"_RecLocId_"^"_OriginalCode
	...s TrackId=..RegBarCode(RegStr,.ErrMsg)
	...i TrackId="" d RtnObj.Err(-1,"","第"_i_"单第"_j_"条,"_ErrMsg)
	..q:RtnObj.success<0
	..
	..s ItmObj={}
	..d ItmObj.%Set("IncId",InciId)
	..d ItmObj.%Set("DetailId",DetailId)
	..d ItmObj.%Set("HVBarCode",HVBarCode)
	..d ItmObj.%Set("BatchNo",BatchNo)
	..d ItmObj.%Set("ExpDate",ExpDate)
	..d ItmObj.%Set("ProduceDate",ProduceDate)
	..d ItmObj.%Set("ManfId",ManfId)
	..d ItmObj.%Set("IngrUomId",UomId)
	..d ItmObj.%Set("RecQty",Qty)
	..d ItmObj.%Set("Rp",Rp)
	..d ItmObj.%Set("Sp",Rp)
	..;d ItmObj.%Set("Remarks",InciId)
	..d ItmObj.%Set("InvNo",InvNo)
	..;d ItmObj.%Set("InvCode",InciId)
	..d ItmObj.%Set("InvDate",InvDate)
	..d ItmObj.%Set("ThirdCode",ServiceType)
	..d ItmObj.%Set("ThirdId",ThirdId)
	..
	..d ItmArray.%Push(ItmObj)
	.q:RtnObj.success<0
	.i ItmArray.%Size()=0 d RtnObj.Err(-21,"","第"_i_"单,明细为空!","",0) q
	.
	.s MainInfo=MainObj.%ToJSON()
	.s ListData=ItmArray.%ToJSON()
	.s RtnObj=##class(web.DHCSTMHUI.DHCINGdRec).Save(MainInfo,ListData)
	.i RtnObj.success<0 s RtnObj.msg="第"_i_"单,保存失败:"_RtnObj.msg q
	.
	.s IngrId=RtnObj.rowid
	.&sql(UPDATE DHC_INGdRec SET INGR_No=INGR_Backup3,INGR_Completed='Y' WHERE INGR_RowId=:IngrId)
	.
	.;自动审核
	.s AuditObj={},AuditObj.gUserId=UserId
	.s AuditParams=AuditObj.%ToJSON()
	.s RtnObj=##class(web.DHCSTMHUI.DHCINGdRec).Audit(IngrId,AuditParams,"Y")
	.i RtnObj.success<0 s RtnObj.msg="第"_i_"单,审核失败:"_RtnObj.msg q
	
	i RtnObj.success<0 tro  q RtnObj
	
	tc
	q RtnObj
}

/// 注册条码
ClassMethod RegBarCode(StrParam, ErrMsg)
{
	n (StrParam,ErrMsg)
	;BarCode_"^"_InciId_"^"_Rp_"^"_BatchNo_"^"_ExpDate_"^"_VendorId_"^"_ManfId_"^"_userid
	s BarCode=$p(StrParam,"^",1)
	s InciId=$p(StrParam,"^",2)
	s Rp=$p(StrParam,"^",3)
	s BatchNo=$p(StrParam,"^",4)
	s ExpDate=$p(StrParam,"^",5)			;+$h数字类型
	s VendorId=$p(StrParam,"^",6)
	s ManfId=$p(StrParam,"^",7)
	s CreateUser=$p(StrParam,"^",8)
	s LocId=$p(StrParam,"^",9)
	s OriginalCode=$p(StrParam,"^",10)
	s Inclb=$p(StrParam,"^",11)
	
	s:ExpDate["-" ExpDate=$zdh(ExpDate,3)
	i BarCode="" s ErrMsg="条码为空" q ""
	s TrackId=$o(^DHCIT(0,"LABEL",BarCode,""))
	i TrackId'="" s ErrMsg=BarCode_"条码重复" q ""
	
	s Incib=""
	i Inclb'="" d
	.s IL=$p(Inclb,"||",2),LB=$p(Inclb,"||",3)
	.s Incib=$p(^INCI(InciId,"IL",IL,"LB",LB),"^",1)
	
	s Date=+$h,Time=$p($h,",",2)
	s Obj=##class(User.DHCItmTrack).%New()
	d Obj.DHCITINCIDRSetObjectId(InciId)
	s Obj.DHCITLabel=BarCode
	s Obj.DHCITDate=Date
	s Obj.DHCITTime=Time
	d Obj.DHCITSSUSRDRSetObjectId(CreateUser)
	d Obj.DHCITINCLBDRSetObjectId(Inclb)
	d Obj.DHCITINCIBDRSetObjectId(Incib)
	d Obj.DHCITPHMNFDRSetObjectId(ManfId)
	s Obj.DHCITRealPrice=Rp
	s Obj.DHCITBatchNo=BatchNo
	s Obj.DHCITExpDate=ExpDate
	d Obj.DHCITAPCVMDRSetObjectId(VendorId)
	;s Obj.DHCITOrderDetailSubId=OrderDetailSubId
	d Obj.DHCITOwnLocDRSetObjectId(LocId)
	s Obj.DHCITOldOriginalBarcode=OriginalCode
	s Sc=Obj.%Save()
	i $$$ISERR(Sc) s ErrMsg=BarCode_"条码注册失败" q ""
	
	s RowId=Obj.%Id()
	q RowId
}

/// 更新发票信息
ClassMethod SynInvInfo(Input) As web.DHCSTMHUI.RtnObj
{
	n (Input)
	
	s ServiceType=..%GetParameter("ServiceType")
	s SetDate=+$h
	s RtnObj=##class(web.DHCSTMHUI.RtnObj).%New()
	s Array=[].%FromJSON(Input)
	
	s Size=Array.%Size()
	i Size=0 q RtnObj.Err(-1,"","入参为空!","",0)
	
	ts
	f i=1:1:Size q:RtnObj.success<0  d
	.s ItmObj=Array.%Get(i-1)
	.
	.s ThirdId=ItmObj.%Get("ThirdId")		;第三方单据明细id
	.s Type=ItmObj.%Get("Type")				;G-入库单, R-退货单
	.s InvNo=ItmObj.%Get("InvNo")			;发票号码
	.s InvCode=ItmObj.%Get("InvCode")		;发票代码
	.s InvDate=ItmObj.%Get("InvDate")		;发票日期
	.
	.s InvDateH=$s(InvDate'="":$zdh(InvDate,3),1:"")
	.s Pointer=##class(web.DHCSTMHUI.DHCServiceBill).GetPointer(ServiceType,Type,ThirdId)
	.
	.i (Type'="G")&&(Type'="R") d RtnObj.Err(-1,"","第"_i_"条,单据类型有误!","",0) q
	.i Pointer="" d RtnObj.Err(-1,"","第"_i_"条,单据信息不存在!","",0) q
	.
	.s MainId=$p(Pointer,"||",1),MainCh=$p(Pointer,"||",2)
	.q:(Type="G")&&'$d(^DHCINGR(MainId,"GRI",MainCh))
	.q:(Type="R")&&'$d(^INGRT(MainId,"DHCGRR",MainCh))
	.
	.i Type="G" d
	..&sql(UPDATE DHC_INGdRecItm
		SET initm_invno=:InvNo, initm_InvCode=:InvCode, initm_invdate=:InvDateH, initm_InvSetDate=:SetDate
		WHERE %id=:Pointer)
	.e  i Type="R" d
	..&sql(UPDATE DHC_INGRTITM
		SET INGRTI_InvNo=:InvNo, INGRTI_InvCode=:InvCode, INGRTI_InvDate=:InvDateH, INGRTI_InvSetDate=:SetDate
		WHERE %id=:Pointer)
	.i SQLCODE<0 d RtnObj.Err(-1,"","第"_i_"条,"_ThirdId_"更新发票失败","",0) q
	
	i RtnObj.success<0 tro  q RtnObj
	
	tc
	q RtnObj
}

/// 根据DetailId获取相关信息
ClassMethod GetIncibByDetailId(DetailId) As %String
{
	n (DetailId)
	q:DetailId="" ""
	
	s Incib=""
	s DHCIncib=$o(^DHCINCIB(0,"DetailId",DetailId,0))
	i DHCIncib'="" d
	.s Incib=$p(^DHCINCIB(DHCIncib),"^",1)
	
	q Incib
}

/// w ##class(web.DHCSTMService.HRPJson.STM2HRPServiceImpl).GetInclbByIncibAndLoc("1002||1",77)
ClassMethod GetInclbByIncibAndLoc(Incib, LocId, CreateFlag = "")
{
	n (Incib,LocId,CreateFlag)
	q:(Incib="")||(LocId="") ""
	s Inci=$p(Incib,"||",1)
	q:Inci="" ""
	
	s Inclb=""
	s IL=0
	f  s IL=$o(^INCI("LB_IB",Incib,Inci,IL)) q:(IL="")||(Inclb'="")  d
	.s ILLoc=$p(^INCI(Inci,"IL",IL),"^",1)
	.q:LocId'=ILLoc
	.s Incil=Inci_"||"_IL
	.s LB=$o(^INCI("LB_IB",Incib,Inci,IL,0))
	.q:LB=""
	.s Inclb=Incil_"||"_LB
	
	;CreateFlag="Y",可自动生成Inclb
	i (Inclb="")&&(CreateFlag="Y") d
	.s IL=$o(^INCI("IL_LOC",LocId,Inci,0))
	.i IL="" d
	..&sql(insert into inc_itmloc(INCIL_INCI_ParRef,INCIL_CTLOC_DR,INCIL_LogQty) values (:Inci,:LocId,0))
	..q:SQLCODE'=0
	..s Incil=$p(%ROWID,$c(1))
	.e  d
	..s Incil=Inci_"||"_IL
	.q:Incil=""
	.
	.s Inclb=##class(web.DHCSTMHUI.Common.StockHandle).InsertIncItmLcBt(Incil,Incib,0)
	
	q Inclb
}

ClassMethod SaveInIsTrf(Input) As web.DHCSTMHUI.RtnObj
{
	/*
[{
	SPDNo: SPD出库单号,
	FromLocCode:  出库科室代码(发放科室),
	ToLocCode: 接收科室代码,
	UserCode: 入库人员代码(工号),
	ReqUserCode: 接收人员代码(工号,如无可传空),
	Remarks: 备注,
	List:[
		{
			StockDetailId: 第三方批次ID, 其他物资代码,批号效期等均不需传递,以此DetailId为准.
			Qty: 入库数量,
			UomDesc: 单位描述(如约定单位规则,可传空)
		},
		{其他单据明细},
		...
	]
},
{其他单据...}]
*/
	n (Input)
	s ServiceType=..%GetParameter("ServiceType")
	s RtnObj=##class(web.DHCSTMHUI.RtnObj).%New()
	s BillArray=[].%FromJSON(Input)
	
	s Size=BillArray.%Size()
	i Size=0 q RtnObj.Err(-1,"","入参为空!","",0)
	
	ts
	f i=1:1:Size q:RtnObj.success<0  d
	.s BillObj=BillArray.%Get(i-1)
	.
	.s SPDNo=BillObj.%Get("SPDNo")
	.s FromLocCode=BillObj.%Get("FromLocCode")
	.s ToLocCode=BillObj.%Get("ToLocCode")
	.s UserCode=BillObj.%Get("UserCode")
	.s Remarks=BillObj.%Get("Remarks")
	.s ReqUserCode=BillObj.%Get("ReqUserCode")
	.
	.s SPDNoUpper=$$ALPHAUP^SSUTIL4(SPDNo)
	.s FromLocId=##class(web.DHCSTMService.HRPJson.CommonInfo).GetLocId(FromLocCode)
	.s ToLocId=##class(web.DHCSTMService.HRPJson.CommonInfo).GetLocId(ToLocCode)
	.s UserId=##class(web.DHCSTMService.HRPJson.CommonInfo).GetUserId(UserCode)
	.s ReqUserId=##class(web.DHCSTMService.HRPJson.CommonInfo).GetUserId(ReqUserCode)
	.
	.i SPDNoUpper="" d RtnObj.Err(-1,"","第"_i_"个单据,单号为空!","",0) q
	.i $d(^DHCINIT(0,"No",SPDNoUpper)) d RtnObj.Err(-1,"","第"_i_"个单据,单号重复处理!","",0) q
	.i FromLocId="" d RtnObj.Err(-1,"","第"_i_"个单据,出库科室无效!","",0) q
	.i ToLocId="" d RtnObj.Err(-1,"","第"_i_"个单据,接收科室无效!","",0) q
	.i (UserCode'="")&&(UserId="") d RtnObj.Err(-1,"","第"_i_"个单据,出库人员无效!","",0) q
	.i (ReqUserCode'="")&&(ReqUserId="") d RtnObj.Err(-1,"","第"_i_"个单据,接收人员无效!","",0) q
	.s HospId=$p(^CTLOC(FromLocId),"^",22)
	.
	.s MainObj={}
	.d MainObj.%Set("InitFrLoc",FromLocId)
	.d MainObj.%Set("InitToLoc",ToLocId)
	.d MainObj.%Set("InitUser",UserId)
	.d MainObj.%Set("InitRemarks",Remarks)
	.d MainObj.%Set("InitReqUser",ReqUserId)
	.d MainObj.%Set("gHospId",HospId)
	.d MainObj.%Set("InitState",10)
	.d MainObj.%Set("InitComp","Y")		;保存为"完成"状态
	.
	.s ItmArray=[]
	.
	.s ListArr=BillObj.%Get("List")
	.s ListSize=ListArr.%Size()
	.i ListSize=0 d RtnObj.Err(-1,"","第"_i_"个单据,单据明细为空!","",0) q
	.
	.f j=ListSize:-1:1 q:RtnObj.success<0  d
	..s PItmObj=ListArr.%Get(j-1)
	..s DetailId=PItmObj.%Get("StockDetailId")
	..s Qty=PItmObj.%Get("Qty")
	..s UomDesc=PItmObj.%Get("UomDesc")
	..s HVBarCode=PItmObj.%Get("HVBarCode")
	..s ThirdId=PItmObj.%Get("ThirdId")
	..
	..i ((HVBarCode'="")&&(Qty'=1)) d RtnObj.Err(-1,"","第"_i_"单第"_j_"条,高值条码数量不符","",0) q
	..i HVBarCode'="" d
	...s BarCodeInfo=##class(web.DHCSTMHUI.DHCItmTrack).GetItmByBarcode(HVBarCode)
	...s BarCodeObj={}.%FromJSON(BarCodeInfo)
	...s BarCodeStatus=BarCodeObj.Status
	...i (BarCodeStatus'="Enable") d RtnObj.Err(-1,"","第"_i_"单第"_j_"条,条码状态不符","",0) q
	..q:RtnObj.success<0
	..
	..;添加DetailId的判断
	..s Incib=..GetIncibByDetailId(DetailId)
	..s Inclb=..GetInclbByIncibAndLoc(Incib,FromLocId)
	..
	..i DetailId="" d RtnObj.Err(-21,"","第"_i_"单第"_j_"条,批次Id为空!","",0) q
	..i (DetailId'="")&&(Incib="") d RtnObj.Err(-21,"","第"_i_"单第"_j_"条,DetailId无效!","",0) q
	..i (Inclb="") d RtnObj.Err(-21,"","第"_i_"单第"_j_"条,DetailId无效!","",0) q
	..
	..s InciId=$p(Inclb,"||",1)
	..s BUomId=$p(^INCI(InciId,1),"^",10)
	..s UomId=BUomId
	..s HVFlag=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncHighValueFlag(InciId)
	..i (HVFlag="Y")&&(HVBarCode="") d RtnObj.Err(-1,"","第"_i_"单第"_j_"条,高值条码为空!","",0) q
	..
	..s ItmObj={}
	..d ItmObj.%Set("Inclb",Inclb)
	..d ItmObj.%Set("Qty",Qty)
	..d ItmObj.%Set("UomId",UomId)
	..d ItmObj.%Set("HVBarCode",HVBarCode)
	..d ItmObj.%Set("ThirdCode",ServiceType)
	..d ItmObj.%Set("ThirdId",ThirdId)
	..
	..d ItmArray.%Push(ItmObj)
	.q:RtnObj.success<0
	.i ItmArray.%Size()=0 d RtnObj.Err(-21,"","第"_i_"单,明细为空!","",0) q
	.
	.s MainInfo=MainObj.%ToJSON()
	.s ListData=ItmArray.%ToJSON()
	.s RtnObj=##class(web.DHCSTMHUI.DHCINIsTrf).Save(MainInfo,ListData)
	.i RtnObj.success<0 s RtnObj.msg="第"_i_"单,保存失败:"_RtnObj.msg q
	.
	.s InitId=RtnObj.rowid
	.&sql(UPDATE DHC_InIsTrf SET INIT_No=:SPDNo WHERE INIT_RowId=:InitId)
	.
	.s AutoAuditFlag="N",AutoAuditInFlag="Y"
	.;自动完成
	.s RtnObj=##class(web.DHCSTMHUI.DHCINIsTrf).SetCompleted(InitId,AutoAuditFlag)
	.i RtnObj.success<0 s RtnObj.msg="第"_i_"单,保存失败:"_RtnObj.msg q
	.;自动审核
	.s RtnObj=##class(web.DHCSTMHUI.DHCINIsTrf).TransOutAuditYes(InitId,UserId,"",AutoAuditInFlag)
	.i RtnObj.success<0 s RtnObj.msg="第"_i_"单,保存失败:"_RtnObj.msg q
	
	i RtnObj.success<0 tro  q RtnObj
	
	tc
	q RtnObj
}

ClassMethod SaveIngdRet(Input) As web.DHCSTMHUI.RtnObj
{
	/*
[{
	SPDNo: SPD退货单号,
	LocCode:  科室代码(退货库房),
	VenCode: 供应商代码,
	UserCode: 制单人员代码(工号),
	Remarks: 备注,
	List:[
		{
			StockDetailId: 第三方批次ID, 其他物资代码,批号效期等均不需传递,以此DetailId为准.
			HVBarCode: 高值条码,
			Qty: 入库数量,
			UomDesc: 单位描述(如约定单位规则,可传空),
			RKItmId: SPD入库明细id
		},
		{其他单据明细},
		...
	]
},
{其他单据...}]
*/
	n (Input)
	s ServiceType=..%GetParameter("ServiceType")
	s RtnObj=##class(web.DHCSTMHUI.RtnObj).%New()
	s BillArray=[].%FromJSON(Input)
	
	s Size=BillArray.%Size()
	i Size=0 q RtnObj.Err(-1,"","入参为空!","",0)
	
	ts
	f i=1:1:Size q:RtnObj.success<0  d
	.s BillObj=BillArray.%Get(i-1)
	.
	.s SPDNo=BillObj.%Get("SPDNo")
	.s LocCode=BillObj.%Get("LocCode")
	.s VenCode=BillObj.%Get("VenCode")
	.s UserCode=BillObj.%Get("UserCode")
	.s Remarks=BillObj.%Get("Remarks")
	.
	.s SPDNoUpper=$$ALPHAUP^SSUTIL4(SPDNo)
	.s LocId=##class(web.DHCSTMService.HRPJson.CommonInfo).GetLocId(LocCode)
	.s VendorId=##class(web.DHCSTMService.HRPJson.CommonInfo).GetVendorId(VenCode)
	.s UserId=##class(web.DHCSTMService.HRPJson.CommonInfo).GetUserId(UserCode)
	.
	.i SPDNoUpper="" d RtnObj.Err(-1,"","第"_i_"个单据,单号为空!","",0) q
	.i $d(^INGRT(0,"RETNO",SPDNoUpper)) d RtnObj.Err(-1,"","第"_i_"个单据,单号重复处理!","",0) q
	.i LocId="" d RtnObj.Err(-1,"","第"_i_"个单据,科室无效!","",0) q
	.i VendorId="" d RtnObj.Err(-1,"","第"_i_"个单据,供应商无效!","",0) q
	.i (UserCode'="")&&(UserId="") d RtnObj.Err(-1,"","第"_i_"个单据,人员无效!","",0) q
	.s HospId=$p(^CTLOC(LocId),"^",22)
	.
	.s MainObj={}
	.d MainObj.%Set("RetLoc",LocId)
	.d MainObj.%Set("Vendor",VendorId)
	.d MainObj.%Set("gHospId",HospId)
	.d MainObj.%Set("gUserId",UserId)
	.d MainObj.%Set("Remarks",Remarks)
	.
	.s ItmArray=[]
	.
	.s ListArr=BillObj.%Get("List")
	.s ListSize=ListArr.%Size()
	.i ListSize=0 d RtnObj.Err(-1,"","第"_i_"个单据,单据明细为空!","",0) q
	.
	.f j=ListSize:-1:1 q:RtnObj.success<0  d
	..s PItmObj=ListArr.%Get(j-1)
	..s DetailId=PItmObj.%Get("StockDetailId")
	..s Qty=PItmObj.%Get("Qty")
	..s UomDesc=PItmObj.%Get("UomDesc")
	..s HVBarCode=PItmObj.%Get("HVBarCode")
	..s ThirdId=PItmObj.%Get("ThirdId")			;退货明细,第三方id
	..s RKThirdId=PItmObj.%Get("RKItemId")		;入库明细,第三方id
	..
	..s Ingri=##class(web.DHCSTMHUI.DHCServiceBill).GetPointer(ServiceType,"G",RKThirdId)
	..;i RKThirdId="" d RtnObj.Err(-21,"","第"_i_"单第"_j_"条,入库明细id为空!","",0) q
	..i (RKThirdId'="")&&(Ingri="") d RtnObj.Err(-21,"","第"_i_"单第"_j_"条,入库明细id无效!","",0) q
	..
	..i HVBarCode'="" d
	...i Qty'=1 d RtnObj.Err(-1,"","第"_i_"单第"_j_"条,高值条码数量不符","",0) q
	...s BarCodeInfo=##class(web.DHCSTMHUI.DHCItmTrack).GetItmByBarcode(HVBarCode)
	...s BarCodeObj={}.%FromJSON(BarCodeInfo)
	...s BarCodeStatus=BarCodeObj.Status
	...i (BarCodeStatus'="Enable") d RtnObj.Err(-1,"","第"_i_"单第"_j_"条,条码状态不符","",0) q
	..q:RtnObj.success<0
	..
	..;添加DetailId的判断
	..s Incib=..GetIncibByDetailId(DetailId)
	..s Inclb=..GetInclbByIncibAndLoc(Incib,LocId)
	..
	..i DetailId="" d RtnObj.Err(-21,"","第"_i_"单第"_j_"条,批次Id为空!","",0) q
	..i (DetailId'="")&&(Incib="") d RtnObj.Err(-21,"","第"_i_"单第"_j_"条,DetailId无效!","",0) q
	..i (Inclb="") d RtnObj.Err(-21,"","第"_i_"单第"_j_"条,DetailId无效!","",0) q
	..
	..i Ingri'="" d
	...s IngriInclb=$p(^DHCINGR(+Ingri,"GRI",$p(Ingri,"||",2)),"^",1)
	...i IngriInclb'=Inclb d RtnObj.Err(-1,"","第"_i_"单第"_j_"条,DetailId与入库明细记录不符!","",0) q
	..q:RtnObj.success<0
	..
	..s InciId=$p(Inclb,"||",1)
	..s BUomId=$p(^INCI(InciId,1),"^",10)
	..s UomId=BUomId
	..s Rp=##class(web.DHCSTMHUI.Common.PriceCommon).GetClbRp(Inclb,UomId,HospId)
	..s Sp=##class(web.DHCSTMHUI.Common.PriceCommon).GetPriceElse(Inclb,+$h,UomId,HospId)
	..s RpAmt=Rp*Qty
	..s HVFlag=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncHighValueFlag(InciId)
	..i (HVFlag="Y")&&(HVBarCode="") d RtnObj.Err(-1,"","第"_i_"单第"_j_"条,高值条码为空!","",0) q
	..
	..s ItmObj={}
	..d ItmObj.%Set("Ingri",Ingri)
	..d ItmObj.%Set("Inclb",Inclb)
	..d ItmObj.%Set("Qty",Qty)
	..d ItmObj.%Set("Uom",UomId)
	..d ItmObj.%Set("HvBarCode",HVBarCode)
	..d ItmObj.%Set("Rp",Rp)
	..d ItmObj.%Set("Sp",Sp)
	..d ItmObj.%Set("InvAmt",RpAmt)
	..d ItmObj.%Set("ThirdCode",ServiceType)
	..d ItmObj.%Set("ThirdId",ThirdId)
	..
	..d ItmArray.%Push(ItmObj)
	.q:RtnObj.success<0
	.i ItmArray.%Size()=0 d RtnObj.Err(-21,"","第"_i_"单,明细为空!","",0) q
	.
	.s MainInfo=MainObj.%ToJSON()
	.s ListData=ItmArray.%ToJSON()
	.s RtnObj=##class(web.DHCSTMHUI.DHCINGdRet).Save(MainInfo,ListData)
	.i RtnObj.success<0 s RtnObj.msg="第"_i_"单,保存失败:"_RtnObj.msg q
	.
	.s IngrtId=RtnObj.rowid
	.&sql(UPDATE DHC_INGDRET SET INGRT_NO=:SPDNo,INGRT_Completed='Y' WHERE INGRT_RowId=:IngrtId)
	.
	.s AuditFlag=$p(^INGRT(IngrtId),"^",7)
	.i AuditFlag'="Y" d
	..s AuditObj={}
	..d AuditObj.%Set("RowId",IngrtId)
	..d AuditObj.%Set("UserId",UserId)
	..d AuditObj.%Set("gHospId",HospId)
	..s AuditStr=AuditObj.%ToJSON()
	..s RtnObj=##class(web.DHCSTMHUI.DHCINGdRet).Audit(AuditStr)
	..i RtnObj.success<0 s RtnObj.msg="第"_i_"单,保存失败:"_RtnObj.msg q
	
	i RtnObj.success<0 tro  q RtnObj
	
	tc
	q RtnObj
}

/// 生成入库单
/// w ##class(web.DHCSTMService.HRPJson.STM2HRPServiceImpl).SaveIngrInit
ClassMethod SaveIngrInit(Input) As web.DHCSTMHUI.RtnObj
{
	/*
[{
	VenCode: 供应商代码,
	RecLocCode: 入库科室代码,
	UserCode: 入库人员代码(工号),
	ToLocCode: 接收科室代码(如无可传空),
	SpdIngrNo: 入库单号,
	List:[
		{
			InciCode: 物资代码,
			StockDetailId: 第三方批次ID,
			Qty: 入库数量,
			UomDesc: 单位描述(如约定单位规则,可传空),
			Rp: 单价(可约定按基本单位),
			BatchNo: 批号,
			ExpDate: 效期(YYYY-mm-dd),
			ManfCode: 生产厂家代码,
			ProduceDate: 生产日期(YYYY-mm-dd),
			InvNo: 发票号,
			InvDate: 发票日期(YYYY-mm-dd)
		},
		{其他单据明细},
		...
	]
},{其他单据...}]
*/
	n (Input)
	
	s ServiceType=..%GetParameter("ServiceType")
	s RtnObj=##class(web.DHCSTMHUI.RtnObj).%New()
	s BillArray=[].%FromJSON(Input)
	
	s Size=BillArray.%Size()
	i Size=0 q RtnObj.Err(-1,"","入参为空!","",0)
	
	s KeyArr=[]
	
	;ts
	f i=1:1:Size d
	.ts
	.s BillObj=BillArray.%Get(i-1)
	.
	.i BillObj="" d
	..d RtnObj.Err(-1,"","第"_i_"个单据,单据内容为空!","",0) q
	.e  d
	..s VenCode=BillObj.%Get("VenCode")
	..s RecLocCode=BillObj.%Get("RecLocCode")
	..s UserCode=BillObj.%Get("UserCode")
	..s ToLocCode=BillObj.%Get("ToLocCode")
	..s SpdIngrNo=BillObj.%Get("SpdIngrNo")
	..s Remarks=BillObj.%Get("Remarks")
	..
	..s SpdIngrNoUpper=$$ALPHAUP^SSUTIL4(SpdIngrNo)
	..s VendorId=##class(web.DHCSTMService.HRPJson.CommonInfo).GetVendorId(VenCode)
	..s RecLocId=##class(web.DHCSTMService.HRPJson.CommonInfo).GetLocId(RecLocCode)
	..s UserId=##class(web.DHCSTMService.HRPJson.CommonInfo).GetUserId(UserCode)
	..s ToLocId=##class(web.DHCSTMService.HRPJson.CommonInfo).GetLocId(ToLocCode)
	..
	..i SpdIngrNoUpper="" d RtnObj.Err(-1,"","第"_i_"个单据,单号为空!","",0) q
	..i $d(^DHCINGR(0,"No",SpdIngrNoUpper)) d RtnObj.Err(-1,"","第"_i_"个单据,单号重复处理!","",0) q
	..i VendorId="" d RtnObj.Err(-1,"","第"_i_"个单据,供应商无效!","",0) q
	..i RecLocId="" d RtnObj.Err(-1,"","第"_i_"个单据,入库科室无效!","",0) q
	..i (UserCode'="")&&(UserId="") d RtnObj.Err(-1,"","第"_i_"个单据,入库人员无效!","",0) q
	..i ToLocId="" d RtnObj.Err(-1,"","第"_i_"个单据,接收科室无效!","",0) q
	..i RecLocId=ToLocId d RtnObj.Err(-1,"","第"_i_"个单据,入库科室与接收科室不能相同!","",0) q
	..s HospId=$p(^CTLOC(RecLocId),"^",22)
	..
	..s MainObj={}
	..d MainObj.%Set("Vendor",VendorId)
	..d MainObj.%Set("RecLoc",RecLocId)
	..d MainObj.%Set("ReqLocId",ToLocId)
	..d MainObj.%Set("InGrRemarks",Remarks)
	..d MainObj.%Set("SynBarcode",SpdIngrNo)
	..d MainObj.%Set("gUserId",UserId)
	..d MainObj.%Set("gHospId",HospId)
	..
	..s MainInfo=MainObj.%ToJSON()
	..s RtnObj=##class(web.DHCSTMHUI.DHCINGdRec).Insert(MainInfo)
	..i RtnObj.success<0 d RtnObj.Err(-1,"","第"_i_"个单据,保存入库单失败:"_RtnObj.msg,"",0) q
	..s IngrId=RtnObj.rowid
	..
	..s ItmArray=[]
	..
	..s ListArr=BillObj.%Get("List")
	..s ListSize=ListArr.%Size()
	..i ListSize=0 d RtnObj.Err(-1,"","第"_i_"个单据,单据明细为空!","",0) q
	..
	..f j=ListSize:-1:1 q:RtnObj.success<0  d
	...s PItmObj=ListArr.%Get(j-1)
	...s InciCode=PItmObj.%Get("InciCode")
	...s DetailId=PItmObj.%Get("StockDetailId")
	...s HVBarCode=PItmObj.%Get("HVBarCode")
	...s Qty=PItmObj.%Get("Qty")
	...s UomDesc=PItmObj.%Get("UomDesc")
	...s Rp=PItmObj.%Get("Rp")
	...s BatchNo=PItmObj.%Get("BatchNo")
	...s ExpDate=PItmObj.%Get("ExpDate")
	...s ManfCode=PItmObj.%Get("ManfCode")
	...s ProduceDate=PItmObj.%Get("ProduceDate")
	...s InvNo=PItmObj.%Get("InvNo")
	...s InvDate=PItmObj.%Get("InvDate")
	...s ThirdId=PItmObj.%Get("ThirdId")
	...
	...s InciId=##class(web.DHCSTMService.HRPJson.CommonInfo).GetInciId(InciCode)
	...s ManfId=##class(web.DHCSTMService.HRPJson.CommonInfo).GetManfId(ManfCode)
	...i ThirdId="" d RtnObj.Err(-21,"","第"_i_"单第"_j_"条,单据明细ThirdId为空!","",0) q
	...i DetailId="" d RtnObj.Err(-21,"","第"_i_"单第"_j_"条,批次Id为空!","",0) q
	...i InciId="" d RtnObj.Err(-21,"","第"_i_"单第"_j_"条,InciCode无效!","",0) q
	...i (ManfCode'="")&&(ManfId="") d RtnObj.Err(-21,"","第"_i_"单第"_j_"条,生产厂家无效!","",0) q
	...s HVFlag=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncHighValueFlag(InciId)
	...i (HVFlag="Y")&&(HVBarCode="") d RtnObj.Err(-1,"","第"_i_"单第"_j_"条,高值条码为空!","",0) q
	...
	...s BUomId=$p(^INCI(InciId,1),"^",10)
	...s UomId=BUomId
	...
	...i HVBarCode'="" d
	....s DHCIT=$o(^DHCIT(0,"LABEL",HVBarCode,0))
	....i DHCIT="" d RtnObj.Err(-1,"","第"_i_"单第"_j_"条,高值条码不存在!","",0) q
	...q:RtnObj.success<0
	...
	...s ItmObj={}
	...d ItmObj.%Set("IncId",InciId)
	...d ItmObj.%Set("DetailId",DetailId)
	...;d ItmObj.%Set("HVBarCode",HVBarCode)			;补录时,不传递高值条码
	...d ItmObj.%Set("BatchNo",BatchNo)
	...d ItmObj.%Set("ExpDate",ExpDate)
	...d ItmObj.%Set("ProduceDate",ProduceDate)
	...d ItmObj.%Set("ManfId",ManfId)
	...d ItmObj.%Set("IngrUomId",UomId)
	...d ItmObj.%Set("RecQty",Qty)
	...d ItmObj.%Set("Rp",Rp)
	...d ItmObj.%Set("Sp",Rp)
	...d ItmObj.%Set("Remarks",HVBarCode)
	...d ItmObj.%Set("InvNo",InvNo)
	...d ItmObj.%Set("InvDate",InvDate)
	...d ItmObj.%Set("ThirdCode",ServiceType)
	...d ItmObj.%Set("ThirdId",ThirdId)
	...
	...;s RtnObj=##class(web.DHCSTMHUI.DHCINGdRecItm).Insert(IngrId,ItmObj)
	...s ItmArr=[]
	...d ItmArr.%Push(ItmObj)
	...s ListData=ItmArr.%ToJSON()
	...s RtnObj=##class(web.DHCSTMHUI.DHCINGdRecItm).Save(IngrId,ListData,MainInfo)
	...i RtnObj.success'=0 d RtnObj.Err(-21,"","第"_i_"单第"_j_"条,明细保存失败:"_RtnObj.msg,"",0) q
	...s Ingri=RtnObj.rowid
	...;这里dhc_hvmat_orditm可能有多条,怎么区分?
	..q:RtnObj.success<0
	..
	..&sql(UPDATE DHC_INGdRec SET INGR_No=INGR_Backup3,INGR_Completed='Y' WHERE INGR_RowId=:IngrId)
	..
	..;自动审核
	..s AuditObj={},AuditObj.gLocId=AuditObj.gUserId=UserId
	..s AuditParams=AuditObj.%ToJSON()
	..s RtnObj=##class(web.DHCSTMHUI.DHCINGdRec).Audit(IngrId,AuditParams,"Y")
	..i RtnObj.success<0 s RtnObj.msg="第"_i_"单,审核失败:"_RtnObj.msg q
	..
	..s CreateParams="^"_RecLocId_"^"_UserId
	..s RtnObj=##class(web.DHCSTMHUI.HVMatOrdItm).CreateTransferByIngr(IngrId,ToLocId,CreateParams)
	..i RtnObj.success<0 s RtnObj.msg="第"_i_"单,自动出库失败:"_RtnObj.msg q
	..s Init=RtnObj.rowid
	..
	..s RtnObj=##class(web.DHCSTMHUI.DHCINIsTrf).TransOutAuditYes(Init,UserId,"","N")
	..i RtnObj.success<0 s RtnObj.msg="第"_i_"单,自动出库审核失败:"_RtnObj.msg q
	..//出库接收
	..s Status=31
	..&sql(update DHC_InIsTrf set INIT_State=:Status where %id=:Init)
	..i SQLCODE<0 s RtnObj.msg="第"_i_"单,自动出库接收失败!" q
	..&sql(update DHC_InIsTrfItm set DHCITI_State=:Status where INITI_INIT_ParRef=:Init)
	..i SQLCODE<0 s RtnObj.msg="第"_i_"单,自动出库接收失败!" q
	..
	..;补录入库出库跟踪日志的记录
	..s Ret=##class(web.DHCSTMHUI.DHCItmTrackDetailAddion).RecordIngr(IngrId)
	..i Ret<0 d RtnObj.Err(-15,"","第"_i_"单,补录入库出库日志记录失败!") q
	.
	.
	.s RecResultObj={}
	.s RecResultObj.itemNo=SpdIngrNo
	.i RtnObj.success<0 d
	..s RecResultObj.success=-1,RecResultObj.msg=RtnObj.msg
	.e  d
	..s RecResultObj.success=1,RecResultObj.msg="成功"
	.
	.d KeyArr.%Push(RecResultObj)
	.
	.i RtnObj.success<0 tro  q
	.tc
	
	s RtnObj.keyValue=KeyArr.%ToJSON()
	
	;i RtnObj.success<0 tro  q RtnObj
	;tc
	;s RtnObj.rowid=IngrId
	s RtnObj.rowid="",RtnObj.msg="",RtnObj.success=""
	q RtnObj
}

/// 退库+退货,一条龙
/// 特别注意: 目前此写法仅支持一条明细,比如停医嘱时自动退库退货
ClassMethod SaveInitIngrt(Input) As web.DHCSTMHUI.RtnObj
{
	/*
[{
	SPDNo: SPD出库单号,
	FromLocCode:  出库科室代码(发放科室),
	ToLocCode: 接收科室代码,
	UserCode: 入库人员代码(工号),
	ReqUserCode: 接收人员代码(工号,如无可传空),
	Remarks: 备注,
	THSPDNo: 退货单单号(退货科室使用ToLocCode),
	
	StockDetailId: 第三方批次ID, 其他物资代码,批号效期等均不需传递,以此DetailId为准.
	Qty: 入库数量,
	UomDesc: 单位描述(如约定单位规则,可传空)
},
{其他单据...}]
*/
	n (Input)
	s ServiceType=..%GetParameter("ServiceType")
	s RtnObj=##class(web.DHCSTMHUI.RtnObj).%New()
	s BillArray=[].%FromJSON(Input)
	
	s Size=BillArray.%Size()
	i Size=0 q RtnObj.Err(-1,"","入参为空!","",0)
	
	s KeyArr=[]
	
	;ts
	f i=1:1:Size q:RtnObj.success<0  d
	.ts
	.s BillObj=BillArray.%Get(i-1)
	.i BillObj="" d
	..d RtnObj.Err(-1,"","第"_i_"个单据,单据内容为空!","",0) q
	.e  d
	..s SPDNo=BillObj.%Get("SPDNo")
	..s THSPDNo=BillObj.%Get("THSPDNo")
	..s FromLocCode=BillObj.%Get("FromLocCode")
	..s ToLocCode=BillObj.%Get("ToLocCode")
	..s UserCode=BillObj.%Get("UserCode")
	..s Remarks=BillObj.%Get("Remarks")
	..s ReqUserCode=BillObj.%Get("ReqUserCode")
	..s VenCode=BillObj.%Get("VenCode")
	..
	..
	..s SPDNoUpper=$$ALPHAUP^SSUTIL4(SPDNo)
	..s THSPDNoUpper=$$ALPHAUP^SSUTIL4(THSPDNo)
	..s FromLocId=##class(web.DHCSTMService.HRPJson.CommonInfo).GetLocId(FromLocCode)
	..s ToLocId=##class(web.DHCSTMService.HRPJson.CommonInfo).GetLocId(ToLocCode)
	..s UserId=##class(web.DHCSTMService.HRPJson.CommonInfo).GetUserId(UserCode)
	..s ReqUserId=##class(web.DHCSTMService.HRPJson.CommonInfo).GetUserId(ReqUserCode)
	..
	..i SPDNoUpper="" d RtnObj.Err(-1,"","第"_i_"个单据,退库单号为空!","",0) q
	..i $d(^DHCINIT(0,"No",SPDNoUpper)) d RtnObj.Err(-1,"","第"_i_"个单据,退库单号重复处理!","",0) q
	..i THSPDNoUpper="" d RtnObj.Err(-1,"","第"_i_"个单据,退货单号为空!","",0) q
	..i $d(^INGRT(0,"RETNO",THSPDNoUpper)) d RtnObj.Err(-1,"","第"_i_"个单据,退货单号重复处理!","",0) q
	..
	..i FromLocId="" d RtnObj.Err(-1,"","第"_i_"个单据,出库科室无效!","",0) q
	..i ToLocId="" d RtnObj.Err(-1,"","第"_i_"个单据,接收科室无效!","",0) q
	..i FromLocId=ToLocId d RtnObj.Err(-1,"","第"_i_"个单据,出库科室与接收科室不能相同!","",0) q
	..i (UserCode'="")&&(UserId="") d RtnObj.Err(-1,"","第"_i_"个单据,出库人员无效!","",0) q
	..i (ReqUserCode'="")&&(ReqUserId="") d RtnObj.Err(-1,"","第"_i_"个单据,接收人员无效!","",0) q
	..i VendorId="" d RtnObj.Err(-1,"","第"_i_"个单据,供应商无效!","",0) q
	..s HospId=$p(^CTLOC(FromLocId),"^",22)
	..
	..
	..s ListArr=BillObj.%Get("List")
	..s ListSize=ListArr.%Size()
	..i ListSize=0 d RtnObj.Err(-1,"","第"_i_"个单据,单据明细为空!","",0) q
	..
	..s ItmArray=[]
	..f j=ListSize:-1:1 q:RtnObj.success<0  d
	...s PItmObj=ListArr.%Get(j-1)
	...s ListObj=PItmObj.%Get("List")
	...s DetailId=PItmObj.%Get("StockDetailId")
	...s Qty=PItmObj.%Get("Qty")
	...s UomDesc=PItmObj.%Get("UomDesc")
	...s HVBarCode=PItmObj.%Get("HVBarCode")
	...s ThirdId=PItmObj.%Get("ThirdId")			;出库明细,第三方id
	...s THThirdId=PItmObj.%Get("THThirdId")		;退货明细,第三方id
	...s RKThirdId=PItmObj.%Get("RKItemId")		;入库明细,第三方id
	...
	...s Ingri=##class(web.DHCSTMHUI.DHCServiceBill).GetPointer(ServiceType,"G",RKThirdId)
	...;i RKThirdId="" d RtnObj.Err(-21,"","第"_i_"单第"_j_"条,入库明细id为空!","",0) q
	...i (RKThirdId'="")&&(Ingri="") d RtnObj.Err(-21,"","第"_i_"单第"_j_"条,入库明细id无效!","",0) q
	...i ThirdId="" d RtnObj.Err(-21,"","第"_i_"单第"_j_"条,单据明细ThirdId为空!","",0) q
	...i Qty'>0 d RtnObj.Err(-21,"","第"_i_"单第"_j_"条,数量需大于0!","",0) q
	...
	...i ((HVBarCode'="")&&(Qty'=1)) d RtnObj.Err(-1,"","第"_i_"单第"_j_"条,高值条码数量不符","",0) q
	...s OriId=""
	...i HVBarCode'="" d
	....s OriId=$o(^DHCHVMORI(0,"BARCODE",HVBarCode,""),-1)
	....i (OriId="") d RtnObj.Err(-1,"","第"_i_"单第"_j_"条,条码状态不符","",0) q
	...q:RtnObj.success<0
	...
	...s Incib=""
	...;2022-08-09 优先按Ingri获取Incib, 避免DetailId出错的情况
	...i Ingri'="" d
	....s IngriInclb=$p(^DHCINGR(+Ingri,"GRI",$p(Ingri,"||",2)),"^",1)
	....s Incib=$p(^INCI(+IngriInclb,"IL",$p(IngriInclb,"||",2),"LB",$p(IngriInclb,"||",3)),"^",1)
	...;添加DetailId的判断
	...
	...i Incib="" s Incib=..GetIncibByDetailId(DetailId)
	...s Inclb=..GetInclbByIncibAndLoc(Incib,FromLocId,"Y")
	...
	...i DetailId="" d RtnObj.Err(-21,"","第"_i_"单第"_j_"条,批次Id为空!","",0) q
	...i (DetailId'="")&&(Incib="") d RtnObj.Err(-21,"","第"_i_"单第"_j_"条,DetailId无效!","",0) q
	...i (Inclb="") d RtnObj.Err(-21,"","第"_i_"单第"_j_"条,批次无效!","",0) q
	...
	...s InciId=$p(Inclb,"||",1)
	...s BUomId=$p(^INCI(InciId,1),"^",10)
	...s UomId=BUomId
	...s HVFlag=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncHighValueFlag(InciId)
	...;i (HVFlag="Y")&&(HVBarCode="") d RtnObj.Err(-1,"","第"_i_"单,高值条码为空!","",0) q
	...s InclbVenInfo=##class(web.DHCSTMHUI.Common.DrugStkCommon).GetvendorInfoByInclb(Inclb)
	...s InclbVenId=$p(InclbVenInfo,"^",1)
	...i (InclbVenId'=VendorId) d RtnObj.Err(-21,"","第"_i_"单第"_j_"条,批次与供应商不符!","",0) q
	...
	...s ItmObj={}
	...d ItmObj.%Set("Inclb",Inclb)
	...d ItmObj.%Set("Qty",Qty)
	...d ItmObj.%Set("UomId",UomId)
	...;d ItmObj.%Set("HVBarCode",HVBarCode)		;补录,不处理高值条码
	...d ItmObj.%Set("ThirdCode",ServiceType)
	...d ItmObj.%Set("ThirdId",ThirdId)
	...d ItmObj.%Set("AddionFlag","Y")			;补录标记
	...
	...d ItmArray.%Push(ItmObj)
	..
	..q:RtnObj.success<0
	..i ItmArray.%Size()=0 d RtnObj.Err(-21,"","第"_i_"单,明细为空!","",0) q
	..
	..s ScgId=""
	..s MainObj={}
	..d MainObj.%Set("InitFrLoc",FromLocId)
	..d MainObj.%Set("InitToLoc",ToLocId)
	..d MainObj.%Set("InitUser",UserId)
	..d MainObj.%Set("InitScg",ScgId)
	..d MainObj.%Set("InitRemarks",Remarks)
	..d MainObj.%Set("InitReqUser",ReqUserId)
	..d MainObj.%Set("gHospId",HospId)
	..d MainObj.%Set("InitState",10)
	..d MainObj.%Set("InitComp","Y")		;保存为"完成"状态
	..
	..s MainInfo=MainObj.%ToJSON()
	..s ListData=ItmArray.%ToJSON()
	..s RtnObj=##class(web.DHCSTMHUI.DHCINIsTrf).Save(MainInfo,ListData)
	..i RtnObj.success<0 s RtnObj.msg="第"_i_"单,保存失败:"_RtnObj.msg q
	..s InitId=RtnObj.rowid
	..
	..;设置完成状态
	..&sql(UPDATE dhc_inistrf set INIT_No=:SPDNo,init_usercompleted='Y',init_state='11' where %ID=:InitId)
	..
	..
	..s RtnObj=##class(web.DHCSTMHUI.DHCINIsTrf).TransInAuditYes(InitId,UserId)
	..q:RtnObj.success<0
	..
	..s ItmArray=[]
	..;倒序组织
	..s InitCh=""
	..f  s InitCh=$o(^DHCINIT(InitId,"ITI",InitCh),-1) q:(InitCh="")||(InitCh=0)||(RtnObj.success<0)  d
	...s Initi=InitId_"||"_InitCh
	...s Intr=$o(^DHCINTR(0,"TypePointer","K",Initi,0))
	...i Intr="" d RtnObj.Err(-21,"","第"_i_"单,退库单保存失败!","",0) q
	...s KInclb=$p(^DHCINTR(Intr),"^",7)
	...i (KInclb="") d RtnObj.Err(-21,"","第"_i_"单,退库单保存失败!","",0) q
	...s InciId=$p(KInclb,"||",1)
	...s BUomId=$p(^INCI(InciId,1),"^",10)
	...s UomId=BUomId
	...s Rp=##class(web.DHCSTMHUI.Common.PriceCommon).GetClbRp(KInclb,UomId,HospId)
	...s Sp=##class(web.DHCSTMHUI.Common.PriceCommon).GetPriceElse(KInclb,+$h,UomId,HospId)
	...s RpAmt=Rp*Qty
	...s HVFlag=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncHighValueFlag(InciId)
	...;i (HVFlag="Y")&&(HVBarCode="") d RtnObj.Err(-1,"","第"_i_"单,高值条码为空!","",0) q
	...
	...s ItmObj={}
	...d ItmObj.%Set("Ingri",Ingri)
	...d ItmObj.%Set("Inclb",KInclb)
	...d ItmObj.%Set("Qty",Qty)
	...d ItmObj.%Set("Uom",UomId)
	...;d ItmObj.%Set("HvBarCode",HVBarCode)
	...d ItmObj.%Set("Rp",Rp)
	...d ItmObj.%Set("Sp",Sp)
	...d ItmObj.%Set("InvAmt",RpAmt)
	...d ItmObj.%Set("ThirdCode",ServiceType)
	...d ItmObj.%Set("ThirdId",THThirdId)
	...d ItmArray.%Push(ItmObj)
	..q:RtnObj.success<0
	..i ItmArray.%Size()=0 d RtnObj.Err(-1,"","第"_i_"单,处理退货单失败!","",0) q
	..
	..s MainObj={}
	..d MainObj.%Set("RetLoc",ToLocId)
	..d MainObj.%Set("Vendor",VendorId)
	..d MainObj.%Set("gHospId",HospId)
	..d MainObj.%Set("gUserId",UserId)
	..d MainObj.%Set("Remarks",Remarks)
	..d MainObj.%Set("ScgStk",ScgId)
	..
	..s MainInfo=MainObj.%ToJSON()
	..s ListData=ItmArray.%ToJSON()
	..s RtnObj=##class(web.DHCSTMHUI.DHCINGdRet).Save(MainInfo,ListData)
	..i RtnObj.success<0 s RtnObj.msg="第"_i_"单,保存失败:"_RtnObj.msg q
	..
	..s IngrtId=RtnObj.rowid
	..&sql(UPDATE DHC_INGDRET SET INGRT_NO=:THSPDNo,INGRT_Completed='Y' WHERE INGRT_RowId=:IngrtId)
	..
	..s AuditFlag=$p(^INGRT(IngrtId),"^",7)
	..i AuditFlag'="Y" d
	...s AuditObj={}
	...d AuditObj.%Set("RowId",IngrtId)
	...d AuditObj.%Set("UserId",UserId)
	...d AuditObj.%Set("gHospId",HospId)
	...s AuditStr=AuditObj.%ToJSON()
	...s RtnObj=##class(web.DHCSTMHUI.DHCINGdRet).Audit(AuditStr)
	...i RtnObj.success<0 s RtnObj.msg="第"_i_"单,退货审核失败:"_RtnObj.msg q
	..
	..i OriId'="" d
	...s Oeori=$p(^DHCHVMORI(OriId,1),"^",1)
	...s Ret=##class(web.DHCSTMHUI.DHCItmTrackDetailAddion).RecordReturn(Oeori,HVBarCode,InitId,IngrtId)
	...&sql(update DHC_HVMat_OrdItm set ORI_IngrFlag=null,ORI_INGRI_Modify_DR=null,ORI_DateOfManu=null where %id=:OriId)
	.
	.s RecResultObj={}
	.s RecResultObj.itemNo=SPDNo
	.i RtnObj.success<0 d
	..s RecResultObj.success=-1,RecResultObj.msg=RtnObj.msg
	.e  d
	..s RecResultObj.success=1,RecResultObj.msg="成功"
	.
	.d KeyArr.%Push(RecResultObj)
	.
	.i RtnObj.success<0 tro  q
	.tc
	
	s RtnObj.keyValue=KeyArr.%ToJSON()
	
	;i RtnObj.success<0 tro  q RtnObj
	;tc
	s RtnObj.rowid="",RtnObj.msg="",RtnObj.success=""
	q RtnObj
}

/// w ##class(web.DHCSTMService.HRPJson.STM2HRPServiceImpl).GetLocStock("{""LocId"":163,""InciCode"":""GZ00002""}",2)
ClassMethod GetLocStock(Input, HospId)
{
	n (Input,HospId)
	s $ZT="GetLocStockErr"
	s ResultSet=##class(%ResultSet).%New("web.DHCSTMService.HRPJson.STM2HRPServiceImpl:GetLocStock")
	s Sc=ResultSet.Execute(Input,HospId)
	i $$$ISERR(Sc) q "{""success"":-10}"
	
	s ColNum=ResultSet.GetColumnCount()
	s TitleStr=""
	f i=1:1:ColNum d
	.i TitleStr="" s TitleStr=ResultSet.GetColumnName(i)
	.e  s TitleStr=TitleStr_"^"_ResultSet.GetColumnName(i)
	
	s Count=0
	s StockStr="{""ListData"":["
	While (ResultSet.Next()) {
		s DataStr=""
		f i=1:1:ColNum d
		.i DataStr="" s DataStr=ResultSet.%GetData(i)
		.e  s DataStr=DataStr_"^"_ResultSet.%GetData(i)
		s JsonStr=##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(DataStr,TitleStr)
		s Count=Count+1
		i Count=1 s StockStr=StockStr_JsonStr
		e  s StockStr=StockStr_","_JsonStr
	}
	s StockStr=StockStr_"],""success"":0,""msg"":""共"_Count_"条""}"
	q StockStr

GetLocStockErr
	q "{""success"":-999}"
}

/// d ##class(%ResultSet).RunQuery("web.DHCSTMService.HRPJson.STM2HRPServiceImpl","GetLocStock","{""Date"":""2021-01-01"",""InciCode"":""GZ00002""}",2)
/// call web_DHCSTMService_HRPJson.STM2HRPServiceImpl_GetLocStock("",2)
Query GetLocStock(Input As %Text, HospId As %String) As web.DHCSTMHUI.Query(ROWSPEC = "StockDetailId,LocCode,LocDesc,InciCode,InciDesc,Spec,Model,Qty,BUomDesc,BatchNo,ExpDate,Rp,VenCode") [ SqlProc ]
{
}

ClassMethod GetLocStockExecute(ByRef qHandle As %Binary, Input As %Text, HospId As %String) As %Status
{
	n (qHandle,Input,HospId)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	
	s Input=$tr(Input,$c(0)),HospId=$tr(HospId,$c(0))
	
	s:Input="" Input="{}"
	s InputObj={}.%FromJSON(Input)
	s PLocCode=InputObj.%Get("LocCode")
	s PInciCode=InputObj.%Get("InciCode")
	s PDate=InputObj.%Get("Date")
	s PLocId=##class(web.DHCSTMService.HRPJson.CommonInfo).GetLocId(PLocCode)
	s PInciId=##class(web.DHCSTMService.HRPJson.CommonInfo).GetInciId(PInciCode)
	s PDateH=+$h
	i PDate'="" s PDateH=$zdh(PDate,3)
	
	s Inci=0
	f  s Inci=$o(^INCI(Inci)) q:Inci=""  d
	.q:+Inci'>0
	.q:(PInciId'="")&&(Inci'=PInciId)
	.s IncscInfo=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncsc(Inci)
	.s StkType=$p(IncscInfo,"^",4)
	.q:StkType'="M"
	.
	.;添加过滤范围
	.s InciFlag=..GetInciFlag(Inci)
	.q:InciFlag'="Y"
	.
	.s InciCode=##class(web.DHCSTMService.HRPJson.CommonInfo).GetInci4Ser(Inci)
	.s InciDesc=$p(^INCI(Inci,1),"^",2)
	.s BUomId=$p(^INCI(Inci,1),"^",10)
	.s BUomDesc=$p(^CT("UOM",BUomId),"^",2)
	.s Spec=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetSpec("",Inci)
	.s Model=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetModel(Inci)
	.
	.s IL=0
	.f  s IL=$o(^INCI(Inci,"IL",IL)) q:IL=""  d
	..q:($d(^INCI(Inci,"IL",IL))'=1)&&($d(^INCI(Inci,"IL",IL))'=11)
	..s Incil=Inci_"||"_IL
	..s LocId=$p(^INCI(Inci,"IL",IL),"^",1)
	..q:LocId=""
	..q:(PLocId'="")&&(LocId'=PLocId)
	..s LocCode=##class(web.DHCSTMService.HRPJson.CommonInfo).GetLoc4Ser(LocId)
	..s LocDesc=$p(^CTLOC(LocId),"^",2)
	..
	..s LB=0
	..f  s LB=$o(^INCI(Inci,"IL",IL,"LB",LB)) q:LB=""  d
	...s Inclb=Incil_"||"_LB
	...
	...;s Qty=$p(^INCI(Inci,"IL",IL,"LB",LB),"^",2)
	...s Qty=##class(web.DHCSTMHUI.Common.DrugStkCommon).QtyINCLB(Inclb,PDateH)
	...q:+Qty=0		;过滤0库存
	...s StockDetailId=##class(web.DHCSTMHUI.Common.DrugStkCommon).GetDetailIdByInclb(Inclb)
	...;q:StockDetailId=""
	...s BatExp=##class(web.DHCSTMHUI.Common.DrugStkCommon).Bat(Inclb)
	...s BatchNo=$p(BatExp,"^",1)
	...s ExpDate=$p(BatExp,"^",2)
	...s VendorInfo=##class(web.DHCSTMHUI.Common.DrugStkCommon).GetvendorInfoByInclb(Inclb)
	...s VendorId=$p(VendorInfo,"^",1)
	...s VenCode=##class(web.DHCSTMService.HRPJson.CommonInfo).GetVendor4Ser(VendorId)
	...s Rp=##class(web.DHCSTMHUI.Common.PriceCommon).GetClbRp(Inclb,BUomId,HospId)
	...
	...d OutPutLocStock
	q $$$OK
OutPutLocStock
	s Data=$lb(StockDetailId,LocCode,LocDesc,InciCode,InciDesc,Spec,Model,Qty,BUomDesc,BatchNo,ExpDate,Rp,VenCode)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// 查询一定时间段内的科室台帐
/// w ##class(web.DHCSTMService.HRPJson.STM2HRPServiceImpl).GetIntrInfo("{""LocCode"":163,""StartDate"":""2021-01-01"",""EndDate"":""2021-11-24""}")
ClassMethod GetIntrInfo(Input)
{
	n (Input,HospId)
	s $ZT="GetIntrErr"
	s ResultSet=##class(%ResultSet).%New("web.DHCSTMService.HRPJson.STM2HRPServiceImpl:GetIntrInfo")
	s Sc=ResultSet.Execute(Input)
	i $$$ISERR(Sc) q "{""success"":-10}"
	
	s ColNum=ResultSet.GetColumnCount()
	s TitleStr=""
	f i=1:1:ColNum d
	.i TitleStr="" s TitleStr=ResultSet.GetColumnName(i)
	.e  s TitleStr=TitleStr_"^"_ResultSet.GetColumnName(i)
	
	s Count=0
	s StockStr="{""ListData"":["
	While (ResultSet.Next()) {
		s DataStr=""
		f i=1:1:ColNum d
		.i DataStr="" s DataStr=ResultSet.%GetData(i)
		.e  s DataStr=DataStr_"^"_ResultSet.%GetData(i)
		s JsonStr=##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(DataStr,TitleStr)
		s Count=Count+1
		i Count=1 s StockStr=StockStr_JsonStr
		e  s StockStr=StockStr_","_JsonStr
	}
	s StockStr=StockStr_"],""success"":0,""msg"":""共"_Count_"条""}"
	q StockStr

GetIntrErr
	q "{""success"":-999}"
}

/// 前闭后开区间, 23:59:59不需要传递
/// d ##class(%ResultSet).RunQuery("web.DHCSTMService.HRPJson.STM2HRPServiceImpl","GetIntrInfo","{""LocCode"":163,""StartDate"":""2021-01-01"",""EndDate"":""2021-11-24""}")
/// call web_DHCSTMService_HRPJson.STM2HRPServiceImpl_GetIntrInfo("{""LocCode"":163,""StartDate"":""2021-01-01"",""EndDate"":""2021-11-24""}")
Query GetIntrInfo(Input As %Text) As web.DHCSTMHUI.Query(ROWSPEC = "IntrType,StockDetailId,LocCode,LocDesc,InciCode,InciDesc,Spec,Model,Qty:%Float,UomDesc,Rp:%Float,RpAmt:%Float,BatchNo,ExpDate,VenCode,HVBarCode") [ SqlProc ]
{
}

ClassMethod GetIntrInfoExecute(ByRef qHandle As %Binary, Input As %Text) As %Status
{
	n (qHandle,Input)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	
	s InputObj={}.%FromJSON(Input)
	s PLocCode=InputObj.%Get("LocCode")
	s PInciCode=InputObj.%Get("InciCode")
	s StartDate=InputObj.%Get("StartDate")
	s StartTime=InputObj.%Get("StartTime")
	s EndDate=InputObj.%Get("EndDate")
	s EndTime=InputObj.%Get("EndTime")
	q:(StartDate="")||(EndDate="") $$$OK
	
	s PLocId=##class(web.DHCSTMService.HRPJson.CommonInfo).GetLocId(PLocCode)
	s PInciId=##class(web.DHCSTMService.HRPJson.CommonInfo).GetInciId(PInciCode)
	s StartDateH=$zdh(StartDate,3)
	s EndDateH=$zdh(EndDate,3)
	s StartTimeH=$s(StartTime'="":$zth(StartTime,1),1:"")
	s EndTimeH=$s(EndTime'="":$zth(EndTime,1),1:"")
	
	;q:PLocId="" $$$OK
	q:(StartDateH="")||(EndDateH="") $$$OK
	
	s Date=StartDateH-1
	f  s Date=$o(^DHCINTR(0,"Date",Date)) q:(Date="")||(Date>EndDateH)  d
	.s Intr=0
	.f  s Intr=$o(^DHCINTR(0,"Date",Date,Intr)) q:Intr=""  d
	..s IntrInfo=^DHCINTR(Intr)
	..s IntrTime=$p(IntrInfo,"^",3)
	..q:(StartTimeH'="")&&(Date=StartDateH)&&(IntrTime<StartTimeH)
	..q:(EndTimeH'="")&&(Date=EndDateH)&&(IntrTime>=EndTimeH)
	..
	..s IntrType=$p(IntrInfo,"^",1)
	..s Qty=$p(IntrInfo,"^",6)
	..s Inclb=$p(IntrInfo,"^",7)
	..s Pointer=$p(IntrInfo,"^",9)
	..s UomId=$p(IntrInfo,"^",10)
	..s Rp=$p(IntrInfo,"^",16)
	..s RpAmt=$p(IntrInfo,"^",17)
	..;q:'$lf($lb("G","T","K","A","R","P","F"),IntrType)
	..s Inci=$p(Inclb,"||",1),IL=$p(Inclb,"||",2),LB=$p(Inclb,"||",3)
	..s LocId=$p(^INCI(Inci,"IL",IL),"^",1)
	..q:(PInciId'="")&&(Inci'=PInciId)
	..q:(PLocId'="")&&(LocId'=PLocId)
	..
	..s StockDetailId=##class(web.DHCSTMHUI.Common.DrugStkCommon).GetDetailIdByInclb(Inclb)
	..q:StockDetailId=""
	..
	..s LocCode=##class(web.DHCSTMService.HRPJson.CommonInfo).GetLoc4Ser(LocId)
	..s LocDesc=$p(^CTLOC(LocId),"^",2)
	..s InciCode=##class(web.DHCSTMService.HRPJson.CommonInfo).GetInci4Ser(Inci)
	..s InciDesc=$p(^INCI(Inci,1),"^",2)
	..s Spec=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetSpec("",Inci)
	..s Model=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetModel(Inci)
	..s UomDesc=$p(^CT("UOM",UomId),"^",2)
	..s BatExp=##class(web.DHCSTMHUI.Common.DrugStkCommon).Bat(Inclb)
	..s BatchNo=$p(BatExp,"^",1),ExpDate=$p(BatExp,"^",2)
	..s VendorInfo=##class(web.DHCSTMHUI.Common.DrugStkCommon).GetvendorInfoByInclb(Inclb)
	..s VendorId=$p(VendorInfo,"^",1)
	..s VenCode=##class(web.DHCSTMService.HRPJson.CommonInfo).GetVendor4Ser(VendorId)
	..s HVBarCode=##class(web.DHCSTMHUI.DHCItmTrack).GetLabelsStr(IntrType,Pointer)
	..
	..d OutPutIntr
	
	q $$$OK
OutPutIntr
	s Data=$lb(IntrType,StockDetailId,LocCode,LocDesc,InciCode,InciDesc,Spec,Model,Qty,UomDesc,Rp,RpAmt,BatchNo,ExpDate,VenCode,HVBarCode)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

}
