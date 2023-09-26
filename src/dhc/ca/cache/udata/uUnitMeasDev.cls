/// Creator: 王赢赢
/// CreatDate: 2009-10-14
/// Description: 单位计量表计
Class dhc.ca.cache.udata.uUnitMeasDev Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Creator: 王赢赢
/// CreatDate: 2009-10-14
/// Description: 代码是否存在
/// Table：dhc.ca.cache.data.UnitMeasDev
/// Input: code-代码,unitDr-单位dr,dataItemDr
/// Output: 
/// Return: 不存在返回0,存在返回所在行号
/// Others:w ##class(dhc.ca.cache.udata.uUnitMeasDev).IfRepCode(2,"1")
ClassMethod IfRepCode(unitDr, dataItemDr, code) As %String
{
	n (unitDr,dataItemDr,code)
	s rowid=0
	s rowid=$o(^DHCCAUNITMEASDEV(0,"UnitDataitemCode",unitDr,dataItemDr,code,rowid))
	i rowid="" d  s rowid=0
	q rowid
}

/// Creator: 王赢赢
/// CreatDate: 2009-10-14
/// Description: 序号是否存在
/// Table：dhc.ca.cache.data.UnitMeasDev
/// Input: order-序号,unitDr-单位dr
/// Output: 
/// Return: 不存在返回0,存在返回所在行号
/// Others:w ##class(dhc.ca.cache.udata.uUnitMeasDev).IfRepOrder(2,"1")
ClassMethod IfRepOrder(unitDr, dataItemDr, order) As %String
{
	n (unitDr,dataItemDr,order)
	s rowid=0
	s rowid=$o(^DHCCAUNITMEASDEV(0,"UnitDataitemOrder",unitDr,dataItemDr,order,rowid))
	i rowid="" d  s rowid=0
	q rowid
}

/// Creator：王赢赢
/// CreatDate：2009-10-14
/// Description: 插入一条新单位单位计量表计数据
/// Table：dhc.ca.cache.data.UnitMeasDev
/// Input：code-代码;remark-备注;start-开始;stop-结束;unitDr-单位Dr;active-有效;
/// Output：
/// Return：返回执行插入语句后的SQLCODE
/// Others：w ##class(dhc.ca.cache.udata.uUnitMeasDev).InsertRec(1,1,1,1,"remark","2009-09-25","2009-09-25","")
ClassMethod InsertRec(unitDr, dataItemDr, order, code, remark, start, stop, active) As %String
{
	
	n (unitDr, dataItemDr, order, code, remark, start, stop, active)
	
	s rowid=0
	s rowid=..IfRepCode(unitDr,dataItemDr,code)
	q:rowid>0 "RepCode"
	
	s rowid=0
	s rowid=..IfRepOrder(unitDr,dataItemDr,order)
	q:rowid>0 "RepOrder"
	
	i start'="" s start=$zdh(start,3)
	i stop'="" s stop=$zdh(stop,3)
	
	i (active'="Y")||(active'="N") s active="Y"
	&sql(insert into dhc_ca_cache_data.UnitMeasDev (UnitMeasDev_unitDr,UnitMeasDev_dataItemDr,UnitMeasDev_order,UnitMeasDev_code,UnitMeasDev_remark,UnitMeasDev_start,UnitMeasDev_stop,UnitMeasDev_active) values(:unitDr, :dataItemDr, :order, :code, :remark, :start, :stop, :active))
	q SQLCODE
}

/// Creator：王赢赢
/// CreatDate：2009-10-14
/// Description: 更新记录
/// Table：dhc.ca.cache.data.UnitMeasDev
/// Input：rowId-所在行号;code-代码;remark-备注;start-开始;stop-结束;unitDr-单位Dr;active-有效;
/// Output：
/// Return：否则返回执行更新语句后的SQLCODE
/// Others：w ##class(dhc.ca.cache.udata.uUnitMeasDev).UpdateRec(1,1,1,1,1,"","2009-09-25","2009-09-25","N")
ClassMethod UpdateRec(rowId, unitDr, dataItemDr, order, code, remark, start, stop, active) As %String
{
	
	n (rowId, unitDr, dataItemDr, order, code, remark, start, stop, active)
	
    s rowid=0
	s rowid=..IfRepCode(unitDr,dataItemDr,code)
	q:(rowid'=0)&(rowid'=rowId) "RepCode"
	s rowid=..IfRepOrder(unitDr,dataItemDr,order)
	q:(rowid'=0)&(rowid'=rowId) "RepOrder"
	
	i start'="" s start=$zdh(start,3)
	i stop'="" s stop=$zdh(stop,3)
	
	&sql(update dhc_ca_cache_data.UnitMeasDev set UnitMeasDev_unitDr=:unitDr,UnitMeasDev_dataItemDr=:dataItemDr,UnitMeasDev_order=:order,UnitMeasDev_code=:code,UnitMeasDev_remark=:remark,UnitMeasDev_start=:start,UnitMeasDev_stop=:stop,UnitMeasDev_active=:active where %ID=:rowId)
	q SQLCODE
}

/// Creator: 王赢赢
/// CreatDate: 2009-10-14
/// Description: 删除记录
/// Table：dhc.ca.cache.data.UnitMeasDev
/// Input：rowId-数据行号
/// Output: 
/// Return: 返回执行删除语句后的SQLCODE
/// Others: w ##class(dhc.ca.cache.udata.uUnitMeasDev).DelRec(1)
ClassMethod DelRec(rowId) As %String
{
	&SQL(DELETE FROM dhc_ca_cache_data.UnitMeasDev WHERE %ID=:rowId)
	q SQLCODE
}

