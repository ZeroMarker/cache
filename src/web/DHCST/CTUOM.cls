Import sqluser

/// Descript:单位（包括单位转换）相关
/// Creater:	ZhangDongmei
/// CreateDate:	2012-05-10
Class web.DHCST.CTUOM Extends (%RegisteredObject, StkTypeG) [ Not ProcedureBlock ]
{

/// Descript:	保存/更新单位信息
/// Creater:	ZhangDongmei
/// CreateDate:	2012-05-10
/// Table:CT_Uom
/// Input:数据串:rowid^代码^描述,rowid^代码^描述
/// Output:		
/// Return："" – 成功，非空：失败
ClassMethod Save(listData As %String) As %Library.String
{
	n (listData)
	;s ^zdm("cs")=listData
	s rowDelim=##class(web.DHCST.Common.UtilCommon).RowDataDelim()
	s len=$l(listData,rowDelim)
	s err=""
	s msg=0
	f i=1:1:len  d
	.s data=$p(listData,rowDelim,i)
	.s rowid=$p(data,"^",1)
	.s code=$p(data,"^",2)
	.s desc=$p(data,"^",3)
	.s tmpid=$o(^CT("UOM",0,"Code",$$ALPHAUP^SSUTIL4(code),""))
	.s:(tmpid'="")&(tmpid'=rowid) msg=-1
 	.s tmpid=$o(^CT("UOM",0,"Desc",$$ALPHAUP^SSUTIL4(desc),""))
 	.s:(tmpid'="")&(tmpid'=rowid) msg=-2
	.i rowid'=""  d
	..s ret=..Update(rowid,code,desc)
	..s:ret'=0 err=err_","_desc
	.e  d
	..s ret=..Insert(code,desc)
	..s:ret="" err=err_","_desc
	.
	q:msg'=0 msg
	q err
}

/// Descript:	增加单位信息
/// Creater:	ZhangDongmei
/// CreateDate:	2012-05-10
/// Table:CT_Uom
/// Input:代码,描述
/// Output:		
/// Return：rowid
ClassMethod Insert(code As %String, desc As %String) As %Library.String [ Private ]
{
	n (code,desc)
 	;
 	;不能为空项
 	q:code="" ""
 	q:desc="" ""
 	;
 	&sql(Insert into CT_UOM(CTUOM_Code,CTUOM_Desc)
 	values(:code,:desc))
 	i SQLCODE'=0  d
 	.s rett=$$ErrorRecord^DHCSTERROR("Insert:CT_UOM",desc,SQLCODE_":"_%msg)
 	q:SQLCODE'=0 ""
 	q $p(%ROWID,$c(1))
}

/// Descript:	更新单位信息
/// Creater:	ZhangDongmei
/// CreateDate:	2012-05-10
/// Table:CT_Uom
/// Input:rowid^代码^描述
/// Output:		
/// Return：rowid
ClassMethod Update(rowid As %String, code As %String, desc As %String) As %Library.String [ Private ]
{
	n (rowid,code,desc)
 	;
 	;不能为空项
 	q:code="" ""
 	q:desc="" ""
 	q:rowid="" ""
 	;
 	&sql(Update CT_Uom set CTUOM_Code=:code,CTUOM_Desc=:desc
 	where CTUOM_Rowid=:rowid)
 	i SQLCODE'=0  d
 	.s rett=$$ErrorRecord^DHCSTERROR("Update:CT_Uom",code,SQLCODE_":"_%msg)
 	q SQLCODE
}

/// Descript:	删除单位信息
/// Creater:	ZhangDongmei
/// CreateDate:	2012-05-10
/// Table:CT_Uom
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
 	&sql(Delete from CT_Uom where CTUOM_Rowid=:rowid)
 	i SQLCODE'=0  d
 	.s rett=$$ErrorRecord^DHCSTERROR("Delete:CT_Uom",rowid,SQLCODE_":"_%msg)
 	q SQLCODE
}

