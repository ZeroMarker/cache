/// Creator: 王赢赢
/// CreatDate: 2009-12-10
/// Description: 单位
Class dhc.ca.cache.udata.uAccPeriods Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Creator: 王赢赢
/// CreatDate: 2009-12-10
/// Description: 代码是否存在
/// Table：dhc.ca.cache.data.AccPeriods
/// Input: code-代码
/// Output: 
/// Return: 不存在返回0,存在返回所在行号
/// Others:w ##class(dhc.ca.cache.udata.uAccPeriods).IfRep(1,3,2)
ClassMethod IfRep(parRef, periodDr, monthDr) As %String
{
	n (parRef, periodDr, monthDr)
	s rowid=0
	s tmpMon=""
	f  q:(rowid="")||(monthDr=tmpMon)  d
	.s rowid=$o(^DHCCAACCOUNTMONTHS(0,"Period",parRef,periodDr,rowid))
	.i rowid'="" d
	..s tmpMon = $p(^DHCCAACCOUNTMONTHS(parRef,"Periods",rowid),"^",2)
	i rowid="" d  s rowid=0
	q rowid
}

/// Creator：王赢赢
/// CreatDate：2009-12-10
/// Description: 插入一条新数据
/// Table：dhc.ca.cache.data.AccPeriods
/// Input：
/// Output：
/// Return：返回执行插入语句后的SQLCODE
/// Others：w ##class(dhc.ca.cache.udata.uAccPeriods).InsertRec(1,1,1)
ClassMethod InsertRec(parRef, periodDr, monthDr) As %String
{
	
	n (parRef, periodDr, monthDr)
	
	//s rowid=0
	//s rowid=..IfRepCode(code)
	//q:rowid>0 "RepCode"
	//s rowid=..IfRepName(name)
	//q:rowid>0 "RepName"
	
	//zjw 20160816  对四个区间限制只能添加一个核算月------ 17、18、19、20  '本期'、'上期'、'去年同期'、'本年首月'
	s nums=0,a=0
	&sql(select count(*) into :nums FROM dhc_ca_cache_data.AccPeriods where AccPeriods_parRef=:parRef and AccPeriods_periodDr=:periodDr and AccPeriods_childSub>0)
	s a=$F("-17-18-19-20-","-"_periodDr_"-")
	q:(a>0)&&(nums>0) "该核算周期此区间已添加核算月，请修正后再试！"
	
	&sql(insert into dhc_ca_cache_data.AccPeriods (AccPeriods_parRef,AccPeriods_periodDr,AccPeriods_monthDr) values(:parRef, :periodDr, :monthDr))
	q SQLCODE
}

/*
/// Creator：王赢赢
/// CreatDate：2009-12-10
/// Description: 更新记录
/// Table：dhc.ca.cache.data.AccPeriods
/// Input：
/// Output：
/// Return：否则返回执行更新语句后的SQLCODE
/// Others：w ##class(dhc.ca.cache.udata.uAccPeriods).UpdateRec(1,4,"name4","N")
ClassMethod UpdateRec(rowId, code, name, active) As %String
{
	
	n (rowId, code, name, active)
	
	s tmpRowid=0
	s tmpRowid=..IfRepCode(code)
	q:(tmpRowid'=0)&(tmpRowid'=rowId) "RepCode"
	s tmpRowid=..IfRepName(name)
	q:(tmpRowid'=0)&(tmpRowid'=rowId) "RepName"
	
	s shortcut =code_"-"_name
	
	&sql(update dhc_ca_cache_data.AccPeriods set AccPeriods_code=:code,AccPeriods_name=:name,AccPeriods_shortcut=:shortcut,AccPeriods_active=:active where %ID=:rowId)
	q SQLCODE
}
*/
/// Creator: 王赢赢
/// CreatDate: 2009-12-10
/// Description: 删除记录
/// Table：dhc.ca.cache.data.AccPeriods
/// Input：rowId-数据行号
/// Output: 
/// Return: 返回执行删除语句后的SQLCODE
/// Others: w ##class(dhc.ca.cache.udata.uAccPeriods).DelRec("2||1")
ClassMethod DelRec(rowId) As %String
{
	&SQL(DELETE FROM dhc_ca_cache_data.AccPeriods WHERE %ID=:rowId)
	q SQLCODE
}