/// Creator: 王赢赢
/// CreatDate: 2009-10-14
/// Description: 查询符合条件的记录
/// Table：dhc.ca.cache.data.UnitMeasDev
/// Input: unitDr-单位,active-有效标志,searchField-查询字段,searchValue-查询值,sortField-排序字段,sortDir-排序方向,Start-起始行,Limit-行数
/// Output: 
/// Return: 返回查询到的记录的Json串
/// Others: w ##class(dhc.ca.cache.udata.uUnitMeasDev).ListRec(1,1,"Y","","","","",0,25,"")
ClassMethod ListRec(unitDr, dataItemDr, active, searchField, searchValue, sortField, sortDir, start, limit, type)
{
	n (unitDr,dataItemDr,active, searchField, searchValue, sortField, sortDir, start, limit, type)
	
	s sqlStr="SELECT UnitMeasDev_rowid,UnitMeasDev_unitDr,UnitMeasDev_dataItemDr,UnitMeasDev_order,UnitMeasDev_code,UnitMeasDev_remark,UnitMeasDev_start,UnitMeasDev_stop,UnitMeasDev_active FROM dhc_ca_cache_data.UnitMeasDev"
	
	s whereStr=" WHERE %ID>0 AND UnitMeasDev_unitDr ="_unitDr_" AND UnitMeasDev_dataItemDr ="_dataItemDr
	i (active="Y")||(active="N") s whereStr=whereStr_" AND UnitMeasDev_active='"_active_"'"
	
	i (type=0) s whereStr=whereStr_" AND %ID not in(select MeasDevDepts_parRef from dhc_ca_cache_data.MeasDevDepts where %ID>0)"
	i (type>0) s whereStr=whereStr_" AND %ID in(select MeasDevDepts_parRef from dhc_ca_cache_data.MeasDevDepts where %ID>0 and MeasDevDepts_deptDr="_type_")"
	
	s sortStr=""
	s sortField1=""
	
	i sortField'="" d
	.i sortField="rowId" s sortField1="UnitMeasDev_rowid"
	.i sortField="code" s sortField1="UnitMeasDev_code"
	.i sortField="remark" s sortField1="UnitMeasDev_remark"
	.i sortField="startTime" s sortField1="UnitMeasDev_start"
	.i sortField="stop" s sortField1="UnitMeasDev_stop"
	.i sortField="order" s sortField1="UnitMeasDev_order"
	.i sortField="active" s sortField1="UnitMeasDev_active"
	
	i sortField1'="" d
	.s sortDir=$ZCONVERT(sortDir,"u")
	.i (sortDir="DESC")||(sortDir="ASC") s sortStr=" ORDER BY "_sortField1_" "_sortDir
	.e  s sortStr=" ORDER BY "_sortField1_" ASC"
	e  d
	.s sortStr=" ORDER BY %ID DESC"
	
	s sqlStr=sqlStr_whereStr_sortStr
	//q sqlStr
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	
	s count=0
	s resultString=""
	s end = start + limit - 1
	
	s json=##class(dhc.ca.cache.comm.JsonObj).%New()
	
	s jsonTitle="rowId^unitDr^dataItemDr^order^code^remark^startTime^stop^active"
	
	While(result.Next())
	{
		s rowId = result.Data("UnitMeasDev_rowid")
		s unitDr = result.Data("UnitMeasDev_unitDr")
		s dataItemDr = result.Data("UnitMeasDev_dataItemDr")
		s order = result.Data("UnitMeasDev_order")
		s code = result.Data("UnitMeasDev_code")
		s remark = result.Data("UnitMeasDev_remark")
		s startTime = result.Data("UnitMeasDev_start")
		s stop = result.Data("UnitMeasDev_stop")		
		s active = result.Data("UnitMeasDev_active")
		
		i startTime'="" s startTime=$zd(startTime,3)
		i stop'="" s stop=$zd(stop,3)
		
		s tmp=rowId_"^"_unitDr_"^"_dataItemDr_"^"_order_"^"_code_"^"_remark_"^"_startTime_"^"_stop_"^"_active
		//w searchValue
		i searchValue'="" d
		.i searchField = "active" d
		..i (searchValue="Y") || (searchValue="y") s searchValue="Y"
		..e  s searchValue="N"
		.q:(searchField = "order")&(order'[searchValue)
		.q:(searchField = "code")&(code'[searchValue)
		.q:(searchField = "remark")&(remark'[searchValue)
		.q:(searchField = "startTime")&(startTime'[searchValue)
		.q:(searchField = "stop")&(stop'[searchValue)
		.q:(searchField = "unitDr")&(unitDr'[searchValue)
		.q:(searchField = "active")&(active'[searchValue)
		.i (count>=start)&(count<=end) d
		..d json.InsertRowData(tmp)
		.s count=count+1
		e  d
		.i (count>=start)&(count<=end) d
		..d json.InsertRowData(tmp)
		.s count=count+1
	}
	d result.Close()
	s resultString = json.getJsonData(jsonTitle,count)
 	k json
	q resultString
}

Storage Default
{
<StreamLocation>^dhc.ca.c.uUnitMeasDevS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
