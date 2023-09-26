Class web.DHCOPBillActManageJson Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// w ##class(web.DHCOPBillActManageJson).GetOPReportCatDetailByDateH("2010-08-26","2010-08-27")
ClassMethod GetOPReportCatDetailByDateH(stDate, endDate, CredNo) As %String
{
 n (stDate, endDate,CredNo)
 s stDate=$zdh(stDate,3)
 s endDate=$zdh(endDate,3)
 s tmpData=##class(web.DHCOPBillActManage).GetOPReportCatDetailByDate(stDate,endDate,CredNo)
 s tmpHead=$p(tmpData,$c(2),1)
 s json=##class(web.com.JsonObj).%New()
 s jsonTitle="rowid^name^title"
 s tmpNum=1
 f  s tmpPiece=$p(tmpHead,"^",tmpNum) q:tmpPiece=""  d
 .s tmpJson=tmpNum_"^"_tmpPiece_"^"_tmpPiece
 .d json.InsertRowData(tmpJson)
 .s tmpNum=tmpNum+1
 //d json.InsertRowData(tmpNum+1_"^临时凭证号^临时凭证号")
 //d json.InsertRowData(tmpNum+2_"^凭证编号^凭证编号")
 s resultString = json.getJsonData(jsonTitle,tmpNum-1)
 k json
 q resultString
}

/// w ##class(web.DHCOPBillActManageJson).GetOPReportCatDetailByDateJ("2009-09-01","2009-09-10")
ClassMethod GetOPReportCatDetailByDateJ(stDate, endDate, CredNo) As %String
{
 n (stDate, endDate,CredNo)
 s stDate=$zdh(stDate,3)
 s endDate=$zdh(endDate,3)
 s tmpData=##class(web.DHCOPBillActManage).GetOPReportCatDetailByDate(stDate,endDate,CredNo)
 s jsonTitle="rowid^"_$p(tmpData,$c(2),1)
 s json=##class(web.com.JsonObj).%New()
 s tmpNum=2
 f  s tmpPiece=$p(tmpData,$c(2),tmpNum) q:tmpPiece=""  d
 .d json.InsertRowData(tmpNum-1_"^"_tmpPiece)
 .s tmpNum=tmpNum+1 
 s resultString = json.getJsonData(jsonTitle,tmpNum-2)
 k json
 q resultString
}

/// w ##class(web.DHCOPBillActManageJson).OPReportCatDetailByUserH("2009-09-01")
ClassMethod OPReportCatDetailByUserH(date) As %String
{
 n (date)
 s date=$zdh(date,3)
 s tmpData=##class(web.DHCOPBillActManage).OPReportCatDetailByUser(date)
 s tmpHead=$p(tmpData,$c(2),1)
 s json=##class(web.com.JsonObj).%New()
 s jsonTitle="rowid^name^title"
 s tmpNum=1
 f  s tmpPiece=$p(tmpHead,"^",tmpNum) q:tmpPiece=""  d
 .s tmpJson=tmpNum_"^"_tmpPiece_"^"_tmpPiece
 .d json.InsertRowData(tmpJson)
 .s tmpNum=tmpNum+1
 s resultString = json.getJsonData(jsonTitle,tmpNum-1)
 k json
 q resultString
}

/// w ##class(web.DHCOPBillActManageJson).OPReportCatDetailByUserJ("2009-09-01")
ClassMethod OPReportCatDetailByUserJ(date) As %String
{
 n (date)
 s date=$zdh(date,3)
 s tmpData=##class(web.DHCOPBillActManage).OPReportCatDetailByUser(date)
 s jsonTitle="rowid^"_$p(tmpData,$c(2),1)
 s json=##class(web.com.JsonObj).%New()
 s tmpNum=2
 f  s tmpPiece=$p(tmpData,$c(2),tmpNum) q:tmpPiece=""  d
 .d json.InsertRowData(tmpNum-1_"^"_tmpPiece)
 .s tmpNum=tmpNum+1 
 s resultString = json.getJsonData(jsonTitle,tmpNum-2)
 k json
 q resultString
}

