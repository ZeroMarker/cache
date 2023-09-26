/// Creator: zhangchao
/// CreatDate: 2015-05-19
/// Description: 自查权限设置
Class dhc.pa.udata.uDeptSchemAudit Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Creator: zhangchao
/// CreatDate:  2015-05-07
/// Description: 插入新记录
/// Table:dhc.pa.data.DeptSchemAudit
/// Others: w ##class(dhc.pa.udata.uDeptSchemAudit).InsertRec("2","1")
ClassMethod InsertRec(DschemDr As %String, DuserDr As %String) As %String
{
	n (DschemDr,DuserDr)
	q:..reRecord(DschemDr,DuserDr)'=0 "reRecord"
	&sql(INSERT INTO dhc_pa_data.DeptSchemAudit(DSA_DSchemDr,DSA_userDr,SAudit_isRead,SAudit_isWrite)VALUES(:DschemDr,:DuserDr,'Y','Y'))
	q SQLCODE
}

/// Creator: zhangchao
/// CreatDate:  2015-05-07
/// Description: 删除记录
/// Table:dhc.pa.data.DeptSchemAudit
/// Others: w ##class(dhc.pa.udata.uDeptSchemAudit).Delete(1)
ClassMethod Delete(rowid As %Integer) As %String
{
	n (rowid)
	&sql(Delete from dhc_pa_data.DeptSchemAudit where %ID = :rowid)
	q SQLCODE
}

/// Creator: zhangchao
/// CreatDate:  2015-05-07
/// Description: 修改记录
/// Table:dhc.pa.data.DeptSchemAudit
/// Others: w ##class(dhc.pa.udata.uDeptSchemAudit).Update("1","","")
ClassMethod Update(rowid As %Integer, DschemDr As %String, DuserDr As %String) As %String
{
	n (rowid,DschemDr,DuserDr)
	q:DschemDr="" "NoschemDr"
	q:DuserDr="" "NoUserDr"
	q:rowid="" "NoRowid"
	k PLIST
	;i DschemDr = "" s DschemDr = $list(^DHCCJXPADeptSchemAuditD(rowid),2)
	;i DuserDr = "" s DuserDr = $list(^DHCCJXPADeptSchemAuditD(rowid),3)
	q:((..reRecord(DschemDr,DuserDr)'=0)&(..reRecord(DschemDr,DuserDr)'=rowid)) "reRecord"
	s Plist(2) = DschemDr
	s Plist(3) = DuserDr
	&sql(Update dhc_pa_data.DeptSchemAudit VALUES Plist() where  %ID = :rowid)
	q SQLCODE
}

