Import SQLUser

Class web.DHCSTPCHCOLLPRN Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

ClassMethod GetPhaColl(itmjs As %Library.String = "", itmjsex As %Library.String = "", main As %String) As %String
{
  k PLIST
  n (main)
  ; ; main --- phacrowid+"B"+"^^^"
  s str=main
  s main=$p(str,"B",1)
  s pamstr=$p(str,"B",2)
  ;
  &sql(select * into :PLIST() from DHC_PhaCollected  where DHC_PhaCollect_Rowid=:main)	
  s phaloc=+PLIST(2)
  s frdate=PLIST(11)
  s todate=PLIST(12)
  s oper=+PLIST(6)
  s wardloc=+PLIST(5)
  s type=PLIST(13)
  s prtdate=PLIST(8)
  s prttime=PLIST(9)
  s dispno=PLIST(15)   ;2007-01-13
  i prtdate'="" s prtdate=$zd(prtdate,3)
  i prttime'="" s prttime=$zt(prttime)
  s type=PLIST(13)
  i phaloc>0 s phaloc=$p(^CTLOC(phaloc),"^",2)  ; desc of location
  i oper>0 s oper=$p(^SSU("SSUSR",oper),"^",2)  ;
  i wardloc>0 s wardloc=$p( ^PAWARD(wardloc),"^",2) ;desc of ward
  e  s wardloc=..getUserDepartment(main) ;2007-04-23
  s frdate=$zd(frdate,3)
  s todate=$zd(todate,3)
  s distypedesc=##class(web.DHCSTPHADRUGGROUP).DispCatDesc(type)           //发药分类名称
  &sql(select sum(phaci_qty*phaci_price) into :amt From dhc_phacollectitm  where phaci_phac_parref=:main)
  s amt=$fn($g(amt),"",2)
  s dispordtype=..getPhacOrdPri(main)
  s Priority=..getPriority(main)
  s retflag=##class(web.DHCSTPCHCOLLS).ChkPhaItmInfo(main,pamstr)
  q:(retflag=0)&(pamstr'="")
  s grp=..GetGrpWard(main)
  s wardloc=wardloc_" "_grp
  q phaloc_"^"_wardloc_"^"_frdate_"^"_todate_"^"_type_"^"_oper_"^"_prtdate_"^"_type_"^"_prttime_"^"_$g(dispno)_"^"_$G(distypedesc)_"^"_$g(amt)_"^"_$g(dispordtype)_"^"_Priority
}

// zdm,2012-03-02，增加批次表后所作修改,

// 摆药单上一条医嘱多个批次只打印一条

/// w ##class(web.DHCSTPCHCOLLPRN).GetPhaCollDetail(147)
ClassMethod GetPhaCollDetail(main As %String) As %String
{
  q:main=""
  n (main)
  s newpid=..PrnID()
  k ^TMP(newpid,"PRNDISPD")
  k ^TMP(newpid,"PRNDISPDTOTAL")
  s i=0
  s h=0
  s ch=0
  ;  ; main --- phacrowid+"B"+"^^^"
  s str=main
  s main=$p(str,"B",1)
  s pamstr=$p(str,"B",2)
  s paregno="",longord="",shortord=""
  i pamstr'="" d
  .s paregno=$p(pamstr,"^",1) 
  .s longord=$p(pamstr,"^",2)
  .s shortord=$p(pamstr,"^",3)
  ;
  s phactype=$p(^DHCPHAC(main),"^",12) 
  s ward=$p(^DHCPHAC(main),"^",4)   ; 病区
  s phaloc=$p(^DHCPHAC(main),"^",1)   ;发药科室
  s phadate=$p(^DHCPHAC(main),"^",2)
  s HospID=$p($g(^CTLOC(phaloc)),"^",22)
  //k ^TMP(newpid)
  f  s ch=$o(^DHCPHAC(main,"I",ch))  q:ch=""  d
   .s data=^(ch)
   .s (adm,admloc,oedis,inclb,incibatno,prescno,qty,sp,amt,bed)=""
   .s (pano,pasex,paname,padob,warddesc,orditemdesc,ordstatus,freq,dosqty)=""
   .s (instruction,duration,drugform)=""
   .s oestatus=$p(data,"^",10)
   .;q:oestatus="D"   					; stopped oedis can't be printed
   .s adm=$p(data,"^",3)
   .s admloc=$p(data,"^",11)
   .i +admloc>0 s admloc=$p(^CTLOC(+admloc),"^",2)
   .i $f(admloc,"-") s admloc=$p(admloc,"-",2)
   .s oedis=$p(data,"^",7)
   .s inci=$p(data,"^",4)
   .s puomID=$p(^INCI(inci,3),"^",6)
   .s exStr=oedis_"^"
   .s uomsp=##Class(web.DHCSTPRICE).GetSp(+inci,+phadate,puomID,HospID,"",exStr)      //整包装价格 //20150115
   .//s uomsp=..getUomPrice(inci,phadate) //整包装价格
   .s incicode=$p(^INCI(inci,1),"^",1)
   .s incidesc=$p(^INCI(inci,1),"^",2)
   .//s spec=##class(web.DHCSTKUTIL).GetSpec(inci)  ;规格
   .s spec=""
   .i inci>0 s spec=##class(web.DHCST.Common.DrugInfoCommon).GetSpec("",inci)
   .;s incidesc=$$GetDesc(incidesc)  ;安徽省立医院增加处理
   .s ordsubcat=..GetArcItmSubCat(inci) ;医嘱子类
   .s uom=..getUom(inci)
   .s drugform=##class(web.DHCSTCOMMONSRV).GetForm(inci)  ;2007-01-13
   .s manf=##class(web.DHCSTITMDESC).GetManfNameByInci(inci)
   .i $p(manf,"-",2)'="" d
   ..s manf=$p(manf,"-",2)
   .s stkbin=..getItmStkBin(inci,phaloc)  ;2007-03-07
   .s generic=##class(web.DHCSTCOMMONSRV).getGeneric(inci)   ;07-03-30  
   .s prescno=$p(data,"^",5)
   .i prescno="" s prescno=+prescno
   .s prescno1=$E(prescno,8,12)   //BY  YULEI  0722
   .s qty=$p(data,"^",6)
   .s resqty=$p(data,"^",12) ;
   .s sp=$fn($p(data,"^",9),"",4)
   .s amt=qty*sp
  . s bed=$p(data,"^",8)  ; bedcode
   .s bedcode=bed
   .;i bed'="" s bedcode=..getBedCode(+bed)
   .s warddesc=..getWardDesc(adm)
   .s tmp=..getPaNo(adm)
   .s pano=$p(tmp,"^",1)
   .q:(pano'=paregno)&(paregno'="")
   .s paname=$p(tmp,"^",2)
   .s pasex=$p(tmp,"^",3)
   .s padob=$p(tmp,"^",4)
   .i padob'="" s padob=$fn((+$h-$zdh(padob,3))/365,"",0)  ;由出生日期->年龄
   .s note=..GetNotes(oedis)
   .s tmp=..getOrdItm(oedis)
   .s orditemdesc=$p(tmp,"^",1)
   .;s ordstatus=$P(tmp,"^",2)   ; status at present time
   .s ordstatus=oestatus		; status when dispensing
   .s freq=$P(tmp,"^",3)
   .s dosqty=$P(tmp,"^",4)
   .s dosqty=$ZCVT(dosqty,"l")
   .s preno=""
   .i +dosqty'=0 s preno=(qty/dosqty)             //BY YULEI  0722
   .s oepresno=$P(tmp,"^",9)    //by YULEI  0722
   .s cyjyfs=$p(tmp,"^",10)  //by YULEI  0802
   .s doseqty2=$p(tmp,"^",11)
   .s doseuom2=$p(tmp,"^",12)
   .s packQty=$p(tmp,"^",13)
   .i packQty'=0  d   //如果医生开了整包装数量，摆药单明细上显示整包装数量
   ..s doseqty2=qty
   ..s doseuom2=uom
   .s doctor=$P(tmp,"^",5)
   .s instruction=$P(tmp,"^",6)
   .s duration=$P(tmp,"^",7)
   .s freqRowid=$P(tmp,"^",8) ; 用药频率rowid
   .s eatdrugtime=..GetFreqTime(freqRowid,"-",",",1,57600)  ; 取用药时间(安徽省立使用)
   .s eatdrugtime=$tr(eatdrugtime,"AaPpMm","")    ;粤北医院使用服药时间格式
   .;s eatdrugtime=..GetFreqTime(freqRowid,"-",",",1,86400)  ; 取用药时间( 积水潭医院使用)
   .i eatdrugtime'="" s eatdrugtime=$zcvt(eatdrugtime,"L")
   .s drugform=##class(web.DHCSTCOMMONSRV).GetForm(inci)  ;2007-01-13
   .s tmpd=..GetOeoriAndSeqNo(oedis)  ;20051107
   .s relateoeori=$p(tmpd,"^",1) ;20051107
   .s seqno=$p(tmpd,"^",2) ;20051107
   .s que=""
   .i phactype="ZCY" d
   ..s que=..Getpaque(prescno) //lq 2008-03-05 取中草药处方信息
   ..s emergency=..GetEmergency(prescno)
   .s remark=##class(web.DHCSTPCHCOLLS2).GetOrdItmRemark($p(oedis,"||",1,2))
   .s manf=##class(web.DHCSTITMDESC).GetManfNameByInci(inci)
   .i $p(manf,"-",2)'="" s manf=$p(manf,"-",2)
   .s stkbin=..getItmStkBin(inci,phaloc)  ;2007-03-07
   .s orddate=..getOrdDate(oedis) ;;2007-03-07
   .s ordtime=..getOrdTime(oedis)
   .s ordsttdate=..getOrdItmSttDate($p(oedis,"||",1),$p(oedis,"||",2)) ;2007-03-23
   .;s ordsttdate=$e(ordsttdate,6,10) //20070720 by yu (粤北医嘱起始日期)
   .s generic=##class(web.DHCSTCOMMONSRV).getGeneric(inci)   ;07-03-30
   .s padiagnose=##class(web.DHCSTKUTIL).GetMRDiagnosDesc(adm,",") ;07-03-30
   .s priority=..OrdItmPriority($p(oedis,"||",1),$p(oedis,"||",2))
   .q:(longord=1)&(priority'="长期医嘱")
   .q:(shortord=1)&(priority="长期医嘱")
   .q:(shortord=1)&(priority="出院带药")
   .i priority="取药医嘱" s freq="备药"          //add by caoting  2011-03-09
   .s pr=$$PrGrp(oedis) 
   .s qtypackuom=$p(^OEORD($p(oedis,"||",1),"I",$p(oedis,"||",2),9),"^",4)
   .s specinstr=$p(^OEORD(ord,"I",itm,2),"^",8) ;中草药处方每味药备注   remark --医嘱备注
   .
   .;-----------中草药-----------
   .s fac=..getPackUomConFac(+oedis,$p(oedis,"||",2))
   .s amtsingle=+dosqty*fac*sp
   .i amtsingle<1 s amtsingle=0_amtsingle
   .;------累加生成中草药单付价格,一条医嘱如果发药时多个批次,只累加一次
   .i '$d(^TMP(newpid,"PrintZCY","OEORD",pano,prescno,oedis)) d
   ..i $d(^TMP(newpid,"PrintZCY","ZCYAMT",pano,prescno)) &(phactype="ZCY")  s ^TMP(newpid,"PrintZCY","ZCYAMT",pano,prescno)=amtsingle+^TMP(newpid,"PrintZCY","ZCYAMT",pano,prescno)
   ..i '$d(^TMP(newpid,"PrintZCY","ZCYAMT",pano,prescno)) &(phactype="ZCY") s ^TMP(newpid,"PrintZCY","ZCYAMT",pano,prescno)=amtsingle
   .
   .i phactype="ZCY" d
   ..s dosqty=dosqty_" "_specinstr ;
   ..s ^TMP(newpid,"PrintZCY","OEORD",pano,prescno,oedis)=""
   ..;s maxqty=..GetArcItmMaxQty(+inclb)
   ..;i +dosqty>maxqty s dosqty=dosqty_"["_doctor_"]"
   .;---------------------------
   .s freqfac=$p(^PHCFR(freqRowid),"^",2)
   .s qtyfac=qty\freqfac  //数了几顿的药
   .s papmi=$p(^PAADM(adm),"^",1)
   .s medicareno=##class(web.DHCSTINTERFACE).GetMrNoByEpisodeID(adm)  //$p(^PAPER(+papmi,"PAT",1),"^",22)
   .s i=i+1 
   .
   .s s1=pano_"^"_paname_"^"_pasex_"^"_padob_"^"_warddesc
   .s s2=bedcode_"^"_admloc_"^"_prescno_"^"_doctor_"^"_incicode
   .s s3=incidesc_"^"_orditemdesc_"^"_ordstatus_"^"_dosqty_"^"_freq
   .s s4=qty_"^"_uom_"^"_sp_"@"_uomsp_"^"_amt_"^"_incibatno
   .s s5=instruction_"^"_duration_"^"_relateoeori_"^"_seqno_"^"_remark  ;20051107
   .s s6=inci_"^"_$g(manf)_"^"_$g(drugform)_"^"_+$g(resqty)_"^"_$g(spec)
   .s s7=$g(eatdrugtime)_"^"_$g(stkbin)_"^"_$g(orddate)_" "_ordtime_"^"_$g(ordsttdate)_"^"_$g(padiagnose)
   .s s8=$g(generic)_"^"_$g(priority)_"^"_$g(oepresno)_"^"_$g(preno)_"^"_$g(prescno1)
   .s s9=$g(cyjyfs)_"^"_$g(que)_"^"_ordsubcat_"^"_$g(emergency)_"^"_$g(qtyfac)_"^"_doseqty2_"^"_doseuom2 ;后面还接着一个"^单付草药价格" lq
   .s s10=inci_"^"_medicareno
   .;------------------以下是明细 -------------------------
   .s packedCat=##class(web.DHCSTPCHCOLLS).getPackedCat() ;需分散整包装打印时,药品类别设置
   .i $f(packedCat,phactype)>0 d 
   ..i qtypackuom="" d   ;散包装医嘱
   ...s ^TMP(newpid,"PRNDISPD","REGNO","BED"_bedcode,pano,pr,"0",i)=s1_"^"_s2_"^"_s3_"^"_s4_"^"_s5_"^"_s6_"^"_s7_"^"_s8_"^"_s9_"^"_s10		
   ..e  d   ;整包装医嘱 
   ...s ^TMP(newpid,"PRNDISPD","REGNO","BED"_bedcode,pano,pr,"1",i)=s1_"^"_s2_"^"_s3_"^"_s4_"^"_s5_"^"_s6_"^"_s7_"^"_s8_"^"_s9_"^"_s10	
   .;不分整散	
   .i ($f(packedCat,phactype)=0)&&(phactype'="ZCY") d
   ..s ^TMP(newpid,"PRNDISPD","REGNO","BED"_bedcode,pano,pr,"0",i)=s1_"^"_s2_"^"_s3_"^"_s4_"^"_s5_"^"_s6_"^"_s7_"^"_s8_"^"_s9_"^"_s10	
   .;中草药
   .i phactype="ZCY" s ^TMP(newpid,"PrintZCY","ZCY",pano,prescno,relateoeori,seqno)=s1_"^"_s2_"^"_s3_"^"_s4_"^"_s5_"^"_s6_"^"_s7_"^"_s8_"^"_s9_"^"_s10
   . 
   .;------------------以下是汇总 -------------------------
   .i stkbin'="" s incicode=stkbin_"_"_incicode  ;汇总按货位排序
   .i $d(^TMP(newpid,"PRNDISPDTOTAL",incicode)) d
   .. s $p(^TMP(newpid,"PRNDISPDTOTAL",incicode),"^",5)=$p(^TMP(newpid,"PRNDISPDTOTAL",incicode),"^",5)+qty
   .. s $p(^TMP(newpid,"PRNDISPDTOTAL",incicode),"^",6)=$p(^TMP(newpid,"PRNDISPDTOTAL",incicode),"^",6)+amt
   .. s resqty=+$g(resqty)
   .. s $p(^TMP(newpid,"PRNDISPDTOTAL",incicode),"^",10)=$p(^TMP(newpid,"PRNDISPDTOTAL",incicode),"^",10)+resqty
   .. s $p(^TMP(newpid,"PRNDISPDTOTAL",incicode),"^",16)=$p(^TMP(newpid,"PRNDISPDTOTAL",incicode),"^",5)-$p(^TMP(newpid,"PRNDISPDTOTAL",incicode),"^",10)
   .e  d
   ..s facqty=qty-resqty
   ..s ^TMP(newpid,"PRNDISPDTOTAL",incicode)=incicode_"^"_incidesc_"^"_sp_"^"_uom_"^"_qty_"^"_amt_"^"_+inclb_"^"_$g(manf)_"^"_$g(drugform)_"^"_+$g(resqty)_"^"_$g(stkbin)_"^"_$g(generic)_"^"_$g(spec)_"^"_admloc_"^"_$g(note)_"^"_facqty  ; 20051207 add "+inclb",2007-7-28,add spec
   .
   .;------------------旧版的,不知新版的哪家医院用,暂屏蔽,LiangQiang----------------------------
   .i bedcode="" s bedcode="未知"
   .i $d(^TMP(newpid,"PRNDISPDTOTAL",incicode,bedcode)) d
   .. s $p(^TMP(newpid,"PRNDISPDTOTAL",incicode,bedcode),"/",1)=$p(^TMP(newpid,"PRNDISPDTOTAL",incicode,bedcode),"/",1)+qty
   .e  d
   .. s ^TMP(newpid,"PRNDISPDTOTAL",incicode,bedcode)=qty_"/"_$tr(bedcode,"床","")
   .;s sortsp=$fn(sp,"",4)*10000
   .;i '$d(^TMP(newpid,"SORTSP",sortsp,incicode)) s ^TMP(newpid,"SORTSP",sortsp,incicode)=incicode
   .
   .;------------------汇总某一个患者长嘱滚动医嘱明细,沈阳--------------------------
   .d SetDispInfo 
   .s tmpstr=s1_"^"_s2_"^"_s3_"^"_s4_"^"_s5_"^"_s6_"^"_s7_"^"_s8_"^"_s9 
   .s ret=..SetDispInfoByFreq(main, freqRowid, tmpstr, newpid)
   ;d CreateCodeList
   i phactype="ZCY" s i=$$Listpano()  ;中草药明细最大值
   
 q i_"^"_newpid
GetDesc(desc)
   //去掉药品名称中的标示字符<安徽省立>
   s desc=$tr(desc,"$","")
   s desc=$tr(desc,"#","")
   s desc=$tr(desc,"*","")
   s desc=$tr(desc,"@","")
   q desc
CreateCodeList
  //按药品的售价排序<安徽省立>
  s ch=""
  s mm=0
  f  s ch=$o(^TMP(newpid,"SORTSP",ch)) q:ch=""  d
  .s code="" f  s code=$o(^TMP(newpid,"SORTSP",ch,code)) q:code=""  d
  ..s mm=mm+1
  ..s ^TMP(newpid,"SORTSPCODE",mm)=code
  k ^TMP(newpid,"SORTSP")
  q
PrGrp(oedis)
 //根据医嘱优先级归类
 //长嘱:0
 //其他:1
 n (oedis)
 s pr=$p(^OEORD($p(oedis,"||",1),"I",$p(oedis,"||",2),1),"^",8)
 s pr=$P($g(^OECPR(pr)),"^",2)
 i pr="S" s pr=0
 e  s pr=1
 q $g(pr)
Listpano()
 ;以病历号排序构造中草药打印数据
 s pano=""
 s num=0
 f  s pano=$o(^TMP(newpid,"PrintZCY","ZCY",pano)) q:pano=""  d
 .s prescno=""
 .f  s prescno=$o(^TMP(newpid,"PrintZCY","ZCY",pano,prescno)) q:prescno=""  d
 ..s seqno=""
 ..f  s seqno=$o(^TMP(newpid,"PrintZCY","ZCY",pano,prescno,seqno)) q:seqno=""  d 
 ...s relateid=""
 ...f  s relateid=$o(^TMP(newpid,"PrintZCY","ZCY",pano,prescno,seqno,relateid)) q:relateid=""  d
 ....s num=num+1
 ....;i ^TMP(newpid,"PrintZCY","ZCYAMT",pano,prescno)<1 s ^TMP(newpid,"PrintZCY","ZCYAMT",pano,prescno)=0_^TMP(newpid,"PrintZCY","ZCYAMT",pano,prescno)
 ....s ^TMP(newpid,"PZCY",num)=^TMP(newpid,"PrintZCY","ZCY",pano,prescno,seqno,relateid)_"^"_^TMP(newpid,"PrintZCY","ZCYAMT",pano,prescno)
 k ^TMP(newpid,"PrintZCY") 
 q num
SetDispInfo
    ;汇总某一个患者长嘱滚动医嘱明细,
    s dispinfo=s1_"^"_s2_"^"_s3_"^"_s4_"^"_s5_"^"_s6_"^"_s7_"^"_s8_"^"_s9
    s ord=+oedis
    s itm=$p(oedis,"||",2)
    s bed=$p(dispinfo,"^",6)
    i $g(bed)="" s bed=+$g(bed)
	s patno=$p(dispinfo,"^",1)
	s qty=$p(dispinfo,"^",16)
	s amt=$p(dispinfo,"^",19)
	s ordenddate=$p(dispinfo,"^",34)
 	s fillerno=$p(^OEORD(ord,"I",itm,9),"^",12)
 	i fillerno="" d
 	.s mainord=oedis
 	e  d
 	.s mainord=$p(fillerno,"!!",1)
 	s prescno=$p(^OEORD(+mainord,"I",$p(mainord,"||",2),1),"^",14)
 	i $g(prescno)="" s prescno=+$g(prescno)
 	i '$d(^TMP("HZOnePat",newpid,bed,patno,prescno,mainord)) d
 	.s ^TMP("HZOnePat",newpid,bed,patno,prescno,mainord)=dispinfo
 	e  d
 	.s orddate=$p(orddate,"||",1)_"||"_ordenddate
	.s $p(^TMP("HZOnePat",newpid,bed,patno,prescno,mainord),"^",16)=$p(^TMP("HZOnePat",newpid,bed,patno,prescno,mainord),"^",16)+qty
	.s $p(^TMP("HZOnePat",newpid,bed,patno,prescno,mainord),"^",19)=$p(^TMP("HZOnePat",newpid,bed,patno,prescno,mainord),"^",19)+amt
	.s $p(^TMP("HZOnePat",newpid,bed,patno,prescno,mainord),"^",34)=orddate
    q
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
	;
	s ordstatus=$p(^OEC("OSTAT",$p(^OEORD(ord,"I",itm,1),"^",13)),"^",2) 
	s freq=$p(^OEORD(ord,"I",itm,2),"^",4)
	s freqRowid=freq
	i +freq>0 s freq=$ZCVT($p(^PHCFR(+freq),"^",1),"L")
	s doctor=$p(^OEORD(ord,"I",itm,1),"^",11)
	i +doctor>0 s doctor=$p(^CTPCP(+doctor,1),"^",2)
	s instruction=$p(^OEORD(ord,"I",itm,2),"^",7)
	i instruction'="" s instruction=$p(^PHCIN(+instruction),"^",2)
	s duration=$p(^OEORD(ord,"I",itm,2),"^",6)
	i duration'="" s duration=$p(^PHCDU(+duration),"^",3)
	s oepresno=$p(^OEORD(ord,"I",itm,"DEP",1),"^")
	s cyjyfs=$p(^OEORD(ord,"I",itm,2),"^",8)
	s doseqtyuom=..getBUomDoseQty(ord,itm)
	s packQty=+$p(^OEORD(ord,"I",itm,9),"^",4)		//整包装数量
	;w $g(arcimdesc)_"^"_$g(ordstatus)_"^"_$g(freq)_"^"_$g(doseqty)_"^"_$g(doctor)_"^"_$g(instruction)_"^"_$g(duration)_"^"_$g(freqRowid)_"^"_$g(oepresno)_"^"_$g(cyjyfs)_"^"_doseqtyuom_"^"_packQty
	q $g(arcimdesc)_"^"_$g(ordstatus)_"^"_$g(freq)_"^"_$g(doseqty)_"^"_$g(doctor)_"^"_$g(instruction)_"^"_$g(duration)_"^"_$g(freqRowid)_"^"_$g(oepresno)_"^"_$g(cyjyfs)_"^"_doseqtyuom_"^"_packQty
}

ClassMethod getPackUomDoseQty(ord, itm)
{
	n (ord,itm)
	s doseqty=$p(^OEORD(ord,"I",itm,2),"^",1)
	;get dose-equiv
	q:doseqty="" ""
	s doseqty=##class(web.DHCSTKUTIL).NN(doseqty)  ;调整数字（使小数点前的"0"能够显示）
	s arcim=$p(^OEORD(ord,"I",itm,1),"^",2) q:arcim="" ""
	s sub=$p(arcim,"||",1),ver=$p(arcim,"||",2)
	s phcdf=$p(^ARCIM(sub,ver,1),"^",12)
	s doseunit=$p(^OEORD(ord,"I",itm,2),"^",3)
	i doseunit'="" s doseunit=$p(^CT("UOM",doseunit),"^",2)
	q:phcdf="" ""
	q doseqty_doseunit
}

ClassMethod getPackUomConFac(ord, itm)
{
	n (ord,itm)
	
	s arcim=$p(^OEORD(ord,"I",itm,1),"^",2) q:arcim="" ""
	s sub=$p(arcim,"||",1),ver=$p(arcim,"||",2)
	s phcdf=$p(^ARCIM(sub,ver,1),"^",12)
	s doseunit=$p(^OEORD(ord,"I",itm,2),"^",3)
	i doseunit'="" s doseunit=$p(^CT("UOM",doseunit),"^",2)
	q:phcdf="" ""
	
	&sql(select PHCDF_CTUOM_DR->ctuom_desc into :buom
		from phc_drgform where phcdf_rowid=:phcdf)

    s fac=##class(web.DHCSTCOMMONSRV).CTUOMFactor(doseunit,buom)

	q $g(fac)
}

ClassMethod getPackUom(ord, itm)
{
	n (ord,itm)
	s doseunit=$p(^OEORD(ord,"I",itm,2),"^",3)
	i doseunit'="" s doseunit=$p(^CT("UOM",doseunit),"^",2)
	q $g(doseunit)
}

ClassMethod getBatNo(inclb As %String) As %String
{
	n (inclb)
	q:inclb="" ""
	&sql(select inclb_incib_dr->incib_no into :batno from inc_itmlcbt where inclb_rowid=:inclb)
	q $g(batno)
}

ClassMethod getUom(inci As %String) As %String
{
	n (inci)
	q:inci'>0 ""
	s uom=$p(^INCI(inci,1),"^",10)
	i +uom>0 s uom=$p(^CT("UOM",+uom),"^",2)
	q uom
}

ClassMethod ListDetailTotalBed(incicode As %String, pid As %String) As %String
{
	n (incicode,pid)
	s tmp=$o(^TMP(pid,"PRNDISPDTOTAL",incicode))
	q:tmp="" ""
	s currincicode=$p(^TMP(pid,"PRNDISPDTOTAL",tmp),"^",1)
	i $f(currincicode,"_") s currincicode=$p(currincicode,"_",2)
	s qty=$p(^TMP(pid,"PRNDISPDTOTAL",tmp),"^",5)

	s bedsum=$$getBedData(tmp,pid)
	q ^TMP(pid,"PRNDISPDTOTAL",tmp)_"^"_$g(bedsum)	
	
getBedData(incicode,pid)
	 n (incicode,pid)
	 s bed=""
	 s sum=""
	 f  s bed=$o(^TMP(pid,"PRNDISPDTOTAL",incicode,bed)) q:bed=""  d
	 . i sum="" s sum=^TMP(pid,"PRNDISPDTOTAL",incicode,bed)
	 . e   s sum=sum_","_^TMP(pid,"PRNDISPDTOTAL",incicode,bed)
	 q $g(sum)
}

ClassMethod ListDetailTotal(incicode As %String, pid As %String) As %String
{
	n (incicode,pid)
	s tmp=$o(^TMP(pid,"PRNDISPDTOTAL",incicode))
	q:tmp="" ""
	; 转换成整包装数量(including uom desc) :  LQ
	s currincicode=$p(^TMP(pid,"PRNDISPDTOTAL",tmp),"^",1)
	i $f(currincicode,"_") s currincicode=$p(currincicode,"_",2)
	s inci=##class(web.DHCSTCOMMONSRV).ItemCodeToID(currincicode)
	s qty=$p(^TMP(pid,"PRNDISPDTOTAL",tmp),"^",5)
	s resqty=$p(^TMP(pid,"PRNDISPDTOTAL",tmp),"^",10)
	s facqty=$p(^TMP(pid,"PRNDISPDTOTAL",tmp),"^",16)
	s $p(^TMP(pid,"PRNDISPDTOTAL",tmp),"^",5) =..getPackQty(inci,qty)
	s $p(^TMP(pid,"PRNDISPDTOTAL",tmp),"^",10)=..getPackQty(inci,resqty)
	s $p(^TMP(pid,"PRNDISPDTOTAL",tmp),"^",16)=..getPackQty(inci,facqty)
	;
	q ^TMP(pid,"PRNDISPDTOTAL",tmp)
}

ClassMethod ListDetailTotal2(mm As %String, pid As %String) As %String
{
 
	n (mm,pid)
 ;	s tmp=$o(^TMP(pid,"SORTSPCODE",mm))
 ;	q:tmp="" ""
	q:'$d(^TMP(pid,"SORTSPCODE",mm)) ""
	s currincicode=^TMP(pid,"SORTSPCODE",mm)
	s bedsum=$$getBedSum(currincicode,pid)
	;q ^(tmp)
	q ^TMP(pid,"PRNDISPDTOTAL",currincicode)_"^"_$g(bedsum)	
getBedSum(incicode,pid)
 n (incicode,pid)
 s bed=""
 s sum=""
 f  s bed=$o(^TMP(pid,"PRNDISPDTOTAL",incicode,bed)) q:bed=""  d
 . i sum="" s sum=^TMP(pid,"PRNDISPDTOTAL",incicode,bed)
 . e   s sum=sum_" "_^TMP(pid,"PRNDISPDTOTAL",incicode,bed)
 q $g(sum)
}

ClassMethod CLEARTMP(pid As %String, tmpname As %String) As %String
{
	q:pid="" ""
	k ^TMP(pid,tmpname) 
	q ""
}

ClassMethod GetOeoriAndSeqNo(oedis As %String) As %String
{
 n (oedis)
 q:oedis="" "^"
 s ord=$p(oedis,"||",1)
 s itm=$p(oedis,"||",2)
 q:ord="" "^"
 q:itm="" "^"
 s OEORIDR=$P(^OEORD(ord,"I",itm,11),"^",39)
 i OEORIDR="" s OEORIDR=ord_"||"_itm
 s seqno=$p(^OEORD(ord,"I",itm,3),"^",4)
 q OEORIDR_"^"_seqno
}

ClassMethod Getpaque(prescno As %String) As %String
{
   ;获得中草药信息 PA_Que1 
   n (prescno)
   q:prescno="" ""
   s queid=""
   s questr=""
   s i=1
   f  s queid=$o(^PAQUE1(0,"PrescNo",prescno,queid)) q:queid=""  d
   .q:'$d(^PAQUE1(queid,"DHC")) 
   .s insdr=$p(^PAQUE1(queid,"DHC"),"^",11)
   .s Instruc=$p(^PHCIN(insdr),"^",1) ;用法
   .s durdr=$p(^PAQUE1(queid,"DHC"),"^",10)
   .s facotor=$p(^PHCDU(durdr),"^",2) ;剂数
   .s orderqty=$p(^PAQUE1(queid,"DHC"),"^",13) ;用量
   .s quedate=$p(^PAQUE1(queid,"DHC"),"^",6) ;开始时间
   .s quexdate=quedate+facotor-1
   .i $g(quedate)'="" s quedate=$zd(quedate,3)
   .i $g(quexdate)'="" s quexdate=$zd(quexdate,3)
   .s preno=$p(^PAQUE1(queid),"^",14) ;处方号
   .s type=$p(^PAQUE1(queid,"DHC"),"^",15) ;方式
   .s notes=$p(^PAQUE1(queid,"DHC"),"^",21) ;备注
   .
   .s questr=Instruc_"^"_facotor_"^"_orderqty_"^"_$g(quedate)_"^"_$g(quexdate)_"^"_notes_"^"_type
   .s i=i+1
   q $g(questr)
}

ClassMethod GetEmergency(prescno As %String) As %String
{
   ;获得中草药信息:急煎标志 
   n (prescno) 
   s queid=""
   s questr=""
   s i=1
   f  s queid=$o(^PAQUE1(0,"PrescNo",prescno,queid)) q:queid=""  d
   .q:'$d(^PAQUE1(queid,"DHC")) 
   .s emergency=$p(^PAQUE1(queid,"DHC"),"^",22)
   .i emergency="Y" s emergency="(急煎)"
   .e  s emergency=""
   .s i=i+1
   q $g(emergency)
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
	. s result=packqty_""_puomdesc
	i restqty>0 d
	. i result'="" d
	. . s result=result_""_restqty_""_buomdesc
	. e  d
	. . s result=restqty_""_buomdesc
	q result
}

/// Creator:Liang Qiang  
/// CreatDate:2009-01-04
/// Description:转换成整包装数量 
/// Input: inci:inc_itmRowid   qty:基本单位数量
/// Output: XX合xx片
/// Return: XX合xx片
/// Others:w ##class(web.DHCSTPCHCOLLPRN).getPackQty(858,0.333333333333333333)
ClassMethod getPackQty(inci, qty) As %String
{
	n (inci,qty)
	;s inci=##class(web.DHCSTCOMMONSRV).ItemCodeToID(incicode)
	q:+qty=0 0
	s result=""
	s buom=+$p(^INCI(inci,1),"^",10)  ; basic uom
	s puom=+$p(^INCI(inci,3),"^",6)  ; 
	i puom="" s puom=buom
	s buomdesc=$p(^CT("UOM",buom),"^",2)
	s puomdesc=$p(^CT("UOM",puom),"^",2)
	;i $f(puomdesc,"(") s puomdesc=$p(puomdesc,"(",1)
	;
	s fac=##class(web.DHCSTCOMMONSRV).UOMFac(puom,buom)
	s packqty=qty\fac
	s restqty=qty-(packqty*fac)
	i packqty'=0 d
	. s result=packqty_""_puomdesc
	i (packqty<0)&(restqty<0) s restqty=-restqty
	s fmtrestqty=restqty
	i $l($p(fmtrestqty,".",2))>5 s fmtrestqty=$fn(fmtrestqty,"",5)
	i restqty'=0 d
	. i result'="" d
	. . s result=result_""_fmtrestqty_""_buomdesc
	. e  d
	. . s result=fmtrestqty_""_buomdesc
	
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

ClassMethod GetPhaci(oedis As %String) As %String
{
	s sp=""
	s phac=$o(^DHCPHAC(0,"PHADSP",oedis,"")) q:phac="" -1
	s ch=$o(^DHCPHAC(0,"PHADSP",oedis,phac,"")) q:ch="" -2
	s sp=$p(^DHCPHAC(phac,"I",ch),"^",9)
	q sp
}

/// Creator:Liang Qiang
/// CreatDate:2009-04-20
/// Description:获取发药打印单明细信息,单个患者N天滚动的相同医嘱汇总
/// Input:发药主表Rowid
/// Output:记录数_"^"_进程号_"^"_0
/// Return:记录数_"^"_进程号_"^"_0
/// Others:
ClassMethod GetDispHZOrd(phac As %String) As %String
{
 s result=..GetPhaCollDetail(phac)
 s cnt=$p(result,"^",1)
 s pid=$p(result,"^",2) 
 s n=0
 i cnt>0 d
 .s n=..CreatePatList(pid) 
 q $g(n)_"^"_$g(pid)_"^"_$g(m)
}

/// Creator:Liang Qiang
/// CreatDate:2009-04-20
/// Description:返回发药打印单明细信息,
/// Input:进程号 ,  记录序号
/// Output:明细信息
/// Return:明细信息
/// Others:
ClassMethod ListDispHZOrd(pid As %String, n As %String) As %String
{
	n (pid,n)
	q:pid="" ""
	q:n="" ""
	q:'$D(^TMP("ListOnePat",pid,n)) ""
	s str=^TMP("ListOnePat",pid,n)
	q:str="" ""
	k ^TMP("ListOnePat",pid,n)
	q str
}

ClassMethod GetDispDetail(phac As %String) As %String
{
 s result=..GetPhaCollDetail(phac)
 s cnt=$p(result,"^",1)
 s pid=$p(result,"^",2) 
 q:$d(^TMP(pid,"PZCY")) cnt_"^"_pid_"^"_0   //如果是打印中草药则退出   
 ;
 s n=0
 s m=0
 
 i cnt>0 d
 . s bedbed=""
 . f  s bedbed=$o(^TMP(pid,"PRNDISPD","REGNO",bedbed))  q:bedbed=""  d
 . . s panopano=""
 . . f  s panopano=$o(^TMP(pid,"PRNDISPD","REGNO",bedbed,panopano)) q:panopano=""  d
 . . . s pr=""
 . . . f  s pr=$o(^TMP(pid,"PRNDISPD","REGNO",bedbed,panopano,pr)) q:pr=""  d
 . . . . s pack=""
 . . . . f  s pack=$o(^TMP(pid,"PRNDISPD","REGNO",bedbed,panopano,pr,pack)) q:pack=""  d
 . . . . . s j=""
 . . . . . f  s j=$o(^TMP(pid,"PRNDISPD","REGNO",bedbed,panopano,pr,pack,j)) q:j=""  d
 . . . . . .
 . . . . . . s tmpdata=^(j)
 . . . . . . //s ^tmpbe(n)=pid_"^"_bedbed
 . . . . . . s pano=$p(tmpdata,"^",1)
 . . . . . . s paname=$p(tmpdata,"^",2)
 . . . . . . s pasex=$p(tmpdata,"^",3)
 . . . . . . s padob=$p(tmpdata,"^",4)
 . . . . . . s warddesc=$p(tmpdata,"^",5)
 . . . . . . s bedcode=$p(tmpdata,"^",6)
 . . . . . . s admloc=$p(tmpdata,"^",7)
 . . . . . . s prescno=$p(tmpdata,"^",8)
 . . . . . . s doctor=$p(tmpdata,"^",9)
 . . . . . . s incicode=$p(tmpdata,"^",10)
 . . . . . . s incidesc=$p(tmpdata,"^",11)
 . . . . . . s orditemdesc=$p(tmpdata,"^",12)
 . . . . . . s ordstatus=$p(tmpdata,"^",13)
 . . . . . . s dosqty=$p(tmpdata,"^",14)
 . . . . . . s freq=$p(tmpdata,"^",15)
 . . . . . . s qty=$p(tmpdata,"^",16)
 . . . . . . s uom=$p(tmpdata,"^",17)
 . . . . . . s sp=$p(tmpdata,"^",18)
 . . . . . . s amt=$p(tmpdata,"^",19)
 . . . . . . s incibatno=$p(tmpdata,"^",20)
 . . . . . . s instruction=$p(tmpdata,"^",21)
 . . . . . . s duration=$p(tmpdata,"^",22)
 . . . . . . s OEORI=$p(tmpdata,"^",23)
 . . . . . . s SeqNo=$p(tmpdata,"^",24)
 . . . . . . s remark=$p(tmpdata,"^",25)
 . . . . . . s inci=$p(tmpdata,"^",26)  ; 20051207
 . . . . . . s manf=$p(tmpdata,"^",27)
 . . . . . . ;s uom=..getIntPackQty(inci,qty,phactype) ;20051207 - including uom desc
 . . . . . . s spec=$p(tmpdata,"^",30)
 . . . . . .
 . . . . . . s eatdrugtime=$p(tmpdata,"^",31)
 . . . . . . s stkbin=$p(tmpdata,"^",32)
 . . . . . . s orddate=$p(tmpdata,"^",33)
 . . . . . . s ordsttdate=$p(tmpdata,"^",34)
 . . . . . .
 . . . . . . s diagnose=$p(tmpdata,"^",35)
 . . . . . . s generic=$p(tmpdata,"^",36)
 . . . . . . s priority=$p(tmpdata,"^",37)
 . . . . . . 
 . . . . . . s oepresno=$p(tmpdata,"^",38)
 . . . . . . s preno=$p(tmpdata,"^",39)
 . . . . . . s prescno1=$p(tmpdata,"^",40)
 . . . . . . s cyjyfs=$p(tmpdata,"^",41)
 . . . . . . 
 . . . . . . s drugform=##class(web.DHCSTCOMMONSRV).GetForm(inci) 
 . . . . . . s action=$p(tmpdata,"^",42)
 . . . . . . s qtyfac=$p(tmpdata,"^",45)
 . . . . . . s doseqty2=$p(tmpdata,"^",46)
 . . . . . . s doseuom2=$p(tmpdata,"^",47)
 . . . . . . s incirowid=$p(tmpdata,"^",48)
 . . . . . . ; 
 . . . . . . s inci=##class(web.DHCSTCOMMONSRV).ItemCodeToID(incicode)
 . . . . . . s qty=..getPackQty(inci,qty) ;转换成整包装数量(including uom desc) :  LQ
 . . . . . . ;
 . . . . . . s a1=pano_"^"_paname_"^"_pasex_"^"_padob_"^"_warddesc
 . . . . . . s a2=bedcode_"^"_admloc_"^"_prescno_"^"_doctor_"^"_incicode
 . . . . . . s a3=incidesc_"^"_orditemdesc_"^"_ordstatus_"^"_dosqty_"^"_freq
 . . . . . . s a4=qty_"^"_uom_"^"_sp_"^"_amt_"^"_incibatno
 . . . . . . s a5=instruction_"^"_duration_"^"_OEORI_"^"_SeqNo_"^"_remark
 . . . . . . s a6=manf_"^"_spec_"^"_eatdrugtime_"^"_stkbin_"^"_orddate
 . . . . . . s a7=ordsttdate_"^"_$g(diagnose)_"^"_$g(generic)_"^"_$g(priority)_"^"_$g(oepresno)
 . . . . . . s a8=$g(preno)_"^"_$g(prescno1)_"^"_$g(cyjyfs)_"^"_$g(drugform)_"^"_$g(action)
 . . . . . . s a9=qtyfac_"^"_doseqty2_"^"_doseuom2
 . . . . . . s a10=incirowid
 . . . . . . i pack=0 d
 . . . . . . . s n=n+1
 . . . . . . . s ^TMP(pid,"PRNDISPBYREGNO",n)=a1_"^"_a2_"^"_a3_"^"_a4_"^"_a5_"^"_a6_"^"_a7_"^"_a8_"^"_a9_"^"_a10
 . . . . . . i pack=1 d
 . . . . . . . s m=m+1
 . . . . . . . s ^TMP(pid,"PRNDISPBYREGNO","PACK",m)=a1_"^"_a2_"^"_a3_"^"_a4_"^"_a5_"^"_a6_"^"_a7_"^"_a8_"^"_a9_"^"_a10
 . . . . . . . 
 q $g(n)_"^"_$g(pid)_"^"_$g(m)
}

ClassMethod ListDispDetail(pid As %String, n As %String) As %String
{
	
	q ^TMP(pid,"PRNDISPBYREGNO",n)
}

ClassMethod ListDispDetailPack(pid As %String, m As %String) As %String
{
	q ^TMP(pid,"PRNDISPBYREGNO","PACK",m)
}

ClassMethod KillTmpGlobal(pid As %String)
{
 q:pid=""
 d ..CLEARTMP(pid,"PRNDISPD")
 d ..CLEARTMP(pid,"PRNDISPDTOTAL")
 d ..CLEARTMP(pid,"SORTSPCODE")
 d ..CLEARTMP(pid,"MZ")
 d ..CLEARTMP(pid,"PRNDISPBYREGNO")
 d ..CLEARTMP(pid,"PZCY")
 d ..CLEARTMP(pid,"PrintZCY")
 k ^TMP("dhcpha",pid,"DispFreq")
 k ^TMP("dhcpha",pid,"LISTDISPFREQ")
 k ^TMP("HZOnePat",pid)
 k ^TMP("ListOnePat",pid)
 q
}

ClassMethod GetDispMZ(phac As %String) As %String
{
 ;取出麻醉打印的信息
 s result=..GetPhaCollDetail(phac)
 s cnt=$p(result,"^",1)
 s pid=$p(result,"^",2)
 q:cnt>0 pid
 q ""
}

ClassMethod ListDispMZ(pid As %String, incicode As %String) As %String
{
  //get main
  s incicode=$o(^TMP(pid,"MZ",incicode))
  q:incicode="" ""
  s main=^TMP(pid,"MZ",incicode)
  ;incicode_"^"_incidesc+"^"_qty_"^"_uom_"^"_amt_"^"_$g(manf)_"^"_$g(drugform)
  s detail=""
  s ch=""
  f  s ch=$o(^TMP(pid,"MZ",incicode,ch)) q:ch=""  s data=^(ch) d
  . i detail="" s detail=data
  . e     s detail=detail_"^"_data
  q main_"!"_detail
}

ClassMethod GetDoctorLocDesc(phac As %String) As %String
{
 //取第一行发药明细的UserAddDept
 s ch=$o(^DHCPHAC(phac,"I","") )
 q:ch="" ""	
 s oedis=$p(^DHCPHAC(phac,"I",ch),"^",7)	
 s ord=$p(oedis,"||",1)
 s itm=$p(oedis,"||",2)
 q:'$d(^OEORD(ord,"I",itm,7)) ""
 s useradddept=$p(^OEORD(ord,"I",itm,7),"^",2)	
 i useradddept'="" s useradddept=$p(^CTLOC(useradddept),"^",2)
 q $g(useradddept)
}

ClassMethod DispTypeNameMZ(phac As %String) As %String
{
 q:phac="" ""
 s disptype=$p(^DHCPHAC(phac),"^",12)	
 s disptype=$$ALPHAUP^SSUTIL4(disptype)
 i disptype["DMY" q "麻药" 
 q "常规药"
}

ClassMethod GetFreqTime(freq, dateConStr, delimiter, date, dateStartTime) As %String
{
 //取频次时间,如果有日期date则输出日期,如果频次时间小于dateStartTime
 n (freq, delimiter,dateConStr, date, dateStartTime)
 q:$g(freq)="" ""
 ;s frw=""  s frw=$o(^PHCFR(0,"Code",$$ALPHAUP^SSUTIL4(freq),frw),-1)
 s frw=freq
 if frw'=""
 {	
	k ^TMP("NurFreq",$j)
	s chl=0  f  s chl=$o(^PHCFR(frw,"DT",chl))  q:chl=""  d
 		.s frtDate=""
 		.i date'="" d
 		    ..i $p(^PHCFR(frw,"DT",chl),"^",1)<dateStartTime s frtDate=$zd(date+1,3)_" "
 		    ..e  s frtDate=$zd(date,3)_" "
 		    ..s frtDate=$tr(frtDate,"-",dateConStr)
 		.s timeStr=$zt(^PHCFR(frw,"DT",chl),2)
 		.i $p(^PHCFR(frw,"DT",chl),"^",1)>86300 s timeStr="00:00"
 		.//s $p(timeStr,":",1)=+$p(timeStr,":",1)
 		.//i $p(timeStr,":",2)'>0 s timeStr=$p(timeStr,":",1)
 		.s tmpList(frtDate_timeStr)=""
 	s frtDateTime="",frtDateTimeStr=""
 	f  s frtDateTime=$o(tmpList(frtDateTime)) q:frtDateTime=""  d
	.i frtDateTimeStr'="" s frtDateTimeStr=frtDateTimeStr_delimiter
	.s frtDateTimeStr=$G(frtDateTimeStr)_frtDateTime
 }
 s a=$G(frtDateTimeStr)
 q:a="" ""
 s cnt=$l(a,delimiter)
 s x=""
 f i=1:1:cnt d
 .s b=$p(a,delimiter,i)
 .s c=$p(b," ",2)
 .q:c=""
 .//s ^TMP("dfd")=c
 .s c=$zth(c)
 .
 .//s c=$zt(c,4)
 .//s c=$tr(c,":","")
 .//s c=$tr(c,"00","")
 .
 .//以下为粤北格式
 .s c=$zt(c,2)
 .s c=$tr(c,":",1)
 .s c=$e(c,1,2)
 .
 .i x="" s x=c
 .e  s x=x_"-"_c
 q $g(x)
}

/// 3.19后增加以下
ClassMethod getStkBin(inclb As %String) As %String
{
 n (inclb)
 s inci=$p(inclb,"||",1)
 s ch=$p(inclb,"||",2)
 q:inci="" ""
 q:ch="" ""
 q:'$d(^INCI(inci,"IL",ch)) ""
 s stkbin=+$p(^INCI(inci,"IL",ch),"^",2)
 q:'$d(^INC("SB",stkbin)) ""
 s stkbindesc=$p(^INC("SB",stkbin),"^",2)
 q stkbindesc
}

// zdm,2012-03-05,根据科室和库存项取货位

ClassMethod getItmStkBin(inci As %String, loc As %String) As %String
{
 n (inci,loc)
 q:loc="" ""
 q:inci="" ""
 s ch=$o(^INCI("IL_LOC",loc,inci,""))
 q:ch="" ""
 q:'$d(^INCI(inci,"IL",ch)) ""
 s stkbin=+$p(^INCI(inci,"IL",ch),"^",2)
 q:'$d(^INC("SB",stkbin)) ""
 s stkbindesc=$p(^INC("SB",stkbin),"^",2)
 q stkbindesc
}

ClassMethod getOrdDate(oedis As %String) As %String
{
  s ord=$p(oedis,"||",1) q:ord="" ""
  s itm=$p(oedis,"||",2) q:itm="" ""
  q:'$d(^OEORD(ord,"I",itm,3)) ""
  s orddate=$p(^OEORD(ord,"I",itm,3),"^",7)	
  i orddate'="" s orddate=$zd(orddate,3)
  q $g(orddate)
}

ClassMethod getPriority(phac As %String) As %String
{
	///获取优先级  lq
 n (phac)
 s ch=$o(^DHCPHAC(phac,"I",0)) q:ch="" ""
 s oedis=$p(^DHCPHAC(phac,"I",ch),"^",7)
 s priority=..OrdItmPriority($p(oedis,"||",1),$p(oedis,"||",2))
 q priority
}

ClassMethod getOrdTime(oedis As %String) As %String
{
	///取医嘱时间lq 
  n (oedis)
  s ord=$p(oedis,"||",1) q:ord="" ""
  s itm=$p(oedis,"||",2) q:itm="" ""
  q:'$d(^OEORD(ord,"I",itm,3)) ""
  s ordtime=$p(^OEORD(ord,"I",itm,1),"^",17)	
  i ordtime'="" s ordtime=$zt(ordtime,2)
  q $g(ordtime)
}

ClassMethod getUserDepartment(phac As %String) As %String
{
 n (phac)
 s ch=$o(^DHCPHAC(phac,"I",0)) q:ch="" ""
 s oedis=$p(^DHCPHAC(phac,"I",ch),"^",7)
 s ord=$p(oedis,"||",1)
 s chl=$p(oedis,"||",2)	
 s userdept=$p(^OEORD(ord,"I",chl,7),"^",2) 
 q:userdept="" ""
 s userdept=$p(^CTLOC(+userdept),"^",2)
 q userdept
}

ClassMethod getOrdItmSttDate(ord As %String, itm As %String) As %String
{
 q:ord="" ""
 q:itm="" ""
 q:'$d(^OEORD(ord,"I",itm,1)) ""
 s sttdate=$p(^OEORD(ord,"I",itm,1),"^",9)
 i sttdate>0 s sttdate=$zd(sttdate,3)
 q sttdate
}

ClassMethod PrnID() As %String
{
  q $I(^DHCSTPHARMACY("PRINTDISP"))
}

ClassMethod getPhacOrdPri(phac As %String) As %String
{
 //取该发药单的医嘱类型:
 //全部是长期医嘱返回"长嘱"
 //全部是非长期医嘱返回"临嘱"
 //若既有长嘱又有非长嘱返回空
 //若有一个出院带药返回空
 n (phac)
 s ch=0
 s ret=0
 s longord=$g(longord)
 s shortord=$g(shortord)
 f  s ch=$o(^DHCPHAC(phac,"I",ch)) q:(ch="")!(ret>0)  d
 . s oedis=$p(^DHCPHAC(phac,"I",ch),"^",7)
 . s ord=$p(oedis,"||",1),chl=$p(oedis,"||",2)
 . s pr=$p(^OEORD(ord,"I",chl,1),"^",8) q:pr=""     
 . s priority=$p(^OECPR(pr),"^",1)                 ;医嘱优先级代码
 . i priority="OUT" s ret=1 q
 . i priority="S" s longord=$g(longord)+1
 . e  s shortord=$g(shortord)+1
 i ret>0 q ""
 i (longord>0) d
 .i (shortord'>0) s result="长嘱"
 .e  s result=""
 e  d
 .i shortord>0 s result="临嘱"
 q $g(result)
}

ClassMethod OrdItmPriority(ord As %String, itm As %String) As %String
{
 n (ord,itm)
 q:ord="" ""
 q:itm="" ""
 
 s pr=$p($g(^OEORD(ord,"I",itm,1)),"^",8)
 q:pr="" ""
 s priority=$P($g(^OECPR(pr)),"^",2)
 q priority
}

ClassMethod ListDetailZCY(pid As %String, h As %String) As %String
{
 q ^TMP(pid,"PZCY",h)
}

ClassMethod GetQueExecute(ByRef qHandle As %Binary, datefrom As %String, dateto As %String, wardrowid As %String) As %Status
{
	//病区审核草药处方
    s repid=$I(^CacheTemp)
    s ind=1
    Set qHandle=$lb(0,repid,0)
    q:datefrom="" $$$OK
    q:dateto="" $$$OK
    q:wardrowid="" $$$OK
    
    f date=datefrom:1:dateto d
    .s labid="" f  s labid=$o(^LABCi("DATE",date,wardrowid,labid)) q:labid=""  d
    ..s firflag=$p(^LABC(labid),"^",3)
    ..;i firflag=1 s $p(^LABC(labid),"^",3)=""
    ..q:firflag=1 ;已审
    ..s serial=$p(^LABC(labid),"^",6)
    ..s adm=$p(^LABC(labid),"^",11)
    ..s patid=$p(^PAADM(adm),"^",1)
    ..s patname=$p(^PAPER(patid,"ALL"),"^",1)
    ..s patno=$p(^PAPER(patid,"PAT",1),"^",1)
    ..s bedid=$p(^PAADM(adm),"^",73)                                             ;PA_Beds RowId
    ..i bedid="" s bed=""
    ..e  s bed=$p(^PAWARD($p(bedid,"||",1),"BED",$p(bedid,"||",2)),"^",1) 
    ..s prescno=$p(^LABC(labid),"^",14)
    ..s questr=..Getpaque(adm,prescno)
    ..;Instruc_"^"_facotor_"^"_orderqty_"^"_$g(quedate)_"^"_$g(quexdate)_"^"_notes_"^"_type 
    ..s instruc=$p(questr,"^",1)
    ..s instruc=$p(instruc,"-",2)
    ..s facotor=$p(questr,"^",2)
    ..s orderqty=$p(questr,"^",3)
    ..s quedate=$p(questr,"^",4)
    ..s quexdate=$p(questr,"^",5)
    ..s type=$p(questr,"^",7)
    ..d OutRowtyp
    ;Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutRowtyp
	set Data=$lb(patname,patno,bed,prescno,instruc,facotor,orderqty,quedate,quexdate,type,labid,serial)   //所对应传出的列名
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
}

ClassMethod GetQueFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetQueExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {				// if there are no more rows, finish 
fetching
		Set AtEnd=1
		Set Row=""
	}
	Else {			
		Set Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetQueClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetQueExecute ]
{
   	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetQue(datefrom, dateto, wardrowid) As %Query(ROWSPEC = "Tpatname:%String,Tpatno:%String,Tbed:%String,Tprescno:%String,Tinstruc:%String,Tfacotor:%String,Torderqty:%String,Tquedate:%String,Tquexdate:%String,Ttype:%String,TRowid:%String,Tserial:%String")
{
}

ClassMethod AduitZYC(rowid, userid, num, eatflag) As %String
{
	///description:如果实收数量(num)为空,则只审当前rowid,
	///            如果实收数量(num)不为空,则审当前rowid -- rowid+num 之间的所有信息,
	///creator:lq 2008-10-29
	 n (rowid,userid,num,eatflag)
	 s ret=0
	 s flag="1"
	 i eatflag="2" s eatflag=0.5 //如果服用方式是一剂两包,则rowid信息数 = 包数 / 2
	 s num=+num*eatflag 
	 i +num'=0 d
	 .f i=1:1:num d
	 ..s rowid=rowid+i
	 ..;&sql(UPDATE  DHC_LabCreat set labc_firflag=:flag,labc_ssusr_dr=:userid where Labc_rowid=:rowid)
	 ..;i SQLCODE'=0 s ret=-1
     e  d
	 .;&sql(UPDATE  DHC_LabCreat set labc_firflag=:flag,labc_ssusr_dr=:userid where Labc_rowid=:rowid)
	 .;i SQLCODE'=0 s ret=-1
	 q $g(ret)
}

ClassMethod GetUserWardId(loc)
{
 ///获得用户病区
  n (loc)
  q:'$d(^PAWARD(0,"WARD_LocationDR",loc)) ""
  s wardid=$O(^PAWARD(0,"WARD_LocationDR",loc,""),-1)
  s warddesc=$p(^PAWARD(wardid),"^",2)
  q warddesc_"^"_wardid
}

ClassMethod GetArcItmSubCat(inci As %String) As %String
{
 n (inci)
 q:inci="" ""
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

ClassMethod ListNoStock(pid, oeori) As %String
{
	n (pid,oeori)
	q:'$d(^TMP("dhcpha","NOSTOCK",pid)) ""
	s tmp=$o(^TMP("dhcpha","NOSTOCK",pid,oeori))
	q:tmp="" ""
	s str=^TMP("dhcpha","NOSTOCK",pid,tmp)
	q str
}

ClassMethod KillNoStock(pid) As %String
{
	n (pid)
	i $d(^TMP("dhcpha","NOSTOCK",pid)) d
	.k ^TMP("dhcpha","NOSTOCK",pid)
	q
}

ClassMethod GetGrpWard(phac) As %String
{
	;获取病区分组
	n (phac)
	s ch=$o(^DHCPHAC(phac,"I",0))
	s adm=$p(^DHCPHAC(phac,"I",ch),"^",3)
	s bedid=$p(^PAADM(adm),"^",73) 
	q $G(grp)
}

ClassMethod GetDoseUomFac(OrditmRowid) As %String
{
   n (OrditmRowid)
   ;Description: 解决1/2片,
   ;如果剂量单位是最小单位，现在的剂量转换成等效单位
   ;如果剂量单位是等效单位，现在的剂量可以不变
   ;Input:OE_OrdItemRowid
   ;Output:fac - 转换因子
   ;Creator:lq   2009-03-06
   s ord=$p(OrditmRowid,"||",1)
   s chl=$p(OrditmRowid,"||",2)
   s fac=1
   s arcimid=$p(^OEORD(ord,"I",chl,1),"^",2)  
   s inci=$o(^INCI(0,"ARCIM_DR",$p(arcimid,"||",1),"") ) q:inci=""  
   s doseuom=$p(^CT("UOM",$p(^OEORD(ord,"I",chl,2),"^",3)),"^",2) 
   s buomdr=$p(^INCI(inci,1),"^",10)
   s buom=$p(^CT("UOM",buomdr),"^",2) 
   s OrderDrugFormRowid=$p(^ARCIM($p(arcimid,"||",1),$p(arcimid,"||",2),1),"^",12)
   s eqchl=""
   f  s eqchl=$o(^PHCD($p(OrderDrugFormRowid,"||",1),"DF",$p(OrderDrugFormRowid,"||",2),"EQ",eqchl)) q:eqchl=""  d
   .s ctuomdr=$p(^PHCD($p(OrderDrugFormRowid,"||",1),"DF",$p(OrderDrugFormRowid,"||",2),"EQ",eqchl),"^",1)
   .s equom=$p(^CT("UOM",ctuomdr),"^",2) 
   .;q:equom'=doseuom
   .s eqqty=$p(^PHCD($p(OrderDrugFormRowid,"||",1),"DF",$p(OrderDrugFormRowid,"||",2),"EQ",eqchl),"^",2)
   i doseuom'=buom d
   .s fac=1
   e  d 
   .s fac=eqqty
   q fac
}

ClassMethod CreatePatList(pid) As %String
{
	n (pid)
	s n=0
	q:'$D(^TMP("HZOnePat",pid)) n
	s bed=""
	f  s bed=$o(^TMP("HZOnePat",pid,bed)) q:bed=""  d
	.s patno="" 
	.f  s patno=$o(^TMP("HZOnePat",pid,bed,patno)) q:patno=""  d
	..s presno=""
	..f  s presno=$o(^TMP("HZOnePat",pid,bed,patno,presno)) q:presno=""  d
	...s oeori=""
	...f  s oeori=$o(^TMP("HZOnePat",pid,bed,patno,presno,oeori)) q:oeori=""  d
	.... s n=n+1
	.... s tmpdata=^TMP("HZOnePat",pid,bed,patno,presno,oeori)
    .... s pano=$p(tmpdata,"^",1)
	.... s paname=$p(tmpdata,"^",2)
	.... s pasex=$p(tmpdata,"^",3)
	.... s padob=$p(tmpdata,"^",4)
	.... s warddesc=$p(tmpdata,"^",5)
	.... s bedcode=$p(tmpdata,"^",6)
	.... s admloc=$p(tmpdata,"^",7)
	.... s prescno=$p(tmpdata,"^",8)
	.... s doctor=$p(tmpdata,"^",9)
	.... s incicode=$p(tmpdata,"^",10)
	.... s incidesc=$p(tmpdata,"^",11)
	.... s orditemdesc=$p(tmpdata,"^",12)
	.... s ordstatus=$p(tmpdata,"^",13)
	.... s dosqty=$p(tmpdata,"^",14)
	.... s freq=$p(tmpdata,"^",15)
	.... s qty=$p(tmpdata,"^",16)
	.... s uom=$p(tmpdata,"^",17)
	.... s sp=$p(tmpdata,"^",18)
	.... s amt=$p(tmpdata,"^",19)
	.... s incibatno=$p(tmpdata,"^",20)
	.... s instruction=$p(tmpdata,"^",21)
	.... s duration=$p(tmpdata,"^",22)
	.... s OEORI=$p(tmpdata,"^",23)
	.... s SeqNo=$p(tmpdata,"^",24)
	.... s remark=$p(tmpdata,"^",25)
	.... s inci=$p(tmpdata,"^",26)  ; 20051207
	.... s manf=$p(tmpdata,"^",27)
	.... s spec=$p(tmpdata,"^",30)
	.... s eatdrugtime=$p(tmpdata,"^",31)
	.... s stkbin=$p(tmpdata,"^",32)
	.... s orddate=$p(tmpdata,"^",33)
	.... s ordsttdate=$p(tmpdata,"^",34)
	.... s diagnose=$p(tmpdata,"^",35)
	.... s generic=$p(tmpdata,"^",36)
	.... s priority=$p(tmpdata,"^",37)
	.... s oepresno=$p(tmpdata,"^",38)
	.... s preno=$p(tmpdata,"^",39)
	.... s prescno1=$p(tmpdata,"^",40)
	.... s cyjyfs=$p(tmpdata,"^",41)
	.... s drugform=##class(web.DHCSTCOMMONSRV).GetForm(inci) 
	.... s action=$p(tmpdata,"^",42)
	.... 
	.... s inci=##class(web.DHCSTCOMMONSRV).ItemCodeToID(incicode)
	.... s qty=..getPackQty(inci,qty) ;转换成整包装数量(including uom desc) :  LQ
	.... ;
	.... s a1=pano_"^"_paname_"^"_pasex_"^"_padob_"^"_warddesc
	.... s a2=bedcode_"^"_admloc_"^"_prescno_"^"_doctor_"^"_incicode
	.... s a3=incidesc_"^"_orditemdesc_"^"_ordstatus_"^"_dosqty_"^"_freq
	.... s a4=qty_"^"_uom_"^"_sp_"^"_$fn(amt,"",2)_"^"_incibatno
	.... s a5=instruction_"^"_duration_"^"_OEORI_"^"_SeqNo_"^"_remark
	.... s a6=manf_"^"_spec_"^"_eatdrugtime_"^"_stkbin_"^"_orddate
	.... s a7=ordsttdate_"^"_$g(diagnose)_"^"_$g(generic)_"^"_$g(priority)_"^"_$g(oepresno)
	.... s a8=$g(preno)_"^"_$g(prescno1)_"^"_$g(cyjyfs)_"^"_$g(drugform)_"^"_$g(action)
	.... s ^TMP("ListOnePat",pid,n)=a1_"^"_a2_"^"_a3_"^"_a4_"^"_a5_"^"_a6_"^"_a7_"^"_a8
	.... 
	k ^TMP("HZOnePat",pid)
	q n
}

/// Creator:Liang Qiang
/// CreatDate:2009-05-18
/// Description:获取某库存项的整包装价格
/// Table: IN_AdjSalePrice
/// Input: incitmRowid , sttdate
/// Output:整包装价格
/// Return:整包装价格
/// Othter:
ClassMethod getUomPrice(INCITM As %String, STTDATE As %String) As %Currency
{
 q
 n (INCITM,STTDATE)
 s PUOM=+$p(^INCI(INCITM,3),"^",6) 
 s PRICE=##class(web.DHCSTCOMMONSRV).GetPriceElse(INCITM,STTDATE,PUOM)  
 q PRICE
}

/// Creator:Liang Qiang
/// CreatDate:2009-09-0
/// Description:获取频率分发时间
/// Table: PHC_DispensingTime
/// Input: 频率Rowid
/// Output:
/// Return:频率分发时间
/// Othter:
ClassMethod GetFreqDispensingTime(Freqrowid As %String) As %String
{
    n (Freqrowid)
	s TPHCDTTime=""
	s PHCDTTime=""
	s Plist=""
	s PHCDTChildSub=0
	f  s PHCDTChildSub=$o(^PHCFR(Freqrowid,"DT",PHCDTChildSub)) q:PHCDTChildSub=""  d
	.s TStr=$p(^PHCFR(Freqrowid,"DT",PHCDTChildSub),"^",1)
	.s TPHCDTTime=$p(TStr,"^",1)
	.s PHCDTTime=$zt(TPHCDTTime,1)
	.s Plist=Plist_","_PHCDTTime
	i Plist'="" s Plist=$p(Plist,",",2,$l(Plist,","))
	;w !,Plist
	q Plist
}

ClassMethod SetDispInfoByFreq(main, freqRowid, dispinfo, pid) As %String
{
	n (main, freqRowid, dispinfo, pid)
	s phcdtimestr=..GetFreqDispensingTime(freqRowid)
	q:phcdtimestr="" ""
	s cnt=$l(phcdtimestr,",")
	s patno=$p(dispinfo,"^",1)
	s bed=$p(dispinfo,"^",6)
	i +bed'=0 s bed=+$g(bed)
	e  s bed=$p(bed,"床")
	s name=$p(dispinfo,"^",2)
	s orditem=$p(dispinfo,"^",11)
	//s orditem=$p(orditem,"*",1)
	s dispty=$p(dispinfo,"^",14)
	s ordstdate=$p(dispinfo,"^",34)
	s instruction=$p(dispinfo,"^",21)
	s freq=$p(dispinfo,"^",15)
	s freq=$e(freq,2,$l(freq)-1)
	s ward=$p(^DHCPHAC(main),"^",4)
	s warddesc=""
	i ward'="" s warddesc=$p(^PAWARD(+ward),"^",2)
       i $f(warddesc,"-") s warddesc=$p(warddesc,"-",2)
	s ordstr=orditem_"^"_dispty_"^"_freq
	;
	f i=1:1:cnt d
	.s phcdtime=$p(phcdtimestr,",",i)
	.s phcdtime="00:00:00" s freqflag="必要时"
	.i phcdtime="08:00:00" s freqflag="早晨"
	.i phcdtime="12:00:00" s freqflag="中午"
	.i phcdtime="16:00:00" s freqflag="下午"
	.i phcdtime="20:00:00" s freqflag="晚间"
	.s adminfo=ward_"^"_patno_"^"_bed_"^"_name_"^"_ordstdate_"^"_freqflag_"^"_warddesc_"^"_instruction
	.
	.i $d(^TMP("dhcpha",pid,"DispFreq",phcdtime,bed)) d
	..s ^TMP("dhcpha",pid,"DispFreq",phcdtime,bed)=^TMP("dhcpha",pid,"DispFreq",phcdtime,bed)_"@"_ordstr
	.e  d
	..s ^TMP("dhcpha",pid,"DispFreq",phcdtime,bed)=adminfo_"||"_ordstr
	..
	q 0
}

ClassMethod GetDispFreqCnt(pid) As %String
{
  n (pid)
  s i=0
  s phcdtime=""
  f  s phcdtime=$o(^TMP("dhcpha",pid,"DispFreq",phcdtime)) q:phcdtime=""  d
  .s bed=""
  .f  s bed=$o(^TMP("dhcpha",pid,"DispFreq",phcdtime,bed)) q:bed=""  d
  ..s i=i+1
  ..s ^TMP("dhcpha",pid,"LISTDISPFREQ",i)=^TMP("dhcpha",pid,"DispFreq",phcdtime,bed)
  k ^TMP("dhcpha",pid,"DispFreq") 
  q i
}

ClassMethod ListDispFreq(pid, i) As %String
{
	n (pid, i)
	q:'$d(^TMP("dhcpha",pid,"LISTDISPFREQ",i)) ""
	q ^TMP("dhcpha",pid,"LISTDISPFREQ",i)
}

/// Description:打印发药单设置打印标志
/// Creator:Liang Qiang
/// CreatDate:2009-11-17
/// Input:发药主表Rowid
/// Output:SQLCODE
/// Others:
ClassMethod SetPrintFlag(coll) As %String
{
	n (coll)
	s prnnum=$p(^DHCPHAC(coll),"^",16)
	i prnnum="" d
	.s prnnum=1
	e  d 
	.s prnnum=prnnum+1
	&sql(update DHC_PHACollected set DHC_PHAPrintFlag=:num 
	where DHC_PHACollect_RowID=:coll )
	q:SQLCODE -1
	q SQLCODE
}

/// Description:获取发药单打印标志
/// Creator:Liang Qiang
/// CreatDate:2009-11-17
/// Input:发药主表Rowid
/// Output:发药单打印次数
/// Others:
ClassMethod GetPrintFlag(coll) As %String
{
	n (coll)
    s prnnum=$p(^DHCPHAC(coll),"^",16)
	i prnnum="" d
	.s prnnum=1
	e  d 
	.s prnnum=prnnum+1
	q prnnum
}

/// Description:获取医嘱项最大量
/// Creator:Liang Qiang
/// CreatDate:2009-11-17
/// Input:库存项Rowid
/// Output:医嘱项最大量
ClassMethod GetArcItmMaxQty(inci As %String) As %String
{
 n (inci)
 q:'$d(^INCI(inci,1)) 0
 s arcim=$p(^INCI(inci,1),"^",3)
 s darc=$o(^DHCItmMast("0","ARCIM",arcim,""))
 q:darc="" 0
 q:'$D(^DHCItmMast(darc)) 0
 s maxqty=$p(^DHCItmMast(darc),"^",3)
 i maxqty="" s maxqty=0
 q maxqty
}

ClassMethod getBUomDoseQty(ord, itm)
{
	//zdm,2010-11-12,徐州口服摆药单数量显示为一次用量
	//如果剂量单位和基本单位能够整除，转换为基本单位对应量
	//如果有小数，显示为原始剂量
	n (ord,itm)
	s doseqty=$p(^OEORD(ord,"I",itm,2),"^",1)
	;get dose-equiv
	q:doseqty="" ""
	s doseqty=##class(web.DHCSTKUTIL).NN(doseqty)  ;调整数字（使小数点前的"0"能够显示）
	s arcim=$p(^OEORD(ord,"I",itm,1),"^",2) q:arcim="" ""
	s sub=$p(arcim,"||",1),ver=$p(arcim,"||",2)
	s phcdf=$p(^ARCIM(sub,ver,1),"^",12)
	s doseunit=$p(^OEORD(ord,"I",itm,2),"^",3)
	q:phcdf="" ""	
	;s fac=##class(web.DHCSTCOMMONSRV).GetItmUOConFac(+inclb)
	&sql(select PHCDF_CTUOM_DR into :buom
		from phc_drgform where phcdf_rowid=:phcdf)
	s qty=doseqty
	s uom=doseunit
	i $g(buom)'=doseunit  d
	.s fac=..getEquivQty(phcdf,doseunit)
	.q:fac=""
	.i '$f(doseqty/fac,".") d
	..s qty=doseqty/fac
	..s uom=buom
	.
	s uomdesc=$p(^CT("UOM",uom),"^",2)
	q qty_"^"_uomdesc
}

ClassMethod getEquivQty(phcdf, doseUom)
{
	n (phcdf,doseUom)
	
	&sql(Select eq_qty into :doseequiv From PHC_FormDoseEquiv
	     Where EQ_ParRef=:phcdf and EQ_CTUOM_DR=:doseUom)
	q:SQLCODE'=0 ""
	s doseequiv=##class(web.DHCSTKUTIL).NN(doseequiv) 
	q $g(doseequiv)
}

/// Creator:Liang Qiang  
/// CreatDate:2009-01-04
/// Description:把汇总打印单中的数量转换成整包装数量 
ClassMethod getPackQtyStr(inci, qty, resqty, facqty) As %String
{
	n (inci, qty,resqty,facqty)
	s ch=""
	s ch=..GetZCY(inci)
	s ^tmpch=ch
	i ch'="" d    
	.s qty=..getPackQty(inci,qty)
	.i resqty'="" s resqty=..getPackQty(inci,resqty)
	.i facqty'="" s facqty=..getPackQty(inci,facqty)
	q qty_"||"_resqty_"||"_facqty
}

/// Creator:Cao Ting
/// CreatDate:2011-03-11
/// Description:判断药品的医嘱子类是否属于中成药
ClassMethod GetZCY(inci) As %String
{
	Q:inci="" ""
    s scgdesc=""
    i $d(^INCI(inci,2)) d
    .s inccat=$p(^INCI(inci,2),"^",2)
    .Q:inccat=""
    .s scg=$o(^DHCSCG("STKCAT",inccat,""))
    .q:scg=""
    .s scgdesc=$p(^DHCSCG(scg),"^",2)
    i scgdesc'="中药" s inci=""
    q inci
}

/// Creator:Cao Ting
/// CreatDate:2011-03-17
/// Description:根据页码返回起始记录的索引
ClassMethod ListDetailTotalByPage(incicode As %String, pid As %String, page As %String) As %String
{
	n (incicode,pid,page)
	s index=1
	
	s tmp=incicode
	i page>1 d
	.s page=page-1
	.f  s tmp=$o(^TMP(pid,"PRNDISPDTOTAL",tmp)) q:index=page  d
	..s index=index+1
	
	s ^tmptm=tmp
	q tmp
}

ClassMethod MergeByOrd(pid As %String) As %String
{
	n (pid)
	s ind=""
	f  s ind=$o(^TMP(pid,"PRNDISPBYREGNO",ind)) q:ind=""  d
	.i ^TMP(pid,"PRNDISPBYREGNO",ind)'="" d
	..s inci=$p(^TMP(pid,"PRNDISPBYREGNO",ind),"^",44)
	..s ind1=ind
	..f  s ind1=$o(^TMP(pid,"PRNDISPBYREGNO",ind1)) q:ind1=""  d
	...i ^TMP(pid,"PRNDISPBYREGNO",ind1)'="" d
	....s inci1=$p(^TMP(pid,"PRNDISPBYREGNO",ind1),"^",44)
	....i (inci1'="") && (inci1=inci) d
	.....s qty=$p(^TMP(pid,"PRNDISPBYREGNO",ind1),"^",16)
	.....s $p(^TMP(pid,"PRNDISPBYREGNO",ind),"^",16)=$p(^TMP(pid,"PRNDISPBYREGNO",ind),"^",16)+qty
	.....s qtyfac=$p(^TMP(pid,"PRNDISPBYREGNO",ind1),"^",41)
	.....s $p(^TMP(pid,"PRNDISPBYREGNO",ind),"^",41)=$p(^TMP(pid,"PRNDISPBYREGNO",ind),"^",41)+qtyfac
	.....s ^TMP(pid,"PRNDISPBYREGNO",ind1)=""
}

ClassMethod GetSYZ(oeori As %String) As %String
{
	q:oeori="" ""
	s strSYZ=""
	s strSYZ=$g(^OEORD(+oeori,"I",$P(oeori,"||",2),"DHC",18))
	q strSYZ
}

// 取备注

ClassMethod GetNotes(moeori As %String) As %String
{
	N (moeori)
	Q:moeori="" ""
	s Notes=""
	S ord=$P(moeori,"||",1) Q:ord="" ""
	S itm=$P(moeori,"||",2) Q:itm="" ""
	f rnum=1:1:$G(^OEORD(ord,"I",itm,"DEP",0)) d
    .s Notes=Notes_$G(^OEORD(ord,"I",itm,"DEP",rnum))
    i $G(Notes)="" s Notes=""
    ;w "Notes"_Notes
    Q Notes
}

/// Description:准备冲减日志打印数据
/// Creator:LiangQiang
/// CreatDate:2013-4-22
ClassMethod GetPresLogData(incicode, pointer, pid) As %String
{

   n (incicode,pointer,pid)
   
   q:pointer="" 0
   q:'$d(^DHCPRES(0,"TypePointer","P",pointer)) 0
   s pres=$o(^DHCPRES(0,"TypePointer","P",pointer,""),-1)
   q:pres="" 0
   s exit=0
   s chl=""
   f  s chl=$o(^DHCPRES(pres,"DET",chl),-1) q:(chl="")||(exit=1)  d
   .s phaci=$p(^DHCPRES(pres,"DET",chl),"^",2)
   .i pointer=phaci s exit=1
   .s tmpchl=chl
   q:$g(tmpchl)="" 0
   s chl=tmpchl
   q:'$d(^DHCPRES(pres,"DET",chl,"SUB")) 0
   
   s pressub=""
   f  s pressub=$o(^DHCPRES(pres,"DET",chl,"SUB",pressub),-1) q:pressub=""  d
   .s phari=$p(^DHCPRES(pres,"DET",chl,"SUB",pressub),"^",1)
   .s phar=+phari
   .s pharqty=$p(^DHCPRES(pres,"DET",chl,"SUB",pressub),"^",2)
   .s inclb=$p(^PHARET(phar),"^",6)
   .s oeori=$p(^PHARET(phar),"^",5)
   .s adm=$p(^OEORD(+oeori),"^",1)
   .s incidesc=$p(^INCI(+inclb,1),"^",2)
   .s tmp=..getPaNo(adm)
   .s pano=$p(tmp,"^",1)
   .s paname=$p(tmp,"^",2)
   .s beddr=$p(^PHARET(phar),"^",15)
   .s bed=$p(^PAWARD(+beddr,"BED",$p(beddr,"||",2)) ,"^",1)
   .s phareqno=""
   .s phareqdr=$p(^PHARET(phar),"^",4)
   .i phareqdr'="" d
   ..s lenreq=$l(phareqdr,",")	//bug修改，zhouyg 201609222
   ..f numreq=1:1:lenreq d
   ...s reqdr=$p(phareqdr,",",numreq)
   ...s nreqno=$p(^RETRQ(reqdr),"^",1)
   ...i phareqno="" d
   ....s phareqno=nreqno
   ...e  d
   ....s phareqno=phareqno_","_nreqno
   .s uom=0
   .s stkbin=..getStkBin(inclb)
   .s index=incicode_"||"_bed_"||"_paname_"||"_incidesc
   .
   .s data=bed_"^"_paname_"^"_incidesc_"^"_pharqty_"^"_uom_"^"_phareqno
   .
   .i '$d(^TMP("dhcpha","DHCSTPCHCOLLPRN","GetPresLogData",pid,index)) d
   ..s ^TMP("dhcpha","DHCSTPCHCOLLPRN","GetPresLogData",pid,index)=data
   .e  d
   ..s $p(^TMP("dhcpha","DHCSTPCHCOLLPRN","GetPresLogData",pid,index),"^",4)=$p(^TMP("dhcpha","DHCSTPCHCOLLPRN","GetPresLogData",pid,index),"^",4)+pharqty
   
   q 0
}

ClassMethod GetPresLogForPrt(pid) As %String
{
   
   	n (pid)
	s i=0
	s index=""
	f  s index=$o(^TMP("dhcpha","DHCSTPCHCOLLPRN","GetPresLogData",pid,index)) q:index=""  d
	.s i=i+1
	.s ^TMP("dhcpha","DHCSTPCHCOLLPRN","GetPresLogForPrt",pid,i)=^TMP("dhcpha","DHCSTPCHCOLLPRN","GetPresLogData",pid,index)
	.
	k ^TMP("dhcpha","DHCSTPCHCOLLPRN","GetPresLogData")
	q i
}

ClassMethod ListPresLogForPrt(pid, i) As %String
{
 
	n (pid,i)
	s str=^TMP("dhcpha","DHCSTPCHCOLLPRN","GetPresLogForPrt",pid,i)
	k ^TMP("dhcpha","DHCSTPCHCOLLPRN","GetPresLogForPrt",pid,i)
	Q str
}

/// 删除临时global
ClassMethod KillTempGlobal(pid) As %String
{
	k ^TMP("dhcpha",pid,"LISTDISPFREQ")
	q ""
}

// Description:取请求单的打印标志

ClassMethod GetPrintReqFlag(req As %String) As %String
{
 n (req)   
 q:req="" ""
 s dInrq=$o(^DHCINRQ(0,"INRQ",req,""))
 q:dInrq="" ""
 q $p(^DHCINRQ(dInrq),"^",2)
}

/// Description:调请求单主信息
/// w ##class(web.DHCSTPCHCOLLPRN).ListReq(223)
ClassMethod ListReq(req As %String) As %String
{
   n (req)
   s ^TMPDHCSTPARAMS("web.DHCSTPCHCOLLPRN","ListReq")=req
   s pid=..PrnID()
 &sql(select inrq_recloc_dr->ctloc_desc,inrq_reqloc_dr->ctloc_desc,inrq_no,inrq_date,inrq_ssusr_dr->ssusr_name,inrq_date,inrq_time 
   into :recloc,:reqloc,:no,:da,:userName,:inrqdate,:inrqtime
  from in_request where inrq_rowid=:req)
   q:SQLCODE -1
   s da=$g(da)  i da'="" s da=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(da,"IP")
   s bdd=$o(^DHCBDD(0,"REQ",req,""))
   s frDate="",toDate=""
   i bdd'="" s frDate=$P(^DHCBDD(bdd),"^",6)
   e  s frDate=inrqdate
   i bdd'="" s toDate=$P(^DHCBDD(bdd),"^",7)
   e  s toDate=inrqdate
   i frDate'="" s frDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(frDate,"IP")
   i toDate'="" s toDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(toDate,"IP")
   s cnt=..GetReqItm(pid,req)
   s cnt2=..GetReqJSDM(pid,req)
   s dhcReqId=$O(^DHCINRQ(0,"INRQ",req,"")) 
   s collUserName=""
   i dhcReqId'="" d
   .s dhcReqData=$g(^DHCINRQ(dhcReqId))
   .q:dhcReqData=""
   .s collUserId=$p(dhcReqData,"^",5)
   .s collUserName=$p($g(^SSU("SSUSR",+collUserId)),"^",2)
   s retData=pid
   s retData=retData_"^"_cnt
   s retData=retData_"^"_##class(web.DHCSTKUTIL).noPrefix($G(recloc),"-")
   s retData=retData_"^"_##class(web.DHCSTKUTIL).noPrefix($G(reqloc),"-")
   s retData=retData_"^"_$G(no)
   s retData=retData_"^"_$G(da)
   s retData=retData_"^"_userName
   s retData=retData_"^"_$G(frDate)
   s retData=retData_"^"_$G(toDate)
   s retData=retData_"^"_collUserName
   q retData
}

/// Description:取出请求单中的一条记录
ClassMethod ListReqItm(npid As %String, n As %String) As %String
{
 n (npid,n)
 q:npid="" ""
 q:n<1 ""
 q $G(^TMP(npid,"PrnReq",n))
}

/// Description:取出请求单中的一条记录
ClassMethod ListReqItmOrd(npid As %String, n As %String) As %String
{
 n (npid,n)
 q:npid="" ""
 s k=$O(^TMP(npid,"PrnReqOrd",n))
 q:k="" ""
 q ^TMP(npid,"PrnReqOrd",k)
}

/// Description:设置请求单的打印标志
ClassMethod SetPrintReqFlag(req As %String) As %String
{
 n (req)   
 q:req="" -1
 s dInrq=$o(^DHCINRQ(0,"INRQ",req,""))
 s prtFlag="1"
 s prtDate=+$h  //zhwh 2011-11-01 增加字段
 s prtTime=$p($h,",",2)  //zhwh 2011-11-01 增加字段
 i dInrq="" d
 . &sql(insert into dhc_inrequest (INRQ_INRQ_DR,INRQ_PrintFlag,INRQ_PrintDate,INRQ_PrintTime) values (:req,:prtFlag,:prtDate,:prtTime) ) 
 e  d
 . s $p(^DHCINRQ(dInrq),"^",2)=prtFlag
 . s $p(^DHCINRQ(dInrq),"^",22)=prtDate  //zhwh 2011-11-01
 . s $p(^DHCINRQ(dInrq),"^",23)=prtTime  //zhwh 2011-11-01
 . 
 q 0
}

ClassMethod GetReqItm(pid As %String, req As %String) As %String
{
  n (pid,req)
  s result=##class(%ResultSet).%New("web.DHCSTTRREQ:ReqItmDisp")
  d result.Execute(req)	
  s i=0
  While (result.Next()) {
	s TRowid=result.Data("TRowid")
	s TCode=result.Data("TCode")
	s TDesc=result.Data("TDesc")
	s TUomDesc=result.Data("TUomDesc")
	continue:result.Data("TQty")=0   //任晓娜 11年4月28日
	s TQty=result.Data("TQty")
	s TSp=result.Data("TSp")
	s TStkQty=result.Data("TStkQty")
	s TSBOfReqLoc=result.Data("TSBOfReqLoc")
	i TSBOfReqLoc="" s sb="0"
	e  s sb=TSBOfReqLoc
	
	&sql(select inci_rowid into :inci from inc_itm where inci_code=:TCode)
	s inci=+$g(inci)
	s spec=""
	i inci>0 s spec=##class(web.DHCST.Common.DrugInfoCommon).GetSpec("",inci)
	//i inci>0 s spec=##Class(web.DHCSTKUTIL).GetInciSpecB(inci)
	s i=i+1
	s a1=TRowid_"^"_TCode_"^"_TDesc_"^"_TUomDesc_"^"_TQty
	s a2=TSp_"^"_TStkQty_"^"_TSBOfReqLoc_"^"_spec
	s ^TMP("x",pid,sb,i)=a1_"^"_a2
   }	
   s n=0
   s sb=""
   f  s sb=$O(^TMP("x",pid,sb)) q:sb=""  d
   .s i=0
   .f  s i=$O(^TMP("x",pid,sb,i)) q:i=""  d
   ..s data=^TMP("x",pid,sb,i)
   ..s n=n+1
   ..s ^TMP(pid,"PrnReq",n)=data
   k ^TMP("x",pid)
   q n
}

ClassMethod GetReqJSDM(pid As %String, req As %String) As %String
{
  s bdd=$O(^DHCBDD(0,"REQ",req,"")) 
  q:bdd="" -1
  s n=0
  s ch=0
  f  s ch=$o(^DHCBDD(bdd,"I",ch))  q:ch=""  d
  .s cho=0
  .f  s cho=$o(^DHCBDD(bdd,"I",ch,"O",cho)) q:cho=""  d
  ..s oeori=$p(^DHCBDD(bdd,"I",ch,"O",cho),"^",1)
  ..&sql(select oeori_itmmast_dr into :arcim from oe_orditem where oeori_rowid=:oeori)
  ..s qty=$p(^DHCBDD(bdd,"I",ch,"O",cho),"^",2)
  ..s paInfo=..Pa(oeori)
  ..
  ..s paname=$P(paInfo,"^",1)
  ..s pasex=$P(paInfo,"^",2)
  ..s paage=$P(paInfo,"^",3)
  ..s papmiid=$P(paInfo,"^",4)
  ..s disease=$P(paInfo,"^",5)
  ..s medicareno=$P(paInfo,"^",6)
  ..s regno=$P(paInfo,"^",7)
  ..s prescno=$P(paInfo,"^",8)
  ..s doctor=$P(paInfo,"^",9)
  ..s freq=$P(paInfo,"^",10)
  ..s doseqty=$P(paInfo,"^",11)
  ..s admloc=$P(paInfo,"^",12)
  ..s instruction=$P(paInfo,"^",13)
  ..s doclocdr=$P(paInfo,"^",14)
  ..s OldWardDesc=$P(paInfo,"^",15)
  ..s ordDate=$P(paInfo,"^",16)
  ..
  ..s ordDate=$P(^OEORD(ord,"I",$p(oeori,"||",2),3),"^",7)
  ..i ordDate'="" s ordDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(ordDate,"IP")
  ..s prescno=$P(^OEORD(ord,"I",$p(oeori,"||",2),1),"^",14)
  ..
  ..s inci=$O(^INCI(0,"ARCIM_DR",$p(arcim,"||",1),""))
  ..s inciDesc=$p(^INCI(inci,1),"^",2)
  ..//s spec=##Class(web.DHCSTKUTIL).GetInciSpecB(inci)
  ..s spec=""
	
  ..i inci>0 s spec=##class(web.DHCST.Common.DrugInfoCommon).GetSpec("",inci)
  ..s buomDesc=""
  ..s buom=$p(^INCI(inci,1),"^",10)
  ..i buom'="" s buomDesc=$P(^CT("UOM",buom),"^",2)
  ..
  ..s a1=paname_"^"_pasex_"^"_paage_"^"_papmiid_"^"_disease
  ..s a2=medicareno_"^"_regno_"^"_$g(prescno)_"^"_doctor_"^"_freq
  ..s a3=doseqty_"^"_admloc_"^"_instruction_"^"_doclocdr_"^"_OldWardDesc
  ..s a4=inciDesc_"^"_spec_"^"_buomDesc_"^"_ordDate_"^"_qty
  ..
  ..s result=a1_"^"_a2_"^"_a3_"^"_a4
  ..s n=n+1
  ..s ^TMP(pid,"PrnReqOrd",n)=result
  ..
  q 0
}

ClassMethod Pa(oeori As %String) As %String
{
 s ord=+oeori
 s OldWardStr=##class(web.DHCSTPCHCOLLS).getOrdWard(oeori) //开医嘱时患者所在病区
 s OldWard=$p(OldWardStr,"^",1)
 s OldWardDesc=$P($G(^PAWARD(OldWard)),"^",2)
 s adm=$p(^OEORD(ord),"^",1)
 s papmi=$p(^PAADM(adm),"^",1)
 s paadmtype=$p(^PAADM(adm),"^",2) ;类型
 s governcardno=$p(^PAPER(papmi,"PER",4),"^", 4) ;门诊病历号
 s paname=$p(^PAPER(papmi,"ALL"),"^", 1) ;患者姓名
 s pasex=$p(^PAPER(papmi,"ALL"),"^",7 ) 
 i pasex'="" s pasex=$p(^CT("SEX",pasex),"^",2)  ;性别
 s dob=$p(^PAPER(papmi,"ALL"),"^", 6)
 s paage=$fn(((+$h)-dob)/365,"",0)       ;年龄
 s papmiid=$p(^PAPER(papmi,"ALL"),"^", 9) ;身份证号
 s medicareno=$p(^PAPER(papmi,"PAT",1),"^",1)
 i paadmtype="O" s medicareno=governcardno  ;门诊
 s disease=""
 s disease=##class(web.DHCSTKUTIL).GetMRDiagnosDesc(adm,",")
 &sql(select papmi_no into :regno from pa_patmas where papmi_rowid=:papmi )
 s regno=$g(regno) 
 s orditminfo=##class(web.DHCSTDISPSTATDM).GetOrdItmInfo($g(oeori))
 s doctor=$p(orditminfo,"^",1)
 s freq=$p(orditminfo,"^",2)
 s doseqty=$p(orditminfo,"^",3)
 s admloc=$p(orditminfo,"^",4)
 i $l(admloc,"-")>1 s admloc=$p(admloc,"-",2) 
 s instruction=$p(orditminfo,"^",5)
 s doclocdr=$p(orditminfo,"^",6)
 s a1=paname_"^"_pasex_"^"_paage_"^"_papmiid_"^"_disease
 s a2=medicareno_"^"_regno_"^"_$g(prescno)_"^"_doctor_"^"_freq
 s a3=doseqty_"^"_admloc_"^"_instruction_"^"_doclocdr_"^"_OldWardDesc
 q a1_"^"_a2_"^"_a3
}

}
