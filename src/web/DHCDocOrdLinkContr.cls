Class web.DHCDocOrdLinkContr Extends (DHCDoc.Util.RegisteredObject, %XML.Adaptor) [ Not ProcedureBlock ]
{

ClassMethod GetOrdLinkStr(ArcimRowid As %String, HospId As %String = "") As %String
{
   ;1413||1
	n (ArcimRowid,HospId,%session)
	s OrdLinkStr=""
	Q:ArcimRowid="" OrdLinkStr
	Set rset=##Class(%ResultSet).%New("web.DHCDocOrdLinkContr:FindOrdLink")
	If rset.QueryIsValid() { 
		Set Status=rset.Execute(ArcimRowid,HospId)
		If 'Status Quit
		Set columns = rset.GetColumnCount()
		While (rset.Next()) {
			set LinkArcimID=rset.GetDataByName("TlinkArcimID")
			set StDate=rset.GetDataByName("TStDate")
			if $l(StDate,"/")=3 s StDate=$zdh(StDate,4)
			if $l(StDate,"-")=3 s StDate=$zdh(StDate,3)
			set EndDate=rset.GetDataByName("TEndDate")
			if $l(EndDate,"/")=3 s EndDate=$zdh(EndDate,4)
			if $l(EndDate,"-")=3 s EndDate=$zdh(EndDate,3)
			s QuitFlag=0
			if (StDate'="")&(StDate>+$H) s QuitFlag=1
			if (EndDate'="")&(EndDate<+$H) s QuitFlag=1
			if LinkArcimID'="",QuitFlag'=1 {
				if OrdLinkStr="" s OrdLinkStr=LinkArcimID
				e  s OrdLinkStr=OrdLinkStr_"^"_LinkArcimID
			}
		}
		d rset.Close()
	}
	
	Q OrdLinkStr
}

Query FindOrdLink(arcimID As %String, HospId As %String = "") As %Query(ROWSPEC = "TArcimDesc:%String,TlinkArcimDesc:%String,TStDate:%String,TEndDate:%String,TarcimID:%String,TlinkArcimID:%String,LRowid:%String")
{
}

/// d ##class(%ResultSet).RunQuery("web.DHCDocOrdLinkContr","FindOrdLink","")
ClassMethod FindOrdLinkExecute(ByRef qHandle As %Binary, arcimID As %String, HospId As %String = "") As %Status
{
	
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	Set qHandle=$lb(0,repid,0)
 	s HospId=##Class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(HospId)
 	s Arcim="",ArcimL="",SDate="",EndDate="",ArcimID="",LinkArcimID=""
 	if (arcimID="") {
	 	s Rowid=""
	 	for {
		 	s Rowid=$o(^User.DHCDocOrdLinkedD(Rowid))
		 	q:Rowid=""
	 		&sql(select L_ArcIMDr->ARCIM_Desc,L_LinkArcIMDr->ARCIM_Desc,L_StDate,L_EndDate,L_ArcIMDr,L_LinkArcIMDr into :Arcim,:ArcimL,:SDate,:EndDate,:ArcimID,:LinkArcimID from SQLUser.DHC_Doc_OrdLinked
	 		where L_Rowid=:Rowid and  L_HospDr=:HospId)
	 		if ('SQLCODE){
	 			if (SDate'="") s SDate=..%ZD(SDate) //$zd(SDate,4)
	 			if (EndDate'="") s EndDate=..%ZD(EndDate) //$zd(EndDate,4)
				d OutputRow
			}
		}
	 }else{
		s Rowid=""
	 	for {
		 	s Rowid=$o(^User.DHCDocOrdLinkedD(Rowid))
		 	q:Rowid=""
		 	&sql(select L_ArcIMDr->ARCIM_Desc,L_LinkArcIMDr->ARCIM_Desc,L_StDate,L_EndDate,L_ArcIMDr,L_LinkArcIMDr into :Arcim,:ArcimL,:SDate,:EndDate,:ArcimID,:LinkArcimID from SQLUser.DHC_Doc_OrdLinked
		 	where L_Rowid=:Rowid and L_ArcIMDr=:arcimID and  L_HospDr=:HospId)
			 if ('SQLCODE){
		 		if (SDate'="") s SDate=..%ZD(SDate) //$zd(SDate,4)
		 		if (EndDate'="") s EndDate=..%ZD(EndDate) //$zd(EndDate,4)
		 		d OutputRow
		 	}
	 	}
	}
   	
	Quit $$$OK
OutputRow
	//Q:##Class(DHCDoc.Common.Hospital).GetHospShowDataFlag("ARC_ItmMast",ArcimID,HospId)="N"
	//Q:##Class(DHCDoc.Common.Hospital).GetHospShowDataFlag("ARC_ItmMast",LinkArcimID,HospId)="N"
	set Data=$lb(Arcim,ArcimL,SDate,EndDate,ArcimID,LinkArcimID,Rowid)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindOrdLinkFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindOrdLinkExecute ]
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
 	Else {		
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindOrdLinkClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindOrdLinkExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod LinkOrdInsert(arcim As %String, linkarcim As %String, stdate As %String, enddate As %String, HospId As %String = "")
{
	Q:(+arcim=0)||(arcim'["||")||('$d(^ARCIM(+arcim,$p(arcim,"||",2)))) "请选择有效的医嘱项目!"
	Q:(+linkarcim=0)||(linkarcim'["||")||('$d(^ARCIM(+linkarcim,$p(linkarcim,"||",2)))) "请选择有效的需开医嘱项目!"
	if (stdate'="") s stdate=..%ZDH(stdate) //$zdh(stdate,4)
	if (enddate'="") s enddate=..%ZDH(enddate) //$zdh(enddate,4)
	s HospId=##Class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(HospId)
	s count=0
	&sql(select count(L_Rowid) into:count from SQLUSER.DHC_Doc_OrdLinked where L_ArcIMDr=:arcim and L_LinkArcIMDr=:linkarcim and L_HospDr=:HospId)
	Q:count>0 "记录重复!"
	&Sql(Insert into SQLUSER.DHC_Doc_OrdLinked Set L_ArcIMDr=:arcim,L_LinkArcIMDr=:linkarcim,L_StDate=:stdate,L_EndDate=:enddate,L_HospDr=:HospId)
	q SQLCODE
}

ClassMethod LinkOrdDel(arcim As %String, linkarcim As %String, LRowid As %String)
{
	&Sql(Delete from SQLUSER.DHC_Doc_OrdLinked where L_ArcIMDr=:arcim and L_LinkArcIMDr=:linkarcim and L_Rowid=:LRowid)
	q SQLCODE
}

/// d ##class(web.DHCDocOrdLinkContr).LinkOrdUpdate("1038||1","12756||1","13/05/2013"," ")
ClassMethod LinkOrdUpdate(arcim As %String, linkarcim As %String, stdate As %String, enddate As %String, TarcimIDOld As %String, TlinkArcimIDOld As %String, LRowid As %String)
{
  	Q:(+arcim=0)||(arcim'["||")||('$d(^ARCIM(+arcim,$p(arcim,"||",2)))) "请选择有效的医嘱项目!"
	Q:(+linkarcim=0)||(linkarcim'["||")||('$d(^ARCIM(+linkarcim,$p(linkarcim,"||",2)))) "请选择有效的需开医嘱项目!"
	if (enddate=" ") s enddate=""
	if (stdate'="") s stdate=..%ZDH(stdate) //$zdh(stdate,4)
	if (enddate'="") s enddate=..%ZDH(enddate) //$zdh(enddate,4)
	s HospId=$lg(^User.DHCDocOrdLinkedD(LRowid),6)
	s count=0
	&sql(select count(L_Rowid) into:count from SQLUSER.DHC_Doc_OrdLinked where L_ArcIMDr=:arcim and L_LinkArcIMDr=:linkarcim and L_HospDr=:HospId and L_Rowid<>:LRowid)
	Q:count>0 "记录重复!"
	&sql(update SQLUSER.DHC_Doc_OrdLinked Set L_ArcIMDr=:arcim,L_LinkArcIMDr=:linkarcim,L_StDate=:stdate,L_EndDate=:enddate where L_ArcIMDr=:TarcimIDOld and L_LinkArcIMDr=:TlinkArcimIDOld and L_Rowid=:LRowid)
	q SQLCODE
}

}
