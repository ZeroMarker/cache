Class User.uAutoHis Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// w ##class(User.uAutoHis).List("125")
ClassMethod List(VouchNo) As %String
{
	n (VouchNo)
	
	;s VouchNo=$c(32)_VouchNo //傻瓜一样的数据库
	;s tmpVouchDr = ""
	;s tmpVouchDr = $o(^User.ACCTVouchI("IndexACCTVouchNo",VouchNo,tmpVouchDr))
	
	s sqlStr="select * from ACCT_VouchDetail"
	s whereStr=" WHERE %ID>0 and ACCT_VouchParref ="_VouchNo
	s sortStr=" ORDER BY %ID DESC"
	
	s sqlStr=sqlStr_whereStr_sortStr
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	
	s count=0
	s amtAll=0
	s resultString=""
	
	s json=##class(web.com.JsonObj).%New()
	s jsonTitle="rowid^summary^subjDr^subjName^amtCredit^amtDebit"
	
	While(result.Next())
	{
		s rowid = result.Data("Detail_Rowid")
		s summary = result.Data("summary")
		s subjDr = result.Data("ACCT_Subj_Dr")
		s subjName = ""
		i subjDr '= "" d
		.s subjName = $LIST(^User.ACCTSubjD(subjDr),2)
		s amtCredit = result.Data("amt_credit")
		s amtDebit = result.Data("amt_debit")
		s amtAll = amtAll + amtCredit
		s tmp=rowid_"^"_summary_"^"_subjDr_"^"_subjName_"^"_amtCredit_"^"_amtDebit
		d json.InsertRowData(tmp)
		s count=count+1
	}
	d json.InsertRowData("-1^合计^^^"_amtAll_"^"_amtAll)
	d result.Close()
	s resultString = json.getJsonData(jsonTitle,count)
 	k json
	q resultString
}

/// Others: w ##class(web.uAutoHis).Update(2,7)
ClassMethod Update(rowid, subjDr) As %String
{
	n (rowid, subjDr)
	s $list(^User.ACCTVouchDetailD(rowid),2)=subjDr
	q $$$OK
}

Storage Default
{
<StreamLocation>^User.uAutoHisS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
