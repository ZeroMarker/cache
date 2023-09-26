Import sqluser

/// Descript:库存分类维护
/// Creater:    zhangxiao
/// CreateDate: 2013-10-17
Class web.DHCST.StkCat Extends (%RegisteredObject, StkTypeG) [ Not ProcedureBlock ]
{

Parameter AppTable [ Final ] = "INC_StkCat";

/// Descript:   查询库存分类
/// Creater:     zhangxiao
/// CreateDate: 2013-10-16
/// Table:INC_StkCat
/// Input:
/// Output:     
/// Return：科室盘点窗口信息
/// w ##class(web.DHCST.StkCat).SelectAll()
ClassMethod SelectAll(HospId)
{
	n (HospId,%session)
	s result = ##class(%Library.ResultSet).%New()
	s Type=..sssCode()
 	s sqlStr="select INCSC_RowId as RowId, INCSC_Code as Code,INCSC_Desc as Description from INC_StkCat  where INCSC_StkType="_"'"_Type_"'"_"order by INCSC_RowId DESC"
	d result.Prepare(sqlStr)
 	d result.Execute()
	s count=0
	s resultString=""
	s json=##class(Code.JsonObj).%New()
	While(result.Next())
	 {
		 s Rowid=result.Data("RowId")
		 CONTINUE:+Rowid=0
		 s flag =##class(PHA.FACE.IN.Com).GetShowDataFlag(..#AppTable,Rowid,HospId) //医院级别授权
		 continue:flag="N"
	 	 s Code=result.Data("Code")
	 	 s Desc=result.Data("Description")
		 s tmp=Rowid_"^"_Code_"^"_Desc
		 s count=count+1
		 d json.InsertRowData(tmp)
       }
 	d result.Close()
 	s resultString=json.getJsonData("RowId^Code^Desc",count)
 	k json
 	q resultString
}

/// Descript:   保存/更新库存分类
/// Creater:    zhangxiao
/// CreateDate: 2013-10-15
/// Table:INC_StkCat
/// Input:数据串:rowid^代码^描述,rowid^代码^描述
/// Output:     
/// Return："" : 成功，非空：失败
/// w ##class(web.DHCST.StkCat).Save("^213123123^中药饮片")
ClassMethod Save(listData As %String, HospId) As %Library.String
{
	n (listData,HospId,%session)
	s rowDelim=##class(web.DHCST.Common.UtilCommon).RowDataDelim()
	s len=$l(listData,rowDelim)
	s errCode=""
	f i=1:1:len d
	.s err=""
	.s data=$p(listData,rowDelim,i)
	.s rowid=$p(data,"^",1)
	.s code=$p(data,"^",2)
	.s desc=$p(data,"^",3)
	.s wrongInfo="代码:"_code_",名称:"_desc
	.s existFlag=..CheckExist(rowid,code,desc,HospId)
	.i existFlag'="" d
	..s err=$p(existFlag,"^",2)
	..s errCode=$s(errCode="":err_": "_wrongInfo,1:errCode_"</br>"_err_": "_wrongInfo)
	.q:err'=""
	.i rowid'="" d
	..s ret=..Update(rowid,code,desc)
	..i ret'=0 s errCode=$s(errCode="":"更新失败: "_wrongInfo,1:errCode_"</br>更新失败: "_wrongInfo)
	.e  d
	..s ret=..Insert(code,desc,HospId)
	..i ret="" s errCode=$s(errCode="":"插入失败: "_wrongInfo,1:errCode_"</br>插入失败: "_wrongInfo)
	q errCode
}

/// Descript:   增加库存分类
/// Creater:    zhangxiao
/// CreateDate: 2013-10-15
/// Table:INC_StkCat
/// Input:代码,描述
/// Output:     
/// Return：rowid
/// w ##class(web.DHCST.StkCat).Insert("19900","输注")
ClassMethod Insert(code As %String, desc As %String, HospId) As %Library.String
{
	n (code,desc,HospId,%session)
	q:code="" ""
	q:desc="" ""
	s type=..sssCode()
	&sql(Insert into INC_StkCat (INCSC_Code,INCSC_Desc,INCSC_StkType) values (:code,:desc,:type))
	i SQLCODE'=0 d
	.s rett=$$ErrorRecord^DHCSTERROR("Insert:INC_StkCat",desc,SQLCODE_":"_%msg)
    e  d
	.s rowid=$p(%ROWID,$c(1))
    .s ret=##class(PHA.FACE.IN.Com).SaveBasicDataHosp(..#AppTable,rowid,HospId)
 	.i ret'=1 d
 	..d ErrorRecord^DHCSTERROR("Insert:BDP_MappingHosp",rowid,ret_":INC_StkCat")
	q:SQLCODE'=0 ""
	
	q $p(%ROWID,$c(1))
}

/// Descript:   更新库存分类
/// Creater:    zhangxiao
/// CreateDate: 2013-10-15
/// Table:INC_StkCat
/// Input:rowid^代码^描述
/// Output:     
/// Return：rowid
ClassMethod Update(rowid As %String, code As %String, desc As %String) As %Library.String [ Private ]
{
	n (rowid,code,desc)
	q:rowid="" ""
	q:code="" ""
	q:desc="" ""
	&sql(Update INC_StkCat set INCSC_Code=:code,INCSC_Desc=:desc where INCSC_RowId=:rowid)
	i SQLCODE'=0 d
	.s rett=$$ErrorRecord^DHCSTERROR("Update:INC_StkCat",desc,SQLCODE_":"_%msg)
	q SQLCODE
}

///  Descript:   删除库存分类
/// Creater:     zhangxiao
/// CreateDate: 2013-10-15
/// Table:INC_StkCat
/// Input:rowid
/// Output:     
/// Return：0 – 成功，非0 ：失败
/// w ##class(web.DHCST.StkCat).Delete(84)
ClassMethod Delete(rowid As %String) As %Library.String
{
	n (rowid)
	q:rowid="" ""
	&sql(Delete from INC_StkCat where INCSC_RowId=:rowid)
	i SQLCODE'=0 d
	.s rett=$$ErrorRecord^DHCSTERROR("Delete:INC_StkCat",rowid,SQLCODE_":"_%msg)
	e  d
    .s ret=##class(PHA.FACE.IN.Com).SaveBasicDataHosp(..#AppTable,rowid,HospId)
 	.i ret'=1 d
 	..d ErrorRecord^DHCSTERROR("Delete:BDP_MappingHosp",rowid,ret_":INC_StkCat")
	q SQLCODE
}

ClassMethod CodeToID(code, HospId)
{
	n (code,HospId)
	s RetRowID=""
	s code=$$ALPHAUP^SSUTIL4(code)
	s BDPHospAut=##class(PHA.FACE.IN.Com).GetHospAut() //医院级别授权是否开启
    s Rowid=0
	f  s Rowid=$o(^INC("SC",0,"Code",code,Rowid)) q:(+Rowid=0)||(RetRowID'="")  d
	.s scgType=$p(^INC("SC",Rowid),"^",3)
	.q:scgType'=..sssCode()
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
	f  s Rowid=$o(^INC("SC",0,"Desc",desc,Rowid)) q:(+Rowid=0)||(RetRowID'="")  d
	.s scgType=$p(^INC("SC",Rowid),"^",3)
	.q:scgType'=..sssCode()
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
ClassMethod CheckExist(rowId, code, desc, HospId = "")
{
 	n (code,desc,rowId,HospId)
 	s errCode=""
 	s id=..CodeToID(code,HospId)
 	i (id'="")&&(id'=rowId) s errCode="-1^代码重复"
	s id=..DescToID(desc,HospId)
 	i (id'="")&&(id'=rowId) s errCode="-1^名称重复"
	q errCode
}

}