/// Creator: 王赢赢
/// CreatDate: 2009-12-10
/// Description: 查询符合条件的记录
/// Table：dhc.ca.cache.data.AccPeriods
/// Input: active-有效标志,searchField-查询字段,searchValue-查询值,sortField-排序字段,sortDir-排序方向,Start-起始行,Limit-行数
/// Output: 
/// Return: 返回查询到的记录的Json串
/// Others: w ##class(dhc.ca.cache.udata.uAccPeriods).ListRec(1,1,"","","","",0,25)
ClassMethod ListRec(parRef, periodDr, searchField, searchValue, sortField, sortDir, start, limit)
{
	n (parRef, periodDr, searchField, searchValue, sortField, sortDir, start, limit)
	
	s sqlStr="SELECT AccPeriods_rowid,AccPeriods_parRef,AccPeriods_periodDr,AccPeriods_monthDr FROM dhc_ca_cache_data.AccPeriods"
	
	s whereStr=" WHERE AccPeriods_parRef="_parRef_" AND AccPeriods_periodDr="_periodDr
	s sortStr=""
	s sortField1=""
	
	i sortField'="" d
	.i sortField="month" s sortField1="AccPeriods_monthDr"
		
	i sortField1'="" d
	.s sortDir=$ZCONVERT(sortDir,"u")
	.i (sortDir="DESC")||(sortDir="ASC") s sortStr=" ORDER BY "_sortField1_" "_sortDir
	.e  s sortStr=" ORDER BY "_sortField1_" ASC"
	e  d
	.s sortStr=" ORDER BY AccPeriods_rowid DESC"
	
	s sqlStr=sqlStr_whereStr_sortStr

	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	
	s count=0
	s resultString=""
	s end = start + limit - 1
	
	s json=##class(dhc.ca.cache.comm.JsonObj).%New()
	
	s jsonTitle="rowid^parRef^periodDr^monthDr^monthCode^monthName^monthStart^monthEnd"
	
	While(result.Next())
	{
		s rowid = result.Data("AccPeriods_rowid")
		s parRef = result.Data("AccPeriods_parRef")
		s periodDr = result.Data("AccPeriods_periodDr")
		s monthDr = result.Data("AccPeriods_monthDr")
		s monthCode = $p(^DHCCAACCOUNTMONTHS(monthDr),"^",1)
		s monthName = $p(^DHCCAACCOUNTMONTHS(monthDr),"^",2)
		s monthStart = $p(^DHCCAACCOUNTMONTHS(monthDr),"^",4)
		s monthEnd = $p(^DHCCAACCOUNTMONTHS(monthDr),"^",5)
		
		s tmp=rowid_"^"_parRef_"^"_periodDr_"^"_monthDr_"^"_monthCode_"^"_monthName_"^"_monthStart_"^"_monthEnd
		
		i (count>=start)&(count<=end) d
		.d json.InsertRowData(tmp)
		s count=count+1
	}
	d result.Close()
	s resultString = json.getJsonData(jsonTitle,count)
 	k json
	q resultString
}

