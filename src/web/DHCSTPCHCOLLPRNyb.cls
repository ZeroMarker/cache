Import SQLUser

Class web.DHCSTPCHCOLLPRNyb Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

ClassMethod GetPhaColl(itmjs As %Library.String = "", itmjsex As %Library.String = "", main As %String) As %String
{
  k PLIST
  n (main)
  &sql(select * into :PLIST() from DHC_PhaCollected  where DHC_PhaCollect_Rowid=:main)	
  s phaloc=+PLIST(2)
  s frdate=PLIST(11)
  s todate=PLIST(12)
  s oper=+PLIST(6)
  s wardloc=+PLIST(5)
  s type=PLIST(13)
  s prtdate=PLIST(8)
  s prttime=PLIST(9)
  i prtdate'="" s prtdate=$zd(prtdate,3)
  i prttime'="" s prttime=$zt(prttime)
  s type=PLIST(13)
  i phaloc>0 s phaloc=$p(^CTLOC(phaloc),"^",2)  ; desc of location
  i oper>0 s oper=$p(^SSU("SSUSR",oper),"^",2)  ;
  i wardloc>0 s wardloc=$p( ^PAWARD(wardloc),"^",2) ;desc of ward
  s frdate=$zd(frdate,3)
  s todate=$zd(todate,3)
  ;取出第一条发药记录的医嘱优先级 - 2006-09-27
  s ch=$o(^DHCPHAC(main,"I",0))
  i ch="" s orditmpriority=""
  e  d
  .s oedis=$p(^DHCPHAC(main,"I",ch),"^",7)
  .s orditmpriority=$p(^OEORD($p(oedis,"||",1),"I",$p(oedis,"||",2),1),"^",8)
  s priority=""
  i orditmpriority'="" d
  . s priority=$p(^OECPR(orditmpriority),"^",1) ;priority code
  i priority="S" s priority="LONG"   ;长期医嘱
  e  d
  .s priority="SHORT"    ;临时医嘱
  s ctname=""
  i wardloc="" d
  .s ctlocnum=$p(^OEORD($p(oedis,"||",1),"I",$p(oedis,"||",2),7),"^",2)
  .i ctlocnum'="" s ctname=$p(^CTLOC(ctlocnum),"^",2)
  i ctname'=""  s ctname=$p(ctname,"-",2)
  q phaloc_"^"_wardloc_"^"_frdate_"^"_todate_"^"_type_"^"_oper_"^"_prtdate_"^"_type_"^"_prttime_"^"_$g(priority)_"^"_$g(ctname)
}