/// w ##class(web.DHCOPBillActManageJson).OPReportCatDetailByLocH("2010-08-26","2010-08-27")
ClassMethod OPReportCatDetailByLocH(stDate, endDate) As %String
{
 n (stDate, endDate)
 s stDate=$zdh(stDate,3)
 s endDate=$zdh(endDate,3)
 s tmpData=##class(web.DHCOPBillActManage).OPReportCatDetailByLoc(stDate,endDate)
 s tmpHead=$p(tmpData,$c(2),1)
 s json=##class(web.com.JsonObj).%New()
 s jsonTitle="rowid^name^title"
 s tmpNum=1
 f  s tmpPiece=$p(tmpHead,"^",tmpNum) q:tmpPiece=""  d
 .s tmpJson=tmpNum_"^"_tmpPiece_"^"_tmpPiece
 .d json.InsertRowData(tmpJson)
 .s tmpNum=tmpNum+1
 s resultString = json.getJsonData(jsonTitle,tmpNum-1)
 k json
 q resultString
}

/// w ##class(web.DHCOPBillActManageJson).OPReportCatDetailByLocJ("2010-08-26","2010-08-27")
ClassMethod OPReportCatDetailByLocJ(stDate, endDate) As %String
{
 n (stDate, endDate)
 s stDate=$zdh(stDate,3)
 s endDate=$zdh(endDate,3)
 s tmpData=##class(web.DHCOPBillActManage).OPReportCatDetailByLoc(stDate,endDate)
 s jsonTitle="rowid^"_$p(tmpData,$c(2),1)
 s json=##class(web.com.JsonObj).%New()
 s tmpNum=2
 f  s tmpPiece=$p(tmpData,$c(2),tmpNum) q:tmpPiece=""  d
 .d json.InsertRowData(tmpNum-1_"^"_tmpPiece)
 .s tmpNum=tmpNum+1 
 s resultString = json.getJsonData(jsonTitle,tmpNum-2)
 k json
 q resultString
}

/// w ##class(web.DHCOPBillActManageJson).OPIncomeH("2008-11-01","2008-11-27")
ClassMethod OPIncomeH(stDate, endDate, CredNo) As %String
{
 n (stDate, endDate,CredNo)
 s stDate=$zdh(stDate,3)
 s endDate=$zdh(endDate,3)
 s tmpData=##class(web.DHCOPBillActManage).OPIncomeByDate(stDate,endDate,CredNo)
 s tmpHead=$p(tmpData,$c(2),1)
 s json=##class(web.com.JsonObj).%New()
 s jsonTitle="rowid^name^title"
 s tmpNum=1
 f  s tmpPiece=$p(tmpHead,"^",tmpNum) q:tmpPiece=""  d
 .s tmpJson=tmpNum_"^"_tmpPiece_"^"_tmpPiece
 .d json.InsertRowData(tmpJson)
 .s tmpNum=tmpNum+1
 s resultString = json.getJsonData(jsonTitle,tmpNum-1)
 k json
 q resultString
}

/// w ##class(web.DHCOPBillActManageJson).OPIncomeJ("2010-08-26","2010-08-27")
ClassMethod OPIncomeJ(stDate, endDate, CredNo) As %String
{
 n (stDate, endDate,CredNo)
 s stDate=$zdh(stDate,3)
 s endDate=$zdh(endDate,3)
 s tmpData=##class(web.DHCOPBillActManage).OPIncomeByDate(stDate,endDate,CredNo)
 s jsonTitle="rowid^"_$p(tmpData,$c(2),1)
 s json=##class(web.com.JsonObj).%New()
 s tmpNum=2
 f  s tmpPiece=$p(tmpData,$c(2),tmpNum) q:tmpPiece=""  d
 .d json.InsertRowData(tmpNum-1_"^"_tmpPiece)
 .s tmpNum=tmpNum+1 
 .;OPIncomeByAdmreason
 .s tmpAdDate=$p(tmpPiece,"^",1)
 .i tmpAdDate'="合计" d
 ..s tmpAdDate=$zdh(tmpAdDate,3)
 ..s tmpAdData=##class(web.DHCOPBillActManage).OPIncomeByAdmreason(tmpAdDate)
 ..s tmpAdNum=1
 ..f  s tmpAdPiece=$p(tmpAdData,"^",tmpAdNum) q:tmpAdPiece=""  d
 ...s tmpAdNum=tmpAdNum+1 
 ...;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 s resultString = json.getJsonData(jsonTitle,tmpNum-2)
 k json
 q resultString
}

