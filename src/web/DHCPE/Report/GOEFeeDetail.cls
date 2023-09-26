Import SQLUser

/// 主要功能: 输出团体医嘱费用明细
Class web.DHCPE.Report.GOEFeeDetail Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 128;

/// 输出团体医嘱费用明细
/// d ##Class(web.DHCPE.Report.GOEFeeDetail).GOEFeeDetailImport("Out","","7")
ClassMethod GOEFeeDetailImport(itmjs As %Library.String = "", itmjsex As %Library.String = "", Instring As %Library.String = "") As %Status
{
   
    s HosPital=$g(^DHCPESetting("DHCPE","HospitalCode"))
	s Instring=""_"^"_""_"^"_Instring_"^"_""
	d ..StatisticOEItemFeeDetail(Instring,HosPital)

	i HosPital="SHDF"  S Data="体检项目"_"^"_"预约数量"_"^"_"预约金额"_"^"_"到达数量"_"^"_"到达金额"_"^"_"结算数量"_"^"_"结算金额"
	else  s Data="体检项目"_"^"_"已检数目"_"^"_"未检数目"_"^"_"总检数目"_"^"_"价格"_"^"_"应收金额"
	
	i ""'=itmjs d
	.s retval=itmjs_"('"_$ZCVT(Data,"O","JS")_"');"
	.&javascript<#(retval)#>

	s ItmMastDR=0
	f  s ItmMastDR=$O(^DHCPETMP("SOS", "ARCIM", ItmMastDR)) Q:(""=ItmMastDR)  d
	.s Data=$G(^DHCPETMP("SOS", "ARCIM", ItmMastDR,"Data"))
	.i ""'=itmjs d
	..s retval=itmjs_"('"_$ZCVT(Data,"O","JS")_"');"
	..&javascript<#(retval)#>
	Q 0
}

