Class web.DHCANRCRiskAssess Extends %RegisteredObject
{

/// d ##class(%ResultSet).RunQuery("web.DHCANRCRiskAssess","FindANRCRiskAssess")
Query FindANRCRiskAssess() As %Query(ROWSPEC = "RowId,OperDiffcultyDr,OperDiffculty,ASADr,ASA,AnrcrcDr,Anrcrc,CtlocDr,Ctloc")
{
}

ClassMethod FindANRCRiskAssessExecute(ByRef qHandle As %Binary) As %Status
{
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	
	s RowId=0
	f  s RowId=$o(^DHCANRC("RiskAssess",RowId)) q:RowId=""  d
	.s OperDiffcultyDr=$li(^DHCANRC("RiskAssess",RowId),1)
	.q:OperDiffcultyDr=""
	.s OperDiffculty=$p($g(^ORC("CATEG",OperDiffcultyDr)),"^",2)
	.s ASADr=$li(^DHCANRC("RiskAssess",RowId),2)
	.q:ASADr=""
	.s ASA=$p($g(^ORC("ASA",ASADr)),"^",2)
	.s AnrcrcTemp=$g(^DHCANRC("RiskAssess",RowId))
	.q:AnrcrcTemp=""
	.s AnrcrcDr=$li(^DHCANRC("RiskAssess",RowId),3)
	.q:AnrcrcDr=""
	.s AnrcrcTemp=$g(^DHCANRC("RiskClass",AnrcrcDr))
	.q:AnrcrcTemp=""
	.s Anrcrc=$li($g(^DHCANRC("RiskClass",AnrcrcDr)),2)
	.s CtlocDr=$li(^DHCANRC("RiskAssess",RowId),4)
	.q:CtlocDr=""
	.s Ctloc=$p($g(^CTLOC(CtlocDr)),"^",2)
	.d OutputRow
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set Data=$lb(RowId,OperDiffcultyDr,OperDiffculty,ASADr,ASA,AnrcrcDr,Anrcrc,CtlocDr,Ctloc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindANRCRiskAssessFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindANRCRiskAssessExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
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

ClassMethod FindANRCRiskAssessClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindANRCRiskAssessExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod InsertANRCRiskAssess(OperDiffcultyDr, ASADr, AnrcrcDr, CtlocDr) As %String
{
	q:(OperDiffcultyDr="")!(ASADr="")!(AnrcrcDr="")!(CtlocDr="")
	s ObjRiskAssess=##class(User.DHCANRCRiskAssess).%New()
	;s ObjRiskAssess.ANRCRAOperDiffcultyDr=##class(User.ORCOperationCategory).%OpenId(OperDiffcultyDr)
	;s ObjRiskAssess.ANRCRAASADr=##class(User.ORCASAClassPhActiv).%OpenId(ASADr)
	s ObjRiskAssess.ANRCRAOperDiffcultyDr=OperDiffcultyDr
	s ObjRiskAssess.ANRCRAASADr=ASADr
	s ObjRiskAssess.ANRCRAAnrcrcDr=##class(User.DHCANRCRiskClass).%OpenId(AnrcrcDr)
	s ObjRiskAssess.ANRCRACtlocDr=CtlocDr
	s SaveStatus=ObjRiskAssess.%Save()
	q:(+SaveStatus=0) "数据添加失败！"
	s ID=ObjRiskAssess.%Id()
	d ObjRiskAssess.%Close()
	q 0
}

ClassMethod UpdateANRCRiskAssess(RowId, OperDiffcultyDr, ASADr, AnrcrcDr, CtlocDr) As %String
{
	q:RowId="" "RowId不能为空！"
	q:(OperDiffcultyDr="")!(ASADr="")!(AnrcrcDr="")!(CtlocDr="")
	q:'##class(User.DHCANRCRiskAssess).%ExistsId(RowId)
	s ObjRiskAssess=##class(User.DHCANRCRiskAssess).%OpenId(RowId)
	;s ObjRiskAssess.ANRCRAOperDiffcultyDr=##class(User.ORCOperationCategory).%OpenId(OperDiffcultyDr)
	;s ObjRiskAssess.ANRCRAASADr=##class(User.ORCASAClassPhActiv).%OpenId(ASADr)
	s ObjRiskAssess.ANRCRAOperDiffcultyDr=OperDiffcultyDr
	s ObjRiskAssess.ANRCRAASADr=ASADr
	s ObjRiskAssess.ANRCRAAnrcrcDr=##class(User.DHCANRCRiskClass).%OpenId(AnrcrcDr)
	s ObjRiskAssess.ANRCRACtlocDr=CtlocDr
	s SaveStatus=ObjRiskAssess.%Save()
	q:(+SaveStatus=0) "数据添加失败！"
	d ObjRiskAssess.%Close()
	q 0
}

ClassMethod DeleteANRCRiskAssess(RowId) As %String
{
	q:(RowId="") 
	q:'##class(User.DHCANRCRiskAssess).%ExistsId(RowId) "无指针对应记录！"
	s DeleteStatus=##class(User.DHCANRCRiskAssess).%DeleteId(RowId)
	q:(+DeleteStatus=0) "数据删除失败！"
	q 0
}

/// d ##CLASS(%ResultSet).RunQuery("web.DHCANCom","FindASAClass")
Query FindASAClass() As %SQLQuery(CONTAINID = 1, ROWSPEC = "Id:%Integer,Description:%String")
{
    select ORASA_RowId,ORASA_Desc from SQLUser.ORC_ASA_ClassPhActiv
}

}
