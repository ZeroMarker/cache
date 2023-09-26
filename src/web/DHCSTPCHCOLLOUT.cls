Import Sqluser

Class web.DHCSTPCHCOLLOUT Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

ClassMethod CreateOutDrugRecords(phaloc As %String, user As %String, phacs As %String) As %String
{
	s jj=$I(^DHCSTPHARMACY("OUTDRUG"))
	;
	k ^TMP(jj,"CreateOutDrug")
	s cnt=$l(phacs,"^")
	s k=0
	s allout=""
	f i=1:1:cnt d
	.s phac=$p(phacs,"^",i)
	.s ch=0 
	.f  s ch=$o(^DHCPHAC(phac,"I",ch)) q:ch=""  d
	. . s adm=$p(^(ch),"^",3)
	. . s phaci=phac_"||"_ch
	. . s k=k+1
	. . s ^TMP(jj,"CreateOutDrug",phaloc,adm,phaci,k)=phaci
	s tmpadm=""
	s adm="" 
    s phacid=""
	s err=0
	tstart
   f  s adm=$o(^TMP(jj,"CreateOutDrug",phaloc,adm)) q:(adm="")!(err<0)  d
   .s outdrug=..InsertOutDrug(phaloc,adm,user)
   .i (outdrug<0) d
   .. s err=-1
   .. trollback
   .q:err<0
   .
   .i allout="" d
   ..s allout=outdrug
   .e  d
   ..s allout=allout_"^"_outdrug
   .q:err<0
   .s phacid=""
   .f  s phacid=$o(^TMP(jj,"CreateOutDrug",phaloc,adm,phacid)) q:(phacid="")!(err<0)  d
   ..s outdrugdet=..InsertOutDrugDetail(outdrug,phacid)
   ..i (outdrugdet<0) d
   ...s err=-2
   ...trollback
   ..q:err<0
   .q:err<0
	q:err<0 ""
	tcommit
	k ^TMP(jj,"CreateOutDrug")
	q allout
}

ClassMethod InsertOutDrug(phaloc As %String, adm As %String, user As %String) As %String
{
 s dd=+$h
 s tt=$p($h,",",2)
 s ward=$p(^PAADM(adm),"^",70)
 &sql(insert into DHC_PhaCollectOutDrug(pcod_phaloc_dr,pcod_ward_dr,pcod_adm_dr,pcod_date,pcod_time,pcod_ssusr_dr)
  values (:phaloc,:ward,:adm,:dd,:tt,:user))
 q:SQLCODE -1
 s main=%ROWID
 q:main="" -1
 q main
}

ClassMethod InsertOutDrugDetail(main As %String, Phaci As %String) As %String
{
	q:main="" -1
	q:Phaci="" -2
	s ch=$o(^DHCPCOD(main,"L",""),-1)+1
	&sql(insert into DHC_PhaCollectOutDrugDet(pcodl_pcod_parref,pcodl_childsub,pcodl_phaci_dr)
	values(:main,:ch,:Phaci))
	q:SQLCODE -3
	q 1
}

