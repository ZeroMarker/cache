Class web.DHCSTMHUI.LocItmStkQtyWarn Extends (%RegisteredObject, %XML.Adaptor, StkTypeM)
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
///   项目列表串(json)
ClassMethod jsLocItmStkQtyLimitWarn(page As %String, rows As %String, Sort As %String = "", Dir As %String = "", StrPar As %String, User As %String = "") As %String
{
 s Start=(page-1)*rows
 s Limit=rows
 s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
 d PJObj.%FromJSON(StrPar)
 s Loc=PJObj.%Get("PhaLoc")
 s SCG=PJObj.%Get("StkGrpId")
 s pHospId=..sssHospId(Loc)
 s SCG=##class(web.DHCSTMHUI.Util.DrugUtil).GetUserCatGrpStr(User,..sssCode(),Loc,SCG,pHospId)  //用户类组串
 s StkBin=PJObj.%Get("StkBin")
 s INCSC=PJObj.%Get("StkCat")
 s IncludeNotUseFlag=PJObj.%Get("UseFlag")
 s result=##class(%Library.ResultSet).%New("web.DHCSTMHUI.LocItmStkQtyWarn:LocItmStkQtyLimitWarn")
 s sc=result.Execute(Loc,SCG,INCSC,StkBin,IncludeNotUseFlag)
 i $$$ISERR(sc) q ""
 
 s colNum=result.GetColumnCount()
 s colNameStr=""
 f i=1:1:colNum d
 .i colNameStr="" s colNameStr=result.GetColumnName(i)
 .e  s colNameStr=colNameStr_"^"_result.GetColumnName(i)

 s count = 0
 s end = Start+Limit
 s json = ##class(web.DHCSTMHUI.Common.JsonObj).%New()
 While(result.Next())
 { 
  s ret=""
  f i=1:1:colNum d
  .i ret="" s ret=result.%GetData(i)
  .e   s ret=ret_"^"_result.%GetData(i)
  .
  s tmp=ret
  s count = count+1
  CONTINUE:count<(Start+1)
  CONTINUE:count>end            
  d json.InsertRowData(tmp)
 }
 d result.Close()
 d json.getJsonData(colNameStr,count)
 k json
 Q ""
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
///  
Query LocItmStkQtyLimitWarn(Loc As %String, SCG As %String, INCSC As %String, StkBin As %String, IncludeNotUseFlag As %String) As Query(ROWSPEC = "incil,inci,InciCode,InciDesc,Spec,Manf,MaxQty:%Float,MinQty:%Float,RepQty:%Float,AvaQty:%Float,IncscDesc,StkUom")
{
}

ClassMethod LocItmStkQtyLimitWarnExecute(ByRef qHandle As %Binary, Loc As %String, SCG As %String, INCSC As %String, StkBin As %String, IncludeNotUseFlag As %String) As %Status
{
 s repid=$I(^CacheTemp)
 s ind=1
 s qHandle=$lb(0,repid,0)
 
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

 i StkBin'="" d
 .s sql=sql_" and INCIL_INCSB_DR="_StkBin
 
 s xrs=##class(%ResultSet).%New()
 d xrs.RuntimeModeSet(0)
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
  s incil=xrs.Data("incil")
  s inci=xrs.Data("inci")
  s ScgGrpInfo=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncStkCatGrp(inci)
  s ScgType=$p(ScgGrpInfo,"^",3)
  continue:ScgType'=..sssCode()
  s scg=$P(ScgGrpInfo,"^",5) 
  i SCG'="" continue:("^"_SCG_"^")'[("^"_scg_"^")  //zhwh 2013-07-17
  s code=xrs.Data("code")
  s desc=xrs.Data("descx")
  s incscDesc=xrs.Data("incscDesc")
  s bUom=xrs.Data("bUom")
  s pUom=xrs.Data("pUom")
  s pUomDesc=xrs.Data("pUomDesc")
  s fac=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(pUom,bUom)
  s stkUom=pUomDesc
  
  s maxQty=maxQty/fac
  s minQty=minQty/fac
  s repQty=repQty/fac
  s avaQty=avaQty/fac
  s spec=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetSpec("",inci)
  s manf=$P(##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetManf(inci),"^",3)
  d OutPutRow1
 }
 Quit $$$OK
OutPutRow1
  s Data=$lb(incil,inci,code,desc,spec,manf,maxQty,minQty,repQty,avaQty,incscDesc,stkUom)   
 s ^CacheTemp(repid,ind)=Data
 s ind=ind+1
 q
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
/// w ##class(web.DHCSTMHUI.LocItmStkQtyWarn).jsLocItmQtyDspWarn(1,15,"","","{""PhaLoc"":""197"",""gUserId"":""6444"",""gLocId"":""392"",""gGroupId"":""264"",""gHospId"":""2"",""StartDate"":""29/01/2019"",""EndDate"":""30/01/2019"",""DispQtyFlag"":""Y"",""NotUseFlag"":"""",""UseDays"":""1""}","")
ClassMethod jsLocItmQtyDspWarn(page As %String, rows As %String, Sort As %String = "", Dir As %String = "", StrPar As %String, User As %String = "") As %String
{
 s Start=(page-1)*rows
 s Limit=rows
 s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
 d PJObj.%FromJSON(StrPar)
 s Loc=PJObj.%Get("PhaLoc")
 s StartDate=PJObj.%Get("StartDate")
 s EndDate=PJObj.%Get("EndDate")
 s StkSupportDays=PJObj.%Get("UseDays")
 s IncludeNotUseFlag=PJObj.%Get("NotUseFlag")
 s DispQtyFlag=PJObj.%Get("DispQtyFlag")
 s result=##class(%Library.ResultSet).%New("web.DHCSTMHUI.LocItmStkQtyWarn:LocItmQtyDspWarn")
 s sc=result.Execute(Loc,StartDate,EndDate,StkSupportDays,IncludeNotUseFlag,User,DispQtyFlag)
 i $$$ISERR(sc) q ""
 ;b
 s colNum=result.GetColumnCount()
 s colNameStr=""
 f i=1:1:colNum d
 .i colNameStr="" s colNameStr=result.GetColumnName(i)
 .e  s colNameStr=colNameStr_"^"_result.GetColumnName(i)

 s count = 0
 s end = Start+Limit
 s json = ##class(web.DHCSTMHUI.Common.JsonObj).%New()
 While(result.Next())
 { 
  s ret=""
  f i=1:1:colNum d
  .i ret="" s ret=result.%GetData(i)
  .e   s ret=ret_"^"_result.%GetData(i)
  .
  s tmp=ret
  s count = count+1
  CONTINUE:count<(Start+1)
  CONTINUE:count>end            
  d json.InsertRowData(tmp)
 }
 d result.Close()
 d json.getJsonData(colNameStr,count)
 k json
 Q ""
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
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.LocItmStkQtyWarn","LocItmQtyDspWarn","^",197,"2019-01-29","2019-01-29",30,"Y",541)
Query LocItmQtyDspWarn(Loc As %String, StartDate As %String, EndDate As %String, StkSupportDays As %String, IncludeNotUseFlag As %String, User As %String = "", DispQtyFlag = "") As Query(ROWSPEC = "incil,inci,InciCode,InciDesc,Spec,Manf,StkUom,AvaQty:%Float,OneDspQty:%Float,ReqQty:%Float")
{
}

ClassMethod LocItmQtyDspWarnExecute(ByRef qHandle As %Binary, Loc As %String, StartDate As %String, EndDate As %String, StkSupportDays As %String, IncludeNotUseFlag As %String, User As %String = "", DispQtyFlag = "") As %Status
{
 s repid=$I(^CacheTemp)
 s ind=1
 s qHandle=$lb(0,repid,0)
 
 q:Loc="" $$$OK
 q:StartDate="" $$$OK
 q:EndDate="" $$$OK
 q:StkSupportDays="" $$$OK
 s:StartDate'="" StartDate=..DH2L(StartDate)
 s:EndDate'="" EndDate=..DH2L(EndDate)
 s dspDays=EndDate-StartDate+1

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

 s xrs=##class(%ResultSet).%New()
 d xrs.RuntimeModeSet(0)
 d xrs.Prepare(sql)
 s sc=xrs.Execute()
 if $$$ISERR(sc) q $$$OK 
 s pHospId=..sssHospId(Loc)
 s UserCatGrpStr=##class(web.DHCSTMHUI.Util.DrugUtil).GetUserCatGrpStr(User,..sssCode(),Loc,"",pHospId) //用户类组
 while (xrs.Next())
 {
  s NotUseFlag=xrs.Data("NotUseFlag")
  i IncludeNotUseFlag'="Y" continue:NotUseFlag="Y"  //不可用的滤除
  s incil=xrs.Data("incil")
  s inci=xrs.Data("inci")
  s grpInfo=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncStkCatGrp(inci)
  s grpType=$P(grpInfo,"^",3)
  continue:grpType'=..sssCode()
  s scg=$P(grpInfo,"^",5)
  continue:(scg'="")&(("^"_UserCatGrpStr_"^")'[("^"_scg_"^"))
  s avaQty=xrs.Data("avaQty")
  s dspQty=##class(web.DHCSTMHUI.INRequestAuxByConsume).TotalItmDisp(incil,StartDate,EndDate)
  continue:(DispQtyFlag="Y")&&(dspQty'<0)
  s oneDspQty=(-dspQty)/dspDays
  s reqQty=oneDspQty*StkSupportDays  //库存持有量
  ;continue:reqQty'>0
  ;continue:avaQty>reqQty
  
  s code=xrs.Data("code")
  s desc=xrs.Data("descx")
  s bUom=xrs.Data("bUom")
  s pUom=xrs.Data("pUom")
  s pUomDesc=xrs.Data("pUomDesc")
  s fac=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(pUom,bUom)
  s stkUom=pUomDesc
  s avaQty=avaQty/fac
  s spec=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetSpec(code,inci)
  s manf=$P(##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetManf(inci),"^",3)   
  d OutPutRow2
 }
 Quit $$$OK
OutPutRow2
 s Data=$lb(incil,inci,code,desc,spec,manf,stkUom,avaQty,oneDspQty,reqQty)   
 s ^CacheTemp(repid,ind)=Data
 s ind=ind+1
 q
}

}
