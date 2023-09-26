/// Descript:调价损益查询及统计
/// Creater:    ZhangDongmei
/// CreateDate: 2013-01-08
Class web.DHCSTMHUI.AspAmount Extends (%RegisteredObject, StkTypeM) [ Not ProcedureBlock ]
{

/// Descript:查询一段时间内的调价损益明细
/// Creater:    Zhangxiao
/// CreateDate: 2018-06-15
/// Table:dhc_aspamount
/// Input:开始行,一页显示记录条数,开始日期,截止日期,
/// 科室id^调价单号^调价原因id^金额类型（1:差额为正，-1:差额为负,0:全部）^库存项id^标志(1:ext调用，其他：润乾调用)
/// Output:     
/// Return：调价损益信息
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.AspAmount","QueryAspAmount","{""StartDate"":""2020-09-08"",""gUserId"":""6423"",""gLocId"":""392"",""gGroupId"":""97"",""gHospId"":""2"",""Loc"":""392"",""ScgId"":"""",""OptType"":""1"",""EndDate"":""2020-09-08"",""InciDesc"":"""",""AdjspNo"":""""}")
Query QueryAspAmount(Params As %String) As Query(ROWSPEC = "RowId,IncId,InciCode,InciDesc,Spec,ExecuteDate,AspUom,StkQty,PriorSp:%Float,ResultSp:%Float,DiffSp:%Float,PriorRp:%Float,ResultRp:%Float,DiffRp:%Float,SpAmt:%Float,RpAmt:%Float,AspReason,AspUser,AuditUser,AspDate,WarrentNo,LocDesc,PurStkQty:%Float,PUomDesc") [ SqlProc ]
{
}

ClassMethod QueryAspAmountExecute(ByRef qHandle As %Binary, Params As %String) As %Status
{
    n (qHandle, Params)
    s repid=$I(^CacheTemp)
    s ind=1
    s qHandle=$lb(0,repid,0)
    ;s ^Tmpxu=Params
    s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	d PJObj.%FromJSON(Params)
	s pStartDate=PJObj.%Get("StartDate")		//开始日期
	s pEndDate=PJObj.%Get("EndDate")		//截止日期
	
    q:pStartDate="" $$$OK
    q:pEndDate="" $$$OK
    s pAdjLocId=PJObj.%Get("Loc")
    s PAdjNo=PJObj.%Get("AdjspNo")
    s AdjReasonId=PJObj.%Get("AdjReasonId")
    s pOptType=PJObj.%Get("OptType")
    s PInci=PJObj.%Get("Inci")
    s Flag=PJObj.%Get("Flag")
    s pItmDesc=PJObj.%Get("InciDesc")
    s pAdjReasonId=PJObj.%Get("AdjReasonId")
    s pStkScgId=PJObj.%Get("ScgId")
    s:pStartDate'="" pStartDate=..DH2L(pStartDate)
	s:pEndDate'="" pEndDate=..DH2L(pEndDate)
	s gUserId=PJObj.%Get("gUserId")
	s gLocId=PJObj.%Get("gLocId")
	s gHospId=PJObj.%Get("gHospId")
	s pHospId=..sssHospId(gLocId)
	s:pHospId="" pHospId=gHospId
    s pStkScgId=##class(web.DHCSTMHUI.Util.DrugUtil).GetUserCatGrpStr(gUserId,..sssCode(),gLocId,pStkScgId,pHospId)
    s sql="select ASPA_Rowid AspaId,"
    s sql=sql_"ASPA_No AspNo,"
    s sql=sql_"ASPA_CTLOC_DR LocId,"
    s sql=sql_"ASPA_CTLOC_DR->ctloc_desc LocDesc,"
    s sql=sql_"ASPA_AdjPrice DiffSp,"
    s sql=sql_"ASPA_INASP_DR AspId,"
    s sql=sql_"ASPA_INCI_DR IncId,"
    s sql=sql_"ASPA_INCI_DR->inci_code InciCode,"
    s sql=sql_"ASPA_INCI_DR->inci_desc InciDesc,"
    s sql=sql_"ASPA_StkQty StkQty,"
    s sql=sql_"ASPA_Amount SpAmt,"
    s sql=sql_"ASPA_Date AspaDate,"
    s sql=sql_"ASPA_AdjRP DiffRp,"
    s sql=sql_"ASPA_INASP_DR->INASP_CTUOM_DR AspUomId,"
    s sql=sql_"ASPA_INASP_DR->INASP_CTUOM_DR->ctuom_desc AspUom,"
    s sql=sql_"ASPA_RPAmt RpAmt"
    s sql=sql_" from dhc_aspamount"
    i Flag=1  d
    .s sql=sql_" where ASPA_Date between "_pStartDate_" and "_pEndDate
    e  d
    .s sql=sql_" where ASPA_Date between '"_pStartDate_"' and '"_pEndDate_"'"
    s xrs=##class(%Library.ResultSet).%New()
    s xrs.RuntimeMode=0
    d xrs.Prepare(sql)
    s sc=xrs.Execute()
    i $$$ISERR(sc) q $$$OK
    s count=0
    while (xrs.Next())
    {
        s AspaId=xrs.Data("AspaId") 
        s AspNo=xrs.Data("AspNo")
        continue:(PAdjNo'="")&(AspNo'=PAdjNo)
        s LocId=xrs.Data("LocId")
        continue:(pAdjLocId'="")&(LocId'=pAdjLocId)
        s LocDesc=xrs.Data("LocDesc")
        s LocDesc=##class(web.DHCSTMHUI.Util.DrugUtil).GetLocDesc(LocDesc)
        s DiffSp=xrs.Data("DiffSp")  
        continue:(pOptType=2)&(DiffSp<=0)   ;只统计差额为正
        continue:(pOptType=3)&(DiffSp>=0)   ;只统计差额为负
        s AspId=xrs.Data("AspId")
        continue:AspId=""
        s AspReasonId=$p(^INASP(AspId),"^",28)
        s AspReason=""
        s:AspReasonId'="" AspReason=$p(^DHCSTREASON("ASP",AspReasonId),"^",2) 
        continue:(pAdjReasonId'="")&(AspReasonId'=pAdjReasonId)
        s IncId=xrs.Data("IncId")  
        continue:(PInci'="")&(IncId'=PInci)
        s scgInfo=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncStkCatGrp(IncId)
        s stkType=$p(scgInfo,"^",3)
        continue:stkType'=..sssCode()
        s StkGrpId=$p(scgInfo,"^",5)
        Continue:(pStkScgId'="")&&(("^"_pStkScgId_"^")'[("^"_StkGrpId_"^"))
        s InciCode=xrs.Data("InciCode")
        s InciDesc=xrs.Data("InciDesc")
        continue:(pItmDesc'="")&(InciDesc'[pItmDesc)
        s StkQty=xrs.Data("StkQty")
        s SpAmt=xrs.Data("SpAmt")    //差额(售价)
        s AspaDate=xrs.Data("AspaDate")
        s:(AspaDate'="")&&(Flag=1) AspaDate=..DL2H(AspaDate)
        s DiffRp=xrs.Data("DiffRp")
        s RpAmt=xrs.Data("RpAmt")   //差额(进价)
        s Spec=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetSpec("",IncId)
        s ExecuteDate=$p(^INASP(AspId),"^",2)
        s:ExecuteDate'="" ExecuteDate=..DL2H(ExecuteDate)
        s AspUomId=xrs.Data("AspUomId")
        s AspUom=xrs.Data("AspUom")
        s PUomId=$p(^INCI(IncId,3),"^",6)
        s PUomDesc=$p(^CT("UOM",PUomId),"^",2)
        s BUomId=$p(^INCI(IncId,1),"^",10)
        s ConFac=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(AspUomId,BUomId)
        s PriorRp=$p(^INASP(AspId),"^",15)     ;基本单位对应的调前进价
        s ResultRp=$p(^INASP(AspId),"^",16)     ;基本单位对应的调后进价
        s PriorSp=$p(^INASP(AspId),"^",6)      ;基本单位对应的调前售价
        s ResultSp=$p(^INASP(AspId),"^",7)      ;基本单位对应的调后售价
        s PriorRp=PriorRp*ConFac
        s ResultRp=ResultRp*ConFac
        s PriorSp=PriorSp*ConFac
        s ResultSp=ResultSp*ConFac
        s DiffSp=DiffSp*ConFac
        s DiffRp=DiffRp*ConFac
        s UomFac=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(PUomId,BUomId)
        s PurStkQty=StkQty/UomFac
        s StkQty=##class(web.DHCSTMHUI.Common.DrugStkCommon).QtyWithUom(IncId,StkQty)
        s AdjUserId=$p(^INASP(AspId),"^",3)
        s:AdjUserId'="" AdjUserName=$p(^SSU("SSUSR",AdjUserId),"^",2)
        s AuditUserId=$p(^INASP(AspId),"^",21) 
        s:AuditUserId'="" AuditUserName=$p(^SSU("SSUSR",AuditUserId),"^",2)
        s WarrentNo=$p(^INASP(AspId),"^",12)    ;物价文件号
        d OutPutRow1
    }
    q $$$OK

OutPutRow1
    s Data=$lb(AspaId,IncId,InciCode,InciDesc,Spec,ExecuteDate,AspUom,StkQty,PriorSp,ResultSp,DiffSp,PriorRp,ResultRp,DiffRp,SpAmt,RpAmt,AspReason,AdjUserName,AuditUserName,AspaDate,WarrentNo,LocDesc,PurStkQty,PUomDesc)
    s ^CacheTemp(repid,ind)=Data
    s ind=ind+1
    q
}

/// Descript:	调价损益汇总
/// Creator:	lxt
/// CreateDate:	2018-09-11
/// Table:		dhc_aspamount
/// Input:		排序，查询条件
/// Return：	调价损益汇总
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.AspAmount","QueryAsp","{""Loc"":""153"",""gUserId"":""873"",""gLocId"":""153"",""gGroupId"":""98"",""gHospId"":""2"",""StartDate"":""21/09/2016"",""EndDate"":""21/09/2018"",""Vendor"":"""",""OptType"":""0"",""Inci"":"""",""InciDesc"":"""",""AdjspNo"":""""}")
Query QueryAsp(Params As %Text) As Query(ROWSPEC = "RowId,IncId,InciCode,InciDesc,Spec,ExecuteDate,AspUom,StkQty,PriorSp:%Float,ResultSp:%Float,DiffSp:%Float,PriorRp:%Float,ResultRp:%Float,DiffRp:%Float,SpAmt:%Float,RpAmt:%Float,AspReason,AspUser,AuditUser,AspDate,WarrentNo,LocDesc,PurStkQty:%Float,PUomDesc") [ SqlProc ]
{
}

ClassMethod QueryAspExecute(ByRef qHandle As %Binary, Params As %Text) As %Status
{
    n (qHandle,Params)
    s repid=$I(^CacheTemp)
    s ind=1
    s qHandle=$lb(0,repid,0)
    
    s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	d PJObj.%FromJSON(Params)
	s pStartDate=PJObj.%Get("StartDate")		//开始日期
	s pEndDate=PJObj.%Get("EndDate")		//截止日期
	
    q:pStartDate="" $$$OK
    q:pEndDate="" $$$OK
    s pAdjLocId=PJObj.%Get("Loc")
    s PAdjNo=PJObj.%Get("AdjspNo")
    s AdjReasonId=PJObj.%Get("AdjReasonId")
    s pOptType=PJObj.%Get("OptType")
    s PInci=PJObj.%Get("Inci")
    s Flag=PJObj.%Get("Flag")
    s pItmDesc=PJObj.%Get("InciDesc")
    s pAdjReasonId=PJObj.%Get("AdjReasonId")
    
    s:pStartDate'="" pStartDate=..DH2L(pStartDate)
	s:pEndDate'="" pEndDate=..DH2L(pEndDate)

    s sql="select ASPA_Rowid AspaId,"
    s sql=sql_"ASPA_No AspNo,"
    s sql=sql_"ASPA_CTLOC_DR LocId,"
    s sql=sql_"ASPA_CTLOC_DR->ctloc_desc LocDesc,"
    s sql=sql_"ASPA_AdjPrice DiffSp,"
    s sql=sql_"ASPA_INASP_DR AspId,"
    s sql=sql_"ASPA_INCI_DR IncId,"
    s sql=sql_"ASPA_INCI_DR->inci_code InciCode,"
    s sql=sql_"ASPA_INCI_DR->inci_desc InciDesc,"
    s sql=sql_"ASPA_StkQty StkQty,"
    s sql=sql_"ASPA_Amount SpAmt,"
    s sql=sql_"ASPA_Date AspaDate,"
    s sql=sql_"ASPA_AdjRP DiffRp,"
    s sql=sql_"ASPA_INASP_DR->INASP_CTUOM_DR AspUomId,"
    s sql=sql_"ASPA_INASP_DR->INASP_CTUOM_DR->ctuom_desc AspUom,"
    s sql=sql_"ASPA_RPAmt RpAmt"
    s sql=sql_" from dhc_aspamount"
    i Flag=1  d
    .s sql=sql_" where ASPA_Date between "_pStartDate_" and "_pEndDate
    e  d
    .s sql=sql_" where ASPA_Date between '"_pStartDate_"' and '"_pEndDate_"'"
    s xrs=##class(%Library.ResultSet).%New()
    s xrs.RuntimeMode=0
    d xrs.Prepare(sql)
    s sc=xrs.Execute()
    i $$$ISERR(sc) q $$$OK
    s count=0
    while (xrs.Next())
    {
        s AspaId=xrs.Data("AspaId") 
        s AspNo=xrs.Data("AspNo")
        continue:(PAdjNo'="")&(AspNo'=PAdjNo)
        s LocId=xrs.Data("LocId")
        continue:(pAdjLocId'="")&(LocId'=pAdjLocId)
        s LocDesc=xrs.Data("LocDesc")
        s LocDesc=##class(web.DHCSTMHUI.Util.DrugUtil).GetLocDesc(LocDesc)
        s DiffSp=xrs.Data("DiffSp")  
        continue:(pOptType=1)&(DiffSp<=0)   ;只统计差额为正
        continue:(pOptType=-1)&(DiffSp>=0)   ;只统计差额为负
        s AspId=xrs.Data("AspId")
        continue:AspId=""
        s AspReasonId=$p(^INASP(AspId),"^",28)
        s AspReason=""
        s:AspReasonId'="" AspReason=$p(^DHCSTREASON("ASP",AspReasonId),"^",2) 
        continue:(pAdjReasonId'="")&(AspReasonId'=pAdjReasonId)
        s IncId=xrs.Data("IncId")  
        continue:(PInci'="")&(IncId'=PInci)
        s scgInfo=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncStkCatGrp(IncId)
        s stkType=$p(scgInfo,"^",3)
        continue:stkType'=..sssCode()
        s InciCode=xrs.Data("InciCode")
        s InciDesc=xrs.Data("InciDesc")
        continue:(pItmDesc'="")&(InciDesc'[pItmDesc)
        s StkQty=xrs.Data("StkQty")
        s SpAmt=xrs.Data("SpAmt")    //差额(售价)
        s AspaDate=xrs.Data("AspaDate")
        s:(AspaDate'="")&&(Flag=1) AspaDate=..DL2H(AspaDate)
        s DiffRp=xrs.Data("DiffRp")
        s RpAmt=xrs.Data("RpAmt")   //差额(进价)
        s Spec=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetSpec("",IncId)
        s ExecuteDate=$p(^INASP(AspId),"^",2)
        s:ExecuteDate'="" ExecuteDate=..DL2H(ExecuteDate)
        s AspUomId=xrs.Data("AspUomId")
        s AspUom=xrs.Data("AspUom")
        s PUomId=$p(^INCI(IncId,3),"^",6)
        s PUomDesc=$p(^CT("UOM",PUomId),"^",2)
        s BUomId=$p(^INCI(IncId,1),"^",10)
        s ConFac=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(AspUomId,BUomId)
        s PriorRp=$p(^INASP(AspId),"^",15)     ;基本单位对应的调前进价
        s ResultRp=$p(^INASP(AspId),"^",16)     ;基本单位对应的调后进价
        s PriorSp=$p(^INASP(AspId),"^",6)      ;基本单位对应的调前售价
        s ResultSp=$p(^INASP(AspId),"^",7)      ;基本单位对应的调后售价
        s PriorRp=PriorRp*ConFac
        s ResultRp=ResultRp*ConFac
        s PriorSp=PriorSp*ConFac
        s ResultSp=ResultSp*ConFac
        s DiffSp=DiffSp*ConFac
        s DiffRp=DiffRp*ConFac
        s UomFac=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(PUomId,BUomId)
        s PurStkQty=StkQty/UomFac
        s StkQty=##class(web.DHCSTMHUI.Common.DrugStkCommon).QtyWithUom(IncId,StkQty)
        s AdjUserId=$p(^INASP(AspId),"^",3)
        s:AdjUserId'="" AdjUserName=$p(^SSU("SSUSR",AdjUserId),"^",2)
        s AuditUserId=$p(^INASP(AspId),"^",21) 
        s:AuditUserId'="" AuditUserName=$p(^SSU("SSUSR",AuditUserId),"^",2)
        s WarrentNo=$p(^INASP(AspId),"^",12)    ;物价文件号
        d OutPutRowAsp
    }
    q $$$OK

OutPutRowAsp
    s Data=$lb(AspaId,IncId,InciCode,InciDesc,Spec,ExecuteDate,AspUom,StkQty,PriorSp,ResultSp,DiffSp,PriorRp,ResultRp,DiffRp,SpAmt,RpAmt,AspReason,AdjUserName,AuditUserName,AspaDate,WarrentNo,LocDesc,PurStkQty,PUomDesc)
    s ^CacheTemp(repid,ind)=Data
    s ind=ind+1
    q
}

/// Descript:	调价损益汇总
/// Creator:	lxt
/// CreateDate:	2018-09-11
/// Table:		dhc_aspamount
/// Input:		排序，查询条件
/// Return：	调价损益汇总
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.AspAmount","QueryAspAmountLB","{""Loc"":""153"",""gUserId"":""873"",""gLocId"":""153"",""gGroupId"":""98"",""gHospId"":""2"",""StartDate"":""21/09/2016"",""EndDate"":""21/09/2018"",""Vendor"":"""",""OptType"":""0"",""Inci"":"""",""InciDesc"":"""",""AdjspNo"":""""}")
Query QueryAspAmountLB(Params As %Text) As Query(ROWSPEC = "AspalbId,IncId,IncCode,IncDesc,Spec,ExecuteDate,AspUom,Qty:%Float,PriorSp:%Float,ResultSp:%Float,DiffSp:%Float,PriorRp:%Float,ResultRp:%Float,DiffRp:%Float,SpAmt:%Float,RpAmt:%Float,AspReason,AspUser,AuditUser,AspDate,WarrentNo,LocDesc,AspNo,VendorId,VendorDesc") [ SqlProc ]
{
}

ClassMethod QueryAspAmountLBExecute(ByRef qHandle As %Binary, Params As %Text) As %Status
{
   	n (qHandle,Params)
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
	
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	d PJObj.%FromJSON(Params)
	s StartDate=PJObj.%Get("StartDate")
	s EndDate=PJObj.%Get("EndDate")
	q:StartDate="" ""
	q:EndDate="" ""
	
    s AdjLocId=PJObj.%Get("Loc")
    s AdjNo=PJObj.%Get("AdjspNo")
    s AdjReasonId=PJObj.%Get("AdjReasonId")
    s DiffType=PJObj.%Get("OptType")
    s ItmId=PJObj.%Get("Inci")
    s VenId=PJObj.%Get("Vendor")
    s ItmDesc=PJObj.%Get("InciDesc")
    s:StartDate'="" StartDate=..DH2L(StartDate)
	s:EndDate'="" EndDate=..DH2L(EndDate)
    
    f date=StartDate:1:EndDate  d
    .i ItmId'=""  d
    ..i AdjLocId'=""  d
    ...s Aspa=0
    ...f  s Aspa=$o(^ASPA(0,"DATEINCIL",date,ItmId,AdjLocId,Aspa)) q:Aspa=""  d
    ....d GetDetail(Aspa)
    ..e   d
    ...s Loc=0
    ...f  s Loc=$o(^ASPA(0,"DATEINCIL",date,ItmId,Loc)) q:Loc=""  d
    ....s Aspa=0
    ....f  s Aspa=$o(^ASPA(0,"DATEINCIL",date,ItmId,Loc,Aspa)) q:Aspa=""  d
    .....d GetDetail(Aspa)
    ....
    ...
    ..
    .e   d
    ..s Inc=0
    ..f  s Inc=$o(^ASPA(0,"DATEINCIL",date,Inc))  q:Inc=""  d
    ...s Loc=0
    ...f  s Loc=$o(^ASPA(0,"DATEINCIL",date,Inc,Loc)) q:Loc=""  d
    ....s Aspa=0
    ....f  s Aspa=$o(^ASPA(0,"DATEINCIL",date,Inc,Loc,Aspa)) q:Aspa=""  d
    .....d GetDetail(Aspa)
    ....
    ...
    ..
    .
    q $$$OK
GetDetail(AspaId)
  s chl=0
  f  s chl=$o(^ASPA(AspaId,"LB",chl))  q:chl=""  d
  .s AspalbId=AspaId_"||"_chl
  .s Inclb=$p(^ASPA(AspaId,"LB",chl),"^",1)
  .s Qty=$p(^ASPA(AspaId,"LB",chl),"^",2)
  .s DiffSp=$p(^ASPA(AspaId,"LB",chl),"^",3)
  .s SpAmt=$p(^ASPA(AspaId,"LB",chl),"^",4)
  .s DiffRp=$p(^ASPA(AspaId,"LB",chl),"^",5)
  .s RpAmt=$p(^ASPA(AspaId,"LB",chl),"^",6)
  .s PriorRp=$p(^ASPA(AspaId,"LB",chl),"^",7)
  .s AspId=$p(^ASPA(AspaId),"^",10)
  .q:AspId=""
  .s LocId=$p(^ASPA(AspaId),"^",2)
  .s AspNo=$p(^ASPA(AspaId),"^",6)
  .s AspaDate=$p(^ASPA(AspaId),"^",8)
  .q:(AdjNo'="")&(AspNo'=AdjNo)
  .q:(AdjLocId'="")&(LocId'=AdjLocId)
  .q:(DiffType=1)&(DiffSp<0)   ;只统计差额为正
  .q:(DiffType=-1)&(DiffSp>0)   ;只统计差额为负
  .s IncId=+Inclb
  .q:(ItmId'="")&(IncId'=ItmId)
  .s scgInfo=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncStkCatGrp(IncId)
  .s stkType=$p(scgInfo,"^",3)
  .q:(stkType'="")&(stkType'=..sssCode())
  .s AspReasonId=$p(^INASP(AspId),"^",28)
  .s:AspReasonId'="" AspReason=$p(^DHCSTREASON("ASP",AspReasonId),"^",2) 
  .q:(AdjReasonId'="")&(AspReasonId'=AdjReasonId)
  .s VendorInfo=##class(web.DHCSTMHUI.Common.DrugStkCommon).GetvendorInfoByInclb(Inclb,AspaDate)
  .s VendorId=$p(VendorInfo,"^",1)
  .s VendorDesc=$p(VendorInfo,"^",2)
  .q:(VenId'="")&(VendorId'=VenId)
  .s LocDesc=$p(^CTLOC(LocId),"^",2)
  .s:AspaDate'="" AspaDate=..DL2H(AspaDate)
  .s IncCode=$p(^INCI(IncId,1),"^",1)
  .s IncDesc=$p(^INCI(IncId,1),"^",2)
  .q:(ItmDesc'="")&(IncDesc'[ItmDesc)
  .s Spec=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetSpec("",IncId)
  .s ExecuteDate=$p(^INASP(AspId),"^",2)
  .s:ExecuteDate'="" ExecuteDate=..DL2H(ExecuteDate)
  .s AspUomId=$p(^INASP(AspId),"^",10)
  .s:AspUomId'="" AspUom=$p(^CT("UOM",AspUomId),"^",2)
  .s BUomId=$p(^INCI(IncId,1),"^",10)
  .s ConFac=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(AspUomId,BUomId)
  .s ResultRp=$p(^INASP(AspId),"^",16)      ;基本单位对应的调后进价
  .s PriorSp=$p(^INASP(AspId),"^",6)      ;基本单位对应的调前售价
  .s ResultSp=$p(^INASP(AspId),"^",7)       ;基本单位对应的调后售价
  .s PriorRp=PriorRp*ConFac
  .s ResultRp=ResultRp*ConFac
  .s PriorSp=PriorSp*ConFac
  .s ResultSp=ResultSp*ConFac
  .s DiffSp=DiffSp*ConFac
  .s DiffRp=DiffRp*ConFac
  .s Qty=Qty*ConFac
  .s AdjUserId=$p(^INASP(AspId),"^",3)
  .s:AdjUserId'="" AdjUserName=$p(^SSU("SSUSR",AdjUserId),"^",2)
  .s AuditUserId=$p(^INASP(AspId),"^",21) 
  .s:AuditUserId'="" AuditUserName=$p(^SSU("SSUSR",AuditUserId),"^",2)
  .s WarrentNo=$p(^INASP(AspId),"^",12)    ;物价文件号
  .d OutPutRow2
  .
  q
OutPutRow2
    s Data=$lb(AspalbId,IncId,IncCode,IncDesc,Spec,ExecuteDate,AspUom,Qty,PriorSp,ResultSp,DiffSp,PriorRp,ResultRp,DiffRp,SpAmt,RpAmt,AspReason,AdjUserName,AuditUserName,AspaDate,WarrentNo,LocDesc,AspNo,VendorId,VendorDesc)   
    s ^CacheTemp(repid,ind)=Data
    s ind=ind+1
    q
}

/// Descript:查询一段时间内的调价损益明细(批次)
/// Creater:	ZhangDongmei
/// CreateDate:	2013-01-08
/// Table:dhc_aspamount
/// Input:
/// Return：调价损益信息(批次)
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.AspAmount","QueryAspBatAmount","{""Loc"":""153"",""gUserId"":""873"",""gLocId"":""153"",""gGroupId"":""98"",""gHospId"":""2"",""StartDate"":""09/01/2020"",""EndDate"":""09/01/2020"",""OptType"":""1"",""Vendor"":"""",""Inci"":"""",""InciDesc"":"""",""AdjSpNo"":""""}")
Query QueryAspBatAmount(Params As %String(MAXLEN="")) As Query(ROWSPEC = "AspaIdLb,IncId,InciCode,InciDesc,Spec,ExecuteDate,AspUom,StkLbQty:%Float,PriorSp:%Float,ResultSp:%Float,DiffSp:%Float,PriorRp:%Float,ResultRp:%Float,DiffLbRp:%Float,SpLbAmt:%Float,RpLbAmt:%Float,AspReason,AspUser,AuditUser,AspDate,WarrentNo,LocDesc,Incib,BatExp,DiffRp:%Float,VendorDesc") [ SqlProc ]
{
}

ClassMethod QueryAspBatAmountExecute(ByRef qHandle As %Binary, Params As %String) As %Status
{
	n (qHandle,Params)
	;s ^zx("QueryAsp")=Params
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	d PJObj.%FromJSON(Params)
	s pStartDate=PJObj.%Get("StartDate")		//开始日期
	s pEndDate=PJObj.%Get("EndDate")
	
	q:pStartDate="" $$$OK
    q:pEndDate="" $$$OK
    s pid=..NewPid()
	s pAdjLocId=PJObj.%Get("Loc")
	s pAdjNo=PJObj.%Get("AdjspNo")
	s pAdjReasonId=PJObj.%Get("AdjReasonId")
	s pOptType=PJObj.%Get("OptType")
	s pInci=PJObj.%Get("Inci")
	s pItmDesc=PJObj.%Get("InciDesc")
	s pVenId=PJObj.%Get("Vendor")
	s:pStartDate'="" pStartDate=..DH2L(pStartDate)
	s:pEndDate'="" pEndDate=..DH2L(pEndDate)
	
	s sql="select ASPALB_ASPA_Parref AspaId,"
	s sql=sql_"ASPALB_Rowid AspaIdLb,"
	s sql=sql_"ASPALB_ASPA_Parref->ASPA_No AspBatNo,"
	s sql=sql_"ASPALB_ASPA_Parref->ASPA_CTLOC_DR LocId,"
	s sql=sql_"ASPALB_ASPA_Parref->ASPA_CTLOC_DR->ctloc_desc LocDesc,"
	s sql=sql_"ASPALB_ASPA_Parref->ASPA_AdjPrice DiffSp,"
	s sql=sql_"ASPALB_ASPA_Parref->ASPA_INAPB_Dr AspBatId,"
	s sql=sql_"ASPALB_ASPA_Parref->ASPA_INCI_DR IncId,"
	s sql=sql_"ASPALB_ASPA_Parref->ASPA_INCI_DR->inci_code IncCode,"
	s sql=sql_"ASPALB_ASPA_Parref->ASPA_INCI_DR->inci_desc IncDesc,"
	s sql=sql_"ASPALB_ASPA_Parref->ASPA_StkQty StkQty,"
	s sql=sql_"ASPALB_Qty StkLbQty,"
	s sql=sql_"ASPALB_ASPA_Parref->ASPA_Amount SpAmt,"
	s sql=sql_"ASPALB_AdjAmt SpLbAmt,"
	s sql=sql_"ASPALB_ASPA_Parref->ASPA_Date AspaDate,"
	s sql=sql_"ASPALB_ASPA_Parref->ASPA_Time AspaTime,"
	s sql=sql_"ASPALB_ASPA_Parref->ASPA_AdjRP DiffRp,"
	s sql=sql_"ASPALB_AdjRP DiffLbRp,"
	s sql=sql_"ASPALB_ASPA_Parref->ASPA_RPAmt RpAmt,"
	s sql=sql_"ASPALB_RPAmt  RpLbAmt,"
	s sql=sql_"ASPALB_INCLB_DR InciLb"
	s sql=sql_" from DHC_ASPAmountLB"
	s sql=sql_" where ASPALB_ASPA_Parref->ASPA_Date between '"_pStartDate_"' and '"_pEndDate_"'"
	s xrs=##class(%Library.ResultSet).%New()
	s xrs.RuntimeMode=0
	d xrs.Prepare(sql)
	s sc=xrs.Execute()
	i $$$ISERR(sc) q $$$OK
	s count=0
	while (xrs.Next())
	{
		s AspaId=xrs.Data("AspaId") 
		s AspaDate=xrs.Data("AspaDate")
		s AspaTime=xrs.Data("AspaTime")
		s AspaDate=..DH2L(AspaDate)
		s AspaTime=..TL2H(AspaTime)
		s AspaIdLb=xrs.Data("AspaIdLb")
		s AspBatNo=xrs.Data("AspBatNo")
		s AspBatNoI=$$ALPHAUP^SSUTIL4(AspBatNo)
		continue:(pAdjNo'="")&(AspBatNo'=pAdjNo)
		s LocId=xrs.Data("LocId")
		continue:(pAdjLocId'="")&(LocId'=pAdjLocId)
		s LocDesc=xrs.Data("LocDesc")
		s LocDesc=##class(web.DHCSTMHUI.Util.DrugUtil).GetLocDesc(LocDesc)
		s DiffSp=xrs.Data("DiffSp")  
		continue:(pOptType=2)&(DiffSp<=0)   ;只统计差额为正
		continue:(pOptType=3)&(DiffSp>=0)   ;只统计差额为负
		s AspBatId=xrs.Data("AspBatId")
		continue:AspBatId=""
		s AspReasonId=$p(^DHCSTINAPB(AspBatId),"^",29)
		s AspReason=""
		s:AspReasonId'="" AspReason=$p(^DHCSTREASON("ASP",AspReasonId),"^",2) 
		continue:(pAdjReasonId'="")&(AspReasonId'=pAdjReasonId)
		s IncId=xrs.Data("IncId")  
		continue:(pInci'="")&(IncId'=pInci)
		s scgInfo=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncStkCatGrp(IncId)
		s stkType=$p(scgInfo,"^",3)
		continue:stkType'=..sssCode()
		s IncCode=xrs.Data("IncCode")
		s IncDesc=xrs.Data("IncDesc")
		continue:(pItmDesc'="")&(IncDesc'[pItmDesc)
		s StkQty=xrs.Data("StkQty")
		s StkLbQty=xrs.Data("StkLbQty")
		s SpAmt=xrs.Data("SpAmt")    //差额(售价)
		s SpLbAmt=xrs.Data("SpLbAmt")
		s InciLb=xrs.Data("InciLb")
		//wyx add 2014-01-16 增加对批次供应商的过滤，由从DHC_ASPAmount取数据改为从DHC_ASPAmountLB取数据
		s VendorInfo=##class(web.DHCSTMHUI.Common.DrugStkCommon).GetvendorInfoByInclb(InciLb,AspaDate)
		s VendorId=$p(VendorInfo,"^",1)
		s VendorDesc=$p(VendorInfo,"^",2)
		continue:(pVenId'="")&(VendorId'=pVenId)
		s DiffRp=xrs.Data("DiffRp")
		s DiffLbRp=xrs.Data("DiffLbRp")
		s RpAmt=xrs.Data("RpAmt")   //差额(进价)
		s RpLbAmt=xrs.Data("RpLbAmt") 
		s Spec=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetSpec("",IncId)
		s ExecuteDate=$p(^DHCSTINAPB(AspBatId),"^",16)
		s:ExecuteDate'="" ExecuteDate=..DL2H(ExecuteDate)
		s AspUomId=$p(^DHCSTINAPB(AspBatId),"^",5),AspUom=""
		s:AspUomId'="" AspUom=$p(^CT("UOM",AspUomId),"^",2)
		s BUomId=$p(^INCI(IncId,1),"^",10)
		s ConFac=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(AspUomId,BUomId)
		s PriorRp=$p(^DHCSTINAPB(AspBatId),"^",10)     ;基本单位对应的调前进价
		s ResultRp=$p(^DHCSTINAPB(AspBatId),"^",11)		;基本单位对应的调后进价
		s PriorSp=$p(^DHCSTINAPB(AspBatId),"^",12)      ;基本单位对应的调前售价
		s ResultSp=$p(^DHCSTINAPB(AspBatId),"^",13)		;基本单位对应的调后售价
		s PriorRp=PriorRp*ConFac
		s ResultRp=ResultRp*ConFac
		s PriorSp=PriorSp*ConFac
		s ResultSp=ResultSp*ConFac
		s DiffSp=DiffSp*ConFac
		s DiffRp=DiffRp*ConFac
		s DiffLbRp=DiffLbRp*ConFac
		s StkQty=##class(web.DHCSTMHUI.Common.DrugStkCommon).QtyWithUom(IncId,StkQty)
		s AdjUserId=$p(^DHCSTINAPB(AspBatId),"^",18),AdjUserName=""
		s:AdjUserId'="" AdjUserName=$p(^SSU("SSUSR",AdjUserId),"^",2)
		s AuditUserId=$p(^DHCSTINAPB(AspBatId),"^",21),AuditUserName=""
		s:AuditUserId'="" AuditUserName=$p(^SSU("SSUSR",AuditUserId),"^",2)
		s WarrentNo=$p(^DHCSTINAPB(AspBatId),"^",27)    ;物价文件号
		s Incib=$p(^DHCSTINAPB(AspBatId),"^",4)
		continue:'$d(^INCI(+Incib,"IB",$p(Incib,"||",2)))
		s BatNo=$p(^INCI(+Incib,"IB",$p(Incib,"||",2)),"^",1)
		s ExpDate=$p(^INCI(+Incib,"IB",$p(Incib,"||",2)),"^",2)
		s ExpDate=..DH2L(ExpDate)
		s BatExp = BatNo_"~"_ExpDate
		s AspaDate=..DH2L(AspaDate)
		
		s data=AspaIdLb_","_IncId_","_IncCode_","_IncDesc_","_Spec_","_ExecuteDate_","_AspUom_","_StkLbQty_","_PriorSp_","_ResultSp_","_DiffSp_","_PriorRp_","_ResultRp_","_DiffLbRp_","_SpLbAmt_","_RpLbAmt_","_AspReason_","_AdjUserName_","_AuditUserName_","_AspaDate_","_WarrentNo_","_LocDesc_","_Incib_","_BatExp_","_DiffRp_","_VendorDesc
		s Index=IncCode_","_IncDesc_","_LocId_","_LocDesc_","_Incib
		i '$d(^TMP("DHCSTM","AspAmount","QueryAspBatAmount",pid,Index)) d
		.s ^TMP("DHCSTM","AspAmount","QueryAspBatAmount",pid,Index)=data
		e  d
		.s $p(^TMP("DHCSTM","AspAmount","QueryAspBatAmount",pid,Index),",",8)=$p(^TMP("DHCSTM","AspAmount","QueryAspBatAmount",pid,Index),",",8)+StkLbQty
		.s $p(^TMP("DHCSTM","AspAmount","QueryAspBatAmount",pid,Index),",",15)=$p(^TMP("DHCSTM","AspAmount","QueryAspBatAmount",pid,Index),",",15)+SpLbAmt
		.s $p(^TMP("DHCSTM","AspAmount","QueryAspBatAmount",pid,Index),",",16)=$p(^TMP("DHCSTM","AspAmount","QueryAspBatAmount",pid,Index),",",16)+RpLbAmt
	}
		
	s Index=0
	f  s Index=$o(^TMP("DHCSTM","AspAmount","QueryAspBatAmount",pid,Index)) q:(Index="")||(Index=0)  d
	.s data=^TMP("DHCSTM","AspAmount","QueryAspBatAmount",pid,Index)
	.s AspaIdLb=$p(data,",",1)
	.s IncId=$p(data,",",2)
	.s IncCode=$p(data,",",3)
	.s IncDesc=$p(data,",",4)
	.s Spec=$p(data,",",5)
	.s ExecuteDate=$p(data,",",6)
	.s AspUom=$p(data,",",7)
	.s StkLbQty=$p(data,",",8)
	.s PriorSp=$p(data,",",9)
	.s ResultSp=$p(data,",",10)
	.s DiffSp=$p(data,",",11)
	.s PriorRp=$p(data,",",12)
	.s ResultRp=$p(data,",",13)
	.s DiffLbRp=$p(data,",",14)
	.s SpLbAmt=$p(data,",",15)
	.s RpLbAmt=$p(data,",",16)
	.s AspReason=$p(data,",",17)
	.s AspUser=$p(data,",",18)
	.s AuditUser=$p(data,",",19)
	.s AspDate=$p(data,",",20)
	.s WarrentNo=$p(data,",",21)
	.s LocDesc=$p(data,",",22)
	.s Incib=$p(data,",",23)
	.s BatExp=$p(data,",",24)
	.s DiffRp=$p(data,",",25)
	.s VendorDesc=$p(data,",",26)
	.d OutPutRow11
	
	k ^TMP("DHCSTM","AspAmount","QueryAspBatAmount",pid)
	q $$$OK
	
OutPutRow11
	s Data=$lb(AspaIdLb,IncId,IncCode,IncDesc,Spec,ExecuteDate,AspUom,StkLbQty,PriorSp,ResultSp,DiffSp,PriorRp,ResultRp,DiffLbRp,SpLbAmt,RpLbAmt,AspReason,AspUser,AuditUser,AspDate,WarrentNo,LocDesc,Incib,BatExp,DiffRp,VendorDesc)   
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

}
