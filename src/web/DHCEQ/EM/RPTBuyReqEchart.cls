/// modified by ZY20221205 bug:2953788、2953980
/// Creator:add by ZY 2849911
/// CreateDate:2022-06-30
/// Descrition:采购申请分析图表
Class web.DHCEQ.EM.RPTBuyReqEchart Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// add by czf 2020-08-05
/// 效益分析首页图表
/// Input：
/// 	nodestr:临时global节点名，不同界面应用不用的nodestr
/// 	PeriodType:期间类型(YearFlag:年度 HalfYear:半年度 Quarter:季度 MonthFlag:月度)
/// 	ChartStr:界面要展示的图表串
/// "web.DHCEQ.EM.RPTBuyReqEchart_GetBuyRequestAnaly,16168,2022-01,2022-12,77,202,85,YearFlag,BuyReqStatus^BuyReqPurchaseType^BuyReqRequestLoc^BuyReqYearFlag^BuyReqStatusAnaly^BuyReqPurchaseTypeAnaly^BuyReqYearFlagAnaly^BuyReqLocAnaly^BuyReqInStockAnaly"
/// w ##Class(web.DHCEQ.EM.RPTBuyReqEchart).GetBuyRequestAnaly("web.DHCEQ.EM.RPTBuyReqEchart_GetBuyRequestAnaly","16168","2022-01","2022-12","77","202","85","YearFlag","BuyReqStatus^BuyReqPurchaseType^BuyReqRequestLoc^BuyReqYearFlag^BuyReqStatusAnaly^BuyReqPurchaseTypeAnaly^BuyReqYearFlagAnaly^BuyReqLocAnaly^BuyReqInStockAnaly")
ClassMethod GetBuyRequestAnaly(nodestr As %String = "", vJob As %String = "", vStartDate As %String = "", vEndDate As %String = "", vCurUserID As %String = "", vCurLocID As %String = "", vCurGroupID As %String = "", vPeriodType As %String = "", ChartStr As %String = "")
{
	s BuyReqInfo=##class(web.DHCEQ.Plat.JsonObject).%New()
	d ##class(web.DHCEQCommon).KillTempGlobal(nodestr)
	s Job=vJob
	i Job="" s Job=$J
	s Date=+$h
	
	i vCurUserID="" s vCurUserID=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	i vCurLocID="" s vCurLocID=##Class(web.DHCEQCommon).getMapIDBySource("dept",%session.Get("LOGON.CTLOCID"))
	i vCurGroupID="" s vCurGroupID=%session.Get("LOGON.GROUPID")
	
	i (vCurUserID="")||(vCurLocID="") Quit ""
	i (vStartDate="")||(vEndDate="") Quit ""
	i ($ZDH(vStartDate_"-01",3)>$ZDH(vEndDate_"-01",3)) Quit ""
	
	s StartDate=##Class(web.DHCEQReport).GetReportDate(vStartDate,1,"",0)
	s EndDate=##Class(web.DHCEQReport).GetReportDate(vEndDate,2,"",0)
	
	s (BuyRequestNum,BuyRequestReqNum,BuyRequestReqAmount,BuyRequestAuditNum,BuyRequestAuditAmount)=0
	
 	s TRequestLocDR=0
	f  s TRequestLocDR=$o(^DHCEQBuyRequest(0,"RequestLoc",TRequestLocDR))  quit:TRequestLocDR=""  d
 	.s rowid=0
	.f  s rowid=$o(^DHCEQBuyRequest(0,"RequestLoc",TRequestLocDR,rowid))  quit:rowid=""  d
	..s DataList=$g(^DHCEQBuyRequest(rowid))
	..q:$p(DataList,"^",45)="Y"
	..;s TRequestLocDR=$p(DataList,"^",2)
	..s TYearFlag=$p(DataList,"^",3)
	..;s TYearFlag=$CASE(TYearFlag,"Y":"年度计划","N":"日常计划","":"")  //add by lmm 2020-05-18 UI调整
	..s TUseLocDR=$p(DataList,"^",4)
	..;q:##class(web.DHCEQCommon).LocIsInEQ(QXType,TUseLocDR,CurLocID,CurGroupID)'=0
	..;s TUseLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept", TUseLocDR)
	..s TYear=$p(DataList,"^",5)
	..;q:(Year'="")&&(TYear'=Year)
	..s TRequestDate=$p(DataList,"^",6)
    ..q:(TRequestDate>EndDate)||(TRequestDate<StartDate)
	..;s TRequestDate=##Class(web.DHCEQCommon).TransValueToPage(TRequestDate,"date")
	..s TStatusDR=$p(DataList,"^",16)
	..;s TStatus=##Class(web.DHCEQCommon).GetEditStatusDisplay(TStatusDR)
	..s TManageLocDR=$p(DataList,"^",18)
	..;q:(CurLocID'="")&&(TManageLocDR'=CurLocID)
	..;s TManageLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept", TManageLocDR)
	..s TEquipTypeDR=$p(DataList,"^",25)
	..//q:(Flag'="")&&(EquipTypeValues'[(","_TEquipTypeDR_","))
	..//q:(##Class(web.DHCEQCommon).EquipTypeIsIn(TEquipTypeDR))
	..;s TEquipType=##Class(web.DHCEQCommon).GetTrakNameByID("equiptype", TEquipTypeDR)
	..s TPurchaseTypeDR=$p(DataList,"^",26)
	..;i TPurchaseTypeDR'="" s TPurchaseType=$p($g(^DHCEQCCode("DHCEQCPurchaseType",TPurchaseTypeDR)),"^",2)
	..s THold1=$p(DataList,"^",17)
	..s TQuantityNum=$p(DataList,"^",8)
	..s TTotalFee=$p(DataList,"^",9)
	..
	..s (tmpBuyRequestAuditNum,tmpBuyRequestAuditAmount)=0
 	..s mxrowid=0
	..f  s mxrowid=$o(^DHCEQBuyRequestList(mxrowid))  quit:mxrowid=""  d
	...s MXDatalist=$g(^DHCEQBuyRequestList(mxrowid))
	...s (TApproveNum,TPrice,TAmount)=""
	...s TRequestNum=$p(MXDatalist,"^",20)
	...s TPrice=$p(MXDatalist,"^",36)
	...s (BRAIRowID,TApproveNum)=""
	...s BRAIStep=$o(^DHCEQBuyReqAuditInfo(0,"BuyRequestListStep",mxrowid,""),-1)
	...i BRAIStep'="" s BRAIRowID=$o(^DHCEQBuyReqAuditInfo(0,"BuyRequestListStep",mxrowid,BRAIStep,0))
	...i BRAIRowID'="" d
	....s TApproveNum=$Piece($g(^DHCEQBuyReqAuditInfo(BRAIRowID)),"^",4)
	....s TPrice=$Piece($g(^DHCEQBuyReqAuditInfo(BRAIRowID)),"^",5)
	....s TAmount=$Piece($g(^DHCEQBuyReqAuditInfo(BRAIRowID)),"^",6)
	...s TPrice=##Class(web.DHCEQCommon).FormatNumber(TPrice,"")
	...s TAmount=##Class(web.DHCEQCommon).FormatNumber(TAmount,"")
	...s tmpBuyRequestAuditNum=tmpBuyRequestAuditNum+TApproveNum
	...s tmpBuyRequestAuditAmount=tmpBuyRequestAuditAmount+TAmount
	..
	..s BuyRequestNum=BuyRequestNum+1
	..s BuyRequestReqNum=BuyRequestReqNum+TQuantityNum
	..s BuyRequestReqAmount=BuyRequestReqAmount+TTotalFee
	..
	..s BuyRequestAuditNum=BuyRequestAuditNum+tmpBuyRequestAuditNum
	..s BuyRequestAuditAmount=BuyRequestAuditAmount+tmpBuyRequestAuditAmount
	..
	..s str=$g(^DHCEQTemp(nodestr,"BuyReqStatus",Date,Job,vCurUserID,TStatusDR))
	..s $p(str,"^",1)=+$p(str,"^",1)+1
	..s $p(str,"^",2)=+$p(str,"^",2)+TQuantityNum
	..s $p(str,"^",3)=+$p(str,"^",3)+TTotalFee
	..s $p(str,"^",4)=+$p(str,"^",4)+tmpBuyRequestAuditNum
	..s $p(str,"^",5)=+$p(str,"^",5)+tmpBuyRequestAuditAmount
	..s ^DHCEQTemp(nodestr,"BuyReqStatus",Date,Job,vCurUserID,TStatusDR)=str
	..
	..s str=$g(^DHCEQTemp(nodestr,"BuyReqPurchaseType",Date,Job,vCurUserID,TPurchaseTypeDR))
	..s $p(str,"^",1)=+$p(str,"^",1)+1
	..s $p(str,"^",2)=+$p(str,"^",2)+TQuantityNum
	..s $p(str,"^",3)=+$p(str,"^",3)+TTotalFee
	..s $p(str,"^",4)=+$p(str,"^",4)+tmpBuyRequestAuditNum
	..s $p(str,"^",5)=+$p(str,"^",5)+tmpBuyRequestAuditAmount
	..s ^DHCEQTemp(nodestr,"BuyReqPurchaseType",Date,Job,vCurUserID,TPurchaseTypeDR)=str
	..
	..s str=$g(^DHCEQTemp(nodestr,"BuyReqRequestLoc",Date,Job,vCurUserID,TRequestLocDR))
	..s $p(str,"^",1)=+$p(str,"^",1)+1
	..s $p(str,"^",2)=+$p(str,"^",2)+TQuantityNum
	..s $p(str,"^",3)=+$p(str,"^",3)+TTotalFee
	..s $p(str,"^",4)=+$p(str,"^",4)+tmpBuyRequestAuditNum
	..s $p(str,"^",5)=+$p(str,"^",5)+tmpBuyRequestAuditAmount
	..s ^DHCEQTemp(nodestr,"BuyReqRequestLoc",Date,Job,vCurUserID,TRequestLocDR)=str
	..
	..s str=$g(^DHCEQTemp(nodestr,"BuyReqYearFlag",Date,Job,vCurUserID,TYearFlag))
	..s $p(str,"^",1)=+$p(str,"^",1)+1
	..s $p(str,"^",2)=+$p(str,"^",2)+TQuantityNum
	..s $p(str,"^",3)=+$p(str,"^",3)+TTotalFee
	..s $p(str,"^",4)=+$p(str,"^",4)+tmpBuyRequestAuditNum
	..s $p(str,"^",5)=+$p(str,"^",5)+tmpBuyRequestAuditAmount
	..s ^DHCEQTemp(nodestr,"BuyReqYearFlag",Date,Job,vCurUserID,TYearFlag)=str
	
	//s BuyReqTotalInfo=BuyRequestNum_"^"_BuyRequestReqNum_"^"_BuyRequestReqAmount_"^"_BuyRequestAuditNum_"^"_BuyRequestAuditAmount
	
	;卡片信息
	s Node="BuyReqStatus"
	d BuyRequestCardInfo
    i (("^"_ChartStr_"^")["^BuyReqStatus^") d ##Class(web.DHCEQ.Plat.CTChartsDefine).CreateChartsData("BuyReqStatus","","","","",htmlstr,BuyReqInfo)
    i (("^"_ChartStr_"^")["^BuyReqStatusAnaly^") d ##Class(web.DHCEQ.Plat.CTChartsDefine).CreateChartsData("BuyReqStatusAnaly",legendDataDR,legendData,"0","状态信息",SeriesData,BuyReqInfo)
	
	s Node="BuyReqPurchaseType"
	d BuyRequestCardInfo
    i (("^"_ChartStr_"^")["^BuyReqPurchaseType^") d ##Class(web.DHCEQ.Plat.CTChartsDefine).CreateChartsData("BuyReqPurchaseType","","","","",htmlstr,BuyReqInfo)
    i (("^"_ChartStr_"^")["^BuyReqPurchaseTypeAnaly^") d ##Class(web.DHCEQ.Plat.CTChartsDefine).CreateChartsData("BuyReqPurchaseTypeAnaly",legendDataDR,legendData,"0","申购类别",SeriesData,BuyReqInfo)
	
	s Node="BuyReqRequestLoc"
	d BuyRequestCardInfo
    i (("^"_ChartStr_"^")["^BuyReqRequestLoc^") d ##Class(web.DHCEQ.Plat.CTChartsDefine).CreateChartsData("BuyReqRequestLoc","","","","",htmlstr,BuyReqInfo)
    i (("^"_ChartStr_"^")["^BuyReqLocAnaly^") d ##Class(web.DHCEQ.Plat.CTChartsDefine).CreateChartsData("BuyReqLocAnaly","0","科室申请统计",legendDataDR,legendData,SeriesData,BuyReqInfo)
	
    i (("^"_ChartStr_"^")["^BuyReqLocAnalyNum^") d ##Class(web.DHCEQ.Plat.CTChartsDefine).CreateChartsData("BuyReqLocAnalyNum","1","数量",legendDataDR,legendData,SeriesData,BuyReqInfo)
	
    i (("^"_ChartStr_"^")["^BuyReqLocAnalyAmount^") d ##Class(web.DHCEQ.Plat.CTChartsDefine).CreateChartsData("BuyReqLocAnalyAmount","2","金额",legendDataDR,legendData,SeriesDataAmount,BuyReqInfo)
	
    i (("^"_ChartStr_"^")["^BuyReqLocAnalyNumAmount^") d ##Class(web.DHCEQ.Plat.CTChartsDefine).CreateChartsData("BuyReqLocAnalyNumAmount","1^2","数量^金额",legendDataDR,legendData,SeriesDataNumAmount,BuyReqInfo)
	
	
	s Node="BuyReqYearFlag"
	d BuyRequestCardInfo
    i (("^"_ChartStr_"^")["^BuyReqYearFlag^") d ##Class(web.DHCEQ.Plat.CTChartsDefine).CreateChartsData("BuyReqYearFlag","","","","",htmlstr,BuyReqInfo)
    i (("^"_ChartStr_"^")["^BuyReqYearFlagAnaly^") d ##Class(web.DHCEQ.Plat.CTChartsDefine).CreateChartsData("BuyReqYearFlagAnaly",legendDataDR,legendData,"0","计划类型",SeriesData,BuyReqInfo)
	
	s Node="BuyReqInStockAnaly"
	d BuyRequestCardInfo
    //i (("^"_ChartStr_"^")["^BuyReqInStockAnaly^") d ##Class(web.DHCEQ.Plat.CTChartsDefine).CreateChartsData("BuyReqInStockAnaly","","","","",htmlstr,BuyReqInfo)
	
	
	d ##Class(web.DHCEQ.Plat.CTChartsDefine).CreateChartsData("BuyReqInStockAnaly","0","历史采购数量统计",legendDataDR,legendData,SeriesData,BuyReqInfo)
	
	q BuyReqInfo
	q BuyReqInfo.%ToJSON()
	
BuyRequestCardInfo

	s SeriesData=##class(web.DHCEQ.Plat.JsonObject).%New()
	s SeriesDataAmount=##class(web.DHCEQ.Plat.JsonObject).%New()
	s SeriesDataNumAmount=##class(web.DHCEQ.Plat.JsonObject).%New()
	s (legendDataDR,legendData,htmlstr)=""
	
	s row=0
	s htmlstr=""
	s vrowid=0
	f  s vrowid=$o(^DHCEQTemp(nodestr,Node,Date,Job,vCurUserID,vrowid)) q:(vrowid="")||(row>15)  d
	.s DataStr=$g(^DHCEQTemp(nodestr,Node,Date,Job,vCurUserID,vrowid))
	.s (Count,QuantityNum,TotalFee)=0
	.s Count=$p(DataStr,"^",1)
	.s QuantityNum=$p(DataStr,"^",2)
	.s TotalFee=$p(DataStr,"^",3)
	.s vrowidDesc=""
	.i Node="BuyReqStatus"  d
	..s vrowidDesc=##Class(web.DHCEQCommon).GetEditStatusDisplay(vrowid)
	..d SeriesData.%Set(vrowid_"-0",Count)
	.e  i Node="BuyReqPurchaseType"  d
	..s vrowidDesc=##Class(web.DHCEQCommon).GetTrakNameByID("purchase", vrowid)
	..d SeriesData.%Set(vrowid_"-0",Count)
	.e  i Node="BuyReqRequestLoc"  d
	..s vrowidDesc=##Class(web.DHCEQCommon).GetTrakNameByID("dept", vrowid)
	..d SeriesData.%Set("1-"_vrowid,QuantityNum)
	..
	..d SeriesDataAmount.%Set("2-"_vrowid,TotalFee)	//金额
	..d SeriesDataNumAmount.%Set("1-"_vrowid,QuantityNum)
	..d SeriesDataNumAmount.%Set("2-"_vrowid,TotalFee)
	..
	..
	.e  i Node="BuyReqYearFlag"  d
	..s vrowidDesc=$CASE(vrowid,"Y":"年度计划","N":"日常计划",:"")
	..d SeriesData.%Set(vrowid_"-0",Count)
	.
	.i legendDataDR=""  d
	..s legendDataDR=vrowid
	..s legendData=vrowidDesc
	.e  d
	..s legendDataDR=legendDataDR_"^"_vrowid
	..s legendData=legendData_"^"_vrowidDesc
	.
	.
	.s curstr="<div><span style='width:30%'>"_vrowidDesc_":"_Count_"条</span><span style='width:30%'>设备数量:"_QuantityNum_"</span><span style='width:38%'>总金额:"_TotalFee_"</span></div>"	// MZY0144	3070859		2022-11-24
	.i htmlstr=""  d
	..s htmlstr=curstr
	.e  d
	..s htmlstr=htmlstr_curstr
	quit
}

}
