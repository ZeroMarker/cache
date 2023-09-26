Import SQLUser

Class web.DHCSTDISPSTATDM Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

ClassMethod GetDispDM(recloc As %String, datefrom As %String, dateto As %String, incicat As %String, Poison As %String, IncludeDoc As %String, admlocrowid As %String) As %String
{
 //s ^zdm("GetDispDM")=recloc_"^"_datefrom_"^"_dateto_"^"_incicat_"^"_Poison_"^"_IncludeDoc_"^"_admlocrowid	
 k mPLIST
 q:dateto<datefrom -1
 q:recloc="" -2
 q:Poison="" -3
 i IncludeDoc="on" s IncludeDoc=1 
 e  s IncludeDoc=0
 s reclocdr=recloc
 s i=0
 s PID=$I(^TMP("DISPSTATDM"))
 s range="P"_"^"_"F"_"^"_"Y"  ; 设置统计范围 : P  -- 住院   , F -- 门诊   ,  Y -- 退药  lq
 ;s range="P"
 s h=1
 s flag="" f  s flag=$p(range,"^",h)  q:flag=""  d
 .f dd=datefrom:1:dateto d
 . .s intr=""
 . .f  s intr=$o(^DHCINTR(0,"TypeDate",flag,dd,intr)  ) q:intr=""  d
 . . .s inclb=$p(^DHCINTR(intr),"^",7)
 . . .s tmplocdr=..GetRecLocDR(inclb)
 . . .q:tmplocdr'=reclocdr
 . . .s inccatdr=$p(^INCI(+inclb,2),"^",2)   ;库存分类
 . . .q:(incicat'="")&($$findinccat(inccatdr,incicat))
 . . .s incidesc=$p(^INCI(+inclb,1),"^",2)  ;药品名称
 . . .;<-----------------------add by lq------------------------------------------
 . . .s BarCode=##Class(web.DHCSTCOMMONSRV).getBarcode(+inclb)
 . . .s fac=##class(web.DHCSTITMDESC).GetManfNameByInci(+inclb) ;厂家
 . . .s fac=$p(fac,"-",2)
 . . .s poisonstr=##class(web.DHCSTCOMMONSRV).getPoisonByInci(+inclb)    ;zdm,2007-8-3
 . . .s poisondr=$p(poisonstr,"^",1)
 . . .i (Poison'="") q:(poisondr'=Poison)
 . . .s batno=..GetBatNo(inclb)   ;发出药品批号
 . . .s qty=$p(^DHCINTR(intr),"^",6)      ;数量
 . . .s uomdr=$p(^DHCINTR(intr),"^",10)
 . . .i uomdr'="" s uom=$p(^CT("UOM",uomdr),"^",2) ;单位
 . . .s qtyuom=-qty_" "_$g(uom)  ;数量
 . . .s amt=-$p(^DHCINTR(intr),"^",8) ;金额
 . . .s pointer=$p(^DHCINTR(intr),"^",9)
 . . .i (flag="Y")||(flag="H") d
 . . . .s data1=..GetPaInfoRet(pointer,flag)
 . . . .s data2=..GetDispInfoRet(pointer,flag)
 . . .e  d
 . . . .s data1=..GetPaInfo(pointer,flag)
 . . . .s data2=..GetDispInfo(pointer,flag)
 . . .s oper=$P(data2,"^",1)  ;发药人
 . . .s prescno=$P(data2,"^",2) ;处方编号
 . . .s doctor=$P(data2,"^",3) ;医生
 . . .s doclocdr=$P(data2,"^",8) ;医生科室
 . . .s admlocdr=$P(data2,"^",9) ;就诊科室
 . . .q:(##class(web.DHCSTKUTIL).DoctorLocRefuse(recloc,doclocdr)=1)&(IncludeDoc=0) ;医生科室信息
 . . .
 . . .q:(admlocdr'=admlocrowid)&(admlocrowid'="")
 . . .
 . . .s paname=$P(data1,"^",1) ;患者姓名
 . . .s pasex=$P(data1,"^",2) ;性别
 . . .s paage=$P(data1,"^",3) ;年龄
 . . .s papmiid=$P(data1,"^",4) ;身份证号
 . . .s disease=##class(PHA.FACE.IN.Com).GetMRDiagnosDesc(prescno,", ")
 . . .s medicareno=$P(data1,"^",6) ;病历号
 . . .s regno=$p(data1,"^",7) ;登记号
 . . .
 . . .s freq=$p(data2,"^",4)  ;频率 
 . . .s doseqty=$p(data2,"^",5) ; 剂量
 . . .s admloc=$p(data2,"^",6)  ;科室
 . . .q:(admlocrowid'="")&(admlocrowid'=admlocdr)
 . . .s instruction=$p(data2,"^",7)
 . . .s rem="" 
 . . .s rem=$p(data2,"^",10)
 . . .s s1=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(dd)_"^"_prescno_"^"_paname_"^"_pasex_"^"_paage
 . . .s s2=papmiid_"^"_medicareno_"^"_disease_"^"_incidesc_"^"_qtyuom
 . . .s s3=doctor_"^"_oper_"^"_oper_"^"_batno_"^"_regno
 . . .s s4=freq_"^"_doseqty_"^"_admloc_"^"_amt_"^"_rem
 . . .s s5=instruction_"^"_uom_"^"_BarCode_"^"_fac // add lq
 . . .s i=i+1
 . . .s ^mPLIST("DISPSTATDM",PID,i)=s1_"^"_s2_"^"_s3_"^"_s4_"^"_s5
 . . .i Poison ="3" s ^TmpPrintDM2(PID,"DISPSTATDM",incidesc,i)=s1_"^"_s2_"^"_s3_"^"_s4_"^"_s5 //lq add  毒麻精神药品二类打印
 . s h=h+1
 q PID_"^"_i
  
findinccat(inccatdr,incicat)
 s retflag=1
 s catcnt=$l(incicat,"^")
 f x=1:1:catcnt d
 .s tmpcat=$p(incicat,"^",x)
 .i inccatdr=tmpcat s retflag=0
 q retflag
}

ClassMethod ListDispDM(pid As %String, i As %String) As %String
{
 q ^mPLIST("DISPSTATDM",pid,i)
}

ClassMethod GetNum(job)
{
 //lq add  2007/10/12
 //毒麻精神药品二类打印,返回各类药总数
 s incidesc=""
 s a=0 
 s str=""
 f  s incidesc=$o(^TmpPrintDM2(job,"DISPSTATDM",incidesc)) q:incidesc=""  d
  .s num=""
  .s b=0 
  .f  s num=$o(^TmpPrintDM2(job,"DISPSTATDM",incidesc,num)) q:num=""  d
  ..s b=b+1
  .s a=a+1
  .s str=str_"||"_a_"^"_b_"^"_incidesc //第几种药_"^"_每总药的数量_"^"_药品名
  .;w !,a_"^"_b_"^"_incidesc
  q a_str
}

ClassMethod GetNum1(job)
{
 //lq add 2007/10/12
 //毒麻精神药品二类打印,返回临时打印global下标,按药名以“||”间隔
 s incidesc=""
 s num=""
 s num1=""
 s num2=""
 f  s incidesc=$o(^TmpPrintDM2(job,"DISPSTATDM",incidesc)) q:incidesc=""  d
  .s n=0
  .f  s num=$o(^TmpPrintDM2(job,"DISPSTATDM",incidesc,num)) q:num=""  d
  ..s num1=num1_"^"_num
  . s num1=num1_"||"
 q num1
}

ClassMethod ListStr(job, name, i)
{
 
 //lq add 2007/10/12
 //毒麻精神药品二类打印,返回打印明细
 //根据下标gnum取临时global中的数据
 s str=^TmpPrintDM2(job,"DISPSTATDM",name,i) 
 q str
}

ClassMethod KillTmpPrintDM2(PID)
{
  //lq add 2007/10/12
  //Kill the ^TMPPRINTDMDM 毒麻精神药品二类打印
  q:PID="" 
  q:'$d(^TMPPRINTDMDM(PID,"DISPSTATDM"))
  k ^TMPPRINTDMDM(PID,"DISPSTATDM")
  q
}

ClassMethod GetPaInfo(pointer As %String, intrType = "") As %String
{
 n (pointer,intrType)
 i intrType="" s intrType="P"
 s PHAC=+$p(pointer,"||",1)
 s CH=+$p(pointer,"||",2)
 s adm=0
 i intrType="P" s adm=$P($g(^DHCPHAC(PHAC,"I",CH)),"^",3)
 e  d
 .s oeori=$p($g(^DHCPHDI(PHAC,"PHDI",CH)),"^",5)
 .s adm=$p($g(^OEORD(+oeori)),"^",1)
 q:adm=0 ""
 s papmi=$p(^PAADM(adm),"^",1)
 s paadmtype=$p(^PAADM(adm),"^",2) ;类型
 s governcardno=##Class(web.DHCSTINTERFACE).GetMrNoByEpisodeID(adm)  //$p($g(^PAPER(papmi,"PER",4),"^", 4) ;门诊病历号
 q:'$d(^PAPER(papmi,"ALL")) ""
 s paname=$p(^PAPER(papmi,"ALL"),"^", 1) ;患者姓名
 s pasex=$p(^PAPER(papmi,"ALL"),"^",7 ) 
 i pasex'="" s pasex=$p(^CT("SEX",pasex),"^",2)  ;性别
 s dob=$p(^PAPER(papmi,"ALL"),"^", 6)
 s papmiid=$p(^PAPER(papmi,"PAT",3),"^",6)
 i papmiid="" d
 .s papmiid=$p((^PAADM(+adm,"DHC")),"^",35)
 .i papmiid'="" s papmiid="(代)"_papmiid
 s paage=##class(PHA.FACE.IN.Com).GetAge(papmi,adm) //年龄统一调用接口wyx 2015-01-29
 ;s medicareno=$p(^PAPER(papmi,"PAT",1),"^",1)
 s medicareno=##class(web.DHCSTINTERFACE).GetMrNoByEpisodeID(adm)
 i paadmtype="O" s medicareno=governcardno  ;门诊
 s disease=""
 ;s disease=..GetDisease(adm)
 s disease=##class(web.DHCSTKUTIL).GetMRDiagnosDesc(adm,",")
 &sql(select papmi_no into :regno from pa_patmas where papmi_rowid=:papmi )
 s regno=$g(regno)
 q paname_"^"_pasex_"^"_paage_"^"_papmiid_"^"_disease_"^"_medicareno_"^"_regno
}

ClassMethod GetPaInfoRet(pointer As %String, intrType = "") As %String
{
 n (pointer,intrType)
 i intrType="" s intrType="Y"
 s phar=$p(pointer,"||",1)
 s ch=$p(pointer,"||",2)
 s adm=0
 i intrType="Y" s adm=$p(^PHARET(phar,"I",ch),"^",8)
 e  d
 .s oeori=$p(^DHCPHRTI(phar,"RTI",ch),"^",2)
 .s adm=$p($g(^OEORD(+oeori)),"^",8)
 q:+adm=0 ""
 s papmi=$p(^PAADM(adm),"^",1)
 s paadmtype=$p(^PAADM(adm),"^",2) ;类型
 s governcardno=##Class(web.DHCSTINTERFACE).GetMrNoByEpisodeID(adm) //$p(^PAPER(papmi,"PER",4),"^", 4) ;门诊病历号
 q:'$d(^PAPER(papmi,"ALL")) ""
 s paname=$p(^PAPER(papmi,"ALL"),"^", 1) ;患者姓名
 s pasex=$p(^PAPER(papmi,"ALL"),"^",7 ) 
 i pasex'="" s pasex=$p(^CT("SEX",pasex),"^",2)  ;性别
 s dob=$p(^PAPER(papmi,"ALL"),"^", 6)
 s papmiid=##class(PHA.FACE.IN.Com).GetPatID(papmi) ;证件号码
 i papmiid="" d
 .s papmiid=$p((^PAADM(+adm,"DHC")),"^",35)
 .i papmiid'="" s papmiid="(代)"_papmiid
 s paage=##class(PHA.FACE.IN.Com).GetAge(papmi,adm) //年龄统一调用接口wyx 2015-01-29
 s medicareno=##Class(web.DHCSTINTERFACE).GetMrNoByEpisodeID(adm)  //$p(^PAPER(papmi,"PAT",1),"^",1)
 i paadmtype="O" s medicareno=governcardno  ;门诊
 s disease=""
 ;s disease=..GetDisease(adm)
 &sql(select papmi_no into :regno from pa_patmas where papmi_rowid=:papmi )
 s regno=$g(regno)
 q paname_"^"_pasex_"^"_paage_"^"_papmiid_"^"_disease_"^"_medicareno_"^"_regno
}

ClassMethod GetDispInfo(pointer As %String, intrType = "") As %String
{
 n (pointer,intrType)
 i intrType="" s intrType="P"
 s PHAC=$p(pointer,"||",1)
 s CH=$p(pointer,"||",2)
 s phaoper=""
 i intrType="P" d
 .s phaoper=$p(^DHCPHAC(PHAC),"^",5)
 .s oedis=$p(^DHCPHAC(PHAC,"I",CH),"^",7)
 e  d
 .s phdFyPhpDr=$p($g(^DHCPHDISP(PHAC,1)),"^",2)
 .s phaoper=$p($g(^DHCPHPER(+phdFyPhpDr)),"^",5)
 .s oedis=$p($g(^DHCPHDI(PHAC,"PHDI",CH)),"^",5)
 i phaoper'="" s phaoper=$p(^SSU("SSUSR",phaoper),"^",2)
 s orditminfo=..GetOrdItmInfo(oedis)
 s ord=$p(oedis,"||",1)
 s itm=$p(oedis,"||",2)
 s Notes=$g(^OEORD(ord,"I",itm,"DEP",1)) ;医嘱备注
 s remark=$p(^OEORD(ord,"I",itm,2),"^",8) //草药备注
 S Notes=$tr($tr($tr(Notes,$c(10)),$C(13))," ")
 i Notes'="" d
 .i remark'="" d
 ..s Notes=Notes_"("_remark_")"
 e  i remark'="" d
 .s Notes=remark
 . 
 s doctor=$p(orditminfo,"^",1)
 s freq=$p(orditminfo,"^",2)
 s doseqty=$p(orditminfo,"^",3)
 s admloc=$p(orditminfo,"^",4)
 s instruction=$p(orditminfo,"^",5)
 s doclocdr=$p(orditminfo,"^",6)
 s prescno=$p(orditminfo,"^",7)
 s admId=$p($g(^OEORD(+oedis)),"^",1)
 s admlocdr=$P(^PAADM(admId),"^",4)
 q phaoper_"^"_$g(prescno)_"^"_doctor_"^"_freq_"^"_doseqty_"^"_admloc_"^"_instruction_"^"_doclocdr_"^"_admlocdr_"^"_Notes
}

ClassMethod GetDispInfoRet(pointer As %String, intrType = "") As %String
{
 n (pointer,intrType)
 i intrType="" s intrType="Y"
 s phar=$p(pointer,"||",1)
 s ch=$p(pointer,"||",2)
 s phaoper=""
 i intrType="Y" d // 取住院
 .s phaoper=$p(^PHARET(phar),"^",3)
 .s oedis=$P(^PHARET(phar,"I",ch),"^",1)
 e  d 			 // 取门诊
 .s phdRetPhpDr=$p(^DHCPHRET(phar),"^",8)
 .s phaoper=$p($g(^DHCPHPER(+phdRetPhpDr)),"^",5)
 .s oedis=$p(^DHCPHRTI(phar,"RTI",ch),"^",2)
 i phaoper'="" s phaoper=$p(^SSU("SSUSR",phaoper),"^",2)
 s admId=$p($g(^OEORD(+oedis)),"^",1)
 s admlocdr=$p(^PAADM(admId),"^",4)
 s orditminfo=..GetOrdItmInfo(oedis)
 s doctor=$p(orditminfo,"^",1)
 s freq=$p(orditminfo,"^",2)
 s doseqty=$p(orditminfo,"^",3)
 s admloc=$p(orditminfo,"^",4)
 s instruction=$p(orditminfo,"^",5)
 s doclocdr=$p(orditminfo,"^",6)
 s prescno=$p(orditminfo,"^",7)
 q phaoper_"^"_$g(prescno)_"^"_doctor_"^"_freq_"^"_doseqty_"^"_admloc_"^"_instruction_"^"_doclocdr_"^"_admlocdr
}

ClassMethod GetOrdItmInfo(oedis As %String) As %String
{
 n (oedis)
 s (ord,itm)=0
 i oedis'="" d
 .s ord=$p(oedis,"||",1)
 .s itm=$p(oedis,"||",2)
 s useradd=""
 i $d(^OEORD(ord,"I",itm,7)) s useradd=$p(^OEORD(ord,"I",itm,7),"^",1)
 s doclocdr=$p(^OEORD(ord,"I",itm,7),"^",2)  //useradd  2014-12-20 ws
 i $g(useradd)'="" s useradd=$p(^SSU("SSUSR",useradd),"^",2)
 i $d(^OEORD(ord,"I",itm,2)) s freq=$p(^OEORD(ord,"I",itm,2),"^",4)
 i $g(freq)'="" s freq=$p(^PHCFR(freq),"^",3)
 i $d(^OEORD(ord,"I",itm,2)) d
 .s doseqty=##class(PHA.COM.Order).OeoriDosage(oedis)
 .s unit=$p(^OEORD(ord,"I",itm,2),"^",3)
 i $g(unit)'=""  s unit=$p(^CT("UOM",unit),"^",2)
 s doseqty=$g(doseqty) //_$g(unit)
 s prescno=$p(^OEORD(ord,"I",itm,1),"^",14)
 i $d(^OEORD(ord,"I",itm,2)) s instruction=$p(^OEORD(ord,"I",itm,2),"^",7)
 i $g(instruction)'="" s instruction=$p($g(^PHCIN(instruction)),"^",2)
 &sql(select oeord_adm_dr->PAADM_DepCode_DR->ctloc_desc into :admloc from oe_order where oeord_rowid=:ord)
 q $g(useradd)_"^"_$g(freq)_"^"_$g(doseqty)_"^"_$g(admloc)_"^"_$g(instruction)_"^"_doclocdr_"^"_prescno
}

ClassMethod GetBatNo(inclb As %String) As %String
{
 n (inclb)
 s inci=+inclb q:inci<1 ""
 s ilch=$P(inclb,"||",2) q:ilch="" ""
 s lb=$P(inclb,"||",3) q:lb="" ""
 q:'$d(^INCI(inci,"IL",ilch,"LB",lb))
 s incib=$p(^INCI(inci,"IL",ilch,"LB",lb),"^",1)
 s ibch=$p(incib,"||",2)
 s ibno=$p(^INCI(inci,"IB",ibch),"^",1)
 q ibno
}

ClassMethod GetRecLocDR(inclb As %String) As %String
{
 n (inclb)
 s inci=+inclb q:inci<1 ""
 s ilch=$P(inclb,"||",2) q:ilch="" ""
 s locdr=$p(^INCI(inci,"IL",ilch),"^",1 )
 q:locdr="" ""
 q locdr
}

ClassMethod GetDoctor(oedis As %String) As %String
{
 n (oedis)
 s ord=$p(oedis,"||",1)
 s itm=$p(oedis,"||",2)
 s useradd=$p(^OEORD(ord,"I",itm,7),"^",1)
 i useradd'="" s useradd=$p(^SSU("SSUSR",useradd),"^",2)
 q useradd
}

ClassMethod GetOecCat(inclb As %String) As %String
{
 n (inclb)
 s inci=+inclb q:inci="" ""
 q:'$d(^INCI(inci,1)) ""
 s arcim=$p(^INCI(inci,1),"^",3)
 s sub=$p(arcim,"||",1)
 s ver=$p(arcim,"||",2)
 s arcic=$p(^ARCIM(sub,ver,1),"^",10  ) q:arcic="" ""
 s ordcat=$p(^ARC("IC",arcic),"^",8)   q:ordcat="" "" ; oec_cat
 s ordcatcode=$p(^OEC("ORCAT",ordcat),"^",1) 
 q ordcatcode
}

ClassMethod GetArcItmSubCat(inclb As %String) As %String
{
 n (inclb)
 s inci=+inclb q:inci="" ""
 q:'$d(^INCI(inci,1)) ""
 s arcim=$p(^INCI(inci,1),"^",3)
 s sub=$p(arcim,"||",1)
 s ver=$p(arcim,"||",2)
 s arcic=$p(^ARCIM(sub,ver,1),"^",10  ) q:arcic="" ""
 ;
 ;s ordsubcatcode=$p(^ARC("IC",arcic),"^",1) 
 ;q ordsubcatcode
 q arcic
}

ClassMethod DispStatDMClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = DispStatDMExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod DispStatDMFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = DispStatDMExecute ]
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

ClassMethod DispStatDMExecute(ByRef qHandle As %Binary, DispLocRowid As %String, StartDate As %String, EndDate As %String, IncStkCatRowid As %String, PoisonRowid As %String, IncludeDoc As %String, admlocrowid As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1
	i DispLocRowid=""  		q $$$OK
	i StartDate=""  q $$$OK
	i EndDate=""   q $$$OK
	s StartDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(StartDate)
 	s EndDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(EndDate)
	s result=..GetDispDM(DispLocRowid,StartDate,EndDate,IncStkCatRowid,PoisonRowid,IncludeDoc,admlocrowid) //add lq
	s pid=$p(result,"^",1)
	s cnt=$p(result,"^",2)
	q:cnt<1 $$$OK
	f i=1:1:cnt d
	.s tmp=..ListDispDM(pid,i)
	. s TDate=$p(tmp,"^",1)
	. s TPrescNo=$p(tmp,"^",2)
	. s TRegNo=$p(tmp,"^",15)
	. s TPaName=$p(tmp,"^",3)
	. s TSex=$p(tmp,"^",4)
	. s TAge=$p(tmp,"^",5)
	. s TIDNO=$p(tmp,"^",6)
	. s TPRNO=$p(tmp,"^",7)
	. s TDiagNose=$p(tmp,"^",8)
	. s TDrugDesc=$p(tmp,"^",9)
	. s TQty=$p(tmp,"^",10)
	. s TDoctor=$p(tmp,"^",11)
	. s TDispUser=$p(tmp,"^",12)
	. s TAuditor=$p(tmp,"^",13)
	. s TDrugBatchNo=$p(tmp,"^",14) 
	. s TFreq=$p(tmp,"^",16)
	. s TDoseQty=$p(tmp,"^",17)
	. s TAdmLoc=$p(tmp,"^",18)
	. s TAmt=$p(tmp,"^",19)
	. s TRem=$p(tmp,"^",20)
	. s TInstruction=$p(tmp,"^",21)
	. s Tuom=$p(tmp,"^",22)  //add lq
	. s TBarCode=$p(tmp,"^",23)  //add  lq
	. s Tpid=pid
	.d outputrow
	k ^mPLIST("DISPSTATDM",pid)
	q $$$OK
outputrow
	;
	
	s Data=$lb(TDate,TPrescNo,TRegNo,TPaName,TSex,TAge,TIDNO,TPRNO,TDiagNose,TDrugDesc,TQty,TDoctor,TDispUser,TAuditor,TDrugBatchNo,TFreq,TDoseQty,TAdmLoc,TAmt,TRem,TInstruction,Tuom,TBarCode,Tpid) //add lq
	s ^CacheTemp(repid,ind)=Data	
	s ind=ind+1
	q
}

Query DispStatDM(DispLocRowid As %String, StartDate As %String, EndDate As %String, IncStkCatRowid As %String, PoisonRowid As %String, IncludeDoc As %String, admlocrowid As %String) As %Query(ROWSPEC = "TDate:%String,TPrescNo:%String,TRegNo:%String,TPaName:%String,TSex:%String,TAge:%String,TIDNO:%String,TPRNO:%String,TDiagNose:%String,TDrugDesc:%String,TQty:%String,TDoctor:%String,TDispUser:%String,TAuditor:%String,TDrugBatchNo:%String,TFreq:%String,TDoseQty:%String,TAdmLoc:%String,TAmt:%String,TRem:%String,TInstruction:%String,Tuom:%String,TBarCode:%String,Tpid:%String")
{
}

ClassMethod GetIncStkCat() As %String
{
 s str=""
 s incsc=""
 f  s incsc=$o(^INC("SC",incsc)) q:incsc=""  d
 .s desc=$p(^INC("SC",incsc),"^",2)
 .s rowid=incsc
 .s str=str_"!"_rowid_"^"_desc
 i str'="" s str=$p(str,"!",2,$l(str,"!"))
 q str
}

// 自制药品统计

// 咸阳财务报表

ClassMethod DispStatBYZZClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = DispStatBYZZExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod DispStatBYZZFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = DispStatBYZZExecute ]
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