ClassMethod GetPhaCollDetail(main As %String) As %String
{
  n (main)
  k ^TMP($j,"PRNDISPD")
  k ^TMP($j,"PRNDISPDTOTAL")
  s i=0
  s ch=0
  s phactype=$p(^DHCPHAC(main),"^",12) 
  f  s ch=$o(^DHCPHAC(main,"I",ch))  q:ch=""  d
   .s data=^(ch)
   .s (adm,admloc,oedis,inclb,incibatno,prescno,qty,sp,amt,bed)=""
   .s (pano,pasex,paname,padob,warddesc,orditemdesc,ordstatus,freq,dosqty)=""
   .s (instruction,duration)=""
   .s oestatus=$p(data,"^",10)
   .q:oestatus="D"   ; stopped oedis can't be printed
   .s adm=$p(data,"^",3)
   .s admloc=$p(data,"^",11)
   .i +admloc>0 s admloc=$p(^CTLOC(+admloc),"^",2)
   .i $f(admloc,"-") s admloc=$p(admloc,"-",2)
   .s oedis=$p(data,"^",7)
   .s inclb=$p(data,"^",4)
   .s incicode=$p(^INCI(+inclb,1),"^",1)
   .s incidesc=$p(^INCI(+inclb,1),"^",2)
   .s incibatno=..getBatNo(inclb)
   .s uom=..getUom(inclb)
   .s prescno=$p(data,"^",5)
   .s qty=$p(data,"^",6)
   .
   .s sp=$p(data,"^",9)
   .s amt=$fn(qty*sp,"",2)
  . s bed=$p(data,"^",8)  ; bedcode
   .s bedcode=bed
   .;i bed'="" s bedcode=..getBedCode(+bed)
   .s warddesc=..getWardDesc(adm)
   .s tmp=..getPaNo(adm)
   .s pano=$p(tmp,"^",1)
   .s paname=$p(tmp,"^",2)
   .s pasex=$p(tmp,"^",3)
   .s padob=$p(tmp,"^",4)
   .s tmp=..getOrdItm(oedis)
   .s orditemdesc=$p(tmp,"^",1)
   .;s ordstatus=$P(tmp,"^",2)   ; status at present time
   .s ordstatus=oestatus		; status when dispensing
   .s freq=$P(tmp,"^",3)
   .s dosqty=$P(tmp,"^",4)
   .s doctor=$P(tmp,"^",5)
   .s instruction=$P(tmp,"^",6)
   .s duration=$P(tmp,"^",7)
   .
   .s tmpd=..GetOeoriAndSeqNo(oedis)  ;20051107
   .s relateoeori=$p(tmpd,"^",1) ;20051107
   .s seqno=$p(tmpd,"^",2) ;20051107
   .
   .s remark=##class(web.DHCSTPCHCOLLS2).GetOrdItmRemark($p(oedis,"||",1,2))
   .s manf=..GetMnfByInclb(inclb)
   .s exetime=..GetExeTime(oedis)
   .s ^TMP("XXXX")=exetime
   .s i=i+1 
   .s s1=pano_"^"_paname_"^"_pasex_"^"_padob_"^"_warddesc
   .s s2=bedcode_"^"_admloc_"^"_prescno_"^"_doctor_"^"_incicode
   .s s3=incidesc_"^"_orditemdesc_"^"_ordstatus_"^"_dosqty_"^"_freq
   .s s4=qty_"^"_uom_"^"_sp_"^"_amt_"^"_incibatno
   .s s5=instruction_"^"_duration_"^"_relateoeori_"^"_seqno_"^"_remark  ;20051107
   .s s6=+inclb_"^"_$g(manf)_"^"_$g(exetime)
   .;s ^TMP($j,"PRNDISPD",i)=s1_"^"_s2_"^"_s3_"^"_s4_"^"_s5   ;20051107
   .s ^TMP($j,"PRNDISPD","REGNO","BED"_bedcode,pano,i)=s1_"^"_s2_"^"_s3_"^"_s4_"^"_s5_"^"_s6		;20051107
   .;s ^TMP("XXXX",1)=bedcode
   .;s ^TMP("XXXX",2)=pano
   .;s ^TMP("XXXX",3)=relateoeori
   .;s ^TMP("XXXX",4)=seqno
   .;s ^TMP("XXXX",5)=oedis
   .
   .i phactype="ZCY" s ^TMP($j,"PRNDISPD","ZCY","BED"_bedcode,pano,relateoeori,seqno,i)=s1_"^"_s2_"^"_s3_"^"_s4_"^"_s5  ;20051107
   .
   .i $d(^TMP($j,"PRNDISPDTOTAL",incicode)) d
   .. s $p(^TMP($j,"PRNDISPDTOTAL",incicode),"^",5)=$p(^TMP($j,"PRNDISPDTOTAL",incicode),"^",5)+qty
   .. s $p(^TMP($j,"PRNDISPDTOTAL",incicode),"^",6)=$p(^TMP($j,"PRNDISPDTOTAL",incicode),"^",6)+amt
   .. 
   .e  d
   .. s ^TMP($j,"PRNDISPDTOTAL",incicode)=incicode_"^"_incidesc_"^"_sp_"^"_uom_"^"_qty_"^"_amt_"^"_+inclb   ; 20051207 add "+inclb"
 q i_"^"_$j
}

ClassMethod getPaNo(adm As %String) As %String
{
	n (adm)
	s papmi=$p(^PAADM(adm),"^",1)
	s papmi=+papmi
	i papmi>0 d
	  . &sql( select papmi_no,papmi_name,papmi_sex_dr->CTSEX_Desc,papmi_dob into :pano,:name,:sex,:dob from  pa_patmas where papmi_rowid=:papmi     )
	  . i $g(dob)>0 s dob=$zd(dob,3)
	q $g(pano)_"^"_$g(name)_"^"_$g(sex)_"^"_$g(dob)
}

ClassMethod getBedCode(bed As %String) As %String
{
	 n (bed)
	&sql(select bed_code into :bedcode from  pac_bed   where bed_rowid=:bed )
	q $g(bedcode)
}

