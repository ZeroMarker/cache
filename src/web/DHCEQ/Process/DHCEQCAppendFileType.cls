Class web.DHCEQ.Process.DHCEQCAppendFileType Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// 获取业务可访问图片类型
/// w ##Class(%ResultSet).RunQuery("web.DHCEQ.Process.DHCEQCAppendFileType","GetAppendFileType")
Query GetAppendFileType() As %Query(ROWSPEC = "TRowID:%String,TCode:%String,TDesc:%String")
{
}

ClassMethod GetAppendFileTypeExecute(ByRef qHandle As %Binary) As %Status
{
	new repid, index
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	s index=1
	d BuildDataGetAppendFileType
	
	Quit $$$OK	
BuildDataGetAppendFileType
	s AppendFileTypeDR=0
	for  s AppendFileTypeDR=$o(^DHCEQCCode("DHCEQCAppendFileType",AppendFileTypeDR)) q:AppendFileTypeDR=""  d
	.d ResetVariablesLookUpInfo
	.s TRowID=AppendFileTypeDR
	.s TCode=$p(^DHCEQCCode("DHCEQCAppendFileType",AppendFileTypeDR),"^",1)
	.s TDesc=$p(^DHCEQCCode("DHCEQCAppendFileType",AppendFileTypeDR),"^",2)
	.d OutputRowLookUpInfo
	quit
OutputRowLookUpInfo
	s Data=$lb(TRowID,TCode,TDesc)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesLookUpInfo
	Set (TRowID,TCode,TDesc)=""
	Quit
}

ClassMethod GetAppendFileTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAppendFileTypeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetAppendFileTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAppendFileTypeExecute ]
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

/// w ##Class(web.DHCEQ.Process.DHCEQCAppendFileType).SaveData("^1^效益文档^^N")
ClassMethod SaveData(AFTData)
{
	new PList
	s PList(1)=$p($G(AFTData),"^",1)
	s PList(2)=$p($G(AFTData),"^",2)
	s PList(3)=$p($G(AFTData),"^",3)
	s PList(5)=$p($G(AFTData),"^",5)
	i (PList(1)="")
	{
		b //1
		k PList(1)
		&SQL(insert into SQLUser.DHC_EQCAppendFileType values :PList())
	}
	else
	{
		k PList(1)
		&SQL(Update SQLUser.DHC_EQCAppendFileType values :PList() where AFT_RowID=:PList(1))
	}
	b
	q:SQLCODE SQLCODE
	q $g(%ROWID)
}

}
