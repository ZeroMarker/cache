Import sqluser

/// Descript:配送商信息相关
/// Creater:    ZhangDongmei
/// CreateDate: 2012-05-15
Class web.DHCST.DHCCarrier Extends (%RegisteredObject, StkTypeG) [ Not ProcedureBlock ]
{

Parameter TableName [ Final ] = "DHC_Carrier";

/// Descript:   保存/更新配送商信息
/// Creater:    ZhangDongmei
/// CreateDate: 2012-05-15
/// Table:DHC_Carrier
/// Input:rowid^代码^描述,rowid^代码^描述
/// Output:     
/// Return：""：成功，非空：保存失败，请检查代码和描述是否重复
/// w ##class(web.DHCST.DHCCarrier).Save("^011^测试^G")
ClassMethod Save(listData As %String, hosp) As %Library.String
{
    n (listData,hosp)

    s rowDelim=##class(web.DHCST.Common.UtilCommon).RowDataDelim()
    s len=$l(listData,rowDelim)
    s err=""
    f i=1:1:len  d
    .s data=$p(listData,rowDelim,i)
    .s rowid=$p(data,"^",1)
    .s code=$p(data,"^",2)
    .s desc=$p(data,"^",3)
    .s type=$p(data,"^",4)
    .s chkRet=..CheckExist(rowid, code, desc, hosp)
    .i chkRet'="" s err=chkRet q
    .i rowid'=""  d
    ..s ret=..Update(rowid,code,desc,type)
    ..s:ret'=0 err=ret
    .e  d
    ..s ret=..Insert(code,desc,type)
    ..i +ret>0 d
    ...d ##class(PHA.FACE.IN.Com).SaveBasicDataHosp(..#TableName, ret, hosp)
    ...s ret=""
    ..s:ret'="" err=ret
    .
    q err
}

/// Descript:   增加配送商信息
/// Creater:    ZhangDongmei
/// CreateDate: 2012-05-15
/// Table:DHC_Carrier
/// Input:代码,描述
/// Output:     
/// Return：rowid
ClassMethod Insert(code As %String, desc As %String, type As %String) As %Library.String [ Private ]
{
    n (code,desc,type)
    ;
    ;不能为空项
    q:code="" ""
    q:desc="" ""
    ;
    s err=""
    &sql(Insert into DHC_Carrier(CA_Code,CA_Desc,CA_Type)
    values(:code,:desc,:type))
    i SQLCODE'=0  d
    .d ErrorRecord^DHCSTERROR("Insert:DHC_Carrier",code,SQLCODE_":"_%msg)
    e  s rowID=$p(%ROWID,$c(1))
    q:SQLCODE'=0 -3
    q $g(rowID)
}

/// Descript:   更新配送商信息
/// Creater:    ZhangDongmei
/// CreateDate: 2012-05-15
/// Table:DHC_Carrier
/// Input:rowid^代码^描述
/// Output:     
/// Return：0,成功,
ClassMethod Update(rowid As %String, code As %String, desc As %String, type As %String) As %Library.String [ Private ]
{
    n (rowid,code,desc,type)
    ;
    ;不能为空项
    q:code="" ""
    q:desc="" ""
    q:rowid="" ""
    s Err=""
    &sql(Update DHC_Carrier set CA_Code=:code,CA_Desc=:desc,CA_Type=:type
    where CA_Rowid=:rowid)
    i SQLCODE'=0  d
    .d ErrorRecord^DHCSTERROR("Update:DHC_Carrier",code,SQLCODE_":"_%msg)
    q Err
}

/// Descript:   删除信息
/// Creater:    ZhangDongmei
/// CreateDate: 2012-05-15
/// Table:DHC_Carrier
/// Input:rowid
/// Output:     
/// Return：0 – 成功，非0 ：失败, -1:配送商在药品定义里使用过，不能删除
ClassMethod Delete(rowid As %String, hosp) As %Library.String
{
    n (rowid,hosp)
    ;
    ;不能为空项
    q:rowid="" ""
    &sql(select count(*) into :count from dhc_itmaddioninfo where INFO_PbCarrier_DR=:rowid)
    q:count>0 -1
    ;
    &sql(Delete from DHC_Carrier where CA_Rowid=:rowid)
    i SQLCODE'=0  d
    .d ErrorRecord^DHCSTERROR("Delete:DHC_Carrier",rowid,SQLCODE_":"_%msg)
    e  d
    .d ##class(PHA.FACE.IN.Com).DeleteBasicDataHosp(..#TableName,rowid,hosp)
    q SQLCODE
}

/// Descript:   查询配送商信息
/// Creater:    ZhangDongmei
/// CreateDate: 2012-05-15
/// Table:DHC_Carrier
/// Input:
/// Output:     
/// Return：配送商信息
ClassMethod Query(Start As %Integer, Limit As %Integer, Sort As %String, Dir As %String, Code As %String, Desc As %String, Type As %String, Hosp) As %String
{
    n (Code,Desc,Start,Limit,Sort,Dir,Type,Hosp)
    ;s ^zdm("Query")=Start_","_Limit_","_Sort_","_Dir_","_Code_","_Desc_","_Type
    s:Type="" Type=..sssCode()
    s count = 0
    s resultString = ""
    s StrSql="select CA_Rowid,CA_Code,CA_Desc,CA_Type"_
    " from dhc_carrier where CA_Type='"_Type_"'"
    s OrderField="CA_RowId"
    i Desc'=""  d
    .s StrSql=StrSql_" and CA_Desc like '%"_Desc_"%'"
    i Code'=""  d
    .s StrSql=StrSql_" and CA_Code like '%"_Code_"%'"
    ;
    s:Sort="Code" OrderField="CA_Code"
    s:Sort="Desc" OrderField="CA_Desc"
    s Dir=$$ALPHAUP^SSUTIL4(Dir)
    s:(Dir="")&(Dir'="ASC")&(Dir'="DESC") Dir="DESC"
    i OrderField'=""  d
    .s StrSql=StrSql_" order by "_OrderField_" "_Dir
    ;s ^zdm("Query_sql")=StrSql
    s json = ##class(Code.JsonObj).%New()
    ;
    s result = ##class(%Library.ResultSet).%New()
    d result.Prepare(StrSql)
    s sc=result.Execute()
    s err=$$$ISERR(sc)
    ;
    If err  q ""
    s count = 0
    s resultString = ""
    s end = Start+Limit
    s json = ##class(Code.JsonObj).%New()
    ;
    While(result.Next())
    {   
        s Rowid = result.Data("CA_Rowid")
        continue:##class(PHA.FACE.IN.Com).GetShowDataFlag(..#TableName,Rowid,Hosp)="N"
        s Code = result.Data("CA_Code")
        s Desc = result.Data("CA_Desc")
        s Type=result.Data("CA_Type")
        ;
        s Data=Rowid_"^"_Code_"^"_Desc_"^"_Type
        s count = count+1   
        CONTINUE:count<(Start+1)
        CONTINUE:count>end  
        d json.InsertRowData(Data)
    }
    d result.Close()
    s resultString = json.getJsonData("RowId^Code^Desc^Type",count)
    k json
    Q resultString
}

ClassMethod CheckExist(rowId, code, desc, hosp)
{
	n (code,desc,rowId,hosp)
	s errCode=""
	s type=..sssCode()
	s sqlStr="SELECT CA_Rowid AS rowID FROM DHC_Carrier WHERE CA_Type='"_type_"'"
	i rowId="" d
	.s newSqlStr=sqlStr_" AND CA_Code='"_code_"'"
	.s existFlag=##class(PHA.COM.Method).IsSQLDataExist(newSqlStr,..#TableName,hosp)
  	.i existFlag'="" s errCode=-1
	.s newSqlStr=sqlStr_" AND CA_Desc='"_desc_"'"
	.s existFlag=##class(PHA.COM.Method).IsSQLDataExist(newSqlStr,..#TableName,hosp)
  	.i existFlag'="" s errCode=-2
	e  d
	.s newSqlStr=sqlStr_" AND CA_Code='"_code_"'"_" AND CA_Rowid!='"_rowId_"'"
	.s existFlag=##class(PHA.COM.Method).IsSQLDataExist(newSqlStr,..#TableName,hosp)
  	.i existFlag'="" s errCode=-1
	.s newSqlStr=sqlStr_" AND CA_Desc='"_desc_"'"_" AND CA_Rowid!='"_rowId_"'"
	.s existFlag=##class(PHA.COM.Method).IsSQLDataExist(newSqlStr,..#TableName,hosp)
  	.i existFlag'="" s errCode=-2
	q errCode
}

}