ClassMethod getWardDesc(adm As %String) As %String
{
	n (adm)
	;s ward=$p(bed,"||",2)
	;q:ward="" ""
	q:adm="" ""
	q:'$d(^PAADM(+adm)) ""
	s ward=$p(^PAADM(adm),"^",70)
	q:ward="" ""
	q:'$d(^PAWARD(+ward)) ""
	s warddesc=$p(^PAWARD(+ward),"^",2)
	q warddesc
}

ClassMethod getOrdItm(oedis As %String) As %String
{
	n (oedis)
    q:oedis="" ""
	s ord=$p(oedis,"||",1),itm=$p(oedis,"||",2) q:ord="" "" q:itm="" ""
	s arcim=$p(^OEORD(ord,"I",itm,1),"^",2) q:arcim="" ""
	s sub=$p(arcim,"||",1),ver=$p(arcim,"||",2) q:sub="" "" q:ver="" ""
	s arcimdesc=$p(^ARCIM(sub,ver,1),"^",2)
	s doseqty=$p(^OEORD(ord,"I",itm,2),"^",1)
	s doseqty=..getPackUomDoseQty(ord,itm)
	s ordstatus=$p(^OEC("OSTAT",$p(^OEORD(ord,"I",itm,1),"^",13)),"^",2) 
	s freq=$p(^OEORD(ord,"I",itm,2),"^",4)
	i +freq>0 s freq=$p(^PHCFR(+freq),"^",1)
	s doctor=$p(^OEORD(ord,"I",itm,1),"^",11)
	i +doctor>0 s doctor=$p(^CTPCP(+doctor,1),"^",2)
	s instruction=$p(^OEORD(ord,"I",itm,2),"^",7)
	i instruction'="" s instruction=$p(^PHCIN(+instruction),"^",2)
	s duration=$p(^OEORD(ord,"I",itm,2),"^",6)
	i duration'="" s duration=$p(^PHCDU(+duration),"^",3)
	q $g(arcimdesc)_"^"_$g(ordstatus)_"^"_$g(freq)_"^"_$g(doseqty)_"^"_$g(doctor)_"^"_$g(instruction)_"^"_$g(duration)
}

ClassMethod getPackUomDoseQty(ord, itm)
{
	
	n (ord,itm)
	s doseqty=$p(^OEORD(ord,"I",itm,2),"^",1)
	;get dose-equiv
	q:doseqty="" ""
	s arcim=$p(^OEORD(ord,"I",itm,1),"^",2) q:arcim="" ""
	s sub=$p(arcim,"||",1),ver=$p(arcim,"||",2)
	s phcdf=$p(^ARCIM(sub,ver,1),"^",12)
	s doseunit=$p(^OEORD(ord,"I",itm,2),"^",3)
	i doseunit'="" s doseunit=$p(^CT("UOM",doseunit),"^",2)
	q:phcdf="" ""
	&sql(select PHCDF_CTUOM_DR->ctuom_desc into :buom
		from phc_drgform where phcdf_rowid=:phcdf)
	i $g(buom)=doseunit q doseqty_doseunit
	;
	&sql(Select eq_qty into :doseequiv From PHC_FormDoseEquiv
	     Where EQ_ParRef=:phcdf)
	q:SQLCODE doseqty_doseunit
	q:+doseequiv=0 ""
	s packuomdoseqty=doseqty/doseequiv
	q packuomdoseqty_buom
}

ClassMethod getBatNo(inclb As %String) As %String
{
	n (inclb)
	q:inclb="" ""
	&sql(select inclb_incib_dr->incib_no into :batno from inc_itmlcbt where inclb_rowid=:inclb)
	q $g(batno)
}

ClassMethod getUom(inclb As %String) As %String
{
	n (inclb)
	s inci=+inclb q:inci'>0 ""
	s uom=$p(^INCI(inci,1),"^",10)
	i +uom>0 s uom=$p(^CT("UOM",+uom),"^",2)
	q uom
}

ClassMethod ListDetail(n As %Integer) As %String
{
	i $d(^TMP($j,"PRNDISPD",n)) q ^TMP($j,"PRNDISPD",n)
	q ""
}

ClassMethod ListPatient(pano As %String) As %String
{
	s pano=$o(^TMP($j,"PRNDISPD","REGNO",pano))
	q pano
}

ClassMethod ListPatientDetail(pano As %String, n As %Integer) As %String
{
	s xx=$o(^TMP($j,"PRNDISPD","REGNO",pano,n))
	q:xx="" ""	
	i $d(^TMP($j,"PRNDISPD","REGNO",pano,xx)) q ^TMP($j,"PRNDISPD","REGNO",pano,xx)_"@"_xx
	q ""
}

