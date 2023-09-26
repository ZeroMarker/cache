Class web.UDHCPrescript Extends DHCDoc.Util.RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// w ##class(web.UDHCPrescript).GetCardBalance(5200)
ClassMethod GetCardBalance(EpisodeID)
{
	s cardbalance=0
	s patstatus=##class(web.DHCBillInterface).GetAdmSourceByAdm(EpisodeID)
	s PapmiDR=$p($g(^PAADM(EpisodeID)),"^",1)
	s cfRowid="" for  s cfRowid=$o(^DHCCARDi("CF",0,"PAPMIDR",PapmiDR,cfRowid)) q:cfRowid=""  d
	.s ActiveFlag=$p(^DHCCARD("CF",cfRowid),"^",10)
	.q:ActiveFlag'="N"
	.s CFCardNo=$p(^DHCCARD("CF",cfRowid),"^",2)
	i $g(CFCardNo)'="" d
	.s rtn=##class(web.UDHCAccManageCLS).getaccinfofromcardno(CFCardNo,"0")
	.i +rtn=0 s cardbalance=$p(rtn,"^",5)
	q cardbalance
}

ClassMethod GetMRAdmByEpisodeID(EpisodeID As %String) As %String
{
	q:EpisodeID="" ""
	q $p($g(^PAADM(EpisodeID)),"^",61)
}

ClassMethod GetSystemDateTime() As %String
{
	
	s sysdate=$zd(+$h,3)
	s systime=..%ZT(..%SysTime(),1)
	q sysdate_"  "_systime
}

// w ##class(web.UDHCPrescript).CheckOrdByDsp("5281||3")

ClassMethod CheckOrdByDsp(OEORIRowid)
{
	Q:OEORIRowid="" ""
	s dis=0,flag=0
	f  s dis=$O(^DHCOEDISQTY(0,"OEORI",OEORIRowid,dis)) Q:dis=""  d
	.s dstatus=$p(^DHCOEDISQTY(dis),"^",7)
	.i dstatus="R" s flag=1
	
	Q flag
}

// w ##class(web.UDHCPrescript).GetOrdPackQtyByDsp("5281||3")

ClassMethod GetOrdPackQtyByDsp(OEORIRowid)
{
	Q:OEORIRowid="" ""
	//s dis=$O(^DHCOEDISQTY(0,"OEORI",OEORIRowid,0))
	//q:dis="" ""
	//q:'$d(^DHCOEDISQTY(dis)) ""
	s Pqty=$p($g(^OEORD(+OEORIRowid,"I",$p(OEORIRowid,"||",2),9)),"^",4)
	;如果没有填数量则自动计算数量
	i (+Pqty=0)  d
	.s DoseUnitID=$p($g(^OEORD(+OEORIRowid,"I",$p(OEORIRowid,"||",2),2)),"^",3) 
	.s ArcimId=$p($g(^OEORD(+OEORIRowid,"I",$p(OEORIRowid,"||",2),1)),"^",2) 
	.s drgformId=$P(^ARCIM(+ArcimId,$P(ArcimId,"||",2),1),"^",12)
	.s DoseQty=$p($g(^OEORD(+OEORIRowid,"I",$p(OEORIRowid,"||",2),2)),"^",1) 
	.s Qty=##Class(web.DHCDocOrderEntry).CalDose(DoseUnitID,drgformId,DoseQty)
	.s Pqty=0
	.s PHFreqDR=$p($g(^OEORD(+OEORIRowid,"I",$p(OEORIRowid,"||",2),2)),"^",4)
	.s DuraDR=$p($g(^OEORD(+OEORIRowid,"I",$p(OEORIRowid,"||",2),2)),"^",6)
	.i DuraDR'="" s Pqty=+Qty*$P(^PHCFR(PHFreqDR),"^",2)*$P(^PHCDU(DuraDR),"^",2)
	b ;1
	s DspConfirmQty=0
	s dis=0  f  s dis=$O(^DHCOEDISQTY(0,"OEORI",OEORIRowid,dis)) Q:dis=""  d
	.s dstatus=$p(^DHCOEDISQTY(dis),"^",7)
	.i dstatus="R" d
	..s qtyuom=$p(^DHCOEDISQTY(dis),"^",6)
	..s OrdItemArcim=$p($g(^OEORD(+OEORIRowid,"I",$p(OEORIRowid,"||",2),1)),"^",2)
	..s BillingUOMDR=$p($g(^ARCIM(+OrdItemArcim,1,8)),"^",14)
	..s fac=##class(web.DHCST.Common.UtilCommon).UOMFac(BillingUOMDR,qtyuom)
	..s dconfirmqty=$p(^DHCOEDISQTY(dis),"^",11)
	..s dconfirmqty=dconfirmqty/fac
	..s DspConfirmQty=DspConfirmQty+dconfirmqty
	
	Q Pqty-DspConfirmQty
}

// w ##class(web.UDHCPrescript).GetArcimInsuCode(4334,^a0)

ClassMethod GetArcimInsuCode(ArcimRowid As %String) As %String
{
    q:$d(^DHCOLT(0,"ARTTA",ArcimRowid))=0 ""	
	s TariDr=$o(^DHCOLT(0,"ARTTA",ArcimRowid,""))
	q:$o(^DHCOLT(0,"ARTTA",ArcimRowid,TariDr))'="" ""
	s insucode=##class(web.DHCINSUPort).GetInusFlagandCode(TariDr)
	q:insucode="" ""
	q $p(insucode,"^",1)
}

ClassMethod GetBillTypeByPrescNo(EpisodeID As %String, PrescNo As %String) As %String
{
    Quit:EpisodeID="" ""
    set OrderRowId=$o(^OEORD(0,"Adm",EpisodeID,""))
	Quit:OrderRowId="" ""
	Quit:'$d(^OEORD(0,"PrescNo",PrescNo,OrderRowId)) ""	
	set Childsub=0,AdmReason=""
	for {
		set Childsub=$o(^OEORD(0,"PrescNo",PrescNo,OrderRowId,Childsub)) q:Childsub=""
		set BBExtCode=$p(^OEORD(OrderRowId,"I",Childsub,11),"^",18)
 		set AdmReason=$p($g(^PAC("ADMREA",BBExtCode)),"^",2)
 		q
	}
	Quit AdmReason
}

ClassMethod SetOrdItemPrintFlag(OrdItemList As %String) As %String
{
    for i=1:1:$l(OrdItemList,"^") do
    .s OrdItem=$p(OrdItemList,"^",i)
    .s ^DHCDOCOEORDPRINTFLAG(OrdItem)="Y"
    q 0
}

// w ##class(web.UDHCPrescript).GetOrdItemInfo(6516,^a0(6516))

