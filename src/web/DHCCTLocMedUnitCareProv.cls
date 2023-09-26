Import SQLUser

Class web.DHCCTLocMedUnitCareProv Extends DHCDoc.Util.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Parameter BUILD = 23;

ClassMethod MedUnitPersonClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = MedUnitPersonExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

/// W ##class(%ResultSet).RunQuery("web.DHCCTLocMedUnitCareProv","MedUnitPerson","1||5")
ClassMethod MedUnitPersonExecute(ByRef qHandle As %Binary, MURowid As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1   
	//s ^ss(802)=MURowid
	Set qHandle=$lb(0,repid,0)
	q:MURowid="" $$$OK
    s CTLocDr=$p(MURowid,"||",1)
    s CTMUChildsub=$p(MURowid,"||",2)
    ;q:((CTLocDr="")!(CTMUChildsub="")) $$$OK
    s MUCPChildsub="0"
    f  s MUCPChildsub=$o(^CTLOC(CTLocDr,"MU", CTMUChildsub,"CP", MUCPChildsub))    q:MUCPChildsub=""   d
    .s MUCPDateFrom="",MUCPDateTo=""
    .s MUCPDoctorDR=$p(^CTLOC(CTLocDr,"MU", CTMUChildsub,"CP", MUCPChildsub),"^",1)
    .q:MUCPDoctorDR="" 
    .s TMPMUCPRowid=CTLocDr_"||"_ CTMUChildsub_"||"_MUCPChildsub
    .s CTPCPCode=$p(^CTPCP(MUCPDoctorDR,1),"^",1)
	.s CTPCPDescNew=$p(^CTPCP(MUCPDoctorDR,1),"^",2)
	.s TMUCPLeader=$p(^CTLOC(CTLocDr,"MU", CTMUChildsub,"CP", MUCPChildsub),"^",2)
    .s:TMUCPLeader="Y" MUCPLeaderFlag="是"
    .s:TMUCPLeader="N" MUCPLeaderFlag="否"
    .s TMUCPOP=$p(^CTLOC(CTLocDr,"MU", CTMUChildsub,"CP", MUCPChildsub),"^",3)
	.s:TMUCPOP="Y" MUCPOPFlag="出诊"
    .s:TMUCPOP="N" MUCPOPFlag="不出诊"
    .s TMUCPIP=$p(^CTLOC(CTLocDr,"MU", CTMUChildsub,"CP", MUCPChildsub),"^",4)
	.s:TMUCPIP="N" MUCPIPFlag="不出诊"
	.s:TMUCPIP="Y" MUCPIPFlag="出诊"
    .s TMPMUCPDateFrom=$p(^CTLOC(CTLocDr,"MU", CTMUChildsub,"CP", MUCPChildsub),"^",5)
    .s MUCPDateFrom=$zd(TMPMUCPDateFrom,4) 
    .s TMPMUCPDateTo=$p(^CTLOC(CTLocDr,"MU", CTMUChildsub,"CP", MUCPChildsub),"^",6)
	.s:(TMPMUCPDateTo'="") MUCPDateTo=$zd(TMPMUCPDateTo,4)
    .d BuildCont1
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
BuildCont1      
	set Data=$lb(CTPCPDescNew,CTPCPCode,MUCPLeaderFlag,MUCPOPFlag,MUCPIPFlag,MUCPDateFrom,MUCPDateTo,MUCPDoctorDR,TMUCPLeader,TMUCPOP,TMUCPIP,TMPMUCPRowid)  
	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod MedUnitPersonFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = MedUnitPersonExecute ]
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

Query MedUnitPerson(MURowid As %String) As %Query(ROWSPEC = "TCTPCPDescNew:%String,TCTPCPCode:%String,TMUCPLeaderFlag:%String,TMUCPOPFlag:%String,TMUCPIPFlag:%String,TMUCPDateFrom:%String,TMUCPDateTo:%String,TMUCPDoctorDR:%String,TMUCPLeader:%String,TMUCPOP:%String,TMUCPIP:%String,TMPMUCPRowid:%String")
{
}

ClassMethod CTPCPDRClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = CTPCPDRExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

/// W ##class(%ResultSet).RunQuery("web.DHCCTLocMedUnitCareProv","CTPCPDR","14||2")
ClassMethod CTPCPDRExecute(ByRef qHandle As %Binary, MURowid As %String, CTPCPDescNew As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	Set qHandle=$lb(0,repid,0)
	s CTPCPDescNewCompare=$ZCVT(CTPCPDescNew,"U")
   	s CTLocDr=$p(MURowid,"||",1)
	q:CTLocDr="" 
	q:$d(^RB("RES",0,"CTLOC",CTLocDr))=0 $$$OK
	s RESRowId="0"
	f  s RESRowId=$o(^RB("RES",0,"CTLOC",CTLocDr,RESRowId)) q:RESRowId=""  d
	.s RESCTPCPDR=$p(^RB("RES",RESRowId),"^",2)
	.q:(RESCTPCPDR="")||('$d(^CTPCP(RESCTPCPDR,1)))
	.s CTPCPCode=$p(^CTPCP(RESCTPCPDR,1),"^",1) 
	.s CTPCPCode=$ZCVT(CTPCPCode,"U")
	.s CTPCPDescNew=$p(^CTPCP(RESCTPCPDR,1),"^",2)
	.s CTPCPDescNew=$ZCVT(CTPCPDescNew,"U")
	.q:(CTPCPDescNewCompare'="")&((CTPCPDescNew'[CTPCPDescNewCompare)&&(CTPCPCode'[CTPCPDescNewCompare))
	.s CTChildsub="0",Flag="N",CTMUDesc="空闲",MUCPRowid=""
	.f  s CTChildsub=$o(^CTLOC(CTLocDr,"MU",CTChildsub)) q:((CTChildsub="")!(Flag'="N"))  d
	..s MUCPChildsub=0
	..f  s MUCPChildsub=$o(^CTLOC(CTLocDr,"MU", CTChildsub,"CP", MUCPChildsub))  q:((MUCPChildsub="")!(Flag'="N"))  d 
	...s MUCPDoctorDR=$p(^CTLOC(CTLocDr,"MU", CTChildsub,"CP", MUCPChildsub),"^",1)
	...q:(MUCPDoctorDR'=RESCTPCPDR)
	...s Flag="Y"
	...s MUCPRowid=CTLocDr_"||"_CTChildsub_"||"_MUCPChildsub
	...s CTMUDesc=$p(^CTLOC(CTLocDr,"MU",CTChildsub),"^",2)	
	.d BuildCont2
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
BuildCont2      
	set Data=$lb(CTPCPDescNew,CTPCPCode,CTMUDesc,RESCTPCPDR,MUCPRowid)  
	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod CTPCPDRFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = CTPCPDRExecute ]
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

Query CTPCPDR(MURowid As %String, CTPCPDescNew As %String = "") As %Query(ROWSPEC = "TCTPCPDescNew:%String,TCTPCPCode:%String,CTMUDesc:%String,RESCTPCPDR:%String,TMUCPRowid:%String")
{
}

// w ##class(web.DHCCTLocMedUnitCareProv).Insert("23^N^18/08/2010^^^N^133||4")

ClassMethod Insert(InString) As %String
{
	//InString=RESCTPCPDR+"^"+MUCPLeaderFlag+"^"+MUCPDateFrom+"^"+MUCPDateTo+"^"+MUCPOPFlag+"^"+MUCPIPFlag+"^"+MURowid
	
 n (InString)

	s ^ss("jkjkj")=InString
	s PLIST(5)=$P(InString,"^",2)   
	s tmpMUCPDateFrom=$P(InString,"^",3)    
    s PLIST(8)=$zdh(tmpMUCPDateFrom,4)
    s tmpMUCPDateTo=$P(InString,"^",4)            
	s:tmpMUCPDateTo'="" PLIST(9)=$zdh(tmpMUCPDateTo,4)            
	s PLIST(6)=$P(InString,"^",5)
	s PLIST(7)=$P(InString,"^",6)
	s RESCTPCPDR=$p(InString,"^",1)
	s PLIST(4)=RESCTPCPDR
	s PLIST(0)=$p(InString,"^",7)
	&sql(insert into DHC_CTLoc_MedUnitCareProv  values PLIST())    
	q:SQLCODE SQLCODE
	s flag=$p(%ROWID,$c(1))
	q flag
}

/// w ##class(web.DHCCTLocMedUnitCareProv).Delete("1||5||5")
ClassMethod Delete(MUCPRowid) As %String
{
   
	n (MUCPRowid)
	s CTLocDr=$p(MUCPRowid,"||",1)
	s MUCTChildSub=$p(MUCPRowid,"||",2)
	s MUCTPCPChildSub=$p(MUCPRowid,"||",3)
	s DateFrom=$p(^CTLOC(CTLocDr,"MU",MUCTChildSub,"CP",MUCTPCPChildSub),"^",5)
	s OutStr=-1
	s Now=..%SysDate()
	i Now>DateFrom d
	.&sql(Update DHC_CTLoc_MedUnitCareProv set MUCP_DateTo=:Now where MUCP_RowId=:MUCPRowid) 
	.q:SQLCODE
	.s OutStr=105
	e              d
	.&sql(delete from DHC_CTLoc_MedUnitCareProv where MUCP_RowId=:MUCPRowid)
	.q:SQLCODE 
	.s OutStr=0
	q OutStr
}

ClassMethod Update(InString) As %String
{
   //instring=MUCPRowid+"^"+MUCPLeaderFlag+"^"+MUCPOPFlag+"^"+MUCPIPFlag+"^"+MUCPDateFrom+"^"+MUCPDateTo+"^"+RESCTPCPDR			
   	n (InString)
	S MPMUCPRowid=$p(InString,"^",1)         
	s MUCPLeaderFlag=$P(InString,"^",2)        
	s MUCPOPFlag=$P(InString,"^",3)         
    s MUCPIPFlag=$P(InString,"^",4)
    s MUCPDateFrom=$P(InString,"^",5)           
	s MUCPDateFrom=$zdh(MUCPDateFrom,4)            
    s MUCPDateTo=$P(InString,"^",6)
    s:(MUCPDateTo'="") MUCPDateTo=$zdh(MUCPDateTo,4)
    s MUCPDoctorDR=$P(InString,"^",7)


	&sql(Update DHC_CTLoc_MedUnitCareProv set MUCP_Doctor_DR=:MUCPDoctorDR, MUCP_LeaderFlag=:MUCPLeaderFlag,MUCP_OPFlag=:MUCPOPFlag,MUCP_DateFrom=:MUCPDateFrom,MUCP_IPFlag=:MUCPIPFlag,MUCP_DateTo=:MUCPDateTo where MUCP_RowId=:MPMUCPRowid) 
	q:SQLCODE SQLCODE
	s flag=$p(%ROWID,$c(1))
	q flag
}

/// w ##class(web.DHCCTLocMedUnitCareProv).RequiredMUCPLeader("1||5")
ClassMethod RequiredMUCPLeader(MURowid) As %String
{
	
	n (MURowid)
	q:MURowid="" 0
    s CTLocDr=$p(MURowid,"||",1)
    s CTMUChildsub=$p(MURowid,"||",2)
    s MUCPChildsub="0"
    s Flag=0
    f  s MUCPChildsub=$o(^CTLOC(CTLocDr,"MU", CTMUChildsub,"CP", MUCPChildsub)) q:MUCPChildsub=""   d
    .s MUCPLeaderFlag=$p(^CTLOC(CTLocDr,"MU", CTMUChildsub,"CP", MUCPChildsub),"^",2)
    .s RowID=CTLocDr_"||"_CTMUChildsub_"||"_MUCPChildsub
    .Q:(MURowid=RowID)
    .i MUCPLeaderFlag="Y" s Flag=1
    q Flag
}

/// w ##class(web.DHCCTLocMedUnitCareProv).limDateFrom("03/08/2010")
ClassMethod limDateFrom(MUCPDateFrom) As %String
{
                                
	n (MUCPDateFrom)
	s DateFrom=""
	s:MUCPDateFrom'="" DateFrom=$zdh(MUCPDateFrom,4)  
	s Now=..%SysDate()                  
	if DateFrom="" s DateFrom=Now
	s flag=DateFrom                    
	i (DateFrom<Now) d 
	.;s flag=Now                         
	s flag=$zd(flag,4)         
	q flag
}

/// w ##class(web.DHCCTLocMedUnitCareProv).CheckedDate(282,"20/12/2014","21/12/2014,9||2||3)
/// 1 可用 0 不可用
ClassMethod CheckedDate(MUCPDoctorDR, MUCPDateFrom, MUCPDateTo, MUCPRowid As %String = "") As %String
{
	
	n (MUCPDoctorDR,MUCPDateTo,MUCPDateFrom,MUCPRowid)
	s ^TempzogHKJK=MUCPDoctorDR_","_ MUCPDateFrom_","_MUCPDateTo_","_MUCPRowid
	s JSDateFrom=$zdh(MUCPDateFrom,4)
	i MUCPDateTo'="" s JSDateTo=$zdh(MUCPDateTo,4)
	e  s JSDateTo=""
	Q:(JSDateTo'="")&&(JSDateFrom>JSDateTo) "0^日期错误"
	Q:MUCPDoctorDR="" "0^医生不存在"
	Q:$d(^CTLOC(0,"CTPCP",MUCPDoctorDR))="0" "1^"
	s Flag=1
	s GetDescStr=""
	s CTLocDr="0"
	f  s CTLocDr=$o(^CTLOC(0,"CTPCP",MUCPDoctorDR,CTLocDr)) q:(CTLocDr="")||(Flag=0)   d
	.s CTMUChildsub="0"
	.f  s CTMUChildsub=$o(^CTLOC(0,"CTPCP",MUCPDoctorDR,CTLocDr,"MU",CTMUChildsub))  q:(CTMUChildsub="")||(Flag=0)  d
	..s MUCPChildsub="0"
	..f  s MUCPChildsub=$o(^CTLOC(0,"CTPCP",MUCPDoctorDR,CTLocDr,"MU",CTMUChildsub,"CP",MUCPChildsub))  q:(MUCPChildsub="")||(Flag=0)  d
	...s MainMURowID=CTLocDr_"||"_CTMUChildsub_"||"_MUCPChildsub
	...Q:((MUCPRowid'="")&&(MainMURowID=MUCPRowid))
	...s DateFrom=+$p(^CTLOC(CTLocDr,"MU", CTMUChildsub,"CP", MUCPChildsub),"^",5)
	...s DateTo=+$p(^CTLOC(CTLocDr,"MU", CTMUChildsub,"CP", MUCPChildsub),"^",6)
	...s CTMUDesc=$p(^CTLOC(CTLocDr,"MU",CTMUChildsub),"^",2)
	...s CTLOCDesc=$P($G(^CTLOC(CTLocDr)),"^",2)
	...if DateTo=0  d
	....s Flag=0,GetDescStr=CTLOCDesc_" "_CTMUDesc
	...else  d
	....if (JSDateFrom>=DateFrom)&&(JSDateFrom<=DateTo)  d
	.....s Flag=0,GetDescStr=CTLOCDesc_" "_CTMUDesc
	....if Flag'=0 d
	.....if JSDateTo=""  d
	......S:JSDateFrom<DateFrom Flag=0,GetDescStr=CTLOCDesc_" "_CTMUDesc
	.....else  d
	......i (JSDateTo>=DateFrom)&&(JSDateTo<=DateTo)  d
	.......s Flag=0,GetDescStr=CTLOCDesc_" "_CTMUDesc
	q Flag_"^"_GetDescStr
}

}
