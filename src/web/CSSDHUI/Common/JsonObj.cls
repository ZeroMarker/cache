Class web.CSSDHUI.Common.JsonObj Extends web.CSSDHUI.Common.DataStore [ ClassType = serial, Not ProcedureBlock ]
{

/// 调用时,使用d obj.getJsonData(***,***,...)
/// csp中需调用需改w为d
Method getJsonData(mapping As %String, count As %Integer, deli As %String = "^", result As %String = "total", root As %String = "rows") As %String
{
	n (mapping,count,deli,result,root,%this)
	w "{"_$c(34)_root_$c(34)_":["
	s cols = $l(mapping,deli)
	i cols > 0 d
	.s rows = ..RowCount()
	.i rows > 0 d
	..f i=1:1:rows d
	...i i=1 w "{"
	...e  w ",{"
	...s temp = ..GetRowData(i)
	...f j=1:1:cols d
	....s colMapping=$p(mapping,deli,j)
	....s colTemp=$p(temp,deli,j)
	....s colTemp=..FormatColValue(colTemp)
	....i j=1 w $c(34)_colMapping_$c(34)_":"_$c(34)_colTemp_$c(34)
	....e  w ","_$c(34)_colMapping_$c(34)_":"_$c(34)_colTemp_$c(34)
	...w "}"
	...
	w "],"_$c(34)_result_$c(34)_":"_count_"}"
}

/// 调用时,使用d obj.getCbJsonData(***,***,...)
Method getCbJsonData(mapping As %String, deli As %String = "^") As %String
{
	n (mapping,deli,%this)
	w "["
	s cols = $l(mapping,deli)
	i cols > 0 d
	.s rows = ..RowCount()
	.i rows > 0 d
	..f i=1:1:rows d
	...i i=1 w "{"
	...e  w ",{"
	...s temp = ..GetRowData(i)
	...f j=1:1:cols d
	....s colMapping=$p(mapping,deli,j)
	....s colTemp=$p(temp,deli,j)
	....s colTemp=..FormatColValue(colTemp)
	....i j=1 w $c(34)_colMapping_$c(34)_":"_$c(34)_colTemp_$c(34)
	....e  w ","_$c(34)_colMapping_$c(34)_":"_$c(34)_colTemp_$c(34)
	...w "}"
	...
	w "]"
}

/// webservice中返回json串的流数据
/// 修改了 result 中的count suess 是否成功
/// XuChao
/// 2017-08-25
Method getJsonDataStream(mapping As %String, count As %Integer, deli As %String = "^", result As %String = "total", root As %String = "rows", success As %String = "true") As %GlobalCharacterStream
{
	n (mapping,count,deli,result,root,%this,success)
	s Response=##class(%GlobalCharacterStream).%New()
	s sc=Response.Write("{"_$c(34)_root_$c(34)_":[")
	s cols = $l(mapping,deli)
	i cols > 0 d
	.s rows = ..RowCount()
	.i rows > 0 d
	..f i=1:1:rows d
	...i i=1 s sc=Response.Write("{")
	...e  s sc=Response.Write(",{") 
	...s temp = ..GetRowData(i)
	...f j=1:1:cols d
	....s colMapping=$p(mapping,deli,j)
	....s colTemp=$p(temp,deli,j)
	....s colTemp=..FormatColValue(colTemp)
	....i j=1 s sc=Response.Write($c(34)_colMapping_$c(34)_":"_$c(34)_colTemp_$c(34))
	....e  s sc=Response.Write(","_$c(34)_colMapping_$c(34)_":"_$c(34)_colTemp_$c(34))
	...s sc=Response.Write("}")
	...
	s sc=Response.Write("],"_$c(34)_result_$c(34)_":"_success_"}")
	q Response
}

/// 2015-03-04 输出summary,添加合计行功能
/// 欲使用getJsonTotal的方法中,不要根据Start,Limit进行continue过滤
/// 调用时,使用d obj.getJsonTotal(Title,Start,Limit,...)
/// csp中需调用需改w为d
Method getJsonTotal(mapping As %String, start As %Integer, limit As %Integer, deli As %String = "^", result As %String = "total", root As %String = "rows") As %String
{
	n (mapping,start,limit,deli,result,root,%this)
	s end=start+limit
	w "{"_root_":["
	s cols = $l(mapping,deli)
	i cols > 0 d
	.f n=1:1:cols s isNumColumn(n)=1	;开始,默认均为数字列
	.s rows = ..RowCount()
	.i rows > 0 d
	..f i=1:1:rows d
	...i i=(start+1) w "{"				;输出第一行{
	...e  i i>start,i<=end w ",{"		;输出第2行以后{
	...
	...s temp = ..GetRowData(i)
	...f j=1:1:cols d
	....s colMapping=$p(mapping,deli,j)
	....s colTemp=$p(temp,deli,j)
	....s colTemp=..FormatColValue(colTemp)
	....//计算合计行
	....i ((isNumColumn(j))&&($ISVALIDNUM(colTemp))) d
	.....s totalJson(j)=$g(totalJson(j))+colTemp
	....e  d
	.....s isNumColumn(j)=0,totalJson(j)=""
	....
	....q:(i<(start+1))||(i>end)		;不在输出范围
	....i j=1 w colMapping_":'"_colTemp_"'"
	....e  w ","_colMapping_":'"_colTemp_"'"
	...i i>start,i<=end w "}"			;输出行后括号
	w "],"_result_":"_rows
	//输出合计行summary
	i ((cols>0)&&(rows>0)) d
	.w ",summary:{"
	.f j=1:1:cols d
	..s colMapping=$p(mapping,deli,j)
	..i j=1 w colMapping_":'"_$g(totalJson(j))_"'"
	..e  w ","_colMapping_":'"_$g(totalJson(j))_"'"
	.w "}"
	w "}"
}

Method getListData(mapping As %String, count As %Integer, deli As %String = "^", result As %String = "results", root As %String = "rows") As %String
{
	n (mapping,count,deli,result,root,%this)
	s str = ""
	s items = ""
	s cols = $l(mapping,deli)
	i cols > 0 d
	.s rows = ..RowCount()
	.i rows > 0 d
	..f i=1:1:rows d
	...s item = ""
	...s temp = ..GetRowData(i)
	...f j=1:1:cols d
	....i item = "" s item = "^"_$p(temp,deli,j)
	....e  s item = item_"^"_$p(temp,deli,j)
	...i items = "" s items = "{"_item_"}"
	...e  s items = items_",{"_item_"}"
	s str = items
	//edit by wangbo 2011-10-20
	q $tr(str,$c(13,10,0))
}

/// 2016-02-20 修改checked取值, 直接write输出
Method getTreeJsonData(mapping As %String, count As %Integer, deli As %String = "^", result As %String = "results", root As %String = "rows") As %String
{
	n (mapping,count,deli,result,root,%this)
	s str = ""
	s items = ""
	s cols = $l(mapping,deli)
	w "["
	i cols > 0 d
	.s rows = ..RowCount()
	.i rows > 0 d
	..f i=1:1:rows d
	...i i=1 w "{"
	...e  w ",{"
	...s temp=$tr(..GetRowData(i),$c(13,10,0))
	...f j=1:1:cols d
	....i j'=1 w ","
	....s colMapping=$p(mapping,deli,j),colTemp=$p(temp,deli,j)
	....i ((colMapping="leaf")||(colMapping="checked")) d
	.....w colMapping_":"_colTemp
	....e  d
	.....w colMapping_":'"_colTemp_"'"
	...w "}"
	w "]"
}

/// Description:格式化数据(斜线和单引号的转义替换, .5形式小数的转换, 回车换行符置换)
/// Creator:	wangjiabin
/// CreatDate:	2014-05-28
ClassMethod FormatColValue(val) As %String
{
	n (val)
	s val=$Replace(val,"\","\\")
	s val=$Replace(val,"""","\""")						;转义双引号,不需转义单引号
	i (($ISVALIDNUM(val))&&((+val=val))) d
	.s tmpVal=$s(val<0:-val,1:val)
	.s:($e(tmpVal,1)=".") val=$tr($fn(val,","),",")		;数字格式处理 .5-->0.5, -.5-->-0.5
	s val=$tr(val,$c(13,10,0))
	q val
}

/// Description:根据query,直接返回json数据,调用时d
/// Creator:	wangjiabin
/// CreatDate:	2014-08-01
/// 若不分页,Limit填0或空
ClassMethod getJsonByQuery(className, queryName, Start, Limit, p1 = "", p2 = "", p3 = "", p4 = "", p5 = "", p6 = "", p7 = "", p8 = "", p9 = "", p10 = "", p11 = "", p12 = "", p13 = "", p14 = "", p15 = "", p16 = "") As %String
{
	s %pcount=$zutil(141)-4
	n (%pcount,className,queryName,Start,Limit,p1,p2,p3,p4,p5,p6,p7,p8,p9,p10,p11,p12,p13,p14,p15,p16)
	;d r^rr		;如需使用,在此调用($zutil(141)之后)
	s result=##class(%Library.ResultSet).%New(className_":"_queryName)
	s execute="s %sc=$method(result,""Execute"""
	f i=1:1:%pcount s execute=execute_",.p"_i
	s execute=execute_")"
	x execute
	k %pcount
	i $$$ISERR(%sc) q ""
	d ..getJsonByResult(result,Start,Limit)
}

/// Description:根据ResultSet,直接返回json数据,调用时d
/// Creator:	wangjiabin
/// CreatDate:	2014-08-01
/// 若不分页,Limit填0或空
/// 2015-03-05 添加summary输出,用于合计行显示
ClassMethod getJsonByResult(ResultSet As %ResultSet, Start = 0, Limit = 0, totalProperty As %String = "results", root As %String = "rows") As %String
{
	n (ResultSet,Start,Limit,totalProperty,root)
	s colNum=ResultSet.GetColumnCount()
	f n=1:1:colNum d
	.s isNumColumn(n)=1					;开始,默认均为数字列
	.s columnName(n)=ResultSet.GetColumnName(n)
	s count=0,end=Start+Limit
	w "{"_root_":["
	While(ResultSet.Next())
	{
		s count=count+1
		s tmpStr=""
		f i=1:1:colNum d
		.s colName=ResultSet.GetColumnName(i)
		.s data=ResultSet.%GetData(i)
		.s data=..FormatColValue(data)	;格式化
		.//计算合计行
		.i ((isNumColumn(i))&&($ISVALIDNUM(data))) d
		..s totalJson(i)=$g(totalJson(i))+data
		.e  d
		..s isNumColumn(i)=0,totalJson(i)=""
		.
		.i tmpStr="" s tmpStr=colName_":'"_data_"'"
		.e  s tmpStr=tmpStr_","_colName_":'"_data_"'"
		continue:(+Limit'=0)&&(count<(Start+1))
		continue:(+Limit'=0)&&(count>end)
		i count=(Start+1) d
		.w "{"_tmpStr_"}"
		e  d
		.w ",{"_tmpStr_"}"
	}
	w "],"_totalProperty_":"_count
	i count>0 d
	.w ",summary:{"
	.f i=1:1:colNum d
	..i i=1 w columnName(i)_":'"_totalJson(i)_"'"
	..e  w ","_columnName(i)_":'"_totalJson(i)_"'"
	.w "}"
	w "}"
	d ResultSet.Close()
}

/// Description:根据表名\Rowid,返回json数据
/// Creator:	zhwh
/// CreatDate:	2014-11-06
ClassMethod GetValue(tab As %String, rowid As %String) As %String
{
	n (rowid,tab) 
	s result="{"
	s sql="select * from "_tab_" where %id='"_rowid_"'"
	s xs=##class(%ResultSet).%New()
	d xs.Prepare(sql)
	s ret=xs.Execute(sql)
	s colcnt=xs.GetColumnCount()
	while (xs.Next())
	{
	   f i=1:1:colcnt d
	   .s colname=xs.GetColumnName(i)
	   .;s tabRowid=$o(^DHCSSTabField(0,"TF",tab,colname,""))
	   .;s:tabRowid'="" colname=$p(^DHCSSTabField(tabRowid),"^",3)
	   .s data=xs.GetData(i)
	   .s ColDataStr=$c(34)_colname_$c(34)_":"_$c(34)_data_$c(34)
	   .i i=1 s result=result_ColDataStr
	   .e  s result=result_","_ColDataStr
	}
	s result=result_"}"
	d xs.Close()
	q result
}

Storage Custom
{
<Type>%Library.CompleteCustomStorage</Type>
}

}
