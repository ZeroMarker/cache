Import sqluser

/// Descript:科室类组人员限定维护
/// Creater:    ZhangDongmei
/// CreateDate: 2012-06-12
Class web.DHCST.StkLocUserCatGrp Extends (%RegisteredObject, StkTypeG) [ Not ProcedureBlock ]
{

/// Descript:   保存/更新人员限定
/// Creater:    ZhangDongmei
/// CreateDate: 2012-06-12
/// Table:DHC_StkLocUserCatGrp
/// Input:科室类组表id;人员id^激活标志^默认标志,人员id^激活标志^默认标志
/// Output:     
/// Return：""：成功，非空：保存失败
ClassMethod Save(LocGrpId As %String, listData) As %Library.String
{
    n (LocGrpId,listData)
    q:LocGrpId="" ""
    s rowDelim=##class(web.DHCST.Common.UtilCommon).RowDataDelim()
    s len=$l(listData,rowDelim)
    s err=""
    s msg=0
    f i=1:1:len q:msg'=0  d
    .s GrpUserInfo=$p(listData,rowDelim,i)
    .s RowId=$p(GrpUserInfo,"^",1)
    .s UserId=$p(GrpUserInfo,"^",2)
    .q:UserId=""
    .s ActiveFlag=$p(GrpUserInfo,"^",3)
    .s DefaultFlag=$p(GrpUserInfo,"^",4)
    .s UserName=$p(GrpUserInfo,"^",5)
    .s tmpName=$p(^SSU("SSUSR",UserId),"^",2)
    .i tmpName=UserName d
    ..s Chl=$o(^DHCSLCG(0,"USER",UserId,LocGrpId,""))
    ..q:Chl=""
    ..q:(RowId=(LocGrpId_"||"_Chl))   //存在不是本条记录的记录则判断为重复，2020-02-21 yangsj
    ..s msg=-1    ;存在
    .q:msg'=0
    .
    .i RowId'="" d
    ..s ret=..Update(RowId,UserId,DefaultFlag,ActiveFlag)
    ..s:ret'=0 err=err_","_tmpName
    .e  d
    ..s ret=..Insert(LocGrpId,UserId,DefaultFlag,ActiveFlag)
    ..s:ret="" err=err_","_tmpName
    .
    q:msg'=0 msg
    q err
}

/// Descript:   增加人员限定
/// Creater:    ZhangDongmei
/// CreateDate: 2012-06-12
/// Table:DHC_StkLocUserCatGrp
/// Input:科室类组表id,人员id,默认标志,激活标志
/// Output:     
/// Return：rowid
ClassMethod Insert(LocGrpId As %String, UserId As %String, DefaultFlag As %String, ActiveFlag As %String) As %Library.String [ Private ]
{
    n (LocGrpId,UserId,DefaultFlag,ActiveFlag)
    ;
    s Chl=1+$o(^DHCSLCG(LocGrpId,"I",""),-1)
    s err=0
    &sql(Insert into DHC_StkLocUserCatGrp(U_SLCG_Parref,U_ChildSub,U_SSUSR_DR,U_Active,U_Default)
    values(:LocGrpId,:Chl,:UserId,:ActiveFlag,:DefaultFlag))
    i SQLCODE'=0  d
    .d ErrorRecord^DHCSTERROR("Insert:DHC_StkLocUserCatGrp",UserId,SQLCODE_":"_%msg)
    .s err=-1
    q:err'=0 ""
    q $p(%ROWID,$c(1))
}

/// Descript:   更新人员限定
/// Creater:    ZhangDongmei
/// CreateDate: 2012-06-12
/// Table:DHC_StkLocUserCatGrp
/// Input:Rowid,默认标志,激活标志
/// Output:     
/// Return：0,成功;
ClassMethod Update(Rowid As %String, UserId As %String, DefaultFlag As %String, ActiveFlag As %String) As %Library.String [ Private ]
{
    n (Rowid,UserId,DefaultFlag,ActiveFlag)
    ;
    ;s ^zdm("web.DHCST.StkLocUserCatGrp.Update")=Rowid
    s err=0
    &sql(Update DHC_StkLocUserCatGrp set U_SSUSR_DR=:UserId,U_Default=:DefaultFlag ,U_Active=:ActiveFlag where U_Rowid=:Rowid)
    i SQLCODE'=0  d
    .d ErrorRecord^DHCSTERROR("Update:DHC_StkLocUserCatGrp",Rowid,SQLCODE_":"_%msg)
    .s err=-1
    q:err'=0 -1
    q 0
}

/// Descript:   查询某科室类组对应的人员信息
/// Creater:    ZhangDongmei
/// CreateDate: 2012-06-12
/// Table:DHC_StkLocUserCatGrp
/// Input:开始行，一页记录数，排序字段，排序方向,科室类组id
/// Output:     
/// Return：Rowid^UserId^人员代码^人员姓名^默认标志^激活状态
/// 
ClassMethod Query(Start As %Integer, Limit As %Integer, Sort As %String, Dir As %String, LocGrpId As %String) As %String
{
    n (LocGrpId,Start,Limit,Sort,Dir)
    ;s ^zdm("Query")=Start_","_Limit_","_Sort_","_Dir_","_StrFilter
    q:LocGrpId="" ""
    s count = 0
    s resultString = ""
    s StrSql="select U_RowId as Rowid,U_SSUSR_DR,U_SSUSR_DR->SSUSR_Initials as Code,"_
    "U_SSUSR_DR->SSUSR_Name as Name,U_Active,U_Default "_
    " from DHC_StkLocUserCatGrp where U_SLCG_Parref='"_LocGrpId_"'"
    s OrderField="Rowid"
    ;
    s:Sort="Code" OrderField="Code"
    s:Sort="Name" OrderField="Name"
    s:Sort="Active" OrderField="U_Active"
    s:Sort="Default" OrderField="U_Default"
    s Dir=$$ALPHAUP^SSUTIL4(Dir)
    s:(Dir'="ASC")&(Dir'="DESC") Dir="DESC"
    i OrderField'=""  d
    .s StrSql=StrSql_" order by "_OrderField_" "_Dir
    ;s ^zdm("Query_sql")=StrSql
    s json = ##class(Code.JsonObj).%New()
    ;b ;11
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
        s Rowid = result.Data("Rowid")
        s UserId = result.Data("U_SSUSR_DR")
        s Code = result.Data("Code")
        s Name = result.Data("Name")
        s Active=result.Data("U_Active")
#;      i Active="Y" d
#;      .s Active="true"
#;      e  d
#;      .s Active="false"
        s Default=result.Data("U_Default")
#;      i Default="Y" d
#;      .s Default="true"
#;      e  d
#;      .s Default="false"
        
        s Data=Rowid_"^"_UserId_"^"_Code_"^"_Name_"^"_Default_"^"_Active
        s count = count+1   
        CONTINUE:count<(Start+1)
        CONTINUE:count>end  
        d json.InsertRowData(Data)
    }
    d result.Close()
    s resultString = json.getJsonData("Rowid^UserId^Code^Name^Default^Active",count)
    k json
    Q resultString
}

/// Descript:   删除某科室类组对应的人员信息
/// Creater:    LiMingzhong
/// CreateDate: 2012-06-15
/// Table:DHC_StkLocUserCatGrp
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
    &sql(Delete from DHC_StkLocUserCatGrp where U_RowId=:rowid)
    i SQLCODE'=0  d
    .d ErrorRecord^DHCSTERROR("Delete:DHC_StkLocUserCatGrp",rowid,SQLCODE_":"_%msg)
    q SQLCODE
}

}
