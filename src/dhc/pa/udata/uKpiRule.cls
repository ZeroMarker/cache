/// Creator: wang ying
/// CreatDate: 2010-01-11
/// Description: 指标来源规则维护(海军总医院)
Class dhc.pa.udata.uKpiRule Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Creator:wang ying
/// CreatDate:2011-01-11
/// Description:查询接口套记录
/// Table:dhc_pa_inter.KpiRule
/// Input:locSetDr-接口套rowid;searchField-查询字段;searchValue-查询值;sortField-排序字段;sortDir-排序方向;start-起始行;limit-行数
/// Output:
/// Return:返回查询到的记录的Json串
/// Others:w ##class(dhc.pa.udata.uKpiRule).OutKpiList(1,"","","","",0,25)
ClassMethod OutKpiList(locSetDr, searchField, searchValue, sortField, sortDir, start, limit) As %String
{
	n (locSetDr,searchField,searchValue,sortField,sortDir,start,limit)

	s sqlStr="select KpiRule_rowid,KpiRule_KPIDr,KpiRule_sysSetDr,KpiRule_active from dhc_pa_inter.KpiRule where %ID>0 and KpiRule_sysSetDr='"_locSetDr_"'"
	
	s sortStr=""
	s sortField1=""
	
	i sortField'="" d
	.i sortField="rowid" s sortField1="KpiRule_rowid"
	.i sortField="KPIName" s sortField1="KpiRule_KPIDr"
	.i sortField="inLocSetName" s sortField1="KpiRule_sysSetDr"
	.i sortField="active" s sortField1="KpiRule_active"
	
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
	s jsonTitle="rowid^KPIDr^code^name^inLocSetDr^inLocSetName^active"
	s KPICode="",KPIName=""
	While(result.Next()){
		s inLocSetName=""
		s rowid=result.Data("KpiRule_rowid")
		s KPIDr=result.Data("KpiRule_KPIDr")
		i KPIDr'="" d
        .i $d(^DHCCJXPAKPIINDEX1(KPIDr)) d
        .s KPICode=$p($g(^DHCCJXPAKPIINDEX1(KPIDr)),"^",1)
        .s KPIName=$p($g(^DHCCJXPAKPIINDEX1(KPIDr)),"^",2)
		
		s inLocSetDr=result.Data("KpiRule_sysSetDr")
		i $D(^DHCCJXPAINTERLOCSET(inLocSetDr)) d
		.i $G(^DHCCJXPAINTERLOCSET(inLocSetDr))'="" d
		..s inLocSetName=$P(^DHCCJXPAINTERLOCSET(inLocSetDr),"^",3)
		
		s active=result.Data("KpiRule_active")
		
		s tmp=rowid_"^"_KPIDr_"^"_KPICode_"^"_KPIName_"^"_inLocSetDr_"^"_inLocSetName_"^"_active
		
		i searchValue'="" d
		.i searchField = "active" d
		..i (searchValue="Y") || (searchValue="y") s searchValue="Y"
		..e  s searchValue="N"
		.q:(searchField = "code")&(KPICode'[searchValue)
		.q:(searchField = "name")&(KPIName'[searchValue)
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

/// Creator：wang ying
/// CreatDate：2011-01-11
/// Description: 判断同一接口套下是否存在同一KPI指标记录
/// Table：
/// Input：locSetDr-接口套rowid;KPIDr-KPI指标rowid
/// Output：
/// Return：返回tempRowid
/// Others：w ##class(dhc.pa.udata.uKpiRule).IfRepKPI(1,3)
ClassMethod IfRepKPI(locSetDr, KPIDr) As %String
{
	n (locSetDr,KPIDr)
	
	s RowId=0,tempRowid=0
	s RowId=$o(^DHCCJXPAKPIRULE(0,"SysSetKPI",locSetDr,KPIDr,RowId))
	i RowId="" d  
	.s tempRowid=0
	e  d
	.s LocSetDr=$P(^DHCCJXPAKPIRULE(RowId),"^",2)
	.i LocSetDr=locSetDr d
	..s tempRowid=RowId
	
	q tempRowid
}

/// Creator：wang ying
/// CreatDate：2011-01-11
/// Description: 为给定的接口套添加KPI指标记录
/// Table：dhc_pa_inter.KpiRule
/// Input：locSetDr-接口套rowid;code-外部指标代码;name-外部指标名称
/// Output：
/// Return：返回SQLCODE
/// Others：w ##class(dhc.pa.udata.uKpiRule).Insert(1,3)
ClassMethod Insert(locSetDr, KPIDr) As %String
{
	n (locSetDr,KPIDr)

	q:(..IfRepKPI(locSetDr,KPIDr))'=0 "RepKPI" 

	s active="Y"
	&SQL(insert into dhc_pa_inter.KpiRule(KpiRule_KPIDr,KpiRule_sysSetDr,KpiRule_active) VALUES(:KPIDr,:locSetDr,:active))
	q SQLCODE
}

/// Creator：wang ying
/// CreatDate：2011-01-11
/// Description: 更新接口套下的KPI指标记录
/// Table：dhc_pa_inter.KpiRule
/// Input：rowid-所在行号;locSetDr-接口套rowid;code-外部指标代码;name-外部指标名称;active-有效标志
/// Output：
/// Return：返回执行更新语句后的SQLCODE
/// Others：w ##class(dhc.pa.udata.uKpiRule).Update(3,1,6,"Y")
ClassMethod Update(rowid, locSetDr, KPIDr, active) As %String
{
	n (rowid,locSetDr,KPIDr,active)
	
	q:rowid="" "rowidEmpt"	//错误数据
	
	s tempRowid=..IfRepKPI(locSetDr,KPIDr)
	q:(tempRowid'="")&(tempRowid'=rowid) "RepKPI"
	
	&sql(update dhc_pa_inter.KpiRule set KpiRule_KPIDr=:KPIDr,KpiRule_sysSetDr=:locSetDr,KpiRule_active=:active where %ID=:rowid)
	q SQLCODE
}

/// Creator:wang ying
/// CreatDate:2011-01-11
/// Description:删除接口套下的KPI指标记录
/// Table:dhc_pa_inter.KpiRule
/// Input:rowid-外部指标记录rowid
/// Output: 
/// Return:返回执行删除语句后的SQLCODE
/// Others:w ##class(dhc.pa.udata.uKpiRule).Delete(4)
ClassMethod Delete(rowid) As %String
{
	n (rowid)
	
	&SQL(delete from dhc_pa_inter.KpiRule where KpiRule_rowid=:rowid)
	q SQLCODE
}

/// Creator:wang ying
/// CreatDate:2011-01-12
/// Description:获得权限范围内并在KpiRule(指标来源表)没有的KPI指标
/// Table:dhc_pa_inter.KpiRule
/// Input:rowid-外部指标记录rowid
/// Output: 
/// Return:返回执行删除语句后的SQLCODE
/// Others:w ##class(dhc.pa.udata.uKpiRule).getKPIDr(1,"demo")
ClassMethod getKPIDr(locSetDr, userCode, start, limit) As %String
{
    n (userCode,locSetDr,start,limit)
	
	q:userCode="" "NoData"
	q:locSetDr="" "NoLocSetDr"
	
	s userCode=$$ALPHAUP^SSUTIL4(userCode)
	//根据用户Code查找用户ID
	s userId=0
	s userId=$O(^SSU("SSUSR",0,"SSUSR_Initials",userCode,userId))
	q:userId="" "NoData"
	
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "select KPIAudit_KPIDr from dhc_pa_data.KPIAudit where %ID>0 and KPIAudit_userDr="_userId
    s sqlStr = sqlStr_" and NOT EXISTS (SELECT KpiRule_KPIDr FROM dhc_pa_inter.KpiRule where dhc_pa_data.KPIAudit.KPIAudit_KPIDr = dhc_pa_inter.KpiRule.KpiRule_KPIDr and KpiRule_sysSetDr="_"'"_locSetDr_"')"
	;w sqlStr,!
	d result.Prepare(sqlStr)
	d result.Execute()

	s count = 0
	s end = start+limit
	s resultString = ""
	s json = ##class(dhc.pa.comm.JsonObj).%New()
	While(result.Next()){
		s KPIDr = result.Data("KPIAudit_KPIDr")
		i KPIDr'="" d 
		.i $D(^DHCCJXPAKPIINDEX1(KPIDr)) d
		..i $G(^DHCCJXPAKPIINDEX1(KPIDr))'="" d
		...s KPIName=$P($G(^DHCCJXPAKPIINDEX1(KPIDr)),"^",2)
		...s tmp=KPIDr_"^"_KPIName
		...s count = count+1
		...i (count>start)&(count<=end) d
		....d json.InsertRowData(tmp)
	}
	d result.Close()
	s resultString = json.getJsonData("rowid^name",count)
 	k json
	q resultString
}

Storage Default
{
<StreamLocation>^dhc.pa.udata.uKpiRuleS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
