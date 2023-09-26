Import SQLUser

Class web.DHCEQCGroupCTable Extends %Library.RegisteredObject [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 10;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

// 安全组访问设备代码

Parameter SQLCODE = "GCT_RowID";

Parameter SQLDESCRIPTION = "GCT_RowID";

Parameter SQLROWID = "GCT_RowID";

ClassMethod CodetableClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = CodetableExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod CodetableExecute(ByRef qHandle As %Binary, RowID As %String) As %Status
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
	.s LROWID=rowid	//rowid
	.s LCodetable=$p(^DHCEQCCodeTable(rowid),"^",2)
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
	.if ((RowID=GroupDR) & (CodeTableDR=LROWID)) d
	..s LPutIn=1
 quit
OutputCodetable
	s TRow=TRow+1
   	s Data=$lb(LCodetable,LROWID,LPutIn,TRow)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetCodetable
	s (LCodetable,LROWID,LPutIn)=""
	quit
}

ClassMethod CodetableFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = CodetableExecute ]
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

Query Codetable(RowID As %String) As %Query(ROWSPEC = "TCodetable:%String,TROWID:%String,TPutIn:%String,TRow:%String")
{
}

ClassMethod GroupClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GroupExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GroupExecute(ByRef qHandle As %Binary, Group As %String) As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	s TRow=0
	s index=1
	s rowid=0
	d BuildDataGetGroup
	Quit $$$OK
BuildDataGetGroup 
	f  s rowid=$o(^SSU("SSGRP",rowid))  quit:rowid=""  d
	.d ResetVariablesGetGroup
	.s LROWID=rowid	//rowid
	.s LGroup=$p(^SSU("SSGRP",rowid),"^",1)
	.q:(LGroup'[Group)
	.d OutputGroup
	quit
OutputGroup
	s TRow=TRow+1
   	s Data=$lb(LGroup,LROWID,TRow)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetGroup
	s (LGroup,LROWID)=""
	quit
}

ClassMethod GroupFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GroupExecute ]
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

Query Group(Group As %String) As %Query(ROWSPEC = "TGroup:%String,TRowID:%String,TRow:%String")
{
}

ClassMethod GroupCTableClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GroupCTableExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GroupCTableExecute(ByRef qHandle As %Binary) As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s rowid=0
	d BuildDataGetGroupCTable
	Quit $$$OK
BuildDataGetGroupCTable
	f  s rowid=$o(^DHCEQCCode("DHCEQCGroupCTable",rowid))  quit:rowid=""  d
	.d ResetVariablesGetGroupCTable
	.s LROWID=rowid	//rowid
	.s LGroup=$p(^DHCEQCCode("DHCEQCGroupCTable",rowid),"^",1)
	.i LGroup'="" s LTGroup=$p(^SSU("SSGRP",LGroup),"^",1)
	.s LCodetable=$p(^DHCEQCCode("DHCEQCGroupCTable",rowid),"^",2)
	.i LCodetable'="" s LTCodetable=$p(^DHCEQCCode("DHCEQCCodeTable",LCodetable),"^",2)
	.d OutputGroupCTable
	quit
OutputGroupCTable
   s Data=$lb(LTGroup,LTCodetable,LROWID)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetGroupCTable
	s (LTGroup,LTCodetable,LROWID)=""
	quit
}

ClassMethod GroupCTableFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GroupCTableExecute ]
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

Query GroupCTable() As %Query(ROWSPEC = "TGroup:%String,TCodetable:%String,TRowID:%String")
{
}

ClassMethod SaveData(itmjs As %Library.String = "", itmjsex As %Library.String = "", RowID As %Library.String = "", Codetable As %Library.String = "", isDel As %Library.String = "")
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

ClassMethod GetCodeID(itmjs As %Library.String = "", itmjsex As %Library.String = "", rowid As %Library.String = "")
{
	new result,resultex
	s (result,resultex)=""
	s result= ^DHCEQCCode("DHCEQCGroupCTable",rowid)
	s resultex=rowid
	s resultex=resultex_"^"	//安全组
	i $p(result,"^",1)'=""  d
	.s Group=$p($g(^DHCEQCCode("DHCEQCGroupCTable",rowid)),"^",1)
	.s resultex=resultex_Group
	s resultex=resultex_"^"	//代码表
	i $p(result,"^",2)'=""  d
	.s Codetable=$p($g(^DHCEQCCode("DHCEQCGroupCTable",rowid)),"^",2)
	.s resultex=resultex_Codetable
	s resultex=resultex_"^"	//安全组代码
	i $p(result,"^",2)'=""  d
	.s resultex=resultex_$p(^SSU("SSGRP",Group),"^",1)
	s resultex=resultex_"^"	//代码表代码
	i $p(result,"^",2)'=""  d
	.s resultex=resultex_$p(^DHCEQCCode("DHCEQCCodeTable",Codetable),"^",2)
	q resultex
}

}
