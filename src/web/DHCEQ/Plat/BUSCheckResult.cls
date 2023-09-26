/// modified by zy0278 2021-08-26  界面输出列修改
/// add by zy 2014-08-07  ZY0116
/// 这个类文件中的方法是用于检测月结报表和折旧报表结果.
/// 两个方法如下:
/// CheckMonthReport  检测某个月的月报结果 
/// 执行方法w ##class(web.DHCEQ.Plat.BUSCheckResult).CheckMonthReport("2021-07")
///   
/// CheckDepreReport  检测折旧报表的折旧金额
/// 
/// 检测时,需要检测的数据golable节点设置应该如下:
/// ^DHCEQTemp("CheckResult",Job,Node,EquipTypeID,StatCatID,StoreLocID,FundsTypeID,OriginID)
///       Job      		$j,是待检测报表中的进程。
///       Node			节点字符串
///       EquipTypeID	类组,如果报表中没有类组汇总的条件,设置值为0
///       StatCatID	    类型,如果报表中没有类型汇总的条件,设置值为0
///       StoreLocID	科室,如果报表中没有科室汇总的条件,设置值为0
///       FundsTypeID	资金来源,如果报表中没有资金来源汇总的条件,设置值为0
///       OriginID		设备来源,如果报表中没有设备来源汇总的条件,设置值为0
Class web.DHCEQ.Plat.BUSCheckResult Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// modified by ZY0293 2022-02-09 增加检测当前时间月份的数据
/// 检测当前月报的快照,出一份结果和月报表中的数据进行比较
/// 入参：	MonthStr:月份 格式为"YYYY-MM"
/// 			ReportType："" 是不分实物和财务月结 "0" 是实物月结  1,是财务月结 
/// w ##class(web.DHCEQ.Plat.BUSCheckResult).CheckMonthReport("2022-02")
ClassMethod CheckMonthReport(MonthStr, ReportType As %String = "")
{
	new SQLCODE,Year,Month,Job,SnapID,PreSnapID,EquipID,DataList
	new EquipTypeID,StatCatID,StoreLocID,FundsTypeID,OriginID
	
	s SQLCODE=0
	s Year =$p(MonthStr,"-",1)
	s Month=$p(MonthStr,"-",2)
	/// modified by ZY0293 2022-02-09
	//i '$Data(^DHCEQMonthReportList(0,"YearMonth",Year,+Month)) quit ""
	s Job=$j
	k ^DHCEQTemp("CheckResult",Job)
	
	//modified by zy  添加
	//目前是直接取当前月的快照，重新统计数据。之后和月结报表的数据进行比较。取上月的快照ID没有用,只是看看是否存在
	//s PreSnapID=SnapID-1
	//if '$Data(^DHCEQSnapShot(PreSnapID,"Equip")) quit ""	//缺少前一个后面的快照不出结果
	/// modified by ZY0293 2022-02-09
	//找到前后两个快照的ID,通过比较两个快照来出期初和期末结果,先比较期初和期末,如果没问题,就认为数据正确.
	s (SnapID,PreSnapID)=""
	//指定的会计周期的第一天才能取到ID
	s SnapID=##Class(web.DHCEQSnapShot).GetSnapIDByMonth(MonthStr)
	if (SnapID'="")
	{
		//统计快照的结果
		s EquipID=0
		f  s EquipID=$o(^DHCEQSnapShot(SnapID,"Equip",EquipID))  quit:EquipID=""  d
		.s DataList=$g(^DHCEQSnapShot(SnapID,"Equip",EquipID))
		.d BuildDataList
	}else
	{
		if (MonthStr=$p($ZD(+$H,3),"-",1,2))
		{
			//统计台帐的结果
			s EquipID=0
			f  s EquipID=$o(^DHCEQEquip(EquipID))  quit:EquipID=""  d
			.s DataList=$g(^DHCEQEquip(EquipID))
			.d BuildDataList
		}
		else
		{
			q ""
		}
	}
	
	s ReportNode="ReportData"
	d ##class(web.DHCEQ.Plat.BUSCheckResult).SumMonthReportData(Job,ReportNode,Year,Month,ReportType)
	
	s SourceName="月报结果"
	i ReportType=0 d
	.s SourceName="实物月报结果"
	e  i ReportType=1 d
	.s SourceName="财务月报结果"
	
	s SQLCODE=##class(web.DHCEQ.Plat.BUSCheckResult).SaveCheckResult("0",SourceName,"",MonthStr,MonthStr,MonthStr,Job,ReportNode,CheckNode)
	k ^DHCEQTemp("CheckResult",Job)
 	q SQLCODE
 	
 	
BuildDataList	
	s (StatCatDR,EquipTypeDR,Status,StoreLocDR,InvalidFlag,OriginDR,StockStatus)=""
	s (OriginalFee,ChangeFee,DepreTotalFee,EndFee,DepreFee,DepreTotalFee)=0
	s OriginID =+$p(DataList,"^",20)
	s Status = $p(DataList,"^",38)
	quit:Status>"2"	//不是本月报废数据,不统计
	s InvalidFlag = $p(DataList,"^",59)
	quit:InvalidFlag="Y"	//无效数据
	s StockStatus = $p(DataList,"^",60)
	quit:(StockStatus="0")||(StockStatus="3")	//验收未入库
	s EquipTypeID = $p(DataList,"^",63)
	s StoreLocID  = $p(DataList,"^",67)
	s StatCatID = $p(DataList,"^",75)
	s OriginalFee = +$p(DataList,"^",27)
	;s DepreFee=$o(^DHCEQMonthDepre(0,"EquipMonth",rowid,MonthStr,0))
	;i DepreFee'="" s DepreFee=$p($g(^DHCEQMonthDepre(DepreFee)),"^",14)
	s DepreTotalFee = $p(DataList,"^",35)
	if (SnapID'="")
	{
		s CheckNode="SnapData"
		s rowid=0
		f  s rowid=$o(^DHCEQSnapShot(SnapID,"Funds",EquipID,rowid)) quit:rowid=""  d
		.s FundsData=$g(^DHCEQSnapShot(SnapID,"Funds",EquipID,rowid))
		.d BuildFundsDataList
	}
	else
	{
		s CheckNode="EquipData"
		s rowid=0
		f  s rowid=$o(^DHCEQFunds(0,"Equip",EquipID,rowid)) quit:rowid=""  d
		.s FundsData=$g(^DHCEQFunds(rowid))
		.d BuildFundsDataList
	}
 	
BuildFundsDataList
	quit:(($p(FundsData,"^",6)="2")||($p(FundsData,"^",10)="Y"))	//F_InvalidFlag||F_OperFlag
	s FundsTypeID=$p(FundsData,"^",2)
	s FundsFee=$p(FundsData,"^",3)
	s FundsDepreTotalFee=$p(FundsData,"^",13)
	s FinaceItemID=+$p(FundsData,"^",20)
	s FunctionCatID=+$p(FundsData,"^",21)
	i FundsDepreTotalFee>FundsFee s FundsDepreTotalFee=FundsFee		//特例:某些医院存在累计折旧大于原值数据
	s FundsNetFee=FundsFee-FundsDepreTotalFee
	i FundsNetFee<0 s FundsNetFee=0
	d ##class(web.DHCEQ.Plat.BUSCheckResult).SetSumDataFeeGolable(Job,CheckNode,EquipTypeID,StatCatID,StoreLocID,FundsTypeID,OriginID,FinaceItemID,FunctionCatID,FundsFee,FundsNetFee,0,FundsDepreTotalFee,0)
}

/// 检测折旧报表的折旧金额
/// 报表输出的同时，检测程序也执行一遍出一个结果，把检查的结果跟报表数据人工进行比较。
/// input:   
/// 				Start    		统计开始时间
/// 				End    	 		统计结束时间
/// 				Node     		节点字符串   ^DHCEQTemp("CheckResult",Job,Node,EquipTypeID,StatCatID,StoreLocID,FundsTypeID,OriginID)
/// 				EquipTypeIDS    可访问的类组窜
/// 				UseLocDR    	科室ID
/// 				IsMainFlag    	是否是主折旧
/// 				FlagStr    		标记EquipTypeID,StatCatID,StoreLocID,FundsTypeID,OriginID那几个是统计要求的节点。"Y^N^Y^Y^Y"
/// 
/// 
/// ^DHCEQTemp("CheckResult",Job,Node,EquipTypeID,StatCatID,StoreLocID,FundsTypeID,OriginID)
/// 
/// w ##class(web.DHCEQ.Plat.BUSCheckResult).CheckDepreReport(+$h-40,+$h,"DD",1,"^1^2^3^4^5^6^7^8^9^","","Y","Y^Y^Y^Y^Y")
ClassMethod CheckDepreReport(Start, End, Node, Job, EquipTypeIDS As %Library.String = "", UseLocDR As %Library.String = "", IsMainFlag As %Library.String = "Y", FlagStr As %Library.String = "")
{
	new SelfFundsFlag,LocID,auditdate,rowid,depredata,equipid
	new EquipTypeID,StatCatID,StoreLocID,FundsTypeID,OriginID
	new EquipTypeFlag,StatCatFlag,StoreLocFlag,FundsTypeFlag,OriginFlag
	
	s SelfFundsFlag=##class(web.DHCEQCommon).GetSysInfo("990015")
	s LocID=0
	f  s LocID=$o(^DHCEQMonthDepre(0,"Loc",LocID))  quit:LocID=""  d
	.q:((UseLocDR'="")&&(UseLocDR'=LocID))
	.s auditdate=Start
	.f  s auditdate=$o(^DHCEQMonthDepre(0,"Loc",LocID,auditdate))  quit:((auditdate="")||(auditdate>End))  d
	..s StoreLocID=LocID
	..s rowid=0
	..f  s rowid=$o(^DHCEQMonthDepre(0,"Loc",LocID,auditdate,rowid))  quit:((rowid=""))  d
	...s depredata=$g(^DHCEQMonthDepre(rowid))
	...q:($p(depredata,"^",3)'=IsMainFlag)
	...s MDStatus=$p($g(^DHCEQMonthDepre(rowid)),"^",20)	//DJ0136
	...q:MDStatus="3"
	...s equipid=$p(depredata,"^",1)
	...s EquipTypeID=$p($g(^DHCEQEquip(equipid)),"^",63)
	...s OriginID=+$p($g(^DHCEQEquip(equipid)),"^",20)
	...s StatCatID=$p($g(^DHCEQEquip(equipid)),"^",75)
	...s DepreFee=$p(depredata,"^",14)
	...s CADFlag=0
	...s CADRowID=0
	...f  s CADRowID=$o(^DHCEQCostAllotDetail(0,"SourceID",rowid,CADRowID)) q:CADRowID=""  d
	....s CADFlag=CADFlag+1
	....s CurUseLocDR=$p($g(^DHCEQCostAllotDetail(CADRowID)),"^",3)
	....q:((UseLocDR'="")&&(UseLocDR'=CurUseLocDR))
	....s DepreFee=$p($g(^DHCEQCostAllotDetail(CADRowID)),"^",5)
	....s FundsTypeID=$p($g(^DHCEQCostAllotDetail(CADRowID)),"^",7)
	....i FundsTypeID="" s FundsTypeID=SelfFundsFlag
	....s StoreLocID=CurUseLocDR
	....s flag=0
	....d SetNodeValueByFlag
	....quit:flag'=0
	....d ##class(web.DHCEQ.Plat.BUSCheckResult).SetSumDataFeeGolable(Job,"MonthDepreData",EquipTypeID,StatCatID,StoreLocID,FundsTypeID,OriginID,0,0,DepreFee,0,0)
	...i CADFlag=0  d
	....s FundsTypeID=SelfFundsFlag
	....s flag=0
	....d SetNodeValueByFlag
	....quit:flag'=0
	....d ##class(web.DHCEQ.Plat.BUSCheckResult).SetSumDataFeeGolable(Job,"MonthDepreData",EquipTypeID,StoreLocID,StoreLocID,FundsTypeID,OriginID,0,0,DepreFee,0,0)
	
	s SQLCODE=##class(web.DHCEQ.Plat.BUSCheckResult).SaveCheckResult("1","",Job,Node,"MonthDepreData")
	k ^DHCEQTemp("CheckResult",Job)
 	q SQLCODE
 	
SetNodeValueByFlag
	if FlagStr=""
	{
		s flag=1
		quit
	}
	s EquipTypeFlag=$p(FlagStr,"^",1)
	s StatCatFlag=$p(FlagStr,"^",2)
	s StoreLocFlag=$p(FlagStr,"^",3)
	s FundsTypeFlag=$p(FlagStr,"^",4)
	s OriginFlag=$p(FlagStr,"^",5)
	
	i EquipTypeFlag="Y"  d
	.s EquipTypeID=0
	.s EquipTypeIDS=""
	if (EquipTypeIDS'="")&&(EquipTypeIDS'[("^"_EquipTypeID_"^"))
	{
		s flag=1
		quit
	}
	i StatCatFlag="Y" s StatCatID=0
	i StoreLocFlag="Y" s StoreLocID=0
	i OriginFlag="Y" s OriginID=0
	i FundsTypeFlag="Y" s FundsTypeID=0
	quit
}

/// w ##class(web.DHCEQ.Plat.BUSCheckResult).SumMonthReportData(Job,Year,Month)
ClassMethod SumMonthReportData(Job, Node, Year, Month, ReportType As %String = "0")
{
	/// modified by ZY0293 2022-02-09
	i '$Data(^DHCEQMonthReportList(0,"Loc",Year,+Month))
	{
		;尚未月结的月份则，到业务表中获取
 		s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
		s StartDate=##Class(web.DHCEQReport).GetReportDate(Year_"-"_Month,"","")
		s EndDate=$p(StartDate,"^",2)
		s StartDate=$p(StartDate,"^",1)
		d ##class(web.DHCEQReport).FillStatListInfo(User,Year,+Month,StartDate,EndDate,"","",ReportType)
		s EquipTypeID=0
		f  s EquipTypeID=$o(^DHCEQTemp("MonthReport","List",User,Job,Year,Month,EquipTypeID)) q:EquipTypeID=""  d
		.s StoreLocID=0
		.f  s StoreLocID=$o(^DHCEQTemp("MonthReport","List",User,Job,Year,Month,EquipTypeID,StoreLocID)) q:StoreLocID=""  d
		..
		..s StatCatID=0
		..f  s StatCatID=$o(^DHCEQTemp("MonthReport","List",User,Job,Year,Month,EquipTypeID,StoreLocID,StatCatID)) q:StatCatID=""  d
		...
		...s OriginID=""
		...f  s OriginID=$o(^DHCEQTemp("MonthReport","List",User,Job,Year,Month,EquipTypeID,StoreLocID,StatCatID,OriginID)) q:OriginID=""  d
		....
		....s FundsTypeID=""
		....f  s FundsTypeID=$o(^DHCEQTemp("MonthReport","List",User,Job,Year,Month,EquipTypeID,StoreLocID,StatCatID,OriginID,FundsTypeID)) q:FundsTypeID=""  d
		.....
		.....s FinaceItemID=""
		.....f  s FinaceItemID=$o(^DHCEQTemp("MonthReport","List",User,Job,Year,Month,EquipTypeID,StoreLocID,StatCatID,OriginID,FundsTypeID,FinaceItemID)) q:FinaceItemID=""  d
		.....
		......s FunctionCatID=""
		......f  s FunctionCatID=$o(^DHCEQTemp("MonthReport","List",User,Job,Year,Month,EquipTypeID,StoreLocID,StatCatID,OriginID,FundsTypeID,FinaceItemID,FunctionCatID)) q:FunctionCatID=""  d
		.......
		.......s ListInfo=$g(^DHCEQTemp("MonthReport","List",User,Job,Year,Month,EquipTypeID,StoreLocID,StatCatID,OriginID,FundsTypeID,FinaceItemID,FunctionCatID))
		.......
		.......s FundsFee=+$p(ListInfo,"^",7)+$p(ListInfo,"^",14)
		.......s FundsDepreTotalFee=+$p(ListInfo,"^",16)
		.......s FundsNetFee=+$p(ListInfo,"^",21)
		.......d ##class(web.DHCEQ.Plat.BUSCheckResult).SetSumDataFeeGolable(Job,Node,EquipTypeID,StatCatID,StoreLocID,FundsTypeID,OriginID,FinaceItemID,FunctionCatID,FundsFee,FundsNetFee,0,FundsDepreTotalFee,0)
	}
	else
	{
		//统计报表的结果
		s EquipTypeID=0
		f  s EquipTypeID=$o(^DHCEQMonthReportList(0,"TypeDate",EquipTypeID))  quit:EquipTypeID=""  d
		.s StatCatID=0
		.f  s StatCatID=$o(^DHCEQMonthReportList(0,"TypeDate",EquipTypeID,Year,+Month,StatCatID)) quit:StatCatID=""  d
		..s StoreLocID=0
		..f  s StoreLocID=$o(^DHCEQMonthReportList(0,"TypeDate",EquipTypeID,Year,+Month,StatCatID,StoreLocID)) quit:StoreLocID=""  d
		...s MRLRowID=0
		...f  s MRLRowID=$o(^DHCEQMonthReportList(0,"TypeDate",EquipTypeID,Year,+Month,StatCatID,StoreLocID,MRLRowID)) quit:MRLRowID=""  d
		....s ListInfo=$g(^DHCEQMonthReportList(MRLRowID))
		....q:+ReportType'=+$p(ListInfo,"^",46)	//ReportType	//0:实物月结 1,财务月结
		....s OriginID=+$p(ListInfo,"^",26)
		....s FundsTypeID=$p(ListInfo,"^",38)
		....s FinaceItemID=+$p(ListInfo,"^",41)	//FinaceItemDR
		....s FunctionCatID=+$p(ListInfo,"^",42)	//FunctionCatDR
		....s FundsFee=+$p(ListInfo,"^",12)+$p(ListInfo,"^",19)
		....s FundsDepreTotalFee=+$p(ListInfo,"^",28)
		....s FundsNetFee=+$p(ListInfo,"^",33)
		....d ##class(web.DHCEQ.Plat.BUSCheckResult).SetSumDataFeeGolable(Job,Node,EquipTypeID,StatCatID,StoreLocID,FundsTypeID,OriginID,FinaceItemID,FunctionCatID,FundsFee,FundsNetFee,0,FundsDepreTotalFee,0)
	}
}

/// 累计计算临时golable的值
/// w ##class(web.DHCEQ.Plat.BUSCheckResult).SetSumDataFeeGolable(1,"ZY",1,2,3,4,5,6,7,8,9,10)
ClassMethod SetSumDataFeeGolable(Job, Node, EquipTypeID, StatCatID, StoreLocID, FundsTypeID, OriginID, FinaceItemID, FunctionCatID, OriginalFee, NetFee, DepreFee, DepreTotalFee, Other)
{
	new SumDateList
	i (Job="")||(Node="")||(EquipTypeID="")||(StatCatID="")||(StoreLocID="")||(FundsTypeID="")||(OriginID="")||(FinaceItemID="")||(FunctionCatID="") quit 
	s SumDateList =$g(^DHCEQTemp("CheckResult",Job,Node,EquipTypeID,StatCatID,StoreLocID,FundsTypeID,OriginID,FinaceItemID,FunctionCatID))
	s $p(SumDateList,"^",1)=+$p(SumDateList,"^",1)+OriginalFee
	s $p(SumDateList,"^",2)=+$p(SumDateList,"^",2)+NetFee
	s $p(SumDateList,"^",3)=+$p(SumDateList,"^",3)+DepreFee
	s $p(SumDateList,"^",4)=+$p(SumDateList,"^",4)+DepreTotalFee
	s $p(SumDateList,"^",5)=+$p(SumDateList,"^",5)+Other
	s ^DHCEQTemp("CheckResult",Job,Node,EquipTypeID,StatCatID,StoreLocID,FundsTypeID,OriginID,FinaceItemID,FunctionCatID)=SumDateList
	quit
}

/// /("0","月报结果","",MonthStr,MonthStr,MonthStr,Job,"ReportData","SnapData")
/// w ##class(web.DHCEQ.Plat.BUSCheckResult).SaveCheckResult(SourceType,SourceName,QueryName,StrMonth,EndMonth,QueryPara,Job, ReportData, CheckData)
ClassMethod SaveCheckResult(SourceType, SourceName, QueryName, StrMonth, EndMonth, QueryPara, Job, ReportData, CheckData)
{
	new CheckResultID,Result,SQLCODE,Flag
	TSTART
	s CheckResultID=##class(web.DHCEQ.Plat.BUSCheckResult).InsertCheckResult(SourceType,SourceName,QueryName,StrMonth,EndMonth,QueryPara)
	i CheckResultID'>0
	{
		TROLLBACK
		q CheckResultID
	}
	s Result=##class(web.DHCEQ.Plat.BUSCheckResult).InsertCheckResultList(CheckResultID,Job,ReportData,CheckData)
	i $p(Result,"^",1)'=0
	{
		TROLLBACK
		q Result
	}
	s Flag=$p(Result,"^",2)
	&SQL(update  sqluser.DHC_EQCheckResult set CR_Status=:Flag where CR_RowID=:CheckResultID)
	i SQLCODE=100 s SQLCODE=0
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}
	TCOMMIT
 	q SQLCODE
}

/// w ##class(web.DHCEQ.Plat.BUSCheckResult).InsertCheckResult()
ClassMethod InsertCheckResult(SourceType, SourceName, QueryName, StrMonth, EndMonth, QueryPara)
{
	new Date,curuser,CR,SQLCODE
	s Date=+$H
	k CR
	s CR(2)=SourceType		;CRSourceType  type:0检测任务||1报表; 
	s CR(3)=SourceName		;CRSourceName  检测报表的名称和方法名用一个字符串存
	s CR(4)=QueryName		;CRQueryName 
	s CR(5)=Date			;CR_Date
	s CR(6)=StrMonth		;CRStrMonth  时间:开始月份||结束月份
	s CR(7)=EndMonth		;CREndMonth 
	s CR(8)=QueryPara		;CRQueryPara 
	s CR(9)=""				;CRStatus  状态:结果是否正确
	s CR(10)=""				;CR_Hold1
	s CR(11)=""				;CR_Hold2
	s CR(12)=""				;CR_Hold3
	s CR(13)=""				;CR_Hold4
	s CR(14)=""				;CR_Hold5
	
	&SQL(insert into sqluser.DHC_EQCheckResult values :CR())
	i SQLCODE
	{
		q SQLCODE
	}
	s CRRowID=$G(%ROWID)
	quit CRRowID
}

ClassMethod InsertCheckResultList(CheckResutlID, Job, ReportNode, CheckNode)
{
	new SQLCODE,EquipTypeID,StatCatID,StoreLocID,FundsTypeID,OriginID,ReportData,CheckData,CRL,Flag
	s (SQLCODE,Flag)=0
	s EquipTypeID=0
	f  s EquipTypeID=$o(^DHCEQTemp("CheckResult",Job,ReportNode,EquipTypeID))  quit:EquipTypeID=""||SQLCODE'=0  d
	.s StatCatID=0
	.f  s StatCatID=$o(^DHCEQTemp("CheckResult",Job,ReportNode,EquipTypeID,StatCatID)) quit:StatCatID=""||SQLCODE'=0  d
	..s StoreLocID=0
	..f  s StoreLocID=$o(^DHCEQTemp("CheckResult",Job,ReportNode,EquipTypeID,StatCatID,StoreLocID)) quit:StoreLocID=""||SQLCODE'=0  d
	...s FundsTypeID=0
	...f  s FundsTypeID=$o(^DHCEQTemp("CheckResult",Job,ReportNode,EquipTypeID,StatCatID,StoreLocID,FundsTypeID)) quit:FundsTypeID=""||SQLCODE'=0  d
	....s OriginID=0
	....f  s OriginID=$o(^DHCEQTemp("CheckResult",Job,ReportNode,EquipTypeID,StatCatID,StoreLocID,FundsTypeID,OriginID)) quit:OriginID=""||SQLCODE'=0  d
	.....s FinaceItemID=0
	.....f  s FinaceItemID=$o(^DHCEQTemp("CheckResult",Job,ReportNode,EquipTypeID,StatCatID,StoreLocID,FundsTypeID,OriginID,FinaceItemID)) quit:FinaceItemID=""||SQLCODE'=0  d
	......s FunctionCatID=0
	......f  s FunctionCatID=$o(^DHCEQTemp("CheckResult",Job,ReportNode,EquipTypeID,StatCatID,StoreLocID,FundsTypeID,OriginID,FinaceItemID,FunctionCatID)) quit:FunctionCatID=""||SQLCODE'=0  d
	.......s ReportData=$g(^DHCEQTemp("CheckResult",Job,ReportNode,EquipTypeID,StatCatID,StoreLocID,FundsTypeID,OriginID,FinaceItemID,FunctionCatID))
	.......s CheckData =$g(^DHCEQTemp("CheckResult",Job,CheckNode ,EquipTypeID,StatCatID,StoreLocID,FundsTypeID,OriginID,FinaceItemID,FunctionCatID))
	.......i (+$p(CheckData,"^",1)'=+$p(ReportData,"^",1))||(+$p(CheckData,"^",2)'=+$p(ReportData,"^",2))||(+$p(CheckData,"^",3)'=+$p(ReportData,"^",3))||(+$p(CheckData,"^",5)'=+$p(ReportData,"^",5)) d
	........k CRL
	........s Flag=1  //有记录写入明细,说明结果有问题,返回Flag改写CR_Status	||(+$p(CheckData,"^",4)'=+$p(ReportData,"^",4))
	........s CRL(2)=CheckResutlID				;CRL_CheckResultDR
	........s CRL(3)=EquipTypeID				;CRL_EquipTypeDR
	........s CRL(4)=StatCatID					;CRL_StatCatDR
	........s CRL(5)=StoreLocID					;CRL_StoreLocDR
	........s CRL(6)=FundsTypeID				;CRL_FundsTypeDR
	........s CRL(7)=OriginID					;CRL_OriginDR
	........s CRL(8)=FinaceItemID				;CRL_FinaceItemDR
	........s CRL(9)=FunctionCatID				;CRL_FunctionCatDR
	........s CRL(10)=""							;CRL_Other
	........s CRL(11)=$p(ReportData,"^",1)		;CRL_ReportOriginalFee
	........s CRL(12)=$p(ReportData,"^",2)		;CRL_ReportNetFee
	........s CRL(13)=$p(ReportData,"^",3)		;CRL_ReportDepreFee
	........s CRL(14)=$p(ReportData,"^",4)		;CRL_ReportDepreTotalFee
	........s CRL(15)=$p(ReportData,"^",5)		;CRL_ReportOther
	........s CRL(16)=$p(CheckData,"^",1)		;CRL_SnapOriginalFee
	........s CRL(17)=$p(CheckData,"^",2)		;CRL_SnapNetFee
	........s CRL(18)=$p(CheckData,"^",3)		;CRL_SnapDepreFee
	........s CRL(19)=$p(CheckData,"^",4)		;CRL_SnapDepreTotalFee
	........s CRL(20)=$p(CheckData,"^",5)		;CRL_SnapOther
	........s CRL(21)=""						;CRL_Hold1
	........s CRL(22)=""						;CRL_Hold2
	........s CRL(23)=""						;CRL_Hold3
	........s CRL(24)=""						;CRL_Hold4
	........s CRL(25)=""						;CRL_Hold5
	........s CRL(26)=""						;CRL_Hold6
	........&SQL(insert into sqluser.DHC_EQCheckResultList values :CRL())
	quit SQLCODE_"^"_Flag
}

/// d ##class(%ResultSet).RunQuery("web.DHCEQ.Plat.BUSCheckResult","CheckResult","0","月报结果")
Query CheckResult(SourceType, NameStr, StrDate, EndDate) As %Query(ROWSPEC = "CRRowID:%String,CRSourceType:%String,CRSourceName:%String,CRQueryName:%String,CRDate:%String,CRStrMonth:%String,CREndMonth:%String,CRQueryPara:%String,CRStatus:%String,CRHold1:%String,CRHold2:%String,CRHold3:%String,CRHold4:%String,CRHold5:%String,CRRow:%String")
{
}

ClassMethod CheckResultExecute(ByRef qHandle As %Binary, SourceType, NameStr, StrDate, EndDate) As %Status
{
 	new repid, index
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1	
	
	s StrDate=##class(web.DHCEQCommon).TransValueFromPage(StrDate,"date")
	i StrDate="" s StrDate=0
	s EndDate=##class(web.DHCEQCommon).TransValueFromPage(EndDate,"date")
	i EndDate="" s EndDate=+$H
	
	s vTSourceType=""
	f  s vTSourceType=$o(^DHCEQCheckResult(0,"TypeName",vTSourceType))  quit:vTSourceType=""  d
	.quit:(SourceType'="")&(SourceType'=vTSourceType)
	.s vTSourceName=""
	.f  s vTSourceName=$o(^DHCEQCheckResult(0,"TypeName",vTSourceType,vTSourceName))  quit:vTSourceName=""  d
	..quit:(NameStr'="")&(NameStr'=vTSourceName)
	..s rowid=0
	..f  s rowid=$o(^DHCEQCheckResult(0,"TypeName",vTSourceType,vTSourceName,rowid))  quit:rowid=""  d
	...s DataList=$g(^DHCEQCheckResult(rowid))
	...d ResetVariablesCheckResult
	...s TRowID=rowid
	...s TSourceType=$P(DataList,"^",1)
	...s TSourceType=$CASE(TSourceType,"0":"任务结果","1":"报表结果",:"没有定义")
	...s TSourceName=$P(DataList,"^",2)
	...s TQueryName=$P(DataList,"^",3)
	...s TDate=$P(DataList,"^",4)
	...quit:(StrDate'="")&(StrDate>TDate)
	...quit:(EndDate'="")&(EndDate<TDate)
	...s TDate=##Class(web.DHCEQCommon).TransValueToPage(TDate,"date")
	...s TStrMonth=$P(DataList,"^",5)
	...s TEndMonth=$P(DataList,"^",6)
	...s TQueryPara=$P(DataList,"^",7)
	...s TStatus=$P(DataList,"^",8)
	...s TStatus=$CASE(TStatus,"0":"正常","1":"异常",:"没有定义")
	...s THold1=$P(DataList,"^",9)
	...s THold2=$P(DataList,"^",10)
	...s THold3=$P(DataList,"^",11)
	...s THold4=$P(DataList,"^",12)
	...s THold5=$P(DataList,"^",13)
	...s TRow=index
	...d OutputRowCheckResult
	
	Quit $$$OK
OutputRowCheckResult
	s Data=$lb(TRowID,TSourceType,TSourceName,TQueryName,TDate,TStrMonth,TEndMonth,TQueryPara,TStatus,THold1,THold2,THold3,THold4,THold5,TRow)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesCheckResult
	s (TRowID,TSourceType,TSourceName,TQueryName,TDate,TStrMonth,TEndMonth,TQueryPara,TStatus,THold1,THold2,THold3,THold4,THold5)=""
	quit
}

ClassMethod CheckResultFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = CheckResultExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 		}
 	Else      {
 		Set Row=^CacheTemp(repid,ind)
 		}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod CheckResultClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = CheckResultExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query CheckResultList(CRRowID) As %Query(ROWSPEC = "CRLRowID:%String,CRLEquipTypeDR:%String,CRLEquipType:%String,CRLStatCatDR:%String,CRLStatCat:%String,CRLStoreLocDR:%String,CRLStoreLoc:%String,CRLFundsTypeDR:%String,CRLFundsType:%String,CRLOriginDR:%String,CRLOrigin:%String,CRLFinaceItemDR:%String,CRLFinaceItem:%String,CRLFunctionCatDR:%String,CRLFunctionCat:%String,CRLOther:%String,CRLReportOriginalFee:%String,CRLReportNetFee:%String,CRLReportDepreFee:%String,CRLReportDepreTotalFee:%String,CRLReportOther:%String,CRLSnapOriginalFee:%String,CRLSnapNetFee:%String,CRLSnapDepreFee:%String,CRLSnapDepreTotalFee:%String,CRLSnapOther:%String,CRLHold1:%String,CRLHold2:%String,CRLHold3,CRLHold4:%String,CRLHold5:%String,CRLHold6:%String")
{
}

ClassMethod CheckResultListExecute(ByRef qHandle As %Binary, CRRowID) As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	i CRRowID="" Quit $$$OK
	s rowid=0
	f  s rowid=$o(^DHCEQCheckResultList(0,"CheckResultDR",CRRowID,rowid))  quit:rowid=""  d
	.d ResetVariablesCheckResultList
	.s DataList=$g(^DHCEQCheckResultList(rowid))
	.s TRowID=rowid
	.s TEquipTypeDR=$P(DataList,"^",2)
	.s TEquipType=##Class(web.DHCEQCommon).GetTrakNameByID("equiptype",TEquipTypeDR)
	.s TStatCatDR=$P(DataList,"^",3)
	.s TStatCat=##Class(web.DHCEQCommon).GetTrakNameByID("statcat",TStatCatDR)
	.s TStoreLocDR=$P(DataList,"^",4)
	.s TStoreLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept",TStoreLocDR)
	.s TFundsTypeDR=$P(DataList,"^",5)
	.s TFundsType=##Class(web.DHCEQCommon).GetTrakNameByID("fundstype",TFundsTypeDR)
	.s TOriginDR=$P(DataList,"^",6)
	.s TOrigin=##Class(web.DHCEQCommon).GetTrakNameByID("origin",TOriginDR)
	.s TFinaceItemDR=$P(DataList,"^",7)
	.i TFinaceItemDR>0 s TFinaceItem=$p($g(^DHCEQCCode("DHCEQCFinaceItem",TFinaceItemDR)),"^",2)
	.s TFunctionCatDR=$P(DataList,"^",8)
	.i TFunctionCatDR>0 s TFunctionCat=$p($g(^DHCEQCCode("DHCEQCFinaceItem",TFunctionCatDR)),"^",2)
	.s TOther=$P(DataList,"^",9)
	.s TReportOriginalFee=$P(DataList,"^",10)
	.s TReportNetFee=$P(DataList,"^",11)
	.s TReportDepreFee=$P(DataList,"^",12)
	.s TReportDepreTotalFee=$P(DataList,"^",13)
	.s TReportOther=$P(DataList,"^",14)
	.s TSnapOriginalFee=$P(DataList,"^",15)
	.s TSnapNetFee=$P(DataList,"^",16)
	.s TSnapDepreFee=$P(DataList,"^",17)
	.s TSnapDepreTotalFee=$P(DataList,"^",18)
	.s TSnapOther=$P(DataList,"^",19)
	.s THold1=$P(DataList,"^",20)
	.s THold2=$P(DataList,"^",21)
	.s THold3=$P(DataList,"^",22)
	.s THold4=$P(DataList,"^",23)
	.s THold5=$P(DataList,"^",24)
	.s THold6=$P(DataList,"^",25)
	.d OutputRowCheckResultList
	
	Quit $$$OK
OutputRowCheckResultList
	s Data=$lb(TRowID,TEquipTypeDR,TEquipType,TStatCatDR,TStatCat,TStoreLocDR,TStoreLoc,TFundsTypeDR,TFundsType,TOriginDR,TOrigin,TFinaceItemDR,TFinaceItem,TFunctionCatDR,TFunctionCat,TOther,TReportOriginalFee,TReportNetFee,TReportDepreFee,TReportDepreTotalFee,TReportOther,TSnapOriginalFee,TSnapNetFee,TSnapDepreFee,TSnapDepreTotalFee,TSnapOther,THold1,THold2,THold3,THold4,THold5,THold6)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesCheckResultList
	s (DataList,TRowID,TEquipTypeDR,TEquipType,TStatCatDR,TStatCat,TStoreLocDR,TStoreLoc,TFundsTypeDR,TFundsType,TOriginDR,TOrigin,TFinaceItemDR,TFinaceItem,TFunctionCatDR,TFunctionCat,TOther,TReportOriginalFee,TReportNetFee,TReportDepreFee,TReportDepreTotalFee,TReportOther,TSnapOriginalFee,TSnapNetFee,TSnapDepreFee,TSnapDepreTotalFee,TSnapOther,THold1,THold2,THold3,THold4,THold5,THold6)=""
	quit
}

ClassMethod CheckResultListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = CheckResultListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 		}
 	Else      {
 		Set Row=^CacheTemp(repid,ind)
 		}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod CheckResultListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = CheckResultListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// w ##Class(web.DHCEQ.Plat.BUSCheckResult).SourceTypeList
ClassMethod SourceTypeList(name, width, Type) As %String
{
	;;下拉列表
	w "<select name='"_name_"' id='"_name_"' style='width:"_width_"' HEIGHT=0>"
	w "<option value=></option>"
	w "<option value=0>任务结果</option>"
	w "<option value=1>报表结果</option>"
	w "</select>",!
}

/// add by czf 2021-08-10
/// 台账及快照数据折旧检测,^DHCEQTempCZF记录错误数据日志
/// 入参:MonthStr:月份格式：yyyy-mm
/// 返回:0：成功 1:有错误 其他：程序执行错误
/// w ##class(web.DHCEQ.Plat.BUSCheckResult).CheckEquipDepre("2022-02")
ClassMethod CheckEquipDepre(MonthStr As %String = "")
{
	i MonthStr="" q "检测月份不能为空!"
	k ^DHCEQTempCZF
	s RtnMsg=0
	s Date=+$h
		s SnapID=""
	s CurMonth=$p($zd(+$h,3),"-",1,2)
	s MonthDiff=##Class(web.DHCEQCommon).DateDiffInt("m",$zdh(CurMonth_"-01",3),$zdh(MonthStr_"-01",3))
	i MonthDiff>=0
	{
		//台账
		s EquipID=0
		f  s EquipID=$o(^DHCEQEquip(EquipID)) q:EquipID=""  d
		.s (ErrMsg,DepreSetErr,FundsErrMsg,EquipInfo,FundsInfo)=""
		.s EquipInfo=$g(^DHCEQEquip(EquipID))
		.q:$p(EquipInfo,"^",59)="Y"
		.q:$p(EquipInfo,"^",60)'=1	;StockStatus
		.q:$p(EquipInfo,"^",38)>2	;Status
		.d CheckEquipDepre
		.;折旧设置表检测
		.d CheckDepreSet
		.;资金来源表检测
		.s (FTotalFee,FDepreTotalFee)=0
		.s FundsID=0
		.f  s FundsID=$o(^DHCEQFunds(0,"Equip",EquipID,FundsID)) q:FundsID=""  d
		..s FundsInfo=$g(^DHCEQFunds(FundsID))
		..q:$p(FundsInfo,"^",10)="Y"
		..s FundTypeDR=$p(FundsInfo,"^",2)
		..s FundType=$p($g(^DHCEQCCode("DHCEQCFundsType",FundTypeDR)),"^",2)
		..s FFee=$p(FundsInfo,"^",3)
		..s FDepreTotal=$p(FundsInfo,"^",13)
		..s FTotalFee=FTotalFee+FFee
		..s FDepreTotalFee=FDepreTotalFee+FDepreTotal
		..i +FDepreTotal<0 d
		...s RtnMsg=1
		...s FundsErrMsg=FundsErrMsg_FundType_"累计折旧小于0!"
		..i +FFee<0 d
		...s RtnMsg=1
		...s FundsErrMsg=FundsErrMsg_FundType_"金额小于0!"
		.d CheckFunds
		.i (ErrMsg'="")||(DepreSetErr'="")||(FundsErrMsg'="") s ^DHCEQTempCZF(0,"ErrorDepre","Equip",EquipID)=SnapID_"^"_ErrMsg_"^"_DepreSetErr_"^"_FundsErrMsg
	}
	else
	{
		//快照
		s SnapID=##Class(web.DHCEQSnapShot).GetSnapIDByMonth(MonthStr)
		i SnapID=""
		{
			q MonthStr_"快照不存在!"	
		}
		else
		{
			d CheckSnapInfo
		}	
	}
	quit RtnMsg
	
CheckSnapInfo
		s EquipID=0
		f  s EquipID=$o(^DHCEQSnapShot(SnapID,"Equip",EquipID)) q:EquipID=""  d
		.s (ErrMsg,DepreSetErr,FundsErrMsg,EquipInfo,FundsInfo)=""
		.s EquipInfo=$g(^DHCEQSnapShot(SnapID,"Equip",EquipID))
		.q:$p(EquipInfo,"^",59)="Y"
		.q:$p(EquipInfo,"^",60)'=1	;StockStatus
		.q:$p(EquipInfo,"^",38)>2	;Status
		.d CheckEquipDepre
		.;资金来源表检测
		.s (FTotalFee,FDepreTotalFee)=0
		.s FundsID=0
		.f  s FundsID=$o(^DHCEQSnapShot(SnapID,"Funds",EquipID,FundsID)) q:FundsID=""  d
		..s FundsInfo=$g(^DHCEQSnapShot(SnapID,"Funds",EquipID,FundsID))
		..q:$p(FundsInfo,"^",10)="Y"
		..s FundTypeDR=$p(FundsInfo,"^",2)
		..s FundType=$p($g(^DHCEQCCode("DHCEQCFundsType",FundTypeDR)),"^",2)
		..s FFee=$p(FundsInfo,"^",3)
		..s FDepreTotal=$p(FundsInfo,"^",13)
		..s FTotalFee=FTotalFee+FFee
		..s FDepreTotalFee=FDepreTotalFee+FDepreTotal
		..i +FDepreTotal<0 d
		...s RtnMsg=1
		...s FundsErrMsg=FundsErrMsg_FundType_"累计折旧小于0!"
		..i +FFee<0 d
		...s RtnMsg=1
		...s FundsErrMsg=FundsErrMsg_FundType_"金额小于0!"
		.d CheckFunds
		.i (ErrMsg'="")||(DepreSetErr'="")||(FundsErrMsg'="") s ^DHCEQTempCZF(0,"ErrorDepre","Equip",EquipID)=SnapID_"^"_ErrMsg_"^"_DepreSetErr_"^"_FundsErrMsg
		quit
		
CheckEquipDepre		;台账折旧检测
	s OriginalFee=$p(EquipInfo,"^",27)
	s DepreTotalFee=$p(EquipInfo,"^",35)
	s NetFee=$p(EquipInfo,"^",28)
	s NetRemainFee=$p(EquipInfo,"^",29)
	s DepreMethod=$p(EquipInfo,"^",33)
	s LimitYearsNum=$p(EquipInfo,"^",31)
	s EQNo=$p(EquipInfo,"^",71)
	
	i $fn(OriginalFee,"",2)'=$fn((DepreTotalFee+NetFee),"",2) d
	.s RtnMsg=1
	.s ErrMsg=ErrMsg_"累计折旧与净值之和不等于原值!"
	
	i (+DepreTotalFee<0)||(+NetFee<0) d
	.s RtnMsg=1
	.s ErrMsg=ErrMsg_"累计折旧或净值小于0!"
	
	i +NetFee<+NetRemainFee d
	.s RtnMsg=1
	.s ErrMsg=ErrMsg_"净值小于净残值!"
	quit
	
CheckDepreSet	;折旧设置表检测
	s FindDSID=0
	s DepreSetID=0
	f  s DepreSetID=$o(^DHCEQDepreSet(0,"Equip",EquipID,DepreSetID)) q:DepreSetID=""  d
	.s FindDSID=1
	.s DSDepreTotalFee=$p(^DHCEQDepreSet(DepreSetID),"^",23)
	.s DSDepreTotal=$p(^DHCEQDepreSet(DepreSetID),"^",22)
	.i $fn(DSDepreTotalFee,"",2)'=$fn(DepreTotalFee,"",2) d
	..s RtnMsg=1
	..s DepreSetErr=DepreSetErr_"折旧设置累计折旧与台账不一致!折旧设置累计折旧:"_DSDepreTotalFee
	.i (DepreTotalFee>0)&&(+DSDepreTotal=0) d
	..s RtnMsg=1
	..s DepreSetErr=DepreSetErr_";折旧期数不正确!折旧设置已折期数:"_DSDepreTotal
	i (DepreMethod'=3)&&(LimitYearsNum'="")&&(FindDSID'=1) d
	.s RtnMsg=1
	.s DepreSetErr=DepreSetErr_";折旧设置不存在!"
	quit

CheckFunds	;资金来源表检测
	i $fn(FTotalFee,"",2)'=$fn(OriginalFee,"",2) d
	.s RtnMsg=1
	.s FundsErrMsg=FundsErrMsg_";资金来源之和不等于设备原值!资金来源金额之和:"_FTotalFee
	i $fn(FDepreTotalFee,"",2)'=$fn(DepreTotalFee,"",2) d
	.s RtnMsg=1
	.s FundsErrMsg=FundsErrMsg_";资金来源累计折旧之和不等于累计折旧!资金来源累计之和:"_FDepreTotalFee
	quit
}

/// czf 2022-02-10
/// 遍历台账检测错误日志
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.Plat.BUSCheckResult","CheckDepreList")
Query CheckDepreList() As %Query(ROWSPEC = "EquipID:%String:设备ID,SnapID:%String:快照ID,EQNo:%String:设备编号,EQErrMsg:%String:设备折旧错误信息,DepreSetErrMsg:%String:折旧设置错误信息,FundsErrMsg:%String:资金来源错误信息,OriginalFee:%String:原值,DepreTotalFee:%String:累计折旧,NetFee:%String:净值,NetRemainFee:%String:净残值,DepreInfo:%String:折旧设置信息,FundsInfo:%String:资金来源信息")
{
}

ClassMethod CheckDepreListExecute(ByRef qHandle As %Binary) As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s EquipID=0
	f  s EquipID=$o(^DHCEQTempCZF(0,"ErrorDepre","Equip",EquipID))  quit:EquipID=""  d
	.d ResetCheckDepreList
	.s Result=$g(^DHCEQTempCZF(0,"ErrorDepre","Equip",EquipID))
	.s SnapID=$p(Result,"^",1)
	.i SnapID'="" s DataList=$g(^DHCEQSnapShot(SnapID,"Equip",EquipID))
	.e  s DataList=$g(^DHCEQEquip(EquipID))
	.s EQNo=$P(DataList,"^",71)
	.s EQErrMsg=$p(Result,"^",2)
	.s DepreSetErrMsg=$p(Result,"^",3)
	.s FundsErrMsg=$p(Result,"^",4)
	.s OriginalFee=$P(DataList,"^",27)
	.s DepreTotalFee=$P(DataList,"^",35)
	.s NetFee=$P(DataList,"^",28)
	.s NetRemainFee=$P(DataList,"^",29)
	.s DepreSetID=$o(^DHCEQDepreSet(0,"Equip",EquipID,""))
	.i DepreSetID'="" d
	..s DepreInfo="累计折旧:"_$p($g(^DHCEQDepreSet(DepreSetID)),"^",23)_",折旧期数:"_$p($g(^DHCEQDepreSet(DepreSetID)),"^",22)
	.s FundsInfo=##class(web.DHCEQFunds).GetFundsInfoNew(EquipID,SnapID)
	.d OutputCheckDepreList

	Quit $$$OK
OutputCheckDepreList
	s Data=$lb(EquipID,SnapID,EQNo,EQErrMsg,DepreSetErrMsg,FundsErrMsg,OriginalFee,DepreTotalFee,NetFee,NetRemainFee,DepreInfo,FundsInfo)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetCheckDepreList
	s (DataList,SnapID,EQNo,Result,EQErrMsg,DepreSetErrMsg,FundsErrMsg,OriginalFee,DepreTotalFee,NetFee,NetRemainFee,DepreSetID,DepreInfo,FundsInfo)=""
	quit
}

ClassMethod CheckDepreListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = CheckDepreListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 		}
 	Else      {
 		Set Row=^CacheTemp(repid,ind)
 		}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod CheckDepreListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = CheckDepreListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

}
