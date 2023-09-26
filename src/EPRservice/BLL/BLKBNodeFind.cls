/// creator: Candyxu
/// date: 2012-02-17
/// desc: KBNODE 操作
Class EPRservice.BLL.BLKBNodeFind Extends (%RegisteredObject, %XML.Adaptor) [ Not ProcedureBlock ]
{

Query SELECTInUseBYPARENTID(KBTreeID As %String = "") As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID:%Integer,Name:%String,KBTreeID:%String,KnowledgeBaseID:%String ,Description:%String,IsCommon:%String", SELECTMODE = "RUNTIME") [ SqlName = SP_KBNode_SELECTInUseBYPARENTID, SqlProc ]
{
	 SELECT ID, Name, KBTreeID,KnowledgeBaseID, Description,IsCommon
	 FROM EPRmeta.KBNode
	 WHERE (KBTreeID = :KBTreeID) and (IsInUse = 'Y' or IsInUse is null)
	 ORDER BY Sequence
}

Query SELECTBYPARENTID(KBTreeID As %String = "") As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID:%Integer,Name:%String,KBTreeID:%String,KnowledgeBaseID:%String ,Description:%String,IsCommon:%String", SELECTMODE = "RUNTIME") [ SqlName = SP_KBNode_SELECTBYPARENTID, SqlProc ]
{
	 SELECT ID, Name, KBTreeID,KnowledgeBaseID, Description,IsCommon
	 FROM EPRmeta.KBNode
	 WHERE (KBTreeID = :KBTreeID)
	 ORDER BY Sequence
}

/// Desc: 按节点名称模糊查找
/// Debug: do ##class(%ResultSet).RunQuery("EPRservice.BLL.BLKBNodeFind","SELECTBYNAME","主诉","133")
Query SELECTBYNAME(PKBName As %String, KnowledgeBaseID As %String) As %Query(ROWSPEC = "ID:%Integer,Name:%String,KBTreeID:%String")
{
}

ClassMethod SELECTBYNAMEExecute(ByRef qHandle As %Binary, PKBName As %String, KnowledgeBaseID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	q:(PKBName = "")||(PKBName = $c(0)) $$$OK
 	Set KnowledgeBaseID = " "_KnowledgeBaseID
 	Set KBRowID = "0"
 	for {
	 	set KBRowID = $o(^DHCEPRM.KBNodeI("IdxKBKnowledgeBaseID",KnowledgeBaseID,KBRowID))
	 	q:(KBRowID = "")
	 	
	 	set Name = $li(^DHCEPRM.KBNodeD(KBRowID),4)
	 	if ($F(Name,PKBName) = 0) continue
	 	set TreeID = $li(^DHCEPRM.KBNodeD(KBRowID),3)
	 	set data = $lb(KBRowID,Name,TreeID)
	    set ^CacheTemp(repid,ind)=data
	    set ind=ind+1  	 
	
	}
	Quit $$$OK
}

ClassMethod SELECTBYNAMEClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SELECTBYNAMEExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod SELECTBYNAMEFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SELECTBYNAMEExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 		kill ^CacheTemp(repid)
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)	
	Quit $$$OK
}

}
