Class web.DHCEkgSystemParam Extends %RegisteredObject
{

ClassMethod GetSystemParam() As %String
{
	
	s ItemMoreReport="N"
	s MoreItemReport="N"
	s SendApptoLoc="Y"
	s SendInPtoLoc="Y"
	s SendOutPtoLoc="Y"
	s SendEmPtoLoc="N"
	s SayAppCfl="Y"
	s DSPAppointmentInterval="30"
	s QueryonlyExam="N"
	s AllowOpRegNotPaid="Y"
	s AllowIpRegNotPaid="Y"
	s AllowHPRegNotPaid="N"
	s AllowEMRegNotPaid="Y"
	s SendHPtoLoc="Y"
	s DHCRisVersion="BJ_JST"
	s FileVersion = "315"
	s FilePath = ""
	s rowid=0
	s rowid=$o(^DHCRBC("SystemParam",rowid))
	i rowid'="" d 
	.s ItemMoreReport=$p(^DHCRBC("SystemParam",rowid),"^",1)
	.s MoreItemReport=$p(^DHCRBC("SystemParam",rowid),"^",2)
	.s SendApptoLoc=$p(^DHCRBC("SystemParam",rowid),"^",3)
	.s SendEmPtoLoc=$p(^DHCRBC("SystemParam",rowid),"^",4)
	.s SendInPtoLoc=$p(^DHCRBC("SystemParam",rowid),"^",5)
	.s SendOutPtoLoc=$p(^DHCRBC("SystemParam",rowid),"^",6)
	.s SayAppCfl=$p(^DHCRBC("SystemParam",rowid),"^",7)	
	.s DSPAppointmentInterval=$p(^DHCRBC("SystemParam",rowid),"^",8)	
	.s QueryonlyExam=$p(^DHCRBC("SystemParam",rowid),"^",9)
	.s SendHPtoLoc=$p(^DHCRBC("SystemParam",rowid),"^",10)
	.s AllowOpRegNotPaid=$p(^DHCRBC("SystemParam",rowid),"^",11)
	.s AllowIpRegNotPaid=$p(^DHCRBC("SystemParam",rowid),"^",12)
	.s AllowHPRegNotPaid=$p(^DHCRBC("SystemParam",rowid),"^",13)
	.s AllowEMRegNotPaid=$p(^DHCRBC("SystemParam",rowid),"^",14)
	.s DHCRisVersion=$p(^DHCRBC("SystemParam",rowid),"^",15)
	.s FileVersion=$p(^DHCRBC("SystemParam",rowid),"^",16)
	.s FilePath = $p(^DHCRBC("SystemParam",rowid),"^",17)
	s Info=ItemMoreReport_"^"_MoreItemReport_"^"_SendApptoLoc_"^"_SendInPtoLoc_"^"_SendOutPtoLoc_"^"_SendEmPtoLoc_"^"_SayAppCfl_"^"_DSPAppointmentInterval_"^"_QueryonlyExam_"^"_SendHPtoLoc_"^"_AllowOpRegNotPaid_"^"_	AllowIpRegNotPaid_"^"_AllowHPRegNotPaid_"^"_AllowEMRegNotPaid_"^"_DHCRisVersion_"^"_FileVersion_"^"_FilePath
	q Info
}

ClassMethod GetDateDigital(strDate As %String) As %String
{
	// 格式2006-12-13
	
	q $zdh(strDate,3)
}

ClassMethod GetDateFormat(DateDigital As %String) As %String
{
	// 格式2006-12-13
	q $zd(DateDigital,3)
}

ClassMethod GetTimeDigital(strTime As %String) As %String
{
   q $zth(strTime,3)
}

ClassMethod GetTimeFormat(TimeDigital As %String) As %String
{
	q $zt(TimeDigital,3)
}

ClassMethod SetMedTrakNameSpace()
{
	;zn "MEDDATA"
	zn "DHC-DATA"
}

ClassMethod SetEKGNameSpace()
{
	;zn "DHC-EKG-DEV"
	;zn "DHC-EKG-DEV-TEST"
	zn "DHC-EKG"
}

ClassMethod SetEKGNameSpaceRemote()
{
	;ZN "DHC-EKG-NDEY"
	;ZN "DHC-EKG-46NEW"
	;ZN "EKG"
	;zn "DHC-EKG-DS-STARDAR"
	zn "DHC-EKG-CL"
	;zn "DHC-EKG"
}

ClassMethod SetWebNameSpace()
{
	;zn "websrc"
	;zn "websource"
	zn "DHC-APP"
}

ClassMethod SetEPRNameSpace()
{
	zn "EPR"
}

Query QueryDHCRBCSystemParam() As %Query(ROWSPEC = "Rowid:%String,MoreItem:%String,MoreReport:%String,SendOutPItoLoc:%String,SendEmergItoLoc:%String,SendInPItoLoc:%String,SendApptoLoc:%String,SendHPtoLoc:%String,AppointmentConflict:%String,AppointmentInterval:%String,OnlyQueryExamItm:%String,Version:%String,AllowOPRegNotPaid:%String,AllowIPRegNotPaid:%String,AllowHPRegNotPaid:%String,AllowEMRegNotPaid:%String,FileVersion:%String,FilePath:%String")
{
}

ClassMethod QueryDHCRBCSystemParamExecute(ByRef qHandle As %Binary) As %Status
{
	//d ##class(%ResultSet).RunQuery("web.DHCEkgSystemParam","QueryDHCRBCSystemParam")
	//DSP_RowID--DSP_MoreItem_Report--DSP_Item_MoreReport--DSP_SendOutPItoLoc--
	//DSP_SendEmergItoLoc--DSP_SendInPItoLoc--DSP_SendApptoLoc--DSP_SendHPtoLoc--
	//DSP_AppointmentConflict--DSP_AppointmentInterval--DSP_OnlyQueryExamItm--
	//DSP_Version--DSP_AllowOPRegNotPaid--DSP_AllowIPRegNotPaid--DSP_AllowHPRegNotPaid--DSP_AllowEMRegNotPaid
	//^DHCRBC("SystemParam",{DSP_RowID})
	//表中没有DSP_Version这个字段
	Set repid=$I(^CacheTemp)
	s ind=1
	s (MoreItem,MoreReport,SendOutPItoLoc,SendEmergItoLoc,SendInPItoLoc,SendApptoLoc)=""
	s (SendHPtoLoc,AppointmentConflict,AppointmentInterval,OnlyQueryExamItm,Version)=""
	s (AllowOPRegNotPaid,AllowIPRegNotPaid,AllowHPRegNotPaid,AllowEMRegNotPaid)=""
	s Rowid=""
	f  s Rowid=$o(^DHCRBC("SystemParam",Rowid)) q:(Rowid="")  d
	.s MoreReport=$P(^DHCRBC("SystemParam",Rowid),"^",1)
	.//s MoreItem=$p(^CTLOC(LocDR),"^",2)
	.s MoreItem=$P(^DHCRBC("SystemParam",Rowid),"^",2)
	.s SendApptoLoc=$P(^DHCRBC("SystemParam",Rowid),"^",3)
	.s SendEmergItoLoc=$P(^DHCRBC("SystemParam",Rowid),"^",4)
	.s SendInPItoLoc=$P(^DHCRBC("SystemParam",Rowid),"^",5)
	.s SendOutPItoLoc=$P(^DHCRBC("SystemParam",Rowid),"^",6)
	.s AppointmentConflict=$P(^DHCRBC("SystemParam",Rowid),"^",7)
	.s AppointmentInterval=$P(^DHCRBC("SystemParam",Rowid),"^",8)
	.s OnlyQueryExamItm=$P(^DHCRBC("SystemParam",Rowid),"^",9)
	.s SendHPtoLoc=$P(^DHCRBC("SystemParam",Rowid),"^",10)
	.s AllowOPRegNotPaid=$P(^DHCRBC("SystemParam",Rowid),"^",11)
	.s AllowIPRegNotPaid=$P(^DHCRBC("SystemParam",Rowid),"^",12)
	.s AllowHPRegNotPaid=$P(^DHCRBC("SystemParam",Rowid),"^",13)
	.s AllowEMRegNotPaid=$P(^DHCRBC("SystemParam",Rowid),"^",14)
	.s Version=$P(^DHCRBC("SystemParam",Rowid),"^",15)
	.s FileVersion=$P(^DHCRBC("SystemParam",Rowid),"^",16)
	.s FilePath=$P(^DHCRBC("SystemParam",Rowid),"^",17)
	.Do ExportSystemParam
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
ExportSystemParam
	set Data=$lb(Rowid,MoreItem,MoreReport,SendOutPItoLoc,SendEmergItoLoc,SendInPItoLoc,SendApptoLoc,
	SendHPtoLoc,AppointmentConflict,AppointmentInterval,OnlyQueryExamItm,Version,
	AllowOPRegNotPaid,AllowIPRegNotPaid,AllowHPRegNotPaid,AllowEMRegNotPaid,FileVersion,FilePath)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod QueryDHCRBCSystemParamFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryDHCRBCSystemParamExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod QueryDHCRBCSystemParamClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryDHCRBCSystemParamExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

Query QueryDHCRBCLocParam() As %Query(ROWSPEC = "Rowid:%String,SystemSDate:%String,SystemEDate:%String,PrintAutoVerify:%String,PrintAutoIssue:%String,VerifyAutoIssue:%String,VerifyNeedsPWD:%String,LocDR:%String,ServerDR:%String,AutoDowndload:%String,PrintBookedTemlate:%String,PrintRegTemplate:%String,PrintRegListTemplate:%String,SendDate:%String,ExamineAfterFree:%String")
{
}

ClassMethod QueryDHCRBCLocParamExecute(ByRef qHandle As %Binary) As %Status
{
	//d ##class(%ResultSet).RunQuery("web.DHCEkgSystemParam","QueryDHCRBCLocParam")
	//DLP_RowID--DLP_BRSystemSDate--DLP_BRSystemEDate--DLP_PrintAutoVerify
	//--DLP_PrintAutoIssue--DLP_VerifyAutoIssue
	//DLP_VerifyNeedsPWD--DLP_Loc_DR--DLP_Server_DR--DLP_AutoDowndload
	//^DHCRBC("LocParam",{DLP_RowID}) 
	Set repid=$I(^CacheTemp)
	s ind=1 
	s (Rowid,SystemSDate,SystemEDate,PrintAutoVerify,PrintAutoIssue)=""
	s (VerifyAutoIssue,VerifyNeedsPWD,LocDR,ServerDR,AutoDowndload,ExamineAfterFree)=""  //add--yzd--090302:ExamineAfterFree
	s Rowid=""
	f  s Rowid=$o(^DHCRBC("LocParam",Rowid)) q:(Rowid="")  d
	.s SystemSDate=$P(^DHCRBC("LocParam",Rowid),"^",1)
	.s SystemEDate=$p(^DHCRBC("LocParam",Rowid),"^",2)
	.s PrintAutoVerify=$P(^DHCRBC("LocParam",Rowid),"^",5)
	.s PrintAutoIssue=$P(^DHCRBC("LocParam",Rowid),"^",4)
	.s VerifyAutoIssue=$P(^DHCRBC("LocParam",Rowid),"^",7)
	.s VerifyNeedsPWD=$P(^DHCRBC("LocParam",Rowid),"^",6)
	.s LocDR=$P(^DHCRBC("LocParam",Rowid),"^",3)
	.s:LocDR'="" LocDR=$P(^CTLOC(LocDR),"^",2)
	.s ServerDR=$P(^DHCRBC("LocParam",Rowid),"^",8)
	.s:ServerDR'="" ServerDR=$P(^DHCRBCServer("Server",ServerDR),"^",1)
	.s AutoDowndload=$P(^DHCRBC("LocParam",Rowid),"^",9)
	.s PrintBookedTemlate=$P(^DHCRBC("LocParam",Rowid),"^",10)
	.s PrintRegTemplate=$P(^DHCRBC("LocParam",Rowid),"^",11)
	.s PrintRegListTemplate=$P(^DHCRBC("LocParam",Rowid),"^",12)
	.s SendDate=$P(^DHCRBC("LocParam",Rowid),"^",13)
	.s ExamineAfterFree=$P(^DHCRBC("LocParam",Rowid),"^",14)    //add--yzd--090302
	.Do ExportLocParam
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
ExportLocParam
	set Data=$lb(Rowid,SystemSDate,SystemEDate,PrintAutoVerify,
	PrintAutoIssue,VerifyAutoIssue,VerifyNeedsPWD,LocDR,ServerDR,
	AutoDowndload,PrintBookedTemlate,PrintRegTemplate,PrintRegListTemplate,SendDate,ExamineAfterFree)  //add--yzd--090302:ExamineAfterFree
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod QueryDHCRBCLocParamFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryDHCRBCLocParamExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod QueryDHCRBCLocParamClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryDHCRBCLocParamExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod SetDHCRBCLocParam(AllInfo As %String, OperateCode As %String) As %String
{
	//d ##class(web.DHCEkgSystemParam).SetDHCRBCLocParam("","I")
}

Query QueryDHCRBCReportStatus() As %Query(ROWSPEC = "Rowid:%String,Code:%String,Desc:%String")
{
}

ClassMethod QueryDHCRBCReportStatusExecute(ByRef qHandle As %Binary) As %Status
{
	//d ##class(%ResultSet).RunQuery("web.DHCEkgSystemParam","QueryDHCRBCReportStatus")
    //DRS_RowID,DRS_Code,DRS_Desc
	//^DHCRBCStatus("ReportStatus",{DRS_RowID})
	Set repid=$I(^CacheTemp)
	s ind=1
	s (Rowid,Code,Desc)=""
	s Rowid=""
	f  s Rowid=$o(^DHCRBCStatus("ReportStatus",Rowid)) q:(Rowid="")  d
	.s Code=$P(^DHCRBCStatus("ReportStatus",Rowid),"^",1)
	.s Desc=$p(^DHCRBCStatus("ReportStatus",Rowid),"^",2)
	.Do ExportRBCReportStatus
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
ExportRBCReportStatus
	set Data=$lb(Rowid,Code,Desc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod QueryDHCRBCReportStatusFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryDHCRBCReportStatusExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod QueryDHCRBCReportStatusClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryDHCRBCReportStatusExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

Query QueryDHCRBCPatientStatus() As %Query(ROWSPEC = "Rowid:%String,Code:%String,Desc:%String")
{
}

ClassMethod QueryDHCRBCPatientStatusExecute(ByRef qHandle As %Binary) As %Status
{
	//d ##class(%ResultSet).RunQuery("web.DHCEkgSystemParam","QueryDHCRBCPatientStatus")
    //DPS_RowID,DPS_Code,DPS_Desc
	//^DHCRBCStatus("PatientStatus",{DPS_RowID})  
	Set repid=$I(^CacheTemp)
	s ind=1
	s (Rowid,Code,Desc)=""
	s Rowid=""
	f  s Rowid=$o(^DHCRBCStatus("PatientStatus",Rowid)) q:(Rowid="")  d
	.s Code=$P(^DHCRBCStatus("PatientStatus",Rowid),"^",1)
	.s Desc=$p(^DHCRBCStatus("PatientStatus",Rowid),"^",2)
	.Do ExportRBCPatientStatus
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
ExportRBCPatientStatus
	set Data=$lb(Rowid,Code,Desc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod QueryDHCRBCPatientStatusFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryDHCRBCPatientStatusExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod QueryDHCRBCPatientStatusClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryDHCRBCPatientStatusExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

Query QueryStudyNoCreatRule() As %Query(ROWSPEC = "Rowid:%String,EQGroup:%String,Prefix:%String,MaxNumber:%String,LocDR:%String,AppType:%String,SubCatDesc:%String")
{
}

ClassMethod QueryStudyNoCreatRuleExecute(ByRef qHandle As %Binary) As %Status
{
	//d ##class(%ResultSet).RunQuery("web.DHCEkgSystemParam","QueryStudyNoCreatRule")
    //RSC_Rowid,RSC_EQGroup_DR,RSC_PREFIX,RSC_MAXNUMBER,RSC_Loc_DR
    //EQGroup:%String,Prefix:%String,MaxNumber:%String,LocDR:%String
	//^DHCPACRegInfoCR("CreateRule",0,{RSC_Rowid})
	Set repid=$I(^CacheTemp)
	s ind=1
	s (Rowid,Code,Desc)=""
	s Rowid=""
	f  s Rowid=$o(^DHCPACRegInfoCR("CreateRule",0,Rowid)) q:(Rowid="")  d
	.s EQGroup=$P(^DHCPACRegInfoCR("CreateRule",0,Rowid),"^",1)
	.i (EQGroup'="") d
	..i $g(^RBC("GRP",EQGroup))'="" s EQGroup=$P(^RBC("GRP",EQGroup),"^",2)
	.s Prefix=$p(^DHCPACRegInfoCR("CreateRule",0,Rowid),"^",2)
	.s LocDR=$p(^DHCPACRegInfoCR("CreateRule",0,Rowid),"^",3)
	.s:LocDR'="" LocDR=$P(^CTLOC(LocDR),"^",2)
	.s MaxNumber=$p(^DHCPACRegInfoCR("CreateRule",0,Rowid),"^",4)
	.s AppType=$p(^DHCPACRegInfoCR("CreateRule",0,Rowid),"^",5)
	.s SubCatDR=$p(^DHCPACRegInfoCR("CreateRule",0,Rowid),"^",6)
	.s ArcItemCatDesc=""
	.i SubCatDR'="" d
	..s ArcItemCatDesc=$p(^ARC("IC",SubCatDR),"^",2)  
	.Do ExportStudyNoCreatRule
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
ExportStudyNoCreatRule
	set Data=$lb(Rowid,EQGroup,Prefix,MaxNumber,LocDR,AppType,ArcItemCatDesc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod QueryStudyNoCreatRuleFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryStudyNoCreatRuleExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod QueryStudyNoCreatRuleClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryStudyNoCreatRuleExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod GetRegNoLength() As %String
{
  s PATCFid="",len=8
  s PATCFid=$o(^CF("PATCF",""))
  i PATCFid'="" s len=$p($g(^CF("PATCF",PATCFid,3)),"^",5)
  i len="" s len=8
  q len
}

ClassMethod ActiveConnDB()
{
  s Time=$zdt($h,3)
  s ^ActiveConnDB=Time
}

Storage Default
{
<Data name="DHCEkgSystemParamDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCEkgSystemParamD</DataLocation>
<DefaultData>DHCEkgSystemParamDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^web.DHCEkgSystemParamD</IdLocation>
<IndexLocation>^web.DHCEkgSystemParamI</IndexLocation>
<StreamLocation>^web.DHCEkgSystemParamS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
