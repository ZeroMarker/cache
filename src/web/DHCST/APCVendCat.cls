Import sqluser

/// Descript:供应商分类相关
/// Creater:    ZhangDongmei
/// CreateDate: 2012-05-15
Class web.DHCST.APCVendCat Extends (%RegisteredObject, StkTypeG) [ Not ProcedureBlock ]
{

Parameter TableName [ Final ] = "APC_VendCat";

/// Descript:   保存/更新供应商分类信息
/// Creater:    ZhangDongmei
/// CreateDate: 2012-05-15
/// Table:APC_VendCat
/// Input:rowid^代码^描述,rowid^代码^描述
/// Output:     
/// Return：""：成功，非空：保存失败，请检查代码和描述是否重复
ClassMethod Save(listData As %String, hosp) As %Library.String
{
    n (listData,hosp)
    s rowDelim=##class(web.DHCST.Common.UtilCommon).RowDataDelim()
    s len=$l(listData,rowDelim)
    s err=""
    f i=1:1:len q:err'=""  d
    .s data=$p(listData,rowDelim,i)
    .s rowid=$p(data,"^",1)
    .s code=$p(data,"^",2)
    .s desc=$p(data,"^",3)
    .s chkRet=..CheckExist(rowid, code, desc, hosp)
    .i chkRet'="" s err=chkRet q
    .i rowid'=""  d
    ..s ret=..Update(rowid,code,desc)
    ..s:ret'=0 err=ret //_","_desc
    .e  d
    ..s ret=..Insert(code,desc)
    ..i +ret<=0 s err=ret //_","_desc
    ..e  d ##class(PHA.FACE.IN.Com).SaveBasicDataHosp(..#TableName, ret, hosp)
    q err
}

/// Descript:   增加分类信息
/// Creater:    ZhangDongmei
/// CreateDate: 2012-05-15
/// Table:APC_VendCat
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
    ;
    s err=""
    s type=..sssCode()
    &sql(Insert into APC_VendCat(APCVC_Code,APCVC_Desc,APCVC_StkType) values(:code,:desc,:type))
    i SQLCODE'=0  d
    .s rett=$$ErrorRecord^DHCSTERROR("Insert:APC_VendCat",code,SQLCODE_":"_%msg)
    q:SQLCODE'=0 -3
    q $p(%ROWID,$c(1))
}

/// Descript:   更新分类信息
/// Creater:    ZhangDongmei
/// CreateDate: 2012-05-15
/// Table:APC_VendCat
/// Input:rowid^代码^描述
/// Output:     
/// Return：0,成功
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
    &sql(Update APC_VendCat set APCVC_Code=:code,APCVC_Desc=:desc,APCVC_StkType=:type
    where APCVC_Rowid=:rowid)
    i SQLCODE'=0  d
    .s rett=$$ErrorRecord^DHCSTERROR("Update:APC_VendCat",code,SQLCODE_":"_%msg)
    //q SQLCODE
    q Err
}

/// Descript:   删除分类信息
/// Creater:    ZhangDongmei
/// CreateDate: 2012-05-15
/// Table:APC_VendCat
/// Input:rowid
/// Output:     
/// Return：0 – 成功，非0 ：失败,-1：该分类已经在供应商定义中使用，不允许删除
ClassMethod Delete(rowid As %String, hosp) As %Library.String
{
    n (rowid,hosp)
    ;
    ;不能为空项
    q:rowid="" ""
    &sql(select count(*) into :count from apc_vendor where APCVM_Category_DR=:rowid)
    q:count>0 -1
    ;
    &sql(Delete from APC_VendCat where APCVC_Rowid=:rowid)
    i SQLCODE'=0  d
    .s rett=$$ErrorRecord^DHCSTERROR("Delete:APC_VendCat",rowid,SQLCODE_":"_%msg)
    e  d
    .d ##class(PHA.FACE.IN.Com).DeleteBasicDataHosp(..#TableName,rowid,hosp)
    q SQLCODE
}

/// Descript:   查询分类信息
/// Creater:    ZhangDongmei
/// CreateDate: 2012-05-15
/// Table:APC_VendCat
/// Input:
/// Output:     
/// Return：分类信息
ClassMethod SelectAll(hosp)
{
	n (hosp)
    //q:type="" ""
    s result = ##class(%Library.ResultSet).%New()
    s sqlStr = "SELECT APCVC_Code,APCVC_Desc,APCVC_RowId  FROM APC_VendCat where APCVC_StkType='G' or APCVC_StkType IS NULL"
    d result.Prepare(sqlStr)
    d result.Execute()
    ;
    s count = 0
    s resultString = ""
    s json = ##class(Code.JsonObj).%New()
    While(result.Next())
    {   
        s Rowid = result.Data("APCVC_RowId")
        continue:##class(PHA.FACE.IN.Com).GetShowDataFlag(..#TableName,Rowid,hosp)="N"
        s Code = result.Data("APCVC_Code")
        s Description = result.Data("APCVC_Desc")
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
	s sqlStr="SELECT APCVC_RowId AS rowID FROM APC_VendCat WHERE APCVC_StkType='"_type_"'"
	i rowId="" d
	.s newSqlStr=sqlStr_" AND APCVC_Code='"_code_"'"
	.s existFlag=##class(PHA.COM.Method).IsSQLDataExist(newSqlStr,..#TableName,hosp)
  	.i existFlag'="" s errCode=-1
	.s newSqlStr=sqlStr_" AND APCVC_Desc='"_desc_"'"
	.s existFlag=##class(PHA.COM.Method).IsSQLDataExist(newSqlStr,..#TableName,hosp)
  	.i existFlag'="" s errCode=-2
	e  d
	.s newSqlStr=sqlStr_" AND APCVC_Code='"_code_"'"_" AND APCVC_RowId!='"_rowId_"'"
	.s existFlag=##class(PHA.COM.Method).IsSQLDataExist(newSqlStr,..#TableName,hosp)
  	.i existFlag'="" s errCode=-1
	.s newSqlStr=sqlStr_" AND APCVC_Desc='"_desc_"'"_" AND APCVC_RowId!='"_rowId_"'"
	.s existFlag=##class(PHA.COM.Method).IsSQLDataExist(newSqlStr,..#TableName,hosp)
  	.i existFlag'="" s errCode=-2
	q errCode
}

}
