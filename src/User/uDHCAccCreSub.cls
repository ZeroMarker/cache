Class User.uDHCAccCreSub Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// w ##class(User.uDHCAccCreSub).Insert(1,"","","","","" ,"","","","","" ,"","","","","","","" )
ClassMethod Insert(creSubParRef, creSubDesc, creSubDataSource, creSubPatType, creSubAccItem, creSubadmreason, creSubpaymode, creSubcat, creSubLoc, creSubFlag1, creSubFlag2, creSubFlag3, creSubFlag4, creSubFlag5, creSubPrePrtFlag, creSubIncluAbort, creSubDFContains, creSubJFContains) As %String
{
	n (creSubParRef, creSubDesc, creSubDataSource, creSubPatType, creSubAccItem, creSubadmreason, creSubpaymode, creSubcat, creSubLoc, creSubFlag1, creSubFlag2, creSubFlag3, creSubFlag4, creSubFlag5, creSubPrePrtFlag, creSubIncluAbort, creSubDFContains, creSubJFContains)

	&sql(insert into DHC_AccCreSub (CreSub_ParRef, CreSub_Desc, CreSub_DataSource, CreSub_PatType, CreSub_AccItem, CreSub_admreason, CreSub_paymode, CreSub_cat, CreSub_Loc, CreSub_Flag1, CreSub_Flag2, CreSub_Flag3, CreSub_Flag4, CreSub_Flag5, CreSub_PrePrtFlag, CreSub_IncluAbort, CreSub_DFContains, CreSub_JFContains ) values(:creSubParRef, :creSubDesc, :creSubDataSource, :creSubPatType, :creSubAccItem, :creSubadmreason, :creSubpaymode, :creSubcat, :creSubLoc, :creSubFlag1, :creSubFlag2, :creSubFlag3, :creSubFlag4, :creSubFlag5, :creSubPrePrtFlag, :creSubIncluAbort, :creSubDFContains, :creSubJFContains))
	q SQLCODE
}

/// w ##class(User.uDHCAccCreSub).Update("1||6","aa","","","","" ,"","","","","" ,"","","","","","","")
ClassMethod Update(rowid, creSubDesc, creSubDataSource, creSubPatType, creSubAccItem, creSubadmreason, creSubpaymode, creSubcat, creSubLoc, creSubFlag1, creSubFlag2, creSubFlag3, creSubFlag4, creSubFlag5, creSubPrePrtFlag, creSubIncluAbort, creSubDFContains, creSubJFContains) As %String
{
	n (rowid, creSubDesc, creSubDataSource, creSubPatType, creSubAccItem, creSubadmreason, creSubpaymode, creSubcat, creSubLoc, creSubFlag1, creSubFlag2, creSubFlag3, creSubFlag4, creSubFlag5, creSubPrePrtFlag, creSubIncluAbort, creSubDFContains, creSubJFContains)

	&sql(update DHC_AccCreSub set CreSub_Desc=:creSubDesc,CreSub_DataSource=:creSubDataSource,CreSub_PatType=:creSubPatType,CreSub_AccItem=:creSubAccItem,CreSub_admreason=:creSubadmreason,CreSub_paymode=:creSubpaymode,CreSub_cat=:creSubcat,CreSub_Loc=:creSubLoc,CreSub_Flag1=:creSubFlag1,CreSub_Flag2=:creSubFlag2,CreSub_Flag3=:creSubFlag3,CreSub_Flag4=:creSubFlag4,CreSub_Flag5=:creSubFlag5,CreSub_PrePrtFlag=:creSubPrePrtFlag,CreSub_IncluAbort=:creSubIncluAbort,CreSub_DFContains=:creSubDFContains,CreSub_JFContains=:creSubJFContains where %ID=:rowid)
	q SQLCODE
}

/// w ##class(User.uDHCAccCreSub).Delete("1||6")
ClassMethod Delete(rowid) As %String
{
	n (rowid)
	&SQL(DELETE FROM DHC_AccCreSub WHERE %ID=:rowid)
	q SQLCODE
}

