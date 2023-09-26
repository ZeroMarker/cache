Import SQLUser

/// 名称: web.DHCOPBillRefundRequestNew    
/// 描述: 门诊退费申请最新程序，将退药申请、退费申请、诊疗医嘱部分退费申请合并到一个程序
/// 编写者： 陈曦
/// 编写日期: 2014-04-11
Class web.DHCOPBillRefundRequestNew Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator： 陈曦
/// CreatDate： 2014-04-11
/// Description:： 组件中tableitem属性
ClassMethod SetAppItemData(CommentName, DataType) As %String
{
	s itmName="TDrugRetReason"  //_rs.GetDataByName("Tind")
	s Val=rs.GetDataByName("TDrugRetReasonDr")
	//s Requre=rs.GetDataByName("Require")
	//s FieldDR=rs.GetDataByName("FieldDR")
	s CommentID=##Class(websys.Component).GetIdFromCodeOrDescription(CommentName)
 	s Active="1"
 	s Active=$s(Active="1":"",1:"disabled")
 	s DataType="ListBox"
 	i DataType="ListBox" d
 	.w "<select id='"_itmName_"' name='"_itmName_"' size=1 "_Active_" style='WIDTH: 150px; HEIGHT: 25px' onchange='DrugRetReasononchange(this)'>"
 	.w "<option value=''></option>"
 	.s temp=##class(web.DHCOutPhReturn).GetReas()
 	.f Index=1:1:($l(temp,"^")) d
 	..s s=$p(temp,"^",Index)
 	..s TDrugRetReason=$p(s,$c(1),1)
 	..s Desc=$p(s,$c(1),2)
 	..i TDrugRetReason=Val w "<option value="_TDrugRetReason_" selected>"_TDrugRetReason_"</option>"
 	..e  w "<option value="_TDrugRetReason_">"_Desc_"</option>"
 	.w "</select>"
 	e  d
 	.s IMGId="ld"_CommentID_"iTDiscReasonz"_rs.GetDataByName("Tind")
 	.w "<input type=text id='"_itmName_"' name='"_itmName_"' style='WIDTH:120px;HEIGHT:24px' value='"_Val_"' onkeydown='lookuphandler(this)'>"
 	.w "<IMG id='"_IMGId_"' name='"_IMGId_"' src='../images/websys/lookup.gif' onclick='lookuphandler(this)'>"
 
 	q ""
}

/// Creator：         陈曦
/// CreatDate：       2014-04-14
/// Description:：    申请退药原因 
Query FindDrugReturnRea() As websys.Query(ROWSPEC = "ReasonDesc:%String,ReasonDr:%String")
{
}

/// d ##class(%ResultSet).RunQuery("web.DHCOPBillRefundRequestNew","FindDrugReturnRea")
ClassMethod FindDrugReturnReaExecute(ByRef qHandle As %Binary) As %Status
{
 	set repid=$I(^CacheTemp)
 	set ind=1
 	set ReasonDesc=""
 	set ReasonDr="0"
 	do OutputRea
 	set ReasonInfo=##class(web.DHCOutPhReturn).GetReas()
 	set count=$l(ReasonInfo,"^")
 	for i=1:1:count  do
 	.set ReasonStr=$p(ReasonInfo,"^",i)
 	.quit:(ReasonStr="")
 	.set ReasonDesc=$p(ReasonStr,$c(1),2) 
 	.set ReasonDr=$p(ReasonStr,$c(1),1)
 	.do OutputRea    
		
 	set qHandle=$lb(0,repid,0)
 	quit $$$OK
OutputRea
 	set Data=$lb(ReasonDesc,ReasonDr)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=ind+1
 	quit
}

Query GetOrderbyReceipIDOweDrug(ReceipRowid As %String, AuditFlag As %String, InvType As %String, ExpStr As %String) As websys.Query(ROWSPEC = "Tselect:%String,TOrder:%String,TOrderSum:%String,TOrderQty:%String,TRecloc:%String,TReturnQty:%String,TOrderRowid:%String,TExcuteflag:%String,RefSum:%String, AuditFlag:%String, AuditCheckDis:%String,AuditSelFlag:%String,OEORDExecQty:%String,PrescNo:%String,CMFlag:%String,AuditUserName:%String,AuditDateTime:%String,ExecutFlagDesc:%String,mySeqNo:%String,UnAuditOrdItem:%String,TExecutDesc,TOrdUserDepDesc,InvPrtDr,TItemStat,TLinkOrder,TOrdDate,TDepDesc,TDrugRetRequ,TDrugRetReason,TDrugRetALready,TDrugRetReasonDr,Tind,TOrderType,TOEORDExecQty,TCanReturnNum,Tphdi,TOweFlag,TDrugCollect,Tinciflag,TOrdStopStatus,TMatDispGrant:%String")
{
}