ClassMethod ListDetaiTotal(incicode As %String) As %String
{
	n (incicode)
	s tmp=$o(^TMP($j,"PRNDISPDTOTAL",incicode))
	q:tmp="" ""
	;q ^(tmp)
	q ^TMP($j,"PRNDISPDTOTAL",tmp)
}

ClassMethod CLEARTMP(pid As %String, tmpname As %String) As %String
{
	k ^TMP(pid,tmpname) 
	q ""
}

ClassMethod DispPrnClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = DispPrnExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod DispPrnExecute(ByRef qHandle As %Binary, Phac As %String, PrtHz As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
	;s Phac=3
	q:Phac="" $$$OK
	s ss=..GetPhaCollDetail(Phac)
	s cnt=$p(ss,"^",1)
	s pid=$p(ss,"^",2)  
	q:cnt="" $$$OK
	;
	s phactype=$p(^DHCPHAC(Phac),"^",12)  ;20051107
	
	if PrtHz=1 d
	. s incicode=""
	. f   s tmpdata=..ListDetaiTotal(incicode)   q:tmpdata=""  d
	. . d ResetVariables
	. . s incicode=$p(tmpdata,"^",1)
	. . d OutputRowDetailTotal
	. . 
	e  d 
	. i phactype="ZCY"  d 	; 20051107
	. . d ResetVariables
	. . s bedbed=""
	. . f  s bedbed=$o(^TMP($j,"PRNDISPD","ZCY",bedbed))  q:bedbed=""  d
	. . . s panopano=""
	. . . f  s panopano=$o(^TMP($j,"PRNDISPD","ZCY",bedbed,panopano)) q:panopano=""  d
	. . . . s OEORIX=""
	. . . . f  s OEORIX=$o(^TMP($j,"PRNDISPD","ZCY",bedbed,panopano,OEORIX)) q:OEORIX=""  d
	. . . . . s seqnox=""
	. . . . . f  s seqnox=$o(^TMP($j,"PRNDISPD","ZCY",bedbed,panopano,OEORIX,seqnox)) q:seqnox=""  d
	. . . . . . s j=""
	. . . . . . f  s j=$o(^TMP($j,"PRNDISPD","ZCY",bedbed,panopano,OEORIX,seqnox,j)) q:j=""  d
	. . . . . . . s tmpdata=^(j)
	. . . . . . . d OutputRowDetail
	. e  d
	. . d ResetVariables
	. . s bedbed=""
	. . f  s bedbed=$o(^TMP($j,"PRNDISPD","REGNO",bedbed))  q:bedbed=""  d
	. . . s panopano=""
	. . . f  s panopano=$o(^TMP($j,"PRNDISPD","REGNO",bedbed,panopano)) q:panopano=""  d
	. . . . s j=""
	. . . . f  s j=$o(^TMP($j,"PRNDISPD","REGNO",bedbed,panopano,j)) q:j=""  d
	. . . . . s tmpdata=^(j)
	. . . . . d OutputRowDetail
	. . 
	. . 
	. . ;f  s pano=..ListPatient(pano) q:pano=""  d
	. . ;. s j=""
	. . ;. f  s tmp=..ListPatientDetail(pano,j) q:tmp=""  d
	. . ;. . s tmpdata=$p(tmp,"@",1)
	. . ;. . s j=$p(tmp,"@",2)
	. . ;. . d OutputRowDetail
	. . 
	. 

	;. 
	;. f i=1:1:cnt d
	;. . d ResetVariables
	;. . s tmpdata=..ListDetail(i)
	;. . d OutputRowDetail
	
	d ..CLEARTMP(pid,"PRNDISPD")
	d ..CLEARTMP(pid,"PRNDISPDTOTAL")
	Quit $$$OK
		
OutputRowDetail
	s pano=$p(tmpdata,"^",1)
	s paname=$p(tmpdata,"^",2)
	s pasex=$p(tmpdata,"^",3)
	s padob=$p(tmpdata,"^",4)
	s warddesc=$p(tmpdata,"^",5)
	s bedcode=$p(tmpdata,"^",6)
	s admloc=$p(tmpdata,"^",7)
	s prescno=$p(tmpdata,"^",8)
	s doctor=$p(tmpdata,"^",9)
	s incicode=$p(tmpdata,"^",10)
	s incidesc=$p(tmpdata,"^",11)
	s orditemdesc=$p(tmpdata,"^",12)
	s ordstatus=$p(tmpdata,"^",13)
	s dosqty=$p(tmpdata,"^",14)
	s freq=$p(tmpdata,"^",15)
	s qty=$p(tmpdata,"^",16)
	s uom=$p(tmpdata,"^",17)
	s sp=$p(tmpdata,"^",18)
	s amt=$p(tmpdata,"^",19)
	s incibatno=$p(tmpdata,"^",20)
	s instruction=$p(tmpdata,"^",21)
	s duration=$p(tmpdata,"^",22)
	s OEORI=$p(tmpdata,"^",23)
	s SeqNo=$p(tmpdata,"^",24)
	s remark=$p(tmpdata,"^",25)
	;
	s inci=$p(tmpdata,"^",26)  ; 20051207
	s manf=$p(tmpdata,"^",27)
	s exetime=$p(tmpdata,"^",28)
	s ^TMP("XXXXXXXJJ")=exetime
	;s uom=..getIntPackQty(inci,qty,phactype) ;20051207 - including uom desc
	;
	s Data=$lb(pano,paname,pasex,padob,warddesc,bedcode,admloc,prescno,doctor,incicode,incidesc,orditemdesc,ordstatus,dosqty,freq,qty,uom,sp,amt,incibatno,instruction,duration,OEORI,SeqNo,remark,manf,exetime)
	s ^CacheTemp(repid,ind)=Data	
	s ind=ind+1
	q
OutputRowDetailTotal
	;s pano=$p(tmpdata,"^",1)
	;s paname=$p(tmpdata,"^",2)
	;s pasex=$p(tmpdata,"^",3)
	;s padob=$p(tmpdata,"^",4)
	;s warddesc=$p(tmpdata,"^",5)
	;s bedcode=$p(tmpdata,"^",6)
	;s admloc=$p(tmpdata,"^",7)
	;s prescno=$p(tmpdata,"^",8)
	;s doctor=$p(tmpdata,"^",9)
	;
	;  incicode_"^"_incidesc_"^"_sp_"^"_uom_"^"_qty_"^"_amt
	s incicode=$p(tmpdata,"^",1)
	s incidesc=$p(tmpdata,"^",2)
	;s orditemdesc=$p(tmpdata,"^",12)
	;s ordstatus=$p(tmpdata,"^",13)
	;s dosqty=$p(tmpdata,"^",14)
	;s freq=$p(tmpdata,"^",15)
	s qty=$p(tmpdata,"^",5)
	s uom=$p(tmpdata,"^",4)
	s sp=$p(tmpdata,"^",3)
	s amt=$p(tmpdata,"^",6)
	;s incibatno=$p(tmpdata,"^",20)
	;s instruction=$p(tmpdata,"^",21)
	;s duration=$p(tmpdata,"^",22)
	;
	s inci=$p(tmpdata,"^",7)  ;20051207
	;s uom=..getIntPackQty(inci,qty,phactype) ;20051207 - using prior "uom" field
	s manf=##class(web.DHCSTKUTIL).GetManfNameByInci(inci)
	s Data=$lb(pano,paname,pasex,padob,warddesc,bedcode,admloc,prescno,doctor,incicode,incidesc,orditemdesc,ordstatus,dosqty,freq,qty,uom,sp,amt,incibatno,instruction,duration,OEORI,SeqNo,remark,manf,exetime)
	s ^CacheTemp(repid,ind)=Data	
	s ind=ind+1
	q

ResetVariables
	s (pano,paname,pasex,padob,warddesc,bedcode,admloc,prescno,doctor,incicode,incidesc,orditemdesc,ordstatus,dosqty,freq,qty,uom,sp,amt,incibatno,instruction,duration,OEORI,SeqNo,remark,manf,exetime)=""
	q
}

