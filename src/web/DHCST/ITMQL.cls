Import sqluser

/// Descript:质量参次维护
/// Creater:	ZhangDongmei
/// CreateDate:	2012-05-28
Class web.DHCST.ITMQL Extends (%RegisteredObject, StkTypeG) [ Not ProcedureBlock ]
{

/// Descript:	保存/更新质量层次信息
/// Creater:	ZhangDongmei
/// CreateDate:	2012-05-28
/// Table:DHC_ItmQualityLevel
/// Input:数据串:rowid^代码^描述^开始日期^截止日期,rowid^代码^描述^开始日期^截止日期,
/// Output:		
/// Return："" – 成功，
/// 非空：失败
ClassMethod Save(listData As %String) As %Library.String
{
	n (listData)
	;s ^zdm("cs")=listData
	s rowDelim=##class(web.DHCST.Common.UtilCommon).RowDataDelim()
	i listData="" d
	.s len=0
	e  d
	.s len=$l(listData,rowDelim)
	s msg=0
	s err=""
	f i=1:1:len  q:msg'=0  d
	.s data=$p(listData,rowDelim,i)
	.s rowid=$p(data,"^",1)
	.s code=$p(data,"^",2)
	.s desc=$p(data,"^",3)
	.q:code=""
	.q:desc=""
	.s stdate=$p(data,"^",4)
	.s eddate=$p(data,"^",5)
	.s tmpid=$o(^DHCITMQL(0,"Code",$$ALPHAUP^SSUTIL4(code),""))
 	.s:(tmpid'="")&(tmpid'=rowid) msg=-1
 	.s tmpid=$o(^DHCITMQL(0,"Desc",$$ALPHAUP^SSUTIL4(desc),"")) 
 	.s:(tmpid'="")&(tmpid'=rowid) msg=-2
 	.q:msg'=0
 	.s:stdate'="" stdate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(stdate)
 	.s:eddate'="" eddate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(eddate)
	.i rowid'=""  d
	..s ret=..Update(rowid,code,desc,stdate,eddate)
	..s:ret'=0 err=err_","_desc
	.e  d
	..s ret=..Insert(code,desc,stdate,eddate)
	..s:ret="" err=err_","_desc
	.
	//q:msg=-1 code_"重复"
	//q:msg=-2 desc_"重复"
	q:msg'=0 msg
	q err
}

/// Descript:	增加质量层次信息
/// Creater:	ZhangDongmei
/// CreateDate:	2012-05-28
/// Table:DHC_ItmQualityLevel
/// Input:代码,描述,开始日期,截止日期
/// Output:		
/// Return：rowid
ClassMethod Insert(Code As %String, Desc As %String, StDate As %String, EdDate As %String) As %Library.String [ Private ]
{
	n (Code,Desc,StDate,EdDate)
 	;
 	;不能为空项
 	q:Code="" ""
 	q:Desc="" ""
 	s:+StDate=0 StDate=+$h
 	s:+EdDate=0 EdDate=$zdh("9999-12-31",3)
 	;
 	&sql(Insert into DHC_ItmQualityLevel(QL_Code,QL_Desc,QL_DateFrom,QL_DateTo)
 	values(:Code,:Desc,:StDate,:EdDate))
 	s Err=0
 	i SQLCODE'=0  d
 	.d ErrorRecord^DHCSTERROR("Insert:DHC_ItmQualityLevel",Desc,SQLCODE_":"_%msg)
 	.s Err=-1
 	q:Err'=0 ""
 	q $p(%ROWID,$c(1))
}

/// Descript:	更新质量层次信息
/// Creater:	ZhangDongmei
/// CreateDate:	2012-05-28
/// Table:DHC_ItmQualityLevel
/// Input:rowid,代码,描述,开始日期,截止日期
/// Output:		
/// Return：0:成功;非0：失败
ClassMethod Update(Rowid As %String, Code As %String, Desc As %String, StDate As %String, EdDate As %String) As %Library.String [ Private ]
{
	n (Rowid,Code,Desc,StDate,EdDate)
 	;
 	;不能为空项
 	q:Code="" ""
 	q:Desc="" ""
 	q:Rowid="" ""
 	s:+StDate=0 StDate=+$h
 	s:+EdDate=0 EdDate=$zdh("9999-12-31",3)
 	;
 	s Err=0
 	&sql(Update DHC_ItmQualityLevel set QL_Code=:Code,QL_Desc=:Desc,QL_DateFrom=:StDate,
 	QL_DateTo=:EdDate where QL_Rowid=:Rowid)
 	i SQLCODE'=0  d
 	.d ErrorRecord^DHCSTERROR("Update:DHC_ItmQualityLevel",Desc,SQLCODE_":"_%msg)
 	.s Err=-1
 	q Err
}

/// Descript:	删除质量层次信息
/// Creater:	ZhangDongmei
/// CreateDate:	2012-05-28
/// Table:DHC_ItmQualityLevel
/// Input:rowid
/// Output:		
/// Return：0 – 成功，非0 ：失败
ClassMethod Delete(rowid As %String) As %Library.String
{
	n (rowid)
 	;
 	;不能为空项
 	q:rowid="" ""
 	;
 	s Err=0
 	&sql(Delete from DHC_ItmQualityLevel where QL_Rowid=:rowid)
 	i SQLCODE'=0  d
 	.d ErrorRecord^DHCSTERROR("Delete:DHC_ItmQualityLevel",rowid,SQLCODE_":"_%msg)
 	.s Err=-1
 	q Err
}

/// Descript:	查询质量层次信息
/// Creater:	ZhangDongmei
/// CreateDate:	2012-05-28
/// Table:DHC_ItmQualityLevel
/// Input:
/// Output:		
/// Return：质量层次信息
ClassMethod SelectAll()
{
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "SELECT QL_Rowid as Rowid,QL_Code,QL_Desc,QL_DateFrom,QL_DateTo"_  
	" FROM DHC_ItmQualityLevel"
	d result.Prepare(sqlStr)
	d result.Execute()
	;
	s count = 0
	s resultString = ""
	s json = ##class(Code.JsonObj).%New()
	While(result.Next())
	{	
		s Rowid = result.Data("Rowid")
		CONTINUE:+Rowid=0
		s Code = result.Data("QL_Code")
		s Desc = result.Data("QL_Desc")
		s DateFrom = result.Data("QL_DateFrom")
		s DateTo = result.Data("QL_DateTo")
		s:DateFrom'="" DateFrom=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(DateFrom,"ST")
		s:DateTo'="" DateTo=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(DateTo,"ST")
		;
		s tmp=Rowid_"^"_Code_"^"_Desc_"^"_DateFrom_"^"_DateTo
		s count = count+1		
		d json.InsertRowData(tmp)
	}
	d result.Close()
	s resultString = json.getJsonData("RowId^Code^Desc^DateFrom^DateTo",count)
	k json
	Q resultString
}

}
