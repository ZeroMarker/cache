Import SQLUser

Class web.DHCTEMPOERPRINTPDA Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 614;

ClassMethod GetTempOrdClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetTempOrdExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod skinnote(Ord, OrdSub)
{
	n (Ord,OrdSub)
	s notes=""
	s notesdr=$P($G(^OEORD(Ord,"I",OrdSub,11)),"^",21)
    if notesdr'="" s notes=$P(^OEC("ACT",notesdr),"^",2)
    q notes
}

ClassMethod getanloc() As %String
{
 //获取麻醉科室dr
	s num=$L(^DHCANOPSET("anloc"),"^")
 	f i=1:1:num
 	{   s detstr=$P(^DHCANOPSET("anloc"),"^",i)
	 	s rw=$P(prior,"|")
	 	s depdr=$G(depdr)_"^"_rw
	}
	q $G(depdr)_"^"
}

ClassMethod GetTempOrdExecute(ByRef qHandle As %Binary, Adm As %String, StartDate As %String, EndDate As %String, ChangeDate As %String = "", stop As %String = "0", ssuser As %String = "", CurDep = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
    s nvar=""
    s adm=Adm
    s UsrTyp=##class(web.DHCLONGTIMEORD).ssusertyp(ssuser)
	if $G(adm)="" Set qHandle=$lb(0,repid,0) Quit $$$OK
    k ^mtemp($J,"temp",Adm)
    d ..GetPatLoc(Adm)
    if CurDep="" s CurDep=$P(^PAADM(Adm),"^",4)

    //S ^DHCOEOrdPrintSet("OrdTyp")="^长期医嘱^自备药-长期医嘱^取药医嘱^出院带药^"
    ;S ^DHCOEOrdPrintSet("OrdTyp")="^自备药-长期医嘱^取药医嘱^"
	//S ^DHCOEOrdPrintSet("OrdCat")="^14^15^16^"
	//s ^DHCDoctorDep("Dep")="^214^" //214-住院麻醉 //过滤某些科室
	s Oew="" f  s Oew=$O(^OEORD(0,"Adm",adm,Oew)) q:Oew=""  d 
	.s OrdSub=""  f  s OrdSub=$O(^OEORD(Oew,"I",OrdSub))  q:OrdSub=""  d
	..s OrdDep=$P($G(^OEORD(Oew,"I",OrdSub,1)),"^",3)
	..q:OrdDep'=CurDep
	..s OrdDate=$P($G(^OEORD(Oew,"I",OrdSub,3)),"^",7)  ;取得医嘱表医嘱日期?
	..s OrdTime=$P($G(^OEORD(Oew,"I",OrdSub,1)),"^",17)
	..s PriorDR=$P($G(^OEORD(Oew,"I",OrdSub,1)),"^",8)     ;OEC_Priority                OEORI_Priority_DR
	..i PriorDR="" q //ypz
	..s PriorDes=$P($G(^OECPR(PriorDR)),"^",2)
	..s oecprCode=$P($G(^OECPR(PriorDR)),"^",1)
	..s PriorDes="^"_PriorDes_"^"
	..q:(^DHCOEOrdPrintSet("OrdTyp")'[PriorDes)
	..//w !,PriorDes
	..s DoctorDr=$P($G(^OEORD(Oew,"I",OrdSub,1)),"^",11)
	..s user=$P($G(^OEORD(Oew,"I",OrdSub,7)),"^",1)
	..q:user=""
	..q:'$D(^SSU("SSUSR",user))
	..s DoctorDr=$P(^SSU("SSUSR",user),"^",14)
	..q:DoctorDr=""  ;s Notes=$G(^OEORD(Oew,"I", OrdSub,"DEP",1))
	..s Notes=""
	..s truedoc=0
	..s DocLoc="" //2005-12-3 qse add///////////////////////////////////////
	..f  s DocLoc=$O(^RB("RES",0,"CTPCP",DoctorDr,DocLoc)) q:DocLoc=""  d
	...if $D(^TMP($J,"loc",adm,DocLoc))  s truedoc=1
	..//q:($G(truedoc)'=1)&(UsrTyp'="NURSE") 
	..f rnum=1:1:$G(^OEORD(Oew,"I",OrdSub,"DEP",0))  d
	...s Notes=Notes_$G(^OEORD(Oew,"I",OrdSub,"DEP",rnum))
	..i $G(Notes)="" s Notes=""
	..//s ggg=$F(Notes,"-")
	..//if ($G(Notes)'="")&(ggg'=0) d
	..//.//s Notes=..note(Oew,OrdSub)
	..;q:(dd'=0)  ;过滤手术室医嘱
	..//s Rem=""
	..//f rnum=1:1:$G(^OEORD(Oew,"I",OrdSub,"REM",0))  d //为阳性
	...//s Rem=Rem_$G(^OEORD(Oew,"I",OrdSub,"REM",rnum))
	..//i $G(Rem)="" s Rem=""
	..i DoctorDr'=""  s Doctor=$P(^CTPCP(DoctorDr,1),"^",2) ;write doctor oeori_doctor_dr
	..e  s Doctor=""
    ..if DoctorDr'="" s CpTypDR=$P(^CTPCP(DoctorDr,1),"^",4)  ;CTPCP_CarPrvTp_DR
	..if '$D(^CT("CPT",CpTypDR)) w !,DoctorDr
	..q:'$D(^CT("CPT",CpTypDR))
	..i $G(CpTypDR)'="" s CpTyp=$P(^CT("CPT",CpTypDR),"^",4)  ;CT_CarPrvTp
	..q:($G(CpTyp)'="DOCTOR")&($G(^DHCOEOrdPrintSet("ifnur"))'="true")  //&(UsrTyp'="NURSE")  //ypz 061102
	..s SchLoc=$$GetDocDep(DoctorDr)
	..if $G(^DHCOEOrdPrintSet("NotLoc"))[SchLoc&($G(^DHCOEOrdPrintSet("NotLoc"))'="")  d
	...//w !,OrdSub,"-",SchLoc,"=="
    ..s DateEx="",TimeEx="" ,CPTEx=""
	..s cl=0 s cl=$O(^OEORD(Oew,"I",OrdSub,"X",cl))
	..i cl=""  s cl=1
	..i $D(^OEORD(Oew,"I",OrdSub,"X",cl))  d
	...s DateEx=$P(^OEORD(Oew,"I",OrdSub,"X",cl),"^",19) i DateEx'="" s DateEx=$ZD(DateEx,3)  ;nursing execute
	...s TimeEx=$P(^OEORD(Oew,"I",OrdSub,"X",cl),"^",20)  i TimeEx'=""  s TimeEx=$ZT(TimeEx,2)
	...s CPTExDR=$P(^OEORD(Oew,"I",OrdSub,"X",cl),"^",15)
	...i CPTExDR'="" s CPTEx=$P(^CTPCP(CPTExDR,1),"^",2)  
	...e  d
	....s StopStr=##class(web.DHCLONGTIMEORD).SingNur(Oew,OrdSub)
	....if StopStr'="" d
	.....s DateEx=$P(StopStr,"|",1),TimeEx=$P(StopStr,"|",2),CPTEx=$P(StopStr,"|",3)
	.....;s CPTEx=""
	..s str=""
	..s str=..PRX(Oew,OrdSub)
	..if str'="" d
	...s ExDoctor=$P(str,"|",3)
	...s ExDate=$P(str,"|",1)
	...s ExTime=$P(str,"|",2)
	..e  d
	...s ExDoctor=""
	...s ExDate=""
	...s ExTime=""
	..s ArcimDR=$P($G(^OEORD(Oew,"I",OrdSub,1)),"^",2)
	..s ARCIMRowid=$P(ArcimDR,"||",1)
	..s ARCIMSub=$P(ArcimDR,"||",2) 
	..s ARCIMD=$P($G(^ARCIM(ARCIMRowid,ARCIMSub,1)),"^",2)  ;ord name   
	..s ARCIMDesc=$P(ARCIMD,"]",2)
	..if ARCIMDesc="" s ARCIMDesc=$P(ARCIMD,"]",1)
	..s pacunit=$P($G(^ARCIM(ARCIMRowid,ARCIMSub,8)),"^",14)
	..if pacunit'="" s pacunit=$P(^CT("UOM",pacunit),"^",2) 
	..s ItemCatDR=$P($G(^ARCIM(ARCIMRowid,ARCIMSub,1)),"^",10) ;oeori_itmmast_dr->arcim_itemcat_dr->arcic_ordcat_dr->orcat_code
	..;W "ArcimDR:",ArcimDR,!
	..q:(ItemCatDR="")
	..s OrdCatDR=$P(^ARC("IC",ItemCatDR),"^",8)    ;ARc_Itemcat
	..s CatDR="^"_OrdCatDR_"^"
	..//q:(OrdCatDR=49)!(OrdCatDR=52)   //材料,收费
	..s OrdCat=$P(^OEC("ORCAT",OrdCatDR),"^",1)    ;OEC_OrderCategory           ARCIC_OrdCat_DR 
	..s OrdCat="^"_OrdCat_"^"
	..q:$G(^DHCOEOrdPrintSet("NotOrdCat"))[CatDR&($G(^DHCOEOrdPrintSet("NotOrdCat"))'="")
	..s PHFreqDR=$P($G(^OEORD(Oew,"I",OrdSub,2)),"^",4)  ;eat medcine medicine frequency
	..i (PHFreqDR'="") d
	...if $D(^PHCFR(PHFreqDR)) s PHFreq=$P(^PHCFR(PHFreqDR),"^",3) 
	...e  s PHFreq=""
	..e  s PHFreq=""  ;table       PHC_Freq
	..s UOMDR=$P($G(^OEORD(Oew,"I",OrdSub,2)),"^",3  ) ;CT_UOM                      OEORI_Unit_DR
	..i UOMDR'="" s UOM=$P(^CT("UOM",UOMDR),"^",2)  
	..e  s UOM="" 
	..s DoseQty=$P($G(^OEORD(Oew,"I",OrdSub,2)),"^",1)   ;numeric  oeori_doseqty,ji Liang
	..if (DoseQty'="")&($P(DoseQty,"."))="" s DoseQty="0"_DoseQty
	..//if DoseQty'="" s ARCIMDesc=$P(ARCIMDesc,"(")
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
	..i Oew=1077641 s ^ypzDebug("norm",OrdSub)=OrdStat
	..q:OrdStatDR=11
	..s Seq2=$P($G(^OEORD(Oew,"I",OrdSub,3)),"^",4)  ;relation No
	..s SeqNo=$p($g(^OEORD(Oew,"I",OrdSub,11)),"^",39) //qshe add 05-08-22
    ..if SeqNo'="" d
    ...s tmpSeqNo=$P(SeqNo,"||",2) ,ARCIMDesc="_____"_ARCIMDesc
    ..e  s tmpSeqNo=OrdSub
    ..s Seq1=tmpSeqNo
    ..s PackNum=""
	..s PadmTyp=$P(^PAADM(adm),"^",2)
	..s PackNum=$P($G(^OEORD(Oew,"I",OrdSub,9)),"^",4)  ;zheng baozhuang shu   OEORI_QtyPackUOM
	..s RefundQty=$P($G(^OEORD(Oew,"I",OrdSub,3)),"^",23)
	..//if PackNum'="" w !,OrdSub
	..s TZh=""
	..//s PHStat=..PHASTAT(Oew,OrdSub)
	..//q:(OrdStatDR=4)&(PHStat="P")  //停了未发
	..//q:(OrdStatDR=4)&(PHStat="")&(^DHCOEOrdPrintSet("OrdCat")[OrdCat)  //停了不是药
	..if (OrdStatDR=4)&(^DHCOEOrdPrintSet("OrdCat")[OrdCat) d
	...s Ret=..PHPACK(Oew,OrdSub)  //退药情况
	...i Ret=1 s TZh="Pass"  
	...//i (PackNum="")&(PhQtyOrd=RefundQty) s TZh="Pass"
	..//q:($G(TZh)="Pass")&(PriorDR'=6)
	..//q:(OrdStatDR=4)&(^DHCOEOrdPrintSet("OrdCat")'[OrdCat)&(stop=2)
	..;i ^DHCOEOrdPrintSet("OrdCat")[OrdCat d
	..;.i PackNum=""  s Numeric=PhQtyOrd
	..;.e  s Numeric=PackNumI
	..;e  s Numeric=""
	..s numstr="",QtyStr=""
	..if $G(PackNum)'="" s PackStr=$G(PackNum)_""_$G(pacunit)
	..if $G(PhQtyOrd)'="" s QtyStr=$G(PhQtyOrd)_" "_$G(UOM)
	..if $G(PackStr)'="" s numstr=$G(PackStr)
	..e  s numstr=$G(QtyStr)
	..if PackNum="" s numstr=""
	..;i ^DHCOEOrdPrintSet("OrdCat")[OrdCat d  
	..;.s DayNum=$G(PhQtyOrd)
	..;.s pacunit="",UOM=""
	..;e  s DayNum=$g(During)
	..;i ^DHCOEOrdPrintSet("OrdCat")[OrdCat s DayNum=$G(PhQtyOrd)  ;除药品外其余的数量都为空
	..;e  s DayNum=""
	..//if numstr'="" w !,OrdSub,"--"
	..q:(OrdStat="停止")&($G(^DHCOEOrdPrintSet("ifstop"))'="true")
	..s xCtcpDesc="" //ypz 070802
	..s xCtcpId=$p($g(^OEORD(Oew,"I",OrdSub,3)),"^",29) //ypz 070802
	..i xCtcpId'="" s xCtcpDesc=" "_$p($g(^CTPCP(xCtcpId,1)),"^",2) //ypz 070802
	..i OrdStat="停止" s Cancel="---DC"_xCtcpDesc ;Doctor //ypz 070802
	..e  s Cancel=""
	..q:(OrdStat="停止")&(stop="0")   ///(UsrTyp="NURSE")&jst add qse 070416
    ..s i=i+1
	..i Oew=1077641 s ^ypzDebug("norm",OrdSub)=^ypzDebug("norm",OrdSub)_"/"_Cancel
    ..//皮试
    ..s skintest="",abnorm=""
    ..s skintest=$p($g(^OEORD(Oew,"I",OrdSub,5)),"^",2)
    ..if (skintest="Y")&(OrdStat'="停止") d
    ...s skinnote=..skinnote(Oew,OrdSub) //w !,OrdSub
    ...s abnorm=$p($g(^OEORD(Oew,"I",OrdSub,11)),"^",3)
    ...if abnorm="Y" s ARCIMDesc=ARCIMDesc_"(+)("_skinnote_")"
    ...if abnorm="N"  s ARCIMDesc=ARCIMDesc_"(-)("_skinnote_")"
    ..if SeqNo'=""  s ARCIMDesc="   "_ARCIMDesc
	..if PriorDes["自备"  s ARCIMDesc=ARCIMDesc_"(自备)"
	..if ^DHCOEOrdPrintSet("OrdCat")[OrdCat d
	...//.s ARCIMDesc=..GetArcim(ARCIMDesc)     ;w !, PriorDes_ARCIMDesc//
	...i oecprCode="OUT" d  //ypz 070802 //if PriorDes=("^出院带药^") d
	....s ARCIMDesc=ARCIMDesc_" "_DoseQty_""_UOM_" "_Meth_" "_PHFreq_""_$G(numstr)_" "_$G(Cancel)_" "_$G(Notes)
	...i oecprCode="ONE" d  //ypz 070802 //if PriorDes="^取药医嘱^" d
	....s ARCIMDesc=ARCIMDesc_" "_$G(numstr)_" "_PHFreq_" "_$G(Cancel)_" "_$G(Notes)
	...//if (PriorDes="^即刻医嘱^")!(PriorDes="^临时医嘱^")!(PriorDes="^自备药即刻^")!(PriorDes="^自备药临时^") d
	...if (oecprCode="STAT")!(oecprCode="NORM")!(oecprCode="^自备药即刻^")!(oecprCode="OM") d
	....s ARCIMDesc=ARCIMDesc_" "_DoseQty_" "_UOM_" "_$G(Meth)_" "_PHFreq_" "_""_$G(numstr)_""_" "_$G(Cancel)_" "_$G(Notes)
	....//w !,ARCIMDesc ;
	..e  d
	...if OrdCatDR=21 s ARCIMDesc=ARCIMDesc  //21医技检查
	...e   d  //$G(PhQtyOrd)>
	....if 1 s ARCIMDesc=ARCIMDesc_" "_$G(Notes)_" "_"x"_$G(PhQtyOrd)_$G(UOM)
	..//if (PriorDes="^即刻医嘱^")&(^DHCOEOrdPrintSet("OrdCat")'[OrdCat) s ARCIMDesc=ARCIMDesc_" st"  
	..if (oecprCode="STAT")&(^DHCOEOrdPrintSet("OrdCat")'[OrdCat) s ARCIMDesc=ARCIMDesc_" st"  
	..if ^DHCOEOrdPrintSet("OrdCat")'[OrdCat  s ARCIMDesc=ARCIMDesc_"  "_$G(Cancel)
	..i Oew=1077641 s ^ypzDebug("norm",OrdSub)=^ypzDebug("norm",OrdSub)_"/"_ARCIMDesc
	..//s OrdList(OrdDate,OrdTime,Seq1,Seq2)=$TR($E($ZD(OrdDate,3),6,10),"-","/")_"|"_$ZT(OrdTime,4)_"|"_$G(Doctor)_"|"_ARCIMDesc_"|"_$G(ExDoctor)_"|"_$G(TimeEx)_"|"_$G(CPTEx)_"|"_$TR($E($G(DateEx),6,10),"-","/")
	..s OrdList(OrdDate,OrdTime,Seq1,Seq2)=$E($ZD(OrdDate,3),3,10)_"|"_$ZT(OrdTime,2)_"|"_$G(Doctor)_"|"_ARCIMDesc_"|"_$G(ExDoctor)_"|"_$G(TimeEx)_"|"_$G(CPTEx)_"|"_$TR($E($G(DateEx),6,10),"-","/")
	..s OrdSub(OrdDate,OrdTime,Seq1,Seq2)=Oew_"||"_OrdSub
	..s OrdStat(OrdDate,OrdTime,Seq1,Seq2)=OrdStat
	..s OrdDose(OrdDate,OrdTime,Seq1,Seq2)=$G(DoseQty)
	..if StTime="" s StTime=OrdTime
	..s OrdListC(StDate,StTime,Seq1,Seq2)=$E($ZD(StDate,3),3,10)_"|"_$ZT(StTime,2)_"|"_$G(Doctor)_"|"_ARCIMDesc_"|"_$G(ExDoctor)_"|"_$G(TimeEx)_"|"_$G(CPTEx)_"|"_$TR($E($G(DateEx),6,10),"-","/")
	..s OrdSubC(StDate,StTime,Seq1,Seq2)=Oew_"||"_OrdSub
	..s OrdStatC(StDate,StTime,Seq1,Seq2)=OrdStat
	..s OrdDoseC(StDate,StTime,Seq1,Seq2)=$G(DoseQty)
	..;b
	s i=0
 if $G(ChangeDate)=""{
	s OrdDate=""  f  s OrdDate=$O(OrdList(OrdDate))  q:OrdDate=""  d
	.s tim="" f  s tim=$O(OrdList(OrdDate,tim))  q:tim=""  d
	..s Seq1=""  f  s Seq1=$O(OrdList(OrdDate,tim,Seq1)) q:Seq1=""  d
	...s Seq2=""  f  s Seq2=$O(OrdList(OrdDate,tim,Seq1,Seq2))  q:Seq2=""  d
	....s ORW="", DisposNurDr="",DisposNur="",DisposDate="",DisposTime=""
	....s OerdDate=$P(OrdList(OrdDate,tim,Seq1,Seq2),"|",1)
	....s OerdTime=$P(OrdList(OrdDate,tim,Seq1,Seq2),"|",2)
	....s Doctor=$P(OrdList(OrdDate,tim,Seq1,Seq2),"|",3)
	....s ARCIMDesc=$P(OrdList(OrdDate,tim,Seq1,Seq2),"|",4)
	....s ExDoctor=$P(OrdList(OrdDate,tim,Seq1,Seq2),"|",5)
	....s TimeEx=$P(OrdList(OrdDate,tim,Seq1,Seq2),"|",6)
	....s DateEx=$P(OrdList(OrdDate,tim,Seq1,Seq2),"|",8)
	....s CPTEx=$P(OrdList(OrdDate,tim,Seq1,Seq2),"|",7)
	....s ORW=OrdSub(OrdDate,tim,Seq1,Seq2),OrdStat=OrdStat(OrdDate,tim,Seq1,Seq2)
	....s rw=$P(ORW,"||"),chl=$P(ORW,"||",2)
	....//q:(stop'=2)&(OrdStat(OrdDate,tim,Seq1,Seq2)="停止")&('$d(^DHCTEMPHBORD(rw,chl)))&($G(OrdDose(OrdDate,tim,Seq1,Seq2))="")
	....//q:(stop=2)&($G(OrdDose(OrdDate,tim,Seq1,Seq2))'="")  //&($G(XDate(rw,chl))="") //s Arcim=$G(Arcim)_" "_"作废"
	....//q:(stop=2)&(OrdStat(OrdDate,tim,Seq1,Seq2)'="停止")
	....if $D(^DHCLOGSHORTORD("lsord",ORW)) d
	.....s ExDC=$P(^DHCLOGSHORTORD("lsord",ORW),"^",1)
	.....s ExNur=$P(^DHCLOGSHORTORD("lsord",ORW),"^",3)
	.....s ExTime=$P(^DHCLOGSHORTORD("lsord",ORW),"^",2)
    ....if $D(^DHCCLNurseExec("oeorid",ORW)) d
	.....s DisposNurDr=$P(^DHCCLNurseExec("oeorid",ORW),"^",3) //处理人
	.....s DisposDate=$ZD($P(^DHCCLNurseExec("oeorid",ORW),"^",1),3) 
	.....s DisposTime=$ZT($P(^DHCCLNurseExec("oeorid",ORW),"^",2),2)
	.....if DisposNurDr'=""  s DisposNur=$P(^SSU("SSUSR",DisposNurDr),"^",2)
	....if $G(DisposNurDr)="" d
	.....s DisposNur=$G(CPTEx),DisposTime=$G(TimeEx)
	....q:((OrdDate<StartDate)!(OrdDate>EndDate)&((StartDate'="")&(EndDate'="")))
    ....if $D(^DHCLONGSET("audittemp",Adm,ORW))  d  //核对
    .....s DisposNur=$G(DisposNur)_"_"_1
    ....D OutPut
    ....s i=i+1
    ....s ^mtemp($J,"temp",Adm,i)=OerdDate_"^"_OerdTime_"^"_ARCIMDesc_"^"_Doctor_"^"_DateEx_"^"_TimeEx_"^"_CPTEx_"^"_ORW_"^"_OrdStat_"^"_$J_"^"_$G(DisposTime)_"^"_$G(DisposNur)
    ....
    ..
 }else{  //医务科用
	s OrdDate=""  f  s OrdDate=$O(OrdListC(OrdDate))  q:OrdDate=""  d
	.s tim=""  f  s tim=$O(OrdListC(OrdDate,tim))  q:tim=""  d
	..s Seq1=""  f  s Seq1=$O(OrdListC(OrdDate,tim,Seq1)) q:Seq1=""  d
	...s Seq2=""  f  s Seq2=$O(OrdListC(OrdDate,tim,Seq1,Seq2))  q:Seq2=""  d
	....s ORW="", DisposNurDr="",DisposNur="",DisposDate="",DisposTime=""
	....s OerdDate=$P(OrdListC(OrdDate,tim,Seq1,Seq2),"|",1)
	....s OerdTime=$P(OrdListC(OrdDate,tim,Seq1,Seq2),"|",2)
	....s Doctor=$P(OrdListC(OrdDate,tim,Seq1,Seq2),"|",3)
	....s ARCIMDesc=$P(OrdListC(OrdDate,tim,Seq1,Seq2),"|",4)
	....s ExDoctor=$P(OrdListC(OrdDate,tim,Seq1,Seq2),"|",5)
	....s TimeEx=$P(OrdListC(OrdDate,tim,Seq1,Seq2),"|",6)
	....s DateEx=$P(OrdListC(OrdDate,tim,Seq1,Seq2),"|",8)
	....s CPTEx=$P(OrdListC(OrdDate,tim,Seq1,Seq2),"|",7)
	....s ORW=OrdSubC(OrdDate,tim,Seq1,Seq2),OrdStat=OrdStatC(OrdDate,tim,Seq1,Seq2)
	....s rw=$P(ORW,"||"),chl=$P(ORW,"||",2)
	....q:(stop'=2)&(OrdStatC(OrdDate,tim,Seq1,Seq2)="停止")&('$d(^DHCTEMPHBORD(rw,chl)))&($G(OrdDose(OrdDate,tim,Seq1,Seq2))="")
	....q:(stop=2)&($G(OrdDoseC(OrdDate,tim,Seq1,Seq2))'="")  //&($G(XDate(rw,chl))="") //s Arcim=$G(Arcim)_" "_"作废"
	....q:(stop=2)&(OrdStatC(OrdDate,tim,Seq1,Seq2)'="停止")
	....if $D(^DHCCLNurseExec("oeorid",ORW)) d
	.....s DisposNurDr=$P(^DHCCLNurseExec("oeorid",ORW),"^",3) //处理人
	.....s DisposDate=$ZD($P(^DHCCLNurseExec("oeorid",ORW),"^",1),3) 
	.....s DisposTime=$ZT($P(^DHCCLNurseExec("oeorid",ORW),"^",2),2)
	.....if DisposNurDr'=""  s DisposNur=$P(^SSU("SSUSR",DisposNurDr),"^",2)
	....q:((OrdDate<StartDate)!(OrdDate>EndDate)&((StartDate'="")&(EndDate'="")))
    ....D OutPut
    ....s i=i+1
    ....if $G(DisposTime)="" d
    .....s DisposNur=$G(CPTEx),DisposTime=$G(TimeEx)
    ....s ^mtemp($J,"temp",Adm,i)=OerdDate_"^"_OerdTime_"^"_ARCIMDesc_"^"_Doctor_"^"_DateEx_"^"_TimeEx_"^"_CPTEx_"^"_ORW_"^"_OrdStat_"^"_$J_"^"_$G(DisposTime)_"^"_$G(DisposNur)
    ...
    .

 }
    s ^mtemp($J,"temp",Adm)=i
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
 //"起始日期|<起始时间|<临时医嘱|<医生签字|<执行时间|<执行人"/
OutPut
	set Data=$lb(OerdDate,OerdTime,ARCIMDesc,Doctor,DateEx,TimeEx,CPTEx,ORW,$j,$G(DisposTime),$G(DisposNur),$G(ExDC),$G(ExNur),$G(ExTime))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
GetDocDep(Doc)
  {
  n 
 //^RB("RES",0,"CTPCP",{RES_CTPCP_DR},{RES_CTLOC_DR},{RES_RowId}) 
  s Loc=""  s Loc=$O(^RB("RES",0,"CTPCP",Doc,Loc),-1)
  Q "^"_$G(Loc)_"^"
 }
}

ClassMethod PHPACK(Ord, OrdSub)
{
   n (Ord,OrdSub)
     s i=0
	 s OrdEx=0  f  s OrdEx=$O(^OEORD(Ord,"I",OrdSub,"X",OrdEx))  q:(OrdEx="")  d
    .s OrdDsp=0  f  s OrdDsp=$O(^OEORD(Ord,"I",OrdSub,"X",OrdEx,"D",OrdDsp)) q:(OrdDsp="")!(i=1)  d
    ..s Dsp=^OEORD(Ord,"I",OrdSub,"X",OrdEx,"D",OrdDsp) 
    ..s Stat=$P(Dsp,"^",6)
    ..q:Stat'="C"
    ..s Qty=$G(Qty)+$P(Dsp,"^",1) 
    ..s ReQty=$G(ReQty)+$P(Dsp,"^",7)
    ..
    if $G(Qty)=$G(ReQty) s Re=1
    e  s Re=0 
    q Re
}

ClassMethod PHASTAT(Ord, OrdSub)
{
 
   n (Ord,OrdSub)
     s i=0
	
	 s OrdEx=0  f  s OrdEx=$O(^OEORD(Ord,"I",OrdSub,"X",OrdEx))  q:(OrdEx="")!(i=1)  d
    .s OrdDsp=0  f  s OrdDsp=$O(^OEORD(Ord,"I",OrdSub,"X",OrdEx,"D",OrdDsp)) q:(OrdDsp="")!(i=1)  d
    ..s Dsp=^OEORD(Ord,"I",OrdSub,"X",OrdEx,"D",OrdDsp) 
    ..s i=i+1
    ..s Stat=$P(Dsp,"^",6)  
    ..b
 q $G(Stat)
}

ClassMethod GetItem(i As %String, Adm As %String, strj As %String)
{
	q ^mtemp(strj,"temp",Adm,i)
}

ClassMethod GetItemNum(Adm As %String, strj As %String)
{
	q ^mtemp(strj,"temp",Adm)
}

ClassMethod GetPatLoc(Adm As %String)
{
  	n (Adm)
  	s loc=""  f  s loc=$O(^PAADMi("TransLoc",Adm,loc)) q:loc=""  d
  	.s ^TMP($J,"loc",Adm,loc)="" 
  	s ^TMP("AdmLoc")=$J
  	q
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

Query GetTempOrd(Adm As %String, StartDate As %String, EndDate As %String, ChangeDate As %String, stop As %String = "0", ssuser As %String = "", Dep = "") As %Query(ROWSPEC = "OerdDate,OerdTime,ARCIMDesc,Doctor,DateEx,TimeEx,CPTEx,ORW,ProcessNo,DisposTime,DisposNur,ExDC,ExNur,ExTime")
{
}

ClassMethod PRX(Oew, OrdSub)
{
	  n (Oew,OrdSub)
	  ; ^OEORD({OE_Order.OEORD_RowId},"I",{OE_OrdItem.OEORI_Childsub}, "ST",{ST_Childsub})
	   s STR=""
	   s chl=""  f  s chl=$O(^OEORD(Oew,"I",OrdSub, "ST",chl)) q:chl=""  d
	   .s statDR=$P(^OEORD(Oew,"I",OrdSub, "ST",chl),"^",3)
	   .s xdate=$P(^OEORD(Oew,"I",OrdSub, "ST",chl),"^",1)
	   .s xtime=$P(^OEORD(Oew,"I",OrdSub, "ST",chl),"^",2)
	   .s cdoc=$P(^OEORD(Oew,"I",OrdSub, "ST",chl),"^",4)
	   .if (statDR=4)&(cdoc="") s STR=$ZD(xdate,3)_"|"_$ZT(xtime,2)_"|"_""
	   .i (statDR=4)&((cdoc'=""))  s STR=$ZD(xdate,3)_"|"_$ZT(xtime,2)_"|"_$P(^SSU("SSUSR",cdoc),"^",2)
	   q $G(STR)
}

ClassMethod note(Oew, OrdSub)
{
	   n (Oew,OrdSub)
	   s Notes=""
	   f rnum=2:1:$G(^OEORD(Oew,"I",OrdSub,"DEP",0))  d
	.s Notes=Notes_$G(^OEORD(Oew,"I",OrdSub,"DEP",rnum))
	q $G(Notes)
}

ClassMethod startrow(typ, adm, page, startrow, Dep) As %String
{
 s ^DHCBLPRINTROW(typ,"xd",adm,Dep)=page_"|"_startrow
	  q 0
}

ClassMethod TmpStartrow(typ, adm, page, startrow, Dep) As %String
{
  //扑打设置
 s ^DHCBLPRINTROWTMP(typ,"xd",adm,Dep)=page_"|"_startrow
 q 0
}

ClassMethod KTmpSet(typ, adm, Dep) As %String
{
  //清除补打设置
  k ^DHCBLPRINTROWTMP(typ,"xd",adm,Dep)
  q 0
}

ClassMethod schtystrow(typ, adm, Dep) As %String
{
  q:(typ="")!(adm="")!(Dep="") ""
  if ($G(^DHCBLPRINTROW(typ,"xd",adm,Dep))="") {
	   s str=$G(^DHCBLPRINTROW(typ,adm))
	   s str1=$G(^DHCBLPRINTROW(typ,adm,Dep))
	   if str1'=""  s ^DHCBLPRINTROW(typ,"xd",adm,Dep)=str1
	   if str'=""  s ^DHCBLPRINTROW(typ,"xd",adm,Dep)=str
	   k ^DHCBLPRINTROW(typ,adm)
	   //s ^DHCBLPRINTROW(typ,"xd",adm,Dep)=str
  }
  q $G(^DHCBLPRINTROW(typ,"xd",adm,Dep))
}

ClassMethod TmpSch(typ, adm, Dep) As %String
{
  if ($G(^DHCBLPRINTROW(typ,"xd",adm,Dep))="") {
	   s str=$G(^DHCBLPRINTROW(typ,adm))
	   s str1=$G(^DHCBLPRINTROW(typ,adm,Dep))
	   if str1'=""  s ^DHCBLPRINTROW(typ,"xd",adm,Dep)=str1
	   if str'=""  s ^DHCBLPRINTROW(typ,"xd",adm,Dep)=str
	   k ^DHCBLPRINTROW(typ,adm)
	   //s ^DHCBLPRINTROW(typ,"xd",adm,Dep)=str
  }
  q $G(^DHCBLPRINTROW(typ,"xd",adm,Dep))
}

ClassMethod saveordno(typ, ordno, flag) As %String
{
	    s ^DHCLOGSHORTORD(typ,ordno)=flag
	    q 0
}

ClassMethod fetchordno(typ, ordno) As %String
{
	    q $G(^DHCLOGSHORTORD(typ,ordno))
}

ClassMethod savestopord(ordno, typ) As %String
{
  
        ///停止医嘱

	    /// k (typ,ordno)stoporditem
	      s ^DHCSTOPORDITEM(ordno,typ)=""
	      q 0
}

ClassMethod stoporditem(ordno, typ) As %String
{
 //k (typ,ordno)
	      q $D(^DHCSTOPORDITEM(ordno,typ))
}

ClassMethod GetArcim(arc) As %String
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
 b
 s f1=$F(arc3,"*")
 if (f1=0)&(arc3'="") s a=$G(a)_"("_arc3
 b
 s f1=$F(arc4,"*")
 if (f1=0)&(arc4'="") s a=$G(a)_"("_arc4
 b
 s f1=$F(arc5,"*")
 if (f1=0)&(arc5'="") s a=$G(a)_"("_arc5
 s f1=$F(arc6,"*")
 if (f1=0)&(arc6'="") s a=$G(a)_"("_arc6
 
 q a
}

ClassMethod UpdateDate(par, exdate, extime) As %String
{
	n (par,exdate,extime)
	s exdate=$ZDH(exdate,3)
	s extime=$ZTH(extime)
	&sql(update oe_ordexec set OEORE_DateExecuted=:exdate, OEORE_TimeExecuted=:extime where oeore_oeori_parref=:par)
	q SQLCODE
}

ClassMethod UpdateStDate(Row, StDate, StTime) As %String
{
	n (Row, StDate, StTime)
	S StDate=$ZDH(StDate,3)
	s StTime=$ZTH(StTime)
	&sql(update oe_orditem set  OEORI_SttDat=:StDate,  OEORI_SttTim=:StTime where oeori_rowid=:Row)
	q SQLCODE
}

ClassMethod SaveHBord(oeoriIdStr) As %String
{
	//保存后补不打印医嘱
	s cl=$P(oeoriIdStr,"^",1)
	if cl="Clear"
	{
		s orw=$P($P(oeoriIdStr,"^",2),"||",1)
		k ^DHCTEMPHBORD(orw)
	}
	q:cl="Clear" 0
	s num=$l(oeoriIdStr,"^")
		s oeoriId=$p(oeoriIdStr,"^",1)
	    s oew=$P(oeoriId,"||")
        k ^DHCTEMPHBORD(oew)
		f i=1:1:num d
	    .s oeoriId=$p(oeoriIdStr,"^",i)
	    .s oew=$P(oeoriId,"||")
	    .s sub=$P(oeoriId,"||",2)
	    .s ^DHCTEMPHBORD(oew,sub)=""
	 q 0
}

ClassMethod GetOrdChecked(oeord) As %String
{
  n (oeord)
	s orw=$P(oeord,"||")
	s sub=$P(oeord,"||",2)
	if $D(^DHCTEMPHBORD(orw,sub)) s ret=1
	else  s ret=0
	q ret
}

ClassMethod getloc(oeord, ordsub) As %String
{
	 n (oeord,ordsub)
    s admId=$p($g(^OEORD(oeord)),"^",1)
	s ctlocdr=$P(^PAADM(admId),"^",4)
	 s user=$P($G(^OEORD(oeord,"I",ordsub,7)),"^",1)
	 s userdep=$P($G(^OEORD(oeord,"I",ordsub,7)),"^",2)  //oeori_UserDepartment_DR
	 q:user="" ""
	 q:'$D(^SSU("SSUSR",user)) ""
	 s DoctorDr=$P(^SSU("SSUSR",user),"^",14)
	 q:DoctorDr="" "" ;s Notes=$G(^OEORD(Oew,"I", OrdSub,"DEP",1))

	 q:'$D(^CTPCP(DoctorDr,1)) ""
	 s typdr=$P(^CTPCP(DoctorDr,1),"^",4)
	 s typ=$P(^CT("CPT",typdr),"^",4)
	 s i=0
	 s loc="" f  s loc=$O(^RB("RES",0,"CTPCP",DoctorDr,loc)) q:(loc="")  d
	 .s i=i+1
	 s loc="" f  s loc=$O(^RB("RES",0,"CTPCP",DoctorDr,loc)) q:(loc="")!(loc=ctlocdr)  d
	 if (i>2)&(userdep'=ctlocdr)&(userdep'="")
	 {
		 q ""
	 }

	 q loc
}

}
