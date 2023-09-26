Import sqluser

/// creator:    yunhaibao
/// createdate: 2018-06-20
/// description:病区基数药管理
Class web.DHCINPHA.WardBaseDrug Extends %RegisteredObject
{

/// description: 请求单列表
/// w ##class(%ResultSet).RunQuery("web.DHCINPHA.WardBaseDrug","QueryTransReq","2018-07-18^2018-07-18^31^")
Query QueryTransReq(inputStr = "") As websys.Query(ROWSPEC = "reqId,proLocDesc,reqNo,reqUserName,reqDateTime,reqTypeDesc,fromDateTime,toDateTime,printDateTime,collDateTime,dispDateTime,collUserName,dispUserName,reqLocDesc,reqType,reqStat,printFlag")
{
}

ClassMethod QueryTransReqExecute(ByRef qHandle As %Binary, inputStr = "") As %Status
{
    #; s ^TMPDHCSTPARAMS("web.DHCINPHA.WardBaseDrug","QueryTransReq")=inputStr
    s repid=$I(^CacheTemp)
    s qHandle=$lb(0,repid,0)
    s ind=1
    q:inputStr="" $$$OK
    s StDate=$p(inputStr,"^",1)
    s EdDate=$p(inputStr,"^",2)
    s StDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(StDate) 
    s EdDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(EdDate)
    s ReqLocId=$p(inputStr,"^",3)
    s ProLocId=$p(inputStr,"^",4)
    s calcuDate=""
    f calcuDate=StDate:1:EdDate d
    .s reqId=""
    .f  s reqId=$o(^INRQ(0,"Date",calcuDate,reqId)) q:reqId=""  d
    ..q:+reqId=0
    ..s reqData=^INRQ(reqId)
    ..s reqLocId=$p(reqData,"^",6)
    ..s proLocId=$p(reqData,"^",5)
    ..q:(ReqLocId'="")&(reqLocId'=ReqLocId)
    ..q:(ProLocId'="")&(proLocId'=ProLocId)
    ..s proLocDesc=##class(PHA.COM.Data.Base).LocDesc(proLocId)
    ..s reqLocDesc=##class(PHA.COM.Data.Base).LocDesc(reqLocId)
    ..s reqDate=$p(reqData,"^",2)
    ..s reqDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(reqDate)
    ..s reqTime=$p(reqData,"^",3)
    ..s reqTime=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(reqTime,"IP")
    ..s reqDateTime=reqDate_" "_reqTime
    ..s reqUserId=$p(reqData,"^",4)
    ..s reqUserName=##class(PHA.COM.Data.Base).UserName(reqUserId)
    ..s finishFlag=$p(reqData,"^",8)
    ..s reqNo=$p(reqData,"^",1)
    ..s reqTypeStr=..GetReqType(reqId)
    ..s reqTypeDesc=$p(reqTypeStr,"^",2)
    ..s reqType=$p(reqTypeStr,"^",1)
    ..q:reqType=""
    ..s bddId=$o(^DHCBDD(0,"REQ",reqId,""))
    ..s (fromDate,fromTime,toDate,toTime)=""
    ..i bddId'="" d
    ...s bddData=$g(^DHCBDD(bddId))
    ...s fromDate=$p(bddData,"^",6)
    ...s fromTime=$p(bddData,"^",14)
    ...s toDate=$p(bddData,"^",7)
    ...s toTime=$p(bddData,"^",15)
    ..i fromDate="" s fromDate=$p(reqData,"^",2)
    ..i toDate="" s toDate=$p(reqData,"^",2)
    ..i fromTime="" s fromTime=$p(reqData,"^",3)
    ..i toTime="" s toTime=$p(reqData,"^",3)
    ..s fromDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(fromDate)
    ..s toDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(toDate)
    ..s fromTime=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(fromTime,"IP")
    ..s toTime=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(toTime,"IP")
    ..s fromDateTime=fromDate_" "_fromTime
    ..s toDateTime=toDate_" "_toTime
    ..s dhcReqId=$O(^DHCINRQ(0,"INRQ",reqId,"")) 
    ..s (initStat,printDateTime,printUserName,collUserName,collDateTime,dispUserName,dispDateTime)=""
    ..
    ..i dhcReqId'="" d
    ...s dhcReqData=$g(^DHCINRQ(dhcReqId))
    ...q:dhcReqData=""
    ...s printFlag=$p(dhcReqData,"^",2)
    ...i printFlag=1 s printFlag=..Translate("是") // @translate
    ...e  s printFlag=..Translate("否") // @translate
    ...//s collUser=$p(dhcReqData,"^",5)
    ...//s collDate=$p(dhcReqData,"^",3)
    ...//s collTime=$p(dhcReqData,"^",4)
    ...//s collDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(collDate)
    ...//s collTime=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(collTime,"IP")
    ...//s collDateTime=collDate_" "_collTime
    ...//s collUserName=$p($g(^SSU("SSUSR",+collUser)),"^",2)
    ...//s dispUser=$p(dhcReqData,"^",8)
    ...//s dispDate=$p(dhcReqData,"^",6)
    ...//s dispTime=$p(dhcReqData,"^",7)
    ...//s dispDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(dispDate)
    ...//s dispTime=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(dispTime,"IP")
    ...//s dispDateTime=dispDate_" "_dispTime
    ...//s dispUserName=$p($g(^SSU("SSUSR",+dispUser)),"^",2)
    ...
    ...s printDate=$p(dhcReqData,"^",22)
    ...s printTime=$p(dhcReqData,"^",23)
    ...s printDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(printDate)
    ...s printTime=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(printTime,"IP")
    ...s printDateTime=printDate_" "_printTime
    ...//i reqType=3 d
    ...i 1=1 d // 走出库的显示,yunhaibao,20200115
    ....s initId=$o(^DHCINIT(0,"REQ",reqId,0))
    ....q:initId=""
    ....s initData=$g(^DHCINIT(initId))
    ....q:initData=""
    ....s collUser=$p(initData,"^",11) // 转移出库人
    ....s collDate=$p(initData,"^",9)
    ....s collTime=$p(initData,"^",10)
    ....s collDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(collDate)
    ....s collTime=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(collTime,"IP")
    ....s collDateTime=collDate_" "_collTime
    ....s collUserName=##class(PHA.COM.Data.Base).UserName(collUser)
    ....s dispUser=$p(initData,"^",17) // 转移入库人
    ....s dispDate=$p(initData,"^",15)
    ....s dispTime=$p(initData,"^",16)
    ....s dispDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(dispDate)
    ....s dispTime=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(dispTime,"IP")
    ....s dispDateTime=dispDate_" "_dispTime
    ....s dispUserName=##class(PHA.COM.Data.Base).UserName(dispUser)
    ....s initStat=$p(initData,"^",14)
    ..s reqStat=..Translate("未完成") // @translate
    ..i initStat=31 s reqStat=..Translate("已接收") // @translate
    ..e  i initStat=21 d
    ...s reqStat=..Translate("已出库") // @translate
    ...s partRet=##class(web.DHCST.DHCINIsTrf).JudPart(21,initId)
    ...i partRet=32 s reqStat=..Translate("部分接收") // @translate
    ..e  i initStat=20 s reqStat=..Translate("出库审核不通过") // @translate
    ..e  i initStat=30 s reqStat=..Translate("拒绝接收") // @translate
    ..e  i finishFlag="Y" s reqStat=..Translate("已完成等待出库") // @translate
    ..i (initStat="31")||(initStat="21") d
    ...s status=##class(web.DHCST.DHCINIsTrf).TransferStatus(reqId)
    ...i (status=1)&&(reqStat'["部分") s reqStat="部分"_reqStat
    ..s ^CacheTemp(repid,ind)=$lb(reqId,proLocDesc,reqNo,reqUserName,reqDateTime,reqTypeDesc,fromDateTime,toDateTime,printDateTime,collDateTime,dispDateTime,collUserName,dispUserName,reqLocDesc,reqType,reqStat,printFlag) 
    ..s ind=ind+1
    q $$$OK
}

/// description: 请求单明细
/// w ##class(%ResultSet).RunQuery("web.DHCINPHA.WardBaseDrug","QueryTransReqItm","109")
Query QueryTransReqItm(inputStr = "") As websys.Query(ROWSPEC = "reqItmId,incRowId,incCode,incDesc,reqUomDesc,reqUomId,reqQty,reqLocPurQty")
{
}

ClassMethod QueryTransReqItmExecute(ByRef qHandle As %Binary, inputStr = "") As %Status
{
    #; s ^TMPDHCSTPARAMS("web.DHCINPHA.WardBaseDrug","QueryTransReqItm")=inputStr
    s repid=$I(^CacheTemp)
    s qHandle=$lb(0,repid,0)
    s ind=1
    s reqId=$p(inputStr,"^",1)
    q:+reqId=0 $$$OK
    q:'$d(^INRQ(reqId)) $$$OK
    s proLocId=$p(^INRQ(reqId),"^",6)
    s reqLocId=$p(^INRQ(reqId),"^",5)
    s hospId=$p($g(^CLOC(proLocId)),"^",22)
    s reqItm=0
    f  s reqItm=$o(^INRQ(reqId,"RQI",reqItm)) q:reqItm=""  d
    .s reqItmData=$g(^INRQ(reqId,"RQI",reqItm))
    .q:reqItmData=""
    .s reqItmId=reqId_"||"_reqItm
    .s incId=$p(reqItmData,"^",4)
    .s reqUomId=$p(reqItmData,"^",5)
    .s reqQty=$p(reqItmData,"^",3)
    .s incCode=$p(^INCI(incId,1),"^",1)
    .s incDesc=##class(PHA.COM.Data.Base).InciDesc(incId)
    .s reqUomDesc=##class(PHA.COM.Data.Base).UomDesc(reqUomId)
    .s pUomId=$p(^INCI(incId,3),"^",6)
    .s reqLocPurQty=##class(web.DHCST.Common.DrugStkCommon).LocDayQtyUom(incId,reqLocId,pUomId,+$h)
    .s ^CacheTemp(repid,ind)=$lb(reqItmId,incId,incCode,incDesc,reqUomDesc,reqUomId,reqQty,reqLocPurQty) 
    .s ind=ind+1
    q $$$OK
}

/// description: 获取请求单类型
ClassMethod GetReqType(reqId As %String) As %String
{
    s dhcReqId=$O(^DHCINRQ(0,"INRQ",reqId,"")) 
    q:dhcReqId="" ""
    s reqTypeId=$p($g(^DHCINRQ(dhcReqId)),"^",1)
    i reqTypeId="1" s reqTypeDesc=..Translate("基数补货") // @translate
    e  i reqTypeId="2" s reqTypeDesc=..Translate("精神毒麻补货") // @translate
    e  i reqTypeId="3" s reqTypeDesc=..Translate("大输液补货") // @translate
    e  s reqTypeDesc="",reqTypeId=""
    q reqTypeId_"^"_reqTypeDesc
}

/// description: 获取请求单主信息
/// w ##class(web.DHCINPHA.WardBaseDrug).GetReqData(103)
ClassMethod GetReqData(reqId)
{
    q:reqId="" ""
    s reqData=$g(^INRQ(reqId))
    q:reqData="" ""
    s proLocId=$p(reqData,"^",5)
    s reqLocId=$p(reqData,"^",6)
    s reqDate=$p(reqData,"^",2)
    s reqDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(reqDate)
    s reqUserId=$p(reqData,"^",4)
    s reqUserName=$p($g(^SSU("SSUSR",+reqUserId)),"^",2)
    s finishFlag=$p(reqData,"^",8) // Y
    s reqNo=$p(reqData,"^",1)
    s reqTypeStr=..GetReqType(reqId)
    s reqTypeDesc=$p(reqTypeStr,"^",2)
    s reqType=$p(reqTypeStr,"^",1)
    s retData1=reqId_"^"_reqNo_"^"_reqLocId_"^"_proLocId_"^"_reqDate
    s retData2=reqUserId_"^"_reqUserName_"^"_finishFlag_"^"_reqType_"^"_reqTypeDesc
    q retData1_"^"_retData2
}

/// description: 删除明细
ClassMethod DeleteReqItm(reqItmId)
{
    q:+reqItmId=0 "明细Id为空"
    q:$p(^INRQ(+reqItmId),"^",8)="Y" "-1^请求单已经完成,无法删除"
    s reqTypeStr=..GetReqType(+reqItmId)
    s reqType=$p(reqTypeStr,"^",1)
    s err=0
    i reqType>0 s err=##class(web.DHCSTBASEDRUG).ClearReqItm(reqItmId)
    q:err'=0 "-1^清除补货明细失败"
    &sql(delete from in_reqitm where inrqi_rowid=:reqItmId)
    q SQLCODE
}

/// description: 删除主信息
ClassMethod DeleteReq(reqId)
{
    q:+reqId=0 "-1^请求单Id为空"
    i reqId'="" s allowDel=##class(web.DHCST.INRequest).AllowDel(reqId)
    e  s allowDel=0
    q:allowDel=-1 "-1^请求单已经完成"
    q:allowDel=-2 "-1^请求单已经转移出库"
    q:allowDel=-3 "-1^请求单已经转换为采购计划"
    q:allowDel<0 "-1^请求单保存失败,错误代码:"_allowDel
    ts
    s reqTypeStr=..GetReqType(+reqId)
    s reqType=$p(reqTypeStr,"^",1)
    s errCode=""
    i (reqType>0)&($o(^DHCBDD(0,"REQ",reqId,""))>0) d
    .&sql(delete from dhc_basedrugdisp where BDD_INRQ_DR=:reqId )
    .i SQLCODE'=0 tro  s errCode=-1_"^删除补货记录失败"
    q:errCode'="" errCode
    i $o(^DHCINRQ(0,"INRQ",reqId,""))>0 d
    .&sql(delete from DHC_INRequest where inrq_inrq_dr=:reqId)
    .i SQLCODE'=0 tro  s errCode=-1_"^删除请求附加记录失败"
    q:errCode'="" errCode
    i $d(^INRQ(reqId)) d
    .&sql(delete from in_request where inrq_rowid=:reqId)
    .i SQLCODE'=0 tro  s errCode=-1_"^删除请求记录失败"
    q:errCode'="" errCode
    tc
    q 0
}

/// description: 补货单明细
/// table:       DHC_BaseDrugDispItm
/// w ##class(%ResultSet).RunQuery("web.DHCINPHA.WardBaseDrug","QueryBaseDrugDispItm","1")
Query QueryBaseDrugDispItm(inputStr = "") As websys.Query(ROWSPEC = "bddItmId,reqItmId,incId,incCode,incDesc,reqUomDesc,reqUomId,reqQty,consumeQty")
{
}

ClassMethod QueryBaseDrugDispItmExecute(ByRef qHandle As %Binary, inputStr = "") As %Status
{
    #; s ^TMPDHCSTPARAMS("web.DHCINPHA.WardBaseDrug","QueryBaseDrugDispItm")=inputStr
    s repid=$I(^CacheTemp)
    s qHandle=$lb(0,repid,0)
    s ind=1
    s bddId=$p(inputStr,"^",1)
    q:+bddId=0 $$$OK
    s bddItm=0
    f  s bddItm=$o(^DHCBDD(bddId,"I",bddItm)) q:bddItm=""  d
    .s bddItmId=bddId_"||"_bddItm
    .s bddItmData=^DHCBDD(bddId,"I",bddItm)
    .s incId=$P(bddItmData,"^",1)
    .s consumeQty=$P(bddItmData,"^",2)
    .s reqQty=$P(bddItmData,"^",3)
    .s reqItmId=$P(bddItmData,"^",4)
    .s incCode=$p(^INCI(incId,1),"^",1)
    .s incDesc=##class(PHA.COM.Data.Base).InciDesc(incId)
    .s reqUomId=$p(^INCI(incId,1),"^",10)
    .s reqUomDesc=##class(PHA.COM.Data.Base).UomDesc(reqUomId)
    .s ^CacheTemp(repid,ind)=$lb(bddItmId,reqItmId,incId,incCode,incDesc,reqUomDesc,reqUomId,reqQty,consumeQty) 
    .s ind=ind+1
    q $$$OK
}

/// description: 保存请求单,调用药库程序,todo还涉及bdd表,有待修改
/// w ##class(web.DHCINPHA.WardBaseDrug).SaveReq("","309^199^4770^^O^","^1671^24^1","3")
ClassMethod SaveReq(reqId, reqMainData, reqItmDatas, reqTypeId)
{
    #; s ^TMPDHCSTPARAMS("web.DHCINPHA.WardBaseDrug","SaveReq")=$lb(reqId, reqMainData, reqItmDatas, reqTypeId)
    i reqId'="" s allowDel=##class(web.DHCST.INRequest).AllowDel(reqId)
    e  s allowDel=0
    q:allowDel=-1 "-1^请求单已经完成"
    q:allowDel=-2 "-1^请求单已经转移出库"
    q:allowDel=-3 "-1^请求单已经转换为采购计划"
    q:allowDel<0 "-1^请求单保存失败,错误代码:"_allowDel
    tstart
    s $ZT="ThrowSaveReq"
    s saveRet=..SaveReqMain(reqId,reqMainData,reqTypeId)
    i $p(saveRet,"^",1)<0 tro  q saveRet
    s reqId=saveRet
    s saveRetItmsRet=..SaveReqItms(reqId,reqItmDatas,reqTypeId)
    i $p(saveRetItmsRet,"^",1)<0 tro  q saveRetItmsRet
    tcommit
    q 0_"^"_reqId
ThrowSaveReq
    d ErrorRecord^DHCSTERROR("##class(web.DHCINPHA.WardBaseDrug).SaveReq","更新",$zt)
    q "-2^"_$tr($ze,"^",",")
}

/// descriprion: 保存基数请求主表
ClassMethod SaveReqMain(reqId, reqMainData, reqTypeId)
{
    s proLocId=$p(reqMainData,"^",1) 
    q:proLocId="" "-1^供给科室为空"
    s reqLocId=$p(reqMainData,"^",2) 
    q:reqLocId="" "-1^请求科室为空"
    q:proLocId=reqLocId "-1^请求科室与供给科室相同"
    s userId=$p(reqMainData,"^",3)      // 请求人
    s stkGrpId=$p(reqMainData,"^",4)    // 类组分类
    s status=$p(reqMainData,"^",5)      // 状态(C,O,X)
    s remark=$p(reqMainData,"^",6)      // 备注内容
    i status="" s status="O"
    s stkGrpCode=""
    i stkGrpId'="" &Sql(select scg_code into :stkGrpCode from dhc_stkcatgroup where %ID=:stkGrpId)
    s curDate=+$h
    s curTime=$p($h,",",2)
    s errCode=""
    i reqId'="" q:##class(web.DHCST.Common.AppCommon).Lock(##class(web.DHCST.INRequest).%GetParameter("AppName")_reqId)<0 "-1^主表加锁失败"
    i reqId="" d   //插入
    .&sql(
        insert into IN_Request
        (inrq_recLoc_dr,inrq_reqloc_dr,inrq_date,inrq_time,inrq_ssusr_dr,inrq_status)
        values 
        (:reqLocId,:proLocId,:curDate,:curTime,:userId,:status) 
     )
    .i SQLCODE'=0  s errCode="-2^插入主表失败" q
    .s reqId=%ROWID
    .&sql(insert into DHC_INRequest(INRQ_Type,INRQ_INRQ_DR,INRQ_SCG_DR)values(:reqTypeId,:reqId,:stkGrpId) )
    .s reqNo=##class(web.DHCST.Common.AppCommon).GetAppNo(##class(web.DHCST.INRequest).%GetParameter("AppName"),stkGrpId,reqLocId)
    .i reqNo'="" d
    ..&sql(update IN_Request set inrq_no=:reqNo where %ID=:reqId)
    ..i SQLCODE'=0 s errCode="-2^更新单号失败" q
    .q:errCode'=""
    e  d   //更新
    .&SQL(
        update IN_Request 
        set INRQ_RecLoc_DR=:reqLocId,INRQ_ReqLoc_DR=:proLocId,INRQ_SSUSR_DR=:userId,INRQ_Status=:status
        where %ID=:reqId
     )
    .i SQLCODE'=0 s errCode="-2^更新主表失败" q
    .s dhcReq=$o(^DHCINRQ(0,"INRQ",reqId,0))
    .i dhcReq'="" d
    ..&SQL(
        update DHC_INRequest
        set INRQ_Type=:reqTypeId,INRQ_INRQ_DR=:reqId,INRQ_SCG_DR=:stkGrpId
        where %ID=:dhcReq
        )
    ..i SQLCODE'=0 s errCode="-2^更新附加主表失败" q
    d ##class(web.DHCST.Common.AppCommon).UnLock(##class(web.DHCST.INRequest).%GetParameter("AppName")_reqId)
    q:errCode'="" errCode
    q reqId
}

/// descriprion: 批量保存基数请求单子表
/// 事务在最外层 SaveReq
ClassMethod SaveReqItms(reqId, reqItmDatas, reqTypeId)
{
    q:reqId="" "-1^请求主表Id为空"
    q:##class(web.DHCST.Common.AppCommon).Lock(##class(web.DHCST.INRequest).%GetParameter("APPNAME")_reqId)<0 "-1^更新明细加锁失败"
    s errCode=""
    s rowDelim=##class(web.DHCST.Common.UtilCommon).RowDataDelim()
    s reqItmsLen=$l(reqItmDatas,rowDelim)
    q:(reqItmDatas="")||(reqItmsLen=0) "-1^无可用保存数据"
    f i=1:1:reqItmsLen  q:errCode'=""  d
    .s reqItmData=$P(reqItmDatas,rowDelim,i)
    .s reqItmId=$P(reqItmData,"^",1)
    .s reqItmData=$P(reqItmData,"^",2,$L(reqItmData,"^"))
    .q:reqItmData=""
    .s saveRetItm=..SaveReqItm(reqId,reqItmId,reqItmData,reqTypeId)
    .i $p(saveRetItm,"^",1)<0 s errCode=saveRetItm q
    d ##class(web.DHCST.Common.AppCommon).UnLock(##class(web.DHCST.INRequest).%GetParameter("APPNAME")_reqId)
    q:errCode'="" errCode
    q 0
}

/// description: 保存基数请求子表
/// other:       暂不控制BDD数量
ClassMethod SaveReqItm(reqId, reqItmId, reqItmData, reqTypeId)
{
    s errCode=""
    s incId=$p(reqItmData,"^",1)
    s reqUomId=$p(reqItmData,"^",2)
    s reqQty=$p(reqItmData,"^",3)
    s itmRemark=$p(reqItmData,"^",4)
    s stkGrpId=$p(reqItmData,"^",5)
    s ppQty=$p(reqItmData,"^",6)  // 建议数量
    s reqDate=$p(^INRQ(reqId),"^",2)
    s IncscDr=$P(^INCI(incId,2),"^",2)                              //库存分类ID
    s IncscDesc=$P(^INC("SC",IncscDr),"^",2)                        //库存分类
    i (reqTypeId=3)&&(IncscDesc'["大输液")  d
    .s errCode="-1^请求单中含有不是大输液药品"   q
    i reqItmId="" d
    .&SQL(SELECT INRQI_RowId FROM IN_ReqItm WHERE INRQI_INRQ_ParRef=:reqId AND INRQI_INCI_DR=:incId)
    .q:SQLCODE=0
    .s maxReqItm=$o(^INRQ(reqId,"RQI",""),-1)+1
    .&sql(
        insert into in_reqitm 
        (inrqi_inrq_parref,inrqi_childsub,inrqi_inci_dr,inrqi_reqqty,inrqi_ctuom_dr,inrqi_date)
        values
        (:reqId,:maxReqItm,:incId,:reqQty,:reqUomId,:reqDate) 
     )
    .i SQLCODE'=0 s errCode="-2^插入请求子表失败" q
    .s reqItmId=reqId_"||"_maxReqItm
    .&sql(
        insert into dhc_inreqitm 
        (INRQI_INRQI_DR,INRQI_Remark,INRQI_ProReqQty) 
        values 
        (:reqItmId,:itmRemark,:ppQty))
    .i SQLCODE'=0 s errCode="-2^插入请求附加子表失败" q
    e  d
    .s reqTypeId=$p(..GetReqType(reqId),"^",1)
    .&SQL(SELECT INRQI_RowId FROM IN_ReqItm WHERE INRQI_INRQ_ParRef=:reqId AND INRQI_INCI_DR=:incId and INRQI_RowId!=:reqItmId)
    .q:SQLCODE=0
    .s curDate=+$h
    .i +reqTypeId>0 d //是否允许更新 2010-12-23
    ..s chkRepQty=##class(web.DHCSTBASEDRUG).CheckRepQtyByReqItm(reqItmId,reqQty) 
    ..i chkRepQty=0 s errCode="-1^请求数量不能大于余量"
    .q:errCode'=""
    .&sql(
        update in_reqitm 
        set inrqi_inci_dr=:incId,inrqi_reqqty=:reqQty,inrqi_ctuom_dr=:reqUomId,inrqi_date=:curDate
        where
        INRQI_RowId=:reqItmId
     )
    .s handleRet=##class(web.DHCSTBASEDRUG).HandleReqItmQty(reqItmId)
    .i SQLCODE'=0 s errCode="-2^更新请求子表失败" q
    q:errCode'="" errCode
    q 0
}

/// description: 完成\取消完成
ClassMethod Finish(reqId, finishFlag)
{
    s saveRet=##class(web.DHCST.INRequest).SetCompleteStatus(reqId,finishFlag)
    s errCode=""
    i saveRet<0 d
    .i saveRet=-10 s errCode="-1^状态值不为Y或N" q
    .e  i saveRet=-1 s errCode="-1^请求单已经转移出库" q
    .e  i saveRet=-2 s errCode="-1^更新状态失败" q
    .e  s errCode="-1^更新状态失败,错误代码:"_saveRet q
    q:errCode'="" errCode
    q 0
}

/// deccription:药品列表,仅基数药界面使用
/// table:      User.IncItm
/// input:      inputStr^1:库存项Id,inputStr^2:供给科室,inputStr^3:基数药单据类型(1)
/// d ##class(%ResultSet).RunQuery("web.DHCINPHA.WardBaseDrug","IncItm","^308^1","a")
Query IncItm(inputStr = "", filterText = "") As websys.Query(ROWSPEC = "incRowId,incCode,incDesc,incSpec")
{
}

ClassMethod IncItmExecute(ByRef qHandle As %Binary, inputStr = "", filterText = "") As %Status
{
    s repid=$I(^CacheTemp)
    s qHandle=$lb(0,repid,0)
    s ind=1
    //q:inputParams="" $$$OK
    s IncId=$p(inputStr,"^",1)
    s LocId=$p(inputStr,"^",2)  
    s reqTypeId=$p(inputStr,"^",3)  
    q:(IncId="")&&(filterText="") $$$OK
    s filterText="%"_$$ALPHAUP^SSUTIL4(filterText)_"%"
    s result = ##class(%Library.ResultSet).%New()
    s StkGrpType="G"
    if (IncId'="") {
        s sqlStr ="select inci_rowid as incId from inc_itm  where inci_RowId='"_IncId_"'"
    }else {
        s sqlStr ="select distinct inca_inci_dr as incId from inc_alias "_
        "where %ALPHAUP(inca_text) like '"_filterText_"' and inca_inci_dr->inci_incsc_dr in "_ 
        "(Select scgr_stkcat_dr from dhc_stkcatgrprelations Where scgr_scg_parref->SCG_Type='"_StkGrpType_"')"
    }
    d result.Prepare(sqlStr)
    d result.Execute()
    While(result.Next())
    {
        s incId = result.Data("incId")
        continue:(LocId'="")&&('$d(^INCI("IL_LOC",LocId,incId)))
        s incDesc=$p(^INCI(incId,1),"^",2)
        s incCode=$p(^INCI(incId,1),"^",1)
        s itmAdd=$o(^DHCITMINFO(0,"INCI",incId,"")) 
        s incSpec=$p($g(^DHCITMINFO(+itmAdd)),"^",27)
        continue:incDesc=""

        s arcItmId=$P(^INCI(incId,1),"^",3)
        continue:arcItmId=""
        s arcItmCat=$p($g(^ARCIM(+arcItmId,1,1)),"^",10)
        continue:arcItmCat=""
        s arcItmCatDesc=$p($g(^ARC("IC",arcItmCat)),"^",2)

        continue:(reqTypeId=2)&&(arcItmCatDesc'["麻醉药品(基数药)")
        continue:(reqTypeId=3)&&(arcItmCatDesc'["大输液(基数药)") 
        continue:(reqTypeId=1)&&(arcItmCatDesc'["西药注射剂(基数药)") 
        d outputRow
    }
    d result.Close()
    Quit $$$OK
outputRow  
    s incDesc=##class(PHA.COM.Data.Base).InciDesc(incId)
    s Data=$lb(incId,incCode,incDesc,incSpec)
    s ^CacheTemp(repid,ind)=Data    
    s ind=ind+1
    q
}

ClassMethod Translate(item)
{
    q ##class(PHA.FACE.IN.Com).Translate("dhcpha.inpha.hisui.querytransreq.csp", item)
}

}
