/// Creator: 杨旭
/// CreatDate: 2009-9-15
/// Description: 核算月码表维护
Class dhc.ca.cache.udata.uAccountMonths Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Creator: 杨旭
/// CreatDate: 2009-9-15
/// Description: 代码是否存在
/// Table: dhc.ca.cache.data.AccountMonths
/// Input: code-代码
/// Output: 
/// Return: 不存在返回0,存在返回所在行号
/// Others: w ##class(dhc.ca.cache.udata.uDataTypes).IfRepCode("1001")
ClassMethod IfRepCode(code) As %String
{
	n (code)
	s rowid=0
	s rowid=$o(^DHCCAACCOUNTMONTHS(0,"Code",code,rowid))
	i rowid="" d  s rowid=0
	q rowid
}

/// Creator: 杨旭
/// CreatDate: 2009-9-15
/// Description: 名称是否存在
/// Table: dhc.ca.cache.data.AccountMonths
/// Input: name-名称
/// Output: 
/// Return: 不存在返回0,存在返回所在行号
/// Others: w ##class(dhc.ca.cache.udata.uDataTypes).IfRepName("工资费用")
ClassMethod IfRepName(name) As %String
{
	n (name)
	s rowid=0
	s rowid=$o(^DHCCAACCOUNTMONTHS(0,"Name",name,rowid))
	i rowid="" d  s rowid=0
	q rowid
}

/// Creator: 杨旭
/// CreatDate: 2009-9-15
/// Description: 插入新记录
/// Table: dhc.ca.cache.data.AccountMonths
/// Input: code-代码; name -名称; start-开始时间; end-结束时间; remark-备注;
/// Output: 
/// Return: 代码为空,返回"EmptyCode";代码存在,返回"RepCode";名称为空,返回"EmptyName";名称存在,返回"RepName";收入支出标志都选中,返回"InOut";执行SQL语句返回SQLCODE
/// Others: w ##class(dhc.ca.cache.udata.uAccountMonths).InsertRec("0001","测试区间","2009-09-01","2009-10-01","备注")
ClassMethod InsertRec(code, name, start, end, remark) As %String
{
	n (code, name, start, end, remark)
	
	q:code="" "EmptyCode"
	q:name="" "EmptyName"
	q:start="" "EmptyStart"
	q:end="" "EmptyEnd"
	
	//20160913 zjw 新加的核算周期名称的格式必须为YYYY-MM，否则返回名称格式错误，避免报表选年份查询时有误
	s namelen=$l(name,"-")
	q:namelen'=2 "NameformatError"
	
	s NameHeadlen=""
	s NameHead=$p(name,"-",1),NameTail=$p(name,"-",2)
	s NameHeadlen=$l(NameHead),NameTaillen=$l(NameTail)
	//年份必须在2000~3999之间，月份不能大于12
	q:(NameHeadlen'=4)||(NameTaillen'=2)||(NameHead>3999)||(NameHead<2000)||(NameTail>12) "NameformatError"
	
	s start=$zdh(start,3)
	s end=$zdh(end,3)
	s rowid=0
	s rowid=..IfRepCode(code)
	q:rowid>0 "RepCode"
	s rowid=..IfRepName(name)
	q:rowid>0 "RepName"
	s desc=code_"-"_name
	&SQL(INSERT INTO dhc_ca_cache_data.AccountMonths (AccountMonths_code,AccountMonths_name,AccountMonths_desc,AccountMonths_start,AccountMonths_end,AccountMonths_dataFinish,AccountMonths_treatFinish,AccountMonths_tieOff,AccountMonths_remark) VALUES (:code,:name,:desc,:start,:end,'N','N','N',:remark))
	q SQLCODE
}

