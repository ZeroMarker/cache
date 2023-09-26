Import sqluser

/// Descript:产地信息相关
/// Creater:    MYQ
/// CreateDate: 2014-07-21
Class web.DHCST.DHCOrigin Extends (%RegisteredObject, StkTypeG) [ Not ProcedureBlock ]
{

Parameter TableName [ Final ] = "DHC_STOrigin";

/// Descript:   保存/更新配送商信息
/// Creater:    ZhangDongmei
/// CreateDate: 2012-05-15
/// Table:DHC_Carrier
/// Input:rowid^代码^描述,rowid^代码^描述
/// Output:     
/// Return：""：成功，非空：保存失败，请检查代码和描述是否重复
ClassMethod Save(listData As %String, hosp) As %Library.String
{
    n (listData,%session,hosp)
    s rowDelim=##class(web.DHCST.Common.UtilCommon).RowDataDelim()
    s len=$l(listData,rowDelim)
    s err=""
    f i=1:1:len  q:err'=""  d
    .s data=$p(listData,rowDelim,i)
    .s rowid=$p(data,"^",1)
    .s code=$p(data,"^",2)
    .s desc=$p(data,"^",3)
    .s type=$p(data,"^",4)
    .s alias=$p(data,"^",5)
    .s hospId=$p(data,"^",6)
    .s tmpid=..CheckCode(code,hosp)
 	.i (tmpid'="")&(tmpid'=rowid)  s err="-1^代码重复:"_code
 	.s tmpid=..CheckDesc(desc,hosp) 
 	.i (tmpid'="")&(tmpid'=rowid)  s err="-1^名称重复:"_desc
 	.q:err'=""
    .i rowid'=""  d
    ..s ret=..Update(rowid,code,desc,type,alias,hospId)
    ..s:ret'=0 err=err_","_desc
    .e  d
    ..s ret=..Insert(code,desc,type,alias,hospId)
    ..i ret'="" d ##class(PHA.FACE.IN.Com).SaveBasicDataHosp(..#TableName, ret, hosp) 
    ..s:ret="" err=err_","_desc
    .
    q err
}

/// Descript:   增加产地信息
/// Creater:    MYQ
/// CreateDate: 2014-07-21
/// Table:DHC_Origin
/// Input:代码,描述
/// Output:     
/// Return：rowid
ClassMethod Insert(code As %String, desc As %String, type As %String, alias As %String, hospId As %String) As %Library.String [ Private ]
{
    n (code,desc,type,alias,hospId,%session)
    q:code="" ""
    q:desc="" ""
    &sql(Insert into DHC_STOrigin(Orig_Code,Orig_Name,Orig_Type,Orig_Alias,Orig_Hosp_Dr)
    values(:code,:desc,:type,:alias,:hospId))
    i SQLCODE'=0  d
    .d ErrorRecord^DHCSTERROR("Insert:DHC_STOrigin",code,SQLCODE_":"_%msg)
    q:SQLCODE'=0 ""
    s AppName="DHCSTCOMMON"
    s RecordTrace=##class(web.DHCST.Common.AppCommon).GetAppPropValue(AppName,"RecordTraceFlag","")
    i RecordTrace="Y" d
    .s JsonStr=##class(web.DHCST.Common.JsonObj).GetValue("DHC_STOrigin",$SYSTEM.SQL.GetROWID())
    .d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLogForOther("DHC_STOrigin","User.DHCSTOrigin","产地信息",$SYSTEM.SQL.GetROWID(),desc,"A",JsonStr)
    q $p(%ROWID,$c(1))
}

/// Descript:   更新产地信息
/// Creater:    MYQ
/// CreateDate: 2014-07-21
/// Table:DHC_Origin
/// Input:rowid^代码^描述
/// Output:     
/// Return：0,成功,
ClassMethod Update(rowid As %String, code As %String, desc As %String, type As %String, alias As %String, hospId As %String) As %Library.String [ Private ]
{
    n (rowid,code,desc,type,alias,hospId)
    q:code="" ""
    q:desc="" ""
    q:rowid="" ""
	s OldJsonStr=##class(web.DHCST.Common.JsonObj).GetValue("DHC_STOrigin",rowid)
    &sql(Update DHC_STOrigin set Orig_Code=:code,Orig_Name=:desc,Orig_Type=:type,Orig_Alias=:alias,Orig_Hosp_Dr=:hospId
    where Orig_Rowid=:rowid)
    i SQLCODE'=0  d
    .d ErrorRecord^DHCSTERROR("Update:DHC_STOrigin",code,SQLCODE_":"_%msg)
    q:SQLCODE'=0 SQLCODE
    s AppName="DHCSTCOMMON"
    s RecordTrace=##class(web.DHCST.Common.AppCommon).GetAppPropValue(AppName,"RecordTraceFlag","")
    i RecordTrace="Y" d
    .s JsonStr=##class(web.DHCST.Common.JsonObj).GetValue("DHC_STOrigin",rowid)
    .d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLogForOther("DHC_STOrigin","User.DHCSTOrigin","产地信息",rowid,desc,"U",JsonStr,OldJsonStr)
    q SQLCODE
}

/// Descript:   删除信息
/// Creater:    MYQ
/// CreateDate: 2014-07-21
/// Table:DHC_Origin
/// Input:rowid
/// Output:     
/// Return：0 – 成功，非0 ：失败, -1:配送商在药品定义里使用过，不能删除
ClassMethod Delete(rowid As %String, hosp) As %Library.String
{
    n (rowid,hosp)
    q:rowid="" ""
    // &sql(select count(*) into :count from dhc_ingdrecitm where INGRI_Origin_DR=:rowid)
    // q:count>0 -1
    &sql(Delete from DHC_STOrigin where Orig_RowId=:rowid)
    i SQLCODE'=0  d
    .d ErrorRecord^DHCSTERROR("Delete:DHC_STOrigin",rowid,SQLCODE_":"_%msg)
    e  d
    .d ##class(PHA.FACE.IN.Com).DeleteBasicDataHosp(..#TableName,rowid,hosp)
    q SQLCODE
}

/// Descript:   查询产地信息
/// Creater:    MYQ
/// CreateDate: 2014-07-21
/// Table:DHC_Origin
/// Input:
/// Output:     
/// Return：产地信息
/// w ##class(web.DHCST.DHCOrigin).Query("0","35","RowId","desc","0001","","G")
ClassMethod Query(Start As %Integer, Limit As %Integer, Sort As %String, Dir As %String, Code As %String, Desc As %String, Type As %String, Alias As %String, HospId As %String, Hosp) As %String
{
    n (Code,Desc,Start,Limit,Sort,Dir,Type,Alias,HospId,Hosp)
    s $zt="ErrorQuery"
    s:Type="" Type=..sssCode()
    s count = 0
    s resultString = ""
    s StrSql="select Orig_RowId,Orig_Code,Orig_Name,Orig_Type,Orig_Alias,Orig_Hosp_Dr"_
    " from DHC_STOrigin where Orig_Type='"_Type_"'"
    s OrderField="Orig_RowId"
    i Desc'="" s StrSql=StrSql_" and Orig_Name like '%"_Desc_"%'"
    i Code'="" s StrSql=StrSql_" and Orig_Code like '%"_Code_"%'"
    i Alias'="" s StrSql=StrSql_" and Orig_Alias like '%"_Alias_"%'"
    i HospId'="" s StrSql=StrSql_" and Orig_Hosp_Dr= "_HospId
    s:Sort="Code" OrderField="Orig_Code"
    s:Sort="Desc" OrderField="Orig_Name"
    s:Sort="Alias" OrderField="Orig_Alias"
    s Dir=$$ALPHAUP^SSUTIL4(Dir)
    s:(Dir="")&(Dir'="ASC")&(Dir'="DESC") Dir="DESC"
    i OrderField'=""  d
    .s StrSql=StrSql_" order by "_OrderField_" "_Dir
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
        s Rowid = result.Data("Orig_RowId")
        continue:##class(PHA.FACE.IN.Com).GetShowDataFlag(..#TableName,Rowid,Hosp)="N"
        s Code = result.Data("Orig_Code")
        s Desc = result.Data("Orig_Name")
        s Type = result.Data("Orig_Type")
        s Alias = result.Data("Orig_Alias")
        s HospId=result.Data("Orig_Hosp_Dr")
        s HospDesc=$s(HospId'="":$p($g(^CT("HOSP",HospId)),"^",2),1:"")
        s Data=Rowid_"^"_Code_"^"_Desc_"^"_Type_"^"_Alias_"^"_HospId_"^"_HospDesc
        s count = count+1   
        CONTINUE:count<(Start+1)
        CONTINUE:count>end  
        d json.InsertRowData(Data)
    }
    d result.Close()
    s resultString = json.getJsonData("RowId^Code^Desc^Type^Alias^HospId^HospDesc",count)
    k json
    Q resultString
ErrorQuery
	s Error=$$Error^DHCSTERROR()
	q "{Error:'"_Error_"'}"
}

/// 验证是否有此产地代码
ClassMethod CheckCode(Code As %String, Hosp) As %String
{
 n (Code,Hosp)
 q:Code="" ""
 s type=..sssCode()
 s rowid=""
 s sqlStr="SELECT Orig_RowId AS rowID FROM DHC_STOrigin WHERE Orig_Code='"_Code_"'"_" AND Orig_Type='"_type_"'"
 q ##class(PHA.COM.Method).IsSQLDataExist(sqlStr,..#TableName,Hosp)
}

/// 验证是否有此产地名称
ClassMethod CheckDesc(Desc As %String, Hosp) As %String
{
 n (Desc,Hosp)
 q:Desc="" ""
 s type=..sssCode()
 s rowid=""
 s sqlStr="SELECT Orig_RowId AS rowID FROM DHC_STOrigin WHERE Orig_Name='"_Desc_"'"_" AND Orig_Type='"_type_"'"
 q ##class(PHA.COM.Method).IsSQLDataExist(sqlStr,..#TableName,Hosp)
}

}
