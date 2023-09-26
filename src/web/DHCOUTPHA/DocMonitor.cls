Import sqluser

/// creator:    yunhaibao
/// createdate: 2018-05-22
/// description:药师审核查询
Class web.DHCOUTPHA.DocMonitor Extends %RegisteredObject
{

/// description: 药师审核查询(仅输出)
/// w ##class(web.DHCOUTPHA.DocMonitor).JsGetRefuseMonitor("50","0","24/11/2019^03/12/2020^^^12175^^0")
ClassMethod JsGetRefuseMonitor(rows, page, inputStr = "")
{
    i +page=0 s page=1
    s collRet=..GetRefuseMonitor(rows,page, inputStr)
    s pid=$p(collRet,"^",1)
    s total=$p(collRet,"^",2)
    q:(pid="")||(+total=0) ##class(web.DHCSTJQUERYCOMMON).GetNoJson()
    s title1="phaOrdId^patNo^patName^incDesc^dosage"
    s title2="freqDesc^instrucDesc^qtyDesc^reasonDesc^userName"
    s title3="opDateTime^passWay^doseDate^doctorName^phNotes"
    s title4="orderStoped"
    s title=title1_"^"_title2_"^"_title3_"^"_title4
    s outputI="",count=0
    f  s outputI=$o(^||TMP("DHCST",$ClassName(),"GetRefuseMonitor",pid,outputI)) q:outputI=""  d
    .s outputData=^||TMP("DHCST",$ClassName(),"GetRefuseMonitor",pid,outputI)
    .s count=count+1
    .i count=1 d
    ..w ##class(web.DHCSTJQUERYCOMMON).GetJsonStartString(total)
    ..w ##class(web.DHCSTJQUERYCOMMON).getJsonData(title,outputData,"^")
    .e  d
    ..w ","_##class(web.DHCSTJQUERYCOMMON).getJsonData(title,outputData,"^")
    i count>0   w ##class(web.DHCSTJQUERYCOMMON).getJsonEndSign()
    e  w ##class(web.DHCSTJQUERYCOMMON).GetNoJson()
    q ""
}

/// description: 药师审核查询(仅输出)
ClassMethod GetRefuseMonitor(rows, page, inputStr)
{
    s pid=..CollectRefuseMonitor(inputStr)
    q:pid="" ""
    s EndRow=page*rows  
    s StartRow=((page-1)*rows)+1 
    s recordCnt=0,total=0
    s sortIndex=""
    f  s sortIndex=$o(^||TMP("DHCST",$ClassName(),"CollectRefuseMonitor",pid,sortIndex)) q:sortIndex=""  d
    .s phaOrdId="",lastPhaOrdId=""
    .f  s phaOrdId=$o(^||TMP("DHCST",$ClassName(),"CollectRefuseMonitor",pid,sortIndex,phaOrdId))  q:phaOrdId=""  d
    ..// 主信息
    ..s total=total+1
    ..q:total<StartRow
    ..q:total>EndRow
    ..s phaOrdData=^DHCPHORDM(phaOrdId)
    ..q:$p(phaOrdData,"^",2)="D"
    ..s appType=$p(phaOrdData,"^",9)
    ..s appTypeDesc=""
    ..i appType="OA" d
    ...s appTypeDesc="处方审核"
    ..e  i appType="OR" d
    ...s appTypeDesc="拒绝发药"
    ..e  i appType="IA" d
    ...s appTypeDesc="医嘱审核"
    ..e  i appType="PIVAS" d
    ...s appTypeDesc="配伍审核"
    ..s userId=$p(phaOrdData,"^",1)     // 操作人
    ..s userName=$p($g(^SSU("SSUSR",+userId)),"^",2)
    ..s operateDate=$p(phaOrdData,"^",3)  // 审核日期
    ..s operateDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(operateDate,"OP")
    ..s operateTime=$p(phaOrdData,"^",4)  // 审核时间
    ..s operateTime=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(operateTime,"OP")
    ..s opDateTime=operateDate_"</br>"_operateTime
    ..s phNote=$p(phaOrdData,"^",6)  // 药师备注,静配该字段以|@|分割操作内容
    ..i phNote["|@|" s phNote=$p(phNote,"|@|",3)    
    ..s docNote=$p(phaOrdData,"^",7) // 医生备注
    ..s firstPhaOrdItm=$o(^DHCPHORDM(phaOrdId,"I",0))
    ..s firstOeori=$p(^DHCPHORDM(phaOrdId,"I",firstPhaOrdItm),"^",2)
    ..s orderStoped=..IsOrderStoped(firstOeori)
    ..
    ..// 汇总明细医嘱Id,原因Id(原因合并显示)
    ..k GetRefuseMonitorData
    ..s phaOrdItm="",reasonStr="",reasonNum=0
    ..f  s phaOrdItm=$o(^DHCPHORDM(phaOrdId,"I",phaOrdItm)) q:phaOrdItm=""  d
    ...q:+phaOrdItm=0
    ...s phaOrdItmData=^DHCPHORDM(phaOrdId,"I",phaOrdItm)
    ...s oeori=$p(phaOrdItmData,"^",2) 
    ...q:oeori=""
    ...s admId=$p($g(^OEORD(+oeori)),"^",1)
    ...s admType=$p(^PAADM(admId),"^",2)
    ...s reasonId=$p(phaOrdItmData,"^",3) // 审核原因
    ...q:reasonId=""
    ...s GetRefuseMonitorData("Oeori",oeori)=phaOrdItmData
    ...q:$d(GetRefuseMonitorData("Reason",oeori,reasonId))
    ...s reasonDesc=##class(PHA.COM.Data.Base).CNTSReasonDesc(reasonId)
    ...s reasonNum=reasonNum+1
    ...//s reasonDesc="▪"_reasonDesc
    ...i '$d(GetRefuseMonitorData("ReasonStr",oeori)) d
    ....s GetRefuseMonitorData("ReasonStr",oeori)=reasonDesc
    ...e  d
    ....s GetRefuseMonitorData("ReasonStr",oeori)=GetRefuseMonitorData("ReasonStr",oeori)_"</br>"_reasonDesc
    ...s GetRefuseMonitorData("Reason",oeori,reasonId)=""
    ..// 配液中心仅存了主医嘱Id,涉及多选拒绝
    ..i appType="PIVAS" d
    ...s mOeori=$o(GetRefuseMonitorData("Oeori",""))
    ...q:mOeori=""
    ...s ordItm=""
    ...f  s ordItm=$O(^OEORDi(0,"OEORI",+mOeori,mOeori,ordItm)) Q:ordItm=""  D
    ....s oeori=+mOeori_"||"_ordItm
    ....s arcItmId=$P($g(^OEORD(+oeori,"I",+$p(oeori,"||",2),1)),"^",2)
    ....S arcItmCatId=$p($g(^ARCIM(+arcItmId,+$p(arcItmId,"||",2),1)),"^",10)
    ....q:$p($g(^ARC("IC",+arcItmCatId)),"^",7)'="R"
    ....s GetRefuseMonitorData("Oeori",oeori)=""
    ..s oeori="",oeoriNum=0
    ..f  s oeori=$o(GetRefuseMonitorData("Oeori",oeori)) q:oeori=""  d
    ...s oeoriNum=oeoriNum+1
    ...i oeoriNum>1 s reasonStr=""
    ...s phaOrdItmData=GetRefuseMonitorData("Oeori",oeori)
    ...s ordId=+oeori,ordItm=$p(oeori,"||",2)
    ...s admId=$p(^OEORD(ordId),"^",1)
    ...s admType=$p(^PAADM(admId),"^",2)
    ...s arcItmId=$p(^OEORD(ordId,"I",ordItm,1),"^",2)
    ...s instruDesc=$p(##class(web.DHCSTCOMMONORDER).OeoriInstruc(oeori),"^",2)
    ...s freqDesc=$p(##class(web.DHCSTCOMMONORDER).OeoriFreq(oeori),"^",3)
    ...s dosage=##class(web.DHCSTCOMMONORDER).OeoriDosage(oeori)
    ...s patId=$p(^PAADM(admId),"^",1)
    ...s patNo=$p(^PAPER(patId,"PAT",1),"^",2) 
    ...s patName=$p(^PAPER(patId,"ALL"),"^",1)
    ...// 计算数量
    ...s dspId=$o(^DHCOEDISQTY(0,"OEORI",oeori,""))
    ...q:dspId=""
    ...s arcimDesc=$p(^ARCIM(+arcItmId,$p(arcItmId,"||",2),1),"^",2)
    ...s arcimDesc = ##class(PHA.FACE.IN.Com).GetTransDesc("User.ARCItmMast","ARCIMDesc", "", arcimDesc)
    ...s Phcdf=##class(web.DHCST.Common.DrugInfoCommon).GetPhcdfByArcim(arcItmId)
    ...s inci=$o(^INCI(0,"ARCIM_DR",+arcItmId,""))
    ...s phcUom=$p($g(^PHCD(+Phcdf,"DF",$p(Phcdf,"||",2),2)),"^",4) // 药学单位
    ...s structMode=$p(##class(web.DHCST.Common.DrugInfoCommon).GetIncStkCatGrp(inci),"^",7)
    ...s finalUom=phcUom,finalQty=$p(^DHCOEDISQTY(dspId),"^",2) // 数量与单位
    ...i structMode'="Y" d
    ....// 一对一转换
    ....s qty=finalQty
    ....s dispUom=$p($g(^OEORD(ordId,"I",ordItm,"DHC")),"^",13)
    ....i (dispUom'="")&&(admType'="I") d   // 住院的发药单位不转
    .....s qtyUomStr=##class(web.DHCSTCOMMONSRV).BQtyToPhaUomQty(inci,qty,dispUom)
    ....e  i admType="I" d // 住院转为住院发药单位
    .....s qtyUomStr=##class(web.DHCSTCOMMONSRV).BQtyToInUomQty(inci,qty)
    ....e  d               // 门诊转为门诊发药单位
    .....s qtyUomStr=##class(web.DHCSTCOMMONSRV).BQtyToOutUomQty(inci,qty)
    ....s finalUom=$p(qtyUomStr,"^",2)
    ....s finalQty=$p(qtyUomStr,"^",1)
    ...i (finalQty[".")&&($l($p(finalQty,".",2))>5) s finalQty=+$fn(finalQty,"",3)
    ...s finalQty=$fn(finalQty, "N")
    ...s phcUomDesc=$p($g(^CT("UOM",+finalUom)),"^",2)
    ...s phcUomDesc=##class(PHA.FACE.IN.Com).GetTransDesc("User.CTUOM","CTUOMDesc", "", phcUomDesc)
    ...s qtyDesc=finalQty_phcUomDesc
    ...s doseDate=$p(phaOrdItmData,"^",6)
    ...s doseDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(doseDate) 
    ...s doctorName=$p(##class(web.DHCSTCOMMONORDER).OeoriDoctor(oeori),"^",2)
    ...s reasonStr=$g(GetRefuseMonitorData("ReasonStr",oeori))
    ...i (lastPhaOrdId=phaOrdId) s (patNo,patName)=""
    ...s lastPhaOrdId=phaOrdId
    ...s data1=phaOrdId_"^"_patNo_"^"_patName_"^"_arcimDesc_"^"_dosage
    ...s data2=freqDesc_"^"_instruDesc_"^"_qtyDesc_"^"_reasonStr_"^"_userName
    ...s data3=opDateTime_"^"_appTypeDesc_"^"_doseDate_"^"_doctorName_"^"_phNote
    ...s data4=orderStoped
    ...s data=data1_"^"_data2_"^"_data3_"^"_orderStoped
    ...s recordCnt=recordCnt+1
    ...s ^||TMP("DHCST",$ClassName(),"GetRefuseMonitor",pid,recordCnt)=data
    k ^||TMP("DHCST",$ClassName(),"CollectRefuseMonitor",pid)
    q pid_"^"_recordCnt
}

/// description: 药师审核查询,按审核日期,数据不多,写清晰
/// w ##class(web.DHCOUTPHA.DocMonitor).CollectRefuseMonitor("2019-10-24^2019-10-24^^^10209^")
ClassMethod CollectRefuseMonitor(inputStr)
{
    s StDate=$p(inputStr,"^",1)
    s EdDate=$p(inputStr,"^",2)
    s RecLocId =$p(inputStr,"^",3)
    s PatNo=$p(inputStr,"^",4)
    s DoctorId=$p(inputStr,"^",5)
    s AdmId=$p(inputStr,"^",6)
    s Stat=$p(inputStr,"^",7)
    s StDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(StDate) 
    s EdDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(EdDate)
    i AdmId'="" d
    .s StDate=$p(^PAADM(AdmId),"^",6)
    .s PatId=$p(^PAADM(AdmId),"^",1)
    .s PatNo=$p(^PAPER(PatId,"PAT",1),"^",1)
    s pid=..NewPid()
    //s resultStr = "Y^N^A"
    s resultIndex = ""
    i Stat=0 s resultIndex="N"
    e  i Stat=1 s resultIndex="A"
    e  i Stat=2 s resultIndex="N"
    q:(resultIndex="") ""
    // 先获取符合条件的phaordid,处方+日期唯一
    s calcuDate=""
    f calcuDate=EdDate:-1:StDate d
    .s phaOrdId=""
    .f  s phaOrdId=$o(^DHCPHORDM(0,"DateResult",calcuDate,resultIndex,phaOrdId),-1) q:phaOrdId=""  d
    ..q:+phaOrdId=0
    ..s quitFlag=""
    ..// 审核状态
    ..s result=$p(^DHCPHORDM(phaOrdId),"^",2)
    ..// 接受 
    ..s agreeFlag=$p(^DHCPHORDM(phaOrdId),"^",8) 
    ..// 过滤-撤销
    ..s cancelUser=$p(^DHCPHORDM(phaOrdId),"^",12)
    ..q:cancelUser'=""
    ..// 过滤-无子数据
    ..s firstPhaOrdItm=+$o(^DHCPHORDM(phaOrdId,"I",""))
    ..q:firstPhaOrdItm=0
    ..i (Stat=0) d
    ...i result="Y" s quitFlag="Y" q
    ...i agreeFlag="Y" s quitFlag="Y" q
    ..e  i (Stat=1) d
    ...i result'="A" s quitFlag="Y" q
    ..e  i (Stat=2) d
    ...i agreeFlag'="Y" s quitFlag="Y" 
    ..q:quitFlag'=""
    ..s oeori=$p($g(^DHCPHORDM(phaOrdId,"I",firstPhaOrdItm)),"^",2) // 第一条就是主医嘱Id
    ..s doseDate=$p(^DHCPHORDM(phaOrdId,"I",firstPhaOrdItm),"^",6)
    ..// 过滤条件-登记号
    ..s admId=$p(^OEORD(+oeori),"^",1)
    ..s patId=$p(^PAADM(admId),"^",1)
    ..s patNo=$p(^PAPER(patId,"PAT",1),"^",2) 
    ..q:(PatNo'="")&&(PatNo'=patNo)
    ..// 过滤-开单医生
    ..s docCpId=$P($g(^OEORD(+oeori,"I",+$p(oeori,"||",2),1)),"^",11)
    ..s doctorId=$s(docCpId'="":$o(^SSU("SSUSR",0,"CTPCP",docCpId,"")),1:"") 
    ..q:(DoctorId'="")&&(DoctorId'=doctorId)
    ..s appType=$p(^DHCPHORDM(phaOrdId),"^",9)
    ..s appTypeDesc=""
    ..s lastPhaOrdId=""
    ..i (appType="OA")||(appType="HERBOA")||(appType="HERBIA") d
    ...s appTypeDesc="处方审核"
    ...d ValidOAOR
    ..e  i (appType="OR")||(appType="HERBOR")||(appType="HERBIR") d
    ...s appTypeDesc="拒绝发药"
    ...d ValidOAOR
    ..e  i appType="IA" d
    ...s appTypeDesc="医嘱审核" // yunhaibao,最后一条未撤销,即为当前
    ...d ValidIA
    ..e  i appType="PIVAS" d
    ...s appTypeDesc="配伍审核"
    ...d ValidPIVAS
    ..q:appTypeDesc=""
    ..q:quitFlag'=""
    ..// 排序
    ..s sortIndex=phaOrdId 
    ..s ^||TMP("DHCST",$ClassName(),"CollectRefuseMonitor",pid,sortIndex,phaOrdId)=""
    q pid
 // 验证门诊该条数据是否有效,门诊撤销以撤销的前一条为准 
ValidOAOR
    s prescNo=$p(^DHCPHORDM(phaOrdId,"I",firstPhaOrdItm),"^",4)
    s tmpPhaOrdId=""
    f  s tmpPhaOrdId=$o(^DHCPHORDM(0,"PrescNo",prescNo,tmpPhaOrdId),-1) q:(tmpPhaOrdId="")||(lastPhaOrdId'="")  d
    .q:+tmpPhaOrdId=0
    .q:$p(^DHCPHORDM(tmpPhaOrdId),"^",12)'="" // 撤销了
    .s lastPhaOrdId=tmpPhaOrdId
    i lastPhaOrdId'=phaOrdId s quitFlag=1 q
    q
 // 验证住院,当前住院可由拒绝直接通过
ValidIA
    s tmpPhaOrdId=""
    f  s tmpPhaOrdId=$o(^DHCPHORDM(0,"OrdItem",oeori,tmpPhaOrdId),-1) q:(tmpPhaOrdId="")||(lastPhaOrdId'="")  d
    .q:+tmpPhaOrdId=0
    .q:$p(^DHCPHORDM(tmpPhaOrdId),"^",12)'=""
    .s lastPhaOrdId=tmpPhaOrdId
    i lastPhaOrdId'=phaOrdId s quitFlag=1 q
    q
 // 验证静配该条数据是否有效
ValidPIVAS
    s doseDate=$p(^DHCPHORDM(phaOrdId,"I",firstPhaOrdItm),"^",6)
    i doseDate="" d
    .s tmpPhaOrdId=""
    .f  s tmpPhaOrdId=$o(^DHCPHORDM(0,"OrdItem",oeori,tmpPhaOrdId),-1) q:(tmpPhaOrdId="")||(lastPhaOrdId'="")  d
    ..q:+tmpPhaOrdId=0
    ..q:$p(^DHCPHORDM(tmpPhaOrdId),"^",12)'=""
    ..s lastPhaOrdId=tmpPhaOrdId
    e  d
    .s tmpPhaOrdId=""
    .f  s tmpPhaOrdId=$o(^DHCPHORDM(0,"DateOrdItem",oeori,doseDate,tmpPhaOrdId),-1) q:(tmpPhaOrdId="")||(lastPhaOrdId'="")  d
    ..q:+tmpPhaOrdId=0
    ..q:$p(^DHCPHORDM(tmpPhaOrdId),"^",12)'=""
    ..s lastPhaOrdId=tmpPhaOrdId
    i lastPhaOrdId'=phaOrdId s quitFlag=1 q
    q
}

/// description: 同意
ClassMethod Agree(phaOrdId, userId = "", LocId = "")
{
    s flag="Y"
    &SQL(Update DHC_PHAORDMONITOR set PHAOM_AgreeFlag=:flag Where PHAOM_ROWID=:phaOrdId)
    q:SQLCODE'=0 "-2^更新同意失败"    
    //处理消息
    d ##class(web.DHCSTInterfaceMessage).SendRefuseOrderMonitor(phaOrdId,"Exec")
    

    s PhaomCh=$o(^DHCPHORDM(phaOrdId,"I",""),-1)
    s PrescNo=$p(^DHCPHORDM(phaOrdId,"I",PhaomCh),"^",4)
    i PrescNo'="" d
    .//更新处方状态
    .s stateRemarks="处方审核-拒绝接受" 
    .s ret=##class(PHA.OP.COM.Method).InsetPrescState(PrescNo,userId,"20",stateRemarks)  //更新处方状态
    .s queid=+$o(^PAQUE1(0,"PrescNo",PrescNo,""))
    .//草药处方需要插入处方追踪信息
    .i $d(^PAQUE1(queid,"DHC"))  d
    ..s SqlStr="^^"_PrescNo_"^C4^"_LocId_"^"_userId
    ..d ##class(web.DHCINPHA.HMPresTrack.SqlDbPresTrack).HandlePresTrackDB(SqlStr)
    q 0
}

/// description: 申诉
/// w ##class(web.DHCOUTPHA.DocMonitor).Appeal("10755","oiuy","4634","110")
ClassMethod Appeal(phaOrdId, appealText, userId = "", LocId = "")
{
    s ^||TMPDHCSTPARAMS("web.DHCOUTPHA.DocMonitor","Appeal")=$lb(phaOrdId, appealText, userId , LocId )
    q:appealText="" "-1^申诉原因为空"
    q:+phaOrdId=0 "-1^审核phaOrdId为空"
    q:'$d(^DHCPHORDM(phaOrdId)) "-1^已不存在该审核记录"
    
    s firstPhaOrdItm=$o(^DHCPHORDM(phaOrdId,"I",0))
    s firstOeori=$p(^DHCPHORDM(phaOrdId,"I",firstPhaOrdItm),"^",2)
    s orderStoped=..IsOrderStoped(firstOeori)
    q:orderStoped="Y" "-1^医嘱已全部作废或取消,无法申诉"
    s docNote=$p(^DHCPHORDM(phaOrdId),"^",7)  //医生备注
    i docNote'="" S appealText=docNote_"/"_appealText
    s result="A"
    &SQL(Update DHC_PHAORDMONITOR set PHAOM_DocNote=:appealText,PHAOM_Result=:result Where PHAOM_ROWID=:phaOrdId)
    q:SQLCODE'=0 "-1^更新申诉信息失败"
    s phaOrdItm=$o(^DHCPHORDM(phaOrdId,"I",""))
    q:+phaOrdId=0 0
    s oeori=$p(^DHCPHORDM(phaOrdId,"I",phaOrdItm),"^",2)
    q:+oeori=0 "-1^审核记录获取不到医嘱ID"
    s admId=$p($g(^OEORD(+oeori)),"^",1)
    //发送申诉消息至基础平台,yunhaibao20170216
    d ##class(web.DHCSTInterfaceMessage).SendRefuseOrderMonitor(phaOrdId,"Exec")        // 读取
    d ##class(web.DHCSTInterfaceMessage).SendAppealOrderMonitor(phaOrdId,"Send",userId) // 发送
    s PrescNo=$p(^DHCPHORDM(phaOrdId,"I",phaOrdItm),"^",4)
    i PrescNo'="" d
    .//更新处方状态
    .s stateRemarks="处方审核-拒绝申诉" 
    .s ret=##class(PHA.OP.COM.Method).InsetPrescState(PrescNo,userId,"20",stateRemarks)  //更新处方状态
    .//草药处方需要插入处方追踪信息
    .s queid=+$o(^PAQUE1(0,"PrescNo",PrescNo,""))
    .i $d(^PAQUE1(queid,"DHC"))  d
    ..s SqlStr="^^"_PrescNo_"^C3^"_LocId_"^"_userId
    ..d ##class(web.DHCINPHA.HMPresTrack.SqlDbPresTrack).HandlePresTrackDB(SqlStr)
    q 0
}

/// Description: 关联医嘱是否全部作废
/// Return:      Y - 是
/// w ##class(web.DHCOUTPHA.DocMonitor).IsPrescStoped()  
ClassMethod IsOrderStoped(pOeori)
{
    s retFlag="Y"
    s adm=$p(^OEORD(+pOeori),"^",1)
    s admType=$p(^PAADM(adm),"^",2)
    s prescNo=$p($g(^OEORD(+pOeori,"I",+$p(pOeori,"||",2),1)),"^",14)
    s que=+$o(^PAQUE1(0,"PrescNo",prescNo,""))
    i que>0 d
    .s findType="Presc"
    e  d
    .i admType="I" s findType="Oeori"
    .e  s findType="Presc"
    
    i findType="Presc" d
    .s ordId=""
    .f  s ordId=$o(^OEORD(0,"PrescNo",prescNo,ordId)) q:ordId=""  d
    ..s ordItm=""
    ..f  s ordItm=$o(^OEORD(0,"PrescNo",prescNo,ordId,ordItm)) q:ordItm=""  d
    ...s oeori=ordId_"||"_ordItm
    ...s oeoriStatCode=$p(##class(web.DHCSTCOMMONORDER).OeoriStat(oeori),"^",1)
    ...i "VE"[oeoriStatCode s retFlag="N"
    e  d
    .s mOeori=##class(web.DHCSTCOMMONORDER).GetMainOeori(oeori)
    .s mOrd=+mOeori
    .s mOrdItm=+$p(mOeori,"||",2)
    .s oeoriStatCode=$p(##class(web.DHCSTCOMMONORDER).OeoriStat(mOeori),"^",1)
    .i "VE"[oeoriStatCode s retFlag="N" q
    .s ordItm=""
    .f  s ordItm=$O(^OEORDi(0,"OEORI",+mOeori,mOrd,ordItm)) q:(ordItm="")||(retFlag="N")  d
    ..s oeori=mOrd_"||"_ordItm
    ..s oeoriStatCode=$p(##class(web.DHCSTCOMMONORDER).OeoriStat(oeori),"^",1)
    ..i "VE"[oeoriStatCode s retFlag="N"
    q retFlag
}

/// description: 进程号
ClassMethod NewPid()
{
    q ##class(web.DHCSTKUTIL).NewPid("web.DHCOUTPHA.DocMonitor","OP")
}

/// 医嘱作废后调用, 如果是医嘱审核拒绝, 则置为接受状态
/// Return: $$$OK- 成功 , 否则- 失败信息
/// Debug:  w ##class(web.DHCOUTPHA.DocMonitor).AcceptOnUnUseOrder("108||67",1)
ClassMethod AcceptOnUnUseOrder(oeori, user)
{
    s mOeori = ##class(PHA.COM.Order).GetMainOeori(oeori)
    s phaom = 0
    for {
        s phaom = $o(^DHCPHORDM(0, "OrdItem", mOeori, phaom)) q:(phaom = "")
        s phaomData = $g(^DHCPHORDM(phaom))
        continue:($p(phaomData, "^", 8) = "Y")
        continue:($p(phaomData, "^", 15) = "D")
        continue:($p(phaomData, "^", 12) '= "")
        continue:($p(phaomData, "^", 2) '= "N")
        d ..Agree(phaom, user)
    }
    q $$$OK
}

}
