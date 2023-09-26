Class User.uACCTSysBusiType Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// w ##class(User.uACCTSysBusiType).Insert(1,"001","asd","G^^N^N",1,1)
ClassMethod Insert(acctSysModeDr, typeCode, typeName, whileSql, isPhase, isInstall) As %String
{
	n (acctSysModeDr, typeCode, typeName, whileSql, isPhase, isInstall)
	&sql(insert into ACCT_SysBusiType (ACCT_SysMode_Dr,type_code,type_name,while_sql,is_phase,is_install) values(:acctSysModeDr, :typeCode, :typeName, :whileSql, :isPhase, :isInstall))
	q SQLCODE
}

/// w ##class(User.uACCTSysBusiType).Update(10,1,"002","ddd","",0,0)
ClassMethod Update(rowid, acctSysModeDr, typeCode, typeName, whileSql, isPhase, isInstall) As %String
{
	n (rowid, acctSysModeDr, typeCode, typeName, whileSql, isPhase, isInstall)
	&sql(update ACCT_SysBusiType set ACCT_SysMode_Dr =:acctSysModeDr,type_code =:typeCode,type_name =:typeName,while_sql =:whileSql,is_phase =:isPhase,is_install =:isInstall where %ID=:rowid)
	q SQLCODE
}

/// w ##class(User.uACCTSysBusiType).Delete(10)
ClassMethod Delete(rowid) As %String
{
	n (rowid)
	&SQL(DELETE FROM ACCT_SysBusiType WHERE %ID=:rowid)
	q SQLCODE
}

/// Others: w ##class(User.uACCTSysBusiType).List("","","","","","")
ClassMethod List(searchField, searchValue, sortField, sortDir, start, limit) As %String
{
	n ( searchField, searchValue, sortField, sortDir, start, limit)
	
	s sqlStr="SELECT * FROM ACCT_SysBusiType"
	s whereStr=" WHERE %ID>0 "
	s sortStr=" ORDER BY %ID DESC"
	
	s sqlStr=sqlStr_whereStr_sortStr
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	
	s count=0
	s resultString=""
	
	s json=##class(web.com.JsonObj).%New()
	
	s jsonTitle="rowid^acctSysModeDr^acctSysModeName^typeCode^typeName^whileSql^isPhase^isInstall"
	
	While(result.Next())
	{
		s rowid = result.Data("Type_Rowid")
		s acctSysModeDr = result.Data("ACCT_SysMode_Dr")
		s acctSysModeName=""
		i $g(^User.ACCTSysModeD(acctSysModeDr))'="" d
		.s acctSysModeName = $LIST(^User.ACCTSysModeD(acctSysModeDr),4)
		s typeCode = result.Data("type_code")
		s typeName = result.Data("type_name")
		s whileSql = result.Data("while_sql")
		s isPhase = result.Data("is_phase")
		s isInstall = result.Data("is_install")
		s tmp=rowid_"^"_acctSysModeDr_"^"_acctSysModeName_"^"_typeCode_"^"_typeName_"^"_whileSql_"^"_isPhase_"^"_isInstall
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
<StreamLocation>^User.uACCTSysBusiTypeS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
