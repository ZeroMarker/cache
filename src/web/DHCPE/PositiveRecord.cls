Class web.DHCPE.PositiveRecord Extends %RegisteredObject
{

ClassMethod Update(InString As %Library.String = "", Type As %String = "P")
{
	s rowid=$P(InString,"^",1)
	s code=$p(InString,"^",2)
	s name=$p(InString,"^",3)
	s mseq=$p(InString,"^",4)
	s fseq=$p(InString,"^",5)
	s UseRange=$p(InString,"^",6)
	s:UseRange="" UseRange="S"
	s UserDR=$p(InString,"^",7)
	i rowid="" d
	.&sql(insert into sqluser.DHC_PE_PositiveRecord(P_Code,P_Name,P_MSequence,P_FSequence,PR_Type,PR_UseRange,PR_User_DR)
		values (:code,:name,:mseq,:fseq,:Type,:UseRange,:UserDR))
	.s:SQLCODE=0 rowid=%ROWID
	e  d
	.&sql(update sqluser.DHC_PE_PositiveRecord set P_Code =:code,P_Name =:name,P_MSequence=:mseq,P_FSequence=:fseq,PR_UseRange=:UseRange,PR_User_DR=:UserDR where ID=:rowid)
	Q SQLCODE_"^"_rowid
}

ClassMethod SavePositiveItem(ParRef, Items)
{
	k ^User.DHCPEPositiveRecordD(ParRef,"Item")
	s ItemLength=$L(Items,"$")
	f i=1:1:ItemLength  d
	.s ItemID=$P(Items,"$",i)
	.s ^User.DHCPEPositiveRecordD(ParRef,"Item",ItemID)=""
	q 0
}

Query FindPositiveRecord(Type As %String = "P", iCode As %String = "", iDesc As %String = "", iMSeq As %String = "", iFSeq As %String = "", iUserRange As %String = "") As %Query(ROWSPEC = "ID:%String,Code:%String,Name:%String,MSeq:%String,FSeq:%String,TUseRange:%String")
{
}

ClassMethod FindPositiveRecordExecute(ByRef qHandle As %Binary, Type As %String = "P", iCode As %String = "", iDesc As %String = "", iMSeq As %String = "", iFSeq As %String = "", iUserRange As %String = "") As %Status
{
      Set repid=$I(^CacheTemp)
      s ind=1
      s UserID=%session.Get("LOGON.USERID")
      s:Type="" Type="P"
      s:iUserRange="" iUserRange="S" 
      s ID=0
      f  s ID=$o(^User.DHCPEPositiveRecordI("TypeIndex",Type,ID)) q:ID=""  d
      .s Code=$listget(^User.DHCPEPositiveRecordD(ID),2)
      .q:((iCode'="")&&(Code'[iCode))
	  .s Name=$listget(^User.DHCPEPositiveRecordD(ID),3)
	  .q:((iDesc'="")&&(Name'[iDesc))
	  .s MSeq=$listget(^User.DHCPEPositiveRecordD(ID),4)
	  .q:((iMSeq'="")&&(MSeq'=iMSeq))
	  .s FSeq=$listget(^User.DHCPEPositiveRecordD(ID),5)
	  .q:((iFSeq'="")&&(FSeq'=iFSeq))
	  .s PRType=$listget(^User.DHCPEPositiveRecordD(ID),6)
	  .s PRUser=$listget(^User.DHCPEPositiveRecordD(ID),7)
	  .s TUseRange="否"
	  .s PRUseRange=$listget(^User.DHCPEPositiveRecordD(ID),8)
	  .q:((iUserRange'="")&&(PRUseRange'=iUserRange))
	  .q:(PRUseRange="U")&&(PRUser'=UserID)
	  .s:PRUseRange="S" TUseRange="是"
      .Do FindBuild
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
FindBuild
      set Data=$lb(ID,Code,Name,MSeq,FSeq,TUseRange)
      Set ^CacheTemp(repid,ind)=Data
      Set ind=ind+1
      quit
}

ClassMethod FindPositiveRecordFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindPositiveRecordExecute ]
{
	
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else{			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind) 
	Quit $$$OK
}

ClassMethod FindPositiveRecordClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindPositiveRecordExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

}
