Class User.uACCTVouch Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// w ##class(User.uACCTVouch).Insert(2,3,"4001",1,"4001201007000","40012010070007","2009-09-01","1","demo","","",1,"")
ClassMethod Insert(acctYearPeriod, acctVouchTypeDr, vouchSource, acctBusiTypeDr, vouchNo, vouchNoUse, vouchDate, vouchBillNum, operator, auditor, poster, cVouchId, outSubjCode) As %String
{
	n (acctYearPeriod, acctVouchTypeDr, vouchSource, acctBusiTypeDr, vouchNo,vouchNoUse,vouchDate,vouchBillNum,operator,auditor,poster,cVouchId,outSubjCode)
	s vouchDate=$zdh(vouchDate,3)
	&sql(insert into ACCT_Vouch (ACCT_YearPeriod_Dr,ACCT_VouchType_Dr,vouch_source,ACCT_BusiType_Dr,vouch_no,vouch_no_use,vouch_date,vouch_bill_num,operator,auditor,poster,c_vouch_id,out_subj_code) values(:acctYearPeriod, :acctVouchTypeDr, :vouchSource, :acctBusiTypeDr, :vouchNo,:vouchNoUse,:vouchDate,:vouchBillNum,:operator,:auditor,:poster,:cVouchId,:outSubjCode))
	q SQLCODE
}

/// w ##class(User.uACCTVouch).Update(28,2,3,"4001",1,"4001201007000","40012010070007","2009-09-01","1","demo","","",1,1,1,1,1,"")
ClassMethod Update(rowid, acctYearPeriod, acctVouchTypeDr, vouchSource, acctBusiTypeDr, vouchNo, vouchNoUse, vouchDate, vouchBillNum, operator, auditor, poster, isCheck, isAcc, isCx, isCancel, cVouchId, outSubjCode) As %String
{
	n (rowid,acctYearPeriod, acctVouchTypeDr, vouchSource, acctBusiTypeDr, vouchNo, vouchNoUse, vouchDate, vouchBillNum, operator, auditor, poster, isCheck, isAcc, isCx, isCancel, cVouchId, outSubjCode)
	s vouchDate=$zdh(vouchDate,3)
	&sql(update ACCT_Vouch set ACCT_YearPeriod_Dr=:acctYearPeriod, ACCT_VouchType_Dr=:acctVouchTypeDr, vouch_source=:vouchSource, ACCT_BusiType_Dr=:acctBusiTypeDr, vouch_no=:vouchNo,vouch_no_use=:vouchNoUse,vouch_date=:vouchDate,vouch_bill_num=:vouchBillNum,operator=:operator,auditor=:auditor,poster=:poster,c_vouch_id=:cVouchId,out_subj_code=:outSubjCode,is_check=:isCheck,is_acc=:isAcc,is_cx=:isCx,is_cancel=:isCancel where %ID=:rowid)
	q SQLCODE
}

/// w ##class(User.uACCTVouch).Delete(7)
ClassMethod Delete(rowid) As %String
{
	n (rowid)
	&SQL(DELETE FROM ACCT_Vouch WHERE %ID=:rowid)
	q SQLCODE
}

