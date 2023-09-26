Class web.DHCSTMHUI.Common.JsonObj Extends web.DHCSTMHUI.Common.DataStore [ ClassType = serial, LegacyInstanceContext, Not ProcedureBlock ]
{

/// 调用时,使用d obj.getJsonData(***,***,...)
/// csp中需调用需改w为d
Method getJsonData(mapping As %String, count As %Integer, deli As %String = "^", result As %String = "total", root As %String = "rows", foot As %String = "footer", foottitle As %String = "", footdata As %String = "") As %String
{
	n (mapping,count,deli,result,root,foot,foottitle,footdata,%this)
	s:deli="" deli="^"
	s:result="" result="total"
	s:root="" root="rows"
	s:foot="" foot="footer"
	s ReturnJson=##class(%DynamicObject).%New()
	s RootJson=##class(%DynamicArray).%New()
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s cols = $l(mapping,deli)
	i cols > 0 d
	.s rows = ..RowCount()
	.i rows > 0 d
	..f i=1:1:rows d
	...s RowJson=##class(%DynamicObject).%New()
	...s temp = ..GetRowData(i)
	...f j=1:1:cols d
	....s colMapping=$p(mapping,deli,j)
	....s colTemp=$p(temp,deli,j)
	....s CheckJsonFlag=((colTemp'="")&&(($e(colTemp,1)="{")||($e(colTemp,1)="[")))
	....i CheckJsonFlag s Sc=PJObj.%FromJSON(colTemp)
	....s isObject=(CheckJsonFlag&&(Sc=0))
	....;当object时,不进行转义,输出不拼接双引号
	....if isObject s colTemp=##class(%DynamicObject).%FromJSON(colTemp)
	....else  s colTemp =..FormatColValue(colTemp)
	....s colType="string"
	....i colMapping[":" s colType=$zcvt($p(colMapping,":",2),"L"),colMapping=$p(colMapping,":",1)
	....i ((colType'="number")||((colType="number")&&(+colTemp'=colTemp))) s colType="string"
	....d RowJson.%Set(colMapping,colTemp,colType)
	...d RootJson.%Push(RowJson)
	i foottitle'="" d
	.s FootJson=##class(%DynamicArray).%New()
	.s FootJsonSc=1,FootJsonObj=##class(%DynamicObject).%New()
	.s FootJsonStr = ##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(footdata,foottitle)
	.s CheckJsonFlag=((FootJsonStr'="")&&(($e(FootJsonStr,1)="{")||($e(FootJsonStr,1)="[")))
	.i CheckJsonFlag s FootJsonSc=PJObj.%FromJSON(FootJsonStr)
	.if (CheckJsonFlag&&(FootJsonSc=0)) s FootJsonObj=##class(%DynamicObject).%FromJSON(FootJsonStr)
	.d FootJson.%Push(FootJsonObj)
	.d ReturnJson.%Set(foot,FootJson)
	d ReturnJson.%Set(root,RootJson)
	d ReturnJson.%Set(result,count)
	w ReturnJson.%ToJSON()
	q ""
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
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Response=##class(%GlobalCharacterStream).%New()
	s sc=Response.Write("{"_$c(34)_root_$c(34)_":[")
	s cols = $l(mapping,deli)
	i cols > 0 d
	.s rows = ..RowCount()
	.i rows > 0 d
	..f i=1:1:rows d
	...i i=1 d Response.Write("{")
	...e  d Response.Write(",{") 
	...s temp=..GetRowData(i)
	...f j=1:1:cols d
	....s colMapping=$p(mapping,deli,j)
	....s colTemp=$p(temp,deli,j)
	....
	....s CheckJsonFlag=((colTemp'="")&&(($e(colTemp,1)="{")||($e(colTemp,1)="[")))
	....i CheckJsonFlag s Sc=PJObj.%FromJSON(colTemp)
	....s isObject=(CheckJsonFlag&&(Sc=0))
	....
	....i j'=1 d Response.Write(",")
	....i isObject d Response.Write($c(34)_colMapping_$c(34)_":"_colTemp)
	....e  d Response.Write($c(34)_colMapping_$c(34)_":"_$c(34)_..FormatColValue(colTemp)_$c(34))
	...s sc=Response.Write("}")
	d Response.Write("],"_$c(34)_result_$c(34)_":"_success_"}")
	q Response
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
	q $tr(str,$c(13,10,0,9))
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
	...s temp=$tr(..GetRowData(i),$c(13,10,0,9))
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
	i ($ISVALIDNUM(val)&&(+val=val)) d
	.s tmpVal=$s(val<0:-val,1:val)
	.s:($e(tmpVal,1)=".") val=$tr($fn(val,","),",")		;数字格式处理 .5-->0.5, -.5-->-0.5
	s val=$tr(val,$c(13,10,0,9))
	q val
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
