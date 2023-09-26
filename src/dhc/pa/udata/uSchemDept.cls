Class dhc.pa.udata.uSchemDept Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Creator：吴顺
/// CreatDate：2015-05-18
/// Description: 归口科室管理
/// Table：dhc_pa_data.Schem ,dhc_pa_data.jxUnit ,dhc_pa_data.schem_MDept
/// Input：起止记录数
/// Output：
/// Return：取出方案编码、方案名称及归口科室信息
/// others:w ##class(dhc.pa.udata.uSchemDept).List("code","001","","",0,25)
ClassMethod List(searchField, searchValue, sortField, sortDir, start, limit) As %String
{
	n (searchField, searchValue,sortField,sortDir,start,limit)
	s sqlStr="select b.SCM_RowID,a.Schem_rowid,a.Schem_code,a.Schem_name,c.JXUnit_rowid,c.JXUnit_name,b.SCM_UserDR,b.SCM_UserDR->SSUSR_Name from dhc_pa_data.Schem a,dhc_pa_data.jxUnit c,dhc_pa_data.schem_MDept b" 
	s whereStr=" where b.SCM_SchemDR=a.Schem_rowid and b.SCM_DeptDr=c.JXUnit_rowid"
		
	
	
	s sortStr=""
	s sortField1=""
		
	i sortField'="" d
	.i sortField="rowid" s sortField1="SCM_RowID"
	.i sortField="code" s sortField1="Schem_code"
    .i sortField="name" s sortField1="Schem_name"
    .i sortField="jname" s sortField1="JXUnit_name"
    .i sortField="userName" s sortField1="SSUSR_Name"
			
	i sortField1'="" d
	.s sortDir=$ZCONVERT(sortDir,"u")
	.i (sortDir="DESC")||(sortDir="ASC") s sortStr=" ORDER BY "_sortField1_" "_sortDir
	.e  s sortStr=" ORDER BY "_sortField1_" ASC"
	;e  d
	;.s sortStr=" ORDER BY %ID DESC"
	
	s sqlStr=sqlStr_whereStr_sortStr
	
	;w sqlStr,!
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	s count=0
	s resultString=""
	s end=start+limit
	
	
	s json=##class(dhc.pa.comm.JsonObj).%New()
	s jsonTitle="rowid^schemDr^code^name^jxunitDr^jname^userDr^userName"
	While(result.Next())
	{   
		s rowid=result.Data("SCM_RowID")
		s schemDr=result.Data("Schem_rowid")
		s code=result.Data("Schem_code")
		s name=result.Data("Schem_name")
		s JXUnitDr=result.Data("JXUnit_rowid")
		s jname=result.Data("JXUnit_name")
		s userDr = result.Data("SCM_UserDR")
		s userName=result.Data("SSUSR_Name")
		s tmp=rowid_"^"_schemDr_"^"_code_"^"_name_"^"_JXUnitDr_"^"_jname_"^"_userDr_"^"_userName
		i searchValue'="" d
		.q:(searchField="name")&(name'[searchValue)
		.q:(searchField="jname")&(jname'[searchValue)
		.q:(searchField="userName")&(userName'[searchValue)
		.q:(searchField="code")&(code'[searchValue)
	 	.s count=count+1
	 	.i (count>start)&(count<=end) d
	 	..s count=count+1
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

/// Table：dhc_pa_data.JXUnit
/// Input：
/// Output：
/// Return：取出归口科室列表
/// Others: w ##class(dhc.pa.udata.uSchemDept).listDept()
ClassMethod listDept(start, limit, str) As %String
{
	
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "select JXUnit_rowid,JXUnit_name from dhc_pa_data.JXUnit where %ID>0"
	i str'="" s sqlStr=sqlStr_" and JXUnit_name like '"_str_"%'"
	;w sqlStr,!
	d result.Prepare(sqlStr)
	d result.Execute()
	s count=0
	s resultString=""
	s end=start+limit
	
	s json = ##class(dhc.pa.comm.JsonObj).%New()
	While(result.Next()){
		s rowid = result.Data("JXUnit_rowid")
		s name = result.Data("JXUnit_name")
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

/// Return：取出方案名称列表
/// Others: w ##class(dhc.pa.udata.uSchemDept).listSchem(0,10,"")
ClassMethod listSchem(start, limit, str) As %String
{
	
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "select Schem_rowid,Schem_code,Schem_name,Schem_frequency from dhc_pa_data.schem where Schem_childSub>0"
	i str'="" s sqlStr=sqlStr_" and Schem_name like '"_str_"%'"
	
	;w sqlStr,!
	d result.Prepare(sqlStr)
	d result.Execute()
	s count = 0
	s resultString = ""
	s end=start+limit
	s json = ##class(dhc.pa.comm.JsonObj).%New()
	While(result.Next()){
		s rowid = result.Data("Schem_rowid")
		s code = result.Data("Schem_code")
		s name = result.Data("Schem_name")
		s type = result.Data("Schem_frequency")
		s tmp=rowid_"^"_code_"^"_name_"!"_type
		s count = count+1
		i (count>start)&(count<=end) d
		.d json.InsertRowData(tmp)
	}
	d result.Close()
	s resultString = json.getJsonData("rowid^code^name",count)
 	k json
	q resultString
}

/// Return：取出负责人列表
/// Others: w ##class(dhc.pa.udata.uSchemDept).listSuser()
ClassMethod listSuser(start, limit, str) As %String
{
	
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "select SSUSR_RowId,SSUSR_Name from SQLUser.SS_User where %ID>0"
	i str'="" s sqlStr=sqlStr_" and SSUSR_Name like '"_str_"%' or SSUSR_Initials like '"_str_"%'"
	d result.Prepare(sqlStr)
	d result.Execute()
	s count = 0
	s resultString = ""
	s end=start+limit
	s json = ##class(dhc.pa.comm.JsonObj).%New()
	While(result.Next()){
		s rowid = result.Data("SSUSR_RowId")
		
		s suser = result.Data("SSUSR_Name")
		s tmp=rowid_"^"_suser
		s count = count+1
		i (count>=start)&(count<=end) d
		.d json.InsertRowData(tmp)
	}
	d result.Close()
	s resultString = json.getJsonData("rowid^suser",count)
 	k json
	q resultString
}

/// 添加
/// Table：dhc_pa_data.Schem ,dhc_pa_data.jxUnit ,dhc_pa_data.schem_MDept
/// Others：w ##class(dhc.pa.udata.uSchemDept).InsertInfo("1||26","4","3")
ClassMethod InsertInfo(name, jname, suser) As %String
{
	n ( name,jname,suser)
	s rowid=0
 	
 	s rowid=..IfRepScheme(name, jname,suser)
	i rowid'=0{
	q "RepScheme"}
	
	//&sql(insert into dhc_pa_data.schem(Schem_code,Schem_name) values(:code,:name))
	&sql(insert into dhc_pa_data.schem_MDept(SCM_SchemDR,SCM_DeptDr,SCM_UserDR) values(:name,:jname,:suser))
	q SQLCODE
}

/// Table：dhc_pa_data.Schem ,dhc_pa_data.jxUnit ,dhc_pa_data.schem_MDept
/// Input：code-方案代码；jname-归口科室
/// Output：
/// Return：更新归口科室
/// Others：w ##class(dhc.pa.udata.uSchemDept).Update("45","医务部")
ClassMethod UpdateOld(rowid, jname) As %String
{
	n (rowid,jname)
	s tmprowid=""
	
	&sql(select JXUnit_rowid into:tmprowid from dhc_pa_data.jxUnit where JXUnit_name=:jname)
	&sql(update dhc_pa_data.schem_MDept set SCM_DeptDr=:tmprowid where SCM_RowID=:rowid )
	
	q SQLCODE
}

/// Table：dhc_pa_data.Schem ,dhc_pa_data.jxUnit ,dhc_pa_data.schem_MDept
/// Input：code-方案代码；jname-归口科室
/// Output：
/// Return：更新归口科室
/// Others：w ##class(dhc.pa.udata.uSchemDept).Update("45","医务部")
ClassMethod Update(rowid, data) As %String
{
	n (rowid,data)
	q:rowid="" "Norowid"
	q:data="" "NoData"
	
	s schemDr=$p(data,"^",1)
	s jxunitDr=$p(data,"^",2)
	s userDr=$p(data,"^",3)
	k PLIST

	
	s Plist(2) = schemDr
	s Plist(3) = jxunitDr
	s Plist(4) = userDr
	&sql(Update dhc_pa_data.schem_MDept VALUES Plist() where  %ID = :rowid)
	q SQLCODE
}

/// 是否重复
/// Others:w ##class(dhc.pa.udata.uSchemDept).IfRepScheme("1||12","6","4")
ClassMethod IfRepScheme(SCMSchemDR, SCMDeptDr, SCMUserDR) As %String [ SqlProc ]
{
  n (SCMSchemDR, SCMDeptDr, SCMUserDR)  
  s rowid =0
  s rowid =$o(^DHCCJXPAschemMDeptI("SCMschemDrJXUnitUser",SCMSchemDR, SCMDeptDr,SCMUserDR,rowid)) 
  i rowid ="" d  s rowid=0 
  ;w rowid,!
  q rowid
}

Storage Default
{
<StreamLocation>^dhc.pa.udata.uSchemDeptS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