/// w ##class(web.DHCOPBillActManageJson).OPIncomeByAdmreasonH("2010-08-27")
ClassMethod OPIncomeByAdmreasonH(date, CredNo) As %String
{
 n (date,CredNo)
 s date=$zdh(date,3)
 s tmpData=##class(web.DHCOPBillActManage).OPIncomeByAdmreason(date)
 s tmpHead=$p(tmpData,$c(2),1)
 s tmpNum=1
 f  s tmpPiece=$p(tmpHead,"^",tmpNum) q:tmpPiece=""  d
 .s tmpNum=tmpNum+1

 s tmpData=##class(web.DHCOPBillActManage).OPIncomeByDate(date,date,CredNo)
 s tmpHead=$p(tmpData,$c(2),1)
 s json=##class(web.com.JsonObj).%New()
 s jsonTitle="rowid^name^title"
 s tmpN=1
 f  s tmpPiece=$p(tmpHead,"^",tmpN+1) q:tmpN=tmpNum  d
 .s tmpJson=tmpN_"^"_tmpPiece_"^"_tmpPiece
 .d json.InsertRowData(tmpJson)
 .s tmpN=tmpN+1
 s resultString = json.getJsonData(jsonTitle,tmpN-1)
 k json
 q resultString
}

/// w ##class(web.DHCOPBillActManageJson).OPIncomeByAdmreasonJ("2010-08-27")
ClassMethod OPIncomeByAdmreasonJ(date, CredNo) As %String
{
 n (date,CredNo)
 s date=$zdh(date,3)
 
 s tmpData=##class(web.DHCOPBillActManage).OPIncomeByAdmreason(date)
 s tmpHead=$p(tmpData,$c(2),1)
 s tmpNum=1
 f  s tmpPiece=$p(tmpHead,"^",tmpNum) q:tmpPiece=""  d
 .s tmpNum=tmpNum+1
 s tmpData=##class(web.DHCOPBillActManage).OPIncomeByDate(date,date,CredNo)
 s tmpHead=$p(tmpData,$c(2),1)
 s jsonTitle=""
 s tmpN=1
 f  s tmpPiece=$p(tmpHead,"^",tmpN+1) q:tmpN=tmpNum  d
 .s tmpN=tmpN+1
 .i jsonTitle="" d
 ..s jsonTitle=tmpPiece
 .e  d
 ..s jsonTitle=jsonTitle_"^"_tmpPiece

 s tmpData=##class(web.DHCOPBillActManage).OPIncomeByAdmreason(date)
 //s jsonTitle="rowid^"_$p(tmpData,$c(2),1)
 s json=##class(web.com.JsonObj).%New()
 s tmpNum=1
 f  s tmpPiece=$p(tmpData,$c(2),tmpNum) q:tmpPiece=""  d
 .d json.InsertRowData(tmpPiece)
 .s tmpNum=tmpNum+1 
 s resultString = json.getJsonData(jsonTitle,tmpNum-1)
 k json
 q resultString
}

