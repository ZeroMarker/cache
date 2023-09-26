Class DHCDoc.DHCDocConfig.ItmDiagnose Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Query GetItmDiagnose(PatType As %String, ARCIMRowid As %String, Diagnose As %String, HospId As %String = "") As %Query(ROWSPEC = "ItmDiaRowid:%String,PatientType:%String,PatientTypeDesc:%String,ItmMastDR:%String,ARCIMDesc:%String,DiagnoseDR:%String,MRCIDDesc:%String,Remark:%String")
{
}

ClassMethod GetItmDiagnoseExecute(ByRef qHandle As %Binary, PatType As %String, ARCIMRowid As %String, Diagnose As %String, HospId As %String = "") As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.ItmDiagnose","GetItmDiagnose")
	s ^tempscl("GetItmDiagnose")=PatType_","_ARCIMRowid_","_Diagnose
	i ($g(HospId)="")&&($d(%session)) s HospId=%session.Get("LOGON.HOSPID")
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
    Set ind=1
    i PatType'="" d
    .s ItmDiaRowid=0 f  s ItmDiaRowid=$o(^DHCITMDIAi("PatientType",HospId,PatType,ItmDiaRowid)) q:ItmDiaRowid=""  d
    ..d GetItmDiagnose(ItmDiaRowid)
    ..Set ind=ind+1 
	..Set qHandle=$lb(0,repid,0)
    Quit:(PatType'="") $$$OK  
    i ARCIMRowid'="" d
    .s ItmDiaRowid=0 f  s ItmDiaRowid=$o(^DHCITMDIAi("Itm",HospId,ARCIMRowid,ItmDiaRowid)) q:ItmDiaRowid=""  d
    ..d GetItmDiagnose(ItmDiaRowid)
    ..Set ind=ind+1 
	..Set qHandle=$lb(0,repid,0)
    Quit:(ARCIMRowid'="") $$$OK
     i Diagnose'="" d
    .s ItmDiaRowid=0 f  s ItmDiaRowid=$o(^DHCITMDIAi("Diagnose",HospId,Diagnose,ItmDiaRowid)) q:ItmDiaRowid=""  d
    ..d GetItmDiagnose(ItmDiaRowid)
    ..Set ind=ind+1 
	..Set qHandle=$lb(0,repid,0)
    Quit:(Diagnose'="") $$$OK
    
	s ItmDiaRowid=0 
	f  s ItmDiaRowid=$o(^DHCITMDIA(ItmDiaRowid)) q:ItmDiaRowid=""  d
	.d GetItmDiagnose(ItmDiaRowid)
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowGetItmDiagnose
	set Data=$lb($g(ItmDiaRowid),$g(PatientType),$g(PatientTypeDesc),$g(ItmMastDR),$g(ARCIMDesc),$g(DiagnoseDR),$g(MRCIDDesc),$g(Remark))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
GetItmDiagnose(ItmDiaRowid)
	 s ItmDiaHospDR=$p(^DHCITMDIA(ItmDiaRowid),"^",5)
	 q:HospId'=ItmDiaHospDR
     s PatientType=$p(^DHCITMDIA(ItmDiaRowid),"^",1)
     q:(PatientType'=PatType)&&(PatType'="")
     //Q:##Class(DHCDoc.Common.Hospital).GetHospShowDataFlag("CT_SocialStatus",PatientType,HospId)="N"
	 s PatientTypeDesc=""
	 i PatientType'="" s PatientTypeDesc=$p(^CT("SS",PatientType),"^",2)
	 s ItmMastDR=$p(^DHCITMDIA(ItmDiaRowid),"^",2)
	 q:(ARCIMRowid'=ItmMastDR)&&(ARCIMRowid'="")
	 //Q:##Class(DHCDoc.Common.Hospital).GetHospShowDataFlag("ARC_ItmMast",ItmMastDR,HospId)="N"
	 s ARCIMDesc=""
	 i ItmMastDR'="" s ARCIMDesc=$p(^ARCIM(+ItmMastDR,$p(ItmMastDR,"||",2),1),"^",2)
	 s DiagnoseDR=$p(^DHCITMDIA(ItmDiaRowid),"^",3)
	 q:(DiagnoseDR'=Diagnose)&&(Diagnose'="")
	 //Q:##Class(DHCDoc.Common.Hospital).GetHospShowDataFlag("MRC_ICDDx",DiagnoseDR,HospId)="N"
	 s MRCIDDesc=""
	 i DiagnoseDR'="" s MRCIDDesc=$p($g(^MRC("ID",DiagnoseDR)),"^",2)
	 s Remark=$p(^DHCITMDIA(ItmDiaRowid),"^",4)
	 Do OutputRowGetItmDiagnose
}

ClassMethod GetItmDiagnoseClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetItmDiagnoseExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetItmDiagnoseFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetItmDiagnoseExecute ]
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
	&sql(delete from SQLUser.DHC_ItmDiagnose where ItmDia_Rowid=:Rowid)
    Q SQLCODE
}

