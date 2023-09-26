/// Description: 主要用于数据转换
Class web.DHCSTPIVAS.Util Extends %RegisteredObject
{

/// Description: 数据转JSON
/// Input:		 data - 字符串或流
/// w ##class(web.DHCSTPIVAS.Util).DataToJson("[{""b"":111}]")
ClassMethod DataToJson(data) As %DynamicArray
{
	s stream = ..DataToStream(data)
	s type = stream.Read(1)
	if (type = "[") {
		s tObj=##class(%DynamicArray).%New()
	} else {
		s tObj=##class(%DynamicObject).%New()
	}
	d stream.Rewind()
	s jsonData = tObj.%FromJSON(stream)
	q jsonData
}

ClassMethod DataToStream(data)
{
	s stream = ##class(%GlobalCharacterStream).%New()
	if $IsObject(data) {
		d stream.CopyFrom(data)
	}else{
		d stream.Write(data)	
	}
	q stream
}

/// Description: 对应datagrid-filter的结果匹配
/// Input:		 rowData 原始数据, json或者字符串的json
/// 			 filterData	筛选条件 [{"field":"manfDesc","op":"contains","value":"四川"}]		
ClassMethod DataGridFilter(rowData, filterData) As %Boolean
{
	q:(filterData = "")||(filterData = "[]") $$$YES
	s row = ##class(PHA.COM.Json).Parse(rowData)
	if ('$d(%zDataGridFilter(filterData), filterRules)){
		s filterRules = ##class(PHA.COM.Json).Parse(filterData)
		s %zDataGridFilter(filterData)=filterRules
	}

	s len = filterRules.%Size() - 1
	for i = 0 : 1 : len{
		s filter = filterRules.%Get(i)
		s field = filter.field
		s value = filter.value
		s op = filter.op
		s data = row.%Get(field)
		if (op = "contains"){
			return:(data '[ value) $$$NO
		}elseif (op = "notcontains"){
			return:(data [ value) $$$NO
		}elseif (op = "equal"){
			return:(data '= value) $$$NO
		}elseif (op = "notequal"){
			return:(data = value) $$$NO
		}elseif (op = "beginwith"){
			return:($match(data, "^" _ value _ ".*") = 0) $$$NO
		}elseif (op = "endwith"){
			return:($match(data, ".*" _ value _ "$") = 0) $$$NO
		}
	}
	q $$$YES
}

ClassMethod NeedFilterPagination(filterData) As %Boolean
{
	q:(filterData = "")||(filterData = "[]") $$$NO
	q $$$YES
}

/// 替换JSON内的某属性的逗号
ClassMethod ReplaceJsonComma(pStr, pProp, newChar = ";")
{
	s repStr = ""
	s regM=##class(%Regex.Matcher).%New("(?<=" _ pProp _ ":"").*?(?="")", pStr)
	while regM.Locate() {
		s repStr = repStr _ regM.Group
	}
	if (repStr '= ""){
		s pStr= $replace(pStr, repStr, $replace(repStr, ",", newChar))
	}
	q pStr
}

}