ClassMethod DispPrnFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = DispPrnExecute ]
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

Query DispPrn(Phac As %String, PrtHz As %String) As %Query(ROWSPEC = "pano:%String,paname:%String,pasex:%String,padob:%String,warddesc:%String,bedcode:%String,admloc:%String,prescno:%String,doctor:%String,incicode:%String,incidesc:%String,orditemdesc:%String,ordstatus:%String,dosqty:%String,freq:%String,qty:%String,uom:%String,sp:%String,amt:%String,incibatno:%String,instruction:%String,duration:%String,OEORI:%String,SeqNo:%String,remark:%String,manf:%String,exetime:%String")
{
}

ClassMethod GetOeoriAndSeqNo(oedis As %String) As %String
{
 n (oedis)
 q:oedis="" "^"
 s ord=$p(oedis,"||",1)
 s itm=$p(oedis,"||",2)
 s exe=$p(oedis,"||",3)
 s dsp=$p(oedis,"||",4)
 q:ord="" "^"
 q:itm="" "^"
 q:exe="" "^"
 q:dsp="" "^"
 q:'$d(^OEORD(ord,"I",itm,"X",exe,"D",dsp)) "^"
 ;
 s OEORIDR=$P(^OEORD(ord,"I",itm,11),"^",39)
 i OEORIDR="" s OEORIDR=ord_"||"_itm
 s seqno=$p(^OEORD(ord,"I",itm,3),"^",4)
 q OEORIDR_"^"_seqno
}

