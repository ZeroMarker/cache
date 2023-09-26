Import sqluser

Class web.DHCST.DrugInfoMaintain Extends (%RegisteredObject, %XML.Adaptor, StkTypeG) [ Not ProcedureBlock ]
{

Parameter AppName [ Final ] = "DHCSTDRUGMAINTAIN";

/// Descript:	查询三大项信息
/// Creater:	ZhangDongmei
/// CreateDate:	2012-05-04
/// Table:INC_Itm,DHC_IncItmAddionInfo,Arc_ItmMast,PHC_DrgMast,PHC_DrgForm
/// Input:开始行，每页显示记录数,库存项名称,代码，别名,库存分类id,是否包含不可用标志，
/// 药学大类id^药学子类id^药学更小分类id^类组id^药学多级分类id^药品状态(新增,不可用等)^开始瑞^结束日期
/// Output:
/// Return：库存项id，代码，名称，规格，厂商，入库单位，售价（入库单位），基本单位，
/// 计价单位，剂型，商品名，通用名，库存分类，药学大类，药学子类，药学小类，不可用标志
/// LastUpdate:yunhaibao,20151127,添加多列,并规范程序写法
/// w ##class(web.DHCST.DrugInfoMaintain).GetItm("0","30","","",$c(1,1)_"amxl"_$c(1,1)_"N"_$c(1)_"^^^^^OnlyUse^^",10213,"2")	
ClassMethod GetItm(Start, Limit, Sort, Dir, Params, User = "", HospitalRowid = "") As %Library.String
{

	n (Start, Limit,Sort,Dir, Params,User,HospitalRowid)
	s ^TMPDHCSTPARAMS("web.DHCST.DrugInfoMaintain","GetItm")=$lb(Start,Limit,Sort,Dir,Params,User, HospitalRowid)
	s $ZT="ErrorGetItm"
	i Params="" w ##class(web.DHCSTEXTCOMMON).GetNoJson()
	q:Params="" ""
	s RowDelim=##class(web.DHCST.Common.UtilCommon).RowDataDelim() 
	s InciDesc=$p(Params,RowDelim,1)
	s InciCode=$p(Params,RowDelim,2)
	s Alias=$p(Params,RowDelim,3)
	s StkCatId=$p(Params,RowDelim,4)
	s AllFlag=$p(Params,RowDelim,5)
	s Others=$p(Params,RowDelim,6)
	i $p(Others,"^",6)'="" s AllFlag="Y"
	s User=$g(User)
	s CatGrpStr=$p(Others,"^",4)
	// 药品查询,不控制类组权限
	s:CatGrpStr="" CatGrpStr=##class(web.DHCST.Util.DrugUtil).GetStkCatGroupRowId(..sssCode())
	s count=0  ;总记录数
	s End=+Start+Limit
	s Start=Start+1
	;q:(InciDesc="")&(InciCode="")&(Alias="")&(StkCatId="") ""   ;不能同时为空
	i InciCode'=""  d
	.i $D(^INCI(0,"Code1",$$ALPHAUP^SSUTIL4(InciCode)_"Z")) d
	..s ret=..GetItmByCode(InciCode,AllFlag,CatGrpStr,HospitalRowid)
	.e  d
	..s ret=..GetItmStartWithCode(InciCode,AllFlag,CatGrpStr,Others,Sort,HospitalRowid) 
	.s pid=$p(ret,"^",1)
	.s count=$p(ret,"^",2)
	e  i InciDesc'="" d
	.i $D(^INCI(0,"Desc",$$ALPHAUP^SSUTIL4(InciDesc))) d
	..s ret=..GetItmByDesc(InciDesc,AllFlag,CatGrpStr,Sort,HospitalRowid)
	.e  d
	..s ret=..GetItmStartWithDesc(InciDesc,AllFlag,CatGrpStr,Others,Sort,HospitalRowid) 
	.s pid=$p(ret,"^",1)
	.s count=$p(ret,"^",2)
	e  i Alias'=""  d
	.s ret=..GetItmByAlias(Alias,AllFlag,Others,CatGrpStr,Sort,HospitalRowid)
	.s pid=$p(ret,"^",1)
	.s count=$p(ret,"^",2)
	e  i StkCatId'=""  d
	.s ret=..GetItmByStkCat(StkCatId,AllFlag,Others,Sort,HospitalRowid)
	.s pid=$p(ret,"^",1)
	.s count=$p(ret,"^",2)
	e  d
	.s ret=..GetAllItm(AllFlag,Others,Sort,CatGrpStr,HospitalRowid)
	.s pid=$p(ret,"^",1)
	.s count=$p(ret,"^",2)
	i pid="" w ##class(web.DHCSTEXTCOMMON).GetNoJson()
	q:pid="" ""
	i count=0 w ##class(web.DHCSTEXTCOMMON).GetNoJson()
	q:count=0 ""
	//每行10个
	s Title1="InciRowid^InciCode^InciDesc^Spec^Manf^PurUom^Sp^BUom^BillUom^Form"
	s Title2="GoodName^GenericName^StkCat^PhcCat^PhcSubCat^PhcMinCat^NotUseFlag^PhaCatAllDesc^ArcItemCat"
	s Title3="OrderCat^Rp^InstrDesc^FreqDesc^PoisonDesc^ItmRemark^MaxSp^CountryBasicFlag^ProvinceBasicFlag^AntiFlag"
	s Title4="InHosFlag^ImportFlag^CodexFlag^DrugUseInfo^StkGrpDesc^OutUomDesc^InUomDesc"
	s Title=Title1_"^"_Title2_"^"_Title3_"^"_Title4
	i End>count s End=count
	s Dir=$$ALPHAUP^SSUTIL4(Dir)
    s:(Dir="")&(Dir'="ASC")&(Dir'="DESC") Dir="DESC"
    i Dir="DESC" s orderflag="-1"
    e  s orderflag="1"
	s exit=0
	s num=0
	s sub=""
	f  s sub=$o(^TMPITMINFO(pid,"ITM",sub),orderflag) q:(sub="")||(exit=1)  d
	.s chl=0
	.f  s chl=$o(^TMPITMINFO(pid,"ITM",sub,chl)) q:(chl="")||(exit=1)  d
	..s num=num+1
	..i num>End s exit=1
	..q:(num<Start)     ;只返回当前页需要显示的记录
	..q:(num>End)
	..s data=^TMPITMINFO(pid,"ITM",sub,chl)
	..// 补零,7,21
	..s sp=$p(data,"^",7)
	..s rp=$p(data,"^",21)
	..s $p(data,"^",7)=$fn(sp,"",$l($p(sp,".",2)))
	..s $p(data,"^",21)=$fn(rp,"",$l($p(rp,".",2)))
	..i num=Start d
	...w ##class(web.DHCSTEXTCOMMON).GetJsonStartString(count)
	...s retstring=##class(web.DHCST.Common.UtilCommon).GetJsonStr(data,Title)
	...w retstring
	..e  d
	...s retstring=##class(web.DHCST.Common.UtilCommon).GetJsonStr(data,Title)
	...w ","_retstring
 	w "]}"
 	k ^TMPITMINFO(pid)      
 	q 
ErrorGetItm
	i $d(pid) k ^TMPITMINFO(pid)    
	s Error=$$Error^DHCSTERROR()
    Set Method=	"##class(web.DHCST.DrugInfoMaintain).GetItm"
	Set ErrorMsg=Method_"("""_Start_""","""_Limit_""","""_Sort_""","""_Dir_""","""_Params_""","""_User_""","""_HospitalRowid_""")"_"</br>"_Error
	w "{Error:'"_ErrorMsg_"'}"
	q ""
}

/// Descript:	查询三大项信息------此函数Bug没有传入医院ID，对集团化医院有影响
/// Creater:	ZhangDongmei
/// CreateDate:	2011-12-14
/// Table:INC_Itm,DHC_IncItmAddionInfo,Arc_ItmMast,PHC_DrgMast,PHC_DrgForm
/// Input:库存项名称,是否包含不可用标志，
/// Output:	库存项id，代码，名称，规格，厂商，入库单位，售价（入库单位），基本单位，
/// 计价单位，剂型，商品名，通用名，库存分类，药学大类，药学子类，药学小类，不可用标志	
/// Return：
/// w ##class(web.DHCST.DrugInfoMaintain).GetItmByDesc("阿莫西林胶囊[0.5g*16粒]","","")
ClassMethod GetItmByDesc(InciDesc, AllFlag, CatGrpStr = "", Sort = "", HospID = "") As %Library.String
{

	n (InciDesc,AllFlag,CatGrpStr,Sort,HospID)
	q:InciDesc="" ""
	s pid=..NewPid()
	k ^TMPITMINFO(pid)
	s InciDesc=$$ALPHAUP^SSUTIL4(InciDesc)
	s InciId=0
	s num=0
	f  s InciId=$o(^INCI(0,"Desc",InciDesc,InciId)) q:InciId=""  d
	.q:'..IsInCatGrpStr(InciId,$G(CatGrpStr)) //类组权限过滤
	.q:##class(PHA.FACE.IN.Com).GetShowDataFlag("INC_Itm",InciId,HospID)="N" //医院级别授权
	.s Code=$p(^INCI(InciId,1),"^",1)
	.s Desc=$p(^INCI(InciId,1),"^",2)
	.s PurUomId=$p(^INCI(InciId,3),"^",6)
	.s BUomId=$p(^INCI(InciId,1),"^",10)
	.s TmpGrpInfo=##class(web.DHCST.Common.DrugInfoCommon).GetIncStkCatGrp(InciId)
	.s TmpGrpType=$p(TmpGrpInfo,"^",3)
	.q:TmpGrpType'=..sssCode()
	.s StkGrpDesc=$p(TmpGrpInfo,"^",2)
	.s:PurUomId'="" PurUomDesc=$p($g(^CT("UOM",PurUomId)),"^",2)
	.s:BUomId'="" BUomDesc=$p($g(^CT("UOM",BUomId)),"^",2)
	.s OutUomId=$p(^INCI(InciId,1),"^",12)
	.s InUomId=$p(^INCI(InciId,1),"^",13)
	.s:OutUomId'="" OutUomDesc=$p($g(^CT("UOM",OutUomId)),"^",2)
	.s:InUomId'="" InUomDesc=$p($g(^CT("UOM",InUomId)),"^",2)
	.//s Sp=##class(web.DHCST.Common.PriceCommon).GetPriceElse(InciId,+$h,PurUomId)
	.//s Sp=##class(web.DHCST.Common.PriceCommon).GetPriceElse(InciId,+$h,PurUomId,HospID,"G","")
	.s Sp=##Class(web.DHCSTPRICE).GetFormatSp(InciId,+$h,PurUomId,HospID,"")	//zhouyg 20141204
	.s StkCatDr=$p(^INCI(InciId,2),"^",2)
	.s:StkCatDr'="" StkCatDesc=$p(^INC("SC",StkCatDr),"^",2)
	.s NotUseFlag=$p(^INCI(InciId,2),"^",9)
	.//q:(AllFlag'="Y")&(NotUseFlag'="N")			;不显示不可用项目,yunhaibao20151210,按名称查不考虑不可用
	.s spec=""
	.s InfoId=$o(^DHCITMINFO(0,"INCI",InciId,0))
	.i InfoId'=""  d
	..s spec=$p(^DHCITMINFO(InfoId),"^",27)
	.s ArcId=$p(^INCI(InciId,1),"^",3)
	.s PHCDF=##class(web.DHCST.Common.DrugInfoCommon).GetPhcdf(InciId)
	.s (PhcCatDesc,PhcSubCatDesc,PhcMinCatDesc)=""
	.;8.0以前药学三级分类
	.;s PhcCatInfo=##class(web.DHCST.Common.DrugInfoCommon).GetPhcCat(InciId)
	.;s PhcCatDesc=$p(PhcCatInfo,"^",1)
	.;s PhcSubCatInfo=##class(web.DHCST.Common.DrugInfoCommon).GetPhcSubCat(InciId)
	.;s PhcSubCatDesc=$p(PhcSubCatInfo,"^",1)
	.;s PhcMinCatInfo=##class(web.DHCST.Common.DrugInfoCommon).GetPhcMinCat(InciId)
	.;s PhcMinCatDesc=$p(PhcMinCatInfo,"^",1)
	.//wyx 2015-04-22 增加药学多级分类过滤
	.s PhaCatAllDesc=""
	.s PhaCatAllstr=##class(web.DHCST.Common.DrugInfoCommon).GetPhaCatAll(InciId)
	.s PhaCatAlls=$p(PhaCatAllstr,"^",1)
	.s PhaCatAllDesc=$p(PhaCatAllstr,"^",2)
	.
	.s LabelName=##class(web.DHCST.Common.DrugInfoCommon).GetGoodNameByPhcd(+PHCDF)
	.s GenericName=##class(web.DHCST.Common.DrugInfoCommon).GetGeneByPhcd(+PHCDF)
	.s GenericName=$p(GenericName,"^",2)
	.s FormDesc=##class(web.DHCST.Common.DrugInfoCommon).GetFormByPhcdf(PHCDF)
	.s FormDesc=$p(FormDesc,"^",2)
	.s Manf=##class(web.DHCST.Common.DrugInfoCommon).GetManf(InciId)
	.s Manf=$p(Manf,"^",3)
	.s BillUom=##class(web.DHCST.Common.DrugInfoCommon).GetArcBuom(ArcId)
	.s BillUomDesc=$p(BillUom,"^",2)
	.s ArcItemCat=##class(web.DHCST.Common.DrugInfoCommon).GetArcItemCat(InciId)   //医嘱子类
	.s ArcItemCat=$p(ArcItemCat,"^",2)
	.s OrderCat=##class(web.DHCST.Common.DrugInfoCommon).GetOrderCategoryByArcim(ArcId)   //医嘱大类
	.s OrderCat=$p(OrderCat,"^",2)
	.s Rp=##Class(web.DHCSTPRICE).GetFormatRp(InciId,+$h,PurUomId,HospID,"")	//进价
	.s InstrStr=##class(web.DHCST.Common.DrugInfoCommon).GetPhcInstrByPhcdf(PHCDF)  //用法
	.s InstrDesc=$p(InstrStr,"^",2)
	.s FreqStr=##class(web.DHCST.Common.DrugInfoCommon).GetPhcFreqByPhcdf(PHCDF)  //频次
	.s FreqDesc=$p(FreqStr,"^",2)
	.s PoisonStr=##class(web.DHCST.Common.DrugInfoCommon).GetPhcPoisonByPhcd(+PHCDF)  //管制分类
	.s PoisonDesc=$p(PoisonStr,"^",2)
	.s ItmRemark=##class(web.DHCST.Common.DrugInfoCommon).GetInciRemark(InciId)  //批准文号
	.s MaxSp=##class(web.DHCST.Common.DrugInfoCommon).GetMaxSp(InciId)  //最高售价
	.s CountryBasicFlag=##class(web.DHCST.Common.DrugInfoCommon).GetCountryBasicFlag(InciId)  //国家基本药物
	.s ProvinceBasicFlag=##class(web.DHCST.Common.DrugInfoCommon).GetProvinceBasicFlag(InciId) //省基本药物
	.s AntiFlag=##class(web.DHCST.Common.DrugInfoCommon).GetAntiFlagByPhcdf(PHCDF)  //抗菌药标志
	.s InHosFlag=##class(web.DHCST.Common.DrugInfoCommon).GetInHosFlag(InciId)  //本院药品目录
	.s ImportFlag=##class(web.DHCST.Common.DrugInfoCommon).GetImportFlag(InciId)  //进口标志
	.s CodexFlag=##class(web.DHCST.Common.DrugInfoCommon).GetCodexFlag(InciId)  //中国药典标志
	.s DrugUseInfo=##class(web.DHCST.Common.DrugInfoCommon).GetDrugUseInfo(InciId)  //用药说明
	.s num=num+1
	.s data1=InciId_"^"_Code_"^"_Desc_"^"_$g(spec)_"^"_$g(Manf)_"^"_$g(PurUomDesc)_"^"_Sp
	.s data2=$g(BUomDesc)_"^"_$g(BillUomDesc)_"^"_$g(FormDesc)_"^"_$g(LabelName)_"^"_$g(GenericName)_"^"_$g(StkCatDesc)
	.s data3=$g(PhcCatDesc)_"^"_$g(PhcSubCatDesc)_"^"_$g(PhcMinCatDesc)_"^"_$g(NotUseFlag)_"^"_PhaCatAllDesc
	.s data4=ArcItemCat_"^"_OrderCat_"^"_Rp_"^"_InstrDesc_"^"_FreqDesc_"^"_PoisonDesc_"^"_ItmRemark_"^"_MaxSp_"^"_CountryBasicFlag_"^"_ProvinceBasicFlag
	.s data5=AntiFlag_"^"_InHosFlag_"^"_ImportFlag_"^"_CodexFlag_"^"_DrugUseInfo_"^"_StkGrpDesc_"^"_OutUomDesc_"^"_InUomDesc
	.;按rowid排序,分页用
	.s Index=InciId
	.i Sort="InciRowid" s Index=InciId
	.e  i Sort="InciCode" s Index=Code
	.e  i Sort="InciDesc" s Index=InciDesc
	.e  i Sort="Spec" s Index=$g(spec)
	.e  i Sort="Manf"  s Index=Manf
	.e  i Sort="PurUom"  s Index=PurUomDesc
	.e  i Sort="Sp"  s Index=Sp
	.e  i Sort="Rp"  s Index=Rp
	.e  i Sort="BUom"  s Index=BUomDesc
	.e  i Sort="BillUom"  s Index=BillUomDesc 
	.e  i Sort="Form"  s Index=FormDesc 
	.e  i Sort="GoodName"  s Index=LabelName 
	.e  i Sort="GenericName"  s Index=GenericName 
	.e  i Sort="StkCat"  s Index=StkCatDesc 
	.e  i Sort="ArcItemCat"  s Index=ArcItemCat 
	.e  i Sort="OrderCat"  s Index=OrderCat
	.e  i Sort="InstrDesc"  s Index=InstrDesc
	.e  i Sort="GenericName"  s Index=GenericName
	.e  i Sort="AntiFlag"  s Index=AntiFlag
	.e  i Sort="InHosFlag"  s Index=InHosFlag
	.e  i Sort="ImportFlag"  s Index=ImportFlag
	.e  i Sort="CodexFlag"  s Index=CodexFlag
	.e  i Sort="FreqDesc"  s Index=FreqDesc
	.e  i Sort="PoisonDesc"  s Index=PoisonDesc
	.e  i Sort="CountryBasicFlag"  s Index=CountryBasicFlag
	.e  i Sort="ProvinceBasicFlag"  s Index=ProvinceBasicFlag
	.e  i Sort="NotUseFlag"  s Index=NotUseFlag 
	.e  s Index=InciId
	.i Index="" s Index="1"
	.s ^TMPITMINFO(pid,"ITM",Index,num)=data1_"^"_data2_"^"_data3_"^"_data4_"^"_data5
	.  
 	q pid_"^"_num
}

/// Descript:	查询三大项信息------此函数Bug没有传入医院ID，对集团化医院有影响
/// Creater:	ZhangDongmei
/// CreateDate:	2011-12-14
/// Table:INC_Itm,DHC_IncItmAddionInfo,Arc_ItmMast,PHC_DrgMast,PHC_DrgForm
/// Input:库存项代码,是否包含不可用标志，
/// Output:	库存项id，代码，名称，规格，厂商，入库单位，售价（入库单位），基本单位，
/// 计价单位，剂型，商品名，通用名，库存分类，药学大类，药学子类，药学小类，不可用标志	
/// Return：
ClassMethod GetItmByCode(InciCode, AllFlag, CatGrpStr = "", HospID = "") As %Library.String
{
    
	n (InciCode,AllFlag,CatGrpStr,HospID)
	q:InciCode="" ""
	s pid=..NewPid()
	k ^TMPITMINFO(pid)  
	s InciCode=$$ALPHAUP^SSUTIL4(InciCode)
	s InciId=$o(^INCI(0,"Code1",$$ALPHAUP^SSUTIL4(InciCode)_"Z","")) 
	q:InciId="" ""
	q:##class(PHA.FACE.IN.Com).GetShowDataFlag("INC_Itm",InciId,HospID)="N" ""
	q:'..IsInCatGrpStr(InciId,$G(CatGrpStr)) "" //类组权限过滤
	s TmpGrpInfo=##class(web.DHCST.Common.DrugInfoCommon).GetIncStkCatGrp(InciId)
	s TmpGrpType=$p(TmpGrpInfo,"^",3)
	s StkGrpDesc=$p(TmpGrpInfo,"^",2)
	q:TmpGrpType'=..sssCode() ""
	s InciDesc=$p(^INCI(InciId,1),"^",2)
	s PurUomId=$p(^INCI(InciId,3),"^",6)
	s BUomId=$p(^INCI(InciId,1),"^",10)
	s:PurUomId'="" PurUomDesc=$p($g(^CT("UOM",PurUomId)),"^",2)
	s:BUomId'="" BUomDesc=$p($g(^CT("UOM",BUomId)),"^",2)
	s OutUomId=$p(^INCI(InciId,1),"^",12)
	s InUomId=$p(^INCI(InciId,1),"^",13)
	s:OutUomId'="" OutUomDesc=$p($g(^CT("UOM",OutUomId)),"^",2)
	s:InUomId'="" InUomDesc=$p($g(^CT("UOM",InUomId)),"^",2)
	s Sp=##Class(web.DHCSTPRICE).GetFormatSp(InciId,+$h,PurUomId,HospID,"")	//zhouyg 20141204
	s StkCatDr=$p(^INCI(InciId,2),"^",2)
	s:StkCatDr'="" StkCatDesc=$p(^INC("SC",StkCatDr),"^",2)
	s NotUseFlag=$p(^INCI(InciId,2),"^",9)
	//q:(AllFlag'="Y")&(NotUseFlag'="N") ""			;不显示不可用项目yunhaibao20151210,按代码查不考虑不可用
	s spec=""
	s InfoId=$o(^DHCITMINFO(0,"INCI",InciId,0))
	i InfoId'=""  d
	.s spec=$p(^DHCITMINFO(InfoId),"^",27)
	s ArcId=$p(^INCI(InciId,1),"^",3)
	s PHCDF=##class(web.DHCST.Common.DrugInfoCommon).GetPhcdf(InciId)
	s (PhcCatDesc,PhcSubCatDesc,PhcMinCatDesc)=""
	/* 8.0以前药学三级分类
	s PhcCatInfo=##class(web.DHCST.Common.DrugInfoCommon).GetPhcCat(InciId)
	s PhcCatDesc=$p(PhcCatInfo,"^",1)
	s PhcSubCatInfo=##class(web.DHCST.Common.DrugInfoCommon).GetPhcSubCat(InciId)
	s PhcSubCatDesc=$p(PhcSubCatInfo,"^",1)
	s PhcMinCatInfo=##class(web.DHCST.Common.DrugInfoCommon).GetPhcMinCat(InciId)
	s PhcMinCatDesc=$p(PhcMinCatInfo,"^",1)
	*/
	//wyx 2015-04-22 增加药学多级分类过滤
	s PhaCatAllDesc=""
	s PhaCatAllstr=##class(web.DHCST.Common.DrugInfoCommon).GetPhaCatAll(InciId)
	s PhaCatAlls=$p(PhaCatAllstr,"^",1)
	s PhaCatAllDesc=$p(PhaCatAllstr,"^",2)
	;
	s LabelName=##class(web.DHCST.Common.DrugInfoCommon).GetGoodNameByPhcd(+PHCDF)
	s GenericName=##class(web.DHCST.Common.DrugInfoCommon).GetGeneByPhcd(+PHCDF)
	s GenericName=$p(GenericName,"^",2)
	s FormDesc=##class(web.DHCST.Common.DrugInfoCommon).GetFormByPhcdf(PHCDF)
	s FormDesc=$p(FormDesc,"^",2)
	s Manf=##class(web.DHCST.Common.DrugInfoCommon).GetManf(InciId)
	s Manf=$p(Manf,"^",3)
	s BillUom=##class(web.DHCST.Common.DrugInfoCommon).GetArcBuom(ArcId)
	s BillUomDesc=$p(BillUom,"^",2)	
	s ArcItemCat=##class(web.DHCST.Common.DrugInfoCommon).GetArcItemCat(InciId)   //医嘱子类
	s ArcItemCat=$p(ArcItemCat,"^",2)
	s OrderCat=##class(web.DHCST.Common.DrugInfoCommon).GetOrderCategoryByArcim(ArcId)   //医嘱大类
	s OrderCat=$p(OrderCat,"^",2)
	s Rp=##Class(web.DHCSTPRICE).GetFormatRp(InciId,+$h,PurUomId,HospID,"")	//进价
	s InstrStr=##class(web.DHCST.Common.DrugInfoCommon).GetPhcInstrByPhcdf(PHCDF)  //用法
	s InstrDesc=$p(InstrStr,"^",2)
	s FreqStr=##class(web.DHCST.Common.DrugInfoCommon).GetPhcFreqByPhcdf(PHCDF)  //频次
	s FreqDesc=$p(FreqStr,"^",2)
	s PoisonStr=##class(web.DHCST.Common.DrugInfoCommon).GetPhcPoisonByPhcd(+PHCDF)  //管制分类
	s PoisonDesc=$p(PoisonStr,"^",2)
	s ItmRemark=##class(web.DHCST.Common.DrugInfoCommon).GetInciRemark(InciId)  //批准文号
	s MaxSp=##class(web.DHCST.Common.DrugInfoCommon).GetMaxSp(InciId)  //最高售价
	s CountryBasicFlag=##class(web.DHCST.Common.DrugInfoCommon).GetCountryBasicFlag(InciId)  //国家基本药物
	s ProvinceBasicFlag=##class(web.DHCST.Common.DrugInfoCommon).GetProvinceBasicFlag(InciId) //省基本药物
	s AntiFlag=##class(web.DHCST.Common.DrugInfoCommon).GetAntiFlagByPhcdf(PHCDF)  //抗菌药标志
	s InHosFlag=##class(web.DHCST.Common.DrugInfoCommon).GetInHosFlag(InciId)  //本院药品目录
	s ImportFlag=##class(web.DHCST.Common.DrugInfoCommon).GetImportFlag(InciId)  //进口标志
    s CodexFlag=##class(web.DHCST.Common.DrugInfoCommon).GetCodexFlag(InciId)  //中国药典标志
    s DrugUseInfo=##class(web.DHCST.Common.DrugInfoCommon).GetDrugUseInfo(InciId)  //用药说明
	s data1=InciId_"^"_InciCode_"^"_InciDesc_"^"_$g(spec)_"^"_$g(Manf)_"^"_$g(PurUomDesc)_"^"_Sp
	s data2=$g(BUomDesc)_"^"_$g(BillUomDesc)_"^"_$g(FormDesc)_"^"_$g(LabelName)_"^"_$g(GenericName)_"^"_$g(StkCatDesc)
	s data3=$g(PhcCatDesc)_"^"_$g(PhcSubCatDesc)_"^"_$g(PhcMinCatDesc)_"^"_$g(NotUseFlag)_"^"_PhaCatAllDesc
	s data4=ArcItemCat_"^"_OrderCat_"^"_Rp_"^"_InstrDesc_"^"_FreqDesc_"^"_PoisonDesc_"^"_ItmRemark_"^"_MaxSp_"^"_CountryBasicFlag_"^"_ProvinceBasicFlag
	s data5=AntiFlag_"^"_InHosFlag_"^"_ImportFlag_"^"_CodexFlag_"^"_DrugUseInfo_"^"_StkGrpDesc_"^"_OutUomDesc_"^"_InUomDesc
	;按名称排序,分页用
	s ^TMPITMINFO(pid,"ITM",InciDesc,1)=data1_"^"_data2_"^"_data3_"^"_data4_"^"_data5
	;
 	q pid_"^"_1
}

/// Descript:	查询三大项信息------此函数Bug没有传入医院ID，对集团化医院有影响
/// Creater:	ZhangDongmei
/// CreateDate:	2011-12-14
/// Table:INC_Itm,DHC_IncItmAddionInfo,Arc_ItmMast,PHC_DrgMast,PHC_DrgForm
/// Input:别名,是否包含不可用标志，
/// Output:	库存项id，代码，名称，规格，厂商，入库单位，售价（入库单位），基本单位，
/// 计价单位，剂型，商品名，通用名，库存分类，药学大类，药学子类，药学小类，不可用标志	
/// Return：
ClassMethod GetItmByAlias(Alias, AllFlag, Others, CatGrpStr = "", Sort = "", HospID = "") As %Library.String
{

	n (Alias,AllFlag,Others,CatGrpStr,Sort,HospID)
	q:Alias="" ""
	s Alias=$$ALPHAUP^SSUTIL4(Alias)_"%"
	s StkGrpId=$p(Others,"^",4)
	s InciUseCondition=$p(Others,"^",6) //药品状态
	s InciStartDate=$p(Others,"^",7) //状态为医嘱截止,做截止日期用,状态为新增做新增日期(IncItm:Updatedate)
	s InciEndDate=$p(Others,"^",8) 
	i InciStartDate'="" s InciStartDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(InciStartDate)
	i InciEndDate'="" s InciEndDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(InciEndDate)
	s pid=..NewPid()
	k ^TMPITMINFO(pid)  
	s num=0
	&sql( declare xx1 cursor for select distinct inca_inci_dr From inc_alias 
	where %ALPHAUP(inca_text) like :Alias)
 	&sql(open xx1)
 	f  &sql(fetch xx1 into :InciId) q:SQLCODE  d
 	.q:'$d(^INCI(InciId,1))
	.q:'..IsInCatGrpStr(+InciId,$G(CatGrpStr))  //类组权限过滤
	.q:##class(PHA.FACE.IN.Com).GetShowDataFlag("INC_Itm",InciId,HospID)="N" //医院级别授权
	.s InciDesc=$p(^INCI(InciId,1),"^",2)
	.s Code=$p(^INCI(InciId,1),"^",1)
	.s PurUomId=$p(^INCI(InciId,3),"^",6)
	.s BUomId=$p(^INCI(InciId,1),"^",10)
	.s:PurUomId'="" PurUomDesc=$p($g(^CT("UOM",PurUomId)),"^",2)
	.s:BUomId'="" BUomDesc=$p($g(^CT("UOM",BUomId)),"^",2)
	.s OutUomId=$p(^INCI(InciId,1),"^",12)
	.s InUomId=$p(^INCI(InciId,1),"^",13)
	.s:OutUomId'="" OutUomDesc=$p($g(^CT("UOM",OutUomId)),"^",2)
	.s:InUomId'="" InUomDesc=$p($g(^CT("UOM",InUomId)),"^",2)
	.s Sp=##Class(web.DHCSTPRICE).GetFormatSp(InciId,+$h,PurUomId,HospID,"")	//zhouyg 20141204
	.s StkCatDr=$p(^INCI(InciId,2),"^",2)
	.s:StkCatDr'="" StkCatDesc=$p(^INC("SC",StkCatDr),"^",2)
	.s NotUseFlag=$p(^INCI(InciId,2),"^",9)
	.q:(AllFlag'="Y")&(NotUseFlag="Y")			;不显示不可用项目
	.s TmpGrpInfo=##class(web.DHCST.Common.DrugInfoCommon).GetIncStkCatGrp(InciId)
	.s TmpGrpType=$p(TmpGrpInfo,"^",3)
	.q:TmpGrpType'=..sssCode()
	.s TmpGrpId=$p(TmpGrpInfo,"^",5)
	.q:(StkGrpId'="")&(TmpGrpId'=StkGrpId)
	.s StkGrpDesc=$p(TmpGrpInfo,"^",2)
	.s ArcId=$p(^INCI(InciId,1),"^",3)
	.s InciUpdateDate=$p(^INCI(InciId,3),"^",1) ;新增日期用
	.s ArcStopDate=##class(web.DHCST.Common.DrugInfoCommon).GetArcItmStopDate(ArcId)  //医嘱截止日期
	.s ArcStopDate=+$p(ArcStopDate,"^",1)
	.i $d(^DHCINTR(0,"INCI",InciId)) s HavedUse="Y"
	.e  s HavedUse=""
	.q:(InciUseCondition="OnlyUse")&&(NotUseFlag="Y")  //在用,yunhaibao20151216,药品状态过滤
	.q:(InciUseCondition="OnlyNotUse")&&(NotUseFlag'="Y")   //不可用
	.q:(InciUseCondition="ArcStop")&&(ArcStopDate="0")  //医嘱截止
	.q:(InciUseCondition="ArcStop")&&(((InciStartDate'="")&&(ArcStopDate<InciStartDate))||((InciEndDate'="")&&(ArcStopDate>InciEndDate)))  
	.q:(InciUseCondition="ArcStop")&&(InciStartDate="")&&(InciEndDate="")&&(ArcStopDate="0")
	.q:(InciUseCondition="NewAdd")&&(InciUpdateDate="") //新增
	.q:(InciUseCondition="NewAdd")&&(((InciStartDate'="")&&(InciUpdateDate<InciStartDate))||((InciEndDate'="")&&(InciUpdateDate>InciEndDate)))  
	.q:(InciUseCondition="NewAdd")&&(InciStartDate="")&&(InciEndDate="")&&(HavedUse'="")  //日期范围为空时,未发生业务
	.s spec=""
	.s InfoId=$o(^DHCITMINFO(0,"INCI",InciId,0))
	.i InfoId'=""  d
	..s spec=$p(^DHCITMINFO(InfoId),"^",27)
	.s PHCDF=##class(web.DHCST.Common.DrugInfoCommon).GetPhcdf(InciId)
	.s (PhcCatDesc,PhcSubCatDesc,PhcMinCatDesc)=""
	.;s PhcCatInfo=##class(web.DHCST.Common.DrugInfoCommon).GetPhcCat(InciId)
	.;s PhcCatDesc=$p(PhcCatInfo,"^",1)
	.;s PhcSubCatInfo=##class(web.DHCST.Common.DrugInfoCommon).GetPhcSubCat(InciId)
	.;s PhcSubCatDesc=$p(PhcSubCatInfo,"^",1)
	.;s PhcMinCatInfo=##class(web.DHCST.Common.DrugInfoCommon).GetPhcMinCat(InciId)
	.;s PhcMinCatDesc=$p(PhcMinCatInfo,"^",1)
	.//wyx 2015-04-22 增加药学多级分类过滤
	.s PhaCatAllDesc=""
	.s PhaCatAllstr=##class(web.DHCST.Common.DrugInfoCommon).GetPhaCatAll(InciId)
	.s PhaCatAlls=$p(PhaCatAllstr,"^",1)
	.s PhaCatAllDesc=$p(PhaCatAllstr,"^",2)
	.s LabelName=##class(web.DHCST.Common.DrugInfoCommon).GetGoodNameByPhcd(+PHCDF)
	.s GenericName=##class(web.DHCST.Common.DrugInfoCommon).GetGeneByPhcd(+PHCDF)
	.s GenericName=$p(GenericName,"^",2)
	.s FormDesc=##class(web.DHCST.Common.DrugInfoCommon).GetFormByPhcdf(PHCDF)
	.s FormDesc=$p(FormDesc,"^",2)
	.s Manf=##class(web.DHCST.Common.DrugInfoCommon).GetManf(InciId)
	.s Manf=$p(Manf,"^",3)
	.s BillUom=##class(web.DHCST.Common.DrugInfoCommon).GetArcBuom(ArcId)
	.s BillUomDesc=$p(BillUom,"^",2)
	.s ArcItemCat=##class(web.DHCST.Common.DrugInfoCommon).GetArcItemCat(InciId)   //医嘱子类
	.s ArcItemCat=$p(ArcItemCat,"^",2)
	.s OrderCat=##class(web.DHCST.Common.DrugInfoCommon).GetOrderCategoryByArcim(ArcId)   //医嘱大类
	.s OrderCat=$p(OrderCat,"^",2)
	.s Rp=##Class(web.DHCSTPRICE).GetFormatRp(InciId,+$h,PurUomId,HospID,"")	//进价
	.s InstrStr=##class(web.DHCST.Common.DrugInfoCommon).GetPhcInstrByPhcdf(PHCDF)  //用法
	.s InstrDesc=$p(InstrStr,"^",2)
	.s FreqStr=##class(web.DHCST.Common.DrugInfoCommon).GetPhcFreqByPhcdf(PHCDF)  //频次
	.s FreqDesc=$p(FreqStr,"^",2)
	.s PoisonStr=##class(web.DHCST.Common.DrugInfoCommon).GetPhcPoisonByPhcd(+PHCDF)  //管制分类
	.s PoisonDesc=$p(PoisonStr,"^",2)
	.s ItmRemark=##class(web.DHCST.Common.DrugInfoCommon).GetInciRemark(InciId)  //批准文号
	.s MaxSp=##class(web.DHCST.Common.DrugInfoCommon).GetMaxSp(InciId)  //最高售价
	.s CountryBasicFlag=##class(web.DHCST.Common.DrugInfoCommon).GetCountryBasicFlag(InciId)  //国家基本药物
	.s ProvinceBasicFlag=##class(web.DHCST.Common.DrugInfoCommon).GetProvinceBasicFlag(InciId) //省基本药物
	.s AntiFlag=##class(web.DHCST.Common.DrugInfoCommon).GetAntiFlagByPhcdf(PHCDF)  //抗菌药标志
	.s InHosFlag=##class(web.DHCST.Common.DrugInfoCommon).GetInHosFlag(InciId)  //本院药品目录
	.s ImportFlag=##class(web.DHCST.Common.DrugInfoCommon).GetImportFlag(InciId)  //进口标志
	.s CodexFlag=##class(web.DHCST.Common.DrugInfoCommon).GetCodexFlag(InciId)  //中国药典标志
	.s DrugUseInfo=##class(web.DHCST.Common.DrugInfoCommon).GetDrugUseInfo(InciId)  //用药说明
	.s num=num+1
	.s Index=InciId
	.i Sort="InciRowid" s Index=InciId
	.e  i Sort="InciCode" s Index=Code
	.e  i Sort="InciDesc" s Index=InciDesc
	.e  i Sort="Spec" s Index=$g(spec)
	.e  i Sort="Manf"  s Index=Manf
	.e  i Sort="PurUom"  s Index=PurUomDesc
	.e  i Sort="Sp"  s Index=Sp
	.e  i Sort="Rp"  s Index=Rp
	.e  i Sort="BUom"  s Index=BUomDesc
	.e  i Sort="BillUom"  s Index=BillUomDesc 
	.e  i Sort="Form"  s Index=FormDesc 
	.e  i Sort="GoodName"  s Index=LabelName 
	.e  i Sort="GenericName"  s Index=GenericName 
	.e  i Sort="StkCat"  s Index=StkCatDesc 
	.e  i Sort="ArcItemCat"  s Index=ArcItemCat 
	.e  i Sort="OrderCat"  s Index=OrderCat
	.e  i Sort="InstrDesc"  s Index=InstrDesc
	.e  i Sort="GenericName"  s Index=GenericName
	.e  i Sort="AntiFlag"  s Index=AntiFlag
	.e  i Sort="InHosFlag"  s Index=InHosFlag
	.e  i Sort="ImportFlag"  s Index=ImportFlag
	.e  i Sort="CodexFlag"  s Index=CodexFlag
	.e  i Sort="FreqDesc"  s Index=FreqDesc
	.e  i Sort="PoisonDesc"  s Index=PoisonDesc
	.e  i Sort="CountryBasicFlag"  s Index=CountryBasicFlag
	.e  i Sort="ProvinceBasicFlag"  s Index=ProvinceBasicFlag
	.e  i Sort="NotUseFlag"  s Index=NotUseFlag 
	.e  s Index=InciId
	.i Index="" s Index="1"
	.s data1=InciId_"^"_Code_"^"_InciDesc_"^"_$g(spec)_"^"_$g(Manf)_"^"_$g(PurUomDesc)_"^"_Sp
	.s data2=$g(BUomDesc)_"^"_$g(BillUomDesc)_"^"_$g(FormDesc)_"^"_$g(LabelName)_"^"_$g(GenericName)_"^"_$g(StkCatDesc)
	.s data3=$g(PhcCatDesc)_"^"_$g(PhcSubCatDesc)_"^"_$g(PhcMinCatDesc)_"^"_$g(NotUseFlag)_"^"_PhaCatAllDesc
	.s data4=ArcItemCat_"^"_OrderCat_"^"_Rp_"^"_InstrDesc_"^"_FreqDesc_"^"_PoisonDesc_"^"_ItmRemark_"^"_MaxSp_"^"_CountryBasicFlag_"^"_ProvinceBasicFlag
	.s data5=AntiFlag_"^"_InHosFlag_"^"_ImportFlag_"^"_CodexFlag_"^"_DrugUseInfo_"^"_StkGrpDesc_"^"_OutUomDesc_"^"_InUomDesc
	.;按rowid排序,分页用
	.s ^TMPITMINFO(pid,"ITM",Index,num)=data1_"^"_data2_"^"_data3_"^"_data4_"^"_data5  
 	q pid_"^"_num
}

/// Descript:	查询三大项信息------此函数Bug没有传入医院ID，对集团化医院有影响
/// Creater:	ZhangDongmei
/// CreateDate:	2011-12-14
/// Table:INC_Itm,DHC_IncItmAddionInfo,Arc_ItmMast,PHC_DrgMast,PHC_DrgForm
/// Input:库存项名称,是否包含不可用标志，药学大类^药学子类^药学小类
/// Output:	库存项id，代码，名称，规格，厂商，入库单位，售价（入库单位），基本单位，
/// 计价单位，剂型，商品名，通用名，库存分类，药学大类，药学子类，药学小类，不可用标志	
/// Return：
ClassMethod GetItmByStkCat(StkCatId, AllFlag, Others, Sort = "", HospID = "") As %Library.String
{

	n (StkCatId,AllFlag,Others,Sort,HospID)
	q:StkCatId="" ""
	s pid=..NewPid()
	k ^TMPITMINFO(pid)  
	s PhcCatId=$p(Others,"^",1)
	s PhcSubCatId=$p(Others,"^",2)
	s PhcMinCatId=$p(Others,"^",3)
	s PhcCatAll=$p(Others,"^",5) //多级药学分类
	s InciUseCondition=$p(Others,"^",6) //药品状态
	s InciStartDate=$p(Others,"^",7) //状态为医嘱截止,做截止日期用,状态为新增做新增日期(IncItm:Updatedate)
	s InciEndDate=$p(Others,"^",8) 
	i InciStartDate'="" s InciStartDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(InciStartDate)
	i InciEndDate'="" s InciEndDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(InciEndDate)
	s InciId=0
	s num=0
	f  s InciId=$o(^INCI(0,"StkCat",StkCatId,InciId)) q:InciId=""  d
	.s Code=$p(^INCI(InciId,1),"^",1)
	.q:##class(PHA.FACE.IN.Com).GetShowDataFlag("INC_Itm",InciId,HospID)="N" 
	.s InciDesc=$p(^INCI(InciId,1),"^",2)
	.s TmpGrpInfo=##class(web.DHCST.Common.DrugInfoCommon).GetIncStkCatGrp(InciId)
	.s TmpGrpType=$p(TmpGrpInfo,"^",3)
	.q:TmpGrpType'=..sssCode()
	.s StkGrpDesc=$p(TmpGrpInfo,"^",2)
	.s PurUomId=$p(^INCI(InciId,3),"^",6)
	.s BUomId=$p(^INCI(InciId,1),"^",10)
	.s:PurUomId'="" PurUomDesc=$p($g(^CT("UOM",PurUomId)),"^",2)
	.s:BUomId'="" BUomDesc=$p($g(^CT("UOM",BUomId)),"^",2)
	.s OutUomId=$p(^INCI(InciId,1),"^",12)
	.s InUomId=$p(^INCI(InciId,1),"^",13)
	.s:OutUomId'="" OutUomDesc=$p($g(^CT("UOM",OutUomId)),"^",2)
	.s:InUomId'="" InUomDesc=$p($g(^CT("UOM",InUomId)),"^",2)
	.s Sp=##Class(web.DHCSTPRICE).GetFormatSp(InciId,+$h,PurUomId,HospID,"")	//zhouyg 20141204
	.s:StkCatId'="" StkCatDesc=$p(^INC("SC",StkCatId),"^",2)
	.s NotUseFlag=$p(^INCI(InciId,2),"^",9)
	.q:(AllFlag'="Y")&(NotUseFlag="Y")			;不显示不可用项目
	.s ArcId=$p(^INCI(InciId,1),"^",3)
	.s InciUpdateDate=$p(^INCI(InciId,3),"^",1) ;新增日期用
	.s ArcStopDate=##class(web.DHCST.Common.DrugInfoCommon).GetArcItmStopDate(ArcId)  //医嘱截止日期
	.s ArcStopDate=+$p(ArcStopDate,"^",1)
	.i $d(^DHCINTR(0,"INCI",InciId)) s HavedUse="Y"
	.e  s HavedUse=""
	.q:(InciUseCondition="OnlyUse")&&(NotUseFlag="Y")  //在用,yunhaibao20151216,药品状态过滤
	.q:(InciUseCondition="OnlyNotUse")&&(NotUseFlag'="Y")   //不可用
	.q:(InciUseCondition="ArcStop")&&(ArcStopDate="0")  //医嘱截止
	.q:(InciUseCondition="ArcStop")&&(((InciStartDate'="")&&(ArcStopDate<InciStartDate))||((InciEndDate'="")&&(ArcStopDate>InciEndDate)))  
	.q:(InciUseCondition="ArcStop")&&(InciStartDate="")&&(InciEndDate="")&&(ArcStopDate="0")
	.q:(InciUseCondition="NewAdd")&&(InciUpdateDate="") //新增
	.q:(InciUseCondition="NewAdd")&&(((InciStartDate'="")&&(InciUpdateDate<InciStartDate))||((InciEndDate'="")&&(InciUpdateDate>InciEndDate)))  
	.q:(InciUseCondition="NewAdd")&&(InciStartDate="")&&(InciEndDate="")&&(HavedUse'="")  //日期范围为空时,未发生业务
	.s spec=""
	.s InfoId=$o(^DHCITMINFO(0,"INCI",InciId,0))
	.i InfoId'=""  d
	..s spec=$p(^DHCITMINFO(InfoId),"^",27)
	.s PHCDF=##class(web.DHCST.Common.DrugInfoCommon).GetPhcdf(InciId)
	.s (PhcCatDesc,PhcSubCatDesc,PhcMinCatDesc)=""
	.;s PhcCatInfo=##class(web.DHCST.Common.DrugInfoCommon).GetPhcCat(InciId)
	.;s PhcCatDesc=$p(PhcCatInfo,"^",1)
	.;s TmpPhcCatId=$p(PhcCatInfo,"^",2)
	.;q:(PhcCatId'="")&(PhcCatId'=TmpPhcCatId)
	.;s PhcSubCatInfo=##class(web.DHCST.Common.DrugInfoCommon).GetPhcSubCat(InciId)
	.;s PhcSubCatDesc=$p(PhcSubCatInfo,"^",1)
	.;s PhcSubCatDr=$p(PhcSubCatInfo,"^",2)
	.;q:(PhcSubCatId'="")&(PhcSubCatId'=PhcSubCatDr)
	.;s PhcMinCatInfo=##class(web.DHCST.Common.DrugInfoCommon).GetPhcMinCat(InciId)
	.;s PhcMinCatDr=$p(PhcMinCatInfo,"^",2)
	.;s PhcMinCatDesc=$p(PhcMinCatInfo,"^",1)
	.;q:(PhcMinCatId'="")&(PhcMinCatDr'=PhcMinCatId)
	.//wyx 2015-04-22 增加药学多级分类过滤
	.s PhaCatAllDesc=""
	.s PhaCatAllstr=##class(web.DHCST.Common.DrugInfoCommon).GetPhaCatAll(InciId)
	.s PhaCatAlls=$p(PhaCatAllstr,"^",1)
	.s PhaCatAllDesc=$p(PhaCatAllstr,"^",2)
	.s retflag=##class(web.DHCST.Common.DrugInfoCommon).CheckNewCatId(PhcCatAll,PhaCatAlls)
	.q:(PhcCatAll'="")&(retflag=0) //add wyx 2014-12-08 药学多级分类
	.
	.s LabelName=##class(web.DHCST.Common.DrugInfoCommon).GetGoodNameByPhcd(+PHCDF)
	.s GenericName=##class(web.DHCST.Common.DrugInfoCommon).GetGeneByPhcd(+PHCDF)
	.s GenericName=$p(GenericName,"^",2)
	.s FormDesc=##class(web.DHCST.Common.DrugInfoCommon).GetFormByPhcdf(PHCDF)
	.s FormDesc=$p(FormDesc,"^",2)
	.s Manf=##class(web.DHCST.Common.DrugInfoCommon).GetManf(InciId)
	.s Manf=$p(Manf,"^",3)
	.s BillUom=##class(web.DHCST.Common.DrugInfoCommon).GetArcBuom(ArcId)
	.s BillUomDesc=$p(BillUom,"^",2)	
	.s ArcItemCat=##class(web.DHCST.Common.DrugInfoCommon).GetArcItemCat(InciId)   //医嘱子类
	.s ArcItemCat=$p(ArcItemCat,"^",2)
	.s OrderCat=##class(web.DHCST.Common.DrugInfoCommon).GetOrderCategoryByArcim(ArcId)   //医嘱大类
	.s OrderCat=$p(OrderCat,"^",2)
	.s Rp=##Class(web.DHCSTPRICE).GetFormatRp(InciId,+$h,PurUomId,HospID,"")	//进价
	.s InstrStr=##class(web.DHCST.Common.DrugInfoCommon).GetPhcInstrByPhcdf(PHCDF)  //用法
	.s InstrDesc=$p(InstrStr,"^",2)
	.s FreqStr=##class(web.DHCST.Common.DrugInfoCommon).GetPhcFreqByPhcdf(PHCDF)  //频次
	.s FreqDesc=$p(FreqStr,"^",2)
	.s PoisonStr=##class(web.DHCST.Common.DrugInfoCommon).GetPhcPoisonByPhcd(+PHCDF)  //管制分类
	.s PoisonDesc=$p(PoisonStr,"^",2)
	.s ItmRemark=##class(web.DHCST.Common.DrugInfoCommon).GetInciRemark(InciId)  //批准文号
	.s MaxSp=##class(web.DHCST.Common.DrugInfoCommon).GetMaxSp(InciId)  //最高售价
	.s CountryBasicFlag=##class(web.DHCST.Common.DrugInfoCommon).GetCountryBasicFlag(InciId)  //国家基本药物
	.s ProvinceBasicFlag=##class(web.DHCST.Common.DrugInfoCommon).GetProvinceBasicFlag(InciId) //省基本药物
	.s AntiFlag=##class(web.DHCST.Common.DrugInfoCommon).GetAntiFlagByPhcdf(PHCDF)  //抗菌药标志
	.s InHosFlag=##class(web.DHCST.Common.DrugInfoCommon).GetInHosFlag(InciId)  //本院药品目录
	.s ImportFlag=##class(web.DHCST.Common.DrugInfoCommon).GetImportFlag(InciId)  //进口标志
	.s CodexFlag=##class(web.DHCST.Common.DrugInfoCommon).GetCodexFlag(InciId)  //中国药典标志
	.s DrugUseInfo=##class(web.DHCST.Common.DrugInfoCommon).GetDrugUseInfo(InciId)  //用药说明
	.s num=num+1
	.s Index=InciId
	.i Sort="InciRowid" s Index=InciId
	.e  i Sort="InciCode" s Index=Code
	.e  i Sort="InciDesc" s Index=InciDesc
	.e  i Sort="Spec" s Index=$g(spec)
	.e  i Sort="Manf"  s Index=Manf
	.e  i Sort="PurUom"  s Index=PurUomDesc
	.e  i Sort="Sp"  s Index=Sp
	.e  i Sort="Rp"  s Index=Rp
	.e  i Sort="BUom"  s Index=BUomDesc
	.e  i Sort="BillUom"  s Index=BillUomDesc 
	.e  i Sort="Form"  s Index=FormDesc 
	.e  i Sort="GoodName"  s Index=LabelName 
	.e  i Sort="GenericName"  s Index=GenericName 
	.e  i Sort="StkCat"  s Index=StkCatDesc 
	.e  i Sort="ArcItemCat"  s Index=ArcItemCat 
	.e  i Sort="OrderCat"  s Index=OrderCat
	.e  i Sort="InstrDesc"  s Index=InstrDesc
	.e  i Sort="GenericName"  s Index=GenericName
	.e  i Sort="AntiFlag"  s Index=AntiFlag
	.e  i Sort="InHosFlag"  s Index=InHosFlag
	.e  i Sort="ImportFlag"  s Index=ImportFlag
	.e  i Sort="CodexFlag"  s Index=CodexFlag
	.e  i Sort="FreqDesc"  s Index=FreqDesc
	.e  i Sort="PoisonDesc"  s Index=PoisonDesc
	.e  i Sort="CountryBasicFlag"  s Index=CountryBasicFlag
	.e  i Sort="ProvinceBasicFlag"  s Index=ProvinceBasicFlag
	.e  i Sort="NotUseFlag"  s Index=NotUseFlag 
	.e  s Index=InciId
	.i Index="" s Index="1"
	.s data1=InciId_"^"_Code_"^"_InciDesc_"^"_$g(spec)_"^"_$g(Manf)_"^"_$g(PurUomDesc)_"^"_Sp
	.s data2=$g(BUomDesc)_"^"_$g(BillUomDesc)_"^"_$g(FormDesc)_"^"_$g(LabelName)_"^"_$g(GenericName)_"^"_$g(StkCatDesc)
	.s data3=$g(PhcCatDesc)_"^"_$g(PhcSubCatDesc)_"^"_$g(PhcMinCatDesc)_"^"_$g(NotUseFlag)_"^"_PhaCatAllDesc
	.s data4=ArcItemCat_"^"_OrderCat_"^"_Rp_"^"_InstrDesc_"^"_FreqDesc_"^"_PoisonDesc_"^"_ItmRemark_"^"_MaxSp_"^"_CountryBasicFlag_"^"_ProvinceBasicFlag
	.s data5=AntiFlag_"^"_InHosFlag_"^"_ImportFlag_"^"_CodexFlag_"^"_DrugUseInfo_"^"_StkGrpDesc_"^"_OutUomDesc_"^"_InUomDesc
	.;按rowid排序,分页用
	.s ^TMPITMINFO(pid,"ITM",Index,num)=data1_"^"_data2_"^"_data3_"^"_data4_"^"_data5
	.   
 	q pid_"^"_num
}

/// Descript:	查询三大项信息------此函数Bug没有传入医院ID，对集团化医院有影响
/// Creater:	ZhangDongmei
/// CreateDate:	2011-12-14
/// Table:INC_Itm,DHC_IncItmAddionInfo,Arc_ItmMast,PHC_DrgMast,PHC_DrgForm
/// Input:是否包含不可用标志，药学大类^药学子类^药学小类^类组
/// Output:	库存项id，代码，名称，规格，厂商，入库单位，售价（入库单位），基本单位，
/// 计价单位，剂型，商品名，通用名，库存分类，药学大类，药学子类，药学小类，不可用标志	
/// Return：
ClassMethod GetAllItm(AllFlag, Others, Sort, CatGrpStr = "", HospID = "") As %Library.String
{

	n (AllFlag,Others,Sort,CatGrpStr,HospID)
	s pid=..NewPid()
	k ^TMPITMINFO(pid)  
	s PhcCatId=$p(Others,"^",1)
	s PhcSubCatId=$p(Others,"^",2)
	s PhcMinCatId=$p(Others,"^",3)
	s StkGrpId=$p(Others,"^",4)
	s PhcCatAll=$p(Others,"^",5) //多级药学分类
	s InciUseCondition=$p(Others,"^",6) //药品状态
	s InciStartDate=$p(Others,"^",7) //状态为医嘱截止,做截止日期用,状态为新增做新增日期(IncItm:Updatedate)
	s InciEndDate=$p(Others,"^",8) 
	i InciStartDate'="" s InciStartDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(InciStartDate)
	i InciEndDate'="" s InciEndDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(InciEndDate)
	s num=0
	s Code=""
	f  s Code=$o(^INCI(0,"Code1",Code)) q:Code=""  d
	.s InciId=""
	.f  s InciId=$o(^INCI(0,"Code1",Code,InciId)) q:InciId=""  d
	..q:'..IsInCatGrpStr(InciId,$G(CatGrpStr))  //类组权限过滤
	..q:##class(PHA.FACE.IN.Com).GetShowDataFlag("INC_Itm",InciId,HospID)="N" 
	..s InciDesc=$p(^INCI(InciId,1),"^",2)
	..s TmpGrpInfo=##class(web.DHCST.Common.DrugInfoCommon).GetIncStkCatGrp(InciId)
	..s TmpGrpType=$p(TmpGrpInfo,"^",3)
	..q:TmpGrpType'=..sssCode()
	..s TmpGrpId=$p(TmpGrpInfo,"^",5)
	..q:(StkGrpId'="")&(TmpGrpId'=StkGrpId)
	..s StkGrpDesc=$p(TmpGrpInfo,"^",2)
	..s PurUomId=$p(^INCI(InciId,3),"^",6)
	..s BUomId=$p(^INCI(InciId,1),"^",10)
	..q:(PurUomId'="")&('$d(^CT("UOM",PurUomId)))
	..s:PurUomId'="" PurUomDesc=$p($g(^CT("UOM",PurUomId)),"^",2)
	..q:(BUomId'="")&('$d(^CT("UOM",BUomId)))
	..s:BUomId'="" BUomDesc=$p($g(^CT("UOM",BUomId)),"^",2)
	..s OutUomId=$p(^INCI(InciId,1),"^",12)
	..s InUomId=$p(^INCI(InciId,1),"^",13)
	..s:OutUomId'="" OutUomDesc=$p($g(^CT("UOM",OutUomId)),"^",2)
	..s:InUomId'="" InUomDesc=$p($g(^CT("UOM",InUomId)),"^",2)
	..s Sp=##Class(web.DHCSTPRICE).GetFormatSp(InciId,+$h,PurUomId,HospID,"")	//zhouyg 20141204
	..s StkCatId=$p(^INCI(InciId,2),"^",2)
	..s:StkCatId'="" StkCatDesc=$p(^INC("SC",StkCatId),"^",2)
	..s NotUseFlag=$p(^INCI(InciId,2),"^",9)
	..q:(AllFlag'="Y")&(NotUseFlag="Y")			;不显示不可用项目
	..s ArcId=$p(^INCI(InciId,1),"^",3)
	..s InciUpdateDate=$p(^INCI(InciId,3),"^",1) ;新增日期用
	..s ArcStopDate=##class(web.DHCST.Common.DrugInfoCommon).GetArcItmStopDate(ArcId)  //医嘱截止日期
	..s ArcStopDate=+$p(ArcStopDate,"^",1)
	..i $d(^DHCINTR(0,"INCI",InciId)) s HavedUse="Y"
	..e  s HavedUse=""
	..q:(InciUseCondition="OnlyUse")&&(NotUseFlag="Y")  //在用,yunhaibao20151216,药品状态过滤
	..q:(InciUseCondition="OnlyNotUse")&&(NotUseFlag'="Y")   //不可用
	..q:(InciUseCondition="ArcStop")&&(ArcStopDate="0")  //医嘱截止
	..q:(InciUseCondition="ArcStop")&&(((InciStartDate'="")&&(ArcStopDate<InciStartDate))||((InciEndDate'="")&&(ArcStopDate>InciEndDate)))  
	..q:(InciUseCondition="ArcStop")&&(InciStartDate="")&&(InciEndDate="")&&(ArcStopDate="0")
	..q:(InciUseCondition="NewAdd")&&(InciUpdateDate="") //新增
	..q:(InciUseCondition="NewAdd")&&(((InciStartDate'="")&&(InciUpdateDate<InciStartDate))||((InciEndDate'="")&&(InciUpdateDate>InciEndDate)))  
	..q:(InciUseCondition="NewAdd")&&(InciStartDate="")&&(InciEndDate="")&&(HavedUse'="")  //日期范围为空时,未发生业务
	..s spec=""
	..s InfoId=$o(^DHCITMINFO(0,"INCI",InciId,0))
	..i InfoId'=""  d
	...s spec=$p(^DHCITMINFO(InfoId),"^",27)
	..s PHCDF=##class(web.DHCST.Common.DrugInfoCommon).GetPhcdf(InciId)
	..q:PHCDF=""
	..s (PhcCatDesc,PhcSubCatDesc,PhcMinCatDesc)=""
	..//wyx 2015-04-22 增加药学多级分类过滤
	..s PhaCatAllDesc=""
	..s PhaCatAllstr=##class(web.DHCST.Common.DrugInfoCommon).GetPhaCatAll(InciId)
	..s PhaCatAlls=$p(PhaCatAllstr,"^",1)
	..s PhaCatAllDesc=$p(PhaCatAllstr,"^",2)
	..s retflag=##class(web.DHCST.Common.DrugInfoCommon).CheckNewCatId(PhcCatAll,PhaCatAlls)
	..q:(PhcCatAll'="")&(retflag=0) //add wyx 2014-12-08 药学多级分类
	..s LabelName=##class(web.DHCST.Common.DrugInfoCommon).GetGoodNameByPhcd(+PHCDF)
	..s GenericName=##class(web.DHCST.Common.DrugInfoCommon).GetGeneByPhcd(+PHCDF)
	..s GenericName=$p(GenericName,"^",2)
	..s FormDesc=##class(web.DHCST.Common.DrugInfoCommon).GetFormByPhcdf(PHCDF)
	..s FormDesc=$p(FormDesc,"^",2)
	..s Manf=##class(web.DHCST.Common.DrugInfoCommon).GetManf(InciId)
	..s Manf=$p(Manf,"^",3)
	..s BillUom=##class(web.DHCST.Common.DrugInfoCommon).GetArcBuom(ArcId)
	..s BillUomDesc=$p(BillUom,"^",2)
	..s ArcItemCat=##class(web.DHCST.Common.DrugInfoCommon).GetArcItemCat(InciId)   //医嘱子类
	..s ArcItemCat=$p(ArcItemCat,"^",2)
	..s OrderCat=##class(web.DHCST.Common.DrugInfoCommon).GetOrderCategoryByArcim(ArcId)   //医嘱大类
	..s OrderCat=$p(OrderCat,"^",2)
	..s Rp=##Class(web.DHCSTPRICE).GetFormatRp(InciId,+$h,PurUomId,HospID,"")	//进价
	..s InstrStr=##class(web.DHCST.Common.DrugInfoCommon).GetPhcInstrByPhcdf(PHCDF)  //用法
	..s InstrDesc=$p(InstrStr,"^",2)
	..s FreqStr=##class(web.DHCST.Common.DrugInfoCommon).GetPhcFreqByPhcdf(PHCDF)  //频次
	..s FreqDesc=$p(FreqStr,"^",2)
	..s PoisonStr=##class(web.DHCST.Common.DrugInfoCommon).GetPhcPoisonByPhcd(+PHCDF)  //管制分类
	..s PoisonDesc=$p(PoisonStr,"^",2)
	..s ItmRemark=##class(web.DHCST.Common.DrugInfoCommon).GetInciRemark(InciId)  //批准文号
	..s MaxSp=##class(web.DHCST.Common.DrugInfoCommon).GetMaxSp(InciId)  //最高售价
	..s CountryBasicFlag=##class(web.DHCST.Common.DrugInfoCommon).GetCountryBasicFlag(InciId)  //国家基本药物
	..s ProvinceBasicFlag=##class(web.DHCST.Common.DrugInfoCommon).GetProvinceBasicFlag(InciId) //省基本药物
	..s AntiFlag=##class(web.DHCST.Common.DrugInfoCommon).GetAntiFlagByPhcdf(PHCDF)  //抗菌药标志
	..s InHosFlag=##class(web.DHCST.Common.DrugInfoCommon).GetInHosFlag(InciId)  //本院药品目录
	..s ImportFlag=##class(web.DHCST.Common.DrugInfoCommon).GetImportFlag(InciId)  //进口标志
	..s CodexFlag=##class(web.DHCST.Common.DrugInfoCommon).GetCodexFlag(InciId)  //中国药典标志
	..s DrugUseInfo=##class(web.DHCST.Common.DrugInfoCommon).GetDrugUseInfo(InciId)  //用药说明
	..s TmpCode=$e(Code,0,($l(Code)-1))
	..s num=num+1
	..s data1=InciId_"^"_TmpCode_"^"_InciDesc_"^"_$g(spec)_"^"_$g(Manf)_"^"_PurUomDesc_"^"_Sp
	..s data2=BUomDesc_"^"_$g(BillUomDesc)_"^"_$g(FormDesc)_"^"_$g(LabelName)_"^"_$g(GenericName)_"^"_$g(StkCatDesc)
	..s data3=$g(PhcCatDesc)_"^"_$g(PhcSubCatDesc)_"^"_$g(PhcMinCatDesc)_"^"_$g(NotUseFlag)_"^"_PhaCatAllDesc
	..s data4=ArcItemCat_"^"_OrderCat_"^"_Rp_"^"_InstrDesc_"^"_FreqDesc_"^"_PoisonDesc_"^"_ItmRemark_"^"_MaxSp_"^"_CountryBasicFlag_"^"_ProvinceBasicFlag
	..s data5=AntiFlag_"^"_InHosFlag_"^"_ImportFlag_"^"_CodexFlag_"^"_DrugUseInfo_"^"_StkGrpDesc_"^"_OutUomDesc_"^"_InUomDesc
	..s Index=InciId
	..i Sort="InciRowid" s Index=InciId
	..e  i Sort="InciCode" s Index=Code
	..e  i Sort="InciDesc" s Index=InciDesc
	..e  i Sort="Spec" s Index=$g(spec)
	..e  i Sort="Manf"  s Index=Manf
	..e  i Sort="PurUom"  s Index=PurUomDesc
	..e  i Sort="Sp"  s Index=Sp
	..e  i Sort="Rp"  s Index=Rp
	..e  i Sort="BUom"  s Index=BUomDesc
	..e  i Sort="BillUom"  s Index=BillUomDesc 
	..e  i Sort="Form"  s Index=FormDesc 
	..e  i Sort="GoodName"  s Index=LabelName 
	..e  i Sort="GenericName"  s Index=GenericName 
	..e  i Sort="StkCat"  s Index=StkCatDesc 
	..e  i Sort="ArcItemCat"  s Index=ArcItemCat 
	..e  i Sort="OrderCat"  s Index=OrderCat
	..e  i Sort="InstrDesc"  s Index=InstrDesc
	..e  i Sort="GenericName"  s Index=GenericName
	..e  i Sort="AntiFlag"  s Index=AntiFlag
	..e  i Sort="InHosFlag"  s Index=InHosFlag
	..e  i Sort="ImportFlag"  s Index=ImportFlag
	..e  i Sort="CodexFlag"  s Index=CodexFlag
	..e  i Sort="FreqDesc"  s Index=FreqDesc
	..e  i Sort="PoisonDesc"  s Index=PoisonDesc
	..e  i Sort="CountryBasicFlag"  s Index=CountryBasicFlag
	..e  i Sort="ProvinceBasicFlag"  s Index=ProvinceBasicFlag
	..e  i Sort="NotUseFlag"  s Index=NotUseFlag 
	..e  s Index=InciId
	..i Index="" s Index="1"
	..s ^TMPITMINFO(pid,"ITM",Index,num)=data1_"^"_data2_"^"_data3_"^"_data4_"^"_data5
 	q pid_"^"_num
}

/// Descript:	保存/更新三大项信息
/// Creater:	ZhangDongmei
/// CreateDate:	2011-12-27
/// Table:PHC_DrgMast,PHC_DrgForm
/// Arc_ItmMast,Inc_Itm,DHC_ItmAddionInfo
/// Input:库存项rowid
/// 
/// 药学项数据串:代码^描述^剂型id^基本单位id^用法id^疗程id^基本数量^产地id^管制分类id
/// ^频次id^医保类别^处方通用名^药学分类id^药学子类id^药学小类id^英文国际非专利药名
/// ^国际专利药名^商品名^制剂通用名^原料通用名^住院按一天量计算^门诊按一天量计算^门诊皮试用原液
/// ^住院皮试用原液^DDD值
/// 
/// 医嘱项数据串:代码^描述^计价单位id^医嘱子类id^费用大类id^费用子类id^独立医嘱标志
/// ^默认医嘱优先级id^无库存医嘱标志^医保名称^别名^缩写
/// ^医保类别^最大量^限制使用天数^每天最大剂量^单次最大剂量^急诊用药^住院用药^门诊用药
/// ^体检用药^医嘱提示^是否维护收费项目标志^是否维护医保项目^收费子分类^住院子分类^门诊子分类
/// ^核算子分类^病历首页子分类^会计子分类^生效日期^截止日期^医嘱大类
/// 
/// 库存项数据串:代码^描述^基本单位id^入库单位id^库存分类id^转移方式
/// ^是否要求批次^是否要求效期^别名^不可用标志^协和码^条码^更新人^售价^进价
/// ^价格生效日期^规格^进口标志^质量层次^处方药分类^基本药物标志^中国药典标志
/// ^临床验证用药标志^处方购药标志^质量编号^国/省别^批准文号^高值类标志^定价类型id
/// ^最高售价^存储条件^本院药品目录^招标标志^招标进价^招标级别^招标供应商id^招标生产商id
/// ^招标配送商id^招标名称^阳光采购标志^效期长度^物价文件号^物价文件备案时间^皮试标志^帐簿分类id
/// ^用药说明^基本药物标志2^省增补药物标志1^省增补药物标志2^药品本位码^进药依据
/// Output:		
/// Return：药学项rowid^医嘱项rowid^库存项rowid
/// 
/// -61，代码不能为空
/// -62,名称不能为空
/// -63,剂型不能为空
/// -64,单位不能为空
/// -65,用法不能为空
/// -51,保存药学项主表失败
/// -52,插入药学项子表失败
/// -66,无效的药学子分类
/// -67,无效的药学小分类
/// -68,无效的管制分类
/// -69,无效的产地
/// -70 ;无效的通用名
/// -71 ;无效的剂型
/// -72 ;无效的频次
/// -73 ;无效的用法
/// -74 ;无效的疗程
/// -75 ;无效的基本单位
/// -76			;药学项代码已经存在，不能重复
/// -77			;药学项名称已经存在，不能重复
/// /// -20,医嘱项代码不能为空
/// -21，医嘱项名称不能为空
/// -22,计价单位不能为空
/// -23,费用大类不能为空
/// -24,费用子类不能为空
/// -25,医嘱子类不能为空
/// -26,药学项id不能为空
/// -27;无效的医嘱子分类
/// -28;无效的费用大类				
/// -29;无效的费用子类
/// -30;无效的药学项
/// -31;无效的计价单位
/// -32;医嘱项代码已经存在，不能重复
/// -32;医嘱项名称已经存在，不能重复
/// -81   ;插入医嘱项主表失败
/// -82   ;插入医嘱项附加表失败
/// -83	  ;插入医嘱项别名失败
/// /// -16:失败,医嘱项Id不能为空
/// -11:失败,库存项代码不能为空
/// -12:失败,库存项名称不能为空
/// -13:失败,基本单位不能为空
/// -14:失败,入库单位不能为空
/// -15:失败,库存分类不能为空
/// -17:失败,转移方式不能为空
/// -18:失败,是否要求批次不能为空
/// -19:失败,是否要求效期不能为空
/// -91：插入库存项失败
/// -92：插入库存项附加表失败
/// -93：插入库存项别名失败
/// -94：保存价格失败
/// /// -1   ;无效的库存分类
/// -3	 ;无效的医嘱项
/// -4	 ;无效的基本单位
/// -5	 ;无效的入库单位
/// -6	 ;库存项代码已经存在，不能重复
/// -7	 ;库存项名称已经存在，不能重复
/// -8	 ;基本单位和入库单位之间不存在转换关系
/// w ##class(web.DHCST.DrugInfoMaintain).SaveData("","","","","")
ClassMethod SaveData(Rowid As %String, listPhcData, listArcData, listIncData, StrParam) As %Library.String
{
	n (Rowid,listPhcData,listArcData,listIncData,StrParam,%session)
	s IncRowid=Rowid
	s ArcRowid=""
	s PhcdfRowid=""
	s:IncRowid'="" ArcRowid=$p(^INCI(IncRowid,1),"^",3)
	s Sub=+ArcRowid
	s Ver=$p(ArcRowid,"||",2)	
	s:(Sub'="")&(Ver'="") PhcdfRowid=$p(^ARCIM(Sub,Ver,1),"^",12)
	s ResultString=""
	s user=$p(StrParam,"^",3)
 	s AppName=##class(web.DHCST.DrugInfoMaintain).%GetParameter("AppName")
	s NeedAudit=##class(web.DHCST.Common.AppCommon).GetAppPropValue(AppName,"NeedAudit",StrParam) //药品是否需要审核,yunhaibao20151216
	//s IsNew="" /*每次修改是否需要判断为新增药品,可根据情况放开*/
	//i (NeedAudit="1")||(NeedAudit="2") s IsNew=..IsInciNewAdd(IncRowid)
	//q:IsNew="Y" -1006
	tstart
 	s $ZT="Error^DHCSTERROR"						
  	;保存至dhc_log以及业务审核记录表DHCWORKAUDIT,yunhaibao20151215
 	s Ret=0
 	i (NeedAudit="1")||(NeedAudit="2") d //新增修改需要审核
 	.s LogMain=##class(web.DHCST.DrugInfoAudit).InsLogMain(user)  //插入dhc_log主表
	.i +LogMain<=0 s Ret=-1001 trollback
 	.q:+Ret<0 
 	.i NeedAudit="2" d  
 	..s Ret=##class(web.DHCST.DrugInfoAudit).SaveToDHCLog(LogMain,PhcdfRowid,ArcRowid,IncRowid,StrParam,listPhcData,listArcData,listIncData)  //修改前
 	i +Ret<0  trollback
 	q:+Ret<0 Ret 	
 	;保存药学项
 	s Ret=##class(web.DHCST.PHCDRGMAST).Save(PhcdfRowid,listPhcData)
 	i +Ret<=0  trollback
 	q:+Ret<=0 Ret
 	s PhcdfId=Ret
 	;保存医嘱项
 	i listArcData'=""  d
 	.s listArcData=PhcdfId_"^"_listArcData
 	s Ret=##class(web.DHCST.ARCITMMAST).Save(ArcRowid,listArcData)
 	i +Ret<=0  trollback
 	q:+Ret<=0 Ret
 	s ArcimId=Ret
 	;保存库存项
 	i listIncData'=""  d
 	.s listIncData=ArcimId_"^"_listIncData
 	s Ret=##class(web.DHCST.INCITM).Save(IncRowid,listIncData)
 	i +Ret<=0  trollback
 	q:+Ret<=0 Ret
 	s InciId=Ret
  	i ((NeedAudit="1")&&(PhcdfRowid=""))||(NeedAudit="2") d  
 	.s Ret=##class(web.DHCST.DrugInfoAudit).SaveToDHCLog(LogMain,PhcdfRowid_"^"_PhcdfId,ArcRowid_"^"_ArcimId,IncRowid_"^"_InciId,StrParam,listPhcData,listArcData,listIncData)  //修改后
 	.s $p(^INCI(InciId,2),"^",9)="Y"  //药品信息设为需要审核时,每次保存置不可用,审核后根据状态置可用
 	i +Ret<0  trollback
 	q:+Ret<0 Ret 
 	tcommit
 	q PhcdfId_"^"_ArcimId_"^"_InciId
}

/// Descript:	查询三大项明细信息
/// Creater:	ZhangDongmei
/// CreateDate:	2012-01-10
/// Table:
/// Input:库存项id
/// Output:库存项：医嘱项rowid^代码^描述^基本单位id^基本单位^入库单位id^入库单位^库存分类id^库存分类^
/// 转移方式^是否要求批次^是否要求效期^别名^不可用标志^协和码^条码^更新人id^更新人^售价^进价^
/// 进口标志^质量层次^处方药分类^基本药物标志^中国药典标志^临床验证用药标志
/// ^处方购药标志^质量编号^国/省别^批准文号^高值类标志^院长签字^定价类型id^定价类型^最高售价^存储条件
/// ^本院药品目录^招标标志^招标进价^招标级别^招标供应商id^招标生产商id^招标配送商id^招标名称^
/// ^阳光采购标志^效期长度^物价文件号^物价文件备案时间^皮试标志^帐簿分类id^帐簿分类^用药说明^基本药物标志2
/// ^省增补药物标志1^省增补药物标志2^药品本位码^进药依据^规格
/// 
/// 医嘱项：药学项子表id^代码^描述^计价单位id^医嘱子类id^医嘱子类^费用大类^费用子类id^
/// 费用子类^独立医嘱标志^默认医嘱优先级id^默认医嘱优先级^无库存医嘱标志^医保名称^缩写
/// ^最大量^限制使用天数^每天最大剂量^单次最大剂量^急诊用药^住院用药^门诊用药
/// ^体检用药^医嘱提示^生效日期^截止日期^医嘱大类描述^医嘱大类id
/// 
/// 药学项：代码^描述^剂型id^剂型^基本单位id^基本单位^用法id^用法^疗程id^疗程^基本数量^产地id^产地
/// ^管制分类id^管制分类^频次id^频次^医保类别^处方通用名id^处方通用名^药学分类id^药学分类^药学子类id^药学子类^
/// 药学小类id^药学小类^英文国际非专利药名
/// ^国际专利药名^商品名^制剂通用名^原料通用名^住院按一天量计算^门诊按一天量计算^门诊皮试用原液
/// ^住院皮试用原液^DDD值
/// Return：
/// others:w ##class(web.DHCST.DrugInfoMaintain).GetDetail(858)
ClassMethod GetDetail(InciId, HospitalRowid = "") As %Library.String
{
	n (InciId,HospitalRowid)
	q:InciId="" "" 
	q:'$d(^INCI(InciId)) ""
	s $ZT="Error^DHCSTERROR"						;增加错误处理
	s IncData=##class(web.DHCST.INCITM).Select(InciId,HospitalRowid)
	i IncData=""  d
	.s IncData=$$CreateEmptyStr(74)
	s ArcimId=$p(IncData,"^",1)
	s ArcData=##class(web.DHCST.ARCITMMAST).Select(ArcimId)
	i ArcData=""  d
	.s ArcData=$$CreateEmptyStr(46)
	s PhcdfId=$p(ArcData,"^",1)
	s PhcData=##class(web.DHCST.PHCDRGMAST).Select(PhcdfId)
	i PhcData=""  d
	.s PhcData=$$CreateEmptyStr(55)
	.
	s xdelim=##class(web.DHCST.Common.UtilCommon).RowDataDelim()
	s Data=IncData_xdelim_ArcData_xdelim_PhcData
	//s Data=##class(ext.util.String).EvalJSON(Data)
	q Data

CreateEmptyStr(Num)
 s EmptyStr=""
 s Num=Num-1
 f i=1:1:Num  d
 .s EmptyStr=EmptyStr_"^"_""
 .
 q EmptyStr
}

/// Descript:	删除三大项信息
/// Creater:	ZhangDongmei
/// CreateDate:	2011-12-28
/// Table:PHC_DrgMast,PHC_DrgForm
/// Arc_ItmMast,Inc_Itm,DHC_ItmAddionInfo
/// Input:库存项rowid
/// Output:		
/// Return：0：成功;错误代码
/// -2 	;删除库存项失败
/// -3 	;删除库存项附加信息失败
/// -4  ;删除库存项别名失败
/// -5  ;删除调价记录失败
/// -81   ;删除医嘱项主表失败
/// -82   ;删除医嘱项附加表失败
/// -83  ;删除医嘱项别名失败
/// -51   ;删除药学项失败
ClassMethod Delete(InciRowid) As %Library.String
{
	n (InciRowid,%session)
	q:InciRowid="" -1
	q:'$d(^INCI(InciRowid)) -1
	s UseFlag=##class(web.DHCST.INCITM).CheckUsed(InciRowid)	
	q:UseFlag=1 -11  ;药品已在使用，不能删除
	s Err=0
	s ArcimRowid=$p(^INCI(InciRowid,1),"^",3)
	s PhcdfRowid=""
	i ArcimRowid'=""  d
 	.s Sub=+ArcimRowid
 	.s Ver=$p(ArcimRowid,"||",2)
 	.s PhcdfRowid=$p(^ARCIM(Sub,Ver,1),"^",12)
 	.
	;
	tstart
 	s $ZT="Error^DHCSTERROR"						;增加错误处理
 	;删除库存项
 	s Ret=##class(web.DHCST.INCITM).Delete(InciRowid)
 	i Ret'=0  trollback
 	q:Ret'=0 Ret
	;
	;删除医嘱项 	
 	s Ret=##class(web.DHCST.ARCITMMAST).Delete(ArcimRowid)
 	i Ret'=0  trollback
 	q:Ret'=0 Ret
	;
 	;删除药学项
 	s Ret=##class(web.DHCST.PHCDRGMAST).Delete(PhcdfRowid)
  	i Ret'=0  trollback
 	q:Ret'=0 Ret
 	tcommit
 	q 0
}

/// Descript:取三大项界面参数配置属性
/// Creater:	ZhangDongmei
/// CreateDate:	2012-09-13
/// Table:
/// Input:
/// Output:		
/// Return：允许录入进价^允许录入售价^三大项代码需一致^三大项名称需一致^不可用状态^批文信息录入方式修改
/// w ##class(web.DHCST.DrugInfoMaintain).GetParamProp("142^102^590^2")
ClassMethod GetParamProp(StrParam = "") As %Library.String
{
	s AppName=##class(web.DHCST.DrugInfoMaintain).%GetParameter("AppName")
	s AllowInputRp=##class(web.DHCST.Common.AppCommon).GetAppPropValue(AppName,"AllowInputRp",StrParam)
	s AllowInputSp=##class(web.DHCST.Common.AppCommon).GetAppPropValue(AppName,"AllowInputSp",StrParam)
	s SameCode=##class(web.DHCST.Common.AppCommon).GetAppPropValue(AppName,"SameCode",StrParam)
	s SameDesc=##class(web.DHCST.Common.AppCommon).GetAppPropValue(AppName,"SameDesc",StrParam)
	s InitStatusNotUse=##class(web.DHCST.Common.AppCommon).GetAppPropValue(AppName,"SetInitStatusNotUse",StrParam)
	s ModDocInfoWayByInterface=##class(web.DHCST.Common.AppCommon).GetAppPropValue(AppName,"ModDocInfoWayByInterface",StrParam)
	s NeedAudit=##class(web.DHCST.Common.AppCommon).GetAppPropValue(AppName,"NeedAudit",StrParam) //药品是否需要审核,yunhaibao20151216
	s Data=AllowInputRp_"^"_AllowInputSp_"^"_SameCode_"^"_SameDesc_"^"_InitStatusNotUse_"^"_ModDocInfoWayByInterface_"^"_NeedAudit
	q Data
}

ClassMethod NewPid() As %String
{
  q $I(^DHCSTPID("DrugInfo"))
}

/// 看某个品种的类组是否包含在列表中
/// Author:zhwh
/// Date:2013-07-15
/// Arguments:
///  inci  -库存项rowid
///  CatGrpStr - 类组rowid串("^"分隔)
/// Return:
///  1 - 包含
///  0 - 不包含
ClassMethod IsInCatGrpStr(inci As %String, CatGrpStr As %String) As %String
{
 n (inci,CatGrpStr)
 q:inci="" 0
 q:CatGrpStr="" 0
 s incsc=$p($G(^INCI(inci,2)),"^",2)
 q:incsc="" 0
 s catgrp=$o(^DHCSCG("STKCAT",incsc,""))
 i ("^"_CatGrpStr_"^")[("^"_catgrp_"^") q 1
 q 0
}

/// W ##class(web.DHCST.DrugInfoMaintain).GetBatInfo("533","102","0","15")
ClassMethod GetBatInfo(Inci As %String, LocID As %String, Start As %String, Limit As %String) As %String
{
	n (Inci,LocID,Start,Limit)
	q:LocID="" ""
	q:Inci="" ""
	s end = Start+Limit
	 s count = 0
    s resultString = ""
    s json = ##class(Code.JsonObj).%New()
    s StkDate=+$h
    s Chl=$o(^INCI("IL_LOC",LocID,Inci,0))
    q:Chl="" ""
	s Incil=Inci_"||"_Chl
	s InciCode = $p(^INCI(Inci,1),"^",1)
	s InciDesc = $p(^INCI(Inci,1),"^",2)
	s IncsbDesc =##class(web.DHCST.Common.DrugStkCommon).GetStkBin(LocID,Inci)
	s IncsbDesc=$p(IncsbDesc,"^",1)
	s BUomId=$p(^INCI(Inci,1),"^",10)
	s PurUomId=$p(^INCI(Inci,3),"^",6)
	s Spec=##class(web.DHCST.Common.DrugInfoCommon).GetSpec("",Inci)
	s Chlb=0  f  s Chlb=$o(^INCI(Inci,"IL",Chl,"LB",Chlb)) q:Chlb=""  d 
	.s Inclb=Inci_"||"_Chl_"||"_Chlb
	.s StockQty=##class(web.DHCST.Common.DrugStkCommon).QtyINCLBU(Inclb,StkDate,BUomId)
	.s Fac=##class(web.DHCST.Common.UtilCommon).UOMFac(PurUomId,BUomId)
	.s PurStockQty = StockQty / Fac
	.s INCIB=$p(^INCI(Inci,"IL",Chl,"LB",Chlb),"^",1)
	.s Btno=$p(^INCI(Inci,"IB",$p(INCIB,"||",2)),"^",1)
	.s Expdate=$p(^INCI(Inci,"IB",$p(INCIB,"||",2)),"^",2)
	.i Expdate'="" s Expdate=$zd(Expdate,3)
	.s active=""
	.s dhcinclb=$o(^DHCINCLB(0,"LB",Inclb,""))
	.s:dhcinclb'="" active=$p(^DHCINCLB(dhcinclb),"^",2)
	.i active="N" s NotuseFlag="Y"
	.e  s NotuseFlag="N"
	.s Data1=Inclb_"^"_Inci_"^"_InciCode_"^"_InciDesc_"^"_StockQty
	.s Data2=IncsbDesc_"^"_Btno_"^"_$g(Expdate)_"^"_PurStockQty_"^"_Spec_"^"_NotuseFlag
	.s Data=Data1_"^"_Data2
	.s count = count+1
	.i (count>Start)&(count<=end) d
	..d json.InsertRowData(Data)
	s Title="Inclb^Inci^InciCode^InciDesc^StockQty^StkBin^Btno^Expdate^PurStockQty^Spec^NotUseFlag"
	if count>0 d
    .s resultString = json.getJsonData(Title,count)
    k json
    q resultString
}

ClassMethod SaveBatInfo(Inclb As %String, NotUseFlag As %String, LockUserId As %String = "", StkNotUseFlag = "") As %String
{
	n (Inclb,NotUseFlag,LockUserId,StkNotUseFlag)
	s LockDate=+$h,LockTime=$p($h,",",2)
	i NotUseFlag="Y" s active="N"
    e  s active="Y"
	i StkNotUseFlag="Y" s stkActive="N"
	e  s stkActive="Y"
    s:(active="Y")&&(stkActive="Y") (LockUserId,LockDate,LockTime)=""	//可用状态下需要置为空！
	s dhcinclb=$o(^DHCINCLB(0,"LB",Inclb,""))
	i dhcinclb=""  d //yunhaibao,当批次附加信息不存在时插入,针对老项目
	.&sql(insert into DHC_IncItmLcBt(INCLB_LB_DR,INCLB_Active,INCLB_LockUser_Dr,INCLB_LockDate,INCLB_LockTime,INCLB_STKActive) 
	values (:Inclb,:active,:LockUserId,:LockDate,:LockTime,:stkActive))
	s dhcinclb=$o(^DHCINCLB(0,"LB",Inclb,""))
    q:dhcinclb="" -1
    s Err=0
    &sql(
    	update dhc_incitmlcbt 
    	set INCLB_Active=:active, INCLB_LockUser_Dr=:LockUserId,
    	INCLB_LockDate=:LockDate,INCLB_LockTime=:LockTime,
    	INCLB_STKActive=:stkActive 
    	where INCLB_RowId=:dhcinclb
    )
    i SQLCODE'=0  d
    .s Err=-1
    q Err
}

/// creator:yunhaibao
/// createdate:2015-10-10
/// description:根据代码模糊检索药品信息数据(目前用于药品信息查询)
/// w ##class(web.DHCST.DrugInfoMaintain).GetItmStartWithCode("H10","N","1")
ClassMethod GetItmStartWithCode(InciLikeCode, AllFlag, CatGrpStr = "", Others = "", Sort = "", HospID = "") As %Library.String
{

	n (InciLikeCode,AllFlag,CatGrpStr,Others,Sort,HospID)
	q:InciLikeCode="" ""
	s StkGrpId=$p(Others,"^",4)
	s InciUseCondition=$p(Others,"^",6) //药品状态
	s InciStartDate=$p(Others,"^",7) //状态为医嘱截止,做截止日期用,状态为新增做新增日期(IncItm:Updatedate)
	s InciEndDate=$p(Others,"^",8) 
	i InciStartDate'="" s InciStartDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(InciStartDate)
	i InciEndDate'="" s InciEndDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(InciEndDate)
	s InciLikeCode=$$ALPHAUP^SSUTIL4(InciLikeCode)_"%"
	s pid=..NewPid()
	k ^TMPITMINFO(pid)  
	s num=0
	&sql( declare xxx1 cursor for select inci_rowid From inc_itm 
	where %ALPHAUP(inci_code) like :InciLikeCode)
 	&sql(open xxx1)
 	f  &sql(fetch xxx1 into :InciId) q:SQLCODE  d
 	.q:'$d(^INCI(InciId,1))
	.q:'..IsInCatGrpStr(+InciId,$G(CatGrpStr))  //类组权限过滤
	.s InciDesc=$p(^INCI(InciId,1),"^",2)
	.s Code=$p(^INCI(InciId,1),"^",1)
	.s PurUomId=$p(^INCI(InciId,3),"^",6)
	.s BUomId=$p(^INCI(InciId,1),"^",10)
	.s:PurUomId'="" PurUomDesc=$p(^CT("UOM",PurUomId),"^",2)
	.s:BUomId'="" BUomDesc=$p(^CT("UOM",BUomId),"^",2)
	.s OutUomId=$p(^INCI(InciId,1),"^",12)
	.s InUomId=$p(^INCI(InciId,1),"^",13)
	.s:OutUomId'="" OutUomDesc=$p($g(^CT("UOM",OutUomId)),"^",2)
	.s:InUomId'="" InUomDesc=$p($g(^CT("UOM",InUomId)),"^",2)
	.s Sp=##Class(web.DHCSTPRICE).GetFormatSp(InciId,+$h,PurUomId,HospID,"")	//zhouyg 20141204
	.s StkCatDr=$p(^INCI(InciId,2),"^",2)
	.s:StkCatDr'="" StkCatDesc=$p(^INC("SC",StkCatDr),"^",2)
	.s NotUseFlag=$p(^INCI(InciId,2),"^",9)
	.q:(AllFlag'="Y")&(NotUseFlag="Y")			;不显示不可用项目
	.s TmpGrpInfo=##class(web.DHCST.Common.DrugInfoCommon).GetIncStkCatGrp(InciId)
	.s TmpGrpType=$p(TmpGrpInfo,"^",3)
	.q:TmpGrpType'=..sssCode()
	.s TmpGrpId=$p(TmpGrpInfo,"^",5)
	.q:(StkGrpId'="")&(TmpGrpId'=StkGrpId)
	.s StkGrpDesc=$p(TmpGrpInfo,"^",2)
	.s ArcId=$p(^INCI(InciId,1),"^",3)
	.s InciUpdateDate=$p(^INCI(InciId,3),"^",1) ;新增日期用
	.s ArcStopDate=##class(web.DHCST.Common.DrugInfoCommon).GetArcItmStopDate(ArcId)  //医嘱截止日期
	.s ArcStopDate=+$p(ArcStopDate,"^",1)
	.i $d(^DHCINTR(0,"INCI",InciId)) s HavedUse="Y"
	.e  s HavedUse=""
	.q:(InciUseCondition="OnlyUse")&&(NotUseFlag="Y")  //在用,yunhaibao20151216,药品状态过滤
	.q:(InciUseCondition="OnlyNotUse")&&(NotUseFlag'="Y")   //不可用
	.q:(InciUseCondition="ArcStop")&&(ArcStopDate="0")  //医嘱截止
	.q:(InciUseCondition="ArcStop")&&(((InciStartDate'="")&&(ArcStopDate<InciStartDate))||((InciEndDate'="")&&(ArcStopDate>InciEndDate)))  
	.q:(InciUseCondition="ArcStop")&&(InciStartDate="")&&(InciEndDate="")&&(ArcStopDate="0")
	.q:(InciUseCondition="NewAdd")&&(InciUpdateDate="") //新增
	.q:(InciUseCondition="NewAdd")&&(((InciStartDate'="")&&(InciUpdateDate<InciStartDate))||((InciEndDate'="")&&(InciUpdateDate>InciEndDate)))  
	.q:(InciUseCondition="NewAdd")&&(InciStartDate="")&&(InciEndDate="")&&(HavedUse'="")  //日期范围为空时,未发生业务
	.s spec=""
	.s InfoId=$o(^DHCITMINFO(0,"INCI",InciId,0))
	.i InfoId'=""  d
	..s spec=$p(^DHCITMINFO(InfoId),"^",27)
	.s PHCDF=##class(web.DHCST.Common.DrugInfoCommon).GetPhcdf(InciId)
	.s (PhcCatDesc,PhcSubCatDesc,PhcMinCatDesc)=""
	.;8.0以前药学三级分类
	.;s PhcCatInfo=##class(web.DHCST.Common.DrugInfoCommon).GetPhcCat(InciId)
	.;s PhcCatDesc=$p(PhcCatInfo,"^",1)
	.;s PhcSubCatInfo=##class(web.DHCST.Common.DrugInfoCommon).GetPhcSubCat(InciId)
	.;s PhcSubCatDesc=$p(PhcSubCatInfo,"^",1)
	.;s PhcMinCatInfo=##class(web.DHCST.Common.DrugInfoCommon).GetPhcMinCat(InciId)
	.;s PhcMinCatDesc=$p(PhcMinCatInfo,"^",1)
	.//wyx 2015-04-22 增加药学多级分类过滤
	.s PhaCatAllDesc=""
	.s PhaCatAllstr=##class(web.DHCST.Common.DrugInfoCommon).GetPhaCatAll(InciId)
	.s PhaCatAlls=$p(PhaCatAllstr,"^",1)
	.s PhaCatAllDesc=$p(PhaCatAllstr,"^",2)
	.
	.s LabelName=##class(web.DHCST.Common.DrugInfoCommon).GetGoodNameByPhcd(+PHCDF)
	.s GenericName=##class(web.DHCST.Common.DrugInfoCommon).GetGeneByPhcd(+PHCDF)
	.s GenericName=$p(GenericName,"^",2)
	.s FormDesc=##class(web.DHCST.Common.DrugInfoCommon).GetFormByPhcdf(PHCDF)
	.s FormDesc=$p(FormDesc,"^",2)
	.s Manf=##class(web.DHCST.Common.DrugInfoCommon).GetManf(InciId)
	.s Manf=$p(Manf,"^",3)
	.s BillUom=##class(web.DHCST.Common.DrugInfoCommon).GetArcBuom(ArcId)
	.s BillUomDesc=$p(BillUom,"^",2)	
	.s ArcItemCat=##class(web.DHCST.Common.DrugInfoCommon).GetArcItemCat(InciId)   //医嘱子类
	.s ArcItemCat=$p(ArcItemCat,"^",2)
	.s OrderCat=##class(web.DHCST.Common.DrugInfoCommon).GetOrderCategoryByArcim(ArcId)   //医嘱大类
	.s OrderCat=$p(OrderCat,"^",2)
	.s Rp=##Class(web.DHCSTPRICE).GetFormatRp(InciId,+$h,PurUomId,HospID,"")	//进价
	.s InstrStr=##class(web.DHCST.Common.DrugInfoCommon).GetPhcInstrByPhcdf(PHCDF)  //用法
	.s InstrDesc=$p(InstrStr,"^",2)
	.s FreqStr=##class(web.DHCST.Common.DrugInfoCommon).GetPhcFreqByPhcdf(PHCDF)  //频次
	.s FreqDesc=$p(FreqStr,"^",2)
	.s PoisonStr=##class(web.DHCST.Common.DrugInfoCommon).GetPhcPoisonByPhcd(+PHCDF)  //管制分类
	.s PoisonDesc=$p(PoisonStr,"^",2)
	.s ItmRemark=##class(web.DHCST.Common.DrugInfoCommon).GetInciRemark(InciId)  //批准文号
	.s MaxSp=##class(web.DHCST.Common.DrugInfoCommon).GetMaxSp(InciId)  //最高售价
	.s CountryBasicFlag=##class(web.DHCST.Common.DrugInfoCommon).GetCountryBasicFlag(InciId)  //国家基本药物
	.s ProvinceBasicFlag=##class(web.DHCST.Common.DrugInfoCommon).GetProvinceBasicFlag(InciId) //省基本药物
	.s AntiFlag=##class(web.DHCST.Common.DrugInfoCommon).GetAntiFlagByPhcdf(PHCDF)  //抗菌药标志
	.s InHosFlag=##class(web.DHCST.Common.DrugInfoCommon).GetInHosFlag(InciId)  //本院药品目录
	.s ImportFlag=##class(web.DHCST.Common.DrugInfoCommon).GetImportFlag(InciId)  //进口标志
	.s CodexFlag=##class(web.DHCST.Common.DrugInfoCommon).GetCodexFlag(InciId)  //中国药典标志
	.s DrugUseInfo=##class(web.DHCST.Common.DrugInfoCommon).GetDrugUseInfo(InciId)  //用药说明
	.s num=num+1
	.s Index=InciId
	.i Sort="InciRowid" s Index=InciId
	.e  i Sort="InciCode" s Index=Code
	.e  i Sort="InciDesc" s Index=InciDesc
	.e  i Sort="Spec" s Index=$g(spec)
	.e  i Sort="Manf"  s Index=Manf
	.e  i Sort="PurUom"  s Index=PurUomDesc
	.e  i Sort="Sp"  s Index=Sp
	.e  i Sort="Rp"  s Index=Rp
	.e  i Sort="BUom"  s Index=BUomDesc
	.e  i Sort="BillUom"  s Index=BillUomDesc 
	.e  i Sort="Form"  s Index=FormDesc 
	.e  i Sort="GoodName"  s Index=LabelName 
	.e  i Sort="GenericName"  s Index=GenericName 
	.e  i Sort="StkCat"  s Index=StkCatDesc 
	.e  i Sort="ArcItemCat"  s Index=ArcItemCat 
	.e  i Sort="OrderCat"  s Index=OrderCat
	.e  i Sort="InstrDesc"  s Index=InstrDesc
	.e  i Sort="GenericName"  s Index=GenericName
	.e  i Sort="AntiFlag"  s Index=AntiFlag
	.e  i Sort="InHosFlag"  s Index=InHosFlag
	.e  i Sort="ImportFlag"  s Index=ImportFlag
	.e  i Sort="CodexFlag"  s Index=CodexFlag
	.e  i Sort="FreqDesc"  s Index=FreqDesc
	.e  i Sort="PoisonDesc"  s Index=PoisonDesc
	.e  i Sort="CountryBasicFlag"  s Index=CountryBasicFlag
	.e  i Sort="ProvinceBasicFlag"  s Index=ProvinceBasicFlag
	.e  i Sort="NotUseFlag"  s Index=NotUseFlag 
	.e  s Index=InciId
	.i Index="" s Index="1"
	.s data1=InciId_"^"_Code_"^"_InciDesc_"^"_$g(spec)_"^"_$g(Manf)_"^"_$g(PurUomDesc)_"^"_Sp
	.s data2=$g(BUomDesc)_"^"_$g(BillUomDesc)_"^"_$g(FormDesc)_"^"_$g(LabelName)_"^"_$g(GenericName)_"^"_$g(StkCatDesc)
	.s data3=$g(PhcCatDesc)_"^"_$g(PhcSubCatDesc)_"^"_$g(PhcMinCatDesc)_"^"_$g(NotUseFlag)_"^"_PhaCatAllDesc
	.s data4=ArcItemCat_"^"_OrderCat_"^"_Rp_"^"_InstrDesc_"^"_FreqDesc_"^"_PoisonDesc_"^"_ItmRemark_"^"_MaxSp_"^"_CountryBasicFlag_"^"_ProvinceBasicFlag
	.s data5=AntiFlag_"^"_InHosFlag_"^"_ImportFlag_"^"_CodexFlag_"^"_DrugUseInfo_"^"_StkGrpDesc_"^"_OutUomDesc_"^"_InUomDesc
	.;按rowid排序,分页用
	.s ^TMPITMINFO(pid,"ITM",Index,num)=data1_"^"_data2_"^"_data3_"^"_data4_"^"_data5   
 	q pid_"^"_num
}

/// creator:yunhaibao
/// createdate:2015-10-10
/// description:根据药品名称模糊检索药品信息数据(目前用于药品信息查询)
/// w ##class(web.DHCST.DrugInfoMaintain).GetItmStartWithDesc("葡萄","N","^^^1^")
ClassMethod GetItmStartWithDesc(InciLikeDesc, AllFlag, CatGrpStr = "", Others = "", Sort = "", HospID = "") As %Library.String
{

	n (InciLikeDesc,AllFlag,CatGrpStr,Others,Sort,HospID)
	q:InciLikeDesc="" ""
	s StkGrpId=$p(Others,"^",4)
	s InciUseCondition=$p(Others,"^",6) //药品状态
	s InciStartDate=$p(Others,"^",7) //状态为医嘱截止,做截止日期用,状态为新增做新增日期(IncItm:Updatedate)
	s InciEndDate=$p(Others,"^",8) 
	i InciStartDate'="" s InciStartDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(InciStartDate)
	i InciEndDate'="" s InciEndDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(InciEndDate)
	s InciLikeDesc=$$ALPHAUP^SSUTIL4(InciLikeDesc)_"%"
	s pid=..NewPid()
	k ^TMPITMINFO(pid)  
	s num=0
	&sql( declare xxxx1 cursor for select inci_rowid From inc_itm 
	where %ALPHAUP(inci_desc) like :InciLikeDesc)
 	&sql(open xxxx1)
 	f  &sql(fetch xxxx1 into :InciId) q:SQLCODE  d
 	.q:'$d(^INCI(InciId,1))
	.q:'..IsInCatGrpStr(+InciId,$G(CatGrpStr))  //类组权限过滤
	.s InciDesc=$p(^INCI(InciId,1),"^",2)
	.s Code=$p(^INCI(InciId,1),"^",1)
	.s PurUomId=$p(^INCI(InciId,3),"^",6)
	.s BUomId=$p(^INCI(InciId,1),"^",10)
	.s:PurUomId'="" PurUomDesc=$p(^CT("UOM",PurUomId),"^",2)
	.s:BUomId'="" BUomDesc=$p(^CT("UOM",BUomId),"^",2)
	.s OutUomId=$p(^INCI(InciId,1),"^",12)
	.s InUomId=$p(^INCI(InciId,1),"^",13)
	.s:OutUomId'="" OutUomDesc=$p($g(^CT("UOM",OutUomId)),"^",2)
	.s:InUomId'="" InUomDesc=$p($g(^CT("UOM",InUomId)),"^",2)
	.s Sp=##Class(web.DHCSTPRICE).GetFormatSp(InciId,+$h,PurUomId,HospID,"")	//zhouyg 20141204
	.s StkCatDr=$p(^INCI(InciId,2),"^",2)
	.s:StkCatDr'="" StkCatDesc=$p(^INC("SC",StkCatDr),"^",2)
	.s NotUseFlag=$p(^INCI(InciId,2),"^",9)
	.q:(AllFlag'="Y")&(NotUseFlag="Y")			;不显示不可用项目
	.s TmpGrpInfo=##class(web.DHCST.Common.DrugInfoCommon).GetIncStkCatGrp(InciId)
	.s TmpGrpType=$p(TmpGrpInfo,"^",3)
	.q:TmpGrpType'=..sssCode()
	.s TmpGrpId=$p(TmpGrpInfo,"^",5)
	.q:(StkGrpId'="")&(TmpGrpId'=StkGrpId)
	.s StkGrpDesc=$p(TmpGrpInfo,"^",2)
	.s ArcId=$p(^INCI(InciId,1),"^",3)
	.s InciUpdateDate=$p(^INCI(InciId,3),"^",1) ;新增日期用
	.s ArcStopDate=##class(web.DHCST.Common.DrugInfoCommon).GetArcItmStopDate(ArcId)  //医嘱截止日期
	.s ArcStopDate=+$p(ArcStopDate,"^",1)
	.i $d(^DHCINTR(0,"INCI",InciId)) s HavedUse="Y"
	.e  s HavedUse=""
	.q:(InciUseCondition="OnlyUse")&&(NotUseFlag="Y")  //在用,yunhaibao20151216,药品状态过滤
	.q:(InciUseCondition="OnlyNotUse")&&(NotUseFlag'="Y")   //不可用
	.q:(InciUseCondition="ArcStop")&&(ArcStopDate="0")  //医嘱截止
	.q:(InciUseCondition="ArcStop")&&(((InciStartDate'="")&&(ArcStopDate<InciStartDate))||((InciEndDate'="")&&(ArcStopDate>InciEndDate)))  
	.q:(InciUseCondition="ArcStop")&&(InciStartDate="")&&(InciEndDate="")&&(ArcStopDate="0")
	.q:(InciUseCondition="NewAdd")&&(InciUpdateDate="") //新增
	.q:(InciUseCondition="NewAdd")&&(((InciStartDate'="")&&(InciUpdateDate<InciStartDate))||((InciEndDate'="")&&(InciUpdateDate>InciEndDate)))  
	.q:(InciUseCondition="NewAdd")&&(InciStartDate="")&&(InciEndDate="")&&(HavedUse'="")  //日期范围为空时,未发生业务
	.s spec=""
	.s InfoId=$o(^DHCITMINFO(0,"INCI",InciId,0))
	.i InfoId'=""  d
	..s spec=$p(^DHCITMINFO(InfoId),"^",27)
	.s PHCDF=##class(web.DHCST.Common.DrugInfoCommon).GetPhcdf(InciId)
	.s (PhcCatDesc,PhcSubCatDesc,PhcMinCatDesc)=""
	.;s PhcCatInfo=##class(web.DHCST.Common.DrugInfoCommon).GetPhcCat(InciId)
	.;s PhcCatDesc=$p(PhcCatInfo,"^",1)
	.;s PhcSubCatInfo=##class(web.DHCST.Common.DrugInfoCommon).GetPhcSubCat(InciId)
	.;s PhcSubCatDesc=$p(PhcSubCatInfo,"^",1)
	.;s PhcMinCatInfo=##class(web.DHCST.Common.DrugInfoCommon).GetPhcMinCat(InciId)
	.;s PhcMinCatDesc=$p(PhcMinCatInfo,"^",1)
	.//wyx 2015-04-22 增加药学多级分类过滤
	.s PhaCatAllDesc=""
	.s PhaCatAllstr=##class(web.DHCST.Common.DrugInfoCommon).GetPhaCatAll(InciId)
	.s PhaCatAlls=$p(PhaCatAllstr,"^",1)
	.s PhaCatAllDesc=$p(PhaCatAllstr,"^",2)
	.
	.s LabelName=##class(web.DHCST.Common.DrugInfoCommon).GetGoodNameByPhcd(+PHCDF)
	.s GenericName=##class(web.DHCST.Common.DrugInfoCommon).GetGeneByPhcd(+PHCDF)
	.s GenericName=$p(GenericName,"^",2)
	.s FormDesc=##class(web.DHCST.Common.DrugInfoCommon).GetFormByPhcdf(PHCDF)
	.s FormDesc=$p(FormDesc,"^",2)
	.s Manf=##class(web.DHCST.Common.DrugInfoCommon).GetManf(InciId)
	.s Manf=$p(Manf,"^",3)
	.s BillUom=##class(web.DHCST.Common.DrugInfoCommon).GetArcBuom(ArcId)
	
	.s ArcItemCat=##class(web.DHCST.Common.DrugInfoCommon).GetArcItemCat(InciId)   //医嘱子类
	.s ArcItemCat=$p(ArcItemCat,"^",2)
	.s OrderCat=##class(web.DHCST.Common.DrugInfoCommon).GetOrderCategoryByArcim(ArcId)   //医嘱大类
	.s OrderCat=$p(OrderCat,"^",2)
	.s Rp=##Class(web.DHCSTPRICE).GetFormatRp(InciId,+$h,PurUomId,HospID,"")	//进价
	.s InstrStr=##class(web.DHCST.Common.DrugInfoCommon).GetPhcInstrByPhcdf(PHCDF)  //用法
	.s InstrDesc=$p(InstrStr,"^",2)
	.s FreqStr=##class(web.DHCST.Common.DrugInfoCommon).GetPhcFreqByPhcdf(PHCDF)  //频次
	.s FreqDesc=$p(FreqStr,"^",2)
	.s PoisonStr=##class(web.DHCST.Common.DrugInfoCommon).GetPhcPoisonByPhcd(+PHCDF)  //管制分类
	.s PoisonDesc=$p(PoisonStr,"^",2)
	.s ItmRemark=##class(web.DHCST.Common.DrugInfoCommon).GetInciRemark(InciId)  //批准文号
	.s MaxSp=##class(web.DHCST.Common.DrugInfoCommon).GetMaxSp(InciId)  //最高售价
	.s CountryBasicFlag=##class(web.DHCST.Common.DrugInfoCommon).GetCountryBasicFlag(InciId)  //国家基本药物
	.s ProvinceBasicFlag=##class(web.DHCST.Common.DrugInfoCommon).GetProvinceBasicFlag(InciId) //省基本药物
	.s AntiFlag=##class(web.DHCST.Common.DrugInfoCommon).GetAntiFlagByPhcdf(PHCDF)  //抗菌药标志
	.s InHosFlag=##class(web.DHCST.Common.DrugInfoCommon).GetInHosFlag(InciId)  //本院药品目录
	.s ImportFlag=##class(web.DHCST.Common.DrugInfoCommon).GetImportFlag(InciId)  //进口标志	
	.s CodexFlag=##class(web.DHCST.Common.DrugInfoCommon).GetCodexFlag(InciId)  //中国药典标志
	.s DrugUseInfo=##class(web.DHCST.Common.DrugInfoCommon).GetDrugUseInfo(InciId)  //用药说明
	.s num=num+1
	.s Index=InciId
	.i Sort="InciRowid" s Index=InciId
	.e  i Sort="InciCode" s Index=Code
	.e  i Sort="InciDesc" s Index=InciDesc
	.e  i Sort="Spec" s Index=$g(spec)
	.e  i Sort="Manf"  s Index=Manf
	.e  i Sort="PurUom"  s Index=PurUomDesc
	.e  i Sort="Sp"  s Index=Sp
	.e  i Sort="Rp"  s Index=Rp
	.e  i Sort="BUom"  s Index=BUomDesc
	.e  i Sort="BillUom"  s Index=BillUomDesc 
	.e  i Sort="Form"  s Index=FormDesc 
	.e  i Sort="GoodName"  s Index=LabelName 
	.e  i Sort="GenericName"  s Index=GenericName 
	.e  i Sort="StkCat"  s Index=StkCatDesc 
	.e  i Sort="ArcItemCat"  s Index=ArcItemCat 
	.e  i Sort="OrderCat"  s Index=OrderCat
	.e  i Sort="InstrDesc"  s Index=InstrDesc
	.e  i Sort="GenericName"  s Index=GenericName
	.e  i Sort="AntiFlag"  s Index=AntiFlag
	.e  i Sort="InHosFlag"  s Index=InHosFlag
	.e  i Sort="ImportFlag"  s Index=ImportFlag
	.e  i Sort="CodexFlag"  s Index=CodexFlag
	.e  i Sort="FreqDesc"  s Index=FreqDesc
	.e  i Sort="PoisonDesc"  s Index=PoisonDesc
	.e  i Sort="CountryBasicFlag"  s Index=CountryBasicFlag
	.e  i Sort="ProvinceBasicFlag"  s Index=ProvinceBasicFlag
	.e  i Sort="NotUseFlag"  s Index=NotUseFlag 
	.e  s Index=InciId
	.i Index="" s Index="1"
	.s data1=InciId_"^"_Code_"^"_InciDesc_"^"_$g(spec)_"^"_$g(Manf)_"^"_$g(PurUomDesc)_"^"_Sp
	.s data2=$g(BUomDesc)_"^"_$g(BillUomDesc)_"^"_$g(FormDesc)_"^"_$g(LabelName)_"^"_$g(GenericName)_"^"_$g(StkCatDesc)
	.s data3=$g(PhcCatDesc)_"^"_$g(PhcSubCatDesc)_"^"_$g(PhcMinCatDesc)_"^"_$g(NotUseFlag)_"^"_PhaCatAllDesc
	.s data4=ArcItemCat_"^"_OrderCat_"^"_Rp_"^"_InstrDesc_"^"_FreqDesc_"^"_PoisonDesc_"^"_ItmRemark_"^"_MaxSp_"^"_CountryBasicFlag_"^"_ProvinceBasicFlag
	.s data5=AntiFlag_"^"_InHosFlag_"^"_ImportFlag_"^"_CodexFlag_"^"_DrugUseInfo_"^"_StkGrpDesc_"^"_OutUomDesc_"^"_InUomDesc
	.;按rowid排序,分页用
	.s ^TMPITMINFO(pid,"ITM",Index,num)=data1_"^"_data2_"^"_data3_"^"_data4_"^"_data5
	.   
 	q pid_"^"_num
}

/// creator:yunhaibao
/// createdate:20151215
/// decription:如果药品信息维护为需要审核,此处判断药品是否为新修改未审核
/// return:Y/N
/// w ##class(web.DHCST.DrugInfoMaintain).IsInciNewAdd("858")
ClassMethod IsInciNewAdd(IncRowid)
{
	N (IncRowid)
	s IsNewEdit=""
	q:IncRowid="" IsNewEdit
	q:'$d(^DHCLOG(0,"INCILOG",+IncRowid)) IsNewEdit
	s maxlev=$o(^DHCSTAL(0,"Level","Basic","G",""),-1) //最大审核级别 
	s dhclogm=$o(^DHCLOG(0,"INCILOG",+IncRowid,""),-1) //药学项log
	i dhclogm'="" d
	.q:'$d(^DHCLOG(0,"INCILOG",+IncRowid,dhclogm))
	.s dhclogsub=$o(^DHCLOG(0,"INCILOG",+IncRowid,dhclogm,"")) 
	.s tmptype=$p(^DHCLOG(dhclogm,"INCI",dhclogsub),"^",2)
	.s levpointer=IncRowid_"||"_dhclogm
	.s levid=$o(^DHCWORKAUDIT(0,"TypePointer","Basic",levpointer,""),-1)  //业务审核记录
	.i levid=""  s IsNewEdit="Y"
	.q:IsNewEdit="Y"
	.s levflag=$p(^DHCWORKAUDIT(levid),"^",7)
	.s auditlev=$p(^DHCWORKAUDIT(levid),"^",6)
	.i (maxlev>0)&(levflag="Y")&(maxlev>auditlev) s IsNewEdit="Y"
	q IsNewEdit
}

/// creator:    yunhaibao
/// createdate: 2017-06-30
/// description:保存药学+医嘱项
/// input:		arcItmID(医嘱项ID),arcItmList(医嘱项数据),phcdList(药学项ID)
/// return:     +$p(retval,"^",1)>=0 成功,其他失败^2为错误信息
/// w ##class(web.DHCST.DrugInfoMaintain).SavePhcArc("469||1","XKF000310^阿普唑仑片[0.4mg*20]^^6^1^1||1^Y^3^N^^^^^^^^^N^N^N^N^1^^^^^^^^^^2017-07-06^^6     423^^","XKF000310^阿普唑仑片[0.4mg*20]^20^2^12^1^1^328^3^12^^416^^^^^^^^^N^0^0^0^^6423^N^N^^^^^^^^^N^^^N^N^N^N^N^N^N^N^N^^N^N^N^N^N^^N")
ClassMethod SavePhcArc(arcItmID, arcItmList, phcdList)
{
	n (arcItmID,arcItmList,phcdList,%session)
	s ^TMPDHCSTPARAMS("web.DHCST.DrugInfoMaintain","SavePhcArc")=$lb(arcItmID, arcItmList, phcdList)
	s phcdfId=""
	i arcItmID'="" d
	.s arcSub=+arcItmID
	.s arcVer=$p(arcItmID,"||",2)	
	.i (arcSub'="")&&(arcVer'="") s phcdfId=$p(^ARCIM(arcSub,arcVer,1),"^",12)
	tstart
 	s $ZT="Error^DHCSTERROR"	
 	/// 保存药学项
 	s saveRet=##class(web.DHCST.PHCDRGMAST).Save(phcdfId,phcdList)
 	i +saveRet<=0  trollback
 	q:+saveRet<=0 "-1^"_##class(web.DHCST.PHCDRGMAST).ErrCodeToDesc(saveRet)
 	s phcdfId=saveRet
 	/// 保存医嘱项
 	s $p(arcItmList,"^",23)="N" // 不维护收费项
 	i (arcItmID'="")&&($d(^INCI(0,"ARCIM_DR",+arcItmID))) d
 	.s incId=$o(^INCI(0,"ARCIM_DR",+arcItmID,""))
 	.s $p(arcItmList,"^",3)=$p($g(^INCI(+incId,1)),"^",12)	// 计价单位,同门诊发药单位
  	s saveRet=##class(web.DHCST.ARCITMMAST).Save(arcItmID,phcdfId_"^"_arcItmList)
 	i +saveRet<=0  trollback
 	q:+saveRet<=0 "-1^"_##class(web.DHCST.ARCITMMAST).ErrCodeToDesc(saveRet)
 	tcommit
	q 0_"^"_saveRet
}

/// creator:    yunhaibao
/// createdate: 2017-07-05
/// description:保存库存项
/// input:		incItmID(库存项ID),incItmList(库存项数据),incStoreList(存储条件),tarItmList(收费项数据)
/// return:     +$p(retval,"^",1)>=0 成功,其他失败^2为错误信息
/// w ##class(web.DHCST.DrugInfoMaintain).SaveInc("",2)
ClassMethod SaveInc(incItmID, incItmList, incStoreCon, tarItmList, userId)
{
	n (incItmID,incItmList,incStoreCon,tarItmList,userId,%session)
	s ^TMPDHCSTPARAMS("web.DHCST.DrugInfoMaintain","SaveInc")=$lb(incItmID, incItmList, incStoreCon, tarItmList, userId)
	s errCode=""
	i incItmID'="" d
	.s itmAddId=$o(^DHCITMINFO(0,"INCI",incItmID,0))
	.i itmAddId'="" s $p(incItmList,"^",32)=$p($g(^DHCITMINFO(itmAddId)),"^",28)
	e  d
	.s arcItmId=$p(incItmList,"^",1)
	tstart
 	s $ZT="Error^DHCSTERROR"	
 	/// 保存库存项
  	s saveRet=##class(web.DHCST.INCITM).Save(incItmID,incItmList,1)
 	i +saveRet<=0  trollback
 	q:+saveRet<=0 "-1^"_##class(web.DHCST.INCITM).ErrCodeToDesc(saveRet)
 	s incItmId=saveRet
 	/// 保存收费项
 	s saveRet=##class(web.DHCST.INCITM).SaveTarItem(incItmId,tarItmList,userId)
  	i +saveRet<=0  trollback
 	q:+saveRet<=0 saveRet
 	/// 新增数据时,价格由此插入
 	i incItmID="" d
 	.s UpdateUserId=$p(incItmList,"^",14)          	;更新人
    .s gLocId=$p(incItmList,"^",58)                	;科室
    .s gGroupId=$p(incItmList,"^",59)              	;安全组
    .s PreExeDate=$p(incItmList,"^",17)				;价格生效日期
    .s Sp=$p(incItmList,"^",15)
    .s Rp=$p(incItmList,"^",16)
    .s PrcFile=$p(incItmList,"^",43)               	;物价文件号
    .s PrcFileDate=$p(incItmList,"^",44)           	;物价文件备案时间
    .s PurUomId=$p(incItmList,"^",5)               	;入库单位id
    .i PrcFileDate'="" s PrcFileDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(PrcFileDate)
    .s paramStr=##class(web.DHCST.Common.AppCommon).GetParamCommon(gGroupId,gLocId,UpdateUserId)
    .s RpRule=$p(paramStr,"^",8)
    .s GroupFlag=$p(paramStr,"^",7)
    .i RpRule'=3 d
    ..i (Sp'="")!(Rp'="")  d
    ...q:GroupFlag="2" //集团化医院标记，如果为集团化医院不插入调价记录
    ...s AppName="DHCSTADJSP"
    ...s:PrcFileDate'="" PrcFileDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(PrcFileDate)
    ...s WarrentInfo=PrcFile_"^"_PrcFileDate_"^"_PreExeDate
    ...s defaultDept=$p(^SSU("SSUSR",UpdateUserId),"^",4)
    ...s hospId=$p(^CTLOC(defaultDept),"^",22)
	...s delRet=##class(web.DHCST.INAdjSalePrice).DeleteAdjPrice(incItmId)
    ...s aspRet=##class(web.DHCST.INAdjSalePrice).CreateAdjspFromNewitm1(incItmId,Sp,UpdateUserId,PurUomId,Rp,AppName,hospId,WarrentInfo)
    ...i +aspRet<0 s errCode="-1^生成价格信息失败,"_aspRet
  	i errCode'=""  trollback
  	q:errCode'="" errCode
 	tcommit
 	/// 存储条件
 	s itmAddId=$o(^DHCITMINFO(0,"INCI",incItmId,0))
 	i itmAddId'="" d
	.s storeId=+$p($g(^DHCITMINFO(itmAddId)),"^",28)
	.i '$d(^DHCItemSC(storeId)) s storeId=""
	.d ##class(web.DHCST.ITMSTORECON).Save(storeId,incStoreCon,incItmId)
	q 0_"^"_incItmId
}

}
