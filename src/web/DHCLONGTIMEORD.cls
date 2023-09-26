Import SQLUser

/// web.DHCLONGTIMEORD
Class web.DHCLONGTIMEORD Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Parameter BUILD = 1258;

ClassMethod GetLongOrdClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetLongOrdExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod GetAdm(RegNo)
{
  	q:RegNo="" ""
  	s patConfig=##class(web.DHCCLCom).GetPatConfig()
	s regNoLong=$p(patConfig,"^")
  	s nvar=""
  	s ln=$L(RegNo)
	s le=regNoLong+1-ln
	s $P(nvar,"0",le)=RegNo
	s papmi=""
	f  s papmi=$o(^PAPERi("PAPMI_PatNo",nvar,papmi)) q:papmi=""  d
	.s name=$p(^PAPER(papmi,"ALL"),"^",1)
	.s Adm=""
	.f  s Adm=$o(^PAPERdr(papmi,"ADM","I",Adm)) q:Adm=""  d  	
	..;s visitstatus=$p(^PAADM(Adm),"^",20)
	..;q:visitstatus'="A"
	..s Typ=$p(^PAADM(Adm),"^",2)
	..q:Typ'="I"
	..s papmiId=papmi
	..s adm=Adm
	..s AdmStr=$G(AdmStr)_Adm_"^"
	q $G(nvar)_"^"_$G(AdmStr)
}

ClassMethod GetPrior() As %String
{
	n
	s num=$L(^DHCLONGSET("longprior"),"^")
	f i=1:1:num
	{
		s str=$P(^DHCLONGSET("longprior"),"^",i)
		s LPrior=$G(LPrior)_$P(str,"|",2)_"^"
		
	}
	q "^"_$G(LPrior)
}

ClassMethod GetTempPrior() As %String
{
	n
	s num=$L(^DHCLONGSET("tempprior"),"^")
	f i=1:1:num
	{
		s str=$P(^DHCLONGSET("tempprior"),"^",i)
		s TempPrior=$G(TempPrior)_$P(str,"|",2)_"^"
		
	}
	q "^"_$G(TempPrior)
}

ClassMethod GetMedCat() As %String
{
   n	
	s num=$L(^DHCLONGSET("medcat"),"^")
	f i=1:1:num
	{
		s str=$P(^DHCLONGSET("medcat"),"^",i)
		s catdr=$P(str,"|",1)
		s catcode=$P(^OEC("ORCAT",catdr),"^",1)
		s medcat=$G(medcat)_catcode_"^"
	}
	q "^"_$G(medcat)
}

