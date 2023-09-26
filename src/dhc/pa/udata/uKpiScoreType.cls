Class dhc.pa.udata.uKpiScoreType Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Creator: wang ying
/// CreatDate: 2011-04-28
/// Description: 查询符合条件的记录
/// Table: dhc_pa_data.KpiScoreType
/// Input: searchField-查询字段;searchValue-查询值;sortField-排序字段;sortDir-排序方向;Start-起始行;Limit-行数;dataFinish-数据采集标志;treatFinish-数据处理标志;tieOff-扎帐标志;
/// Output: 
/// Return: 返回查询到的记录的Json串
/// Others: w ##class(dhc.pa.udata.uKpiScoreType).ListRec("Y","","","","",0,25)
ClassMethod ListRec(active, searchField, searchValue, sortField, sortDir, start, limit) As %String
{
		n (active,searchField, searchValue, sortField, sortDir, start, limit)
		
		s sqlStr="SELECT KpiScoreType_Rowid,KpiScoreType_KpiDr,KpiScoreType_DirectScore,KpiScoreType_LevelScore,KpiScoreType_Active FROM dhc_pa_data.KpiScoreType WHERE %ID>0"
				
		s sortStr=""
		s sortField1=""
		
		i sortField'="" d
		.i sortField="rowid" s sortField1="KpiScoreType_Rowid"
		.i sortField="KpiDr" s sortField1="KpiScoreType_KpiDr"
		.i sortField="directScore" s sortField1="KpiScoreType_DirectScore"
		.i sortField="levelScore" s sortField1="KpiScoreType_LevelScore"
		.i sortField="active" s sortField1="KpiScoreType_Active"
			
		i sortField1'="" d
		.s sortDir=$ZCONVERT(sortDir,"u")
		.i (sortDir="DESC")||(sortDir="ASC") s sortStr=" ORDER BY "_sortField1_" "_sortDir
		.e  s sortStr=" ORDER BY "_sortField1_" ASC"
		e  d
		.s sortStr="ORDER BY %ID DESC"
		
		s sqlStr=sqlStr_sortStr
		
		s result=##class(%Library.ResultSet).%New()
		
		d result.Prepare(sqlStr)
		d result.Execute()
		
		s count=0
		s resultString=""
		s end=start+limit
		
		s json=##class(dhc.pa.comm.JsonObj).%New()
		s jsonTitle="rowid^KpiDr^KPIName^directScore^levelScore^active"
		
		While(result.Next())
		{
			s KPIName=""
			s rowid=result.Data("KpiScoreType_Rowid")
			s KpiDr = result.Data("KpiScoreType_KpiDr")
			i KpiDr'="" d
			i $d(^DHCCJXPAKPIINDEX1(KpiDr)) d
			.s KPIName=$p($g(^DHCCJXPAKPIINDEX1(KpiDr)),"^",2)
			
			s directScore=result.Data("KpiScoreType_DirectScore")
			s levelScore=result.Data("KpiScoreType_LevelScore")
			s active=result.Data("KpiScoreType_Active")
			
			s tmp=rowid_"^"_KpiDr_"^"_KPIName_"^"_directScore_"^"_levelScore_"^"_active
			s count=count+1
			i searchValue'="" d
			.q:(searchField="KpiDr")&(KpiDr'[searchValue)
			.q:(searchField="KPIName")&(KPIName'[searchValue)
			.q:(searchField="active")&(active'[searchValue)
			.i (count>start)&(count<=end) d
			..d json.InsertRowData(tmp)
			e  d
			.i (count>start)&(count<=end) d
			..d json.InsertRowData(tmp)
		}
	
		d result.Close()
		s resultString = json.getJsonData(jsonTitle,count)
	 	k json
		q resultString
}

/// Creator: wang ying
/// CreatDate:  2011-04-28
/// Description: 插入新记录
/// Table: dhc_pa_data.KpiScoreType
/// Input: data-待插入的数据(code^name^desc)
/// Output: 
/// Return: 代码为空,返回"EmptyCode";代码存在,返回"RepCode";名称为空,返回"EmptyName";名称存在,返回"RepName";收入支出标志都选中,返回"InOut";执行SQL语句返回SQLCODE
/// Others: w ##class(dhc.pa.udata.uKpiScoreType).InsertRec("23^Y^")
ClassMethod InsertRec(data) As %String
{
		n (data)
		
		k PLIST
		q:data="" "EmptyRecData"
		
		s KPIDr=$p(data,"^",1)
		s directScore=$p(data,"^",2)
		s levelScore = $p(data,"^",3)

	    s active="Y"
		
		i KPIDr'="" s PLIST(2)=KPIDr
		i directScore'="" s PLIST(3)=directScore
		i levelScore'="" s PLIST(4)=levelScore
		i active'="" s PLIST(5)=active
	
		
		&sql(INSERT INTO dhc_pa_data.KpiScoreType VALUES PLIST())
		q SQLCODE
}

/// Creator: wang ying
/// CreatDate: 2011-04-28
/// Description: 更新记录
/// Table: dhc_pa_data.KpiScoreType
/// Input: rowid-数据行号;data-待插入的数据(code^name^start^end^remark^tieOff);
/// Output: 
/// Return: 执行SQL语句返回SQLCODE
/// Others：w ##class(dhc.pa.udata.uKpiScoreType).UpdateRec(1,"5^Y^^Y")
ClassMethod UpdateRec(rowid, data) As %String
{
		n (rowid,data)
		
		k PLIST
		q:data="" "EmptyRecData"
		
		s KPIDr=$p(data,"^",1)
		s directScore=$p(data,"^",2)
		s levelScore = $p(data,"^",3)
		s active=$p(data,"^",4)
		
	
		
	    s PLIST(2)=KPIDr
		s PLIST(3)=directScore
		s PLIST(4)=levelScore
		s PLIST(5)=active
		
		&SQL(UPDATE dhc_pa_data.KpiScoreType VALUES PLIST() where %ID=:rowid)
		q SQLCODE
}

/// Creator: wang ying
/// CreatDate: 2011-04-28
/// Description: 代码是否存在
/// Table: dhc_pa_data.ScoreLevel
/// Input: code-代码
/// Output: 
/// Return: 不存在返回0,存在返回所在行号
/// Others: w ##class(dhc.nca.app.appAAccCycle).IfRepCode("201006")
ClassMethod IfRepCode(code) As %String
{
	n (code)
	s rowid=0
	s rowid=$o(^DHCCJXPASCORELEVEL(0,"Code",code,rowid))
	i rowid="" d  s rowid=0
	q rowid
}

/// Creator: wang ying
/// CreatDate: 2011-04-28
/// Description: 名称是否存在
/// Table: dhc_pa_data.ScoreLevel
/// Input: name-名称
/// Output: 
/// Return: 不存在返回0,存在返回所在行号
/// Others: w ##class(dhc.nca.app.appAAccCycle).IfRepName("工资费用")
ClassMethod IfRepName(name) As %String
{
	n (name)
	s rowid=0
	s rowid=$o(^DHCCJXPASCORELEVEL(0,"Name",name,rowid))
	i rowid="" d  s rowid=0
	q rowid
}

/// Creator: wang ying
/// CreatDate: 2011-04-28
/// Description: 删除分组记录
/// Table：dhc_pa_data.KpiScoreType
/// Input：rowid-数据行号
/// Output: 
/// Return: 返回执行删除语句后的SQLCODE
/// Others: w ##class(dhc.pa.udata.uKpiScoreType).Delete(1)
ClassMethod Delete(rowid) As %String
{
	n (rowid)
	
	&SQL(DELETE FROM dhc_pa_data.KpiScoreType WHERE %ID=:rowid)
	q SQLCODE
}

/// Creator: wang ying
/// CreatDate: 2013-07-16
/// Description: 初始化指标类别表
/// Table: dhc_pa_data.KpiScoreType
/// Input: name-名称
/// Output: 
/// Return: 不存在返回0,存在返回所在行号
/// Others: w ##class(dhc.pa.udata.uKpiScoreType).init()
ClassMethod init() As %String
{
	
	k PLIST
	s currStagem=..currStragem()
	i currStagem="ERROR" q:"ERROR"
	i currStagem="NO" q:"NO"
	s SQLCODE=0
	s rowid=0
	f  s rowid=$o(^DHCCJXPASTRATAGEM(currStagem,"Schem",rowid)) q:rowid=""  d
	.i $g(^DHCCJXPASTRATAGEM(currStagem,"Schem",rowid))'="" d
	..s schem=^DHCCJXPASTRATAGEM(currStagem,"Schem",rowid)
	..s schemFlag=$p(schem,"^",12)
	..i schemFlag="Y" d
	...s detailRowid=0
	...f  s detailRowid=$o(^DHCCJXPASTRATAGEM(currStagem,"SchemDetail",rowid,detailRowid)) q:detailRowid=""  d
	....i $g(^DHCCJXPASTRATAGEM(currStagem,"SchemDetail",rowid,detailRowid))'="" d
	.....s detail=^DHCCJXPASTRATAGEM(currStagem,"SchemDetail",rowid,detailRowid)
	.....s kpiDr=$p(detail,"^",2)
	.....s upKPIDR=$p(detail,"^",5)
	.....i upKPIDR>0 d
	......i $g(^DHCCJXPAKPIINDEX1(kpiDr))'="" d
	.......s KPIType=0
	.......f  s KPIType=$o(^DHCCJXPAKPISCORETYPE(0,"KPI",KPIType)) q:KPIType=""  d
	........i KPIType=kpiDr d
	.........&sql(delete from dhc_pa_data.KpiScoreType where KpiScoreType_KpiDr=:KPIType)
	.......i '$d(^DHCCJXPAKPISCORETYPE(0,"KPI",kpiDr))  d
	........s PLIST(2)=kpiDr
	........s PLIST(3)="Y"
	........s PLIST(5)="Y"
	........&sql(INSERT INTO dhc_pa_data.KpiScoreType VALUES PLIST())
	q SQLCODE
}

/// Creator: wang ying
/// CreatDate: 2013-07-16
/// Description: 当前战略
/// Table: dhc_pa_data.Stratagem
/// Input: name-名称
/// Output: 
/// Return: 不存在返回0,存在返回rowid
/// Others: w ##class(dhc.pa.udata.uKpiScoreType).currStragem()
ClassMethod currStragem() As %String
{

	s rowid=0,num=0,currRowid=""
	f  s rowid=$o(^DHCCJXPASTRATAGEM(rowid)) q:rowid=""  d
	.i $g(^DHCCJXPASTRATAGEM(rowid))'="" d
	..s currFlag=$p(^DHCCJXPASTRATAGEM(rowid),"^",14)
	..i currFlag="Y" d
    ...s currRowid=rowid
    ...s num=num+1
	i num=1 q currRowid
	i num>1 q "ERROR"
	i num=0 q "NO"
}

Storage Default
{
<StreamLocation>^dhc.pa.udata.uKpiScoreTypeS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
