Class web.DHCPdaTempOrd Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

ClassMethod GetOrdRadiaExecute(ByRef qHandle As %Binary, Parr As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
    s nvar=""
    //Adm As %String, StartDate As %String, EndDate As %String, longtyp As %String, tempTyp As %String
     s adm=$P(Parr,"^",1)
	 s StartDate=$P(Parr,"^",2)
	 s EndDate=$P(Parr,"^",3)
	 s longtyp=$P(Parr,"^",4)
	 s tempTyp=$P(Parr,"^",5)
	 s Instru=$P(Parr,"^",6)
	if $G(adm)="" Set qHandle=$lb(0,repid,0) Quit $$$OK
    s Oew=""  s Oew=$O(^OEORD(0,"Adm",adm,Oew)) 
    if StartDate="" s StartDate=+$H
    if EndDate=""  s EndDate=+$H
    if StartDate'="" s StartDate=$ZDH(StartDate,3)
    if EndDate'="" s EndDate=$ZDH(EndDate,3)
    f date=StartDate:1:EndDate 
    { 
	    s OrdSub=""  f  s OrdSub=$O(^OEORDi(0,"StDt",date,Oew,OrdSub)) q:OrdSub=""  d
    	.s PriorDR=$P($G(^OEORD(Oew,"I",OrdSub,1)),"^",8)     ;OEC_Priority                OEORI_Priority_DR
	    .i PriorDR="" q //ypz
	   	.s OrdDate=$P($G(^OEORD(Oew,"I",OrdSub,1)),"^",9)
	    .s OrdTime=$P($G(^OEORD(Oew,"I",OrdSub,1)),"^",10)
	    .if OrdTime="" s OrdTime=$P($H,",",2)
        .s PriorDes=$P($G(^OECPR(PriorDR)),"^",2)
	    .s oecprCode=$P($G(^OECPR(PriorDR)),"^",1)
	    .s OrdStatDR=$P($G(^OEORD(Oew,"I",OrdSub,1)),"^",13)  ; OEC_OrderStatus             OEORI_ItemStat_DR 
	    .i OrdStatDR'="" s OrdStat=$P(^OEC("OSTAT",OrdStatDR),"^",2)
	    .//i (stop="0")&(OrdStat="停止") q 
        .s PriorDes="^"_PriorDes_"^"
	    .q:(^DHCOEOrdPrintSet("OrdTyp")'[PriorDes)&(tempTyp'="0")
	    .q:(^DHCOEOrdPrintSet("L","OrdTyp")'[PriorDes)&(longtyp'="0")
	    .s DoctorDr=$P($G(^OEORD(Oew,"I",OrdSub,1)),"^",11)
	    .s ServFlag=..GetServFlag(Oew,OrdSub)
	    .q:ServFlag'="S"
        .if DoctorDr'="" s CpTypDR=$P(^CTPCP(DoctorDr,1),"^",4)  ;CTPCP_CarPrvTp_DR
	    .q:CpTypDR=""
	    .q:'$D(^CT("CPT",CpTypDR))
	    .i $G(CpTypDR)'="" s CpTyp=$P(^CT("CPT",CpTypDR),"^",4)  ;CT_CarPrvTp
	    .q:CpTyp'="DOCTOR"
	   	.s MethDR=$P($G(^OEORD(Oew,"I",OrdSub,2)),"^",7)   ;PHC_Instruc                 OEORI_Instr_DR
	    .q:Instru'=MethDR&(Instru'="")
        .s Seq=##class(web.DHCPdaLongTimeOrd).GetSeqNo(Oew,OrdSub)
	    .s Seq1=$P(Seq,"^",1),Seq2=$P(Seq,"^",2)
	    .s ARCIMDesc(Oew,OrdSub)=##class(web.DHCPdaLongTimeOrd).GetArcDes(Oew,OrdSub)  ;ord name   
        .s ORD(OrdDate,OrdTime,Seq1,Seq2,Oew,OrdSub)=""
        .s DateEx="",TimeEx="" ,CPTEx=""
	    .s cl=0 s cl=$O(^OEORD(Oew,"I",OrdSub,"X",cl))
	    .i cl=""  s cl=1
	    .i $D(^OEORD(Oew,"I",OrdSub,"X",cl))  d
	    ..s DateEx=$P(^OEORD(Oew,"I",OrdSub,"X",cl),"^",19) i DateEx'="" s DateEx=$ZD(DateEx,3)  ;nursing execute
	    ..s TimeEx=$P(^OEORD(Oew,"I",OrdSub,"X",cl),"^",20)  i TimeEx'=""  s TimeEx=$ZT(TimeEx,2)
	    ..s CPTExDR=$P(^OEORD(Oew,"I",OrdSub,"X",cl),"^",15)
	    ..i CPTExDR'="" s CPTEx=$P(^CTPCP(CPTExDR,1),"^",2) 
	    .s DateEx(Oew,OrdSub)=DateEx,TimeEx(Oew,OrdSub)=TimeEx,CPTEx(Oew,OrdSub)=CPTEx
	 }
       s OrdDate=""  f  s OrdDate=$O(ORD(OrdDate))  q:OrdDate=""  d
	   .s tim="" f  s tim=$O(ORD(OrdDate,tim)) q:tim=""  d
	   ..s Seq1=""  f  s Seq1=$O(ORD(OrdDate,tim,Seq1)) q:Seq1=""  d
	   ...s Seq2=""  f  s Seq2=$O(ORD(OrdDate,tim,Seq1,Seq2))  q:Seq2=""  d
	   ....s rw=""  f  s rw=$O(ORD(OrdDate,tim,Seq1,Seq2,rw)) q:rw=""  d
	   .....s chl=""  f  s chl=$O(ORD(OrdDate,tim,Seq1,Seq2,rw,chl)) q:chl=""  d
	   ......s ARCIMDesc=ARCIMDesc(rw,chl)
	   ......if Seq2'=0  s ARCIMDesc="●"_ARCIMDesc
	   ......s DateEx=DateEx(rw,chl),TimeEx=TimeEx(rw,chl),CPTEx=CPTEx(rw,chl)
	   ......s ORW=rw_"||"_chl
	   ......s ArcimDR=$P($G(^OEORD(rw,"I",chl,1)),"^",2)
	   ......d OutPut
 
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
 //"起始日期|<起始时间|<临时医嘱|<医生签字|<执行时间|<执行人"/
