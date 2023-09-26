Class User.uACCTYearPeriod Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// w ##class(User.uACCTYearPeriod).Insert(1,"04","2010-08-01","2010-08-01",1,0 ,0,0,0,0,0,0,0,"Y","","2010-08-01",0)
ClassMethod Insert(acctYearDr, acctMonth, beginDate, endDate, cashFlag, fixFlag, matFlag, medFlag, drugStoreFlag, wageFlag, accFlag, budgFlag, perfFlag, costFlag, matCheckDate, fixCheckDate, isDepreciation) As %String
{
	n (acctYearDr, acctMonth, beginDate, endDate, cashFlag, fixFlag, matFlag, medFlag, drugStoreFlag, wageFlag,accFlag,budgFlag,perfFlag,costFlag,matCheckDate,fixCheckDate,isDepreciation)
		
	//to be continual
	
	s beginDate=$zdh(beginDate,3)
	s endDate=$zdh(endDate,3)
	i matCheckDate'="" d
	.s matCheckDate=$zdh(matCheckDate,3)
	i fixCheckDate'="" d
	.s fixCheckDate=$zdh(fixCheckDate,3)
	
	&sql(insert into ACCT_YearPeriod (ACCT_Year_Dr,acct_month,begin_date,end_date,cash_flag,fix_flag,mat_flag,med_flag,drugstore_flag,wage_flag,acc_flag,budg_flag,perf_flag,cost_flag,mat_check_date,fix_check_date,is_depreciation) values(:acctYearDr, :acctMonth, :beginDate, :endDate, :cashFlag, :fixFlag, :matFlag, :medFlag, :drugStoreFlag, :wageFlag, :accFlag, :budgFlag, :perfFlag, :costFlag, :matCheckDate, :fixCheckDate, :isDepreciation))
	q SQLCODE
}

/// w ##class(User.uACCTYearPeriod).Update(3,1,"04","2010-08-08","2010-08-08",1,1 ,1,1,1,1,1,1,1,"N","2010-08-01","",0)
ClassMethod Update(rowid, acctYearDr, acctMonth, beginDate, endDate, cashFlag, fixFlag, matFlag, medFlag, drugStoreFlag, wageFlag, accFlag, budgFlag, perfFlag, costFlag, matCheckDate, fixCheckDate, isDepreciation) As %String
{
	n (rowid, acctYearDr, acctMonth, beginDate, endDate, cashFlag, fixFlag, matFlag, medFlag, drugStoreFlag, wageFlag,accFlag,budgFlag,perfFlag,costFlag,matCheckDate,fixCheckDate,isDepreciation)
		
	//to be continual
	
	s beginDate=$zdh(beginDate,3)
	s endDate=$zdh(endDate,3)
	i matCheckDate'="" d
	.s matCheckDate=$zdh(matCheckDate,3)
	i fixCheckDate'="" d
	.s fixCheckDate=$zdh(fixCheckDate,3)
	
	&sql(update ACCT_YearPeriod set ACCT_Year_Dr =:acctYearDr,acct_month =:acctMonth,begin_date =:beginDate,end_date =:endDate,cash_flag =:cashFlag,fix_flag =:fixFlag,mat_flag =:matFlag,med_flag =:medFlag,drugstore_flag =:drugStoreFlag,wage_flag =:wageFlag,acc_flag =:accFlag,budg_flag =:budgFlag,perf_flag =:perfFlag,cost_flag =:costFlag,mat_check_date =:matCheckDate,fix_check_date =:fixCheckDate,is_depreciation =:isDepreciation where %ID=:rowid)
	q SQLCODE
}

/// w ##class(User.uACCTYearPeriod).Delete(4)
ClassMethod Delete(rowid) As %String
{
	n (rowid)
	&SQL(DELETE FROM ACCT_YearPeriod WHERE %ID=:rowid)
	q SQLCODE
}

//to be ...

/// Others: w ##class(User.uACCTYearPeriod).List()
ClassMethod List() As %String
{
	n ( searchField, searchValue, sortField, sortDir, start, limit)
	
	s sqlStr="SELECT * FROM ACCT_YearPeriod"
	s whereStr=" WHERE %ID>0 "
	s sortStr=" ORDER BY %ID DESC"
	
	s sqlStr=sqlStr_whereStr_sortStr
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	
	s count=0
	s resultString=""
	
	s json=##class(web.com.JsonObj).%New()
	
	s jsonTitle="rowid^acctYearDr^acctYearName^acctMonth^render^beginDate^endDate^cashFlag^fixFlag^matFlag^medFlag^drugStoreFlag^wageFlag^accFlag^budgFlag^perfFlag^costFlag^matCheckDate^fixCheckDate^isDepreciation"
	
	While(result.Next())
	{
		s rowid = result.Data("ID")
		s acctYearDr =result.Data("ACCT_Year_Dr")
		s acctYearName=""
		i (acctYearDr'="")&&($g(^User.ACCTYearD(acctYearDr))'="") d
		.s acctYearName = $LIST(^User.ACCTYearD(acctYearDr),13)
		s acctMonth =result.Data("acct_month")
		s beginDate=result.Data("begin_date")
		s beginDate=$zd(beginDate,3)
		s endDate=result.Data("end_date")
		s endDate=$zd(endDate,3)
		s cashFlag=result.Data("cash_flag")
		s fixFlag=result.Data("fix_flag")
		s matFlag=result.Data("mat_flag")
		s medFlag=result.Data("med_flag")
		s drugStoreFlag=result.Data("drugstore_flag")
		s wageFlag=result.Data("wage_flag")
		s accFlag=result.Data("acc_flag")
		s budgFlag=result.Data("budg_flag")
		s perfFlag=result.Data("perf_flag")
		s costFlag=result.Data("cost_flag")
		s matCheckDate=result.Data("mat_check_date")
		i matCheckDate'="" d
		.s matCheckDate=$zd(matCheckDate,3)
		s fixCheckDate=result.Data("fix_check_date")
		i fixCheckDate'="" d
		.s fixCheckDate=$zd(fixCheckDate,3)
		s isDepreciation=result.Data("is_depreciation")
		s tmp=rowid_"^"_ acctYearDr_"^"_ acctYearName _"^"_ acctMonth_"^"_acctYearName_"-"_acctMonth_"^"_beginDate_"^"_ endDate_"^"_ cashFlag_"^"_ fixFlag_"^"_ matFlag_"^"_ medFlag_"^"_ drugStoreFlag_"^"_ wageFlag_"^"_accFlag_"^"_budgFlag_"^"_perfFlag_"^"_costFlag_"^"_matCheckDate_"^"_fixCheckDate_"^"_isDepreciation
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
<StreamLocation>^User.uACCTYearPeriodS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
