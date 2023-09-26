Class web.DHCAnOPPrice Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 325;

ClassMethod GetAnOpPriceClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAnOpPriceExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod GetAnOpPriceExecute(ByRef qHandle As %Binary, Adm As %String, Dep As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
    s nvar=""
   // if '$D(^mtemp($J,Dep)) k ^mtemp($J,Dep)
    s adm=Adm
    s i=0
	if $G(adm)="" Set qHandle=$lb(0,repid,0) Quit $$$OK
    S ^DHCOEOrdPrintSet("OrdTyp")="^长期医嘱^自备药-长期医嘱^取药医嘱^"
	S ^DHCOEOrdPrintSet("OrdCat")="^52^"
	//s ^DHCDoctorDep("Dep")="^"_Dep_"^" //214-住院麻醉 //过滤某些科室
	s Oew="" f  s Oew=$O(^OEORD(0,"Adm",adm,Oew)) q:Oew=""  d 
	.s OrdSub=""  f  s OrdSub=$O(^OEORD(Oew,"I",OrdSub))  q:OrdSub=""  d
	..s OrdDate=$P($G(^OEORD(Oew,"I",OrdSub,3)),"^",7)  ;取得医嘱表医嘱日期?
	..s OrdTime=$P($G(^OEORD(Oew,"I",OrdSub,1)),"^",17)
	..s PriorDR=$P($G(^OEORD(Oew,"I",OrdSub,1)),"^",8)     ;OEC_Priority                OEORI_Priority_DR
	..i PriorDR'="" s PriorDes=$P(^OECPR(PriorDR),"^",2)
	..e  q
	..s PriorDes="^"_PriorDes_"^"
	..q:(^DHCOEOrdPrintSet("OrdTyp")[PriorDes)
	..;w !,PriorDR
	..s DoctorDr=$P($G(^OEORD(Oew,"I",OrdSub,1)),"^",11)
	..q:DoctorDr=""  ;s Notes=$G(^OEORD(Oew,"I", OrdSub,"DEP",1))
	..i DoctorDr'=""  s Doctor=$P(^CTPCP(DoctorDr,1),"^",3) ;write doctor oeori_doctor_dr
	..e  s Doctor=""
    ..if DoctorDr'="" s CpTypDR=$P(^CTPCP(DoctorDr,1),"^",4)  ;CTPCP_CarPrvTp_DR
	..i $G(CpTypDR)'="" s CpTyp=$P(^CT("CPT",CpTypDR),"^",4)  ;CT_CarPrvTp
	..//q:($G(CpTyp)'="DOCTOR")
	..//s SchLoc=$$GetDocDep(DoctorDr)
	..s truedoc=0
	..s Loc="" 
	..f  s Loc=$O(^RB("RES",0,"CTPCP",DoctorDr,Loc)) q:Loc=""  d
	...if Dep=Loc  s truedoc=1
	..q:truedoc=0
    ..s sttDate=$p($g(^OEORD(Oew,"I",OrdSub,1)),"^",9)
	..s ArcimDR=$P($G(^OEORD(Oew,"I",OrdSub,1)),"^",2)
	..s UnitPrice=+##CLASS(UDHCJFPRICE).GetOrderPrice("","",ArcimDR,sttDate,"","","","")
	..s ARCIMRowid=$P(ArcimDR,"||",1)
	..s ARCIMSub=$P(ArcimDR,"||",2) 
	..s ARCIMDesc=$P($G(^ARCIM(ARCIMRowid,ARCIMSub,1)),"^",2)  ;ord name             ;by jaslee
	..s pacunit=$P($G(^ARCIM(ARCIMRowid,ARCIMSub,8)),"^",14)
	..if pacunit'="" s pacunit=$P(^CT("UOM",pacunit),"^",2) 
	..s ItemCatDR=$P($G(^ARCIM(ARCIMRowid,ARCIMSub,1)),"^",10) ;oeori_itmmast_dr->arcim_itemcat_dr->arcic_ordcat_dr->orcat_code
	..s OrdCatDR=$P(^ARC("IC",ItemCatDR),"^",8)    ;ARc_Itemcat
	..s OrdCat=$P(^OEC("ORCAT",OrdCatDR),"^",1)    ;OEC_OrderCategory           ARCIC_OrdCat_DR 
	..s OerCat=OrdCat
	..s OrdCat="^"_OrdCat_"^"
	..q:^DHCOEOrdPrintSet("OrdCat")[OrdCat
	..s PHFreqDR=$P($G(^OEORD(Oew,"I",OrdSub,2)),"^",4)  ;eat medcine medicine frequency
	..i PHFreqDR'="" s PHFreq=$P(^PHCFR(PHFreqDR),"^",3) 
	..e  s PHFreq=""  ;table       PHC_Freq
	..s UOMDR=$P($G(^OEORD(Oew,"I",OrdSub,2)),"^",3  ) ;CT_UOM                      OEORI_Unit_DR
	..i UOMDR'="" s UOM=$P(^CT("UOM",UOMDR),"^",2)  
	..e  s UOM="" 
	..s DoseQty=$P($G(^OEORD(Oew,"I",OrdSub,2)),"^",1)   ;numeric  oeori_doseqty,ji Liang
	..s PhQtyOrd=$P($G(^OEORD(Oew,"I",OrdSub,1)),"^",12)  ;oeori_Phqtyord  shu liang
	..s MethDR=$P($G(^OEORD(Oew,"I",OrdSub,2)),"^",7)   ;PHC_Instruc                 OEORI_Instr_DR
	..i MethDR'="" s Meth=$P(^PHCIN(MethDR),"^",2)  
	..e   s Meth=""
	..s DurDR=$P($G(^OEORD(Oew,"I",OrdSub,2)),"^",6)   ;         OEORI_Durat_DR->phcdu_desc1, PHC_Duration
	..i DurDR'="" s During=$P(^PHCDU(DurDR),"^",3)   
	..e  s During=""  ;           period of treatment
	..s StDate=$P($G(^OEORD(Oew,"I",OrdSub,1)),"^",9)
	..s StTime=$P($G(^OEORD(Oew,"I",OrdSub,1)),"^",10) 
	..s OrdStatDR=$P($G(^OEORD(Oew,"I",OrdSub,1)),"^",13)  ; OEC_OrderStatus             OEORI_ItemStat_DR 
	..i OrdStatDR'="" s OrdStat=$P(^OEC("OSTAT",OrdStatDR),"^",2) 
	..e  s OrdStat=""  ;ord status
	..q:OrdStatDR=11
	..s Seq2=$P($G(^OEORD(Oew,"I",OrdSub,3)),"^",4)  ;relation No
	..s SeqNo=$p($g(^OEORD(Oew,"I",OrdSub,11)),"^",39) //qshe add 05-08-22
    ..if SeqNo'="" d
    ...s tmpSeqNo=$P(SeqNo,"||",2) ,ARCIMDesc="_____"_ARCIMDesc
    ..e  s tmpSeqNo=OrdSub
    ..s Seq1=tmpSeqNo
	..s PadmTyp=$P(^PAADM(adm),"^",2)
	..s PackNum=$P($G(^OEORD(Oew,"I",OrdSub,9)),"^",4)  ;zheng baozhuang shu   OEORI_QtyPackUOM
	..s pacunit=$P($G(^ARCIM(ARCIMRowid,ARCIMSub,8)),"^",14)
	..if pacunit'="" s pacunit=$P(^CT("UOM",pacunit),"^",2) 
	..i ^DHCOEOrdPrintSet("OrdCat")[OrdCat d
	...i PackNum=""  s Numeric=PhQtyOrd
	...e  s Numeric=PackNum
	..e  s Numeric=""
	..i ^DHCOEOrdPrintSet("OrdCat")[OrdCat d  
	...s DayNum=$G(PhQtyOrd)
	...//s pacunit="",UOM=""
	..e  s DayNum=$g(During)
	..i ^DHCOEOrdPrintSet("OrdCat")[OrdCat s DayNum=$G(PhQtyOrd)  ;除药品外其余的数量都为空
	..e  s DayNum=""
	..i OrdStat="停止" s Cancel="作废" ;Doctor
	..e  s Cancel=""
	..q:OrdStat="停止"
	..s i=i+1
	..if SeqNo'=""  s ARCIMDesc="   "_ARCIMDesc
	..if ^DHCOEOrdPrintSet("OrdCat")[OrdCat d
	...//s TotalNumeric=$$GetNum(Oew,OrdSub)
	...s par=Oew_"||"_OrdSub
	...&sql(select sum(OEORE_PhQtyIss) into :TotalNumeric from SQLUSER.OE_OrdExec where oeore_oeori_parref=:par)
	...if TotalNumeric'="" s TotalPrice=TotalNumeric*UnitPrice
	...e  s TotalPrice=PhQtyOrd*UnitPrice
	..e   s TotalPrice=PhQtyOrd*UnitPrice  //_"  x"_$G(PhQtyOrd)
	..s ARCIMDesc=ARCIMDesc //_"__"_Cancel
	..s ArcTolPrice(ArcimDR,i)=TotalPrice
	..i $G(PackNum)="" d
	...s ArcName(ArcimDR)=ARCIMDesc
	...s ArcUPrice(ArcimDR)=UnitPrice
	...s ArcCat(ArcimDR)=OerCat
	...s ArcItem(ArcimDR)=ItemCatDR
	...s ArcNum(ArcimDR,i)=$G(PhQtyOrd)
	...s ArcUom(ArcimDR)=UOM
	..e   d
	...s ArcName(ArcimDR)=ARCIMDesc
	...s ArcCat(ArcimDR)=OerCat
	...s ArcItem(ArcimDR)=ItemCatDR
	...s ArcUPrice(ArcimDR)=TotalPrice/PackNum
	...s ArcNum(ArcimDR,i)=PackNum
	...s ArcUom(ArcimDR)=pacunit
	
	s arc=""  f  s arc=$O(ArcNum(arc)) q:arc=""  d
	.s i=""  f  s i=$O(ArcNum(arc,i)) q:i=""  d
	..s ArcNum(arc)=$G(ArcNum(arc))+ArcNum(arc,i)
	..s ArcTolPrice(arc)=$G(ArcTolPrice(arc))+ArcTolPrice(arc,i)
	..s ArcTolPrice=$G(ArcTolPrice)+ArcTolPrice(arc)
	if (Dep'="214")  //211-住院手术，212，－第二手术室
	{  
	   b
	    s OPFEI=0,CAIL=0 //33手术类   504 加收
    	s arc=""  f  s arc=$O(ArcNum(arc)) q:arc=""  d
    	.if (ArcCat(arc)="33")&(ArcItem(arc)'="504") d
    	..s OPFEI=OPFEI+ArcTolPrice(arc),Arcim=ArcName(arc)
    	.e  s CAIL=CAIL+ArcTolPrice(arc)
		s Typ="33"
	s ^mtemp($j,"OPFEI")=$G(OPFEI)_"^"_$G(CAIL)_"^"_$G(Arcim)
	}
	if (Dep="214") //麻醉 帐单子类 麻醉费38||1,,治疗费34||19材料费34||8,氧气费34||7
	{   s ANFEI=0,CANFEI=0
    	s arc=""  f  s arc=$O(ArcNum(arc)) q:arc=""  d
	    .s ARCIMRowid=$P(arc,"||",1)
	    .s ARCIMSub=$P(arc,"||",2) 
	    .s billsub=$P($G(^ARCIM(ARCIMRowid,ARCIMSub,1)),"^",9)  ;ord name             ;by jaslee
    	.if billsub="38||1" s mzfei=$G(mzfei)+ArcTolPrice(arc)
    	.if billsub="34||8" s clfei=$G(clfei)+ArcTolPrice(arc)
    	.if billsub="34||19" s zhlfei=$G(zhlfei)+ArcTolPrice(arc)
    	.if billsub="34||7" s yqfei=$G(yqfei)+ArcTolPrice(arc)
    	.s ANFEI=ANFEI+ArcTolPrice(arc)
    	.;if (ArcCat(arc)="32")&(ArcName(arc)["以上") d
    	.;.s CANFEI=CANFEI+ArcTolPrice(arc)
    s ^mtemp($J,"OPFEI")=$G(ANFEI)_"^"_$G(mzfei)_"^"_$G(clfei)_"^"_$G(zhlfei)_"^"_$G(yqfei)
    s Typ=" "	
	}
	
	s j=0
	s arc=""  f  s arc=$O(ArcNum(arc)) q:arc=""  d
	.q:(ArcCat(arc)=Typ)
	.D OutPut
    .s j=j+1
    .s ^mtemp($J,Dep,j)=ArcName(arc)_"^"_ArcNum(arc)_""_ArcUom(arc)_"^"_ArcUPrice(arc)_"^"_ArcTolPrice(arc)_"^"_ArcCat(arc)
    s ^mtemp($J,Dep)=j
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
 //"起始日期|<起始时间|<临时医嘱|<医生签字|<执行时间|<执行人"/
OutPut
	set Data=$lb(ArcName(arc),ArcNum(arc)_""_ArcUom(arc),ArcUPrice(arc),ArcTolPrice(arc),ArcCat(arc))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
GetDocDep(Doc)
  {
  n 
 //^RB("RES",0,"CTPCP",{RES_CTPCP_DR},{RES_CTLOC_DR},{RES_RowId}) 
  s Loc="" f  s Loc=$O(^RB("RES",0,"CTPCP",Doc,Loc)) q:Loc=""  d
  .s sr=$G(sr)_"^"_$G(Loc)_"^"
  Q sr
 }
GetNum(Oew,OrdSub)
 { 
   // n
    s par=Oew_"||"_OrdSub
   &sql(select sum(OEORE_PhQtyIss) into :num from SQLUSER.OE_OrdExec where oeore_oeori_parref=:par)
	 //s cl="" f  s cl=$O(^OEORD(Oew,"I",OrdSub,"X",cl))  q:(cl="")!($G(num)'="")  d
	//.s num=$P(^OEORD(Oew,"I",OrdSub,"X",cl),"^",3)
	//w !,num
	q $G(num)
}
}

ClassMethod GetAnOpFei()
{
	q $G(^mtemp($j,"OPFEI"))
}

ClassMethod GetAnOpPriceFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAnOpPriceExecute ]
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

Query GetAnOpPrice(Adm As %String, Dep As %String) As %Query(ROWSPEC = "Arcim,Num,Price,TotalPrice,Cat")
{
}

ClassMethod GetOrditemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetOrditemExecute ]
{
   
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod GetOrditemExecute(ByRef qHandle As %Binary, ward As %String) As %Status
{
	  Set repid=$I(^CacheTemp)
 	  s ind=1
      s i=0
 	  if $G(ward)="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	    s paroom=0 f  s paroom=$o(^PAADMi("CurrWard",ward,paroom)) q:paroom=""  d
        .s admId=0 f  s admId=$o(^PAADMi("CurrWard",ward,paroom,admId)) q:admId=""  d
        ..s pavisit=$p($g(^PAADM(admId)),"^",20)
        ..i pavisit="D" q
        ..s admno=$p($g(^PAADM(admId)),"^",81)
        ..s papmiId=$p($g(^PAADM(admId)),"^",1)
        ..s RegNo=$p($g(^PAPER(papmiId,"PAT",1)),"^",1)
        ..s PatName=$p($g(^PAPER(papmiId,"ALL")),"^",1)
        ..s sex=$p($g(^CT("SEX",$p($g(^PAPER(papmiId,"ALL")),"^",7))),"^",2)
        ..s bedSub=$p($p($g(^PAADM(admId)),"^",73),"||",2)
        ..q:bedSub=""
        ..s BedCode=$p($g(^PAWARD(ward,"BED",bedSub)),"^",1)
        ..s room=$P(^PAROOM(paroom),"^",2)
        ..s BedCode=room_BedCode
        ..q:BedCode="" ;防止床位有变化
       	..s Oew="" f  s Oew=$O(^OEORD(0,"Adm",admId,Oew)) q:Oew=""  d 
	    ...s OrdSub=""  f  s OrdSub=$O(^OEORD(Oew,"I",OrdSub))  q:OrdSub=""  d
	    ....s OrdDate=$P($G(^OEORD(Oew,"I",OrdSub,3)),"^",7)  ;取得医嘱表医嘱日期?
	    ....s OrdTime=$P($G(^OEORD(Oew,"I",OrdSub,1)),"^",17)
	    ....s phcinId=$p($g(^OEORD(Oew,"I",OrdSub,2)),"^",7)
	    ....q:phcinId=""
	    ....s skintest=$p($g(^OEORD(Oew,"I",OrdSub,5)),"^",2)
        ....//if ((skintest="Y")) s val("phcinDesc")=val("phcinDesc")_"(皮试)"
        ....s phcindes=$p($g(^PHCIN(phcinId)),"^",2)
        ....s b=$F(phcindes,"皮试")
	    ....s Note=$g(^OEORD(Oew,"I",OrdSub,"DEP",1))_" "_$g(^OEORD(Oew,"I",OrdSub,"DEP",2))_$g(^OEORD(Oew,"I",OrdSub,"DEP",3))_$g(^OEORD(Oew,"I",OrdSub,"DEP",4))                      ;xuqy 04/08/04
	    ....s a=$F(Note,"皮试")
	    ....//q:(a=0)&(b=0)
	    ....q:skintest'="Y"
	    ....s ArcimDR=$P($G(^OEORD(Oew,"I",OrdSub,1)),"^",2)
    	....s ARCIMRowid=$P(ArcimDR,"||",1)
	    ....s ARCIMSub=$P(ArcimDR,"||",2) 
	    ....s Arcim=$P($G(^ARCIM(ARCIMRowid,ARCIMSub,1)),"^",2)  ;or
	    ....s DDate=$ZD(OrdDate,3)_" "_$ZT(OrdTime)
	    ....s OrdId=Oew_"||"_OrdSub
	    ....d Out
	    ....//w !,BedCode,PatName,RegNo,Arcim,Note,DDate,OrdId
	    ...
	    ..
	    .
	    Set qHandle=$lb(0,repid,0)
	    Quit $$$OK		     
	       
Out
	set Data=$lb(BedCode,PatName,RegNo,Arcim,Note,DDate,OrdId)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1 	
	quit
}

ClassMethod GetOrditemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetOrditemExecute ]
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

Query GetOrditem(Ward As %String) As %Query(ROWSPEC = "BedCode,PatName,RegNo,Arcim,Note,DDate,OrdId")
{
}

Query GetOpPrice(Adm As %String, Dep As %String) As %Query(ROWSPEC = "Arcim,Num,Price,TotalPrice,Cat")
{
}

ClassMethod GetOpPriceFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetOpPriceExecute ]
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

ClassMethod GetOpPriceClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetOpPriceExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod GetOpPriceExecute(ByRef qHandle As %Binary, Adm As %String, Dep As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
    s nvar=""
    //s Dep=%session.Data("LOGON.CTLOCID")
   // if '$D(^mtemp($J,Dep)) k ^mtemp($J,Dep)
   s ^TT(89)=Adm
  // if Adm="" Set Adm=%request.Get("Adm")
   	s ^ypzTmp(31)=$g(Arcim)_","_$g(Num)_","_$g(Price)_","_$g(TotalPrice)_","_$g(Cat)
    s adm=Adm
    s i=0
	if $G(adm)="" Set qHandle=$lb(0,repid,0) Quit $$$OK
    //S ^DHCOEOrdPrintSet("OrdTyp")="^长期医嘱^自备药-长期医嘱^取药医嘱^"
	//S ^DHCOEOrdPrintSet("OrdCat")="^52^"
	//s ^DHCDoctorDep("Dep")="^"_Dep_"^" //214-住院麻醉 //过滤某些科室
	s Oew="" f  s Oew=$O(^OEORD(0,"Adm",adm,Oew)) q:Oew=""  d 
	.s OrdSub=""  f  s OrdSub=$O(^OEORD(Oew,"I",OrdSub))  q:OrdSub=""  d
	..s OrdDate=$P($G(^OEORD(Oew,"I",OrdSub,3)),"^",7)  ;取得医嘱表医嘱日期?
	..s OrdTime=$P($G(^OEORD(Oew,"I",OrdSub,1)),"^",17)
	..s PriorDR=$P($G(^OEORD(Oew,"I",OrdSub,1)),"^",8)     ;OEC_Priority                OEORI_Priority_DR
	..i PriorDR'="" s PriorDes=$P(^OECPR(PriorDR),"^",2)
	..e  q
	..s PriorDes="^"_PriorDes_"^"
	..q:(^DHCOEOrdPrintSet("OrdTyp")'[PriorDes)
	..//w !,^DHCOEOrdPrintSet("OrdTyp")
	..s DoctorDr=$P($G(^OEORD(Oew,"I",OrdSub,1)),"^",11)
	..s user=$P($G(^OEORD(Oew,"I",OrdSub,7)),"^",1)
	..q:user=""
	..q:'$D(^SSU("SSUSR",user))
	..s DoctorDr=$P(^SSU("SSUSR",user),"^",14)
	..q:DoctorDr=""  ;s Notes=$G(^OEORD(Oew,"I", OrdSub,"DEP",1))
	..//q:DoctorDr=""  ;s Notes=$G(^OEORD(Oew,"I", OrdSub,"DEP",1))
	..i DoctorDr'=""  s Doctor=$P(^CTPCP(DoctorDr,1),"^",3) ;write doctor oeori_doctor_dr
	..e  s Doctor=""
    ..if DoctorDr'="" s CpTypDR=$P(^CTPCP(DoctorDr,1),"^",4)  ;CTPCP_CarPrvTp_DR
	..i $G(CpTypDR)'="" s CpTyp=$P(^CT("CPT",CpTypDR),"^",4)  ;CT_CarPrvTp
	..//q:($G(CpTyp)'="DOCTOR")
	..//s SchLoc=$$GetDocDep(DoctorDr)
	..s truedoc=0
	..s Loc="" 
	..f  s Loc=$O(^RB("RES",0,"CTPCP",DoctorDr,Loc)) q:Loc=""  d
	...//w !,Loc
	...if Dep=Loc  s truedoc=1
	..q:truedoc=0
    ..s sttDate=$p($g(^OEORD(Oew,"I",OrdSub,1)),"^",9)
	..s ArcimDR=$P($G(^OEORD(Oew,"I",OrdSub,1)),"^",2)
	..s UnitPrice=+##CLASS(UDHCJFPRICE).GetOrderPrice("","",ArcimDR,sttDate,"","","","")
	..s ARCIMRowid=$P(ArcimDR,"||",1)
	..s ARCIMSub=$P(ArcimDR,"||",2) 
	..s OrdStatDR=$P($G(^OEORD(Oew,"I",OrdSub,1)),"^",13)  ; OEC_OrderStatus             OEORI_ItemStat_DR 
	..i OrdStatDR'="" s OrdStat=$P(^OEC("OSTAT",OrdStatDR),"^",2) 
	..e  s OrdStat=""  ;ord status
	..q:OrdStatDR=11
	..i OrdStat="停止" s Cancel="作废" ;Doctor
	..e  s Cancel=""
	..q:OrdStat="停止"
	..s ARCIMDesc=$P($G(^ARCIM(ARCIMRowid,ARCIMSub,1)),"^",2)  ;ord name             ;by jaslee
	..if (UnitPrice=0) d
	...s ARCPRICE(Oew,OrdSub)=ArcimDR_"^"_ARCIMDesc // s UnitPrice=$P(^OEORD(Oew,"I",OrdSub,1),"^",9)  //w !,UnitPrice,"  ",ArcimDR
	..q:UnitPrice=0
	..s pacunit=$P($G(^ARCIM(ARCIMRowid,ARCIMSub,8)),"^",14)
	..if pacunit'="" s pacunit=$P(^CT("UOM",pacunit),"^",2) 
	..s ItemCatDR=$P($G(^ARCIM(ARCIMRowid,ARCIMSub,1)),"^",10) ;oeori_itmmast_dr->arcim_itemcat_dr->arcic_ordcat_dr->orcat_code
	..s OrdCatDR=$P(^ARC("IC",ItemCatDR),"^",8)    ;ARc_Itemcat
	..s OrdCat=$P(^OEC("ORCAT",OrdCatDR),"^",1)    ;OEC_OrderCategory           ARCIC_OrdCat_DR 
	..s OerCat=OrdCat
	..s OrdCat="^"_OrdCat_"^"
	..//q:^DHCOEOrdPrintSet("OrdCat")[OrdCat
	..s PHFreqDR=$P($G(^OEORD(Oew,"I",OrdSub,2)),"^",4)  ;eat medcine medicine frequency
	..i PHFreqDR'="" s PHFreq=$P(^PHCFR(PHFreqDR),"^",3) 
	..e  s PHFreq=""  ;table       PHC_Freq
	..s UOMDR=$P($G(^OEORD(Oew,"I",OrdSub,2)),"^",3  ) ;CT_UOM                      OEORI_Unit_DR
	..i UOMDR'="" s UOM=$P(^CT("UOM",UOMDR),"^",2)  
	..e  s UOM="" 
	..s DoseQty=$P($G(^OEORD(Oew,"I",OrdSub,2)),"^",1)   ;numeric  oeori_doseqty,ji Liang
	..s PhQtyOrd=$P($G(^OEORD(Oew,"I",OrdSub,1)),"^",12)  ;oeori_Phqtyord  shu liang
	..s MethDR=$P($G(^OEORD(Oew,"I",OrdSub,2)),"^",7)   ;PHC_Instruc                 OEORI_Instr_DR
	..i MethDR'="" s Meth=$P(^PHCIN(MethDR),"^",2)  
	..e   s Meth=""
	..s DurDR=$P($G(^OEORD(Oew,"I",OrdSub,2)),"^",6)   ;         OEORI_Durat_DR->phcdu_desc1, PHC_Duration
	..i DurDR'="" s During=$P(^PHCDU(DurDR),"^",3)   
	..e  s During=""  ;           period of treatment
	..s StDate=$P($G(^OEORD(Oew,"I",OrdSub,1)),"^",9)
	..s StTime=$P($G(^OEORD(Oew,"I",OrdSub,1)),"^",10) 
	..s Seq2=$P($G(^OEORD(Oew,"I",OrdSub,3)),"^",4)  ;relation No
	..s SeqNo=$p($g(^OEORD(Oew,"I",OrdSub,11)),"^",39) //qshe add 05-08-22
    ..if SeqNo'="" d
    ...s tmpSeqNo=$P(SeqNo,"||",2) ,ARCIMDesc="_____"_ARCIMDesc
    ..e  s tmpSeqNo=OrdSub
    ..s Seq1=tmpSeqNo
	..s PadmTyp=$P(^PAADM(adm),"^",2)
	..s PackNum=$P($G(^OEORD(Oew,"I",OrdSub,9)),"^",4)  ;zheng baozhuang shu   OEORI_QtyPackUOM
	..s pacunit=$P($G(^ARCIM(ARCIMRowid,ARCIMSub,8)),"^",14)
	..if pacunit'="" s pacunit=$P(^CT("UOM",pacunit),"^",2) 
	..i ^DHCOEOrdPrintSet("OrdCat")[OrdCat d
	...i PackNum=""  s Numeric=PhQtyOrd
	...e  s Numeric=PackNum
	..e  s Numeric=""
	..i ^DHCOEOrdPrintSet("OrdCat")[OrdCat d  
	...s DayNum=$G(PhQtyOrd)
	...//s pacunit="",UOM=""
	..e  s DayNum=$g(During)
	..i ^DHCOEOrdPrintSet("OrdCat")[OrdCat s DayNum=$G(PhQtyOrd)  ;除药品外其余的数量都为空
	..e  s DayNum=""
	..s i=i+1
	..if SeqNo'=""  s ARCIMDesc="   "_ARCIMDesc
	..if ^DHCOEOrdPrintSet("OrdCat")[OrdCat d
	...//s TotalNumeric=$$GetNum(Oew,OrdSub)
	...s par=Oew_"||"_OrdSub
	...&sql(select sum(OEORE_PhQtyIss) into :TotalNumeric from SQLUSER.OE_OrdExec where oeore_oeori_parref=:par)
	...if (TotalNumeric'="") s TotalPrice=TotalNumeric*UnitPrice
	...e  s TotalPrice=PhQtyOrd*UnitPrice
	..e  d
	...s TotalPrice=PhQtyOrd*UnitPrice  //_"  x"_$G(PhQtyOrd)
	..s ARCIMDesc=ARCIMDesc //_"__"_Cancel
	..s ArcTolPrice(ArcimDR,i)=TotalPrice
	..i $G(PackNum)="" d
	...s ArcName(ArcimDR)=ARCIMDesc
	...s ArcUPrice(ArcimDR)=UnitPrice
	...s ArcCat(ArcimDR)=OerCat
	...s ArcItem(ArcimDR)=ItemCatDR
	...s ArcNum(ArcimDR,i)=$G(PhQtyOrd)
	...s ArcUom(ArcimDR)=UOM
	...//w !,ARCIMDesc_"!"_ArcNum(ArcimDR,i)
	..e   d
	...s ArcName(ArcimDR)=ARCIMDesc
	...s ArcCat(ArcimDR)=OerCat
	...s ArcItem(ArcimDR)=ItemCatDR
	...s ArcUPrice(ArcimDR)=TotalPrice/PackNum
	...s ArcNum(ArcimDR,i)=PackNum
	...s ArcUom(ArcimDR)=pacunit
	s n=1
	s rw=""  f  s rw=$O(ARCPRICE(rw)) q:rw=""  d
	.s chl=""  f  s chl=$O(ARCPRICE(rw,chl)) q:chl=""  d
	..s ArcimDR=$P(ARCPRICE(rw,chl),"^",1)
	..s ArcPrice=$P(^OEORD(rw,"I",chl,3),"^",25)
	..s ARCIMDesc=$P(ARCPRICE(rw,chl),"^",2)
	..s ArcName(ArcimDR)=ARCIMDesc
	..s ArcUPrice(ArcimDR)=0
	..s ArcTolPrice(ArcimDR,n)=ArcPrice
	..s ArcCat(ArcimDR)=""
    ..s ArcItem(ArcimDR)=""
	..s ArcNum(ArcimDR,n)=""
	..s ArcUom(ArcimDR)=""
	..s n=n+1
	.
	k ^mtemp($J,"OPFEI")
	s arc=""  f  s arc=$O(ArcNum(arc)) q:arc=""  d
	.s i=""  f  s i=$O(ArcNum(arc,i)) q:i=""  d
	..s ArcNum(arc)=$G(ArcNum(arc))+ArcNum(arc,i)
	..//w !,ArcName(arc)_"^"_ArcTolPrice(arc,i)
	..s ArcTolPrice(arc)=$G(ArcTolPrice(arc))+ArcTolPrice(arc,i)
	.s ArcTolPrice=$G(ArcTolPrice)+ArcTolPrice(arc)
	.//w !,ArcTolPrice(arc)
	s ^mtemp($j,"OPFEI")=$G(ArcTolPrice)_"^"_$G(CAIL)_"^"_$G(Arcim)
	
	s j=0
	s arc=""  f  s arc=$O(ArcNum(arc)) q:arc=""  d
	.//q:(ArcCat(arc)=Typ)
	.D OutPut1
    .s j=j+1
    .s ^mtemp($J,Dep,j)=ArcName(arc)_"^"_ArcNum(arc)_""_ArcUom(arc)_"^"_ArcUPrice(arc)_"^"_ArcTolPrice(arc)_"^"_ArcCat(arc)
    s ^mtemp($J,Dep)=j
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
 //"起始日期|<起始时间|<临时医嘱|<医生签字|<执行时间|<执行人"/
OutPut1
	set Data=$lb(ArcName(arc),ArcNum(arc)_""_ArcUom(arc),ArcUPrice(arc),ArcTolPrice(arc),ArcCat(arc))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
GetDocDep1(Doc)
  {
  n 
 //^RB("RES",0,"CTPCP",{RES_CTPCP_DR},{RES_CTLOC_DR},{RES_RowId}) 
  s Loc="" f  s Loc=$O(^RB("RES",0,"CTPCP",Doc,Loc)) q:Loc=""  d
  .s sr=$G(sr)_"^"_$G(Loc)_"^"
  Q sr
 }
GetNum1(Oew,OrdSub)
 { 
   // n
    s par=Oew_"||"_OrdSub
   &sql(select sum(OEORE_PhQtyIss) into :num from SQLUSER.OE_OrdExec where oeore_oeori_parref=:par)
	 //s cl="" f  s cl=$O(^OEORD(Oew,"I",OrdSub,"X",cl))  q:(cl="")!($G(num)'="")  d
	//.s num=$P(^OEORD(Oew,"I",OrdSub,"X",cl),"^",3)
	//w !,num
	q $G(num)
}
}

}
