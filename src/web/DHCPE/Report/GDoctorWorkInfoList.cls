/// zhouli
///  在总检医生工作量统计中，点工作量次数，连接到总检明细列表中
/// 组件：DHCPEGDoctorInfoList
Class web.DHCPE.Report.GDoctorWorkInfoList Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 127;

// d ##class(%ResultSet).RunQuery("web.DHCPE.Report.GDoctorWorkInfoList","InfoList","60812", "61103","2873")

Query InfoList(DateBegin As %Library.String = "", DateEnd As %Library.String = "", DocID As %Library.String = "", DocType As %Library.String = "", VIPLevel As %Library.String = "", GroupDR As %Library.String = "") As %Query(ROWSPEC = "TRegNo:%String,TPatName:%String,TAuditDate:%String,TGoupName:%String,TGADMID:%String,DocType:%String,TCheckDate:%String")
{
}

ClassMethod InfoListExecute(ByRef qHandle As %Binary, DateBegin As %Library.String = "", DateEnd As %Library.String = "", DocID As %Library.String = "", DocType As %Library.String = "", VIPLevel As %Library.String = "", GroupDR As %Library.String = "") As %Status
{
  
	Set repid=$I(^CacheTemp)
	s ind=1	
	S J=$j 
	i DateBegin'="" s DateBegin=##class(websys.Conversions).DateHtmlToLogical(DateBegin)
	i DateEnd'=""   s DateEnd=##class(websys.Conversions).DateHtmlToLogical(DateEnd)
	if DocType="G"{
     i ((""'=DateBegin)||(""'=DateEnd)) d
 	.i 0'=+DateBegin  s DateBegin=DateBegin-1
	.s AuditDate=+DateBegin
	.f  s AuditDate=$O(^DHCPEGS(0,"AuditDateTime",AuditDate))  q:((""'=DateEnd)&(AuditDate>+DateEnd)||(""=AuditDate))  d
	..s AuditTime=0
	..f  s AuditTime=$O(^DHCPEGS(0,"AuditDateTime",AuditDate,AuditTime)) q:(""=AuditTime)  d
	...s GSRowId=0	
	...f  s GSRowId=$O(^DHCPEGS(0,"AuditDateTime",AuditDate,AuditTime,GSRowId)) q:(""=GSRowId)  d
	....;b
    ....s GSAuditUserDR=$p($G(^DHCPEGS(GSRowId,1)),"^",5)
    ....s GSIADMDR=$p($G(^DHCPEGS(GSRowId,1)),"^",1)
    ....
    ....Q:GSAuditUserDR=""
    ....Q:(GSAuditUserDR'=DocID)&&(DocID'="")
    ....s AuditDate=$p($g(^DHCPEGS(GSRowId,1)),"^",6)
    ....Q:AuditDate=""
    ....
    ....i AuditDate'="" s AuditDateN=##class(websys.Conversions).DateLogicalToHtml(AuditDate)
    
    ....s Vip=##class(web.DHCPE.PreCommon).GetVIPLevel("IADM",GSIADMDR)
  	....s VipID=$p($g(Vip),"^",1)
  	....q:(VIPLevel'="")&(VIPLevel'=VipID)

    ....s PreIADM=$p($g(^DHCPEIADM(GSIADMDR)),"^",4)
    ....s GADM=$P($g(^DHCPEIADM(GSIADMDR)),"^",2)
 	....q:((GroupDR'="")&&(GroupDR'=GADM))
    ....s PIBIDR=$P($G(^DHCPEPreIADM(PreIADM)),"^",1)
    ....s PAPMINo=$p($g(^DHCPEPreIBI(PIBIDR)),"^",1)
    ....s Name=$p($g(^DHCPEPreIBI(PIBIDR)),"^",2)
    ....S GADMDR=""
    ....s GoupName=""
    ....s GBaseInfoID=""
    ....s CheckDate=""
    ....s CheckDate=$p($g(^DHCPEIADM(GSIADMDR)),"^",5)
    ....s:CheckDate'="" CheckDate=##class(websys.Conversions).DateLogicalToHtml(CheckDate)
    ....s GADMDR=$p($g(^DHCPEIADM(GSIADMDR)),"^",2)
    ....i GADMDR'=""  s GBaseInfoID=$P($G(^DHCPEGADM(GADMDR)),"^",1)
    ....i GBaseInfoID'=""  s GoupName=$P($G(^DHCPEGBI(GBaseInfoID)),"^",2)
    ....d GDoctorWorkStatisticOut
    }
   ELSE{
	 S PAADM=0
     f  s PAADM=$o(^DHCPEDataEx("DHCPEGeneralSummarize","MainDoctor",PAADM))  q:PAADM=""  d
     .s MainStr=$g(^DHCPEDataEx("DHCPEGeneralSummarize","MainDoctor",PAADM))
     .s MainDate=$p(MainStr,"^",2)
     .q:MainDate=""
     .q:(DateBegin'="")&&(MainDate<DateBegin)
     .q:(DateEnd'="")&&(MainDate>DateEnd)
     .s MainUserDR=$p(MainStr,"^",1)
     .Q:MainUserDR=""
     .Q:(MainUserDR'=DocID)&&(DocID'="")
     .i MainDate'="" s AuditDateN=##class(websys.Conversions).DateLogicalToHtml(MainDate)
     .S IADMDR=$o(^DHCPEIADM(0,"PAADM",PAADM,0))
     .q:IADMDR=""
     .s Vip=##class(web.DHCPE.PreCommon).GetVIPLevel("IADM",IADMDR)
  	 .s VipID=$p($g(Vip),"^",1)
  	 .q:(VIPLevel'="")&(VIPLevel'=VipID)

     .s CheckDate=""
     .s CheckDate=$p($g(^DHCPEIADM(IADMDR)),"^",5)
     .s:CheckDate'="" CheckDate=##class(websys.Conversions).DateLogicalToHtml(CheckDate)
     .s PreIADM=$p($g(^DHCPEIADM(IADMDR)),"^",4)
     .s GADM=$P($g(^DHCPEIADM(IADMDR)),"^",2)
 	 .q:((GroupDR'="")&&(GroupDR'=GADM))
     .s PIBIDR=$P($G(^DHCPEPreIADM(PreIADM)),"^",1)
     .s PAPMINo=$p($g(^DHCPEPreIBI(PIBIDR)),"^",1)
     .s Name=$p($g(^DHCPEPreIBI(PIBIDR)),"^",2)
     .S GADMDR=""
     .s GoupName=""
     .s GBaseInfoID=""
     .s GADMDR=$p($g(^DHCPEIADM(IADMDR)),"^",2)
     .i GADMDR'=""  s GBaseInfoID=$P($G(^DHCPEGADM(GADMDR)),"^",1)
     .i GBaseInfoID'=""  s GoupName=$P($G(^DHCPEGBI(GBaseInfoID)),"^",2)
     .d GDoctorWorkStatisticOut
     }
     
     i DocType="G" S DocType="初审"
     i DocType="M" S DocType="复审"
     w "<font color = blue size=4 >已"_DocType_"人员信息</font>"

	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
GDoctorWorkStatisticOut
	;w CheckDate
	set Data=$lb(PAPMINo,Name,AuditDateN,GoupName,GADMDR,DocType,CheckDate)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod InfoListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = InfoListExecute ]
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

ClassMethod InfoListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = InfoListExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

}
