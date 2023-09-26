Import sqluser

/// creator:    yunhaibao
/// createdate: 20160607
/// descirpiton:住院药房退药申请
Class web.DHCINPHA.Request Extends %RegisteredObject
{

/// description: 查询已发药,用于退药申请
/// others:      按用药日期\关联医嘱顺序显示,但不控制
/// w ##class(%ResultSet).RunQuery("web.DHCINPHA.Request","QueryDisped","0000000598^871^184^8^")
Query QueryDisped(inputStr = "") As websys.Query(ROWSPEC = "recLocId,recLocDesc,incCode,incDesc,canRetQty,reqQty,dspQty,bUomDesc,dspId,reqReasonId,reqReasonDesc,docLocDesc,doseDateTime,encryptLevel,patLevel,wardLocId,oeoriSign,reqHistory,phacLbRowId,dspSubRowId,inclb,cantretreason,cyFlag,prescNo,needGrpRet,canRetFlag,mDspId,firstRow,patNo,patName")
{
}

ClassMethod QueryDispedExecute(ByRef qHandle As %Binary, inputStr = "") As %Status
{
    s repid=$I(^CacheTemp)
    s qHandle=$lb(0,repid,0)
    s ind=1
    q:inputStr="" $$$OK
    s PatNo=$p(inputStr,"^",1)
    s AdmId=$p(inputStr,"^",2)
    s RecLocId=$p(inputStr,"^",3)
    s LocId=$p(inputStr,"^",4)
    s EMFlag=$p(inputStr,"^",5)
    q:(PatNo="")&&(AdmId="") $$$OK
    
    #; 如果就诊ID为空, 登记号不为空, 则取最后一个就诊
    i AdmId="" d
    .i PatNo'="" d
    ..i EMFlag="Y" s lastAdmId=##class(PHA.COM.Method).GetAdmByPatNo(PatNo,"E")
    ..e  s lastAdmId=##class(PHA.COM.Method).GetAdmByPatNo(PatNo,"I")
    .s AdmId=$g(lastAdmId)
    
    q:(AdmId="") $$$OK
    
    s PatId=$p(^PAADM(AdmId),"^",1) 
    s (encryptLevel,patLevel)=""
    s encryptFlag=##Class(web.DHCSTCOMMPARA).GetEncryptLevelFlag()
    i encryptFlag=1 d
    .s encryptLevelInfo=##class(web.DHCBL.CARD.UCardPaPatMasInfo).GetPatEncryptLevel(PatId,"")
    .s encryptLevel=$p(encryptLevelInfo,"^",1)
    .s patLevel=$p(encryptLevelInfo,"^",2)
    // 过滤-已出院
    s visitStatus=##class(web.DHCSTCOMMONSRV).GetCurrentAdmStatus(AdmId)
    q:visitStatus=0 $$$OK
    s hospId=$p($g(^CTLOC(+LocId)),"^",22)
    s appParams=""_"^"_""_"^"_""_"^"_hospId
    s crossWardReqFlag=##class(web.DHCST.Common.AppCommon).GetAppPropValue("DHCSTORDDISP","CrossWardReqFlag",appParams) 
    s patID=$p(^PAADM(AdmId),"^",1) 
    s patNo=$p(^PAPER(patID,"PAT",1),"^",2)
    s patName=$p(^PAPER(patID,"ALL"),"^",1) 
    // 直接遍历打包表没有合适的索引,获取符合条件的
    s ordId=$o(^OEORD(0,"Adm",AdmId,"")) 
    q:ordId="" $$$OK
    s admType=$p(^PAADM(AdmId),"^",2)
    s ordItm=""
    f  s ordItm=$o(^OEORD(ordId,"I",ordItm)) q:ordItm=""  d
    .s quitFlag=""
    .q:+ordItm=0
    .s oeori=ordId_"||"_ordItm
    .i admType="E" s emPayStayStatus=##class(web.DHCSTCOMMONSRV).GetPayStayStatus(oeori)
    .e  s emPayStayStatus=""
    .s mOeori=##class(web.DHCSTKUTIL).GetMainOeori(oeori)
    .q:'$d(^DHCOEDISQTY(0,"OEORI",oeori))
    .s dspId=""
    .f  s dspId=$o(^DHCOEDISQTY(0,"OEORI",oeori,dspId)) q:dspId=""  d
    ..q:+dspId=0
    ..s dspData=$g(^DHCOEDISQTY(dspId))
    ..// 过滤-未发
    ..q:$p(dspData,"^",7)'="C"
    ..q:$p(dspData,"^",13)'="P"
    ..// 过滤-禁止退药申请
    ..q:##class(web.DHCSTRETREQUEST).GetRequestFlagbyDsp(dspId)=0
    ..s Prescno=$p(^OEORD(ordId,"I",ordItm,1),"^",14)       ;处方号
    ..q:Prescno=""
    ..s queid=##class(PHA.COM.Order).PrescCYQueId(Prescno)
    ..s cyFlag=$s(queid'="":"Y",1:"")
    ..q:(cyFlag = "Y")  
    ..s phacItmRowId=$p(dspData,"^",14)  
    ..q:+phacItmRowId=0
    ..s phacId=+phacItmRowId,phacCh=$p(phacItmRowId,"||",2)
    ..s oeore=$p(dspData,"^",3)
    ..q:oeore="" 
    ..s oeoreStatusDr=$p($g(^OEORD(+oeore,"I",+$p(oeore,"||",2),"X",$p(oeore,"||",3))),"^",16)
    ..s oeoreStatus=$p($g(^OEC("STAT",+oeoreStatusDr)),"^",1) 
    ..// 过滤-停止执行可做申请 - 住院与急诊留观均判断执行记录
    ..q:oeoreStatus'="D"
    ..s mDspId=##class(web.DHCSTCOMMONORDER).GetMainDspId(dspId)
    ..// 判断特殊科室
    ..s wardId=$p(^DHCPHAC(phacId),"^",4)
    ..s wardLocId=$p($g(^PAWARD(+wardId)),"^",5)
    ..i wardId'="" s locId=$p(^PAWARD(wardId),"^",5)
    ..e  d
    ...s locId=##Class(web.DHCSTKUTIL).UserDept(oeori) // 特殊科室即为医生科室
    ...
    ..s recLocId=$p(dspData,"^",24)
    ..q:(RecLocId'="")&&(RecLocId'=recLocId)
    ..s specFlag=##class(web.DHCSTPCHCOLLS).DoctorLocRefuse(recLocId,locId)     // 是否为特殊科室
    ..s lgSpecFlag=##class(web.DHCSTPCHCOLLS).DoctorLocRefuse(recLocId,LocId)   // 登陆科室是否为特殊科室
    ..// 跨病区设置
    ..i crossWardReqFlag'="Y" d
    ...// i (specFlag=1)&&(lgSpecFlag'=1) d
    ...i locId'=LocId d
    ....s quitFlag="Y"
    ..q:quitFlag'=""
    ..s pivasFlag=$p($g(^OEORD(ordId,"I",ordItm,"DHC")),"^",16)
    ..s needGrpRet="", has60="", pogPackFlag=""
    ..i (cyFlag="Y")||(pivasFlag="Y") s needGrpRet="Y"  // 成组退
    ..s canRetFlag="Y"
    ..i pivasFlag="Y" d
    ...s reqNeedAudit=##class(web.DHCSTPIVAS.Settings).GetAppParamProp("",recLocId,"","ReqNeedAudit")
    ...i reqNeedAudit="Y" d 
    ....s has60=##class(PHA.FACE.OUT.Com).IfOeoreHas60(oeore)
    ....i has60="Y" s canRetFlag="N"
    ...s packReqAudit=##class(web.DHCSTPIVAS.Settings).GetAppParamProp("",recLocId,"","PackReqAudit")
    ...i packReqAudit="Y" d
    ....s pogPackFlag=$p($g(^DHCOEDISQTY(mDspId)),"^",28)
    ....q:pogPackFlag'="P"
    ....s psNumber=$p(##class(web.DHCSTPIVAS.Common).CurPsState(mDspId),"^",1)
    ....s pogId = +$o(^PIVA(0, "DSP", +dspId, ""))
    ....s pogAllowFlag = $p($g(^PIVA(pogId)), "^", 28)      // 可退标志
    ....i (psNumber>=85)&&(pogAllowFlag '= "Y") d
    .....s canRetFlag="N"  //配液打包医嘱，当前配液状态在打印交接单之后的，不让申请退药(置为允许退药后可以退药)
    ..s firstRow=""
    ..// 准备输出数据
    ..s doseDate=$p(dspData,"^",21)
    ..s doseTime=$p(dspData,"^",20)
    ..s doseDateHtml=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(doseDate)
    ..s doseTimeHtml=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(doseTime)
    ..s doseDateTime=doseDateHtml_" "_doseTimeHtml
    ..s recLocDesc=##class(PHA.COM.Data.Base).LocDesc(recLocId)
    ..s dosage=##class(web.DHCSTCOMMONORDER).OeoriDosage(oeori)
    ..s docLocDesc=##class(web.DHCSTRETREQUEST).UserDept(oeori)
    ..s dspSubId=0
    ..f  s dspSubId=$o(^DHCOEDISQTY(dspId,"I",dspSubId)) q:dspSubId=""  d
    ...s dspSubRowId=dspId_"||"_dspSubId
    ...s phacLbId=0
    ...f  s phacLbId=$o(^DHCPHACi("DSPB",dspSubRowId,phacId,phacCh,phacLbId))  q:phacLbId=""  d
    ....q:'$d(^DHCPHAC(phacId,"I",phacCh,"B",phacLbId))
    ....s phacLbRowId=phacId_"||"_phacCh_"||"_phacLbId
    ....s retedQty=##class(web.DHCSTPHARETURN).ReturnedQtyByPhacLb(phacLbRowId)     //已退数量
    ....s reqedQty=##class(web.DHCSTRETREQUEST).GetReqQtyByPhacLb(phacLbRowId)      //已申请未退
    ....s dspQty=$p(^DHCPHAC(phacId,"I",phacCh,"B",phacLbId),"^",2)                 //发药数量 
    ....s canRetQty=dspQty-retedQty-reqedQty                                        //还可退数量
    ....q:canRetQty<=0
    ....s inclb=$p(^DHCPHAC(phacId,"I",phacCh,"B",phacLbId),"^",1)
    ....s incId=+inclb
    ....q:+incId=0
    ....s incCode=$p(^INCI(incId,1),"^",1)
    ....s incDesc=##class(PHA.COM.Data.Base).InciDesc(incId)
    ....s bUomId=$p(^INCI(incId,1),"^",10)
    ....s bUomDesc=##class(PHA.COM.Data.Base).UomDesc(bUomId)
    ....s reqHistory=##class(PHA.IP.COM.Base).Translate("已申请未退")_" : <b>"_reqedQty_"</b></br><span style=visibility:hidden>得得得</span>"_##class(PHA.IP.COM.Base).Translate("已退")_" : <b>"_retedQty_"</b>"
    ....s (reqReasonId,reqReasonDesc,oeoriSign)=""
    ....s itmAddId=$o(^DHCITMINFO(0,"INCI",incId,"")) 
    ....i itmAddId'="" d
    .....s cantRetReasonId=$p(^DHCITMINFO(itmAddId),"^",46)
    .....s cantRetReason= ##class(PHA.COM.Data.Base).RefRetCode(+cantRetReasonId)
    ....e  s cantRetReason=""
    ....i (canRetFlag="N")&&(has60="Y") s cantRetReason = ##class(PHA.IP.COM.Base).Translate("静配已配置") // @translate
    ....i (canRetFlag="N")&&(pogPackFlag="Y") s cantRetReason = ##class(PHA.IP.COM.Base).Translate("静配已打包完成交接") // @translate
    ....i canRetQty'="" s canRetQty=$fn(canRetQty,"",$l($p(canRetQty,".",2)))
    ....i dspQty'="" s dspQty=$fn(dspQty,"",$l($p(dspQty,".",2)))
    ....s data1=recLocId_"^"_recLocDesc_"^"_incCode_"^"_incDesc_"^"_canRetQty
    ....s data2=canRetQty_"^"_dspQty_"^"_bUomDesc_"^"_dspId_"^"_reqReasonId
    ....s data3=reqReasonDesc_"^"_docLocDesc_"^"_doseDateTime_"^"_encryptLevel_"^"_patLevel
    ....s data4=wardLocId_"^"_oeoriSign_"^"_reqHistory_"^"_phacLbRowId_"^"_dspSubRowId
    ....s data5=inclb_"^"_cantRetReason_"^"_cyFlag_"^"_Prescno_"^"_needGrpRet
    ....s data6=canRetFlag_"^"_mDspId_"^"_firstRow_"^"_patNo_"^"_patName
    ....s data=data1_"^"_data2_"^"_data3_"^"_data4_"^"_data5_"^"_data6
    ....s sortIndex=recLocId_"^"_doseDate_"^"_mDspId 
    ....s QueryDispedData(sortIndex,dspId,phacLbRowId)=data
    ....s QueryDispedDataGrp(sortIndex)=$g(QueryDispedDataGrp(sortIndex))+1
    ...
    ..
    .
    // 输出
    s sortIndex=""
    f  s sortIndex=$o(QueryDispedData(sortIndex)) q:sortIndex=""  d
    .s ordNum=QueryDispedDataGrp(sortIndex)
    .s dspId="",oeoriNum=0
    .f  s dspId=$o(QueryDispedData(sortIndex,dspId)) q:dspId=""  d
    ..s phacLbRowId=""
    ..f  s phacLbRowId=$o(QueryDispedData(sortIndex,dspId,phacLbRowId)) q:phacLbRowId=""  d
    ...s dspData=$g(QueryDispedData(sortIndex,dspId,phacLbRowId))
    ...s oeoriNum=oeoriNum+1
    ...i oeoriNum=1  s $p(dspData,"^",28)="Y"
    ...i ordNum=1 s oeoriSign=""
    ...e  i oeoriNum=1 s oeoriSign="-1"
    ...e  i oeoriNum<ordNum s oeoriSign="0"
    ...e  i oeoriNum=ordNum s oeoriSign="1"
    ...s $p(dspData,"^",17)=oeoriSign
    ...s ^CacheTemp(repid,ind)=$lfs(dspData,"^")    
    ...s ind=ind+1
    q $$$OK
}

/// description: 病人信息
/// w ##class(web.DHCINPHA.Request).PatInfo(48)
ClassMethod PatInfo(admId)
{
    q:admId="" ""
    s (patNo, patName) = ""
    &SQL(
        SELECT 
        PAADM_PAPMI_DR->PAPMI_No,PAADM_PAPMI_DR->PAPMI_Name 
        into 
        :patNo,:patName 
        FROM 
        PA_Adm 
        WHERE 
        PAADM_RowId=:admId
    )
    q patNo_"^"_patName
}

/// description: 退药原因
/// w ##class(%ResultSet).RunQuery("web.DHCINPHA.Request","BLCReasonForRefund")
Query BLCReasonForRefund(filterText = "", hospId As %String = "") As websys.Query(ROWSPEC = "RowId:%String,Description:%String")
{
}

ClassMethod BLCReasonForRefundExecute(ByRef qHandle As %Binary, filterText = "", hospId As %String = "") As %Status
{
    s repid=$I(^CacheTemp)
    s qHandle=$lb(0,repid,0)
    s ind=1
    s id=0
    f  s id=$o(^BLC("RFR",id)) q:id=""  d
    .q:(hospId'="")&&(##class(PHA.FACE.IN.Com).GetShowDataFlag("BLC_ReasonForRefund",id,hospId)="N") //医院级别授权
    .s desc=##class(PHA.COM.Data.Base).RefundReasonDesc(id)
    .q:desc=""
    .d outputRow
    Quit $$$OK
outputRow  
    s Data=$lb(id,desc)
    s ^CacheTemp(repid,ind)=Data    
    s ind=ind+1
    q
}

/// description: 数据保存前验证
ClassMethod CheckBeforeSave(phacLbRowId, reqQty)
{
    q:+phacLbRowId=0 "-1^发药孙表Id为空"
    q:+reqQty=0 "-1^申请数量为0"
    s chkExist=##class(web.DHCSTRETREQUEST).CheckReqExist(phacLbRowId)
    q:chkExist'="" "-1^存在未退药的退药申请"
    s allowRet=##class(web.DHCSTPHARETURN).AllowReturnByPhacLb(phacLbRowId,reqQty)
    q:allowRet'=1 "-1^申请数量大于可退数量"
    q 0
}

/// Description: 多病区保存,需按病区或医技科室重新排序
ClassMethod SaveMulti(pData, pUserId, pLocId)
{
    k SaveMultiData
    q:pUserId="" "-1^用户Id为空"
    q:pData="" "-1^无可用保存数据"
    /* 排序 */
    s len=$l(pData, ",")
    f i=1:1:len d
    .s data=$p(pData,",",i)
    .q:data=""
    .s dspId=$p(data,"^",1)
    .s phacItmLbID=$p(data,"^",4)
    .s dspData=$g(^DHCOEDISQTY(dspId))
    .s oeori=$p(dspData,"^",1)
    .s admId=$p(dspData,"^",26)
    .s recLoc=$p(dspData,"^",24)
    .s admType=$p(^PAADM(admId),"^",2)
    .i admType="E" d
    ..s locId=##class(web.DHCSTCOMMONSRV).GetEMLoc(admId)  // 留观
    .e  d
    ..s wardId=$p(^DHCPHAC(+phacItmLbID),"^",4)
    ..i wardId'="" s locId=$p(^PAWARD(wardId),"^",5)       // 特殊科室
    ..e  d
    ...s locId=##Class(web.DHCSTKUTIL).UserDept(oeori) // 特殊科室即为医生科室
    .i '$d(SaveMultiData("Data",recLoc,locId)) d
    ..s SaveMultiData("Data",recLoc,locId)=data
    .e  d
    ..s SaveMultiData("Data",recLoc,locId)=$g(SaveMultiData("Data",recLoc,locId))_","_data
    /* 保存 */
    s i=0
    s recLoc=""
    f  s recLoc=$o(SaveMultiData("Data",recLoc)) q:recLoc=""  d
    .s locId=""
    .f  s locId=$o(SaveMultiData("Data",recLoc,locId)) q:locId=""  d
    ..s data=SaveMultiData("Data",recLoc,locId)
    ..s saveRet=..Save(data,pUserId,locId)
    ..s i=i+1
    ..s SaveMultiData("Ret",i)=saveRet
    /* 汇总返回值数据 */
    s retInfo=""
    s i=""
    f  s i=$o(SaveMultiData("Ret",i)) q:i=""  d
    .s ret=SaveMultiData("Ret",i)
    .i $p(ret,"^",1)=0 d
    ..i $p(retInfo,"^",2)="" d
    ...s $p(retInfo,"^",2)=$p(ret,"^",2)
    ..e  d
    ...s $p(retInfo,"^",2)=$p(retInfo,"^",2)_"</br>"_$p(ret,"^",2)
    .e  d
    ..i $p(retInfo,"^",3)="" d
    ...s $p(retInfo,"^",3)=$p(ret,"^",2)
    ..e  d
    ...s $p(retInfo,"^",3)=$p(retInfo,"^",3)_","_$p(ret,"^",2)
    q retInfo
}

/// description: 保存
ClassMethod Save(inputDatas, userId, locId)
{
    q:userId="" "-1^用户Id为空"
    q:inputDatas="" "-1^无可用保存数据"
    s datasLen=$l(inputDatas,",")
    s datasI=""
    s errCode=""
    s curDate=+$h
    s curTime=$p($h,",",2)
    s reqStatus="Prove"
    s SuccSaveData=""
    s $zt="ThrowSave"
    ts
    s lastRecLocId=""
    s reqId=""
    f datasI=1:1:datasLen q:errCode'=""  d
    .s iData=$p(inputDatas,",",datasI)
    .q:iData=""
    .s dspId=$p(iData,"^",1)
    .s reqQty=$p(iData,"^",2)
    .s reqReasonId=$p(iData,"^",3)
    .q:(+dspId=0)||(+reqQty=0)||(+reqReasonId=0)
    .s dspData=$g(^DHCOEDISQTY(dspId))
    .q:dspData=""
    .q:$p(dspData,"^",7)'="C"
    .q:##class(web.DHCSTRETREQUEST).GetRequestFlagbyDsp(dspId)=0
    .s phacItmRowId=$p(dspData,"^",14)  
    .q:+phacItmRowId=0
    .s oeori=$p(dspData,"^",1)
    .s oeore=$p(dspData,"^",3)
    .q:oeore="" 
    .s admId=$p(dspData,"^",26)
    .s admType=$p(^PAADM(admId),"^",2)
    .i admType="E" s emPayStayStatus=##class(web.DHCSTCOMMONSRV).GetPayStayStatus(oeori)
    .e  s emPayStayStatus=""
    .s oeoreStatusDr=$p($g(^OEORD(+oeore,"I",+$p(oeore,"||",2),"X",$p(oeore,"||",3))),"^",16)
    .s oeoreStatus=$p($g(^OEC("STAT",+oeoreStatusDr)),"^",1) 
    .q:oeoreStatus'="D"
    .s dspCatCode=##class(web.DHCSTPCHCOLLS).OrdCatType(oeori)
    .s wardLocId=$p(dspData,"^",22) // 病区科室,急诊留观为开单科室但退药应为所在留观室
    .i admType="I" s wardId=$o(^PAWARD(0,"WARD_LocationDR",+wardLocId,""))
    .e  s wardId=""
    .s curWardId=$p(^PAADM(admId),"^",70)   
    .s bedId=""
    .i (wardId=curWardId)||(emPayStayStatus="Y") s bedId=$p(^PAADM(admId),"^",73)   //zhouyg 20160510 取床号修改,换病区了就是空
    .s docLocId=$p($g(^OEORD(+oeori,"I",+$p(oeori,"||",2),7)),"^",2)  ;医生科室
    .s recLocId=$p(^DHCPHAC(+phacItmRowId),"^",1)
    .s patId=$p(^PAADM(admId),"^",1) 
    .s patNo=$p(^PAPER(patId,"PAT",1),"^",1)
    .s phacLbRowId=$p(iData,"^",4)
    .s phacId=+phacLbRowId,phacCh=$p(phacLbRowId,"||",2),phacLbId=$p(phacLbRowId,"||",3)
    .// 售价
    .s sp=$p(^DHCPHAC(phacId,"I",phacCh,"B",phacLbId),"^",5)
    .s spAmt=sp*reqQty
    .s retedQty=##class(web.DHCSTPHARETURN).ReturnedQtyByPhacLb(phacLbRowId)    //已退数量
    .s reqedQty=##class(web.DHCSTRETREQUEST).GetReqQtyByPhacLb(phacLbRowId)     //已申请未退
    .s dspQty=$p(^DHCPHAC(phacId,"I",phacCh,"B",phacLbId),"^",2)                //发药数量 
    .s canRetQty=dspQty-retedQty-reqedQty                                       //还可退数量
    .q:canRetQty<=0
    .s admLocId=$p(^DHCPHAC(+phacItmRowId,"I",$p(phacItmRowId,"||",2)),"^",11)
    .s doseDate=$p(dspData,"^",21)
    .s inclb=$p(^DHCPHAC(phacId,"I",phacCh,"B",phacLbId),"^",1)
    .s dodisBatch=$p(^DHCPHAC(phacId,"I",phacCh,"B",phacLbId),"^",7)
    .i lastRecLocId'=recLocId s reqId="" // 控制按接收科室生成单据
    .s lastRecLocId=recLocId
    .i reqId=""  d
    ..s ordDept=locId
    ..i admType="E" s ordDept=##class(web.DHCSTCOMMONSRV).GetEMLoc(admId)
    ..s mainData=recLocId_"^"_patId_"^"_admId_"^"_ordDept_"^"_bedId_"^"_userId_"^"_wardLocId
    ..s reqId=##class(web.DHCSTRETREQUEST).InsertReqMain(mainData)
    .i reqId="" s errCode="-2^插入主表失败,具体信息可查看错误日志" q
    .s detailData=reqId_"^"_oeori_"^"_reqQty_"^"_sp_"^"_userId_"^"_doseDate_"^"_reqReasonId_"^"_dspId_"^"_phacLbRowId_"^"_dodisBatch_"^"_inclb
    .s reqItmId=##class(web.DHCSTRETREQUEST).InsertDetail(detailData)
    .i reqItmId="" s errCode="-2^插入子表失败,具体信息可查看错误日志" q
    .s mUpdateSystemStatus4DspD(dspId) = ""
    .s reqNo=$p(^RETRQ(reqId),"^",1)
    .s SuccSaveData(reqNo)=""
    i errCode'="" tro  q errCode
    tc
    d ##class(PHA.IP.COM.Face).UpdateSystemStatus4Dsp(.mUpdateSystemStatus4DspD, "PHAREP", userId)
    s reqNoStr=""
    s reqNo=""
    f  s reqNo=$o(SuccSaveData(reqNo)) q:reqNo=""  d
    .s reqNoStr=$s(reqNoStr="":reqNo,1:reqNoStr_"</br>"_reqNo)
    q 0_"^"_reqNoStr
ThrowSave
    s errCode=$$SqlErrorRecord^DHCSTERROR("DHCSTPHARETREQ","web.DHCINPHA.Request:Save",$ze)
    q -1_"^"_$replace($ze,"^","")
}

/// description: 删除明细
/// w ##class(web.DHCINPHA.Request).DeleteItms("60||1")
ClassMethod DeleteItms(reqItmIds)
{
    q:reqItmIds="" "-1^明细Id为空"
    s errInfoData=""
    s len=$l(reqItmIds,"^")
    s i=""
    s delAllFlag=0
    f i=1:1:len d
    .s errCode=""
    .s reqItmId=$p(reqItmIds,"^",i)
    .q:reqItmId=""
    .s reqId=+reqItmId
    .s reqItm=+$p(reqItmId,"||",2)
    .s refundFlag=$p($g(^RETRQ(+reqId,"I",reqItm)),"^",12)
    .s reqStatus=$p($g(^RETRQ(+reqId,"I",reqItm)),"^",10)
    .i (refundFlag=1)&&(reqStatus'="Execute") d
    ..s errCode=-1
    ..s errInfoData("已提前退费")=""
    .q:errCode'=""
    .i reqStatus="Execute" d
    ..s errCode=-1
    ..s errInfoData("已退药")=""
    .q:errCode'=""
    .s retedQty=+##class(web.DHCSTPHARETURN).GetReqReturnedQtyByPhaRet(reqItmId)
    .i retedQty>0 d
    ..s errCode=-1
    ..s errInfoData("已退药")=""
    .q:errCode'=""
    .&SQL(delete from dhc_pharetrequestitm where retrqi_rowid=:reqItmId)
    .d ..UpdatePhaReqForItm(reqId)
    .s chkReqRet=##class(PHA.IP.Print.Request).CheckReqDataIsNull(reqId)
    .i chkReqRet=0 s delAllFlag=1
    s errInfo="",errCode=""
    f  s errCode=$o(errInfoData(errCode)) q:errCode=""  d
    .s errInfo=$s(errInfo="":errCode,1:errInfo_"</br>"_errCode)
    q:errInfo'="" "-1^"_errInfo
    q:delAllFlag=1 1 
    q 0
}

/// description: 多选提前退费
/// w ##class(web.DHCINPHA.Request).RefundReqMulti(45,701)
ClassMethod RefundReqMulti(reqIdStr, userId)
{
    q:userId="" "-1^用户Id为空"
    q:reqIdStr="" "-1^申请单Id为空"
    s errCode=""
    k errCodeData
    s reqLen=$l(reqIdStr,",")
    s reqI=""
    f reqI=1:1:reqLen d
    .s reqId=$p(reqIdStr,",",reqI)
    .q:+reqId=0
    .s reqObj=##class(User.DHCPhaRetRequest).%OpenId(reqId,0)
    .q:reqObj=""
    .s reqNo=reqObj.RETRQReqNo
    .q:reqNo=""
    .s refRet=..RefundReq(reqId,userId)
    .i $p(refRet,"^",1)<0 d
    ..s refErrInfo=$p(refRet,"^",2)
    ..q:refErrInfo=""
    ..q:$d(errCodeData(refErrInfo))
    ..s errCodeData(refErrInfo)=""
    ..i errCode="" s errCode="-1^"_refErrInfo
    ..e  s errCode=errCode_"</br>"_refErrInfo
    q:errCode'="" errCode
    q 0
}

/// description: 申请单提前退费
ClassMethod RefundReq(reqId, userId)
{
    q:+reqId="0" "-1^申请单Id为空"
    s admId=$p(^RETRQ(reqId),"^",5)
    s admType=$p(^PAADM(admId),"^",2)
    q:admType'="I" "-1^非住院医嘱不能提前退费"
    s errCode=""
    k errCodeData
    s reqItm=""
    f  s reqItm=$o(^RETRQ(reqId,"I",reqItm)) q:reqItm=""  d
    .s reqItmId=reqId_"||"_reqItm
    .s refRet=..RefundReqItm(reqItmId,userId)
    .i $p(refRet,"^",1)<0 d
    ..s refErrInfo=$p(refRet,"^",2)
    ..q:refErrInfo=""
    ..q:$d(errCodeData(refErrInfo))
    ..s errCodeData(refErrInfo)=""
    ..i errCode="" s errCode="-1^"_refErrInfo
    ..e  s errCode=errCode_"</br>"_refErrInfo
    q:errCode'="" errCode
    q 0
}

/// description: 申请单明细提前退费
ClassMethod RefundReqItm(reqItmId, userId)
{
    s $zt="ThrowRefundReqItm"
    s reqId=+reqItmId,reqItm=$p(reqItmId,"||",2)
    q:+reqId=0 "-1^申请主表Id为空"
    q:+reqItm=0 "-1^申请子表Id为空"
    // 直接加锁
    s lockRet=##class(web.DHCST.Common.AppCommon).Lock("User.DHCPhaRetRequestItm:"_reqItmId)  
    q:lockRet<0 "-1^加锁失败"
    s reqItmObj=##class(User.DHCPhaRetRequestItm).%OpenId(reqItmId,0)
    i reqItmObj="" d ##class(web.DHCST.Common.AppCommon).UnLock("User.DHCPhaRetRequestItm:"_reqItmId) q "-1^申请明细已删除"
    s refundStatus=reqItmObj.RETRQIRefundStatus
    q:refundStatus=1 "-1^已退费"
    s oeDspObj=reqItmObj.RETRQIDoDisDr
    s dspId=oeDspObj.%Id()
    s reqQty=reqItmObj.RETRQIQty
    s surQty=##class(web.DHCSTPHARETURN).GetReqItmSurplus(reqItmId) // 剩余未退
    i surQty<=0 d ##class(web.DHCST.Common.AppCommon).UnLock("User.DHCPhaRetRequestItm:"_reqItmId) q "-1^已退药"
    s allowRet=+##class(web.DHCSTPHARETURN).AllowReturn("","",dspId,surQty)
    i allowRet'=1 d ##class(web.DHCST.Common.AppCommon).UnLock("User.DHCPhaRetRequestItm:"_reqItmId) q "-1^本次退费数量大于剩余未退数量"
    s partPay=##Class(web.DHCSTPHARETURN2).GetRetParted(dspId,surQty)
    i partPay=0 d ##class(web.DHCST.Common.AppCommon).UnLock("User.DHCPhaRetRequestItm:"_reqItmId) q "-1^存在附加费用,不允许部分提前退费"
    s oeore=oeDspObj.DSPOEOREDR.%Id()
    s dspPay=##Class(web.DHCSTKUTIL).IfRetForPaidNew(oeore)
    i dspPay=0 d ##class(web.DHCST.Common.AppCommon).UnLock("User.DHCPhaRetRequestItm:"_reqItmId) q "-1^已中途结算"
    s admId=oeDspObj.DSPAdmDR.%Id()
    s admStatus=##class(web.DHCSTCOMMONSRV).GetCurrentAdmStatus(admId)
    i admStatus=0 d ##class(web.DHCST.Common.AppCommon).UnLock("User.DHCPhaRetRequestItm:"_reqItmId) q "-1^已出院"
    TS
    s insRet=##class(web.DHCSTPHARETURN2).InsertDODIS(reqItmId,userId)
    i $p(insRet,"^",1)<0 d ##class(web.DHCST.Common.AppCommon).UnLock("User.DHCPhaRetRequestItm:"_reqItmId) TRO  q "-1^插入打包记录失败,"_insRet
    s updRet=##class(web.DHCSTPHARETURN2).UpdReqNoRefundStatus(reqItmId,"1")
    i $p(updRet,"^",1)<0 d ##class(web.DHCST.Common.AppCommon).UnLock("User.DHCPhaRetRequestItm:"_reqItmId) TRO  q "-1^更新退药申请退费标志失败,"_updRet
    s updRet=##class(web.DHCSTPHARETURN).UpdBillStatus(dspId)
    i $p(updRet,"^",1)'=0 d ##class(web.DHCST.Common.AppCommon).UnLock("User.DHCPhaRetRequestItm:"_reqItmId) TRO  q "-1^更新执行记录计费状态失败,"_updRet
    TC
    d ##class(web.DHCST.Common.AppCommon).UnLock("User.DHCPhaRetRequestItm:"_reqItmId)
    q 0
ThrowRefundReqItm
    d ##class(web.DHCST.Common.AppCommon).UnLock("User.DHCPhaRetRequestItm:"_reqItmId)
    d Error^DHCSTERROR()
    q "-1^"_$replace($ze,"^","")
}

/// Description: 删除或新增明细,重新更新主表状态
ClassMethod UpdatePhaReqForItm(ReqId)
{
    q:(ReqId = "") ""
    if (+$o(^RETRQ(ReqId, "I", ""), -1) = 0) {
        &SQL(
            DELETE FROM DHC_PhaRetRequest WHERE RETRQ_Rowid = :ReqId
        )   
    }
    s cnt = 0 
    s itm = ""
    for {
        s itm = $o(^RETRQ(ReqId, "I", itm), 1, data)
        q:(itm = "")
        s itmStatus = $p(data, "^", 10)
        s cntData(itmStatus) = $g(cntData(itmStatus)) + 1
        s cnt = cnt + 1
        q:(itmStatus = "Prove")
    }
    

    s finalStatus = ""
    if ($d(cntData("Prove"))){
        s finalStatus = "Prove"
    }else{
        
        if ($d(cntData("Execute"))) {
            s finalStatus = "Execute"
        }
        if (cnt = $g(cntData("Refuse"))) {
            s finalStatus = "Refuse"
        }
    }   
    if (+$o(^RETRQ(ReqId, "I", ""), -1) > 0)&&(finalStatus '= ""){
        &SQL(
            Update DHC_PhaRetRequest set RETRQ_Status=:finalStatus where RETRQ_Rowid=:ReqId
        )
    }
    q 0
}

/// creator:    dinghongying
/// createdate: 20181212
/// descripiton:获取病区的退药信息
/// web.DHCSTINTERFACE QueryRetInfo 调用,实际为给portal数据
/// w ##class(web.DHCINPHA.Request).GetRetInfo("2018-12-10","2018-12-13","",1)
ClassMethod GetRetInfo(StartDate, EndDate, WardID, Type)
{
    q:StartDate="" ""
    q:EndDate="" ""
    q:Type="" ""
    s pid=..NewPid()
    k ^TMP("DHCST",$this,"GetRetInfo",pid)
    s StartDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(StartDate) 
    s EndDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(EndDate)
    s n=0
    s date=""
    f date=StartDate:1:EndDate  d
    .i Type="1"   d  // 待退药
    ..s retRequestId=""
    ..f  s retRequestId=$o(^RETRQ(0,"DATE",date,retRequestId)) q:(retRequestId="")||(retRequestId=0)  d
    ...q:+retRequestId=0
    ...s retNo=$p(^RETRQ(retRequestId),"^",1)            //退药单号,申请按申请单号
    ...s admId=$p(^RETRQ(retRequestId),"^",5)            //就诊id
    ...s wardDr=$p(^RETRQ(retRequestId),"^",7)  
    ...s ward=$p(^CTLOC(wardDr),"^",2) 
    ...s reqStatus=$p(^RETRQ(retRequestId),"^",14)       //申请单状态
    ...i reqStatus="Prove" s reqStatus="待退药"
    ...i reqStatus="Execute" s reqStatus="已退药" 
    ...s reqchl=""
    ...f  s reqchl=$o(^RETRQ(retRequestId,"I",reqchl)) q:reqchl=""  d
    ....q:+reqchl=0
    ....q:$p($g(^RETRQ(retRequestId,"I",reqchl)),"^",10)="Execute"
    ....s reqUserId=$p($g(^RETRQ(retRequestId,"I",reqchl)),"^",9) //退药申请人id
    ....s reqUser=$p($g(^SSU("SSUSR",reqUserId)),"^",2)            //退药申请人
    ....s reqDate=$p($g(^RETRQ(retRequestId,"I",reqchl)),"^",7)   //退药申请日期
    ....s reqQty=$p($g(^RETRQ(retRequestId,"I",reqchl)),"^",3)   //申请退药数量
    ....s inciid=$p($g(^RETRQ(retRequestId,"I",reqchl)),"^",13)   //库存项id
    ....s inciCode=$p(^INCI(inciid,1),"^",1)
    ....s inciDesc=$p(^INCI(inciid,1),"^",2)               //药品名称
    ....s buomDesc=$p(^CT("UOM",$p(^INCI(inciid,1),"^",10)),"^",2) //单位
    ....s dodis=$p($g(^RETRQ(retRequestId,"I",reqchl)),"^",11)   //打包表id
    ....s oeore=$p(^DHCOEDISQTY(dodis),"^",3)               //医嘱执行id
    ....s retQty=reqQty      //退药数量,申请按申请数量
    ....s retDate=""         //退药日期
    ....s retUserId=""       //退药人id
    ....s retUser=""         //退药人
    ....s ordItemId=$p(^DHCOEDISQTY(dodis),"^",1)                   //医嘱明细id
    ....s ord=$p(ordItemId,"||",1)
    ....s itm=$p(ordItemId,"||",2)
    ....s doseQty=##class(web.DHCSTCOMMONORDER).OeoriDosage(ordItemId) //剂量
    ....d outputRetInfo
    
    .i Type="2"    d  //已退药
    ..s phaRetId=""
    ..f  s phaRetId=$o(^PHARET(0,"DATE",date,phaRetId)) q:phaRetId=""  d
    ...s reqStatus="已退药"
    ...s retDate=$p(^PHARET(phaRetId),"^",1)          //退药日期
    ...s retUserId=$p(^PHARET(phaRetId),"^",3)        //退药人id
    ...s retUser=$p($g(^SSU("SSUSR",+retUserId)),"^",2)   //退药人
    ...s retNo=$p(^PHARET(phaRetId),"^",7)            //退药单号
    ...s wardDr=$p(^PHARET(phaRetId),"^",6)          
    ...s ward=$p(^CTLOC(wardDr),"^",2)            //病区
    ...s retchl=""
    ...f  s retchl=$o(^PHARET(phaRetId,"I",retchl)) q:retchl=""  d
    ....s retRequestId=$p(^PHARET(phaRetId,"I",retchl),"^",7)  //退药申请子表id
    ....s reqchl=$p(retRequestId,"||",2)
    ....i retRequestId'="" d
    .....s reqUserId=$p($g(^RETRQ(+retRequestId,"I",reqchl)),"^",9) //退药申请人id
    .....s reqUser=$p($g(^SSU("SSUSR",reqUserId)),"^",2)            //退药申请人
    .....s reqDate=$p($g(^RETRQ(+retRequestId,"I",reqchl)),"^",7)   //退药申请日期
    ....e  d
    .....s reqUserId=""
    .....s reqUser=""
    .....s reqDate=""
    ....s retQty=$p(^PHARET(phaRetId,"I",retchl),"^",2)             //退药数量
    ....s dodis=$p(^PHARET(phaRetId,"I",retchl),"^",13)             //打包表id
    ....s OrdItemId=$p(^DHCOEDISQTY(dodis),"^",1)                   //医嘱明细id
    ....s ord=$p(OrdItemId,"||",1)
    ....s itm=$p(OrdItemId,"||",2)
    ....s doseQty=##class(web.DHCSTCOMMONORDER).OeoriDosage(OrdItemId) 
    ....s admId=$p(^PHARET(phaRetId,"I",retchl),"^",8)              //就诊id
    ....s admLocId=$p(^PAADM(admId),"^",4)
    ....s admLocDesc=$p($g(^CTLOC(+admLocId)),"^",2)
    ....s inciid=$p(^PHARET(phaRetId,"I",retchl),"^",11)
    ....s inciCode=$p(^INCI(inciid,1),"^",1)
    ....s inciDesc=$p(^INCI(inciid,1),"^",2)   //药品名称
    ....s buomDesc=$p(^CT("UOM",$p(^INCI(inciid,1),"^",10)),"^",2)  //单位
    ....s oeore=$p(^DHCOEDISQTY(dodis),"^",3)               //医嘱执行id
    ....d outputRetInfo
    q pid_"^"_n
outputRetInfo
    s a1=$g(admId)_"^"_$g(oeore)_"^"_$g(inciDesc)_"^"_$g(retNo)_"^"_$g(retQty)
    s a2=$g(buomDesc)_"^"_$g(doseQty)_"^"_$g(Type)_"^"_$g(reqStatus)_"^"_$g(reqDate)
    s a3=$g(reqUserId)_"^"_$g(reqUser)_"^"_$g(retDate)_"^"_$g(retUserId)_"^"_$g(retUser)_"^"_$g(wardDr)
    s data=a1_"^"_a2_"^"_a3
    s n=n+1
    s ^TMP("DHCST",$this,"GetRetInfo",pid,n)=a1_"^"_a2_"^"_a3
    q ""
}

/// description: 进程号
ClassMethod NewPid()
{
    q ##class(web.DHCSTKUTIL).NewPid($ClassName(),"IP")
}

/// Description: 退药申请是否已经彻底完成, 只要还有可退的就是未完成
/// ##class(web.DHCINPHA.Request).IsRequestFinished
ClassMethod IsRequestFinished(req) As %String
{
    s reqStatus = $p(^RETRQ(req),"^",14)
    q:(reqStatus '= "Prove") "Y"
    q "N"
}

/// Description: 获取拒绝退药信息
/// ##class(web.DHCINPHA.Request).GetRefuseData
ClassMethod GetRefuseData(reqi)
{
    s itmData = $g(^RETRQ(+reqi, "I", +$p(reqi, "||", 2)))
    s refuseReason = $p(itmData,"^",17)
    q:(refuseReason = "") ""
    s refuseReason = ##class(PHA.COM.Data.Base).RetRefReasonDesc(refuseReason)
    s refuseStatusData = ##class(BS.PHA.IN.Status).GetLastData("User.DHCPhaRetRequestItm", reqi)
    s refuseUserName = $p($g(^SSU("SSUSR", +$lg(refuseStatusData,6))), "^", 2)
    s refuseDate = ##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml($lg(refuseStatusData,4))
    s refuseTime = ##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml($lg(refuseStatusData,5))
    q refuseDate _ " " _ refuseTime _ " | " _ refuseUserName _ "</br>" _ refuseReason
}

}
