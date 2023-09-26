Include Nur.DateFormat

Class web.DHCIFWorkLoad Extends %Library.RegisteredObject [ ClassType = "", ProcedureBlock ]
{

ClassMethod InsertWork(OeoreId As %String, Item As %String, UserId As %String, CTLocId As %String, FailureNum As %String) As %String
{
	s Date=$P($h,",",1)
	s Parr="^"_OeoreId_"^"_Date_"^"_Item_"^"_UserId_"^"_CTLocId_"^"_FailureNum
	s a=##class(User.DHCIFWorkStat).Save(Parr)
	q 0
}

ClassMethod DeleteWork(OeoreId As %String, Item As %String) As %String
{
	s row="" f  s row=$O(^User.DHCIFWorkStatI("Oeore"," "_OeoreId,Item,row)) q:row=""  d
	.d ##class(User.DHCIFWorkStat).%DeleteId(row)
	q 0
}

/// ##class(web.DHCIFWorkLoad).GetNurWork(63,"2011-03-03","2017-03-03","SummUserAdd")
ClassMethod GetNurWork(CTLocId As %String, StDate As %String, EndDate As %String, funname As %String) As %String
{
	q:CTLocId="" ""
	s ^sctmp("mzsy")=CTLocId_","_ StDate _","_ EndDate _","_ funname
	s fromDate=$$$zdh(StDate,3),toDate=$$$zdh(EndDate,3)
 	s rw="" f  s rw=$O(^RB("RES",0,"CTLOC",CTLocId,rw)) q:rw=""  d
 	.s ctcptId=$P(^RB("RES",rw),"^",2)
 	.q:ctcptId=""
 	.s UserId=$O(^SSU("SSUSR",0,"CTPCP",ctcptId,0))
 	.q:UserId=""
 	.s num=1,InfuWork=0,ConWork=0,DosWork=0,FailWork=0
 	.s UserName=$P(^SSU("SSUSR",UserId),"^",2)
 	.f date=fromDate:1:toDate d 
 	..s rel="" f  s rel=$O(^User.DHCIFWorkStatI("UserDr"," "_UserId,date,rel)) q:rel=""  d
 	...s FailNum=$list(^User.DHCIFWorkStatD(rel),3)
 	...s typDr=$list(^User.DHCIFWorkStatD(rel),4)
 	...i typDr'="" d 
 	....s typ=$list(^User.DHCIFWorkItemD(typDr),2)
 	....i typ="Infusion" s InfuWork=InfuWork+num
 	....i typ="Continue" s ConWork=ConWork+num
 	....i typ="Dosage" s DosWork=DosWork+num
 	....s FailWork=FailWork+FailNum
 	.s rtnval=funname_"('"_$ZCVT($g(UserName),"O","JS")_"','"_$ZCVT($g(InfuWork),"O","JS")_"','"_$ZCVT($g(ConWork),"O","JS")_"','"_$ZCVT($g(DosWork),"O","JS")_"','"_$ZCVT($g(FailWork),"O","JS")_"','"_$ZCVT($G(UserId),"O","JS")_"');"
    .&javascript<#(rtnval)#>
 	q 0
}

ClassMethod GetDetailsWork(UserId As %String, CTLocId As %String, StDate As %String, EndDate As %String, funname As %String) As %String
{
	q:(UserId="")&&(CTLocId="") ""
	q:(StDate="")||(EndDate="") ""
	s fromDate=$$$zdh(StDate,3),toDate=$$$zdh(EndDate,3)
	for date=fromDate:1:toDate d
	.i UserId'="" d
	..s row="" f  s row=$O(^User.DHCIFWorkStatI("UserDr"," "_UserId,date,row)) q:row=""  d
	...s OeoreId=$list(^User.DHCIFWorkStatD(row),6)
	...q:(OeoreId="")&&(OeoreId'["||")
	...s ExecDateTime=""
	...s Oew=$P(OeoreId,"||",1)
	...s Episodeid=$P($g(^OEORD(Oew)),"^",1)
	...q:Episodeid=""
	...s Papmidr=$P(^PAADM(Episodeid),"^",1)
	...s RegNo=$p($g(^PAPER(Papmidr,"PAT",1)),"^",1)
	...s PatName=$p($g(^PAPER(Papmidr,"ALL")),"^",1)
	...s WorkItemDr=$list(^User.DHCIFWorkStatD(row),4)
	...s WorkItemDesc=$list(^User.DHCIFWorkItemD(WorkItemDr),3)
	...s ArcDesc=..GetArcDesc(OeoreId)
	...s UserName=$P(^SSU("SSUSR",UserId),"^",2)
	...i WorkItemDesc["配液" d 
	....s ExecDateTime=##class(web.DHCIFDosAge).DosAgeDateTime(OeoreId)
	...e  d //输液与续液 
	....s rel="" f  s rel=$O(^User.DHCIFTimeI("Oeore"," "_OeoreId,rel)) q:rel=""  d
	.....s StDate=$list(^User.DHCIFTimeD(rel),10)
	.....s StTime=$list(^User.DHCIFTimeD(rel),11)
	.....i StDate'="" s ExecDateTime=$ZD(StDate,3)_" "_$ZT(StTime)
	...s rtnval=funname_"('"_$ZCVT($G(RegNo),"O","JS")_"','"_$ZCVT($G(PatName),"O","JS")_"','"_$ZCVT($G(ArcDesc),"O","JS")_"','"_$ZCVT($G(WorkItemDesc),"O","JS")_"','"_$ZCVT($G(ExecDateTime),"O","JS")_"','"_$ZCVT($g(UserName),"O","JS")_"');"
    ...&javascript<#(rtnval)#>
    .i CTLocId'="" d
    ..s id="" f  s id=$O(^User.DHCIFWorkStatI("CTLoc"," "_CTLocId,date,id)) q:id=""  d
   	...s OeoreId=$list(^User.DHCIFWorkStatD(id),6)
	...q:(OeoreId="")&&(OeoreId'["||")
	...s ExecDateTime=""
	...s Oew=$P(OeoreId,"||",1)
	...s Episodeid=$P($g(^OEORD(Oew)),"^",1)
	...q:Episodeid=""
	...s Papmidr=$P(^PAADM(Episodeid),"^",1)
	...s RegNo=$p($g(^PAPER(Papmidr,"PAT",1)),"^",1)
	...s PatName=$p($g(^PAPER(Papmidr,"ALL")),"^",1)
	...s WorkItemDr=$list(^User.DHCIFWorkStatD(id),4)
	...s WorkItemDesc=$list(^User.DHCIFWorkItemD(WorkItemDr),3)
	...s ArcDesc=..GetArcDesc(OeoreId)
	...s UserDr=$list(^User.DHCIFWorkStatD(id),7)
	...s UserName=$P(^SSU("SSUSR",UserDr),"^",2)
	...i WorkItemDesc["配液" d 
	....s ExecDateTime=##class(web.DHCIFDosAge).DosAgeDateTime(OeoreId)
	...e  d //输液与续液 
	....s rw="" f  s rw=$O(^User.DHCIFTimeI("Oeore"," "_OeoreId,rw)) q:rw=""  d
	.....s StDate=$list(^User.DHCIFTimeD(rw),10)
	.....s StTime=$list(^User.DHCIFTimeD(rw),11)
	.....i StDate'="" s ExecDateTime=$ZD(StDate,3)_" "_$ZT(StTime)
	...s rtnval=funname_"('"_$ZCVT($G(RegNo),"O","JS")_"','"_$ZCVT($G(PatName),"O","JS")_"','"_$ZCVT($G(ArcDesc),"O","JS")_"','"_$ZCVT($G(WorkItemDesc),"O","JS")_"','"_$ZCVT($G(ExecDateTime),"O","JS")_"','"_$ZCVT($g(UserName),"O","JS")_"');"
    ...&javascript<#(rtnval)#>
 	q 0
}

ClassMethod GetArcDesc(OeoreId As %String) As %String
{
	q:OeoreId="" ""
	s oew=$P(OeoreId,"||",1)
	s chl=$P(OeoreId,"||",2)
	s arcimdr=$p($g(^OEORD(oew,"I",chl,1)),"^",2)
    s scrip=$P(arcimdr,"||")
	s ver=$P(arcimdr,"||",2)
	s arcimdes=$P(^ARCIM(scrip,ver,1),"^",2) //^OEORDi(0,"OEORI",oeordId,RowId,curOriSub)
	s curOriSub="" f  s curOriSub=$O(^OEORDi(0,"OEORI",oew,oew_"||"_chl,curOriSub)) q:curOriSub=""  d
	.s arcimdr=$p($g(^OEORD(oew,"I",curOriSub,1)),"^",2)
	.s scrip=$P(arcimdr,"||")
	.s ver=$P(arcimdr,"||",2)
	.s arcimCurdes=$P(^ARCIM(scrip,ver,1),"^",2)
	.s arcimdes=arcimdes_"___"_arcimCurdes
	q $G(arcimdes)
}

ClassMethod GetCTLocWork(CTLocId As %String, StDate As %String, EndDate As %String, funname As %String) As %String
{
	q:CTLocId="" ""
	q:StDate="" ""
	q:EndDate="" ""
	s fromDate=$$$zdh(StDate,3),toDate=$$$zdh(EndDate,3)
	s num=1,TotalInfuWork=0,TotalConWork=0,TotalDosWork=0
	s CTLoc=$P(^CTLOC(CTLocId),"^",2)
	for date=fromDate:1:toDate d
	.s rw="" f  s rw=$O(^User.DHCIFWorkStatI("CTLoc"," "_CTLocId,date,rw)) q:rw=""  d
	..s typDr=$list(^User.DHCIFWorkStatD(rw),4)
 	..i typDr'="" d
 	...s typ=$list(^User.DHCIFWorkItemD(typDr),2)
 	...i typ="Infusion" s TotalInfuWork=TotalInfuWork+num
 	...i typ="Continue" s TotalConWork=TotalConWork+num
 	...i typ="Dosage" s TotalDosWork=TotalDosWork+num
 	s rtnval=funname_"('"_$ZCVT($G(CTLoc),"O","JS")_"','"_$ZCVT($G(TotalInfuWork),"O","JS")_"','"_$ZCVT($G(TotalConWork),"O","JS")_"','"_$ZCVT($G(TotalDosWork),"O","JS")_"','"_$ZCVT($G(CTLocId),"O","JS")_"');"
 	&javascript<#(rtnval)#>
 	q 0
}

// 根据科室取医院名称

ClassMethod gethospital(id)
{
	q:id="" ""
	s hospitaldr=$p(^CTLOC(id),"^",22)
	q:hospitaldr="" ""
	s desc=$p(^CT("HOSP",hospitaldr),"^",2)
	q desc
}

}
