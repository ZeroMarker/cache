Import sqluser

Class web.DHCSTPIVAS.DataCenter Extends %RegisteredObject
{

ClassMethod PIVASCNTSWAYID()
{
    &SQL(SELECT PWAY_RowID into :pwayId FROM DHC_PHCNTSWAY WHERE PWAY_Code='PIVAS' AND PWAY_Active='Y')
    q $g(pwayId)
}

/// w ##class(web.DHCSTPIVAS.DataCenter).MakeBill(78,711)
ClassMethod MakeBill(pog, userId) As %String
{
    s ret=0
    q:pog="" ""
    q:'$d(^PIVA(pog)) ""
    s adm="",oeorestr=""
    s pogsub=""
    F  S pogsub=$O(^PIVA(pog,"I",pogsub)) Q:pogsub=""  D
    .S dsp=$P(^PIVA(pog,"I",pogsub),"^",1)
    .Q:dsp=""
    .Q:'$D(^DHCOEDISQTY(dsp))
    .s oeori=$P(^DHCOEDISQTY(dsp),"^",1)
    .Q:oeori=""
    .s adm=$p($g(^OEORD(+oeori)),"^",1)
    .q:adm=""
    .q:$P(^DHCOEDISQTY(dsp),"^",7)'="C" //未发药不调用
    .S oeore=$p(^DHCOEDISQTY(dsp),"^",3)
    .i oeorestr="" s oeorestr=oeore
    .e  s oeorestr=oeorestr_"^"_oeore
    i (adm'="")&&(oeorestr'="") s ret=##Class(web.DHCSTPIVAS.Face).BILLN(adm,userId,oeorestr,1)
    q ret
}

ClassMethod DeleteDHCPHACollected(phac)
{
    &SQL(
        DELETE FROM DHC_PHACollected 
        WHERE DHC_PHACollect_RowID = :phac
    )
    q SQLCODE
}

ClassMethod InsertDHCPHACollected(recLocId, wardId, userId)
{
    s errCode=""
    s dispNo=##class(web.DHCST.Common.AppCommon).GetAppNo("DHCSTORDDISP", "", recLocId)
    q:$p(dispNo,"^",1)<0 "-2^单号加锁失败"
    s curDate=+$h
    s curTime=$p($h,",",2)
    &SQL(
        INSERT INTO DHC_PHACollected
        (DHC_PHALoc_DR, DHC_PHAWard_DR, DHC_PHAOperator, DHC_PHACollectStatus, DHC_PHAPrintDate, DHC_PHAPrintTime, DHC_PHAOrdType, DHC_PHADispNo, DHC_PHACollectDate, DHC_PHACollectTime, DHC_PHACollectUser)
        VALUES
        (:recLocId,:wardId,:userId, 'Collect',:curDate,:curTime, 'PIVA',:dispNo,:curDate,:curTime,:userId)
    )
    i SQLCODE'=0 d
    .s errMsgInfo="##class(web.DHCSTPIVAS.DataHandler).InsertDHCPHACollected("_$lts($lb(recLocId, wardId, userId))_")"
    .d ErrorRecord^DHCSTERROR("DHCSTINPIVA",errMsgInfo,SQLCODE_":"_%msg)
    .s errCode="-2^"_SQLCODE_":"_%msg
    q:errCode'="" errCode
    Q $P(%ROWID,$C(1))
}

ClassMethod InsertOrdGrpOrder(pogId As %String, ordStr As %String) As %String
{
    q:pogId="" ""
    q:ordStr="" ""
    s errCode=""
    s ordLen=$p(ordStr,"^")
    s ordI="" 
    f ordI=1:1:ordLen q:errCode'=""  d
    .s ordIStr=$p(ordStr,"^",ordI)
    .q:ordIStr=""
    .s oeori=$p(ordIStr,"*",2)
    .q:oeori=""
    .s maxSub=+$O(^PIVA(pogId,"O",""),-1)+1
    .&SQL(
        INSERT INTO PIVA_OrdGrpOrder
        (POGO_POG_Parref , POGO_ChildSub , POGO_OEORI_Dr)
        VALUES
        (:pogId,:maxSub,:oeori)
        )
    .i SQLCODE'=0 d
    ..s errCode="-2^"_SQLCODE_":"_%msg 
    ..s errMsgInfo="##class(web.DHCSTPIVAS.DataHandler).InsertOrdGrpOrder"
    ..d ErrorRecord^DHCSTERROR("DHCSTINPIVA",errMsgInfo,SQLCODE_":"_%msg)
    q:errCode'="" errCode
    q 0
}

ClassMethod UpdateOeDspToPack(mDsp, pogFlag)
{
    q:mDsp="" "-1^mDsp为空"
    q:$P(^DHCOEDISQTY(mDsp),"^",7)="C" "-1^已减库存,不能修改打包状态"
    s errInfo=""
    i pogFlag="" s pogFlag="N" // 任何形式的人为修改, 该字段都应该有值
    &SQL(UPDATE DHC_OEDispensing SET DSP_PogFlag=:pogFlag WHERE DSP_RowId=:mDsp)
    i SQLCODE'=0 d
    .s errInfo="-2^"_SQLCODE_":"_%msg 
    .s errMsgInfo="##class(web.DHCSTPIVAS.DataHandler).UpdateOeDspToPack"
    .d ErrorRecord^DHCSTERROR("DHCSTINPIVA",errMsgInfo,SQLCODE_":"_%msg)
    q errInfo
}

ClassMethod Dispensing(pogId, userId)
{
    s pogData=$g(^PIVA(pogId))
    s locId=$P(pogData,"^",7)
    s hospId=$s(locId'="":$p($g(^CTLOC(locId)),"^",22),1:"")
    s ruleFlag=##Class(web.DHCSTCOMMPARA).GetRpRule(hospId)
    S phacId=$P(pogData,"^",10)
    if (phacId ="") {
        s mDsp=$p(pogData,"^",1)
        s dspData = $g(^DHCOEDISQTY(mDsp))
        s wardLoc = $p(dspData, "^", 22)    
        s wardId = $o(^PAWARD(0, "WARD_LocationDR", wardLoc, 0))  
        s phacId = ##class(web.DHCSTPIVAS.DataHandler).InsertDHCPHACollected(locId, wardId, userId)
    }
    s errCode=""
    s pogItm=""
    f  s pogItm=$O(^PIVA(pogId,"I",pogItm)) Q:(pogItm="")||(errCode'="")  D
    .q:+pogItm=0
    .q:errCode'=""
    .S dspId=$P(^PIVA(pogId,"I",pogItm),"^",1)
    .q:dspId=""
    .q:'$d(^DHCOEDISQTY(dspId))
    .s oeori=$P(^DHCOEDISQTY(dspId),"^",1)
    .q:oeori=""
    .q:$P(^DHCOEDISQTY(dspId),"^",7)'="TC"
    .q:##class(web.DHCSTPIVAS.Common).OeoriPriority(oeori)["OM"
    .s oeore=$P(^DHCOEDISQTY(dspId),"^",3)
    .q:##class(web.DHCSTPIVAS.Common).CheckOeoreStat(oeore)'=1
    .s dispRet=##class(web.DHCINPHA.Disp.Save).Dispensing(phacId, dspId, oeori, ruleFlag,  "",  "PIVAS")
    .i +dispRet<0 s errCode=dispRet
    .//低版本的发药, 8.3之前
    .//i ruleFlag=3 d
    .//.S err=##class(web.DHCSTPCHCOLLS).DispensingByBatch(phacId,dspId,oeori)  // 处理发药及库存系列表
    .//e  d
    .//.S err=##class(web.DHCSTPCHCOLLS).Dispensing(phacId,dspId,oeori) 
    .//i err'=0 d
    .//.s incDesc=$p(##class(web.DHCSTPIVAS.Common).GetIncItmByOeori(oeori),"^",3)
    .//.s errCode="-1^库存不足:"_incDesc
    q:errCode'="" errCode
    d ##class(PHA.IN.Narc.Com).SaveNarcDispPIVAS(pogId,userId) // 毒麻药自动登记
    q errCode
}

ClassMethod InsOrdGrpState(pogId As %String, userId As %String, psId As %String, pogsNo = "") As %String
{
    Q:pogId="" -1_"^主记录Id为空"
    Q:userId="" -1_"^用户为空"
    Q:psId="" -1_"^预执行状态为空"
    q:$d(^PIVA(0,"PS",psId,pogId)) 0 
    s locId=$p(^PIVA(pogId),"^",7)
    s pogsId=$O(^PIVA(pogId,"S",""),-1)+1
    s curDate=+$h
    s curTime=$p($h,",",2)
    s sn=$i(^mdata("PIVAOrdGrpState"))
    s scanNo=##class(web.DHCSTPIVAS.Common).CalcuScanNo(pogId,userId,psId)
    &SQL(
        INSERT INTO PIVA_OrdGrpState  
        (
            POGS_POG_Parref,POGS_ChildSub,POGS_PS_Dr,POGS_SSUSR_Dr,
            POGS_Date,POGS_Time,POGS_No,POGS_Loc_Dr,POGS_SerialNo,POGS_ScanNo
        )
        VALUES 
        (
            :pogId,:pogsId,:psId,:userId,
            :curDate,:curTime,:pogsNo,:locId,:sn,:scanNo
        )
    )
    i SQLCODE'=0 d
    .d ErrorRecord^DHCSTERROR("Insert:User.PIVAOrdGrpState","插入",SQLCODE_":"_%msg)
    Q:SQLCODE'=0 -1_"^插入User.PIVAOrdGrpState失败"
    Q SQLCODE
}

/// Input: operateCode 
///             CANCEL 对应取消psNumber的操作
/// w ##class(web.DHCSTPIVAS.DataCenter).UpdateSystemStatus(3, 84673, 1, 186)
ClassMethod UpdateSystemStatus(psNumber, dsp, user, loc = "", remarks = "", operateCode = "")
{
    q:(user = "")||(dsp = "") $$$OK
    s dspData = $g(^DHCOEDISQTY(dsp))
    if (loc = ""){
        if ($d(%session)){
            s loc = %session.Data("LOGON.CTLOCID")
        }else{
            s loc = $p(dspData, "^", 24)
        }
    }
    s statusCode = $case(psNumber,
                    3:  "PIVABATCHING",
                    10: "PIVASIGN",
                    20: "PIVAALLOT",
                    30: "PIVADISCHARGE",
                    40: "PIVALABELING",
                    50: "PIVACHECK",
                    60: "PIVACONFIGURE",
                    70: "PIVAREVIEW",
                    80: "PIVALOADING",
                    85: "PIVAPRINT",
                    90: "PHAREC",
                      : "")
    if (psNumber = "Distrib60") {
        s statusCode = "PHATRANS"
    }
    if (operateCode = "CANCEL"){
        s statusCode = "C" _ statusCode
    }
    s pog = $o(^PIVA(0, "DSP", dsp, 0))
    q:(pog = "") $$$OK
    s pogItm = 0
    for {
        s pogItm = $o(^PIVA(pog, "I", pogItm), 1, itmData) q:(pogItm = "")
        s pogDsp = $p(itmData, "^", 1)
        s dspData = $g(^DHCOEDISQTY(pogDsp))
        s oeore = $p(dspData, "^", 3)
        s ret = ##class(PHA.FACE.IN.Com).UpdateSystemStatus(oeore, "", statusCode, user, loc, remarks)
    }
    q $$$OK
}

/// description: 更新配液打包表记录的打印顺序号
ClassMethod UpdatePogPNo(pogId, pNo, pDateNo = "")
{
    if (pDateNo = ""){
        &SQL(
            UPDATE SQLUSER.PIVA_OrdGrp SET POG_PNo = :pNo WHERE POG_RowId = :pogId
        )
    }else{
        &SQL(
            UPDATE SQLUSER.PIVA_OrdGrp SET POG_PNo = :pNo, POG_DateNo = :pDateNo WHERE POG_RowId = :pogId
        )
    }
    q SQLCODE
}

/// Description: 审方调用医嘱闭环
/// Debug:       w ##class(web.DHCSTPIVAS.DataCenter).UpdateSystemStatus4OeAudit(,,,,,)
ClassMethod UpdateSystemStatus4OeAudit(statusCode, mOeori, user, loc, remarks = "", operateCode = "")
{
    q:(user = "")||(mOeori = "") $$$OK
    if (operateCode = "CANCEL"){
        s statusCode = "C" _ statusCode
    }
    s oeoriList = ##class(PHA.COM.Order).GetOeoriLbByOrder(mOeori)
    for i = 1 : 1 : $ll(oeoriList){
        s oeori = $lg(oeoriList, i)
        s ret = ##class(PHA.FACE.IN.Com).UpdateSystemStatus(oeori, "", statusCode, user, loc, remarks)
    }
    q $$$OK
}

}
