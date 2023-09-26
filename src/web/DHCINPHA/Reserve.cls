Import sqluser

/// creator:     yunhaibao
/// createdate:  2018-10-29
/// description: 冲减类,住院发药,医生科室发药公用
Class web.DHCINPHA.Reserve Extends %RegisteredObject
{

/// 满整支发药的判断, INCI代表判断库存项的维护(8.5.3以及之后), 否则按原始规则
Parameter WholeDispCheckRule = "INCI";

/// description: 发药完成调用冲减以及满整支
/// return:      $p(ret,"^",1)<0,失败
/// w ##class(web.DHCINPHA.Reserve).ExeResAfterDisp("18337",1)
ClassMethod ExeResAfterDisp(PhacIdStr, UserId, ResFlag = "")
{
    // 冲减
    i ResFlag="Y" s resRet=..SaveData(PhacIdStr, UserId)
    // 满整支
    s wholeRet=..SaveReserveForWhole(PhacIdStr,UserId)
    q 0
}

/// description: 保存冲减
ClassMethod SaveData(PhacIdStr, UserId)
{
    k ReserveReqData            // 汇总退药申请
    k ReserveReqRetLinkData     // 申请与退药关联
    k ReserveReqPhacLinkData    // 申请与发药关联
    q:PhacIdStr="" ""
    q:UserId="" ""
    s tmpPhacId=$p(PhacIdStr,"A",1)
    q:tmpPhacId="" ""
    q:'$d(^DHCPHAC(tmpPhacId)) ""
    s recLocId=$p(^DHCPHAC(tmpPhacId),"^",1)
    q:recLocId="" ""
    s phaLocationId=$o(^DHCPL(0,"Loc",recLocId,""))
    q:phaLocationId="" ""
    s locConfig=$g(^DHCPL(phaLocationId))
    s resStDate=$p(locConfig,"^",18)
    s resEdDate=$p(locConfig,"^",19)
    s resStDate=##Class(web.DHCSTKUTIL).GetDah(resStDate)   // 冲减的退药申请单开始日期
    s resEdDate=##Class(web.DHCSTKUTIL).GetDah(resEdDate)   // 冲减的退药申请单结束日期
    s resAllFlag=$p(locConfig,"^",20)                       // 全部冲减配置
    s resRetFlag=$p(locConfig,"^",16)                       // 是否冲减配置
    q:resRetFlag'="Y" ""
    s resAllFlag="N"    // 全部冲减,目前几乎没有使用的项目,容易导致病区冲减混乱.后台直接不放开,2018-10-30,yunhaibao
    s wardId=$p(^DHCPHAC(tmpPhacId),"^",4)
    q:wardId="" ""                                          // 特殊科室冲减暂不写
    s pid=..CalcuInc(PhacIdStr)
    q:'$d(^TMP("DHCST",$ClassName(),"CalcuInc","WardInc",pid)) ""
    s wardLocId=""
    f  s wardLocId=$o(^TMP("DHCST",$ClassName(),"CalcuInc","WardInc",pid,wardLocId)) q:wardLocId=""  d
    .s incId=""
    .f  s incId=$o(^TMP("DHCST",$ClassName(),"CalcuInc","WardInc",pid,wardLocId,incId)) q:incId=""  d
    ..s incCalcuData=^TMP("DHCST",$ClassName(),"CalcuInc","WardInc",pid,wardLocId,incId)
    ..s incQty=$p(incCalcuData,"^",1)
    ..// 计算可冲减的申请单
    ..s tCanRetQty=0    // 逐渐累加,大于incQty时,如下循环退出
    ..s reqId=""
    ..f  s reqId=$o(^RETRQ(0,"RECSTDEPT",recLocId,"Prove",wardLocId,reqId)) q:reqId=""  d
    ...s reqDate=$p(^RETRQ(reqId),"^",16)
    ...// 过滤-申请单日期
    ...q:(resStDate'="")&&(reqDate<resStDate)
    ...q:(resEdDate'="")&&(reqDate>resEdDate)
    ...s reqItm=0
    ...f  s reqItm=$o(^RETRQ(0,"INCI",incId,reqId,reqItm)) q:reqItm=""  d
    ....s reqItmData=^RETRQ(reqId,"I",reqItm)
    ....// 过滤-已退标识
    ....q:$p(reqItmData,"^",10)'="Prove"
    ....s reqItmId=reqId_"||"_reqItm
    ....s refundStatus=$p(reqItmData,"^",12)
    ....s phacLbId=$p(reqItmData,"^",14)
    ....// 过滤提前退费?
    ....// q:refundStatus=1
    ....s oeori=$p(reqItmData,"^",1)
    ....s admId=$p(^OEORD(+oeori),"^",1)
    ....s dspSubId=$p(reqItmData,"^",14)
    ....s dspId=+dspSubId
    ....q:+dspId=0
    ....s oeore=$p(^DHCOEDISQTY(dspId),"^",3) 
    ....// 过滤-中途结算
    ....q:(##Class(web.DHCSTKUTIL).IfRetForPaidNew(oeore)=0)&(refundStatus'=1)
    ....// 过滤-已出院
    ....s admStatus=##class(web.DHCSTCOMMONSRV).GetCurrentAdmStatus(admId)
    ....q:(admStatus=0)&(refundStatus'=1)
    ....s canRetQty=##class(web.DHCSTPHARETURN).GetReqItmSurplus(reqItmId)  // 已申请剩余未退数量
    ....
    ....q:(resAllFlag'="Y")&&(canRetQty>incQty)
    ....s tCanRetQty=tCanRetQty+canRetQty
    ....s canFlag=1
    ....i (resAllFlag'="Y")&&(tCanRetQty>incQty) d
    .....// 正常冲减,可退数大于发药数时,则准备退出,并还原总数
    .....s tCanRetQty=tCanRetQty-canRetQty
    .....s canFlag=-1
    ....q:canFlag=-1
    ..../* 数据-可退申请 */
    ....s ReserveReqData(reqId,reqItm)=reqItmId_"^"_canRetQty
    ....// 记录关联,申请与发药一对多,如下应记录申请退可使用的发药表信息
    ....s phacItmLbId=""
    ....f  s phacItmLbId=$o(^TMP("DHCST",$ClassName(),"CalcuInc","PhacItmLb",pid,wardLocId,incId,phacItmLbId)) q:(phacItmLbId="")||(canRetQty<=0)  d
    .....s phacItmLbQtyStr=^TMP("DHCST",$ClassName(),"CalcuInc","PhacItmLb",pid,wardLocId,incId,phacItmLbId)
    .....s phacQty=$p(phacItmLbQtyStr,"^",1)     // 剩余可继续使用数量
    .....q:+phacQty<=0
    .....s phacOrigQty=$p(phacItmLbQtyStr,"^",2) // 发药原始数量
    .....s calcuQty=phacQty-canRetQty
    .....i calcuQty<=0 d
    ......// 发药记录用完了,K掉
    ......k ^TMP("DHCST",$ClassName(),"CalcuInc","PhacItmLb",pid,wardLocId,incId,phacItmLbId)
    ......s useQty=phacQty           // 本次使用数量
    .....e  d
    ......// 没用完,更新可使用数量
    ......s $p(^TMP("DHCST",$ClassName(),"CalcuInc","PhacItmLb",pid,wardLocId,incId,phacItmLbId),"^",1)=calcuQty
    ......s useQty=canRetQty
    ...../* 数据-申请与发药关联 */
    .....s canRetQty=canRetQty-useQty // 每次循环,待退数量是递减的
    .....s ReserveReqPhacLinkData(reqId_"||"_reqItm,phacItmLbId)=phacOrigQty_"^"_canRetQty_"^"_useQty
    .....
    k ^TMP("DHCST",$ClassName(),"CalcuInc","PhacItmLb",pid)
    k ^TMP("DHCST",$ClassName(),"CalcuInc","WardInc",pid)
    q:'$d(ReserveReqData) ""
    // 所有申请准备完毕,开始执行申请单退药
    s reqId=""
    f  s reqId=$o(ReserveReqData(reqId)) q:reqId=""  d
    .s reqItmDataStr=""
    .s reqItm=""
    .f  s reqItm=$o(ReserveReqData(reqId,reqItm)) q:reqItm=""  d
    ..s reqItmData=ReserveReqData(reqId,reqItm)
    ..q:reqItmData=""
    ..i reqItmDataStr="" s reqItmDataStr=reqItmData
    ..e  s reqItmDataStr=reqItmDataStr_","_reqItmData
    .q:reqItmDataStr=""
    .// 申请单退药中不再处理冲减数据
    .s exeRet=##Class(web.DHCSTPHARETURN).ExecReturnByReq("","",recLocId,UserId,"AUTORT",reqItmDataStr,"1")
    .q:exeRet["fail"
    .s retIdStr=$p(exeRet,",",2)
    .s retId=$p(retIdStr,"^",1) // 按申请退,单号唯一
    .q:retId=""
    .// 保存退药冲减记录
    .s saveRes=..SaveResDetailByRet(retId,UserId)
    .q:$p(saveRes,"^",1)<0
    .// 确保每次处理一个退药单
    .k ReserveReqRetLinkData
    .s retItm=0
    .f  s retItm=$o(^PHARET(retId,"I",retItm)) q:retItm=""  d
    ..s retReqItmId=$p(^PHARET(retId,"I",retItm),"^",7)
    ..q:retReqItmId=""
    ..s retLb=0
    ..f  s retLb=$o(^PHARET(retId,"I",retItm,"B",retLb)) q:retLb=""  d
    ...// 关联-退药与申请
    ...s ReserveReqRetLinkData(retId_"||"_retItm_"||"_retLb,retReqItmId)=""
    .// 根据关联找到发药孙表Id
    .s retItmLbId=""
    .f  s retItmLbId=$o(ReserveReqRetLinkData(retItmLbId)) q:retItmLbId=""  d
    ..s retReqItmId=""
    ..f  s retReqItmId=$o(ReserveReqRetLinkData(retItmLbId,retReqItmId)) q:retReqItmId=""  d
    ...s phacItmLbId=""
    ...f  s phacItmLbId=$o(ReserveReqPhacLinkData(retReqItmId,phacItmLbId)) q:phacItmLbId=""  d
    ....// 保存发药冲减记录
    ....s useQty=$p($g(ReserveReqPhacLinkData(retReqItmId,phacItmLbId)),"^",3)
    ....s saveResDet=..SaveResDetailByPhacLb(phacItmLbId,retItmLbId,useQty,UserId)
    q ""
}

/// description: 冲减前汇总可冲减的药品数据
ClassMethod CalcuInc(PhacIdStr)
{
    s $zt="ThrowCalcuInc"
    s phacLen=$l(PhacIdStr,"A")
    q:phacLen=0 ""
    // 可冲减的发药类别
    s catCodeStr=##class(web.DHCSTCOMMONSRV).getReservedCat()
    s catCodeList=$lfs(catCodeStr,"^")
    s pid=..NewPid()
    s phacI=0
    f phacI=1:1:phacLen d
    .s phacId=$p(PhacIdStr,"A",phacI)
    .q:phacId=""
    .s wardId=$p(^DHCPHAC(phacId),"^",4)
    .q:wardId=""
    .s wardLocId=$p(^PAWARD(wardId),"^",5)  // 以ctloc表id为节点,医生科室发药可能用到
    .s catCode=$p(^DHCPHAC(phacId),"^",12)
    .// 过滤-可冲减发药类别(配置)
    .q:$lf(catCodeList,catCode)=0
    .s phacItm=0
    .f  s phacItm=$o(^DHCPHAC(phacId,"I",phacItm)) q:phacItm=""  d
    ..s phacLb=0
    ..f  s phacLb=$o(^DHCPHAC(phacId,"I",phacItm,"B",phacLb)) q:phacLb=""  d
    ...s phacLbData=^DHCPHAC(phacId,"I",phacItm,"B",phacLb)
    ...q:phacLbData=""
    ...s phacItmLbId=phacId_"||"_phacItm_"||"_phacLb
    ...s inclb=$p(phacLbData,"^",1)
    ...s qty=$p(phacLbData,"^",2)
    ...s dspSubId=$p(phacLbData,"^",3)
    ...s incId=+inclb
    ...// 按病区记录本次发药的总量
    ...i '$d(^TMP("DHCST",$ClassName(),"CalcuInc","WardInc",pid,wardLocId,incId)) d
    ....s ^TMP("DHCST",$ClassName(),"CalcuInc","WardInc",pid,wardLocId,incId)=qty
    ...e  d
    ....s $p(^TMP("DHCST",$ClassName(),"CalcuInc","WardInc",pid,wardLocId,incId),"^",1)=qty+$p(^TMP("DHCST",$ClassName(),"CalcuInc","WardInc",pid,wardLocId,incId),"^",1)
    ...// 按发药孙表记录数量,用于关联,哪个申请可以用哪个发药记录冲减
    ...s ^TMP("DHCST",$ClassName(),"CalcuInc","PhacItmLb",pid,wardLocId,incId,phacItmLbId)=qty_"^"_qty
    q pid
ThrowCalcuInc
    i $d(pid) d
    .k ^TMP("DHCST",$ClassName(),"CalcuInc","PhacItmLb",pid)
    .k ^TMP("DHCST",$ClassName(),"CalcuInc","WardInc",pid)
    s errRet=$$JsonErrorRecord^DHCSTERROR()
    q ""
}

/// description: 根据退药表插入冲减数据,这不可能并发
ClassMethod SaveResDetailByRet(RetId, UserId)
{
    q:RetId="" ""
    q:'$d(^PHARET(RetId)) ""
    s phaLocId=$p(^PHARET(RetId),"^",5)
    q:##class(web.DHCSTCOMMONSRV).ReserveRetFlag(phaLocId)'="Y" ""
    s retItm=0
    f  s retItm=$o(^PHARET(RetId,"I",retItm)) q:retItm=""  d
    .s retLb=0
    .f  s retLb=$o(^PHARET(RetId,"I",retItm,"B",retLb)) q:retLb=""  d
    ..s recLbData=^PHARET(RetId,"I",retItm,"B",retLb)
    ..s inclb=$p(recLbData,"^",1)
    ..s incId=+inclb
    ..s resLbRet=..SaveResDetailByRetLb("",RetId_"||"_retItm_"||"_retLb,UserId)
    q 0
}

/// description: 根据退药表插入冲减数据
/// input:       IncludeDisp(是否同时插入发药数据)
ClassMethod SaveResDetailByRetLb(ResId = "", RetItmLbId, UserId)
{
    s errCode=""
    s retId=+RetItmLbId
    s retItm=$p(RetItmLbId,"||",2)
    s retLb=$p(RetItmLbId,"||",3)
    s retItmId=retId_"||"_retItm
    s retItmLbData=^PHARET(retId,"I",retItm,"B",retLb)
    s inclb=$p(retItmLbData,"^",1)
    s qty=$p(retItmLbData,"^",2)
    s phacItmLbId=$p(retItmLbData,"^",8)
    s incId=+inclb
    s oeori=$p(^PHARET(retId,"I",retItm),"^",1)
    s wholeFlag=..IsWholeDisp(oeori)    // 满整支发药
    s reqLocId=$p(^PHARET(retId),"^",6)         // 申请退药科室
    s recLocId=$p(^PHARET(retId),"^",5)
    s wardLocId=reqLocId
    s wardId=$o(^PAWARD(0,"WARD_LocationDR",wardLocId,""))
    s wardDispFlag=$p(^DHCPHAC(+phacItmLbId),"^",4) // 为空时为医生科室发药
    s docLocId=""
    i wardDispFlag="" d
    .s docLocId=$p($g(^OEORD(+oeori,"I",+$p(oeori,"||",2),7)),"^",2)
    i ResId="" d
    .i wardDispFlag'="" d
    ..s resId=$o(^DHCPRES(0,"LOCINCIWARD",recLocId,incId,wardId,""))
    .e  d
    ..s resId=$o(^DHCPRES(0,"LOCINCIDEPT",recLocId,incId,docLocId,""))
    e  s resId=ResId
    i wholeFlag=1 s calcuQty=-qty   // 满整支冲减插入负数,特殊情况,上线后,开启冲减,直接走满整支默认首次也应该插入负数
    e  s calcuQty=qty   
    i resId="" d
    .// 插入主表
    .i wardDispFlag="" d
    ..s insRet=..InsertDHCPhaReserve(recLocId,"",docLocId,incId,calcuQty)
    .e  d
    ..s insRet=..InsertDHCPhaReserve(recLocId,wardId,"",incId,calcuQty)
    .i $p(insRet,"^",1)<0 s errCode=insRet
    .e  s resId=insRet
    e  d
    .s updRet=..UpdateDHCPhaReserve(resId,calcuQty)
    q:errCode'="" errCode
    // 退药插子表
    s insDetailRet=..InsertDHCPhaReserveDetail(resId,"Y",RetItmLbId,qty,UserId)
    i $p(insDetailRet,"^",1)<0 q insDetailRet
    // 标识为冲减退,该表数量目前仅做为标志
    &SQL(UPDATE DHC_PhaReturnItm SET PHARI_ReservedQty=PHARI_Qty WHERE PHARI_Rowid=:retItmId)
    q insDetailRet
}

/// description: 根据发药存表插入冲减数据并关联退药
/// input:       UseQty(该申请明细使用的发药孙表的数量)
ClassMethod SaveResDetailByPhacLb(PhacItmLbId, RetItmLbId, UseQty, UserId)
{
    s errCode=""
    s UseQty=+UseQty
    q:PhacItmLbId="" ""
    q:RetItmLbId="" ""
    s phacId=+PhacItmLbId
    s phacItm=$p(PhacItmLbId,"||",2)
    s phacLb=$p(PhacItmLbId,"||",3)
    s dspId=+$p(^DHCPHAC(phacId,"I",phacItm),"^",13)
    s oeori=$p(^DHCOEDISQTY(dspId),"^",1)
    s wardId=$p(^DHCPHAC(phacId),"^",4)
    s recLocId=$p(^DHCPHAC(phacId),"^",1)
    s docLocId=$p($g(^OEORD(+oeori,"I",+$p(oeori,"||",2),7)),"^",2)
    s inclb=$p(^DHCPHAC(phacId,"I",phacItm,"B",phacLb),"^",1)
    s incId=+inclb
    // 满整支发药,在此肯定存在记录
    i wardId'="" d
    .s resId=$o(^DHCPRES(0,"LOCINCIWARD",recLocId,incId,wardId,""))
    e  d
    .s resId=$o(^DHCPRES(0,"LOCINCIDEPT",recLocId,incId,docLocId,""))
    q:resId="" "-1^冲减主表Id为空"
    s wholeFlag=..IsWholeDisp(oeori)
    s calcuQty=-UseQty
    i wholeFlag=1 s calcuQty=UseQty
    // 先更新主表,普通为减,满整支为加
    s updRet=..UpdateDHCPhaReserve(resId,calcuQty)
    s phacLbQty=$p(^DHCPHAC(phacId,"I",phacItm,"B",phacLb),"^",2)
    s insDetailRet=..InsertDHCPhaReserveDetail(resId,"P",PhacItmLbId,phacLbQty,UserId)
    i $p(insDetailRet,"^",1)<0 s errCode=insDetailRet
    e  s resItmId=insDetailRet
    q:errCode'="" errCode
    // 插孙表
    s insDeSubRet=..InsertDHCPhaReserveDetailSub(resItmId,RetItmLbId,UseQty)
    s phacilResQty=$p(^DHCPHAC(phacId,"I",phacItm,"B",phacLb),"^",8)
    s newResQty=phacilResQty+UseQty
    // 更新发药孙表冲减数,直接加法累加
    &SQL(UPDATE DHC_PhaCollectItmLB SET PHACIL_ResQty=:newResQty WHERE PHACIL_Rowid=:PhacItmLbId)
    q 0
}

/// description: 满整支发药的单独处理
/// input:       PhacIdStr(发药表Id串,A分隔),RetIdStr(退药表Id串,A分隔,目前长度为1)
/// w ##class(web.DHCINPHA.Reserve).SaveReserveForWhole(64,1)
ClassMethod SaveReserveForWhole(PhacIdStr, UserId)
{
    q:(PhacIdStr="") ""
    s tmpPhac = $p(PhacIdStr,"A",1)
    s loc = $p(^DHCPHAC(tmpPhac),"^",1)
    s hosp = $p(^CTLOC(loc), "^", 22)
    s pid=..NewPid()
    // 发药处理满整支
    s phacLen=$l(PhacIdStr,"A")
    s phacI=0
    f phacI=1:1:phacLen d
    .s phacId=$p(PhacIdStr,"A",phacI)
    .q:phacId=""
    .s wardId=$p(^DHCPHAC(phacId),"^",4)
    .s recLocId=$p(^DHCPHAC(phacId),"^",1)
    .s phacItm=0
    .f  s phacItm=$o(^DHCPHAC(phacId,"I",phacItm)) q:phacItm=""  d
    ..s dspId=+$p(^DHCPHAC(phacId,"I",phacItm),"^",13)
    ..s oeori=$p(^DHCOEDISQTY(dspId),"^",1)
    ..s arcItmId=$p($g(^OEORD(+oeori,"I",+$p(oeori,"||",2),1)),"^",2)
    ..q:arcItmId=""
    ..// 过滤-非满整支
    ..q:..IsWholeDisp(oeori)'=1
    ..s docLocId=$p($g(^OEORD(+oeori,"I",+$p(oeori,"||",2),7)),"^",2)
    ..s phacLb=0
    ..f  s phacLb=$o(^DHCPHAC(phacId,"I",phacItm,"B",phacLb)) q:phacLb=""  d
    ...s phacLbData=^DHCPHAC(phacId,"I",phacItm,"B",phacLb)
    ...q:phacLbData=""
    ...s errCode=""
    ...s inclb=$p(phacLbData,"^",1)
    ...s qty=$p(phacLbData,"^",2)
    ...s resQty=+$p(phacLbData,"^",8)
    ...q:resQty<0
    ...s realQty=qty-resQty // 作为真实计算满整支发药的数量,因可能存在冲减
    ...q:realQty<=0
    ...s incId=+inclb
    ...// 这就得处理满整支发的数据咯
    ...d AddResDetail
    q 0
AddResDetail
    i wardId'="" d
    .s resId=$o(^DHCPRES(0,"LOCINCIWARD",recLocId,incId,wardId,""))
    e  d
    .s resId=$o(^DHCPRES(0,"LOCINCIDEPT",recLocId,incId,docLocId,""))
    i resId="" d
    .// 不存在,则保留数插入0
    .i wardId'="" d
    ..s insRet=..InsertDHCPhaReserve(recLocId,wardId,"",incId,0)
    .e  d
    ..s insRet=..InsertDHCPhaReserve(recLocId,"",docLocId,incId,0)
    .i $p(insRet,"^",1)<0 s errCode=insRet
    .s resId=insRet
    q:errCode'=""
    s resQty=$p(^DHCPRES(resId),"^",4) // 当前保留数
    s realResQty=realQty+resQty
    i realResQty<1 d    
    .// 可用发药+保留 小于 1,则继续保留,就是不发
    .s $p(^DHCPHAC(phacId,"I",phacItm,"B",phacLb),"^",8)=qty
    .s finalResQty=realResQty
    e  d
    .// 大于1,即为整数部分可发0.9  0.4  0.9-1
    .s calcuQty=qty-(realResQty\1) 
    .s $p(^DHCPHAC(phacId,"I",phacItm,"B",phacLb),"^",8)=calcuQty
    .s finalResQty=realResQty-(realResQty\1)
    s $p(^DHCPRES(resId),"^",4)=finalResQty // 最终保留数,没问题
    // 插入子表 
    s insDetRet=..InsertDHCPhaReserveDetail(resId, "P", phacId_"||"_phacItm_"||"_phacLb, qty, UserId)
    q
}

/// description: 插入主表
ClassMethod InsertDHCPhaReserve(RecLocId, WardId, DocLocId, IncId, ReqQty, UserId)
{
    s errCode=""
    q:RecLocId="" "-1^药房Id为空"
    q:(WardId="")&&(DocLocId="") "病区Id与医生科室Id同时为空"
    q:IncId="" "库存项Id为空"
    &SQL(
        INSERT INTO DHC_PhaReserve 
        (PRES_CTLOC_DR,PRES_INCI_DR,PRES_ResQty,PRES_Ward_DR,PRES_Dept_DR)
        VALUES
        (:RecLocId,:IncId,:ReqQty,:WardId,:DocLocId)
    )
    i SQLCODE'=0  d
    .s errInfo=SQLCODE_":"_$g(%msg)
    .s errCode="-1^"_$replace(errInfo,"^","")
    .s errRet=$$SqlErrorRecord^DHCSTERROR("DHC_PhaReserve","InsertDHCPhaReserve",errInfo)
    e  d
    .s rowId=$g(%ROWID)
    q:errCode'="" errCode
    q rowId
}

/// description: 更新冲减主表
/// input:       Qty(传正负)
ClassMethod UpdateDHCPhaReserve(ResId, Qty)
{
    s errCode=""
    // 加锁？
    s resQty=$p(^DHCPRES(ResId),"^",4)
    s newQty=resQty+Qty
    // 是否需要判断负数
    &SQL(
        UPDATE DHC_PhaReserve SET PRES_ResQty=:newQty WHERE PRES_Rowid=:ResId
    )
    i SQLCODE'=0  d
    .s errInfo=SQLCODE_":"_$g(%msg)
    .s errCode="-1^"_$replace(errInfo,"^","")
    .s errRet=$$SqlErrorRecord^DHCSTERROR("DHC_PhaReserve","UpdateDHCPhaReserve",errInfo)
    e  d
    .s rowId=$g(%ROWID)
    q:errCode'="" errCode
    q rowId
}

/// description: 插入冲减子表
ClassMethod InsertDHCPhaReserveDetail(ResId, Type, Pointer, Qty, UserId)
{
    s errCode=""
    q:ResId="" "-1^冲减主表Id为空"
    s maxChild=$o(^DHCPRES(ResId,"DET",""),-1)+1
    s avaQty=$p(^DHCPRES(ResId),"^",4)
    s curDate=+$h
    s curTime=$p($h,",",2)
    &SQL(
        INSERT INTO DHC_PhaReserveDetail 
        (
            PRDET_PRES_Parref,PRDET_Childsub,PRDET_Type,PRDET_Qty,PRDET_OperUser_Dr,
            PRDET_Date,PRDET_Time,PRDET_AvailQty,PRDET_Pointer
        )
        VALUES
        (
            :ResId,:maxChild,:Type,:Qty,:UserId,
            :curDate,:curTime,:avaQty,:Pointer
        )
    )
    i SQLCODE'=0  d
    .s errInfo=SQLCODE_":"_$g(%msg)
    .s errCode="-1^"_$replace(errInfo,"^","")
    .s errRet=$$SqlErrorRecord^DHCSTERROR("DHC_PhaReserveDetail","InsertDHCPhaReserveDetail",errInfo)
    e  d
    .s rowId=$g(%ROWID)
    q:errCode'="" errCode
    q rowId
}

/// description: 插入冲减孙表
ClassMethod InsertDHCPhaReserveDetailSub(ResDetailId, RetItmLbId, Qty)
{
    s errCode=""
    q:ResDetailId="" "-1^冲减子表Id为空"
    s maxChildSub=$o(^DHCPRES(+ResDetailId,"DET",$p(ResDetailId,"||",2),"SUB",""),-1)+1
    &SQL(
        INSERT INTO DHC_PhaReserveDetailSub 
        (
            PRDETS_PRDET_Parref,PRDETS_ChildSub,PRDETS_PHARET_Dr,PRDETS_Qty
        )
        VALUES
        (
            :ResDetailId,:maxChildSub,:RetItmLbId,:Qty
        )
    )
    i SQLCODE'=0  d
    .s errInfo=SQLCODE_":"_$g(%msg)
    .s errCode="-1^"_$replace(errInfo,"^","")
    .s errRet=$$SqlErrorRecord^DHCSTERROR("DHC_PhaReserveDetailSub","InsertDHCPhaReserveDetailSub",errInfo)
    e  d
    .s rowId=$g(%ROWID)
    q:errCode'="" errCode
    q rowId
}

/// description: 获取满整支发药的医嘱子类Id串
/// w ##class(web.DHCINPHA.Reserve).GetWholeArcCatStr(1)
ClassMethod GetWholeArcCatStr(hosp) As %String
{
    s arcCatStr=""
    s drugGrpId=0
    f  s drugGrpId=$o(^DHCSTDRUGGRP(drugGrpId)) q:drugGrpId=""  d
    .q:(##class(PHA.FACE.IN.Com).GetShowDataFlag(##class(PHA.IP.DispCat.Save).#TableName, drugGrpId, hosp) = "N")
    .s drugGrpItm=0
    .f  s drugGrpItm=$o(^DHCSTDRUGGRP(drugGrpId,"I",drugGrpItm)) q:drugGrpItm=""  d
    ..s drugItmData=^DHCSTDRUGGRP(drugGrpId,"I",drugGrpItm)
    ..q:drugItmData=""
    ..s wholeFlag=$p(drugItmData,"^",4)
    ..q:wholeFlag'=1
    ..s arcCatId=$p(drugItmData,"^",1)
    ..i arcCatStr="" s arcCatStr=arcCatId
    ..e  s arcCatStr=arcCatStr_"^"_arcCatId
    q arcCatStr
}

/// description: 进程号
/// w ##class(web.DHCINPHA.Reserve).NewPid()
ClassMethod NewPid() As %String
{
    q ##class(web.DHCSTKUTIL).NewPid($ClassName(),"IP")
}

/// Description: 是否符合满整支, 住院一天量没勾,不算满整支
/// Return:      1 - 符合
/// Debug:       w ##class(web.DHCINPHA.Reserve).IsWholeDisp("1479||213")
ClassMethod IsWholeDisp(oeori)
{
    q:(..#WholeDispCheckRule = "INCI") ..IsWholeDisp4Inci(oeori)
    q:oeori="" ""
    s ord=$p(oeori,"||",1) q:ord="" ""
    s itm=$p(oeori,"||",2) q:itm="" ""
    q:'$d(^OEORD(ord,"I",itm)) ""
    s arcim=$p(^OEORD(ord,"I",itm,1),"^",2) q:arcim="" ""
    s sub=$p(arcim,"||",1)
    s ver=$p(arcim,"||",2)
    q:'$d(^ARCIM(sub,ver,1)) ""
    s phcdf=$p(^ARCIM(sub,ver,1),"^",12)
    q:phcdf="" ""
    s ipOneDay=$p($g(^PHCD(+phcdf,"DF",+$p(phcdf,"||",2),2)),"^",6) 
    q:ipOneDay'="Y" ""
    s ordcat=$p(^ARCIM(sub,ver,1),"^",10)
    q:ordcat="" ""
    s sdgr=$o(^DHCSTDRUGGRP(0,"ORDCAT",ordcat,"")) q:sdgr="" ""
    s sdgsub=$o(^DHCSTDRUGGRP(0,"ORDCAT",ordcat,sdgr,"")) q:sdgsub="" ""
    s wholeflag=$p(^DHCSTDRUGGRP(sdgr,"I",sdgsub),"^",4)
    q wholeflag
}

/// Description: 按库存项的维护判断是否为满整支发药
ClassMethod IsWholeDisp4Inci(oeori)
{
    s ord = $p(oeori, "||", 1)
    s itm = $p(oeori, "||", 2)
    s arcim = $p($g(^OEORD(ord, "I", itm, 1)), "^", 2) 
    q:(arcim = "") 0
    s inci = $o(^INCI(0, "ARCIM_DR", +arcim, ""))
    s itmAdd = $o(^DHCITMINFO(0, "INCI", inci, ""))
    q:(itmAdd = "") 1
    s wholeDispFlag = $p($g(^DHCITMINFO(itmAdd, 2)), "^", 5)
    q $s(wholeDispFlag = "Y" : 1 , 1 : 0)
}

}
