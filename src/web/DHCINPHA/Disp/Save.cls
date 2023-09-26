Import sqluser

/// creator:    yunhaibao
/// createdate: 2018-10-19
/// description:住院发药保存数据 
Class web.DHCINPHA.Disp.Save Extends %RegisteredObject
{

Parameter AppName [ Final ] = "DHCSTORDDISP";

/// description: 住院发药保存 
///              每次按病区-类别保存,全院一起容易超时
///              已发药类别为基础,按关联医嘱发药,一个不能发就不能发
/// ^TMP("DHCST","web.DHCINPHA.Disp.Query","SaveData",pid,wardId,catCode,mDsp,dspId)
/// w ##class(web.DHCINPHA.Disp.Save).SaveData("D20220729P16420","184^8#^PF^18946^18946^18946^")
ClassMethod SaveData(Pid, InputStr)
{
    //s ^PHATMP("MYQ","web.DHCINPHA.Disp.Save","SaveData")=$lb(Pid, InputStr)
    k ^||TMP("DHCST", $ClassName())
    q:Pid="" "-1^获取不到进程号"
    q:InputStr="" "-1^发药参数为空"
    s PhaLocId=$p(InputStr,"^",1)
    s ToLocIndex=$p(InputStr,"^",2)
    s ToLocID=+ToLocIndex
    s Floor=$p(ToLocIndex,"#",2)
    s CatCode=$p(InputStr,"^",3)
    s CollUserId=$p(InputStr,"^",4) // 发药人
    s OperUserId=$p(InputStr,"^",5) // 摆药人
    s PrintUser=$p(InputStr,"^",6)  // 打印人
    s AuditUser=$p(InputStr,"^",7)  // 核对人
    s StartDate=""
    s EndDate=""
    s UrgentFlag=""
    s WardGrp=""
    q:ToLocID=0 "-1^取药科室为空"
    q:PhaLocId="" "-1^药房科室为空"
    q:CatCode="" "-1^发药类别为空"
    s HospId=$p(^CTLOC(PhaLocId),"^",22)
    s PhaLocConfig=##Class(web.DHCSTPHALOC).GetPhaflag(PhaLocId)
    s OweDispFlag=$p(PhaLocConfig,"^",23)   // 等于Y时,控制欠费发药
    s Params="^"_PhaLocId_"^^"_HospId
    s NeedSkinTest=##class(web.DHCST.Common.AppCommon).GetAppPropValue("DHCSTORDDISP","SKINTESTFLAG",Params) 
    s PositiveDrugCanDispFlag=##class(web.DHCST.Common.AppCommon).GetAppPropValue("DHCSTORDDISP","IfPositiveDrugAllowDisp",Params)  //阳性是否允许发药 add by zouxiang 20220412
    q:'$d(^TMP("DHCST","web.DHCINPHA.Disp.Query","SaveData",Pid,ToLocIndex,CatCode)) "-1^该科室此类别无可发药数据"
    s fDsp = $o(^TMP("DHCST","web.DHCINPHA.Disp.Query","SaveData",Pid,ToLocIndex,CatCode,0))
    s (PhacWardId, PhacDocLocId) = ""
    i fDsp'="" d
    .i ($lg(##class(PHA.IP.COM.Method).GetOrderDispWay($p(^DHCOEDISQTY(fDsp),"^",1)), 1) = "WARDDISP") d
    ..s PhacWardId=$o(^PAWARD(0,"WARD_LocationDR", ToLocID, ""))
    .e  d
    ..s PhacDocLocId = ToLocID
    k SaveDataData
    s errCode=""
    s mainData=PhaLocId_"^"_PhacWardId_"^"_OperUserId_"^"_StartDate_"^"_EndDate_"^"_CatCode_"^"_UrgentFlag_"^"_WardGrp_"^"_CollUserId_"^"_""_"^"_PrintUser_"^"_AuditUser_"^"_Floor_"^"_PhacDocLocId
    s succCnt=0
    s phacId=""
    s mDsp=""
    f  s mDsp=$o(^TMP("DHCST","web.DHCINPHA.Disp.Query","SaveData",Pid,ToLocIndex,CatCode,mDsp)) q:(mDsp="")||(errCode'="")  d
    .// 皮试相关判断
    .q:(..ValidateLinkOrderSkinTest(mDsp, NeedSkinTest, PositiveDrugCanDispFlag) = $$$NO)
    .// 过滤-欠费(配置)-OweDispFlag
    .q:(OweDispFlag="Y")&&($d(^TMP("DHCST","web.DHCINPHA.Disp.Query","AdmOweFee",Pid,$p(^DHCOEDISQTY(mDsp),"^",26))))
    .// 保存前的简易判断
    .s canDisp="1"
    .s dspId=""
    .f  s dspId=$o(^TMP("DHCST","web.DHCINPHA.Disp.Query","SaveData",Pid,ToLocIndex,CatCode,mDsp,dspId)) q:(dspId="")||(canDisp'="1")  d 
    ..i $d(^TMP("DHCST","web.DHCINPHA.Disp.Query","SaveToFilter",Pid,dspId)) s canDisp="" q
    ..// 可添加一些不复杂限制条件
    .q:canDisp'="1"
    .
    .i phacId="" d
    ..s phacId=..InsertDHCPHACollected(mainData)
    ..i phacId>0 l +^DHCPHAC(phacId)
    .i $p(phacId,"^",1)<0 d
    ..s errCode=phacId
    ..d ..SetCantDispInfo(errCode)
    .q:errCode'=""
    .
    .TSTART 
    .s dspId="",errDispCode=""
    .f  s dspId=$o(^TMP("DHCST","web.DHCINPHA.Disp.Query","SaveData",Pid,ToLocIndex,CatCode,mDsp,dspId)) q:(dspId="")||(errDispCode'="")  d 
    ..s oeori=$p(^DHCOEDISQTY(dspId),"^",1)
    ..s dispRet=..Dispensing(phacId, dspId, oeori, "")
    ..i $p(dispRet,"^",1)="-1" d
    ...s errDispCode=dispRet
    ...i errDispCode["库存不足" s SaveDataData("NoStock",Pid,dspId)=""  // 数组回滚不消失
    .i errDispCode'="" d ..SetCantDispInfo(errDispCode)
    .i errDispCode'="" TROLLBACK  q
    .TCOMMIT 
    .
    .s succCnt=succCnt+1
    .s doseDate=$p(^DHCOEDISQTY(mDsp),"^",21)
    .i doseDate'="" s DoseDateRange(doseDate)=""
    // 库存不足数据记录到临时global
    i $d(SaveDataData) d
    .merge ^TMP("DHCST","web.DHCINPHA.Disp.Save","SaveData","NoStock",Pid)=SaveDataData("NoStock",Pid)
    k SaveDataData
    q:errCode'="" errCode
    // 是否成功,子表没数据删主表
    s tmpErrorInfo = ..GetCantDispInfo()
    i tmpErrorInfo="" s tmpErrorInfo="-1^未发出药品"
    h 5
    i (phacId="") d
    .s phacId=tmpErrorInfo
    e  i (phacId'="")&&(+$o(^DHCPHAC(phacId,"I",""))=0) d
    .d ..DeleteDHCPHACollected(phacId)
    .l -^DHCPHAC(phacId)
    .s phacId=tmpErrorInfo
    e  d 
    .s StartDate=$o(DoseDateRange(""))
    .s EndDate=$o(DoseDateRange(""), -1)
    .// 更新用药日期范围以及发药状态1
    .&SQL(
        UPDATE DHC_PHACollected 
        SET DHC_PHADateFrom=:StartDate,DHC_PHADateTo=:EndDate
        WHERE DHC_PHACollect_RowID=:phacId
     )
    .d ..UpdatePhacStatus(phacId)
    .l -^DHCPHAC(phacId)
    .d ..MakeBill(phacId)
    .s phacData=$g(^DHCPHAC(phacId))
    .s finalStatus = $p(phacData, "^", 6)
    .i finalStatus = "Collect" d
    ..d ##class(PHA.IP.COM.Face).UpdateSystemStatus4PhaCollect(phacId, "PHADISP", OperUserId) // 医嘱闭环, 配药
    ..d ##class(PHA.IP.COM.Face).UpdateSystemStatus4PhaCollect(phacId, "PHACOL", CollUserId)  // 医嘱闭环, 发药
    .i finalStatus = "Confirm" d
    ..d ##class(PHA.IP.COM.Face).UpdateSystemStatus4PhaCollect(phacId, "PHADISP", OperUserId)
    .d ##class(PHA.COM.Job).Prepare("web.DHCST.HERP", "SendData", phacId,"P","") // 插入HERP中间表 add by liangjiaquan 2018-11-27
    .s narcDispParams = "P"_"^"_phacId_"^"_CollUserId_"^"_("")_"^"_("")
    .d ##class(PHA.COM.Job).Prepare("PHA.IN.Narc.Com", "SaveNarcDisp", narcDispParams, "")  // 毒麻药品自动登记. Huxt 2021-06-04
    .//k ^TMP("DHCST","web.DHCINPHA.Disp.Query","SaveData",Pid)
    d ##class(PHA.COM.Job).Execute()
    q phacId
}

/// description: 保存发药主表
/// w ##class(web.DHCINPHA.Disp.Save).InsertDHCPHACollected("1^2")
ClassMethod InsertDHCPHACollected(MainData As %String) As %String
{
    s errCode=""
    q:MainData="" "-1^入参为空" 
    s PhacLoc=$p(MainData,"^",1)
    s PhacWard=$p(MainData,"^",2)
    s PhacOperUser=$p(MainData,"^",3)
    s PhacDateFrom=$p(MainData,"^",4)
    s PhacDateTo=$p(MainData,"^",5)
    s PhacType=$p(MainData,"^",6)
    s UrgentFlag=$p(MainData,"^",7)
    s WardGrp=$p(MainData,"^",8)
    s PhacCollUser=$p(MainData,"^",9)
    s PrescNo=$p(MainData,"^",10)
    s PrintUser=$p(MainData,"^",11)
    s CollateUser=$p(MainData,"^",12) // 点击发药的核对人
    s Floor=$p(MainData,"^",13)
    i Floor=0 s Floor=""
    s DocLoc=$p(MainData,"^",14)
    s PhacDate=+$h
    s PhacTime=$p($h,",",2)
    s PhacStatus="Print"
    s PhacNo=##class(web.DHCST.Common.AppCommon).GetAppNo(..%GetParameter("AppName"),"",PhacLoc)
    q:PhacNo="" "-1^生成发药单号失败"
    &sql(
        INSERT INTO DHC_PHACollected
        (
            DHC_PHALoc_DR, DHC_PHACollectDate, DHC_PHACollectTime, DHC_PHAWard_DR, DHC_PHAOperator,
            DHC_PHACollectStatus, DHC_PHAPrintDate, DHC_PHAPrintTime, DHC_PHADateFrom, DHC_PHADateTo,
            DHC_PHAOrdType, DHC_PHACollectUser, DHC_PHADispNo, DHC_PHAPrescNo, DHC_PHAPrintUser,
            DHC_PHAOperateDate, DHC_PHAOperateTime,DHC_PHACollateUser, DHC_PHABuildFloor_DR,DHC_PHADocLoc_DR
        ) 
        VALUES 
        (
            :PhacLoc, :PhacDate, :PhacTime, :PhacWard, :PhacOperUser,
            :PhacStatus, :PhacDate, :PhacTime, :PhacDateFrom, :PhacDateTo,
            :PhacType, :PhacCollUser, :PhacNo, :PrescNo, :PrintUser,
            :PhacDate, :PhacTime, :CollateUser, :Floor, :DocLoc
        )
    )
    i SQLCODE'=0  d
    .s errInfo=SQLCODE_":"_$g(%msg)
    .s err=$$SqlErrorRecord^DHCSTERROR("InsertDHCPHACollected:DHC_PHACollected",PhacWard,errInfo)
    .s errCode="-1^InsertDHCPHACollected:"_errInfo
    q:errCode'="" errCode
    q $p(%ROWID,$c(1))
}

/// description: 保存发药子表
/// 对应打包表,不在存储金额售价
ClassMethod InsertDHCPHACollectItm(PhacId, DspId) As %String
{
    q:PhacId="" "-1^发药主表Id为空"
    q:DspId="" "-1^打包表Id为空"
    s dspData=$g(^DHCOEDISQTY(DspId))
    q:dspData="" "-1^不存在此打包表记录"
    s errCode=""
    s oeori=$p(dspData,"^",1)
    s ordId=+oeori
    s ordItm=+$p(oeori,"||",2)
    s admId=$p($g(^OEORD(ordId)),"^",1) 
    s prescNo=$p($g(^OEORD(ordId,"I",ordItm,1)),"^",14)  
    s admLocId=$p($g(^PAADM(+admId)),"^",4)
    s wardLocId=$p(dspData,"^",22)
    s bedNo=$p(##class(web.DHCSTCOMMONORDER).GetAdmBedCode(admId,wardLocId),"^",2)
    s doseDate=$p(dspData,"^",21) 
    s maxChildSub=$o(^DHCPHAC(PhacId,"I",""),-1)+1
    &SQL(
        INSERT INTO DHC_PHACollectItm
        (
            PHACI_PHAC_ParRef,PHACI_ChildSub,PHACI_Adm_DR,PHACI_PrescNo,PHACI_OEDIS_DR,
            PHACI_BED,PHACI_AdmLoc_DR,PHACI_DODIS_DR,PHACI_DateDosing
        )
        VALUES(
            :PhacId,:maxChildSub,:admId,:prescNo,:oeori,
            :bedNo,:admLocId,:DspId,:doseDate
        )
    )
    i SQLCODE'=0  d
    .s errInfo=SQLCODE_":"_$g(%msg)
    .s err=$$SqlErrorRecord^DHCSTERROR("InsertDHCPHACollectItm:DHC_PHACollectItm",DspId,errInfo)
    .s errCode="-1^InsertDHCPHACollectItm:"_errInfo
    q:errCode'="" errCode
    q $p(%ROWID,$c(1))
}

/// description: 保存发药孙表
/// 对应打包子表
ClassMethod InsertDHCPhaCollectItmLB(PhacItmId, ItmLbData) As %String
{
    s errCode=""
    q:PhacItmId="" "-1^发药子表Id为空"
    s phacId=+PhacItmId
    s locId=$p(^DHCPHAC(phacId),"^",1)
    s hospId=$p(^CTLOC(locId),"^",22)
    s inclb=$p(ItmLbData,"^",1)
    s incId=+inclb
    s bUomId=$p(^INCI(incId,1),"^",10)
    s qty=$p(ItmLbData,"^",2)   // 基本单位数量
    s sp=$p(ItmLbData,"^",3)
    s rp=$p(ItmLbData,"^",4)
    s dspSubId=$p(ItmLbData,"^",5)
    s rpAmt=rp*qty
    s spAmt=sp*qty
     //格式化数值小数位数
    S custId=##Class(web.DHCSTCOMMO).GetCusIDByHospID(hospId)
    S catGrpStr=##Class(web.DHCSTCOMINC).GetIncStkCatGrp(incId)
    S catGrpDesc=$P(catGrpStr,"^",4)
    S perv="^^^"_catGrpDesc_"^"_custId_"^DHC"
    s rpAmt=##Class(web.DHCSTCOMMPARA).GetNumbDec(rpAmt,perv,"FmtRA",1)
    s spAmt=##Class(web.DHCSTCOMMPARA).GetNumbDec(spAmt,perv,"FmtSA",1)
    s maxChildSub=$o(^DHCPHAC(phacId,"I",$p(PhacItmId,"||",2),"B",""),-1)+1
    &SQL(
        INSERT INTO DHC_PHACollectItmLB
        (
            PHACIL_PHACI_ParRef,PHACIL_ChildSub,PHACIL_INCLB_Dr,PHACIL_Qty,PHACIL_Rp,
            PHACIL_RpAmt,PHACIL_Sp,PHACIL_SpAmt,PHACIL_DSPB_Dr
        ) 
        VALUES 
        (
            :PhacItmId,:maxChildSub,:inclb,:qty,:rp,
            :rpAmt,:sp,:spAmt,:dspSubId
        )
    )
    i SQLCODE'=0  d
    .s errInfo=SQLCODE_":"_$g(%msg)
    .s err=$$SqlErrorRecord^DHCSTERROR("InsertDHCPhaCollectItmLB:DHC_PHACollectItmLB",dspSubId,errInfo)
    .s errCode="-1^InsertDHCPhaCollectItmLB:"_errInfo
    q:errCode'="" errCode
    q $p(%ROWID,$c(1))
}

/// description: 插入发药子表并处理库存,希望为所有处理明细发药的入口
/// input:       From(来自哪里调用,控制一些判断),DOCLOCDISP:医生科室发药
/// return:      $p(ret,"^",1)="-1"(发药失败,关联医嘱也不可发)
///              $p(ret,"^",1)="-2"(发药失败,关联医嘱也可发)
///              $p(ret,"^",1)=""  (发药失败,关联医嘱可发)
/// 医嘱结构改造后,发药子表直接对应打包表(1对1)
/// w ##class(web.DHCINPHA.Disp.Save).Dispensing(103,2284,"7||62",2,"")
ClassMethod Dispensing(PhacId, DspIdStr, Oeori, RuleFlag, StrictFlag = "", From = "")
{
    s RuleFlag="" //增加生效日期后,批次价判断计费点获取
    q:DspIdStr="" "-1^打包Id为空"
    q:PhacId="" "-1^发药主表为空"
    s recLocId=$p($g(^DHCOEDISQTY(+DspIdStr)),"^",24)
    s hospId=$p($g(^CTLOC(+recLocId)),"^",22)
    s arcItmId=$p($g(^OEORD(+Oeori,"I",+$p(Oeori,"||",2),1)),"^",2) 
    s arcItmCat=$p(^ARCIM(+$p(arcItmId,"||",1),+$p(arcItmId,"||",2),1),"^",10)
    s priId=$p($g(^OEORD(+Oeori,"I",+$p(Oeori,"||",2),1)),"^",8) 
    s priCode=$p($g(^OECPR(+priId)),"^",1)
    s feePoint=##Class(web.DHCSTPCHCOLLS2).GetFeePoint(arcItmCat_"^"_priCode_"^"_Oeori)
    i feePoint=1 s ruleDate=+$h // 发药计费
    e  s ruleDate=$p($g(^OEORD(+Oeori,"I",+$p(Oeori,"||",2),3)),"^",7)
    s RuleFlag=##class(web.DHCSTCOMMPARA).GetRpRule(hospId,ruleDate)
    s Params="^"_recLocId_"^^"_hospId
    s DispPriceWay=##class(web.DHCST.Common.AppCommon).GetAppPropValue("DHCSTCOMMON","DispPriceWay",Params)
    s noNeedTro=""  // 不为空时,不回滚
    s $zt="ThrowDispensing"
    s phacItmId=""
    l +^DHCOEDISPENSING(Oeori):5 e  q "-1^明细加锁失败"
    
    /* ! 事务开始 */
    TSTART
    s errCode=""
    s dspIdLen=$l(DspIdStr,",")
    s dspI=0
    f dspI=1:1:dspIdLen q:errCode'=""  d // 理论上,dspIdLen为1
    .s dspId=$p(DspIdStr,",",dspI)
    .i $p(^DHCOEDISQTY(dspId),"^",7)'="TC" s errCode="-2^不为未发药状态",noNeedTro=1 q
    .s oeore=$p(^DHCOEDISQTY(dspId),"^",3)
    .i ##class(web.DHCSTCOMMONSRV).GetOrdState(oeore)=0 s errCode="-2^执行记录已停",noNeedTro=1 q
    .i ##class(web.DHCINPHA.Disp.Query).HaveBeenRefused(dspId)="Y" s errCode="-1^已拒绝发药" q
    .s nurSeeStr=##class(web.DHCSTCOMMONSRV).GetNurseSeeType($p(oeore,"||",1,2),recLocId)
    .i (From'="DOCLOCDISP")&&($p(nurSeeStr,"^",1)="N") s errCode="-1^"_$p(nurSeeStr,"^",3) q
    .s mDsp = ##class(web.DHCSTCOMMONORDER).GetMainDspId(dspId)
    .i (From'="DOCLOCDISP")&&(From'="PIVAS")&&(##class(PHA.IP.COM.Method).GetPhaAuditFlagByDsp(mDsp)'="Y") s errCode="-1^医嘱审核未通过" q
    .
    ./* 判断是否需要重写子表并重写 */
    .s rebuildFlag=..ShouldReBuildBatch(dspId,feePoint,RuleFlag)
    .i rebuildFlag="Y" d
    ..s reRet=..ReBuildDHCOEDispBatch(dspId,ruleDate)
    ..i $p(reRet,"^",1)<0 s errCode="-1^"_$p(reRet,"^",2)
    .q:errCode'="" 
    .
    ./* 发药计费,处理价格,更新为最新 */
    .i (feePoint=1)&&(rebuildFlag'="Y") d
    ..d ##class(web.DHCINPHA.Disp.Save).UpdateOeDispPrice(dspId)
    .
    ./* 处理发药子表 */
    .s phacItmId=..InsertDHCPHACollectItm(PhacId,dspId) 
    .i $p(phacItmId,"^",1)<0 s errCode="-1^"_$p(phacItmId,"^",2)
    .q:errCode'=""
    .i +$o(^DHCOEDISQTY(dspId, "I", 0)) = 0 s errCode = "-1^尚未插入打包子表" q
    ./* 处理发药孙表 */
    .s dspSub=0
    .f  s dspSub=$o(^DHCOEDISQTY(dspId,"I",dspSub)) q:(dspSub="")||(errCode'="")  d
    ..s dspSubData=^DHCOEDISQTY(dspId,"I",dspSub)
    ..s bQty=$p(dspSubData,"^",2)
    ..s inclb=$p(dspSubData,"^",1)
    ..s incId=$p(dspSubData,"^",5)
    ..s dspSubId=dspId_"||"_dspSub
    ..d DHCPhaCollectItmLB
    .   
    ./* 更新打包表状态以及在途 */
    .i errCode="" d
    ..i +$o(^DHCPHAC(+phacItmId,"I",+$p(phacItmId,"||",2),"B",0)) = 0 s errCode = "-1^未能处理库存" q
    ..s updRet=..UpdateDHCOEDisp(phacItmId)
    ..i $p(updRet,"^",1)<0 s errCode="-1^"_$p(updRet,"^",2) q
    ..
    ../*判断临购药品限制使用数量是否充足 */  //2021-03-12 yangsj
    ..s TmpIfEoughFlag=0
    ..i (##class(%Dictionary.MethodDefinition).%ExistsId("PHA.IN.TmpDrugPurAuth.Save||UpdateUseQtyByDisp"))  d
    ...s TmpIfEoughFlag = ##Class(PHA.IN.TmpDrugPurAuth.Save).UpdateUseQtyByDisp(phacItmId,"P",hospId)
    ..i TmpIfEoughFlag'=0 s errCode="-1^"_$p(TmpIfEoughFlag,"^",2) q
    
    i (errCode'="")&&(noNeedTro="") TROLLBACK  l -^DHCOEDISPENSING(Oeori) q errCode

    /* ! 事务结束 */
    TCOMMIT
    l -^DHCOEDISPENSING(Oeori)
    q phacItmId
    
DHCPhaCollectItmLB  
    s pid=..GetInclbCounter(recLocId,incId) // 里边有锁:^DHCINCIL(recLocId,incId)
    i pid<0 s errCode="-1^分配库存进程号加锁失败" l -^DHCINCIL(recLocId,incId) q
    s rp=$p(dspSubData,"^",3)
    s sp=$p(dspSubData,"^",4)
    s incEnough=""
    
    i RuleFlag=3 d
    .s inclbQty=##class(web.DHCSTSTKQTY).GetInclbQtyForDisp(inclb)
    .i inclbQty>=bQty d
    ..s ^TMPGETINCLB(pid,$replace(inclb,"||",""))=bQty_"^"_inclb
    ..s incEnough=1 
    
    /* 重写了打包子表的此处库存不足,直接退出 */
    i (rebuildFlag="Y")&&(incEnough<=0) d
    .l -^DHCINCIL(recLocId,incId)
    .k ^TMPGETINCLB(pid)
    .s errCode="-1^库存不足"
    q:errCode'=""
    
    /* 批次价非批次价均由此重新分配库存 */
    i (incEnough<=0)||(incEnough="") d 
    .s incEnough=##CLASS(web.DHCSTSTKQTY).GetInclbQty(incId,bQty,recLocId,pid)
    i incEnough<=0 d
    .s errCode="-1^库存不足" 
    .l -^DHCINCIL(recLocId,incId)
    .k ^TMPGETINCLB(pid)
    q:errCode'=""
    
    s newClb=""
    f  s newClb=$o(^TMPGETINCLB(pid,newClb)) q:(newClb="")||(errCode'="")  d
    .s inclb=$p(^TMPGETINCLB(pid,newClb),"^",2)
    .s qty=$p(^TMPGETINCLB(pid,newClb),"^",1)
    .i DispPriceWay=2 d // 按发药当时价格, 多批次可能不同
    ..s rp=##Class(web.DHCSTPRICE).GetCurRp(inclb,"",hospId)
    ..s sp=##Class(web.DHCSTPRICE).GetCurSp(inclb,"",hospId)
    .i DispPriceWay=3 d
    ..s rp=##Class(web.DHCSTPRICE).GetCurRp(inclb,"",hospId)
    .i (RuleFlag=1)&&(DispPriceWay'=2)&&(DispPriceWay'=3) d 
    ..s rp=##Class(web.DHCSTPRICE).GetCurRp(inclb,"",hospId)
    .s itmLbData=inclb_"^"_qty_"^"_sp_"^"_rp_"^"_dspSubId
    .s phacItmLbId=..InsertDHCPhaCollectItmLB(phacItmId,itmLbData) 
    .i $p(phacItmLbId,"^",1)<0 s errCode="-1^"_$p(phacItmLbId,"^",1)
    .q:errCode'=""
    .s retStk=##class(PHA.IP.COM.Save).HandleTransP(phacItmLbId)    // 处理该笔发药记录的台帐库存,此方法先不动
    .i retStk<0 s errCode="-1^处理库存失败,库存不足"
    l -^DHCINCIL(recLocId,incId)
    k ^TMPGETINCLB(pid)
    q
ThrowDispensing
    TROLLBACK
    l -^DHCOEDISPENSING(Oeori)
    i $d(pid)&&(pid'="") k ^TMPGETINCLB(pid)
    i ($d(recLocId))&&($d(incId)) d
    .i (recLocId'="")&&(incId'="") l -^DHCINCIL(recLocId,incId)
    q -1_"^"_$tr($ze,"^","")
}

/// description: 账单
ClassMethod MakeBill(PhacId)
{
    k MakeBillData
    q:PhacId="" ""
    s userId=$p(^DHCPHAC(PhacId),"^",5)
    s phacItm=0
    f  s phacItm=$o(^DHCPHAC(PhacId,"I",phacItm)) q:phacItm=""  d
    .s phacItmData=^DHCPHAC(PhacId,"I",phacItm)
    .s admId=$p(phacItmData,"^",3)
    .q:$p(^PAADM(admId),"^",2)'="I" // 仅住院调账单
    .s oeori=$p(phacItmData,"^",7)
    .s ordId=+oeori
    .s ordItm=+$p(oeori,"||",2)
    .q:(ordId=0)||(ordItm=0)
    .s arcItmId=$p($g(^OEORD(ordId,"I",ordItm,1)),"^",2) 
    .q:arcItmId="" 
    .s arcItmCat=$p(^ARCIM(+$p(arcItmId,"||",1),+$p(arcItmId,"||",2),1),"^",10) // 医嘱子类
    .s priId=$p($g(^OEORD(ordId,"I",ordItm,1)),"^",8) 
    .q:priId=""
    .s priCode=$p($g(^OECPR(+priId)),"^",1)
    .s feePoint=##Class(web.DHCSTPCHCOLLS2).GetFeePoint(arcItmCat_"^"_priCode_"^"_oeori)
    .q:feePoint'=1 //发药计费才调用账单
    .s dspIdStr=$p(phacItmData,"^",13)
    .s dspIdLen=$l(dspIdStr,",")
    .s dspI=0
    .f dspI=1:1:dspIdLen d
    ..s dspId=$p(dspIdStr,",",dspI)
    ..q:dspId=""
    ..s oeore=$p($g(^DHCOEDISQTY(dspId)),"^",3)
    ..i '$d(MakeBillData(admId)) d
    ...s MakeBillData(admId)=oeore
    ..e  d
    ...s MakeBillData(admId)=MakeBillData(admId)_"^"_oeore
    q:'$d(MakeBillData) ""
    s billRet=""
    s admId=""
    f  s admId=$o(MakeBillData(admId)) q:admId=""  d
    .s oeoreStr=MakeBillData(admId)
    .q:oeoreStr=""
    .s billRet=##Class(web.UDHCJFBILL).BILLN(admId,userId,oeoreStr,1)
    k MakeBillData
    q billRet
}

/// description: 更新打包表以及子表为发药状态
ClassMethod UpdateDHCOEDisp(PhacItmId)
{
    s errCode=""
    q:PhacItmId="" ""
    s dspId=$p($g(^DHCPHAC(+PhacItmId,"I",+$p(PhacItmId,"||",2))),"^",13)
    s curDate=+$h,curTime=$p($h,",",2),userId=$p($g(^DHCPHAC(+PhacItmId)),"^",5)
    s dspStatus="C",dspType="P"
    // 更新打包表
    &SQL(
        UPDATE DHC_OEDispensing 
        SET DSP_Status=:dspStatus,DSP_Date=:curDate,DSP_time=:curTime,
            DSP_User=:userId,DSP_Type=:dspType,DSP_Pointer=:PhacItmId 
        where DSP_RowId=:dspId
    )
    i SQLCODE'=0  d
    .s errInfo=SQLCODE_":"_$g(%msg)
    .s err=$$SqlErrorRecord^DHCSTERROR("UpdateDHCOEDisp:DHC_OEDispensing",PhacItmId,errInfo)
    .s errCode="-1^UpdateDHCOEDisp:DHC_OEDispensing:"_errInfo
    q:errCode'="" errCode
    i $d(^DHCOEDISQTY(dspId,"I")) { 
        // 更新打包子表
        &SQL(
            UPDATE DHC_OEDispBatch 
            SET DSPB_Status=:dspStatus
            where DSPB_DSP_ParRef=:dspId
        )
        i SQLCODE'=0  d
        .s errInfo=SQLCODE_":"_$g(%msg)
        .s err=$$SqlErrorRecord^DHCSTERROR("UpdateDHCOEDisp:DHC_OEDispBatch",PhacItmId,errInfo)
        .s errCode="-1^UpdateDHCOEDisp:DHC_OEDispBatch:"_errInfo
    }
    q:errCode'="" errCode   
    s recLocId=$p($g(^DHCPHAC(+PhacItmId)),"^",1)
    s hospId=$p(^CTLOC(recLocId),"^",22)
    s ruleFlag=##Class(web.DHCSTCOMMPARA).GetRpRule(hospId)
    // 处理在途
    s dspSub=0
    f  s dspSub=$o(^DHCOEDISQTY(dspId,"I",dspSub)) q:dspSub=""  d
    .s dspSubId=dspId_"||"_dspSub
    .s dspSubData=^DHCOEDISQTY(dspId,"I",dspSub)
    .s dspQty=-$p(dspSubData,"^",2)
    .s incId=$p(dspSubData,"^",5)
    .s incCh=$o(^INCI("IL_LOC",recLocId,incId,""))
    .q:incCh=""
    .s inclb=$p(dspSubData,"^",1)
    .s incil=incId_"||"_incCh
    .i ruleFlag'=3 d
    ..// 非批次价,不涉及批次转换
    ..s sqlStr=incil_"^"_3_"^"_dspQty_"^"_""_"^"_dspSubId_"^"_recLocId  
    ..s resRet=##class(PHA.COM.Reserve).SetReserve(sqlStr)
    .e  d
    ..// 批次价,涉及发药换批次,发药换批次时,重新分配处会重新计算在途清除与增加
    ..s incil=$p(inclb,"||",1,2)
    ..s sqlStr=incil_"^"_3_"^"_dspQty_"^"_inclb_"^"_dspSubId_"^"_recLocId
    ..s resRet=##class(PHA.COM.Reserve).SetReserve(sqlStr)
    q ""
}

/// description: 删除发药表
ClassMethod DeleteDHCPHACollected(PhacId As %String) As %String
{
    q:PhacId="" ""
    &SQL(DELETE FROM DHC_PHACollected WHERE DHC_PHACollect_RowID=:PhacId)
    q SQLCODE
}

/// description: 发药计费时,直接先重写,事务在外层,此方法不能单独运行!
ClassMethod ReBuildDHCOEDispBatch(DspId, RuleDateH = "")
{
    s recLocId=$p(^DHCOEDISQTY(DspId),"^",24)
    s errCode=""
    s dspSub=0
    f  s dspSub=$o(^DHCOEDISQTY(DspId,"I",dspSub)) q:dspSub=""  d
    .d ##class(web.DHCST01).DelResDeatilByDspSub(DspId_"||"_dspSub)
    &SQL(DELETE FROM DHC_OEDispBatch WHERE DSPB_DSP_ParRef=:DspId AND DSPB_Childsub>0)
    q:SQLCODE'=0 "-1^删除打包子表失败,SQLCODE:"_SQLCODE
    s insRet=##class(web.DHCST01).InsDspBatch(DspId,0,RuleDateH,1,1)
    i insRet<0 s errCode="-1^重写打包子表失败"
    e  i insRet=0 s errCode="-1^库存不足"
    q:errCode'="" errCode
    q ""
}

/// description: 获取发药Pid,涉及分配库存保持一个
ClassMethod GetInclbCounter(RecLocId, IncId) As %String
{
     l +^DHCINCIL(RecLocId,IncId):10  e  q -1
     s pid=##Class(web.DHCSTCOMMO).NewPidOEInclb()
     q pid
}

/// description: 更新打包表发药类别QT,重新匹配类别
ClassMethod UpdateOEDispCat(DspId)
{
    s oeori=$p(^DHCOEDISQTY(DspId),"^",1)
    s recLocId=$p(^DHCOEDISQTY(DspId),"^",24)
    s newCatCode=##class(web.DHCSTCOMMONSRV).GetDspCatId(oeori,"",recLocId)
    q:newCatCode="" 0
    &SQL(UPDATE DHC_OEDispensing SET DSP_Category=:newCatCode WHERE DSP_RowId=:DspId)
    q:SQLCODE'=0 "-1^更新打包表发药类别失败"
    q 0
}

/// description: 更新打包字表进售金额(发药计费)
/// w ##class(web.DHCINPHA.Disp.Save).UpdateOeDispPrice(86574,3)
ClassMethod UpdateOeDispPrice(DspId, HospId = "")
{
    q:+DspId=0 ""
    s recLocId=$p(^DHCOEDISQTY(DspId),"^",24)
    s hospId=$p(^CTLOC(recLocId),"^",22)
    s dspSub=0
    f  s dspSub=$o(^DHCOEDISQTY(DspId,"I",dspSub)) q:dspSub=""  d
    .s dspSubData=^DHCOEDISQTY(DspId,"I",dspSub)
    .q:$p(dspSubData,"^",6)'="TC"
    .s dspIncId=$p(dspSubData,"^",5)
    .s dspInclb=$p(dspSubData,"^",1)    
    .s dspRp=$p(dspSubData,"^",3)
    .s dspSp=$p(dspSubData,"^",4)
    .i dspInclb'="" s getInclb=dspInclb
    .e  s getInclb=dspIncId
    .s curSp=##class(web.DHCSTPRICE).GetCurSp(getInclb,"",hospId)
    .s curRp=##class(web.DHCSTPRICE).GetCurRp(getInclb,"",hospId)
    .i (dspRp'=curRp)||(dspSp'=curSp) d
    ..s dspSubId=DspId_"||"_dspSub
    ..&SQL(
        UPDATE DHC_OEDispBatch 
        SET DSPB_Sp=:curSp,DSPB_Rp=:curRp
        WHERE DSPB_RowId=:dspSubId
     )
    q 0
}

/// Description: 批次价,发药计费时,判断库存,如果不足需要重写打包子表
/// Return:      Y - 库存足够 , N - 库存不够
ClassMethod IsBatchQtyEnough(dsp)
{
    s ret="Y"
    s dspSub=0
    f  s dspSub=$o(^DHCOEDISQTY(dsp,"I",dspSub)) q:(dspSub="")||(ret="N")  d
    .s dspSubData=^DHCOEDISQTY(dsp,"I",dspSub)
    .s bQty=$p(dspSubData,"^",2)
    .s inclb=$p(dspSubData,"^",1)
    .q:inclb=""
    .s inclbQty=##class(web.DHCSTSTKQTY).GetInclbQtyForDisp(inclb)
    .i inclbQty<bQty d
    ..s ret="N"
    q ret
}

/// Description: 判断是否需要重写打包子表
/// Return:      Y - 需要重写
ClassMethod ShouldReBuildBatch(dsp, feePoint, rpRule)
{
    s ret="N"
    q:+$o(^DHCOEDISQTY(dsp,"I",0))=0 "Y"
    i (feePoint=1)&&(rpRule=3) d
    .s enoughFlag=..IsBatchQtyEnough(dsp)
    .i enoughFlag="N" s ret="Y" 
    q ret
}

/// description: 进程号
ClassMethod NewPid()
{
    q ##class(web.DHCSTKUTIL).NewPid($ClassName(),"IP")
}

/// Description: 处理配药发药流程
/// w ##class(web.DHCINPHA.Disp.Save).UpdatePhacStatus(486)
ClassMethod UpdatePhacStatus(phac)
{
    s phacData = ^DHCPHAC(phac)
    s loc = $p(phacData, "^", 1)
    s hosp = $p(^CTLOC(loc), "^", 22)
    s params = "^" _ loc _ "^^" _ hosp
    s needConfirm = ##class(web.DHCST.Common.AppCommon).GetAppPropValue("DHCSTORDDISP", "NEEDCONFIRM", params) 
    s operDate = $p(phacData, "^", 18)
    s operTime = $p(phacData, "^", 19)
    s operUser = $p(phacData, "^", 5)
    s collDate = $p(phacData, "^", 2)
    s collTime = $p(phacData, "^", 3)
    s collUser = $p(phacData, "^", 13)
    i needConfirm = 1 d
    .s status = "Confirm"
    .s (collDate, collTime, collUser) = ""
    .d ##class(PHA.IP.COM.Face).UpdateSystemStatus4PhaCollect(phac, "PHADISP", operUser)
    e  i needConfirm = 2 d
    .s status = "Print"
    .s (operDate, operTime, operUser) = ""
    .s (collDate, collTime, collUser) = ""
    e  d
    .s status = "Collect"
    .d ##class(PHA.IP.COM.Face).UpdateSystemStatus4PhaCollect(phac, "PHACOL", collUser)
    &SQL(
        UPDATE DHC_PHACollected 
        SET DHC_PHACollectStatus = :status,
        DHC_PHACollectDate = :collDate,DHC_PHACollectTime=:collTime,DHC_PHACollectUser=:collUser,
        DHC_PHAOperateDate=:operDate, DHC_PHAOperateTime = :operTime, DHC_PHAOperator=:operUser
        WHERE DHC_PHACollect_RowID = :phac
    )
    q SQLCODE
}

/// Description: 对于关联医嘱的皮试的判断, 判断整个关联医嘱
///              1. 配置, 阳性是否允许发药
///              2. 配置, 医嘱阳性时, 对应用法为皮试的医嘱是否允许发药
/// Input:          
/// Debug:       w ##class(web.DHCINPHA.Disp.Save).ValidateLinkOrderSkinTest(226812, "Y", "N")
///              w ##class(PHA.COM.Order).IsInstForSkinTest("665||53")
ClassMethod ValidateLinkOrderSkinTest(dsp, pNeedSkinTest = "", pPositiveDrugCanDispFlag = "") As %Boolean
{
    q:(pNeedSkinTest '= "Y") $$$YES
    s dspData = $g(^DHCOEDISQTY(dsp))
    s oeori = $p(dspData, "^", 1)
    s mOeori = ##class(web.DHCSTCOMMONORDER).GetMainOeori(oeori)
    q:($d(^||TMP("DHCST", $ClassName(), "ValidateLinkOrder", mOeori), ret)) ret
    #; 结果, 有结果不再获取
    s oeoriList = $lb(mOeori)
    s ord = +mOeori, itm = 0
    for {
        s itm = $o(^OEORDi(0, "OEORI", ord, mOeori, itm)) q:(itm = "")
        s oeoriList = oeoriList _ $lb(ord _ "||" _ itm)
    }
    for i = 1 : 1 : $ll(oeoriList) {
        s oeori = $lg(oeoriList, i)
        continue:(oeori = "")
        s skinTestValue = $p(##class(web.DHCSTCOMMONORDER).OeoriSkinTest(oeori), "^", 1)
        s instSkinTestFlag = ""
        if (skinTestValue < 0)&&(pPositiveDrugCanDispFlag = "Y"){
            #; 医嘱及其关联医嘱中是否存在用法为皮试的, 用于判断医嘱为阳性时, 皮试用法的是否还继续发, 一般不再需要了, 已经阳性了
            s instSkinTestFlag = ##class(PHA.COM.Order).IsInstForSkinTest(oeori)
        }

        if (skinTestValue < 0)&&(instSkinTestFlag '= "Y"){
            d SetResult($$$NO)
            return $$$NO  
        }
    }
    d SetResult($$$YES)
    q $$$YES
SetResult(value)
    s ^||TMP("DHCST", $ClassName(), "ValidateLinkOrder", mOeori) = value
    q $$$OK
}

ClassMethod SetCantDispInfo(info)
{
    s ^||TMP("DHCST", $ClassName(), "CantDispInfo", info) = ""
}

/// w ##class(web.DHCINPHA.Disp.Save).GetCantDispInfo()
ClassMethod GetCantDispInfo()
{
    q:('$d(^||TMP("DHCST", $ClassName(), "CantDispInfo"))) ""
    q $o(^||TMP("DHCST", $ClassName(), "CantDispInfo", ""))
}

}