ClassMethod save(Rowid As %String, Str As %String, HospId As %String) As %String [ ProcedureBlock = 0 ]
{
	s PatientTypeRowid=$p(Str,"!",1)
	s ARCIMID=$p(Str,"!",2)
	s MRCICDDR=$p(Str,"!",3)
	s Remark=$p(Str,"!",4)
	s arcimcode="",MRCIDCode=""
	 &sql(select ARCIM_code into :arcimcode from SQLUSER.arc_itmmast where ARCIM_RowId=:ARCIMID)
     q:arcimcode="" "-1"
     &sql(select MRCID_Code into :MRCIDCode from SQLUSER.mrc_icddx where MRCID_RowId=:MRCICDDR)
     q:MRCIDCode="" "-2"
	 if (Rowid=""){
		K PLIST
		 s PLIST(2)=PatientTypeRowid
	     s PLIST(3)=ARCIMID 
	     s PLIST(4)=MRCICDDR
	     s PLIST(5)=Remark
	     s PLIST(6)=HospId
		&sql(insert into SQLUser.DHC_ItmDiagnose values :PLIST())
	}else{
		&sql(update SQLUser.DHC_ItmDiagnose
            set ItmDia_PatientType_DR=:PatientTypeRowid,ItmDia_ItmMast_DR=:ARCIMID,ItmDia_Diagnose_DR=:MRCICDDR,ItmDia_Remark=:Remark
            where ItmDia_Rowid=:Rowid )
	}
	Q SQLCODE
}

Query GetWeekDiagnose(HospId As %String = "") As %Query(ROWSPEC = "WeekNum:%String,DiagnoseDR:%String,MRCIDDesc:%String")
{
}

ClassMethod GetWeekDiagnoseExecute(ByRef qHandle As %Binary, HospId As %String = "") As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.ItmDiagnose","GetWeekDiagnose")
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
	s ind=1
	i ($g(HospId)="")&&($d(%session)) s HospId=%session.Get("LOGON.HOSPID")
	if (HospId'="") {
		s HospCodeNode="HospDr_"_HospId
		s WeekNum=""
		for {
			s WeekNum=$O(^DHCDocConfig(HospCodeNode,"WeekGestationDia",WeekNum))
			q:WeekNum=""
			s DiagnoseDR=$G(^DHCDocConfig(HospCodeNode,"WeekGestationDia",WeekNum))
			s DiagnoseDesc=$p(^MRC("ID",DiagnoseDR),"^",2)
			d OutPut2
		}
	}else{
		s WeekNum=""
		for {
			s WeekNum=$O(^DHCDocConfig("WeekGestationDia",WeekNum))
			q:WeekNum=""
			s DiagnoseDR=$G(^DHCDocConfig("WeekGestationDia",WeekNum))
			s DiagnoseDesc=$p(^MRC("ID",DiagnoseDR),"^",2)
			d OutPut2

		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutPut2
	s Data=$LB(WeekNum,DiagnoseDR,DiagnoseDesc)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Quit
}

ClassMethod GetWeekDiagnoseClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetWeekDiagnoseExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetWeekDiagnoseFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetWeekDiagnoseExecute ]
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

ClassMethod saveWeekDiagnose(WeekNum As %String, DiagnoseDr As %String, HospId As %String = "") As %String
{
	if ((WeekNum="")||(DiagnoseDr="")) q "-100"
	i ($g(HospId)="")&&($d(%session)) s HospId=%session.Get("LOGON.HOSPID")
	if (HospId'="") {
		s HospCodeNode="HospDr_"_HospId
		Q:$d(^DHCDocConfig(HospCodeNode,"WeekGestationDia",WeekNum)) "存在相同的周数！"
		s ^DHCDocConfig(HospCodeNode,"WeekGestationDia",WeekNum)=DiagnoseDr
	}else{
		Q:$d(^DHCDocConfig("WeekGestationDia",WeekNum)) "存在相同的周数！"
		s ^DHCDocConfig("WeekGestationDia",WeekNum)=DiagnoseDr
	}
	q 0
}

ClassMethod deleteWeekDiagnose(WeekNum As %String, HospId As %String = "") As %String
{
	if ((WeekNum="")) q "-100"
	i ($g(HospId)="")&&($d(%session)) s HospId=%session.Get("LOGON.HOSPID")
	if (HospId'="") {
		s HospCodeNode="HospDr_"_HospId
		k ^DHCDocConfig(HospCodeNode,"WeekGestationDia",WeekNum)
	}else{
		k ^DHCDocConfig("WeekGestationDia",WeekNum)
	}
	q 0
}

ClassMethod GetWeekDiagnose(WeekNum As %String, HospId As %String = "") As %String
{
	if ((WeekNum="")) q ""
	i ($g(HospId)="")&&($d(%session)) s HospId=%session.Get("LOGON.HOSPID")
	if (HospId'="") {
		s HospCodeNode="HospDr_"_HospId
		q $G(^DHCDocConfig(HospCodeNode,"WeekGestationDia",WeekNum))
	}else{
		q $G(^DHCDocConfig("WeekGestationDia",WeekNum))
	}
}

}
