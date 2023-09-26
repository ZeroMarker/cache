Import SQLUser

Class web.udhcOPRefund Extends BILL.COM.Abstract
{

/// AuditFlag审批标志
/// 在此编写算法计算必须要退的医嘱项目selflag=1
/// Executflag  应该表示为?执行医嘱标志?(只要医嘱被执行过?药品和费用项目等)
/// InvType   "PRT"    DHC_INVPRT
/// InvType   "API"    DHC_AccPayInv
/// d ##class(%ResultSet).RunQuery("web.udhcOPRefund","GetOrderbyReceipID",214562,"","")
Query GetOrderbyReceipID(ReceipRowid As %String, AuditFlag As %String, InvType As %String) As websys.Query(ROWSPEC = "Tselect:%String,TOrder:%String,TOrderSum:%String,TOrderQty:%String,TRecloc:%String,TReturnQty:%String,TOrderRowid:%String,TExcuteflag:%String,RefSum:%String,AuditFlag:%String,AuditCheckDis:%String,AuditSelFlag:%String,OEORDExecQty:%String,PrescNo:%String,CMFlag:%String,AuditUserName:%String,AuditDateTime:%String,ExecutFlagDesc:%String,mySeqNo:%String,UnAuditOrdItem:%String,TExecutDesc,TOrdUserDepDesc,InvPrtDr,TItemStat,TLinkOrder,TOrdDate,TDepDesc,TOrdStopStatus,TOrderType,Tind:%String,TPBORowID:%String,TPackUom:%String")
{
}

ClassMethod GetOrderbyReceipIDExecute(ByRef qHandle As %Binary, ReceipRowid As %String, AuditFlag As %String, InvType As %String) As %Status
{
    set repid=$I(^CacheTemp)
    set qHandle=$lb(0,repid,0)
    set ind=1
    do ResetVariables
    set ReceipRowid=$p(ReceipRowid,"^",1)
	if (ReceipRowid="") quit $$$OK
	
    if (InvType="")   set InvType="PRT"

    //+2015-2-13 hujunbin 留观病人只显示停止的医嘱
    set StayFlag="N"
    if (InvType="PRT")  do
    .set StayFlag=$p(^DHCINVPRT(ReceipRowid),"^",44)    //发票上的急诊留观标志
    .do GetInvDetail(ReceipRowid)
    if (InvType="API")  do
    .set APCons="0"
    .for  set APCons=$o(^DHCINVPRTCAPi(0,"APINVDR",ReceipRowid,APCons))   quit:(APCons="")  do
    ..set InvDr=$p($g(^DHCINVPRTCAP(APCons)),"^",1)
    ..set StayFlag=$p($g(^DHCINVPRT(InvDr)),"^",44)     //发票上的急诊留观标志
    ..do GetInvDetail(InvDr)
 
    quit $$$OK
    
GetInvDetail(InvDr)
	set hospitalDR=$p(^DHCINVPRT(InvDr),"^",39)
    set HerbConfig=##class(web.DHCOPConfig).GetHerbalConfig(hospitalDR)
	set FCHerbRange=$p(HerbConfig,$c(2),5)
	
	set configInfo=##class(web.DHCOPConfig).ReadOPSPConfig(hospitalDR)
	set UnAuditOrderCateStr=$p(configInfo,"^",37)
	//set UnAuditOrderCateStr=##class(web.DHCOPConfig).GetUnAuditOrderCate(hospitalDR)
	
    set conRowid=0
    for  set conRowid=$o(^DHCBCI(0,"INV",InvDr,conRowid)) quit:(conRowid="")  do
    .set bill=$p($g(^DHCBCI(conRowid)),"^",2)
    .set selflag=1
    .set PBOChildsub=0
    .for  set PBOChildsub=$o(^DHCPB(bill,"O",PBOChildsub)) q:(PBOChildsub="")  do
    ..set pboInfo=$g(^DHCPB(bill,"O",PBOChildsub))
    ..quit:(pboInfo="")
    ..set (AuditUserName, AuditDateTime, ExecutFlagDesc, ARCOrdType)=""
    ..set PBO=bill_"||"_PBOChildsub
    ..set Arcim=$p(pboInfo,"^",3)                //DHC_PatBillOrder->PBO_ARCIM_DR
    ..set ArcItmCateDR=$p(^ARCIM(+Arcim,$p(Arcim,"||",2),1),"^",10)   //医嘱子类
    ..set UnAuditOrdItem="N"
    ..if (($c(2)_UnAuditOrderCateStr_$c(2))[($c(2)_ArcItmCateDR_$c(2))) set UnAuditOrdItem="Y"   //医嘱属于免审核的子类内则q出 add by wanghc 2009-10-12
    ..set ArcimDesc=$p($g(^ARCIM(+Arcim,$p(Arcim,"||",2),1)),"^",2)   //名称
    ..set OEORI=$p(pboInfo,"^",4)                  //PBO_OEORI_DR
	..set OrderBillQty=$p(pboInfo,"^",5)           //PBO_BillQty
	..set Billreturnqty=+$p(pboInfo,"^",6)         //PBO_RefundQty
    ..set mySeqNo=$p($g(^OEORD(+OEORI,"I",$p(OEORI,"||",2),3)),"^",4)
    ..set myrtn=##class(web.UDHCPRTOEAuthIF).ReadOEORDAuthFlag(InvDr, OEORI, "")
    ..set myAuditFlag=$p(myrtn,"^",1)         //判断是否审批
    ..set myAuditCheckDis=$p(myrtn,"^",2)     //判断选择项目是否Disable
    ..set myAuditSelFlag=$p(myrtn,"^",3)      //判断选择项目是否被选中
    ..//新版检查申请单
    ..set isAppRepFlag=##class(web.UDHCJFPRICE).IsAppRepOrder(OEORI)
    ..set Executflag=0
  	..//+2017-08-28 ZhYW 判断是否走门诊物资发放流程
	..set matDispGrant=##class(web.DHCOPBillRefundRequest).CheckIsMatDispGrant(OEORI, hospitalDR)
    ..set SFlag=0
    ..set myPriceInfo=##class(web.UDHCOEORDOPIF).GetOrderPrice(bill_"||"_PBOChildsub, OEORI, SFlag, "")
    ..set OrderUnitPrice=$p(myPriceInfo,"^",1)     //PBO_UnitPrice
	..set myPatUnitPrice=$p(myPriceInfo,"^",4)     //PBO_PatPrice
    ..set returnqty=0
    ..set packUom=##class(web.DHCBillCommon).GetPackUom(Arcim, OEORI)
    ..set confac=##class(web.DHCBillCommon).GetUomConvFactor(Arcim, OEORI)
    ..set TotalSum=$p(^DHCPB(bill,"O",PBOChildsub),"^",8)
    ..set PatSum=$p(^DHCPB(bill,"O",PBOChildsub),"^",11)
    ..set PatSum=$fn(PatSum,"",2)
    ..set myRefSum=PatSum
    ..set recDeptDR=$p($g(^OEORD(+OEORI,"I",+$p(OEORI,"||",2),3)),"^",6)   //接收科室
    ..set recdepdesc=$s((+recDeptDR'=0):$p($g(^CTLOC(recDeptDR)),"^",2),1:"")
    ..if ($l(recdepdesc,"-")>1) set recdepdesc=$p(recdepdesc,"-",2)
    ..set ARCCATRowid=$p(^ARCIM(+Arcim,$p(Arcim,"||",2),1),"^",10)
    ..set ARCOrdType=$p(^ARC("IC",ARCCATRowid),"^",7)
    ..set myPrescNo="", myCMFlag=""
    ..if (ARCOrdType="R")  do
    ...set myPrescNo=$p($g(^OEORD(+OEORI,"I",+$p(OEORI,"||",2),1)),"^",14)   //处方号
    ...if (FCHerbRange[("^"_ARCCATRowid_"^")) s myCMFlag="Y"
    ...set Executflag=##class(web.UDHCOEORDOPIF).CheckPhDispRet(OEORI)       //发药标识
    ...set returnqty=##class(web.DHCOutPhReturn).GetRetOrdQty(OEORI, InvDr)
    ...//modify 2013-07-18 chenxi 配液中心药品取药房接口程序
    ...set OEFlag=$p($g(^OEORD(+OEORI,"I",$p(OEORI,"||",2),"DHC")),"^",16)
    ...if (OEFlag="Y")  do
    ....set OrderBillQty=(OrderBillQty+Billreturnqty)/confac     //2015-03-30 chenxi 静配不允许多次退药，此处取账单退费数量和收费数量合计
    ....set PackQty=##class(web.DHCSTPIVAOUTCOMMON).GetPIVAOutValidQty(OEORI)
    ....set PackQty=PackQty/confac
    ....set returnqty=OrderBillQty-PackQty
    ...set OrderBillQty=(OrderBillQty+Billreturnqty)/confac
    ...//
    ...set returnqty=returnqty/confac
    ...if (Executflag=0) do
    ....//药物医嘱?没有发药的
    ....set selflag=0
    ...else  do
    ....//药物医嘱?已经发药的
    ....set selflag=0
	....set ExecutFlagDesc="已发药"
    ....//已经退药的
    ....if (+returnqty'=0) do
    .....if (OrderBillQty=returnqty) do
    ......set selflag=1       //全部退
    .....else  do
    ......set selflag=1       //部分退
    .....if (+PatSum'=0)  do
    ......//set myRefSum=myPatUnitPrice*confac*returnqty
    ......//set myRefSum=$fn(myRefSum+0.0000001,"",2)
    ......set myRefSum=..GetPHRefundSum(PBO, InvDr)    //+2018-12-27 ZhYW 药品退药金额
    ..//+2017-06-21 ZhYW
    ..else  if (matDispGrant="Y") do
	...set OrderBillQty=OrderBillQty+Billreturnqty
    ...//判断物资是否已发放
    ...set Executflag=##class(web.DHCOPBillRefundRequest).CheckMatDisp(OEORI)    //0 未发, 1 已发
    ...if (Executflag=0) do
    ....set selflag=0
    ...else  do
    ....set selflag=0
    ....set myExpStr=InvDr
    ....set ApplyRefQtyInfo=##class(web.DHCOPBillOERefundQty).GetRefundQTY(OEORI, myExpStr)   //物资实际退费数量
    ....set ApplyRefQty=+$p(ApplyRefQtyInfo,"^",2)
    ....if (+ApplyRefQty'=0) do
    .....set returnqty=ApplyRefQty
    ....set ExecutFlagDesc="已发放"
    ....set myRefSum=myPatUnitPrice*ApplyRefQty
    ....set myRefSum=$fn(myRefSum+0.0000001,"",2)
   	..//
    ..else  do
    ...set OrderBillQty=(OrderBillQty+Billreturnqty)
    ...set OrdStat=$p(^OEORD(+OEORI,"I",$p(OEORI,"||",2),1),"^",13)
    ...set OrdStatCode=$p(^OEC("OSTAT",OrdStat),"^",1)
    ...if (OrdStatCode="E") do
    ....if (isAppRepFlag="Y") do
	.....//判断是否是部分执行
	.....set isPartExecFlag=##class(web.udhcOPRefund).IsPartExecut(OEORI)
	.....if (isPartExecFlag=0) do
	......set Executflag=0
	......set selflag=0
	....else  do
	.....//被执行的非药物医嘱
	.....set Executflag=1
	.....set selflag=0
    ...else  do
    ....//没有被执行的非药物医嘱
    ....set OEORDExecQty=##class(web.UDHCOEORDOPIF).ReadOEORDExecQty(InvDr, OEORI, "")
    ....if (+OEORDExecQty'=0) do
	.....set myRefSum=(OrderBillQty-OEORDExecQty)*myPatUnitPrice
    .....if (+myRefSum<0) set myRefSum=0
    .....set myRefSum=$fn(myRefSum+0.0000001,"",2)
    ....set Executflag=0
    ....set selflag=0
    ...set:(+Executflag=1) ExecutFlagDesc="已执行"
    ...//申请退费数量不为0时, 按申请退费数量退费
    ...set ApplyRefQtyInfo=##class(web.DHCOPBillOERefundQty).GetRefundQTY(OEORI, "")
    ...set ApplyRefQty=+$p(ApplyRefQtyInfo,"^",2)
    ...if (+ApplyRefQty'=0) do
    ....set returnqty=ApplyRefQty
    ....set myRefSum=myPatUnitPrice*ApplyRefQty
    ....set myRefSum=$fn(myRefSum+0.0000001,"",2)
    ...//
	...if (isAppRepFlag="Y") do
    ....//取退费金额
    ....set isRefAll=##class(web.udhcOPRefund).IsAllRefundRepPart(OEORI)
    ....if (isRefAll=1) set returnqty=0	        //部分退费
    ....else  set returnqty=1	                //全部退费
    ....set myRefSum=..GetRepPartRefAmt(OEORI, PBO)
    ..//
    ..if ((+selflag=1)&&(+Executflag=1)) do
    ...set myAuditSelFlag=1
    ..set ItemStat=$p($g(^OEORD(+OEORI,"I",+$p(OEORI,"||",2),1)),"^",13)     //医嘱状态
    ..set TItemStat=$p(^OEC("OSTAT",ItemStat),"^",2)
    ..set TOrdStopStatus=$p(^OEC("OSTAT",ItemStat),"^",1)
    ..set TLinkOrder=$p($g(^OEORD(+OEORI,"I",+$p(OEORI,"||",2),11)),"^",39)  //关联医嘱指针
    ..set TOrdDate=$p($g(^OEORD(+OEORI,"I",+$p(OEORI,"||",2),1)),"^",9)      //医嘱日期
    ..set TOrdDate=##class(websys.Conversions).DateLogicalToHtml(TOrdDate)
    ..set TDepID=$p($g(^OEORD(+OEORI,"I",+$p(OEORI,"||",2),1)),"^",3)        //科室
    ..set TDepDesc=$s((+TDepID'=0):$p($g(^CTLOC(TDepID)),"^",2),1:"")
    ..if (TDepDesc["-") set TDepDesc=$p(TDepDesc,"-",2)
    ..//quit:(+PatSum=0)
    ..quit:(+TotalSum=0)     //记账系数为1时,要求可以退费  add zhli  17.9.8
  	..quit:((StayFlag="Y")&&(+myAuditSelFlag'=1))   //+2015-2-13 hujunbin 留观病人只显示需退费医嘱
    ..do OutputRow
    
    quit
OutputRow
    set Data=$lb(selflag,ArcimDesc,PatSum,OrderBillQty,recdepdesc,returnqty,OEORI,Executflag,myRefSum,myAuditFlag,myAuditCheckDis,myAuditSelFlag,OEORDExecQty,myPrescNo,myCMFlag,AuditUserName,AuditDateTime,ExecutFlagDesc,mySeqNo,UnAuditOrdItem,TExecutDesc,TOrdUserDepDesc,InvDr,TItemStat,TLinkOrder,TOrdDate,TDepDesc,TOrdStopStatus,ARCOrdType,ind,PBO,packUom)
    set ^CacheTemp(repid,ind)=Data
    set ind=ind+1
    quit
ResetVariables
    set (ArcimDesc,PatSum,OrderBillQty,recdepdesc,returnqty,OEORI,Executflag,myRefSum,myAuditFlag,myAuditCheckDis,myAuditSelFlag,myPrescNo,myCMFlag,mySeqNo,TItemStat,TLinkOrder,TOrdDate,TDepDesc,UnAuditOrdItem,TOrdStopStatus,ARCOrdType,PBO,packUom)=""
    set selflag =0
    //医嘱执行数量 对于药物医嘱指发药数量
    set OEORDExecQty=0
    quit
}

/// 获取发票信息 DHC_INPVRT表的信息
/// 所有的发票都需要审批,可以出现假审批,当时只有=Y  时才能退费
/// w ##class(web.udhcOPRefund).GetRcptinfo("SetReceipInfo","","229006")
ClassMethod GetRcptinfo(itmjs As %String = "", itmjsex As %String = "", INVPRTRowid As %String, HospId As %String) As %String
{
	s ^TMP("GetRcptinfo")=$lb(itmjs, itmjsex, INVPRTRowid, HospId)
    s INVPRTRowid=$p(INVPRTRowid,"^",1)
    q:'$d(^DHCINVPRT(INVPRTRowid)) -1  //发票不存在
    s PRTHospDR=$p($g(^DHCINVPRT(INVPRTRowid)),"^",39)
    q:(PRTHospDR'=HospId) -1
    
    s myColPFlag=0
    s Refundflag=0
    s myAccFlag="", myAccRowID=""
    s flag=$p($g(^DHCINVPRT(INVPRTRowid)),"^",8)
    s PRTAcount=$p($g(^DHCINVPRT(INVPRTRowid)),"^",1)
    s PRTPatPay=$p($g(^DHCINVPRT(INVPRTRowid)),"^",16)
    s PRTUsr=$p($g(^DHCINVPRT(INVPRTRowid)),"^",21)
    s UserNo=$p($g(^SSU("SSUSR",PRTUsr)),"^",1)
    s PrtPapmiDR=$p($g(^DHCINVPRT(INVPRTRowid)),"^",15)
    s PapmiNo=$p($g(^PAPER(PrtPapmiDR,"PAT",1)),"^",2)
    s PapmiName=$p($g(^PAPER(PrtPapmiDR,"ALL")),"^",1)
    ;add by wangjian 2015-03-27 增加病人密级和级别
    s PatEncryptLevel=##class(web.UDHCJFBaseCommon).GetPatEncryptLevel(PrtPapmiDR, "")
    s EncryptLevel=$p(PatEncryptLevel,"^",1)
    s PatLevel=$p(PatEncryptLevel,"^",2)
    ;end
    s PapmiSex=$p($g(^PAPER(PrtPapmiDR,"ALL")),"^",7)
    s PaSex=$p(^CT("SEX",PapmiSex),"^",2)
    s myINSDivDR=$p($g(^DHCINVPRT(INVPRTRowid)),"^",30)     ;PRT_InsDiv_DR
    s myYBPaySum=+$p($g(^DHCINVPRT(INVPRTRowid)),"^",31)    ;PRT_YBPaySum
    s myOPRoundSum=+$p($g(^DHCINVPRT(INVPRTRowid)),"^",37)  ;PRT_OPCRoundErr
    s myINSTypeDR=$p($g(^DHCINVPRT(INVPRTRowid)),"^",9)     ;PRT_InsType_DR
    //s Verifyflag=$p($g(^DHCINVPRT(INVPRTRowid)),"^",22)   ;审批标志
    s myConAppFlag=$p($g(^DHCSOPFCON(1)),"^",14)            ;OPFC_AppFlag
    
    //+2019-03-25 ZhYW 先去掉不用
    //s myrtn=##class(web.UDHCPRTOEAuthIF).ReadINVAuthFlag(INVPRTRowid, "")
    s Verifyflag=""     //$p(myrtn,"^",1)
    s myMixOE=""        //$p(myrtn,"^",2)               //混合医嘱标志
    s mySpecLFalg=""    //$p($g(myrtn),"^",4)
    
    s reportsDR=$p($g(^DHCINVPRT(INVPRTRowid)),"^",6)   //->DHC_INVPRTReports
    s myINVPayMDR=""
    s myINVPMSub=$o(^DHCINVPRT(INVPRTRowid,"P",""),-1)
    i (myINVPMSub'="") d
    .s myINVPayMDR=$p($g(^DHCINVPRT(INVPRTRowid,"P",myINVPMSub)),"^",1)
    .s myAccPLDR=$p($g(^DHCINVPRT(INVPRTRowid,"P",myINVPMSub)),"^",8)       ;IPM_AccPL_DR
    .s myPayCode=$p(^CT("CTPM",myINVPayMDR),"^",1)
    .i (myPayCode="CPP") d
    ..q:(myAccPLDR="")     ;2014-08-01 tang
    ..s myAccRowID=+myAccPLDR
    ..;s myCashPMDR=$o(^CT("CTPM",0,"Code","CASH",0))
    ..s myAccFlag=$p(^DHCACD("AccM",myAccRowID),"^",13)
    ..;如果是账户支付，判断是否能够退费
    ..;如果没有打印发票，必须在此退
    ..;N   P
    ..;如果已经打印发票，不能退,必须到集中打印发票处退
    ..s myPFlag=$p($g(^DHCINVPRT(INVPRTRowid)),"^",3)       ;PRT_INVPrintFlag
    ..s myINVNo=$p($g(^DHCINVPRT(INVPRTRowid)),"^",14)      ;PRT_inv
    ..i ((myPFlag="P")&&(myINVNo="")) d
    ...s myColPFlag=1       ;已经集中打印了
    ..q:(myAccFlag="N")     ;账户正常退出，否则转为现金支付

    i $d(^DHCINVPRT(0,"InitInvDR",INVPRTRowid))  s Refundflag=1
    
    s ret=PapmiNo_"^"_PapmiName_"^"_PaSex_"^"_PRTPatPay_"^"_flag_"^"_Refundflag_"^"_PRTUsr_"^"_reportsDR_"^"_Verifyflag
    s ret=ret_"^"_myINVPayMDR_"^"_myColPFlag_"^"_myConAppFlag_"^"_myMixOE
    s ret=ret_"^"_myINSDivDR
    s ret=ret_"^"_mySpecLFalg_"^"_myYBPaySum
    s ret=ret_"^"_myOPRoundSum
    s ret=ret_"^"_myINSTypeDR
    s ret=ret_"^"_myAccFlag_"^"_PrtPapmiDR_"^"_EncryptLevel_"^"_PatLevel_"^"_myAccRowID
    s ret=ret_"^"_UserNo
	
    s retval=itmjs_"('"_$ZCVT(ret,"O","JS")_"');"
    i itmjsex'="""" s retval=retval_itmjsex_"('"_$ZCVT(ret,"O","JS")_"');"
    &javascript<#(retval)#>
    
    q 0
}

/// w ##class(web.udhcOPRefund).GetRepROWIDBroker("SetReceipID","","ZY100001091","2")
ClassMethod GetRepROWIDBroker(itmjs As %String = "", itmjsex As %String = "", ReceipNO As %String, HospDR As %String)
{
	set ^TMP("ReceipNO")=$lb(itmjs, itmjsex, ReceipNO, HospDR)
    set rtn=..GetRepROWID(ReceipNO, HospDR)
    set retval=itmjs_"('"_$ZCVT(rtn,"O","JS")_"');"
    if itmjsex'="""" set retval=retval_itmjsex_"('"_$ZCVT(rtn,"O","JS")_"');"
    &javascript<#(retval)#>
    quit rtn
}

ClassMethod GetRepROWID(ReceipNO As %String, HospDR As %String) As %String
{
    s rtn=-1
	
    s INVPRTRowId=""
    f  s INVPRTRowId=$o(^DHCINVPRT(0,"INV",ReceipNO,INVPRTRowId),-1) q:((INVPRTRowId="")||(+rtn'=-1))  d
    .s FairType=$p($g(^DHCINVPRT(INVPRTRowId)),"^",34)
    .q:(FairType'="F")
    .s InvHospDr=$p(^DHCINVPRT(INVPRTRowId),"^",39)
    .q:(HospDR'=InvHospDr)
    .s rtn=INVPRTRowId_"^PRT"
    q:(+rtn'=-1) rtn
    
    //集中打印发票
    s AccPInvRowId=""
    f  s AccPInvRowId=$o(^DHCINVPRTAPi(0,"INVNo",ReceipNO,AccPInvRowId),-1) q:((AccPInvRowId="")||(+rtn'=-1))  d
    .s InvHospDr=$p(^DHCINVPRTAP(AccPInvRowId),"^",30)
    .q:(HospDR'=InvHospDr)
    .s rtn=AccPInvRowId_"^API"
  
    q rtn
}

/// 利用DHC_AccPayINV表的RowID查询医嘱List
/// 在此编写算法计算必须要退的医嘱项目selflag=1
/// 能否选择由两个变量决定：1。是否执行，2。是否审批通过
/// Executflag  应该表示为?执行医嘱标志?(只要医嘱被执行过?药品和费用项目等)
/// myAppFlag   表示此医嘱是否经过审批
/// 如果小票没有经过审批，就是退药，也不能退费,即：selflag=0
/// do ##class(%ResultSet).RunQuery("web.udhcOPRefund","ReadOrderByAPIRowID", "21163")
Query ReadOrderByAPIRowID(APIRowID As %String) As websys.Query(ROWSPEC = "Tselect:%String,TOrder:%String,TOrderSum:%String,TOrderQty:%String,TRecloc:%String,TReturnQty:%String,TOrderRowid:%String,TExcuteflag:%String,RefSum:%String,PRTRowID:%String,RecLocdesc:%String,Tind:%String,BillNo:%String,AppFlag:%String,AppDesc:%String,AuditCheckDis:%String,AuditSelFlag:%String,PayDTime:%String,TItemStat:%String,TLinkOrder:%String,TOrdDate:%String,TDepDesc:%String,TOEORDExecQty:%String,TPBORowID:%String,TUnAuditOrdItem:%String,TItemStatCode:%String,TPackUom::%String")
{
}

ClassMethod ReadOrderByAPIRowIDExecute(ByRef qHandle As %Binary, APIRowID As %String) As %Status
{
    set repid=$I(^CacheTemp)
    set qHandle=$lb(0,repid,0)
    set ind=1
    if (APIRowID="")  quit $$$OK
    
	set UnAuditOrderCateStr=##class(web.DHCOPConfig).GetUnAuditOrderCate()
    
    set myAConRowID=0
    for  set myAConRowID=$o(^DHCINVPRTCAPi(0,"APINVDR",APIRowID,myAConRowID)) quit:(myAConRowID="")  do
    .set ReceipRowid=$p(^DHCINVPRTCAP(myAConRowID),"^",1)                 ;ACP_INVPRT_DR
    .set myAppFlag=$p(^DHCINVPRT(ReceipRowid),"^",22)                     ;审批标志
    .set myConAppFlag=$p($g(^DHCSOPFCON(1)),"^",14)                       ;OPFC_AppFlag
    .set myINVPMSub=$o(^DHCINVPRT(ReceipRowid,"P",0))
    .if (myINVPMSub'="") do
    ..set myINVPayMDR=$p($g(^DHCINVPRT(ReceipRowid,"P",myINVPMSub)),"^",1)
    ..set myAccPLDR=$p($g(^DHCINVPRT(ReceipRowid,"P",myINVPMSub)),"^",8)      ;IPM_AccPL_DR
    ..quit:(myAccPLDR="")
	..set myBillNo=$p(^DHCACD("AccM",+myAccPLDR,"AccPL",$p(myAccPLDR,"||",2)),"^",4)
    ..set myRecLocDR=$p(^DHCACD("AccM",+myAccPLDR,"AccPL",$p(myAccPLDR,"||",2)),"^",10)   
    ..set myRecLocdesc=$p($g(^CTLOC(myRecLocDR)),"^",2)
    .set conRowid=0
    .for  set conRowid=$o(^DHCBCI(0,"INV",ReceipRowid,conRowid)) quit:(conRowid="")  do
    ..set bill=$p($g(^DHCBCI(conRowid)),"^",2)
    ..set myPRTDR=$p($g(^DHCBCI(conRowid)),"^",1)
    ..set myPayDTime=$p(^DHCINVPRT(myPRTDR),"^",5)
    ..set myPayDTime=##class(websys.Conversions).DateLogicalToHtml(myPayDTime)
    ..set myPaytime=$p(^DHCINVPRT(myPRTDR),"^",20)
    ..set myPaytime=##class(websys.Conversions).TimeLogicalToHtml(myPaytime, 1)
    ..set myPayDTime=myPayDTime_" "_myPaytime
    ..set selflag=1
    ..set PBOChildsub=0
    ..for  set PBOChildsub=$o(^DHCPB(bill,"O",PBOChildsub)) quit:(PBOChildsub="")  do
    ...quit:$d(^DHCPB(bill,"O",PBOChildsub))=10
    ...set PBO=bill_"||"_PBOChildsub
    ...set Arcim=$p(^DHCPB(bill,"O",PBOChildsub),"^",3) ;DHC_PatBillOrder->PBO_ARCIM_DR
    ...set ArcimDesc=$p($g(^ARCIM(+Arcim,$p(Arcim,"||",2),1)),"^",2) 
	...set ArcItmCateDR=$p(^ARCIM(+Arcim,$p(Arcim,"||",2),1),"^",10)   ;医嘱子类
	...set UnAuditOrdItem="N"
	...if (($c(2)_UnAuditOrderCateStr_$c(2))[($c(2)_ArcItmCateDR_$c(2))) set UnAuditOrdItem="Y"
    ...set OEORI=$p(^DHCPB(bill,"O",PBOChildsub),"^",4)    ;DHC_PatBillOrder->PBO_OEORI_DR
    ...set Executflag=0
    ...set OrderUnitPrice=$p(^DHCPB(bill,"O",PBOChildsub),"^",7)      ;PBO_UnitPrice
    ...set Billreturnqty=+$p(^DHCPB(bill,"O",PBOChildsub),"^",6)      ;PBO_RefundQty
    ...set OrderBillQty=$p(^DHCPB(bill,"O",PBOChildsub),"^",5)        ;PBO_BillQty
    ...set SFlag=0
    ...set myPriceInfo=##class(web.UDHCOEORDOPIF).GetOrderPrice(bill_"||"_PBOChildsub, OEORI, SFlag, "")
    ...set OrderUnitPrice=$p(myPriceInfo,"^",1)               ;PBO_UnitPrice
    ...set myPatUnitPrice=$p(myPriceInfo,"^",4)               ;PBO_PatPrice
    ...set returnqty=0
    ...set packUom=##class(web.DHCBillCommon).GetPackUom(Arcim, OEORI)
    ...set confac=##class(web.DHCBillCommon).GetUomConvFactor(Arcim, OEORI)
    ...set OrderBillQty=(OrderBillQty+Billreturnqty)/confac
    ...quit:(OrderBillQty=0)
    ...set myrtn=##class(web.UDHCPRTOEAuthIF).ReadOEORDAuthFlag(ReceipRowid, OEORI, "")
    ...set myAppFlag=$p(myrtn,"^",1)           ;判断是否审批
    ...set myAuditCheckDis=$p(myrtn,"^",2)     ;判断选择项目是否Disable
    ...set myAuditSelFlag=$p(myrtn,"^",3)      ;判断选择项目是否被选中
	...//+2017-08-28 ZhYW 判断是否走门诊物资发放流程
	...set matDispGrant=##class(web.DHCOPBillRefundRequest).CheckIsMatDispGrant(OEORI, "")
    ...//+2017-07-06 ZhYW 新版检查申请单
    ...set isAppRepFlag=##class(web.UDHCJFPRICE).IsAppRepOrder(OEORI)
    ...set PatSum=$p(^DHCPB(bill,"O",PBOChildsub),"^",11)
    ...set PatSum=$fn(PatSum,"",2)
    ...set myRefSum=PatSum
    ...set recDeptDR=$p($g(^OEORD(+OEORI,"I",+$p(OEORI,"||",2),3)),"^",6)       //接收科室
    ...set recdepdesc=$s((+recDeptDR'=0):$p($g(^CTLOC(recDeptDR)),"^",2),1:"")
    ...if ($l(recdepdesc,"-")>1) set recdepdesc=$p(recdepdesc,"-",2)
    ...set ARCCATRowid=$p(^ARCIM(+Arcim,$p(Arcim,"||",2),1),"^",10)
    ...set ARCOrdType=$p(^ARC("IC",ARCCATRowid),"^",7)
    ...if (ARCOrdType="R")  do
    ....set Executflag=##class(web.UDHCOEORDOPIF).CheckPhDispRet(OEORI)
    ....set returnqty=##class(web.DHCOutPhReturn).GetRetOrdQty(OEORI, ReceipRowid)
    ....//modify 2013-07-18 chenxi 配液中心药品取药房接口程序
    ....set OEFlag=$p($g(^OEORD(+OEORI,"I",$p(OEORI,"||",2),"DHC")),"^",16)
    ....if (OEFlag="Y")  do
    .....set PackQty=##class(web.DHCSTPIVAOUTCOMMON).GetPIVAOutValidQty(OEORI)
    .....set PackQty=PackQty/confac
    .....set returnqty=OrderBillQty-PackQty
    ....set confac=##class(web.DHCBillCommon).GetUomConvFactor(Arcim, OEORI)
    ....set returnqty=returnqty/confac
    ....if (Executflag=0) do
    .....//药物医嘱?没有发药的
    .....set selflag=0
    ....else  do
    .....//药物医嘱?已经发药的
    .....set selflag=0
    .....//已经退药的  同时要求审批过的小票
    .....if ((+returnqty'=0)&&(myAppFlag="Y")) do
    ......if (OrderBillQty=returnqty)  do
    .......set selflag=1      //全部退
    ......else  do
    .......set selflag=1      //部分退
    ......if (+PatSum'=0) do
    .......//set myRefSum=myPatUnitPrice*confac*returnqty
    .......//set myRefSum=$fn((myRefSum+0.0000001),"",2)
    .......set myRefSum=..GetPHRefundSum(PBO, ReceipRowid)  //+2018-12-27 ZhYW 药品退药金额
	...//+2017-06-21 ZhYW
    ...else  if (matDispGrant="Y") do
	....set OrderBillQty=OrderBillQty+Billreturnqty
    ....//判断物资是否已发放
    ....set Executflag=##class(web.DHCOPBillRefundRequest).CheckMatDisp(OEORI)    //0 未发, 1 已发
    ....if (Executflag=0) do
    .....set selflag=0
    ....else  do
    .....set selflag=0
    .....set myExpStr=ReceipRowid
    .....set ApplyRefQtyInfo=##class(web.DHCOPBillOERefundQty).GetRefundQTY(OEORI, myExpStr)   //物资实际退费数量
    .....set ApplyRefQty=+$p(ApplyRefQtyInfo,"^",2)
    .....if (+ApplyRefQty'=0) do
    ......set returnqty=ApplyRefQty
    ......set Executflag=1
    .....set myRefSum=myPatUnitPrice*ApplyRefQty
    .....set myRefSum=$fn(myRefSum+0.0000001,"",2)
   	...//
    ...else  do
    ....set OrdStat=$p(^OEORD(+OEORI,"I",$p(OEORI,"||",2),1),"^",13)
    ....set OrdStatCode=$p(^OEC("OSTAT",OrdStat),"^",1)
    ....if (OrdStatCode="E") do
    .....//+2017-07-06 ZhYW
    .....if (isAppRepFlag="Y") do
    ......//判断是否是部分执行
    ......set isPartExecFlag=##class(web.udhcOPRefund).IsPartExecut(OEORI)
    ......if (isPartExecFlag=0) do
	.......set Executflag=0
	.......set selflag=0
    .....else  do
    ......//被执行的非药物医嘱?
    ......set Executflag=1
    ......set selflag=0
    ....else  do
    .....//没有被执行的非药物医嘱?
    .....set Executflag=0
    .....set selflag=0
    .....//计算被执行数量
    .....set OEORDExecQty=##class(web.UDHCOEORDOPIF).ReadOEORDExecQty(ReceipRowid, OEORI, "")
    .....if (+OEORDExecQty'=0) do
    ......//set myRefSum=(OrderBillQty-OEORDExecQty)*OrderUnitPrice
    ......set returnqty=OrderBillQty-OEORDExecQty
    ......set myRefSum=returnqty*myPatUnitPrice
    ......set:(+myRefSum<0) myRefSum=0
    ......set myRefSum=$fn(myRefSum+0.0000001,"",2)
    .....//申请退费数量不为0时，按申请退费数量退费,
    .....//此次注意"部分退费"与"部分退执行"的优先级。优先按"部分退费"，其次按"部分执行"
    .....set ApplyRefQtyInfo=##class(web.DHCOPBillOERefundQty).GetRefundQTY(OEORI, "")
    .....set ApplyRefQty=+$p(ApplyRefQtyInfo,"^",2)
    .....if (+ApplyRefQty'=0) do
    ......set returnqty=ApplyRefQty-OEORDExecQty
    ......set myRefSum=returnqty*myPatUnitPrice
    ......if (+myRefSum<0) set myRefSum=0
    ......set myRefSum=$fn(myRefSum+0.0000001,"",2)
 	......set Executflag=1
    ...if (myAppFlag="Y") do
    ....set myAppDesc="审批"
    ...else  do
    ....set myAppDesc="未审批"
    ...//+2017-07-06 ZhYW 
    ...if (isAppRepFlag="Y") do
    ....//取退费金额
    ....set isRefAll=##class(web.udhcOPRefund).IsAllRefundRepPart(OEORI)
    ....if (isRefAll=1) set returnqty=0	    //部分退费
    ....else  set returnqty=1	            //全部退费
    ....set myRefSum=..GetRepPartRefAmt(OEORI, PBO)
    ...//
    ...//增加审批的其他选项
    ...if ((+selflag=1)&&(+Executflag=1)) do
    ....set myAuditSelFlag="1"
    ...set ItemStat=$p($g(^OEORD(+OEORI,"I",+$p(OEORI,"||",2),1)),"^",13)      //医嘱状态
    ...set TItemStat=$p(^OEC("OSTAT",ItemStat),"^",2)
    ...set ItemStatCode=$p(^OEC("OSTAT",ItemStat),"^",1)
    ...set TLinkOrder=$p($g(^OEORD(+OEORI,"I",+$p(OEORI,"||",2),11)),"^",39)   //关联医嘱指针
    ...set TOrdDate=$p($g(^OEORD(+OEORI,"I",+$p(OEORI,"||",2),1)),"^",9)       //医嘱日期
    ...set TOrdDate=##class(websys.Conversions).DateLogicalToHtml(TOrdDate)
    ...set TDepID=$p($g(^OEORD(+OEORI,"I",+$p(OEORI,"||",2),1)),"^",3)         //科室
    ...set TDepDesc=$s((+TDepID'=0):$p($g(^CTLOC(TDepID)),"^",2),1:"")
    ...if (TDepDesc["-") set TDepDesc=$p(TDepDesc,"-",2)
    ...do OutputRowFAPI
    
    quit $$$OK
    
OutputRowFAPI
    set Data=$lb(selflag,ArcimDesc,PatSum,OrderBillQty,recdepdesc,returnqty,OEORI,Executflag,myRefSum,ReceipRowid,myRecLocdesc,ind,myBillNo,myAppFlag,myAppDesc,myAuditCheckDis,myAuditSelFlag,myPayDTime,TItemStat,TLinkOrder,TOrdDate,TDepDesc,OEORDExecQty,PBO,UnAuditOrdItem,ItemStatCode,packUom)
    set ^CacheTemp(repid,ind)=Data
    set ind=ind+1
    quit
}

/// 查询支付点
Query ReadRcptList(APIRowID As %String) As websys.Query(ROWSPEC = "Arg1:%String,Arg2:%String,Arg3:%String,Arg4:%String,Arg5:%String")
{
}

/// d ##class(%ResultSet).RunQuery("web.udhcOPRefund","ReadRcptList","58")
ClassMethod ReadRcptListExecute(ByRef qHandle As %Binary, APIRowID As %String) As %Status
{
    set repid=$I(^CacheTemp)
    set ind=1
    set qHandle=$lb(0,repid,0)
	if (APIRowID="")   quit $$$OK

    d ResetVariablesRL
    
    s myIdx=0
    
    s conRowid=0
    f  s conRowid=$o(^DHCINVPRTCAPi(0,"APINVDR",APIRowID,conRowid)) q:(conRowid="")  d
    .s myIdx=myIdx+1
    .d ResetVariablesRL
    .s INVPRTRowid=$p(^DHCINVPRTCAP(conRowid),"^",1)                    ;ACP_INVPRT_DR
    .s flag=$p($g(^DHCINVPRT(INVPRTRowid)),"^",8)
    .s PRTAcount=$p($g(^DHCINVPRT(INVPRTRowid)),"^",1)
    .s PRTPatPay=$p($g(^DHCINVPRT(INVPRTRowid)),"^",16)
    .s PRTUsr=$p($g(^DHCINVPRT(INVPRTRowid)),"^",21)
    .s UserNo=$p($g(^SSU("SSUSR",PRTUsr)),"^",1)
    .s myPrtDate=$p($g(^DHCINVPRT(INVPRTRowid)),"^",5)
    .s myPrtTime=$p($g(^DHCINVPRT(INVPRTRowid)),"^",20)
    .s Verifyflag=$p($g(^DHCINVPRT(INVPRTRowid)),"^",22)
    .s reportsDR=$p($g(^DHCINVPRT(INVPRTRowid)),"^",6)
    .s myINVPayMDR=""
    .;只有一种支付方式，如果多种需要修改；
    .s myINVPMSub=$o(^DHCINVPRT(INVPRTRowid,"P",0))
    .i (myINVPMSub'="") d
    ..s myINVPayMDR=$p($g(^DHCINVPRT(INVPRTRowid,"P",myINVPMSub)),"^",1)
    ..s myAccPLDR=$p($g(^DHCINVPRT(INVPRTRowid,"P",myINVPMSub)),"^",8)      ;IPM_AccPL_DR
    ..q:(myAccPLDR="")
    ..s myBillNo=$p(^DHCACD("AccM",+myAccPLDR,"AccPL",$p(myAccPLDR,"||",2)),"^",4)      ;
    ..s myRecLocDR=$p(^DHCACD("AccM",+myAccPLDR,"AccPL",$p(myAccPLDR,"||",2)),"^",10)   ;
    ..s myRecLocdesc=$p($g(^CTLOC(myRecLocDR)),"^",2)
    ..s myPayCode=$p(^CT("CTPM",myINVPayMDR),"^",1)
    ..;卡支付
    ..i (myPayCode="CPP") d
    ...s myAccRowID=+myAccPLDR
    ...s myCashPMDR=$o(^CT("CTPM",0,"Code","CASH",0))       ;现金支付
    ...s myAccFlag=$p(^DHCACD("AccM",myAccRowID),"^",13)
    ...s myPFlag=$p($g(^DHCINVPRT(INVPRTRowid)),"^",3)      ;PRT_INVPrintFlag
    ...s myINVNo=$p($g(^DHCINVPRT(INVPRTRowid)),"^",14)     ;PRT_inv
    ...i ((myPFlag="P")&&(myINVNo="")) d
    ....s myColPFlag=1          ;已经集中打印了
    ...q:(myAccFlag="N")        ;账户正常退出，否则转为现金支付；
    ...s myINVPayMDR=myCashPMDR
    ..d OutputRowRL
        
    quit $$$OK
    
OutputRowRL
    set Data=$lb(myIdx,selflag,myBillNo,UserNo,myPrtDate,myPrtTime,myTolSum,myOEOrdRStr,myInsType,myRefundSum,myRecLocdesc, INVPRTRowid)
    set ^CacheTemp(repid,ind)=Data
    set ind=ind+1
    quit
ResetVariablesRL
    set (selflag, myBillNo, UserNo, myPrtDate, myPrtTime, myTolSum, myOEOrdRStr,myInsType, myRefundSum, myRecLocdesc)=""
    set selflag=0
    quit
}

ClassMethod UpdateOrderStat(Orderstr As %String, uUser As %String)
{
    s StopOrderstr=$p(Orderstr,"!",1)
    s ToBillOrderstr=$p(Orderstr,"!",2)
    s updatedate="",updatetime=""
    s updatedate=$p($h,",",1)
    s updatetime=$p($h,",",2)
    s CTPCPDR=$p(^SSU("SSUSR",uUser),"^",9) 
    i (StopOrderstr'="")  d
    .s stopnum=$l(StopOrderstr,"^")
    .f num=1:1:stopnum  d
    ..s StopOrderid=$p(StopOrderstr,"^",num)
    ..s $p(^OEORD(+StopOrderid,"I",$p(StopOrderid,"||",2),1),"^",13)="4"
    ..s $p(^OEORD(+StopOrderid,"I",$p(StopOrderid,"||",2),2),"^",15)=updatetime
    ..s $p(^OEORD(+StopOrderid,"I",$p(StopOrderid,"||",2),3),"^",34)=updatedate
    ..s $p(^OEORD(+StopOrderid,"I",$p(StopOrderid,"||",2),3),"^",29)=CTPCPDR
    ..s $p(^OEORD(+StopOrderid,"I",$p(StopOrderid,"||",2),8),"^",12)=uUser
    i (ToBillOrderstr'="")  d
    .s tobillnum=$l(ToBillOrderstr,"^")
    .f tbnum=1:1:tobillnum  d
    ..s ToBillOrderid=$p(ToBillOrderstr,"^",tbnum)
    ..s $p(^OEORD(+ToBillOrderid,"I",$p(ToBillOrderid,"||",2),3),"^",5)="TB"
    q 0
}

/// 通过患者登记号找患者的发票，倒排序   by xin
ClassMethod GetInvPrtByPatient(PatientID)
{
	k mPlist
	q:(PatientID="") ""
	s PatientID=##Class(web.UDHCJFBaseCommon).regnocon(PatientID)
	s PapmiDr=$o(^PAPERi("PAPMI_PatNo",$$ALPHAUP^SSUTIL4(PatientID),""))
	q:PapmiDr="" ""
	s PatName=$p($g(^PAPER(PapmiDr,"ALL")),"^",1)
  
	s admtype="" 
	f  s admtype=$o(^PAPERdr(PapmiDr,"ADM",admtype)) q:admtype=""  d
	.q:admtype="I"
	.s admdr="" 
	.f  s admdr=$o(^PAPERdr(PapmiDr,"ADM",admtype,admdr)) q:admdr=""  d
	..s bcidr="" 
	..f  s bcidr=$o(^DHCBCI(0,"ADM",admdr,bcidr)) q:bcidr=""  d
	...s Invdr=$p($g(^DHCBCI(bcidr)),"^",1)
	...q:Invdr=""
	...s InvNo=$p($g(^DHCINVPRT(Invdr)),"^",14)
	...s Prtflag=$p($g(^DHCINVPRT(Invdr)),"^",8)
	...s PrtFairType=$p($g(^DHCINVPRT(Invdr)),"^",34)
	...q:Prtflag'="N"
	...q:PrtFairType'="F"
	...s Prtdate=$p($g(^DHCINVPRT(Invdr)),"^",5)
	...s mPlist(Invdr)=InvNo
	s retstr=""
	s ind="" 
	f  s ind=$o(mPlist(ind),-1) q:ind=""  d
	. i retstr="" d 
	..  s retstr=ind_$c(1)_mPlist(ind) 
	.e  d
	.. s retstr=retstr_"^"_ind_$c(1)_mPlist(ind)
	q retstr_"!"_PatName
}

ClassMethod getPrtFairType(invprtRowid As %String)
{
    q:invprtRowid=""
    q:$d(^DHCINVPRT(invprtRowid))=0
    s fairType = $p(^DHCINVPRT(invprtRowid),"^",34)
    q fairType
}

/// Creator:yyx
/// CreateDate:2010-09-01
/// Function  :取发票的非医保支付的支付方式及金额，并返回多种支付方式标志
///            dhc_invpaymode中的ipm_note3记录为1时为病人的非医保支付方式
/// w ##class(web.udhcOPRefund).GetPrtPayMode(177258)
ClassMethod GetPrtPayMode(PrtRowID)
{
    s ChildSub=0,PayModeNum=0,PayModeList=""
    f  s ChildSub=$o(^DHCINVPRT(PrtRowID,"P",ChildSub)) q:ChildSub=""  d
    .s PayMode=$p(^DHCINVPRT(PrtRowID,"P",ChildSub),"^",1)
    .s PayModeDesc=$p(^CT("CTPM",PayMode),"^",2)
    .s PayModeCode=$p(^CT("CTPM",PayMode),"^",1)
    .s PayAmt=$p(^DHCINVPRT(PrtRowID,"P",ChildSub),"^",3)
    .s PayNote=$p(^DHCINVPRT(PrtRowID,"P",ChildSub),"^",12)
    .i PayNote="1" s PayModeNum=PayModeNum+1
    .;q:+$g(PayAmt)=0
    .i PayModeList'="" s PayModeList=PayModeList_"&"_PayModeDesc_" "_PayAmt_"  "_PayModeCode
    .e  s PayModeList=PayModeDesc_" "_PayAmt_"  "_PayModeCode
    s PayModeList=PayModeNum_"&"_PayModeList
    q PayModeList
}

/// Creator: yyx
/// CreateDate: 2010-09-16
/// Function: 取医嘱的审核标志
ClassMethod GetOrderVerifyFlag(OERowID)
{
    s VeriFlag="N"
    s DHCOEORDRowID=$o(^DHCORDItem(0,OERowID,""))
    i DHCOEORDRowID'="" d
    .s RefundAuditStatus=$p(^DHCORDItem(DHCOEORDRowID,1),"^",1)
    .i RefundAuditStatus="A" s VeriFlag="Y"
    q VeriFlag
}

/// Lid
/// 2010-03-23
/// 根据发票Rowid获取该发票的审核标志
ClassMethod GetInvAuditFlag(invPrtRowid)
{
	q:(invPrtRowid="") ""
    q:'$d(^DHCINVPRT(invPrtRowid)) -1 ;发票不存在
    s AuditFlag=$p(^DHCINVPRT(invPrtRowid),"^",22) ;PRT_AllowRefund
    q $g(AuditFlag)
}

/// Lid
/// 2010-03-23
/// 撤销审核功能
/// 入参:PrtRowid:发票Rowid,TabFlag:发票类型(PRT:门诊收费发票,API:集中打印发票)
/// 出参:-1:发票已退费，不能撤销审核
///     0:撤销审核成功
///     非0(不含-1):撤销审核失败
/// w ##class(web.udhcOPRefund).CancelAudi("220725", "PRT", 5816)
ClassMethod CancelAudi(PrtRowid, TabFlag, user As %String = "")
{
	s ^TMP("CancelAudi")=PrtRowid_","_TabFlag_","_user
    i TabFlag="" s TabFlag="PRT"
    s rtn=0
    i TabFlag="PRT" d
    .s rtn=$$CancelAudiSingleInv(PrtRowid,user)
    e  d
    .s PCInv=0
    .f  s PCInv=$o(^DHCINVPRTCAPi(0,"APINVDR",PrtRowid,PCInv))  q:((PCInv="")!(+rtn'=0))  d
    ..s InvPrtDr=$p($g(^DHCINVPRTCAP(PCInv)),"^",1)
    ..s rtn=$$CancelAudiSingleInv(InvPrtDr,user)
    q rtn
    
CancelAudiSingleInv(invPrtRowid,user)
    ;判断该发票是否已经退费
    s invFlag=$p(^DHCINVPRT(invPrtRowid),"^",8)
    q:invFlag'="N" -1      ;不为N，说明此发票已退费，不能撤销审核  
    q:$d(^DHCINVPRT(invPrtRowid,"OA"))=0 -2
	
	//+2017-06-23 ZhYW 物资材料已退回不能撤销
    s refQty=0
    s ioasub=0
    f  s ioasub=$o(^DHCINVPRT(invPrtRowid,"OA",ioasub)) q:((ioasub="")||(refQty'=0))  d
    .s orderid=$p(^DHCINVPRT(invPrtRowid,"OA",ioasub),"^",1)
    .q:orderid=""
    .s matDispGrant=##class(web.DHCOPBillRefundRequest).CheckIsMatDispGrant(orderid)
	.q:(matDispGrant'="Y")
	.s dispStat=##class(web.DHCOPBillRefundRequest).CheckMatDisp(orderid)
	.q:(dispStat=0)
    .s refQtyInfo=##class(web.DHCOPBillOERefundQty).GetRefundQTY(orderid, invPrtRowid)
    .s refQty=+$p(refQtyInfo,"^",2)
    q:(refQty'=0) -3
    //
    
 	ts
 	
    s ioasub=0
    f  s ioasub=$o(^DHCINVPRT(invPrtRowid,"OA",ioasub)) q:(ioasub="")||(rtn'=0)  d
    .s orderid=$p(^DHCINVPRT(invPrtRowid,"OA",ioasub),"^",1)
    .q:(orderid="")
    .s ret=##class(web.DHCOPBillRefundRequestNew).UpdateOEItmFAuth(orderid, user, "", "", "C")
    .s rtn=##class(web.DHCOPBillOERefundQty).Insert(orderid, 0, user,"")
    .i rtn=0 d
    ..s INVRefRowID=invPrtRowid_"||"_ioasub
    ..s STPara=orderid_"^"_INVRefRowID
    ..s rtn=##class(web.DHCSTINTERFACE).DelOutPhRequset(STPara)
    
	;删除发票审核表里的审核记录
    i $d(^DHCINVPRT(invPrtRowid,"OA")) d
    .s sub=0
    .f  s sub=$o(^DHCINVPRT(invPrtRowid,"OA",sub)) quit:sub=""  d
    ..s oeori=$p(^DHCINVPRT(invPrtRowid,"OA",sub),"^",1)
    ..s refundRepPart=$p(^DHCINVPRT(invPrtRowid,"OA",sub),"^",19)
    ..s isAppRepFlag=##class(web.UDHCJFPRICE).IsAppRepOrder(oeori)
	..i (isAppRepFlag="Y")&&(refundRepPart'="") d
    ...s err=##Class(web.DHCAPPInterface).SetExaReqFlag(oeori,refundRepPart,"N")
    ...s rtn=err
    .q:rtn
    .&sql(DELETE FROM DHC_INVOEItemAuthorize WHERE PRT_IOA_ParRef=:invPrtRowid)
    .k ^DHCINVPRT(invPrtRowid,"OA",0)
    .s rtn=SQLCODE
    i (+rtn) tro  q rtn
    
	;把发票表的审核标志均置为null
    &sql(
    	UPDATE DHC_InvPrt
    	SET prt_allowrefund=null, prt_allrefunduser=null,prt_allrefunddate=null,prt_allrefundtime=null,PRT_RefundReason=null, PRT_RefAuditLoc_DR=null
    	WHERE %ID = :invPrtRowid
    )
	set rtn=SQLCODE
    i (+rtn) tro  q rtn_"^"_$g(%msg)
    
	if ($tl>0) tc
    
    q rtn
}

/// do ##class(%ResultSet).RunQuery("web.udhcOPRefund","QryPrtInvListByAccPInv","71")
Query QryPrtInvListByAccPInv(APIRowID As %String, LangId As %String = "") As websys.Query(ROWSPEC = "TPrtDate:%String:支付日期,TPrtTime:%String:支付时间,TPatNo:%String:登记号,TPatName:%String:患者姓名,TDepDesc:%String:科室,TPrtAcount:%Float:费用总额,TPrtDiscAmt:%Float:折扣金额,TPrtPayorAmt:%Float:记账金额,TPrtPatAmt:%Float:自付金额,TPaymStr:%String:支付方式")
{
}

ClassMethod QryPrtInvListByAccPInvExecute(ByRef qHandle As %Binary, APIRowID As %String, LangId As %String = "") As %Status
{
    set repid=$I(^CacheTemp)
    set qHandle=$lb(0,repid,0)
    set ind=1 
    if (+APIRowID=0) quit $$$OK
    
    if (LangId="")&&($d(%session)) {
	    set LangId=%session.Get("LOGON.LANGID")
	}
	
    set ACPRowId=0
    while($o(^DHCINVPRTCAPi(0,"APINVDR",APIRowID,ACPRowId))) {
	    set ACPRowId=$o(^DHCINVPRTCAPi(0,"APINVDR",APIRowID,ACPRowId))
	   	set PrtRowId=$p(^DHCINVPRTCAP(ACPRowId),"^",1)
	    set PrtData=$g(^DHCINVPRT(PrtRowId))
	    set PrtDate=$p(PrtData,"^",5)
	    set PrtTime=$p(PrtData,"^",20)
	 	set PrtDate=##class(websys.Conversions).DateLogicalToHtml(PrtDate)
	    set PrtTime=##class(websys.Conversions).TimeLogicalToHtml(PrtTime, 1)
	    set UserDR=$p(PrtData,"^",21)
	    set UserName=$p(^SSU("SSUSR",UserDR),"^",2)
	    set UserName=##class(User.SSUser).GetTranByDesc("SSUSRName", UserName, LangId)
	    set PrtAcount=$p(PrtData,"^",1)
	    set PrtAcount=$fn(PrtAcount,"",2)
	    set PrtDiscAmt=$p(PrtData,"^",7)
		set PrtDiscAmt=$fn(PrtDiscAmt,"",2)
		set PrtPayorAmt=$p(PrtData,"^",18)
		set PrtPayorAmt=$fn(PrtPayorAmt,"",2)
		set PrtPatAmt=$p($g(PrtData),"^",16)
	    set PrtPatAmt=$fn(PrtPatAmt,"",2)
	    set Papmi=$p(PrtData,"^",15)
	    set PatName=$p(^PAPER(Papmi,"ALL"),"^",1)
	    set PatNo=$p(^PAPER(Papmi,"PAT",1),"^",1)
	    set AdmDept=""
	    set BillConInv=0
	    while($o(^DHCBCI(0,"INV",PrtRowId,BillConInv))) {
		    set BillConInv=$o(^DHCBCI(0,"INV",PrtRowId,BillConInv))
		    set ConData=$g(^DHCBCI(BillConInv))
		    set Adm=$p(^DHCBCI(BillConInv),"^",3)
		    set DeptDR=$p(^PAADM(Adm),"^",4)
		    set DeptDesc=$s((+DeptDR'=0):$p($g(^CTLOC(DeptDR)),"^",2),1:"")
		    set DeptDesc=##class(User.CTLoc).GetTranByDesc("CTLOCDesc", DeptDesc, LangId)
		    set AdmDept=$s((AdmDept=""):DeptDesc,1:(AdmDept_", "_DeptDesc))
		}
		set PaymStr=""
		set PaymSub=0
		while($o(^DHCINVPRT(PrtRowId,"P",PaymSub))) {
			set PaymSub=$o(^DHCINVPRT(PrtRowId,"P",PaymSub))
			set PaymData=$g(^DHCINVPRT(PrtRowId,"P",PaymSub))
			continue:(PaymData="")
			set PaymDR=$p(PaymData,"^",1)
			continue:(+PaymDR=0)
			set PaymDesc=$p($g(^CT("CTPM",PaymDR)),"^",2)
			set PaymDesc=##class(User.CTPayMode).GetTranByDesc("CTPMDesc", PaymDesc, LangId)
			set PaymAmt=$p(PaymData,"^",3)
			set PaymAmt=$fn(PaymAmt,"",2)
			set PaymStr=$s((PaymStr=""):(PaymDesc_"："_PaymAmt),1:(PaymStr_" "_PaymDesc_"："_PaymAmt))
		}
	    do OutputPrtInvList
	}

    quit $$$OK
OutputPrtInvList
    set Data=$lb(PrtDate,PrtTime,PatNo,PatName,AdmDept,PrtAcount,PrtDiscAmt,PrtPayorAmt,PrtPatAmt,PaymStr)
    set ^CacheTemp(repid,ind)=Data
    set ind=ind+1
    quit
}

/// Creator: ZHL
/// CreatDate: 2009-07-03
/// Description: 在退费审核界面调用,使可以审核集中打印的发票.
/// Input: InvNo:发票号
/// Return: InvDr^InvType 发票表id^发票类型(AccPInv,集中打印发票;Inv,结算发票)    
ClassMethod GetInvIdByNo(itmjs As %Library.String = "", itmjsex As %Library.String = "", ReceipNO As %String)
{
    s ret=0
    s ReceipNO=ReceipNO
    s ReceipNO=$ZConvert(ReceipNO, "U")
    i ($d(^DHCINVPRT(0,"INV",ReceipNO))=0)&($d(^DHCINVPRTAPi(0,"INVNo",ReceipNO))=0)  s ret=-1_"^"    
    
    i $d(^DHCINVPRT(0,"INV",ReceipNO))  d
    .s INVPRTRowid=$o(^DHCINVPRT(0,"INV",ReceipNO,"")) 
    .s ret=INVPRTRowid_"^PRT"
    
    i $d(^DHCINVPRTAPi(0,"INVNo",ReceipNO))  d
    .s INVPRTRowid=$o(^DHCINVPRTAPi(0,"INVNo",ReceipNO,""))
    .s ret=INVPRTRowid_"^API"
    
    s retval=itmjs_"('"_$ZCVT(ret,"O","JS")_"');"
    i itmjsex'="""" s retval=retval_itmjsex_"('"_$ZCVT(ret,"O","JS")_"');"
    &javascript<#(retval)#>
    q ret
}

/// Creator: Lid
/// CreatDate: 2012-04-16
/// Description: 判断医嘱是否是关联医嘱
/// Return: 1:关联医嘱，0:非关联医嘱
ClassMethod CheckSeqFlag(OEORIDR1, OEORIDR2)
{
    Set OEORIOEORIDR=$p(^OEORD(+OEORIDR1,"I",$p(OEORIDR1,"||",2),11),"^",39)
    Quit:(OEORIOEORIDR'="")&(OEORIOEORIDR=OEORIDR2) 1
    Set OEORIOEORIDR=$p(^OEORD(+OEORIDR2,"I",$p(OEORIDR2,"||",2),11),"^",39)
    Quit:(OEORIOEORIDR'="")&(OEORIOEORIDR=OEORIDR1) 1
    Quit 0
}

/// Creator: yyx
/// CreateDate: 2014-01-16
/// Description: 根据医嘱rowid取最新的发票rowid
/// Debug: w ##class(web.udhcOPRefund).GetPrtRowIDByOERowID(OERowID)
ClassMethod GetPrtRowIDByOERowID(OERowID)
{
	s InvRowID=""
    s PBRowID=$o(^DHCPBi(0,"OEORI",OERowID,""),-1)
    i (PBRowID'="") d
    .s BCIRowID=$o(^DHCBCI(0,"Bill",PBRowID,""),-1)
    .i (BCIRowID'="") d
    ..s InvRowID=$p(^DHCBCI(BCIRowID),"^",1)
    q InvRowID
}

/// Creator: chenxi
/// CreateDate: 2015-02-14
/// Description: 判断发票退费时退费数量是否大于收费数量
/// Debug: w ##class(web.udhcOPRefund).CheckOENegativeNum(PrtRowid)
ClassMethod CheckOENegativeNum(PrtRowid)
{
    q:(+PrtRowid=0) 0
    s ErrNum=0
    s ConRowid=0
    f  s ConRowid=$o(^DHCBCI(0,"INV",PrtRowid,ConRowid)) q:ConRowid=""  d
    .s BillNo=$p($g(^DHCBCI(ConRowid)),"^",2)
    .s PBOChildsub=0  
    .f  s PBOChildsub=$o(^DHCPB(BillNo,"O",PBOChildsub)) q:PBOChildsub=""  d
    ..s Arcim=$p(^DHCPB(BillNo,"O",PBOChildsub),"^",3) ;DHC_PatBillOrder->PBO_ARCIM_DR
    ..s ArcItmCateDR=$p(^ARCIM(+Arcim,$p(Arcim,"||",2),1),"^",10)   ;医嘱子类
    ..s OEORI=$p(^DHCPB(BillNo,"O",PBOChildsub),"^",4) ;DHC_PatBillOrder->PBO_OEORI_DR
    ..s Billreturnqty=+$p(^DHCPB(BillNo,"O",PBOChildsub),"^",6)     ;PBO_RefundQty
    ..s OrderBillQty=$p(^DHCPB(BillNo,"O",PBOChildsub),"^",5)       ;PBO_BillQty
    ..s ReturnQty=0
    ..s Confac=##class(web.DHCBillCommon).GetUomConvFactor(Arcim, OEORI)
    ..s PatSum=$p(^DHCPB(BillNo,"O",PBOChildsub),"^",11)
    ..s ARCCATRowid=$p(^ARCIM(+Arcim,$p(Arcim,"||",2),1),"^",10)
    ..s ARCOrdType=$p(^ARC("IC",ARCCATRowid),"^",7)
    ..s myPrescNo="", myCMFlag=""
    ..i (ARCOrdType="R")  d
    ...s Executflag=##class(web.UDHCOEORDOPIF).CheckPhDispRet(OEORI)
    ...s ReturnQty=+$p(^DHCPB(BillNo,"O",PBOChildsub),"^",6)        ;PBO_RefundQty
    ...s ReturnQty=+$p($g(^OEORD(+OEORI,"I",+$p(OEORI,"||",2),3)),"^",23) ;医嘱退药数量
    ...s ReturnQty=##class(web.DHCOutPhReturn).GetRetOrdQty(OEORI,PrtRowid)
    ...//modify 2013-07-18 chenxi 配液中心药品取药房接口程序
    ...s OEFlag=$p($g(^OEORD(+OEORI,"I",$p(OEORI,"||",2),"DHC")),"^",16)
    ...i (OEFlag="Y")  d
    ....s PackQty=##class(web.DHCSTPIVAOUTCOMMON).GetPIVAOutValidQty(OEORI)
    ....s PackQty=PackQty/Confac
    ....s ReturnQty=OrderBillQty-PackQty
    ...s OrderBillQty=(OrderBillQty+Billreturnqty)/Confac
    ...//
    ...s ReturnQty=ReturnQty/Confac
    ..e  d
    ...s OrderBillQty=(OrderBillQty+Billreturnqty)
    ...s OrdStat=$p(^OEORD(+OEORI,"I",$p(OEORI,"||",2),1),"^",13)
    ...s OrdStatCode=$p(^OEC("OSTAT",OrdStat),"^",1)
    ...i (OrdStatCode="E") d
    ...e  d
    ....s OEORDExecQty=##class(web.UDHCOEORDOPIF).ReadOEORDExecQty(PrtRowid, OEORI, "")
    ...s ApplyRefQtyInfo=##class(web.DHCOPBillOERefundQty).GetRefundQTY(OEORI, "")
    ...s ApplyRefQty=+$p(ApplyRefQtyInfo,"^",2)
    ...i (+ApplyRefQty'=0) d
    ....s ReturnQty=ApplyRefQty
    ..i (ReturnQty>OrderBillQty)  d
    ...s ErrNum=ErrNum+1
    
    q ErrNum
}

ClassMethod GetInvStatFlag(ReceiptID As %String) As %String
{
    s StayFlag=""
    q:(+ReceiptID=0) StayFlag
    s StayFlag=$p($g(^DHCINVPRT(ReceiptID)),"^",44)
    q StayFlag
}

/// 根据医嘱rowid获取退费金额--新版检查申请单
/// 规则：
/// 		1.判断是否走折扣
/// 		2.如果没有走折扣, 直接取退费部位的价格
/// 		3.如果走折扣，需按中间表的折扣从小到大取退费金额（第一个退费部位的价格乘最后一个系数，第二个退费部位的价格乘倒数第二个折扣系数...依次递推）
/// 		4.部位加收医嘱的计算规则:部位退费时部位加收必须退费（部位加收一定不能有折扣）
/// 		5.后处理医嘱的计算规则：后处理医嘱只能与最后一个部位一起退费，即如果有部位没有退费，它就不能退费.
///  w ##class(web.udhcOPRefund).GetRepPartRefAmt("653||2","272775||1")
/// w ##class(web.udhcOPRefund).GetRepPartRefAmt("653||2","272775||1","319||1||1")
ClassMethod GetRepPartRefAmt(oeitm As %String, pbo As %String, arReqItmIdStr As %String = "") As %String
{
	set refAmt=0
	set (price,discPrice,insPrice,patPrice)=0
	set adm=$p(^OEORD(+oeitm),"^",1)
	set pattype=$p($g(^PAADM(adm,1)),"^",6)
	set instype=$p($g(^PAADM(adm,1)),"^",7)
	set arcim=$p(^OEORD(+oeitm,"I",$p(oeitm,"||",2),1),"^",2)
	set sttdate=$p(^OEORD(+oeitm,"I",$p(oeitm,"||",2),1),"^",9)
	set oeprice=""
	;取Adm保存的挂号优惠类别
	set RCDRowID=$p($g(^PAADM(adm,"DHC")),"^",25)
    set HospID=##class(web.UDHCHospitalGroup).GetHospitalByAdm(adm)
	set regLoc=""
	set itmPriceExpStr=RCDRowID_"^"_oeitm_"^"_""_"^"_adm_"^"_regLoc_"^"_""
	
	;调用接口取退费部位rowid
	set repPartIdStr=##class(web.DHCAPPInterface).GetReqPartID(oeitm)
	;+2018-11-17 ZhYW arReqItmIdStr不为空时，以arReqItmIdStr取部位
	if (arReqItmIdStr'="") {
		set repPartIdStr=##class(web.udhcOPRefund).GetRepPartIdStr(arReqItmIdStr)
	}
	;是否是部分退费
	set isRefundAll=..IsAllRefundRepPart(oeitm)
	;是否走折扣
	set isDiscRtn=..IsBillByDisc(oeitm,pbo)
	set isDisc=$p(isDiscRtn,"!",1)
	if (isDisc=0){
		;
		set itmDr=0
		for  set itmDr=$o(^DHCAPREPTA(0,"OrdTar",oeitm,itmDr)) quit:itmDr=""  do
		.set artiDr=0
		.for  set artiDr=$o(^DHCAPREPTA(0,"OrdTar",oeitm,itmDr,artiDr)) quit:artiDr=""  do
		..set tmp=$g(^DHCAPREPTA(artiDr))
		..set pointer=$p(tmp,"^",1)	;ARTI_Pointer
		..set type=$p(tmp,"^",3)	;ARTI_Type
		..set disc=$p(tmp,"^",4)	;ARTI_Disc
		..set itm=$p(tmp,"^",5)	;ARTI_Tar_Dr
		..set qty=$p(tmp,"^",8)	;ARTI_Qty
		..set billStatus=$p(tmp,"^",9) ;账单状态
		..set pboDr=$p(tmp,"^",12)
		..quit:(pboDr'=pbo)
		..quit:(type="P")&&(("^"_repPartIdStr_"^")'[("^"_pointer_"^"))
		..quit:((type="D")&&(isRefundAll=1))
		..quit:(billStatus'="P")
		..set err=##CLASS(UDHCJFPRICE).GetItmPrice(itm,sttdate,instype,pattype,oeprice,HospID,itmPriceExpStr)
		..set err0=($p(err,"^",1)*disc)_"^"_($p(err,"^",2)*disc)_"^"_($p(err,"^",3)*disc)_"^"_($p(err,"^",4)*disc)
		..set price=$p(err0,"^",1)*qty+price
		..set discPrice=$p(err0,"^",2)*qty+discPrice
		..set insPrice=$p(err0,"^",3)*qty+insPrice
		..set patPrice=$p(err0,"^",4)*qty+patPrice
		;
		set refAmt=patPrice
		;
	}else{
		;1.取部位退费金额
		set discStr=$p(isDiscRtn,"!",2)
		;
		set index=0
		set len=$l(repPartIdStr,"^")
		for i=1:1:len do
		.set partDr=$p(repPartIdStr,"^",i)
		.quit:((partDr="")||(+partDr=0))
		.set artiDr=0
		.for  set artiDr=$o(^DHCAPREPTA(0,"OrdPointer",oeitm,partDr,artiDr)) quit:(artiDr="")  do
		..set tmp=$g(^DHCAPREPTA(artiDr))
		..set pointer=$p(tmp,"^",1)	    ;ARTI_Pointer
		..set type=$p(tmp,"^",3)	    ;ARTI_Type
		..set disc=$p(tmp,"^",4)	    ;ARTI_Disc
		..set itm=$p(tmp,"^",5)	        ;ARTI_Tar_Dr
		..set qty=$p(tmp,"^",8)	        ;ARTI_Qty
		..set billStatus=$p(tmp,"^",9)  ;账单状态
		..set pboDr=$p(tmp,"^",12)
		..quit:(pboDr'=pbo)
		..quit:(billStatus'="P")
		..set err=##CLASS(UDHCJFPRICE).GetItmPrice(itm,sttdate,instype,pattype,oeprice,HospID,itmPriceExpStr)
		..;判断医嘱项目是否走折扣
		..set isBascPriceFlag=..IsBascPrice(arcim,itm,sttdate)
		..if (isBascPriceFlag=1) do
		...set index=index+1	                ;一个部位在中间表有可能有多条记录
		...set factDisc=$p(discStr,"^",index)	;第一个退费部位的价格乘最后一个系数，第二个退费部位的价格乘倒数第二个折扣系数...依次递推
		...set disc=factDisc
		..set err0=($p(err,"^",1)*disc)_"^"_($p(err,"^",2)*disc)_"^"_($p(err,"^",3)*disc)_"^"_($p(err,"^",4)*disc)
		..set price=$p(err0,"^",1)*qty+price
		..set discPrice=$p(err0,"^",2)*qty+discPrice
		..set insPrice=$p(err0,"^",3)*qty+insPrice
		..set patPrice=$p(err0,"^",4)*qty+patPrice
		
		;2.取后处理医嘱退费金额
		set itmDr=0
		for  set itmDr=$o(^DHCAPREPTA(0,"OrdTar",oeitm,itmDr)) quit:itmDr=""  do
		.set artiDr=0
		.for  set artiDr=$o(^DHCAPREPTA(0,"OrdTar",oeitm,itmDr,artiDr)) quit:artiDr=""  do
		..set tmp=$g(^DHCAPREPTA(artiDr))
		..set pointer=$p(tmp,"^",1)	   ;ARTI_Pointer
		..set type=$p(tmp,"^",3)	   ;ARTI_Type
		..set disc=$p(tmp,"^",4)	   ;ARTI_Disc
		..set itm=$p(tmp,"^",5)	       ;ARTI_Tar_Dr
		..set qty=$p(tmp,"^",8)	       ;ARTI_Qty
		..set billStatus=$p(tmp,"^",9) ;账单状态
		..set pboDr=$p(tmp,"^",12)
		..quit:(pboDr'=pbo)
		..quit:(type'="D")
		..quit:(isRefundAll=1)
		..quit:(billStatus'="P")
		..set err=##CLASS(UDHCJFPRICE).GetItmPrice(itm,sttdate,instype,pattype,oeprice,HospID,itmPriceExpStr)
		..set err0=($p(err,"^",1)*disc)_"^"_($p(err,"^",2)*disc)_"^"_($p(err,"^",3)*disc)_"^"_($p(err,"^",4)*disc)
		..set price=$p(err0,"^",1)*qty+price
		..set discPrice=$p(err0,"^",2)*qty+discPrice
		..set insPrice=$p(err0,"^",3)*qty+insPrice
		..set patPrice=$p(err0,"^",4)*qty+patPrice
		;
		set refAmt=patPrice	
	}
	quit refAmt
}

/// 验证医嘱项对应得收费项目是否打折
/// 0:不打折，1：打折
/// w ##class(web.udhcOPRefund).IsBascPrice("14560||1",5648,"2017-04-01")
ClassMethod IsBascPrice(arcim, itm, stDate)
{
	set stDate=##class(websys.Conversions).DateHtmlToLogical(stDate)
	set isBasePriceFlag=0
	set execuDate=""
	for  set execuDate=$o(^DHCOLT(0,"ARTTA",arcim,itm,execuDate)) quit:(execuDate="")  do
	.quit:(execuDate>stDate)
	.set oltDr=""
	.for  set oltDr=$o(^DHCOLT(0,"ARTTA",arcim,itm,execuDate,oltDr)) quit:(oltDr="")  do
	..set endDate=$p(^DHCOLT(oltDr),"^",5)
	..if (endDate="") set endDate=+$h+10000
	..quit:(endDate<stDate)
	..set bascPriceFlag=$p(^DHCOLT(oltDr),"^",8)
	..if (bascPriceFlag="Y") do
	...set isBasePriceFlag=1
	;
	quit isBasePriceFlag
}

/// 验证是否走折扣
/// 0_$c(2)_"":没有走折扣
/// 1_$c(2)_0.3^0.8^1:走折扣
/// w ##class(web.udhcOPRefund).IsBillByDisc("668||3","250220||1")
ClassMethod IsBillByDisc(oeitm, pbo)
{
	kill PLISTDISC
	
	set index=0
	set itmDr=0
	for  set itmDr=$o(^DHCAPREPTA(0,"OrdTar",oeitm,itmDr)) quit:(itmDr="")  do
	.set artiDr=0
	.for  set artiDr=$o(^DHCAPREPTA(0,"OrdTar",oeitm,itmDr,artiDr)) quit:(artiDr="")  do
	..set tmp=$g(^DHCAPREPTA(artiDr))
	..set pointer=$p(tmp,"^",1)	;ARTI_Pointer
	..set type=$p(tmp,"^",3)	;ARTI_Type
	..set disc=$p(tmp,"^",4)
	..set billStatus=$p(tmp,"^",9) ;账单状态
	..set pboDr=$p(tmp,"^",12)
	..set partFlag=$p(tmp,"^",14)
	..quit:(pbo'=pboDr)
	..quit:(type'="P")
	..quit:(partFlag'=1) ;1：部位医嘱，其他：非部分医嘱
	..quit:(billStatus'="P")
	..;if (+disc'=1) do
	..;.set discFlag=1
	..set index=index+1
	..set PLISTDISC(disc,index)=""
	;
	set discStr="", discFlag=0
	set disc=""
	for  set disc=$o(PLISTDISC(disc)) quit:(disc="")  do
	.set index=""
	.for  set index=$o(PLISTDISC(disc,index)) quit:(index="")  do
	..if ((+disc'=1)&&(discFlag=0)) do
	...set discFlag=1
	..if (discStr="") set discStr=disc
	..else  set discStr=discStr_"^"_disc
	;
	quit discFlag_"!"_discStr
}

/// 验证是否全部退费
/// 0:全部退费，1:部分退费,空：非新版申请但医嘱
/// w ##class(web.udhcOPRefund).IsAllRefundRepPart()
ClassMethod IsAllRefundRepPart(oeitm)
{
	kill PLIST1, PLIST2
	set isAppRepFlag=##class(web.UDHCJFPRICE).IsAppRepOrder(oeitm)
	quit:(isAppRepFlag'="Y") 0
	;调用接口取退费部位rowid
	set repPartIdStr=##Class(web.DHCAPPInterface).GetReqPartID(oeitm)
	for i=1:1:$l(repPartIdStr,"^") do
	.set tmp=$p(repPartIdStr,"^",i)
	.quit:(tmp="")
	.set PLIST1(tmp)=""
	
	set itmDr=0
	for  set itmDr=$o(^DHCAPREPTA(0,"OrdTar",oeitm,itmDr)) quit:(itmDr="")  do
	.set artiDr=0
	.for  set artiDr=$o(^DHCAPREPTA(0,"OrdTar",oeitm,itmDr,artiDr)) quit:(artiDr="")  do
	..set tmp=$g(^DHCAPREPTA(artiDr))
	..set pointer=$p(tmp,"^",1)	   ;ARTI_Pointer
	..set type=$p(tmp,"^",3)	   ;ARTI_Type
	..set billStatus=$p(tmp,"^",9) ;账单状态
	..quit:(type'="P")
	..quit:(billStatus'="P")
	..set PLIST2(pointer)=""
	
	set str1="", str2=""
	set val=""
	for  set val=$o(PLIST1(val)) quit:(val="")  do
	.if (str1="") set str1=val
	.else  set str1=str1_"^"_val
	
	set val=""
	for  set val=$o(PLIST2(val)) quit:(val="")  do
	.if (str2="") set str2=val
	.else  set str2=str2_"^"_val
	
	if ("^"_str1_"^")=("^"_str2_"^") set rtn=0
	else  set rtn=1
	
	quit rtn
}

/// 0:部分执行或未执行，1：全部执行
/// w ##class(web.udhcOPRefund).IsPartExecut("1217||3")
ClassMethod IsPartExecut(oeitm)
{
	set flag=-1
	set myORESub=0
	for  set myORESub=$o(^OEORD(+oeitm,"I",$p(oeitm,"||",2), "X",myORESub))  quit:((myORESub="")||(flag=0))  d
	.set myExStDate=$p(^OEORD(+oeitm,"I",$p(oeitm,"||",2),"X",myORESub),"^",1)	            ;OEORE_ExStDate
	.set myExStTime=$p(^OEORD(+oeitm,"I",$p(oeitm,"||",2),"X",myORESub),"^",2)	            ;OEORE_ExStTime
	.set myOrdStatusDR=$p(^OEORD(+oeitm,"I",$p(oeitm,"||",2),"X",myORESub,"BILL"),"^",1)		;OEORE_OrderStatus_DR
	.;quit:(myOrdStatusDR="")
	.set statCode=$s((+myOrdStatusDR'=0):$p(^OEC("OSTAT",myOrdStatusDR),"^",1),1:"")
	.if (statCode="E") do
	..set flag=1
	.else  do
	..set flag=0
	;
	if (flag=-1) set flag=0
	;
	quit flag
}

/// -1:无执行记录,0:全部未执行,1:部分执行,2:全部执行
/// w ##class(web.udhcOPRefund).IsPartExecut2("1217||3")
ClassMethod IsPartExecut2(oeitm)
{
	set isAppRepFlag=##class(web.UDHCJFPRICE).IsAppRepOrder(oeitm)
	quit:(isAppRepFlag="Y") ..IsAppRepPartExecut(oeitm)
	
	set flag=-1
	set execFalg=0
	set noExecFlag=0
	set myORESub=0
	for  set myORESub=$o(^OEORD(+oeitm,"I",$p(oeitm,"||",2),"X",myORESub))  quit:(myORESub="")  do
	.set myExStDate=$p(^OEORD(+oeitm,"I",$p(oeitm,"||",2),"X",myORESub),"^",1)	                ;OEORE_ExStDate
	.set myExStTime=$p(^OEORD(+oeitm,"I",$p(oeitm,"||",2),"X",myORESub),"^",2)	                ;OEORE_ExStTime
	.set myOrdStatusDR=$p(^OEORD(+oeitm,"I",$p(oeitm,"||",2),"X",myORESub,"BILL"),"^",1)		;OEORE_OrderStatus_DR
	.;quit:(myOrdStatusDR="")
	.set statCode=$s((+myOrdStatusDR'=0):$p(^OEC("OSTAT",myOrdStatusDR),"^",1),1:"")
	.if (statCode="E") do
	..set execFalg=1
	.else  do
	..set noExecFlag=1
	;
	if (execFalg=0)&&(noExecFlag=1)	set flag=0	;全部未执行
	if (execFalg=1)&&(noExecFlag=1) set flag=1	;部分执行
	if (execFalg=1)&&(noExecFlag=0) set flag=2	;全部执行
	
	;
	quit flag
}

/// Creator：   ZhYW
/// CreatDate： 2017-09-08
/// Description: 更新检查申请部位表退费申请状态
/// Input:      OE_OrdItem.RowID, arReqItmIdStr: DHC_AppRepPart.RowID
/// Output：    
/// Return: 0:"更新成功", <>0:"更新失败"
/// Debug: w ##class(web.udhcOPRefund).UpdateExaReqFlag("653||2", "")
ClassMethod UpdateExaReqFlag(oeitm As %String, arReqItmIdStr As %String) As %String
{
	set rtn=0
	quit:(oeitm="") rtn
	set arReqID=$o(^DHCAPREP(0,"OrdItem",oeitm,""))         // 检查申请ID
	quit:(arReqID="") rtn
	set sub=$o(^DHCAPREP(0,"OrdItem",oeitm,arReqID,""))     // 检查申请医嘱项Child
	quit:(sub="") rtn
	
	set upd2NArReqItmIdStr=""
	set child="0"
	for  set child=$o(^DHCAPREP(arReqID,"AR",sub,"PA",child)) quit:(child="")  do
	.set exeStatus=$p(^DHCAPREP(arReqID,"AR",sub,"PA",child),"^",2)
	.quit:(exeStatus="D")
	.set reqFlag=$p(^DHCAPREP(arReqID,"AR",sub,"PA",child),"^",6)    // 退费申请
	.quit:(reqFlag'="Y")
	.set arReqItmId=arReqID_"||"_sub_"||"_child
	.if (("!!"_arReqItmIdStr_"!!") '[ ("!!"_arReqItmId_"!!")) do
	..set upd2NArReqItmIdStr=$s((upd2NArReqItmIdStr=""):arReqItmId,1:(upd2NArReqItmIdStr_"!!"_arReqItmId))

	ts
	
	if (arReqItmIdStr'="") do
	.set rtn=##class(web.DHCAPPInterface).SetExaReqFlag(oeitm, arReqItmIdStr, "Y")
	if ((+rtn=0)&&(upd2NArReqItmIdStr'="")) do
	.set rtn=##class(web.DHCAPPInterface).SetExaReqFlag(oeitm, upd2NArReqItmIdStr, "N")

	if (rtn=0) do
	.tc
	else  do
	.tro

	quit rtn
}

/// Creator: ZhYW
/// CreatDate: 2018-12-27
/// Description: 根据账单医嘱RowId和发票RowId取退药金额
/// Input: pboRowId:DHC_PatBillOrder.RowId, prtRowId:DHC_INVPRT.RowId
/// Return: 
/// Debug: w ##class(web.udhcOPRefund).GetPHRefundSum("3482340||2", 7507860)
ClassMethod GetPHRefundSum(pboRowId As %String, prtRowId As %String) As %String
{
	set refundSum=0
	quit:($l("||")'=2) refundSum
	
	set pb=+$p(pboRowId,"||",1)
	set pbo=+$p(pboRowId,"||",2)
	
	set pbd=0
	for  set pbd=$o(^DHCPB(pb,"O",pbo,"D",pbd)) quit:(pbd="")  do
	.set pbdInfo=$g(^DHCPB(pb,"O",pbo,"D",pbd))
	.quit:(pbdInfo="")
	.set pbdBillQty=$p(pbdInfo,"^",5)
	.quit:(+pbdBillQty'>0)
	.set dspbId=$p(pbdInfo,"^",27)
	.quit:(dspbId="")
	.set price=$p(pbdInfo,"^",4)        //PBD_UnitPrice
	.set patPrice=$p(pbdInfo,"^",20)    //PBD_PatPrice
	.set retQty=##class(PHA.FACE.OUT.Com).GetPrtPhdRetQty(prtRowId, dspbId)
	.set refundSum=$i(refundSum,(patPrice*retQty))
	
	quit ##class(web.UDHCJFBILL).round(refundSum)
}

/// Creator: ZhYW 
/// CreatDate: 2018-11-17
/// Description: 取新版检查申请单部位
/// Input: arReqItmIdStr: DHC_AppRepPart.AR_RowID串(多个间以"!!"分割)
/// Return: repPartIdStr: DHC_AppRepPart.AR_Part_Dr(多个间以"^"分割)
/// Debug: w ##class(web.udhcOPRefund).GetRepPartIdStr("319||1||1")
ClassMethod GetRepPartIdStr(arReqItmIdStr As %String) As %String
{
	set repPartIdStr=""
	for i=1:1:$l(arReqItmIdStr,"!!") do
	.set arReqItmId=$p(arReqItmIdStr,"!!",i)
	.quit:($l(arReqItmId,"||")'=3)
	.set tmp=$g(^DHCAPREP(+arReqItmId,"AR",+$p(arReqItmId,"||",2),"PA",+$p(arReqItmId,"||",3)))
	.quit:(tmp="")
	.set repPartId=$p(tmp,"^",1)
	.set repPartIdStr=$s((repPartIdStr=""):repPartId,1:(repPartIdStr_"^"_repPartId))
	
	quit repPartIdStr
}

/// Creator: ZhYW
/// CreatDate: 2019-01-15
/// Description: 新版检查申请单执行状态
/// Input: oeitm:OE_OrdItem.RowId
/// Output: 
/// Table: DHC_AppRepTarItm
/// Return: -1:非新版检查申请单或无执行记录, 0:全部未执行, 1:部分执行, 2:全部执行
/// Debug: w ##class(web.udhcOPRefund).IsAppRepPartExecut("357||5")
ClassMethod IsAppRepPartExecut(oeitm As %String) As %String
{
	set flag=-1
	set isAppRepFlag=##class(web.UDHCJFPRICE).IsAppRepOrder(oeitm)
	quit:(isAppRepFlag'="Y") flag
	
	set execFalg=0
	set noExecFlag=0
	
	set itmDr=0
	for  set itmDr=$o(^DHCAPREPTA(0,"OrdTar",oeitm,itmDr)) quit:(itmDr="")  do
	.set artiDr=0
	.for  set artiDr=$o(^DHCAPREPTA(0,"OrdTar",oeitm,itmDr,artiDr)) quit:(artiDr="")  do
	..set tmp=$g(^DHCAPREPTA(artiDr))
	..quit:(tmp="")
	..set billed=$p(tmp,"^",9)         //ARTI_Billed
	..quit:(billed'="P")           
	..set ordExec=$p(tmp,"^",10)	   //ARTI_OrdExec
	..set statDR=$p(^OEORD(+ordExec,"I",$p(ordExec,"||",2),"X",$p(ordExec,"||",3),"BILL"),"^",1)   //OEORE_OrderStatus_DR
	..set statCode=$s((+statDR'=0):$p(^OEC("OSTAT",statDR),"^",1),1:"")
	..if (statCode="E") do
	...set execFalg=1
	..else  do
	...set noExecFlag=1
	
	if ((execFalg=0)&&(noExecFlag=1)) set flag=0	//全部未执行
	if ((execFalg=1)&&(noExecFlag=1)) set flag=1	//部分执行
	if ((execFalg=1)&&(noExecFlag=0)) set flag=2	//全部执行
	
	quit flag
}

}
