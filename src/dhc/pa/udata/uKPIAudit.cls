Class dhc.pa.udata.uKPIAudit Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Creator: wang ying
/// CreatDate: 2010-07-29
/// Description: 查询符合条件的记录
/// Table: dhc.pa.data.KPIAudit
/// Input: searchField-查询字段;searchValue-查询值;sortField-排序字段;sortDir-排序方向;Start-起始行;Limit-行数;dataFinish-数据采集标志;treatFinish-数据处理标志;tieOff-扎帐标志;
/// Output: 
/// Return: 返回查询到的记录的Json串
/// Others: w ##class(dhc.pa.udata.uKPIAudit).ListRec("","","","rowid","DESC",0,25)
ClassMethod ListRec(active, searchField, searchValue, sortField, sortDir, start, limit) As %String
{
		n (active,searchField, searchValue, sortField, sortDir, start, limit)
		
		;w active_"^"_searchField_"^"_searchValue_"^"_sortField_"^"_sortDir_"^"_start_"^"_limit,!
		s sqlStr="SELECT KPIAudit_rowid,KPIAudit_KPIDr,KPIAudit_userDr FROM dhc_pa_data.KPIAudit WHERE %ID>0"
					
		s sortStr=""
		s sortField1=""
		
		i sortField'="" d
		.i sortField="rowid" s sortField1="KPIAudit_rowid"
		.i sortField="KPIName" s sortField1="KPIAudit_KPIDr"
		.i sortField="UserName" s sortField1="KPIAudit_userDr"
			
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
		s jsonTitle="rowid^KPIDr^KPIName^UserDr^UserName"
		s KPIName="",userName=""
		While(result.Next())
		{
			
			s rowid=result.Data("KPIAudit_rowid")
			s KPIDr=result.Data("KPIAudit_KPIDr")
			i KPIDr'="" s KPIName = $p($g(^DHCCJXPAKPIINDEX1(KPIDr)),"^",2)
			s userDr=result.Data("KPIAudit_userDr")
			i userDr'=""  s userName = $p($g(^SSU("SSUSR",userDr)),"^",2)
			
			
			s tmp=rowid_"^"_KPIDr_"^"_KPIName_"^"_userDr_"^"_userName
			
			i searchValue'="" d
			.q:(searchField="KPIDr")&(KPIName'[searchValue)
			.q:(searchField="UserDr")&(userName'[searchValue)
			.s count=count+1
			.i (count>start)&(count<=end) d
			..d json.InsertRowData(tmp)
			e  d
			.s count=count+1
			.i (count>start)&(count<=end) d
			..d json.InsertRowData(tmp)
		}
	
		d result.Close()
		s resultString = json.getJsonData(jsonTitle,count)
	 	k json
		q resultString
}

/// Creator: wang ying
/// CreatDate: 2010-07-29
/// Description: KPI指标是否存在
/// Table: dhc.pa.data.KPIAudit
/// Input: code-代码
/// Output: 
/// Return: 不存在返回0,存在返回所在行号
/// Others: w ##class(dhc.pa.udata.uKPIAudit).IfRepKPI("201006")
ClassMethod IfRepKPI(KPIDr, user) As %String
{
	n (KPIDr,user)
	q:KPIDr="" ""
	q:user="" ""
	s rowid=0
	s rowid=$o(^DHCCJXPAKPIAUDIT(0,"User",user,KPIDr,rowid))
	i rowid="" d  s rowid=0
	q rowid
}

/// Creator: wang ying
/// CreatDate:  2010-07-29
/// Description: 插入新记录
/// Table: dhc.pa.data.KPIAudit
/// Input: data-待插入的数据(code^name^desc)
/// Output: 
/// Return: 代码为空,返回"EmptyCode";代码存在,返回"RepCode";名称为空,返回"EmptyName";名称存在,返回"RepName";收入支出标志都选中,返回"InOut";执行SQL语句返回SQLCODE
/// Others: w ##class(dhc.pa.udata.uKPIAudit).InsertRec("14,10^705")
ClassMethod InsertRec(data) As %String
{
		n (data)
		
		k PLIST
		q:data="" "EmptyRecData"
		
		s KPIDr=$p(data,"^",1)
		s userId=$p(data,"^",2)
		s SQLCODE=0
        s len=$l(KPIDr,",")
        s i=1
        TSTART
        f i=i:1:len   d
		.s rowid=0
		.s rowid=..IfRepKPI(KPIDr,userId)
		.q:rowid>0  s SQLCODE="RepKPI"
		.s KPI=$P(KPIDr,",",i)
		.i KPI'="" s PLIST(2)=KPI
		.i userId'="" s PLIST(3)=userId
		.&sql(INSERT INTO dhc_pa_data.KPIAudit VALUES PLIST())
		i SQLCODE'=0  TROLLBACK
		e  TCOMMIT
		q SQLCODE
}

/// Creator: wang ying
/// CreatDate: 2010-07-29
/// Description: 更新记录
/// Table: dhc.pa.data.KPIAudit
/// Input: rowid-数据行号;data-待插入的数据(code^name^start^end^remark^tieOff);
/// Output: 
/// Return: 执行SQL语句返回SQLCODE
/// Others：w ##class(dhc.pa.udata.uKPIAudit).UpdateRec(1,"70^1397")
ClassMethod UpdateRec(rowid, data) As %String
{
		n (rowid,data)
		
		k PLIST
		q:data="" "EmptyRecData"
		
	
		s KPIDr=$p(data,"^",1)
		s userId=$p(data,"^",2)
		/*
		s user = $$ALPHAUP^SSUTIL4(UserCode)
		s userId = ""
		s userId = $o(^SSU("SSUSR",0,"SSUSR_Name",user,userId))
        */
		s id=0
		s id=..IfRepKPI(KPIDr, userId)
		q:(id'=0)&(id'=rowid) "RepKPI"
		
	

		s PLIST(2)=KPIDr
		s PLIST(3)=userId

		&SQL(UPDATE dhc_pa_data.KPIAudit VALUES PLIST() where %ID=:rowid)
		q SQLCODE
}

/// Creator: wang ying
/// CreatDate: 2010-07-29
/// Description: 删除记录
/// Table: dhc.pa.data.KPIAudit
/// Input：rowid-数据行号
/// Output: 
/// Return: 返回执行删除语句后的SQLCODE
/// Others: w ##class(dhc.pa.udata.uKPIAudit).DelRec("2")
ClassMethod DelRec(rowid) As %String
{
	&SQL(DELETE FROM dhc_pa_data.KPIAudit WHERE %ID=:rowid)
	q SQLCODE
}

/// Creator：wang ying
/// CreatDate：2010-7-29
/// Description: 获取顶层的KPI指标
/// Table：dhc_pa_data.KPIIndex1
/// Input：start:开始记录位置;limit:单页记录条数;str-模糊查询字符串
/// Output：
/// Return：有效指标字符串
/// Others：w ##class(dhc.pa.udata.uKPIAudit).GetKPIs("","","")
ClassMethod GetKPIs(start, limit, str) As %String
{
	n (start, limit, str)
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "SELECT KPIIndex1_rowid,KPIIndex1_name FROM dhc_pa_data.KPIIndex1 where %ID>0 and KPIIndex1_isKPI='Y' and KPIIndex1_isEnd='Y'"
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
		
		s tmp=rowid_"^"_name
		i (start'="")&&(limit'="") d
		.i (count>start)&(count<=end) d
		..s count = count+1
		..d json.InsertRowData(tmp)
		e  d
		.s count = count+1
		.d json.InsertRowData(tmp)
	}
	d result.Close()
	s resultString = json.getJsonData("rowid^name",count)
 	k json
	q resultString
}

/// Creator：wang ying
/// CreatDate：2010-7-29
/// Description: 获取顶层的KPI指标
/// Table：dhc_pa_data.KPIIndex1
/// Input：start:开始记录位置;limit:单页记录条数;str-模糊查询字符串
/// Output：
/// Return：有效指标字符串
/// Others：w ##class(dhc.pa.udata.uKPIAudit).GetKPI(1)
ClassMethod GetKPI(userCode, str) As %String
{
	n (userCode,str)
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "select * from dhc_pa_data.KPIIndex1 where KPIIndex1_rowid not in (select KPIAudit_KPIDr from dhc_pa_data.KPIAudit where KPIAudit_rowid>0 and KPIAudit_userDr='"_userCode_"') and KPIIndex1_rowid>0"
	s getAuditKPIStr=##class(dhc.pa.udata.uComm).GetAuditKPIStr("","")
	s sqlStr=sqlStr_getAuditKPIStr //2016-8-2 add cyl
	i str'="" s sqlStr = sqlStr_" and KPIIndex1_shortcut LIKE '%"_str_"%'"
	d result.Prepare(sqlStr)
	d result.Execute()
	;w sqlStr,!
	s count = 0
	s resultString = ""
	s json = ##class(dhc.pa.comm.JsonObj).%New()
	While(result.Next()){
		s rowid = result.Data("KPIIndex1_rowid")
		
		
		s name = result.Data("KPIIndex1_name")
		
		s tmp=rowid_"^"_name
		
		s count = count+1
		d json.InsertRowData(tmp)
	}
	d result.Close()
	s resultString = json.getJsonData("rowid^name",count)
 	k json
	q resultString
}

/// Creator: wang ying
/// CreatDate: 2010-08-02
/// Description: 找出用户
/// Table: SSUser
/// Input: code-代码
/// Output: 
/// Return: 
/// Others: w ##class(dhc.pa.udata.uKPIAudit).findUser(0,25,"李")
ClassMethod findUser(start, limit, str) As %String
{
	n (start, limit,str)
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr="SELECT SSUSR_RowId,SSUSR_Initials,SSUSR_Name FROM SS_User WHERE %ID>0"
	i str'="" s sqlStr = sqlStr_" and SSUSR_Name LIKE '"_str_"%'"
	
	d result.Prepare(sqlStr)
	d result.Execute()

	s count = 0
	s resultString = ""
	s end = start+limit
	s json = ##class(dhc.pa.comm.JsonObj).%New()
	While(result.Next()){
		s rowid = result.Data("SSUSR_RowId")
		
		s CODE = result.Data("SSUSR_Initials")
		s name = result.Data("SSUSR_Name")
		s name=name_"-"_CODE
		
		
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

Storage Default
{
<StreamLocation>^dhc.pa.udata.uKPIAuditS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
