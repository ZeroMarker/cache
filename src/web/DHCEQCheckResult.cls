/// modified by zy 2017-04-12
/// add by zy 2014-08-07  ZY0116
/// 这个类文件中的方法是用于检测月结报表和折旧报表结果.
/// 两个方法如下:
/// CheckMonthReport  检测某个月的月报结果 
/// 执行方法w ##class(web.DHCEQCheckResult).CheckMonthReport("2021-07")
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
Class web.DHCEQCheckResult Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// 检测当前月报的快照,出一份结果和月报表中的数据进行比较
/// 入参：	MonthStr:月份 格式为"YYYY-MM"
/// 			ReportType："" 是不分实物和财务月结 "0" 是实物月结  1,是财务月结 
/// w ##class(web.DHCEQCheckResult).CheckMonthReport("2021-07")
ClassMethod CheckMonthReport(MonthStr, ReportType As %String = "")
{
	new SQLCODE,Year,Month,Job,SnapID,PreSnapID,EquipID,DataList
	new EquipTypeID,StatCatID,StoreLocID,FundsTypeID,OriginID
	
	s SQLCODE=0
	s Year =$p(MonthStr,"-",1)
	s Month=$p(MonthStr,"-",2)
	
	i '$Data(^DHCEQMonthReportList(0,"YearMonth",Year,+Month)) quit ""
	s Job=$j
	k ^DHCEQTemp("CheckResult",Job)
	
	//找到前后两个快照的ID,通过比较两个快照来出期初和期末结果,先比较期初和期末,如果没问题,就认为数据正确.
	s (SnapID,PreSnapID)=""
	//指定的会计周期的第一天才能取到ID
	s SnapID=##Class(web.DHCEQSnapShot).GetSnapIDByMonth(MonthStr)
	i SnapID="" quit ""
	
	//modified by zy  添加
	//目前是直接取当前月的快照，重新统计数据。之后和月结报表的数据进行比较。取上月的快照ID没有用,只是看看是否存在
	//s PreSnapID=SnapID-1
	//if '$Data(^DHCEQSnapShot(PreSnapID,"Equip")) quit ""	//缺少前一个后面的快照不出结果
	
	//统计快照的结果
	s EquipID=0
	f  s EquipID=$o(^DHCEQSnapShot(SnapID,"Equip",EquipID))  quit:EquipID=""  d
	.s DataList=$g(^DHCEQSnapShot(SnapID,"Equip",EquipID))
	.
	.s (StatCatDR,EquipTypeDR,Status,StoreLocDR,InvalidFlag,OriginDR,StockStatus)=""
	.s (OriginalFee,ChangeFee,DepreTotalFee,EndFee,DepreFee,DepreTotalFee)=0
	.s OriginID =+$p(DataList,"^",20)
	.s Status = $p(DataList,"^",38)
	.quit:Status>"2"	//不是本月报废数据,不统计
	.s InvalidFlag = $p(DataList,"^",59)
	.quit:InvalidFlag="Y"	//无效数据
	.s StockStatus = $p(DataList,"^",60)
	.quit:(StockStatus="0")||(StockStatus="3")	//验收未入库
	.s EquipTypeID = $p(DataList,"^",63)
	.s StoreLocID  = $p(DataList,"^",67)
	.s StatCatID = $p(DataList,"^",75)
	.s OriginalFee = +$p(DataList,"^",27)
	.;s DepreFee=$o(^DHCEQMonthDepre(0,"EquipMonth",rowid,MonthStr,0))
	.;i DepreFee'="" s DepreFee=$p($g(^DHCEQMonthDepre(DepreFee)),"^",14)
	.s DepreTotalFee = $p(DataList,"^",35)
	.s Node="SnapData"
	.s rowid=0
	.f  s rowid=$o(^DHCEQSnapShot(SnapID,"Funds",EquipID,rowid)) quit:rowid=""  d
	..s FundsData=$g(^DHCEQSnapShot(SnapID,"Funds",EquipID,rowid))
	..quit:(($p(FundsData,"^",6)="2")||($p(FundsData,"^",10)="Y"))	//F_InvalidFlag||F_OperFlag
	..s FundsTypeID=$p(FundsData,"^",2)
	..s FundsFee=$p(FundsData,"^",3)
	..s FundsDepreTotalFee=$p(FundsData,"^",13)
	..s FinaceItemID=+$p(FundsData,"^",20)
	..s FunctionCatID=+$p(FundsData,"^",21)
	..i FundsDepreTotalFee>FundsFee s FundsDepreTotalFee=FundsFee		//特例:某些医院存在累计折旧大于原值数据
	..s FundsNetFee=FundsFee-FundsDepreTotalFee
	..i FundsNetFee<0 s FundsNetFee=0
	..d ##class(web.DHCEQCheckResult).SetSumDataFeeGolable(Job,Node,EquipTypeID,StatCatID,StoreLocID,FundsTypeID,OriginID,FinaceItemID,FunctionCatID,FundsFee,FundsNetFee,0,FundsDepreTotalFee,0)
	
	s Node="ReportData"
	d ##class(web.DHCEQCheckResult).SumMonthReportData(Job,Node,Year,Month,ReportType)
	
	s SourceName="月报结果"
	i ReportType=0 d
	.s SourceName="实物月报结果"
	e  i ReportType=1 d
	.s SourceName="财务月报结果"
	
	s SQLCODE=##class(web.DHCEQCheckResult).SaveCheckResult("0",SourceName,"",MonthStr,MonthStr,MonthStr,Job,"ReportData","SnapData")
	k ^DHCEQTemp("CheckResult",Job)
 	q SQLCODE
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
/// w ##class(web.DHCEQCheckResult).CheckDepreReport(+$h-40,+$h,"DD",1,"^1^2^3^4^5^6^7^8^9^","","Y","Y^Y^Y^Y^Y")
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
	....d ##class(web.DHCEQCheckResult).SetSumDataFeeGolable(Job,"MonthDepreData",EquipTypeID,StatCatID,StoreLocID,FundsTypeID,OriginID,0,0,DepreFee,0,0)
	...i CADFlag=0  d
	....s FundsTypeID=SelfFundsFlag
	....s flag=0
	....d SetNodeValueByFlag
	....quit:flag'=0
	....d ##class(web.DHCEQCheckResult).SetSumDataFeeGolable(Job,"MonthDepreData",EquipTypeID,StoreLocID,StoreLocID,FundsTypeID,OriginID,0,0,DepreFee,0,0)
	
	s SQLCODE=##class(web.DHCEQCheckResult).SaveCheckResult("1","",Job,Node,"MonthDepreData")
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

/// w ##class(web.DHCEQCheckResult).SumMonthReportData(Job,Year,Month)
ClassMethod SumMonthReportData(Job, Node, Year, Month, ReportType As %String = "0")
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
	....d ##class(web.DHCEQCheckResult).SetSumDataFeeGolable(Job,Node,EquipTypeID,StatCatID,StoreLocID,FundsTypeID,OriginID,FinaceItemID,FunctionCatID,FundsFee,FundsNetFee,0,FundsDepreTotalFee,0)
}