OutPut
	set Data=$lb(ARCIMDesc,ORW,DateEx,TimeEx ,CPTEx,ArcimDR)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetServFlag(OrderRowid, itemsub) As %String
{
	//取检查标记 //
 	s arcimid=$p(^OEORD(OrderRowid,"I",itemsub,1),"^",2)
 	s ServerMaterial=$p($g(^ARCIM($p(arcimid,"||",1),$p(arcimid,"||",2),7)),"^",6)
 	q ServerMaterial
}

ClassMethod GetRadiaNote(oeordrowid) As %String
{
 //报告
	s rw=$O(^DHCPACRegInfoi("OEORI",oeordrowid,""))
	if rw="" q ""
	if rw'="" s studno=$P(^DHCPACRegInfo(rw),"^",2)
	s rprw=$O(^DHCRBStudyi("Report","StudyNo",studno,""))
	q:rprw="" ""
	s examdesc=^DHCRBStudy("Report",rprw,"ExamDescEx")  
	s resultdesc=^DHCRBStudy("Report",rprw,"ResultDescEx")
	q examdesc_$C(1)_resultdesc
}

ClassMethod GetOrdRadiaFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetOrdRadiaExecute ]
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

ClassMethod GetOrdRadiaClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetOrdRadiaExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetOrdRadia(Parr As %String) As %Query(ROWSPEC = "ARCIMDesc,ORW,DateEx,TimeEx ,CPTEx,ArcimDR,sel")
{
}