/// w ##class(User.uACCTVouch).List(yearPeriod)
ClassMethod List(yearPeriod) As %String
{
	n (yearPeriod)
	s sqlStr="select * from ACCT_Vouch"
	s whereStr=" WHERE %ID>0  and ACCT_YearPeriod_Dr= "_yearPeriod
	s sortStr=" ORDER BY %ID DESC"
	
	s sqlStr=sqlStr_whereStr_sortStr
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	
	s count=0
	s resultString=""
	
	s json=##class(web.com.JsonObj).%New()
	s jsonTitle="rowid^acctYearPeriod^acctVouchTypeDr^vouchSource^acctBusiTypeDr^vouchNo^vouchNoUse^vouchDate^vouchBillNum^operator^auditor^poster^isCheck^isAcc^isCx^isCancel^cVouchId^outSubjCode"
	
	While(result.Next())
	{
		s rowid = result.Data("Vouch_Rowid")
		s acctYearPeriod = result.Data("ACCT_YearPeriod_Dr")
		s acctVouchTypeDr = result.Data("ACCT_VouchType_Dr")
		s vouchSource = result.Data("vouch_source")
		s acctBusiTypeDr = result.Data("ACCT_BusiType_Dr")
		s vouchNo = result.Data("vouch_no")
		s vouchNoUse = result.Data("vouch_no_use")
		s vouchDate = result.Data("vouch_date")
		s vouchBillNum = result.Data("vouch_bill_num")
		s operator = result.Data("operator")
		s auditor = result.Data("auditor")
		s poster = result.Data("poster")
		s isCheck = result.Data("is_check")
		s isAcc = result.Data("is_acc")
		s isCx = result.Data("is_cx")
		s isCancel = result.Data("is_cancel")
		s cVouchId = result.Data("c_vouch_id")
		s outSubjCode = result.Data("out_subj_code")
		s tmp=rowid_"^"_acctYearPeriod_"^"_acctVouchTypeDr_"^"_vouchSource_"^"_acctBusiTypeDr_"^"_vouchNo_"^"_vouchNoUse_"^"_vouchDate_"^"_vouchBillNum_"^"_operator_"^"_auditor_"^"_poster_"^"_isCheck_"^"_isAcc_"^"_isCx_"^"_isCancel_"^"_cVouchId_"^"_outSubjCode
		d json.InsertRowData(tmp)
		s count=count+1
	}
	d result.Close()
	s resultString = json.getJsonData(jsonTitle,count)
 	k json
	q resultString
}

/// w ##class(User.uACCTVouch).ListII("1","1")
ClassMethod ListII(yearPeriod, opera) As %String
{
	n (yearPeriod,opera)
	s sqlStr="select * from ACCT_Vouch"
	s whereStr=" WHERE %ID>0 and ACCT_YearPeriod_Dr= "_yearPeriod_" and operator = '"_opera_"'"
	s sortStr=" ORDER BY %ID DESC"
	
	s sqlStr=sqlStr_whereStr_sortStr
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	
	s count=0
	s resultString=""
	
	s json=##class(web.com.JsonObj).%New()
	s jsonTitle="rowid^acctYearPeriod^acctVouchTypeDr^vouchSource^acctBusiTypeDr^acctBusiTypeName^vouchNo^vouchNoUse^vouchDate^vouchBillNum^operator^auditor^poster^isCheck^isAcc^isCx^isCancel^cVouchId^outSubjCode^sheetNo"
	
	While(result.Next())
	{
		s rowid = result.Data("Vouch_Rowid")
		s acctYearPeriod = result.Data("ACCT_YearPeriod_Dr")
		s acctVouchTypeDr = result.Data("ACCT_VouchType_Dr")
		s vouchSource = result.Data("vouch_source")
		s acctBusiTypeDr = result.Data("ACCT_BusiType_Dr")
		s acctBusiTypeName=""
		i acctBusiTypeDr'="" d
		.s acctBusiTypeName= $LIST(^User.ACCTSysBusiTypeD(acctBusiTypeDr),6)
		s vouchNo = result.Data("vouch_no")
		s vouchNoUse = result.Data("vouch_no_use")
		s vouchDate = result.Data("vouch_date")
		i vouchDate'="" d
		.s vouchDate = $zd(vouchDate,3)
		s vouchBillNum = result.Data("vouch_bill_num")
		s operator = result.Data("operator")
		s auditor = result.Data("auditor")
		s poster = result.Data("poster")
		s isCheck = result.Data("is_check")
		s isAcc = result.Data("is_acc")
		s isCx = result.Data("is_cx")
		s isCancel = result.Data("is_cancel")
		s cVouchId = result.Data("c_vouch_id")
		s outSubjCode = result.Data("out_subj_code")
		s sum=""
		f  s sum=$o(^User.ACCTVouchBussI("PKVouchBussno",rowid,sum)) q:sum=""  d
		.s tmp=rowid_"^"_acctYearPeriod_"^"_acctVouchTypeDr_"^"_vouchSource_"^"_acctBusiTypeDr_"^"_acctBusiTypeName_"^"_vouchNo_"^"_vouchNoUse_"^"_vouchDate_"^"_vouchBillNum_"^"_operator_"^"_auditor_"^"_poster_"^"_isCheck_"^"_isAcc_"^"_isCx_"^"_isCancel_"^"_cVouchId_"^"_outSubjCode_"^"_sum
		.d json.InsertRowData(tmp)
		.s count=count+1
	}
	d result.Close()
	s resultString = json.getJsonData(jsonTitle,count)
 	k json
	q resultString
}

