Import sqluser

/// Descript:药品调价原因维护
/// Creater:    zhangxiao
/// CreateDate: 2013-7-26
Class web.DHCST.InStkTkWindow Extends (%RegisteredObject, StkTypeG) [ Not ProcedureBlock ]
{

/// Descript:   保存/更新盘点窗口
/// Creater:    zhangxiao
/// CreateDate: 2013-7-26
/// Table:DHC_InStkTkWindow
/// Input:数据串:rowid^代码^描述^科室id,rowid^代码^描述^科室id
/// Output:     
/// Return："" : 成功，非空：失败
/// w ##class(web.DHCST.InStkTkWindow).Save("^011^22^102")
ClassMethod Save(listData As %String) As %Library.String
{
	n (listData)
	s rowDelim=##class(web.DHCST.Common.UtilCommon).RowDataDelim()
	i listData="" d
	.s len=0
	e  d
	.s len=$l(listData,rowDelim)
	s msg=0
	s err=""
	f i=1:1:len q:msg'=0  d
	.s data=$p(listData,rowDelim,i)
	.s rowid=$p(data,"^",1)
	.s code=$p(data,"^",2)
	.s desc=$p(data,"^",3)
	.s locid=$p(data,"^",4)
	.q:code=""
	.q:desc=""
	.s tmpid=""
    .&SQL(SELECT STTKW_RowID into :tmpid FROM DHC_InStkTkWindow WHERE STTKW_Code=:code AND STTKW_CTLOC_DR=:locid)
    .s:(tmpid'="")&(tmpid'=rowid) msg=-1
    .s tmpid=""
    .&SQL(SELECT STTKW_RowID into :tmpid FROM DHC_InStkTkWindow WHERE STTKW_Desc=:desc AND STTKW_CTLOC_DR=:locid)
    .s:(tmpid'="")&(tmpid'=rowid) msg=-2
    .q:msg'=0
	.i rowid'="" d
	..s ret=..Update(rowid,code,desc,locid)
	..s:ret'=0 err=err //_","_ret
	.e  d
	..s ret=..Insert(code,desc,locid)
	..s:ret'="" err=err //_","_desc
	q:msg=-1 msg 
	q:msg=-2 msg 
	q:msg'=0 msg
	q err
}

/// Descript:   增加科室盘点窗口
/// Creater:    zhangxiao
/// CreateDate: 2013-7-26
/// Table:DHC_InStkTkWindow
/// Input:代码,描述,科室id
/// Output:     
/// Return：rowid
ClassMethod Insert(code As %String, desc As %String, locid As %String) As %Library.String [ Private ]
{
	n (code,desc,locid)
	q:code=""
	q:desc=""
	q:locid=""
	s Err=0
	&sql(Insert into DHC_InStkTkWindow (STTKW_CTLOC_DR,STTKW_Code,STTKW_Desc) values (:locid,:code,:desc))
	i SQLCODE'=0 d
	.s rett=$$ErrorRecord^DHCSTERROR("Insert:DHC_InStkTkWindow",desc,SQLCODE_":"_%msg)
	.s Err=-1
    q:Err'=0 ""
	//q:SQLCODE'=0 ""
	q $p(%ROWID,$c(1))
}

/// Descript:   更新科室盘点窗口
/// Creater:    zhangxiao
/// CreateDate: 2013-7-26
/// Table:DHC_InStkTkWindow
/// Input:rowid^代码^描述^科室id
/// Output:     
/// Return：rowid
ClassMethod Update(rowid As %String, code As %String, desc As %String, locid As %String) As %Library.String [ Private ]
{
	n (rowid,code,desc,locid)
	q:rowid="" ""
	q:code="" ""
	q:desc="" ""
	s Err=""
	&sql(Update DHC_InStkTkWindow set STTKW_Code=:code,STTKW_Desc=:desc where STTKW_RowID=:rowid)
	i SQLCODE'=0 d
	.s rett=$$ErrorRecord^DHCSTERROR("Update:DHC_InStkTkWindow",desc,SQLCODE_":"_%msg)
	.s Err=-1
    q Err
	//q SQLCODE
}

///  Descript:   查询科室盘点窗口
/// Creater:     zhangxiao
/// CreateDate: 2013-7-26
/// Table:DHC_InStkTkWindow
/// Input:rowid
/// Output:     
/// Return：0 – 成功，非0 ：失败
ClassMethod Delete(rowid As %String) As %Library.String
{
	n (rowid)
	q:rowid="" ""
	&sql(Delete from DHC_InStkTkWindow where STTKW_RowID=:rowid)
	i SQLCODE'=0 d
	.s rett=$$ErrorRecord^DHCSTERROR("Delete:DHC_InStkTkWindow",rowid,SQLCODE_":"_%msg)
	q SQLCODE
}

/// Descript:   查询科室盘点窗口
/// Creater:     zhangxiao
/// CreateDate: 2013-7-26
/// Table:DHC_InStkTkWindow
/// Input:
/// Output:     
/// Return：科室盘点窗口信息
/// w ##class(web.DHCST.InStkTkWindow).SelectAll()
ClassMethod SelectAll(LocId)
{
	n (LocId)
 	s result = ##class(%Library.ResultSet).%New()
 	s sqlStr="select STTKW_RowID as RowId, STTKW_Code as Code,STTKW_Desc as Description from DHC_InStkTkWindow where STTKW_CTLOC_DR="_LocId
	d result.Prepare(sqlStr)
 	d result.Execute()
	s count=0
	s resultString=""
	s json=##class(Code.JsonObj).%New()
	While(result.Next())
	 {
		 s Rowid=result.Data("RowId")
		 CONTINUE:+Rowid=0
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

}
