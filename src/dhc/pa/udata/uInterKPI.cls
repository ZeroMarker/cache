/// Creator: wang ying
/// CreatDate: 2010-11-15
/// Description: 接口指标表维护
Class dhc.pa.udata.uInterKPI Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Creator: wang ying
/// CreatDate: 2010-11-15
/// Description: 查询符合条件的记录
/// Table：dhc.pa.udata.InterLoc 
/// Input: searchField-查询字段,searchValue-查询值,sortField-排序字段,sortDir-排序方向,Start-起始行,Limit-行数
/// Output: 
/// Return: 返回查询到的记录的Json串
/// Others: w ##class(dhc.pa.udata.uInterKPI).ListRec("Y","","","rowid","ASC",0,25,5)
ClassMethod ListRec(active, searchField, searchValue, sortField, sortDir, start, limit, inKPIDr)
{
	n (active, searchField, searchValue, sortField, sortDir, start, limit,inKPIDr)
	
	s sqlStr="SELECT InterKPI_rowid,InterKPI_kpiDr,InterKPI_okrDr,InterKPI_remark,InterKPI_active FROM dhc_pa_inter.InterKPI"
	
	s whereStr=" WHERE %ID>0"
	
	s whereStr=whereStr_" AND InterKPI_kpiDr='"_inKPIDr_"'"
	s sortStr=""
	s sortField1=""
	
	i sortField'="" d
	.i sortField="rowid" s sortField1="InterKPI_rowid"
	.i sortField="kpiDr" s sortField1="InterKPI_kpiDr"
	.i sortField="kpirlue" s sortField1="InterKPI_okrDr"
	.i sortField="remark" s sortField1="InterKPI_remark"
	.i sortField="active" s sortField1="InterKPI_active"
	
	i sortField1'="" d
	.s sortDir=$ZCONVERT(sortDir,"u")
	.i (sortDir="DESC")||(sortDir="ASC") s sortStr=" ORDER BY "_sortField1_" "_sortDir
	.e  s sortStr=" ORDER BY "_sortField1_" ASC"
	e  d
	.s sortStr=" ORDER BY InterKPI_rowid DESC"
	
	s sqlStr=sqlStr_whereStr_sortStr
    ;w sqlStr,!
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	
	s count=0
	s resultString=""
	s end = start + limit - 1
	
	s json=##class(dhc.pa.comm.JsonObj).%New()
	s code="",name=""
	s jsonTitle="rowid^KPIDr^kpirule^KPIName^code^name^locSetDr^locSetName^remark^active"
	s KPIName = ""
	While(result.Next())
	{
		
		s rowid=result.Data("InterKPI_rowid")
		s KPIDr=result.Data("InterKPI_kpiDr")
		;w jxUnitDr,!
		i KPIDr'="" d
		.i $d(^DHCCJXPAINDEX1(KPIDr))  d
		..s KPIName=$p($g(^DHCCJXPAINDEX1(KPIDr)),"^",2)
		s kpirule=result.Data("InterKPI_okrDr")
		i kpirule'="" d
		.i $d(^DHCCJXPAOUTKPIRULE(kpirule)) d
		..s code = $p($g(^DHCCJXPAOUTKPIRULE(kpirule)),"^",1)
		..s name = $p($g(^DHCCJXPAOUTKPIRULE(kpirule)),"^",2)
		..s locSetDr = $p($g(^DHCCJXPAOUTKPIRULE(kpirule)),"^",3)
		..i locSetDr'="" d
		...i $d(^DHCCJXPAINTERLOCSET(locSetDr)) d
		....s locSetName = $p($g(^DHCCJXPAINTERLOCSET(locSetDr)),"^",3)
		s remark=result.Data("InterKPI_remark")
		s active=result.Data("InterKPI_active")
		
		s tmp=rowid_"^"_KPIDr_"^"_kpirule_"^"_KPIName_"^"_code_"^"_name_"^"_locSetDr_"^"_locSetName_"^"_remark_"^"_active
		
		i searchValue'="" d
		.q:(searchField = "KPIName")&(KPIName'[searchValue)
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

/// Creator: wang ying
/// CreatDate: 2010-11-25
/// Description: KPI规则是否存在
/// Table：dhc.pa.udata.InterLoc 
/// Input: code-代码
/// Output: 
/// Return: 不存在返回0,存在返回所在行号
/// Others:w ##class(dhc.pa.udata.uInterKPI).IfRepKPI(2,1)
ClassMethod IfRepKPI(KPIDr, KPIRlueDr) As %String
{
	n (KPIDr,KPIRlueDr)
	s rowid=0
	s rowid=$o(^DHCCJXPAINTERKPI(0,"IKKPICode",KPIDr,KPIRlueDr,rowid))
	i rowid="" d  s rowid=0
	q rowid
}

/// Creator: wang ying
/// CreatDate:  2010-11-11
/// Description: 插入新接口科室记录
/// Table:dhc.pa.udata.InterLoc 
/// Input: data-待插入的数据(code^name^desc)
/// Output: 
/// Return: 代码为空,返回"EmptyCode";代码存在,返回"RepCode";名称为空,返回"EmptyName";名称存在,返回"RepName";收入支出标志都选中,返回"InOut";执行SQL语句返回SQLCODE
/// Others: w ##class(dhc.pa.udata.uInterKPI).InsertRec("7^8^备注")
ClassMethod InsertRec(data) As %String
{
		n (data)
		
		k PLIST
		q:data="" "EmptyRecData"
		
		s KPIDr=$p(data,"^",1)
		s kpiRuleDr=$p(data,"^",2)
		s remark = $p(data,"^",3)
		
		
		s id = 0
		s id = ..IfRepKPI(KPIDr,kpiRuleDr)
		q:id>0 "RepKPI"
		
		s active = "Y"
		
		i KPIDr'="" s PLIST(2)=KPIDr
		i kpiRuleDr'="" s PLIST(3)=kpiRuleDr
		i remark'="" s PLIST(5)=remark
		i active'="" s PLIST(6)=active
			
		&sql(INSERT INTO dhc_pa_inter.InterKPI VALUES PLIST())
		q SQLCODE
}

/// Creator: wang ying
/// CreatDate:  2010-11-11
/// Description: 插入新接口科室记录
/// Table:dhc.pa.udata.InterLoc 
/// Input: data-待插入的数据(code^name^desc)
/// Output: 
/// Return: 代码为空,返回"EmptyCode";代码存在,返回"RepCode";名称为空,返回"EmptyName";名称存在,返回"RepName";收入支出标志都选中,返回"InOut";执行SQL语句返回SQLCODE
/// Others: w ##class(dhc.pa.udata.uInterKPI).UpdataRec("3^4^备注",5)
ClassMethod UpdataRec(data, rowid) As %String
{
		n (data,rowid)
		
		k PLIST
		q:data="" "EmptyRecData"
		q:rowid="" "rowidEmpt"
		s KPIDr=$p(data,"^",1)
		s kpiRuleDr=$p(data,"^",2)
		s remark = $p(data,"^",3)
		s active = $p(data,"^",4)
		
		
		s id = 0
		s id = ..IfRepKPI(KPIDr,kpiRuleDr)
		q:((id>0)&&(id'=rowid)) "RepKPI"
		
		
		s PLIST(2)=KPIDr
		s PLIST(3)=kpiRuleDr
		s PLIST(5)=remark
		s PLIST(6)=active
			
		&sql(UPDATE dhc_pa_inter.InterKPI VALUES PLIST() where %ID=:rowid)
		q SQLCODE
}

/// Creator:wang ying
/// CreatDate:2010-11-25
/// Description:删除接口指标
/// Table:dhc_pa_inter.OutKpiRule
/// Input:rowid-接口指标rowid
/// Output: 
/// Return:返回执行删除语句后的SQLCODE
/// Others:w ##class(dhc.pa.udata.uInterKPI).Delete(1)
ClassMethod Delete(rowid) As %String
{
	n (rowid)
	&SQL(delete from dhc_pa_inter.InterKPI where %ID=:rowid)
	q SQLCODE
}

/// Creator：wang ying
/// CreatDate：2010-11-25
/// Description: 根据指标id获取KPI指标
/// Table：dhc_pa_data.KPIIndex1
/// Input：start:开始记录位置;limit:单页记录条数;
/// Output：
/// Return：有效指标字符串
/// Others：w ##class(dhc.pa.udata.uInterKPI).GetKPIs("","",0,10,"")
ClassMethod GetKPIs(searchField, searchValue, start, limit, str) As %String
{
	n ( searchField, searchValue,start, limit, str)
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "SELECT KPIIndex1_rowid,KPIIndex1_code,KPIIndex1_name,KPIIndex1_desc FROM dhc_pa_data.KPIIndex1 where %ID>0 and KPIIndex1_isKPI='Y' and KPIIndex1_isEND='Y'"
	i str'="" s sqlStr = sqlStr_" and KPIIndex1_shortcut LIKE '%"_str_"%'"
	
	d result.Prepare(sqlStr)
	d result.Execute()
   
	s count = 0
	s resultString = ""
	s end = start+limit
	s json = ##class(dhc.pa.comm.JsonObj).%New()
	While(result.Next()){
		s rowid = result.Data("KPIIndex1_rowid")
		s name = result.Data("KPIIndex1_name")
		s code = result.Data("KPIIndex1_code")
		s desc = result.Data("KPIIndex1_desc")
		s tmp=rowid_"^"_name_"^"_code_"^"_desc
		i searchValue'="" d
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
	s resultString = json.getJsonData("rowid^name^code^desc",count)
 	k json
	q resultString
}

Storage Default
{
<StreamLocation>^dhc.pa.udata.uInterKPIS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
