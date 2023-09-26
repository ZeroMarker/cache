Class web.DHCaOET Extends %RegisteredObject [ ProcedureBlock ]
{

ClassMethod CO29(DoseQty, PHCFRrow, PHCDUrow, Prior, SttDate, EndDate) As %String
{
	; $$ Computed Value for field number 29
	 ;n (DoseQty,PHCFRrow,PHCDUrow,Prior,SttDate,EndDate)
	 s Prior=$g(Prior),PriorCode=$p($g(^OECPR(+Prior)),"^")
	 s SttDate=$g(SttDate),EndDate=$g(EndDate)
	 ;s Freq=$$FreqFac^aOE14(PHCFRrow) 
	 s Freq=$$FreqFac(PHCFRrow) 
	 s Duration=$p($g(^PHCDU(+PHCDUrow)),"^",2)
	 i 'PHCDUrow,SttDate,EndDate s Duration=EndDate-SttDate+1
	 ;$$DuraFac^aOE14(PHCDUrow)
	 s s=$g(^PHCFR(+PHCFRrow))
	 s FreqFactor=$p(s,"^",2),FreqDays=$p(s,"^",5)
	 s:'Duration Duration=1
	 ;
	 i " ONE STAT "[(" "_PriorCode_" ") s FreqFactor=1,Duration=1
	 i FreqDays,'FreqFactor s FreqFactor=Duration-1\FreqDays+1,Duration=1
	 S QTY=DoseQty*FreqFactor*Duration
	 q QTY
FreqFac(PHCFRrow) ; Get the factor of frequency
	 ;n Factor
	 q:$g(PHCFRrow)="" 1
	 s Factor=$P($g(^PHCFR(PHCFRrow)),"^",2)
	 q:+$g(Factor)=0 1
	 q +$g(Factor)
}

/// ; Get conversion factor  $$ConvFac^ST02
ClassMethod ConvFac(CTUOMr1, CTUOMr2) As %String
{
	 ; Convert from CTUOMr1 to CTUOMr2
	 ;n (CTUOMr1,CTUOMr2,NoMess)
	 ;n Factor,SQLCODE
	 ;
	 ; Get Unit of measurement
	 i $p(CTUOMr1,$c(1))=$p(CTUOMr2,$c(1)) q 1
	 ;temporary
	 i 'CTUOMr1!('CTUOMr2) q 1
	 ;
	 &SQL(Select CTCF_Factor into:Factor From SQlUser.CT_ConFac where CTCF_FrUOM_DR=:CTUOMr1 and CTCF_ToUOM_DR=:CTUOMr2)
	 i SQLCODE d
	 . &SQL(Select CTCF_Factor into:Factor From SQlUser.CT_ConFac where CTCF_FrUOM_DR=:CTUOMr2 and CTCF_ToUOM_DR=:CTUOMr1)
	 . i 'SQLCODE s Factor=$j((1.0000/(+Factor)),0,4)
	 q:'SQLCODE $g(Factor)
	 ;
	 q ""
}

/// 	;Default Value for Billed Flag
ClassMethod DEF76(par, arcim) As %String
{
	 q:$g(par)="" ""
	 q:$g(arcim)="" ""
	 s admtype=..admtype(par)
	 ;for OutPatients,Emergency,Health Promotion : To Bill
	 ;for InPatients : Ignore, if executable flag:Not Required => to bill
	 q:admtype="" "TB"
	 q:"OEH"[admtype "To Bill"
	 s exec=$$exec(arcim)
	 i exec["N"!(exec="") q "To Bill"
	 ;check order entry configuration
	 s type=$p($g(^CF("OE",1)),"^",15) ;BUO-bill upon ordering,BUE-bill upon execution
	 q $s(type="BUO":"To Bill",1:"Ignore")
	 ;
exec(arcim) ;find executable flag for item master
	 q:$g(arcim)="" ""
	 s subcat=$p($g(^ARCIM(+arcim,1,1)),"^",10) q:subcat="" ""
	 s execrow=$p($g(^ARC("IC",subcat)),"^",9) q:execrow="" ""
	 s exec=$p($g(^OEC("EXEC",+execrow)),"^")
 q exec
}

ClassMethod EPIS()
{
	;n (row,arcim)
	 ;s err=$$udfepisno($g(row),$g(arcim)) q:err'="" err
	 ;check configuration
	 s str=$g(^CF("PATCF",1,7)),method=$p(str,"^"),cnttype=$p(str,"^",2),length=$p(str,"^",3)
	 ;default method - system counter
	 s:method="" method="S"
	 ;if counter type not setup , use system counter
	 i method="U",'cnttype s method="S"
	 i method="D" d
	 .s:'length length=4 s ind=..next("^EPIS(+$h)"),dt=$zd($h),dt=$p(dt,"/",3)_$p(dt,"/")_$p(dt,"/",2),prno=dt_$$LPAD1(ind,"0",length)
	 i method="S" s prno=..next("^EPIS(0)")
	 i method="U" d
	 .L +^COUNT("CNTTYPE",cnttype)
	 .s s1=$g(^COUNT("CNTTYPE",cnttype)),pref=$p(s1,"^",2),suf=$p(s1,"^",3)
	 .s len=$p(s1,"^",4),cnt=$p(s1,"^",5)
	 .s cnt=cnt+1
	 .S $P(^COUNT("CNTTYPE",cnttype),"^",5)=cnt
	 .L -^COUNT("CNTTYPE",cnttype)
	 .s prno=pref_$$LPAD1(cnt,"0",len)_suf
	 q prno
LPAD1(STRING,SUB,LENGTH) ;
	 k RES 
	 S STRING=$G(STRING),LENGTH=$G(LENGTH)
	 S:'$G(LENGTH) LENGTH=8
	 S $P(RES,SUB,LENGTH)=SUB
	 Q $E(RES,1,LENGTH-$L(STRING))_$E(STRING,1,LENGTH)
}

/// Generate the executables
ClassMethod GenExe(OEORIrow As %String)
{
	Set Config=##Class(websys.Configuration).%OpenId(1)
	Set MEDDATA=Config.DataNamespace
	Set CurrentNS=$ZNSPACE
	ZN MEDDATA		
	d GenExe^aOET4(OEORIrow)
	ZN CurrentNS
	/*
 n SQLCODE,OEORI,PAADM,PAADMrow
 s OEORDrow=$p(OEORIrow,"||")
 ;
 &SQL(SELECT OEORD_ADM_DR INTO :PAADMrow FROM OE_Order WHERE  OEORD_RowId=:OEORDrow)
 ;
 d ^aOET4b 
 ;
 &SQL(SELECT * INTO :OEORI() FROM OE_OrdItem WHERE OEORI_RowId = :OEORIrow)
 q:SQLCODE 
 ;check pharmacy flag D-diet,R-drug
 s PharmFl=$$check^aOET4b($g(OEORI(4)))
 i PharmFl="D" d Diet q
 ;if IV insert executable only for outpatients
 q:" X I R "'[(" "_PharmFl_" ")
 i $p($g(PAADM(9)),$c(1))'="O",PharmFl="I" q
 ;if priority=One Dose,insert 1 excutable,ignore frequency
 i $p($g(^OECPR(+$g(OEORI(23)))),"^")="ONE" d One q
 ;if priority=Stat,insert 1 excutable,ignore frequency
 i $p($g(^OECPR(+$g(OEORI(23)))),"^")="STAT" d One q
 ;treat all patients as Inpatients (for creating of execution schedule)
 i $p($g(^CF("OE",1)),"^",40)="Y" s PAADM(9)="I"
 ;  
 ;================
 ;
InsItem1 ; Inserted selected item into OEORE - one item may means
 ;      multiple record in OEORE (when it is a profile). 
 ; Pre-requirement : OEORI()
 ;
 ; ProfFlag - Profile Flag
 ;
 n ARCIM,SQLCODE,ARCIMrow,OK,Dose,Freq,Duration,PHCFRrow
 ;
 ;---------------------------
 ;&SQL(SELECT OEORE_RowId
 ;     FROM   OE_OrdExec
 ;    WHERE  OEORE_OEORI_ParRef=:OEORI(1))
 ;q:'SQLCODE
 ;
 q:'$$GetUnit(OEORI(1)) 0
 q:'$$GetARCIM(OEORI(4)) 0
 ;
 S OK=$$InsItem(OEORI(4),"")
 ;change finsh date of the order if last date of execution is later 
 ;previous value
 Q
 s oldfindate=$$CO135a^at122($g(OEORI(17)),$g(OEORI(35)),$g(OEORI(113)))
 ;current value
 s findate=$$CO135^at122($g(OEORI(1)),$g(OEORI(17)),$g(OEORI(35)),$g(OEORI(113)))
 s seq=$p($g(OEORI(77)),$c(1))
 i seq'="",findate-oldfindate d
 .k ^OEORDi(0,"FnDtSeqNo",+$g(OEORI(1)),+oldfindate,seq,+$p(OEORI(1),"||",2))
 .s ^OEORDi(0,"FnDtSeqNo",+$g(OEORI(1)),+findate,seq,+$p(OEORI(1),"||",2))=""
 d discon($g(OEORI(1)))
 q
 ;
 ;*/
}

ClassMethod GetDrgFormPoison(ARCIMRowid) As %String
{
	;w $$GetDrgFormPoison^DHCDocOrderCommon("4859||1")
	s DrgFormRowid=$p(^ARCIM(+ARCIMRowid,$p(ARCIMRowid,"||",2),1),"^",12)
	i DrgFormRowid=-1 s DrgFormRowid=""
	Q:DrgFormRowid="" ""
	s DrgFormPoison=$p(^PHCD(+DrgFormRowid,1),"^",4)
	if DrgFormPoison=$C(0) s DrgFormPoison=""
	Q $g(DrgFormPoison)
}

ClassMethod GetInstrGroupCode(InstrRowid) As %String
{
	;n (InstrRowid)
	Q:InstrRowid="" ""
	s InstrCode=$P($g(^PHCIN(InstrRowid)),"^",1)
	s len=$length(InstrCode,".")
	Q:len=2 $P(InstrCode,".",1)
	Q ""
}

ClassMethod GetOELabSpecimen(Par) As %String
{
	Quit:$g(Par)="" ""
	Set OERid=+Par
	Set OESubrid=$P(Par,"||",2)
	Set OESpecRid=$O(^OEORD(OERid,"I",OESubrid,"SPEC",0))
	Q:OESpecRid="" "" 
	Set specimen=""
	Set specimen=$p(^OEORD(OERid,"I",OESubrid,"SPEC",OESpecRid),"^",1)
	Set Container=$p(^OEORD(OERid,"I",OESubrid,"SPEC",OESpecRid),"^",11)
	Set Convolumn=$p(^OEORD(OERid,"I",OESubrid,"SPEC",OESpecRid),"^",12)	
	Quit specimen
}

ClassMethod GetOrder(Adm) As %String
{
	Set ord=$o(^OEORD(0,"Adm",Adm,""))
	If ord="" {
		s oeord=##class(User.OEOrder).%New()
		d oeord.OEORDAdmDRSetObjectId(Adm)
		s oeord.OEORDDate=+$h
		s oeord.OEORDTime=$p($h,",",2)
		s save=oeord.%Save(0)
		s ord=+oeord.%Id()
		d oeord.%Close()
	}
	Q ord
}

ClassMethod GetPHPrescTypeByArcim(row) As %String
{
 ;n (row)
 Q:row="" ""
	S ArcimRowid=$p(^OEORD(+row,"I",$P(row,"||",2),1),"^",2)	
 s CNMedAppendItemRowid=##Class(web.DHCDocConfig).GetConfigNode("CNMedAppendItem")
 ;如果是附加材料则算成中草药
 Q:CNMedAppendItemRowid=ArcimRowid "3"
 s ItemCatRowid=$p($g(^ARCIM(+ArcimRowid,$p(ArcimRowid,"||",2),1)),"^",10)
	Q:ItemCatRowid="" ""
	s ItemType=""
	s PoisonRowid=..GetDrgFormPoison(ArcimRowid)
	s PoisonCode=""
	i PoisonRowid'="" {
		s PoisonCode=$P(^PHCPO(PoisonRowid),"^",1)
		;精神一类
		if PoisonCode="J1" s ItemType="6"
		;精神二类
		if PoisonCode="J2" s ItemType="5"
		;抗生素
		if PoisonCode="KSS" s ItemType="7"
		if ItemType'="" Q ItemType
	}	
	//草药子分类
	s CNMedItemCat=##Class(web.DHCDocConfig).GetConfigNode("CNMedItemCat")
	i "^"_CNMedItemCat_"^"[("^"_ItemCatRowid_"^") s ItemType="3"
	//西药子分类
	s MedItemCat=##Class(web.DHCDocConfig).GetConfigNode("MedItemCat")
	i "^"_MedItemCat_"^"[("^"_ItemCatRowid_"^") s ItemType="1"
	//中成药子分类
	s CPMedItemCat=##Class(web.DHCDocConfig).GetConfigNode("CPMedItemCat")
	i "^"_CPMedItemCat_"^"[("^"_ItemCatRowid_"^") s ItemType="2"
	s CPMedItemCat=##Class(web.DHCDocConfig).GetConfigNode("LimitMedItemCat")
	;精神二类药
	i "^"_CPMedItemCat_"^"[("^"_ItemCatRowid_"^") s ItemType="5"
	Q ItemType
}

ClassMethod PRNO(Date, adm, loc) As %String
{
	 ;n (Date,adm,loc,arcim,row)
	 s billver=$p($g(^CF("SM",1)),"^",12) 
	 ;for authority items , use different number
	 i ..auth($g(arcim))'="" q ..authno()
	 s admtype=$p($g(^PAADM(+adm)),"^",2)
	 ;fist try to find prescription for admission/location if oe configuration = one prescription for receiving location
	 i $p($g(^CF("OE",1)),"^",35)="RL" d  q:prno'="" prno
	 .s err=$$getpresc^MVBPAQUE(adm,loc),prno=$g(PLIST(1))
	 ;s err=$$udfprescno(loc,admtype,Date)
	 q:err'="" err
	 s:'$g(Date) Date=+$h
	 s ind=$$next("^PRESC("_Date_")"),dt1=$zd(Date),mm=+dt1,yy=$p(dt1,"/",3)
	 s num1=yy+2#10
	 s yy1=$e(yy,3,4)
	 s num2=$e("ABCDEFGHIJKL",mm)
	 s dt=$e($tr(dt1,"/"),1,4)
	 s prno=dt_$e(100000+ind,2,6)
	 s prno=admtype_yy1_dt_$e(100000+ind,2,6)
	 i billver="M" s prno=admtype_num1_num2_$p(dt1,"/",2)_$e(100000+ind,2,6)
	 q prno
getpresc(adm,loc) ;get prescriprion number 
	 ;n (adm,loc,PLIST)
	 k PLIST s found=0,prescfound=0
	 s que=0 f  s que=$o(^PAQUE1(0,"QUE1_PAADM_DR",+adm,que)) q:que=""  q:found  d
	 .s s=$g(^PAQUE1(que)),loc1=$p(s,"^",4),prescfound=1
	 .q:loc-loc1  s found=1,PLIST(1)=$p(s,"^",14)
	 s PLIST=$o(PLIST(""),-1)
	 i 'found,'prescfound q 100
	 i 'found,prescfound q 61
	 q 0
next(glo)
	 l +@glo s ind=$g(@glo)+1,@glo=ind l -@glo
	 q ind
}

ClassMethod PRNO1(Date, adm, loc)
{
	 ;n (Date,adm,loc,arcim,row)
	 s billver=$p($g(^CF("SM",1)),"^",12) 
	 ;for authority items , use different number
	 i ..auth($g(arcim))'="" q ..authno()
	 s admtype=$p($g(^PAADM(+adm)),"^",2)
	 ;fist try to find prescription for admission/location if oe configuration = one prescription for receiving location
	 i $p($g(^CF("OE",1)),"^",35)="RL" d  q:prno'="" prno
	 .;s err=$$getpresc^MVBPAQUE(adm,loc),prno=$g(PLIST(1))
	 .s err=$$getpresc(adm,loc),prno=$g(PLIST(1))
	 ;s err=$$udfprescno(loc,admtype,Date)
	 ;q:err'="" err
	 s:'$g(Date) Date=+$h
	 s ind=$$next("^PRESC("_Date_")"),dt1=$zd(Date),mm=+dt1,yy=$p(dt1,"/",3)
	 s num1=yy+2#10
	 s yy1=$e(yy,3,4)
	 s num2=$e("ABCDEFGHIJKL",mm)
	 s dt=$e($tr(dt1,"/"),1,4)
	 s prno=dt_$e(100000+ind,2,6)
	 s prno=admtype_yy1_dt_$e(100000+ind,2,6)
	 i billver="M" s prno=admtype_num1_num2_$p(dt1,"/",2)_$e(100000+ind,2,6)
	 q prno
getpresc(adm,loc) ;get prescriprion number 
	 ;n (adm,loc,PLIST)
	 k PLIST s found=0,prescfound=0
	 s que=0 f  s que=$o(^PAQUE1(0,"QUE1_PAADM_DR",+adm,que)) q:que=""  q:found  d
	 .s s=$g(^PAQUE1(que)),loc1=$p(s,"^",4),prescfound=1
	 .q:loc-loc1  s found=1,PLIST(1)=$p(s,"^",14)
	 s PLIST=$o(PLIST(""),-1)
	 i 'found,'prescfound q 100
	 i 'found,prescfound q 61
	 q 0
next(glo)
	b ;glo
	 l +@glo s ind=$g(@glo)+1,@glo=ind l -@glo
	 q ind
}

ClassMethod admloc(par) As %String
{
	 s adm=$p($g(^OEORD(+order)),"^") q:'adm ""
	 q ..ordloc(adm)
}

/// ;Find Admission type using Order RowId
ClassMethod admtype(par) As %String
{
	 q:$g(par)="" ""
	 s adm=+$g(^OEORD(+par)) q:'adm ""
	 s admtype=$p($g(^PAADM(adm)),"^",2)
	 q admtype
}

/// check if item requires separate presc per item
ClassMethod auth(arcim) As %String
{
	 ;n (arcim,row)
	 ;only australian billing
	 s billver=$p($g(^CF("SM",1)),"^",12)
	 q:billver'="A" ""
	 s drgform=$p($g(^ARCIM(+arcim,1,1)),"^",12) 
	 q:'drgform ""
	 s categ=$p($g(^PHCD(+drgform,1)),"^",4)
	 q:'categ ""
	 s desc=$p($g(^PHCPO(categ)),"^",2)
	 s desc=$ZCVT(desc,"U")
	 i desc["AUTHORITY" q ("^"_$g(row))
	 q ""
}

/// ;generate authority presc number
ClassMethod authno()
{
	s $p(a,"0",8)=""
	s cnt=$zincr(^COUNT("AUTHOR"))
	s sum=0
	f j=1:1:$l(cnt) s sum=sum+$e(cnt,j)
	s sum=sum#9
	s cnt=cnt_sum
	i $l(cnt)<8 s cnt=$e(a,1,8-$l(cnt))_cnt
	q cnt
}

ClassMethod baseuom(ArcimRowid As %String) As %String
{
	;s baseuom=$$baseuom^CHB02(ArcimRowid)
	Set inci=$o(^INCI(0,"ARCIM_DR",+ArcimRowid,""))
	Quit:inci="" ""
	Set baseuom=$p(^INCI(inci,1),"^",10)
	Q baseuom
}

/// ;get converted qty   $$billqty^MVBOEITA
ClassMethod billqty(uom, arcim, billqty) As %String
{
	 ;n (uom,arcim,billqty)
	 q:'billqty ""
	 s billuom=$p($g(^ARCIM(+arcim,1,8)),"^",14)
	 s drgform=$p($g(^ARCIM(+arcim,1,1)),"^",12)
	 s baseuom=$p($g(^PHCD(+drgform,"DF",+$p(drgform,"||",2),2)),"^",4)
	 q:'billuom ""
	 i baseuom s uom=baseuom
	 s conv=+..ConvFac(billuom,uom) 
	 q billqty*conv
}

/// ;Calculate flag    calcfl^aOET1
ClassMethod calcfl(arcim) As %String
{
	 ;n calc,itemcat
	 s itemcat=+$p($g(^ARCIM(+$g(arcim),1,1)),"^",10) 
	 s calc=$p($g(^ARC("IC",itemcat)),"^",11) 
	 q calc
}

/// ;Calculate Stock Qty for Dispensing
ClassMethod calcqty(drgform, uom, qty)
{
	 ;n (drgform,uom,qty)
	 s uom=$p($g(uom),$c(1))
	 q:'$g(drgform) qty
	 q:'$g(uom) ..partial(drgform,qty)
	 
	 &SQL(SELECT PHCDF_BaseQty INTO :baseqty
	 FROM SQLUser.PHC_DrgForm WHERE PHCDF_RowId = :drgform)
	 ;
	 q:SQLCODE ..partial(drgform,qty)
	 ;
	 &SQL(SELECT EQ_Qty	INTO :uomqty
	 FROM SQLUser.PHC_FormDoseEquiv
	 WHERE EQ_ParRef = :drgform AND EQ_CTUOM_DR = :uom)
	 ;
	 q:SQLCODE ..partial(drgform,qty)
	 q:'uomqty ..partial(drgform,qty)
	 q ..partial(drgform,qty/uomqty*baseqty)
}

ClassMethod calcqty1(drgform, uom, qty, oeitm)
{
	 ;n (PLIST,drgform,uom,qty,oeitm) 
	 k PLIST
	 s doseqty=$p($g(^OEORD(+oeitm,"I",+$p(oeitm,"||",2),2)),"^",1)
	 s arcim=$p($g(^OEORD(+oeitm,"I",+$p(oeitm,"||",2),1)),"^",2)
	 s durat=$p($g(^OEORD(+oeitm,"I",+$p(oeitm,"||",2),2)),"^",6)
	 s freq=$p($g(^OEORD(+oeitm,"I",+$p(oeitm,"||",2),2)),"^",4)
	 s billqty=$p($g(^OEORD(+oeitm,"I",+$p(oeitm,"||",2),9)),"^",4)
	 s prior=$p($g(^OEORD(+oeitm,"I",+$p(oeitm,"||",2),1)),"^",8)
	 s calcfl=..calcfl(arcim) s:'doseqty doseqty=1
	 ;b
	 s phartype=..phartype(arcim)
	 ;do not round up on dose qty level
	 s calcfl1="N"
	 ;check configuration
	 i $p($g(^CF("OE",1)),"^",48)="Y" s calcfl1="Y"
	 i calcfl="N" s calcfl1="N"
	 i calcfl1["Y",phartype'["X" s qty1=..calcqty(drgform,uom,doseqty),qty1=..CO29(qty1,freq,durat,prior)
	 i calcfl1["Y",phartype'["X"
	 e  s qty1=..calcqty(drgform,uom,qty)
	 i billqty s qty1=..billqty(uom,arcim,billqty)
	 Q qty1
	 ;s PLIST=1,PLIST(1)=qty1
	 ;q 0
}

ClassMethod dur(row As %String) As %String
{
	q:'row 1
	s s=$g(^PHCDU(+row)),factor=$p(s,"^",2)
	q:factor factor
	Q 1
}

/// ;check if prescription exists
ClassMethod exist(prno, adm)
{
	 ;n (prno,adm)
	 ;1-yes,0-no
	 q:'adm 0
	 q:prno="" 0
	 s que=0,found=0 f  s que=$o(^PAQUE1(0,"PrescNo",prno,que)) q:que=""  q:found  d
	 .q:$p($g(^PAQUE1(que)),"^",3)-adm
	 .s found=1
	 q found
}

ClassMethod freq(row As %String) As %String
{
	q:'row 0
	s s=$g(^PHCFR(+row)),factor=$p(s,"^",2),days=$p(s,"^",5)
	q:factor factor
	q:'days 0
	q 1/days
}

ClassMethod next(glo) As %String [ ProcedureBlock = 1 ]
{
	 l +@glo s ind=$g(@glo)+1,@glo=ind l -@glo
	 q ind
}

/// ;get default operation category if item is procedure
ClassMethod opercat(arcim) As %String
{
	 s arcim=$p($g(arcim),$c(1)) q:arcim="" ""
	 s row=$o(^ORC("OPER",0,"ARCIM",arcim,"")) q:row="" ""
	 q $p($g(^ORC("OPER",row)),"^",7)
}

ClassMethod ordloc(adm) As %String
{
	&SQL(Select PAADM_DepCode_DR,PAADM_CurrentWard_DR into :loc,:locw From SQLUser.PA_Adm Where PAADM_RowId=:adm)
	q $s($g(locw)'="":locw,1:$g(loc))
}

/// ;check if drug is flagged deduct partialy = "N" 
/// ;round up to integer   partial^aOET7   
ClassMethod partial(drgform, qty) As %String
{
	 ;n (drgform,qty)
	 q:'drgform qty
	 s partial=$p($g(^PHCD(+drgform,"DF",+$p(drgform,"||",2),2)),"^",6)
	 q:partial="Y" qty
	 s qty1=qty\1+$s(qty#1:1,1:0)
	 q qty1
}

/// ;get patient share to pay     
ClassMethod patshare(oeitm)
{
	 ;patshare^MVBOEITM
	 ;n (oeitm)
	 s amt=0
	 s ind=0 f  s ind=$o(^OEORD(+oeitm,"I",+$p(oeitm,"||",2),"BILL",ind)) q:ind=""  s s=^(ind) d
	 .s bill=$p(s,"^"),amt1=$p(s,"^",2),patins=$p(s,"^",3)
	 .i patins["P" s amt=amt+amt1
	 .i patins["I" s amt=amt+$p($g(^ARPBL(+bill,"BGRP",+$p(bill,"||",2),"ITM",+$p(bill,"||",3))),"^",8)
	 q amt
}

/// ;check order entry configuration: ;create index upon ordering or payment
ClassMethod pay() As %String
{
	;$$pay^at122d()
	q $p($g(^CF("OE",1)),"^",17)
}

/// ;Pharmacy Type   phartype^aOET1
ClassMethod phartype(arcim) As %String
{
	 ;n calc,itemcat
	 s itemcat=+$p($g(^ARCIM(+$g(arcim),1,1)),"^",10) 
	 s calc=$p($g(^ARC("IC",itemcat)),"^",7) 
	 q calc
	 ;
}

ClassMethod prior(row) As %String
{
	 s prior=$p($g(^OEORD(+row,"I",+$p(row,"||",2),1)),"^",8)
	 q $p($g(^OECPR(+prior)),"^")
}

ClassMethod stock(arcim) As %String
{
	;check if item is linked to stock
	;0-no,1-yes
	i $p($g(^ARCIM(+arcim,1,1)),"^",12) q 1
	i $d(^INCI(0,"ARCIM_DR",+arcim)) q 1
	q 0
}

/// /;update order
ClassMethod updorder(oeitm, stat, user) As %String
{
	 ;n (oeitm,stat,user)
	 s user=$g(user)
	 s oestat=$o(^OEC("OSTAT",0,"Code","E",""))
	 ;
	 &SQL(Update SQLUser.OE_OrdItem SET OEORI_PharmacyStatus=:stat,OEORI_UserUpdate = :user where oEORI_RowId=:oeitm)
	 q:SQLCODE SQLCODE
	 q:stat'="A" SQLCODE
	 s presc=$p($g(^OEORD(+oeitm,"I",+$p(oeitm,"||",2),1)),"^",14)
	 q:presc="" 0
	 s queue=$o(^PAQUE1(0,"PrescNo",presc,""),-1)
	 q:'queue 0
	 s $p(^PAQUE1(queue),"^",22)=user
	 q SQLCODE
}

/// ;update queue status to Accepted
ClassMethod updque(row, stat)
{
	 ;n (row,stat) 
	 ;;updque^aOET11
	 s stat=$tr($g(stat),"P","A")
	 &SQL(Update SQLUser.PA_QUE1 set QUE1_PharmStatus=:stat where QUE1_RowId=:row)
	 s presc=$p($g(^PAQUE1(+row)),"^",14) q:presc=""
	 s ord=$o(^OEORD(0,"PrescNo",presc,""),-1)
	 s itm=0 f  s itm=$o(^OEORD(0,"PrescNo",presc,ord,itm)) q:itm=""  d
	 .s err=..updorder(ord_"||"_itm,"A","")
	 q
}

/// / ;check prescription status, update queue
ClassMethod updqueue(presc, nofile)
{
	 s retconf=$p($g(^CF("OE",1)),"^",69)
	 q:presc="" 0
	 s que=$o(^PAQUE1(0,"PrescNo",presc,""),-1)
	 s (oldstat,questat)=$p($g(^PAQUE1(+que)),"^",13)
	 s adm=$p($g(^PAQUE1(+que)),"^",3)
	 s packed=0,collected=0,partial=0,notcollected=0
	 s blankstat=0
	 ;;s ord=$o(^OEORD(0,"PrescNo",presc,""),-1) q:'ord 0
	 s ord=$o(^OEORD(0,"Adm",+adm,"")) q:'ord 0
	 s adms=$g(^PAADM(+adm))
	 s admtype=$p(adms,"^",2)
	 s visst=$p(adms,"^",20)
	 s disdate=$p(adms,"^",17)
	 s distime=$p(adms,"^",18)
	 s itm="" f  s itm=$o(^OEORD(0,"PrescNo",presc,ord,itm)) q:itm=""  d
	 .s s=$g(^OEORD(ord,"I",itm,1)),arcim=$p(s,"^",2),qty=$p(s,"^",12),oestat=$p(s,"^",13)
	 .i oestat s oestat=$p($g(^OEC("OSTAT",oestat)),"^")
	 .s seq=$p($g(^OEORD(ord,"I",itm,3)),"^",4)
	 .s uom=$p($g(^OEORD(ord,"I",itm,2)),"^",3)
	 .s billed=$p($g(^OEORD(ord,"I",itm,3)),"^",5)
	 .i " P TR R "[(" "_billed_" ") s paid=1
	 .e  s paid=0
	 .i 'paid,'..patshare(ord_"||"_itm) s paid=1
	 .s defstat=$s(paid:"P","IE"[admtype:"P",##Class(web.DHCaOET).pay()["P":"T",1:"P")
	 .q:seq=""  s stat=$p(s,"^",13),statcode=$p($g(^OEC("OSTAT",+stat)),"^",1)  
	 .i " D "[(" "_statcode_" ") s newquest("J")="" q
	 .;check pharmacy status of individual item
	 .s pharmst=$p($g(^OEORD(ord,"I",itm,8)),"^",11)
	 .i pharmst'="",pharmst'="A" s newquest(pharmst)=""
	 .i pharmst="A" s newquest(pharmst,itm)=""
	 .i pharmst="" s newquest(defstat,itm)=""
	 .s drgform=$p($g(^ARCIM(+arcim,1,1)),"^",12)
	 .;convert into stock qty
	 .s qty=##Class(web.DHCaOET).calcqty1(drgform,uom,qty,ord_"||"_itm)
	 .;check dispensed qty
	 .s qtydisp=0
	 .i pharmst'="",pharmst'="R" s notpacked(itm)=1
	 .s ex=0 f  s ex=$o(^OEORD(ord,"I",itm,"X",ex)) q:ex=""  s s3=^(ex) d
	 ..s exdate=+s3,extime=$p(s3,"^",2)
	 ..i retconf="Y",visst="D",disdate,exdate>disdate s newquest("Z")=""
	 ..i retconf="Y",visst="D",disdate,exdate=disdate,extime>distime s newquest("Z")=""
	 ..s dis=0 f  s dis=$o(^OEORD(ord,"I",itm,"X",ex,"D",dis)) q:dis=""  s s2=^(dis) d
	 ...s qtydisp=qtydisp+s2-$p(s2,"^",7),stat1=$p(s2,"^",6)
	 ...q:qtydisp'>0
	 ...s packed=1 k notpacked(itm) k newquest("P",itm),newquest("A",itm)
	 ...i stat1="" s blankstat=1,newquest("M")=""
	 ...i stat1="C" s collected=1,newquest("C")=""
	 ...i stat1="P" s notcollected=1,newquest("M")=""
	 .i qty>qtydisp,qtydisp s partial=1,newquest("A")=""
	 i $d(notpacked) s newquest("A")=""
	 s newstat=questat
	 ;b
	 ;check new queue status
	 d
	 .i '$d(newquest) s newstat=questat q
	 .s newstat="",ind="" f  s ind=$o(newquest(ind)) q:ind=""  s newstat=newstat_ind
	 .q
	 .i 'packed s newstat="A" q
	 .;for existing prescriptions
	 .i packed,blankstat,questat'="C" s newstat="M" q
	 .i packed,blankstat,questat="C" s newstat="C" q
	 .i packed,partial d  q
	 ..i collected,notcollected s newstat="AMC" q
	 ..i 'collected,notcollected s newstat="AM" q
	 ..i collected,'notcollected s newstat="AC" q
	 .i packed,'partial d  q
	 ..i collected,notcollected s newstat="MC" q
	 ..i 'collected,notcollected s newstat="M" q
	 ..i collected,'notcollected s newstat="C" q
	 i $d(notpacked),newstat'["A" d
	 .i newstat="M" s newstat="AM" q
	 .i newstat="MC" s newstat="AMC" q
	 .i newstat="C" s newstat="AC" q
	 ;b
	 q:$g(nofile) 0
	 i oldstat=newstat q 0
	 &SQL(Update SQLUser.PA_QUE1 set QUE1_PharmStatus=:newstat where QUE1_RowId=:que)
	 ;i SQLCODE b
	 q SQLCODE
}

}
