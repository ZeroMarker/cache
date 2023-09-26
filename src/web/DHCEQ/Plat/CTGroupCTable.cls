Import SQLUser

Class web.DHCEQ.Plat.CTGroupCTable Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Modified By CSJ 2018-10-23 
/// 描述: 安全组访问代码表HISUI改造：按规范修改Query输出列
/// 入参:安全组id
/// 访问表：DHC_EQCGroupCTable
/// 输出列：TCodeTable,TRowid,TPutIn,TRow
/// 返回值:无
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.Plat.CTGroupCTable","CodeTable","1")
Query CodeTable(RowID As %String) As %Query(ROWSPEC = "TCodeTable:%String,TRowid:%String,TPutIn:%String,TRow:%String")
{
}

ClassMethod CodeTableClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = CodetableExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod CodeTableExecute(ByRef qHandle As %Binary, RowID As %String) As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s rowid=0
	s TRow=0
	d BuildDataGetCodetable
	Quit $$$OK
BuildDataGetCodetable
	f  s rowid=$o(^DHCEQCCodeTable(rowid))  quit:rowid=""  d
	.d ResetVariablesGetCodetable
	.s TRowid=rowid	//rowid
	.s TCodeTable=$p(^DHCEQCCodeTable(rowid),"^",2)
	.q:$p(^DHCEQCCodeTable(rowid),"^",5)=1
	.q:$p(^DHCEQCCodeTable(rowid),"^",4)'=1
	.d Buildput
	.d OutputCodetable
	quit
Buildput
    s srowid=0
	f  s srowid=$o(^DHCEQCCode("DHCEQCGroupCTable",srowid))  quit:srowid=""  d
	.s GroupDR=$p(^DHCEQCCode("DHCEQCGroupCTable",srowid),"^",1)
	.s CodeTableDR=$p(^DHCEQCCode("DHCEQCGroupCTable",srowid),"^",2)
	.if ((RowID=GroupDR) & (CodeTableDR=TRowid)) d
	..s TPutIn="Y"
 quit
OutputCodetable
	s TRow=TRow+1
   	s Data=$lb(TCodeTable,TRowid,TPutIn,TRow)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetCodetable
	s (TCodeTable,TRowid,TPutIn)=""
	quit
}

ClassMethod CodeTableFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = CodetableExecute ]
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

ClassMethod SaveData(RowID As %Library.String = "", Codetable As %Library.String = "", isDel As %Library.String = "")
{
 k PLIST,rowid
  s SQLCODE=0
  s PLIST(2) = RowID	;安全组
  s PLIST(3) = Codetable	;代码
  i (+isDel=1)
 {
  &SQL(select GCT_RowID into :Rowid from DHC_EQCGroupCTable where GCT_GroupDR=:RowID and GCT_CodeTableDR=:Codetable)
 	if (Rowid="")
 	{
 	&SQL(Insert Into SQLUSER.DHC_EQCGroupCTable Values :PLIST())
 	}
 	else
 	{
	 	q Rowid
 	}
 }
 i (+isDel=2)
 {
    &SQL(select GCT_RowID into :Rowid from DHC_EQCGroupCTable where GCT_GroupDR=:RowID and GCT_CodeTableDR=:Codetable)
 	if (Rowid'="")
 	{
 	&SQL(Delete From SQLUSER.DHC_EQCGroupCTable where GCT_RowID = :Rowid)
 	q Rowid
 	}
 }
 if SQLCODE  q SQLCODE
 Set ID=$g(%ROWID)
 q ID
}

}
