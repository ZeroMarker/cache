Import SQLUSER

Class web.DHCRisTechian Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Parameter BUILD = 221;

/// d ##class(%ResultSet).RunQuery("web.DHCRisTechian","QueryPatientByEQ","","")
Query QueryPatientByEQ(EQDR As %String, Date As %String) As %Query(ROWSPEC = "GetRegNo:%String,GetName:%String,GetSexDesc:%String,GetstrAge:%String,Getpatienttype:%String,GetStudyNo:%String,GetstrOrderName:%String,filmNum:%String,exposeNum:%String,GetMainDoc:%String,GetEQDesc:%String")
{
}

ClassMethod QueryPatientByEQExecute(ByRef qHandle As %Binary, EQDR As %String, Date As %String) As %Status
{
	  Set repid=$I(^CacheTemp)
      If $g(ind)="" Set ind=1
      s ^DHCRISTEMP23=EQDR_"^"_Date

	  if Date="" s Date=+$h
	  s Regrowid=0 f  s Regrowid=$o(^DHCPACRegInfoi("RegDate",Date,Regrowid)) q:Regrowid=""  d    
      .s RegInfo=##class(web.DHCRisCommFunctionEx).GetRegInfobyrowid(Regrowid)
      .s GetStudyNo=$p(RegInfo,"^",1)
      .s GetstrRegDate=$p(RegInfo,"^",2)
      .s GetstrRegTime=$p(RegInfo,"^",3)
      .s GetEQDesc=$p(RegInfo,"^",5)
      .s GetMainDoc=$p(RegInfo,"^",6)
      .s GetEQDr=$p(RegInfo,"^",11)
      .;q:EQDR=""
      .q:(EQDR'="")&(EQDR'=GetEQDr)
      .s GetRegDate=$p(RegInfo,"^",16)
      .s Oeorditemdr=$p(RegInfo,"^",8)
      .s filmNum="",exposeNum=""
      .s studydescrowid=$o(^DHCRBStudyi("StudyDesc","StudyNo",GetStudyNo,""))
      .i studydescrowid'="" d
      ..s filmNum=$p(^DHCRBStudy("StudyDesc",studydescrowid),"^",5)
      ..s exposeNum=$p(^DHCRBStudy("StudyDesc",studydescrowid),"^",4) 
      .s paadmdr=$p(RegInfo,"^",9)
      .s PatInfo=##class(web.DHCRisCommFunctionEx).GetPaadmInfo(paadmdr)
      .s GetRegNo=$p(PatInfo,"^",1)
      .s GetName=$p(PatInfo,"^",2)
      .s GetstrAge=$p(PatInfo,"^",4)
      .s GetstrAge=$p(GetstrAge," ")
 	  .s GetSexDesc=$p(PatInfo,"^",5)
      .s Getpatienttype=$p(PatInfo,"^",6)
      .s Gettypedesc=$p(PatInfo,"^",7)
      .s GetLocName=$p(PatInfo,"^",8)
      .s OrderRowid=$p(Oeorditemdr,"||",1)
      .s itemsub=$p(Oeorditemdr,"||",2)
 
      .s ordInfo=##class(web.DHCRisCommFunctionEx).GetOeorditminfo(OrderRowid,itemsub)
      .s GetstrOrderName=$p(ordInfo,"^",1)
      .s Getprice=$p(ordInfo,"^",10)
      .s GetNum=$p(ordInfo,"^",11)
      .s GetTotalPrice=$p(ordInfo,"^",12)
      .Do OutRow4
    Set qHandle=$lb(0,repid,0)
   Quit $$$OK
OutRow4
   	set Data=$lb(GetRegNo,GetName,GetSexDesc,GetstrAge,Getpatienttype,GetStudyNo,GetstrOrderName,filmNum,exposeNum,GetMainDoc,GetEQDesc)
   	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
 	quit
}

ClassMethod QueryPatientByEQFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryPatientByEQExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" 
 	{				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else 
 	{				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod QueryPatientByEQClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryPatientByEQExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod ExecuteItem(StudyNo As %String, FilmNums As %String, ExposeNum As %String, usercode As %String)
{
	q:StudyNo="" 100
	tstart 
	if usercode'="" d
	.s userid=$o(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(usercode),""))
	.s CareProDR=""
    .i userid'="" s CareProDR=$p(^SSU("SSUSR",userid),"^",14)
	.&sql(update DHCRB_RegInfo set RAR_MainDoctor_DR=:CareProDR where RAR_StudyNo =:StudyNo)
	.s StudyDescRowid=$o(^DHCRBStudyi("StudyDesc","StudyNo",StudyNo,""))
	.i StudyDescRowid'="" d
	..&sql(update DHCRB_StudyDesc (DRSD_ExpoureNum, DRSD_FilmNum) values (:ExposeNum,:FilmNums) where DRSD_StudyNo=:StudyNo)
	.else  d
	..&sql(insert into DHCRB_StudyDesc (DRSD_StudyNo,DRSD_ExpoureNum, DRSD_FilmNum) values (:StudyNo,:ExposeNum,:FilmNums))
	 I SQLCODE TRollback  q SQLCODE
	 TCOMMIT 
	 q SQLCODE
}

ClassMethod CancelExec(StudyNo As %String)
{
	q:StudyNo="" 100
	tstart 
    &sql(update DHCRB_RegInfo set RAR_MainDoctor_DR="" where RAR_StudyNo =:StudyNo)
    &sql(update DHCRB_StudyDesc (DRSD_ExpoureNum, DRSD_FilmNum) values ("","") where DRSD_StudyNo=:StudyNo)
    I SQLCODE TRollback  q SQLCODE
	TCOMMIT 
	q SQLCODE
}

///     在技师工作站中更新

}
