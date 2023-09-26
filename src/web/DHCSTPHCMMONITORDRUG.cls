Import sqluser

/// 临床药学管理
/// clinical pharmacy manage
Class web.DHCSTPHCMMONITORDRUG Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

///  取病人列表
/// w ##class(web.DHCSTPHCMMONITORDRUG).QueryMonInPatList("100","1","2011-06-30^2014-07-01")
ClassMethod QueryMonInPatList(rows, page, input) As %String
{
	
	s pid=##class(web.DHCSTPHCMCOMMON).GetPID()
	
	s endpage=page*rows  //结束行
	s stpage=((page-1)*rows)+1 //开始行
	
 
	s datefrom=$p(input,"^",1)
	s:datefrom'="" datefrom=$zdh(datefrom,3)
	s dateto=$p(input,"^",2)
	s:dateto'="" dateto=$zdh(dateto,3)
	
	s %argStDate=datefrom
	s %argEndDate=dateto
    /*
	s h=0
	f date=datefrom:1:dateto d
	.s locstr="1136"
	.s loccnt=$l(locstr,"^")
	.f x=1:1:loccnt d
	..s locdr=$p(locstr,"^",x)
	..s ord=""
	..f  s ord=$o(^OEORDi(0,"LocStDtArr",locdr,0,date,ord)) q:ord=""  d
	...s exist=0
	...s adm=$p(^OEORD(ord),"^",1)
	...s %EpisodeID=adm
	...s wardcode="未分配"
	...s admwarddr=$p(^PAADM(adm),"^",70) 
	...//q:(warddr'=admwarddr)&(warddr'="")&(admwarddr'="")
    ...s papmi=$p(^PAADM(adm),"^",1)
    ...s patname=$p(^PAPER(papmi,"ALL"),"^",1)
    ...s patno=$p(^PAPER(papmi,"PAT",1),"^",1)
    ...s bedno="未分配"
    ...s beddr=$p(^PAADM(adm),"^",73)
    ...i beddr'="" s bedno=$p(^PAWARD($p(beddr,"||",1),"BED",$p(beddr,"||",2)),"^",1)
    ...s chl=""  
    ...f  s chl=$o(^OEORDi(0,"LocStDtArr",locdr,0,date,ord,chl)) q:(chl="")||(exist=1)  d
	....s orditm=ord_"||"_chl
	....s presc=$p(^OEORD(ord,"I",chl,1),"^",14) ;处方号
	....q:presc=""
	....s dsp=$o(^DHCOEDISQTY(0,"OEORI",orditm,""))
	....q:dsp="" 
	....s priordr=+$p(^OEORD(ord,"I",chl,1),"^",8) 
    ....q:priordr=0 
    ....s priority=$p(^OECPR(priordr),"^",1) 			;医嘱优先级代码              
    ....q:priority["OM" ;自备药
    ....s statdr=$p(^OEORD(ord,"I",chl,1),"^",13)
	....s oeflag=$p(^OEC("OSTAT",statdr),"^",1) 
	....q:(oeflag'="V")&(oeflag'="E")
    ....s ret=##class(web.DHCSTPHCMFUNLIBITM).CheckDrugExist("CheckDrugExist")
	....q:ret=1
	....s ret=##class(web.DHCSTPHCMFUNLIBITM).CheckLabItmResult("CheckLabItmByArcID")
	....q:ret'=""
    ....s index=admwarddr_","_bedno_","_patno_","_patname_","_adm
    ....s ^TMP("DHCST","DHCSTPHCMMONITORDRUG","QueryMonInPatList",pid,"index",index)=""
    */
    
    s h=0
   	s datefrom=$p(input,"^",1)
	s:datefrom'="" datefrom=$zdh(datefrom,3)
	s dateto=$p(input,"^",2)
	s:dateto'="" dateto=$zdh(dateto,3)
	s resulttype=$p(input,"^",3)
    s app=""
    f  s app=$o(^DHCPHORDM(0,"AppType",app)) q:app=""  d
    .q:(app'="ADR")
    .s main=""
    .f  s main=$o(^DHCPHORDM(0,"AppType",app,main)) q:main=""  d
    ..s flag=$p(^DHCPHORDM(main),"^",2)
    ..q:(resulttype=0)&(flag="N")
    ..q:(resulttype=1)&(flag'="Y")
    ..q:(resulttype=2)&(flag'="N")
    ..s sub=""
    ..f  s sub=$o(^DHCPHORDM(main,"I",sub)) q:sub=""  d
    ...s adm=$p(^DHCPHORDM(main,"I",sub),"^",5)
    ...s wardcode="未分配"
	...s admwarddr=$p(^PAADM(adm),"^",70) 
    ...s papmi=$p(^PAADM(adm),"^",1)
    ...s patname=$p(^PAPER(papmi,"ALL"),"^",1)
    ...s patno=$p(^PAPER(papmi,"PAT",1),"^",1)
    ...s bedno="未分配"
    ...s beddr=$p(^PAADM(adm),"^",73)
    ...i beddr'="" s bedno=$p(^PAWARD($p(beddr,"||",1),"BED",$p(beddr,"||",2)),"^",1)
    ...s index=app_","_admwarddr_","_bedno_","_patno_","_patname_","_adm
    ...s ^TMP("DHCST","DHCSTPHCMMONITORDRUG","QueryMonInPatList",pid,"index",index)=""
    ..
    ..
   
	s index=""
	f  s index=$o(^TMP("DHCST","DHCSTPHCMMONITORDRUG","QueryMonInPatList",pid,"index",index)) q:index=""  d
    .s adm=$p(index,",",6)
    .s bedno=$p(index,",",3)
    .s patno=$p(index,",",4)
    .s patname=$p(index,",",5)
    .i app="ADR" s app="不良"
    .s papmi=$P(^PAADM(adm),"^",1)
    .s sexDr=$p(^PAPER(papmi,"ALL"),"^",7) 
	.i sexDr'="" s sex=$p(^CT("SEX",sexDr),"^","2")
	.s patage=##class(web.DHCSTKUTIL).GetAge(papmi)  ;年龄
	.s admdate=$p(^PAADM(adm),"^",6)
	.s admtime=$p(^PAADM(adm),"^",7)
	.i admdate'="" s admdate=$zd(admdate,3)
	.i admtime'="" s admtime=$zt(admtime,1)
	.s admdate=admdate_" "_admtime
	.s admward=""
	.s admwarddr=$p(^PAADM(adm),"^",70) 
	.i admwarddr'="" s admward=$p(^PAWARD(admwarddr),"^",2)
	.i $f(admward,"-") s admward=$p(admward,"-",2)
	.s patage=##class(web.DHCSTKUTIL).GetAge(papmi)  ;年龄
	.s diag=##class(web.DHCSTKUTIL).GetMRDiagnosDesc(adm,",")
    .s patW=##class(PHA.COM.Order).PatWeight(adm)
    .s patH=##class(PHA.COM.Order).PatHeight(adm)
    .s dept=""
    .s deptdr=$P(^PAADM(adm),"^",4)
    .i deptdr'="" s dept=$p(^CTLOC(deptdr),"^",2)
    .i $f(dept,"-") s dept=$p(dept,"-",2)
    .
    .s h=h+1
    .s data=patno_"^"_admward_"^"_bedno_"^"_adm_"^"_patname_"^"_sex_"^"_patage_"^"_patH_"^"_patW_"^"_admdate_"^"_diag_"^"_dept_"^"_app
    .s ^TMP("DHCST","DHCSTPHCMMONITORDRUG","QueryMonInPatList",pid,"Num",h)=data

	q:h=0 ##class(web.DHCSTJQUERYCOMMON).GetNoJson()
	
	s maxrow=h
    i endpage>maxrow s endpage=maxrow
    s count=0
    s h=""
    f  s h=$o(^TMP("DHCST","DHCSTPHCMMONITORDRUG","QueryMonInPatList",pid,"Num",h)) q:h=""  d
    .s data=^TMP("DHCST","DHCSTPHCMMONITORDRUG","QueryMonInPatList",pid,"Num",h)
    .s patno=$p(data,"^",1)
    .s ward=$p(data,"^",2)
    .s bedno=$p(data,"^",3)
    .s patname=$p(data,"^",5)
    .s patsex=$p(data,"^",6)
    .s patage=$p(data,"^",7)
    .s patadm=$p(data,"^",4)
    .s patH=$p(data,"^",8)
    .s patW=$p(data,"^",9)
    .s patdate=$p(data,"^",10)
    .s diag=$p(data,"^",11)
    .s dept=$p(data,"^",12)
    .s app=$p(data,"^",13)
    .
    .s count=count+1
    .q:count<stpage
    .q:count>endpage
    .
    .s patno=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("patno",patno)
	.s patname=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("patname",patname)
	.s patsex=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("patsex",patsex)
	.s patage=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("patage",patage)
	.s patadm=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("patadm",patadm)
	.s ward=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("patward",ward)
	.s dept=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("patloc",dept)
	.s patH=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("patH",patH)
	.s patW=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("patW",patW)
	.s patdate=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("patdate",patdate)
	.s diag=##class(web.DHCSTJQUERYCOMMON).GetJsonLastCell("patdiag",diag)
	.
	.s tmpstr=patno_patname_patsex_patage_patadm_ward_dept_patH_patW_patdate_diag
	.
    .s startString=##class(web.DHCSTJQUERYCOMMON).GetJsonStartString(maxrow)
    .s firstrow=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstRow(tmpstr)
    .s lastrow=##class(web.DHCSTJQUERYCOMMON).GetJsonLastRow(tmpstr)
    .
    .i count=stpage w startString
    .i count<endpage w firstrow
    .i count=endpage w lastrow
    
    k ^TMP("DHCST","DHCSTPHCMMONITORDRUG","QueryMonInPatList",pid)
    
    q ""
}

/// w ##Class(web.DHCSTPHCMMONITORDRUG).QueryInPatOrdItemList("100","1","2011-06-30^2014-06-30^77")
ClassMethod QueryInPatOrdItemList(rows, page, input) As %String
{
	
	s pid=##class(web.DHCSTPHCMCOMMON).GetPID()
	
	s endpage=page*rows  //结束行
	s stpage=((page-1)*rows)+1 //开始行
	
	s datefrom=$p(input,"^",1)
	s:datefrom'="" datefrom=$zdh(datefrom,3)
	s dateto=$p(input,"^",2)
	s:dateto'="" dateto=$zdh(dateto,3)
	s adm=$p(input,"^",3)
	i adm'=0 s ord=$o(^OEORD(0,"Adm",adm,""))
	s pid=##class(web.DHCSTPHCMCOMMON).GetPID()
	s h=0

    s chl=0  
    f  s chl=$o(^OEORD(ord,"I",chl)) q:(chl="")||(chl=0)  d
	.s orditm=ord_"||"_chl
	.q:'$d(^DHCOEDISQTY(0,"OEORI",orditm))  //过滤非药品
	.d getitmdata
	.
	
	q:h=0 ##class(web.DHCSTJQUERYCOMMON).GetNoJson()
	
	s maxrow=h
    i endpage>maxrow s endpage=maxrow
    s count=0
    s h=""
  
    f  s h=$o(^TMP("DHCST","DHCSTPHCMMONITORDRUG","QueryInPatOrdItemList",pid,"itm",h)) q:h=""  d
    .s data=^TMP("DHCST","DHCSTPHCMMONITORDRUG","QueryInPatOrdItemList",pid,"itm",h)
    .s incidesc=$p(data,"^",1)
    .s spec=$p(data,"^",6)
    .s qty=$p(data,"^",2)
    .s uomdesc=$p(data,"^",3)
    .s dosage=$p(data,"^",4)
    .s freq=$p(data,"^",5)
    .s instruc=$p(data,"^",7)
    .s remark=$p(data,"^",13)
    .s price=$p(data,"^",15)
    .s amt=$p(data,"^",16)
    .s skintest=$p(data,"^",18)
    .s:skintest'="" incidesc=skintest_" "_incidesc
    .s pri=$p(data,"^",10)
    .s doctor=$p(data,"^",11)
    .s orddatetime=$p(data,"^",12)
    .s manf=$p(data,"^",14)
    .s price=$p(data,"^",15)
    .s form=$p(data,"^",9)
    .s basflag=$p(data,"^",19)
    .s orditem=$p(data,"^",20)
    .s result=$p(data,"^",21)
    .s patid=$p(data,"^",22)
    .s patname=$p(data,"^",23)
    .s mainflag=$p(data,"^",24)
    .s moeori=$p(data,"^",25)
    .s adm=$p(data,"^",26)
    .
    .s count=count+1
    .q:count<stpage
    .q:count>endpage
    .
    .s incidesc=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("incidesc",incidesc)
	.s qty=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("qty",qty)
	.s uomdesc=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("uomdesc",uomdesc)
	.s dosage=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("dosage",dosage)
	.s freq=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("freq",freq)
	.s spec=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("spec",spec)
	.s instruc=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("instruc",instruc)
	.s form=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("form",form)
	.s ordpri=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("ordpri",pri)
	.s basflag=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("basflag",basflag)
	.s doctor=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("doctor",doctor)
	.s orddate=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("orddate",orddatetime)
	.s remark=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("remark",remark)
	.s manf=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("manf",manf)
	.s price=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("price",price)
	.s amt=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("amt",amt)
	.s orditem=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("orditem",orditem)
	.i result="拒绝" s result="result:'<font color=red>"_result_"</font>',"
	.e  s result=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("result",result)
	.s patid=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("patid",patid)
	.s patname=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("patname",patname)
	.s mainflag=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("mainflag",mainflag)
	.s moeori=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("moeori",moeori)
	.s adm=##class(web.DHCSTJQUERYCOMMON).GetJsonLastCell("adm",adm)
	.
	.s tmpstr=incidesc_qty_uomdesc_dosage_freq_spec_instruc_form_ordpri_basflag_doctor_orddate_remark_manf_price_amt_orditem_result
	.s tmpstr=tmpstr_patid_patname_mainflag_moeori_adm
	.
    .s startString=##class(web.DHCSTJQUERYCOMMON).GetJsonStartString(maxrow)
    .s firstrow=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstRow(tmpstr)
    .s lastrow=##class(web.DHCSTJQUERYCOMMON).GetJsonLastRow(tmpstr)
	.
    .i count=stpage w startString
    .i count<endpage w firstrow
    .i count=endpage w lastrow
    
    
    k ^TMP("DHCST","DHCSTPHCMMONITORDRUG","QueryInPatOrdItemList",pid)
    q ""
	
getitmdata
	
	s papmi=$p(^PAADM(adm),"^",1)
    s patname=$p(^PAPER(papmi,"ALL"),"^",1)
    s patid=$p(^PAPER(papmi,"PAT",1),"^",1)
    s bedno="未分配"
    s beddr=$p(^PAADM(adm),"^",73)
    i beddr'="" s bedno=$p(^PAWARD($p(beddr,"||",1),"BED",$p(beddr,"||",2)),"^",1)
	s presc=$p(^OEORD(ord,"I",chl,1),"^",14) ;处方号
	
	q:presc="" 
	s dsp=$o(^DHCOEDISQTY(0,"OEORI",orditm,""))
	q:dsp="" 
	s priordr=+$p(^OEORD(ord,"I",chl,1),"^",8) 
    q:priordr=0 
    s priority=$p(^OECPR(priordr),"^",1) 			;医嘱优先级代码              
    q:priority["OM" ;自备药
    s statdr=$p(^OEORD(ord,"I",chl,1),"^",13)
    s oeflag=$p(^OEC("OSTAT",statdr),"^",1) 
	//q:(oeflag'="V")&(oeflag'="E")
	
    //q:(priority'["OUT")&(onlyout="true") 
    s result=##class(web.DHCSTCNTSCOMMON).GetOrdAuditResult(orditm)
    //q:(onlyadt="true")&(result="")
    //q:(onlyadt'="true")&(result'="")
    //s dodis=##class(web.DHCSTPCHCOLLS).GetDODIS(orditm)  q:dodis=""
    
	s arcimid=$p(^OEORD(ord,"I",chl,1),"^",2)  ;医嘱 ARC_ItmMast ARCIM_RowId
	s itmmastid=$p(arcimid,"||",1)
	s itmmastver=$p(arcimid,"||",2)
	s inci=$o(^INCI(0,"ARCIM_DR",$p(arcimid,"||",1),"") ) q:inci=""  //医嘱名称
	s inciDesc=$p(^INCI(inci,1),"^",2) //药品名称
    s qty=$p(^DHCOEDISQTY(dsp),"^",2)
	s puomdr=+$p(^INCI(inci,3),"^",6)
	s buomdr=+$p(^INCI(inci,1),"^",10)
	s fac=+##Class(web.DHCSTCOMMONSRV).UOMFac(puomdr,buomdr)
	s uomdr=buomdr
	i (qty#fac)=0 d
	.s qty=qty/fac   //数量
	.s uomdr=puomdr 
	s uomdesc=$p($g(^CT("UOM",uomdr)),"^",2) //单位
	s dosage=$j($p(^OEORD(ord,"I",chl,2),"^",1)," ",3) ;剂量
    s doseuom=""
	s dosuomID=+$p(^OEORD(ord,"I",chl,2),"^",3)
	i dosuomID'=0 d
	.s doseuom=$p($g(^CT("UOM",dosuomID)),"^",2) ;剂量单位
	s freq=""
	s freqdr=+$p($g(^OEORD(ord,"I",chl,2)),"^",4) ;OEORI_PHFreq_DR
    i freqdr'=0 s freq=$p($g(^PHCFR(freqdr)),"^",3)  ;频率
    s instru=""
    s instrudr=+$p(^OEORD(ord,"I",chl,2),"^",7)
    s:instrudr'=0 instru=$p(^PHCIN(instrudr),"^",2)        	;用法
    s duration=""
    s dur=+$p(^OEORD(ord,"I",chl,2),"^",6)
	s:dur'=0 duration=$p(^PHCDU(dur),"^",1)         	;用药疗程
	s priorty=""
	s pri=+$p(^OEORD(ord,"I",chl,1),"^",8)
	s:pri'=0 priorty=$p(^OECPR(pri),"^",2)   		;医嘱优先级
	s doctor=##class(web.DHCSTCOMMONSRV).getOrdDoctor(orditm)       ;医生
	s skintest=##class(web.DHCSTCOMMONSRV).GetSkinTestResult(orditm)  ;皮试
	s form=##class(web.DHCSTCOMMONSRV).GetForm(inci)  ;剂型
	i $F(form,$c(13)) s form=$tr(form,$c(13,10),"")
	s spec=##class(web.DHCSTCOMMONSRV).getBarcode(inci) ;规格
	s manf=##class(web.DHCSTITMDESC).GetManfNameByInci(inci) ;厂家
	i $f(manf,$c(13)) s manf=$tr(manf,$c(13,10),"")
	i $f(manf,"-") s manf=$p(manf,"-",2)
	s remark=##class(web.DHCSTCOMMONSRV).GetOrdItmRemark(orditm) ;备注
    s orddate=$p(^DHCOEDISQTY(dsp),"^",15)
    i orddate'="" s orddate=$zd(orddate,3)
    s ordtime=$p(^DHCOEDISQTY(dsp),"^",20)
    i ordtime'="" s ordtime=$zt(ordtime,1)
    s orddatetime=orddate_" "_ordtime  ;开单日期
    s status=$p(^DHCOEDISQTY(dsp),"^",7)
    s dspdate=+$h
	i status="C" s dspdate=$p(^DHCOEDISQTY(dsp),"^",8)
	s price=##class(web.DHCSTCOMMONSRV).GetPriceElse(+inci,dspdate,puomdr,"")
	s amt=$fn(price*qty,"",2)
	s specinstr=$p(^OEORD(ord,"I",chl,2),"^",8)
	s basflag=##class(web.DHCSTCNTSCOMMON).GetBasicDrugflag(inci)
	s moeori=##class(web.DHCSTCNTSCOMMON).GetMainOeori(orditm)
	s result=##class(web.DHCSTCNTSCOMMON).GetOrdAuditResult(orditm)
    s result=$p(result,",",4)
    i result="SHJJ" s result="拒绝"
    i result="SHTG" s result="通过"
	i moeori'=orditm d
	.s mainflag=0
	.s inciDesc="_____"_inciDesc
	e  d
	.s mainflag=1 
    s h=h+1
    s data=inciDesc_"^"_qty_"^"_uomdesc_"^"_dosage_doseuom_"^"_freq_"^"_spec_"^"_instru_"^"_duration_"^"_form
    s data=data_"^"_priorty_"^"_doctor_"^"_orddatetime_"^"_remark_"^"_manf_"^"_price_"^"_amt_"^"_specinstr_"^"_skintest
    s data=data_"^"_basflag_"^"_orditm_"^"_result_"^"_patid_"^"_patname_"^"_mainflag_"^"_moeori_"^"_adm
    s index=bedno_"^"_adm_"^"_orddatetime_"^"_moeori_"^"_orditm
    s ^TMP("DHCST","DHCSTPHCMMONITORDRUG","QueryInPatOrdItemList",pid,"index",index,h)=data
    
    s h=0
    s index=""
    f  s index=$o(^TMP("DHCST","DHCSTPHCMMONITORDRUG","QueryInPatOrdItemList",pid,"index",index)) q:index=""  d
    .s num=""
    .f  s num=$o(^TMP("DHCST","DHCSTPHCMMONITORDRUG","QueryInPatOrdItemList",pid,"index",index,num)) q:num=""  d
    ..s data=^TMP("DHCST","DHCSTPHCMMONITORDRUG","QueryInPatOrdItemList",pid,"index",index,num)
    ..s h=h+1
    ..s ^TMP("DHCST","DHCSTPHCMMONITORDRUG","QueryInPatOrdItemList",pid,"itm",h)=data
    
    q
}

/// 不良反应用药查询
/// w ##class(web.DHCSTPHCMMONITORDRUG).QueryAdrData()
/// result新建时是空,忽略关注是"Y",标志原因了是"N"
ClassMethod QueryAdrData() As %String
{

        s apptype="ADR"
		s admtype="I"
		s adm=""
		f  s adm=$o(^PAADMi("PAADM_Type",admtype,adm)) q:adm=""  d
		.s chkflag=##class(web.DHCSTPHCMEMPPAT).GetMFlagByAdm(adm,apptype)
		.q:chkflag'=""
		.s admdate=$p(^PAADM(adm),"^",6)
		.s %EpisodeID=adm
		.s %argStDate=admdate
	    .s %argEndDate=+$h
		.s ret=##class(web.DHCSTPHCMFUNLIBITM).CheckDrugExist(apptype)
	    .q:ret=1
	    .s ret=##class(web.DHCSTPHCMFUNLIBITM).CheckLabItmResult(apptype)
	    .q:ret'=""
	    .s input=""_"^"_adm_"^"_""_"^"_apptype
	    .s ret=##class(web.DHCSTPHCMEMPPAT).AddEmpFlag(input)
	    .
	    
	    q ""
}

/// w ##class(web.DHCSTPHCMMONITORDRUG).QueryReaDs()
ClassMethod QueryReaDs(rows, page, input) As %String
{
		s pid=##class(web.DHCSTPHCMCOMMON).GetPID()

	    s endpage=page*rows  //结束行
	    s stpage=((page-1)*rows)+1 //开始行
	    
		s h=0
		s waycode="3"
		s id=""
		f  s id=$o(^DHCPCREASON(0,"Level",waycode,id)) q:id=""  d
		.s reasondr=""
		.f  s reasondr=$o(^DHCPCREASON(0,"Level",waycode,id,reasondr)) q:reasondr=""  d
		..s desc=$p(^DHCPCREASON(reasondr),"^",2)
		..s parentId=id
		..i id=0 s parentId=""
		..s rowid=reasondr
		..
		..s h=h+1
		..s data=desc_"^"_parentId_"^"_rowid
	    ..s ^TMP("DHCST","DHCSTPHCMMONITORDRUG","QueryReaDs",pid,h)=data
	    
	    q:h=0 ##class(web.DHCSTJQUERYCOMMON).GetNoJson()
	    s maxrow=h
    
	    s count=0
	    s h=""
	    f  s h=$o(^TMP("DHCST","DHCSTPHCMMONITORDRUG","QueryReaDs",pid,h)) q:h=""  d
	    .s data=^TMP("DHCST","DHCSTPHCMMONITORDRUG","QueryReaDs",pid,h)
	    .s desc=$p(data,"^",1)
	    .s parentId=$p(data,"^",2)
	    .s rowid=$p(data,"^",3)
	    .
	    .s desc=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("desc",desc) 
	    .s rowid=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("rowid",rowid) 
		.s parentId=##class(web.DHCSTJQUERYCOMMON).GetJsonLastCell("_parentId",parentId)
		.
		.s tmpstr=desc_rowid_parentId
	    .s startString=##class(web.DHCSTJQUERYCOMMON).GetJsonStartString(maxrow)
	    .s firstrow=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstRow(tmpstr)
	    .s lastrow=##class(web.DHCSTJQUERYCOMMON).GetJsonLastRow(tmpstr)
		.s count=count+1
		.i count=1 w startString
	    .i count<maxrow w firstrow
	    .i count=maxrow w lastrow
		.
		k ^TMP("DHCST","DHCSTPHCMMONITORDRUG","QueryReaDs",pid)
		q ""
}

/// 保存原因
ClassMethod SaveReaForMon(input) As %String
{
	
	s user=$p(input,"^",1)
	s adm=$p(input,"^",2)
	s rea=$p(input,"^",3)
	s currdate=+$h
	s currtime=$p($h,",",2)
	
	s apptype="ADR"
	
	tstart
	s err=0
	k PLIST
	s PLIST(2)=user
	s PLIST(3)="N"
	s PLIST(4)=currdate
	s PLIST(5)=currtime
	s PLIST(10)=apptype 
	&sql(INSERT INTO DHC_PHAORDMONITOR  VALUES :PLIST())
	i SQLCODE'=0  tro 
	i SQLCODE'=0 s err=1
	q:err'=0 -2
	s phaomr=+%ROWID
	//
	s cnt=$l(rea,",")
	f i=1:1:cnt d
	.s reason=$p(rea,",",i)
	.k PLIST
	.s PLIST(0)=phaomr
	.s PLIST(5)=+$o(^DHCPHORDM(phaomr,"I",""),-1)+1
	.s PLIST(4)=reason
	.s PLIST(7)=adm
	.&sql(INSERT INTO DHC_PHAORDMONITORLIST  VALUES :PLIST())
	.i SQLCODE'=0  tro 
	.i SQLCODE'=0 s err=1

	q:err'=0 -1
	tcommit
	
	q err
}

/// w ##class(web.DHCSTPHCMMONITORDRUG).GetAdmReaDs("77")
ClassMethod GetAdmReaDs(input) As %String
{
	s ret=""
	s pid=##class(web.DHCSTPHCMCOMMON).GetPID()
	s h=0
	s adm=$p(input,"^",1)
	s exit=0
	s main=""
	f  s main=$o(^DHCPHORDM(0,"Adm",adm,main),-1) q:(main="")||(exit=1)  d
    .s flag=$p(^DHCPHORDM(main),"^",2)
    .q:flag'="N"
    .s exit=1
    .s sub=""
    .f sub=$o(^DHCPHORDM(main,"I",sub)) q:sub=""  d
    ..s reasondr=$p(^DHCPHORDM(main,"I",sub),"^",3)
    ..s desc=""
    ..i reasondr'="" d
    ...s desc=$p(^DHCPCREASON(reasondr),"^",2)
    ..s rowid=reasondr
    ..s h=h+1
	..s data=desc_"^"_rowid
	..s ^TMP("DHCST","DHCSTPHCMMONITORDRUG","GetAdmReaDs",pid,h)=data
	    
	q:h=0 ##class(web.DHCSTJQUERYCOMMON).GetNoJson()
	s maxrow=h
    
    s count=0
    s h=""
    f  s h=$o(^TMP("DHCST","DHCSTPHCMMONITORDRUG","GetAdmReaDs",pid,h)) q:h=""  d
    .s data=^TMP("DHCST","DHCSTPHCMMONITORDRUG","GetAdmReaDs",pid,h)
    .s desc=$p(data,"^",1)
    .s rowid=$p(data,"^",2)
    .
    .s desc=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("desc",desc) 
    .s rowid=##class(web.DHCSTJQUERYCOMMON).GetJsonLastCell("rowid",rowid) 
	.
	.s tmpstr=desc_rowid
    .s startString=##class(web.DHCSTJQUERYCOMMON).GetJsonStartString(maxrow)
    .s firstrow=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstRow(tmpstr)
    .s lastrow=##class(web.DHCSTJQUERYCOMMON).GetJsonLastRow(tmpstr)
	.s count=count+1
	.i count=1 s ret=startString
    .i count<maxrow s ret=ret_firstrow
    .i count=maxrow s ret=ret_lastrow
	.
	k ^TMP("DHCST","DHCSTPHCMMONITORDRUG","GetAdmReaDs",pid)
	q ret
}

/// Creator:bianshuai
/// CreateDate:2014-09-19
/// Descript:夜晚监控执行函数 ---执行插入不成功的情况下是否进行global记录错误问题
/// w ##Class(web.DHCSTPHCMMONITORDRUG).NightMonitor()
ClassMethod NightMonitor() As %String
{
	S AdmDr="",Num=0
	F  S AdmDr=$o(^PAADMi("PAADM_Type","I",AdmDr)) Q:AdmDr=""  D
	.S patVisit=$p($g(^PAADM(AdmDr)),"^",20)
    .//Q:patVisit'="A"
    .S Num=Num+1
    .W Num,!
    /*
    .S AdmDate=$p(^PAADM(AdmDr),"^",6)
	.S %EpisodeID=AdmDr
	.S %argStDate=AdmDate
    .S %argEndDate=+$h
	.d ..CheckThemeItm()
	*/
    Q Num
}

/// Descript:根据主题生成监测数据
ClassMethod CheckThemeItm() As %String
{
	N (%EpisodeID,%argStDate,%argEndDate)
	S ThemeID=""
	F  S ThemeID=$o(^DHCPHFUTHE(ThemeID)) Q:ThemeID=""  D
	.S ch=""
	.F  S ch=$o(^DHCPHFUTHE(ThemeID,"I",ch)) Q:ch=""  D
	..S apptype=$p(^DHCPHFUTHE(ThemeID,"I",ch),"^",1) //项目代码
	..S desc=$p(^DHCPHFUTHE(ThemeID,"I",ch),"^",2) //项目名称
	..S chkflag=##class(web.DHCSTPHCMEMPPAT).GetMFlagByAdm(%EpisodeID,apptype)
	..Q:chkflag'=""  //已存在
    ..S ret=##class(web.DHCSTPHCMFUNLIBITM).ExecMonitorLibFun(ThemeID_"||"_ch)
    ..Q:ret'="1"
    ..S input=""_"^"_%EpisodeID_"^"_""_"^"_apptype
    ..S ret=##class(web.DHCSTPHCMEMPPAT).AddEmpFlag(input) //记录监测信息
    Q 0
}

}
