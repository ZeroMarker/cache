Import SQLUser

/// web.DHCLONGTIMEORD
Class web.DHCLONGTIMEORDCZ Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 33;

ClassMethod GetLongOrdClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetLongOrdExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod GetAdm(RegNo)
{
  	q:RegNo="" ""
  	s nvar=""
	s ln=$L(RegNo)
	s le=9-ln
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
	.
	q $G(nvar)_"^"_$G(AdmStr)
}

ClassMethod GetLongOrdExecute(ByRef qHandle As %Binary, Adm As %String) As %Status
{
   Set repid=$I(^CacheTemp)
   s ind=1
   s i=0
   k ^mtemp($j,"long",Adm)
   q:$G(Adm)="" ""
   s adm=Adm
  // s ^kkk=Adm
  // w !,StartDate_"^"_EndDate
   if $G(adm)="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	   S ^DHCOEOrdPrintSet("L","OrdTyp")="^长期医嘱^自备药-长期医嘱^"
       S ^DHCOEOrdPrintSet("L","OrdCat")="^52^"
       s Oew="" f  s Oew=$O(^OEORD(0,"Adm",adm,Oew)) q:Oew=""  d
	   .s OrdSub=""  f  s OrdSub=$O(^OEORD(Oew,"I",OrdSub))  q:OrdSub=""  d
	   ..s PriorDR=$P($G(^OEORD(Oew,"I",OrdSub,1)),"^",8)     ;OEC_Priority                OEORI_Priority_DR
	   ..i PriorDR'="" s PriorDes=$P(^OECPR(PriorDR),"^",2)  
	   ..e  q     ///PriorDR --10--自备药长期医嘱
	   ..s PriorDes="^"_PriorDes_"^"
	   ..q:^DHCOEOrdPrintSet("L","OrdTyp")'[PriorDes
	   ..s XSTR=..PRX(Oew,OrdSub) ;求医生停止医嘱日期时间
	   ..i XSTR'="" d
	   ...s OID=..GETOID(Oew,OrdSub)
	   ...i OID'="" d 
	   ....s Ow=$P(OID,",",1)
	   ....s cl=$P(OID,",",2)
	   ....i $G(XDate(Ow,cl))="" d
	   .....;w !,$G(XDate(OID)),",",OID
	   .....s XDate(Ow,cl)=$P(XSTR,"|",1),XTime(Ow,cl)=$P(XSTR,"|",2),XCpt(Ow,cl)=$P(XSTR,"|",3)
	   .....//w !,XSTR ,Ow,cl ;;w !,$G(XDate(OID)),",",OID,"ooo" 
	   ....
	   ...
	   ...e  d
	   ....i $G(XDate(Oew,OrdSub))="" d
	   .....s XDate(Oew,OrdSub)=$P(XSTR,"|",1),XTime(Oew,OrdSub)=$P(XSTR,"|",2),XCpt(Oew,OrdSub)=$P(XSTR,"|",3) 
	   ..s XSTR=..SingNur(Oew,OrdSub) ;
	   ..i XSTR'="" d
	   ...s OID=..GETOID(Oew,OrdSub)
	   ...i OID'="" d 
	   ....s Ow=$P(OID,",",1)
	   ....s cl=$P(OID,",",2)
	   ....i $G(nursestopDate(Ow,cl))="" d
	   .....s nursestopDate(Ow,cl)=$P(XSTR,"|",1),nursestopTime(Ow,cl)=$P(XSTR,"|",2),nursestop(Ow,cl)=$P(XSTR,"|",3) 
	   .....//w !,XSTR,"",OID
	   ...e  d
	   ....i $G(nursestopDate(Oew,OrdSub))="" d
	   .....s nursestopDate(Oew,OrdSub)=$P(XSTR,"|",1),nursestopTime(Oew,OrdSub)=$P(XSTR,"|",2),nursestop(Oew,OrdSub)=$P(XSTR,"|",3) 
	   ..s ODate=$P($G(^OEORD(Oew,"I",OrdSub,8)),"^",14) ;长期医嘱开医嘱日期
	   ..q:ODate'=""
	   ..s OrdDate=$P($G(^OEORD(Oew,"I",OrdSub,3)),"^",7)  ;取得医嘱表医嘱日期时间?加入基础数据表
	   ..s OrdDate=+OrdDate
	   ..s OrdTime(Oew,OrdSub)=$P($G(^OEORD(Oew,"I",OrdSub,1)),"^",17)
	   ..s Status=$P($G(^OEORD(Oew,"I",OrdSub,1)),"^",13)  ; OEC_OrderStatus             OEORI_ItemStat_DR 
	   ..q:Status=11
	   ..s Seq2=$P($G(^OEORD(Oew,"I",OrdSub,3)),"^",4)  ;relation No
	   ..s SeqNo=$p($g(^OEORD(Oew,"I",OrdSub,11)),"^",39) //qshe add 05-08-22
       ..if SeqNo'="" d
       ...s tmpSeqNo=$P(SeqNo,"||",2) //,val("arcimDesc")="_____"_tmpSeqNo_val("arcimDesc")
       ..e  s tmpSeqNo=OrdSub
       ..s Seq1=tmpSeqNo
	   ..s ORD(OrdDate,Seq1,Seq2,Oew,OrdSub)=""
	   ..s DoctorDr=$P($G(^OEORD(Oew,"I",OrdSub,1)),"^",11)
	   ..i DoctorDr'=""  s Doctor(Oew,OrdSub)=$P(^CTPCP(DoctorDr,1),"^",3) ;write doctor oeori_doctor_dr
	   ..e  s Doctor(Oew,OrdSub)=""
	   ..if DoctorDr'="" s CpTypDR=$P(^CTPCP(DoctorDr,1),"^",4)  ;CTPCP_CarPrvTp_DR
	   ..i $G(CpTypDR)'="" s CpTyp=$P(^CT("CPT",CpTypDR),"^",4)  ;CT_CarPrvTp
	   ..q:($G(CpTyp)'="DOCTOR")
	   ..s ExceChl=0 s ExceChl=$O(^OEORD(Oew,"I",OrdSub,"X",ExceChl))
	   ..i ExceChl'=""  d
	   ...//w !,ExceChl,",",OrdSub,"}"
	   ...s DateEx=$P(^OEORD(Oew,"I",OrdSub,"X",ExceChl),"^",19) i DateEx'="" s DateEx(Oew,OrdSub)=$ZD(DateEx,3)  ;nursing execute
	   ...s TimeEx=$P(^OEORD(Oew,"I",OrdSub,"X",ExceChl),"^",20)  i TimeEx'=""  s TimeEx(Oew,OrdSub)=$ZT(TimeEx,2)
	   ...s CPTExDR=$P(^OEORD(Oew,"I",OrdSub,"X",ExceChl),"^",15)
	   ...i CPTExDR'="" s CPTEx(Oew,OrdSub)=$P(^CTPCP(CPTExDR,1),"^",3)  
	   ...e  s CPTEx=""
	   ..s ArcimDR=$P($G(^OEORD(Oew,"I",OrdSub,1)),"^",2)
	   ..e  s DateEx(Oew,OrdSub)="",TimeEx(Oew,OrdSub)="",CPTEx(Oew,OrdSub)=""
	   ..s ARCIMRowid=$P(ArcimDR,"||",1)
	   ..s ARCIMSub=$P(ArcimDR,"||",2)  
	   ..s ARCIMDesc(Oew,OrdSub)=$P($G(^ARCIM(ARCIMRowid,ARCIMSub,1)),"^",2)  ;ord name
	   ..if SeqNo'="" s ARCIMDesc(Oew,OrdSub)="_____"_ ARCIMDesc(Oew,OrdSub)
	   ..s ItemCatDR=$P($G(^ARCIM(ARCIMRowid,ARCIMSub,1)),"^",10) ;oeori_itmmast_dr->arcim_itemcat_dr->arcic_ordcat_dr->orcat_code
	   ..s OrdCatDR=$P(^ARC("IC",ItemCatDR),"^",8)    ;ARc_Itemcat
	   ..s OrdCat=$P(^OEC("ORCAT",OrdCatDR),"^",1)    ;OEC_OrderCategory           ARCIC_OrdCat_DR 
	   ..s OrdCat="^"_OrdCat_"^"
       ..s PHFreqDR=$P($G(^OEORD(Oew,"I",OrdSub,2)),"^",4)  ;eat medcine medicine frequency
	   ..i PHFreqDR'="" s PHFreq(Oew,OrdSub)=$P(^PHCFR(PHFreqDR),"^",3) 
	   ..e  s PHFreq=""  ;table       PHC_Freq
	   ..s UOMDR=$P($G(^OEORD(Oew,"I",OrdSub,2)),"^",3) ;CT_UOM                      OEORI_Unit_DR
	   ..i UOMDR'="" s UOM(Oew,OrdSub)=$P(^CT("UOM",UOMDR),"^",2)  
	   ..e  s UOM="" 
	   ..s DoseQty(Oew,OrdSub)=$P($G(^OEORD(Oew,"I",OrdSub,2)),"^",1)   ;numeric  oeori_doseqty,ji Liang
	   ..s PhQtyOrd(Oew,OrdSub)=$P($G(^OEORD(Oew,"I",OrdSub,1)),"^",12)  ;oeori_Phqtyord  shu liang
	   ..s MethDR=$P($G(^OEORD(Oew,"I",OrdSub,2)),"^",7)   ;PHC_Instruc                 OEORI_Instr_DR
	   ..i MethDR'="" s Meth(Oew,OrdSub)=$P(^PHCIN(MethDR),"^",2)  
	   ..e   s Meth(Oew,OrdSub)=""
	   ..s DurDR=$P($G(^OEORD(Oew,"I",OrdSub,2)),"^",6)   ;         OEORI_Durat_DR->phcdu_desc1, PHC_Duration
	   ..i DurDR'="" s During(Oew,OrdSub)=$P(^PHCDU(DurDR),"^",3)   
	   ..e  s During=""  ;           period of treatment
	   ..s Notes(Oew,OrdSub)=""
	   ..f rnum=1:1:$G(^OEORD(Oew,"I",OrdSub,"DEP",0))  d
	   ...s Notes(Oew,OrdSub)=Notes(Oew,OrdSub)_$G(^OEORD(Oew,"I",OrdSub,"DEP",rnum))
	   ..s ggg=$F(Notes(Oew,OrdSub),"-")
	   ..if ($G(Notes(Oew,OrdSub))'="")&(ggg'=0) d
	   ...s Notes(Oew,OrdSub)=..note(Oew,OrdSub)
	   ..s StDate=$P($G(^OEORD(Oew,"I",OrdSub,1)),"^",9)
	   ..s StTime=$P($G(^OEORD(Oew,"I",OrdSub,1)),"^",10)   
	   ..s OrdStatDR=$P($G(^OEORD(Oew,"I",OrdSub,1)),"^",13)  ; OEC_OrderStatus             OEORI_ItemStat_DR 
	   ..i OrdStatDR'="" s OrdStat(Oew,OrdSub)=$P(^OEC("OSTAT",OrdStatDR),"^",2) 
	   ..e  s OrdStat(Oew,OrdSub)=""  ;ord status
	   ..s PadmTyp(Oew,OrdSub)=$P(^PAADM(adm),"^",2)
	   ..s PackNum(Oew,OrdSub)=$P($G(^OEORD(Oew,"I",OrdSub,9)),"^",4)  ;zheng baozhuang shu   OEORI_QtyPackUOM
	   ..i (^DHCOEOrdPrintSet("L","OrdCat")["^"_OrdCat_"^")  d
	   ...i PackNum(Oew,OrdSub)=""  s Numeric(Oew,OrdSub)=" "_PhQtyOrd(Oew,OrdSub)
	   ...e  s Numeric(Oew,OrdSub)=" "_PackNum(Oew,OrdSub)
	   ..e  s Numeric(Oew,OrdSub)=""
	   ..i (^DHCOEOrdPrintSet("L","OrdCat")[OrdCat) d  
	   ...s DayNum(Oew,OrdSub)="  "   ;X"_"";PhQtyOrd(Oew,OrdSub)
	   ..e  s DayNum(Oew,OrdSub)=""  ;$g(During)
	   ..if (^DHCOEOrdPrintSet("L","OrdCat")[OrdCat)  d
	   ..e  s ARCIMDesc(Oew,OrdSub)=ARCIMDesc(Oew,OrdSub)  //_" x"_PhQtyOrd(Oew,OrdSub)
	   ..if PriorDR=10 s ARCIMDesc(Oew,OrdSub)=ARCIMDesc(Oew,OrdSub)_"  (自备)"
	   ;..
	   ;.ORD(OrdDate,seq1,seq2,Oew,OrdSub)
	  // w !,StDate_"^"_EndDate
	   k MList
	   s i=0
	   s OrdDate=""  f  s OrdDate=$O(ORD(OrdDate))  q:OrdDate=""  d
	   .s Seq1=""  f  s Seq1=$O(ORD(OrdDate,Seq1)) q:Seq1=""  d
	   ..s Seq2=""  f  s Seq2=$O(ORD(OrdDate,Seq1,Seq2))  q:Seq2=""  d
	   ...s rw=""  f  s rw=$O(ORD(OrdDate,Seq1,Seq2,rw)) q:rw=""  d
	   ....s chl=""  f  s chl=$O(ORD(OrdDate,Seq1,Seq2,rw,chl)) q:chl=""  d
	   .....q:$G(ARCIMDesc(rw,chl))=""
	   .....s Arcim="",DateEx="",XDate="",XTime="",TimeEx="",NurseStopDate="",NurseStopTime="",NurseStop="" ;i Seq2>0 s ARCIMDesc(rw,chl)="    "_ARCIMDesc(rw,chl)
	   .....s OerdDate=$E($ZD(OrdDate,3),6,10),OerdTime=$ZT(OrdTime(rw,chl),2),Doctor=$G(Doctor(rw,chl)),CPTEx=$G(CPTEx(rw,chl))
	   .....s Arcim=$G(ARCIMDesc(rw,chl))_" "_Notes(rw,chl)_" "_$G(DoseQty(rw,chl))_" "_$G(UOM(rw,chl))_" "_$G(Meth(rw,chl))_" "_$G(PHFreq(rw,chl))_" "_$G(DayNum(rw,chl))_" "_$G(Cancel(rw,chl))
	   .....s DateEx=$G(DateEx(rw,chl)),TimeEx=$G(TimeEx(rw,chl))
	   .....s XDate=$G(XDate(rw,chl)),XTime=$G(XTime(rw,chl)),XCpt=$G(XCpt(rw,chl))
	   .....s XDate=$E(XDate,6,10)
	   .....s NurseStopDate=$G(nursestopDate(rw,chl)),NurseStopTime=$G(nursestopTime(rw,chl))
	   .....s NurseStop=$G(nursestop(rw,chl)),ORW=rw_$C(1)_chl,OrdStat=OrdStat(rw,chl)
	   .....//w !,CPTEx,ORW,"}"
	   .....;w !,StDate_"^"_EndDate
	   .....if $G(XDate(rw,chl))=""  s XDate(rw,chl)=0
	   .....e  s XDate(rw,chl)=$ZDH($G(XDate(rw,chl)),3)
	   .....q:$G(XDate)'="" //s Arcim=$G(Arcim)_" "_"作废"
	   .....//q:(OrdDate<StartDate)!(OrdDate>EndDate)&((StartDate'="")&(EndDate'=""))
	   .....D OutPut
	   .....s i=i+1
	   .....s ^mtemp($j,"long",Adm,i)=OerdDate_"^"_OerdTime_"^"_Doctor_"^"_CPTEx_"^"_Arcim_"^"_XDate_"^"_XTime_"^"_XCpt_"^"_NurseStop_"^"_OrdStat_"^"_ORW
	   ...
	   ..
	   .
	   s ^mtemp($j,"long",Adm)=i
	   s ^TT("sd")=i
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
  //起始日期|<起始时间|<起始医生签字|<起始护士签字|<长期医嘱|<停止日期|<停止时间|<停止医生签字|<停止护士签字"
OutPut
	set Data=$lb(OerdDate,OerdTime,Doctor,CPTEx,Arcim,XDate,XTime,XCpt,NurseStop,OrdStat,ORW)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetItem(i As %String, Adm As %String)
{
	q ^mtemp($j,"long",Adm,i)
}

ClassMethod GetItemNum(Adm As %String)
{
	q ^mtemp($j,"long",Adm)
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

Query GetLongOrd(Adm As %String) As %Query(ROWSPEC = "OerdDate,OerdTime,Doctor,CPTEx,Arcim,XDate,XTime,XCpt,NurseStop,OrdStat,ORW")
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
	  ; ^OEORD({OE_Order.OEORD_RowId},"I",{OE_OrdItem.OEORI_Childsub}, "ST",{ST_Childsub})
	   s STR=""
	   s chl=""  f  s chl=$O(^OEORD(Oew,"I",OrdSub,"ST",chl)) q:chl=""  d
	   .s statDR=$P(^OEORD(Oew,"I",OrdSub,"ST",chl),"^",3)
	   .s xdate=$P(^OEORD(Oew,"I",OrdSub, "ST",chl),"^",1)
	   .s xtime=$P(^OEORD(Oew,"I",OrdSub, "ST",chl),"^",2)
	   .s cdoc=$P(^OEORD(Oew,"I",OrdSub, "ST",chl),"^",4)
	   .if (statDR=4)&(cdoc="") s STR=$ZD(xdate,3)_"|"_$ZT(xtime,2)_"|"_""
	   .i (statDR=4)&((cdoc'=""))  s STR=$ZD(xdate,3)_"|"_$ZT(xtime,2)_"|"_$P(^SSU("SSUSR",cdoc),"^",2)
	   s XSDate=$P($G(^OEORD(Oew,"I",OrdSub,3)),"^",34)  ;stop date
	   s XSTime=$P($G(^OEORD(Oew,"I",OrdSub,2)),"^",15)   ;stop time
	   s XSCpt=$P($G(^OEORD(Oew,"I",OrdSub,3)),"^",29)    ;stop doctor
	   if (XSDate'="")&(XSTime'="")&(XSCpt="")&($G(STR)'="") d
	   if XSCpt'="" s STR=$ZD(XSDate,3)_"|"_$ZT(XSTime,2)_"|"_$P(^CTPCP(XSCpt,1),"^",3)
	   //.if statDR=4 s STR=""_"|"_""_"|"_""  //$P(^CTPCP(CPTExDR,1),"^",3)
	  // s aa=..GETOID(Oew, OrdSub)
	   q $G(STR)
}

ClassMethod SingNur(Oew, OrdSub)
{
	  n (Oew,OrdSub)
	   i $D(^DHCCLNurseExec("DISCON","OrdItem",Oew_"||"_OrdSub))  d
	   .s a=^DHCCLNurseExec("DISCON","OrdItem",Oew_"||"_OrdSub)
	   .s nursestdr=$P(a,"^",3)
	   .i nursestdr'=""  s nursestop=$P(^SSU("SSUSR",nursestdr),"^",2)
	   .s nursestopDate=$ZD($P(a,"^",1),3)                            ;护士停长嘱的日期时间
	   .s nursestopTime=$ZT($P(a,"^",2),2)
	   .s nurstr=nursestopDate_"|"_nursestopTime_"|"_nursestop
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

}