/// Descript:	查询单位信息
/// Creater:	ZhangDongmei
/// CreateDate:	2012-05-10
/// Table:CT_Uom
/// Input:
/// Output:		
/// Return：单位信息
ClassMethod SelectAll(Start As %Integer, Limit As %Integer, Sort As %String, Dir As %String, Desc As %String)
{
	;s ^zdm("SelectAll")=Desc
	n (Start,Limit,Sort,Dir,Desc)
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "SELECT CTUOM_Rowid as Rowid,CTUOM_Code as Code,CTUOM_Desc as Description"_
	"  FROM CT_Uom where CTUOM_Desc like '%"_Desc_"%'"
	;
	s OrderField="Rowid"
    ;
    s:Sort="Code" OrderField="Code"
    s:Sort="Desc" OrderField="Description"
    s Dir=$$ALPHAUP^SSUTIL4(Dir)
    s:(Dir="")&(Dir'="ASC")&(Dir'="DESC") Dir="DESC"
    i OrderField'=""  d
    .s sqlStr=sqlStr_" order by "_OrderField_" "_Dir
    .
    d result.Prepare(sqlStr)
	d result.Execute()
	s count = 0
	s resultString = ""
	s end = Start+Limit
	s json = ##class(Code.JsonObj).%New()
	While(result.Next())
	{	
		s Rowid = result.Data("Rowid")
		s Code = result.Data("Code")
		s Description = result.Data("Description")
		s tmp=Rowid_"^"_Code_"^"_Description
		s count = count+1	
		CONTINUE:count<(Start+1)
		CONTINUE:count>end	
		d json.InsertRowData(tmp)
	}
	d result.Close()
	s resultString = json.getJsonData("RowId^Code^Desc",count)
	k json
	Q resultString
}

/// Descript:	增加单位转换关系
/// Creater:	ZhangDongmei
/// CreateDate:	2012-05-10
/// Table:CT_ConFac
/// Input:From单位id^To单位id^转换因子,From单位id^To单位id^转换因子
/// Output:		
/// Return：成功:"", 失败:失败串
ClassMethod AddConFac(ListData As %String) As %Library.String
{
	n (ListData)
	;s ^zdm("cs")=listData
	s rowDelim=##class(web.DHCST.Common.UtilCommon).RowDataDelim()
	s len=$l(ListData,rowDelim)
	s err=""
	f i=1:1:len  d
	.s Data=$p(ListData,rowDelim,i)
	.s FrUom=$p(Data,"^",1)
	.s ToUom=$p(Data,"^",2)
	.q:'$d(^CT("UOM",FrUom))
	.q:'$d(^CT("UOM",ToUom))
	.s ToUomDesc=$p(^CT("UOM",ToUom),"^",2)
	.s ConFac=$p(Data,"^",3)
	.s ActiveFlag=$p(Data,"^",4)
	.s id=$o(^CT("CTCF",0,"UOM",FrUom,ToUom,""))   ;存在该单位间的转换关系
	.i id'=""  d
	..s err=err_",存在到单位"_ToUomDesc_"的转换关系"
	.q:id'=""
	.s ret=..InsertConFac(FrUom,ToUom,ConFac,ActiveFlag)
	.i ret=""  d
	..s err=err_","_ToUomDesc
	.
	;a
	q err
}

/// Descript:	增加单位转换关系
/// Creater:	ZhangDongmei
/// CreateDate:	2012-05-10
/// Table:CT_ConFac
/// Input:From单位id,To单位id,转换因子
/// Output:		
/// Return：成功:rowid, 失败:空
ClassMethod InsertConFac(FrUom As %String, ToUom As %String, ConFac As %Integer, ActiveFlag As %String) As %Library.String [ Private ]
{
	n (FrUom,ToUom,ConFac,ActiveFlag)
 	;
 	;不能为空项
 	q:FrUom="" ""
 	q:ToUom="" ""
 	q:'$d(^CT("UOM",FrUom)) ""
 	q:'$d(^CT("UOM",ToUom)) ""
 	;
 	;s ActiveFlag="Y"
 	&sql(Insert into CT_ConFac(CTCF_FrUOM_DR,CTCF_ToUOM_DR,CTCF_Factor,
 	CTCF_ActiveFlag) values(:FrUom,:ToUom,:ConFac,:ActiveFlag))
 	i SQLCODE'=0  d
 	.s FrUomDesc=$p(^CT("UOM",FrUom),"^",2)
 	.s ToUomDesc=$p(^CT("UOM",ToUom),"^",2)
 	.s rett=$$ErrorRecord^DHCSTERROR("InsertConFac:CT_ConFac",FrUomDesc_"-"_ToUomDesc,SQLCODE_":"_%msg)
 	q:SQLCODE'=0 ""
 	q $p(%ROWID,$c(1))
}

