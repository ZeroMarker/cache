Import SQLUser

/// 体检费用清单
Class web.DHCPE.FeeReport.InvItemFeeList Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 98;

/// w ##class(web.DHCPE.FeeReport.InvItemFeeList).GetInvItemFeeList("","","22")
ClassMethod GetInvItemFeeList(itmjs As %Library.String = "", itmjsex As %Library.String = "", Instring As %Library.String = "") As %Status
{
	// DHC_PE_INVPRT.{ PRT_ROWID }
 	s InvRptRowID=$P(Instring,"^",1)
 	
 	d ..GetInvDetail($P(itmjs, "^", 1), itmjsex, InvRptRowID)
	
 	d ..GetInvItemFeeListInfo($P(itmjs, "^", 2), itmjsex, InvRptRowID)

	Q 1
}

ClassMethod GetInvDetail(itmjs As %Library.String = "", itmjsex As %Library.String = "", RptRowId As %Library.String = "")
{
	s CurData=$G(^DHCPEINVPRT(RptRowId))

 	// 发票号 DHC_PE_invprt.{ PRT_INVNO } 
 	s INVNO=$P(CurData, "^", 1 )
 	
 	// DHC_PE_invprt.{ PRT_PAADM_DR }
 	s PAADMDR=$P(CurData, "^", 2 )
 	
 	//PA_ADM	PAADM_PAPMI_DR
	s PapmiDR=$p($g(^PAADM(PAADMDR)),"^",1)			
	q:(""=PapmiDR) ""
	
	//姓名	PAPMI_Name PA_PatMas
	s Name=$p(^PAPER(PapmiDR,"ALL"),"^",1)			

	// 登记号 PA_PatMas.{PAPMI_IPNo}
	S PAPMIIPNo=$P(^PAPER(PapmiDR,"PAT",1),"^",1)	
 	
 	s Data=PAPMIIPNo_"^"_Name_"^"_INVNO
	
	i ""'=itmjs d
	.s retval=itmjs_"('"_$ZCVT(Data,"O","JS")_"');"
	.&javascript<#(retval)#>
 	
 	Q Data
}

