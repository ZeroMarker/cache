Import SQLUser

Class web.DHCCAbFeeCheck Extends (%RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

/// 通用 判断需执行计费的医嘱 不用系统设置的计费点的医嘱子类 只走自己的配置
ClassMethod GetCheckFeeExec(ind, PAADMRowId, InDaysCount) As %String
{
	//w ##class(web.DHCCAbFeeCheck).GetCheckFeeExec(10,13571477,600)
	s abnormal=$p(^DHCCAbFeeConfig("YCFeeCheck",ind),"^",3),Mem="正常"
	s OrderID=$o(^OEORD(0,"Adm",PAADMRowId,""))
	s pbqtys=0
	s i=0
	s OrdItemCld=0 f  s OrdItemCld=$o(^OEORD(OrderID,"I",OrdItemCld))  q:OrdItemCld=""  d
	.s ItmMastDR=$p(^OEORD(OrderID,"I",OrdItemCld,1),"^",2)
	.s ArcCatRowID="",OrdCatDr=""
	.s ItmMastDesc=$p(^ARCIM(+ItmMastDR,1,1),"^",2)
	.s ArcCatRowID = $p($g(^ARCIM(+ItmMastDR,1,1)),"^",10)
	.s:ArcCatRowID'="" OrdCatDr=$p($g(^ARC("IC",ArcCatRowID)),"^",8)
	
	.s qflag=0
    .s arctype="" f  s arctype=$o(^DHCCAbFeeConfig("Details",ind,arctype)) q:arctype=""  d
    ..//b   ;1
    ..i arctype="OECCAT" d  //按大类
    ...i $d(^DHCCAbFeeConfig("Details",ind,arctype,OrdCatDr)) d
    ....s qflag=1
    ..i arctype="ARCIC" d  //按子类
    ...i $d(^DHCCAbFeeConfig("Details",ind,arctype,ArcCatRowID)) d
    ....s qflag=1
    ..i arctype="ARCIM" d  //按医嘱项
    ...i $d(^DHCCAbFeeConfig("Details",ind,arctype,ItmMastDR)) d
    ....s qflag=1
    .q:qflag=0   
    .s itmstat=$p(^OEORD(OrderID,"I",OrdItemCld,1),"^",13)
    .//q:itmstat=4   //停止
    .//q:itmstat=11   //未激活
    .q:(itmstat'=1)&&(itmstat'=6)
    .//b   ;1
    .s jfflag=0
    .s pb="" f  s pb=$o(^DHCPBi(0,"OEORI",OrderID_"||"_OrdItemCld,pb)) q:pb=""  d
    ..s pbo="" f  s pbo=$o(^DHCPBi(0,"OEORI",OrderID_"||"_OrdItemCld,pb,pbo)) q:pbo=""  d
    ...s pbflag=$p(^DHCPB(pb,"O",pbo),"^",16)
    ...//q:pbflag=""
    ...s pbqty=$p(^DHCPB(pb,"O",pbo),"^",5)
    ...s refundqty=$p(^DHCPB(pb,"O",pbo),"^",6)
    ...s pbqtys=pbqty+refundqty
    ...//w !,pbqtys
    ...i pbqtys>0 s jfflag=1
	.s addusr=$p(^OEORD(OrderID,"I",OrdItemCld,7),"^",1)
	.i addusr'="" s addusr=$p(^SSU("SSUSR",addusr),"^",2)
	.s ordstdate=$p(^OEORD(OrderID,"I",OrdItemCld,1),"^",9)
	.s ordstdate=$zd(ordstdate,3)
    .//w !,ItmMastDesc_"^"_pbqtys_"^"_jfflag
    .i jfflag=0 d   //未计费
    ..i Mem="正常" s Mem=addusr_"|"_ordstdate_"|"_ItmMastDesc
    ..e  s Mem=Mem_"|"_addusr_"|"_ordstdate_"|"_ItmMastDesc
    ..s i=i+1

    
   
	q i_"^"_abnormal_"^"_Mem
}

/// 与手术室相关的判断Apply,Decline,Receive,InRoom,Operate,LeaveRoom,Finish,NotApp
ClassMethod GetCheckFeeOP(ind, PAADMRowId, InDaysCount) As %String
{
	//w ##class(web.DHCCAbFeeCheck).GetCheckFeeExec(10,13571477,600)
	s abnormal=$p(^DHCCAbFeeConfig("YCFeeCheck",ind),"^",3),Mem="正常"
	s OrderID=$o(^OEORD(0,"Adm",PAADMRowId,""))
	s i=0
	s ssflag=0,ssordflag=0,opdescs=""
	s op="" f  s op=$o(^DHCANOPArrange(0,"Adm",PAADMRowId,op)) q:op=""  d
	.s opstatus=$p(^DHCANOPArrange(op),"^",27)
	.q:(opstatus="A")!(opstatus="D")!(opstatus="N")
	.s arrdate=$p(^DHCANOPArrange(op),"^",7)
	.s arrtime=$p(^DHCANOPArrange(op),"^",8)
	.s arrusr=$p(^DHCANOPArrange(op),"^",9)
	.q:(arrdate'="")!(arrusr'="")
	.s ssflag=1
	.s arrdate=$zd(arrdate,3)
	.s anaId=$P($G(^DHCANOPArrange(op)),"^",2)
	.s anaSub=$P(anaId,"||",2)
	.f  s anaopSub=$O(^OR(PAADMRowId,"ANA",anaSub,"OP",anaopSub)) q:(anaopSub="")||(anaopSub=0)  d
	..s opDr=$P($G(^OR(PAADMRowId,"ANA",anaSub,"OP",anaopSub)),"^",6)
	..i opDr'=""  s opdesc=$P($G(^ORC("OPER",operDr)),"^",2)
	..e  s opdesc=""
	..i opdescs="" s opdescs=arrdate_"|"_opdesc
	..e  s opdescs=opdescs_"|"_arrdate_"|"_opdesc

	i ssflag=1 d   //患者有进行了的手术
	.s locs=""   //标版手术麻醉科室应该是在这个表维护CT_LocationList_Locations
	.s ll="" f  s ll=$o(^CT("LL",ll)) q:ll=""  d
	..s llcode=$p(^CT("LL",ll),"^",1)
	..i llcode["OP" d
	...s lll="" f  s lll=$o(^CT("LL",ll,"LOC",lll)) q:lll=""  d
	....s lloc=$p(^CT("LL",ll,"LOC",lll),"^",1)
	....s locs=locs_"^"_lloc

	.s OrdItemCld=0 f  s OrdItemCld=$o(^OEORD(OrderID,"I",OrdItemCld))  q:OrdItemCld=""  d
	..s itmstat=$p(^OEORD(OrderID,"I",OrdItemCld,1),"^",13)
    ..q:(itmstat'=1)&&(itmstat'=6)
	..s retPrice=##class(web.UDHCJFPRICE).GetOrderPrice("", "", ItmMastDR, +$h, "", "", "", "")
	..s Price=$P(retPrice,"^",1)
    ..q:+Price=0   //无费用的医嘱不管
	...s ItmMastDR=$p(^OEORD(OrderID,"I",OrdItemCld,1),"^",2)
	...s ArcCatRowID="",OrdCatDr=""
	...s ItmMastDesc=$p(^ARCIM(+ItmMastDR,1,1),"^",2)
	...s ArcCatRowID = $p($g(^ARCIM(+ItmMastDR,1,1)),"^",10)
	...s:ArcCatRowID'="" OrdCatDr=$p($g(^ARC("IC",ArcCatRowID)),"^",8)
	...s orddept=$p(^OEORD(OrderID,"I",OrdItemCld,1),"^",3)
	...i locs[orddept d
	....s ssordflag=1   //有手麻开的有效医嘱
    .i ssordflag=0 d
    ..i Mem="正常" s Mem=opdescs
    ..e  s Mem=Mem_"|"_opdescs
    .s i=i+1

    
   
	q i_"^"_abnormal_"^"_Mem
}

/// 与麻醉科相关的判断Apply,Decline,Receive,InRoom,Operate,LeaveRoom,Finish,NotApp
ClassMethod GetCheckFeeOPAS(ind, PAADMRowId, InDaysCount) As %String
{
	//w ##class(web.DHCCAbFeeCheck).GetCheckFeeExec(10,13571477,600)
	s abnormal=$p(^DHCCAbFeeConfig("YCFeeCheck",ind),"^",3),Mem="正常"
	s OrderID=$o(^OEORD(0,"Adm",PAADMRowId,""))
	s i=0
	s ssflag=0,ssordflag=0,opdescs=""
	s op="" f  s op=$o(^DHCANOPArrange(0,"Adm",PAADMRowId,op)) q:op=""  d
	.s opstatus=$p(^DHCANOPArrange(op),"^",27)
	.q:(opstatus="A")!(opstatus="D")!(opstatus="N")
	.s arrdate=$p(^DHCANOPArrange(op),"^",7)
	.s arrtime=$p(^DHCANOPArrange(op),"^",8)
	.s arrusr=$p(^DHCANOPArrange(op),"^",9)
	.q:(arrdate'="")!(arrusr'="")
	.s ssflag=1
	.s arrdate=$zd(arrdate,3)
	.s anaId=$P($G(^DHCANOPArrange(op)),"^",2)
	.s anaSub=$P(anaId,"||",2)
	.f  s anaopSub=$O(^OR(PAADMRowId,"ANA",anaSub,"OP",anaopSub)) q:(anaopSub="")||(anaopSub=0)  d
	..s opDr=$P($G(^OR(PAADMRowId,"ANA",anaSub,"OP",anaopSub)),"^",6)
	..i opDr'=""  s opdesc=$P($G(^ORC("OPER",operDr)),"^",2)
	..e  s opdesc=""
	..i opdescs="" s opdescs=arrdate_"|"_opdesc
	..e  s opdescs=opdescs_"|"_arrdate_"|"_opdesc

	i ssflag=1 d   //患者有进行了的手术
	.s locs=""   //标版手术麻醉科室应该是在这个表维护CT_LocationList_Locations
	.s ll="" f  s ll=$o(^CT("LL",ll)) q:ll=""  d
	..s llcode=$p(^CT("LL",ll),"^",1)
	..i llcode["AN" d
	...s lll="" f  s lll=$o(^CT("LL",ll,"LOC",lll)) q:lll=""  d
	....s lloc=$p(^CT("LL",ll,"LOC",lll),"^",1)
	....s locs=locs_"^"_lloc

	.s OrdItemCld=0 f  s OrdItemCld=$o(^OEORD(OrderID,"I",OrdItemCld))  q:OrdItemCld=""  d
	..s itmstat=$p(^OEORD(OrderID,"I",OrdItemCld,1),"^",13)
    ..q:(itmstat'=1)&&(itmstat'=6)
	..s retPrice=##class(web.UDHCJFPRICE).GetOrderPrice("", "", ItmMastDR, +$h, "", "", "", "")
	..s Price=$P(retPrice,"^",1)
    ..q:+Price=0   //无费用的医嘱不管
	...s ItmMastDR=$p(^OEORD(OrderID,"I",OrdItemCld,1),"^",2)
	...s ArcCatRowID="",OrdCatDr=""
	...s ItmMastDesc=$p(^ARCIM(+ItmMastDR,1,1),"^",2)
	...s ArcCatRowID = $p($g(^ARCIM(+ItmMastDR,1,1)),"^",10)
	...s:ArcCatRowID'="" OrdCatDr=$p($g(^ARC("IC",ArcCatRowID)),"^",8)
	...s orddept=$p(^OEORD(OrderID,"I",OrdItemCld,1),"^",3)
	...i locs[orddept d
	....s ssordflag=1   //有手麻开的有效医嘱
    .i ssordflag=0 d
    ..i Mem="正常" s Mem=opdescs
    ..e  s Mem=Mem_"|"_opdescs
    .s i=i+1

    
   
	q i_"^"_abnormal_"^"_Mem
}

/// 通用 判断检验检查医嘱核实未执行的
ClassMethod GetCheckFeeLisRis(ind, PAADMRowId, InDaysCount) As %String
{
	//w ##class(web.DHCCAbFeeCheck).GetCheckFeeExec(10,13571477,600)
	s abnormal=$p(^DHCCAbFeeConfig("YCFeeCheck",ind),"^",3),Mem="正常"
	s OrderID=$o(^OEORD(0,"Adm",PAADMRowId,""))
	s pbqtys=0
	s i=0
	s OrdItemCld=0 f  s OrdItemCld=$o(^OEORD(OrderID,"I",OrdItemCld))  q:OrdItemCld=""  d
	.s ItmMastDR=$p(^OEORD(OrderID,"I",OrdItemCld,1),"^",2)
	.s ArcCatRowID="",OrdCatDr=""
	.s ItmMastDesc=$p(^ARCIM(+ItmMastDR,1,1),"^",2)
	.s ArcCatRowID = $p($g(^ARCIM(+ItmMastDR,1,1)),"^",10)
	.s:ArcCatRowID'="" OrdCatDr=$p($g(^ARC("IC",ArcCatRowID)),"^",8)
	
	.s qflag=0
    .s arctype="" f  s arctype=$o(^DHCCAbFeeConfig("Details",ind,arctype)) q:arctype=""  d
    ..//b   ;1
    ..i arctype="OECCAT" d  //按大类
    ...i $d(^DHCCAbFeeConfig("Details",ind,arctype,OrdCatDr)) d
    ....s qflag=1
    ..i arctype="ARCIC" d  //按子类
    ...i $d(^DHCCAbFeeConfig("Details",ind,arctype,ArcCatRowID)) d
    ....s qflag=1
    ..i arctype="ARCIM" d  //按医嘱项
    ...i $d(^DHCCAbFeeConfig("Details",ind,arctype,ItmMastDR)) d
    ....s qflag=1
    .q:qflag=0   
    .s itmstat=$p(^OEORD(OrderID,"I",OrdItemCld,1),"^",13)
	.s addusr=$p(^OEORD(OrderID,"I",OrdItemCld,7),"^",1)
	.i addusr'="" s addusr=$p(^SSU("SSUSR",addusr),"^",2)
	.s ordstdate=$p(^OEORD(OrderID,"I",OrdItemCld,1),"^",9)
	.s ordstdate=$zd(ordstdate,3)
    .//q:itmstat=4   //停止
    .//q:itmstat=11   //未激活
    .q:(itmstat'=1)   //&&(itmstat'=6)
    .i Mem="正常" s Mem=addusr_"|"_ordstdate_"|"_ItmMastDesc
    .e  s Mem=Mem_"|"_addusr_"|"_ordstdate_"|"_ItmMastDesc
    .s i=i+1

    
   
	q i_"^"_abnormal_"^"_Mem
}

/// 通用 判断医嘱与住院天数的关系
ClassMethod GetCheckFeeGE(ind, PAADMRowId, InDaysCount, indate, outdate) As %String
{
	//w ##class(web.DHCCAbFeeCheck).GetCheckFeeGE(1,13583975,600)
	s abnormal=$p(^DHCCAbFeeConfig("YCFeeCheck",ind),"^",3),Mem="正常"
	s OrderID=$o(^OEORD(0,"Adm",PAADMRowId,""))
	s pbqtys=0
	s OrdItemCld=0 f  s OrdItemCld=$o(^OEORD(OrderID,"I",OrdItemCld))  q:OrdItemCld=""  d
	.s ItmMastDR=$p(^OEORD(OrderID,"I",OrdItemCld,1),"^",2)
	.s ArcCatRowID="",OrdCatDr=""
	.s ItmMastDesc=$p(^ARCIM(+ItmMastDR,1,1),"^",2)
	.s ArcCatRowID = $p($g(^ARCIM(+ItmMastDR,1,1)),"^",10)
	.s:ArcCatRowID'="" OrdCatDr=$p($g(^ARC("IC",ArcCatRowID)),"^",8)
	
	.s qflag=0
    .s arctype="" f  s arctype=$o(^DHCCAbFeeConfig("Details",ind,arctype)) q:arctype=""  d
    ..//b   ;1
    ..i arctype="OECCAT" d  //按大类
    ...i $d(^DHCCAbFeeConfig("Details",ind,arctype,OrdCatDr)) d
    ....s qflag=1
    ..i arctype="ARCIC" d  //按子类
    ...i $d(^DHCCAbFeeConfig("Details",ind,arctype,ArcCatRowID)) d
    ....s qflag=1
    ..i arctype="ARCIM" d  //按医嘱项
    ...i $d(^DHCCAbFeeConfig("Details",ind,arctype,ItmMastDR)) d
    ....s qflag=1
    .q:qflag=0   
    .//b  ;2
    .s pb="" f  s pb=$o(^DHCPBi(0,"OEORI",OrderID_"||"_OrdItemCld,pb)) q:pb=""  d
    ..s pbo="" f  s pbo=$o(^DHCPBi(0,"OEORI",OrderID_"||"_OrdItemCld,pb,pbo)) q:pbo=""  d
    ...s pbflag=$p(^DHCPB(pb,"O",pbo),"^",16)
    ...//q:pbflag=""
    ...s pbqty=$p(^DHCPB(pb,"O",pbo),"^",5)
    ...s refundqty=$p(^DHCPB(pb,"O",pbo),"^",6)
    ...s pbqtys=pbqtys+pbqty+refundqty

    
   i InDaysCount>pbqtys d
	.s YCCount=InDaysCount-pbqtys
	.s Mem="少"_YCCount
	e  i InDaysCount<pbqtys
	.s YCCount=pbqtys-InDaysCount
	.s Mem="多"_YCCount
   
	q InDaysCount_"^"_abnormal_"^"_Mem
}

/// 对药品的发药数量与计费数量的比对 防止按频次时候发药数与计费数不符
ClassMethod GetCheckDrugFee(ind, PAADMRowId, InDaysCount, indate, outdate) As %String
{
	//w ##class(web.DHCCAbFeeCheck).GetCheckFeeGE(1,13583975,600)
	s abnormal=$p(^DHCCAbFeeConfig("YCFeeCheck",ind),"^",3),Mem="正常"
	s OrderID=$o(^OEORD(0,"Adm",PAADMRowId,""))
	s pbqtys=0
	s OrdItemCld=0 f  s OrdItemCld=$o(^OEORD(OrderID,"I",OrdItemCld))  q:OrdItemCld=""  d
	.s ItmMastDR=$p(^OEORD(OrderID,"I",OrdItemCld,1),"^",2)
	.s ArcCatRowID="",OrdCatDr="",DSPQtySum=0,cflag=0,PBOQty=0
	.s ItmMastDesc=$p(^ARCIM(+ItmMastDR,1,1),"^",2)
	.s ArcCatRowID = $p($g(^ARCIM(+ItmMastDR,1,1)),"^",10)
	.s:ArcCatRowID'="" OrdCatDr=$p($g(^ARC("IC",ArcCatRowID)),"^",8)
	.s OEORIRowid=OrderID_"||"_OrdItemCld
	.s qflag=0
    .s arctype="" f  s arctype=$o(^DHCCAbFeeConfig("Details",ind,arctype)) q:arctype=""  d
    ..//b   ;1
    ..i arctype="OECCAT" d  //按大类
    ...i $d(^DHCCAbFeeConfig("Details",ind,arctype,OrdCatDr)) d
    ....s qflag=1
    ..i arctype="ARCIC" d  //按子类
    ...i $d(^DHCCAbFeeConfig("Details",ind,arctype,ArcCatRowID)) d
    ....s qflag=1
    ..i arctype="ARCIM" d  //按医嘱项
    ...i $d(^DHCCAbFeeConfig("Details",ind,arctype,ItmMastDR)) d
    ....s qflag=1
    .q:qflag=0   
    .s prior="",priorcode=""
    .s prior=$p(^OEORD(OrderID,"I",OrdItemCld,1),"^",8) 
    .i prior'=""  d
    ..s priorcode=$p($g(^OECPR(+prior)),"^",1)
    .s sttdate=$p(^OEORD(OrderID,"I",OrdItemCld,1),"^",9) 
    .s sttdate=$zd(sttdate,3)
    .q:(priorcode="OUT")

	.s UserLoc=$p(^OEORD(OrderID,"I",OrdItemCld,7),"^",2)
	.s RecLoc=$p(^OEORD(OrderID,"I",OrdItemCld,3),"^",6)
	.s reclocdesc=$p(^CTLOC(RecLoc),"^",1) 
	.i $d(^CTLOC(RecLoc,"LINK",0,"Loc",UserLoc)) d
	..s LinkFlag="Y"
	.e  d
	..s LinkFlag="N"
    .q:(LinkFlag="Y")  //下医嘱科室与发药科室是关联科室;例如麻醉科与药房
    .//关联科室一般的费用已经记了 但是出院的时候可能还没发药 不应该进行判断
    .q:($d(^DHCOEDISQTY(0,"OEORI",OEORIRowid))=0)
    .//得到发药数量 合肥总院老版药房不走这个^DHCOEDISQTY
    .s DspRowid="0",DSPQtySum=0
    .f  s DspRowid=$o(^DHCOEDISQTY(0,"OEORI",OEORIRowid,DspRowid))  q:(DspRowid="")  d
    ..s DspStatus=$p(^DHCOEDISQTY(DspRowid),"^",7)
    ..q:(DspStatus="TC")
    ..s DspQty=$p(^DHCOEDISQTY(DspRowid),"^",11)
    ..i DspStatus="C"  d
    ...s DSPQtySum=DSPQtySum+DspQty
    ..i DspStatus="R"  d
    ...s DSPQtySum=DSPQtySum-DspQty

    .//得到计费数量
    .s pb="" f  s pb=$o(^DHCPBi(0,"OEORI",OEORIRowid,pb)) q:pb=""  d
    ..s pbo="" f  s pbo=$o(^DHCPBi(0,"OEORI",OEORIRowid,pb,pbo)) q:pbo=""  d
    ...s pbflag=$p(^DHCPB(pb,"O",pbo),"^",16)
    ...//q:pbflag=""
    ...s PBOQty=$p(^DHCPB(pb,"O",pbo),"^",5)
    ...s PBORefQty=$p(^DHCPB(pb,"O",pbo),"^",6)
    ...s PBOQty=PBOQty+PBORefQty
    ...q:(DSPQtySum'>PBOQty)   // 双方都是按照基本单位走的
    ...s cflag=1
    ...s Qty=DSPQtySum-PBOQty
    .i cflag=1 d   //计费数量小于发药数量
    ..i Mem="正常" s Mem=sttdate_"|"_reclocdesc_"|"_ItmMastDesc_"|发药数"_DSPQtySum_"|计费数"_PBOQty
    ..e  s Mem=Mem_"|"_sttdate_"|"_reclocdesc_"|"_ItmMastDesc_"|发药数"_DSPQtySum_"|计费数"_PBOQty
    
   
	q InDaysCount_"^"_abnormal_"^"_Mem
}

/// 违规停医嘱(非本人所开且本人与患者病区不关联)
ClassMethod GetCheckStop(ind, PAADMRowId, InDaysCount) As %String
{
	//w ##class(web.DHCCAbFeeCheck).GetCheckStop(3,13571477,600)
	s abnormal=$p(^DHCCAbFeeConfig("YCFeeCheck",ind),"^",3),Mem="正常"
	s OrderID=$o(^OEORD(0,"Adm",PAADMRowId,""))
	s pbqtys=0
	s i=0
	s OrdItemCld=0 f  s OrdItemCld=$o(^OEORD(OrderID,"I",OrdItemCld))  q:OrdItemCld=""  d
	.s ItmMastDR=$p(^OEORD(OrderID,"I",OrdItemCld,1),"^",2)
	.s ArcCatRowID="",OrdCatDr=""
	.s ItmMastDesc=$p(^ARCIM(+ItmMastDR,1,1),"^",2)
    .s itmstat=$p(^OEORD(OrderID,"I",OrdItemCld,1),"^",13)
    .q:itmstat'=4   //停止
	.s retPrice=##class(web.UDHCJFPRICE).GetOrderPrice("", "", ItmMastDR, +$h, "", "", "", "")
	.s Price=$P(retPrice,"^",1)
    .q:+Price=0   //无费用的医嘱不管

 	.s orddoc=$p(^OEORD(OrderID,"I",OrdItemCld,1),"^",11)
 	.s stopdoc=$p(^OEORD(OrderID,"I",OrdItemCld,3),"^",29)
 	.s stopdoccode=""
 	.i stopdoc'="" s stopdoccode=$p(^CTPCP(stopdoc,1),"^",1)
 	.q:stopdoccode="SYS01"    //合肥一些自动停医嘱的任务
 	.s flag=0
 	.//i (orddoc'="")&&(stopdoc'="") d 床位费等无下医嘱人
 	.i stopdoc'="" d
 	..s locs=""
 	..s admward=$p(^PAADM(PAADMRowId),"^",70)
 	..s admwardloc=$p(^PAWARD(admward),"^",5)   //转成loc
 	..s orddept=$p(^OEORD(OrderID,"I",OrdItemCld,1),"^",3)
 	..s stopusr=$O(^SSU("SSUSR",0,"CTPCP",stopdoc,""))
 	..s loc=$p(^SSU("SSUSR",stopusr),"^",4)
 	..s locs=locs_"^"_loc
 	..s link="" f  s link=$o(^CTLOC(loc,"LINK",link)) q:link=""  d
 	...s linkloc=$p(^CTLOC(loc,"LINK",link),"^",1)
 	...s locs=locs_"^"_linkloc   //默认登陆科室的关联科室

 	..s aa="" f  s aa=$o(^SSU("SSUSR",stopusr,"OTHLL",aa)) q:aa=""  d
 	...s locother=$p(^SSU("SSUSR",stopusr,"OTHLL",aa),"^",1)
 	...q:locother=""
 	...s link="" f  s link=$o(^CTLOC(locother,"LINK",link)) q:link=""  d
 	....s linkloc=$p(^CTLOC(locother,"LINK",link),"^",1)
 	....s locs=locs_"^"_linkloc   //其他登陆科室的关联科室

 	...s locs=locs_"^"_locother 
 	..s locs=locs_"^"
 	..i (locs'[admwardloc)&&(locs'[orddept)  d  //停医嘱者 不属于患者相关科室与患者下医嘱科室
 	...s flag=1
 	.q:flag=0
 	.s stopdate=$p(^OEORD(OrderID,"I",OrdItemCld,3),"^",34)
 	.i stopdoc'="" s stopdoc=$p(^CTPCP(stopdoc,1),"^",2)
 	.//w !,stopdoc_"^"_ItmMastDesc_"!"_locs_"!"_orddept_"^"_admwardloc

	.s stopdate=$zd(stopdate,3)
	.i Mem="正常" s Mem=stopdoc_"|"_stopdate_"|"_ItmMastDesc
    .e  s Mem=Mem_"|"_stopdoc_"|"_stopdate_"|"_ItmMastDesc
    .s i=i+1
    q i_"^"_abnormal_"^"_Mem
}

/// 检查身份证号 出院前要补入完
ClassMethod GetCheckIDCard(ind, PAADMRowId, InDaysCount) As %String
{
	s abnormal=$p(^DHCCAbFeeConfig("YCFeeCheck",ind),"^",3),Mem="正常"
	s papmi=$p(^PAADM(PAADMRowId),"^",1)
	s idcard=$p(^PAPER(papmi,"PAT",3),"^",6)   // PAPMI_DVAnumber 18位 PatID18位容易丢失尾数
	i idcard="" s Mem="无身份证号"
	
	q InDaysCount_"^"_abnormal_"^"_Mem
}

/// 给护士最终结算界面调用与LookUpAbnormalFee基本一样
ClassMethod GetCheckFeeFinal(EpisodeID As %String, sureflag As %String) As %String
{
	//w ##class(web.DHCCAbFeeCheck).GetCheckFeeFinal(13583975,"")
	//s ^lgltest("0315")=EpisodeID_"^"_sureflag
	q:EpisodeID="" ""
	s wardId=$p($g(^PAADM(EpisodeID)),"^",70)
	q:wardId="" ""
	q:'$d(^DHCCAbFeeConfig("WardConfig",wardId)) ""
	s wardflag=$p(^DHCCAbFeeConfig("WardConfig",wardId),"^",1)
	q:wardflag=0 ""
	s oeordId=$o(^OEORD(0,"Adm",EpisodeID,""))
	q:oeordId="" ""
    s ret="",Tind=0	
    s bedSub=$p($p($g(^PAADM(EpisodeID)),"^",73),"||",2)

	i $g(bedSub)'="" s bedCode=$p($g(^PAWARD(wardId,"BED",bedSub)),"^",1) //床号
	s PaitentID=$p($g(^PAADM(EpisodeID)),"^",1)
	
	s regNo=$p(^PAPER(PaitentID,"PAT",1),"^",1)
	s patName=$p($g(^PAPER(+^PAADM(EpisodeID),"ALL")),"^",1) //姓名
	//系统的入院日 入床日 以及统计组的入床日 护管的入床日 四个日期 优先级递增
	//入院日
	s InBedDate1=$p(^PAADM(EpisodeID),"^",6)
	//入床日
	s firsttransbed=0
	s tran="" f  s tran=$o(^PAADM(EpisodeID,"TRANS",tran)) q:tran=""  d
	.q:firsttransbed=1
	.s tranbeddr=$p(^PAADM(EpisodeID,"TRANS",tran),"^",8)
	.i tranbeddr'="" d
	..s firsttransbed=1
	..s InBedDate1=$p(^PAADM(EpisodeID,"TRANS",tran),"^",1)
	//统计组的入床日
	i $d(^DHCMRIPDetail(0,"TYPE","RYRS","ADM",EpisodeID)) d
	.s iprowid=0 f  s iprowid=$o(^DHCMRIPDetail(0,"TYPE","RYRS","ADM",EpisodeID,iprowid)) q:iprowid=""  d
	..s MRIPDayDr=$p(^DHCMRIPDetail(iprowid),"^",3)
	..s InBedDate1=$p(^MRIPdaily(MRIPDayDr),"^",6)
	//护管程序的入床日
	s QTRECRowID=$o(^DHCADMQTREC("adm",EpisodeID,""))
	i $g(QTRECRowID)'="" s InBedDate1=$p(^DHCADMQTREC("QTREC",QTRECRowID),"^",2)
	
	s InBedDate=$zd(InBedDate1,3) //入院日期
	
	//医疗结算日期
	s OutDate1=$p(^PAADM(EpisodeID),"^",59)
	//最终结算日期
	i OutDate1="" s OutDate1=$p(^PAADM(EpisodeID),"^",17)
	
	//当前日期
	i $g(OutDate1)="" s OutDate1=+$h
	
	
	s OutDate=$zd(OutDate1,3)
    s PatInDays=OutDate1-InBedDate1
    
    
	s node=""
	f  s node=$o(^DHCCAbFeeConfig("YCFeeCheck",node)) q:node=""  d
	.s espression=$g(^DHCCAbFeeConfig("YCFeeCheck",node))
	.s classname=$p(espression,"^",1)
	.s ffname=$p(espression,"^",2)
	.//s ItmMast=$p(espression,"^",3)
	.s NormalDesc=$p(espression,"^",3)
	.s useflag=$p(espression,"^",4)
	.q:useflag=0   //停用
    .//空调日期单算
    .if node=7 d
    ..s ktfstart=$p(NormalDesc,"|",2)
    ..s ktfend=$p(NormalDesc,"|",3)
    ..s ktfstart=$zdh(ktfstart,3)
    ..s ktfend=$zdh(ktfend,3)
    ..i (ktfstart>OutDate1)!(ktfend<InBedDate1) d
    ...//收不到空调费
    ..e  d
    ...//有可收空调费
    ...if ktfstart<InBedDate1 s ktfstart=InBedDate1
    ...i ktfend>OutDate1 s ktfend=OutDate1
    ...s PatInDays=ktfend-ktfstart 
    .e   d
    ..s PatInDays=OutDate1-InBedDate1  
	.s checkflag="",checkstatus="",sureuser="",suretime="",suremem=""
	.//s checkrowid="" f  s checkrowid=$o(^DHCCAbFeeCheck(0,"ADM",EpisodeID,checkrowid)) q:checkrowid=""  d
	.i $d(^DHCCAbFeeCheck(0,"ADM",EpisodeID,node)) d
	..//按该规则已经审过 取最后一条状态记录
	..//s abndr=$p(^DHCCAbFeeCheck(checkrowid),"^",1)
	..s checkrowid=$o(^DHCCAbFeeCheck(0,"ADM",EpisodeID,node,""),-1)  //最后一条
	..s checkflag=$p(^DHCCAbFeeCheck(checkrowid),"^",6)
	..i checkflag=1 s checkstatus="已审"
	..i checkflag=0 s checkstatus="撤销"
	..s date=$p(^DHCCAbFeeCheck(checkrowid),"^",4)
	..s date=$zd(date,3)
	..s time=$p(^DHCCAbFeeCheck(checkrowid),"^",5)
	..s time=$zt(time)
	..s suretime=date_" "_time
	..s userdr=$p(^DHCCAbFeeCheck(checkrowid),"^",7)
	..s sureuser=$p(^SSU("SSUSR",userdr),"^",2)
	..s suremem=$p(^DHCCAbFeeCheck(checkrowid),"^",8)
	.q:(sureflag'="on")&&(checkflag=1)   //已审
	.q:(sureflag="on")&&((checkflag="")!(checkflag=0))  //未审以及撤销
	.s mth="##class("_classname_")."_ffname
	.s pp=node_","_EpisodeID_","_PatInDays     //_","_InBedDate1_","_OutDate1
	.//s ^test=pp
	.s mth=mth_"("_pp_")"
	.s c="a="_mth
	.set @c
	.s b="a"
	.s aa=@b
	.s TempDesc=a
	.//s TempDesc=..GetAdmYC(EpisodeID,"",PatInDays,InBedDate1,OutDate1)
	.s abnormalDesc=$p(TempDesc,"^",2)
	.s MemDesc=$p(TempDesc,"^",3)
	.s retInDays=$p(TempDesc,"^",1)
	.//i +retInDays'=0 
	.//s PatInDays=retInDays
	.q:MemDesc="正常"
	.//b    ;1
	.s Tind=Tind+1
	.s ret="根据系统设置的出院规则判断,有"_Tind_"条规则判断出可能异常 请先到出院审查界面处理"
	
	q ret
}

Query LookUpAbnormalFee(EpisodeID As %String, sureflag As %String) As %Query(ROWSPEC = "TRegNo,TPatName,TBedCode,TabnormalDesc,TInBedDate,TOutDate,TPatInDays,TMemDesc,Tind,TAdm,TSureStatus,TSureUser,TSureTime,TMemSure")
{
}

ClassMethod LookUpAbnormalFeeExecute(ByRef qHandle As %Binary, EpisodeID As %String, sureflag As %String) As %Status
{
 	s repid=$i(^CacheTemp)
 	i $g(ind)="" s ind=1
	i EpisodeID="" s qHandle=$lb(0,repid,0) q $$$OK
	s wardId=$p($g(^PAADM(EpisodeID)),"^",70)
	i wardId="" s qHandle=$lb(0,repid,0) q $$$OK
	s wardflag=$p(^DHCCAbFeeConfig("WardConfig",wardId),"^",1)
	i wardflag=0 s qHandle=$lb(0,repid,0) q $$$OK
	s oeordId=$o(^OEORD(0,"Adm",EpisodeID,""))
	i oeordId="" s qHandle=$lb(0,repid,0) q $$$OK
	s Tind=0
	
	s bedSub=$p($p($g(^PAADM(EpisodeID)),"^",73),"||",2)

	i $g(bedSub)'="" s bedCode=$p($g(^PAWARD(wardId,"BED",bedSub)),"^",1) //床号
	s PaitentID=$p($g(^PAADM(EpisodeID)),"^",1)
	
	s regNo=$p(^PAPER(PaitentID,"PAT",1),"^",1)
	s patName=$p($g(^PAPER(+^PAADM(EpisodeID),"ALL")),"^",1) //姓名
	//系统的入院日 入床日 以及统计组的入床日 护管的入床日 四个日期 优先级递增
	//入院日
	s InBedDate1=$p(^PAADM(EpisodeID),"^",6)
	//入床日
	s firsttransbed=0
	s tran="" f  s tran=$o(^PAADM(EpisodeID,"TRANS",tran)) q:tran=""  d
	.q:firsttransbed=1
	.s tranbeddr=$p(^PAADM(EpisodeID,"TRANS",tran),"^",8)
	.i tranbeddr'="" d
	..s firsttransbed=1
	..s InBedDate1=$p(^PAADM(EpisodeID,"TRANS",tran),"^",1)
	//统计组的入床日
	i $d(^DHCMRIPDetail(0,"TYPE","RYRS","ADM",EpisodeID)) d
	.s iprowid=0 f  s iprowid=$o(^DHCMRIPDetail(0,"TYPE","RYRS","ADM",EpisodeID,iprowid)) q:iprowid=""  d
	..s MRIPDayDr=$p(^DHCMRIPDetail(iprowid),"^",3)
	..s InBedDate1=$p(^MRIPdaily(MRIPDayDr),"^",6)
	//护管程序的入床日
	s QTRECRowID=$o(^DHCADMQTREC("adm",EpisodeID,""))
	i $g(QTRECRowID)'="" s InBedDate1=$p(^DHCADMQTREC("QTREC",QTRECRowID),"^",2)
	
	
	s InBedDate=$zd(InBedDate1,3) //入院日期
	
	//医疗结算日期
	s OutDate1=$p(^PAADM(EpisodeID),"^",59)
	//最终结算日期
	i OutDate1="" s OutDate1=$p(^PAADM(EpisodeID),"^",17)
	//离床日该如何取?尚未想出好的规则
	//当前日期
	i $g(OutDate1)="" s OutDate1=+$h
	
	
	s OutDate=$zd(OutDate1,3)
    s PatInDays=OutDate1-InBedDate1
    
    
	s node=""
	f  s node=$o(^DHCCAbFeeConfig("YCFeeCheck",node)) q:node=""  d
	.s espression=$g(^DHCCAbFeeConfig("YCFeeCheck",node))
	.s classname=$p(espression,"^",1)
	.s ffname=$p(espression,"^",2)
	.//s ItmMast=$p(espression,"^",3)
	.s NormalDesc=$p(espression,"^",3)
	.s useflag=$p(espression,"^",4)
	.q:useflag=0   //停用
    .//空调日期单算
    .if node=7 d
    ..s ktfstart=$p(NormalDesc,"|",2)
    ..s ktfend=$p(NormalDesc,"|",3)
    ..s ktfstart=$zdh(ktfstart,3)
    ..s ktfend=$zdh(ktfend,3)
    ..i (ktfstart>OutDate1)!(ktfend<InBedDate1) d
    ...//收不到空调费
    ..e  d
    ...//有可收空调费
    ...if ktfstart<InBedDate1 s ktfstart=InBedDate1
    ...i ktfend>OutDate1 s ktfend=OutDate1
    ...s PatInDays=ktfend-ktfstart 
    .e   d
    ..s PatInDays=OutDate1-InBedDate1  
	.s checkflag="",checkstatus="",sureuser="",suretime="",suremem=""
	.//s checkrowid="" f  s checkrowid=$o(^DHCCAbFeeCheck(0,"ADM",EpisodeID,checkrowid)) q:checkrowid=""  d
	.i $d(^DHCCAbFeeCheck(0,"ADM",EpisodeID,node)) d
	..//按该规则已经审过 取最后一条状态记录
	..//s abndr=$p(^DHCCAbFeeCheck(checkrowid),"^",1)
	..s checkrowid=$o(^DHCCAbFeeCheck(0,"ADM",EpisodeID,node,""),-1)  //最后一条
	..s checkflag=$p(^DHCCAbFeeCheck(checkrowid),"^",6)
	..i checkflag=1 s checkstatus="已审"
	..i checkflag=0 s checkstatus="撤销"
	..s date=$p(^DHCCAbFeeCheck(checkrowid),"^",4)
	..s date=$zd(date,3)
	..s time=$p(^DHCCAbFeeCheck(checkrowid),"^",5)
	..s time=$zt(time)
	..s suretime=date_" "_time
	..s userdr=$p(^DHCCAbFeeCheck(checkrowid),"^",7)
	..s sureuser=$p(^SSU("SSUSR",userdr),"^",2)
	..s suremem=$p(^DHCCAbFeeCheck(checkrowid),"^",8)
	.q:(sureflag'="on")&&(checkflag=1)   //已审
	.q:(sureflag="on")&&((checkflag="")!(checkflag=0))  //未审以及撤销
	.s mth="##class("_classname_")."_ffname
	.s pp=node_","_EpisodeID_","_PatInDays     //_","_InBedDate1_","_OutDate1
	.//s ^test=pp
	.s mth=mth_"("_pp_")"
	.s c="a="_mth
	.set @c
	.s b="a"
	.s aa=@b
	.s TempDesc=a
	.//s TempDesc=..GetAdmYC(EpisodeID,"",PatInDays,InBedDate1,OutDate1)
	.s abnormalDesc=$p(TempDesc,"^",2)
	.s MemDesc=$p(TempDesc,"^",3)
	.s retInDays=$p(TempDesc,"^",1)
	.//i +retInDays'=0 
	.//s PatInDays=retInDays
	.q:MemDesc="正常"
	.s Tind=Tind+1
	.d OutputRow

 			s qHandle=$lb(0,repid,0)
 			//k ^TMP("Discon",$i)
			q $$$OK
    
OutputRow
		s Data=$lb(regNo,patName,bedCode,abnormalDesc,InBedDate,OutDate,PatInDays,MemDesc,node,EpisodeID,checkstatus,sureuser,suretime,suremem)
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

Query LookUpAbFeeAll(nodes As %String, wardid As %String, Sdate As %String, Edate As %String, Outflag As %String, Inflag As %String, Sureflag As %String) As %Query(ROWSPEC = "TWard,TRegNo,TPatName,TBedCode,TabnormalDesc,TInBedDate,TOutDate,TPatInDays,TMemDesc,Tind,TAdm,TSureStatus,TSureUser,TSureTime,TMemSure")
{
}

ClassMethod LookUpAbFeeAllExecute(ByRef qHandle As %Binary, nodes As %String, wardid As %String, Sdate As %String, Edate As %String, Outflag As %String, Inflag As %String, Sureflag As %String) As %Status
{
	//d ##class(%ResultSet).RunQuery("web.DHCCAbFeeCheck","LookUpAbFeeAll","1^2^3","",63261,63261,"","on","")
	//s ^lgltest("0315")=nodes_"^"_wardid_"^"_Sdate_"^"_Edate_"^"_Outflag_"^"_Inflag_"^"_Sureflag
 	s repid=$i(^CacheTemp)
 	i $g(ind)="" s ind=1
	i nodes="" s qHandle=$lb(0,repid,0) q $$$OK
	i Sdate="" s qHandle=$lb(0,repid,0) q $$$OK
	i Edate="" s qHandle=$lb(0,repid,0) q $$$OK
	s Tind=0
	k AdmList
	i Outflag="on" d   //按照出院查
	.f date=Sdate:1:Edate d
	..s adm="" f  s adm=$o(^PAADMi("DischDate",date,adm)) q:adm=""  d
	...s admtype=$p(^PAADM(adm),"^",2)
	...q:admtype'="I"
	...s admward=$p(^PAADM(adm),"^",70)
	...q:admward=""
	...q:(wardid'="")&&(wardid'=admward)
	...s AdmList(admward,adm)=""
	i Inflag="on" d   //按照在院查
	.s curward="" f  s curward=$o(^PAADMi("CurrWard",curward)) q:curward=""  d
	..q:(wardid'="")&&(wardid'=curward)
	..s curroom="" f  s curroom=$o(^PAADMi("CurrWard",curward,curroom)) q:curroom=""  d
	...s adm="" f  s adm=$o(^PAADMi("CurrWard",curward,curroom,adm)) q:adm=""  d
	....s admtype=$p(^PAADM(adm),"^",2)
	....q:admtype'="I"
	....s admdate=$p(^PAADM(adm),"^",6)
	....q:admdate<Sdate
	....q:admdate>Edate
	....s AdmList(curward,adm)=""
	i Sureflag="on" d
	.s adm="" f  s adm=$o(^DHCCAbFeeCheck(0,"ADM",adm)) q:adm=""  d
	..s admward=$p(^PAADM(adm),"^",70)
	..q:(wardid'="")&&(wardid'=admward)
	..s discdate=$p(^PAADM(adm),"^",17)
	..q:discdate<Sdate
	..q:discdate>Edate
	..s AdmList(admward,adm)=""
	..
	
	s ward="" f  s ward=$o(AdmList(ward)) q:ward=""  d
	.s warddesc=$p(^PAWARD(ward),"^",1)
	.s adm="" f  s adm=$o(AdmList(ward,adm)) q:adm=""  d
	..s oeordId=$o(^OEORD(0,"Adm",adm,""))
	..q:oeordId=""
	..s bedSub=$p($p($g(^PAADM(adm)),"^",73),"||",2)
    ..i $g(bedSub)'="" s bedCode=$p($g(^PAWARD(ward,"BED",bedSub)),"^",1) //床号
    ..s PaitentID=$p($g(^PAADM(adm)),"^",1)
	
	..s regNo=$p(^PAPER(PaitentID,"PAT",1),"^",1)
	..s patName=$p($g(^PAPER(PaitentID,"ALL")),"^",1) //姓名
	..//系统的入院日 入床日 以及统计组的入床日 护管的入床日 四个日期 优先级递增
	..//入院日
	..s InBedDate1=$p(^PAADM(adm),"^",6)
	..//入床日
	..s firsttransbed=0
	..s tran="" f  s tran=$o(^PAADM(adm,"TRANS",tran)) q:tran=""  d
	...q:firsttransbed=1
	...s tranbeddr=$p(^PAADM(adm,"TRANS",tran),"^",8)
	...i tranbeddr'="" d
	....s firsttransbed=1
	....s InBedDate1=$p(^PAADM(adm,"TRANS",tran),"^",1)
	..//统计组的入床日
	..i $d(^DHCMRIPDetail(0,"TYPE","RYRS","ADM",adm)) d
	...s iprowid=0 f  s iprowid=$o(^DHCMRIPDetail(0,"TYPE","RYRS","ADM",adm,iprowid)) q:iprowid=""  d
	....s MRIPDayDr=$p(^DHCMRIPDetail(iprowid),"^",3)
	....s InBedDate1=$p(^MRIPdaily(MRIPDayDr),"^",6)
	..//护管程序的入床日
	..s QTRECRowID=$o(^DHCADMQTREC("adm",adm,""))
	..i $g(QTRECRowID)'="" s InBedDate1=$p(^DHCADMQTREC("QTREC",QTRECRowID),"^",2)
	..s InBedDate=$zd(InBedDate1,3) //入院日期
	..//医疗结算日期
	..s OutDate1=$p(^PAADM(adm),"^",59)
	..//最终结算日期
	..i OutDate1="" s OutDate1=$p(^PAADM(adm),"^",17)
	..//离床日该如何取?尚未想出好的规则
	..//当前日期
	..i $g(OutDate1)="" s OutDate1=+$h
	
	
	..s OutDate=$zd(OutDate1,3)
    ..s PatInDays=OutDate1-InBedDate1
    
    
	..s len=$l(nodes,"^")
    ..f j=1:1:len d
    ...s node=$p(nodes,"^",j)
	...s espression=$g(^DHCCAbFeeConfig("YCFeeCheck",node))
	...s classname=$p(espression,"^",1)
	...s ffname=$p(espression,"^",2)
	...//s ItmMast=$p(espression,"^",3)
	...s NormalDesc=$p(espression,"^",3)
	...s useflag=$p(espression,"^",4)
	...q:useflag=0   //停用
    ...//空调日期单算
    ...if node=7 d
    ....s ktfstart=$p(NormalDesc,"|",2)
    ....s ktfend=$p(NormalDesc,"|",3)
    ....s ktfstart=$zdh(ktfstart,3)
    ....s ktfend=$zdh(ktfend,3)
    ....i (ktfstart>OutDate1)!(ktfend<InBedDate1) d
    .....//收不到空调费
    ....e  d
    .....//有可收空调费
    .....if ktfstart<InBedDate1 s ktfstart=InBedDate1
    .....i ktfend>OutDate1 s ktfend=OutDate1
    .....s PatInDays=ktfend-ktfstart 
    ...e   d
    ....s PatInDays=OutDate1-InBedDate1  
	...s checkflag="",checkstatus="",sureuser="",suretime="",suremem=""
	...//s checkrowid="" f  s checkrowid=$o(^DHCCAbFeeCheck(0,"ADM",EpisodeID,checkrowid)) q:checkrowid=""  d
	...i $d(^DHCCAbFeeCheck(0,"ADM",adm,node)) d
	....//按该规则已经审过 取最后一条状态记录
	....//s abndr=$p(^DHCCAbFeeCheck(checkrowid),"^",1)
	....s checkrowid=$o(^DHCCAbFeeCheck(0,"ADM",adm,node,""),-1)  //最后一条
	....s checkflag=$p(^DHCCAbFeeCheck(checkrowid),"^",6)
	....i checkflag=1 s checkstatus="已审"
	....i checkflag=0 s checkstatus="撤销"
	....s date=$p(^DHCCAbFeeCheck(checkrowid),"^",4)
	....s date=$zd(date,3)
	....s time=$p(^DHCCAbFeeCheck(checkrowid),"^",5)
	....s time=$zt(time)
	....s suretime=date_" "_time
	....s userdr=$p(^DHCCAbFeeCheck(checkrowid),"^",7)
	....s sureuser=$p(^SSU("SSUSR",userdr),"^",2)
	....s suremem=$p(^DHCCAbFeeCheck(checkrowid),"^",8)
	...q:(Sureflag'="on")&&(checkflag=1)   //已审
	...q:(Sureflag="on")&&((checkflag="")!(checkflag=0))  //未审以及撤销
	...s mth="##class("_classname_")."_ffname
	...s pp=node_","_adm_","_PatInDays     //_","_InBedDate1_","_OutDate1
	...s mth=mth_"("_pp_")"
	...s c="a="_mth
	...set @c
	...s b="a"
	...s aa=@b
	...s TempDesc=a
	...//s TempDesc=..GetAdmYC(EpisodeID,"",PatInDays,InBedDate1,OutDate1)
	...s abnormalDesc=$p(TempDesc,"^",2)
	...s MemDesc=$p(TempDesc,"^",3)
	...s retInDays=$p(TempDesc,"^",1)
	...//i +retInDays'=0 
	...//s PatInDays=retInDays
	...q:MemDesc="正常"
	...s Tind=Tind+1
	...d OutputRow2
            
 			s qHandle=$lb(0,repid,0)
 			K AdmList
			q $$$OK
    
OutputRow2
		s Data=$lb(warddesc,regNo,patName,bedCode,abnormalDesc,InBedDate,OutDate,PatInDays,MemDesc,node,adm,checkstatus,sureuser,suretime,suremem)
 		s ^CacheTemp(repid,ind)=Data
 		s ind=ind+1
		q
}

ClassMethod LookUpAbFeeAllFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = LookUpAbFeeAllExecute ]
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

ClassMethod LookUpAbFeeAllClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = LookUpAbFeeAllExecute ]
{
	s repid=$li(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

ClassMethod savesure(adm, abndr, flag, mem, other) As %String
{
	   //13626691,5,111111 cancel仍然用 insert 仅是flag变化1已审 0撤销
	   //w ##class(web.DHCCAbFeeCheck).savesure(13626691,5,111111,"")
	   //insert into DHCCAbFeeCheck values (5,13626691,115,1,62200,1,111111,"")
       s ret=""
       b   ;1
       s user=%session.Get("LOGON.USERID")
       s wardid=%session.Get("LOGON.WARDID")
       s cdate=+$h
       s ctime=$p($h,",",2)
       &sql(insert into DHCCAbFeeCheck values (:abndr,:adm,:wardid,:user,:cdate,:ctime,:flag,:mem,:other))

	   q SQLCODE
}

}
