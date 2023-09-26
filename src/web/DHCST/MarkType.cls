Import sqluser

/// Descript:定价类型维护
/// Creater:    ZhangDongmei
/// CreateDate: 2012-05-29
Class web.DHCST.MarkType Extends (%RegisteredObject, StkTypeG) [ Not ProcedureBlock ]
{

Parameter AppTable [ Final ] = "DHC_MarkType";

/// Descript:   保存/更新定价类型信息
/// Creater:    ZhangDongmei
/// CreateDate: 2012-05-29
/// Table:DHC_MarkType
/// Input:数据串:rowid^代码^描述^是否中标^是否使用,rowid^代码^描述^是否中标^是否使用
/// Output:     
/// Return："" – 成功，
/// 非空：失败
ClassMethod Save(listData As %String, HospId = "") As %Library.String
{
    n (listData,HospId)
    ;s ^zdm("cs")=listData
    s rowDelim=##class(web.DHCST.Common.UtilCommon).RowDataDelim()
    s len=$l(listData,rowDelim)
    s msg=0
    s err=""
    f i=1:1:len  q:msg'=0  d
    .s data=$p(listData,rowDelim,i)
    .s rowid=$p(data,"^",1)
    .s code=$p(data,"^",2)
    .s desc=$p(data,"^",3)
    .q:code=""
    .q:desc=""
    .s pbflag=$p(data,"^",4)
    .s useflag=$p(data,"^",5)
    .s tmpid=..CodeToID(code, HospId)
    .s:(tmpid'="")&(tmpid'=rowid) msg=-1
    .s tmpid=..DescToID(desc, HospId)
    .s:(tmpid'="")&(tmpid'=rowid) msg=-2
    .q:msg'=0
    .i rowid'=""  d
    ..s ret=..Update(rowid,code,desc,pbflag,useflag)
    ..s:ret'=0 err=err_","_desc
    .e  d
    ..s ret=..Insert(code,desc,pbflag,useflag,HospId)
    ..s:ret="" err=err_","_desc
    .
    q:msg=-1 msg //code_"重复"
    q:msg=-2 msg //desc_"重复"
    q:msg'=0 msg
    q err
}

/// Descript:   增加定价类型信息
/// Creater:    ZhangDongmei
/// CreateDate: 2012-05-29
/// Table:DHC_MarkType
/// Input:代码,描述,是否中标,是否使用
/// Output:     
/// Return：rowid
ClassMethod Insert(Code As %String, Desc As %String, PbFlag As %String, UseFlag As %String, HospId = "") As %Library.String [ Private ]
{
    n (Code,Desc,PbFlag,UseFlag,HospId,%session)
    ;
    ;不能为空项
    q:Code="" ""
    q:Desc="" ""
    ;
    &sql(Insert into DHC_MarkType(MT_Code,MT_Desc,MT_ZbFlag,MT_UseFlag,MT_Type)
    values(:Code,:Desc,:PbFlag,:UseFlag,'G'))
    s Err=0
    i SQLCODE'=0  d
    .s rett=$$ErrorRecord^DHCSTERROR("Insert:DHC_MarkType",Desc,SQLCODE_":"_%msg)
    .s Err=-1
    e  d
    .s RowID=$p(%ROWID,$c(1))
    .d ##class(PHA.FACE.IN.Com).SaveBasicDataHosp(..#AppTable,RowID,HospId)
    q:Err'=0 ""
    q $p(%ROWID,$c(1))
}

/// Descript:   更新定价类型信息
/// Creater:    ZhangDongmei
/// CreateDate: 2012-05-29
/// Table:DHC_MarkType
/// Input:rowid,代码,描述,是否中标,是否使用
/// Output:     
/// Return：0:成功;非0：失败
ClassMethod Update(Rowid As %String, Code As %String, Desc As %String, PbFlag As %String, UseFlag As %String) As %Library.String [ Private ]
{
    n (Rowid,Code,Desc,PbFlag,UseFlag)
    ;
    ;不能为空项
    q:Code="" ""
    q:Desc="" ""
    q:Rowid="" ""
    ;
    s Err=0
    &sql(Update DHC_MarkType set MT_Code=:Code,MT_Desc=:Desc,
    MT_ZbFlag=:PbFlag,MT_UseFlag=:UseFlag,MT_Type='G' where MT_Rowid=:Rowid)
    i SQLCODE'=0  d
    .s rett=$$ErrorRecord^DHCSTERROR("Update:DHC_MarkType",Desc,SQLCODE_":"_%msg)
    .s Err=-1
    q Err
}

/// Descript:   删除定价类型信息
/// Creater:    ZhangDongmei
/// CreateDate: 2012-05-29
/// Table:DHC_MarkType
/// Input:rowid
/// Output:     
/// Return：0 – 成功，非0 ：失败
ClassMethod Delete(rowid As %String, HospId As %String = "") As %Library.String
{
    n (rowid,HospId)
    ;
    ;不能为空项
    q:rowid="" ""
    ;
    s Err=0
    &sql(Delete from DHC_MarkType where MT_Rowid=:rowid)
    i SQLCODE'=0  d
    .s rett=$$ErrorRecord^DHCSTERROR("Delete:DHC_MarkType",rowid,SQLCODE_":"_%msg)
    .s Err=-1
    e  d 
    .i HospId'="" d ##class(PHA.FACE.IN.Com).DeleteBasicDataHosp(..#AppTable,rowid,HospId)
    q Err
}

/// Descript:   查询定价类型信息
/// Creater:    ZhangDongmei
/// CreateDate: 2012-05-29
/// Table:DHC_MarkType
/// Input:
/// Output:     
/// Return：定价类型信息
ClassMethod SelectAll(HospId = "")
{
	n (HospId)
    s result = ##class(%Library.ResultSet).%New()
    s sqlStr = "SELECT MT_Rowid as Rowid,MT_Code,MT_Desc,MT_ZbFlag,MT_UseFlag"_  
    " FROM DHC_MarkType where MT_Type='G'"
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
        s flag =##class(PHA.FACE.IN.Com).GetShowDataFlag(..#AppTable,Rowid,HospId) //医院级别授权
        continue:flag="N"
        s Code = result.Data("MT_Code")
        s Desc = result.Data("MT_Desc")
        s ZbFlag = result.Data("MT_ZbFlag")
        s UseFlag = result.Data("MT_UseFlag")
        s tmp=Rowid_"^"_Code_"^"_Desc_"^"_ZbFlag_"^"_UseFlag
        s count = count+1       
        d json.InsertRowData(tmp)
    }
    d result.Close()
    s resultString = json.getJsonData("RowId^Code^Desc^ZbFlag^UseFlag",count)
    k json
    Q resultString
}

