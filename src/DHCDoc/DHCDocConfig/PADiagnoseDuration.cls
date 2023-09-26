Class DHCDoc.DHCDocConfig.PADiagnoseDuration Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Query GetPADiagnoseDuration(PatType As %String, Diagnos As %String, HospId As %String = "") As %Query(ROWSPEC = "PDDRowid:%String,PatientType:%String,PatientTypeDesc:%String,DiagnoseDR:%String,MRCIDDesc:%String,DurationDR:%String,Duration:%String,Remark:%String")
{
}

ClassMethod GetPADiagnoseDurationExecute(ByRef qHandle As %Binary, PatType As %String, Diagnos As %String, HospId As %String = "") As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.PADiagnoseDuration","GetPADiagnoseDuration",1,"")
	Set repid=$I(^CacheTemp)
    Set ind=1
    Set qHandle=$lb(0,repid,0)
    i ($g(HospId)="")&&($d(%session)) s HospId=%session.Get("LOGON.HOSPID")
    i PatType'="" d
    .s PDDRowid=0 f  s PDDRowid=$o(^DHCPADIADuration(0,"PatientType",HospId,PatType,PDDRowid)) q:PDDRowid=""  d
    ..d GetPADiagnoseDuration(PDDRowid)
	..Set ind=ind+1 
	..Set qHandle=$lb(0,repid,0)
    Quit:(PatType'="") $$$OK
    
    i Diagnos'="" d
    .s PDDRowid=0 f  s PDDRowid=$o(^DHCPADIADuration(0,"Diagnose",HospId,Diagnos,PDDRowid)) q:PDDRowid=""  d
    ..d GetPADiagnoseDuration(PDDRowid)
    ..Set ind=ind+1 
	..Set qHandle=$lb(0,repid,0)
    Quit:(Diagnos'="") $$$OK
    
	s PDDRowid=0  
	f  s PDDRowid=$o(^DHCPADIADuration(PDDRowid)) q:PDDRowid=""  d
    .d GetPADiagnoseDuration(PDDRowid)
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowGetPADiagnoseDuration
	set Data=$lb($g(PDDRowid),$g(PatientType),$g(PatientTypeDesc),$g(DiagnoseDR),$g(MRCIDDesc),$g(DurationDR),$g(Duration),$g(Remark))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
GetPADiagnoseDuration(PDDRowid)
	s PDDHospDR=$p(^DHCPADIADuration(PDDRowid),"^",5)
	q:PDDHospDR'=HospId
    s PatientType=$p(^DHCPADIADuration(PDDRowid),"^",1)
    q:(PatientType'=PatType)&&(PatType'="")
    //Q:##Class(DHCDoc.Common.Hospital).GetHospShowDataFlag("CT_SocialStatus",PatientType,HospId)="N"
	s PatientTypeDesc=""
	i PatientType'="" s PatientTypeDesc=$p(^CT("SS",PatientType),"^",2)
	s DiagnoseDR=$p(^DHCPADIADuration(PDDRowid),"^",2)
	q:(DiagnoseDR'=Diagnos)&&(Diagnos'="")
	//Q:##Class(DHCDoc.Common.Hospital).GetHospShowDataFlag("MRC_ICDDx",DiagnoseDR,HospId)="N"
	s MRCIDDesc=""
	i DiagnoseDR'="" s MRCIDDesc=$p(^MRC("ID",DiagnoseDR),"^",2)
	s DurationDR=$p(^DHCPADIADuration(PDDRowid),"^",3)
	s Duration=""
	i DurationDR'="" s Duration=$p(^PHCDU(DurationDR),"^",1)
	s Remark=$p(^DHCPADIADuration(PDDRowid),"^",4)
	Do OutputRowGetPADiagnoseDuration
}

ClassMethod GetPADiagnoseDurationClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPADiagnoseDurationExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetPADiagnoseDurationFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPADiagnoseDurationExecute ]
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

ClassMethod delete(Rowid As %String) As %String
{
	&sql(delete from SQLUser.DHCPADiagnoseDuration where PDD_Rowid=:Rowid)
    q SQLCODE
}

ClassMethod save(Rowid As %String, Str As %String) As %String [ ProcedureBlock = 0 ]
{
	s PatientTypeRowid=$p(Str,"!",1)
	s DurationRowid=$p(Str,"!",2)
	s DiagnoseRowid=$p(Str,"!",3)
	s Remark=$p(Str,"!",4)
	s HospDr=$p(Str,"!",5)
	q:'$d(^PHCDU(DurationRowid)) "-1"
	if (Rowid=""){
		K PLIST(1)
		s PLIST(2)=$p(Str,"!",1) 
	    s PLIST(4)=$p(Str,"!",2)
	    s PLIST(3)=$p(Str,"!",3) 
	    s PLIST(5)=$p(Str,"!",4) 
	    s PLIST(6)=HospDr
		&sql(insert into SQLUser.DHCPADiagnoseDuration values :PLIST())
	}else{
		&sql(update SQLUser.DHCPADiagnoseDuration
            set PDD_PatientType_DR=:PatientTypeRowid,PDD_Duration_DR=:DurationRowid,PDD_Diagnose_DR=:DiagnoseRowid,PDD_Remark=:Remark
            where PDD_Rowid=:Rowid )
	}
	q SQLCODE
}

ClassMethod find(PatientTypeRowid, DiagnoseRowid, HospId) As %String
{
	s count=0
	&sql(select count(*) into :count from SQLUser.DHCPADiagnoseDuration
            where PDD_PatientType_DR=:PatientTypeRowid and PDD_Diagnose_DR=:DiagnoseRowid and PDD_Hosp_DR=:HospId)
    Q count
}

ClassMethod CopyPatType(SourceRowId As %String, DestinateRowId As %String, HospId As %String) As %String
{
    Q:'$d(^CT("SS",SourceRowId))||('$d(^CT("SS",DestinateRowId))) "-1"
	s rtn=0
	if ($d(^DHCPADIADuration("0","PatientType",HospId,SourceRowId))){
		s Rowid=0 f  s Rowid=$o(^DHCPADIADuration(0,"PatientType",HospId,SourceRowId,Rowid)) q:(Rowid="")||(rtn<0)  d
		.s DiagnoseRowid=$p(^DHCPADIADuration(Rowid),"^",2)
		.i (..find(DestinateRowId,DiagnoseRowid,HospId)'=0) s rtn="-2"
		.q:rtn="-2"
		.s DurationRowid=$p(^DHCPADIADuration(Rowid),"^",3)
		.s remark=$p(^DHCPADIADuration(Rowid),"^",4)
		.k PLIST
		.s PLIST(2)=DestinateRowId
        .s PLIST(4)=DurationRowid
        .s PLIST(3)=DiagnoseRowid
        .s PLIST(5)=remark
        .s PLIST(6)=HospId
        .&sql(insert into SQLUser.DHCPADiagnoseDuration values :PLIST())
	}else{
		Q 100
	}
	q rtn
}

}
