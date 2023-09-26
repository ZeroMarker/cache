/// Created by SongDeBo 2006/6/13
/// Description: The base operation of order of team and personal.
/// 
Class web.DHCPE.HandlerPreOrds Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

Parameter BUILD = 1;

/// 
/// Description:获取团体的预约项目列表(OutItemIds)及其预约记录列表(OutGTOrdItemIds) 
/// 			Get the OrdItemIds which match OrdEntId	
/// parameter:
/// 		PGTOIARCOSDR	: DHC_PE_PreGTeam.{ PGT_RowId }		医嘱套
/// 		OutOrdItemIds	: output OutOrdItemIds, separated by "^"	返回团体分组项目 RowId 列表
/// 		OutItemIds		: output ItemIds, separated by "^"		返回医嘱项目列表
/// 	test: w ##class(web.DHCPE.HandlerPreOrds).IGetItemIdStr4GTOrdEnt("1||1||13",.GTOrdItemIds,.ItemIds)
ClassMethod IGetItemIdStr4GTOrdEnt(PGTRowId As %Library.String = "", OutPGTOIRowIds As %Library.String = "", OutPGTOIItmMastDRs As %Library.String = "")
{
	s ^tempdhcpe("webDHCPEHandlerPreOrds","IGetItemIdStr4GTOrdEnt")=""""_PGTRowId_","""_OutPGTOIRowIds_""","""_OutPGTOIItmMastDRs_""""
	Q:(""=PGTRowId) ""
	s gAdmId=$p(PGTRowId,"||",1)
	s gTeamId=$p(PGTRowId,"||",2)
	Q:(""=gAdmId)&(""=gTeamId) ""
	
	// 返回 团体预约的医嘱项目记录 的列表 
	s OutPGTOIRowIds=""
	// 返回 团体预约的 医嘱项目 列表
	s OutPGTOIItmMastDRs=""	
	
	s childId=""
	// 团体分组项目表 DHC_PE_PreGTOrdItem
	f  s childId=$o(^DHCPEPreGADM(gAdmId,"Team",gTeamId,"ORDITEM",childId))  q:childId=""  d
	.s CurData=$G(^DHCPEPreGADM(gAdmId,"Team",gTeamId,"ORDITEM",childId))
	.///排除无效的
	.s Flag=$p(CurData,"^",13)
	.q:Flag'=1
	.
	.Q:($p(CurData,"^",2)'=PGTRowId)
	.
	.s PGTOIRowId=gAdmId_"||"_gTeamId_"||"_childId
	.s PGTOIItmMastDR=$p(CurData,"^",1)
	.
	.s OutPGTOIRowIds=OutPGTOIRowIds_"^"_PGTOIRowId // 对应DHC_PE_PreGTOrdItem PGTOI_RowId
	.s OutPGTOIItmMastDRs=OutPGTOIItmMastDRs_"^"_PGTOIItmMastDR	// 对应DHC_PE_PreGTOrdItem PGTOI_ItmMast_DR 医嘱项目
	.	 
	
	//整理返回值格式　^15||3||3^15||3||4^15||3||5 --> 15||3||3^15||3||4^15||3||5
	i (OutPGTOIRowIds'="")  d
	.s OutPGTOIRowIds=$e(OutPGTOIRowIds,2,$l(OutPGTOIRowIds))
	.s OutPGTOIItmMastDRs=$e(OutPGTOIItmMastDRs,2,$l(OutPGTOIItmMastDRs))
	.
	q ""
}

ClassMethod GetIFee(PreIADM)
{
	s Amount=0
	s AID=0
	f  s AID=$O(^DHCPEPreA(0,"CRMADM","I",PreIADM,AID)) q:AID=""  d
	.s Status=$P(^DHCPEPreA(AID),"^",21)
	.q:Status="NU"
	.s OneAmt=$P(^DHCPEPreA(AID),"^",9)
	.s Amount=Amount+OneAmt
	q Amount
}

// ******************************************************************************

/// 功能：获取图体的金额 通过计算团体每个人员的金额实现
/// 
/// return: totalAmount
/// test: w ##class(web.DHCPE.HandlerPreOrds).IGetAmount4Grp(33)
ClassMethod IGetAmount4Grp(AdmId)
{
	s ^tempdhcpe("web.DHCPE.HandlerPreOrds","IGetAmount4Grp")=AdmId
	s totalAmount=0
	s GATotal=0,GFTotal=0
	s iAdmId="0"
	for  s iAdmId=$o(^DHCPEPreIADM(0,"PGADM",AdmId,iAdmId))  q:iAdmId=""  d
	. s pAmount=..IGetAmount4Person(iAdmId)
	. s GATotal=GATotal+$p(pAmount,"^",1)
	. s GFTotal=GFTotal+$p(pAmount,"^",2)
	q GATotal_"^"_GFTotal
}

/// 功能：获取图体组的金额
/// 实现：通过计算团体每个人员的金额实现
/// return: totalAmount
/// test: w ##class(web.DHCPE.HandlerPreOrds).IGetAmount4Team(33||2)
ClassMethod IGetAmount4Team(AdmId)
{
	s ^tempdhcpe("web.DHCPE.HandlerPreOrds","IGetAmount4Team")=AdmId
	s totalAmount=0
	s TATotal=0,TFTotal=0
	s iAdmId="0"
	for  s iAdmId=$o(^DHCPEPreIADM(0,"PGTeam",AdmId,iAdmId))  q:iAdmId=""  d 
	. s pAmount=..IGetAmount4Person(iAdmId)
	. s TATotal=TATotal+$p(pAmount,"^",1)
	. s TFTotal=TFTotal+$p(pAmount,"^",2)
	q TATotal_"^"_TFTotal
}

/// 获取个人的应收金额(医嘱费用)
/// return: totalAmount
/// test: w ##class(web.DHCPE.HandlerPreOrds).IGetAmount4Person(206)
ClassMethod IGetAmount4Person(AdmId)
{
	s ^tempdhcpe("web.DHCPE.HandlerPreOrds","IGetAmount4Person")=AdmId
	s OutAmount=""
	s FTotal=0,ATotal=0
	//获取医嘱项目的金额
	s totalAmount=..GetAmount4POrdItm(AdmId)
	s ATotal=$p(totalAmount,"^",1)
	s FTotal=$p(totalAmount,"^",2)
	/***注: iMedical8.5套餐价格已存在项目价格表,套餐价格表已不再存数据;***/
	/***注: iMedical8.5以前版本需要下面注释的代码***/
	/*
	//获取医嘱套的金额
	s totalAmount=..GetAmount4POrdEnt(AdmId)
	s ATotal=ATotal+$p(totalAmount,"^",1)
	s FTotal=FTotal+$p(totalAmount,"^",2)
	*/
	i $p(ATotal,".",1)="" s ATotal=0_ATotal
	s ATotal=$fn(ATotal,"",2)
	
	i $p(FTotal,".",1)="" s FTotal=0_FTotal
	s FTotal=$fn(FTotal,"",2)

	q ATotal_"^"_FTotal
}

/// 功能：获取个人所作的医嘱项目的应收金额
/// return: totalAmount
/// test: w ##class(web.DHCPE.HandlerPreOrds).GetAmount4POrdItm(AdmId)
ClassMethod GetAmount4POrdItm(AdmId)
{
	s childId="0",iFactAmount=0,iAccountAmount=0,iFactTotal=0,iAccountTotal=0
	f  s childId=$o(^DHCPEPreIADM(AdmId,"ORDITEM",childId)) q:childId=""  d 
	.s ItemID=AdmId_"||"_childId
	.s myStr=$G(^DHCPEPreIADM(AdmId,"ORDITEM",childId))
	.Q:(""=myStr)
	.///排除无效的
	.s Flag=$p(myStr,"^",16)
	.q:Flag'=1
	.s myOrdEntId=$p(myStr,"^",2)
	./***注: iMedical8.5套餐价格已存在项目价格表,套餐价格表已不再存数据;***/
	./***注: iMedical8.5以前版本需要下面注释的代码***/
	.;q:myOrdEntId'="" 
	.s iAccountAmount=$p(myStr,"^",14)
	.i iAccountAmount="" s iAccountAmount=0
	.s iAccountTotal=iAccountTotal+iAccountAmount
	.s iFactAmount=..GetFactAmountByItem(ItemID,"","")
	.s iFactTotal=iFactTotal+iFactAmount
	
	q iAccountTotal_"^"_iFactTotal
}

/// ##class(web.DHCPE.HandlerPreOrds).GetFactAmountByItem("","")
ClassMethod GetFactAmountByItem(ItemID, AdmType, AType)
{
	s iAdm=$p(ItemID,"||",1)
	s iSub=$p(ItemID,"||",2)
	s Sub=0
	s FactTotal=0
	f  s Sub=$o(^DHCPEPreIADM(iAdm,"ORDITEM",iSub,"FEE",Sub)) q:Sub=""  d
	.s DataStr=$g(^DHCPEPreIADM(iAdm,"ORDITEM",iSub,"FEE",Sub))
	.s AuditId=$p(DataStr,"^",5)
	.q:AuditId=""
	.s Flag=$p($g(^DHCPEPreA(AuditId)),"^",21)
	.q:Flag="NU"
	.s AuditType=$p($g(^DHCPEPreA(AuditId)),"^",1)
	.q:(AdmType'="")&&(AuditType'=AdmType)
	.s AppType=$p($g(^DHCPEPreA(AuditId)),"^",20)
	.q:(AType'="")&&(AppType'=AType)
	.s OneFact=$p(DataStr,"^",2)
	.i OneFact="" s OneFact=0
	.s FactTotal=FactTotal+OneFact
	s PIOEDR=$P($G(^DHCPEPreIADM($p(ItemID,"||",1),"ORDITEM",$p(ItemID,"||",2))),"^",2)
	If PIOEDR'="" Do
	.q:'$D(^DHCPEPreIADM(iAdm,"ORDENT",iSub,"FEE"))
	.d ##class(web.DHCPE.OrdSetsPrice).SplitOrdSetPrice(PIOEDR)
	.s FactTotal=$G(^DHCPEDataEx("DHC_PE_PreIOrdItemFee","PIOEFEE",PIOEDR,ItemID))
	q FactTotal
}

/// 功能：获取个人的项目套的金额
/// return: totalAmount
/// w ##class(web.DHCPE.HandlerPreOrds).GetAmount4POrdEnt(206)
ClassMethod GetAmount4POrdEnt(AdmId)
{
	s childId="0",oFactAmount=0,AccountAmount=0,oFactTotal=0,AccountTotal=0
	f  s childId=$o(^DHCPEPreIADM(AdmId,"ORDENT",childId)) q:childId=""  d 
	.s tempData=$g(^DHCPEPreIADM(AdmId,"ORDENT",childId))
	.///排除无效的
	.s Flag=$p(tempData,"^",9)
	.q:Flag'=1
	.s OrdId=AdmId_"||"_childId
	.s AccountAmount=$p(tempData,"^",7)
	.i AccountAmount="" s AccountAmount=0
	.s AccountTotal=AccountTotal+AccountAmount
	.s FactAmount=..GetFactAmountByOrd(OrdId,"","")
	.s oFactTotal=oFactTotal+FactAmount
	q AccountTotal_"^"_oFactTotal
}

/// Type "":所有  "I":个人  "G":团体
/// AType "":所有  "ADD":加项  "PRE":预约
/// ##class(web.DHCPE.HandlerPreOrds).GetFactAmountByOrd("","","")
ClassMethod GetFactAmountByOrd(OrdIdttt, AdmType, AType)
{
	s iAdm=$p(OrdIdttt,"||",1)
	s iSub=$p(OrdIdttt,"||",2)
	s Sub=0
	s FactTotal=0
	i $D(^DHCPEPreIADM(iAdm,"ORDENT",iSub,"FEE")){
	f  s Sub=$o(^DHCPEPreIADM(iAdm,"ORDENT",iSub,"FEE",Sub)) q:Sub=""  d
	.s DataStr=$g(^DHCPEPreIADM(iAdm,"ORDENT",iSub,"FEE",Sub))
	.s AuditId=$p(DataStr,"^",5)
	.q:AuditId=""
	.s Flag=$p($g(^DHCPEPreA(AuditId)),"^",21)
	.q:Flag="NU"
	.s AuditType=$p($g(^DHCPEPreA(AuditId)),"^",1)
	.q:(AdmType'="")&&(AuditType'=AdmType)
	.s AppType=$p($g(^DHCPEPreA(AuditId)),"^",20)
	.q:(AType'="")&&(AppType'=AType)
	.s OneFact=$p(DataStr,"^",2)
	.i OneFact="" s OneFact=0
	.s FactTotal=FactTotal+OneFact
	}else{
		f  s Sub=$O(^DHCPEPreIADM(0,"OrdEnt",OrdIdttt,iAdm,Sub)) q:Sub=""  d
		.
		.s OneFact=##class(web.DHCPE.HandlerPreOrds).GetFactAmountByItem(iAdm_"||"_Sub,AdmType,AType)
		.i OneFact="" s OneFact=0
		.s FactTotal=FactTotal+OneFact
	}
	q FactTotal
}

ClassMethod GetPaiedFlag(PreIADM)
{
	;##class(web.DHCPE.HandlerPreOrds).GetPaiedFlag()
	;0:未付费 1:部分付费 2:全部付费 3:没有项目 4:定额卡 5:挂账
	s NoPaiedFlag=0
	s GZNoPaiedFlag=1
	s PaiedFlag=0
	s DEPaiedFlag=0
	s ItemFlag=0
	
	s ItemSub=0
	f  s ItemSub=$O(^DHCPEPreIADM(PreIADM,"ORDITEM",ItemSub)) q:(ItemSub="")||(NoPaiedFlag="1"&&PaiedFlag="1")  d
	.q:$d(^DHCPEPreIADM(PreIADM,"ORDITEM",ItemSub))=10
	.s Stat=$P(^DHCPEPreIADM(PreIADM,"ORDITEM",ItemSub),"^",16)
	.q:Stat'="1"
	.q:$o(^DHCPECRMO(0,"CRMORI",PreIADM_"||"_ItemSub,0))=""
	.s ItemFlag="1"
	.s SetID=$P(^DHCPEPreIADM(PreIADM,"ORDITEM",ItemSub),"^",2)
	.//q:SetID'=""
	.s FeeSub=0
	.f  s FeeSub=$O(^DHCPEPreIADM(PreIADM,"ORDITEM",ItemSub,"FEE",FeeSub)) q:(FeeSub="")||(NoPaiedFlag="1"&&PaiedFlag="1")  d
	..s AuditID=$P(^DHCPEPreIADM(PreIADM,"ORDITEM",ItemSub,"FEE",FeeSub),"^",5)
	..q:AuditID=""
	..s UseFlag=$P($g(^DHCPEPreA(AuditID)),"^",21)
	..q:UseFlag="NU"
	..s PaiedStatus=$P($g(^DHCPEPreA(AuditID)),"^",14)
	..i PaiedStatus="UNCHARGED" d
	...s:$p(^DHCPEPreIADM(PreIADM,"ORDITEM",ItemSub),"^",9)'="Y" GZNoPaiedFlag="0"
	...s NoPaiedFlag="1"
	..i PaiedStatus="CHARGED" d
	...i $g(^DHCPEPreA("AsCharged",AuditID))'="" d
	....s DEPaiedFlag="1"  // 定额卡
	...e  d
	....s YJSFlag=##class(web.DHCPE.CashierEx).IsYJSByAuditDr(AuditID)
	....i YJSFlag=0 s PaiedFlag="1"
	....e  s NoPaiedFlag="1"
	
	q:(NoPaiedFlag="1"&&(PaiedFlag="1"||DEPaiedFlag="1")) 1
	
	s ItemSub=0
	f  s ItemSub=$O(^DHCPEPreIADM(PreIADM,"ORDENT",ItemSub)) q:(ItemSub="")||(NoPaiedFlag="1"&&PaiedFlag="1")  d
	.s Stat=$P($G(^DHCPEPreIADM(PreIADM,"ORDENT",ItemSub)),"^",9)
	.q:Stat'="1"
	.
	.s PItmsub=0,preiordid=""
	.f  s PItmsub=$o(^DHCPEPreIADM(0,"OrdEnt",PreIADM_"||"_ItemSub,PreIADM,PItmsub)) q:((PItmsub="")||(preiordid'=""))  d
	..q:$P(^DHCPEPreIADM(PreIADM,"ORDITEM",PItmsub),"^",16)'="1"
	..s preiordid=PreIADM_"||"_PItmsub
	.q:preiordid=""
	.q:$o(^DHCPECRMO(0,"CRMORI",preiordid,0))=""
	.
	.s ItemFlag="1"
	.s FeeSub=0
	.f  s FeeSub=$O(^DHCPEPreIADM(PreIADM,"ORDENT",ItemSub,"FEE",FeeSub)) q:(FeeSub="")||(NoPaiedFlag="1"&&PaiedFlag="1")  d
	..s AuditID=$P(^DHCPEPreIADM(PreIADM,"ORDENT",ItemSub,"FEE",FeeSub),"^",5)
	..q:AuditID=""
	..s UseFlag=$P($g(^DHCPEPreA(AuditID)),"^",21)
	..q:UseFlag="NU"
	..s PaiedStatus=$P($g(^DHCPEPreA(AuditID)),"^",14)
	..i PaiedStatus="UNCHARGED" d
	...s:$p(^DHCPEPreIADM(PreIADM,"ORDENT",ItemSub),"^",9)'="Y" GZNoPaiedFlag="0"
	...s NoPaiedFlag="1"
	..i PaiedStatus="CHARGED" d
	...i $g(^DHCPEPreA("AsCharged",AuditID))'="" d
	....s DEPaiedFlag="1"  // 定额卡
	...e  d
	....s YJSFlag=##class(web.DHCPE.CashierEx).IsYJSByAuditDr(AuditID)
	....i YJSFlag=0 s PaiedFlag="1"
	....e  s NoPaiedFlag="1"
	
	q:ItemFlag="0" 3
	
	q:(NoPaiedFlag="1"&&(PaiedFlag="1"||DEPaiedFlag="1")) 1
	q:PaiedFlag="1" 2
	i ((PaiedFlag="0")&&(DEPaiedFlag="0")) {
		q:GZNoPaiedFlag="0" 0
		q:GZNoPaiedFlag="1" 5
	}
	q:DEPaiedFlag="1" 4
	q 0
}

ClassMethod GetPaiedFlagDesc(PaiedFlag)
{
	q:PaiedFlag="0" "未付费"
	q:PaiedFlag="1" "部分付费"
	q:PaiedFlag="2" "全部付费"
	q:PaiedFlag="3" "没有项目(未登记)"
	q:PaiedFlag="4" "定额卡"
	q:PaiedFlag="5" "挂账"
	q ""
}

/// 提供pacs组：根据医嘱ID获取医嘱实际价格
/// 参数：医嘱ID
/// D ##class(web.DHCPE.HandlerPreOrds).GetArcimFactAmountByOEORIDR("")
ClassMethod GetArcimFactAmountByOEORIDR(OEORIDR)
{
  
    s FactAmount=0
    s CRMORowId=$o(^DHCPECRMO(0,"OEORI",OEORIDR,0))
    q:CRMORowId="" "0"
    s CRMOCRMORI=$p(^DHCPECRMO(CRMORowId),"^",2)
	q:CRMOCRMORI="" "0"
	s FactAmount=+##class(web.DHCPE.HandlerPreOrds).GetFactAmountByItem(CRMOCRMORI, "", "")
	q FactAmount
}

/// Descript:提供药房组：根据医嘱ID获取医嘱实际单价和金额
/// Input:
/// 		OEORIDR：OE_OrdItem的rowid
/// Return:Price^FactAmount
///        单价^数量
///            (scancodeFlag为0时调用计费公共函数，为1时调用互联网产品组扫码付)
/// Creater:	sunxintao
/// CreateDate:	2021-01-25
/// Debug: w ##class(web.DHCPE.HandlerPreOrds).GetArcimFactPriceAndAmountByOEORIDR("4526||4")
ClassMethod GetArcimFactPriceAndAmountByOEORIDR(OEORIDR)
{
  
    s FactAmount=0
    s CRMORowId=$o(^DHCPECRMO(0,"OEORI",OEORIDR,0))
    q:CRMORowId="" "0^0"
    s CRMOCRMORI=$p(^DHCPECRMO(CRMORowId),"^",2)
	q:CRMOCRMORI="" "0^0"
	s Qty=$g(^DHCPEDataEx("DHCPEPreIOrdItem","Qty",CRMOCRMORI))
	s:(Qty="") Qty=1
	s:(Qty=0) Qty=1
	s FactAmount=+##class(web.DHCPE.HandlerPreOrds).GetFactAmountByItem(CRMOCRMORI, "", "")
	s Price=$fn(FactAmount/Qty,"",2)
	q Price_"^"_FactAmount
}

}
