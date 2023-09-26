Import SQLUser

/// Creator:Liang Qiang
/// CreatDate:2009-05-08
/// Description:为其它组提供接口函数,其它组统一调用这里
/// 
Class web.DHCSTINTERFACE Extends %RegisteredObject
{

/// Creator:Liang Qiang
/// CreatDate:2009-05-08
/// Description:取三大项附加信息中的批准文号
/// Table:DHC_ItmAddionInfo
/// Input:医嘱项Rowid
/// Output:三大项附加信息中的批准文号
/// Retrun:三大项附加信息中的批准文号
/// Others:
ClassMethod GetRemark(arcim As %String) As %String
{
    s arcim=+arcim q:arcim<1 ""
    s inci=$o(^INCI(0,"ARCIM_DR",arcim,""))
    q:inci="" ""
    s info=$O(^DHCITMINFO(0,"INCI",inci,""))
    q:info="" ""
    s remark=$p($g(^DHCITMINFO(info)),"^",10)
    q $g(remark)
}

/// Descript：取处方号
/// Creater：zhouyg
/// CreateDate:20110426
/// Input:      医嘱项RowID
/// Retrun: 处方号描述(根据用户维护，一般为"处方药","非处方药")
ClassMethod GetOTC(arcim As %String) As %String
{
    q:arcim="" ""
    s phcdfID=##Class(web.DHCSTCOMMPHC).GetPhcdfByArcim(arcim)
    s phcdID=$p(phcdfID,"||",1)
    s phcdSub=$p(phcdfID,"||",2)
    q:(phcdID="")||(phcdSub="") ""
    s OTC=$p($g(^PHCD(phcdID,"DF",phcdSub,"DHC")),"^",35)
    q OTC
}

/// Descript：传送发药数据至
/// Creater：LiangQiang
/// CreateDate:20110505
/// Input:  发药主表rowid , 药房标识 1 :住院  非1: 门诊 
/// Retrun: 0 成功，非0 失败
/// 
ClassMethod SendDataToDispmachine(phrowid, pharmacyflag) As %String
{
    s Soap=##Class(DHCENS.DRUG.BS.SOAP.WebENSDRUGServiceSoap).%New() 
    i pharmacyflag="I" d
    .s Input="<Request><Drug><PhacID >"_phrowid_"</ PhacID></Drug></Request>" 
    .s RetStr=Soap.IPDrugSend(Input) 
    i pharmacyflag="O" d
    .s Input="<Request><Drug><PhdID>"_phrowid_"</PhdID></Drug></Request>"
    .s RetStr=Soap.OPDrugSend(Input)
    s reader = ##class(%XML.Reader).%New()
    s sc=reader.OpenString(RetStr)
    d reader.Correlate("Response","web.DHCSTENSMSGPH")
    s RetCode="", RetContent=""
    While (reader.Next(.obj,.sc)) {
        s RetCode =obj.ResultCode
        s RetContent=obj.ResultContent
    }
    q:RetCode'=0 -1000
    q 0
}

/// Descript：   取某医嘱剩余未发数量(计费组使用,中途结算时未发完的不结算)(已经停止的、自备药过滤掉返回值是0)
/// Creater：    zhouyg
/// CreateDate: 2012-01-12
/// Input:      医嘱RowID
/// Retrun:     剩余未发数量(基本单位数量^基本单位描述),没有则返回空值""
ClassMethod GetTCDsp(oeori As %String) As %String
{
    s retQty=""
    q:oeori="" retQty
    s OrdID=$p(oeori,"||",1)
    s OrdSub=$p(oeori,"||",2)
    q:(OrdID="")!(OrdSub="") retQty
    //判断医嘱状态(医嘱核实、未核实、停止状态)
    s oestID=$p(^OEORD(OrdID,"I",OrdSub,1),"^",13)
    q:oestID="" retQty
    s oestflag=$p($g(^OEC("OSTAT",oestID)),"^",1)
    q:(oestflag'="V")&(oestflag'="E") retQty
    //判断医嘱优先级(是否自备药)
    s PriorID=$p(^OEORD(OrdID,"I",OrdSub,1),"^",8)
    q:PriorID="" retQty
    s priorCode=$p($g(^OECPR(PriorID)),"^",1) ;医嘱优先级代码 
    q:priorCode="" retQty            
    q:$ZCVT(priorCode,"U")["OM" retQty
    s ArcimID=$p(^OEORD(OrdID,"I",OrdSub,1),"^",2)
    s ArcimSub=$p(ArcimID,"||",1)
    q:ArcimSub="" retQty
    s InciID=$o(^INCI(0,"ARCIM_DR",ArcimSub,""))
    q:InciID="" retQty
    s bUomID=$p(^INCI(InciID,1),"^",10)
    q:bUomID="" retQty
    s bUomDesc=$p($g(^CT("UOM",bUomID)),"^",2)
    s dspID=""
    f  s dspID=$o(^DHCOEDISQTY(0,"OEORI",oeori,dspID))  q:dspID=""  d
    .q:$p(^DHCOEDISQTY(dspID),"^",7)'="TC"  //状态不是"TC"的不考虑
    .s qty=$p(^DHCOEDISQTY(dspID),"^",11)
    .s retQty=retQty+qty
    q:retQty="" retQty
    q retQty_"^"_bUomDesc
}

/// Creator:Liang Qiang
/// CreatDate:2011-11-16
/// Input:医嘱rowid ,发药类别描述
/// 获取药品类别是否口服  0 不是 1 是   医生站用，勿动
ClassMethod GetDrugCatByOrd(orditm As %String, durgtype) As %String
{
      s ord=+orditm
      s chl=$p(orditm,"||",2)
      s arcimid=$p(^OEORD(ord,"I",chl,1),"^",2)                                    
      s arccatid=$p(^ARCIM($p(arcimid,"||",1),$p(arcimid,"||",2),1),"^",10)        
      s catcode=$p(^ARC("IC",arccatid),"^",1)                         
      s cat=##class(web.DHCSTPCHCOLLS).GetCat(catcode)
      q:cat=durgtype 1
      q 0
}

/// Creator:Liang Qiang
/// CreatDate:2012-04-14
/// Description:判断医嘱退药申请是否可以出院通过 (已退药或已退费)
/// Input:医嘱执行表rowid 
/// Output:0 不可以 1 可以  护士站用，勿动
ClassMethod GetDrugRequestStatus(OrdExeRowid As %String) As %String
{
    s ret=0
    s retflag="Execute"
    s dsp=$o(^DHCOEDISQTY(0,"OEORE",OrdExeRowid,""))
    s dspstatus=$p(^DHCOEDISQTY(dsp),"^",7)
    q:dspstatus'="C" 1
    s reqrowid=""
    f  s reqrowid=$o(^RETRQ("DODIS",dsp,reqrowid)) q:reqrowid=""  d
    .s sub=""
    .f  s sub=$o(^RETRQ("DODIS",dsp,reqrowid,sub)) q:sub=""  d
    ..s status=$p(^RETRQ(reqrowid,"I",sub),"^",10)
    ..i status=retflag s ret=1
    ..s refundstatus=$p(^RETRQ(reqrowid,"I",sub),"^",12)
    ..i refundstatus=1 s ret=1
    q ret
}

/// Descript：   根据医嘱项取药品的价格
/// Creater:        zhouyg
/// CreateDate: 2012-07-05
/// Input:      ArcimID-医嘱项ID,DateH-日期($h格式),UomID-单位ID(为空则返回基本单位价格),HospID-医院ID(CT_Hospital)(可以为空)
/// Return:     是否药品(是"Y"或否"N")^进价(未加成价)^售价,
/// 异常:     参数错误返回空
/// Others:     w ##Class(web.DHCSTINTERFACE).GetPrice("741||1",+$h,"","")
ClassMethod GetPrice(ArcimID As %String, DateH As %String, UomID As %String, HospID As %String = "") As %String
{
 q:ArcimID="" ""
 q:DateH="" ""
 s ArcimSubs=$p(ArcimID,"||",1)
 q:ArcimSubs="" ""
 s InciID=$o(^INCI(0,"ARCIM_DR",ArcimSubs,""))
 q:InciID="" "N^0^0"    //非药品医嘱
 s scgStr=##Class(web.DHCSTCOMINC).GetIncStkCatGrp(InciID)
 s scgType=$p(scgStr,"^",3)
 q:scgType'="G" "N^0^0" //非药品医嘱
 s buomID=$p(^INCI(InciID,1),"^",10)
 i UomID="" s UomID=buomID
 s Aexcudate=DateH+1
 s retRp=0,retSp=0,adjrow=""
 I HospID'="" D
 .s excudate=$o(^INASP(0,"HOSPI",HospID,InciID,Aexcudate),-1)
 .Q:excudate=""
 .s adjrow=$o(^INASP(0,"HOSPI",HospID,InciID,excudate,""),-1)
 i adjrow="" d
 .s excudate=$o(^INASP(0,"INCI",InciID,Aexcudate),-1)
 .Q:excudate=""
 .s adjrow=$o(^INASP(0,"INCI",InciID,excudate,""),-1)
 q:adjrow="" "Y^0^0"    //是药品但是没有调价记录
 s pRp=$p(^INASP(adjrow),"^",14)
 s bRp=$p(^INASP(adjrow),"^",16)
 //s pSp=$p(^INASP(adjrow),"^",11)
 //s bSp=$p(^INASP(adjrow),"^",7)
 s bSp=$p(^INASP(adjrow),"^",29)    //深圳因为已经调价，售价字段值=进价字段值，所以启用备用售价
 s adjuomID=$p(^INASP(adjrow),"^",10)
 s factor=##Class(web.DHCSTCOMMONSRV).UOMFac(UomID,buomID)
 i UomID=adjuomID  d
 .s retRp=pRp
 e  d
 .s retRp=bRp*factor
 s retSp=bSp*factor
 //20100425 zhouyg 格式化数值小数位数
 i $d(^$R("^web.DHCSTCOMMPARA.1")) d
 .S CustID=##Class(web.DHCSTCOMMO).GetCusIDByHospID(HospID) //DHC_STCustomer
 .S CatGrpStr=##Class(web.DHCSTCOMINC).GetIncStkCatGrp(InciID)
 .S StkTypeDesc=$P(CatGrpStr,"^",4)
 .S Perv="^^^"_StkTypeDesc_"^"_CustID_"^DHC"
 .i UomID=buomID d
 ..s retRp=##Class(web.DHCSTCOMMPARA).GetNumbDec(retRp,Perv,"FmtRP",2)
 ..s retSp=##Class(web.DHCSTCOMMPARA).GetNumbDec(retSp,Perv,"FmtSP",2)
 .e  d
 ..s retRp=##Class(web.DHCSTCOMMPARA).GetNumbDec(retRp,Perv,"FmtRP",1)
 ..s retSp=##Class(web.DHCSTCOMMPARA).GetNumbDec(retSp,Perv,"FmtSP",1)
 e  d
 .i UomID=buomID d
 ..s retRp=+$j(retRp,7,6)
 ..s retSp=+$j(retSp,7,6)
 .e  d
 ..s retRp=+$j(retRp,3,2)
 ..s retSp=+$j(retSp,3,2)
 s RetValue="Y^"_retRp_"^"_retSp
 q RetValue
}

/// Creator:zhouyg
/// CreatDate:2011-08-09
/// Description:取协议单位系数,写自温岭草药用
/// Table:DHC_IncilDispUom
/// Input:医嘱项Rowid,接收科室
/// Output:与基本单位的转换系数字符串("^"分隔),如3^5^10
/// Retrun:与基本单位的转换系数字符串("^"分隔)
/// Others:w ##class(web.DHCSTINTERFACE).GetDspUomFac("858||1",100)
ClassMethod GetDspUomFac(arcimID As %String, RecLocID As %String) As %String
{
    s arcimID=+arcimID
    q:arcimID<1 ""
    q:RecLocID="" ""
    s inci=$o(^INCI(0,"ARCIM_DR",arcimID,""))
    q:inci="" ""
    s ilsub=$o(^INCI("IL_LOC",RecLocID,inci,""))
    q:ilsub="" ""
    s buomID=$p($g(^INCI(inci,1)),"^",10)
    q:buomID="" ""
    s retstr=""
    s incil=inci_"||"_ilsub
    s ilduID=""
    f  s ilduID=$o(^DHCILDU(0,"INCIL",incil,ilduID)) q:ilduID=""  d
    .s active=$p(^DHCILDU(ilduID),"^",2)
    .q:active'="Y"
    .s datefrom=$p(^DHCILDU(ilduID),"^",3)
    .q:(+datefrom'=0)&&(+datefrom>+$h)
    .s dateto=$p(^DHCILDU(ilduID),"^",4)
    .q:(+dateto'=0)&&(+dateto<=+$h)
    .s duomID=$p(^DHCILDU(ilduID),"^",1)
    .q:duomID=""
    .s fac=##Class(web.DHCSTCOMMONSRV).UOMFac(duomID,buomID)
    .q:fac=""
    .i retstr="" d
    ..s retstr=fac
    .e  d
    ..s retstr=retstr_"^"_fac
    q retstr
}

/// 判断医嘱是否毒麻药
ClassMethod GetPoisonByOrd(orditm As %String) As %String
{
   s ord=+orditm
   s chl=$p(orditm,"||",2)
   s arcimid=$p(^OEORD(ord,"I",chl,1),"^",2)                                
   s incidr=$O(^INCI(0,"ARCIM_DR",$p(arcimid,"||",1),""))
   s poisonstr=##class(web.DHCSTCOMMONSRV).getPoisonByInci(+incidr)
   q:poisonstr="" ""
   s poisondr=$p(poisonstr,"^",1)
   s poison=$p(poisonstr,"^",3)
   q:(poison'["毒药")&(poison'["麻醉") ""
   q 1
}

/// 判断医嘱是否精神药品
ClassMethod GetPoisonByOrdJS(orditm As %String) As %String
{
   s ord=+orditm
   s chl=$p(orditm,"||",2)
   s arcimid=$p(^OEORD(ord,"I",chl,1),"^",2)                                
   s incidr=$O(^INCI(0,"ARCIM_DR",$p(arcimid,"||",1),""))
   s poisonstr=##class(web.DHCSTCOMMONSRV).getPoisonByInci(+incidr)
   q:poisonstr="" ""
   s poisondr=$p(poisonstr,"^",1)
   s poison=$p(poisonstr,"^",3)
   q:(poison'["精神") ""
   q 1
}

/// Descript：   开医嘱或发药时判断是否有可用库存(批次价与非批次价通用)
/// Creater：    zhouyg
/// CreateDate：2013-08-12
/// Input：      医嘱项ID,接收科室ID,基本单位数量,判断逻辑库存还是实库存(0判断逻辑库存,1判断实库存,目前只对非批次价有意义,批次价必须判断逻辑库存程序已经写死)
/// Return:     0-没有满足条件的批次,1-有满足条件的批次,<0表示错误
/// Others:     开医嘱药品下拉,选中,审核三次均调用此方法
/// ##class(web.DHCSTINTERFACE).GetAvailQtyByArc(医嘱项Id，接收科室Id，基本单位数量，0)
/// w ##Class(web.DHCSTINTERFACE).GetAvailQtyByArc("2491||1","224",1,"1")
ClassMethod GetAvailQtyByArc(Arcim As %String, recLoc As %String, Qty As %String, ResFlag As %String = "0")
{
    q:..isMatArcim(Arcim) ##class(web.DHCSTMHUI.DHCSTMSERVICE).GetAvailQtyByArc(Arcim,recLoc,Qty,ResFlag)  //20151210
    q:Arcim="" -1
    q:recLoc="" -2
    s RetCode=0
    s HospID=$p($g(^CTLOC(recLoc)),"^",22)
    i HospID="" d
    .s RuleFlag=1
    e  d
    .s RuleFlag=##Class(web.DHCSTCOMMPARA).GetRpRule(HospID)    //价格规则
    /// 批次价
    i RuleFlag=3 d
    .s RetCode=##Class(web.DHCST01).GetAvailQtyByArc(Arcim,recLoc,Qty) // ok
    e  d
    ./// 非批次价
    .s ArcSub=$p(Arcim,"||",1)
    .q:ArcSub=""
    .s incID=""
    .f  s incID=$o(^INCI(0,"ARCIM_DR",ArcSub,incID)) q:(incID="")||(RetCode=1)  d
    ..s AvialQty=0
    ..i ResFlag=1 d
    ...s AvialQty=##class(web.DHCSTSTKQTY).GetIncilValidQty(incID,recLoc) // ok
    ..e  d
    ...s il=$o(^INCI("IL_LOC",recLoc,incID,""))
    ...q:il=""
    ...s incil=incID_"||"_il
    ...s AvialQty=##Class(web.DHCSTSTKQTY).GetStkQtyInclb(incil) // ok
    ...s oeResQty=$p(^INCI(incID,"IL",il),"^",10)
    ...s AvialQty=AvialQty-oeResQty
    ..i AvialQty<Qty d
    ...s RetCode=0
    ..e  d
    ...s RetCode=1
    q RetCode
}

/// Descript：   开医嘱判断是否有可用库存(批次价与非批次价通用)
/// Creater：    zhouyg
/// CreateDate：2017-07-01
/// Input：      库存项ID,接收科室ID,基本单位数量,判断逻辑库存还是实库存(0判断逻辑库存,1判断实库存,目前只对非批次价有意义,批次价必须判断逻辑库存程序已经写死)
/// Return:     0-没有满足条件的批次,1-有满足条件的批次,<0表示错误
/// LastUpdate: 20190822 替换代码为##class(PHA.FACE.OUT.Method).GetAvailQtyByInc
ClassMethod GetAvailQtyByInc(IncID As %String, RecLocID As %String, Qty As %String, ResFlag As %String = "0")
{
    q ##class(PHA.FACE.OUT.Method).GetAvailQtyByInc(IncID,RecLocID,Qty,ResFlag)
}

/// Descript：   根据医嘱项和科室取库存数量、在途数等(一品多规调用！)
/// Creater：    zhouyg
/// CreateDate：2015-01-19
/// Input：      医嘱项ID,科室ID
///             add: AdmType 如果病人类型为 I住院，则取住院加锁标致，否则取门诊加锁标致 2020-10-29 yangsj
/// Return： 库存项1信息串$C(2)库存项2信息串
///             库存项信息=1库存项ID^2库存项代码^3库存项名称^4规格^5住院单位id^6住院单位描述^7门诊单位ID^8门诊单位描述^9当前库存数^10可用库存数^11医嘱占用数^12库存业务占用数
///             MaYuqiang 20220714 增加参数 StockFlag（Y - 判断库存 , 其他不判断库存）, StockFlag非Y时返回库存数为99999
/// w ##Class(web.DHCSTINTERFACE).GetIncilQtyList("5676||1","165")
/// 仅供下医嘱
ClassMethod GetIncilQtyList(ArcID As %String, recLoc As %String, AdmType As %String = "", StockFlag As %String = "Y") As %String
{
    s lockNode=$S(AdmType="I":46,1:1)
    q:ArcID="" ""
    q:recLoc="" ""
    q:..isMatArcim(ArcID) ##class(web.DHCSTMHUI.DHCSTMSERVICE).GetIncilQtyList(ArcID,recLoc)
    s ArcIDM=$p(ArcID,"||",1)
    q:ArcIDM="" ""
    s IncID="",RetList=""
    f  s IncID=$o(^INCI(0,"ARCIM_DR",ArcIDM,IncID)) q:(IncID="")  d
    .s ilSub=$o(^INCI("IL_LOC",recLoc,IncID,""))
    .s itmAdd=$o(^DHCITMINFO(0,"INCI",IncID,""))
    .s ordEndDate=$p($G(^DHCITMINFO(+itmAdd)),"^",113) 
    .q:(ordEndDate'="")&&(ordEndDate<+$h)
    .q:ilSub=""
    .s incil=IncID_"||"_ilSub
    .//判断科室库存项是否加锁
    .s dhcIncil=$o(^DHCINCIL(0,"INCIL",incil,""),-1)
    .s LockFlag=$s(dhcIncil'="":$p(^DHCINCIL(dhcIncil),"^",lockNode),1:"N")
    .q:LockFlag="Y"
    .s IncList=##Class(web.DHCSTSTKQTY).GetIncilQtyList(incil,"Y")
    .i (StockFlag '= "Y") d
    ..s IncList = "99999^99999^0^0"
    .q:IncList=""
    .s (InUom,OutUom)=""
    .s IncCode=$p(^INCI(IncID,1),"^",1)
    .s IncDesc=$p(^INCI(IncID,1),"^",2)
    .s Spec=##Class(web.DHCSTCOMINC).GetSpec(IncID)
    .s InUomID=$p(^INCI(IncID,1),"^",13)
    .s OutUomID=$p(^INCI(IncID,1),"^",12)
    .i InUomID'="" d
    ..s InUom=$p(^CT("UOM",InUomID),"^",2)
    .i OutUomID'="" d
    ..s OutUom=$p(^CT("UOM",OutUomID),"^",2)
    .s IncList=IncID_"^"_IncCode_"^"_IncDesc_"^"_Spec_"^"_InUomID_"^"_InUom_"^"_OutUomID_"^"_OutUom_"^"_IncList
    .i RetList="" d
    ..s RetList=IncList
    .e  d
    ..s RetList=RetList_$c(2)_IncList
    q RetList
}

/// Descript：       根据医嘱医嘱处理在途数(医生站接口,批次价和非批次价通用)
/// Creater：        zhouyg
/// CreateDate： 2015-01-15
/// Table：          
/// Input：          医嘱ID,医嘱执行ID,seFlag(开医嘱:1，停医嘱或执行:2)
///                 医嘱ID,医嘱执行ID只能输入其一，如果两个都录入就按执行ID处理
/// Return：     0-成功,其它-失败
ClassMethod SetOeResQty(OeItmID As %String, OeExeID As %String, seFlag As %String) As %String
{
    q:(..isMatOrd(OeItmID))!(..isMatOrd(OeExeID)) ##class(web.DHCSTMHUI.DHCSTMSERVICE).SetOeResQty(OeItmID,OeExeID,seFlag) //20151210
    q ##Class(web.DHCST01).SetOeResQty(OeItmID,OeExeID)
}

/// Descript：   住院开医嘱时处理配药批次表(因为涉及到实时的取逻辑库存,本方法同时处理了科室在途和科室批次在途)
/// Creater：    zhouyg
/// CreateDate：2013-08-08
/// Table：      DHC_OEDispensing,DHCOEDispBatch,inc_itmloc,inc_itmlcbt
/// Input：      DHC_OEDispensing的ID,RollFlag(1为滚医嘱)
/// Return：    0-没有满足条件的批次,1-保存成功,<0-表示错误,对非1的需要回滚整个医嘱
ClassMethod InsDspBatch(DspID As %String, RollFlag As %String) As %String
{
    q:..isMatDisp(DspID) ##class(web.DHCSTMHUI.DHCSTMSERVICE).InsDspBatch(DspID,RollFlag)  //20151210
    s baseRet = ##Class(web.DHCST01).UpdateRecLoc4BaseOrder(DspID)
    q ##Class(web.DHCST01).InsDspBatch(DspID,RollFlag)
}

/// Descript：   门诊开医嘱时处理配药批次表(因为涉及到实时的取逻辑库存,本方法同时处理了科室在途和科室批次在途)
/// Creater：    zhouyg
/// CreateDate：2013-08-08
/// Table：      OE_OrdItem,DHCOEDispBatch,inc_itmloc,inc_itmlcbt
/// Input：      OE_OrdItem的ID
/// Output： INCLB^数量^进价^售价
/// Return： 0-没有满足条件的批次,1-有满足条件的批次,<0表示错误,对非1的需要回滚整个医嘱
/// w ##class(web.DHCSTINTERFACE).InsDspBatchForOut("404||1")
ClassMethod InsDspBatchForOut(OeoriID As %String) As %String
{
    q:..isMatOrd(OeoriID) ##class(web.DHCSTMHUI.DHCSTMSERVICE).InsDspBatchForOut(OeoriID) //20151210
    
    s cesFlag=..IsImpDataByContingences(OeoriID)  //单机版标志
    s ret=""
    i cesFlag'="Y" d
    .s baseRet = ##Class(web.DHCST01).UpdateRecLoc4BaseOrder($o(^DHCOEDISQTY(0,"OEORI",OeoriID, "")))
    .s ret=##Class(web.DHCST01).InsDspBatchForOut(OeoriID)
    e  d
    .s ret=##Class(web.DHCST01).InsDspBatchForImport(OeoriID)  //2021-11-12 zhaozhiduan  应急系统恢复
    q ret
}

/// Descript：   价格规则
/// Creater：    zhouyg
/// CreateDate：2013-08-16
/// Input:      HospID(院区ID),DateH(+$h格式的日期,该日期因业务不同而不同,空为当前日期)
/// Return:     1-按入库进价，2-按统一进价(调价进价)，3-按批次进价
/// Modify:     2019-08-13,增加生效日期判断 
/// w ##class(web.DHCSTINTERFACE).GetRpRule(HospID,DateH)   
ClassMethod GetRpRule(HospID As %String = "", DateH = "")
{
    s RuleFlag=##Class(web.DHCSTCOMMPARA).GetRpRule(HospID,DateH)   //进价规则
    q RuleFlag
}

/// Descript：   开医嘱前判断实际库存是否满足(非批次价使用)
/// Creater：    zhouyg
/// CreateDate：2013-12-20
/// Input：      医嘱项ID,接收科室ID,基本单位数量
/// Return:     0-库存不满足,1-库存满足,<0表示错误
/// Others:     
ClassMethod IsQtyEnoughByArc(Arcim As %String, LocID As %String, Qty As %String) As %String
{
    q:Arcim="" -102
    q:LocID="" -103
    s ArcimSub=$p(Arcim,"||",1)
    q:ArcimSub="" -102
    s Inci=$o(^INCI(0,"ARCIM_DR",ArcimSub,"")) 
    q:Inci="" -104
    s CurQty=##Class(web.DHCSTSTKQTY).IL(Inci,LocID,+$h)
    i CurQty<Qty d
    .s stkflag=0
    e  d
    .s stkflag=1
    q stkflag
}

/// Descript：   调用接口取病案号
/// Creater：    LiangQiang
/// CreateDate：2014-01-23
/// Input：      EpisodeID
/// Return:     病案号
ClassMethod GetMrNoByEpisodeID(EpisodeID As %String) As %String
{
    s admType=$p($g(^PAADM(+EpisodeID)),"^",2)
    q ##class(web.DHCSTInterfaceFromElse).GetMrNoByEpisodeID(EpisodeID,admType)
}

/// Descript：医生站调用返回是否可以开医嘱
/// Creater：    wyx
/// CreateDate：2014-02-19
/// Input：    医嘱项RowID,接收科室ID,数量
/// Return:   所开数量>剩余数量   0 否则返回1 
ClassMethod EnoughStk(ARCIMrow, CTLOCrow, QtyNeed, NOMSG = "")
{
    q:$g(ARCIMrow)="" 0
    s INCIrow=..GetINCI($p($p(ARCIMrow,$c(1)),"||",1))
    q:$g(INCIrow)="" 1
    q ..ChkStock(INCIrow,CTLOCrow,QtyNeed,0)
}

ClassMethod GetINCI(ARCIMsub)
{
    s ARCIMsub=$p(ARCIMsub,$c(1))
    s INCIrow=$o(^INCI(0,"ARCIM_DR",ARCIMsub,""))
    q $g(INCIrow)
}

ClassMethod ChkStock(INCIrow, CTLOCrow, QtyNeed, NoMSG)
{
    s ilSub=$o(^INCI("IL_LOC",CTLOCrow,INCIrow,""))
    q:ilSub="" 0
    s LocQty=$p(^INCI(INCIrow,"IL",ilSub),"^",3)
    s ResQty=$p(^INCI(INCIrow,"IL",ilSub),"^",10)
    s TotalQty=0
    s inclbsub=""
    f  s inclbsub=$o(^INCI(INCIrow,"IL",ilSub,"LB",inclbsub)) q:inclbsub=""  d
    .s inclb=INCIrow_"||"_ilSub_"||"_inclbsub
    .q:(##class(web.DHCSTSTKQTY).ValidInclbExpDate(inclb) '= "Y")
    .s ldate=$o(^DHCBTLOCTOT(0,"LocBtDate",CTLOCrow,inclb,""),-1) 
    .s daymainid=$o(^DHCBTLOCTOT(0,"LocBtDate",CTLOCrow,inclb,ldate,""))
    .s daybtid=$o(^DHCBTLOCTOT(0,"LocBtDate",CTLOCrow,inclb,ldate,daymainid,""),-1)
    .s batQty=$p(^DHCBTLOCTOT(daymainid,"I",daybtid),"^",3)
    .i TotalQty=0 s TotalQty=batQty
    .e  s TotalQty=TotalQty+batQty
    q:(TotalQty-ResQty)'<QtyNeed 1
    q 0
}

/// Descript：   获取有库存药品的批次售价(仅仅开医嘱时取价格显示使用，其它业务不要用)
/// Creater：    yuruiying
/// CreateDate：2013-09-16
/// Input：      Arc_ItmMast的ID,接收科室ID,高值条码
/// Output： 批次售价
/// Return： 批次售价,-100加锁失败,-102医嘱项为空,-103科室为空,-104对应库存项不存在,-106科室库存项不存在
/// Update:     zhouyg 20170905
ClassMethod GetNotEmptyINCILSp(HospID As %String = "", Arcim As %String, Recloc As %String, MatBarcode As %String = "", IncID As %String = "")
{
    q:..isMatArcim(Arcim) ##class(web.DHCSTMHUI.DHCSTMSERVICE).GetNotEmptyINCILSp(HospID,Arcim,Recloc,MatBarcode) //20151210
    s RuleFlag=##Class(web.DHCSTCOMMPARA).GetRpRule(HospID) //进价规则
    s sp=0
    i RuleFlag=3 d
    .s sp=##Class(web.DHCST01).GetBatSp(Arcim,Recloc,IncID)
    else  d
    .s inciID=""
    .f  s inciID=$o(^INCI(0,"ARCIM_DR",$p(Arcim,"||",1),inciID)) q:(inciID="")||(sp'=0)  d
    ..q:(IncID'="")&&(IncID'=inciID)
    ..s NotUseFlag=$p(^INCI(inciID,2),"^",9)
    ..q:NotUseFlag="Y"
    ..s sp=##Class(web.DHCSTPRICE).GetCurSp(inciID,"",HospID)
    i (sp = 0) d
    .s sp = ##class(web.DHCSTPRICE).GetDefSpByArcim(Arcim, HospID)
    q sp
}

/// Descript：   取医嘱执行记录售价(批次价格使用,住院按执行取价格)
/// Creater：    zhouyg
/// CreateDate：2014-12-24
/// Table：      DHC_OEDispensing,DHC_OEDispBatch
/// Input：      DspID-DHC_OEDispensing的ID
/// Output： 批次售价
/// Return： 批次售价
/// Update:     zhouyg 20170905
ClassMethod GetDspSp(DspID As %String) As %String
{
    q:..isMatDisp(DspID) ##class(web.DHCSTMHUI.DHCSTMSERVICE).GetDspSp(DspID)   //20151210
    s batsp=##Class(web.DHCSTPRICE).GetDspSp(DspID)
    q batsp
}

/// Descript：   获取配药批次表中第一个批次售价(门诊按医嘱取价格)
/// Creater：    yuruiying
/// CreateDate：2013-09-16
/// Return:     售价
ClassMethod GetDispBatFirstSp(HospID As %String = "", OrdItmdr As %String, Recloc As %String)
{
    q:..isMatOrd(OrdItmdr) ##class(web.DHCSTMHUI.DHCSTMSERVICE).GetDispBatFirstSp(HospID,OrdItmdr,Recloc)   //20151210
    q:OrdItmdr="" 0
    s oedosdr="",batsp=0
    s oedosdr=$o(^DHCOEDISQTY(0,"OEORI",OrdItmdr,oedosdr))
    q:(oedosdr="") 0
    q:'$D(^DHCOEDISQTY(oedosdr)) 0
    s batsp=##Class(web.DHCSTPRICE).GetDspSp(oedosdr)
    i batsp=0 d
    .s HospID=""
    .s Recloc=$p($g(^OEORD(+OrdItmdr,"I",+$p(OrdItmdr,"||",2),3)),"^",6)
    .i Recloc'="" s HospID=$p($g(^CTLOC(Recloc)),"^",22)
    .s ArcitmDr=$p($g(^OEORD(+OrdItmdr,"I",+$p(OrdItmdr,"||",2),1)),"^",2)
    .s batsp=##Class(web.DHCST01).GetBatSp(ArcitmDr,Recloc)
    q batsp
}

/// Descript：   获取当前药品最后一个批次的当前售价
/// Creater：    yuruiying
/// CreateDate：2013-09-16
/// Return:     售价
/// Update: 药品循环找库存项取第一库存项价格 zhouyg 20170905
ClassMethod GetIncibLastSp(HospID As %String = "", Arcim As %String)
{
    q:..isMatArcim(Arcim) ##class(web.DHCSTMHUI.DHCSTMSERVICE).GetIncibLastSp(HospID,Arcim)   //20151210
    s inciID="",RetSp=0
    f  s inciID=$o(^INCI(0,"ARCIM_DR",$p(Arcim,"||",1),inciID)) q:(inciID="")||(RetSp'=0)  d
    .s NotUseFlag=$p(^INCI(inciID,2),"^",9)
    .q:NotUseFlag="Y"
    .s RetSp=+##Class(web.DHCSTPRICE).GetCurSp(inciID,"",HospID)    //zhouyg 20140325
    i (RetSp = 0) d
    .s RetSp = ##class(web.DHCSTPRICE).GetDefSpByArcim(Arcim, HospID)
    q RetSp
}

/// Descript：   调用生成退药申请(供计费组)
/// Creater：    LiangQiang
/// CreateDate：2014-04-15
/// Input：      reclocdr,prt,prescno,ordstr,reasondr,opuserid
/// Return:     0 成功 非0失败
/// ##class(web.DHCSTINTERFACE).SaveOutPhRequest(reclocdr,prt,prescno,ordstr,reasondr,opuserid)
ClassMethod SaveOutPhRequest(reclocdr, prt, prescno, ordstr, reasondr, opuserid) As %String
{
    //s ordstr="orditem^qty$c(2)orditem^qty"
    s cnt=$l(ordstr,$c(2))
    s phdrowid=""
    s phd=""
    f  s phd=$o(^DHCPHDISPi("PRESCNO",prescno,phd)) q:(phd="")||(phdrowid'="")  d
    .s phl=$p(^DHCPHDISP(phd,1),"^",1)
    .s tmpprescno=$p(^DHCPHDISP(phd,2),"^",1)
    .q:tmpprescno'=prescno
    .s fyflag=$p(^DHCPHDISP(phd),"^",4)
    .q:fyflag'=1
    .s phdrowid=phd
    q:phdrowid="" -100
    s ret=0
    f i=1:1:cnt q:ret'=0  d
    .s tmpstr=$p(ordstr,$c(2),i)
    .s orditem=$p(tmpstr,"^",1)
    .s qty=$p(tmpstr,"^",2)
    .s phl=$p(^DHCPHDISP(phd,1),"^",1)
    .s phdi=""
    .f  s phdi=$o(^DHCPHDI(phd,"PHDI",phdi)) q:phdi=""  d
    ..s oeori=$p(^DHCPHDI(phd,"PHDI",phdi),"^",5)
    ..q:oeori'=orditem
    ..s retqty=+$p(^DHCPHDI(phd,"PHDI",phdi),"^",6)
    ..s phaqty=+$p(^DHCPHDI(phd,"PHDI",phdi),"^",4)
    ..q:(phaqty-retqty)'>0
    ..s phditm=phd_"||"_phdi
    ..s over=""
    ..i i=cnt s over="1"
    ..s ret=##class(web.DHCOutPhReturn).InsertPhRequest(reclocdr, phdrowid, prt, prescno, phditm, qty, reasondr, opuserid, over)
    q ret
}

/// Descript：   获取已发数,已申请数,已退药(供计费组)
/// Creater：    LiangQiang
/// CreateDate：2014-04-15
/// Input：      医嘱ID,发票ID
/// Return:     已发数,已申请数,已退药
/// ##class(web.DHCSTINTERFACE).GetOutPhOrditmQty("350||1","")
ClassMethod GetOutPhOrditmQty(orditem, prt) As %String
{
    s dsp=$o(^DHCOEDISQTY(0,"OEORI",orditem,""))
    q:dsp="" ""
    s status=$p(^DHCOEDISQTY(dsp),"^",7) 
    q:status'="C" "0^0^0"
    s dspqty=$p(^DHCOEDISQTY(dsp),"^",5) 
    s ord=$p(orditem,"||",1)
    s itm=$p(orditem,"||",2)
    s prescno=$p(^OEORD(ord,"I",itm,1),"^",14)
    s reqqty=0,retqtysum=0
    s phd=""
    f  s phd=$o(^DHCPHDISPi("PRESCNO",prescno,phd)) q:phd=""  d
    .s phl=$p(^DHCPHDISP(phd,1),"^",1)
    .s tmpprescno=$p(^DHCPHDISP(phd,2),"^",1)
    .q:tmpprescno'=prescno
    .s fyflag=$p(^DHCPHDISP(phd),"^",4)
    .q:fyflag'=1
    .s phdi=""
    .f  s phdi=$o(^DHCPHDI(phd,"PHDI",phdi)) q:phdi=""  d
    ..s oeori="",payamount="",retqty="",qty="",price=0
    ..s oeori=$p(^DHCPHDI(phd,"PHDI",phdi),"^",5)
    ..q:oeori'=orditem
    ..s retqty=+$p(^DHCPHDI(phd,"PHDI",phdi),"^",6)
    ..s retqtysum=retqtysum+retqty
    ..s phditm=phd_"||"_phdi
    ..s phreq=""
    ..f  s phreq=$o(^DHCPHREQi(phditm,"PHDI",phreq)) q:phreq=""  d
    ...s zfflag=$p(^DHCPHREQ(phreq),"^",1)
    ...q:zfflag="1"
    ...s retflag=$p(^DHCPHREQ(phreq),"^",11)
    ...q:(retflag'="0")&(retflag'="")
    ...s phreqsub=""
    ...f  s phreqsub=$o(^DHCPHREQi(phditm,"PHDI",phreq,phreqsub)) q:phreqsub=""  d
    ....s phreqphdi="",lreqqty=0
    ....s phreqphdi=$p(^DHCPHREQ(phreq,"I",phreqsub),"^",1)
    ....q:phreqphdi'=phditm
    ....s lreqqty=$p(^DHCPHREQ(phreq,"I",phreqsub),"^",4)
    ....s reqqty=reqqty+lreqqty
    
    s retqty=##class(web.DHCOutPhReturn).GetRetOrdQty(orditem)
    
    q dspqty_"^"_reqqty_"^"_retqty
}

/// Descript：   发送消息
/// Creater：    LiangQiang
/// CreateDate：2014-12-25
/// Input：      发送的消息内容,入参串,其它数据
/// Return:     0成功,-100失败
/// ##class(web.DHCSTINTERFACE).SendPharmacyMsg(Context,Para,OtherData)
ClassMethod SendPharmacyMsg(Context, Para, OtherData) As %String
{
    q ##class(web.DHCSTInterfaceFromElse).SendPharmacyMsg(Context, Para, OtherData)
}

/// Descript：   调用生成退药申请(供计费组)
/// Creater：    liangjiaquan
/// CreateDate：2014-04-27
/// Input：      reclocdr,prt,prescno,ordstr,reasondr,opuserid
/// Return:     0 成功 非0失败
/// w ##class(web.DHCSTINTERFACE).SaveOutPhRequestnew("103","295713","O18081500010","71822||2^1^1^29||1||1^295713||12"_$c(2)_"71822||3^1^1^29||2||1^295713||13","21","2889")
ClassMethod SaveOutPhRequestnew(reclocdr, prt, prescno, ordstr, reasondr, opuserid) As %String
{
    s cnt=$l(ordstr,$c(2))
    s phdrowid=""
    s phd=""
    f  s phd=$o(^DHCPHDISPi("PRESCNO",prescno,phd)) q:(phd="")||(phdrowid'="")  d
    .s phl=$p(^DHCPHDISP(phd,1),"^",1)
    .s tmpprescno=$p(^DHCPHDISP(phd,2),"^",1)
    .q:tmpprescno'=prescno
    .s fyflag=$p(^DHCPHDISP(phd),"^",4)
    .q:fyflag'=1
    .s phdrowid=phd
    q:phdrowid="" -100
    s ret=0
    f i=1:1:cnt  d
    .s tmpstr=$p(ordstr,$c(2),i)
    .s orditem=$p(tmpstr,"^",1)
    .s qty=$p(tmpstr,"^",2)
    .s staus=$p(tmpstr,"^",3)
    .s phditm=$p(tmpstr,"^",4)
    .s InsRowID=$p(tmpstr,"^",5)
    .//判断是否已申请
    .s reqflag=0
    .i (staus="1")  d
    ..s phaqty=+$p(^DHCPHDI(+phditm,"PHDI",$p(phditm,"||",2),"INCLB",$p(phditm,"||",3)),"^",1)
    ..s retqty=+$p(^DHCPHDI(+phditm,"PHDI",$p(phditm,"||",2),"INCLB",$p(phditm,"||",3)),"^",2)
    ..s reqty=##class(web.DHCOutPhCommon).GetHasReqQty(phditm)
    ..s:(phaqty-retqty-reqty)'>0 reqflag=1
    .e  d
    ..s reqflag=+$p(^DHCPHOW(+phditm,"I",$p(phditm,"||",2)),"^",4)
    .q:(reqflag'=0)
    .s over=""
    .i i=cnt s over="1"
    .s ret=##class(web.DHCOutPhReturn).InsertPhRequest(reclocdr, +phditm, prt, prescno, phditm, qty, reasondr, opuserid, over, staus, InsRowID)
    q ret
}

/// Descript:   根据门诊发药子表取已申请未退的数量
/// Creater:    zhouyg
/// CreateDate: 2016-03-11
/// Input:      门诊发药子表ID
/// Return： 数量
/// w ##class(web.DHCSTINTERFACE).GetReqQty(524)
ClassMethod GetReqQty(phditm)
{
    s orditm=$p(^DHCPHDI(+phditm,"PHDI",$p(phditm,"||",2)),"^",5)
    s ord=$p(orditm,"||",1)
    s itm=$p(orditm,"||",2)
    s itmmast=$p(^OEORD(ord,"I",itm,1),"^",2)
    s itmmastid=$p(itmmast,"||",1)
    s itmmastver=$p(itmmast,"||",2)
    s inci=""
    s inci=$o(^INCI(0,"ARCIM_DR",itmmastid,inci))
    q:inci="" 0
    s phuomid=$p(^ARCIM(itmmastid,itmmastver,8),"^",14)
    s basuom=+$p(^INCI(inci,1),"^",10)
    s confac=1
    s confac=##class(web.DHCOutPhReturn).GetConFac(phuomid,basuom)
    
    s req="",sumqty=0
    f  s req=$o(^DHCPHREQi(phditm,"PHDI",req)) q:req=""  d
    .s zfflag=$p(^DHCPHREQ(req),"^",1)
    .q:zfflag="1"
    .s retflag=$p(^DHCPHREQ(req),"^",11)
    .q:(retflag'="0")&(retflag'="")
    .s newprt=+$p(^DHCPHREQ(req),"^",5)
    .q:newprt=0
    .s prtflag=$p($g(^DHCINVPRT(newprt)),"^",8)
    .q:(($g(prtflag)="A")!($g(prtflag)="S"))
    .s reqi=0
    .f  s reqi=$o(^DHCPHREQi(phditm,"PHDI",req,reqi))  q:reqi=""  d
    ..s phdi=$p(^DHCPHREQ(req,"I",reqi),"^",1)
    ..s reqty=$p(^DHCPHREQ(req,"I",reqi),"^",4)
    ..s retQty=$p(^DHCPHREQ(req,"I",reqi),"^",5)
    ..s reqty=confac*(reqty-retQty)
    ..s sumqty=sumqty+reqty
    q sumqty
}

/// Descript:   根据医嘱项ID取药学多级分类的值
/// Creater:    wyx
/// CreateDate: 2015-01-06
/// Input:      InciDr-医嘱项ID
/// Output:     Return
/// Return： 药学多级分类值 格式："catcode1-catcode2-catcode3^catdesc1-catdesc2-catdesc3^catid1-catid2-catid3"
/// w ##class(web.DHCSTINTERFACE).GetPhaCatAllByArc(524)
ClassMethod GetPhaCatAllByArc(ArcRowid)
{
    Q:ArcRowid="" ""
    S Phcdf=##class(web.DHCST.Common.DrugInfoCommon).GetPhcdfByArcim(ArcRowid)
    Q:Phcdf="" ""
    s PhaCatAllStr=..GetPhaCatAllByPhc(Phcdf)
    Q PhaCatAllStr
}

/// Descript:   根据库存项ID取药学多级分类的值
/// Creater:    wyx
/// CreateDate: 2015-01-06
/// Input:      InciDr-库存项ID
/// Output:     Return
/// Return： 药学多级分类值 格式："catcode1-catcode2-catcode3^catdesc1-catdesc2-catdesc3^catid1-catid2-catid3"
/// w ##class(web.DHCSTINTERFACE).GetPhaCatAllByInci(524)
ClassMethod GetPhaCatAllByInci(InciDr)
{
    Q:InciDr="" ""
    S Phcdf=##class(web.DHCST.Common.DrugInfoCommon).GetPhcdf(InciDr)
    Q:Phcdf="" ""
    s PhaCatAllStr=..GetPhaCatAllByPhc(Phcdf)
    Q PhaCatAllStr
}

/// Descript:   根据药学项ID取药学多级分类的值
/// Creater:    wyx
/// CreateDate: 2015-01-06
/// Input:      InciDr-药学项ID
/// Output:     Return
/// Return： 药学多级分类值 格式："catcode1-catcode2-catcode3^catdesc1-catdesc2-catdesc3^catid1-catid2-catid3"
ClassMethod GetPhaCatAllByPhc(Phcdf)
{
    q ##class(web.DHCST.Common.DrugInfoCommon).GetPhaCatAllByPhcdf(Phcdf)
    Q:Phcdf="" ""
    s NewCatId=""
    s PhaCatAllStr=""
    s NewCatId=$P($g(^PHCD(+Phcdf,"DF",$p(Phcdf,"||",2),"DHC")),"^",20)           ;多级药学分类
    i NewCatId'="" d
    .s PhaCatAllStr=##class(web.DHCST.DHCSTPHCCATMAINTAIN).GetAllPhcCatById(NewCatId,"","","")
    Q PhaCatAllStr
}

/// Description: 获取退药原因（供计费退费申请处调用）
/// Creator: bian shuai
/// CreatDate: 2015-12-10
/// Input: 医嘱ID, 发票ID
ClassMethod GetPhRetReason(prt As %String, oeori As %String) As %String
{
    
    q:(prt="")||(oeori="") ""
    
    s retreason=""
    /// 取申请单中申请退药原因
    s phd=""
    f  s phd=$o(^DHCPHDI(0,"OEORI",oeori,phd)) q:(phd="")||(retreason'="")  d
    .s ch=""
    .f  s ch=$o(^DHCPHDI(0,"OEORI",oeori,phd,ch)) q:(ch="")||(retreason'="")  d
    ..s phdi=phd_"||"_ch
    ..s reqid=$o(^DHCPHREQi(phdi,"PHDI",""))
    ..q:reqid=""
    ..s newprt=$p(^DHCPHREQ(reqid),"^",5)           /// 发票ID
    ..q:newprt'=prt
    ..s reasonid=$p(^DHCPHREQ(reqid),"^",13)        /// 申请表 退药原因ID
    ..q:reasonid=""
    ..s retreason=$p(^BLC("RFR",reasonid),"^",2)    /// 退药原因描述
    
    q:retreason'="" retreason
    
    /// 取退药表中退药原因
    s phret=""
    f  s phret=$o(^DHCPHRTIi(oeori,"ORDI",phret))  q:(phret="")||(retreason'="")  d
    .q:'$d(^DHCPHRET(phret))
    .s newprt=$p(^DHCPHRET(phret),"^",16) 
    .q:newprt'=prt
    .s reasonid=$p(^DHCPHRET(phret),"^",13)         /// 申请表 退药原因ID
    .q:reasonid=""
    .s retreason=$p(^BLC("RFR",reasonid),"^",2)     /// 退药原因描述
    
    q retreason
}

/// Descript：   删除退药申请单(供计费组)
/// Creater：    bianshuai
/// CreateDate：2015-12-17
/// Input：      OEItmRowID_"^"_InsRowID
/// Return:     状态码^错误原因
/// LastUpdate:根据退费申请的ID检索退药申请并删除 zhouyg 20160130
///            删除后当子表再无数据时删除该申请,yunhaibao20160226
/// w ##class(web.DHCSTINTERFACE).DelOutPhRequset("1909||3^200270||2")
ClassMethod DelOutPhRequset(param As %String) As %String
{
    q:param="" ""
    tstart
    s err=0
    f i=1:1:$L(param,"%") q:err'=0  d
    .s tmpparam=$p(param,"%",i)
    .s oeori=$p(tmpparam,"^",1)
    .s InsRowID=$p(tmpparam,"^",2)
    .q:InsRowID=""
    .s reqid=""
    .f  s reqid=$o(^DHCPHREQi("Refund",InsRowID,reqid)) q:(reqid="")||(err'=0)  d
    ..s retflag=$p(^DHCPHREQ(reqid),"^",11)    ///退药状态
    ..q:retflag=1                              ///申请单已退药,不允许删除!
    ..s reqch=""
    ..f  s reqch=$o(^DHCPHREQi("Refund",InsRowID,reqid,reqch)) q:(reqch="")||(err'=0)  d
    ...q:+reqch=0
    ...s chowflag=$p(^DHCPHREQ(reqid,"I",reqch),"^",6)
    ...i chowflag="1" d //欠药退
    ....s phdoweiID=$p(^DHCPHREQ(reqid,"I",reqch),"^",1)
    ....s $p(^DHCPHOW(+phdoweiID,"I",$p(phdoweiID,"||",2)),"^",4)=""
    ...s reqitm=reqid_"||"_reqch
    ...&sql(delete from dhc_phreqitem where phreqi_rowid=:reqitm)
    ...i SQLCODE'=0 s err=1
    ..i '$d(^DHCPHREQ(+reqitm,"I")) d
    ...&SQL(DELETE FROM DHC_PHREQUEST WHERE PHReq_Rowid=:reqid)
    ...i SQLCODE'=0 s err=1
    i err'=0 tro
    q:err'=0 "-1"
    tcommit
    q 0
}

/// 判断是否材料
/// Date:2015-12-10
/// Author:zhwh
/// Arguments:
///  DispId - RowId of DHC_OeDispensing
/// Return:
///  1 - 物资材料
///  0 - 其他  
ClassMethod isMatDisp(DispId) As %String
{
    q:DispId="" 0
    s Oeori=$p($g(^DHCOEDISQTY(DispId)),"^",1)
    q:Oeori="" 0
    s Oeord=$p(Oeori,"||",1),Ch=$p(Oeori,"||",2)
    q:(Oeord="")||(Ch="") 0
    s ARCIM=$p($g(^OEORD(Oeord,"I",Ch,1)),"^",2)
    q:ARCIM="" 0
    q ..isMatArcim(ARCIM)
}

/// 判断是否材料
/// Date:2015-12-10
/// Author:zhwh
/// Arguments:
///  ord - RowId of OE_OrdItem or OE_OrdExec
/// Return:
///  1 - 物资材料
///  0 - 其他  
ClassMethod isMatOrd(ord) As %String
{
    s Oeord=$p(ord,"||",1),Ch=$p(ord,"||",2)
    q:(Oeord="")||(Ch="") 0
    s ARCIM=$p($g(^OEORD(Oeord,"I",Ch,1)),"^",2)
    q:ARCIM="" 0
    q ..isMatArcim($g(ARCIM))
}

/// 判断是否材料
/// Date:2015-12-10
/// Author:zhwh
/// Arguments:
///  arcim - RowId of ARC_ItmMast
/// Return:
///  1 - 物资材料
///  0 - 其他  
ClassMethod isMatArcim(arcim As %String) As %String
{
    q:arcim="" 0
    s Arc=$p(arcim,"||",1)
    q:Arc="" 0
    s Inci=$o(^INCI(0,"ARCIM_DR",Arc,0))
    q:Inci="" 0
    s Incsc=$p($g(^INCI(Inci,2)),"^",2)
    q:Incsc="" 0
    s IncscStkType=$p($g(^INC("SC",Incsc)),"^",3)
    q:IncscStkType="M" 1
    q 0
}

/// Description: 给护士站提供接口,根据执行记录id判断医嘱是否已经审核通过
/// Creator:     yunhaibao
/// CreatDate:   2017-03-10
/// Input:       医嘱ID
/// Return:      Y:审核通过/不需要审核,N:审核不通过,"":未审核
/// Modify:      医生科室发药不需要审核,2020-05-18,yunhaibao
/// w ##class(web.DHCSTINTERFACE).GetOrdIPMonitorResult("2294||85")
ClassMethod GetOrdIPMonitorResult(oeori As %String) As %String
{
    s noNeedAudit = "Y"
    q:oeori="" noNeedAudit
    s ord=+oeori
    s orditm=$p(oeori,"||",2)
    s oedspid=$o(^DHCOEDISQTY(0,"OEORI",oeori,""))
    q:oedspid="" noNeedAudit
    s ord=+oeori
    s orditm=$p(oeori,"||",2)
    s userdeptdr=+$p($g(^OEORD(ord,"I",orditm,7)),"^",2) ; 开单科室
    s reclocdr=+$p($g(^OEORD(ord,"I",orditm,3)),"^",6)
    q:(userdeptdr="")||(reclocdr="") noNeedAudit
    s phalocdr=$o(^DHCPL(0,"Loc",reclocdr,""))
    q:phalocdr="" noNeedAudit
    s phalocaudit=$p(^DHCPL(phalocdr),"^",32)
    q:phalocaudit'="Y" noNeedAudit
    q:($d(^DHCSTPAL(0,"PhOrdLoc",reclocdr))&&('$d(^DHCSTPAL(0,"PhOrdLoc",reclocdr,userdeptdr)))) noNeedAudit
    #; 医生科室不审
    &sql(select * from CT_LocLinkLocation where link_parref=:reclocdr and link_ctloc_dr=:userdeptdr)
    q:SQLCODE=0 noNeedAudit
    s auditResult = ##class(PHA.COM.Method).GetPhaAuditResult4Ord(oeori)
    q $lg(auditResult,2)
}

/// Description: 根据单位格式化进售价
/// Creator:     yunhaibao
/// CreatDate:   2017-03-22
/// Input:       Input:Number-数值,HospID:医院id,DFlag:1,入库单位 2:基本单位,FmtType:格式化类型(FmtSp售价,FmtRp进价)
/// Return:      
/// w ##class(web.DHCSTINTERFACE).FormatPrice(123.12334,1,2,"FmtSp")
ClassMethod FormatPrice(Number, HospID, DFlag, FmtType) As %Library.String
{
    i FmtType="FmtSp" s retvalue=##class(web.DHCST.Common.AppCommon).FormatSp(Number, HospID, DFlag)
    e  i FmtType="FmtRp" s retvalue=##class(web.DHCST.Common.AppCommon).FormatRp(Number, HospID, DFlag)
    e  s retvalue=Number
    q retvalue
}

/// Description: 给护士站接口,提供药品实际物理数量^可用数量^在途数量（住院已审核未发药数量）接口
/// Creator:     yunhaibao
/// CreatDate:   2018-09-07
/// Input:       Arcim(医嘱项Id),RecLocId(接收科室Id),Days(统计前N天的已审未发)
/// Return:      实际库存(去除过期及批次不可用)^可用库存(在^1基础减去占用)^在途数(护士已审核未发药)
/// w ##class(web.DHCSTINTERFACE).GetQtyListForNurse("2449||1","182",3)
ClassMethod GetQtyListForNurse(Arcim, RecLocId, Days = 3) As %Library.String
{
    q:..isMatArcim(Arcim)=1 ""
    q:RecLocId="" ""
    s curQty=0
    s nurResQty=0
    s dirtyQty=0
    s incId=""
    f  s incId=$o(^INCI(0,"ARCIM_DR",+Arcim,incId)) q:incId=""  d
    .s arcEndFlag=##class(web.DHCINPHA.Disp.Query).CheckArcEnd(Arcim)
    .q:arcEndFlag="Y"   //过滤医嘱项截止   add by zouxiang 
    .s incOrdEndFlag=##class(web.DHCINPHA.Disp.Query).CheckIncOrdEnd(incId)
    .q:incOrdEndFlag="Y"  //过滤库存项医嘱截止 add by zouxiang 
    .s incCh=""
    .f  s incCh=$o(^INCI("IL_LOC",RecLocId,incId,incCh)) q:incCh=""  d
    ..q:+incCh=0
    ..s inLockFlag=""
    ..s dhcincil=$o(^DHCINCIL(0,"INCIL",incId_"||"_incCh,""))
    ..i dhcincil'="" s inLockFlag=$p($g(^DHCINCIL(dhcincil)),"^",46)
    ..q:inLockFlag="Y"  //过滤科室库存项-住院加锁
    ..s incLb=""
    ..f  s incLb=$o(^INCI(incId,"IL",incCh,"LB",incLb)) q:incLb=""  d
    ...q:+incLb=0
    ...s incChLb=incId_"||"_incCh_"||"_incLb
    ...s incBatId=$p(^INCI(incId,"IL",incCh,"LB",incLb),"^",1)
    ...s quitFlag=""
    ...i incBatId'="" d
    ....s expDate=+$p($g(^INCI(incId,"IB",+$p(incBatId,"||",2))),"^",2)
    ....i (expDate'=0)&&(expDate<+$h)  s quitFlag=1 // 过期
    ...q:quitFlag'=""
    ...s dhcInclb=$o(^DHCINCLB(0,"LB",incChLb,""),-1)
    ...q:dhcInclb=""
    ...// 过滤-批次库存项库存不可用,护士应判断此处,因医嘱已下
    ...s inclbStkAct=$p($g(^DHCINCLB(dhcInclb)),"^",4)  
    ...q:inclbStkAct'="Y"
    ...// 过滤-批次库存项医嘱不可用,护士应判断此处,因医嘱已下
    ...s pDispActiveFlag = ##class(web.DHCST.Common.AppCommon).GetParamOeoriBatActiveDisp(RecLocId)  //医嘱批次不可用是否允许发药
    ...s inclbArcAct=$p($g(^DHCINCLB(dhcInclb)),"^",2)  
    ...q:(inclbArcAct'="Y")&(pDispActiveFlag'="Y")
    ...s inclbQty=##class(web.DHCSTSTKQTY).CurQtyINCLB(incChLb)
    ...q:+inclbQty<0
    ...s curQty=curQty+inclbQty 
    ...s inclbDirQty=+$p(^INCI(incId,"IL",incCh,"LB",incLb),"^",3)
    ...s dirtyQty=dirtyQty+inclbDirQty
    s avaQty=curQty-dirtyQty
    // 计算已审核未发药
    s curDate=+$h
    s stDate=curDate-Days
    s conDate=""
    f conDate=curDate:-1:stDate d
    .s dspId=0
    .f  s dspId=$o(^DHCOEDISQTY(0,"RECCONARCIM",RecLocId,conDate,"Y","TC",Arcim,dspId)) q:dspId=""  d
    ..s oeore=$p(^DHCOEDISQTY(dspId),"^",3)
    ..q:##class(web.DHCSTCOMMONSRV).GetOrdState(oeore)=0
    ..s dspQty=$p(^DHCOEDISQTY(dspId),"^",5)
    ..s nurResQty=nurResQty+dspQty
    q curQty_"^"_avaQty_"^"_nurResQty
}

/// Description:获取某条医嘱的请求单类型（仅供护理组领药审核时生成请求单使用）
/// Creator:    hulihua
/// CreateDate: 2017-03-07（据说是女生节）
/// Table:      DHC_OEDispensing-医嘱打包表,DHCStkDrugGroup-发药类别,DHCStkDrugGrpItm-发药类别和医嘱子类关联表,DHC_PHSendLoc-送药科室维护
/// Input:      DspId-打包表ID
/// Output:
/// Return： 0-无需生成请求单，1-送药，2-取药，3-毒性，4-麻醉，5-精一，6-精二，100-弹框选择    
/// Others:     KFBY的类别走东华老流程最后发往摆药机！
/// Modify:     按后续新的逻辑修改此处, 不存在麻精等, 只返回取药\发药, 2022-01-05 yunhaibao
/// w ##class(web.DHCSTINTERFACE).GetReqTypeByDsp("217193")
ClassMethod GetReqTypeByDsp(DspId As %String) As %String
{
    s dspData = $g(^DHCOEDISQTY(DspId))
    s recLoc = $p(dspData, "^", 24)
    s wardLoc = $p(dspData, "^", 22)
    q:(recLoc = "")||(wardLoc = "") 0
    s phsl = $o(^DHCPHSLi("PHLOC", recLoc, wardLoc, ""), -1)
    q:(phsl = "") 0
    s sendFlag = $p($g(^DHCPHSL(phsl)), "^", 3)
    q:(sendFlag = "Y") 100
    q 2
#;  S RecLocId=$p(^DHCOEDISQTY(DspId),"^",24)
#;  S WardLocId=$p(^DHCOEDISQTY(DspId),"^",22)
#;  Q:'$D(^DHCPHSLi("PHLOC",RecLocId,WardLocId)) 0
#;  S Oeori=$p(^DHCOEDISQTY(DspId),"^",1)
#;  S OrdID=$p(Oeori,"||",1)
#;  S OrdSub=$p(Oeori,"||",2)
#;  S ArcimID=$p(^OEORD(OrdID,"I",OrdSub,1),"^",2)                                    
#;  S ArcCatID=$p(^ARCIM($p(ArcimID,"||",1),$p(ArcimID,"||",2),1),"^",10)        
#;  S CatCode=$p(^ARC("IC",ArcCatID),"^",1)                         
#;  S Cat=##class(web.DHCSTPCHCOLLS).GetCat(CatCode)
#;  S MachFlag=1
#;  S:Cat="KFBY" MachFlag=##class(web.DHCINPHA.MTCommon.PublicCallMethod).CheckSendKFBY(Oeori)
#;  Q:(Cat="KFBY")&&(MachFlag=0) 100
#;  Q:(Cat="KFBY")&&(MachFlag=1) 0
#;  Q:Cat["DM" 3
#;  Q:Cat["MZ" 4
#;  Q:Cat["JY" 5
#;  Q:Cat["JE" 6
#;  S PhslId=$o(^DHCPHSLi("PHLOC",RecLocId,WardLocId,""),-1)
#;  S SendFlag=$p(^DHCPHSL(PhslId),"^",3)
#;  Q:SendFlag="Y" 100 
#;  Q 2
}

/// Description:护士点击领药审核完成给药房发消息开始备药（仅供护理组领药审核界面确认开始备药时使用）
/// Creator:    hulihua
/// CreateDate: 2017-03-13
/// Table:      
/// Input:      PhLocStr-药房科室串，WardId-病区ID
/// Output:
/// Return： 0-成功，-1-接收科室为空，-2-病区为空  
/// Others:
/// w ##class(web.DHCSTINTERFACE).SaveMessageByAudit("102","2","4956")
ClassMethod SaveMessageByAudit(PhLocStr As %String, WardId As %String, UserId As %String) As %String
{
    Q:PhLocStr="" -1
    Q:WardId="" -2
    S ret=0
    S Len=$l(PhLocStr,",")
    F i=1:1:Len D
    .Q:ret'=0
    .S PhLoc=$p(PhLocStr,",",i)
    .S ret=##class(web.DHCINPHA.MTWardSeat.SetWardConfig).UpdateMessageByAudit(PhLoc,WardId)
    .b ;
    Q:ret'=0 ret
    S ret=##class(web.DHCINPHA.MTWardSeat.SetWardConfig).SetReadyDrugInfo(UserId,WardId)
    Q ret
}

/// Descript:   取售价,支持各种售价规则的取法(规则不同,参数不同)
///             对于已开立的医嘱,统一价批次价计费组均调用此处
/// Creater：    zhouyg
/// CreateDate：2017-10-24
/// Input：      DHC_OEDispBatch表ID
/// Return： 返回售价(不带千分位)
/// Others:     hulihua 2018-12-27 增加日期的入参
/// w ##class(web.DHCSTINTERFACE).GetBatchSp("102||1","34956")
ClassMethod GetBatchSp(DspBatchID, dah = "") As %String
{
    s DspID=$p(DspBatchID,"||",1)
    s DspSub=$p(DspBatchID,"||",2)
    q:(DspID="")||(DspSub="") 0
    s dspData = $g(^DHCOEDISQTY(DspID))
    s dspbData = $g(^DHCOEDISQTY(DspID,"I",DspSub))
    s inclb=$p(dspbData,"^",1)
    s inci=$p(dspbData,"^",5)
    q:(inclb="")&&(inci="") 0
    i inclb="" s inclb=inci
    s:dah="" dah=$p(dspData,"^",21)
    s uomID=""
    s oeori = $p(dspData, "^", 1)
    s RecLocID=$p($g(^OEORD(+oeori, "I", +$p(oeori, "||", 2), 3)), "^", 6)
    s HospID=""
    i RecLocID'="" d
    .s HospID=$p($g(^CTLOC(RecLocID)),"^",22)
    s timeh=""
    //s exStr="" 20210430,开医嘱计费取打包子表价格,发药计费发药时会更新打包子表价格,所以都取打包子表价格
    s exStr="^^"_DspBatchID
    s billFlag="Y"
    q ##Class(web.DHCSTPRICE).GetSp(inclb, dah, uomID, HospID, timeh, exStr,billFlag)
}

/// Descript:   取进价,支持各种进价规则的取法(规则不同,参数不同)
/// Creater：    zhouyg
/// CreateDate：2017-10-24
/// Input：      inclb-科室库存项批次ID,不按批次取的此值可以为inciID(不能为空),uomID-单位ID(为空则按基本单位取)
///             dah-日期($h格式,按入库进价取可以为空),HospID-医院ID(按入库进价取可以为空，其它规则如果为空则不进行医院判断取最后一个符合条件的记录),timeh(数值格式，为空则认为是23:59:59，只有按批次价格有意义)
/// Return： 返回进价(不带千分位)
ClassMethod GetRp(inclb, dah, uomID, HospID, timeh = "") As %String
{
    q ##Class(web.DHCSTPRICE).GetRp(inclb, dah, uomID, HospID, timeh)
}

/// Descript:   取售价,支持各种售价规则的取法(规则不同,参数不同)
/// Creater：    zhouyg
/// CreateDate：2017-10-24
/// Input：      inclb-科室库存项批次ID,不按批次取的此值可以为inciID(不能为空),uomID-单位ID(为空则按基本单位取)
///             dah-日期($h格式),HospID-医院ID(如果为空则不进行医院判断取最后一个符合条件的记录),timeh(数值格式，为空则认为是23:59:59，只有按批次价格有意义)
///             exStr-扩展参数字符串(OE_OrdItem的ID^DHC_OEDispensing的ID,这两个哪个有值就按哪个找，如果都传就按Dispensing找)
/// Return： 返回售价(不带千分位)
/// ##Class(web.DHCSTINTERFACE).GetSp("1||1||1",64580,"",1,"","")
ClassMethod GetSp(inclb, dah, uomID, HospID, timeh = "", exStr = "") As %String
{
    q ##Class(web.DHCSTPRICE).GetSp(inclb, dah, uomID, HospID, timeh, exStr)
}

/// Description:根据医嘱项的ID获取第一个库存项对应的门诊发药单位和住院发药单位信息
/// Creator:    hulihua
/// CreateDate: 2017-10-24
/// Table:      ARC_ItmMast–医嘱项表、INC_Itm-库存项表
/// Input:
/// Output:
/// Return：    门诊发药单位ID^门诊发药单位^住院发药单位ID^住院发药单位^基本单位
/// Others: flag=1，取基本单位ID;  flag=0，取住院发药单位或基本单位
/// w ##class(web.DHCSTINTERFACE).GetPhDispUom("577||1","1")
ClassMethod GetPhDispUom(ArcimDr As %String, flag As %String) As %String
{
    q:ArcimDr="" "NoINCI"
    s Inci=##class(web.DHCSTCOMINC).GetInciID(ArcimDr)
    q:Inci="" "NoINCI"
    s OutPhUomDr=$p(^INCI(Inci,1),"^",12)
    s INCICTUOMDR=$p(^INCI(Inci,1),"^",10)
    ;s INCICTUOM=$p(^CT("UOM",INCICTUOMDR),"^",2)
    s OutPhUom=$s(OutPhUomDr'="":$p(^CT("UOM",OutPhUomDr),"^",2),1:"")
    s InPhUomDr=$p(^INCI(Inci,1),"^",13)
    s InPhUom=$s(InPhUomDr'="":$p(^CT("UOM",InPhUomDr),"^",2),1:"")
    //^ARCIM({ARCIM_Subscript},{ARCIM_Version})
    s ARCIMSubscript=$p(ArcimDr,"||",1)
    s ARCIMVersion=$p(ArcimDr,"||",2)
    s ARCIMItemCatDR=$p(^ARCIM(ARCIMSubscript,ARCIMVersion,1),"^",10) //医嘱子分类ID
    if flag="0"
        {
        if ((ARCIMItemCatDR="29")||(ARCIMItemCatDR="30")) 
            {
                q INCICTUOMDR
            }
        else
            {
                if InPhUomDr="" s InPhUomDr="NoINCI"
                q InPhUomDr
            }
        }
    else 
        {
            if INCICTUOMDR="" s INCICTUOMDR="NoINCI"
            q INCICTUOMDR
            
        }
}

/// Description:通过收费项获取医嘱项ID（医保组调用）
/// Creator:    hulihua
/// CreateDate: 2017-11-13
/// Table:      DHC_TarItem、DHC_IncTarRela、ARC_ItmMast、INC_Itm、      
/// Input:      
/// Output:
/// Return： 医嘱项ID  
/// Others:
/// w ##class(web.DHCSTINTERFACE).GetArcimDrByTar("1")
ClassMethod GetArcimDrByTar(TarId As %String) As %String
{
    Q:TarId="" ""
    S IncTarRelaId=$o(^DHCINCTARi("TAR",TarId,""),-1)
    Q:IncTarRelaId="" ""
    S InciId=$p(^DHCINCTAR(IncTarRelaId),"^",1)
    Q:InciId="" ""
    S ArcimDr=##class(web.DHCST.Common.DrugInfoCommon).GetArcim(InciId)
    Q ArcimDr
}

/// Description:通过医嘱项ID获取收费项ID串（医保组/医生站调用）
/// Creator:    hulihua
/// CreateDate: 2017-11-13
/// Table:      DHC_TarItem、DHC_IncTarRela、ARC_ItmMast、INC_Itm、      
/// Input:      收费项ID串      
/// Output:
/// Return： 收费项ID    
/// Others:
/// w ##class(web.DHCSTINTERFACE).GetTarIdByArcimDr("1927||1")
ClassMethod GetTarIdByArcimDr(ArcimId As %String) As %String
{
    Q:ArcimId="" ""
    S ArcIDM=$p(ArcimId,"||",1)
    Q:ArcIDM="" ""
    S TarIdStr=""
    S InciId=0
    F  S InciId=$o(^INCI(0,"ARCIM_DR",ArcIDM,InciId))  Q:InciId=""  D
    .Q:+InciId=0
    .s TarId=##class(web.DHCST.INCLINKTAR).GetTarItmIdByInc(InciId,"")
    .q:TarId=""
    .S TarIdStr=$S(TarIdStr="":TarId,1:TarIdStr_","_TarId)
    Q TarIdStr
}

/// Description:通过执行记录ID获取收费项ID和批号串（医保组调用）
/// Creator:    hulihua
/// CreateDate: 2017-11-13
/// Table:      DHC_TarItem、DHC_IncTarRela、ARC_ItmMast、INC_Itm、      
/// Input:      Oeore-执行记录ID        
/// Output:
/// Return： 批号,收费项ID,发药退药标识$$批次号,收费项ID,发药退药标识    
/// Others:
/// w ##class(web.DHCSTINTERFACE).GetTarInfoByOeore("1143||2||1")
ClassMethod GetTarInfoByOeore(Oeore As %String) As %String
{
    Q:Oeore="" ""
    S ReturnStr=""
    s DspDate=""
    S DspId=""
    F  S DspId=$o(^DHCOEDISQTY(0,"OEORE",Oeore,DspId)) Q:DspId=""  D
    .S DspStatus=$p(^DHCOEDISQTY(DspId),"^",7)
    .Q:DspStatus="TC"
    .S DspType=$p(^DHCOEDISQTY(DspId),"^",13)
    .S DspPointer=$p(^DHCOEDISQTY(DspId),"^",14)
    .S DspDate=$p(^DHCOEDISQTY(DspId),"^",8)
    .S DspCh=0
    .F  S DspCh=$o(^DHCOEDISQTY(DspId,"I",DspCh))  Q:DspCh=""  D
    ..S DspBatch=DspId_"||"_DspCh
    ..I DspStatus="C" D
    ...I DspType="P" D
    ....S sub=$o(^DHCPHACi("DSPB",DspBatch,+DspPointer,$p(DspPointer,"||",2),""),-1)
    ....S Inclb=$p(^DHCPHAC(+DspPointer,"I",$p(DspPointer,"||",2),"B",sub),"^",1)
    ...E  D
    ....S sub=$o(^DHCPHDIi("DSPB",DspBatch,+DspPointer,$p(DspPointer,"||",2),""),-1)
    ....S Inclb=$p(^DHCPHDI(+DspPointer,"PHDI",$p(DspPointer,"||",2),"INCLB",sub),"^",3)
    ...S Incib=$P(^INCI(+Inclb,"IL",$p(Inclb,"||",2),"LB",$p(Inclb,"||",3)),"^",1)
    ...S Chl=$p(Incib,"||",2)
    ...S BatNo=$p(^INCI(+Incib,"IB",Chl),"^",1)
    ...s TarId=##class(web.DHCST.INCLINKTAR).GetTarItmIdByInc(+Inclb,DspDate)
    ...S ReturnStr=$s(ReturnStr="":BatNo_","_TarId_",0",1:ReturnStr_"$$"_BatNo_","_TarId_",0")
    ..E  D
    ...I DspType="Y" D
    ....S Inci=$p(^DHCOEDISQTY(DspId,"I",DspCh),"^",5)
    ....S PhacDsp=$o(^DHCOEDISQTY(0,"OEORE",Oeore,""))
    ....S PhacCh=0,PhacDspBatch=""
    ....F  S PhacCh=$O(^DHCOEDISQTY(PhacDsp,"I",PhacCh))  Q:(PhacCh="")||(PhacDspBatch'="")  D
    .....S PhacInci=$p(^DHCOEDISQTY(PhacDsp,"I",PhacCh),"^",5)
    .....S:PhacInci=Inci PhacDspBatch=PhacDsp_"||"_PhacCh
    ....Q:PhacDspBatch=""
    ....S sub=$o(^PHARETi("DSPB",PhacDspBatch,+DspPointer,$p(DspPointer,"||",2),""),-1)
    ....S Inclb=$p(^PHARET(+DspPointer,"I",$p(DspPointer,"||",2),"B",sub),"^",1)
    ...E  D
    ....S sub=$o(^DHCPHRTIi("DSPB",DspBatch,+DspPointer,""),-1)
    ....S Inclb=$p(^DHCPHRTI(+DspPointer,"RTI",sub),"^",12)
    ...S Incib=$P(^INCI(+Inclb,"IL",$p(Inclb,"||",2),"LB",$p(Inclb,"||",3)),"^",1)
    ...S Chl=$p(Incib,"||",2)
    ...S BatNo=$p(^INCI(+Incib,"IB",Chl),"^",1)
    ...s TarId=##class(web.DHCST.INCLINKTAR).GetTarItmIdByInc(+Inclb,DspDate)
    ...S ReturnStr=$s(ReturnStr="":BatNo_","_TarId_",1",1:ReturnStr_"$$"_BatNo_","_TarId_",1")
    ..
    .
    Q ReturnStr
}

/// Description:通过收费项ID取药品信息
/// Creator:    hulihua
/// CreateDate: 2017-11-14
/// Table:      DHC_TarItem、DHC_IncTarRela、INC_Itm、      
/// Input:      
/// Output:
/// Return： 规格、基本单位、入库单位、剂型dr、剂型、厂家、每次用量、频次、剂量单位、批准文号 
/// Others:     医保组上传数据调用，由于入参是收费项厂家取三大项默认的，等效单位多个徐保保徐工说等效单位只取第一个！
/// w ##class(web.DHCSTINTERFACE).GetDrugInfoByTar("1")
ClassMethod GetDrugInfoByTar(TarId As %String) As %String
{
    Q:TarId="" ""
    S InciId=##class(web.DHCST.INCLINKTAR).GetIncIdByTarItm(TarId)
    Q:InciId="" ""
    S Spec=##class(web.DHCST.Common.DrugInfoCommon).GetSpec("",InciId)
    S PurUomId=$p(^INCI(InciId,3),"^",6)
    S PurchCTUomDesc =$p(^CT("UOM",PurUomId),"^",2)
    S BUomId=$p(^INCI(InciId,1),"^",10)
    S BaseCTUomDesc =$p(^CT("UOM",BUomId),"^",2)
    S FormInfo=##class(web.DHCST.Common.DrugInfoCommon).GetForm(InciId)
    S Form=$p(FormInfo,"^",2)
    S FormDr=$p(FormInfo,"^",3)
    S ManfInfo=##class(web.DHCST.Common.DrugInfoCommon).GetManf(InciId)
    S Manf=$p(ManfInfo,"^",3)
    S Remark=##class(web.DHCST.Common.DrugInfoCommon).GetInciRemark(InciId)
    S ArcimDr=##class(web.DHCST.Common.DrugInfoCommon).GetArcim(InciId)
    S Phcdf=##class(web.DHCST.Common.DrugInfoCommon).GetPhcdfByArcim(ArcimDr)
    S Freq=$p(##class(web.DHCST.Common.DrugInfoCommon).GetPhcFreqByPhcdf(Phcdf),"^",2)
    S phc=$P(Phcdf,"||",1)
    Q:phc="" ""
    S formsub=$P(Phcdf,"||",2)
    Q:formsub="" ""
    S eqsub=$O(^PHCD(phc,"DF",formsub,"EQ",""))         //为空：未维护等效单位
    S equomdr=$s(eqsub'="":$P($g(^PHCD(phc,"DF",formsub,"EQ",eqsub)),"^",1),1:"")
    S EQuom=$s(equomdr'="":$P($g(^CT("UOM",equomdr)),"^",2),1:"")
    S EQqty=$s(eqsub'="":$P($g(^PHCD(phc,"DF",formsub,"EQ",eqsub)),"^",2),1:"") //等效数量
    S ReturnStr1=Spec_"^"_BaseCTUomDesc_"^"_PurchCTUomDesc_"^"_FormDr_"^"_Form_"^"_Manf
    S ReturnStr2=EQqty_"^"_Freq_"^"_EQuom_"^"_Remark
    S ReturnStr=ReturnStr1_"^"_ReturnStr2
    Q ReturnStr
}

/// Description:获取一段时间内的入库\退货主信息和明细信息
/// Creator:    hulihua
/// CreateDate: 2017-11-17
/// Table:      DHC_INGdRec-入库主表、DHC_INGdRecItm-入库子表、DHC_INTRANS-科室库存操作跟踪表
/// Input:      StratDate-开始日期、EndDate-截止日期、PhLoc-入库科室、IngrNo-入库单号、类型(G-入库,R-退货)
/// Output:     业务单号，采购批次号，发票号，进货价，进（退）货数量，医院药品编号,医院药品名称，进（退）货日期，生产厂家，剂型，规格，单位，批准文号，国药准字，备注，供货商
/// Return：     inum-明细条数，pid-计数器   
/// Others:     医保组上传数据调用
/// w ##class(web.DHCSTINTERFACE).GetInGdrecByIntr("2017-10-11","2017-11-17","","","G")
ClassMethod GetInGdrecByIntr(StratDate As %String, EndDate As %String, PhLoc As %String, IngrNo As %String, Type As %String) As %String
{
    q:(StratDate="")||(EndDate="") ""
    ;s StratDate=$zdh(StratDate,3)
    ;s EndDate=$zdh(EndDate,3)
    s pid=$I(^TMP("DHCST","web.DHCSTINTERFACE"))
    k ^TMP("DHCST","web.DHCSTINTERFACE","GetInGdrecByIntr",pid,"InTrDetail")
    s typestr=$s(Type="":"G^R",1:Type),Num=0
    s cnt=$l(typestr,"^")
    f i=1:1:cnt d
    .s type=$p(typestr,"^",i)
    .f date=StratDate:1:EndDate d
    ..s intr=""
    ..f  s intr=$o(^DHCINTR(0,"TypeDate",type,date,intr)) q:intr=""  d
    ...q:'$d(^DHCINTR(intr))
    ...s Inclb=$p(^DHCINTR(intr),"^",7)
    ...s LocID=$$LOC^ST01(Inclb)
    ...q:(PhLoc'="")&&(PhLoc'=LocID)
    ...s Inci=+Inclb
    ...s pointer=$p(^DHCINTR(intr),"^",9)
    ...s InciCode = $p(^INCI(Inci,1),"^",1)
    ...s InciDesc = $p(^INCI(Inci,1),"^",2)
    ...s IntrDate=$p(^DHCINTR(intr),"^",2)
    ...s:IntrDate'="" IntrDate=$zd(IntrDate,3)
    ...s Incib=$P(^INCI(Inci,"IL",$p(Inclb,"||",2),"LB",$p(Inclb,"||",3)),"^",1)
    ...s BatNo=$p(^INCI(Inci,"IB",$p(Incib,"||",2)),"^",1)
    ...s VendManf=##class(web.DHCST.Common.DrugStkCommon).VendManfByIncIb(Incib) 
    ...s PManf=$p(VendManf,"^",4)
    ...s FormInfo=##class(web.DHCST.Common.DrugInfoCommon).GetForm(Inci)
    ...s Form=$p(FormInfo,"^",2)
    ...s Spec=##class(web.DHCST.Common.DrugInfoCommon).GetSpec("",Inci)
    ...s BUomId=$p(^INCI(Inci,1),"^",10)
    ...s BaseCTUomDesc =$p(^CT("UOM",BUomId),"^",2)
    ...s ReMark=##class(web.DHCST.Common.DrugInfoCommon).GetInciRemark(Inci)
    ...s ReMarkNote=ReMark
    ...s Qty=$p(^DHCINTR(intr),"^",6)
    ...s IntrUom=$p(^DHCINTR(intr),"^",10)
    ...s Fac=##class(web.DHCST.Common.UtilCommon).UOMFac(IntrUom,BUomId)
    ...S Qty=Qty*Fac
    ...i type="G" d
    ....s IngrId=+pointer
    ....s Ingrch=$p(pointer,"||",2)
    ....q:'$d(^DHCINGR(IngrId))
    ....q:'$d(^DHCINGR(IngrId,"GRI",Ingrch))
    ....s IntrNo=$p(^DHCINGR(IngrId),"^",1)
    ....s vendordr=$p(^DHCINGR(IngrId),"^",3)
    ....s InvNo=$p(^DHCINGR(IngrId,"GRI",Ingrch),"^",27)
    ....s Rp=$p(^DHCINGR(IngrId,"GRI",Ingrch),"^",30)
    ....s Rp=Rp/Fac
    ....s Note=$G(^DHCINGR(IngrId,"GRI",Ingrch,"REM"))
    ...e  d
    ....s IngrtId=+pointer
    ....s Ingrtch=$p(pointer,"||",2)
    ....q:'$d(^INGRT(IngrtId))
    ....q:'$d(^INGRT(IngrtId,"DHCGRR",Ingrtch))
    ....s IntrNo=$p(^INGRT(IngrtId),"^",1)
    ....s vendordr=$p(^INGRT(IngrtId),"^",2)
    ....s InvNo=$p(^INGRT(IngrtId,"DHCGRR",Ingrtch),"^",12)
    ....s Rp=$p(^INGRT(IngrtId,"DHCGRR",Ingrtch),"^",7)
    ....s Rp=Rp/Fac
    ....s Note=$p(^INGRT(IngrtId,"DHCGRR",Ingrtch),"^",21)
    ...q:(IngrNo'="")&&(IngrNo'=IntrNo)
    ...s vendordesc=$S(vendordr'="":$p(^APC("APCVM",vendordr),"^",3),1:"") 
    ...s:$F(vendordesc,"-") vendordesc=$p(vendordesc,"-",2)
    ...;
    ...s Data1=IntrNo_"^"_BatNo_"^"_InvNo_"^"_Rp_"^"_Qty                        //单号，采购批次号，发票号，进货价，进（退）货数量
    ...s Data2=InciCode_"^"_InciDesc_"^"_IntrDate_"^"_PManf_"^"_Form            //医院药品编号，医院药品名称，进（退）货日期，生产厂家，剂型
    ...s Data3=Spec_"^"_BaseCTUomDesc_"^"_ReMark_"^"_ReMarkNote_"^"_Note        //规格，单位，批准文号，国药准字，备注，供货商
    ...s Data4=vendordesc                                                       //供货商
    ...s Num=Num+1
    ...s ^TMP("DHCST","web.DHCSTINTERFACE","GetInGdrecByIntr",pid,"InTrDetail",Num)=Data1_"^"_Data2_"^"_Data3_"^"_Data4
    ..
    .
    q pid_"^"_Num
}

/// Description:护士停止执行记录的时候需要自动作废最后一次的请领记录
/// Creator:    hulihua
/// CreateDate: 2017-12-26
/// Table:      DHC_InPhReq、DHC_InPhReqItm
/// Input:      DspId-打包表ID,CancelUserId-停止人ID
/// Output:
/// Return： 0-成功或无需修改，-1-请领子表修改失败，-2-请领主表修改失败，空-请领单信息有误 
/// Others:     医生站和护理组停医嘱、停执行记录以及撤销领药审核调用  
/// w ##class(web.DHCSTINTERFACE).UpInphReqStatus("")
ClassMethod UpInphReqStatus(DspId As %String, CancelUserId As %String) As %String
{
    q:DspId="" ""
    ;无需走请领单的无需修改！
    q:'$d(^DHCINPHREQi("DSP",DspId)) 0
    ;已发药或者退药的无需修改！
    q:$p(^DHCOEDISQTY(DspId),"^",7)'="TC" 0         
    s PhReqId=$o(^DHCINPHREQi("DSP",DspId,""),-1)
    q:PhReqId=""
    s PhReqCh=$o(^DHCINPHREQi("DSP",DspId,PhReqId,""),-1)
    q:PhReqCh="" ""
    q:'$d(^DHCINPHREQ(PhReqId,"I",PhReqCh)) ""
    s PhReqiStatus=$p(^DHCINPHREQ(PhReqId,"I",PhReqCh),"^",2)
    s PhReqiId=PhReqId_"||"_PhReqCh
    s Status="05",CancelDate=+$h,CancelTime=$p($h,",",2),Err=0
    i PhReqiStatus'="05" d
    .;修改请领子表状态！
    .&sql(Update DHC_InPhReqItm set PHRI_Status=:Status,PHRI_CancelUser_Dr=:CancelUserId,PHRI_CancelDate=:CancelDate,
    PHRI_CancelTime=:CancelTime where PHRI_RowID=:PhReqiId)
    .i SQLCODE'=0  d
    ..s rett=$$ErrorRecord^DHCSTERROR("UpInphReqStatus:DHC_InPhReqItm",PhReqiId,SQLCODE_":"_%msg)
    ..s Err=-1
    .           
    q:Err'=0 Err
    ;主表已经是作废状态的无需再次更新！
    s InReqSatus=$p(^DHCINPHREQ(PhReqId),"^",8)
    q:InReqSatus="05" Err
    ;循环遍历修改主表的状态
    s PhReqCh=0,UpdateFlag=0
    f  s PhReqCh=$o(^DHCINPHREQ(PhReqId,"I",PhReqCh))  q:(PhReqCh="")||(UpdateFlag'=0)  d
    .s InReqiSatus=$p(^DHCINPHREQ(PhReqId,"I",PhReqCh),"^",2)
    .s:InReqiSatus'="05" UpdateFlag=1
    q:UpdateFlag'=0 Err
    &sql(Update DHC_InPhReq set PHR_Status=:Status,PHR_CancelUser_Dr=:CancelUserId,PHR_CancelDate=:CancelDate,
    PHR_CancelTime=:CancelTime where PHR_RowID=:PhReqId)
    i SQLCODE'=0  d
    .s rett=$$ErrorRecord^DHCSTERROR("UpInphReqStatus:DHC_InPhReq",PhReqId,SQLCODE_":"_%msg)
    .s Err=-2           
    q Err
}

/// Descript:   取组合金额(医生站开医嘱界面显示草药用)
/// Creater：    zhouyg
/// CreateDate：2017-10-24
/// Input：InciList
/// Return：返回金额
/// w ##class(web.DHCSTINTERFACE).GetInciListPrice()
ClassMethod GetInciListPrice(incilist, HospID = "") As %String
{
    q:incilist="" 0
    s num=$l(incilist,"@")
    q:num=0 0
    s amt=0
    f ii=1:1:num  d
    .s IncStr=$p(incilist,"@",ii)
    .s IncID=$p(IncStr,"!",1)
    .s DspQty=+$p(IncStr,"!",2)
    .q:IncID=""
    .q:DspQty=0
    .s sp=##Class(web.DHCSTPRICE).GetSp(IncID,+$h,"", HospID)
    .s spamt=sp*DspQty
    .s amt=amt+spamt
    q amt
}

/// Description:根据药学单位数量转换为库存基本单位数量（医嘱项对库存项一对多）
/// Creator:    zhouyg
/// CreateDate: 2018-10-11
/// Table:      
/// Input:      库存项ID,药学单位ID（药学基本单位或等效单位）,数量
/// Output:
/// Return： 库存项基本单位数量
/// Others:     医生站开医嘱调用
/// w ##class(web.DHCSTINTERFACE).ConPhQty("11","111",12)
ClassMethod ConPhQty(incID As %String, phUomID As %String, phQty As %String) As %String
{
    q:incID="" phQty
    q:phUomID="" phQty
    s incUomID=$p($g(^INCI(incID,1)),"^",10)
    q:incUomID="" phQty
    //1 库存项基本单位=入参单位
    q:incUomID=phUomID phQty    
    s conFacID=$o(^CT("CTCF",0,"UOM",incUomID,phUomID,""))
    //2 库存项基本单位与入参单位有转换系数
    i conFacID'="" d
    .s uomFac=$p(^CT("CTCF",conFacID),"^",3)
    e  d
    .
    .s uomFac=0
    q:uomFac=0 phQty
    s incQty=phQty/uomFac
    q incQty
}

/// Description:根据药学单位数量转换为库存基本单位数量（医嘱项对库存项一对多）
/// Creator:    zhouyg
/// CreateDate: 2018-10-11
/// Table:      
/// Input:      库存项ID,药学单位ID（可以为各种单位，包括等效单位）,数量
/// Output:
/// Return： 库存项基本单位数量
/// Others:     医生站开医嘱调用
/// w ##class(web.DHCSTINTERFACE).ConPhQty("11","111",12)
ClassMethod GetConPhQty(incID As %String, phUomID As %String, phQty As %String) As %String
{
    s incQty=##class(web.DHCSTCOMINC).GetConPhQty(incID,phUomID,phQty)
    q incQty
}

/// Description:根据两个传入单位取得转换率
/// Creator:    hulihua
/// CreateDate: 2018-10-10
/// Table:      CT_ConFac      
/// Input:      fr-转入之前的单位, to-要转的单位
/// Output:     
/// Return： 转换率
/// Others: 
/// Others: w ##class(web.DHCSTINTERFACE).UOMFac(14,26)
ClassMethod UOMFac(fr, to)
{
    q ##class(web.DHCST.Common.UtilCommon).UOMFac(fr,to)
}

/// Description:判断某医嘱项的结构模式
/// Creator:    hulihua
/// CreateDate: 2018-10-15
/// Table:      ARC_ItmMast–医嘱项表、DHC_StkCatGroup-类组表
/// Input:      ArcimDr-医嘱项ID
/// Output:     
/// Return： Y-一对多，N-一对一 
/// Others:   
/// Debug:      w ##class(web.DHCSTINTERFACE).GetStruModeFlag("1||1")
ClassMethod GetStruModeFlag(ArcimDr As %String) As %String
{
    q:ArcimDr="" "N"
    s ArcimSub=$p(ArcimDr,"||",1)
    q:ArcimSub="" "N"
    s Inci=$o(^INCI(0,"ARCIM_DR",ArcimSub,"")) 
    q:Inci="" "N"
    s StkGrpInfo=##class(web.DHCST.Common.DrugInfoCommon).GetIncStkCatGrp(Inci)
    s ScgType=$p(StkGrpInfo,"^",3)
    q:ScgType'="G" "N"
    s StruModeFlag=$p(StkGrpInfo,"^",7)
    s:StruModeFlag="" StruModeFlag="N"
    q StruModeFlag
}

/// Description: 给新产品组接口,根据医嘱Id,获取已发数量(带单位)
/// Creator:     yunhaibao
/// CreatDate:   2018-10-31
/// Input:       Oeori(医嘱Id)
/// Return:      
/// w ##class(web.DHCSTINTERFACE).GetOeoriDispedQtyUom("1009||6")
ClassMethod GetOeoriDispedQtyUom(Oeori) As %Library.String
{
    q:Oeori="" ""
    s arcItmId=$p($g(^OEORD(+Oeori,"I",+$p(Oeori,"||",2),1)),"^",2)
    s arcSub=+arcItmId
    s arcVer=+$p(arcItmId,"||",2)
    s incId=$o(^INCI(0,"ARCIM_DR",arcSub,""))
    q:incId="" ""
    s phcdfId=$p(^ARCIM(arcSub,arcVer,1),"^",12)
    s phcUomId=$p(^PHCD(+phcdfId,"DF",+$p(phcdfId,"||",2),2),"^",4)
    s struModeFlag=##class(web.DHCSTINTERFACE).GetStruModeFlag(arcItmId)
    s qty=0
    s dspId=0
    f  s dspId=$o(^DHCOEDISQTY(0,"OEORI",Oeori,dspId)) q:dspId=""  d
    .s dspData=$g(^DHCOEDISQTY(dspId))
    .q:$p(dspData,"^",7)="TC"   // 未发
    .s dspSub=0
    .f  s dspSub=$o(^DHCOEDISQTY(dspId,"I",dspSub)) q:dspSub=""  d
    ..s dspSubData=^DHCOEDISQTY(dspId,"I",dspSub)
    ..s dspSubStatus=$p(dspSubData,"^",6)
    ..q:(dspSubStatus'="C")&&(dspSubStatus'="R")
    ..s dspQty=$p(dspSubData,"^",2)
    ..i dspSubStatus="R" s dspQty=-dspQty
    ..s incId=$p(dspSubData,"^",5)
    ..i struModeFlag="Y" d
    ...s bUomId=$p(^INCI(incId,1),"^",10)
    ...s fac=##Class(web.DHCSTCOMMONSRV).UOMFac(bUomId,phcUomId)
    ...s dspQty=dspQty*fac
    ...s qty=qty+dspQty
    ..e  d
    ...s qty=qty+dspQty // 非一对多,药学单位与基本单位一致
    q:qty=0 ""
    s uomDesc=""
    // 一对多,按药学基本单位输出
    i struModeFlag="Y" d
    .s uomDesc=$p($g(^CT("UOM",+phcUomId)),"^",2) 
    e  d
    .s tmpDspId=$o(^DHCOEDISQTY(0,"OEORI",Oeori,""))
    .s admId=$p(^DHCOEDISQTY(tmpDspId),"^",26)
    .s admType=$p(^PAADM(admId),"^",2)
    .s dispUomId=$p($g(^OEORD(+Oeori,"I",+$p(Oeori,"||",2),"DHC")),"^",13)
    .i admType="I" s dispUomId="" // yunhaibao20181227,住院先不转换
    .i dispUomId'="" d
    ..s qtyUomStr=##class(web.DHCSTCOMMONSRV).BQtyToPhaUomQty(incId,qty,dispUomId)
    .e  i admType="I" d // 住院转为住院发药单位
    ..s qtyUomStr=##class(web.DHCSTCOMMONSRV).BQtyToInUomQty(incId,qty)
    .e  d            // 门诊转为门诊发药单位
    ..s qtyUomStr=##class(web.DHCSTCOMMONSRV).BQtyToOutUomQty(incId,qty)
    .s qty=$p(qtyUomStr,"^",1)
    .s uomId=$p(qtyUomStr,"^",2)
    .s uomDesc=$p($g(^CT("UOM",+uomId)),"^",2) 
    i (qty<1)&&($p(qty,".",1)'="") s qty=0_qty
    q qty_uomDesc
}

/// Description:(给Portal组调用)护士长角色查询退药信息
/// Creator:    dinghongying
/// CreateDate: 2018-12-12
/// d ##class(%ResultSet).RunQuery("web.DHCSTINTERFACE","QueryRetInfo","2018-12-10","2018-12-13","","1")
Query QueryRetInfo(StartDate As %String, EndDate As %String, WardID As %String, Type As %String) As websys.Query(ROWSPEC = "AdmId,OrdExeRowid,DrugDesc,RetNo,RetQty,Uom,DoseQty,ReqStatusCode,ReqStatus,ReqDate,ReqUserId,ReqUser,RetDate,RetUserId,RetUser")
{
}

ClassMethod QueryRetInfoExecute(ByRef qHandle As %Binary, StartDate As %String, EndDate As %String, WardID As %String, Type As %String) As %Status
{
    s repid=$I(^CacheTemp)
    s qHandle=$lb(0,repid,0)
    s ind=1
    i +$p($g(^PAWARD(+WardID)),"^",5)>0 s WardLocId=$p($g(^PAWARD(+WardID)),"^",5)
    e  s WardLocId=WardID
    set Str=##class(web.DHCINPHA.Request).GetRetInfo(StartDate,EndDate,WardID,Type)
    s pid=$p(Str,"^",1)
    s n=$p(Str,"^",2)
    q:n'>0 $$$OK
    s num=""
    f  s num=$o(^TMP("DHCST","web.DHCINPHA.Request","GetRetInfo",pid,num)) q:num=""  d
    .s RetInfo=^TMP("DHCST","web.DHCINPHA.Request","GetRetInfo",pid,num)
    .s AdmId=$p(RetInfo,"^",1)
    .s OrdExeRowid=$p(RetInfo,"^",2)
    .q:OrdExeRowid=""
    .s DrugDesc=$p(RetInfo,"^",3)
    .s RetNo=$p(RetInfo,"^",4)
    .s RetQty=$p(RetInfo,"^",5)
    .s Uom=$p(RetInfo,"^",6)
    .s DoseQty=$p(RetInfo,"^",7)
    .s ReqStatusCode=$p(RetInfo,"^",8)
    .s ReqStatus=$p(RetInfo,"^",9)
    .q:(ReqStatusCode="1")&&(ReqStatus="已退药")
    .s ReqDate=$p(RetInfo,"^",10)
    .s ReqDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(ReqDate) 
    .s ReqUserId=$p(RetInfo,"^",11)
    .s ReqUser=$p(RetInfo,"^",12)
    .s RetDate=$p(RetInfo,"^",13)
    .s RetDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(RetDate)
    .s RetUserId=$p(RetInfo,"^",14)
    .s RetUser=$p(RetInfo,"^",15)
    .s wardDr=$p(RetInfo,"^",16)
    .q:(WardLocId'="")&&(WardLocId'=wardDr)
    .set Data=$lb(AdmId,OrdExeRowid,DrugDesc,RetNo,RetQty,Uom,DoseQty,ReqStatusCode,ReqStatus,ReqDate,ReqUserId,ReqUser,RetDate,RetUserId,RetUser)
    .Set ^CacheTemp(repid,ind)=Data  
    .Set ind=ind+1
    k ^TMP("DHCST","web.DHCINPHA.Request","GetRetInfo",pid)
    q $$$OK
}

/// Author : MaYuqiang
/// Date Created : 20190107
/// Description:统计处方点评数据(给Portal组提供)
/// Input : StartDate - 开始日期(系统日期格式), EndDate - 截止日期(系统日期格式), userCode - 门诊指医嘱医生,住院指主管医生(SS_User的id)
///         TypeID - 点评方式id, AdmLocID - 就诊科室id
/// Output : admid - 就诊id , prescno - 处方号 , result - 点评结果(Y/N/"" - 合理/不合理/未点评) , comreason - 点评原因(仅不合理才写:orditm1$$原因串1^orditm1$$原因串2)
/// 
/// d ##class(%ResultSet).RunQuery("web.DHCSTINTERFACE","QueryCommentInfo","64649","65000","","","")
Query QueryCommentInfo(StartDate As %String, EndDate As %String, userCode As %String, TypeID As %String, AdmLocID As %String) As websys.Query(ROWSPEC = "adm:%String,prescno:%String,result:%String,resconinfo:%String,commentdate:%String,admloc:%String")
{
}

ClassMethod QueryCommentInfoExecute(ByRef qHandle As %Binary, StartDate As %String, EndDate As %String, userCode As %String, TypeID As %String, AdmLocID As %String) As %Status
{
    s repid=$I(^CacheTemp)
    s qHandle=$lb(0,repid,0)
    s ind=1
    
    s CTypeStr="P^F"        // 默认住院,门诊点评单都统计
    s CTypeLen=$l(CTypeStr,"^")
    f CTypeNum=1:1:CTypeLen d
    .s CType=$p(CTypeStr,"^",CTypeNum)
    .f date=StartDate:1:EndDate d
    ..s pcntsid=""
    ..f  s pcntsid=$o(^DHCPHCNTS(0,"Date",date,CType,pcntsid)) q:pcntsid=""  d
    ...s pcntstype=$p(^DHCPHCNTS(pcntsid),"^",7)    //点评方式id
    ...q:(TypeID'="")&&(TypeID'=pcntstype)
    ...s itm="0"
    ...f  s itm=$o(^DHCPHCNTS(pcntsid,"I",itm)) q:itm=""  d
    ....q:'$d(^DHCPHCNTS(pcntsid,"I",itm))
    ....s pcntsitm=pcntsid_"||"_itm
    ....s comdata=$g(^DHCPHCNTS(pcntsid,"I",itm))
    ....s prescno=$p(comdata,"^",1)         //处方号
    ....s adm=$p(comdata,"^",3)             //就诊id
    ....s admloc=$p(^PAADM(adm),"^",4)      //就诊科室
    ....q:(AdmLocID'="")&&('$LF($LISTFROMSTRING(AdmLocID,"^"),admloc))
    ....i CType="F" d
    .....s orditm=$p(comdata,"^",2) 
    .....s ctpcpid=$p($g(^OEORD(+orditm,"I",$p(orditm,"||",2),1)),"^",11)
    ....e  d
    .....s ctpcpid=$p(^PAADM(adm),"^",9)
    ....//s doctorid=$o(^SSU("SSUSR",0,"CTPCP",ctpcpid,""),-1)
    ....s doctorcode=$p($g(^CTPCP(ctpcpid,1)),"^",1)
    ....q:(userCode'="")&&(userCode'=doctorcode)    //过滤医生
    ....s result=$p(comdata,"^",6)              //点评结果
    ....s resconinfo=""                         //点评原因串
    ....i result="N" d
    .....s resconinfo=##class(web.DHCSTCNTSCOMMON).GetCommonReason(pcntsitm)
    ....s commentdate=$zd(date,3)
    ....s locId=admloc
    ....d OutPutComData
    q $$$OK
OutPutComData
    set Data=$lb(adm,prescno,result,resconinfo,commentdate,admloc)
    Set ^CacheTemp(repid,ind)=Data  
    Set ind=ind+1
    q
}

/// description: 插入中间表数据
/// input:       PrescNo(处方号),PrtId(发票Id),RecLocId(接收科室Id)
/// w ##class(web.DHCOUTPHA.PharWin).InsertPharWin("O181217000012","",309,"")
ClassMethod InsertPharWin(PrescNo, PrtId, RecLocId, PhwId = "")
{
    q ##class(web.DHCOUTPHA.PharWin).InsertPharWin(PrescNo, PrtId, RecLocId, PhwId)
}

/// description: 根据执行记录判断药品是否被加锁(给护理组)
/// input:       Oeore(执行记录Id)
/// return:      1(加锁)
/// w ##class(web.DHCSTINTERFACE).GetIncilLockByOeore("146||262||6")
ClassMethod GetIncilLockByOeore(Oeore)
{
    q:Oeore="" ""
    s adm=$P(^OEORD(+Oeore),"^",1)
    s admType=$P(^PAADM(adm),"^",2)
    s lockNode=$S(admType="I":46,1:1)
    s dspId=$o(^DHCOEDISQTY(0,"OEORE",Oeore,""))
    q:dspId="" ""
    s lockFlag=""
    s recLocId=$p(^DHCOEDISQTY(dspId),"^",24)
    s dspSub=0
    f  s dspSub=$o(^DHCOEDISQTY(dspId,"I",dspSub)) q:(dspSub="")||(lockFlag="Y")  d
    .s incId=$p(^DHCOEDISQTY(dspId,"I",dspSub),"^",5)
    .q:+incId=0
    .s incCh=$o(^INCI("IL_LOC",recLocId,incId,""))
    .q:incCh=""
    .s dhcIncil=$o(^DHCINCIL(0,"INCIL",incId_"||"_incCh,""),-1)
    .s lockFlag=$s(dhcIncil'="":$p($g(^DHCINCIL(dhcIncil)),"^",lockNode),1:"N")
    q:lockFlag="Y" 1
    q ""
}

/// description: 获取不需要领药审核的医嘱子类
/// input:       RecLocId(接收科室Id)
/// return:      医嘱子类1Id^医嘱子类2Id^医嘱子类3Id...
/// w ##class(web.DHCSTINTERFACE).GetPassAuditCats(311)
ClassMethod GetPassAuditCats(RecLocId)
{
    q:RecLocId="" ""
    s arcCatStr=""
    s arcCatId=0
    f  s arcCatId=$o(^CF.PHA.IP.LOCARCCATi("LOCARCCAT",RecLocId,arcCatId)) q:arcCatId=""  d
    .s placId=0
    .f  s placId=$o(^CF.PHA.IP.LOCARCCATi("LOCARCCAT",RecLocId,arcCatId,placId)) q:placId=""  d
    ..s placData=$g(^CF.PHA.IP.LOCARCCAT(placId))
    ..s passAudit=$p(placData,"^",3)
    ..q:passAudit'="Y"
    ..s arcCatStr=$s(arcCatStr="":arcCatId,1:arcCatStr_"^"_arcCatId)
    q arcCatStr
}

/// description: (给护士站:需关注医嘱)判断医嘱是否走医生科室发药
/// input:       Oeori(医嘱Id)
/// return:      Y(是)
/// w ##class(web.DHCSTINTERFACE).IfDocLocDisp("1033||1")
ClassMethod IfDocLocDisp(Oeori)
{
    s ordId=+$p(Oeori,"||",1)
    s ordItm=+$p(Oeori,"||",2)
    q:(ordId=0)||(ordItm=0) ""
    s recLocId=$p($g(^OEORD(ordId,"I",ordItm,3)),"^",6) 
    s docLocId=$p($g(^OEORD(ordId,"I",ordItm,7)),"^",2) 
    q:(recLocId="")||(docLocId="") ""
    q:$d(^CTLOC(recLocId,"LINK",0,"Loc",docLocId)) "Y"
    q ""
}

/// description: (给护士站:需关注医嘱)为护理组提供是否需要领药审核的接口,仅取配置
/// input:       Oeori(医嘱Id)
/// return:      Y(需要)
/// w ##class(web.DHCSTINTERFACE).IfNeedNurAudit("197||5")
ClassMethod IfNeedNurAudit(Oeore)
{
    s flag=""
    q:+Oeore=0 ""
    s dspId=$o(^DHCOEDISQTY(0,"OEORE",Oeore,""))
    q:dspId="" ""
    s recLocId=$p(^DHCOEDISQTY(dspId),"^",24)
    q:recLocId="" ""
    s phLocId=$o(^DHCPL(0,"Loc",recLocId,""))
    q:phLocId="" ""
    s priorCode=$p(##class(web.DHCSTCOMMONORDER).OeoriPriority($p(Oeore,"||",1,2)),"^",2)
    q:$ZCVT(priorCode,"U")["OM" ""
    i priorCode="OUT" d
    .s HospId=$p(^CTLOC(recLocId),"^",22)
    .s params="^"_recLocId_"^^"_HospId
    .s outAuditFlag=##class(web.DHCST.Common.AppCommon).GetAppPropValue("DHCSTORDDISP","OUTAUDITFLAG",params)
    .i outAuditFlag'="Y" s flag=""
    .e  s flag="Y"
    q:priorCode="OUT" flag // 出院带药单独"
    s auditNeed=$p(^DHCPL(phLocId),"^",14)
    q:(auditNeed'="Y") ""
    s passAudit=""
    i $d(^CF.PHA.IP.LOCARCCATi("LOCARCCAT",recLocId)) d  
    .s arcItmId=$p(^OEORD(+Oeore,"I",+$p(Oeore,"||",2),1),"^",2)
    .s arcItmCatId=$p(^ARCIM(+arcItmId,1,1),"^",10)
    .q:arcItmCatId=""
    .s plac=$o(^CF.PHA.IP.LOCARCCATi("LOCARCCAT",recLocId,arcItmCatId,""))
    .q:plac=""
    .s passAudit=$p(^CF.PHA.IP.LOCARCCAT(plac),"^",3)
    q:passAudit="Y" ""  // 不需要领药审核的子类
    q auditNeed
}

/// Descript:  查询皮试关联医嘱项接口函数
/// Creater:    wwl
/// CreateDate: 2016-03-07
/// Table:ARC_SKTINFO
/// Input:医嘱项id
/// Output:
/// Return：关联皮试医嘱信息(医嘱项ID^医嘱项代码^医嘱项名称，多个用/分隔)
///    .i SkinStr=""  d
///   ..s SkinStr=Skindr_"^"_SkArccode_"^"_SkArcdesc
///    .e  d
///    ..s SkinStr=SkinStr_"/"_Skindr_"^"_SkArccode_"^"_SkArcdesc
ClassMethod GetSktInfoFor(Arcimdr) As %Library.String
{
    
    q:Arcimdr="" ""
    s SkinStr=""
    s count=0
    s SkArc=0
    f  s SkArc=$o(^ARCSKTi("SKINTEST",Arcimdr,SkArc))  q:SkArc=""  d
    .s Skindr=""
    .f  s Skindr=$o(^ARCSKTi("SKINTEST",Arcimdr,SkArc,Skindr)) q:Skindr=""  d
    ..s SkArcdesc=$p(^ARCIM(+SkArc,$p(SkArc,"||",2),1),"^",2)
    ..s SkArccode=$p(^ARCIM(+SkArc,$p(SkArc,"||",2),1),"^",1)
    ..I SkinStr="" D
    ...s SkinStr=SkArc_"^"_SkArccode_"^"_SkArcdesc
    ..E  D
    ...s SkinStr=SkinStr_"/"_SkArc_"^"_SkArccode_"^"_SkArcdesc

    q SkinStr
}

/// Description: 门诊缴费为批次价且打包表无批次数据时调用
/// CreateDate:  2019-08-13
/// Creator:     yunhaibao
/// Return:      $p(insRet,"^",1)=1:成功,$p(insRet,"^",1)<=0:失败
/// Caller:      计费组
/// yunhaibao 20190823,不用此方法,先留着
/// w ##class(web.DHCSTINTERFACE).RebuildDspBatchForOut(医嘱Id)
ClassMethod RebuildDspBatchForOut(Oeori)
{
    s errCode=""
    s dspId=$o(^DHCOEDISQTY(0,"OEORI",Oeori,""))
    q:dspId="" 1
    s recLocId=$p($g(^DHCOEDISQTY(dspId)),"^",24)
    s hasFlag=""
    // 处理原在途
    s dspSub=0
    f  s dspSub=$o(^DHCOEDISQTY(dspId,"I",dspSub)) q:dspSub=""  d
    .s DHCOEDISQTYI=$g(^DHCOEDISQTY(dspId,"I",dspSub))
    .s inclb=$p(DHCOEDISQTYI,"^",1)
    .s qty=$p(DHCOEDISQTYI,"^",2)
    .s inci=$p(DHCOEDISQTYI,"^",5)
    .// 先跑通,此处待修正,不影响联调
    .i inclb'="" d ##class(web.DHCST01).UpdInclbResQty(inclb,-qty)
    .e  i inci'=""  d ##class(web.DHCST01).UPDINVRESQTY(inci,recLocId,-qty) 
    .s hasFlag=1
    i hasFlag'="" d // 删表
    .&SQL(DELETE FROM DHC_OEDispBatch WHERE DSPB_DSP_ParRef=:dspId AND DSPB_Childsub>0)
    .i SQLCODE'=0 s errCode="-1^删除DHC_OEDispBatch失败,SQLCODE:"_SQLCODE
    q:errCode'="" errCode
    // 重新插表
    s insRet=##Class(web.DHCST01).InsDspBatchForOut(Oeori)
    q:insRet'=1 "-1^库存不足"
    q 0
}

///     Description: 获取医嘱iMedical应急方案医嘱导入标识
///     Creator      zhaozhiduan
///     CreateDate:  2021-11-12
///     Input：       医嘱项ID
///     Output：  Y/N
///     Debug:       w ##class(web.DHCSTINTERFACE).IsImpDataByContingences("249405||1")
ClassMethod IsImpDataByContingences(ordItmId)
{
    q:ordItmId="" "N"
    s ordId=$p(ordItmId,"||",1)
    s itmId=$p(ordItmId,"||",2)
    s cesFlag=$p($g(^OEORD(ordId,"I",itmId,"DHC")),"^",62)
    s cesFlag=$s(cesFlag="Y":"Y",1:"N")
    q cesFlag
}

}