/// w ##class(web.DHCOPBillActManageJson).IPReportCatDetailByDateH("2008-07-14","2010-04-08")
ClassMethod IPReportCatDetailByDateH(stDate, endDate, CredNo) As %String
{
 n (stDate, endDate,CredNo)
 s stDate=$zdh(stDate,3)
 s endDate=$zdh(endDate,3)
 s tmpData=##class(web.DHCOPBillActManage).IPReportCatDetailByDate(stDate,endDate,CredNo)
 s tmpHead=$p(tmpData,$c(2),1)
 s json=##class(web.com.JsonObj).%New()
 s jsonTitle="rowid^name^title"
 s tmpNum=1
 f  s tmpPiece=$p(tmpHead,"^",tmpNum) q:tmpPiece=""  d
 .s tmpJson=tmpNum_"^"_tmpPiece_"^"_tmpPiece
 .d json.InsertRowData(tmpJson)
 .s tmpNum=tmpNum+1
 //d json.InsertRowData(tmpNum+1_"^临时凭证号^临时凭证号")
 //d json.InsertRowData(tmpNum+2_"^凭证编号^凭证编号")
 s resultString = json.getJsonData(jsonTitle,tmpNum-1)
 k json
 q resultString
}

/// w ##class(web.DHCOPBillActManageJson).IPReportCatDetailByDateJ("2008-07-14","2010-04-08")
ClassMethod IPReportCatDetailByDateJ(stDate, endDate, CredNo) As %String
{
 n (stDate, endDate,CredNo)
 s stDate=$zdh(stDate,3)
 s endDate=$zdh(endDate,3)
 s tmpData=##class(web.DHCOPBillActManage).IPReportCatDetailByDate(stDate,endDate,CredNo)
 s jsonTitle="rowid^"_$p(tmpData,$c(2),1)
 s json=##class(web.com.JsonObj).%New()
 s tmpNum=2
 f  s tmpPiece=$p(tmpData,$c(2),tmpNum) q:tmpPiece=""  d
 .s tmpD = $p(tmpPiece,"^",1)
 .i tmpD'="合计" d
 ..s tmpD=$zdh(tmpD,4)
 ..;w tmpD,!
 .d json.InsertRowData(tmpNum-1_"^"_tmpPiece)
 .s tmpNum=tmpNum+1 
 s resultString = json.getJsonData(jsonTitle,tmpNum-2)
 k json
 q resultString
}

/// w ##class(web.DHCOPBillActManageJson).IPReportCatDetailByUserH("2010-04-02")
ClassMethod IPReportCatDetailByUserH(date) As %String
{
  n (date)
  s date=$zdh(date,3)
 s tmpData=##class(web.DHCOPBillActManage).IPReportCatDetailByUser(date)
 s tmpHead=$p(tmpData,$c(2),1)
 s json=##class(web.com.JsonObj).%New()
 s jsonTitle="rowid^name^title"
 s tmpNum=1
 f  s tmpPiece=$p(tmpHead,"^",tmpNum) q:tmpPiece=""  d
 .s tmpJson=tmpNum_"^"_tmpPiece_"^"_tmpPiece
 .d json.InsertRowData(tmpJson)
 .s tmpNum=tmpNum+1
 s resultString = json.getJsonData(jsonTitle,tmpNum-1)
 k json
 q resultString
}

/// w ##class(web.DHCOPBillActManageJson).IPReportCatDetailByUserJ("2010-04-02")
ClassMethod IPReportCatDetailByUserJ(date) As %String
{
  n (date)
  s date=$zdh(date,3)
 s tmpData=##class(web.DHCOPBillActManage).IPReportCatDetailByUser(date)
 s jsonTitle="rowid^"_$p(tmpData,$c(2),1)
 s json=##class(web.com.JsonObj).%New()
 s tmpNum=2
 f  s tmpPiece=$p(tmpData,$c(2),tmpNum) q:tmpPiece=""  d
 .d json.InsertRowData(tmpNum-1_"^"_tmpPiece)
 .s tmpNum=tmpNum+1 
 s resultString = json.getJsonData(jsonTitle,tmpNum-2)
 k json
 q resultString
}

