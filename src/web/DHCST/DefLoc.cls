Import sqluser

/// Descript:支配科室信息相关
/// Creater:	ZhangDongmei
/// CreateDate:	2012-05-24
Class web.DHCST.DefLoc Extends (%RegisteredObject, StkTypeG) [ Not ProcedureBlock ]
{

/// Descript:	保存/更新支配科室
/// Creater:	ZhangDongmei
/// CreateDate:	2012-05-24
/// Table:DHC_DefLoc
/// Input:科室id,支配科室id^支配科室id
/// Output:		
/// Return：""：成功，非空：保存失败
ClassMethod Save(LocId As %String, listData) As %Library.String
{
	n (LocId,listData)
	s ^zdm("cs")=listData
	q:LocId="" ""
	s len=$l(listData,"^")
	s err=""
	f i=1:1:len  d
	.s SubLocId=$p(listData,"^",i)
	.q:SubLocId=""
	.s Rowid=$o(^DHCDLOC(0,"LEADSUB",LocId,SubLocId,""))
	.q:+Rowid>0    ;存在支配关系
	.s SubLocDesc=$p(^CTLOC(SubLocId),"^",2)
	.s ret=..Insert(LocId,SubLocId)
	.s:ret="" err=err_","_SubLocDesc
	.
	q err
}

/// Descript:	增加支配科室定义
/// Creater:	ZhangDongmei
/// CreateDate:	2012-05-24
/// Table:DHC_DefLoc
/// Input:科室id,支配科室id
/// Output:		
/// Return：rowid
ClassMethod Insert(LocId As %String, SubLocId As %String) As %Library.String [ Private ]
{
	n (LocId,SubLocId)
 	;
 	s err=0
 	&sql(Insert into DHC_DefLoc(DLOC_Lead_DR,DLOC_Sub_DR)
 	values(:LocId,:SubLocId))
 	i SQLCODE'=0  d
 	.s rett=$$ErrorRecord^DHCSTERROR("Insert:DHC_DefLoc",SubLocId,SQLCODE_":"_%msg)
 	.s err=-1
 	q:err'=0 ""
 	q $p(%ROWID,$c(1))
}

/// Descript:	删除支配科室定义
/// Creater:	ZhangDongmei
/// CreateDate:	2012-05-24
/// Table:DHC_DefLoc
/// Input:rowid
/// Output:		
/// Return：0,成功,
ClassMethod Delete(rowid As %String) As %Library.String
{
	n (rowid)
 	;
 	;不能为空项
 	q:rowid="" ""
 	;
 	s Err=0
 	&sql(Delete from DHC_DefLoc where DLOC_ROWID=:rowid)
 	i SQLCODE'=0  d
 	.s rett=$$ErrorRecord^DHCSTERROR("Delete:DHC_DefLoc",rowid,SQLCODE_":"_%msg)
 	.s Err=-3
 	q Err
}

/// Descript:	查询某科室对应的支配科室信息
/// Creater:	ZhangDongmei
/// CreateDate:	2012-05-24
/// Table:DHC_DefLoc
/// Input:开始行，一页记录数，排序字段，排序方向,主科室id
/// Output:		
/// Return：Rowid^支配科室id^支配科室代码^支配科室描述
/// 
ClassMethod Query(Start As %Integer, Limit As %Integer, Sort As %String, Dir As %String, LocId As %String) As %String
{
	n (LocId,Start,Limit,Sort,Dir)
	;s ^zdm("Query")=Start_","_Limit_","_Sort_","_Dir_","_StrFilter
	q:LocId="" ""
	s count = 0
	s resultString = ""
	s StrSql="select DLOC_ROWID as Rowid,DLOC_Sub_DR,DLOC_Sub_DR->CTLOC_Code as Code,"_
	"DLOC_Sub_DR->CTLOC_Code as CtDesc"_
    " from DHC_DefLoc where DLOC_Lead_DR='"_LocId_"'"
    s OrderField="Rowid"
    ;
    s:Sort="Code" OrderField="Code"
    s:Sort="Desc" OrderField="CtDesc"
    s Dir=$$ALPHAUP^SSUTIL4(Dir)
    s:(Dir'="ASC")&(Dir'="DESC") Dir="DESC"
    i OrderField'=""  d
    .s StrSql=StrSql_" order by "_OrderField_" "_Dir
    ;s ^zdm("Query_sql")=StrSql
	s json = ##class(Code.JsonObj).%New()
	;b ;11
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
		s Rowid = result.Data("Rowid")
		s Code = result.Data("Code")
		s Desc = result.Data("CtDesc")
		s SubLocId=result.Data("DLOC_Sub_DR")
		;
		s Data=Rowid_"^"_Code_"^"_Desc_"^"_SubLocId
		s count = count+1	
		CONTINUE:count<(Start+1)
		CONTINUE:count>end	
		d json.InsertRowData(Data)
	}
	d result.Close()
	s resultString = json.getJsonData("Rowid^Code^Desc^SubLocId",count)
	k json
	Q resultString
}

ClassMethod test1()
{
 q ..sssDesc()
}

}
