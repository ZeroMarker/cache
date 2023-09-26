/// 医院质量管理系统---检查人员
/// Creator: 何佳兵
/// CreatDate: 2015-06-15
/// Description:
Class dhc.qm.udata.ucheckuser Extends %Persistent [ ClassType = serial, Not ProcedureBlock ]
{

/// Others: w ##class(dhc.qm.udata.ucheckuser).List("","")
ClassMethod List(name) As %String
{
	n (name)
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "select CheckUser_rowid,CheckUser_CheckDr,CheckUser_CheckDr->SSUSR_Name,CheckUser_active from dhc_qm_data.CheckUser "

	i name'="" d
	.&sql(select SSUSR_RowId into:temp from SQLUSER.SS_User where SSUSR_Name=:name )
	.s sqlStr=sqlStr_"where CheckUser_CheckDr ="_temp_""
	d result.Prepare(sqlStr)
	d result.Execute()
	
	s count = 0
	s resultString = ""
	s json = ##class(herp.comm.JsonObj).%New()
	While(result.Next()){
		s rowid = result.Data("CheckUser_rowid")
		s CheckDr = result.Data("CheckUser_CheckDr")
		s name = result.Data("SSUSR_Name")
		s active = result.Data("CheckUser_active")
		i active="Y" s active="是"
		i active="N" s active="否"
		s tmp=rowid_"^"_CheckDr_"^"_name_"^"_active
		s count = count+1
		d json.InsertRowData(tmp)
	}
	d result.Close()
	s resultString = json.getJsonData("rowid^CheckDr^name^active",count)
 	k json
	q resultString
}

/// Others: w ##class(dhc.qm.udata.ucheckuser).GetUser("0","10","王")
ClassMethod GetUser(start, limit, str) As %String
{
	n (start, limit, str)
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "select SSUSR_RowId,SSUSR_Name from SQLUSER.SS_User "
	i str'="" s sqlStr = sqlStr_" where  SSUSR_Name  LIKE '%"_str_"%'"
	d result.Prepare(sqlStr)
	d result.Execute()
	
	s count = 0
	s resultString = ""
	s end = start+limit
	s json = ##class(herp.comm.JsonObj).%New()
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

/// Others: w ##class(dhc.qm.udata.ucheckuser).Ifname(14)
ClassMethod Ifname(name) As %String
{
	&sql(select CheckUser_rowid into:rowid from dhc_qm_data.CheckUser where CheckUser_CheckDr=:name)
	q rowid
}

/// Others: w ##class(dhc.qm.udata.ucheckuser).Insert(14,"Y")
ClassMethod Insert(name, active) As %String
{
	n (name,active)
	s flag=..Ifname(name)
	i flag'="" q "RepName"

	&sql(insert into dhc_qm_data.CheckUser values(:name,:active))
	q SQLCODE
}

/// Others: w ##class(dhc.qm.udata.ucheckuser).Delete("1")
ClassMethod Delete(rowid) As %String
{
	&sql(delete from dhc_qm_data.CheckUser where CheckUser_rowid=:rowid )
	q SQLCODE
}

/// Others: w ##class(dhc.qm.udata.ucheckuser).Update(8,"N")
ClassMethod Update(rowid, newname, checktive, flag) As %String
{
	n (rowid, newname, checktive,flag)
	if (flag=1){
		s flag=..Ifname(newname)
		i flag'="" q "RepName"
		&sql(update dhc_qm_data.CheckUser set CheckUser_CheckDr=:newname,CheckUser_active=:checktive where CheckUser_rowid=:rowid )	
		q SQLCODE
	}else{
		&sql(update dhc_qm_data.CheckUser set CheckUser_active=:checktive where CheckUser_rowid=:rowid )	
		q SQLCODE	
	}
}

Storage Default
{
<ExtentSize>100000</ExtentSize>
<StreamLocation>^dhc.qm.udata.ucheckuserS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
