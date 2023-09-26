Import SQLUser

Class web.DHCLabConditionQuery Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// RejectType 拒收类型Query
/// D ##class(%ResultSet).RunQuery("web.DHCLabConditionQuery","RejectType","")
Query RejectType(code As %String) As %Query(ROWSPEC = "RejReason:%String,code:%String") [ SqlProc ]
{
}

ClassMethod RejectTypeExecute(ByRef qHandle As %Binary, code As %String) As %Status
{
 	S repid=$I(^CacheTemp)
 	If $G(ind)="" S ind=1
 	S Config=##Class(websys.Configuration).%OpenId(1)
    S LabNameSapce=Config.LabDataNamespace
    S:'$l(LabNameSapce) LabNameSapce="LABDATA"
    S code=""
    S RejReason="所有"
    S Data=$lb(RejReason,code)
 	D OutputRow1 	
	S cnt=1
	S seq="" F  S seq=$O(^[LabNameSapce]DHCREJECTTYPE(0,"SEQ",seq)) Q:seq=""  D
	.S code="" F  S code=$O(^[LabNameSapce]DHCREJECTTYPE(0,"SEQ",seq,code)) Q:code=""  D
	..S Active=$P(^[LabNameSapce]DHCREJECTTYPE(code),"\",3)
	..S Active=$P(Active,$C(1),1)
	..I Active'="Y" Q
	..S RejReason=$P(^[LabNameSapce]DHCREJECTTYPE(code),"\",1)
	..S RejReason=$P(RejReason,$C(1),1)
	..S Data=$lb(RejReason,code)
 	..D OutputRow1 	 	
 	S qHandle=$lb(0,repid,0)
	Q $$$OK
OutputRow1
	S Data=$lb(RejReason,code)
 	S ^CacheTemp(repid,ind)=Data
 	S ind=ind+1
	Q
}

ClassMethod RejectTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = RejectTypeExecute ]
{
 	S AtEnd=$LIST(qHandle,1)
 	S repid=$LIST(qHandle,2)
 	S ind=$LIST(qHandle,3)
	//
 	S ind=$O(^CacheTemp(repid,ind))
 	I ind="" {				// if there are no more rows, finish fetching
 		S AtEnd=1
 		S Row=""
 	}
 	Else      {				// fetch row
 		S Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	S qHandle=$lb(AtEnd,repid,ind)
	Q $$$OK
}

ClassMethod RejectTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = RejectTypeExecute ]
{
	S repid=$LIST(qHandle,2)
 	K ^CacheTemp(repid)
 	Q $$$OK
}

}
