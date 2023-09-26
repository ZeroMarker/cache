Class web.DHCSYD Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

ClassMethod Insert(OEORDDr As %String, OEORDType As %String) As %String
{
 s FinDate=""
 if OEORDDr="" q ""
 Set DHCSYDRowid=""
 Set OEORIStDate=$P(^OEORD(+OEORDDr,"I",$P(OEORDDr,"||",2),1),"^",9)
 Set DHCSYDRowid=$O(^DHCSYD("StDate",OEORIStDate,OEORDDr,-1))
 if DHCSYDRowid="" d
 .Set DHCSYDSTDate=$P(^OEORD(+OEORDDr,"I",$P(OEORDDr,"||",2),1),"^",9)
 .Set DHCSYDSTTime=$P(^OEORD(+OEORDDr,"I",$P(OEORDDr,"||",2),1),"^",17)
 .;Set DHCSYDEndDate=$P(^OEORD(+OEORDDr,"I",$P(OEORDDr,"||",2),1),"^",9)
 .if $D(^OEORD(+OEORDDr,"I",$P(OEORDDr,"||",2),"X",0)) d
 ..Set ExecRowid=^OEORD(+OEORDDr,"I",$P(OEORDDr,"||",2),"X",0)  
 ..Set FinDate=$P(^OEORD(+OEORDDr,"I",$P(OEORDDr,"||",2),"X",ExecRowid),"^",1)
 .Set DHCSYDType=OEORDType
 .Set DHCSYDStatus="Ready"
 .Set Parref=+OEORDDr
 .If FinDate="" Set FinDate=DHCSYDSTDate
 .&Sql(insert into SQLUSER.DHC_SYD set DHCSYD_OEORD_Dr=:OEORDDr,DHCSYD_STDate=:DHCSYDSTDate,DHCSYD_STTime=:DHCSYDSTTime,DHCSYD_Status=:DHCSYDStatus,DHCSYD_OEORD_Parref=:Parref,DHCSYD_EndDate=:FinDate,DHCSYD_Type=:DHCSYDType)
 Q "0"
}

ClassMethod InsertHLD(EpisodeID As %String) As %String
{
 // w ##class(web.DHCSYD).InsertHLD(180017)
 s SheetsRowid=##class(web.DHCPAAdmSheets).GetCurrentSheet(EpisodeID)
 q:SheetsRowid="" "101"	
 Set PAADMSDate=$P($G(^DHCPAADMS(SheetsRowid)),"^",4)
 Set PAADMSEndDate=$P($G(^DHCPAADMS(SheetsRowid)),"^",9)
 Set SheetItemRowid=0 f  s SheetItemRowid=$O(^DHCPAADMS(SheetsRowid,"I",SheetItemRowid)) Q:SheetItemRowid=""  d
 .Set OEORDDr=$P(^DHCPAADMS(SheetsRowid,"I",SheetItemRowid),"^",1)
 .Set OEORIStDate=$P(^OEORD(+OEORDDr,"I",$P(OEORDDr,"||",2),1),"^",9)
 .Set DHCSYDRowid=$O(^DHCSYD("StDate",OEORIStDate,OEORDDr,-1))
 .if DHCSYDRowid="" d
 ..Set DHCSYDSTDate=$P(^OEORD(+OEORDDr,"I",$P(OEORDDr,"||",2),1),"^",9)
 ..Set DHCSYDSTTime=$P(^OEORD(+OEORDDr,"I",$P(OEORDDr,"||",2),1),"^",17)
 ..Set DHCSYDEndDate=$P(^OEORD(+OEORDDr,"I",$P(OEORDDr,"||",2),9),"^",9)
 ..Set DHCSYDSeqNo=$P(^DHCPAADMS(SheetsRowid,"I",SheetItemRowid),"^",2)
 ..if $D(^OEORD(+OEORDDr,"I",$P(OEORDDr,"||",2),"X",0)) d
 ...Set ExecRowid=^OEORD(+OEORDDr,"I",$P(OEORDDr,"||",2),"X",0)  
 ...Set FinDate=$P(^OEORD(+OEORDDr,"I",$P(OEORDDr,"||",2),"X",ExecRowid),"^",1)
 ..Set DHCSYDType="HLD"
 ..Set DHCSYDStatus="Ready"
 ..Set Parref=+OEORDDr
 ..&Sql(insert into SQLUSER.DHC_SYD set DHCSYD_OEORD_Dr=:OEORDDr,DHCSYD_STDate=:DHCSYDSTDate,DHCSYD_STTime=:DHCSYDSTTime,DHCSYD_Status=:DHCSYDStatus,DHCSYD_OEORD_Parref=:Parref,DHCSYD_EndDate=:PAADMSEndDate,DHCSYD_Type=:DHCSYDType,DHCSYD_SeqNo=:DHCSYDSeqNo)
 Q "0"
}

