Class web.DHCPE.Report.NoResultItems Extends %Persistent
{

Query NoResultItems(DateFrom As %String = "", DateTo As %String = "", ArrivedFlag As %String = "", RecLocID As %String = "", CurLocID As %String = "") As %Query(ROWSPEC = "Name:%String,RegNo:%String,Date:%String,ARCIMDesc:%String,TReceivedDate:%String")
{
}

/// d ##class(%ResultSet).RunQuery("web.DHCPE.Report.NoResultItems","NoResultItems","2023-02-17","2023-02-17","on","","105")
ClassMethod NoResultItemsExecute(ByRef qHandle As %Binary, DateFrom As %String = "", DateTo As %String = "", ArrivedFlag As %String = "", RecLocID As %String = "", CurLocID As %String = "") As %Status
{
    
	k ^DHCPETMPNRData("RowData") 
	Set repid=$I(^CacheTemp)
	Set ind=1
	i ArrivedFlag="" s ArrivedFlag="N"
	else  s ArrivedFlag="Y"
	s Job=$J 
	k ^TempDHCPE("NoResult",Job)

	s OtherStation=$G(^DHCPESetting("DHCPE","StationId_Other",CurLocID))
	s LabStation=$G(^DHCPESetting("DHCPE","StationId_Lab",CurLocID))
	S MedicalStation=$G(^DHCPESetting("DHCPE","StationId_Medical",CurLocID))
	s RisStation=$g(^DHCPESetting("DHCPE","StationId_Ris",CurLocID))
	s RisStation="^"_RisStation_"^"

	i DateFrom'=""  s DateFrom=##class(websys.Conversions).DateHtmlToLogical(DateFrom)
    i DateTo'=""  s DateTo=##class(websys.Conversions).DateHtmlToLogical(DateTo)
     
     i DateFrom=""  s DateFrom=+$h
     i DateTo=""  s DateTo=+$h
     s AdmDate=DateFrom-1
     i ArrivedFlag="Y" d
     .f  s AdmDate=$o(^DHCPEIADM(0,"AdmDateTime",AdmDate))  q:(AdmDate="")||(AdmDate>DateTo)  d
	 ..s Date=$ZD(AdmDate,3)
	 ..s AdmTime=0
     ..f  s AdmTime=$o(^DHCPEIADM(0,"AdmDateTime",AdmDate,AdmTime))  q:AdmTime=""  d
     ...s IADMRowID=0
     ...f  s IADMRowID=$o(^DHCPEIADM(0,"AdmDateTime",AdmDate,AdmTime,IADMRowID)) q:IADMRowID=""  d
     ....d GetOneInfo
     e  d
     .f  s AdmDate=$o(^DHCPEDataEx("ConfirmRecPaper","DateTime",AdmDate)) q:(AdmDate="")||(AdmDate>DateTo)  d
	 ..s Time=0
	 ..f  s Time=$O(^DHCPEDataEx("ConfirmRecPaper","DateTime",AdmDate,Time)) q:Time=""  d
	 ...s PIADM=""
	 ...f  s PIADM=$o(^DHCPEDataEx("ConfirmRecPaper","DateTime",AdmDate,Time,PIADM)) q:PIADM=""  d
	 ....s RecievedDate=$zd($p(^DHCPEDataEx("ConfirmRecPaper",PIADM),"^",1),3) 
	 ....s IADMRowID=$O(^DHCPEIADM(0,"CRMADM",PIADM,0))
	 ....q:IADMRowID=""
	 ....d GetOneInfo
     s Loc=""
	 f  s Loc=$O(^TempDHCPE("NoResult",Job,Loc)) q:Loc=""  d
	 .d Clear
	 .s Name=Loc
	 .d OutPut
	 .s Desc=""
	 .f  s Desc=$O(^TempDHCPE("NoResult",Job,Loc,Desc)) q:Desc=""  d
	 ..s Sort=0
	 ..f  s Sort=$O(^TempDHCPE("NoResult",Job,Loc,Desc,Sort)) q:Sort=""  d	 
	 ...d Clear
	 ...s Info=$G(^TempDHCPE("NoResult",Job,Loc,Desc,Sort))
	 ...s Name=$P(Info,"^",1)
	 ...s RegNo=$P(Info,"^",2)
	 ...s Date=$P(Info,"^",3)
	 ...s:Date'="" Date=##class(websys.Conversions).DateLogicalToHtml(Date)
	 ...S RecievedDate=Date
	 ...s ARCIMDesc=$P(Info,"^",4)
	 ...d OutPut
	 k ^TempDHCPE("NoResult",Job)
	s Date=##class(websys.Conversions).DateLogicalToHtml(+$h)
	s Time=##class(websys.Conversions).TimeLogicalToHtml($p($h,",",2))
	s str=Date_" "_Time 
	s BeginDate=##class(websys.Conversions).DateLogicalToHtml(+DateFrom)
	s EndDate=##class(websys.Conversions).DateLogicalToHtml(+DateTo)
	Set qHandle=$lb(0,repid,0)
	set ^DHCPETMPNRData("RowData")=BeginDate_"-"_EndDate_"^"_str
	Quit $$$OK
	
GetOneInfo
	 s LocFlag=##class(web.DHCPE.PreCommon).GetLocFlag("PEADM",IADMRowID)         //Add by 090702
     q:LocFlag=1  
     s Status=$P($g(^DHCPEIADM(IADMRowID)),"^",8)
	 Q:"ARRIVED"'=Status
	 s PreIADM=$P($g(^DHCPEIADM(IADMRowID)),"^",4)
	 q:PreIADM="" 
	 s OrderSets=$G(^DHCPEDataEx("DHCPEPreIADM","PreOrdSet",PreIADM)) 
	 s OrderSets=$p(OrderSets,"^",2) 
	 s PIADMVip=$p($g(^DHCPEPreIADM(PreIADM)),"^",18)
	 s PIADMVip="^"_PIADMVip_"^"
     s PAADM=$P($g(^DHCPEIADM(IADMRowID)),"^",1)
     Q:PAADM=""
     q:(##class(web.DHCPE.ResultPermission).GetGeneAdviserStatus(PAADM)="Audited")
     d ##class(web.DHCPE.TransResult).TransMain(PAADM)
     s PapmiDr=$p($G(^PAADM(PAADM)),"^",1)
     s RegNo="",Name="",SexDesc="",Age=""
     s RegNo=$p($g(^PAPER(PapmiDr,"PAT",1)),"^",2)
     s Name=$p($g(^PAPER(PapmiDr,"ALL")),"^",1)
 	 s sexdr=$p($g(^PAPER(PapmiDr,"ALL")),"^",7)
 	 if (""'=sexdr)  do
 	 .s SexDesc=$p($g(^CT("SEX",sexdr)),"^",2) 
 	 s dob=$p($g(^PAPER(PapmiDr,"ALL")),"^",6)              
 	 s:(""'=dob) Age=##class(web.DHCLCNUREXCUTE).CalAge(dob,+$h)
 	 s Age=$P(Age,"Y")
     s OEORDRowId=0 
     s OEORDRowId=$O(^OEORD(0,"Adm",PAADM,OEORDRowId))  
     Q:""=OEORDRowId
     s OEORIChildsub=0
     f  s OEORIChildsub=$O(^OEORD(OEORDRowId,"I",OEORIChildsub)) Q:(""=OEORIChildsub)  d
     .s OEORIRowId=OEORDRowId_"||"_OEORIChildsub  //oe_order表 ID
     .s BilledStatus=$p($g(^OEORD(OEORDRowId,"I",OEORIChildsub,3)),"^",5)  //oe_orditem 付费状态
     .Q:"P"'=BilledStatus
     .Q:$d(^DHCPEDataEx("DHCPEPreIOrdItem","RefuseCheck",OEORIRowId))        //过滤谢绝检查项目                                   //add by rxb 20121114
     .Q:$d(^DHCPEDataEx("DHCPEPreIOrdItem","RegNoDo",OEORIRowId))        //过滤登记未做检查项目                                   //add by rxb 20121114
     .s OEORIItemStatDR=$p($G(^OEORD(OEORDRowId,"I",OEORIChildsub,1)),"^",13)  //检验医嘱状态
     .s OEORIItmMastDR=$p($G(^OEORD(OEORDRowId,"I",OEORIChildsub,1)),"^",2)  
	 .q:OEORIItmMastDR=""
	 .;s Station=$O(^DHCPEST(0,"STORD_ARCIM",OEORIItmMastDR,0))
	 .;q:Station=""
	  .// 根据医嘱项ID查找对应OrderDR（站点和项目组合ID）
	 .s StatOrderID=##class(web.DHCPE.CT.HISUICommon).GetStatOrderIDByARCIM(OEORIItmMastDR,CurLocID)
	 .s Station=$p(StatOrderID,"||",1)
	 .q:Station=""
	 .s Childsub=$p(StatOrderID,"||",2)
	 .q:(""=Childsub)
	 .q:OtherStation=Station
	 .q:MedicalStation=Station
	 .q:(4=OEORIItemStatDR)		// 是否有效医嘱
     .q:(LabStation'=Station)&&(RisStation'[("^"_Station_"^"))
     .q:(6'=OEORIItemStatDR)
	 .;s Sub=$O(^DHCPEST(0,"STORD_ARCIM",OEORIItmMastDR,Station,0))
	 .;s AutoFlag=$P(^DHCPEST(Station,"O",Sub),"^",6)
	 .s SOSID=$O(^CF.PE.StationOrderSetI("IdxOfLocOrder"," "_CurLocID,Station_"||"_Childsub,0))
	 .q:SOSID=""
	 .s AutoFlag=$lg($g(^CF.PE.StationOrderSetD(SOSID)),7)
	 .q:AutoFlag="N"
	 .s ARCIMDesc=$p($g(^ARCIM($p(OEORIItmMastDR,"||",1),$p(OEORIItmMastDR,"||",2),1)),"^",2)
	 .s vRecLocID=$p($G(^OEORD(OEORDRowId,"I",OEORIChildsub,3)),"^",6)
	 .q:(RecLocID'="")&&(RecLocID'=vRecLocID)
	 .s RecLoc=""
	 .i vRecLocID'="" d
	 ..s RecLoc=$p($g(^CTLOC(vRecLocID)),"^",2)
	 .e  d
	 ..s RecLoc="无接受科室"
	 .q:$O(^DHCPERLT(0,"OEORI",OEORIRowId,0))'=""
	 .s Sort=$i(^TempDHCPE("NoResult",Job,RecLoc,ARCIMDesc))
	 .s ^TempDHCPE("NoResult",Job,RecLoc,ARCIMDesc,Sort)=Name_"^"_RegNo_"^"_AdmDate_"^"_ARCIMDesc
	 q 
Clear
	s (Name,RegNo,Date,ARCIMDesc,RecievedDate)=""
	q 
OutPut
    /***翻译 start***/
    s ARCIMDesc=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("User.ARCItmMast",ARCIMDesc,"ARCIMDesc","cls")
    /***翻译   end***/
	set Data=$lb(Name,RegNo,Date,ARCIMDesc,RecievedDate)
	set ^DHCPETMPNRData("RowData",ind)=Name_"^"_RegNo_"^"_Date_"^"_ARCIMDesc
	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod NoResultItemsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = NoResultItemsExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else{			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod NoResultItemsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = NoResultItemsExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetQueryTime()
{
	q $p($g(^DHCPETMPNRData("RowData")),"^",2)
}

ClassMethod GetDateFromTo()
{
 
	q $p($g(^DHCPETMPNRData("RowData")),"^",1)
}

ClassMethod GetRowData(rownum)
{
	s DataStr=$g(^DHCPETMPNRData("RowData",rownum))
	q DataStr
}

ClassMethod GetRowLength()
{
	s ind=""
	s ind=$o(^DHCPETMPNRData("RowData",ind),-1)
	q ind
}

Storage Default
{
<Data name="NoResultItemsDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCPE.ReD50C.NoResultItemsD</DataLocation>
<DefaultData>NoResultItemsDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^web.DHCPE.ReD50C.NoResultItemsD</IdLocation>
<IndexLocation>^web.DHCPE.ReD50C.NoResultItemsI</IndexLocation>
<StreamLocation>^web.DHCPE.ReD50C.NoResultItemsS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
