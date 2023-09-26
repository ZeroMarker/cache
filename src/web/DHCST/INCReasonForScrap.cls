Import sqluser

/// Descript:报损原因维护
/// Creater:	LiangQiang
/// CreateDate:	2013-12-26
Class web.DHCST.INCReasonForScrap Extends (%RegisteredObject, StkTypeG) [ Not ProcedureBlock ]
{

/// Descript:	保存/更新报损原因
/// Creater:	LiangQiang
/// CreateDate:	2013-12-26
/// Table:DHC_IncReasonForStockScrap
/// Input:数据串:rowid^代码^描述,rowid^代码^描述
/// Output:		
/// Return："" : 成功，非空：失败
ClassMethod Save(listData As %String, hosp) As %Library.String
{
	n (listData,hosp)
	s rowDelim=##class(web.DHCST.Common.UtilCommon).RowDataDelim()
	i listData="" d
	.s len=0
	e  d
	.s len=$l(listData,rowDelim)
	s msg=0
	s err=""
	f i=1:1:len q:msg'=0  d
	.s data=$p(listData,rowDelim,i)
	.s rowid=$p(data,"^",1)
	.s code=$p(data,"^",2)
	.s desc=$p(data,"^",3)
	.q:code=""
	.q:desc=""
	.s tmpid=""
	.s chkRet=..CheckExist(rowid,code,desc,hosp)
	.i chkRet'="" s msg=chkRet q
    .q:msg'=0
	.i rowid'=""  d
	..s ret=..Update(rowid,code,desc)
	..s:ret'=0 err=err //_","_desc
	.e  d
	..s ret=..Insert(code,desc)
	..s:ret'="" err=err //_","_desc
	..i +ret>0 d
 	...d ##class(PHA.FACE.IN.Com).SaveBasicDataHosp("DHC_IncReasonForStockScrap", ret, hosp)
	q:msg=-1 msg 
	q:msg=-2 msg 
	q:msg'=0 msg
	q err
}

/// Descript:	增加报损原因
/// Creater:	LiangQiang
/// CreateDate:	2013-12-26
/// Table:DHC_IncReasonForStockScrap
/// Input:代码,描述
/// Output:		
/// Return：rowid
ClassMethod Insert(code As %String, desc As %String) As %Library.String [ Private ]
{
	n (code,desc)
 	;
 	;不能为空项
 	q:code="" ""
 	q:desc="" ""
 	s type=..sssCode()
 	s Err=0
 	&sql(Insert into DHC_IncReasonForStockScrap(REASON_ScrapCode,REASON_ScrapDesc,REASON_ScrapType)
 	values(:code,:desc,:type))
 	
 	i SQLCODE'=0  d
 	.s rett=$$ErrorRecord^DHCSTERROR("Insert:DHC_IncReasonForStockScrap",desc,SQLCODE_":"_%msg)
 	q:Err'=0 ""
 	q:SQLCODE'=0 ""
 	q $p(%ROWID,$c(1))
}

/// Descript:	更新报损原因
/// Creater:	LiangQiang
/// CreateDate:	2013-12-26
/// Table:DHC_IncReasonForStockScrap
/// Input:rowid^代码^描述
/// Output:		
/// Return：rowid
ClassMethod Update(rowid As %String, code As %String, desc As %String) As %Library.String [ Private ]
{
	n (rowid,code,desc)
 	;
 	;不能为空项
 	q:code="" ""
 	q:desc="" ""
 	q:rowid="" ""
 	s type=..sssCode()
 	s Err=""
 	&sql(Update DHC_IncReasonForStockScrap set REASON_ScrapCode=:code,REASON_ScrapDesc=:desc,REASON_ScrapType=:type
 	where REASON_ScrapRowID=:rowid)
 	i SQLCODE'=0  d
 	.s rett=$$ErrorRecord^DHCSTERROR("Update:DHC_IncReasonForStockScrap",desc,SQLCODE_":"_%msg)
 	q Err
 	q SQLCODE
}

/// Descript:	删除报损原因
/// Creater:	LiangQiang
/// CreateDate:	2013-12-26
/// Table:DHC_IncReasonForStockScrap
/// Input:rowid
/// Output:		
/// Return：0 – 成功，非0 ：失败
ClassMethod Delete(rowid As %String, hosp) As %Library.String
{
	n (rowid,hosp)
 	;
 	;不能为空项
 	q:rowid="" ""
 	;
 	&sql(Delete from DHC_IncReasonForStockScrap where REASON_ScrapRowID=:rowid)
 	i SQLCODE'=0  d
 	.s rett=$$ErrorRecord^DHCSTERROR("Delete:DHC_IncReasonForStockScrap",rowid,SQLCODE_":"_%msg)
 	e  d
 	.d ##class(PHA.FACE.IN.Com).DeleteBasicDataHosp("DHC_IncReasonForStockScrap",rowid,hosp)
 	q SQLCODE
}

/// Descript:	查询报损原因信息
/// Creater:	LiangQiang
/// CreateDate:	2013-12-26
/// Table:DHC_IncReasonForStockScrap
/// Input:
/// Output:		
/// Return：报损原因信息
ClassMethod SelectAll(hosp)
{
	n (hosp)
	S Type="G"
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "SELECT REASON_ScrapRowID as Rowid,REASON_ScrapCode as Code,REASON_ScrapDesc as Description,REASON_ScrapType As SType"_  
	" FROM DHC_IncReasonForStockScrap"
	d result.Prepare(sqlStr)
	d result.Execute()
	;
	s count = 0
	s resultString = ""
	s json = ##class(Code.JsonObj).%New()
	While(result.Next())
	{	
		s Rowid = result.Data("Rowid")
		s Code = result.Data("Code")
		s SType=result.Data("SType")
		continue:##class(PHA.FACE.IN.Com).GetShowDataFlag("DHC_IncReasonForStockScrap",Rowid,hosp)="N"
		CONTINUE:(+Rowid=0)||((SType'=Type)&(SType'=""))
		s Description = result.Data("Description")
		s tmp=Rowid_"^"_Code_"^"_Description
		s count = count+1		
		d json.InsertRowData(tmp)
	}
	d result.Close()
	s resultString = json.getJsonData("RowId^Code^Desc",count)
	k json
	Q resultString
}

/// creator:	 yunhaibao
/// createdate:  2017-12-31
/// description: 验证原因是否重复
ClassMethod CheckExist(rowId, code, desc, hosp)
{
	n (code,desc,rowId,hosp)
	s errCode=""
	s type=..sssCode()
	s sqlStr="SELECT REASON_ScrapRowID as rowID FROM DHC_IncReasonForStockScrap WHERE REASON_ScrapType='"_type_"'"
	i rowId="" d
	.s newSqlStr=sqlStr_" AND REASON_ScrapCode='"_code_"'"
	.s existFlag=##class(PHA.COM.Method).IsSQLDataExist(newSqlStr,"DHC_IncReasonForStockScrap",hosp)
  	.i existFlag'="" s errCode=-1
	.s newSqlStr=sqlStr_" AND REASON_ScrapDesc='"_desc_"'"
	.s existFlag=##class(PHA.COM.Method).IsSQLDataExist(newSqlStr,"DHC_IncReasonForStockScrap",hosp)
  	.i existFlag'="" s errCode=-2
	e  d
	.s newSqlStr=sqlStr_" AND REASON_ScrapCode='"_code_"'"_" AND REASON_ScrapRowID!='"_rowId_"'"
	.s existFlag=##class(PHA.COM.Method).IsSQLDataExist(newSqlStr,"DHC_IncReasonForStockScrap",hosp)
  	.i existFlag'="" s errCode=-1
	.s newSqlStr=sqlStr_" AND REASON_ScrapDesc='"_desc_"'"_" AND REASON_ScrapRowID!='"_rowId_"'"
	.s existFlag=##class(PHA.COM.Method).IsSQLDataExist(newSqlStr,"DHC_IncReasonForStockScrap",hosp)
  	.i existFlag'="" s errCode=-2
	q errCode
}

}
