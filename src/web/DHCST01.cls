Import Sqluser

Class web.DHCST01 Extends %RegisteredObject
{

ClassMethod UPDINV1(IMILROW, QTY)
{
    ;UPDATE INVENTORY (only quantity without price)
    ; Return 1 if OK, 0 if not OK
    S IMILROW=$P(IMILROW,$C(1))
    S QTY=$P(QTY,$C(1))
    S IM=$P(IMILROW,"||",1)
    Q:IM="" 0
    S ILSub=$P(IMILROW,"||",2)
    S LBSub=$P(IMILROW,"||",3)
    //L +^INCI(IM):10
    L +^INCI(IM,"IL",ILSub):10
    E  Q 0
    //S IMREC=$g(^INCI(IM,1))
    S IMILREC=$g(^INCI(IM,"IL",ILSub))
    S IMLBREC=$g(^INCI(IM,"IL",ILSub,"LB",LBSub))
    //S IMQTY=$P(IMREC,"^",4)
    S IMILQTY=$P(IMILREC,"^",3)
    S IMLBQTY=$P(IMLBREC,"^",2)
    S $P(IMLBREC,"^",2)=IMLBQTY+QTY
    S $P(IMILREC,"^",3)=IMILQTY+QTY
    //S $P(IMREC,"^",4)=IMQTY+QTY
    //S ^INCI(IM,1)=IMREC
    S ^INCI(IM,"IL",ILSub)=IMILREC
    S ^INCI(IM,"IL",ILSub,"LB",LBSub)=IMLBREC

    L -^INCI(IM,"IL",ILSub)
    q 1
}

/// Descript：       处理科室库存的医嘱在途数
/// Table：          inc_itmloc
/// Input：          库存项ID,科室ID,数量
/// Return：     1-成功,其它-失败
ClassMethod UPDINVRESQTY(inci, loc, qty)
{
    s $zt="ErrUPDINVRESQTY"
    s ch=$O(^INCI("IL_LOC",loc,inci,""))
    q:ch="" 0
    q:($d(^INCI(inci,"IL",ch))'=11) 0
    //l +^INCIRESERVE(inci,loc) //zhouyg 20131029 不解锁问题的修改
    l +^INCI(inci,"IL",ch):3 E  Q -100
    s rec=^INCI(inci,"IL",ch)
    s resqty=$p(rec,"^",10)
    i resqty+qty<0 s resqty=-qty  ;当qty<0时,消去resqty时到零为止
    s $p(rec,"^",10)=resqty+qty
    s ^INCI(inci,"IL",ch)=rec
    l -^INCI(inci,"IL",ch)
    //l -^INCIRESERVE(inci,loc)
    q 1
ErrUPDINVRESQTY
    s ret = $$ErrorRecord^DHCSTERROR("DHCSTPARAMER", "RunTime", $ze)
    q "ERROR-"_$tr($ze,"<>^'"," %- ")
}

ClassMethod UPDINCI(INTRDATA, TRANSFLAG = "")
{
 
    ; Return 1 if OK, 0 if not OK
    S IMILROW=$p(INTRDATA,"^",3)
    S QTY=$p(INTRDATA,"^",4)
    S IMILROW=$P(IMILROW,$C(1))
    S QTY=$P(QTY,$C(1))
    S IM=$P(IMILROW,"||",1)
    Q:IM="" 0
    L +^INCI(IM,"IL",$P(IMILROW,"||",2)):10 E  Q 0
    ts
    //1.处理INCI库存相关
    s ret=##class(web.DHCST.Common.StockHandle).UpdateStock(IMILROW,QTY)  
    //i IMILROW="308||6||5" b //21311 
    i ret=0 d
    .s ret=1
    .q:TRANSFLAG'=""
    .//2.增加台帐
    .
    .s ret=##class(web.DHCSTINTRANS).IntoTrans(INTRDATA) 
    .//i IMILROW="308||6||5" b //2131 2
    i ret'>0 tro
    i ret'>0 L -^INCI(IM,"IL",$P(IMILROW,"||",2))
    q:ret'>0 0
    tc
    L -^INCI(IM,"IL",$P(IMILROW,"||",2))
    Q 1
}

/// Descript：       处理科室库存项及科室库存批次的在途数
/// Creater：        zhouyg
/// CreateDate： 2013-08-15
/// Table：          inc_itmloc,inc_itmlcbt
/// Input：          inc_itmlcbt的ID
/// Output：     INCLB^数量
/// Return：     0-成功,其它-失败
ClassMethod UpdLocIncResQty(inclb As %String, qty As %String) As %String
{
    q 0  //zhouyg 20131213 发药时不能处理此处 
    q:inclb="" -1
    s inci=$p(inclb,"||",1)
    s ilsub=$p(inclb,"||",2)
    s lbsub=$p(inclb,"||",3)
    l +^INCIRESERVE(inclb)
    s rec=^INCI(inci,"IL",ilsub)
    s resqty=$p(rec,"^",10)
    i resqty+qty<0 s resqty=-qty  ;当qty<0时,消去resqty时到零为止
    s $p(rec,"^",10)=resqty+qty
    s ^INCI(inci,"IL",ilsub)=rec
    //
    s rec=^INCI(inci,"IL",ilsub,"LB",lbsub)
    s resqty=$p(rec,"^",3)
    i resqty+qty<0 s resqty=-qty
    s $p(rec,"^",3)=resqty+qty
    s ^INCI(inci,"IL",ilsub,"LB",lbsub)=rec
    l -^INCIRESERVE(inclb)
    q 0
}

/// Descript：       处理科室库存批次的医嘱在途数
/// Creater：        zhouyg
/// CreateDate： 2014-07-07(20141224)
/// Table：          inc_itmlcbt,dhc_incitmlcbt
/// Input：          inc_itmlcbt的ID,数量
/// Return：     0-成功,其它-失败
ClassMethod UpdInclbResQty(inclb As %String, qty As %String) As %String
{
    q:inclb="" -1
    s dhcinclb=##Class(web.DHCST.DHCINCItmLcBt).Insert(inclb)
    q:dhcinclb'>0 -2
    q:##class(web.DHCST.Common.AppCommon).Lock("User.DHCINCItmLcBt"_inclb)<0 -99
    s rec=^DHCINCLB(dhcinclb)
    s resqty=$p(rec,"^",3)         //INCLB_ReservedQty
    i resqty+qty<0 s resqty=-qty  //当qty<0时,消去resqty时到零为止
    s $p(rec,"^",3)=resqty+qty
    s ^DHCINCLB(dhcinclb)=rec
    d ##class(web.DHCST.Common.AppCommon).UnLock("User.DHCINCItmLcBt"_inclb)
    q 0
}

/// Descript：       根据医嘱医嘱处理在途数(医生站接口,批次价使用)
/// Creater：        zhouyg
/// CreateDate： 2015-01-15
/// Table：          
/// Input：          医嘱ID,医嘱执行ID
///                 医嘱ID,医嘱执行ID只能输入其一，如果两个都录入就按执行ID处理
///                 批次价时开医嘱不能调用此函数(批次价时已经在开医嘱插入批次表同时处理了在途数)
/// Return：     0-成功,其它-失败
/// w ##class(web.DHCST01).SetOeResQty("3839||6","")
ClassMethod SetOeResQty(OeItmID As %String, OeExeID As %String) As %String
{
    s $zt="ErrSetOeResQty"
    q:(OeItmID="")&(OeExeID="") -1
    s retCode=0
    i OeExeID'="" d
    .s OeordID=$p(OeExeID,"||",1)
    .s OeItmSub=$p(OeExeID,"||",2)
    else  d
    .s OeordID=$p(OeItmID,"||",1)
    .s OeItmSub=$p(OeItmID,"||",2)
    q:(OeordID="")||(OeItmSub="") -3
    s PriorID=$p(^OEORD(OeordID,"I",OeItmSub,1),"^",8)
    q:PriorID="" -6
    s priorCode=$p($g(^OECPR(PriorID)),"^",1) ;自备药不处理在途数 20160112 zhouyg
    q:$ZCVT(priorCode,"U")["OM" 0
    s admID=$p($g(^OEORD(OeordID)),"^",1)
    q:admID="" -2
    s admType=$p($g(^PAADM(admID)),"^",2)
    s ArcimID=$p($g(^OEORD(OeordID,"I",OeItmSub,1)),"^",2)
    //s incID=##Class(web.DHCSTCOMINC).GetInciID(ArcimID)
    //q:incID="" -4
    s RecLocID=$p(^OEORD(OeordID,"I",OeItmSub,3),"^",6)
    q:RecLocID="" -5
    s HospID=$p($g(^CTLOC(RecLocID)),"^",22)
    s RuleFlag=##Class(web.DHCSTCOMMPARA).GetRpRule(HospID)
    //批次价
    i RuleFlag=3 d
    .i OeExeID'="" d
    ..s dspID=""
    ..f  s dspID=$o(^DHCOEDISQTY(0,"OEORE",OeExeID,dspID)) q:(dspID="")||(retCode'=0)  d
    ...s dspStatus=$p(^DHCOEDISQTY(dspID),"^",7)
    ...q:(dspStatus'="TC")
    ...s dspbID="0"
    ...f  s dspbID=$o(^DHCOEDISQTY(dspID,"I",dspbID)) q:(dspbID="")||(retCode'=0)  d
    ....s inclb=$p(^DHCOEDISQTY(dspID,"I",dspbID),"^",1)
    ....s dspQty=$p(^DHCOEDISQTY(dspID,"I",dspbID),"^",2)
    ....s dspQty=-dspQty    //停医嘱减在途
    ....s incil=$p(inclb,"||",1,2)
    ....s SqlStr=incil_"^"_"2"_"^"_dspQty_"^"_inclb_"^"_dspID_"||"_dspbID_"^"_RecLocID
    ....s Ret=##class(PHA.COM.Reserve).SetReserve(SqlStr)
    .e  d
    ..q:(admType="I")   //住院病人不能按照医嘱ID处理
    ..s dspID=""
    ..f  s dspID=$o(^DHCOEDISQTY(0,"OEORI",OeItmID,dspID)) q:(dspID="")||(retCode'=0)  d
    ...s dspStatus=$p(^DHCOEDISQTY(dspID),"^",7)
    ...q:(dspStatus'="TC")
    ...s dspbID="0"
    ...f  s dspbID=$o(^DHCOEDISQTY(dspID,"I",dspbID)) q:(dspbID="")||(retCode'=0)  d
    ....s inclb=$p(^DHCOEDISQTY(dspID,"I",dspbID),"^",1)
    ....s dspQty=$p(^DHCOEDISQTY(dspID,"I",dspbID),"^",2)
    ....s dspQty=-dspQty    //停医嘱减在途
    ....s incil=$p(inclb,"||",1,2)
    ....s SqlStr=incil_"^"_"2"_"^"_dspQty_"^"_inclb_"^"_dspID_"||"_dspbID_"^"_RecLocID
    ....s Ret=##class(PHA.COM.Reserve).SetReserve(SqlStr)
    q:RuleFlag=3 retCode
    //非批次价
    i OeExeID'="" d
    .s dspID=""
    .f  s dspID=$o(^DHCOEDISQTY(0,"OEORE",OeExeID,dspID)) q:(dspID="")  d
    ..s dspStatus=$p(^DHCOEDISQTY(dspID),"^",7)
    ..q:(dspStatus'="TC")
    ..s RecLocID=$p(^DHCOEDISQTY(dspID),"^",24)
    ..q:RecLocID=""
    ..s dspbSub="0"
    ..f  s dspbSub=$o(^DHCOEDISQTY(dspID,"I",dspbSub)) q:(dspbSub="")||(retCode'=0)  d
    ...s dspbID=dspID_"||"_dspbSub
    ...s incID=$p(^DHCOEDISQTY(dspID,"I",dspbSub),"^",5)
    ...s incilSub=$o(^INCI("IL_LOC",RecLocID,incID,"")) //zhouyg 20160826
    ...s incil=incID_"||"_incilSub
    ...s dspQty=$p(^DHCOEDISQTY(dspID,"I",dspbSub),"^",2)
    ...s dspQty=-dspQty //停医嘱减在途
    ...s SqlStr=incil_"^"_"2"_"^"_dspQty_"^"_""_"^"_dspbID_"^"_RecLocID
    ...s Ret=##class(PHA.COM.Reserve).SetReserve(SqlStr)
    else  d
    .q:(admType="I")    //住院病人不能按照医嘱ID处理
    .s dspID=""
    .f  s dspID=$o(^DHCOEDISQTY(0,"OEORI",OeItmID,dspID)) q:(dspID="")  d
    ..s dspStatus=$p(^DHCOEDISQTY(dspID),"^",7)
    ..q:(dspStatus'="TC")
    ..s RecLocID=$p(^DHCOEDISQTY(dspID),"^",24)
    ..q:RecLocID=""
    ..s dspbSub="0"
    ..f  s dspbSub=$o(^DHCOEDISQTY(dspID,"I",dspbSub)) q:(dspbSub="")||(retCode'=0)  d
    ...s dspbID=dspID_"||"_dspbSub
    ...s incID=$p(^DHCOEDISQTY(dspID,"I",dspbSub),"^",5)
    ...q:incID=""
    ...s incilSub=$o(^INCI("IL_LOC",RecLocID,incID,"")) //zhouyg 20160826
    ...s incil=incID_"||"_incilSub
    ...s dspQty=$p(^DHCOEDISQTY(dspID,"I",dspbSub),"^",2)
    ...s dspQty=-dspQty //停医嘱减在途
    ...s SqlStr=incil_"^"_"2"_"^"_dspQty_"^"_""_"^"_dspbID_"^"_RecLocID
    ...s Ret=##class(PHA.COM.Reserve).SetReserve(SqlStr)
    q retCode
ErrSetOeResQty
    s ret = $$ErrorRecord^DHCSTERROR("DHCSTPARAMER", "RunTime", $ze)
    q "ERROR-"_$tr($ze,"<>^'"," %- ")
}

/// Description: 门诊开医嘱时处理配药批次表(因为涉及到实时的取逻辑库存,本方法同时处理了科室在途和科室批次在途)
/// Creater:     zhouyg
/// CreateDate:  2013-08-08
/// Table:       OE_OrdItem,DHCOEDispBatch,inc_itmloc,inc_itmlcbt
/// Input:       OE_OrdItem的ID
/// Output:      INCLB^数量^进价^售价
/// Return:      0-没有满足条件的批次,1-有满足条件的批次,<0表示错误
/// Modify:      医嘱结构改造增加为所有价格模式都需调用,hulihua2018-10-13
///              不再判断库存是否足够,增加插入不成功的日志,yunhaibao20191211
///              增加InsType参数,默认2,1为(发药重写插入),
///              增加CallType参数,默认空,1为(发药重写插入),MaYuqiang20220722
/// Debug:       w ##class(web.DHCST01).InsDspBatchForOut("2066||4")
ClassMethod InsDspBatchForOut(OeoriID As %String, DateH = "", InsType = "2", CallType = "") As %String
{
    s $ZT="ErrInsDspBatchForOut"
    q:OeoriID="" -101
    s OrdID=$p(OeoriID,"||",1)
    s OrdSub=$p(OeoriID,"||",2)
    s PriorID=$p(^OEORD(OrdID,"I",OrdSub,1),"^",8)
    q:PriorID="" -102
    s priorCode=$p($g(^OECPR(PriorID)),"^",1) ;自备药不处理 20160112 zhouyg
    q:$ZCVT(priorCode,"U")["OM" 1
    s Arcim=$p(^OEORD(OrdID,"I",OrdSub,1),"^",2) 
    q:Arcim="" -103
    s recLoc=$p(^OEORD(OrdID,"I",OrdSub,3),"^",6) 
    q:recLoc="" -104
    s HospID=$p($g(^CTLOC(recLoc)),"^",22)
    s RuleFlag=##Class(web.DHCSTCOMMPARA).GetRpRule(HospID,DateH)
    s pid=##Class(web.DHCSTCOMMO).NewPidOEInclb()
    s qtyFlag = ##class(PHA.OP.COM.Method).GetSingleProp("", recLoc,"", "QtyTypeFlag")
    s Status="TC"
    TSTART
    s DspID="",RetCode=""
    f  s DspID=$o(^DHCOEDISQTY(0,"OEORI",OeoriID,DspID)) q:(DspID="")||(RetCode'="")  d
    .q:+$o(^DHCOEDISQTY(DspID,"I",0))>0
    .s PackInci=$p($g(^DHCOEDISQTY(DspID,"EXP")),"^",1)     // 开医嘱生成的库存项列表
    .i PackInci="" s RetCode=-105_"^PackInci为空" q
    .s PackNum=$l(PackInci,$c(1))
    .f ii=1:1:PackNum q:(RetCode'="")  d
    ..s IncStr=$p(PackInci,$c(1),ii)
    ..s IncID=+$p(IncStr,"!",1)
    ..i IncID=0 s RetCode=-107_"^PackInci的库存项为空" q
    ..s DspQty=+$p(IncStr,"!",2)
    ..i DspQty=0 s RetCode=-108_"^PackInci的数量为空" q
    ..s ILSub=$o(^INCI("IL_LOC",recLoc,IncID,"")) 
    ..i +ILSub>0 s incil=IncID_"||"_ILSub
    ..e  s incil=""
    ../// 1 非批次价,直接用医嘱计算出的库存项和数量插入打包子表
    ..i RuleFlag'=3 d
    ...s sp=##Class(web.DHCSTPRICE).GetCurSp(IncID,"",HospID)
    ...s rp=##Class(web.DHCSTPRICE).GetCurRp(IncID,"",HospID)
    ...s DspbStr=DspID_"^^"_DspQty_"^"_sp_"^"_rp_"^"_IncID_"^"_Status
    ...s RetIns=##Class(web.DHCSTOEDispBatch).InsDspBatch(DspbStr)
    ...s InsSQLCODE=$p(RetIns,"^",1)
    ...i InsSQLCODE'=0 s RetCode=-109_"^插入打包子表失败,统一价" q
    ...i incil'="" d
    ....s dspbID=$p(RetIns,"^",2)
    ....s SqlStr=incil_"^"_"1"_"^"_DspQty_"^"_""_"^"_dspbID_"^"_recLoc
    ....s Ret=##class(PHA.COM.Reserve).SetReserve(SqlStr)
    ..q:RuleFlag'=3
    ../// 2 批次价,计算批次后插入打包子表
    ..i incil="" s RetCode="-1^插入打包子表,科室库存项为空,库存项Id为"_IncID q
    ..i $$LKOut()<0 s RetCode="-1^插入打包子表,科室库存项加锁失败,科室库存项Id为"_incil q
    ../// 2.1 批次价,库存不足时找最后批次补充
    ..s RetInclb=..GetInclbQty(incil,DspQty,pid,InsType,CallType,"",qtyFlag)
    ..i RetInclb'=1 d
    ...// 库存不足找最后批次
    ...d UKOut
    ...k ^TMP("DHCST","web.DHCST01","Inclb",pid)
    ...s Inclb=##Class(web.DHCSTCOMINC).GetLastInclbByLoc(incil)
    ...s sp=##Class(web.DHCSTPRICE).GetCurSp(Inclb,"",HospID)
    ...s rp=##Class(web.DHCSTPRICE).GetCurRp(Inclb,"",HospID)
    ...s DspbStr=DspID_"^"_Inclb_"^"_DspQty_"^"_sp_"^"_rp_"^"_IncID_"^"_Status
    ...s RetIns=##Class(web.DHCSTOEDispBatch).InsDspBatch(DspbStr)
    ...s InsSQLCODE=$p(RetIns,"^",1)
    ...i InsSQLCODE'=0 d
    ....s RetCode=-1000_"^插入打包子表失败,批次价库存不足"
    ..q:RetInclb'=1
    ../// 2.2 批次价,库存充足
    ..s iNum=""
    ..f  s iNum=$o(^TMP("DHCST","web.DHCST01","Inclb",pid,iNum)) q:(iNum="")!(RetCode'="")  d
    ...s inclbStr=^(iNum)
    ...s rqty=+$p(inclbStr,"^",1) // 数量是已经计算过的
    ...s sp=+$p(inclbStr,"^",2)
    ...s rp=+$p(inclbStr,"^",3)
    ...s rinclb=$p(inclbStr,"^",4)
    ...s DspbStr=DspID_"^"_rinclb_"^"_rqty_"^"_sp_"^"_rp_"^"_IncID_"^"_Status
    ...s RetIns=##Class(web.DHCSTOEDispBatch).InsDspBatch(DspbStr)
    ...s InsSQLCODE=$p(RetIns,"^",1)
    ...i InsSQLCODE'=0 s RetCode=-1000_"^插入打包子表失败,批次价库存充足时" q
    ...s dspbID=$p(RetIns,"^",2)
    ...// 处理批次占用数
    ...s SqlStr=incil_"^"_"1"_"^"_rqty_"^"_rinclb_"^"_dspbID_"^"_recLoc
    ...s Ret=##class(PHA.COM.Reserve).SetReserve(SqlStr)
    ..d UKOut
    i RetCode'="" d
    .TROLLBACK
    .// 记录日志
    .d ErrorRecord^DHCSTERROR("DHCSTPARAMER","入参:"_OeoriID_","_DateH ,$p(RetCode,"^",2))
    q:RetCode'="" 0
    TCOMMIT
    q 1
LKOut()
    l +^INCI(IncID,"IL",ILSub):5 e  q -1
    q 0
UKOut
    l -^INCI(IncID,"IL",ILSub)
    k ^TMP("DHCST","web.DHCST01","Inclb",pid)
    q
ErrInsDspBatchForOut
    s ret = $$ErrorRecord^DHCSTERROR("DHCSTPARAMER", "RunTime", $ze)
    q "ERROR-"_$tr($ze,"<>^'"," %- ")
}

/// Description: 门诊应急系统批量导入数据时处理打包子表数据
/// CreateDate:  2021-11-15
/// Table:       OE_OrdItem,DHCOEDispBatch,inc_itmloc,inc_itmlcbt
/// Input:       OE_OrdItem的ID,日期
/// Output:      0-没有满足条件的批次,1-有满足条件的批次,<0表示错误
/// Debug:       w ##class(web.DHCST01).InsDspBatchForImport("3||144")
ClassMethod InsDspBatchForImport(OeoriID As %String, DateH = "")
{
    s $ZT="InsDspBatchForImport"
    q:OeoriID="" -101
    s ordId=$p(OeoriID,"||",1)
    s itmId=$p(OeoriID,"||",2)
    s priorId=$p(^OEORD(ordId,"I",itmId,1),"^",8)
    q:priorId="" -102
    s priorCode=$p($g(^OECPR(priorId)),"^",1) ;自备药不处理 
    q:$ZCVT(priorCode,"U")["OM" 1
    s arcId=$p(^OEORD(ordId,"I",itmId,1),"^",2) 
    q:arcId="" -103
    s recLocId=$p(^OEORD(ordId,"I",itmId,3),"^",6) 
    q:recLocId="" -104
    s hospId=$p($g(^CTLOC(recLocId)),"^",22)
    s ruleFlag=##Class(web.DHCSTCOMMPARA).GetRpRule(hospId,DateH)
    //获取医嘱扩展表中指定的库存项ID和批次ID
    s impFlag=$p($g(^OEORD(ordId,"I",itmId,"DHC")),"^",62)
    q:impFlag'="Y" -104
    s impInclbInfo=$p($g(^OEORD(ordId,"I",itmId,"DHC")),"^",63)
    s impInclb=$p(impInclbInfo,",",1)
    s batSp=$p(impInclbInfo,",",2)  //批次基本单位售价
    q:(ruleFlag=3)&&(impInclb="") -105
    s impInciInfo=$p($g(^OEORD(ordId,"I",itmId,"DHC")),"^",64)
    s impInci=$p(impInciInfo,",",1)
    s inciSp=$p(impInciInfo,",",2)   //基本单位售价
    q:(impInci="")&&(impInclb="") -105
    s incId=""
    i ruleFlag=3 s incId=+impInclb
    e  s incId=impInci
    s buomId=$p(^INCI(incId,1),"^",10)
    s Status="TC"
    s iLSub=$o(^INCI("IL_LOC",recLocId,incId,"")) 
    i +iLSub>0 s incil=incId_"||"_iLSub
    e  s incil=""
    q:incil="" -105
    TSTART
    s dspId="",errInfo=""
    f  s dspId=$o(^DHCOEDISQTY(0,"OEORI",OeoriID,dspId)) q:(dspId="")||(errInfo'="")  d
    .q:+$o(^DHCOEDISQTY(dspId,"I",0))>0
    .s dspQty=$p(^DHCOEDISQTY(dspId),"^",5)
    .s qtyUomId=$p(^DHCOEDISQTY(dspId),"^",6)
    .s Fac=##class(web.DHCST.Common.UtilCommon).UOMFac(qtyUomId,buomId)
    .s bQty=dspQty*Fac
    .i ruleFlag'=3 d
    ..//非批次价
    ..s rp=##Class(web.DHCSTPRICE).GetCurRp(incId,"",hospId)
    ..s dspbStr=dspId_"^^"_bQty_"^"_batSp_"^"_rp_"^"_incId_"^"_Status
    ..s retVal=##Class(web.DHCSTOEDispBatch).InsDspBatch(dspbStr)
    ..i $p(retVal,"^",1)'=0 s errInfo=-109_"^插入打包子表失败,统一价" q
    ..i incil'="" d
    ...s dspbID=$p(retVal,"^",2)
    ...s sqlStr=incil_"^"_"1"_"^"_bQty_"^"_""_"^"_dspbID_"^"_recLocId
    ...s Ret=##Class(PHA.COM.Reserve).SetReserve(sqlStr)
    .e  d
    ..//批次价
    ..s rp=##Class(web.DHCSTPRICE).GetCurRp(impInclb,"",hospId)
    ..s dspbStr=dspId_"^"_impInclb_"^"_bQty_"^"_batSp_"^"_rp_"^"_incId_"^"_Status
    ..s retVal=##Class(web.DHCSTOEDispBatch).InsDspBatch(dspbStr)
    ..i $p(retVal,"^",1)'=0 s errInfo=-1000_"^插入打包子表失败,批次价库存充足时" q
    ..s dspbID=$p(retVal,"^",2)
    ..// 处理批次占用数
    ..s sqlStr=incil_"^"_"1"_"^"_bQty_"^"_impInclb_"^"_dspbID_"^"_recLocId
    ..s Ret=##Class(PHA.COM.Reserve).SetReserve(sqlStr)
    i errInfo'="" d
    .TROLLBACK
    .// 记录日志
    .d ErrorRecord^DHCSTERROR("DHCSTPARAMER","入参:"_OeoriID_","_DateH,$p(errInfo,"^",2))
    q:errInfo'="" 0
    TCOMMIT
    q 1

InsDspBatchForImport
    s $zt=""
    s ret = $$ErrorRecord^DHCSTERROR("DHCSTPARAMER", "RunTime", $ze)
    q "ERROR-"_$tr($ze,"<>^'"," %- ")
}

/// Description: 住院开医嘱时处理配药批次表(因为涉及到实时的取逻辑库存,本方法同时处理了科室在途和科室批次在途)
/// Creater:     zhouyg
/// CreateDate:  2013-08-08
/// Table:       DHC_OEDispensing,DHCOEDispBatch,inc_itmloc,inc_itmlcbt
/// Input:       DspID(DHC_OEDispensing的ID),RollFlag是否滚医嘱(1为滚医嘱,该参数不再使用),InsType(1:发药,2:下医嘱)
/// Output:      INCLB^数量^进价^售价
/// Return:      0-没有满足条件的批次,1-有满足条件的批次,<0表示错误
/// Modify:      不再判断库存是否足够,增加插入不成功的日志,yunhaibao20191211
///              增加InsType参数,默认2,1为(发药重写插入),yunhaibao20200402
///              增加CallType参数,默认空,1为(发药重写插入),MaYuqiang20220722
/// Debug:       w ##class(web.DHCST01).InsDspBatch("28","","")
ClassMethod InsDspBatch(DspID As %String, RollFlag As %String = "", DateH = "", InsType = "2", CallType = "") As %String
{
    s $ZT="ErrInsDspBatch"
    q:DspID="" -101
    s OeoriID=$p($g(^DHCOEDISQTY(DspID)),"^",1)
    s OrdID=$p(OeoriID,"||",1)
    s OrdSub=$p(OeoriID,"||",2)
    s PriorID=$p(^OEORD(OrdID,"I",OrdSub,1),"^",8)
    q:PriorID="" -104
    s priorCode=$p($g(^OECPR(PriorID)),"^",1) ;自备药不处理 20160112 zhouyg
    q:$ZCVT(priorCode,"U")["OM" 1
    s Arcim=$p(^OEORD(OrdID,"I",OrdSub,1),"^",2) 
    q:Arcim="" -102
    s RecLocID=$p($g(^DHCOEDISQTY(DspID)),"^",24)
    q:RecLocID="" -103
    s HospID=$p($g(^CTLOC(RecLocID)),"^",22)
    s RuleFlag=##Class(web.DHCSTCOMMPARA).GetRpRule(HospID,DateH)
    s pid=##Class(web.DHCSTCOMMO).NewPidOEInclb()
    s PackInci=$p($g(^DHCOEDISQTY(DspID,"EXP")),"^",1)  //开医嘱生成的库存项列表
    q:PackInci="" -105
    s PackNum=$l(PackInci,$c(1))
    q:PackNum=0 -105
    s Status="TC"   
    TSTART
    s RetCode=""
    f ii=1:1:PackNum q:(RetCode'="")  d
    .s IncStr=$p(PackInci,$c(1),ii)
    .s IncID=+$p(IncStr,"!",1)
    .i IncID=0 s RetCode=-107_"^PackInci的库存项为空" q
    .s DspQty=+$p(IncStr,"!",2)
    .i DspQty=0 s RetCode=-107_"^PackInci的库存项为空" q
    .s ILSub=$o(^INCI("IL_LOC",RecLocID,IncID,"")) 
    .i +ILSub>0 s incil=IncID_"||"_ILSub
    .e  s incil=""
    ./// 1 非批次价,直接用医嘱计算出的库存项和数量插入打包子表
    .i RuleFlag'=3 d
    ..s sp=##Class(web.DHCSTPRICE).GetCurSp(IncID,"",HospID)
    ..s rp=##Class(web.DHCSTPRICE).GetCurRp(IncID,"",HospID)
    ..s DspbStr=DspID_"^"_""_"^"_DspQty_"^"_sp_"^"_rp_"^"_IncID_"^"_Status
    ..s RetIns=##Class(web.DHCSTOEDispBatch).InsDspBatch(DspbStr)
    ..s InsSQLCODE=$p(RetIns,"^",1)
    ..i InsSQLCODE'=0 d
    ...s RetCode=-1000_"^插入打包子表失败,统一价"
    ..q:RetCode'=""
    ..i incil'="" d
    ...s dspbID=$p(RetIns,"^",2)
    ...s SqlStr=incil_"^"_"1"_"^"_DspQty_"^"_""_"^"_dspbID_"^"_RecLocID
    ...s Ret=##class(PHA.COM.Reserve).SetReserve(SqlStr)
    .q:RuleFlag'=3
    ./// 2 批次价,计算批次后插入打包子表
    .i incil="" s RetCode="-1^插入打包子表,科室库存项为空,库存项Id为"_IncID q
    .i $$LK()<0 s RetCode="-1^插入打包子表,科室库存项加锁失败,科室库存项Id为"_incil q
    .s RetInclb=..GetInclbQty(incil,DspQty,pid,InsType,CallType)
    ./// 2.1 批次价,库存不足时找最后批次补充
    .i RetInclb'=1 d
    ..d UK
    ..k ^TMP("DHCST","web.DHCST01","Inclb",pid)
    ..s Inclb=##Class(web.DHCSTCOMINC).GetLastInclbByLoc(incil) //滚医嘱时如果库存不足取科室最后一个批次 20141224
    ..s sp=##Class(web.DHCSTPRICE).GetCurSp(Inclb,"",HospID)
    ..s rp=##Class(web.DHCSTPRICE).GetCurRp(Inclb,"",HospID)
    ..s DspbStr=DspID_"^"_Inclb_"^"_DspQty_"^"_sp_"^"_rp_"^"_IncID_"^"_Status
    ..s RetIns=##Class(web.DHCSTOEDispBatch).InsDspBatch(DspbStr)
    ..s InsSQLCODE=$p(RetIns,"^",1)
    ..i InsSQLCODE'=0 s RetCode=-1000_"^插入打包子表失败,批次价库存不足时"
    .q:RetInclb'=1
    ./// 2.2 批次价,库存充足
    .s iNum=""
    .f  s iNum=$o(^TMP("DHCST","web.DHCST01","Inclb",pid,iNum)) q:(iNum="")!(RetCode'="")  d
    ..s inclbStr=^(iNum)
    ..s rqty=+$p(inclbStr,"^",1)
    ..s sp=+$p(inclbStr,"^",2)
    ..s rp=+$p(inclbStr,"^",3)
    ..s rinclb=$p(inclbStr,"^",4)
    ..s DspbStr=DspID_"^"_rinclb_"^"_rqty_"^"_sp_"^"_rp_"^"_IncID_"^"_Status
    ..s RetIns=##Class(web.DHCSTOEDispBatch).InsDspBatch(DspbStr)
    ..s InsSQLCODE=$p(RetIns,"^",1)
    ..i InsSQLCODE'=0 s RetCode=-1000_"^插入打包子表失败,批次价库存充足时" q
    ..s dspbID=$p(RetIns,"^",2)
    ..//处理批次占用数
    ..s SqlStr=incil_"^"_"1"_"^"_rqty_"^"_rinclb_"^"_dspbID_"^"_RecLocID
    ..s Ret=##class(PHA.COM.Reserve).SetReserve(SqlStr)
    .d UK
    .k ^TMP("DHCST","web.DHCST01","Inclb",pid)
    i RetCode'="" d
    .TROLLBACK
    .// 记录日志
    .d ErrorRecord^DHCSTERROR("DHCSTPARAMER","入参:"_DspID_","_RollFlag_","_DateH ,$p(RetCode,"^",2))
    q:RetCode'="" 0
    TCOMMIT
    q 1
LK()
    l +^INCI(IncID,"IL",ILSub):5 e  q -1
    q 0
UK
    l -^INCI(IncID,"IL",ILSub)
    q
ErrInsDspBatch
    s ret = $$ErrorRecord^DHCSTERROR("DHCSTPARAMER", "RunTime", $ze)
    q "ERROR-"_$tr($ze,"<>^'"," %- ")
}

/// Descript：   开医嘱时取价格显示(批次价格使用,仅仅开医嘱使用)
/// Creater：    zhouyg
/// CreateDate：2014-12-24
/// Table：      Arc_ItmMast,Inc_itm,inc_itmloc,inc_itmlcbt
/// Input：      Arc_ItmMast的ID,接收科室ID
/// Output： 批次售价
/// Return： 批次售价,-102医嘱项为空,-103科室为空
/// Update： 20170905 zhouyg 循环找库存项取第一个在用库存项的价格
///             20210722 yunhaibao 去除加锁,意义不大(因打包子表少数据问题修正)
ClassMethod GetBatSp(Arcim As %String, RecLoc As %String, IncID As %String) As %String
{
    s $ZT="ErrGetBatSp"
    q:Arcim="" -102
    q:RecLoc="" -103
    s HospID=$p($g(^CTLOC(RecLoc)),"^",22)
    s pid=##Class(web.DHCSTCOMMO).NewPidOEInclb()
    s inci="",RetSp=0
    f  s inci=$o(^INCI(0,"ARCIM_DR",$p(Arcim,"||",1),inci)) q:(inci="")||(RetSp'=0)  d
    .q:(IncID'="")&&(IncID'=inci)
    .s NotUseFlag=$p(^INCI(inci,2),"^",9)
    .q:NotUseFlag="Y"
    .s ILSub=$o(^INCI("IL_LOC",RecLoc,inci,"")) 
    .q:ILSub=""
    .s DspQty=1 //取库存满足大于等于1的批次即可
    .s incil=inci_"||"_ILSub
    .i $$LKBatSp()<0 q
    .s RetCode=..GetInclbQty(incil,DspQty,pid,2)
    .i RetCode'=1 d
    ..d UKBatSp
    ..k ^TMP("DHCST","web.DHCST01","Inclb",pid)
    ..s RetSp=##Class(web.DHCSTPRICE).GetCurSp(inci,"",HospID)
    .e  d
    ..s iNum=$o(^TMP("DHCST","web.DHCST01","Inclb",pid,""))
    ..q:iNum=""
    ..s RetSp=$p(^TMP("DHCST","web.DHCST01","Inclb",pid,iNum),"^",2)
    ..d UKBatSp
    ..k ^TMP("DHCST","web.DHCST01","Inclb",pid)
    q RetSp
LKBatSp()
    //l +^INCI(inci,"IL",ILSub):5 e  q -1
    q 0
UKBatSp
    //l -^INCI(inci,"IL",ILSub)
    q
ErrGetBatSp
    s ret = $$ErrorRecord^DHCSTERROR("DHCSTPARAMER", "RunTime", $ze)
    q "ERROR-"_$tr($ze,"<>^'"," %- ")
}

/// Descript：   开医嘱或发药取可用库存的批次
/// Creater：    zhouyg
/// CreateDate：2013-08-12
/// Input：      Incil-科室库存项ID,ReqQty-需要数量,pid-进程ID,ReseFlag-是否考虑在途数(1-发药使用只考虑出库占用,2-开医嘱使用考虑医嘱占用数和出库占用数),CallType(1-发药)
///             ResInclbDATA-数组数据,临时占用,批次价重新分配库存会用到
///             QtyType-数量类型(1-数量需为整包装；""-不限制)
/// Output： ^TMP("DHCST","web.DHCST01","Inclb",pid,inclb),输出结果必须是相同售价的批次
/// Return： 0-没有满足条件的批次,1-有满足条件的批次,<0表示错误
/// Modify:     2018-10-22,增加CallType表示是否判断医嘱批次不可用,hulihua
///             2019-08-29,修改两个^TMP为数组,yunhaibao
///             w ##class(web.DHCST01).GetInclbQty("250||7",20,987515997,"",1)
ClassMethod GetInclbQty(Incil As %Library.String, ReqQty As %Library.String, pid As %String, ReseFlag As %String = "", CallType As %String = "", ResInclbDATA = "", QtyType = "")
{
    q:Incil="" -201
    q:+ReqQty=0 -203
    s Inci=$p(Incil,"||",1)
    q:Inci="" -205
    s ilSub=$p(Incil,"||",2)
    q:ilSub="" -204
    s locID=$p(^INCI(Inci,"IL",ilSub),"^",1)
    q:locID="" -205
    s HospID=$p($g(^CTLOC(locID)),"^",22)
    k GetInclbQtyDATA   // 记录排序等
    k ^TMP("DHCST","web.DHCST01","Inclb",pid)
    i QtyType=1  d
    .s cfFlag=##class(PHA.COM.Drug).IsHerb(Inci)
    .i cfFlag="Y" s QtyType=""
    s fac = 1 
    i QtyType=1  d
    .s minUomId = "" 
    .s minDispUomId = ##class(web.DHCSTSTKQTY).GetMinDispUom(Inci, locID)
    .i (minDispUomId '= "") s minUomId = minDispUomId
    .e  d 
    ..s outUomId=$p(^INCI(Inci,1),"^",12) 
    ..i outUomId="" s outUomId=$p(^INCI(Inci,3),"^",6)
    ..s minUomId = outUomId
    .s bUomId=$p(^INCI(Inci,1),"^",10)
    .s fac=##class(web.DHCST.Common.UtilCommon).UOMFac(minUomId,bUomId)
    
    ///取所有库存大于0的批次
    s SelBatFlag=##Class(web.DHCSTCOMMPARA).GetSelBatRule(HospID)                            //选择批次索引规则
    s SelOrderBatFlag=##Class(web.DHCSTCOMMPARA).GetSelOrderBatRule(HospID)                  //选择批次索引规则
    s DispActiveFlag="N"
    i CallType="1" d
    .s DispActiveFlag=##class(web.DHCST.Common.AppCommon).GetParamOeoriBatActiveDisp(locID)
    s BatEnough=""
    s inclb=""
    i CallType="1" d // 发药
    .f  s inclb=$o(^DHCINCLBi("ACISTKBT","Y",locID,Inci,inclb)) q:(inclb="")  d
    ..d CalcuGetInclbQty
    e  d             // 开医嘱
    .f  s inclb=$o(^DHCINCLBi("ACIBT","Y",locID,Inci,inclb)) q:(inclb="")  d
    ..d CalcuGetInclbQty
    ///确定所有符合条件的批次
    s dda="",newqty=+ReqQty,LastSp="",stkflag=0,iNum=0
    f  s dda=$o(GetInclbQtyDATA("DHCST","web.DHCST01","EXSP",pid,dda)) q:(dda="")!(stkflag=1)  d
    .s tta=""
    .f  s tta=$o(GetInclbQtyDATA("DHCST","web.DHCST01","EXSP",pid,dda,tta)) q:(tta="")!(stkflag=1)  d
    ..s expd=""
    ..f  s expd=$o(GetInclbQtyDATA("DHCST","web.DHCST01","EXSP",pid,dda,tta,expd)) q:(expd="")!(stkflag=1)  d
    ...s ibb=""
    ...f  s ibb=$o(GetInclbQtyDATA("DHCST","web.DHCST01","EXSP",pid,dda,tta,expd,ibb)) q:(ibb="")!(stkflag=1)  d
    ....s ManfID=""
    ....f  s ManfID=$o(GetInclbQtyDATA("DHCST","web.DHCST01","EXSP",pid,dda,tta,expd,ibb,ManfID)) q:(ManfID="")!(stkflag=1)  d
    .....q:GetInclbQtyDATA("DHCST","web.DHCST01","MANF",pid,ManfID)<+ReqQty
    .....s sp=""
    .....f  s sp=$o(GetInclbQtyDATA("DHCST","web.DHCST01","EXSP",pid,dda,tta,expd,ibb,ManfID,sp)) q:(sp="")!(stkflag=1)  d
    ......//q:(LastSp'="")&(LastSp'=sp)
    ......//s LastSp=sp //zhouyg 20131213 不判断价格,同一执行记录可以不同价格
    ......s inclb=""
    ......f  s inclb=$o(GetInclbQtyDATA("DHCST","web.DHCST01","EXSP",pid,dda,tta,expd,ibb,ManfID,sp,inclb)) q:(inclb="")!(stkflag=1)  d
    .......s clbstr=GetInclbQtyDATA("DHCST","web.DHCST01","EXSP",pid,dda,tta,expd,ibb,ManfID,sp,inclb)
    .......s lbqty=+$p(clbstr,"^",1)
    .......q:(BatEnough=1)&&(lbqty<ReqQty)
    .......s rp=+##Class(web.DHCSTPRICE).GetCurRp(inclb,"",HospID)
    .......s iNum=iNum+1
    .......i lbqty'<newqty d
    ........s ^TMP("DHCST","web.DHCST01","Inclb",pid,iNum)=newqty_"^"_sp_"^"_rp_"^"_inclb
    ........s newqty=0
    ........s stkflag=1
    .......e  d
    ........s ^TMP("DHCST","web.DHCST01","Inclb",pid,iNum)=lbqty_"^"_sp_"^"_rp_"^"_inclb
    ........s newqty=newqty-lbqty
    i stkflag'=1 d
    .k ^TMP("DHCST","web.DHCST01","Inclb",pid)
    q:stkflag'=1 stkflag
    k GetInclbQtyDATA
    q stkflag 
CalcuGetInclbQty 
    i 1=1 d
    .q:+inclb=0
    .s LBSub=$p(inclb,"||",3)
    .i ReseFlag=1 d
    ..s lbqty=##CLASS(web.DHCSTSTKQTY).GetCurQtyINCLB(inclb)    //发药时使用，只判断出库占用数
    .else  if ReseFlag=2 d
    ..s lbqty=##CLASS(web.DHCSTSTKQTY).GetAvialQtyINCLB(inclb)  //zhouyg 20140707 改为开医嘱时判断出库占用数和医嘱占用数
    .e  d
    ..s lbqty=##CLASS(web.DHCSTSTKQTY).CurQtyINCLB(inclb)   //不考虑在途数
    .i $d(ResInclbDATA(inclb)) d
    ..s lbqty=lbqty-ResInclbDATA(inclb)
    .q:lbqty'>0
    .i QtyType=1 s lbqty=(lbqty\fac)*fac  // 门诊西药 取整包装数量()  zhaozhiduan 2021-12-29
    .q:(lbqty'>0) // 2023-02-15, yunhaibao
    .q:(SelOrderBatFlag=2)&&(lbqty<ReqQty) //按数量优先,库存均不够时认为库存不足,yunhaibao20161209
    .s incib=$P(^INCI(Inci,"IL",ilSub,"LB",LBSub),"^",1)
    .q:incib=""
    .s IBSub=$p(incib,"||",2)
    .q:IBSub=""
    .q:'$d(^INCI(Inci,"IB",IBSub))
    .s ExpDate=+$p($g(^INCI(Inci,"IB",IBSub)),"^",2)
    .q:(##class(web.DHCSTSTKQTY).ValidInclbExpDate(inclb) '= "Y")
    .q:'$d(^DHCINCLB(0,"LB",inclb))
    .s dhcinclb=$o(^DHCINCLB(0,"LB",inclb,""),-1)
    .s inclbactive=$p($g(^DHCINCLB(dhcinclb)),"^",2)
    .q:(DispActiveFlag="N")&&(inclbactive'="Y") //yunhaibao20151231,过滤不可用
    .s sp=+##Class(web.DHCSTPRICE).GetCurSp(inclb,"",HospID)
    .s (DateAdd,TimeAdd,ManfID)="0"
    .s dhcincib=$o(^DHCINCIB(0,"INCIB",incib,""))
    .i dhcincib'="" d
    ..s DHCINCIB=$g(^DHCINCIB(dhcincib))
    ..s DateAdd=+$p(DHCINCIB,"^",10)
    ..s TimeAdd=+$p(DHCINCIB,"^",11)
    ..s ManfID=+$p(DHCINCIB,"^",7)
    .i SelBatFlag=1 d
    ..s index1=+ExpDate //有效期优先
    ..s index2=DateAdd
    ..s index3=TimeAdd
    .e  d
    ..s index1=+DateAdd //先进先出
    ..s index2=TimeAdd
    ..s index3=ExpDate 
    .i (SelOrderBatFlag=1)&&(lbqty>=ReqQty) s BatEnough=1
    .s GetInclbQtyDATA("DHCST","web.DHCST01","EXSP",pid,index1,index2,index3,LBSub,+ManfID,sp,inclb)=lbqty
    .s GetInclbQtyDATA("DHCST","web.DHCST01","MANF",pid,+ManfID)=$g(GetInclbQtyDATA("DHCST","web.DHCST01","MANF",pid,+ManfID))+lbqty    //20140925增加 开医嘱和发药时每次必须是同厂家的
    q
}

/// Descript：   开医嘱前判断批次库存是否满足
/// Creater：    zhouyg
/// CreateDate：2013-08-12
/// Input：      医嘱项ID,接收科室ID,基本单位数量(医嘱总数量)
/// Return:     0-没有满足条件的批次,1-有满足条件的批次,<0表示错误
ClassMethod GetAvailQtyByArc(Arcim As %String, recLoc As %String, Qty As %String) As %String
{
    q:Arcim="" -102
    q:recLoc="" -103
    s ArcimS=$p(Arcim,"||",1)
    q:ArcimS="" -102
    s pid=##Class(web.DHCSTCOMMO).NewPidOEInclb()
    s Inci="",stkflag=0
    f  s Inci=$o(^INCI(0,"ARCIM_DR",ArcimS,Inci)) q:(Inci="")||(stkflag=1)  d
    .s ilSub=$o(^INCI("IL_LOC",recLoc,Inci,"")) 
    .q:ilSub=""
    .s incil=Inci_"||"_ilSub
    .s stkflag=..GetInclbQty(incil,Qty,pid,2)
    .k ^TMP("DHCST","web.DHCST01","Inclb",pid)
    q stkflag
}

/// Descript：   开医嘱前判断批次库存是否满足
/// Creater：    zhouyg
/// CreateDate：2019-09-01
/// Input：      医嘱项ID,接收科室ID,基本单位数量(医嘱总数量)
/// Return:     0-没有满足条件的批次,1-有满足条件的批次,<0表示错误
ClassMethod GetAvailQtyByInc(IncID As %String, RecLocID As %String, Qty As %String) As %String
{
    q:IncID="" -102
    q:RecLocID="" -103
    s pid=##Class(web.DHCSTCOMMO).NewPidOEInclb()
    s ilSub=$o(^INCI("IL_LOC",RecLocID,IncID,"")) 
    q:ilSub=""
    s incil=IncID_"||"_ilSub
    s stkflag=..GetInclbQty(incil,Qty,pid,2)
    k ^TMP("DHCST","web.DHCST01","Inclb",pid)
    q stkflag
}

/// Descript：   根据配药表ID判断开医嘱或发药时判断是否有可用库存的批次
/// Creater：    zhouyg
/// CreateDate：2013-08-12
/// Input：      DHC_OEDispensing的ID
/// Return:     0-没有满足条件的批次,1-有满足条件的批次,<0表示错误
ClassMethod GetAvailQtyByDsp(DspID As %String)
{
    q:DspID="" -101
    s OeoriID=$p($g(^DHCOEDISQTY(DspID)),"^",1)
    s OrdID=$p(OeoriID,"||",1)
    s OrdSub=$p(OeoriID,"||",2)
    q:(OrdID="")!(OrdSub="") -105
    s PriorID=$p(^OEORD(OrdID,"I",OrdSub,1),"^",8)
    q:PriorID="" -6
    s priorCode=$p($g(^OECPR(PriorID)),"^",1) ;自备药不处理 20160112 zhouyg
    q:$ZCVT(priorCode,"U")["OM" 1
    s Arcim=$p(^OEORD(OrdID,"I",OrdSub,1),"^",2) 
    q:Arcim="" -102
    s recLoc=$p($g(^DHCOEDISQTY(DspID)),"^",24)
    q:recLoc="" -103
    s Inci=$o(^INCI(0,"ARCIM_DR",$p(Arcim,"||",1),"")) 
    q:Inci="" -104
    s ilSub=$o(^INCI("IL_LOC",recLoc,Inci,"")) 
    q:ilSub="" -106
    s incil=Inci_"||"_ilSub
    s DspQty=$p($g(^DHCOEDISQTY(DspID)),"^",11)
    //s stkflag=..GetAvailQty(incil,DspQty)
    s pid=##Class(web.DHCSTCOMMO).NewPidOEInclb()
    s stkflag=..GetInclbQty(incil,DspQty,pid,2)
    k ^TMP("DHCST","web.DHCST01","Inclb",pid)
    q stkflag
}

/// Descript：   开医嘱或发药时判断是否有可用库存的批次
/// Creater：    zhouyg
/// CreateDate：2013-08-12
/// Input：      inc_itmloc的ID,ReqQty-需要的数量
/// Return:     0-没有满足条件的批次,1-有满足条件的批次,<0表示错误
ClassMethod GetAvailQty(incil As %String, ReqQty As %String) As %String
{
    q 0 //此方法不用，统一改为GetInclbQty 方法
    s Inci=$p(incil,"||",1)
    s ilSub=$p(incil,"||",2)
    q:(Inci="")!(ilSub="") -1
    s LocID=$p(^INCI(Inci,"IL",ilSub),"^",1)
    q:LocID="" -2
    s HospID=$p(^CTLOC(LocID),"^",22)
    s pid=##Class(web.DHCSTCOMMO).NewPidOEInclb()
    k ^TMP("DHCST","OEAVAIL",pid)
    s inclb=""
    f  s inclb=$o(^DHCINCLBi("ACISTKBT","Y",LocID,Inci,inclb)) q:(inclb="")  d
    .q:+inclb=0
    .s LBSub=$p(inclb,"||",3)
    .s lbqty=##CLASS(web.DHCSTSTKQTY).GetCurQtyINCLB(inclb)
    .q:lbqty'>0
    .s sp=+##Class(web.DHCSTPRICE).GetCurSp(inclb,"",HospID)
    .s ^TMP("DHCST","OEAVAIL",pid,"SP",sp)=$g(^TMP("DHCST","OEAVAIL",pid,"SP",sp))+lbqty
    ///
    s stkflag=0
    s sp=""
    f  s sp=$o(^TMP("DHCST","OEAVAIL",pid,"SP",sp)) q:(sp="")!(stkflag=1)  d
    .q:^TMP("DHCST","OEAVAIL",pid,"SP",sp)<ReqQty
    .s stkflag=1
    k ^TMP("DHCST","OEAVAIL",pid)
    q stkflag
}

/// Descript:   判断开医嘱保存的批次库存是否够用,转移自web.DHCSTPCHCOLLS(zhouyg 20141225)
/// Creater:    zhouyg
/// CreateDate: 2014-12-25  
/// Input:      DspID-DHC_OEDispensing的ID,进程ID
/// Return:     1-够用，0-不够用，需要重新取批次
/// Others:     yunhaibao20170831,添加inci参数;
///             hulihua2018-10-22增加发药是否判断医嘱批次不可用的配置
ClassMethod GetDspClb(dsp As %String, pid As %String, inci = "") As %String
{
    k ^TMP("DHCST","web.DHCST01","Inclb",pid)
    q:(dsp = "") 0
    q:($o(^DHCOEDISQTY(dsp, "I", 0)) = "") 0
    s sub = 0, retFlag = 1, iNum = 0
    for{
        s sub = $o(^DHCOEDISQTY(dsp, "I", sub), 1, subData)
        q:(sub = "")
        s qty = $p(subData,"^",2)
        s inclb = $p(subData,"^",1)
        if (##class(web.DHCSTSTKQTY).ValidInclbForDisp(inclb) '= "Y"){
            s retFlag = 0
            q
        }
        s curQty = ##Class(web.DHCSTSTKQTY).GetCurQtyINCLB(inclb)
        if (curQty < qty){
            s retFlag = 0
            q
        }
        s rp = $p(subData,"^",3)
        s sp = $p(subData,"^",4)
        s iNum = iNum + 1
        s ^TMP("DHCST", "web.DHCST01", "Inclb", pid, iNum) = qty _ "^" _ sp _ "^" _ rp _ "^" _ inclb
    }
    if (retFlag '= 1){
        k ^TMP("DHCST", "web.DHCST01", "Inclb", pid)
    }
    q retFlag
}

/// Descript:   判断开医嘱保存的批次库存是否够用,转移自web.DHCSTOutPhDisp(zhouyg 20141225)
/// Creater:    zhouyg
/// CreateDate: 2014-12-25  
/// Input:      OeoriID-OE_OrdItem的ID,进程ID,库存项ID,是否判读医嘱批次不可用(1-不判断，空-判断)
/// Return:     1-够用，0-不够用，需要重新取批次
/// Others:     hulihua 2018-10-26,新医嘱改造修改为按照打包子表去判断以及增加发药是否判断医嘱批次不可用的配置
/// w ##class(web.DHCST01).GetDspClbForOut("99809||3","987414997",308)
ClassMethod GetDspClbForOut(DspbBatchId As %String, pid As %String, incId As %String = "", ResInclbDATA = "") As %String
{
    k ^TMP("DHCST", "web.DHCST01", "Inclb", pid)
    s dsp = +DspbBatchId,sub = +$p(DspbBatchId, "||", 2)
    s subData = $g(^DHCOEDISQTY(dsp, "I", sub))
    s inclb = $p(subData, "^", 1)
    s inci = +inclb, il = +$p(inclb, "||", 2), lb = +$p(inclb, "||", 3)
    q:(incId '= "")&&(incId '= inci) 0
    q:(##class(web.DHCSTSTKQTY).ValidInclbForDisp(inclb) '= "Y") 0
    s dspQty = $p(subData, "^", 2)
    s curQty = ##Class(web.DHCSTSTKQTY).GetCurQtyINCLB(inclb)
    i $d(ResInclbDATA(inclb)) {
        s curQty=curQty - ResInclbDATA(inclb)
    }
    q:(curQty < dspQty) 0
    s rp=$p(subData, "^", 3)
    s sp=$p(subData, "^", 4)
    s ^TMP("DHCST", "web.DHCST01", "Inclb", pid, 1) = dspQty _ "^" _ sp _ "^" _ rp _ "^" _ inclb
    q 1
}

/// creator:yunhaibao
/// createdate:20160307
/// description:根据打包表id处理在途数
/// UpdInclbResQty
ClassMethod MinusResQtyByDspBatch(dsprowid As %String)
{
    s minusret=0
    s dspsub=0
    f  s dspsub=$o(^DHCOEDISQTY(dsprowid,"I",dspsub)) q:(dspsub="")||(minusret<0)  d
    .s minusret=..DelResDeatilByDspSub(dsprowid_"||"_dspsub)
    q minusret
}

/// Description: 删除打包子表时,处理在途以及在途明细
/// w ##class(web.DHCST01).DelResDeatilByDspSub()
ClassMethod DelResDeatilByDspSub(DspSubId As %String)
{
    q ##class(PHA.COM.Reserve).DelReserveByDspBat(DspSubId)
}

/// Description: 插入打包子表前, 根据基数药设置获取基数药优先使用的接收科室, 库存足够, 直接修正接收科室为设置的科室(一般为开单|所在病区)
///              独立事务, 仅在插入打包子表前调用
/// Creator:     yunhaibao
/// CreateDate:  2023-04-18
/// Since:       >=imedical 9.0
/// Return:      $$$OK 无异常
ClassMethod UpdateRecLoc4BaseOrder(dsp As %String)
{
    q:(dsp = "") $$$OK
    q:(+$o(^DHCOEDISQTY(dsp, "I", 0)) > 0) $$$OK
    try{
        s dspData = $g(^DHCOEDISQTY(dsp))
        s category = $p(dspData, "^", 27)
        ret:(category = 0) $$$OK
        s dspRecLocID = $p(dspData, "^", 24)
        s baseRecLocID = ##class(PHA.COM.Method).GetBaseDrugPriRecLoc(dsp)
        ret:(baseRecLocID = "") $$$OK
        s oeori = $p(dspData, "^", 1)
        s ord = $p(oeori, "||", 1)
        s ordItm = $p(oeori, "||", 2)
        s priorityID = $p(^OEORD(ord, "I", ordItm, 1), "^", 8)
        ret:(priorityID = "") $$$OK
        s priorityCode = $p($g(^OECPR(+priorityID)), "^", 1)
        ret:(priorityCode [ "OM") $$$OK
        ret:(priorityCode = "OUT") $$$OK
        #; s hospID = $p(^CTLOC(dspRecLocID), "^", 22)
        #; s rpRule = ##Class(web.DHCSTCOMMPARA).GetRpRule(hospID)
        s inciPackComb = $p($g(^DHCOEDISQTY(dsp, "EXP")), "^", 1)
        ret:(inciPackComb = "") $$$OK
        ret:($l(inciPackComb, $c(1)) = 0) $$$OK
        s pid=##Class(web.DHCSTCOMMO).NewPidOEInclb()
        for i = 1 : 1 : $l(inciPackComb, $c(1)) {
            s dspInciStr = $p(inciPackComb, $c(1), 1)
            s inci = $p(dspInciStr, "!", 1)
            s dspQty = $p(dspInciStr, "!", 2)
            s inciCh = $o(^INCI("IL_LOC", baseRecLocID, inci, ""))
            s incil = $s(inciCh = "" : "" , 1 : inci _ "||" _ inciCh)
            ret:(incil = "") $$$OK
            #; 对于基数药, 统一价和批次价都应该先判断库存
            s enoughFlag = ##class(web.DHCST01).GetInclbQty(incil, dspQty, pid)
            if (enoughFlag '= 1){
                ret $$$OK
            }
        }
        ts
        s ret = ##class(PHA.COM.Core.Face).UpdateRecLoc(dsp, baseRecLocID)
        if (+ret < 0){
            tro
        }else{
            tc
        }
    }catch ex {
        s ret = "-1^" _ $g(%msg)
    }
    q $g(ret)
}

}
