Import SQLUser

/// 配液复核
Class web.DHCSTPIVAOUTRECHECK Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// 通过瓶签条码，查询配液减库数据
/// Creator:Pengzhikun
/// CreatDate:2014-07-20
/// Input:瓶签条码
/// Output:明细
/// d ##class(web.DHCSTPIVAOUTRECHECK).GetPatientId("1422-3-5","0","200","22/07/2014^25/07/2014^237^false")
ClassMethod GetPatientId(barcode, StPage, Limit, input) As %String
{
	S ord=$P(barcode,"-",1)
	s adm=$p(^OEORD(ord),"^",1)
    s papmidr=$p(^PAADM(adm),"^",1)
    S PapmiNo=$p(^PAPER(papmidr,"PAT",1),"^",2) // 病人ID号
    ;拼接新的input
    s Input=$p(input,"^",1)_"^"_$p(input,"^",2)_"^"_$p(input,"^",3)_"^"_PapmiNo_"^"_$p(input,"^",4)
    ;执行查询改病人的配液数据
    d ..FindReCheckPatInfo(PapmiNo,StPage,Limit,Input)
    q ""
}

/// 查询配液减库数据	
/// Creator:LiangQiang
/// CreatDate:2013-05-31
/// Input:登记号,开始行,限制行,参数串
/// Output:明细
/// d ##class(web.DHCSTPIVAOUTRECHECK).FindReCheckPatInfo("","0","200","20/07/2014^25/07/2014^237^^false")
ClassMethod FindReCheckPatInfo(RegNo, StPage, Limit, Input) As %String
{
	S cnumber=70  /// 复核
	s pid=##class(web.DHCSTPIVAOUTCOMMON).GetPIVAOUTPID()
	s stdate=$p(Input,"^",1)
	s stdate=$zdh(stdate,4)
	s enddate=$p(Input,"^",2)
	s enddate=$zdh(enddate,4)
    s phalocdr=$p(Input,"^",3)
    s patID=$p(Input,"^",4)
    s checkflag=$p(Input,"^",5)
    s type="O"   //门诊
    s endpage=StPage+Limit  //结束行
	s stpage=StPage+1 //开始行

	f date=stdate:1:enddate  d
	.s pogid=""
	.f  s pogid=$o(^PIVA(0,"LOCORDDATE",phalocdr,date,pogid)) q:pogid=""  d
	..s barcode=$p(^PIVA(pogid),"^",17)
 	..///下一个配药状态
 	..S psdr=$P(^PIVA(pogid),"^",6)
 	..S nextstr=##class(web.DHCSTPIVAOUTCOMMON).GetNextStat(psdr,phalocdr,type)
 	..S nextnumber=$P(nextstr,"^",2)
 	..Q:nextnumber="" //Q出状态码为空的，护士接收之后状态码也为空
 	..s statenumber=nextnumber
 	..//Q:nextnumber'=cnumber
 	..;Q:(checkflag'="true")&(nextnumber'=cnumber)
 	..Q:(checkflag'="true")&(nextnumber'=cnumber)&(nextnumber'="") //penzi,查询未审核的，包含审核前几个状态的药品(以便查询审核前的药品提醒)
 	..;Q:(checkflag="true")&(nextnumber<=cnumber)&(nextnumber'="")
 	..Q:(checkflag="true")&(nextnumber'>cnumber)&(nextnumber'="") //2014-7-27 penzi  查询未复核的，默认显示所有
 	../// 明细
	..s pogsub=""
	..F  s pogsub=$O(^PIVA(pogid,"I",pogsub)) Q:pogsub=""  D
	...S dodis=$P(^PIVA(pogid,"I",pogsub),"^",1)
	...Q:dodis=""
	...Q:'$D(^DHCOEDISQTY(dodis))
	...S OrdExeRowid=$p(^DHCOEDISQTY(dodis),"^",3) //判断执行记录
    ...q:##class(web.DHCSTPIVAOUTCOMMON).GetOrdState(OrdExeRowid)=0
    ...S dspstatus=$p(^DHCOEDISQTY(dodis),"^",7)
 	...//Q:dspstatus'="C"	/// 已经确认发药
	...S oeori=$p(^DHCOEDISQTY(dodis),"^",1)
	...S pri=##class(web.DHCSTPIVAOUTCOMMON).GetOePriority(oeori)
	...S pricode=$P(pri,"^",2)
	...S pricode=$ZCVT(pricode,"U")
	...//Q:pricode["OM"
	...Q:(pricode'["OM")&(dspstatus'="C")
	...S ord=$P(oeori,"||",1)
 	...S chl=$P(oeori,"||",2) 
 	...S incitm=##class(web.DHCSTPIVAOUTCOMMON).GetIncItm(oeori)
 	...S inci=$P(incitm,"^",1)
 	...S itmdesc=$P(incitm,"^",3)
 	...S qty=$P(^DHCOEDISQTY(dodis),"^",11)
 	...S stkbin=##class(web.DHCSTPIVAOUTCOMMON).GetStkBin(phalocdr,inci)
 	...s adm=$p(^OEORD(ord),"^",1)
    ...s papmidr=$p(^PAADM(adm),"^",1)
    ...S admtype=$p(^PAADM(adm),"^",2)
    ...Q:admtype="I"
    ...S PapmiNo=$p(^PAPER(papmidr,"PAT",1),"^",2) // 2014-07-16 bianshuai
	...Q:(PapmiNo'=RegNo)&(RegNo'="")			   // 2014-07-16 bianshuai
    ...s orddate=$p(^DHCOEDISQTY(dodis),"^",21)
    ...s ordtime=$p(^DHCOEDISQTY(dodis),"^",20)
    ...s grpno=$p(^DHCOEDISQTY(dodis),"^",4)
    ...s seqno=$P(^OEORD(ord,"I",chl,3),"^",4)
    ...s index=papmidr_"^"_adm_"^"_orddate_"^"_ordtime_"^"_pogid_"^"_grpno_"^"_oeori_"^"_statenumber_"^"_seqno //seqno要在最后否则主医嘱不在第一条
    ...s index2=dodis
    ...s ^TMP("dhcpha","DHCSTPIVAOUTOPSTOCK","FindOrdGrpDetail",pid,"index",index,index2)=""
    
    s h=0
    s index=""
    f  s index=$o(^TMP("dhcpha","DHCSTPIVAOUTOPSTOCK","FindOrdGrpDetail",pid,"index",index)) q:index=""  d
    .s adm=$p(index,"^",2)
    .s pogid=$p(index,"^",5)
    .s oeori=$p(index,"^",7)
    .s statenumber=$p(index,"^",8)
   	.s ord=$p(oeori,"||",1)
	.s chl=$p(oeori,"||",2)
	.s prescno=$p(^OEORD(ord,"I",chl,1),"^",14)
    .s papmi=+$p(^PAADM(adm),"^",1)
    .s patno=$p(^PAPER(papmi,"PAT",1),"^",2)
    .s patname=$p(^PAPER(papmi,"ALL"),"^",1)           
    .s arcimid=$p(^OEORD(ord,"I",chl,1),"^",2)  ;医嘱 ARC_ItmMast ARCIM_RowId
	.s itmmastid=$p(arcimid,"||",1)
	.s itmmastver=$p(arcimid,"||",2)
	.s inci=$o(^INCI(0,"ARCIM_DR",$p(arcimid,"||",1),"") ) q:inci=""  //医嘱名称
	.s inciDesc=$p(^INCI(inci,1),"^",2) //药品名称
	.s puomdr=$p(^ARCIM(itmmastid,itmmastver,8),"^",14)
	.s buomdr=+$p(^INCI(inci,1),"^",10)
	.s fac=+##Class(web.DHCSTCOMMONSRV).UOMFac(puomdr,buomdr)
	.s uomdr=buomdr
	.s dosage=$j($p(^OEORD(ord,"I",chl,2),"^",1)," ",3) ;剂量
    .s doseuom=""
	.s dosuomID=$p(^OEORD(ord,"I",chl,2),"^",3)
	.i dosuomID'="" d
	..s doseuom=$p($g(^CT("UOM",dosuomID)),"^",2) ;剂量单位
	.s freq=""
	.s freqdr=+$p($g(^OEORD(ord,"I",chl,2)),"^",4) ;OEORI_PHFreq_DR
    .i freqdr'=0 s freq=$p($g(^PHCFR(freqdr)),"^",3)  ;频率
    .s instru=""
    .s instdr=+$p(^OEORD(ord,"I",chl,2),"^",7)
    .i instdr'=0 s instru=$p(^PHCIN(instdr),"^",2)        	;用法
    .s duration=""
    .s durationdr=+$p(^OEORD(ord,"I",chl,2),"^",6)
	.i durationdr'=0 s duration=$p(^PHCDU(durationdr),"^",1)         	;用药疗程
	.s priorty=""
	.s pri=+$p(^OEORD(ord,"I",chl,1),"^",8)
	.s priorty=$p(^OECPR(pri),"^",2)   		;医嘱优先级
	.s doctor=##class(web.DHCSTCOMMONSRV).getOrdDoctor(oeori)       ;医生
	.s skintest=##class(web.DHCSTCOMMONSRV).GetSkinTestResult(oeori)  ;皮试
	.s form=##class(web.DHCSTCOMMONSRV).GetForm(inci)  ;剂型
	.i $F(form,$c(13)) s form=$p(form,$c(13))
	.s spec=##class(web.DHCSTCOMMONSRV).getBarcode(inci) ;规格
	.s remark=##class(web.DHCSTCOMMONSRV).GetOrdItmRemark(oeori) ;备注
	.s qty=0
	.s index2=""
    .f  s index2=$o(^TMP("dhcpha","DHCSTPIVAOUTOPSTOCK","FindOrdGrpDetail",pid,"index",index,index2)) q:index2=""  d
    ..s dodis=$p(index2,"^",1)
    ..s qty=$P(^DHCOEDISQTY(dodis),"^",11)
    ..s orddate=$p(^DHCOEDISQTY(dodis),"^",21)
    ..i orddate="" s orddate=$p(^DHCOEDISQTY(dodis),"^",15)
    ..i orddate'="" s orddate=$zd(orddate,3)
    ..s ordtime=$p(^DHCOEDISQTY(dodis),"^",20)
    ..i ordtime="" s ordtime=$p(^DHCOEDISQTY(dodis),"^",16)
    ..i ordtime'="" s ordtime=$zt(ordtime,1)
    ..s orddatetime=orddate_" "_ordtime  ;开单日期
    ..S grpno=$p(^DHCOEDISQTY(dodis),"^",4)
    ..S mdodis=##class(web.DHCSTPIVA).GetMainOEDispID(dodis,grpno)
    ..S OrdExecRowid=$p(^DHCOEDISQTY(mdodis),"^",3)
	..S barcode=$REPLACE(OrdExecRowid,"||","-")
    ..i (qty#fac)=0 d
	...s qty=qty/fac   //数量
	...s uomdr=puomdr 
	..s uomdesc=$p($g(^CT("UOM",uomdr)),"^",2) //单位
	..s selectflag=mdodis   //1
    ..s packflag=##class(web.DHCSTPIVAOUTCOMMON).GetPackFlag(mdodis) //打包状态 bianshuai
	..s h=h+1
	..s tmpindex=prescno_"||"_orddatetime //_"||"_mdodis
	..s prescnoT=prescno
	..i $D(^TMP("dhcpha","DHCSTPIVAOUTOPSTOCK","FindOrdGrpDetail","PrescNo","mdodis",pid,mdodis)) d
    ...s selectflag=""
    ..e  d
    ...s ^TMP("dhcpha","DHCSTPIVAOUTOPSTOCK","FindOrdGrpDetail","PrescNo","mdodis",pid,mdodis)=""
    ..
    ..i $D(^TMP("dhcpha","DHCSTPIVAOUTOPSTOCK","FindOrdGrpDetail","PrescNo",pid,tmpindex)) d
    ...s orddatetime=""
    ...s prescno=""
    ...s patno="",patname=""
    ..e  d
    ...s ^TMP("dhcpha","DHCSTPIVAOUTOPSTOCK","FindOrdGrpDetail","PrescNo",pid,tmpindex)=""
	..s data=inciDesc_"^"_qty_"^"_uomdesc_"^"_dosage_doseuom_"^"_freq_"^"_spec_"^"_instru_"^"_duration_"^"_form
    ..s data=data_"^"_priorty_"^"_doctor_"^"_orddatetime_"^"_remark_"^"_"^"_oeori_"^"_prescno_"^"_selectflag
    ..s data=data_"^"_patno_"^"_patname_"^"_dodis_"^"_pogid_"^"_packflag_"^"_barcode_"^"_statenumber_"^"_adm_"^"_prescnoT
    ..s ^TMP("dhcpha","DHCSTPIVAOUTOPSTOCK","FindOrdGrpDetail",pid,"Itm",prescnoT,mdodis,h)=data
	
	q:h=0 ##class(web.DHCSTEXTCOMMON).GetNoJson()
    s maxrow=h
    i endpage>maxrow s endpage=maxrow
    s count=0
    
    s prescnox=""
    f  s prescnox=$o(^TMP("dhcpha","DHCSTPIVAOUTOPSTOCK","FindOrdGrpDetail",pid,"Itm",prescnox)) q:prescnox=""  d
    .s mdodis=""
    .f  s mdodis=$o(^TMP("dhcpha","DHCSTPIVAOUTOPSTOCK","FindOrdGrpDetail",pid,"Itm",prescnox,mdodis)) q:mdodis=""  d  
    ..s h=""
    ..f  s h=$o(^TMP("dhcpha","DHCSTPIVAOUTOPSTOCK","FindOrdGrpDetail",pid,"Itm",prescnox,mdodis,h)) q:h=""  d
    ...s data=^TMP("dhcpha","DHCSTPIVAOUTOPSTOCK","FindOrdGrpDetail",pid,"Itm",prescnox,mdodis,h)
    ...s incidesc=$p(data,"^",1)
    ...s qty=$p(data,"^",2)
    ...s uomdesc=$p(data,"^",3)
    ...s dosage=$p(data,"^",4)
    ...s freq=$p(data,"^",5)
    ...s spec=$p(data,"^",6)
    ...s instruc=$p(data,"^",7)
    ...s dura=$p(data,"^",8)
    ...s form=$p(data,"^",9)
    ...s pri=$p(data,"^",10)
    ...s doctor=$p(data,"^",11)
    ...s orddate=$p(data,"^",12)
    ...s remark=$p(data,"^",13)
    ...s manf=$p(data,"^",14)
    ...s orditm=$p(data,"^",15)
    ...s prescno=$p(data,"^",16)
    ...s selectflag=$p(data,"^",17)
    ...s patno=$p(data,"^",18)
    ...s patname=$p(data,"^",19)
    ...s dsprowid=$p(data,"^",20)
    ...s pogid=$p(data,"^",21)
    ...s packflag=$p(data,"^",22)
    ...s barcode=$p(data,"^",23)
    ...s statenumber=$p(data,"^",24)
    ...s AdmDr=$p(data,"^",25)
    ...s prescnoT=$p(data,"^",26)
    ...
    ...s count=count+1
    ...q:count<stpage
    ...q:count>endpage
    ...
    ...s incidesc=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("incidesc",incidesc)
	...s qty=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("qty",qty)
	...s uomdesc=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("uomdesc",uomdesc)
	...s dosage=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("dosage",dosage)
	...s freq=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("freq",freq)
	...s spec=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("spec",spec)
	...s instruc=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("instruc",instruc)
	...s dura=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("dura",dura)
	...s form=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("form",form)
	...s pri=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("pri",pri)
	...s doctor=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("doctor",doctor)
	...s orddate=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("orddate",orddate)
	...s remark=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("remark",remark)
	...s orditm=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("orditm",orditm)
	...s prescno=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("prescno",prescno)
	...s prescnoT=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("prescnoT",prescnoT)
	...s selectflag=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("selectflag",selectflag)
	...s patno=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("patid",patno)
	...s patname=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("patname",patname)
	...s dsprowid=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("dsprowid",dsprowid)
	...s packflag=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("packflag",packflag)
	...s barcode=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("barcode",barcode)
	...s statenumber=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("statenumber",statenumber)
	...s AdmDr=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("AdmDr",AdmDr)
	...s pogid=##class(web.DHCSTEXTCOMMON).GetJsonLastCell("pogid",pogid)
	...
	...s tmpstr=incidesc_qty_uomdesc_dosage_freq_spec_instruc_dura_form_pri_doctor_orddate_remark_orditm_prescno_prescnoT_selectflag
	...s tmpstr=tmpstr_patno_patname_dsprowid_packflag_barcode_statenumber_AdmDr_pogid
	...
    ...s startString=##class(web.DHCSTEXTCOMMON).GetJsonStartString(maxrow)
    ...s firstrow=##class(web.DHCSTEXTCOMMON).GetJsonFirstRow(tmpstr)
    ...s lastrow=##class(web.DHCSTEXTCOMMON).GetJsonLastRow(tmpstr)
	...
    ...
    ...i count=stpage w startString
    ...i count<endpage w firstrow
    ...i count=endpage w lastrow
    
    
    k ^TMP("dhcpha","DHCSTPIVAOUTOPSTOCK","FindOrdGrpDetail",pid)
    q ""
}

ClassMethod SavePivaReCheck(pog, user)
{
	S AskUserdr=$o(^DHCPHPERi("USR",user,""))
	Q:AskUserdr="" -99
	S cnumber=70
	S type="O"
	S psdr=$P(^PIVA(pog),"^",6) /// pog的当前状态
	S phlocdr=$P(^PIVA(pog),"^",7)
	S nextstr=##class(web.DHCSTPIVAOUTCOMMON).GetNextStat(psdr,phlocdr,type)
	S nextnumber=$P(nextstr,"^",2)
	s nownumber=$P(^PIVAS(psdr),"^",1)
	q:nownumber=cnumber -13
	q:nextnumber'=cnumber -1
	//S recflag=..CheckIfRec(pog)   //检查是否已接收
	//q:recflag'=0 -21
	S ps=##class(web.DHCSTPIVAOUTCOMMON).GetCurrPSDrByNum(cnumber,phlocdr,type)
	L +^PIVA(pog):10  e  q -12
	TSTART
	//处理 PIVA_OrdGrp系列表
	S ret=##class(web.DHCSTPIVAOUTOPSTOCK).UpdPog(pog,ps,user)
	b ///hhh
	I ret'=0 TRo
	i ret'=0 d unlock
	i ret'=0 q -14
	TCOMMIT
	d unlock
	Q ret
unlock
	L -^PIVA(pog)
}

ClassMethod GetPrintReceiptInfo() As %String
{
}

/// Creator:bianshuai
/// CreateDate:2014-09-20
/// Descript:打印输液清单
/// D ##Class(%ResultSet).RunQuery("web.DHCSTPIVAOUTRECHECK","PrtInfusionList","33871","237")
Query PrtInfusionList(AdmDr As %String, LocDr As %String) As %Query(ROWSPEC = "Seqno:%String,Desc:%String,DoseQty:%String,Instr:%String,Ferq:%String,Durat:%String,mseqno:%Integer") [ SqlProc ]
{
}

ClassMethod PrtInfusionListExecute(ByRef qHandle As %Binary, AdmDr As %String, LocDr As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1
	i AdmDr="" Quit $$$OK
	i LocDr="" Quit $$$OK
	S pid=..NewPid() //计数器
	D ..killTempGlobal(pid)
	S seqind=1
	S AdmDate=$p(^PAADM(AdmDr),"^",6) ;就诊日期
    S ord=$o(^OEORD(0,"Adm",AdmDr,"")) 
	Q:ord=""	 //对应就诊日期下该病人ord
    S chl=""
    S dsp=""
    //F  S chl=$o(^OEORDi(0,"LocStDtArr",LocDr,0,AdmDate,ord,chl)) Q:chl=""  D
    //F  S dsp=$o(^DHCOEDISQTY(0,"ADM",LocDr,+$h,"C",AdmDr,dsp)) Q:dsp=""  D
    F  S dsp=$o(^DHCOEDISQTY(0,"ADM",AdmDr,dsp)) b  Q:dsp=""  D
    .s pivareq=$o(^PIVADIS(0,"DODIS",dsp,""))
    .q:pivareq=""
    .q:$p(^PIVADIS(pivareq),"^",3)'="Y"  //非打包退出
    .s oeori=$p(^DHCOEDISQTY(dsp),"^",1)
	.S ord=+oeori
	.S chl=$p(oeori,"||",2)
	.b
	.S prescno=$p(^OEORD(ord,"I",chl,1),"^",14)
	.Q:prescno=""
	.S itmmast=$p(^OEORD(ord,"I",chl,1),"^",2)
    .S ItemCatDR=$p(^ARCIM($p(itmmast,"||",1),$p(itmmast,"||",2),1),"^",10)
    .S ordertype=$P(^ARC("IC",ItemCatDR),"^",7)
    .Q:ordertype'="R"
    .S oeflag=$p(^OEC("OSTAT",$p(^OEORD(ord,"I",chl,1),"^",13)),"^",1) //医嘱状态
    .;Q:(oeflag'="V")&(oeflag'="E")
    .S doseqty=$p($g(^OEORD(ord,"I",chl,2)),"^",1) //剂量
    .S unitdr=$p($g(^OEORD(ord,"I",chl,2)),"^",3)   //单位
    .S:unitdr'="" unit=$p(^CT("UOM",unitdr),"^",2)
    .S phfragdr=+$p($g(^OEORD(ord,"I",chl,2)),"^",4) 
    .S phfre=$p($g(^PHCFR(phfragdr)),"^",3)  //频率
    .S duratdr=+$p($g(^OEORD(ord,"I",chl,2)),"^",6) 
    .S durat=$p($g(^PHCDU(duratdr)),"^",3)  //疗程
    .S instrdr=$p($g(^OEORD(ord,"I",chl,2)),"^",7) //用法
    .S instr=$p($g(^PHCIN(instrdr)),"^",2)
    .S moeori=##class(web.DHCSTPIVA).GetMainOeori(oeori)
    .Q:$d(^TMP("DHCST","web.DHCSTPIVAOUTRECHECK","PrtInfusionMainInfo",pid,moeori_"||"_oeori))
    .S inci=$o(^INCI(0,"ARCIM_DR",$p(itmmast,"||",1),""))
    .Q:inci=""
    .S incidesc=$p(^INCI(inci,1),"^",2)
    .
    .S ^TMP("SEQNUM",pid,oeori)=seqind
    .If '$d(^TMP("SEQPOINT",pid,moeori)) D
    ..S ^TMP("SEQPOINT",pid,oeori)=0
    .S mseqno=seqind  //主序号
    .If moeori'=oeori D
    ..S ^TMP("SEQPOINT",pid,moeori)=^TMP("SEQPOINT",pid,moeori)+1
    ..S oeseqno=^TMP("SEQNUM",pid,moeori)_"."_^TMP("SEQPOINT",pid,moeori)
    .E  D
    ..S oeseqno=seqind
    ..S seqind=seqind+1
    .S ListData=oeseqno_"^"_incidesc_"^"_doseqty_unit_"^"_instr_"^"_phfre_"^"_durat_"^"_mseqno
    .S index=moeori_"||"_oeori
    .S ^TMP("DHCST","web.DHCSTPIVAOUTRECHECK","PrtInfusionMainInfo",pid,index)=ListData

	S i=""
	f  S i=$o(^TMP("DHCST","web.DHCSTPIVAOUTRECHECK","PrtInfusionMainInfo",pid,i)) Q:i=""  D
	.S mdata=$g(^TMP("DHCST","web.DHCSTPIVAOUTRECHECK","PrtInfusionMainInfo",pid,i))
	.//mdata列表 Desc,DoseQty,Instr,Ferq,Durat
	.//mdata列表 药品名称,剂量,用法,频次,疗程
	.S ListData=$LISTFROMSTRING(mdata,"^")   //converted into a Cache list
	.Set ^CacheTemp(repid,ind)=ListData	
	.Set ind=ind+1
	.
	D ..killTempGlobal(pid)
	Set QHandle=$lb(0,repid,0)
	Quit $$$OK
}

ClassMethod PrtInfusionListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = PrtInfusionListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod PrtInfusionListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = PrtInfusionListExecute ]
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

/// Creator:bianshuai
/// CreateDate:2014-09-20
/// Descript:病人基本信息
ClassMethod PrtInfusionMainInfo(AdmDr As %String) As %String
{
	//N (AdmDr)
	S papmidr=$p(^PAADM(AdmDr),"^",1)
    S PapmiNo=$p(^PAPER(papmidr,"PAT",1),"^",2) //登记号
	S AdmDate=$p(^PAADM(AdmDr),"^",6) //就诊日期
    i AdmDate'="" s AdmDate=$zd(AdmDate,3)
    S papmi=$p(^PAADM(AdmDr),"^",1)
    S PatName=$p(^PAPER(papmi,"ALL"),"^",1) //姓名
    S PatAge=##class(web.DHCOutPhCommon).GetAge(papmi) //年龄 
    S SexId=$p(^PAPER(papmi,"ALL"),"^",7)
    S PatSex=$p(^CT("SEX",SexId),"^",2) //性别
    S AdmLoc=$p(^PAADM(AdmDr),"^",4)  //就诊科室
    S AdmLoc=$p($p(^CTLOC(AdmLoc),"^",2) ,"-",2)
    Q PapmiNo_"^"_PatName_"^"_PatSex_"^"_PatAge_"^"_AdmDate_"^"_AdmLoc
}

/// Descript:k掉临时global
ClassMethod killTempGlobal(pid As %String) As %String
{
    k ^TMP("SEQNUM",pid)
	k ^TMP("SEQPOINT",pid)
	k ^TMP("DHCST","web.DHCSTPIVAOUTRECHECK","PrtInfusionMainInfo",pid)
}

/// Descript:计数器
ClassMethod NewPid() As %String
{
	Q $I(^DHCST("PIVAOUTRECHECK"))
}

}