ClassMethod DispStatBYZZExecute(ByRef qHandle As %Binary, DispLocRowid As %String, StartDate As %String, EndDate As %String, PoisonRowid As %String) As %Status
{
	
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1
	s DispLocRowid=DispLocRowid
	s StartDate=$zdh("2014-01-01",3)
	;s EndDate=$zdh(+$h,3)
	s EndDate=+$h
	s PoisonRowid=PoisonRowid
	i DispLocRowid=""  		q $$$OK
	i StartDate=""  q $$$OK
	i EndDate=""   q $$$OK
	s result=..GetDispBYZZ(DispLocRowid,StartDate,EndDate,PoisonRowid,"","") 
	s pid=$p(result,"^",1)
	s cnt=$p(result,"^",2)
	q:cnt<1 $$$OK
	f i=1:1:cnt d
	.s tmp=..ListDispBYZZ(pid,i)
	. s TDrugDesc=$p(tmp,"^",9)
	. s TQty=$p(tmp,"^",10)
	. s TAdmLoc=$p(tmp,"^",18) 
	. s TAmt=$p(tmp,"^",19)
	. s TSp=TAmt/TQty
	.d outputrows11
	k ^mPLIST("DISPSTATBYZZ",pid)
	q $$$OK
outputrows11
	s Data=$lb(TAdmLoc,TDrugDesc,TQty,TAmt,TSp)
	s ^CacheTemp(repid,ind)=Data	
	s ind=ind+1
	q
}

