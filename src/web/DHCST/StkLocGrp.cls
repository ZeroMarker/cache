Import sqluser

/// Descript:科室组相关
/// Creater:    ZhangDongmei
/// CreateDate: 2012-05-22
Class web.DHCST.StkLocGrp Extends (%RegisteredObject, StkTypeG) [ Not ProcedureBlock ]
{

Parameter AppTable [ Final ] = "DHC_StkLocGroup";

/// Descript:   保存/更新科室组信息
/// Creater:    ZhangDongmei
/// CreateDate: 2012-05-22
/// Table:DHC_StkLocGroup
/// Input:rowid^代码^描述^类型,rowid^代码^描述^类型
/// Output:     
/// Return：""：成功，非空：保存失败，请检查代码和描述是否重复
/// w ##class(web.DHCST.StkLocGrp).Save("^123^123^G")
ClassMethod Save(listData As %String, HospId = "") As %Library.String
{
    n (listData,HospId)
    //s ^zdm("cs")=listData
    s rowDelim=##class(web.DHCST.Common.UtilCommon).RowDataDelim()
    s len=$l(listData,rowDelim)
    s err=""
    s apptype="DHCSTCOMMON"
    f i=1:1:len  d
    .s data=$p(listData,rowDelim,i)
    .s rowid=$p(data,"^",1)
    .s code=$p(data,"^",2)
    .s desc=$p(data,"^",3)
    .s type=$p(data,"^",4)
    .s ret=..CheckExist(rowid, code, desc,apptype, HospId)
    .s:ret'="" err=ret
    .q:err'=""
    .i rowid'=""  d
    ..s ret=..Update(rowid,code,desc,type,apptype,HospId)
    ..s:ret'="" err=ret
    .e  d
    ..s ret=..Insert(code,desc,type,apptype,HospId)
    ..s:ret'="" err=ret
    .
    q err
}

/// Descript:   增加科室组信息
/// Creater:    ZhangDongmei
/// CreateDate: 2012-05-22
/// Table:DHC_StkLocGroup
/// Input:代码,描述，类型
/// Output:     
/// Return：rowid
ClassMethod Insert(code As %String, desc As %String, type As %String, apptype As %String, HospId = "") As %Library.String [ Private ]
{
    n (code,desc,type,apptype,HospId)
    ;
    ;不能为空项
    q:code="" ""
    q:desc="" ""
    s err=""
    &sql(Insert into DHC_StkLocGroup(SLG_Code,SLG_Desc,SLG_Type,SLG_AppType)
    values(:code,:desc,:type,:apptype))
    i SQLCODE'=0  d
    .s rett=$$ErrorRecord^DHCSTERROR("Insert:DHC_StkLocGroup",code,SQLCODE_":"_%msg)
    .s err=-1
    e  d
    .s Rowid=$p(%ROWID,$c(1))
    .i HospId'="" d ##class(PHA.FACE.IN.Com).SaveBasicDataHosp(..#AppTable,Rowid,HospId)
    q err
}

/// Descript:   更新科室组信息
/// Creater:    ZhangDongmei
/// CreateDate: 2012-05-22
/// Table:DHC_StkLocGroup
/// Input:rowid^代码^描述^类型
/// Output:     
/// Return：0,成功,
ClassMethod Update(rowid As %String, code As %String, desc As %String, type As %String, apptype As %String, HospId = "") As %Library.String [ Private ]
{
    n (rowid,code,desc,type,apptype,HospId)
    ;
    ;不能为空项
    q:code="" ""
    q:desc="" ""
    q:rowid="" ""
    ;
    s Err=""
    &sql(Update DHC_StkLocGroup set SLG_Code=:code,SLG_Desc=:desc,SLG_Type=:type,SLG_AppType=:apptype
    where SLG_Rowid=:rowid)
    i SQLCODE'=0  d
    .s rett=$$ErrorRecord^DHCSTERROR("Update:DHC_StkLocGroup",code,SQLCODE_":"_%msg)
    .s Err=-3
    q Err
}

/// Descript:   删除信息
/// Creater:    ZhangDongmei
/// CreateDate: 2012-05-22
/// Table:DHC_StkLocGroup
/// Input:rowid
/// Output:     
/// Return：0 – 成功，非0 ：失败,
ClassMethod Delete(rowid As %String, HospId = "") As %Library.String
{
    n (rowid,HospId)
    q:rowid="" ""
    s Err=0
    q:$d(^DHCLOC(0,"SLG",rowid)) -2
    &sql(Delete from DHC_StkLocGroup where SLG_Rowid=:rowid)
    i SQLCODE'=0  d
    .s rett=$$ErrorRecord^DHCSTERROR("Delete:DHC_StkLocGroup",rowid,SQLCODE_":"_%msg)
    .s Err=-1
    e  d
    .i HospId'="" d ##class(PHA.FACE.IN.Com).DeleteBasicDataHosp(..#AppTable,rowid,HospId)
    q Err
}

/// Descript:   查询科室组信息
/// Creater:    ZhangDongmei
/// CreateDate: 2012-05-22
/// Table:DHC_StkLocGroup
/// Input:
/// Output:     
/// Return：科室组信息
ClassMethod Query(Start As %Integer, Limit As %Integer, Sort As %String, Dir As %String, Desc As %String, Code As %String, Type As %String, HospId = "") As %String
{
    n (Desc,Type,Code,Start,Limit,Sort,Dir,HospId)
    ;s ^zdm("Query")=Code_","_Name_","_Start_","_Limit_","_Sort_","_Dir
    s count = 0
    s resultString = ""
    s StrSql="select SLG_RowId,SLG_Code,SLG_Desc,SLG_Type"_
    " from DHC_StkLocGroup where SLG_Desc like '%"_Desc_"%' and SLG_Code like '%"_Code_"%'"
    s OrderField="SLG_RowId"
   
    i Type'=""  d
    .s StrSql=StrSql_" and SLG_Type = '"_Type_"'"
    ;
    s:Sort="Code" OrderField="SLG_Code"
    s:Sort="Desc" OrderField="SLG_Desc"
    s:Sort="Type" OrderField="SLG_Type"
    s Dir=$$ALPHAUP^SSUTIL4(Dir)
    s:(Dir'="ASC")&(Dir'="DESC") Dir="DESC"
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
        s Rowid = result.Data("SLG_RowId")
        s flag =##class(PHA.FACE.IN.Com).GetShowDataFlag(..#AppTable,Rowid,HospId) //医院级别授权
        continue:flag="N"
        s Code = result.Data("SLG_Code")
        s Desc = result.Data("SLG_Desc")
        s Type = result.Data("SLG_Type")
        s LocId = $p(^DHCSLG(Rowid),"^",5)
        CONTINUE:LocId'=""
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

ClassMethod CodeToID(code, HospId, apptype)
{
	n (code,HospId,apptype)
	s RetRowID=""
	s code=$$ALPHAUP^SSUTIL4(code)
	s BDPHospAut=##class(PHA.FACE.IN.Com).GetHospAut() //医院级别授权是否开启
    s Rowid=0
	f  s Rowid=$o(^DHCSLG(0,"Code",apptype,code,Rowid)) q:(+Rowid=0)||(RetRowID'="")  d
	.s flag="Y"
	.i BDPHospAut="Y" d
	..i HospId="" s flag="N",RetRowID="-1^入参HospId为空"
	..e  s flag =##class(PHA.FACE.IN.Com).GetShowDataFlag(..#AppTable,Rowid,HospId) //医院级别授权
	.q:flag="N"
	.s RetRowID=Rowid
	q $g(RetRowID)
}

ClassMethod DescToID(desc, HospId, apptype)
{
	n (desc,HospId,apptype)
	s RetRowID=""
	s desc=$$ALPHAUP^SSUTIL4(desc)
	s BDPHospAut=##class(PHA.FACE.IN.Com).GetHospAut() //医院级别授权是否开启
    s Rowid=0
	f  s Rowid=$o(^DHCSLG(0,"Desc",apptype,desc,Rowid)) q:(+Rowid=0)||(RetRowID'="")  d
	.s flag="Y"
	.i BDPHospAut="Y" d
	..i HospId="" s flag="N",RetRowID="-1^入参HospId为空"
	..e  s flag =##class(PHA.FACE.IN.Com).GetShowDataFlag(..#AppTable,Rowid,HospId) //医院级别授权
	.q:flag="N"
	.s RetRowID=Rowid
	q $g(RetRowID)
}

/// description: 判断代码描述是否重复
/// return:      -1^验证信息
ClassMethod CheckExist(rowId, code, desc, apptype, HospId)
{
 	n (code,desc,rowId,apptype,HospId)
 	s errCode=""
 	s id=..CodeToID(code,HospId,apptype)
 	i (id'="")&&(id'=rowId) s errCode="-1^代码重复"
	s id=..DescToID(desc,HospId,apptype)
 	i (id'="")&&(id'=rowId) s errCode="-1^名称重复"
	q errCode
}

}