/// w ##class(User.uACCTVouch).ListIII("3","","")
ClassMethod ListIII(yearPeriod, noFrom, noTo) As %String
{
	n (yearPeriod, noFrom, noTo)
	s sqlStr="select * from ACCT_Vouch"
	i ((noFrom="")||(noTo="")) d
	.;w "a"
	.s whereStr=" WHERE %ID>0 and ACCT_YearPeriod_Dr= "_yearPeriod
	e  d
	.;w "b"
	.s whereStr=" WHERE %ID>0 and ACCT_YearPeriod_Dr= "_yearPeriod_" and vouch_no <= '"_noTo_"' and vouch_no >= '"_noFrom_"'"
	s sortStr=" ORDER BY %ID DESC"
	
	s sqlStr=sqlStr_whereStr_sortStr
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	
	s count=0
	s resultString=""
	
	s json=##class(web.com.JsonObj).%New()
	s jsonTitle="rowid^acctYearPeriod^acctVouchTypeDr^vouchSource^acctBusiTypeDr^acctBusiTypeName^vouchNo^vouchNoUse^vouchDate^vouchBillNum^operator^auditor^poster^isCheck^isAcc^isCx^isCancel^cVouchId^outSubjCode^sheetNo"
	
	While(result.Next())
	{
		s rowid = result.Data("Vouch_Rowid")
		s acctYearPeriod = result.Data("ACCT_YearPeriod_Dr")
		s acctVouchTypeDr = result.Data("ACCT_VouchType_Dr")
		s vouchSource = result.Data("vouch_source")
		s acctBusiTypeDr = result.Data("ACCT_BusiType_Dr")
		s acctBusiTypeName=""
		i acctBusiTypeDr'="" d
		.s acctBusiTypeName= $LIST(^User.ACCTSysBusiTypeD(acctBusiTypeDr),6)
		s vouchNo = result.Data("vouch_no")
		s vouchNoUse = result.Data("vouch_no_use")
		s vouchDate = result.Data("vouch_date")
		i vouchDate'="" d
		.s vouchDate = $zd(vouchDate,3)
		s vouchBillNum = result.Data("vouch_bill_num")
		s operator = result.Data("operator")
		s auditor = result.Data("auditor")
		s poster = result.Data("poster")
		s isCheck = result.Data("is_check")
		s isAcc = result.Data("is_acc")
		s isCx = result.Data("is_cx")
		s isCancel = result.Data("is_cancel")
		s cVouchId = result.Data("c_vouch_id")
		s outSubjCode = result.Data("out_subj_code")
		s sum=""
		f  s sum=$o(^User.ACCTVouchBussI("PKVouchBussno",rowid,sum)) q:sum=""  d
		.s tmp=rowid_"^"_acctYearPeriod_"^"_acctVouchTypeDr_"^"_vouchSource_"^"_acctBusiTypeDr_"^"_acctBusiTypeName_"^"_vouchNo_"^"_vouchNoUse_"^"_vouchDate_"^"_vouchBillNum_"^"_operator_"^"_auditor_"^"_poster_"^"_isCheck_"^"_isAcc_"^"_isCx_"^"_isCancel_"^"_cVouchId_"^"_outSubjCode_"^"_sum
		.d json.InsertRowData(tmp)
		.s count=count+1
	}
	d result.Close()
	s resultString = json.getJsonData(jsonTitle,count)
 	k json
	q resultString
}

Storage Default
{
<StreamLocation>^User.uACCTVouchS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
