Import SQLUser

/// 创建时间		：2008.01.21
/// 创建人		：xuwm
/// 存在系统		：体检系统
/// 主要功能		: 为厦门实现的功能:导出预约团体的详细数据
/// 备注			: 与宁波的需求有冲突:宁波的需求是当前功能的子集
/// 			: 人员导出部分与《体检月工作量统计》的名单部分类似
/// 最后修改时间	：
/// 最后修改人	：
/// 文件状态		: 未完成
/// 
Class web.DHCPE.Report.PreGADMInfostatistic Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 112;

/// 团体组项目单价
/// w ##class(web.DHCPE.Report.PreGADMInfostatistic).PreGADMInfostatistic("7")
ClassMethod PreGADMInfostatistic(GID As %Library.String = "")
{
	k ^DHCPETMP("PGI")
	s ^DHCPETMP("PGI","Total")=0
	// DHC_PE_PreIADM.{ PIADM_RowId }
	s pid=0
	f  s pid=$O(^DHCPEPreIADM(0,"PGADM",GID,pid)) Q:(""=pid)  d
	.
	.s CurData=$g(^DHCPEPreIADM(pid))
	.
	.// PIADM_PIBI_DR 预登记个人基本信息号
	.s PIADMPIBIDR=$p(CurData,"^",1)
	.Q:(""=PIADMPIBIDR)	//防止取到空数据
	.
	.// PIADM_PGTeam_DR 对应组ADM	 DHC_PE_PreGTeam
	.s PIADMPGTeamDRName="(无组)"
	.s PIADMPGTeamDR=$p(CurData,"^",3)
	.//PGT_ParRef
	.s PGTParRef=$P(PIADMPGTeamDR,"||",1)
	.//PGT_ChildSub
	.s PGTChildSub=$P(PIADMPGTeamDR,"||",2)
	.s:(""'=PIADMPGTeamDR) PIADMPGTeamDRName=$P($g(^DHCPEPreGADM(PGTParRef,"Team",PGTChildSub)),"^",1)
	.
	.s ^DHCPETMP("PGI","PGTeam",PIADMPGTeamDRName,"Total")=1+$G(^DHCPETMP("PGI","PGTeam",PIADMPGTeamDRName,"Total"))
	.
	.// PIADM_PEDateBegin	预约体检日期
	.s PIADMPEDateBegin=$p(CurData,"^",4)
	.s:(""'=PIADMPEDateBegin) PIADMPEDateBegin=$ZD(PIADMPEDateBegin,3)
	.
	.// PIADM_PEDateEnd	预约体检日期
	.s PIADMPEDateEnd=$p(CurData,"^",5)
	.s:(""'=PIADMPEDateEnd) PIADMPEDateEnd=$ZD(PIADMPEDateEnd,3)
	.
	.// PIADM_Status	登记状态
	.s Status=$p(CurData,"^",8)
	.s Status=##Class(web.DHCPE.PreCommon).TransStatus(Status)
	.
	.s retVal=##class(web.DHCPE.HandlerPreOrds).IGetAmount4Person(pid)
	.s AAmount=$P(retVal,"^",1)
	.s FAmount=$P(retVal,"^",2)
	.
	.s IADMAdmDate=""	// 到达日期
	.s RPTPrintDate=""	// 打印日期
	.s RPTSendDate=""	// 发送日期
	.
	.// DHC_PE_IADM.{ IADM_RowId }
	.s IADMRowId=$o(^DHCPEIADM(0,"CRMADM",pid,0))
	.i ""'=IADMRowId d
	..// DHC_PE_IADM.{ IADM_Status }
	..s Status=$p(^DHCPEIADM(IADMRowId),"^",8)
	..s Status=##Class(web.DHCPE.PreCommon).TransStatus(Status)
	..
	..// DHC_PE_IADM.{ IADM_AdmDate }
	..s IADMAdmDate=$p(^DHCPEIADM(IADMRowId),"^",5)
	..s:((""'=IADMAdmDate)) IADMAdmDate=$ZD(IADMAdmDate,3)
	..
	..// DHC_PE_Report.{ RPT_RowId }
	..s RPTRowId=$O(^DHCPERPT(0,"IADM",IADMRowId,0))
	..// DHC_PE_Report.{ RPT_Status }
	..s RPTStatus=$P(^DHCPERPT(RPTRowId),"^",2)
	..
	..// DHC_PE_Report.{ RPT_PrintDate
	..s RPTPrintDate=$P(^DHCPERPT(RPTRowId),"^",7)
	..s:((""'=RPTPrintDate)) RPTPrintDate=$ZD(RPTPrintDate,3)
	..// DHC_PE_Report.{ RPT_SendDate }
	..s RPTSendDate=$P(^DHCPERPT(RPTRowId),"^",9)
	..s:((""'=RPTSendDate)) RPTSendDate=$ZD(RPTSendDate,3)
	.
	.// 各种状态的人员统计
	.s ^DHCPETMP("PGI","Status",Status,"Total")=1+$G(^DHCPETMP("PGI","Status",Status,"Total"))
	.// 客户信息
	.s CurData=##Class(web.DHCPE.PreIBaseInfo).GetPreIBaseInfo(PIADMPIBIDR_"^^^")
	.
	.s RegNo=$P(CurData,"^",2)				//	登记号
	.s Name=$P(CurData,"^",3)				//	姓名
	.s Sex=$P(CurData,"^",5)				//	性别
	.s DOB=$P(CurData,"^",6)				//	生日
	.s:(""'=DOB) DOB=$ZD($ZDH(DOB,4),3)
	.s Tel=$P(CurData,"^",11)				//	MobilePhone
	.s:(""=Tel) Tel=$P(CurData,"^",9)		//	Tel1
	.s:(""=Tel) Tel=$P(CurData,"^",10)		//	Tel2
	.
	.s IDCard=$P(CurData,"^",12)			//	身份证
	.s Address=$P(CurData,"^",17)			//	地址
	.s Age=+$P(CurData,"^",28)				//	年龄
	.
	.// 总人数统计
	.s ^DHCPETMP("PGI","Total")=1+^DHCPETMP("PGI","Total")
	.// 获取客户的费用
	.d ..GetGIADMFeeinfo(pid)
	.
	.s ^DHCPETMP("PGI","IADMs",pid)=RegNo_"^"_Name_"^"_Sex_"^"_Status
	.s ^DHCPETMP("PGI","IADMs",pid)=^DHCPETMP("PGI","IADMs",pid)_"^"_IADMAdmDate_"^"_RPTPrintDate_"^"_RPTSendDate
	.s ^DHCPETMP("PGI","IADMs",pid)=^DHCPETMP("PGI","IADMs",pid)_"^"_PIADMPGTeamDRName_"^"_$FN(FAmount,"",2)
	.s ^DHCPETMP("PGI","IADMs",pid)=^DHCPETMP("PGI","IADMs",pid)_"^"_PIADMPEDateBegin_"^"_PIADMPEDateEnd
	.s ^DHCPETMP("PGI","IADMs",pid)=^DHCPETMP("PGI","IADMs",pid)_"^"_IDCard_"^"_Tel_"^"_Age_"^"_DOB_"^"_Address
	.//w ^DHCPETMP("PGI","IADMs",pid),!
	s ^DHCPETMP("PGI","IADMs",0)="登记号"_"^"_"姓名"_"^"_"性别"_"^"_"状态"
	s ^DHCPETMP("PGI","IADMs",0)=^DHCPETMP("PGI","IADMs",0)_"^"_"到达日期"_"^"_"打印报告日期"_"^"_"报告发送日期"
	s ^DHCPETMP("PGI","IADMs",0)=^DHCPETMP("PGI","IADMs",0)_"^"_"分组"_"^"_"金额"
	s ^DHCPETMP("PGI","IADMs",0)=^DHCPETMP("PGI","IADMs",0)_"^"_"预约起始日期"_"^"_"预约截止日期"
	s ^DHCPETMP("PGI","IADMs",0)=^DHCPETMP("PGI","IADMs",0)_"^"_"身份证"_"^"_"电话"_"^"_"年龄(岁)"_"^"_"出生日期"_"^"_"地址"
	//w ^DHCPETMP("PGI","IADMs",0),!
	Q ""
}

/// 导出数据----接口
/// w ##class(web.DHCPE.Report.PreGADMInfostatistic).PreGADMstatisticImport("Out","","1^")
ClassMethod PreGADMstatisticImport(itmjs As %Library.String = "", itmjsex As %Library.String = "", Instring As %Library.String = "") As %Status
{
	
	
	//  DHC_PE_PreGADM.{ PGADM_RowId }
	s GID=$P(Instring,"^",1)
	s Step=+$P(Instring,"^",2)
	d:(2>Step) ..PreGADMInfostatistic(GID)
	
	s retval=""
	s ^DHCPETMP("PGI","1")=Instring
	s:(2>Step) retval=..PreGADMInfoImport(itmjs,"","")
	s ^DHCPETMP("PGI","2")=Instring
	s:(2=Step) retval=..PreGADMPersonListImport(itmjs,"","")
	s ^DHCPETMP("PGI","3")=Instring
	s:(3=Step) retval=..PreGADMFeeImport(itmjs,"","")
	Q retval
}

/// 导出团体统计信息
/// d ##class(web.DHCPE.Report.PreGADMInfostatistic).PreGADMInfoImport("Out","","1^")
ClassMethod PreGADMInfoImport(itmjs As %Library.String = "", itmjsex As %Library.String = "", Instring As %Library.String = "") As %Status
{

	s Data="总人数:"_"^"_(+^DHCPETMP("PGI","Total"))
	i ""'=itmjs d
	.s retval=itmjs_"('"_$ZCVT(Data,"O","JS")_"');"
	.&javascript<#(retval)#>
	.
	s Status=""
	f  s Status=$O(^DHCPETMP("PGI","Status",Status)) Q:(""=Status)  d
	.s Data=Status_"人数:"_"^"_(+^DHCPETMP("PGI","Status",Status,"Total"))
	.i ""'=itmjs d
	..s retval=itmjs_"('"_$ZCVT(Data,"O","JS")_"');"
	..&javascript<#(retval)#>
	..
	Q "统计数据"
}

/// 导出团体客户信息
/// w ##class(web.DHCPE.Report.PreGADMInfostatistic).PreGADMPersonListImport("Out","","1^")
ClassMethod PreGADMPersonListImport(itmjs As %Library.String = "", itmjsex As %Library.String = "", Instring As %Library.String = "") As %Status
{
	s id=""
	f  s id=$O(^DHCPETMP("PGI","IADMs",id)) Q:(""=id)  d
	.s Data=^DHCPETMP("PGI","IADMs",id)
	.i ""'=itmjs d
	..s retval=itmjs_"('"_$ZCVT(Data,"O","JS")_"');"
	..&javascript<#(retval)#>
	Q "客户信息"
}

/// 导出团体费用信息
/// d ##class(web.DHCPE.Report.PreGADMInfostatistic).PreGADMFeeImport("Out","","")
ClassMethod PreGADMFeeImport(itmjs As %Library.String = "", itmjsex As %Library.String = "", Instring As %Library.String = "") As %Status
{
	s Data="登记号"_"^"_"姓名"_"^"_"团体组"_"^"_"项目名称"_"^"_"登记类型"_"^"_"费用类型"_"^"_"公费金额"_"^"_"自费金额"_"^"_"总价"
	i ""'=itmjs d
	.s retval=itmjs_"('"_$ZCVT(Data,"O","JS")_"');"
	.&javascript<#(retval)#>
	.

	s piadmid=""
	f  s piadmid=$O(^DHCPETMP("PGI","IADMs",piadmid)) Q:(""=piadmid)  d
	.
	.s Data=^DHCPETMP("PGI","IADMs",piadmid)
	.s RegNo=$P(Data,"^",1)
	.s Name=$P(Data,"^",2)
	.s Team=$P(Data,"^",8)
	.s ItemType=""
	.f  s ItemType=$O(^DHCPETMP("PGI","IADMs",piadmid,"Fee",ItemType)) Q:(""=ItemType)  d
	..s FeeItem=""
	..f  s FeeItem=$O(^DHCPETMP("PGI","IADMs",piadmid,"Fee",ItemType,FeeItem)) Q:(""=FeeItem)  d
	...s FAmount=+$G(^DHCPETMP("PGI","IADMs",piadmid,"Fee",ItemType,FeeItem,"FAmount"))
	...s GAmount=+$G(^DHCPETMP("PGI","IADMs",piadmid,"Fee",ItemType,FeeItem,"GAmount"))
	...s IAmount=+$G(^DHCPETMP("PGI","IADMs",piadmid,"Fee",ItemType,FeeItem,"IAmount"))
	...s Type=$G(^DHCPETMP("PGI","IADMs",piadmid,"Fee",ItemType,FeeItem,"Type"))
	...s FeeType=$G(^DHCPETMP("PGI","IADMs",piadmid,"Fee",ItemType,FeeItem,"FeeType"))
	...
	...s Data=RegNo_"^"_Name_"^"_Team_"^"_FeeItem_"^"_Type_"^"_FeeType_"^"_$FN(GAmount,"",2)_"^"_$FN(IAmount,"",2)_"^"_$FN(FAmount,"",2)
	...i ""'=itmjs d
	....s retval=itmjs_"('"_$ZCVT(Data,"O","JS")_"');"
	....&javascript<#(retval)#>
	....
	..
	..
	..s RegNo=""
	..s Name=""
	..s Team=""
	Q "费用详情"
}

/// 获取团体客户的费用信息
/// d ##class(web.DHCPE.Report.PreGADMInfostatistic).GetGIADMFeeinfo(140)
ClassMethod GetGIADMFeeinfo(piadmid As %Library.String = "") As %Status
{
	s OrderSetsList="^" // 已处理套餐的列表
	// DHC_PE_PreIOrdItem.{ PIOI_ChildSub }
	s PIOIChildSub=0
	f  s PIOIChildSub=$O(^DHCPEPreIADM(piadmid, "ORDITEM", PIOIChildSub)) Q:(""=PIOIChildSub)  d
	.
	.s CurData=$G(^DHCPEPreIADM(piadmid, "ORDITEM", PIOIChildSub))
	.
	.// DHC_PE_PreIOrdItem.{ PIOI_OrdEnt_DR } 
	.s PIOIOrdEntDR=$P(CurData,"^",2)
	.Q:(""'=PIOIOrdEntDR)&(OrderSetsList[("^"_PIOIOrdEntDR_"^"))
	.s:(""'=PIOIOrdEntDR) OrderSetsList=OrderSetsList_"^"_PIOIOrdEntDR_"^"
	.
	.
	.// 套餐项目
	.i (""'=PIOIOrdEntDR) d
	..// DHC_PE_PreIOrdEnt.{ PIOE_ChildSub }
	..s PIOEChildSub=$P(PIOIOrdEntDR, "||", 2)
	..s CurData=$G(^DHCPEPreIADM(piadmid,"ORDENT",PIOEChildSub))
	..
	..// DHC_PE_PreIOrdEnt.{ PIOE_ItemStat } 1-核实 4-停止
	..s PIOEItemStat=$P(CurData,"^", 9)
	..Q:(4=PIOEItemStat)
	..
	..// DHC_PE_PreIOrdEnt.{ PIOE_OrderSets_DR } = ARC_OrdSets
	..s OrderSets=$P(CurData, "^", 1)
	..s OrderSets=$p(^ARCOS(OrderSets),"^",2) // ARCOS_Desc
	..
	..// 优惠金额
	..s FactAmount=+##class(web.DHCPE.HandlerPreOrds).GetFactAmountByOrd(PIOIOrdEntDR,"","")
	..s ^DHCPETMP("PGI","IADMs",piadmid,"Fee", "套餐", OrderSets, "FAmount")=FactAmount
	..
	..// DHC_PE_PreIOrdEnt.{ PIOE_Type } PRE-PreReg 预约 ADD-AddOrder加项
	..s PIOEType=$P(CurData,"^", 8)
	..s:(PIOEType="PRE") ^DHCPETMP("PGI", "IADMs", piadmid, "Fee", "套餐", OrderSets, "Type")="预约"
	..s:(PIOEType="ADD") ^DHCPETMP("PGI", "IADMs", piadmid, "Fee", "套餐", OrderSets, "Type")="加项"
	..
	..
	..
	..// 额外加项
	..s AdmTypes="^" //费用列表
	..s GFactAmount=0
	..s IFactAmount=0
	..// DHC_PE_PreIOrdEntFee.{ PIOEF_ChildSub }
	..s PIOEFChildSub=0
	..f  s PIOEFChildSub=$o(^DHCPEPreIADM(piadmid,"ORDENT",PIOEChildSub, "FEE", PIOEFChildSub)) Q:(""=PIOEFChildSub)  d
	...s CurData=$g(^DHCPEPreIADM(piadmid,"ORDENT",PIOEChildSub,"FEE",PIOEFChildSub))
	...
	...// DHC_PE_PreIOrdEntFee.{ PIOEF_PAudit_DR } = DHC_PE_PreAudit
	...s AuditId=$p(CurData, "^", 5)
	...// 团体和个人ADM审核表 DHC_PE_PreAudit.{ PA_Status }
	...s PAStatus=$p($g(^DHCPEPreA(AuditId)),"^",21)
	...Q:("NU"=PAStatus) // U-Use有效 NU-NoUse无效
	...// DHC_PE_PreAudit.{ PA_ADMType } G-团体费用 I-个人费用
	...s ADMType=$p($g(^DHCPEPreA(AuditId)),"^",1)
	...s AdmTypes=AdmTypes_ADMType_"^" 
	...// DHC_PE_PreIOrdEntFee.{ PIOEF_FactAmount }
	...s FactAmount=$p(CurData,"^", 2)
	...s:("G"=ADMType) GFactAmount=GFactAmount+FactAmount
	...s:("I"=ADMType) IFactAmount=IFactAmount+FactAmount
	..
	..
	..
	..// 公费
	..s ^DHCPETMP("PGI","IADMs",piadmid,"Fee", "套餐", OrderSets, "GAmount")=GFactAmount
	..// 自费
	..s ^DHCPETMP("PGI","IADMs",piadmid,"Fee", "套餐", OrderSets, "IAmount")=IFactAmount
	..
	..// 公费加项
	..s:(AdmTypes["^G^")&(AdmTypes'["^I^") ^DHCPETMP("PGI","IADMs",piadmid,"Fee", "套餐", OrderSets, "FeeType")="公费"
	..// 自费加项
	..s:(AdmTypes'["^G^")&(AdmTypes["^I^") ^DHCPETMP("PGI","IADMs",piadmid,"Fee", "套餐", OrderSets, "FeeType")="自费"
	..// 公+自
	..s:(AdmTypes["^G^")&(AdmTypes["^I^") ^DHCPETMP("PGI","IADMs",piadmid,"Fee", "套餐", OrderSets, "FeeType")="公+自"
	..
	.
	.
	.
	.// 非套餐项目
	.i ""=PIOIOrdEntDR d
	..// DHC_PE_PreIOrdItem.{ PIOI_ItemStat } 1-核实 4-停止
	..s PIOIItemStat=$P(CurData,"^",16)
	..Q:(4=PIOIItemStat)
	..
	..// DHC_PE_PreIOrdItem.{ PIOI_ItmMast_DR }
	..s ItmMastDR=$P(CurData,"^",1)
	..s ItmMastDesc=$p(^ARCIM($p(ItmMastDR,"||",1),$p(ItmMastDR,"||",2),1),"^",2)
	..
	..// 应收金额
	..// DHC_PE_PreIOrdItem.{ PIOI_AccountAmount }
	..s AccountAmount=$P(CurData,"^",14)
	..
	..s PIOIDR=piadmid_"||"_PIOIChildSub
	..// 优惠金额
	..s FactAmount=+##class(web.DHCPE.HandlerPreOrds).GetFactAmountByItem(PIOIDR,"","")
	..s ^DHCPETMP("PGI","IADMs",piadmid,"Fee", "项目", ItmMastDesc, "FAmount")=FactAmount
	..
	..
	..
	..// PIOI_Type PRE-PreReg预约 ADD-AddOrder加项
	..s PIOIType=$P(CurData,"^",15)
	..s:(PIOIType="PRE") ^DHCPETMP("PGI", "IADMs", piadmid, "Fee", "项目", ItmMastDesc, "Type")="预约"
	..s:(PIOIType="ADD") ^DHCPETMP("PGI", "IADMs", piadmid, "Fee", "项目", ItmMastDesc, "Type")="加项"
	..
	..
	..s AdmTypes="^" //费用类型列表
	..s GFactAmount=0
	..s IFactAmount=0
	..// DHC_PE_PreIOrdItemFee.{ PIOIF_ChildSub }
	..s PIOIFChildSub=0
	..f  s PIOIFChildSub=$o(^DHCPEPreIADM(piadmid,"ORDITEM",PIOIChildSub,"FEE",PIOIFChildSub)) Q:(""=PIOIFChildSub)  d
	...s CurData=$g(^DHCPEPreIADM(piadmid,"ORDITEM",PIOIChildSub,"FEE",PIOIFChildSub))
	...
	...// DHC_PE_PreIOrdItemFee.{ PIOIF_PAudit_DR } = DHC_PE_PreAudit
	...s AuditId=$p(CurData, "^", 5)
	...// 团体和个人ADM审核表 DHC_PE_PreAudit.{ PA_Status }
	...s PAStatus=$p($g(^DHCPEPreA(AuditId)),"^",21)
	...Q:("NU"=PAStatus) // U-Use有效 NU-NoUse无效
	...// DHC_PE_PreAudit.{ PA_ADMType } G-团体费用 I-个人费用
	...s ADMType=$p($g(^DHCPEPreA(AuditId)),"^",1)
	...s AdmTypes=AdmTypes_ADMType_"^" 
	...// DHC_PE_PreIOrdItemFee.{ PIOIF_FactAmount }
	...s FactAmount=$p(CurData,"^", 2)
	...s:("G"=ADMType) GFactAmount=GFactAmount+FactAmount
	...s:("I"=ADMType) IFactAmount=IFactAmount+FactAmount
	..
	..// 公费
	..s ^DHCPETMP("PGI","IADMs",piadmid,"Fee", "项目", ItmMastDesc, "GAmount")=GFactAmount
	..// 自费
	..s ^DHCPETMP("PGI","IADMs",piadmid,"Fee", "项目", ItmMastDesc, "IAmount")=IFactAmount
	..
	..// 公费加项
	..s:(AdmTypes["^G^")&(AdmTypes'["^I^") ^DHCPETMP("PGI","IADMs",piadmid,"Fee", "项目", ItmMastDesc, "FeeType")="公费"
	..// 自费加项
	..s:(AdmTypes'["^G^")&(AdmTypes["^I^") ^DHCPETMP("PGI","IADMs",piadmid,"Fee", "项目", ItmMastDesc, "FeeType")="自费"
	..// 公+自
	..s:(AdmTypes["^G^")&(AdmTypes["^I^") ^DHCPETMP("PGI","IADMs",piadmid,"Fee", "项目", ItmMastDesc, "FeeType")="公+自"
	..

	Q ""
}

Storage Default
{
<Data name="PreGADMInfostatisticDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCP.PreGADMInfostatisticD</DataLocation>
<DefaultData>PreGADMInfostatisticDefaultData</DefaultData>
<IdLocation>^web.DHCP.PreGADMInfostatisticD</IdLocation>
<IndexLocation>^web.DHCP.PreGADMInfostatisticI</IndexLocation>
<StreamLocation>^web.DHCP.PreGADMInfostatisticS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