ClassMethod GetBingAnNo(itmjs As %Library.String = "", itmjsex As %Library.String = "", regno As %String) As %String
{
	n (itmjs,itmjsex,regno)
	q:regno="" ""
	&sql(select PAPMI_SafetyNetCardNo into :aa from pa_patmas where papmi_no=:regno)
	q:SQLCODE ""
	q $g(aa)
}

ClassMethod GetDurationFactor(itmjs As %Library.String = "", itmjsex As %Library.String = "", duration)
{
	n (itmjs,itmjsex,duration)
	q:duration="" ""
	&sql(select phcdu_factor into :aa From PHC_Duration where phcdu_desc1=:duration)
	q:SQLCODE ""
	q $g(aa)
}

ClassMethod getIntPackQty(inci, qty, phactype) As %String
{
	n (inci,qty,phactype)
	;s inci=##class(web.DHCSTCOMMONSRV).ItemCodeToID(incicode)
	s result=""
	s buom=+$p(^INCI(inci,1),"^",10)  ; basic uom
	s puom=+$p(^INCI(inci,3),"^",6)  ; 
	i puom="" s puom=buom
	s buomdesc=$p(^CT("UOM",buom),"^",2)
	s puomdesc=$p(^CT("UOM",puom),"^",2)
	i phactype'="ZCHY" q qty_" "_buomdesc
	;
	s fac=##class(web.DHCSTCOMMONSRV).UOMFac(puom,buom)
	s packqty=qty\fac
	s restqty=qty-(packqty*fac)
	i packqty>0 d
	. s result=packqty_" "_puomdesc
	i restqty>0 d
	. i result'="" d
	. . s result=result_" "_restqty_" "_buomdesc
	. e  d
	. . s result=restqty_" "_buomdesc
	q result
}

