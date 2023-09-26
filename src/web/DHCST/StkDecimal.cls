Import sqluser

/// Descript:小数规则维护
/// Creater:    ZhangDongmei
/// CreateDate: 2012-05-31
Class web.DHCST.StkDecimal Extends (%RegisteredObject, StkTypeG) [ Not ProcedureBlock ]
{

Parameter AppTable [ Final ] = "DHC_StkDecimal";

/// Descript:   保存/更新小数规则信息
/// Creater:    ZhangDongmei
/// CreateDate: 2012-05-31
/// Table:DHC_StkDecimal
/// Input:数据串:rowid^规则名称^规则描述^是否使用,rowid^规则名称^规则描述^是否使用
/// Output:     
/// Return："" – 成功，
/// 非空：失败
/// w ##class(web.DHCST.StkDecimal).Save("^11^11^","2")
ClassMethod Save(listData As %String, HospId = "") As %Library.String
{
    n (listData,HospId)
    s ^YSJTMP("Save")=$LB(listData,HospId)
    s rowDelim=##class(web.DHCST.Common.UtilCommon).RowDataDelim()
    s len=$l(listData,rowDelim)
    TSTART
    s err=""
    f i=1:1:len  d
    .s data=$p(listData,rowDelim,i)
    .s rowid=$p(data,"^",1)
    .s code=$p(data,"^",2)
    .s desc=$p(data,"^",3)
    .q:code=""
    .q:desc=""
    .s useflag=$p(data,"^",4)   ;去掉rowid
    .s tmpid=..CodeToID(code, HospId)
    .i (tmpid'="")&(tmpid'=rowid) s err="代码重复" q
    .s tmpid=..DescToID(desc, HospId)
    .i (tmpid'="")&(tmpid'=rowid) s err="名称重复" q
    .i rowid'=""  d
    ..s ret=..Update(rowid,code,desc,useflag)
    ..s:ret'=0 err=err_","_desc
    .e  d
    ..s ret=..Insert(code,desc,useflag,HospId)
    ..s:ret="" err=err_","_desc
    i err'="" TROLLBACK  q err
    TCOMMIT
    q err
}

/// Descript:   增加小数规则信息
/// Creater:    ZhangDongmei
/// CreateDate: 2012-05-31
/// Table:DHC_StkDecimal
/// Input:名称,描述,是否使用
/// Output:     
/// Return：rowid
ClassMethod Insert(Name As %String, Desc As %String, UseFlag As %String, HospId = "") As %Library.String [ Private ]
{
    n (Name,Desc,UseFlag,HospId)
    ;
    ;不能为空项
    q:Name="" ""
    q:Desc="" ""
    ;
    &sql(Insert into DHC_StkDecimal(SD_Name,SD_Desc,SD_UseFlag,SD_Type)
    values(:Name,:Desc,:UseFlag,'G'))
    s Err=0
    i SQLCODE'=0  d
    .s rett=$$ErrorRecord^DHCSTERROR("Insert:DHC_StkDecimal",Desc,SQLCODE_":"_%msg)
    .s Err=-1
    e  d
    .s Rowid=$p(%ROWID,$c(1))
    .i HospId'="" d ##class(PHA.FACE.IN.Com).SaveBasicDataHosp(..#AppTable,Rowid,HospId)
    q:Err'=0 ""
    q $p(%ROWID,$c(1))
}

/// Descript:   更新小数规则信息
/// Creater:    ZhangDongmei
/// CreateDate: 2012-05-31
/// Table:DHC_StkDecimal
/// Input:rowid,名称,描述,是否使用
/// Output:     
/// Return：0:成功;非0：失败
ClassMethod Update(Rowid As %String, Name As %String, Desc As %String, UseFlag As %String) As %Library.String [ Private ]
{
    n (Rowid,Name,Desc,UseFlag)
    ;
    ;不能为空项
    q:Name="" ""
    q:Desc="" ""
    q:Rowid="" ""
    ;
    s Err=0
    &sql(Update DHC_StkDecimal set SD_Name=:Name,SD_Desc=:Desc,
    SD_UseFlag=:UseFlag,SD_Type='G' where SD_Rowid=:Rowid)
    i SQLCODE'=0  d
    .s rett=$$ErrorRecord^DHCSTERROR("Update:DHC_StkDecimal",Desc,SQLCODE_":"_%msg)
    .s Err=-1
    q Err
}

/// Descript:   删除小数规则信息
/// Creater:    ZhangDongmei
/// CreateDate: 2012-05-31
/// Table:DHC_StkDecimal
/// Input:rowid
/// Output:     
/// Return：0 – 成功，非0 ：失败
ClassMethod Delete(rowid As %String, HospId = "") As %Library.String
{
    n (rowid,HospId)
    ;
    ;不能为空项
    q:rowid="" ""
    ;
    s Err=0
    &sql(Delete from DHC_StkDecimal where SD_Rowid=:rowid)
    i SQLCODE'=0  d
    .s rett=$$ErrorRecord^DHCSTERROR("Delete:DHC_StkDecimal",rowid,SQLCODE_":"_%msg)
    .s Err=-1
    e  d
    .i HospId'="" d ##class(PHA.FACE.IN.Com).DeleteBasicDataHosp(..#AppTable,rowid,HospId)
    q Err
}

/// Descript:   查询小数规则信息
/// Creater:    ZhangDongmei
/// CreateDate: 2012-05-31
/// Table:DHC_StkDecimal
/// Input:
/// Output:     
/// Return：小数规则信息
/// w ##class(web.DHCST.StkDecimal).SelectAll(3)
ClassMethod SelectAll(HospId = "")
{
	n (HospId)
	
    s result = ##class(%Library.ResultSet).%New()
    s sqlStr = "SELECT SD_Rowid as Rowid,SD_Name,SD_Desc,SD_UseFlag"_  
    " FROM DHC_StkDecimal where SD_Type='G'"
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
        //w ..#AppTable_"^"_Rowid_"^"_HospId,!
        continue:flag="N"
        s Name = result.Data("SD_Name")
        s Desc = result.Data("SD_Desc")
        s UseFlag = result.Data("SD_UseFlag")
    
        s tmp=Rowid_"^"_Name_"^"_Desc_"^"_UseFlag
        s count = count+1       
        d json.InsertRowData(tmp)
    }
    d result.Close()
    s resultString = json.getJsonData("RowId^Name^Desc^UseFlag",count)
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
