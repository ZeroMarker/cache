Import sqluser

/// Descript:药品调价原因维护
/// Creater:    LiMingzhong
/// CreateDate: 2012-6-7
Class web.DHCST.DHCReasonForAdjustPrice Extends (%RegisteredObject, StkTypeG) [ Not ProcedureBlock ]
{

Parameter TableName [ Final ] = "DHC_ReasonForAdjustPrice";

/// Descript:   保存/更新调价原因
/// Creater:    LiMingzhong
/// CreateDate: 2012-6-7
/// Table:DHC_ReasonForAdjustPrice
/// Input:数据串:rowid^代码^描述,rowid^代码^描述
/// Output:     
/// Return："" : 成功，非空：失败
ClassMethod Save(listData As %String, hosp) As %Library.String
{
    n (listData,hosp)
    ;s ^zdm("cs")=listData
    s rowDelim=##class(web.DHCST.Common.UtilCommon).RowDataDelim()
    s len=$l(listData,rowDelim)
    s msg=0
    s err=""
    f i=1:1:len  d
    .s data=$p(listData,rowDelim,i)
    .s rowid=$p(data,"^",1)
    .s code=$p(data,"^",2)
    .s desc=$p(data,"^",3)
    .q:code=""
	.q:desc=""
	.s chkExist=..CheckExist(rowid,code,desc,hosp)
	.i chkExist'="" s msg=chkExist q
    .q:msg'=0
    .i rowid'=""  d
    ..s ret=..Update(rowid,code,desc)
    ..s:ret'=0 err=err //_","_desc
    .e  d
    ..s ret=..Insert(code,desc)
    ..i ret'="" d ##class(PHA.FACE.IN.Com).SaveBasicDataHosp(..#TableName, ret, hosp)
    ..s:ret'="" err=err //_","_desc
    q:msg=-1 msg 
	q:msg=-2 msg 
	q:msg'=0 msg
	q err
}

/// Descript:   增加调价原因
/// Creater:    LiMingzhong
/// CreateDate: 2012-6-7
/// Table:DHC_ReasonForAdjustPrice
/// Input:代码,描述
/// Output:     
/// Return：rowid
ClassMethod Insert(code As %String, desc As %String) As %Library.String [ Private ]
{
    n (code,desc)
    s type="G"
    ;
    ;不能为空项
    q:code="" ""
    q:desc="" ""
    //q:$d(^DHCSTREASON("ASP",0,"Code",$$ALPHAUP^SSUTIL4(code))) ""
    //q:$d(^DHCSTREASON("ASP",0,"Desc",$$ALPHAUP^SSUTIL4(desc))) ""
    ;
    &sql(Insert into DHC_ReasonForAdjustPrice(REA_Code,REA_Desc,REA_StkType) values(:code,:desc,:type))
    s Err=0
    ;b ;1
    i SQLCODE'=0  d
    .s rett=$$ErrorRecord^DHCSTERROR("Insert:DHC_ReasonForAdjustPrice",desc,SQLCODE_":"_%msg)
    .s Err=-1
    q:Err'=0 ""
    //q:SQLCODE'=0 ""
    q $p(%ROWID,$c(1))
}

/// Descript:   更新调价原因
/// Creater:    LiMingzhong
/// CreateDate: 2012-6-7
/// Table:DHC_ReasonForAdjustPrice
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
    s Err=""
    //s tmpid=$o(^DHCSTREASON("ASP",0,"Code",$$ALPHAUP^SSUTIL4(code),""))
    //q:(tmpid'="")&(tmpid'=rowid) -1 
    //s tmpid=$o(^DHCSTREASON("ASP",0,"Desc",$$ALPHAUP^SSUTIL4(desc),"")) 
    //q:(tmpid'="")&(tmpid'=rowid) -2
    ;
    &sql(Update DHC_ReasonForAdjustPrice set REA_Code=:code,REA_Desc=:desc where REA_Rowid=:rowid)
    i SQLCODE'=0  d
    .s rett=$$ErrorRecord^DHCSTERROR("Update:DHC_ReasonForAdjustPrice",desc,SQLCODE_":"_%msg)
    .s Err=-1
    q Err
    //q SQLCODE
}

/// Descript:   删除调价原因
/// Creater:    LiMingzhong
/// CreateDate: 2012-6-7
/// Table:DHC_ReasonForAdjustPrice
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
    &sql(Delete from DHC_ReasonForAdjustPrice where REA_RowId=:rowid)
    i SQLCODE'=0  d
    .s rett=$$ErrorRecord^DHCSTERROR("Delete:DHC_ReasonForAdjustPrice",rowid,SQLCODE_":"_%msg)
    e  d
    .d ##class(PHA.FACE.IN.Com).DeleteBasicDataHosp(..#TableName,rowid,hosp)
    q SQLCODE
}

/// Descript:   查询调价原因信息
/// Creater:    LiMingzhong
/// CreateDate: 2012-6-7
/// Table:DHC_ReasonForAdjustPrice
/// Input:
/// Output:     
/// Return：调价原因信息
ClassMethod SelectAll(hosp)
{
	S Type="G"
    s result = ##class(%Library.ResultSet).%New()
    s sqlStr = "select REA_RowId as RowId, REA_Code as Code, REA_Desc as Description,REA_StkType AS StkType from DHC_ReasonForAdjustPrice"
    d result.Prepare(sqlStr)
    d result.Execute()
    ;
    s count = 0
    s resultString = ""
    s json = ##class(Code.JsonObj).%New()
    While(result.Next())
    {   
        s Rowid = result.Data("RowId")
        s Code = result.Data("Code")
        s StkType= result.Data("StkType")
       	continue:##class(PHA.FACE.IN.Com).GetShowDataFlag(..#TableName,Rowid,hosp)="N"
        CONTINUE:(+Rowid=0)||((StkType'="")&(StkType'=Type))
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

ClassMethod CheckExist(rowId, code, desc, hosp)
{
	n (code,desc,rowId,hosp)
	s errCode=""
	s type=..sssCode()
	s sqlStr="SELECT REA_RowId AS rowID FROM DHC_ReasonForAdjustPrice WHERE REA_StkType='"_type_"'"
	i rowId="" d
	.s newSqlStr=sqlStr_" AND REA_Code='"_code_"'"
	.s existFlag=##class(PHA.COM.Method).IsSQLDataExist(newSqlStr,..#TableName,hosp)
  	.i existFlag'="" s errCode=-1
	.s newSqlStr=sqlStr_" AND REA_Desc='"_desc_"'"
	.s existFlag=##class(PHA.COM.Method).IsSQLDataExist(newSqlStr,..#TableName,hosp)
  	.i existFlag'="" s errCode=-2
	e  d
	.s newSqlStr=sqlStr_" AND REA_Code='"_code_"'"_" AND REA_RowId!='"_rowId_"'"
	.s existFlag=##class(PHA.COM.Method).IsSQLDataExist(newSqlStr,..#TableName,hosp)
  	.i existFlag'="" s errCode=-1
	.s newSqlStr=sqlStr_" AND REA_Desc='"_desc_"'"_" AND REA_RowId!='"_rowId_"'"
	.s existFlag=##class(PHA.COM.Method).IsSQLDataExist(newSqlStr,..#TableName,hosp)
  	.i existFlag'="" s errCode=-2
	q errCode
}

}
