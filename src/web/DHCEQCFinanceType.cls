Class web.DHCEQCFinanceType Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// add by HHM  20150917 HHM0021
/// 财务大类
/// 新添：FinanceType、GetFinanceTypeByID
/// d ##Class(%ResultSet).RunQuery("web.DHCEQCFinanceType","FinanceType",'')
/// modified by sjh SJH0036 2020-20-13 输出列标题修改
Query FinanceType(FinanceType As %String) As %Query(ROWSPEC = "Hidden:%String,Code:%String:编码,Desc:%String:描述,Remark:%String:备注")
{
}

ClassMethod FinanceTypeExecute(ByRef qHandle As %Binary, FinanceType As %String) As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	s index=1
	s rowid=0
	f  s rowid=$o(^DHCEQCCode("DHCEQCFinanceType",rowid)) quit:rowid=""  d
	.d ResetVariablesGetFinanceType
	.s TRowID=rowid
	.s TInvalidFlag=$p($g(^DHCEQCCode("DHCEQCFinanceType",rowid)),"^",4)  ;add by kdf 2018-10-09 增加过滤 需求号：583597
	.q:TInvalidFlag="Y"
	.s TCode=$p($g(^DHCEQCCode("DHCEQCFinanceType",rowid)),"^",1)
	.s TDesc=$p($g(^DHCEQCCode("DHCEQCFinanceType",rowid)),"^",2)
	.s TRemark=$p($g(^DHCEQCCode("DHCEQCFinanceType",rowid)),"^",3)
	.d OutputRowGetFinanceType
	Quit $$$OK
OutputRowGetFinanceType
	s Data=$lb(TRowID,TCode,TDesc,TRemark)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetFinanceType
	s (TRowID,TCode,TDesc,TRemark)=""
	quit
}

ClassMethod FinanceTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FinanceTypeExecute ]
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

ClassMethod FinanceTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FinanceTypeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)

	Quit $$$OK
}

ClassMethod GetFinanceTypeByID(rowid)
{
	s Info=""
	i rowid'="" d
	.s Info=$g(^DHCEQCCode("DHCEQCFinanceType",rowid))
	q Info
}

}
