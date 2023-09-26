Class web.DHCPE.Report.GDoctorWorkStatic Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 154;

// d ##class(%ResultSet).RunQuery("web.DHCPE.Report.GDoctorWorkStatic","GDoctorWorkStatistic","61056", "61103")

Query GDoctorWorkStatistic(DateBegin As %Library.String = "", DateEnd As %Library.String = "", DocType As %Library.String = "", VIPLevel As %Library.String = "", GroupDR As %Library.String = "") As %Query(ROWSPEC = "TGDoctorName:%String,TGDWA_Amount:%String,TGDoctorNo:%String,TGDoctorID:%String,TDocType:%String")
{
}

ClassMethod GDoctorWorkStatisticExecute(ByRef qHandle As %Binary, DateBegin As %Library.String = "", DateEnd As %Library.String = "", DocType As %Library.String = "", VIPLevel As %Library.String = "", GroupDR As %Library.String = "") As %Status
{
 
 	s ind=1
 	s id=0	
	Set repid=$I(^CacheTemp)
 	S J=$j
 	
 	i DocType=""  s DocType="G"

 	i DateBegin'="" s DateBegin=##class(websys.Conversions).DateHtmlToLogical(DateBegin)
	i DateEnd'="" s DateEnd=##class(websys.Conversions).DateHtmlToLogical(DateEnd)
	
    if DocType="G"{
    i ((""'=DateBegin)||(""'=DateEnd)) d
 	.i 0'=+DateBegin  s DateBegin=DateBegin-1
	.s AuditDate=+DateBegin
	.f  s AuditDate=$O(^DHCPEGS(0,"AuditDateTime",AuditDate)) q:((""'=DateEnd)&(AuditDate>+DateEnd)||(""=AuditDate))  d
	..s AuditTime=0
	..f  s AuditTime=$O(^DHCPEGS(0,"AuditDateTime",AuditDate,AuditTime)) q:(""=AuditTime)  d
	...s GSRowId=0	
	...f  s GSRowId=$O(^DHCPEGS(0,"AuditDateTime",AuditDate,AuditTime,GSRowId)) q:(""=GSRowId)  d
    ....s GSIADMDR=$p($G(^DHCPEGS(GSRowId,1)),"^",1)
    ....s LocFlag=##class(web.DHCPE.PreCommon).GetLocFlag("PEADM",GSIADMDR)          //add 2009-07-07 
  	....q:LocFlag=1
  	....s Vip=##class(web.DHCPE.PreCommon).GetVIPLevel("IADM",GSIADMDR)
  	....s VipID=$p($g(Vip),"^",1)
  	....q:(VIPLevel'="")&(VIPLevel'=VipID)
  	....s GADM=$P($g(^DHCPEIADM(GSIADMDR)),"^",2)
 	....q:((GroupDR'="")&&(GroupDR'=GADM))
    ....s GSAuditUserDR=$p($G(^DHCPEGS(GSRowId,1)),"^",5)
    ....Q:GSAuditUserDR=""
    ....s ^DHCPETMP(J,"GDoctor", GSAuditUserDR)=+$G(^DHCPETMP(J,"GDoctor", GSAuditUserDR))+1
    }
    ELSE{
	 
    i ((""'=DateBegin)||(""'=DateEnd)) d
 	.i 0'=+DateBegin  s DateBegin=DateBegin-1
	.s AuditDate=+DateBegin
	.f  s AuditDate=$o(^DHCPEDataEx("DHCPEGeneralSummarize","MainDate",AuditDate))  q:(AuditDate="")||(AuditDate>DateEnd)   d
	..s AuditTime=0
    ..f  s AuditTime=$o(^DHCPEDataEx("DHCPEGeneralSummarize","MainDate",AuditDate,AuditTime))  q:AuditTime=""   d 
    ...s PAADM=0
    ...f  s PAADM=$o(^DHCPEDataEx("DHCPEGeneralSummarize","MainDate",AuditDate,AuditTime,PAADM)) q:PAADM=""  d
    ....q:'$d(^DHCPEDataEx("DHCPEGeneralSummarize","MainDoctor",PAADM))
    ....s LocFlag=##class(web.DHCPE.PreCommon).GetLocFlag("PAADM",PAADM)          //add 2009-07-07 
  	....q:LocFlag=1
    ....s Vip=##class(web.DHCPE.PreCommon).GetVIPLevel("PAADM",PAADM)
    ....s VipID=$p($g(Vip),"^",1)
  	....q:(VIPLevel'="")&(VIPLevel'=VipID)
  	....s GSIADMDR=$o(^DHCPEIADM(0,"PAADM",PAADM,0))
  	....s GADM=$P($g(^DHCPEIADM(GSIADMDR)),"^",2)
 	....q:((GroupDR'="")&&(GroupDR'=GADM))
    ....s MainUserDR=$G(^DHCPEDataEx("DHCPEGeneralSummarize","MainDate",AuditDate,AuditTime,PAADM))
    ....Q:MainUserDR=""
    ....s ^DHCPETMP(J,"GDoctor", MainUserDR)=+$G(^DHCPETMP(J,"GDoctor", MainUserDR))+1
    }
     
   	s USERRowId=0,Amount=0,MAmount=0,Total=0
	f  s USERRowId=$O(^DHCPETMP(J,"GDoctor", USERRowId)) q:USERRowId=""  d
    .s DocName=$P($G(^SSU("SSUSR",USERRowId)),"^",2)
    .s DocNo=$P($G(^SSU("SSUSR",USERRowId)),"^",1)
    .s:(""=DocName) DocName="("_USERRowId_")"
	.s Amount=+$G(^DHCPETMP(J,"GDoctor", USERRowId))
	.s Total=Total+Amount
    .d GDoctorWorkStatisticOut
    s (DocName,Amount,DocNo,USERRowId,DocType)=""
    s Amount=Total
    s DocName="合计："
    ;d GDoctorWorkStatisticOut
    K ^DHCPETMP(J)
    w "<font color=blue size=1 >合计: "_ Amount _"人</font>"
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
GDoctorWorkStatisticOut
	set Data=$lb(DocName,Amount,DocNo,USERRowId,DocType)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod GDoctorWorkStatisticFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GDoctorWorkStatisticExecute ]
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

ClassMethod GDoctorWorkStatisticClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GDoctorWorkStatisticExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

}