ClassMethod OutQueryClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = OutQueryExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod OutQueryExecute(ByRef qHandle As %Binary, displocrowid As %String, Adm As %String, wardrowid As %String, StartDate As %String, EndDate As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1
 	;
	s PhaLoc=displocrowid
	s Ward=wardrowid
	;s Adm=PaAdm
	;
	q:PhaLoc="" $$$OK
	;
	i Adm="" q:StartDate="" $$$OK
	i Adm="" q:EndDate="" $$$OK
	i Adm="" q:Ward="" $$$OK
	;

	i Adm'="" d
	. s pcod=""
	. f  s pcod=$o(^DHCPCOD(0,"ADM",PhaLoc,Adm,pcod)) q:pcod=""  d
	. . s ward=$p(^DHCPCOD(pcod),"^",2)
	. . i ward'="" s ward=$p(^PAWARD(ward),"^",2)
	. . s dd=$p(^DHCPCOD(pcod),"^",4)
	. . s tt=$p(^DHCPCOD(pcod),"^",5)
	. . i dd'="" s dd=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(dd,"IP")
	. . i tt'="" s tt=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(tt,"IP")
	. . s user=$p(^DHCPCOD(pcod),"^",6)
	. . i user'="" s user=$p(^SSU("SSUSR",user),"^",2)
	. . s pano=..PaNo(Adm)
	. . s paname=..PaName(Adm)
	. . s bed=..Bed(Adm)
	. . s rowid=pcod
	. . s dispno=..GetDispNoOutDrug(pcod)
	. . 
	. . ;2007-9-25,zdm,性别，年龄，入院诊断
	. . s patnameid=$p(^PAADM(Adm),"^",1)                                           
	. . s sexdr=$p(^PAPER(patnameid,"ALL"),"^",7)
	. . i sexdr'="" s sex=$P(^CT("SEX",sexdr),"^",2) 
	. . s age=##class(web.DHCSTKUTIL).GetAge(patnameid) //年龄
	. . s diagnose=##class(web.DHCSTKUTIL).GetMRDiagnosDesc(Adm,",")
	. . s EncryptLevelInfo=""
    . . s EncryptLevel=""
    . . s PatLevel="" 
    . . s EncryptFlag=##Class(web.DHCSTCOMMPARA).GetEncryptLevelFlag("")
    . . i EncryptFlag=1 d
	. . . s EncryptLevelInfo=##class(web.DHCBL.CARD.UCardPaPatMasInfo).GetPatEncryptLevel(patnameid,"")
 	. . . s EncryptLevel=$p(EncryptLevelInfo,"^",1)
 	. . . s PatLevel=$p(EncryptLevelInfo,"^",2)
	. . d outputrow1
	e  d
	. f ddxxx=StartDate:1:EndDate d
	. . s pcod=""
	. . f  s pcod=$o(^DHCPCOD(0,"LOCDATE",PhaLoc,ddxxx,pcod)) q:pcod=""  d
	. . . s tmpward=$p(^DHCPCOD(pcod),"^",2)
	. . . q:tmpward'=wardrowid
	. . . s ward=$p(^PAWARD(wardrowid),"^",2)
	. . . s dd=$p(^DHCPCOD(pcod),"^",4)
	. . . s tt=$p(^DHCPCOD(pcod),"^",5)
	. . . i dd'="" s dd=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(dd,"IP")
	. . . i tt'="" s tt=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(tt,"IP")
	. . . s user=$p(^DHCPCOD(pcod),"^",6)
	. . . i user'="" s user=$p(^SSU("SSUSR",user),"^",2)
	. . . s adm=$p(^DHCPCOD(pcod),"^",3)
	. . . s pano=..PaNo(adm)
	. . . s paname=..PaName(adm)
	. . . s bed=..Bed(adm)
	. . . s rowid=pcod
	. . . s dispno=..GetDispNoOutDrug(pcod)
	. . . 
	. . . ;2007-9-25,zdm,性别，年龄，入院诊断
	. . . s patnameid=$p(^PAADM(adm),"^",1)                                           
	. . . s sexdr=$p(^PAPER(patnameid,"ALL"),"^",7)
	. . . i sexdr'="" s sex=$P(^CT("SEX",sexdr),"^",2) 
	. . . s age=##class(web.DHCSTKUTIL).GetAge(patnameid) //年龄
	. . . s diagnose=##class(web.DHCSTKUTIL).GetMRDiagnosDesc(adm,",")
	. . . s EncryptLevelInfo=""
    . . . s EncryptLevel=""
    . . . s PatLevel="" 
    . . . s EncryptFlag=##Class(web.DHCSTCOMMPARA).GetEncryptLevelFlag("")
    . . . i EncryptFlag=1 d
	. . . . s EncryptLevelInfo=##class(web.DHCBL.CARD.UCardPaPatMasInfo).GetPatEncryptLevel(patnameid,"")
 	. . . . s EncryptLevel=$p(EncryptLevelInfo,"^",1)
 	. . . . s PatLevel=$p(EncryptLevelInfo,"^",2)
	. . . d outputrow1
	Quit $$$OK
outputrow1
	s Data=$lb(rowid,dd,tt,pano,paname,ward,bed,user,dispno,age,$g(sex),diagnose,EncryptLevel,PatLevel)
	s ^CacheTemp(repid,ind)=Data	
	s ind=ind+1
	q
}

