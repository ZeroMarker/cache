/// Creator: 李明忠
/// CreatDate: 2010-07-30
/// Description: 绩效单元权限设置表维护
Class dhc.pa.udata.uJXUnitAudit Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Creator：李明忠
/// CreatDate：2010-7-30
/// Description: 查询符合条件的绩效单元权限设置记录
/// Table：dhc_pa_data.JXUnitAudit
/// Input：jxUnitDr-绩效单元ID;searchField-查询字段;searchValue-查询值;sortField-排序字段;sortDir-排序方向;start-起始行;limit-行数;
/// Output：
/// Return：返回查询到的记录的Json串
/// Others:w ##class(dhc.pa.udata.uJXUnitAudit).List("","","rowid","DESC",0,25)
ClassMethod List(searchField, searchValue, sortField, sortDir, start, limit) As %String
{
	n (searchField, searchValue, sortField, sortDir, start, limit)
	
	//SQL
	s sqlStr="select JXUnitAudit_rowid,JXUnitAudit_jxUnitDr,JXUnitAudit_userDr,JXUnitAudit_isRead,JXUnitAudit_isWrite from dhc_pa_data.JXUnitAudit"
	s whereStr=" where %ID>0"
	
	s sortStr="",sortField1=""
	i sortField'="" d
	.i sortField="rowid" s sortField1="JXUnitAudit_rowid"
	.i sortField="jxUnitName" s sortField1="JXUnitAudit_jxUnitDr"
	.i sortField="userName" s sortField1="JXUnitAudit_userDr"
	.i sortField="isRead" s sortField1="JXUnitAudit_isRead"
	.i sortField="isWrite" s sortField1="JXUnitAudit_isWrite"
	
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
	s jsonTitle="rowid^jxUnitDr^jxUnitName^userDr^userName^isRead^isWrite"
	While(result.Next()){
		//集体初始化
		s jxUnitName="",userName=""
		
		s rowid=result.Data("JXUnitAudit_rowid")
		s jxUnitDr=result.Data("JXUnitAudit_jxUnitDr")
		i jxUnitDr'="" d
		.i $D(^DHCCJXPAJXUNIT(jxUnitDr)) d
		..i $G(^DHCCJXPAJXUNIT(jxUnitDr))'="" d
		...s jxUnitName=$P(^DHCCJXPAJXUNIT(jxUnitDr),"^",3)
		
		s userDr=result.Data("JXUnitAudit_userDr")
		i userDr'="" d
		.i $D(^SSU("SSUSR",userDr)) d
		..i $G(^SSU("SSUSR",userDr))'="" d
		...s userName=$P(^SSU("SSUSR",userDr),"^",2)
		s isRead=result.Data("JXUnitAudit_isRead")
		s isWrite=result.Data("JXUnitAudit_isWrite")
		
		s tmp=rowid_"^"_jxUnitDr_"^"_jxUnitName_"^"_userDr_"^"_userName_"^"_isRead_"^"_isWrite
		
		i searchValue'="" d
		.q:(searchField = "userName")&(userName'[searchValue)
		.q:(searchField = "jxUnitName")&(jxUnitName'[searchValue)
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
/// CreatDate：2010-9-13
/// Description: 获取绩效单元
/// Table：dhc_pa_data.JXBaseData
/// Input：start:开始记录位置;limit:单页记录条数;str-模糊查询字符串
/// Output：
/// Return：有效绩效单元字符串
/// Others：w ##class(dhc.pa.udata.uJXUnitAudit).GetJXUnit(0,10,"内")
ClassMethod GetJXUnit(start, limit, str) As %String
{
	n (start, limit, str)
	
	//查询当前战略
	s Stratagem = ""
	s curreStratagemDr = ""
	f  s Stratagem=$o(^DHCCJXPASTRATAGEM(Stratagem)) q:Stratagem=""  d
	.i $D(^DHCCJXPASTRATAGEM(Stratagem)) d
	..i $G(^DHCCJXPASTRATAGEM(Stratagem))'="" d
	...s curreStratagem = $P(^DHCCJXPASTRATAGEM(Stratagem),"^",14)
	...i curreStratagem="Y" d
	....s curreStratagemDr = Stratagem
	
	
	

	//是否参与核算标志
	s isEnd="Y"
	
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "select JXUnit_rowid,JXUnit_shortcut from dhc_pa_data.JXUnit where %ID>0 and JXUnit_level=2 "
	;and JXUnit_appSysDr=2"
	;s whereStr=" and JXUnit_isEnd='"_isEnd_"'"
	;s whereStr=" and JXUnit_stratagemDr='"_curreStratagemDr_"'"
	s whereStr=""
	i str'="" s whereStr=" and JXUnit_shortcut like '%"_str_"%'"
	
	s sqlStr=sqlStr_whereStr
	d result.Prepare(sqlStr)
	d result.Execute()

	s count = 0
	s resultString = ""
	s end = start+limit
	s json = ##class(dhc.pa.comm.JsonObj).%New()
	While(result.Next()){
		s jxUnitDr = result.Data("JXUnit_rowid")
		s jxUnitShortCut = result.Data("JXUnit_shortcut")
		s tmp=jxUnitDr_"^"_jxUnitShortCut
		s count = count+1
		i (count>start)&(count<=end) d
		.d json.InsertRowData(tmp)
	}
	d result.Close()
	s resultString = json.getJsonData("jxUnitDr^jxUnitShortCut",count)
 	k json
	q resultString
}

/// Creator：李明忠
/// CreatDate：2010-7-30
/// Description: 获取trakcare用户
/// Table：User.SSUser
/// Input：start:开始记录位置;limit:单页记录条数;str-模糊查询字符串
/// Output：
/// Return：有效trakcare用户字符串
/// Others：w ##class(dhc.pa.udata.uJXUnitAudit).GetUser(0,10,"")
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

/// Creator：李明忠
/// CreatDate：2010-7-30
/// Description: 判断绩效单元是否存在一个用户多条权限记录
/// Table：dhc_pa_data.JXUnitAudit
/// Input：jxUnitDr-绩效单元ID;userDr-trakcare用户ID
/// Output：
/// Return：返回childSub
/// Others：w ##class(dhc.pa.udata.uJXUnitAudit).IfRepRecode()
ClassMethod IfRepRecode(jxUnitDr, userDr) As %String
{
	n (jxUnitDr, userDr)
	
	s rowid=0
	s rowid = $O(^DHCCJXPAJXUNITAUDIT(0,"JXUnitUser",jxUnitDr,userDr,rowid))
	i rowid="" s rowid=0
	q rowid
}

/// Creator：李明忠
/// CreatDate：2010-7-30
/// Description: 为给定的绩效单元添加用户权限记录
/// Table：dhc_pa_data.JXUnitAudit
/// Input：data-待插入数据(jxunitdr^userdr^isRead^isWrite);
/// Output：
/// Return：返回SQLCODE
/// Others：w ##class(dhc.pa.udata.uJXUnitAudit).Insert("10^47^Y^Y")
ClassMethod Insert(data) As %String
{
	n (data)
	
	q:data="" "dataEmpt"      				//空数据dataEmpt
	k PLIST
	
	s jxUnitDr=$p(data,"^",1)				//绩效单元
	i jxUnitDr'="" s PLIST(2)=jxUnitDr 
	
	s userDr=$p(data,"^",2)					//用户
	i userDr'="" s PLIST(3)=userDr
	
	s isRead=$p(data,"^",3)					//读权限
	i isRead'="" s PLIST(4)=isRead
	
	s isWrite=$p(data,"^",4)				//写权限
	i isWrite'="" s PLIST(5)=isWrite
	
	q:(..IfRepRecode(jxUnitDr,userDr))'=0 "RepRecode" 

	&SQL(insert into dhc_pa_data.JXUnitAudit VALUES PLIST())
	q SQLCODE
}

/// Creator：李明忠
/// CreatDate：2010-7-30
/// Description: 为给定的绩效单元添加用户权限记录
/// Table：dhc_pa_data.JXUnitAudit
/// Input：data-待插入数据(jxunitdr^userdr^isRead^isWrite);
/// Output：
/// Return：返回SQLCODE
/// Others：w ##class(dhc.pa.udata.uJXUnitAudit).Inserts("3,4,5^47^Y^Y")
ClassMethod Inserts(data) As %String
{
	n (data)
	
	q:data="" "dataEmpt"      				//空数据dataEmpt
	
	s jxUnitDr=$p(data,"^",1)				//绩效单元
	s userDr=$p(data,"^",2)					//用户
	s isRead=$p(data,"^",3)					//读权限
	s isWrite=$p(data,"^",4)				//写权限
	
	s len=$l(jxUnitDr,",")
	s SQLCODE=0
	TSTART
	f i=1:1:len d
	.s jxUnit=$p(jxUnitDr,",",i)
	.s SQLCODE=..Insert(jxUnit_"^"_userDr_"^"_isRead_"^"_isWrite)
	i SQLCODE'=0 TROLLBACK
	e  TCOMMIT
	
	q SQLCODE
}

/// Creator:李明忠
/// CreatDate:2010-7-30
/// Description:删除绩效单元下的用户权限记录
/// Table:dhc_pa_data.JXUnitAudit
/// Input:rowid-用户权限记录ID
/// Output: 
/// Return:返回执行删除语句后的SQLCODE
/// Others:w ##class(dhc.pa.udata.uJXUnitAudit).Delete(4)
ClassMethod Delete(rowid) As %String
{
	n (rowid)
	
	&SQL(delete from dhc_pa_data.JXUnitAudit where %ID=:rowid)
	q SQLCODE
}

/// Creator：李明忠
/// CreatDate：2010-7-30
/// Description: 更新绩效单元下的用户权限记录
/// Table：dhc_pa_data.JXUnitAudit
/// Input：rowid-所在行号;data-数据字符串(jxunitdr^userdr^isRead^isWrite);
/// Output：
/// Return：返回执行更新语句后的SQLCODE
/// Others：w ##class(dhc.pa.udata.uJXUnitAudit).Update(1,"10^47^Y^Y")
ClassMethod Update(rowid, data) As %String
{
	n (rowid, data)
	
	q:rowid="" "rowidEmpt"					//错误数据
	q:data="" "dataEmpt"      				//空数据dataEmpt
	k PLIST
	
	s jxUnitDr=$p(data,"^",1)				//绩效单元
	i jxUnitDr'="" s PLIST(2)=jxUnitDr 
	
	s userDr=$p(data,"^",2)					//用户
	i userDr'="" s PLIST(3)=userDr
	
	s isRead=$p(data,"^",3)					//读权限
	i isRead'="" s PLIST(4)=isRead
	
	s isWrite=$p(data,"^",4)				//写权限
	i isWrite'="" s PLIST(5)=isWrite
	
	s RowId=..IfRepRecode(jxUnitDr,userDr)
	q:(RowId'=0)&(RowId'=rowid) "RepRecode"
	
	&sql(update dhc_pa_data.JXUnitAudit values PLIST() where %ID=:rowid)
	q SQLCODE
}

/// Creator：李明忠
/// CreatDate：2010-9-13
/// Description: 获取绩效单元
/// Table：dhc_pa_data.JXBaseData
/// Input：start:开始记录位置;limit:单页记录条数;str-模糊查询字符串
/// Output：
/// Return：有效绩效单元字符串
/// Others：w ##class(dhc.pa.udata.uJXUnitAudit).GetJXUnits("1","")
ClassMethod GetJXUnits(userId, str) As %String
{
	n (userId,str)
	

	//是否参与核算标志
	s isEnd="Y"
	
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "select * from dhc_pa_data.JXUnit where JXUnit_rowid>0 and JXUnit_rowid not in (select JXUnitAudit_jxUnitDr from dhc_pa_data.JXUnitAudit where JXUnitAudit_userDr='"_userId_"')"
	s getAuditUnitStr=##class(dhc.pa.udata.uComm).GetAuditUnitStr("","") //2016-8-2
	s whereStr=""
	s whereStr=whereStr_getAuditUnitStr
	;s whereStr=" and JXUnit_stratagemDr='"_curreStratagemDr_"'"
	i str'="" s whereStr=whereStr_" and JXUnit_shortcut like '%"_str_"%'"
	
	s sqlStr=sqlStr_whereStr

	d result.Prepare(sqlStr)
	d result.Execute()

	s count = 0
	s resultString = ""
	s json = ##class(dhc.pa.comm.JsonObj).%New()
	While(result.Next()){
		s jxUnitDr = result.Data("JXUnit_rowid")
		s jxUnitShortCut = result.Data("JXUnit_shortcut")
		s tmp=jxUnitDr_"^"_jxUnitShortCut
		s count = count+1
        d json.InsertRowData(tmp)
	}
	d result.Close()
	s resultString = json.getJsonData("jxUnitDr^jxUnitShortCut",count)
 	k json
	q resultString
}

Storage Default
{
<StreamLocation>^dhc.pa.udata.uJXUnitAuditS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
