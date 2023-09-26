Import sqluser

/// Descript:规则累计进差率维护
/// Creater:    ZhangDongmei
/// CreateDate: 2012-05-30
Class web.DHCST.MarkRuleAdd Extends (%RegisteredObject, StkTypeG) [ Not ProcedureBlock ]
{

/// Descript:   保存/更新规则信息
/// Creater:    ZhangDongmei
/// CreateDate: 2012-05-30
/// Table:DHC_MarkRuleAdd
/// Input:数据串:rowid^父表id^代码^描述^上限^下限^加成^备注^是否使用,
/// rowid^父表id^代码^描述^上限^下限^加成^备注^是否使用
/// Output:     
/// Return："" – 成功，
/// 非空：失败
ClassMethod Save(listData As %String) As %Library.String
{
    n (listData)
    ;s ^zdm("cs")=listData
    s rowDelim=##class(web.DHCST.Common.UtilCommon).RowDataDelim()
    s len=$l(listData,rowDelim)
    ;s msg=0
    s err=""
    f i=1:1:len  d
    .s data=$p(listData,rowDelim,i)
    .s rowid=$p(data,"^",1)
    .s parref=$p(data,"^",2)
    .s code=$p(data,"^",3)
    .s desc=$p(data,"^",4)
    .q:code=""
    .q:desc=""
    .q:parref=""
    .s DataStr=$p(data,"^",3,$l(data,"^"))   ;去掉rowid和父表rowid
    .;s tmpid=$o(^DHCINMT(0,"Code",$$ALPHAUP^SSUTIL4(code),""))
    .;s:(tmpid'="")&(tmpid'=rowid) msg=-1
    .;s tmpid=$o(^DHCINMT(0,"Desc",$$ALPHAUP^SSUTIL4(desc),"")) 
    .;s:(tmpid'="")&(tmpid'=rowid) msg=-2
    .i rowid'=""  d
    ..s ret=..Update(rowid,DataStr)
    ..s:ret'=0 err=err_","_desc
    .e  d
    ..s ret=..Insert(parref,DataStr)
    ..s:ret="" err=err_","_desc
    .
    q err
}

/// Descript:   增加累计规则信息
/// Creater:    ZhangDongmei
/// CreateDate: 2012-05-30
/// Table:DHC_MarkRuleAdd
/// Input:父表id,代码^描述^上限^下限^加成^备注^是否使用
/// Output:     
/// Return：rowid
ClassMethod Insert(Parref As %String, ListData As %String) As %Library.String [ Private ]
{
    n (Parref,ListData)
    ;
    s Code=$p(ListData,"^",1)
    s Desc=$p(ListData,"^",2)
    s MaxRp=$p(ListData,"^",3)
    s MinRp=$p(ListData,"^",4)
    s Margin=$p(ListData,"^",5)
    s Remark=$p(ListData,"^",6)
    s UseFlag=$p(ListData,"^",7) 
    ;不能为空项
    q:Parref="" ""
    q:Code="" ""
    q:Desc="" ""
    s Chl=1+$o(^DHCINMRA(Parref,"I",""),-1)
    ;
    &sql(Insert into DHC_MarkRuleAdd(MRA_MR_Parref,MRA_ChildSub,MRA_Code,MRA_Desc,MRA_MinRp,
    MRA_MaxRp,MRA_Margin,MRA_Remark,MRA_UseFlag)
    values(:Parref,:Chl,:Code,:Desc,:MinRp,:MaxRp,:Margin,:Remark,:UseFlag))
    s Err=0
    i SQLCODE'=0  d
    .s rett=$$ErrorRecord^DHCSTERROR("Insert:DHC_MarkRuleAdd",Desc,SQLCODE_":"_%msg)
    .s Err=-1
    q:Err'=0 ""
    q $p(%ROWID,$c(1))
}

/// Descript:   更新累计规则信息
/// Creater:    ZhangDongmei
/// CreateDate: 2012-05-30
/// Table:DHC_MarkRuleAdd
/// Input:rowid,代码^描述^上限^下限^加成^备注^是否使用
/// Output:     
/// Return：0:成功;非0：失败
ClassMethod Update(Rowid As %String, ListData As %String) As %Library.String [ Private ]
{
    n (Rowid,ListData)
    ;
    s Code=$p(ListData,"^",1)
    s Desc=$p(ListData,"^",2)
    s MaxRp=$p(ListData,"^",3)
    s MinRp=$p(ListData,"^",4)
    s Margin=$p(ListData,"^",5)
    s Remark=$p(ListData,"^",6)
    s UseFlag=$p(ListData,"^",7)
    ;不能为空项
    q:Code="" ""
    q:Desc="" ""
    q:Rowid="" ""
    ;
    s Err=0
    &sql(Update DHC_MarkRuleAdd set MRA_Code=:Code,MRA_Desc=:Desc,
    MRA_MinRp=:MinRp,MRA_MaxRp=:MaxRp,MRA_Margin=:Margin,
    MRA_Remark=:Remark,MRA_UseFlag=:UseFlag where MRA_Rowid=:Rowid)
    i SQLCODE'=0  d
    .s rett=$$ErrorRecord^DHCSTERROR("Update:DHC_MarkRuleAdd",Desc,SQLCODE_":"_%msg)
    .s Err=-1
    q Err
}

/// Descript:   删除累计规则信息
/// Creater:    ZhangDongmei
/// CreateDate: 2012-05-30
/// Table:DHC_MarkRuleAdd
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
    &sql(Delete from DHC_MarkRuleAdd where MRA_Rowid=:rowid)
    i SQLCODE'=0  d
    .s rett=$$ErrorRecord^DHCSTERROR("Delete:DHC_MarkRuleAdd",rowid,SQLCODE_":"_%msg)
    .s Err=-1
    q Err
}

/// Descript:   查询某规则的累计规则信息
/// Creater:    ZhangDongmei
/// CreateDate: 2012-05-30
/// Table:DHC_MarkRuleAdd
/// Input:父表id
/// Output: 
/// Return：RowId^代码^描述^下限^上限^加成^备注^是否使用
ClassMethod SelectAll(Parref As %String)
{
    n (Parref)
    s result = ##class(%Library.ResultSet).%New()
    s sqlStr = "SELECT MRA_RowID as Rowid,MRA_Code,MRA_Desc,MRA_MinRp,MRA_MaxRp,"_  
    "MRA_Margin,MRA_Remark,MRA_UseFlag"_
    " FROM DHC_MarkRuleAdd where MRA_MR_Parref="_Parref
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
        s Code = result.Data("MRA_Code")
        s Desc = result.Data("MRA_Desc")
        s MinRp = result.Data("MRA_MinRp")
        s MaxRp = result.Data("MRA_MaxRp")
        s Margin = result.Data("MRA_Margin")
        s Remark = result.Data("MRA_Remark")
        s UseFlag = result.Data("MRA_UseFlag")
    	s MinRp=##class(web.DHCST.Common.UtilCommon).AddZero(MinRp)
    	s MaxRp=##class(web.DHCST.Common.UtilCommon).AddZero(MaxRp)
    	s Margin=##class(web.DHCST.Common.UtilCommon).AddZero(Margin)
        s tmp=Rowid_"^"_Code_"^"_Desc_"^"_MinRp_"^"_MaxRp_"^"_Margin_"^"_Remark_"^"_UseFlag
        s count = count+1       
        d json.InsertRowData(tmp)
    }
    d result.Close()
    s resultString = json.getJsonData("RowId^Code^Desc^MinRp^MaxRp^Margin^Remark^UseFlag",count)
    k json
    Q resultString
}

}
