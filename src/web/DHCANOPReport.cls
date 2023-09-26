Class web.DHCANOPReport Extends %RegisteredObject
{

/// d ##class(%ResultSet).RunQuery("web.DHCANOPReport","LookUpStatistic","")
Query LookUpStatistic(type) As %Query(ROWSPEC = "tCode:%String,tDesc:%String")
{
}

ClassMethod LookUpStatisticExecute(ByRef qHandle As %Binary, type) As %Status
{
 	s repid=$i(^CacheTemp)
 	i $g(ind)="" s ind=1
 	
 	s ^DHCANOP("Statistics","StatType","ByLoc")="按科室"
	s ^DHCANOP("Statistics","StatType","ByCareProv")="按医护人员"
	s ^DHCANOP("Statistics","StatType","ByPat")="按病人"
	s ^DHCANOP("Statistics","StatType","ByASA")="按分级"
	
	s StatType=""
	f  s StatType=$o(^DHCANOP("Statistics","StatType",StatType)) q:StatType=""  d
	.s tCode=StatType
	.s tDesc=^DHCANOP("Statistics","StatType",StatType)
	.d OutputRow2
 	
 	s qHandle=$lb(0,repid,0)
	q $$$OK
    
OutputRow2
	s Data=$lb(tCode,tDesc)
 	s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod LookUpStatisticFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = LookUpStatisticExecute ]
{
 	s AtEnd=$li(qHandle,1)
 	s repid=$li(qHandle,2)
 	s ind=$li(qHandle,3)
	//
 	s ind=$o(^CacheTemp(repid,ind))
 	i ind="" {				// if there are no more rows, finish fetching
 		s AtEnd=1
 		s Row=""
 	}
 	else      {				// fetch row
 		s Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod LookUpStatisticClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = LookUpStatisticExecute ]
{
	s repid=$li(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

ClassMethod TypeAdd(code As %String, typeCode As %String, typeStr As %String)
{
	/*
	q:(code="") -2
	i $d(^DHCCLSet("AnOp","PrnCol","VarDef",code))>0 q -1
	s ^DHCCLSet("AnOp","PrnCol","VarDef",code)=typeStr q 0
	*/
	q:(code="")||(typeCode="") -2
	s stypeCode=""
	s scode=""
	s num=0
	f  s stypeCode=$O(^DHCANOPStat("Statistics","StatType",stypeCode)) q:stypeCode=""  d
	.f  s scode=$O(^DHCANOPStat("Statistics","StatType",stypeCode,scode)) q:scode=""  d
	..i (code=scode)  d
	...s num=num+1
	q:num>0 -1
	s ^DHCANOPStat("Statistics","StatType",typeCode,code)=typeStr
	q 0
}

/// d ##class(%ResultSet).RunQuery("web.DHCANOPReport","FindQueryType","")
Query FindQueryType() As %Query(ROWSPEC = "code:%String,name:%String,operstat:%String,statisticstat:%String,statCode:%String,ststatCode:%String")
{
}

ClassMethod FindQueryTypeExecute(ByRef qHandle As %Binary) As %Status
{
	s repid=$i(^CacheTemp)
 	i $g(ind)="" s ind=1
	s queryTypeCode=""
	s queryCode=""
	f  s queryTypeCode=$o(^DHCANOPStat("Statistics","StatType",queryTypeCode)) q:queryTypeCode=""  d
	 .s ststatCode=queryTypeCode
	 .f  s queryCode=$o(^DHCANOPStat("Statistics","StatType",queryTypeCode,queryCode)) q:queryCode=""  d
	 ..s code=queryCode
	 ..s name=$p(^DHCANOPStat("Statistics","StatType",queryTypeCode,queryCode),"^",1)
	 ..s operstat=$p(^DHCANOPStat("Statistics","StatType",queryTypeCode,queryCode),"^",2)
	 ..s statCode=$p(^DHCANOPStat("Statistics","StatType",queryTypeCode,queryCode),"^",3)
	 ..s statisticstat=$p(^DHCANOPStat("Statistics","StatType",queryTypeCode,queryCode),"^",4) 
     ..d OutRowtyp1
    s qHandle=$lb(0,repid,0)  
     q $$$OK

OutRowtyp1
	s Data=$lb(code,name,operstat,statisticstat,statCode,ststatCode)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q

 //code,name,filename,byadm,prnframe,prechkdays
}

ClassMethod FindQueryTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindQueryTypeExecute ]
{
	s AtEnd=$li(qHandle,1)
 	s repid=$li(qHandle,2)
 	s ind=$li(qHandle,3)
 	s ind=$o(^CacheTemp(repid,ind))
 	i ind="" {				// if there are no more rows, finish fetching
 		s AtEnd=1
 		s Row=""
 	}
 	else      {			
 		s Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod FindQueryTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindQueryTypeExecute ]
{
	s repid=$li(qHandle,2)
 	k ^CacheTemp(repid)
    q $$$OK
}

/// d ##class(%ResultSet).RunQuery("web.DHCANOPReport","FinTypeSetPrint","")
Query FinTypeSetPrint(queryTypeCode As %String = "", ststatCode As %String = "") As %Query(ROWSPEC = "seqno,name,ColLink,ColLinkID,schtypeId,returntypeId,schtype,returntype")
{
}

ClassMethod FinTypeSetPrintExecute(ByRef qHandle As %Binary, queryTypeCode As %String = "", ststatCode As %String = "") As %Status
{
	//s ^DHCANOPStat("Statistics","StatType",StatType,code,repschtypeId,ColLinkID)
 	s repid=$i(^CacheTemp)
 	s ind=1
 	s trepschtypeId=""
	k ^TempSeqno
	//s rw=1
	i (queryTypeCode'="")
	{
	f  s trepschtypeId=$o(^DHCANOPStat("Statistics","StatType",ststatCode,queryTypeCode,trepschtypeId)) q:trepschtypeId=""  d 
	.s tColLinkID=0
	.f  s tColLinkID=$o(^DHCANOPStat("Statistics","StatType",ststatCode,queryTypeCode,trepschtypeId,tColLinkID)) q:tColLinkID=""  d
	    ..s name=$p(^DHCANOPStat("Statistics","StatType",ststatCode,queryTypeCode,trepschtypeId,tColLinkID),"^",1)
	    ..s ColLink=$p(^DHCANOPStat("Statistics","StatType",ststatCode,queryTypeCode,trepschtypeId,tColLinkID),"^",2)
	    ..s ColLinkID=tColLinkID
        ..s seqno=+$p(^DHCANOPStat("Statistics","StatType",ststatCode,queryTypeCode,trepschtypeId,tColLinkID),"^",3)
        ..s returntypeId=$p(^DHCANOPStat("Statistics","StatType",ststatCode,queryTypeCode,trepschtypeId,tColLinkID),"^",4)
        ..s schtype=$p(^DHCANOPStat("Statistics","StatType",ststatCode,queryTypeCode,trepschtypeId,tColLinkID),"^",5)
        ..s returntype=$p(^DHCANOPStat("Statistics","StatType",ststatCode,queryTypeCode,trepschtypeId,tColLinkID),"^",6)
        ..s schtypeId=trepschtypeId
        ..s Data=$lb(seqno,name,ColLink,ColLinkID,schtypeId,returntypeId,schtype,returntype)
        ..s ^TempSeqno("Statistics","StatType",seqno)=Data
        
        
        s seqnonum=0
        f  s seqnonum=$o(^TempSeqno("Statistics","StatType",seqnonum)) q:seqnonum=""  d
        .
        .d OutRow
        ;d OutRow
        /*
        ..s tem(seqno,rw)=$lb(seqno,name,ColLink,ColLinkID,rw,repschtypeId,repreturntypeId)
        ..s rw=rw+1
        ..*/
	}
	/*
	s i=0
    s seqno=""  f  s seqno=$O(tem(seqno))  q:seqno=""  d
    .s rw=0 f  s rw=$O(tem(seqno,rw)) q:rw=""  d
    ..s name=$List(tem(seqno,rw),2)
    ..s ColLink=$List(tem(seqno,rw),3)
    ..s ColLinkID=$List(tem(seqno,rw),4)
    ..s schtypeId=$List(tem(seqno,rw),6)
    ..s returntypeId=$List(tem(seqno,rw),7)
    ..s i=i+1
    ..d OutRow
    
    if (i=0)&(queryTypeCode'="") k ^DHCANOPStat("Statistics","StatType",ststatCode,queryTypeCode)
    */
    s qHandle=$lb(0,repid,0)
    q $$$OK
OutRow
	//s Data=$lb(seqno,name,ColLink,ColLinkID,schtypeId,returntypeId,schtype,returntype)
 	s ^CacheTemp(repid,ind)=^TempSeqno("Statistics","StatType",seqnonum)
 	s ind=ind+1
	q

 //code,name,filename,byadm,prnframe
}

ClassMethod FinTypeSetPrintFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FinTypeSetPrintExecute ]
{
	s AtEnd=$li(qHandle,1)
 	s repid=$li(qHandle,2)
 	s ind=$li(qHandle,3)
 	s ind=$o(^CacheTemp(repid,ind))
 	i ind="" {				// if there are no more rows, finish fetching
 		s AtEnd=1
 		s Row=""
 	}
 	else      {			
 		s Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod FinTypeSetPrintClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FinTypeSetPrintExecute ]
{
	s repid=$li(qHandle,2)
 	k ^CacheTemp(repid)
    q $$$OK
}

//ClassMethod AddTitle(code As %String, StatType As %String, ColLinkID As %String, typeStr As %String)

ClassMethod AddTitle(code, StatType, ColLinkID, repschtypeId, typeStr)
{
	//s ^TempLm("AddTitle","121122")=code+"^"+StatType+"^"+ColLinkID+"^"+typeStr
	
	q:(code="") -2
	s trepschtypeId=""
	s tColLinkID=""
	s num=0
	f  s trepschtypeId=$O(^DHCANOPStat("Statistics","StatType",StatType,code,trepschtypeId)) q:trepschtypeId=""  d
	.i (repschtypeId=trepschtypeId)  d
	..f  s tColLinkID=$O(^DHCANOPStat("Statistics","StatType",StatType,code,trepschtypeId,tColLinkID)) q:tColLinkID=""  d
	...i (ColLinkID=tColLinkID)  d
	....s num=num+1
	q:(num>0) -1
	s ^DHCANOPStat("Statistics","StatType",StatType,code,repschtypeId,ColLinkID)=typeStr
	q 0
}

Query LookUpComCode(type) As %Query(ROWSPEC = "tCode:%String,tDesc:%String")
{
}

ClassMethod LookUpComCodeExecute(ByRef qHandle As %Binary, type) As %Status
{
	s ^DHCCLComCode("SchType",1)="Inquiry^查询条件"
	s ^DHCCLComCode("SchType",2)="Return^查询结果"
	s ^DHCCLComCode("ReturnType",1)="Number^数值型"
	s ^DHCCLComCode("ReturnType",2)="String^字符型"
 	s repid=$i(^CacheTemp)
 	i $g(ind)="" s ind=1
 	i type="" s type="Default"
 	s codeId=0
 	f  s codeId=$o(^DHCCLComCode(type,codeId)) q:codeId=""  d
 		.s ifActive=$p(^DHCCLComCode(type,codeId),"^",3)
 		.q:(ifActive'="Y")&(ifActive'="")
 		.s tCode=$p(^DHCCLComCode(type,codeId),"^",1)
 		.s tDesc=$p(^DHCCLComCode(type,codeId),"^",2)
 		.d OutputRow2
 	s qHandle=$lb(0,repid,0)
	q $$$OK
    
OutputRow2
	s Data=$lb(tCode,tDesc)
 	s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod LookUpComCodeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = LookUpComCodeExecute ]
{
 	s AtEnd=$li(qHandle,1)
 	s repid=$li(qHandle,2)
 	s ind=$li(qHandle,3)
	//
 	s ind=$o(^CacheTemp(repid,ind))
 	i ind="" {				// if there are no more rows, finish fetching
 		s AtEnd=1
 		s Row=""
 	}
 	else      {				// fetch row
 		s Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod LookUpComCodeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = LookUpComCodeExecute ]
{
	s repid=$li(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

//20150907+dyl+

ClassMethod TypeUpdate(oldCode As %String, code As %String, repststatcode As %String, ststatCode As %String, typeStr As %String) As %String
{
	q:(code="") -2
	q:(oldCode="") -1
	s stypeCode=""
	s scode=""
	s num=0
	;如果新的代码在系统中已经存在，并且旧的代码跟系统中的不一样，判断代码已经存在
	f  s stypeCode=$O(^DHCANOPStat("Statistics","StatType",stypeCode)) q:stypeCode=""  d
		.f  s scode=$O(^DHCANOPStat("Statistics","StatType",stypeCode,scode)) q:scode=""  d
			..i (code=scode)&(scode'=oldCode)  d
				...s num=num+1
	q:num>0 -1
	k ^DHCANOPStat("Statistics","StatType",ststatCode,oldCode)
	s ^DHCANOPStat("Statistics","StatType",repststatcode,code)=typeStr
	m ^DHCANOPStat("Statistics","StatType",repststatcode,code)=^DHCANOPStat("Statistics","StatType",ststatCode,oldCode)
	if (ststatCode'=repststatcode)||(code'=oldCode)  d
	.k ^DHCANOPStat("Statistics","StatType",ststatCode,oldCode)
	q 0
}

ClassMethod TypeDel(ststatCode As %String, code As %String) As %String
{
	q:(code="") -2
	k ^DHCANOPStat("Statistics","StatType",ststatCode,code)
	k ^DHCANOPStat("Statistics","StatType",ststatCode,code)
	q 0
}

ClassMethod UpdateTitle(code, StatType, repColLinkID, repschtypeId, ColLinkID, schtypeId, typeStr) As %String
{
	//s ^TempLm("AddTitle","121122")=code+"^"+StatType+"^"+ColLinkID+"^"+typeStr
	
	q:(code="") -2
	s trepschtypeId=""
	s tColLinkID=""
	s num=0
	f  s trepschtypeId=$O(^DHCANOPStat("Statistics","StatType",StatType,code,trepschtypeId)) q:trepschtypeId=""  d
		.i (repschtypeId=trepschtypeId)  d
			..f  s tColLinkID=$O(^DHCANOPStat("Statistics","StatType",StatType,code,trepschtypeId,tColLinkID)) q:tColLinkID=""  d
				...i (ColLinkID=tColLinkID)&(repColLinkID'=tColLinkID)  d
					....s num=num+1
	q:(num>0) -1
	//s rw=$I(^DHCANOPStat("Statistics","StatType",StatType,Code,ColLinkID))
	k ^DHCANOPStat("Statistics","StatType",StatType,code,schtypeId,ColLinkID)
	s ^DHCANOPStat("Statistics","StatType",StatType,code,repschtypeId,repColLinkID)=typeStr
	q 0
}

ClassMethod DelTitle(ststatCode, queryTypeCode, schtypeId, ColLinkID) As %String
{
	q:(queryTypeCode="")||(ststatCode="")||(schtypeId="")||(ColLinkID="") -1
	k ^DHCANOPStat("Statistics","StatType",ststatCode,queryTypeCode,schtypeId,ColLinkID)
	q 0
}

Query LookUpReport(ColName) As %Query(ROWSPEC = "varStr:%String,varAlp:%String")
{
}

ClassMethod LookUpReportExecute(ByRef qHandle As %Binary, ColName) As %Status
{
 	s repid=$i(^CacheTemp)
 	i $g(ind)="" s ind=1
 	s var=0
 	f  s var=$o(^DHCANOPStat("Statistics","Report","Var",var)) q:var=""  d
 		.s varStr=$p(^DHCANOPStat("Statistics","Report","Var",var),"^",1)
 		.q:(ColName'="")&(varStr'[ColName)
 		.s varAlp=$p(^DHCANOPStat("Statistics","Report","Var",var),"^",2)
 		.d Outvar
 	s qHandle=$lb(0,repid,0)
	q $$$OK
    
Outvar
	s Data=$lb(varStr,varAlp)
 	s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod LookUpReportFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = LookUpReportExecute ]
{
 	s AtEnd=$li(qHandle,1)
 	s repid=$li(qHandle,2)
 	s ind=$li(qHandle,3)
	//
 	s ind=$o(^CacheTemp(repid,ind))
 	i ind="" {				// if there are no more rows, finish fetching
 		s AtEnd=1
 		s Row=""
 	}
 	else      {				// fetch row
 		s Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod LookUpReportClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = LookUpReportExecute ]
{
	s repid=$li(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

}
