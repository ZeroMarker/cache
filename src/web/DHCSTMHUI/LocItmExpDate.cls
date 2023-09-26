Import sqluser

Class web.DHCSTMHUI.LocItmExpDate Extends (%RegisteredObject, %XML.Adaptor, StkTypeM) [ Inheritance = right, Not ProcedureBlock ]
{

/// 检索效期查看要求的科室库存项目列表
/// Author:zhwh
/// Date:2012-07-26
/// Argu:
///  Loc      -  科室RowId
///  RestMon - 相对于参照日期之后的月数(即即将RestMonth月后过期)
///  ZeroStkFlag - 零库存批次标志
///  INCSC  - 分类
///  IncludeNotUseFlag -  包含不可用
///  refDate - 效期参照日期(一般是当前日期)
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.LocItmExpDate","LocItmBatOfExp",^tmpltx(9271),^tmpltx(9272))
Query LocItmBatOfExp(Params As %String, RestMon As %String) As Query(ROWSPEC = "inclb,inci,InciCode,InciDesc,Spec,Manf,incsc,IncscDesc,batNo,expDate,stkQty:%Float,stkUom,sbDesc,lastvendorName,warnDays:%Integer,month,SpecDesc")
{
}

ClassMethod LocItmBatOfExpExecute(ByRef qHandle As %Binary, Params As %String, RestMon As %String) As %Status
{
	n (qHandle,Params,RestMon)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)

	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	d PJObj.%FromJSON(Params)
	s Loc=PJObj.%Get("PhaLoc")
	q:Loc="" $$$OK
	
	s EndDate=PJObj.%Get("EndDate")
	s ZeroStkFlag=PJObj.%Get("ZeroFlag")
	s INCSC=PJObj.%Get("StkCat")
	s StkGrpId=PJObj.%Get("StkGrpId")
	s IncludeNotUseFlag=PJObj.%Get("NotUseFlag")
	s UserId=PJObj.%Get("gUserId")
	s gHospId=PJObj.%Get("gHospId")
	s PInci=PJObj.%Get("Inci")
	s PInciDesc=PJObj.%Get("InciDesc")
	s pHospId=..sssHospId(Loc)
	s:pHospId="" pHospId=gHospId
	s StkGrpId=##class(web.DHCSTMHUI.Util.DrugUtil).GetUserCatGrpStr(UserId,..sssCode(),Loc,StkGrpId,pHospId)

	s EndDate=..DH2L(EndDate)
	s sql=" select a.%id inclb,"
	s sql=sql_"inclb_incib_dr incib,"
	s sql=sql_"inclb_incib_dr->incib_no batNo,"
	s sql=sql_"inclb_incib_dr->incib_expdate expDate,"
	s sql=sql_"inclb_phyqty lbQty,"
	s sql=sql_"inclb_incil_parref->incil_inci_parref->inci_code code,"
	s sql=sql_"inclb_incil_parref->incil_inci_parref->inci_desc descx,"
	s sql=sql_"inclb_incil_parref->incil_inci_parref->inci_incsc_dr incsc,"
	s sql=sql_"inclb_incil_parref->incil_inci_parref->inci_incsc_dr->incsc_desc incscDesc,"
	s sql=sql_"inclb_incil_parref->incil_incsb_dr->incsb_desc sbDesc,"
	s sql=sql_"inclb_incil_parref->incil_inci_parref->inci_notuseflag NotUseFlag,"
	s sql=sql_"inclb_incil_parref->incil_inci_parref->inci_ctuom_purch_dr pUom,"
	s sql=sql_"inclb_incil_parref->incil_inci_parref->inci_ctuom_purch_dr->ctuom_desc pUomDesc,"
	s sql=sql_"inclb_incil_parref->incil_inci_parref->inci_ctuom_dr bUom,"
	s sql=sql_"inclb_incil_parref->incil_inci_parref->inci_ctuom_dr->ctuom_desc bUomDesc"
	s sql=sql_" from inc_itmlcbt a join dhc_incitmlcbt b "
	s sql=sql_" on b.inclb_lb_dr=a.%id"
	s sql=sql_ " where inclb_ctloc_dr='"_Loc_"' and inclb_active='Y'"
	s xrs=##class(%Library.ResultSet).%New()
	d xrs.RuntimeModeSet(0)
	d xrs.Prepare(sql)
	s sc=xrs.Execute()
	i $$$ISERR(sc) q $$$OK
	while (xrs.Next())
	{
		s inclb=xrs.Data("inclb")
		s inci=+inclb
		continue:(PInci'="")&&(inci'=PInci)
		s IncscId=$p(^INCI(inci,2),"^",2)
		continue:(INCSC'="")&&(IncscId'=INCSC)
		s incib=xrs.Data("incib")
		s batNo=xrs.Data("batNo")
		s expDate=xrs.Data("expDate")
		continue:expDate=""

		s StkGrpInfo=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncStkCatGrp(inci)
		s ScgType=$p(StkGrpInfo,"^",3)
		s Scg=$p(StkGrpInfo,"^",5)
		continue:ScgType'=..sssCode()

		continue:(StkGrpId'="")&(("^"_StkGrpId_"^")'[("^"_Scg_"^"))
		//continue:expDate<FirstDate
		s dateRange=..GetDateRange(EndDate,expDate)
		s flag=##class(web.DHCSTMHUI.Common.UtilCommon).FindInList(RestMon,dateRange,",")
		continue:flag=0   //效期不在要求的日期范围内
		;continue:expDate>toExpDate   //效期在要求的截止期之后

		s warnDays=expDate-EndDate   //预警天数(即参照日期n天后到期)，负值表示相对参照日期，已经过期
		//w warnDays,!
		s stkQty=xrs.Data("lbQty")
		;i ZeroStkFlag="N" continue:stkQty'>0
		i ZeroStkFlag'="Y" continue:stkQty'>0
		s StockQty=##class(web.DHCSTMHUI.Common.DrugStkCommon).IL(inci,Loc,EndDate)
		continue:StockQty'>0
		s code=xrs.Data("code")
		s desc=xrs.Data("descx")
		continue:(PInciDesc'="")&&(desc'[PInciDesc)
		s incsc=xrs.Data("incsc")
		s incscDesc=xrs.Data("incscDesc")
		s sbDesc=xrs.Data("sbDesc")
		s NotUseFlag=xrs.Data("NotUseFlag")
		i IncludeNotUseFlag="Y" continue:NotUseFlag="Y"  // 不可用

		s pUom=xrs.Data("pUom")
		s pUomDesc=xrs.Data("pUomDesc")
		s bUom=xrs.Data("bUom")
		s bUomDesc=xrs.Data("bUomDesc")
		s fac=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(pUom,bUom)
		s stkQty=stkQty/fac  //换算
		//
		s stkUom=pUomDesc
		s spec=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetSpec("",inci)
		s manf=$p(##class(web.DHCSTMHUI.Common.DrugStkCommon).GetManfInfoByInclb(inclb),"^",2)
		s lastVen=##class(web.DHCSTMHUI.Common.DrugStkCommon).GetvendorInfoByInclb(inclb,+$h)
		s lastvendorName=$p(lastVen,"^",2)
		i expDate'="" s expDate=..DL2H(expDate)
		s SpecDesc=##class(web.DHCSTMHUI.Common.DrugStkCommon).GetSpecDescByInclb(inclb)
		d OutPutRow
	}
	Quit $$$OK
OutPutRow
	s Data=$lb(inclb,inci,code,desc,spec,manf,incsc,incscDesc,batNo,expDate,stkQty,stkUom,sbDesc,lastvendorName,warnDays,dateRange,SpecDesc)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// 判断该效期是属于哪个过期段
/// Author:zhangdongmei
/// Date:2012-08-13
/// Argu:
///  参考日期，效期 
/// Return:过期段（0：相对于参考日期已经过期；1：相对于参考日期还有一个月过期；）
ClassMethod GetDateRange(RefDate As %String, ExpDate As %String) As %String
{
  n (RefDate,ExpDate)
  q:ExpDate<RefDate 0   ;已经过期
  s DateRange=13        ;距离过期至少在12个月以上
  s Flag=0              ;未找到过期段
  f MonthFlag=1:1:12  q:Flag=1  d
  .
  .s NewRefDate=$p($SYSTEM.SQL.DATEADD("mm",MonthFlag,RefDate)," ")
  .i NewRefDate["-" s NewRefDate=$zdh(NewRefDate,3)
  .i ExpDate<NewRefDate  d
  ..s Flag=1
  ..s DateRange=MonthFlag
  ..
  .
  q DateRange
}

}
