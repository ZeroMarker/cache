Import SQLUser

Class web.DHCEQCCycleUnit Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Parameter BUILD = 5;

// 周期单位

Parameter SQLCODE = "CU_Code";

Parameter SQLDATEFROM;

Parameter SQLDESCRIPTION = "CU_Desc";

Parameter SQLDATETO;

Parameter SQLROWID = "CU_RowID";

Parameter SQLFILTER = " (CU_InvalidFlag = 'N') ";

Query LookUp(para) As %SQLQuery(ROWSPEC = "Description:%String:名称,HIDDEN:%String,Code:%String:编码")
{
SELECT CU_Desc,
	   CU_RowID,
	   CU_Code
FROM sqluser.DHC_EQCCycleUnit
where CU_InvalidFlag = 'N' and CU_Desc like nvl(:para,'')||'%'
}

ClassMethod CycleUnitClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = CycleUnitExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod CycleUnitExecute(ByRef qHandle As %Binary) As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s rowid=0
	d BuildDataGetCycleUnit
	Quit $$$OK
BuildDataGetCycleUnit
	f  s rowid=$o(^DHCEQCCode("DHCEQCCycleUnit",rowid))  quit:rowid=""  d
	.d ResetVariablesGetCycleUnit
	.s LTRowID = rowid	//rowid
	.s LTCode = $p($g(^DHCEQCCode("DHCEQCCycleUnit",rowid)),"^",1)	//代码
	.s LTDesc = $p($g(^DHCEQCCode("DHCEQCCycleUnit",rowid)),"^",2)	//描述
	.s LTRemark = $p($g(^DHCEQCCode("DHCEQCCycleUnit",rowid)),"^",3)	//备注
	.s LTType= $p($g(^DHCEQCCode("DHCEQCCycleUnit",rowid)),"^",4)	//类型
	.s LTInvalidFlag = $p($g(^DHCEQCCode("DHCEQCCycleUnit",rowid)),"^",5) //无效标志
	.d OutputRowGetCycleUnit
	quit
OutputRowGetCycleUnit
	s Data=$lb(LTRowID,LTCode,LTDesc,LTRemark,LTType,LTInvalidFlag)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetCycleUnit
	s (LTRowID,LTCode,LTDesc,LTRemark,LTType,LTInvalidFlag)=""
	quit
}

ClassMethod CycleUnitFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = CycleUnitExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 		}
 	Else      {
 		Set Row=^CacheTemp(repid,ind)
 		}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

Query CycleUnit() As %Query(ROWSPEC = "TRowID:%String,TCode:%String,TDesc:%String,TRemark:%String,TType:%String,TInvalidFlag:%String")
{
}

/// 根据周期单位及周期单位数量 计算日期
/// 入参：
/// unit:DHCEQCCycleUnit周期单位DR
/// qty：周期数量
/// fromdate:起始日期
/// format:日期格式：默认格式为dd/mm/yyyy，1表示数字
/// 返回：
/// 	日期格式dd/mm/yyyy
/// w ##Class(web.DHCEQCCycleUnit).CycleUnitDate(1,2,"26/5/2011")
ClassMethod CycleUnitDate(unit As %String, qty As %String, fromdate As %String, format As %String = "")
{
	if (unit)="" q ""
	if qty="" q ""
	if fromdate="" q ""
	if format=1 s fromdate=$zd(fromdate,4)
	s unit=$p($g(^DHCEQCCode("DHCEQCCycleUnit",unit)),"^",4)
	if unit=1
	{
		s unit="YYYY"
	}
	elseif unit="2"
	{
		s unit="M"
	}
	elseif unit="3"
	{
		s unit="D"
	}
	else
	{
		q ""
	}
	s fromdate=##Class(web.DHCEQCommon).DateAdd(unit,qty,fromdate)
	if format=1 s fromdate=$zdh(fromdate,4) 
	q fromdate
}

}