/// w ##class(web.DHCOPBillActManageJson).IPReportCatDetailByLocH("2008-07-14","2010-04-08")
ClassMethod IPReportCatDetailByLocH(stDate, endDate) As %String
{
 n (stDate, endDate)
 s stDate=$zdh(stDate,3)
 s endDate=$zdh(endDate,3)
 s tmpData=##class(web.DHCOPBillActManage).IPReportCatDetailByLoc(stDate,endDate)
 s tmpHead=$p(tmpData,$c(2),1)
 s json=##class(web.com.JsonObj).%New()
 s jsonTitle="rowid^name^title"
 s tmpNum=1
 f  s tmpPiece=$p(tmpHead,"^",tmpNum) q:tmpPiece=""  d
 .s tmpJson=tmpNum_"^"_tmpPiece_"^"_tmpPiece
 .d json.InsertRowData(tmpJson)
 .s tmpNum=tmpNum+1
 s resultString = json.getJsonData(jsonTitle,tmpNum-1)
 k json
 q resultString
}

/// w ##class(web.DHCOPBillActManageJson).IPReportCatDetailByLocJ("2008-07-14","2010-04-08")
ClassMethod IPReportCatDetailByLocJ(stDate, endDate) As %String
{
 n (stDate, endDate)
 s stDate=$zdh(stDate,3)
 s endDate=$zdh(endDate,3)
 s tmpData=##class(web.DHCOPBillActManage).IPReportCatDetailByLoc(stDate,endDate)
 s jsonTitle="rowid^"_$p(tmpData,$c(2),1)
 s json=##class(web.com.JsonObj).%New()
 s tmpNum=2
 f  s tmpPiece=$p(tmpData,$c(2),tmpNum) q:tmpPiece=""  d
 .d json.InsertRowData(tmpNum-1_"^"_tmpPiece)
 .s tmpNum=tmpNum+1 
 s resultString = json.getJsonData(jsonTitle,tmpNum-2)
 k json
 q resultString
}

/// w ##class(web.DHCOPBillActManageJson).IPIncomeH("2008-07-14","2010-04-08")
ClassMethod IPIncomeH(stDate, endDate, CredNo) As %String
{
 n (stDate, endDate,CredNo)
 s stDate=$zdh(stDate,3)
 s endDate=$zdh(endDate,3)
 s tmpData=##class(web.DHCOPBillActManage).IPIncomeByDate(stDate,endDate,CredNo)
 s tmpHead=$p(tmpData,$c(2),1)
 s json=##class(web.com.JsonObj).%New()
 s jsonTitle="rowid^name^title"
 s tmpNum=1
 f  s tmpPiece=$p(tmpHead,"^",tmpNum) q:tmpPiece=""  d
 .s tmpJson=tmpNum_"^"_tmpPiece_"^"_tmpPiece
 .d json.InsertRowData(tmpJson)
 .s tmpNum=tmpNum+1
 s resultString = json.getJsonData(jsonTitle,tmpNum-1)
 k json
 q resultString
}

/// w ##class(web.DHCOPBillActManageJson).IPIncomeJ("2010-08-26","2010-08-27")
ClassMethod IPIncomeJ(stDate, endDate, CredNo) As %String
{
 n (stDate, endDate,CredNo)
 s stDate=$zdh(stDate,3)
 s endDate=$zdh(endDate,3)
 s tmpData=##class(web.DHCOPBillActManage).IPIncomeByDate(stDate,endDate,CredNo)
 s jsonTitle="rowid^"_$p(tmpData,$c(2),1)
 s json=##class(web.com.JsonObj).%New()
 s tmpNum=2
 f  s tmpPiece=$p(tmpData,$c(2),tmpNum) q:tmpPiece=""  d
 .d json.InsertRowData(tmpNum-1_"^"_tmpPiece)
 .s tmpNum=tmpNum+1 
 .;OPIncomeByAdmreason
 .s tmpAdDate=$p(tmpPiece,"^",1)
 .i tmpAdDate'="合计" d
 ..s tmpAdDate=$zdh(tmpAdDate,3)
 ..s tmpAdData=##class(web.DHCOPBillActManage).IPIncomeByAdmreason(tmpAdDate)
 ..s tmpAdNum=1
 ..f  s tmpAdPiece=$p(tmpAdData,"^",tmpAdNum) q:tmpAdPiece=""  d
 ...s tmpAdNum=tmpAdNum+1 
 ...;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 s resultString = json.getJsonData(jsonTitle,tmpNum-2)
 k json
 q resultString
}

