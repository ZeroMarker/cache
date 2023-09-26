Import sqluser

/// creator:yunhaibao
/// createdate:20160613
/// descirpiton:拒绝退药原因维护
Class web.DHCOUTPHA.PHRRefuseReason Extends %RegisteredObject [ ProcedureBlock ]
{

/// Descripttion:拒绝退药原因
/// w ##class(web.DHCOUTPHA.PHRRefuseReason).SaveReason("1^2^eeeee")
ClassMethod SaveReason(DataList As %String) As %String
{
	s len=$L(DataList,"||")
	f i=1:1:len d
	.s TmpStr=$p(DataList,"||",i)
	.i $p(TmpStr,"^",1)'="" d
	..s ret=..UpdateReason(TmpStr)
	.e  d
	..s ret=..InsertReason(TmpStr)
	q 0
}

ClassMethod InsertReason(DataStr)
{
	s code=$p(DataStr,"^",2)
	s desc=$p(DataStr,"^",3)
	q:(code="")||(desc="") -3
	q:$d(^PHRREFUSE(0,"Code",$$ALPHAUP^SSUTIL4(code))) -1
	q:$d(^PHRREFUSE(0,"Desc",$$ALPHAUP^SSUTIL4(desc))) -2
	&sql(insert into PHR_RefuseReason(Refuse_code,Refuse_desc) values (:code,:desc) )
	q SQLCODE
}

ClassMethod UpdateReason(DataStr)
{
	s rowid=$p(DataStr,"^",1)
	s code=$p(DataStr,"^",2)
	s desc=$p(DataStr,"^",3)
	q:(code="")||(desc="") -3
	s exist=0
	i $d(^PHRREFUSE(0,"Code",$$ALPHAUP^SSUTIL4(code))) d
	.s tmprowid=$o(^PHRREFUSE(0,"Code",$$ALPHAUP^SSUTIL4(code),""))
	.i tmprowid'=rowid s exist=-1
	i $d(^PHRREFUSE(0,"Desc",$$ALPHAUP^SSUTIL4(desc))) d
	.s tmprowid=$o(^PHRREFUSE(0,"Desc",$$ALPHAUP^SSUTIL4(desc),""))
	.i tmprowid'=rowid s exist=-2
	q:exist<0 exist
	&sql(update PHR_RefuseReason set Refuse_code=:code,Refuse_desc=:desc where Refuse_rowid=:rowid)
	q SQLCODE
}

/// Descripttion:删除拒绝退药原因
ClassMethod DeleteReason(rowid As %String) As %String
{
 q:rowid="" 0
 &sql(delete from PHR_RefuseReason where Refuse_rowid=:rowid)
 ;&sql(delete from BLC_ReasonForRefund where RFR_RowId=:rowid)
 q:SQLCODE -1
 q 0
}

/// Descripttion:查询拒绝退药原因
/// 
ClassMethod jsQueryReason()
{
	
	s result=##class(%Library.ResultSet).%New("web.DHCOUTPHA.PHRRefuseReason:RefuseReason")
	s sc=result.Execute()
	i $$$ISERR(sc) q ##class(web.DHCSTJQUERYCOMMON).getJsonEmptySign(0) 
	s colNum=result.GetColumnCount()
	s colNameStr=""
	f i=1:1:colNum d
	.i colNameStr="" s colNameStr=result.GetColumnName(i)
	.e  s colNameStr=colNameStr_"^"_result.GetColumnName(i)
	s countrecords=0
	While(result.Next())
	{ 
		s ret=""
		f i=1:1:colNum d
		.i ret="" s ret=result.%GetData(i)
		.e  s ret=ret_"^"_result.%GetData(i)
		s countrecords=countrecords+1
		I countrecords=1 d
		.w "["
		.W ##class(web.DHCSTJQUERYCOMMON).getJsonData(colNameStr,ret)
		e  d
		.W ","_##class(web.DHCSTJQUERYCOMMON).getJsonData(colNameStr,ret)
	}
	q:countrecords=0 ##class(web.DHCSTJQUERYCOMMON).getJsonEmptySign(0) 
	w "]"
	q ""
}

Query RefuseReason() As %SQLQuery(ROWSPEC = "ID:%String,Code:%String,Desc:%String")
{
  select  Refuse_rowid,Refuse_code,Refuse_desc From PHR_RefuseReason where Refuse_rowid>0
}

ClassMethod CheckRefuseReason(rowid, icode, idesc) As %String
{
  s ret=0
  s orowid=""
  f  s orowid=$o(^PHRREFUSE(0,"Code",icode,orowid)) q:(orowid="")||(ret'=0)  d
  .q:orowid=rowid
  .s ret=-1
  q:ret'=0 ret
  s orowid=""
  f  s orowid=$o(^PHRREFUSE(0,"Desc",idesc,orowid)) q:(orowid="")||(ret'=0)  d
  .q:orowid=rowid
  .s ret=-2  
  q ret
}

}
