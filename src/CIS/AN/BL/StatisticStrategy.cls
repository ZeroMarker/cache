Class CIS.AN.BL.StatisticStrategy Extends %RegisteredObject
{

/// Creator：      	雍阳
/// CreatDate：    	2017-12-20
/// Description： 	统计查询策略处理
/// Table：        	DHCAN.StatisticStrategy
/// Input:			strategyId:策略ID，startDateTime:开始日期时间，endDateTime:结束日期时间
/// Return：       	"",直接写入Response
/// d ##class(CIS.AN.BL.StatisticStrategy).ProceedStrategy(1,"2017-11-01","2017-11-30")
ClassMethod ProceedStrategy(strategyId, startDateTime, endDateTime) As %String
{
	/// 1.验证策略有效性
	/// 2.预处理策略行
	/// 3.预处理策略条件
	/// 4.预处理策略列
	/// 5.遍历主数据
	/// 5.1. [In Loop]获取当前手术安排信息中相关所有统计项目的值(for each)
	/// 5.2. [In Loop]根据统计项目值设置相关策略条件项的布尔值(for each)
	/// 5.3. [In Loop]根据统计项目值和策略行设置生成结果行(无策略行时同一生成到单独一行,根据关联行设置结果行的关联关系(层级结构))(recur)
	/// 5.4. [In Loop]根据列的逻辑表达式带入条件项的布尔值确定列条件布尔值，true则为结果列
	/// 5.5. [In Loop]获取结果列对应的汇总类型，生成汇总值
	/// 5.6. [In Loop]*[行相关]汇总值的计算*
	/// 5.7. [In Loop]设置结果单元格(结果行,结果列)的值(∑)
	/// 6.处理结果数据表列(根据数值表达式计算得出最终结果列)
	/// 7.生成总计行(根据累加计算得出所有行每一列的总计)
	/// 结果数据存储位置: ^TMPANStatistic($j)
	
	if '(..Validate(strategyId)) quit "{error:""未通过策略验证""}" 
	
	kill params,deployList
	kill ^TMPANStatistic($j)
	
	do PredisposeParams
	do ..PredisposeRows(strategyId,.deployList)
	do ..PredisposeFilters(strategyId,.deployList)
	do ..PredisposeColumns(strategyId,.deployList)
	do ..LoopMainStream(.params,.deployList)
	do ..ConstructResult(.deployList)
	
	quit ""
	
PredisposeParams
	set params("StrategyId")=strategyId
	set startDate = $p(startDateTime," ",1)
	set startTime = $p(startDateTime," ",2)
	set endDate = $p(endDateTime," ",1)
	set endTime = $p(endDateTime," ",2)
	set params("StartDate")=##class(CIS.AN.COM.DateTime).ConvertToDateH(startDate)
	set:startTime'="" params("StartTime")=##class(CIS.AN.COM.DateTime).ConvertToTimeH(startTime)
	set params("EndDate")=##class(CIS.AN.COM.DateTime).ConvertToDateH(endDate)
	set:endTime'="" params("EndTime")=##class(CIS.AN.COM.DateTime).ConvertToTimeH(endTime)
	
	quit
}

/// Creator：      	雍阳
/// CreatDate：    	2017-12-20
/// Description： 	验证统计策略有效性
/// Table：        	DHCAN.StatisticStrategy
/// Input:			strategyId:策略ID
/// Return：       	0 or 1
ClassMethod Validate(strategyId) As %Boolean
{
	quit 1
}

/// Creator：      	雍阳
/// CreatDate：    	2017-12-20
/// Description： 	预处理策略行
/// Table：        	DHCAN.StatisticStrategyRow
/// Input:			strategyId:策略ID，deployList:配置参数列表
/// Return：       	"",直接写入deployList
ClassMethod PredisposeRows(strategyId, ByRef deployList As %ArrayOfDataTypes) As %String
{
	set rowId=""
	for
	{
		set rowId=$o(^DHCANCI("StatisticStrategyRow","Strategy",strategyId,rowId))
		quit:rowId=""
		
		set deployList("Row",rowId)=""
		set itemId=$lg(^DHCANCD("StatisticStrategyRow",rowId),3)
		set deployList("Item",itemId)=""
		set relatedRowId=$lg(^DHCANCD("StatisticStrategyRow",rowId),4)
		if (relatedRowId>0)
		{
			set deployList("RowTreeNode",relatedRowId,rowId)=""
		}
		else
		{
			set deployList("RowOrignalNode",rowId)=""
		}
	}
	
	quit ""
}

/// Creator：      	雍阳
/// CreatDate：    	2017-12-20
/// Description： 	预处理策略条件项
/// Table：        	DHCAN.StatisticStrategyFilter
/// Input:			strategyId:策略ID，deployList:配置参数列表
/// Return：       	""，直接写入deployList
ClassMethod PredisposeFilters(strategyId, ByRef deployList As %ArrayOfDataTypes) As %String
{
	set filterId=""
	for
	{
		set filterId=$o(^DHCANCI("StatisticStrategyFilter","Strategy",strategyId,filterId))
		quit:filterId=""
		
		set deployList("Filter",filterId)=""
		set itemId=$lg(^DHCANCD("StatisticStrategyFilter",filterId),3)
		set deployList("Item",itemId)=""
	}
	
	quit ""
}

/// Creator：      	雍阳
/// CreatDate：    	2017-12-20
/// Description： 	预处理策略列
/// Table：        	DHCAN.StatisticStrategyColumn
/// Input:			strategyId:策略ID，deployList:配置参数列表
/// Return：       	""，直接写入deployList
ClassMethod PredisposeColumns(strategyId, ByRef deployList As %ArrayOfDataTypes) As %String
{
	set colId=""
	for
	{
		set colId=$o(^DHCANCI("StatisticStrategyColumn","Strategy",strategyId,colId))
		quit:colId=""
		
		set deployList("Column",colId)=""
		set itemId=$lg(^DHCANCD("StatisticStrategyColumn",colId),3)
		set:itemId>0 deployList("ColumnItem",itemId)=""
		set summaryTypeId=$lg(^DHCANCD("StatisticStrategyColumn",colId),10)
		set deployList("SummaryType",summaryTypeId)=""
	}
	
	quit ""
}

/// Creator：      	雍阳
/// CreatDate：    	2017-12-20
/// Description： 	遍历主数据
/// Table：        	DHCAN.OperSchedule
/// Input:			params:入参列表，deployList:配置参数列表
/// Return：       	""
ClassMethod LoopMainStream(ByRef params As %List, ByRef deployList As %ArrayOfDataTypes) As %String
{
	set startDate=params("StartDate")
	set endDate=params("EndDate")
	set deployList("StrategyId")=params("StrategyId")
	
	set date=""
	for date=startDate:1:endDate
	{
		set operScheduleId=""
		for
		{
			set operScheduleId=$o(^DHCAN.OperScheduleI("OPDate",date,operScheduleId))
			quit:operScheduleId=""
			
			do ..ProceedOperSchedule(operScheduleId,.deployList)
		}
	}
	
	quit ""
}

/// Creator：      	雍阳
/// CreatDate：    	2017-12-20
/// Description： 	单条手术安排数据处理
/// Table：        	DHCAN.OperSchedule
/// Input:			operScheduleId:手术安排ID，deployList:配置参数列表
/// Return：       	""
ClassMethod ProceedOperSchedule(operScheduleId, ByRef deployList As %ArrayOfDataTypes) As %String
{
	kill itemDataList,itemIdList,filterResultList,availableColumnList
	merge itemIdList = deployList("Item")
	
	set success=##class(CIS.AN.BL.StatisticItem).GetDataList(operScheduleId,.itemIdList,.itemDataList)
	do ..ProceedFilters(.deployList, .itemDataList, .filterResultList)
	
	set strategyId=deployList("StrategyId")
	if ($lg(^DHCANCD("StatisticStrategy",strategyId),3) = "D") ///手术筛选中所有条件按逻辑与处理
	{
		set filterId="",filterSuccess=1
		for
		{
			set filterId=$o(filterResultList(filterId))
			quit:(filterId="")||('filterSuccess)
			
			set filterSuccess = filterSuccess && filterId
		}
		
		if 'filterSuccess quit ""
	}
	
	
	do ..ProceedRows(.deployList, .itemDataList, .resultRowList)
	do ..ProceedColumns(.deployList, .filterResultList, .availableColumnList)
	
	if $d(deployList("ColumnItem"))
	{
		kill itemIdList
		merge itemIdList = deployList("ColumnItem")
		set success=##class(CIS.AN.BL.StatisticItem).GetDataList(operScheduleId,.itemIdList,.itemDataList)
	}
	
	do ..FillResultCells(operScheduleId, .itemDataList,.resultRowList, .availableColumnList)
	
	quit ""
}

/// Creator：      	雍阳
/// CreatDate：    	2017-12-20
/// Description： 	处理策略行数据，生成结果行
/// Table：        	DHCAN.StatisticStrategyRow
/// Input:			deployList:配置参数列表，itemDataList:统计项目值列表，resultRowList:生成的结果行
/// Return：       	""
ClassMethod ProceedRows(ByRef deployList, ByRef itemDataList, ByRef resultRowList) As %String
{
	kill resultRowList
	set rowId=""
	for
	{
		set rowId = $o(deployList("RowOrignalNode",rowId))
		quit:rowId=""
		
		do ..GenerateResultRows("", rowId, .itemDataList,.deployList, .resultRowList)
	}
}

/// Creator：      	雍阳
/// CreatDate：    	2017-12-20
/// Description： 	生成结果行
/// Table：        	DHCAN.StatisticStrategyRow
/// Input:			parentRowId:父策略行ID，rowId:策略行ID，itemDataList:统计项目值列表，deployList:配置参数列表，resultRowList:生成的结果行
/// Return：       	""
ClassMethod GenerateResultRows(parentRowId, rowId, ByRef itemDataList, ByRef deployList, ByRef resultRowList) As %String
{
	set itemId=$lg(^DHCANCD("StatisticStrategyRow",rowId),3)
	set relatedRow=$lg(^DHCANCD("StatisticStrategyRow",rowId),4)
		
	kill itemData
	set dataId=""
	for
	{
		set dataId=$o(itemDataList(itemId,"Data",dataId))
		quit:dataId=""
		
		set itemData=itemDataList(itemId,"Data",dataId)
		
		if (parentRowId="")
		{
			set resultRowId=..GetResultRow(rowId, "", itemId, itemData, .resultRowList)
		}
		else
		{
			set parentResultRowId=""
			for
			{
				set parentResultRowId=$o(resultRowList("Row",parentRowId,"Result",parentResultRowId))
				quit:parentResultRowId=""
				
				set resultRowId=..GetResultRow(rowId, parentResultRowId, itemId, itemData, .resultRowList)
			}
		}
	}
	
	
	set subRowId=""
	for
	{
		set subRowId=$o(deployList("RowTreeNode",rowId,subRowId))
		quit:subRowId=""
		
		do ..GenerateResultRows(rowId, subRowId, .itemDataList,.deployList, .resultRowList)
	}
}

/// Creator：      	雍阳
/// CreatDate：    	2017-12-20
/// Description： 	获取结果行
/// Table：        	DHCAN.StatisticStrategyRow
/// Input:			rowId:策略行ID，parentResultRowId:父结果行ID，itemId:统计项目ID，itemData:统计项目值，resultRowList:生成的结果行
/// Return：       	""
ClassMethod GetResultRow(rowId, parentResultRowId, itemId, itemData, ByRef resultRowList As %List) As %String
{
	set value=$lg(itemData,2),text=$lg(itemData,3)
	set index=parentResultRowId_"||"_itemId_"||"_value
	set resultRowId=$o(^TMPANStatistic($j,"Result","RowIndex","Value",rowId,index,""),-1)
	
	if (resultRowId="")
	{
		set resultRowId=..CreateResultRow(rowId,parentResultRowId,itemId,value,text)
	}
	
	set resultRowList("Result",resultRowId)=""
	set resultRowList("Row",rowId,"Result",resultRowId)=""
	
	quit resultRowId
}

/// Creator：      	雍阳
/// CreatDate：    	2017-12-20
/// Description： 	创建新结果行
/// Table：        	DHCAN.StatisticStrategyRow
/// Input:			rowId:策略行ID，parentResultRowId:父结果行ID，itemId:统计项目ID，itemData:统计项目值，resultRowList:生成的结果行
/// Return：       	""
ClassMethod CreateResultRow(rowId, parentResultRowId, itemId, value, text) As %String
{
	set rowCount=$o(^TMPANStatistic($j,"Result","Row",""),-1)
	set resultRowId=rowCount+1
	set ^TMPANStatistic($j,"Result","Row",resultRowId)=$lb(parentResultRowId,value,text)
	set index=parentResultRowId_"||"_itemId_"||"_value
	set ^TMPANStatistic($j,"Result","RowIndex","Value",rowId,index,resultRowId)=""
	
	quit resultRowId
}

/// Creator：      	雍阳
/// CreatDate：    	2017-12-20
/// Description： 	处理判断条件
/// Table：        	DHCAN.StatisticStrategyFilter
/// Input:			deployList:配置参数列表，itemDataList:统计项目值列表，filterResultList:条件项值列表
/// Return：       	""
ClassMethod ProceedFilters(ByRef deployList, ByRef itemDataList, ByRef filterResultList) As %String
{
	kill filterResultList
	set filterId=""
	for
	{
		set filterId=$O(deployList("Filter",filterId))
		quit:filterId=""
		
		set itemId=$lg(^DHCANCD("StatisticStrategyFilter",filterId),3)
		set field=$lg(^DHCANCD("StatisticStrategyFilter",filterId),4)
		set type=$lg(^DHCANCD("StatisticStrategyFilter",filterId),5)
		set method=$lg(^DHCANCD("StatisticStrategyFilter",filterId),6)
		set checkText=$lg(^DHCANCD("StatisticStrategyFilter",filterId),7)
		set minValue=$lg(^DHCANCD("StatisticStrategyFilter",filterId),8)
		set maxValue=$lg(^DHCANCD("StatisticStrategyFilter",filterId),9)
		set filterResult = 0
		
		set dataId=""
		for
		{
			set dataId=$o(itemDataList(itemId,"Data",dataId))
			quit:(dataId="")||filterResult
		
			if (type="TXT")
			{
				set singleFilterResult = ..GetTextFilterResult(itemDataList(itemId,"Data",dataId), method, checkText)
			}
			elseif (type="NUM")
			{
				set singleFilterResult = ..GetNumberFilterResult(itemDataList(itemId,"Data",dataId),minValue,maxValue)
			}
			
			set filterResult=filterResult||singleFilterResult
		}
		
		set filterResultList(filterId)=filterResult
	}
}

/// Creator：      	雍阳
/// CreatDate：    	2017-12-20
/// Description： 	获取文本筛选结果
/// Table：        	
/// Input:			itemData:统计项目值，method:匹配方法，checkText:匹配值
/// Return：       	""
ClassMethod GetTextFilterResult(itemData As %List, method, checkText) As %Boolean
{
	set value=$lg(itemData,2)
	set text=$lg(itemData,3)
	
	if (method="E")
	{
		quit (checkText=value) || (checkText = text)
	}
	elseif (method="C")
	{
		quit ((","_checkText_",")[(","_value_","))||(text[checkText)
	}
	elseif (method="SW")
	{
		quit (($c(2)_text)[($c(2)_checkText))
	}
	elseif (method="EW")
	{
		quit ((text_$c(2))[(checkText_$c(2)))
	}
	
	quit 0
}

/// Creator：      	雍阳
/// CreatDate：    	2017-12-20
/// Description： 	获取数值筛选结果
/// Table：        	
/// Input:			itemData:统计项目值，minValue:最小值，maxValue:最大值
/// Return：       	""
ClassMethod GetNumberFilterResult(itemData As %List, minValue, maxValue) As %String
{
	set value=$lg(itemData,2)
	
	set onlyMin = ((minValue'="") && (maxValue="") && (value >= minValue))
	set onlyMax = ((minValue="") &&(maxValue'="") && (value <= maxValue))
	set MinMax = ((minValue'="") &&(maxValue'="") && (value >= minValue) && (value <= maxValue))
	
	quit onlyMin || onlyMax || MinMax
}

/// Creator：      	雍阳
/// CreatDate：    	2017-12-27
/// Description： 	处理列，根据条件项目值和列的逻辑表达式计算列的逻辑结果
/// Table：        	
/// Input:			deployList:配置参数列表，filterResultList:条件项逻辑值列表，availableColumnList:可用列的列表
/// Return：       	""
ClassMethod ProceedColumns(ByRef deployList, ByRef filterResultList, ByRef availableColumnList) As %String
{
	set colId=""
	for
	{
		set colId=$o(deployList("Column",colId))
		quit:colId=""
		
		set filters=$lg(^DHCANCD("StatisticStrategyColumn",colId),4)
		set filterFormula=$lg(^DHCANCD("StatisticStrategyColumn",colId),5)
		
		kill Args
		for i=1:1:$l(filters,",")
		{
			set filterId=$p(filters,",",i)
			set Args(i)=+$g(filterResultList(filterId))
		}
		
		set result=..CalculateExpression(filterFormula,.Args)
		
		if (result) set availableColumnList(colId)=""
	}
	
	quit ""
}

/// Creator：      	雍阳
/// CreatDate：    	2017-12-20
/// Description： 	计算表达式，逻辑和数值表达式计算
/// Table：        	
/// Input:			expression:表达式，Args:参数值列表
/// Return：       	表达式计算结果
ClassMethod CalculateExpression(expression, ByRef Args) As %String [ ProcedureBlock = 0 ]
{
	set $ZT="ERROR"
    set ret=0
    set index=""
    for
    {
	    set index=$o(Args(index))
	    quit:index=""
	    set expression=..ReplaceString(expression,"{"_index_"}",+Args(index))
    }
    set expression=$ZSTRIP(expression,"*APC",,"()+-*/\#.&|'")
    set expression="set ret="_expression
    xecute expression
    quit ret
ERROR
    quit "<ERROR>"_$ZE
}

/// Creator：      	雍阳
/// CreatDate：    	2017-12-20
/// Description： 	替换字符串
/// Table：        	
/// Input:			str:原字符串, OldStr:被替换的旧字符串, NewStr:替换的新字符串
/// Return：       	原字符串被替换后的结果字符串
/// w ##class(CIS.AN.BL.StatisticStrategy).ReplaceString("abcdefghijk","c","tc")
ClassMethod ReplaceString(str, OldStr, NewStr) As %String
{
    set i=$find(str,OldStr)
    while(i>0)
    {
        set begin=i-$L(OldStr)-1
        set str=$E(str,1,begin)_NewStr_$E(str,i,$L(str))
        set i=$find(str,OldStr,begin+$L(NewStr)+1)
    }
    quit str
}

/// Creator：      	雍阳
/// CreatDate：    	2017-12-28
/// Description： 	填充单元格，将数值设置到临时global中
/// Table：        	
/// Input:			operScheduleId:手术安排ID, itemDataList:统计项目值, resultRowList:结果行列表，resultColumnList:结果列列表
/// Return：       	
ClassMethod FillResultCells(operScheduleId, ByRef itemDataList, ByRef resultRowList, ByRef resultColumnList) As %String
{
	/// 暂时填充1 (手术例次)
	set rowId=""
	for
	{
		set rowId=$o(resultRowList("Result",rowId))
		quit:rowId=""
		
		set colId=""
		for
		{
			set colId=$o(resultColumnList(colId))
			quit:colId=""
			
			set addingCellValue=1
			set itemId=$lg(^DHCANCD("StatisticStrategyColumn",colId),3)
			set:itemId>0 addingCellValue = $lg(itemDataList(itemId),3)
			
			set ^TMPANStatistic($j,"Result","Data",rowId,colId)=$g(^TMPANStatistic($j,"Result","Data",rowId,colId)) + addingCellValue
			set ^TMPANStatistic($j,"Result","Details",rowId,colId)=$g(^TMPANStatistic($j,"Result","Details",rowId,colId)) + $lb(operScheduleId)
		}
	}
	
	quit ""
}

/// Creator：      	雍阳
/// CreatDate：    	2017-12-20
/// Description： 	处理统计值类型，暂时未实现
/// Table：        	
/// Input:			
/// Return
ClassMethod ProceedSummaryTypes() As %String
{
}

/// Creator：      	雍阳
/// CreatDate：    	2018-01-09
/// Description： 	组成结果，直接写入Response
/// Table：        	
/// Input:			deployList:配置参数列表
/// Return			""
ClassMethod ConstructResult(ByRef deployList As %ArrayOfDataTypes) As %String
{
	write "{"
	write """rows"":","["
	set resultRowId="",rowCount=0
	for
	{
		set resultRowId=$o(^TMPANStatistic($j,"Result","Row",resultRowId))
		quit:resultRowId=""
		
		write:rowCount ","
		write "{"
		write """RowId"":""",resultRowId,""","
		write """RelatedRow"":""",$lg(^TMPANStatistic($j,"Result","Row",resultRowId),1),""","
		write """RowValue"":""",$lg(^TMPANStatistic($j,"Result","Row",resultRowId),2),""","
		write """RowDesc"":""",$lg(^TMPANStatistic($j,"Result","Row",resultRowId),3),""""
		
		set colId=""
		for
		{
			set colId=$o(deployList("Column",colId))
			quit:colId=""
			
			set columns=$lg(^DHCANCD("StatisticStrategyColumn",colId),6)
			set numbericFormula=$lg(^DHCANCD("StatisticStrategyColumn",colId),7)
			set cellValue=$g(^TMPANStatistic($j,"Result","Data",resultRowId,colId))
			
			if (numbericFormula'="")&&(columns'="")
			{
				kill Args
				for i=1:1:columns
				{
					set Args(i)=+$g(^TMPANStatistic($j,"Result","Data",resultRowId,$p(columns,",",i)))
				}
				set cellValue=..CalculateExpression(numbericFormula,.Args)
			}
			
			write ",""Column_",colId,""":""",cellValue,""""
		}
		
		write "}"
		set rowCount=rowCount+1
	}
	
	write "],"
	write """total"":",rowCount,"}"
	
	quit ""
}

/// Creator：      	雍阳
/// CreatDate：    	2018-01-10
/// Description： 	组成图表值结果，暂时未实现
/// Table：        	
/// Input:			
/// Return			
ClassMethod ConstructChartData() As %String
{
}

}