ClassMethod GetInvItemFeeListInfo(itmjs As %Library.String = "", itmjsex As %Library.String = "", RptRowId As %Library.String = "")
{
	k ^DHCPEIIFLTMP
	s CurData=$G(^DHCPEINVPRT(RptRowId))

 	// DHC_PE_invprt.{ PRT_PB_DR } = DHC_PatientBill.{ } = DHC_PE_PAPBRelate.{ PAPB_PB_DR }
 	s PBDR=$P(CurData, "^", 3)

	// DHC_PE_PAPBRelate.{ PAPB_RowId }
	s PAPBRowId=0
	f  s PAPBRowId=$O(^DHCPEPAPBR(0,"PBDR",PBDR,PAPBRowId)) Q:(""=PAPBRowId)  d
	.// DHC_PE_PAPBRelate.{ PAPB_PA_DR } = DHC_PE_PreAudit.{ }
	.s PADR=$P($G(^DHCPEPAPBR(PAPBRowId)), "^" ,1)
	.k ^DHCPETemp
	.d ##class(web.DHCPE.ItemFeeList).GetListInfo(PADR,1,$H,$J)
	.
	.s curdate=""
	.f  s curdate=$O(^DHCPETemp("GetListInfo",curdate)) Q:(""=curdate)  d
	..s job=""
	..f  s job=$O(^DHCPETemp("GetListInfo",curdate,job)) Q:(""=job)  d
	...s ItemId=""
	...f  s ItemId=$O(^DHCPETemp("GetListInfo",curdate,job,ItemId)) Q:(""=ItemId)  d
	....// 实收金额
	....s itmFactAmount=""
	....f  s itmFactAmount=$O(^DHCPETemp("GetListInfo",curdate,job,ItemId,itmFactAmount)) Q:(""=itmFactAmount)  d
	.....
	.....// w !,"itmFactAmount:"_itmFactAmount_"  "_$G(^DHCPETemp("GetListInfo",curdate,job,ItemId,itmFactAmount))
	.....s CurData=$G(^DHCPETemp("GetListInfo",curdate,job,ItemId,itmFactAmount))
	.....
	.....// 价格(应收金额)
	.....s ItemPrice=+$P(CurData, "^", 6)
	.....s ^DHCPEIIFLTMP("ItemList", ItemId, "Price", ItemPrice)=ItemPrice
	.....
	.....// 名称
	.....s ^DHCPEIIFLTMP("ItemList", ItemId)=$P(CurData, "^", 1)
	.....// 数量
	.....s ItemNum=$P(CurData, "^", 2)
	.....s ^DHCPEIIFLTMP("ItemList", ItemId, "Price", ItemPrice, "ItemNum")=$G(^DHCPEIIFLTMP("ItemList", ItemId, "Price", ItemPrice, "ItemNum"))+ItemNum
	.....// 实收金额
	.....s ^DHCPEIIFLTMP("ItemList", ItemId, "Price", ItemPrice, "FactAmount")=$P(CurData, "^", 3)+$G(^DHCPEIIFLTMP("ItemList", ItemId, "Price", ItemPrice, "FactAmount"))
	.....
	.....// 实收价格
	.....s ^DHCPEIIFLTMP("ItemList", ItemId, "Price", ItemPrice, "FactPrice")=$P(CurData, "^", 4)
	.....
	.....// 规格
	.....//s ^DHCPEIIFLTMP("ItemList", ItemId, "Price", ItemPrice, "UOM")=$P(CurData, "^", 5)
	.....
	.....s ^DHCPEIIFLTMP("ItemList", ItemId, "Price", ItemPrice, "ItemTotalAmount")=ItemNum*ItemPrice+$G(^DHCPEIIFLTMP("ItemList", ItemId, "Price", ItemPrice, "ItemTotalAmount"))
	.....
	.
	
	k ^DHCPETemp
	s No=0
	s ItemId=""
	f  s ItemId=$O(^DHCPEIIFLTMP("ItemList", ItemId)) Q:(""=ItemId)  d
	.s ItemName=^DHCPEIIFLTMP("ItemList", ItemId)
	.
	.s ItemPrice=""
	.f  s ItemPrice=$O(^DHCPEIIFLTMP("ItemList", ItemId, "Price", ItemPrice)) Q:(""=ItemPrice)  d
	..s ItemNum=$G(^DHCPEIIFLTMP("ItemList", ItemId, "Price", ItemPrice, "ItemNum"))
	..s ItemTotalAmount=^DHCPEIIFLTMP("ItemList", ItemId, "Price", ItemPrice, "ItemTotalAmount")
	..
	..s No=No+1
	..s Data=No_"^"_ItemName_"^"_$J(ItemPrice,3,2)_"^"_ItemNum_"^"_$J(ItemTotalAmount,3,2)
	..
	..i ""'=itmjs d
	...s retval=itmjs_"('"_$ZCVT(Data,"O","JS")_"');"
	...&javascript<#(retval)#>
	..
	..// 应收总计
	..s ^DHCPEIIFLTMP("Total", "TotalAmount")=$G(^DHCPEIIFLTMP("Total", "TotalAmount"))+ItemTotalAmount
	..// 实收总计
	..s ^DHCPEIIFLTMP("Total", "FactAmount")=$G(^DHCPEIIFLTMP("Total", "FactAmount"))+^DHCPEIIFLTMP("ItemList", ItemId, "Price", ItemPrice, "FactAmount")
	..// 优惠总计
	.

	s TotalAmount=$G(^DHCPEIIFLTMP("Total", "TotalAmount"))
	s Data=""_"^"_"应收合计"_"^"_""_"^"_""_"^"_$J(TotalAmount,3,2)
	i ""'=itmjs d
	.s retval=itmjs_"('"_$ZCVT(Data,"O","JS")_"');"
	.&javascript<#(retval)#>
	
	s FactAmount=$G(^DHCPEIIFLTMP("Total", "FactAmount"))
	s Data=""_"^"_"实收金额"_"^"_""_"^"_""_"^"_$J(FactAmount,3,2)
	i ""'=itmjs d
	.s retval=itmjs_"('"_$ZCVT(Data,"O","JS")_"');"
	.&javascript<#(retval)#>
	
	s Data=""_"^"_"优惠金额"_"^"_""_"^"_""_"^"_$J(TotalAmount-FactAmount,3,2)
	i ""'=itmjs d
	.s retval=itmjs_"('"_$ZCVT(Data,"O","JS")_"');"
	.&javascript<#(retval)#>
	.
	
	Q
}

/// w ##class(web.DHCPE.Report.MonthStatistic).getpath()
ClassMethod getpath()
{
	&sql(select pathtoreports into :path from websys.configuration)
	q path
}

}
