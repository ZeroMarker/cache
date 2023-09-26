Include webimport

IncludeGenerator webimport

Class web.DHCSTPCHCOLLSyb Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Parameter BUILD = 585;

ClassMethod CLEARALL() As %Integer
{
	d ..CLEARTMP($j,"D")
	d ..CLEARTMP($j,"D1")
	d ..CLEARTMP($j,"D2")
	d ..CLEARTMP($j,"DISPM")
	d ..CLEARTMP($j,"DISPD")
	d ..CLEARTMP($j,"DISPMQ")  ;发药查询所用
	d ..CLEARTMP($j,"DISPDQ")  ;发药查询所用
	q 0
}

ClassMethod CLEARTMP(pid, PAR As %String) As %String
{
	k ^TMP(pid,PAR)
}

ClassMethod GETDATA1(gettype1 As %String, pid As %String) As %Integer
{
	n (gettype1,pid)
	k ^TMP(pid,"D1")
	s gettype=$g(gettype1)
	s j=0
	s arcpj="" f  s arcpj=$o(^TMP(pid,"D","ADM",arcpj))  q:arcpj=""  d
	.s arcpjsub="" f  s arcpjsub=$o(^TMP(pid,"D","ADM",arcpj,arcpjsub)) q:arcpjsub=""  d  
	..i ^TMP(pid,"D","ARCCAT",arcpj,arcpjsub)=gettype d
	...s getoedis=^TMP(pid,"D","OEDIS",arcpj,arcpjsub)
	...s getord=$p(getoedis,"||",1)                                                       ;OEORD_RowId                                                                      
	...s getchl=$p(getoedis,"||",2)                                                       ;OEORI_ChildSub
	...q:$p(^OEORD(getord,"I",getchl,1),"^",8)=""    
	...s j=j+1
	...s getadm=^TMP(pid,"D","ADM",arcpj,arcpjsub)
	...s getbed=^TMP(pid,"D","BED",arcpj,arcpjsub)
	...s getinclbdr=^TMP(pid,"D","INCLBDR",arcpj,arcpjsub)
	...s getpresc=^TMP(pid,"D","PRESC",arcpj,arcpjsub)
	...s getqty=^TMP(pid,"D","QTY",arcpj,arcpjsub)
	...s getprice=^TMP(pid,"D","PRICE",arcpj,arcpjsub)
	...s getdeploc=^TMP(pid,"D","DEPLOC",arcpj,arcpjsub)
	...s getoeflag=^TMP(pid,"D","OEFLAG",arcpj,arcpjsub)
	...s getaudited=$g(^TMP(pid,"D","AUDITED",arcpj,arcpjsub))      ; 0525 - if audited or not
	...s getinci=$p(getinclbdr,"||",1)                                                    ;INCI_RowId
	...s getincil=$p(getinclbdr,"||",2)                                                   ;INCIL_ChildSub
	...s getinclb=$p(getinclbdr,"||",3)                                                   ;INCLB_ChildSub
	...s getincibdr=$p(^INCI(getinci,"IL",getincil,"LB",getinclb),"^",1)                  ;INCIB_RowId
	...s getincib=$p(getincibdr,"||",2)
	...s getarcimid=$p(^OEORD(getord,"I",getchl,1),"^",2)                                 ;ARCIM_RowId      
	...s getpatnameid=$p(^PAADM(getadm),"^",1)                                            ;PA_PatMas PAPMI_RowId
	...s getarcim=$p(^ARCIM($p(getarcimid,"||",1),$p(getarcimid,"||",2),1),"^",2)
	...i gettype="PJ" s i=getdeploc_"||"_getbed_"||"_getarcimid    
	...e  s i=getinci_"||"_getarcimid_"||"_getdeploc_"||"_getbed
	...
	...;i gettype="ZJ" s i=getinci_"||"_getarcimid_"||"_getdeploc_"||"_getbed
	...;i gettype="DSY" s i=getinci_"||"_getarcimid_"||"_getdeploc_"||"_getbed
	...;i gettype="DSY" s i=getinci_"||"_getarcimid_"||"_getdeploc_"||"_getbed  ;;;;;;;;;;chh
	...;s ^TMP("XXXX",1)=i 
	...s ^TMP(pid,"D1","ARCIM",i,j)=getarcim       ;getarcim(i,j)                                                  ;医嘱名称
	...s ^TMP(pid,"D1","PATNAME",i,j)=$p(^PAPER(getpatnameid,"ALL"),"^",1)      ;getpatname(i,j)                     ;病人姓名   
	...s ^TMP(pid,"D1","PATMRN",i,j)=$p(^PAPER(getpatnameid,"PAT",1),"^",1)     ;getpatmrn(i,j)                     ;病人登记号
	...s ^TMP(pid,"D1","YBTYPE",i,j)=..GetYBType(getadm)
	...s ^TMP(pid,"D1","PRESC",i,j)=getpresc                                    ;getpresc(i,j)                     ;医嘱处方号      
	...s ^TMP(pid,"D1","BED",i,j)=getbed                                        ;getbed(i,j)                     ;病人床号       
	...s ^TMP(pid,"D1","PRICE",i,j)=getprice                                    ;getprice(i,j)                     ;医嘱价格       
	...s ^TMP(pid,"D1","QTY",i,j)=getqty                                        ;getqty(i,j)                     ;医嘱数量
	...s ^TMP(pid,"D1","PAKUOM",i,j)=$p(^CT("UOM",$p(^INCI(getinci,1),"^",10)),"^",2)  ;getpakuom(i,j)              ;药品基本库存单位       
	...i $p(^OEORD(getord,"I",getchl,2),"^",6)="" s ^TMP(pid,"D1","DURA",i,j)="*"
	...e  s ^TMP(pid,"D1","DURA",i,j)=$p(^PHCDU($p(^OEORD(getord,"I",getchl,2),"^",6)),"^",1)   ;getdur(i,j)      ;用药疗程
	...i $p(^OEORD(getord,"I",getchl,2),"^",7)="" s ^TMP(pid,"D1","INST",i,j)="*"
	...e  s ^TMP(pid,"D1","INST",i,j)=$p(^PHCIN($p(^OEORD(getord,"I",getchl,2),"^",7)),"^",2)  ;getinst(i,j)      ;用法
	...i $f(^TMP(pid,"D1","INST",i,j),"-")  s ^TMP(pid,"D1","INST",i,j)=$p(^TMP(pid,"D1","INST",i,j),"-",2)      
	...i $p(^OEORD(getord,"I",getchl,2),"^",4)="" s ^TMP(pid,"D1","FREQ",i,j)="*"           
	...e  s ^TMP(pid,"D1","FREQ",i,j)=$p(^PHCFR($p(^OEORD(getord,"I",getchl,2),"^",4)),"^",1)    ;getfreq(i,j)    ;用药频率 
	...s ^TMP(pid,"D1","DOSAGE",i,j)=$j($p(^OEORD(getord,"I",getchl,2),"^",1)," ",2)                       ;getdosage(i,j)   ;用药剂量
	...i $p(^OEORD(getord,"I",getchl,2),"^",3)="" s ^TMP(pid,"D1","UOM",i,j)="*"
	...e  s ^TMP(pid,"D1","UOM",i,j)=$p(^CT("UOM",$p(^OEORD(getord,"I",getchl,2),"^",3)),"^",2)   ;getuom(i,j)      ;剂量单位           
	...s ^TMP(pid,"D1","BATNO",i,j)=$p(^INCI(getinci,"IB",getincib),"^",1)         ;getincibno(i,j)                ;药物批号
	...s ^TMP(pid,"D1","OEFLAG",i,j)=getoeflag                                        ;getoeflag(i,j)               ;医嘱核实、未核实、停止状态
	...s ^TMP(pid,"D1","TYPE",i,j)=$p(^OECPR($p(^OEORD(getord,"I",getchl,1),"^",8)),"^",2)   ; getordtype(i,j)     ;医嘱优先级
	...s ^TMP(pid,"D1","DEPLOC",i,j)=$p(^CTLOC(getdeploc),"^",2)   ;getdeploc(i,j)             ;病人所在科室
	...s ^TMP(pid,"D1","OE",i,j)=getoedis     ;----------------------;;;;;;
	...i $f(^TMP(pid,"D1","DEPLOC",i,j),"-")  s ^TMP(pid,"D1","DEPLOC",i,j)=$p(^TMP(pid,"D1","DEPLOC",i,j),"-",2)
	...s ^TMP(pid,"D1","AUDITED",i,j)=getaudited    ;20060525 if audited or not
	s num=0
	s j="" f  s j=$o(^TMP(pid,"D1","ARCIM",j))  q:j=""  d
	.s i="" f  s i=$o(^TMP(pid,"D1","ARCIM",j,i)) q:i=""  d
	..i ^TMP(pid,"D1","OEFLAG",j,i)="V" s ^TMP(pid,"D1","OEFLAG",j,i)="*"
	..i ^TMP(pid,"D1","OEFLAG",j,i)="D" s ^TMP(pid,"D1","OEFLAG",j,i)="停止"
	..s getinfo0=^TMP(pid,"D1","DEPLOC",j,i)_"&"_^TMP(pid,"D1","BED",j,i)_"&"_^TMP(pid,"D1","PATNAME",j,i)_"&"_^TMP(pid,"D1","PATMRN",j,i)
	..s getinfo1=^TMP(pid,"D1","ARCIM",j,i)_"&"_^TMP(pid,"D1","QTY",j,i)_"&"_^TMP(pid,"D1","PAKUOM",j,i)_"&"_^TMP(pid,"D1","PRICE",j,i)
	..s getinfo2=^TMP(pid,"D1","OEFLAG",j,i)_"&"_^TMP(pid,"D1","TYPE",j,i)_"&"_^TMP(pid,"D1","DOSAGE",j,i)_^TMP(pid,"D1","UOM",j,i)
	..s getinfo3=^TMP(pid,"D1","FREQ",j,i)_"&"_^TMP(pid,"D1","INST",j,i)_"&"_^TMP(pid,"D1","DURA",j,i)_"&"_^TMP(pid,"D1","PRESC",j,i)_"&"_^TMP(pid,"D1","BATNO",j,i)
	..s getinfo4=^TMP(pid,"D1","OE",j,i)_"&"_^TMP(pid,"D1","YBTYPE",j,i)_"&"_^TMP(pid,"D1","AUDITED",j,i)
	..s getMed=getinfo0_"&"_getinfo1_"&"_getinfo2_"&"_getinfo3_"&"_getinfo4
	..s num=num+1
	..;s mPLIST(num)=getMed
	..s ^TMP(pid,"DISPD",num)=getMed 
	..
	..;
	.; 
	k ^TMP(pid,"D1")
	q num
}

ClassMethod GetYBType(adm As %String) As %String
{
	n (adm)
	q:adm="" ""
	s tmp=""
	s papmidr=$p(^PAADM(adm),"^",1)
	q:$g(papmidr)="" ""
	s persiondr=papmidr
	s ybdr=$p(^PAPER(persiondr,"PER",1),"^",10)
	q:$g(ybdr)="" ""
	q:'$d(^CT("SS",ybdr)) ""   ; 07.17
	s tmp=$p(^CT("SS",ybdr),"^",2)
	q $g(tmp)
}