ClassMethod GetOrdItemInfo(EpisodeID As %String, OrdItemList As %String) As %String
{
	;s ^a0(EpisodeID)=OrdItemList
	s PapmiDR=$p($g(^PAADM(EpisodeID)),"^",1)
	s AdmType=$p($g(^PAADM(EpisodeID)),"^",2)
	s AdmDep=$p($g(^PAADM(EpisodeID)),"^",4)
	s AdmDate=$p($g(^PAADM(EpisodeID)),"^",6)
	s AdmReason=$p($g(^PAADM(EpisodeID,1)),"^",7)
	i AdmDep'="" s HospId=$p($g(^CTLOC(AdmDep)),"^",22)
	s PAADMRegConDisDR=$P($G(^PAADM(EpisodeID,"DHC")),"^",25)
	k ^CacheTemp("DHCDirectOrdItem",$j)
	s OtherSum=0
    for i=1:1:$l(OrdItemList,"^") do
    .s OrdItem=$p(OrdItemList,"^",i)
    .s ord=+OrdItem,chl=$p(OrdItem,"||",2)
	.q:'$d(^OEORD(ord,"I",chl))
	.s Sttdate=$p(^OEORD(ord,"I",chl,1),"^",9)
	.s doctor=$p(^OEORD(ord,"I",chl,1),"^",11)
	.s:$g(doctor)'="" doctor=$p(^CTPCP(doctor,1),"^",2)
	.s:$g(doctor)="" doctor=""
	.s OrdStatus=$p($g(^OEORD(ord,"I",chl,1)),"^",13)
	.s:$g(OrdStatus)'="" OrdStatus=$p(^OEC("OSTAT",OrdStatus),"^",1)  ;医嘱状态
	.s:$g(OrdStatus)="" OrdStatus=$g(OrdStatus)
	.s Billed=$p($g(^OEORD(ord,"I",chl,3)),"^",5)
	.;Q:Billed="P"      ;已经收费则退出
	.Q:(OrdStatus="I") ;未激活
	.Q:(OrdStatus="E") ;执行
	.Q:(OrdStatus="U") ;未核实
	.Q:(OrdStatus="D")
	.s ArcimId=$p($g(^OEORD(ord,"I",chl,1)),"^",2)
	.s SubCategory=$p($g(^ARCIM(+ArcimId,$p(ArcimId,"||",2),1)),"^",10)
	.s OrdcatDesc="",OrdcatDR=""
	.s:SubCategory'="" OrdcatDR=$p(^ARC("IC",SubCategory),"^",8)
	.s:OrdcatDR'="" OrdcatDesc=$p($g(^OEC("ORCAT",OrdcatDR)),"^",2)
	.s ArcimDesc=$p(^ARCIM(+ArcimId,1,1),"^",2)
	.s GenericName=##class(web.UDHCJFCOMMON).GetDrugCommonNameByArcimId(ArcimId)
	.i GenericName'="" s ArcimDesc=GenericName
	.s ItemCatDR=$p(^ARCIM(+ArcimId,1,1),"^",10)
	.s OrderRecDepRowid=$P($G(^OEORD(ord,"I",chl,3)),"^",6) ;OEORI_RecDep_DR
	.s OrderType=$P(^ARC("IC",ItemCatDR),"^",7)
	.i OrderType="R" d
	..s BillPrice=$p($g(^OEORD(ord,"I",chl,2)),"^",13)
	..s PackQty=..GetOrdPackQtyByDsp(OrdItem)
	.e  d
	..;批次价
	..s EstStr=PAADMRegConDisDR_"^"_ord_"||"_chl_"^"_""_"^"_EpisodeID_"^"_OrderRecDepRowid
	..;s retPrice=##Class(web.UDHCJFPRICE).GetOrderPrice("",AdmReason,ArcimId,AdmDate,"","","","",HospId,EstStr)
	..s ordstr3=$g(^OEORD(ord,"I",chl,3))
	..s OEORIPrice=$p(ordstr3,"^",25)
	..s EpissubtypeId=$P($g(^PAADM(EpisodeID,1)),"^",6)
	..s retPrice=##class(web.UDHCJFPRICE).GetOrderPrice(EpissubtypeId,AdmReason,ArcimId ,AdmDate, "", "","", OEORIPrice,"",EstStr)
	..s BillPrice=$p(retPrice,"^",1)
	..s PackQty=$p($g(^OEORD(ord,"I",chl,9)),"^",4)
	..i PackQty="" s PackQty=$p($g(^OEORD(ord,"I",chl,1)),"^",12)
	.s OEORIDR=$p($g(^OEORD(ord,"I",chl,11)),"^",39)
	.s ExamFlag=##class(web.DHCDocOrderCommon).GetItemServiceFlag(ArcimId)
	.i ExamFlag=1 s OrderType="E"
	.;1:"【药品】",2:"【检验】",3:"【检查】",4:"【其他】"	
	.s OrderTypeNum=$case(OrderType,"R":1,"L":2,"E":3,:4)
	.//关联医嘱插入的材料费和
	.s flag=0
	.i OrderTypeNum=4 d
	..i OEORIDR'="" d
	...s flag=1
	...i Billed'="P" s OtherSum=BillPrice*PackQty+OtherSum
	..s LabCL=$p($g(^OEORD(ord,"I",chl,"DHC")),"^",22)
	..i LabCL'="" d
	...s flag=1
	...i Billed'="P" s OtherSum=BillPrice*PackQty+OtherSum
	.Q:flag=1
	.s RecDepDR=$p($g(^OEORD(ord,"I",chl,3)),"^",6)
	.s ^CacheTemp("DHCDirectOrdItem",$j,OrderTypeNum,ord_"||"_chl)=ArcimDesc_"^"_PackQty_"^"_RecDepDR_"^"_Billed_"^"_BillPrice
	b ;
	s cardbalance=0
	s patstatus=##class(web.DHCBillInterface).GetAdmSourceByAdm(EpisodeID)
	i patstatus="" s patstatus=0
	s cfRowid="" for  s cfRowid=$o(^DHCCARDi("CF",0,"PAPMIDR",PapmiDR,cfRowid)) q:cfRowid=""  d
	.s ActiveFlag=$p(^DHCCARD("CF",cfRowid),"^",10)
	.q:ActiveFlag'="N"
	.s CFCardNo=$p(^DHCCARD("CF",cfRowid),"^",2)
	i $g(CFCardNo)'="" d
	.s rtn=##class(web.UDHCAccManageCLS).getaccinfofromcardno(CFCardNo,"0")
	.i +rtn=0 s cardbalance=$p(rtn,"^",5)
	
	s TypeOrderStr="",OrderSum=0,OrderSumR=0,OrderDesc=""
    s rtype="0"  for  s rtype=$O(^CacheTemp("DHCDirectOrdItem",$j,rtype)) q:rtype=""  d
    .s OrderStr=""
    .s orditem=""  for  s orditem=$O(^CacheTemp("DHCDirectOrdItem",$j,rtype,orditem)) q:orditem=""  d
    ..s s1=^CacheTemp("DHCDirectOrdItem",$j,rtype,orditem)
    ..s OrderRecLoc="",CTLOCAddress="",RecLocStr="",CSZDK=""
	..s OrderName=$p(s1,"^",1),OrderPackQty=$p(s1,"^",2)
	..s OrderBilled=$p(s1,"^",4),OrderPrice=$p(s1,"^",5)
	..s OrderRecLocDR=$p(s1,"^",3)
	..i OrderRecLocDR'="" d
	...s OrderRecLoc=$p(^CTLOC(OrderRecLocDR),"^",2)
	...i OrderRecLoc["-" s OrderRecLoc=$p(OrderRecLoc,"-",2)
	...s CTLOCAddress=$g(^CTLOC(OrderRecLocDR,"ADDR",1))
	...;i (OrderRecLocDR=121)||(OrderRecLocDR=181) s CSZDK="请先划价再交费"
	..i OrderBilled'="P" s OrderSum=OrderPrice*OrderPackQty+OrderSum
    ..i rtype=1 d
    ...i OrderBilled'="P" s OrderSumR=OrderPrice*OrderPackQty+OrderSumR
    ...i patstatus=0 d
    ....s OrderName="请到一楼门急诊药房交方取药",OrderBill=""   //"[已收费]"
	....i OrderBilled'="P" s OrderName="请先到建卡结算中心交费再到一楼门急诊药房交方取药"
	...e  s OrderName="请先到建卡结算中心交费再到一楼门急诊药房交方取药",OrderBill=""
	...;i OrderStr="" s OrderStr1=OrderName_$c(5)_CTLOCAddress_$c(5)_$g(OrderBill)   //VB打印
	...;e  s OrderStr=OrderStr_$c(4)_OrderName_$c(5)_CTLOCAddress_$c(5)_$g(OrderBill)
	...b ;i OrderStr="",OrderBill'="P" s OrderStr=OrderName_$c(5)_CTLOCAddress_$c(5)_$g(OrderBill)
	...i OrderStr="" s OrderStr1="  "_OrderName_" "_$g(OrderBill)  //_" "_OrderRecLoc_"("_CTLOCAddress_")"   //xml打印
	...i OrderStr="",OrderBill'="P" s OrderStr="  "_OrderName  //_" "_OrderRecLoc_"("_CTLOCAddress_")"
	..e   d
	...s OrderBill=$case(OrderBilled,"P":"已收费",:"未收费")
	...i rtype=2 d
	....i AdmType="O" s RecLocDesc="一楼采血中心"
	....i AdmType="E" s RecLocDesc="一楼急诊输液室"
	....;s admloc=$p(^PAADM(EpisodeID),"^",4)
	....;i admloc=454 s RecLocDesc="儿科输液室"
	....s LisRecLocDesc=RecLocDesc
	....s ArcimDr=$p(^OEORD(+orditem,"I",$p(orditem,"||",2),1),"^",2)
	....s GetReportInfo=$g(^ARCIM(+ArcimDr,$p(ArcimDr,"||",2),"RB",1))  //检验取报告信息
	....s PressingInfo=$p($g(^ARCIM(+ArcimDr,$p(ArcimDr,"||",2),9)),"^",14)  //检验注意事项
	....Set OESpecRid=$O(^OEORD(+orditem,"I",$p(orditem,"||",2),"SPEC",0))
	....i OESpecRid'="" d
	.....Set specimen=$p(^OEORD(+orditem,"I",$p(orditem,"||",2),"SPEC",OESpecRid),"^",1)
	.....i specimen'="" s specdesc=$p($g(^TTAB("SPEC",specimen)),"\",1)
	.....i $g(specdesc)'="" s OrderName=OrderName_"" //     "_$g(specdesc)
	....i OrderStr="" s OrderStr="  "_OrderName  _"  ("_OrderPrice_"元*"_OrderPackQty_")  "_$g(specdesc)_"   "_OrderBill_"  "_$g(PressingInfo)_"  "_$g(GetReportInfo)  //_"  "_RecLocStr      //xml打印
	....e  s OrderStr=OrderStr_$c(3)_"  "_OrderName   _"   ("_OrderPrice_"元*"_OrderPackQty_")  "_$g(specdesc)_"   "_OrderBill_"  "_$g(PressingInfo)_"  "_$g(GetReportInfo)   //_"  "_RecLocStr
	...i (rtype=3)||(rtype=4) d
	....s RecLocStr=CTLOCAddress_OrderRecLoc
	....i rtype=4 s RecLocStr="",CSZDK=""
	....i OrderStr="" s OrderStr="  "_OrderName  _"  ("_OrderPrice_"元*"_OrderPackQty_")"_"   "_OrderBill_"  "_RecLocStr_"  "_$g(CSZDK)      //xml打印
	....e  s OrderStr=OrderStr_$c(3)_"  "_OrderName   _"   ("_OrderPrice_"元*"_OrderPackQty_")"_"  "_OrderBill_"  "_RecLocStr_"  "_$g(CSZDK)
	..s OrderType=$case(rtype,1:"【药品】",2:"【检验】",3:"【检查】",4:"【其他】")
	.;b ;111111
	.i rtype=1 d
	..i OrderSumR'=0 s OrderType=OrderType  //_" (药费"_$fn(OrderSumR,"",2)_"元)"
	..i OrderStr="" s OrderStr=OrderStr1   //_"  药费为"_$fn(OrderSumR,"",2)_"元"   不显示药费
	.i rtype=2 s OrderType=OrderType_" 采血地点:"_LisRecLocDesc  //检验显示采血位置
	.;i TypeOrderStr="" s TypeOrderStr=OrderType_$c(3)_OrderStr	
	.;e  s TypeOrderStr=TypeOrderStr_$c(2)_OrderType_$c(3)_OrderStr	
	.i TypeOrderStr="" s TypeOrderStr=OrderType_$c(2)_OrderStr	
	.e  s TypeOrderStr=TypeOrderStr_$c(1)_OrderType_$c(2)_OrderStr
	
	s OtherSumStr=""
	i OrderSum'=0 s OrderSum=$fn(OrderSum,"",2)+OtherSum
	if patstatus=0 do
	.i OtherSum'=0 s OtherSumStr="(含部分其他费用："_OtherSum_"元) "
	.i (OrderSum+OtherSum)<cardbalance d
	..s OrderDesc="请直接到相关科室刷卡消费就诊。"
	..i OrderSum'=0 s OrderDesc="本次未收费用为："_OrderSum_"元，"_OtherSumStr_OrderDesc
	.e  d
	..s OrderDesc="请到建卡结算中心充值交费后再到相应科室就诊。"
	..i OrderSum'=0 d
	...s OrderDesc1="本次未收费用为："_OrderSum_"元，"_OtherSumStr
	...s OrderDesc=OrderDesc1_$c(3)_OrderDesc_"应续缴金额为："_(OrderSum-cardbalance)_"元。"
	else  do
	.s OrderDesc="请到建卡结算中心交费后再到相应科室就诊。"
	s TypeOrderStr=TypeOrderStr_$c(1)_""_$c(2)_OrderDesc
	
	k ^CacheTemp("DHCDirectOrdItem",$j)
	q:(TypeOrderStr="") ""
	q TypeOrderStr
}

// w ##class(web.UDHCPrescript).GetAllOrdItemInfo(6035)

ClassMethod GetAllOrdItemInfo(EpisodeID As %String) As %String
{
	s PapmiDR=$p($g(^PAADM(EpisodeID)),"^",1)
	s AdmType=$p($g(^PAADM(EpisodeID)),"^",2)
	s AdmDep=$p($g(^PAADM(EpisodeID)),"^",4)
	s AdmDate=$p($g(^PAADM(EpisodeID)),"^",6)
	s AdmReason=$p($g(^PAADM(EpisodeID,1)),"^",7)
	s PAADMRegConDisDR=$P($G(^PAADM(EpisodeID,"DHC")),"^",25)
	i AdmDep'="" s HospId=$p($g(^CTLOC(AdmDep)),"^",22)
	k ^CacheTemp("DHCDirectOrdItem",$j)
    s ord="" s ord=$o(^OEORD(0,"Adm",EpisodeID,ord)) q:ord="" -1	
    s chl=0 f  s chl=$o(^OEORD(ord,"I",chl)) q:chl=""  d          ;
	.q:'$d(^OEORD(ord,"I",chl))
	.s Sttdate=$p(^OEORD(ord,"I",chl,1),"^",9)
	.s doctor=$p(^OEORD(ord,"I",chl,1),"^",11)
	.s:$g(doctor)'="" doctor=$p(^CTPCP(doctor,1),"^",2)
	.s:$g(doctor)="" doctor=""
	.s OrdStatus=$p($g(^OEORD(ord,"I",chl,1)),"^",13)
	.s:$g(OrdStatus)'="" OrdStatus=$p(^OEC("OSTAT",OrdStatus),"^",1)  ;医嘱状态
	.s:$g(OrdStatus)="" OrdStatus=$g(OrdStatus)
	.s Billed=$p($g(^OEORD(ord,"I",chl,3)),"^",5)
	.;Q:Billed="P"      ;已经收费则退出
	.Q:(OrdStatus="I") ;未激活
	.Q:(OrdStatus="E") ;执行
	.Q:(OrdStatus="U") ;未核实
	.Q:(OrdStatus="D")
	.s ArcimId=$p($g(^OEORD(ord,"I",chl,1)),"^",2)	
	.s SubCategory=$p($g(^ARCIM(+ArcimId,$p(ArcimId,"||",2),1)),"^",10)
	.s OrdcatDesc="",OrdcatDR=""
	.s:SubCategory'="" OrdcatDR=$p(^ARC("IC",SubCategory),"^",8)
	.s:OrdcatDR'="" OrdcatDesc=$p($g(^OEC("ORCAT",OrdcatDR)),"^",2)
	.;q:(OrdcatDesc["材料")||(OrdcatDesc["诊疗费")
	.;Q:(CMSubCategory'[("^"_SubCategory_"^"))&&(CMFlag="Y")
	.;Q:(CMSubCategory[("^"_SubCategory_"^"))&&(CMFlag="N")
	.;s ArcimType=##class(web.DHCOPAdmReg).GetRegArcimBillSubType(ArcimId)
	.;q:ArcimType'="Other"
	.s ArcimDesc=$p(^ARCIM(+ArcimId,1,1),"^",2)
	.s GenericName=##class(web.UDHCJFCOMMON).GetDrugCommonNameByArcimId(ArcimId)
	.i GenericName'="" s ArcimDesc=GenericName
	.s RecDepDR=$p($g(^OEORD(ord,"I",chl,3)),"^",6)
	.s ItemCatDR=$p(^ARCIM(+ArcimId,1,1),"^",10)
	.s OrderType=$P(^ARC("IC",ItemCatDR),"^",7)
	.i OrderType="R" d
	..s BillPrice=$p($g(^OEORD(ord,"I",chl,2)),"^",13)
	..s PackQty=..GetOrdPackQtyByDsp(ord_"||"_chl)
	.e  d
	..;批次价
	..s OrderRecDepRowid=$P($G(^OEORD(ord,"I",chl,3)),"^",6)
	..s ExpStr=PAADMRegConDisDR_"^"_ord_"||"_chl_"^"_""_"^"_EpisodeID_"^"_RecDepDR
	..s retPrice=##Class(web.UDHCJFPRICE).GetOrderPrice("",AdmReason,ArcimId,AdmDate,"","","","",HospId,ExpStr)
	..s BillPrice=$p(retPrice,"^",1)
	..s PackQty=$p($g(^OEORD(ord,"I",chl,9)),"^",4)
	..i PackQty="" s PackQty=$p($g(^OEORD(ord,"I",chl,1)),"^",12)
	.s OrderTypeNum=""
	.i OrderType="R" s OrderTypeNum=1
	.;s OrderTypeNum=$case(OrderType,"R":1,"L":2,"N":3,:4)
	.s OrdCatDR=$P(^ARC("IC",ItemCatDR),"^",8)
	.;i OrderTypeNum>2 s OrderTypeNum=$case(OrdCatDR,1:4,3:3,:5)
	.i OrdCatDR=3 s OrderTypeNum=3
	.i OrdCatDR=4 s OrderTypeNum=2
	.i $g(OrderTypeNum)="" s OrderTypeNum=4
	
	.s ^CacheTemp("DHCDirectOrdItem",$j,OrderTypeNum,ord_"||"_chl)=ArcimDesc_"^"_PackQty_"^"_RecDepDR_"^"_Billed_"^"_BillPrice
	;
	s cardbalance=0
	s patstatus=##class(web.DHCBillInterface).GetAdmSourceByAdm(EpisodeID)
	i patstatus="" s patstatus=0
	s cfRowid="" for  s cfRowid=$o(^DHCCARDi("CF",0,"PAPMIDR",PapmiDR,cfRowid)) q:cfRowid=""  d
	.s ActiveFlag=$p(^DHCCARD("CF",cfRowid),"^",10)
	.q:ActiveFlag'="N"
	.s CFCardNo=$p(^DHCCARD("CF",cfRowid),"^",2)
	i $g(CFCardNo)'="" d
	.s rtn=##class(web.UDHCAccManageCLS).getaccinfofromcardno(CFCardNo,"0")
	.i +rtn=0 s cardbalance=$p(rtn,"^",5)
	
	s TypeOrderStr="",OrderSum=0,OrderSumR=0,OrderDesc=""
    s rtype="0"  for  s rtype=$O(^CacheTemp("DHCDirectOrdItem",$j,rtype)) q:rtype=""  d
    .s OrderStr=""
    .s orditem=""  for  s orditem=$O(^CacheTemp("DHCDirectOrdItem",$j,rtype,orditem)) q:orditem=""  d
    ..s s1=^CacheTemp("DHCDirectOrdItem",$j,rtype,orditem)
    ..s OrderRecLoc="",CTLOCAddress="",RecLocStr="",CSZDK=""
	..s OrderName=$p(s1,"^",1),OrderPackQty=$p(s1,"^",2)
	..s OrderBilled=$p(s1,"^",4),OrderPrice=$p(s1,"^",5)
	..s OrderRecLocDR=$p(s1,"^",3)
	..i OrderRecLocDR'="" d
	...s OrderRecLoc=$p(^CTLOC(OrderRecLocDR),"^",2)
	...i OrderRecLoc["-" s OrderRecLoc=$p(OrderRecLoc,"-",2)
	...s CTLOCAddress=$g(^CTLOC(OrderRecLocDR,"ADDR",1))
	...i (OrderRecLocDR=121)||(OrderRecLocDR=181) s CSZDK="请先划价再交费"
	..i OrderBilled'="P" s OrderSum=OrderPrice*OrderPackQty+OrderSum
    ..i rtype=1 d
    ...i OrderBilled'="P" s OrderSumR=OrderPrice*OrderPackQty+OrderSumR
    ...i patstatus=0 d
    ....s OrderName="药费已交，请到一楼门急诊药房交方取药",OrderBill=""   //"[已收费]"
	....i OrderBilled'="P" s OrderName="药费未交，请先到建卡结算中心交费再到一楼门急诊药房交方取药"
	...e  s OrderName="药费未交，请先到建卡结算中心交费再到一楼门急诊药房交方取药",OrderBill=""
	...;i OrderStr="" s OrderStr1=OrderName_$c(5)_CTLOCAddress_$c(5)_$g(OrderBill)   //VB打印
	...;e  s OrderStr=OrderStr_$c(4)_OrderName_$c(5)_CTLOCAddress_$c(5)_$g(OrderBill)
	...b ;i OrderStr="",OrderBill'="P" s OrderStr=OrderName_$c(5)_CTLOCAddress_$c(5)_$g(OrderBill)
	...i OrderStr="" s OrderStr1="  "_OrderName_" "_$g(OrderBill)  //_" "_OrderRecLoc_"("_CTLOCAddress_")"   //xml打印
	...i OrderStr="",OrderBill'="P" s OrderStr="  "_OrderName  //_" "_OrderRecLoc_"("_CTLOCAddress_")"
	..e   d
	...s OrderBill=$case(OrderBilled,"P":"已收费",:"未收费")
	...i rtype=2 d
	....i AdmType="O" s RecLocDesc="一楼采血中心"
	....i AdmType="E" s RecLocDesc="一楼急诊输液室"
	....s admloc=$p(^PAADM(EpisodeID),"^",4)
	....i admloc=454 s RecLocDesc="儿科输液室"
	....s LisRecLocDesc=RecLocDesc
	....s ArcimDr=$p(^OEORD(+orditem,"I",$p(orditem,"||",2),1),"^",2)
	....s GetReportInfo=$g(^ARCIM(+ArcimDr,$p(ArcimDr,"||",2),"RB",1))  //检验取报告信息
	....s PressingInfo=$p($g(^ARCIM(+ArcimDr,$p(ArcimDr,"||",2),9)),"^",14)  //检验注意事项
	....Set OESpecRid=$O(^OEORD(+orditem,"I",$p(orditem,"||",2),"SPEC",0))
	....i OESpecRid'="" d
	.....Set specimen=$p(^OEORD(+orditem,"I",$p(orditem,"||",2),"SPEC",OESpecRid),"^",1)
	.....i specimen'="" s specdesc=$p($g(^TTAB("SPEC",specimen)),"\",1)
	.....i $g(specdesc)'="" s OrderName=OrderName_"" //     "_$g(specdesc)
	....i OrderStr="" s OrderStr="  "_OrderName  _"  ("_OrderPrice_"元*"_OrderPackQty_")  "_$g(specdesc)_"   "_OrderBill_"  "_$g(PressingInfo)_"  "_$g(GetReportInfo)  //_"  "_RecLocStr      //xml打印
	....e  s OrderStr=OrderStr_$c(3)_"  "_OrderName   _"   ("_OrderPrice_"元*"_OrderPackQty_")  "_$g(specdesc)_"   "_OrderBill_"  "_$g(PressingInfo)_"  "_$g(GetReportInfo)   //_"  "_RecLocStr
	...i (rtype=3)||(rtype=4) d
	....s specdesc=""
	....s RecLocStr=CTLOCAddress_OrderRecLoc
	....i rtype=4 s RecLocStr="",CSZDK=""
	....i OrderStr="" s OrderStr="  "_OrderName  _"  ("_OrderPrice_"元*"_OrderPackQty_")"_$g(specdesc)_"   "_OrderBill_"  "_RecLocStr_"  "_$g(CSZDK)      //xml打印
	....e  s OrderStr=OrderStr_$c(3)_"  "_OrderName   _"   ("_OrderPrice_"元*"_OrderPackQty_")"_$g(specdesc)_"  "_OrderBill_"  "_RecLocStr_"  "_$g(CSZDK)
	..s OrderType=$case(rtype,1:"【药品】",2:"【检验】",3:"【检查】",4:"【其他】")
	.;b ;111111
	.i rtype=1 d
	..i OrderSumR'=0 s OrderType=OrderType_" (药费"_$fn(OrderSumR,"",2)_"元)"
	..i OrderStr="" s OrderStr=OrderStr1_"  药费为"_$fn(OrderSumR,"",2)_"元"
	.i rtype=2 s OrderType=OrderType_" 采血地点:"_LisRecLocDesc  //检验显示采血位置
	.;i TypeOrderStr="" s TypeOrderStr=OrderType_$c(3)_OrderStr	
	.;e  s TypeOrderStr=TypeOrderStr_$c(2)_OrderType_$c(3)_OrderStr	
	.i TypeOrderStr="" s TypeOrderStr=OrderType_$c(2)_OrderStr	
	.e  s TypeOrderStr=TypeOrderStr_$c(1)_OrderType_$c(2)_OrderStr
	
	i OrderSum'=0 s OrderSum=$fn(OrderSum,"",2)
	if patstatus=0 do
	.i OrderSum<cardbalance d
	..s OrderDesc="请直接到相关科室刷卡就诊"
	..i OrderSum'=0 s OrderDesc="本次未收费用为："_OrderSum_"元。"_OrderDesc
	.e  d
	..s OrderDesc="请到建卡结算中心充值交费后再到相应科室就诊"
	..i OrderSum'=0 s OrderDesc="本次未收费用为："_OrderSum_"元。"_OrderDesc_",建议充值额为："_(OrderSum-cardbalance)
	else  do
	.s OrderDesc="请到建卡结算中心交费后再到相应科室就诊。"
	s TypeOrderStr=TypeOrderStr_$c(1)_""_$c(2)_OrderDesc
	
	k ^CacheTemp("DHCDirectOrdItem",$j)
	q:(TypeOrderStr="") ""
	q TypeOrderStr
}

// w ##class(web.UDHCPrescript).GetPrescNoStr("4859")

ClassMethod GetPrescNoStr(EpisodeID As %String) As %String
{
	set PrescNoStr="",DMNum=0
	Set rset=##class(%ResultSet).%New("web.DHCOEOrdItem:GetPrescriptions")
	do rset.Execute(EpisodeID)
	While (rset.Next()) {
		s PrescNo=rset.Data("PrescNo")
		s RecDep=rset.Data("RecDep")
		s PrescDate=rset.Data("PrescDate")
		s PrescType=rset.Data("PrescType")
		s PrescTypeDesc=rset.Data("PrescTypeDesc")
		;w PrescType_"!"_PrescTypeDesc,!
		;if PrescType=2 s DMNum=DMNum+1
		b ;1
		if PrescType=2{
			s DMNum=DMNum+1
			s PrescNo=PrescNo_"!"_DMNum
			if PrescNoStr="" set PrescNoStr=PrescNo_"   "_PrescDate_"   "_RecDep
			else  set PrescNoStr=PrescNo_"   "_PrescDate_"   "_RecDep_"^"_PrescNoStr
		}else{
			if PrescNoStr="" set PrescNoStr=PrescNo_"   "_PrescDate_"   "_RecDep
			else  set PrescNoStr=PrescNoStr_"^"_PrescNo_"   "_PrescDate_"   "_RecDep
		}
	}
	d rset.Close()
	q PrescNoStr
}

ClassMethod GetPAADmListBroker(itmjs As %Library.String = "", EpisodeID As %String) As %String
{
	 Set rset=##class(%ResultSet).%New("web.DHCOEOrdItem:HistoryAdm")
	 do rset.Execute(EpisodeID)
	 While (rset.Next()) {
		s Adm=rset.Data("Adm")
		s res=rset.Data("res")
		
		s retval=itmjs_"('"_$ZCVT(res,"O","JS")_"','"_$ZCVT(Adm,"O","JS")_"');"
		&javascript<#(retval)#>
	 }
	 d rset.Close()
	 q 0
}

// w ##class(web.UDHCPrescript).GetPrescNoStrByOrdList(121,"119||36^119||37")

ClassMethod GetPrescNoStrByOrdList(EpisodeID As %String, OrdItemList As %String, SearchDate As %String = "") As %String
{
	set PrescNoStr="",DMNum=0
	s SearchDate=..%ZDH(SearchDate)
	i SearchDate="" s SearchDate=..%SysDate()
	s AdmType=##class(web.DHCDocOrderEntry).GetPAAdmType(EpisodeID)
	k PrescList,PrescListNo
    for i=1:1:$l(OrdItemList,"^") {
	    s OrdItem=$p(OrdItemList,"^",i)
    	s ord=+OrdItem,chl=$p(OrdItem,"||",2)
    	s PrescNo=$P($G(^OEORD(ord,"I",chl,1)),"^",14)
		continue:PrescNo=""
		s QUE1RowID=$O(^PAQUE1(0,"PrescNo",PrescNo,0))
		s QuePresType=$p($g(^PAQUE1(QUE1RowID,"DHC")),"^",2)
    	s BillType=##class(DHCDocPrescript).GetPrescType(PrescNo)
    	s Count=..GeOrdPrescExecCount(EpisodeID,PrescNo,SearchDate)
    	
 		i (Count>0) {
 			s ArcimRowid=$p(^OEORD(ord,"I",chl,1),"^",2)
 			s RecDepDR=$P($G(^OEORD(ord,"I",chl,3)),"^",6) ;OEORI_RecDep_DR
 			s BBExtCode=$p(^OEORD(ord,"I",chl,11),"^",18)
 			s AdmReason=""
 			if (BBExtCode'="") s AdmReason=$p($g(^PAC("ADMREA",BBExtCode)),"^",2)
 			if RecDepDR'="" s RecDep=$P(^CTLOC(RecDepDR),"^",2)
 			s SttDate=$p(^OEORD(ord,"I",chl,1),"^",9)
 			s TransDate=$zd(SttDate,3)
 			
 			;1:普通  2:毒麻  3:精二  4:小儿
 			s PrescType="",PrescTypeDesc=""
 			s LoopPrescType=100
 			if (QuePresType=3){
	 			s PrescType=1
	 			s PrescTypeDesc="普通"
 			}else{
	 			/*
	 			s PoisonRowid=##class(web.DHCDocOrderEntry).GetDrgFormPoison(ArcimRowid)
	 			i PoisonRowid'="" {
	 				s PoisonCode=$p($g(^PHCPO(PoisonRowid)),"^",1)
	 				i PoisonCode="J1" s PrescType=2
	 				i PoisonCode="DX" s PrescType=2
	 				i PoisonCode="MZ" s PrescType=2
	 				i PoisonCode="J2" s PrescType=3
	 			}
	 			*/
	 			s OrderPHPrescType=##Class(web.DHCDocOrderCommon).GetPHPrescTypeByItem(ArcimRowid)
	 			s PrescType=$CASE(OrderPHPrescType,5:3,6:2,8:2,:PrescType)
	 			i PrescType="" s PrescType=1
	 			i PrescType=1 s PrescTypeDesc="普通"
	 			i PrescType=2 {
		 			s PrescTypeDesc="麻精一"
		 			s LoopPrescType=1
	 			}
	 			i PrescType=3 s PrescTypeDesc="精二"
	 			if PrescType=2{
	 				s DMNum=DMNum+1
	 			}
 			}
 			if '$d(PrescList(LoopPrescType,PrescNo)) {
 				s PrescList(LoopPrescType,PrescNo)=PrescType_"^"_TransDate_"^"_RecDep_"^"_BillType
 			}
 		}
    }
	s LoopPrescType=0
	for {
		s LoopPrescType=$O(PrescList(LoopPrescType))
		q:LoopPrescType=""
		s PrescNo=0
		for {
			s PrescNo=$o(PrescList(LoopPrescType,PrescNo))
			q:PrescNo=""
			s Val=$G(PrescList(LoopPrescType,PrescNo))
			s PrescType=$p(Val,"^",1)
			s RecDep=$p(Val,"^",3)
			s PrescDate=$p(Val,"^",2)
			s AdmReason=$p(Val,"^",4)
			continue:($d(PrescListNo(PrescNo)))
			s PrescListNo(PrescNo)=1
			if PrescType=2{
				s PrescNo=PrescNo_"!"_DMNum
				if PrescNoStr="" set PrescNoStr=PrescNo_"   "_PrescDate_"   "_RecDep_"   "_AdmReason
				else  set PrescNoStr=PrescNo_"   "_PrescDate_"   "_RecDep_"   "_AdmReason_"^"_PrescNoStr
			}else{
				if PrescNoStr="" set PrescNoStr=PrescNo_"   "_PrescDate_"   "_RecDep_"   "_AdmReason
				else  set PrescNoStr=PrescNoStr_"^"_PrescNo_"   "_PrescDate_"   "_RecDep_"   "_AdmReason
			}
		}
	}
	q PrescNoStr
}

// w ##class(web.UDHCPrescript).GetOrdItemByPrescNo(9,"MJ17070300001")

ClassMethod GetOrdItemByPrescNo(EpisodeID As %String, PrescNo As %String, SearchDate As %String = "") As %String
{
	
	s ^tan("GetOrdItemByPrescNo")=EpisodeID_","_PrescNo_","_SearchDate
	s SearchDate=..%ZDH(SearchDate)
	i SearchDate="" s SearchDate=..%SysDate()
	Quit:(EpisodeID="")||(PrescNo="") ""
	set OrderRowId=$o(^OEORD(0,"Adm",EpisodeID,""))
	Quit:OrderRowId="" ""
	Quit:'$d(^OEORD(0,"PrescNo",PrescNo,OrderRowId)) ""
	s PAAdmType=##class(web.DHCDocOrderEntry).GetPAAdmType(EpisodeID)
	set PrescSum=0,PrescItem=""
	set Childsub=0
	for {
		set Childsub=$o(^OEORD(0,"PrescNo",PrescNo,OrderRowId,Childsub)) q:Childsub="" 
  		continue:##class(web.DHCBillInterface).ICheckOrderIsRefAudit(OrderRowId_"||"_Childsub)="Y"
  		set itemStatDr=$p($g(^OEORD(+OrderRowId,"I",Childsub,1)),"^",13)
  		
  		s statcode=""
        i itemStatDr'="" {
            s statcode=$p($g(^OEC("OSTAT",itemStatDr)),"^",1)
        }
        
  		
  		set SkinTest=$p($g(^OEORD(+OrderRowId,"I",Childsub,5)),"^",2)
  		i SkinTest="N" s SkinTestflag="N"
  		e  s SkinTestflag="Y"
  		s dspflag=..CheckOrdByDsp(OrderRowId_"||"_Childsub)
  		if (PAAdmType="I"){
	  		s Count=..GetOrdExecCount(OrderRowId_"||"_Childsub,SearchDate)
	  		continue:(Count=0)
	  	}else{
			continue:((statcode'="V")&&(statcode'="E"))&&(dspflag=0)
	  	}
		set OrdItemArcim=$p($g(^OEORD(+OrderRowId,"I",Childsub,1)),"^",2)
  		continue:(OrdItemArcim="")  		
  		//s OEORIPrescNo=$p($g(^OEORD(+OrderRowId,"I",Childsub,1)),"^",14)
  		set ItemCatDR=$p($g(^ARCIM(+OrdItemArcim,1,1)),"^",10)
 		set OrderType=$p($g(^ARC("IC",ItemCatDR)),"^",7)	;ARCIC_OrderType
 		continue:(OrderType'="R")
 		s ordstr3=$g(^OEORD(+OrderRowId,"I",Childsub,3))
 		s OrdBilled=$p(ordstr3,"^",5)
 		s myBillFlag=0 
		i $g(OrdBilled)="P" s myBillFlag=1
		s PriorityDR=$p(^OEORD(+OrderRowId,"I",Childsub,1),"^",8)
		s Priority=$p(^OECPR(PriorityDR),"^",2)
		s ISLongOrderPrior=##class(appcom.OEOrdItem).ISLongOrderPrior(PriorityDR)
 		s (PackQty,PackUOM,Frequence,Duration,Instruction)=""
 		s Price=$p($g(^OEORD(+OrderRowId,"I",Childsub,2)),"^",13)
 		s myOrdInfo=""
 		if ('ISLongOrderPrior){
	 		s PrintPriority=""
	 		s PackQty=$p($g(^OEORD(+OrderRowId,"I",Childsub,9)),"^",4)
	 		;如果没有填数量则自动计算数量
		    i ((+PackQty=0))  {
			    /*
		    	s DoseQty=$p($g(^OEORD(+OrderRowId,"I",Childsub,2)),"^",1) 
		    	s DoseUnitID=$p($g(^OEORD(+OrderRowId,"I",Childsub,2)),"^",3)  
		    	s drgformId=$P(^ARCIM(+OrdItemArcim,$P(OrdItemArcim,"||",2),1),"^",12)
		    	s PHFreqDR=$p($g(^OEORD(+OrderRowId,"I",Childsub,2)),"^",4) 
		    	s DuraDR=$p($g(^OEORD(+OrderRowId,"I",Childsub,2)),"^",6) 
				s Qty=##Class(web.DHCDocOrderEntry).CalDose(DoseUnitID,drgformId,DoseQty)
				i DuraDR'="" s PackQty=+Qty*$P(^PHCFR(PHFreqDR),"^",2)*$P(^PHCDU(DuraDR),"^",2)
		    	*/
				s dis=0  
				f  {
					s dis=$O(^DHCOEDISQTY(0,"OEORI",OrderRowId_"||"_Childsub,dis))
					q:dis=""
					s dstatus=$p(^DHCOEDISQTY(dis),"^",7)
					//发药数量
					i (dstatus="C")||(dstatus="TC") {
						s PackQty=PackQty+$p(^DHCOEDISQTY(dis),"^",11)
					}
				}
				s INCIRowid=##class(web.DHCDocOrderEntry).GetINCI(+OrdItemArcim)
				s BillingUOMDR=$p($g(^INCI(INCIRowid,1)),"^",10)
		    }else{
			    set BillingUOMDR=$p($g(^ARCIM(+OrdItemArcim,1,8)),"^",14)
		 		;协议单位
				s ProtocolPackUOMDR=$p($g(^OEORD(+OrderRowId,"I",Childsub,"DHC")),"^",13)
				i ProtocolPackUOMDR'="" s BillingUOMDR=ProtocolPackUOMDR
		    }
		    s PackUOM=##class(web.DHCDocOrderCommon).GetUOMDesc(BillingUOMDR)
		 	i PackUOM["(" s PackUOM=$p(PackUOM,"(",1)
		    s myOrdInfo=PackQty_PackUOM
 		}else{
	 		s myOrdInfo="("_Priority_")"
	 	}
 		//s PhQtyOrd=$p($g(^OEORD(+OrderRowId,"I",Childsub,1)),"^",12)
 		s dsp=0,qty=0
 		for{
	 		s dsp=$o(^DHCOEDISQTY(0,"OEORI",+OrderRowId_"||"_Childsub,dsp))  q:dsp=""  
	 		s qty=+$g(qty)+$p(^DHCOEDISQTY(dsp),"^",2)
	 	}
 		
 		
	 	
  		s OrderName=$p($g(^ARCIM(+OrdItemArcim,1,1)),"^",2)
  		s GenericName=##class(web.UDHCJFCOMMON).GetDrugCommonNameByArcimId(OrdItemArcim)
		i GenericName'="" s OrderName=GenericName
  		s InciRowid=##class(web.DHCDocOrderEntry).GetINCI(+OrdItemArcim)
  		q:InciRowid=""
		i InciRowid'="" {
			s Spec=##class(web.DHCOutPhDisp).GetPhgg(InciRowid)
			s INFORowId=$o(^DHCITMINFO(0,"INCI",InciRowid,""))
			//s INFOOTC=$p(^DHCITMINFO(INFORowId),"^",5)
			//i INFOOTC'="处方药" s OrderName="(OTC) "_OrderName
			//s Spec=$P(Spec,"[",2)
			//s Spec=$P(Spec,"]",1)
			
			s qtyinfo=##class(web.DHCOutPhCommon).getPackQty(InciRowid,qty)
	        s qty=$p(qtyinfo,"^",1)
	        //s PackQty=qty

		}
		set Sum=PackQty*Price, Sum=$fn(Sum,"",2)
 		//set PrescSum=PackQty*Price+PrescSum
		//自备药、嘱托金额不计算在总金额里 	
		s ProirityDr=$p($g(^OEORD(+OrderRowId,"I",Childsub,1)),"^",8)
		s OECPRCode=""
		i ProirityDr'="" s OECPRCode=$p($g(^OECPR(ProirityDr)),"^",1)
		i ((OECPRCode'="OM")&&(OECPRCode'="OMST")&&(OECPRCode'="OMCQZT")&&(OECPRCode'="OMLSZT"))  {  //自备药、嘱托
			set PrescSum=PackQty*Price+PrescSum
		}
	
				
				

		i $g(Spec)'="" {
			s Spec=$zcvt(Spec,"L")
			s Spec="("_$g(Spec)_")"
		}
		s OrderName=OrderName_$g(Spec)
		s DoseQty=$p($g(^OEORD(+OrderRowId,"I",Childsub,2)),"^",1)
		s DoseUOM=$p($g(^OEORD(+OrderRowId,"I",Childsub,2)),"^",3)
		if DoseUOM'="" s DoseUOM=$p($g(^CT("UOM",DoseUOM)),"^",1)
		s DoseUOM=$zcvt(DoseUOM,"L")
		if DoseQty["." {
			if $p(DoseQty,".",1)="" s DoseQty="0"_DoseQty
		}
  		s FrequenceRowid=$p($g(^OEORD(+OrderRowId,"I",Childsub,2)),"^",4)
  		if FrequenceRowid'="" s Frequence=$p($g(^PHCFR(FrequenceRowid)),"^",3)
		s DurationRowid=$p($g(^OEORD(+OrderRowId,"I",Childsub,2)),"^",6)
		if DurationRowid'="" s Duration=$p($g(^PHCDU(DurationRowid)),"^",1)
		s InstructionRowid=$p($g(^OEORD(+OrderRowId,"I",Childsub,2)),"^",7)
		if InstructionRowid'="" s Instruction=$p($g(^PHCIN(InstructionRowid)),"^",2)
		
		set Orddate=$zd($p($g(^OEORD(+OrderRowId,"I",Childsub,3)),"^",7),3)
 		set Ordtime=..%ZT($p($g(^OEORD(+OrderRowId,"I",Childsub,1)),"^",15),1)
		set PoisonRowid=##class(web.DHCDocOrderEntry).GetDrgFormPoison(OrdItemArcim)
		if PoisonRowid'="" set PoisonClass=$p($g(^PHCPO(PoisonRowid)),"^",1)
		if $g(PoisonClass) set PoisonClass=$tr(PoisonClass,$c(13,10),"")
		
		
		
		if $g(SkinTestflag)="Y"  s OrdItem=OrderName_"   "_myOrdInfo_"   "_"皮内注射(皮试)"
		if $g(SkinTestflag)="N"  set OrdItem=OrderName_"   "_myOrdInfo_"/"_DoseQty_DoseUOM_" "_Frequence_" "_Instruction
	   	//set OrdItem=OrderName_"^"_PackQty_"^"_PackUOM_"^"_DoseQty_"^"_DoseUOM_"^"_Instruction_"^"_Frequence_"^"_Duration_"^"_Sum
	   	if (PAAdmType="I"){
			s prior=$p($g(^OEORD(+OrderRowId,"I",Childsub,1)),"^",8)
 			s prior=$p($g(^OECPR(+prior)),"^",2)
 			s OrdItem=OrdItem_" "_prior
		}
	   	
	   	s OrdItemStrLen=$l(OrdItem)
	   	i OrdItemStrLen>40 d
	   	.s OrdItem1=$p(OrdItem," ","1")
	   	.s OrdItem4=$p(OrdItem," ","4")
	   	.s OrdItem5=$p(OrdItem," ","5")
	   	.s OrdItem6=$p(OrdItem," ","6")
	   	.s OrdItem=OrdItem1_"  "_OrdItem4_$c(13)_"                              "_OrdItem5_" "_OrdItem6
	   	if PrescItem="" set PrescItem=OrdItem
	   	else  set PrescItem=PrescItem_$c(2)_OrdItem
  	}
  	if (PAAdmType'="I"){
  		i $g(myBillFlag)=1  s BillTxt="本处方已收费 请到一楼药房交方取药"
  		i $g(myBillFlag)=0  s BillTxt="本处方未收费 请到收费处交费后取药"
		set PrescSum=$fn(PrescSum,"",2)
  	}else{
		s PrescSum="" 
	}
	set PrescOtherInfo=PrescSum_"^"_$g(PoisonClass)_"^"_$g(Orddate)_"^"_$g(Ordtime)
	
 	Quit PrescOtherInfo_$c(1)_PrescItem_$c(1)_$g(BillTxt)
}

ClassMethod GetDrugCommonNameByArcimId(ArcimId As %String) As %String
{
	;w ##class(web.UDHCPrescript).GetDrugCommonNameByArcimId("1487||1")
	;n (ArcimId)
	
	s DrugCommonName=""
    s Drugbarcode=""
	i ArcimId'="" d
	.s ItmCat=$p($g(^ARCIM($p(ArcimId,"||",1),$p(ArcimId,"||",2),1)),"^",10)
	.s OrdType=$p($g(^ARC("IC",ItmCat)),"^",7)	;ARCIC_OrderType
	.Q:OrdType'="R" 
	.;s DrugCommonName =$p($g(^ARCIM($p(ArcimId,"||",1),$p(ArcimId,"||",2),8)),"^",21) ;ARCIM_GenericDesc 通用名 8 21
	.;取药学项上的通用名
	.s phcdf=$p($g(^ARCIM($p(ArcimId,"||",1),$p(ArcimId,"||",2),1)),"^",12)
	.q:phcdf=""
	.s gene=$p($g(^PHCD(+phcdf,4)),"^",1)
	.q:gene=""
	.s DrugCommonName=$p($g(^PHCGE("GE",gene)),"^",2)
	
	Quit DrugCommonName
}

ClassMethod GetPHItemInfo(OERowId)
{
	Q:OERowId=""
	s DQTY=1
	&sql(select OEORI_ItmMast_DR->ARCIM_BillingUOM_DR,OEORI_ItmMast_DR->ARCIM_PHCDF_DR->PHCDF_CTUOM_DR,OEORI_UNIT_DR,OEORI_ItmMast_DR->ARCIM_PHCDF_DR into :PackUOMID,:BaseUOMID,:DoseUOMID,:DrgFormID from SQLUser.OE_OrdItem where OEORI_Rowid=:OERowId)
	s facnum=$$UOMFac(PackUOMID,BaseUOMID)
	//&sql(select EQ_Qty into :DQTY from SQLUser.PHC_FormDoseEquiv where EQ_ParRef=:DrgFormID and EQ_CTUOM_DR=:DoseUOMID)
	//s DDesc=$p(^CT("UOM",DoseUOMID),"^",2)
	s EQRowId=$o(^PHCD($P(DrgFormID,"||",1),"DF",$P(DrgFormID,"||",2),"EQ",0))
	q:$g(EQRowId)="" 1_"^"_$p(^CT("UOM",BaseUOMID),"^",2)_"^"_1  ;fdd 20080803
	s DQTY=$P(^PHCD($P(DrgFormID,"||",1),"DF",$P(DrgFormID,"||",2),"EQ",EQRowId),"^",2)
	if DQTY<1 s DQTY="0"_DQTY
	S DDescID=$P(^PHCD($P(DrgFormID,"||",1),"DF",$P(DrgFormID,"||",2),"EQ",EQRowId),"^",1)
	s DDesc=$p(^CT("UOM",DDescID),"^",2)
	Q DQTY_"^"_DDesc_"^"_facnum
UOMFac(fr,to)   
 q:fr=to 1    ;if from-uom is as same as to-uom then return 1
 s rowid=""
 s rowid=$o(^CT("CTCF",0,"UOM",fr,to,rowid)) 
 i rowid'="" d       
 .s fac=$p(^CT("CTCF",rowid),"^",3)
 .s fac=$p(fac,$c(1))
 e  d
 .s fac=1
 q $g(fac)
}

ClassMethod GetPrescItemsBroker(itmjs As %Library.String = "", EpisodeID As %String, PrescNo As %String) As %Library.String
{
	;Rowid:OrderName:,StartDate:SeqNo:DoseQty:DoseUOM:Priority:Status:Frequence:Instruction:Duration:PackQty:RecDep:Billed")
	Set rset=##class(%ResultSet).%New("web.UDHCPrescript:GetPrescItems")
	do rset.Execute(EpisodeID,PrescNo)
	Set columns = rset.GetColumnCount()
	While (rset.Next()) {
		For col = 1:1:columns {
			;Write rset.GetColumnName(col),":"
			if col=1 set value=rset.GetData(col)
			e  s value=value_"^"_rset.GetData(col)
		}
		s retval=itmjs_"('"_$ZCVT(value,"O","JS")_"');"
		&javascript<#(retval)#>
	}
	d rset.Close()
	Q 1
}

ClassMethod GetPrescItemsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPrescItemsExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod GetPrescItemsExecute(ByRef qHandle As %Binary, EpisodeID As %String, PrescNo As %String) As %Status
{
 Set repid=$I(^CacheTemp)
 If $g(ind)="" Set ind=1
 set PatType="", InsType="", PriorRowid="", InstrRowid="", LinkTo="", OEPrice="",PrescripType=""
 set RowCount=0
 k ^CacheTemp("DHCPrescOrdItem",$j,"master")
 do CheckRowCount
 s PAADMRegConDisDR=$P($G(^PAADM(EpisodeID,"DHC")),"^",25)
 if RowCount>0 d
 .&sql(DECLARE CNMedCursor CURSOR FOR
 SELECT OEORI_Rowid,OEORI_ItmMast_DR->ARCIM_Desc,Todate(OEORI_SttDat,'dd/mm/yyyy'),OEORI_SeqNo,
 OEORI_DoseQty,OEORI_UNIT_DR->CTUOM_Desc,
	       OEORI_Priority_dr->OECPR_Desc,OEORI_Itemstat_dr->OSTAT_Desc,oeori_PHFreq_dr->PHCFR_Code,
	       OEORI_instr_dr->PHCIN_Desc1,OEORI_Durat_dr->PHCDU_Desc1,
	       OEORI_QtyPackUOM,OEORI_ItmMast_DR->ARCIM_BillingUOM_DR->CTUOM_Desc,
	       OEORI_RecDep_DR->CTLOC_Desc,OEORI_Billed,OEORI_ItmMast_DR,OEORI_SttDat,OEORI_BBExtCode,
	       OEORI_UserAdd->SSUSR_Initials,OEORI_UserAdd->SSUSR_Name,
	       OEORI_ItmMast_DR->ARCIM_ItemCat_DR,OEORI_OEORI_DR,OEORI_Action_DR->ACT_Desc
	  INTO :Rowid,:OrderName,:StartDate,:SeqNo,:DoseQty,:DoseUOM,:Priority,:Status,:Frequence,
	       :Instruction,:Duration,:PackQty,:PackUOM,:RecDep,:Billed,:ARCIMRowid,:SttDate,
	       :BillType,:UserAddCode,:UserAddName,:ItemCat,:LinkOrderItem,:Action
	  From SQLUser.OE_OrdItem 
	 WHERE OEORI_PrescNo=:PrescNo and OEORI_OEORD_PARREF->OEORD_ADM_DR=:EpisodeID and 
	       OEORI_ItemStat_DR->OSTAT_Code='V' and OEORI_ItmMast_DR->ARCIM_ItemCat_DR->ARCIC_OrderType='R')
	.&sql(OPEN CNMedCursor)
	.for  &SQL(FETCH CNMedCursor) QUIT:SQLCODE  do
	..;协议单位
	..s ProtocolPackUOMDR=$p($g(^OEORD(Rowid,"I",$P(Rowid,"||",2),"DHC")),"^",13)
	..i ProtocolPackUOMDR'="" d
	...s PackUOM=$p($g(^CT("UOM",ProtocolPackUOMDR)),"^",2)
	..;批次价
	..s OrderRecDepRowid=$P($G(^OEORD(Rowid,"I",$P(Rowid,"||",2),3)),"^",6) ;OEORI_RecDep_DR
	..s ExpStr=Rowid_"^"_""_"^"_EpisodeID_"^"_OrderRecDepRowid
	..s retPrice=##class(web.DHCDocOrderEntry).GetOrderPrice(PatType, InsType, ARCIMRowid, SttDate, PriorRowid, InstrRowid, LinkTo, OEPrice,PAADMRegConDisDR,ProtocolPackUOMDR,ExpStr)
	..;w !, PackQty_"^"_PackUOM
	..s Price=$P(retPrice,"^",1)
	..s DiscPrice=$P(retPrice,"^",2)
	..s InsPrice=$P(retPrice,"^",3)
	..s PatPrice=$P(retPrice,"^",4)
	..s Sum=PackQty*Price
	..s FRQRowid=$O(^PHCFR(0,"Code",$$ALPHAUP^SSUTIL4(Frequence),""))
	..s Frequence=$P(^PHCFR(FRQRowid),"^",4)
	..s PrescripType="自费"
	..s ^zll("20140829")=BillType_"^"_PrescNo
	..i BillType="" s BillTypeDesc="自费"
	..e  d
	...s BillTypeDesc=$P(^PAC("ADMREA",BillType),"^",2)
	...s PrescripType=$p($G(^PAC("ADMREA",BillType,"DOC")),"^",1)
	...i PrescripType=""  s PrescripType=BillTypeDesc
	...s ^zll("20140829",1)=PrescripType_"^"_BillTypeDesc
	..;
	..;在药学项上记录了该药品属于哪类
	..s DrgFormRowid=##class(web.DHCDocOrderEntry).GetDrgForm(ARCIMRowid)
	..s OfficialCode=""
	..s BillClassDesc=""
	..i DrgFormRowid'="" d
	...s DrgMastRowid=$p(DrgFormRowid,"||",1)
	...s OfficialCode=$p($g(^PHCD(DrgMastRowid,4)),"^",2)
	..i OfficialCode=1 s BillClassDesc="甲类"
	..i OfficialCode=2 s BillClassDesc="乙类"
	..i OfficialCode=3 s BillClassDesc="丙类"
	..s PoisonRowid=##class(web.DHCDocOrderEntry).GetDrgFormPoison(ARCIMRowid)
	..i PoisonRowid'="" d
	...s PoisonClass=$p($g(^PHCPO(PoisonRowid)),"^",2)
	...s PoisonClass=$tr(PoisonClass,$c(13,10),"")
	...i PoisonClass="二类精神" s PoisonClass="精二"
	...e  i PoisonClass="一类精神" s PoisonClass="精一"
	...e  i PoisonClass="麻醉药品" s PoisonClass="麻"
	...i PoisonClass'=("精二")&&(PoisonClass'="精一")&&(PoisonClass'="麻")  s PoisonClass=""
	..e  s PoisonClass=""
	..i (DoseQty'="")&(DoseQty<1) s DoseQty="0"_$number(DoseQty)
	..s GenericName=..GetDrugCommonNameByArcimId(ARCIMRowid)
	..i GenericName'="" d
	...s Spec=""
	...s ARCIMSub=$p(ARCIMRowid,"||",1)
	...s InciRowid=##class(web.DHCDocOrderEntry).GetINCI(ARCIMSub)
	...i InciRowid'="" s Spec=##class(web.DHCOutPhDisp).GetPhgg(InciRowid)
	...s Spec=$P(Spec,"[",2)
	...s Spec=$P(Spec,"]",1)
	...//add by wl090116
	...i Spec="" s Spec=##class(web.DHCOutPhDisp).GetPhgg(InciRowid)
	...s OrderName=GenericName_Spec
	...//s OrderName=GenericName
	..if StartDate'="" s StartDate=$ZD(StartDate,3)
	..s Data1=$lb(Rowid,OrderName,StartDate,SeqNo,DoseQty,DoseUOM,Priority,Status,Frequence,Instruction,Duration,PackQty,PackUOM,Price,Sum,RecDep,Billed,BillTypeDesc,BillClassDesc,UserAddCode,UserAddName,PoisonClass,ItemCat,Action,PrescripType)
	..i LinkOrderItem="" s ^CacheTemp("DHCPrescOrdItem",$j,"master",Rowid)=Data1
	..e  d
	...if '$D(^CacheTemp("DHCPrescOrdItem",$j,"master",LinkOrderItem)) d
	....s ^CacheTemp("DHCPrescOrdItem",$j,"master",LinkOrderItem)=""
	...s ^CacheTemp("DHCPrescOrdItem",$j,"master",LinkOrderItem,"sub",Rowid)=Data1
	..;
	..;do OutputRow2
	.&sql(CLOSE CNMedCursor)
	s SeqNo=0
	s mas=0 for  s mas=$O(^CacheTemp("DHCPrescOrdItem",$j,"master",mas)) q:mas=""  d
	. s s1=^CacheTemp("DHCPrescOrdItem",$j,"master",mas)
	. i s1'="" d 
	. .s SeqNo=SeqNo+1
	. .s $List(s1,4)=SeqNo
	. .s Data=s1
	. .d OutputRow2
	. s SubSeqCount=0
	. s sub=0  for  s sub=$O(^CacheTemp("DHCPrescOrdItem",$j,"master",mas,"sub",sub)) q:sub=""  d
	. . s s2=^CacheTemp("DHCPrescOrdItem",$j,"master",mas,"sub",sub)
	. . i s1="" d
	. . . s SeqNo= SeqNo+1
	. . . s $List(s2,4)=SeqNo
	. . . s Data=s2
	. . . d OutputRow2
	. . e  d
	. . . s SubSeqCount=SubSeqCount+1
	. . . s SubSeqNo=SeqNo_"."_SubSeqCount
	. . . s $List(s2,4)=SubSeqNo
	. . . s Data=s2
	. . . d OutputRow2
	k ^CacheTemp("DHCPrescOrdItem",$j,"master")
 else  Do
 .do ResetVariables2
 .set Data=$lb(Rowid,OrderName,StartDate,SeqNo,DoseQty,DoseUOM,Priority,Status,Frequence,Instruction,Duration,PackQty,PackUOM,Price,Sum,RecDep,Billed,BillTypeDesc,BillClassDesc,UserAddCode,UserAddName,PoisonClass,ItemCat,Action,PrescripType)
 .Do OutputRow2 	
 Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow2
	;set Data=$lb(Rowid,OrderName,StartDate,SeqNo,DoseQty,DoseUOM,Priority,Status,Frequence,Instruction,Duration,PackQty,PackUOM,Price,Sum,RecDep,Billed,BillTypeDesc,BillClassDesc,UserAddCode,UserAddName,PoisonClass,ItemCat)
 Set ^CacheTemp(repid,ind)=Data
 Set ind=ind+1
	Quit
ResetVariables2
	set (Rowid,OrderName,StartDate,SeqNo,DoseQty,DoseUOM,Priority,Status,Frequence,Instruction,Duration,PackQty,PackUOM,Price,Sum,RecDep,Billed,BillTypeDesc,BillClassDesc,UserAddCode,UserAddName,PoisonClass,ItemCat,Action,PrescripType)=""
	quit
CheckRowCount
 if PrescNo="" s RowCount=0
 else  d
 .&sql(SELECT Count(*) INTO :RowCount From SQLUser.OE_OrdItem 
	 WHERE OEORI_PrescNo=:PrescNo and OEORI_OEORD_PARREF->OEORD_ADM_DR=:EpisodeID)
	quit
}

ClassMethod GetPrescItemsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPrescItemsExecute ]
{
 Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
	//
 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {				// if there are no more rows, finish fetching
 Set AtEnd=1
 Set Row=""
 }
 Else      {				// fetch row
 Set Row=^CacheTemp(repid,ind)
 }
 // Save QHandle
 s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod getdsy(rowid)
{
 s OEORDRowId=$P(rowid,"||",1),OEORIChildsub=$P(rowid,"||",2)
 s oeoridr=$p(^OEORD(OEORDRowId,"I",OEORIChildsub,11),"^",39)	
 q oeoridr
}

ClassMethod gettype(rowid)
{
 s OEORDRowId=$P(rowid,"||",1),OEORIChildsub=$P(rowid,"||",2)
 s ItmMastrowid=$p(^OEORD(OEORDRowId,"I",OEORIChildsub,1),"^",2)
 s Subscript=$p(ItmMastrowid,"||",1),Version=$p(ItmMastrowid,"||",2)
 s ItemCat=$p(^ARCIM(Subscript,Version,1),"^",10)
 s fl=##Class(web.DHCDocOrderCommon).GetPHPrescType(ItemCat,"",ItmMastrowid)
 q fl
}

ClassMethod YBFL(RowId)
{
 s childsub=$p(RowId,"||",2),RowId=$p(RowId,"||",1)
 s ItmMastDR=$p(^OEORD(RowId,"I",childsub,1),"^",2)
 i $d(^OEORD(RowId,"I",childsub,"DEP")) s DepProcNotes=^OEORD(RowId,"I",childsub,"DEP",1)
 s Subscript=$p(ItmMastDR,"||",1) s Version=$p(ItmMastDR,"||",2)
 s PHCDFDR=$p(^ARCIM(Subscript,Version,1),"^",12)
 s ARCIMDesc=$p(^ARCIM(Subscript,Version,1),"^",2)
 s OfficialCode=$p(^PHCD($p(PHCDFDR,"||",1),4),"^",2)
 i OfficialCode="1" s YBFL="{甲}"
 i OfficialCode="2" s YBFL="{乙}"
 i OfficialCode="3" s YBFL="{丙}"
 q ARCIMDesc_"^"_DepProcNotes
}

Query GetPrescItems(EpisodeID As %String, PrescNo As %String) As %Library.Query(CONTAINID = "", ROWSPEC = "Rowid:%String,OrderName:%String,StartDate:%String,SeqNo:%String,DoseQty:%String,DoseUOM:%String,Priority:%String,Status:%String,Frequence:%String,Instruction:%String,Duration:%String,PackQty:%String,PackUOM:%String,Price:%String,Sum:%String,RecDep:%String,Billed:%String,BillType:%String,BillClass:%String,UserAddCode:%String,UserAddName:%String,PoisonClass:%String,ItemCat:%String,Action:%String,PrescripType:%String")
{
}

ClassMethod SetGetChildWeight(EpisodeID, Weight)
{
	s ret="^"
	if (EpisodeID'="")&&(Weight'="") d
	.s MRRowId=$p(^PAADM(EpisodeID),"^",61)
	.q:MRRowId=""
	.&sql(update SQLUser.MR_Adm set MRADM_Weight=:Weight where MRADM_RowId=:MRRowId)
	.if SQLCODE=0 s ret="0"_"^"_""
	.if SQLCODE=0 s ret="0"_"^"_Weight
	.else  s ret="200^"
	else  d 
	.if (EpisodeID="") s ret="201^" q
	.s MRRowId=$p(^PAADM(EpisodeID),"^",61)
	.b
	.q:MRRowId=""
	.s rtnWeight=$p(^MR(MRRowId,"PRO",1),"^",27)
	.s ret="1^"_rtnWeight
	q ret
}

ClassMethod GetPatInform(AdmRowId)
{
	s PatInform=""
	set Paadmdate=$p(^PAADM(AdmRowId),"^",6)
	if Paadmdate'="" set Paadmdate=$zd(Paadmdate,3)
	set Depcodedr=$p(^PAADM(AdmRowId),"^",4)
	set Depdesc=$p($g(^CTLOC(Depcodedr)),"^",2)
	if Depdesc["-" set Depdesc=$p(Depdesc,"-",2)
	s PapmiDr=$p(^PAADM(AdmRowId),"^",1)
	s Company=$p($g(^PAPER(PapmiDr,"PER",4)),"^",18) 
	s MRRowId=$p(^PAADM(AdmRowId),"^",61)
	s PatWeight=""
	i MRRowId'="" s PatWeight=$p($g(^MR(MRRowId,"PRO",1)),"^",27)
	Set SessLoc = $g(%session.Data("LOGON.CTLOCID")),SessHospDesc=""
    if SessLoc>0 d 
    .Set SessHosp = $p(^CTLOC(SessLoc),"^",22)
    .Set:SessHosp>0 SessHospDesc=$p(^CT("HOSP",SessHosp),"^",2)
	Set AdmReason=$P($g(^PAADM(AdmRowId,1)),"^",7)
    s PAAdmReason=""
	If AdmReason'="" Set PAAdmReason=$P($g(^PAC("ADMREA",AdmReason)),"^",2)
	Set BedId=$P($g(^PAADM(AdmRowId)),"^",73)
    if BedId'="" Set PAAdmBed=$P($g(^PAWARD(+BedId,"BED",$P(BedId,"||",2))),"^",1)
	else  Set PAAdmBed=""
	s PatInform=Company_"^"_PatWeight_"^"_Depdesc_"^"_Paadmdate_"^"_SessHospDesc_"^"_Depcodedr_"^"_PAAdmReason_"^"_PAAdmBed
	q PatInform
}

ClassMethod SavePatInform(AdmRowId, PatInform)
{
	
	s Rtn=0
	s Company=$p(PatInform,"^",1)
	s PapmiDr=$p(^PAADM(AdmRowId),"^",1)
	&sql(update SQLUser.PA_PatMas set PAPMI_SecondPhone=:Company where PAPMI_RowId=:PapmiDr)
	s Rtn=SQLCODE
	q Rtn
}

/// w ##class(web.UDHCPrescript).GetSupplyMethod("")
ClassMethod GetSupplyMethod(nid As %String) As %String
{
	Set ret=""
	Quit:nid="" ret
	s PAPMIDVAnumber=$P($G(^PAPER(nid,"ALL")),"^",9 )  ;身份证 证件类型
    if PAPMIDVAnumber=""  d
 	.s myCredTypeDesc=""
 	.s myCredTypeID=$p($g(^PAPER(nid,"PAT",3)),"^",7)
 	.s:myCredTypeID'="" myCredTypeDesc=$p($g(^PAC("CARD",myCredTypeID)),"^",2)
 	.if myCredTypeDesc["身份证"  d
 	..s PAPMIDVAnumber=$p($g(^PAPER(nid,"PAT",3)),"^",6)
	;Set PAPMIID=$P($G(^PAPER(nid,"PAT",3)),"^",6)
	Set SupplyName=$P($G(^PAPER(nid,"ALL")),"^",23)
	Set SupplyCard=$P($G(^PAPER(nid,"ALL")),"^",24)
	Set ret=PAPMIDVAnumber_"^"_SupplyName_"^"_SupplyCard
	Quit ret
}

/// Date 2015-08-13
/// Description:  PAPERName7代办人姓名  PAPERName8代办人身份证号
/// w ##class(web.UDHCPrescript).CredNoCheck("60","522426198805200874")
ClassMethod CredNoCheck(PatientID As %String, PatInfo As %String) As %String
{
	Q:PatientID="" -100
	s myIDNo=$P(PatInfo,"^",1)
	s DPatName=$P(PatInfo,"^",2)
	s DPatCredNo=$P(PatInfo,"^",3)
	s PatAddress=$P(PatInfo,"^",4)
	TSTART
	s Obj=##class(User.PAPatMas).%OpenId(PatientID)
	if (Obj.PAPMIID="") s Obj.PAPMIID=myIDNo
	s DVANumber=Obj.PAPMIDVAnumber
	s Obj.PAPMIDVAnumber=myIDNo
	s Obj.PAPMIName7=DPatName
	s Obj.PAPMIName8=DPatCredNo
	do Obj.PAPMICardTypeDRSetObjectId(1)
	Set sc=Obj.%Save()
	If $$$ISERR(sc) {
 		Trollback
 		Quit -100
 	}
 	s Object=##class(User.PAPerson).%OpenId(PatientID)
 	s Object.PAPERID=myIDNo
 	s Object.PAPERName7=DPatName
 	s Object.PAPERName8=DPatCredNo
 	Set sc1=Object.%Save()
	If $$$ISERR(sc1) {
 		Trollback
 		Quit -100
 	}
 	TCommit
	q 0
}

ClassMethod SavePatAddress(PatientID As %String, PatAddress As %String) As %String
{
	//s $p(^PAPER(PatientID,"PER","ADD",1),"^",1)=PatAddress
	s person=##class(User.PAPerson).%OpenId(PatientID)
	d person.PAPERStName.Insert(PatAddress)
	Set sc1=person.%Save()
	If $$$ISERR(sc1) {
 		Quit -100
 	}
	
	Q 0
}

ClassMethod GetOrdTreatInfo(EpisodeID As %String, OrdItemList As %String) As %String
{
    s ^tt(EpisodeID)=OrdItemList
    s OrderStr=""
    s PapmiDR=$p($g(^PAADM(EpisodeID)),"^",1)
    s AdmType=$p($g(^PAADM(EpisodeID)),"^",2)
    s AdmDep=$p($g(^PAADM(EpisodeID)),"^",4)
    s AdmDate=$p($g(^PAADM(EpisodeID)),"^",6)
    s AdmReason=$p($g(^PAADM(EpisodeID,1)),"^",7)
    s HospId=""
    i AdmDep'="" s HospId=$p($g(^CTLOC(AdmDep)),"^",22)
    s PAADMRegConDisDR=$P($G(^PAADM(EpisodeID,"DHC")),"^",25)
    for i=1:1:$l(OrdItemList,"^") do
    .s OrdItem=$p(OrdItemList,"^",i)
    .s ord=+OrdItem,chl=$p(OrdItem,"||",2)
    .q:'$d(^OEORD(ord,"I",chl))
    .s OrdStatus=$p($g(^OEORD(ord,"I",chl,1)),"^",13)
    .s:$g(OrdStatus)'="" OrdStatus=$p(^OEC("OSTAT",OrdStatus),"^",1)  ;医嘱状态
    .s:$g(OrdStatus)="" OrdStatus=$g(OrdStatus)
    .s Billed=$p($g(^OEORD(ord,"I",chl,3)),"^",5)
    .Q:Billed="P"      ;已经收费则退出
    .Q:(OrdStatus="I") ;未激活
    .Q:(OrdStatus="E") ;执行
    .Q:(OrdStatus="U") ;未核实
    .Q:(OrdStatus="D")
    .s OEORIARCOSDR=$p($g(^OEORD(ord,"I",chl,3)),"^",10)
    .s ARCICDesc=""
    .if (OEORIARCOSDR'="") d
    ..s ARCOSOrdSubCatDR=$p($g(^ARCOS(OEORIARCOSDR)),"^",9)
    ..s:ARCOSOrdSubCatDR'="" ARCICDesc=$p($g(^ARC("IC",ARCOSOrdSubCatDR)),"^",2)
    .Q:ARCICDesc="计价单"
    .s ArcimId=$p($g(^OEORD(ord,"I",chl,1)),"^",2)
    .s PackQty=$p($g(^OEORD(ord,"I",chl,9)),"^",4)
    .i PackQty="" s PackQty=$p($g(^OEORD(ord,"I",chl,1)),"^",12)
    .s ARCIMText4=$p($g(^ARCIM(+ArcimId,$p(ArcimId,"||",2),9)),"^",35)
    .Q:(ARCIMText4'="CZ")&&(ARCIMText4'="SS")
    .i ARCIMText4="CZ" s Title="处 置 治 疗 单"
    .i ARCIMText4="SS" s Title="手 术 治 疗 单"
    .s ArcimDesc=$p(^ARCIM(+ArcimId,1,1),"^",2)
    .s ArcimDesc=ArcimDesc_" "_PackQty
    .s OrderRecDepRowid=$P($G(^OEORD(ord,"I",chl,3)),"^",6) ;OEORI_RecDep_DR
    .s OEORIDocDr=$P($G(^OEORD(ord,"I",chl,1)),"^",11) ;
    .s OEORIDoc=$p(^CTPCP(OEORIDocDr,1),"^",2) //申请医生
    .s OEORIUserDepartmentDR=$P($G(^OEORD(ord,"I",chl,7)),"^",2)
    .s OEORIUserDepartment=$p(^CTLOC(OEORIUserDepartmentDR),"^",2) //申请科室
    .if OEORIUserDepartment["-" set OEORIUserDepartment=$p(OEORIUserDepartment,"-",2)
    .s OEORIDate=$P($G(^OEORD(ord,"I",chl,3)),"^",7)
    .s OEORIDate=$zd(OEORIDate,3) //申请日期
    .s EstStr=PAADMRegConDisDR_"^"_ord_"||"_chl_"^"_""_"^"_EpisodeID_"^"_OrderRecDepRowid
    .s retPrice=##Class(web.UDHCJFPRICE).GetOrderPrice("",AdmReason,ArcimId,AdmDate,"","","","",HospId,EstStr)
    .s BillPrice=$p(retPrice,"^",1)
    .s BillSum=$fn(BillPrice*PackQty,"",2)_"元"
    .s BillSum=$fn(BillSum,"",2)
    .s OneOrderStr=ArcimDesc_"$"_BillSum_"$"_OEORIUserDepartment_"$"_OEORIDoc_"$"_OEORIDate_"$"_Title
    .i OrderStr="" s OrderStr="  "_OneOrderStr
    .e  s OrderStr=OrderStr_$c(3)_"  "_OneOrderStr
    Q OrderStr
}

ClassMethod GetOrdValuationInfo(EpisodeID As %String, OrdItemList As %String) As %String
{
    s ^rr(EpisodeID)=OrdItemList
    k ^TempOrdValuationInfo("GetOrdValuationInfo",$j)
    s OrderStr=""
    s PapmiDR=$p($g(^PAADM(EpisodeID)),"^",1)
    s AdmType=$p($g(^PAADM(EpisodeID)),"^",2)
    s AdmDep=$p($g(^PAADM(EpisodeID)),"^",4)
    s AdmDate=$p($g(^PAADM(EpisodeID)),"^",6)
    s AdmReason=$p($g(^PAADM(EpisodeID,1)),"^",7)
    s HospId=""
    i AdmDep'="" s HospId=$p($g(^CTLOC(AdmDep)),"^",22)
    s PAADMRegConDisDR=$P($G(^PAADM(EpisodeID,"DHC")),"^",25)
    for i=1:1:$l(OrdItemList,"^") do
    .s OrdItem=$p(OrdItemList,"^",i)
    .s ord=+OrdItem,chl=$p(OrdItem,"||",2)
    .q:ord=0
    .q:'$d(^OEORD(ord,"I",chl))
    .s OrdStatus=$p($g(^OEORD(ord,"I",chl,1)),"^",13)
    .s:$g(OrdStatus)'="" OrdStatus=$p(^OEC("OSTAT",OrdStatus),"^",1)  ;医嘱状态
    .s:$g(OrdStatus)="" OrdStatus=$g(OrdStatus)
    .s Billed=$p($g(^OEORD(ord,"I",chl,3)),"^",5)
    .Q:Billed="P"      ;已经收费则退出
    .Q:(OrdStatus="I") ;未激活
    .Q:(OrdStatus="E") ;执行
    .Q:(OrdStatus="U") ;未核实
    .Q:(OrdStatus="D")
    .s OEORIARCOSDR=$p($g(^OEORD(ord,"I",chl,3)),"^",10)
    .Q:OEORIARCOSDR=""
    .s ARCOSOrdSubCatDR=$p($g(^ARCOS(OEORIARCOSDR)),"^",9)
    .Q:ARCOSOrdSubCatDR=""
    .s ARCICDesc=$p($g(^ARC("IC",ARCOSOrdSubCatDR)),"^",2)
    .Q:ARCICDesc'="计价单"
    .s ^TempOrdValuationInfo("GetOrdValuationInfo",$j,OEORIARCOSDR,$p(OrdItem,"||",2))=OrdItem
    s OEORIARCOSDR=0
    f  s OEORIARCOSDR=$o(^TempOrdValuationInfo("GetOrdValuationInfo",$j,OEORIARCOSDR)) Q:OEORIARCOSDR=""  d
    .s ARCOSDesc=$p(^ARCOS(OEORIARCOSDR),"^",2)
    .i ARCOSDesc["-" s ARCOSDesc=$p(ARCOSDesc,"-",2)
    .s ARCOSDesc=ARCOSDesc_":"
    .s Sub=0,OneOrderStr="",OneARCOSSum=0
    .f  s Sub=$o(^TempOrdValuationInfo("GetOrdValuationInfo",$j,OEORIARCOSDR,Sub)) Q:Sub=""  d
    ..s OrdItem=$g(^TempOrdValuationInfo("GetOrdValuationInfo",$j,OEORIARCOSDR,Sub))
    ..s ord=+OrdItem,chl=$p(OrdItem,"||",2)
    ..s ArcimId=$p($g(^OEORD(ord,"I",chl,1)),"^",2)
    ..s PackQty=$p($g(^OEORD(ord,"I",chl,9)),"^",4)
    ..i PackQty="" s PackQty=$p($g(^OEORD(ord,"I",chl,1)),"^",12)
    ..s ArcimDesc=$p(^ARCIM(+ArcimId,1,1),"^",2)
    ..s ArcimDesc=ArcimDesc //_"测试测试测试测试测试测试测试测试测试测试"
    ..s ARCIMDescLength=$l(ArcimDesc)
    ..i ARCIMDescLength>20 s ArcimDesc=$e(ArcimDesc,1,20)_""
    ..//s ArcimDesc=$replace(ArcimDesc,"测试"," ")
    ..s ArcimDesc="  "_ArcimDesc_" X "_PackQty
    ..s OEORIDocDr=$P($G(^OEORD(ord,"I",chl,1)),"^",11) ;
    ..s OEORIDoc=$p(^CTPCP(OEORIDocDr,1),"^",2) //申请医生
    ..s OEORIUserDepartmentDR=$P($G(^OEORD(ord,"I",chl,7)),"^",2)
    ..s OEORIUserDepartment=$p(^CTLOC(OEORIUserDepartmentDR),"^",2) //申请科室
    ..if OEORIUserDepartment["-" set OEORIUserDepartment=$p(OEORIUserDepartment,"-",2)
    ..s OEORIDate=$P($G(^OEORD(ord,"I",chl,3)),"^",7)
    ..s OEORIDate=$zd(OEORIDate,3) //申请日期
    ..s OrderRecDepRowid=$P($G(^OEORD(ord,"I",chl,3)),"^",6) ;OEORI_RecDep_DR
    ..s EstStr=PAADMRegConDisDR_"^"_ord_"||"_chl_"^"_""_"^"_EpisodeID_"^"_OrderRecDepRowid
    ..s retPrice=##Class(web.UDHCJFPRICE).GetOrderPrice("",AdmReason,ArcimId,AdmDate,"","","","",HospId,EstStr)
    ..s BillPrice=$p(retPrice,"^",1)
    ..s OneARCOSSum=OneARCOSSum+BillPrice*PackQty
    ..//s BillSum=$fn(BillPrice*PackQty,"",2)_"元"
    ..i OneOrderStr="" s OneOrderStr=ArcimDesc
    ..e  s OneOrderStr=OneOrderStr_$c(3)_ArcimDesc
    .s Title="计费单"
    .s OneARCOSOrdInfo=Title_"$"_$fn(OneARCOSSum,"",2)_"$"_OEORIDate_"$"_OEORIUserDepartment_"$"_OEORIDoc_"$"_ARCOSDesc_"$"_OneOrderStr
    .i OrderStr="" s OrderStr="  "_OneARCOSOrdInfo
    .e  s OrderStr=OrderStr_$c(1)_"  "_OneARCOSOrdInfo
    k ^TempOrdValuationInfo("GetOrdValuationInfo",$j)
    Q OrderStr
}

// w ##class(web.UDHCPrescript).GetOutBuyInfo(710,"636||3^636||4")

ClassMethod GetOutBuyInfo(EpisodeID As %String, OrdItemList As %String) As %String
{
	s ^tan("GetOutBuyInfo")=EpisodeID_","_OrdItemList
    k OutBuyInfoList("GetOutBuyInfo")
    s OEECCatID="14"
    s OrderStr=""
    s PapmiDR=$p($g(^PAADM(EpisodeID)),"^",1)
    s AdmType=$p($g(^PAADM(EpisodeID)),"^",2)
    s AdmDep=$p($g(^PAADM(EpisodeID)),"^",4)
    s AdmDate=$p($g(^PAADM(EpisodeID)),"^",6)
    s AdmReason=$p($g(^PAADM(EpisodeID,1)),"^",7)
    s HospId=""
    i AdmDep'="" s HospId=$p($g(^CTLOC(AdmDep)),"^",22)
    s PAADMRegConDisDR=$P($G(^PAADM(EpisodeID,"DHC")),"^",25)
    for i=1:1:$l(OrdItemList,"^") do
    .s OrdItem=$p(OrdItemList,"^",i)
    .s ord=+OrdItem,chl=$p(OrdItem,"||",2)
    .q:ord=0
    .q:'$d(^OEORD(ord,"I",chl))
    .s OrdStatus=$p($g(^OEORD(ord,"I",chl,1)),"^",13)
    .s:$g(OrdStatus)'="" OrdStatus=$p(^OEC("OSTAT",OrdStatus),"^",1)  ;医嘱状态
    .s:$g(OrdStatus)="" OrdStatus=$g(OrdStatus)
    .s Billed=$p($g(^OEORD(ord,"I",chl,3)),"^",5)
    .Q:Billed="P"      ;已经收费则退出
    .Q:(OrdStatus="I") ;未激活
    .Q:(OrdStatus="E") ;执行
    .Q:(OrdStatus="U") ;未核实
    .Q:(OrdStatus="D")
    .
    .
    .s ARCIMRowId=$p($g(^OEORD(ord,"I",chl,1)),"^",2)
    .s ItemCatRowid=$p($g(^ARCIM(+ARCIMRowId,$p(ARCIMRowId,"||",2),1)),"^",10)
    .s OrderType=$P(^ARC("IC",ItemCatRowid),"^",8)
    .q:OEECCatID'=OrderType
    .s PrescNo=$P($G(^OEORD(ord,"I",chl,1)),"^",14)
    .;w ^OEORD(ord,"I",chl,1),!
    .q:PrescNo=""
    .;w PrescNo,!
    .s OutBuyInfoList("GetOutBuyInfo",PrescNo)=""
    s OutBuyInfo=""
    s PrescNo="0"
    for {
		s PrescNo=$O(OutBuyInfoList("GetOutBuyInfo",PrescNo))
		q:PrescNo=""
		s PrescListInfo=##class(web.DHCDocPrescriptJSSZY).GetPrescListInfo(PrescNo)
		continue:PrescListInfo=""
		if (OutBuyInfo=""){
			s OutBuyInfo=PrescListInfo
		}else{
			s OutBuyInfo=OutBuyInfo_"PerDlim"_PrescListInfo
		}
	}
    
    
    k OutBuyInfoList("GetOutBuyInfo")
    Q OutBuyInfo
}

/// w ##class(web.UDHCPrescript).GetPrescNoList(13)
ClassMethod GetPrescNoList(EpisodeID As %String) As %String
{

    s PrescNoList=""
    q:($g(EpisodeID)="") PrescNoList
    q:'$d(^OEORD(0,"Adm",EpisodeID)) PrescNoList
    s OrdId1=$o(^OEORD(0,"Adm",EpisodeID,0))
    s PatientID=$P(^PAADM(EpisodeID),"^",1)
    s PAADMRegConDisDR=$P($G(^PAADM(EpisodeID,"DHC")),"^",25)
    q:OrdId1=""
    s OrdId2=0
    s OrdCreateDate="",OrdCreateTime="",OrdStartDate="",OrdStartTime="",ArcimDesc=""
    for {
        s OrdId2=$o(^OEORD(OrdId1,"I",OrdId2))
        q:OrdId2=""
        s OEItemID=OrdId1_"||"_OrdId2
        s ordstr1=$g(^OEORD(OrdId1,"I",OrdId2,1))
        s ordstr2=$g(^OEORD(OrdId1,"I",OrdId2,2))
        s ordstr3=$g(^OEORD(OrdId1,"I",OrdId2,3))
        s ordstr5=$g(^OEORD(OrdId1,"I",OrdId2,5))
        s ordstr9=$g(^OEORD(OrdId1,"I",OrdId2,9))
        s ordstr11=$g(^OEORD(OrdId1,"I",OrdId2,11))
    
        s OrdStatusDR=$p(ordstr1,"^",13)
        s:$g(OrdStatusDR)'="" OrdStatus=$p(^OEC("OSTAT",OrdStatusDR),"^",2),OrdStatusCode=$p(^OEC("OSTAT",OrdStatusDR),"^",1)
        s:$g(OrdStatusDR)="" OrdStatus=$g(OrdStatusDR),OrdStatusCode=""
        continue:((OrdStatusCode'="V")&(OrdStatusCode'="E"))   
        s PrescNo=$p(ordstr1,"^",14)
        continue:PrescNo=""
        continue:("^"_PrescNoList_"^")[("^"_PrescNo_"^")
        if (PrescNoList=""){
            s PrescNoList=PrescNo
        }else{
            s PrescNoList=PrescNoList_"^"_PrescNo
        }
    }
    q PrescNoList
}

/// /w ##Class(web.UDHCPrescript).GetEMRSignUseID(878,600,"OPEMR")
ClassMethod GetEMRSignUseID(AdmRowId As %String, UserID As %String, EMRType As %String, Type As %String = "OPEMR") As %String
{
	s ^tan("GetEMRSignUseID")=AdmRowId_","_UserID_","_EMRType
    //s arr=##Class(EMRservice.HISInterface.BOExternal).ScatterDataForOP(AdmRowId)
    s arr=##Class(web.UDHCPrescript).GetUserScatterDataForOP(AdmRowId,UserID,EMRType)
    q:arr="" ""
    ///病历签字姓名
    s UserName=""
    if (EMRType="OPEMR"){
        ///门诊病历签字人
        s UserName=arr.GetAt($G(^DHCDocLocalSysP("EMR","OPEMRUserName")))
    }elseif (EMRType="EMRCertificate"){
        ///疾病诊断证明书签字人
        s UserName=arr.GetAt($G(^DHCDocLocalSysP("EMR","EMRCertificateUserName")))
    }elseif (EMRType="OPEMRReturn"){
        ///复诊病历签字人
        s UserName=arr.GetAt($G(^DHCDocLocalSysP("EMR","OPEMRReturnUserName")))
    }
    ///
    s UsrID=arr.GetAt("signUsrID")
    if (UserName="")&&(UsrID'=""){
        s UserName=$P($G(^SSU("SSUSR",UsrID)),"^",2)
    }
    q UsrID_"^"_UserName
}

/// //s arr=##Class(web.UDHCPrescript).GetUserScatterDataForOP("878","600","OPEMR")
ClassMethod GetUserScatterDataForOP(AdmRowId As %String, UserID As %String, EMRType As %String) As %ArrayOfDataTypes
{
    s ^tan("GetUserScatterDataForOP")=AdmRowId_","_UserID_","_EMRType
    s OutPutData = ##Class(%ArrayOfDataTypes).%New()
    s arr=##Class(EMRservice.HISInterface.BOExternal).ScatterDataForOP(AdmRowId)
    q:arr="" ""
    s AInstanceID=0
    for
    {
        s OneEMRData = arr.GetNext(.AInstanceID)
        //b ;12
        q:(AInstanceID = "")
        /*
        s key = ""		
		do
		{ 			
	    	s item = OneEMRData.GetNext(.key)
	    	w "key:"_key_"   "_item,!
		} while (key '="")
        */
        s OneEMRDataUserID=OneEMRData.GetAt("signUsrID")
        continue:(OneEMRDataUserID'=UserID)
        s SignName=""
        if (EMRType="OPEMR"){
            ///门诊病历签字人
            s SignName=OneEMRData.GetAt($G(^DHCDocLocalSysP("EMR","OPEMRUserName")))
        }
        if (EMRType="OPEMRReturn"){
            ///复诊病历签字人
            s SignName=OneEMRData.GetAt($G(^DHCDocLocalSysP("EMR","OPEMRReturnUserName")))
        }
        
        if (EMRType="EMRCertificate"){
            ///疾病诊断证明书签字人
            s SignName=OneEMRData.GetAt($G(^DHCDocLocalSysP("EMR","EMRCertificateUserName")))
        }
        //w AInstanceID_","_SignName,!
        continue:SignName=""
        s OutPutData=OneEMRData
        //w OneEMRDataUserID_"^"_SignName
        //b
        ///取最后一个，不要在这个地方quit
    }
    q OutPutData
}

/// /w ##Class(web.UDHCPrescript).GetEMRCertificateInfo(128,2543)
ClassMethod GetEMRCertificateInfo(AdmRowId As %String, UserID As %String) As %String
{
    //s arr=##Class(EMRservice.HISInterface.BOExternal).ScatterDataForOP(AdmRowId)
    s arr=##Class(web.UDHCPrescript).GetUserScatterDataForOP(AdmRowId,UserID,"EMRCertificate")
    q:arr="" $C(1)_$C(1)_$C(1)_$C(1)_$C(1)_$C(1)_$C(1)
    ////工作单位
    s GZDW=arr.GetAt($G(^DHCDocLocalSysP("EMR","EMRCertificateGZDW")))
    ////临床诊断
    s LCZD=arr.GetAt($G(^DHCDocLocalSysP("EMR","EMRCertificateLCZD")))
    ////临床建议
    s LCJY=arr.GetAt($G(^DHCDocLocalSysP("EMR","EMRCertificateLCJY")))
    ////医师
    s LCYS=arr.GetAt($G(^DHCDocLocalSysP("EMR","EMRCertificateUserName")))
    ////日期
    s RQ=arr.GetAt($G(^DHCDocLocalSysP("EMR","EMRCertificateRQ")))
    s split="|||"
    s OutPut= LCYS_$C(1)_RQ_$C(1)_LCZD_$C(1)_GZDW_$C(1)_"临床诊断:^"_LCZD_split_"建  议  :^"_LCJY
    q OutPut
}

/// w ##Class(web.UDHCPrescript).GetEMRInfo(13436,2893,"OPEMRReturn")
ClassMethod GetEMRInfo(AdmRowId As %String, UserID As %String, Type As %String = "OPEMR") As %String
{
    //s arr=##Class(EMRservice.HISInterface.BOExternal).ScatterDataForOP(AdmRowId)
    s arr=##Class(web.UDHCPrescript).GetUserScatterDataForOP(AdmRowId,UserID,Type)
    q:arr="" "^"
    s split="|||"
	s divide="!"
    if (Type="OPEMRReturn"){
	    ///   HDSD00.03.241
	    s FZ=arr.GetAt($G(^DHCDocLocalSysP("EMR","OPEMRReturnFZNR")))
	    ////处置 
		s CZ=arr.GetAt($G(^DHCDocLocalSysP("EMR","OPEMRReturnCZ")))
	    s OutPut= "复诊内容:^"_FZ_split_"处置:^"_CZ
	    b
	    q OutPut
    }elseif (Type="OPEMR"){
	    ////主诉
	    s ZS=arr.GetAt($G(^DHCDocLocalSysP("EMR","OPEMRUserZS")))
	    ////病史
	    s BS=arr.GetAt($G(^DHCDocLocalSysP("EMR","OPEMRUserBS")))
	    ////体格检查
	    s TGJC=arr.GetAt($G(^DHCDocLocalSysP("EMR","OPEMRUserTGJC")))
	    ////实验室检查 
	    s SYSJC=arr.GetAt($G(^DHCDocLocalSysP("EMR","OPEMRUserSYSJC")))
	    ////处理       
	    s CL=arr.GetAt($G(^DHCDocLocalSysP("EMR","OPEMRUserCL")))
	    ///病历签字姓名
	    s UserName=arr.GetAt($G(^DHCDocLocalSysP("EMR","OPEMRUserName")))
	    ///
	    s UsrID=arr.GetAt("signUsrID")
	    s split="|||"
	    s OutPut= "主   诉   :^"_ZS_split_"病   史   :^"_BS_split_"体格检查  :^"_TGJC_split_"实验室检查:^"_SYSJC //_split_"处   理   :^"_CL
	    q OutPut
	}
    q ""
}

/// 一键打印 病历打印 诊断方法
/// //w ##Class(web.UDHCPrescript).GetMRDiagnosDesc(128)
ClassMethod GetMRDiagnosDesc(MRAdmRowid As %String, DelimStr As %String = "", LogLocId As %String = "") As %String
{
    s ^tan("GetMRDiagnosDesc")=MRAdmRowid_","_DelimStr
    s retval=""
    s i=0
    s XYDiagList=""
    s ZYDiagList=""
    Set obj=##class(%ResultSet).%New("web.DHCMRDiagnosNew:DiagnosList")
    d obj.Execute(MRAdmRowid,"","",LogLocId)
    For   {
        Quit:'obj.Next()
        s Desc=$replace(obj.Data("DiagnosDesc"),"&nbsp&nbsp"," ")
        s Desc=$replace(Desc," ","")
        s MRDesc=obj.Data("DiagnosMRDesc")
        if (Desc=""){
            s Desc=MRDesc
        }elseif (MRDesc'=""){
            s Desc=Desc_"-"_MRDesc
        }
        s DiagStat=obj.Data("DiagStat")
        if (DiagStat'="确诊"){
            s Desc=Desc_"?"
        }
        s DiagnosCat=obj.Data("DiagnosCat")
        
        if (DiagnosCat="西医"){
            if (XYDiagList="") s XYDiagList=Desc
            e  s XYDiagList=XYDiagList_"^"_Desc
        }else{
            if (ZYDiagList="") { s ZYDiagList=Desc}
            else{
                if (DiagnosCat="证候"){
                    s ZYDiagList=ZYDiagList_"("_Desc_")"
                }else{
                    s ZYDiagList=ZYDiagList_"^"_Desc
                }
                //s ZYDiagList=ZYDiagList_"^"_Desc
            }
            
        }
    }
    d obj.Close()
    q XYDiagList_"||"_ZYDiagList
}

/// /w ##Class(web.UDHCPrescript).GetSOrdInfo(121)
/// 获取除药品以外的医嘱
ClassMethod GetSOrdInfo(AdmRowId As %String) As %String
{
    s OrderInfo=""
    s Num=0
    k SOrdInfoArr
    s OEOrd=$O(^OEORD(0,"Adm",AdmRowId,""),-1)
    s Sub=0
    for {
        s Sub=$O(^OEORD(OEOrd,"I",Sub))
        q:Sub=""
        continue:'$D(^OEORD(OEOrd,"I",Sub,1))
        s ARCIMDr=$P(^OEORD(OEOrd,"I",Sub,1),"^",2)
        s ArcimName=$P(^ARCIM(+ARCIMDr,$P(ARCIMDr,"||",2),1),"^",2)
        s OrdDepProcNotes= $g(^OEORD(OEOrd,"I",Sub,"DEP",1))  ;取备注
        i ArcimName["嘱托"  s ArcimName=OrdDepProcNotes
        //s ArcimName=$p(ArcimName,"[",1) //门诊病历打印去掉规格
        s ItemCatRowid=$p($g(^ARCIM(+ARCIMDr,$p(ARCIMDr,"||",2),1)),"^",10)
        s ItemCatDesc=$P(^ARC("IC",ItemCatRowid),"^",2)
        //continue:ItemCatDesc="卫生材料"
        s OrderType=$P(^ARC("IC",ItemCatRowid),"^",7)
        s OrdcatDR=$p(^ARC("IC",ItemCatRowid),"^",8)
	s OrdcatDesc=$p($g(^OEC("ORCAT",OrdcatDR)),"^",2)
	continue:OrdcatDesc["嘱托"									////嘱托单独打印
        s OEORIDoctorDR=$P($g(^OEORD(OEOrd,"I",Sub,1)),"^",11)
        //b //12
        continue:OEORIDoctorDR=""
        continue:OrderType="R"
        s TtemStat=$P($G(^OEORD(OEOrd,"I",Sub,1)),"^",13) ;OEORI_Billed
        s statcode=""
        i TtemStat'="" {
            s statcode=$p($g(^OEC("OSTAT",TtemStat)),"^",1)
        }
        
        continue:(statcode'="V")&&(statcode'="E")
        s PhyQtyOrd=$P($G(^OEORD(OEOrd,"I",Sub,1)),"^",12) ;OEORI_PhQtyOrd
        s ReqPartDesc=##Class(web.DHCAPPInterface).GetExaReqPartDesc(OEOrd_"||"_Sub)
		s ArcimName=ArcimName_ReqPartDesc
        s OneOrdInfo=ArcimName_"X"_PhyQtyOrd
        if ($G(SOrdInfoArr(OrderType))=""){
            s SOrdInfoArr(OrderType)=OneOrdInfo
        }else{
            s SOrdInfoArr(OrderType)=SOrdInfoArr(OrderType)_"-|-"_OneOrdInfo
        }
    }
    s OrderType=""
    for {
        s OrderType=$O(SOrdInfoArr(OrderType))
        q:OrderType=""
        s OneOrdInfo=$G(SOrdInfoArr(OrderType))
        continue:OneOrdInfo=""
        if (OrderInfo=""){
            s OrderInfo=OneOrdInfo
        }else{
            s OrderInfo=OrderInfo_$C(2)_OneOrdInfo
        }
    }
    q OrderInfo
}

/// 获取嘱托的医嘱
ClassMethod GetZTOrdInfo(AdmRowId As %String) As %String
{
    s OrderInfo=""
    s Num=0
    k SOrdInfoArr
    s OEOrd=$O(^OEORD(0,"Adm",AdmRowId,""),-1)
    s Sub=0
    for {
        s Sub=$O(^OEORD(OEOrd,"I",Sub))
        q:Sub=""
        continue:'$D(^OEORD(OEOrd,"I",Sub,1))
        s ARCIMDr=$P(^OEORD(OEOrd,"I",Sub,1),"^",2)
        s ArcimName=$P(^ARCIM(+ARCIMDr,$P(ARCIMDr,"||",2),1),"^",2)
        s OrdDepProcNotes= $g(^OEORD(OEOrd,"I",Sub,"DEP",1))  ;取备注

        s ItemCatRowid=$p($g(^ARCIM(+ARCIMDr,$p(ARCIMDr,"||",2),1)),"^",10)
        s OrderType=$P(^ARC("IC",ItemCatRowid),"^",7)
        s OrdcatDR=$p(^ARC("IC",ItemCatRowid),"^",8)
		s OrdcatDesc=$p($g(^OEC("ORCAT",OrdcatDR)),"^",2)
		continue:OrdcatDesc'["嘱托"											////嘱托单独打印
		continue:OrdDepProcNotes=""
        s OEORIDoctorDR=$P($g(^OEORD(OEOrd,"I",Sub,1)),"^",11)
        continue:OEORIDoctorDR=""
        s TtemStat=$P($G(^OEORD(OEOrd,"I",Sub,1)),"^",13) ;OEORI_Billed
        s statcode=""
        i TtemStat'="" {
            s statcode=$p($g(^OEC("OSTAT",TtemStat)),"^",1)
        }
        
        continue:(statcode'="V")&&(statcode'="E")
        s Num=Num+1
         if (OrderInfo=""){
            s OrderInfo=""_Num_"、"_OrdDepProcNotes
        }else{
            s OrderInfo=OrderInfo_$C(2)_""_Num_"、"_OrdDepProcNotes
        }

    }
    q OrderInfo
}

/// /w ##Class(web.UDHCPrescript).GetOrdInfo(128)
ClassMethod GetOrdInfo(AdmRowId As %String) As %String
{
    s ^tan("GetOrdInfo")=AdmRowId
    s OrderInfo=""
    s Num=0
    s CMSubCategory=##Class(web.DHCDocOrderCommon).GetCNMedItemCatStr()
    s OEOrd=$O(^OEORD(0,"Adm",AdmRowId,""),-1)
    s Sub=0
    for {
        s Sub=$O(^OEORD(OEOrd,"I",Sub))
        q:Sub=""
        continue:'$D(^OEORD(OEOrd,"I",Sub,1))
        s ARCIMDr=$P(^OEORD(OEOrd,"I",Sub,1),"^",2)
        s ArcimName=$P(^ARCIM(+ARCIMDr,$P(ARCIMDr,"||",2),1),"^",2)
        s ArcimName=$p(ArcimName,"[",1)
        
        s ItemCatRowid=$p($g(^ARCIM(+ARCIMDr,$p(ARCIMDr,"||",2),1)),"^",10)
        continue:("^"_CMSubCategory_"^")[("^"_ItemCatRowid_"^")
        
        
        //w ArcimName_"@@@"_ItemCatRowid_"@@"_CMKLSubCategory_"@@@"_$P(^ARC("IC",ItemCatRowid),"^",2),!
        s OrderType=$P(^ARC("IC",ItemCatRowid),"^",7)
        continue:OrderType'="R"
        s TtemStat=$P($G(^OEORD(OEOrd,"I",Sub,1)),"^",13) ;OEORI_Billed
        s statcode=""
        i TtemStat'="" {
            s statcode=$p($g(^OEC("OSTAT",TtemStat)),"^",1)
        }
        
        continue:(statcode'="V")&&(statcode'="E")

        s OrderInstrRowid=$P($G(^OEORD(OEOrd,"I",Sub,2)),"^",7)
        //w ArcimName_","_OrderInstrRowid,!
        s OrderInstrDesc=$$ALPHAUP^SSUTIL4($p(^PHCIN(OrderInstrRowid),"^",2))
        
        s OrderDoseQty=$P($G(^OEORD(OEOrd,"I",Sub,2)),"^",1) ;OEORI_DoseQty
        s OrderDoseUOMRowid=$P($G(^OEORD(OEOrd,"I",Sub,2)),"^",3) ;OEORI_Unit_DR
        s ItemDoseUOM=$P($G(^CT("UOM",OrderDoseUOMRowid)),"^",2)
        
        s OrderFreqRowid=$P($G(^OEORD(OEOrd,"I",Sub,2)),"^",4) ; OEORI_PHFreq_DR
        s OrderFreqDesc=$P($g(^PHCFR(OrderFreqRowid)),"^",3) //$P($g(^PHCFR(OrderFreqRowid)),"^",2)
        
        s OrderPackUOM=""
        s OrderPackQty=$P($G(^OEORD(OEOrd,"I",Sub,9)),"^",4) ;OEORIQtyPackUOM
        s PackUOMDR=$p($g(^OEORD(OEOrd,"I",Sub,"DHC")),"^",13)
        i PackUOMDR'="" {
            s OrderPackUOM=$p($g(^CT("UOM",PackUOMDR)),"^",2)
        }
        s OrderPackUOM=$p(OrderPackUOM,"(",1)
        //b //OrderFreqDesc
        s MainOEORIDR=$P($G(^OEORD(OEOrd,"I",Sub,11)),"^",39)
        if (MainOEORIDR=""){
            s Num=Num+1
            s OneOrderInfo=Num_"、"_ArcimName_"*"_OrderPackQty_OrderPackUOM_"^"_OrderDoseQty_ItemDoseUOM_"^"_OrderFreqDesc_"^"_OrderInstrDesc
        }else{
            s OneOrderInfo="   "_ArcimName_"^"_"   "_OrderDoseQty_ItemDoseUOM_"^^"
        }
        if (OrderInfo=""){
            s OrderInfo=OneOrderInfo
        }else{
            s OrderInfo=OrderInfo_$C(2)_OneOrderInfo
        }
        
    }
    
    q OrderInfo
}

/// /w ##Class(web.UDHCPrescript).GetCMOrdInfo(121)
ClassMethod GetCMOrdInfo(AdmRowId As %String) As %String
{
    s ^tan("GetCMOrdInfo")=AdmRowId
    s OrderInfo=""
    ///设置每行应该显示几个草药
    s CountH=2
    s OEOrd=$O(^OEORD(0,"Adm",AdmRowId,""),-1)
    s QUE1RowID=0
    for {
        s QUE1RowID=$O(^PAQUE1(0,"QUE1_PAADM_DR",AdmRowId,QUE1RowID))
        q:QUE1RowID=""
        s OnePrescInfo=""
        s PrescNo=$P(^PAQUE1(QUE1RowID),"^",14)
        continue:PrescNo=""
        s PAQDHCStr=$G(^PAQUE1(QUE1RowID,"DHC"))
        if (PAQDHCStr=""){
            s PAQDHCStr=$G(^PAQUE1Log(QUE1RowID,"DHC"))
        }
        ;w QUE1RowID_","_PAQDHCStr,!
        continue:PAQDHCStr=""
        s PrescCookMode=$P(PAQDHCStr,"^",15)
        s prestype=$p(PAQDHCStr,"^",2)
        
        continue:prestype'="3"          ///草药处方应该都有煎药方式才对吧-，-
        s Sub=0
        s count=0
        for {
            s Sub=$O(^OEORD(0,"PrescNo",$$ALPHAUP^SSUTIL4(PrescNo),OEOrd,Sub))
            q:Sub=""
            s TtemStat=$P($G(^OEORD(OEOrd,"I",Sub,1)),"^",13) ;OEORI_Billed
            s statcode=""
            i TtemStat'="" {
                s statcode=$p($g(^OEC("OSTAT",TtemStat)),"^",1)
            }
            continue:(statcode'="V")&&(statcode'="E")
            s count=count+1
            s ARCIMDr=$P(^OEORD(OEOrd,"I",Sub,1),"^",2)
            s ArcimName=$P(^ARCIM(+ARCIMDr,$P(ARCIMDr,"||",2),1),"^",2)
            //门诊病历草药医嘱去掉[内的内容
            s ArcimName=$p(ArcimName,"[",1) 
            s DoseQty=$P($G(^OEORD(OEOrd,"I",Sub,2)),"^",1)
            s OrderDoseUOMRowid=$P($G(^OEORD(OEOrd,"I",Sub,2)),"^",3)
            s ItemDoseUOM=$P($G(^CT("UOM",OrderDoseUOMRowid)),"^",2)
            s PhSpecInstr=$P($G(^OEORD(OEOrd,"I",Sub,2)),"^",8)
            s PhSpecInstrCode=##Class(web.UDHCPrescript).PhSpecInstrDesc(PhSpecInstr)
            //s PhSpecInstrCode="测试"
            if (PhSpecInstrCode'=""){
                s PhSpecInstrCode="("_PhSpecInstrCode_")"
            }
            if (count#CountH)=1{
                //if (OnePrescInfo="") s OnePrescInfo=ArcimName_"  "_DoseQty_ItemDoseUOM_"  "_PhSpecInstrCode
                //e  s OnePrescInfo=OnePrescInfo_"&"_ArcimName_"  "_DoseQty_ItemDoseUOM_"  "_PhSpecInstrCode
                if (OnePrescInfo="") s OnePrescInfo=ArcimName_"  "_PhSpecInstrCode_" "_DoseQty_ItemDoseUOM
                e  s OnePrescInfo=OnePrescInfo_"&"_ArcimName_"  "_PhSpecInstrCode_" "_DoseQty_ItemDoseUOM
            }else{
                //s OnePrescInfo=OnePrescInfo_"#"_ArcimName_"  "_DoseQty_ItemDoseUOM_"  "_PhSpecInstrCode
                s OnePrescInfo=OnePrescInfo_"#"_ArcimName_"  "_PhSpecInstrCode_" "_DoseQty_ItemDoseUOM
            }   
        }
        continue:OnePrescInfo=""
        ///补齐最后一行的数据
        for i=1:1:(count#CountH) {
            s OnePrescInfo=OnePrescInfo_"#"
        }
        
        
        s OrderDurRowid=$P(^PAQUE1(QUE1RowID,"DHC"),"^",10)
        s OrderDurDesc=$P($g(^PHCDU(OrderDurRowid)),"^",3)
        s PrescInstrRowid=$P(^PAQUE1(QUE1RowID,"DHC"),"^",11)
        s OrderInstrDesc=$$ALPHAUP^SSUTIL4($p(^PHCIN(PrescInstrRowid),"^",2))
        s PrescCookModeDesc=##Class(web.UDHCPrescript).CookModeDesc(PrescCookMode)
        
        if (OrderInfo="") s OrderInfo=OnePrescInfo_"||"_OrderDurDesc_"  "_PrescCookModeDesc
        e  s OrderInfo=OrderInfo_$C(2)_OnePrescInfo_"||"_OrderDurDesc_"  "_PrescCookModeDesc
    }
    q OrderInfo
}

/// /w ##Class(web.UDHCPrescript).PhSpecInstrDesc(1)
ClassMethod PhSpecInstrDesc(PhSpecCode As %String, CurLogonHosp As %String = "") As %String
{
    s PhSpecDesc=""
    q:PhSpecCode="" PhSpecDesc
    s PhSpecInstrList=..%GetConfig("CNMedItemPhSpecInstr",CurLogonHosp)
    ///1"_$c(1)_"先煎^2"_$c(1)_"后下^3"_$c(1)_"包煎^4"_$c(1)_"另煎^5"_$c(1)_"捣碎^6"_$c(1)_"烊化^7"_$c(1)_"冲服^8"_$c(1)_"煎汤代水"
    for i=1:1:$length(PhSpecInstrList,"^") {
        s Instr=$P(PhSpecInstrList,"^",i)
        if ($P(Instr,$c(1),1)=PhSpecCode){
            s PhSpecDesc=$P(Instr,$c(1),2)
        }
        q:PhSpecDesc'=""
    }
    q PhSpecDesc
}

/// /w ##Class(web.UDHCPrescript).CookModeDesc(7)
ClassMethod CookModeDesc(CookModeCode As %String, CurLogonHosp As %String = "") As %String
{
    s CookModeDesc=""
    q:CookModeCode="" CookModeDesc
    
    s CookModeStr=..%GetConfig("CNMedCookMode",CurLogonHosp)
    for i=1:1:$length(CookModeStr,"^") {
        s CookMode=$P(CookModeStr,"^",i)
        if ($P(CookMode,$c(1),1)=CookModeCode){
            s CookModeDesc=$P(CookMode,$c(1),2)
        }
        q:CookModeDesc'=""
    }
    
    q CookModeDesc
}

/// Debug:w ##class(web.UDHCPrescript).GetDocGifCode(18881)
ClassMethod GetDocGifCode(USERID As %String) As %String
{
    s Base64=""
    q:USERID="" Base64
    ;Modify20230521 统一入口到医生站CA业务类
    s Base64=##class(web.DHCDocSignVerify).GetImageByUserID(USERID)
    q Base64
    
    s obj=##CLass(CA.UsrSignatureInfo).GetCertName(USERID)
    if $IsObject(obj) {
        s Base64=obj.SignImage
    }
    q Base64
}

/// w ##class(web.UDHCPrescript).GetOrdItemInfoNew(3085,"2939||3")
ClassMethod GetOrdItemInfoNew(EpisodeID As %String, OrdItemList As %String) As %String
{
	s ^tmpa0("GetOrdItemInfo")=EpisodeID_","_OrdItemList
	s Space="    "
	s PapmiDR=$P($g(^PAADM(EpisodeID)),"^",1)
	s AdmType=$p($g(^PAADM(EpisodeID)),"^",2)
	s AdmDep=$p($g(^PAADM(EpisodeID)),"^",4)
	//就诊科室是感染的，检验的接受位置是固定的
	s GRKAdmDepAddress=""
	//i AdmDep="52" s GRKAdmDepAddress="感染科护士站"
	s AdmDate=$p($g(^PAADM(EpisodeID)),"^",6)
	s AdmReason=$p($g(^PAADM(EpisodeID,1)),"^",7)
	i AdmDep'="" s HospId=$p($g(^CTLOC(AdmDep)),"^",22)
	//获取医院温馨提示接口
    s HospGuideTips=##class(DHCDoc.DHCDocConfig.PatGuide).GetHospTip(HospId)
	s PAADMRegConDisDR=$P($G(^PAADM(EpisodeID,"DHC")),"^",25)
	s OrdItemInfo=""
	s Pline="--------------------------------------------------------------"
	k DrugPrescList
	k OrdTypeList
	s OtherSum=0
	for i=1:1:$l(OrdItemList,"^") {
		s OrdItem=$p(OrdItemList,"^",i)
	    s ord=+OrdItem,chl=$p(OrdItem,"||",2)
	    Continue:'$d(^OEORD(ord,"I",chl,1))
	    s Sttdate=$p(^OEORD(ord,"I",chl,1),"^",9)
	    s doctor=$p(^OEORD(ord,"I",chl,1),"^",11)
	    s:$g(doctor)'="" doctor=$p(^CTPCP(doctor,1),"^",2)
	    s:$g(doctor)="" doctor=""
	    s OrdStatus=$p($g(^OEORD(ord,"I",chl,1)),"^",13)
	    s:$g(OrdStatus)'="" OrdStatus=$p(^OEC("OSTAT",OrdStatus),"^",1)  ;医嘱状态
	    s:$g(OrdStatus)="" OrdStatus=$g(OrdStatus)
	    s Billed=$p($g(^OEORD(ord,"I",chl,3)),"^",5)
	    //b ;Q:Billed="P"      ;已经收费则退出
	    Continue:(OrdStatus="I") ;未激活
	    Continue:(OrdStatus="E") ;执行
	    Continue:(OrdStatus="U") ;未核实
	    //Continue:(OrdStatus="D")
	    s ArcimId=$p($g(^OEORD(ord,"I",chl,1)),"^",2)
	    s SubCategory=$p($g(^ARCIM(+ArcimId,$p(ArcimId,"||",2),1)),"^",10)
	    s OrdcatDesc="",OrdcatDR=""
	    s:SubCategory'="" OrdcatDR=$p(^ARC("IC",SubCategory),"^",8)
	    s:OrdcatDR'="" OrdcatDesc=$p($g(^OEC("ORCAT",OrdcatDR)),"^",2)
	    s ArcimDesc=$p(^ARCIM(+ArcimId,1,1),"^",2)
	    s GenericName=##class(web.UDHCJFCOMMON).GetDrugCommonNameByArcimId(ArcimId)
	    i GenericName'="" s ArcimDesc=GenericName
	    s ReqPartDesc=##Class(web.DHCAPPInterface).GetExaReqPartDesc(ord_"||"_chl)
		s ArcimDesc=ArcimDesc_ReqPartDesc
	    //s ArcimDesc=$E(ArcimDesc,1,10)
	    s ItemCatDR=$p(^ARCIM(+ArcimId,1,1),"^",10)
	    s OrderRecDepRowid=$P($G(^OEORD(ord,"I",chl,3)),"^",6) ;OEORI_RecDep_DR
	    s OrderType=$P(^ARC("IC",ItemCatDR),"^",7)
	    s OEORIPrice=$p($g(^OEORD(ord,"I",chl,3)),"^",25)
	    s retPrice=##Class(web.DHCDocOrderCommon).GetOEORIPrice(ord_"||"_chl)
	    s BillPrice=$P(retPrice,"^",1)
	    i OrderType="R" {
		    s PackQty=..GetOrdPackQtyByDsp(OrdItem)
	    }else{
		    s PackQty=$p($g(^OEORD(ord,"I",chl,9)),"^",4)
		    i PackQty="" s PackQty=$p($g(^OEORD(ord,"I",chl,1)),"^",12)
	    }
	    s RecDepDR=$p($g(^OEORD(ord,"I",chl,3)),"^",6)
	    s ExamFlag=##class(web.DHCDocOrderCommon).GetItemServiceFlag(ArcimId)
    	i ExamFlag=1 s OrderType="E"
    	;1:"【药品】",2:"【检验】",3:"【检查】",4:"【其他】"   
    	s OrderTypeNum=$case(OrderType,"R":1,"L":2,"E":3,:4)
    	if (OrderTypeNum="4"){
	    	s BindSource=$P($g(^OEORD(ord,"I",chl,"DHC")),"^",41)
	    	continue:BindSource'=""
	    	}
    	s OrderPrescNo=$P($G(^OEORD(ord,"I",chl,1)),"^",14) ;OEORI_PrescNo
	    i OrderPrescNo'="" {
		    s DrugPrescList(OrderPrescNo,ord_"||"_chl)=ArcimDesc_"^"_PackQty_"^"_RecDepDR_"^"_Billed_"^"_BillPrice
	    }else{
    		s OrdTypeList(OrderTypeNum,ord_"||"_chl)=ArcimDesc_"^"_PackQty_"^"_RecDepDR_"^"_Billed_"^"_BillPrice
	    }
	}
	
	s Sum=0
   	/// s OrderType=$case(rtype,1:"【药品】",2:"【检验】",3:"【检查】",4:"【其他】")
    if $D(DrugPrescList){
		s PrescCount=0
		s OrderPrescNo=0
		for {
			s OrderPrescNo=$O(DrugPrescList(OrderPrescNo))
			q:OrderPrescNo=""
			s ZYFlag=##Class(web.DHCDocPrescriptJSSZY).IsPrescType(OrderPrescNo)
			s DuratDesc=""
			s Count=0
			s PrescSum=0
			s PrescCount=PrescCount+1
			s RecDepDr=""
			s OEORD=0
			for {
				s OEORD=$O(DrugPrescList(OrderPrescNo,OEORD))
				q:OEORD=""
				s Count=Count+1
				s ArcimDesc=$P(DrugPrescList(OrderPrescNo,OEORD),"^",1)
				s DuratDR=$P($g(^OEORD(+OEORD,"I",$P(OEORD,"||",2),2)),"^",6)
				if (DuratDR'=""){
					s DuratDesc=$P(^PHCDU(DuratDR),"^",3)
				}
				s:RecDepDr="" RecDepDr=$P(DrugPrescList(OrderPrescNo,OEORD),"^",3)
				s BillPrice=$P(DrugPrescList(OrderPrescNo,OEORD),"^",5)
				s PackQty=$P(DrugPrescList(OrderPrescNo,OEORD),"^",2)
				s ProirityDr=$p($g(^OEORD(+OEORD,"I",$p(OEORD,"||",2),1)),"^",8)
				s OECPRCode=""
				i ProirityDr'="" s OECPRCode=$p($g(^OECPR(ProirityDr)),"^",1)
				i ((OECPRCode'="OM")&&(OECPRCode'="OMST")&&(OECPRCode'="OMCQZT")&&(OECPRCode'="OMLSZT")) {   //自备药、嘱托
					s PrescSum=PrescSum+(BillPrice*PackQty)
				}
				s CTLOCAddress=..GuidAddress(OEORD,HospId)
			}
			continue:RecDepDr=""
			if (ZYFlag="1")&&(DuratDesc'=""){
				s Count=DuratDesc_" "_Count
			}
			s RecDepDesc=$P(^CTLOC(RecDepDr),"^",2)
			i RecDepDesc["-" s RecDepDesc=$P(RecDepDesc,"-",2)
			//s RecDepDesc=$tr(RecDepDesc,"2楼","")
		    //s RecDepAddrDr=$O(^CTLOC(RecDepDr,"ADDR",""),-1)
		   	//s CTLOCAddress="未维护接受位置"
		    //s:RecDepAddrDr'="" CTLOCAddress=$g(^CTLOC(RecDepDr,"ADDR",RecDepAddrDr))
		    
		    s PrescSum=$FN(PrescSum,"",2)
		    s OrdItemInfo=OrdItemInfo_$C(2)_RecDepDesc_"^^"_Count_"种("_PrescSum_"元)^"_CTLOCAddress_"^^^"
		    s Sum=Sum+PrescSum
		}
		s OrdItemInfo="【药品】"_PrescCount_"张处方^^^^^^"_$C(2)_OrdItemInfo
		
		s OrdItemInfo=OrdItemInfo_$C(2)_Pline_"^^^^^^"
	}
	if $D(OrdTypeList){
		//s OrdTypeList(OrderTypeNum,ord_"||"_chl)=ArcimDesc_"^"_PackQty_"^"_RecDepDR_"^"_Billed_"^"_BillPrice
		s OrderTypeNum=0
		for {
			s OrderTypeNum=$O(OrdTypeList(OrderTypeNum))
			q:OrderTypeNum=""
			s OrderTypeDesc=$case(OrderTypeNum,1:"【药品】",2:"【检验】",3:"【检查】",4:"【其他】")
    					
			if (OrdItemInfo'=""){
				s OrdItemInfo=OrdItemInfo_$C(2)_OrderTypeDesc_"^^^^^^"
			}else{
				s OrdItemInfo=OrderTypeDesc_"^^^^^^"
			}
			s OEORD=0
			for {
				s OEORD=$O(OrdTypeList(OrderTypeNum,OEORD))
				q:OEORD=""
				s ArcimDesc=$P(OrdTypeList(OrderTypeNum,OEORD),"^",1)
				
				s RecDepDr=$P(OrdTypeList(OrderTypeNum,OEORD),"^",3)
				s RecDepDesc=$P(^CTLOC(RecDepDr),"^",2)
				i RecDepDesc["-" s RecDepDesc=$P(RecDepDesc,"-",2)
			    //s RecDepAddrDr=$O(^CTLOC(RecDepDr,"ADDR",""),-1)
			   	//s CTLOCAddress="未维护接受位置"
			    //s:RecDepAddrDr'="" CTLOCAddress=$g(^CTLOC(RecDepDr,"ADDR",RecDepAddrDr))
			    s CTLOCAddress=..GuidAddress(OEORD,HospId)
			    s BillPrice=$P(OrdTypeList(OrderTypeNum,OEORD),"^",5)
			    s PackQty=$P(OrdTypeList(OrderTypeNum,OEORD),"^",2)
			    i OrderTypeNum=2 {
				    s ArcimDr=$p($g(^OEORD(+OEORD,"I",$P(OEORD,"||",2),1)),"^",2)
				    s GetReportInfo=$g(^ARCIM(+ArcimDr,$p(ArcimDr,"||",2),"RB",1))  //检验取报告信息
	    			s PressingInfo=$p($g(^ARCIM(+ArcimDr,$p(ArcimDr,"||",2),9)),"^",14)  //检验注意事项
	    			s OEORINotifyClinician=$p($g(^OEORD(+OEORD,"I",$P(OEORD,"||",2),11)),"^",55)
	    			if (PressingInfo'=""){
		    			s ArcimDesc=ArcimDesc_" "_PressingInfo
		    		}
		    		s OESpecRid=$O(^OEORD(+OEORD,"I",$P(OEORD,"||",2),"SPEC",0))
					i +OESpecRid'=0 {
						s specdesc=""
						Set specimen=$p($G(^OEORD(+OEORD,"I",$P(OEORD,"||",2),"SPEC",OESpecRid)),"^",1)
						i specimen'="" s specdesc=$p($g(^TTAB("SPEC",specimen)),"\",1)
						s RecDepDesc=specdesc
					}
					
	    			i OEORINotifyClinician="Y" s ArcimDesc=ArcimDesc_"(急)"
	    			//i GRKAdmDepAddress'="" s CTLOCAddress=GRKAdmDepAddress
	    			//s BloodDisAdress=##class(web.DHCOPBillHDDC).findLOCBloodDisNew(OEORD,specimen)
	    			//i BloodDisAdress'="" s CTLOCAddress=BloodDisAdress
			    }
			    s BillPrice=$FN(BillPrice,"",2)
			    s OrdItemInfo=OrdItemInfo_$c(2)_ArcimDesc_"("_BillPrice_"元*"_PackQty_")^^"_RecDepDesc_"^"_CTLOCAddress_"^^^^"
			}
			s OrdItemInfo=OrdItemInfo_$C(2)_Pline_"^^^^^^"
		}
	}
	if (OrdItemInfo'=""){
		s LMNUM=35 
		s MesageL=$l(HospGuideTips)
		s a=MesageL/LMNUM
		if a<=1  {
			s OrdItemInfo=OrdItemInfo_$C(2)_HospGuideTips_"^^^^^^"
		}else{
			s b=$fn(a,"",0)
			if a>b s b=b+1 //取最大行
			for j=1:1:b  {
				s sub2mesag=$E(HospGuideTips,(LMNUM*j-LMNUM+1),LMNUM*j)
				s OrdItemInfo=OrdItemInfo_$C(2)_sub2mesag_"^^^^^^"
			}
		}		
		/*s OrdItemInfo=OrdItemInfo_$C(2)_"请到收费处交费后再到相应科室就诊^^^^^^"
		s OrdItemInfo=OrdItemInfo_$C(2)_"本单据材料费未计算，仅供参考^^^^^^"*/
	}
    q OrdItemInfo
}

/// 根据导诊单配置获取导诊位置
/// w ##class(web.UDHCPrescript).GuidAddress("3461||5",2)
ClassMethod GuidAddress(OrdItem As %String, HospId As %String) As %String
{
	s HospId=##Class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(HospId)
	s PatGuideAdress=""
	s ArcimId=$p($g(^OEORD(+OrdItem,"I",$p(OrdItem,"||",2),1)),"^",2)
	s SubCategoryDR=$p($g(^ARCIM(+ArcimId,$p(ArcimId,"||",2),1)),"^",10)
    s OrdCatDR=$p(^ARC("IC",SubCategoryDR),"^",8)
	s OrdRecDepRowid=$P($G(^OEORD(+OrdItem,"I",$p(OrdItem,"||",2),3)),"^",6) ;OEORI_RecDep_DR  
	s OrdUserDepartmentDR=$P($G(^OEORD(+OrdItem,"I",$p(OrdItem,"||",2),7)),"^",2)
	s PatGuideInfo=""
	//类型 项目 开单科室 接收科室
	//OECat:医嘱大类，OECatItem:医嘱子类，BB:标本
	s SpecimenDR=$O(^OEORD(+OrdItem,"I",$P(OrdItem,"||",2),"SPEC",0))
	if (SpecimenDR'="") {
		s SpecCode=$p(^OEORD(+OrdItem,"I",$P(OrdItem,"||",2),"SPEC",SpecimenDR),"^",1)
		s HospitalCode=$p($g(^CT("HOSP",HospId)),"^",1)
		s LabHospitalDR=$o(^dbo.BTHospitalI("IndexCode",##Class(LIS.Util.Common).IndexData(HospitalCode),""))
		s SpecimenDR=$o(^dbo.BTSpecimenI("IndexCode",LabHospitalDR,##Class(LIS.Util.Common).IndexData(SpecCode),""))
		s SpecPatGuideInfo=##class(DHCDoc.DHCDocConfig.PatGuide).GetPatGuideInfo("BB",SpecimenDR,OrdUserDepartmentDR,OrdRecDepRowid,HospId)
		if (SpecPatGuideInfo'="") {
			s PatGuideInfo=SpecPatGuideInfo
		}
	}
	if (PatGuideInfo="") {
		s PatGuideInfo=##class(DHCDoc.DHCDocConfig.PatGuide).GetPatGuideInfo("OEARCItem",ArcimId,OrdUserDepartmentDR,OrdRecDepRowid,HospId)
		if (PatGuideInfo=""){
			s PatGuideInfo=##class(DHCDoc.DHCDocConfig.PatGuide).GetPatGuideInfo("OECatItem",SubCategoryDR,OrdUserDepartmentDR,OrdRecDepRowid,HospId)
			if (PatGuideInfo="") {
				s PatGuideInfo=##class(DHCDoc.DHCDocConfig.PatGuide).GetPatGuideInfo("OECat",OrdCatDR,OrdUserDepartmentDR,OrdRecDepRowid,HospId)
			}
		}
	}
	if (PatGuideInfo'="") {
		s PatGuideAdress=$p(PatGuideInfo,"^",4)
	}
	if (PatGuideAdress=""){
		s RecDepAddrDr=$O(^CTLOC(OrdRecDepRowid,"ADDR",""),-1)
	    s:RecDepAddrDr'="" PatGuideAdress=$g(^CTLOC(OrdRecDepRowid,"ADDR",RecDepAddrDr))
	}
	Q PatGuideAdress
}

/// /w ##class(web.UDHCPrescript).GetPAAdmPrescList(41)
ClassMethod GetPAAdmPrescList(EpisodeID As %String, LimitNum As %String = "") As %String
{
	//n (EpisodeID)
	s HospID=##Class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId("")
	Set langid=..%LanguageID()
	s QUE1RowID=""
	
	s PAAdmPrescList=$C(1)
	k PAAdmPrescListArr
	
	s PatientID=$P(^PAADM(EpisodeID),"^",1)
	s myEpisodeID=EpisodeID
	d GetOneAdmInfo
	s PAADMType=0
	for {
		s PAADMType=$O(^PAPERdr(PatientID,"ADM",PAADMType))
		q:PAADMType=""
		s myEpisodeID=""
		for {
			s myEpisodeID=$O(^PAPERdr(PatientID,"ADM",PAADMType,myEpisodeID),-1)
			q:myEpisodeID=""
			continue:myEpisodeID=EpisodeID
			s AdmHospitalId=##class(DHCDoc.Common.Hospital).GetAdmHospitalId(myEpisodeID)
			continue:AdmHospitalId'=HospID
			d GetOneAdmInfo
		}
	}
	s Count=0
	s InserDate=""
	for {
		s InserDate=$O(PAAdmPrescListArr(InserDate),-1)
		q:InserDate=""
		s InserTime=""
		for {
			s InserTime=$O(PAAdmPrescListArr(InserDate,InserTime),-1)
			q:InserTime=""
			s QUE1RowID=""
			for {
				s QUE1RowID=$O(PAAdmPrescListArr(InserDate,InserTime,QUE1RowID),-1)
				q:QUE1RowID=""
				s Data=$G(PAAdmPrescListArr(InserDate,InserTime,QUE1RowID))
				continue:Data=""
				s PreacNo=$P(Data,"^",1)
				s Doctor=$P(Data,"^",2)
				s Flag=$P(Data,"^",3)
				s EndDate=$P(Data,"^",4)
				s DurDesc=$P(Data,"^",5)
				s AddUser=$P(Data,"^",6)
				
				s ARCOSRowId=$P(Data,"^",7)
				s ARCOSName=$P(Data,"^",8)
				s IsARCOSFormula=$P(Data,"^",9)
				s CareProvType=##class(web.DHCDocOrderCommon).GetCareProvType(AddUser)
	            s CareProvType=$zcvt(CareProvType,"U")
				continue:CareProvType'="DOCTOR"
				continue:(LimitNum'="")&&(Count>LimitNum)
				s Count=Count+1
				s OneInfo=PreacNo_$C(1)_ARCOSName_" "_PreacNo_" "_Doctor_" "_EndDate_" "_DurDesc_$C(1)_Flag_$C(1)_IsARCOSFormula
				if (PAAdmPrescList=""){
					s PAAdmPrescList=OneInfo
				}else{
					s PAAdmPrescList=PAAdmPrescList_$C(2)_OneInfo
				}
			}
			
		}
	}
	q PAAdmPrescList
GetOneAdmInfo
	s OEOrd=$O(^OEORD(0,"Adm",myEpisodeID,""),-1)
	for {
		s QUE1RowID=$o(^PAQUE1(0,"QUE1_PAADM_DR",myEpisodeID,QUE1RowID))
		q:QUE1RowID=""
		Continue:'$d(^PAQUE1(QUE1RowID))
		;s PharmStatus=$p(^PAQUE1(QUE1RowID),"^",13) //处方状态
		;q:PharmStatus="C"
		s Prescno=$p(^PAQUE1(QUE1RowID),"^",14)
		s Prescctpcp=$p(^PAQUE1(QUE1RowID),"^",5)
		s doctordr=$p(^PAQUE1(QUE1RowID),"^",5)
		continue:doctordr=""
		s doctor=$p($G(^CTPCP(doctordr,1)),"^",2)
		Set doctor= ##class(User.CTCareProv).GetTranByDesc("CTPCPDesc",doctor,langid)
		s transdate=$p(^PAQUE1(QUE1RowID),"^",7)
		Continue:'$d(^PAQUE1(QUE1RowID,"DHC"))
		s prestype=$p(^PAQUE1(QUE1RowID,"DHC"),"^",2)
		Continue:prestype'=3
		s ARCOSRowId=$P(^PAQUE1(QUE1RowID,"DHC"),"^",24)
		s ARCOSName="",IsARCOSFormula=0
		if (+ARCOSRowId>0){
			s ARCOSName=$P(^ARCOS(ARCOSRowId),"^",2)
			s IsARCOSFormula=..IsARCOSFormula(ARCOSRowId)
		}
		s InserDate=$P(^PAQUE1(QUE1RowID,"DHC"),"^",4)
		s InserTime=$P(^PAQUE1(QUE1RowID,"DHC"),"^",5)
		s Flag=1
		s AddUser=$P(^PAQUE1(QUE1RowID,"DHC"),"^",3)
		s Sub=$O(^OEORD(0,"PrescNo",Prescno,OEOrd,0))
		s OrderBilled=$P($G(^OEORD(OEOrd,"I",Sub,3)),"^",5) ;OEORI_Billed
		if (OrderBilled="P"){
			s Flag=2
		}
		
		s Stat=$P($G(^OEORD(+OEOrd,"I",Sub,1)),"^",13) 
		s statcode="V"
		i Stat'=""{
			s statcode=$p($g(^OEC("OSTAT",Stat)),"^",1)
		}
		if ("^U^D^C^")[statcode {
			s Flag=4
		}
		if (myEpisodeID'=EpisodeID){
			continue:("^U^D^C^")[statcode
			s Flag=3
		}
		s PrescDurRowid=$p(^PAQUE1(QUE1RowID,"DHC"),"^",10)
		s PrescDurDesc="",DuratNum=""
		if (PrescDurRowid'=""){
			s PrescDurDesc=$p(^PHCDU(PrescDurRowid),"^",3)
			s PrescDurDesc=##class(User.PHCDuration).GetTranByDesc("PHCDUDesc1",PrescDurDesc,langid)
			s DuratNum=$p(^PHCDU(PrescDurRowid),"^",2)
		}
		
		
		s MainSub=$O(^OEORD(0,"PrescNo",Prescno,OEOrd,0))
		s SttDat=$p($g(^OEORD(OEOrd,"I",MainSub,"X",1)),"^",1)
		if (SttDat="") s SttDat=$p(^OEORD(OEOrd,"I",MainSub,1),"^",9)
		s SttTim=$p(^OEORD(OEOrd,"I",MainSub,1),"^",10)
		s PHFreqDR=$p(^OEORD(OEOrd,"I",MainSub,2),"^",4)
		s PHFreqNum=""
		if (PHFreqDR'=""){
			s PHFreqNum=$p(^PHCFR(PHFreqDR),"^",2)
		}
        s EndDate=""
		i PHFreqNum'="" s EndDate=SttDat+(DuratNum\PHFreqNum+$S(((DuratNum#PHFreqNum)>0):1,1:0))-1
		i EndDate'="" s EndDate=..%ZD(EndDate) //$ZD(EndDate,3)
		s PAAdmPrescListArr(InserDate,InserTime,QUE1RowID)=Prescno_"^"_doctor_"^"_Flag_"^"_..%ZD(SttDat)_##class(websys.Translation).Get("opdoc.oeorder.cmlistcustom.csp","至")_EndDate_"^"_PrescDurDesc_"^"_AddUser_"^"_ARCOSRowId_"^"_ARCOSName_"^"_IsARCOSFormula
	}
	
	q
}

/// w ##class(web.UDHCPrescript).GetPrescListDate("O15120100009")
ClassMethod GetPrescListDate(PrescNo As %String) As %String
{
	s ^tan("GetPrescListDate")=PrescNo
	s LogonHospID=%session.Get("LOGON.HOSPID")
	q:PrescNo="" ""
	s PrescListDate=""
	s CMKLSubCategory=..%GetConfig("CNMedKLItemCat")
	s OEOrd=$O(^OEORD(0,"PrescNo",PrescNo,0))
	s EpisodeID=$P(^OEORD(OEOrd),"^",1)
	s mainSub=$O(^OEORD(0,"PrescNo",PrescNo,OEOrd,0))
	
	s QUE1RowID=$O(^PAQUE1(0,"PrescNo",PrescNo,0))
	s prestype=$p(^PAQUE1(QUE1RowID,"DHC"),"^",2)
	q:prestype'="3" -1
	
	s PrescDurRowid=$P(^PAQUE1(QUE1RowID,"DHC"),"^",10)
	s PrescDurationDesc="",PrescDurationFactor=""
	if (PrescDurRowid'=""){
		s PrescDurationDesc=$p(^PHCDU(PrescDurRowid),"^",3)
		s PrescDurationFactor=$p(^PHCDU(PrescDurRowid),"^",2)
	}
	s PrescInstruction=$P(^PAQUE1(QUE1RowID,"DHC"),"^",11)
	s PrescInstructionDesc=""
	if (PrescInstruction'=""){
		s PrescInstructionDesc=$p(^PHCIN(PrescInstruction),"^",2)
	}
	
	s PrescCookMode=$P(^PAQUE1(QUE1RowID,"DHC"),"^",15)
	
	s RecLoc=$P(^OEORD(OEOrd,"I",mainSub,3),"^",6)
	
	s PrescFrequence=$P(^PAQUE1(QUE1RowID,"DHC"),"^",9)
	s PrescFrequenceDesc=""
	if (PrescFrequence'=""){
	 s PrescFrequenceDesc=$p(^PHCFR(PrescFrequence),"^",3)
	}
	s PrescOrderQty=$P(^PAQUE1(QUE1RowID,"DHC"),"^",13)
	
	s PrescPrior=$P(^OEORD(OEOrd,"I",mainSub,1),"^",8)
	s PrescPriorDesc=$P(^OECPR(PrescPrior),"^",1)
	
	s PrescAppenItemQty=0
	
	s PrescNotes=$P(^PAQUE1(QUE1RowID,"DHC"),"^",21)
	
	s PrescEmergency=$P(^PAQUE1(QUE1RowID,"DHC"),"^",22)
	
		
	s StartDate=$p(^PAQUE1(QUE1RowID,"DHC"),"^",6)
	s StartTime=$p(^PAQUE1(QUE1RowID,"DHC"),"^",7)
	s StartDate=..%ZD(StartDate)_" "_..%ZT(StartTime,1)
	s EndDate=""
	
	s ARCOSRowId=$P(^PAQUE1(QUE1RowID,"DHC"),"^",24)
	
	s ArcimDr=$P(^OEORD(OEOrd,"I",mainSub,1),"^",2)
	s ItemCatRowid=$p($g(^ARCIM(+ArcimDr,$p(ArcimDr,"||",2),1)),"^",10)
	
	s CMPrescTypeCode=$P(^PAQUE1(QUE1RowID,"DHC"),"^",26)
	if CMPrescTypeCode="" s CMPrescTypeCode="CNMedItemCat"
	s ItemCatStr=..%GetConfig(CMPrescTypeCode)

	s PAAdmType=##class(web.DHCDocOrderEntry).GetPAAdmType(EpisodeID)
	if PAAdmType="I" {
		s PACWardID=$P($g(^PAADM(EpisodeID)),"^",70)
		s EpLoc=$P($g(^PAWARD(PACWardID)),"^",5)
	}else{
		s EpLoc=$P($g(^PAADM(EpisodeID)),"^",4)
	}
	
	s CMRecLocStr=##Class(web.DHCDocOrderCommon).GetCMRecLoc(EpisodeID,ItemCatStr,LogonHospID)
	s DefaultRecLoc=$$GetDefalocID(CMRecLocStr)
	
	s PAADMRegConDisDR=$P($G(^PAADM(EpisodeID,"DHC")),"^",25)
	s PatType=$P(^PAADM(EpisodeID,1),"^",6)
	s InsType=$P(^PAADM(EpisodeID,1),"^",7)
	
	s PrescPriorRowid=""
	s OrderInfo=""
	s Sub=0
	for {
		s Sub=$O(^OEORD(0,"PrescNo",PrescNo,OEOrd,Sub))
		q:Sub=""
		s ArcimDr=$P(^OEORD(OEOrd,"I",Sub,1),"^",2)
		s ArcimName=$p($g(^ARCIM(+ArcimDr,$p(ArcimDr,"||",2),1)),"^",2)
		if PrescPriorRowid=""{
			s PrescPriorRowid=$P(^OEORD(OEOrd,"I",Sub,1),"^",8)
		}
		s DoseQty=$P(^OEORD(OEOrd,"I",Sub,2),"^",1)
		s DoseUOMRowid=$P(^OEORD(OEOrd,"I",Sub,2),"^",3)
		s PhSpecInstr=$P(^OEORD(OEOrd,"I",Sub,2),"^",8)
		s ItemARCOSRowId=$P(^OEORD(OEOrd,"I",Sub,3),"^",10)
		s Detail=DoseQty_$C(1)_DoseUOMRowid_"^^^^^^"_ItemARCOSRowId_"^^^"_PhSpecInstr
		s OneOrdInfo=ArcimDr_"!"_""_"!"_Detail
		if OrderInfo="" {
			s OrderInfo=OneOrdInfo
		}else{
			s OrderInfo=OrderInfo_$C(2)_OneOrdInfo
		}
	}
	s TakingMedicineMethod=$P(^PAQUE1(QUE1RowID,"DHC"),"^",37)
	s AddLongArcimDr=""
    s AddLongOrderID=$P(^PAQUE1(QUE1RowID,"DHC"),"^",25)
    i AddLongOrderID'="" {
        s AddLongArcimDr=$P(^OEORD(+AddLongOrderID,"I",$p(AddLongOrderID,"||",2),1),"^",2)
    }
	s PrescListDate=OrderInfo_$C(12)
	s PrescListDate=PrescListDate_""_PrescDurationDesc_$C(2)_PrescDurRowid_$C(2)_PrescDurationFactor
	s PrescListDate=PrescListDate_"^"_PrescInstructionDesc_$C(2)_PrescInstruction
	s PrescListDate=PrescListDate_"^"_PrescCookMode
	s PrescListDate=PrescListDate_"^"_RecLoc
	s PrescListDate=PrescListDate_"^"_PrescFrequenceDesc_$C(2)_PrescFrequence
	s PrescListDate=PrescListDate_"^"_PrescOrderQty
	s PrescListDate=PrescListDate_"^"_PrescPrior
	s PrescListDate=PrescListDate_"^"_PrescPriorDesc
	s PrescListDate=PrescListDate_"^"_PrescAppenItemQty
	s PrescListDate=PrescListDate_"^"_PrescNotes
	s PrescListDate=PrescListDate_"^"_PrescEmergency
	s PrescListDate=PrescListDate_"^"_StartDate
	s PrescListDate=PrescListDate_"^"_EndDate
	s PrescListDate=PrescListDate_"^"_ARCOSRowId
	s PrescListDate=PrescListDate_"^"_CMPrescTypeCode
	s PrescListDate=PrescListDate_"^"_TakingMedicineMethod
	s PrescListDate=PrescListDate_"^"_AddLongArcimDr		;AddLongOrderID  ;前台使用的是医嘱项ID，非医嘱ID
	s PrescListDate=PrescListDate_"^"_PrescPriorRowid
	q PrescListDate
GetDefalocID(RecLocStr)
	s DeLocID=""
	s RecLocCount=$L(RecLocStr,$C(2))
	F iLoc=1:1:RecLocCount {
		S RecLocStr=$P(RecLocStr,$C(2),iLoc)
		s ReclocRowId=$P(RecLocStr,$C(1),1)
		if iLoc=1 s DeLocID=ReclocRowId
		s Defaut=$P(RecLocStr,$C(1),3)
		if (Defaut="Y") s DeLocID=ReclocRowId
		
	}
	Q DeLocID
}

ClassMethod CheckStopPrescNo(PrescNo As %String, UserID As %String, EpisodeID As %String) As %String
{
	q:PrescNo="" -1
	s OEOrd=$O(^OEORD(0,"PrescNo",PrescNo,0))
	q:OEOrd="" "-2^处方号不存在"
	s myEpisodeID=$P(^OEORD(OEOrd),"^",1)
	q:(EpisodeID'=myEpisodeID) "-3^不同就诊记录，不可停止"
	s SSUSRHospitalDR=$p($g(^SSU("SSUSR",UserID)),"^",98)
	s OEOrd=$O(^OEORD(0,"PrescNo",PrescNo,0))
	if (OEOrd'=""){
		s Sub=$O(^OEORD(0,"PrescNo",PrescNo,OEOrd,""))
		if (Sub'=""){
			s stat=$p($g(^OEORD(+OEOrd,"I",Sub,1)),"^",13)
			i stat s stat=$p($g(^OEC("OSTAT",stat)),"^")
			Q:(stat'="V")&&(stat'="E") "-4^该处方已停止!"
		}
		// 仅允许撤销本人所开医嘱(门急诊)
		s OPOrdStopLimit=..%GetConfig("OPOrdStopLimit",SSUSRHospitalDR) //$g(^DHCDocConfig("OPOrdStopLimit"))
		if (OPOrdStopLimit=1){
		  i (##class(web.DHCDocOrderCommon).IsEntryOEORIUser(OEOrd_"||"_Sub,UserID)="N") {
			  Q "-5^非本人所开处方不能停止!"
		  }
		}
	}
	q "0^"
}

/// /w ##class(web.UDHCPrescriptQueryCM).StopPrescNo("I15112700006")
ClassMethod StopPrescNo(PrescNo As %String, UserID As %String, LocID As %String) As %String
{
	q:PrescNo="" -1
	s OEOrd=$O(^OEORD(0,"PrescNo",PrescNo,0))
	q:OEOrd="" "-2^处方号不存在"
	s EpisodeID=$P(^OEORD(OEOrd),"^",1)
	s PatAdmType=$p(^PAADM(EpisodeID),"^",2)
	q:PatAdmType="I" "-3^住院患者请前往医嘱单医生停止医嘱"
	s rtn=0
	s OrderItemStr=""
	s Sub=0
	for {
		s Sub=$O(^OEORD(0,"PrescNo",PrescNo,OEOrd,Sub))
		q:Sub=""
		s OrItemID=OEOrd_"||"_Sub
		s AddLocId=$p($g(^OEORD(OEOrd,"I",Sub,7)),"^",2) //科室扩展设置-》医嘱只能本科室停止
		s OnlyThisDepStopFlag=0
		s:AddLocId'="" OnlyThisDepStopFlag=$P($G(^CTLOC(AddLocId,"DHC")),"^",14)
		s:(LocID'=AddLocId)&&(OnlyThisDepStopFlag=1) rtn="-4^医嘱只能开单科室停止!"
		if (OrderItemStr=""){
			s OrderItemStr=OrItemID
		}else{
			s OrderItemStr=OrderItemStr_"^"_OrItemID
		}
	}
	q:rtn'=0 rtn
	s ErrMsg=""
	TS
	s ret=##class(web.UDHCStopOrderLook).StopOrder("","",OrderItemStr,UserID,"","N","",.ErrMsg)
	if (+ret'=0){
		TRO
		q "-100^"_ErrMsg
	}
	TC
	
	q "0^"_OrderItemStr
}

ClassMethod GetPreFraGroup() As %String
{
	 w "<DIV id='preftabsList' style='position:relative; padding:10px;'>"
	 w "<input type='button' value='科室模板' id='OEPrefLoc' style='position:relative; padding:10px;'/>"
	 w "<input type='button' value='个人模板' id='OEPrefUser' style='position:relative; padding:10px;'/>"
	 ;w "<input type='button' value='全院模板' id='OEPrefHosp' style='position:relative; padding:10px;'/>"
	 w "</DIV>"
}

ClassMethod SaveWeight(MRAdmID As %String, Weight As %String) As %String
{
	s $p(^MR(MRAdmID,"PRO",1),"^",27)=Weight
	q 0
}

ClassMethod GetMRDiagnosDescNew(MRAdmRowid As %String, DelimStr As %String, LogonCTLocRowId As %String) As %String
{
    s retval=""
    s i=0
    Set obj=##class(%ResultSet).%New("web.MRDiagnos:Find")
    d obj.Execute(MRAdmRowid)
    For  Quit:'obj.Next()  Do
    .s Desc=obj.Data("MRDIAICDCodeDRDesc")
    .s Rowid=obj.Data("ID")
    .s MRAddLocDr=$p($g(^MR($P(Rowid,"||",1),"DIA",$P(Rowid,"||",2),1)),"^",20)
    .//Q:(LogonCTLocRowId'=MRAddLocDr)&&(LogonCTLocRowId'="")
    .s bb=$g(^MR($P(Rowid,"||",1),"DIA",$P(Rowid,"||",2),"DES",1))
    .s CodeRowid=obj.Data("MRDIAICDCodeDR")
    .i CodeRowid'="" d
    ..s BillFlag1=$P($G(^MRC("ID",+CodeRowid)),"^",13)
    ..s BillFlag3=$P($g(^MRC("ID",+CodeRowid)),"^",15)
    ..i BillFlag3'="Y" d
    ...s DiagnosCat="西医"
    ..else  if (BillFlag3="Y")&&(BillFlag1'="Y") d
    ...s DiagnosCat="中医"
    ..else  d
    ...s DiagnosCat="证候"
    .e  d
    ..s Questionnaire=$P($G(^MR($P(Rowid,"||",1),"DIA",$P(Rowid,"||",2))),"^",22)
    ..i Questionnaire=1 d
    ...s DiagnosCat="西医"
    ..else  if (Questionnaire=2) d
    ...s DiagnosCat="中医"
    ..else  if (Questionnaire=3) d
    ...s DiagnosCat="证候"
    ..else  d
    ...s DiagnosCat="??"
    .;s MRDesc=obj.Data("MRDIADesc")
    .s MRDesc=$g(^MR($P(Rowid,"||",1),"DIA",$P(Rowid,"||",2),"DES",1))  ;and by wanghailong for 306||6 乱码
    .s Find=0
    .i DiagnosCat="证候" d
    ..s Desc1=$p(retval,i_".",2)
    ..s Desc2=$p(Desc1,"?",1)
    ..i Desc="" s Desc=MRDesc
    ..s Desc3=Desc2_"("_Desc_")"
    ..s $p(retval,i_".",2)=Desc3 //_""_$p(Desc1,"?",2)
    ..i Desc1["?" s $p(retval,i_".",2)=$p(retval,i_".",2)_"?"
    ..s Find=1
    .Q:Find="1"
    .s MRStatus=""
    .s MRStatusRowid=$p($g(^MR(+Rowid,"DIA",$p(Rowid,"||",2))),"^",9)
    .i MRStatusRowid'="" s MRStatus=$p($g(^MRC("DSTAT",MRStatusRowid)),"^",2)
    .i MRStatus="确诊" s MRStatus=""
    .i MRStatus="待诊" s MRStatus="?"
    .;if MRDesc'="" s MRDesc=$LIST(MRDesc,1)
    .i Desc="" s Desc=MRDesc
    .e  d
    ..i MRDesc'="" s Desc=Desc_"("_MRDesc_")"
    .i Desc'="" d
    ..i MRStatus'="" s Desc=Desc_""_MRStatus
    ..//s Desc=Desc_"  "_MRStatus
    .s i=i+1
    .s Desc=i_"."_Desc
    .if retval="" s retval=Desc
    .e  s retval=retval_DelimStr_Desc
    d obj.Close()
    q retval
    //q $ZCVT(retval,"O","JS")
}

/// tanjishan
/// w ##Class(web.UDHCPrescript).GetAdmPrintList("1094","600",0)
/// 根据就诊号，获取此就诊下所有的病历打印单据
ClassMethod GetAdmPrintList(paadm As %String, PrintUser As %String, MTREnble As %String) As %String
{
	
	s AInstanceIDList=""
	s PrintDocID=""
	s:PrintUser'="" PrintDocID=$P(^SSU("SSUSR",PrintUser),"^",14)
	s admdate=$P($G(^PAADM(paadm)),"^",6)
	s CategoryID = ""
	for {
		s CategoryID = $O(^DHCEMRI.ECRecordI("IdxEpisodeIDChartItemID"," "_paadm, CategoryID))
		q:(CategoryID="")

		s ecRecordID = $O(^DHCEMRI.ECRecordI("IdxEpisodeIDChartItemID"," "_paadm, CategoryID, ""))

		s id = "" 
		for {
			s id = $O(^DHCEMRM.EMRTemplateI("IdxCategoryID",CategoryID, id))
			q:(id="")

			s emrTmpl = ##class(EMRmeta.EMRTemplate).%OpenId(id)
			s tmpl = ##class(EMRmeta.Template).%OpenId(emrTmpl.BindTemplateID)
			q:(emrTmpl.CategoryID = "114")
			s ecID = $tr(ecRecordID," ","")
			s title=tmpl.Name
			continue:(MTREnble="1")&&((title="门诊病历")||(title="复诊病历"))
			s insID = $O(^DHCEMRI.InstanceDataI("IdxEcrecordTemplateStatus",ecID," "_emrTmpl.BindTemplateID," SAVE", ""),-1)
			q:(""=insID)
			s AInstanceID=ecID_"||"_insID
			s tmp2 = ##class(EMRinstance.InstanceData).%OpenId(AInstanceID)
			s title=tmp2.Title
			s signID=0
			s FindUserSign=0
			for {
				s signID=$O(^DHCEMRI.EMRSignI("IdxInstance", " "_AInstanceID, signID))
				q:(signID="")
				s sign=##Class(EMRinstance.EMRSign).%OpenId(signID)
				continue:(sign.isSignValid'="1")
				s signUsrID=sign.UsrID
				continue:(PrintUser'="")&&(PrintUser'=signUsrID)
				s FindUserSign=1
			}
			continue:FindUserSign=0
			
			if (AInstanceIDList="") { s AInstanceIDList= AInstanceID_$C(2)_title_$C(2)_signUsrID }
			else { s AInstanceIDList = AInstanceIDList_"^"_AInstanceID_$C(2)_title_$C(2)_signUsrID }
		
		}	 	
	}
	q AInstanceIDList
}

/// tanjishan
/// 获取电子病历打印链接
ClassMethod GetSelfPrintParam(AInstanceID As %String) As %String
{
	s WebServer=$List(^websys.ConfigurationD(1),37)
	//s url=##Class(EMRservice.HISInterface.BOExternal).GetSelfPrintParam(insID)
	s chartItemType="Single"
	s tmp1 = ##class(EMRinstance.InstanceData).%OpenId(AInstanceID)
	s TemplateID=tmp1.TemplateID
	
	s tmp2 = ##class(EMRmeta.Template).%OpenId(TemplateID)
	s chartItemType=tmp2.ChartItemType
	//Multiple
	s url="csp/emr.record.browse.browsform.editor.csp?id="_AInstanceID_"&chartItemType="_chartItemType_"&pluginType=DOC&Print=Y"
	s url=$TR(url,"/","\")
	s url="http:"_WebServer_"\"_url_"&CloseAfterPrint=Y"
	q url
}

/// tanjishan
/// 置打印标志,可用于病历打印后不可编辑等
ClassMethod InsertSelfPrintLog(AInstanceID As %String) As %String
{
	 d ##Class(EMRservice.HISInterface.BOExternal).InsertSelfPrintLog(AInstanceID)
	 q 0
}

ClassMethod GetAllEMRData(AdmRowId As %String, Type As %String) As %String
{
	s ^tan("GetAllEMRData")=AdmRowId_","_Type
    s OutPutData=""
    k AllEMRData
    s arr=##Class(EMRservice.HISInterface.BOExternal).ScatterDataForOP(AdmRowId)
    if ((arr'="")){
	    s AInstanceID=0
	    for
	    {
	        s OneEMRData = arr.GetNext(.AInstanceID)
	        q:(AInstanceID = "")
	        s OneEMRDataUserID=OneEMRData.GetAt("signUsrID")
	        s EMRType=""
	        ///门诊病历签字人
	        s OPEMRSignName=OneEMRData.GetAt($G(^DHCDocLocalSysP("EMR","OPEMRUserName")))
	        ///复诊病历签字人
	        s OPEMRReturnSignName=OneEMRData.GetAt($G(^DHCDocLocalSysP("EMR","OPEMRReturnUserName")))
	        ///疾病诊断证明书签字人
	        s EMRCertificateSignName=OneEMRData.GetAt($G(^DHCDocLocalSysP("EMR","EMRCertificateUserName")))
        	if (OPEMRSignName'=""){
	        	s EMRType=1
	        }elseif (OPEMRReturnSignName'=""){
		    	s EMRType=2
		    }
		    if (EMRType=""){continue}
        	s AllEMRData(OneEMRDataUserID,EMRType)=""
	    }
    }
    if (Type'="OPEMROnly"){
	    s AInstanceIDList=##Class(web.UDHCPrescript).GetAdmPrintList(AdmRowId,"")
	    for i=1:1:$l(AInstanceIDList,"^") {
			 s AInstanceIDInfo=$P(AInstanceIDList,"^",i)
			 continue:AInstanceIDInfo=""
			 s signUsrID=$P(AInstanceIDInfo,$C(2),3)
			 s title=$P(AInstanceIDInfo,$C(2),2)
			 s AInstanceID=$P(AInstanceIDInfo,$C(2),1)
			 s AllEMRData(signUsrID,title)=AInstanceID
		}
    }
    s signUsrID=""
    for {
	    s signUsrID=$O(AllEMRData(signUsrID))
	    q:signUsrID=""
	    s title=0
	    for {
			s title=$O(AllEMRData(signUsrID,title))
			q:title=""
			s signUsrName=$P(^SSU("SSUSR",signUsrID),"^",2)
			s titleName=$CASE(title,1:"门诊病历",2:"复诊病历",:title)
			s AInstanceID=AllEMRData(signUsrID,title)
			if (OutPutData=""){
				s OutPutData=signUsrID_$C(2)_signUsrName_$C(2)_titleName_$C(2)_AInstanceID
			}else{
				s OutPutData=OutPutData_"^"_signUsrID_$C(2)_signUsrName_$C(2)_titleName_$C(2)_AInstanceID
			}
		}
	}
    q OutPutData
}

ClassMethod GetFormulaOrdInfo(AdmRowId As %String) As %String
{
	s ^tan("GetFormulaOrdInfo")=AdmRowId
    s FormulaItemCat=..%GetConfig("FormulaItemCat")
    s OrderInfo=""
    k FormulaOrd
    s OEOrd=$O(^OEORD(0,"Adm",AdmRowId,""),-1)
    s QUE1RowID=0
    for {
        s QUE1RowID=$O(^PAQUE1(0,"QUE1_PAADM_DR",AdmRowId,QUE1RowID))
        q:QUE1RowID=""
        s OnePrescInfo=""
        s PrescNo=$P(^PAQUE1(QUE1RowID),"^",14)
        continue:PrescNo=""
        s PAQDHCStr=$G(^PAQUE1(QUE1RowID,"DHC"))
        if (PAQDHCStr=""){
            s PAQDHCStr=$G(^PAQUE1Log(QUE1RowID,"DHC"))
        }
        ;w QUE1RowID_","_PAQDHCStr,!
        continue:PAQDHCStr=""
        s PrescCookMode=$P(PAQDHCStr,"^",15)
        s prestype=$p(PAQDHCStr,"^",2)
        
        continue:prestype'="3"          ///草药处方应该都有煎药方式才对吧-，-
        s Sub=0
        s ARCOSDr=..GetFormulaOrdFlag(PrescNo)
        continue:ARCOSDr=""

        s OrderDurRowid=$P(^PAQUE1(QUE1RowID,"DHC"),"^",10)
        s OrderDurDesc=$P($g(^PHCDU(OrderDurRowid)),"^",3)
        s PrescInstrRowid=$P(^PAQUE1(QUE1RowID,"DHC"),"^",11)
        s OrderInstrDesc=$$ALPHAUP^SSUTIL4($p(^PHCIN(PrescInstrRowid),"^",2))
        s PrescCookModeDesc=##Class(web.UDHCPrescript).CookModeDesc(PrescCookMode)
        s FormulaOrd(PrescNo)=ARCOSDr_"^"_OrderDurDesc_"^"_OrderInstrDesc
        
    }
    s PrescNo=0
    for {
		s PrescNo=$O(FormulaOrd(PrescNo))
		q:PrescNo=""
		s ARCOSDr=$P(FormulaOrd(PrescNo),"^",1)
		s OrderDurDesc=$P(FormulaOrd(PrescNo),"^",2)
		s OrderInstrDesc=$P(FormulaOrd(PrescNo),"^",3)
		
		s ARCOSName=$P(^ARCOS(ARCOSDr),"^",2)
		
		if (OrderInfo="") s OrderInfo=ARCOSName_"||"_OrderDurDesc_"  "_OrderInstrDesc
        e  s OrderInfo=OrderInfo_$C(2)_ARCOSName_"||"_OrderDurDesc_"  "_OrderInstrDesc
	}
    
    
    q OrderInfo
}

ClassMethod GetFormulaOrdFlag(PrescNo As %String) As %String
{
	s FormulaARCOSDr=""
	s FormulaItemCat=..%GetConfig("FormulaItemCat")
	q:PrescNo="" FormulaARCOSDr
	s OEOrd=$O(^OEORD(0,"PrescNo",$$ALPHAUP^SSUTIL4(PrescNo),0))
	q:OEOrd="" FormulaARCOSDr
	s Sub=0
    for {
        s Sub=$O(^OEORD(0,"PrescNo",$$ALPHAUP^SSUTIL4(PrescNo),OEOrd,Sub))
        q:Sub=""
        q:FormulaARCOSDr'=""
        s TtemStat=$P($G(^OEORD(OEOrd,"I",Sub,1)),"^",13) ;OEORI_Billed
        s statcode=""
        i TtemStat'="" {
            s statcode=$p($g(^OEC("OSTAT",TtemStat)),"^",1)
        }
        continue:(statcode'="V")&&(statcode'="E")
        ///协定处方另外打印
        s ARCOSDr=$P($g(^OEORD(OEOrd,"I",Sub,3)),"^",10)
        continue:ARCOSDr=""
        s ARCOSItemTypeDR=$P($G(^ARCOS(ARCOSDr)),"^",9)
        continue:ARCOSItemTypeDR=""
        continue:(("^"_FormulaItemCat_"^")'[("^"_ARCOSItemTypeDR_"^"))
        s FormulaARCOSDr=ARCOSDr
        
    }
	
	q FormulaARCOSDr
}

ClassMethod IsARCOSFormula(ARCOSRowid As %String, CurLogonHosp As %String = "") As %String
{
	q:ARCOSRowid="" ""
	s FormulaItemCat=..%GetConfig("FormulaItemCat",CurLogonHosp)
	
	s ARCOSCat=$P(^ARCOS(ARCOSRowid),"^",9)
	if (("^"_FormulaItemCat_"^")[("^"_ARCOSCat_"^")){
		q "1"
	}
	q ""
}

ClassMethod IsPresnoFormula(PrescNo As %String) As %String
{
	q:PrescNo="" ""
	s PrescNoFormulaFlag=0
	s ord1=0
	f  s ord1=$o(^OEORD(0,"PrescNo",PrescNo,ord1)) q:(ord1="")||(PrescNoFormulaFlag=1)  d
    .s ordsub1=0
    .f  s ordsub1=$o(^OEORD(0,"PrescNo",PrescNo,ord1,ordsub1)) q:(ordsub1="")||(PrescNoFormulaFlag=1)  d
    ..s ARCIMARcosRowId=$p($g(^OEORD(ord1,"I",ordsub1,3)),"^",10)
    ..q:ARCIMARcosRowId=""
    ..s ARCIMFormulaFlag=##class(web.UDHCPrescript).IsARCOSFormula(ARCIMARcosRowId)
    ..i ARCIMFormulaFlag=1 s PrescNoFormulaFlag=1
    Q PrescNoFormulaFlag
}

ClassMethod GeOrdPrescExecCount(EpisodeID As %String, PrescNo As %String, SearchDate As %String) As %String
{
	s Count=0
	s AdmType=##class(web.DHCDocOrderEntry).GetPAAdmType(EpisodeID)
	set ord=$o(^OEORD(0,"Adm",EpisodeID,""))
	q:(ord="") 0
	if (AdmType="I"){
		s SubT=0
		for {
	    	s SubT=$O(^OEORD(0,"PrescNo",PrescNo,ord,SubT))
	    	q:(SubT="")
	    	s Count=(..GetOrdExecCount(ord_"||"_SubT,SearchDate))+Count
	    }
	}else{
		s Count=##class(web.DHCOEOrdItem).GetPrescItemCount(EpisodeID,PrescNo)
	}
	q Count
}

ClassMethod GetOrdExecCount(OrdRowID As %String, SearchDate) As %String
{
	s Count=0
	s ord=+OrdRowID
	s SubT=$P(OrdRowID,"||",2)
	s ArcimId=$p(^OEORD(ord,"I",SubT,1),"^",2)
	q:(ArcimId="") 0
	s arctpdr=$p(^ARCIM($p(ArcimId,"||",1),$p(ArcimId,"||",2),1),"^",10)
	s OrderType=$P(^ARC("IC",arctpdr),"^",7)
	q:(OrderType'="R") 0
	s PriorityDR=$p(^OEORD(ord,"I",SubT,1),"^",8)
	s ISLongOrderPrior=##class(appcom.OEOrdItem).ISLongOrderPrior(PriorityDR)
	if (1){
		s OEOREChildsub=0
		for {
			s OEOREChildsub=$O(^OEORD(ord,"I",SubT,"X",OEOREChildsub))
			q:(OEOREChildsub="")
			s ExeData = $p($g(^OEORD(ord,"I",SubT,"X",OEOREChildsub)),"^",1)
			continue:((ExeData<SearchDate)||(ExeData>SearchDate))
			s ExecStateDR = $p($g(^OEORD(ord,"I",SubT,"X",OEOREChildsub)),"^",16)
			s ExecStateCode=""
			if (ExecStateDR'=""){
				s ExecStateCode = $p(^OEC("STAT",ExecStateDR),"^",1)
			}
			if (ExecStateCode'="D")&&(ExecStateCode'="R"){
				s Count=Count+1
			}
		}
	}
	q Count
}

/// w ##Class(web.UDHCPrescript).GetCMLongArcimLinkOrdList("146||119")
ClassMethod GetCMLongArcimLinkOrdList(OrdRowID As %String) As %String
{
	s OrdList=""
	s ord=+OrdRowID
	s chl=$P(OrdRowID,"||",2)
	s ArcimId=$p(^OEORD(ord,"I",chl,1),"^",2)
	s PrescRowid=$O(^PAQUE1(0,"DHCPAQue","AddLongOrderID",ord_"||"_chl,0))
	if ($P($G(^PAQUE1(PrescRowid,"DHC")),"^",2)'=3){
		q OrdList
	}
	s AddLongOrderID=$P($G(^PAQUE1(PrescRowid,"DHC")),"^",25)
	if (AddLongOrderID'=OrdRowID){
		q OrdList
	}
	s MainLinkOrdRowID=$P($G(^PAQUE1(PrescRowid,"DHC")),"^",34)
	if (MainLinkOrdRowID=""){
		q OrdList
	}
	s OrdList=MainLinkOrdRowID
	set Childsub=0
	for {
		set Childsub=$o(^OEORDi(0,"OEORI",ord,MainLinkOrdRowID,Childsub))
		q:Childsub=""
		s ArcimId=$p($g(^OEORD(ord,"I",Childsub,1)),"^",2)
		s ItemCatDR=$p(^ARCIM(+ArcimId,1,1),"^",10)
		s OrderType=$P(^ARC("IC",ItemCatDR),"^",7)
		if (OrderType'="R"){
			continue
		}
		if (OrdList=""){
			s OrdList=ord_"||"_Childsub
		}else{
			s OrdList=OrdList_"^"_ord_"||"_Childsub
		}
	}
	q OrdList
}

/// w ##Class(web.UDHCPrescript).GetCMLinkLongOrd("146||119")
ClassMethod GetCMLinkLongOrd(OrdRowID As %String) As %String
{
	s ord=+OrdRowID
	s chl=$P(OrdRowID,"||",2)
	s ArcimId=$p(^OEORD(ord,"I",chl,1),"^",2)
	s PrescNo=$P($G(^OEORD(ord,"I",chl,1)),"^",14)
	if (PrescNo=""){
		s PrescRowid=$O(^PAQUE1(0,"DHCPAQue","AddLongOrderID",OrdRowID,0))
		if (PrescRowid'=""){
			q OrdRowID
		}
		q ""
	}
	s PrescRowid=$O(^PAQUE1(0,"PrescNo",PrescNo,0))
	if (PrescRowid=""){
		q ""
	}
	if ($P($G(^PAQUE1(PrescRowid,"DHC")),"^",2)'=3){
		q ""
	}
	s AddLongOrderID=$P($G(^PAQUE1(PrescRowid,"DHC")),"^",25)
	q AddLongOrderID
}

ClassMethod GetItemByPrescNo(PrescNo)
{
	s OrdItems=[]
	Set langid=..%LanguageID()
	s OEOrd=$O(^OEORD(0,"PrescNo",PrescNo,0))
	s Sub=0 for {
		s Sub=$O(^OEORD(0,"PrescNo",PrescNo,OEOrd,Sub)) Q:Sub=""
		s itemStatDr=$p($g(^OEORD(+OEOrd,"I",Sub,1)),"^",13)
        s statcode=$p($g(^OEC("OSTAT",+itemStatDr)),"^",1)
        continue:(statcode'="V")&&(statcode'="E")
		s ArcimRowid=$P(^OEORD(OEOrd,"I",Sub,1),"^",2)
		continue:ArcimRowid=""
		s ArcimDesc=$p($g(^ARCIM(+ArcimRowid,$p(ArcimRowid,"||",2),1)),"^",2)
		s ArcimDesc=##class(User.ARCItmMast).GetTranByDesc("ARCIMDesc",ArcimDesc,langid)
		s DoseQty=$P(^OEORD(OEOrd,"I",Sub,2),"^",1)
		s DoseUOMRowid=$P(^OEORD(OEOrd,"I",Sub,2),"^",3)
		s DoseUOM=$P(^CT("UOM",DoseUOMRowid),"^",2)
		s DoseUOM=##class(User.CTUOM).GetTranByDesc("CTUOMDesc",DoseUOM,langid)
		s PhSpecInstr=$P(^OEORD(OEOrd,"I",Sub,2),"^",8)
		s:PhSpecInstr'="" ArcimDesc=ArcimDesc_"("_PhSpecInstr_")"
		d OrdItems.%Push({"ArcimDesc":(ArcimDesc),"DoseQty":(DoseQty_DoseUOM)})
	}
	Q OrdItems.%ToJSON()
}

ClassMethod GetOrdCMPrescTypeCode(OrdItemID)
{
	s PAQue1RowID=$O(^PAQUE1(0,"DHCPAQue","AddLongOrderID",OrdItemID,0))
	if (PAQue1RowID'=""){
		s CMOrderRowId=$P($G(^PAQUE1(PAQue1RowID,"DHC")),"^",34)
		if CMOrderRowId'=""{
			s OrdItemID=CMOrderRowId
		}
	}
	s PrescNo=$P($G(^OEORD(+OrdItemID,"I",$P(OrdItemID,"||",2),1)),"^",14)
	Q:PrescNo="" ""
	s QUE1RowID=$O(^PAQUE1(0,"PrescNo",PrescNo,0))
	Q:QUE1RowID="" ""
	s CMPrescTypeCode=$P($G(^PAQUE1(QUE1RowID,"DHC")),"^",26)
	Q CMPrescTypeCode
}

ClassMethod IsValidPrescNo(PrescNo)
{
	s Flag=0
	Q:PrescNo="" Flag
	s OEOrd=$O(^OEORD(0,"PrescNo",PrescNo,0))
	s Sub=0 for {
		s Sub=$O(^OEORD(0,"PrescNo",PrescNo,OEOrd,Sub)) Q:Sub=""
		s itemStatDr=$p($g(^OEORD(+OEOrd,"I",Sub,1)),"^",13)
        s statcode=$p($g(^OEC("OSTAT",+itemStatDr)),"^",1)
       	if (statcode="V")||(statcode="E"){
			s Flag=1
			Q
		}
	}
	Q Flag
}

}
