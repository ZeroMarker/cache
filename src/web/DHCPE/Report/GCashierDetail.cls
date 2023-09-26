Import SQLUser

/// 主要功能		: 输出团体收费明细
/// 主要功能		：
///            注意	：不能有换组操作
///            注意	：由于程序中加项时，如果项目类型是公费的，后删除，不会重新计算。会有金额不对的情况
Class web.DHCPE.Report.GCashierDetail Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 370;

/// 团体组项目单价
/// w ##class(web.DHCPE.Report.GCashierDetail).GetGTItemAmount("8||1")
ClassMethod GetGTItemAmount(GTDR As %Library.String = "")
{
	s TotalFactAmount=0
	s TotalAccountAmount=0
	// DHC_PE_PreGADM.{ PGADM_RowId }
	s GAdmId = $P(GTDR,"||",1)
	// DHC_PE_PreGTeam.{ PGT_ChildSub }
	s GTID = $P(GTDR,"||",2)
	
	// 已计算遗嘱套的列表
	s OrdEntDRs="^"
	// 团体分组项目表 DHC_PE_PreGTOrdItem.{ PGTOI_ChildSub }
	s PGTOIChildSub=0
	f  s PGTOIChildSub=$o(^DHCPEPreGADM(GAdmId, "Team", GTID, "ORDITEM", PGTOIChildSub))  Q:(""=PGTOIChildSub)  d
	.s CurData=$G(^DHCPEPreGADM(GAdmId, "Team", GTID, "ORDITEM", PGTOIChildSub))
	.
	.// PIOI_AddOrdItem	加项类别 
	.// 团体组项目不分预约还是公费
	.
	.// DHC_PE_PreGTOrdItem.{ PGTOI_ItemStat }
	.s PGTOIItemStat=$p(CurData,"^",13)
	.Q:(4=PGTOIItemStat) // 停止的项目不计费
	.
	.// DHC_PE_PreGTOrdItem.{ PGTOI_OrdEnt_DR }
	.s OrdEntDR=$p(CurData,"^",2)
	.Q:(""'=OrdEntDR)&(OrdEntDRs[("^"_OrdEntDR_"^"))
	.
	.i OrdEntDR'=""  d
	..// 团体分组项目套餐表 DHC_PE_PreGTOrdEnt.{ PGTOE_ChildSub }
	..s PGTOEChildSub=$p(OrdEntDR,"||",3)
	..s CurData=$g(^DHCPEPreGADM(GAdmId, "Team", GTID, "ORDENT",PGTOEChildSub))
	..// DHC_PE_PreGTOrdEnt.{ PGTOE_OrderSets_DR }
	..s OrderSetsDR=$p(CurData,"^",1)
	..// DHC_PE_PreGTOrdEnt.{ PGTOE_ItemStat }
	..s PGTOEItemStat=$p(CurData,"^",7)
	..Q:(4=PGTOEItemStat)
	..
	..s FactAmount=$p(CurData,"^",5)
	..s AccountAmount=$p(CurData,"^",6)
	..
	..s OrdEntDRs=OrdEntDRs_OrdEntDR_"^"
	.e  d
	..// DHC_PE_PreGTOrdItem.{ PGTOI_FactAmount }
	..s FactAmount=$p(CurData,"^",4)
	..
	..// DHC_PE_PreGTOrdItem.{ PGTOI_AccountAmount }
	..s AccountAmount=$p(CurData,"^",11)
	..// DHC_PE_PreGTOrdItem.{ PGTOI_ItmMast_DR }
	..s ItmMastDR=$p(CurData,"^",1)
	.
	.// 合计
	.s TotalFactAmount=TotalFactAmount+FactAmount
	.s TotalAccountAmount=TotalAccountAmount+AccountAmount
	
	Q TotalFactAmount_"^"_TotalAccountAmount
}

/// 团体费用明细
/// w ##class(web.DHCPE.Report.GCashierDetail).GCashierDetailImport("","","1")
ClassMethod GCashierDetailImport(itmjs As %Library.String = "", itmjsex As %Library.String = "", Instring As %Library.String = "") As %Status
{
	s GDR=Instring  //  DHC_PE_PreGADM.{ PGADM_RowId }
	
	s Datas=""
	k ^DHCPETMPCDI
	s GTotalAmount=0
	s GPerson=0
	// DHC_PE_PreGTeam.{ PGT_ChildSub }
	s PGTChildSub=0
	f  s PGTChildSub=$O(^DHCPEPreGADM(GDR, "Team", PGTChildSub)) q:(""=PGTChildSub)  d
	.s PGTDR=GDR_"||"_PGTChildSub
	.s PGTDesc=$P(^DHCPEPreGADM(GDR,"Team",PGTChildSub),"^",1)
	.
	.// 团体人数
	.s Person=+##Class(web.DHCPE.PreGTeam).GetTotalPersonByItem(PGTDR)
	.s GPerson=GPerson+Person
	.
	.// 单价
	.s Amount=+..GetGTItemAmount(PGTDR)
	.
	.// 金额(应收金额)
	.s TotalAmount=Person*Amount
	.s ^DHCPETMPCDI("TotalAomunt", "GTFactAmount", PGTDR)=TotalAmount
	.
	.
	.s Data=""_"^"_PGTDesc_"^"_$J(Amount, 3, 2)_"^"_Person_"^"_$J(TotalAmount,3 ,2)
	.s Datas=Datas_Data_"!"
	.i ""'=itmjs d
	..s retval=itmjs_"('"_$ZCVT(Data,"O","JS")_"');"
	..&javascript<#(retval)#>
	.
	.
	.// 以下测试用
	.s ^DHCPETMPCDI("GTeam", PGTDR)=PGTDesc
	.s ^DHCPETMPCDI("GTeam", PGTDR, "Amount")=Amount
	.s ^DHCPETMPCDI("GTeam", PGTDR, "Person")=Person
	.s ^DHCPETMPCDI("GTeam", PGTDR, "TotalAmount")=TotalAmount
	.// 以上测试用 
	.
	.// 团体组费用合计
	.s ^DHCPETMPCDI("TotalAomunt", "GFactAmount")=TotalAmount+$G(^DHCPETMPCDI("TotalAomunt", "GFactAmount"))
	.
	.// 团体人数
	.s ^DHCPETMPCDI("Person")=Person+$G(^DHCPETMPCDI("Person"))
	.
	.// 团体组人员列表
	.// DHC_PE_PreIADM.{ PIADM_RowId }
	.s PIADMRowId=0
	.f  s PIADMRowId=$O(^DHCPEPreIADM(0,"PGTeam", PGTDR, PIADMRowId)) Q:(""=PIADMRowId)  d
	..// DHC_PE_PreIADM.{ PIADM_PIBI_DR }
	..s PIBIDR=$P($G(^DHCPEPreIADM(PIADMRowId)), "^", 1)
	..// DHC_PE_PreIBaseInfo.{ PIBI_Name }
	..s PIBIName=$P($G(^DHCPEPreIBI(PIBIDR)), "^", 2)
	..s ^DHCPETMPCDI("PreIADM",PIADMRowId) = PIBIName
	..
	.
	// 团体组合计
	s Data="合计:"_"^"_ ""_"^"_""_"^"_$G(^DHCPETMPCDI("Person"))_"^"_$J($G(^DHCPETMPCDI("TotalAomunt", "GFactAmount")), 3, 2)
	//s Datas=Datas_Data_"!"
	i ""'=itmjs d
	.s retval=itmjs_"('"_$ZCVT(Data,"O","JS")_"');"
	.&javascript<#(retval)#>	
	////////////////////////////////////////////////////////////////////////////////////////////
	////////////////////////////////////////////////////////////////////////////////////////////
	////////////////////////////////////////////////////////////////////////////////////////////
	
	
	// 团体人员费用统计
	s PIADMRowId=0
	f  s PIADMRowId=$O(^DHCPETMPCDI("PreIADM", PIADMRowId)) Q:(""=PIADMRowId)  d
	.//Q:'((146=PIADMRowId)||(147=PIADMRowId)||(148=PIADMRowId)||(151=PIADMRowId))
	.//Q:(26'=PIADMRowId)
	.s Name=^DHCPETMPCDI("PreIADM",PIADMRowId)
	.
	.s ^DHCPETMPCDI("PreIADM",PIADMRowId, "Price")=0
	.s OrderSetsList="^" //套餐列表
	.
	.// DHC_PE_PreIOrdItem.{ PIOI_ChildSub }
	.s PIOIChildSub=0
	.f  s PIOIChildSub=$O(^DHCPEPreIADM(PIADMRowId, "ORDITEM", PIOIChildSub)) Q:(""=PIOIChildSub)  d
	..s PIOIDR=PIADMRowId_"||"_PIOIChildSub
	..//w !,"PIOIDR:"_PIOIDR
	..s CurData=$G(^DHCPEPreIADM(PIADMRowId, "ORDITEM", PIOIChildSub))
	..
	..// DHC_PE_PreIOrdItem.{ PIOI_OrdEnt_DR } 
	..s PIOIOrdEntDR=$P(CurData,"^",2)
	..//w !,"PIOIDR:"_PIOIDR_"  PIOIOrdEntDR:"_PIOIOrdEntDR
	../////////////////////////////////////////////////////////////////////////////////////
	../////////////////////////////////////////////////////////////////////////////////////
	../////////////////////////////////////////////////////////////////////////////////////
	..Q:(""'=PIOIOrdEntDR)&(OrderSetsList[("^"_PIOIOrdEntDR_"^"))
	..s:(""'=PIOIOrdEntDR) OrderSetsList=OrderSetsList_"^"_PIOIOrdEntDR_"^"
	..
	..
	..// 套餐项目
	..i (""'=PIOIOrdEntDR) d
	...// DHC_PE_PreIOrdEnt.{ PIOE_ChildSub }
	...s PIOEChildSub=$P(PIOIOrdEntDR, "||", 2)
	...s CurData=$G(^DHCPEPreIADM(PIADMRowId,"ORDENT",PIOEChildSub))
	...
	...// DHC_PE_PreIOrdEnt.{ PIOE_OrderSets_DR } = ARC_OrdSets
	...s OrderSetsDR=$P(CurData, "^", 1)
	...i 0=$D(^DHCPETMPCDI("OrderSets", OrderSetsDR)) d
	....s OrderSetsDRDesc=$p(^ARCOS(OrderSetsDR),"^",2) // ARCOS_Desc
	....s ^DHCPETMPCDI("OrderSets", OrderSetsDR)=OrderSetsDRDesc
	...s OrderSetsDRDesc=^DHCPETMPCDI("OrderSets", OrderSetsDR)
	...s ^DHCPETMPCDI("PreIADM", PIADMRowId, "OrderSets", PIOIOrdEntDR)=OrderSetsDRDesc
	...
	...// 优惠金额
	...s FactAmount=+##class(web.DHCPE.HandlerPreOrds).GetFactAmountByOrd(PIOIOrdEntDR,"","")
	...s ^DHCPETMPCDI("PreIADM", PIADMRowId, "OrderSets", PIOIOrdEntDR)=^DHCPETMPCDI("PreIADM",PIADMRowId, "OrderSets", PIOIOrdEntDR)_" 金额"_FactAmount
	...//w !,"OrdEntDR:"_PIOIOrdEntDR_" Desc:"_OrderSetsDRDesc_" FactAmount:"_FactAmount
	.../////////////////////////////////////////////////////////////////////////////////////
	.../////////////////////////////////////////////////////////////////////////////////////
	.../////////////////////////////////////////////////////////////////////////////////////
	...
	...// 减项
	...// 停止团体组项目计算其金额,如果加项后删除不计算
	...// 团体分组项目 DHC_PE_PreIOrdEnt.{ PIOE_GTOE_DR }  不为空,说明为团体组项目
	...s PIOEGTOEDR=$P(CurData,"^", 2)
	...
	...// DHC_PE_PreIOrdEnt.{ PIOE_ItemStat } 1-核实 4-停止
	...s PIOEItemStat=$P(CurData,"^", 9)
	...s:(4=PIOEItemStat) ^DHCPETMPCDI("PreIADM",PIADMRowId, "OrderSets", PIOIOrdEntDR)=^DHCPETMPCDI("PreIADM",PIADMRowId, "OrderSets", PIOIOrdEntDR)_"  停止"
	...s:(1=PIOEItemStat) ^DHCPETMPCDI("PreIADM",PIADMRowId, "OrderSets", PIOIOrdEntDR)=^DHCPETMPCDI("PreIADM",PIADMRowId, "OrderSets", PIOIOrdEntDR)_"  预约"
	...
	...//w "    Stat:"_PIOIItemStat_"   OIDR:"_PIOIGTOIDR
	...i (""'=PIOEGTOEDR)&(4=PIOEItemStat) d
	....//w "   DEL  "
	....// 单价为FactAmount的ItmMastDR项目的金额
	....s ^DHCPETMPCDI("OrderSets", OrderSetsDR, "DEL", FactAmount, "FactAmount")=FactAmount
	....s ^DHCPETMPCDI("OrderSets", OrderSetsDR, "DEL", FactAmount, "TotalAmount")=FactAmount+$G(^DHCPETMPCDI("OrderSets", OrderSetsDR, "DEL", FactAmount, "TotalAmount"))
	....s ^DHCPETMPCDI("OrderSets", OrderSetsDR, "DEL", FactAmount, "Count")=1+$G(^DHCPETMPCDI("OrderSets", OrderSetsDR, "DEL", FactAmount, "Count"))
	....s ^DHCPETMPCDI("OrderSets", OrderSetsDR, "DEL", FactAmount, "IADMs")=Name_","_$G(^DHCPETMPCDI("OrderSets", OrderSetsDR, "DEL", FactAmount, "IADMs"))
	....
	...s:(""'=PIOEGTOEDR)&(4=PIOEItemStat) ^DHCPETMPCDI("减项预约", OrderSetsDRDesc, Name)=FactAmount
	...s:(""=PIOEGTOEDR)&(4=PIOEItemStat) ^DHCPETMPCDI("减项加项", OrderSetsDRDesc, Name)=FactAmount
	...//w !,"    Stat:"_PIOIItemStat_"   OIDR:"_PIOIGTOIDR
	...Q:(""'=PIOEGTOEDR)&(4=PIOEItemStat) // 过滤掉删除的是团体组加的项目
	...Q:(""=PIOEGTOEDR)&(4=PIOEItemStat) // 过滤掉删除的是个人额外加的项目
	...s:(""'=PIOEGTOEDR) ^DHCPETMPCDI("PreIADM",PIADMRowId, "Price")=FactAmount+^DHCPETMPCDI("PreIADM",PIADMRowId, "Price")
	...////////////////////////////////////////////////////////////////////////////////////
	...////////////////////////////////////////////////////////////////////////////////////
	...////////////////////////////////////////////////////////////////////////////////////
	...
	...
	...
	...// DHC_PE_PreIOrdEnt.{ PIOE_Type } PRE-PreReg 预约 ADD-AddOrder加项
	...s PIOEType=$P(CurData,"^", 8)
	...s:(""=PIOEGTOEDR)&(PIOEType="PRE") ^DHCPETMPCDI("PreIADM",PIADMRowId, "OrderSets", PIOIOrdEntDR)=^DHCPETMPCDI("PreIADM",PIADMRowId, "OrderSets", PIOIOrdEntDR)_"  预约加项"
	...s:(""=PIOEGTOEDR)&(PIOEType="ADD") ^DHCPETMPCDI("PreIADM",PIADMRowId, "OrderSets", PIOIOrdEntDR)=^DHCPETMPCDI("PreIADM",PIADMRowId, "OrderSets", PIOIOrdEntDR)_"  额外加项"
	...
	...
	...
	...// 预约加项
	...i (""=PIOEGTOEDR)&(PIOEType="PRE") d
	....//b //预约加项
	....//w !,"DR:"_PIOIDR_"  ItmMastDR:"_ItmMastDR_"  FactAmount:"_FactAmount
	....s ^DHCPETMPCDI("OrderSets", OrderSetsDR, "ADD", "P", FactAmount, "FactAmount")=FactAmount
	....s ^DHCPETMPCDI("OrderSets", OrderSetsDR, "ADD", "P", FactAmount, "Count")=1+$G(^DHCPETMPCDI("OrderSets", OrderSetsDR, "ADD", "P", FactAmount, "Count"))
	....s ^DHCPETMPCDI("OrderSets", OrderSetsDR, "ADD", "P", FactAmount, "TotalAmount")=FactAmount+$G(^DHCPETMPCDI("OrderSets", OrderSetsDR, "ADD", "P", FactAmount, "TotalAmount"))
	....s ^DHCPETMPCDI("OrderSets", OrderSetsDR, "ADD", "P", FactAmount, "IADMs")=Name_","_$G(^DHCPETMPCDI("OrderSets", OrderSetsDR, "ADD", "P", FactAmount, "IADMs"))
	....
	....s ^DHCPETMPCDI("PreIADM",PIADMRowId, "OrderSets", PIOIOrdEntDR)=^DHCPETMPCDI("PreIADM",PIADMRowId, "OrderSets", PIOIOrdEntDR)_"  公费:"_FactAmount
	....s ^DHCPETMPCDI("PreIADM",PIADMRowId, "Price")=^DHCPETMPCDI("PreIADM",PIADMRowId, "Price")+FactAmount
	....s ^DHCPETMPCDI("预约加项", OrderSetsDRDesc, Name)=FactAmount
	...// 过滤非加项(预约项目)
	...Q:(PIOEType'="ADD")
	...////////////////////////////////////////////////////////////////////////////////////
	...////////////////////////////////////////////////////////////////////////////////////
	...////////////////////////////////////////////////////////////////////////////////////
	...
	...
	...
	...
	...
	...
	...// 额外加项
	...s AdmTypes="^" //费用列表
	...s GFactAmount=0
	...s IFactAmount=0
	...// DHC_PE_PreIOrdEntFee.{ PIOEF_ChildSub }
	...s PIOEFChildSub=0
	...f  s PIOEFChildSub=$o(^DHCPEPreIADM(PIADMRowId,"ORDENT",PIOEChildSub,"FEE",PIOEFChildSub)) Q:(""=PIOEFChildSub)  d
	....s CurData=$g(^DHCPEPreIADM(PIADMRowId,"ORDENT",PIOEChildSub,"FEE",PIOEFChildSub))
	....
	....// DHC_PE_PreIOrdEntFee.{ PIOEF_PAudit_DR } = DHC_PE_PreAudit
	....s AuditId=$p(CurData, "^", 5)
	....// 团体和个人ADM审核表 DHC_PE_PreAudit.{ PA_Status }
	....s PAStatus=$p($g(^DHCPEPreA(AuditId)),"^",21)
	....Q:("NU"=PAStatus) // U-Use有效 NU-NoUse无效
	....// DHC_PE_PreAudit.{ PA_ADMType } G-团体费用 I-个人费用
	....s ADMType=$p($g(^DHCPEPreA(AuditId)),"^",1)
	....s AdmTypes=AdmTypes_ADMType_"^" 
	....// DHC_PE_PreIOrdEntFee.{ PIOEF_FactAmount }
	....s FactAmount=$p(CurData,"^", 2)
	....s:("G"=ADMType) GFactAmount=GFactAmount+FactAmount
	....s:("I"=ADMType) IFactAmount=IFactAmount+FactAmount
	....// w "  GFactAmount:"_GFactAmount_"   IFactAmount:"_IFactAmount
	...
	...
	...// 公费加项
	...i (AdmTypes["^G^")&(AdmTypes'["^I^") d
	....s ^DHCPETMPCDI("OrderSets", OrderSetsDR, "ADD", "G", GFactAmount, "FactAmount")=GFactAmount
	....s ^DHCPETMPCDI("OrderSets", OrderSetsDR, "ADD", "G", GFactAmount, "Count")=1+$G(^DHCPETMPCDI("OrderSets", OrderSetsDR, "ADD", "G", GFactAmount, "Count"))
	....s ^DHCPETMPCDI("OrderSets", OrderSetsDR, "ADD", "G", GFactAmount, "TotalAmount")=GFactAmount+$G(^DHCPETMPCDI("OrderSets", OrderSetsDR, "ADD", "G", GFactAmount, "TotalAmount"))
	....s ^DHCPETMPCDI("OrderSets", OrderSetsDR, "ADD", "G", GFactAmount, "IADMs")=Name_","_$G(^DHCPETMPCDI("OrderSets", OrderSetsDR, "ADD", "G", GFactAmount, "IADMs"))
	....
	....s ^DHCPETMPCDI("PreIADM",PIADMRowId, "OrderSets", PIOIOrdEntDR)=^DHCPETMPCDI("PreIADM",PIADMRowId, "OrderSets", PIOIOrdEntDR)_"  公费:"_GFactAmount
	....s ^DHCPETMPCDI("PreIADM",PIADMRowId, "Price")=^DHCPETMPCDI("PreIADM",PIADMRowId, "Price")+GFactAmount
	....s ^DHCPETMPCDI("公费加项", OrderSetsDRDesc, Name)=GFactAmount
	...
	...// 自费加项(不计入团体费用)
	...i (AdmTypes'["^G^")&(AdmTypes["^I^") d
	....s ^DHCPETMPCDI("OrderSets", OrderSetsDR, "ADD", "I", IFactAmount, "FactAmount")=IFactAmount
	....s ^DHCPETMPCDI("OrderSets", OrderSetsDR, "ADD", "I", IFactAmount, "Count")=1+$G(^DHCPETMPCDI("OrderSets", OrderSetsDR, "ADD", "I", IFactAmount, "Count"))
	....s ^DHCPETMPCDI("OrderSets", OrderSetsDR, "ADD", "I", IFactAmount, "TotalAmount")=IFactAmount+$G(^DHCPETMPCDI("OrderSets", OrderSetsDR, "ADD", "I", IFactAmount, "TotalAmount"))
	....s ^DHCPETMPCDI("OrderSets", OrderSetsDR, "ADD", "I", IFactAmount, "IADMs")=Name_","_$G(^DHCPETMPCDI("OrderSets", OrderSetsDR, "ADD", "I", IFactAmount, "IADMs"))
	....
	....s ^DHCPETMPCDI("PreIADM",PIADMRowId, "OrderSets", PIOIOrdEntDR)=^DHCPETMPCDI("PreIADM",PIADMRowId, "OrderSets", PIOIOrdEntDR)_"  自费:"_IFactAmount
	....s ^DHCPETMPCDI("自费加项", OrderSetsDRDesc, Name)=FactAmount
	....//s ^DHCPETMPCDI("PreIADM",PIADMRowId, "Price")=^DHCPETMPCDI("PreIADM",PIADMRowId, "Price")+IFactAmount
	...
	...// 公+自(自己支付的费用不计入团体费用)
	...i (AdmTypes["^G^")&(AdmTypes["^I^") d
	....s ^DHCPETMPCDI("OrderSets", OrderSetsDR, "ADD", "A", GFactAmount, IFactAmount, "FactAmount")=GFactAmount
	....s ^DHCPETMPCDI("OrderSets", OrderSetsDR, "ADD", "A", GFactAmount, IFactAmount, "Count")=1+$G(^DHCPETMPCDI("OrderSets", OrderSetsDR, "ADD", "A", GFactAmount, IFactAmount, "Count"))
	....s ^DHCPETMPCDI("OrderSets", OrderSetsDR, "ADD", "A", GFactAmount, IFactAmount, "TotalAmount")=GFactAmount+$G(^DHCPETMPCDI("OrderSets", OrderSetsDR, "ADD", "A", GFactAmount, IFactAmount, "TotalAmount"))
	....s ^DHCPETMPCDI("OrderSets", OrderSetsDR, "ADD", "A", GFactAmount, IFactAmount, "IADMs")=Name_", "_$G(^DHCPETMPCDI("OrderSets", OrderSetsDR, "ADD", "A", GFactAmount, IFactAmount, "IADMs"))
	....
	....s ^DHCPETMPCDI("PreIADM",PIADMRowId, "OrderSets", PIOIOrdEntDR)=^DHCPETMPCDI("PreIADM",PIADMRowId, "OrderSets", PIOIOrdEntDR)_"  公费:"_GFactAmount_"  自费:"_IFactAmount
	....s ^DHCPETMPCDI("PreIADM",PIADMRowId, "Price")=^DHCPETMPCDI("PreIADM",PIADMRowId, "Price")+GFactAmount
	....s ^DHCPETMPCDI("公自加项", OrderSetsDRDesc, Name)=GFactAmount
	../////////////////////////////////////////////////////////////////////////////////////
	../////////////////////////////////////////////////////////////////////////////////////
	../////////////////////////////////////////////////////////////////////////////////////
	..
	..
	..
	..
	..// 非套餐项目
	..i ""=PIOIOrdEntDR d
	...// DHC_PE_PreIOrdItem.{ PIOI_ItmMast_DR }
	...s ItmMastDR=$P(CurData,"^",1)
	...i 0=$D(^DHCPETMPCDI("ItmMast", ItmMastDR)) d
	....s ItmMastDesc=$p(^ARCIM($p(ItmMastDR,"||",1),$p(ItmMastDR,"||",2),1),"^",2)
	....s ^DHCPETMPCDI("ItmMast", ItmMastDR)=ItmMastDesc
	...s ItmMastDesc=^DHCPETMPCDI("ItmMast", ItmMastDR)
	...s ^DHCPETMPCDI("PreIADM",PIADMRowId, "ItmMast", PIOIDR)=ItmMastDesc
	...
	...// 应收金额
	...// DHC_PE_PreIOrdItem.{ PIOI_AccountAmount }
	...s AccountAmount=$P(CurData,"^",14)
	...
	...// 优惠金额
	...s FactAmount=+##class(web.DHCPE.HandlerPreOrds).GetFactAmountByItem(PIOIDR,"","")
	...s ^DHCPETMPCDI("PreIADM",PIADMRowId, "ItmMast", PIOIDR)=^DHCPETMPCDI("PreIADM",PIADMRowId, "ItmMast", PIOIDR)_" 金额"_FactAmount
	...//w !,"DR:"_PIOIDR_"  Desc:"_ItmMastDesc
	.../////////////////////////////////////////////////////////////////////////////////////
	.../////////////////////////////////////////////////////////////////////////////////////
	.../////////////////////////////////////////////////////////////////////////////////////
	...
	...
	...
	...
	...// 减项
	...// 停止团体组项目计算其金额,如果加项后删除不计算
	...// 团体分组项目 DHC_PE_PreIOrdItem.{ PIOI_GTOI_DR }  不为空,说明为团体组项目
	...s PIOIGTOIDR=$P(CurData,"^", 4)
	...
	...// DHC_PE_PreIOrdItem.{ PIOI_ItemStat } 1-核实 4-停止
	...s PIOIItemStat=$P(CurData,"^",16)
	...s:(4=PIOIItemStat) ^DHCPETMPCDI("PreIADM",PIADMRowId, "ItmMast", PIOIDR)=^DHCPETMPCDI("PreIADM",PIADMRowId, "ItmMast", PIOIDR)_"  停止"
	...s:(1=PIOIItemStat) ^DHCPETMPCDI("PreIADM",PIADMRowId, "ItmMast", PIOIDR)=^DHCPETMPCDI("PreIADM",PIADMRowId, "ItmMast", PIOIDR)_"  预约"
	...
	...//w "  PIOIGTOIDR:"_PIOIGTOIDR_"   Stat:"_PIOIItemStat
	...i (""'=PIOIGTOIDR)&(4=PIOIItemStat) d
	....//w "   DEL  "
	....// 单价为FactAmount的ItmMastDR项目的金额
	....s ^DHCPETMPCDI("ItmMast", ItmMastDR, "DEL", FactAmount, "FactAmount")=FactAmount
	....s ^DHCPETMPCDI("ItmMast", ItmMastDR, "DEL", FactAmount, "TotalAmount")=FactAmount+$G(^DHCPETMPCDI("ItmMast", ItmMastDR, "DEL", FactAmount, "TotalAmount"))
	....s ^DHCPETMPCDI("ItmMast", ItmMastDR, "DEL", FactAmount, "Count")=1+$G(^DHCPETMPCDI("ItmMast", ItmMastDR, "DEL", FactAmount, "Count"))
	....s ^DHCPETMPCDI("ItmMast", ItmMastDR, "DEL", FactAmount, "IADMs")=Name_","_$G(^DHCPETMPCDI("ItmMast", ItmMastDR, "DEL", FactAmount, "IADMs"))
	....
	...s:(""'=PIOIGTOIDR)&(4=PIOIItemStat) ^DHCPETMPCDI("减项预约", ItmMastDesc, Name)=FactAmount
	...s:(""=PIOIGTOIDR)&(4=PIOIItemStat) ^DHCPETMPCDI("减项加项", ItmMastDesc, Name)=FactAmount
	...//w !,"    Stat:"_PIOIItemStat_"   OIDR:"_PIOIGTOIDR
	...Q:(""'=PIOIGTOIDR)&(4=PIOIItemStat) // 过滤掉删除的是团体组加的项目
	...Q:(""=PIOIGTOIDR)&(4=PIOIItemStat) // 过滤掉删除的是个人额外加的项目
	...s:(""'=PIOIGTOIDR) ^DHCPETMPCDI("PreIADM",PIADMRowId, "Price")=FactAmount+^DHCPETMPCDI("PreIADM",PIADMRowId, "Price")
	...////////////////////////////////////////////////////////////////////////////////////
	...////////////////////////////////////////////////////////////////////////////////////
	...////////////////////////////////////////////////////////////////////////////////////
	...
	...
	...
	...
	...// PIOI_Type PRE-PreReg预约 ADD-AddOrder加项
	...s PIOIType=$P(CurData,"^",15)
	...s:(""=PIOIGTOIDR)&(PIOIType="PRE") ^DHCPETMPCDI("PreIADM",PIADMRowId, "ItmMast", PIOIDR)=^DHCPETMPCDI("PreIADM",PIADMRowId, "ItmMast", PIOIDR)_"  预约加项"
	...s:(""=PIOIGTOIDR)&(PIOIType="ADD") ^DHCPETMPCDI("PreIADM",PIADMRowId, "ItmMast", PIOIDR)=^DHCPETMPCDI("PreIADM",PIADMRowId, "ItmMast", PIOIDR)_"  额外加项"
	...//w "    Stat:"_PIOIType
	...
	...
	...// 预约加项
	...i (""=PIOIGTOIDR)&(PIOIType="PRE") d
	....//w "  预约加项"
	....//w !,"DR:"_PIOIDR_"  ItmMastDR:"_ItmMastDR_"  FactAmount:"_FactAmount
	....s ^DHCPETMPCDI("ItmMast", ItmMastDR, "ADD", "P", FactAmount, "FactAmount")=FactAmount
	....s ^DHCPETMPCDI("ItmMast", ItmMastDR, "ADD", "P", FactAmount, "Count")=1+$G(^DHCPETMPCDI("ItmMast", ItmMastDR, "ADD", "P", FactAmount, "Count"))
	....s ^DHCPETMPCDI("ItmMast", ItmMastDR, "ADD", "P", FactAmount, "TotalAmount")=FactAmount+$G(^DHCPETMPCDI("ItmMast", ItmMastDR, "ADD", "P", FactAmount, "TotalAmount"))
	....s ^DHCPETMPCDI("ItmMast", ItmMastDR, "ADD", "P", FactAmount, "IADMs")=Name_","_$G(^DHCPETMPCDI("ItmMast", ItmMastDR, "ADD", "P", FactAmount, "IADMs"))
	....
	....s ^DHCPETMPCDI("PreIADM",PIADMRowId, "ItmMast", PIOIDR)=^DHCPETMPCDI("PreIADM",PIADMRowId, "ItmMast", PIOIDR)_"  公费:"_FactAmount
	....s ^DHCPETMPCDI("PreIADM",PIADMRowId, "Price")=^DHCPETMPCDI("PreIADM",PIADMRowId, "Price")+FactAmount
	....s ^DHCPETMPCDI("预约加项", ItmMastDesc, Name)=FactAmount
	...// 过滤非加项(预约项目)
	...Q:(PIOIType'="ADD")
	...////////////////////////////////////////////////////////////////////////////////////
	...////////////////////////////////////////////////////////////////////////////////////
	...////////////////////////////////////////////////////////////////////////////////////
	...
	...
	...
	...
	...
	...// 额外加项
	...s AdmTypes="^" //费用列表
	...s GFactAmount=0
	...s IFactAmount=0
	...// DHC_PE_PreIOrdItemFee.{ PIOIF_ChildSub }
	...s PIOIFChildSub=0
	...f  s PIOIFChildSub=$o(^DHCPEPreIADM(PIADMRowId,"ORDITEM",PIOIChildSub,"FEE",PIOIFChildSub)) Q:(""=PIOIFChildSub)  d
	....s CurData=$g(^DHCPEPreIADM(PIADMRowId,"ORDITEM",PIOIChildSub,"FEE",PIOIFChildSub))
	....
	....// DHC_PE_PreIOrdItemFee.{ PIOIF_PAudit_DR } = DHC_PE_PreAudit
	....s AuditId=$p(CurData, "^", 5)
	....// 团体和个人ADM审核表 DHC_PE_PreAudit.{ PA_Status }
	....s PAStatus=$p($g(^DHCPEPreA(AuditId)),"^",21)
	....Q:("NU"=PAStatus) // U-Use有效 NU-NoUse无效
	....// DHC_PE_PreAudit.{ PA_ADMType } G-团体费用 I-个人费用
	....s ADMType=$p($g(^DHCPEPreA(AuditId)),"^",1)
	....s AdmTypes=AdmTypes_ADMType_"^" 
	....// DHC_PE_PreIOrdItemFee.{ PIOIF_FactAmount }
	....s FactAmount=$p(CurData,"^", 2)
	....s:("G"=ADMType) GFactAmount=GFactAmount+FactAmount
	....s:("I"=ADMType) IFactAmount=IFactAmount+FactAmount
	....// w "  GFactAmount:"_GFactAmount_"   IFactAmount:"_IFactAmount
	...
	...
	...// 公费加项
	...i (AdmTypes["^G^")&(AdmTypes'["^I^") d
	....//w "  公费加项  "_GFactAmount
	....s ^DHCPETMPCDI("ItmMast", ItmMastDR, "ADD", "G", GFactAmount, "FactAmount")=GFactAmount
	....s ^DHCPETMPCDI("ItmMast", ItmMastDR, "ADD", "G", GFactAmount, "Count")=1+$G(^DHCPETMPCDI("ItmMast", ItmMastDR, "ADD", "G", GFactAmount, "Count"))
	....s ^DHCPETMPCDI("ItmMast", ItmMastDR, "ADD", "G", GFactAmount, "TotalAmount")=GFactAmount+$G(^DHCPETMPCDI("ItmMast", ItmMastDR, "ADD", "G", GFactAmount, "TotalAmount"))
	....s ^DHCPETMPCDI("ItmMast", ItmMastDR, "ADD", "G", GFactAmount, "IADMs")=Name_","_$G(^DHCPETMPCDI("ItmMast", ItmMastDR, "ADD", "G", GFactAmount, "IADMs"))
	....s ^DHCPETMPCDI("PreIADM",PIADMRowId, "ItmMast", PIOIDR)=^DHCPETMPCDI("PreIADM",PIADMRowId, "ItmMast", PIOIDR)_"  公费:"_GFactAmount
	....s ^DHCPETMPCDI("PreIADM",PIADMRowId, "Price")=^DHCPETMPCDI("PreIADM",PIADMRowId, "Price")+GFactAmount
	....s ^DHCPETMPCDI("公费加项", ItmMastDesc, Name)=GFactAmount
	...
	...// 自费加项
	...i (AdmTypes'["^G^")&(AdmTypes["^I^") d
	....//w "  自费加项  "_IFactAmount
	....s ^DHCPETMPCDI("ItmMast", ItmMastDR, "ADD", "I", IFactAmount, "FactAmount")=IFactAmount
	....s ^DHCPETMPCDI("ItmMast", ItmMastDR, "ADD", "I", IFactAmount, "Count")=1+$G(^DHCPETMPCDI("ItmMast", ItmMastDR, "ADD", "I", IFactAmount, "Count"))
	....s ^DHCPETMPCDI("ItmMast", ItmMastDR, "ADD", "I", IFactAmount, "TotalAmount")=IFactAmount+$G(^DHCPETMPCDI("ItmMast", ItmMastDR, "ADD", "I", IFactAmount, "TotalAmount"))
	....s ^DHCPETMPCDI("ItmMast", ItmMastDR, "ADD", "I", IFactAmount, "IADMs")=Name_","_$G(^DHCPETMPCDI("ItmMast", ItmMastDR, "ADD", "I", IFactAmount, "IADMs"))
	....s ^DHCPETMPCDI("PreIADM",PIADMRowId, "ItmMast", PIOIDR)=^DHCPETMPCDI("PreIADM",PIADMRowId, "ItmMast", PIOIDR)_"  自费:"_IFactAmount
	....s ^DHCPETMPCDI("自费加项", ItmMastDesc, Name)=FactAmount
	....//s ^DHCPETMPCDI("PreIADM",PIADMRowId, "Price")=^DHCPETMPCDI("PreIADM",PIADMRowId, "Price")+IFactAmount
	...
	...// 公+自
	...i (AdmTypes["^G^")&(AdmTypes["^I^") d
	....//w "  自费加项   "_GFactAmount
	....s ^DHCPETMPCDI("ItmMast", ItmMastDR, "ADD", "A", GFactAmount, IFactAmount, "FactAmount")=GFactAmount
	....s ^DHCPETMPCDI("ItmMast", ItmMastDR, "ADD", "A", GFactAmount, IFactAmount, "Count")=1+$G(^DHCPETMPCDI("ItmMast", ItmMastDR, "ADD", "A", GFactAmount, IFactAmount, "Count"))
	....s ^DHCPETMPCDI("ItmMast", ItmMastDR, "ADD", "A", GFactAmount, IFactAmount, "TotalAmount")=GFactAmount+$G(^DHCPETMPCDI("ItmMast", ItmMastDR, "ADD", "A", GFactAmount, IFactAmount, "TotalAmount"))
	....s ^DHCPETMPCDI("ItmMast", ItmMastDR, "ADD", "A", GFactAmount, IFactAmount, "IADMs")=Name_", "_$G(^DHCPETMPCDI("ItmMast", ItmMastDR, "ADD", "A", GFactAmount, IFactAmount, "IADMs"))
	....s ^DHCPETMPCDI("PreIADM",PIADMRowId, "ItmMast", PIOIDR)=^DHCPETMPCDI("PreIADM",PIADMRowId, "ItmMast", PIOIDR)_"  公费:"_GFactAmount_"  自费:"_IFactAmount
	....s ^DHCPETMPCDI("PreIADM",PIADMRowId, "Price")=^DHCPETMPCDI("PreIADM",PIADMRowId, "Price")+GFactAmount
	....s ^DHCPETMPCDI("公自加项", ItmMastDesc, Name)=GFactAmount
	/*
	s ItmMastDR=0
	f  s ItmMastDR=$O(^DHCPETMPCDI("ItmMast",ItmMastDR)) Q:(""=ItmMastDR)  d
	.s ItmMastDesc=$p(^ARCIM($p(ItmMastDR,"||",1),$p(ItmMastDR,"||",2),1),"^",2)
	.s ^DHCPETMPCDI("ItmMast", ItmMastDR)=ItmMastDesc
	*/
	////////////////////////////////////////////////////////////////////////////////////////////
	////////////////////////////////////////////////////////////////////////////////////////////
	////////////////////////////////////////////////////////////////////////////////////////////
	
	s Title="加项"
	s ItmMastDR=0
	f  s ItmMastDR=$O(^DHCPETMPCDI("ItmMast", ItmMastDR)) Q:(""=ItmMastDR)  d
	.
	.s ItmMastDesc=^DHCPETMPCDI("ItmMast", ItmMastDR)
	.s FactAmount="" //不能从0开始 ,有可能是负值
	.f  s FactAmount=$O(^DHCPETMPCDI("ItmMast", ItmMastDR, "ADD", "P", FactAmount)) Q:(""=FactAmount)  d
	..s Amount=^DHCPETMPCDI("ItmMast", ItmMastDR, "ADD", "P", FactAmount, "FactAmount")
	..s Count=^DHCPETMPCDI("ItmMast", ItmMastDR, "ADD", "P", FactAmount, "Count")
	..s TotalAmount=^DHCPETMPCDI("ItmMast", ItmMastDR, "ADD", "P", FactAmount, "TotalAmount")
	..s Person=^DHCPETMPCDI("ItmMast", ItmMastDR, "ADD", "P", FactAmount, "IADMs")
	..s Data=Title_"^"_ItmMastDesc_"("_$P(Person,",",1,$L(Person,",")-1)_")"_"^"_$J(Amount, 3, 2)_"^"_Count_"^"_$J(TotalAmount,3 ,2)
	..s Datas=Datas_Data_"!"
	..i ""'=itmjs d
	...s retval=itmjs_"('"_$ZCVT(Data,"O","JS")_"');"
	...&javascript<#(retval)#>
	..s Title=""
	..
	..s ^DHCPETMPCDI("TotalAomunt", "ADD", "P")=TotalAmount+$G(^DHCPETMPCDI("TotalAomunt", "ADD", "P"))
	/////////////////////////////////////////////////////////////////////////////////////////
	s OrderSetsDR=0
	f  s OrderSetsDR=$O(^DHCPETMPCDI("OrderSets", OrderSetsDR)) Q:(""=OrderSetsDR)  d
	.s Desc=^DHCPETMPCDI("OrderSets", OrderSetsDR)
	.s FactAmount="" //不能从0开始 ,有可能是负值
	.f  s FactAmount=$O(^DHCPETMPCDI("OrderSets", OrderSetsDR, "ADD", "P", FactAmount)) Q:(""=FactAmount)  d
	..
	..s Amount=^DHCPETMPCDI("OrderSets", OrderSetsDR, "ADD", "P", FactAmount, "FactAmount")
	..s Count=^DHCPETMPCDI("OrderSets", OrderSetsDR, "ADD", "P", FactAmount, "Count")
	..s TotalAmount=^DHCPETMPCDI("OrderSets", OrderSetsDR, "ADD", "P", FactAmount, "TotalAmount")
	..s Person=^DHCPETMPCDI("OrderSets", OrderSetsDR, "ADD", "P", FactAmount, "IADMs")
	..s Data=Title_"^"_Desc_"("_$P(Person,",",1,$L(Person,",")-1)_")"_"^"_$J(Amount, 3, 2)_"^"_Count_"^"_$J(TotalAmount,3 ,2)
	..
	..s Datas=Datas_Data_"!"
	..i ""'=itmjs d
	...s retval=itmjs_"('"_$ZCVT(Data,"O","JS")_"');"
	...&javascript<#(retval)#>
	..s Title=""
	..s ^DHCPETMPCDI("TotalAomunt", "ADD", "P")=TotalAmount+$G(^DHCPETMPCDI("TotalAomunt", "ADD", "P"))
	// 加项合计
	s Data="加项合计:"_"^"_ ""_"^"_""_"^"_""_"^"_$J($G(^DHCPETMPCDI("TotalAomunt", "ADD", "P")), 3, 2)
	i ""'=itmjs d
	.s retval=itmjs_"('"_$ZCVT(Data,"O","JS")_"');"
	.&javascript<#(retval)#>
	////////////////////////////////////////////////////////////////////////////////////////////
	////////////////////////////////////////////////////////////////////////////////////////////
	////////////////////////////////////////////////////////////////////////////////////////////
	



	// 
	s Title="公费加项"
	s ItmMastDR=0
	f  s ItmMastDR=$O(^DHCPETMPCDI("ItmMast", ItmMastDR)) Q:(""=ItmMastDR)  d
	.
	.s Desc=^DHCPETMPCDI("ItmMast", ItmMastDR)
	.s FactAmount="" //不能从0开始 ,有可能是负值
	.f  s FactAmount=$O(^DHCPETMPCDI("ItmMast", ItmMastDR, "ADD", "G", FactAmount)) Q:(""=FactAmount)  d
	..s Amount=^DHCPETMPCDI("ItmMast", ItmMastDR, "ADD", "G", FactAmount, "FactAmount")
	..s Count=^DHCPETMPCDI("ItmMast", ItmMastDR, "ADD", "G", FactAmount, "Count")
	..s TotalAmount=^DHCPETMPCDI("ItmMast", ItmMastDR, "ADD", "G", FactAmount, "TotalAmount")
	..s Person=^DHCPETMPCDI("ItmMast", ItmMastDR, "ADD", "G", FactAmount, "IADMs")
	..
	..s Data=Title_"^"_Desc_"("_$P(Person,",",1,$L(Person,",")-1)_")"_"^"_$J(Amount, 3, 2)_"^"_Count_"^"_$J(TotalAmount,3 ,2)
	..s Datas=Datas_Data_"!"
	..i ""'=itmjs d
	...s retval=itmjs_"('"_$ZCVT(Data,"O","JS")_"');"
	...&javascript<#(retval)#>
	..s Title=""
	..
	..//w !,"Desc:"_Desc_"  TotalAmount:"_TotalAmount
	..s ^DHCPETMPCDI("TotalAomunt", "ADD", "G")=TotalAmount+$G(^DHCPETMPCDI("TotalAomunt", "ADD", "G"))
	..//w "    :"_^DHCPETMPCDI("TotalAomunt", "ADD", "G")_":"
	/////////////////////////////////////////////////////////////////////////////////////////
	s OrderSetsDR=0
	f  s OrderSetsDR=$O(^DHCPETMPCDI("OrderSets", OrderSetsDR)) Q:(""=OrderSetsDR)  d
	.s Desc=^DHCPETMPCDI("OrderSets", OrderSetsDR)
	.s FactAmount="" //不能从0开始 ,有可能是负值
	.f  s FactAmount=$O(^DHCPETMPCDI("OrderSets", OrderSetsDR, "ADD", "G", FactAmount)) Q:(""=FactAmount)  d
	..s Amount=^DHCPETMPCDI("OrderSets", OrderSetsDR, "ADD", "G", FactAmount, "FactAmount")
	..s Count=^DHCPETMPCDI("OrderSets", OrderSetsDR, "ADD", "G", FactAmount, "Count")
	..s TotalAmount=^DHCPETMPCDI("OrderSets", OrderSetsDR, "ADD", "G", FactAmount, "TotalAmount")
	..s Person=^DHCPETMPCDI("OrderSets", OrderSetsDR, "ADD", "G", FactAmount, "IADMs")
	..s Data=Title_"^"_Desc_"("_$P(Person,",",1,$L(Person,",")-1)_")"_"^"_$J(Amount, 3, 2)_"^"_Count_"^"_$J(TotalAmount,3 ,2)
	..s Datas=Datas_Data_"!"
	..i ""'=itmjs d
	...s retval=itmjs_"('"_$ZCVT(Data,"O","JS")_"');"
	...&javascript<#(retval)#>
	..s Title=""
	..
	..//w !,"Desc:"_Desc_"  TotalAmount:"_TotalAmount
	..s ^DHCPETMPCDI("TotalAomunt", "ADD", "G")=TotalAmount+$G(^DHCPETMPCDI("TotalAomunt", "ADD", "G"))
	..//w "    :"_^DHCPETMPCDI("TotalAomunt", "ADD", "G")_":"
	..
	// 公费加项合计
	s Data="公费加项合计:"_"^"_ ""_"^"_""_"^"_""_"^"_$J($G(^DHCPETMPCDI("TotalAomunt", "ADD", "G")) ,3 , 2)
	i ""'=itmjs d
	.s retval=itmjs_"('"_$ZCVT(Data,"O","JS")_"');"
	.&javascript<#(retval)#>
	////////////////////////////////////////////////////////////////////////////////////////////
	////////////////////////////////////////////////////////////////////////////////////////////
	////////////////////////////////////////////////////////////////////////////////////////////
	
	
	
	
	
	/*
	s Title="自费加项"
	s ItmMastDR=0
	f  s ItmMastDR=$O(^DHCPETMPCDI("ItmMast", ItmMastDR)) Q:(""=ItmMastDR)  d
	.s Desc=^DHCPETMPCDI("ItmMast", ItmMastDR)
	.s FactAmount="" //不能从0开始 ,有可能是负值
	.f  s FactAmount=$O(^DHCPETMPCDI("ItmMast", ItmMastDR, "ADD", "I", FactAmount)) Q:(""=FactAmount)  d
	..s Amount=^DHCPETMPCDI("ItmMast", ItmMastDR, "ADD", "I", FactAmount, "FactAmount")
	..s Count=^DHCPETMPCDI("ItmMast", ItmMastDR, "ADD", "I", FactAmount, "Count")
	..s TotalAmount=^DHCPETMPCDI("ItmMast", ItmMastDR, "ADD", "I", FactAmount, "TotalAmount")
	..s Person=^DHCPETMPCDI("ItmMast", ItmMastDR, "ADD", "I", FactAmount, "IADMs")
	..s Data=Title_"^"_Desc_"("_$P(Person,",",1,$L(Person,",")-1)_")"_"^"_$J(Amount, 3, 2)_"^"_Count_"^"_$J(TotalAmount,3 ,2)
	..s Datas=Datas_Data_"!"
	..i ""'=itmjs d
	...s retval=itmjs_"('"_$ZCVT(Data,"O","JS")_"');"
	...&javascript<#(retval)#>
	..s Title=""
	..// 不计入团体费用
	..//s ^DHCPETMPCDI("TotalAomunt", "ADD", "I")=TotalAmount+$G(^DHCPETMPCDI("TotalAomunt", "ADD", "I"))
	..
	/////////////////////////////////////////////////////////////////////////////////////////
	s OrderSetsDR=0
	f  s OrderSetsDR=$O(^DHCPETMPCDI("OrderSets", OrderSetsDR)) Q:(""=OrderSetsDR)  d
	.s Desc=^DHCPETMPCDI("OrderSets", OrderSetsDR)
	.s FactAmount="" //不能从0开始 ,有可能是负值
	.f  s FactAmount=$O(^DHCPETMPCDI("OrderSets", OrderSetsDR, "ADD", "I", FactAmount)) Q:(""=FactAmount)  d
	..s Amount=^DHCPETMPCDI("OrderSets", OrderSetsDR, "ADD", "I", FactAmount, "FactAmount")
	..s Count=^DHCPETMPCDI("OrderSets", OrderSetsDR, "ADD", "I", FactAmount, "Count")
	..s TotalAmount=^DHCPETMPCDI("OrderSets", OrderSetsDR, "ADD", "I", FactAmount, "TotalAmount")
	..s Person=^DHCPETMPCDI("OrderSets", OrderSetsDR, "ADD", "I", FactAmount, "IADMs")
	..s Data=Title_"^"_Desc_"("_$P(Person,",",1,$L(Person,",")-1)_")"_"^"_$J(Amount, 3, 2)_"^"_Count_"^"_$J(TotalAmount,3 ,2)
	..s Datas=Datas_Data_"!"
	..i ""'=itmjs d
	...s retval=itmjs_"('"_$ZCVT(Data,"O","JS")_"');"
	...&javascript<#(retval)#>
	..s Title=""
	..// 不计入团体费用
	..//s ^DHCPETMPCDI("TotalAomunt", "ADD", "I")=TotalAmount+$G(^DHCPETMPCDI("TotalAomunt", "ADD", "I"))
	// 自费加项合计
	s Data="自费加项合计:"_"^"_ ""_"^"_""_"^"_""_"^"_$J($G(^DHCPETMPCDI("TotalAomunt", "ADD", "I")),3 ,2)
	i ""'=itmjs d
	.s retval=itmjs_"('"_$ZCVT(Data,"O","JS")_"');"
	.&javascript<#(retval)#>
	////////////////////////////////////////////////////////////////////////////////////////////
	////////////////////////////////////////////////////////////////////////////////////////////
	////////////////////////////////////////////////////////////////////////////////////////////
	*/
	
	
	
	
	s Title="公+自加项"
	s ItmMastDR=0
	f  s ItmMastDR=$O(^DHCPETMPCDI("ItmMast", ItmMastDR)) Q:(""=ItmMastDR)  d
	.s ItmMastDesc=^DHCPETMPCDI("ItmMast", ItmMastDR)
	.s GFactAmount="" //不能从0开始 ,有可能是负值
	.f  s GFactAmount=$O(^DHCPETMPCDI("ItmMast", ItmMastDR, "ADD", "A", GFactAmount)) Q:(""=GFactAmount)  d
	..s IFactAmount="" //不能从0开始 ,有可能是负值
	..f  s IFactAmount=$O(^DHCPETMPCDI("ItmMast", ItmMastDR, "ADD", "A", GFactAmount, IFactAmount)) Q:(""=IFactAmount)  d
	...s Amount=^DHCPETMPCDI("ItmMast", ItmMastDR, "ADD", "A", GFactAmount, IFactAmount, "FactAmount")
	...s Count=^DHCPETMPCDI("ItmMast", ItmMastDR, "ADD", "A", GFactAmount, IFactAmount, "Count")
	...s TotalAmount=^DHCPETMPCDI("ItmMast", ItmMastDR, "ADD", "A", GFactAmount, IFactAmount, "TotalAmount")
	...
	...s Desc=ItmMastDesc_"("_(GFactAmount+IFactAmount)_")"
	...s Person=^DHCPETMPCDI("ItmMast", ItmMastDR, "ADD", "A", GFactAmount, IFactAmount, "IADMs")
	...s Data=Title_"^"_Desc_"("_$P(Person,",",1,$L(Person,",")-1)_")"_"^"_$J(Amount, 3, 2)_"^"_Count_"^"_$J(TotalAmount,3 ,2)
	...s Datas=Datas_Data_"!"
	...i ""'=itmjs d
	....s retval=itmjs_"('"_$ZCVT(Data,"O","JS")_"');"
	....&javascript<#(retval)#>
	...s Title=""
	...s ^DHCPETMPCDI("TotalAomunt", "ADD", "A")=TotalAmount+$G(^DHCPETMPCDI("TotalAomunt", "ADD", "A"))
	////////////////////////////////////////////////////////////////////////////////////////////
	//w "   TotalAomunt ADD:"_$G(^DHCPETMPCDI("TotalAomunt", "ADD", "A"))
	s OrderSetsDR=0
	f  s OrderSetsDR=$O(^DHCPETMPCDI("OrderSets", OrderSetsDR)) Q:(""=OrderSetsDR)  d
	.s ODesc=^DHCPETMPCDI("OrderSets", OrderSetsDR)
	.//w !," ODesc:"_ODesc
	.
	.s GFactAmount="" //不能从0开始 ,有可能是负值
	.f  s GFactAmount=$O(^DHCPETMPCDI("OrderSets", OrderSetsDR, "ADD", "A", GFactAmount)) Q:(""=GFactAmount)  d
	..//w !,"  GFactAmount:"_GFactAmount
	..s IFactAmount="" //不能从0开始 ,有可能是负值
	..f  s IFactAmount=$O(^DHCPETMPCDI("OrderSets", OrderSetsDR, "ADD", "A", GFactAmount, IFactAmount)) Q:(""=IFactAmount)  d
	...//w !,"      GFactAmount:"_GFactAmount
	...s Amount=^DHCPETMPCDI("OrderSets", OrderSetsDR, "ADD", "A", GFactAmount, IFactAmount, "FactAmount")
	...s Count=^DHCPETMPCDI("OrderSets", OrderSetsDR, "ADD", "A", GFactAmount, IFactAmount, "Count")
	...s TotalAmount=^DHCPETMPCDI("OrderSets", OrderSetsDR, "ADD", "A", GFactAmount, IFactAmount, "TotalAmount")
	...
	...s Desc=ODesc_"("_(GFactAmount+IFactAmount)_")"
	...s Person=^DHCPETMPCDI("OrderSets", OrderSetsDR, "ADD", "A", GFactAmount, IFactAmount, "IADMs")
	...s Data=Title_"^"_Desc_"("_$P(Person,",",1,$L(Person,",")-1)_")"_"^"_$J(Amount, 3, 2)_"^"_Count_"^"_$J(TotalAmount,3 ,2)
	...s Datas=Datas_Data_"!"
	...i ""'=itmjs d
	....s retval=itmjs_"('"_$ZCVT(Data,"O","JS")_"');"
	....&javascript<#(retval)#>
	...s Title=""
	...//w "  TotalAmount:"_TotalAmount
	...s ^DHCPETMPCDI("TotalAomunt", "ADD", "A")=TotalAmount+$G(^DHCPETMPCDI("TotalAomunt", "ADD", "A"))
	...//w "   TotalAomunt ADD:"_^DHCPETMPCDI("TotalAomunt", "ADD", "A")

	
	// 公+自加项合计
	s Data="公+自加项合计:"_"^"_ ""_"^"_""_"^"_""_"^"_$J($G(^DHCPETMPCDI("TotalAomunt", "ADD", "A")), 3 ,2)
	i ""'=itmjs d
	.s retval=itmjs_"('"_$ZCVT(Data,"O","JS")_"');"
	.&javascript<#(retval)#>
	////////////////////////////////////////////////////////////////////////////////////////////
	////////////////////////////////////////////////////////////////////////////////////////////
	////////////////////////////////////////////////////////////////////////////////////////////
	
	
	
	
	
	
	
	
	s Title="减项"
	s ItmMastDR=0
	f  s ItmMastDR=$O(^DHCPETMPCDI("ItmMast", ItmMastDR)) Q:(""=ItmMastDR)  d
	.s Desc=^DHCPETMPCDI("ItmMast", ItmMastDR)
	.s FactAmount="" //不能从0开始 ,有可能是负值
	.f  s FactAmount=$O(^DHCPETMPCDI("ItmMast", ItmMastDR, "DEL", FactAmount)) Q:(""=FactAmount)  d
	..s Amount=^DHCPETMPCDI("ItmMast", ItmMastDR, "DEL", FactAmount, "FactAmount")
	..s Count=^DHCPETMPCDI("ItmMast", ItmMastDR, "DEL", FactAmount, "Count")
	..s TotalAmount=^DHCPETMPCDI("ItmMast", ItmMastDR, "DEL", FactAmount, "TotalAmount")
	..s Person=^DHCPETMPCDI("ItmMast", ItmMastDR, "DEL", FactAmount, "IADMs")
	..s Data=Title_"^"_Desc_"("_$P(Person,",",1,$L(Person,",")-1)_")"_"^"_$J(Amount, 3, 2)_"^"_Count_"^"_$J(TotalAmount,3 ,2)
	..s Datas=Datas_Data_"!"
	..i ""'=itmjs d
	...s retval=itmjs_"('"_$ZCVT(Data,"O","JS")_"');"
	...&javascript<#(retval)#>
	..s Title=""
	..
	..s ^DHCPETMPCDI("TotalAomunt", "DEL")=TotalAmount+$G(^DHCPETMPCDI("TotalAomunt", "DEL"))
	..
	/////////////////////////////////////////////////////////////////////////////////////////
	s OrderSetsDR=0
	f  s OrderSetsDR=$O(^DHCPETMPCDI("OrderSets", OrderSetsDR)) Q:(""=OrderSetsDR)  d
	.s Desc=^DHCPETMPCDI("OrderSets", OrderSetsDR)
	.s FactAmount="" //不能从0开始 ,有可能是负值
	.f  s FactAmount=$O(^DHCPETMPCDI("OrderSets", OrderSetsDR, "DEL", FactAmount)) Q:(""=FactAmount)  d
	..s Amount=^DHCPETMPCDI("OrderSets", OrderSetsDR, "DEL", FactAmount, "FactAmount")
	..s Count=^DHCPETMPCDI("OrderSets", OrderSetsDR, "DEL", FactAmount, "Count")
	..s TotalAmount=^DHCPETMPCDI("OrderSets", OrderSetsDR, "DEL", FactAmount, "TotalAmount")
	..s Person=^DHCPETMPCDI("OrderSets", OrderSetsDR, "DEL", FactAmount, "IADMs")
	..s Data=Title_"^"_Desc_"("_$P(Person,",",1,$L(Person,",")-1)_")"_"^"_$J(Amount, 3, 2)_"^"_Count_"^"_$J(TotalAmount,3 ,2)
	..s Datas=Datas_Data_"!"
	..i ""'=itmjs d
	...s retval=itmjs_"('"_$ZCVT(Data,"O","JS")_"');"
	...&javascript<#(retval)#>
	..s Title=""
	..
	..s ^DHCPETMPCDI("TotalAomunt", "DEL")=TotalAmount+$G(^DHCPETMPCDI("TotalAomunt", "DEL"))

	// 减项合计
	s Data="减项合计:"_"^"_ ""_"^"_""_"^"_""_"^"_$J($G(^DHCPETMPCDI("TotalAomunt", "DEL")), 3, 2)
	i ""'=itmjs d
	.s retval=itmjs_"('"_$ZCVT(Data,"O","JS")_"');"
	.&javascript<#(retval)#>
	.
	////////////////////////////////////////////////////////////////////////////////////////////
	////////////////////////////////////////////////////////////////////////////////////////////
	////////////////////////////////////////////////////////////////////////////////////////////
	
	
	
	
	
	
	
	// 总计
	// 团体组费用
	s GTotalAmount=$G(^DHCPETMPCDI("TotalAomunt", "GFactAmount"))
	// 加项
	s FeeType=""
	f  s FeeType=$O(^DHCPETMPCDI("TotalAomunt", "ADD", FeeType)) Q:(""=FeeType)  d
	.s GTotalAmount=GTotalAmount+$G(^DHCPETMPCDI("TotalAomunt", "ADD", FeeType))
	// 减项
	s GTotalAmount=GTotalAmount-$G(^DHCPETMPCDI("TotalAomunt", "DEL"))
	
	s ^DHCPETMPCDI("TotalAomunt")=GTotalAmount
	s Data="总计:"_"^"_ ""_"^"_""_"^"_$G(^DHCPETMPCDI("Person"))_"^"_$J(GTotalAmount, 3, 2)
	//s Datas=Datas_Data_"!"
	i ""'=itmjs d
	.s retval=itmjs_"('"_$ZCVT(Data,"O","JS")_"');"
	.&javascript<#(retval)#>
	.
	Q 0
}

ClassMethod StatisticPreIOrdItemFee()
{
	Q 0
}

ClassMethod StatisticPreIOrdEntFee()
{
	Q 0
}

}