/// 累计计算临时golable的值
/// w ##class(web.DHCEQCheckResult).SetSumDataFeeGolable(1,"ZY",1,2,3,4,5,6,7,8,9,10)
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
/// w ##class(web.DHCEQCheckResult).SaveCheckResult(SourceType,SourceName,QueryName,StrMonth,EndMonth,QueryPara,Job, ReportData, CheckData)
ClassMethod SaveCheckResult(SourceType, SourceName, QueryName, StrMonth, EndMonth, QueryPara, Job, ReportData, CheckData)
{
	new CheckResultID,Result,SQLCODE,Flag
	TSTART
	s CheckResultID=##class(web.DHCEQCheckResult).InsertCheckResult(SourceType,SourceName,QueryName,StrMonth,EndMonth,QueryPara)
	i CheckResultID'>0
	{
		TROLLBACK
		q CheckResultID
	}
	s Result=##class(web.DHCEQCheckResult).InsertCheckResultList(CheckResultID,Job,ReportData,CheckData)
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

/// w ##class(web.DHCEQCheckResult).InsertCheckResult()
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

/// d ##class(%ResultSet).RunQuery("web.DHCEQCheckResult","CheckResult","0","月报结果")
Query CheckResult(SourceType, NameStr, StrDate, EndDate) As %Query(ROWSPEC = "TRowID:%String,TSourceType:%String,TSourceName:%String,TQueryName:%String,TDate:%String,TStrMonth:%String,TEndMonth:%String,TQueryPara:%String,TStatus:%String,THold1:%String,THold2:%String,THold3:%String,THold4:%String,THold5:%String,TRow:%String")
{
}

ClassMethod CheckResultExecute(ByRef qHandle As %Binary, SourceType, NameStr, StrDate, EndDate) As %Status
{
 	new repid, index
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1	
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

Query CheckResultList(CRRowID) As %Query(ROWSPEC = "TRowID:%String,TEquipTypeDR:%String,TEquipType:%String,TStatCatDR:%String,TStatCat:%String,TStoreLocDR:%String,TStoreLoc:%String,TReportOriginalFee:%String,TReportNetFee:%String,TReportDepreFee:%String,TReportDepreTotalFee:%String,TReportOther:%String,TSnapOriginalFee:%String,TSnapNetFee:%String,TSnapDepreFee:%String,TSnapDepreTotalFee:%String,TSnapOther:%String,THold1:%String,THold2:%String,THold3,THold4:%String,THold5:%String,THold6:%String")
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
	.s TOther=$P(DataList,"^",7)
	.s TReportOriginalFee=$P(DataList,"^",8)
	.s TReportNetFee=$P(DataList,"^",9)
	.s TReportDepreFee=$P(DataList,"^",10)
	.s TReportDepreTotalFee=$P(DataList,"^",11)
	.s TReportOther=$P(DataList,"^",12)
	.s TSnapOriginalFee=$P(DataList,"^",13)
	.s TSnapNetFee=$P(DataList,"^",14)
	.s TSnapDepreFee=$P(DataList,"^",15)
	.s TSnapDepreTotalFee=$P(DataList,"^",16)
	.s TSnapOther=$P(DataList,"^",17)
	.s THold1=$P(DataList,"^",18)
	.s THold2=$P(DataList,"^",19)
	.s THold3=$P(DataList,"^",10)
	.s THold4=$P(DataList,"^",21)
	.s THold5=$P(DataList,"^",22)
	.s THold6=$P(DataList,"^",23)
	.d OutputRowCheckResultList
	
	Quit $$$OK
OutputRowCheckResultList
	s Data=$lb(TRowID,TEquipTypeDR,TEquipType,TStatCatDR,TStatCat,TStoreLocDR,TStoreLoc,TReportOriginalFee,TReportNetFee,TReportDepreFee,TReportDepreTotalFee,TReportOther,TSnapOriginalFee,TSnapNetFee,TSnapDepreFee,TSnapDepreTotalFee,TSnapOther,THold1,THold2,THold3,THold4,THold5,THold6)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesCheckResultList
	s (DataList,TRowID,TEquipTypeDR,TEquipType,TStatCatDR,TStatCat,TStoreLocDR,TStoreLoc,TReportOriginalFee,TReportNetFee,TReportDepreFee,TReportDepreTotalFee,TReportOther,TSnapOriginalFee,TSnapNetFee,TSnapDepreFee,TSnapDepreTotalFee,TSnapOther,THold1,THold2,THold3,THold4,THold5,THold6)=""
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

// w ##Class(web.DHCEQCheckResult).SourceTypeList

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
/// 入参:Type:快照："snap",台帐：其他
/// 	 MonthStr:月份格式：yyyy-mm
/// d ##class(web.DHCEQMonthDepre).CheckEquipDepre("")
ClassMethod CheckEquipDepre(Type As %String = "", MonthStr As %String = "")
{
	k ^DHCEQTempCZF
	s Date=+$h
	i Type="Snap"
	{
		//快照
		s SnapID=""
		i MonthStr'="" s SnapID=##Class(web.DHCEQSnapShot).GetSnapIDByMonth(MonthStr)
		i SnapID'="" d
		.d CheckSnapInfo
		e  d
		.f  s SnapID=$o(^DHCEQSnapShot(SnapID)) q:SnapID=""  d
		..s SnapDate=$g(^DHCEQSnapShot(SnapID,"Begin"))
		..i SnapDate'="" s Date=$p(SnapDate,",",1)
		..d CheckSnapInfo
	}
	else
	{
		//台账
		s EquipID=0
		f  s EquipID=$o(^DHCEQEquip(EquipID)) q:EquipID=""  d
		.q:EquipID=48
		.s (ErrMsg,EQErrMsg,EquipInfo,FundsInfo)=""
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
		..s FFee=$p(FundsInfo,"^",3)
		..s FDepreTotal=$p(FundsInfo,"^",13)
		..s FTotalFee=FTotalFee+FFee
		..s FDepreTotalFee=FDepreTotalFee+FDepreTotal
		..i (+FDepreTotal<0)||(+FFee<0) d
		...s ^DHCEQTempCZF(0,"ErrorDepre","Funds",EquipID,FundsID)=EQNo_"资金来源累计折旧或净值小于0!,资金来源金额:"_FFee_",资金来源累计折旧:"_FDepreTotal
		.d CheckFunds
	}
	quit
	
CheckSnapInfo
		s EquipID=0
		f  s EquipID=$o(^DHCEQSnapShot(SnapID,"Equip",EquipID)) q:EquipID=""  d
		.s (ErrMsg,EQErrMsg,EquipInfo,FundsInfo)=""
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
		..s FFee=$p(FundsInfo,"^",3)
		..s FDepreTotal=$p(FundsInfo,"^",13)
		..s FTotalFee=FTotalFee+FFee
		..s FDepreTotalFee=FDepreTotalFee+FDepreTotal
		..i (+FDepreTotal<0)||(+FFee<0) d
		...s ^DHCEQTempCZF(0,"ErrorDepre","Funds",EquipID,FundsID)=EQNo_"资金来源累计折旧或净值小于0!资金来源金额:"_FFee_",资金来源累计折旧:"_FDepreTotal
		.d CheckFunds
		quit
		
CheckEquipDepre		;台账折旧检测
	s OriginalFee=$p(EquipInfo,"^",27)
	s DepreTotalFee=$p(EquipInfo,"^",35)
	s NetFee=$p(EquipInfo,"^",28)
	s NetRemainFee=$p(EquipInfo,"^",29)
	s DepreMethod=$p(EquipInfo,"^",33)
	s LimitYearsNum=$p(EquipInfo,"^",31)
	s EQNo=$p(EquipInfo,"^",71)
	s EQErrMsg="原值:"_OriginalFee_",累计折旧:"_DepreTotalFee_",净值:"_NetFee_",净残值:"_NetRemainFee
	i +OriginalFee'=(DepreTotalFee+NetFee) d
	.s ErrMsg=EQNo_"累计折旧与净值之和不等于原值!"_EQErrMsg
	.i Type="Snap" s ^DHCEQTempCZF(0,"ErrorDepre","SnapEquip",SnapID,EquipID)=ErrMsg
	.e  s ^DHCEQTempCZF(0,"ErrorDepre","Equip",EquipID)=ErrMsg
	e  i (+DepreTotalFee<0)||(+NetFee<0) d
	.s ErrMsg=EQNo_"累计折旧或净值小于0!"_EQErrMsg
	.i Type="Snap" s ^DHCEQTempCZF(0,"ErrorDepre","SnapEquip",SnapID,EquipID)=ErrMsg
	.e  s ^DHCEQTempCZF(0,"ErrorDepre","Equip",EquipID)=ErrMsg
	e  i +NetFee<+NetRemainFee d
	.s ErrMsg=EQNo_"净值小于净残值!"_EQErrMsg
	.i Type="Snap" s ^DHCEQTempCZF(0,"ErrorDepre","SnapEquip",SnapID,EquipID)=ErrMsg
	.e  s ^DHCEQTempCZF(0,"ErrorDepre","Equip",EquipID)=ErrMsg
	quit
	
CheckDepreSet	;折旧设置表检测
	s FindDSID=0
	s DepreSetID=0
	f  s DepreSetID=$o(^DHCEQDepreSet(0,"Equip",EquipID,DepreSetID)) q:DepreSetID=""  d
	.s FindDSID=1
	.s DSDepreTotalFee=$p(^DHCEQDepreSet(DepreSetID),"^",23)
	.s DSDepreTotal=$p(^DHCEQDepreSet(DepreSetID),"^",22)
	.i +DSDepreTotalFee'=+DepreTotalFee d
	..s ^DHCEQTempCZF(0,"ErrorDepre","DepreSet",EquipID,DepreSetID)=EQNo_"折旧设置累计折旧与台账不一致!"_EQErrMsg_",折旧设置累计折旧:"_DSDepreTotalFee_",已折期数:"_DSDepreTotal
	.i (DepreTotalFee>0)&&(+DSDepreTotal=0) d
	..s ^DHCEQTempCZF(0,"ErrorDepre","DepreSet",EquipID,DepreSetID)=EQNo_"折旧设置累计折旧与台账不一致!"_EQErrMsg_",折旧设置累计折旧:"_DSDepreTotalFee_",已折期数:"_DSDepreTotal
	i (DepreMethod'=3)&&(LimitYearsNum'="")&&(FindDSID'=1) s ^DHCEQTempCZF(0,"ErrorDepre","DepreSet",EquipID)=EQNo_"折旧设置不存在!"_EQErrMsg_",折旧方法:"_DepreMethod_",折旧年限:"_LimitYearsNum
	quit

CheckFunds	;资金来源表检测
	i +FTotalFee'=+OriginalFee d
	.s ErrMsg=EQNo_"资金来源之和不等于设备原值!"_EQErrMsg
	.i Type="Snap" s ^DHCEQTempCZF(0,"ErrorDepre","SnapFunds",SnapID,EquipID)=ErrMsg
	.e  s ^DHCEQTempCZF(0,"ErrorDepre","Funds",EquipID)=ErrMsg
	i +FDepreTotalFee'=+DepreTotalFee d
	.s ErrMsg=EQNo_"资金来源累计折旧之和不等于累计折旧!"_EQErrMsg
	.i Type="Snap" s ^DHCEQTempCZF(0,"ErrorDepre","SnapFunds",SnapID,EquipID)=ErrMsg
	.e  s ^DHCEQTempCZF(0,"ErrorDepre","Funds",EquipID)=ErrMsg

	quit
}

}
