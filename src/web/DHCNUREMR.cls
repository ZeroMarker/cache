Class web.DHCNUREMR Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// w ##class(web.DHCNUREMR).Replace("abcdefghijklmn&KeyEnter;opqrstuvwxyz","&KeyEnter;","\n")
ClassMethod Replace20170908(Strings, Str, Rep) As %String [ Language = basic ]
{
return Replace(Strings,Str,Rep)
}

/// w##class(web.DHCNUREMR).Replace("abcdefghijklmn&KeyEnter;opqrstuvwxyz","&KeyEnter;","\n")
ClassMethod Replace(Strings, Str, Rep) As %String
{
 Q ..ReplaceCommon(Strings,Str,Rep)
}

/// 要求被替换的内容不能=""
ClassMethod ReplaceCommon(instr As %String, substr As %String, replacement As %String) As %String
{
	;
	q:(substr="") instr
	;q:(replacement="") instr
	q:'($l(instr,substr)>1) instr
	
	s mylen=$l(instr,substr)
	for myIdx=1:1:mylen {
		s myary(myIdx)=$p(instr,substr, myIdx)
	}
	
	s mystr=""
	s myIdx=""
	s myIdx=$o(myary(myIdx))
	while (myIdx'=""){
		s myrepstr=""
		i ($o(myary(myIdx))=""){
			s myrepstr=myary(myIdx)
		}else{
			s myrepstr=myary(myIdx)_replacement
		}
		
		i (mystr=""){
			s mystr=myrepstr
		}else{
			s mystr=mystr_myrepstr
		}
		
		s myIdx=$o(myary(myIdx))
		q:(myIdx="")
	}
	
	q mystr
}

ClassMethod GetMGEpMulEmrExecute(ByRef qHandle As %Binary, parr As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
    //s parr="1^2010-04-25^2010-04-25^fold2"
 	s foldcode=$P(parr,"^",4)
 	s stdate=$P(parr,"^",2)
 	s eddate=$P(parr,"^",3)
 	s Loc=$P(parr,"^",1)
 	s std=$ZDH(stdate,3)
 	s end=$ZDH(eddate,3)
    s foldcode=$ZConvert(foldcode,"U")
 	//s dep=parr
 	 f date=std:1:end
 	 {
	 	 s parentid=""  f  s parentid=$O(^NurEmr.DHCMgEmrDataChildI("EmrGrpDate",date," "_foldcode,parentid)) q:parentid=""  d
	 	 .s chl=""  f  s chl=$O(^NurEmr.DHCMgEmrDataChildI("EmrGrpDate",date," "_foldcode,parentid,chl)) q:chl=""  d
         ..d out

	 }
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK

out
    s (depdes,patname,emrtyp,ludate,lutime,user,person,episode,multid,rw)=""
    s rw=parentid_"||"_chl
    s a=^NurEmr.DHCMgEmrDataD(parentid,"ParentID",chl)
    s p=^NurEmr.DHCMgEmrDataD(parentid)
    s Status=$ListGet(a,6)
    if Status="" s Status="保存"
    if Status="A" s Status="提交"
    s MultId=$ListGet(a,11)
    q:MultId'=""
    s multid=rw
    s dep=$List(p,4)
    q:(dep'=Loc)&(Loc'="")
    s code=$list(a,10)
    s emrtyp=$Listget(a,8)
    s episode=$List(p,3)
    if episode'=""
    {
	    s papmiId=+^PAADM(episode)
	    s patname=$p($g(^PAPER(papmiId,"ALL")),"^",1)
    }
    if dep'="" s depdes=$P(^CTLOC(dep),"^",2)
    s lutime=$List(a,7)
    
    s lutime=$ZT(lutime)
    s ludate=$ListGet(a,4)
    s ludate=$ZD(ludate,3)
    s userdr=$ListGet(a,9)
    s persondr=$ListGet(p,8)
    s grptitle=$ListGet(a,12)
    
    if userdr'=""
    {
	    s parr=^User.DHCMGPersonsD(userdr)
	    s user=$list(parr, 21)
    }
    if persondr'=""
    {
	  s parr=^User.DHCMGPersonsD(persondr)
      s person=$list(parr, 21)
    }
    b
    d OutRowtyp
    q
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
  
OutRowtyp
	set Data=$lb(depdes,patname,grptitle,ludate,lutime,user,person,episode,dep,code,"",multid,Status)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetMGEpMulEmrFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetMGEpMulEmrExecute ]
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

ClassMethod GetMGEpMulEmrClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetMGEpMulEmrExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetMGEpMulEmr(parr As %String) As %Query(ROWSPEC = "depdes,patname,emrtyp,ludate,lutime,user,person,episode,Loc,emrcode,rw,mulrw,status")
{
}

ClassMethod GetMgAdmEmrConExecute(ByRef qHandle As %Binary, parr As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	//s parr="140^2010-04-10^2010-04-20^WinTmpver211itm21fold2NOD"
 	s Loc=$P(parr,"^",1)
 	s emrcode=$P(parr,"^",4)
 	s stdate=$P(parr,"^",2)
 	s eddate=$P(parr,"^",3)
 	s std=$ZDH(stdate,3)
 	s end=$ZDH(eddate,3)
    s emrcode=$ZConvert(emrcode,"U")
    
 	//s dep=parrWinTmpver111itm11fold1NOD
 	//if parentid=""  Set qHandle=$lb(0,repid,0) Quit $$$OK
 	 f date=std:1:end
 	 {
	 	 s parentid=""  f  s parentid=$O(^NurEmr.DHCMgEmrDataChildI("EmrCodeDate",date," "_emrcode,parentid)) q:parentid=""  d
	 	 .s chl=""  f  s chl=$O(^NurEmr.DHCMgEmrDataChildI("EmrCodeDate",date," "_emrcode,parentid,chl)) q:chl=""  d
         ..d out

	 }
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK

out
    s (depdes,patname,emrtyp,ludate,lutime,user,person,episode,multid,rw)=""
    s rw=parentid_"||"_chl
    s a=^NurEmr.DHCMgEmrDataD(parentid,"ParentID",chl)
    s p=^NurEmr.DHCMgEmrDataD(parentid)
    s Status=$ListGet(a,6)
    if Status="" s Status="保存"
    if Status="A" s Status="提交"
    s dep=$List(p,4)
    s code=$list(a,2)
    s emrtyp=$Listget(a,8) 
    s episode=$List(p,3)
    if episode'=""
    {
	    s papmiId=+^PAADM(episode)
	    s patname=$p($g(^PAPER(papmiId,"ALL")),"^",1)
	    s patward=$P(^PAADM(episode),"^",70)
	    s patloc=$P(^PAWARD(patward),"^",5)
    }
    if dep="" s dep=$Listget(a,13)
    if dep=""
    { 
      s aa=##class(NurEmr.DHCMgEmrDataChild).%OpenId(parentid_"||"_chl)
      s aa.EmrLoc=patloc
      d aa.%Save()
      s dep=patloc
      
    }
   // w !,dep
    b
    q:(dep'=Loc)&(Loc'="")
    if dep'="" s depdes=$P(^CTLOC(dep),"^",2)
    s lutime=$List(a,7)
    s lutime=$ZT(lutime)
    s ludate=$ListGet(a,4)
    s ludate=$ZD(ludate,3)
    s userdr=$ListGet(a,9)
    s persondr=$ListGet(p,8)
    if userdr'=""
    {
	    s parr=^User.DHCMGPersonsD(userdr)
	    s user=$list(parr, 21)
    }
    if persondr'=""
    {
	  s parr=^User.DHCMGPersonsD(persondr)
      s person=$list(parr, 21)
    }
    b
    d OutRowtyp
    q
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
  
OutRowtyp
	set Data=$lb(depdes,patname,emrtyp,ludate,lutime,user,person,episode,dep,code,rw,multid,Status)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetMgAdmEmrConFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetMgAdmEmrConExecute ]
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

ClassMethod GetMgAdmEmrConClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetMgAdmEmrConExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetMgAdmEmrCon(parr As %String) As %Query(ROWSPEC = "depdes,patname,emrtyp,ludate,lutime,user,person,episode,Loc,emrcode,rw,mulrw,status")
{
}

ClassMethod GetMgArEmrConExecute(ByRef qHandle As %Binary, parr As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	//s parr="2^2010-04-10^2010-04-20^WinTmpver211itm21fold2NOD"
 	s parentid=$P(parr,"^",1)
 	s emrcode=$P(parr,"^",4)
 	s stdate=$P(parr,"^",2)
 	s eddate=$P(parr,"^",3)
 	s std=$ZDH(stdate,3)
 	s end=$ZDH(eddate,3)
    s emrcode=$ZConvert(emrcode,"U")
    
 	//s dep=parr
 	if parentid=""  Set qHandle=$lb(0,repid,0) Quit $$$OK
 	 f date=std:1:end
 	 {
	 	 s chl=""  f  s chl=$O(^NurEmr.DHCMgEmrDataChildI("EmrCodeDate",date," "_emrcode,parentid,chl)) q:chl=""  d
         .b
         .d out

	 }
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK

out
    s (depdes,patname,emrtyp,ludate,lutime,user,person,episode,multid,rw)=""
    s rw=parentid_"||"_chl
    s a=^NurEmr.DHCMgEmrDataD(parentid,"ParentID",chl)
    s p=^NurEmr.DHCMgEmrDataD(parentid)
    s Status=$ListGet(a,6)
    if Status="" s Status="保存"
    if Status="A" s Status="提交"
    
    s dep=$List(p,4)
    //q:(dep'=Loc)&(Loc'="")
    s code=$list(a,2)
    s emrtyp=$Listget(a,8)
    s episode=$List(p,3)
    if episode'=""
    {
	    s papmiId=+^PAADM(episode)
	    s patname=$p($g(^PAPER(papmiId,"ALL")),"^",1)
    }
    if dep'="" s depdes=$P(^CTLOC(dep),"^",2)
    s lutime=$List(a,7)
    s lutime=$ZT(lutime)
    s ludate=$ListGet(a,4)
    s ludate=$ZD(ludate,3)
    s userdr=$ListGet(a,9)
    s persondr=$ListGet(p,8)
    if userdr'=""
    {
	    s parr=^User.DHCMGPersonsD(userdr)
	    s user=$list(parr, 21)
    }
    if persondr'=""
    {
	  s parr=^User.DHCMGPersonsD(persondr)
      s person=$list(parr, 21)
    }
    b
    d OutRowtyp
    q
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
  
OutRowtyp
	set Data=$lb(depdes,patname,emrtyp,ludate,lutime,user,person,episode,dep,code,rw,multid,Status)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetMgArEmrConFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetMgArEmrConExecute ]
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

ClassMethod GetMgArEmrConClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetMgArEmrConExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetMgArEmrCon(parr As %String) As %Query(ROWSPEC = "depdes,patname,emrtyp,ludate,lutime,user,person,episode,Loc,emrcode,rw,mulrw,status")
{
}