/// 增加发票RowID
/// AuditFlag审批标志
/// =""  默认查询所有的
/// 在此编写算法计算必须要退的医嘱项目selflag=1
/// Executflag  应该表示为?执行医嘱标志?(只要医嘱被执行过?药品和费用项目等)
/// InvType   "PRT"           dhc_invprt
/// InvType   "API"           dhc_accpayinv   
/// d ##class(%ResultSet).RunQuery("web.DHCOPBillRefundRequestNew","GetOrderbyReceipIDOweDrug","219617","","PRT","4988^6^303^2")
ClassMethod GetOrderbyReceipIDOweDrugExecute(ByRef qHandle As %Binary, ReceipRowid As %String, AuditFlag As %String, InvType As %String, ExpStr As %String) As %Status
{
	set repid=$I(^CacheTemp)
	set ind=1
	set qHandle=$lb(0,repid,0)
	if +$g(ReceipRowid)=0 	quit $$$OK
	do ResetVariablesOweDrug

	s myorind=""
	s Guser=$p(ExpStr,"^",1)
	s Grp=$p(ExpStr,"^",2)
	s Loc=$p(ExpStr,"^",3)
	s Hosp=$p(ExpStr,"^",4)
	s Rtn=##class(web.DHCSOPFConfig).SELECT(1)
	s LocStr="#"_PLIST(43)
	i LocStr[("#"_Loc_"#") s myLoc="" //20150508 在此配置可以全部审批的科室 ywb
	e  s myLoc=Loc
	i InvType=""   s InvType="PRT"
	s HerbConfig=##class(web.DHCOPConfig).GetHerbalConfig()
	s FCHerbRange=$p(HerbConfig,$c(2),5)
	s UnAuditOrderCateStr=##class(web.DHCOPConfig).GetUnAuditOrderCate()
	
	s MYYPorderstr1=""
	i (InvType="PRT")  d
	.s MYYPorderstr1=..PHRequest(ReceipRowid, myLoc)
	.i (ind'=1) s myorind=ind
	.d GetInvDetailOweDrug(ReceipRowid, myLoc)
	i (InvType="API")  d
	.s APCons="0"
	.f  s APCons=$o(^DHCINVPRTCAPi(0,"APINVDR",ReceipRowid,APCons))   q:(APCons="")  d
	..s InvDrid=$p($g(^DHCINVPRTCAP(APCons)),"^",1)
	..s myorind=""
	..s MYYPorderstr1=..PHRequest(InvDrid, myLoc)
	..i (ind'=1) s myorind=ind
	..d GetInvDetailOweDrug(InvDrid, myLoc)
	
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK	
	
GetInvDetailOweDrug(InvDr, myLoc)
	s conRowid=0 
	f  s conRowid=$o(^DHCBCI(0,"INV",InvDr,conRowid)) q:(conRowid="")  d
	.s bill=$p($g(^DHCBCI(conRowid)),"^",2)
	.s selflag=1
	.s confac=""
	.s PBOChildsub=0
	.f  s PBOChildsub=$o(^DHCPB(bill,"O",PBOChildsub)) q:(PBOChildsub="")  d
	..q:($d(^DHCPB(bill,"O",PBOChildsub))=10)
	..s (AuditUserName,AuditDateTime,ExecutFlagDesc,TOrderType,TDrugRetReason,TDrugRetALready,TDrugRetReasonDr)=""
	..s Arcim=$p(^DHCPB(bill,"O",PBOChildsub),"^",3) ;DHC_PatBillOrder->PBO_ARCIM_DR
	..s ArcItmCateDR=$p(^ARCIM(+Arcim,$p(Arcim,"||",2),1),"^",10)   ;医嘱子类
	..i (($c(2)_UnAuditOrderCateStr_$c(2))[($c(2)_ArcItmCateDR_$c(2))) s UnAuditOrdItem="Y" ;医嘱属于免审核的子类则q出 add by wanghc 2009-10-12
	..e  s UnAuditOrdItem="N"
	..s ArcimDesc=$p($g(^ARCIM(+Arcim,$p(Arcim,"||",2),1)),"^",2)   ;名称
	..s OEORI=$p(^DHCPB(bill,"O",PBOChildsub),"^",4) ;DHC_PatBillOrder->PBO_OEORI_DR
	..s OrderDept=$p($g(^OEORD(+OEORI,"I",+$p(OEORI,"||",2),7)),"^",2) ;开单科室
	..q:(myLoc'="")&(OrderDept'=myLoc)    //20150508 本科室只能审核本科室开的医嘱 ywb	
	..s mySeqNo=""
	..s:$d(^OEORD(+OEORI,"I",$p(OEORI,"||",2),3))'=0 mySeqNo=$p(^OEORD(+OEORI,"I",$p(OEORI,"||",2),3),"^",4)
	..s TOrdStopStatus=""
	..s ItemStatDR=$p($g(^OEORD(+OEORI,"I",+$p(OEORI,"||",2),1)),"^",13) 
	..i (+ItemStatDR'=0) d
	...s TOrdStopStatus=$p(^OEC("OSTAT",ItemStatDR),"^",1)
	..s myAuditFlag="",myAuditCheckDis="",myAuditSelFlag=""
	..//2016-02-03 chenxi 门诊退费审核与门诊退费区分，退费审核时停医嘱自动勾选上，退费时需审核过才自动勾选
	..s RefFlag="Request"      //RefFlag  Request---退费审核，Refund--退费
	..s ExpStr=RefFlag
	..s myrtn=##class(web.UDHCPRTOEAuthIF).ReadOEORDAuthFlag(InvDr, OEORI, ExpStr)
	..s myAuditFlag=$p(myrtn,"^",1)         ;判断是否审批
	..s myAuditCheckDis=$p(myrtn,"^",2)		;判断选择项目是否Disable
	..s myAuditSelFlag=$p(myrtn,"^",3)		;判断选择项目是否被选中
	..//新版检查申请单标志
	..s isAppRepFlag=##class(web.UDHCJFPRICE).IsAppRepOrder(OEORI)
	..s Executflag=0
	..//+2017-08-28 ZhYW 判断是否走门诊物资发放流程
	..s matDispGrant=..CheckIsMatDispGrant(OEORI, Hosp)
	..s OrderUnitPrice=$p(^DHCPB(bill,"O",PBOChildsub),"^",7)	;PBO_UnitPrice
	..s myPatUnitPrice=0				;患者的自付分类单价
	..s SFlag=0
	..s myPriceInfo=##class(web.UDHCOEORDOPIF).GetOrderPrice(bill_"||"_PBOChildsub, OEORI, SFlag, "")
	..s OrderUnitPrice=$p(myPriceInfo,"^",1)				     ;PBO_UnitPrice
	..s myPatUnitPrice=$p(myPriceInfo,"^",4)				     ;PBO_PatPrice
	..s Billreturnqty=+$p(^DHCPB(bill,"O",PBOChildsub),"^",6)	 ;PBO_RefundQty
	..s OrderBillQty=$p(^DHCPB(bill,"O",PBOChildsub),"^",5)		 ;PBO_BillQty
	..s returnqty=0
	..//modify 2015-01-06 修改协议处方取值方式
	..s confac=##class(web.DHCBillCommon).GetUomConvFactor(Arcim, OEORI)
	..s OrderBillQty=(OrderBillQty+Billreturnqty)/confac
	..//s PatSum=OrderUnitPrice*OrderBillQty
	..s TotalSum=$p(^DHCPB(bill,"O",PBOChildsub),"^",8)
	..s PatSum=$p(^DHCPB(bill,"O",PBOChildsub),"^",11)
	..s PatSum=$fn(PatSum,"",2)
	..s myRefSum=PatSum
	..s recdepcode=$p($g(^OEORD(+OEORI,"I",+$p(OEORI,"||",2),3)),"^",6) ;接收科室
	..;增加审核人审核时间
	..s AuditInfo=..GetCheckUserDateByOrdId(OEORI, "")
	..s AuditUserNametmp=$p(AuditInfo,"^",1)
	..s AuditDateTimetmp=$p(AuditInfo,"^",2)
	..s recdepdesc=$p($g(^CTLOC(recdepcode)),"^",2)
	..i ($l(recdepdesc,"-")>1)  s recdepdesc=$p(recdepdesc,"-",2)
	..s ARCCATRowid=$p(^ARCIM(+Arcim,$p(Arcim,"||",2),1),"^",10)
	..s ARCOrdType=$p(^ARC("IC",ARCCATRowid),"^",7)
	..s myPrescNo="", myCMFlag=""
	..s TOweFlag="1"
	..s inci=$o(^INCI(0,"ARCIM_DR",+Arcim,""))
	..s AllowOrderWOStockCheck=$p(^ARCIM(+Arcim,$p(Arcim,"||",2),8),"^",11)
	..s Tinciflag="Y"      //"Y"不走库存, "N"走库存
	..i ((inci'="")&&(AllowOrderWOStockCheck'="Y"))  d
	...s Tinciflag="N"
	..i (ARCOrdType="R")  d
	...q:(MYYPorderstr1[("^"_OEORI_"^"))
	...s myPrescNo=$p($g(^OEORD(+OEORI,"I",+$p(OEORI,"||",2),1)),"^",14) ;处方号
	...i FCHerbRange[("^"_ARCCATRowid_"^") s myCMFlag="Y"
	...s Executflag=##class(web.UDHCOEORDOPIF).CheckPhDispRet(OEORI)
	...s returnqty=##class(web.DHCOutPhReturn).GetRetOrdQty(OEORI, InvDr)
	...//modify 2013-07-18 chenxi 配液中心药品取药房接口程序
    ...s OEFlag=$p($g(^OEORD(+OEORI,"I",$p(OEORI,"||",2),"DHC")),"^",16)
    ...i (OEFlag="Y")  d
    ....s PackQty=##class(web.DHCSTPIVAOUTCOMMON).GetPIVAOutValidQty(OEORI)
    ....s PackQty=PackQty/confac
    ....s returnqty=OrderBillQty-PackQty
	...//modify 2014-04-16 退费审核时调用药房组接口获取已发药数量、已申请退药数量、已退药数量	
	...s TOEORDExecQty=0,TDrugRetALready=0,TCanReturnNum=0,OEORDExecQty=0
	...s OEORDExecQty=..ReadOEORDExecQty(InvDr, OEORI, "")
	...s DrugNumInfo=##class(web.DHCSTINTERFACE).GetOutPhOrditmQty(OEORI, InvDr)
	...i (DrugNumInfo'="")  do
	....s TDrugCollect=+$p(DrugNumInfo,"^",1)
	....s TDrugRetALready=+$p(DrugNumInfo,"^",2)
	....s returnqty1=returnqty/confac
	....s TCanReturnNum=OrderBillQty-TDrugRetALready-returnqty1
	...s confac=##class(web.DHCBillCommon).GetUomConvFactor(Arcim, OEORI)
	...s returnqty=returnqty/confac
	...i (Executflag=0) d  
	....;药物医嘱?没有发药的
	....s selflag=0
	...e  d
	....;药物医嘱?已经发药的?Executflag=1
	....s selflag=0
	....;已经退药的
	....i (+returnqty'=0) d  
	.....i OrderBillQty=returnqty d
	......s selflag=1		//全部退
	.....e  d
	......s selflag=1		//部分退
	.....;s myRefSum=$fn($fn((myRefSum/OrderBillQty),"",6)*returnqty,"",2)
	.....i (+PatSum'=0) d
	......;s myRefSum=OrderUnitPrice*confac*returnqty
	......s myRefSum=myPatUnitPrice*confac*returnqty
	......s myRefSum=$fn(myRefSum+0.0000001,"",2)
	...s:(Executflag="1") ExecutFlagDesc="已发药"
	...i (+selflag=1)&(+Executflag=1) d
	....s myAuditSelFlag=1
	...s invprtAuditFlag=$p(^DHCINVPRT(InvDr),"^",22)    //add by wanghc
	...i (myAuditFlag="Y")&(invprtAuditFlag="Y") d
	....s AuditUserDr=$p(^DHCINVPRT(InvDr),"^",25)
	....s AuditUserName=""
	....i (AuditUserDr'="") s AuditUserName=$p(^SSU("SSUSR",AuditUserDr),"^",2)
	....s AuditDate=$p(^DHCINVPRT(InvDr),"^",23)
	....s AuditTime=$p(^DHCINVPRT(InvDr),"^",24)
	....s AuditDate=##class(websys.Conversions).DateLogicalToHtml(AuditDate)
	....s AuditTime=##class(websys.Conversions).TimeLogicalToHtml(AuditTime, 1)
	....s AuditDateTime=AuditDate_" "_AuditTime
	....s ExecutFlagDesc="已审核"
	...s ItemStat=$p($g(^OEORD(+OEORI,"I",+$p(OEORI,"||",2),1)),"^",13) ;医嘱状态
	...s TItemStat=$p(^OEC("OSTAT",ItemStat),"^",2)
	...s TLinkOrder=$p($g(^OEORD(+OEORI,"I",+$p(OEORI,"||",2),11)),"^",39) ;关联医嘱指针
	...s TOrdDate=$p($g(^OEORD(+OEORI,"I",+$p(OEORI,"||",2),1)),"^",9) ;医嘱日期
	...s TOrdDate=##class(websys.Conversions).DateLogicalToHtml(TOrdDate)
	...s TDepID=$p($g(^OEORD(+OEORI,"I",+$p(OEORI,"||",2),1)),"^",3) ;科室
	...s:TDepID'="" TDepDesc=$p($p(^CTLOC(TDepID),"^",2),"-",2)
	...s Tphdi=""
	...;q:+PatSum=0
	...q:+TotalSum=0   ;记账系数为1时,要求显示明细  add zhli  17.9.8
    ...s TDrugRetReasonDr="",TDrugRetReason=""
    ...s AuditUserName="",AuditDateTime=""
    ...i $d(^DHCINVPRT(InvDr,"OA")) d
    ....s OASub=""
    ....f  s OASub=$o(^DHCINVPRT(InvDr,"OA",OASub)) q:OASub=""  d
    .....s OAOEORI=$p(^DHCINVPRT(InvDr,"OA",OASub),"^",1)
    .....q:OAOEORI'=OEORI
    .....s TDrugRetReasonDr=$p(^DHCINVPRT(InvDr,"OA",OASub),"^",11) 
	.....i (TDrugRetReasonDr'="")  d
	......s TDrugRetReason=$p($g(^DHCINVOPREFR(TDrugRetReasonDr)),"^",2)
	.....s ExecutFlagDesc="已审核"
	.....s AuditUserDr=$p(^DHCINVPRT(InvDr,"OA",OASub),"^",2)
	.....s AuditUserName=""
	.....i (AuditUserDr'="") s AuditUserName=$p(^SSU("SSUSR",AuditUserDr),"^",2)
	.....s AuditDate=$p(^DHCINVPRT(InvDr,"OA",OASub),"^",3)
	.....s AuditTime=$p(^DHCINVPRT(InvDr,"OA",OASub),"^",4) 
	.....s AuditDate=##class(websys.Conversions).DateLogicalToHtml(AuditDate)
	.....s AuditTime=##class(websys.Conversions).TimeLogicalToHtml(AuditTime, 1)
	.....s AuditDateTime=AuditDateTime_" "_AuditTime
	...d OutputRowOweDrug
	..e  d
	...s ExecutFlagDesc=""
	...s TOweFlag="0"
	...s OrdStat=$p(^OEORD(+OEORI,"I",$p(OEORI,"||",2),1),"^",13)
	...s OrdStatdesc=$p(^OEC("OSTAT",OrdStat),"^",2)
	...i ($p(^OEC("OSTAT",OrdStat),"^",1)="E") d
	....i (isAppRepFlag="Y") d
	.....;判断是否是部分执行
	.....s isPartExecFlag=##class(web.udhcOPRefund).IsPartExecut(OEORI)
	.....i isPartExecFlag=0 d
	......s Executflag=0
	......s selflag=0
	....e  d
	.....;被执行的非药物医嘱?
	.....s Executflag=1
	.....s selflag=0
	...e  d
	....;没有被执行的非药物医嘱?
	....;对于部分执行医嘱的退费
	....s TDrugCollect=0,TDrugRetALready=0
	....s OEORDExecQty=##class(web.UDHCOEORDOPIF).ReadOEORDExecQty(InvDr, OEORI, "")
	....i (+OEORDExecQty'=0) d
	.....//s myRefSum=(OrderBillQty-OEORDExecQty)*OrderUnitPrice
	.....s myRefSum=(OrderBillQty-OEORDExecQty)*myPatUnitPrice
	.....s:(+myRefSum<0) myRefSum=0
	.....s myRefSum=$fn(myRefSum+0.0000001,"",2)
	....s Executflag=0
	....s selflag=0
	...s:(Executflag="1") ExecutFlagDesc="已执行"
	...;申请退费数量不为0时,按申请退费数量退费
	...s invprtAuditFlag=$p(^DHCINVPRT(InvDr),"^",22) //add by wanghc
	...//2017-06-28 modify by ZhYW
	...i (matDispGrant="Y") d
	....//判断物资是否已发放
	....s Executflag=##class(web.DHCSTM.PCHCOLLSM).CheckDispStaByOeori(OEORI)
	....s:(Executflag=0) ExecutFlagDesc="未发放"
	....s:(Executflag=1) ExecutFlagDesc="已发放"
	....s ApplyRefQtyInfo=##class(web.DHCOPBillOERefundQty).GetApplyRefundQty(OEORI, InvDr)
	...e  d
	....s ApplyRefQtyInfo=##class(web.DHCOPBillOERefundQty).GetRefundQTY(OEORI, "")
	...s ApplyRefQty=+$p(ApplyRefQtyInfo,"^",2)
	...i (+ApplyRefQty'=0) d
	....i (invprtAuditFlag="Y") d
	.....s myAuditSelFlag=1
	.....s Executflag=1
	...//
	...//s returnqty=+$p(ApplyRefQtyInfo,"^",3)
	...s returnqty=""
	...s myRefSum=ApplyRefQty*myPatUnitPrice
	...//modify 2014-04-18 根据配置判断是否可退,计算可退数量
	...s TDrugRetALready="", TCanReturnNum=""
	...s TDrugRetALready=ApplyRefQty
	...s TCanReturnNum=OrderBillQty-TDrugRetALready-OEORDExecQty
	...i (+selflag=1)&(+Executflag=1) d
	....s myAuditSelFlag=1
	...i (myAuditFlag="Y") d
	....s invprtAuditFlag=$p(^DHCINVPRT(InvDr),"^",22)     //add by wanghc
	....i (invprtAuditFlag="Y") d
	.....//s AuditUserName=$p(^SSU("SSUSR",$p(^DHCINVPRT(InvDr),"^",25)),"^",2)
	.....//s AuditDateTime=$zd($P(^DHCINVPRT(InvDr),"^",23),3)_" "_$zt($P(^DHCINVPRT(InvDr),"^",24),2) //end 2009-9-11
	.....//s ExecutFlagDesc="已审核"
	...s ItemStat=$p($g(^OEORD(+OEORI,"I",+$p(OEORI,"||",2),1)),"^",13)    ;医嘱状态
	...s TItemStat=$p(^OEC("OSTAT",ItemStat),"^",2)
	...s TLinkOrder=$p($g(^OEORD(+OEORI,"I",+$p(OEORI,"||",2),11)),"^",39) ;关联医嘱指针
	...s TOrdDate=$p($g(^OEORD(+OEORI,"I",+$p(OEORI,"||",2),1)),"^",9) ;医嘱日期
	...s TOrdDate=##class(websys.Conversions).DateLogicalToHtml(TOrdDate)
	...s TDepID=$p($g(^OEORD(+OEORI,"I",+$p(OEORI,"||",2),1)),"^",3) ;科室
	...s:(TDepID'="") TDepDesc=$p($p(^CTLOC(TDepID),"^",2),"-",2)
	...s Tphdi=""
	...;q:+PatSum=0
	...q:+TotalSum=0   ;记账系数为1时,要求显示明细  add zhli  17.9.8
	...s TDrugRetReasonDr="",TDrugRetReason=""
    ...s AuditUserName="",AuditDateTime=""
    ...i $d(^DHCINVPRT(InvDr,"OA")) d
    ....s OASub=""
    ....f  s OASub=$o(^DHCINVPRT(InvDr,"OA",OASub)) q:OASub=""  d
    .....s OAOEORI=$p(^DHCINVPRT(InvDr,"OA",OASub),"^",1)
    .....q:(OAOEORI'=OEORI)
    .....s ApplyRefQtyInfo=##class(web.DHCOPBillOERefundQty).GetRefundQTY(OAOEORI, "")
    .....s ApplyRefQty=+$p(ApplyRefQtyInfo,"^",2)
    .....//q:+ApplyRefQty=0
    .....s TDrugRetReasonDr=$p(^DHCINVPRT(InvDr,"OA",OASub),"^",11) 
	.....i (TDrugRetReasonDr'="")  d
	......s TDrugRetReason=$p($g(^DHCINVOPREFR(TDrugRetReasonDr)),"^",2)
	.....s ExecutFlagDesc="已审核"
	.....s AuditUserDr=$p(^DHCINVPRT(InvDr,"OA",OASub),"^",2)
	.....s AuditUserName=""
	.....i (AuditUserName'="") s AuditUserName=$p(^SSU("SSUSR",AuditUserDr),"^",2)
	.....s AuditDate=$p(^DHCINVPRT(InvDr,"OA",OASub),"^",3)
	.....s AuditTime=$p(^DHCINVPRT(InvDr,"OA",OASub),"^",4)
	.....s AuditDate=##class(websys.Conversions).DateLogicalToHtml(AuditDate)
	.....s AuditTime=##class(websys.Conversions).TimeLogicalToHtml(AuditTime, 1)
	.....s AuditDateTime=AuditDate_" "_AuditTime
	...d OutputRowOweDrug
	
	quit
OutputRowOweDrug
	set Data=$lb(selflag,ArcimDesc,PatSum,OrderBillQty,recdepdesc,returnqty,OEORI,Executflag,myRefSum,myAuditFlag,myAuditCheckDis, myAuditSelFlag, OEORDExecQty,myPrescNo,myCMFlag,AuditUserName,AuditDateTime,ExecutFlagDesc,mySeqNo,UnAuditOrdItem,TExecutDesc,TOrdUserDepDesc,$g(InvDr),$g(TItemStat),$g(TLinkOrder),$g(TOrdDate),$g(TDepDesc),$g(TDrugRetRequ),$g(TDrugRetReason),$g(TDrugRetALready),$g(TDrugRetReasonDr),ind,$g(ARCOrdType),$g(TOEORDExecQty),$g(TCanReturnNum),Tphdi,$g(TOweFlag),$g(TDrugCollect),$g(Tinciflag),TOrdStopStatus,matDispGrant)
	set ^CacheTemp(repid,ind)=Data
	set ind=ind+1
	quit
ResetVariablesOweDrug
	set (selflag,ArcimDesc,PatSum,OrderBillQty,recdepdesc,returnqty,OEORI,Executflag,myRefSum, myAuditFlag, myAuditCheckDis, myAuditSelFlag,myPrescNo,myCMFlag,mySeqNo,TItemStat,TLinkOrder,TOrdDate,TDepDesc,TDrugRetRequ,TDrugRetReason,TDrugRetALready,TDrugRetReasonDr,ARCOrdType,Tphdi,TDrugCollect,Tinciflag,TOweFlag,TOrdStopStatus,matDispGrant)=""
	set selflag=0
	;医嘱执行数量 对于药物医嘱指发药数量
	set OEORDExecQty=0
	quit
}

/// Creator：         陈曦
/// CreatDate：       2014-04-14
/// Description:：    申请退药原因 
Query FindDrugReturnRea1() As websys.Query(ROWSPEC = "ReasonDr:%String,ReasonDesc:%String")
{
}

/// d ##class(%ResultSet).RunQuery("web.DHCOPBillRefundRequestNew","FindDrugReturnRea")
ClassMethod FindDrugReturnRea1Execute(ByRef qHandle As %Binary) As %Status
{
 	set repid=$I(^CacheTemp)
 	set ind=1
 	set ReasonDesc=""
 	set ReasonDr="0"
 	do OutputRea1
 	set ReasonInfo=##class(web.DHCOutPhReturn).GetReas()
 
 	set LReason=$l(ReasonInfo,"^")
 	for ReasonNum=1:1:LReason  do
 	.set ReasonStr=$p(ReasonInfo,"^",ReasonNum)
 	.quit:(ReasonStr="")
 	.set ReasonDesc=$p(ReasonStr,$c(1),2)
 	.set ReasonDr=$p(ReasonStr,$c(1),1)
 	.do OutputRea1    
		
 	set qHandle=$lb(0,repid,0)
 	quit $$$OK
OutputRea1
 	set Data=$lb(ReasonDr,ReasonDesc)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=ind+1
 	quit
}

/// 根据医嘱id获取审核人和审核时间的方法。
/// w ##class(web.DHCOPBillRefundRequestNew).GetCheckUserDateByOrdId("81370||1","")
ClassMethod GetCheckUserDateByOrdId(OeordItemDr As %String, ExpStr As %String = "") As %String
{
	n (OeordItemDr,ExpStr)
	s CheckUser="",CheckDate="",CheckTime=""
    i $d(^DHCORDItem(0,OeordItemDr)) d
    .s DHCORIRowId=""		
    .f  s DHCORIRowId=$o(^DHCORDItem(0,OeordItemDr,DHCORIRowId)) q:DHCORIRowId=""  d
    ..q:(+DHCORIRowId=0)
    ..q:'$d(^DHCORDItem(DHCORIRowId,1))
    ..s RefundAuditStatus=$p(^DHCORDItem(DHCORIRowId,1),"^",1)	;DHCORI_RefundAuditStatus  N ,A ,C : 正常的,审核,取消审核
    ..q:RefundAuditStatus'="A"
    ..s RefundAuditUser=$p(^DHCORDItem(DHCORIRowId,1),"^",2)	;DHCORI_RefundAuditUser_Dr
    ..s RefundAuditDate=$p(^DHCORDItem(DHCORIRowId,1),"^",3)	;DHCORI_RefundAuditDate
    ..s RefundAuditTime=$p(^DHCORDItem(DHCORIRowId,1),"^",4)	;DHCORI_RefundAuditTime
    
	i +$g(RefundAuditUser)'=0 s CheckUser=$p(^SSU("SSUSR",RefundAuditUser),"^",2)
	i +$g(RefundAuditDate)'=0 s CheckDate=$zd(RefundAuditDate,3)
	i +$g(RefundAuditTime)'=0 s CheckTime=$zt(RefundAuditTime,2)

	q CheckUser_"^"_CheckDate_" "_CheckTime
}

/// w ##class(web.DHCOPBillRefundRequestNew).VerifyByType(214542,639,"214542@@^^^983||8^639^^^^P^1^^^^@@983||8",1,231)
ClassMethod VerifyByType(INVPRTRowid As %String, vUser As %String, AuditINfo As %String, RefReason As %String, RefAudiLocDR As %String) As %String
{
  	New (INVPRTRowid,vUser,AuditINfo,RefReason ,RefAudiLocDR)
	//Set ^TMP("VerifyByType",INVPRTRowid)=$lb(INVPRTRowid, vUser, AuditINfo, RefReason, RefAudiLocDR)
	Set rtn=0
	If (AuditINfo'="") {
		Set rtn=0
		For num=1:1:$l(AuditINfo,$c(3))  Quit:(+rtn'=0)  Do
		.Set DataStr=$p(AuditINfo,$c(3),num)
		.Set InvDr=$p(DataStr,"@@",1)
		.Set AuditStr=$p(DataStr,"@@",2)
		.Set OEORDStr=$p(DataStr,"@@",3)
		.Set rtn=..VerifyRefundRcp(InvDr, vUser, AuditStr, OEORDStr, RefReason, RefAudiLocDR)	
	}Else{
		Set rtn=0
		Set rtn=..VerifyRefundRcp(INVPRTRowid, vUser, "", "", RefReason, RefAudiLocDR)
	}
	
	quit rtn
}

/// ##class(web.DHCOPBillRefundRequestNew).VerifyRefundRcp(4680,1472,^TMPVerify,"2531||10^2531||10^2531||11^2531||12",1,69)
ClassMethod VerifyRefundRcp(INVPRTRowid As %String, vUser As %String, AuditINfo As %String, OEORDStr As %String, RefReason As %String, RefAudiLocDR As %String) As %String
{
	n (INVPRTRowid, vUser, AuditINfo, OEORDStr, RefReason, RefAudiLocDR)
	;s $ZT="ERROR^DHCSSERR"
	
	s myrtn=0
	;
	d ..tb()
	
	s vdate=+$h
	s vtime=$p($h,",",2)
	&sql(update DHC_INVPRT set PRT_AllowRefund='Y',PRT_AllRefundDate=:vdate,PRT_AllRefundTime=:vtime,PRT_AllRefundUser=:vUser,
		PRT_RefundReason=:RefReason, PRT_RefAuditLoc_DR=:RefAudiLocDR
		where PRT_Rowid=:INVPRTRowid)
	s myrtn=SQLCODE
	
	;yyx 2012-05-24 增加退费审核日期索引
	s ^DHCINVPRT(0,"RefundConfirmDATE",vdate,INVPRTRowid)=""
	;RefAuditLocDR, RefundReason
	
	i (+myrtn=0)&(($tr(OEORDStr," ",""))'="") d
	.//s myrtn=##class(web.UDHCPRTOEAuthIF).SaveAuthInfo(INVPRTRowid,vUser, OEORDStr, AuditINfo,RefAudiLocDR, RefReason, "")
	.s myrtn=..SaveAuthInfo(INVPRTRowid,vUser, OEORDStr, AuditINfo, RefAudiLocDR, RefReason, "")
	;

	i (+myrtn=0) d
	.d ..tc()
	e  d
	.Trollback

	q +myrtn
}

ClassMethod SaveAuthInfo(PRTRowID As %String, UserDR As %String, OEORDStr As %String, OEAuthInfo As %String, RefAuditLocDR As %String, RefundReason As %String, ExpStr As %String) As %String
{
	n (PRTRowID, UserDR, OEORDStr, OEAuthInfo, RefAuditLocDR, RefundReason, ExpStr)
	s myrtn=..InsertAuthInfo(PRTRowID, UserDR, OEAuthInfo, RefundReason)
	q:(myrtn'=0) myrtn
	s myrtn=..UpdateOEItmFAuth(OEORDStr, UserDR, RefAuditLocDR, RefundReason, "A")
	q:(myrtn'=0) myrtn
	
	;modify 2014-04-18 增加退药申请单
	s myrtn=..InsertDrugReturnRequset(PRTRowID, OEORDStr, UserDR, RefAuditLocDR, RefundReason, OEAuthInfo)
	q:(myrtn'=0) myrtn

	;modify 2014-04-18 增加部分退费申请
	s myrtn=..InsertParkReturnRequset(PRTRowID, OEORDStr, UserDR, RefAuditLocDR, RefundReason, OEAuthInfo)

	q myrtn
}

ClassMethod InsertAuthInfo(PRTRowID As %String, UserDR As %String, OEAuthInfo As %String, RefundReason As %String = "") As %String
{
	s RefundReason=$g(RefundReason)
	n (PRTRowID, UserDR, OEAuthInfo,RefundReason)
	s myrtn=0
	k ^||TMPOEITMREFROWID("REFROWDI")
	s mylen=$l(OEAuthInfo,$c(2))
	
	f i=1:1:mylen  q:(myrtn'=0)  d
	.s myOEInfo=$p(OEAuthInfo,$c(2),i)
	.q:(myOEInfo="")
	.s myAuthLen=$l(myOEInfo,"^")
	.k PLIST
	.s PLIST(0)=PRTRowID
	.f j=3:1:myAuthLen d
	..s PLIST(j-1)=$p(myOEInfo,"^",j)
	.k PLIST(1)
	.k PLIST(2)
	.s PLIST(5)=+$h
	.s PLIST(6)=$p($h,",",2)
	.s PLIST(9)=""
	.s PLIST(10)=""
	.s PLIST(13)=RefundReason
	.s phdi=$p(myOEInfo,"^",12)
	.s phflag=$p(myOEInfo,"^",13)
	.s oeori=$p(myOEInfo,"^",4)
	.s refundRepPart=$p(myOEInfo,"^",14)
	.s PLIST(21)=refundRepPart
	.s myrtn=##class(web.UDHCINVOEItemAuthorize).INSERT()
	.q:(+myrtn)
	.;调用新产品组接口
	.s isAppRepFlag=##class(web.UDHCJFPRICE).IsAppRepOrder(oeori)
	.i (isAppRepFlag="Y")&&(refundRepPart'="") d
	..s err=##class(web.DHCAPPInterface).SetExaReqFlag(oeori, refundRepPart, "Y")
	..s myrtn=err
	.q:(+myrtn)
	.s OEItmRowID=PLIST(3)
	.i (phdi'="")&(phflag'="")  d
	..s tmphpdi=phflag_"||"_phdi
	..s ^||TMPOEITMREFROWID("REFROWDI",OEItmRowID,tmphpdi)=$g(%ROWID)
	
	q myrtn
}

/// 更新医嘱表的审批
ClassMethod UpdateOEItmFAuth(OEORDStr As %String, UserDR As %String, RefAuditLocDR As %String, RefundReason As %String, AuditStatus As %String = "") As %String
{
	s AuditStatus=$g(AuditStatus)
	n (OEORDStr, UserDR, RefAuditLocDR, RefundReason, AuditStatus)
	
	i (AuditStatus="")  s AuditStatus="A"
	s myrtn=0
	s mylen=$l(OEORDStr,"^")
	
	f i=1:1:mylen  q:(+myrtn'=0)  d
	.s myOEORI=$p(OEORDStr,"^",i)
	.q:(myOEORI="")
	.s myExpOERowID=$o(^DHCORDItem(0,myOEORI,0))
	.i (myExpOERowID'="") d
	..k PLIST
	..s myrtn=##class(web.UDHCOEOrdItem).SELECT(myExpOERowID)
	..q:(+myrtn'=0)
	..s PLIST(6)=AuditStatus
	..s PLIST(7)=UserDR
	..s PLIST(8)=+$h
	..s PLIST(9)=$p($h,",",2)
	..s PLIST(10)=RefundReason			;DHCORI_RefundReason
	..i (RefAuditLocDR'="") d
	...s PLIST(11)=RefAuditLocDR		;DHCORI_RefAuditLoc_DR
	..s myrtn=##class(web.UDHCOEOrdItem).UPDATE(myExpOERowID)
	..q:(+myrtn'=0)
	.e  d
	..;Insert Table
	..k PLIST
	..s PLIST(2)=myOEORI
	..s PLIST(6)="A"
	..s PLIST(7)=UserDR
	..s PLIST(8)=+$h
	..s PLIST(9)=$p($h,",",2)
	..s PLIST(10)=RefundReason			;DHCORI_RefundReason
	..i (RefAuditLocDR'="") d
	...s PLIST(11)=RefAuditLocDR		;DHCORI_RefAuditLoc_DR
	..s myrtn=##class(web.UDHCOEOrdItem).INSERT()
	..q:(+myrtn'=0)
	
	q myrtn
}

/// Creator:  陈曦
/// CreatDate: 2014-04-18
/// Desc: 判断医嘱是否允许部分退费
/// Debug: w ##class(web.DHCOPBillRefundRequestNew).GetOrdAllowPartRequest("51||17")
ClassMethod GetOrdAllowPartRequest(OrdRowid)
{
	n (OrdRowid)
	q:(OrdRowid="") "N"
	s OrderRowid=$p(OrdRowid,"||",1)
	s OrdSub=$p(OrdRowid,"||",2)
	q:(OrderRowid="") "N"
	q:(OrdSub="") "N"
	q:($d(^OEORD(OrderRowid,"I",OrdSub))=0) "N"
	s AllowFlag="N"
	s ArcimRowid=$p(^OEORD(OrderRowid,"I",OrdSub,1),"^",2)
	q:(ArcimRowid="") "N"
	q:($d(^ARCIM(+ArcimRowid,$p(ArcimRowid,"||",2)))=0) "N"
	s ArcCatDr=$p(^ARCIM(+ArcimRowid,$p(ArcimRowid,"||",2),1),"^",10)
	q:(ArcCatDr="") "N"
	s OrdCateType=$p($g(^ARC("IC",ArcCatDr)),"^",7)                   //医嘱类型
	q:(OrdCateType="R") "N"	           //2018-03-29 ZhYW 药品不在此部分退费
	//s inci=$o(^INCI(0,"ARCIM_DR",+ArcimRowid,""))
	//是否走库存管理，ARCIM_AllowOrderWOStockCheck="Y"不走库存管理, 非"Y"走库存管理
	//s AllowOrderWOStockCheck=$p(^ARCIM(+ArcimRowid,$p(ArcimRowid,"||",2),8),"^",11)  //ARCIM_AllowOrderWOStockCheck
	//q:((inci'="")&&(AllowOrderWOStockCheck'="Y")) "N"	//走库存的医嘱不在此部分退费
	
	s CatNum=0,ArcimNum=0,ArcimNNum=0,CatNNum=0
	s CurDate=+$h
	s ORACRowid=""
	s ORACRowid=$o(^DHCJFOrderRefundAppConfig(0,"Arcim",ArcimRowid,ORACRowid),-1) 
	i (ORACRowid'="")  d
	.s ArcimNum=ArcimNum+1
	.s StDate=$p(^DHCJFOrderRefundAppConfig(ORACRowid),"^",3)
	.s EndDate=$p(^DHCJFOrderRefundAppConfig(ORACRowid),"^",4)
	.s ORACFlag=$p(^DHCJFOrderRefundAppConfig(ORACRowid),"^",14)
	.i (ORACFlag'="Y")  d
	..s ArcimNNum=ArcimNNum+1
	.e  d
	..i (StDate'="")&((CurDate<StDate)!(CurDate>EndDate))  d
	...s ArcimNNum=ArcimNNum+1
	
	//+2017-06-21 ZhYW 物资医嘱可部分退
	s matDispGrant=..CheckIsMatDispGrant(OrdRowid, "")
	i (matDispGrant="Y") d
	.s AllowFlag="Y"
	//
	i ((ArcimNum'=0)&(ArcimNNum=0))  d
	.s AllowFlag="Y"
	q:(AllowFlag="Y") AllowFlag
	q:((ArcimNum'=0)&(ArcimNNum'=0)) "N"
	s ORACRowid="0"
	f  s ORACRowid=$o(^DHCJFOrderRefundAppConfig(0,"Arcic",ArcCatDr,ORACRowid))  q:(ORACRowid="")  d 
	.s OracArcimRowid=$p(^DHCJFOrderRefundAppConfig(ORACRowid),"^",2)
	.q:(OracArcimRowid'="")
	.s CatNum=CatNum+1
	.s StDate=$p(^DHCJFOrderRefundAppConfig(ORACRowid),"^",3)
	.s EndDate=$p(^DHCJFOrderRefundAppConfig(ORACRowid),"^",4)
	.s ORACFlag=$p(^DHCJFOrderRefundAppConfig(ORACRowid),"^",14)
	.i (ORACFlag'="Y")  d
	..s CatNNum=CatNNum+1
	.e  d
	..i (StDate'="")&((CurDate<StDate)!(CurDate>EndDate))  d
	...s CatNNum=CatNNum+1
	
	i ((CatNum'=0)&(CatNNum=0))  d
	.s AllowFlag="Y"
	
	q AllowFlag
}

/// Creator:        陈曦
/// CreatDate:      2014-04-18
/// Desc:           退费时药品可申请退药单
/// Debug: ##class(web.DHCSTINTERFACE).SaveOutPhRequest(reclocdr,prt,prescno,ordstr,reasondr,opuserid)
ClassMethod InsertDrugReturnRequset(PRTRowID, OEORDStr, UserDR, RefAuditLocDR, RefundReason, OEAuthInfo)
{
	n (PRTRowID,OEORDStr, UserDR, RefAuditLocDR, RefundReason, OEAuthInfo)
	s myrtn=0
	s mylen=$l(OEAuthInfo,$c(2))
	
	k ^TMP("DHCOPBill","DrugRefundRequest",$j,UserDR,PRTRowID)
	f i=1:1:mylen  d
	.s myOEInfo=$p(OEAuthInfo,$c(2),i)
	.q:(myOEInfo="")
	.s OEORIRowid=$p(myOEInfo,"^",4)
	.q:(OEORIRowid="")
	.s OEORIPrescNo=$p($g(^OEORD(+OEORIRowid,"I",+$p(OEORIRowid,"||",2),1)),"^",14)
	.q:(OEORIPrescNo="")
	.s RequestQty=$p(myOEInfo,"^",10)
	.s RequestReaDr=$p(myOEInfo,"^",11)
	.s phdi=$p(myOEInfo,"^",12)
	.s phflag=$p(myOEInfo,"^",13)
	.q:(RequestReaDr="")
	.s RecLocDR=$p($g(^OEORD(+OEORIRowid,"I",+$p(OEORIRowid,"||",2),3)),"^",6)
	.q:(RecLocDR="")
	.q:(phflag="")
	.i (phdi'="") d
	..s ^TMP("DHCOPBill","DrugRefundRequest",$j,UserDR,PRTRowID,RecLocDR,OEORIPrescNo,OEORIRowid,phflag_"||"_phdi)=RequestQty_"^"_RequestReaDr_"^"_phflag_"^"_phdi
	.e  d
	..;为空的即为协定方，不能部分退，故从发药表直接取退药数据
	..s phd=""
	..f  s phd=$o(^DHCPHDISPi("PRESCNO",OEORIPrescNo,phd)) q:(phd="")  d
	...s phl=$p(^DHCPHDISP(phd,1),"^",1)
	...s fyflag=$p(^DHCPHDISP(phd),"^",4)
	...q:(fyflag'=1)
	...s phdch=""
	...f  s phdch=$o(^DHCPHDI(phd,"PHDI",phdch))  q:(phdch="")  d
	....s orditm=$p(^DHCPHDI(phd,"PHDI",phdch),"^",5)
	....q:(orditm'=OEORIRowid)
	....s phdsub=0
	....f  s phdsub=$o(^DHCPHDI(phd,"PHDI",phdch,"INCLB",phdsub)) q:(phdsub="")  d
	.....s phaqty=+$p(^DHCPHDI(phd,"PHDI",phdch,"INCLB",phdsub),"^",1)
	.....s retqty=+$p(^DHCPHDI(phd,"PHDI",phdch,"INCLB",phdsub),"^",2)
	.....s RequestQty=phaqty-retqty
	.....s phdi=phd_"||"_phdch_"||"_phdsub
	.....s ^TMP("DHCOPBill","DrugRefundRequest",$j,UserDR,PRTRowID,RecLocDR,OEORIPrescNo,OEORIRowid,phflag_"||"_phdi)=RequestQty_"^"_RequestReaDr_"^"_phflag_"^"_phdi
	
	s RecLocDR="",DrugReqRetCode=0
	f  s RecLocDR=$o(^TMP("DHCOPBill","DrugRefundRequest",$j,UserDR,PRTRowID,RecLocDR))  q:(RecLocDR="")!(DrugReqRetCode'=0)  d
	.s OEORIPrescNo=""
	.f  s OEORIPrescNo=$o(^TMP("DHCOPBill","DrugRefundRequest",$j,UserDR,PRTRowID,RecLocDR,OEORIPrescNo))  q:(OEORIPrescNo="")!(DrugReqRetCode'=0)  d
	..s RequestReaDr="",OrdReqInfo=""
	..s OEORIRowid=""
	..f  s OEORIRowid=$o(^TMP("DHCOPBill","DrugRefundRequest",$j,UserDR,PRTRowID,RecLocDR,OEORIPrescNo,OEORIRowid))  q:(OEORIRowid="")!(DrugReqRetCode'=0)  d
	...s phflag=""
	...f  s phflag=$o(^TMP("DHCOPBill","DrugRefundRequest",$j,UserDR,PRTRowID,RecLocDR,OEORIPrescNo,OEORIRowid,phflag))  q:(phflag="")!(DrugReqRetCode'=0)  d
	....s RequestReaQty=$p(^TMP("DHCOPBill","DrugRefundRequest",$j,UserDR,PRTRowID,RecLocDR,OEORIPrescNo,OEORIRowid,phflag),"^",1)
	....s RequestReaDr1=$p(^TMP("DHCOPBill","DrugRefundRequest",$j,UserDR,PRTRowID,RecLocDR,OEORIPrescNo,OEORIRowid,phflag),"^",2)
	....s chowflag=$p(^TMP("DHCOPBill","DrugRefundRequest",$j,UserDR,PRTRowID,RecLocDR,OEORIPrescNo,OEORIRowid,phflag),"^",3)
	....s tmphdi=$p(^TMP("DHCOPBill","DrugRefundRequest",$j,UserDR,PRTRowID,RecLocDR,OEORIPrescNo,OEORIRowid,phflag),"^",4)
	....q:(+RequestReaQty=0)
	....i ((RequestReaDr="")&&(RequestReaDr1'=""))  d
	.....s RequestReaDr=RequestReaDr1
	....i (OrdReqInfo="")  d
	.....s OrdReqInfo=OEORIRowid_"^"_RequestReaQty_"^"_chowflag_"^"_tmphdi_"^"_^||TMPOEITMREFROWID("REFROWDI",OEORIRowid,phflag)
	....e  d  
	.....s OrdReqInfo=OrdReqInfo_$c(2)_OEORIRowid_"^"_RequestReaQty_"^"_chowflag_"^"_tmphdi_"^"_^||TMPOEITMREFROWID("REFROWDI",OEORIRowid,phflag)
	..q:(OrdReqInfo="")
	..q:(RequestReaDr="")
	..s DrugReqRetCode1=##class(web.DHCSTINTERFACE).SaveOutPhRequestnew(RecLocDR, PRTRowID, OEORIPrescNo, OrdReqInfo, RequestReaDr, UserDR)
	..i (DrugReqRetCode1>0)  d
	...s DrugReqRetCode=0
	..e  d
	...s DrugReqRetCode=1111 
	
	k ^TMP("DHCOPBill","DrugRefundRequest",$j,UserDR,PRTRowID)

	i (DrugReqRetCode'=0)  d
	.s myrtn=DrugReqRetCode	

	q myrtn
}

/// Creator:        陈曦
/// CreatDate:      2014-04-18
/// Desc:           退费时有配置非药品的医嘱可部分退费
/// Debug: w ##class(web.DHCSTINTERFACE).SaveOutPhRequest(reclocdr,prt,prescno,ordstr,reasondr,opuserid)
ClassMethod InsertParkReturnRequset(PRTRowID, OEORDStr, UserDR, RefAuditLocDR, RefundReason, OEAuthInfo)
{
	n (PRTRowID,OEORDStr, UserDR, RefAuditLocDR, RefundReason, OEAuthInfo)
		
	s myrtn=0
	s mylen=$l(OEAuthInfo,$c(2))
	k ^TMP("DHCOPBill","PartRefund",$j,UserDR,PRTRowID)
	f i=1:1:mylen  d
	.s myOEInfo=$p(OEAuthInfo,$c(2),i)
	.q:(myOEInfo="")
	.s OEORIRowid=$p(myOEInfo,"^",4)
	.q:(OEORIRowid="")
	.s Arcim=$p(^OEORD(+OEORIRowid,"I",$p(OEORIRowid,"||",2),1),"^",2)
	.q:(Arcim="")
	.s ARCCATRowid=$p(^ARCIM(+Arcim,$p(Arcim,"||",2),1),"^",10)
	.q:(ARCCATRowid="")
	.s ARCOrdType=$p(^ARC("IC",ARCCATRowid),"^",7)
	.q:(ARCOrdType="R")
	.s RequestQty=$p(myOEInfo,"^",10)
	.//2016-02-16 医嘱不允许部分退费不能插入 DHC_OERefundQTY 表
	.s Allowflag=..GetOrdAllowPartRequest(OEORIRowid)
	.q:(Allowflag'="Y")
	.s ^TMP("DHCOPBill","PartRefund",$j,UserDR,PRTRowID,OEORIRowid)=RequestQty
	
	s PartRefundCode=0,OrdReqInfo=""
	s OEORIRowid=""
	f  s OEORIRowid=$o(^TMP("DHCOPBill","PartRefund",$j,UserDR,PRTRowID,OEORIRowid))  q:(OEORIRowid="")  d
	.s RequestReaQty=$p(^TMP("DHCOPBill","PartRefund",$j,UserDR,PRTRowID,OEORIRowid),"^",1)
	.//q:(+RequestReaQty=0)
	.i (OrdReqInfo="")  d
	..s OrdReqInfo=OEORIRowid_"^"_RequestReaQty
	.e  d  
	..s OrdReqInfo=OrdReqInfo_"!"_OEORIRowid_"^"_RequestReaQty
	
	q:(OrdReqInfo="") 0
	
	//+2017-06-21 ZhYW 
	s ExpStr=PRTRowID
	s PartRefundCode=##class(web.DHCOPBillOERefundQty).InertApplyRefundQty(OrdReqInfo, UserDR, ExpStr)	
	
	i (+PartRefundCode=0)  d
	.s myrtn=0
	e  d
	.s myrtn=2222
	
	k ^TMP("DHCOPBill","PartRefund",$j,UserDR,PRTRowID)
	
	q myrtn
}

/// CreatDate:      2014-04-27
/// Desc:           广州开发区医院欠药药房程序
/// w ##class(web.DHCOPBillRefundRequestNew).PHRequest(227958,7)
ClassMethod PHRequest(CPrtInv As %Library.String, myLoc)
{
	q:(CPrtInv="")
	s MYYPorderstr=""
	s prt=CPrtInv
	s prt=+prt
	s papmi=$p(^DHCINVPRT(CPrtInv),"^",15)
	q:(papmi="")
	//2018-10-16 ZhYW 
	d ..GetPrtPresnoInfo(prt)
	
	i (prt'=0) d
	.s prescno=""
	.f  s prescno=$o(^||TMP($j,prt,prescno)) q:(prescno="")  d
	..s ordItmStr=$g(^||TMP($j,prt,prescno))
	..s phdrow=""
	..f  s phdrow=$o(^DHCPHDISPi("PRESCNO",prescno,phdrow)) q:(phdrow="")  d
	...s fyflag=$p(^DHCPHDISP(phdrow),"^",4)
	...q:(fyflag'="1")
	...s phdsub=""
	...f  s phdsub=$o(^DHCPHDI(phdrow,"PHDI",phdsub)) q:(phdsub="")  d
	....s ord="", itm="", phditm="", dispqty=0, retqty=0, price=0
	....s orditm=$p(^DHCPHDI(phdrow,"PHDI",phdsub),"^",5)
	....q:(("^"_ordItmStr_"^")'[("^"_orditm_"^"))
	....s OEORI=orditm
	....s ord=$p(orditm,"||",1)
	....s itm=$p(orditm,"||",2)
	....s RecLoc=$p(^OEORD(ord,"I",itm,3),"^",6)
	....s recdepdesc=$p(^CTLOC(RecLoc),"^",2)
	....i ($f(recdepdesc,"-")'=0)  d
	.....s recdepdesc=$p(recdepdesc,"-",2)
	....s OrderDept=$p($g(^OEORD(ord,"I",itm,7)),"^",2) ;开单科室
	....q:((myLoc'="")&&(OrderDept'=myLoc))             ;20150508 本科室只能审核本科室开的医嘱 ywb	
	....s ItemStatDR=$p($g(^OEORD(+OEORI,"I",+$p(OEORI,"||",2),1)),"^",13)
	....s TOrdStopStatus=$s((ItemStatDR'=""):$p(^OEC("OSTAT",ItemStatDR),"^",1),1:"")
	....s OEORDExecQty=..ReadOEORDExecQty(prt, OEORI, "")
	....i (MYYPorderstr'[("^"_OEORI_"^")) d
	.....i (MYYPorderstr="") s MYYPorderstr="^"_OEORI_"^"
	.....e  s MYYPorderstr=MYYPorderstr_OEORI_"^"
	....s phdicsub="0", dispqty=0              //医嘱结构改造
	....f  s phdicsub=$o(^DHCPHDI(phdrow,"PHDI",phdsub,"INCLB",phdicsub)) q:(phdicsub="")!(phdicsub="0")  d
	.....s incqty=0, basuom="", pointer="", intrno="", user=""
	.....s inclb=$p(^DHCPHDI(phdrow,"PHDI",phdsub,"INCLB",phdicsub),"^",3)
	.....s dispqty=+$p(^DHCPHDI(phdrow,"PHDI",phdsub,"INCLB",phdicsub),"^",1)
	.....s dspitm=$p(^DHCPHDI(phdrow,"PHDI",phdsub,"INCLB",phdicsub),"^",9)
	.....s Tphdi=phdrow_"||"_phdsub_"||"_phdicsub      ;wangjian 2018-06-08
	.....s (ArcimDesc, PatSum, OrderBillQty, returnqty, Executflag, myRefSum, myAuditFlag, myAuditCheckDis, myAuditSelFlag, myPrescNo,myCMFlag,AuditUserName,AuditDateTime,ExecutFlagDesc,mySeqNo,UnAuditOrdItem,TExecutDesc,TOrdUserDepDesc,InvDr,TItemStat,TLinkOrder,TOrdDate,TDepDesc,TDrugRetRequ,TDrugRetReason,TDrugRetALready,TDrugRetReasonDr,ARCOrdType,TOEORDExecQty,TCanReturnNum)=""
	.....i (dspitm="")  d
	......s retqty=0
	.....e  d
	......s phr="", retqty=0
	......f  s phr=$o(^DHCPHRTIi("DSPB",dspitm,phr)) q:(phr="")  d
	.......s phri=""
	.......f  s phri=$o(^DHCPHRTIi("DSPB",dspitm,phr,phri)) q:(phri="")  d
	........s rqty=$p(^DHCPHRTI(phr,"RTI",phri),"^",3)
	........s retqty=retqty+rqty
	.....s TDrugCollect=dispqty
	.....s phdqty=dispqty-retqty
	.....s phditm=phdrow_"||"_phdsub
	.....s reqqty=0
	.....s InvOasub=""
	.....;取申请单中的记录
	.....i (dspitm'="")  d
	......s phreq=""
	......f  s phreq=$o(^DHCPHREQi("DSPB",dspitm,phreq)) q:(phreq="")  d
	.......s zfflag=$p(^DHCPHREQ(phreq),"^",1)
	.......q:(zfflag="1")
	.......s retflag=$p(^DHCPHREQ(phreq),"^",11)
	.......q:((retflag'="0")&&(retflag'=""))
	.......s newprt=+$p(^DHCPHREQ(phreq),"^",5)
 	.......q:(+newprt=0)
	.......s prtflag=$p($g(^DHCINVPRT(newprt)),"^",8)
	.......q:((prtflag="A")||(prtflag="S"))
	.......s phreqsub=""
	.......f  s phreqsub=$o(^DHCPHREQi("DSPB",dspitm,phreq,phreqsub)) q:phreqsub=""  d
	........s phreqphdi=$p(^DHCPHREQ(phreq,"I",phreqsub),"^",1)
	........q:($p(^DHCPHREQ(phreq,"I",phreqsub),"^",6)=1)       //modify 2016-01-30 过滤欠药的记录
	........q:(phreqphdi'=phditm)
	........s lreqqty=$p(^DHCPHREQ(phreq,"I",phreqsub),"^",4)
	........s reqqty=reqqty+lreqqty
	........s InvOasub=$p(^DHCPHREQ(phreq,"I",phreqsub),"^",7)
	.....s inci=+inclb
	.....q:(+inci=0)
	.....s baseprice=0, phuomid="", basuom="", phuomdesc=""
	.....i (prt=0) d
	......s dspdate=##class(web.DHCOutPhDisp).getDspDate(OEORI)
	......i (dspdate="") s dspdate=+$h
	......s HospString=##class(web.DHCSTCOMMONSRV).GetLocHosp(RecLoc)
 	......s hospdr=$p(HospString,"^",1)
	......s baseprice=##class(web.DHCSTCOMMONSRV).GetPriceElse(+inci, +dspdate, "", hospdr)
	.....e  d
	......s baseprice=##class(web.DHCOutPhDisp).GetBasPrice(prt, OEORI, dspitm)
	......s baseprice=$fn(baseprice,"",4)
	.....s ArcimDr=$p(^OEORD(ord,"I",itm,1),"^",2)
	.....s phdesc=$p(^ARCIM(+ArcimDr,$p(ArcimDr,"||",2),1),"^",2)
	.....s phuomid=$p(^ARCIM(+ArcimDr,$p(ArcimDr,"||",2),8),"^",14)
	.....i (phuomid'="") s phuomdesc=$p($g(^CT("UOM",phuomid)),"^",2)
	.....s basuom=+$p(^INCI(inci,1),"^",10)
	.....s confac=##class(web.DHCBillCommon).GetUomConvFactor(ArcimDr, OEORI)
	.....s TDrugCollect=TDrugCollect/confac
	.....//s reqqty=reqqty*confac    //modify 2015-01-07 门诊退药申请表里是最小单位
	.....s phdqty1=phdqty/confac
	.....s phdqty=phdqty-reqqty
	.....//q:phdqty=0
	.....s scrqty=0, scrprice=0
	.....s scrqty=phdqty/confac
	.....s reqqty1=reqqty/confac
	.....s scrprice=baseprice*confac
	.....s (ArcimDesc,PatSum,OrderBillQty,returnqty,Executflag,myRefSum,myAuditFlag,myAuditCheckDis,myAuditSelFlag,myPrescNo,myCMFlag,AuditUserName,AuditDateTime,ExecutFlagDesc,mySeqNo,UnAuditOrdItem,TExecutDesc,TOrdUserDepDesc,InvDr,TItemStat,TLinkOrder,TOrdDate,TDepDesc,TDrugRetRequ,TDrugRetReason,TDrugRetALready,TDrugRetReasonDr,ARCOrdType,TOEORDExecQty,TCanReturnNum)=""
	.....s selflag=0,myAuditFlag=0
	.....s Executflag="1"
	.....s ExecutFlagDesc="已发药"
	.....s TOweFlag="1"
	.....s myPrescNo=prescno
	.....s ArcimDesc=""
	.....s TCanReturnNum=scrqty
	.....s OrderBillQty=0
	.....s DHCBCIRowid="0"
	.....f  s DHCBCIRowid=$o(^DHCBCI(0,"INV",CPrtInv,DHCBCIRowid))  q:(DHCBCIRowid="")  d
	......s PBRowid=$p(^DHCBCI(DHCBCIRowid),"^",2)
	......q:(+PBRowid=0)
	......s PBOSubDr="0"
	......f  s PBOSubDr=$o(^DHCPBi(0,"OEORI",orditm,PBRowid,PBOSubDr))  q:(PBOSubDr="")  d
	.......s PBOQty=$p(^DHCPB(PBRowid,"O",PBOSubDr),"^",5)
	.......s PBORetQty=$p(^DHCPB(PBRowid,"O",PBOSubDr),"^",6)
	.......s OrderBillQty=OrderBillQty+PBOQty+PBORetQty
	.......s PBOPatAmt=$p(^DHCPB(PBRowid,"O",PBOSubDr),"^",8)
	.......s PatSum=PatSum+PBOPatAmt
	.....s OrderBillQty=OrderBillQty/confac
	.....//s PatSum=OrderBillQty*scrprice
	.....s ArcimDesc=phdesc
	.....s ARCOrdType="R"
	.....s TDrugRetALready=reqqty1
	.....s PatSum=$j(PatSum,3,2),myRefSum=$j(myRefSum,3,2)
	.....i $g(TCanReturnNum)=0  d
	......s invprtAuditFlag=$p(^DHCINVPRT(CPrtInv),"^",22) 
	.....//2015-02-03 chenxi 增加退费审核标志、退费审核是否可勾选取值	  
	.....s myAuditFlag="",myAuditCheckDis="",myAuditSelFlag=""
	.....//2016-02-03 chenxi 门诊退费审核与门诊退费区分，退费审核时停医嘱自动勾选上，退费时需审核过才自动勾选
	.....s RefFlag="Request"      //RefFlag  Request---退费审核，Refund--退费
	.....s ExpStr=RefFlag
	.....s myrtn=##class(web.UDHCPRTOEAuthIF).ReadOEORDAuthFlag(CPrtInv, OEORI, ExpStr)
	.....s myAuditFlag=$p(myrtn,"^",1)         ;判断是否审批
	.....s myAuditCheckDis=$p(myrtn,"^",2)		;判断选择项目是否Disable
	.....s myAuditSelFlag=$p(myrtn,"^",3)		;判断选择项目是否被选中  
	.....//add wyx 2015-01-14
	.....s returnqty=##class(web.DHCOutPhReturn).GetRetOrdQty(OEORI, CPrtInv)
	.....s returnqty=returnqty/confac
	.....s AuditUserName="", TDrugRetReasonDr="", TDrugRetReason="", AuditDateTime=""
	.....s RefReaNum=0
	.....i (InvOasub'="")  d
	......s OASub=$p(InvOasub,"||",2)
	......s OAInvdr=$p(InvOasub,"||",1)
	......i (OASub'="")&(OAInvdr=CPrtInv)  d
	.......s RefReaNum=RefReaNum+1
	.......s TDrugRetReasonDr=$p(^DHCINVPRT(CPrtInv,"OA",OASub),"^",11) 
	.......i (TDrugRetReasonDr'="")  d
	........s TDrugRetReason=$p($g(^DHCINVOPREFR(TDrugRetReasonDr)),"^",2)
	.......s ExecutFlagDesc="已审核"
	.......s AuditUserDr=$p(^DHCINVPRT(CPrtInv,"OA",OASub),"^",2)
	.......s AuditUserName=""
	.......i (AuditUserDr'="") s AuditUserName=$p(^SSU("SSUSR",AuditUserDr),"^",2)
	.......s AuditDate=$p(^DHCINVPRT(CPrtInv,"OA",OASub),"^",3)
	.......s AuditTime=$p(^DHCINVPRT(CPrtInv,"OA",OASub),"^",4)
	.......s AuditDate=##class(websys.Conversions).DateLogicalToHtml(AuditDate)
	.......s AuditTime=##class(websys.Conversions).TimeLogicalToHtml(AuditTime, 1)
	.......s AuditDateTime=AuditDate_" "_AuditTime
	.....e  d
	......i ($d(^DHCINVPRT(CPrtInv,"OA")))&(returnqty'=0) d
	.......s OASub=""
	.......f  s OASub=$o(^DHCINVPRT(CPrtInv,"OA",OASub)) q:(OASub="")  d
	........s OAOEORI=$p(^DHCINVPRT(CPrtInv,"OA",OASub),"^",1)
	........q:(OAOEORI'=OEORI)
	........s TDrugRetReasonDr=$p(^DHCINVPRT(CPrtInv,"OA",OASub),"^",11) 
	........i (TDrugRetReasonDr'="")  d
	.........s TDrugRetReason=$p($g(^DHCINVOPREFR(TDrugRetReasonDr)),"^",2)
	........s ExecutFlagDesc="已审核"
	........s AuditUserDr=$p(^DHCINVPRT(CPrtInv,"OA",OASub),"^",2)
	........s AuditUserName=""
	........i (AuditUserDr'="")  s AuditUserName=$p(^SSU("SSUSR",AuditUserDr),"^",2)
	........s AuditDate=$p(^DHCINVPRT(CPrtInv,"OA",OASub),"^",3)
	........s AuditTime=$p(^DHCINVPRT(CPrtInv,"OA",OASub),"^",4) 
	........s AuditDate=##class(websys.Conversions).DateLogicalToHtml(AuditDate)
	........s AuditTime=##class(websys.Conversions).TimeLogicalToHtml(AuditTime, 1)
	........s AuditDateTime=AuditDate_" "_AuditTime
	.....;增加审核人审核时间
	.....s AuditUserNametmp=""	;$p(^SSU("SSUSR",$p(^DHCINVPRT(InvDr),"^",25)),"^",2)
	.....s AuditDateTimetmp=""	;$zd($P(^DHCINVPRT(InvDr),"^",23),3)_" "_$zt($P(^DHCINVPRT(InvDr),"^",24),2) //end 2009-9-11
	.....//2016-01-29 chenxi 审核相关信息从发票子表获取
	.....set AuditInfo=..GetCheckUserDateByOrdId(OEORI, "")
	.....quit:(+PatSum=0)
	.....set Tinciflag="N"
	.....set ArcItmCateDR=$p(^ARCIM(+ArcimDr,$p(ArcimDr,"||",2),1),"^",10)   ;医嘱子类
	.....if (($c(2)_UnAuditOrderCateStr_$c(2))[($c(2)_ArcItmCateDR_$c(2))) set UnAuditOrdItem="Y" ;医嘱属于免审核的子类则q出 add by wanghc 2009-10-12
	.....else  set UnAuditOrdItem="N"
	.....//+2017-08-28 ZhYW
	.....set matDispGrant="N"
	.....set Data=$lb(selflag,ArcimDesc,PatSum,OrderBillQty,recdepdesc,returnqty,OEORI,Executflag,myRefSum,myAuditFlag,myAuditCheckDis,myAuditSelFlag,OEORDExecQty,myPrescNo,myCMFlag,AuditUserName,AuditDateTime,ExecutFlagDesc,mySeqNo,UnAuditOrdItem,TExecutDesc,TOrdUserDepDesc,$g(CPrtInv),$g(TItemStat),$g(TLinkOrder),$g(TOrdDate),$g(TDepDesc),$g(TDrugRetRequ),$g(TDrugRetReason),$g(TDrugRetALready),$g(TDrugRetReasonDr),ind,$g(ARCOrdType),$g(TOEORDExecQty),$g(TCanReturnNum),Tphdi,TOweFlag,TDrugCollect,Tinciflag,TOrdStopStatus,matDispGrant)
	.....set ^CacheTemp(repid,ind)=Data
	.....set ind=ind+1
	  
	s presc=""
	f  s presc=$o(^DHCPHOWi(0,"PAPMI",papmi,presc)) q:(presc="")  d
	.s phow=""
	.f  s phow=$o(^DHCPHOWi(0,"PAPMI",papmi,presc,phow))  q:(phow="")  d
	..s phowprt=$p(^DHCPHOW(phow),"^",7)
	..i (phowprt'="") s phowprt=##class(web.DHCOutPhReturn).GetNewPrtFrOld(phowprt)
	..q:(CPrtInv'="")&(CPrtInv'=phowprt)
	..s status=$p(^DHCPHOW(phow),"^",8)
	..q:(status=2)     //如果欠药单已发药状态,库存已减,不考虑
	..s phowretdate=$p(^DHCPHOW(phow),"^",10)
	..q:(phowretdate'="")
	..s prescno=$p(^DHCPHOW(phow),"^",6)
	..s RecLoc=$p(^DHCPHOW(phow),"^",2)
	..s recdepdesc=$p(^CTLOC(RecLoc),"^",2)
	..i ($f(recdepdesc,"-")'=0)  d
	...s recdepdesc=$p(recdepdesc,"-",2)
	..s phowsub=""
	..f  s phowsub=$o(^DHCPHOWEI(phow,"I",phowsub)) q:(phowsub="")  d
	...//q:$p(^DHCPHOWEI(phow,"I",phowsub),"^",4)="1"
	...s orditm=$p(^DHCPHOWEI(phow,"I",phowsub),"^",1)
	...s Tphdi=phow_"||"_phowsub
	...s OEORI=orditm
	...s TOrdStopStatus=""
	...s ItemStatDR=$p($g(^OEORD(+OEORI,"I",+$p(OEORI,"||",2),1)),"^",13) 
	...i (+ItemStatDR'=0)  d
	....s TOrdStopStatus=$p(^OEC("OSTAT",ItemStatDR),"^",1)
	...s OEORDExecQty = ..ReadOEORDExecQty(prt,OEORI, "")
	...i (MYYPorderstr'[("^"_OEORI_"^")) d
	....i MYYPorderstr="" s MYYPorderstr="^"_OEORI_"^"
	....e  s MYYPorderstr=MYYPorderstr_OEORI_"^"
	...s ord=+orditm
	...s itm=$p(orditm,"||",2)
	...s OrderDept=$p($g(^OEORD(ord,"I",itm,7)),"^",2)  //开单科室	
	...q:((myLoc'="")&&(OrderDept'=myLoc))              //20150508 本科室只能审核本科室开的医嘱 ywb	
	...s qty=$p(^DHCPHOWEI(phow,"I",phowsub),"^",2)
	...s ArcimDr=$p($g(^OEORD(ord,"I",itm,1)),"^",2)
	...q:(ArcimDr="")
	...s inci=$o(^INCI(0,"ARCIM_DR",ArcimDr,""))
	...q:(inci="")
	...s phdesc=$p(^ARCIM(+ArcimDr,$p(ArcimDr,"||",2),1),"^",2)
	...s baseprice=0, phuomid="", basuom="", phuomdesc=""
	...i (+CPrtInv=0) d
	....s dspdate=##class(web.DHCOutPhDisp).getDspDate(orditm)
	....i (dspdate="") s dspdate=+$h
	....s HospString=##class(web.DHCSTCOMMONSRV).GetLocHosp(RecLoc)
 	....s hospdr=$p(HospString,"^",1)
	....s baseprice=##class(web.DHCSTCOMMONSRV).GetPriceElse(+inci, +dspdate, "", hospdr)
	...e  d
	....s baseprice=##class(web.DHCOutPhDisp).GetBasPrice(CPrtInv, orditm, dspitm)
	....s baseprice=$fn(baseprice,"",4)
	...s phuomid=$p(^ARCIM(+ArcimDr,$p(ArcimDr,"||",2),8),"^",14)
	...s phuomdesc=$p($g(^CT("UOM",phuomid)),"^",2)
	...s basuom=+$p(^INCI(inci,1),"^",10)
	...s confac=##class(web.DHCBillCommon).GetUomConvFactor(ArcimDr, OEORI)
	...s phdqty=qty
	...//q:phdqty=0
	...s scrqty=0, scrprice=0
	...s scrqty=phdqty/confac
	...s scrprice=baseprice*confac
	...s scrqty=phdqty/confac
	...s scrprice=baseprice*confac
	...s (ArcimDesc,PatSum, OrderBillQty, returnqty, Executflag, myRefSum, myAuditFlag, myAuditCheckDis, myAuditSelFlag,myPrescNo,myCMFlag,AuditUserName,AuditDateTime,ExecutFlagDesc,mySeqNo,UnAuditOrdItem,TExecutDesc,TOrdUserDepDesc,InvDr,TItemStat,TLinkOrder,TOrdDate,TDepDesc,TDrugRetRequ,TDrugRetReason,TDrugRetALready,TDrugRetReasonDr,ARCOrdType,TOEORDExecQty,TCanReturnNum)=""
	...s selflag=0, myAuditFlag=0
	...s Executflag="1"
	...s ExecutFlagDesc="欠药"
	...s TOweFlag="0"
	...s myPrescNo=prescno
	...s ArcimDesc=""
	...s ARCOrdType="R"
	...s TCanReturnNum=scrqty
	...//s OrderBillQty=scrqty
	...s OrderBillQty=0
	...s DHCBCIRowid="0"
	...f  s DHCBCIRowid=$o(^DHCBCI(0,"INV",CPrtInv,DHCBCIRowid))  q:(DHCBCIRowid="")  d
	....s PBRowid=$p(^DHCBCI(DHCBCIRowid),"^",2)
 	....q:(PBRowid="") 
	....s PBOSubDr="0"
	....f  s PBOSubDr=$o(^DHCPBi(0,"OEORI",orditm,PBRowid,PBOSubDr))  q:(PBOSubDr="")  d
	.....s PBOQty=$p(^DHCPB(PBRowid,"O",PBOSubDr),"^",5)
	.....s PBORetQty=$p(^DHCPB(PBRowid,"O",PBOSubDr),"^",6)
	.....s OrderBillQty=OrderBillQty+PBOQty+PBORetQty  
	...s OrderBillQty=OrderBillQty/confac
	...s PatSum=OrderBillQty*scrprice
	...s ArcimDesc=phdesc
	...s reqqty=0
	...s InvOasub=""
	...s phreq=""
	...f  s phreq=$o(^DHCPHREQi(Tphdi,"PHDI",phreq)) q:phreq=""  d
	....s phreqsub=""
	....f  s phreqsub=$o(^DHCPHREQi(Tphdi,"PHDI",phreq,phreqsub)) q:phreqsub=""  d
	.....s phreqphdi=$p(^DHCPHREQ(phreq,"I",phreqsub),"^",1)
	.....q:$p(^DHCPHREQ(phreq,"I",phreqsub),"^",6)'=1    //过滤欠药的记录
	.....s lreqqty=$p(^DHCPHREQ(phreq,"I",phreqsub),"^",4)
	.....s reqqty=reqqty+lreqqty
	.....s InvOasub=$p(^DHCPHREQ(phreq,"I",phreqsub),"^",7)
	...s reqqty=reqqty/confac
	...s TDrugRetALready=reqqty
	...s PatSum=$j(PatSum,3,2),myRefSum=$j(myRefSum,3,2)
	...s invprtAuditFlag=$p(^DHCINVPRT(CPrtInv),"^",22) 
	...i ((invprtAuditFlag="Y")&&(reqqty'=0)) d
	....//s myAuditCheckDis="Y"
	....//s myAuditFlag="Y"
	....s AuditUserName=$p(^SSU("SSUSR",$p(^DHCINVPRT(CPrtInv),"^",25)),"^",2)
	....s tmp=$zd($P(^DHCINVPRT(CPrtInv),"^",23),3)
	....s tmp2=$zt($P(^DHCINVPRT(CPrtInv),"^",24),2)
	....s tmpDate=##class(websys.Conversions).DateLogicalToHtml(tmp)
	....s tmpTime=##class(websys.Conversions).TimeLogicalToHtml(tmp2,1)
	....s AuditDateTime=tmpDate_" "_tmpTime    //end 2009-9-11
	....s ExecutFlagDesc="已审核" 	  
	....s TCanReturnNum=0
	...//add wyx 2015-01-14
	...s returnqty=0
	...//2016-02-03 chenxi 门诊退费审核与门诊退费区分，退费审核时停医嘱自动勾选上，退费时需审核过才自动勾选
	...s RefFlag="Request"      //RefFlag  Request---退费审核，Refund--退费
	...s ExpStr=RefFlag
	...s myrtn=##class(web.UDHCPRTOEAuthIF).ReadOEORDAuthFlag(CPrtInv, OEORI, ExpStr)
	...s myAuditFlag=$p(myrtn,"^",1)         ;判断是否审批
	...s myAuditCheckDis=$p(myrtn,"^",2)		;判断选择项目是否Disable
	...s myAuditSelFlag=$p(myrtn,"^",3)		;判断选择项目是否被选中	  
	...s AuditUserName="",TDrugRetReasonDr="",TDrugRetReason="",AuditDateTime=""
	...s RefReaNum=0
	...i (InvOasub'="")  d
	....s OASub=$p(InvOasub,"||",2)
	....s OAInvdr=$p(InvOasub,"||",1)
	....i ((OASub'="")&&(OAInvdr=CPrtInv))  d
	.....s RefReaNum=RefReaNum+1
	.....s TDrugRetReasonDr=$p(^DHCINVPRT(CPrtInv,"OA",OASub),"^",11) 
	.....i (TDrugRetReasonDr'="")  s TDrugRetReason=$p($g(^DHCINVOPREFR(TDrugRetReasonDr)),"^",2)
	.....s ExecutFlagDesc="已审核"
	.....s AuditUserDr=$p(^DHCINVPRT(CPrtInv,"OA",OASub),"^",2)
	.....s AuditUserName=""
	.....i (AuditUserDr'="") s AuditUserName=$p(^SSU("SSUSR",AuditUserDr),"^",2)
	.....s AuditDate=$p(^DHCINVPRT(CPrtInv,"OA",OASub),"^",3)
	.....s AuditDate=##class(websys.Conversions).DateLogicalToHtml(AuditDate)
	.....s AuditTime=$p(^DHCINVPRT(CPrtInv,"OA",OASub),"^",4)
	.....s AuditTime=##class(websys.Conversions).TimeLogicalToHtml(AuditTime, 1)
	.....s AuditDateTime=AuditDate_" "_AuditTime
	...;增加审核人审核时间
	...s AuditUserNametmp=""	;$p(^SSU("SSUSR",$p(^DHCINVPRT(InvDr),"^",25)),"^",2)
	...s AuditDateTimetmp=""	;$zd($P(^DHCINVPRT(InvDr),"^",23),3)_" "_$zt($P(^DHCINVPRT(InvDr),"^",24),2) //end 2009-9-11
	...s AuditInfo=..GetCheckUserDateByOrdId(OEORI,"")
	...s TLinkOrder=OEORI
	...s Tinciflag="N"
	...s TDrugCollect=""
	...s ArcItmCateDR=$p(^ARCIM(+ArcimDr,$p(ArcimDr,"||",2),1),"^",10)   ;医嘱子类
	...i (($c(2)_UnAuditOrderCateStr_$c(2))[($c(2)_ArcItmCateDR_$c(2))) s UnAuditOrdItem="Y" ;医嘱属于免审核的子类则q出 add by wanghc 2009-10-12
	...e  s UnAuditOrdItem="N"
	...//+2017-08-28 ZhYW
	...set matDispGrant="N"
	...set Data=$lb(selflag,ArcimDesc,PatSum,OrderBillQty,recdepdesc,returnqty,OEORI,Executflag,myRefSum,myAuditFlag,myAuditCheckDis,myAuditSelFlag,OEORDExecQty,myPrescNo,myCMFlag,AuditUserName,AuditDateTime,ExecutFlagDesc,mySeqNo,UnAuditOrdItem,TExecutDesc,TOrdUserDepDesc,$g(CPrtInv),$g(TItemStat),$g(TLinkOrder),$g(TOrdDate),$g(TDepDesc),$g(TDrugRetRequ),$g(TDrugRetReason),$g(TDrugRetALready),$g(TDrugRetReasonDr),ind,$g(ARCOrdType),$g(TOEORDExecQty),$g(TCanReturnNum),Tphdi,$g(TOweFlag),$g(TDrugCollect),Tinciflag,TOrdStopStatus,matDispGrant)
	...set ^CacheTemp(repid,ind)=Data
	...set ind=ind+1
	  
	k ^||TMP($j)
	q MYYPorderstr
}

/// Creator:        HYG
/// CreatDate:      2014-04-27
/// Desc:           输入数量是否是频次
/// /##class(web.DHCOPBillRefundRequestNew).getqdnum("2531||27")
ClassMethod getqdnum(TCanReturnNum As %Library.String, oroeid As %Library.String)
{
	n (oroeid,TCanReturnNum)
	s qty=##class(web.DHCOutPhDisp).getDspQty(oroeid)
    s phdudr=+$p(^OEORD(+oroeid,"I",$p(oroeid,"||",2),2),"^",6)
    i (phdudr'=0)  d
	.i $d(^PHCDU(phdudr)) d
	..s phdfactor=$p(^PHCDU(phdudr),"^",2)
	s phfragdr=$p($g(^OEORD(+oroeid,"I",$p(oroeid,"||",2),2)),"^",4)
	i (phfragdr'="")  d
	.s phfac=$p($g(^PHCFR(phfragdr)),"^",2)    //频次系数
	.s phfactor=$p($g(^PHCFR(phfragdr)),"^",5)
	s:(phfactor="") fac=phfac*phdfactor
	s:(phfactor'="") fac=phfac*phdfactor/phfactor
	s:(fac[".") fac=+$p(fac,".",1)+1 
	s dosage=qty/fac
	S TCanReturnNum=TCanReturnNum/dosage
	s flag=TCanReturnNum
	s:TCanReturnNum["." flag=0
	q flag
}

/// Creator:        HYG
/// CreatDate:      2014-04-27
/// Desc:           输入数量
/// /##class(web.DHCOPBillRefundRequestNew).getqdnum("2531||27")
ClassMethod getrtnqdnum(flag As %Library.String, oroeid As %Library.String)
{
	n (oroeid, TCanReturnNum)
	s qty=+$p($g(^OEORD(+OEORI,"I",$p(OEORI,"||",2),1)),"^",12)
    s phdudr=+$p(^OEORD(+oroeid,"I",$p(oroeid,"||",2),2),"^",6)
    i (phdudr'=0)  d
	.i $d(^PHCDU(phdudr)) d
	..s phdfactor=$p(^PHCDU(phdudr),"^",2)
	s phfragdr=$p($g(^OEORD(+oroeid,"I",$p(oroeid,"||",2),2)),"^",4)
	i (phfragdr'="")  d
	.s phfac=$p($g(^PHCFR(phfragdr)),"^",2)    //频次系数
	.s phfactor=$p($g(^PHCFR(phfragdr)),"^",5)
	s:(phfactor="") fac=phfac*phdfactor
	s:(phfactor'="") fac=phfac*phdfactor/phfactor
	s:(fac[".") fac=+$p(fac,".",1)+1 
	s dosage=qty/fac
	s rtnnum=dosage*flag

	q rtnnum
}

ClassMethod ReadOEORDExecQty(PRTRowID As %String, OEORI As %String, ExpStr As %String) As %String
{
	n (PRTRowID, OEORI, ExpStr)
	s myExcQty=0, excqty=1
	q:(OEORI="") myExcQty
	s ArcimRowid=$p($g(^OEORD(+OEORI,"I",$p(OEORI,"||",2),1)),"^",2)		;EORI_ItmMast_DR	
	s myORESub=0
	f  s myORESub=$o(^OEORD(+OEORI,"I",$p(OEORI,"||",2), "X",myORESub))  q:(myORESub="")  d
	.s myExStDate=$p(^OEORD(+OEORI,"I",$p(OEORI,"||",2), "X",myORESub), "^", 1)	;OEORE_ExStDate
	.s myExStTime=$p(^OEORD(+OEORI,"I",$p(OEORI,"||",2), "X",myORESub), "^", 2)	;EORE_ExStTime
	.s myOrdAdmStatusDR=$p(^OEORD(+OEORI,"I",$p(OEORI,"||",2), "X",myORESub), "^", 16)		;OEORE_Order_AdminStatus
	.q:(myOrdAdmStatusDR="")
	.s mySBill=$p(^OEC("STAT",myOrdAdmStatusDR),"^",3)
	.q:(mySBill="N")
	.s myExcQty=+myExcQty+1
	s ret=##class(web.DHCSTPIVA).GetDosageBUom(OEORI)
	i (ret'="") d
    .s dosage=$p(ret,"^",1)
    .i (dosage[".")  d
    ..s excqty=+$p(dosage,".",1)+1
    .e  d
    ..s excqty=dosage
    
	q myExcQty*excqty
}

ClassMethod GetOEORIReason(PrtRowid, OEORI)
{
	n (PrtRowid, OEORI)
	s DHCORIRowId=$o(^DHCORDItem(0,OEORI,0))
	q:(DHCORIRowId="") ""
	s OEAUser=$p(^DHCORDItem(DHCORIRowId,1),"^",2)
	s OEADate=$p(^DHCORDItem(DHCORIRowId,1),"^",3)
	s OEATime=$p(^DHCORDItem(DHCORIRowId,1),"^",4)
	s OEAReasonDr=$p(^DHCORDItem(DHCORIRowId,1),"^",5)
	s OEALoc=$p(^DHCORDItem(DHCORIRowId,1),"^",6)
	i (OEAUser'="") s OEAUser=$p(^SSU("SSUSR",OEAUser),"^",2)
	i (OEADate'="") s OEADate=$zd(OEADate,3)
	i (OEATime'="") s OEATime=$zt(OEATime,1)
	s OEAReasonDesc=""
	i (OEAReasonDr'="") s OEAReasonDesc=$p(^DHCINVOPREFR(OEAReasonDr),"^",2)

	s out=OEAUser_"^"_OEADate_"^"_OEATime_"^"_OEAReasonDr_"^"_OEAReasonDesc_"^"_OEALoc
	
	q out
}

/// Creator:Lid
/// CreatDate:2017-03-10
/// Desc:初始化组件Table上每行的"申请部位"单元格
/// w ##class(web.DHCOPBillRefundRequestNew).InitRepPartTarCell()
ClassMethod InitRepPartTarCell()
{
	set index=rs.GetDataByName("Tind")
	set oeitm=rs.GetDataByName("TOrderRowid")
	quit:$tr(oeitm," ","")="" ""
	set prtRowId=rs.GetDataByName("InvPrtDr")
	set:+prtRowId=0 prtRowId=""""""
	
	set executFalg=rs.GetDataByName("ExecutFlagDesc")
	set RefundRepPart="RefundRepPart"_"z"_index
	set isAppRepFlag=##class(web.UDHCJFPRICE).IsAppRepOrder(oeitm)
	if (isAppRepFlag="Y") {
		if (executFalg="已执行"){
			set active="1"
		}else {
			set active="1"	;默认按钮可用
		}
		set color="blue"
		set active=$s(active="1":"",1:"disabled")
		set tmpoeitm=""""_oeitm_""""
		write "<input type='button' id='BtnOpenPartWin' name='BtnOpenPartWin' "_active
		write " style='WIDTH: 40px; HEIGHT: 24px; COLOR: "_color_"'"
		write " value='部位' onClick='OpenPartWinOnClick("_tmpoeitm_","_prtRowId_","_index_")'>"
		write "<input type='HIDDEN' id='RefundRepPartz"_index_"' name='RefundRepPartz"_index_"' value="""" >"
	}else{
		
	}
	
	quit ""
}

/// Creator: ZhYW
/// CreatDate: 2017-08-28
/// Desc: 判断是否是走发放流程的物资
/// Input: oeitm:医嘱RowID, hospitalDR:院区RowID
/// Reutrn: Y:是，N:不是
/// w ##class(web.DHCOPBillRefundRequestNew).CheckIsMatDispGrant("111||14")
ClassMethod CheckIsMatDispGrant(oeitm As %String, hospitalDR As %String = "") As %String
{
	new (oeitm, hospitalDR)
	set grantFlag="N"
	set expStr="^^^"_hospitalDR
	set grantConfig=##class(web.DHCSTM.Common.AppCommon).GetAppPropValue("DHCSTMATDISPM", "MatDisp", expStr)
	quit:(grantConfig'="Y") grantFlag
	quit:($l(oeitm,"||")'=2) grantFlag
	set arcim=$p(^OEORD(+oeitm,"I",$p(oeitm,"||",2),1),"^",2)
	set isMatArcim=##class(web.DHCSTINTERFACE).isMatArcim(arcim)
	if (+isMatArcim=1) {
		set grantFlag="Y"
	}

	quit grantFlag
}

/// Creator: ZhYW
/// CreatDate: 2018-10-16
/// Description: 获取结算的处方信息
/// Input: prtRowId:DHC_INVPRT.RowId
/// Output: 
/// Return: 
/// Debug: w ##class(web.DHCOPBillRefundRequestNew).GetPrtPresnoInfo()
ClassMethod GetPrtPresnoInfo(prtRowId As %String) As %String
{
	new (prtRowId)
	set rtn=0
	quit:(+prtRowId=0) rtn
	
	kill ^||TMP($j,prtRowId)
	
	set bciDr="0"
    for  set bciDr=$o(^DHCBCI(0,"INV",prtRowId,bciDr)) quit:(bciDr="")  do
    .set pb=$p(^DHCBCI(bciDr),"^",2)
	.quit:(+pb=0)
    .set pbo="0"
    .for  set pbo=$o(^DHCPB(pb,"O",pbo)) quit:(pbo="")  do
    ..quit:($d(^DHCPB(pb,"O",pbo))=10)
    ..set arcim=$p(^DHCPB(pb,"O",pbo),"^",3)
    ..set oeori=$p(^DHCPB(pb,"O",pbo),"^",4)
    ..set orderType=##class(web.UDHCJFBaseCommon).GetOrdCateType(arcim, 0)
    ..quit:(orderType'="R")       //过滤非药品医嘱
    ..set priorityId=$p($g(^OEORD(oeori,"I",$p(oeori,"||",2),1)),"^",8)
	..set priorityCode=$s((priorityId'=""):$p(^OECPR(priorityId),"^",1),1:"")
	..quit:(priorityCode["OM")	   //过滤自备药医嘱
    ..set presno=$p(^OEORD(+oeori,"I",$p(oeori,"||",2),1),"^",14)
    ..quit:(presno="")
    ..set ^||TMP($j,prtRowId,presno)=$g(^||TMP($j,prtRowId,presno))_"^"_oeori
    
    quit rtn
}

ClassMethod tb()
{
	n SQLCODE
	TSTART  s SQLCODE=$zu(34)
	q
}

ClassMethod tc()
{
	n SQLCODE
	TCOMMIT  s SQLCODE=$zu(34)
	q
}

}
