Class User.uACCTSysMode Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// w ##class(User.uACCTSysMode).Insert(4002,"设备管理",1)
ClassMethod Insert(code, name, isAutoVouch) As %String
{
	n (code,name,isAutoVouch)
	&sql(insert into ACCT_SysMode (mod_code,mod_name,is_auto_vouch) values(:code,:name,:isAutoVouch))
	q SQLCODE
}

/// w ##class(User.uACCTSysMode).Update(2,4003,"设备管理",1)
ClassMethod Update(rowid, code, name, isAutoVouch) As %String
{
	n (rowid,code,name,isAutoVouch)
	&sql(update ACCT_SysMode set mod_code=:code,mod_name=:name,is_auto_vouch=:isAutoVouch where %ID=:rowid)
	q SQLCODE
}

/// w ##class(User.uACCTSysMode).Delete(2)
ClassMethod Delete(rowid) As %String
{
	n (rowid)
	&SQL(DELETE FROM ACCT_SysMode WHERE %ID=:rowid)
	q SQLCODE
}

/// w ##class(User.uACCTSysMode).List()
ClassMethod List() As %String
{
	s sqlStr="select * from ACCT_SysMode"
	s whereStr=" WHERE %ID>0 "
	s sortStr=" ORDER BY %ID DESC"
	
	s sqlStr=sqlStr_whereStr_sortStr
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	
	s count=0
	s resultString=""
	
	s json=##class(web.com.JsonObj).%New()
	s jsonTitle="rowid^code^name^isAutoVouch"
	
	While(result.Next())
	{
		s rowid = result.Data("ID")
		s code = result.Data("mod_code")
		s name = result.Data("mod_name")
		s isAutoVouch = result.Data("is_auto_vouch")
		s tmp=rowid_"^"_code_"^"_name_"^"_isAutoVouch
		d json.InsertRowData(tmp)
		s count=count+1
	}
	d result.Close()
	s resultString = json.getJsonData(jsonTitle,count)
 	k json
	q resultString
}

Storage Default
{
<StreamLocation>^User.uACCTSysModeS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