/// Descript:	更新单位转换关系
/// Creater:	ZhangDongmei
/// CreateDate:	2012-05-10
/// Table:CT_ConFac
/// Input:rowid^转换因子^激活标志,rowid^转换因子^激活标志
/// Output:		
/// Return：成功:"", 失败:失败串
ClassMethod UpdConFac(ListData As %String) As %Library.String
{
	n (ListData)
	;s ^zdm("cs")=listData
	s rowDelim=##class(web.DHCST.Common.UtilCommon).RowDataDelim()
	s len=$l(ListData,rowDelim)
	s err=""
	f i=1:1:len  d
	.s Data=$p(ListData,rowDelim,i)
	.s Rowid=+$p(Data,"^",1)
	.s ConFac=$p(Data,"^",2)
	.s ActiveFlag=$p(Data,"^",3)
	.b ;1
	.q:Rowid=""
	.s ret=..UpdateConFac(Rowid,ConFac,ActiveFlag)
	.b ;2
	.i ret'=0  d
	..s err=err_","_Rowid_":"_ret
	.
	q err
}

/// Descript:	更新单位转换关系
/// Creater:	ZhangDongmei
/// CreateDate:	2012-05-10
/// Table:CT_ConFac
/// Input:rowid
/// Output:		
/// Return：0 – 成功，非0 ：失败
ClassMethod UpdateConFac(rowid As %String, ConFac As %Integer, ActiveFlag As %String) As %Library.String
{
	n (rowid,ConFac,ActiveFlag)
 	;
 	;不能为空项
 	q:rowid="" -1
 	;
 	&sql(Update CT_ConFac set CTCF_Factor=:ConFac,CTCF_ActiveFlag=:ActiveFlag where CTCF_Rowid=:rowid)
 	i SQLCODE'=0  d
 	.s rett=$$ErrorRecord^DHCSTERROR("UpdateConFac:CT_ConFac",rowid,SQLCODE_":"_%msg)
 	q SQLCODE
}

/// Descript:	删除单位转换关系
/// Creater:	ZhangDongmei
/// CreateDate:	2012-05-10
/// Table:CT_ConFac
/// Input:rowid
/// Output:		
/// Return：0 – 成功，非0 ：失败
ClassMethod DeleteConFac(rowid As %String) As %Library.String
{
	n (rowid)
 	;
 	;不能为空项
 	q:rowid="" ""
 	;
 	&sql(Delete from CT_ConFac where CTCF_Rowid=:rowid)
 	i SQLCODE'=0  d
 	.s rett=$$ErrorRecord^DHCSTERROR("DeleteConFac:CT_ConFac",rowid,SQLCODE_":"_%msg)
 	q SQLCODE
}

/// Descript:	查询和已知单位存在转换关系的单位
/// Creater:	ZhangDongmei
/// CreateDate:	2012-05-10
/// Table:CT_ConFac
/// Input:From单位id
/// Output:		
/// Return：转换信息
ClassMethod SelectConUom(FrUomId As %String)
{
	n (FrUomId)
	q:FrUomId="" ""
	s count = 0
	s resultString = ""
	s json = ##class(Code.JsonObj).%New()
	s ToUomId=""
	f  s ToUomId=$o(^CT("CTCF",0,"UOM",FrUomId,ToUomId)) q:ToUomId=""  d
	.s Rowid=$o(^CT("CTCF",0,"UOM",FrUomId,ToUomId,"")) 
	.q:Rowid="" 
	.s ToUomCode=$p(^CT("UOM",ToUomId),"^",1)
	.s ToUomDesc=$p(^CT("UOM",ToUomId),"^",2) 
	.s ConFac=$p(^CT("CTCF",Rowid),"^",3)
	.s ActiveFlag=$p(^CT("CTCF",Rowid),"^",4)
#;	.i ActiveFlag="Y" s ActiveFlag="true"
#;	.e  s ActiveFlag="false"
	.s tmp=Rowid_"^"_ToUomId_"^"_ToUomCode_"^"_ToUomDesc_"^"_ConFac_"^"_ActiveFlag
	.s count = count+1		
	.d json.InsertRowData(tmp)
	.
	s resultString = json.getJsonData("Rowid^ToUomId^ToUomCode^ToUomDesc^ConFac^ActiveFlag",count)
	k json
	Q resultString
}

}
