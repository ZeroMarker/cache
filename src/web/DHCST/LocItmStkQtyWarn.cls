Class web.DHCST.LocItmStkQtyWarn Extends (%RegisteredObject, %XML.Adaptor, StkTypeG)
{

/// 取科室中库存报警的项目列表(json)
/// Author:zhwh
/// Date:2012-07-26
/// Argu:
///  Start
///  Limit
///  Sort
///  Dir
///  StrPar
/// Return:
///   项目列表串(json)0,999999,,,102^1^^^N^1,590
///   w ##class(web.DHCST.LocItmStkQtyWarn).jsLocItmStkQtyLimitWarn(0,9999,"","","102^1^^^N^1",590) 
ClassMethod jsLocItmStkQtyLimitWarn(Start As %String, Limit As %String, Sort As %String, Dir As %String, StrPar As %String, User As %String) As %String
{
 s $zt="ErrorjsLocItmStkQtyLimitWarn"
 s jsSort=Sort	   
 s qPar=Sort_"^"_Dir    //查询参数:排序字段和方向
 s Loc=$p(StrPar,"^",1)  //科室rowid
 s SCG=$p(StrPar,"^",2)  //类组rowid
 s:SCG="" SCG=##class(web.DHCST.Util.DrugUtil).GetUserCatGrpStrNew(User,..sssCode()) //传递类组串
 s INCSC=$p(StrPar,"^",3)   //分类rowid
 s StkBin=$p(StrPar,"^",4)  //货位rowid
 s IncludeNotUseFlag=$p(StrPar,"^",5)  //是否包括"不可用"项目
 s LimitFlag=$p(StrPar,"^",6)  //限制条件
 s result=##class(%Library.ResultSet).%New("web.DHCST.LocItmStkQtyWarn:LocItmStkQtyLimitWarn")
 s sc=result.Execute(qPar,Loc,SCG,INCSC,StkBin,IncludeNotUseFlag,LimitFlag)
 i $$$ISERR(sc) q ##class(web.DHCSTEXTCOMMON).GetNoJson() 
 d ##class(web.DHCST.Common.Display).RSToJson(result,Sort,Dir,Start,Limit)
 Q ""
ErrorjsLocItmStkQtyLimitWarn
 s Error=$$Error^DHCSTERROR()
 q "{Error:'"_Error_"'}"
}

/// 检索科室库存报警的项目
/// Author:zhwh
/// Date:20120726
/// Argu:
///  Loc - 科室RowId，
///  SCG - 类组RowId=””，
///  INCSC -分类RowId=””，
///  SbDesc  - 货位码=””，
///  IncludeNotUseFlag - 不可用标志=””
///  LimitFlag - "限制条件"
Query LocItmStkQtyLimitWarn(qPar As %String, Loc As %String, SCG As %String, INCSC As %String, StkBin As %String, IncludeNotUseFlag As %String, LimitFlag As %String = "") As %Query(ROWSPEC = "incil:%String,inci:%String,code:%String,desc:%String,spec:%String,manf:%String,maxQty:%String,minQty:%String,repQty:%String,avaQty:%String,incscDesc:%String,stkUom:%String,stkStat:%String") [ SqlProc ]
{
}

ClassMethod LocItmStkQtyLimitWarnExecute(ByRef qHandle As %Binary, qPar As %String, Loc As %String, SCG As %String, INCSC As %String, StkBin As %String, IncludeNotUseFlag As %String, LimitFlag As %String = "") As %Status
{
 s repid=$I(^CacheTemp)
 s ind=1
 s qHandle=$lb(0,repid,0)
 s Sort=$p(qPar,"^",1)
 s Dir=$p(qPar,"^",2)
 s HospId=$p($g(^CTLOC(Loc)),"^",22)
 s sql="select incil_inci_parref inci,"
 s sql=sql_"incil_rowid incil,"
 s sql=sql_"incil_inci_parref->inci_code code,"
 s sql=sql_"incil_inci_parref->inci_desc descx,"
 s sql=sql_"incil_maxqty maxQty,"
 s sql=sql_"incil_minqty minQty,"
 s sql=sql_"incil_repqty repQty,"
 s sql=sql_"incil_availqty avaQty,"
 s sql=sql_"incil_inci_parref->inci_notuseflag NotUseFlag,"
 s sql=sql_"incil_inci_parref->inci_incsc_dr->incsc_desc incscDesc,"
 s sql=sql_"incil_inci_parref->inci_ctuom_purch_dr pUom,"
 s sql=sql_"incil_inci_parref->inci_ctuom_purch_dr->ctuom_desc pUomDesc,"
 s sql=sql_"incil_inci_parref->inci_ctuom_dr bUom,"
 s sql=sql_"incil_inci_parref->inci_ctuom_dr->ctuom_desc bUomDesc"
 s sql=sql_" from inc_itmloc"
 s sql=sql_" where incil_ctloc_dr="_Loc

 i INCSC'="" d
 . s sql=sql_" and incil_inci_parref->inci_incsc_dr="_INCSC 
 s orderFieldName=""
 s Sort=$$ALPHAUP^SSUTIL4(Sort)
 s:Sort="CODE" orderFieldName="code"
 s:Sort="DESC" orderFieldName="descx"
 s:Sort="INCSC" orderFieldName="incscDesc"
 ;s:Sort="" orderFieldName=""
 s Dir=$$ALPHAUP^SSUTIL4(Dir)
 s:(Dir="")&(Dir'="ASC")&(Dir'="DESC") Dir="DESC"
 i orderFieldName'="" d
 .s sql=sql_" Order By "_orderFieldName_" "_Dir
 s xrs=##class(%ResultSet).%New()
 d xrs.Prepare(sql)
 s sc=xrs.Execute()
 if $$$ISERR(sc) q $$$OK  
 while (xrs.Next())
 {
  s NotUseFlag=xrs.Data("NotUseFlag")
  i IncludeNotUseFlag="Y" continue:NotUseFlag="Y"  //不可用的滤除
  s maxQty=xrs.Data("maxQty")
  s minQty=xrs.Data("minQty")
  continue:(+minQty=0)&(+maxQty=0)   //未设置上下限的滤除
  s repQty=xrs.Data("repQty")
  s avaQty=xrs.Data("avaQty")
  s err=0
  i (minQty'="")&(avaQty<minQty) s err=-1
  i (maxQty'="")&(avaQty>maxQty) s err=-2
  continue:err=0    
  continue:(LimitFlag="1")&&(avaQty'>maxQty)
  continue:(LimitFlag="2")&&(avaQty'<maxQty)
  s incil=xrs.Data("incil")
  s inci=xrs.Data("inci")
  s ScgGrpInfo=##class(web.DHCST.Common.DrugInfoCommon).GetIncStkCatGrp(inci)
  s ScgType=$p(ScgGrpInfo,"^",3)
  continue:ScgType'=..sssCode()
  s scg=$P(ScgGrpInfo,"^",5) 
  i SCG'="" continue:("^"_SCG_"^")'[("^"_scg_"^")  //zhwh 2013-07-17
  //新货位码过滤,yunhaibao20160216
  s stkbinret=##class(web.DHCST.Common.DrugInfoCommon).GetInciBinStr(incil,",",StkBin,"") 
  s stkbinquit=$p(stkbinret,":",1)
  continue:(StkBin'="")&&(stkbinquit="0")
  s code=xrs.Data("code")
  s desc=xrs.Data("descx")
  s incscDesc=xrs.Data("incscDesc")
  s bUom=xrs.Data("bUom")
  s pUom=xrs.Data("pUom")
  s pUomDesc=xrs.Data("pUomDesc")
  s fac=##class(web.DHCST.Common.UtilCommon).UOMFac(pUom,bUom)
  s stkUom=pUomDesc  
  s maxQty=maxQty/fac
  s minQty=minQty/fac
  s repQty=repQty/fac
  s avaQty=avaQty/fac
  s maxQty=##class(web.DHCST.Common.AppCommon).FormatSq(maxQty,HospId,1,"G")
  s minQty=##class(web.DHCST.Common.AppCommon).FormatSq(minQty,HospId,1,"G")
  s repQty=##class(web.DHCST.Common.AppCommon).FormatSq(repQty,HospId,1,"G")
  s avaQty=##class(web.DHCST.Common.AppCommon).FormatSq(avaQty,HospId,1,"G")
  s spec=##class(web.DHCST.Common.DrugInfoCommon).GetSpec("",inci)
  s manf=$P(##class(web.DHCST.Common.DrugInfoCommon).GetManf(inci),"^",3)
  i avaQty>maxQty s stkStat="高于上限"
  i avaQty<maxQty s stkStat="低于下限"
  d OutPutRow1
 }
 Quit $$$OK
OutPutRow1
  s Data=$lb(incil,inci,code,desc,spec,manf,maxQty,minQty,repQty,avaQty,incscDesc,stkUom,stkStat)   
 s ^CacheTemp(repid,ind)=Data
 s ind=ind+1
 q
}

ClassMethod LocItmStkQtyLimitWarnClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = LocItmStkQtyLimitWarnExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod LocItmStkQtyLimitWarnFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = LocItmStkQtyLimitWarnExecute ]
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

/// 取科室内库存不足以满足库存支持天数的销售之库存项目串(json)
/// Author:zhwh
/// Date:2012-07-26
/// Argu:
///  Loc a - 科室RowId，
///  StartDate - 参考起始日期，
///  EndDate   - 参考截止日期，
///  StkSupportDays  -库存保持天数
/// Return:
///    库存项目串(json)
///    w ##class(web.DHCST.LocItmStkQtyWarn).jsLocItmQtyDspWarn(0,30,"","","98^2015-11-01^2016-02-25^900000^N",590) 
ClassMethod jsLocItmQtyDspWarn(Start As %String, Limit As %String, Sort As %String, Dir As %String, StrPar As %String, User As %String = "") As %String
{
  
 s $zt="ErrorjsLocItmQtyDspWarn"
 s jsSort=Sort
 s qPar=Sort_"^"_Dir    //查询参数:排序字段和方向
 s Loc=$p(StrPar,"^",1)  //科室rowid
 s StartDate=$p(StrPar,"^",2)  //类组rowid
 s EndDate=$p(StrPar,"^",3)   //分类rowid
 s StkSupportDays=$p(StrPar,"^",4)  //货位名称
 s IncludeNotUseFlag=$p(StrPar,"^",5)  //是否包括"不可用"项目
 s result=##class(%Library.ResultSet).%New("web.DHCST.LocItmStkQtyWarn:LocItmQtyDspWarn")
 s sc=result.Execute(qPar,Loc,StartDate,EndDate,StkSupportDays,IncludeNotUseFlag,User)
 i $$$ISERR(sc) q ##class(web.DHCSTEXTCOMMON).GetNoJson() 
 d ##class(web.DHCST.Common.Display).RSToJson(result,Sort,Dir,Start,Limit)
 Q ""
ErrorjsLocItmQtyDspWarn
 s Error=$$Error^DHCSTERROR()
 q "{Error:'"_Error_"'}"
}

/// 检索科室内库存不足以满足库存支持天数的销售之库存项目
/// Author:zhwh
/// Date:2012-07-26
/// Argu:
///  Loc a - 科室RowId，
///  StartDate - 参考起始日期，
///  EndDate   - 参考截止日期，
///  StkSupportDays  -库存保持天数
///  IncludeNotUseFlag - 包含"不可用"
///  d ##Class(%ResultSet).RunQuery("web.DHCST.LocItmStkQtyWarn","LocItmQtyDspWarn","^","246","2020-06-01","2020-07-01","99999","N",11643)
///  d ##Class(%ResultSet).RunQuery("web.DHCST.LocItmStkQtyWarn","LocItmQtyDspWarn","","246","2020-06-01","2020-07-01","99999","N",11643)
Query LocItmQtyDspWarn(qPar As %String, Loc As %String, StartDate As %String, EndDate As %String, StkSupportDays As %String, IncludeNotUseFlag As %String, User As %String = "") As %Query(ROWSPEC = "incil:%String,inci:%String,code:%String,desc:%String,spec:%String,manf:%String,stkUom:%String,avaQty:%String,oneDspQty:%String,reqQty:%String") [ SqlProc ]
{
}

ClassMethod LocItmQtyDspWarnExecute(ByRef qHandle As %Binary, qPar As %String, Loc As %String, StartDate As %String, EndDate As %String, StkSupportDays As %String, IncludeNotUseFlag As %String, User As %String = "") As %Status
{
	s ^YSJTMP("LocItmQtyDspWarn")=$LB(qPar , Loc , StartDate , EndDate , StkSupportDays , IncludeNotUseFlag , User )
 s repid=$I(^CacheTemp)
 s ind=1
 s qHandle=$lb(0,repid,0)
 
 q:Loc="" $$$OK
 q:StartDate="" $$$OK
 q:EndDate="" $$$OK
 q:StkSupportDays="" $$$OK
 i StartDate'="" s StartDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(StartDate)
 i EndDate'="" s EndDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(EndDate)
 s dspDays=EndDate-StartDate+1

 s Sort=$p(qPar,"^",1)
 s Dir=$p(qPar,"^",2)

 s sql="select incil_inci_parref inci,"
 s sql=sql_"incil_rowid incil,"
 s sql=sql_"incil_inci_parref->inci_code code,"
 s sql=sql_"incil_inci_parref->inci_desc descx,"
 s sql=sql_"incil_availqty avaQty,"
 s sql=sql_"incil_inci_parref->inci_notuseflag NotUseFlag,"
 s sql=sql_"incil_inci_parref->inci_ctuom_purch_dr pUom,"
 s sql=sql_"incil_inci_parref->inci_ctuom_purch_dr->ctuom_desc pUomDesc,"
 s sql=sql_"incil_inci_parref->inci_ctuom_dr bUom,"
 s sql=sql_"incil_inci_parref->inci_ctuom_dr->ctuom_desc bUomDesc"
 s sql=sql_" from inc_itmloc"
 s sql=sql_" where incil_ctloc_dr="_Loc

 s orderFieldName=""
 s Sort=$$ALPHAUP^SSUTIL4(Sort)
 s:Sort="CODE" orderFieldName="code"
 s:Sort="DESC" orderFieldName="descx"
 ;s:Sort="" orderFieldName=""
 s Dir=$$ALPHAUP^SSUTIL4(Dir)
 s:(Dir="")&(Dir'="ASC")&(Dir'="DESC") Dir="DESC"
 i orderFieldName'="" d
 .s sql=sql_" Order By "_orderFieldName_" "_Dir
 s xrs=##class(%ResultSet).%New()
 d xrs.Prepare(sql)
 s sc=xrs.Execute()
 if $$$ISERR(sc) q $$$OK 
  
 //s UserCatGrpStr=##class(web.DHCST.Util.DrugUtil).GetUserCatGrpStrNew(User,..sssCode(),Loc) //用户类组
 while (xrs.Next())
 {
  s NotUseFlag=xrs.Data("NotUseFlag")
  i IncludeNotUseFlag'="Y" continue:NotUseFlag="Y"  //不可用的滤除
  s incil=xrs.Data("incil")
  s inci=xrs.Data("inci")
  //
  /*
  s grpInfo=##class(web.DHCST.Common.DrugInfoCommon).GetIncStkCatGrp(inci)
  s grpType=$P(grpInfo,"^",3)
  continue:grpType'=..sssCode()
  s scg=$P(grpInfo,"^",5)
  continue:(scg'="")&(("^"_UserCatGrpStr_"^")'[("^"_scg_"^"))   //去掉过滤。界面上类组下拉框，后台过滤会导致各个用户看到的类组不一致
  */
  s avaQty=xrs.Data("avaQty")
  i avaQty<0 s avaQty=0 //yunhaibao20160225,理论上不存在负数,置为0
  s dspQty=##class(web.DHCST.INRequestAuxByConsume).TotalItmDisp(incil,StartDate,EndDate) //消耗总数
  s oneDspQty=(-dspQty)/dspDays
  s reqQty=oneDspQty*StkSupportDays  //平均消耗*天数
  continue:reqQty'>0
  continue:avaQty>reqQty  
  s code=xrs.Data("code")
  s desc=xrs.Data("descx")
  s bUom=xrs.Data("bUom")
  s pUom=xrs.Data("pUom")
  s pUomDesc=xrs.Data("pUomDesc")
  s fac=##class(web.DHCST.Common.UtilCommon).UOMFac(pUom,bUom)
  s stkUom=pUomDesc
  s avaQty=avaQty/fac
  s oneDspQty=oneDspQty/fac
  s reqQty=reqQty/fac
  s spec=##class(web.DHCST.Common.DrugInfoCommon).GetSpec("",inci)
  s manf=$P(##class(web.DHCST.Common.DrugInfoCommon).GetManf(inci),"^",3)   
  s hospid=$p(^CTLOC(Loc),"^",22)
  s StkType = "G" 
  s avaQty=##class(web.DHCST.Common.AppCommon).FormatSq(avaQty,hospid,1,StkType)
  s oneDspQty=##class(web.DHCST.Common.AppCommon).FormatSq(oneDspQty,hospid,1,StkType)
  s reqQty=##class(web.DHCST.Common.AppCommon).FormatSq(reqQty,hospid,1,StkType)
  d OutPutRow2
 }
 Quit $$$OK
OutPutRow2
 s Data=$lb(incil,inci,code,desc,spec,manf,stkUom,avaQty,oneDspQty,reqQty)   
 s ^CacheTemp(repid,ind)=Data
 s ind=ind+1
 q
}

ClassMethod LocItmQtyDspWarnClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = LocItmQtyDspWarnExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod LocItmQtyDspWarnFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = LocItmQtyDspWarnExecute ]
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

ClassMethod NewPid()
{
	q $i(^DHCST("DHCST.LocItmStkQtyWarn"))
}

}
