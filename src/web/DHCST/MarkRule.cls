Import sqluser

/// Descript:定价规则维护
/// Creater:    ZhangDongmei
/// CreateDate: 2012-05-29
Class web.DHCST.MarkRule Extends (%RegisteredObject, StkTypeG) [ Not ProcedureBlock ]
{

Parameter AppTable [ Final ] = "DHC_MarkRule";

/// Descript:   保存/更新定价规则信息
/// Creater:    ZhangDongmei
/// CreateDate: 2012-05-29
/// Table:DHC_MarkRule
/// Input:数据串:rowid^代码^描述^规则上限^规则下限^加成率^定价类型^备注^是否使用^最高加成额
/// ^最高加成率^加成额^小数规则,rowid^代码^描述^规则上限^规则下限^加成率^定价类型^备注
/// ^是否使用^最高加成额^最高加成率^加成额^小数规则
/// Output:     
/// Return："" – 成功，
/// 非空：失败
/// w ##class(web.DHCST.MarkRule).Save("^1^2^^^^7^^Y^^^^5",2)
ClassMethod Save(listData As %String, HospId = "") As %Library.String
{
    n (listData,HospId)
    s rowDelim=##class(web.DHCST.Common.UtilCommon).RowDataDelim()
    s len=$l(listData,rowDelim)
    ;s msg=0
    s err=""
    f i=1:1:len  d
    .s data=$p(listData,rowDelim,i)
    .s rowid=$p(data,"^",1)
    .s code=$p(data,"^",2)
    .s desc=$p(data,"^",3)
    .q:code=""
    .q:desc=""
    .s DataStr=$p(data,"^",2,$l(data,"^"))   ;去掉rowid
    .s tmpid=..CodeToID(code,HospId)
    .s:(tmpid'="")&(tmpid'=rowid) msg=-1
    .s tmpid=..DescToID(desc,HospId)
    .s:(tmpid'="")&(tmpid'=rowid) msg=-2
    .i rowid'=""  d
    ..s ret=..Update(rowid,DataStr)
    ..s:ret'=0 err=err_","_desc
    .e  d
    ..s ret=..Insert(DataStr,HospId)
    ..s:ret="" err=err_","_desc
    .
    q err
}

/// Descript:   增加定价规则信息
/// Creater:    ZhangDongmei
/// CreateDate: 2012-05-29
/// Table:DHC_MarkRule
/// Input:代码^描述^规则上限^规则下限^加成率^定价类型^备注^是否使用^最高加成额
/// ^最高加成率^加成额^小数规则
/// Output:     
/// Return：rowid
ClassMethod Insert(ListData As %String, HospId = "") As %Library.String [ Private ]
{
    n (ListData,HospId)
    ;
    s Code=$p(ListData,"^",1)
    s Desc=$p(ListData,"^",2)
    s MaxRp=$p(ListData,"^",3)
    s MinRp=$p(ListData,"^",4)
    s Margin=$p(ListData,"^",5)
    s MtDr=$p(ListData,"^",6)
    s Remark=$p(ListData,"^",7)
    s UseFlag=$p(ListData,"^",8)
    s MaxMPrice=$p(ListData,"^",9)
    s MaxMargin=$p(ListData,"^",10)
    s MPrice=$p(ListData,"^",11)
    s MRSDDr=$p(ListData,"^",12)
    ;不能为空项
    q:Code="" ""
    q:Desc="" ""
    ;
    &sql(Insert into DHC_MarkRule(MR_Code,MR_Desc,MR_MinRp,MR_MaxRp,MR_Margin,
    MR_MT_Dr,MR_Remark,MR_UseFlag,MR_MaxMPrice,MR_MPrice,MR_MaxMargin,MR_SD_Dr,MR_Type)
    values(:Code,:Desc,:MinRp,:MaxRp,:Margin,:MtDr,:Remark,:UseFlag,:MaxMPrice,
    :MPrice,:MaxMargin,:MRSDDr,'G'))
    s Err=0
    i SQLCODE'=0  d
    .s rett=$$ErrorRecord^DHCSTERROR("Insert:DHC_MarkRule",Desc,SQLCODE_":"_%msg)
    .s Err=-1
    e  d
    .s Rowid=$p(%ROWID,$c(1))
    .i HospId'="" d ##class(PHA.FACE.IN.Com).SaveBasicDataHosp(..#AppTable,Rowid,HospId)
    q:Err'=0 ""
    q $p(%ROWID,$c(1))
}

/// Descript:   更新定价规则信息
/// Creater:    ZhangDongmei
/// CreateDate: 2012-05-30
/// Table:DHC_MarkRule
/// Input:rowid,代码^描述^规则上限^规则下限^加成率^定价类型^备注^是否使用^最高加成额
/// ^最高加成率^加成额^小数规则
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
    s MtDr=$p(ListData,"^",6)
    s Remark=$p(ListData,"^",7)
    s UseFlag=$p(ListData,"^",8)
    s MaxMPrice=$p(ListData,"^",9)
    s MaxMargin=$p(ListData,"^",10)
    s MPrice=$p(ListData,"^",11)
    s MRSDDr=$p(ListData,"^",12)
    ;不能为空项
    q:Code="" ""
    q:Desc="" ""
    q:Rowid="" ""
    ;
    s Err=0
    &sql(Update DHC_MarkRule set MR_Code=:Code,MR_Desc=:Desc,
    MR_MinRp=:MinRp,MR_MaxRp=:MaxRp,MR_Margin=:Margin,MR_MT_Dr=:MtDr,
    MR_Remark=:Remark,MR_UseFlag=:UseFlag,MR_MaxMPrice=:MaxMPrice,
    MR_MPrice=:MPrice,MR_MaxMargin=:MaxMargin,MR_SD_Dr=:MRSDDr,MR_Type='G' where MR_Rowid=:Rowid)
    i SQLCODE'=0  d
    .s rett=$$ErrorRecord^DHCSTERROR("Update:DHC_MarkRule",Desc,SQLCODE_":"_%msg)
    .s Err=-1
    q Err
}

