/// creat by zhouli
/// 检验清单
/// 用于查询在一段时间内开某条已打印条码的医嘱的人员信息
Class web.DHCPE.BarPrintFind Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// 通过输入的参数查询所要信息
Query QueryBarInfo(DateFrom As %String = "", DateTo As %String = "", TimeFrom As %String = "", TimeTo As %String = "", ARCIMDescID As %String = "", GroupID As %String = "", PrintFlag As %String = "") As %Query(ROWSPEC = "LabID:%String,RegNo:%String,PatName:%String,Sex:%String,Age:%String,ARCIMDesc:%String,ResultStatus:%String,TSpecAudit:%String")
{
}

// d ##class(%ResultSet).RunQuery("web.DHCPE.BarPrintFind","QueryBarInfo")

ClassMethod QueryBarInfoExecute(ByRef qHandle As %Binary, DateFrom As %String = "", DateTo As %String = "", TimeFrom As %String = "", TimeTo As %String = "", ARCIMDescID As %String = "", GroupID As %String = "", PrintFlag As %String = "") As %Status
{
    // q:ARCIMDescID="" "请输入医嘱名称!"
	Set repid=$I(^CacheTemp)
	i PrintFlag="" s PrintFlag="N"
	else  s PrintFlag="Y"
	s curUser=%session.Get("LOGON.USERID")
	s AuditFlag="未审核"
	
		//s curUser=1
	k ^DHCPETMPLabData(curUser)

 	s ind=100
    s HosCode=$G(^DHCPESetting("DHCPE","HospitalCode"))
    i DateTo=""  s DateTo=+$h
    i HosCode="FX"  {
 	s Date=DateFrom-1                                                                  //可以从当天开始查询
 	f  s Date=$o(^DHCPETempLabEpisodeNo("Date",Date))  q:(Date="")||(Date>DateTo)  d   //当日期不符合条件退出
    .s Time=0
 	.f  s Time=$o(^DHCPETempLabEpisodeNo("Date",Date,Time))  q:(Time="")  d
 	..q:(TimeFrom'="")&&((Date=DateFrom)&&(Time<TimeFrom))                       
    ..q:(TimeTo'="")&&((Date=DateTo)&&(Time>TimeTo))
 	..s LabNo=0
 	..f  s LabNo=$o(^DHCPETempLabEpisodeNo("Date",Date,Time,LabNo))  q:LabNo=""  d    //通过遍历^DHCPETempLabEpisodeNo获取标本号   
 	
 	...s oeordRowid=0
 	...f  s oeordRowid=$o(^OEORD(0,"EpisNo",LabNo,oeordRowid))  q:oeordRowid=""  d      //oe_order表
    ....s AdmDr=""
 	....s AdmDr=$p(^OEORD(oeordRowid),"^",1)        //PA_Adm表ID
    ....q:$g(AdmDr)=""
    ....s IADM=0
    ....f  s IADM=$o(^DHCPEIADM(0,"PAADM",AdmDr,IADM))  q:IADM=""  d
    .....s gid=$p($g(^DHCPEIADM(IADM)),"^",2)
    .....q:((GroupID'="")&&(gid'=GroupID))
    .....s PapmiDr="" 
 	.....s PapmiDr=$p(^PAADM(AdmDr),"^",1)                // PA_PatMas表    
 	.....q:$g(PapmiDr)=""      
 	.....s name=""
 	.....s sexdr=""
 	.....s dob=""
 	.....S RegNo=""
 	.....s RegNo=$p(^PAPER(PapmiDr,"PAT",1),"^",2)
 	.....s name=$p(^PAPER(PapmiDr,"ALL"),"^",1)
 	.....s sexdr=$p(^PAPER(PapmiDr,"ALL"),"^",7)
 	.....if (""'=sexdr)  do
 	......s CTSEXdesc=$p(^CT("SEX",sexdr),"^",2) 
 	.....Else             do
 	......s CTSEXdesc=""
 	.....s dob=$p(^PAPER(PapmiDr,"ALL"),"^",6)              //出生年月   
 	.....s Age=""
 	.....s:(""'=dob) Age=##class(web.DHCLCNUREXCUTE).CalAge(dob,+$h)
 	.....s Age=$P(Age,"Y")                                 //年龄
 	.....s age=0
 	.....s oeoriRowid=0
 	.....f  s oeoriRowid=$o(^OEORD(0,"EpisNo",LabNo,oeordRowid,oeoriRowid))  q:oeoriRowid=""  d //oe_orditem 表
 	......s ItmmaststatDR=""
 	......s ItmmaststatDR=$p(^OEORD(oeordRowid,"I",oeoriRowid,1),"^",13) 
    ......q:ItmmaststatDR'=1                    //当不是核实状态退出
 	......s ItmmastDr=""
 	......s ItmmastDr=$p(^OEORD(oeordRowid,"I",oeoriRowid,1),"^",2 ) 
    ......q:$g(ItmmastDr)="" 
    ......q:ARCIMDescID'=ItmmastDr 
 	......s arcimsub=""
 	......s arcimver=""
 	......s arcimdesc=""
 	......s arcimsub=$p(ItmmastDr,"||",1),arcimver=$p(ItmmastDr,"||",2)
 	......s arcimdesc=$p(^ARCIM(arcimsub,arcimver,1),"^",2)
 	......//s ^DHCPEBarPrint("Data",RegNo,LabNo)=
 	......d Find
    }
    elseif (HosCode="WHYY")||(HosCode="SZBA")
    { 
   
     i DateFrom=""  s DateFrom=+$h
     i DateTo=""  s DateTo=+$h
     s AdmDate=DateFrom-1
     f  s AdmDate=$o(^DHCPEIADM(0,"AdmDateTime",AdmDate))  q:(AdmDate="")||(AdmDate>DateTo)  d
	 .s AdmTime=0
     .f  s AdmTime=$o(^DHCPEIADM(0,"AdmDateTime",AdmDate,AdmTime))  q:AdmTime=""  d
     ..q:(TimeFrom'="")&&((AdmDate=DateFrom)&&(AdmTime<TimeFrom))                       
     ..q:(TimeTo'="")&&((AdmDate=DateTo)&&(AdmTime>TimeTo))
     ..s IADMRowID=0
     ..f  s IADMRowID=$o(^DHCPEIADM(0,"AdmDateTime",AdmDate,AdmTime,IADMRowID)) q:IADMRowID=""  d
     ...s Status=$P($g(^DHCPEIADM(IADMRowID)),"^",8)
	 ...Q:"ARRIVED"'=Status
     ...s LocFlag=##class(web.DHCPE.PreCommon).GetLocFlag("PEADM",IADMRowID)         //Add by 090702
     ...q:LocFlag=1  
     ...s PAADM=$P(^DHCPEIADM(IADMRowID),"^",1)
     ...Q:PAADM=""
     ...s GADMDR=$p($g(^DHCPEIADM(IADMRowID)),"^",2)
     ...q:((GroupID'="")&&(GADMDR'=GroupID))
     ...s PapmiDr=$p($G(^PAADM(PAADM)),"^",1)
     ...s RegNo="",Name="",SexDesc="",Age=""
     ...s RegNo=$p(^PAPER(PapmiDr,"PAT",1),"^",2)
     
 	 ...s Name=$p(^PAPER(PapmiDr,"ALL"),"^",1)
 	 ...s sexdr=$p(^PAPER(PapmiDr,"ALL"),"^",7)
 	 ...if (""'=sexdr)  do
 	 ....s SexDesc=$p(^CT("SEX",sexdr),"^",2) 
 	 ...s dob=$p(^PAPER(PapmiDr,"ALL"),"^",6)              //出生年月   
 	 ...s:(""'=dob) Age=##class(web.DHCLCNUREXCUTE).CalAge(dob,+$h)
 	 ...s Age=$P(Age,"Y")                                 //年龄
     ...s OEORDRowId=0 
     ...s OEORDRowId=$O(^OEORD(0,"Adm",PAADM,OEORDRowId))  //oe_order表
     ...Q:""=OEORDRowId
     ...s OEORIChildsub=0
     ...f  s OEORIChildsub=$O(^OEORD(OEORDRowId,"I",OEORIChildsub)) Q:(""=OEORIChildsub)  d
     ....s OEORIRowId=OEORDRowId_"||"_OEORIChildsub  //oe_order表 ID
     ....//w !,OEORIRowId
     ....s OEORIItemStatDR=$p($G(^OEORD(OEORDRowId,"I",OEORIChildsub,1)),"^",13)  //检验医嘱状态
     ....Q:4=OEORIItemStatDR		// 是否有效医嘱
     ....//w !,OEORIRowId_"^"_OEORIItemStatDR_"^"_$G(^OEORD(OEORDRowId,"I",OEORIChildsub,1))
     ....s OEORIItmMastDR=$p($G(^OEORD(OEORDRowId,"I",OEORIChildsub,1)),"^",2)  
	 ....q:OEORIItmMastDR=""
	 ....;q:OEORIItmMastDR="1622||1"   //呼气试验不打印
	 ....q:(ARCIMDescID'="")&&(ARCIMDescID'=OEORIItmMastDR)
	 ....s OEORILabEpisodeNo=$p($G(^OEORD(OEORDRowId,"I",OEORIChildsub,3)),"^",20)
	 ....q:OEORILabEpisodeNo=""
	 ....s ARCOS=$p($G(^OEORD(OEORDRowId,"I",OEORIChildsub,3)),"^",10)
	 ....s ARCIMDesc=$p(^ARCIM($p(OEORIItmMastDR,"||",1),$p(OEORIItmMastDR,"||",2),1),"^",2)
	 ....Q:'$d(^DHCPETempLabEpisodeNo("PrintSendLabNo",OEORIRowId))&&(PrintFlag="Y")
	 ....Q:$d(^DHCPETempLabEpisodeNo("PrintSendLabNo",OEORIRowId))&&(PrintFlag="N")
	 ....s SpecimenType=##class(web.DHCPE.BarPrint).GetSpecName(OEORIRowId)
	 
	 ....q:(SpecimenType'[("血"))
	 ....s ResultStatus=##class(web.DHCPE.OEOrdItem).GetResultStatus(OEORILabEpisodeNo,OEORIItmMastDR,ARCOS,OEORIRowId)
	 ....s ^DHCPETMPLabData(curUser,"TotalLabByDate",AdmDate,PAADM,OEORILabEpisodeNo,OEORIRowId)=RegNo_"^"_Name_"^"_SexDesc_"^"_Age
	 ....s ^DHCPETMPLabData(curUser,"TotalLab",OEORIRowId)=OEORILabEpisodeNo
	 ....s RecLocID=$p($G(^OEORD(OEORDRowId,"I",OEORIChildsub,3)),"^",6)
	 ....s RecLoc=""
	 ....i RecLocID'="" d
	 .....s RecLoc=$p(^CTLOC(RecLocID),"^",2)
	 .....s RecLoc=$p(RecLoc,"-",2)
	 .....s ^DHCPETMPLabData(curUser,"SpecimenListByEpisodeNo",OEORILabEpisodeNo,RecLoc)=1
  
     s EpisodeNo=0
     f   s EpisodeNo=$o(^DHCPETMPLabData(curUser,"SpecimenListByEpisodeNo",EpisodeNo))  q:EpisodeNo=""  d
     .s Specimen=0
     .f  s Specimen=$o(^DHCPETMPLabData(curUser,"SpecimenListByEpisodeNo",EpisodeNo,Specimen))  q:Specimen=""  d
     ..i $d(^DHCPETempLabEpisodeScan(EpisodeNo)) s ^DHCPETMPLabData(curUser,"SpecimenList",Specimen,"TotalSpecimenAudited")=+$G(^DHCPETMPLabData(curUser,"SpecimenList",Specimen,"TotalSpecimenAudited"))+1
	 ..else  s ^DHCPETMPLabData(curUser,"SpecimenList",Specimen,"TotalSpecimenUnAudit")=+$G(^DHCPETMPLabData(curUser,"SpecimenList",Specimen,"TotalSpecimenUnAudit"))+1
	 ..s ^DHCPETMPLabData(curUser,"SpecimenList",Specimen,"TotalSpecimen")=+$G(^DHCPETMPLabData(curUser,"SpecimenList",Specimen,"TotalSpecimen"))+1
	 s ind=1
	 s SpecimenDesc=0
	 f  s SpecimenDesc=$o(^DHCPETMPLabData(curUser,"SpecimenList",SpecimenDesc))  q:SpecimenDesc=""  d
	 .s AuditTotal="已审核："_+$G(^DHCPETMPLabData(curUser,"SpecimenList",SpecimenDesc,"TotalSpecimenAudited"))_"份"
	 .s UnAuditTotal="未审核："_+$G(^DHCPETMPLabData(curUser,"SpecimenList",SpecimenDesc,"TotalSpecimenUnAudit"))_"份"
	 .s Total="共："_+$G(^DHCPETMPLabData(curUser,"SpecimenList",SpecimenDesc,"TotalSpecimen"))_"份"
	 .s OEORILabEpisodeNo=""
	 .s AuditTotal=AuditTotal_"   , "_UnAuditTotal
	 .s RegNo=SpecimenDesc,Name=Total,SexDesc="",Age="",ARCIMDesc=AuditTotal,ResultStatus="",AuditFlag=""
	 .d OutPut
	 s ind=200
	 s AdmDate=0
	 f  s AdmDate=$o(^DHCPETMPLabData(curUser,"TotalLabByDate",AdmDate))  q:AdmDate=""  d
	 .s PAADM=0
	 .f  s PAADM=$o(^DHCPETMPLabData(curUser,"TotalLabByDate",AdmDate,PAADM)) q:PAADM=""  d
	 ..s OEORILabEpisodeNo=0
	 ..f  s OEORILabEpisodeNo=$o(^DHCPETMPLabData(curUser,"TotalLabByDate",AdmDate,PAADM,OEORILabEpisodeNo))  q:OEORILabEpisodeNo=""  d
	 ...//s ^DHCPETempLabEpisodeScan(SpecNo)=Date_"^"_Time_"^"_%session.Get("LOGON.USERID")
	 ...s AuditFlag="未审核"
	 ...i $d(^DHCPETempLabEpisodeScan(OEORILabEpisodeNo)) s AuditFlag="已审核"
	 ...s OEORIRowId=0,ARCIMDesc="",ResultStatus=""
	 ...f  s OEORIRowId=$o(^DHCPETMPLabData(curUser,"TotalLabByDate",AdmDate,PAADM,OEORILabEpisodeNo,OEORIRowId))  q:OEORIRowId=""  d
	 ....s DataStr=$G(^DHCPETMPLabData(curUser,"TotalLabByDate",AdmDate,PAADM,OEORILabEpisodeNo,OEORIRowId))
	
	 ....s RegNo=$p(DataStr,"^",1)
	 ....s Name=$p(DataStr,"^",2)
	 ....s SexDesc=$p(DataStr,"^",3)
	 ....s Age=$p(DataStr,"^",4)
	 ....s OEORD=$P(OEORIRowId,"||",1),OEORIChildsub=$P(OEORIRowId,"||",2)
	 ....s OEORIItmMastDR=$p($G(^OEORD(OEORD,"I",OEORIChildsub,1)),"^",2) 
	 ....s ARCIMDescOne=$p(^ARCIM($p(OEORIItmMastDR,"||",1),$p(OEORIItmMastDR,"||",2),1),"^",2) 
	 ....s ARCOS=$p($G(^OEORD(OEORIItmMastDR,"I",OEORIItmMastDR,3)),"^",10)
	 ....s ResultStatusOne=##class(web.DHCPE.OEOrdItem).GetResultStatus(OEORILabEpisodeNo,OEORIItmMastDR,ARCOS,OEORIRowId)
	 ....i ARCIMDesc=""  s ARCIMDesc=ARCIMDescOne
	 ....else  s ARCIMDesc=ARCIMDesc_","_ARCIMDescOne
	 ....i ResultStatus=""  s ResultStatus=ResultStatusOne
	 ....else  s ResultStatus=ResultStatus_","_ResultStatusOne
	 ...d OutPut
	    }
    
    else
    {
	 i DateFrom=""  s DateFrom=0
     i DateTo=""  s DateTo=+$h
     s AdmDate=DateFrom-1
     f  s AdmDate=$o(^DHCPEIADM(0,"AdmDateTime",AdmDate))  q:(AdmDate="")||(AdmDate>DateTo)  d
     .s AdmTime=0
     .f  s AdmTime=$o(^DHCPEIADM(0,"AdmDateTime",AdmDate,AdmTime))  q:AdmTime=""  d
     ..q:(TimeFrom'="")&&((AdmDate=DateFrom)&&(AdmTime<TimeFrom))                       
     ..q:(TimeTo'="")&&((AdmDate=DateTo)&&(AdmTime>TimeTo))
     ..s IADMRowID=0
     ..f  s IADMRowID=$o(^DHCPEIADM(0,"AdmDateTime",AdmDate,AdmTime,IADMRowID)) q:IADMRowID=""  d
     ...s LocFlag=##class(web.DHCPE.PreCommon).GetLocFlag("PEADM",IADMRowID)         //Add by 090702
     ...q:LocFlag=1  
     ...s PAADM=$P(^DHCPEIADM(IADMRowID),"^",1)
     ...Q:PAADM=""
     ...s GADMDR=$p($g(^DHCPEIADM(IADMRowID)),"^",2)
     ...q:((GroupID'="")&&(GADMDR'=GroupID))
     ...s PapmiDr=$p($G(^PAADM(PAADM)),"^",1)
     ...s RegNo="",Name="",SexDesc="",Age=""
     ...s RegNo=$p(^PAPER(PapmiDr,"PAT",1),"^",2)
 	 ...s Name=$p(^PAPER(PapmiDr,"ALL"),"^",1)
 	 ...s sexdr=$p(^PAPER(PapmiDr,"ALL"),"^",7)
 	 ...if (""'=sexdr)  do
 	 ....s SexDesc=$p(^CT("SEX",sexdr),"^",2) 
 	 ...s dob=$p(^PAPER(PapmiDr,"ALL"),"^",6)              //出生年月   
 	 ...s:(""'=dob) Age=##class(web.DHCLCNUREXCUTE).CalAge(dob,+$h)
 	 ...s Age=$P(Age,"Y")                                 //年龄
     ...s OEORDRowId=0 
     ...s OEORDRowId=$O(^OEORD(0,"Adm",PAADM,OEORDRowId))  //oe_order表
     ...Q:""=OEORDRowId
     ...s OEORIChildsub=0
     ...f  s OEORIChildsub=$O(^OEORD(OEORDRowId,"I",OEORIChildsub)) Q:(""=OEORIChildsub)  d
     ....s OEORIRowId=OEORDRowId_"||"_OEORIChildsub  //oe_order表 ID
     ....s OEORIItemStatDR=$p($G(^OEORD(OEORDRowId,"I",OEORIChildsub,1)),"^",13)  //检验医嘱状态
     ....Q:4=OEORIItemStatDR		// 是否有效医嘱
     ....s OEORIItmMastDR=$p($G(^OEORD(OEORDRowId,"I",OEORIChildsub,1)),"^",2)  //检验医嘱状态
	 ....q:OEORIItmMastDR=""
	 ....q:(ARCIMDescID'="")&&(ARCIMDescID'=OEORIItmMastDR)
	 ....s OEORILabEpisodeNo=$p($G(^OEORD(OEORDRowId,"I",OEORIChildsub,3)),"^",20)
	 ....q:OEORILabEpisodeNo=""
	 ....s ARCOS=$p($G(^OEORD(OEORDRowId,"I",OEORIChildsub,3)),"^",10)
	 ....s ARCIMDesc=$p(^ARCIM($p(OEORIItmMastDR,"||",1),$p(OEORIItmMastDR,"||",2),1),"^",2)
	 ....Q:'$d(^DHCPETempLabEpisodeNo("PrintSendLabNo",OEORIRowId))&&(PrintFlag="Y")
	 ....Q:$d(^DHCPETempLabEpisodeNo("PrintSendLabNo",OEORIRowId))&&(PrintFlag="N")
	 ....s ResultStatus=##class(web.DHCPE.OEOrdItem).GetResultStatus(OEORILabEpisodeNo,OEORIItmMastDR,ARCOS,OEORIRowId)
	 ....s ^DHCPETMPLabData(curUser,"TotalLab",OEORIRowId)=OEORILabEpisodeNo
	 ....d OutPut
    }
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
Find
 	set Data=$lb(LabNo,RegNo,name,CTSEXdesc,Age,arcimdesc,"")
 	s ^DHCPETMPLabData(curUser,"RowData",ind)=RegNo_"^"_name_"^"_CTSEXdesc_"^"_Age_"^"_arcimdesc_"^"_LabNo_"^"_ind
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
OutPut
	set Data=$lb(OEORILabEpisodeNo,RegNo,Name,SexDesc,Age,ARCIMDesc,ResultStatus,AuditFlag)
	s ^DHCPETMPLabData(curUser,"RowData",ind)=RegNo_"^"_Name_"^"_SexDesc_"^"_Age_"^"_ARCIMDesc_"^"_OEORILabEpisodeNo_"^"_ind
 	s BaseNum="10000000000"
 	i AuditFlag="已审核" s BaseNum="20000000000"
 	Set ^CacheTemp(repid,BaseNum+ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod QueryBarInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryBarInfoExecute ]
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

ClassMethod QueryBarInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryBarInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod getpath()
{
	&sql(select pathtoreports into :path from websys.configuration)
	q path
}

// w ##class(web.DHCPE.BarPrintFind).PrintInfo()

/// 打印信息
/// 传入到JS 
ClassMethod PrintInfo()
{
	s curLoc=%session.Get("LOGON.CTLOCID")
	s curUser=%session.Get("LOGON.USERID")
	s LocDesc=$p(^CTLOC(curLoc),"^",2)	
	s ind=0,DataStr="",Data="",ReturnStr=""
	f  s ind=$o(^DHCPETMPLabData(curUser,"RowData",ind))  q:(ind="")||(ind>="20")  d   //只打印检验清单界面上汇总信息
	.s Data=$G(^DHCPETMPLabData(curUser,"RowData",ind))
	.i DataStr="" s DataStr=Data
	.else  s DataStr=DataStr_"@@"_Data
  	s OEOrdID=0,i=0,LabNoStr=""
  	f  s OEOrdID=$o(^DHCPETMPLabData(curUser,"TotalLab",OEOrdID))  q:OEOrdID=""  d
  	.s LabNo=$G(^DHCPETMPLabData(curUser,"TotalLab",OEOrdID))
  	.i ("^"_LabNoStr_"^")'[("^"_LabNo_"^")   d
  	..s LabNoStr=LabNoStr_"^"_LabNo
  	..s i=i+1
  	..//w !,LabNo_"^"_i
    .s ^DHCPETempLabEpisodeNo("PrintSendLabNo",OEOrdID)="Y"
    //w !,ReturnStr
  	s ReturnStr=LocDesc_"$"_i_"$"_DataStr
 	q ReturnStr
}

/// w ##class(web.DHCPE.BarPrintFind).GetDate("11/12/2007","05/05/2008","","","6725||1")
ClassMethod GetDate(DateFrom As %String = "", DateTo As %String = "", TimeFrom As %String = "", TimeTo As %String = "", ARCIMDescID As %String = "")
{
  	s datafr="",dateto="",DateStart="",DateEnd="",timefr="",timeto="",TimeStart="",TimeEnd="",ARCIMDESC="",arcimsub="",arcimver=""
  	s ordprice=""
    i DateFrom'=""  {s datafr=$zdh(DateFrom,4)}
    i DateTo'=""    {s dateto=$zdh(DateTo,4)}
    i datafr'="" s DateStart=$zd(datafr,3)
    i dateto'="" s DateEnd=$zd(dateto,3)
   
    i ARCIMDescID'="" d
    .s arcimsub=$p(ARCIMDescID,"||",1),arcimver=$p(ARCIMDescID,"||",2)
 	.s ARCIMDESC=$p($g(^ARCIM(arcimsub,arcimver,1)),"^",2) 
 	.s ordprice=##class(web.DHCPE.PreItemList).GetOrderPrice(ARCIMDescID)
	s str=DateStart_"^"_DateEnd_"^"_TimeFrom_"^"_TimeTo_"^"_ARCIMDESC_"^"_ordprice
	q str
}

ClassMethod QueryOrdersExecute(ByRef qHandle As %Binary, ARCIMDesc As %Library.String) As %Status
{
  Set repid=$I(^CacheTemp)
   s:$d(%session) CTLOCID=%session.Get("LOGON.CTLOCID")
  //s ParRef=$G(^DHCPESetting("DHCPE","StationId_Lab")) //直接取检验站点
  s ParRef=$G(^DHCPESetting("DHCPE","StationId_Lab",CTLOCID))
                       //直接取检验站点
  i ""=ParRef {	
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	
	s ARCIMDesc=$g(ARCIMDesc)
	s ARCIMDesc=$ZCVT(ARCIMDesc,"U")                                               //大小写转换
   
	s ind=1
 	s id="0" 	
	f  s id=$O(^DHCPEST(ParRef,"O",id)) q:id=""  d                          
	.s CurData=$g(^DHCPEST(ParRef,"O",id))
    .s iParRef=ParRef
	.s iChildsub=id
	.s iRowId=iParRef_"||"_id                                                       //获取检验站点下医嘱的RowID
	.s iARCIMDR=$p(CurData,"^",1)                                                    // ARC_ItmMast表ID  
	.Q:(""=iARCIMDR)
	.s iARCIMCode=$p(^ARCIM($p(iARCIMDR,"||",1),$p(iARCIMDR,"||",2),1),"^",1)
	.s iARCIMDesc=$p(^ARCIM($p(iARCIMDR,"||",1),$p(iARCIMDR,"||",2),1),"^",2)
    .s AliasId=0
	.s Alias=""
	.f  s AliasId=$o(^ARC("ALIAS",0,"ARCIM",iARCIMDR,AliasId)) q:(AliasId="")  d     //通过检验医嘱ID索引别名ID
	..s EffDate=$p(^ARC("ALIAS",AliasId),"^",13)                                      //判断有效医嘱日期
	..i EffDate="" s EffDate=+$h+1
	..q:EffDate<+$h
	..s AliasText=$p(^ARC("ALIAS",AliasId),"^",6)
	..s AliasText=$ZCVT(AliasText,"U")
	..s Alias=Alias_"^"_AliasText
    .q:(($ZCVT(iARCIMDesc,"U")'[ARCIMDesc)&&(Alias'[ARCIMDesc))                    
    .d QueryOut   
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
QueryOut      
	set Data=$lb(iARCIMDesc,iARCIMDR,iARCIMCode)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod QueryOrdersFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryOrdersExecute ]
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

Query QueryOrders(ARCIMDesc As %Library.String) As %Query(ROWSPEC = "ARCIMDESC:%String,ARCIMDR:%String,ARCIMCODE:%String")
{
}

ClassMethod QueryOrdersClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryOrdersExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// d ##Class(web.DHCPE.BarPrintFind).OutMainHISUI()
ClassMethod OutMainHISUI(Month As %String = "", OutFlag As %String = "")
{
	
	i Month="" d
 	.s Month=+$H
 	e  d
 	.s Month=##class(websys.Conversions).DateHtmlToLogical(Month)
 	

 	s DateStr=$zd(Month,3)
 	s DateStr=$E(DateStr,0,8)
 	s StartDateStr=DateStr_"01"
 	s StartDate=$zdh(StartDateStr,3)
 	s EndDate=StartDate+32
 	s DateStr=$zd(EndDate,3)
 	s DateStr=$E(DateStr,0,8)
 	s EndDateStr=DateStr_"01"
 	s EndDate=$zdh(EndDateStr,3)
 	s EndDate=EndDate-1
 	
 	s TabInfo=""
 	if (OutFlag="Return") {
	 	s TabInfo=TabInfo_"<TABLE id='SpecList' height=100% width=100% border=0 cellspacing='0' cellpadding='0' style='white-space:normal; word-break:break-all;'>"
		s TabInfo=TabInfo_"<tr class='datagrid-header' headerCls='panel-header-gray' style='width:36px; height:30px; margin-top: 0px;'>"
		s TabInfo=TabInfo_"<td>周一</td>"
		s TabInfo=TabInfo_"<td>周二</td>"	
		s TabInfo=TabInfo_"<td>周三</td>"
		s TabInfo=TabInfo_"<td>周四</td>"
		s TabInfo=TabInfo_"<td>周五</td>"	
		s TabInfo=TabInfo_"<td>周六</td>"
		s TabInfo=TabInfo_"<td>周日</td>"		
		s TabInfo=TabInfo_"</tr>"
 	} else {
	 	w "<TABLE id='SpecList' height=100% width=100% border=0 cellspacing='0' cellpadding='0' style='white-space:normal; word-break:break-all;'>"
		w "<tr class='datagrid-header' headerCls='panel-header-gray' style='width:26px; height:36px; margin-top: 0px;'>"
		w "<td>周一</td>"
		w "<td>周二</td>"	
		w "<td>周三</td>"
		w "<td>周四</td>"
		w "<td>周五</td>"	
		w "<td>周六</td>"
		w "<td>周日</td>"		
		w "</tr>"
 	}
	d ClearInfo
	
	s UIVersion=##class(websys.StandardTypeItem).GetIdFromCodeOrDescription("websys","HISUIDefVersion")
    i UIVersion="lite" s LineColor="#E2E2E2;"
    e  s LineColor="#cccccc"
	
	/// 原来程序写的不对 改造下
	
	s Week=$ZD(StartDate,10)
 	i Week=0 s Week=7
	
	if (OutFlag="Return") {
		s TabInfo=TabInfo_"<tr>"
		/// 输出第一行1号之前的单元格
		f ind=1:1:Week-1 d
		.s TabInfo=TabInfo_"<td style='border-right: 1px solid "_LineColor_";'></td>"
		
	} else {
		/// 输出第一行1号之前的单元格
		f ind=1:1:Week-1 d
		.w "<td style='border-right: 1px solid "_LineColor_";'></td>"
		
	}
	s isFirstLine=1
	f Date=StartDate:1:EndDate {	
 		s Week=$ZD(Date,10)
 		i Week=0 s Week=7
		s DateStr=##class(websys.Conversions).DateLogicalToHtml(Date)
		s Flag=1
		
		if (OutFlag="Return") {
			/// 另起一行的时候输出行
			s:(Week=1)&&(Date'=StartDate) TabInfo=TabInfo_"</tr><tr>"
			s:(Week=1)&&(Date'=StartDate) isFirstLine=0
			s TabInfo=TabInfo_..OutLinkHISUI(DateStr,isFirstLine,Week)
		} else {
			/// 另起一行的时候输出行
			w:(Week=1)&&(Date'=StartDate) "</tr><tr>"
			s:(Week=1)&&(Date'=StartDate) isFirstLine=0
			w ..OutLinkHISUI(DateStr,isFirstLine,Week)
			
		}
 	}
 	/// 输出循环结束的行信息
 	s Week=$ZD(EndDate,10)
 	i Week=0 s Week=7
 	
	if (OutFlag="Return") {
 		
		 	f ind=1:1:7-Week d
			.s:(ind=(7-Week)) TabInfo=TabInfo_"<td style='border-top: 1px solid "_LineColor_";'></td>"
			.s:(ind'=(7-Week)) TabInfo=TabInfo_"<td style='border-top: 1px solid "_LineColor_";border-right: 1px solid "_LineColor_";'></td>"
	 	
	 	
	} else {
		f ind=1:1:7-Week d
		.w:(ind=(7-Week)) "<td style='border-top: 1px solid "_LineColor_";'></td>"
		.w:(ind'=(7-Week)) "<td style='border-top: 1px solid "_LineColor_";border-right: 1px solid "_LineColor_";'></td>"
 	}
 	
 	
 	
 	if (OutFlag="Return") {
 		
		 	
			s TabInfo=TabInfo_"<tr></table>"
	 	
	 	
	} else {
		
		w "<tr></table>"
 	}
 	//w ""
 	q TabInfo
ClearInfo
	s Flag=0
	s (PLIST(1),PLIST(2),PLIST(3),PLIST(4),PLIST(5),PLIST(6),PLIST(7))=""
	q
}

/// note by sun 增加行列数 用于UI改造
ClassMethod OutLinkHISUI(DateStr, Line As %String = "", Colum As %String = "")
{
	;d ##class(web.DHCPE.BarPrintFind).OutLinkHISUI("")
	s Job=$J
	k ^DHCPETemp("Spec",Job)
	
	s UIVersion=##class(websys.StandardTypeItem).GetIdFromCodeOrDescription("websys","HISUIDefVersion")
    i UIVersion="lite" s LineColor="#E2E2E2;"
    e  s LineColor="#CCCCCC"
	
	i DateStr=""{
		 q "<td></td>"
	}
	s Date=##class(websys.Conversions).DateHtmlToLogical(DateStr)
	s BeginDate=##class(websys.Conversions).DateLogicalToHtml(Date)
	
	
	s lnk="dhcpespecdetail.hisui.csp?DateStr="_Date_"&BeginDate="_BeginDate_"&EndDate="_BeginDate_"&Type=Item"
	s Time=""    
	f  s Time=$O(^DHCPETempLabEpisodeScan("Date",Date,Time)) q:Time=""  d
	.s SpecNo=""
	.f  s SpecNo=$O(^DHCPETempLabEpisodeScan("Date",Date,Time,SpecNo)) q:SpecNo=""  d
	..s LocFlag=##class(web.DHCPE.PreCommon).GetLocFlag("SPEC",SpecNo)         //Add by 090702
    ..q:LocFlag=1  
	..s Info=$G(^DHCPETempLabEpisodeScan(SpecNo))
	..s User=$P(Info,"^",3)
	..;q:User="1"
	..s:User="" User=1
	..s ^DHCPETemp("Spec",Job,User,"Total")=+$G(^DHCPETemp("Spec",Job,User,"Total"))+1
	..s Flag=..IsReturnResult(SpecNo)
	..s:Flag=0 ^DHCPETemp("Spec",Job,User,"NoResult")=+$G(^DHCPETemp("Spec",Job,User,"NoResult"))+1
	..s Flag=..IsNoRec(SpecNo)
	..s:Flag=0 ^DHCPETemp("Spec",Job,User,"NoRec")=+$G(^DHCPETemp("Spec",Job,User,"NoRec"))+1

	s Info=""
	s User=""
	f  s User=$O(^DHCPETemp("Spec",Job,User)) q:User=""  d
	.s UserDesc=$P(^SSU("SSUSR",User),"^",2)
	.s TotalNum=+$G(^DHCPETemp("Spec",Job,User,"Total"))
	.s NoResultNum=+$G(^DHCPETemp("Spec",Job,User,"NoResult"))
	.s NoRecNum=+$g(^DHCPETemp("Spec",Job,User,"NoRec"))
	.s Info=Info_"<br><font color=#000000 size='14pt' font-family=微软雅黑>"_UserDesc_"</font>-<font color=#28bA05 size='14pt' font-family=微软雅黑>"_TotalNum_"</font>"
	.i NoResultNum>0 s Info=Info_"-<font color='#EE0f0f' size=14pt font-family=微软雅黑>"_NoResultNum_"</font>"
	.i NoRecNum>0 s Info=Info_"-<font color=#ff9933 size=14pt font-family=微软雅黑>"_NoRecNum_"</font>"
	k ^DHCPETemp("Spec",Job)
	//w "<font color = red size=4pt><a href="_lnk_" target='_blank' >"_DateStr_"</a>"_Info_"</font>"
	q:(Line=1)&&(Colum'=7) "<td style='border-right: 1px solid "_LineColor_";' valign=top ondblclick='ShowSpecList(this)' id='"_DateStr_"'><font color = #000000  size=14pt font-family=微软雅黑>"_DateStr_"</font><br>"_Info_"</td>"
    q:(Line=1)&&(Colum=7) "<td valign=top ondblclick='ShowSpecList(this)' id='"_DateStr_"'><font color = #000000  size=14pt font-family=微软雅黑>"_DateStr_"</font><br>"_Info_"</td>"
    q:(Line'=1)&&(Colum'=7) "<td style='border-right: 1px solid "_LineColor_";border-top: 1px solid "_LineColor_";' valign=top ondblclick='ShowSpecList(this)' id='"_DateStr_"'><font color = #000000  size=14pt font-family=微软雅黑>"_DateStr_"</font><br>"_Info_"</td>"
    q:(Line='1)&&(Colum=7) "<td style='border-top: 1px solid "_LineColor_";' valign=top ondblclick='ShowSpecList(this)' id='"_DateStr_"'><font color = #000000  size=14pt font-family=微软雅黑>"_DateStr_"</font><br>"_Info_"</td>"
   
   q "<td valign=top ondblclick='ShowSpecList(this)' id='"_DateStr_"'><font color = #000000  size=14pt font-family=微软雅黑>"_DateStr_"</font><br>"_Info_"</td>"
}

/// Description: 获取采集标本一览数组
/// Input:		 BeginDate：开始日期， EndDate：结束日期
/// Return:  	  
/// Creator:	 xueying
/// CreateDate:	 2023-02-21
/// Debug: w ##class(web.DHCPE.BarPrintFind).GetSpectDataEventArr("2023-01-30","2023-03-12")
ClassMethod GetSpectDataEventArr(BeginDate, EndDate) As %DynamicArray
{
	s ^temp("DHCPE","GetSpectDataEventArr")=$lb(BeginDate,EndDate)
	Set arr = []
	Set Job=$J
	
	For Date = BeginDate:1:EndDate
	{
		Kill ^DHCPETemp("Spec",Job)
		Set Time = ""
		For {
			Set Time = $ORDER(^DHCPETempLabEpisodeScan("Date",Date,Time))
			Quit:Time=""
			Set SpecNo=""
			For {
				Set SpecNo = $ORDER(^DHCPETempLabEpisodeScan("Date",Date,Time,SpecNo))
				Quit:SpecNo=""
				
				Set LocFlag=##class(web.DHCPE.PreCommon).GetLocFlag("SPEC",SpecNo)  
				Continue:LocFlag=1
				Set Info=$G(^DHCPETempLabEpisodeScan(SpecNo))
				Set User=$P(Info,"^",3)
				Set:User="" User=1
				Set ^DHCPETemp("Spec",Job,User,"Total")=+$G(^DHCPETemp("Spec",Job,User,"Total"))+1
				Set Flag=##class(web.DHCPE.BarPrintFind).IsReturnResult(SpecNo)
				Set:Flag=0 ^DHCPETemp("Spec",Job,User,"NoResult")=+$G(^DHCPETemp("Spec",Job,User,"NoResult"))+1
				Set Flag=##class(web.DHCPE.BarPrintFind).IsNoRec(SpecNo)
				Set:Flag=0 ^DHCPETemp("Spec",Job,User,"NoRec")=+$G(^DHCPETemp("Spec",Job,User,"NoRec"))+1
				
			}
		}
		
		Set Info=""
		Set User = ""
		For {
		
			Set User = $ORDER(^DHCPETemp("Spec",Job,User))
			Quit:User=""
			Set UserDesc=$P(^SSU("SSUSR",User),"^",2)
			Set TotalNum=+$G(^DHCPETemp("Spec",Job,User,"Total"))
			Set NoResultNum=+$G(^DHCPETemp("Spec",Job,User,"NoResult"))
			Set NoRecNum=+$g(^DHCPETemp("Spec",Job,User,"NoRec"))
		    if Info="" {
			    Set Info ="<font color=green>"_UserDesc_"-"_TotalNum_"</font>"
				if NoResultNum>0 Set Info=Info_"-<font color=red>"_NoResultNum_"</font>"
				if NoRecNum>0 Set Info=Info_"-<font color=gold>"_NoRecNum_"</font>"
		    }else{
			    Set Info =Info_"<br><font color=green>"_UserDesc_"-"_TotalNum_"</font>"
				if NoResultNum>0 Set Info=Info_"-<font color=red>"_NoResultNum_"</font>"
				if NoRecNum>0 Set Info=Info_"-<font color=gold>"_NoRecNum_"</font>"
		    }
		}
		if (Info'=""){
		    Set obj = {}
			Set obj.title = Info
			Set startTime=$p($h,",",2)
			Set endTime=$p($h,",",2)
			Set obj.start = $ZDATE(Date,3)_" "_$ZTIME(startTime)
            Set obj.end = $ZDATE(Date,3)_" "_$ZTIME(endTime)
            Set obj.type = "Time"
            Set Notice=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("dhcpespeclist.new.hisui.csp","注：采集人-合计标本数-未回传结果标本数-未接收标本数")  //翻译
            Set obj.detail = Notice
			Do arr.%Push(obj)
		}	
		
	  k ^DHCPETemp("Spec",Job)
			
	}
	
	Quit arr
}

ClassMethod IsNoRec(SpecNo)
{
	s Flag=1
	q:SpecNo="" Flag
	s OEORDID=$O(^OEORD(0,"EpisNo",SpecNo,""))
	s OEpisNoid=0
	f  s OEpisNoid=$O(^OEORD(0,"EpisNo",SpecNo,OEORDID,OEpisNoid)) q:(OEpisNoid="")||(Flag=0)  d
	.s OeordItemID=OEORDID_"||"_OEpisNoid
	.q:$p($G(^OEORD(OEORDID,"I",OEpisNoid,1)),"^",13)="4"
	.s:$p($G(^OEORD(OEORDID,"I",OEpisNoid,1)),"^",13)="1" Flag=0
	q Flag
}

Query FindPreManager(Month As %String = "") As %Query(ROWSPEC = "TZ1:%String,TZ2:%String,TZ3:%String,TZ4:%String,TZ5:%String,TZ6:%String,TZ7:%String")
{
}

ClassMethod FindPreManagerExecute(ByRef qHandle As %Binary, Month As %String = "") As %Status
{
	;d ##class(%ResultSet).RunQuery("web.DHCPE.PreManager","FindPreManager",62607)
	Set repid=$I(^CacheTemp)
 	s ind=1
 	i Month="" d
 	.s Month=+$H
 	e  d
 	.;s Month=$ZDH(Month,4)
 	.s Month=##class(websys.Conversions).DateHtmlToLogical(Month) 
   
 	s DateStr=$ZD(Month,3)
 	
 	s DateStr=$E(DateStr,0,8)
 	s StartDateStr=DateStr_"01"
 	s StartDate=$ZDH(StartDateStr,3)
 	
 	s EndDate=StartDate+32
 	s DateStr=$ZD(EndDate,3)
 	s DateStr=$E(DateStr,0,8)
 	s EndDateStr=DateStr_"01"
 	s EndDate=$ZDH(EndDateStr,3)
 	
 	s EndDate=EndDate-1
 	d ClearInfo
 	f Date=StartDate:1:EndDate
 	{	
 		s Week=$ZD(Date,10)
 		//s Week=##class(websys.Conversions).DateLogicalToHtml(Date)
 		i Week=0 s Week=7
		//s DateStr=$ZD(Date,3)
		s DateStr=##class(websys.Conversions).DateLogicalToHtml(Date)
		s Flag=1
		s PLIST(Week)=DateStr
		i Week=7 d
		.d FindAreaBuild
		.d ClearInfo
 	}
 	d:Flag=1 FindAreaBuild
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
ClearInfo
	s Flag=0
	s (PLIST(1),PLIST(2),PLIST(3),PLIST(4),PLIST(5),PLIST(6),PLIST(7))=""
	q
FindAreaBuild      
	set Data=$lb(PLIST(1),PLIST(2),PLIST(3),PLIST(4),PLIST(5),PLIST(6),PLIST(7))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindPreManagerFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindPreManagerExecute ]
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

ClassMethod FindPreManagerClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindPreManagerExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

Query FindSpecDetail(BeginDate As %String = "", EndDate As %String, FindType As %String = "Detail", VIPLevel As %String = "", ShowTotal As %String = "", VName As %String = "", SpecCode As %String = "") As %Query(ROWSPEC = "RecordSum:%String,TRegNo:%String,TName:%String,TSpecNo:%String,TReceiver:%String,TRecDate:%String,TSpecCode:%String,TSpecDesc:%String,TSpecColor:%String,TResultStatus:%String")
{
}

ClassMethod FindSpecDetailExecute(ByRef qHandle As %Binary, BeginDate As %String = "", EndDate As %String, FindType As %String = "Detail", VIPLevel As %String = "", ShowTotal As %String = "", VName As %String = "", SpecCode As %String = "") As %Status
{
	;d ##class(%ResultSet).RunQuery("web.DHCPE.BarPrintFind","FindSpecDetail",62607)
   
    
	Set repid=$I(^CacheTemp)
	;s FindType="Item"
	s Job=$J
	s UserID=%session.Get("LOGON.USERID")
	s ExportName="DHCPESpecDetail"
	k ^TempDHCPEExportCommon(UserID,ExportName)
	k ^TempDHCPEBarPrintFind(Job)
	k ^DHCPETMPLabEpisode("Item","SpecNo")
 	s ind=1
 	i EndDate'="" s EndDate=##class(websys.Conversions).DateHtmlToLogical(EndDate) 
 	i BeginDate'="" s BeginDate=##class(websys.Conversions).DateHtmlToLogical(BeginDate) 
 	i BeginDate="" s BeginDate=0
 	i EndDate="" s EndDate=+$H
 	i VName'="" d
 	.k ^TempDHCPEBarPrintFind($J)
 	.s NameU=$$ALPHAUP^SSUTIL4(VName)
 	.s NameDesc=$O(^PAPERi("PAPER_PatName",NameU),-1)
 	.f  s NameDesc=$O(^PAPERi("PAPER_PatName",NameDesc)) q:(NameDesc="")||(NameDesc'[NameU)  d
 	..s PatID=0
 	..f  s PatID=$O(^PAPERi("PAPER_PatName",NameDesc,PatID)) q:(PatID="")  d
 	...s PAADMID=""
 	...f  s PAADMID=$O(^PAPERdr(PatID,"ADM","H",PAADMID)) q:PAADMID=""  d
 	....s OrderID=$O(^OEORD(0,"Adm",PAADMID,0))
 	....q:OrderID=""
 	....s OrderSub=0
 	....f  s OrderSub=$O(^OEORD(OrderID,"I",OrderSub)) q:OrderSub=""  d
 	.....s Stat=$p($G(^OEORD(OrderID,"I",OrderSub,1)),"^",13)
 	.....q:Stat="4"
 	.....s SpecNo=$p($G(^OEORD(OrderID,"I",OrderSub,3)),"^",20)
 	.....q:SpecNo=""
 	.....q:'$D(^DHCPETempLabEpisodeScan(SpecNo))
 	.....q:$d(^DHCPETMPLabEpisode("Item","SpecNo",SpecNo))
    .....s ^DHCPETMPLabEpisode("Item","SpecNo",SpecNo)=1
 	.....;q:$D(^TempDHCPEBarPrintFind($J,SpecNo))
 	.....;s ^TempDHCPEBarPrintFind($J,SpecNo)=""
 	.....d OneSpecNo
 	.;k ^TempDHCPEBarPrintFind($J)
 	e  d
 	.s DateStr=BeginDate-1
 	.f  s DateStr=$O(^DHCPETempLabEpisodeScan("Date",DateStr)) q:(DateStr="")||(DateStr>EndDate)  d
 	..s Time=""
	..f  s Time=$O(^DHCPETempLabEpisodeScan("Date",DateStr,Time)) q:Time=""  d
	...s SpecNo=""
	...f  s SpecNo=$O(^DHCPETempLabEpisodeScan("Date",DateStr,Time,SpecNo)) q:SpecNo=""  d
	....d OneSpecNo
	i FindType="Person" d
	.s TReceiver=""
	.s OneTotal=0
	.f  s TReceiver=$O(^TempDHCPEBarPrintFind(Job,"Total",TReceiver)) q:TReceiver=""  d
	..s (RegNo,Name,SpecNo)=""
	..s RegNo=$G(^TempDHCPEBarPrintFind(Job,"Total",TReceiver))
	..s OneTotal=OneTotal+RegNo
	..d FindSpecDetailBuild
	.s (RegNo,Name,SpecNo)=""
	.s RegNo=OneTotal
	.s TReceiver="总计"
	.d FindSpecDetailBuild
	i FindType="Item" d
	.s RecLocID=""
	.f  s RecLocID=$O(^TempDHCPEBarPrintFind(Job,"Total",RecLocID)) q:RecLocID=""  d
	..s RecLocDesc=$P(^CTLOC(RecLocID),"^",2)
	..s Item=""
	..f  s Item=$O(^TempDHCPEBarPrintFind(Job,"Total",RecLocID,Item)) q:Item=""  d
	...s OneTotal=0
	...s TReceiver=""
	...f  s TReceiver=$O(^TempDHCPEBarPrintFind(Job,"Total",RecLocID,Item,TReceiver)) q:TReceiver=""  d
	....s (RegNo,Name,SpecNo)=""
	....s RegNo=$G(^TempDHCPEBarPrintFind(Job,"Total",RecLocID,Item,TReceiver))
	....s OneTotal=OneTotal+RegNo
	....s Name=$P(Item,"&",2)
	....s placeCode="",placerCodeDesc="",placerColor="",ResultStatus=""
	....i ShowTotal'="1" d
	.....s placeInfo=$G(^TempDHCPEBarPrintFind(Job,"Total",RecLocID,Item,TReceiver,"SPECContainer"))
	.....s placeCode=$P(placeInfo,"^",1)
	.....s placerCodeDesc=$P(placeInfo,"^",2)
	.....s placerColor=$P(placeInfo,"^",3)
	.....s ResultStatus=$g(^TempDHCPEBarPrintFind(Job,"Total",RecLocID,Item,TReceiver,"ResultStatus"))
	.....d FindSpecDetailBuild
	...s (RegNo,Name,SpecNo)=""
	...s RegNo="合计:"_OneTotal
	...;s Name=Item
	...s Name=$P(Item,"&",2)
	...s TReceiver=""
	...d FindSpecDetailBuild
	i FindType="Detail"  d
	.;^TempDHCPEBarPrintFind(Job,"Total",TReceiver,SpecNo)
	.s TReceiver="" 
	.f  s TReceiver=$O(^TempDHCPEBarPrintFind(Job,"Total",TReceiver)) q:TReceiver=""  d
	..s OneTotal=0
	..s SpecNo=""
	..f  s SpecNo=$O(^TempDHCPEBarPrintFind(Job,"Total",TReceiver,SpecNo)) q:SpecNo=""  d
	...s OneTotal=OneTotal+1
	...s Info=$G(^TempDHCPEBarPrintFind(Job,"Total",TReceiver,SpecNo))
	...s RegNo=$P(Info,"^",1)
	...s Name=$P(Info,"^",2)
	...s TRecDate=$P(Info,"^",3)
	...d:ShowTotal'="1" FindSpecDetailBuild
	..s RegNo="合计:"_OneTotal
	..s Name=""
	..s SpecNo=""
	..s TRecDate=""
	..d FindSpecDetailBuild
	k ^TempDHCPEBarPrintFind(Job)
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OneSpecNo
	s LocFlag=##class(web.DHCPE.PreCommon).GetLocFlag("SPEC",SpecNo)
	q:LocFlag=1
	s Info=$G(^DHCPETempLabEpisodeScan(SpecNo))
	s TReceiver=$P(Info,"^",3)
	q:TReceiver=""
	s Time=$P(Info,"^",2)
	s Date=$P(Info,"^",1)
	q:Date>EndDate
	q:Date<BeginDate
	s TRecDate=$ZD(Date,3)_" "_$ZT(Time)
	s:TReceiver'="" TReceiver=$P(^SSU("SSUSR",TReceiver),"^",2)
	s OEORDID=$O(^OEORD(0,"EpisNo",SpecNo,""))
	;s obj=##class(User.OEOrder).%OpenId(OEORDID)
	s AdmID=$p($G(^OEORD(OEORDID)),"^",1)
	s PatID=$P(^PAADM(AdmID),"^",1)
	s Name=$P(^PAPER(PatID,"ALL"),"^",1) ;obj.OEORDAdmDR.PAADMPAPMIDR.PAPMIName
	q:(VName'="")&&(Name'[VName)
	s CurVIP=##class(web.DHCPE.PreCommon).GetVIPLevel("PAADM",AdmID)
	q:(VIPLevel'="")&&(VIPLevel'=+CurVIP)
	i FindType="Person" d
	.q:$D(^TempDHCPEBarPrintFind(Job,"Detail",TReceiver,AdmID))
	.s ^TempDHCPEBarPrintFind(Job,"Total",TReceiver)=+$G(^TempDHCPEBarPrintFind(Job,"Total",TReceiver))+1
	.s ^TempDHCPEBarPrintFind(Job,"Detail",TReceiver,AdmID)=""
	i FindType="Item"  d
	.d ItemList
	i FindType="Detail"  d
	.;q:FindType'="Detail"
	.s Name=$P(^PAPER(PatID,"ALL"),"^",1)
	.s RegNo=$P(^PAPER(PatID,"PAT",1),"^",1)
	.s ^TempDHCPEBarPrintFind(Job,"Total",TReceiver,SpecNo)=RegNo_"^"_Name_"^"_TRecDate
	.;d FindSpecDetailBuild
	q
ItemList
	s OEORDID=$O(^OEORD(0,"EpisNo",SpecNo,""))
	s OEpisNoid=0
	f  s OEpisNoid=$O(^OEORD(0,"EpisNo",SpecNo,OEORDID,OEpisNoid)) q:(OEpisNoid="")  d
	.s OeordItemID=OEORDID_"||"_OEpisNoid
	.q:$p($G(^OEORD(OEORDID,"I",OEpisNoid,1)),"^",13)="4"
	.s RecLoc=$p($G(^OEORD(OEORDID,"I",OEpisNoid,3)),"^",6)
	.;s obj=##class(User.OEOrdItem).%OpenId(OeordItemID)
	.s ArcID=$p($G(^OEORD(OEORDID,"I",OEpisNoid,1)),"^",2)
	.;s ArcDesc=obj.OEORIItmMastDR.ARCIMDesc
	.s ArcDesc=##class(web.DHCPE.DHCPECommon).GetArcDesc(ArcID)
	.s ARCOS=$p($G(^OEORD(OEORDID,"I",OEpisNoid,3)),"^",10)
	.s OEORIItmMastDR=$p($G(^OEORD(OEORDID,"I",OEpisNoid,1)),"^",2)
	.s ResultStatus=##class(web.DHCPE.OEOrdItem).GetResultStatus(SpecNo,OEORIItmMastDR,ARCOS,OeordItemID)
	.s placerStr=##Class(web.DHCNurCom).GetSpecContainerCode(OeordItemID)
	.s placerColor=$p(placerStr,"^",5) //颜色 
	.s placerVolumn=$p(placerStr,"^",4) //容量
	.s placerCodeDesc=$p(placerStr,"^",3) //名称 
	.s placeCode=$p(placerStr,"^",1)_$p(placerStr,"^",2)
	.q:(SpecCode'="")&&(SpecCode'=placeCode)
	.i placerVolumn'="" s placerCodeDesc=placerVolumn_"ml"_placerCodeDesc
	.s ^TempDHCPEBarPrintFind(Job,"Total",RecLoc,ArcID_"&"_ArcDesc,TReceiver)=+$G(^TempDHCPEBarPrintFind(Job,"Total",RecLoc,ArcID_"&"_ArcDesc,TReceiver))+1
	.s ^TempDHCPEBarPrintFind(Job,"Total",RecLoc,ArcID_"&"_ArcDesc,TReceiver,"SPECContainer")=placeCode_"^"_placerCodeDesc_"^"_placerColor
	.s ^TempDHCPEBarPrintFind(Job,"Total",RecLoc,ArcID_"&"_ArcDesc,TReceiver,"ResultStatus")=ResultStatus
	q

FindSpecDetailBuild
	s Flag=0
	s:FindType="Detail" Flag=..IsReturnResult(SpecNo)
	s Num="1000000000"
	;i Flag=1 s Num="200000000000"   
	set Data=$lb(0,RegNo,Name,SpecNo,TReceiver,$G(TRecDate),placeCode,placerCodeDesc,placerColorr,ResultStatus)
 	Set ^CacheTemp(repid,Num+ind)=Data
 	i FindType="Detail" d
 	.s ^TempDHCPEExportCommon(UserID,ExportName,ind)=TReceiver_"^"_Name_"^"_RegNo_"^"_SpecNo_"^"_$P(##class(web.DHCPE.BarPrintFind).GetOrdInfo(SpecNo),"^",6)
 	e  i FindType="Item"  d
 	.s ^TempDHCPEExportCommon(UserID,ExportName,ind)=TReceiver_"^"_Name_"^"_RegNo_"^"_placerCodeDesc_"^"_ResultStatus
 	e  d
 	.s ^TempDHCPEExportCommon(UserID,ExportName,ind)=TReceiver_"^"_RegNo
 	s placeCode="",placerCodeDesc="",placerColor="",ResultStatus=""
 	Set ind=ind+1
 	q
}

ClassMethod FindSpecDetailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindSpecDetailExecute ]
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
 		s RecordSum=$o(^CacheTemp(repid,""),-1)-1000000000
 		s $LIST(^CacheTemp(repid,ind),1)=RecordSum
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindSpecDetailClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindSpecDetailExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod OutOrdInfo(SpecNo)
{
	q:SpecNo=""
	s Info=""
	s OEORDID=$O(^OEORD(0,"EpisNo",SpecNo,""))
	s OEpisNoid=0
	f  s OEpisNoid=$O(^OEORD(0,"EpisNo",SpecNo,OEORDID,OEpisNoid)) q:(OEpisNoid="")  d
	.s OeordItemID=OEORDID_"||"_OEpisNoid
	.q:$p($G(^OEORD(OEORDID,"I",OEpisNoid,1)),"^",13)="4"
	.s obj=##class(User.OEOrdItem).%OpenId(OeordItemID)
	.s ArcDesc=obj.OEORIItmMastDR.ARCIMDesc
	.i $O(^DHCPERLT(0,"OEORI",OeordItemID,""))="" d
	..s ArcDesc="<font color=red>"_ArcDesc_"</font>"
	.i Info="" d
	..s Info=ArcDesc
	.e  d
	..s Info=Info_","_ArcDesc
	w Info
}

ClassMethod GetOrdInfo(SpecNo As %Library.String = "")
{
	q:SpecNo="" ""
	s OEORDID=$O(^OEORD(0,"EpisNo",SpecNo,""))
	q:OEORDID=""
	s obj=##class(User.OEOrder).%OpenId(OEORDID)
	s RegNo=obj.OEORDAdmDR.PAADMPAPMIDR.PAPMINo
	s Name=obj.OEORDAdmDR.PAADMPAPMIDR.PAPMIName
	s Sex=obj.OEORDAdmDR.PAADMPAPMIDR.PAPMISexDR.CTSEXDesc
	s Age=obj.OEORDAdmDR.PAADMPAPMIDR.PAPMIDOB
	s:Age'="" Age=+##class(web.DHCLCNUREXCUTE).CalAge(Age,+$h)
	s Info=""
	s OEpisNoid=0
	f  s OEpisNoid=$O(^OEORD(0,"EpisNo",SpecNo,OEORDID,OEpisNoid)) q:(OEpisNoid="")  d
	.s OeordItemID=OEORDID_"||"_OEpisNoid
	.q:$p($G(^OEORD(OEORDID,"I",OEpisNoid,1)),"^",13)="4"
	.s OEORIItmMastDR=$p($G(^OEORD(OEORDID,"I",OEpisNoid,1)),"^",2)
	
	.s ARCIMSubscript=$p(OEORIItmMastDR,"||",1)
	.s ARCIMVersion=$p(OEORIItmMastDR,"||",2)
	.s ArcDesc=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",2)
	.i Info="" d
	..s Info=ArcDesc
	.e  d
	..s Info=Info_","_ArcDesc
	q RegNo_"^"_Name_"^"_Sex_"^"_Age_"^"_SpecNo_"^"_Info
}

ClassMethod GetAllSpecNo(DateStr As %Library.String = "")
{
	s str=""
	s Time=""
	f  s Time=$O(^DHCPETempLabEpisodeScan("Date",DateStr,Time)) q:Time=""  d
	.s SpecNo=""
	.f  s SpecNo=$O(^DHCPETempLabEpisodeScan("Date",DateStr,Time,SpecNo)) q:SpecNo=""  d
	..s LocFlag=##class(web.DHCPE.PreCommon).GetLocFlag("SPEC",SpecNo)
	..q:LocFlag=1
	..i str="" d
	...s str=SpecNo
	..e  d
	...s str=str_"^"_SpecNo
	Quit str
}

ClassMethod OutLink(DateStr)
{
	;d ##class(web.DHCPE.BarPrintFind).OutLink("")
	s Job=$J
	k ^DHCPETemp("Spec",Job)
	i DateStr=""{
		 w ""
		 q
	}
	s Date=##class(websys.Conversions).DateHtmlToLogical(DateStr)
	s BeginDate=##class(websys.Conversions).DateLogicalToHtml(Date)
	//s Date=$ZDH(DateStr,3)
	//s BeginDate=$ZD(Date,4)
	
	s lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCPESpecDetail&DateStr="_Date_"&BeginDate="_BeginDate_"&EndDate="_BeginDate_"&FindType=Item"
	s Time=""    
	f  s Time=$O(^DHCPETempLabEpisodeScan("Date",Date,Time)) q:Time=""  d
	.s SpecNo=""
	.f  s SpecNo=$O(^DHCPETempLabEpisodeScan("Date",Date,Time,SpecNo)) q:SpecNo=""  d
	..s LocFlag=##class(web.DHCPE.PreCommon).GetLocFlag("SPEC",SpecNo)         //Add by 090702
    ..q:LocFlag=1  
	..s Info=$G(^DHCPETempLabEpisodeScan(SpecNo))
	..s User=$P(Info,"^",3)
	..;q:User="1"
	..s:User="" User=1
	..s ^DHCPETemp("Spec",Job,User,"Total")=+$G(^DHCPETemp("Spec",Job,User,"Total"))+1
	..s Flag=..IsReturnResult(SpecNo)
	..s:Flag=0 ^DHCPETemp("Spec",Job,User,"NoResult")=+$G(^DHCPETemp("Spec",Job,User,"NoResult"))+1
	s Info=""
	s User=""
	f  s User=$O(^DHCPETemp("Spec",Job,User)) q:User=""  d
	.s UserDesc=$P(^SSU("SSUSR",User),"^",2)
	.s TotalNum=+$G(^DHCPETemp("Spec",Job,User,"Total"))
	.s NoResultNum=+$G(^DHCPETemp("Spec",Job,User,"NoResult"))
	.s Info=Info_"<br><font color=green>"_UserDesc_"-"_TotalNum_"</font>"
	.i NoResultNum>0 s Info=Info_"-<font color=red>"_NoResultNum_"</font>"
	k ^DHCPETemp("Spec",Job)
	w "<font color = red size=4pt><a href="_lnk_" target='_blank' >"_DateStr_"</a>"_Info_"</font>"
}

ClassMethod IsReturnResult(SpecNo)
{
	s Flag=1
	q:SpecNo="" Flag
	s OEORDID=$O(^OEORD(0,"EpisNo",SpecNo,""))
	s OEpisNoid=0
	f  s OEpisNoid=$O(^OEORD(0,"EpisNo",SpecNo,OEORDID,OEpisNoid)) q:(OEpisNoid="")||(Flag=0)  d
	.s OeordItemID=OEORDID_"||"_OEpisNoid
	.q:$p($G(^OEORD(OEORDID,"I",OEpisNoid,1)),"^",13)="4"
	.s:$O(^DHCPERLT(0,"OEORI",OeordItemID,""))="" Flag=0
	q Flag
}

ClassMethod GetLisResult(Date, UserId)
{
	s flag=0
	s BeginDate=$P(Date,"^",1)
	i BeginDate="" d
	.s BeginDate=+$H
	e  d
	.s BeginDate=##class(websys.Conversions).DateHtmlToLogical(BeginDate)
	s EndDate=$P(Date,"^",2)
	i EndDate="" d
	.s EndDate=+$H
	e  d
	.s EndDate=##class(websys.Conversions).DateHtmlToLogical(EndDate)
	s Date=BeginDate-1
	f  s Date=$O(^DHCPETempLabEpisodeScan("Date",Date)) q:(Date="")||(Date>EndDate)  d
	.s Time=""
	.f  s Time=$O(^DHCPETempLabEpisodeScan("Date",Date,Time)) q:Time=""  d
	..s SpecNo=""
	..f  s SpecNo=$O(^DHCPETempLabEpisodeScan("Date",Date,Time,SpecNo)) q:SpecNo=""  d
	...s OEORDID=$O(^OEORD(0,"EpisNo",SpecNo,""))
	...q:OEORDID=""
	...s admId=$P($g(^OEORD(OEORDID)),"^",1)
	...s OEpisNoid=0
	...f  s OEpisNoid=$O(^OEORD(0,"EpisNo",SpecNo,OEORDID,OEpisNoid)) q:(OEpisNoid="")  d
	....s OeordItemID=OEORDID_"||"_OEpisNoid
	....q:$O(^DHCPERLT(0,"OEORI",OeordItemID,""))'=""  
	....;d ##class(web.DHCPE.TransResult).TransALabItem(admId, UserId, OeordItemID)
	....s flag=1
	....d ##class(web.DHCPE.TransResult).TransALabItemNewByPT(admId, UserId, OeordItemID)
	q flag
}

ClassMethod GetPrintTime()
{
	s Date=$zd(+$h,3)
	s Time=$zt($p($h,",",2),1)
	q Date_" "_Time
}

ClassMethod OutFindTypeToHTML(DefautValue As %String = "Detail") As %String
{
	;d ##Class(web.DHCPE.RoomManager).OutStationToHTML("130")
	s ContrlWidth="155"
	s (DStr,IStr,PStr)=">"
	s:DefautValue="Detail" DStr=" selected>"
	s:DefautValue="Item" IStr=" selected>"
	s:DefautValue="Person" PStr=" selected>"
	//下拉列表
	w "<select name='FindType' id='FindType' style='width:"_ContrlWidth_"' HEIGHT=0  tabIndex=2>",!
	w "<option value='Detail' "_DStr_"明细</option>",!
	w "<option value='Item' "_IStr_"项目</option>",!
	w "<option value='Person' "_PStr_"人员</option>",!
	w "</select>",!
	Quit $$$OK
}

Query QueryCheckInfo(AdmStr As %Library.String) As %Query(ROWSPEC = "TRegNo:%String,TName:%String,TSex:%String,TBirth:%String,TTel:%String,TGroupDesc:%String,TCurRoom:%String")
{
}

ClassMethod QueryCheckInfoExecute(ByRef qHandle As %Binary, AdmStr As %Library.String) As %Status
{
 	Set repid=$I(^CacheTemp)
 	s ind=1
 	s AdmLength=$L(AdmStr,"^")
	f i=1:1:AdmLength d
	.s OneAdmStr = $P(AdmStr,"^",i)
	.q:OneAdmStr=""
	.;PatName_"^"_Sex_"^"_Birth_"^"_IDCard_"^"_RegNo_"^"_Tel
	.s Info=##class(web.DHCPE.AdmRecordManager).GetBaseInfo(OneAdmStr)
	.s CurRoomInfo=##class(web.DHCPE.RoomManager).GetAdmCurRoom(OneAdmStr,"ADM","Desc")
	.s Person=$P(CurRoomInfo,"^",2)
	.s Name=$P(CurRoomInfo,"^",3)
	.s CurRoomInfo=$P(CurRoomInfo,"^",1)
	.s CurRoomInfo="'"_Name_"'在'"_CurRoomInfo_"'处候诊,是第'"_Person_"'位"
    .d QueryCheckInfo
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
QueryCheckInfo
	;TRegNo,TName,TSex,TBirth,TTel,TGroupDesc,TCurRoom
	set Data=$lb($P(Info,"^",5),$P(Info,"^",1),$P(Info,"^",2),$P(Info,"^",3),$P(Info,"^",6),$P(Info,"^",7),CurRoomInfo)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod QueryCheckInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryCheckInfoExecute ]
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

ClassMethod QueryCheckInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryCheckInfoExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

Query QuerySPECContainers(Desc As %Library.String, LocID) As websys.Query(ROWSPEC = "SpecCode:%String,SpecDesc:%String,SpecColor:%String")
{
}

ClassMethod QuerySPECContainersExecute(ByRef qHandle As %Binary, Desc As %Library.String, LocID) As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	s LisNewVersion=$g(^DHCPESetting("DHCPE","LisNewVersion",LocID))
 	i LisNewVersion'="Y"
 	{
	 	Set qHandle=$lb(0,repid,0)
		Quit $$$OK
 	}
 	s id=0
 	f  s id=$O(^dbo.BTContainerD(id))  q:id=""  d
 	.s SpecCode=$lg(^dbo.BTContainerD(id),2)
 	.s SpecDesc=$lg(^dbo.BTContainerD(id),3)
 	.s Volumn=$lg($g(^dbo.BTContainerD(id)),5)
 	.s:Volumn'="" SpecDesc=Volumn_"ml"_SpecDesc
 	.q:(Desc'="")&&(SpecDesc'[Desc)
 	.s SpecColor=$lg(^dbo.BTContainerD(id),6)
 	.s Data=$lb(SpecCode,SpecDesc,SpecColor)
 	.s ^CacheTemp(repid,ind)=Data
 	.s ind=ind+1
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
}

}