ClassMethod InsertHLDBak(EpisodeID As %String) As %String
{
 Set SheetsRowid=""
 f  Set SheetsRowid=$O(^DHCPAADMS(0,"PAADM",EpisodeID,SheetsRowid)) q:SheetsRowid=""  d
 .Set PAADMSDate=$P($G(^DHCPAADMS(SheetsRowid)),"^",4)
 .Set PAADMSEndDate=$P($G(^DHCPAADMS(SheetsRowid)),"^",9)
 .Set SheetItemRowid=0 f  s SheetItemRowid=$O(^DHCPAADMS(SheetsRowid,"I",SheetItemRowid)) Q:SheetItemRowid=""  d
 ..Set OEORDDr=$P(^DHCPAADMS(SheetsRowid,"I",SheetItemRowid),"^",1)
 ..Set OEORIStDate=$P(^OEORD(+OEORDDr,"I",$P(OEORDDr,"||",2),1),"^",9)
 ..Set DHCSYDRowid=$O(^DHCSYD("StDate",OEORIStDate,OEORDDr,-1))
 ..if DHCSYDRowid="" d
 ...Set DHCSYDSTDate=$P(^OEORD(+OEORDDr,"I",$P(OEORDDr,"||",2),1),"^",9)
 ...Set DHCSYDSTTime=$P(^OEORD(+OEORDDr,"I",$P(OEORDDr,"||",2),1),"^",17)
 ...Set DHCSYDEndDate=$P(^OEORD(+OEORDDr,"I",$P(OEORDDr,"||",2),9),"^",9)
 ...Set DHCSYDSeqNo=$P(^DHCPAADMS(SheetsRowid,"I",SheetItemRowid),"^",2)
 ...if $D(^OEORD(+OEORDDr,"I",$P(OEORDDr,"||",2),"X",0)) d
 ....Set ExecRowid=^OEORD(+OEORDDr,"I",$P(OEORDDr,"||",2),"X",0)  
 ....Set FinDate=$P(^OEORD(+OEORDDr,"I",$P(OEORDDr,"||",2),"X",ExecRowid),"^",1)
 ...Set DHCSYDType="HLD"
 ...Set DHCSYDStatus="Ready"
 ...Set Parref=+OEORDDr
 ...&Sql(insert into SQLUSER.DHC_SYD set DHCSYD_OEORD_Dr=:OEORDDr,DHCSYD_STDate=:DHCSYDSTDate,DHCSYD_STTime=:DHCSYDSTTime,DHCSYD_Status=:DHCSYDStatus,DHCSYD_OEORD_Parref=:Parref,DHCSYD_EndDate=:PAADMSEndDate,DHCSYD_Type=:DHCSYDType,DHCSYD_SeqNo=:DHCSYDSeqNo)
 Q "0"
}