ClassMethod GetMnfByInclb(inclb As %String) As %String
{
  n (inclb)
  s ingri=..GetLastBatByInclb(inclb)
  q:ingri="" ""
  s DHCINGR=$o(^DHCINGR(0,"INGDRECITM",ingri,"")) q:DHCINGR="" ""
  s CH=$o(^DHCINGR(0,"INGDRECITM",ingri,DHCINGR,"")) q:CH="" ""
  s manf=$P(^DHCINGR(DHCINGR,"GRI",CH),"^",29) q:manf="" ""
  q:'$d(^PHMNF(+manf)) ""
  s manfdesc=$p(^PHMNF(+manf),"^",2)
  i manfdesc'="" d
  .i manfdesc["-" s manfdesc=$p(manfdesc,"-",2)
  .s manfdesc=$e(manfdesc,1,4)
  q $g(manfdesc)
}

ClassMethod GetLastBatByInclb(inclb)
{
                     ;
   q:inclb="" ""
   &sql(select inclb_incib_dr into :incib from inc_itmlcbt where inclb_rowid=:inclb)
   s incib=$g(incib)
   q:incib="" ""
   s INGR=$o(^INGRI("GRI_INCIB",incib,""),-1)
   i INGR d
    .s INGRCH=$o(^INGRI("GRI_INCIB",incib,INGR,""))
    .s INGRI=INGR_"||"_INGRCH
   q $g(INGRI)
}

ClassMethod getDrugOutList(adm, locdr)
{
	;n (admno,locdr)
	k ^TMP($j,"OUTDRUG")
	s i=0
	q:adm="" 0
	;s visitstatus=$p(^PAADM(adm),"^",20)
	;q:visitstatus="D" 0
	s ord=$o(^OEORD(0,"Adm",adm,"")) q:ord="" 0
	s pano="",paname="",pasex="",padob="",admloc=""
	s disploc=$p(^CTLOC(locdr),"^",2)     ; dispensing location
	&sql(select paadm_papmi_dr->papmi_no,paadm_papmi_dr->papmi_name,
		paadm_papmi_dr->papmi_sex_dr->CTSEX_Desc,
		paadm_papmi_dr->papmi_dob,
		PAADM_DepCode_DR->ctloc_desc
	 into :pano,:paname,:pasex,:padob,:admloc from pa_adm where paadm_rowid=:adm)
	
	s itm=0 
	f  s itm=$o(^OEORD(ord,"I",itm)) q:itm=""  d
	. q:$p(^OEORD(ord,"I",itm,1),"^",8)=""
	. s priority=$p(^OECPR($p(^OEORD(ord,"I",itm,1),"^",8)),"^",1)  
    . q:priority'="OUT"       ; if not "out" type then quit 
	. s recdepdr=$p(^OEORD(ord,"I",itm,3),"^",6) 
	. q:recdepdr'=locdr   ; not the receieve loc
	. s orderstatus=$p(^OEORD(ord,"I",itm,1),"^",13)
	. i orderstatus'="" s orderstatus=$p(^OEC("OSTAT",orderstatus),"^",1)
	. q:orderstatus="D"         ; stoped order item
	. s prescno=$p(^OEORD(ord,"I",itm,1),"^",14)
	. s doseqty=$p(^OEORD(ord,"I",itm,2),"^",1)
	. ;s unit=$p(^OEORD(ord,"I",itm,2),"^",3)
	. ;s unit=$p(^CT("UOM",unit),"^",2)
	. s freq=$p(^OEORD(ord,"I",itm,2),"^",4)
	. i freq'="" s freq=$p(^PHCFR(freq),"^",1)
	. s arcim=$p(^OEORD(ord,"I",itm,1),"^",2)
	. s code=$p(^ARCIM($p(arcim,"||",1),$p(arcim,"||",2),1),"^",1)
	. s desc=$p(^ARCIM($p(arcim,"||",1),$p(arcim,"||",2),1),"^",2)
	. s instruction=$p(^OEORD(ord,"I",itm,2),"^",7)
	. i instruction'="" s instruction=$p(^PHCIN(instruction),"^",2)
	. s doctor=$p(^OEORD(ord,"I",itm,1),"^",11)
	. i doctor'="" s doctor=$p(^CTPCP(doctor),"^",2)
	. ;s orddate=$p(^OEORD(ord,"I",itm,3),"^",7)
	. ;s time=$p(^OEORD(ord,"I",itm,1),"^",17)
	. ;s sttdate=$p(^OEORD(ord,"I",itm,1),"^",9)
	. s duration=$p(^OEORD(ord,"I",itm,1),"^",7)
	. i duration'="" s duration=$p(^PHCDU(duration),"^",3)
	. s orditemremark=##class(web.DHCSTPCHCOLLS2).GetOrdItmRemark(ord_"||"_itm)
	. ;s orditemrowid=ord_"||"_itm
	. s exe=0  f  s exe=$o(^OEORD(ord,"I",itm,"X",exe)) q:exe=""  d
	. . s dsp=0  f  s dsp=$o(^OEORD(ord,"I",itm,"X",exe,"D",dsp)) q:dsp=""  d
	. . . s status=$p(^(dsp),"^",6)
	. . . q:status'="C"
	. . . s qty=+$p(^(dsp),"^",1),retqty=+$p(^(dsp),"^",7)
	. . . s qty=qty-retqty
	. . . s inclb=$p(^(dsp),"^",2)
	. . . s uom=""
	. . . s buom=$p(^INCI(+inclb,1),"^",10)
	. . . i buom'="" s uom=$p(^CT("UOM",buom),"^",2)
	. . . 
	. . . s dsprowid=ord_"||"_itm_"||"_exe_"||"_dsp
	. .	. s sp=..GetPhaci(dsprowid)   ; not dispensing
	. .	. q:sp<0
	. .	. s amt=$fn(sp*qty,"",2)
	. .	. s i=i+1
	. .	. s info1=pano_"^"_paname_"^"_pasex_"^"_padob_"^"_admloc
	. .	. s info2=prescno_"^"_doctor_"^"_code_"^"_desc_"^"_orderstatus
	. .	. s info3=doseqty_"^"_freq_"^"_qty_"^"_uom_"^"_sp_"^"_amt
	. .	. s info4=instruction_"^"_duration_"^"_orditemremark_"^"_disploc
	. .	. s ^TMP($j,"OUTDRUG",i)=info1_"^"_info2_"^"_info3_"^"_info4
    q i
}

ClassMethod ListDrugOut(n)
{
	q ^TMP($j,"OUTDRUG",n)
}

ClassMethod GetPhaci(oedis As %String) As %String
{
	s sp=""
	s phac=$o(^DHCPHAC(0,"PHADSP",oedis,"")) q:phac="" -1
	s ch=$o(^DHCPHAC(0,"PHADSP",oedis,phac,"")) q:ch="" -2
	s sp=$p(^DHCPHAC(phac,"I",ch),"^",9)
	q sp
}

ClassMethod GetDispDrugOutClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDispDrugOutExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod GetDispDrugOutExecute(ByRef qHandle As %Binary, AdmRowid As %String, LocDr As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	q:AdmRowid="" $$$OK
 	q:LocDr="" $$$OK
 	;
 	s cnt=..getDrugOutList(AdmRowid,LocDr)
 	q:cnt<0 $$$OK
 	d resetvariables
 	f i=1:1:cnt d
 	.s data=..ListDrugOut(i)
 	.s pano=$p(data,"^",1)
 	.s paname=$p(data,"^",2)
 	.s pasex=$p(data,"^",3)
 	.s padob=$p(data,"^",4)
	.s admloc=$p(data,"^",5)
	.s prescno=$p(data,"^",6)
	.s doctor=$p(data,"^",7)
	.s code=$p(data,"^",8)
	.s desc=$p(data,"^",9)
	.s orderstatus=$p(data,"^",10)
	.s doseqty=$p(data,"^",11)
	.s freq=$p(data,"^",12)
	.s qty=$p(data,"^",13)
	.s uom=$p(data,"^",14)
	.s sp=$p(data,"^",15)
	.s amt=$p(data,"^",16)
	.s instruction=$p(data,"^",17)
	.s duration=$p(data,"^",18)
	.s orditemremark=$p(data,"^",19)
	.s disploc=$p(data,"^",20)
	.s padob=$fn((+$h-padob)/365,"",0)
 	.d outputrow
 	.
 	k ^TMP($j,"OUTDRUG")   ;in the end , clear the global variables
 	q $$$OK
resetvariables
	s (pano,paname,pasex,padob,admloc,prescno,doctor,code,desc,orderstatus,dosqty,freq,qty,uom,sp,amt,instruction,duration,orditemremark,disploc)=""
	q
outputrow
 	s Data=$lb(pano,paname,pasex,padob,admloc,prescno,doctor,code,desc,orderstatus,dosqty,freq,qty,uom,sp,amt,instruction,duration,orditemremark,disploc)
	s ^CacheTemp(repid,ind)=Data	
	s ind=ind+1
	q
}

ClassMethod GetDispDrugOutFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDispDrugOutExecute ]
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

Query GetDispDrugOut(AdmRowid As %String, LocDr As %String) As %Query(ROWSPEC = "pano:%String,paname:%String,pasex:%String,padob:%String,admloc:%String,prescno:%String,doctor:%String,code:%String,desc:%String,orderstatus:%String,doseqty:%String,freq:%String,qty:%String,uom:%String,sp:%String,amt:%String,instruction:%String,duration:%String,orditemremark:%String,disploc:%String")
{
}

ClassMethod GetExeTime(oedis As %String) As %String
{
	
 n (oedis)
 s ord=$p(oedis,"||",1),itm=$p(oedis,"||",2)
 q:'$d(^OEORD(ord,"I",itm,2)) ""
 s freq=$p(^OEORD(ord,"I",itm,2),"^",4)
 ;
 s ch=0
 s result=""
 q:freq="" ""
 q:'$d(^PHCFR(freq)) ""
 f  s ch=$o(^PHCFR(freq,"DT",ch)) q:ch=""  d
 . s disptime=$P(^(ch),"^",1)   
 . s disptime=+$e($zt(disptime),1,2)
 . i result="" s result=disptime
 . e  d
 . . s result=result_","_disptime
 q result
}

}