/// Creator: 杨旭
/// CreatDate: 2009-9-15
/// Description: 查询符合条件的记录
/// Table: dhc.ca.cache.data.AccountMonths
/// Input: searchField-查询字段;searchValue-查询值;sortField-排序字段;sortDir-排序方向;Start-起始行;Limit-行数;dataFinish-数据采集标志;treatFinish-数据处理标志;tieOff-扎帐标志;
/// Output: 
/// Return: 返回查询到的记录的Json串
/// Others: w ##class(dhc.ca.cache.udata.uAccountMonths).ListRec("","","rowid","DESC",0,25,"","","")
ClassMethod ListRec(searchField, searchValue, sortField, sortDir, start, limit, dataFinish, treatFinish, tieOff)
{
	n (searchField, searchValue, sortField, sortDir, start, limit, dataFinish, treatFinish, tieOff)
	
	s sqlStr="SELECT AccountMonths_rowid,AccountMonths_code,AccountMonths_name,AccountMonths_desc,AccountMonths_start,AccountMonths_end,AccountMonths_dataFinish,AccountMonths_treatFinish,AccountMonths_tieOff,AccountMonths_remark FROM dhc_ca_cache_data.AccountMonths WHERE %ID>0"
	
	i (dataFinish="Y")||(dataFinish="N") s sqlStr=sqlStr_" AND AccountMonths_dataFinish='"_dataFinish_"'"
	i (treatFinish="Y")||(treatFinish="N") s sqlStr=sqlStr_" AND AccountMonths_treatFinish='"_treatFinish_"'"
	i (tieOff="Y")||(tieOff="N") s sqlStr=sqlStr_" AND AccountMonths_tieOff='"_tieOff_"'"
	
	s sortStr=""
	s sortField1=""
	
	i sortField'="" d
	.i sortField="rowid" s sortField1="AccountMonths_rowid"
	.i sortField="code" s sortField1="AccountMonths_code"
	.i sortField="name" s sortField1="AccountMonths_name"
	.i sortField="start" s sortField1="AccountMonths_start"
	.i sortField="end" s sortField1="AccountMonths_end"
	.i sortField="dataFinish" s sortField1="AccountMonths_dataFinish"
	.i sortField="treatFinish" s sortField1="AccountMonths_treatFinish"
	.i sortField="tieOff" s sortField1="AccountMonths_tieOff"
	.i sortField="remark" s sortField1="AccountMonths_remark"
	e  s sortField="AccountMonths_rowid"
	
	i sortField1'="" d
	.s sortDir=$ZCONVERT(sortDir,"u")
	.i (sortDir="DESC")||(sortDir="ASC") s sortStr=" ORDER BY "_sortField1_" "_sortDir
	.e  s sortStr=" ORDER BY "_sortField1_" ASC"
	e  d
	.s sortStr=" ORDER BY AccountMonths_rowid DESC"
	
	s sqlStr=sqlStr_sortStr
	
	s result=##class(%Library.ResultSet).%New()
	;w sqlStr
	d result.Prepare(sqlStr)
	d result.Execute()
	
	s count=0
	s resultString=""
	s end=start+limit
	
	s json=##class(dhc.ca.cache.comm.JsonObj).%New()
	s jsonTitle="rowid^code^name^desc^start^end^dataFinish^treatFinish^tieOff^remark"
	
	While(result.Next())
	{
		
		s rowid=result.Data("AccountMonths_rowid")
		s code=result.Data("AccountMonths_code")
		s name=result.Data("AccountMonths_name")
		s desc=result.Data("AccountMonths_desc")
		s startDate=result.Data("AccountMonths_start")
		i startDate'= "" d
		.s startDate= $zd(startDate,3)
		s endDate=result.Data("AccountMonths_end")
		i endDate'= "" d
		.s endDate= $zd(endDate,3)
		s dataFinish=result.Data("AccountMonths_dataFinish")
		s treatFinish=result.Data("AccountMonths_treatFinish")
		s tieOff=result.Data("AccountMonths_tieOff")
		s remark=result.Data("AccountMonths_remark")
	
		s tmp=rowid_"^"_code_"^"_name_"^"_desc_"^"_startDate_"^"_endDate_"^"_dataFinish_"^"_treatFinish_"^"_tieOff_"^"_remark
		s count=count+1
		i searchValue'="" d
		.q:(searchField="code")&(code'[searchValue)
		.q:(searchField="name")&(name'[searchValue)
		.q:(searchField="desc")&(desc'[searchValue)
		.q:(searchField="start")&(start'[searchValue)
		.q:(searchField="end")&(end'[searchValue)
		.q:(searchField="remark")&(remark'[searchValue)
		.i (count>start)&(count<=end) d
		..d json.InsertRowData(tmp)
		.
		e  d
		.i (count>start)&(count<=end) d
		..d json.InsertRowData(tmp)
	}

	d result.Close()
	s resultString = json.getJsonData(jsonTitle,count)
 	k json
	q resultString
}

/// Creator: 杨旭
/// CreatDate: 2009-9-15
/// Description: 更新记录
/// Table: dhc.ca.cache.data.AccountMonths
/// Input: rowid-数据行号;code-代码; name -名称; start-开始时间; end-结束时间; dataFinish-数据采集标志;treatFinish-数据处理标志;tieOff-扎帐标志;remark-备注;
/// Output: 
/// Return: 代码为空,返回"EmptyCode";代码存在,返回"RepCode";名称为空,返回"EmptyName";名称存在,返回"RepName";收入支出标志都选中,返回"InOut";执行SQL语句返回SQLCODE
/// Others：w ##class(dhc.ca.cache.udata.uAccountMonths).UpdateRec(1,"0002","测试区间","2009-09-01","2009-10-01","Y","N","N","备注")
ClassMethod UpdateRec(rowid, code, name, start, end, dataFinish, treatFinish, tieOff, remark) As %String
{
	n (rowid, code, name, start, end, dataFinish, treatFinish, tieOff ,remark)
	
	q:code="" "EmptyCode"
	q:name="" "EmptyName"
	q:start="" "EmptyStart"
	q:end="" "EmptyEnd"
	
	
	//20160913 zjw 新加的核算周期名称的格式必须为YYYY-MM，否则返回名称格式错误，避免报表选年份查询时有误
	s namelen=$l(name,"-")
	q:namelen'=2 "NameformatError"
	
	s NameHeadlen=""
	s NameHead=$p(name,"-",1),NameTail=$p(name,"-",2)
	s NameHeadlen=$l(NameHead),NameTaillen=$l(NameTail)
	//年份必须在2000~3999之间，月份不能大于12
	q:(NameHeadlen'=4)||(NameTaillen'=2)||(NameHead>3999)||(NameHead<2000)||(NameTail>12) "NameformatError"
	
	
	s start=$zdh(start,3)
	s end=$zdh(end,3)
	
	s tmpRowid=0
	s tmpRowid=..IfRepCode(code)
	q:(tmpRowid'=0)&(tmpRowid'=rowid) "RepCode"
	s tmpRowid=0
	s tmpRowid=..IfRepName(name)
	q:(tmpRowid'=0)&(tmpRowid'=rowid) "RepName"
	s desc=code_"-"_name
	&SQL(UPDATE dhc_ca_cache_data.AccountMonths SET AccountMonths_code=:code,AccountMonths_name=:name,AccountMonths_desc=:desc,AccountMonths_start=:start,AccountMonths_end=:end,AccountMonths_dataFinish=:dataFinish,AccountMonths_treatFinish=:treatFinish,AccountMonths_tieOff=:tieOff,AccountMonths_remark=:remark WHERE %ID=:rowid)
	
	q SQLCODE
}

/// Creator: 杨旭
/// CreatDate: 2009-9-16
/// Description: 获得上期
/// Table: dhc.ca.cache.data.AccountMonths
/// Input: findDate-需要获得上期的时间格式为YYYYMM;
/// Output: 
/// Return: 如果输入的格式不为YYYYMM返回ErrorType,如果输入年份错误返回ErrorYear,
/// 		如果月份错误返回ErrorMonth,否则返回上期日期.
/// Others：w ##class(dhc.ca.cache.udata.uAccountMonths).GetLastMonth("200909")
ClassMethod GetLastMonth(findDate) As %String
{
	n (findDate)
	s rs=""
	s year=""
	s month=""
	s year=$e(findDate,1,4)
	s month=$e(findDate,5,6)
	
	q:'(findDate?6N)||($l(findDate)'=6) "ErrorType"
	q:year<1 "ErrorYear"
	q:(month>12)||(month=0) "ErrorMonth"
	
	i month-1=0 d
	.s year=year-1
	.s month=12
	e  d
	.s month=month-1
	.i $l(month)=1 s month=0_month
	
	s rs=year_month
	q rs
}

/// Creator: 杨旭
/// CreatDate: 2009-9-16
/// Description: 获得去年同期
/// Table: dhc.ca.cache.data.AccountMonths
/// Input: findDate-需要获得上期的时间格式为YYYYMM;
/// Output: 
/// Return: 如果输入的格式不为YYYYMM返回ErrorType,如果输入年份错误返回ErrorYear,
/// 		如果月份错误返回ErrorMonth,否则返回去年日期.
/// Others：w ##class(dhc.ca.cache.udata.uAccountMonths).GetLastYear("200909")
ClassMethod GetLastYear(findDate) As %String
{
	n (findDate)
	s rs=""
	s year=""
	s month=""
	s year=$e(findDate,1,4)
	s month=$e(findDate,5,6)
	
	q:'(findDate?6N)||($l(findDate)'=6) "ErrorType"
	q:year<1 "ErrorYear"
	q:(month>12)||(month=0) "ErrorMonth"
	
	s year=year-1
	
	s rs=year_month
	q rs
}

Storage Default
{
<StreamLocation>^dhc.ca.c.uAccountMonthsS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
