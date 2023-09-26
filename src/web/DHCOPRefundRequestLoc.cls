Import SQLUser

Class web.DHCOPRefundRequestLoc Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Parameter BUILD = 0;

ClassMethod GetGroupDetailClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetGroupDetailExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetGroupDetailExecute(ByRef qHandle As %Binary) As %Status
{
	;New repid, index
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
	s index=1
	d ResetVariablesFR
	s myIdx=0
	s RLRowid=0
	f  s RLRowid=$o(^DHCOPRefundRequestLoc(RLRowid)) q:RLRowid=""  d
	.s myIdx=+myIdx+1
	.s No=myIdx
	.s TRowid=RLRowid
	.s GroupDr=$p(^DHCOPRefundRequestLoc(RLRowid),"^",1)
	.s:(GroupDr'="") GroupDesc=$p($g(^SSU("SSGRP",GroupDr)),"^",1)
	.s LocDr=$p(^DHCOPRefundRequestLoc(RLRowid),"^",2)
	.s:(LocDr'="") LocDesc=$p($g(^CTLOC(LocDr)),"^",2)
	.d OutputFR
	Quit $$$OK
ResetVariablesFR
	s (No,TRowid, GroupDesc, LocDesc, GroupDr, LocDr)=""
	quit
OutputFR
	s Data=$lb(No,TRowid,GroupDesc,LocDesc,GroupDr,LocDr)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
}

ClassMethod GetGroupDetailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetGroupDetailExecute ]
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

Query GetGroupDetail() As %Query(ROWSPEC = "No:%String,TRowID:%String,TGroupDesc:%String,TLocDesc:%String,TGroupRowID:%String,TLocRowID:%String")
{
}

Query GetGroup() As %SQLQuery(CONTAINID = 1)
{
	SELECT SSGRP_RowId,SSGRP_Desc FROM SS_Group order by SSGRP_Desc
}

Query GetCTLoc() As %SQLQuery(CONTAINID = 1)
{
	SELECT ADMLOC_CTLOC_DR,ADMLOC_CTLOC_DR->CTLOC_Desc FROM PAC_AdmTypeLocation where ADMLOC_AdmType='O' order by ADMLOC_CTLOC_DR->CTLOC_Desc
}

ClassMethod InsertGrpRefLoc(GroupDR As %String, LocDr As %String, GRLInfo As %String) As %String
{
	n (GroupDR, LocDr, GRLInfo)
	
	s myrtn=0
	q:(GroupDR="") -200
	q:(LocDr="") -200
	s myPRowID=0
	s myFlag=0   ;$d
	f  s myPRowID=$o(^DHCOPRefundRequestLoc(0,"RL",GroupDR,LocDr,myPRowID)) q:(myPRowID="")  d
	.s LocRowID=$p(^DHCOPRefundRequestLoc(myPRowID),"^",2)
	.i LocDr=LocRowID  d
	..s myFlag=1
	q:(+myFlag=1) -201
	k PLIST
	s mylen=$l(GRLInfo,"^")
	f i=1:1:mylen  d
	.q:($p(GRLInfo,"^",i)="")
	.s PLIST(i)=$p(GRLInfo,"^",i)   
	s PLIST(5)=$p($h,",",1)
	s PLIST(6)=$p($h,",",2)
	s myrtn=##class(web.DHCOPRefundRequestLoc).INSERT()
	q myrtn
}

ClassMethod INSERT()
{
	K PLIST(1)
	s $ZT="ERROR^DHCSSERR"  d ..tb()
	&sql(INSERT INTO DHC_OPRefundRequestLoc Values PLIST())
	d ..tc()
	s myRowID=%ROWID
	i 'SQLCODE d ..SELECT(myRowID)
	q SQLCODE
}

ClassMethod SELECT(RowId)
{
	k PLIST
	&sql(SELECT * INTO PLIST() FROM DHC_OPRefundRequestLoc WHERE RL_Rowid= :RowId) 
	s PLIST=$o(PLIST(""),-1)
	q SQLCODE
	;
}

ClassMethod DelGroupRefLoc(PPMRowID As %String) As %String
{
	n (PPMRowID)
	s myrtn=0
	q:(PPMRowID="")
	s myrtn=##class(web.DHCOPRefundRequestLoc).DELETE(PPMRowID)
	q myrtn
}

ClassMethod DELETE(RowId)
{
	s $ZT="ERROR^DHCSSERR" d ..tb()
	&sql(DELETE FROM DHC_OPRefundRequestLoc WHERE RL_Rowid= :RowId)
	d ..tc()
	q SQLCODE
}

ClassMethod EditGroupRefLoc(PPMRowID As %String, PPMInfo As %String) As %String
{
	n (PPMRowID, PPMInfo)
}

ClassMethod tb()
{
	n SQLCODE
	TSTART  s SQLCODE=$zu(34)
	q
}

ClassMethod tc()
{
	n SQLCODE
	TCOMMIT  s SQLCODE=$zu(34)
	q
}

}