/// w ##class(User.uDHCAccCreSub).List(1)
ClassMethod List(creSubParRef) As %String
{
	n (creSubParRef)
	s sqlStr="select * from DHC_AccCreSub"
	s whereStr=" WHERE CreSub_Sub>0 and CreSub_ParRef = "_creSubParRef
	s sortStr=" ORDER BY CreSub_Rowid DESC"
	
	s sqlStr=sqlStr_whereStr_sortStr
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	
	s count=0
	s resultString=""
	
	s json=##class(web.com.JsonObj).%New()
	s jsonTitle="rowid^creSubParRef^creSubDesc^creSubDataSource^creSubPatType^creSubAccItem^creSubadmreason^creSubpaymode^creSubcat^creSubLoc^creSubFlag1^creSubFlag2^creSubFlag3^creSubFlag4^creSubFlag5^creSubPrePrtFlag^creSubIncluAbort^creSubDFContains^creSubJFContains"
	
	While(result.Next())
	{
		// CreSub_ParRef, CreSub_Desc, CreSub_DataSource, CreSub_PatType, CreSub_AccItem, CreSub_admreason,
		// CreSub_paymode, CreSub_cat, CreSub_Loc, CreSub_Flag1, CreSub_Flag2, CreSub_Flag3, CreSub_Flag4,
		// CreSub_Flag5, CreSub_PrePrtFlag, CreSub_IncluAbort, CreSub_DFContains, CreSub_JFContains 
		
		// rowid^creSubParRef^creSubDesc^creSubDataSource^creSubPatType^creSubAccItem^creSubadmreason^
		// creSubpaymode^creSubcat^creSubLoc^creSubFlag1^creSubFlag2^creSubFlag3^creSubFlag4^creSubFlag5^
		// creSubPrePrtFlag^creSubIncluAbort^creSubDFContains^creSubJFContains
		
		s rowid = result.Data("CreSub_Rowid")
		s creSubParRef = result.Data("CreSub_ParRef")
		s creSubDesc = result.Data("CreSub_Desc")
		s creSubDataSource = result.Data("CreSub_DataSource")
		s creSubPatType = result.Data("CreSub_PatType")
		s creSubAccItem = result.Data("CreSub_AccItem")
		s creSubadmreason = result.Data("CreSub_admreason")
		s creSubpaymode = result.Data("CreSub_paymode")
		s creSubcat = result.Data("CreSub_cat")
		s creSubLoc = result.Data("CreSub_Loc")
		s creSubFlag1 = result.Data("CreSub_Flag1")
		s creSubFlag2 = result.Data("CreSub_Flag2")
		s creSubFlag3 = result.Data("CreSub_Flag3")
		s creSubFlag4 = result.Data("CreSub_Flag4")
		s creSubFlag5 = result.Data("CreSub_Flag5")
		s creSubPrePrtFlag = result.Data("CreSub_PrePrtFlag")
		s creSubIncluAbort = result.Data("CreSub_IncluAbort")
		s creSubDFContains = result.Data("CreSub_DFContains")
		s creSubJFContains = result.Data("CreSub_JFContains")
		//rowid^creSubParRef^creSubDesc^creSubDataSource^creSubPatType^creSubAccItem^creSubadmreason^creSubpaymode^creSubcat^creSubLoc^creSubFlag1^creSubFlag2^creSubFlag3^creSubFlag4^creSubFlag5^creSubPrePrtFlag^creSubIncluAbort^creSubDFContains^creSubJFContains
		s tmp=rowid_"^"_creSubParRef_"^"_creSubDesc_"^"_creSubDataSource_"^"_creSubPatType_"^"_creSubAccItem_"^"_creSubadmreason_"^"_creSubpaymode_"^"_creSubcat_"^"_creSubLoc_"^"_creSubFlag1_"^"_creSubFlag2_"^"_creSubFlag3_"^"_creSubFlag4_"^"_creSubFlag5_"^"_creSubPrePrtFlag_"^"_creSubIncluAbort_"^"_creSubDFContains_"^"_creSubJFContains
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
<StreamLocation>^User.uDHCAccCreSubS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
