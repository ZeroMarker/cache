/// Creator: 李明忠
/// CreatDate: 2010-11-10
/// Description: 指标来源规则维护
Class dhc.pa.udata.uOutKpiRule Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Creator:李明忠
/// CreatDate:2010-11-10
/// Description:查询接口套记录
/// Table:dhc_pa_inter.InterLocSet
/// Input:searchField-查询字段;searchValue-查询值;sortField-排序字段;sortDir-排序方向;start-起始行;limit-行数
/// Output:
/// Return:返回查询到的记录的Json串
/// Others:w ##class(dhc.pa.udata.uOutKpiRule).LocSetList("","","rowid","ASC",0,25)
ClassMethod LocSetList(searchField, searchValue, sortField, sortDir, start, limit) As %String
{
	n (searchField, searchValue, sortField, sortDir, start, limit)

	s sqlStr="select InterLocSet_rowid,InterLocSet_order,InterLocSet_code,InterLocSet_name,InterLocSet_shortcut,InterLocSet_desc,InterLocSet_active from dhc_pa_inter.InterLocSet where %ID>0 and InterLocSet_active='Y'"
	s sortStr=""
	s sortField1=""
	
	i sortField'="" d
	.i sortField="rowid" s sortField1="InterLocSet_rowid"
	.i sortField="order" s sortField1="InterLocSet_order"
	.i sortField="code" s sortField1="InterLocSet_code"
	.i sortField="name" s sortField1="InterLocSet_name"
	.i sortField="shortcut" s sortField1="InterLocSet_shortcut"
	.i sortField="desc" s sortField1="InterLocSet_desc"
	.i sortField="active" s sortField1="InterLocSet_active"
	
	i sortField1'="" d
	.s sortDir=$ZCONVERT(sortDir,"u")
	.i (sortDir="DESC")||(sortDir="ASC") s sortStr=" ORDER BY "_sortField1_" "_sortDir
	.e  s sortStr=" ORDER BY "_sortField1_" DESC"
	e  d
	.s sortStr=" ORDER BY %ID ASC"
	
	s sqlStr=sqlStr_sortStr
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	
	s count=0
	s resultString=""
	s end=start+limit-1
	
	s json=##class(dhc.pa.comm.JsonObj).%New()
	s jsonTitle="rowid^order^code^name^shortcut^desc^active"
	
	While(result.Next()){
		s rowid=result.Data("InterLocSet_rowid")
		s order=result.Data("InterLocSet_order")
		s code=result.Data("InterLocSet_code")
		s name=result.Data("InterLocSet_name")
		s shortcut=result.Data("InterLocSet_shortcut")
		s desc=result.Data("InterLocSet_desc")
		s active=result.Data("InterLocSet_active")
		
		s tmp=rowid_"^"_order_"^"_code_"^"_name_"^"_shortcut_"^"_desc_"^"_active
		
		i searchValue'="" d
		.i searchField = "active" d
		..i (searchValue="Y") || (searchValue="y") s searchValue="Y"
		..e  s searchValue="N"
		.i searchField = "flag" d
		..i (searchValue="Y") || (searchValue="y") s searchValue="Y"
		..e  s searchValue="N"
		.q:(searchField = "code")&(code'[searchValue)
		.q:(searchField = "name")&(name'[searchValue)
		.q:(searchField = "desc")&(desc'[searchValue)
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

/// Creator:李明忠
/// CreatDate:2010-11-10
/// Description:查询指标记录
/// Table:dhc_pa_inter.OutKpiRule
/// Input:locSetDr-接口套rowid;searchField-查询字段;searchValue-查询值;sortField-排序字段;sortDir-排序方向;start-起始行;limit-行数
/// Output:
/// Return:返回查询到的记录的Json串
/// Others:w ##class(dhc.pa.udata.uOutKpiRule).OutKpiList(1,"name","出","","",0,10)
ClassMethod OutKpiList(locSetDr, searchField, searchValue, sortField, sortDir, start, limit) As %String
{
	n (locSetDr,searchField,searchValue,sortField,sortDir,start,limit)

	s sqlStr="select OutKpiRule_rowid,OutKpiRule_outKpiCode,OutKpiRule_outKpiName,OutKpiRule_inLocSetDr,OutKpiRule_active from dhc_pa_inter.OutKpiRule where %ID>0 and OutKpiRule_inLocSetDr='"_locSetDr_"'"
	
	s sortStr=""
	s sortField1=""
	
	i sortField'="" d
	.i sortField="rowid" s sortField1="OutKpiRule_rowid"
	.i sortField="code" s sortField1="OutKpiRule_outKpiCode"
	.i sortField="name" s sortField1="OutKpiRule_outKpiName"
	.i sortField="inLocSetName" s sortField1="OutKpiRule_inLocSetDr"
	.i sortField="active" s sortField1="OutKpiRule_active"
	
	i sortField1'="" d
	.s sortDir=$ZCONVERT(sortDir,"u")
	.i (sortDir="DESC")||(sortDir="ASC") s sortStr=" ORDER BY "_sortField1_" "_sortDir
	.e  s sortStr=" ORDER BY "_sortField1_" DESC"
	e  d
	.s sortStr=" ORDER BY %ID ASC"
	
	s sqlStr=sqlStr_sortStr
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	
	s count=0
	s resultString=""
	s end=start+limit-1
	
	s json=##class(dhc.pa.comm.JsonObj).%New()
	s jsonTitle="rowid^code^name^inLocSetDr^inLocSetName^active"
	
	While(result.Next()){
		s inLocSetName=""
		s rowid=result.Data("OutKpiRule_rowid")
		s code=result.Data("OutKpiRule_outKpiCode")
		s name=result.Data("OutKpiRule_outKpiName")
		
		s inLocSetDr=result.Data("OutKpiRule_inLocSetDr")
		i inLocSetDr'="" d
		.i $D(^DHCCJXPAINTERLOCSET(inLocSetDr)) d
		..i $G(^DHCCJXPAINTERLOCSET(inLocSetDr))'="" d
		...s inLocSetName=$P(^DHCCJXPAINTERLOCSET(inLocSetDr),"^",3)
		
		s active=result.Data("OutKpiRule_active")
		
		s tmp=rowid_"^"_code_"^"_name_"^"_inLocSetDr_"^"_inLocSetName_"^"_active
		
		i searchValue'="" d
		.i searchField = "active" d
		..i (searchValue="Y") || (searchValue="y") s searchValue="Y"
		..e  s searchValue="N"
		.q:(searchField = "code")&(code'[searchValue)
		.q:(searchField = "name")&(name'[searchValue)
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

/// Creator：李明忠
/// CreatDate：2010-11-10
/// Description: 判断同一接口套下是否存在同一外部指标记录
/// Table：
/// Input：locSetDr-接口套rowid;code-外部指标代码
/// Output：
/// Return：返回tempRowid
/// Others：w ##class(dhc.pa.udata.uOutKpiRule).IfRepRecode(2,"zsr")
ClassMethod IfRepRecode(locSetDr, code) As %String
{
	n (locSetDr,code)
	
	s RowId=0,tempRowid=0
	s RowId=$o(^DHCCJXPAOUTKPIRULE(0,"OutKpiCode",code,RowId))
	i RowId="" d  
	.s tempRowid=0
	e  d
	.s LocSetDr=$P(^DHCCJXPAOUTKPIRULE(RowId),"^",3)
	.i LocSetDr=locSetDr d
	..s tempRowid=RowId
	
	q tempRowid
}

/// Creator：李明忠
/// CreatDate：2010-11-10
/// Description: 判断同一接口套下是否存在同一外部指标记录
/// Table：
/// Input：locSetDr-接口套rowid;code-外部指标代码
/// Output：
/// Return：返回tempRowid
/// Others：w ##class(dhc.pa.udata.uOutKpiRule).IfRepRecode("101")
ClassMethod IfRepRecode1(code) As %String
{
	n (code)
	
	s RowId=0
	s RowId=$o(^DHCCJXPAOUTKPIRULE(0,"OutKpiCode",code,RowId))
	i RowId="" s RowId=0
	q RowId
}

/// Creator：李明忠
/// CreatDate：2010-11-10
/// Description: 为给定的接口套添加外部指标记录
/// Table：dhc_pa_inter.OutKpiRule
/// Input：locSetDr-接口套rowid;code-外部指标代码;name-外部指标名称
/// Output：
/// Return：返回SQLCODE
/// Others：w ##class(dhc.pa.udata.uOutKpiRule).Insert(1,1,"西药费")
ClassMethod Insert(locSetDr, code, name) As %String
{
	n (locSetDr,code,name)

	q:(..IfRepRecode(locSetDr,code))'=0 "RepRecode" 

	s active="Y"
	&SQL(insert into dhc_pa_inter.OutKpiRule(OutKpiRule_outKpiCode,OutKpiRule_outKpiName,OutKpiRule_inLocSetDr,OutKpiRule_active) VALUES(:code,:name,:locSetDr,:active))
	q SQLCODE
}

/// Creator：李明忠
/// CreatDate：2010-11-10
/// Description: 更新接口套下的外部指标记录
/// Table：dhc_pa_inter.OutKpiRule
/// Input：rowid-所在行号;locSetDr-接口套rowid;code-外部指标代码;name-外部指标名称;active-有效标志
/// Output：
/// Return：返回执行更新语句后的SQLCODE
/// Others：w ##class(dhc.pa.udata.uOutKpiRule).Update(2,2,"1","西药费","N")
ClassMethod Update(rowid, locSetDr, code, name, active) As %String
{
	n (rowid,locSetDr,code,name,active)
	
	q:rowid="" "rowidEmpt"	//错误数据
	
	s tempRowid=..IfRepRecode(locSetDr,code)
	q:(tempRowid'=0)&(tempRowid'=rowid) "RepRecode"
	
	&sql(update dhc_pa_inter.OutKpiRule set OutKpiRule_outKpiCode=:code,OutKpiRule_outKpiName=:name,OutKpiRule_inLocSetDr=:locSetDr,OutKpiRule_active=:active where %ID=:rowid)
	q SQLCODE
}

/// Creator:李明忠
/// CreatDate:2010-11-10
/// Description:删除接口套下的外部指标记录
/// Table:dhc_pa_inter.OutKpiRule
/// Input:rowid-外部指标记录rowid
/// Output: 
/// Return:返回执行删除语句后的SQLCODE
/// Others:w ##class(dhc.pa.udata.uOutKpiRule).Delete(4)
ClassMethod Delete(rowid) As %String
{
	n (rowid)
	
	&SQL(delete from dhc_pa_inter.OutKpiRule where OutKpiRule_rowid=:rowid)
	q SQLCODE
}

Storage Default
{
<StreamLocation>^dhc.pa.udata.uOutKpiRuleS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
