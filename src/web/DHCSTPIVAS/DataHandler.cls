/// description: 配伍审核后状态执行的公共类
Class web.DHCSTPIVAS.DataHandler Extends web.DHCSTPIVAS.Common
{

Parameter LogSign;

/// creator:    yunhaibao
/// createdate: 2018-02-24
/// description:扫码调用
/// input:      barCode(条码), psNumber(预执行状态标识号), userId(用户Id), locId(科室Id),pogsNo(流程单号)
/// output:     $p(ret,"^",1)<0 失败,$p(ret,"^",1) 失败信息
ClassMethod ExecuteByBarCode(barCode As %String, psNumber As %String, userId As %String, locId As %String, pogsNo = "") As %String
{
    Q:(barCode["-")&&($l(barCode,"-")'=3) -1_"^标签长度错误"
    Q:barCode="" -1_"^标签为空"
    Q:psNumber="" -1_"^预执行状态为空"
    Q:userId="" -1_"^用户为空"
    s barCode=##class(web.DHCSTPIVAS.Common).BarCodeToOeore(barCode)
    S ord=$p(barCode,"||",1)
    S itm=$p(barCode,"||",2)
    s exe=$p(barCode,"||",3)
    S oeori=ord_"||"_itm
    s oeore=ord_"||"_itm_"||"_exe
    s dspId=$o(^DHCOEDISQTY(0,"OEORE",oeore,""))
    q:dspId="" -1_"^标签错误,获取不到医嘱信息"
    s grpNo=$p(^DHCOEDISQTY(dspId),"^",4)
    S mDsp=##class(web.DHCSTPIVAS.Common).GetMainDspId(dspId,grpNo)
    q:mDsp="" -1_"^标签错误,获取不到医嘱打包记录"
    s pogId=$o(^PIVA(0,"OEGRP",mDsp,grpNo,""))
    Q:pogId="" -1_"^尚未打印标签"
    Q:'$d(^PIVA(pogId)) -1_"^无此标签"
    #; S phacId=$P(^PIVA(pogId),"^",10)
    #; Q:phacId="" -1_"^取标签信息错误,获取不到Phac"
    s checkRet=..Execute(pogId,psNumber,userId,locId,pogsNo)
    q checkRet
}

/// creator:    yunhaibao
/// createdate: 2018-02-24
/// description:批量执行遍历调用、扫码获取pogId后调用
/// input:      pogId(条码), psNumber(预执行状态标识号), userId(用户Id), locId(科室Id),pogsNo(单号)
/// output:     $p(ret,"^",1)<0 失败,$p(ret,"^",1) 失败信息
ClassMethod Execute(pogId As %String, psNumber As %String, userId As %String, locId As %String = "", pogsNo = "")
{
    s hospId=$s(locId'="":$p($g(^CTLOC(locId)),"^",22),1:"")
    s locDr=$P(^PIVA(pogId),"^",7)
    s systemStat = ##class(web.DHCSTPIVAS.Common).GetSystemStat(locId)
    q:(systemStat '= $$$OK) systemStat
    s hospDr=$s(locDr'="":$p($g(^CTLOC(locDr)),"^",22),1:"")
    q:(hospDr'="")&&(hospId'="")&&(hospId'=hospDr) "-1^该记录所在院区不为本次登录的院区" 
    s mDsp=$p(^PIVA(pogId),"^",1)
    s packFlag=##class(web.DHCSTPIVAS.Common).DspPackFlag(mDsp)
    s dispFlag=##class(web.DHCSTPIVAS.Common).PsDispFlag(locDr,psNumber,packFlag) // 减库标识// 减库标识,yunhaibao20190728,配液与打包区分
    s errCode="",errDetail=""
    S phacId=$P(^PIVA(pogId),"^",10)
    s DHCOEDISQTY=$g(^DHCOEDISQTY(mDsp))
    s grpNo=$p(DHCOEDISQTY,"^",4)
    s mOeori=$p(DHCOEDISQTY,"^",1)
    s mOeore=$p(DHCOEDISQTY,"^",3)
    s recLocId=$p(DHCOEDISQTY,"^",24)
    s admId=$p(^OEORD(+mOeori),"^",1)
    s doseDate=$p(DHCOEDISQTY,"^",21)
    s auditTimes=##class(web.DHCSTPIVAS.Settings).GetAppParamProp("",recLocId,"OeAudit","AuditTimes")
    s passCode=$p(##Class(web.DHCSTPIVAS.Common).GetOrdPassState(mOeori,doseDate,auditTimes,recLocId),"^",1)
    q:(passCode'="SHTG")&&(passCode'="ZCDB") "-1^配伍审核未通过"
    s needNurAudit=##class(web.DHCSTPIVAS.Settings).GetNeedNurseAudit(recLocId)
    
    s lockRet=##class(web.DHCSTPIVAS.Common).Lock("DHCOEDispensing",mDsp)
    q:lockRet'=0 lockRet 
    
    i (needNurAudit="Y")&&(##class(web.DHCSTPIVAS.Common).NurAuditFlagByMDsp(mDsp)'="Y") d UnLockExecute s errCode ="-1_^护士未做领药审核"
    q:errCode'="" errCode
    s needStopInfo = ##class(web.DHCSTPIVAS.Common).GetNeedStopState(pogId, psNumber)
    i +needStopInfo<0 d UnLockExecute s errCode=needStopInfo_":"_$replace(mOeore,"||","-")_"^"_errDetail
    q:errCode'="" errCode
    s speStat=$P(^PIVA(pogId),"^",8)
    i speStat="R" d UnLockExecute  s errCode="-1^已拒绝配液:"_$replace(mOeore,"||","-")_"^"_errDetail
    e  i speStat="S" d UnLockExecute  s errCode="-1^已打印停止签:"_$replace(mOeore,"||","-")_"^"_errDetail
    q:errCode'="" errCode
    s psRowId=##class(web.DHCSTPIVAS.Common).GetPivaStateId(locDr,"I",psNumber)
    I psRowId="" d UnLockExecute s errCode="-1^不存在该配液状态:"_$replace(mOeore,"||","-")_"^"_errDetail
    q:errCode'="" errCode
    s curPsId=$P(^PIVA(pogId),"^",6)
    s curPsNumber=$P(^PIVAS(curPsId),"^",1)
    i curPsNumber=psNumber d UnLockExecute s errCode="-1^已执行过:"_$replace(mOeore,"||","-")_"^"_errDetail
    q:errCode'="" errCode
    i (curPsNumber'<60)&(psNumber<60) d UnLockExecute s errCode="-1^已计帐,不能执行:"_$replace(mOeore,"||","-")_"^"_errDetail
    s nextExeStr=##class(web.DHCSTPIVAS.Common).GetNextPsState(curPsId,locDr,"I",packFlag)
    s nextPsnumber=$p(nextExeStr,"^",2)
    i nextPsnumber'=psNumber d UnLockExecute s errCode="-1^配液状态不为"_$p(^PIVAS(psRowId),"^",2)_":"_$replace(mOeore,"||","-")_"^"_errDetail
    q:errCode'="" errCode
    // 判断欠费状态
    s oeoreStr = ##class(web.DHCSTPIVAS.Common).GetOeoreStrByPog(pogId)
    s amtRet= ##class(web.DHCSTPCHCOLLS2).CheckArrearsNew("", admId, oeoreStr, recLocId)
    i amtRet="N" d UnLockExecute s errCode="-1^已欠费:"_$replace(mOeore,"||","-")_"^"_errDetail
    q:errCode'="" errCode

    TSTART
    S updRet=..UpdPog(pogId,psRowId,userId,pogsNo)  //1 处理 PIVA_OrdGrp系列表
    i +updRet'=0 d TRollback s errCode=updRet_"^"_errDetail
    q:+updRet'=0 errCode
    /// 配置状态时处理库存
    I dispFlag="Y" s dispRet=..Dispensing(pogId,userId)
    e  s dispRet=0
    i +dispRet'=0 d TRollback s errCode=dispRet_"^"_errDetail
    q:+dispRet'=0 errCode
    // 收配置费
    s feeFlag=##class(web.DHCSTPIVAS.Common).GetPsFeeFlag(locDr,psNumber)
    i feeFlag="Y" s feeRet=..InsertOrder(pogId,userId)
    e  s feeRet=0
    i +feeRet'=0 d TRollback s errCode=feeRet_"^"_errDetail
    q:+feeRet'=0 errCode 
    TCOMMIT
    d UnLockExecute
    i dispFlag="Y" d ##class(web.DHCSTPIVAS.DataCenter).MakeBill(pogId,userId)
    Q 0_"^执行成功"
UnLockExecute
    i $d(mDsp) d ##class(web.DHCSTPIVAS.Common).UnLock("DHCOEDispensing",mDsp)
    q
TRollback
    TROLLBACK
    d UnLockExecute
    Q "-1^"_$ze
}

/// description: 统一更新配液状态并插入配液状态记录
/// w ##class(web.DHCSTPIVAS.DataHandler).UpdPog()
ClassMethod UpdPog(pogId As %String, psId As %String, userId As %String, pogsNo = "") As %String
{
    &SQL(Update PIVA_OrdGrp set POG_PS_Dr=:psId Where pog_rowid=:pogId)

    i SQLCODE'=0 d
    .d ErrorRecord^DHCSTERROR("Update:User.PIVAOrdGrp","更新",SQLCODE_":"_%msg)
    Q:SQLCODE'=0 -1_"^更新User.PIVAOrdGrp失败"
    S insRet=..InsOrdGrpState(pogId,userId,psId,pogsNo)
    Q insRet
}

/// description: 统一插入配液状态记录
/// parref + 状态 = 唯一记录
/// w ##class()
ClassMethod InsOrdGrpState(pogId As %String, userId As %String, psId As %String, pogsNo = "") As %String
{
    q ##class(web.DHCSTPIVAS.DataCenter).InsOrdGrpState(pogId, userId, psId, pogsNo)
}

/// description: 处理库存
/// others:      本方法没事务,供其他方法调用
ClassMethod Dispensing(pogId, userId)
{
    q ##class(web.DHCSTPIVAS.DataCenter).Dispensing(pogId, userId)
}

/// creator:    yunhaibao
/// createdate: 20160112
/// description:配液配置后调用账单程序,一次打签adm必然一样
/// w ##class(web.DHCSTPIVAS.DataHandler).MakeBill(107,1)
ClassMethod MakeBill(pog, userId) As %String
{
    q ##class(web.DHCSTPIVAS.DataCenter).MakeBill(pog, userId)
}

/// description: 配液大类绑定费用,减库时同时插入医嘱表
/// input:       pogId(配液主表id),userId(操作用户Id)
/// w ##class(web.DHCSTPIVAS.DataHandler).InsertOrder(1506,711)
ClassMethod InsertOrder(pogId, userId)
{
    s grpOrder = $o(^PIVA(pogId, "O", ""))
    q:(+grpOrder > 0) 0
    q:userId="" "-1^获取不到登录用户"
    s mDsp=$P(^PIVA(pogId),"^",1)
    s mOeori=$p(^DHCOEDISQTY(mDsp),"^",1)
    s recLocId=$p(^DHCOEDISQTY(mDsp),"^",24)
    s doseDate=$P(^PIVA(pogId),"^",4)
    s hospId =$p(^CTLOC(recLocId),"^",22)
    s mOrd=+mOeori
    s admId=$p(^OEORD(mOrd),"^",1)
    //s userCPId=##class(web.SSUser).GetDefaultCareProvider(userId)
    // 改取下医嘱医生 add by zhaoxinlong 2022.09.01
    s userCPId=$p(^OEORD(mOrd, "I", $p(mOeori, "||", 2), 1),"^",11)
    s admReasonId=$p($g(^PAADM(admId,1)),"^",7)
    s admDeptId=$p($g(^PAADM(admId)),"^",70)
    s orderPriId=$o(^OECPR(0,"Code","NORM","")) // 默认医嘱优先级
    s orderStDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(+$h,"PIVA")
    s orderStTime=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml($p($h,",",2),"PIVA")
    s errCode=""
    s lnkOrdStr=##class(web.DHCSTPIVAS.Common).GetPOGLinkFee(pogId)
    i 1=1 d
    .s lnkOrdStr=##class(web.DHCSTPIVAS.Common).FiltFeeLimit(lnkOrdStr, mOrd, doseDate, hospId)
    .s loLen=$l(lnkOrdStr,"^")
    .s loI=""
    .f loI=1:1:loLen q:errCode'=""  d
    ..s lnkOrd=$p(lnkOrdStr,"^",loI)
    ..q:lnkOrd=""
    ..i userCPId="" s errCode="-1^医护人员未维护该用户,无法插入配置费用"
    ..q:errCode'=""
    ..s arcItmId=$p(lnkOrd,"@",1)
    ..s qty=$p(lnkOrd,"@",2)
    ..s arcSub=$p(arcItmId,"||",1),arcVer=$p(arcItmId,"||",2)
    ..s arcItmCat=$p(^ARCIM(arcSub,arcVer,1),"^",10)
    ..s orderType=""
    ..i arcItmCat'="" s orderType=$p($g(^ARC("IC",+arcItmCat)),"^",7)
    ..s sp=""
    ..s oeoriStr1=arcItmId_"^"_orderType_"^"_orderPriId_"^"_orderStDate_"^"_orderStTime
    ..s oeoriStr2=""_"^"_sp_"^"_recLocId_"^"_admReasonId_"^"_""_"^"_""
    ..s oeoriStr3=""_"^"_""_"^"_qty_"^"_""_"^"_""
    ..s oeoriStr4=""_"^"_""_"^"_""_"^"_""_"^"_""  //19 loI
    ..s oeoriStr5=""_"^"_""_"^"_""_"^"_""_"^"_""_"^"_""_"^"_""_"^"_""
    ..s oeoriStr=oeoriStr1_"^"_oeoriStr2_"^"_oeoriStr3_"^"_oeoriStr4_"^"_oeoriStr5
    ..//s ordRet=##Class(web.DHCOEOrdItem).InsertOrderItem(admId,oeoriStr,userId,recLocId,userCPId,"")
    ..s ordRet=##class(PHA.FACE.IN.Com).SaveOrderItems(admId,oeoriStr,userId,recLocId,userCPId,"")
    ..// 返回值:
    ..s ordRetVal=$P(ordRet,"^",1)
    ..i ordRetVal=100 s errCode="-2^插入附加配置费用失败" q
    ..s insRet=..InsertOrdGrpOrder(pogId,ordRet) // 配液记录与配置费医嘱关联
    ..i $p(insRet,"^",1)<0 s errCode="-2^关联附加配置费用失败"_insRet q
    q:errCode'="" errCode
    q 0
}

/// creator:    yunhaibao
/// createdate: 2018-03-11
/// description:将配液医嘱置为打包或取消打包
/// input:      mDsp(主打包Id)
/// w ##class(web.DHCSTPIVAS.DataHandler).UpdateOeDspToPack()
ClassMethod UpdateOeDspToPack(mDsp, pogFlag)
{
    if ('$d(^oddCOM("PHA.COM.Log"))){
        q ##class(web.DHCSTPIVAS.DataCenter).UpdateOeDspToPack(mDsp, pogFlag)
    }
    #; 增加操作日志, 2023-02-22, yunhaibao
    s phaObject = ##class(%ArrayOfDataTypes).%New()
    d phaObject.SetAt("SQLUSER.DHC_OEDispensing", "table")
    d phaObject.SetAt("医嘱打包表", "description")
    d phaObject.SetAt("配液中心医嘱打包状态", "dataDescription")
    d phaObject.SetAt("UPDATE", "type")
    #; d phaObject.SetAt($lb("DSP_OEORE_DR", "DSP_PogFlag"), "includeFields")
    d phaObject.SetAt("Y", "onlyDifferent")
    s log = ##class(PHA.COM.Log).%New()
    s log.PHAObject = phaObject
    d log.PHAStart(mDsp)
    s ret = ##class(web.DHCSTPIVAS.DataCenter).UpdateOeDspToPack(mDsp, pogFlag)
    q log.PHAEnd(mDsp)
    q ret
}

/// creator:    yunhaibao
/// createdate: 2018-07-20
/// description:批量打包
/// input:      mDspStr(主打包Id串)(^分隔)
/// w ##class(web.DHCSTPIVAS.DataHandler).UpdateOeDspToPackMulti()
ClassMethod UpdateOeDspToPackMulti(mDspStr, pogFlag)
{
    q:mDspStr="" "-1^无可用打包数据"
    s errCode=""
    s mDspLen=$l(mDspStr,"^")
    f mDspI=1:1:mDspLen d
    .s mDsp=$p(mDspStr,"^",mDspI)
    .q:mDsp=""
    .s updRet=..UpdateOeDspToPack(mDsp,pogFlag)
    .i +$p(updRet,"^",1)<0 d
    ..s updErrInfo=$p(updRet,"^",2)
    ..i errCode="" s errCode="-1^"_updErrInfo
    ..e  s errCode=errCode_"</br>"_updErrInfo
    q:errCode'="" errCode
    q 0
}

/// creator:    yunhaibao
/// createdate: 2018-04-27
/// description:配液配置费用关联
/// table:      PIVA_OrdGrpOrder
/// input:      pogId(配液主表Id),ordStr(医嘱Id信息)格式()
/// w ##class(web.DHCSTPIVAS.DataHandler).InsertOrdGrpOrder()
ClassMethod InsertOrdGrpOrder(pogId As %String, ordStr As %String) As %String
{
    q ##class(web.DHCSTPIVAS.DataCenter).InsertOrdGrpOrder(pogId, ordStr)
}

/// createdate: 2019-03-13
/// description:根据退药单停配置费
/// w ##class(web.DHCSTPIVAS.DataHandler).StopOrderByRet(43,1)
ClassMethod StopOrderByRet(RetId, UserId)
{
    q:RetId="" 0
    q:UserId="" "-1^获取不到退药人"
    s errCode=""
    s retItm=""
    f  s retItm=$o(^PHARET(RetId,"I",retItm)) q:(retItm="")!(errCode'="")  d
    .s dspId=$p(^PHARET(RetId,"I",retItm),"^",13)
    .s stopRet=..StopOrderByDsp(dspId,UserId)
    .q:stopRet=""
    .i $p(stopRet,"^",1)<0 s errCode=stopRet
    q:errCode'="" errCode
    q 0
}

/// creator:    yunhaibao
/// createdate: 2018-04-27
/// description:退药成功后停止配液配置费用关联的医嘱
/// table:      PIVA_OrdGrpOrder
/// input:      dspId(打包Id),用户Id(医嘱Id信息)
/// return:     $p(retValue,"^",1)<0 失败
/// w ##class(web.DHCSTPIVAS.DataHandler).StopOrder()
ClassMethod StopOrderByDsp(dspId, userId)
{
    q:dspId="" ""
    s pogId=$o(^PIVA(0,"DSP",dspId,""))
    q:pogId="" ""
    s stopRet=..StopOrder(pogId,userId)
    q stopRet
}

/// creator:    yunhaibao
/// createdate: 2018-04-27
/// description:根据配液主表Id停止配液配置费用关联的医嘱
/// table:      PIVA_OrdGrpOrder
/// input:      pogId(打包Id),用户Id(医嘱Id信息)
/// w ##class(web.DHCSTPIVAS.DataHandler).StopOrder(185973,711)
ClassMethod StopOrder(pogId, userId)
{
    s errCode=""
    s (curDate,curTime,pinNum,doctorId)=""
    s oeoriStr=""
    s pogoItm=""
    f  s pogoItm=$o(^PIVA(pogId,"O",pogoItm)) q:pogoItm=""  d
    .q:+pogoItm=0
    .s oeori=$p(^PIVA(pogId,"O",pogoItm),"^",1)
    .q:oeori=""
    .s oeoriStatCode=$p(##class(web.DHCSTPIVAS.Common).OeoriStat(oeori),"^",1)
    .q:(oeoriStatCode'="V")&&(oeoriStatCode'="E") // 已停的就不在重复停
    .s oeoriData=oeori_"!"_curDate_"!"_curTime
    .i oeoriStr="" s oeoriStr=oeoriData
    .e  s oeoriStr=oeoriStr_"^"_oeoriData
    .s docCPId=$p($g(^OEORD(+oeori,"I",+$p(oeori,"||",2),1)),"^",11)
    .i docCPId'="" s doctorId=$o(^SSU("SSUSR",0,"CTPCP",docCPId,""))
    q:oeoriStr="" ""
    // 配置费用为临时,作废
    s unRet=##class(appcom.OEOrdItem).UnUseMulti(oeoriStr,doctorId,pinNum,"N")
    i unRet'=0 q "-1^作废配液中心关联配置费用失败,"_unRet
    q unRet
}

/// Description: 置为可退或不可退
/// w ##class(web.DHCSTPIVAS.DataHandler).SaveRetFlag("75","Y","711")
ClassMethod SaveRetFlag(POGIdStr, Flag, UserId, LogonInfo = "")
{
    //s ^PHATMP("MYQ",$this,"SaveRetFlag") = $lb(POGIdStr, Flag, UserId, LogonInfo)
    k msgData
    q:(POGIdStr = "") ..Translate("-1^无可操作数据") // @translate
    q:("YN" '[ Flag) ..Translate("-1^标志错误") // @translate
    s recLocId = $p(LogonInfo, "^", 1)
    s packReqAudit = ##class(web.DHCSTPIVAS.Settings).GetAppParamProp("",recLocId,"","PackReqAudit")
    s pivaReqAudit = ##class(web.DHCSTPIVAS.Settings).GetAppParamProp("",recLocId,"","ReqNeedAudit") 
    q:(packReqAudit'="Y")&&(pivaReqAudit'="Y") ..Translate("-1^未开始是否置为可退药功能") // @translate
    s len = $l(POGIdStr, "^")
    for i = 1 : 1 : len{
        s pog = $p(POGIdStr, "^", i)
        continue:(pog = "")
        s dsp = $p(^PIVA(pog), "^", 1)
        s oeore = $p(^DHCOEDISQTY(dsp), "^", 3)
        s packFlag = ##class(web.DHCSTPIVAS.Common).DspPackFlag(dsp)
        s oeoreStatCode = $p(##class(web.DHCSTPIVAS.Common).OeoreStat(oeore), "^", 1)
        if (oeoreStatCode '= "D"){
            s tmpValue = ..Translate("未停止执行") // @translate
            s msgData(3, tmpValue) = $g(msgData(3, tmpValue)) + 1
            continue
        }
        s lastDsp = $o(^DHCOEDISQTY(0,"OEORE", oeore, ""), -1)
        s lastDspStatus = $p(^DHCOEDISQTY(dsp), "^", 7)
        if (lastDspStatus [ "R"){
            s tmpValue = ..Translate("已退药") // @translate
            s msgData(1, tmpValue) = $g(msgData(1, tmpValue)) + 1
            continue
        }
        if ($d(^RETRQ(0, "DODIS", dsp))){
            s tmpValue = ..Translate("已退药申请") // @translate
            s msgData(2, tmpValue) = $g(msgData(2, tmpValue)) + 1
            continue    
        }
        
        if ((packFlag = "P")&&(packReqAudit '= "Y")){
            s tmpValue = ..Translate("打包医嘱") // @translate
            s msgData(6, tmpValue) = $g(msgData(6, tmpValue)) + 1
            continue    
        }
        if ((packFlag '= "P")&&(pivaReqAudit '= "Y")){
            s tmpValue = ..Translate("配液医嘱") // @translate
            s msgData(7, tmpValue) = $g(msgData(7, tmpValue)) + 1
            continue    
        }
        s allowFlag = $p(^PIVA(pog), "^", 28)
        if ((Flag = "N")&&(allowFlag '= "Y")){
            s tmpValue = ..Translate("不需置为不可退医嘱") // @translate
            s msgData(4, tmpValue) = $g(msgData(4, tmpValue)) + 1
            continue    
        }
        if ((Flag = "Y")&&(allowFlag = "Y")){
            s tmpValue = ..Translate("不需置为不可退医嘱") // @translate
            s msgData(5, tmpValue) = $g(msgData(5, tmpValue)) + 1
            continue    
        }
        &SQL(
            UPDATE SQLUSER.PIVA_OrdGrp 
            SET POG_AllowFlag = :Flag, POG_AllowUser_Dr = :UserId 
            WHERE POG_RowId=:pog
        )   
        s tmpValue = ..Translate("处理成功") // @translate
        s msgData(0, tmpValue) = $g(msgData(0, tmpValue)) + 1 
    }
    
    q:(+$o(msgData(""), -1) = 0) 0
    
    s msgLB = ""
    s i = ""
    for {
        s i = $o(msgData(i))
        q:(i = "")
        s j = ""
        for {
            s j = $o(msgData(i, j), 1, cnt)
            q:(j = "")
            s info = ..ReplaceTranslation("{{info}}的记录数:{{count}}",$lb("{{info}}",$j(j, 5)), $lb("{{count}}",cnt))  // @translate
            s msg = "<div style='line-height:28px'>" _ info_ "</div>" 
            s msgLB = msgLB _ $lb(msg)
        }
    }
    q:(msgLB = "") 0
    
    q "0^" _ $lts(msgLB, "")
}

/// description: 打签后插入住院发药主表
/// w ##class(web.DHCSTPIVAS.DataHandler).InsertDHCPHACollected(101,1,1)
ClassMethod InsertDHCPHACollected(recLocId, wardId, userId)
{
    q ##class(web.DHCSTPIVAS.DataCenter).InsertDHCPHACollected(recLocId, wardId, userId)
}

ClassMethod DeleteDHCPHACollected(phac)
{
    q ##class(web.DHCSTPIVAS.DataCenter).DeleteDHCPHACollected(phac)
}

ClassMethod UpdateOrdGrpState(pogsId As %String, pogsNo) As %String
{
    &SQL(
        UPDATE PIVA_OrdGrpState 
        SET POGS_No = :pogsNo
        WHERE POGS_RowID = :pogsId
    )
    i SQLCODE'=0 d
    .d ErrorRecord^DHCSTERROR("Update:User.PIVAOrdGrpState","更新",SQLCODE_":"_%msg)
    Q:SQLCODE'=0 -1_"更新User.PIVAOrdGrpState失败"
    Q SQLCODE
}

}
