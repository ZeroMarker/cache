Import SQLUser

Class web.DHCEQCChangeType Extends %Library.RegisteredObject [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 5;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

//设备变动类型

Parameter SQLCODE = "CT_RowID";

Parameter SQLDESCRIPTION = "CT_RowID";

Parameter SQLROWID = "CT_RowID";

Parameter SQLFILTER = " (CT_InvalidFlag = 'N') ";

ClassMethod ChangeTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = ChangeTypeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod ChangeTypeExecute(ByRef qHandle As %Binary) As %Status
{
	new repid, index,rowid
	S repid=$I(^CacheTemp)
 	S qHandle=$lb(0,repid,0)
	s index=1
	s rowid=0
	d BuildDataGetChangeType
	Quit $$$OK
BuildDataGetChangeType
	f  s rowid=$o(^DHCEQCCode("DHCEQCChangeType",rowid))  quit:rowid=""  d
	.d ResetVariablesGetChangeType
	.s LRowID = rowid	//rowid
	.s LCode = $p($g(^DHCEQCCode("DHCEQCChangeType",rowid)),"^",1)	//代码
	.s LDesc = $p($g(^DHCEQCCode("DHCEQCChangeType",rowid)),"^",2)	//描述
	.s LRemark = $p($g(^DHCEQCCode("DHCEQCChangeType",rowid)),"^",3)	//备注
	.s LType= $p($g(^DHCEQCCode("DHCEQCChangeType",rowid)),"^",4)	//类型
	.s LInvalidFlag = $p($g(^DHCEQCCode("DHCEQCChangeType",rowid)),"^",5) //无效标志
	.d OutputRowGetChangeType
	quit
OutputRowGetChangeType
	s Data=$lb(LRowID,LCode,LDesc,LRemark,LType,LInvalidFlag)
	S ^CacheTemp(repid,index)=Data
	S index=index+1
	quit
ResetVariablesGetChangeType
	s (LRowID,LCode,LDesc,LRemark,LType,LInvalidFlag)=""
	quit
}

ClassMethod ChangeTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = ChangeTypeExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 		}
 	Else      {Set Row=^CacheTemp(repid,ind)}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

Query ChangeType() As %Query(ROWSPEC = "TRowID:%String,TCode:%String,TDesc:%String,TRemark:%String,TType:%String,TInvalidFlag:%String")
{
}

Storage Default
{
<Data name="DHCEQCChangeTypeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCEQCChangeTypeD</DataLocation>
<DefaultData>DHCEQCChangeTypeDefaultData</DefaultData>
<IdLocation>^web.DHCEQCChangeTypeD</IdLocation>
<IndexLocation>^web.DHCEQCChangeTypeI</IndexLocation>
<StreamLocation>^web.DHCEQCChangeTypeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
