Import sqluser

/// Descript:出入库类型相关
/// Creater:    ZhangDongmei
/// CreateDate: 2012-05-10
/// LastUpdate: 2015-11-24,yunhaibao,添加出入库方式的默认设置维护
Class web.DHCST.DHCOpType Extends (%RegisteredObject, StkTypeG) [ Not ProcedureBlock ]
{

/// Descript:   保存/更新出入库类型信息
/// Creater:    ZhangDongmei
/// CreateDate: 2012-05-10
/// Table:DHC_OperateType
/// Input:数据串:rowid^代码^描述^类型
/// Output:     
/// Return："" – 成功，非空：失败
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
    .s default=$p(data,"^",5)
    .s DefaultRepeatFalg=..CheckRepeatDefault(rowid, code, desc, type, default, hosp)
    .i DefaultRepeatFalg="Y" s err=err_","_desc_"的""默认""属性重复" q
    .i rowid'=""  d
    ..s ret=..Update(rowid,code,desc,type,default)
    ..s:ret'=0 err=err_","_desc
    .e  d
    ..s ret=..Insert(code,desc,type,default)
    ..i +ret>0 d
    ...d ##class(PHA.FACE.IN.Com).SaveBasicDataHosp("DHC_OperateType", ret, hosp)
    ..s:ret="" err=err_","_desc
    .
    q err
}

/// w ##class(web.DHCST.DHCOpType).CheckRepeatDefault()
ClassMethod CheckRepeatDefault(rowid, code, desc, type, default, hosp)
{
	q:default'="Y" "N"
	s ExistFlag="N"
	s IPTRowId=""
	f  s IPTRowId=$O(^DHCOPTYPE(0,"TYPE",type,IPTRowId)) q:(IPTRowId="")||(ExistFlag="Y")  d
	.q:(rowid'="")&&(rowid=IPTRowId)
	.q:##class(PHA.FACE.IN.Com).GetShowDataFlag("DHC_OperateType",IPTRowId,hosp)="N"
	.s tmpDefaultFlag=$p(^DHCOPTYPE(IPTRowId),"^",4)
	.i tmpDefaultFlag="Y" s ExistFlag="Y" q
	q ExistFlag
}

/// Descript:   增加出入库类型信息
/// Creater:    ZhangDongmei
/// CreateDate: 2012-05-10
/// Table:DHC_OperateType
/// Input:代码,描述,类型
/// Output:     
/// Return：rowid
ClassMethod Insert(code As %String, desc As %String, type As %String, default As %String) As %Library.String [ Private ]
{
    n (code,desc,type,default)
    q:code="" ""
    q:desc="" ""
    &sql(Insert into DHC_OperateType(IPT_Code,IPT_Desc,IPT_Type,IPT_Default)
    values(:code,:desc,:type,:default))
    s Err=0
    i SQLCODE'=0  d
    .s rett=$$ErrorRecord^DHCSTERROR("Insert:DHC_OperateType",desc,SQLCODE_":"_%msg)
    .s Err=-1
    q:Err'=0 ""
    q $p(%ROWID,$c(1))
}

/// Descript:   更新出入库类型信息
/// Creater:    ZhangDongmei
/// CreateDate: 2012-05-10
/// Table:DHC_OperateType
/// Input:rowid^代码^描述^类型
/// Output:     
/// Return：rowid
ClassMethod Update(rowid As %String, code As %String, desc As %String, type As %String, default As %String) As %Library.String [ Private ]
{
    n (rowid,code,desc,type,default)
    ;
    ;不能为空项
    q:code="" ""
    q:desc="" ""
    q:rowid="" ""
    s Err=0
    &sql(Update DHC_OperateType set IPT_Code=:code,IPT_Desc=:desc,IPT_Type=:type,IPT_Default=:default
    where IPT_Rowid=:rowid)
    i SQLCODE'=0  d
    .s Err=SQLCODE
    .s rett=$$ErrorRecord^DHCSTERROR("Update:DHC_OperateType",desc,SQLCODE_":"_%msg)
    .
    q Err
}

/// Descript:   删除出入库类型信息
/// Creater:    ZhangDongmei
/// CreateDate: 2012-05-10
/// Table:DHC_OperateType
/// Input:rowid
/// Output:     
/// Return：0 – 成功，非0 ：失败
ClassMethod Delete(rowid As %String, hosp) As %Library.String
{
    n (rowid,hosp)
    ;
    ;不能为空项
    q:rowid="" ""
    s Err=0
    &sql(Delete from DHC_OperateType where IPT_Rowid=:rowid)
    i SQLCODE'=0  d
    .s Err=SQLCODE
    .s rett=$$ErrorRecord^DHCSTERROR("Delete:DHC_OperateType",rowid,SQLCODE_":"_%msg)
    e  d
    .d ##class(PHA.FACE.IN.Com).DeleteBasicDataHosp("DHC_OperateType",rowid,hosp)
    q Err
}

/// Descript:   查询出入库类型信息
/// Creater:    ZhangDongmei
/// CreateDate: 2012-05-10
/// Table:DHC_OperateType
/// Input:
/// Output:     
/// Return：类组信息
/// w ##class(web.DHCST.DHCOpType).SelectAll()
ClassMethod SelectAll(hosp)
{
    s result = ##class(%Library.ResultSet).%New()
    s sqlStr = "SELECT IPT_Rowid as Rowid,IPT_Code as Code,IPT_Desc as Description,IPT_Type as Type,IPT_Default as DefaultFlag"_  
    " FROM DHC_OperateType where IPT_Type="_"'I'"_" or "_"IPT_Type="_"'O'"
    d result.Prepare(sqlStr)
    d result.Execute()
    s count = 0
    s resultString = ""
    s json = ##class(Code.JsonObj).%New()
    While(result.Next())
    {   
        s Rowid = result.Data("Rowid")
        s Code = result.Data("Code")
        CONTINUE:+Rowid=0
        continue:##class(PHA.FACE.IN.Com).GetShowDataFlag("DHC_OperateType",Rowid,hosp)="N"
        s Description = result.Data("Description")
        s Type = result.Data("Type")
        s Default= result.Data("DefaultFlag")
        s tmp=Rowid_"^"_Code_"^"_Description_"^"_Type_"^"_Default
        s count = count+1       
        d json.InsertRowData(tmp)
    }
    d result.Close()
    s resultString = json.getJsonData("RowId^Code^Desc^Type^Default",count)
    k json
    Q resultString
}

}