ClassMethod Collect(phacdr As %String, Nurse As %String) As %String
{
	n (phacdr,Nurse)
	s Nurse=$g(Nurse)
	i '$d(^DHCPHAC(phacdr)) q -1
	;s i=0   
	;s phaci="" f  s phaci=$o(^DHCPHAC(phacdr,"I",phaci)) q:phaci=""  d
	;.s i=i+1
	;.s oedis=$p(^DHCPHAC(phacdr,"I",phaci),"^",7)
	;.s ord=$p(oedis,"||",1)                                                       ;OEORD_RowId                                                                      
	;.s chl=$p(oedis,"||",2)                                                       ;OEORI_ChildSub   
	;.s presc=$p(^DHCPHAC(phacdr,"I",phaci),"^",5)                                 ;医嘱处方号
	;.s oeflag=$p(^DHCPHAC(phacdr,"I",phaci),"^",10)                               ;医嘱核实、未核实、停止状态
	;.q:$$phstat^CHMVBaOET8(ord,chl)'="P"
	;.s err=$$collect^CHMVBaOET8(ord,chl) 
	;.i oeflag="D" s err=$$returnal^CHMVBaOET8(ord,chl)
	
	; calculate the rowcount of items 
	s phacdate=+$h
	s phactime=$p($h,",",2)
	s phaci="" 
	s cnt=0 
	f  s phaci=$o(^DHCPHAC(phacdr,"I",phaci)) q:phaci=""  d
	.s cnt=cnt+1
	.s qty=$p(^DHCPHAC(phacdr,"I",phaci),"^",6)  
	.s oedis=$p(^DHCPHAC(phacdr,"I",phaci),"^",7)
	.s oeflag=$p(^DHCPHAC(phacdr,"I",phaci),"^",10)  
	.i oeflag="D"  d ##class(web.DHCSTPHARETURN).ReturnDisp(oedis,qty,"")
	
	s ret=0 
	i cnt=0 d
	. &sql(DELETE FROM DHC_PHACollected WHERE DHC_PHACollect_RowID=:phacdr)
	. s phacdr=""
	e  d
	.s code="Collect"
	. &sql(UPDATE DHC_PHACollected SET DHC_PHACounts=:cnt,DHC_PHACollectStatus=:code,
	                                DHC_PHACollectDate=:phacdate,
	                                DHC_PHACollectTime=:phactime,
	                                DHC_PHACollectUser=:Nurse WHERE DHC_PHACollect_RowID=:phacdr)
	.i SQLCODE'=0 s ret=-2
	q:ret<0 ret
	i (phacdr'="") d ##class(web.DHCSTPCHCOLLS2).ReUpdateOedis(phacdr) ;再置oe_dispensing表的dsp_status为Collected,避免再发药 
	q ret
}

ClassMethod GetCat(CATCODE As %String) As %String
{
	n (CATCODE)
	s CATCODE=$$ALPHAUP^SSUTIL4(CATCODE)
	s ordcatdr=$o(^ARC("IC",0,"Code",CATCODE,"")) q:ordcatdr="" ""
	s SDG=$o(^DHCSTDRUGGRP(0,"ORDCAT",ordcatdr,"")) q:SDG="" ""
	s dispcat=$p(^DHCSTDRUGGRP(SDG),"^",1)
	q dispcat
}

ClassMethod GETDATA(phacdr As %String) As %Integer
{
   k ^TMP($j,"D2")
   ;k ^TMP($j,"DISPMQ")
   i '$d(^DHCPHAC(phacdr)) q -1
   s phactype=$p(^DHCPHAC(phacdr),"^",12)
   s phacdatefrom=$p(^DHCPHAC(phacdr),"^",10)
   s phacdateto=$p(^DHCPHAC(phacdr),"^",11)
   s phacward=$p(^DHCPHAC(phacdr),"^",4)
   s phacloc=$p(^DHCPHAC(phacdr),"^",1)
   s phacuser=$p(^DHCPHAC(phacdr),"^",5)
   s phacstat=$p(^DHCPHAC(phacdr),"^",6)
   s phacusername=$g(phacusername)
   i phacuser'="" s phacusername=$p(^SSU("SSUSR",+phacuser),"^",2)
   ;s P1=phactype
   ;s P2=$ZD(phacdatefrom,3)
   ;s P3=$ZD(phacdateto,3)
   ;i phacward="" s P4="*"
   ;e  s P4=$p(^PAWARD(phacward),"^",2)
   ;i phacuser="" s P5="*"
   ;e  s P5=$p(^SSU("SSUSR",phacuser),"^",2)
   ;s P6=phacstat
   ;s ^TMP($j,"DISPMQ")=phacloc_"&"_phactype_"&"_phacdatefrom_"&"_phacdateto_"&"_phacward_"&"_phacuser_"&"_phacstat
   s i=0   
   s phaci="" f  s phaci=$o(^DHCPHAC(phacdr,"I",phaci)) q:phaci=""  d
   .s i=i+1
   .s adm=$p(^DHCPHAC(phacdr,"I",phaci),"^",3)
   .s inclbdr=$p(^DHCPHAC(phacdr,"I",phaci),"^",4) 
   .s oedis=$p(^DHCPHAC(phacdr,"I",phaci),"^",7)   
   .s inci=$p(inclbdr,"||",1)                                                    ;INCI_RowId
   .s incil=$p(inclbdr,"||",2)                                                   ;INCIL_ChildSub
   .s inclb=$p(inclbdr,"||",3)                                                   ;INCLB_ChildSub
   .s incibdr=$p(^INCI(inci,"IL",incil,"LB",inclb),"^",1)                        ;INCIB_RowId
   .s incib=$p(incibdr,"||",2)                                                   ;INCIB_ChildSub   
   .s ord=$p(oedis,"||",1)                                                       ;OEORD_RowId                                                                      
   .s chl=$p(oedis,"||",2)                                                       ;OEORI_ChildSub
   .i '$d(^OEORD(ord,"I",chl)) q  
   .;s ordmemo=$$GetOrdItmRemark^DHCSTIPOUT(oedis)  
   .s ordmemo=##class(web.DHCSTPCHCOLLS2).GetOrdItmRemark(oedis)                                 ;oeori_remarks
   .&sql(select oeori_doctor_dr into :doctor from oe_orditem where oeori_oeord_parref=:ord and oeori_childsub=:chl)   ;医师
   .i doctor'="" s doctor=$p(^CTPCP(doctor,1),"^",2)
   .s arcimid=$p(^OEORD(ord,"I",chl,1),"^",2)                                    ;ARCIM_RowId     
   .s patnameid=$p(^PAADM(adm),"^",1)                                            ;PA_PatMas PAPMI_RowId
   .s code="In Patient"
   .&sql(select max(paadm_admdate) into :admdate from pa_adm where paadm_papmi_dr=:patnameid and paadm_type=:code)  ;入院日期
   .s admdate=$zd(admdate,3) 
   .s deploc=$p(^DHCPHAC(phacdr,"I",phaci),"^",11)
   .s arcim=$p(^ARCIM($p(arcimid,"||",1),$p(arcimid,"||",2),1),"^",2)
   .s bed=$p(^DHCPHAC(phacdr,"I",phaci),"^",8)
   .s j=deploc_"||"_bed_"||"_arcim         ;i phactype="PJ" 
   .i phactype'="PJ" s j=arcim_"||"_deploc_"||"_bed        
   .s ^TMP($j,"D2","ARCIM",j,i)=arcim                                        ;arcim(j,i)                 ;医嘱名称
   .s ^TMP($j,"D2","PATNAME",j,i)=$p(^PAPER(patnameid,"ALL"),"^",1)          ;patname(j,i)                 ;病人姓名   
   .s ^TMP($j,"D2","PATMRN",j,i)=$p(^PAPER(patnameid,"PAT",1),"^",1)         ;patmrn(j,i)                 ;病人登记号      
   .s ^TMP($j,"D2","PRESC",j,i)=$p(^DHCPHAC(phacdr,"I",phaci),"^",5)         ;presc(j,i)                 ;医嘱处方号      
   .s ^TMP($j,"D2","BED",j,i)=bed                                            ;bed(j,i)                 ;病人床号       
   .s ^TMP($j,"D2","PRICE",j,i)=$fn($p(^DHCPHAC(phacdr,"I",phaci),"^",9),"",4)         ;price(j,i)                 ;医嘱价格       
   .s ^TMP($j,"D2","QTY",j,i)=$p(^DHCPHAC(phacdr,"I",phaci),"^",6)           ;qty(j,i)                 ;医嘱数量
   .s ^TMP($j,"D2","PAKUOM",j,i)=$p(^CT("UOM",$p(^INCI(inci,1),"^",10)),"^",2) ;pakuom(j,i)               ;药品基本库存单位       
   .s ^TMP($j,"D2","YBTYPE",j,i)=..GetYBType(+adm)
   .i $p(^OEORD(ord,"I",chl,2),"^",6)="" s ^TMP($j,"D2","DURA",j,i)="*"
   .e  s ^TMP($j,"D2","DURA",j,i)=$p(^PHCDU($p(^OEORD(ord,"I",chl,2),"^",6)),"^",1)   ;dur(j,i)         ;用药疗程
   .i $p(^OEORD(ord,"I",chl,2),"^",7)="" s ^TMP($j,"D2","INST",j,i)="*"
   .e  s ^TMP($j,"D2","INST",j,i)=$p(^PHCIN($p(^OEORD(ord,"I",chl,2),"^",7)),"^",2)   ;inst(j,i)        ;用法
   .i $f(^TMP($j,"D2","INST",j,i),"-")  s ^TMP($j,"D2","INST",j,i)=$p(^TMP($j,"D2","INST",j,i),"-",2)      
   .i $p(^OEORD(ord,"I",chl,2),"^",4)="" s ^TMP($j,"D2","FREQ",j,i)="*"           ;freq(j,i)
   .e  s ^TMP($j,"D2","FREQ",j,i)=$p(^PHCFR($p(^OEORD(ord,"I",chl,2),"^",4)),"^",1)           ;用药频率 
   .s ^TMP($j,"D2","DOSAGE",j,i)=$j($p(^OEORD(ord,"I",chl,2),"^",1)," ",3)                     ;dosage(j,i)         ;用药剂量
   .i $p(^OEORD(ord,"I",chl,2),"^",3)="" s ^TMP($j,"D2","UOM",j,i)="*"
   .e  s ^TMP($j,"D2","UOM",j,i)=$p(^CT("UOM",$p(^OEORD(ord,"I",chl,2),"^",3)),"^",2)   ;uom(j,i)         ;剂量单位           
   .s ^TMP($j,"D2","BATNO",j,i)=$p(^INCI(inci,"IB",incib),"^",1)                       ;incibno(j,i)     ;药物批号
   .s ^TMP($j,"D2","OEFLAG",j,i)=$p(^DHCPHAC(phacdr,"I",phaci),"^",10)                    ;oeflag(j,i)    ;医嘱核实、未核实、停止状态
   .i $p(^OEORD(ord,"I",chl,1),"^",8)="" s ^TMP($j,"D2","TYPE",j,i)="*"            ;ordtype(j,i)
   .e  s ^TMP($j,"D2","TYPE",j,i)=$p(^OECPR($p(^OEORD(ord,"I",chl,1),"^",8)),"^",2)           ;医嘱优先级
   .s ^TMP($j,"D2","DEPLOC",j,i)=$p(^CTLOC(deploc),"^",2)                                  ;deploc(j,i)   ;病人所在科室
   .i $f(^TMP($j,"D2","DEPLOC",j,i),"-")  s ^TMP($j,"D2","DEPLOC",j,i)=$p(^TMP($j,"D2","DEPLOC",j,i),"-",2)
   .s ^TMP($j,"D2","DOTOR",j,i)=doctor        
   .s ^TMP($j,"D2","ADMDATE",j,i)=admdate
   .s ^TMP($j,"D2","PHACUSERNAME",j,i)=phacusername
   .s ^TMP($j,"D2","ORDMEMO",j,i)=ordmemo
   .i (^TMP($j,"D2","OEFLAG",j,i)'="D")&(^TMP($j,"D2","TYPE",j,i)'="NORM") d
   ..i $d(HUIZONGPJ(arcimid)) s $p(HUIZONGPJ(arcimid),"&",2)=$p(HUIZONGPJ(arcimid),"&",2)+^TMP($j,"D2","QTY",j,i) 
   ..i '$d(HUIZONGPJ(arcimid)) d
   ...s $p(HUIZONGPJ(arcimid),"&",1)=arcim 
   ...s $p(HUIZONGPJ(arcimid),"&",2)=^TMP($j,"D2","QTY",j,i) 
   ...s $p(HUIZONGPJ(arcimid),"&",3)=$p(^INCI(inci,1),"^",10)
   ...s $p(HUIZONGPJ(arcimid),"&",4)=^TMP($j,"D2","PRICE",j,i)
   s num=0
   s j="" f  s j=$o(^TMP($j,"D2","ARCIM",j))  q:j=""  d
   .s i="" f  s i=$o(^TMP($j,"D2","ARCIM",j,i)) q:i=""  d
   ..i ^TMP($j,"D2","OEFLAG",j,i)="V" s ^TMP($j,"D2","OEFLAG",j,i)="*"
   ..i ^TMP($j,"D2","OEFLAG",j,i)="D" s ^TMP($j,"D2","OEFLAG",j,i)="停止"
   ..s info0=^TMP($j,"D2","DEPLOC",j,i)_"&"_^TMP($j,"D2","BED",j,i)_"&"_^TMP($j,"D2","PATNAME",j,i)_"&"_^TMP($j,"D2","PATMRN",j,i)
   ..s info1=^TMP($j,"D2","ARCIM",j,i)_"&"_^TMP($j,"D2","QTY",j,i)_" "_^TMP($j,"D2","PAKUOM",j,i)_"&"_^TMP($j,"D2","PRICE",j,i)
   ..s info2=^TMP($j,"D2","OEFLAG",j,i)_"&"_^TMP($j,"D2","TYPE",j,i)_"&"_^TMP($j,"D2","DOSAGE",j,i)_^TMP($j,"D2","UOM",j,i)
   ..s info3=^TMP($j,"D2","FREQ",j,i)_"&"_^TMP($j,"D2","INST",j,i)_"&"_^TMP($j,"D2","DURA",j,i)_"&"_^TMP($j,"D2","PRESC",j,i)_"&"_^TMP($j,"D2","BATNO",j,i)_"&"_^TMP($j,"D2","DOTOR",j,i)_"&"_^TMP($j,"D2","ADMDATE",j,i)_"&"_^TMP($j,"D2","PHACUSERNAME",j,i)_"&"_^TMP($j,"D2","ORDMEMO",j,i)
   ..s Med=info0_"&"_info1_"&"_info2_"&"_info3
   ..s memo=""
   ..s memonum=^OEORD(ord,"I",chl,"DEP",0)               ;get memo
   ..f k=2:1:memonum  d
   ...s memo=memo_^OEORD(ord,"I",chl,"DEP",k)
   ..s num=num+1
   ..;s mPLIST(num)=Med_"&"_memo_"&"_^TMP($j,"D2","YBTYPE",j,i)
   ..s ^TMP($j,"DISPDQ",num)=^TMP($j,"D2","YBTYPE",j,i)_"&"_Med_"&"_memo_"&"_111111111
   ..;
   .; 
   k ^TMP($j,"D2")
   q num
}

ClassMethod GetDispD(n As %Integer, pid As %String) As %String
{
	i $d(^TMP(pid,"DISPD",n)) q ^TMP(pid,"DISPD",n)
	q ""
}

ClassMethod GetDispDQ(n As %Integer) As %String
{
	i $d(^TMP($j,"DISPDQ",n)) q ^TMP($j,"DISPDQ",n)
	q ""
}

ClassMethod getprice(INCITM As %String, STTDATE As %String) As %Currency
{
	n (INCITM,STTDATE)
	;-------calculate the retail price-------------------
	s STTDATE=STTDATE+1
	s excudate=$o(^INASP(0,"INCI",INCITM,STTDATE),-1)
	q:excudate="" 0
	s adjrow=$o(^INASP(0,"INCI",INCITM,excudate,""))
	s PRICE=$p(^INASP(adjrow),"^",7)       
	q PRICE
}

ClassMethod PCHCOLLADM(loc1 As %String, adm1 As %String, datefrom1 As %String, dateto1 As %String, user1 As %String, SpecialPha As %String, LFlag As %String, SFlag As %String, OutFlag As %String, DispCat As %String, NotAudit As %String) As %Integer
{
  ; s ^TMP("XXXXXX")=loc1_" \ "_adm1_" \ "_datefrom1_" \ "_dateto1_" \ "_user1_" \ "_SpecialPha_" \ "_LFlag_" \ "_SFlag_" \ "_OutFlag_" \ "_DispCat
   d ..CLEARALL()
    ;s ^TMP($j,"XXXXXXXXXXXX")=NotAudit
   s datefrom=datefrom1
   s dateto=dateto1
   s adm=$g(adm1)
   s ord=$o(^OEORD(0,"Adm",adm,""))
   q:ord="" -1
   s ward=$p(^PAADM(adm),"^",70)
   s loc=$g(loc1),user=$g(user1)
   s i=0
   f date=datefrom:1:dateto d
   .s chl="" f  s chl=$o(^OEORDi(0,"ItemDate",date,ord,chl)) q:chl=""  d          ;
   ..s reploc=$p(^OEORD(ord,"I",chl,3),"^",6)                                     ;医嘱接收位置
   ..q:reploc'=loc                                                                ;只处理发到该药房的医嘱
   ..q:$p(^OEORD(ord,"I",chl,1),"^",8)=""                      ;优先级不存在的不予发放 2006-05-27
   ..s priority=$p(^OECPR($p(^OEORD(ord,"I",chl,1),"^",8)),"^",1)  
   ..q:priority=""
   ..q:priority="OM" ;自备药即刻
   ..q:priority="OMST" ;自备药长期
   ..;q:priority="PRN" 
   ..s doctorloc=$p(^OEORD(ord,"I",chl,7),"^",2)   ;060725
   ..
   ..;i (SpecialPha="1")&(DoctorLocRowid'="")  q:(DoctorLocRowid'=doctorloc)  ; 实行医生科室发药时的控制
   ..;i (SpecialPha="0")&(DoctorLocRowid="") q:(..DoctorLocRefuse(loc,doctorloc)=1) ;病区发药时过滤掉医生科室
   ..
   ..i LFlag="1"    q:priority'="S"       ;只处理长期医嘱
   ..i OutFlag="1"  q:priority'="OUT"      ;只处理出院带药
   ..i SFlag="1"    q:(priority="S")!(priority="OUT")         ;只处理即刻医嘱和取药医嘱   
   ..i OutFlag'="1"  q:priority="OUT"      ;在不选中"仅发出院代药"的情况下,不包括出院带药
   ..s Audited=##class(web.DHCSTPCHCOLLS2).OrdItmAudited(ord_"||"_chl)
   ..i ('NotAudit)&(..NonAuditLoc(loc)=0) q:Audited<0  	 ; not audited ,2006-05-13 added
   ..q:##class(web.DHCSTPCHCOLLS2).SkinTest(ord_"||"_chl)<0 		;not skintest,2006-05-13 added
   ..
   ..s ex=0 f  s ex=$o(^OEORD(ord,"I",chl,"X",ex)) q:ex=""  d                     ;
   ...s dis=0 f  s dis=$o(^OEORD(ord,"I",chl,"X",ex,"D",dis)) q:dis=""  s disp=^(dis) d   ;
   ....s stdfid=""  ;--------------------------------
   ....s stdfid=$o(^STDF("OEDI",ord_"||"_chl_"||"_ex_"||"_dis,stdfid))
   ....q:stdfid'=""  ;---------------------------------------------------------
   ....s dstatus=$p(disp,"^",6)                                                   ;
   ....;b
   ....q:$g(dstatus)'="P"                                                         ;只处理已打包医嘱
   ....s i=i+1                                                                    ;
   ....;---------- get data ------------------------------------------------------;----------------------------       
   ....s bedid=$p(^PAADM(adm),"^",73)                                               ;PA_Beds RowId
   ....i bedid="" s bed=""
   ....e  s bed=$p(^PAWARD($p(bedid,"||",1),"BED",$p(bedid,"||",2)),"^",1)          ;病人床号
   ....s deploc=$p(^PAADM(adm),"^",4)                                               ;病人所在科室
   ....s oeflag=$p(^OEC("OSTAT",$p(^OEORD(ord,"I",chl,1),"^",13)),"^",1)            ;医嘱核实、未核实、停止状态
   ....q:oeflag="D"  ; Stoped Item excluded zhwh.05.11.01
   ....;q:oeflag'="V"  ;
   ....q:(oeflag'="V")&(oeflag'="E")
   ....
   ....s j=deploc_"||"_bed_"||"_oeflag_"||"_priority
   ....s ^TMP($j,"D","ADM",j,i)=adm
   ....s ^TMP($j,"D","OEDIS",j,i)=ord_"||"_chl_"||"_ex_"||"_dis                   ;        
   ....s ^TMP($j,"D","PRESC",j,i)=$p(^OEORD(ord,"I",chl,1),"^",14)                  ;医需处方号
   ....s ^TMP($j,"D","QTY",j,i)=$p(^OEORD(ord,"I",chl,"X",ex,"D",dis),"^",1)        ;发药数量        
   ....s ^TMP($j,"D","BED",j,i)=bed                                                 ;病人床号
   ....s arcimid=$p(^OEORD(ord,"I",chl,1),"^",2)                                    ;医嘱 ARC_ItmMast ARCIM_RowId
   ....s arccatid=$p(^ARCIM($p(arcimid,"||",1),$p(arcimid,"||",2),1),"^",10)        ;医嘱子类RowId
   ....s catcode=$p(^ARC("IC",arccatid),"^",1)                ;arccat(j,i)          ;医嘱子类代码
   ....s ^TMP($j,"D","ARCCAT",j,i)=..GetCat(catcode)
   ....s inclbid=$p(^OEORD(ord,"I",chl,"X",ex,"D",dis),"^",2)                       ;INCLB_RowId
   ....s sttdate=$p(^OEORD(ord,"I",chl,1),"^",9)                                    ;Order Start Date     
   ....s inci=$p(inclbid,"||",1)                                                    ;INCI_RowId
   ....s incil=$p(inclbid,"||",2)                                                   ;INCIL_ChildSub
   ....s inclb=$p(inclbid,"||",3)                                                   ;INCLB_ChildSub
   ....s incibid=$p(^INCI(inci,"IL",incil,"LB",inclb),"^",1)                        ;INCIB_RowId
   ....s ^TMP($j,"D","INCLBDR",j,i)=inclbid                                         ;INCLB_RowId : 药物库存批次        
   ....s ^TMP($j,"D","PRICE",j,i)=..getprice(inci,sttdate)                          ;医嘱价格
   ....s ^TMP($j,"D","OEFLAG",j,i)=oeflag                                           ;医嘱核实、未核实、停止状态
   ....s ^TMP($j,"D","DEPLOC",j,i)=deploc                                           ;病人所在科室       
   ....;--------------------------------------------------------------------------;-----------------------------
   ....i ^TMP($j,"D","BED",j,i)="" s ^TMP($j,"D","BED",j,i)="*"            ;bed(j,i)bed(j,i)="" s bed(j,i)="*"
   ....s ^TMP($j,"D","AUDITED",j,i)=$g(Audited)
   ....
   ....s ^TMP($j,"D","SAVE",j,i)=1 ;
   ....i (SpecialPha=1)&(..NonAuditLoc(loc)=0)&($g(Audited)<0) s ^TMP($j,"D","SAVE",j,i)=0 ;
   ....
   ...;
   ..;
   .;
   i i>0 s ^TMP($j,"DISPM")=loc_"^"_ward_"^"_datefrom_"^"_dateto_"^"_user1
   i i>0 q $j
   ;
   q ""
}

ClassMethod PCHCOLLS(loc1 As %String, ward1 As %String, datefrom1 As %String, dateto1 As %String, user1 As %String, SpecialPha As %String, LFlag As %String, SFlag As %String, OutFlag As %String, DispCat As %String, DoctorLocRowid As %String, NotAudit As %String) As %Integer
{
	;save the data into temporary global
	;s ^TMP("XXXXXX",2)=loc1_" \ "_ward1_" \ "_datefrom1_" \ "_dateto1_" \ "_user1_" \ "_SpecialPha_" \ "_LFlag_" \ "_SFlag_" \ "_OutFlag_" \ "_DispCat_" \ "_DoctorLocRowid_" \ "_NotAudit

	n (loc1,ward1,datefrom1,dateto1,user1,SpecialPha,LFlag,SFlag,OutFlag,DispCat,DoctorLocRowid,NotAudit)
	;
	d ..CLEARALL()
	s datefrom=datefrom1
	s dateto=dateto1 

    ;s ^TMP($j,"XXXXXXXXXXXX")=NotAudit
    
	s ward=$g(ward1)  ; get rowid of ward 
	s loc=$g(loc1),user=$g(user1)
	i (SpecialPha="0")&(ward="") q -1  ; 病区为空
	i (SpecialPha="1")&(ward'="") q -1   ; 特殊药房发药（病区应不加限定）
	s i=0
	s ^TMP($j,"DISPM")=loc_"^"_ward_"^"_datefrom_"^"_dateto_"^"_user
	f date=datefrom:1:dateto d
	.s ord="" f  s ord=$o(^OEORDi(0,"ItemDate",date,ord)) q:ord=""  d               ;
	..q:'$D(^OEORD(ord))
	..s adm=$p(^OEORD(ord),"^",1)  
	..q:adm=""
	..q:'$d(^PAADM(adm))
	..;s ^TMP("XXXXXXXX")=adm
	..s admward=$p(^PAADM(adm),"^",70)  ;病人所在病房                                
	..q:(SpecialPha="0")&(admward'=ward) 
	..
	..
	..s AmtReult=##class(web.DHCSTPCHCOLLS2).IFGivePHC(adm,ward,SpecialPha)
	..q:AmtReult=-1  ;对欠费的处理   ..
	..
	..s chl="" f  s chl=$o(^OEORDi(0,"ItemDate",date,ord,chl)) q:chl=""  d          ;
	...s reploc=$p(^OEORD(ord,"I",chl,3),"^",6) q:+reploc'=+loc  ; the receive loc is not the specified loc                                  ;医嘱接收位置
	...
	...q:$p(^OEORD(ord,"I",chl,1),"^",8)=""         ;优先级不存在的不予发放 2006-05-27
	...s priority=$p(^OECPR($p(^OEORD(ord,"I",chl,1),"^",8)),"^",1)                 ;医嘱优先级代码
	...q:priority="OM" ;自备药即刻
	...q:priority="OMST" ;自备药长期
	...;q:priority="PRN"  ;
    ...i LFlag="1"    q:priority'="S"       ;只处理长期医嘱
    ...i OutFlag="1"  q:priority'="OUT"      ;只处理出院带药
    ...i SFlag="1"    q:(priority="S")!(priority="OUT")         ;只处理即刻医嘱和取药医嘱   
	...i OutFlag'="1"  q:priority="OUT"      ;在不选中"仅发出院代药"的情况下,不包括出院带药
	...s Audited=##class(web.DHCSTPCHCOLLS2).OrdItmAudited(ord_"||"_chl)
	...i (SpecialPha="0")&('NotAudit)&(..NonAuditLoc(loc)=0) q:Audited<0  	; not audited ,2006-05-13 added
	...
	...
	...q:##class(web.DHCSTPCHCOLLS2).SkinTest(ord_"||"_chl)<0 		;not skintest,2006-05-13 added
	...
	...s doctor=$p(^OEORD(ord,"I",chl,7),"^",1)
	...;s doctorloc=..DocLocRowid(doctor)
	...
	...s doctorloc=$p(^OEORD(ord,"I",chl,7),"^",2)   ;060725
	...
	...i (SpecialPha="1")&(DoctorLocRowid'="")  q:(DoctorLocRowid'=doctorloc)  ; 实行医生科室发药时的控制
	...i (SpecialPha="1")&(DoctorLocRowid="") q:(..DoctorLocRefuse(loc,doctorloc)=1)
	...i (SpecialPha="0")&(DoctorLocRowid="") q:(..DoctorLocRefuse(loc,doctorloc)=1) ;病区发药时过滤掉医生科室
	...i (SpecialPha="1")&('NotAudit)&(..NonAuditDoctorLoc(doctorloc)=0) q:Audited<0
	...
	...s ex=0 f  s ex=$o(^OEORD(ord,"I",chl,"X",ex)) q:ex=""  d                     ;
	....s dis=0 f  s dis=$o(^OEORD(ord,"I",chl,"X",ex,"D",dis)) q:dis=""  s disp=^(dis) d   ;
	.....s stdfid=""  ;--------------------------------
	.....s stdfid=$o(^STDF("OEDI",ord_"||"_chl_"||"_ex_"||"_dis,stdfid))
	.....q:stdfid'=""  ;---------------------------------------------------------
	.....
	.....s dstatus=$p(disp,"^",6)                                                   ;
	.....q:$g(dstatus)'="P"   
	.....;---------- get data ------------------------------------------------------;----------------------------       
	.....s bedid=$p(^PAADM(adm),"^",73)                                             ;PA_Beds RowId
	.....i bedid="" s bed=""
	.....e  s bed=$p(^PAWARD($p(bedid,"||",1),"BED",$p(bedid,"||",2)),"^",1)        ;病人床号
	.....s deploc=$p(^PAADM(adm),"^",4)                                             ;病人所在科室
	.....;s ^TMP("XXX",1)=ord
	.....;s ^TMP("XXX",2)=chl
	.....s oeflag=$p(^OEC("OSTAT",$p(^OEORD(ord,"I",chl,1),"^",13)),"^",1)          ;医嘱核实、未核实、停止状态
	.....q:oeflag="D"  ; Stoped Item excluded zhwh.05.11.01
	.....;q:oeflag'="V"  ;
	.....
	.....q:(oeflag'="V")&(oeflag'="E")
	.....s arcimid=$p(^OEORD(ord,"I",chl,1),"^",2)                                    ;医嘱 ARC_ItmMast ARCIM_RowId
	.....s arccatid=$p(^ARCIM($p(arcimid,"||",1),$p(arcimid,"||",2),1),"^",10)        ;医嘱子类RowId
	.....s catcode=$p(^ARC("IC",arccatid),"^",1)            ;arccat(j,i)              ;医嘱子类代码
	.....;
	.....s cat=..GetCat(catcode)
	.....
	.....q:..CatInList(DispCat,cat)=0  ;If the cat not in the required cat list then quit
	.....;q:((..GetCat(catcode)="PJ")&(priority="ONCE"))
	.....s i=i+1                                                                  ;
	.....s j=deploc_"||"_bed_"||"_oeflag_"||"_priority_"||"_adm
	.....
	.....;
	.....s ^TMP($j,"D","ADM",j,i)=adm                                               ;adm(j,i)
	.....s ^TMP($j,"D","OEDIS",j,i)=ord_"||"_chl_"||"_ex_"||"_dis                   ;oedis(j,i)         ;        
	.....s ^TMP($j,"D","PRESC",j,i)=$p(^OEORD(ord,"I",chl,1),"^",14)                ;presc(j,i)         ;医需处方号
	.....s ^TMP($j,"D","QTY",j,i)=$p(^OEORD(ord,"I",chl,"X",ex,"D",dis),"^",1)      ;qty(j,i)           ;发药数量        
	.....s ^TMP($j,"D","BED",j,i)=bed     ;bed(j,i)                                                     ;病人床号
	.....s ^TMP($j,"D","ARCCAT",j,i)=cat
	.....s inclbid=$p(^OEORD(ord,"I",chl,"X",ex,"D",dis),"^",2)                       ;INCLB_RowId
	.....s sttdate=$p(^OEORD(ord,"I",chl,1),"^",9)                                    ;Order Start Date     
	.....s inci=$p(inclbid,"||",1)                                                    ;INCI_RowId
	.....s incil=$p(inclbid,"||",2)                                                   ;INCIL_ChildSub
	.....s inclb=$p(inclbid,"||",3)                                                   ;INCLB_ChildSub
	.....s incibid=$p(^INCI(inci,"IL",incil,"LB",inclb),"^",1)                        ;INCIB_RowId
	.....s ^TMP($j,"D","INCLBDR",j,i)=inclbid      ;inclbdr(j,i)                      ;INCLB_RowId : 药物库存批次        
	.....s ^TMP($j,"D","PRICE",j,i)=..getprice(inci,sttdate)    ;price(j,i)           ;医嘱价格
	.....s ^TMP($j,"D","OEFLAG",j,i)=oeflag       ;oeflag(j,i)                        ;医嘱核实、未核实、停止状态
	.....s ^TMP($j,"D","DEPLOC",j,i)=deploc       ;deploc(j,i)                        ;病人所在科室       
	.....i ^TMP($j,"D","BED",j,i)="" s ^TMP($j,"D","BED",j,i)="*"   ;bed(j,i)
	.....s ^TMP($j,"D","AUDITED",j,i)=$g(Audited) ;
	.....s ^TMP($j,"D","SAVE",j,i)=1 ;
	.....i (SpecialPha=1)&(DoctorLocRowid'="")&(..NonAuditDoctorLoc(doctorloc)=0)&($g(Audited)<0) s ^TMP($j,"D","SAVE",j,i)=0 ;
	.....i (SpecialPha=0)&(..NonAuditLoc(loc)=0)&($g(Audited)<0) s ^TMP($j,"D","SAVE",j,i)=0 ; 
	.....
	..... 
	.....
	....;
	...;
	..;
	.;
	i i>0 s ^TMP($j,"DISPM")=loc_"^"_ward_"^"_datefrom_"^"_dateto_"^"_user1
	i i>0 q $j    ; return the process ID
	q ""
}

ClassMethod DoctorLocRefuse(phaloc, doctorloc)
{
	;1:拒绝的医生科室 0:非拒绝的医生科室
	n (phaloc,doctorloc)
	&sql(select * from CT_LocLinkLocation where link_parref=:phaloc and link_ctloc_dr=:doctorloc)
	q:'SQLCODE 1
	q 0
}

ClassMethod CatInList(dispcat, cat)
{
	n (dispcat, cat)
	s i=1
	s result=0
	f  s tmp=$p(dispcat,"^",i) q:(tmp="")!(result=1)  d
	. i cat=tmp s result=1 q
	. s i=i+1
    q result
}

ClassMethod GetAdm(itmjs As %Library.String = "", itmjsex As %Library.String = "", RegNo As %String) As %Integer
{
	n (RegNo,itmjs,itmjsex)
	s result=$g(result)
	;s papmi=$o(^PAPERi("PAPMI_PatNo",$$ALPHAUP^SSUTIL4(RegNo),""))
	s papmi=$o(^PAPERi("PAPMI_PatNo",RegNo,""))
	q:papmi="" ""
	;s P2=$p(^PAPER(papmi,"ALL"),"^",1)
	s adm="" f  s adm=$o(^PAPERdr(papmi,"ADM","I",adm),-1) q:adm=""  d
	. i adm'="" d
	. . s adm=+adm
	. . q:$p(^PAADM(adm),"^",2)'="I"      ; if not inpatient then quit - 20060601
	. . s depcodedr=$p(^PAADM(adm),"^",4) i depcodedr'="" s depDesc=$p(^CTLOC(depcodedr),"^",2)
	. . s admdate=$p(^PAADM(adm),"^",6) i admdate>0 s admdate=$zd(admdate,3) 
	. . s admtime=$p(^PAADM(adm),"^",7) i admtime>0 s admtime=$zt(admtime)
	. . s curWard=$p(^PAADM(adm),"^",70) i curWard'="" s curWardDesc=$p(^PAWARD(+curWard),"^",2)
	. . s curBed=$p(^PAADM(adm),"^",73) i curBed'="" d
	. . .s w=+curBed,b=$p(curBed,"||",2) q:(w="")!(b="")
	. . .s curBedcode=$p(^PAWARD(w,"BED",b),"^",1)
	. . s doctor=$p(^PAADM(adm),"^",9) i doctor'=""  s doctor=$p(^CTPCP(doctor,1),"^",2 )
	. .
	. s xxx=$g(adm)_"&"_$g(depDesc)_" * "_$g(admdate)_" * "_$g(admtime)_" * "_$g(curWardDesc)_" * "_$g(curBedcode)_" * "_$g(doctor)
	. i result="" d
	. . s result=xxx ;
	. e  d
	. . s result=result_"^"_xxx
	. . 
	s retval=itmjs_"('"_$ZCVT(result,"O","JS")_"');"
	i itmjsex'="""" s retval=retval_itmjsex_"('"_$ZCVT(result,"O","JS")_"');"
	&javascript<#(retval)#>
	q $g(result)
}

ClassMethod GetPaInfo(itmjs As %Library.String = "", itmjsex As %Library.String = "", pano As %String) As %String
{
	n (pano,itmjs,itmjsex)
	&sql(select papmi_name,papmi_sex_dr->ctsex_desc,nvl(papmi_dob,"") 
	        into :paname,:sex,:dob from pa_patmas
	       where papmi_no=:pano)
	q:SQLCODE ""
	i $g(dob)'="" d
	   .s age=$fn((+$h-dob)/365,"",0)
	   .s dob=$zd(dob,3)
	   .s dob=dob_"( "_age_"岁 )" 
	;s dob=$zd(dob,3)
	s result=$g(paname)_"^"_$g(sex)_"^"_ $g(dob)
   
	s retval=itmjs_"('"_$ZCVT(result,"O","JS")_"');"
	i itmjsex'="""" s retval=retval_itmjsex_"('"_$ZCVT(result,"O","JS")_"');"
	&javascript<#(retval)#>
}

ClassMethod GetColl(datef As %String, datet As %String, pha As %String, ward As %String, user As %String, type As %String, StartTime As %String, EndTime As %String) As %Integer
{
	q:datef="" ""
	q:datet="" ""
	q:pha="" ""
    i $g(StartTime)="" s StartTime=$zth("00:00:00",3)       ;0
    i $g(EndTime)="" s EndTime=$zth("23:59:59",3)       ;86399
 	;
	s ward=$g(ward),user=$g(user),type=$g(type)  
	;s datef=$ZDATEH(datef,4)
	;s datet=$ZDATEH(datet,4)
	s num=0
	k ^TMP($j,"DISPMQ")
	k ^TMP($j,"DISPDQ")

	f date=datef:1:datet d
	.s coll="" f  s coll=$o(^DHCPHAC(0,"PHP",pha,"DATE",date,coll)) q:coll=""  d               ;
	..s collward=$p(^DHCPHAC(coll),"^",4) 
	..s colluser=$p(^DHCPHAC(coll),"^",5)
	..s colltype=$p(^DHCPHAC(coll),"^",12)
	..s colldate=$p(^DHCPHAC(coll),"^",2)
	..s colltime=$p(^DHCPHAC(coll),"^",3)
    ..;s ch="" f  s ch=$o(^DHCPHAC(coll,"I",ch)) q:ch=""  d
	..i colldate=datef q:(colltime<StartTime)
	..i colldate=datet q:(colltime>EndTime)
	..i ward'="" q:collward'=ward
	..i type'="" q:colltype'=type
	..i user'="" q:colluser'=user
	..i collward'="" s collward=$p(^PAWARD(collward),"^",2)       
	..i colluser'="" s colluser=$p(^SSU("SSUSR",colluser),"^",2)
	..s ctname=""   ;20061229 add
	..i collward="" d    ;20061229 add
	...s ch=$o(^DHCPHAC(coll,"I",0)) ;20061229 add
    ...i ch>0 d     ;20061229 add
    ....s oedis=$p(^DHCPHAC(coll,"I",ch),"^",7)  ;20061229 add
    ....q:'$d(^OEORD($p(oedis,"||",1),"I",$p(oedis,"||",2))) ;20061229 add
    ....s ctlocnum=$p(^OEORD($p(oedis,"||",1),"I",$p(oedis,"||",2),7),"^",2) ;20061229 add
    ....i ctlocnum'="" s ctloc1=$p(^CTLOC(ctlocnum),"^",2),ctname=$p(ctloc1,"-",2) ;20061229 add
	..s collpdate=$p(^DHCPHAC(coll),"^",7) i collpdate'="" s collpdate=$ZD(collpdate)
	..s collptime=$p(^DHCPHAC(coll),"^",8) i collptime'="" s collptime=$ZT(collptime)
	..s collcdate=$p(^DHCPHAC(coll),"^",2) i collcdate'="" s collcdate=$ZD(collcdate)
	..s collctime=$p(^DHCPHAC(coll),"^",3) i collctime'="" s collctime=$ZT(collctime)
	..s collcount=$p(^DHCPHAC(coll),"^",9)
	..s collcuser=$p(^DHCPHAC(coll),"^",13) i collcuser'="" s collcuser=$p(^SSU("SSUSR",collcuser),"^",2)
	..s collstatus=$p(^DHCPHAC(coll),"^",6)
	..s colldatef=$ZD($p(^DHCPHAC(coll),"^",10))
	..s colldatet=$ZD($p(^DHCPHAC(coll),"^",11))
	..i colltype'="" s colltypedesc=..DispCatDesc(colltype)
	..s num=num+1
	..s ^TMP($j,"DISPMQ",num)=coll_"&"_collward_"&"_colltype_"&"_colldatef_"-"_colldatet_"&"_collstatus_"&"_collcount_"&"_collpdate_"&"_collptime_"&"_collcdate_"&"_collctime_"&"_colluser_"&"_collcuser_"&"_$g(colltypedesc)_"&"_$g(ctname)
	..;s mPLIST(num)=coll_"&"_collward_"&"_colltype_"&"_colldatef_"-"_colldatet_"&"_collstatus_"&"_collcount_"&"_collpdate_"&"_collptime_"&"_collcdate_"&"_collctime_"&"_colluser_"&"_collcuser
	.;
	q num_"^"_$j
}

ClassMethod GetDispM(n As %Integer) As %String
{
	i +n<1 q ""  				;^TMP($j,"DISPM")  ; if n is null
	i $d(^TMP($j,"DISPM",n)) q ^TMP($j,"DISPM",n)
	q ""
}

ClassMethod GetDispMQ(pid As %String, n As %Integer) As %String
{
	i +n<1 q ^TMP(pid,"DISPMQ")  ; if n is null
	i $d(^TMP(pid,"DISPMQ",n)) q ^TMP(pid,"DISPMQ",n)
	q ""
}

ClassMethod SAVEDATA(itmjs As %Library.String = "", itmjsex As %Library.String = "", phactype As %String, pid As %String, CollectUserRowid As %String) As %String
{
	;  s ^TMP($j,"DISPM")=loc1_"^"_ward1_"^"_datefrom1_"^"_dateto1_"^"_user1
	n (itmjs,itmjsex,phactype,pid,CollectUserRowid)
	s phactype=$g(phactype) 
	s phacdatefrom=$p(^TMP(pid,"DISPM"),"^",3)
	s phacdateto=$p(^TMP(pid,"DISPM"),"^",4)
	s phacward=$p(^TMP(pid,"DISPM"),"^",2)
	s phacloc=$p(^TMP(pid,"DISPM"),"^",1) i phacloc=""  s phacward="*"
	s phacuser=$p(^TMP(pid,"DISPM"),"^",5)
	s phacpdate=+$h
	s phacptime=$p($h,",",2)
	s phacstatus="Print"
	s j=1
	k PLIST
	s PLIST(2)=$g(phacloc)
	s PLIST(5)=$g(phacward)
	s PLIST(6)=$g(phacuser)
	s PLIST(7)=$g(phacstatus)
	s PLIST(8)=$g(phacpdate)
	s PLIST(9)=$g(phacptime)
	s PLIST(11)=$g(phacdatefrom)
	s PLIST(12)=$g(phacdateto)
	s PLIST(13)=$g(phactype)
	&sql(INSERT INTO DHC_PHACollected VALUES :PLIST())
	q:SQLCODE -1
	s phacrowid=$P($g(%ROWID),$c(1))  
	s arcpj="" f  s arcpj=$o(^TMP(pid,"D","ADM",arcpj))  q:arcpj=""  d
	.s arcpjsub="" f  s arcpjsub=$o(^TMP(pid,"D","ADM",arcpj,arcpjsub)) q:arcpjsub=""  d 
	..s stdfid=""  ;-------------------
	..s stdfid=$o(^STDF("OEDI",^TMP(pid,"D","OEDIS",arcpj,arcpjsub),stdfid))
	..i stdfid=""  d  ;--------------
	...i phactype=^TMP(pid,"D","ARCCAT",arcpj,arcpjsub) d        
	....s phaciadm=^TMP(pid,"D","ADM",arcpj,arcpjsub)
	....s phacibed=^TMP(pid,"D","BED",arcpj,arcpjsub)
	....s phacidis=^TMP(pid,"D","OEDIS",arcpj,arcpjsub)
	....;q:(..NonAuditLoc(phacloc)=0)&(##class(web.DHCSTPCHCOLLS2).OrdItmAudited(phacidis)<0) 
	....s cansave=^TMP(pid,"D","SAVE",arcpj,arcpjsub) q:cansave=0
	....
	....s phaciinci=^TMP(pid,"D","INCLBDR",arcpj,arcpjsub)
	....s phacipresc=^TMP(pid,"D","PRESC",arcpj,arcpjsub)
	....s phaciqty=^TMP(pid,"D","QTY",arcpj,arcpjsub)
	....s phaciprice=^TMP(pid,"D","PRICE",arcpj,arcpjsub)
	....s phacistatus=^TMP(pid,"D","OEFLAG",arcpj,arcpjsub)
	....s phaciloc=^TMP(pid,"D","DEPLOC",arcpj,arcpjsub)
	....;q:phacistatus="D"  ;if orditem hase been stop then quit
	....q:##class(web.DHCSTPCHCOLLS2).HaveBeenRefused(phacidis)>0   ; refused can not be saved
	....
	....k PLIST
	....s PLIST(0)=$g(phacrowid)
	....s PLIST(2)=$g(phaciadm)
	....s PLIST(3)=$g(phacipresc)
	....s PLIST(4)=$g(phaciinci)
	....s PLIST(5)=$g(phaciqty)
	....s PLIST(6)=$g(phacidis)
	....s PLIST(7)=j
	....s PLIST(10)=$g(phacibed)
	....s PLIST(11)=$g(phaciprice)
	....s PLIST(12)=$g(phacistatus)
	....s PLIST(13)=$g(phaciloc)
	....TSTART
	....&sql(INSERT INTO DHC_PHACollectItm VALUES PLIST())
	....s ret=SQLCODE
	....i ret'=0 TROLLBACK
	....q:ret
	....s phaci=%ROWID
	....i phaci="" TROLLBACK
	....q:phaci="" 
	....s resultstk=##class(DHCSTPCHCOLLS2).DhcStkTab(phaci) ;handle the dhc tables
	....i resultstk<0 TROLLBACK
	....q:resultstk<0
	....TCOMMIT
	....s j=j+1
	....
	;
	i j-1=0 d
	. &sql(delete from dhc_phacollected where dhc_phacollect_rowid=:phacrowid )
	q:j-1=0 0
	d ..Collect(phacrowid,CollectUserRowid) ;make collect flag
	;
	s result=$g(phacrowid) ;
	;
	s retval=itmjs_"('"_$ZCVT(result,"O","JS")_"');"
	i itmjsex'="""" s retval=retval_itmjsex_"('"_$ZCVT(result,"O","JS")_"');"
	&javascript<#(retval)#>
	;
	q $g(phacrowid)
}

ClassMethod KillTmpAfterSave(itmjs As %Library.String = "", itmjsex As %Library.String = "", pid As %String)
{
	d ..CLEARTMP(pid,"DISPM")	; 
	d ..CLEARTMP(pid,"DISPD")	; 
	d ..CLEARTMP(pid,"D")		; 
	q 0
}

ClassMethod GetGroup(user As %String) As %String
{
	n (user) s user=$g(user) q:user="" 0
	i '$d(^SSU("SSUSR",user)) q 0
	s group=$p(^SSU("SSUSR",user),"^",5)
	q $g(group)
}

ClassMethod HUIZONGPJD() As %Integer
{
	s num=0
	s HUIPHAR="" f  s HUIPHAR=$o(HUIZONGPJ(HUIPHAR)) q:HUIPHAR=""  d
	.s BILLUOM=$p(^ARCIM($p(HUIPHAR,"||",1),$p(HUIPHAR,"||",2),8),"^",14)
	.s BASEUOM=$p(HUIZONGPJ(HUIPHAR),"&",3)
	.s FACTOR=1
	.i BILLUOM'="" d
	..s CFDr="" 
	..s CFDr=$o(^CT("CTCF",0,"UOM",BILLUOM,BASEUOM,""))
	..i CFDr'="" s FACTOR=$p(^CT("CTCF",CFDr),"^",3)
	.s $p(HUIZONGPJ(HUIPHAR),"&",3)=$p(^CT("UOM",BILLUOM),"^",2)
	.s $p(HUIZONGPJ(HUIPHAR),"&",2)=$p(HUIZONGPJ(HUIPHAR),"&",2)/FACTOR
	.s $p(HUIZONGPJ(HUIPHAR),"&",4)=FACTOR*$p(HUIZONGPJ(HUIPHAR),"&",4)
	.s num=num+1
	.s mPLIST(num)=HUIZONGPJ(HUIPHAR)
	q num
}

ClassMethod GetInciCode(arcimdesc As %String) As %String
{
	k code
	s itm=""
	s desc=$$ALPHAUP^SSUTIL4(arcimdesc)
	s itm=$o(^INCI(0,"Desc",desc,"")) q:itm="" ""
	s code=$p(^INCI(itm,1),"^",1)
	q code
}

ClassMethod LocUser(Loc As %String) As %Integer
{
	n user,num       
	k PLIST	s num=0 s user=""
	f  s user=$o(^SSU("SSUSR",user)) q:user=""  d
	.q:$p(^SSU("SSUSR",user),"^",4)'=Loc
	.s num=num+1
	.s PLIST(num)=$p(^SSU("SSUSR",user),"^",2)
	s PLIST=num
	q num
}

ClassMethod GrpUser(grp As %String) As %String
{
	n (grp)	q:grp="" ""
	s grp=+grp,user="",result=""
	f   s user=$o(^SSU("SSUSR",0,"Group",grp,user))  q:user=""  d
	. i result="" d
	. . s result=user
	. e  d
	. . s result=result_"^"_user
	q result
}

ClassMethod GetInternalType(loc As %String) As %String
{
	n (loc)
	s IntType=$p(^CTLOC(loc),"^",13)
	q IntType
}

ClassMethod GetLocDesc(LOC As %String) As %String
{
	n (LOC)	s LocDesc=""
	i LOC'="" s LocDesc=$p(^CTLOC(LOC),"^",1)
	q LocDesc
}

ClassMethod TotalColl(datef As %String, datet As %String, pha As %String, type As %String, stime As %String, etime As %String, inci As %String) As %Integer
{
   n (datef,datet,pha,type,stime,etime,inci)
   d ..ClearColl($j)
   i $g(stime)="" s stime=$zth("00:00:00",3)       ;0
   i $g(etime)="" s etime=$zth("23:59:59",3)       ;86399
   ;i (stime?4N1"-"1(2N,1N)1"-"1(2N,1N)1" "1(2N,1N)1":"1(2N,1N)1":"1(2N,1N)) s stime=$p(stime," ",2)
   ;i (etime?4N1"-"1(2N,1N)1"-"1(2N,1N)1" "1(2N,1N)1":"1(2N,1N)1":"1(2N,1N)) s etime=$p(etime," ",2)
   ;i '(stime?1(2N,1N)1":"1(2N,1N)1":"1(2N,1N)) s stime="00:00:00"
   ;i '(etime?1(2N,1N)1":"1(2N,1N)1":"1(2N,1N)) s etime="23:59:59" 
   ;s stime=$ZTH(stime,3)
   ;s etime=$ZTH(etime,3)
   s i=0
   ;
   f date=datef:1:datet d
   .s phccid="" 
   .f  s phccid=$o(^DHCPHAC(0,"PHA",pha,"DATE",date,phccid)) q:phccid=""  d
   ..q:(type'="")&&($p(^DHCPHAC(phccid),"^",12)'=type)
   ..s time=$p(^DHCPHAC(phccid),"^",3)
   ..i (date=datef)&(time<stime) q
   ..i (date=datet)&(time>etime) q
   ..s phccitm=""
   ..f  s phccitm=$o(^DHCPHAC(phccid,"I",phccitm)) q:phccitm=""  d
   ...s phcipriorty=..GetOrderPriorty(phccid_"||"_phccitm)
   ...;i phcipriorty="PRN" q  ; out-dispensing not included
   ...s phcistatus=$p(^DHCPHAC(phccid,"I",phccitm),"^",10)
   ...i phcistatus="D" q   ; stoped orditem  not included
   ...s phciinci=$p(^DHCPHAC(phccid,"I",phccitm),"^",4) s phciinci=+phciinci ;
   ...q:(inci'="")&(phciinci'=inci)
   ...s phciqty=$p(^DHCPHAC(phccid,"I",phccitm),"^",6)
   ...s phciprice=$p(^DHCPHAC(phccid,"I",phccitm),"^",9)
   ...s phciloc=+$p(^DHCPHAC(phccid,"I",phccitm),"^",11)   ;adm loc
   ...s pakuom=$p(^INCI(phciinci,1),"^",10)
   ...s cost=phciqty*phciprice
   ...s cost=$tr($j(cost,10,2)," ","")
   ...;各种药的总数量和总金额
   ...i $d(^TMP($j,"locsum",phciinci))  d             
        ....s $p(^TMP($j,"locsum",phciinci),"&",1)=$p(^TMP($j,"locsum",phciinci),"&",1)+phciqty
        ....s $p(^TMP($j,"locsum",phciinci),"&",3)=$p(^TMP($j,"locsum",phciinci),"&",3)+cost
   ...e  d
        ....s $p(^TMP($j,"locsum",phciinci),"&",1)=phciqty
        ....s $p(^TMP($j,"locsum",phciinci),"&",3)=cost
        ....s $p(^TMP($j,"locsum",phciinci),"&",4)=pakuom
   ...;各种药在各科室的消耗
   ...i $d(^TMP($j,"locsum2",phciinci,phciloc))  d             
        ....s $p(^TMP($j,"locsum2",phciinci,phciloc),"&",1)=$p(^TMP($j,"locsum2",phciinci,phciloc),"&",1)+phciqty
        ....s $p(^TMP($j,"locsum2",phciinci,phciloc),"&",3)=$p(^TMP($j,"locsum2",phciinci,phciloc),"&",3)+cost
   ...e  d
        ....s $p(^TMP($j,"locsum2",phciinci,phciloc),"&",1)=phciqty
        ....s $p(^TMP($j,"locsum2",phciinci,phciloc),"&",3)=cost
   ...;各科室消耗的各种药
   ...i $d(^TMP($j,"locsum1",phciloc,phciinci))  d             
        ....s $p(^TMP($j,"locsum1",phciloc,phciinci),"&",1)=$p(^TMP($j,"locsum1",phciloc,phciinci),"&",1)+phciqty
        ....s $p(^TMP($j,"locsum1",phciloc,phciinci),"&",3)=$p(^TMP($j,"locsum1",phciloc,phciinci),"&",3)+cost
   ...e  d
        ....s $p(^TMP($j,"locsum1",phciloc,phciinci),"&",1)=phciqty
        ....s $p(^TMP($j,"locsum1",phciloc,phciinci),"&",3)=cost
   ...
   ...s incicode=$p(^INCI(phciinci,1),"^",1)
   ...s incidesc=$p(^INCI(phciinci,1),"^",2)
   ...s admlocid=$p(^DHCPHAC(phccid,"I",phccitm),"^",11)
   ...i admlocid'="" s admloc=$P(^CTLOC(+admlocid),"^",2)
   ...s oedis=$p(^DHCPHAC(phccid,"I",phccitm),"^",7)
   ...s ord=$p(oedis,"||",1),itm=$p(oedis,"||",2)
   ...s doctorid=$P(^OEORD(ord,"I",itm,7),"^",1)
   ...i doctorid'="" s doctor=$P(^SSU("SSUSR",+doctorid),"^",2)
   ...s prescno=$P(^OEORD(ord,"I",itm,1),"^",14)
   ...s adm=$P(^OEORD(ord),"^",1)
   ...s patnameid=$p(^PAADM(adm),"^",1)                                            ;PA_PatMas PAPMI_RowId
   ...s patname=$p(^PAPER(patnameid,"ALL"),"^",1)
   ...s patno=$p(^PAPER(patnameid,"PAT",1),"^",1)
   ...i pakuom'="" s uom=$p(^CT("UOM",+pakuom),"^",2)
   ...s i=i+1
   ...s ^TMP($j,"locsumitm",incicode,admlocid,i)=patno_"^"_patname_"^"_admloc_"^"_$g(doctor)_"^"_prescno_"^"_incicode_"^"_incidesc_"^"_$g(uom)_"^"_phciqty_"^"_$fn($g(phciprice),"",4)_"^"_cost_"^"_$zd(date,4)
   ...
   ..;
   .;
   ;统计退药
   f date=datef:1:datet d
   . s ret="" 
   . f  s ret=$o(^PHARET(0,"RECLOC",pha,date,ret)) q:ret=""  d
   . . s tt=$p(^PHARET(ret),"^",2)
   . . i (date=datef)&(tt<stime) q
   . . i (date=datet)&(tt>etime) q
   . . s inclb=$p(^PHARET(ret),"^",6) q:inclb=""
   . . s rinci=+inclb q:rinci=""
   . . q:(inci'="")&(rinci'=inci)
   . . s pakuom=$p(^INCI(rinci,1),"^",10)
   . . s retqty=+$p(^PHARET(ret),"^",12)
   . . s sprice=$p(^PHARET(ret),"^",13)
   . . s retcost=$p(^PHARET(ret),"^",14)
   . . s retloc=$p(^PHARET(ret),"^",7) q:retloc=""
   . . s retloc=+retloc
   . .;各种药的退药总数量和退药总金额
   . .i $d(^TMP($j,"locsum",rinci))  d             
        ...s $p(^TMP($j,"locsum",rinci),"&",2)=$p(^TMP($j,"locsum",rinci),"&",2)+retqty
        ...s $p(^TMP($j,"locsum",rinci),"&",3)=$p(^TMP($j,"locsum",rinci),"&",3)-retcost
   . .e  d
        ...s $p(^TMP($j,"locsum",rinci),"&",2)=retqty
        ...s $p(^TMP($j,"locsum",rinci),"&",3)=-retcost
        ...s $p(^TMP($j,"locsum",rinci),"&",4)=pakuom
   . .;各种药在各科室的退药
   . .i $d(^TMP($j,"locsum2",rinci,retloc))  d             
        ...s $p(^TMP($j,"locsum2",rinci,retloc),"&",2)=$p(^TMP($j,"locsum2",rinci,retloc),"&",2)+retqty
        ...s $p(^TMP($j,"locsum2",rinci,retloc),"&",3)=$p(^TMP($j,"locsum2",rinci,retloc),"&",3)-retcost
   . .e  d
        ...s $p(^TMP($j,"locsum2",rinci,retloc),"&",2)=retqty
        ...s $p(^TMP($j,"locsum2",rinci,retloc),"&",3)=-retcost
   . .;各科室退药的各种药
   . .i $d(^TMP($j,"locsum1",retloc,rinci))  d             
        ...s $p(^TMP($j,"locsum1",retloc,rinci),"&",2)=$p(^TMP($j,"locsum1",retloc,rinci),"&",2)+retqty
        ...s $p(^TMP($j,"locsum1",retloc,rinci),"&",3)=$p(^TMP($j,"locsum1",retloc,rinci),"&",3)-retcost
   . .e  d
        ...s $p(^TMP($j,"locsum1",retloc,rinci),"&",2)=retqty
        ...s $p(^TMP($j,"locsum1",retloc,rinci),"&",3)=-retcost
   . .
   . . s incicode=$p(^INCI(rinci,1),"^",1)
   . . s incidesc=$p(^INCI(rinci,1),"^",2)
   . . s admlocid=+retloc
   . . i admlocid'="" s admloc=$P(^CTLOC(+admlocid),"^",2)
   . . s oedis=$p(^PHARET(ret),"^",5)
   . . s ord=$p(oedis,"||",1),itm=$p(oedis,"||",2)
   . . s doctorid=$P(^OEORD(ord,"I",itm,7),"^",1)
   . . i doctorid'="" s doctor=$P(^SSU("SSUSR",+doctorid),"^",2)
   . . s prescno=$P(^OEORD(ord,"I",itm,1),"^",14)
   . . s adm=$P(^OEORD(ord),"^",1)
   . . s patnameid=$p(^PAADM(adm),"^",1)                                            ;PA_PatMas PAPMI_RowId
   . . s patname=$p(^PAPER(patnameid,"ALL"),"^",1)
   . . s patno=$p(^PAPER(patnameid,"PAT",1),"^",1)
   . . i pakuom'="" s uom=$p(^CT("UOM",+pakuom),"^",2)
   . . s i=i+1
   . . s ^TMP($j,"locsumitm",incicode,admlocid,i)=patno_"^"_patname_"^"_admloc_"^"_$g(doctor)_"^"_prescno_"^"_incicode_"^"_incidesc_"^"_$g(uom)_"^"_-retqty_"^"_$fn($g(sprice),"",4)_"^"_-retcost_"^"_$zd(date,4)
   . .
   .;
   q $j
}

ClassMethod PopulateLocs(processno) As %String
{
 	n loc,result  
	s loc="",result=""
 	f  s loc=$o(^TMP(processno,"locsum1",loc)) q:loc=""  d 
 	 .s locdesc=$p(^CTLOC(loc),"^",2) 
 	 .s tmp=loc_"#"_locdesc
 	 .i result="" d
 	 . . s result=tmp
 	 . e  d
 	 . . s result=result_"^"_tmp
	s tmp="0"_"#"_"总计"
	s result=result_"^"_tmp
	q $g(result)
}

ClassMethod AdmLocDisp(processid As %String, dept As %String) As %Integer
{
	n (processid,dept) 
	s num=0
	s subtotal=0
	;总计     
	i dept=0 d
	 .s inci=""
	 .f  s inci=$o(^TMP(processid,"locsum",inci)) q:inci=""  d
	 ..s inciname=$p(^INCI(inci,1),"^",2)
	 ..s incicode=$p(^INCI(inci,1),"^",1)
	 ..s uomname=$p(^CT("UOM",$p(^TMP(processid,"locsum",inci),"&",4)),"^",2)
	 ..s dispqty=$p(^TMP(processid,"locsum",inci),"&",1)
	 ..s retqty=$p(^TMP(processid,"locsum",inci),"&",2) 
	 ..s subsum=+dispqty-(+retqty)
	 ..s amt=$p(^TMP(processid,"locsum",inci),"&",3)
	 ..s num=num+1
	 ..s ^TMP(processid,"ADMLOCDISP",num)=inciname_"&"_$g(dispqty)_"&"_$g(retqty)_"&"_$g(subsum)_"&"_$g(uomname)_"&"_$g(amt)_"&"_$g(incicode)
	 ..s subtotal=subtotal+$p(^TMP(processid,"locsum",inci),"&",3)
	 .;
	;某一科室
	i dept>0 d
	 .s inci=""
	 .f  s inci=$o(^TMP(processid,"locsum1",dept,inci)) q:inci=""  d
	 ..s inciname=$p(^INCI(inci,1),"^",2)
	 ..s incicode=$p(^INCI(inci,1),"^",1)
	 ..s uomname=$p(^CT("UOM",$p(^TMP(processid,"locsum",inci),"&",4)),"^",2)
	 ..s dispqty=$p(^TMP(processid,"locsum1",dept,inci),"&",1)
	 ..s retqty=$p(^TMP(processid,"locsum1",dept,inci),"&",2) 
	 ..s subsum=+dispqty-(+retqty)
	 ..;s subtotal=subtotal+$p(^TMP(processid,"locsum1",dept,inci),"&",3)
	 ..s amt=$p(^TMP(processid,"locsum1",dept,inci),"&",3)
	 ..s num=num+1
	 ..s ^TMP(processid,"ADMLOCDISP",num)=inciname_"&"_dispqty_"&"_retqty_"&"_subsum_"&"_$g(uomname)_"&"_$g(amt)_"&"_$g(incicode) 
	 ..s subtotal=subtotal+$p(^TMP(processid,"locsum1",dept,inci),"&",3)
	;s P9=num
	;s P8=subtotal
	s num=num+1
	s ^TMP(processid,"ADMLOCDISP",num)="总计:"_"&&&&&"_subtotal_"&"_"" 
	q num
}

ClassMethod ListAdmLocDisp(processid As %String, n As %Integer) As %String
{
	i $d(^TMP(processid,"ADMLOCDISP",n)) q ^TMP(processid,"ADMLOCDISP",n)
	q ""
}

ClassMethod ClearColl(processid As %String) As %String
{
	q:processid="" 0
	k ^TMP(processid,"ADMLOCDISP")
	k ^TMP(processid,"locsum1")
	k ^TMP(processid,"locsum2")
	k ^TMP(processid,"locsum")
	k ^TMP(processid,"locsumitm")
	
	q 0
}

ClassMethod KillCollTmpGlobal(itmjs As %Library.String = "", itmjsex As %Library.String = "", pid As %String) As %String
{
	d ..ClearColl(pid)
	q ""
}

ClassMethod getpha(loc As %String) As %String
{
	n (loc)   i loc'="" d
	. s loc=$p(^CTLOC(loc),"^",2)
	i loc["-" s loc=$p(loc,"-",2)         
	q loc
}

ClassMethod TotalCollCYDY(datef As %String, datet As %String, pha As %String, type As %String, stime As %String, etime As %String) As %Integer
{
   s datef=$ZDH(datef,3)
   s datet=$ZDH(datet,3)
   i $g(stime)="" s stime="00:00:00"       ;0
   i $g(etime)="" s etime="23:59:59"       ;86399
   i (stime?4N1"-"1(2N,1N)1"-"1(2N,1N)1" "1(2N,1N)1":"1(2N,1N)1":"1(2N,1N)) s stime=$p(stime," ",2)
   i (etime?4N1"-"1(2N,1N)1"-"1(2N,1N)1" "1(2N,1N)1":"1(2N,1N)1":"1(2N,1N)) s etime=$p(etime," ",2)       
   i '(stime?1(2N,1N)1":"1(2N,1N)1":"1(2N,1N)) s stime="00:00:00"
   i '(etime?1(2N,1N)1":"1(2N,1N)1":"1(2N,1N)) s etime="23:59:59"                             
   s stime=$ZTH(stime,3)
   s etime=$ZTH(etime,3)
   f date=datef:1:datet d
   .s phccid="" f  s phccid=$o(^DHCPHAC(0,"PHA",pha,"DATE",date,phccid)) q:phccid=""  d        
   ..s time=$p(^DHCPHAC(phccid),"^",3)
   ..i (date=datef)&(time<stime) q
   ..i (date=datet)&(time>etime) q
   ..s phccitm="" f  s phccitm=$o(^DHCPHAC(phccid,"I",phccitm)) q:phccitm=""  d
   ...s phcipriorty=..GetOrderPriorty(phccid_"||"_phccitm)
   ...i phcipriorty'="PRN" q
   ...s phcistatus=$p(^DHCPHAC(phccid,"I",phccitm),"^",10)
   ...i phcistatus="D" q        
   ...s phciinci=$p(^DHCPHAC(phccid,"I",phccitm),"^",4) s phciinci=$p(phciinci,"||",1)
   ...s phciqty=$p(^DHCPHAC(phccid,"I",phccitm),"^",6)
   ...s phciprice=$j($p(^DHCPHAC(phccid,"I",phccitm),"^",9)," ",2)
   ...s phciloc=$p(^DHCPHAC(phccid,"I",phccitm),"^",11)
   ...s pakuom=$p(^INCI(phciinci,1),"^",10)
   ...s cost=phciqty*phciprice
   ...s cost=$tr($j(cost,10,2)," ","")
   ...;各种药的总数量和总金额
   ...i $d(locsum(phciinci))  d             
        ....s $p(locsum(phciinci),"&",1)=$p(locsum(phciinci),"&",1)+phciqty
        ....s $p(locsum(phciinci),"&",3)=$p(locsum(phciinci),"&",3)+cost
   ...i '$d(locsum(phciinci))  d
        ....s $p(locsum(phciinci),"&",1)=phciqty
        ....s $p(locsum(phciinci),"&",3)=cost
        ....s $p(locsum(phciinci),"&",4)=pakuom
   ...;各种药在各科室的消耗
   ...i $d(locsum(phciinci,phciloc))  d             
        ....s $p(locsum(phciinci,phciloc),"&",1)=$p(locsum(phciinci,phciloc),"&",1)+phciqty
        ....s $p(locsum(phciinci,phciloc),"&",3)=$p(locsum(phciinci,phciloc),"&",3)+cost
   ...i '$d(locsum(phciinci,phciloc))  d
        ....s $p(locsum(phciinci,phciloc),"&",1)=phciqty
        ....s $p(locsum(phciinci,phciloc),"&",3)=cost
   ...;各科室消耗的各种药
   ...i $d(locsum1(phciloc,phciinci))  d             
        ....s $p(locsum1(phciloc,phciinci),"&",1)=$p(locsum1(phciloc,phciinci),"&",1)+phciqty
        ....s $p(locsum1(phciloc,phciinci),"&",3)=$p(locsum1(phciloc,phciinci),"&",3)+cost
   ...i '$d(locsum1(phciloc,phciinci))  d
        ....s $p(locsum1(phciloc,phciinci),"&",1)=phciqty
        ....s $p(locsum1(phciloc,phciinci),"&",3)=cost
   ...;
   ..;
   .;
   ;统计退药 FROM IN_TRANS WHERE INTR_TYPE="Y"
   f date=datef:1:datet d
   .s retdr="" f  s retdr=$o(^INTR(0,"TypeDate","Y",date,retdr)) q:retdr=""  d
   ..s time=$p(^INTR(retdr),"^",3)
   ..i (date=datef)&(time<stime) q
   ..i (date=datet)&(time>etime) q
   ..s retpt=$p(^INTR(retdr),"^",9)
   ..s rord=$p(retpt,"||",1),rchl=$p(retpt,"||",2),rexe=$p(retpt,"||",3),rdis=$p(retpt,"||",4)
   ..s retinclb=$p(^INTR(retdr),"^",7)
   ..s rinci=$p(retinclb,"||",1),rincil=$p(retinclb,"||",2),rinclb=$p(retinclb,"||",3)
   ..s pakuom=$p(^INCI(rinci,1),"^",10)
   ..s retqty=$p(^INTR(retdr),"^",6)
   ..i '$d(^OEORD(rord,"I",rchl)) q
   ..s retrecloc=$p(^OEORD(rord,"I",rchl,3),"^",6)
   ..s retreason=$p(^OEORD(rord,"I",rchl,3),"^",30)
   ..q:retrecloc'=pha                                      ;药房
   ..q:retreason="7"!(retreason="")                        ;退药为系统恢复库存---退药原因为 "未发药先停"
   ..;s retloc=$p(^OEORD(rord,"I",rchl,1),"^",3)  ;OEORI_OrdDept_DR
   ..s retarcim=$p(^OEORD(rord,"I",rchl,1),"^",2) ;OEORI_ItmMast_DR
   ..s retsttdate=$p(^OEORD(rord,"I",rchl,1),"^",9)  ;OEORI_SttDat
   ..s rettype=$p(^ARCIM($p(retarcim,"||",1),$p(retarcim,"||",2),1),"^",10)
   ..s priority=$p($g(^OECPR($p($g(^OEORD(rord,"I",rchl,1)),"^",8))),"^",1)
   ..i priority'="PRN" q
   ..;s rettypecode=$p(^ARC("IC",rettype),"^",1)
   ..;i type'=$$GetCat(rettypecode) q                                             ;药品类别
   ..s retincib=$p(^INCI(rinci,"IL",rincil,"LB",rinclb),"^",1)
   ..s retcost=retqty*(..getprice(rinci,retsttdate))
   ..s retcost=$tr($j(retcost,10,2)," ","")
   ..;&sql(select phaci_admloc_dr into :loc from dhc_phacollectitm  where phaci_phac_parref=:rord)
   ..s retloc=$$getloc2^DHCSTBTSTRIPPRINT(retpt) ;$$getloc^DHCSTBTSTRIPPRINT(retpt)
   ..i retloc="" q
   ..;i retloc="" s retloc=$p(^OEORD(rord,"I",rchl,1),"^",3)  ;OEORI_OrdDept_DR 9,2
   ..;各种药的退药总数量和退药总金额
   ..i $d(locsum(rinci))  d             
        ...s $p(locsum(rinci),"&",2)=$p(locsum(rinci),"&",2)+retqty
        ...s $p(locsum(rinci),"&",3)=$p(locsum(rinci),"&",3)-retcost
   ..i '$d(locsum(rinci))  d
        ...s $p(locsum(rinci),"&",2)=retqty
        ...s $p(locsum(rinci),"&",3)=-retcost
        ...s $p(locsum(rinci),"&",4)=pakuom
   ..;各种药在各科室的退药
   ..i $d(locsum(rinci,retloc))  d             
        ...s $p(locsum(rinci,retloc),"&",2)=$p(locsum(rinci,retloc),"&",2)+retqty
        ...s $p(locsum(rinci,retloc),"&",3)=$p(locsum(rinci,retloc),"&",3)-retcost
   ..i '$d(locsum(rinci,retloc))  d
        ...s $p(locsum(rinci,retloc),"&",2)=retqty
        ...s $p(locsum(rinci,retloc),"&",3)=-retcost
   ..;各科室退药的各种药
   ..;&sql(select phaci_admloc_dr into :a1 from dhc_phacollectitm where phaci_oedis_dr=:retpt)
   ..i $d(locsum1(retloc,rinci))  d             
        ...s $p(locsum1(retloc,rinci),"&",2)=$p(locsum1(retloc,rinci),"&",2)+retqty ;retloc-->loc2
        ...s $p(locsum1(retloc,rinci),"&",3)=$p(locsum1(retloc,rinci),"&",3)-retcost
   ..i '$d(locsum1(retloc,rinci))  d
        ...s $p(locsum1(retloc,rinci),"&",2)=retqty
        ...s $p(locsum1(retloc,rinci),"&",3)=-retcost
   ..;
   .;
   q 0
}

ClassMethod GetOrderPriorty(phaci As %String) As %String
{
	n (phaci)
	s pha=+phaci,ch=$p(phaci,"||",2)
	s oedis=$p(^DHCPHAC(pha,"I",ch),"^",7)
	s oe=+oedis,itm=$p(oedis,"||",2)
	q:oe="" ""
	q:itm="" ""
	s priority=$p(^OEORD(oe,"I",itm,1),"^",8)
	q:priority="" ""
	s priority=$p(^OECPR(priority),"^",1)
    q $p(priority,$c(1))
}

ClassMethod GetDispType(itmjs As %Library.String = "", itmjsex As %Library.String = "", phacrowid As %String) As %String
{
	n (phacrowid)
	&sql(select dhc_phaordtype into :disptype from dhc_phacollected
		where dhc_phacollect_rowid=:phacrowid)
	q $g(disptype)
}

ClassMethod CollectDrugClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = CollectDrugExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod CollectDrugExecute(ByRef qHandle As %Binary, displocrowid As %String, wardrowid As %String, StartDate As %String, EndDate As %String, Userid As %String, ByWardFlag As %String, LongOrdFlag As %String, ShortOrdFlag As %String, OutWithDrugFlag As %String, DispCat As %String, Adm As %String, DoctorLocRowid As %String, NotAudit As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	;
 	q:displocrowid="" $$$OK
 	q:StartDate="" $$$OK
 	q:EndDate="" $$$OK
	//实现；
    i NotAudit="on" s NotAudit=1
    e  s NotAudit=0
	Do ResetVariables
	i Adm="" d  // 按病区发药
	. s PID=..PCHCOLLS(displocrowid,wardrowid,StartDate,EndDate,Userid,ByWardFlag,LongOrdFlag,ShortOrdFlag,OutWithDrugFlag,DispCat,DoctorLocRowid,NotAudit)
	e  d  //按病人发药
	. s PID=..PCHCOLLADM(displocrowid,Adm,StartDate,EndDate,Userid,ByWardFlag,LongOrdFlag,ShortOrdFlag,OutWithDrugFlag,DispCat,NotAudit)
	q:PID="" $$$OK    // no Process ID returned
	s i=1
	f  s type=$p(DispCat,"^",i)  q:type=""  d
	. s rowcnt=..GETDATA1(type,PID)
	. f n=1:1:rowcnt  d
	. . s dispitm=..GetDispD(n,PID)
	. . Do OutputRow
	. s i=i+1
	
	Quit $$$OK
OutputRow
	s issutype=$p(dispitm,"&",18)
	s admloc=$p(dispitm,"&",1) 
	s bedno=$p(dispitm,"&",2)
	s paname=$p(dispitm,"&",3)
	s registerno=$p(dispitm,"&",4)
	s arcimdesc=$p(dispitm,"&",5)
	s qty=$p(dispitm,"&",6)
	s uom=$p(dispitm,"&",7)
	s sp=$p(dispitm,"&",8)
	s sp=$fn(sp,"",2)
	s ordstatus=$p(dispitm,"&",9)
	s phatype=$p(dispitm,"&",10)
	s dosage=$p(dispitm,"&",11)
	s freq=$p(dispitm,"&",12)
	s instr=$p(dispitm,"&",13)
	s duration=$p(dispitm,"&",14)
	s prescno=$p(dispitm,"&",15)
	s batno =$p(dispitm,"&",16)
	s ordis =$p(dispitm,"&",17)
	s audited=$p(dispitm,"&",19)
	i audited<0 s audited="N"
	e  s audited="Y"
	set Data=$lb(PID,issutype,admloc,bedno,paname,registerno,arcimdesc,qty,uom,sp,ordstatus,phatype,dosage,freq,instr,duration,prescno,batno,ordis,audited)
 	Set ^CacheTemp(repid,ind)=Data	
 	Set ind=ind+1
	quit
ResetVariables
	set (PID,issutype,admloc,bedno,paname,registerno,arcimdesc,qty,uom,sp,ordstatus,phatype,dosage,freq,instr,duration,prescno,batno,ordis,audited)=""
	quit
}

ClassMethod CollectDrugFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = CollectDrugExecute ]
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

Query CollectDrug(displocrowid As %String, wardrowid As %String, StartDate As %String, EndDate As %String, Userid As %String, ByWardFlag As %String, LongOrdFlag As %String, ShortOrdFlag As %String, OutWithDrugFlag As %String, DispCat As %String, Adm As %String, DoctorLocRowid As %String, NotAudit As %String) As %Query(ROWSPEC = "TPID:%String,TInsuType:%String,TAdmLoc:%String,TBedNo:%String,TPaName:%String,TRegNo:%String,TDesc:%String,TQty:%String,TUom:%String,TSalePrice:%String,TOrdStatus:%String,TPhaCat:%String,TDoseQty:%String,TFreq:%String,TInstruction:%String,TDuration:%String,TPrescNo:%String,TBatchNo:%String,Toedis:%String,TAudited:%String")
{
}

ClassMethod DispListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = DispListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod DispListExecute(ByRef qHandle As %Binary, StartDate As %String, EndDate As %String, displocrowid As %String, wardrowid As %String, Userid As %String, dispcatvalue As %String, StartTime As %String, EndTime As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	;
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
	//实现；
	q:$g(displocrowid)="" $$$OK
	q:$g(StartDate)="" $$$OK
	q:$g(EndDate)="" $$$OK
	;Do ResetVariables1
	;s (StartDate,EndDate,displocrowid,wardrowid,Userid,DispCat)=""
	;w StartDate
	;w EndDate
	;s StartDate="60068"
	;s EndDate="60118"
	;s displocrowid=98
	s tmp=..GetColl(StartDate,EndDate,displocrowid,wardrowid,Userid,dispcatvalue,StartTime,EndTime)
	s cnt=$p(tmp,"^",1)
	s pid=$p(tmp,"^",2)
	s i=1
	f i=1:1:cnt   d
	. s dispm=..GetDispMQ(pid,i)
	. q:dispm=""
	. d OutputRow1
 	k ^TMP(pid,"DISPMQ")
 	Set qHandle=$lb(0,repid,0)
	q $$$OK
OutputRow1
	s coll=$p(dispm,"&",1)
	s collward=$p(dispm,"&",2)
	s colltype=$p(dispm,"&",3)
	s colldatescope=$p(dispm,"&",4)
	s collstatus=$p(dispm,"&",5)
	s collcount=$p(dispm,"&",6)
	s collpdate=$p(dispm,"&",7)
	s collptime=$p(dispm,"&",8)
	s collcdate=$p(dispm,"&",9)
	s collctime=$p(dispm,"&",10)
	s colluser=$p(dispm,"&",11)
	s collcuser=$p(dispm,"&",12)
	s colltypedesc=$p(dispm,"&",13)
	s ctname=$p(dispm,"&",14)
	i collward="" s collward=$p(dispm,"&",14)
	;coll,TWard,TDispCat,TDateScope,TStatus,TPrintDate,TPrintTIme,TCollectDate,TCollectTime,TOperUser"	
 	s Data=$lb(coll,collward,colltype,colldatescope,collstatus,collpdate,collptime,collcdate,collctime,colluser,collcuser,colltypedesc)
 	s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
	
ResetVariables1
	q
}

ClassMethod DispListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = DispListExecute ]
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

Query DispList(StartDate As %String, EndDate As %String, displocrowid As %String, wardrowid As %String, Userid As %String, dispcatvalue As %String, StartTime As %String, EndTime As %String) As %Query(ROWSPEC = "Tcoll:%String,TWard:%String,TDispCat:%String,TDateScope:%String,TStatus:%String,TPrintDate:%String,TPrintTime:%String,TCollectDate:%String,TCollectTime:%String,TOperUser:%String,TCollectUser:%String,TDispCatDesc:%String")
{
}

ClassMethod DispStatClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = DispStatExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod DispStatExecute(ByRef qHandle As %Binary, StartDate As %String, EndDate As %String, displocrowid As %String, dispcatval As %String, StartTime As %String, EndTime As %String, incirowid As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	;
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	i StartDate="" s qHandle=$lb(0,repid,0) q $$$OK
 	i EndDate="" s qHandle=$lb(0,repid,0) q $$$OK
 	i displocrowid="" s qHandle=$lb(0,repid,0) q $$$OK
	//实现；
	s ^TMP("XXXX",1)=incirowid
	s pno= ..TotalColl(StartDate,EndDate,displocrowid,dispcatval,StartTime,EndTime,incirowid)
	s admlocs=..PopulateLocs(pno)
	s i=1 
	f  s admloc=$p(admlocs,"^",i)  q:admloc=""  d
	. d OutputRow2
	. s i=i+1
	
	s qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow2

	s locrowid=$p(admloc,"#",1)
	s locdesc=$p(admloc,"#",2)
 	s Data=$lb(pno,locrowid,locdesc)
 	s ^CacheTemp(repid,ind)=Data	
 	s ind=ind+1
	q
}

ClassMethod DispStatFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = DispStatExecute ]
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

Query DispStat(StartDate As %String, EndDate As %String, displocrowid As %String, dispcatval As %String, StartTime As %String, EndTime As %String, incirowid As %String) As %Query(ROWSPEC = "ProcessID:%String,AdmLocRowid:%String,AdmLocDesc:%String")
{
}

ClassMethod DispOperUserClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = DispOperUserExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod DispOperUserFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = DispOperUserExecute ]
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

ClassMethod DispOperUserExecute(ByRef qHandle As %Binary, Grpid As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	;
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
	//实现；
	d ResetVariables3
	s result=..GrpUser(Grpid)
	s i=1
	f  s userid=$p(result,"^",i) q:userid=""  d
	. s i=i+1
	. q:'$d(^SSU("SSUSR",userid))
	. s username=$p(^SSU("SSUSR",userid),"^",2)
	. d OutputRow3
	. 
	. 
	Quit $$$OK
OutputRow3
 	s Data=$lb(username,userid )
 	s ^CacheTemp(repid,ind)=Data	
 	s ind=ind+1
	q
ResetVariables3
	s (userid,username)=""
	q
}

Query DispOperUser(Grpid As %String) As %Query(ROWSPEC = "username:%String,userid:%String")
{
}

ClassMethod DispDetailClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = DispDetailExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod DispDetailExecute(ByRef qHandle As %Binary, coll As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	;
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	q:coll="" $$$OK
	//实现；
	d ResetVariables4
	s cnt=..GETDATA(coll)
	f i=1:1:cnt d
	. s detail=..GetDispDQ(i)
	. d OutputRow4
	. 
	d ..CLEARTMP($j,"DISPDQ") ;clear the temp global 
	Quit $$$OK
OutputRow4
	s TInsuType=$p(detail,"&",1)
	s TAdmLoc=$p(detail,"&",2)
	s TBedNo=$p(detail,"&",3)
	s TPaName=$p(detail,"&",4)
	s TRegNo=$p(detail,"&",5)
	
	s TOrdItemDesc=$p(detail,"&",6)
	s TQty=$p(detail,"&",7)
	s TSalePrice=$p(detail,"&",8)
	s TStatus=$p(detail,"&",9)
	s TDispCat=$p(detail,"&",10)
	s TDoseQty=$p(detail,"&",11)
	s TFreq=$p(detail,"&",12)
	s TInstruction=$p(detail,"&",13)
	s TDuration=$p(detail,"&",14)
	s TPrescno=$p(detail,"&",15)
	s TBatchNo=$p(detail,"&",16)
	
 	s Data=$lb(TInsuType,TAdmLoc,TBedNo,TPaName,TRegNo,TOrdItemDesc,TQty,TSalePrice,TStatus,TDispCat,TDoseQty,TFreq,TInstruction,TDuration,TPrescno,TBatchNo)
 	s ^CacheTemp(repid,ind)=Data	
 	s ind=ind+1
	q
ResetVariables4
	s (TInsuType,TAdmLoc,TBedNo,TPaName,TRegNo,TOrdItemDesc,TQty,TSalePrice,TStatus,TDispCat,TDoseQty,TFreq,TInstruction,TDuration,TPrescno,TBatchNo)=""
	q
}

ClassMethod DispDetailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = DispDetailExecute ]
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

Query DispDetail(coll As %String) As %Query(ROWSPEC = "TInsuType:%String,TAdmLoc:%String,TBedNo:%String,TPaName:%String,TRegNo:%String,TOrdItemDesc:%String,TQty:%String,TSalePrice:%String,TStatus:%String,TDispCat:%String,TDoseQty:%String,TFreq:%String,TInstruction:%String,TDuration:%String,TPrescno:%String,TBatchNo:%String")
{
}

ClassMethod DispStatItmClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = DispStatExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod DispStatItmExecute(ByRef qHandle As %Binary, ProcessID As %String, AdmLocRowid As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	;
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
	//实现；
	i ProcessID=""  Set qHandle=$lb(0,repid,0) q $$$OK
	i AdmLocRowid=""  Set qHandle=$lb(0,repid,0) q $$$OK
	;
	s cnt=..AdmLocDisp(ProcessID,AdmLocRowid) q:cnt<1 $$$OK
	f i=1:1:cnt d
	. s dispitm=..ListAdmLocDisp(ProcessID,i)
	. d OutputDispStatItm
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputDispStatItm
	s DispItmDesc=$p(dispitm,"&",1)	
	s DispQty=$p(dispitm,"&",2)	
	s RetQty=$p(dispitm,"&",3)	
	s Total=$p(dispitm,"&",4)	
	s Uom=$p(dispitm,"&",5)	
	s Amount=$p(dispitm,"&",6)	
	s DispItmCode=$p(dispitm,"&",7)
	;
	s PID=ProcessID
	;	
 	s Data=$lb(DispItmDesc,DispQty,RetQty,Total,Uom,Amount,PID,DispItmCode,AdmLocRowid)
 	s ^CacheTemp(repid,ind)=Data	
 	s ind=ind+1
	q
}

ClassMethod DispStatItmFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = DispStatExecute ]
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

Query DispStatItm(ProcessID As %String, AdmLocRowid As %String) As %Query(ROWSPEC = "DispItmDesc:%String,DispQty:%String,RetQty:%String,Total:%String,Uom:%String,Amount:%String,PID:%String,DispItmCode:%String,AdmLocID:%String")
{
}

ClassMethod DocLocRowid(user As %String) As %String
{
	n (user)
	q:user="" ""
	s defaultloc=$p(^SSU("SSUSR",+user),"^",4)
	q defaultloc
}

Query DispStatItmDet(PID As %String, INCI As %String, AdmLocId As %String) As %Query(ROWSPEC = "TRegNo:%String,TName:%String,TAdmLoc:%String,TDoctor:%String,TPrescNo:%String,TCode:%String,TDesc:%String,TUom:%String,TQty:%String,TSp:%String,TAmt:%String,TDispDate:%String")
{
}

ClassMethod DispStatItmDetExecute(ByRef qHandle As %Binary, PID As %String, INCI As %String, AdmLocId As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	;
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
	//实现；
	q:PID="" $$$OK
	q:INCI="" $$$OK
	;s ^TMP("XXXX",1)=AdmLocId
	i AdmLocId>0 d 
	.; s ^TMP("XXXX",2)=INCI
	. s n=""
	. f  s n=$o(^TMP($j,"locsumitm",INCI,AdmLocId,n)) q:n=""  d
	. . s sdata=^(n)
	. . d OutputDispStatItmDet
	. . 
	e  d
	. s AdmLocId=""
	. f  s AdmLocId=$o(^TMP($j,"locsumitm",INCI,AdmLocId))  q:AdmLocId=""  d
	. . ;k ^TMP("YYYY",1)
	. . ;s ^TMP("YYYY",1)=$g(^TMP("YYYY",1))_"%"_AdmLocId
	. . s n=""
	. . f  s n=$o(^TMP($j,"locsumitm",INCI,AdmLocId,n)) q:n=""  d
	. . . s sdata=^(n)
	. . . d OutputDispStatItmDet
	. . . 
	.
	Quit $$$OK

OutputDispStatItmDet
	s TRegNo=$p(sdata,"^",1)
	s TName=$p(sdata,"^",2)
	s TAdmLoc=$p(sdata,"^",3)
	s TDoctor=$p(sdata,"^",4)
	s TPrescNo=$p(sdata,"^",5)
	s TCode=$p(sdata,"^",6)
	s TDesc=$p(sdata,"^",7)
	s TUom=$p(sdata,"^",8)
	s TQty=$p(sdata,"^",9)
	s TSp=$p(sdata,"^",10)
	s TAmt=$p(sdata,"^",11)
	s TDispDate=$p(sdata,"^",12)
 	s Data=$lb(TRegNo,TName,TAdmLoc,TDoctor,TPrescNo,TCode,TDesc,TUom,TQty,TSp,TAmt,TDispDate)
 	s ^CacheTemp(repid,ind)=Data	
 	s ind=ind+1
	q
}

ClassMethod DispStatItmDetFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = DispStatItmDetExecute ]
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

ClassMethod DispStatItmDetClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = DispStatItmDetExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod DispCatDesc(catcode As %String) As %String
{
	 &sql( select sdg_desc into :aa from dhcstkdruggroup where sdg_code=:catcode) 
	 q $g(aa)
}

ClassMethod NonAuditLoc(phalocdr As %String) As %String
{
	n (phalocdr)
	s ddd=$lb(537,468)    ;无需审核的发药科室列表
	q:$lf(ddd,phalocdr)>0 1 
	q 0
}

ClassMethod NonAuditDoctorLoc(docloc As %String) As %String
{
	n (docloc)
	s ddd=$lb(309,308)    ;无需审核的医生科室列表
	q:$lf(ddd,docloc)>0 1 
	q 0
}

}
