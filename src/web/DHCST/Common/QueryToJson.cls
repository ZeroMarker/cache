/// creator:    yunhaibao
/// createdate: 2017-06-26
/// description:统一json数据格式,不需要再单独拼串,直接写query即可
/// 			1.所有行数写在最后,第一节点均为数据
Class web.DHCST.Common.QueryToJson Extends %RegisteredObject [ Not ProcedureBlock ]
{

Parameter nullIndex = -999999;

/// creator:    yunhaibao
/// createdate: 2017-06-26
/// description:解析query统一入口
/// params:     plugin(插件名称),className(类名称),queryName(query名称),strParams(参数1|@|参数2)
/// w ##class(web.DHCST.Common.QueryToJson).Execute("EasyUI.DataGrid","web.DHCOutPhCode","FindPhWin","","1^30^^")
/// w ##class(web.DHCST.Common.QueryToJson).Execute("EasyUI.DataGrid","web.DHCST.PHCChemical","Query","^^^","1^30^chemicalDesc^desc")
ClassMethod Execute(plugin, className, queryName, strParams, pluginParams)
{
	n (plugin,className,queryName,strParams,pluginParams,%session)
	q:plugin="" "-1^插件名不能为空"
	q:className="" "-1^类名不能为空"
	q:queryName="" "-1^方法名不能为空"
	s pluginFrame=$p(plugin,".",1)
	s pluginName=$p(plugin,".",2)
	s split="|@|"
	s paramsCnt=$l(strParams,split)
	s resultSet=##class(%ResultSet).%New(className_":"_queryName)
	s exeStr="set %sc=$zobjmethod(resultSet,""Execute"""
	i strParams'=""  d
	.f i=1:1:paramsCnt  d 
	..s argName=$p(strParams,split,i)
	..s exeStr=exeStr_","_""""_argName_""""
	s exeStr=exeStr_")"
	// 执行Query
	x exeStr 
	i $d(%objlasterror) //错误信息
	i pluginFrame="Cache" // to do w ..EasyUI(resultSet,pluginName) 
	i pluginFrame="EasyUI" w ..EasyUI(resultSet,pluginName,pluginParams) 
	i pluginFrame="Ext" //to do
	d resultSet.%Close()
 	q ""
}

ClassMethod Ext()
{
}

ClassMethod EasyUI(RS, pluginName, pluginParams)
{
	n (pluginName,RS,pluginParams)
	i pluginName="ComboBox" w ..EasyUIComboBox(RS) 
	i pluginName="DataGrid" w ..EasyUIDataGrid(RS,pluginParams) 
	q ""
}

ClassMethod EasyUIComboBox(RS)
{
	n (RS)
	s columns=RS.GetColumnCount()
	s i=0,colNameStr=""
	f i=1:1:columns  d
	.s colNameStr=$s(colNameStr="":RS.GetColumnName(i),1:colNameStr_"^"_RS.GetColumnName(i))
	s count=0
	While(RS.Next())
	{ 
		s i=0,rowData=""
		f i=1:1:columns  d
		.s rowData=$s(rowData="":RS.GetData(i),1:rowData_"^"_RS.GetData(i))
		s count=count+1
		I count=1 d
		.w "["
		.W ##class(web.DHCSTJQUERYCOMMON).getJsonData(colNameStr,rowData)
		e  d
		.W ","_##class(web.DHCSTJQUERYCOMMON).getJsonData(colNameStr,rowData)
	}
	i count>0 w "]"
	q:count=0 "[]" 
	q ""
}

ClassMethod EasyUIDataGrid(RS, pluginParams)
{
	n (RS,pluginParams)
	s page=$p(pluginParams,"^",1)
	s rows=$p(pluginParams,"^",2)
	s sort=$p(pluginParams,"^",3)
	s order=$p(pluginParams,"^",4)
	i page="" s page=1
	i rows="" s rows=9999
	s endRow=page*rows  
	s startRow=((page-1)*rows)+1 
	s columns=RS.GetColumnCount()
	s colNameStr="",sortColNum="",sortColData=""
	s i=0
	f i=1:1:columns  d
	.s colName=RS.GetColumnName(i)
	.i colName=sort s sortColNum=i
	.s colNameStr=$s(colNameStr="":colName,1:colNameStr_"^"_colName)
	s key=""
	While(RS.Next())
	{ 
		s i=0,rowData=""
		f i=1:1:columns  d
		.s cellData=RS.GetData(i)
		.i i=sortColNum d
		..i cellData'="" s sortColData=cellData
		..e  s sortColData=..#nullIndex
		.s rowData=$s(rowData="":cellData,1:rowData_"^"_cellData)
		i sortColData="" s sortColData=..#nullIndex
		///排序
		s key=key+1
		s SortDataSet(sortColData,key)=rowData
	}
	s order=$s($zcvt(order,"U")="DESC":-1,1:1)
	s writed=""
	s count=0,i=0
	s sortColData=""
	f  s sortColData=$o(SortDataSet(sortColData),order)  q:sortColData=""  d
	.s i=""
	.f  s i=$o(SortDataSet(sortColData,i),order)  q:i=""  d
	..s count=count+1
	..q:count<startRow
    ..q:count>endRow
	..s outputData=SortDataSet(sortColData,i)
	..i count=startRow d
	...w ..StartSign("EasyUI.DataGrid")
	...w ##class(web.DHCSTJQUERYCOMMON).getJsonData(colNameStr,outputData)
	..e  d
	...w ","
	...w ##class(web.DHCSTJQUERYCOMMON).getJsonData(colNameStr,outputData)
	..s writed=1
	i writed'="" w ..EndSign("EasyUI.DataGrid",count) q ""
	w ##class(web.DHCSTJQUERYCOMMON).getJsonEmptySign(0)
	q ""
}

/// description: 开始符
/// w ##class(web.DHCST.Common.QueryToJson).StartSign("EasyUI.DataGrid")
ClassMethod StartSign(plugin)
{
	n (plugin)
	s startSign=""
	i plugin="EasyUI.DataGrid" s startSign="{""rows"":["
	q startSign
}

/// description: 结束符
/// w ##class(web.DHCST.Common.QueryToJson).EndSign("EasyUI.DataGrid",999)
ClassMethod EndSign(plugin, total)
{
	n (plugin,total)
	s endSign=""
	i plugin="EasyUI.DataGrid" s endSign="],""total"":"""_total_"""}"
	q endSign
}

}
