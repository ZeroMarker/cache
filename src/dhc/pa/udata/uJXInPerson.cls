/// Creator: 李明忠
/// CreatDate: 2010-11-25
/// Description: 内部人员表
Class dhc.pa.udata.uJXInPerson Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Creator:李明忠
/// CreatDate:2010-11-25
/// Description:查询绩效单元记录
/// Table:dhc_pa_data.JXUnit
/// Input:searchField-查询字段;searchValue-查询值;sortField-排序字段;sortDir-排序方向;start-起始行;limit-行数
/// Output:
/// Return:返回查询到的记录的Json串
/// Others:w ##class(dhc.pa.udata.uJXInPerson).JXUnitList("","","","",0,25)
ClassMethod JXUnitList(searchField, searchValue, sortField, sortDir, start, limit) As %String
{
	n (searchField, searchValue, sortField, sortDir, start, limit)
	
	//获取当前方案
	s stratagemDr = 0
	s curreStratagemDr = 0
	f  s stratagemDr=$O(^DHCCJXPASTRATAGEM(stratagemDr)) q:stratagemDr=""  d
	.i $D(^DHCCJXPASTRATAGEM(stratagemDr)) d
	..i $G(^DHCCJXPASTRATAGEM(stratagemDr))'="" d
	...s curreStratagem = $P(^DHCCJXPASTRATAGEM(stratagemDr),"^",14)
	...i curreStratagem="Y" d
	....s curreStratagemDr = stratagemDr

	s sqlStr="select JXUnit_rowid,JXUnit_code,JXUnit_name,JXUnit_py,JXUnit_shortcut from dhc_pa_data.JXUnit where %ID>0 and JXUnit_isEnd='Y' and JXUnit_stratagemDr="_curreStratagemDr
	s sortStr=""
	s sortField1=""
	
	i sortField'="" d
	.i sortField="rowid" s sortField1="JXUnit_rowid"
	.i sortField="code" s sortField1="JXUnit_code"
	.i sortField="name" s sortField1="JXUnit_name"
	.i sortField="shortcut" s sortField1="JXUnit_shortcut"
	.i sortField="py" s sortField1="JXUnit_py"
	
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
	s jsonTitle="rowid^code^name^shortcut^py"
	
	While(result.Next()){
		s rowid=result.Data("JXUnit_rowid")
		s code=result.Data("JXUnit_code")
		s name=result.Data("JXUnit_name")
		s shortcut=result.Data("JXUnit_shortcut")
		s py=result.Data("JXUnit_py")
		
		s tmp=rowid_"^"_code_"^"_name_"^"_shortcut_"^"_py
		
		i searchValue'="" d
		.i searchField = "active" d
		..i (searchValue="Y") || (searchValue="y") s searchValue="Y"
		..e  s searchValue="N"
		.i searchField = "flag" d
		..i (searchValue="Y") || (searchValue="y") s searchValue="Y"
		..e  s searchValue="N"
		.q:(searchField = "code")&(code'[searchValue)
		.q:(searchField = "name")&(name'[searchValue)
		.q:(searchField = "shortcut")&(shortcut'[searchValue)
		.q:(searchField = "py")&(py'[searchValue)
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
/// CreatDate：2010-11-25
/// Description: 获取trakcare用户
/// Table：User.SSUser
/// Input：start:开始记录位置;limit:单页记录条数;str-模糊查询字符串
/// Output：
/// Return：有效trakcare用户字符串
/// Others：w ##class(dhc.pa.udata.uJXInPerson).GetUser(0,10,"")
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

/// Creator:李明忠
/// CreatDate:2010-11-25
/// Description:查询内部人员记录
/// Table:dhc_pa_inter.JXInPerson
/// Input:jxUnitDr-绩效单元rowid;searchField-查询字段;searchValue-查询值;sortField-排序字段;sortDir-排序方向;start-起始行;limit-行数
/// Output:
/// Return:返回查询到的记录的Json串
/// Others:w ##class(dhc.pa.udata.uJXInPerson).PersonList(1,"","","","",0,25)
ClassMethod PersonList(jxUnitDr, searchField, searchValue, sortField, sortDir, start, limit) As %String
{
	s sqlStr="select JXInPerson_rowid,JXInPerson_jxUnitDr,JXInPerson_ssUserDr,JXInPerson_remark,JXInPerson_active from dhc_pa_inter.JXInPerson where %ID>0 and JXInPerson_jxUnitDr='"_jxUnitDr_"'"
	
	s sortStr=""
	s sortField1=""
	
	i sortField'="" d
	.i sortField="rowid" s sortField1="JXInPerson_rowid"
	.i sortField="jxUnitName" s sortField1="JXInPerson_jxUnitDr"
	.i sortField="userName" s sortField1="JXInPerson_ssUserDr"
	.i sortField="userCode" s sortField1="JXInPerson_ssUserDr"
	.i sortField="remark" s sortField1="JXInPerson_remark"
	.i sortField="active" s sortField1="JXInPerson_active"
	
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
	s jsonTitle="jxUnitDr^rowid^userDr^userCode^userName^remark^active"
	
	While(result.Next()){
		s userName="",userCode=""
		s rowid=result.Data("JXInPerson_rowid")
		s jxUnitDr=result.Data("JXInPerson_jxUnitDr")
		s userDr=result.Data("JXInPerson_ssUserDr")
		i userDr'="" d
		.i $D(^SSU("SSUSR",userDr)) d
		..i $G(^SSU("SSUSR",userDr))'="" d
		...s userName=$P(^SSU("SSUSR",userDr),"^",2)
		...s userCode=$P(^SSU("SSUSR",userDr),"^",1)
		
		s remark=result.Data("JXInPerson_remark")
		s active=result.Data("JXInPerson_active")
		
		s tmp=jxUnitDr_"^"_rowid_"^"_userDr_"^"_userCode_"^"_userName_"^"_remark_"^"_active
		
		i searchValue'="" d
		.i searchField = "active" d
		..i (searchValue="Y") || (searchValue="y") s searchValue="Y"
		..e  s searchValue="N"
		.q:(searchField = "userCode")&(userCode'[searchValue)
		.q:(searchField = "userName")&(userName'[searchValue)
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
/// CreatDate：2010-11-25
/// Description: 判断整个医院是否存在同一记录
/// Table：
/// Input：userDr-内部人员rowid
/// Output：
/// Return：返回RowId
/// Others：w ##class(dhc.pa.udata.uJXInPerson).IfRepRecode(1)
ClassMethod IfRepRecode(userDr) As %String
{
	n (userDr)
	
	s RowId=0
	s RowId=$O(^DHCCJXPAJXINPERSON(0,"ssUser",userDr,RowId))
	i RowId="" s RowId=0
	q RowId
}

/// Creator：李明忠
/// CreatDate：2010-11-25
/// Description: 判断一个绩效单元是否存在同一记录
/// Table：
/// Input：jxUnitDr-绩效单元rowid;userDr-内部人员rowid
/// Output：
/// Return：返回RowId
/// Others：w ##class(dhc.pa.udata.uJXInPerson).IfRepRecode2(1,1)
ClassMethod IfRepRecode2(jxUnitDr, userDr) As %String
{
	n (jxUnitDr,userDr)
	
	s RowId=0
	s RowId=$O(^DHCCJXPAJXINPERSON(0,"JXUnitUser",jxUnitDr,userDr,RowId))
	i RowId="" s RowId=0
	q RowId
}

/// Creator：李明忠
/// CreatDate：2010-11-25
/// Description: 为给定的绩效单元添加内部人员记录
/// Table：dhc_pa_inter.JXInPerson
/// Input：jxUnitDr-绩效单元rowid;userDr-内部人员rowid;remark-备注
/// Output：
/// Return：返回SQLCODE
/// Others：w ##class(dhc.pa.udata.uJXInPerson).Insert(1,1,"备注")
ClassMethod Insert(jxUnitDr, userDr, remark) As %String
{
	n (jxUnitDr,userDr,remark)

	q:jxUnitDr="" "NoUnit" 
	q:userDr="" "NoUser" 
	q:(..IfRepRecode(userDr))'=0 "RepRecode" 
	s active="Y"
	
	&SQL(insert into dhc_pa_inter.JXInPerson(JXInPerson_jxUnitDr,JXInPerson_ssUserDr,JXInPerson_remark,JXInPerson_active) VALUES(:jxUnitDr,:userDr,:remark,:active))
	q SQLCODE
}

/// Creator：李明忠
/// CreatDate：2010-11-25
/// Description: 更新接口套下的外部指标记录
/// Table：dhc_pa_inter.JXInPerson
/// Input：rowid-内部人员记录rowid;jxUnitDr-绩效单元rowid;userDr-内部人员rowid;remark-人员备注;active-有效标志
/// Output：
/// Return：返回执行更新语句后的SQLCODE
/// Others：w ##class(dhc.pa.udata.uJXInPerson).Update(2,2,"1","西药费","N")
ClassMethod Update(rowid, jxUnitDr, userDr, remark, active) As %String
{
	n (rowid,jxUnitDr,userDr,remark,active)
	
	q:rowid="" "rowidEmpt"	//错误数据
	
	s tempRowid=..IfRepRecode(userDr)
	q:(tempRowid'="")&(tempRowid'=rowid) "RepRecode"
	
	&sql(update dhc_pa_inter.JXInPerson set JXInPerson_jxUnitDr=:jxUnitDr,JXInPerson_ssUserDr=:userDr,JXInPerson_remark=:remark,JXInPerson_active=:active where %ID=:rowid)
	q SQLCODE
}

/// Creator:李明忠
/// CreatDate:2010-11-25
/// Description:删除绩效单元下的内部人员记录
/// Table:dhc_pa_inter.JXInPerson
/// Input:rowid-内部人员记录rowid
/// Output: 
/// Return:返回执行删除语句后的SQLCODE
/// Others:w ##class(dhc.pa.udata.uJXInPerson).Delete(4)
ClassMethod Delete(rowid) As %String
{
	n (rowid)
	
	&SQL(delete from dhc_pa_inter.JXInPerson where JXInPerson_rowid=:rowid)
	q SQLCODE
}

Storage Default
{
<StreamLocation>^dhc.pa.udata.uJXInPersonS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
