Class User.uACCTSubjMap Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// w ##class(User.uACCTSubjMap).Insert(9,9,"a",9,"a")
ClassMethod Insert(acctModDr, acctSubjDr, typeCode, locDr, docType) As %String
{
	n (acctModDr, acctSubjDr, typeCode, locDr, docType)
	&sql(insert into ACCT_SubjMap (Acct_Mod_Dr, Acct_Subj_Dr, type_code, loc_dr, doc_type) values(:acctModDr, :acctSubjDr, :typeCode, :locDr, :docType))
	q SQLCODE
}

/// w ##class(User.uACCTSubjMap).Update(5,8,8,"b",8,"b")
ClassMethod Update(rowid, acctModDr, acctSubjDr, typeCode, locDr, docType) As %String
{
	n (rowid,acctModDr, acctSubjDr, typeCode, locDr, docType)
	&sql(update ACCT_SubjMap set Acct_Mod_Dr =:acctModDr,Acct_Subj_Dr=:acctSubjDr,type_code=:typeCode,loc_dr=:locDr,doc_type=:docType where %ID=:rowid)
	q SQLCODE
}

/// w ##class(User.uACCTSubjMap).Delete(5)
ClassMethod Delete(rowid) As %String
{
	n (rowid)
	&SQL(DELETE FROM ACCT_SubjMap WHERE %ID=:rowid)
	q SQLCODE
}

/// w ##class(User.uACCTSubjMap).List()
ClassMethod List() As %String
{
	//n ( searchField, searchValue, sortField, sortDir, start, limit)
	
	s sqlStr="SELECT * FROM ACCT_SubjMap"
	s whereStr=" WHERE %ID>0 "
	s sortStr=" ORDER BY %ID DESC"
	
	s sqlStr=sqlStr_whereStr_sortStr
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	
	s count=0
	s resultString=""
	
	s json=##class(web.com.JsonObj).%New()
	
	s jsonTitle="rowid^acctModDr^acctModName^acctSubjDr^acctSubjName^locDr^locName^docType^docTypeid"
	
	While(result.Next())
	{
		s rowid = result.Data("ID")
		s acctModDr = result.Data("Acct_Mod_Dr") 
		s acctModName = ""
		i $g(^User.ACCTSysModeD(acctModDr))'="" d
		.s acctModName = $LIST(^User.ACCTSysModeD(acctModDr),4)
		s acctSubjDr = result.Data("Acct_Subj_Dr") 
		s acctSubjName = ""
		i $g(^User.ACCTSubjD(acctSubjDr))'="" d
		.s acctSubjName = $LIST(^User.ACCTSubjD(acctSubjDr),3)
		s typeCode = result.Data("doc_type") 
		s locDr = result.Data("loc_dr") 
		s locName = ""
		i $g(^CTLOC(locDr))'="" d
		.s locName = $p(^CTLOC(locDr),"^",2)
		s docType = result.Data("type_code") 
		;w docType,!
		s docTypeName=""
		i docType'="" d
		.;w "a",docType,!
		.s docTypeName=$p(^INC("SC",docType),"^",2)
		.;w docTypeName,!
		s tmp=rowid_"^"_acctModDr_"^"_acctModName_"^"_acctSubjDr_"^"_acctSubjName_"^"_locDr_"^"_locName_"^"_docTypeName_"^"_docType
		d json.InsertRowData(tmp)
		s count=count+1
	}
	d result.Close()
	s resultString = json.getJsonData(jsonTitle,count)
 	k json
	q resultString
}

/// w ##class(User.uACCTSubjMap).ListINCSC()
ClassMethod ListINCSC() As %String
{
	
	s sqlStr="select incsc_desc,incsc_rowid From inc_stkcat"
	s whereStr=" WHERE %ID>0 "
	s sortStr=" ORDER BY %ID DESC"
	
	s sqlStr=sqlStr_whereStr_sortStr
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	
	s count=0
	s resultString=""
	
	s json=##class(web.com.JsonObj).%New()
	
	s jsonTitle="rowid^desc"
	
	While(result.Next())
	{
		s rowid = result.Data("INCSC_RowId")
		s desc = result.Data("INCSC_Desc") 
		s tmp=rowid_"^"_desc
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
<StreamLocation>^User.uACCTSubjMapS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