/// Creator: zhangchao
/// CreatDate:  2015-05-07
/// Description: 显示记录
/// Table:dhc.pa.data.DeptSchemAudit
/// Others: w ##class(dhc.pa.udata.uDeptSchemAudit).List("ssusrName","牛","","","0","10")
ClassMethod List(searchField, searchValue, sortField, sortDir, start, limit) As %String
{
	n (searchField, searchValue, sortField, sortDir, start, limit)
	s sqlStr = "select DSA_rowid,DSA_userDr,DSA_userDr->SSUSR_Name as ssusr_Name,DSA_DSchemDr,DSA_DSchemDr->DSC_name as dsc_name from dhc_pa_data.DeptSchemAudit "
	
	
	s sortStr=""
	s sortField1=""
		
	i sortField'="" d
	.i sortField="rowid" s sortField1="DSA_rowid"
	.i sortField="ssusrName" s sortField1="ssusr_Name"
    .i sortField="dscname" s sortField1="dsc_name"
			
	i sortField1'="" d
	.s sortDir=$ZCONVERT(sortDir,"u")
	.i (sortDir="DESC")||(sortDir="ASC") s sortStr=" ORDER BY "_sortField1_" "_sortDir
	.e  s sortStr=" ORDER BY "_sortField1_" ASC"
	e  d
	.s sortStr="ORDER BY %ID DESC"
		
	s sqlStr=sqlStr_sortStr
	
	s count = 0
	s end=start+limit
 	s result=##class(%Library.ResultSet).%New()
 	d result.Prepare(sqlStr)
 	d result.Execute()
 	s resultString = ""
 	s json = ##class(dhc.pa.comm.JsonObj).%New()
 	s jsonTitle = "DSArowid^ssuser^ssusr_name^dschemDr^dsc_name"
 	s ssusrName="",dscname=""
 	While(result.Next())
 	{
	 	s DSArowid = result.Data("DSA_rowid")
	 	s ssuser = result.Data("DSA_userDr")
	 	s ssusrName = result.Data("ssusr_Name")
	 	;w ssusrName,!
	 	s dscname = result.Data("dsc_name")
	 	s DSchemDr = result.Data("DSA_DSchemDr")
	 	s tmp = DSArowid_"^"_ssuser_"^"_ssusrName_"^"_DSchemDr_"^"_dscname
	 	i searchValue'="" d
		.q:(searchField="ssusrName")&(ssusrName'[searchValue)
		.q:(searchField="dscname")&(dscname'[searchValue)
	 	.s count=count+1
	 	.d json.InsertRowData(tmp)
		e  d
		.s count=count+1
		.i (count>start)&(count<=end) d
		..d json.InsertRowData(tmp)
	 	;w tmp,!
	}
 	d result.Close()
 	s resultString = json.getJsonData(jsonTitle,count)
 	k json
 	q resultString
}

/// Creator: zhangchao
/// CreatDate:  2015-05-07
/// Description: 显示用户的下拉框
/// Table:SS_USer
/// Others: w ##class(dhc.pa.udata.uDeptSchemAudit).Listuser(0,10,"")
ClassMethod Listuser(start, limit, str) As %String
{
	n (start, limit,str)
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr="SELECT SSUSR_RowId,SSUSR_Name FROM SS_User WHERE %ID>0"
	i str'="" s sqlStr = sqlStr_" and SSUSR_Name LIKE '"_str_"%'"
	
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

/// Creator: zhangchao
/// CreatDate:  2015-05-07
/// Description: 显示自查名称的下拉框
/// Table:dhc_pa_data.deptSchem
/// Others: w ##class(dhc.pa.udata.uDeptSchemAudit).Listdscname(0,10,"")
ClassMethod Listdscname(start, limit, str) As %String
{
	n (start, limit,str)
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr="select DSC_rowid,DSC_name from dhc_pa_data.deptSchem "
	i str'="" s sqlStr = sqlStr_"where DSC_name LIKE '"_str_"%'"
	
	d result.Prepare(sqlStr)
	d result.Execute()

	s count = 0
	s resultString = ""
	s end = start+limit
	s json = ##class(dhc.pa.comm.JsonObj).%New()
	While(result.Next()){
		s rowid = result.Data("DSC_rowid")
		s name = result.Data("DSC_name")
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

/// Creator:wang ying
/// CreatDate:2015-7-15
/// Description:判断是否有重复记录
/// Table:
/// Input:
/// Output:
/// Return:0 1
/// Others:w ##class(dhc.pa.udata.uDeptSchemAudit).reRecord(1,1)
ClassMethod reRecord(schemDr, UserDr) As %String
{
	q:schemDr="" "NoschemDr"
	q:UserDr="" "NoUserDr"
	s usrName=""
    
    s rerowid=0
	i $d(^DHCCJXPADeptSchemAuditI("DSchemUser",schemDr,UserDr)) d
	.s rerowid=$o(^DHCCJXPADeptSchemAuditI("DSchemUser",schemDr,UserDr,rerowid)) 
	q rerowid
}

Storage Default
{
<StreamLocation>^dhc.pa.udata.uDeptSchemAuditS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
