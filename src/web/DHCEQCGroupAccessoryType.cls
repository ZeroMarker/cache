Class web.DHCEQCGroupAccessoryType Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Parameter BUILD = 58;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

// 安全组访问类组

Parameter SQLCODE = "GAT_RowID";

Parameter SQLDESCRIPTION = "GAT_RowID";

Parameter SQLROWID = "GAT_RowID";

ClassMethod GroupAccessoryTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GroupAccessoryTypeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GroupAccessoryTypeExecute(ByRef qHandle As %Binary) As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s rowid=0
	d BuildDataGetGroupAccessoryType
	Quit $$$OK
BuildDataGetGroupAccessoryType
	f  s rowid=$o(^DHCEQCCode("DHCEQCGroupAccessoryType",rowid))  quit:rowid=""  d
	.d ResetVariablesGetGroupAccessoryType
	.s LROWID=rowid	//rowid
	.s LGroup=$p(^DHCEQCCode("DHCEQCGroupAccessoryType",rowid),"^",1)
	.i LGroup'="" s LTGroup=$p(^SSU("SSGRP",LGroup),"^",1)
	.s LTAccessoryTypeDR=$p($g(^DHCEQCCode("DHCEQCGroupAccessoryType",rowid)),"^",2) //
	.i LTAccessoryTypeDR'="" s LTAccessoryType=$p($g(^DHCEQCCode("DHCEQCAccessoryType",LTAccessoryTypeDR)),"^",2) //
	.s LTInvalidFlag=$p($g(^DHCEQCCode("DHCEQCGroupAccessoryType",rowid)),"^",3)
	.//q:LTInvalidFlag="Y"
	.d OutputGroupAccessoryType
	quit
OutputGroupAccessoryType
   s Data=$lb(LTGroup,LGroup,LROWID,LTAccessoryTypeDR,LTAccessoryType)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetGroupAccessoryType
	s (LTGroup,LGroup,LROWID,LTAccessoryTypeDR,LTAccessoryType)=""
	quit
}

ClassMethod GroupAccessoryTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GroupAccessoryTypeExecute ]
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

Query GroupAccessoryType() As %Query(ROWSPEC = "TGroup:%String,TGroupDR:%String,TRowID:%String,TAccessoryTypeDR:%String,TAccessoryType:%String")
{
}

ClassMethod GetDocByID(itmjs As %Library.String = "", itmjsex As %Library.String = "", rowid As %Library.String = "")
{
	new result,resultex
	s (result,resultex)=""
	s result= ^DHCEQCCode("DHCEQCUOM",rowid)
	s resultex=rowid
	s resultex=resultex_"^"	//
	i $p(result,"^",1)'=""  d
	.s resultex=resultex_$p(^DHCEQCCode("DHCEQCGroupAccessoryType",rowid),"^",1)
	s resultex=resultex_"^"	//
	i $p(result,"^",1)'=""  d
	.s resultex=resultex_$p(^SSU("SSGRP",$p(^DHCEQCCode("DHCEQCGroupAccessoryType",rowid),"^",1)),"^",1)
	s resultex=resultex_"^"	//
	i $p(result,"^",2)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCGroupAccessoryType",rowid)),"^",2)
	s resultex=resultex_"^"	//
	i $p(result,"^",2)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCAccessoryType",$p($g(^DHCEQCCode("DHCEQCGroupAccessoryType",rowid)),"^",2))),"^",2)
	q resultex
}

ClassMethod SaveData(itmjs As %Library.String = "", itmjsex As %Library.String = "", RowID As %Library.String = "", Codetable As %Library.String = "", isDel As %Library.String = "", DefaultFlag)
{
 k PLIST,rowid
  s PLIST(2) = RowID	;安全组
  s PLIST(3) = Codetable	;代码
  s PLIST(4) = DefaultFlag
  i (+isDel=1)
 {
  &SQL(select GAT_RowID into :Rowid from SQLUSER.DHC_EQCGroupAccessoryType where GAT_GroupDR=:RowID and GAT_AccessoryTypeDR=:Codetable)
 	if (Rowid="")
 	{
 	&SQL(Insert Into SQLUSER.DHC_EQCGroupAccessoryType Values :PLIST())
 	}
 	else
 	{
	 	&SQL(update SQLUSER.DHC_EQCGroupAccessoryType Values :PLIST() where GAT_RowID=:Rowid)
 	}
 }
 i (+isDel=2)
 {
  &SQL(select GAT_RowID into :Rowid from SQLUSER.DHC_EQCGroupAccessoryType where GAT_GroupDR=:RowID and GAT_AccessoryTypeDR=:Codetable)
 	if (Rowid'="")
 	{
 	&SQL(Delete From SQLUSER.DHC_EQCGroupAccessoryType where GAT_RowID = :Rowid)
 	q Rowid
 }
 }
 if SQLCODE  q SQLCODE
 Set ID=$g(%ROWID)
 q ID
}

Query Codetable(RowID As %String) As %Query(ROWSPEC = "TCodetable:%String,TROWID:%String,TPutIn:%String,TDefaultFlag:%String,TRow:%String")
{
}

ClassMethod CodetableExecute(ByRef qHandle As %Binary, RowID As %String) As %Status
{
	
	new repid, index
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s TRow=0
	n TRowID,TDesc,TDefaultFlag,TSelected,GETRowID
	s TRowID=0
	f  s TRowID=$o(^DHCEQCCode("DHCEQCAccessoryType",TRowID))  quit:TRowID=""  d
	.s (TSelected,TDefaultFlag)=""
	.q:$p(^DHCEQCCode("DHCEQCAccessoryType",TRowID),"^",4)="Y"
	.s TDesc=$p(^DHCEQCCode("DHCEQCAccessoryType",TRowID),"^",2)
	.s GETRowID=$o(^DHCEQCCode("DHCEQCGroupAccessoryType",0,"Group",RowID,TRowID,0))
	.i GETRowID'=""  d
	..s TSelected=##Class(web.DHCEQCommon).TransValueToPage("Y","bool")
	..s TDefaultFlag=$p(^DHCEQCCode("DHCEQCGroupAccessoryType",GETRowID),"^",3)
	..i TDefaultFlag'="" s TDefaultFlag=##Class(web.DHCEQCommon).TransValueToPage(TDefaultFlag,"bool")
	.
	.d OutputCodetable
	Quit $$$OK
OutputCodetable
	s TRow=TRow+1
   	s Data=$lb(TDesc,TRowID,TSelected,TDefaultFlag,TRow)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
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

ClassMethod CodetableClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = CodetableExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

}
