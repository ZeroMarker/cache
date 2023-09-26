Import SQLUSER

Class web.DHCANCDocOperation Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

/// //--------------------------------手术名称关联手术分类--------------------------------
/// d ##class(%ResultSet).RunQuery("web.DHCANCDocOperation","FindOrcOperation")
Query FindOrcOperation(OperationName As %String = "") As %Query(ROWSPEC = "tOperationName:%String,tOperationNameCat:%String,toperId:%String")
{
}

ClassMethod FindOrcOperationExecute(ByRef qHandle As %Binary, OperationName As %String = "") As %Status
{
 	 Set repid=$I(^CacheTemp)
 	 If $g(ind)="" Set ind=1
	 s toperId=0,tOperationName="",tOperationNameCat=""
	 f  s toperId=$o(^ORC("OPER",toperId))  q:toperId=""  d
		.s tOperationName=$p($g(^ORC("OPER",toperId)),"^",2)
		.q:(tOperationName'=OperationName)&(OperationName'="")
		.s tOperationNameCat=$p($g(^ORC("OPER",toperId,"DHC")),"^",16)
		.Do OutputRow3	 
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
    
OutputRow3
	set Data=$lb(tOperationName,tOperationNameCat,toperId)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindOrcOperationFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindOrcOperationExecute ]
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

ClassMethod FindOrcOperationClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindOrcOperationExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod UpdateOperationNameCat(operId, OperationNameCat) As %String
{
 
	s $p(^ORC("OPER",operId,"DHC"),"^",16)=OperationNameCat
	s $p(^TempTK("OPER",operId,"DHC"),"^",16)=OperationNameCat
	q 0
}

/// /d ##class(web.DHCANCDocOperation).CheckOperationNameCat(5)
ClassMethod CheckOperationNameCat(operId) As %String
{
	s OperationNameCat=$p($g(^ORC("OPER",operId,"DHC")),"^",16)
	q OperationNameCat
}

/*
/// //d ##class(%ResultSet).RunQuery("web.DHCANCDocOperation","FindOperationDoc","","")
Query FindOperationDoc() As %SQLQuery(CONTAINID = 1, ROWSPEC = "tDocId:%Integer,tOperationDoc:%Integer")
{
    select CTPCP_RowId1,CTPCP_Desc from SQLUser.CT_CareProv
}
*/
/// //--------------------------------手术医生关联手术分类--------------------------------
/// d ##class(%ResultSet).RunQuery("web.DHCANCDocOperation","FindOperationDoc")
Query FindOperationDoc(locDescOrId As %String = "") As %Query(ROWSPEC = "tOperationDoc:%String,tOperationDocCat:%String,tDocId:%String")
{
}

ClassMethod FindOperationDocExecute(ByRef qHandle As %Binary, locDescOrId As %String = "") As %Status
{
 	 Set repid=$I(^CacheTemp)
 	 If $g(ind)="" Set ind=1
 	 s ctlocIdList=""
 	 i locDescOrId'="" d
		.i locDescOrId=+locDescOrId s ctlocIdList=locDescOrId
		.e  d
			..s locDesc=$$ALPHAUP^SSUTIL4(locDescOrId)
			..s ctlocIdList=$o(^CTLOC(0,"Desc",locDesc,""))
 	 s locListCodeStr="INOPDEPT^OUTOPDEPT^EMOPDEPT"
 	 i ctlocIdList="" s ctlocIdList=##class(web.DHCCLCom).GetLocIdByLocListCode(locListCodeStr)
 	 f i=1:1:$l(ctlocIdList) d
		.s ctlocId=$p(ctlocIdList,"^",i)
		.q:ctlocId=""
		.s resId="",tOperationDoc="",tOperationDocCat=""
		.f  s resId=$O(^RB("RES",0,"CTLOC",ctlocId,resId))  q:resId=""  d
			..s tDocId=$P(^RB("RES",resId),"^",2)
	        ..q:tDocId=""
		    ..s tOperationDoc=$p($g(^CTPCP(tDocId,1)),"^",2)
		    ..s tOperationDocCat=$g(^DHCCLSet("AnOp","PrvTp",tDocId,"OpCat"))
		    ..Do OutputRow2	
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
    
OutputRow2
	set Data=$lb(tOperationDoc,tOperationDocCat,tDocId)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindOperationDocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindOperationDocExecute ]
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

