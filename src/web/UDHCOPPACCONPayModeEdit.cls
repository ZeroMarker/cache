Import SQLUser

Class web.UDHCOPPACCONPayModeEdit Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

ClassMethod DelPACPM(PPMRowID As %String) As %String
{
	n (PPMRowID)
	s myrtn=0
	
	q:(PPMRowID="")
	
	s myrtn=##class(web.UDHCOPPACCONPayMode).DELETE(PPMRowID)
	
	q myrtn
}

ClassMethod InsertPACPM(INSRowID As %String, PMRowID As %String, HospId As %String) As %String
{
	n (INSRowID, PMRowID, HospId)
	s myrtn=0
	q:(INSRowID="") -200
	q:(PMRowID="") -200
	
	;判断是否有重复
	s myFlag=0
	s myPRowID=0
	f  s myPRowID=$o(^DHCOPPARCONPMODEi(0,"ADMRDR",INSRowID,myPRowID)) q:((myPRowID="")||(myFlag'=0))  d
	.s myPMRowID=$p(^DHCOPPARCONPMODE(myPRowID),"^",2)
	.q:(PMRowID'=myPMRowID)
	.s myPMHospDR=$p(^DHCOPPARCONPMODE(myPRowID),"^",8)
	.q:(HospId'=myPMHospDR)
	.s myFlag=1
	
	q:(+myFlag=1) -201
	
	k PLIST
	s PLIST(2)=INSRowID
	s PLIST(3)=PMRowID
	s PLIST(9)=HospId
	s myrtn=##class(web.UDHCOPPACCONPayMode).INSERT()
	
	q myrtn
}

Query ReadPPM(HospId As %String) As websys.Query(ROWSPEC = "PPMRowID:%String,PPMADMRDesc:%String,PPMPMDesc:%String,PPMADMRDR:%String,PPMPMDR:%String,PPMIOType:%String,PPMDefType:%String")
{
}

ClassMethod ReadPPMExecute(ByRef qHandle As %Binary, HospId As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1
	set ^TMP("ReadPPM")=HospId
	set PPMRowID=0
	for  set PPMRowID=$o(^DHCOPPARCONPMODE(PPMRowID))  quit:(PPMRowID="")  do
	.set PPMInfo=$g(^DHCOPPARCONPMODE(PPMRowID))
	.quit:(PPMInfo="")
	.set PPMADMRDR=$p(PPMInfo,"^",1)
	.set PPMPMDR=$p(PPMInfo,"^",2)
	.set PPMADMRDesc=$s((+PPMPMDR'=0):$p($g(^PAC("ADMREA",PPMADMRDR)),"^",2),1:"")
	.set PPMPMDesc=$s((+PPMPMDR'=0):$p($g(^CT("CTPM",PPMPMDR)),"^",2),1:"")
	.set PPMIOType=$p(PPMInfo,"^",3)
	.set PPMDefType=$p(PPMInfo,"^",4)
	.set PPMHospDR=$p(PPMInfo,"^",8)
	.quit:(HospId'=PPMHospDR)
	.do OutputFR
	
	quit $$$OK
OutputFR
	set Data=$lb(PPMRowID,PPMADMRDesc,PPMPMDesc,PPMADMRDR,PPMPMDR,PPMIOType,PPMDefType)
	set ^CacheTemp(repid,ind)=Data
	set ind=ind+1
	quit
}

/// Debug: do ##class(%ResultSet).RunQuery("web.UDHCOPPACCONPayModeEdit","ReadAdmReason","2")
Query ReadAdmReason(HospId As %String) As websys.Query(ROWSPEC = "id:%String,text:%String")
{
}

ClassMethod ReadAdmReasonExecute(ByRef qHandle As %Binary, HospId As %String) As %Status
{
    set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
    set ind=1
	set rowId="0"
	for  set rowId=$o(^PAC("ADMREA",rowId))  quit:(rowId="")  do
	.set tmp=$g(^PAC("ADMREA",rowId))
	.quit:(tmp="")
	.set showFlag=##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag("PAC_AdmReason", rowId, HospId)
	.quit:(showFlag="N")
	.set reaDesc=$p(tmp,"^",2)
	.set dateFrom=$p(tmp,"^",3)
    .set dateTo=$p(tmp,"^",4)
	.do OutputAdmReason
	
	quit $$$OK
OutputAdmReason
	set Data=$lb(rowId,reaDesc)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=ind+1
	quit
}

}