ClassMethod GetOrdDataExecute(ByRef qHandle As %Binary, Parr As %String) As %Status
{
	//d ##class(%ResultSet).RunQuery("web.DHCPdaTempOrd","GetOrdData","3508729^2010-10-27^2010-10-27^0^1^^1")
	Set repid=$I(^CacheTemp)
 	s ind=1
    s nvar=""
    //Adm As %String, StartDate As %String, EndDate As %String, longtyp As %String, tempTyp As %String
     s adm=$P(Parr,"^",1)
	 //s StartDate=$P(Parr,"^",2)
	 //s EndDate=$P(Parr,"^",3)
	 s longtyp=$P(Parr,"^",4)
	 s tempTyp=$P(Parr,"^",5)
	 s Instru=$P(Parr,"^",6)
	 s check=$P(Parr,"^",7)
	 s stop=$P(Parr,"^",8)
	 
	if $G(adm)="" Set qHandle=$lb(0,repid,0) Quit $$$OK
    s Oew=""  s Oew=$O(^OEORD(0,"Adm",adm,Oew)) 
    if Oew="" Set qHandle=$lb(0,repid,0) Quit $$$OK
    //if StartDate="" s StartDate=+$H
    //if EndDate=""  s EndDate=+$H
    s StartDate=$P(^PAADM(adm),"^",6)
    s EndDate=+$h
    //if StartDate'="" s StartDate=$ZDH(StartDate,3)
    //if EndDate'="" s EndDate=$ZDH(EndDate,3)
    f date=StartDate:1:EndDate   d
	    .s OrdSub=""  f  s OrdSub=$O(^OEORDi(0,"StDt",date,Oew,OrdSub)) q:OrdSub=""  d
    	..s PriorDR=$P($G(^OEORD(Oew,"I",OrdSub,1)),"^",8)     ;OEC_Priority                OEORI_Priority_DR
	    ..i PriorDR="" q //ypz
	   	..s OrdDate=$P($G(^OEORD(Oew,"I",OrdSub,1)),"^",9)
	    ..s OrdTime=$P($G(^OEORD(Oew,"I",OrdSub,1)),"^",10)
	    ..if OrdTime="" s OrdTime=$P($H,",",2)
        ..s PriorDes=$P($G(^OECPR(PriorDR)),"^",2)
	    ..s oecprCode=$P($G(^OECPR(PriorDR)),"^",1)
	    ..s OrdStatDR=$P($G(^OEORD(Oew,"I",OrdSub,1)),"^",13)  ; OEC_OrderStatus             OEORI_ItemStat_DR 
	    ..i OrdStatDR'="" s OrdStat=$P(^OEC("OSTAT",OrdStatDR),"^",2)
	    ..e  s OrdStat=""
	    ..q:(stop="1")&(OrdStat="停止") 
        ..s PriorDes="^"_PriorDes_"^"
	    ..//q:(^DHCOEOrdPrintSet("OrdTyp")'[PriorDes)&(tempTyp'="0")&(longtyp=0)
	    ..//q:(^DHCOEOrdPrintSet("L","OrdTyp")'[PriorDes)&(longtyp'="0")&(tempTyp=0)
	    ..s DoctorDr=$P($G(^OEORD(Oew,"I",OrdSub,1)),"^",11)
        ..if DoctorDr'="" s CpTypDR=$P(^CTPCP(DoctorDr,1),"^",4)  ;CTPCP_CarPrvTp_DR
	    ..e  s CpTypDR=""
	    ..q:CpTypDR=""
	    ..q:'$D(^CT("CPT",CpTypDR))
	    ..i $G(CpTypDR)'="" s CpTyp=$P(^CT("CPT",CpTypDR),"^",4)  ;CT_CarPrvTp
	    ..q:CpTyp'="DOCTOR"
	   	..s MethDR=$P($G(^OEORD(Oew,"I",OrdSub,2)),"^",7)   ;PHC_Instruc                 OEORI_Instr_DR
	    ..q:Instru'=MethDR&(Instru'="")
	    ..s ServFlag=""
        ..s ServFlag=..GetServFlag(Oew,OrdSub)
	    ..q:(ServFlag'="S")&(check'="")
	    ..s ArcimDR=$P($G(^OEORD(Oew,"I",OrdSub,1)),"^",2)
	    ..s ARCIMRowid=$P(ArcimDR,"||",1)
	    ..s ARCIMSub=$P(ArcimDR,"||",2) 
	    ..s ItemCatDR=$P($G(^ARCIM(ARCIMRowid,ARCIMSub,1)),"^",10) ;oeori_itmmast_dr->arcim_itemcat_dr->arcic_ordcat_dr->orcat_code
	    ..q:(ItemCatDR="")
	    ..s OrdCatDR=$P(^ARC("IC",ItemCatDR),"^",8)    ;ARc_Itemcat
        ..s OrdCatDesc=$P(^OEC("ORCAT",OrdCatDR),"^",2)
        ..q:(OrdCatDesc'["检查")&&(OrdCatDesc'["放射")
        ..s Seq=##class(web.DHCPdaLongTimeOrd).GetSeqNo(Oew,OrdSub)
	    ..s Seq1=$P(Seq,"^",1),Seq2=$P(Seq,"^",2)
	    ..s PHFreqDR=$P($G(^OEORD(Oew,"I",OrdSub,2)),"^",4)  ;eat medcine medicine frequency
        ..if PHFreqDR'="" s factor(Oew,OrdSub)=$P($G(^PHCFR(PHFreqDR)),"^",2) 
       	..s DoseQty(Oew,OrdSub)=$P($G(^OEORD(Oew,"I",OrdSub,2)),"^",1)   ;numeric  oeori_doseqty,ji Liang
        ..s ARCIMDesc(Oew,OrdSub)=##class(web.DHCPdaLongTimeOrd).GetArcDes(Oew,OrdSub)  ;ord name   
        ..s ORD(OrdDate,OrdTime,Seq1,Seq2,Oew,OrdSub)=""
        ..s DateEx="",TimeEx="" ,CPTEx=""
	    ..s cl=0 s cl=$O(^OEORD(Oew,"I",OrdSub,"X",cl))
	    ..i cl=""  s cl=1
	    ..i $D(^OEORD(Oew,"I",OrdSub,"X",cl))  d
	    ...s DateEx=$P(^OEORD(Oew,"I",OrdSub,"X",cl),"^",19)
	    ...i DateEx'="" s DateEx=$E($ZD(DateEx,3),6,10)  ;nursing execute
	    ...s TimeEx=$P(^OEORD(Oew,"I",OrdSub,"X",cl),"^",20)
	    ...i TimeEx'=""  s TimeEx=$ZT(TimeEx,2)
	    ...s CPTExDR=$P(^OEORD(Oew,"I",OrdSub,"X",cl),"^",15)
	    ...i CPTExDR'="" s CPTEx=$P(^CTPCP(CPTExDR,1),"^",2)
	    ..s DateEx(Oew,OrdSub)=DateEx,TimeEx(Oew,OrdSub)=TimeEx,CPTEx(Oew,OrdSub)=CPTEx
	    ..i check="1" s RORD(ARCIMDesc(Oew,OrdSub),OrdDate,OrdTime,Seq1,Seq2,Oew,OrdSub)=""
	    ..i check="1" d 
	    ...s DateEx(Oew,OrdSub)="",TimeEx(Oew,OrdSub)="",CPTEx(Oew,OrdSub)=""
	    ...s rw=$O(^DHCPACRegInfoi("OEORI",Oew_"||"_OrdSub,""))
		...q:rw=""
		...s studno=$P(^DHCPACRegInfo(rw),"^",2)
		...q:studno=""
		...s rprw=$O(^DHCRBStudyi("Report","StudyNo",studno,""))
		...q:rprw=""
		...s reportDate=$P($G(^DHCRBStudy("Report",rprw)),"^",9) 
		...i reportDate'=""  s DateEx(Oew,OrdSub)=$E($ZD(reportDate,3),6,10)
		...e  s DateEx(Oew,OrdSub)=""
		...s reportTime=$P($G(^DHCRBStudy("Report",rprw)),"^",10)
		...i reportTime'="" s TimeEx(Oew,OrdSub)=$ZT(reportTime,2)
		...e  s TimeEx(Oew,OrdSub)=""
		...s reportDoc=$P($G(^DHCRBStudy("Report",rprw)),"^",8)
		...i reportDoc'="" s CPTEx(Oew,OrdSub)=$P(^SSU("SSUSR",reportDoc),"^",2)
		...e  s CPTEx(Oew,OrdSub)=""
        
        i check="1" d
	       .s arcm="" f  s arcm=$O(RORD(arcm))  q:arcm=""  d
	       ..s OrdDate=""  f  s OrdDate=$O(RORD(arcm,OrdDate))  q:OrdDate=""  d
		   ...s tim="" f  s tim=$O(RORD(arcm,OrdDate,tim)) q:tim=""  d
		   ....s Seq1=""  f  s Seq1=$O(RORD(arcm,OrdDate,tim,Seq1)) q:Seq1=""  d
		   .....s Seq2=""  f  s Seq2=$O(RORD(arcm,OrdDate,tim,Seq1,Seq2))  q:Seq2=""  d
		   ......s rw=""  f  s rw=$O(RORD(arcm,OrdDate,tim,Seq1,Seq2,rw)) q:rw=""  d
		   .......s chl=""  f  s chl=$O(RORD(arcm,OrdDate,tim,Seq1,Seq2,rw,chl)) q:chl=""  d
		   ........s ARCIMDesc=ARCIMDesc(rw,chl)
		   ........if Seq2'=0  s ARCIMDesc="●"_ARCIMDesc
		   ........s DateEx=DateEx(rw,chl),TimeEx=TimeEx(rw,chl),CPTEx=CPTEx(rw,chl)
		   ........s ORW=rw_"||"_chl
		   ........s ArcimDR=$P($G(^OEORD(rw,"I",chl,1)),"^",2)
		   ........s Dose=$G(DoseQty(rw,chl))
		   ........s Factor=$G(factor(rw,chl))
		   ........s UOMDR=$P($G(^OEORD(rw,"I",chl,2)),"^",3  ) ;CT_UOM                      OEORI_Unit_DR
		   ........i UOMDR'="" s UOM=$P(^CT("UOM",UOMDR),"^",2)
		   ........i $G(UOM)="ml" s sum=$G(sum)+(Dose*Factor)  
		   ........d OutPut1
        e  d      
	       .s OrdDate=""  f  s OrdDate=$O(ORD(OrdDate))  q:OrdDate=""  d
		   ..s tim="" f  s tim=$O(ORD(OrdDate,tim)) q:tim=""  d
		   ...s Seq1=""  f  s Seq1=$O(ORD(OrdDate,tim,Seq1)) q:Seq1=""  d
		   ....s Seq2=""  f  s Seq2=$O(ORD(OrdDate,tim,Seq1,Seq2))  q:Seq2=""  d
		   .....s rw=""  f  s rw=$O(ORD(OrdDate,tim,Seq1,Seq2,rw)) q:rw=""  d
		   ......s chl=""  f  s chl=$O(ORD(OrdDate,tim,Seq1,Seq2,rw,chl)) q:chl=""  d
		   .......s ARCIMDesc=ARCIMDesc(rw,chl)
		   .......if Seq2'=0  s ARCIMDesc="●"_ARCIMDesc
		   .......s DateEx=DateEx(rw,chl),TimeEx=TimeEx(rw,chl),CPTEx=CPTEx(rw,chl)
		   .......s ORW=rw_"||"_chl
		   .......s ArcimDR=$P($G(^OEORD(rw,"I",chl,1)),"^",2)
		   .......s Dose=$G(DoseQty(rw,chl))
		   .......s Factor=$G(factor(rw,chl))
		   .......s UOMDR=$P($G(^OEORD(rw,"I",chl,2)),"^",3  ) ;CT_UOM                      OEORI_Unit_DR
		   .......i UOMDR'="" s UOM=$P(^CT("UOM",UOMDR),"^",2)
		   .......i $G(UOM)="ml" s sum=$G(sum)+(Dose*Factor)  
		   .......d OutPut1
		   .i ind'=1 d
		   ..i $G(sum)="" s sum=0
		   ..s (ARCIMDesc,ORW,DateEx,TimeEx ,CPTEx,ArcimDR,Dose,UOM,Factor)="",ARCIMDesc=$G(sum)_"ml"
    	   ..d OutPut1
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
 //"起始日期|<起始时间|<临时医嘱|<医生签字|<执行时间|<执行人"/
OutPut1
	set Data=$lb(ARCIMDesc,ORW,DateEx,TimeEx ,CPTEx,ArcimDR,"",Dose,$G(UOM),Factor)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetOrdDataFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetOrdDataExecute ]
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

