Import sqluser

/// Descript:项目组相关
/// Creater:	ZhangDongmei
/// CreateDate:	2013-03-07
Class web.DHCST.LocItemGrp Extends (%RegisteredObject, StkTypeG) [ Not ProcedureBlock ]
{

Parameter AppTable [ Final ] = "DHC_LocItemGrp";

/// Descript:	保存/更新项目组信息
/// Creater:	ZhangDongmei
/// CreateDate:	2013-03-07
/// Table:DHC_LocItemGrp
/// Input:rowid^代码^描述^激活标志^备注,rowid^代码^描述^激活标志^备注
/// Output:		
/// Return：""：成功，非空：保存失败，请检查代码和描述是否重复
ClassMethod Save(listData As %String, HospId = "") As %Library.String
{
	n (listData,HospId)
	;s ^zdm("cs")=listData
	s rowDelim=##class(web.DHCST.Common.UtilCommon).RowDataDelim()
	s len=$l(listData,rowDelim)
	s err=""
	f i=1:1:len  d
	.s data=$p(listData,rowDelim,i)
	.s rowid=$p(data,"^",1)
	.s code=$p(data,"^",2)
	.s desc=$p(data,"^",3)
	.s active=$p(data,"^",4)
	.s remark=$p(data,"^",5)
	.q:code=""
    .q:desc=""
    .s tmpid=..CodeToID(code,HospId)
    .s:(tmpid'="")&(tmpid'=rowid) err=-1
    .s tmpid=..DescToID(desc,HospId)
    .s:(tmpid'="")&(tmpid'=rowid) err=-2
	.i rowid'=""  d
	..s ret=..Update(rowid,code,desc,active,remark)
	..s:ret'=0 err=err_","_desc
	.e  d
	..s ret=..Insert(code,desc,active,remark, HospId)
	..s:+ret<=0 err=err_","_desc
	.
	q err
}

/// Descript:	增加项目组信息
/// Creater:	ZhangDongmei
/// CreateDate:	2013-03-07
/// Table:DHC_LocItemGrp
/// Input:代码,描述，激活状态，备注
/// Output:		
/// Return：rowid
ClassMethod Insert(code As %String, desc As %String, active As %String, remark As %String, HospId = "") As %Library.String [ Private ]
{
	n (code,desc,active,remark,HospId)
 	;
 	;
 	;
 	s err=0
 	&sql(Insert into DHC_LocItemGrp(LIG_Code,LIG_Desc,LIG_Flag,LIG_ReMark)
 	values(:code,:desc,:active,:remark))
 	i SQLCODE'=0  d
 	.s rett=$$ErrorRecord^DHCSTERROR("Insert:DHC_StkLocGroup",code,SQLCODE_":"_%msg)
 	.s err=-3
    e  d
    .s Rowid=$p(%ROWID,$c(1))
    .i HospId'="" d ##class(PHA.FACE.IN.Com).SaveBasicDataHosp(..#AppTable,Rowid,HospId)
 	q:err'=0 ""
 	q $p(%ROWID,$c(1))
}

/// Descript:	更新项目组信息
/// Creater:	ZhangDongmei
/// CreateDate:	2013-03-07
/// Table:DHC_LocItemGrp
/// Input:代码,描述，激活状态，备注
/// Output:		
/// Return：0,成功,
ClassMethod Update(rowid As %String, code As %String, desc As %String, active As %String, remark As %String) As %Library.String [ Private ]
{
	n (rowid,code,desc,active,remark)
 	;
 	;
 	s Err=0
 	&sql(Update DHC_LocItemGrp set LIG_Code=:code,LIG_Desc=:desc,LIG_Flag=:active,LIG_ReMark=:remark 
 	where LIG_Rowid=:rowid)
 	i SQLCODE'=0  d
 	.s rett=$$ErrorRecord^DHCSTERROR("Update:DHC_LocItemGrp",code,SQLCODE_":"_%msg)
 	.s Err=-3
 	q Err
}

/// Descript:	删除信息
/// Creater:	ZhangDongmei
/// CreateDate:	2013-03-07
/// Table:DHC_LocItemGrp
/// Input:rowid
/// Output:		
/// Return：0 – 成功，非0 ：失败,
ClassMethod Delete(rowid As %String, HospId = "") As %Library.String
{
	n (rowid,HospId)
 	;
 	;不能为空项
 	q:rowid="" ""
 	;
 	s Err=0
 	&sql(Delete from DHC_LocItemGrp where LIG_Rowid=:rowid)
 	q:SQLCODE=100 -1
 	i SQLCODE'=0  d
 	.s rett=$$ErrorRecord^DHCSTERROR("Delete:DHC_LocItemGrp",rowid,SQLCODE_":"_%msg)
 	.s Err=-1
    e  d
    .i HospId'="" d ##class(PHA.FACE.IN.Com).DeleteBasicDataHosp(..#AppTable,rowid,HospId)
 	q Err
}

/// Descript:	查询项目组信息
/// Creater:	ZhangDongmei
/// CreateDate:	2013-03-07
/// Table:DHC_LocItemGrp
/// Input:
/// Output:		
/// Return：项目组信息
ClassMethod Query(Start As %Integer, Limit As %Integer, Sort As %String, Dir As %String, Desc As %String, Code As %String, Active As %String, HospId = "") As %String
{
	n (Desc,Active,Code,Start,Limit,Sort,Dir,HospId)
	;s ^zdm("Query")=Code_","_Name_","_Start_","_Limit_","_Sort_","_Dir
	s count = 0
	s resultString = ""
	s StrSql="select LIG_RowID,LIG_Code,LIG_Desc,LIG_Flag,LIG_ReMark"_
    " from DHC_LocItemGrp where LIG_Desc like '%"_Desc_"%' and LIG_Code like '%"_Code_"%'"
    s OrderField="LIG_RowID"
   
    i Active'=""  d
    .s StrSql=StrSql_" and LIG_Flag = '"_Active_"'"
    ;
    s:Sort="Code" OrderField="LIG_Code"
    s:Sort="Desc" OrderField="LIG_Desc"
    s:Sort="Active" OrderField="LIG_Flag"
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
		s Rowid = result.Data("LIG_RowID")
		s flag =##class(PHA.FACE.IN.Com).GetShowDataFlag(..#AppTable,Rowid,HospId) //医院级别授权
		CONTINUE:flag="N"
		s Code = result.Data("LIG_Code")
		s Desc = result.Data("LIG_Desc")
		s Active = result.Data("LIG_Flag")
		s Remark=result.Data("LIG_ReMark")
		;
		s Data=Rowid_"^"_Code_"^"_Desc_"^"_Active_"^"_Remark
		s count = count+1	
		CONTINUE:count<(Start+1)
		CONTINUE:count>end	
		d json.InsertRowData(Data)
	}
	d result.Close()
	s resultString = json.getJsonData("RowId^Code^Desc^Active^Remark",count)
	k json
	Q resultString
}

ClassMethod CodeToID(code, HospId)
{
	n (code,HospId)
	s RetRowID=""
	s BDPHospAut=##class(PHA.FACE.IN.Com).GetHospAut() //医院级别授权是否开启
	s Rowid=0
	f  s Rowid=$o(^DHCLIG(Rowid)) q:(+Rowid=0)||(RetRowID'="")  d
	.s tmpCode=$p(^DHCLIG(Rowid),"^",1)
	.q:code'=tmpCode
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
	s BDPHospAut=##class(PHA.FACE.IN.Com).GetHospAut() //医院级别授权是否开启
	s Rowid=0
	f  s Rowid=$o(^DHCLIG(Rowid)) q:(+Rowid=0)||(RetRowID'="")  d
	.s tmpDesc=$p(^DHCLIG(Rowid),"^",2)
	.q:desc'=tmpDesc
	.s flag="Y"
	.i BDPHospAut="Y" d
	..i HospId="" s flag="N",RetRowID="-1^入参HospId为空"
	..e  s flag =##class(PHA.FACE.IN.Com).GetShowDataFlag(..#AppTable,Rowid,HospId) //医院级别授权
	.q:flag="N"
	.s RetRowID=Rowid
	q $g(RetRowID)
}

}
