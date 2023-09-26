Class User.uACCTSubjType Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// w ##class(User.uACCTSubjType).Insert("1001","001","","03","资产" )
ClassMethod Insert(compCode, copyCode, note, subjTypeCode, subjTypeName) As %String
{
	n (compCode, copyCode, note, subjTypeCode, subjTypeName)
	&sql(insert into ACCT_SubjType (comp_code,copy_code,note,subj_type_code,subj_type_name) values(:compCode, :copyCode, :note, :subjTypeCode, :subjTypeName))
	q SQLCODE
}

/// w ##class(User.uACCTSubjType).Update(3,"1001","001","","04","资产a" )
ClassMethod Update(rowid, compCode, copyCode, note, subjTypeCode, subjTypeName) As %String
{
	n (rowid,compCode, copyCode, note, subjTypeCode, subjTypeName)
	&sql(update ACCT_SubjType set comp_code=:compCode,copy_code=:copyCode,note=:note,subj_type_code=:subjTypeCode,subj_type_name=:subjTypeName where %ID=:rowid)
	q SQLCODE
}

/// w ##class(User.uACCTSubjType).Delete(3)
ClassMethod Delete(rowid) As %String
{
	n (rowid)
	&SQL(DELETE FROM ACCT_SubjType WHERE %ID=:rowid)
	q SQLCODE
}

/// w ##class(User.uACCTSubjType).List()
ClassMethod List() As %String
{
	s sqlStr="select * from ACCT_SubjType"
	s whereStr=" WHERE %ID>0 "
	s sortStr=" ORDER BY %ID DESC"
	
	s sqlStr=sqlStr_whereStr_sortStr
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	
	s count=0
	s resultString=""
	
	s json=##class(web.com.JsonObj).%New()
	s jsonTitle="rowid^compCode^copyCode^note^subjTypeCode^subjTypeName"
	
	While(result.Next())
	{
		s rowid = result.Data("ID")
		s compCode = result.Data("comp_code")
		s copyCode = result.Data("copy_code")
		s note = result.Data("note")
		s subjTypeCode = result.Data("subj_type_code")
		s subjTypeName = result.Data("subj_type_name")
		s tmp=rowid_"^"_compCode_"^"_copyCode_"^"_note_"^"_subjTypeCode_"^"_subjTypeName
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
<StreamLocation>^User.uACCTSubjTypeS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