/// d ##class(%ResultSet).RunQuery("web.DHCSTDISPSTATDM","DispStatBYZZ","209","2013-12-20","2014-03-20","21")
Query DispStatBYZZ(DispLocRowid As %String, StartDate As %String, EndDate As %String, PoisonRowid As %String) As %Query(ROWSPEC = "TAdmLoc:%String,TDrugDesc:%String,TQty:%String,TAmt:%String,TSp:%String") [ SqlProc ]
{
}

ClassMethod GetDispBYZZ(recloc As %String, datefrom As %String, dateto As %String, Poison As %String, IncludeDoc As %String, admlocrowid As %String) As %String
{
 //s ^zdm("GetDispDM")=recloc_"^"_datefrom_"^"_dateto_"^"_incicat_"^"_Poison_"^"_IncludeDoc_"^"_admlocrowid	
 k mPLIST
 q:dateto<datefrom -1
 q:recloc="" -2
 q:Poison="" -3
 i IncludeDoc="on" s IncludeDoc=1 
 e  s IncludeDoc=0
 ;s reclocdr=##class(web.DHCSTCOMMONSRV).LocToRowID(recloc)
 s reclocdr=recloc
 s i=0
 s PID=$I(^TMP("DISPSTATBYZZ"))
 s range="P"_"^"_"F"_"^"_"Y"  ; 设置统计范围 : P  -- 住院   , F -- 门诊   ,  Y -- 退药  lq
 ;s range="P"
 s h=1
 s flag="" f  s flag=$p(range,"^",h)  q:flag=""  d
 .f dd=datefrom:1:dateto d
 . .s intr=""
 . .f  s intr=$o(^DHCINTR(0,"TypeDate",flag,dd,intr)  ) q:intr=""  d
 . . .s inclb=$p(^DHCINTR(intr),"^",7)
 . . .s tmplocdr=..GetRecLocDR(inclb)
 . . .q:tmplocdr'=reclocdr
 . . .
 . . .;s ordcat=$$GetOecCat(inclb)
 . . .;s ordcat=..GetArcItmSubCat(inclb)
 . . .;q:(ordcat'="518")&(ordcat'="517")&(ordcat'="500")&(ordcat'="501")   ; JST使用的毒麻精神医嘱子类
 . . .
 . . .s inccatdr=$p(^INCI(+inclb,2),"^",2)   ;库存分类
 . . .;q:(incicat'="")&(inccatdr'=incicat)
 . . .s incidesc=$p(^INCI(+inclb,1),"^",2)  ;药品名称
 . . .;<-----------------------add by lq------------------------------------------
 . . .//s BarCode=$p(^INCI(+inclb,3),"^",9)  ;规格
 . . .s BarCode=##Class(web.DHCSTCOMMONSRV).getBarcode(+inclb)
 . . .s fac=##class(web.DHCSTITMDESC).GetManfNameByInci(+inclb) ;厂家
 . . .s fac=$p(fac,"-",2)
 . . .s poisonstr=##class(web.DHCSTCOMMONSRV).getPoisonByInci(+inclb)    ;zdm,2007-8-3
 . . .s poisondr=$p(poisonstr,"^",1)
 . . .i (Poison'="") q:(poisondr'=Poison)
 . . .s batno=..GetBatNo(inclb)   ;发出药品批号
 . . .s qty=$p(^DHCINTR(intr),"^",6)      ;数量
 . . .s uomdr=$p(^DHCINTR(intr),"^",10)
 . . .i uomdr'="" s uom=$p(^CT("UOM",uomdr),"^",2) ;单位
 . . .s qtyuom=-qty  ;;_" "_$g(uom)  ;数量
 . . .
 . . .s amt=-$p(^DHCINTR(intr),"^",8) ;金额
 . . .
 . . .s pointer=$p(^DHCINTR(intr),"^",9)
 . . .i flag="Y" s data1=..GetPaInfoRet(pointer)
 . . .e  s data1=..GetPaInfo(pointer)
 . . .i flag="Y" s data2=..GetDispInfoRet(pointer)
 . . .e  s data2=..GetDispInfo(pointer)
 . . .s oper=$P(data2,"^",1)  ;发药人
 . . .s prescno=$P(data2,"^",2) ;处方编号
 . . .s doctor=$P(data2,"^",3) ;医生
 . . .s doclocdr=$P(data2,"^",8) ;医生科室
 . . .s admlocdr=$P(data2,"^",9) ;就诊科室
 . . .q:(##class(web.DHCSTKUTIL).DoctorLocRefuse(recloc,doclocdr)=1)&(IncludeDoc=0) ;医生科室信息
 . . .
 . . .q:(admlocdr'=admlocrowid)&(admlocrowid'="")
 . . .
 . . .s paname=$P(data1,"^",1) ;患者姓名
 . . .s pasex=$P(data1,"^",2) ;性别
 . . .s paage=$P(data1,"^",3) ;年龄
 . . .s papmiid=$P(data1,"^",4) ;身份证号
 . . .s disease=$P(data1,"^",5) ;病名
 . . .s medicareno=$P(data1,"^",6) ;病历号
 . . .s regno=$p(data1,"^",7) ;登记号
 . . .
 . . .s freq=$p(data2,"^",4)  ;频率 
 . . .s doseqty=$p(data2,"^",5) ; 剂量
 . . .s admloc=$p(data2,"^",6)  ;科室
 . . .q:(admlocrowid'="")&(admlocrowid'=admlocdr)
 . . .s instruction=$p(data2,"^",7)
 . . .s rem="" 
 . . .s rem=$p(data2,"^",10)
 . . .s s1=$zd(dd,3)_"^"_prescno_"^"_paname_"^"_pasex_"^"_paage
 . . .s s2=papmiid_"^"_medicareno_"^"_disease_"^"_incidesc_"^"_qtyuom
 . . .s s3=doctor_"^"_oper_"^"_oper_"^"_batno_"^"_regno
 . . .s s4=freq_"^"_doseqty_"^"_admloc_"^"_amt_"^"_rem
 . . .s s5=instruction_"^"_uom_"^"_BarCode_"^"_fac // add lq
 . . .s i=i+1
 . . .s ^mPLIST("DISPSTATBYZZ",PID,i)=s1_"^"_s2_"^"_s3_"^"_s4_"^"_s5
 . s h=h+1
 q PID_"^"_i
}

ClassMethod ListDispBYZZ(pid As %String, i As %String) As %String
{
 q ^mPLIST("DISPSTATBYZZ",pid,i)
}

}
