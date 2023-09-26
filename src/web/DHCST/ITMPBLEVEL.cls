Import sqluser

/// Descript:招标级别维护
/// Creater:	ZhangDongmei
/// CreateDate:	2012-05-28
Class web.DHCST.ITMPBLEVEL Extends (%RegisteredObject, StkTypeG) [ Not ProcedureBlock ]
{

Parameter AppTable [ Final ] = "DHC_ItmPBLevel";

/// Descript:	保存/更新招标级别信息
/// Creater:	ZhangDongmei
/// CreateDate:	2012-05-28
/// Table:DHC_ItmPBLevel
/// Input:数据串:rowid^代码^描述^开始日期^截止日期,rowid^代码^描述^开始日期^截止日期,
/// Output:		
/// Return："" – 成功，
/// 非空：失败
/// w ##class(web.DHCST.ITMPBLEVEL).Save("^44^招标一级【总院】^^","2")
ClassMethod Save(listData As %String, HospId = "") As %Library.String
{
	n (listData,HospId)
	;s ^zdm("cs")=listData
	s rowDelim=##class(web.DHCST.Common.UtilCommon).RowDataDelim()
	i listData="" d
	.s len=0
	e  d
	.s len=$l(listData,rowDelim)
	s msg=""
	s err=""
	///检查代码重复
	f i=1:1:len  q:msg'=""  d
	.s data=$p(listData,rowDelim,i)
	.s rowid=$p(data,"^",1)
	.s code=$p(data,"^",2)
	.s desc=$p(data,"^",3)
	.q:code=""
	.q:desc=""
	.s ret=..CheckExist(rowid,code,desc,HospId)
 	.s:ret'="" msg=$p(ret,"^",1)
 	q:msg'="" msg
 	
	s err=""
	f i=1:1:len  q:msg'=""  d
	.s data=$p(listData,rowDelim,i)
	.s rowid=$p(data,"^",1)
	.s code=$p(data,"^",2)
	.s desc=$p(data,"^",3)
	.q:code=""
	.q:desc=""
	.s stdate=$p(data,"^",4)
	.s eddate=$p(data,"^",5)
 	.s:stdate'="" stdate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(stdate)
 	.s:eddate'="" eddate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(eddate)
	.i rowid'=""  d
	..s ret=..Update(rowid,code,desc,stdate,eddate)
	..s:ret'=0 err=err_","_desc
	.e  d
	..s ret=..Insert(code,desc,stdate,eddate,HospId)
	..s:ret="" err=err_","_desc
	.
	
	q err
}

/// Descript:	增加招标级别信息
/// Creater:	ZhangDongmei
/// CreateDate:	2012-05-28
/// Table:DHC_ItmPBLevel
/// Input:代码,描述,开始日期,截止日期
/// Output:		
/// Return：rowid
ClassMethod Insert(Code As %String, Desc As %String, StDate As %String, EdDate As %String, HospId = "") As %Library.String [ Private ]
{
	n (Code,Desc,StDate,EdDate,HospId)
 	;
 	;不能为空项
 	q:Code="" ""
 	q:Desc="" ""
 	s:+StDate=0 StDate=+$h
 	s:+EdDate=0 EdDate=$zdh("9999-12-31",3)
 	;
 	&sql(Insert into DHC_ItmPBLevel(PBL_Code,PBL_Desc,PBL_DateFrom,PBL_DateTo)
 	values(:Code,:Desc,:StDate,:EdDate))
 	s Err=0
 	i SQLCODE'=0  d
 	.d ErrorRecord^DHCSTERROR("Insert:DHC_ItmPBLevel",Desc,SQLCODE_":"_%msg)
 	.s Err=-1
    e  d
    .s Rowid=$p(%ROWID,$c(1))
    .d ##class(PHA.FACE.IN.Com).SaveBasicDataHosp(..#AppTable,Rowid,HospId)
 	q:Err'=0 ""
 	q $p(%ROWID,$c(1))
}

/// Descript:	更新招标级别信息
/// Creater:	ZhangDongmei
/// CreateDate:	2012-05-28
/// Table:DHC_ItmPBLevel
/// Input:rowid,代码,描述,开始日期,截止日期
/// Output:		
/// Return：0:成功;非0：失败
ClassMethod Update(Rowid As %String, Code As %String, Desc As %String, StDate As %String, EdDate As %String) As %Library.String [ Private ]
{
	n (Rowid,Code,Desc,StDate,EdDate)
 	;
 	;不能为空项
 	q:Code="" ""
 	q:Desc="" ""
 	q:Rowid="" ""
 	;
 	s:+StDate=0 StDate=+$h
 	s:+EdDate=0 EdDate=$zdh("9999-12-31",3)
 	s Err=0
 	&sql(Update DHC_ItmPBLevel set PBL_Code=:Code,PBL_Desc=:Desc,
 	PBL_DateFrom=:StDate,PBL_DateTo=:EdDate where PBL_Rowid=:Rowid)
 	i SQLCODE'=0  d
 	.d ErrorRecord^DHCSTERROR("Update:DHC_ItmPBLevel",Desc,SQLCODE_":"_%msg)
 	.s Err=-1
 	q Err
}

/// Descript:	删除招标级别信息
/// Creater:	ZhangDongmei
/// CreateDate:	2012-05-28
/// Table:DHC_ItmPBLevel
/// Input:rowid
/// Output:		
/// Return：0 – 成功，非0 ：失败
ClassMethod Delete(rowid As %String, HospId = "") As %Library.String
{
	n (rowid, HospId)
 	;
 	;不能为空项
 	q:rowid="" ""
 	;
 	s Err=0
 	&sql(Delete from DHC_ItmPBLevel where PBL_Rowid=:rowid)
 	i SQLCODE'=0  d
 	.d ErrorRecord^DHCSTERROR("Delete:DHC_ItmPBLevel",rowid,SQLCODE_":"_%msg)
 	.s Err=-1
    e  d
    .d ##class(PHA.FACE.IN.Com).DeleteBasicDataHosp(..#AppTable,rowid,HospId)
 	q Err
}

/// Descript:	查询招标级别信息
/// Creater:	ZhangDongmei
/// CreateDate:	2012-05-28
/// Table:DHC_ItmPBLevel
/// Input:
/// Output:		
/// Return：招标级别信息
ClassMethod SelectAll(HospId = "")
{
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "SELECT PBL_Rowid as Rowid,PBL_Code,PBL_Desc,PBL_DateFrom,PBL_DateTo"_  
	" FROM DHC_ItmPBLevel"
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
		s Code = result.Data("PBL_Code")
		s Desc = result.Data("PBL_Desc")
		s DateFrom = result.Data("PBL_DateFrom")
		s DateTo = result.Data("PBL_DateTo")
		s:DateFrom'="" DateFrom=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(DateFrom,"ST")
		s:DateTo'="" DateTo=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(DateTo,"ST")
		;
		s tmp=Rowid_"^"_Code_"^"_Desc_"^"_DateFrom_"^"_DateTo
		s count = count+1		
		d json.InsertRowData(tmp)
	}
	d result.Close()
	s resultString = json.getJsonData("RowId^Code^Desc^DateFrom^DateTo",count)
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
	f  s Rowid=$o(^DHCITMPBL(0,"Code",code,Rowid)) q:(+Rowid=0)||(RetRowID'="")  d
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
	f  s Rowid=$o(^DHCITMPBL(0,"Desc",desc,Rowid)) q:(+Rowid=0)||(RetRowID'="")  d
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
 	i (id'="")&&(id'=rowId) s errCode="-2^名称重复"
	q errCode
}

}
