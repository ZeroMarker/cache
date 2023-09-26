/// Creator: Zhao LiGuo
/// CreatDate: 2010-11-10
/// Description: 指标来源规则维护
Class dhc.bonus.udata.uOutKpiRule Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Creator:Zhao LiGuo
/// CreatDate:2010-11-10
/// Description:查询接口套记录
/// Table:dhc_bonus_inter.InterLocSet
/// Input:searchField-查询字段;searchValue-查询值;sortField-排序字段;sortDir-排序方向;start-起始行;limit-行数
/// Output:
/// Return:返回查询到的记录的Json串
/// Others:w ##class(dhc.bonus.udata.uOutKpiRule).LocSetList("type","1","","",0,25)
ClassMethod LocSetList(searchField, searchValue, sortField, sortDir, start, limit) As %String
{
	n (searchField, searchValue, sortField, sortDir, start, limit)

	s sqlStr="select InterLocSet_rowid,InterLocSet_order,InterLocSet_code,InterLocSet_name,"
	_" InterLocSet_shortcut,InterLocSet_desc,InterLocSet_active,InterLocSet_type from dhc_bonus_inter.InterLocSet "
	_" where %ID>0 and InterLocSet_active='Y'"
	
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
	;w sqlStr,!
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	
	s count=0
	s resultString=""
	s end=start+limit-1
	
	s json=##class(dhc.bonus.comm.JsonObj).%New()
	s jsonTitle="rowid^order^code^name^shortcut^desc^active"
	
	While(result.Next()){
		s rowid=result.Data("InterLocSet_rowid")
		s order=result.Data("InterLocSet_order")
		s code=result.Data("InterLocSet_code")
		s name=result.Data("InterLocSet_name")
		s shortcut=result.Data("InterLocSet_shortcut")
		s desc=result.Data("InterLocSet_desc")
		s active=result.Data("InterLocSet_active")
		s type=result.Data("InterLocSet_type")
		
		s tmp=rowid_"^"_order_"^"_code_"^"_name_"^"_shortcut_"^"_desc_"^"_active
		/*
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
		.q:(searchField = "type")&(type'[searchValue)
		.i (count>=start)&(count<=end) d
		..d json.InsertRowData(tmp)
		.s count=count+1
		e  d
		*/
		i (count>=start)&(count<=end) d
		.d json.InsertRowData(tmp)
		s count=count+1
	}
	d result.Close()
	s resultString = json.getJsonData(jsonTitle,count)
 	k json
	q resultString
}

/// Creator:Zhao LiGuo
/// CreatDate:2010-11-10
/// Description:查询接口套记录
/// Table:dhc_bonus_inter.InterLocSet
/// Input:searchField-查询字段;searchValue-查询值;sortField-排序字段;sortDir-排序方向;start-起始行;limit-行数
/// Output:
/// Return:返回查询到的记录的Json串
/// Others:w ##class(dhc.bonus.udata.uOutKpiRule).LocSetSubList("TypeID","3","","",0,25)
ClassMethod LocSetSubList(searchField, searchValue, sortField, sortDir, start, limit) As %String
{
	n (searchField, searchValue, sortField, sortDir, start, limit)

	s sqlStr="select InterLocSet_rowid,InterLocSet_order,InterLocSet_code,InterLocSet_name,"
	_" InterLocSet_shortcut,InterLocSet_desc,InterLocSet_active,InterLocSet_type from dhc_bonus_inter.InterLocSet "
	_" where %ID>0  and InterLocSet_active='Y'"
		
	;i searchField="TypeID" d
	;.s sqlStr = sqlStr_" and InterLocSet_type="_searchValue
	s sqlStr = sqlStr_"  order by InterLocSet_code "
	//w sqlStr,!
	
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	
	s count=0
	s resultString=""
	s end=start+limit-1
	
	s json=##class(dhc.bonus.comm.JsonObj).%New()
	s jsonTitle="rowid^order^code^name^shortcut^desc^active"
	
	While(result.Next()){
		s rowid=result.Data("InterLocSet_rowid")
		s order=result.Data("InterLocSet_order")
		s code=result.Data("InterLocSet_code")
		s name=result.Data("InterLocSet_name")
		s shortcut=result.Data("InterLocSet_shortcut")
		s desc=result.Data("InterLocSet_desc")
		s active=result.Data("InterLocSet_active")
		s type=result.Data("InterLocSet_type")
		
		s tmp=rowid_"^"_order_"^"_code_"^"_name_"^"_shortcut_"^"_desc_"^"_active
		
		i (count>=start)&(count<=end) d
		.d json.InsertRowData(tmp)
		s count=count+1
	}
	d result.Close()
	s resultString = json.getJsonData(jsonTitle,count)
 	k json
	q resultString
}

