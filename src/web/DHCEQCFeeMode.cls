Import SQLUser

Class web.DHCEQCFeeMode Extends %Library.RegisteredObject [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 5;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

//费用方式

Parameter SQLCODE = "FM_RowID";

Parameter SQLDESCRIPTION = "FM_RowID";

Parameter SQLROWID = "FM_RowID";

Parameter SQLFILTER = " (FM_InvalidFlag = 'N') ";

ClassMethod FeeModeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FeeModeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FeeModeExecute(ByRef qHandle As %Binary) As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s rowid=0
	d BuildDataGetFeeMode
	Quit $$$OK
BuildDataGetFeeMode
	f  s rowid=$o(^DHCEQCCode("DHCEQCFeeMode",rowid))  quit:rowid=""  d
	.d ResetVariablesGetFeeMode
	.s LTRowID = rowid	//rowid
	.s LTCode = $p($g(^DHCEQCCode("DHCEQCFeeMode",rowid)),"^",1)	//代码
	.s LTDesc = $p($g(^DHCEQCCode("DHCEQCFeeMode",rowid)),"^",2)	//描述
	.s LTRemark = $p($g(^DHCEQCCode("DHCEQCFeeMode",rowid)),"^",3)	//备注
	.s LTType= $p($g(^DHCEQCCode("DHCEQCFeeMode",rowid)),"^",4)	//类型
	.s LTInvalidFlag = $p($g(^DHCEQCCode("DHCEQCFeeMode",rowid)),"^",5) //无效标志
	.d OutputRowGetFeeMode
	quit
OutputRowGetFeeMode
	s Data=$lb(LTRowID,LTCode,LTDesc,LTRemark,LTType,LTInvalidFlag)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetFeeMode
	s (LTRowID,LTCode,LTDesc,LTRemark,LTType,LTInvalidFlag)=""
	quit
}

ClassMethod FeeModeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FeeModeExecute ]
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

Query FeeMode() As %Query(ROWSPEC = "TRowID:%String,TCode:%String,TDesc:%String,TRemark:%String,TType:%String,TInvalidFlag:%String")
{
}

Storage Default
{
<Data name="DHCEQCFeeModeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCEQCFeeModeD</DataLocation>
<DefaultData>DHCEQCFeeModeDefaultData</DefaultData>
<IdLocation>^web.DHCEQCFeeModeD</IdLocation>
<IndexLocation>^web.DHCEQCFeeModeI</IndexLocation>
<StreamLocation>^web.DHCEQCFeeModeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
