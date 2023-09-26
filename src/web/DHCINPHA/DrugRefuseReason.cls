Import SQLUser

Class web.DHCINPHA.DrugRefuseReason Extends (%RegisteredObject, websys.Abstract) [ ClassType = "", ProcedureBlock ]
{

Parameter TableName [ Final ] = "DHC_STRefuseReason";

/// 拒绝发药原因维护列表
/// w ##class(web.DHCINPHA.DrugRefuseReason).jsGetDrugRefuseReasonList(1,10,"",2)
ClassMethod jsGetDrugRefuseReasonList(page, rows, params, hosp)
{
	s stpage=((page-1)*rows)+1 //开始行
	s endpage=page*rows  //结束行
	s pid=..NewPid()
    s $zt="ErrorjsGetDrugRefuseReasonList"
    s result=##class(%Library.ResultSet).%New("web.DHCINPHA.DrugRefuseReason:RefReason")
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
		continue:##class(PHA.FACE.IN.Com).GetShowDataFlag(..#TableName,result.%Get("Rowid"),hosp)="N"
		s countrecords=countrecords+1  //可做索引用
		s ^TMP("DHCST","web.DHCINPHA.DrugRefuseReason","jsGetDrugRefuseReasonList",pid,countrecords)=ret
	}
	q:countrecords="0" ##class(web.DHCSTJQUERYCOMMON).getJsonEmptySign(0)
	i endpage>countrecords s endpage=countrecords
	s count=0
	s outputi=""
	f  s outputi=$o(^TMP("DHCST","web.DHCINPHA.DrugRefuseReason","jsGetDrugRefuseReasonList",pid,outputi)) q:outputi=""  d
	.s outputdata=^TMP("DHCST","web.DHCINPHA.DrugRefuseReason","jsGetDrugRefuseReasonList",pid,outputi)
	.s count=count+1
	.q:count<stpage
    .q:count>endpage
	.I count=stpage d
	..w ##class(web.DHCSTJQUERYCOMMON).GetJsonStartString(countrecords)
	..W ##class(web.DHCSTJQUERYCOMMON).getJsonData(colNameStr,outputdata)
	.e  d
	..W ","_##class(web.DHCSTJQUERYCOMMON).getJsonData(colNameStr,outputdata)
	.i count=endpage w ##class(web.DHCSTJQUERYCOMMON).getJsonEndSign()
	k ^TMP("DHCST","web.DHCINPHA.DrugRefuseReason","jsGetDrugRefuseReasonList",pid)
	q ""
ErrorjsGetDrugRefuseReasonList
	k ^TMP("DHCST","web.DHCINPHA.DrugRefuseReason","jsGetDrugRefuseReasonList",pid)
	s Error=$$Error^DHCSTERROR()
	q Error
}

ClassMethod NewPid()
{
	q $i(^DHCOUTPHA("web.DHCINPHA.DrugRefuseReason"))
}

// 查询拒绝发药原因

Query RefReason() As %SQLQuery(ROWSPEC = "Rowid:%String,Code:%String,Desc:%String")
{
 select  rf_rowid,rf_code,rf_desc From dhc_strefusereason
}

/// 增加拒绝发药原因
/// w ##class(web.DHCINPHA.DrugRefuseReason).InsertRefReason("3333","","012")
ClassMethod InsertRefReason(rowid As %String, code As %String, desc As %String, hosp) As %String
{
 s chkRet=..CheckRefReason("",code,desc,hosp)
 q:chkRet'=0 chkRet
 i rowid="" d
 .&sql(insert into dhc_strefusereason(rf_code,rf_desc) values (:code,:desc) )
 .
 q:SQLCODE -1
 d ##class(PHA.FACE.IN.Com).SaveBasicDataHosp(..#TableName, $p(%ROWID,$c(1)), hosp)
 q 0
}

/// 更新拒绝发药原因
/// d ##class(web.DHCINPHA.DrugRefuseReason).UpdateRefReason("37","7","不要多问")
ClassMethod UpdateRefReason(rowid As %String, code As %String, desc As %String, hosp) As %String
{
 s icode=$$ALPHAUP^SSUTIL4(code)
 s idesc=$$ALPHAUP^SSUTIL4(desc)
 q:icode="" -99
 q:idesc="" -99
 s valFlag=0
 i rowid="" d
 .s chkRet=..CheckRefReason("",code,desc,hosp)
 .i chkRet'=0 s valFlag=-1 q
 .&sql(insert into dhc_strefusereason(rf_code,rf_desc) values (:code,:desc) )
 .i SQLCODE=0 d
 ..d ##class(PHA.FACE.IN.Com).SaveBasicDataHosp(..#TableName, $p(%ROWID,$c(1)), hosp)
 e  d
 .s ret=..CheckRefReason(rowid,icode,idesc,hosp)
 .s valFlag=ret 
 .q:ret'=0 
 .&sql(update dhc_strefusereason set rf_code=:code,rf_desc=:desc where rf_rowid=:rowid)
 q:valFlag'=0 valFlag
 q:SQLCODE -100
 q %ROWID
}

/// 检查拒绝发药原因
/// d ##class(web.DHCINPHA.DrugRefuseReason).CheckRefReason("37","7","不要多问")
ClassMethod CheckRefReason(rowid, icode, idesc, hosp) As %String
{
  	s errCode=0
	s sqlStr="SELECT RF_Rowid AS rowID FROM DHC_STRefuseReason WHERE 1=1" 
	i rowid="" d
	.s newSqlStr=sqlStr_" AND RF_Code='"_icode_"'"
	.s existFlag=##class(PHA.COM.Method).IsSQLDataExist(newSqlStr,..#TableName,hosp)
  	.i existFlag'="" s errCode=-1
	.s newSqlStr=sqlStr_" AND RF_Desc='"_idesc_"'"
	.s existFlag=##class(PHA.COM.Method).IsSQLDataExist(newSqlStr,..#TableName,hosp)
  	.i existFlag'="" s errCode=-2
	e  d
	.s newSqlStr=sqlStr_" AND RF_Code='"_icode_"'"_" AND RF_Rowid!='"_rowid_"'"
	.s existFlag=##class(PHA.COM.Method).IsSQLDataExist(newSqlStr,..#TableName,hosp)
  	.i existFlag'="" s errCode=-1
	.s newSqlStr=sqlStr_" AND RF_Desc='"_idesc_"'"_" AND RF_Rowid!='"_rowid_"'"
	.s existFlag=##class(PHA.COM.Method).IsSQLDataExist(newSqlStr,..#TableName,hosp)
  	.i existFlag'="" s errCode=-2
	q errCode
}

/// 删除拒绝发药原因
/// d ##class(web.DHCINPHA.DrugRefuseReason).DeleteRefReason("45")
ClassMethod DeleteRefReason(rowid As %String, hosp) As %String
{
 q:rowid="" 0
 &sql(delete from dhc_strefusereason where rf_rowid=:rowid)
 q:SQLCODE -1
 d ##class(PHA.FACE.IN.Com).DeleteBasicDataHosp(..#TableName,rowid,hosp)
 q 0
}

}
