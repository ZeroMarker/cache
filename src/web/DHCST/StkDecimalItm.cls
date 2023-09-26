Import sqluser

/// Descript:小数规则明细维护
/// Creater:    ZhangDongmei
/// CreateDate: 2012-05-31
Class web.DHCST.StkDecimalItm Extends (%RegisteredObject, StkTypeG) [ Not ProcedureBlock ]
{

/// Descript:   保存/更新小数规则明细信息
/// Creater:    ZhangDongmei
/// CreateDate: 2012-05-31
/// Table:DHC_StkDecimalItm
/// Input:数据串:rowid^父表id^规则下限^规则上限^小数位数,
/// rowid^父表id^规则下限^规则上限^小数位数
/// Output:     
/// Return："" – 成功，
/// 非空：失败
/// w ##class(web.DHCST.StkDecimalItm).Save("11||1^11^10^100^11")
ClassMethod Save(listData As %String) As %Library.String
{
    n (listData)
    //s ^zdm("cs")=listData
    s rowDelim=##class(web.DHCST.Common.UtilCommon).RowDataDelim()
    s len=$l(listData,rowDelim)
    s msg=0
    s err=""
    f i=1:1:len  d
    .s data=$p(listData,rowDelim,i)
    .s rowid=$p(data,"^",1)
    .s parref=$p(data,"^",2)
    .s min=$p(data,"^",3)
    .s max=$p(data,"^",4)
    .s decimallen=$p(data,"^",5)
    .q:parref=""
    .s tmpmin=""
    .s tmpmax=""
    .s tmprowid=""
    .&SQL(SELECT SDI_RowID,SDI_Min, SDI_Max into :tmprowid,:tmpmin,:tmpmax FROM DHC_StkDecimalItm WHERE SDI_SD_Parref=:parref )
    .s:(tmprowid'=rowid)&&(tmpmin'="")&(tmpmin=min)&(tmpmax'="")&(tmpmax=max) msg=-1
    .q:msg'=0
    .i rowid'=""  d
    ..s ret=..Update(rowid,min,max,decimallen)
    ..s:ret'=0 err=err_","_min_"-"_max
    .e  d
    ..s ret=..Insert(parref,min,max,decimallen)
    ..s:ret="" err=err_","_min_"-"_max
    q:msg=-1 msg
    q err
}

/// Descript:   增加小数规则明细信息
/// Creater:    ZhangDongmei
/// CreateDate: 2012-05-31
/// Table:DHC_StkDecimalItm
/// Input:父表id,规则下限,规则上限,小数位数
/// Output:     
/// Return：rowid
ClassMethod Insert(Parref As %String, Min As %String, Max As %String, DecimalLen As %String) As %Library.String [ Private ]
{
    n (Parref,Min,Max,DecimalLen)
    ;
    ;不能为空项
    q:Parref="" ""
    s Chl=1+$o(^DHCSD(Parref,"I",""),-1)
    ;
    &sql(Insert into DHC_StkDecimalItm(SDI_SD_Parref,SDI_Childsub,SDI_Min,SDI_Max,SDI_DecimalLen)
    values(:Parref,:Chl,:Min,:Max,:DecimalLen))
    s Err=0
    i SQLCODE'=0  d
    .s rett=$$ErrorRecord^DHCSTERROR("Insert:DHC_StkDecimalItm",Parref,SQLCODE_":"_%msg)
    .s Err=-1
    q:Err'=0 ""
    q $p(%ROWID,$c(1))
}

/// Descript:   更新小数规则明细信息
/// Creater:    ZhangDongmei
/// CreateDate: 2012-05-31
/// Table:DHC_StkDecimalItm
/// Input:rowid,规则下限,规则上限,小数位数
/// Output:     
/// Return：0:成功;非0：失败
ClassMethod Update(Rowid As %String, Min As %String, Max As %String, DecimalLen As %String) As %Library.String [ Private ]
{
    n (Rowid,Min,Max,DecimalLen)
    ;
    ;不能为空项
    q:Rowid="" ""
    ;
    s Err=0
    &sql(Update DHC_StkDecimalItm set SDI_Min=:Min,SDI_Max=:Max,
    SDI_DecimalLen=:DecimalLen where SDI_Rowid=:Rowid)
    i SQLCODE'=0  d
    .s rett=$$ErrorRecord^DHCSTERROR("Update:DHC_StkDecimalItm",Rowid,SQLCODE_":"_%msg)
    .s Err=-1
    q Err
}

/// Descript:   删除小数规则明细信息
/// Creater:    ZhangDongmei
/// CreateDate: 2012-05-31
/// Table:DHC_StkDecimalItm
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
    &sql(Delete from DHC_StkDecimalItm where SDI_Rowid=:rowid)
    i SQLCODE'=0  d
    .s rett=$$ErrorRecord^DHCSTERROR("Delete:DHC_StkDecimalItm",rowid,SQLCODE_":"_%msg)
    .s Err=-1
    q Err
}

/// Descript:   查询小数规则明细信息
/// Creater:    ZhangDongmei
/// CreateDate: 2012-05-31
/// Table:DHC_StkDecimalItm
/// Input:
/// Output:     
/// Return：小数规则明细信息
ClassMethod SelectAll(Parref As %String)
{
    n (Parref)
    q:Parref="" ""
    s result = ##class(%Library.ResultSet).%New()
    s sqlStr = "SELECT SDI_Rowid as Rowid,SDI_Min,SDI_Max,SDI_DecimalLen"_  
    " FROM DHC_StkDecimalItm where SDI_SD_Parref="_Parref
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
        s Min = result.Data("SDI_Min")
        s Max = result.Data("SDI_Max")
        s DecimalLen = result.Data("SDI_DecimalLen")
        ;
        s tmp=Rowid_"^"_Min_"^"_Max_"^"_DecimalLen
        s count = count+1       
        d json.InsertRowData(tmp)
    }
    d result.Close()
    s resultString = json.getJsonData("RowId^Min^Max^DecimalLen",count)
    k json
    Q resultString
}

}