ClassMethod OutQueryFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = OutQueryExecute ]
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

Query OutQuery(displocrowid As %String, Adm As %String, wardrowid As %String, StartDate As %String, EndDate As %String) As %Query(ROWSPEC = "tPCODRowid:%String,tDispDate:%String,tDispTime:%String,tRegNo:%String,tPaName:%String,tWard:%String,tBed:%String,tDispUser:%String,tDispNo:%String,TAge:%String,TSex:%String,TDiagnose:%String,TEncryptLevel:%String,TPatLevel:%String")
{
}

ClassMethod PaNo(adm As %String) As %String
{
 
 &sql(select paadm_papmi_dr->papmi_no into :regno from pa_adm where paadm_rowid=:adm)
 q $g(regno)
}

ClassMethod PaName(adm As %String) As %String
{
 &sql(select paadm_papmi_dr->papmi_name into :name from pa_adm where paadm_rowid=:adm)
 q $g(name)
}

ClassMethod Bed(adm As %String) As %String
{
 
	&sql(select paadm_currentbed_dr->bed_code into :bed from pa_adm where paadm_rowid=:adm )
	q $g(bed)
}

ClassMethod GetDispDrugOutClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDispDrugOutExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetDispDrugOutExecute(ByRef qHandle As %Binary, PCODROWID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1

 q:PCODROWID="" $$$OK
	;
	s ret=..GetOutCollect(PCODROWID)
	s cnt=$p(ret,"^",1),pid=$p(ret,"^",2)
	q:cnt<0 $$$OK
	d resetvariables
	f i=1:1:cnt d
	.s data=..ListOutCollect(pid,i)
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
	.
	.;2007-9-26,zdm,通用名，规格，剂型，厂家
	.s generic=$p(data,"^",28)
	.s Specifaction=$p(data,"^",31)
	.s form=$p(data,"^",33)
	.s manf=$p(data,"^",32)
	.s manf=$p(manf,"-",2)
	
	.d outputrow
	.
	k ^TMP(pid,"OUTDRUG")   ;in the end , clear the global variables
	q $$$OK
resetvariables
	s (pano,paname,pasex,padob,admloc,prescno,doctor,code,desc,orderstatus,dosqty,freq,qty,uom,sp,amt,instruction,duration,orditemremark,disploc,generic,Specifaction,form,manf)=""
	q
outputrow
	s Data=$lb(pano,paname,pasex,padob,admloc,prescno,doctor,code,desc,orderstatus,dosqty,freq,qty,uom,sp,amt,instruction,duration,orditemremark,disploc,generic,Specifaction,form,manf)
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

Query GetDispDrugOut(PCODROWID As %String) As %Query(ROWSPEC = "pano:%String,paname:%String,pasex:%String,padob:%String,admloc:%String,prescno:%String,doctor:%String,code:%String,desc:%String,orderstatus:%String,doseqty:%String,freq:%String,qty:%String,uom:%String,sp:%String,amt:%String,instruction:%String,duration:%String,orditemremark:%String,disploc:%String,generic:%String,barcode:%String,form:%String,manf:%String")
{
}

ClassMethod ListOutCollect(pid, n)
{
	q ^TMP(pid,"OUTDRUG",n)
}

ClassMethod ListOutTotal(incicode As %String, pid As %String) As %String
{
	n (incicode,pid)
	s tmp=$o(^TMP(pid,"OUTDRUGTOTAL",incicode))
	q:tmp="" ""
	s currincicode=$p(^TMP(pid,"OUTDRUGTOTAL",tmp),"^",1)
	q ^TMP(pid,"OUTDRUGTOTAL",tmp)
}

ClassMethod ListOutMaininfo(pid As %String) As %String
{
	n (pid)
	q ^TMP(pid,"OUTDRUGMAININFO")
}

ClassMethod GetOutCollect(pcod As %String) As %String
{
 ///lq 修改可以一次性取全病区 患者出院带药信息
 s ppid=$I(^DHCSTPHARMACY("PRINTOUTDRUGXXXX"))
 k ^TMP(ppid,"OUTDRUG")
 s allpcod=pcod
 s cnt=$l(allpcod,"^")
 s h=1
 s i=0 
 f h=1:1:cnt d
 .s pcod=$p(allpcod,"^",h)
 .s disploc=$p(^DHCPCOD(pcod),"^",1)
 .i disploc'="" s disploc=$p(^CTLOC(disploc),"^",2)
 .s adm=$p(^DHCPCOD(pcod),"^",3)
 .;
 .q:adm="" ;"^"
 .s withdmy=..WithDMY(pcod) ;2007-03-17 是否含有毒麻药
 
 .s wardid=$p(^DHCPCOD(pcod),"^",2)				
 .i wardid'="" s ward=$p(^PAWARD(wardid),"^",2)				
 .s ward=$g(ward)  ;病区
 
 .s pano="",paname="",pasex="",padob="",admloc="",warddesc=""
 .&sql(select paadm_papmi_dr->papmi_no,paadm_papmi_dr->papmi_name,
		paadm_papmi_dr->papmi_sex_dr->CTSEX_Desc,
		paadm_papmi_dr->papmi_dob,
		PAADM_DepCode_DR->ctloc_desc,paadm_currentward_dr->ward_desc
		into :pano,:paname,:pasex,:padob,:admloc,:warddesc from pa_adm where paadm_rowid=:adm) ;PA_PatMas PAPMI_RowId
 .s diagnoseDesc=##class(web.DHCSTKUTIL).GetMRDiagnosDesc(adm,",")
 .&sql(select PAPMI_PAPER_DR->paper_id into :idno From pa_patmas where papmi_no=:pano)
 .s ^TMP(ppid,"OUTDRUGMAININFO")=ward_"^"_disploc
 .s idno=$g(pano) 
 .s ch=0
 .f  s ch=$o(^DHCPCOD(pcod,"L",ch)) q:ch=""  d 
 .. s phaci=$p(^DHCPCOD(pcod,"L",ch),"^",1)
 .. s phacdr=$p(phaci,"||",1),phaci=$p(phaci,"||",2)
 .. ;s phadspno=$p(^DHCPHAC(phacdr),"^",14) ;PHADispNo zdm add
 .. s phadspno=..GetDispNoOutDrug(pcod) 			;2007-8-22,zdm
 .. q:'$d(^DHCPHAC(phacdr,"I",phaci))
 .. s inclbdr=$p(^DHCPHAC(phacdr,"I",phaci),"^",4) 
 .. s oedis=$p(^DHCPHAC(phacdr,"I",phaci),"^",7)   
 .. s qty=$p(^DHCPHAC(phacdr,"I",phaci),"^",6) 
 .. s sp=$p(^DHCPHAC(phacdr,"I",phaci),"^",9)
 .. s amt=$fn(sp*qty,"",2)
 .. //s sp=$fn(sp,"",4) //发药单位更改，先不舍
 .. s prescno=$p(^DHCPHAC(phacdr,"I",phaci),"^",5)
 .. s inci=$p(inclbdr,"||",1)  
 .. s code=$p(^INCI(inci,1),"^",1)                                                 ;INCI_RowId
 .. s desc=$p(^INCI(inci,1),"^",2)  
 .. s uom=""
 .. s buom=$p(^INCI(inci,1),"^",10)
 .. i buom'="" s uom=$p(^CT("UOM",buom),"^",2)
 ..  
 .. s bed=$p(^DHCPHAC(phacdr,"I",phaci),"^",8) ;zdm add
 ..  
 .. s ord=$p(oedis,"||",1)                                                       ;OEORD_RowId                                                                      
 .. s itm=$p(oedis,"||",2)                                                       ;OEORI_ChildSub
 .. i '$d(^OEORD(ord,"I",itm)) q 
 .. s orddate=##class(web.DHCSTPCHCOLLPRN).getOrdDate(ord_"||"_itm) ;;2007-03-07
 .. s ordtime=##class(web.DHCSTPCHCOLLPRN).getOrdTime(ord_"||"_itm) 
 .. s doseqty=$p(^OEORD(ord,"I",itm,2),"^",1)
 .. s unit=$p(^OEORD(ord,"I",itm,2),"^",3)
 .. i unit'=""  s unit=$p(^CT("UOM",unit),"^",2)
 .. s doseqty=doseqty_unit
 .. s dose=##class(web.DHCSTPCHCOLLPRN).getPackUomDoseQty(ord,itm)  ;zdm add
 .. s duration=$p(^OEORD(ord,"I",itm,1),"^",7)
 .. i duration'="" s duration=$p(^PHCDU(duration),"^",3)
 .. s orditemremark=##class(web.DHCSTPCHCOLLS2).GetOrdItmRemark(ord_"||"_itm)
 .. s instruction=$p(^OEORD(ord,"I",itm,2),"^",7)
 .. i instruction'="" s instruction=$p(^PHCIN(instruction),"^",2)
 .. s freq=$p(^OEORD(ord,"I",itm,2),"^",4)
 .. i freq'="" s freq=$p(^PHCFR(freq),"^",3)
 .. s doctor=$p(^OEORD(ord,"I",itm,1),"^",11)
 .. i doctor'="" s doctor=$p(^CTPCP(doctor,1),"^",2)
 .. ;&sql(select oeori_doctor_dr into :doctor from oe_orditem where oeori_oeord_parref=:ord and oeori_childsub=:itm)   
 .. ;i doctor'="" s doctor=$p(^CTPCP(doctor,1),"^",2)
 .. s orderstatus=$p(^OEC("OSTAT",$p(^OEORD(ord,"I",itm,1),"^",13)),"^",2)
 ..
 .. s dmyflag=..DMYFlag(pcod,ch)  ;2007-03-17
 .. s generic=##class(web.DHCSTCOMMONSRV).getGeneric(inci)  ;别名-通用名
 .. 
 .. ;2007-8-14,zdm,规格，厂家,剂型
 .. s Specifaction=##class(web.DHCSTCOMMONSRV).getBarcode(inci)		;规格
 .. s manf=##class(web.DHCSTITMDESC).GetManfNameByInci(inci)	;厂家
 .. s form=##class(web.DHCSTCOMMONSRV).GetForm(inci)
 .. //wyx add 发药单位 2014-01-08
 .. s newqty=""
 .. s newunitdesc=""
 .. s newsp=0
 .. s basuomdr=+$p(^INCI(inci,1),"^",10)
 .. s dispuomdr=$p($g(^OEORD(ord,"I",itm,"DHC")),"^",13)
 .. i dispuomdr'="" d
 ... s confac=##class(web.DHCSTCOMMONSRV).UOMFac(dispuomdr,basuomdr)
 ... s dispqty2=qty/confac
 ... s unit=$p($g(^CT("UOM",dispuomdr)),"^",2)
 ... s newqty=dispqty2
 ... s newunitdesc=unit
 ... s newsp=sp*confac
 ... //wyx add 发药单位 2014-01-08
 .. i (newqty'="")&&(newunitdesc'="") d
 ... s disqty=newqty
 ... s disuom=newunitdesc
 ... s dissp=newsp
 .. e  d
 ... s disqty=qty
 ... s disuom=uom
 ... s dissp=sp
 .. 
 .. i '$d(^TMP(ppid,"OUTDRUGTOTAL",code)) d
 ...s ^TMP(ppid,"OUTDRUGTOTAL",code)=code_"^"_desc_"^"_Specifaction_"^"_form_"^"_disqty_"^"_dissp_"^"_amt_"^"_manf_"^"_disuom
 .. e  d
 ...s $p(^TMP(ppid,"OUTDRUGTOTAL",code),"^",5)=$p(^TMP(ppid,"OUTDRUGTOTAL",code),"^",5)+disqty
 ...s $p(^TMP(ppid,"OUTDRUGTOTAL",code),"^",7)=$p(^TMP(ppid,"OUTDRUGTOTAL",code),"^",7)+amt
 .. s i=i+1
 .. s padob=$fn((+$h-padob)/365,"",0)
 .. s info1=pano_"^"_paname_"^"_pasex_"^"_padob_"^"_admloc
 .. s info2=prescno_"^"_doctor_"^"_code_"^"_desc_"^"_orderstatus
 .. s info3=doseqty_"^"_freq_"^"_disqty_"^"_disuom_"^"_dissp
 .. s info4=amt_"^"_instruction_"^"_duration_"^"_orditemremark_"^"_disploc
 .. s info5=$g(diagnoseDesc)_"^"_$G(idno)_"^"_$g(warddesc)_"^"_$g(withdmy)_"^"_$g(dmyflag)
 .. s info6=$g(ward)_"^"_$g(bed)_"^"_$g(generic)_"^"_$g(dose)_"^"_$g(phadspno)
 .. s info7=$g(Specifaction)_"^"_$g(manf)_"^"_$g(form)_"^"_$g(orddate)_"^"_$g(ordtime)
 .. s ^TMP(ppid,"OUTDRUG",i)=info1_"^"_info2_"^"_info3_"^"_info4_"^"_info5_"^"_info6_"^"_info7
 q i_"^"_ppid
}

ClassMethod WithDMY(pcod As %String) As %String
{
 ;是否包含精神麻醉类药品
 ;returnvalue : 1 - 含, 0 - 不含
 s ch=0
 s dmyflag=0
 f  s ch=$o(^DHCPCOD(pcod,"L",ch)) q:(ch="")!(dmyflag=1)  d
 .s phaci=$p(^DHCPCOD(pcod,"L",ch),"^",1)
 .s phac=+phaci
 .s dispcat=$p($g(^DHCPHAC(phac)),"^",12)
 .s dispcat=$ZCVT(dispcat,"U")
 .i dispcat="DMY" s dmyflag=1 q    ;
 q dmyflag
}

ClassMethod DMYFlag(pcod As %String, ch As %String) As %String
{
 n (pcod,ch)
 q:pcod<1 ""
 q:ch="" ""
 q:'$d(^DHCPCOD(pcod,"L",ch)) ""
 s phaci=$p(^DHCPCOD(pcod,"L",ch),"^",1)
 s phac=+phaci q:phac<1 ""
 q:'$d(^DHCPHAC(phac)) ""
 s dispcat=$ZCVT($p(^DHCPHAC(phac),"^",12),"U")
 i dispcat["DMY" q "***" 
 q ""
}

ClassMethod GetDispNoOutDrug(pcod As %String) As %String
{
	;2007-8-22,zdm,根据pcod_rowid生成出院带药单号
	n (pcod)
	q:pcod<1 ""

	s tmp="00000000"_pcod
	s len=$L(tmp)
	
	s tmpno=$E(tmp,len-8+1,len)

	s dispno="CYDY"_tmpno
	
	q dispno
}

}