ClassMethod CodeToID(code, HospId)
{
	n (code,HospId)
	s RetRowID=""
	s code=$$ALPHAUP^SSUTIL4(code)
	s BDPHospAut=##class(PHA.FACE.IN.Com).GetHospAut() //医院级别授权是否开启
	s Rowid=0
	f  s Rowid=$o(^DHCINMT(0,"Code",code,Rowid)) q:(+Rowid=0)||(RetRowID'="")  d
	.s flag="Y"
	.i BDPHospAut="Y" d
	..i HospId="" s flag="N",RetRowID="-1^入参HospId为空"
	..e  s flag =##class(PHA.FACE.IN.Com).GetShowDataFlag(..#AppTable,Rowid,HospId) //医院级别授权
	.q:flag="N"
	.s RetRowID=Rowid
	q $g(RetRowID)
}

ClassMethod DescToID(desc, HospId)
{
	n (desc,HospId)
	s RetRowID=""
	s desc=$$ALPHAUP^SSUTIL4(desc)
	s BDPHospAut=##class(PHA.FACE.IN.Com).GetHospAut() //医院级别授权是否开启
	s Rowid=0
	f  s Rowid=$o(^DHCINMT(0,"Desc",desc,Rowid)) q:(+Rowid=0)||(RetRowID'="")  d
	.s flag="Y"
	.i BDPHospAut="Y" d
	..i HospId="" s flag="N",RetRowID="-1^入参HospId为空"
	..e  s flag =##class(PHA.FACE.IN.Com).GetShowDataFlag(..#AppTable,Rowid,HospId) //医院级别授权
	.q:flag="N"
	.s RetRowID=Rowid
	q $g(RetRowID)
}

}