ClassMethod StopDrugClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = StopDrugExecute ]
{
	Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod StopDrugExecute(ByRef qHandle As %Binary, EpisodeID As %String) As %Status
{
 Set repid=$I(^CacheTemp)
 s ind=1
 if EpisodeID=""  Set qHandle=$lb(0,repid,0) quit $$$OK
	Set OeordRowid=$O(^OEORD(0,"Adm",EpisodeID,-1))
	Set UserID=%session.Get("LOGON.USERID")
	Set SYDRowid="" F  s SYDRowid=$O(^DHCSYD("OEORDPARREF",OeordRowid,SYDRowid)) Q:SYDRowid=""  d
	.Set DHCSYDStatus=$P($G(^DHCSYD(SYDRowid)),"^",4)
	.Q:DHCSYDStatus'="Ready"
	.Set OEORDDr=$P($G(^DHCSYD(SYDRowid)),"^",3)
	.Set OEORDRowId=$P(OEORDDr,"||",1)
	.Set OEORIChildsub=$P(OEORDDr,"||",2)
	.;If '$D(^OEORD(OEORDRowId,"I",OEORIChildsub)) Set qHandle=$lb(0,repid,0)  Quit $$$OK
	.q:'$D(^OEORD(OEORDRowId,"I",OEORIChildsub)) 
	.Set ItmMastrowid=$p(^OEORD(OEORDRowId,"I",OEORIChildsub,1),"^",2)
 .Set Subscript=$p(ItmMastrowid,"||",1)
 .Set Version=$p(ItmMastrowid,"||",2)
 .Set Phcdfdr=$p(^ARCIM(Subscript,Version,1),"^",12)
 .Set ARCIMDesc=$p(^ARCIM(Subscript,Version,1),"^",2)
 .Set BillingUOMdr=$p(^ARCIM(Subscript,Version,8),"^",14)
 .Set packuom=$p(^CT("UOM",BillingUOMdr),"^",2)
 .Set FrequenceRowid=$p($G(^OEORD(OEORDRowId,"I",OEORIChildsub,2)),"^",4)
 .Set DurationRowid=$p($g(^OEORD(OEORDRowId,"I",OEORIChildsub,2)),"^",6)
 .Set InstructionRowid=$p($g(^OEORD(OEORDRowId,"I",OEORIChildsub,2)),"^",7)
 .Set QtyPackUOM=$p($g(^OEORD(OEORDRowId,"I",OEORIChildsub,9)),"^",4) 
 .Set DoseQty=$p($g(^OEORD(OEORDRowId,"I",OEORIChildsub,2)),"^",1) 
 .Set PhSpecInstr=$p($g(^OEORD(OEORDRowId,"I",OEORIChildsub,2)),"^",8) 
 .Set FrequenceRowid=$p($G(^OEORD(OEORDRowId,"I",OEORIChildsub,2)),"^",4)
 .Set UpdateDate=$p($G(^OEORD(OEORDRowId,"I",OEORIChildsub,11)),"^",4)
 .Set UpdateTime=$p($G(^OEORD(OEORDRowId,"I",OEORIChildsub,11)),"^",5)
 .Set UpdateDate=$ZD(UpdateDate,3)
 .Set UpdateTime=$ZT(UpdateTime,3)
 .Set OEORIBilled=$p($G(^OEORD(OEORDRowId,"I",OEORIChildsub,3)),"^",5)
 .;Q:OEORIBilled'="TB"  //为了调试方便,上线的时候一定要改成P
 .Set DoctorDR=$p($G(^OEORD(OEORDRowId,"I",OEORIChildsub,1)),"^",11)
 .If DoctorDR'="" s DoctorDesc=$p($g(^CTPCP(DoctorDR,1)),"^",2) e  s DoctorDesc=""
 .Set UserAdd="" s UserAdd=$p($g(^OEORD(OEORDRowId,"I",OEORIChildsub,7)),"^",1) e  s UserAdd="" 
 .Q:UserAdd'=UserID
 .Set DepProcNotes=""
 .Set DepProcNotes=$p($g(^OEORD(OEORDRowId,"I",OEORIChildsub,"DEP")),"^",1)
 .Set OEORIDR=$p($G(^OEORD(OEORDRowId,"I",OEORIChildsub,11)),"^",39)
 .If OEORIDR'="" s ARCIMDesc="____"_ARCIMDesc
 .If OEORIDR="" s OEORIDR=OEORDRowId_"||"_OEORIChildsub
 .If FrequenceRowid'="" s PHCFRDesc=$p($G(^PHCFR(FrequenceRowid)),"^",1)
 .Set DoseUOM="" s DoseUOM=$p($g(^OEORD(OEORDRowId,"I",OEORIChildsub,2)),"^",3) 
 .If InstructionRowid'="" s PHCINDesc=$p($p(^PHCIN(InstructionRowid),2),"^",2)
 .s UnitPrice=##class(web.DHCDocOrderEntry).GetOrderPrice("", "", ItmMastrowid, "", "", "", "", "") 
 .s UnitPrice=$p(UnitPrice,"^",1) 
 .Set UnitPrice=$j(UnitPrice,9,2)
 .Set DurationFactor=1
 .If DurationRowid'="" d
 ..Set DurationDesc=$p(^PHCDU(DurationRowid),"^",3)  
 ..Set DurationFactor=$p(^PHCDU(DurationRowid),"^",2)
 .Set CTUOMDesc=""
 .If DoseUOM'="" s CTUOMDesc=$p($g(^CT("UOM",DoseUOM)),"^",2) 
 .Set PHCFRDesc=""
 .If FrequenceRowid'="" s PHCFRDesc=$p($g(^PHCFR(FrequenceRowid)),"^",3) 
 .Set oeoriId=OEORDDr
 .Do OutputRow1	 	

 Set qHandle=$lb(0,repid,0)
	Quit $$$OK

OutputRow1
	set Data=$lb(ARCIMDesc,QtyPackUOM,packuom,DoseQty,CTUOMDesc,PHCINDesc,PHCFRDesc,UpdateDate,UpdateTime,DoctorDesc,DurationDesc,UnitPrice,DepProcNotes,DoseQty,OEORIBilled,oeoriId)
 Set ^CacheTemp(repid,ind)=Data
 Set ind=ind+1
	quit
}

ClassMethod StopDrugFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = StopDrugExecute ]
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

