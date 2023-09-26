Import SQLUser

/// creator:        chenxi
/// creatdate:      2014-09-28
/// description:    住院病人费用核查程序
Class web.DHCIPBillCheckAdmFee Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Parameter BUILD = 1;

/// creator:        chenxi
/// creatdate:      2014-10-09
/// description:    撤销住院费用审核
ClassMethod InsertYCFeeCheckConfig()
{
   ///w ##class(web.DHCIPBillCheckAdmFee).InsertYCFeeCheckConfig()
   
   s ^DHCCAbFeeConfig("YCFeeCheck",1) = "web.DHCCAbFeeCheck^GetCheckFeeGE^床位费收费天数与实际住院天数是否相符^1" 
   s ^DHCCAbFeeConfig("YCFeeCheck",2) = "web.DHCCAbFeeCheck^GetCheckFeeGE^级别护理收费天数与实际住院天数是否相符^1" 
   s ^DHCCAbFeeConfig("YCFeeCheck",3) = "web.DHCCAbFeeCheck^GetCheckStop^非本病区身份违规停本病区开立的医嘱(不包含某些项目例如检查)^0" 
   s ^DHCCAbFeeConfig("YCFeeCheck",4) = "web.DHCCAbFeeCheck^GetCheckFeeLisRis^检验检查已下医嘱已收费但相关医技科室未执行^1" 
   s ^DHCCAbFeeConfig("YCFeeCheck",5) = "web.DHCCAbFeeCheck^GetCheckFeeGE^住院诊查收费天数与实际住院天数是否相符^1" 
   
   s ^DHCCAbFeeConfig("YCFeeCheck",6) = "web.DHCCAbFeeCheck^GetCheckFeeGE^伙食费收费天数与实际包伙天数是否相符^1" 
   s ^DHCCAbFeeConfig("YCFeeCheck",7) = "web.DHCCAbFeeCheck^GetCheckFeeGE^空调费收费天数与实际空调开放天数是否相符|2013-11-15|2014-3-1^1" 
   s ^DHCCAbFeeConfig("YCFeeCheck",8) = "web.DHCCAbFeeCheck^GetCheckDrugFee^实际发药数量与收费是否相符(例如静配的按频次发药计费)^1" 
   s ^DHCCAbFeeConfig("YCFeeCheck",9) = "web.DHCCAbFeeCheck^GetCheckFeeOP^已做手术申请但是没有手术室计费^1" 
   s ^DHCCAbFeeConfig("YCFeeCheck",10) = "web.DHCCAbFeeCheck^GetCheckFeeExec^需计费医嘱未停止未计费(所有收费医嘱都要配置上)^1" 
   s ^DHCCAbFeeConfig("YCFeeCheck",11) = "web.DHCCAbFeeCheck^GetCheckFeeOPAS^已做手术申请但是没有麻醉科计费^1" 
   s ^DHCCAbFeeConfig("YCFeeCheck",12) = "web.DHCCAbFeeCheck^GetCheckIDCard^患者出院前需要补入身份证号^1"
   s ^DHCCAbFeeConfig("YCFeeCheck",13) = "web.DHCCAbFeeCheck^GetOrderExecErr^7.0后版本医嘱没有执行记录^1" 
   s ^DHCCAbFeeConfig("YCFeeCheck",14) = "web.DHCCAbFeeCheck^GetOrderErr^查找数据不全的医嘱^1"
   s ^DHCCAbFeeConfig("YCFeeCheck",15) = "web.DHCCAbFeeCheck^GetOrderBillNum^医嘱账单数量小于0的医嘱^1"
   q 0
}

/// creator:        chenxi
/// creatdate:      2014-09-28
/// description:    住院病人错误数据查询
Query LookUpAbnormalFee(EpisodeID As %String, sureflag As %String, PAPERNo As %String, PAPERName As %String, BedCode As %String, InBedDate As %String, OutDate As %String, PatInDays As %String, WardDesc As %String, PAPERDr As %String, AbnormalDesc As %String, AbnormalDr As %String) As %Query(ROWSPEC = "TabnormalDesc:%String,TMemDesc:%String,TSureStatus:%String,TAbnormalDr:%String,TSureUser:%String,TSureTime:%String,TAdm:%String,TMemSure:%String,TOrderDesc:%String,TStDate:%String,TOrderDoctor:%String,TOrderStatus:%String,TOrdCatDesc:%String,TOrderQty:%String,TOrderPrice:%String,TOrderAmt:%String,TDrugQty:%String,TRecLoc:%String,TOrderRowid:%String,TPBORowid:%String,TOrderExecRowid:%String,TSelect:%String,TStopDate:%String,TStopUser:%String,TEndDate:%String,TCheckFlag:%String,TCancelCheckUser:%String,TCancelCheckDate:%String,TOrdEpisodeId:%String")
{
}

