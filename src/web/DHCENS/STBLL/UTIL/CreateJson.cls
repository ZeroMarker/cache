Class web.DHCENS.STBLL.UTIL.CreateJson Extends (%RegisteredObject, %XML.Adaptor)
{

/// Creator：WuXianPu
/// CreatDate：2014—07-19
/// Description：替换$c(13)、$c(10)、\、'成空
/// Table：
/// Input：
/// Output：
/// Return：
/// Others：w ##class(IMP.DB.CreateJson).EvalJSON("")
ClassMethod EvalJSON(instr As %String) As %String
{
	set mystr = instr	
	Quit:(mystr="") mystr	
	set mystr = ..Replace(mystr,"\", "\\")	
	set mystr = ..Replace(mystr,"'", "\'")	
	set mystr = ..Replace(mystr,$c(13), "")	
	set mystr = ..Replace(mystr,$c(10), "")
	set mystr = ..Replace(mystr,$c(1), "")
	set mystr = ..Replace(mystr,$c(2), "")
	Quit mystr
}

/// Creator：WuXianPu
/// CreatDate：2014—07-19
/// Description：对JSON数据字符特殊字符处理
/// Table：
/// Input：
/// Output：
/// Return：
/// Others：w ##class(IMP.DB.CreateJson).Replace("")
ClassMethod Replace(instr As %String, substr As %String, replacement As %String) As %String
{
	Quit:(substr="") instr
	Quit:'($l(instr,substr)>1) instr	
	set mylen=$l(instr,substr)
	for myIdx=1:1:mylen {
		set myary(myIdx)=$p(instr,substr, myIdx)
	}	
	set mystr=""
	set myIdx=""
	set myIdx=$o(myary(myIdx))
	while (myIdx'=""){
		set myrepstr=""
		if ($o(myary(myIdx))=""){
			set myrepstr=myary(myIdx)
		}else{
			set myrepstr=myary(myIdx)_replacement
		}
		
		if (mystr=""){
			set mystr=myrepstr
		}else{
			set mystr=mystr_myrepstr
		}
		
		set myIdx=$o(myary(myIdx))
		Quit:(myIdx="")
	}
	Quit mystr
}

/// Creator：WuXianPu
/// CreatDate：2014—07-19
/// Description：获取信息集合列表显示在datagrid控件中
/// Table：
/// Input：classname：Query对应类名称，classquery：Query对应方法名称，input：查询条件，page：当前页数，rows：每页显示行数
/// Output：满足条件的Json
/// Return：
/// Others： w ##class(web.DHCENS.STBLL.UTIL.CreateJson).GetDataInfoListShowDatagrid("web.DHCENS.STBLL.UTIL.EnsInterface","GetEnsInterfaceData","^^^2016-08-25 00:00:00^2016-08-25 23:59:59^N","8","10")
ClassMethod GetDataInfoListShowDatagrid(classname As %String, classquery As %String, input As %String, page As %String, rows As %String) As %String
{
	set $zt="Exception"
	set rs=##class(%Library.ResultSet).%New(classname_":"_classquery)
	set cnt=0,displayRows=0
	set rowData=""	
	set columns=rs.GetColumnCount()
	set sc=rs.Execute(input)
	w "{"_$c(34)_"rows"_$c(34)_":[",!	
	;ext默认的开始是1
	if page=1 {
		set startRecordNo=1
	}
	else {
		set startRecordNo=rows*(page-1)+1
	}
	set limitRecordCnt=page*rows
	for  Quit:rs.Next()=0  d
	.set cnt=cnt+1
	.Quit:displayRows=rows
	.if ((cnt'<startRecordNo)&&(displayRows<limitRecordCnt))!(startRecordNo="")!(limitRecordCnt=0)  d
	..w:displayRows>0 ","
	..w "{"
	..set rowData=""
	..for i=1:1:columns  d
	...set:i>1 rowData=rowData_","
	...set myColName=rs.GetColumnName(i)
	...set rowData=rowData_$c(34)_myColName_$c(34)_":"	
	...set tmpData=rs.GetData(i)
	...set tmpData=..EvalJSON(tmpData)
	...set rowData=rowData_$c(34)_tmpData_$c(34)
	..w rowData
	..w "}",!
	..set displayRows=displayRows+1
	w "],"_$c(34)_"total"_$c(34)_":"_cnt_"}"
	Quit ""
Exception
	set cnt=0
	w "{"_$c(34)_"rows"_$c(34)_":[],"_$c(34)_"total"_$c(34)_":"_cnt_"}"
	Quit ""
}

/// Creator：WuXianPu
/// CreatDate：2014—07-19
/// Description：查询满足条件服务的详细信息
/// Table：
/// Input：classname：Query对应类名称，classquery：Query对应方法名称，input：查询条件
/// Output：
/// Return：
/// Others： w ##class(web.DHCENS.Method.CreateJson).GetDataDetailInfo("IMP.Dao.ServiceInfo","GetServiceDetailInfoData","SOAP^CancelFeeApp")
ClassMethod GetDataDetailInfo(classname As %String, classquery As %String, input As %String) As %String
{
	set $zt="Exception"
	set rs=##class(%Library.ResultSet).%New(classname_":"_classquery)
	set cnt=0
	set columns=rs.GetColumnCount()
	set sc=rs.Execute(input)
	for  Quit:rs.Next()=0  d
	.set rowData=""
	.if cnt=0 d
	..w "{"
	.else  d
	..w ",{"	
	.for i=1:1:columns  d
	..set:i>1 rowData=rowData_","
	..set myColName=rs.GetColumnName(i)
	..set rowData=rowData_$c(34)_myColName_$c(34)_":"	
	..set tmpData=rs.GetData(i)
	..set tmpData=..EvalJSON(tmpData)
	..set rowData=rowData_$c(34)_tmpData_$c(34)
	.w rowData_"}"
	.set cnt=cnt+1
	Quit ""
Exception
    w "{}"
	Quit ""
}

/// Creator：WuXianPu
/// CreatDate：2014—07-19
/// Description：获取信息集合列表显示在combox控件中
/// Table：
/// Input：classname：Query对应类名称，classquery：Query对应方法名称，input：查询条件
/// Output：
/// Return：
/// Others： w ##class(web.DHCENS.Method.CreateJson).GetDataInfoListShowCombox("web.DHCENS.Method.EnsInterfaceMethod","GetmethodProcuctionTermData","")
ClassMethod GetDataInfoListShowCombox(classname As %String, classquery As %String, Input As %String) As %String
{
	set $zt="Exception"
	set rs=##class(%Library.ResultSet).%New(classname_":"_classquery)
	set cnt=0	
	set columns=rs.GetColumnCount()
	set sc=rs.Execute(Input)
	w "["	
	for  Quit:rs.Next()=0  d
	.set rowData=""
	.if cnt=0 d
	..w "{"
	.else  d
	..w ",{"	
	.for i=1:1:columns  d
	..set:i>1 rowData=rowData_","
	..set myColName=rs.GetColumnName(i)
	..set rowData=rowData_$c(34)_myColName_$c(34)_":"	
	..set tmpData=rs.GetData(i)
	..set tmpData=..EvalJSON(tmpData)
	..set rowData=rowData_$c(34)_tmpData_$c(34)
	.w rowData_"}"
	.set cnt=cnt+1
	w "]"
	Quit ""
Exception
    w "[]"
	Quit ""
}

/// Creator：WuXianPu
/// CreatDate：2014—08-06
/// Description：获取信息集合列表显示在Tree控件中
/// Table：
/// Input：classname：Query对应类名称，classquery：Query对应方法名称，input：查询条件
/// Output：
/// Return：
/// Others： w ##class(IMP.DB.CreateJson).GetDataInfoListShowTree("IMP.Dao.ServiceInfo","GetServiceCodeInfoData","Send")
ClassMethod GetDataInfoListShowTree(classname As %String, classquery As %String, Input As %String) As %String
{
	set $zt="Exception"
	set rs=##class(%Library.ResultSet).%New(classname_":"_classquery)
	set cnt=0

	set columns=rs.GetColumnCount()
	set sc=rs.Execute(Input)
	set rowData="["
	set childNode=""
	for  Quit:rs.Next()=0  d
	.if (cnt=0) d
	..set rowData=rowData_"{"
	.else  d
	..if childNode="" d
	...set rowData=rowData_",{"
	.if (childNode="end") d  
	..set rowData=rowData_",{"
	.if (childNode="start") d  
	..set rowData=rowData_"{"
	..set childNode="end"	
	.for i=1:1:columns  d
	..set myColName=rs.GetColumnName(i)	
	..set tmpData=rs.GetData(i)
	..if ((myColName="children")&&(tmpData="")) d
	...set rowData=rowData_"}"
	..else  d
	...if (myColName="children") d
	....set childNode="start"
	....set rowData=rowData_","_$c(34)_myColName_$c(34)_":["
	...else  d
	....set:i>1 rowData=rowData_","
	....set rowData=rowData_$c(34)_myColName_$c(34)_":"
	....set tmpData=..EvalJSON(tmpData)
	....set rowData=rowData_$c(34)_tmpData_$c(34)
	.if myColName'="children" d
	...set rowData=rowData_"}"
	.set cnt=cnt+1
	if childNode'="" d
	.set rowData=rowData_"]}]"
	e  d
	.set rowData=rowData_"]"
	w rowData
	Quit ""
Exception
    w "[]"
	Quit ""
}

}