ClassMethod GetOrdDataClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetOrdDataExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetOrdData(Parr As %String) As %Query(ROWSPEC = "ARCIMDesc,ORW,DateEx,TimeEx ,CPTEx,ArcimDR,sel,Dose,Uom,Factor")
{
}

ClassMethod GetTempOrdClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetTempOrdExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod GetTempOrdExecute(ByRef qHandle As %Binary, Adm As %String, StartDate As %String, EndDate As %String, ChangeDate As %String = "", stop As %String = "0") As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
    s nvar=""
    s adm=Adm
    s ret=stop
    s stop=$P(ret,"^",1)
    s ant=$P(ret,"^",2)
	if $G(adm)="" Set qHandle=$lb(0,repid,0) Quit $$$OK
    s Oew=""  s Oew=$O(^OEORD(0,"Adm",adm,Oew)) 
    if StartDate="" s StartDate=+$H
    if EndDate=""  s EndDate=+$H
    if StartDate'="" s StartDate=$ZDH(StartDate,3)
    if EndDate'="" s EndDate=$ZDH(EndDate,3)

    f date=StartDate:1:EndDate 
    { 
	    s OrdSub=""  f  s OrdSub=$O(^OEORDi(0,"StDt",date,Oew,OrdSub)) q:OrdSub=""  d
    	.s PriorDR=$P($G(^OEORD(Oew,"I",OrdSub,1)),"^",8)     ;OEC_Priority                OEORI_Priority_DR
	    .i PriorDR="" q //ypz
	   	.s OrdDate=$P($G(^OEORD(Oew,"I",OrdSub,1)),"^",9)
	   	.i OrdDate'="" s SDate=$E($ZD(OrdDate,3),6,10)
	   	.e  s SDate=""
	    .s OrdTime=$P($G(^OEORD(Oew,"I",OrdSub,1)),"^",10)
	    .i OrdTime'="" s STime=$ZT(OrdTime,2)
	    .e  s STime=""
	    .if OrdTime="" s OrdTime=$P($H,",",2)
        .s PriorDes=$P($G(^OECPR(PriorDR)),"^",2)
	    .s oecprCode=$P($G(^OECPR(PriorDR)),"^",1)
	    .s OrdStatDR=$P($G(^OEORD(Oew,"I",OrdSub,1)),"^",13)  ; OEC_OrderStatus             OEORI_ItemStat_DR 
	    .i OrdStatDR'="" s OrdStat=$P(^OEC("OSTAT",OrdStatDR),"^",2)
	    .i (stop="0")&(OrdStat="停止") q 
        .s PriorDes="^"_PriorDes_"^"
	    .q:(^DHCOEOrdPrintSet("OrdTyp")'[PriorDes)
	    .s phtyp=##class(web.DHCPdaLongTimeOrd).Getphtyp(Oew,OrdSub)
	    .q:(phtyp'="抗生素")&(ant'="0")
	    .s DoctorDr=$P($G(^OEORD(Oew,"I",OrdSub,1)),"^",11)
        .if DoctorDr'="" s CpTypDR=$P(^CTPCP(DoctorDr,1),"^",4),Cpt= $P(^CTPCP(DoctorDr,1),"^",4) ;CTPCP_CarPrvTp_DR
	    .e  s Cpt=""
	    .q:$G(CpTypDR)=""
	    .q:'$D(^CT("CPT",CpTypDR))
	    .i $G(CpTypDR)'="" s CpTyp=$P(^CT("CPT",CpTypDR),"^",4)  ;CT_CarPrvTp
	    .q:CpTyp'="DOCTOR"
        .s Seq=##class(web.DHCPdaLongTimeOrd).GetSeqNo(Oew,OrdSub)
	    .s Seq1=$P(Seq,"^",1),Seq2=$P(Seq,"^",2)
	    .s ARCIMDesc(Oew,OrdSub)=##class(web.DHCPdaLongTimeOrd).GetArcDes(Oew,OrdSub)  ;ord name   
        .s ORD(OrdDate,OrdTime,Seq1,Seq2,Oew,OrdSub)=""
        .s DateEx="",TimeEx="" ,CPTEx=""
	    .s cl=0 s cl=$O(^OEORD(Oew,"I",OrdSub,"X",cl))
	    .i cl=""  s cl=1
	    .i $D(^OEORD(Oew,"I",OrdSub,"X",cl))  d
	    ..s DateEx=$P(^OEORD(Oew,"I",OrdSub,"X",cl),"^",19)
	    ..i DateEx'="" s DateEx=$E($ZD(DateEx,3),6,10)  ;nursing execute
	    ..s TimeEx=$P(^OEORD(Oew,"I",OrdSub,"X",cl),"^",20)
	    ..i TimeEx'=""  s TimeEx=$ZT(TimeEx,2)
	    ..s CPTExDR=$P(^OEORD(Oew,"I",OrdSub,"X",cl),"^",15)
	    ..i CPTExDR'="" s CPTEx=$P(^CTPCP(CPTExDR,1),"^",2) 
	    .s DateEx(Oew,OrdSub)=DateEx,TimeEx(Oew,OrdSub)=TimeEx,CPTEx(Oew,OrdSub)=CPTEx
	    .s SDate(Oew,OrdSub)=SDate,STime(Oew,OrdSub)=STime,Cpt(Oew,OrdSub)=Cpt
	 }
       s OrdDate=""  f  s OrdDate=$O(ORD(OrdDate))  q:OrdDate=""  d
	   .s tim="" f  s tim=$O(ORD(OrdDate,tim)) q:tim=""  d
	   ..s Seq1=""  f  s Seq1=$O(ORD(OrdDate,tim,Seq1)) q:Seq1=""  d
	   ...s Seq2=""  f  s Seq2=$O(ORD(OrdDate,tim,Seq1,Seq2))  q:Seq2=""  d
	   ....s rw=""  f  s rw=$O(ORD(OrdDate,tim,Seq1,Seq2,rw)) q:rw=""  d
	   .....s chl=""  f  s chl=$O(ORD(OrdDate,tim,Seq1,Seq2,rw,chl)) q:chl=""  d
	   ......s ARCIMDesc=ARCIMDesc(rw,chl)
	   ......if Seq2'=0  s ARCIMDesc="●"_ARCIMDesc
	   ......s DateEx=DateEx(rw,chl),TimeEx=TimeEx(rw,chl),CPTEx=CPTEx(rw,chl)
	   ......s ORW=rw_"||"_chl
	   ......s SDate=SDate(rw,chl)
	   ......s STime=STime(rw,chl)
	   ......s Cpt=Cpt(rw,chl)
	   ......d OutPut2
 
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
 //"起始日期|<起始时间|<临时医嘱|<医生签字|<执行时间|<执行人"/
OutPut2
	set Data=$lb(ARCIMDesc,ORW,SDate,STime,Cpt,DateEx,TimeEx,CPTEx)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetTempOrdFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetTempOrdExecute ]
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