ClassMethod FindOperationDocClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindOperationDocExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// d ##class(%ResultSet).RunQuery("web.DHCANCDocOperation","FindCtcpNew","","INOPDEPT^OUTOPDEPT^EMOPDEPT","","","","Y","Y")
Query FindCtcpNew(needCtcpDesc As %String, locListCodeStr As %String, locDescOrId As %String = "", EpisodeID As %String = "", opaId As %String = "", ifDoctor As %String = "", ifSurgeon As %String = "") As %Query(ROWSPEC = "ctcpId,ctcpDesc,tOperationDocCat")
{
}

ClassMethod FindCtcpNewExecute(ByRef qHandle As %Binary, needCtcpDesc As %String, locListCodeStr As %String, locDescOrId As %String = "", EpisodeID As %String = "", opaId As %String = "", ifDoctor As %String = "", ifSurgeon As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s needCtcpDesc=$$ALPHAUP^SSUTIL4(needCtcpDesc)
	s ctlocIdList=""
	i locDescOrId'="" d
		.i locDescOrId=+locDescOrId s ctlocIdList=locDescOrId
		.e  d
			..s locDesc=$$ALPHAUP^SSUTIL4(locDescOrId)
			..s ctlocIdList=$o(^CTLOC(0,"Desc",locDesc,""))
	i EpisodeID="",opaId'="" s EpisodeID=$P($g(^DHCANOPArrange(opaId)),"^",1)
	s locListCodeStr=##class(web.DHCCLCom).AdjustLocListCode(locListCodeStr,EpisodeID)
	i ctlocIdList="" s ctlocIdList=##class(web.DHCCLCom).GetLocIdByLocListCode(locListCodeStr)
	i needCtcpDesc="",ctlocIdList="" s ind=1 s qHandle=$lb(0,repid,0) Quit $$$OK
	
	//查询提示已安排手术间的麻醉科医生、手术室护士
	i ((locListCodeStr_"^")["AN^")!((locListCodeStr_"^")["OP^") d
		.s opaStartDate=$p($g(^DHCANOPArrange(+opaId)),"^",14)
		.q:opaStartDate=""
    	.k ctcpList
    	.s oprId=$P($G(^DHCANOPArrange(opaId)),"^",20)
    	.q:oprId=""
    	.s oprDesc=$p(^DHCANC("OPRoom",oprId),"^",2)
    	.s opaId=""
    	.f  s opaId=$O(^DHCANOPArrange(0,"SDate",+opaStartDate,opaId)) q:opaId=""  d 
	    	..q:'$d(^DHCANOPArrange(opaId))
	    	..s anaId=$P(^DHCANOPArrange(opaId),"^",2)
	    	..s EpisodeID=+anaId
	    	..s anaSub=$p(anaId,"||",2)
	    	..i ((locListCodeStr_"^")]"AN^") d
	    		...s anaSuperCtcpId=$P(^OR(EpisodeID,"ANA",anaSub),"^",7)
	    		...d SetCtcp(anaSuperCtcpId,oprDesc)
	    		...s anaesthCtcpId=$P(^OR(EpisodeID,"ANA",anaSub),"^",6)
	    		...d SetCtcp(anaesthCtcpId,oprDesc)
	    		...s anaopSub=0 
				...f  s anaopSub=$O(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub)) q:(anaopSub="")  d
		    		....i $P(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub),"^",12)'="M" q
		    		....s anassSub=0
		    		....i $P(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub),"^",12)'="M" q
		    		....f  s anassSub=$o(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub,"ANASS",anassSub)) q:anassSub=""  d
		        		.....s ctcpId=$p(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub,"ANASS",anassSub),"^")
		        		.....d SetCtcp(ctcpId,oprDesc)
	    	..q:(locListCodeStr_"^")'["OP^"
	    	..s anaopSub=0 
			..f  s anaopSub=$O(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub)) q:(anaopSub="")  d
		    	...i $P(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub),"^",12)'="M" q
		    	...s scnSub=0
		    	...f  s scnSub=$o(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub,"SCN",scnSub)) q:scnSub=""  d
		        	....s ctcpId=$p(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub,"SCN",scnSub),"^")
		        	....d SetCtcp(ctcpId,oprDesc)
		    	...s cirnSub=0
		    	...f  s cirnSub=$o(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub,"CIRN",cirnSub)) q:cirnSub=""  d
		        	....s ctcpId=$p(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub,"CIRN",cirnSub),"^")
		        	....d SetCtcp(ctcpId,oprDesc)
	s ctcptIdStr=$g(^DHCCLSet("AnOp","OpDocTp")) //能为主刀医师的医护人员类型
	f i=1:1:$l(ctlocIdList) d
		.s ctlocId=$p(ctlocIdList,"^",i)
		.q:ctlocId=""
		.s resId="",tOperationDocCat=""
		.f  s resId=$O(^RB("RES",0,"CTLOC",ctlocId,resId))  q:resId=""  d
			..s ctcpId=$P(^RB("RES",resId),"^",2)
			..s tOperationDocCat=$g(^DHCCLSet("AnOp","PrvTp",ctcpId,"OpCat"))
			..q:ctcpId=""
			..s ctcptId=$p($g(^CTPCP(ctcpId,1)),"^",4)
			..q:ctcptId=""
			..q:(ifSurgeon="Y")&((locListCodeStr_"^")["OPDEPT^")&((ctcptIdStr'="")&(("^"_ctcptIdStr_"^")'[("^"_ctcptId_"^")))
			..s ctcptType=$p(^CT("CPT",ctcptId),"^",4)
			..q:(ifDoctor'="")&(ifDoctor="Y")&(ctcptType'="DOCTOR")
			..q:(ifDoctor'="")&(ifDoctor'="Y")&(ctcptType'="NURSE")
			..s ctcpDesc=$p($g(^CTPCP(ctcpId,1)),"^",2)
			..q:($p(ctcpDesc,needCtcpDesc)'="")&(needCtcpDesc'="")&(##class(web.UDHCANOPArrange).MatchName(ctcpId,needCtcpDesc)=0)
			..s ctcpDesc=ctcpDesc_$g(ctcpList(ctcpId))
			..Do Outputcpt	

 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
SetCtcp(ctcpId,oprDesc)
	q:(ctcpId="")
	q:$g(ctcpList(ctcpId))[("("_oprDesc_")")
	s ctcpList(ctcpId)=$g(ctcpList(ctcpId))_"("_oprDesc_")"
	q

Outputcpt
 set Data=$lb(ctcpId,ctcpDesc,tOperationDocCat)
 Set ^CacheTemp(repid,ind)=Data
 Set ind=ind+1
 quit
}

ClassMethod FindCtcpNewFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindCtcpNewExecute ]
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

ClassMethod FindCtcpNewClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindCtcpNewExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod UpdateOperationDocCat(DocId, OperationDocCat) As %String
{
	s Num=0
	f  s OperDocId=$O(^DHCCLSet("AnOp","PrvTp",OperDocId,"OpCat")) q:OperDocId=""  d 
	.s Num=Num+1
	.s OperDocCatStr=$g(^DHCCLSet("AnOp","PrvTp",OperDocId,"OpCat"))
	.s OperDocCatNum=$l(OperDocCatStr,"^")
	.s OperDocCatNum=OperDocCatNum+1
	.s $p(^DHCCLSet("AnOp","PrvTp",DocId,"OpCat"),"^",OperDocCatNum)=OperationDocCat
	.s $p(^TemkTK("AnOp","PrvTp",DocId,"OpCat"),"^",OperDocCatNum)=OperationDocCat
	i Num=0  d
	.s $p(^DHCCLSet("AnOp","PrvTp",DocId,"OpCat"),"^",1)=OperationDocCat
	.s $p(^TemkTokki("AnOp","PrvTp",DocId,"OpCat"),"^",OperDocCatNum)=OperationDocCat
}

Storage Default
{
<Data name="DHCANCDocOperationDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCANCDocOperationD</DataLocation>
<DefaultData>DHCANCDocOperationDefaultData</DefaultData>
<IdLocation>^web.DHCANCDocOperationD</IdLocation>
<IndexLocation>^web.DHCANCDocOperationI</IndexLocation>
<StreamLocation>^web.DHCANCDocOperationS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