ClassMethod GetPatOrdExecute(ByRef qHandle As %Binary, par As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	s ^TY("GetPatOrd")=par
 	//补贴调节记录
 	//s par="5307120^2010-03-03^2010-03-03"
    s adm=$P(par,"^",1)
    s stdate=$P(par,"^",2)
    s eddate=$P(par,"^",3)
    s PriorFlag=$P(par,"^",4)
    i stdate["_" s stdate=$ZDH(stdate,3)
    e   s stdate=##class(websys.Conversions).DateHtmlToLogical(stdate)
    i eddate["-" s eddate=$ZDH(eddate,3)
    e   s eddate=##class(websys.Conversions).DateHtmlToLogical(eddate)
    //s stdate=##class(websys.Conversions).DateHtmlToLogical(stdate)
 	//s eddate=##class(websys.Conversions).DateHtmlToLogical(eddate)
	s Oew="" s Oew=$O(^OEORD(0,"Adm",adm,Oew)) 
	if Oew="" Set qHandle=$lb(0,repid,0)	Quit $$$OK

    f Date=stdate:1:eddate
    {
       s OrdSub=""  f  s OrdSub=$O(^OEORDi(0,"ItemDate",Date,Oew,OrdSub)) q:OrdSub=""  d
		.s OrdDate=$P($G(^OEORD(Oew,"I",OrdSub,3)),"^",7)  ;取得医嘱表医嘱日期?
		.s OrdTime=$P($G(^OEORD(Oew,"I",OrdSub,1)),"^",17)
		.//s OrdDate=$ZD(OrdDate,3)
		.s OrdDate=##class(websys.Conversions).DateLogicalToHtml(OrdDate)
		.s OrdTime=$ZT(OrdTime)
		.s PriorDR=$P($G(^OEORD(Oew,"I",OrdSub,1)),"^",8)     ;OEC_Priority 
		.q:PriorDR=""  //               OEORI_Priority_DR
		.i PriorDR'="" s PriorDes=$P(^OECPR(PriorDR),"^",2)
		.q:(PriorFlag="T")&&(PriorDes'="临时医嘱")
		.q:(PriorFlag="L")&&(PriorDes'="长期医嘱")
		.s DoctorDr=$P($G(^OEORD(Oew,"I",OrdSub,1)),"^",11)
		.s user=$P($G(^OEORD(Oew,"I",OrdSub,7)),"^",1)
		.q:user=""
		.q:'$D(^SSU("SSUSR",user))
		.s DoctorDr=$P(^SSU("SSUSR",user),"^",14)
		.q:DoctorDr=""  ;s Notes=$G(^OEORD(Oew,"I", OrdSub,"DEP",1))
		.s Notes=""
		.f rnum=1:1:$G(^OEORD(Oew,"I",OrdSub,"DEP",0))  d
		..s Notes=Notes_$G(^OEORD(Oew,"I",OrdSub,"DEP",rnum))
		.i $G(Notes)="" s Notes=""
	    .i DoctorDr'=""  s Doctor=$P(^CTPCP(DoctorDr,1),"^",2) ;write doctor oeori_doctor_dr
		.e  s Doctor=""
	    .if DoctorDr'="" s CpTypDR=$P(^CTPCP(DoctorDr,1),"^",4)  ;CTPCP_CarPrvTp_DR
		.i $G(CpTypDR)'="" s CpTyp=$P(^CT("CPT",CpTypDR),"^",4)  ;CT_CarPrvTp
		.q:($G(CpTyp)'="DOCTOR")  //&(UsrTyp'="NURSE")  //ypz 061102
		.s ArcimDR=$P($G(^OEORD(Oew,"I",OrdSub,1)),"^",2)
		.s ARCIMRowid=$P(ArcimDR,"||",1)
		.s ARCIMSub=$P(ArcimDR,"||",2) 
		.s ARCIMD=$P($G(^ARCIM(ARCIMRowid,ARCIMSub,1)),"^",2)  ;ord name   
		.s ARCIMDesc=$P(ARCIMD,"]",2)
		.if ARCIMDesc="" s ARCIMDesc=$P(ARCIMD,"]",1)
		.s ARCIMDesc=$P(ARCIMD,"(",1)
		.s pacunit=$P($G(^ARCIM(ARCIMRowid,ARCIMSub,8)),"^",14)
		.if pacunit'="" s pacunit=$P(^CT("UOM",pacunit),"^",2) 
		.s ItemCatDR=$P($G(^ARCIM(ARCIMRowid,ARCIMSub,1)),"^",10) ;oeori_itmmast_dr->arcim_itemcat_dr->arcic_ordcat_dr->orcat_code
		.;W "ArcimDR:",ArcimDR,!
		.q:(ItemCatDR="")
		.s OrdCatDR=$P(^ARC("IC",ItemCatDR),"^",8)    ;ARc_Itemcat
		.//q:(OrdCatDR=49)!(OrdCatDR=52)   //材料,收费
		.s OrdCat=$P(^OEC("ORCAT",OrdCatDR),"^",1)    ;OEC_OrderCategory           ARCIC_OrdCat_DR 
		.s OrdCat="^"_OrdCat_"^"
		.s PHFreqDR=$P($G(^OEORD(Oew,"I",OrdSub,2)),"^",4)  ;eat medcine medicine frequency
		.i (PHFreqDR'="") d
		..if $D(^PHCFR(PHFreqDR)) s PHFreq=$P(^PHCFR(PHFreqDR),"^",3) 
		..e  s PHFreq=""
		.e  s PHFreq=""  ;table       PHC_Freq
		.s UOMDR=$P($G(^OEORD(Oew,"I",OrdSub,2)),"^",3  ) ;CT_UOM                      OEORI_Unit_DR
		.i UOMDR'="" s UOM=$P(^CT("UOM",UOMDR),"^",2)  
		.e  s UOM="" 
		.s DoseQty=$P($G(^OEORD(Oew,"I",OrdSub,2)),"^",1)   ;numeric  oeori_doseqty,ji Liang
		.if (DoseQty'="")&($P(DoseQty,"."))="" s DoseQty="0"_DoseQty
		.s Dose=DoseQty  //_" "_UOM
		.s PhQtyOrd=$P($G(^OEORD(Oew,"I",OrdSub,1)),"^",12)  ;oeori_Phqtyord  shu liang
		.s MethDR=$P($G(^OEORD(Oew,"I",OrdSub,2)),"^",7)   ;PHC_Instruc                 OEORI_Instr_DR
		.i MethDR'="" s Meth=$P(^PHCIN(MethDR),"^",2)  
		.e   s Meth=""
		.s DurDR=$P($G(^OEORD(Oew,"I",OrdSub,2)),"^",6)   ;         OEORI_Durat_DR->phcdu_desc1, PHC_Duration
		.i DurDR'="" s During=$P(^PHCDU(DurDR),"^",3)   
		.e  s During=""  ;           period of treatment
		.s StDate=$P($G(^OEORD(Oew,"I",OrdSub,1)),"^",9)
		.s StTime=$P($G(^OEORD(Oew,"I",OrdSub,1)),"^",10) 
		.s OrdStatDR=$P($G(^OEORD(Oew,"I",OrdSub,1)),"^",13)  ; OEC_OrderStatus             OEORI_ItemStat_DR 
		.i OrdStatDR'="" s OrdStat=$P(^OEC("OSTAT",OrdStatDR),"^",2) 
		.e  s OrdStat=""  ;ord status
		.q:OrdStatDR=11
		.s Seq2=$P($G(^OEORD(Oew,"I",OrdSub,3)),"^",4)  ;relation No
		.s SeqNo=$p($g(^OEORD(Oew,"I",OrdSub,11)),"^",39) //qshe add 05-08-22
	    .if SeqNo'="" d
	    ..s tmpSeqNo=$P(SeqNo,"||",2),ARCIMDesc="_____"_ARCIMDesc
	    .e  s tmpSeqNo=OrdSub
	    .s SeqNo(Oew,OrdSub)=SeqNo    ;lgl+
	    .s Seq1=tmpSeqNo
		.s PadmTyp=$P(^PAADM(adm),"^",2)
		.s PackNum=$P($G(^OEORD(Oew,"I",OrdSub,9)),"^",4)  ;zheng baozhuang shu   OEORI_QtyPackUOM
		.s RefundQty=$P($G(^OEORD(Oew,"I",OrdSub,3)),"^",23)
		.s PackStr=""   ;lgl+ 否则取药医嘱数量会错
		.if $G(PackNum)'="" s PackStr=$G(PackNum)_" "_$G(pacunit)
		.if $G(PhQtyOrd)'="" s QtyStr=$G(PhQtyOrd)_" "_$G(UOM)
		.if $G(PackStr)'="" s numstr=$G(PackStr)
		.e  s numstr=$G(QtyStr)
		.d out
	
	}
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK

  
out
	set Data=$lb(OrdDate,OrdTime,ARCIMDesc,PriorDes,Meth,PHFreq,Dose,UOM,PhQtyOrd,OrdStat,Doctor,Oew,OrdSub,"false",Seq1)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetPatOrdFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPatOrdExecute ]
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

ClassMethod GetPatOrdClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPatOrdExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetPatOrd(parr As %String) As %Query(ROWSPEC = "OrdDate,OrdTime,ARCIMDesc,PriorDes,Meth,PHFreq,Dose,DoseUnit,PhQtyOrd,OrdStat,Doctor,Oew,OrdSub,Sel:%Boolean,SeqNo")
{
}

ClassMethod GetReader20170908(id As %String, DissolveStream As %Stream) As %XML.TextReader
{
	s AFileName=..GetFileName(id) 
	S stream=##class(%FileCharacterStream).%New()
	S stream.Filename=AFileName
	d stream.TranslateTableSet("UTF8")
	d stream.WriteLine("<?xml version=""1.0"" encoding=""UTF-8""?>")
	//b ///sdfsdf
	while (DissolveStream.AtEnd = 0)
	{ 
		s readstring=DissolveStream.Read(1024)
	 	d stream.Write(readstring)
	}
	d stream.SaveStream()
	D stream.%Close()
	S sc = ##class(%XML.TextReader).ParseFile(AFileName,.reader)
	q reader
}

ClassMethod GetReader(id As %String, DissolveStream As %Stream) As %XML.TextReader
{
	s reader=""
	// 备份
	s AFileName=..GetFileName(id) 
	S stream=##class(%FileCharacterStream).%New()
	S stream.Filename=AFileName
	d stream.TranslateTableSet("UTF8")
	d stream.WriteLine("<?xml version=""1.0"" encoding=""UTF-8""?>")
	//b ///sdfsdf
	while (DissolveStream.AtEnd = 0)
	{ 
		s readstring=DissolveStream.Read(1024)
	 	d stream.Write(readstring)
	}
	d stream.SaveStream()
	D stream.%Close()
	i (DissolveStream'="") {
		d DissolveStream.Rewind()
		s sc=##class(%XML.TextReader).ParseStream(DissolveStream,.reader)
		i ($$$ISERR(sc)) s reader=""
	}
	q reader
}

ClassMethod GetData(mth As %String, parrm As %String) As %String
{
   //mth="##class(web.DHCMGNurComm).GetLoc"
   //s mth="web.DHCMGNurComm:GetLoc" ,parrm=p1:4!p2:5
   s mth="##class("_$P(mth,":")_")."_$P(mth,":",2)
   s l=$L(parrm,"!")

   s pp=""

   if $F(parrm,"!")'=0
   {
	   f i=1:1:l
	   {
	     s itm=$P(parrm,"!",i)
	     if itm="" continue
	     	 //  s ^TMP("aa")="ffff"

	     s p=$P(itm,":",1)
	     s v=$P(itm,":",2)
	     s @p=v
	     if pp'="" s pp=pp_","_p
	     e  s pp=p 
	     b //
	   }
   }
   	s mth=mth_"("_pp_")"
   	b  //getdata
   	s c="a="_mth
   	set @c
   	s b="a"
   	s aa=@b
   	
	s a=$TR(aa,$C(1),"@")
	s a=$TR(a,$C(2),"!")
	s a=$TR(a,$C(3),"$")
	q a
}

ClassMethod GetPrintData(param) As %GlobalCharacterStream
{
   //web.DHCNUREMR
   //

 //s ^TMP("param")=param
 // s param=^TMP("param")
 //s param="DHCPRISONPRNEXAMXS^^^PRISON.PhysExamRec:getprnval&parr:19"
   // s param="PrnReportver111itm11fold1NOD^31||4^^"
   // s param="DHCPregPrn2^^^web.DHCPregPrint:PregHisRec&PregDr$170"
  //  s param="DHCNurOPChecMoulPrn^57||1^^web.DHCNurOpRecComm:OpCheckRecPrn&parr$2"
    //s str=##class(web.DHCNUREMR).GetPrintData(^TMPTY("GetPrintData"))
    s ^TMPTY("GetPrintData")=param
	s EmrCode=$P(param,"^",1) //
	s Id=$P(param,"^",2)
	s mulid=$P(param,"^",3)
	s mthpar=$P(param,"^",4)
	if mthpar="!" s mthpar=""
	s itmLabelVal=""  //LabelText
	s str=##class(NurEmr.NurEmrSub).getData(EmrCode)
	s ITM=""
	b ;1
	if str'="" 
	{  
		;S ITM=##CLASS(NurEmr.NurEmrSub).%OpenId(str)
		s parr=EmrCode_"^"_mthpar
		S ITM=##CLASS(NurEmr.NurEmrSub).GetStreamNewHH(parr)

	}else
	{
	  q ""
	}
	;d ITM.EmrSubData.Rewind()
	d ITM.Rewind()
   // Set sc = ##class(%XML.TextReader).ParseFile(ITM.EmrSubData,.Reader)   
    ;s Reader=..GetReader(str,ITM.EmrSubData)
	s Reader=..GetReader(str,ITM)

    while Reader.Read()
    {
	   if Reader.Name="PageHeadFoot"
	   {
		   while Reader.Read()
		   {
		     if $find(Reader.Name,"B")'=0
		     {
			        s itmname=Reader.Name
			    	if (Reader.MoveToAttributeName("Rel"))
				    {
					  s TMPITM(itmname)=Reader.Value
					  s TMPITMData(Reader.Value)=""
					
					}
					
			 }
		     if (Reader.Name="PageHeadFoot")&(Reader.NodeType="endelement")  q
		   }
	   }
	   if Reader.Name="MetaData"
	   {
		   while Reader.Read()
		   {
		     if $find(Reader.Name,"B")'=0
		     {
			        s itmname=Reader.Name
			    	if (Reader.MoveToAttributeName("Rel"))
				    {
					  s TMPITM(itmname)=Reader.Value
					  s TMPITMData(Reader.Value)=""
					//  w !,Reader.Value
					
					}
					
			 }
		     if (Reader.Name="MetaData")&(Reader.NodeType="endelement")  q
		   }
	   }
	   if Reader.Name="WinTmp"
	   {
	      while Reader.Read()
	      {
	   	      s path=Reader.Path
	   	      if Reader.Name["Tmp"
	   	      {
				    if (Reader.MoveToAttributeName("WinCode"))
				    {
					  s TMP(Reader.Value)=""
					}
		   	  }
     	   	  if (Reader.Name="WinTmp")&(Reader.NodeType="endelement")  q
	      }
	   }
	   
	   if Reader.Name="InstanceData"
		{
		   while Reader.Read()
		   {
			 // b
		      s itmname=Reader.Name
		      if itmname="" continue
		
			      s lb=$E(itmname,0,5)

			      if ($F(lb,"Label")'="0")
			      {
				    if (Reader.MoveToAttributeName("text"))
				    {
					 // if itmdataVal(code,itmname)'="" s itmdataVal(code,itmname)=itmdataVal(code,itmname)_"@"_Reader.Value
					  s itmLabelVal(EmrCode,itmname)=Reader.Value
					 // b ///----0
					}
				   // b //ooooo(注:总分<=17分,可上报不可避免压疮)
	              // w !,itmname
				  }
              
             if (Reader.Name="InstanceData")&(Reader.NodeType="endelement")  q

		   }
		}
	   
	   
	 //  w !,Reader.Name
	  // if Reader.EOF q安徽省立医院护理不良/意外事件报告表
	}

    s ItmRelName=""
    s ItmLink=""
	s itm="" f  s itm=$O(TMPITMData(itm)) q:itm=""  d
	.s ItmData($P(itm,"."),$P(itm,".",2))=""
	//b //按界面取值取值
    if mulid'=""
    {
		s tcode="" f  s tcode=$O(TMP(tcode)) q:tcode=""  d
	    .s rw=##class(NurEmr.DHCMgEmrDataChild).getmultiId(tcode,mulid)
	    .//b mukl
	    .if rw'="" d ..getItmData(.ItmData,.ItmRelName,.ItmLink,tcode,rw) 
    }else
    {
	
	 s tcode="" f  s tcode=$O(TMP(tcode)) q:tcode=""  d
     .s aa=..getItmData(.ItmData,.ItmRelName,.ItmLink,tcode,Id) 
     .if (Id'="")&(aa="id") d
     ..d ..getItmData(.ItmData,.ItmRelName,.ItmLink,tcode,"") 
	}
	//b  //
	//先将数据取出根据关键值放入数据   s a(i)=##class(web.DHCNUREMR).GetData(mth,par)
	//根据键值 关联界面元素 if $D(ItmRelName(code,it)) s value=$G(tmval(ItmRelName(code,it)))
   // s rw##class(NurEmr.NuEmrData).getmultiId(code,mulid)
    d Reader.Rewind()
    s a=""

    
    s l=$L(mthpar,"|")
    s tabledata=""
	f i=1:1:l
	{
	  s mp=$P(mthpar,"|",i)
	  
	  if mp="" continue
	 
	  i mp["$" s mth=$P(mp,"$",1),par=$P(mp,"$",2)
	  i mp["&" s mth=$P(mp,"&",1),par=$P(mp,"&",2)
	  s c="" f  s c=$O(ItmLink(c)) q:c=""  d
	  .s n=""  f  s n=$O(ItmLink(c,n)) q:n=""  d
	  ..q:ItmLink(c,n)=""
	  ..b //sdeeeee
	  ..if ($F(mp,ItmLink(c,n))'=0) d
	  ...s aa=##class(web.DHCPregPrint).GetQueryData(mth,par)  ///dddd
	  ...b //ddd555555
	  ...s tabledata(c,n)=aa
	  ...s mp=""
	  if mp="" continue
	  b //mth
	  s a(i)=##class(web.DHCNUREMR).GetData(mth,par)
	  b  ////000
	  if mth'="web.DHCConsult:getConsultInfo" s a(i)=$TR(a(i),"|","&")
	  

	}
	s tmval=""
	s m=""  f  s m=$O(a(m)) q:m=""  d
	.if a(m)="" q
	.s l=$L(a(m),"^")
	.for i=1:1:l d
	..s itm=$P(a(m),"^",i)
	..q:itm=""
	..s p=$P(itm,"&",1)
	..///s v=$P(itm,"&",2)
	..s v=..MergeStr(itm,"&",2)
	..s tmval(p)=v
    ///InstanceData  付值 10-10-20
    s itm=""  f  s itm=$O(itmLabelVal(EmrCode,itm)) q:itm=""  d
    .if $D(tmval(itmLabelVal(EmrCode,itm))) d
    ..s itmLabelVal(EmrCode,itm)=tmval(itmLabelVal(EmrCode,itm))
    .e  k itmLabelVal(EmrCode,itm)
   // s a=##class(%system)
    b //bmmmmd
    Set datastream=##class(%GlobalCharacterStream).%New()
   b //8888888
    s itm="" f  s itm=$O(TMPITM(itm)) q:itm=""  d
    .s str=TMPITM(itm)
	.s code=$P(str,"."),it=$P(str,".",2)
	.s value=ItmData(code,it)
	.s dataval=ItmData(code,it)
	.if $D(tabledata(code,it)) d
	..s value=..gettabledata(value,tabledata(code,it))
	..//b //9999999999999999999999
	.s flag="0"
	.s selval=""
	.//b  ///==
	.if $G(ItmRelName(code,it))'="" d  //	.i (mthpar'="")&($F(it,"T")=0) d
	..if $G(ItmRelName(code,it))'="" s value=$G(tmval(ItmRelName(code,it)))
	..e  s value=$G(tmval(it))
    ..if $find(it,"R")'=0 d
	...s dval=dataval
	...//s selval=..getmulval(dval,value)
	...s selval=..getradioval(dval,value)
	...s flag="1"
    ..if $find(it,"M")'=0 d
	...s dval=dataval
	...s selval=..getmulval(dval,value)
	...s flag="1"
	..if $find(it,"O")'=0 d
	...s dval=dataval
	...s selval=..getsinglval(dval,value)
	...s flag="1"
	..if $find(it,"I")'=0 d
	...if value'="" d
	....s value=$TR(value,"!","|")
	....i ($d(^SSU("SSUSR",value))) s value=value_"|"_$p(^SSU("SSUSR",value),"^",2)  //签名
    . //b v1
	.if flag="1" s value=selval
	.s value=##class(web.DHCNUREMR).Replace(value,"&KeyEnter;","\n")    //, 
	.;s value=##class(web.DHCNUREMR).Replace(value,"&","\\")    //, 
	.s value=$ZCVT(value,"O","XML")
	.//w ! ,code,"--",value,"--",it,"--",itm
    .s a=a_"<"_itm_" typ="""_it_""">"_##class(web.DHCNUREMR).Replace(value,"&nbsp;"," ")_"</"_itm_">"
    
    s itm=""  f  s itm=$O(itmLabelVal(EmrCode,itm)) q:itm=""  d
    .s value=itmLabelVal(EmrCode,itm)
    .s a=a_"<"_itm_" typ="""_itm_""">"_##class(web.DHCNUREMR).Replace(value,"&nbsp;"," ")_"</"_itm_">"
    s b="<?xml version='1.0' encoding='UTF-8'?>"
    s a=b_"<Root>"_a_"</Root>"
    
    
   // s b="<?xml version='1.0' encoding='UTF-8'?>"
   // s a=b_"<?xml version='1.0' encoding='UTF-8'?><Root><B9 typ='T101'>63^45^0^0^1^0^0^S102^CareDate^日期|63^44^1^0^2^45^0^S103^CareTime^时间|63^42^2^0^3^89^0^S104^Item1^护理级别|63^38^3^0^4^131^0^S105^Item2^饮食|63^37^4^0^5^169^0^S106^Item3^意识|63^3^5^0^6^206^0^S107^Item4^T(?)|63^38^6^0^7^244^0^S108^Item5^P/HR(次/分)|63^38^7^0^8^282^0^S109^Item6^R(次/分)|63^49^8^0^9^320^0^S110^Item7^BP(mmHg)|63^38^9^0^10^369^0^S111^Item9^SPO2(%)|63^38^10^0^11^407^0^S112^Item10^吸氧(升/分)|63^37^11^0^12^445^0^S113^Item11^切口敷料|23^111^12^0^13^482^0^^^入液量(ml)|23^130^13^0^15^593^0^^^出液量(ml)|63^45^14^0^18^723^0^S119^Item17^其他1|63^45^15^0^19^768^0^S120^Item18^其他2|63^135^16^0^20^813^0^S121^CaseMeasure^病情观察及护理措施|63^44^17^0^21^948^0^S122^User^签名|63^3^18^0^22^992^0^S124^DiagnosDr^DiagnosDr|40^68^19^1^13^482^23^S114^Item12^名称_|40^43^20^1^14^550^23^S115^Item13^量_|40^50^21^1^15^593^23^S116^Item14^名称|40^41^22^1^16^643^23^S117^Item15^量|40^39^23^1^17^684^23^S118^Item16^颜色性状|\\CareDate^CareTime^Item1^Item2^Item3^Item4^Item5^Item6^Item7^Item9^Item10^Item11^Item12^Item13^Ite14^Item15^Item16^Item17^Item18^CaseMeasure^User^DiagnosDr^$23^40^23^40^23^40^23^40^23^40^23^$45^44^42^38^37^38^38^38^49^38^38^37^68^43^50^41^39^45^45^135^44^3^$!!!!!!!!!!!!!!!!!!!!!!^!!!!!!!!!!!!!!!!!!!!!!^!!!!!!!!!!!!!!!!!!!!!!^!!!!!!!!!!!!!!!!!!!!!!^!!!!!!!!!!!!!!!!!!!!!!^!!!!!!!!!!!!!!!!!!!!!!^!!!!!!!!!!!!!!!!!!!!!!^!!!!!!!!!!!!!!!!!!!!!!^!!!!!!!!!!!!!!!!!!!!!!^</B9></Root>"

    d datastream.Write(a)
    q datastream
    ///如果传进的方法与table的关联方法相同 就作为table的方法
}

ClassMethod gettabledata(olddata, newdata) As %String
{
  s str=$P(olddata,"$",1)
  s rowsize=$P(olddata,"$",2)
  s colsize=$P(olddata,"$",3)
  s relstr=$P(str,"&",2)
  s head=$P(str,"&",1)
  s rows=$L(newdata,"&")
  s ldata=$P(olddata,"$",4)
  s olrows=$L(ldata,"^")
  b //0000000000000000000
  for r=1:1:rows
  {
    s dat=$P(newdata,"&",r)
    s cl=$l(dat,"^")
    if dat="" continue
    for c=1:1:cl
    {
	   s itm=$P(dat,"^",c)
	   if itm="" continue
	   s d=$P(itm,"|")
	   s v=$P(itm,"|",2)
	   s t(r,d)=v
	}
  }
  s ret=""
  s rh=20
  for r=1:1:olrows
  {
	  //s rowsize=rowsize_"^"_rh
	  s l=$L(relstr,"^")
	  s rd=""
	  if '$D(t(r))  //新数据不够的补旧数据
	  {
	    s ret=ret_$P(ldata,"^",r)_"^"
	    continue
	  }
	  f i=1:1:l
	  {
	   s n=$P(relstr,"^",i)
	   if n="" continue
	   s rd=rd_t(r,n)_"!"
	  }
	 // b //col
	  s ret=ret_rd_"^"
  }
  s ret=head_"$"_rowsize_"$"_colsize_"$"_ret
  b
  q ret
}

ClassMethod getsinglval(val, sel) As %String
{
  //单选
  //
    //s ^TMP("fff",val)=sel
   s ^TMPTYSING=val_"^"_sel	
   s arr=$P(val,"@")
   s l=$L(arr,"!")
   s selitm=""
   s code=""
   s sel=$P(sel,"!")
   for i=1:1:l
   {
     s itm=$P(arr,"!",i)
     s des=$P(itm,"|")
     s v=$P(itm,"|",2)
     s code=code_des_"!"
     if v=sel 
     {
	     s selitm=des_"|"_des //v_"|"_des
	     
     }
     if des=sel 
     {
	     s selitm=des_"|"_des //v_"|"_des
     }
     i i=sel
     {
	     s selitm=des_"|"_des
	 }
     i (i=l)&&(selitm="") d
     .s selitm=sel_"|"_sel
   }
   q code_"@"_selitm
}

ClassMethod getmulval(val, sel) As %String
{
  //多选
   b ;2
   s arr=$P(val,"@")
   s l=$L(arr,"!")
   s selitm=$TR(sel,";","^")
   s code=""
   for i=1:1:l
   {
     s itm=$P(arr,"!",i)
     s des=$P(itm,"|")
     s v=$P(itm,"|",2)
     s code=code_des_"!"
   }
   
   q code_"@"_selitm
}

ClassMethod getradioval(val, sel) As %String
{
  //R单选
   
   s arr=$P(val,"@")
   s l=$L(arr,"!")
   //s selitm=$TR(sel,";","^")
   s selitm=$TR(sel,";","")
   s code=""
   for i=1:1:l
   {
     s itm=$P(arr,"!",i)
     s des=$P(itm,"|")
     s v=$P(itm,"|",2)
     s code=code_des_"!"
   }
   b ;2
   q selitm
}

ClassMethod GetContinueFlag(code) As %String
{
 ///s a=##class(web.DHCNUREMR).GetContinueFlag()
  	  s str=##class(NurEmr.NurEmrSub).getData(code)
  	  s Flag=""
	  if (str'="")
	  {
		  S ITM=##CLASS(NurEmr.NurEmrSub).%OpenId(str)
		  s Data=ITM.EmrSubData
          s Reader=..GetReader(code,Data)
          
	      while Reader.Read()
	      {
	        	if Reader.Name="InstanceData"	
	        	{
		           if (Reader.MoveToAttributeName("Continue"))
		           {
			         s Flag=Reader.Value
			       }
			       b
		        } 
		  }
	  }
	  q Flag
}

ClassMethod getItmData(itmdata, itmRelName, itmLink, code, id) As %String
{
  
	s ITM=""
	S Data=""
  b //////////////////ppppp
    if id'=""
    {
	   s ITM=##class(NurEmr.DHCMgEmrDataChild).%OpenId(id)
	   s itcode=ITM.EmrCode
	   b /////----------------------------
	   q:code'=itcode "id"
	   s Data=ITM.EmrData
	//  if id="54"  b  ///
	}else{
	  s str=##class(NurEmr.NurEmrSub).getData(code)
      if str'="" 
	   {
		S ITM=##CLASS(NurEmr.NurEmrSub).%OpenId(str)
		s Data=ITM.EmrSubData
	   }else
	   {
	    q ""
	   }
	}
	
	d Data.Rewind()
	 //if code="DHCNurOpCheckPrn" w !,"dddddddddddddssww"
	 //b/////t
   // Set sc = ##class(%XML.TextReader).ParseStream(Data,.Reader)
    if id'="" s Reader=..GetReader(id,Data)
    e  s Reader=..GetReader(code,Data)
      
	while Reader.Read()
	{
		s tt=Reader.Name
		if $E(tt,0,1)="T"
		{
              if Reader.MoveToAttributeName("Head") s TableHead(code,tt)=Reader.Value
             // b //dddd222
	    }
	    if Reader.Name="MetaData"
	    {
		   while Reader.Read()
           {
	      	  if (Reader.Name="MetaData")&(Reader.NodeType="endelement")  q
              s itmname=Reader.Name
	   	      if ($E(Reader.Name,0,1)="M")!($E(Reader.Name,0,1)="O")!($E(Reader.Name,0,1)="R")
	   	       {
	         	  if Reader.MoveToAttributeName("RelName") s itmRelName(code,itmname)=Reader.Value
                  s itm=..getpritm(.Reader,itmname,.itmdata,code)
	   	       }
 		    // w !,Reader.Name," //00",Reader.Path
		    // if Reader.Name="T11" b
              s xname=Reader.Name
	          if Reader.MoveToAttributeName("RelName") s itmRelName(code,xname)=Reader.Value
              if Reader.MoveToAttributeName("Link") s itmLink(code,xname)=Reader.Value
              if Reader.MoveToAttributeName("hidden") 
		      {
			     //s itmHidd(code,xname)=Reader.Value
			      if ((Reader.Value="Y")&($E(xname,0,1)="S"))
			      {
				      k itmLink(code,xname)
				       /// b hide
			      }
		      }
      // if itmname="xname" b  //66666
             // if code="DHCNurOpCheckPrn" w !,xname
	          if ($E(xname,0,1)="T")
	          {
		        s title="",RelStr=""
			      while Reader.Read()
			      {
				     if (Reader.Name=xname)&(Reader.NodeType="endelement")  q
				      if (Reader.MoveToAttributeName("Title"))
				      {
					     s title=title_Reader.Value_"^"
					  }
	               if (Reader.MoveToAttributeName("RelName"))
				      {
					     s RelStr=RelStr_Reader.Value_"^"
					  }
	
				  }
				  if $G(TableHead(code,xname))'=""
				  {
					s itmdata(code,xname)=TableHead(code,xname)_"&"_RelStr
					b //tabheaddddddddddddddddddddddddddddddd
				  }
				  else{
			         s itmdata(code,xname)=title_"&"_RelStr
			         b //tabhead1////////////////
				   }
		     }
	       }
	  

		}
       // w !,Reader.Name ,"--------"

		if Reader.Name="InstanceData"
		{
		   while Reader.Read()
		   {
			 // w !, Reader.Name
			 // b
		      s itmname=Reader.Name
		      if itmname="" continue
		      if $D(itmdata(code,itmname))
		      {
			      s lb=$E(itmname,0,1)
			      if lb="O"
			      {
				     // b //ooooo(注:总分<=17分,可上报不可避免压疮)
				    if (Reader.MoveToAttributeName("selecttext"))
				    {
					  if itmdata(code,itmname)'="" s itmdata(code,itmname)=itmdata(code,itmname)_"@"_Reader.Value
					  e  s itmdata(code,itmname)=Reader.Value
					 // b ///----0
					}else{
						s itmdata(code,itmname)=itmdata(code,itmname)_"@"
						}
				  }
                  if lb="I"
			      {
				     if (Reader.MoveToAttributeName("SelectItm"))
				     {                              
					  s itmdata(code,itmname)=Reader.Value
					 // s ^TM(code,itmname)=Reader.Value
					 }
                    ///bI
				  }
                  if lb="M"
			      {
				     if (Reader.MoveToAttributeName("selectItm"))
				     {
					  if itmdata(code,itmname)'="" s itmdata(code,itmname)=itmdata(code,itmname)_"@"_Reader.Value
					  e  s itmdata(code,itmname)=Reader.Value
					 }else{
						 s itmdata(code,itmname)=itmdata(code,itmname)_"@"
						 }
                   // b ///Mb不可避免压疮上报表
				  }
                  if lb="R"
			      {
				     if (Reader.MoveToAttributeName("selectItm"))
				     {
					  if itmdata(code,itmname)'="" s itmdata(code,itmname)=itmdata(code,itmname)_"@"_Reader.Value
					  e  s itmdata(code,itmname)=Reader.Value
					 }else{
						 s itmdata(code,itmname)=itmdata(code,itmname)_"@"
						 }
                   // b ///Mb不可避免压疮上报表
				  }
                  if lb="D"
			      {
				     if (Reader.MoveToAttributeName("DateTimeVal"))
				     {
					     
				      s aa=Reader.Value
				      s aa=$TR(aa,"^"," ")
					  s itmdata(code,itmname)=aa
					  //?  b??
					 }else{
						// s itmdata(code,itmname)=$ZD(+$H,3)
						// b ////////////ds
						 }
                    
				  }
                  if lb="S"
			      {
				     
				     if (Reader.MoveToAttributeName("text"))
				     {
					  s itmdata(code,itmname)=Reader.Value
					 }
				  }
                  if lb="T"
			      {
				      if itmdata(code,itmname)'="" s itmdata(code,itmname)=itmdata(code,itmname)_"$"_..getfree(Reader,Reader.Name)
					  e  s itmdata(code,itmname)=..getfree(Reader,Reader.Name)
					 // b ///////////////////////////////
					  //s itmdata(code,itmname)=..getfree(Reader,Reader.Name)
				  }
                  if lb="G"
			      {
				           s str=""
				    	   while Reader.Read()
		                   { 
		                   //b  //888888888888888888
		                    if (Reader.Name=itmname)&(Reader.NodeType="endelement")  q
		                     s lb=$E(Reader.Name,0,1)
		                     if lb="F"
		                     {
			                   s str=str_..getfree(Reader,Reader.Name)
			                 }
			                 if lb="S"
			                 {
				                   if (Reader.MoveToAttributeName("Value"))
				                    {
					                    s str=str_Reader.Value
					                }else{
						            }
				             }
		                     if lb="O"
			                 {
				                   if (Reader.MoveToAttributeName("Value"))
				                    {
					                    s str=str_Reader.Value
					                }else{
						            }
				             }
		                     if lb="M"
			                 {
				                   if (Reader.MoveToAttributeName("Value"))
				                    {
					                    s str=str_Reader.Value
					                }else{
						            }
				             }
		                     if lb="R"
			                 {
				                   if (Reader.MoveToAttributeName("Value"))
				                    {
					                    s str=str_Reader.Value
					                }else{
						            }
				             }
		                   if lb="N"
			                 {
				                   if (Reader.MoveToAttributeName("Value"))
				                    {
					                    s str=str_Reader.Value
					                }else{
						            }
				             }
		                     }
		                s itmdata(code,itmname)=str

				  }
              }
             if (Reader.Name="InstanceData")&(Reader.NodeType="endelement")  q

		   }
		}
}
 q "1"  //555555555555
}

ClassMethod getpdata(cls, mth, p, pdata, arr)
{
	           s data=##class(web.DHCMGPrintComm).GetData(cls_":"_mth,p)
	           if data'=""
	           {
		         s l=$L(data,"^")  //    s retStr="REGNO@"_regNo_"^LOC@"_ctlocDesc_"^ROOM@"_$g(room)_"^SEX@"_$g(sex)_"^PATNAME@"_$g(patName)_"^BEDCODE@"_$g(bedCode)_"^AGE@"_$g(age)_"岁^WARD@"_$g(wardDesc)_"^DIAG@"_diag
		         f i=1:1:l
		         {
			       s a1=$P(data,"^",i)
			       if a1="" continue
			       s nm=$P(a1,"@",1)
			       s nv=$P(a1,"@",2)
			       s bb(nm)=nv
			     }
			     s l=$l(arr,"@")
			     f i=1:1:l
			     {
				   s dd=$P(arr,"@",i)
				   if dd="" continue
				   s dm=$P(dd,"|",1)
				   s dv=$P(dd,"|",2)
				   s pdata(dm)=$G(bb(dv))
				 }
		       }
}

ClassMethod getpritm(Reader, itmname, itmdata, code) As %String
{
   
    s itm=""
	while Reader.Read()
	{
	 // q
      if (Reader.Name=itmname)&(Reader.NodeType="endelement")  q
      if ((Reader.Name="")&(Reader.NodeType="chars"))
      {
	      // s itm=itm_$P(Reader.Value,"|")_"!"
           s itm=itm_Reader.Value_"!"

      }
    //  w !,Reader.Name," //--",Reader.Value,"-NodeType-",Reader.NodeType
	}
    s itmdata(code,itmname)=itm
    q itm
}

// w ##class(web.DHCNUREMR).getcomflag("DHCNURANHUI3","134","")

ClassMethod getcomflag(code, EpisodeID, loc) As %String
{
  if (code="DHCNUREMRPIC") q ""
  s ^TMP("c")=code
  s id=##class(NurEmr.NurEmrSub).GetKCode(code)
  s flag=$listget(^NurEmr.NurEmrSubD(id),8)
  //s flag="Y" //测试用，上线后请屏蔽
  if flag'="Y"
  {
	 s a=##class(Nur.DHCMGNurseSet).getSet()
	 s generpath=$P(a,"^",3)
	 if ($E(generpath,$L(generpath))="\") s generpath=generpath_"\"
     if generpath="" s generpath="\\127.0.0.1\dhcmg\"
  	 if '##class(%Library.File).DirectoryExists(generpath)
	 {
		 s Result = ##class(%Library.File).CreateDirectoryChain(generpath) 
	 }
     Set file = ##class(%Library.File).%New(generpath_code_".js") 
     k ^NurEmr.NurEmrSubK("Kcode",code)
    // s a=##class(web.DHCNUREMR).getPagData("",code,"","")
     s a=##class(web.DHCNUREMR).getPagData("",code,EpisodeID,loc,"true")
     d file.Open("WNSK\UTF8\")
     d file.WriteLine("var sm = new Ext.grid.CheckboxSelectionModel();")
     d file.WriteLine("var sm1 = new Ext.grid.CheckboxSelectionModel();")
     d file.WriteLine("var sm2 = new Ext.grid.CheckboxSelectionModel();")
     d file.WriteLine("var sm3 = new Ext.grid.CheckboxSelectionModel();")

     s name=""  f  s name=$O(^NurEmr.NurEmrSubK("tablestore",code,name)) q:name=""  d
     .d file.WriteLine("var "_code_name_"="_^NurEmr.NurEmrSubK("tablestore",code,name)_";")
  
     d file.Write("var arr=")
     while ('(a.AtEnd))
     {
	     d file.Write(a.ReadLine())
     }
     d file.WriteLine(";")
     s id=""  f  s id=$O(^User.DHCNURMenuSubD(id)) q:(id="")  d  //只有护理病历模板去除底部tobar
     .s chl=""  f  s chl=$O(^User.DHCNURMenuSubD(id,chl)) q:(chl="")  d
     ..s a=##class(User.DHCNURMenuSub).%OpenId(id_"||"_chl)
     ..s ReccCode=$zcvt(a.Code,"U")
     ..s qcode="DHCDocShiftExchage^DHCNurShiftExchage^DHCNURxhsbfind" //交班本
     ..s qcode=$zcvt(qcode,"U")
     ..i (ReccCode=code)!(qcode[ReccCode)  d
     ...d file.WriteLine("if (typeof(arr[0].items)!=""undefined"") arr[0].items[0].getBottomToolbar().hide();")
     d ..writecomm(file)
     d file.Close()
     q file.SizeGet()
  }else
  {  
   q ""
  }
}

ClassMethod generatorJs(code) As %String
{
	//s a=##class(web.DHCNUREMR).generatorJs("DHCNURANHUI3")
	s ^TMP("aaa")=code
	 s a=##class(Nur.DHCMGNurseSet).getSet()
	 s generpath=$P(a,"^",3)
     if generpath="" s generpath="\\127.0.0.1\dhcmg\"
     k ^NurEmr.NurEmrSubK("Kcode",code)
  	 if '##class(%Library.File).DirectoryExists(generpath)
	 {
		 s Result = ##class(%Library.File).CreateDirectoryChain(generpath) 
		
	 }
     Set file = ##class(%Library.File).%New(generpath_code_".js") 
     s a=##class(web.DHCNUREMR).getPagData("",code,"","","true")
     
     // s ^TMP("aaa1")=generpath_code_".js"
     d file.Open("WNSK\UTF8\")
     d file.WriteLine("var sm = new Ext.grid.CheckboxSelectionModel();")
     d file.WriteLine("var sm1 = new Ext.grid.CheckboxSelectionModel();")
     d file.WriteLine("var sm2 = new Ext.grid.CheckboxSelectionModel();")
     d file.WriteLine("var sm3 = new Ext.grid.CheckboxSelectionModel();")
     s name=""  f  s name=$O(^NurEmr.NurEmrSubK("tablestore",code,name)) q:name=""  d
     .d file.WriteLine("var "_code_name_"="_^NurEmr.NurEmrSubK("tablestore",code,name)_";")
     //s retdata="男,女,看看空间" //##class(Nur.DHCNurHeadKnowledge).getdepHead(headcode,Loc)
	 //i retdata'="" d
	 //.s stordata=##class(web.DHCNUREMRHead).GetStoreByStr(retdata)
	 //.d file.WriteLine("var headstore="_stordata)
     d file.Write("var arr=")
     while ('(a.AtEnd))
     {
	     d file.Write(a.ReadLine())
     }
     d file.WriteLine(";")
     s id=""  f  s id=$O(^User.DHCNURMenuSubD(id)) q:(id="")  d  //只有护理病历模板去除底部tobar
     .s chl=""  f  s chl=$O(^User.DHCNURMenuSubD(id,chl)) q:(chl="")  d
     ..s a=##class(User.DHCNURMenuSub).%OpenId(id_"||"_chl)
     ..s ReccCode=$zcvt(a.Code,"U")
     ..s qcode="DHCDocShiftExchage^DHCNurShiftExchage^DHCNURxhsbfind" //交班本
     ..s qcode=$zcvt(qcode,"U")
     ..i (ReccCode=code)!(qcode[ReccCode)  d
     ...d file.WriteLine("if (typeof(arr[0].items)!=""undefined"") arr[0].items[0].getBottomToolbar().hide();")
     d ..writecomm(file)
     d file.Close()
     q file.SizeGet()
}

ClassMethod writecomm(file) As %String
{
  //var sm = new Ext.grid.CheckboxSelectionModel();

	d file.WriteLine("var pg=0;")
	d file.WriteLine("Ext.onReady(function() {")
	d file.WriteLine("if (pg>0) return ;")
    d file.WriteLine(" new Ext.form.FormPanel({")
	d file.WriteLine("height:600,")
	d file.WriteLine("width: 800,")
	d file.WriteLine("id:'gform',")
	d file.WriteLine("autoScroll:true,")
	d file.WriteLine("layout: 'absolute',")
	d file.WriteLine("items:arr,")
	d file.WriteLine("renderTo: Ext.getBody()")
    d file.WriteLine("});")
	d file.WriteLine("pg++;")
	d file.WriteLine("var fheight=document.body.offsetHeight;")
	d file.WriteLine("var fwidth=document.body.offsetWidth;")
	d file.WriteLine("var fm=Ext.getCmp('gform');")
	d file.WriteLine("fm.setHeight(fheight);")
	d file.WriteLine("fm.setWidth(fwidth);")

    d file.WriteLine("BodyLoadHandler();")
    d file.WriteLine("});")
    q 0
}

ClassMethod getPagData(itmdata, code, EpisodeId, Loc, ReturnStream = "false") As %GlobalCharacterStream
{
 // s a=##class(web.DHCNUREMR).getPagData("","DHCNUR2",338155,"")
    s headtmp=""
   // s %session.Data("LOGON.USERID")=4337
   
    ///取表格标题
   //i $D(%session) s a=##class(Nur.DHCNurRecHeadChangeRec).gethead(EpisodeId,%session.Data("LOGON.USERID"),code,.headtmp)
    i $D(%session) s a=##class(Nur.DHCNurRecHeadChangeRec).gethead(EpisodeId,$g(%session.Data("LOGON.USERID")),code,.headtmp)
  // s ^TMP("head11")=$LB(EpisodeId,%session.Data("LOGON.USERID"),code)
  // m ^TMP("head1")=headtmp
    s ITM=""    
	S Data=""
	s rowid=""
	
	s AnaesID=""
	if $D(%request)
	{
		 s AnaesID=$G(%request.Data("AnaesID",1))
		 	//  s ^TMP("anaes")=AnaesID
	}
	
	if EpisodeId'=""
    {
	     s parentid=##class(NurEmr.DHCMgEmrData).getEpisodeId(EpisodeId) 
    }
    if rowid="" 
    {
        s rowid=##class(NurEmr.DHCMgEmrData).getEpisodeIdRowId(EpisodeId,code) //getEpisodeIdRowId
    }
    if AnaesID'=""
    { ///2010-04-05 qse add
	  s rowid=##class(Nur.DHCNurAnaesRec).getNurAnaesId(code,AnaesID)
	 // s ^TMP("anaes")=rowid
	}
    s Data=""
   if rowid'=""
    {
	   // b  ///9999
	   s ITM=##class(NurEmr.DHCMgEmrDataChild).%OpenId(rowid)
	   s itcode=ITM.EmrCode
	   q:code'=itcode ""
	   s Data=ITM.EmrData
	    ///b/////////9999999
	//  if id="54"  b  ///
	}else{
        s str=##class(NurEmr.NurEmrSub).GetKCode(code)
        if str="" s str=##class(NurEmr.NurEmrSub).getData(code)
       if str'=""   
	   {
		S ITM=##CLASS(NurEmr.NurEmrSub).%OpenId(str)
		s Data=ITM.EmrSubData
		s title=ITM.EmrSubDesc
		//b ///33
	   }else
	   {
	    q ""
	   }
	}
	d Data.Rewind()

	
	////////////////////b ppppp
	///b ////t
  // Set sc = ##class(%XML.TextReader).ParseStream(Data,.Reader)
    s Reader=..GetReader(code,Data)

	//Set datastream=##class(%GlobalCharacterStream).%New()
   // d datastream.Write(xml)
	while Reader.Read()
	{
		if Reader.Name="MetaData"
	    {
		   s aa=""
		   if Reader.MoveToAttributeName("Link") s aa=Reader.Value
           if aa'=""
           {
	           s cls=$P(aa,"^"),mth=$P(aa,"^",2)
	           s p=$P(aa,"^",3)
	           s arr=$P(aa,"^",4)
	           if p="Adm" s p=p_":"_EpisodeId
	           if p="AnaesID" s p=p_":"_AnaesID
	           s pdata=""
	           if EpisodeId'=""
	           {
	            d ..getpdata(cls,mth,p,.pdata,arr)
	           }
           }
		   while Reader.Read()
           {
	      	  if (Reader.Name="MetaData")&(Reader.NodeType="endelement")  q
              s itmname=Reader.Name
	   	      if ($E(Reader.Name,0,1)="M")!($E(Reader.Name,0,1)="O")!($E(Reader.Name,0,1)="R")
	   	       {
	          	 if Reader.MoveToAttributeName("RelName") s itmRelName(code,itmname)=Reader.Value
 		         if Reader.MoveToAttributeName("Link") s itmLinkName(code,itmname)=Reader.Value
                 if Reader.MoveToAttributeName("Title") s itmTitle(code,itmname)=Reader.Value
                s itm=..getitm(.Reader,itmname,.itmdata,code)
	   	       }
 		    // w !,Reader.Name," //00",Reader.Path
		    // if Reader.Name="T11" b
              s xname=Reader.Name
	          if Reader.MoveToAttributeName("RelName") s itmRelName(code,xname)=Reader.Value
		      if Reader.MoveToAttributeName("Link") s itmLinkName(code,xname)=Reader.Value
		      if Reader.MoveToAttributeName("Title") s itmTitle(code,xname)=Reader.Value
		      if Reader.MoveToAttributeName("Edit") s itmEdit(code,xname)=Reader.Value
		      if Reader.MoveToAttributeName("CheckSel") s itmCheckSel(code,xname)=Reader.Value
		      if Reader.MoveToAttributeName("hidden") 
		      {
			      s itmHidd(code,xname)=Reader.Value
			      if ((Reader.Value="Y")&($E(xname,0,1)="S"))
			      {
				       s itmdata(code,xname)=""
				       /// b hide
			      }
		      }
              if ($E(xname,0,1)="T")
	          {
		        //显示顺序按表头分组
                d ..getTtitle(xname,code)
                s itmifor=""
		        s title=""
		          
			      while Reader.Read()
			      {
         		     if (Reader.Name=xname)&(Reader.NodeType="endelement")  q
		             s colname=Reader.Name
		             s itmtable(code,colname)=""

                   if ($E(Reader.Name,0,1)="M")!($E(Reader.Name,0,1)="O")!($E(Reader.Name,0,1)="I")!($E(Reader.Name,0,1)="R")
				     {	
				         if Reader.NodeType="endelement" continue
				     	 if (Reader.MoveToAttributeName("Title")) s head=Reader.Value
	            	     if Reader.MoveToAttributeName("Link") s itmLinkName(code,colname)=Reader.Value

		                 if Reader.MoveToAttributeName("RelName") s Relname=Reader.Value
		                 if Reader.MoveToAttributeName("Pos") s Pos=Reader.Value
		                 s title=title_$G(head)_"!"_$G(Relname)_"!"_colname_"!"_$G(Pos)_"^"
		                 s itmifor(colname)=$G(head)_"!"_$G(Relname)_"!"_colname_"!"_$G(Pos)_"^"
			             if Reader.NodeType'="endelement" s itm=..getitm(.Reader,colname,.itmdata,code)
					 }else{
						 if Reader.NodeType="endelement" continue
				     	 if (Reader.MoveToAttributeName("Title")) s head=Reader.Value
		                 if Reader.MoveToAttributeName("RelName") s Relname=Reader.Value
		                 if Reader.MoveToAttributeName("Pos") s Pos=Reader.Value
		                 s title=title_$G(head)_"!"_$G(Relname)_"!"_colname_"!"_$G(Pos)_"^"
		                 s itmifor(colname)=$G(head)_"!"_$G(Relname)_"!"_colname_"!"_$G(Pos)_"^"
					 }
				         if (Reader.MoveToAttributeName("DateFlag"))
				        {
					       if Reader.Value="Y" s itmdata(code,colname)=Reader.Value_"^D"
					    }
					    if (Reader.MoveToAttributeName("TimeFlag"))
				        {
					       if Reader.Value="Y" s itmdata(code,colname)=Reader.Value_"^T"
					   
					    }

				  }
				  
			      //s itmdata(code,xname)=title
			      s str=""
				  s i="" f  s i=$o(^DHCNurEmrGen2(i)) q:i=""  d
				  .s itm=""  f  s itm=$o(^DHCNurEmrGen2(i,itm)) q:itm=""  d
				  ..s val=$g(itmifor(itm))
				  ..q:val=""
				  ..i str="" d
				  ...s str=val
				  ..e  d
				  ...s str=str_val
			      s itmdata(code,xname)=str  
		     }
		     // w !,xname
		      
              if ($E(xname,0,1)="D")
	          {
		        if (Reader.MoveToAttributeName("DateFlag"))
		        {
			       if Reader.Value="Y" s itmdata(code,xname)=Reader.Value_"^D"
			   
			    }
			    if (Reader.MoveToAttributeName("TimeFlag"))
		        {
			       if Reader.Value="Y" s itmdata(code,xname)=Reader.Value_"^T"
			    }
		      }
	       }

		}
		if Reader.Name="InstanceData"
		{
		   while Reader.Read()
		   {
			 // b
		      s itmname=Reader.Name
		      if itmname="" continue
		
			      s lb=$E(itmname,0,1)

			      if lb="O"
			      {
				     // b //ooooo(注:总分<=17分,可上报不可避免压疮)
				    if (Reader.MoveToAttributeName("selecttext"))
				    {
					 // if itmdataVal(code,itmname)'="" s itmdataVal(code,itmname)=itmdataVal(code,itmname)_"@"_Reader.Value
					 s itmdataVal(code,itmname)=Reader.Value
					 // b ///----0
					}else{
						s itmdataVal(code,itmname)=$G(itmdataVal(code,itmname))
						}
				  }
                  if lb="I"
			      {
				     if (Reader.MoveToAttributeName("SelectItm"))
				     {
					  s itmdataVal(code,itmname)=Reader.Value
					 }
                   // b ///M
				  }
                  if (lb="M")!(lb="R")
			      {
				     if (Reader.MoveToAttributeName("selectItm"))
				     {
					  if $G(itmdataVal(code,itmname))'="" s itmdataVal(code,itmname)=Reader.Value
					  e  s itmdataVal(code,itmname)=Reader.Value
					 }else{
						 s itmdataVal(code,itmname)=$G(itmdataVal(code,itmname))
						 }
                   // b ///Mb不可避免压疮上报表
				  }
                  if lb="D"
			      {
				     if (Reader.MoveToAttributeName("DateTimeVal"))
				     {
					     
				      s aa=Reader.Value
				      s aa=$TR(aa,"^"," ")
					  s itmdataVal(code,itmname)=aa
					 // b  //???
					 }else{
						// s itmdata(code,itmname)=$ZD(+$H,3)
						// b ////////////ds
						 }
                    
				  }
                  if lb="S"
			      {
				     
				     if (Reader.MoveToAttributeName("text"))
				     {
					  s itmdataVal(code,itmname)=Reader.Value
					 }
				  }

			      if lb="G"
			      {
				         s str=""
						 if Reader.MoveToAttributeName("type") s typ= Reader.Value
					     if Reader.MoveToAttributeName("tabindex") s tab= Reader.Value
					     if Reader.MoveToAttributeName("left") s x= Reader.Value
					     if Reader.MoveToAttributeName("top") s y= Reader.Value
					     if Reader.MoveToAttributeName("width") s w= Reader.Value
					     if Reader.MoveToAttributeName("height") s h= Reader.Value
						 if Reader.MoveToAttributeName("text") s text= Reader.Value
						 if $G(itmdata(code,itmname))'="" s itmdata(code,itmname)=itmdata(code,itmname)_"@"_typ_"^"_x_"^"_y_"^"_h_"^"_w_"^"_text_"^"_tab
						 e  s itmdata(code,itmname)=typ_"^"_x_"^"_y_"^"_h_"^"_w_"^"_text_"^"_tab
				    	   while Reader.Read()
		                   { 
		                   //b  //888888888888888888
		                    if (Reader.Name=itmname)&(Reader.NodeType="endelement")  q
		                     s lb=$E(Reader.Name,0,1)
		                   //	w !,Reader.Name
                             if lb="F"
		                     {
			                   s str=str_..getfree(Reader,Reader.Name)
			                  // b
			                 }
			                if lb="S"
			                 {
				                   if (Reader.MoveToAttributeName("Value"))
				                    {
					                    s str=str_Reader.Value
					                }else{
						            }
				             }
		                     if lb="O"
			                 {
				                   if (Reader.MoveToAttributeName("Value"))
				                    {
					                    s str=str_Reader.Value
					                }else{
						            }
				             }
		                     if lb="R"
			                 {
				                   if (Reader.MoveToAttributeName("Value"))
				                    {
					                    s str=str_Reader.Value
					                }else{
						            }
				             }
		                     if lb="M"
			                 {
				                   if (Reader.MoveToAttributeName("Value"))
				                    {
					                    s str=str_Reader.Value
					                }else{
						            }
				             }
		                   if lb="N"
			                 {
				                   if (Reader.MoveToAttributeName("Value"))
				                    {
					                    s str=str_Reader.Value
					                }else{
						            }
				             }

			                 s itmdataVal(code,itmname)=str
		                   }
		                   
			      }
		      
              if ($E(itmname,0,1)="T") 
              {
                 // s typ=Reader.Value
			     if Reader.MoveToAttributeName("type") s typ= Reader.Value
			     if Reader.MoveToAttributeName("tabindex") s tab= Reader.Value
			     if Reader.MoveToAttributeName("left") s x= Reader.Value
			     if Reader.MoveToAttributeName("top") s y= Reader.Value
			     if Reader.MoveToAttributeName("width") s w= Reader.Value
			     if Reader.MoveToAttributeName("height") s h= Reader.Value
				 if Reader.MoveToAttributeName("text") s text= Reader.Value
				 //b  //table
				 if $G(itmdata(code,itmname))'="" s itmdata(code,itmname)=itmdata(code,itmname)_"@"_typ_"^"_x_"^"_y_"^"_h_"^"_w_"^"_text_"^"_tab
				 e  s itmdata(code,itmname)=typ_"^"_x_"^"_y_"^"_h_"^"_w_"^"_text_"^"_tab
	          	 s itmtableData(code,itmname)=..getfree(Reader,itmname)
	          }
		      if Reader.MoveToAttributeName("type")
		      { ///left="537" top="537" ofx="0" ofy="0" width="53" height="21"
			     s typ=Reader.Value
			     if Reader.MoveToAttributeName("tabindex") s tab= Reader.Value
			     if Reader.MoveToAttributeName("left") s x= Reader.Value
			     if Reader.MoveToAttributeName("top") s y= Reader.Value
			     if Reader.MoveToAttributeName("width") s w= Reader.Value
			     if Reader.MoveToAttributeName("height") s h= Reader.Value
				 if Reader.MoveToAttributeName("text") s text= Reader.Value
				 if $G(itmHidd(code,itmname))="Y" q
				 if $G(itmdata(code,itmname))'="" s itmdata(code,itmname)=itmdata(code,itmname)_"@"_typ_"^"_x_"^"_y_"^"_h_"^"_w_"^"_$G(text)_"^"_tab
				 e  s itmdata(code,itmname)="@"_typ_"^"_x_"^"_y_"^"_h_"^"_w_"^"_$G(text)_"^"_tab
				 
			  }
	         
             if (Reader.Name="InstanceData")&(Reader.NodeType="endelement")  q

		   }
		}
}
 // m ^TMP("bbb")=itmLinkName
 s ff=##class(%GlobalCharacterStream).%New()
 d ff.Write("[")
 s i=0
  // b  ///>>>
 // m ^TMP("link")=itmLinkName
 s cc=""  f  s cc=$O(pdata(cc)) q:cc=""  d
 .s itmdataVal(code,cc)=pdata(cc)
 s name=""  f  s name=$O(itmdata(code,name)) q:name=""  d
 .q:$D(itmtable(code,name))
 .s hflag=$G(itmHidd(code,name))
 .if hflag="Y" d
 ..s ^NurEmr.NurEmrSubK("Kcode",code,name)=itmLinkName(code,name)_":"_itmRelName(code,name)
 ..s code2=$zcvt(code,"U")
 ..i '$d(^NurEmr.NurEmrSubK("Kcode",code2,name)) s ^NurEmr.NurEmrSubK("Kcode",code2,name)=itmLinkName(code,name)_":"_itmRelName(code,name)
 .q:hflag="Y"
 .s a1=$P(itmdata(code,name),"@")
 .//s ^TMP("a1")=itmdata(code,name)
 .s a2=$P(itmdata(code,name),"@",2)
 .s link=$G(itmLinkName(code,name))
 .s aa=""
 .s RelName=$G(itmRelName(code,name))
 .if RelName="" s cnname=name
 .e  s cnname=RelName
 .//if $E(name,0,1)="T" q
 .if $F(itmdata(code,name),"@")=0 s aa=itmdata(code,name)
 .e  s aa=a2
 .s typ=$P(aa,"^",1)
 .if (typ="DesignForm.QHLine")!(typ="DesignForm.QVline")!(typ="DesignForm.QVline") q
 .s x=$P(aa,"^",2)
 .s y=$P(aa,"^",3)
 .s h=$P(aa,"^",4)
 .s w=$P(aa,"^",5)
 .s text=$P(aa,"^",6)
 .s tab=$P(aa,"^",7)
 .s title=$G(itmTitle(code,name))
 .s i=i+1
 .//if i>42 q
 .s flag="0"
 . // s b=b_"{tabIndex:'"_1_"',name:'grr',xtype:'panel',x:"_0_",y:"_200_",height:"_200_",width:"_400_",border:false,items:[{xtype:'grid',stripeRows: true,name:'hhh',title:'dddf',height:200,width:400,store:"_..getstore()_",columns:"_..getcols()_"}]}," 
 .if $E(name,0,1)="T" d
 ..s xtype="grid"
 ..s flag=1
 ..s grphead=..GetGrpHead(name,code)
 ..s check="N" ,sm="" //复选 grid
 ..s RowSel=",sm: new Ext.grid.RowSelectionModel({ singleSelect:false})"
 ..if $G(itmCheckSel(code,name))="Y" d
 ...s grphead="",check="Y",sm=",sm:sm",RowSel=""
 ...if cnname="mygrid1" s sm=",sm:sm1"
 ...if cnname="mygrid2" s sm=",sm:sm2"
 ...if cnname="mygrid3" s sm=",sm:sm3"
 ..//b //gggggggg
 ..s vastr=itmtableData(code,name)
 ..b
 ..s widstr=$P(vastr,"$",2)
 ..s griddata=""
 ..if link'="" d
 ...s cls=$P(link,":",1),mth=$P(link,":",2),parrm=$P(link,":",3),dl=$P(link,":",4),vl=$P(link,":",5)
 ...s stdata=..GenerateMetaData(a1,cls,mth)
 ...s ^NurEmr.NurEmrSubK("tablestore",code,name)=stdata
 ...s griddata=code_name
 ..e  d
 ...s stdata=..getstore1(a1,vastr)
 ...s ^NurEmr.NurEmrSubK("tablestore",code,name)=stdata
 ...s griddata=code_name
 ..s editflag=$G(itmEdit(code,name))
 ..
 ..if editflag="Y" d
 ...if grphead="" d ff.Write("{id:'"_cnname_"pl',name:'"_cnname_"',tabIndex:'"_tab_"',x:"_x_",y:"_y_",height:"_h_",width:"_w_",xtype:'panel',layout:'fit',border:false,items:[new Ext.grid.EditorGridPanel({id:'"_cnname_"'"_sm_",name:'"_cnname_"',loadMask:true,clicksToEdit: 1, stripeRows: true,title:'"_title_"',height:"_h_",width:"_w_",tbar:[{id:'"_cnname_"but1',text:'新建'},{id:'"_cnname_"but2',text:'修改'}],store:"_griddata_",colModel: new Ext.grid.ColumnModel({columns:"_..getcols1(a1,.itmdata,code,widstr,.itmRelName,.itmLinkName,.headtmp,check)_",defaultSortable:false,enableColumnMove: false,viewConfig:{forceFit: false}})"_RowSel_",bbar: new Ext.PagingToolbar({store:"_griddata_",displayInfo:true,pageSize:10})})]},")
 ...e  d ff.Write("{id:'"_cnname_"pl',name:'"_cnname_"',tabIndex:'"_tab_"',x:"_x_",y:"_y_",height:"_h_",width:"_w_",xtype:'panel',layout:'fit',border:false,items:[new Ext.grid.EditorGridPanel({id:'"_cnname_"',name:'"_cnname_"',title:'"_title_"',loadMask:true,clicksToEdit: 1, stripeRows: true,height:"_h_",width:"_w_",tbar:[{id:'"_cnname_"but1',text:'新建'},{id:'"_cnname_"but2',text:'修改'}],store:"_griddata_",colModel: new Ext.grid.ColumnModel({columns:"_..getcols1(a1,.itmdata,code,widstr,.itmRelName,.itmLinkName,.headtmp)_",rows:"_grphead_",defaultSortable:false}),enableColumnMove: false,viewConfig:{forceFit: false},plugins:[new Ext.ux.plugins.GroupHeaderGrid()],sm: new Ext.grid.RowSelectionModel({ singleSelect: false}),bbar: new Ext.PagingToolbar({store:"_griddata_",displayInfo:true,pageSize:10})})]},")
 ..e  d
 ...if grphead="" d ff.Write("{id:'"_cnname_"pl',name:'"_cnname_"',tabIndex:'"_tab_"',x:"_x_",y:"_y_",height:"_h_",width:"_w_",xtype:'panel',layout:'fit',border:false,items:[new Ext.grid.GridPanel({id:'"_cnname_"'"_sm_",name:'"_cnname_"',loadMask:true,clicksToEdit: 1, stripeRows: true,title:'"_title_"',height:"_h_",width:"_w_",tbar:[{id:'"_cnname_"but1',text:'新建'},{id:'"_cnname_"but2',text:'修改'}],store:"_griddata_",colModel: new Ext.grid.ColumnModel({columns:"_..getcols1(a1,.itmdata,code,widstr,.itmRelName,.itmLinkName,.headtmp,check)_",defaultSortable:false,enableColumnMove: false,viewConfig:{forceFit: false}})"_RowSel_",bbar: new Ext.PagingToolbar({store:"_griddata_",displayInfo:true,pageSize:10})})]},")
 ...e  d ff.Write("{id:'"_cnname_"pl',name:'"_cnname_"',tabIndex:'"_tab_"',x:"_x_",y:"_y_",height:"_h_",width:"_w_",xtype:'panel',layout:'fit',border:false,items:[new Ext.grid.GridPanel({id:'"_cnname_"',name:'"_cnname_"',title:'"_title_"',loadMask:true,clicksToEdit: 1, stripeRows: true,height:"_h_",width:"_w_",tbar:[{id:'"_cnname_"but1',text:'新建'},{id:'"_cnname_"but2',text:'修改'}],store:"_griddata_",colModel: new Ext.grid.ColumnModel({columns:"_..getcols1(a1,.itmdata,code,widstr,.itmRelName,.itmLinkName,.headtmp)_",rows:"_grphead_",defaultSortable:false}),enableColumnMove: false,viewConfig:{forceFit:false},plugins:[new Ext.ux.plugins.GroupHeaderGrid()],sm: new Ext.grid.RowSelectionModel({ singleSelect: false}),bbar: new Ext.PagingToolbar({store:"_griddata_",displayInfo:true,pageSize:10})})]},") 
 .if $E(name,0,1)="R" d   //单选
 ..s xtype="radio"
 ..if link'="" s a1=..GetLinkData(link)
 ..s radioGrp=..GetRadioGrp(a1,cnname,$G(itmdataVal(code,name)))
 ..s flag=1
 ..d ff.Write("{name:'"_cnname_"',id:'"_cnname_"',frame:true,isFormField:true, labelAlign:'left',tabIndex:'"_tab_"',x:"_x_",y:"_y_",height:"_(h+5)_",width:"_w_",xtype:'panel',layout:'column',items:"_radioGrp_"},") 
 .if $E(name,0,1)="M" d
 ..s xtype="checkbox"
 ..if link'="" s a1=..GetLinkData(link)
 ..s checkGrp=..GetCheckGrp(a1,cnname,$G(itmdataVal(code,name)))
 ..s flag=1
 ..//i $G(itmdataVal(code,name))'="" d
 ..d ff.Write("{name:'"_cnname_"',id:'"_cnname_"',frame:true,isFormField:true, labelAlign:'left',tabIndex:'"_tab_"',x:"_x_",y:"_y_",height:"_(h+5)_",width:"_w_",xtype:'panel',layout:'column',items:"_checkGrp_"},") 
 .if $E(name,0,1)="O" d
 ..s xtype="combo"
 ..s flag=1
 ..s datastore=..GetStore(a1)  //b //combo
 ..s pl=..getvalFlag(a1)
 ..//i $G(itmdataVal(code,name))'="" d 
 ..d ff.Write("{name:'"_cnname_"',id:'"_cnname_"',tabIndex:'"_tab_"',x:"_x_",y:"_y_",triggerAction:'all',height:"_h_",width:"_w_",xtype:'"_xtype_"',store:"_datastore_", displayField:'desc', valueField:'id',allowBlank: true,mode:'local',value:'"_$P(itmdataVal(code,name),"|",pl)_"'},") 
 ..//d ff.Write("CreateComboBox('_"_cnname_','ArcimDesc','ArcimDR','医嘱项',"",90,'web.DHCNurCom','FindMasterItem',"ARCIMDesc",x,y),") 
 .if $E(name,0,1)="I" d
 ..s xtype="combo"
 ..s cls="",mth="",dl="Desc",vl="id",parrm=""
 ..if link'="" d
 ...s cls=$P(link,":",1),mth=$P(link,":",2),parrm=$P(link,":",3),dl=$P(link,":",4),vl=$P(link,":",5)
 ...if parrm=""  s a1=..GetLinkData(link)
 ..s flag=1
 ..if link="" d
 ...s datastore=..GetLinkData1($G(itmdataVal(code,name)))  //b //combo
 ...if datastore'="" d ff.Write("{name:'"_cnname_"',id:'"_cnname_"',tabIndex:'"_tab_"',x:"_x_",y:"_y_",height:"_h_",width:"_w_",xtype:'"_xtype_"',store:"_datastore_", displayField:'desc',triggerAction:'all', valueField:'id',allowBlank: true,mode:'local',value:'"_$P($G(itmdataVal(code,name)),"|")_"'},") 
 ...e  d ff.Write("{name:'"_cnname_"',id:'"_cnname_"',tabIndex:'"_tab_"',x:"_x_",y:"_y_",height:"_h_",width:"_w_",xtype:'"_xtype_"', displayField:'desc', valueField:'id',triggerAction:'all',allowBlank: true,mode:'local'},") 
 ..e  d
 ...if $G(a1)="" d ff.Write("{name:'"_cnname_"',id:'"_cnname_"',store:"_..GenerateComBoxMeta(dl_"^"_vl,cls,mth)_",tabIndex:'"_tab_"',x:"_x_",listWidth:'400',y:"_y_",height:"_h_",width:"_w_",xtype:'"_xtype_"', displayField:'"_dl_"', valueField:'"_vl_"',hideTrigger:false,queryParam:'"_parrm_"',forceSelection:true,triggerAction:'all',minChars:1,pageSize:10,typeAhead:true,typeAheadDelay:1000,loadingText:'Searching...'},") 
 ...e  d
 ....s datastore=..GetStore(a1)
 ....d ff.Write("{name:'"_cnname_"',id:'"_cnname_"',tabIndex:'"_tab_"',x:"_x_",y:"_y_",height:"_h_",width:"_w_",xtype:'"_xtype_"',store:"_datastore_", displayField:'desc', valueField:'id',allowBlank: true,mode:'local',value:''},") 
 .if $F(name,"Button")'=0 d
 ..s xtype="button"
 ..s flag=1
 ..d ff.Write("{tabIndex:'"_tab_"',name:'"_cnname_"',xtype:'panel',layout:'column',x:"_x_",y:"_y_",height:"_h_",width:"_w_",border:false,buttons:[{plain:true,frame:true,xtype:'button',id:'"_cnname_"',text:'"_text_"'}]},") 
 .if $E(name,0,1)="D" d
 ..s flag=1
 ..s df=$P(a1,"^")
 ..s df2=$P(a1,"^",2)
 ..if df2="D" s xtype="datefield",format="Y-m-d"
 ..if df2="T" s xtype="timefield"
 .. //bDateTime
 ..if xtype="timefield" d
 ...if itmdataVal(code,name)'="" d
 ....s itmdataVal(code,name)=$ZT($ZTH(itmdataVal(code,name)),4)
 ..if df2="D" d ff.Write("{name:'"_cnname_"',id:'"_cnname_"',tabIndex:'"_tab_"',x:"_x_",y:"_y_",height:"_h_",width:"_w_",xtype:'"_xtype_"',value:'"_itmdataVal(code,name)_"'},") //2017.3标库 
 ..//if df2="D" d ff.Write("{name:'"_cnname_"',id:'"_cnname_"',format:'"_format_"',tabIndex:'"_tab_"',x:"_x_",y:"_y_",height:"_h_",width:"_w_",xtype:'"_xtype_"',value:'"_itmdataVal(code,name)_"'},") 

 ..if df2="T" d ff.Write("{name:'"_cnname_"',id:'"_cnname_"',tabIndex:'"_tab_"',x:"_x_",y:"_y_",height:"_h_",width:"_w_",format: 'H:i',xtype:'"_xtype_"',value:'"_itmdataVal(code,name)_"'},") 
 .if $E(name,0,1)="G" d
 ..s xtype="textarea"
 ..s flag=1
 ..d ff.Write("{name:'"_cnname_"',id:'"_cnname_"',tabIndex:'"_tab_"',x:"_x_",y:"_y_",height:"_h_",width:"_w_",xtype:'"_xtype_"',value:'"_$G(itmdataVal(code,name))_"'},")
 ..//b //GGG
 .if typ="System.Windows.Forms.Label" s xtype="label" 
 .else  s xtype=""
 .if typ="System.Windows.Forms.Button" s xtype="button"
 .q:flag=1 
 .if $G(xtype)'="" d ff.Write("{name:'"_cnname_"',id:'"_cnname_"',tabIndex:'"_tab_"',x:"_x_",y:"_y_",height:"_h_",width:"_w_",xtype:'"_xtype_"',text:'"_text_"'},")
 .e  d ff.Write("{tabIndex:'"_tab_"' ,xtype:'textfield',x:"_x_",y:"_y_",height:"_h_",width:"_w_",name:'"_cnname_"',id:'"_cnname_"',value:'"_$G(itmdataVal(code,name))_"'},")
 ;s ff=$e(ff,0,$l(ff)-1)
 s tmpff=##class(%GlobalCharacterStream).%New()
 while ('(ff.AtEnd))
 {
	 set len=1024
	 set str=ff.Read(len)
	 if $l(str)'=1024 d 
	 .s str=$e(str,0,$l(str)-1)
	 d tmpff.Write(str)
 }
 s ff=tmpff
 d ff.Write("]")   //",{x:100,y:200,xtype:'timefield',anchor:'10%'}]"  
 i ReturnStream="true" q ff
 else  q ff.Read()
}

ClassMethod GetLinkData1(a) As %String
{
  if a'="" s id=$P(a,"|",1),des=$P(a,"|",2)
  if a="" s b="new Ext.data.JsonStore({data : [],fields: ['desc', 'id']})"
  if a'="" s b="new Ext.data.JsonStore({data : [{desc:'"_des_"',id:'"_id_"'}],fields: ['desc', 'id']})"
  q b

  q "" ;
  if a="" q ""
  s cls=$P(a,"^",1)
  s mth=$P(a,"^",2)
  s dt="##class("_cls_")."_mth_"()"
  q @dt
}

ClassMethod getdepmodel(LocId) As %String
{
	s ret=""
	i LocId'="" d
	.s DepModelStr=$G(^DHCNurDepModelSet(LocId))
	.f ii=1:1:$L(DepModelStr,"^") d
	..s DepModel=$P(DepModelStr,"^",ii)
	..q:DepModel=""
	..s ModelKey=$P(DepModel,"|",1)
	..s ModelName=$P(DepModel,"|",2)
	..s ret=ret_ModelKey_"|"_ModelName_"!"
  q ret
}

ClassMethod GetLinkData(a) As %String
{
  
 // s a="new Ext.data.JsonStore({data : [],fields: ['desc', 'id']})"
 // q a

  //q "" ;
  if a="" q ""
  s cls=$P(a,"^",1)
  s mth=$P(a,"^",2)
  s dt="##class("_cls_")."_mth_"()"
 // b  ///333
  q @dt
}

ClassMethod GenerateMetaData(str As %String, cls, Rmth) As %String
{
   s ret="{root:'rows',totalProperty:'results',fields:["
   s l=$L(str,"^")
   s mth=$P(Rmth,".")
   s QueryTyp="Query"
  if $P(Rmth,".",2)'="" s QueryTyp=$P(Rmth,".",2)
   for i=1:1:l
   {
      s itmstr=$P(str,"^",i)
      if itmstr="" continue
      s head=$P(itmstr,"!",1)
      s dataindex=$P(itmstr,"!",2)
      s h(i)=dataindex
      s ret=ret_"{'name':'"_dataindex_"','mapping':'"_dataindex_"'}"
      i i'=l s ret=ret_","
   }
   s ret=$e(ret,0,$l(ret)-1)
   s ret=ret_"]}"  
   s ret1="new Ext.data.Store({proxy:new Ext.data.HttpProxy({url:""../csp/dhc.nurse.ext.common.getdata.csp""}),reader:new Ext.data.JsonReader("_ret_"),"
   s ret2="baseParams:{className:'"_cls_"',methodName:'"_mth_"',type:'"_QueryTyp_"'}"
   s ret=ret1_ret2_"})"
  q ret
}

ClassMethod GenerateComBoxMeta(str As %String, cls, Rmth) As %String
{
 //w ##class(web.DHCNUREMR).GenerateComBoxMeta
   s ret="{root:'rows',totalProperty:'results',fields:["
   s l=$L(str,"^")
   s mth=$P(Rmth,".")
   s QueryTyp="Query"
   if $P(Rmth,".",2)'="" s QueryTyp=$P(Rmth,".",2)
   b
   for i=1:1:l
   {
      s itm=$P(str,"^",i)
      if itm="" continue
      s head=itm
      s dataindex=itm
      s h(i)=dataindex
      s ret=ret_"{'name':'"_dataindex_"','mapping':'"_dataindex_"'}"
      b
      i i'=(l) s ret=ret_","
   }
   //s ret=$e(ret,0,$l(ret)-1)
   s ret=ret_"]}"  
   s ret1="new Ext.data.Store({proxy:new Ext.data.HttpProxy({url:""../csp/dhc.nurse.ext.common.getdata.csp""}),reader:new Ext.data.JsonReader("_ret_"),"
   s ret2="baseParams:{className:'"_cls_"',methodName:'"_mth_"',type:'"_QueryTyp_"'}"
   s ret=ret1_ret2_"})"
  q ret
}

ClassMethod getstore1(str, data) As %String
{

  s l=$L(str,"^")
  //q ..GenerateMetaData(str)
  
  s ret="["
   for i=1:1:l
   {
      s itmstr=$P(str,"^",i)
      if itmstr="" continue
      s head=$P(itmstr,"!",1)
      s dataindex=$P(itmstr,"!",2)
      s h(i)=dataindex
      s ret=ret_"'"_dataindex_"',"
   }
    s ret=$e(ret,0,$l(ret)-1)
    s ret=ret_"]"   //",{x:100,y:200,xtype:'timefield',anchor:'10%'}]"  
   s tdata=$P(data,"$",3)
   s rws=$L(tdata,"^")
   s tt="["
   for i=1:1:rws
   {
	   s cldata=$P(tdata,"^",i)
	   s cols=$L(cldata,"!")
	   s cret="{"
	   if cldata="" continue
	   for c=1:1:cols
	   {
	     if '$D(h(c)) continue
	     s cd=$P(cldata,"!",c)
	     if cd="" s cd=""
	     if h(c)="CareDate" 
	     {
		     s cd="Date()"
		     s cret=cret_h(c)_":"_cd_","
	     }
	     else{
	     s cret=cret_h(c)_":'"_cd_"',"
	     }
	   } 
	   s cret=$e(cret,0,$l(cret)-1)
	   s tt=tt_cret_"},"
   }
   s tt=$e(tt,0,$l(tt)-1)
   s tt=tt_"]"
   //s a="new Ext.data.JsonStore({data:"_tt_",fields:"_ret_"})"
   s a="new Ext.data.JsonStore({data:[],fields:"_ret_"})"
 // b //7777000000
 q a
}

ClassMethod getcols1(str, itmdata, code, widthstr, itmrel, itmlink, headtmp, check = "N") As %String
{
 // s a="[{header:'项目名称',dataIndex:'name'},{header:'开发团队',dataIndex:'organization'},{header:'网址',dataIndex:'homepage'}]"
  // s a=##class(web.DHCNUREMR).getcols1()
   //s str="日期!a1!D21!1^日期!a1!D21!1^时间!a2!"
  // s str=str_"D22!2^时间!a2!D22!2^有无发生!a3!O103!3^有无发生!a3!O103!3^发生(面积 部位 程度)!a4!S104!4^发生(面积 部位 程度)!a4!S104!4^再评分!a5!S106!5^再评分!a5!S106!5^签名!a6!I111!6^签名!a6!I111!6^"
   i $D(%session) s Loc=$G(%session.Data("LOGON.CTLOCID"))
   e  s Loc="" 
   s LableRec=##class(Nur.DHCNurChangeLableRec).GetLableRec(code_"^"_Loc)
   k tmpLableRec
  // m ^TMP("ll")=itmlink
   for i=1:1:$L(LableRec,"&")
   {
	   s Lable=$P(LableRec,"&",i)
	   s LableId=$P(Lable,"|",1)
	   if LableId="" continue
	   s LableDesc=$P(Lable,"|",2)
	   s tmpLableRec(LableId)=LableDesc
   }
   
   s h=""  f  s h=$O(tmpLableRec(h)) q:h=""  d
   .if $G(headtmp(h))'=""  s tmpLableRec(h)=headtmp(h) 
  // m ^TMP("aaa")=LableRec
  ////qse add
   s l=$L(str,"^")
   //m ^TMP("aaa")=itmlink

   for i=1:1:l
   {
      s itmstr=$P(str,"^",i)
      s width=$P(widthstr,"^",i)
      if itmstr="" continue
      s head=$P(itmstr,"!",1)
      s dataindex=$P(itmstr,"!",2)
      s col=$P(itmstr,"!",3)
      s setstr=""
      s stordata=""
      if $D(itmdata(code,col)) s setstr=itmdata(code,col)
      //if $E(col,0,1)="D" s setstr="D^Y"
      if (($E(col,0,1)="D" )&(setstr'=""))
      { 
        s flag=$P(setstr,"^",1)
        
        s typ=$P(setstr,"^",2)
        if typ="D" s xtype="datefield"
        if typ="T" s xtype="timefield"
      }
      if $E(col,0,1)="S" s xtype="textfield"
      if $E(col,0,1)="E" s xtype="textarea"
      if $E(col,0,1)="G" s xtype="textarea"
      if $E(col,0,1)="O" s xtype="combo"
      if $E(col,0,1)="I" s xtype="combo"
      if ((dataindex["MItem")!(dataindex["IfSel"))&($E(col,0,1)="O") s xtype="radio" //radio
      if $E(col,0,1)="M" d
      .s name=$P(itmstr,"!")
      .s xtype="lvcombo"
      .s stordata=..GetStore($G(itmdata(code,col)))
      s readonly="false"
      ;if dataindex="CaseMeasure" s readonly="true"
      //if $E(col,0,1)="M" s readonly="true"
      s pos=$P(itmstr,"!",4)
      if pos="" s pos=i
      if $G(dataindex)'="",$D(tmpLableRec(dataindex)) s head=tmpLableRec(dataindex)
      s titlH="{header:'"_head_"',dataIndex:'"_dataindex_"',width:"_width_","
      i xtype="datefield" s titlH=titlH_"renderer:function(value){if(value instanceof Date){ return new Date(value).format(websys_DateFormat);}else{ return value}}," //2017.3标库
      //i xtype="datefield" s titlH=titlH_"renderer:function(value){if(value instanceof Date){ return new Date(value).format(""Y-m-d"");}else{ return value}},"
      s cls="",mth="",dl="Desc",vl="id",parrm=""
      s link=$G(itmlink(code,col))
      if $G(itmlink(code,col))'="" d
      .s cls=$P(link,":",1),mth=$P(link,":",2),parrm=$P(link,":",3),dl=$P(link,":",4),vl=$P(link,":",5)

      if (xtype="combo" )
      {
	     s stordata=..GetStore($G(itmdata(code,col)))
		
	     if ($G(itmlink(code,col))'="")&(Loc'="")
	     {
		     //s ^TMP("ll")=itmlink(code,col)_"^"_Loc
		  // s stordata=..GetStore(##class(web.DHCMGPrintComm).GetData(itmlink(code,col),"Loc:"_Loc))
		 }
	    // b  ///ds
	     
	  }
      if xtype="lvcombo" s con="editor:new Ext.grid.GridEditor(new Ext.ux.form.LovCombo({hideOnSelect:false,showSelectAll:'true',displayField:'id', valueField:'desc',store:"_$G(stordata)_",mode:'local'}))}"
      if link="" 
      {
	   
	    if (xtype="combo") d
	    .s con="editor:new Ext.grid.GridEditor(new Ext.form.ComboBox({displayField:'id',triggerAction:'all', valueField:'desc',store:"_$G(stordata)_",mode:'local'}))}"
        .//i code="DHCNURANHUI3"  d
        .//.s con="editor:new Ext.grid.GridEditor(new Ext.form.ComboBox({displayField:'id',triggerAction:'all', valueField:'desc',store:headstore,mode:'local'}))}"
      }else{
       	
        if (xtype="combo")  d
        .//s con="renderer:function(object,a,b,c,d,e){ if(object==undefined){ return """" }else{ alert(d+""@""+e);return (Ext.getCmp(""mygrid"").getColumnModel().getCellEditor(d,e).mons[0].item.lastSelectionText);}},"
        .//..GenerateComBoxMeta(dl_"^"_vl,cls,mth)
        .//.s con="editor:new Ext.grid.GridEditor(new Ext.form.ComboBox({store:CreateStore('"_cls_"','"_mth_"'),listWidth:400,displayField:'"_dl_"', valueField:'"_dl_"',hideTrigger:true,queryParam:'"_parrm_"',forceSelection:true,triggerAction:'all',minChars:1,pageSize:10,typeAhead:true,typeAheadDelay:1000,loadingText:'Searching...'}))}"
        .s con="editor:new Ext.grid.GridEditor(new Ext.form.ComboBox({store:"_..GenerateComBoxMeta(dl_"^"_vl,cls,mth)_",listWidth:400,displayField:'"_dl_"', valueField:'"_dl_"',hideTrigger:false,queryParam:'"_parrm_"',forceSelection:true,triggerAction:'all',minChars:1,pageSize:10,typeAhead:true,typeAheadDelay:1000,loadingText:'Searching...'}))}"
      }
      if xtype="textarea" s con= "editor: new Ext.grid.GridEditor(new Ext.form.TextArea({readOnly:"_readonly_",grow:true}))}"
      if xtype="textfield" s con= "editor: new Ext.grid.GridEditor(new Ext.form.TextField({readOnly:"_readonly_"}))}"
      if xtype="datefield" s con=" editor:new Ext.form.DateField({id:'"_col_"'})}"
      //if xtype="datefield" s con=" editor:new Ext.form.DateField({id:'"_col_"',format: 'Y-m-d'})}" //2017.3标库
       if xtype="radio" s con="type:'bool',editor:new Ext.grid.GridEditor(new Ext.form.Checkbox({allowBlank:true})),renderer:function(value){ if(value==1){return ""√"";} else { if(value!=""""){return value} else{return """"}}}}"
      //if xtype="datefield" s con=" editor: new Ext.grid.GridEditor(new Ext.form.DateField({id:'"_col_"',format: 'Y-m-d'}))}"
      if xtype="timefield" s con="editor: new Ext.grid.GridEditor(new Ext.form.TimeField({format: 'H:i'}))}"
      s titlH=titlH_con
      s tt(i)=titlH

   }
   s a="["
   if check="Y"  s a="[new Ext.grid.RowNumberer(),sm,"
   s p=""  f  s p=$O(tt(p)) q:p=""  d
   .s a=a_tt(p)_","
   s a=$e(a,0,$l(a)-1)
   s a=a_"]"
  q a
}

ClassMethod getcols11(str, itmdata, code, widthstr) As %String
{
 // s a="[{header:'项目名称',dataIndex:'name'},{header:'开发团队',dataIndex:'organization'},{header:'网址',dataIndex:'homepage'}]"
  // s a=##class(web.DHCNUREMR).getcols1()
   //s str="日期!a1!D21!1^日期!a1!D21!1^时间!a2!"
  // s str=str_"D22!2^时间!a2!D22!2^有无发生!a3!O103!3^有无发生!a3!O103!3^发生(面积 部位 程度)!a4!S104!4^发生(面积 部位 程度)!a4!S104!4^再评分!a5!S106!5^再评分!a5!S106!5^签名!a6!I111!6^签名!a6!I111!6^"
   
   s l=$L(str,"^")
   for i=1:1:l
   {
      s itmstr=$P(str,"^",i)
      s width=$P(widthstr,"^",i)
      if itmstr="" continue
      s head=$P(itmstr,"!",1)
      s dataindex=$P(itmstr,"!",2)
      s col=$P(itmstr,"!",3)
      s setstr=""
      if $D(itmdata(code,col)) s setstr=itmdata(code,col)
      //if $E(col,0,1)="D" s setstr="D^Y"
      if (($E(col,0,1)="D" )&(setstr'=""))
      { 
        s flag=$P(setstr,"^",1)
        
        s typ=$P(setstr,"^",2)
        if typ="D" s xtype="datefield"
        if typ="T" s xtype="timefield"
      }
      if $E(col,0,1)="S" s xtype="textfield"
      if $E(col,0,1)="O" s xtype="combo"
      if $E(col,0,1)="I" s xtype="combo"
      
      s pos=$P(itmstr,"!",4)
      if pos="" s pos=i
      s titlH="{header:'"_head_"',dataIndex:'"_dataindex_"',width:"_width_"}"
      ///{header: 'Changed', width: 50, dataIndex: 'changed'}
      s tt(i)=titlH

   }
   s a="["
   s p=""  f  s p=$O(tt(p)) q:p=""  d
   .s a=a_tt(p)_","
   s a=$e(a,0,$l(a)-1)
   s a=a_"]"
  q a
}

ClassMethod GetCheckGrp(a, cnname, selitm) As %String
{

   s l=$L(a,"!")
   s dd=""
   for i=1:1:l
   {
     if $P(a,"!",i)="" continue
     s itm=$P(a,"!",i)
     s id=$p(itm,"|",2)
     s txt=$p(itm,"|")
     s cl=$L(selitm,"^")
     s flag="false"
     for j=1:1:cl
     {
	    s sel=$P(selitm,"^",j)
	    if txt=$TR(sel," ","") s flag="true"
	 }
	// b //checSel
     if id="" s id=i
     if dd="" s dd="{name:'"_cnname_"_"_id_"',id:'"_cnname_"_"_id_"',xtype:'checkbox',checked:"_flag_", boxLabel:'"_txt_"'}"
     e  s dd=dd_",{name:'"_cnname_"_"_i_"',id:'"_cnname_"_"_id_"',xtype:'checkbox',checked:"_flag_", boxLabel:'"_txt_"'}"
   }
   q "["_dd_"]"
}

ClassMethod GetRadioGrp(a, cnname, selitm) As %String
{

   s l=$L(a,"!")
   s dd=""
   for i=1:1:l
   {
     if $P(a,"!",i)="" continue
     s itm=$P(a,"!",i)
     s id=$p(itm,"|",2)
     s txt=$p(itm,"|")
     s cl=$L(selitm,"^")
     s flag="false"
     for j=1:1:cl
     {
	    s sel=$P(selitm,"^",j)
	    if txt=$TR(sel," ","") s flag="true"
	 }
	// b //checSel
     if id="" s id=i
     if dd="" s dd="{name:'"_cnname_"',id:'"_cnname_"_"_id_"',xtype:'radio',checked:"_flag_", boxLabel:'"_txt_"'}"
     e  s dd=dd_",{name:'"_cnname_"',id:'"_cnname_"_"_id_"',xtype:'radio',checked:"_flag_", boxLabel:'"_txt_"'}"
   }
   q "["_dd_"]"
}

ClassMethod GetStore(a) As %String
{
   s l=$L(a,"!")
   s dd=""
   for i=1:1:l
   {
     if $P(a,"!",i)="" continue
     if dd="" s dd=..getitmstore($P(a,"!",i))
     e  s dd=dd_","_..getitmstore($P(a,"!",i))
   }
 s dd="["_dd_"]"
 s a="new Ext.data.JsonStore({data : "_dd_",fields: ['desc', 'id']})"
  q a
}

ClassMethod getvalFlag(a) As %String
{
   s flag=1
   s l=$L(a,"!")
   s dd=""
   s itm=$P(a,"!",1)
   if itm="" q flag
   s text=$P(itm,"|")
   s val=$P(itm,"|",2)
   if val="" s flag=2
 q flag
}

ClassMethod GetComboData(a) As %String
{
   s l=$L(a,"!")
   s dd=""
   for i=1:1:l
   {
     if $P(a,"!",i)="" continue
     if dd="" s dd=..getitmstore($P(a,"!",i))
     e  s dd=dd_","_..getitmstore($P(a,"!",i))
   }
 s dd="["_dd_"]"
 // s a="new Ext.data.SimpleStore({data : "_dd_",fields: ['desc', 'id']})"
  q dd
}

ClassMethod getitmstore(a)
{
   s text=$P(a,"|")
   s val=$P(a,"|",2)
   if val="" s val=text
  //s str="['"_text_"','"_val_"']"
   s str="{desc:'"_text_"',id:'"_val_"'}"
   q str
}

ClassMethod getfree(Reader, itmname) As %String
{
   
    s itm=""
    b ///ddf
	while Reader.Read()
	{
	  if (Reader.Name=itmname)&(Reader.NodeType="endelement") q  
      if ((Reader.Name="")&(Reader.NodeType="chars")) s itm=itm_Reader.Value
    //  w !, Reader.NodeType
    //  w !,Reader.Name," //--",Reader.Value,"-NodeType-",Reader.NodeType
	}
   //	b  ///9999
   //	
    q itm
}

ClassMethod getitm(Reader, itmname, itmdata, code) As %String
{
   
    s itm=""
	while Reader.Read()
	{
	 // q
      if (Reader.Name=itmname)&(Reader.NodeType="endelement")  q
      if ((Reader.Name="")&(Reader.NodeType="chars"))
      {
	       s itm=itm_Reader.Value_"!"

      }
    //  w !,Reader.Name," //--",Reader.Value,"-NodeType-",Reader.NodeType
	}
    s itmdata(code,itmname)=itm
    q itm
}

ClassMethod GetMGNurEmrExecute(ByRef qHandle As %Binary, parr As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 //	s parr="1336^2010-03-20^2010-03-20^itm11"
 	s emrcode=$P(parr,"^",4)
 	s stdate=$P(parr,"^",2)
 	s eddate=$P(parr,"^",3)
 	s Loc=$P(parr,"^",1)
 	s std=$ZDH(stdate,3)
 	s end=$ZDH(eddate,3)
    s emrcode=$ZConvert(emrcode,"U")
 	//s dep=parr
 	//if dep=""  Set qHandle=$lb(0,repid,0) Quit $$$OK
    for date=std:1:end
    {
	      s code=""  f  s code=$O(^NurEmr.NuEmrDataI("Date",date,code)) q:code=""  d
          .q:code'[emrcode
          .s rw=""  f  s rw=$O(^NurEmr.NuEmrDataI("Date",date,code,rw)) q:rw=""  d
	      ..
	      ..d out
    }
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK

out
    s (depdes,patname,emrtyp,ludate,lutime,user,person,episode,multid)=""
    s a=^NurEmr.NuEmrDataD(rw)
    s Status=$ListGet(a,11)
    if Status="" s Status="保存"
    if Status="A" s Status="提交"
    
    s dep=$List(a,6)
    q:(dep'=Loc)&(Loc'="")
    s emrcode=$list(a,2)
    s multid=$Listget(a,10)
    s emrtyp=$Listget(a,12)
    s episode=$List(a,5)
    if episode'=""
    {
	    s papmiId=+^PAADM(episode)
	    s patname=$p($g(^PAPER(papmiId,"ALL")),"^",1)
    }
    if dep'="" s depdes=$P(^CTLOC(dep),"^",2)
    s lutime=$List(a,7)
    s lutime=$ZT(lutime)
    s ludate=$ListGet(a,4)
    s ludate=$ZD(ludate,3)
    s userdr=$ListGet(a,8)
    s persondr=$ListGet(a,9)
    if userdr'=""
    {
	    s parr=^User.DHCMGPersonsD(userdr)
	    s user=$list(parr, 21)
    }
    if persondr'=""
    {
	  s parr=^User.DHCMGPersonsD(persondr)
      s person=$list(parr, 21)
    }

    d OutRowtyp
    q
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
  
OutRowtyp
	set Data=$lb(depdes,patname,emrtyp,ludate,lutime,user,person,episode,dep,emrcode,rw,multid,Status)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetMGNurEmrFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetMGNurEmrExecute ]
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

ClassMethod GetMGNurEmrClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetMGNurEmrExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetMGNurEmr(parr As %String) As %Query(ROWSPEC = "depdes,patname,emrtyp,ludate,lutime,user,person,episode,Loc,emrcode,rw,mulrw,status")
{
}

ClassMethod GetMGNurMulEmrExecute(ByRef qHandle As %Binary, parr As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	//s parr="1336^2010-03-25^2010-03-25^fold4"
 	s foldcode=$P(parr,"^",4)
 	s stdate=$P(parr,"^",2)
 	s eddate=$P(parr,"^",3)
 	s Loc=$P(parr,"^",1)
 	s std=$ZDH(stdate,3)
 	s end=$ZDH(eddate,3)
    s foldcode=$ZConvert(foldcode,"U")
 	//s dep=parr
 	//if dep=""  Set qHandle=$lb(0,repid,0) Quit $$$OK
    for date=std:1:end
    {
	
		s rw="" f  s rw=$O(^NurEmr.NuEmrDataMultiI("DateCode",date," "_foldcode,rw)) q:rw=""  d
        .d out
    }
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK

out
    s (depdes,patname,emrtyp,ludate,lutime,user,person,episode,multid)=""
	   s c=^NurEmr.NuEmrDataMultiD(rw)
	   s dep=$List(c,4)
	    s multid=rw
	    s episode=$List(c,3)
	    if episode'=""
	    {
		s papmiId=+^PAADM(episode)
		s patname=$p($g(^PAPER(papmiId,"ALL")),"^",1)
	    }
		if dep'="" s depdes=$P(^CTLOC(dep),"^",2)
		if (dep'=Loc)&(Loc'="") q	
		b
		s lutime=$List(c,5)
		s lutime=$ZT(lutime)
		s ludate=$ListGet(c,2)
		s ludate=$ZD(ludate,3)
		s userdr=$ListGet(c,6)
		s persondr=$ListGet(c,7)
		s emrtyp=$ListGet(c,8)
		s emrcode=$ListGet(c,9)
		s Status=""
        if userdr'=""
        {
			s parr=^User.DHCMGPersonsD(userdr)
			s user=$list(parr, 21)
        }
		if persondr'=""
		{
		  s parr=^User.DHCMGPersonsD(persondr)
		  s person=$list(parr, 21)
		}
       d OutRowtyp
       q
    //s code=$ZConvert(emrcode,"U")
   // s EmrCode=emrcode
   // s id=$O(^NurEmr.NurEmrSubI("EmrCode",code,""))
    //b  //
    //if id'=""
    //{
	 // s b=##class(NurEmr.NurEmrSub).%OpenId(id)
	//  s emrtyp=b.EmrSubDesc
   // }
    q
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
  
OutRowtyp
	set Data=$lb(depdes,patname,emrtyp,ludate,lutime,user,person,episode,dep,emrcode,rw,multid,Status)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetMGNurMulEmrFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetMGNurMulEmrExecute ]
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

ClassMethod GetMGNurMulEmrClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetMGNurMulEmrExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetMGNurMulEmr(parr As %String) As %Query(ROWSPEC = "depdes,patname,emrtyp,ludate,lutime,user,person,episode,Loc,emrcode,rw,mulrw,status")
{
}

ClassMethod ParseNurEmrCode(Code As %String) As %String
{
	//s a=##class(web.DHCNUREMR).ParseNurEmrCode()
	s EmrCode="WinTmp"
	//s Code="WinTmpver5131itm513fold51fold5NOD"
	//s Code="fold2"
	s str=##class(NurEmr.NurEmrMain).getData(EmrCode)
	s a=##class(NurEmr.NurEmrMain).%OpenId(str)
	d a.EmrData.Rewind()
   // Set sc = ##class(%XML.TextReader).ParseStream(a.EmrData,.Reader)
    s Reader=..GetReader(str,a.EmrData)
    // k ^foldtitle
     b
     
     while Reader.Read()
     {

	    if Reader.Name=Code
	    {      if $E(Code,0,3)="itm"
	           {
		         	s path=Reader.Path
                    if (Reader.MoveToAttributeName("Title"))
				      {
                        b ////
  					    s itmtitle(path)=Reader.Value
					  }
					
		       }
			   while Reader.Read()
			   {
				  if $find(Reader.Name,"fold")'=0
			      { 
			        s path=Reader.Path
				    if path'="" 
				    {
				     // s itmcode(path)=Reader.Name
				      if (Reader.MoveToAttributeName("Title"))
				      {
					   s foldtitle(path)=Reader.Value
					  }
				    }
				  }

                  s nodname=Reader.Name // $Find(nodname,"fold")'=0)&
			      s path=Reader.Path
			      if (Reader.Name=Code)&(Reader.NodeType="endelement")  q
			      if ((Reader.NodeType="element"))   
			      {
				    s typ=""
				    if (Reader.MoveToAttributeName("foldtyp"))
				    {
					  s typ=Reader.Value
					}

			      }
			      if $find(Reader.Name,"ver")'=0
			      {
				    if path'="" s itmcode(path)=Reader.Name
				  }
				  if $find(Reader.Name,"itm")'=0
			      {
				    if path'="" 
				    {
				      if (Reader.MoveToAttributeName("Title"))
				      {
					    s itmtitle(path)=Reader.Value
					  }
				    }
				  }
			   }
		}
}
    s p="" for  s p=$O(itmcode(p)) q:p=""  d
    .s l=$L(p,"/")
    .s n1=$P(p,"/",4),n2=$P(p,"/",5),n3=$P(p,"/",6),n4=$P(p,"/",7)
    .s MG(n1,n2,n3)="WinTmp"_n4_n3_n2_n1_"NOD"
    .b
   b
    s flag=0
    s ret=""
    s r1="" f  s r1=$O(MG(r1)) q:r1=""  d
    .s r2="" f  s r2=$O(MG(r1,r2)) q:r2=""  d
    ..s r3="" f  s r3=$O(MG(r1,r2,r3)) q:r3=""  d
    ...if $find(r2,"fold")=0 d
    ....s nod="/ROOT/NOD/"_r1_"/"_r2
    ....s title=$G(itmtitle(nod))
    ....s ret=$G(ret)_MG(r1,r2,r3)_$C(2)_title_"^"
    ...if $find(r2,"fold")=0 s flag=1
    ...if $find(r2,"fold")=0 q
    ...s nod="/ROOT/NOD/"_r1_"/"_r2_"/"_r3
    ...s title=$G(itmtitle(nod))
    ...s MGV(r1,r2)=$G(MGV(r1,r2))_MG(r1,r2,r3)_$C(2)_title_"^"
    s str=""
    //"/ROOT/NOD/fold5/fold52"
    b //
    s f="" f  s f=$O(MGV(f)) q:f=""  d
    .s f1=""  f  s f1=$O(MGV(f,f1)) q:f1=""  d
    ..s nod="/ROOT/NOD/"_f_"/"_f1
    ..s title=$G(foldtitle(nod))
    ..s str=str_MGV(f,f1)_$C(3)_title_$C(1)  
    if flag=1  s str=ret
    b
    q str
}

ClassMethod test(id) As %String
{
 //s a=##class(web.DHCNUREMR).test(7)
  s a=##class(NurEmr.NurEmrSub).%OpenId(id)
  w a.EmrSubData.Size
 // Set sc = ##class(%XML.TextReader).ParseStream(a.EmrSubData,.Reader)
                           
  Set tmpstream = ##class(%GlobalCharacterStream).%New()

  do a.EmrSubData.Rewind()

 for i=1:1:5 {
  do tmpstream.WriteLine(  a.EmrSubData.ReadLine())
  w !,a.EmrSubData.ReadLine()
  b ////////
 }
 b //
  Set sc = ##class(%XML.TextReader).ParseStream(tmpstream,.Reader)
  b  ////
  q sc
}

ClassMethod test2() As %String
{
 //s a=##class(web.DHCNUREMR).test2()

  //s file="/tmp/dhcc/WinTmpver711itm71fold7NOD.xml"
 
 // set sc = ##class(%XML.TextReader).ParseFile(file,.reader)
 // b
 // q sc
	w !,$j
	Set file = ##class(%File).%New("/tmp/dhcc/WinTmpver711itm71fold7NOD.xml") 
    Do file.Open("RU") 
    Set tmpstream = ##class(%GlobalCharacterStream).%New()
    Do tmpstream.CopyFrom(file) 
    // Do tmpstream.CopyFrom(file)
    b
    Set sc = ##class(%XML.TextReader).ParseStream(tmpstream,.Reader)
    q sc
}

ClassMethod GetFileName20170908(aID As %String) As %String
{
 s AOSString = ##class(%SYSTEM.Version).GetOS()
 s WindowsFlag =$Find(AOSString,"Windows") 
 S UNIXFlag =$Find(AOSString,"UNIX") 
     
	 set FilePath=""  //$ZUTIL(12,"")_"TempMG"
	 if WindowsFlag>0
	 {
	      s FilePath="c:\tmp"
	
	 }
	 if (UNIXFlag>0) 
	 {	
	     s FilePath="/tmp/TempMG"

	 }
	 if '##Class(%Library.File).DirectoryExists(FilePath)
	 {
		 s Result = ##Class(%Library.File).CreateDirectoryChain(FilePath) 
	 }
	 
	 if (WindowsFlag>0) 
	 {
	   s FileNameStr = FilePath_"\"_$J_"_"_$TR(aID,"||","")_".xml"
	   Quit FileNameStr	 
		 
     }
	 if (UNIXFlag>0) 
	 {
	   s FileNameStr = FilePath_"/"_$J_".xml"
	   Quit FileNameStr	 
	 }
}

/// Creator: 未知
/// Modified by: 徐保良 徐鹏
/// ModifyDate: 2017-08-01
/// Description: (1)修改了文件冗余的Bug;(2)更换了文件路径,改用公司标准文件路径;
/// Input: aID:护理病历模板ID
/// Return: 备份文件路径及ID
/// Others: w ##class(web.DHCNUREMR).GetFileName("NurTemplate001")
ClassMethod GetFileName(aID As %String) As %String
{
	s AOSString = ##class(%SYSTEM.Version).GetOS()
 	s WindowsFlag =$Find(AOSString,"Windows") 
 	// 根据操作系统是否Windows,确定文件目录
	if WindowsFlag>0{
		s FilePath="C:\backup\dhccbak\nurmodel"
	}else{
		s FilePath="/backup/dhccbak/nurmodel"
	}
	// 目录不存在,则创建目录
	if '##Class(%Library.File).DirectoryExists(FilePath){
		s Result = ##Class(%Library.File).CreateDirectoryChain(FilePath) 
	}
	// 目录+模板ID作为文件名字
	if (WindowsFlag>0){
		s FileNameStr = FilePath_"\"_$TR(aID,"||","")_".xml"	   	 
    }else{
		s FileNameStr = FilePath_"/"_$TR(aID,"||","")_".xml"  		 
	}
	
	Quit FileNameStr
}

ClassMethod readxml(xRead, code, nod, typ, prev)
{
    //if ($F(nod,0,3)=$F(prev,0,3))&( typ="endelement" )  s ^json=^json_","
    if (nod=code)&(typ="endelement") 
    {
	    s ^flag="1"
    }
	while xRead.Read()
	{  
	    s prevnod=nod
	    s curr=nod
		s nod=xRead.Name
	    if ^flag="1"  q
		s path=xRead.Path
		s l=$l(path,"/")
		//if path'="" s ^a(path)=""
	    if xRead.MoveToAttributeName("Title")	
        {
	        s ^a(path)=xRead.Value
	    }
        d ..readxml(xRead,code,nod,xRead.NodeType,prevnod)
	    if ^flag="1"  q
	}
}

ClassMethod readxml1(xRead, code, nod, typ, prev, num)
{
    //if ($F(nod,0,3)=$F(prev,0,3))&( typ="endelement" )  s ^json=^json_","
    if (nod=code)&(typ="endelement") 
    {
	    s ^flag="1"
    }
	while xRead.Read()
	{  
	    s prevnod=nod
	    s curr=nod
		s nod=xRead.Name
	    if ^flag="1"  q
		s path=xRead.Path
		s l=$l(path,"/")
		//if path'="" s ^a(num,path)=""
	    if xRead.MoveToAttributeName("Title")	
        {
	        s ^a(num,path)=xRead.Value
	    }
		s num=num+1			    
        d ..readxml1(xRead,code,nod,xRead.NodeType,prevnod,.num)
	    if ^flag="1"  q
	}
}

ClassMethod GetGrpHead(Code As %String, EmrCode) As %String
{
	//s a=##class(web.DHCNUREMR).GetGrpHead()
	   k ^t,^a
	  // s Code="T101",EmrCode="DHCNURPRN2"
        s str=##class(NurEmr.NurEmrSub).GetKCode(EmrCode)
        if str="" s str=##class(NurEmr.NurEmrSub).getData(EmrCode)
       // b /////d
       if str'=""   
	   {
		S ITM=##CLASS(NurEmr.NurEmrSub).%OpenId(str)
		s Data=ITM.EmrSubData
		s title=ITM.EmrSubDesc
		//b ///33
	   }else
	   {
	    q ""
	   }
	
	d Data.Rewind()
   // Set sc = ##class(%XML.TextReader).ParseStream(a.EmrData,.Reader)
    s Reader=..GetReader(str,Data)
    
     s ^flag="0"
     s num=0
     b ////11111111111111
     while Reader.Read()
     {
	    if Reader.Name=Code
	    {   
	       d ..readxml1(Reader,Code,Code,Reader.NodeType,"",.num) 
	       if ^flag="1" q
		}
    }
    k ^t
    s rows=0
    s maxrow=0
    s r=""  f  s r=$O(^a(r)) q:r=""  d
    .s itm="" f  s itm=$O(^a(r,itm)) q:itm=""  d
    ..s l=$L(itm,"/")
    ..s rows=0
    ..s tt=$P(itm,"/",l)
    ..if $F(tt,Code)'=0  s head(l-2,r,tt)=^a(r,itm)
    ..e  d
    ...s a1=$P(itm,"/",3)
    ...s a2=$P(itm,"/",4)
    ...s a3=$P(itm,"/",5)
    ...s a4=$P(itm,"/",6)
    ...if l=6 s thead(r,a1,a2,a3,a4)=^a(r,itm)
    ...if l=5 s thead(r,a1,a2,a3)=^a(r,itm)
    ...if l=4 s thead(r,a1,a2)=^a(r,itm)
    ..f i=1:1:l  d
    ...s tm=$P(itm,"/",i)
    ...s fl=$F(tm,Code)
    ...if fl'=0 s rows=rows+1
    ...if rows>maxrow s maxrow=rows
    s rw=2
    s JRows=""
    s ret=""
    f rw=2:1:maxrow
    {
	   d ..getcolspan(.head,rw,Code)
	   s r="" f  s r=$O(^a(r)) q:r=""  d
	   .s it="" f  s it=$O(^a(r,it)) q:it=""  d
	   ..s l=$L(it,"/")
	   ..q:l>(rw+2)
	   ..s itm=$P(it,"/",l)
	   ..s fl=$F(itm,Code)
	   ..if fl=0  d
	   ...s JRows(rw)=$G(JRows(rw))_"{},"
	   ..else  d
	   ...if $D(head(rw,r,itm)) d
	   ....s titl=$P(head(rw,r,itm),"^")
	   ....s colsspan=$P(head(rw,r,itm),"^",2)
	   ....s JRows(rw)=$G(JRows(rw))_"{header:'"_titl_"',colspan:"_colsspan_",align:'center'},"
	    s JRows(rw)="["_$e(JRows(rw),0,$l(JRows(rw))-1)_"]"
        s ret=ret_JRows(rw)_","
	}
	s ret="["_$e(ret,0,$l(ret)-1)_"]"
	q ret
}

ClassMethod getcolspan(head, rw, Code)
{
   s cols=0
   s r=""  f  s r=$O(head(rw,r)) q:r=""  d
   .s h=""  f  s h=$O(head(rw,r,h)) q:h=""  d
   ..s head(rw,r,h)=head(rw,r,h)_"^"_..getcls(h,Code)
}

ClassMethod getcls(h, Code) As %String
{
    s cols=0
	s gg="" f  s gg=$O(^a(gg)) q:gg=""  d
    .s aa="" f  s aa=$O(^a(gg,aa)) q:aa=""  d
    ..s a=$P(aa,h,2)
    ..s l=$L(aa,"/")
    ..s b=$P(aa,"/",l)
    ..s fl=$F(b,Code)
    ..//if (a'="")&(fl=0)  s cols=cols+1
    ..if ($p(a,"/")="")&(a'="")&(fl=0)  s cols=cols+1
   q cols
}

ClassMethod WinTeste(Code As %String) As %String
{
	//s a=##class(web.DHCNUREMR).WinTeste()
	s EmrCode="WinTmp"
	k ^a
	s str=##class(NurEmr.NurEmrMain).getData(EmrCode)
	s a=##class(NurEmr.NurEmrMain).%OpenId(str)
	d a.EmrData.Rewind()
    //Set sc = ##class(%XML.TextReader).ParseStream(a.EmrData,.Reader)
    s Reader=..GetReader(str,a.EmrData)
    
     s ^flag="0"
     while Reader.Read()
     {
	    if Reader.Name=Code
	    {   
	       d ..readxml(Reader,Code,Code,Reader.NodeType,"") 
	       if ^flag="1" q
		}
    }
    k ^t
    s r=""  f  s r=$O(^a(r)) q:r=""  d
    .s aa=r
    .s l=$L(aa,"/")
    .s b=$P(aa,"/",4)
    .s b1=$P(aa,"/",5)
    .s b2=$P(aa,"/",6)
    .s ^t(1,b)=""
    .if (b1'="")&('$D(^t(2,b,b1))) d
    ..s ^t(2,b,b1)=^a(r)
    .//if (b2'="")&(b1'="")  s ^t(3,b1,b2)=""
   // b  /////////////
    //t(1,"fold2")=""
	//t(2,"fold2","itm21")=""
	//t(2,"fold2","itm22")=""
	//t(3,"itm21","ver211")=""
	//t(3,"itm22","ver221")=""
    s arr=""
    s json=""
       s i=1
	   s nod="" f  s nod=$O(^t(i,nod)) q:nod=""  d
	   .//w "[{"_nod_"}]"
	   .if $D(^t((i+1),nod)) d
	   ..k arr
	   ..m arr=^t((i+1),nod)
	   ..s ff=..getstr(.arr)
	   ..if nod=Code s json=json_"["_..getjson(ff,(i+1),nod)_"]"
	   ..e  s json=json_"[{text:'"_nod_"',id:'"_nod_"',leaf:false,children:["_..getjson(ff,(i+1),nod)_"]"_"}]"
	   .e  d
	   ..s json=json_"[{text:'"_nod_"',id:'"_nod_"',leaf:false}]"
	// b  ///iiiii
    q json
}

ClassMethod getjson(kk, n, curno) As %String
{
 //if '$D(^arr) q ""
 s l=$L(kk,"^")
 s gg=""
 k gg
 for i=1:1:l
 {
   s d=$P(kk,"^",i)
   s itm=$P(d,"|")
   if d="" continue
   s gg(itm)=$P(d,"|",2)
 }
 m arr=gg
 s nn=""  f  s nn=$O(arr(nn)) q:nn=""  d
 .if $D(^t((n+1),nn)) d
 ..k bb
 ..m bb=^t((n+1),nn)
 ..s hh=..getstr(.bb)
 ..if $G(ret)'="" s ret=$G(ret)_",{text:'"_arr(nn)_"',id:'"_nn_"',leaf:false,children:["_..getjson(hh,(n+1),nn)_"]"_"}"
 ..e  s ret=$G(ret)_"{text:'"_arr(nn)_"',id:'"_nn_"',leaf:false,children:["_..getjson(hh,(n+1),nn)_"]"_"}"
 .e  d
 ..if $G(ret)'="" s ret=$G(ret)_",{text:'"_arr(nn)_"',id:'"_nn_"',leaf:true}"
 ..e  s ret=$G(ret)_"{text:'"_arr(nn)_"',id:'"_nn_"',leaf:true}"
 q ret
}

ClassMethod getstr(glb) As %String
{
  s a=""
   s n=""  f  s n=$O(glb(n)) q:n=""  d
   .s a=a_n_"|"_glb(n)_"^"
   q a
}

ClassMethod GetCheckGrp1(a, cnname, selitm) As %String
{

   s l=$L(a,"!")
   s dd=""
   s x=5,y=5
   for i=1:1:l
   {
     if $P(a,"!",i)="" continue
     s itm=$P(a,"!",i)
     s id=$p(itm,"|",2)
     s txt=$p(itm,"|")
     if id="" s id=i
     s cl=$L(selitm,"^")
     s flag="false"
     for j=1:1:cl
     {
	    s sel=$P(selitm,"^",j)
	    if txt=$TR(sel," ","") s flag="true"
	 }
	// b //checSel
     if id="" s id=i
     if dd="" s dd="{x:"_x_", y:"_y_", name:'"_cnname_id_"',id:'"_cnname_"_"_id_"',xtype:'checkbox',checked:"_flag_", boxLabel:'"_txt_"'}"
     e  s dd=dd_",{x:"_x_", y:"_y_",name:'"_cnname_i_"',id:'"_cnname_"_"_id_"',xtype:'checkbox',checked:"_flag_", boxLabel:'"_txt_"'}"
    s y=y+20
   }
   q "["_dd_"]"
}

ClassMethod getcols() As %String
{
 s a="[{header:'项目名称',dataIndex:'name'},{header:'开发团队',dataIndex:'organization'},{header:'网址',dataIndex:'homepage'}]"
 q a
}

ClassMethod getno(a) As %String
{
 //w ##class(web.DHCNUREMR).getno()
    s tim(0)=24
    s tim(1)=4
    s tim(2)=8
    s tim(3)=12
    s tim(4)=16
    s tim(5)=20
    
	s intim=$ZTH(a)
	s num=$FN(intim*6/86400,"",0)
	q tim(num)
}

ClassMethod testxml() As %String
{
 //d ##class(web.DHCNUREMR).testxml()

	set reader = ##class(%XML.Reader).%New() 
	set sc = reader.OpenFile("e:\aaa.xml") 
	set doc = reader.Document 
	set element = doc.GetDocumentElement() 
	do element.SetAttribute("title",,"ddd") 
	 
	set writer=##class(%XML.Writer).%New() 
	set sc = writer.OutputToFile("e:\newCompany.xml") 
	do writer.DocumentNode(element)
	kill
}

ClassMethod getcheckform(code, selitm) As %String
{
 //s selitm="口腔护理;床上擦浴;更衣裤^mulitmNur!"
    //s a=##class(web.DHCNUREMR).getcheckform("DHCNUR2","")
	 s l=$l(selitm,"!")
	 for i=1:1:l
	 {
	   s itm=$P(selitm,"!",i)
	   if itm="" continue
	   s tt=$P(itm,"^",2)
	   s sel=$P(itm,"^",1)
	   s TT(tt)=sel
	 }
	 s ret=""
	 s itm=""  f  s itm=$O(^DHCMGNURSEFORM(code,itm)) q:itm=""  d
     .s ss=$P(^DHCMGNURSEFORM(code,itm),"^")
     .s data=$P(^DHCMGNURSEFORM(code,itm),"^",2)
     .s titl=$P(ss,"!",1)
     .s it=$P(ss,"!",2)
     .if selitm="" s checkstr=..GetCheckGrp1(data,it,"")
	 .e  s checkstr=..GetCheckGrp1(data,it,$TR($G(TT(it)),";","^"))
     .s ret=ret_it_"^"_titl_"^"_checkstr_"!"
    q ret
	 //if selitm=""  q ..GetCheckGrp(^DHCMGNURSEFORM(code,itm),cname,"")
	 //e  q ..GetCheckGrp(^DHCMGNURSEFORM(code,itm),cname,$TR(selitm,";","^"))
}

ClassMethod GetMulti(code) As %String
{
    s ret=""
    s itm=""  f  s itm=$O(^DHCMGNURSEFORM(code,itm)) q:itm=""  d
    .s ss=$P(^DHCMGNURSEFORM(code,itm),"^")
    .s it=$P(ss,"!",2)
    .s ret=ret_"^"_it
    q ret
}

// 显示顺序按表头分组

ClassMethod readxml2(xRead, code, nod, typ, prev, num)
{
    if (nod=code)&(typ="endelement") 
    {
	    s ^flag2="1"
    }
	while xRead.Read()
	{  
	    s prevnod=nod
	    s curr=nod
		s nod=xRead.Name
	    if ^flag2="1"  q
		s path=xRead.Path
		s l=$l(path,"/")
		s id=$p(path,"/",l)
	    if xRead.MoveToAttributeName("Title")	
        {
	        if id[code continue
	        s ^DHCNurEmrGen2(num,id)=xRead.Value
	    }
		s num=num+1			    
        d ..readxml2(xRead,code,nod,xRead.NodeType,prevnod,.num)
	    if ^flag2="1"  q
	}
}

// 显示顺序按表头分组

ClassMethod getTtitle(Code, EmrCode) As %String
{
       k ^t2,^DHCNurEmrGen2
       s str=##class(NurEmr.NurEmrSub).GetKCode(EmrCode)
       if str="" s str=##class(NurEmr.NurEmrSub).getData(EmrCode)
       if str'=""   
	   {
		S ITM=##CLASS(NurEmr.NurEmrSub).%OpenId(str)
		s Data=ITM.EmrSubData
		s title=ITM.EmrSubDesc
	   }else
	   {
	    q ""
	   }
	   d Data.Rewind()
       s Reader=..GetReader(str,Data)
       s ^flag2="0"
       s num=0
       while Reader.Read()
       {
	     if Reader.Name=Code
	     {   
	       d ..readxml2(Reader,Code,Code,Reader.NodeType,"",.num) 
	       if ^flag2="1" q
		 }
       }
       k ^t2
}

/// Creator: Panshuai
/// CreateDate: 2014-10-15
/// Description:根据开始日期、结束日期、病历单据名称取是否有保存记录
/// Table: Nur.DHCMoudData,Nur.DHCMoudDataSub,Nur.DHCNurseRecParent,Nur.DHCNurseRecSub
/// Input: EpisodeID:就诊号,StDate：开始日期,EdDate:结束日期,EmrName:模版名称
/// Return: 记录表名^记录ID^记录日期^记录时间^记录人,无记录返回空
/// w ##class(web.DHCNUREMR).GetEmrStatus(356,"2014-10-16","2014-10-16","入院评估单")
ClassMethod GetEmrStatus(EpisodeID As %String, StDate As %String, EdDate As %String, EmrName As %String) As %String
{
	q:(EpisodeID="") ""
	s EmrCode=..GetEmrCodeByName(EmrName)
	q:(EmrCode="") ""
	s rtnStr=""
	i StDate["-" s StDate=$zdh(StDate,3)
	i StDate["/" s StDate=$zdh(StDate)
	i StDate="" s StDate=+$h
	
	i EdDate["-" s EdDate=$zdh(EdDate,3)
	i EdDate["/" s EdDate=$zdh(EdDate)
	i EdDate="" s EdDate=+$h
	
	s code=$ZConvert(EmrCode,"U") //$ZConvert(EmrCode,"L")
	s MoudFlag="Y"
	s id=""
	s id=$O(^Nur.DHCMoudDataI("EmrCode"," "_code," "_EpisodeID,id))
	;b ;01
	i id'=""
	{
		s MoudSubFlag=""
		s chlsub=""
		f  s chlsub=$o(^Nur.DHCMoudDataD(id,"ChildRec",chlsub),-1) q:(chlsub="")!(MoudSubFlag="Y")  d 
		.s MoudSubFlag="N"
		.s MoudSubID=id_"||"_chlsub
		.s tmpa=##class(Nur.DHCMoudDataSub).%OpenId(MoudSubID)
		.s EmrDate=tmpa.EmrDate
     	.s RecDate=EmrDate
     	.s RecTime=tmpa.EmrTime
     	.s RecUser=tmpa.EmrUser
     	.s CancelUser=tmpa.RecCancelUser
     	.q:CancelUser'=""
     	.q:(EmrDate<StDate)!(EmrDate>EdDate)
     	.s MoudSubFlag="Y"
     	.s rtnStr="Nur.DHCMoudDataSub^"_MoudSubID_"^"_RecDate_"^"_RecTime_"^"_RecUser
		
		q:MoudSubFlag="Y" rtnStr
		
		i MoudSubFlag="" 
		{
     	  s tmpb=##class(Nur.DHCMoudData).%OpenId(id)
     	  s EmrDate=tmpb.EmrDate
     	  s RecDate=EmrDate
     	  s RecTime=tmpb.EmrTime
     	  s RecUser=tmpb.EmrUser
     	  s CancelUser=tmpb.RecCancelUser
     	
     	  i (EmrDate<StDate)!(EmrDate>EdDate) s MoudFlag="N"
     	  i CancelUser'="" s MoudFlag="N"
     	  i MoudFlag="Y" s rtnStr="Nur.DHCMoudData^"_id_"^"_RecDate_"^"_RecTime_"^"_RecUser
     	  q:MoudFlag="Y" rtnStr
		}
	}
	else
	{
		s MoudFlag="N"
	}
	i MoudFlag="N"
	{
		s RecSubFlag="N"
		s rtnStr=""
		s parr=""
		s parr=$O(^Nur.DHCNurseRecParentI("Episode"," "_EpisodeID,parr))
		;b ;02
		q:parr="" ""
		f EDate=EdDate:-1:StDate
		{
			s rw=""
			f  s rw=$O(^Nur.DHCNurseRecSubI("TypDat"," "_code,EDate,parr,rw),-1) q:(rw="")!(RecSubFlag="Y")  d
			.;b ;03
			.s id=parr_"||"_rw
			.s tmpc=##class(Nur.DHCNurseRecSub).%OpenId(id)
			.s EmrDate=tmpc.CareDate
			.q:(EmrDate<StDate)!(EmrDate>EdDate)
     	    .s CancelUser=tmpc.RecCancelUser
			.q:(CancelUser'="")
			.s RecDate=tmpc.RecDate
     	    .s RecTime=tmpc.RecTime
     	    .s RecUser=tmpc.RecUser
     	    .;b ;04
     	    .s rtnStr="Nur.DHCNurseRecSub^"_id_"^"_RecDate_"^"_RecTime_"^"_RecUser
     	    .s RecSubFlag="Y"
		}
		q rtnStr
		
	}
	q rtnStr
}

/// Creator: Panshuai
/// CreateDate: 2014-10-22
/// Description:根据模版名称获取模版关键字
/// Table: NurEmr.NurEmrSub
/// Input: EmrName：模版名称
/// Return: 有记录模版关键字,无记录返回空
/// w ##class(web.DHCNUREMR).GetEmrCodeByName("入院评估单")
ClassMethod GetEmrCodeByName(EmrName As %String) As %String
{
	q:EmrName="" ""
	s rtnStr="",Flag="N"
	s SubKCode="" f  s SubKCode=$O(^NurEmr.NurEmrSubI("KCode",SubKCode),-1) q:(SubKCode="")!(Flag="Y")  d
	.s ItmId=$O(^NurEmr.NurEmrSubI("KCode",SubKCode,""))
	.q:ItmId=""
	.s RecName=$List(^NurEmr.NurEmrSubD(ItmId),4)
	.q:RecName'=EmrName
	.;q:(RecName'[EmrName)&(EmrName'[RecName)
	.s Flag="Y"
	.s rtnStr=$TR(SubKCode," ","")
	q rtnStr
}

/// / value:字符串，Delimiter：分割符 startPos：起始位置
/// /对于分割符分割的字符串取包含分割符的串
/// 例如: value:"a&b&c&d" Delimiter:"&" startPos:2 -> output:b&c&d
/// w ##class(web.DHCNUREMR).MergeStr("a&b&c&d&&","&",2)
ClassMethod MergeStr(value, Delimiter, startPos)
{
	//n (value,Delimiter,startPos)
	s ret=""
	s len=$l(value,Delimiter)
	f i=startPos:1:len
	{
	 s val=$p(value,Delimiter,i)
	 i ret="" s ret=val
	 e  s ret=ret_Delimiter_val
		}
	q ret
}

/// 多次评估
ClassMethod GetPrintDataPGD(param) As %GlobalCharacterStream
{
	b //4
	s ^niewei(3331)=param
	s ^pyh("GetPrintDataPGD")=$lb(param)
	s EmrCode=$P(param,"^",1) //
	s Id=$P(param,"^",2)
	s mulid=$P(param,"^",3)
	s mthpar=$P(param,"^",4)
	if mthpar="!" s mthpar=""
	s itmLabelVal=""  //LabelText
	s str=##class(NurEmr.NurEmrSub).getData(EmrCode)
	s ITM=""
	if str'="" 
	{  	
		s parr=EmrCode_"^"_mthpar
		S ITM=##CLASS(NurEmr.NurEmrSub).GetStreamNewHH(parr)
	}else
	{
	  q ""
	}
	;d ITM.EmrSubData.Rewind()
	
	d ITM.Rewind()
   // Set sc = ##class(%XML.TextReader).ParseFile(ITM.EmrSubData,.Reader)   
    ;s Reader=..GetReader(str,ITM.EmrSubData)
	s Reader=..GetReader(str,ITM)

    while Reader.Read()
    {
	   if Reader.Name="PageHeadFoot"
	   {
		   while Reader.Read()
		   {
		     if $find(Reader.Name,"B")'=0
		     {
			        s itmname=Reader.Name
			    	if (Reader.MoveToAttributeName("Rel"))
				    {
					  s TMPITM(itmname)=Reader.Value
					  s TMPITMData(Reader.Value)=""
					
					}
					
			 }
		     if (Reader.Name="PageHeadFoot")&(Reader.NodeType="endelement")  q
		   }
	   }
	   if Reader.Name="MetaData"
	   {
		   while Reader.Read()
		   {
		     if $find(Reader.Name,"B")'=0
		     {
			        s itmname=Reader.Name
			    	if (Reader.MoveToAttributeName("Rel"))
				    {
					  s TMPITM(itmname)=Reader.Value
					  s TMPITMData(Reader.Value)=""
					//  w !,Reader.Value
					
					}
					
			 }
		     if (Reader.Name="MetaData")&(Reader.NodeType="endelement")  q
		   }
	   }
	   if Reader.Name="WinTmp"
	   {
	      while Reader.Read()
	      {
	   	      s path=Reader.Path
	   	      if Reader.Name["Tmp"
	   	      {
				    if (Reader.MoveToAttributeName("WinCode"))
				    {
					  s TMP(Reader.Value)=""
					}
		   	  }
     	   	  if (Reader.Name="WinTmp")&(Reader.NodeType="endelement")  q
	      }
	   }
	   
	   if Reader.Name="InstanceData"
		{
		   while Reader.Read()
		   {
			 // b
		      s itmname=Reader.Name
		      if itmname="" continue
		
			      s lb=$E(itmname,0,5)

			      if ($F(lb,"Label")'="0")
			      {
				    if (Reader.MoveToAttributeName("text"))
				    {
					 // if itmdataVal(code,itmname)'="" s itmdataVal(code,itmname)=itmdataVal(code,itmname)_"@"_Reader.Value
					  s itmLabelVal(EmrCode,itmname)=Reader.Value
					 // b ///----0
					}
				   // b //ooooo(注:总分<=17分,可上报不可避免压疮)
	              // w !,itmname
				  }
              
             if (Reader.Name="InstanceData")&(Reader.NodeType="endelement")  q

		   }
		}
	   
	   
	 //  w !,Reader.Name
	  // if Reader.EOF q安徽省立医院护理不良/意外事件报告表
	}

    s ItmRelName=""
    s ItmLink=""
	s itm="" f  s itm=$O(TMPITMData(itm)) q:itm=""  d
	.s ItmData($P(itm,"."),$P(itm,".",2))=""
	//b //按界面取值取值
    if mulid'=""
    {
		s tcode="" f  s tcode=$O(TMP(tcode)) q:tcode=""  d
	    .s rw=##class(NurEmr.DHCMgEmrDataChild).getmultiId(tcode,mulid)
	    .//b mukl
	    .if rw'="" d ..getItmData(.ItmData,.ItmRelName,.ItmLink,tcode,rw) 
    }else
    {
	
	 s tcode="" f  s tcode=$O(TMP(tcode)) q:tcode=""  d
     .s aa=..getItmData(.ItmData,.ItmRelName,.ItmLink,tcode,Id) 
     .if (Id'="")&(aa="id") d
     ..d ..getItmData(.ItmData,.ItmRelName,.ItmLink,tcode,"") 
	}
	//b  //
	//先将数据取出根据关键值放入数据   s a(i)=##class(web.DHCNUREMR).GetData(mth,par)
	//根据键值 关联界面元素 if $D(ItmRelName(code,it)) s value=$G(tmval(ItmRelName(code,it)))
   // s rw##class(NurEmr.NuEmrData).getmultiId(code,mulid)
    d Reader.Rewind()
    s a=""
    s l=$L(mthpar,"|")
    //多次
    k addInfo
	s count=0
	//end
    s tabledata=""
	f i=1:1:l
	{
	  s mp=$P(mthpar,"|",i)
	  
	  if mp="" continue
	 
	  s mth=$P(mp,"&",1),par=$P(mp,"&",2)
	  s c="" f  s c=$O(ItmLink(c)) q:c=""  d
	  .s n=""  f  s n=$O(ItmLink(c,n)) q:n=""  d
	  ..q:ItmLink(c,n)=""
	  ..b //sdeeeee
	  ..if ($F(mp,ItmLink(c,n))'=0) d
	  ...s aa=##class(web.DHCPregPrint).GetQueryData(mth,par)  ///dddd
	  ...b //ddd555555
	  ...s tabledata(c,n)=aa
	  ...s mp=""
	  if mp="" continue

	  //s a(i)=##class(web.DHCNUREMR).GetData(mth,par)
	  //if mth'="web.DHCConsult:getConsultInfo" s a(i)=$TR(a(i),"|","&")
	  
	  //多次
	  i (par["@@")&&(mth'="web.DHCConsult:getConsultInfo")
	  {
	  	s parInfo=..SplitParam(par)
	  	i parInfo["$" d
	  	.f j=1:1:$l(parInfo,"$") d
	  	..s parnew=$p(parInfo,"$",j)
	  	..q:parnew=""
		..s a(i+count)=##class(web.DHCNUREMR).GetData(mth,parnew)
		..s a(i+count)=$TR(a(i+count),"|","&")
		..i j>1 d
		...s addInfo(i+count)="_"_j
		..s count=count+1
	  }
 else
	  {
	  	s a(i+count)=##class(web.DHCNUREMR).GetData(mth,par)
	  	if mth'="web.DHCConsult:getConsultInfo" s a(i)=$TR(a(i),"|","&")
	  }
	  //end

	}
	s tmval=""
	s m=""  f  s m=$O(a(m)) q:m=""  d
	.if a(m)="" q
	
	.s addStr=$g(addInfo(m))  //多次
	
	.s l=$L(a(m),"^")
	.for i=1:1:l d
	..s itm=$P(a(m),"^",i)
	..q:itm=""
	..s p=$P(itm,"&",1)
	..///s v=$P(itm,"&",2)
	..s v=..MergeStr(itm,"&",2)
	
	..s p=p_addStr //多次
	
	..s tmval(p)=v
    ///InstanceData  付值 10-10-20
    s itm=""  f  s itm=$O(itmLabelVal(EmrCode,itm)) q:itm=""  d
    .if $D(tmval(itmLabelVal(EmrCode,itm))) d
    ..s itmLabelVal(EmrCode,itm)=tmval(itmLabelVal(EmrCode,itm))
    .e  k itmLabelVal(EmrCode,itm)
   // s a=##class(%system)
    b //bmmmmd
    Set datastream=##class(%GlobalCharacterStream).%New()
    s b="<?xml version='1.0' encoding='UTF-8'?>"
    s tempStr=b_"<Root>"
    d datastream.Write(tempStr)  //45
   b //8888888
    s itm="" f  s itm=$O(TMPITM(itm)) q:itm=""  d
    .s str=TMPITM(itm)
	.s code=$P(str,"."),it=$P(str,".",2)
	.s value=ItmData(code,it)
	.s dataval=ItmData(code,it)
	.if $D(tabledata(code,it)) d
	..s value=..gettabledata(value,tabledata(code,it))
	..//b //9999999999999999999999
	.s flag="0"
	.s selval=""
	.//b  ///==
	.;if $G(ItmRelName(code,it))'="" d  //	.i (mthpar'="")&($F(it,"T")=0) d
	.;.if $G(ItmRelName(code,it))'="" s value=$G(tmval(ItmRelName(code,it)))
	.//多次
	.s itnew=it
	.if itnew["_" s itnew=$p(itnew,"_",1)
	.if $G(ItmRelName(code,itnew))'="" d  //	.i (mthpar'="")&($F(it,"T")=0) d
	..if $G(ItmRelName(code,itnew))'="" d
	...s ItemCodex=ItmRelName(code,itnew)
	...i it["_" s ItemCodex=ItemCodex_"_"_$p(it,"_",2)
	...s value=$G(tmval(ItemCodex))
	...//end
	..e  s value=$G(tmval(it))
    ..if $find(it,"R")'=0 d
	...s dval=dataval
	...s selval=..getmulval(dval,value)
	...s flag="1"
    ..if $find(it,"M")'=0 d
	...s dval=dataval
	...s selval=..getmulval(dval,value)
	...s flag="1"
	..if $find(it,"O")'=0 d
	...s dval=dataval
	...s selval=..getsinglval(dval,value)
	...s flag="1"
	..if $find(it,"I")'=0 d
	...if value'="" d
	....s value=$TR(value,"!","|")
	....i ($d(^SSU("SSUSR",value))) s value=value_"|"_$p(^SSU("SSUSR",value),"^",2)  //签名
    . //b v1
    .if flag="1" s value=selval
	.s value=##class(web.DHCNUREMR).Replace(value,"&KeyEnter;","\n")    //, 
	.;s value=##class(web.DHCNUREMR).Replace(value,"&","\\")    //, 
	
	.//首次护理记录单打印时，如果评分为空，自动将"分"字隐藏。  add by yjn 20171222
	.i (code="DHCNURPGD_SCHLJL")&(it="S156")&(+value=value) d
	..s value=value_"分"
	.//身高
	.i (code="DHCNURPGD_SCHLJL")&(it="S148")&(+value=value) d
	..s value=value_"cm"
	.//体重
	.i (code="DHCNURPGD_SCHLJL")&(it="S149")&(+value=value) d
	..s value=value_"kg"
	
	.s value=$ZCVT(value,"O","XML")
	.//w ! ,code,"--",value,"--",it,"--",itm
    .//s a=a_"<"_itm_" typ="""_it_""">"_##class(web.DHCNUREMR).Replace(value,"&nbsp;"," ")_"</"_itm_">"
    .s tempStr="<"_itm_" typ="""_it_""">"_##class(web.DHCNUREMR).Replace(value,"&nbsp;"," ")_"</"_itm_">"
    .d datastream.Write(tempStr)
    
    s itm=""  f  s itm=$O(itmLabelVal(EmrCode,itm)) q:itm=""  d
    .s value=itmLabelVal(EmrCode,itm)
    .//s a=a_"<"_itm_" typ="""_itm_""">"_##class(web.DHCNUREMR).Replace(value,"&nbsp;"," ")_"</"_itm_">"  //5
    .s tempStr="<"_itm_" typ="""_itm_""">"_##class(web.DHCNUREMR).Replace(value,"&nbsp;"," ")_"</"_itm_">"
    .d datastream.Write(tempStr)
    s b="<?xml version='1.0' encoding='UTF-8'?>"
    s a=b_"<Root>"_a_"</Root>"
    s tempStr="</Root>"
    d datastream.Write(tempStr)
   // s b="<?xml version='1.0' encoding='UTF-8'?>"
   // s a=b_"<?xml version='1.0' encoding='UTF-8'?><Root><B9 typ='T101'>63^45^0^0^1^0^0^S102^CareDate^日期|63^44^1^0^2^45^0^S103^CareTime^时间|63^42^2^0^3^89^0^S104^Item1^护理级别|63^38^3^0^4^131^0^S105^Item2^饮食|63^37^4^0^5^169^0^S106^Item3^意识|63^3^5^0^6^206^0^S107^Item4^T(?)|63^38^6^0^7^244^0^S108^Item5^P/HR(次/分)|63^38^7^0^8^282^0^S109^Item6^R(次/分)|63^49^8^0^9^320^0^S110^Item7^BP(mmHg)|63^38^9^0^10^369^0^S111^Item9^SPO2(%)|63^38^10^0^11^407^0^S112^Item10^吸氧(升/分)|63^37^11^0^12^445^0^S113^Item11^切口敷料|23^111^12^0^13^482^0^^^入液量(ml)|23^130^13^0^15^593^0^^^出液量(ml)|63^45^14^0^18^723^0^S119^Item17^其他1|63^45^15^0^19^768^0^S120^Item18^其他2|63^135^16^0^20^813^0^S121^CaseMeasure^病情观察及护理措施|63^44^17^0^21^948^0^S122^User^签名|63^3^18^0^22^992^0^S124^DiagnosDr^DiagnosDr|40^68^19^1^13^482^23^S114^Item12^名称_|40^43^20^1^14^550^23^S115^Item13^量_|40^50^21^1^15^593^23^S116^Item14^名称|40^41^22^1^16^643^23^S117^Item15^量|40^39^23^1^17^684^23^S118^Item16^颜色性状|\\CareDate^CareTime^Item1^Item2^Item3^Item4^Item5^Item6^Item7^Item9^Item10^Item11^Item12^Item13^Ite14^Item15^Item16^Item17^Item18^CaseMeasure^User^DiagnosDr^$23^40^23^40^23^40^23^40^23^40^23^$45^44^42^38^37^38^38^38^49^38^38^37^68^43^50^41^39^45^45^135^44^3^$!!!!!!!!!!!!!!!!!!!!!!^!!!!!!!!!!!!!!!!!!!!!!^!!!!!!!!!!!!!!!!!!!!!!^!!!!!!!!!!!!!!!!!!!!!!^!!!!!!!!!!!!!!!!!!!!!!^!!!!!!!!!!!!!!!!!!!!!!^!!!!!!!!!!!!!!!!!!!!!!^!!!!!!!!!!!!!!!!!!!!!!^!!!!!!!!!!!!!!!!!!!!!!^</B9></Root>"
	B ;--1
    ;d datastream.Write(a)
    q datastream
    ///如果传进的方法与table的关联方法相同 就作为table的方法
}

/// 分隔参数
/// w ##class(web.DHCNUREMR).SplitParam("parr:391_1@@391_2@@391_3@@391_4@@391_5!flag:!")
ClassMethod SplitParam(str) As %String
{
	k tmpParam
	k tmpTitle
	s pos=""
	f i=1:1:$l(str,"!") d
	.s single=$p(str,"!",i)
	.q:single=""
	.s name=$p(single,":",1)
	.s desc=$p(single,":",2)
	.s tmpParam(name)=desc
	.s tmpTitle(i)=name
	.i desc["@@",$p(desc,"@@",1)'="",$p(desc,"@@",2)'="" s pos=name
	q:pos="" str

	s ret=""
	s split=$g(tmpParam(pos))
	f i=1:1:$l(split,"@@") d
	.s retStr=""
	.s splitdsec=$p(split,"@@",i)
	.q:splitdsec=""
	.f j=1:1:$o(tmpTitle(""),-1) d
	..s name=$g(tmpTitle(j))
	..s desc=$g(tmpParam(name))
	..i name=pos d
	...s desc=splitdsec
	..s retStr=$s(retStr="":name_":"_desc,1:retStr_"!"_name_":"_desc)
	.q:retStr=""
	.s retStr=retStr_"!"
	.s ret=$s(ret="":retStr,1:ret_"$"_retStr)
	
	q ret
}

}