/// Creator:zlg
/// CreatDate:2011-6-9
/// Description:查询指标记录
/// Table:dhc_bonus_inter.OutKpiRule
/// Input:locSetDr-接口套rowid;searchField-查询字段;searchValue-查询值;sortField-排序字段;sortDir-排序方向;start-起始行;limit-行数
/// Output:
/// Return:返回查询到的记录的Json串
/// Others:w ##class(dhc.bonus.udata.uOutKpiRule).OutKpiList(39,"","","","",0,25)
ClassMethod OutKpiList(locSetDr, searchField, searchValue, sortField, sortDir, start, limit) As %String
{
	n (locSetDr,searchField,searchValue,sortField,sortDir,start,limit)
	//
	s sqlStr="select OutKpiRule_rowid,OutKpiRule_outKpiCode,OutKpiRule_outKpiName,OutKpiRule_inLocSetDr,"_
	" OutKpiRule_inLocSetDr->InterLocSet_name , OutKpiRule_InterMethodDr->InterLocMethod_methodDesc,OutKpiRule_InterMethodDr as OutKpiRule_InterMethodDr,OutKpiRule_location,"_
	" OutKpiRule_active from dhc_bonus_inter.OutKpiRule where %ID>0 and OutKpiRule_inLocSetDr="_locSetDr
	
	s sortStr=""
	s sortField1=""
	
	i sortField'="" d
	.i sortField="rowid" s sortField1="OutKpiRule_rowid"
	.i sortField="code" s sortField1="OutKpiRule_outKpiCode"
	.i sortField="name" s sortField1="OutKpiRule_outKpiName"
	.i sortField="inLocSetName" s sortField1="OutKpiRule_inLocSetDr"
	.i sortField="methodDesc" s sortField1="OutKpiRule_InterMethodDr->InterLocMethod_methodDesc"
	.i sortField="location" s sortField1="OutKpiRule_location"
	
	.i sortField="active" s sortField1="OutKpiRule_active"
	
	i sortField1'="" d
	.s sortDir=$ZCONVERT(sortDir,"u")
	.i (sortDir="DESC")||(sortDir="ASC") s sortStr=" ORDER BY "_sortField1_" "_sortDir
	.e  s sortStr=" ORDER BY "_sortField1_" DESC"
	e  d
	.s sortStr=" ORDER BY %ID ASC"
	
	s sqlStr=sqlStr_sortStr
	s result=##class(%Library.ResultSet).%New()
	
   // w sqlStr,!
	d result.Prepare(sqlStr)
	d result.Execute()
   
  
	s count=0
	s resultString=""
	s end=start+limit-1
	
	s json=##class(dhc.bonus.comm.JsonObj).%New()
	s jsonTitle="rowid^code^name^inLocSetDr^inLocSetName^interMethodDr^methodDesc^location^active"
	
	While(result.Next()){
		s inLocSetName=""
		s rowid=result.Data("OutKpiRule_rowid")
		s code=result.Data("OutKpiRule_outKpiCode")
		s name=result.Data("OutKpiRule_outKpiName")
		
		s InterLocSetname=result.Data("InterLocSet_name")
		
		//s interMethodDr= 21 // result.Data("OutKpiRule_InterMethodDr")
		s interMethodDr = result.Data("OutKpiRule_InterMethodDr")
		
		s methodDesc=result.Data("InterLocMethod_methodDesc")
		s location=result.Data("OutKpiRule_location")
		
		s inLocSetDr=result.Data("OutKpiRule_inLocSetDr")
		i inLocSetDr'="" d
		.i $D(^DHCCJXPAINTERLOCSET(inLocSetDr)) d
		..i $G(^DHCCJXPAINTERLOCSET(inLocSetDr))'="" d
		...s inLocSetName=$P(^DHCCJXPAINTERLOCSET(inLocSetDr),"^",3)
		
		s active=result.Data("OutKpiRule_active")
		
		s tmp=rowid_"^"_code_"^"_name_"^"_inLocSetDr_"^"_inLocSetName_"^"_interMethodDr_"^"_InterLocSetname_"_"_methodDesc_"^"_location_"^"_active
		
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

/// Creator：Zhao LiGuo
/// CreatDate：2010-11-10
/// Description: 判断同一接口套下是否存在同一外部指标记录
/// Table：
/// Input：locSetDr-接口套rowid;code-外部指标代码
/// Output：
/// Return：返回tempRowid
/// Others：w ##class(dhc.bonus.udata.uOutKpiRule).IfRepRecode(2,"zsr")
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

/// Creator：Zhao LiGuo
/// CreatDate：2010-11-10
/// Description: 判断同一接口套下是否存在同一外部指标记录
/// Table：
/// Input：locSetDr-接口套rowid;code-外部指标代码
/// Output：
/// Return：返回tempRowid
/// Others：w ##class(dhc.bonus.udata.uOutKpiRule).IfRepRecode("101")
ClassMethod IfRepRecode1(code) As %String
{
	n (code)
	
	s RowId=0
	s RowId=$o(^DHCCJXPAOUTKPIRULE(0,"OutKpiCode",code,RowId))
	i RowId="" s RowId=0
	q RowId
}

/// Creator：Zhao LiGuo
/// CreatDate：2010-11-10
/// Description: 为给定的接口套添加外部指标记录
/// Table：dhc_bonus_inter.OutKpiRule
/// Input：locSetDr-接口套rowid;code-外部指标代码;name-外部指标名称
/// Output：
/// Return：返回SQLCODE
/// Others：w ##class(dhc.bonus.udata.uOutKpiRule).Insert(1,1,"西药费")
ClassMethod Insert(locSetDr, code, name, interMethodDr, order) As %String
{
	n (locSetDr,code,name,interMethodDr,order)

	q:(..IfRepRecode(locSetDr,code))'=0 "RepRecode" 

	s active="Y"
	&SQL(insert into dhc_bonus_inter.OutKpiRule(OutKpiRule_outKpiCode,OutKpiRule_outKpiName,OutKpiRule_inLocSetDr,OutKpiRule_InterMethodDr,OutKpiRule_location,OutKpiRule_active) VALUES(:code,:name,:locSetDr,:interMethodDr,:order,:active))
	q SQLCODE
}

/// Creator：Zhao LiGuo
/// CreatDate：2010-11-10
/// Description: 更新接口套下的外部指标记录
/// Table：dhc_bonus_inter.OutKpiRule
/// Input：rowid-所在行号;locSetDr-接口套rowid;code-外部指标代码;name-外部指标名称;active-有效标志
/// Output：
/// Return：返回执行更新语句后的SQLCODE
/// Others：w ##class(dhc.bonus.udata.uOutKpiRule).Update(2,2,"1","西药费","N")
ClassMethod Update(rowid, locSetDr, code, name, interMethodDr, order, active) As %String
{
	n (rowid,locSetDr,code,name,interMethodDr,order,active)
	
	q:rowid="" "rowidEmpt"	//错误数据
	
	s tempRowid=..IfRepRecode(locSetDr,code)
	q:(tempRowid'=0)&(tempRowid'=rowid) "RepRecode"
	
	&sql(update dhc_bonus_inter.OutKpiRule set OutKpiRule_outKpiCode=:code,OutKpiRule_outKpiName=:name,OutKpiRule_inLocSetDr=:locSetDr,OutKpiRule_InterMethodDr=:interMethodDr,OutKpiRule_location=:order,OutKpiRule_active=:active where %ID=:rowid)
	q SQLCODE
}

/// Creator:Zhao LiGuo
/// CreatDate:2010-11-10
/// Description:删除接口套下的外部指标记录
/// Table:dhc_bonus_inter.OutKpiRule
/// Input:rowid-外部指标记录rowid
/// Output: 
/// Return:返回执行删除语句后的SQLCODE
/// Others:w ##class(dhc.bonus.udata.uOutKpiRule).Delete(4)
ClassMethod Delete(rowid) As %String
{
	n (rowid)
	
	&SQL(delete from dhc_bonus_inter.OutKpiRule where OutKpiRule_rowid=:rowid)
	q SQLCODE
}

Storage Default
{
<StreamLocation>^dhc.bonus.udata.uOutKpiRuleS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
