Import sqluser

Class web.DHCST.LocItmExpDate Extends (%RegisteredObject, %XML.Adaptor, StkTypeG) [ Not ProcedureBlock ]
{

Parameter AppName [ Final ] = "DHCSTLOCITMSTK";

/// 取效期报警的库存项目列表 (json)
/// Author:zhwh
/// Date:2012-07-26
/// w ##class(web.DHCST.LocItmExpDate).jsLocItmBatOfExp("0","30","","","187^2022-02-14^13^N^^N^3",18659)
ClassMethod jsLocItmBatOfExp(Start As %String, Limit As %String, Sort As %String, Dir As %String, StrPar As %String, User As %String = "") As %String
{
	n (Start , Limit, Sort , Dir , StrPar , User, %session)
	s ^PHATMP("YSJ","jsLocItmBatOfExp") = $LB(Start , Limit, Sort , Dir , StrPar , User)
    s $zt="ErrorjsLocItmBatOfExp"
	s qPar=Sort_"^"_Dir     
	s Loc=$p(StrPar,"^",1)    //科室rowid
	s refDate=$p(StrPar,"^",2)  //效期参照日期(一般是当前日期)
	s RestMonth=$p(StrPar,"^",3)  //相对于参照日期之后的月数(就是说即将RestMonth月后过期)
	s ZeroStkFlag=$p(StrPar,"^",4)   //包含零库存标志
	s INCSC=$p(StrPar,"^",5)  //库存分类rowid
	s IncludeNotUseFlag=$p(StrPar,"^",6)   //是否排除"不可用"项
	s StkGrpId=$p(StrPar,"^",7)
	//s:StkGrpId="" StkGrpId=##class(web.DHCST.Util.DrugUtil).GetUserCatGrpStrNew(User,..sssCode())  //若类组为空，则传递User类组串
	s result=##class(%Library.ResultSet).%New("web.DHCST.LocItmExpDate:LocItmBatOfExp")
	s sc=result.Execute(qPar,Loc,refDate,RestMonth,ZeroStkFlag,INCSC,IncludeNotUseFlag,StkGrpId)
	i $$$ISERR(sc) q ##class(web.DHCSTEXTCOMMON).GetNoJson()  
	d ##class(web.DHCST.Common.Display).RSToJson(result,Sort,Dir,Start,Limit)
	Q ""
ErrorjsLocItmBatOfExp
	s Error=$$Error^DHCSTERROR()
	q "{Error:'"_Error_"'}"
}

/// 检索效期查看要求的科室库存项目列表
/// Author:zhwh
/// Date:2012-07-26
/// Argu:
///  Loc      -  科室RowId
///  refDate - 效期参照日期(一般是当前日期)
///  RestMonth - 相对于参照日期之后的月数(即即将RestMonth月后过期)
///  ZeroStkFlag - 零库存批次标志
///  INCSC  - 分类
///  IncludeNotUseFlag -  包含不可用
///  w ##class(%ResultSet).RunQuery("web.DHCST.LocItmExpDate","LocItmBatOfExp","^","320","2016-07-17","0,1,2,3,4,5,6,13","N","","N",3)
Query LocItmBatOfExp(qPar As %String, Loc As %String, refDate As %String, RestMonth As %String, ZeroStkFlag As %String, INCSC As %String, IncludeNotUseFlag As %String, StkGrpId As %String) As %Query(ROWSPEC = "inclb:%String,inci:%String,code:%String,desc:%String,spec:%String,manf:%String,incsc:%String,incscDesc:%String,batNo:%String,expDate:%String,stkQty:%String,stkUom:%String,sbDesc:%String,lastvendorName:%String,warnDays:%String,month:%String") [ SqlProc ]
{
}

ClassMethod LocItmBatOfExpExecute(ByRef qHandle As %Binary, qPar As %String, Loc As %String, refDate As %String, RestMonth As %String, ZeroStkFlag As %String, INCSC As %String, IncludeNotUseFlag As %String, StkGrpId As %String) As %Status
{
 s repid=$I(^CacheTemp)
 s ind=1
 s qHandle=$lb(0,repid,0)
 s refDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(refDate)
 s Sort=$p(qPar,"^",1)
 s Dir=$p(qPar,"^",2)
 s orderFieldName=""
 s Sort=$$ALPHAUP^SSUTIL4(Sort)
 s:Sort="CODE" orderFieldName="code"
 s:Sort="DESC" orderFieldName="descx"
 s:Sort="EXPDATE" orderFieldName="expDate"
 ;s:Sort="" orderFieldName=""
 ;s:Sort="" orderFieldName=""
 ;
 s sql=" select %id inclb,"
 s sql=sql_"inclb_incib_dr incib,"
 s sql=sql_"inclb_incib_dr->incib_no batNo,"
 s sql=sql_"inclb_incib_dr->incib_expdate expDate,"
 s sql=sql_"inclb_phyqty lbQty,"
 s sql=sql_"inclb_incil_parref->incil_inci_parref->inci_code code,"
 s sql=sql_"inclb_incil_parref->incil_inci_parref->inci_desc descx,"
 s sql=sql_"inclb_incil_parref->incil_inci_parref->inci_incsc_dr incsc,"
 s sql=sql_"inclb_incil_parref->incil_inci_parref->inci_incsc_dr->incsc_desc incscDesc,"
 //s sql=sql_"inclb_incil_parref->incil_incsb_dr->incsb_desc sbDesc,"
 s sql=sql_"inclb_incil_parref->incil_inci_parref->inci_notuseflag NotUseFlag,"
 s sql=sql_"inclb_incil_parref->incil_inci_parref->inci_ctuom_purch_dr pUom,"
 s sql=sql_"inclb_incil_parref->incil_inci_parref->inci_ctuom_purch_dr->ctuom_desc pUomDesc,"
 s sql=sql_"inclb_incil_parref->incil_inci_parref->inci_ctuom_dr bUom,"
 s sql=sql_"inclb_incil_parref->incil_inci_parref->inci_ctuom_dr->ctuom_desc bUomDesc"
 
 s sql=sql_" from   inc_itmlcbt "
 s sql=sql_ " where  inclb_incil_parref->incil_ctloc_dr="_Loc
 i INCSC'="" d
 .s sql=sql_" and inclb_incil_parref->incil_inci_parref->inci_incsc_dr="_INCSC
 
 i orderFieldName'="" d
 .s sql=sql_" Order By "_orderFieldName_" "_Dir
 s Dir=$$ALPHAUP^SSUTIL4(Dir)
 s:(Dir="")&(Dir'="ASC")&(Dir'="DESC") Dir="DESC"
 s xrs=##class(%Library.ResultSet).%New()
 d xrs.Prepare(sql)
 s sc=xrs.Execute()
 i $$$ISERR(sc) q $$$OK
 s count = 0
 while (xrs.Next())
 {
  s inclb=xrs.Data("inclb")
  s inci=+inclb
  s incib=xrs.Data("incib")
  s incil=$p(inclb,"||",1,2)
  s batNo=xrs.Data("batNo")
  s expDate=xrs.Data("expDate")
  i expDate'="" s expDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(expDate)
  s StkGrpInfo=##class(web.DHCST.Common.DrugInfoCommon).GetIncStkCatGrp(inci)
  s ScgType=$p(StkGrpInfo,"^",3)
  s Scg=$p(StkGrpInfo,"^",5)
  continue:ScgType'=..sssCode()
  //continue:(StkGrpId'="")&(Scg'=StkGrpId)
  continue:(StkGrpId'="")&(("^"_StkGrpId_"^")'[("^"_Scg_"^"))
  //continue:expDate<FirstDate
  s dateRange=..GetDateRange(refDate,expDate)
  s flag=##class(web.DHCST.Common.UtilCommon).FindInList(RestMonth,dateRange,",")
  continue:flag=0   //效期不在要求的日期范围内
  ;continue:expDate>toExpDate   //效期在要求的截止期之后
  s warnDays=expDate-refDate   //预警天数(即参照日期n天后到期)，负值表示相对参照日期，已经过期
  //s stkQty=xrs.Data("lbQty")
  s stkQty=##class(web.DHCST.Common.DrugStkCommon).QtyINCLB(inclb,+$h)
  i ZeroStkFlag="N" continue:stkQty'>0
  s code=xrs.Data("code")
  s desc=xrs.Data("descx")
  s incsc=xrs.Data("incsc")
  s incscDesc=xrs.Data("incscDesc")
  s stkbinret=##class(web.DHCST.Common.DrugInfoCommon).GetInciBinStr(incil,",","","") 
  s stkbinstr=$p(stkbinret,":",2)
  s sbDesc=stkbinstr  //货位
  s NotUseFlag=xrs.Data("NotUseFlag")
  i IncludeNotUseFlag="Y" continue:NotUseFlag="Y"  // 不可用
  s pUom=xrs.Data("pUom")
  s pUomDesc=xrs.Data("pUomDesc")
  s bUom=xrs.Data("bUom")
  s bUomDesc=xrs.Data("bUomDesc")
  s fac=##class(web.DHCST.Common.UtilCommon).UOMFac(pUom,bUom)
  s stkQty=stkQty/fac  //换算
  s stkUom=pUomDesc
  s spec=##class(web.DHCST.Common.DrugInfoCommon).GetSpec("",inci)
  s manf=$p(##class(web.DHCST.Common.DrugStkCommon).GetManfInfoByInclb(inclb),"^",2)
  s lastVen=##class(web.DHCST.Common.DrugStkCommon).GetInclbVend(inclb,+$h)
  s lastvendorName=$p(lastVen,"^",2)
  i expDate'="" s expDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(expDate,"ST")
  d OutPutRow
 }

 ;库存批次RowId，药品RowId，药品代码，名称，规格，厂商，批号，效期，库存数量，单位，货位码，最新供应商
 Quit $$$OK
OutPutRow
 s Data=$lb(inclb,inci,code,desc,spec,manf,incsc,incscDesc,batNo,expDate,stkQty,stkUom,sbDesc,lastvendorName,warnDays,dateRange)   
 s ^CacheTemp(repid,ind)=Data
 s ind=ind+1
 q
}

ClassMethod LocItmBatOfExpClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = LocItmBatOfExpExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod LocItmBatOfExpFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = LocItmBatOfExpExecute ]
{
 Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {                // if there are no more rows, finish fetching
    Set AtEnd=1
    Set Row=""
 }
 Else {         
        Set Row=^CacheTemp(repid,ind)
 }
 s qHandle=$lb(AtEnd,repid,ind)
 Quit $$$OK
}

/// 判断该效期是属于哪个过期段
/// Author:zhangdongmei
/// Date:2012-08-13
/// Argu:
///  参考日期，效期 
/// Return:过期段（0：相对于参考日期已经过期；1：相对于参考日期还有一个月过期；）
/// w ##class(web.DHCST.LocItmExpDate).GetDateRangeOld($ZDH("2021-03-05",3),$ZDH("2021-04-05",3))
ClassMethod GetDateRangeOld(RefDate As %String, ExpDate As %String) As %String
{
  n (RefDate,ExpDate)
  q:ExpDate<RefDate 0   ;已经过期
  s DateRange=13        ;距离过期至少在12个月以上
  s Flag=0              ;未找到过期段
  f MonthFlag=1:1:12  q:Flag=1  d
  .
  .s NewRefDate=$p($SYSTEM.SQL.DATEADD("mm",MonthFlag,RefDate)," ")
  .i NewRefDate["-" s NewRefDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(NewRefDate)
  .i ExpDate<NewRefDate  d
  ..s Flag=1
  ..s DateRange=MonthFlag
  ..
  .
  q DateRange
}

/// yangshijie 2021-04-07
/// w ##class(web.DHCST.LocItmExpDate).GetDateRange($ZDH("2021-03-05",3),$ZDH("2021-04-05",3))
ClassMethod GetDateRange(RefDate As %String, ExpDate As %String) As %String
{
  n (RefDate,ExpDate)
  q:ExpDate<RefDate 0   ;已经过期
  s RefDate=$zd(RefDate,3)
  s ExpDate=$zd(ExpDate,3)
  s RefY=$P(RefDate,"-",1),RefM=$P(RefDate,"-",2),RefD=$P(RefDate,"-",3)
  s ExpY=$P(ExpDate,"-",1),ExpM=$P(ExpDate,"-",2),ExpD=$P(ExpDate,"-",3)
  s DiffY=ExpY-RefY,DiffM=ExpM-RefM,DiffD=ExpD-RefD
  i DiffM<0 s DiffY=DiffY-1,DiffM=12+DiffM
  i DiffD>=0 s DiffM=DiffM+1
  s DateRange = ((DiffY*12)+DiffM)
  q:(DateRange>12) 13
  q DateRange
}

/// Descript:取效期报警吸相关参数
/// Creater:    yangsj
/// CreateDate: 2021-04-09
/// Table:
/// Input:安全组id,科室id,用户id
/// Output:     
/// Return：默认勾选月份
/// w ##class(web.DHCST.LocItmExpDate).GetParamProp(142,257,11643)
ClassMethod GetParamProp(GroupId As %String, LocId As %String, UserId As %String) As %Library.String
{
    n (GroupId,LocId,UserId)
    s:LocId'="" HospId=$p(^CTLOC(LocId),"^",22)
    s Param=GroupId_"^"_LocId_"^"_UserId_"^"_$g(HospId)
    s AppName=##class(web.DHCST.LocItmExpDate).%GetParameter("AppName")
    s ExpDateWarnMon=##class(web.DHCST.Common.AppCommon).GetAppPropValue(AppName,"ExpDateWarnMon",Param)
    q ExpDateWarnMon
}

ClassMethod NewPid() As %String
{
  q $I(^DHCSTPID("LocItmExpDate"))
}

}
