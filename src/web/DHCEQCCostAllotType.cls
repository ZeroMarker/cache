Class web.DHCEQCCostAllotType Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Parameter BUILD = 6;

//成本分配方案

Parameter SQLCODE = "CAT_RowID";

Parameter SQLDATEFROM;

Parameter SQLDESCRIPTION = "CAT_RowID";

Parameter SQLDATETO;

Parameter SQLFILTER = " (CAT_InvalidFlag = 'N') ";

Parameter SQLROWID = "CAT_RowID";

Query LookUp(para) As %SQLQuery(ROWSPEC = "Description:%String,HIDDEN:%String,Code:%String")
{
SELECT CAT_Desc,
	   CAT_RowID,
	   CAT_Code
FROM sqluser.DHC_EQCCostAllotType
where CAT_InvalidFlag = 'N' and CAT_Desc like nvl(:para,'')||'%'
}

ClassMethod GetValueClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetValueExecute ]
{
	Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod GetValueExecute(ByRef qHandle As %Binary) As %Status
{
 new repid, index,rowid
	Set repid=$I(^CacheTemp)
 Set qHandle=$lb(0,repid,0)
	s index=1
	s rowid=0
	d BuildDataGetValue
	Quit $$$OK
BuildDataGetValue
	f  s rowid=$o(^DHCEQCCode("DHCEQCCostAllotType",rowid))  quit:rowid=""  d
	.d ResetVariablesGetValue
	.s LTRowID = rowid	//rowid
	.s LTCode = $p($g(^DHCEQCCode("DHCEQCCostAllotType",rowid)),"^",1)	//代码
	.s LTDesc = $p($g(^DHCEQCCode("DHCEQCCostAllotType",rowid)),"^",2)	//描述
	.s LTRemark = $p($g(^DHCEQCCode("DHCEQCCostAllotType",rowid)),"^",3)	//备注
	.s LTType= $p($g(^DHCEQCCode("DHCEQCCostAllotType",rowid)),"^",4)	//类型
	.s LTInvalidFlag = $p($g(^DHCEQCCode("DHCEQCCostAllotType",rowid)),"^",5) //无效标志
	.d OutputRowGetValue
	quit
OutputRowGetValue
	s Data=$lb(LTRowID,LTCode,LTDesc,LTRemark,LTType,LTInvalidFlag)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetValue
	s (LTRowID,LTCode,LTDesc,LTRemark,LTType,LTInvalidFlag)=""
	quit
}

ClassMethod GetValueFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetValueExecute ]
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

Query GetValue() As %Query(ROWSPEC = "TRowID:%String,TCode:%String,TDesc:%String,TRemark:%String,TType:%String,TInvalidFlag:%String")
{
}

}