Query GetTempOrd(Adm As %String, StartDate As %String, EndDate As %String, ChangeDate As %String, stop As %String = "0") As %Query(ROWSPEC = "ARCIMDesc,ORW,SDate,STime,Cpt,DateEx,TimeEx,CPTEx")
{
}

ClassMethod GetOrdTempData(Adm As %String, StartDate As %String, EndDate As %String, ChangeDate As %String, stop As %String = "0") As %String
{
  // n (Adm, StartDate, EndDate, ChangeDate, stop)
   s QueryName="web.DHCPdaTempOrd:GetTempOrd"
   //q "web.DHCNURPDAQUEXCUTE:GetPatOrdItem"
   Set rset = ##class(%ResultSet).%New(QueryName)
   Set columns = rset.GetColumnCount()

 // Execute the query
    s sc = rset.Execute(Adm, StartDate, EndDate, ChangeDate, stop)

   s QueryName=$TR(QueryName,":","&")
   s ret=$P(QueryName,"&",2)_"&"
  s i=0
  While (rset.Next()) {
       i (i=0){
        For col = 1:1:columns {
            s ret=ret_rset.GetColumnName(col)_"&"
        }
       }
       s coldata=""
       For col = 1:1:columns {
            s coldata=coldata_rset.GetData(col)_"^"
        }

      if (i=0){
	      s ret=ret_"$"_coldata_"&"
	      }else{
		    s ret=ret_coldata_"&"

		      }
      s i=i+1
      if i>100  q
      
 }
 Do rset.Close()
 s qu=$P(QueryName,"&",2)_"&"
 if ret=qu  s ret="-1"
 q ret
}

ClassMethod GetOrddta(Parr As %String) As %String
{
  // n (Adm, StartDate, EndDate, ChangeDate, stop)
   s QueryName="web.DHCPdaTempOrd:GetOrdData"
   //q "web.DHCNURPDAQUEXCUTE:GetPatOrdItem"
   Set rset = ##class(%ResultSet).%New(QueryName)
   Set columns = rset.GetColumnCount()

 // Execute the query
    s sc = rset.Execute(Parr)

   s QueryName=$TR(QueryName,":","&")
   s ret=$P(QueryName,"&",2)_"&"
  s i=0
  While (rset.Next()) {
       i (i=0){
        For col = 1:1:columns {
            s ret=ret_rset.GetColumnName(col)_"&"
        }
       }
       s coldata=""
       For col = 1:1:columns {
            s coldata=coldata_rset.GetData(col)_"^"
        }

      if (i=0){
	      s ret=ret_"$"_coldata_"&"
	      }else{
		    s ret=ret_coldata_"&"

		      }
      s i=i+1
      if i>200  q
      
 }
 Do rset.Close()
 s qu=$P(QueryName,"&",2)_"&"
 if ret=qu  s ret="-1"
 q ret
}

}