ClassMethod GetLongOrdExecute(ByRef qHandle As %Binary, Adm As %String, StartDate As %String, EndDate As %String, ChangeDate As %String = "", stop As %String = "0", ssuser = "", CurDep = "", NurOrd, DocOrd, SelDocDep As %String = "N", DocDepId = "", SelRecDep As %String = "N", RecDepId = "") As %Status
{
  
   Set repid=$I(^CacheTemp)
   s ind=1
   s i=0
   q:$G(Adm)="" ""
   s adm=Adm
   s UsrTyp=..ssusertyp(ssuser)
   if $G(adm)="" Set qHandle=$lb(0,repid,0) Quit $$$OK
   if CurDep="" s CurDep=1  //=$P(^PAADM(Adm),"^",4)
   e   s depno=CurDep
       k ^mtemp($j,"long",Adm)
       d ##CLASS(web.DHCTEMPOERPRINT).GetPatLoc(adm)
       s depnum=1
       s Oew="" f  s Oew=$O(^OEORD(0,"Adm",adm,Oew)) q:Oew=""  d
	   .s OrdSub="0"  f  s OrdSub=$O(^OEORD(Oew,"I",OrdSub))  q:(OrdSub="")!(OrdSub="0")  d
	   ..s OrdDep=$P($G(^OEORD(Oew,"I",OrdSub,1)),"^",3)
	   ..s odt=$P($G(^OEORD(Oew,"I",OrdSub,3)),"^",7),otim=$P($G(^OEORD(Oew,"I",OrdSub,1)),"^",17)
	   ..s ODTim=odt*86400+otim
	   ..s depnum=..getdepno(adm,ODTim)
	   ..q:OrdDep=""
	   ..q:(depnum'=depno)  //depno 转科顺序号
	   ..s SchLoc=$P($G(^OEORD(Oew,"I",OrdSub,7)),"^",2)
	   ..s SchLoc=$p(SchLoc,$c(1))
	   ..q:(SelDocDep="Y")&(DocDepId'="")&(DocDepId'=SchLoc)
	   ..s OrdRecDepId=$P($G(^OEORD(Oew,"I",OrdSub,3)),"^",6)
	   ..q:(SelRecDep="Y")&(RecDepId'="")&(RecDepId'=OrdRecDepId)
	   ..s PriorDR=$P($G(^OEORD(Oew,"I",OrdSub,1)),"^",8)     ;OEC_Priority                OEORI_Priority_DR
	   ..i PriorDR'="" s PriorDes=$P(^OECPR(PriorDR),"^",2)  
	   ..e  q     
	   ..s PriorDes="^"_PriorDes_"^"
	   ..s ArcimDR=$P($G(^OEORD(Oew,"I",OrdSub,1)),"^",2)
	   ..//长期显示临时术后医嘱,为了分页  
	   ..q:(^DHCOEOrdPrintSet("L","OrdTyp")'[PriorDes)&(ArcimDR'="4898||1")&(ArcimDR'="5632||1")
	   ..s OrdDate=$P($G(^OEORD(Oew,"I",OrdSub,1)),"^",9)
	   ..s OrdTime=$P($G(^OEORD(Oew,"I",OrdSub,1)),"^",10)
	   ..s OrdStatDR=$P($G(^OEORD(Oew,"I",OrdSub,1)),"^",13) 
	   ..s OrdStatCode=$p(^OEC("OSTAT",OrdStatDR),"^",1)
	   ..q:(OrdStatCode="U")
	   ..i OrdStatDR'="" s OrdStat=$P(^OEC("OSTAT",OrdStatDR),"^",2) 
	   ..e  s OrdStat=""  ;ord status
	   ..s XSTR="||"
	   ..i OrdStatCode="D" s XSTR=..PRX(Oew,OrdSub) ;求医生停止医嘱日期时间
	   ..i ($G(XDate(Oew,OrdSub))="")&($P(XSTR,"|",1)'="") d
	   ...s XDate(Oew,OrdSub)=$ZD(OrdDate,3),XTime(Oew,OrdSub)=$P(XSTR,"|",2),XCpt(Oew,OrdSub)=$P(XSTR,"|",3) 
	   ..s XSTR=""
	   ..i OrdStatCode="D" s XSTR=##class(web.DHCLCNUREXCUTE).GetXOrdInfo(Oew,OrdSub) ;
	   ..;i OrdStatCode="D" s XSTR=..SingNur(Oew,OrdSub) ;
	   ..i XSTR'="" d
	   ...s nursestopDate(Oew,OrdSub)=$P(XSTR,"|",1),nursestopTime(Oew,OrdSub)=$P(XSTR,"|",2),nursestop(Oew,OrdSub)=$P(XSTR,"|",3) 
       ...s stopOrdInfo=##class(web.DHCLCNUREXCUTE).GetXOrdInfo(Oew,OrdSub)
	   ...s XUserid=$p($G(stopOrdInfo),"^",1) 
	   ...q:XUserid=""
	   ...i $P(XSTR,"|",3)="" s nursestop(Oew,OrdSub)=$p($g(^CTPCP(XUserid,1)),"^",2)
       ..s OrdStat(Oew,OrdSub)=OrdStat 
	   ..s OrdDate=$P($G(^OEORD(Oew,"I",OrdSub,1)),"^",9)  ;取得医嘱表医嘱日期时间?加入基础数据表
	   ..s OrdDate=+OrdDate
	   ..s OrdTime(Oew,OrdSub)=$P($G(^OEORD(Oew,"I",OrdSub,1)),"^",10)
	   ..s Seq2=$P($G(^OEORD(Oew,"I",OrdSub,3)),"^",4)  ;relation No
	   ..s SeqNo=$p($g(^OEORD(Oew,"I",OrdSub,11)),"^",39) //qshe add 05-08-22
       ..if SeqNo'="" d
       ...s tmpSeqNo=$P(SeqNo,"||",2) //,val("arcimDesc")="_____"_tmpSeqNo_val("arcimDesc")
       ..e  s tmpSeqNo=OrdSub
       ..s Seq1=tmpSeqNo
	   ..s StDate=$P($G(^OEORD(Oew,"I",OrdSub,1)),"^",9)
	   ..s StTime=$P($G(^OEORD(Oew,"I",OrdSub,1)),"^",10) 
	   ..if StTime=""  s StTime=OrdTime(Oew,OrdSub) 
	   ..s StTime(Oew,OrdSub)=StTime
	   ..s user=$P($G(^OEORD(Oew,"I",OrdSub,7)),"^",1)
	   ..q:user=""
       ..s DoctorDr=$P(^SSU("SSUSR",user),"^",14)
       ..q:DoctorDr=""
	   ..i DoctorDr'=""  s Doctor(Oew,OrdSub)=$P($g(^CTPCP(DoctorDr,1)),"^",2) ;write doctor oeori_doctor_dr
	   ..i DoctorDr'=""  s Doctor(Oew,OrdSub)=$P($g(^CTPCP(DoctorDr,1)),"^",2) ;write doctor oeori_doctor_dr
	   ..e  s Doctor(Oew,OrdSub)=""
	   ..if DoctorDr'="" s CpTypDR=$P(^CTPCP(DoctorDr,1),"^",4)  
	   ..if '$D(^CT("CPT",CpTypDR)) 
	   ..q:'$D(^CT("CPT",CpTypDR))  
	   ..i $G(CpTypDR)'="" s CpTyp=$P(^CT("CPT",CpTypDR),"^",4)  
	   ..q:($G(CpTyp)'="DOCTOR")&($G(^DHCOEOrdPrintSet("ifnur"))'="true")     // &(UsrTyp'="NURSE")ypz 061102////////////2005-12-3 qse add
	   ..s truedoc=0
	   ..if (NurOrd'=0)&(DocOrd=0)&($G(CpTyp)="DOCTOR") q
	   ..if (DocOrd'=0)&(NurOrd=0)&($G(CpTyp)="NURSE") q
	   ..s DocLoc="" //2005-12-3 qse add///////////////////////////////////////
       ..f  s DocLoc=$O(^RB("RES",0,"CTPCP",DoctorDr,DocLoc)) q:DocLoc=""  d
	   ...if $D(^TMP($J,"PatLoc",adm,DocLoc))  s truedoc=1
	   ..q:($G(truedoc)'=1)&(UsrTyp'="NURSE") 
       ..s ExceChl=0 s ExceChl=$O(^OEORD(Oew,"I",OrdSub,"X",ExceChl))
	   ..i ExceChl'=""  d
	   ...s DateEx=$P(^OEORD(Oew,"I",OrdSub,"X",ExceChl),"^",19) i DateEx'="" s DateEx(Oew,OrdSub)=$ZD(DateEx,3)  ;nursing execute
	   ...s TimeEx=$P(^OEORD(Oew,"I",OrdSub,"X",ExceChl),"^",20)  i TimeEx'=""  s TimeEx(Oew,OrdSub)=$ZT(TimeEx,2)
	   ...s CPTExDR=$P(^OEORD(Oew,"I",OrdSub,"X",ExceChl),"^",15)
	   ...i CPTExDR'="" s CPTEx(Oew,OrdSub)=$P($G(^CTPCP(CPTExDR,1)),"^",2)  
	   ...e  s CPTEx=""
	   ..e  s DateEx(Oew,OrdSub)="",TimeEx(Oew,OrdSub)="",CPTEx(Oew,OrdSub)=""
	   ..i OrdStatCode="C" d
	   ...s DateEx(Oew,OrdSub)="",TimeEx(Oew,OrdSub)="",CPTEx(Oew,OrdSub)=""
	   ..s ARCIMRowid=$P(ArcimDR,"||",1)
	   ..s ARCIMSub=$P(ArcimDR,"||",2)  
	   ..s ItemCatDR=$P($G(^ARCIM(ARCIMRowid,ARCIMSub,1)),"^",10) ;oeori_itmmast_dr->arcim_itemcat_dr->arcic_ordcat_dr->orcat_code
	   ..s OrdCatDR=$P(^ARC("IC",ItemCatDR),"^",8)    ;ARc_Itemcat
	   ..s OrdCat=$P(^OEC("ORCAT",OrdCatDR),"^",1)    ;OEC_OrderCategory           ARCIC_OrdCat_DR 
	   ..s OrdCat="^"_OrdCat_"^"
	   ..s OrdCatDR="^"_OrdCatDR_"^"
	   ..s OrdTyp=$P(^ARC("IC",ItemCatDR),"^",7)
	   ..s ARCIMD(Oew,OrdSub)=$P($G(^ARCIM(ARCIMRowid,ARCIMSub,1)),"^",2)  ;ord name
	   ..s dos=$P($G(^OEORD(Oew,"I",OrdSub,2)),"^",1)
	   ..if OrdTyp="R"  s ARCIMD(Oew,OrdSub)=..PhGener(ARCIMRowid,ARCIMSub)
	   ..s ARCIMDesc(Oew,OrdSub)=ARCIMD(Oew,OrdSub)
	   ..//皮试
       ..s skintest="",abnorm=""
   	   ..s skintest=$p($g(^OEORD(Oew,"I",OrdSub,5)),"^",2)
   	   ..if (skintest="Y")&(OrdStatCode'="D") d
   	   ...s skinnote=##class(web.DHCTEMPOERPRINT).skinnote(Oew,OrdSub) //w !,OrdSub
   	   ...s abnorm=$p($g(^OEORD(Oew,"I",OrdSub,11)),"^",3)
       ...if abnorm="Y" s ARCIMDesc(Oew,OrdSub)=ARCIMDesc(Oew,OrdSub)_"(+)"_skinnote  //070815
   	   ...if abnorm="N"  s ARCIMDesc(Oew,OrdSub)=ARCIMDesc(Oew,OrdSub)_"(-)"_skinnote
	   ..if ARCIMDesc(Oew,OrdSub)=""  D
	   ...s ARCIMDesc(Oew,OrdSub)=$P(ARCIMD(Oew,OrdSub),"]",1)
	   ..if SeqNo'="" s ARCIMDesc(Oew,OrdSub)="_____"_ ARCIMDesc(Oew,OrdSub)
	   ..q:$G(^DHCOEOrdPrintSet("NotOrdCat"))[OrdCatDR&($G(^DHCOEOrdPrintSet("NotOrdCat"))'="")
	   ..s ItemCatDRStr="^"_ItemCatDR_"^" 
	   ..q:$G(^DHCOEOrdPrintSet("NotSordCat"))[ItemCatDRStr&($G(^DHCOEOrdPrintSet("NotSordCat"))'="")
       ..s flageCaiLiao=..getFlageCL(ARCIMRowid,ARCIMSub)   //DiTan
       ..q:(flageCaiLiao=1)&(stop=0)
       ..s ORD(OrdDate,OrdTime(Oew,OrdSub),Seq1,Seq2,Oew,OrdSub)=""
	   ..s ORDC(StDate,StTime,Seq1,Seq2,Oew,OrdSub)=""  //s ORDC(StDate,StTime,Seq1,Seq2,Oew,OrdSub)=""   //医务修改用
       ..//w !,OrdCat
       ..s PHFreqDR=$P($G(^OEORD(Oew,"I",OrdSub,2)),"^",4)  ;eat medcine medicine frequency
	   ..i PHFreqDR'="" s PHFreq(Oew,OrdSub)=$P(^PHCFR(PHFreqDR),"^",3) 
	   ..e  s PHFreq=""  ;table       PHC_Freq
	   ..s UOMDR=$P($G(^OEORD(Oew,"I",OrdSub,2)),"^",3) ;CT_UOM                      OEORI_Unit_DR
	   ..i UOMDR'="" s UOM(Oew,OrdSub)=$P(^CT("UOM",UOMDR),"^",2)  
	   ..e  s UOM="" 
	   ..s DoseQty(Oew,OrdSub)=$P($G(^OEORD(Oew,"I",OrdSub,2)),"^",1)   ;numeric  oeori_doseqty,ji Liang
	   ..//点前补零
	   ..if (DoseQty(Oew,OrdSub)'="")&(($P(DoseQty(Oew,OrdSub),"."))="") s DoseQty(Oew,OrdSub)="0"_DoseQty(Oew,OrdSub)
	   ..s PhQtyOrd(Oew,OrdSub)=$P($G(^OEORD(Oew,"I",OrdSub,1)),"^",12)  ;oeori_Phqtyord  shu liang
	   ..s MethDR=$P($G(^OEORD(Oew,"I",OrdSub,2)),"^",7)   ;PHC_Instruc                 OEORI_Instr_DR
	   ..i MethDR'="" s Meth(Oew,OrdSub)=$P(^PHCIN(MethDR),"^",2)  
	   ..e   s Meth(Oew,OrdSub)=""
	   ..S SpeedFlow=""
	   ..S SpeedFlowRate=$P($G(^OEORD(Oew,"I",OrdSub,3)),"^",17)
	   ..s SpeedFlowUnitDr=$P($G(^OEORD(Oew,"I",OrdSub,6)),"^",8)
	   ..i SpeedFlowUnitDr'="" s SpeedFlowUnit=$p($g(^OEC("SFR",SpeedFlowUnitDr)),"^",2)
	   ..I SpeedFlowRate'="",SpeedFlowUnitDr'="" S SpeedFlow=$g(SpeedFlowRate)_" "_$g(SpeedFlowUnit)
	   ..s Meth(Oew,OrdSub)=Meth(Oew,OrdSub)_" "_SpeedFlow
	   ..s DurDR=$P($G(^OEORD(Oew,"I",OrdSub,2)),"^",6)   ;        
	   ..i DurDR'="" s During(Oew,OrdSub)=$P(^PHCDU(DurDR),"^",3)   
	   ..e  s During=""  ;          
	   ..s Notes(Oew,OrdSub)=""
	   ..f rnum=1:1:$G(^OEORD(Oew,"I",OrdSub,"DEP",0))  d
	   ...s Notes(Oew,OrdSub)=Notes(Oew,OrdSub)_$G(^OEORD(Oew,"I",OrdSub,"DEP",rnum))
	   ..s ggg=$F(Notes(Oew,OrdSub),"-")
	   ..if ($G(Notes(Oew,OrdSub))'="")&(ggg'=0) d
	   ...s Notes(Oew,OrdSub)=..note(Oew,OrdSub)
	   ..s PHSPACK=0
	   ..s PadmTyp(Oew,OrdSub)=$P(^PAADM(adm),"^",2)
	   ..s PackNum(Oew,OrdSub)=$P($G(^OEORD(Oew,"I",OrdSub,9)),"^",4)  
	   ..i (^DHCOEOrdPrintSet("OrdCat")[OrdCat)  d
	   ...i PackNum(Oew,OrdSub)=""  s Numeric(Oew,OrdSub)=" "_PhQtyOrd(Oew,OrdSub)
	   ...e  s Numeric(Oew,OrdSub)=" "_PackNum(Oew,OrdSub)
	   ..e  s Numeric(Oew,OrdSub)=""
	   ..i (^DHCOEOrdPrintSet("OrdCat")[OrdCat) d  
	   ...s ARCIMDesc(Oew,OrdSub)=..GetArcim(ARCIMDesc(Oew,OrdSub))
	   ...s DayNum(Oew,OrdSub)="  "  
	   ..e  s DayNum(Oew,OrdSub)=""  
	   ..if (^DHCOEOrdPrintSet("OrdCat")[OrdCat)  d
	   ..e  d
	   ...s flageX=..GetFlage(ARCIMRowid,ARCIMSub)
	   ...s ARCIMDesc(Oew,OrdSub)=ARCIMDesc(Oew,OrdSub)
	   ...e  s ARCIMDesc(Oew,OrdSub)=ARCIMDesc(Oew,OrdSub)
	   ..if PriorDes["自备" s ARCIMDesc(Oew,OrdSub)=ARCIMDesc(Oew,OrdSub)_"  (自备)"
	   ..s ARCIMOrdCat(Oew,OrdSub)=OrdCat
	  
	   s i=0
	   s OrdDate=""  f  s OrdDate=$O(ORD(OrdDate))  q:OrdDate=""  d
	   .s tim="" f  s tim=$O(ORD(OrdDate,tim)) q:tim=""  d
	   ..s Seq1=""  f  s Seq1=$O(ORD(OrdDate,tim,Seq1)) q:Seq1=""  d
	   ...s Seq2=""  f  s Seq2=$O(ORD(OrdDate,tim,Seq1,Seq2))  q:Seq2=""  d
	   ....s rw=""  f  s rw=$O(ORD(OrdDate,tim,Seq1,Seq2,rw)) q:rw=""  d
	   .....s chl=""  f  s chl=$O(ORD(OrdDate,tim,Seq1,Seq2,rw,chl)) q:chl=""  d
	   ......q:$G(ARCIMDesc(rw,chl))=""
	   ......s Arcim="",DateEx="",XDate="",XTime="",TimeEx="",NurseStopDate="",NurseStopTime="",NurseStop="",OrdStat=""
	   ......s Doctor="" 
	   ......s OerdDate=$E($ZD(OrdDate,3),3,10),OerdTime=$ZT(OrdTime(rw,chl),2),Doctor=$G(Doctor(rw,chl)),CPTEx=$G(CPTEx(rw,chl))
	   ......if ^DHCOEOrdPrintSet("OrdCat")'[$G(ARCIMOrdCat(rw,chl))  s Arcim=$G(ARCIMDesc(rw,chl))_" "_$G(PHFreq(rw,chl)) 
	   ......e  s Arcim=$G(ARCIMDesc(rw,chl))_" "_$G(DoseQty(rw,chl))_""_$G(UOM(rw,chl))_" "_$G(Meth(rw,chl))_" "_$G(PHFreq(rw,chl)) 
	   ......s Arcim=Arcim_" "_$g(Notes(rw,chl))
	   ......s DateEx=$G(DateEx(rw,chl)),TimeEx=$G(TimeEx(rw,chl))
	   ......s XDate=$G(XDate(rw,chl)),XTime=$G(XTime(rw,chl)),XCpt=$G(XCpt(rw,chl))
	   ......q:(XCpt'="")&(stop="0") 
	   ......if XDate'="" s XDate=$TR($E(XDate,6,10),"-","/")  
	   ......e  s XDate=""
	   ......s NurseStopDate=$G(nursestopDate(rw,chl)),NurseStopTime=$G(nursestopTime(rw,chl))
	   ......s NurseStop=$G(nursestop(rw,chl)),ORW=rw_"||"_chl,OrdStat=$g(OrdStat(rw,chl))
	   ......if $G(XDate(rw,chl))=""  s XDate(rw,chl)=0
	   ......e  s XDate(rw,chl)=$ZDH($G(XDate(rw,chl)),3)  
	   ......s rwno=rw_"||"_chl
	   ......if $D(^DHCLOGSHORTORD("longord",rwno)) d
	   .......s ExNur=$P(^DHCLOGSHORTORD("longord",rwno),"^",1)
	   .......s StopDateTime=$P(^DHCLOGSHORTORD("longord",rwno),"^",2)
	   .......s StopDoc=$P(^DHCLOGSHORTORD("longord",rwno),"^",3)
	   .......s StopNur=$P(^DHCLOGSHORTORD("longord",rwno),"^",4)
       ......s OrdStat=OrdStat(rw,chl)
	   ......q:(OrdDate<StartDate)!(OrdDate>EndDate)&((StartDate'="")&(EndDate'=""))
	   ......if $D(^DHCLONGSET("audit",Adm,rw_"|"_chl)) d
	   .......s OrdStat=OrdStat_"_"_1
	   ......if (CPTEx="")&(NurseStop'="") s CPTEx=NurseStop
	   ......D OutPut
 	   ......s ArcimDR=$P($G(^OEORD(rw,"I",chl,1)),"^",2)  //DiTan S 某些材料医嘱只显示但医嘱单不打印
	   ......s ARCIMRowid=$P(ArcimDR,"||",1)
	   ......s ARCIMSub=$P(ArcimDR,"||",2)
	   ......s flageCaiLiao=..getFlageCL(ARCIMRowid,ARCIMSub)
       ......q:(flageCaiLiao=1)                           //DiTan E
	   ......s i=i+1
	   ......s ^mtemp($j,"long",Adm,i)=OerdDate_"^"_OerdTime_"^"_Doctor_"^"_CPTEx_"^"_Arcim_"^"_XDate_"^"_XTime_"^"_XCpt_"^"_NurseStop_"^"_OrdStat_"^"_ORW_"^"_$J
	   s Ord=$O(^OEORD(0,"Adm",adm,""))
	   s ^mtemp($j,"long",Adm)=i
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
  //起始日期|<起始时间|<起始医生签字|<起始护士签字|<长期医嘱|<停止日期|<停止时间|<停止医生签字|<停止护士签字"
OutPut
	set Data=$lb(OerdDate,OerdTime,Doctor,CPTEx,Arcim,XDate,XTime,XCpt,NurseStop,OrdStat,ORW,$J,$G(ExNur),$G(StopDateTime),$G(StopDoc),$G(StopNur),PreStopDate,PreStopTime)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod PhGener(ARCIMRowid, ARCIMSub) As %String
{
 //通用名+规格  --->缩写
	 n (ARCIMRowid,ARCIMSub)
	  s PHCGERDR=$P($G(^ARCIM(ARCIMRowid,ARCIMSub,8)),"^",21)
	  i PHCGERDR["-" s PHCGERDR=$p(PHCGERDR,"-",2)
	  //PHCGERDR=$P($G(^ARCIM(ARCIMRowid,ARCIMSub,1)),"^",3)  //
	  s GerName=PHCGERDR
	  s phcdfDr=$p(^ARCIM(ARCIMRowid,ARCIMSub,1),"^",12)
	  s PHMNFDr=$p(^PHCD(+phcdfDr,2),"^",7)
	  s GerName=PHMNFDr_" "_GerName
	  //if PHCGERDR'="" s GerName=$P(^PHCGE("GE",PHCGERDR),"^",2)
	  ////^INCI(0,"ARCIM_DR",$p({INCI_OriginalARCIM_DR},"||",1), {INCI_RowId})
	  //s incDr="" s incDr=$O(^INCI(0,"ARCIM_DR",ARCIMRowid,incDr))
	  //if incDr'="" s Spec=..GetDrugSpec(ARCIMRowid_"||"_ARCIMSub)         //$P(^INCI(incDr,3),"^",9)
	  q $G(GerName)   //_$G(Spec) //"("_$G(Spec)_")"
}

ClassMethod GetItem(i As %String, Adm As %String, strj As %String)
{
	q ^mtemp(strj,"long",Adm,i)
}

ClassMethod GetItemNum(Adm As %String, strj As %String)
{
	q ^mtemp(strj,"long",Adm)
}

ClassMethod GetLongOrdFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetLongOrdExecute ]
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

Query GetLongOrd(Adm As %String, StartDate As %String, EndDate As %String, ChangeDate As %String = "", stop As %String, ssuser = "", Dep = "1", NurOrd = "", DocOrd = 0, SelDocDep As %String = "N", DocDepId = "", SelRecDep As %String = "N", RecDepId = "") As %Query(ROWSPEC = "OerdDate,OerdTime,Doctor,CPTEx,Arcim,XDate,XTime,XCpt,NurseStop,OrdStat,ORW,ProcessNo,ExNur,StopDateTime,StopDoc,StopNur,PreStopDate,PreStopTime")
{
}

ClassMethod GETOID(Oew, OrdSub)
{
	  n (Oew,OrdSub)
	  s oid=$P($G(^OEORD(Oew,"I",OrdSub,9)),"^",12)
	  i oid'="" d
	  .s OPar=$P(oid,"!!",1)
	  .s par=$P(OPar,"||",1)
	  .s chl=$P(OPar,"||",2)
	  .s RowId=par_","_chl
	  q $G(RowId)
}

ClassMethod PRX(Oew, OrdSub)
{
	  n (Oew,OrdSub)
	   s STR=""
	   s chl=""  f  s chl=$O(^OEORD(Oew,"I",OrdSub,"ST",chl)) q:(chl="")!($G(cdoc)'="")  d
	   .s statDR=$P(^OEORD(Oew,"I",OrdSub,"ST",chl),"^",3)
	   .q:statDR'=4
	   .s xdate=$P(^OEORD(Oew,"I",OrdSub, "ST",chl),"^",1)
	   .s xtime=$P(^OEORD(Oew,"I",OrdSub, "ST",chl),"^",2)
	   .s cdoc=$P($g(^OEORD(Oew,"I",OrdSub, "ST",chl)),"^",4)
	   .if (statDR=4)&(cdoc="") s STR=$ZD(xdate,3)_"|"_$ZT(xtime,2)_"|"_""
	   .i (statDR=4)&((cdoc'=""))  s STR=$ZD(xdate,3)_"|"_$ZT(xtime,2)_"|"_$P(^SSU("SSUSR",cdoc),"^",2)
	   s XSDate=$P($G(^OEORD(Oew,"I",OrdSub,3)),"^",34)  ;stop date
	   s XSTime=$P($G(^OEORD(Oew,"I",OrdSub,2)),"^",15)   ;stop time
	   s XSCpt=$P($G(^OEORD(Oew,"I",OrdSub,3)),"^",29)    ;stop doctor
	   if XSCpt'="" d
	   .if XSDate'="" d
	   ..s STR=$ZD(XSDate,3)_"|"_$ZT(XSTime,2)_"|"_$P(^CTPCP(XSCpt,1),"^",2)
	   q $G(STR)
}

ClassMethod SingNur(Oew, OrdSub)
{
	 n (Oew,OrdSub)
	 s oeoriId=Oew_"||"_OrdSub
	 s xOrdExecStr=##Class(web.DHCNurCom).GetXOrdExecInfo(oeoriId)
	 i xOrdExecStr'="" d
	 .s a=xOrdExecStr
	 .s nursestdr=$P(a,"^",1)
	 .i nursestdr'="" s nursestop=$p($g(^CTPCP(nursestdr,1)),"^",2) //ypz 060806 add $g
	 .i $P(a,"^",2)'="" s nursestopDate=$ZD($P(a,"^",2),3)
	 .e  s nursestopDate=""
	 .i $P(a,"^",3)'="" s nursestopTime=$ZT($P(a,"^",3),2)
	 .e  s nursestopTime=""
	 .s nurstr=nursestopDate_"|"_nursestopTime_"|"_$G(nursestop)
	 q $G(nurstr)
}

ClassMethod note(Oew, OrdSub)
{
	   n (Oew,OrdSub)
	   s Notes=""
	   f rnum=2:1:$G(^OEORD(Oew,"I",OrdSub,"DEP",0))  d
	.s Notes=Notes_$G(^OEORD(Oew,"I",OrdSub,"DEP",rnum))
	q $G(Notes)
}

ClassMethod GetPNameRegNo(Adm As %String = "")
{
 //s aa=..try()
 q:Adm="" ""
 q:'$d(^PAADM(Adm)) ""
 s papmidr=$p(^PAADM(Adm),"^",1)
 //s pname=$p(^PAPER(papmidr,"ALL"),"^",1)
 &sql(select papmi_no,papmi_name into :Regno,:pname from pa_patmas where papmi_rowid=:papmidr)
 q pname_"^"_Regno
}

ClassMethod GetArcim(arc)
{
 n (arc)
 //s arc="asdfasdfadf(asdf)(d*sdf)"
 s arc1=$P(arc,"(",1) 
 s arc2=$P(arc,"(",2)
 s arc3=$P(arc,"(",3)
 s arc4=$P(arc,"(",4)
 s arc5=$P(arc,"(",5)
 s arc6=$P(arc,"(",6)
 s a=arc1
 s f1=$F(arc2,"*")
 
 if (f1=0)&(arc2'="") s a=$G(a)_"("_arc2
 s f1=$F(arc3,"*")
 if (f1=0)&(arc3'="") s a=$G(a)_"("_arc3
 s f1=$F(arc4,"*")
 if (f1=0)&(arc4'="") s a=$G(a)_"("_arc4
 s f1=$F(arc5,"*")
 if (f1=0)&(arc5'="") s a=$G(a)_"("_arc5
 s f1=$F(arc6,"*")
 if (f1=0)&(arc6'="") s a=$G(a)_"("_arc6
 
 q a
}

ClassMethod UpateStopDate(Row, StDate, StTime) As %String
{
	///修改长嘱停止时间
	n (Row, StDate, StTime)
	//w !,Row
	s StDate=$ZDH(StDate,3), StTime=$ZTH(StTime)
	s Oew=$P(Row,"||")
	s Sub=$P(Row,"||",2)
	s OrdSub=Sub f  s OrdSub=$O(^OEORD(Oew,"I",OrdSub))  q:OrdSub=""  d
	.s OID=..GETOID(Oew,OrdSub)
	.q:OID=""
	.s OldId=$P(OID,",")_"||"_$P(OID,",",2)
	.q:Row'=OldId
	.s PreOew=Oew,PreSub=OrdSub
	.s ^jj=PreOew_"|"_OrdSub
	if $G(PreOew)'=""
	{
     s RowId=PreOew_"||"_PreSub
	}
	else
	{
	  s RowId=Row
	  s PreOew=$P(Row,"||")
	  s PreSub=$P(Row,"||",2)
	}
    &sql(update oe_orditem set  OEORI_XDate=:StDate,OEORI_XTime=:StTime where OEORI_ROWID=:RowId)
    
    s chl=""  f  s chl=$O(^OEORD(PreOew,"I",PreSub,"ST",chl)) q:(chl="")  d
	.s statDR=$P(^OEORD(PreOew,"I",PreSub,"ST",chl),"^",3)
	.q:statDR'=4
	.s orstatid=PreOew_"||"_PreSub_"||"_chl
	.&sql(update OE_OrdStatus set ST_Date=:StDate,ST_Time=:StTime where ST_RowId=:orstatid)
	.b
  q SQLCODE
}

ClassMethod SaveHBord(oeoriIdStr) As %String
{
	//保存后补不打印医嘱
	s cl=$P(oeoriIdStr,"^",1)
	if cl="Clear"
	{
		s orw=$P($P(oeoriIdStr,"^",2),$C(1),1)
		k ^DHCLONGHBORD(orw)
	}
	q:cl="Clear" 0
	s num=$l(oeoriIdStr,"^")
		s oeoriId=$p(oeoriIdStr,"^",1)
	    s oew=$P(oeoriId,$C(1))
        k ^DHCLONGHBORD(oew)
		f i=1:1:num d
	    .s oeoriId=$p(oeoriIdStr,"^",i)
	    .s oew=$P(oeoriId,$C(1))
	    .s sub=$P(oeoriId,$C(1),2)
	    .s ^DHCLONGHBORD(oew,sub)=""
	 q 0
}

ClassMethod GetOrdChecked(oeord) As %String
{
  n (oeord)
	s orw=$P(oeord,$C(1))
	s sub=$P(oeord,$C(1),2)
	if $D(^DHCLONGHBORD(orw,sub)) s ret=1
	else  s ret=0
	q ret
}

ClassMethod ssusertyp(user) As %String
{
  //用户类型
     q:user="" ""
	 s DoctorDr=$P($g(^SSU("SSUSR",user)),"^",14)
	 q:DoctorDr="" "" ;s Notes=$G(^OEORD(Oew,"I", OrdSub,"DEP",1))

	 q:'$D(^CTPCP(DoctorDr,1)) ""
	 s typdr=$P(^CTPCP(DoctorDr,1),"^",4)
	 s typ=$P(^CT("CPT",typdr),"^",4)
     q typ
}

ClassMethod SaveLongSet(Str)
{
  //医嘱设置longstr+"!"+temstr+"!"+medcat+"!"+NotLoc+"!"+NotOrdCat+"!"+ifstop.checked+"!"+ifnur.checked
   n (Str)
	s longpri=$P(Str,"!",3)
	s TempPri=$P(Str,"!",2)
	s MedCat=$P(Str,"!",1)
	s NotLoc=$P(Str,"!",4)
	s NotOrdCat=$P(Str,"!",5)
	s ifstop=$P(Str,"!",6)
	s ifnur=$P(Str,"!",7)
	s ^DHCLONGSET("longprior")=longpri
	s ^DHCLONGSET("tempprior")=TempPri
	s ^DHCLONGSET("medcat")=MedCat
	S ^DHCOEOrdPrintSet("L","OrdTyp")=..GetPrior()
	S ^DHCOEOrdPrintSet("OrdCat")=..GetMedCat()
	s ^DHCOEOrdPrintSet("OrdTyp")=..GetTempPrior()
	s ^DHCOEOrdPrintSet("NotLoc")=..GetNotLoc(NotLoc)
	s ^DHCOEOrdPrintSet("NotOrdCat")=..GetNotLoc(NotOrdCat)
	s ^DHCOEOrdPrintSet("ifstop")=ifstop
	s ^DHCOEOrdPrintSet("ifnur")=ifnur
	
	q 0
}

ClassMethod GetPreStopDate(Oew, OrdSub) As %String
{
  //取预停日期时间
 	   n (Oew, OrdSub)
 	   s retstr=""
 	   s PreStopDate=$P($G(^OEORD(Oew,"I",OrdSub,9)),"^",9)  ;stop date
	   s PreStopTime=$P($G(^OEORD(Oew,"I",OrdSub,9)),"^",10)   ;stop time
	   if PreStopDate'="" s retstr=PreStopDate_"^"_PreStopTime
	   e  s retstr=""
       q retstr
}

ClassMethod GetSetValue()
{
	q $G(^DHCOEOrdPrintSet("NotLoc"))_"!"_$G(^DHCOEOrdPrintSet("NotOrdCat"))_"!"_$G(^DHCOEOrdPrintSet("ifstop"))_"!"_$G(^DHCOEOrdPrintSet("ifnur"))
}

ClassMethod GetNotLoc(SelStr) As %String
{
   n (SelStr)	
	s num=$L(SelStr,"^")
	f i=1:1:num
	{
		s str=$P(SelStr,"^",i)
		s dr=$P(str,"|",1)
		s redr=$G(redr)_dr_"^"
	}
	q:$G(redr)="" ""
	q "^"_$G(redr)
}

ClassMethod GetLongPriorFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetLongPriorExecute ]
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

ClassMethod GetLongPriorClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetLongPriorExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod GetLongPriorExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	if '$D(^DHCLONGSET("longprior")) Set qHandle=$lb(0,repid,0)	Quit $$$OK
 	s num=$L(^DHCLONGSET("longprior"),"^")    

 	f i=1:1:num
 	{   s prior=$P(^DHCLONGSET("longprior"),"^",i)
	 	s rw=$P(prior,"|")
	 	s desc=$P(prior,"|",2)
	 	Do Outputcat1
	}
 	
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
Outputcat1
	set Data=$lb(rw,desc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

Query GetLongPrior() As %Query(ROWSPEC = "rw,desc")
{
}

ClassMethod GetTempPriorFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetTempPriorExecute ]
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

ClassMethod GetTempPriorClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetTempPriorExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod GetTempPriorExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	if '$D(^DHCLONGSET("tempprior"))   Set qHandle=$lb(0,repid,0)	Quit $$$OK
 	s num=$L(^DHCLONGSET("tempprior"),"^")
 	f i=1:1:num
 	{   s prior=$P(^DHCLONGSET("tempprior"),"^",i)
	 	s rw=$P(prior,"|")
	 	s desc=$P(prior,"|",2)
	 	Do Outputcat
	}
 	
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
Outputcat
	set Data=$lb(rw,desc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

Query GetTempPrior() As %Query(ROWSPEC = "rw,desc")
{
}

ClassMethod GetMedCatFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetMedCatExecute ]
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

ClassMethod GetMedCatClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetMedCatExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod GetMedCatExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
    if '$D(^DHCLONGSET("medcat"))   Set qHandle=$lb(0,repid,0)	Quit $$$OK
 	s num=$L(^DHCLONGSET("medcat"),"^")
 	f i=1:1:num
 	{   s prior=$P(^DHCLONGSET("medcat"),"^",i)
	 	s rw=$P(prior,"|")
	 	s desc=$P(prior,"|",2)
	 	Do Outputcat2
	}
 	
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
Outputcat2
	set Data=$lb(rw,desc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

Query GetMedCat() As %Query(ROWSPEC = "rw,desc")
{
}

ClassMethod tempsaveaudit(adm, str) As %String
{
 //核对医嘱
	n (adm,str)
	//s adm=907
	//s str="713"_$C(1)_"1^713"_$C(1)_"1^713"_$C(1)_"1"
	s ^TT=adm_"_"_str
	S num=$l(str,"^")
	//s ^TT=num
	f i=1:1:num-1
	{ 
		s rr=$P(str,"^",i)
		s rw=$P(rr,"!",1)
		s rwflg=$P(rr,"!",2)
		s exd=$P(rr,"!",3)
		s exnur=$P(rr,"!",4)
		s ext=$P(rr,"!",5)
		s $P(^DHCLOGSHORTORD("lsord",rw),"^",1)=exd
		s $P(^DHCLOGSHORTORD("lsord",rw),"^",2)=ext
		s $P(^DHCLOGSHORTORD("lsord",rw),"^",3)=exnur
		if (rwflg=1)
		{
		s ^DHCLONGSET("audittemp",adm,rw)=""
		}
		else
		{
			k ^DHCLONGSET("audittemp",adm,rw)
		}
	}
	q "OK"
}

ClassMethod saveaudit(adm, str) As %String
{
 //核对医嘱
	n (adm,str)
	//s adm=907
	//s str="713"_$C(1)_"1^713"_$C(1)_"1^713"_$C(1)_"1"
	//s ^TT0=adm_"_"_str
	S num=$l(str,"^")
	f i=1:1:num-1
	{ 
		s rr=$P(str,"^",i)
		s rw=$P(rr,"!",1)
		s rwflg=$P(rr,"!",2)
		s rw=$TR(rw,$C(1),"||")
		s ExNur=$P(rr,"!",3)
		s StopDateTime=$P(rr,"!",4)
		s StopDoc=$P(rr,"!",5)
		s StopNur=$P(rr,"!",6)
		s row=$P(rw,"|")_"||"_$P(rw,"|",2)
		s $P(^DHCLOGSHORTORD("longord",row),"^",1)=ExNur
	    s $P(^DHCLOGSHORTORD("longord",row),"^",2)=StopDateTime
	    s $P(^DHCLOGSHORTORD("longord",row),"^",3)=StopDoc
	    s $P(^DHCLOGSHORTORD("longord",row),"^",4)=StopNur
	    //s ^TMP(9)=rw_"^"_ExNur_"^"_StopDateTime_"^"_StopDoc_"^"_StopNur

		if (rwflg=1)
		{
		s ^DHCLONGSET("audit",adm,rw)=rr
		}
		else
		{
			k ^DHCLONGSET("audit",adm,rw)
		}
	}
	q "OK"
}

ClassMethod clearaudit(adm)
{
	n (adm)
	k ^DHCLONGSET("audit",adm)
	k ^DHCLONGSET("audittemp",adm)
	q 0
}

ClassMethod getdepno1(Adm As %String, OrdDateTim As %String)
{
	n (Adm,OrdDateTim)
	s i=0
	s flag=""
	s tod=(+$H*86400)+$P($H,",",2)
	s OrdDateTim=60935*86400+64674
	d ##CLASS(web.DHCTEMPOERPRINT).GetPatLoc(Adm)
	s no="" f  s no=$O(^TMP($J,"loc",Adm,no)) q:no=""  d
	.s Dep=""  f  s Dep=$O(^TMP($J,"loc",Adm,no,Dep)) q:Dep=""  d
	..s sdt=$P(^TMP($J,"loc",Adm,no,Dep),"^",1),edt=$P(^TMP($J,"loc",Adm,no,Dep),"^",2)
	..if edt*0=0 s edt=tod
	..b
	..s i=i+1
	..if (OrdDateTim>sdt)&(OrdDateTim<edt) s flag=i
   q flag
}

ClassMethod getdepno(Adm As %String, OrdDateTim As %String)
{
	n (Adm,OrdDateTim)
	s i=0
	s flag=""
	s tod=(+$H*86400)+$P($H,",",2)
	//s OrdDateTim=60943*86400+32109
	//d ##CLASS(web.DHCTEMPOERPRINT).GetPatLoc(Adm)
	s no="" f  s no=$O(^TMP($J,"loc",Adm,no)) q:no=""  d
	.s Dep=""  f  s Dep=$O(^TMP($J,"loc",Adm,no,Dep)) q:Dep=""  d
	..s sdt=$P(^TMP($J,"loc",Adm,no,Dep),"^",1),edt=$P(^TMP($J,"loc",Adm,no,Dep),"^",2)
	..if edt*0=0 s edt=tod
	..s i=i+1
	..if (OrdDateTim>sdt)&(OrdDateTim<edt) s flag=i
   q flag
}

ClassMethod GetTranLoc(Adm)
{
 //病人科室
	n (Adm)
	   s LocStr=""
       d ##CLASS(web.DHCTEMPOERPRINT).GetPatLoc(Adm)
	   s AdmLoc=$P(^PAADM(Adm),"^",4)
	   s i=0
	   s no="" f  s no=$O(^TMP($J,"loc",Adm,no)) q:no=""  d
	   .s Dep=""  f  s Dep=$O(^TMP($J,"loc",Adm,no,Dep)) q:Dep=""  d
	   ..s DepDes=$P(^CTLOC(Dep),"^",2)
	   ..s i=i+1
	   ..if AdmLoc=Dep  s LocStr=$G(LocStr)_Dep_"^"_DepDes_"^"_"Y"_"^"_i_"|"
	   ..e  s LocStr=$G(LocStr)_Dep_"^"_DepDes_"^"_"N"_"^"_i_"|"
	 q LocStr
}

ClassMethod ExeLongQuery(Adm, Dep, ssuser) As %String
{
 n (Adm, Dep, ssuser)
 Set rset = ##class(%ResultSet).%New()
 Set rset.ClassName = "web.DHCLONGTIMEORD"
 Set rset.QueryName = "GetLongOrd"
 ;Do rset.Execute(Adm,"","","", "",ssuser, Dep,1,1)
 Do rset.Execute(Adm,"","","", "",ssuser, Dep,0,1)
 q $J
}

ClassMethod ExeTempQuery(Adm, Dep, ssuser) As %String
{
 n (Adm, Dep, ssuser)
 Set rset = ##class(%ResultSet).%New()
 Set rset.ClassName = "web.DHCTEMPOERPRINT"
 Set rset.QueryName = "GetTempOrd"
 ;Do rset.Execute(Adm,"","","", "",ssuser, Dep,1,1)
 Do rset.Execute(Adm,"","","", "",ssuser, Dep,0,1)
 q $j
}

ClassMethod GetDrugSpec(ArcimID As %Library.String = "") As %String
{
  s rtn=""
  q:ArcimID="" rtn
  s inc=$o(^INCI(0,"ARCIM_DR",$p(ArcimID,"||",1),""))
  q:inc="" rtn
  s itminf=""
  s itminf=$o(^DHCITMINFO(0,"INCI",inc,""))
  i itminf'=""  d
  .s rtn=$p($g(^DHCITMINFO(itminf)),"^",27)
  q rtn
}

ClassMethod GetFlage(ARCIMRowid, ARCIMSub) As %String
{
	s flage=0
	s billSubDr=$P($G(^ARCIM(ARCIMRowid,ARCIMSub,1)),"^",9)
	q:billSubDr="" flage
	i (billSubDr="61||2")!(billSubDr="61||3") s flage=1
	//s bgRowId=$P(billSubDr,"||",1)
	//s bgChilSub=$P(billSubDr,"||",1)
	//s sgCode=$P($G(^ARCBG(bgRowId,"SG",bgChilSub)),"^",1)
	//i (sgCode["HHH")!(sgCode["HHH")  s flage=1
	q flage
}

ClassMethod getFlageCL(ARCIMRowid, ARCIMSub)
{
	s flage=0
	s billSubDr=$P($G(^ARCIM(ARCIMRowid,ARCIMSub,1)),"^",9)
	q:billSubDr="" flage
	i billSubDr="61||1" s flage=1
	q flage
}

/// Creator: wangxinlei
/// CreatDate: 2009-09-03
/// Description: 取科室
/// Table：CT_Loc
/// Input：LocDesc: 查询条件
/// Return：CTLocDesc:科室描述, CTLocId:科室的ID
Query LookupCTLoc(LocDesc As %String, Group = "") As %Query(ROWSPEC = "CTLocDesc:%String,CTLocId:%String")
{
}

ClassMethod LookupCTLocExecute(ByRef qHandle As %Binary, LocDesc As %String, Group = "") As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	;s rowid=0
	i $g(LocDesc)'="" s LocDesc=$$ALPHAUP^SSUTIL4(LocDesc)
	s len=$l(LocDesc)
    s CTLocId=0 f  s CTLocId=$o(^CTLOC(CTLocId)) q:CTLocId=""  d
    .q:'$d(^CTLOC(CTLocId))
    .s CTLocDesc=$p(^CTLOC(CTLocId),"^",2)
    .s CTLocGroup=$p(^CTLOC(CTLocId),"^",19)
    .s CTLocCode= $p($g(^CTLOC(CTLocId)),"^",43)
    .q:CTLocGroup'=1
    .;q:(Group'="")&(CTLocGroup'=Group)
    .s tmpLocDesc=$$ALPHAUP^SSUTIL4(CTLocDesc)
    .s tmpLocDesc=$e(tmpLocDesc,1,len)
    .q:(tmpLocDesc'=LocDesc)&&(CTLocCode'[LocDesc) 
 	.Do OutputRow4
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
    
OutputRow4
	set Data=$lb(CTLocDesc,CTLocId)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod LookupCTLocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = LookupCTLocExecute ]
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

ClassMethod LookupCTLocClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = LookupCTLocExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod GETLOCID(locId)
{
 s docLoc=""
 s logonLocType=$p($g(^CTLOC(locId)),"^",13)
 i logonLocType="W" d
 .s chl=0 f  s chl=$O(^CTLOC(locId,"LINK",chl)) q:chl=""  d
 ..s linkLoc=$P(^CTLOC(locId,"LINK",chl),"^",1)
 ..s docLoc=linkLoc
 e  i logonLocType="E" d
 .s docLoc=locId
 q docLoc
}

}
