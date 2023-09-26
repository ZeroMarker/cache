Class web.DHCEQCheckData Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// 检测月结记录中是否平衡
/// 检测在用期初 变动 及期末
/// select MRL_EquipTypeDR,* from dhc_eqmonthreportlist where (mrl_usedbegin+mrl_usedin-mrl_disused-MRL_UsedReturn+MRL_UsedMoveIn-MRL_UsedMoveOut+MRL_ChangeAccount-MRL_UsedReduce+MRL_UsedOther)<>mrl_usedend and mrl_year=2012
/// 检测在库期初 变动 及期末
/// select * from dhc_eqmonthreportlist where (mrl_stockbegin+MRL_StockIn-MRL_StockReturn-MRL_StockReduce-MRL_StockMoveOut+MRL_StockMoveIn-MRL_StockDisused+MRL_StockChangeAccount+MRL_StockOther)<>mrl_stockend and mrl_year=2012
/// Add By JDL 2012-3-16
/// 检查月结报表与台帐数据是否一致
/// 入参：	MonthStr:月份 格式为"YYYY-MM"
/// 			IsSnap:"Y" 与快照比较  其他：与台帐比较
/// 			ShowType："" 是显示所有 "D" 是显示不同 
/// 	w ##Class(web.DHCEQCheckData).CheckMonthReportData("2012-02")
ClassMethod CheckMonthReportData(MonthStr, vEquipType As %String = "", IsSnap As %String = "Y", ShowType As %String = "D")
{
	n Year,Month,ErrDesc
	n EquipTypeDR,StatCatDR,LocDR,OriginDR,FundsTypeDR
	n SnapID
	n RowID,GblData,OriginalFee,NetFee,SumDepreTotalFee,ReportOriginalFee,ReportNetFee,SumReportDepreTotalFee
	n LocFlag,StatCatFlag,OriginFlag
	s LocFlag=1
	s StatCatFlag=1
	s OriginFlag=1
		
	s ErrDesc=""
	i MonthStr=""
	{
		s ErrDesc="月结月份不能为空!"
		q ErrDesc
	}
	s Year=+$p(MonthStr,"-",1)
	s Month=+$p(MonthStr,"-",2)
	
	s SnapID=""
	i IsSnap="Y"
	{
		s SnapID=##Class(web.DHCEQSnapShot).GetSnapIDByMonth(MonthStr)
		i SnapID=""
		{
			s ErrDesc="没有找到相对应的快照!"
			q ErrDesc
		}
	}
	
		
	;根据台帐或快照 分组汇总计算 原值及净值，并计算累计折旧总计
	k ^DHCEQTemp("DHCEQCheckData","CheckMonthReportData",MonthStr)
	s SumDepreTotalFee=0
	s RowID=0
	i SnapID=""  d
	.f  s RowID=$o(^DHCEQEquip(RowID))  quit:(RowID="")  d
	..s GblData=^DHCEQEquip(RowID)
	..d AddCheckMonthReportData
	e  d
	.f  s RowID=$o(^DHCEQSnapShot(SnapID,"Equip",RowID))  quit:(RowID="")  d
	..s GblData=^DHCEQSnapShot(SnapID,"Equip",RowID)
	..d AddCheckMonthReportData
	
	;根据月结  分组汇总计算 原值及净值，并计算累计折旧总计
	s SumReportDepreTotalFee=0
	s EquipTypeDR=0
	f  s EquipTypeDR=$o(^DHCEQMonthReportList(0,"TypeDate",EquipTypeDR)) q:EquipTypeDR=""  d
	.q:(vEquipType'="")&&(vEquipType'=EquipTypeDR)
	.s StatCatDR=0
	.f  s StatCatDR=$o(^DHCEQMonthReportList(0,"TypeDate",EquipTypeDR,Year,Month,StatCatDR)) q:StatCatDR=""  d
	..s LocDR=0
	..f  s LocDR=$o(^DHCEQMonthReportList(0,"TypeDate",EquipTypeDR,Year,Month,StatCatDR,LocDR)) q:LocDR=""  d
	...s RowID=0
	...f  s RowID=$o(^DHCEQMonthReportList(0,"TypeDate",EquipTypeDR,Year,Month,StatCatDR,LocDR,RowID)) q:RowID=""  d
	....s GblData=$g(^DHCEQMonthReportList(RowID))
	....s OriginDR=$p(GblData,"^",26)
	....;q:(FundsType'=$p(GblData,"^",38))
	....s StockEnd=+$p(GblData,"^",12)	///在库 上月期末为本月期初
	....s UsedEnd=+$p(GblData,"^",19)
	....
	....s LocNode=LocDR
	....s StatCatNode=StatCatDR
	....s OriginNode=OriginDR
	....
	....i LocFlag=0 s LocNode=0
	....i StatCatFlag=0 s StatCatNode=0
	....i OriginFlag=0 s OriginNode=0
	....;s (LocNode,StatCatNode,OriginNode)=0
	....
	....s StockEnd=+StockEnd+$p($g(^DHCEQTemp("DHCEQCheckData","CheckMonthReportData",MonthStr,"ReportListInfo",LocNode,EquipTypeDR,StatCatNode,OriginNode)),"^",1)
	....s UsedEnd=+UsedEnd+$p($g(^DHCEQTemp("DHCEQCheckData","CheckMonthReportData",MonthStr,"ReportListInfo",LocNode,EquipTypeDR,StatCatNode,OriginNode)),"^",2)
	....s SumReportDepreTotalFee=SumReportDepreTotalFee+$p(GblData,"^",28)
	....s NetFee=$p(GblData,"^",33)+$p($g(^DHCEQTemp("DHCEQCheckData","CheckMonthReportData",MonthStr,"ReportListInfo",LocNode,EquipTypeDR,StatCatNode,OriginNode)),"^",3)
	....s ^DHCEQTemp("DHCEQCheckData","CheckMonthReportData",MonthStr,"ReportListInfo",LocNode,EquipTypeDR,StatCatNode,OriginNode)=StockEnd_"^"_UsedEnd_"^"_NetFee
	
	;比对
	s OKCount=0
	s ErrCount=0
	s LocDR=""
	f  s LocDR=$o(^DHCEQTemp("DHCEQCheckData","CheckMonthReportData",MonthStr,"ReportListInfo",LocDR)) q:LocDR=""  d
	.s EquipTypeDR=""
	.f  s EquipTypeDR=$o(^DHCEQTemp("DHCEQCheckData","CheckMonthReportData",MonthStr,"ReportListInfo",LocDR,EquipTypeDR)) q:EquipTypeDR=""  d
	..q:(vEquipType'="")&&(vEquipType'=EquipTypeDR)
	..s StatCatDR=""
	..f  s StatCatDR=$o(^DHCEQTemp("DHCEQCheckData","CheckMonthReportData",MonthStr,"ReportListInfo",LocDR,EquipTypeDR,StatCatDR)) q:StatCatDR=""  d
	...s OriginDR=""
	...f  s OriginDR=$o(^DHCEQTemp("DHCEQCheckData","CheckMonthReportData",MonthStr,"ReportListInfo",LocDR,EquipTypeDR,StatCatDR,OriginDR)) q:OriginDR=""  d
	....s ReportData=$g(^DHCEQTemp("DHCEQCheckData","CheckMonthReportData",MonthStr,"ReportListInfo",LocDR,EquipTypeDR,StatCatDR,OriginDR))
	....s EquipData=$g(^DHCEQTemp("DHCEQCheckData","CheckMonthReportData",MonthStr,"EquipListInfo",LocDR,EquipTypeDR,StatCatDR,OriginDR))
	....
	....s Loc=##Class(web.DHCEQCommon).GetTrakNameByID("dept",LocDR)
	....s EquipType = $p($g(^DHCEQCCode("DHCEQCEquipType",EquipTypeDR)),"^",2)
	....s StatCat=$p($g(^DHCEQCCode("DHCEQCStatCat",StatCatDR)),"^",2)
	....s Origin=""
	....i OriginDR>0 s Origin=$p($g(^DHCEQCCode("DHCEQCOrigin",OriginDR)),"^",2)
	....
	....s StockEnd=+$p(EquipData,"^",1)
	....s UsedEnd=+$p(EquipData,"^",2)
	....s OriginalFee=StockEnd+UsedEnd
	....s NetFee=+$p(EquipData,"^",3)
	....s ReportStockEnd=+$p(ReportData,"^",1)
	....s ReportUsedEnd=+$p(ReportData,"^",2)
	....s ReportOriginalFee=ReportStockEnd+ReportUsedEnd
	....s ReportNetFee=+$p(ReportData,"^",3)
	....
	....s Info="EquipType="_EquipType
	....i LocDR>0 s Info=Info_",Loc="_LocDR
	....i StatCatDR>0 s Info=Info_",StatCat="_StatCat
	....i OriginDR>0 s Info=Info_",Origin="_Origin
	....
	....s ErrFlag=0
	....i ((+OriginalFee)'=(+ReportOriginalFee))  d
	.....w Info_"  报表全="_(+ReportOriginalFee)_" ; 台帐全="_(+OriginalFee)_";差="_(ReportOriginalFee-OriginalFee),!
	.....s ErrCount=ErrCount+1
	.....s ErrFlag=1
	....
	....q:ErrFlag=1
	....i ((+StockEnd)'=(+ReportStockEnd))||((+UsedEnd)'=(+ReportUsedEnd))  d
	.....
	.....w Info_"  报表库="_(+ReportStockEnd)_" ; 台帐库="_(+StockEnd)_";差="_(ReportStockEnd-StockEnd),!
	.....s ErrCount=ErrCount+1
	.....s ErrFlag=1
	....
	....q:ErrFlag=1
	....i ((+NetFee)'=(+ReportNetFee))  d
	.....w Info_"  报表净="_(+ReportNetFee)_" ; 台帐净="_(+NetFee)_";差="_(ReportNetFee-NetFee),!
	.....s ErrCount=ErrCount+1
	.....s ErrFlag=1
	....
	....q:ErrFlag=1
	....s OKCount=OKCount+1
	.....
	
	i SumReportDepreTotalFee'=SumDepreTotalFee
	{
		;累计折旧无法比较，由报废、退货、调整等原因
		;w "TotalDepreFee: Report="_SumReportDepreTotalFee_" ; Equip="_SumDepreTotalFee,!
	}
	w "ErrCount:"_ErrCount_"  OKCount:"_OKCount,!
	k ^DHCEQTemp("DHCEQCheckData","CheckMonthReportData")
	q "Finish"
AddCheckMonthReportData
	///出库状态、无效标志
	s StockStatus=$p(GblData,"^",60)
	;尚未入库的不计入
	q:(StockStatus="0")
	
	s CounterFlag="1"
	;其他退货、报废、无效的，不计入原值、数量，只计入折旧、累计折旧相关数据
	i (StockStatus="3") s CounterFlag="0"
	;过滤掉报废的
	s Status=$p(GblData,"^",38)
	i (Status>"2") s CounterFlag="0"
	;过滤掉无效的
	s InvalidFlag=$p(GblData,"^",59)
	i (InvalidFlag="Y") s CounterFlag="0"
	q:CounterFlag="0"
	
	;q:((UseLocDR'="")&&(UseLocDR'=$p(GblData,"^",67)))  ;库房
	;q:(EquipTypeDR="")&("1"=##Class(web.DHCEQCommon).EquipTypeIsIn($p(GblData,"^",63)))	;Mozy0070	2011-12-03
		
	s EquipTypeDR=$p(GblData,"^",63)
	q:(vEquipType'="")&&(vEquipType'=EquipTypeDR)
	i EquipTypeDR '=""  s EquipType = $p($g(^DHCEQCCode("DHCEQCEquipType",EquipTypeDR)),"^",2)	
	s StatCatDR=$p(GblData,"^",75)
	i StatCatDR'="" s StatCat=$p($g(^DHCEQCCode("DHCEQCStatCat",StatCatDR)),"^",2)
	s OriginDR=$p(GblData,"^",20)
	i OriginDR="" s OriginDR=0
	s LocDR=$p(GblData,"^",67)
		
	s LocNode=LocDR
	s StatCatNode=StatCatDR
	s OriginNode=OriginDR
	
	i LocFlag=0 s LocNode=0
	i StatCatFlag=0 s StatCatNode=0
	i OriginFlag=0 s OriginNode=0
	
	s StockEnd=+$p($g(^DHCEQTemp("DHCEQCheckData","CheckMonthReportData",MonthStr,"EquipListInfo",LocNode,EquipTypeDR,StatCatNode,OriginNode)),"^",1)
	s UsedEnd=+$p($g(^DHCEQTemp("DHCEQCheckData","CheckMonthReportData",MonthStr,"EquipListInfo",LocNode,EquipTypeDR,StatCatNode,OriginNode)),"^",2)
	i Status'="1"
	{	s StockEnd=$p(GblData,"^",27)+StockEnd	}
	else
	{	s UsedEnd=$p(GblData,"^",27)+UsedEnd }
	
	s SumDepreTotalFee=SumDepreTotalFee+$p(GblData,"^",35)
	s NetFee=$p(GblData,"^",28)+$p($g(^DHCEQTemp("DHCEQCheckData","CheckMonthReportData",MonthStr,"EquipListInfo",LocNode,EquipTypeDR,StatCatNode,OriginNode)),"^",3)
	
	s ^DHCEQTemp("DHCEQCheckData","CheckMonthReportData",MonthStr,"EquipListInfo",LocNode,EquipTypeDR,StatCatNode,OriginNode)=StockEnd_"^"_UsedEnd_"^"_NetFee
	
	q
}

}
