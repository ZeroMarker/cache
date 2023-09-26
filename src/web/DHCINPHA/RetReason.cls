Import SQLUser

Class web.DHCINPHA.RetReason Extends %RegisteredObject
{

Parameter TableName [ Final ] = "BLC_ReasonForRefund";

/// 退药原因维护列表
/// d ##class(web.DHCINPHA.RetReason).jsGetRetReasonList(1,10,"")
ClassMethod jsGetRetReasonList(page, rows, params, hosp)
{
	s stpage=((page-1)*rows)+1 //开始行
	s endpage=page*rows  //结束行
	s pid=..NewPid()
    s $zt="ErrorjsGetRetReasonList"
    s result=##class(%Library.ResultSet).%New("web.DHCINPHA.RetReason:GetRetReasons")
	s sc=result.Execute()
	i $$$ISERR(sc) q ##class(web.DHCSTJQUERYCOMMON).getJsonEmptySign(0) 
	s colNum=result.GetColumnCount()
	s colNameStr=""
	f i=1:1:colNum d
	.i colNameStr="" s colNameStr=result.GetColumnName(i)
	.e  s colNameStr=colNameStr_"^"_result.GetColumnName(i)
	s countrecords=0
	While(result.Next())
	{ 
		s ret=""
		f i=1:1:colNum d
		.i ret="" s ret=result.%GetData(i)
		.e   s ret=ret_"^"_result.%GetData(i)
		continue:##class(PHA.FACE.IN.Com).GetShowDataFlag(..#TableName,result.%Get("TRowid"),hosp)="N"
		s countrecords=countrecords+1  //可做索引用
		s ^TMP("DHCST","web.DHCINPHA.RetReason","jsGetRetReasonList",pid,countrecords)=ret
	}
	q:countrecords="0" ##class(web.DHCSTJQUERYCOMMON).getJsonEmptySign(0)
	i endpage>countrecords s endpage=countrecords
	s count=0
	s outputi=""
	f  s outputi=$o(^TMP("DHCST","web.DHCINPHA.RetReason","jsGetRetReasonList",pid,outputi)) q:outputi=""  d
	.s outputdata=^TMP("DHCST","web.DHCINPHA.RetReason","jsGetRetReasonList",pid,outputi)
	.s count=count+1
	.q:count<stpage
    .q:count>endpage
	.I count=stpage d
	..w ##class(web.DHCSTJQUERYCOMMON).GetJsonStartString(countrecords)
	..W ##class(web.DHCSTJQUERYCOMMON).getJsonData(colNameStr,outputdata)
	.e  d
	..W ","_##class(web.DHCSTJQUERYCOMMON).getJsonData(colNameStr,outputdata)
	.i count=endpage w ##class(web.DHCSTJQUERYCOMMON).getJsonEndSign()
	k ^TMP("DHCST","web.DHCINPHA.RetReason","jsGetRetReasonList",pid)
	q ""
ErrorjsGetRetReasonList
	k ^TMP("DHCST","web.DHCINPHA.RetReason","jsGetRetReasonList",pid)
	s Error=$$Error^DHCSTERROR()
	q Error
}

ClassMethod NewPid()
{
	q $i(^DHCOUTPHA("web.DHCINPHA.RetReason"))
}

/// 查询退药原因
Query GetRetReasons() As %SQLQuery(ROWSPEC = "TReasonDesc:%String,TRowid:%String,TReasonCode:%String")
{
 select Rfr_desc,Rfr_rowid,Rfr_code From BLC_ReasonForRefund
}

/// 增加退药原因
/// w ##class(web.DHCINPHA.RetReason).InsertRetReason("对对对","","对对对","4")
ClassMethod InsertRetReason(desc As %String, rowid As %String, code As %String, hosp) As %String
{
 s exist=..CheckExist("", code, desc, hosp)
 q:exist<0 exist	
 i rowid="" d
 .&sql(insert into BLC_ReasonForRefund(RFR_Code,RFR_Desc) values (:code,:desc) )
 q:SQLCODE -1
 d ##class(PHA.FACE.IN.Com).SaveBasicDataHosp(..#TableName, $p(%ROWID,$c(1)), hosp)
 q 0
}

/// 更新退药原因
ClassMethod UpdateRetReason(desc As %String, rowid As %String, code As %String, hosp) As %String
{
 s exist=..CheckExist(rowid, code, desc, hosp)
 q:exist<0 exist
 i rowid="" d
 .&sql(insert into BLC_ReasonForRefund(RFR_Code,RFR_Desc) values (:code,:desc) )
 .i SQLCODE=0 d
 ..d ##class(PHA.FACE.IN.Com).SaveBasicDataHosp(..#TableName, $p(%ROWID,$c(1)), hosp)
 e  d
 .&sql(update BLC_ReasonForRefund set RFR_Code=:code,RFR_Desc=:desc where RFR_RowId=:rowid)
 q:SQLCODE -1
 q 0
}

/// 删除退药原因
ClassMethod DeleteRetReason(rowid As %String, hosp) As %String
{
 q:rowid="" 0
 &sql(delete from BLC_ReasonForRefund where RFR_RowId=:rowid)
 q:SQLCODE -1
 d ##class(PHA.FACE.IN.Com).DeleteBasicDataHosp(..#TableName,rowid,hosp)
 q 0
}

ClassMethod CheckExist(rowid, icode, idesc, hosp) As %String
{
  	s errCode=0
	s sqlStr="SELECT RFR_RowId AS rowID FROM BLC_ReasonForRefund WHERE 1=1" 
	i rowid="" d
	.s newSqlStr=sqlStr_" AND RFR_Code='"_icode_"'"
	.s existFlag=##class(PHA.COM.Method).IsSQLDataExist(newSqlStr,..#TableName,hosp)
  	.i existFlag'="" s errCode=-12
	.s newSqlStr=sqlStr_" AND RFR_Desc='"_idesc_"'"
	.s existFlag=##class(PHA.COM.Method).IsSQLDataExist(newSqlStr,..#TableName,hosp)
  	.i existFlag'="" s errCode=-11
	e  d
	.s newSqlStr=sqlStr_" AND RFR_Code='"_icode_"'"_" AND RFR_RowId!='"_rowid_"'"
	.s existFlag=##class(PHA.COM.Method).IsSQLDataExist(newSqlStr,..#TableName,hosp)
  	.i existFlag'="" s errCode=-12
	.s newSqlStr=sqlStr_" AND RFR_Desc='"_idesc_"'"_" AND RFR_RowId!='"_rowid_"'"
	.s existFlag=##class(PHA.COM.Method).IsSQLDataExist(newSqlStr,..#TableName,hosp)
  	.i existFlag'="" s errCode=-11
	q errCode
}

}
