Import sqluser

/// Descript:应用程序维护相关
/// Creater:    LiMingzhong
/// CreateDate: 2012-06-6
Class web.DHCST.DHCStkSysApp Extends (%RegisteredObject, StkTypeG) [ Not ProcedureBlock ]
{

/// Descript:   保存/更新应用程序
/// Creater:    ZhangDongmei
/// CreateDate: 2012-06-05
/// Table:DHC_StkSysApp
/// Input:数据串:rowid^代码^描述^程序类型(B,Q,S,M),rowid^代码^描述^程序类型
/// Output:     
/// Return：>0 : 成功，其他：失败
/// Other: w ##class(web.DHCST.DHCStkSysApp).Save("^aaa^aaa^B")
ClassMethod Save(listData As %String) As %Library.String
{
    n (listData)
    ;s ^zdm("cs")=listData
    s rowDelim=##class(web.DHCST.Common.UtilCommon).RowDataDelim()
    s len=$l(listData,rowDelim)
    f i=1:1:len q:$g(ret)<0  d
    .s data=$p(listData,rowDelim,i)
    .s rowid=$p(data,"^",1)
    .s code=$p(data,"^",2)
    .s desc=$p(data,"^",3)
    .s ModuType=$p(data,"^",4)
    .i rowid'=""  d
    ..s ret=..Update(rowid,code,desc,ModuType)
    .e  d
    ..s ret=..Insert(code,desc,ModuType)

    q +ret
}

/// Descript:   应用系统管理
/// Creater:    LiMingzhong
/// CreateDate: 2012-6-6
/// Table:DHC_StkSysApp
/// Input:代码,描述,模块类别
/// Output:     
/// Return：rowid 成功; -1 代码重复, -2 名称重复, -3 insert失败
ClassMethod Insert(code As %String, desc As %String, type As %String) As %Library.String
{
    n (code,desc,type)
    ;
    ;不能为空项
    q:code="" -10
    q:desc="" -10
    q:type="" -10
    q:$d(^DHCSSA(0,"ACODE",$$ALPHAUP^SSUTIL4(code))) -1
    q:$d(^DHCSSA(0,"ADESC",$$ALPHAUP^SSUTIL4(desc))) -2
    s gType=..sssCode()
    s err=0
    &sql(Insert into DHC_StkSysApp(SSA_Code,SSA_Desc,SSA_GrpType,SSA_ModuType) values(:code,:desc,:gType,:type))
    
    i SQLCODE'=0  d
    .s rett=$$ErrorRecord^DHCSTERROR("Insert:DHC_StkSysApp",code,SQLCODE_":"_%msg)
    .s err=-3
    q:err'=0 err
    q $p(%ROWID,$c(1))
}

/// Descript:   应用系统管理
/// Creater:    LiMingzhong
/// CreateDate: 2012-6-6
/// Table:DHC_StkSysApp
/// Input:rowid^代码^描述
/// Output:     
/// Return：rowid 成功; -1 代码重复, -2 名称重复, -3 update失败
ClassMethod Update(rowid As %String, code As %String, desc As %String, type As %String) As %Library.String [ Private ]
{
    n (rowid,code,desc,type)
    
    ;不能为空项
    q:code="" -10
    q:desc="" -10
    q:type="" -10
    q:rowid="" -10
    s tmpid=$o(^DHCSSA(0,"ACODE",$$ALPHAUP^SSUTIL4(code),""))
    q:(tmpid'="")&(tmpid'=rowid) -1
    s tmpid=$o(^DHCSSA(0,"ADESC",$$ALPHAUP^SSUTIL4(desc),"")) 
    q:(tmpid'="")&(tmpid'=rowid) -2
    s Err=0
    &sql(Update DHC_StkSysApp set SSA_Code=:code,SSA_Desc=:desc,SSA_ModuType=:type where SSA_RowID=:rowid)
    i SQLCODE'=0  d
    .s rett=$$ErrorRecord^DHCSTERROR("Update:DHC_StkSysApp",rowid,SQLCODE_":"_%msg)
    .s Err=-3
    q:Err'=0 Err
    q rowid
}

/// Descript:   应用系统管理
/// Creater:    LiMingzhong
/// CreateDate: 2012-06-6
/// Table:DHC_StkSysApp
/// Input:rowid
/// Output:     
/// Return：0 – 成功，非0 ：失败
ClassMethod Delete(rowid As %String) As %Library.String
{
    n (rowid)
    
    ;不能为空项
    q:rowid="" ""
    
    &sql(Delete from DHC_StkSysApp where SSA_RowID=:rowid)
    i SQLCODE'=0  d
    .s rett=$$ErrorRecord^DHCSTERROR("Delete:DHC_StkSysApp",rowid,SQLCODE_":"_%msg)
    q SQLCODE
}

/// Descript:   查询应用系统管理
/// Creater:    LiMingzhong
/// CreateDate: 2012-6-6
/// Table:DHC_StkSysApp
/// Input:
/// Output:     
/// Return：应用系统管理Json字符串
/// Other:w ##class(web.DHCST.DHCStkSysApp).SelectAll()
ClassMethod SelectAll()
{
    s result = ##class(%Library.ResultSet).%New()
    s type=..sssCode()
    s sqlStr = "select SSA_RowID as RowId,SSA_Code as Code,SSA_Desc as Description,SSA_ModuType as ModuType from DHC_StkSysApp where SSA_RowID>0 and SSA_GrpType="_"'"_type_"'"
    d result.Prepare(sqlStr)
    d result.Execute()
    ;
    s count = 0
    s resultString = ""
    s json = ##class(Code.JsonObj).%New()
    While(result.Next())
    {   
        s RowId = result.Data("RowId")
        s Code = result.Data("Code")
        s Desc = result.Data("Description")
        s Type = result.Data("ModuType")
        s tmp=RowId_"^"_Code_"^"_Desc_"^"_Type
        s count = count+1       
        d json.InsertRowData(tmp)
    }
    d result.Close()
    s resultString = json.getJsonData("RowId^Code^Desc^Type",count)
    k json
    Q resultString
}

/// =====================================
/// Descript:   查询应用系统管理
/// Huxt 2020-09-02
/// w ##class(web.DHCST.DHCStkSysApp).HisuiSelectAll()
ClassMethod HisuiSelectAll()
{
    s result = ##class(%Library.ResultSet).%New()
    s type = ..sssCode()
    s sqlStr = "select SSA_RowID as RowId,SSA_Code as Code,SSA_Desc as Description,SSA_ModuType as ModuType from DHC_StkSysApp where SSA_RowID>0 and SSA_GrpType="_"'"_type_"'"
    d result.Prepare(sqlStr)
    d result.Execute()
    s colLen = result.GetColumnCount()
    s total = 0
   	s rows = []
	while (result.%Next()) {
		s oneRow = {}
		f i=1:1:colLen d
        .s outVal = result.GetData(i)
 		.s outKey = result.GetColumnName(i)
 		.d oneRow.%Set(outKey,outVal)
 		d rows.%Push(oneRow)
 		s total = total + 1
    }
    s retJson = {}
    s retJson.rows = rows
    s retJson.total = total
    q retJson.%ToJSON()
}

}