/// w ##class(web.DHCOPBillActManageJson).IPIncomeByAdmreasonH("2010-04-02")
ClassMethod IPIncomeByAdmreasonH(date, CredNo) As %String
{
 n (date,CredNo)
 s date=$zdh(date,3)
 s tmpData=##class(web.DHCOPBillActManage).IPIncomeByAdmreason(date)
 s tmpHead=$p(tmpData,$c(2),1)
 s tmpNum=1
 f  s tmpPiece=$p(tmpHead,"^",tmpNum) q:tmpPiece=""  d
 .s tmpNum=tmpNum+1

 s tmpData=##class(web.DHCOPBillActManage).IPIncomeByDate(date,date,CredNo)
 s tmpHead=$p(tmpData,$c(2),1)
 s json=##class(web.com.JsonObj).%New()
 s jsonTitle="rowid^name^title"
 s tmpN=1
 f  s tmpPiece=$p(tmpHead,"^",tmpN+1) q:tmpN=tmpNum  d
 .s tmpJson=tmpN_"^"_tmpPiece_"^"_tmpPiece
 .d json.InsertRowData(tmpJson)
 .s tmpN=tmpN+1
 s resultString = json.getJsonData(jsonTitle,tmpN-1)
 k json
 q resultString
}

/// w ##class(web.DHCOPBillActManageJson).IPIncomeByAdmreasonJ("2010-04-02")
ClassMethod IPIncomeByAdmreasonJ(date, CredNo) As %String
{
 n (date,CredNo)
 s date=$zdh(date,3)
 
 s tmpData=##class(web.DHCOPBillActManage).IPIncomeByAdmreason(date)
 s tmpHead=$p(tmpData,$c(2),1)
 s tmpNum=1
 f  s tmpPiece=$p(tmpHead,"^",tmpNum) q:tmpPiece=""  d
 .s tmpNum=tmpNum+1
 s tmpData=##class(web.DHCOPBillActManage).IPIncomeByDate(date,date,CredNo)
 s tmpHead=$p(tmpData,$c(2),1)
 s jsonTitle=""
 s tmpN=1
 f  s tmpPiece=$p(tmpHead,"^",tmpN+1) q:tmpN=tmpNum  d
 .s tmpN=tmpN+1
 .i jsonTitle="" d
 ..s jsonTitle=tmpPiece
 .e  d
 ..s jsonTitle=jsonTitle_"^"_tmpPiece

 s tmpData=##class(web.DHCOPBillActManage).IPIncomeByAdmreason(date)
 //s jsonTitle="rowid^"_$p(tmpData,$c(2),1)
 s json=##class(web.com.JsonObj).%New()
 s tmpNum=1
 f  s tmpPiece=$p(tmpData,$c(2),tmpNum) q:tmpPiece=""  d
 .d json.InsertRowData(tmpPiece)
 .s tmpNum=tmpNum+1 
 s resultString = json.getJsonData(jsonTitle,tmpNum-1)
 k json
 q resultString
}

/// w ##class(web.DHCOPBillActManageJson).BuildCredP("DHCOPB001",61193,"",1,1)
ClassMethod BuildCredP(CredCode, Date, User, Guser, yearPeriodId) As %String
{
 n (CredCode, Date, User, Guser, yearPeriodId)
 //&sql(insert into ACCT_VouchBuss (Acct_Vouch_Dr, buss_no) values(:acctModDr, :acctSubjDr, :typeCode, :locDr, :docType))
 s tmpCode=##class(web.AccCredManage).BuildCred(CredCode, Date, Date, User, Guser, yearPeriodId)
 q tmpCode
}

Storage Default
{
<StreamLocation>^web.DHCOPBillActManageJsonS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
