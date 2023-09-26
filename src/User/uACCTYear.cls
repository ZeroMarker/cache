Class User.uACCTYear Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// w ##class(User.uACCTYear).Insert(10011,03102,20110,"2010-08-01","2010-08-01",1,0 ,0,0,'Y',"2010-08-01")
ClassMethod Insert(compCode, copyCode, acctYear, beginDate, endDate, periodNum, accFlag, budgFlag, perfFlag, costFlag, cashDate) As %String
{
	n (compCode, copyCode, acctYear, beginDate, endDate,periodNum,accFlag,budgFlag,perfFlag,costFlag,cashDate)
	
	//to be continual
	
	s beginDate=$zdh(beginDate,3)
	s endDate=$zdh(endDate,3)
	i cashDate'="" d
	.s cashDate=$zdh(cashDate,3)
	&sql(insert into ACCT_Year (comp_code,copy_code,acct_year,begin_date,end_date,period_num,acc_flag,budg_flag,perf_flag,cost_flag,cash_date) values(:compCode, :copyCode, :acctYear, :beginDate, :endDate,:periodNum,:accFlag,:budgFlag,:perfFlag,:costFlag,:cashDate))
	q SQLCODE
}

/// w ##class(User.uACCTYear).Update(3,"1002","002","2010","2010-08-01","2010-08-01",1,0 ,0,0,"Y","2010-08-01")
ClassMethod Update(rowid, compCode, copyCode, acctYear, beginDate, endDate, periodNum, accFlag, budgFlag, perfFlag, costFlag, cashDate) As %String
{
	n (rowid,compCode, copyCode, acctYear, beginDate, endDate,periodNum,accFlag,budgFlag,perfFlag,costFlag,cashDate)
		
	//to be continual
	
	s beginDate=$zdh(beginDate,3)
	s endDate=$zdh(endDate,3)
	i cashDate'="" d
	.s cashDate=$zdh(cashDate,3)
	&sql(update ACCT_Year set comp_code=:compCode,copy_code=:copyCode,acct_year=:acctYear,begin_date=:beginDate,end_date=:endDate,period_num=:periodNum,acc_flag=:accFlag,budg_flag=:budgFlag,perf_flag=:perfFlag,cost_flag=:costFlag,cash_date=:cashDate where %ID=:rowid)
	q SQLCODE
}

/// w ##class(User.uACCTYear).Delete(2)
ClassMethod Delete(rowid) As %String
{
	n (rowid)
	&SQL(DELETE FROM ACCT_Year WHERE %ID=:rowid)
	q SQLCODE
}

/// w ##class(User.uACCTYear).List()
ClassMethod List() As %String
{
	s sqlStr="select * from ACCT_Year"
	s whereStr=" WHERE %ID>0 "
	s sortStr=" ORDER BY %ID DESC"
	
	s sqlStr=sqlStr_whereStr_sortStr
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	
	s count=0
	s resultString=""
	
	s json=##class(web.com.JsonObj).%New()
	s jsonTitle="rowid^compCode^copyCode^acctYear^beginDate^endDate^periodNum^accFlag^budgFlag^perfFlag^costFlag^cashDate"
	
	While(result.Next())
	{
		s rowid = result.Data("ID")
		s compCode = result.Data("comp_code")
		s copyCode = result.Data("copy_code")
		s acctYear = result.Data("acct_year")
		s beginDate = result.Data("begin_date")
		s beginDate = $zd(beginDate,3)
		s endDate = result.Data("end_date")
		s endDate = $zd(endDate,3)
		s periodNum = result.Data("period_num")
		s accFlag = result.Data("acc_flag")
		s budgFlag = result.Data("budg_flag")
		s perfFlag = result.Data("perf_flag")
		s costFlag = result.Data("cost_flag")
		s cashDate = result.Data("cash_date")
		i cashDate'="" d
		.s cashDate = $zd(cashDate,3)
		s tmp=rowid_"^"_compCode_"^"_copyCode_"^"_acctYear_"^"_beginDate_"^"_endDate_"^"_periodNum_"^"_accFlag_"^"_budgFlag_"^"_perfFlag_"^"_costFlag_"^"_cashDate
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
<StreamLocation>^User.uACCTYearS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