ClassMethod LookUpAbnormalFeeExecute(ByRef qHandle As %Binary, EpisodeID As %String, sureflag As %String, PAPERNo As %String, PAPERName As %String, BedCode As %String, InBedDate As %String, OutDate As %String, PatInDays As %String, WardDesc As %String, PAPERDr As %String, AbnormalDesc As %String, AbnormalDr As %String) As %Status
{
 	s repid=$i(^CacheTemp)
 	s ind=1
 	set ^TMPZYW("LookUpAbnormal")=$g(EpisodeID)_","_$g(sureflag)_","_$g(PAPERNo)_","_$g(PAPERName)_","_$g(BedCode)_","_$g(InBedDate)_","_$g(OutDate)_","_$g(PatInDays)_","_$g(WardDesc)_","_$g(PAPERDr)_","_$g(AbnormalDesc)_","_$g(AbnormalDr)
 	// d ##class(%ResultSet).RunQuery("web.DHCIPBillCheckAdmFee","LookUpAbnormalFee",1067, "", "0000000556", "test101", "0901床", 64383, 64400, 17, "产科护理单元", 556, "")
	s InBedDate=##class(websys.Conversions).DateHtmlToLogical(InBedDate)
	s OutDate=##class(websys.Conversions).DateHtmlToLogical(OutDate)
	s VersionFlag="New"
	i EpisodeID="" s qHandle=$lb(0,repid,0) q $$$OK
	i InBedDate="" s qHandle=$lb(0,repid,0) q $$$OK
	i OutDate="" s qHandle=$lb(0,repid,0) q $$$OK
	
	s OEOrdDr=$o(^OEORD(0,"Adm",EpisodeID,""))
	i OEOrdDr="" s qHandle=$lb(0,repid,0) q $$$OK
	///s InBedDate1="",OutDate1=""
    i AbnormalDesc=""  d 
    .s AbnormalDr="0"
    
    i sureflag="on" s sureflag=1
    e  s sureflag=0
    		
	///i InBedDate1="" s qHandle=$lb(0,repid,0) q $$$OK
	///i OutDate1="" s qHandle=$lb(0,repid,0) q $$$OK
	s Tind=0
	k ^TMP("DHCIPBill","YCFeeCheck",EpisodeID,$j)
	k ^TMP("DHCIPBill","YCFeeCheckAdmDate",EpisodeID,$j)
	k ^TMP("DHCIPBill","AlreadyPBDate",EpisodeID,$j)
	k ^TMP("DHCIPBill","OEORDErr",EpisodeID,$j)
	k ^TMP("DHCIPBill","YCFeeCheckNDate",EpisodeID,$j)
	
	
	
	s Conf=""
	s Conf=$o(^DHCTarC("CF",Conf))
	s DefaultCP=$p(^DHCTarC("CF",Conf),"^",9)
	i DefaultCP="" s DefaultCP="OD"
	s PhOutFlag=##class(web.UDHCJFBILL).GetPhOutFlag()
	
	//modfiy 2014-11-04 婴儿和母亲一个账单的核查
    s Conf=$O(^DHCTarC("CF",""))
    s BabyFlag=$p(^DHCTarC("CF",Conf),"^",5)
    
    i BabyFlag="Y"  d
    .s BabyAdmRowid="0"
    .f  s BabyAdmRowid=$o(^PAADMi("Mother",EpisodeID,BabyAdmRowid))  q:(BabyAdmRowid="")  d
    ..k ^TMP("DHCIPBill","YCFeeCheckAdmDate",BabyAdmRowid,$j)
    ..k ^TMP("DHCIPBill","BabyAdmInOutDate",BabyAdmRowid,$j)
	
	///modify 2014-10-10 判断病人是否做过手术
	s ssflag=0,ssordflag=0,opdescs=""
	s op="" f  s op=$o(^DHCANOPArrange(0,"Adm",EpisodeID,op)) q:op=""  d
	.s opstatus=$p(^DHCANOPArrange(op),"^",27)
	.q:(opstatus="A")!(opstatus="D")!(opstatus="N")
	.s arrdate=$p(^DHCANOPArrange(op),"^",7)
	.s arrtime=$p(^DHCANOPArrange(op),"^",8)
	.s arrusr=$p(^DHCANOPArrange(op),"^",9)
	.q:(arrdate="")!(arrusr="")
	.s ssflag=1
	.s arrdate=$zd(arrdate,3)
	.s anaId=$P($G(^DHCANOPArrange(op)),"^",2)
	.s anaSub=$P(anaId,"||",2)
	.s anaopSub="" f  s anaopSub=$O(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub)) q:(anaopSub="")||(+anaopSub=0)  d
	..s opDr=$P($G(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub)),"^",6)
	..i opDr'=""  s opdesc=$P($G(^ORC("OPER",operDr)),"^",2)
	..e  s opdesc=""
	..i opdescs="" s opdescs=arrdate_"|"_opdesc
	..e  s opdescs=opdescs_"|"_arrdate_"|"_opdesc
	//
	//mdofify 2015-03-02 增加判断中途结算按指定金额结算时会有负数量医嘱
	s AllowNegativeArcim=$g(^DHCINTBILLARC("ARC"))
	s nusenode=""
	s node=""
	f  s node=$o(^DHCCAbFeeConfig("YCFeeCheck",node)) q:node=""  d
	.s espression=$g(^DHCCAbFeeConfig("YCFeeCheck",node))
	.s useflag=$p(espression,"^",4)
	.i useflag=0 s nusenode=nusenode_"^"_node_"^"
	.q:useflag=0   //停用
	.s NormalDesc=$p(espression,"^",3)
	.f PrtDate=InBedDate:1:OutDate  d
	..i (node=1)!(node=2)!(node=5)!(node=6)  d 
	...s ^TMP("DHCIPBill","YCFeeCheckAdmDate",EpisodeID,$j,node,PrtDate)=""
	.i node=7   d
	..s ktfstart=$p(NormalDesc,"|",2)
    ..s ktfend=$p(NormalDesc,"|",3)
    ..s ktfstart=$zdh(ktfstart,3)
    ..s ktfend=$zdh(ktfend,3)  
    ..f PrtDate=ktfstart:1:ktfend  d
    ...q:(PrtDate>OutDate)
    ...q:(PrtDate<InBedDate)
    ...s ^TMP("DHCIPBill","YCFeeCheckAdmDate",EpisodeID,$j,node,PrtDate)=""
	.i ((node=9)!(node=11))  d
	..s ^TMP("DHCIPBill","YCFeeCheck",EpisodeID,$j,node)=""	
	.i BabyFlag="Y"  d
    ..s BabyAdmRowid="0"
    ..f  s BabyAdmRowid=$o(^PAADMi("Mother",EpisodeID,BabyAdmRowid))  q:(BabyAdmRowid="")  d
    ...s Babyadmbedinfo=..GetAdmBedInfo(BabyAdmRowid)
    ...s Babyadmdate=$p(Babyadmbedinfo,"^",10)
    ...s Babyoutdate=$p(Babyadmbedinfo,"^",11)
    ...i $f(Babyadmdate,"/")'=0  d
    ....s Babyadmdate=$zdh(Babyadmdate,4)
    ...i $f(Babyadmdate,"-")'=0  d
    ....s Babyadmdate=$zdh(Babyadmdate,3)
    ...i $f(Babyoutdate,"/")'=0  d
    ....s Babyoutdate=$zdh(Babyoutdate,4)
    ...i $f(Babyoutdate,"-")'=0  d
    ....s Babyoutdate=$zdh(Babyoutdate,3)
    ...i Babyoutdate=""  s Babyoutdate=+$h
    ...i (Babyadmdate'="")&(Babyoutdate'="")  d
    ....s ^TMP("DHCIPBill","BabyAdmInOutDate",BabyAdmRowid,$j)=Babyadmdate_"^"_Babyoutdate
    ....i (node=1)!(node=2)!(node=5)!(node=6)  d
    .....f PrtDate=Babyadmdate:1:Babyoutdate  d
	......s ^TMP("DHCIPBill","YCFeeCheckAdmDate",BabyAdmRowid,$j,node,PrtDate)=""	
	....i node=7   d
	.....s ktfstart=$p(NormalDesc,"|",2)
    .....s ktfend=$p(NormalDesc,"|",3)
    .....s ktfstart=$zdh(ktfstart,3)
    .....s ktfend=$zdh(ktfend,3)  
    .....f PrtDate=ktfstart:1:ktfend  d
    ......q:(PrtDate>Babyoutdate)
    ......q:(PrtDate<Babyadmdate)
    ......s ^TMP("DHCIPBill","YCFeeCheckAdmDate",BabyAdmRowid,$j,node,PrtDate)=""
	
	;; 
	s OEOriDr="0",PBNegativeNum=0
	f  s OEOriDr=$o(^OEORD(OEOrdDr,"I",OEOriDr))  q:(OEOriDr="")  d
	.q:($d(^OEORD(+OEOrdDr,"I",OEOriDr,1))=0)
	.s OEORIRowid=OEOrdDr_"||"_OEOriDr
	.s ArcimRowid=$p(^OEORD(OEOrdDr,"I",OEOriDr,1),"^",2)
	.q:(ArcimRowid="")
	.s ArcItmCatDr=$p($g(^ARCIM(+ArcimRowid,$p(ArcimRowid,"||",2),1)),"^",10) 
	.s node=14
	.i (ArcItmCatDr="")  d
	..s ^TMP("DHCIPBill","YCFeeCheck",EpisodeID,$j,node,"ItemCatNull",OEORIRowid)=""	
	.q:(ArcItmCatDr="")
	.s OecCatDr=$p(^ARC("IC",ArcItmCatDr),"^",8)
	.i OecCatDr=""  d
	..s ^TMP("DHCIPBill","YCFeeCheck",EpisodeID,$j,node,"OECCatNull",OEORIRowid)=""
    .q:(OecCatDr="")
    .s ItmStatDr=$p(^OEORD(OEOrdDr,"I",OEOriDr,1),"^",13)
    .i ItmStatDr=""  d
	..s ^TMP("DHCIPBill","YCFeeCheck",EpisodeID,$j,node,"OrdStatNull",OEORIRowid)=""
    .q:(ItmStatDr="")
	.s StatCode=$p(^OEC("OSTAT",ItmStatDr),"^",1)
	.s StDate=$p(^OEORD(OEOrdDr,"I",OEOriDr,1),"^",9)
	.s Prior="",PriorCode=""
    .s Prior=$p(^OEORD(OEOrdDr,"I",OEOriDr,1),"^",8) 
    .s OrdType=$p(^ARC("IC",ArcItmCatDr),"^",7)
    .s OEORIQty=$p(^OEORD(OEOrdDr,"I",OEOriDr,1),"^",18)   ////医嘱首日次数，首日次数为0不插入打包表和医嘱执行记录表 
    .s OEORIOEORIDr=""
	.s OEORIOEORIDr=$p($g(^OEORD(OEOrdDr,"I",OEOriDr,11)),"^",39)
	.s MOrdType="",MOrdQty="",MArcimDr="",MItemCatDr=""
	.i OEORIOEORIDr'=""  d
	..s MArcimDr=$p(^OEORD(+OEORIOEORIDr,"I",$p(OEORIOEORIDr,"||",2),1),"^",2)
	..s MItemCatDr=$p(^ARCIM(+MArcimDr,$p(MArcimDr,"||",2),1),"^",10) 
	..i MItemCatDr'=""  d
	...s MOrdType=$p(^ARC("IC",MItemCatDr),"^",7)
	...s MOrdQty=$p(^OEORD(+OEORIOEORIDr,"I",$p(OEORIOEORIDr,"||",2),1),"^",18)    
    .s PriorCode=""
	.i Prior'=""  d
	..s PriorCode=$p($g(^OECPR(+Prior)),"^",1)
	.q:(PriorCode["OM") 			; 
	.Set inci=$o(^INCI(0,"ARCIM_DR",+ArcimRowid,""))
	.s LinkFlag="N"
	.i (inci'="")&(OrdType="R")  d
	..s LinkFlag=##class(web.UDHCJFBILL).GetUserLocLinkRecLoc(OEORIRowid)
	.;add by zg 20150715
	.;PhOutFlag LinkFlag,PriorCode , DefaultCP ArcItmCatDr
	.s Condition=$o(^DHCTarC("BC",0,ArcItmCatDr,""))
	.i Condition'="" s CP=$p(^DHCTarC("BC",Condition),"^",2)
	.e  s CP=DefaultCP	
	.i VersionFlag'="New"  d 
	..///获取医嘱的计费数量 PBOQtySum
	..s PBRowid=0,PBOQtySum=0
	..f  s PBRowid=$o(^DHCPBi(0,"OEORI",OEORIRowid,PBRowid))  q:(PBRowid="")  d  
	...s PBODr="0"
	...f  s PBODr=$o(^DHCPBi(0,"OEORI",OEORIRowid,PBRowid,PBODr))  q:(PBODr="")  d
	....s PBOQty=$p(^DHCPB(PBRowid,"O",PBODr),"^",5)
	....s PBORefQty=$p(^DHCPB(PBRowid,"O",PBODr),"^",6)
	....s PBOQtySum=PBOQtySum+PBOQty+PBORefQty
	..///获取医嘱的实际发药数量 DspNum
	..s DspRowid="0",DspNum=0
	..f  s DspRowid=$o(^DHCOEDISQTY(0,"OEORI",OEORIRowid,DspRowid))  q:(DspRowid="")  d
	...s DSPStatus=$p(^DHCOEDISQTY(DspRowid),"^",7)
	...s DSPQty=$p(^DHCOEDISQTY(DspRowid),"^",11)
	...i DSPStatus="C"  d
	....s DspNum=DspNum+DSPQty
	...i DSPStatus="R"  d
	....s DspNum=DspNum-DSPQty
	../// end
	..s node=""
	..f  s node=$o(^DHCCAbFeeConfig("YCFeeCheck",node))  q:(node="")  d
	...s espression=$g(^DHCCAbFeeConfig("YCFeeCheck",node))
	...s useflag=$p(espression,"^",4)
	...q:(useflag=0)&(node'=10)&(node'=8)&(node'=13)&(node'=14)&(node'=15)  //这些规则 不允许被停用
	...s qflag="0"
	...i $d(^DHCCAbFeeConfig("Details",node,"OECCAT",OecCatDr))'=0  d
	....s qflag="1"
	...i $d(^DHCCAbFeeConfig("Details",node,"ARCIC",ArcItmCatDr))'=0  d
	....s qflag="1"
	...i $d(^DHCCAbFeeConfig("Details",node,"ARCIM",ArcimRowid))'=0  d
	....s qflag="1"	
	...i ((node=1)!(node=2)!(node=5)!(node=6)!(node=7))&(qflag="1")  d
	....s ^TMP("DHCIPBill","AlreadyPBDate",EpisodeID,$j,node,StDate)=""  
	...i (node=13)&(OEORENum=0)  d
	....s ^TMP("DHCIPBill","YCFeeCheck",EpisodeID,$j,node,"OEORENull",OEORIRowid)=""
	...i (node=4)&(StatCode="V")&(PBOQtySum>0)&(qflag="1")  d 
	....s ^TMP("DHCIPBill","YCFeeCheck",EpisodeID,$j,node,"OEAlreadyPBAndNExec",OEORIRowid)=StatCode_"^"_PBOQtySum_"^"_qflag
	...i (node=8)&(qflag="1")  d
	....i (PhOutFlag="N")&(PriorCode="OUT")  d
	.....i PBOQtySum=0  d
	......//s ^TMP("DHCIPBill","YCFeeCheck",EpisodeID,$j,node,"OEOutDrugNPB",OEORIRowid)=""
	....e  i LinkFlag="Y"  d	
	....e  d
	.....i PBOQtySum'=DspNum  d
	......s ^TMP("DHCIPBill","YCFeeCheck",EpisodeID,$j,node,"OEDrugErr",OEORIRowid)=PBOQtySum_"^"_DspNum
	...i (node=10)&(qflag="1")&(PBOQtySum=0)   d
	....i (StatCode="V")!(StatCode="E")  d
	.....i (OrdType="R")&(+OEORIQty=0)  d
	......;
	.....e  d 
	......s ^TMP("DHCIPBill","YCFeeCheck",EpisodeID,$j,10,"OENPBRowid",OEORIRowid)=""
	...i ((node=9)!(node=11))&(ssflag=1)&(qflag="1")  d
	....i (StatCode="V")!(StatCode="E")  d
	.....s ^TMP("DHCIPBill","YCFeeCheck",EpisodeID,$j,node,"OPAlreadyOE",OEORIRowid)=""
	...//mdofify 2015-03-02 增加判断中途结算按指定金额结算时会有负数量医嘱
	...s AllowNegativeNum=0
	...i ($g(AllowNegativeArcim)'="")  d
	....s AArcimRowid=$p(^OEORD(+OEORIRowid,"I",$p(OEORIRowid,"||",2),1),"^",2) 
	....i AllowNegativeArcim=AArcimRowid  d
	.....s AllowNegativeNum=AllowNegativeNum+1 
	...i (node=15)&(PBOQtySum<0)&(AllowNegativeNum=0)  d
	....s ^TMP("DHCIPBill","YCFeeCheck",EpisodeID,$j,node,"PBNegativeNum",OEORIRowid)=""    
    .; 以上为 非 New 版本的情况。 没有走执行记录。
    .e  d
    ..s OEOreDr="0",OEORENum=0,NFirstQty=0
    ..f  s OEOreDr=$o(^OEORD(OEOrdDr,"I",OEOriDr,"X",OEOreDr))  q:(OEOreDr="")  d
	...s OEORENum=OEORENum+1 	; 执行记录数量
    ...s OEORERowid=OEOrdDr_"||"_OEOriDr_"||"_OEOreDr     
    ...s OEStatDr=$p(^OEORD(OEOrdDr,"I",OEOriDr,"X",OEOreDr,"BILL"),"^",1)
    ...s OEStatCode=""
    ...i OEStatDr'=""  d 
    ....s OEStatCode=$p(^OEC("OSTAT",OEStatDr),"^",1)
    ...//获取医嘱的计费数量 PBOQtySum
	...s PBRowid=0,PBOQtySum=0,PBOTotSum=0.00
	...f  s PBRowid=$o(^DHCPB(0,"OEEXC",OEORERowid,PBRowid))  q:(PBRowid="")  d  
	....s PBODr="0"
	....f  s PBODr=$o(^DHCPB(0,"OEEXC",OEORERowid,PBRowid,PBODr))  q:(PBODr="")  d
	.....q:($d(^DHCPB(PBRowid,"O",PBODr))=0)
	.....s PBOQty=$p(^DHCPB(PBRowid,"O",PBODr),"^",5)
	.....s PBORefQty=$p(^DHCPB(PBRowid,"O",PBODr),"^",6)
	.....s PBOQtySum=PBOQtySum+PBOQty+PBORefQty
	.....s PBOTotamt=$p(^DHCPB(PBRowid,"O",PBODr),"^",8)
	.....s PBOTotSum=PBOTotSum+PBOTotamt	
	...//获取医嘱的实际发药数量 DspNum	
	...s DspRowid="0",DspNum=0
	...f  s DspRowid=$o(^DHCOEDISQTY(0,"OEORE",OEORERowid,DspRowid))  q:(DspRowid="")  d
	....s DSPStatus=$p(^DHCOEDISQTY(DspRowid),"^",7)
	....s DSPQty=$p(^DHCOEDISQTY(DspRowid),"^",11)
	....i DSPStatus="C"  d
	.....s DspNum=DspNum+DSPQty
	....i DSPStatus="R"  d
	.....s DspNum=DspNum-DSPQty
	...s node=""
	...f  s node=$o(^DHCCAbFeeConfig("YCFeeCheck",node))  q:(node="")  d
	....s espression=$g(^DHCCAbFeeConfig("YCFeeCheck",node))
	....s useflag=$p(espression,"^",4)
	....q:(useflag=0)&(node'=10)&(node'=8)&(node'=13)&(node'=14)&(node'=15)  // 这几个规则不允许被停用。[停用无效]
	....s qflag="0"
	....i $d(^DHCCAbFeeConfig("Details",node,"OECCAT",OecCatDr))'=0  d
	.....s qflag="1"
	....i $d(^DHCCAbFeeConfig("Details",node,"ARCIC",ArcItmCatDr))'=0  d
	.....s qflag="1"
	....i $d(^DHCCAbFeeConfig("Details",node,"ARCIM",ArcimRowid))'=0  d
	.....s qflag="1"	
	....s OEOREStDate=$p(^OEORD(OEOrdDr,"I",OEOriDr,"X",OEOreDr),"^",1)	
	....i ((node=1)!(node=2)!(node=5)!(node=6)!(node=7))&(qflag="1")  d
	.....s ^TMP("DHCIPBill","AlreadyPBDate",EpisodeID,$j,node,OEOREStDate)=""  	;收费天数与住院天数是否一致:存收费天数的global。
	....i (node=4)&(StatCode="V")&(PBOQtySum>0)&(qflag="1")  d 
	.....s ^TMP("DHCIPBill","YCFeeCheck",EpisodeID,$j,node,"OEAlreadyPBAndNExec",OEORERowid)=StatCode_"^"_PBOQtySum_"^"_qflag
	....i (PhOutFlag="N")&(PriorCode="OUT")  d
	.....s CP="OD"
	....i LinkFlag="Y"  d
	.....s CP="OD"
	....i ((CP="CR")&(OrdType="R")&(qflag="1")&(node=10)&((OEStatCode="V")!(OEStatCode="E"))) d
	.....s DispTCInfo=..GetTCDspNew(OEORERowid)  ;取未发放的药品的数量
	.....s DisPTCQty=$p(DispTCInfo,"^",1)
	.....i +DisPTCQty'=0 d
	......s ^TMP("DHCIPBill","YCFeeCheck",EpisodeID,$j,10,"OENPBRowid",OEORERowid)=""	
	....i ((CP="OD")&(OrdType="R")&(qflag=1)&(node=10)&((OEStatCode="V")!(OEStatCode="E"))) d
	.....s OEOrdRowID=OEOrdDr_"||"_OEOriDr
	.....s PBDrugErrStr=..GetODOrdDispNew(OEOrdRowID,OEORERowid)
	.....s PBDrugNum=$p(PBDrugErrStr,"^",2)
	.....s DSPdrugNum=$p(PBDrugErrStr,"^",1)   
	.....i PBDrugNum'=DSPdrugNum d
	......s ^TMP("DHCIPBill","YCFeeCheck",EpisodeID,$j,10,"OENPBRowid",OEORERowid)=""
	....i (node=8)&(qflag="1")  d
	.....i ((CP="CR")&(OrdType="R")) d
	......i PBOQtySum'=DspNum  d
	.......s ^TMP("DHCIPBill","YCFeeCheck",EpisodeID,$j,node,"OEDrugErr",OEORERowid)=PBOQtySum_"^"_DspNum
	....i ((CP="OD")&(OrdType="R")&(qflag=1)&(node=10)&(StatCode="V")!(StatCode="E")) d
	.....s DspNum=$p(^OEORD(+OEOrdDr,"I",OEOriDr,"X",OEOreDr),"^",5)
	.....i PBOQtySum'=DspNum  d
	......s ^TMP("DHCIPBill","YCFeeCheck",EpisodeID,$j,10,"OENPBRowid",OEORERowid)=PBOQtySum_"^"_DspNum
	....i (node=10)&(qflag="1")&(PBOQtySum=0)   d
	.....i (OEStatCode="V")!(OEStatCode="E")  d
	......s ^TMP("DHCIPBill","YCFeeCheck",EpisodeID,$j,10,"OENPBRowid",OEORERowid)=""  ;需计费医嘱未停止未计费
	....i ((node=9)!(node=11))&(ssflag=1)&(qflag="1")  d
	.....i (OEStatCode="V")!(OEStatCode="E")  d
	......s ^TMP("DHCIPBill","YCFeeCheck",EpisodeID,$j,node,"OPAlreadyOE",OEORERowid)=""
	....//mdofify 2015-03-02 增加判断中途结算按指定金额结算时会有负数量医嘱
	....s AllowNegativeNum=0
	....i ($g(AllowNegativeArcim)'="")  d
	.....s AArcimRowid=$p(^OEORD(+OEORERowid,"I",$p(OEORERowid,"||",2),1),"^",2) 
	.....i AllowNegativeArcim=AArcimRowid  d
	......s AllowNegativeNum=AllowNegativeNum+1
	....//2016-09-08 chenxi 药品批次价取价格时有可能取到负数价格,这里改为判断负数金额
	....//i (node=15)&(PBOQtySum<0)&(AllowNegativeNum=0)  d
	....i (node=15)&(PBOTotSum<0)&(AllowNegativeNum=0)  d
	.....s ^TMP("DHCIPBill","YCFeeCheck",EpisodeID,$j,node,"PBNegativeNum",OEORERowid)="" 
	....//2015-06-30 长期医嘱首日执行次数为 0 时 首日可以没有执行记录,子医嘱的首日执行次数根据主医嘱的取值
	....//i (OrdType="R")&(OEOREStDate'=StDate)&(OEORENum=1)&(+OEORIQty'=0)  d
	....i (PriorCode="S")!(PriorCode="OMST")  d
	.....i (OEOREStDate'=StDate)&(OEORENum=1)&(+OEORIQty'=0)&(OEORIOEORIDr="")  d
	......// OEORIOEORIDr:关联医嘱。没有关联医嘱,首日执行次数不为0 实际执行时间[OEOREStDate]和要求执行时间[StDate]不一致
	......s NFirstQty=NFirstQty+1 
	.....i (OEOREStDate'=StDate)&(OEORENum=1)&(+MOrdQty'=0)&(OEORIOEORIDr'="")  d
	......// 有关联医嘱,首日执行次数不为0 实际执行时间[OEOREStDate]和要求执行时间[StDate]不一致
	......s NFirstQty=NFirstQty+1	
	....e  d
	.....//非长期医嘱。要求执行时间和实际执行时间不一致。
	.....i (OEOREStDate'=StDate)&(OEORENum=1)  d
	......s NFirstQty=NFirstQty+1 
	..i (NFirstQty'=0)  d
	...//这里没有执行记录的医嘱在 CheckOrdAllowNExec 方法中已经处理,可以注释掉。LookUpAbnormalFee 方法中
	...//s ^TMP("DHCIPBill","YCFeeCheck",EpisodeID,$j,13,"OEORENull",OEORIRowid)=""
	..//2015-06-10 chenxi 判断一直是执行记录时，判断该医嘱是否为子医嘱，
	..//如果为子医嘱则判断主医嘱的执行记录是否停止,如果停止则该医嘱可以没有执行记录
	..s NExecFlag="Y"
	..s NExecFlag=..CheckOrdAllowNExec(OEORIRowid)
	..i NExecFlag'="Y"  d
	...s ^TMP("DHCIPBill","YCFeeCheck",EpisodeID,$j,13,"OEORENull",OEORIRowid)=""    
    
 	s BabyAdmStr=""
    i BabyFlag="Y"  d
    .s BabyAdmRowid="0"
    .f  s BabyAdmRowid=$o(^PAADMi("Mother",EpisodeID,BabyAdmRowid))  q:(BabyAdmRowid="")  d
    ..i BabyAdmStr="" s BabyAdmStr=BabyAdmRowid
    ..e  s BabyAdmStr=BabyAdmStr_"^"_BabyAdmRowid
    ..s BabyOEOrdDr="0"
    ..f  s BabyOEOrdDr=$o(^OEORD(0,"Adm",BabyAdmRowid,BabyOEOrdDr))  q:(BabyOEOrdDr="")  d 
    ...s OEOriDr="0",PBNegativeNum=0
	...f  s OEOriDr=$o(^OEORD(BabyOEOrdDr,"I",OEOriDr))  q:(OEOriDr="")  d
	....q:($d(^OEORD(+BabyOEOrdDr,"I",OEOriDr,1))=0)
	....s OEORIRowid=BabyOEOrdDr_"||"_OEOriDr
	....s ArcimRowid=$p(^OEORD(BabyOEOrdDr,"I",OEOriDr,1),"^",2)
	....q:(ArcimRowid="")
	....s ArcItmCatDr=$p(^ARCIM(+ArcimRowid,$p(ArcimRowid,"||",2),1),"^",10) 
	....s node=14
	....i ArcItmCatDr=""  d
	.....s ^TMP("DHCIPBill","YCFeeCheck",EpisodeID,$j,node,"ItemCatNull",OEORIRowid)=""
	....q:(ArcItmCatDr="")
	....s OecCatDr=$p(^ARC("IC",ArcItmCatDr),"^",8)
	....i OecCatDr=""  d
	.....s ^TMP("DHCIPBill","YCFeeCheck",EpisodeID,$j,node,"OECCatNull",OEORIRowid)=""
    ....q:(OecCatDr="")
    ....s ItmStatDr=$p(^OEORD(BabyOEOrdDr,"I",OEOriDr,1),"^",13)
    ....i ItmStatDr=""  d
	.....s ^TMP("DHCIPBill","YCFeeCheck",EpisodeID,$j,node,"OrdStatNull",OEORIRowid)=""
    ....q:(ItmStatDr="")
	....s StatCode=$p(^OEC("OSTAT",ItmStatDr),"^",1)
	....s StDate=$p(^OEORD(BabyOEOrdDr,"I",OEOriDr,1),"^",9)
	....s Prior="",PriorCode=""
    ....s Prior=$p(^OEORD(BabyOEOrdDr,"I",OEOriDr,1),"^",8) 
    ....s OrdType=$p(^ARC("IC",ArcItmCatDr),"^",7)
    ....s OEORIQty=$p(^OEORD(BabyOEOrdDr,"I",OEOriDr,1),"^",18)   ////医嘱首日次数，首日次数为0不插入打包表和医嘱执行记录表 
    ....q:(Prior["OM") 
    ....s PriorCode=""
	....i Prior'=""  d
	.....s PriorCode=$p($g(^OECPR(+Prior)),"^",1)
	....s LinkFlag="N"
	....i OrdType="R"  d
	.....s LinkFlag=##class(web.UDHCJFBILL).GetUserLocLinkRecLoc(OEORIRowid)	
	....i VersionFlag'="New"  d 
	.....//获取医嘱的计费数量
	.....s PBRowid=0,PBOQtySum=0
	.....f  s PBRowid=$o(^DHCPBi(0,"OEORI",OEORIRowid,PBRowid))  q:(PBRowid="")  d  
	......s PBODr="0"
	......f  s PBODr=$o(^DHCPBi(0,"OEORI",OEORIRowid,PBRowid,PBODr))  q:(PBODr="")  d
	.......s PBOQty=$p(^DHCPB(PBRowid,"O",PBODr),"^",5)
	.......s PBORefQty=$p(^DHCPB(PBRowid,"O",PBODr),"^",6)
	.......s PBOQtySum=PBOQtySum+PBOQty+PBORefQty
	.....//获取医嘱的实际发药数量
	.....s DspRowid="0",DspNum=0
	.....f  s DspRowid=$o(^DHCOEDISQTY(0,"OEORI",OEORIRowid,DspRowid))  q:(DspRowid="")  d
	......s DSPStatus=$p(^DHCOEDISQTY(DspRowid),"^",7)
	......s DSPQty=$p(^DHCOEDISQTY(DspRowid),"^",11)
	......i DSPStatus="C"  d
	.......s DspNum=DspNum+DSPQty
	......i DSPStatus="R"  d
	.......s DspNum=DspNum-DSPQty
	.....s node=""
	.....f  s node=$o(^DHCCAbFeeConfig("YCFeeCheck",node))  q:(node="")  d
	......s espression=$g(^DHCCAbFeeConfig("YCFeeCheck",node))
	......s useflag=$p(espression,"^",4)
	......q:(useflag=0)&(node'=10)&(node'=8)&(node'=13)&(node'=14)&(node'=15)  //停用 
	......s qflag="0"
	......i $d(^DHCCAbFeeConfig("Details",node,"OECCAT",OecCatDr))'=0  d
	.......s qflag="1"
	......i $d(^DHCCAbFeeConfig("Details",node,"ARCIC",ArcItmCatDr))'=0  d
	.......s qflag="1"
	......i $d(^DHCCAbFeeConfig("Details",node,"ARCIM",ArcimRowid))'=0  d
	.......s qflag="1"	
	......i ((node=1)!(node=2)!(node=5)!(node=6)!(node=7))&(qflag="1")  d
	.......s ^TMP("DHCIPBill","AlreadyPBDate",EpisodeID,$j,node,StDate)=""  
	......i (node=13)&(OEORENum=0)  d
	.......s ^TMP("DHCIPBill","YCFeeCheck",EpisodeID,$j,node,"OEORENull",OEORIRowid)=""
	......i (node=4)&(StatCode="V")&(PBOQtySum>0)&(qflag="1")  d 
	.......s ^TMP("DHCIPBill","YCFeeCheck",EpisodeID,$j,node,"OEAlreadyPBAndNExec",OEORIRowid)=StatCode_"^"_PBOQtySum_"^"_qflag
	......i (PhOutFlag="N")&(PriorCode="OUT")  d
	.......s CP="OD"
	......i LinkFlag="Y"  d
	.......s CP="OD"
	......i ((CP="CR")&(OrdType="R")&(qflag=1)&(node=10)) d
	.......s DispTCInfo=..GetTCDspNew(OEORERowid)  ;取未发放的药品的数量
	.......s DisPTCQty=$p(DispTCInfo,"^",1)
	.......i +DisPTCQty'=0 d
	........s ^TMP("DHCIPBill","YCFeeCheck",EpisodeID,$j,10,"OENPBRowid",OEORERowid)=""	
	......i ((CP="OD")&(OrdType="R")&(qflag=1)&(node=10)) d
	.......s OEOrdRowID=OEOrdDr_"||"_OEOriDr
	.......s PBDrugErrStr=..GetODOrdDispNew(OEOrdRowID,OEORERowid)
	.......s PBDrugNum=$p(PBDrugErrStr,"^",2)
	.......s DSPdrugNum=$p(PBDrugErrStr,"^",1)   
	.......i PBDrugNum'=DSPdrugNum d
	........s ^TMP("DHCIPBill","YCFeeCheck",EpisodeID,$j,10,"OENPBRowid",OEORERowid)=""	
	......i (node=8)&(qflag="1")  d
	.......i (PhOutFlag="N")&(PriorCode="OUT")  d
	........i PBOQtySum=0  d
	.........//s ^TMP("DHCIPBill","YCFeeCheck",EpisodeID,$j,node,"OEOutDrugNPB",OEORIRowid)=""
	.......e  i LinkFlag="Y"  d	
	.......e  d
	........i PBOQtySum'=DspNum  d
	.........s ^TMP("DHCIPBill","YCFeeCheck",EpisodeID,$j,node,"OEDrugErr",OEORIRowid)=PBOQtySum_"^"_DspNum
	......i (node=10)&(qflag="1")&(PBOQtySum=0)   d
	.......i (StatCode="V")!(StatCode="E")  d
	........;i (OrdType="R")&(OEORIQty=0)  d
	........;e  d 
	........s ^TMP("DHCIPBill","YCFeeCheck",EpisodeID,$j,10,"OENPBRowid",OEORIRowid)=""     
	......i ((node=9)!(node=11))&(ssflag=1)&(qflag="1")  d
	.......i (StatCode="V")!(StatCode="E")  d
	........s ^TMP("DHCIPBill","YCFeeCheck",EpisodeID,$j,node,"OPAlreadyOE",OEORIRowid)=""	
	......//mdofify 2015-03-02 增加判断中途结算按指定金额结算时会有负数量医嘱
	......s AllowNegativeNum=0
	......i ($g(AllowNegativeArcim)'="")  d
	.......s AArcimRowid=$p(^OEORD(+OEORIRowid,"I",$p(OEORIRowid,"||",2),1),"^",2) 
	.......i AllowNegativeArcim=AArcimRowid  d
	........s AllowNegativeNum=AllowNegativeNum+1 
	......i (node=15)&(PBOQtySum<0)&(AllowNegativeNum=0)  d	
	.......s ^TMP("DHCIPBill","YCFeeCheck",EpisodeID,$j,node,"PBNegativeNum",OEORIRowid)=""    
    ....e  d
    .....; New版本的 
    .....s OEOreDr="0",OEORENum=0,NFirstQty=0
    .....f  s OEOreDr=$o(^OEORD(BabyOEOrdDr,"I",OEOriDr,"X",OEOreDr))  q:(OEOreDr="")  d
	......s OEORENum=OEORENum+1 
    ......s OEORERowid=BabyOEOrdDr_"||"_OEOriDr_"||"_OEOreDr 
    ......s OEStatDr=$p(^OEORD(BabyOEOrdDr,"I",OEOriDr,"X",OEOreDr,"BILL"),"^",1)
    ......s OEStatCode=""
    ......i OEStatDr'=""  d 
    .......s OEStatCode=$p(^OEC("OSTAT",OEStatDr),"^",1)
    ......//获取医嘱的计费数量
	......s PBRowid=0,PBOQtySum=0,PBOTotSum=0.00
	......f  s PBRowid=$o(^DHCPB(0,"OEEXC",OEORERowid,PBRowid))  q:(PBRowid="")  d  
	.......s PBODr="0"
	.......f  s PBODr=$o(^DHCPB(0,"OEEXC",OEORERowid,PBRowid,PBODr))  q:(PBODr="")  d
	........q:($d(^DHCPB(PBRowid,"O",PBODr))=0)
	........s PBOQty=$p(^DHCPB(PBRowid,"O",PBODr),"^",5)
	........s PBORefQty=$p(^DHCPB(PBRowid,"O",PBODr),"^",6)
	........s PBOQtySum=PBOQtySum+PBOQty+PBORefQty	
	........s PBOTotamt=$p(^DHCPB(PBRowid,"O",PBODr),"^",8)
	........s PBOTotSum=PBOTotSum+PBOTotamt
	......//获取医嘱的实际发药数量
	......s DspRowid="0",DspNum=0
	......f  s DspRowid=$o(^DHCOEDISQTY(0,"OEORE",OEORERowid,DspRowid))  q:(DspRowid="")  d
	.......s DSPStatus=$p(^DHCOEDISQTY(DspRowid),"^",7)
	.......s DSPQty=$p(^DHCOEDISQTY(DspRowid),"^",11)
	.......i DSPStatus="C"  d
	........s DspNum=DspNum+DSPQty
	.......i DSPStatus="R"  d
	........s DspNum=DspNum-DSPQty
	......s node=""
	......f  s node=$o(^DHCCAbFeeConfig("YCFeeCheck",node))  q:(node="")  d
	.......s espression=$g(^DHCCAbFeeConfig("YCFeeCheck",node))
	.......s useflag=$p(espression,"^",4)
	.......//q:(useflag=0)&(node'=10)&(node'=8)&(node'=13)  // 
	.......q:(useflag=0)&(node'=10)&(node'=8)&(node'=13)&(node'=14)&(node'=15)  // 这几个规则不允许被停用
	.......s qflag="0"
	.......i $d(^DHCCAbFeeConfig("Details",node,"OECCAT",OecCatDr))'=0  d
	........s qflag="1"
	.......i $d(^DHCCAbFeeConfig("Details",node,"ARCIC",ArcItmCatDr))'=0  d
	........s qflag="1"
	.......i $d(^DHCCAbFeeConfig("Details",node,"ARCIM",ArcimRowid))'=0  d
	........s qflag="1"	
	.......s OEOREStDate=$p(^OEORD(BabyOEOrdDr,"I",OEOriDr,"X",OEOreDr),"^",1)	
	.......i ((node=1)!(node=2)!(node=5)!(node=6)!(node=7))&(qflag="1")  d
	........s ^TMP("DHCIPBill","AlreadyPBDate",BabyAdmRowid,$j,node,OEOREStDate)=""  
	.......i (node=4)&(StatCode="V")&(PBOQtySum>0)&(qflag="1")  d 
	........s ^TMP("DHCIPBill","YCFeeCheck",EpisodeID,$j,node,"OEAlreadyPBAndNExec",OEORERowid)=StatCode_"^"_PBOQtySum_"^"_qflag
	.......i (PhOutFlag="N")&(PriorCode="OUT")  d
	........s CP="OD"
	.......i LinkFlag="Y"  d
	........s CP="OD"	
	.......i ((CP="CR")&(OrdType="R")&(qflag="1")&(node=10)&((OEStatCode="V")!(OEStatCode="E"))) d
	........s DispTCInfo=..GetTCDspNew(OEORERowid)  ;取未发放的药品的数量
	........s DisPTCQty=$p(DispTCInfo,"^",1)
	........i +DisPTCQty'=0 d
	.........s ^TMP("DHCIPBill","YCFeeCheck",EpisodeID,$j,10,"OENPBRowid",OEORERowid)=""	
	.......i ((CP="OD")&(OrdType="R")&(qflag=1)&(node=10)&((OEStatCode="V")!(OEStatCode="E"))) d
	........s OEOrdRowID=OEOrdDr_"||"_OEOriDr
	........s PBDrugErrStr=..GetODOrdDispNew(OEOrdRowID,OEORERowid)
	........s PBDrugNum=$p(PBDrugErrStr,"^",2)
	........s DSPdrugNum=$p(PBDrugErrStr,"^",1)   
	........i PBDrugNum'=DSPdrugNum d
	.........s ^TMP("DHCIPBill","YCFeeCheck",EpisodeID,$j,10,"OENPBRowid",OEORERowid)=""
	.......i (node=8)&(qflag="1")  d
	........i ((CP="CR")&(OrdType="R")) d
	.........i PBOQtySum'=DspNum  d
	..........s ^TMP("DHCIPBill","YCFeeCheck",EpisodeID,$j,node,"OEDrugErr",OEORERowid)=PBOQtySum_"^"_DspNum
	.......i ((CP="OD")&(OrdType="R")&(qflag=1)&(node=10)&((OEStatCode="V")!(OEStatCode="E"))) d
	........s DspNum=$p(^OEORD(+BabyOEOrdDr,"I",OEOriDr,"X",OEOreDr),"^",5)
	........i PBOQtySum'=DspNum  d
	.........s ^TMP("DHCIPBill","YCFeeCheck",EpisodeID,$j,10,"OENPBRowid",OEORERowid)=PBOQtySum_"^"_DspNum
	.......i (node=10)&(qflag="1")&(PBOQtySum=0)   d
	........i (OEStatCode="V")!(OEStatCode="E")  d
	.........;i (OrdType="R")&(+$g(OEORIQty)=0)  d
	.........;e  d 
	.........s ^TMP("DHCIPBill","YCFeeCheck",EpisodeID,$j,10,"OENPBRowid",OEORERowid)=""  
	.......i ((node=9)!(node=11))&(ssflag=1)&(qflag="1")  d
	........i (OEStatCode="V")!(OEStatCode="E")  d
	.........s ^TMP("DHCIPBill","YCFeeCheck",EpisodeID,$j,node,"OPAlreadyOE",OEORERowid)=""	
	.......///mdofify 2015-03-02 增加判断中途结算按指定金额结算时会有负数量医嘱
	.......s AllowNegativeNum=0
	.......i ($g(AllowNegativeArcim)'="")  d
	........s AArcimRowid=$p(^OEORD(+OEORERowid,"I",$p(OEORERowid,"||",2),1),"^",2) 
	........i AllowNegativeArcim=AArcimRowid  d
	.........s AllowNegativeNum=AllowNegativeNum+1
	.......///2016-09-08 chenxi 药品批次价取价格时有可能取到负数价格,这里改为判断负数金额
	.......///i (node=15)&(PBOQtySum<0)&(AllowNegativeNum=0)  d	
	.......i (node=15)&(PBOTotSum<0)&(AllowNegativeNum=0)  d
	........s ^TMP("DHCIPBill","YCFeeCheck",EpisodeID,$j,node,"PBNegativeNum",OEORERowid)="" 	
	.......i (PriorCode="S")!(PriorCode="OMST")  d
	........i (OEOREStDate'=StDate)&(OEORENum=1)&(OEORIQty'=0)&(OEORIOEORIDr="")  d
	.........s NFirstQty=NFirstQty+1 
	........i (MOrdType="R")&(OEOREStDate'=StDate)&(OEORENum=1)&(+MOrdQty'=0)&(OEORIOEORIDr'="")  d
	.........s NFirstQty=NFirstQty+1	
	.......e  d
	........i (OEOREStDate'=StDate)&(OEORENum=1)  d
	.........s NFirstQty=NFirstQty+1 
	.....i (NFirstQty'=0)  d
	......;s ^TMP("DHCIPBill","YCFeeCheck",EpisodeID,$j,13,"OEORENull",OEORIRowid)=""
	.....///2015-06-10 chenxi 判断一直是执行记录时，判断该医嘱是否为子医嘱，
	.....///如果为子医嘱则判断主医嘱的执行记录是否停止,如果停止则该医嘱可以没有执行记录
	.....s NExecFlag="Y"
	.....s NExecFlag=..CheckOrdAllowNExec(OEORIRowid)
	.....i NExecFlag'="Y"  d
	......s ^TMP("DHCIPBill","YCFeeCheck",EpisodeID,$j,13,"OEORENull",OEORIRowid)=""	

	s node=""
	f  s node=$o(^TMP("DHCIPBill","YCFeeCheck",EpisodeID,$j,node))  q:(node="")   d	
	.q:(AbnormalDr'="0")&(AbnormalDr'=node)
	.s CAbFeeConfig=$g(^DHCCAbFeeConfig("YCFeeCheck",node))   
	.s TabnormalDesc=$p(CAbFeeConfig,"^",3)
	.s TMemDesc=""  
    .s TAbnormalDr=node
    .s TAdm=EpisodeID
	.s TCheckFlag="0"		;规则不能审核的标志 0不能审核，1可以审核。 除了 1,2,5,6,7 的规则可以审核，其他不能审核到规则
	.s (TSureUser,TSureTime,TMemSure,TOrderDesc,TStDate,TOrderDoctor,TOrderStatus,TOrdCatDesc)=""
	.s (TOrderQty,TOrderPrice,TOrderAmt,TDrugQty,TRecLoc,TOrderRowid,TPBORowid,TOrderExecRowid,TStopDate,TStopUser,TEndDate)=""
	.s TSureStatus="未审核"
	.s TSelect="0"
	.s TCancelCheckUser=""
	.s TCancelCheckDate=""
	.s OPAlreadyOENum=0
	.i node=9  d
	..s TabnormalDesc=TabnormalDesc_"(手术医嘱)"
	.i node=11  d
	..s TabnormalDesc=TabnormalDesc_"(麻醉医嘱)"
	.i ((node=9)!(node=11))&(ssflag="1")  d
	..i $d(^TMP("DHCIPBill","YCFeeCheck",EpisodeID,$j,node,"OPAlreadyOE"))'=0  d
	...s OPAlreadyOENum=OPAlreadyOENum+1
	..s TCheckFlag="1" 
	.q:(OPAlreadyOENum>0)&(node=9)&(ssflag="1")
	.q:(OPAlreadyOENum>0)&(node=11)&(ssflag="1")
	.q:(node=9)&(ssflag="0")
	.q:(node=11)&(ssflag="0")
	.s TCancelCheckUser=""
	.s TCancelCheckDate=""
	.s JFCFARowid="0",ExamineFlagNum=0
	.f  s JFCFARowid=$o(^DHCJFCheckAdmFee(0,"Adm",TAdm,JFCFARowid))  q:(JFCFARowid="")  d
	..s node1=$p(^DHCJFCheckAdmFee(JFCFARowid),"^",2)
	..q:(node1'=node)
	..q:((node1'=9)&(node1'=11))
	..s ExamineFlag=$p(^DHCJFCheckAdmFee(JFCFARowid),"^",6)
	..i ExamineFlag="Y"  d
	...s ExamineFlagNum=ExamineFlagNum+1  
	...s TSureStatus="已审核"
	...s TMemSure=$p(^DHCJFCheckAdmFee(JFCFARowid),"^",10)
	...s TSureUser=""
	...s TSureUserDr=$p(^DHCJFCheckAdmFee(JFCFARowid),"^",9)
	...i TSureUserDr'=""  d
	....s TSureUser=$p(^SSU("SSUSR",TSureUserDr),"^",2)
	...s TSureDate=$p(^DHCJFCheckAdmFee(JFCFARowid),"^",7)
	...i TSureDate'=""  d
	....s TSureDate=##class(websys.Conversions).DateLogicalToHtml(TSureDate)
	...s TSureTime=$p(^DHCJFCheckAdmFee(JFCFARowid),"^",8)
	...i TSureTime'=""  d
	....s TSureTime=##class(websys.Conversions).TimeLogicalToHtml(TSureTime,1)
	...s TSureTime=TSureDate_" "_TSureTime
	..e  d
	...s TSureStatus="未审核"
	...s TMemSure=""
	...s TSureUser=""
	...s TSureTime=""
	...s TCancelCheckUser=""
	...s TCancelCheckUserDr=$p(^DHCJFCheckAdmFee(JFCFARowid),"^",21)
	...i TCancelCheckUserDr'=""  d
	....s TCancelCheckUser=$p(^SSU("SSUSR",TCancelCheckUserDr),"^",2)
	...s TCancelCheckDate=$p(^DHCJFCheckAdmFee(JFCFARowid),"^",19)
	...i TCancelCheckDate'=""  d
	....s TCancelCheckDate=##class(websys.Conversions).DateLogicalToHtml(TCancelCheckDate)
	...s TCancelCheckTime=$p(^DHCJFCheckAdmFee(JFCFARowid),"^",20)
	...i TCancelCheckTime'=""  d
	....s TCancelCheckTime=##class(websys.Conversions).TimeLogicalToHtml(TCancelCheckTime,1) 
	....s TCancelCheckDate=TCancelCheckDate_" "_TCancelCheckTime
	.i ExamineFlagNum>0  d
	..s TSelect="1"	
	..s TSureStatus="已审核"  
	..s TCancelCheckUser=""
	..s TCancelCheckDate=""
	.s TOrdEpisodeId=EpisodeID
	.d OutputRow                               
	.; 上面对 9 和 11 规则的输出 控制
	.s Flag=""
	.f  s Flag=$o(^TMP("DHCIPBill","YCFeeCheck",EpisodeID,$j,node,Flag))  q:(Flag="")  d 
	..q:(node=9)
	..q:(node=11)
	..s TOrdEpisodeId=EpisodeID
	..s TSureStatus="未审核"
	..s TMemSure=""
	..s TSureUser=""
	..s TSureTime=""
	..s TCancelCheckUser=""
	..i VersionFlag'="New"  d
	...s TOrderRowid=""
	...f  s TOrderRowid=$o(^TMP("DHCIPBill","YCFeeCheck",EpisodeID,$j,node,Flag,TOrderRowid))  q:(TOrderRowid="")  d	
	....s TabnormalDesc=""
	....i Flag="ItemCatNull"  d
	.....s TabnormalDesc="医嘱子类为空" 
	....i Flag="OECCatNull"  d
	.....s TabnormalDesc="医嘱大类为空" 
	....i Flag="OrdStatNull"  d
	.....s TabnormalDesc="医嘱状态为空" 	
	....s OEOrdDr=$p(TOrderRowid,"||",1)
	....s OEOriDr=$p(TOrderRowid,"||",2)
	....s ArcimRowid=$p(^OEORD(OEOrdDr,"I",OEOriDr,1),"^",2)
	....s TSureStatus="未审核"
	....s TSureUser=""
	....s TSureTime=""
	....s TOrderDesc=""
	....s TMemSure=""
	....i ArcimRowid'=""  d
	.....s TOrderDesc=$p($g(^ARCIM(+ArcimRowid,$p(ArcimRowid,"||",2)),1),"^",2)
	....s TStDate1=$p(^OEORD(OEOrdDr,"I",OEOriDr,1),"^",9)
	....s TStDate="" 
	....i TStDate1'=""  d
	.....s TStDate=##class(websys.Conversions).DateLogicalToHtml(TStDate1) 
	....s TStTime=$p(^OEORD(OEOrdDr,"I",OEOriDr,1),"^",10)
	....i TStTime'=""  d
	.....s TStTime=##class(websys.Conversions).TimeLogicalToHtml(TStTime,1)
	.....s TStDate=TStDate_" "_TStTime
	....s TOrderDoctor=""
	....s TOrderDoctorDr=$p(^OEORD(OEOrdDr,"I",OEOriDr,1),"^",11)
	....i TOrderDoctorDr'=""  d
	.....s TOrderDoctor=$p(^CTPCP(TOrderDoctorDr,1),"^",2)
	....s TOrderStatusDr=$p(^OEORD(OEOrdDr,"I",OEOriDr,1),"^",13) 
	....s TOrderStatus=""
	....i TOrderStatusDr'=""  d
	.....s TOrderStatus=$p(^OEC("OSTAT",TOrderStatusDr),"^",2)
	....s TOrdCatDesc="",TOrderPrice=0.00	
	....s TOrderQty=0,TOrderPrice=0.00,TOrderAmt=0.00,TDrugQty=0	
	....s TPBORowid=$p(^OEORD(OEOrdDr,"I",OEOriDr,1),"^",16)
	....i TPBORowid'=""  d
	.....s PBRowid=$p(TPBORowid,"||",1)
	.....s PBOSub=$p(TPBORowid,"||",2)
	.....s TOrderQty=$p($g(^DHCPB(PBRowid,"O",PBOSub)),"^",5)
	.....s PBORefQty=$p($g(^DHCPB(PBRowid,"O",PBOSub)),"^",6)
	.....s TOrderQty=TOrderQty+PBORefQty
	.....s TOrderPrice=$p($g(^DHCPB(PBRowid,"O",PBOSub)),"^",7)   
	.....s TOrderAmt=$p($g(^DHCPB(PBRowid,"O",PBOSub)),"^",8)
	.....s TOrderAmt=$j(TOrderAmt,3,2)
	....s DSPRowid="0"
	....f  s DSPRowid=$o(^DHCOEDISQTY(0,"OEORI",TOrderRowid,DSPRowid))  q:(DSPRowid="")  d
	.....s DspStatus=$p(^DHCOEDISQTY(DSPRowid),"^",7)  
	.....s DspconfirmQty=$p(^DHCOEDISQTY(DSPRowid),"^",11) 
	.....i DspStatus="C"  d 
	......s TDrugQty=TDrugQty+DspconfirmQty
	.....i DspStatus="R"  d 
	......s TDrugQty=TDrugQty-DspconfirmQty 
	....s RecLocDr=$p(^OEORD(OEOrdDr,"I",OEOriDr,3),"^",6)
	....s TRecLoc=""
	....i RecLocDr'=""  d
	.....s TRecLoc=$p(^CTLOC(RecLocDr),"^",2)
	.....i $f(TRecLoc,"-")'=0  d
	......s TRecLoc=$p(TRecLoc,"-",2)    
	....s TOrderExecRowid=""
	....s TSelect="0"
	....s TStopDate=$p($g(^OEORD(OEOrdDr,"I",OEOriDr,3)),"^",34)
	....i TStopDate'=""  d
	.....s TStopDate=##class(websys.Conversions).DateLogicalToHtml(TStopDate)
	....s TStopTime=$p($g(^OEORD(OEOrdDr,"I",OEOriDr,2)),"^",15)
	....i TStopTime'=""  d
	.....s TStopTime=##class(websys.Conversions).TimeLogicalToHtml(TStopTime,1)
	.....s TStopDate=TStopDate_" "_TStopTime
	....s TStopUser=""
	....s TStopUserDr=$p($g(^OEORD(OEOrdDr,"I",OEOriDr,3)),"^",29)
	....i TStopUserDr'=""  d
	.....s TStopUser=$p(^CTPCP(TStopUserDr,1),"^",2)  
	....s TEndDate=$p($g(^OEORD(OEOrdDr,"I",OEOriDr,9)),"^",9)
	....s TEndTime=$p($g(^OEORD(OEOrdDr,"I",OEOriDr,9)),"^",10)
	....i TEndDate'=""  d
	.....s TEndDate=##class(websys.Conversions).DateLogicalToHtml(TEndDate)
	.....i TEndTime'=""  d
	......s TEndTime=##class(websys.Conversions).TimeLogicalToHtml(TEndTime,1) 
	......s TEndDate=TEndDate_" "_TEndTime
	....s TOrderExecRowid=""
	....s TCheckFlag="1"
	....s TCancelCheckUser=""
	....s TCancelCheckDate=""
	....;检查医嘱项审核状态：
	....s JFCFARowid="0",ExamineFlagNum=0
	....f  s JFCFARowid=$o(^DHCJFCheckAdmFee(0,"Oeori",TOrderRowid,JFCFARowid))  q:(JFCFARowid="")  d
	.....s ExamineFlag=$p(^DHCJFCheckAdmFee(JFCFARowid),"^",6)
	.....i ExamineFlag="Y"  d
	......s ExamineFlagNum=ExamineFlagNum+1  
	......s TSureStatus="已审核"
	......s TMemSure=$p(^DHCJFCheckAdmFee(JFCFARowid),"^",10)
	......s TSureUser=""
	......s TSureUserDr=$p(^DHCJFCheckAdmFee(JFCFARowid),"^",9)
	......i TSureUserDr'=""  d
	.......s TSureUser=$p(^SSU("SSUSR",TSureUserDr),"^",2)
	......s TSureDate=$p(^DHCJFCheckAdmFee(JFCFARowid),"^",7)
	......i TSureDate'=""  d
	.......s TSureDate=##class(websys.Conversions).DateLogicalToHtml(TSureDate)
	......s TSureTime=$p(^DHCJFCheckAdmFee(JFCFARowid),"^",8)
	......i TSureTime'=""  d
	.......s TSureTime=##class(websys.Conversions).TimeLogicalToHtml(TSureTime,1)
	......s TSureTime=TSureDate_" "_TSureTime
	.....e  d
	......s TSureStatus="未审核"
	......s TMemSure=""
	......s TSureUser=""
	......s TSureTime=""
	......s TCancelCheckUser=""
	......s TCancelCheckUserDr=$p(^DHCJFCheckAdmFee(JFCFARowid),"^",21)
	......i TCancelCheckUserDr'=""  d
	.......s TCancelCheckUser=$p(^SSU("SSUSR",TCancelCheckUserDr),"^",2)
	......s TCancelCheckDate=$p(^DHCJFCheckAdmFee(JFCFARowid),"^",19)
	......i TCancelCheckDate'=""  d
	.......s TCancelCheckDate=##class(websys.Conversions).DateLogicalToHtml(TCancelCheckDate)
	......s TCancelCheckTime=$p(^DHCJFCheckAdmFee(JFCFARowid),"^",20)
	......i TCancelCheckTime'=""  d
	.......s TCancelCheckDate=TCancelCheckDate_" "_##class(websys.Conversions).TimeLogicalToHtml(TCancelCheckTime,1)
	....i ExamineFlagNum>0  d
	.....s TSelect="1" 
	.....s TSureStatus="已审核"       
	.....s TCancelCheckUser=""
	.....s TCancelCheckDate=""
	....s OrderBillFlag=$p(^OEORD(+TOrderRowid,"I",$p(TOrderRowid,"||",2),3),"^",5)
    ....//q:(OrderBillFlag="P")
	....s TOrdEpisodeId=EpisodeID
	....d OutputRow                                            
	..; 上面 对 非New 版本的处理
	..e  d	
	...i Flag="OEORENull"  d
	....;对于没有执行记录的输出 规则13.
	....s TOrderRowid=""
	....f  s TOrderRowid=$o(^TMP("DHCIPBill","YCFeeCheck",EpisodeID,$j,node,Flag,TOrderRowid))  q:(TOrderRowid="")  d	
	.....s (TSureUser,TSureTime,TMemSure,TOrderDesc,TStDate,TOrderDoctor,TOrderStatus,TOrdCatDesc)=""
	.....s (TOrderQty,TOrderPrice,TOrderAmt,TDrugQty,TRecLoc,TPBORowid,TOrderExecRowid,TStopDate,TStopUser,TEndDate)=""
	.....s TabnormalDesc=""
	.....i Flag="ItemCatNull"  d
	......s TabnormalDesc="医嘱子类为空" 
	.....i Flag="OECCatNull"  d
	......s TabnormalDesc="医嘱大类为空" 
	.....i Flag="OrdStatNull"  d
	......s TabnormalDesc="医嘱状态为空" 	
	.....s OEOrdDr=$p(TOrderRowid,"||",1)
	.....s OEOriDr=$p(TOrderRowid,"||",2)
	.....s ArcimRowid=$p(^OEORD(OEOrdDr,"I",OEOriDr,1),"^",2)
	.....s TSureStatus="未审核"
	.....s TSureUser=""
	.....s TSureTime=""
	.....s TOrderDesc=""
	.....s TMemSure=""
	.....i ArcimRowid'=""  d
	......s TOrderDesc=$p($G(^ARCIM(+ArcimRowid,$p(ArcimRowid,"||",2),1)),"^",2)
	.....s TStDate1=$p(^OEORD(OEOrdDr,"I",OEOriDr,1),"^",9)
	.....s TStDate="" 
	.....i TStDate1'=""  d
	......s TStDate=##class(websys.Conversions).DateLogicalToHtml(TStDate1) 
	.....s TStTime=$p(^OEORD(OEOrdDr,"I",OEOriDr,1),"^",10)
	.....i TStTime'=""  d
	......s TStDate=TStDate_" "_##class(websys.Conversions).TimeLogicalToHtml(TStTime,1)
	.....s TOrderDoctor=""
	.....s TOrderDoctorDr=$p(^OEORD(OEOrdDr,"I",OEOriDr,1),"^",11)
	.....i TOrderDoctorDr'=""  d
	......s TOrderDoctor=$p(^CTPCP(TOrderDoctorDr,1),"^",2)
	.....s TOrderStatusDr=$p(^OEORD(OEOrdDr,"I",OEOriDr,1),"^",13) 
	.....s TOrderStatus=""
	.....i TOrderStatusDr'=""  d
	......s TOrderStatus=$p(^OEC("OSTAT",TOrderStatusDr),"^",2)
	.....s TOrdCatDesc="",TOrderPrice=0.00	
	.....s TOrderQty=0,TOrderPrice=0.00,TOrderAmt=0.00,TDrugQty=0	
	.....s TPBORowid=$p($g(^OEORD(OEOrdDr,"I",OEOriDr,1)),"^",16)
	.....i +$g(TPBORowid)=0 s TPBORowid=""
	.....;s TPBORowid=""
	.....i TPBORowid'=""  d
	......s PBRowid=$p(TPBORowid,"||",1)
	......s PBOSub=$p(TPBORowid,"||",2)
	......s TOrderQty=$p($g(^DHCPB(PBRowid,"O",PBOSub)),"^",5)
	......s PBORefQty=$p($g(^DHCPB(PBRowid,"O",PBOSub)),"^",6)
	......s TOrderQty=TOrderQty+PBORefQty
	......s TOrderPrice=$p($g(^DHCPB(PBRowid,"O",PBOSub)),"^",7)   
	......s TOrderAmt=$p($g(^DHCPB(PBRowid,"O",PBOSub)),"^",8)
	......s TOrderAmt=$j(TOrderAmt,3,2)
	.....s DSPRowid="0"
	.....f  s DSPRowid=$o(^DHCOEDISQTY(0,"OEORI",TOrderRowid,DSPRowid))  q:(DSPRowid="")  d
	......s DspStatus=$p(^DHCOEDISQTY(DSPRowid),"^",7)  
	......s DspconfirmQty=$p(^DHCOEDISQTY(DSPRowid),"^",11) 
	......i DspStatus="C"  d 
	.......s TDrugQty=TDrugQty+DspconfirmQty
	......i DspStatus="R"  d 
	.......s TDrugQty=TDrugQty-DspconfirmQty 
	.....s RecLocDr=$p(^OEORD(OEOrdDr,"I",OEOriDr,3),"^",6)
	.....s TRecLoc=""
	.....i RecLocDr'=""  d
	......s TRecLoc=$p(^CTLOC(RecLocDr),"^",2)
	......i $f(TRecLoc,"-")'=0  d
	.......s TRecLoc=$p(TRecLoc,"-",2)    
	.....s TOrderExecRowid=""
	.....s TSelect="0"
	.....s TStopDate=$p($g(^OEORD(OEOrdDr,"I",OEOriDr,3)),"^",34)
	.....i TStopDate'=""  d
	......s TStopDate=##class(websys.Conversions).DateLogicalToHtml(TStopDate)
	.....s TStopTime=$p($g(^OEORD(OEOrdDr,"I",OEOriDr,2)),"^",15)
	.....i TStopTime'=""  d
	......s TStopDate=TStopDate_" "_##class(websys.Conversions).TimeLogicalToHtml(TStopTime,1)
	.....s TStopUser=""
	.....s TStopUserDr=$p($g(^OEORD(OEOrdDr,"I",OEOriDr,3)),"^",29)
	.....i TStopUserDr'=""  d
	......s TStopUser=$p(^CTPCP(TStopUserDr,1),"^",2)  
	.....s TEndDate=$p($g(^OEORD(OEOrdDr,"I",OEOriDr,9)),"^",9)
	.....s TEndTime=$p($g(^OEORD(OEOrdDr,"I",OEOriDr,9)),"^",10)
	.....i TEndDate'=""  d
	......s TEndDate=##class(websys.Conversions).DateLogicalToHtml(TEndDate)
	......i TEndTime'=""  d
	.......s TEndTime=##class(websys.Conversions).TimeLogicalToHtml(TEndTime,1) 
	.......s TEndDate=TEndDate_" "_TEndTime
	.....s TOrderExecRowid=""
	.....s TCheckFlag="1"
	.....s TCancelCheckUser=""
	.....s TCancelCheckDate=""
	.....s JFCFARowid="0",ExamineFlagNum=0
	.....f  s JFCFARowid=$o(^DHCJFCheckAdmFee(0,"Oeori",TOrderRowid,JFCFARowid))  q:(JFCFARowid="")  d
	......s ExamineFlag=$p(^DHCJFCheckAdmFee(JFCFARowid),"^",6)
	......s OrdExecNode=$p(^DHCJFCheckAdmFee(JFCFARowid),"^",2)
	......q:(OrdExecNode'=node)
	......i ExamineFlag="Y"  d
	.......s ExamineFlagNum=ExamineFlagNum+1  
	.......s TSureStatus="已审核"
	.......s TMemSure=$p(^DHCJFCheckAdmFee(JFCFARowid),"^",10)
	.......s TSureUser=""
	.......s TSureUserDr=$p(^DHCJFCheckAdmFee(JFCFARowid),"^",9)
	.......i TSureUserDr'=""  d
	........s TSureUser=$p(^SSU("SSUSR",TSureUserDr),"^",2)
	.......s TSureDate=$p(^DHCJFCheckAdmFee(JFCFARowid),"^",7)
	.......i TSureDate'=""  d
	........s TSureDate=##class(websys.Conversions).DateLogicalToHtml(TSureDate)
	.......s TSureTime=$p(^DHCJFCheckAdmFee(JFCFARowid),"^",8)
	.......i TSureTime'=""  d
	........s TSureTime=##class(websys.Conversions).TimeLogicalToHtml(TSureTime,1)
	.......s TSureTime=TSureDate_" "_TSureTime
	......e  d
	.......s TSureStatus="未审核"
	.......s TMemSure=""
	.......s TSureUser=""
	.......s TSureTime=""
	.......s TCancelCheckUser=""
	.......s TCancelCheckUserDr=$p(^DHCJFCheckAdmFee(JFCFARowid),"^",21)
	.......i TCancelCheckUserDr'=""  d
	........s TCancelCheckUser=$p(^SSU("SSUSR",TCancelCheckUserDr),"^",2)
	.......s TCancelCheckDate=$p(^DHCJFCheckAdmFee(JFCFARowid),"^",19)
	.......i TCancelCheckDate'=""  d
	........s TCancelCheckDate=##class(websys.Conversions).DateLogicalToHtml(TCancelCheckDate)
	.......s TCancelCheckTime=$p(^DHCJFCheckAdmFee(JFCFARowid),"^",20)
	.......i TCancelCheckTime'=""  d
	........s TCancelCheckDate=TCancelCheckDate_" "_##class(websys.Conversions).TimeLogicalToHtml(TCancelCheckTime,1)
	.....i ExamineFlagNum>0  d
	......s TSelect="1" 
	......s TSureStatus="已审核"       
	......s TCancelCheckUser=""
	......s TCancelCheckDate=""
	.....s OrderBillFlag=$p(^OEORD(+TOrderRowid,"I",$p(TOrderRowid,"||",2),3),"^",5)
    .....///q:(OrderBillFlag="P")
	.....s TOrdEpisodeId=EpisodeID
	.....d OutputRow      
	...e  i (Flag'="OEORENull")&(node=14)  d
	....;对于 规则14输出.
	....s TOrderRowid=""
	....f  s TOrderRowid=$o(^TMP("DHCIPBill","YCFeeCheck",EpisodeID,$j,node,Flag,TOrderRowid))  q:(TOrderRowid="")  d	
	.....s (TSureUser,TSureTime,TMemSure,TOrderDesc,TStDate,TOrderDoctor,TOrderStatus,TOrdCatDesc)=""
	.....s (TOrderQty,TOrderPrice,TOrderAmt,TDrugQty,TRecLoc,TPBORowid,TOrderExecRowid,TStopDate,TStopUser,TEndDate)=""
	.....s TabnormalDesc=""
	.....i Flag="ItemCatNull"  d
	......s TabnormalDesc="医嘱子类为空" 
	.....i Flag="OECCatNull"  d
	......s TabnormalDesc="医嘱大类为空" 
	.....i Flag="OrdStatNull"  d
	......s TabnormalDesc="医嘱状态为空" 	
	.....s OEOrdDr=$p(TOrderRowid,"||",1)
	.....s OEOriDr=$p(TOrderRowid,"||",2)
	.....s ArcimRowid=$p(^OEORD(OEOrdDr,"I",OEOriDr,1),"^",2)
	.....s TSureStatus="未审核"
	.....s TSureUser=""
	.....s TSureTime=""
	.....s TOrderDesc=""
	.....s TMemSure=""
	.....i ArcimRowid'=""  d
	......s TOrderDesc=$p($G(^ARCIM(+ArcimRowid,$p(ArcimRowid,"||",2),1)),"^",2)
	.....s TStDate1=$p(^OEORD(OEOrdDr,"I",OEOriDr,1),"^",9)
	.....s TStDate="" 
	.....i TStDate1'=""  d
	......s TStDate=##class(websys.Conversions).DateLogicalToHtml(TStDate1) 
	.....s TStTime=$p(^OEORD(OEOrdDr,"I",OEOriDr,1),"^",10)
	.....i TStTime'=""  d
	......s TStDate=TStDate_" "_##class(websys.Conversions).TimeLogicalToHtml(TStTime,1)
	.....s TOrderDoctor=""
	.....s TOrderDoctorDr=$p(^OEORD(OEOrdDr,"I",OEOriDr,1),"^",11)
	.....i TOrderDoctorDr'=""  d
	......s TOrderDoctor=$p(^CTPCP(TOrderDoctorDr,1),"^",2)
	.....s TOrderStatusDr=$p(^OEORD(OEOrdDr,"I",OEOriDr,1),"^",13) 
	.....s TOrderStatus=""
	.....i TOrderStatusDr'=""  d
	......s TOrderStatus=$p(^OEC("OSTAT",TOrderStatusDr),"^",2)
	.....s TOrdCatDesc="",TOrderPrice=0.00	
	.....s TOrderQty=0,TOrderPrice=0.00,TOrderAmt=0.00,TDrugQty=0	
	.....s TPBORowid=$p($g(^OEORD(OEOrdDr,"I",OEOriDr,1)),"^",16)
	.....i +$g(TPBORowid)=0 s TPBORowid=""
	.....;s TPBORowid=""
	.....i TPBORowid'=""  d
	......s PBRowid=$p(TPBORowid,"||",1)
	......s PBOSub=$p(TPBORowid,"||",2)
	......s TOrderQty=$p($g(^DHCPB(PBRowid,"O",PBOSub)),"^",5)
	......s PBORefQty=$p($g(^DHCPB(PBRowid,"O",PBOSub)),"^",6)
	......s TOrderQty=TOrderQty+PBORefQty
	......s TOrderPrice=$p($g(^DHCPB(PBRowid,"O",PBOSub)),"^",7)   
	......s TOrderAmt=$p($g(^DHCPB(PBRowid,"O",PBOSub)),"^",8)
	......s TOrderAmt=$j(TOrderAmt,3,2)
	.....s DSPRowid="0"
	.....f  s DSPRowid=$o(^DHCOEDISQTY(0,"OEORI",TOrderRowid,DSPRowid))  q:(DSPRowid="")  d
	......s DspStatus=$p(^DHCOEDISQTY(DSPRowid),"^",7)  
	......s DspconfirmQty=$p(^DHCOEDISQTY(DSPRowid),"^",11) 
	......i DspStatus="C"  d 
	.......s TDrugQty=TDrugQty+DspconfirmQty
	......i DspStatus="R"  d 
	.......s TDrugQty=TDrugQty-DspconfirmQty 
	.....s RecLocDr=$p(^OEORD(OEOrdDr,"I",OEOriDr,3),"^",6)
	.....s TRecLoc=""
	.....i RecLocDr'=""  d
	......s TRecLoc=$p(^CTLOC(RecLocDr),"^",2)
	......i $f(TRecLoc,"-")'=0  d
	.......s TRecLoc=$p(TRecLoc,"-",2)    
	.....s TOrderExecRowid=""
	.....s TSelect="0"
	.....s TStopDate=$p($g(^OEORD(OEOrdDr,"I",OEOriDr,3)),"^",34)
	.....i TStopDate'=""  d
	......s TStopDate=##class(websys.Conversions).DateLogicalToHtml(TStopDate)
	.....s TStopTime=$p($g(^OEORD(OEOrdDr,"I",OEOriDr,2)),"^",15)
	.....i TStopTime'=""  d
	......s TStopDate=TStopDate_" "_##class(websys.Conversions).TimeLogicalToHtml(TStopTime,1)
	.....s TStopUser=""
	.....s TStopUserDr=$p($g(^OEORD(OEOrdDr,"I",OEOriDr,3)),"^",29)
	.....i TStopUserDr'=""  d
	......s TStopUser=$p(^CTPCP(TStopUserDr,1),"^",2)  
	.....s TEndDate=$p($g(^OEORD(OEOrdDr,"I",OEOriDr,9)),"^",9)
	.....s TEndTime=$p($g(^OEORD(OEOrdDr,"I",OEOriDr,9)),"^",10)
	.....i TEndDate'=""  d
	......s TEndDate=##class(websys.Conversions).DateLogicalToHtml(TEndDate)
	......i TEndTime'=""  d
	.......s TEndDate=TEndDate_" "_##class(websys.Conversions).TimeLogicalToHtml(TEndTime,1) 
	.....s TOrderExecRowid=""
	.....s TCheckFlag="1"
	.....s TCancelCheckUser=""
	.....s TCancelCheckDate=""
	.....s JFCFARowid="0",ExamineFlagNum=0
	.....f  s JFCFARowid=$o(^DHCJFCheckAdmFee(0,"Oeori",TOrderRowid,JFCFARowid))  q:(JFCFARowid="")  d
	......s ExamineFlag=$p(^DHCJFCheckAdmFee(JFCFARowid),"^",6)
	......s OrdExecNode=$p(^DHCJFCheckAdmFee(JFCFARowid),"^",2)
	......q:(OrdExecNode'=node)
	......i ExamineFlag="Y"  d
	.......s ExamineFlagNum=ExamineFlagNum+1  
	.......s TSureStatus="已审核"
	.......s TMemSure=$p(^DHCJFCheckAdmFee(JFCFARowid),"^",10)
	.......s TSureUser=""
	.......s TSureUserDr=$p(^DHCJFCheckAdmFee(JFCFARowid),"^",9)
	.......i TSureUserDr'=""  d
	........s TSureUser=$p(^SSU("SSUSR",TSureUserDr),"^",2)
	.......s TSureDate=$p(^DHCJFCheckAdmFee(JFCFARowid),"^",7)
	.......i TSureDate'=""  d
	........s TSureDate=##class(websys.Conversions).DateLogicalToHtml(TSureDate)
	.......s TSureTime=$p(^DHCJFCheckAdmFee(JFCFARowid),"^",8)
	.......i TSureTime'=""  d
	........s TSureTime=##class(websys.Conversions).TimeLogicalToHtml(TSureTime,1)
	.......s TSureTime=TSureDate_" "_TSureTime
	......e  d
	.......s TSureStatus="未审核"
	.......s TMemSure=""
	.......s TSureUser=""
	.......s TSureTime=""
	.......s TCancelCheckUser=""
	.......s TCancelCheckUserDr=$p(^DHCJFCheckAdmFee(JFCFARowid),"^",21)
	.......i TCancelCheckUserDr'=""  d
	........s TCancelCheckUser=$p(^SSU("SSUSR",TCancelCheckUserDr),"^",2)
	.......s TCancelCheckDate=$p(^DHCJFCheckAdmFee(JFCFARowid),"^",19)
	.......i TCancelCheckDate'=""  d
	........s TCancelCheckDate=##class(websys.Conversions).DateLogicalToHtml(TCancelCheckDate)
	.......s TCancelCheckTime=$p(^DHCJFCheckAdmFee(JFCFARowid),"^",20)
	.......i TCancelCheckTime'=""  d
	........s TCancelCheckTime=##class(websys.Conversions).TimeLogicalToHtml(TCancelCheckTime,1)
	........s TCancelCheckDate=TCancelCheckDate_" "_TCancelCheckTime
	.....i ExamineFlagNum>0  d
	......s TSelect="1" 
	......s TSureStatus="已审核"       
	......s TCancelCheckUser=""
	......s TCancelCheckDate=""
	.....s OrderBillFlag=$p(^OEORD(+TOrderRowid,"I",$p(TOrderRowid,"||",2),3),"^",5)
    .....//q:(OrderBillFlag="P")
	.....s TOrdEpisodeId=EpisodeID
	.....d OutputRow
		
	...e  d
	....; 除了 1,2,5,6,7,13规则 ，其他规则的输出。
	....s TOrderExecRowid=""
	....f  s TOrderExecRowid=$o(^TMP("DHCIPBill","YCFeeCheck",EpisodeID,$j,node,Flag,TOrderExecRowid))  q:(TOrderExecRowid="")  d
    .....s (TSureUser,TSureTime,TMemSure,TOrderDesc,TStDate,TOrderDoctor,TOrderStatus,TOrdCatDesc)=""
	.....s (TOrderQty,TOrderPrice,TOrderAmt,TDrugQty,TRecLoc,TOrderRowid,TPBORowid,TStopDate,TStopUser,TEndDate)=""
    .....s TabnormalDesc=""
    .....s TSureStatus="未审核"
	.....s TSureUser=""
	.....s TSureTime=""
	.....s TOrderDesc=""
	.....s TMemSure=""
	.....s TStDate=""
	.....i node=14  d
	......s OEExcStDate="",OEExcStTime=""
	.....e  d
	......s OEExcStDate=$p(^OEORD(+TOrderExecRowid,"I",$p(TOrderExecRowid,"||",2),"X",$p(TOrderExecRowid,"||",3)),"^",1)
    ......s OEExcStTime=$p(^OEORD(+TOrderExecRowid,"I",$p(TOrderExecRowid,"||",2),"X",$p(TOrderExecRowid,"||",3)),"^",2)     
    .....i OEExcStDate'=""  d
    ......s TStDate=##class(websys.Conversions).DateLogicalToHtml(OEExcStDate)
    ......i OEExcStTime'=""  d
    .......s OEExcStTime=##class(websys.Conversions).TimeLogicalToHtml(OEExcStTime,1) 
    .......s TStDate=TStDate_" "_OEExcStTime
    .....s OEOrdDr=$p(TOrderExecRowid,"||",1)
    .....s OEOriDr=$p(TOrderExecRowid,"||",2)
    .....s ArcimRowid=$p(^OEORD(OEOrdDr,"I",OEOriDr,1),"^",2)
    .....i ArcimRowid'=""  d
	......s TOrderDesc=$p($g(^ARCIM(+ArcimRowid,$p(ArcimRowid,"||",2),1)),"^",2)
    .....s OrdExeSub=$p(TOrderExecRowid,"||",3)
	.....s TOrderRowid=OEOrdDr_"||"_OEOriDr
	.....s OEORDBillStr=$g(^OEORD(OEOrdDr,"I",OEOriDr,"X",OrdExeSub,"BILL"))
	.....s TOrderExecRowid1=OEOrdDr_"||"_OEOriDr_"||"_OrdExeSub
	.....s TPBORowid=""
	.....i OEORDBillStr'=""  d
	......s TPBORowid=$p(OEORDBillStr,"^",2)
	.....i (TPBORowid'="")  d
	......s PBRowid=$p(TPBORowid,"||",1)
	......s PBOSub=$p(TPBORowid,"||",2)
	......i $d(^DHCPB(PBRowid,"O",PBOSub))'=0  d
	.......s TOrderQty=$p($g(^DHCPB(PBRowid,"O",PBOSub)),"^",5)
	.......s PBORefQty=$p($g(^DHCPB(PBRowid,"O",PBOSub)),"^",6)
	.......s TOrderQty=TOrderQty+PBORefQty
	.......s TOrderPrice=$p($g(^DHCPB(PBRowid,"O",PBOSub)),"^",7)   
	.......s TOrderAmt=$p($g(^DHCPB(PBRowid,"O",PBOSub)),"^",8)
	.......s TOrderAmt=$j(TOrderAmt,3,2)	
	.....s DSPRowid="0"
	.....f  s DSPRowid=$o(^DHCOEDISQTY(0,"OEORE",TOrderExecRowid1,DSPRowid))  q:(DSPRowid="")  d
	......s DspStatus=$p(^DHCOEDISQTY(DSPRowid),"^",7)  
	......s DspconfirmQty=$p(^DHCOEDISQTY(DSPRowid),"^",11) 
	......i DspStatus="C"  d 
	.......s TDrugQty=TDrugQty+DspconfirmQty
	......i DspStatus="R"  d 
	.......s TDrugQty=TDrugQty-DspconfirmQty 
	.....s RecLocDr=$p(^OEORD(OEOrdDr,"I",OEOriDr,3),"^",6)
	.....s TRecLoc=""
	.....i RecLocDr'=""  d
	......s TRecLoc=$p(^CTLOC(RecLocDr),"^",2)
	......i $f(TRecLoc,"-")'=0  d
	.......s TRecLoc=$p(TRecLoc,"-",2)    
	.....s TSelect="0"
	.....s TStopDate=$p($g(^OEORD(OEOrdDr,"I",OEOriDr,3)),"^",34)
	.....i TStopDate'=""  d
	......s TStopDate=##class(websys.Conversions).DateLogicalToHtml(TStopDate)
	.....s TStopTime=$p($g(^OEORD(OEOrdDr,"I",OEOriDr,2)),"^",15)
	.....i TStopTime'=""  d
	......s TStopTime=##class(websys.Conversions).TimeLogicalToHtml(TStopTime,1)
	......s TStopDate=TStopDate_" "_TStopTime
	.....s TStopUser=""
	.....s TStopUserDr=$p($g(^OEORD(OEOrdDr,"I",OEOriDr,3)),"^",29)
	.....i TStopUserDr'=""  d
	......s TStopUser=$p(^CTPCP(TStopUserDr,1),"^",2)  
	.....s TEndDate=$p($g(^OEORD(OEOrdDr,"I",OEOriDr,9)),"^",9)
	.....s TEndTime=$p($g(^OEORD(OEOrdDr,"I",OEOriDr,9)),"^",10)
	.....i TEndDate'=""  d
	......s TEndDate=##class(websys.Conversions).DateLogicalToHtml(TEndDate)
	......i TEndTime'=""  d
	.......s TEndTime=##class(websys.Conversions).TimeLogicalToHtml(TEndTime,1)
	.......s TEndDate=TEndDate_" "_TEndTime	
	.....s TCheckFlag="1"
	.....s TCancelCheckUser=""
	.....s TCancelCheckDate=""
	.....s JFCFARowid="0",ExamineFlagNum=0
	.....f  s JFCFARowid=$o(^DHCJFCheckAdmFee(0,"Oeore",TOrderExecRowid1,JFCFARowid))  q:(JFCFARowid="")  d
	......s ExamineFlag=$p(^DHCJFCheckAdmFee(JFCFARowid),"^",6)
	......s OrdExecNode=$p(^DHCJFCheckAdmFee(JFCFARowid),"^",2)
	......q:(OrdExecNode'=node)
	......i ExamineFlag="Y"  d
	.......s ExamineFlagNum=ExamineFlagNum+1  
	.......s TSureStatus="已审核"
	.......s TMemSure=$p(^DHCJFCheckAdmFee(JFCFARowid),"^",10)
	.......s TSureUser=""
	.......s TSureUserDr=$p(^DHCJFCheckAdmFee(JFCFARowid),"^",9)
	.......i TSureUserDr'=""  d
	........s TSureUser=$p(^SSU("SSUSR",TSureUserDr),"^",2)
	.......s TSureDate=$p(^DHCJFCheckAdmFee(JFCFARowid),"^",7)
	.......i TSureDate'=""  d
	........s TSureDate=##class(websys.Conversions).DateLogicalToHtml(TSureDate)
	.......s TSureTime=$p(^DHCJFCheckAdmFee(JFCFARowid),"^",8)
	.......i TSureTime'=""  d
	........s TSureTime=##class(websys.Conversions).TimeLogicalToHtml(TSureTime,1)
	.......s TSureTime=TSureDate_" "_TSureTime	
	......e  d
	.......s TSureStatus="未审核"
	.......s TMemSure=""
	.......s TSureUser=""
	.......s TSureTime=""
	.......s TCancelCheckUser=""
	.......s TCancelCheckUserDr=$p(^DHCJFCheckAdmFee(JFCFARowid),"^",21)
	.......i TCancelCheckUserDr'=""  d
	........s TCancelCheckUser=$p(^SSU("SSUSR",TCancelCheckUserDr),"^",2)
	.......s TCancelCheckDate=$p(^DHCJFCheckAdmFee(JFCFARowid),"^",19)
	.......i TCancelCheckDate'=""  d
	........s TCancelCheckDate=##class(websys.Conversions).DateLogicalToHtml(TCancelCheckDate)
	.......s TCancelCheckTime=$p(^DHCJFCheckAdmFee(JFCFARowid),"^",20)
	.......i TCancelCheckTime'=""  d
	........s TCancelCheckTime=##class(websys.Conversions).TimeLogicalToHtml(TCancelCheckTime,1)
	........s TCancelCheckDate=TCancelCheckDate_" "_TCancelCheckTime
	.....i ExamineFlagNum>0  d
	......s TSelect="1" 
	......s TSureStatus="已审核"       
	......s TCancelCheckUser=""
	......s TCancelCheckDate=""
	.....s OrderBillFlag=$p(^OEORD(+TOrderRowid,"I",$p(TOrderRowid,"||",2),3),"^",5)
    .....//q:(OrderBillFlag="P")
	.....s TOrdEpisodeId=EpisodeID
	.....d OutputRow                                   
	
	//再处理费床位费、诊查费、护理费等类医嘱(需按天计算)  ^TMP("DHCIPBill","YCFeeCheckAdmDate",EpisodeID,$j,node,PrtDate)
	s node=""
	f  s node=$o(^TMP("DHCIPBill","YCFeeCheckAdmDate",EpisodeID,$j,node))  q:(node="")  d
	.q:(AbnormalDr'="0")&(AbnormalDr'=node)
	.s CAbFeeConfig=$g(^DHCCAbFeeConfig("YCFeeCheck",node))
	.s PrtDate=""
	.s PrtNum=0
	.f  s PrtDate=$o(^TMP("DHCIPBill","YCFeeCheckAdmDate",EpisodeID,$j,node,PrtDate))  q:(PrtDate="")  d
	..i $d(^TMP("DHCIPBill","AlreadyPBDate",EpisodeID,$j,node,PrtDate))=0  d
	...s ^TMP("DHCIPBill","YCFeeCheckNDate",EpisodeID,$j,node,PrtDate)=""      
	
	i BabyFlag="Y"  d
    .s BabyAdmRowid="0"
    .f  s BabyAdmRowid=$o(^PAADMi("Mother",EpisodeID,BabyAdmRowid))  q:(BabyAdmRowid="")  d
	..s node=""
	..f  s node=$o(^TMP("DHCIPBill","YCFeeCheckAdmDate",BabyAdmRowid,$j,node))  q:(node="")  d
	...q:(AbnormalDr'="0")&(AbnormalDr'=node)
	...s CAbFeeConfig=$g(^DHCCAbFeeConfig("YCFeeCheck",node))
	...s PrtDate=""
	...s PrtNum=0
	...f  s PrtDate=$o(^TMP("DHCIPBill","YCFeeCheckAdmDate",BabyAdmRowid,$j,node,PrtDate))  q:(PrtDate="")  d
	....i $d(^TMP("DHCIPBill","AlreadyPBDate",BabyAdmRowid,$j,node,PrtDate))=0  d
	.....s ^TMP("DHCIPBill","YCFeeCheckNDate",BabyAdmRowid,$j,node,PrtDate)=""

	s TOrdEpisodeId=""
	f  s TOrdEpisodeId=$o(^TMP("DHCIPBill","YCFeeCheckNDate",TOrdEpisodeId))  q:(TOrdEpisodeId="")  d
	.s EpisodeIDnum=0
	.i TOrdEpisodeId=EpisodeID  d
	..s EpisodeIDnum=EpisodeIDnum+1
	.i BabyFlag="Y"  d
    ..s BabyAdmRowid="0"
    ..f  s BabyAdmRowid=$o(^PAADMi("Mother",EpisodeID,BabyAdmRowid))  q:(BabyAdmRowid="")  d
	...i BabyAdmRowid=TOrdEpisodeId  d
	....s EpisodeIDnum=EpisodeIDnum+1 
	.q:(EpisodeIDnum=0)
	.s node=""
	.f  s node=$o(^TMP("DHCIPBill","YCFeeCheckNDate",TOrdEpisodeId,$j,node))  q:(node="")  d
	..q:(AbnormalDr'="0")&(AbnormalDr'=node)
	..s TMotherAdm=$p(^PAADM(TOrdEpisodeId),"^",75)
	..s BabyOEOrdDr=""
	..i TMotherAdm'=""  d 
	...s BabyOEOrdDr=$o(^OEORD(0,"Adm",TOrdEpisodeId,""))
	..//q:(TMotherAdm'="")&(BabyOEOrdDr="")
	..s CAbFeeConfig=$g(^DHCCAbFeeConfig("YCFeeCheck",node))
	..s TabnormalDesc=$p(CAbFeeConfig,"^",3)
	..s TMemDesc=""  
    ..s TAbnormalDr=node
    ..s TAdm=TOrdEpisodeId
	..s TCheckFlag="1"
	..s (TSureUser,TSureTime,TMemSure,TOrderDesc,TStDate,TOrderDoctor,TOrderStatus,TOrdCatDesc)=""
	..s (TOrderQty,TOrderPrice,TOrderAmt,TDrugQty,TRecLoc,TOrderRowid,TPBORowid,TOrderExecRowid,TStopDate,TStopUser,TEndDate)=""
	..s TSureStatus="未审核"  
	..s TSelect="0"
	..s TCancelCheckUser=""
	..s TCancelCheckDate=""
	..s JFCFARowid="0",ExamineFlagNum=0
	..f  s JFCFARowid=$o(^DHCJFCheckAdmFee(0,"Adm",TAdm,JFCFARowid))  q:(JFCFARowid="")  d
	...s node1=$p(^DHCJFCheckAdmFee(JFCFARowid),"^",2)
	...q:(node1'=node)
	...s ExamineFlag=$p(^DHCJFCheckAdmFee(JFCFARowid),"^",6)
	...i ExamineFlag="Y"  d
	....s ExamineFlagNum=ExamineFlagNum+1  
	....s TSureStatus="已审核"
	....s TMemSure=$p(^DHCJFCheckAdmFee(JFCFARowid),"^",10)
	....s TSureUser=""
	....s TSureUserDr=$p(^DHCJFCheckAdmFee(JFCFARowid),"^",9)
	....i TSureUserDr'=""  d
	.....s TSureUser=$p(^SSU("SSUSR",TSureUserDr),"^",2)
	....s TSureDate=$p(^DHCJFCheckAdmFee(JFCFARowid),"^",7)
	....i TSureDate'=""  d
	.....s TSureDate=##class(websys.Conversions).DateLogicalToHtml(TSureDate)
	....s TSureTime=$p(^DHCJFCheckAdmFee(JFCFARowid),"^",8)
	....i TSureTime'=""  d
	.....s TSureTime=##class(websys.Conversions).TimeLogicalToHtml(TSureTime,1)
	....s TSureTime=TSureDate_" "_TSureTime
	...e  d
	....s TSureStatus="未审核"
	....s TMemSure=""
	....s TSureUser=""
	....s TSureTime=""
	....s TCancelCheckUser=""
	....s TCancelCheckUserDr=$p(^DHCJFCheckAdmFee(JFCFARowid),"^",21)
	....i TCancelCheckUserDr'=""  d
	.....s TCancelCheckUser=$p(^SSU("SSUSR",TCancelCheckUserDr),"^",2)
	....s TCancelCheckDate=$p(^DHCJFCheckAdmFee(JFCFARowid),"^",19)
	....i TCancelCheckDate'=""  d
	.....s TCancelCheckDate=##class(websys.Conversions).DateLogicalToHtml(TCancelCheckDate)
	....s TCancelCheckTime=$p(^DHCJFCheckAdmFee(JFCFARowid),"^",20)
	....i TCancelCheckTime'=""  d
	.....s TCancelCheckDate=TCancelCheckDate_" "_##class(websys.Conversions).TimeLogicalToHtml(TCancelCheckTime,1)     
	..i ExamineFlagNum>0  d
	...s TSelect="1"	
	...s TSureStatus="已审核"  
	...s TCancelCheckUser=""
	...s TCancelCheckDate=""
	..d OutputRow                             
	..s PrtDate=""
	..s PrtNum=0
	..//f  s PrtDate=$o(^TMP("DHCIPBill","YCFeeCheckAdmDate",EpisodeID,$j,node,PrtDate))  q:(PrtDate="")  d
	..f  s PrtDate=$o(^TMP("DHCIPBill","YCFeeCheckNDate",TOrdEpisodeId,$j,node,PrtDate))  q:(PrtDate="")  d
	...i $d(^TMP("DHCIPBill","AlreadyPBDate",TOrdEpisodeId,$j,node,PrtDate))=0  d
	....s TabnormalDesc=""
	....s TOrderDesc="未找到医嘱"  
	....s InBedDate1=InBedDate
	....s OutDate1=OutDate
	....i TMotherAdm=""  d
	.....s InBedDate1=InBedDate
	.....s OutDate1=OutDate
	....e  d
	.....s BabyAdmdateStr=$g(^TMP("DHCIPBill","BabyAdmInOutDate",TOrdEpisodeId,$j))
	.....i BabyAdmdateStr'=""  d
	......s InBedDate1=$p(BabyAdmdateStr,"^",1)
	......s OutDate1=$p(BabyAdmdateStr,"^",2)  
	....q:PrtDate<InBedDate1
	....q:PrtDate>OutDate1
	....s TStDate=##class(websys.Conversions).DateLogicalToHtml(PrtDate)	
	....s TOrderDoctor=""
	....s TOrderStatus=""
	....s TOrdCatDesc=""
	....s TOrderQty=""
	....s TOrderPrice=""
	....s TOrderAmt=""
	....s TDrugQty=""
	....s TRecLoc=""
	....s TOrderRowid=""
	....s TPBORowid=""
	....s TOrderExecRowid=""
	....s TSelect="0"
	....s TStopDate=""
	....s TStopUser=""
	....s TEndDate=""
	....s TEndTime=""
	....s TCheckFlag="0"
	....s TCancelCheckUser=""
	....s TCancelCheckDate=""
	....d OutputRow                
 	
   k ^TMP("DHCIPBill","YCFeeCheck",EpisodeID,$j)
   k ^TMP("DHCIPBill","YCFeeCheckAdmDate",EpisodeID,$j)
   k ^TMP("DHCIPBill","AlreadyPBDate",EpisodeID,$j)
   k ^TMP("DHCIPBill","OEORDErr",EpisodeID,$j)
   //k ^TMP("DHCIPBill","YCFeeCheckNDate",EpisodeID,$j)
   i BabyFlag="Y"  d
   .s BabyAdmRowid="0"
   .f  s BabyAdmRowid=$o(^PAADMi("Mother",EpisodeID,BabyAdmRowid))  q:(BabyAdmRowid="")  d
   ..k ^TMP("DHCIPBill","YCFeeCheckAdmDate",BabyAdmRowid,$j)
   ..k ^TMP("DHCIPBill","YCFeeCheckNDate",BabyAdmRowid,$j)
   
   Set qHandle=$lb(0,repid,0)
   //k ^TMP("Discon",$i)
   Quit $$$OK
    
OutputRow
   s TOrder="" 
   
   i TOrderRowid'=""  d
   .s TOrder=$p(TOrderRowid,"||",1)
   e  d
   .i TOrderExecRowid'=""  d
   ..s TOrder=$p(TOrderExecRowid,"||",1)
   
   i $g(TOrder)'=""  d
   .s AdmDr=$p(^OEORD(TOrder),"^",1)
   .i AdmDr'=""  d
   ..s TOrdEpisodeId=AdmDr
   ..s MotherAdm=$p(^PAADM(AdmDr),"^",75) 
   ..i MotherAdm'=""  d
   ...s TOrderDesc=TOrderDesc_"(婴儿)" 
   e  d
   .i $g(TOrdEpisodeId)'=""  d
   ..s MotherAdm=$p(^PAADM(TOrdEpisodeId),"^",75)
   ..i MotherAdm'=""  d
   ...s TOrderDesc=TOrderDesc_"(婴儿)"
  
   ///2016-03-14 chenxi 规则10也改成能审核状态
   s tmp="^8^15^"  ;2015-07-13 ZG 13规则可以审核
   i (tmp[("^"_TAbnormalDr_"^")) d
   .s TCheckFlag=0 
   
   q:(sureflag=1)&(TSureStatus'="已审核")
   
   s Data=$lb(TabnormalDesc,TMemDesc,TSureStatus,TAbnormalDr,TSureUser,TSureTime,TAdm,TMemSure,TOrderDesc,TStDate,TOrderDoctor,TOrderStatus,TOrdCatDesc,TOrderQty,TOrderPrice,TOrderAmt,TDrugQty,TRecLoc,TOrderRowid,TPBORowid,TOrderExecRowid,TSelect,TStopDate,TStopUser,TEndDate,TCheckFlag,TCancelCheckUser,TCancelCheckDate,$g(TOrdEpisodeId))
   s ^CacheTemp(repid,ind)=Data
   s ind=ind+1
   q
}

ClassMethod LookUpAbnormalFeeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = LookUpAbnormalFeeExecute ]
{
 	s AtEnd=$li(qHandle,1)
 	s repid=$li(qHandle,2)
 	s ind=$li(qHandle,3)
	//
 	s ind=$o(^CacheTemp(repid,ind))
 	i ind="" {				// if there are no more rows, finish fetching
 		s AtEnd=1
 		s Row=""
 	}
 	else      {				// fetch row
 		s Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod LookUpAbnormalFeeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = LookUpAbnormalFeeExecute ]
{
	s repid=$li(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

/// Creator:        chenxi
/// Creatdate:      2014-09-28
/// Description:    住院病人住院天数相关信息
/// Modify: ZhYW 2017-08-21 
/// Others: 住院天数计算:
///             1)出院患者: 住院天数=出院日期-入院日期
///             2)在院患者: 如果【出院与转科设置】中勾选了【取医生出院时间】
///                 a.如果未开立出院医嘱时, 住院天数=当天-入院日期
///                 b.如果医生开立了出院医嘱(即置上了出院时间), 住院天数=min(出院日期, 当天)-入院日期
///             *备注: 特殊情况如当天入当天出算 1
/// Debug: w ##class(web.DHCIPBillCheckAdmFee).GetAdmBedInfo(940)
ClassMethod GetAdmBedInfo(EpisodeID As %String) As %String
{
	new (EpisodeID)
	set adm = EpisodeID
	quit:(+adm=0) ""
	set PAPERDr=$p(^PAADM(adm),"^",1)
	quit:(+PAPERDr=0) ""
	set PAPERName=$p(^PAPER(PAPERDr,"ALL"),"^",1)
	set PAPERNo=$p(^PAPER(PAPERDr,"PAT",1),"^",1)
	set AdmLocDr=$p(^PAADM(adm),"^",4)	
	set AdmLoc=""
	if (AdmLocDr'="") {
		set AdmLoc=$p(^CTLOC(AdmLocDr),"^",2)
		if ($f(AdmLoc,"-")'=0) {
			set AdmLoc=$p(AdmLoc,"-",2)
		}
	}
	set WardDr=$p($g(^PAADM(adm)),"^",70)
	set WardDesc=""
	if (WardDr'="") {
		set WardDesc=$p(^PAWARD(WardDr),"^",2)
		if ($f(WardDesc,"-")'=0) {
			set WardDesc=$p(WardDesc,"-",2)   
		}
	}
	set BedDr=$p(^PAADM(adm),"^",73)	
	set BedCode=""
	if (BedDr'="")  {
		set BedCode=$p(^PAWARD(+BedDr,"BED",$p(BedDr,"||",2)),"^",1)
	}
	
	set admInOutDateInfo=##class(web.UDHCJFBaseCommon).GetAdmInOutDatebyEpisodeID(adm)
	set admDate=$p(admInOutDateInfo,"^",1)
	set admTime=$p(admInOutDateInfo,"^",2)
	set admDay=$p(admInOutDateInfo,"^",3)
	set disDate=$p(admInOutDateInfo,"^",4)
	set disTime=$p(admInOutDateInfo,"^",5)
	if (disDate=""){
		set disDate = +$h
	}
	set admDate=##class(websys.Conversions).DateLogicalToHtml(admDate)      //入院日期
	set disDate=##class(websys.Conversions).DateLogicalToHtml(disDate)      //出院日期
	
	set AdmInfo=PAPERDr_"^"_PAPERName_"^"_PAPERNo_"^"_AdmLocDr_"^"_AdmLoc_"^"_WardDr_"^"_WardDesc_"^"_BedDr_"^"_BedCode_"^"_admDate_"^"_disDate_"^"_admDay 
	
	quit AdmInfo
}

/// 测试方法。
/// w ##class(web.DHCIPBillCheckAdmFee).InsertCheckOETest()
ClassMethod InsertCheckOETest()
{
	
	 
	s InsertCheckOE="InsertCheckOE"
	
 	d ..InsertCheckOE(^TMPzg(InsertCheckOE,0),^TMPzg(InsertCheckOE,1),^TMPzg(InsertCheckOE,2),^TMPzg(InsertCheckOE,3))
}

/// creator:        chenxi
/// creatdate:      2014-10-09
/// description:    住院费用审核
/// w ##class(web.DHCIPBillCheckAdmFee).InsertCheckOE("","965||22")
ClassMethod InsertCheckOE(EpisodeID, CheckeStr, Memo, Guser)
{
   n (EpisodeID,CheckeStr,Memo,Guser)
   q:(+EpisodeID=0) "AdmNull"
   q:(CheckeStr="") "OEORINull"
   q:(Guser="") "UserNull"
   s CurDate=+$h
   s CurTime=$p($h,",",2)
   s RetCode=0
   ;s ^TMPzg("InsertCheckOE",0)=EpisodeID
   s ^TMPzg("InsertCheckOE",1)=CheckeStr
   ;s ^TMPzg("InsertCheckOE",2)=Memo
   ;s ^TMPzg("InsertCheckOE",3)=Guser
   
   
   TStart
   s LCheckeStr=$l(CheckeStr,"!!")
   ///CheckStr=TOrderRowid+"^"+TPBORowid+"^"+TOrderExecRowid+"^"+TAbnormalDr;   
   s ExamineFlag="Y"
   f CheckeStrNum=1:1:LCheckeStr  q:(RetCode'=0)  d
   .s CheckeStr1=$p(CheckeStr,"!!",CheckeStrNum)
   .q:(CheckeStr1="") 
   .s OrderRowid=$p(CheckeStr1,"^",1)
   .s TOrderExecRowid=$p(CheckeStr1,"^",3)
   .///q:(OrderRowid="")
   .s OrderBillFlag=""
   .///modify 2015-03-02 
   .i TOrderExecRowid'=""  d
   ..s OrderBillFlag=$p(^OEORD(+TOrderExecRowid,"I",$p(TOrderExecRowid,"||",2),"X",$p(TOrderExecRowid,"||",3)),"^",6)
   .q:(OrderBillFlag="P")
   .s TPBORowid=$p(CheckeStr1,"^",2)   
   .s TAbnormalDr=$p(CheckeStr1,"^",4)
   .s TOrdEpisodeId=$p(CheckeStr1,"^",5)
   .i +TOrdEpisodeId=0  d
   ..s TOrdEpisodeId=EpisodeID  
   .i TAbnormalDr=""  d
   ..s RetCode=101
   .q:(RetCode'=0)
   .s JFCAFRowid="0",CheckNum=0
   .i TOrderExecRowid'=""  d
   ..f  s JFCAFRowid=$o(^DHCJFCheckAdmFee(0,"Oeore",TOrderExecRowid,JFCAFRowid))  q:(JFCAFRowid="")!(RetCode'=0)  d 
   ...s OldExamineFlag=$p(^DHCJFCheckAdmFee(JFCAFRowid),"^",6)
   ...q:(OldExamineFlag'="Y")
   ...s CheckNum=CheckNum+1
   .e  i OrderRowid'=""  d
   ..f  s JFCAFRowid=$o(^DHCJFCheckAdmFee(0,"Oeori",OrderRowid,JFCAFRowid))  q:(JFCAFRowid="")!(RetCode'=0)  d 
   ...s OldExamineFlag=$p(^DHCJFCheckAdmFee(JFCAFRowid),"^",6)
   ...q:(OldExamineFlag'="Y")
   ...s CheckNum=CheckNum+1
   .e  d
   ..f  s JFCAFRowid=$o(^DHCJFCheckAdmFee(0,"Adm",TOrdEpisodeId,JFCAFRowid))  q:(JFCAFRowid="")!(RetCode'=0)  d 
   ...s CAFAbnormalDr=$p(^DHCJFCheckAdmFee(JFCAFRowid),"^",2)
   ...q:(CAFAbnormalDr'=TAbnormalDr)
   ...s CAFOEORE=$p(^DHCJFCheckAdmFee(JFCAFRowid),"^",4)
   ...q:(CAFOEORE'="")
   ...s OldExamineFlag=$p(^DHCJFCheckAdmFee(JFCAFRowid),"^",6)
   ...q:(OldExamineFlag'="Y")
   ...s CheckNum=CheckNum+1
   .i CheckNum=0  d
   ..k PLIST
   ..s PLIST(1)=""
   ..s PLIST(2)=TOrdEpisodeId  
   ..s PLIST(3)=TAbnormalDr  
   ..s PLIST(4)=OrderRowid 
   ..s PLIST(5)=TOrderExecRowid 
   ..s PLIST(6)=TPBORowid 
   ..s PLIST(7)=ExamineFlag 
   ..s PLIST(8)=CurDate 
   ..s PLIST(9)=CurTime 
   ..s PLIST(10)=Guser
   ..s PLIST(11)=Memo
   ..&sql(INSERT INTO DHC_JFCheckAdmFee Values PLIST())
   ..s RetCode=RetCode+SQLCODE
   
   
    
   i RetCode=0  d
   .tcommit
   e  d
   .trollback
   
   q RetCode
}

Query LookUpAbnormal() As %Query(ROWSPEC = "TabnormalDesc:%String,TAbnormalDr:%String")
{
}

ClassMethod LookUpAbnormalExecute(ByRef qHandle As %Binary) As %Status
{
 	s repid=$i(^CacheTemp)
 	s ind=1
 	//d ##class(%ResultSet).RunQuery("web.DHCIPBillCheckAdmFee","LookUpAbnormalFee",3750112,"","","","","","","","","")
	s TabnormalDesc="全部"	
	s TAbnormalDr="0"
	d OutputRow1
	
	s TAbnormalDr=""
	f  s TAbnormalDr=$o(^DHCCAbFeeConfig("YCFeeCheck",TAbnormalDr))  q:(TAbnormalDr="")  d
	.s CAbFeeConfig=$g(^DHCCAbFeeConfig("YCFeeCheck",TAbnormalDr))
	.q:(CAbFeeConfig="")
	.s TabnormalDesc=$p(CAbFeeConfig,"^",3)    
    .d OutputRow1 
	
   s qHandle=$lb(0,repid,0)
   //k ^TMP("Discon",$i)
   q $$$OK
    
OutputRow1
   s Data=$lb(TabnormalDesc,TAbnormalDr)
   s ^CacheTemp(repid,ind)=Data
   s ind=ind+1
   q
}

ClassMethod LookUpAbnormalFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = LookUpAbnormalExecute ]
{
 	s AtEnd=$li(qHandle,1)
 	s repid=$li(qHandle,2)
 	s ind=$li(qHandle,3)
	//
 	s ind=$o(^CacheTemp(repid,ind))
 	i ind="" {				// if there are no more rows, finish fetching
 		s AtEnd=1
 		s Row=""
 	}
 	else      {				// fetch row
 		s Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod LookUpAbnormalClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = LookUpAbnormalExecute ]
{
	s repid=$li(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

/// creator:        chenxi
/// creatdate:      2014-10-09
/// description:    撤销住院费用审核
ClassMethod CancelCheckOE(EpisodeID, CancelStr, Guser)
{
   n (EpisodeID,CancelStr,Guser)
   q:(+EpisodeID=0) "AdmNull"
   q:(CancelStr="") "OEORINull"
   q:(Guser="") "UserNull"
   s CurDate=+$h
   s CurTime=$p($h,",",2)
   s RetCode=0
   
   TStart
   s LCancelStr=$l(CancelStr,"!!")
   ///CheckStr=TOrderRowid+"^"+TPBORowid+"^"+TOrderExecRowid+"^"+TAbnormalDr;   
   s ExamineFlag="N"
   f CancelStrNum=1:1:LCancelStr  q:(RetCode'=0)  d
   .s CancelStr1=$p(CancelStr,"!!",CancelStrNum)
   .q:(CancelStr1="") 
   .s OrderRowid=$p(CancelStr1,"^",1)
   .///q:(OrderRowid="")
   .s OrderBillFlag=""
   .s TOrderExecRowid=$p(CancelStr1,"^",2)
   .s TAbnormalDr=$p(CancelStr1,"^",3)
   .i TAbnormalDr=""  d
   ..s RetCode=101
   .q:(RetCode'=0) 
   .///modify 2015-03-02 
   .i TOrderExecRowid'=""  d
   ..s OrderBillFlag=$p(^OEORD(+TOrderExecRowid,"I",$p(TOrderExecRowid,"||",2),"X",$p(TOrderExecRowid,"||",3)),"^",6)
   .q:(OrderBillFlag="P")
   .s JFCAFRowid="0"
   .i TOrderExecRowid'=""  d
   ..f  s JFCAFRowid=$o(^DHCJFCheckAdmFee(0,"Oeore",TOrderExecRowid,JFCAFRowid))  q:(JFCAFRowid="")!(RetCode'=0)  d 
   ...s OldExamineFlag=$p(^DHCJFCheckAdmFee(JFCAFRowid),"^",6)
   ...q:(OldExamineFlag'="Y")
   ...&sql(update DHC_JFCheckAdmFee 
         set JFCAF_UpDate=:CurDate ,JFCAF_UpTime=:CurTime,JFCAF_UpUser=:Guser,JFCAF_ExamineFlag=:ExamineFlag,
             JFCAF_CancelUser_Dr=:Guser,JFCAF_CancelDate=:CurDate,JFCAF_CancelTime=:CurTime
         where JFCAF_Rowid=:JFCAFRowid )
   ...s RetCode=RetCode+SQLCODE
   .e  i OrderRowid'=""  d
   ..f  s JFCAFRowid=$o(^DHCJFCheckAdmFee(0,"Oeori",OrderRowid,JFCAFRowid))  q:(JFCAFRowid="")!(RetCode'=0)  d 
   ...s OldExamineFlag=$p(^DHCJFCheckAdmFee(JFCAFRowid),"^",6)
   ...q:(OldExamineFlag'="Y")
   ...&sql(update DHC_JFCheckAdmFee 
         set JFCAF_UpDate=:CurDate ,JFCAF_UpTime=:CurTime,JFCAF_UpUser=:Guser,JFCAF_ExamineFlag=:ExamineFlag,
             JFCAF_CancelUser_Dr=:Guser,JFCAF_CancelDate=:CurDate,JFCAF_CancelTime=:CurTime
         where JFCAF_Rowid=:JFCAFRowid )
   ...s RetCode=RetCode+SQLCODE
   .e  d
   ..s BabyStr=##class(web.DHCIPBillCashier).GetBabyAdm(EpisodeID)
   ..s EpisodeIDStr=EpisodeID_"^"_BabyStr
   ..f j=1:1:$l(EpisodeIDStr,"^") d
   ...s tEpisodeID=$p(EpisodeIDStr,"^",j)
   ...q:+$g(tEpisodeID)=0
   ...f  s JFCAFRowid=$o(^DHCJFCheckAdmFee(0,"Adm",tEpisodeID,JFCAFRowid))  q:(JFCAFRowid="")!(RetCode'=0)  d 
   ....s CAFAbnormalDr=$p(^DHCJFCheckAdmFee(JFCAFRowid),"^",2)
   ....q:(CAFAbnormalDr'=TAbnormalDr)
   ....s CAFOEORE=$p(^DHCJFCheckAdmFee(JFCAFRowid),"^",4)
   ....q:(CAFOEORE'="")
   ....&sql(update DHC_JFCheckAdmFee 
          set JFCAF_UpDate=:CurDate ,JFCAF_UpTime=:CurTime,JFCAF_UpUser=:Guser,JFCAF_ExamineFlag=:ExamineFlag,
             JFCAF_CancelUser_Dr=:Guser,JFCAF_CancelDate=:CurDate,JFCAF_CancelTime=:CurTime
          where JFCAF_Rowid=:JFCAFRowid )
   ....s RetCode=RetCode+SQLCODE
   
   i RetCode=0  d
   .tcommit
   e  d
   .trollback
   
   q RetCode
}

/// creator:      chenxi
/// creatdate:    2014-09-09
/// Descript：    出院结算前或医嘱费用查询时根据账单号和就诊rowid 判断病人费用是否有问题。CheckFlag:"PAY"--结算，根据账单判断  "search"--查询
///              BillFlag: "Old"-- 老账单程序(医嘱没有执行记录)，"New"--新账单程序(7.0 之后版本滚执行记录而不是医嘱)
///              病人已做最终结算：
///              1、	检验检查存在核实未执行医嘱
///              2、	病人出院后账单中床位费与实际天数不符
///              无论病人是否做过最终结算都需判断
///              1、	分次发药，计费时只收了部分发药的费用 
///              2、	医嘱未插入执行记录  
///              3、	账单不平 
///              4、    病人结算的账单里如果有空账单则删除            
/// w ##class(web.DHCIPBillCheckAdmFee).AdmSettlementCheck(EpisodeId, Billno, CheckFlag, BillFlag)  
/// w ##class(web.DHCIPBillCheckAdmFee).AdmSettlementCheck(561,229265, "PAY", "New")      
ClassMethod AdmSettlementCheck(EpisodeId, Billno, CheckFlag, BillFlag)
{
   n (EpisodeId,Billno,CheckFlag,BillFlag)
   q:(+EpisodeId=0) ""
   q:(+Billno="") ""
   
   s job=$j
   
   k ^TMP("DHCIPBill","NORDExec",EpisodeId,$j)     ///没有执行记录的医嘱
   k ^TMP("DHCIPBill","TCDrug",EpisodeId,$j)       ///没有发药的医嘱
   k ^TMP("DHCIPBill","PBDrugErr",EpisodeId,$j)    ///发药数量与账单数量不对的医嘱
   k ^TMP("DHCIPBill","NBillOrd",EpisodeId,$j)    ///未计费医嘱
   k ^TMP("DHCIPBill","BillSumErr",EpisodeId,$j)    ///此次就诊账单表不平的账单
   k ^TMP("DHCIPBill","OrdBillSumErr",EpisodeId,$j)    ///此次就诊账单表不平的医嘱
   k ^TMP("DHCIPBill","BillBedErr",EpisodeId,$j)    ///
   k ^TMP("DHCIPBill","PBNegativeNum",EpisodeId,$j)    /// 此账单账单数量为负数的医嘱
   
  s ErrStr=""
    
   ///判断病人的医嘱是否有问题
   s OrdErrStr=..AdmOeOrdCheck(EpisodeId,Billno,BillFlag)
   
   ///modify 2014-09-09 判断病人账单费用是否有问题，判断病人床位费是否和住院天数相符
   s BillBedQtySum=0,PBFeeErrNumSum=0,PBOrdFeeErrNumsum=0,PBNegativeNum=0
   ///s PBRowid="0"
   ///f  s PBRowid=$o(^DHCPB(0,"ADM",EpisodeId,PBRowid))  q:(PBRowid="")  d  
   .///s BillErrStr=..AdmBillCheck(EpisodeId,Billno,CheckFlag)
   .///s PBFeeErrNum=$p(BillErrStr,"^",2)
   .///s PBOrdFeeErrNum=$p(BillErrStr,"^",3)
   .///s PBFeeErrNumSum=PBFeeErrNumSum+PBFeeErrNum 
   .///s PBOrdFeeErrNumsum=PBOrdFeeErrNumsum+BillBedQtySum 
   
   s BillErrStr=..AdmBillCheck(EpisodeId,Billno,CheckFlag)
   s PBFeeErrNum=$p(BillErrStr,"^",1)
   s PBOrdFeeErrNum=$p(BillErrStr,"^",2)
   s PBNegativeNum=$p(BillErrStr,"^",3)
   
    
   
   b ; w OrdErrStr
   
   ///进程号^7.0后版本没有执行记录^核实状态医嘱没有计费^没有发药医嘱^发药数量与计费数量不一致^缺少床位的天数^缺少护理费的天数^缺少诊查费的天数^缺少伙食费的天数^缺少取暖费的天数^手术申请是否有手术医嘱^手术申请是否有麻醉医嘱^费用不平的账单数量^费用不平的医嘱数量^账单数量小于0
   s ErrStr=job_"^"_OrdErrStr_"^"_PBFeeErrNum_"^"_PBOrdFeeErrNum_"^"_PBNegativeNum
   
   q ErrStr
}

/// creator:      chenxi
/// creatdate:    2014-11-13
/// Descript：    判断婴儿医嘱是否有问题
ClassMethod GetBabySettlementCheck(MotherAdm, BillNo, CheckFlag, BillFlag)
{
	s RetStr=""
	s BabyAdmRowID=""
	f  s BabyAdmRowID=$o(^PAADMi("Mother",MotherAdm,BabyAdmRowID)) q:BabyAdmRowID=""  d
	.s RetStr1=..AdmSettlementCheck(BabyAdmRowID, BillNo, CheckFlag, BillFlag)
	.s BabyPAERDr=$p(^PAADM(BabyAdmRowID),"^",1)
	.s BabyName=""
	.i BabyPAERDr'=""  d
	..s BabyName=$p(^PAPER(BabyPAERDr,"ALL"),1)
	.i RetStr=""  d
	..s RetStr=BabyName_$c(2)_RetStr1
	.e  d
	..s RetStr=RetStr_$c(3)_BabyName_$c(2)_RetStr1 
	q RetStr
}

/// creator:      chenxi
/// creatdate:    2014-09-09
/// Descript：    判断病人的医嘱是否有问题
///              1、	医嘱未插入执行记录
///              2、	检验检查存在核实未执行医嘱
///              3、    药品医嘱收费数量与发药数量不一致
ClassMethod AdmOeOrdCheck(EpisodeId, Billno, BillFlag)
{
   n (EpisodeId,Billno,BillFlag)
   q:(+EpisodeId=0) ""
   
   s OEOrdDr=$o(^OEORD(0,"Adm",EpisodeId,""))
   q:(OEOrdDr="") "0^0^0^0^0^0^0^0^0^0^0"
   
   //b ///2err
   s Conf=""
   s Conf=$o(^DHCTarC("CF",Conf))
   s DefaultCP=$p(^DHCTarC("CF",Conf),"^",9)
   i DefaultCP="" s DefaultCP="OD"
   s OrdNExecDNum=0   ///7.0 之后医嘱执行记录表没有数据的
   s OrdNExecSNum=0   ///核实医嘱未计费
   s NDrugNum=0       ///未发药医嘱
   s PBDrugErrNum=0   ///药品医嘱与计费数量不一致
   
   s VisitStatus=$p(^PAADM(EpisodeId),"^",20)
   
   //系统的入院日 入床日 以及统计组的入床日 护管的入床日 四个日期 优先级递增
   //入院日
   s InBedDate1=$p(^PAADM(EpisodeId),"^",6)
   //入床日
   s firsttransbed=0
   s tran="" f  s tran=$o(^PAADM(EpisodeId,"TRANS",tran)) q:tran=""  d
   .q:firsttransbed=1
   .s tranbeddr=$p(^PAADM(EpisodeId,"TRANS",tran),"^",8)
   .i tranbeddr'="" d
   ..s firsttransbed=1
   ..s InBedDate1=$p(^PAADM(EpisodeId,"TRANS",tran),"^",1)
   //统计组的入床日
   i $d(^DHCMRIPDetail(0,"TYPE","RYRS","ADM",EpisodeId)) d
   .s iprowid=0 f  s iprowid=$o(^DHCMRIPDetail(0,"TYPE","RYRS","ADM",EpisodeId,iprowid)) q:iprowid=""  d
   ..s MRIPDayDr=$p(^DHCMRIPDetail(iprowid),"^",3)
   ..s InBedDate1=$p(^MRIPdaily(MRIPDayDr),"^",6)
   //护管程序的入床日
   ///2016-03-02 chenxi 此日期为体温单中入院事件的日期，费用核查中不应取此日期
   ///s QTRECRowID=$o(^DHCADMQTREC("adm",EpisodeId,""))
   ///i $g(QTRECRowID)'="" d
   .///s InBedDate1=$p(^DHCADMQTREC("QTREC",QTRECRowID),"^",2)
   s InBedDate=$zd(InBedDate1,4) //入院日期
   
	
   //医疗结算日期
   s OutDate1=$p(^PAADM(EpisodeId),"^",59)
   //最终结算日期
   i OutDate1="" s OutDate1=$p(^PAADM(EpisodeId),"^",17)   
   i OutDate1=""  s OutDate1=+$h 
  
   //b  ////计算需收床位费、诊查费、护理费的医嘱
   k ^TMP("DHCIPBill","NeedChargeOrd",EpisodeId,$j)
   k ^TMP("DHCIPBill","AlreadyPBDate",EpisodeId,$j)
   k ^TMP("DHCIPBill","LackDateOrd",EpisodeId,$j)
   k ^TMP("DHCIPBill","OPAlreadyOE",EpisodeId,$j)  
   
   ///modify 2014-10-10 判断病人是否做过手术
	s ssflag=0,ssordflag=0,opdescs=""
	s op="" f  s op=$o(^DHCANOPArrange(0,"Adm",EpisodeId,op)) q:op=""  d
	.s opstatus=$p(^DHCANOPArrange(op),"^",27)
	.q:(opstatus="A")!(opstatus="D")!(opstatus="N")
	.s arrdate=$p(^DHCANOPArrange(op),"^",7)
	.s arrtime=$p(^DHCANOPArrange(op),"^",8)
	.s arrusr=$p(^DHCANOPArrange(op),"^",9)
	.q:(arrdate="")!(arrusr="")
	.s ssflag=1
	.///s arrdate=$zd(arrdate,3)
	.///s anaId=$P($G(^DHCANOPArrange(op)),"^",2)
	.///s anaSub=$P(anaId,"||",2)
	.///s anaopSub="" f  s anaopSub=$O(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub)) q:(anaopSub="")||(+anaopSub=0)  d
	..///s opDr=$P($G(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub)),"^",6)
	..///i opDr'=""  s opdesc=$P($G(^ORC("OPER",operDr)),"^",2)
	..///e  s opdesc=""
	..///i opdescs="" s opdescs=arrdate_"|"_opdesc
	..///e  s opdescs=opdescs_"|"_arrdate_"|"_opdesc
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////
   
   
   ///s OutDate1=63141
   s TAbnormalDr=""
   f  s TAbnormalDr=$o(^DHCCAbFeeConfig("YCFeeCheck",TAbnormalDr))  q:(TAbnormalDr="")  d
   .s CAbFeeConfig=$g(^DHCCAbFeeConfig("YCFeeCheck",TAbnormalDr))
   .q:(CAbFeeConfig="")
   .s useflag=$p(CAbFeeConfig,"^",4)
   .s NormalDesc=$p(CAbFeeConfig,"^",3)
   .q:(useflag="0")&(TAbnormalDr'=10)&(TAbnormalDr'=8)&(TAbnormalDr'=13)  //停用 
   .f PrtDate=InBedDate1:1:OutDate1  d   
   ..i (TAbnormalDr=1)!(TAbnormalDr=2)!(TAbnormalDr=5)!(TAbnormalDr=6)  d 
   ...s ^TMP("DHCIPBill","NeedChargeOrd",EpisodeId,$j,TAbnormalDr,PrtDate)=""
   ..i TAbnormalDr=7   d
   ...s ktfstart=$p(NormalDesc,"|",2)
   ...s ktfend=$p(NormalDesc,"|",3)
   ...s ktfstart=$zdh(ktfstart,3)
   ...s ktfend=$zdh(ktfend,3)  
   ...f PrtDate=ktfstart:1:ktfend  d
   ....q:(PrtDate>OutDate1)
   ....q:(PrtDate<InBedDate1)
   ....s ^TMP("DHCIPBill","NeedChargeOrd",EpisodeId,$j,TAbnormalDr,PrtDate)=""	
    
   
   s PhOutFlag=##class(web.UDHCJFBILL).GetPhOutFlag()
   s OEORDDr="0"
   f  s OEORDDr=$o(^OEORD(0,"Adm",EpisodeId,OEORDDr))  q:(OEORDDr="")  d 
   .s OEORIDr="0"
   .f  s OEORIDr=$o(^OEORD(OEORDDr,"I",OEORIDr))  q:(OEORIDr="")  d
   ..q:($d(^OEORD(+OEORDDr,"I",OEORIDr,1))=0)
   ..s ExecNum=0,NFirstQty=0,DisPTCSum=0
   ..s OEOrdRowID=OEORDDr_"||"_OEORIDr
   ..s ArcimRowid=$p(^OEORD(OEORDDr,"I",OEORIDr,1),"^",2)
   ..q:(ArcimRowid="")
   ..s ArcItemCatDr=$p($g(^ARCIM(+ArcimRowid,$p(ArcimRowid,"||",2),1)),"^",10)
   ..q:(ArcItemCatDr="")
   ..s StDate=$p(^OEORD(OEORDDr,"I",OEORIDr,1),"^",9)
   ..s OrdCateType=$p(^ARC("IC",ArcItemCatDr),"^",7)
   ..s OecCatDr=$p(^ARC("IC",ArcItemCatDr),"^",8)
   ..s OEORIQty=$p(^OEORD(OEORDDr,"I",OEORIDr,1),"^",18)   ////医嘱首日次数，首日次数为0不插入打包表和医嘱执行记录表 
   ..s OEORIOEORIDr=""
   ..s OEORIOEORIDr=$p($g(^OEORD(OEORDDr,"I",OEORIDr,11)),"^",39)
   ..s MOrdType="",MOrdQty="",MArcimDr="",MItemCatDr=""
   ..i OEORIOEORIDr'=""  d
   ...s MArcimDr=$p(^OEORD(+OEORIOEORIDr,"I",$p(OEORIOEORIDr,"||",2),1),"^",2)
   ...s MItemCatDr=$p(^ARCIM(+MArcimDr,$p(MArcimDr,"||",2),1),"^",10) 
   ...i MItemCatDr'=""  d
   ....s MOrdType=$p(^ARC("IC",MItemCatDr),"^",7)
   ....s MOrdQty=$p(^OEORD(+OEORIOEORIDr,"I",$p(OEORIOEORIDr,"||",2),1),"^",18)   
   ..q:(OecCatDr="")
   ..s Condition=$o(^DHCTarC("BC",0,ArcItemCatDr,""))	
   ..i Condition'="" s CP=$p(^DHCTarC("BC",Condition),"^",2)
   ..e  s CP=DefaultCP
   ..s OEPriorDr=$p($g(^OEORD(OEORDDr,"I",OEORIDr,1)),"^",8)
   ..s OEPriorCode=""
   ..i OEPriorDr'=""  d
   ...s OEPriorCode=$p(^OECPR(OEPriorDr),"^",1)  
   ..q:(OEPriorCode["OM")   
   ..i (PhOutFlag="N")&(OEPriorCode="OUT") s CP="OD"
   ..i (CP="CR")&(OrdCateType="R") d
   ...s LinkFlag=##class(web.UDHCJFBILL).GetUserLocLinkRecLoc(OEOrdRowID)
   ...i LinkFlag="Y" s CP="OD"
   ..///判断病人做了手术申请是否有补录相关医嘱  控制点9,11
   ..s ItmStatDr=$p(^OEORD(OEORDDr,"I",OEORIDr,1),"^",13)
   ..q:(ItmStatDr="")
   ..s StatCode=$p(^OEC("OSTAT",ItmStatDr),"^",1)
   ..i (StatCode="V")!(StatCode="E")  d
   ...i $d(^DHCCAbFeeConfig("Details",9,"OECCAT",OecCatDr))'=0  d
   ....s ^TMP("DHCIPBill","OPAlreadyOE",EpisodeId,$j,9,OEOrdRowID)=""
   ...i $d(^DHCCAbFeeConfig("Details",9,"ARCIC",ArcItemCatDr))'=0  d
   ....s ^TMP("DHCIPBill","OPAlreadyOE",EpisodeId,$j,9,OEOrdRowID)=""
   ...i $d(^DHCCAbFeeConfig("Details",9,"ARCIM",ArcimRowid))'=0  d
   ....s ^TMP("DHCIPBill","OPAlreadyOE",EpisodeId,$j,9,OEOrdRowID)=""
   ...i $d(^DHCCAbFeeConfig("Details",11,"OECCAT",OecCatDr))'=0  d
   ....s ^TMP("DHCIPBill","OPAlreadyOE",EpisodeId,$j,11,OEOrdRowID)=""
   ...i $d(^DHCCAbFeeConfig("Details",11,"ARCIC",ArcItemCatDr))'=0  d
   ....s ^TMP("DHCIPBill","OPAlreadyOE",EpisodeId,$j,11,OEOrdRowID)=""
   ...i $d(^DHCCAbFeeConfig("Details",11,"ARCIM",ArcimRowid))'=0  d
   ....s ^TMP("DHCIPBill","OPAlreadyOE",EpisodeId,$j,11,OEOrdRowID)=""
   ..i BillFlag="New"  d
   ...s OEOREDr="0",ExecNum=0
   ...f  s OEOREDr=$o(^OEORD(OEORDDr,"I",OEORIDr,"X",OEOREDr))  q:(OEOREDr="")  d
   ....s ExecNum=ExecNum+1
   ....s OEOREStDate=$p(^OEORD(OEORDDr,"I",OEORIDr,"X",OEOREDr),"^",1)	
   ....///i (OrdCateType="R")&(OEOREStDate'=StDate)&(ExecNum=1)&(+OEORIQty'=0)  d
   .....///s NFirstQty=NFirstQty+1 
   ....///i (MOrdType="R")&(OEOREStDate'=StDate)&(ExecNum=1)&(+MOrdQty'=0)  d
   .....///s NFirstQty=NFirstQty+1   
   ....i (OEPriorCode="S")!(OEPriorCode="OMST")  d
   .....i (OEOREStDate'=StDate)&(ExecNum=1)&(OEORIQty'=0)&(OEORIOEORIDr="")  d
   ......s NFirstQty=NFirstQty+1 
   .....i (MOrdType="R")&(OEOREStDate'=StDate)&(ExecNum=1)&(+MOrdQty'=0)&(OEORIOEORIDr'="")  d
   ......s NFirstQty=NFirstQty+1	
   ....e  d
   .....i (OEOREStDate'=StDate)&(ExecNum=1)  d
   ......s NFirstQty=NFirstQty+1    
   ....s OEORERowID=OEORDDr_"||"_OEORIDr_"||"_OEOREDr   
   ....s Billed=$p(^OEORD(OEORDDr,"I",OEORIDr,"X",OEOREDr),"^",6)
   ....s ItemStatDr=$p($g(^OEORD(OEORDDr,"I",OEORIDr,"X",OEOREDr,"BILL")),"^",1)
   ....s ItemStatCode=""
   ....i ItemStatDr'=""  d
   .....s ItemStatCode=$p(^OEC("OSTAT",ItemStatDr),"^",1)    
   ....i (ItemStatCode="V")!(ItemStatCode="E")  d
   .....s qflag="0"  
   .....i $d(^DHCCAbFeeConfig("Details",10,"OECCAT",OecCatDr))'=0  d
   ......s qflag="1"
   .....i $d(^DHCCAbFeeConfig("Details",10,"ARCIC",ArcItemCatDr))'=0  d
   ......s qflag="1"
   .....i $d(^DHCCAbFeeConfig("Details",10,"ARCIM",ArcimRowid))'=0  d
   ......s qflag="1"
   .....s CheckFlag=..GetCheckFlag(EpisodeId,"",OEOrdRowID)
   .....s PBNum=0
   .....s PBNum=..GetOrdPBNumNew(OEORERowID)   
   .....i (qflag="1")&((Billed="TB")!(PBNum=0))&(VisitStatus="D")  d
   ......i ((CheckFlag'="Y")&((ItemStatCode="V")!(ItemStatCode="E")))  d
   .......s ^TMP("DHCIPBill","NBillOrd",EpisodeId,$j,OEORDDr,OEORIDr,OEOREDr)=Billed   
   .......s OrdNExecSNum=OrdNExecSNum+1  
   ....;对于 1,2,5,6,7规则的处理。
	....s node=""
	....f  s node=$o(^DHCCAbFeeConfig("YCFeeCheck",node))  q:(node="")  d
	.....s espression=$g(^DHCCAbFeeConfig("YCFeeCheck",node))
	.....s useflag=$p(espression,"^",4)
	.....q:(useflag=0)&(node'=10)&(node'=8)&(node'=13)&(node'=14)&(node'=15)  // 这几个规则不允许被停用。[停用无效]
	.....s qflag="0"
	.....i $d(^DHCCAbFeeConfig("Details",node,"OECCAT",OecCatDr))'=0  d
	......s qflag="1"
	.....i $d(^DHCCAbFeeConfig("Details",node,"ARCIC",ArcItemCatDr))'=0  d
	......s qflag="1"
	.....i $d(^DHCCAbFeeConfig("Details",node,"ARCIM",ArcimRowid))'=0  d
	......s qflag="1"	
	.....s OEOREStDate=$p(^OEORD(OEORDDr,"I",OEORIDr,"X",OEOREDr),"^",1)	
	.....i ((node=1)!(node=2)!(node=5)!(node=6)!(node=7))&(qflag="1")  d
	......s ^TMP("DHCIPBill","AlreadyPBDate",EpisodeId,$j,node,OEOREStDate)=""  	;收费天数与住院天数是否一致:存收费天数的global。
    .....i ((CP="CR")&(OrdCateType="R")&(qflag="1")&(node=10)&((ItemStatCode="V")!(ItemStatCode="E"))) d
    ......s CheckFlag=..GetCheckFlag(EpisodeId,"",OEOrdRowID)
    ......s DispTCInfo=..GetTCDspNew(OEORERowID)  ;取未发放的药品的数量
    ......s DisPTCQty=$p(DispTCInfo,"^",1)
    ......s DisPTCSum=DisPTCSum+(+DisPTCQty)
    ......i (+DisPTCQty'=0)&(CheckFlag'="Y") d
    .......s ^TMP("DHCIPBill","TCDrug",EpisodeId,$j,OEORDDr,OEORIDr,OEOREDr)=DisPTCQty    
    .......s NDrugNum=NDrugNum+1
    .....i ((CP="CR")&(OrdCateType="R")&(qflag="1")&(node=8)) d
    ......s PBDrugErrStr=..GetOrdDispNew(OEOrdRowID,OEORERowID)
    ......s PBDrugNum=$p(PBDrugErrStr,"^",2)
    ......s DSPdrugNum=$p(PBDrugErrStr,"^",1)
    ......///2015-02-19 chenxi 增加判断，在《住院费用监控配置》中 规则8 未配置的大类、子类、或医嘱项不检测
    ......///现在有些医院有免费药的概念，此类药品发药但是不收费   
    ......s DrugNumCheckFlag=$p(PBDrugErrStr,"^",3)   
    ......i (PBDrugNum'=DSPdrugNum)&(DrugNumCheckFlag="Y") d
    .......s PBDrugErrNum=PBDrugErrNum+1
    .......s ^TMP("DHCIPBill","PBDrugErr",EpisodeId,$j,OEORDDr,OEORIDr,OEOREDr)=PBDrugErrStr
    .....i ((CP="OD")&(OrdCateType="R")&(qflag="1")&(node=10)&((ItemStatCode="V")!(ItemStatCode="E"))) d
    ......s CheckFlag=..GetCheckFlag(EpisodeId,"",OEOrdRowID)
    ......s PBDrugErrStr=..GetODOrdDispNew(OEOrdRowID,OEORERowID)
    ......s PBDrugNum=$p(PBDrugErrStr,"^",2)
    ......s DSPdrugNum=$p(PBDrugErrStr,"^",1)   
    ......i (PBDrugNum'=DSPdrugNum)&(CheckFlag'="Y") d
    .......s PBDrugErrNum=PBDrugErrNum+1
    .......s ^TMP("DHCIPBill","PBDrugErr",EpisodeId,$j,OEORDDr,OEORIDr,OEOREDr)=PBDrugErrStr   
    ...s NExecFlag="Y"
   ...s NExecFlag=..CheckOrdAllowNExec(OEOrdRowID)
   ...i NExecFlag'="Y"  d
   ....;判断是否审核。
   ....s CheckFlag=..GetCheckFlag(EpisodeId,"",OEOrdRowID)
   ....i CheckFlag'="Y" d
   .....s OrdNExecDNum=OrdNExecDNum+1
   ....s ^TMP("DHCIPBill","NORDExec",EpisodeId,$j,OEORDDr,OEORIDr)=""       
   ..e  d
   ...///modify 2014-10-14 判断床位费、诊查费、护理费等是否缺医嘱////////////////////////////////////////////////////////////////////////////////////////////////////// 
   ...s StDate=$p($g(^OEORD(OEORDDr,"I",OEORIDr,1)),"^",9)
   ...s TAbnormalDr=""
   ...f  s TAbnormalDr=$o(^DHCCAbFeeConfig("YCFeeCheck",TAbnormalDr))  q:(TAbnormalDr="")  d
   ....s CAbFeeConfig=$g(^DHCCAbFeeConfig("YCFeeCheck",TAbnormalDr))
   ....q:(CAbFeeConfig="")
   ....s useflag=$p(CAbFeeConfig,"^",4)
   ....q:(useflag="0")&(node'=10)&(node'=8)&(node'=13)  //停用 
   ....s qflag="0"
   ....i $d(^DHCCAbFeeConfig("Details",TAbnormalDr,"OECCAT",OecCatDr))'=0  d
   .....s qflag="1"
   ....i $d(^DHCCAbFeeConfig("Details",TAbnormalDr,"ARCIC",ArcItemCatDr))'=0  d
   .....s qflag="1"
   ....i $d(^DHCCAbFeeConfig("Details",TAbnormalDr,"ARCIM",ArcimRowid))'=0  d
   .....s qflag="1"	
   ....i ((TAbnormalDr=1)!(TAbnormalDr=2)!(TAbnormalDr=5)!(TAbnormalDr=6))&(qflag="1")  d
   .....s ^TMP("DHCIPBill","AlreadyPBDate",EpisodeId,$j,TAbnormalDr,StDate)="" 
   .../////////////////////////////////////////////////////////////////////////////////////////////////////////
   ...i (CP="CR")&(OrdCateType="R") d
   ....s LinkFlag=##class(web.UDHCJFBILL).GetUserLocLinkRecLoc(OEOrdRowID)
   ....i LinkFlag="Y" s CP="OD"
   ...i ((CP="CR")&(OrdCateType="R")) d
   ....s DispTCInfo=..GetTCDspOld(OEOrdRowID)  ;取未发放的药品的数量
   ....s DisPTCQty=$p(DispTCInfo,"^",1)
   ....i +DisPTCQty'=0 d
   .....s ^TMP("DHCIPBill","TCDrug",EpisodeId,$j,OEORDDr,OEORIDr)=DisPTCQty
   .....s NDrugNum=NDrugNum+1   
   ....s PBDrugErrStr=..GetOrdDispOld(OEOrdRowID)
   ....s PBDrugNum=$p(PBDrugErrStr,"^",2)
   ....s DSPdrugNum=$p(PBDrugErrStr,"^",1)   
   ....i PBDrugNum'=DSPdrugNum d
   .....s PBDrugErrNum=PBDrugErrNum+1
   .....s ^TMP("DHCIPBill","PBDrugErr",EpisodeId,$j,OEORDDr,OEORIDr)=PBDrugErrStr
   ...///modify 2014-10-11 根据配置判断医嘱是tb状态的 
   ...s ItemStatDr=$p($g(^OEORD(OEORDDr,"I",OEORIDr,1)),"^",13)
   ...s ItemStatCode="" 
   ...i ItemStatDr'=""  d
   ....s ItemStatCode=$p(^OEC("OSTAT",ItemStatDr),"^",1)
   ...i (ItemStatCode="V")!(ItemStatCode="E")  d
   ....s qflag="0"  
   ....i $d(^DHCCAbFeeConfig("Details",10,"OECCAT",OecCatDr))'=0  d
   .....s qflag="1"
   ....i $d(^DHCCAbFeeConfig("Details",10,"ARCIC",ArcItemCatDr))'=0  d
   .....s qflag="1"
   ....i $d(^DHCCAbFeeConfig("Details",10,"ARCIM",ArcimRowid))'=0  d
   .....s qflag="1"
   ....s PBNum=0
   ....s PBNum=..GetOrdPBNumOld(OEOrdRowID)	
   ....s OEBillFlag=$p($g(^OEORD(OEORDDr,"I",OEORIDr,3)),"^",5)
   ....i (qflag="1")&((PBNum=0)!(OEBillFlag="TB"))  d
   .....i (OrdCateType="R")&(OEORIQty=0)  d
   .....e  d
   ......s ^TMP("DHCIPBill","NBillOrd",EpisodeId,$j,OEORDDr,OEORIDr)=OEBillFlag_"^"_PBNum   
   ......s OrdNExecSNum=OrdNExecSNum+1   
  
   s BedErrNum=0  ///没有收床位费的天数
   s ExamErrNum=0     ///没有收诊查费的天数
   s NurseErrNum=0           ///没有收护理费的天数
   s FootErrNum=0            ///没有收伙食费的天数
   s WarmErrNum=0
   s TAbnormalDr=""
   f  s TAbnormalDr=$o(^TMP("DHCIPBill","NeedChargeOrd",EpisodeId,$j,TAbnormalDr))  q:(TAbnormalDr="")  d
   .s PrtDate=""
   .s JFCFARowid="0",ExamineFlagNum=0
   .f  s JFCFARowid=$o(^DHCJFCheckAdmFee(0,"Adm",EpisodeId,JFCFARowid))  q:(JFCFARowid="")  d
   ..s node1=$p(^DHCJFCheckAdmFee(JFCFARowid),"^",2)
   ..q:(node1'=TAbnormalDr)
   ..s ExamineFlag=$p(^DHCJFCheckAdmFee(JFCFARowid),"^",6)
   ..i ExamineFlag="Y"  d
   ...s ExamineFlagNum=ExamineFlagNum+1 
   .q:(ExamineFlagNum>0)&((TAbnormalDr=1)!(TAbnormalDr=2)!(TAbnormalDr=5)!(TAbnormalDr=6)!(TAbnormalDr=7))  
   .f  s PrtDate=$o(^TMP("DHCIPBill","NeedChargeOrd",EpisodeId,$j,TAbnormalDr,PrtDate))  q:(PrtDate="")  d
   ..i $d(^TMP("DHCIPBill","AlreadyPBDate",EpisodeId,$j,TAbnormalDr,PrtDate))=0  d
   ...i TAbnormalDr="1"  d
   ....s BedErrNum=BedErrNum+1
   ...i TAbnormalDr="2"  d
   ....s NurseErrNum=NurseErrNum+1 
   ...i TAbnormalDr="5"  d
   ....s ExamErrNum=ExamErrNum+1 
   ...i TAbnormalDr="6"  d
   ....s FootErrNum=FootErrNum+1 
   ...i TAbnormalDr="7"  d
   ....s WarmErrNum=WarmErrNum+1 
   ...s ^TMP("DHCIPBill","LackDateOrd",EpisodeId,$j,TAbnormalDr,PrtDate)="" 
  
   ///判断病人是否有手术、麻醉相关医嘱
   s OPAlreadyOENum=0,OPAlreadyOENum1=0   ///手术相关医嘱
   s OeoriRowid=""
   f  s OeoriRowid=$o(^TMP("DHCIPBill","OPAlreadyOE",EpisodeId,$j,9,OeoriRowid))  q:(OeoriRowid="")  d
   .s OPAlreadyOENum1=OPAlreadyOENum1+1
   ;2015-07-17 审核控制 zg
   s CheckFlag1=..GetCheckFlag(EpisodeId,9,"")
   i (ssflag=1)&(OPAlreadyOENum1=0)&(VisitStatus="D")&(CheckFlag1'="Y")  d
   .s OPAlreadyOENum=1 
   
   s AnaAlreadyOENum=0 ,AnaAlreadyOENum1=0  ///麻醉相关医嘱
   s OeoriRowid=""
   f  s OeoriRowid=$o(^TMP("DHCIPBill","OPAlreadyOE",EpisodeId,$j,11,OeoriRowid))  q:(OeoriRowid="")  d
   .s AnaAlreadyOENum1=AnaAlreadyOENum1+1    
   ;2015-07-17 审核控制 zg
   s CheckFlag2=..GetCheckFlag(EpisodeId,11,"")
   i (ssflag=1)&(AnaAlreadyOENum1=0)&(VisitStatus="D")&(CheckFlag2'="Y")  d
   .s AnaAlreadyOENum=1 
  
   b   ///7.0后版本没有执行记录^核实状态医嘱没有计费^没有发药医嘱^发药数量与计费数量不一致^缺少床位的天数^缺少护理费的天数^缺少诊查费的医嘱^缺少伙食费的医嘱^取暖费^手术申请是否有手术医嘱^手术申请是否有麻醉医嘱   
   q OrdNExecDNum_"^"_OrdNExecSNum_"^"_NDrugNum_"^"_PBDrugErrNum_"^"_BedErrNum_"^"_NurseErrNum_"^"_ExamErrNum_"^"_FootErrNum_"^"_WarmErrNum_"^"_OPAlreadyOENum_"^"_AnaAlreadyOENum
}

/// Creator :     chenxi
/// CreateDate:   2014-09-09
/// Function:     判断医嘱药房发药的和计费的数量是否一致
/// W ##CLASS(web.DHCIPBillCheckAdmFee).GetOrdDispNew("148||45","148||45||1")
ClassMethod GetOrdDispNew(OEOrdRowID, OEOrdExecRowID)
{
	n (OEOrdRowID, OEOrdExecRowID)
	s DisQty=0,PBOQty=0,EqualFlag="Y",PBOQtyAll=0
	///2015-02-19 chenxi 增加判断，在《住院费用监控配置》中 规则8 未配置的大类、子类、或医嘱项不检测
	///现在有些医院有免费药的概念，此类药品发药但是不收费
	s Arcimdr=$p(^OEORD(+OEOrdRowID,"I",$p(OEOrdRowID,"||",2),1),"^",2)
	s Itemcatdr=$p(^ARCIM(+Arcimdr,$p(Arcimdr,"||",2),1),"^",10)
	s Ordcatdr=$p(^ARC("IC",Itemcatdr),"^",8)
	s AbnorNum=0,node=8
	s qflag="0"
	i $d(^DHCCAbFeeConfig("Details",node,"OECCAT",Ordcatdr))'=0  d
	.s qflag="1"
	i $d(^DHCCAbFeeConfig("Details",node,"ARCIC",Itemcatdr))'=0  d
	.s qflag="1"
	i $d(^DHCCAbFeeConfig("Details",node,"ARCIM",Arcimdr))'=0  d
	.s qflag="1"	
	
	s Checkflag="Y"
	i qflag="0"  d
	.s Checkflag="N"
		
	Set dsp=0 For  Set dsp=$O(^DHCOEDISQTY(0,"OEORE",OEOrdExecRowID,dsp)) Q:dsp=""  Do
	.Set disp=^DHCOEDISQTY(dsp)
	.Set dspstatus=$P(disp,"^",7)
	.Quit:((dspstatus'="R")&(dspstatus'="C"))
	.Set dspqty=+$P(disp,"^",11)
	.i dspstatus="R" s dspqty=0-dspqty
	.Set DisQty=DisQty+dspqty
	s PBRowID=0
	f  s PBRowID=$o(^DHCPB(0,"OEEXC",OEOrdExecRowID,PBRowID)) q:PBRowID=""  d
	.s ChildSub=0
	.f  s ChildSub=$o(^DHCPB(0,"OEEXC",OEOrdExecRowID,PBRowID,ChildSub)) q:ChildSub=""  d
	..q:($d(^DHCPB(PBRowID,"O",ChildSub))=0)
	..s BillQty=$p(^DHCPB(PBRowID,"O",ChildSub),"^",5)
	..s RefundQty=$p(^DHCPB(PBRowID,"O",ChildSub),"^",6)
	..s PBOQty=BillQty+RefundQty
	..s PBOQtyAll=PBOQtyAll+PBOQty

	q DisQty_"^"_PBOQtyAll_"^"_Checkflag
}

/// Descript：	取某医嘱剩余未发数量(计费组使用,中途结算时未发完的不结算)(已经停止的、自备药过滤掉返回值是0)
/// Creater：	陈曦
/// CreateDate:	2014-09-09
/// Input:		医嘱RowID
/// Retrun:		剩余未发数量(基本单位数量^基本单位描述),没有则返回空值""
ClassMethod GetTCDspOld(oeori) As %String
{
	n (oeori)
	
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
	
	q retQty   ;_"^"_bUomDesc
}

/// Creator :     chenxi
/// CreateDate:   2014-09-09
/// Function:     判断医嘱药房发药的和计费的数量是否一致
ClassMethod GetOrdDispOld(OEOrdRowID)
{
	n (OEOrdRowID)
	s DisQty=0,PBOQty=0,EqualFlag="Y",PBOQtyAll=0
	Set dsp=0 For  Set dsp=$O(^DHCOEDISQTY(0,"OEORI",OEOrdRowID,dsp)) Q:dsp=""  Do
	.Set disp=^DHCOEDISQTY(dsp)
	.Set dspstatus=$P(disp,"^",7)
	.Quit:((dspstatus'="R")&(dspstatus'="C"))
	.Set dspqty=+$P(disp,"^",11)
	.i dspstatus="R" s dspqty=0-dspqty
	.Set DisQty=DisQty+dspqty
	
	s PBRowID=0
	f  s PBRowID=$o(^DHCPBi(0,"OEORI",OEOrdRowID,PBRowID)) q:PBRowID=""  d
	.s ChildSub=0
	.f  s ChildSub=$o(^DHCPBi(0,"OEORI",OEOrdRowID,PBRowID,ChildSub)) q:ChildSub=""  d
	..s BillQty=$p(^DHCPB(PBRowID,"O",ChildSub),"^",5)
	..s RefundQty=$p(^DHCPB(PBRowID,"O",ChildSub),"^",6)
	..s PBOQty=BillQty+RefundQty
	..s PBOQtyAll=PBOQtyAll+PBOQty

	q DisQty_"^"_PBOQtyAll
}

/// creator:      chenxi
/// creatdate:    2014-09-09
/// Descript：    判断病人的账单是否有问题
///              1、	医嘱未插入执行记录
///              2、	检验检查存在核实未执行医嘱
/// Debug: w ##class(web.DHCIPBillCheckAdmFee).AdmBillCheck(129, 249304, "")
ClassMethod AdmBillCheck(EpisodeId, PBRowid, CheckFlag)
{
	n (EpisodeId,PBRowid,CheckFlag)
	q:(+EpisodeId=0) 0
	q:(+PBRowid=0) 0
   
	//mdofify 2015-03-02 增加判断中途结算按指定金额结算时会有负数量医嘱
	s AllowNegativeArcim=$g(^DHCINTBILLARC("ARC"))
	//b //AdmBillCheck  
   
	s PaidFlag=$p(^DHCPB(PBRowid),"^",16)
	s PBAmt=$p(^DHCPB(PBRowid),"^",8)
	s PBPatAmt=$p(^DHCPB(PBRowid),"^",12)
	s PBDSum=0.00,PBDPatShareSum=0.00
	s PBOrdFeeErrNum=0,PBFeeErrNum=0,BillBedQty=0 
	s PBOSub="0",PBOSum=0,PBOQtySum=0.00,PBNegativeNum=0
	f  s PBOSub=$o(^DHCPB(PBRowid,"O",PBOSub))  q:(PBOSub="")  d
	.//+2017-05-25 ZhYW 防止空账单错误
	.q:($d(^DHCPB(PBRowid,"O",PBOSub))=10)
	.s ArcimDr=$p(^DHCPB(PBRowid,"O",PBOSub),"^",3)
	.s ItemCatDr=$p(^ARCIM(+ArcimDr,$p(ArcimDr,"||",2),1),"^",10)
	.s OrdCatDr=$p(^ARC("IC",ItemCatDr),"^",8)
	.s PBOBedQty=$p(^DHCPB(PBRowid,"O",PBOSub),"^",5)
	.s PBORefBedQty=$p(^DHCPB(PBRowid,"O",PBOSub),"^",6)
	.s PBOBedQty=PBOBedQty+PBORefBedQty
	.q:(PaidFlag="P")
	.///modify 2014-9-9 chenxi  将空账单过滤掉
	.s CheckOEORIRowid=$p($g(^DHCPB(PBRowid,"O",PBOSub)),"^",4)
	.s ErrPBONum=0
	.i ($d(^DHCPB(PBRowid,"O",PBOSub))=10)||($d(^DHCPB(PBRowid,"O",PBOSub))=0) d
	..i (CheckOEORIRowid="")&(PaidFlag'="P")  d
	...k ^DHCPB(PBRowid,"O",PBOSub,"D",0)
	...k ^DHCPB(PBRowid,"O",PBOSub)
	...s ErrPBONum=ErrPBONum+1
	.///q:(ErrPBONum>0)
	.///
	.s PBOAmt=$p(^DHCPB(PBRowid,"O",PBOSub),"^",8)
	.s PBOPatAmt=$p(^DHCPB(PBRowid,"O",PBOSub),"^",11)
	.s PBOSum=PBOSum+PBOAmt
	.s PBDSub="0",PBDTotat=0.00,PBDPatTotal=0.00
	.f  s PBDSub=$o(^DHCPB(PBRowid,"O",PBOSub,"D",PBDSub)) q:PBDSub=""  d
	..s PBDAmt=$p(^DHCPB(PBRowid,"O",PBOSub,"D",PBDSub),"^",7)
	..s PBDShareAmt=$p(^DHCPB(PBRowid,"O",PBOSub,"D",PBDSub),"^",10)
	..s PBDTotat=PBDTotat+PBDAmt
	..s PBDPatTotal=PBDPatTotal+PBDShareAmt
	..s PBDSum=PBDSum+PBDAmt
	..s PBDPatShareSum=PBDPatShareSum+PBDShareAmt
	.i (PBOAmt'=PBDTotat)!(PBDPatTotal'=PBOPatAmt)  d
	..s ^TMP("DHCIPBill","OrdBillSumErr",EpisodeId,$j,PBRowid,PBOSub)=PBOAmt_"^"_PBOPatAmt_"^"_PBDTotat_"^"_PBDPatTotal
	..s PBOrdFeeErrNum=PBOrdFeeErrNum+1
	.///mdofify 2015-03-02 增加判断中途结算按指定金额结算时会有负数量医嘱
	.s AllowNegativeNum=0
	.i ($g(AllowNegativeArcim)'="")  d
	..s AArcimRowid=$p(^OEORD(+CheckOEORIRowid,"I",$p(CheckOEORIRowid,"||",2),1),"^",2) 
	..i AllowNegativeArcim=AArcimRowid  d
	...s AllowNegativeNum=AllowNegativeNum+1 
	.///2016-09-08 chenxi 药品批次价取价格时有可能取到负数价格,这里改为判断负数金额
	.///i (PBOBedQty<0)&(AllowNegativeNum=0)  d
	.i (PBOAmt<0)&(AllowNegativeNum=0)  d
	..s ^TMP("DHCIPBill","PBNegativeNum",EpisodeId,$j,PBRowid,PBOSub)=PBOAmt 
	..s PBNegativeNum=PBNegativeNum+1
	
	i ((PBAmt'=PBDSum)!(PBPatAmt'=PBDPatShareSum))&(PaidFlag'="P")  d
	.s ^TMP("DHCIPBill","BillSumErr",EpisodeId,$j,PBRowid)=PBAmt_"^"_PBPatAmt_"^"_PBDSum_"^"_PBDPatShareSum
	.s PBFeeErrNum=1
	
	///mdofiy 病人不平的账单^账单中不平的医嘱数量^账单数量小于0的
	q PBFeeErrNum_"^"_PBOrdFeeErrNum_"^"_PBNegativeNum
}

/// Creator :     chenxi
/// CreateDate:   2014-10-14
/// Function:     获取医嘱计费数量
ClassMethod GetOrdPBNumOld(OEOrdRowID)
{
	n (OEOrdRowID)
	s PBRowID=0,PBOQtyAll=0
	f  s PBRowID=$o(^DHCPBi(0,"OEORI",OEOrdRowID,PBRowID)) q:PBRowID=""  d
	.s ChildSub=0
	.f  s ChildSub=$o(^DHCPBi(0,"OEORI",OEOrdRowID,PBRowID,ChildSub)) q:ChildSub=""  d
	..s BillQty=$p(^DHCPB(PBRowID,"O",ChildSub),"^",5)
	..s RefundQty=$p(^DHCPB(PBRowID,"O",ChildSub),"^",6)
	..s PBOQty=BillQty+RefundQty
	..s PBOQtyAll=PBOQtyAll+PBOQty

	q PBOQtyAll
}

/// Creator :     chenxi
/// CreateDate:   2014-10-14
/// Function:     获取医嘱计费数量
ClassMethod GetOrdPBNumNew(OEOrdERowID)
{
	n (OEOrdERowID)
	s PBRowID=0,PBOQtyAll=0
	f  s PBRowID=$o(^DHCPB(0,"OEEXC",OEOrdERowID,PBRowID)) q:PBRowID=""  d
	.s ChildSub=0
	.f  s ChildSub=$o(^DHCPB(0,"OEEXC",OEOrdERowID,PBRowID,ChildSub)) q:ChildSub=""  d
	..q:($d(^DHCPB(PBRowID,"O",ChildSub))=0)
	..s BillQty=$p(^DHCPB(PBRowID,"O",ChildSub),"^",5)
	..s RefundQty=$p(^DHCPB(PBRowID,"O",ChildSub),"^",6)
	..s PBOQty=BillQty+RefundQty
	..s PBOQtyAll=PBOQtyAll+PBOQty

	q PBOQtyAll
}

/// Descript：	取某医嘱剩余未发数量(计费组使用,中途结算时未发完的不结算)(已经停止的、自备药过滤掉返回值是0)
/// Creater：	zhouyg
/// CreateDate:	2012-01-12
/// Input:		医嘱RowID
/// Retrun:		剩余未发数量(基本单位数量^基本单位描述),没有则返回空值""
ClassMethod GetTCDsp(oeori As %String) As %String
{
	n (oeori)
	
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
 	
 	///2015-02-19 chenxi 增加判断，在《住院费用监控配置》中 规则10 未配置的大类、子类、或医嘱项不检测
	
	s Arcimdr=$p(^OEORD(+OrdID,"I",OrdSub,1),"^",2)
	s Itemcatdr=$p(^ARCIM(+Arcimdr,$p(Arcimdr,"||",2),1),"^",10)
	s Ordcatdr=$p(^ARC("IC",Itemcatdr),"^",8)
	s AbnorNum=0,node=10
	s qflag="0"
	i $d(^DHCCAbFeeConfig("Details",node,"OECCAT",Ordcatdr))'=0  d
	.s qflag="1"
	i $d(^DHCCAbFeeConfig("Details",node,"ARCIC",Itemcatdr))'=0  d
	.s qflag="1"
	i $d(^DHCCAbFeeConfig("Details",node,"ARCIM",Arcimdr))'=0  d
	.s qflag="1"	
	
	s Checkflag="Y"
	i qflag="0"  d
	.s Checkflag="N"
 	
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
	i $g(DisPTCInfo)="" s DisPTCInfo=oeori_"("_retQty_bUomDesc_")"
	e  s DisPTCInfo=DisPTCInfo_"&"_oeori_"("_retQty_bUomDesc_")"
	q retQty   ;_"^"_bUomDesc
}

/// creator:      chenxi
/// creatdate:    2015-01-27
/// Descript：    判断病人的医嘱是否有问题
///              1、	医嘱未插入执行记录
///              2、	检验检查存在核实未执行医嘱
///              3、    药品医嘱收费数量与发药数量不一致
/// w ##class(web.DHCIPBillCheckAdmFee).AdmOeOrdCheckNurse(27,"New")
ClassMethod AdmOeOrdCheckNurse(EpisodeId, BillFlag)
{
   
	n (EpisodeId,BillFlag)
	q:(+EpisodeId=0) 0

	s OEOrdDr=$o(^OEORD(0,"Adm",EpisodeId,""))
	q:(OEOrdDr="") 0

	s Conf=""
	s Conf=$o(^DHCTarC("CF",Conf))
	s DefaultCP=$p(^DHCTarC("CF",Conf),"^",9)
	i DefaultCP="" s DefaultCP="OD"
	s OrdNExecDNum=0   ///7.0 之后医嘱执行记录表没有数据的
	s OrdNExecSNum=0   ///核实医嘱未计费
	s NDrugNum=0       ///未发药医嘱
	s PBDrugErrNum=0   ///药品医嘱与计费数量不一致
	s BedErrNum=0

	s job=$j
	k ^TMP("DHCIPBill","NORDExec",EpisodeId,$j)     ///没有执行记录的医嘱
	k ^TMP("DHCIPBill","TCDrug",EpisodeId,$j)       ///没有发药的医嘱
	k ^TMP("DHCIPBill","PBDrugErr",EpisodeId,$j)    ///发药数量与账单数量不对的医嘱
	k ^TMP("DHCIPBill","NBillOrd",EpisodeId,$j)    ///未计费医嘱
	k ^TMP("DHCIPBill","BillSumErr",EpisodeId,$j)    ///此次就诊账单表不平的账单
	k ^TMP("DHCIPBill","OrdBillSumErr",EpisodeId,$j)    ///此次就诊账单表不平的医嘱
	k ^TMP("DHCIPBill","BillBedErr",EpisodeId,$j)    ///
	k ^TMP("DHCIPBill","PBNegativeNum",EpisodeId,$j)    /// 此账单账单数量为负数的医嘱

	s VisitStatus=$p(^PAADM(EpisodeId),"^",20)

	//系统的入院日 入床日 以及统计组的入床日 护管的入床日 四个日期 优先级递增
	//入院日
	s InBedDate1=$p(^PAADM(EpisodeId),"^",6)
	//入床日
	s firsttransbed=0
	s tran="" f  s tran=$o(^PAADM(EpisodeId,"TRANS",tran)) q:tran=""  d
	.q:firsttransbed=1
	.s tranbeddr=$p(^PAADM(EpisodeId,"TRANS",tran),"^",8)
	.i tranbeddr'="" d
	..s firsttransbed=1
	..s InBedDate1=$p(^PAADM(EpisodeId,"TRANS",tran),"^",1)
	//统计组的入床日
	i $d(^DHCMRIPDetail(0,"TYPE","RYRS","ADM",EpisodeId)) d
	.s iprowid=0 f  s iprowid=$o(^DHCMRIPDetail(0,"TYPE","RYRS","ADM",EpisodeId,iprowid)) q:iprowid=""  d
	..s MRIPDayDr=$p(^DHCMRIPDetail(iprowid),"^",3)
	..s InBedDate1=$p(^MRIPdaily(MRIPDayDr),"^",6)
	//护管程序的入床日
	///2016-03-02 chenxi 此日期为体温单中入院事件的日期，费用核查中不应取此日期
	///s QTRECRowID=$o(^DHCADMQTREC("adm",EpisodeId,""))
	///i $g(QTRECRowID)'="" d
	.///s InBedDate1=$p(^DHCADMQTREC("QTREC",QTRECRowID),"^",2)
	s InBedDate=$zd(InBedDate1,4) //入院日期


	//医疗结算日期
	s OutDate1=$p(^PAADM(EpisodeId),"^",59)
	//最终结算日期
	i OutDate1="" s OutDate1=$p(^PAADM(EpisodeId),"^",17)    
	i OutDate1=""  s OutDate1=+$h  
	b  ////计算需收床位费、诊查费、护理费的医嘱
	k ^TMP("DHCIPBill","NeedChargeOrd",EpisodeId,$j)
	k ^TMP("DHCIPBill","AlreadyPBDate",EpisodeId,$j)
	k ^TMP("DHCIPBill","LackDateOrd",EpisodeId,$j)
	k ^TMP("DHCIPBill","OPAlreadyOE",EpisodeId,$j)  

	///modfiy 2014-11-04 婴儿和母亲一个账单的核查///////////////////////////////
    s Conf=$O(^DHCTarC("CF",""))
    s BabyFlag=$p(^DHCTarC("CF",Conf),"^",5)
    
    s BabyAdmStr=""
    i BabyFlag="Y"  d
    .s BabyAdmStr=##class(web.DHCIPBillCashier).GetBabyAdm(EpisodeId)
    .q:BabyAdmStr=""
    .f i=1:1:$l(BabyAdmStr,"^") d
    ..s BabyAdmRowid=$p(BabyAdmStr,"^",i)
	..k ^TMP("DHCIPBill","NORDExec",BabyAdmRowid,$j)     ///没有执行记录的医嘱
	..k ^TMP("DHCIPBill","TCDrug",BabyAdmRowid,$j)       ///没有发药的医嘱
	..k ^TMP("DHCIPBill","PBDrugErr",BabyAdmRowid,$j)    ///发药数量与账单数量不对的医嘱
	..k ^TMP("DHCIPBill","NBillOrd",BabyAdmRowid,$j)    ///未计费医嘱
	..k ^TMP("DHCIPBill","BillSumErr",BabyAdmRowid,$j)    ///此次就诊账单表不平的账单
	..k ^TMP("DHCIPBill","OrdBillSumErr",BabyAdmRowid,$j)    ///此次就诊账单表不平的医嘱
	..k ^TMP("DHCIPBill","BillBedErr",BabyAdmRowid,$j)    ///
	..k ^TMP("DHCIPBill","PBNegativeNum",BabyAdmRowid,$j)    /// 此账单账单数量为负数的医嘱
	..k ^TMP("DHCIPBill","NeedChargeOrd",BabyAdmRowid,$j)
	..k ^TMP("DHCIPBill","AlreadyPBDate",BabyAdmRowid,$j)
	..k ^TMP("DHCIPBill","LackDateOrd",BabyAdmRowid,$j)
	..k ^TMP("DHCIPBill","OPAlreadyOE",BabyAdmRowid,$j) 
    ..s Babyadmbedinfo=..GetAdmBedInfo(BabyAdmRowid)
    ..s Babyadmdate=$p(Babyadmbedinfo,"^",10)
    ..s Babyoutdate=$p(Babyadmbedinfo,"^",11)
    ..i $f(Babyadmdate,"/")'=0  d
    ...s Babyadmdate=$zdh(Babyadmdate,4)
    ..i $f(Babyadmdate,"-")'=0  d
    ...s Babyadmdate=$zdh(Babyadmdate,3)
    ..i $f(Babyoutdate,"/")'=0  d
    ...s Babyoutdate=$zdh(Babyoutdate,4)
    ..i $f(Babyoutdate,"-")'=0  d
    ...s Babyoutdate=$zdh(Babyoutdate,3)
    ..i Babyoutdate=""  s Babyoutdate=+$h
    ..i (Babyadmdate'="")&(Babyoutdate'="")  d
	...s TAbnormalDr=""
	...f  s TAbnormalDr=$o(^DHCCAbFeeConfig("YCFeeCheck",TAbnormalDr))  q:(TAbnormalDr="")  d
	....s CAbFeeConfig=$g(^DHCCAbFeeConfig("YCFeeCheck",TAbnormalDr))
	....q:(CAbFeeConfig="")
	....s useflag=$p(CAbFeeConfig,"^",4)
	....s NormalDesc=$p(CAbFeeConfig,"^",3)
	....q:(useflag="0")&(TAbnormalDr'=10)&(TAbnormalDr'=8)&(TAbnormalDr'=13)&(TAbnormalDr'=14)&(TAbnormalDr'=15)  //停用
	....f PrtDate=Babyadmdate:1:Babyoutdate  d
	.....i (TAbnormalDr=1)!(TAbnormalDr=2)!(TAbnormalDr=5)!(TAbnormalDr=6)  d 
	......s ^TMP("DHCIPBill","NeedChargeOrd",BabyAdmRowid,$j,TAbnormalDr,PrtDate)=""	
	....i TAbnormalDr=7   d
	.....s ktfstart=$p(NormalDesc,"|",2)
    .....s ktfend=$p(NormalDesc,"|",3)
    .....s ktfstart=$zdh(ktfstart,3)
    .....s ktfend=$zdh(ktfend,3)  
    .....f PrtDate=ktfstart:1:ktfend  d
    ......q:(PrtDate>Babyoutdate)
    ......q:(PrtDate<Babyadmdate)
    ......s ^TMP("DHCIPBill","NeedChargeOrd",BabyAdmRowid,$j,TAbnormalDr,PrtDate)=""

	///modify 2014-10-10 判断病人是否做过手术
	s ssflag=0,ssordflag=0,opdescs=""
	s op="" f  s op=$o(^DHCANOPArrange(0,"Adm",EpisodeId,op)) q:op=""  d
	.s opstatus=$p(^DHCANOPArrange(op),"^",27)
	.q:(opstatus="A")!(opstatus="D")!(opstatus="N")
	.s arrdate=$p(^DHCANOPArrange(op),"^",7)
	.s arrtime=$p(^DHCANOPArrange(op),"^",8)
	.s arrusr=$p(^DHCANOPArrange(op),"^",9)
	.q:(arrdate="")!(arrusr="")
	.s ssflag=1	
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	///mdofify 2015-03-02 增加判断中途结算按指定金额结算时会有负数量医嘱
	s AllowNegativeArcim=$g(^DHCINTBILLARC("ARC"))
   
	///s OutDate1=63141
	
	s TAbnormalDr=""
	f  s TAbnormalDr=$o(^DHCCAbFeeConfig("YCFeeCheck",TAbnormalDr))  q:(TAbnormalDr="")  d
	.///q:(TAbnormalDr=7)
	.s CAbFeeConfig=$g(^DHCCAbFeeConfig("YCFeeCheck",TAbnormalDr))
	.q:(CAbFeeConfig="")
	.s useflag=$p(CAbFeeConfig,"^",4)
	.s NormalDesc=$p(CAbFeeConfig,"^",3)
	.q:(useflag="0")&(TAbnormalDr'=10)&(TAbnormalDr'=8)&(TAbnormalDr'=13)&(TAbnormalDr'=14)&(TAbnormalDr'=15)  //停用 
	.f PrtDate=InBedDate1:1:OutDate1  d
	..i (TAbnormalDr=1)!(TAbnormalDr=2)!(TAbnormalDr=5)!(TAbnormalDr=6)  d 
	...s ^TMP("DHCIPBill","NeedChargeOrd",EpisodeId,$j,TAbnormalDr,PrtDate)=""
	..i TAbnormalDr=7   d
	...s ktfstart=$p(NormalDesc,"|",2)
    ...s ktfend=$p(NormalDesc,"|",3)
    ...s ktfstart=$zdh(ktfstart,3)
    ...s ktfend=$zdh(ktfend,3)  
    ...f PrtDate=ktfstart:1:ktfend  d
    ....q:(PrtDate>OutDate1)
    ....q:(PrtDate<InBedDate1)
    ....s ^TMP("DHCIPBill","NeedChargeOrd",EpisodeId,$j,TAbnormalDr,PrtDate)=""	

	s PhOutFlag=##class(web.UDHCJFBILL).GetPhOutFlag()
	s OEORDDr="0"
	f  s OEORDDr=$o(^OEORD(0,"Adm",EpisodeId,OEORDDr))  q:(OEORDDr="")  d 
	.s OEORIDr="0"
	.f  s OEORIDr=$o(^OEORD(OEORDDr,"I",OEORIDr))  q:(OEORIDr="")  d
	..s ExecNum=0,NFirstQty=0,DisPTCSum=0
	..q:($d(^OEORD(+OEORDDr,"I",OEORIDr,1))=0)
	..s OEOrdRowID=OEORDDr_"||"_OEORIDr
	..s ArcimRowid=$p(^OEORD(OEORDDr,"I",OEORIDr,1),"^",2)
	..q:(ArcimRowid="")
	..s ArcItemCatDr=$p($g(^ARCIM(+ArcimRowid,$p(ArcimRowid,"||",2),1)),"^",10)
	..q:(ArcItemCatDr="")
	..s StDate=$p(^OEORD(OEORDDr,"I",OEORIDr,1),"^",9)
	..s OrdCateType=$p(^ARC("IC",ArcItemCatDr),"^",7)
	..s OecCatDr=$p(^ARC("IC",ArcItemCatDr),"^",8)
	..s OEORIQty=$p(^OEORD(OEORDDr,"I",OEORIDr,1),"^",18)   ////医嘱首日次数，首日次数为0不插入打包表和医嘱执行记录表 
	..s OEORIOEORIDr=""
	..s OEORIOEORIDr=$p($g(^OEORD(OEORDDr,"I",OEORIDr,11)),"^",39)
	..s MOrdType="",MOrdQty="",MArcimDr="",MItemCatDr=""
	..i OEORIOEORIDr'=""  d
	...s MArcimDr=$p(^OEORD(+OEORIOEORIDr,"I",$p(OEORIOEORIDr,"||",2),1),"^",2)
	...s MItemCatDr=$p(^ARCIM(+MArcimDr,$p(MArcimDr,"||",2),1),"^",10) 
	...i MItemCatDr'=""  d
	....s MOrdType=$p(^ARC("IC",MItemCatDr),"^",7)
	....s MOrdQty=$p(^OEORD(+OEORIOEORIDr,"I",$p(OEORIOEORIDr,"||",2),1),"^",18)   
	..q:(OecCatDr="")
	..s Condition=$o(^DHCTarC("BC",0,ArcItemCatDr,""))	
	..i Condition'="" s CP=$p(^DHCTarC("BC",Condition),"^",2)
	..e  s CP=DefaultCP
	..s OEPriorDr=$p($g(^OEORD(OEORDDr,"I",OEORIDr,1)),"^",8)
	..s OEPriorCode=""
	..i OEPriorDr'=""  d
	...s OEPriorCode=$p(^OECPR(OEPriorDr),"^",1)  
	..q:(OEPriorCode["OM")   
	..i (PhOutFlag="N")&(OEPriorCode="OUT") s CP="OD"
	..i (CP="CR")&(OrdCateType="R") d
	...s LinkFlag=##class(web.UDHCJFBILL).GetUserLocLinkRecLoc(OEOrdRowID)
	...i LinkFlag="Y" s CP="OD"
	..///判断病人做了手术申请是否有补录相关医嘱  控制点9,11
	..s ItmStatDr=$p(^OEORD(OEORDDr,"I",OEORIDr,1),"^",13)
	..q:(ItmStatDr="")
	..s StatCode=$p(^OEC("OSTAT",ItmStatDr),"^",1)
	..s CAbFeeConfig=$g(^DHCCAbFeeConfig("YCFeeCheck",9))
	..s UserFlag1=$p(CAbFeeConfig,"^",4)
	..s CAbFeeConfig=$g(^DHCCAbFeeConfig("YCFeeCheck",11))
	..s UserFlag2=$p(CAbFeeConfig,"^",4)
	..i (StatCode="V")!(StatCode="E")  d
	...i UserFlag1="1"  d
	....i $d(^DHCCAbFeeConfig("Details",9,"OECCAT",OecCatDr))'=0  d
	.....s ^TMP("DHCIPBill","OPAlreadyOE",EpisodeId,$j,9,OEOrdRowID)=""
	....i $d(^DHCCAbFeeConfig("Details",9,"ARCIC",ArcItemCatDr))'=0  d
	.....s ^TMP("DHCIPBill","OPAlreadyOE",EpisodeId,$j,9,OEOrdRowID)=""
	....i $d(^DHCCAbFeeConfig("Details",9,"ARCIM",ArcimRowid))'=0  d
	.....s ^TMP("DHCIPBill","OPAlreadyOE",EpisodeId,$j,9,OEOrdRowID)=""
	...i UserFlag2="1"  d
	....i $d(^DHCCAbFeeConfig("Details",11,"OECCAT",OecCatDr))'=0  d
	.....s ^TMP("DHCIPBill","OPAlreadyOE",EpisodeId,$j,11,OEOrdRowID)=""
	....i $d(^DHCCAbFeeConfig("Details",11,"ARCIC",ArcItemCatDr))'=0  d
	.....s ^TMP("DHCIPBill","OPAlreadyOE",EpisodeId,$j,11,OEOrdRowID)=""
	....i $d(^DHCCAbFeeConfig("Details",11,"ARCIM",ArcimRowid))'=0  d
	.....s ^TMP("DHCIPBill","OPAlreadyOE",EpisodeId,$j,11,OEOrdRowID)=""
	..i BillFlag="New"  d
	...s OEOREDr="0"
	...f  s OEOREDr=$o(^OEORD(OEORDDr,"I",OEORIDr,"X",OEOREDr))  q:(OEOREDr="")  d
	....s ExecNum=ExecNum+1
	....s OEOREStDate=$p(^OEORD(OEORDDr,"I",OEORIDr,"X",OEOREDr),"^",1)	
	....s OEORERowID=OEORDDr_"||"_OEORIDr_"||"_OEOREDr   
	....s Billed=$p(^OEORD(OEORDDr,"I",OEORIDr,"X",OEOREDr),"^",6)
	....s ItemStatDr=$p($g(^OEORD(OEORDDr,"I",OEORIDr,"X",OEOREDr,"BILL")),"^",1)
	....s ItemStatCode=""
	....i ItemStatDr'=""  d
	.....s ItemStatCode=$p(^OEC("OSTAT",ItemStatDr),"^",1)    
	....i (ItemStatCode="V")!(ItemStatCode="E")  d
	.....s qflag="0"  
	.....i $d(^DHCCAbFeeConfig("Details",10,"OECCAT",OecCatDr))'=0  d
	......s qflag="1"
	.....i $d(^DHCCAbFeeConfig("Details",10,"ARCIC",ArcItemCatDr))'=0  d
	......s qflag="1"
	.....i $d(^DHCCAbFeeConfig("Details",10,"ARCIM",ArcimRowid))'=0  d
	......s qflag="1"
	.....s PBNum=0
	.....s PBNum=..GetOrdPBNumNew(OEORERowID)   
	.....s CheckFlag=..GetCheckFlag(EpisodeId,"",OEOrdRowID)
	.....i (qflag="1")&((Billed="TB")!(PBNum=0)&((ItemStatCode="V")!(ItemStatCode="E")))  d
	......i CheckFlag'="Y"   d
	.......s ^TMP("DHCIPBill","NBillOrd",EpisodeId,$j,OEORDDr,OEORIDr,OEOREDr)=Billed   
	.......s OrdNExecSNum=OrdNExecSNum+1
	....;对于 1,2,5,6,7规则的处理。
	....s node=""
	....f  s node=$o(^DHCCAbFeeConfig("YCFeeCheck",node))  q:(node="")  d
	.....s espression=$g(^DHCCAbFeeConfig("YCFeeCheck",node))
	.....s useflag=$p(espression,"^",4)
	.....q:(useflag=0)&(node'=10)&(node'=8)&(node'=13)&(node'=14)&(node'=15)  // 这几个规则不允许被停用。[停用无效]
	.....s qflag="0"
	.....i $d(^DHCCAbFeeConfig("Details",node,"OECCAT",OecCatDr))'=0  d
	......s qflag="1"
	.....i $d(^DHCCAbFeeConfig("Details",node,"ARCIC",ArcItemCatDr))'=0  d
	......s qflag="1"
	.....i $d(^DHCCAbFeeConfig("Details",node,"ARCIM",ArcimRowid))'=0  d
	......s qflag="1"	
	.....s OEOREStDate=$p(^OEORD(OEORDDr,"I",OEORIDr,"X",OEOREDr),"^",1)	
	.....i ((node=1)!(node=2)!(node=5)!(node=6)!(node=7))&(qflag="1")  d
	......s ^TMP("DHCIPBill","AlreadyPBDate",EpisodeId,$j,node,OEOREStDate)=""  	;收费天数与住院天数是否一致:存收费天数的global。
	.....i ((CP="OD")&(OrdCateType="R")&(qflag="1")&(node=10)&((ItemStatCode="V")!(ItemStatCode="E"))) d
	......s CheckFlag=..GetCheckFlag(EpisodeId,"",OEOrdRowID)
	......i CheckFlag'="Y" d
	.......s PBDrugErrStr=..GetODOrdDispNew(OEOrdRowID,OEORERowID)
	.......s PBDrugNum=$p(PBDrugErrStr,"^",2)
	.......s DSPdrugNum=$p(PBDrugErrStr,"^",1)   
	.......i PBDrugNum'=DSPdrugNum d
	........s PBDrugErrNum=PBDrugErrNum+1
	........s ^TMP("DHCIPBill","PBDrugErr",EpisodeId,$j,OEORDDr,OEORIDr,OEOREDr)=PBDrugErrStr
	.....i ((CP="CR")&(OrdCateType="R")&(qflag="1")&(node=10)&((ItemStatCode="V")!(ItemStatCode="E"))) d
	......s CheckFlag=..GetCheckFlag(EpisodeId,"",OEOrdRowID)
	......i CheckFlag'="Y" d
	.......s DispTCInfo=..GetTCDspNew(OEORERowID)  ;取未发放的药品的数量
	.......s DisPTCQty=$p(DispTCInfo,"^",1)
	.......s DisPTCSum=DisPTCSum+(+DisPTCQty)
	.......i +DisPTCQty'=0 d
	........s ^TMP("DHCIPBill","TCDrug",EpisodeId,$j,OEORDDr,OEORIDr,OEOREDr)=DisPTCQty    
	........s NDrugNum=NDrugNum+1
	.....i ((CP="CR")&(OrdCateType="R")&(qflag="1")&(node=8)) d	
	......s PBDrugErrStr=..GetOrdDispNew(OEOrdRowID,OEORERowID)
	......s PBDrugNum=$p(PBDrugErrStr,"^",2)
	......s DSPdrugNum=$p(PBDrugErrStr,"^",1)
	......///2015-02-19 chenxi 增加判断，在《住院费用监控配置》中 规则8 未配置的大类、子类、或医嘱项不检测
	......///现在有些医院有免费药的概念，此类药品发药但是不收费   
	......s DrugNumCheckFlag=$p(PBDrugErrStr,"^",3)
	......i (PBDrugNum'=DSPdrugNum)&(DrugNumCheckFlag="Y") d
	.......s PBDrugErrNum=PBDrugErrNum+1
	.......s ^TMP("DHCIPBill","PBDrugErr",EpisodeId,$j,OEORDDr,OEORIDr,OEOREDr)=PBDrugErrStr	
	...;对于13没有执行记录规则的处理。
	...s NExecFlag="Y"
	...s NExecFlag=..CheckOrdAllowNExec(OEOrdRowID)
	...i NExecFlag'="Y"  d
	....;判断是否审核。
	....s CheckFlag=..GetCheckFlag(EpisodeId,"",OEOrdRowID)
	....i CheckFlag'="Y" d
	.....s OrdNExecDNum=OrdNExecDNum+1
	.....s ^TMP("DHCIPBill","NORDExec",EpisodeId,$j,OEORDDr,OEORIDr)=""
	...i (NFirstQty'=0)  d
	....;s OrdNExecDNum=OrdNExecDNum+1
	....;s ^TMP("DHCIPBill","NORDExec",EpisodeId,$j,OEORDDr,OEORIDr)=""  
	..e  d
	...///modify 2014-10-14 判断床位费、诊查费、护理费等是否缺医嘱////////////////////////////////////////////////////////////////////////////////////////////////////// 
	...s StDate=$p($g(^OEORD(OEORDDr,"I",OEORIDr,1)),"^",9)
	...s TAbnormalDr=""
	...f  s TAbnormalDr=$o(^DHCCAbFeeConfig("YCFeeCheck",TAbnormalDr))  q:(TAbnormalDr="")  d
	....s CAbFeeConfig=$g(^DHCCAbFeeConfig("YCFeeCheck",TAbnormalDr))
	....q:(CAbFeeConfig="")
	....s useflag=$p(CAbFeeConfig,"^",4)
	....q:(useflag="0")&(node'=10)&(node'=8)&(node'=13)&(node'=14)&(node'=15)  //停用 
	....s qflag="0"
	....i $d(^DHCCAbFeeConfig("Details",TAbnormalDr,"OECCAT",OecCatDr))'=0  d
	.....s qflag="1"
	....i $d(^DHCCAbFeeConfig("Details",TAbnormalDr,"ARCIC",ArcItemCatDr))'=0  d
	.....s qflag="1"
	....i $d(^DHCCAbFeeConfig("Details",TAbnormalDr,"ARCIM",ArcimRowid))'=0  d
	.....s qflag="1"	
	....i ((TAbnormalDr=1)!(TAbnormalDr=2)!(TAbnormalDr=5)!(TAbnormalDr=6))&(qflag="1")  d
	.....s ^TMP("DHCIPBill","AlreadyPBDate",EpisodeId,$j,TAbnormalDr,StDate)="" 
	.../////////////////////////////////////////////////////////////////////////////////////////////////////////
	...i (CP="CR")&(OrdCateType="R") d
	....s LinkFlag=##class(web.UDHCJFBILL).GetUserLocLinkRecLoc(OEOrdRowID)
	....i LinkFlag="Y" s CP="OD"
	...i ((CP="CR")&(OrdCateType="R")) d
	....s DispTCInfo=..GetTCDspOld(OEOrdRowID)  ;取未发放的药品的数量
	....s DisPTCQty=$p(DispTCInfo,"^",1)
	....i +DisPTCQty'=0 d
	.....s ^TMP("DHCIPBill","TCDrug",EpisodeId,$j,OEORDDr,OEORIDr)=DisPTCQty
	.....s NDrugNum=NDrugNum+1   
	....s PBDrugErrStr=..GetOrdDispOld(OEOrdRowID)
	....s PBDrugNum=$p(PBDrugErrStr,"^",2)
	....s DSPdrugNum=$p(PBDrugErrStr,"^",1)   
	....i PBDrugNum'=DSPdrugNum d
	.....s PBDrugErrNum=PBDrugErrNum+1
	.....s ^TMP("DHCIPBill","PBDrugErr",EpisodeId,$j,OEORDDr,OEORIDr)=PBDrugErrStr
	...///modify 2014-10-11 根据配置判断医嘱是tb状态的 
	...s ItemStatDr=$p($g(^OEORD(OEORDDr,"I",OEORIDr,1)),"^",13)
	...s ItemStatCode="" 
	...i ItemStatDr'=""  d
	....s ItemStatCode=$p(^OEC("OSTAT",ItemStatDr),"^",1)
	...i (ItemStatCode="V")!(ItemStatCode="E")  d
	....s qflag="0"  
	....i $d(^DHCCAbFeeConfig("Details",10,"OECCAT",OecCatDr))'=0  d
	.....s qflag="1"
	....i $d(^DHCCAbFeeConfig("Details",10,"ARCIC",ArcItemCatDr))'=0  d
	.....s qflag="1"
	....i $d(^DHCCAbFeeConfig("Details",10,"ARCIM",ArcimRowid))'=0  d
	.....s qflag="1"
	....s PBNum=0
	....s PBNum=..GetOrdPBNumOld(OEOrdRowID)	
	....s OEBillFlag=$p($g(^OEORD(OEORDDr,"I",OEORIDr,3)),"^",5)
	....i (qflag="1")&((PBNum=0)!(OEBillFlag="TB"))  d
	.....i (OrdCateType="R")&(OEORIQty=0)  d
	.....e  d
	......s ^TMP("DHCIPBill","NBillOrd",EpisodeId,$j,OEORDDr,OEORIDr)=OEBillFlag_"^"_PBNum   
	......s OrdNExecSNum=OrdNExecSNum+1  
	b ////0000
	i BabyFlag="Y" d
	.q:BabyAdmStr=""
	.f i=1:1:$l(BabyAdmStr,"^") d
    ..s BabyAdmRowid=$p(BabyAdmStr,"^",i)
	..d CheckBabyAdmFee(BabyAdmRowid)
	b ////1111
	s BedErrNum=0  ///没有收床位费的天数
	s ExamErrNum=0     ///没有收诊查费的天数
	s NurseErrNum=0           ///没有收护理费的天数
	s FootErrNum=0            ///没有收伙食费的天数
	s WarmErrNum=0
	s TAbnormalDr=""
	f  s TAbnormalDr=$o(^TMP("DHCIPBill","NeedChargeOrd",EpisodeId,$j,TAbnormalDr))  q:(TAbnormalDr="")  d
	.s PrtDate=""
	.s JFCFARowid="0",ExamineFlagNum=0
	.f  s JFCFARowid=$o(^DHCJFCheckAdmFee(0,"Adm",EpisodeId,JFCFARowid))  q:(JFCFARowid="")  d
	..s node1=$p(^DHCJFCheckAdmFee(JFCFARowid),"^",2)
	..q:(node1'=TAbnormalDr)
	..s ExamineFlag=$p(^DHCJFCheckAdmFee(JFCFARowid),"^",6)
	..i ExamineFlag="Y"  d
	...s ExamineFlagNum=ExamineFlagNum+1 
	.q:(ExamineFlagNum>0)&((TAbnormalDr=1)!(TAbnormalDr=2)!(TAbnormalDr=5)!(TAbnormalDr=6)!(TAbnormalDr=7))   
	.f  s PrtDate=$o(^TMP("DHCIPBill","NeedChargeOrd",EpisodeId,$j,TAbnormalDr,PrtDate))  q:(PrtDate="")  d
	..i $d(^TMP("DHCIPBill","AlreadyPBDate",EpisodeId,$j,TAbnormalDr,PrtDate))=0  d
	...i TAbnormalDr="1"  d
	....s BedErrNum=BedErrNum+1
	...i TAbnormalDr="2"  d
	....s NurseErrNum=NurseErrNum+1 
	...i TAbnormalDr="5"  d
	....s ExamErrNum=ExamErrNum+1 
	...i TAbnormalDr="6"  d
	....s FootErrNum=FootErrNum+1 
	...i TAbnormalDr="7"  d
	....s WarmErrNum=WarmErrNum+1 
	...s ^TMP("DHCIPBill","LackDateOrd",EpisodeId,$j,TAbnormalDr,PrtDate)="" 
	
	i BabyFlag="Y"  d
    .s BabyAdmStr=##class(web.DHCIPBillCashier).GetBabyAdm(EpisodeId)
    .q:BabyAdmStr=""
    .f i=1:1:$l(BabyAdmStr,"^") d
    ..s BabyAdmRowid=$p(BabyAdmStr,"^",i)	
	..s TAbnormalDr=""
	..f  s TAbnormalDr=$o(^TMP("DHCIPBill","NeedChargeOrd",BabyAdmRowid,$j,TAbnormalDr))  q:(TAbnormalDr="")  d
	...s PrtDate=""
	...s JFCFARowid="0",ExamineFlagNum=0
	...f  s JFCFARowid=$o(^DHCJFCheckAdmFee(0,"Adm",BabyAdmRowid,JFCFARowid))  q:(JFCFARowid="")  d
	....s node1=$p(^DHCJFCheckAdmFee(JFCFARowid),"^",2)
	....q:(node1'=TAbnormalDr)
	....s ExamineFlag=$p(^DHCJFCheckAdmFee(JFCFARowid),"^",6)
	....i ExamineFlag="Y"  d
	.....s ExamineFlagNum=ExamineFlagNum+1 
	...q:(ExamineFlagNum>0)&((TAbnormalDr=1)!(TAbnormalDr=2)!(TAbnormalDr=5)!(TAbnormalDr=6)!(TAbnormalDr=7))   
	...f  s PrtDate=$o(^TMP("DHCIPBill","NeedChargeOrd",BabyAdmRowid,$j,TAbnormalDr,PrtDate))  q:(PrtDate="")  d
	....i $d(^TMP("DHCIPBill","AlreadyPBDate",BabyAdmRowid,$j,TAbnormalDr,PrtDate))=0  d
	.....i TAbnormalDr="1"  d
	......s BedErrNum=BedErrNum+1
	.....i TAbnormalDr="2"  d
	......s NurseErrNum=NurseErrNum+1 
	.....i TAbnormalDr="5"  d
	......s ExamErrNum=ExamErrNum+1 
	.....i TAbnormalDr="6"  d
	......s FootErrNum=FootErrNum+1 
	.....i TAbnormalDr="7"  d
	......s WarmErrNum=WarmErrNum+1 
	.....s ^TMP("DHCIPBill","LackDateOrd",BabyAdmRowid,$j,TAbnormalDr,PrtDate)=""
	
	
	s job=$j

	s CAbFeeConfig=$g(^DHCCAbFeeConfig("YCFeeCheck",9))
	s UserFlag1=$p(CAbFeeConfig,"^",4)
	s CAbFeeConfig=$g(^DHCCAbFeeConfig("YCFeeCheck",11))
	s UserFlag2=$p(CAbFeeConfig,"^",4)

	///判断病人是否有手术、麻醉相关医嘱
	s OPAlreadyOENum=0,OPAlreadyOENum1=0   ///手术相关医嘱
	s OeoriRowid=""
	f  s OeoriRowid=$o(^TMP("DHCIPBill","OPAlreadyOE",EpisodeId,$j,9,OeoriRowid))  q:(OeoriRowid="")  d
	.s OPAlreadyOENum1=OPAlreadyOENum1+1
	
	;2015-07-17 审核控制 zg
	s CheckFlag1=..GetCheckFlag(EpisodeId,9,"")
	i (ssflag=1)&(OPAlreadyOENum1=0)&(UserFlag1="1")&(CheckFlag1'="Y")  d
	.s OPAlreadyOENum=1 

	s AnaAlreadyOENum=0 ,AnaAlreadyOENum1=0  ///麻醉相关医嘱
	s OeoriRowid=""
	f  s OeoriRowid=$o(^TMP("DHCIPBill","OPAlreadyOE",EpisodeId,$j,11,OeoriRowid))  q:(OeoriRowid="")  d
	.s AnaAlreadyOENum1=AnaAlreadyOENum1+1 
	;2015-07-17 审核控制 zg   
	s CheckFlag2=..GetCheckFlag(EpisodeId,11,"")
	i (ssflag=1)&(AnaAlreadyOENum1=0)&(UserFlag2="1")&(CheckFlag2'="Y")  d
	.s AnaAlreadyOENum=1 

	i BabyFlag="Y"  d
    .s BabyAdmStr=##class(web.DHCIPBillCashier).GetBabyAdm(EpisodeId)
    .q:BabyAdmStr=""
    .f i=1:1:$l(BabyAdmStr,"^") d
    ..s BabyAdmRowid=$p(BabyAdmStr,"^",i)	
	..s OeoriRowid=""
	..f  s OeoriRowid=$o(^TMP("DHCIPBill","OPAlreadyOE",BabyAdmRowid,$j,9,OeoriRowid))  q:(OeoriRowid="")  d
	...s OPAlreadyOENum1=OPAlreadyOENum1+1		
	..s CheckFlag1=..GetCheckFlag(BabyAdmRowid,9,"")
	..i (ssflag=1)&(OPAlreadyOENum1=0)&(UserFlag1="1")&(CheckFlag1'="Y")  d
	...s OPAlreadyOENum=1 
	..s AnaAlreadyOENum=0 ,AnaAlreadyOENum1=0  ///麻醉相关医嘱
	..s OeoriRowid=""
	..f  s OeoriRowid=$o(^TMP("DHCIPBill","OPAlreadyOE",BabyAdmRowid,$j,11,OeoriRowid))  q:(OeoriRowid="")  d
	...s AnaAlreadyOENum1=AnaAlreadyOENum1+1 
	..s CheckFlag2=..GetCheckFlag(BabyAdmRowid,11,"")
	..i (ssflag=1)&(AnaAlreadyOENum1=0)&(UserFlag2="1")&(CheckFlag2'="Y")  d
	...s AnaAlreadyOENum=1
	
	s PBFeeErrNumSum=0,PBOrdFeeErrNumsum=0,PBNegativeSum=0
	s PBRowid="0"
	f  s PBRowid=$o(^DHCPB(0,"ADM",EpisodeId,PBRowid))  q:(PBRowid="")  d  
	.s BillErrStr=..AdmBillCheck(EpisodeId,PBRowid,"")
	.s PBFeeErrNum=$p(BillErrStr,"^",1)
	.s PBOrdFeeErrNum=$p(BillErrStr,"^",2)
	.s PBNegativeNum=$p(BillErrStr,"^",3)
	.s PBFeeErrNumSum=PBFeeErrNumSum+PBFeeErrNum 
	.s PBOrdFeeErrNumsum=PBOrdFeeErrNumsum+PBOrdFeeErrNum 
	.s PBNegativeSum=PBNegativeSum+PBNegativeNum


	s ErrNum=OrdNExecDNum+OrdNExecSNum+NDrugNum+PBDrugErrNum+BedErrNum+NurseErrNum+ExamErrNum+FootErrNum+WarmErrNum+OPAlreadyOENum+AnaAlreadyOENum
	///s ErrNum=ErrNum+PBFeeErrNumSum+PBOrdFeeErrNumsum+PBNegativeSum
	s ErrNum=ErrNum+PBNegativeSum
	b ;w ErrNum
	///7.0后版本没有执行记录^核实状态医嘱没有计费^没有发药医嘱^发药数量与计费数量不一致^缺少床位的天数^缺少护理费的天数^缺少诊查费的医嘱^缺少伙食费的医嘱^取暖费^手术申请是否有手术医嘱^手术申请是否有麻醉医嘱   

	k ^TMP("DHCIPBill","NORDExec",EpisodeId,$j)     ///没有执行记录的医嘱
	k ^TMP("DHCIPBill","TCDrug",EpisodeId,$j)       ///没有发药的医嘱
	k ^TMP("DHCIPBill","PBDrugErr",EpisodeId,$j)    ///发药数量与账单数量不对的医嘱
	k ^TMP("DHCIPBill","NBillOrd",EpisodeId,$j)    ///未计费医嘱
	k ^TMP("DHCIPBill","BillSumErr",EpisodeId,$j)    ///此次就诊账单表不平的账单
	k ^TMP("DHCIPBill","OrdBillSumErr",EpisodeId,$j)    ///此次就诊账单表不平的医嘱
	k ^TMP("DHCIPBill","BillBedErr",EpisodeId,$j)    ///
	k ^TMP("DHCIPBill","PBNegativeNum",EpisodeId,$j)    /// 此账单账单数量为负数的医嘱
	i BabyAdmStr'="" d
    .f i=1:1:$l(BabyAdmStr,"^") d
    ..s BabyAdmRowid=$p(BabyAdmStr,"^",i)
	..k ^TMP("DHCIPBill","NORDExec",BabyAdmRowid,$j)     ///没有执行记录的医嘱
	..k ^TMP("DHCIPBill","TCDrug",BabyAdmRowid,$j)       ///没有发药的医嘱
	..k ^TMP("DHCIPBill","PBDrugErr",BabyAdmRowid,$j)    ///发药数量与账单数量不对的医嘱
	..k ^TMP("DHCIPBill","NBillOrd",BabyAdmRowid,$j)    ///未计费医嘱
	..k ^TMP("DHCIPBill","BillSumErr",BabyAdmRowid,$j)    ///此次就诊账单表不平的账单
	..k ^TMP("DHCIPBill","OrdBillSumErr",BabyAdmRowid,$j)    ///此次就诊账单表不平的医嘱
	..k ^TMP("DHCIPBill","BillBedErr",BabyAdmRowid,$j)    ///
	..k ^TMP("DHCIPBill","PBNegativeNum",BabyAdmRowid,$j)    /// 此账单账单数量为负数的医嘱
	..k ^TMP("DHCIPBill","NeedChargeOrd",BabyAdmRowid,$j)
	..k ^TMP("DHCIPBill","AlreadyPBDate",BabyAdmRowid,$j)
	..k ^TMP("DHCIPBill","LackDateOrd",BabyAdmRowid,$j)
	..k ^TMP("DHCIPBill","OPAlreadyOE",BabyAdmRowid,$j)  
	q ErrNum
	
CheckBabyAdmFee(EpisodeId)
	s OEORDDr="0"
	f  s OEORDDr=$o(^OEORD(0,"Adm",EpisodeId,OEORDDr))  q:(OEORDDr="")  d 
	.s OEORIDr="0"
	.f  s OEORIDr=$o(^OEORD(OEORDDr,"I",OEORIDr))  q:(OEORIDr="")  d
	..s ExecNum=0,NFirstQty=0,DisPTCSum=0
	..q:($d(^OEORD(+OEORDDr,"I",OEORIDr,1))=0)
	..s OEOrdRowID=OEORDDr_"||"_OEORIDr
	..s ArcimRowid=$p(^OEORD(OEORDDr,"I",OEORIDr,1),"^",2)
	..q:(ArcimRowid="")
	..s ArcItemCatDr=$p($g(^ARCIM(+ArcimRowid,$p(ArcimRowid,"||",2),1)),"^",10)
	..q:(ArcItemCatDr="")
	..s StDate=$p(^OEORD(OEORDDr,"I",OEORIDr,1),"^",9)
	..s OrdCateType=$p(^ARC("IC",ArcItemCatDr),"^",7)
	..s OecCatDr=$p(^ARC("IC",ArcItemCatDr),"^",8)
	..s OEORIQty=$p(^OEORD(OEORDDr,"I",OEORIDr,1),"^",18)   ////医嘱首日次数，首日次数为0不插入打包表和医嘱执行记录表 
	..s OEORIOEORIDr=""
	..s OEORIOEORIDr=$p($g(^OEORD(OEORDDr,"I",OEORIDr,11)),"^",39)
	..s MOrdType="",MOrdQty="",MArcimDr="",MItemCatDr=""
	..i OEORIOEORIDr'=""  d
	...s MArcimDr=$p(^OEORD(+OEORIOEORIDr,"I",$p(OEORIOEORIDr,"||",2),1),"^",2)
	...s MItemCatDr=$p(^ARCIM(+MArcimDr,$p(MArcimDr,"||",2),1),"^",10) 
	...i MItemCatDr'=""  d
	....s MOrdType=$p(^ARC("IC",MItemCatDr),"^",7)
	....s MOrdQty=$p(^OEORD(+OEORIOEORIDr,"I",$p(OEORIOEORIDr,"||",2),1),"^",18)   
	..q:(OecCatDr="")
	..s Condition=$o(^DHCTarC("BC",0,ArcItemCatDr,""))	
	..i Condition'="" s CP=$p(^DHCTarC("BC",Condition),"^",2)
	..e  s CP=DefaultCP
	..s OEPriorDr=$p($g(^OEORD(OEORDDr,"I",OEORIDr,1)),"^",8)
	..s OEPriorCode=""
	..i OEPriorDr'=""  d
	...s OEPriorCode=$p(^OECPR(OEPriorDr),"^",1)  
	..q:(OEPriorCode["OM")   
	..i (PhOutFlag="N")&(OEPriorCode="OUT") s CP="OD"
	..i (CP="CR")&(OrdCateType="R") d
	...s LinkFlag=##class(web.UDHCJFBILL).GetUserLocLinkRecLoc(OEOrdRowID)
	...i LinkFlag="Y" s CP="OD"
	..///判断病人做了手术申请是否有补录相关医嘱  控制点9,11
	..s ItmStatDr=$p(^OEORD(OEORDDr,"I",OEORIDr,1),"^",13)
	..q:(ItmStatDr="")
	..s StatCode=$p(^OEC("OSTAT",ItmStatDr),"^",1)
	..s CAbFeeConfig=$g(^DHCCAbFeeConfig("YCFeeCheck",9))
	..s UserFlag1=$p(CAbFeeConfig,"^",4)
	..s CAbFeeConfig=$g(^DHCCAbFeeConfig("YCFeeCheck",11))
	..s UserFlag2=$p(CAbFeeConfig,"^",4)
	..i (StatCode="V")!(StatCode="E")  d
	...i UserFlag1="1"  d
	....i $d(^DHCCAbFeeConfig("Details",9,"OECCAT",OecCatDr))'=0  d
	.....s ^TMP("DHCIPBill","OPAlreadyOE",EpisodeId,$j,9,OEOrdRowID)=""
	....i $d(^DHCCAbFeeConfig("Details",9,"ARCIC",ArcItemCatDr))'=0  d
	.....s ^TMP("DHCIPBill","OPAlreadyOE",EpisodeId,$j,9,OEOrdRowID)=""
	....i $d(^DHCCAbFeeConfig("Details",9,"ARCIM",ArcimRowid))'=0  d
	.....s ^TMP("DHCIPBill","OPAlreadyOE",EpisodeId,$j,9,OEOrdRowID)=""
	...i UserFlag2="1"  d
	....i $d(^DHCCAbFeeConfig("Details",11,"OECCAT",OecCatDr))'=0  d
	.....s ^TMP("DHCIPBill","OPAlreadyOE",EpisodeId,$j,11,OEOrdRowID)=""
	....i $d(^DHCCAbFeeConfig("Details",11,"ARCIC",ArcItemCatDr))'=0  d
	.....s ^TMP("DHCIPBill","OPAlreadyOE",EpisodeId,$j,11,OEOrdRowID)=""
	....i $d(^DHCCAbFeeConfig("Details",11,"ARCIM",ArcimRowid))'=0  d
	.....s ^TMP("DHCIPBill","OPAlreadyOE",EpisodeId,$j,11,OEOrdRowID)=""
	..i BillFlag="New"  d
	...s OEOREDr="0"
	...f  s OEOREDr=$o(^OEORD(OEORDDr,"I",OEORIDr,"X",OEOREDr))  q:(OEOREDr="")  d
	....s ExecNum=ExecNum+1
	....s OEOREStDate=$p(^OEORD(OEORDDr,"I",OEORIDr,"X",OEOREDr),"^",1)	
	....s OEORERowID=OEORDDr_"||"_OEORIDr_"||"_OEOREDr   
	....s Billed=$p(^OEORD(OEORDDr,"I",OEORIDr,"X",OEOREDr),"^",6)
	....s ItemStatDr=$p($g(^OEORD(OEORDDr,"I",OEORIDr,"X",OEOREDr,"BILL")),"^",1)
	....s ItemStatCode=""
	....i ItemStatDr'=""  d
	.....s ItemStatCode=$p(^OEC("OSTAT",ItemStatDr),"^",1)    
	....i (ItemStatCode="V")!(ItemStatCode="E")  d
	.....s qflag="0"  
	.....i $d(^DHCCAbFeeConfig("Details",10,"OECCAT",OecCatDr))'=0  d
	......s qflag="1"
	.....i $d(^DHCCAbFeeConfig("Details",10,"ARCIC",ArcItemCatDr))'=0  d
	......s qflag="1"
	.....i $d(^DHCCAbFeeConfig("Details",10,"ARCIM",ArcimRowid))'=0  d
	......s qflag="1"
	.....s PBNum=0
	.....s PBNum=..GetOrdPBNumNew(OEORERowID)   
	.....s CheckFlag=..GetCheckFlag(EpisodeId,"",OEOrdRowID)
	.....i (qflag="1")&((Billed="TB")!(PBNum=0)&((ItemStatCode="V")!(ItemStatCode="E")))  d
	......i CheckFlag'="Y"   d
	.......s ^TMP("DHCIPBill","NBillOrd",EpisodeId,$j,OEORDDr,OEORIDr,OEOREDr)=Billed   
	.......s OrdNExecSNum=OrdNExecSNum+1
	....;对于 1,2,5,6,7规则的处理。
	....s node=""
	....f  s node=$o(^DHCCAbFeeConfig("YCFeeCheck",node))  q:(node="")  d
	.....s espression=$g(^DHCCAbFeeConfig("YCFeeCheck",node))
	.....s useflag=$p(espression,"^",4)
	.....q:(useflag=0)&(node'=10)&(node'=8)&(node'=13)&(node'=14)&(node'=15)  // 这几个规则不允许被停用。[停用无效]
	.....s qflag="0"
	.....i $d(^DHCCAbFeeConfig("Details",node,"OECCAT",OecCatDr))'=0  d
	......s qflag="1"
	.....i $d(^DHCCAbFeeConfig("Details",node,"ARCIC",ArcItemCatDr))'=0  d
	......s qflag="1"
	.....i $d(^DHCCAbFeeConfig("Details",node,"ARCIM",ArcimRowid))'=0  d
	......s qflag="1"	
	.....s OEOREStDate=$p(^OEORD(OEORDDr,"I",OEORIDr,"X",OEOREDr),"^",1)	
	.....i ((node=1)!(node=2)!(node=5)!(node=6)!(node=7))&(qflag="1")  d
	......s ^TMP("DHCIPBill","AlreadyPBDate",EpisodeId,$j,node,OEOREStDate)=""  	;收费天数与住院天数是否一致:存收费天数的global。
	.....i ((CP="OD")&(OrdCateType="R")&(qflag="1")&(node=10)&((ItemStatCode="V")!(ItemStatCode="E"))) d
	......s CheckFlag=..GetCheckFlag(EpisodeId,"",OEOrdRowID)
	......i CheckFlag'="Y" d
	.......s PBDrugErrStr=..GetODOrdDispNew(OEOrdRowID,OEORERowID)
	.......s PBDrugNum=$p(PBDrugErrStr,"^",2)
	.......s DSPdrugNum=$p(PBDrugErrStr,"^",1)   
	.......i PBDrugNum'=DSPdrugNum d
	........s PBDrugErrNum=PBDrugErrNum+1
	........s ^TMP("DHCIPBill","PBDrugErr",EpisodeId,$j,OEORDDr,OEORIDr,OEOREDr)=PBDrugErrStr	
	.....i ((CP="CR")&(OrdCateType="R")&(qflag="1")&(node=10)&((ItemStatCode="V")!(ItemStatCode="E"))) d
	......s CheckFlag=..GetCheckFlag(EpisodeId,"",OEOrdRowID)
	......i CheckFlag'="Y" d
	.......s DispTCInfo=..GetTCDspNew(OEORERowID)  ;取未发放的药品的数量
	.......s DisPTCQty=$p(DispTCInfo,"^",1)
	.......s DisPTCSum=DisPTCSum+(+DisPTCQty)
	.......i +DisPTCQty'=0 d
	........s ^TMP("DHCIPBill","TCDrug",EpisodeId,$j,OEORDDr,OEORIDr,OEOREDr)=DisPTCQty    
	........s NDrugNum=NDrugNum+1
	.....i ((CP="CR")&(OrdCateType="R")&(qflag="1")&(node=8)) d
	......s PBDrugErrStr=..GetOrdDispNew(OEOrdRowID,OEORERowID)
	......s PBDrugNum=$p(PBDrugErrStr,"^",2)
	......s DSPdrugNum=$p(PBDrugErrStr,"^",1)
	......///2015-02-19 chenxi 增加判断，在《住院费用监控配置》中 规则8 未配置的大类、子类、或医嘱项不检测
	......///现在有些医院有免费药的概念，此类药品发药但是不收费   
	......s DrugNumCheckFlag=$p(PBDrugErrStr,"^",3)
	......i (PBDrugNum'=DSPdrugNum)&(DrugNumCheckFlag="Y") d
	.......s PBDrugErrNum=PBDrugErrNum+1
	.......s ^TMP("DHCIPBill","PBDrugErr",EpisodeId,$j,OEORDDr,OEORIDr,OEOREDr)=PBDrugErrStr
	...;对于13没有执行记录规则的处理。
	...s NExecFlag="Y"
	...s NExecFlag=..CheckOrdAllowNExec(OEOrdRowID)
	...i NExecFlag'="Y"  d
	....;判断是否审核。
	....s CheckFlag=..GetCheckFlag(EpisodeId,"",OEOrdRowID)
	....i CheckFlag'="Y" d
	.....s OrdNExecDNum=OrdNExecDNum+1
	....s ^TMP("DHCIPBill","NORDExec",EpisodeId,$j,OEORDDr,OEORIDr)=""
	...i (NFirstQty'=0)  d
	....;s OrdNExecDNum=OrdNExecDNum+1
	....;s ^TMP("DHCIPBill","NORDExec",EpisodeId,$j,OEORDDr,OEORIDr)=""  
	..e  d
	...///modify 2014-10-14 判断床位费、诊查费、护理费等是否缺医嘱////////////////////////////////////////////////////////////////////////////////////////////////////// 
	...s StDate=$p($g(^OEORD(OEORDDr,"I",OEORIDr,1)),"^",9)
	...s TAbnormalDr=""
	...f  s TAbnormalDr=$o(^DHCCAbFeeConfig("YCFeeCheck",TAbnormalDr))  q:(TAbnormalDr="")  d
	....s CAbFeeConfig=$g(^DHCCAbFeeConfig("YCFeeCheck",TAbnormalDr))
	....q:(CAbFeeConfig="")
	....s useflag=$p(CAbFeeConfig,"^",4)
	....q:(useflag="0")&(node'=10)&(node'=8)&(node'=13)&(node'=14)&(node'=15)  //停用 
	....s qflag="0"
	....i $d(^DHCCAbFeeConfig("Details",TAbnormalDr,"OECCAT",OecCatDr))'=0  d
	.....s qflag="1"
	....i $d(^DHCCAbFeeConfig("Details",TAbnormalDr,"ARCIC",ArcItemCatDr))'=0  d
	.....s qflag="1"
	....i $d(^DHCCAbFeeConfig("Details",TAbnormalDr,"ARCIM",ArcimRowid))'=0  d
	.....s qflag="1"	
	....i ((TAbnormalDr=1)!(TAbnormalDr=2)!(TAbnormalDr=5)!(TAbnormalDr=6))&(qflag="1")  d
	.....s ^TMP("DHCIPBill","AlreadyPBDate",EpisodeId,$j,TAbnormalDr,StDate)="" 
	.../////////////////////////////////////////////////////////////////////////////////////////////////////////
	...i (CP="CR")&(OrdCateType="R") d
	....s LinkFlag=##class(web.UDHCJFBILL).GetUserLocLinkRecLoc(OEOrdRowID)
	....i LinkFlag="Y" s CP="OD"
	...i ((CP="CR")&(OrdCateType="R")) d
	....s DispTCInfo=..GetTCDspOld(OEOrdRowID)  ;取未发放的药品的数量
	....s DisPTCQty=$p(DispTCInfo,"^",1)
	....i +DisPTCQty'=0 d
	.....s ^TMP("DHCIPBill","TCDrug",EpisodeId,$j,OEORDDr,OEORIDr)=DisPTCQty
	.....s NDrugNum=NDrugNum+1   
	....s PBDrugErrStr=..GetOrdDispOld(OEOrdRowID)
	....s PBDrugNum=$p(PBDrugErrStr,"^",2)
	....s DSPdrugNum=$p(PBDrugErrStr,"^",1)   
	....i PBDrugNum'=DSPdrugNum d
	.....s PBDrugErrNum=PBDrugErrNum+1
	.....s ^TMP("DHCIPBill","PBDrugErr",EpisodeId,$j,OEORDDr,OEORIDr)=PBDrugErrStr
	...///modify 2014-10-11 根据配置判断医嘱是tb状态的 
	...s ItemStatDr=$p($g(^OEORD(OEORDDr,"I",OEORIDr,1)),"^",13)
	...s ItemStatCode="" 
	...i ItemStatDr'=""  d
	....s ItemStatCode=$p(^OEC("OSTAT",ItemStatDr),"^",1)
	...i (ItemStatCode="V")!(ItemStatCode="E")  d
	....s qflag="0"  
	....i $d(^DHCCAbFeeConfig("Details",10,"OECCAT",OecCatDr))'=0  d
	.....s qflag="1"
	....i $d(^DHCCAbFeeConfig("Details",10,"ARCIC",ArcItemCatDr))'=0  d
	.....s qflag="1"
	....i $d(^DHCCAbFeeConfig("Details",10,"ARCIM",ArcimRowid))'=0  d
	.....s qflag="1"
	....s PBNum=0
	....s PBNum=..GetOrdPBNumOld(OEOrdRowID)	
	....s OEBillFlag=$p($g(^OEORD(OEORDDr,"I",OEORIDr,3)),"^",5)
	....i (qflag="1")&((PBNum=0)!(OEBillFlag="TB"))  d
	.....i (OrdCateType="R")&(OEORIQty=0)  d
	.....e  d
	......s ^TMP("DHCIPBill","NBillOrd",EpisodeId,$j,OEORDDr,OEORIDr)=OEBillFlag_"^"_PBNum   
	......s OrdNExecSNum=OrdNExecSNum+1  
	q
}

/// creator:      zhougang 
/// creatdate:    2015-07-14
/// Descript：    判断规则或医嘱是否审核。
/// 单独判断规则时，必须传入就诊。
/// w ##class(web.DHCIPBillCheckAdmFee).GetCheckFlag(872,"","965||22")
ClassMethod GetCheckFlag(EpisodeId, Abnormal, Oeori)
{
		;"Oeori","Pbo",
	s RtnValue="N"
	q:(+$g(Abnormal)=0)&(+$g(Oeori)=0) "N"
	i (+$g(Abnormal)'=0) d
	i (+$g(Oeori)'=0) d
	.s JFCFARowid="0",ExamineFlagNum=0
	.f  s JFCFARowid=$o(^DHCJFCheckAdmFee(0,"Oeori",Oeori,JFCFARowid))  q:(JFCFARowid="")  d
	..s AdmDr=$p(^DHCJFCheckAdmFee(JFCFARowid),"^",1)
	..s Node=$p(^DHCJFCheckAdmFee(JFCFARowid),"^",2)
	..q:(EpisodeId'=AdmDr)&(EpisodeId'="")
	..q:(Abnormal'=Node)&(Abnormal'="")
	..s ExamineFlag=$p(^DHCJFCheckAdmFee(JFCFARowid),"^",6)
	..i ExamineFlag="Y" s ExamineFlagNum=ExamineFlagNum+1
	.i +ExamineFlagNum>0 s RtnValue="Y"
	e  d
	.s JFCFARowid="0",ExamineFlagNum=0
    .f  s JFCFARowid=$o(^DHCJFCheckAdmFee(0,"Adm",EpisodeId,JFCFARowid))  q:(JFCFARowid="")  d
	..s AdmDr=$p(^DHCJFCheckAdmFee(JFCFARowid),"^",1)
	..s Node=$p(^DHCJFCheckAdmFee(JFCFARowid),"^",2)
	..;q:+Abnormal=0
	..q:(EpisodeId'=AdmDr)&(EpisodeId'="")
	..q:(Abnormal'=Node)&(Abnormal'="")
	..s ExamineFlag=$p(^DHCJFCheckAdmFee(JFCFARowid),"^",6)
	..i ExamineFlag="Y"  d
	...s ExamineFlagNum=ExamineFlagNum+1 
	.i ExamineFlagNum>0 s RtnValue="Y"

	q RtnValue
}

/// creator:      chenxi
/// creatdate:    2016-06-10
/// Descript：    判断医嘱没有执行记录是否正确, 非长期医嘱必须有执行记录，长期医嘱首日次数为 0 的可以没有执行记录，
///               第二日开始必须有执行记录，医嘱停止之后的可以没有执行记录否则必须有执行记录，关联医嘱的判断根据主医嘱确定 
/// w ##class(web.DHCIPBillCheckAdmFee).CheckOrdAllowNExec("965||30")
ClassMethod CheckOrdAllowNExec(OEORIRowid)
{
	n (OEORIRowid)
	q:(OEORIRowid="") "N"
	s NExecFlag="Y"
	s OEORIOEORIDr=""
	s OEOrdDr=$p(OEORIRowid,"||",1)
	s OEOriDr=$p(OEORIRowid,"||",2)
	s OEORIOEORIDr=$p($g(^OEORD(OEOrdDr,"I",OEOriDr,11)),"^",39)
	///q:(OEORIOEORIDr="") "Y"
	s MotherOEOrdDr="",MotherOEOriDr="",MotherArcimDr="",MotherItemCat="",MotherOrdType=""
	i OEORIOEORIDr'=""  d
	.s MotherOEOrdDr=$p(OEORIOEORIDr,"||",1)
	.s MotherOEOriDr=$p(OEORIOEORIDr,"||",2)
	.s MotherArcimDr=$p($g(^OEORD(MotherOEOrdDr,"I",MotherOEOriDr,1)),"^",2)
	.q:MotherArcimDr=""	
	.s MotherItemCat=$p(^ARCIM(+MotherArcimDr,$p(MotherArcimDr,"||",2),1),"^",10)
	.i MotherItemCat'=""  d
	..s MotherOrdType=$p(^ARC("IC",MotherItemCat),"^",7)
	///b  ///1err
	s ArcimDr=$p($g(^OEORD(OEOrdDr,"I",OEOriDr,1)),"^",2)
	q:(ArcimDr="") "N"	
	s ItemCat=$p(^ARCIM(+ArcimDr,$p(ArcimDr,"||",2),1),"^",10)
	s OrdType=""
	i ItemCat'=""  d
	.s OrdType=$p(^ARC("IC",ItemCat),"^",7)
		
	k ^TMP("DHCIPBill","CheckExecOrd",OEORIRowid,$j)
	k ^TMP("DHCIPBill","CheckExecOrdMother",OEORIRowid,$j)
	k ^TMP("DHCIPBill","CheckExecOrdChild",OEORIRowid,$j)
	
	i OEORIOEORIDr=""   d
	.s OEORIQty=$p(^OEORD(OEOrdDr,"I",OEOriDr,1),"^",18)
	.s OEORIXDate=$p($g(^OEORD(OEOrdDr,"I",OEOriDr,3)),"^",34)	
	.i OEORIXDate=""  d
	..s OEORIXDate=+$h
	.s OEORIStDate=$p(^OEORD(OEOrdDr,"I",OEOriDr,1),"^",9)
	.s Prior="",PriorCode=""
    .s Prior=$p(^OEORD(OEOrdDr,"I",OEOriDr,1),"^",8)  
	.i Prior'=""  d
	..s PriorCode=$p($g(^OECPR(+Prior)),"^",1)
	.s OEordNum=0,OEordExcNum=0
	.f ExecDate=OEORIStDate:1:OEORIXDate  d
	..s OEordNum=OEordNum+1
	..s ^TMP("DHCIPBill","CheckExecOrd",OEORIRowid,$j,ExecDate)="" 
	.s OrdExecSub="0"
	.f  s OrdExecSub=$o(^OEORD(OEOrdDr,"I",OEOriDr,"X",OrdExecSub))  q:(OrdExecSub="")  d
	..s OEordExcNum=OEordExcNum+1
	..s OrdExecStDate=$p(^OEORD(OEOrdDr,"I",OEOriDr,"X",OrdExecSub),"^",1) 
	..q:(OrdExecStDate="")
	..s OrdExecRowid=OEOrdDr_"||"_OEOriDr_"||"_OrdExecSub
	..s ^TMP("DHCIPBill","CheckExecOrd",OEORIRowid,$j,OrdExecStDate,OrdExecRowid)=""
	.s FirstNum=0,ExecNum=0,StopErrNum=0
	.s OrdExecStDate=""
	.f  s OrdExecStDate=$o(^TMP("DHCIPBill","CheckExecOrd",OEORIRowid,$j,OrdExecStDate))  q:(OrdExecStDate="")  d
	..s StopNum=0
	..s OrdExecRowid=""  
	..f  s OrdExecRowid=$o(^TMP("DHCIPBill","CheckExecOrd",OEORIRowid,$j,OrdExecStDate,OrdExecRowid))  q:(OrdExecRowid="")  d
	...s ExecNum=ExecNum+1 
	...i OrdExecStDate=OEORIStDate  d
	....s FirstNum=FirstNum+1
	...s StopNum=StopNum+1
	..;i (StopNum=0)&(OrdExecStDate'>OEORIXDate)  d
	..///i (StopNum=0)&(OrdExecStDate'>OEORIXDate)&(OEordNum'=OEordExcNum)  d
	..i (StopNum=0)&(OrdExecStDate'>OEORIXDate)&(OrdExecStDate'=OEORIStDate)  d
	...s StopErrNum=StopErrNum+1
	..i (PriorCode="S")!(PriorCode="OMST")  d
	...i (FirstNum=0)&(+OEORIQty'=0)  d
	....s NExecFlag="N"		;OEORIOEORIDr 关联医嘱为空：首日执行次数不为0 首日的要求执行时间和实际执行时间不一致的
	...i StopErrNum'=0  d
	....s NExecFlag="N"		;确少医嘱执行记录的情况。
	...i (ExecNum=0)&(+OEORIQty'=0)  d 
	....s NExecFlag="N"		;这个判断感觉没有必要。[因为只要有执行记录 ExecNum 就不可能为 0 如果为 0 就是确实执行记录。 ]
	.i (PriorCode'="S")&(PriorCode'="OMST")  d
	..i ExecNum=0  d
	...s NExecFlag="N"
	e  d 
	.;有主医嘱的情况处理。根据主医嘱来判断。
	.s MotherOrdExecSub="0"
	.f  s MotherOrdExecSub=$o(^OEORD(MotherOEOrdDr,"I",MotherOEOriDr,"X",MotherOrdExecSub))  q:(MotherOrdExecSub="")  d
	..s MStatCodeDr=$p($g(^OEORD(+MotherOEOrdDr,"I",MotherOEOriDr,"X",MotherOrdExecSub,"BILL")),"^",1)
	..s MOrdExecStDate=$p(^OEORD(MotherOEOrdDr,"I",MotherOEOriDr,"X",MotherOrdExecSub),"^",1)
	..s MStatCode=""
	..i MStatCodeDr'=""  d
	...s MStatCode=$p($g(^OEC("OSTAT",+MStatCodeDr)),"^")  
	..i (MStatCode'="U")&(MStatCode'="D")&(MStatCode'="C")  d
	...s ^TMP("DHCIPBill","CheckExecOrdMother",OEORIRowid,$j,MOrdExecStDate)=$g(^TMP("DHCIPBill","CheckExecOrdMother",OEORIRowid,$j,MOrdExecStDate))+1
	.s OrdExecSub="0"
	.f  s OrdExecSub=$o(^OEORD(OEOrdDr,"I",OEOriDr,"X",OrdExecSub))  q:(OrdExecSub="")  d
	..s OrdExecStDate=$p(^OEORD(OEOrdDr,"I",OEOriDr,"X",OrdExecSub),"^",1)
	..s ^TMP("DHCIPBill","CheckExecOrdChild",OEORIRowid,$j,OrdExecStDate)=$g(^TMP("DHCIPBill","CheckExecOrdChild",OEORIRowid,$j,OrdExecStDate))+1
	.s NStopNum=0,MOrdExecStDate=""
	.f  s MOrdExecStDate=$o(^TMP("DHCIPBill","CheckExecOrdMother",OEORIRowid,$j,MOrdExecStDate))  q:(MOrdExecStDate="")  d
	..s MOrdExecNum=+$g(^TMP("DHCIPBill","CheckExecOrdMother",OEORIRowid,$j,MOrdExecStDate))
	..i MOrdExecNum'=0  d
	...s ChildOrdExecNum=+$g(^TMP("DHCIPBill","CheckExecOrdChild",OEORIRowid,$j,MOrdExecStDate)) 
	...i ChildOrdExecNum=0  d
	....s NStopNum=NStopNum+1 
	.i NStopNum'=0  d
	..s NExecFlag="N"  
	
	q NExecFlag
}

/// Function:     判断下医嘱计费药品医嘱数量和计费的数量是否一致
/// W ##CLASS(web.DHCIPBillCheckAdmFee).GetODOrdDispNew("497||78","497||78||1")
ClassMethod GetODOrdDispNew(OEOrdRowID, OEOrdExecRowID)
{
	n (OEOrdRowID, OEOrdExecRowID)
	s DisQty=0,PBOQty=0,EqualFlag="Y",PBOQtyAll=0
	
	Set DisQty=$p(^OEORD(+OEOrdExecRowID,"I",$p(OEOrdExecRowID,"||",2),"X",$p(OEOrdExecRowID,"||",3)),"^",5)
	s PBRowID=0
	f  s PBRowID=$o(^DHCPB(0,"OEEXC",OEOrdExecRowID,PBRowID)) q:PBRowID=""  d
	.s ChildSub=0
	.f  s ChildSub=$o(^DHCPB(0,"OEEXC",OEOrdExecRowID,PBRowID,ChildSub)) q:ChildSub=""  d
	..q:($d(^DHCPB(PBRowID,"O",ChildSub))=0)
	..s BillQty=$p(^DHCPB(PBRowID,"O",ChildSub),"^",5)
	..s RefundQty=$p(^DHCPB(PBRowID,"O",ChildSub),"^",6)
	..s PBOQty=BillQty+RefundQty
	..s PBOQtyAll=PBOQtyAll+PBOQty

	q DisQty_"^"_PBOQtyAll
}

ClassMethod GetTCDspNew(oeore As %String) As %String
{
	n (oeore)
	
	s retQty=""
	q:oeore="" retQty
	s OrdID=$p(oeore,"||",1)
	s OrdSub=$p(oeore,"||",2)
	s Orecsub=$p(oeore,"||",3)
	
	q:(OrdID="")!(OrdSub="")!(Orecsub="") retQty
		
	//判断医嘱状态(医嘱核实、未核实、停止状态)
	///s oestID=$p(^OEORD(OrdID,"I",OrdSub,1),"^",13)
	s oestID=$p(^OEORD(OrdID,"I",OrdSub,"X",Orecsub,"BILL"),"^",1) 
	q:oestID="" retQty
	s oestflag=$p($g(^OEC("OSTAT",oestID)),"^",1)
 	q:(oestflag'="V")&(oestflag'="E") retQty
 	 	
 	//判断医嘱优先级(是否自备药)
 	s PriorID=$p(^OEORD(OrdID,"I",OrdSub,1),"^",8)
 	q:PriorID="" retQty
 	s priorCode=$p($g(^OECPR(PriorID)),"^",1) ;医嘱优先级代码 
 	q:priorCode="" retQty            
 	q:$ZCVT(priorCode,"U")["OM" retQty
 	
 	///2015-02-19 chenxi 增加判断，在《住院费用监控配置》中 规则10 未配置的大类、子类、或医嘱项不检测
	
	s Arcimdr=$p(^OEORD(+OrdID,"I",OrdSub,1),"^",2)
	s Itemcatdr=$p(^ARCIM(+Arcimdr,$p(Arcimdr,"||",2),1),"^",10)
	s Ordcatdr=$p(^ARC("IC",Itemcatdr),"^",8)
	s AbnorNum=0,node=10
	s qflag="0"
	i $d(^DHCCAbFeeConfig("Details",node,"OECCAT",Ordcatdr))'=0  d
	.s qflag="1"
	i $d(^DHCCAbFeeConfig("Details",node,"ARCIC",Itemcatdr))'=0  d
	.s qflag="1"
	i $d(^DHCCAbFeeConfig("Details",node,"ARCIM",Arcimdr))'=0  d
	.s qflag="1"	
	
	s Checkflag="Y"
	i qflag="0"  d
	.s Checkflag="N"
 	
 	s ArcimID=$p(^OEORD(OrdID,"I",OrdSub,1),"^",2)
 	s ArcimSub=$p(ArcimID,"||",1)
 	q:ArcimSub="" retQty
 	s InciID=$o(^INCI(0,"ARCIM_DR",ArcimSub,""))
 	q:InciID="" retQty
 	s bUomID=$p(^INCI(InciID,1),"^",10)
 	q:bUomID="" retQty
 	s bUomDesc=$p($g(^CT("UOM",bUomID)),"^",2)
 	s dspID=""
 	f  s dspID=$o(^DHCOEDISQTY(0,"OEORE",oeore,dspID))  q:dspID=""  d
 	.q:$p(^DHCOEDISQTY(dspID),"^",7)'="TC"  //状态不是"TC"的不考虑
 	.s qty=$p(^DHCOEDISQTY(dspID),"^",11)
 	.s retQty=retQty+qty
	q:retQty="" retQty
	i $g(DisPTCInfo)="" s DisPTCInfo=oeore_"("_retQty_bUomDesc_")"
	e  s DisPTCInfo=DisPTCInfo_"&"_oeore_"("_retQty_bUomDesc_")"
	q retQty   ;_"^"_bUomDesc
}

}
