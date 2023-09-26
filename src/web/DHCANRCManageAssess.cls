Import SQLUSER

Class web.DHCANRCManageAssess Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// d ##class(%ResultSet).RunQuery("web.DHCANRCManageAssess","FindManageAssess")
Query FindManageAssess() As %Query(ROWSPEC = "anrcmaRowId,anrcrcId,anrcrcDesc,opType,opTypeDesc,anrcmcId,anrcmcDesc,ctlocId,ctlocDesc,maxAge")
{
}

ClassMethod FindManageAssessExecute(ByRef qHandle As %Binary) As %Status
{
    Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
	//ANRCMA_RowId
	//AnrcrcId,OPType,AnrcmcId,CtlocId,MaxAge
	s anrcmaRowId=0  f  s anrcmaRowId=$o(^DHCANRC("ManageAssess",anrcmaRowId)) q:anrcmaRowId=""  d
	.s anrcrcId=$li($g(^DHCANRC("ManageAssess",anrcmaRowId)),1)
	.s anrcrcInfo=$g(^DHCANRC("RiskClass",anrcrcId))
	.q:anrcrcInfo=""
	.s anrcrcDesc=$li($g(^DHCANRC("RiskClass",anrcrcId)),2)
	.s opType=$li($g(^DHCANRC("ManageAssess",anrcmaRowId)),2)
	.s opTypeDesc=""
	.i opType="B" s opTypeDesc="择期"
	.i opType="R" s opTypeDesc="限期"
	.i opType="E" s opTypeDesc="急诊"
	.s anrcmcId=$li($g(^DHCANRC("ManageAssess",anrcmaRowId)),3)
	.s anrcmcDesc=$li($g(^DHCANRC("ManageClass",anrcmcId)),2)
	.s ctlocId=$li($g(^DHCANRC("ManageAssess",anrcmaRowId)),4)
	.s ctlocDesc=$p($p($g(^CTLOC(ctlocId)),"^",2),"-",2)
	.s maxAge=$li($g(^DHCANRC("ManageAssess",anrcmaRowId)),5)
 	.d OutPutManageAssess
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
    
OutPutManageAssess
	set Data=$lb(anrcmaRowId,anrcrcId,anrcrcDesc,opType,opTypeDesc,anrcmcId,anrcmcDesc,ctlocId,ctlocDesc,maxAge)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindManageAssessFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindManageAssessExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindManageAssessClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindManageAssessExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod InsertManageAssess(AnrcrcId, OPType, AnrcmcId, CtlocId, MaxAge) As %String
{
	q:AnrcrcId="" "-1"
	q:OPType="" "-2"
	q:AnrcmcId="" "-3"
	q:CtlocId="" "-4"
	q:MaxAge="" "-5"
	//ANRCMA_RowId ANRCMA_Anrcrc_Dr ANRCMA_SourceType ANRCMA_Anrcmc_Dr ANRCMA_Ctloc_Dr ANRCMA_MaxAge_Dr 
	&sql(insert into DHC_ANRC_ManageAssess set ANRCMA_Anrcrc_Dr=:AnrcrcId,ANRCMA_SourceType=:OPType,ANRCMA_Anrcmc_Dr=:AnrcmcId,ANRCMA_Ctloc_Dr=:CtlocId,ANRCMA_MaxAge_Dr=:MaxAge)
	q SQLCODE
}

ClassMethod DeleteManageAssess(AnrcmaRowId) As %String
{
	q:AnrcmaRowId="" "-1"
	&sql(delete from DHC_ANRC_ManageAssess where ANRCMA_RowId=:AnrcmaRowId)
	q SQLCODE
}

ClassMethod UpdateManageAssess(AnrcmaRowId, AnrcrcId, OPType, AnrcmcId, CtlocId, MaxAge) As %String
{
	q:AnrcmaRowId="" "-1"
	q:AnrcrcId="" "-2"
	q:OPType="" "-3"
	q:AnrcmcId="" "-4"
	q:CtlocId="" "-5"
	q:MaxAge="" "-6"
	&sql(update DHC_ANRC_ManageAssess set ANRCMA_Anrcrc_Dr=:AnrcrcId,ANRCMA_SourceType=:OPType,ANRCMA_Anrcmc_Dr=:AnrcmcId,ANRCMA_Ctloc_Dr=:CtlocId,ANRCMA_MaxAge_Dr=:MaxAge where ANRCMA_RowId=:AnrcmaRowId)
	q SQLCODE
}

}