/// 统计医嘱状况
/// d ##Class(web.DHCPE.Report.GOEFeeDetail).StatisticOEItemFeeDetail("^^89^","SHDF")
ClassMethod StatisticOEItemFeeDetail(Instring As %Library.String = "", HosPital) As %Status
{
	s ^zl("PIADMRowId")=Instring
	s RegNo = $P(Instring, "^", 1)
	s Name = $P(Instring, "^", 2)
	s GAdmDR = $P(Instring, "^", 3)
	s GTAdmDR = $P(Instring, "^", 4)
 	k ^DHCPETMP("SOS")
 	k ^DHCPETMP("ItemList")
 	s ^DHCPETMP("SOS", "StatisticOEItemFeeDetail")=Instring
	
	
	// 按团体 
	i (""'=GAdmDR)&(""=GTAdmDR) d
	.i HosPital="SHDF"  d
	..s PIADMRowId=0
	..f  s PIADMRowId=$O(^DHCPEPreIADM(0, "PGADM", GAdmDR, PIADMRowId)) q:PIADMRowId=""  d
	...s CurData=$g(^DHCPEPreIADM(PIADMRowId))
	...s PIADMStatus=$p(CurData,"^",8)
	...Q:("CANCELPREREG"=PIADMStatus)
	...Q:("CANCELPE"=PIADMStatus)
	...d ..GetIADMItemDetail(PIADMRowId)
	.else  d
	..s PIADMRowId=0
	..f  s PIADMRowId=$O(^DHCPEPreIADM(0, "PGADM", GAdmDR, PIADMRowId)) q:PIADMRowId=""  d
	...
	...s CurData=$g(^DHCPEPreIADM(PIADMRowId))
	...
	...// PIADM_Status
	...s PIADMStatus=$p(CurData,"^",8)
	...Q:("ARRIVED"'=PIADMStatus)
	...// PIADM_PIBI_DR
	...s PIBIDR=$p(CurData, "^", 1)
	...// DHC_PE_PreIBaseInfo.{PIBI_Name }	姓名
	...s PIBIDRName=$p($g(^DHCPEPreIBI(PIBIDR)), "^", 2)
	...q:(""'=Name)&(PIBIDRName'[Name)
	...
	...// DHC_PE_IADM.{ IADM_RowId }
	...s IADMRowId=0
	...f  s IADMRowId=$O(^DHCPEIADM(0, "CRMADM", PIADMRowId, IADMRowId)) Q:(""=IADMRowId)  d
	....// DHC_PE_IADM.{ IADM_PAADM_DR }
	....s PAADMDR=$P($G(^DHCPEIADM(IADMRowId)), "^", 1)
	....
	....s ^DHCPETMP("SOS", "PAADM", PAADMDR)=PIBIDRName
	....//w "PAADMDR:"_PAADMDR_"  PIBIDRName:"_PIBIDRName,!
	....s ^DHCPETMP("SOS", "PIADM", PIADMRowId)=PIBIDRName
 	
	// 按团体组
	i (""'=GTAdmDR)&(""=GTAdmDR) d
	.s PIADMRowId=0
	.f  s PIADMRowId=$O(^DHCPEPreIADM(0, "PGTeam", GTAdmDR, PIADMRowId)) q:PIADMRowId=""  d
	..s CurData=$g(^DHCPEPreIADM(PIADMRowId))
	..
	..// PIADM_Status
	..s PIADMStatus=$p(CurData,"^",8)
	..Q:("ARRIVED"'=PIADMStatus)
	..// PIADM_PIBI_DR
	..s PIBIDR=$p(CurData, "^", 1)
	..// DHC_PE_PreIBaseInfo.{PIBI_Name }	姓名
	..s PIBIDRName=$p($g(^DHCPEPreIBI(PIBIDR)), "^", 2)
	..q:(""'=Name)&(PIBIDRName'[Name)
	..
	..// DHC_PE_IADM.{ IADM_RowId }
	..s IADMRowId=0
	..f  s IADMRowId=$O(^DHCPEIADM(0, "CRMADM", PIADMRowId, IADMRowId)) Q:(""=IADMRowId)  d
	...// DHC_PE_IADM.{ IADM_PAADM_DR }
	...s PAADMDR=$P($G(^DHCPEIADM(IADMRowId)), "^", 1)
	...
	...s ^DHCPETMP("SOS", "PAADM", PAADMDR)=PIBIDRName
	...//w "PAADMDR:"_PAADMDR_"  PIBIDRName:"_PIBIDRName,!
	..s ^DHCPETMP("SOS", "PIADM", PIADMRowId)=PIBIDRName
	..
 	
 	//	///////////////////////		统计		/////////////////////////////////// 	
	s PAADM="0"
	f  s PAADM=$O(^DHCPETMP("SOS", "PAADM", PAADM)) q:PAADM=""  d
	.s Name=$G(^DHCPETMP("SOS", "PAADM", PAADM))
	.//w "PAADMDR:"_PAADMDR_"  Name:"_Name
	.// OE_Order
	.s OEORDRowId=0
	.f  s OEORDRowId=$O(^OEORD(0,"Adm", PAADM , OEORDRowId)) Q:(""=OEORDRowId)  d
	..//w "  OEORDRowId:"_OEORDRowId,!
	..// OE_OrdItem.{ OEORI_Childsub }
	..s OEORIChildsub=0
	..f  s OEORIChildsub=$O(^OEORD(OEORDRowId,"I",OEORIChildsub)) Q:(""=OEORIChildsub)  d
	...
	...//医嘱状态 OEORI_ItemStat_DR(OEC_OrderStatus)
	...s OEORIItemStatDR=$p($G(^OEORD(OEORDRowId, "I", OEORIChildsub,1)),"^",13)
	...Q:(4=OEORIItemStatDR) //过滤停止医嘱
	...
	...// OE_OrdItem.{ OEORI_ItmMast_DR }
	...s ItmMastDR=$P(^OEORD(OEORDRowId, "I", OEORIChildsub, 1), "^", 2)
	...//w "  OEORIChildsub:"_OEORIChildsub_"   ItmMastDR:"_ItmMastDR, !
	...s ^DHCPETMP("SOS", "ARCIM", ItmMastDR, "ItemStat", 9999, "Count")=1+$G(^DHCPETMP("SOS", "ARCIM", ItmMastDR, "ItemStat", 9999, "Count"))
	...s ^DHCPETMP("SOS", "ARCIM", ItmMastDR, "ItemStat", OEORIItemStatDR, "Count")=1+$G(^DHCPETMP("SOS", "ARCIM", ItmMastDR, "ItemStat", OEORIItemStatDR, "Count"))
	...
	...
	s TotalAmount=0
	s ItmMastDR=0
	f  s ItmMastDR=$O(^DHCPETMP("SOS", "ARCIM", ItmMastDR)) Q:(""=ItmMastDR)  d
	.s Price=+##class(web.DHCPE.PreItemList).GetOrderPrice(ItmMastDR)
	.//s ^DHCPETMP("SOS", "ARCIM", ItmMastDR, "Price")=Price
	.s ARCIMDesc=$p(^ARCIM($p(ItmMastDR,"||",1),$p(ItmMastDR,"||",2),1),"^",2)
	.
	.//w "ItmMastDR:"_ItmMastDR_"  ARCIMDesc:"_ARCIMDesc,!
	.//s ItemStat=""
	.//f  s ItemStat=$O(^DHCPETMP("SOS", "ARCIM", ItmMastDR, "ItemStat", ItemStat)) Q:(""=ItemStat)  d
	.//.// OEC_OrderStatus.{OSTAT_Desc}
	.//.s:(9999'=ItemStat) OSTATDesc=$P($G(^OEC("OSTAT",OEORIItemStatDR)),"^",2)
	.//.s:(9999=ItemStat) OSTATDesc="总计"
	.//.s Count=$G(^DHCPETMP("SOS", "ARCIM", ItmMastDR, "ItemStat", ItemStat, "Count"))
	.//.w "  ItemStat:"_ItemStat_"  OSTATDesc:"_OSTATDesc_"  Count:"_Count,!
	.s VCount=+$G(^DHCPETMP("SOS", "ARCIM", ItmMastDR, "ItemStat", 1,"Count"))
	.s ECount=+$G(^DHCPETMP("SOS", "ARCIM", ItmMastDR, "ItemStat", 6,"Count"))
	.s TCount=+$G(^DHCPETMP("SOS", "ARCIM", ItmMastDR, "ItemStat", 9999,"Count"))
	.s TAmount=TCount*Price
	.s TotalAmount=TotalAmount+TAmount
	.s ^DHCPETMP("SOS", "ARCIM", ItmMastDR, "Data")=ARCIMDesc_"^"_VCount_"^"_ECount_"^"_TCount_"^"_$FN(+Price,"",2)_"^"_$FN(+TAmount, "", 2)

    s ItmMastDR=0,PreNum="",PreAmount="",ArrivedNum="",ArrivedAmount="",PayedNum="",PayedAmount=""
    f  s ItmMastDR=$o(^DHCPETMP("ItemList",ItmMastDR))  q:ItmMastDR=""  d
    .s ARCIMDesc=$p(^ARCIM($p(ItmMastDR,"||",1),$p(ItmMastDR,"||",2),1),"^",2)
    .s PreNum=$g(^DHCPETMP("ItemList",ItmMastDR,"PreARCIM"))
    .s PreAmount=$g(^DHCPETMP("ItemList",ItmMastDR,"PreARCIMAmount"))
    .s ArrivedNum=$g(^DHCPETMP("ItemList",ItmMastDR,"ArrivedARCIM"))
    .s ArrivedAmount=$g(^DHCPETMP("ItemList",ItmMastDR,"ArrivedARCIMAmount"))
    .s PayedNum=$g(^DHCPETMP("ItemList",ItmMastDR,"PayedARCIM"))
    .s PayedAmount=$g(^DHCPETMP("ItemList",ItmMastDR,"PayedARCIMAmount"))
    .s ^DHCPETMP("SOS", "ARCIM", ItmMastDR, "Data")=ARCIMDesc_"^"_PreNum_"^"_PreAmount_"^"_ArrivedNum_"^"_ArrivedAmount_"^"_PayedNum_"^"_PayedAmount
 	//s ^DHCPETMP("SOS", "ARCIM", "总计", "Data")="    总计:"_"^"_""_"^"_""_"^"_""_"^"_""_"^"_$FN(TotalAmount, "", 2)
	Q ""
}

ClassMethod GetIADMItemDetail(PIADMRowId) As %Status
{
    
    S PIOIChildSub=0
    f  s PIOIChildSub=$o(^DHCPEPreIADM(PIADMRowId,"ORDITEM",PIOIChildSub))  q:PIOIChildSub=""  d
    .s CurDate=$g(^DHCPEPreIADM(PIADMRowId,"ORDITEM",PIOIChildSub))
    .s PIOIDR=PIADMRowId_"||"_PIOIChildSub
    .s ItmMastDR=$p(CurDate,"^",1)
    .s ItemStat=$p(CurDate,"^",16)
    .q:ItemStat'=1
    .s PIOEDR=$p(CurDate,"^",2)
	.If PIOEDR'="" Do
	..d ##class(web.DHCPE.OrdSetsPrice).SplitOrdSetPrice(PIOEDR)
	..s EntFactAmountStr=..GFactAmountByOrd(PIOEDR,"G","ORDENT")
	..s EntFactTotalAmount=$p(EntFactAmountStr,"^",1)
	..s GFactAmount=$p(EntFactAmountStr,"^",2)
	..s GPayedAmount=$p(EntFactAmountStr,"^",3)
	..s ItemFactAmount=^DHCPEDataEx("DHC_PE_PreIOrdItemFee","PIOEFEE",PIOEDR,PIOIDR)
	..S ItemGFactAmount=(GFactAmount*ItemFactAmount)/EntFactTotalAmount
	.Else  Do
	..s ItemGFactAmount=+##class(web.DHCPE.HandlerPreOrds).GetFactAmountByItem(PIOIDR,"G","")
	..s ItemFactAmountStr=..GFactAmountByOrd(PIOIDR,"G","ORDITEM")
	..s GPayedAmount=$p(ItemFactAmountStr,"^",3)
    .s ^DHCPETMP("ItemList",ItmMastDR,"PreARCIM")=+$g(^DHCPETMP("ItemList",ItmMastDR,"PreARCIM"))+1
    .s ^DHCPETMP("ItemList",ItmMastDR,"PreARCIMAmount")=+$g(^DHCPETMP("ItemList",ItmMastDR,"PreARCIMAmount"))+ItemGFactAmount
    .i GPayedAmount'=0  d
    ..s ^DHCPETMP("ItemList",ItmMastDR,"PayedARCIM")=+$g(^DHCPETMP("ItemList",ItmMastDR,"PayedARCIM"))+1
    ..s ^DHCPETMP("ItemList",ItmMastDR,"PayedARCIMAmount")=+$g(^DHCPETMP("ItemList",ItmMastDR,"PayedARCIMAmount"))+GPayedAmount
    .s PIADMStatus=$p($g(^DHCPEPreIADM(PIADMRowId)),"^",8)
    .q:PIADMStatus'="ARRIVED"
    .s ^DHCPETMP("ItemList",ItmMastDR,"ArrivedARCIM")=+$g(^DHCPETMP("ItemList",ItmMastDR,"ArrivedARCIM"))+1
    .s ^DHCPETMP("ItemList",ItmMastDR,"ArrivedARCIMAmount")=+$g(^DHCPETMP("ItemList",ItmMastDR,"ArrivedARCIMAmount"))+ItemGFactAmount
}

ClassMethod GFactAmountByOrd(PIOEDR, Type, ItemType) As %Status
{
   
    s iAdm=$p(PIOEDR,"||",1)
	s iSub=$p(PIOEDR,"||",2)
	s Sub=0
	s FactTotal=0,FactOneTotal=0,ChargedAmount=0
	f  s Sub=$o(^DHCPEPreIADM(iAdm,ItemType,iSub,"FEE",Sub)) q:Sub=""  d
	.s DataStr=$g(^DHCPEPreIADM(iAdm,ItemType,iSub,"FEE",Sub))
	.s AuditId=$p(DataStr,"^",5)
	.q:AuditId=""
	.s OneFact=$p(DataStr,"^",2)
	.s Flag=$p($g(^DHCPEPreA(AuditId)),"^",21)
	.q:Flag="NU"
	.s AuditType=$p($g(^DHCPEPreA(AuditId)),"^",1)
	.s FactTotal=FactTotal+OneFact
	.q:(Type'="")&&(AuditType'=Type)
	.s FactOneTotal=FactOneTotal+OneFact
	.S PAChargedStatus=$p($g(^DHCPEPreA(AuditId)),"^",14)
	.Q:PAChargedStatus="UNCHARGED"  //没付费
	.s ChargedAmount=ChargedAmount+OneFact
	q FactTotal_"^"_FactOneTotal_"^"_ChargedAmount
}

}
