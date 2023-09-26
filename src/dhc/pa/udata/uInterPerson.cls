/// Creator: 李明忠
/// CreatDate: 2010-11-25
/// Description: 接口人员设置
Class dhc.pa.udata.uInterPerson Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Creator:李明忠
/// CreatDate:2010-11-25
/// Description:查询内部人员记录
/// Table:dhc_pa_data.JXInPerson
/// Input:searchField-查询字段;searchValue-查询值;sortField-排序字段;sortDir-排序方向;start-起始行;limit-行数
/// Output:
/// Return:返回查询到的记录的Json串
/// Others:w ##class(dhc.pa.udata.uInterPerson).InList("","","","",0,25)
ClassMethod InList(searchField, searchValue, sortField, sortDir, start, limit) As %String
{
	n (searchField, searchValue, sortField, sortDir, start, limit)

	s sqlStr="select DISTINCT JXInPerson_ssUserDr from dhc_pa_inter.JXInPerson where %ID>0 and JXInPerson_active='Y'"
	s sortStr=""
	s sortField1=""
	
	i sortField'="" d
	.i sortField="userDr" s sortField1="JXInPerson_ssUserDr"
	
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
	s jsonTitle="userDr^userCode^userName"
	
	While(result.Next()){
		s userName="",userCode=""
		s userDr=result.Data("JXInPerson_ssUserDr")
		i userDr'="" d
		.i $D(^SSU("SSUSR",userDr)) d
		..i $G(^SSU("SSUSR",userDr))'="" d
		...s userName=$P(^SSU("SSUSR",userDr),"^",2)
		...s userCode=$P(^SSU("SSUSR",userDr),"^",1)
		
		s tmp=userDr_"^"_userCode_"^"_userName
		
		i searchValue'="" d
		.i searchField = "active" d
		..i (searchValue="Y") || (searchValue="y") s searchValue="Y"
		..e  s searchValue="N"
		.i searchField = "flag" d
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

/// Creator:李明忠
/// CreatDate:2010-11-25
/// Description:查询接口人员记录
/// Table:dhc_pa_inter.InterPerson
/// Input:inDr-内部人员rowid;searchField-查询字段;searchValue-查询值;sortField-排序字段;sortDir-排序方向;start-起始行;limit-行数
/// Output:
/// Return:返回查询到的记录的Json串
/// Others:w ##class(dhc.pa.udata.uInterPerson).OutList(1,"","","","",0,25)
ClassMethod OutList(inDr, searchField, searchValue, sortField, sortDir, start, limit) As %String
{
	s sqlStr="select InterPerson_rowid,InterPerson_ssUserDr,InterPerson_code,InterPerson_name,InterPerson_inLocSetDr,InterPerson_remark,InterPerson_active from dhc_pa_inter.InterPerson where %ID>0 and InterPerson_ssUserDr='"_inDr_"'"
	
	s sortStr=""
	s sortField1=""
	
	i sortField'="" d
	.i sortField="rowid" s sortField1="InterPerson_rowid"
	.i sortField="code" s sortField1="InterPerson_code"
	.i sortField="name" s sortField1="InterPerson_name"
	.i sortField="LocSetName" s sortField1="InterPerson_inLocSetDr"
	.i sortField="remark" s sortField1="InterPerson_remark"
	.i sortField="active" s sortField1="InterPerson_active"
	
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
	s jsonTitle="rowid^userDr^code^name^inLocSetDr^LocSetName^remark^active"
	
	While(result.Next()){
		s LocSetName=""
		s rowid=result.Data("InterPerson_rowid")
		s userDr=result.Data("InterPerson_ssUserDr")
		s code=result.Data("InterPerson_code")
		s name=result.Data("InterPerson_name")
		s inLocSetDr=result.Data("InterPerson_inLocSetDr")
		i inLocSetDr'="" d
		.i $D(^DHCCJXPAINTERLOCSET(inLocSetDr)) d
		..i $G(^DHCCJXPAINTERLOCSET(inLocSetDr))'="" d
		...s LocSetName=$P(^DHCCJXPAINTERLOCSET(inLocSetDr),"^",3)
		s remark=result.Data("InterPerson_remark")
		s active=result.Data("InterPerson_active")
		
		s tmp=rowid_"^"_userDr_"^"_code_"^"_name_"^"_inLocSetDr_"^"_LocSetName_"^"_remark_"^"_active
		
		i searchValue'="" d
		.i searchField = "active" d
		..i (searchValue="Y") || (searchValue="y") s searchValue="Y"
		..e  s searchValue="N"
		.q:(searchField = "code")&(code'[searchValue)
		.q:(searchField = "name")&(name'[searchValue)
		.q:(searchField = "LocSetName")&(LocSetName'[searchValue)
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
/// Description: 获取接口套
/// Table：dhc_pa_inter.InterLocSet
/// Input：start:开始记录位置;limit:单页记录条数;str-模糊查询字符串
/// Output：
/// Return：有效接口套字符串
/// Others：w ##class(dhc.pa.udata.uInterPerson).GetLocSet(0,10,"")
ClassMethod GetLocSet(start, limit, str) As %String
{
	n (start, limit, str)
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "select InterLocSet_rowid,InterLocSet_name from dhc_pa_inter.InterLocSet where %ID>0 and InterLocSet_active='Y'"
	i str'="" s sqlStr = sqlStr_" and InterLocSet_shortcut like '"_str_"%'"
	
	d result.Prepare(sqlStr)
	d result.Execute()

	s count = 0
	s resultString = ""
	s end = start+limit
	s json = ##class(dhc.pa.comm.JsonObj).%New()
	While(result.Next()){
		s rowid = result.Data("InterLocSet_rowid")
		s name = result.Data("InterLocSet_name")
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
/// CreatDate：2010-11-25
/// Description: 判断内部人员在同一接口套下是否存在同一接口人员
/// Table：
/// Input：inDr-内部人员rowid;interLocSetDr-接口套rowid;code-接口人员代码
/// Output：
/// Return：返回RowId
/// Others：w ##class(dhc.pa.udata.uInterPerson).IfRepRecode(1,1,"1114")
ClassMethod IfRepRecode(inDr, interLocSetDr, code) As %String
{
	n (inDr,interLocSetDr,code)
	
	s RowId=0
	s RowId=$O(^DHCCJXPAINTERPERSON(0,"UserCodeLocSet",inDr,interLocSetDr,code,RowId))
	i RowId="" s RowId=0
	q RowId
}

/// Creator：李明忠
/// CreatDate：2010-11-25
/// Description: 为给定的内部人员添加接口人员记录
/// Table：dhc_pa_inter.InterPerson
/// Input：inDr-内部人员rowid;code-接口人员代码;name-接口人员名称;interLocSetDr-接口套rowid;remark-备注
/// Output：
/// Return：返回SQLCODE
/// Others：w ##class(dhc.pa.udata.uInterPerson).Insert(1,1,"ss",1,"备注")
ClassMethod Insert(inDr, code, name, interLocSetDr, remark) As %String
{
	n (inDr,code,name,interLocSetDr,remark)

	q:inDr="" "NoUser" 
	q:interLocSetDr="" "NoInterLocSetDr" 
	q:(..IfRepRecode(inDr,interLocSetDr,code))'=0 "RepRecode" 
	s active="Y"
	
	&SQL(insert into dhc_pa_inter.InterPerson(InterPerson_ssUserDr,InterPerson_code,InterPerson_name,InterPerson_inLocSetDr,InterPerson_remark,InterPerson_active) VALUES(:inDr,:code,:name,:interLocSetDr,:remark,:active))
	q SQLCODE
}

/// Creator：李明忠
/// CreatDate：2010-11-25
/// Description: 更新内部人员下的接口人员记录
/// Table：dhc_pa_inter.InterPerson
/// Input：rowid-内部人员记录rowid;inDr-内部人员rowid;code-接口人员代码;name-接口人员名称;interLocSetDr-接口套rowid;active-有效标志;remark-备注
/// Output：
/// Return：返回执行更新语句后的SQLCODE
/// Others：w ##class(dhc.pa.udata.uInterPerson).Update(2,2,"1","西药费","N")
ClassMethod Update(rowid, inDr, code, name, interLocSetDr, remark, active) As %String
{
	n (rowid,inDr,code,name,interLocSetDr,remark,active)
	
	q:rowid="" "rowidEmpt"	//错误数据
	
	s tempRowid=..IfRepRecode(inDr,interLocSetDr,code)
	q:(tempRowid'="")&(tempRowid'=rowid) "RepRecode"
	
	&sql(update dhc_pa_inter.InterPerson set InterPerson_ssUserDr=:inDr,InterPerson_code=:code,InterPerson_name=:name,InterPerson_inLocSetDr=:interLocSetDr,InterPerson_remark=:remark,InterPerson_active=:active where %ID=:rowid)
	q SQLCODE
}

/// Creator:李明忠
/// CreatDate:2010-11-25
/// Description:删除内部人员映射下的接口人员记录
/// Table:dhc_pa_inter.InterPerson
/// Input:rowid-接口人员记录rowid
/// Output: 
/// Return:返回执行删除语句后的SQLCODE
/// Others:w ##class(dhc.pa.udata.uInterPerson).Delete(4)
ClassMethod Delete(rowid) As %String
{
	n (rowid)
	
	&SQL(delete from dhc_pa_inter.InterPerson where InterPerson_rowid=:rowid)
	q SQLCODE
}

Storage Default
{
<StreamLocation>^dhc.pa.udata.uInterPersonS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
