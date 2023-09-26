/// Creator: wang ying
/// CreatDate: 2011-09-05
/// Description: 求平均值指标
Class dhc.pa.udata.uKPIPro Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Creator：wang ying
/// CreatDate：2011-09-05
/// Description: 查询符合条件的求平均值指标记录
/// Table：dhc_pa_data.KPIPro
/// Input：searchField-查询字段;searchValue-查询值;sortField-排序字段;sortDir-排序方向;start-起始行;limit-行数;
/// Output：
/// Return：返回查询到的记录的Json串
/// Others:w ##class(dhc.pa.udata.uKPIPro).List("","","","",0,25)
ClassMethod List(searchField, searchValue, sortField, sortDir, start, limit) As %String
{
	n (searchField, searchValue, sortField, sortDir, start, limit)
	
	//SQL
	s sqlStr="select KPIPro_rowid,KPIPro_kpiDr from dhc_pa_data.KPIPro"
	s whereStr=" where %ID>0"
	
	s sortStr="",sortField1=""
	i sortField'="" d
	.i sortField="rowid" s sortField1="KPIPro_rowid"
	.i sortField="KPIName" s sortField1="KPIPro_kpiDr"

	
	i sortField1'="" d
	.s sortDir=$ZCONVERT(sortDir,"u")
	.i (sortDir="desc")||(sortDir="asc") s sortStr=" order by "_sortField1_" "_sortDir
	.e  s sortStr=" order by "_sortField1_" asc"
	e  s sortStr=" order by %ID desc"
	
	s sqlStr=sqlStr_whereStr_sortStr
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	
	s count=0
	s resultString=""
	s end=start+limit-1
	
	s json=##class(dhc.pa.comm.JsonObj).%New()
	s jsonTitle="rowid^KPIDr^KPIName^desc"
	While(result.Next()){
		//集体初始化
		s KPIName=""
		
		s rowid=result.Data("KPIPro_rowid")
		s KPIDr=result.Data("KPIPro_kpiDr")
		i KPIDr'="" d
		.i $D(^DHCCJXPAKPIINDEX1(KPIDr)) d
		..i $G(^DHCCJXPAKPIINDEX1(KPIDr))'="" d
		...s KPIName=$P(^DHCCJXPAKPIINDEX1(KPIDr),"^",2)
		
		
		s tmp=rowid_"^"_KPIDr_"^"_KPIName_"^求平均值"
		
		i searchValue'="" d
		.q:(searchField = "KPIName")&(KPIName'[searchValue)
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
/// CreatDate：2011-09-05
/// Description: 获取指标
/// Table：dhc_pa_data.KPIAudit
/// Input：start:开始记录位置;limit:单页记录条数;str-模糊查询字符串;userCode-用户代码
/// Output：
/// Return：有指标字符串
/// Others：w ##class(dhc.pa.udata.uKPIPro).GetKPI(0,10,"","demo")
ClassMethod GetKPI(start, limit, str, userCode) As %String
{
	n (start, limit, str, userCode)
	
	q:userCode="" "NoData"
	
	s userCode=$$ALPHAUP^SSUTIL4(userCode)
	//根据用户Code查找用户ID
	s userId=0
	s userId=$O(^SSU("SSUSR",0,"SSUSR_Initials",userCode,userId))
	q:userId="" "NoData"
	
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "select KPIAudit_KPIDr,KPIIndex1_shortcut from dhc_pa_data.KPIAudit,dhc_pa_data.KPIIndex1 where KPIAudit_rowid>0 and KPIAudit_userDr="_userId_" and KPIAudit_KPIDr=KPIIndex1_rowid"
	s whereStr=""
	i str'="" s whereStr=" and KPIIndex1_shortcut LIKE '%"_str_"%'"
	
	s sqlStr=sqlStr_whereStr
	d result.Prepare(sqlStr)
	d result.Execute()

	s count = 0
	s resultString = ""
	s end = start+limit
	s json = ##class(dhc.pa.comm.JsonObj).%New()
	While(result.Next()){
		s KPIDr = result.Data("KPIAudit_KPIDr")
		s shortCut=result.Data("KPIIndex1_shortcut")
		i '$d(^DHCCJXPAKPIPRO(0,"KPI",KPIDr)) d
		.s tmp=KPIDr_"^"_shortCut
		.s count = count+1
		.i (count>start)&(count<=end) d
		..d json.InsertRowData(tmp)
	}
	d result.Close()
	s resultString = json.getJsonData("KPIDr^shortCut",count)
 	k json
	q resultString
}

/// Creator：wang ying
/// CreatDate：2011-09-05
/// Description: 获取trakcare用户
/// Table：User.SSUser
/// Input：start:开始记录位置;limit:单页记录条数;str-模糊查询字符串
/// Output：
/// Return：有效trakcare用户字符串
/// Others：w ##class(dhc.pa.udata.uKPIPro).GetUser(0,10,"")
ClassMethod GetUser(start, limit, str) As %String
{
	n (start, limit, str)
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "select SSUSR_RowId,SSUSR_Name from SS_User where %ID>0"
	i str'="" s sqlStr = sqlStr_" and SSUSR_Name like '"_str_"%'"
	
	d result.Prepare(sqlStr)
	d result.Execute()

	s count = 0
	s resultString = ""
	s end = start+limit
	s json = ##class(dhc.pa.comm.JsonObj).%New()
	While(result.Next()){
		s rowid = result.Data("SSUSR_RowId")
		s name = result.Data("SSUSR_Name")
		s tmp=rowid_"^"_name
		s count = count+1
		i (count>start)&(count<=end) d
		.d json.InsertRowData(tmp)
	}
	d result.Close()
	s resultString = json.getJsonData("rowid^name",count)
 	k json
	q resultString
}

/// Creator：wang ying
/// CreatDate：2011-09-05
/// Description: 判是否存在一个指标多条权限记录
/// Table：dhc_pa_data.KPIPro
/// Input：KPIDr-绩效单元ID
/// Output：
/// Return：返回childSub
/// Others：w ##class(dhc.pa.udata.uKPIPro).IfRepRecode()
ClassMethod IfRepRecode(KPIDr) As %String
{
	n (KPIDr)
	
	s rowid=0
	s rowid = $O(^DHCCJXPAKPIPRO(0,"KPI",KPIDr,rowid))
	i rowid="" s rowid=0
	q rowid
}

/// Creator：wang ying
/// CreatDate：2011-09-05
/// Description: 添加指标记录
/// Table：dhc_pa_data.KPIPro
/// Input：data-待插入数据(KPIDr);
/// Output：
/// Return：返回SQLCODE
/// Others：w ##class(dhc.pa.udata.uKPIPro).Insert("1")
ClassMethod Insert(data) As %String
{
	n (data)
	
	q:data="" "dataEmpt"      				//空数据dataEmpt
	k PLIST
	
	s KPIDr=$p(data,"^",1)				//指标
	i KPIDr'="" s PLIST(2)=KPIDr 
	
	
	q:(..IfRepRecode(KPIDr))'=0 "RepRecode" 

	&SQL(insert into dhc_pa_data.KPIPro VALUES PLIST())
	q SQLCODE
}

/// Creator:wang ying
/// CreatDate:2011-09-05
/// Description:删除指标记录
/// Table:dhc_pa_data.KPIPro
/// Input:rowid-指标记录ID
/// Output: 
/// Return:返回执行删除语句后的SQLCODE
/// Others:w ##class(dhc.pa.udata.uKPIPro).Delete(4)
ClassMethod Delete(rowid) As %String
{
	n (rowid)
	
	&SQL(delete from dhc_pa_data.KPIPro where %ID=:rowid)
	q SQLCODE
}

/// Creator：wang ying
/// CreatDate：2011-09-05
/// Description: 修改指标记录
/// Table：dhc_pa_data.KPIPro
/// Input：data-待插入数据(KPIDr);
/// Output：
/// Return：返回SQLCODE
/// Others：w ##class(dhc.pa.udata.uKPIPro).Update(37,2)
ClassMethod Update(rowid, data) As %String
{
	n (rowid, data)
	
	q:rowid="" "rowidEmpt"					//错误数据
	q:data="" "dataEmpt"      				//空数据dataEmpt
	k PLIST
	
	s KPIDr=$p(data,"^",1)				//指标
	i KPIDr'="" s PLIST(2)=KPIDr 
	

	s RowId=..IfRepRecode(KPIDr)
	q:(RowId'=0)&(RowId'=rowid) "RepRecode"
	
	&sql(update dhc_pa_data.KPIPro values PLIST() where %ID=:rowid)
	q SQLCODE
}

Storage Default
{
<StreamLocation>^dhc.pa.udata.uKPIProS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