/// Descript:   删除定价规则信息
/// Creater:    ZhangDongmei
/// CreateDate: 2012-05-30
/// Table:DHC_MarkRule
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
    &sql(Delete from DHC_MarkRule where MR_Rowid=:rowid)
    i SQLCODE'=0  d
    .s rett=$$ErrorRecord^DHCSTERROR("Delete:DHC_MarkRule",rowid,SQLCODE_":"_%msg)
    .s Err=-1
    e  d
    .i HospId'="" d ##class(PHA.FACE.IN.Com).DeleteBasicDataHosp(..#AppTable,rowid,HospId)
    q Err
}

/// Descript:   查询定价规则信息
/// Creater:    ZhangDongmei
/// CreateDate: 2012-05-30
/// Table:DHC_MarkRule
/// Input:
/// Output: RowId^代码^描述^规则下限^规则上限^加成率^定价类型id^定价类型描述
/// ^备注^是否使用^最大加成额^加成额^最大加成率^小数规则id^小数规则描述  
/// Return：定价规则信息
/// w ##class(web.DHCST.MarkRule).SelectAll(2)
ClassMethod SelectAll(HospId = "")
{
    n (HospId)
    s result = ##class(%Library.ResultSet).%New()
    s sqlStr = "SELECT MR_Rowid as Rowid,MR_Code,MR_Desc,MR_MinRp,MR_MaxRp,"_  
    "MR_Margin,MR_MT_Dr,MR_Remark,MR_UseFlag,MR_MaxMPrice,MR_MPrice,MR_MaxMargin,"_
    "MR_SD_Dr FROM DHC_MarkRule where MR_Type='G'"
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
        s Code = result.Data("MR_Code")
        s Desc = result.Data("MR_Desc")
        s MinRp = result.Data("MR_MinRp")
        s MaxRp = result.Data("MR_MaxRp")
        s Margin = result.Data("MR_Margin")
        s MtDr = +result.Data("MR_MT_Dr")               //定价类型
        s:MtDr'=0 MtDesc=$p($g(^DHCINMT(MtDr)),"^",2)       //定价类型描述
        s Remark = result.Data("MR_Remark")
        s UseFlag = result.Data("MR_UseFlag")
        s MaxMPrice = result.Data("MR_MaxMPrice")
        s MPrice = result.Data("MR_MPrice")
        s MaxMargin = result.Data("MR_MaxMargin")
        s SdDr = +result.Data("MR_SD_Dr")               //小数规则
        s:SdDr'=0 SdDesc=$p($g(^DHCSD(SdDr)),"^",2)     //小数规则描述
        s MinRp=##class(web.DHCST.Common.UtilCommon).AddZero(MinRp)
        s MaxRp=##class(web.DHCST.Common.UtilCommon).AddZero(MaxRp)
        s Margin=##class(web.DHCST.Common.UtilCommon).AddZero(Margin)
        s MaxMPrice=##class(web.DHCST.Common.UtilCommon).AddZero(MaxMPrice)
        s MPrice=##class(web.DHCST.Common.UtilCommon).AddZero(MPrice)
        s MaxMargin=##class(web.DHCST.Common.UtilCommon).AddZero(MaxMargin)
        s Data1=Rowid_"^"_Code_"^"_Desc_"^"_MinRp_"^"_MaxRp_"^"_Margin_"^"_MtDr_"^"_$g(MtDesc)
        s Data2=$g(Remark)_"^"_UseFlag_"^"_MaxMPrice_"^"_MPrice_"^"_MaxMargin_"^"_SdDr_"^"_$g(SdDesc)
        s tmp=Data1_"^"_Data2
        s count = count+1   
        
        d json.InsertRowData(tmp)
    }
    d result.Close()
    s resultString = json.getJsonData("RowId^Code^Desc^MinRp^MaxRp^Margin^MtDr^MtDesc^Remark^UseFlag^MaxMPrice^MPrice^MaxMargin^SdDr^SdDesc",count)
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
