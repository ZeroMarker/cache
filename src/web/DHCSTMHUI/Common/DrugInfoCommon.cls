Import sqluser

/// Descript:	物资基本信息相关的公共方法
/// CreateDate:	2018-05-03
Class web.DHCSTMHUI.Common.DrugInfoCommon Extends (%RegisteredObject, %XML.Adaptor, web.DHCSTMHUI.StkTypeM) [ Not ProcedureBlock ]
{

/// 根据库存项代码或RowID取得规格
ClassMethod GetSpec(incicode, inci) As %Library.String
{
	n (incicode,inci)
	i inci="" d
	.s inci=..ItemCodeToID(incicode)
	q:inci="" ""
	s add=$o(^DHCITMINFO(0,"INCI",inci,""))
	q:add="" ""
	s spec=$p($G(^DHCITMINFO(add)),"^",27)
	q spec
}

/// Descript:根据库存项id和参数配置取供应商
/// Creater:	ZhangDongmei
/// CreateDate:	2012-06-19
/// Table:
/// Input:库存项id,应用程序代码
/// Output:		
/// Return：供应商id^供应商名称
ClassMethod GetConfigVendor(IncId As %String, AppCode As %String, Params As %String) As %Library.String
{
	n (IncId,AppCode,Params)
	s VendorProp=##class(web.DHCSTMHUI.Common.AppCommon).GetAppPropValue(AppCode,"DefaItmVendor",Params)
	i VendorProp=1  d   ;取最后一次入库供应商
	.s VenInfo=##class(web.DHCSTMHUI.Common.DrugStkCommon).GetLastVen(IncId)
	e  d   ;取招标供应商
	.s VenInfo=..GetPbVendor(IncId)
	s VenId=$p(VenInfo,"^",1)
	s VenDesc=$p(VenInfo,"^",2)
	;
	q VenId_"^"_VenDesc
}

/// Descript:	根据库存项Id和参数配置取生产厂家
/// Creater:	ZhangDongmei
/// CreateDate:	2012-06-19
/// Input:		库存项id,应用程序代码,安全组id^科室id^用户id^医院id
/// Return:		生产厂家id^生产厂家名称
/// w ##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetConfigManf("7797","","")
ClassMethod GetConfigManf(IncId As %String, AppCode As %String, Params As %String) As %Library.String
{
	n (IncId,AppCode,Params)
	
	s (ManfId,ManfDesc)=""
	s ManfProp=##class(web.DHCSTMHUI.Common.AppCommon).GetAppPropValue(AppCode,"DefaManf",Params)
	i ManfProp=1  d   ;取最后一次入库生产厂家
	.s ManfInfo=..GetLastManf(IncId)
	.s ManfId=$p(ManfInfo,"^",1)
	.s ManfDesc=$p(ManfInfo,"^",2)
	e  i ManfProp=3  d   ;招标生产厂家
	.s ManfInfo=..GetPbManf(IncId)
	.s ManfId=$p(ManfInfo,"^",1)
	.s ManfDesc=$p(ManfInfo,"^",2)
	e  d   ;初始生产厂家
	.s ManfInfo=..GetManf(IncId)
	.s ManfId=$p(ManfInfo,"^",1)
	.s ManfDesc=$p(ManfInfo,"^",3)
	q ManfId_"^"_ManfDesc
}

/// Descript:根据库存项id和参数配置取配送商
/// Creater:	ZhangDongmei
/// CreateDate:	2012-09-27
/// Table:
/// Input:库存项id,应用程序代码
/// Output:		
/// Return：配送商id^配送商名称
ClassMethod GetConfigCarrier(IncId As %String, AppCode As %String, Params As %String) As %Library.String
{
	n (IncId,AppCode,Params)
	s DefaItmCarrier=##class(web.DHCSTMHUI.Common.AppCommon).GetAppPropValue(AppCode,"DefaItmCarrier",Params)
	i DefaItmCarrier=1 d   ;上次采购配送商
	.s CarrierInfo=..GetLastPbCarrier(IncId)
	.s CarrierId=$p(CarrierInfo,"^",1)
	.s CarrierDesc=$p(CarrierInfo,"^",2)
	e  d   ;招标配送商
	.s CarrierInfo=..GetPbCarrier(IncId)
	.s CarrierId=$p(CarrierInfo,"^",1)
	.s CarrierDesc=$p(CarrierInfo,"^",2)
	
	q CarrierId_"^"_CarrierDesc
}

/// Description:取某库存项招标供应商(供应链有值的,返回供应链上的供应商)
/// Input:		库存项id
/// Output:		供应商ID^供应商名称^供应商代码
/// w ##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetPbVendor(6)
ClassMethod GetPbVendor(Inci) As %Library.String
{
	n (Inci)
	q:Inci="" ""
	s (VendorId,VenDesc,VenCode)=""
	
	s ChainId=$o(^CT.HRP.MAT.SupplyChainItmI("INCI",Inci,""),-1)
	i ChainId'="" d
	.s VendorId=$lg(^CT.HRP.MAT.SupplyChainD(ChainId),4)
	
	i VendorId="" d
	.s Add=$o(^DHCITMINFO(0,"INCI",Inci,""))
	.q:Add=""
	.s VendorId=$p($G(^DHCITMINFO(Add)),"^",24)
	
	s:VendorId'="" VenDesc=$p(^APC("APCVM",VendorId),"^",3)
	s:VendorId'="" VenCode=$p(^APC("APCVM",VendorId),"^",2)
	q VendorId_"^"_VenDesc_"^"_VenCode
}

/// Description:取某库存项生产厂家
/// Input:		库存项id
/// Output:		生产厂家ID^生产厂家名称
/// w ##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetPbManf(6)
ClassMethod GetPbManf(Inci) As %Library.String
{
	n (Inci,%session)
	q:Inci="" ""
	s (ManfId,ManfDesc)=""
	
	s Add=$o(^DHCITMINFO(0,"INCI",Inci,""))
	//1.优先取注册证厂家
	i Add'="" d
	.q:'$d(^DHCITMINFO(Add))
	.s RegCertDR=$p($g(^DHCITMINFO(Add,1)),"^",18)
	.i RegCertDR'="" d
	..s ManfId=$p($g(^DHCMRCT(RegCertDR)),"^",2)

	//2.若无注册证厂家,优先取授权书厂家
	i ManfId="" d
	.s ChainId=$o(^CT.HRP.MAT.SupplyChainItmI("INCI",Inci,""),-1)
	.i ChainId'="" d
	..s ManfId=$lg(^CT.HRP.MAT.SupplyChainD(ChainId),3)
	
	//3.若无注册证、授权书厂家取库存项附加表厂家
	i (ManfId="")&&(Add'="") d
	.s ManfId=$p($G(^DHCITMINFO(Add)),"^",25)
	
	s:ManfId'="" ManfDesc=$P($g(^PHMNF(ManfId)),"^",2)
	s ManfDesc=..%FieldTranslate("User.PHManufacturer","PHMNFName",ManfDesc)
	q ManfId_"^"_ManfDesc
}

/// Descript:取某库存项上次采购配送商
/// Creater:zhangdongmei
/// CreateDate:2012-09-27
/// Input:库存项id
/// Output:	
/// Return:配送商ID^配送商名称
ClassMethod GetLastPbCarrier(Inci) As %Library.String
{
	n (Inci)
	q:Inci="" ""
	s CarrierId="",CarrierDesc=""
	s Inpp=""
	f  s Inpp=$o(^INPP(0,"INCI",Inci,Inpp),-1) q:(Inpp="")!(CarrierId'="")  d
	.s Chl=""
	.f  s Chl=$o(^INPP(0,"INCI",Inci,Inpp,Chl),-1)  q:(Chl="")!(CarrierId'="")  d
	..s CarrierId=$p(^INPP(Inpp,"PPI",Chl),"^",8)
	.
	s:((CarrierId'="")&&($d(^DHCCARR(CarrierId)))&&(CarrierId'=0)) CarrierDesc=$p(^DHCCARR(CarrierId),"^",2)
	q CarrierId_"^"_CarrierDesc
}

/// Descript:取某库存项招标配送商
/// Creater:zhangdongmei
/// CreateDate:2012-06-19
/// Input:库存项id
/// Output:	
/// Return配送商ID^配送商名称
ClassMethod GetPbCarrier(Inci) As %Library.String
{
	n (Inci)
	q:Inci="" ""
	s Add=$o(^DHCITMINFO(0,"INCI",Inci,"")) 
	q:Add="" ""
	s (CarrierDesc,CAMobile)=""
	s CarrierId=$p($G(^DHCITMINFO(Add)),"^",26)
	s:CarrierId'="" CarrierDesc=$P(^DHCCARR(CarrierId),"^",2)
	s:CarrierId'="" CAMobile=$P(^DHCCARR(CarrierId),"^",4)
	q CarrierId_"^"_CarrierDesc_"^"_CAMobile
}

ClassMethod ItemCodeToID(incicode)
{
	n (incicode)
	s incicode=$$ALPHAUP^SSUTIL4(incicode)
	s Inci=$o(^INCI(0,"Code1",incicode_"Z",0))
	q Inci
}

/// Descript:	根据库存项的ID取生产厂家
/// Creater:	Zhouyg
/// CreateDate:	20100309
/// Input:		InciDr-INC_Itm的ID
/// Output:		Return
/// Return：	生产厂家ID^生产厂家代码^生产厂家名称
ClassMethod GetManf(InciDr)
{
	N (InciDr)
	Q:+InciDr=0 ""
	s ManfId=$p(..GetPbManf(InciDr),"^",1)
	s ManfCode=$s(ManfId'="":$P($g(^PHMNF(ManfId)),"^",1),1:"")
	s ManfDesc=$s(ManfId'="":$P($g(^PHMNF(ManfId)),"^",2),1:"")
	q ManfId_"^"_ManfCode_"^"_ManfDesc
}

/// Descript:	根据库存项ID取DrgForm的ID
/// Creater:	Zhouyg
/// CreateDate:	20100302
/// Input:		InciDr-库存项RowID
/// Output:		Return
/// Return：	PHC_DrgForm的ID
ClassMethod GetPhcdf(InciDr)
{
	N (InciDr)
	S ArcimDr=..GetArcim(InciDr)
	Q:ArcimDr="" ""
	S Phcdf=..GetPhcdfByArcim(ArcimDr)
	Q Phcdf
}

/// Descript:	根据医嘱项ID取DrgForm的ID
/// Creater:	Zhouyg
/// CreateDate:	20100302
/// Input:		ArcimDr-Arc_ItmMast的RowID
/// Output:		Return
/// Return：	PHC_DrgForm的ID
ClassMethod GetPhcdfByArcim(ArcimDr)
{
	N (ArcimDr)
	S Arcsub=$P(ArcimDr,"||",1)
	S Arcver=$P(ArcimDr,"||",2)
	Q:Arcsub="" ""
	Q:Arcver="" ""
	Q:'$D(^ARCIM(Arcsub,Arcver)) ""
	S Phcdf=$P(^ARCIM(Arcsub,Arcver,1),"^",12)
	Q Phcdf
}

/// Descript:	根据库存项ID取基本单位
/// Creater:	Zhouyg
/// CreateDate:	20100302
/// Input:		InciDr-inci_rowid
/// Output:		Return
/// Return：	基本单位ID^基本单位描述
ClassMethod GetIncBuom(InciDr)
{
	N (InciDr)
	Q:InciDr="" ""
	Q:'$D(^INCI(InciDr)) ""
	S buomdr=$P(^INCI(InciDr,1),"^",10)
	Q:buomdr="" ""
	Q:'$D(^CT("UOM",buomdr)) ""
	S buomdesc=$P(^CT("UOM",buomdr),"^",2)
	Q buomdr_"^"_buomdesc
}

/// Descript:	根据库存项ID取账单单位
/// Creater:	Zhouyg
/// CreateDate:	20100302
/// Input:		InciDr-inci_rowid
/// Output:		Return
/// Return：	账单单位ID^账单单位描述
ClassMethod GetArcBuomByInc(InciDr)
{
	N (InciDr)
	Q:InciDr="" ""
	Q:'$D(^INCI(InciDr)) ""
	S ArcimDr=..GetArcim(InciDr)
	Q ..GetArcBuom(ArcimDr)
}

/// Descript:	根据库存项ID取医嘱项ID
/// Creater:	Zhouyg
/// CreateDate:	20100302
/// Input:		InciDr-inci_rowid 
/// Output:		Return
/// Return：	医嘱项ID
ClassMethod GetArcim(InciDr)
{
	N (InciDr)
	Q:InciDr="" ""
	Q:'$D(^INCI(InciDr)) ""
	S ArcimDr=$P(^INCI(InciDr,1),"^",3)
	S Arcsub=$P(ArcimDr,"||",1)
	S Arcver=$P(ArcimDr,"||",2)
	Q:Arcsub="" ""
	Q:Arcver="" ""
	Q:'$D(^ARCIM(Arcsub,Arcver)) ""
	Q Arcsub_"||"_Arcver
}

/// Descript:	根据库存项ID获取有效计费项ID
/// Creater:	wangjiabin
/// CreateDate:	2021-08-10
/// Input:		Inci 
/// Output:		Tari
/// w ##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetTARI(5)
ClassMethod GetTARI(Inci) As %String
{
	n (Inci)
	q:Inci="" ""
	s Arcim=$P(^INCI(Inci,1),"^",3)
	q:Arcim="" ""
	
	s TarItmId=..GetTARIByArcim(Arcim)
	q TarItmId
}

/// Descript:	根据医嘱项ID获取有效计费项ID
/// Creater:	wangjiabin
/// CreateDate:	2021-08-10
/// Input:		Arcim
/// Output:		Tari
/// w ##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetTARIByArcim("5||1")
ClassMethod GetTARIByArcim(Arcim) As %String
{
	n (Arcim)
	q:Arcim="" ""
	
	s TarItmId=""
	s Tariff=""
	f  s Tariff=$o(^DHCOLT(0,"ARTTA",Arcim,Tariff)) q:(Tariff="")||(TarItmId'="")  d
	.s StartDate=""
	.f  s StartDate=$o(^DHCOLT(0,"ARTTA",Arcim,Tariff,StartDate)) q:(StartDate="")||(TarItmId'="")  d
	..q:(StartDate="")||(StartDate>+$h)
	..s LinkId=$o(^DHCOLT(0,"ARTTA",Arcim,Tariff,StartDate,""))
	..q:LinkId=""
	..s EndDate=$p(^DHCOLT(LinkId),"^",5)
	..q:(EndDate'="")&&(EndDate<+$h)
	..s TarItmId=Tariff
	
	q TarItmId
}

/// Descript:	根据医嘱项ID取账单单位
/// Creater:	Zhouyg
/// CreateDate:	20100302
/// Input:		ArcimDr-Arcim_rowid
/// Output:		Return
/// Return：	账单单位ID^账单单位描述
ClassMethod GetArcBuom(ArcimDr)
{
	N (ArcimDr)
	S Arcsub=$P(ArcimDr,"||",1)
	S Arcver=$P(ArcimDr,"||",2)
	Q:Arcsub="" ""
	Q:Arcver="" ""
	Q:'$D(^ARCIM(Arcsub,Arcver)) ""
	S BillUomDr=$P(^ARCIM(Arcsub,Arcver,8),"^",14)
	Q:BillUomDr="" ""
	Q:'$D(^CT("UOM",BillUomDr)) ""
	S BillUomDesc=$P(^CT("UOM",BillUomDr),"^",2)
	Q BillUomDr_"^"_BillUomDesc
}

/// Creator:	wangjiabin
/// CreatDate:	2014-02-08
/// Description:获得库存项的医保类别信息(新版医保类别保存在INFOInsuCatDR,值为rowid)
/// Table:		INC_Itm,DHC_ItmAddionInfo,DHC_ItmInsuCategory
/// Input:		库存项ID
/// Return:		医保类别id^code^desc
ClassMethod GetInsuCat(inci) As %Library.String
{
	n (inci)
	q:inci="" ""
	s add=$o(^DHCITMINFO(0,"INCI",inci,""))
	q:add="" ""
	s insu=$p($G(^DHCITMINFO(add)),"^",49)
	s insuCode="",insuDesc=""
	i (+insu>0)&&($d(^DHCITMIC(insu))) d
	.s insuCode=$p(^DHCITMIC(insu),"^",1)
	.s insuDesc=$p(^DHCITMIC(insu),"^",2)
	q insu_"^"_insuCode_"^"_insuDesc
}

/// Creator:	zhouyonggang
/// CreatDate:	2011-03-16
/// Description:获得库存项的类组信息
/// Table:		INC_Itm，DHC_StkCatGrpRelations
/// Input:		库存项ID
/// Return:		类组代码^类组描述^类组类型
/// 2016-03-09: Level缺省值由0改为1
ClassMethod GetIncStkCatGrp(inci, Type As %String = "M", Level As %String = "1") As %Library.String
{
	n (inci,Type,Level)
	s:Type="" Type=..sssCode()
	Q:inci="" ""
	Q:'$d(^INCI(inci,2)) ""
	s inccat=$p(^INCI(inci,2),"^",2)
	q:inccat="" ""
	s scg=..GetParSCG(inccat,Type,Level)
	q:scg="" ""
	s scgdesc=$p($g(^DHCSCG(scg)),"^",2)
	s scgcode=$p($g(^DHCSCG(scg)),"^",1)
	s scgtype=$p($g(^DHCSCG(scg)),"^",3)
	S scgtypeDesc=""
	S scgtypeDesc=..stktypeDesc(scgtype)
	s scgset=$p(^DHCSCG(scg),"^",5)
	s scgsetdesc=""
	i scgset="MM" s scgsetdesc="医用材料"
	i scgset="MO" s scgsetdesc="后勤材料"
	i scgset="MR" s scgsetdesc="试剂"
	i scgset="MF" s scgsetdesc="固定资产"
	q scgcode_"^"_scgdesc_"^"_scgtype_"^"_scgtypeDesc_"^"_scg_"^"_scgsetdesc_"^"_scgset
}

/// 根据分类取类组信息
/// Author:	zhwh
/// Date	2011-11-02
/// Argu:		
/// 	cat - 库存分类ID, StkType, Level(0:顶级类组,1:底层类组)
/// Return:		
/// 	字符串: 类组代码^类组描述^类组类型^类组类型名称^类组Rowid
/// Tables: 
/// 	INC_Itm，DHC_StkCatGrpRelations
/// 2016-03-10: Level缺省值由0改为1
ClassMethod StkCatGrpStr(cat As %String, Type As %String = "M", Level As %String = "1") As %String
{
	n (cat,Type,Level)
	q:cat="" ""
	s scg=..GetParSCG(cat,Type,Level)
	q:scg="" ""
	s scgdesc=$p(^DHCSCG(scg),"^",2)
	s scgcode=$p(^DHCSCG(scg),"^",1)
	s scgtype=$p(^DHCSCG(scg),"^",3)
	S scgtypeDesc=..stktypeDesc(scgtype)
	q scgcode_"^"_scgdesc_"^"_scgtype_"^"_scgtypeDesc_"^"_scg
}

/// 取大包装描述
/// Author:zhwh
/// Date:2012-07-20
/// Argu:
///  inci  -库存项rowid
/// Return:
///  大包装描述串
ClassMethod GetPackUom(inci As %String) As %String
{
	n (inci)
	s uom="",fac=""
	&sql(select INFO_PackUom,INFO_PackUomFactor into :uom,:fac from DHC_ItmAddionInfo where INFO_INCI_DR=:inci)
	q:SQLCODE ""
	q uom_" x "_fac
}

/// Creator:zhangdongmei
/// CreatDate:	2012-08-06
/// Description:获得库存项的医嘱子类信息
/// Table:ARC_ItmMast，ARC_ItemCat
/// Input:库存项ID
/// Return:	医嘱子类id^医嘱子类描述
ClassMethod GetArcItemCat(inci) As %Library.String
{
	n (inci)
 	; get the arc_item cat rowid according to stock item rowid
 	q:inci="" ""
 	s ARCIM=$p(^INCI(inci,1),"^",3) 
 	q:ARCIM="" ""
 	s sub=+ARCIM,ver=$p(ARCIM,"||",2) 
 	q:'$d(^ARCIM(sub,ver,1)) ""
 	s itemcat=$p(^ARCIM(sub,ver,1),"^",10)  
	s catdesc=""
 	s:itemcat'="" catdesc=$p(^ARC("IC",itemcat),"^",2) 
 	q itemcat_"^"_catdesc
}

/// Description:取得某库存项的定价类型信息
/// Input:		inci_itmRowid
/// Output:		定价类型
/// Creator:	wangjiabin
/// CreateDate:	2013-11-21
ClassMethod GetMarkType(inci)
{
	n (inci)
	q:inci="" ""
	s infoid=$o(^DHCITMINFO(0,"INCI",inci,""))
	q:infoid="" ""
	s spTypedr=$p(^DHCITMINFO(infoid),"^",15)
	s spType=""
	i spTypedr'="" d
	.s spType=$p($g(^DHCINMT(spTypedr)),"^",2)
	q spTypedr_"^"_spType
}

/// Description:取得某库存项的招标标志
/// Input:		inci_itm Rowid
/// Output:		Y/N
/// CreateDate:	2020-02-25 改为按INFO_PbFlag取值
ClassMethod GetItmPbFlag(inci)
{
	n (inci)
	q:inci="" ""
	s Info=$o(^DHCITMINFO(0,"INCI",inci,""))
	q:Info="" ""
	
	s PbFlag=$p($g(^DHCITMINFO(Info,1)),"^",10)
	s:PbFlag="" PbFlag="N"
	q PbFlag
}

/// Description:取得某库存项的招标级别
/// Input:inci_itmRowid
/// Output:招标级别
/// Creator:Liang Qiang
/// CreateDate:2009-03-15
ClassMethod GetItmAddtionPbLevel(inci)
{
	n (inci)
	q:inci="" ""
	s infoid=$o(^DHCITMINFO(0,"INCI",inci,""))
	q:infoid="" ""
	s PbLevel=$p(^DHCITMINFO(infoid),"^",30)
	q PbLevel
}

/// Description:取得某库存项的备案标志
/// Input:inci_itmRowid
/// Output:0-否 , 1-备案
/// Creator:Liang Qiang
/// CreateDate:2009-03-15
ClassMethod GetItmAddtionBAFlag(inci)
{
	n (inci)
	q:inci="" ""
	s infoid=$o(^DHCITMINFO(0,"INCI",inci,""))
	q:infoid="" ""
	s BAflag=$p(^DHCITMINFO(infoid),"^",29)
	q BAflag
}

/// Description:取得某库存项的进口标志
/// Input:DHC_ItmAddionInfo
/// Output:Y,N
/// Creator:zdm
/// CreateDate:2012-01-16
ClassMethod GetItmImportFlag(inci)
{
	n (inci)
	q:inci="" ""
	s infoid=$o(^DHCITMINFO(0,"INCI",inci,""))
	q:infoid="" ""
	s Impflag=$p(^DHCITMINFO(infoid),"^",2)
	q Impflag
}

/// 库存类型名称
/// Author:zhwh
/// Date:2013-04-27
/// Argu: 
///  type - 库存类型代码值
/// Return:
///   库存类型名称
ClassMethod stktypeDesc(scgtype As %String) As %String
{
	n (scgtype)
	I scgtype="G" q "Drug"
	I scgtype="M" q "Material"
	q "Other"
}

/// CreatDate:2013-05-15
/// Description:取库存项高值标志
/// Table:DHC_ItmAddionInfo
/// Input:库存项代码
/// Return:高值标志：Y/N
ClassMethod GetIncHighValueFlag(inci) As %String
{
	n (inci)
	q:inci="" ""
	s flag="N"
	s info=$o(^DHCITMINFO(0,"INCI",inci,""))
	q:info="" flag
	s flag=$p(^DHCITMINFO(info),"^",12)
	s:flag="" flag="N"
	q flag
}

/// 根据库存项RowID取得
ClassMethod GetBrand(inci) As %Library.String
{
	n (inci)
	q:inci="" ""
	s add=$o(^DHCITMINFO(0,"INCI",inci,""))
	q:add="" ""
	s brand=$p($G(^DHCITMINFO(add)),"^",58)
	q brand
}

/// 根据库存项RowID取得型号
ClassMethod GetModel(inci) As %Library.String
{
	n (inci)
	q:inci="" ""
	s add=$o(^DHCITMINFO(0,"INCI",inci,""))
	q:add="" ""
	s model=$p($G(^DHCITMINFO(add)),"^",59)
	q model
}

/// /// 根据库存项RowID取得简称
ClassMethod GetAbbrev(inci) As %Library.String
{
	n (inci)
	q:inci="" ""
	s add=$o(^DHCITMINFO(0,"INCI",inci,""))
	q:add="" ""
	s abbrev=$p($G(^DHCITMINFO(add)),"^",60)
	q abbrev
}

/// /// 根据库存项RowID取得监管级别
ClassMethod GetSupervision(inci) As %Library.String
{
	n (inci)
	q:inci="" ""
	s add=$o(^DHCITMINFO(0,"INCI",inci,""))
	q:add="" ""
	s Supervision=$p($G(^DHCITMINFO(add)),"^",61)
	q Supervision
}

/// Descript:取科室库存项所维护的货位
/// Creater:	LiangQaing
/// CreateDate:	2013-11-19
/// Table:
/// Input:科室库存项ID,分隔符,货位ID,货位描述
/// Output:		
/// Return:是否有相关货位:货位串
ClassMethod GetInciBinStr(incil, del = "", sbrowid = "", desc = "")
{
	n (incil, del,sbrowid, desc)
	s chkflag=0
	s ret=""
	s incilb=""
	f  s incilb=$o(^DHCINCILB(0,"Loc",incil,incilb)) q:incilb=""  d
	.s stkbindr=$p(^DHCINCILB(incilb),"^",2)
	.s stkbin=$p(^INC("SB",stkbindr),"^",2)
	.i ret="" d
	..s ret=stkbin
	.e  d
	..s ret=ret_del_stkbin
	.q:(stkbin'[desc)&(desc'="")
	.q:(stkbindr'=sbrowid)&(stkbindr'="")
	.s chkflag=1
	q chkflag_":"_ret
}

/// CreatDate:2014-05-28  tsr
/// Description:取库存项植入标志
/// Table:DHC_ItmAddionInfo
/// Input: 库存项Rowid
/// Return:植入标志：Y/N
ClassMethod GetIncImplantationMat(inci) As %String
{
	n (inci)
	q:inci="" ""
	s flag="N"
	s info=$o(^DHCITMINFO(0,"INCI",inci,""))
	q:info="" flag
	s flag=$p(^DHCITMINFO(info),"^",62)
	s:flag="" flag="N"
	q flag
}

/// CreatDate: 2014-11-11  tsr
/// Description: 取库存项禁止请领标志
/// Table: DHC_ItmAddionInfo
/// Input: 库存项Rowid
/// Return: 禁止请领标志：Y/N
ClassMethod GetIncNoLocReq(inci) As %String
{
	n (inci)
	q:inci="" ""
	s flag="N"
	s info=$o(^DHCITMINFO(0,"INCI",inci,""))
	q:info="" flag
	s flag=$p(^DHCITMINFO(info),"^",74)
	s:flag="" flag="N"
	q flag
}

/// 返回类组的子类组(叶子)，若没有子类组时，返回本身
/// author:zhwh
/// Date:2014-03-04
/// Arguments:
/// par - 类组rowid
/// Return
///  子类组串
ClassMethod ChildScgStr(par, HospId = "") As %String
{
	n (par,HospId,%session)
	s r=$$GetChildScg(par)
	s ss=""
	f i=1:1:$l(r,",") d
	.i $p(r,",",i)'="" d
	..i ss="" s ss=$p(r,",",i)
	..e  s ss=ss_","_$p(r,",",i)
	i ss="" s ss=par
	s ss=##class(web.DHCSTMHUI.Util.StkGrp).filterScgByHosp(ss,HospId)
	q ss
GetChildScg(par) 
	n (par)
	s scg=""
	s result=""
	f  s scg=$o(^DHCSCG(0,"Parent",par,scg)) q:scg=""  d
	.i '$d(^DHCSCG(0,"Parent",scg)) d
	..s result=result_","_scg
	.e  d
	..s xx=$$GetChildScg(scg)
	..s result=result_","_xx
	q result
}

/// 返回库存分类的类组(最顶级)
/// Author:zhwh
/// Date:2014-03-04
/// Arguments :
/// incsc -库存分类rowid   Level=0返回顶级类组 Level=1 返回库存分类上的一级类组
/// Return:
///    最顶级类组 
/// 2016-03-10: Level缺省值由0改为1
ClassMethod GetParSCG(incsc As %String, Type As %String = "M", Level As %String = "1") As %String
{
	n (incsc,Type,Level)
	s:Type="" Type=..sssCode()
	s scg="",flag=0,tmpscg2=""
	f  s scg=$o(^DHCSCG("STKCAT",incsc,scg)) q:(scg="")!(flag=1)  d
	.s scgtype=$p(^DHCSCG(scg),"^",3)
	.q:scgtype'=Type
	.s flag=1
	.s tmpscg2=scg
	q:tmpscg2="" ""
	q:Level=1 tmpscg2
	s scg=tmpscg2
	s par=""
	;添加tmpScg,避免上级类组错误维护成自身后出现的死循环
	f  s tmpScg=scg,scg=$p($g(^DHCSCG(scg)),"^",4) q:(scg="")!(scg=tmpScg)  d
	.s scgtype=$p(^DHCSCG(scg),"^",3)
	.q:scgtype'=Type
	.s par=scg
	i par="" d
	.s par=tmpScg
	q par
}

/// Description:返回类组以及其所有子类(缺省逗号隔开)
/// Creator:	wangjiabin
/// CreateDate:	2016-03-09
/// Input:		类组id, 分隔符
/// Output:		类组串
ClassMethod GetAllChildScgStr(par As %String, delim As %String) As %String
{
	n (par,delim)
	s:$g(delim)="" delim=","
	q:par="" ""
	s ret=$$GetChildrenScg(par)
	;加上自身
	i ret="" s ret=par
	e  s ret=par_","_ret
	s ret=$tr(ret,",",delim)
	q ret
GetChildrenScg(par) 
	n (par)
	s result=""
	s scg=""
	f  s tmpScg=scg,scg=$o(^DHCSCG(0,"Parent",par,scg)) q:(scg="")||(scg=tmpScg)  d
	.i result="" s result=scg
	.e  s result=result_","_scg
	.s children=$$GetChildrenScg(scg)
	.q:children=""
	.s result=result_","_children

	q result
}

/// 获取收费标志(Y,N)
ClassMethod GetChargeFlag(inci)
{
	n (inci)
	q:inci="" "N"
	s add=$o(^DHCITMINFO(0,"INCI",inci,0))
	q:add="" "N"
	s charge=$p(^DHCITMINFO(add),"^",57)
	q:charge="" "N"
	q charge
}

/// 获取零库存标志(Y,N)
ClassMethod GetZeroStkFlag(inci, loc = "")
{
	n (inci,loc)
	s ZeroStkFlag=""
	i loc'="" d
	.&sql(select INCIL_RowId into :incil from inc_itmloc where INCIL_CTLOC_DR=:loc and INCIL_INCI_ParRef=:inci) 
	.&sql(select INCIL_ZeroStk into :ZeroStkFlag from DHC_IncItmLoc where INCIL_INCIL_DR=:incil)
	.i ZeroStkFlag="" d
	..s hosid=##class(web.DHCSTMHUI.StkTypeM).sssHospId(loc)
	..&sql(select IncHosp_Zero into :ZeroStkFlag from DHC_IncHosp where IncHosp_INCI_DR=:inci and IncHosp_HOSP_DR=:hosid)
	q:ZeroStkFlag'="" ZeroStkFlag
	q:inci="" "N"
	s add=$o(^DHCITMINFO(0,"INCI",inci,0))
	q:add="" "N"
	s ZeroStkFlag=$p(^DHCITMINFO(add),"^",81)
	q:ZeroStkFlag="" "N"
	q ZeroStkFlag
}

/// 根据库存项RowID取得注册证和注册证效期
/// Return:	注册证号^注册证效期^注册证物资名称^注册证号全称^注册证发证日期
/// w ##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetCert(8)
ClassMethod GetCert(inci, manf = "") As %Library.String
{
	n (inci,manf)
	
	s MatRegCertDR=""
	i manf="" d
	.s dhcitmid=$o(^DHCITMINFO(0,"INCI",inci,""))
	.q:dhcitmid=""
	.q:'$d(^DHCITMINFO(dhcitmid))
	.s MatRegCertDR=$p($g(^DHCITMINFO(dhcitmid,1)),"^",18)
	e  d
	.s RelaId=""
	.f  s RelaId=$o(^User.DHCItmRegRelationsI("Inci",inci,RelaId),-1) q:(RelaId="")||(MatRegCertDR'="")  d
	..s RelaInfo=^User.DHCItmRegRelationsD(RelaId)
	..s RegCertId=$lg(RelaInfo,2)
	..s MRCManfId=$p(^DHCMRCT(RegCertId),"^",2)
	..q:(MRCManfId'=manf)
	..s MatRegCertDR=RegCertId
	
	s (CerNo,CerExpDate,CertItmDesc,IRRegCertNoFull,IRRegCertDateOfIssue,RegExpExtended,RegValidLong)=""
	s (MRCEnglishDesc,MRCProArea,MRCProCountry,MRCProCouEngName,MRCRegStandard,MRCStructure,MRCAppliedRange,MRCRegAgent,MRCSPDAChangeDate,MRCRegName,
		MRCRegPerAddress,MRCAgentAddress,MRCSpecForm,MRCRemark,MRCApprovalDate,MRCCategory,RegSpecNum)=""
	
	i MatRegCertDR'="" d
	.q:'$d(^DHCMRCT(MatRegCertDR))
	.s info=^DHCMRCT(MatRegCertDR)
	.
	.s MRCEnglishDesc=$p(info,"^",3)	;物资英文名称
	.s MRCAppliedRange=$p(info,"^",4)	;适用范围
	.s MRCProArea=$p(info,"^",5)		;生产场所
	.s MRCProCouEngName=$p(info,"^",6)	;生产国家英文描述
	.s MRCProCountry=$p(info,"^",7)		;生产国家
	.s MRCRegAgent=$p(info,"^",8)		;注册代理
	.s MRCRegStandard=$p(info,"^",9)	;注册标准
	.s MRCSPDAChangeDate=$p(info,"^",10)	;药监局变更日期
	.s MRCStructure=$p(info,"^",11)		;性能结构及组成
	.s CerNo=$p(info,"^",12)			;注册证号
	.s MRCRegName=$p(info,"^",13)		;注册人名称 生产厂家
	.s MRCRegPerAddress=$p(info,"^",14)	;注册人地址 生产厂家地址
	.s MRCAgentAddress=$p(info,"^",15)	;代理人住所
	.s CertItmDesc=$p(info,"^",16)		;注册名称
	.s MRCSpecForm=$p(info,"^",17)		;规格型号
	.s MRCRemark=$p(info,"^",18)		;备注
	.s MRCApprovalDate=$p(info,"^",19)	;批准日期
	.s CerExpDate=$p(info,"^",20)		;有效期
	.s MRCCategory=$p(info,"^",21)		;注册证类型
	.s RegValidLong=$p(info,"^",22)		;注册证长期标志
	.s RegExpExtended=$p(info,"^",23)	;注册证延长效期标志
	.s RegSpecNum=$p(info,"^",24)		;规格型号数
	.
	.s:CerExpDate'="" CerExpDate=..DL2H(CerExpDate)
	.s:MRCSPDAChangeDate'="" MRCSPDAChangeDate=..DL2H(MRCSPDAChangeDate)
	.s:MRCApprovalDate'="" MRCApprovalDate=..DL2H(MRCApprovalDate)
	.s IRRegCertNoFull=""				;注册证号全称
	.s IRRegCertDateOfIssue=""			;注册证发证日期

	s Data=CerNo_"^"_CerExpDate_"^"_CertItmDesc_"^"_IRRegCertNoFull_"^"_IRRegCertDateOfIssue_"^"_RegExpExtended_"^"_RegValidLong_"^"_MRCEnglishDesc_"^"_MRCProArea_"^"_MRCProCountry
		_"^"_MRCProCouEngName_"^"_MRCRegStandard_"^"_MRCStructure_"^"_MRCAppliedRange_"^"_MRCRegAgent_"^"_MRCSPDAChangeDate_"^"_MRCRegName_"^"_MRCRegPerAddress_"^"_MRCAgentAddress_"^"_MRCSpecForm
		_"^"_MRCRemark_"^"_MRCApprovalDate_"^"_MRCCategory_"^"_RegSpecNum
	q Data
}

/// 获取打包收费标志(Y,N)
ClassMethod GetPackChargeFlag(inci)
{
	n (inci)
	q:inci="" "N"
	s add=$o(^DHCITMINFO(0,"INCI",inci,0))
	q:add="" "N"
	s packcharge=$p(^DHCITMINFO(add),"^",85)
	q:packcharge="" "N"
	q packcharge
}

/// 获取账簿分类
ClassMethod GetBookCat(inci)
{
	n (inci)
	q:inci="" ""
	s add=$o(^DHCITMINFO(0,"INCI",inci,0))
	q:add="" ""
	s bcDr=$p(^DHCITMINFO(add),"^",36)
	q:bcDr="" ""
	s bcCode=$p(^DHCSTBC(bcDr),"^",1)
	s bcDesc=$p(^DHCSTBC(bcDr),"^",2)
	q bcDr_"^"_bcCode_"^"_bcDesc
}

/// 获取耗材的"跟台"标记
ClassMethod GetTableFlag(inci) As %String
{
	n (inci)
	q:inci="" "N"
	s add=$o(^DHCITMINFO(0,"INCI",inci,0))
	q:add="" "N"
	s flag=$p(^DHCITMINFO(add),"^",50)	;暂时用高危标志
	q:flag="" "N"
	q flag
}

/// 获取库存项创建日期时间以及更新日期时间
/// 20160922 lihui
/// w ##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetInciCreateDate(2915)
ClassMethod GetInciCreateDate(inci) As %Library.String
{
	n (inci)
	q:inci="" "^^^"
	s (incicreateDate,incicreateTime,inciupdateDate,inciupdateTime)=""
	s inciupdateDate=$p(^INCI(inci,3),"^",1)
	s inciupdateTime=$p(^INCI(inci,3),"^",2)
	s dhcinfoid=$o(^DHCITMINFO(0,"INCI",inci,""))
	i dhcinfoid'="" d
	.s incicreateDate=$p(^DHCITMINFO(dhcinfoid),"^",94)
	.s incicreateTime=$p(^DHCITMINFO(dhcinfoid),"^",95)
	q incicreateDate_"^"_incicreateTime_"^"_inciupdateDate_"^"_inciupdateTime
}

/// 获取库存项是否可用标记 20170721lihui
/// w ##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetNotUseFlag(8703)
ClassMethod GetNotUseFlag(inci) As %String
{
	n (inci)
	q:inci="" "N"
	q:'$d(^INCI(inci)) "N"
	s UseFlag=$p(^INCI(inci,2),"^",9)	;不可用标志
	q:UseFlag="" "N"
	q UseFlag
}

/// Descrption:获取计量标记
/// Date:20190815
/// liuhui
/// w ##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetMetringflag(3316)
ClassMethod GetMetringflag(inci) As %String
{
	n (inci)
	q:inci="" "N"
	q:'$d(^INCI(inci)) "N"
	s Matringflag="N"
	s dhcinfoid=$o(^DHCITMINFO(0,"INCI",inci,""))
    i dhcinfoid'=""  d
	.s Matringflag=$p($g(^DHCITMINFO(dhcinfoid,1)),"^",16)	;计量标志

	q:Matringflag="" "N"
	q Matringflag
}

/// Description:根据入库日期供应商
/// Date:20191112
/// liuhui
/// w ##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetDateVendor(66275,511)
ClassMethod GetDateVendor(IngrDate, Vendor) As %String
{
	n (IngrDate,Vendor)
	q:IngrDate="" ""
	q:Vendor="" ""
	s VenDesc=""
	s Stdate=""
	f  s Stdate=$o(^DHCSTVH(0,"SDVend",Vendor,Stdate))	q:(Stdate="")||((VenDesc'=""))  d
	.q:IngrDate<Stdate
	.s STVHId=""
	.f  s STVHId=$o(^DHCSTVH(0,"SDVend",Vendor,Stdate,STVHId))  q:(STVHId="")||(VenDesc'="")  d
	..s Enddate=$p(^DHCSTVH(STVHId),"^",3)
	..q:(Enddate'="")&&(IngrDate'<Enddate)
	..s STVHName=$p(^DHCSTVH(STVHId),"^",5)
	..s:STVHName'="" VenDesc=STVHName
	s:VenDesc="" VenDesc=$p(^APC("APCVM",Vendor),"^",3)
	q VenDesc
}

/// 获取一次性标志(Y,N)
ClassMethod GetBAFlag(inci)
{
	n (inci)
	q:inci="" "N"
	s add=$o(^DHCITMINFO(0,"INCI",inci,0))
	q:add="" "N"
	s BAflag=$p(^DHCITMINFO(add),"^",29)
	q:BAflag="" "N"
	q BAflag
}

/// Descript:	依据库存项取hospid
/// Creator:	lxt
/// CreateDate:	2020/4/23
/// Table:		IN_Po
/// Input:		排序，查询条件
/// Return：	订单信息
/// w ##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetInciHospID()
ClassMethod GetInciHospID(inci)
{
	n (inci)
	q:inci="" ""
	s RowId=$o(^ITMADDHOP(0,"Inci",inci,0))
	q:RowId="" ""
	s HospId=$p(^ITMADDHOP(RowId),"^",2)
	q HospId
}

/// Descript:	判断库存项类组是否存在科室类组中
/// Creator:	lxt
/// CreateDate:	2020-06-30
/// Table:		Inc_itm
/// Input:		排序，查询条件
/// Return：	0都在科室类组中  <>0存在不再科室类组中物资
/// w ##class(web.DHCSTMHUI.Common.DrugInfoCommon).CheckLocIncludeInciScg()
ClassMethod CheckLocIncludeInciScg(LocId, InciStr)
{
	n (LocId,InciStr)
	q:((LocId="")||(InciStr="")) -1
	
	s LocScgStr=##class(web.DHCSTMHUI.Util.DrugUtil).GetUserCatGrpStr("","M",LocId)
	q:LocScgStr="" 0
	
	s ret=0
	s Len=$l(InciStr,",")
	f i=1:1:Len d
	.s Inci=$p(InciStr,",",i)
	.s InciScg=$p(..GetIncStkCatGrp(Inci),"^",5)
	.s:("^"_LocScgStr_"^")'[("^"_InciScg_"^") ret=-2
	.q:ret'=0
	
	q ret
}

/// CreatDate:2019-09-04
/// Description:根据库存Id获取批次码管理标志
/// Table:DHC_ItmAddionInfo
/// Input:库存项Id
/// Return:批次码管理标志标志：Y/N
ClassMethod GetBatchCodeFlag(Inci) As %String
{
	n (Inci)
	q:Inci="" ""
	s Flag="N"
	s Info=$o(^DHCITMINFO(0,"INCI",Inci,""))
	q:Info="" Flag
	s Flag=$p($G(^DHCITMINFO(Info,1)),"^",23)
	s:Flag="" Flag="N"
	q Flag
}

/// Description:根据计费项rowid获取库存项rowid
/// Input:		DHC_TarItem表的rowid
/// Return:		库存项rowid(inc_itm), 或""
/// w ##Class(web.DHCSTMHUI.Common.DrugInfoCommon).GetInciIdByTarId(2349)
ClassMethod GetInciIdByTarId(TarItemId)
{
	n (TarItemId)
	q:TarItemId="" ""
	s InciId=""
	s Date=+$h
	
	s StartDate=""
	f  s StartDate=$o(^DHCOLT(0,"TAR",TarItemId,StartDate),-1) q:(StartDate="")||(InciId'="")  d
	.s OltId=""
	.f  s OltId=$o(^DHCOLT(0,"TAR",TarItemId,StartDate,OltId),-1) q:(OltId="")||(InciId'="")  d
	..s OltInfo=^DHCOLT(OltId)
	..s ArcimId=$p(OltInfo,"^",1)
	..s EndDate=$p(OltInfo,"^",5)
	..q:(EndDate'="")&&(EndDate<Date)
	..s Arc=$p(ArcimId,"||",1)
	..q:Arc=""
	..s InciId=$o(^INCI(0,"ARCIM_DR",Arc,""))
	
	q InciId
}

/// Descrption:获取重点关注标志
/// Date:20210325
/// creater:wxj
/// w ##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetMonitorFlag(832)
ClassMethod GetMonitorFlag(inci) As %String
{
	n (inci)
	q:inci="" "N"
	s Info=$o(^DHCITMINFO(0,"INCI",inci,""))
	q:Info="" "N"	
	s MonitorFlag=$p($g(^DHCITMINFO(Info)),"^",93)
	s:MonitorFlag="" MonitorFlag="N"
	q MonitorFlag
}

ClassMethod GetLastManf(IncId) As %Library.String
{
	n (IncId)
	s ManfId="",ManfDesc=""
	;
	s Ingr=""
	f  s Ingr=$o(^DHCINGR(0,"INCI",IncId,Ingr),-1) q:(Ingr="")!(ManfDesc'="")  d
	.s Chl=""
	.f  s Chl=$o(^DHCINGR(0,"INCI",IncId,Ingr,Chl),-1) q:(Chl="")!(ManfDesc'="")  d
	..q:'$d(^DHCINGR(Ingr))
	..s IngrDate=$P(^DHCINGR(Ingr),"^",4)
	..q:IngrDate=""
	..s ManfId=$p(^DHCINGR(Ingr,"GRI",Chl),"^",29)
	..s:ManfId'="" ManfDesc=$p(^PHMNF(ManfId),"^",2)
	..
	.
	q ManfId_"^"_ManfDesc
}

/// 库存分类信息
/// w ##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncsc("11")
ClassMethod GetIncsc(Inci) As %String
{
	n (Inci)
	s Inci=+Inci
	q:'$d(^INCI(Inci,2)) ""
	s IncscId=$p(^INCI(Inci,2),"^",2)
	q:IncscId="" ""
	
	s IncscCode=$p($g(^INC("SC",IncscId)),"^",1)
	s IncscDesc=$p($g(^INC("SC",IncscId)),"^",2)
	s StkType=$p($g(^INC("SC",IncscId)),"^",3)
	
	q IncscId_"^"_IncscCode_"^"_IncscDesc_"^"_StkType
}

/// 官方分类
ClassMethod GetOfficialCat(Inci)
{
	n (Inci)
	q:Inci="" ""
	s Info=$o(^DHCITMINFO(0,"INCI",Inci,""))
	q:Info="" ""
	s CatId=$p(^DHCITMINFO(Info),"^",107)
	q:CatId="" ""
	s CatCode=$p(^DHCMCO(CatId),"^",1)
	s CatDesc=$p(^DHCMCO(CatId),"^",2)
	q CatId_"^"_CatCode_"^"_CatDesc
}

/// 重点关注分类
ClassMethod GetClinicCat(Inci)
{
	n (Inci)
	q:Inci="" ""
	s Info=$o(^DHCITMINFO(0,"INCI",Inci,""))
	q:Info="" ""
	s CatId=$p(^DHCITMINFO(Info),"^",108)
	q:CatId="" ""
	s CatCode=$p($g(^DHCMCC(CatId)),"^",1)
	s CatDesc=$p($g(^DHCMCC(CatId)),"^",2)
	q CatId_"^"_CatCode_"^"_CatDesc
}

/// Descript:	获取库存项信息(object)
/// Creator:	wangjiabin
/// CreateDate:	2021-07-30
/// Input:		Inci, ScgType(类组类型:M-物资库存类组, O-财务类组)
/// Output:     object型
/// s obj=##class(web.DHCSTMHUI.DHCINGdRecStat).GetInciObj(2,"M")
ClassMethod GetInciObj(Inci, ScgType = "M", HospId)
{
	n (Inci,ScgType,HospId)
	s:ScgType="" ScgType=..sssCode()
	
	s Obj={}
	q:(Inci="")||'$d(^INCI(Inci,1)) Obj
	s InciCode=$p(^INCI(Inci,1),"^",1)
	s InciDesc=$p(^INCI(Inci,1),"^",2)
	s BUomId=$p(^INCI(Inci,1),"^",10)	;基本单位
	s PUomId=$p(^INCI(Inci,3),"^",6)	;入库单位
	s IncscId=$p(^INCI(Inci,2),"^",2)
	q:(BUomId="")||(PUomId="")||(IncscId="") Obj
	
	s UomFac=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(PUomId,BUomId)
	s BUomDesc=$p(^CT("UOM",BUomId),"^",2)
	s PUomDesc=$p(^CT("UOM",PUomId),"^",2)
	s IncscCode=$s(IncscId'="":$p(^INC("SC",IncscId),"^",1),1:"")
	s IncscDesc=$s(IncscId'="":$p(^INC("SC",IncscId),"^",2),1:"")
	s HVFlag=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncHighValueFlag(Inci)
	s ChargeFlag=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetChargeFlag(Inci)
	s ScgInfo=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncStkCatGrp(Inci,ScgType)
	s StkGrpDesc=$p(ScgInfo,"^",2),ScgId=$p(ScgInfo,"^",5)
	
	s MarkTypeInfo=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetMarkType(Inci)
	s MarkTypeId=$p(MarkTypeInfo,"^",1)
	s MarkType=$p(MarkTypeInfo,"^",2)

	s ImpFlag=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetItmImportFlag(Inci)
	s PbFlag=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetItmPbFlag(Inci)
	
	s Spec=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetSpec("",Inci)
	s Model=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetModel(Inci)
	s Brand=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetBrand(Inci)
	s ManfInfo=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetManf(Inci)
	s ManfId=$p(ManfInfo,"^",1)
	s ManfDesc=$p(ManfInfo,"^",3)
	s CertInfo=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetCert(Inci)
	s CertNo=$p(CertInfo,"^",1)			;注册证号
	s CertDesc=$p(CertInfo,"^",3)		;注册证名称
	s MonitorFlag=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetMonitorFlag(Inci)
	s BookCatInfo=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetBookCat(Inci)
	s BookCatId=$p(BookCatInfo,"^",1),BookCatCode=$p(BookCatInfo,"^",2),BookCatDesc=$p(BookCatInfo,"^",3)
	s MatInsuInfo=##class(web.DHCSTMHUI.Common.ServiceCommon).GetInsuInfo(Inci,HospId)
	s MatInsuCode=$p(MatInsuInfo,"^",1)
	s MatInsuDesc=$p(MatInsuInfo,"^",2)
	s OfficialCat=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetOfficialCat(Inci)	//68分类
	s OfficialCatId=$p(OfficialCat,"^",1),OfficialCatDesc=$p(OfficialCat,"^",3)
	s ClinicCat=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetClinicCat(Inci)	//重点关注分类
	s ClinicCatId=$p(ClinicCat,"^",1),ClinicCatDesc=$p(ClinicCat,"^",3)
	s PurCode=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetPurCode(Inci)	//阳光采购编码
	s LastVendorInfo=##class(web.DHCSTMHUI.Common.DrugStkCommon).GetLastVen(Inci)
	s LastVendorId=$p(LastVendorInfo,"^",1)
	s LastVendorDesc=$p(LastVendorInfo,"^",2)
	s PbLevel=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetItmAddtionPbLevel(Inci)
	s PbLevelDesc=$s(PbLevel'="":$p($g(^DHCITMPBL(PbLevel)),"^",2),1:"")
	s Obj.InciCode=InciCode
	s Obj.InciDesc=InciDesc
	s Obj.BUomId=BUomId
	s Obj.PUomId=PUomId
	s Obj.UomFac=UomFac
	s Obj.BUomDesc=BUomDesc
	s Obj.PUomDesc=PUomDesc
	s Obj.HVFlag=HVFlag
	s Obj.ChargeFlag=ChargeFlag
	s Obj.IncscId=IncscId
	s Obj.IncscCode=IncscCode
	s Obj.IncscDesc=IncscDesc
	s Obj.ScgId=ScgId
	s Obj.StkGrpDesc=StkGrpDesc
	s Obj.MarkTypeId=MarkTypeId
	s Obj.MarkType=MarkType
	s Obj.ImpFlag=ImpFlag
	s Obj.PbFlag=PbFlag
	s Obj.Spec=Spec
	s Obj.Model=Model
	s Obj.Brand=Brand
	s Obj.ManfId=ManfId
	s Obj.ManfDesc=ManfDesc
	s Obj.CertNo=CertNo
	s Obj.CertDesc=CertDesc
	s Obj.MonitorFlag=MonitorFlag
	s Obj.BookCatId=BookCatId
	s Obj.BookCatCode=BookCatCode
	s Obj.BookCatDesc=BookCatDesc
	s Obj.MatInsuDesc=MatInsuDesc
	s Obj.MatInsuCode=MatInsuCode
	s Obj.OfficialCatId=OfficialCatId
	s Obj.OfficialCatDesc=OfficialCatDesc
	s Obj.ClinicCatId=ClinicCatId
	s Obj.ClinicCatDesc=ClinicCatDesc
	s Obj.PurCode=PurCode
	s Obj.LastVendorId=LastVendorId
	s Obj.LastVendorDesc=LastVendorDesc
	s Obj.PbLevel=PbLevel
	s Obj.PbLevelDesc=PbLevelDesc
	
	q Obj
}

/// Descript:	取库存项附加表国家医保代码、国家医保名称
/// Creator:	wxj
/// CreateDate:	2022-04-22
/// Input:		Inci库存项ID
/// Output:     国家医保代码^国家医保名称
/// w ##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetInciInsuInfo(2)
ClassMethod GetInciInsuInfo(Inci) As %Library.String
{
	n (Inci)
	q:Inci="" ""
	s MatInsuInfo=""
	s Info=$o(^DHCITMINFO(0,"INCI",Inci,""))
	q:Info="" ""
	s MatInsuCode=$p($g(^DHCITMINFO(Info,1)),"^",39)
	s MatInsuDesc=$p($g(^DHCITMINFO(Info,1)),"^",54)
	s MatInsuInfo=MatInsuCode_"^"_MatInsuDesc
	q MatInsuInfo
}

/// Descript:	根据库存项RowID取得国家医保代码、国家医保名称
/// Creator:	wxj
/// CreateDate:	2022-04-08
/// Input:		Inci库存项ID,HosptialID:院区ID
/// Output:     国家医保代码^国家医保名称
/// w ##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetMatInsuInfo(2)
ClassMethod GetMatInsuInfo(Inci, HosptialID) As %Library.String
{
	n (Inci,HosptialID)
	q:Inci="" ""
	s MatInsuInfo=..GetInciInsuInfo(Inci)
	//若无基础数据平台国家医保取值配置，按库存项取值
	s InsuConfig=##class(web.DHCSTMHUI.Common.ServiceCommon).GetInsuConfig(HosptialID)
	q:InsuConfig="" MatInsuInfo
	//若有收费项且有国家医保取值配置,按医保组接口取值
	s TarItmId=..GetTARI(Inci)
	i TarItmId'="" d
	.s MatInsuInfo=##class(web.DHCSTMHUI.Common.ServiceCommon).GetInsuInfo(Inci, HosptialID)		;TARIInsuCode
	q MatInsuInfo
}

/// Descript:	取阳光采购编码
/// Creator:	wxj
/// CreateDate:	2022-04-22
/// Input:		Inci库存项ID
/// Output:     阳光采购编码
/// w ##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetPurCode(2)
ClassMethod GetPurCode(Inci) As %Library.String
{
	n (Inci)
	q:Inci="" ""
	s Info=$o(^DHCITMINFO(0,"INCI",Inci,""))
	q:Info="" ""
	s PurCode=$p($g(^DHCITMINFO(Info)),"^",56)
	q PurCode
}

/// Descript:	取临采标志及临采最大入库量
/// Creator:	wxj
/// CreateDate:	2023-03-21
/// Input:		Inci--库存项Rowid
/// Output:     临采标志_"^"_临采最大入库量
/// w ##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetTemPurchaseInfo(2)
ClassMethod GetTemPurchaseInfo(inci) As %Library.String
{
	n (inci)
	q:inci="" ""
	s Info=$o(^DHCITMINFO(0,"INCI",inci,""))
	q:Info="" ""
	
	s TemPurchaseFlag=$p($g(^DHCITMINFO(Info,1)),"^",17)
	s:TemPurchaseFlag="" TemPurchaseFlag="N"
	s RecMaxQty=$p($g(^DHCITMINFO(Info)),"^",121)
	q TemPurchaseFlag_"^"_RecMaxQty
}

/// Descript:	取装备协会编码
/// Creator:	wxj
/// CreateDate:	2023-04-07
/// Input:		Inci--库存项Rowid
/// Output:     装备协会编码
/// w ##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetEquAssCode(2)
ClassMethod GetEquAssCode(inci) As %Library.String
{
	n (inci)
	q:inci="" ""
	s Info=$o(^DHCITMINFO(0,"INCI",inci,""))
	q:Info="" ""	
	s EquAssCode=$p($g(^DHCITMINFO(Info,1)),"^",37)
	q EquAssCode
}

/// 获取采购类型
/// w ##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetDictValDesc("SunPur","22,23")
ClassMethod GetDictValDesc(DictType, DictValIdStr) As %String
{
	n (DictType,DictValIdStr)
	q:DictType="" ""
	q:DictValIdStr="" ""
	s DictValDescStr=""
	s Len=$l(DictValIdStr,",")
	f i=1:1:Len d
	.s DictValId=$p(DictValIdStr,",",i)
	.q:'$d(^CT.HRP.MAT.ComDictValueD(DictValId))
	.s DictValType=$lg(^CT.HRP.MAT.ComDictValueD(DictValId),2)
	.q:DictValType'=DictType
	.s DictValDesc=$lg(^CT.HRP.MAT.ComDictValueD(DictValId),4)
	.s DictValDescStr=$s(DictValDescStr="":DictValDesc,1:DictValDescStr_","_DictValDesc)
	q DictValDescStr
}

}