ClassMethod StopDrugM(OEORIRowid As %String, user As %String)
{
	if OEORIRowid="" Q "-257"
	Set SYDrowid=$O(^DHCSYD("OEORD",OEORIRowid,-1))
	Q:$G(SYDrowid)=""
	Set DHCSYDType=$P(^DHCSYD(SYDrowid),"^",12)
	if DHCSYDType'="HLD" {
	Set OEORIStDate=$P(^OEORD(+OEORIRowid,"I",$P(OEORIRowid,"||",2),1),"^",9)
 Set OEORIOEORIDR=$P(^OEORD(+OEORIRowid,"I",$P(OEORIRowid,"||",2),11),"^",39)
 Set MasterOEORI=OEORIRowid
 If OEORIOEORIDR'="" Set MasterOEORI=OEORIOEORIDR 
 K ^TEMP("SYDSTOPDrug",$j)
 Set ^TEMP("SYDSTOPDrug",$j)=MasterOEORI
 Set i=1
 Set OEORIChildsub=0 f  S OEORIChildsub=$O(^OEORD($P(MasterOEORI,"||",1),"I",OEORIChildsub)) Q:OEORIChildsub=""  d
 .Set SubOEORIOEORIDR=$P(^OEORD($P(MasterOEORI,"||",1),"I",OEORIChildsub,11),"^",39)
 .If SubOEORIOEORIDR=MasterOEORI Set ^TEMP("SYDSTOPDrug",$j,"Sub",i)=$P(MasterOEORI,"||",1)_"||"_OEORIChildsub
 .Set i=i+1
 If $D(^TEMP("SYDSTOPDrug",$j,"Sub")) {
	    s GetSub=0 f  s GetSub=$O(^TEMP("SYDSTOPDrug",$j,"Sub",GetSub)) Q:GetSub=""  d
	    .Set SubOeord=^TEMP("SYDSTOPDrug",$j,"Sub",GetSub)
	    .Set OEORIStDate=$P(^OEORD($P(SubOeord,"||",1),"I",$P(SubOeord,"||",2),1),"^",9)
	    .Set DHCSYDRowid=$O(^DHCSYD("StDate",OEORIStDate,SubOeord,-1))
	    .Set $P(^DHCSYD(DHCSYDRowid),"^",4)="Stop"
	    .Set $P(^DHCSYD(DHCSYDRowid),"^",7)=+$h
	    .Set $P(^DHCSYD(DHCSYDRowid),"^",8)=$P($h,",",2)
	    .Set $P(^DHCSYD(DHCSYDRowid),"^",9)=user
	 }
	Set MasterOEORI=^TEMP("SYDSTOPDrug",$j)
 Set DHCSYDRowid=$O(^DHCSYD("StDate",OEORIStDate,MasterOEORI,-1))
 Set $P(^DHCSYD(DHCSYDRowid),"^",4)="Stop"
 Set $P(^DHCSYD(DHCSYDRowid),"^",7)=+$h
 Set $P(^DHCSYD(DHCSYDRowid),"^",8)=$P($h,",",2)
 Set $P(^DHCSYD(DHCSYDRowid),"^",9)=user
	Q "0"
	}else{
 Set $P(^DHCSYD(SYDrowid),"^",4)="Stop"
 Set $P(^DHCSYD(SYDrowid),"^",7)=+$h
 Set $P(^DHCSYD(SYDrowid),"^",8)=$P($h,",",2)
 Set $P(^DHCSYD(SYDrowid),"^",9)=user
	Q "0"}
}

Query StopDrug(EpisodeID As %String) As %Query(ROWSPEC = "ARCIMDesc:%String,QtyPackUOM:%String,packuom:%String,DoseQty:%String,CTUOMDesc:%String,PHCINDesc:%String,PHCFRDesc:%String,UpdateDate:%String,UpdateTime:%String,DoctorDesc:%String,DurationDesc:%String,UnitPrice:%String,DepProcNotes:%String,DoseQty:%String,OEORIBilled:%String,oeoriId:%String")
{
}

}
