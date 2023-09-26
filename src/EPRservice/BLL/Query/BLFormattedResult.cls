/// 名称：EPRservice.BLL.Query.BLFormattedResult
/// 描述：查询结果格式化业务逻辑对象
/// 创建者：houjian
/// 创建日期：2011-06-20
Class EPRservice.BLL.Query.BLFormattedResult Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// Desc:	输出Json格式的查询结果
ClassMethod OutputJsonResult(AGUID As %String, AStartKey As %String, AEndKey As %String, AColText As %String)
{
	q:(AGUID = "")
	q:(AStartKey < 1)||(AEndKey < AStartKey) 

	s blItemResult = ##Class(EPRservice.BLL.Query.BLQueryResult).CreateInstanceByColText(AGUID, AColText)
	s colCount = blItemResult.ColumnList.Count()
	q:(colCount = 0)
	
	for i = AStartKey:1:AEndKey
	{
		s dataList = blItemResult.GetResultByKey(i)
		continue:(dataList = "")
		
		s json = ..ResultListToJson(dataList, blItemResult.ColumnList)
		if (i > AStartKey) w "," 
		w json
	}
}

/// Desc:	转换查询结果格式：从 %List 到 Json
ClassMethod ResultListToJson(AResultList As %List, AColumnList As %ListOfDataTypes) As %String
{
	s json = "{"
	
	s count = AColumnList.Count()
	for j = 1:1:count
	{
		if (j > 1)
		{
			s json = json_","
		}
		
		s column = AColumnList.GetAt(j)
		s colName = $P(column, "^", 2)
		s result = $ListGet(AResultList,j)
		s result = $replace(result,"""","\""")
		s json = json_""""_colName_""":"""_result_""""
	}
	
	s json = json_"}"
	
	s json =  ..FilterIlleaglChar(json)
	q json
}

/// Desc:	替换掉json串中的回车换行符号
ClassMethod FilterIlleaglChar(AJson As %String) As %String
{
	s AJson = $tr(AJson,$c(10),"")
	s AJson = $tr(AJson,$c(13),"")
	q AJson
}

}