/// Creator: 王赢赢
/// CreatDate: 2009-12-11
/// Description: 查询符合条件的记录
/// Table：dhc.ca.cache.data.AccPeriods
/// Input: active-有效标志,searchField-查询字段,searchValue-查询值,sortField-排序字段,sortDir-排序方向,Start-起始行,Limit-行数
/// Output: 
/// Return: 返回查询到的记录的Json串
/// Others: w ##class(dhc.ca.cache.udata.uAccPeriods).UnlistRec(1,1,"","","monthDr","DESC",0,25)
ClassMethod UnlistRec(parRef, periodDr, searchField, searchValue, sortField, sortDir, start, limit)
{
   ;q parRef_"^"_periodDr_"^"_searchField_"^"_searchValue_"^"_sortField_"^"_sortDir_"^"_start_"^"_limit
	n (parRef, periodDr, searchField, searchValue, sortField, sortDir, start, limit)
	s tmpMons = "("
	s subrowid = 1
	s tmpM = ""
	f  q:subrowid=""  d
	.s subrowid=$o(^DHCCAACCOUNTMONTHS(0,"Period",parRef,periodDr,subrowid))
	
	.i subrowid="" d
	.e  i tmpMons = "(" d
	..s tmpM = $p(^DHCCAACCOUNTMONTHS(parRef,"Periods",subrowid),"^",2)
	..s tmpMons = tmpMons _ tmpM
	.e  d
	..s tmpM = $p(^DHCCAACCOUNTMONTHS(parRef,"Periods",subrowid),"^",2)
	..s tmpMons = tmpMons _","_ tmpM
	s tmpMons = tmpMons_")"
	//q tmpMons
	s sqlStr="SELECT AccountMonths_rowid,AccountMonths_code,AccountMonths_name,AccountMonths_desc,AccountMonths_start,AccountMonths_end,AccountMonths_dataFinish,AccountMonths_treatFinish,AccountMonths_tieOff,AccountMonths_remark FROM dhc_ca_cache_data.AccountMonths "
	s whereStr=" WHERE %ID>0 "
	s others = ""
	i tmpM '= "" d
	.s others = " AND AccountMonths_rowid NOT IN "_tmpMons
	s sqlStr=sqlStr_whereStr_others
	
	//q sqlStr

	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	s count=0
	s resultString=""
	s end = start + limit - 1
	
	s json=##class(dhc.ca.cache.comm.JsonObj).%New()
	
	s jsonTitle="monthDr^monthCode^monthName^monthStart^monthEnd"
	
	While(result.Next())
	{
		s monthDr = result.Data("AccountMonths_rowid")
		s monthCode = result.Data("AccountMonths_code")
		s monthName = result.Data("AccountMonths_name")
		s monthStart = result.Data("AccountMonths_start")
		s monthEnd = result.Data("AccountMonths_end")
		
		s tmp=monthDr_"^"_monthCode_"^"_monthName_"^"_monthStart_"^"_monthEnd
		i (count>=start)&(count<=end) d
		.d json.InsertRowData(tmp)
		s count=count+1
	}
	d result.Close()
	s resultString = json.getJsonData(jsonTitle,count)
 	k json
	q resultString
}

/// Creator: 王赢赢
/// CreatDate: 2009-12-11
/// Description: 复制其它月份数据
/// Table: dhc.ca.cache.data.AccPeriods
/// Input：oldMon,newMon,itemDr
/// Output: 
/// Return: 返回执行删除语句后的SQLCODE
/// Others: w ##class(dhc.ca.cache.udata.uParamDatas).copyOtherMon(1,2,1,1)
ClassMethod copyOtherMon(oldMon, newMon) As %String
{
	n (oldMon,newMon)
	s sqlStr="SELECT AccPeriods_rowid,AccPeriods_parRef,AccPeriods_childSub,AccPeriods_periodDr,AccPeriods_monthDr FROM dhc_ca_cache_data.AccPeriods"
	s whereStr=" WHERE AccPeriods_parRef="_oldMon
	s sqlStr=sqlStr_whereStr
	s num=0
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	While(result.Next())
	{	
		i result.Data("AccPeriods_childSub")'=0 d
		.s periodDr = result.Data("AccPeriods_periodDr")
		.s monthDr = result.Data("AccPeriods_monthDr")
		.s tmpR=0
		.s tmpR=..IfRep(newMon, periodDr, monthDr)
		.i tmpR=0 d
		..s num=num+1
		..&sql(insert into dhc_ca_cache_data.AccPeriods (AccPeriods_parRef,AccPeriods_periodDr,AccPeriods_monthDr) values(:newMon, :periodDr, :monthDr))
	}
	q num
}

Storage Default
{
<StreamLocation>^dhc.ca.c.uAccPeriodsS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
