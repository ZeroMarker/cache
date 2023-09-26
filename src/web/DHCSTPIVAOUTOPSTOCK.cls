Import SQLUser

/// 配液减库
Class web.DHCSTPIVAOUTOPSTOCK Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// 查询配液减库数据	
/// Creator:LiangQiang
/// CreatDate:2013-05-31
/// Input:登记号,开始行,限制行,参数串
/// Output:明细
ClassMethod FindOrdGrpDetail(RegNo, StPage, Limit, Input) As %String
{
	
	S cnumber=60  /// 60固定为打签状态
	s pid=##class(web.DHCSTPIVAOUTCOMMON).GetPIVAOUTPID()
	s stdate=$p(Input,"^",1)
	s stdate=$zdh(stdate,4)
	s enddate=$p(Input,"^",2)
	s enddate=$zdh(enddate,4)
    s phalocdr=$p(Input,"^",3)
    s patID=$p(Input,"^",4)
    s prtnostr=$p(Input,"^",5)
    s labelno=$p(Input,"^",6)
    s type="O"   //门诊
    
    s endpage=StPage+Limit  //结束行
	s stpage=StPage+1 //开始行
	s pogspsdr=##class(web.DHCSTPIVAOUTCOMMON).GetCurrPSDrByNum(10,phalocdr,type)

	f date=stdate:1:enddate  d
	.s pogid=""
	.f  s pogid=$o(^PIVA(0,"LOCSTATE",phalocdr,date,pogspsdr,pogid)) q:pogid=""  d
	..s barcode=$p(^PIVA(pogid),"^",17)
	..//q:(barcode'=labelno)&(labelno'="")  //检查瓶签号
	..//s pogschl=$o(^PIVA(0,"PS",pogspsdr,pogid,""))
	..//s pogno=$p(^PIVA(pogid,"S",pogschl),"^",7)
	..s pogno=$p(^PIVA(pogid),"^",16) //瓶签号 bianshuai 2015-12-07 
	..q:##class(web.DHCSTPIVAOUTCOMMON).ChkPrtNo(prtnostr,pogno)=0 //检查单号
 	..///下一个配药状态
 	..S psdr=$P(^PIVA(pogid),"^",6)
 	..S nextstr=##class(web.DHCSTPIVAOUTCOMMON).GetNextStat(psdr,phalocdr,type)
 	..S nextnumber=$P(nextstr,"^",2)
 	..Q:nextnumber'=cnumber
 	../// 明细
	..s pogsub=""
	..F  s pogsub=$O(^PIVA(pogid,"I",pogsub)) Q:pogsub=""  D
	...S dodis=$P(^PIVA(pogid,"I",pogsub),"^",1)
	...Q:dodis=""
	...Q:'$D(^DHCOEDISQTY(dodis))
    ...S dspstatus=$p(^DHCOEDISQTY(dodis),"^",7)
 	...//Q:dspstatus'="TC"	/// 已经确认发药
	...S oeori=$p(^DHCOEDISQTY(dodis),"^",1)
	...S OrdExeRowid=$p(^DHCOEDISQTY(dodis),"^",3) //判断执行记录
    ...q:##class(web.DHCSTPIVAOUTCOMMON).GetOrdState(OrdExeRowid)=0
	...S pri=##class(web.DHCSTPIVAOUTCOMMON).GetOePriority(oeori)
	...S pricode=$P(pri,"^",2)
	...S pricode=$ZCVT(pricode,"U")
	...//Q:pricode["OM"
	...S ord=$P(oeori,"||",1)
 	...S chl=$P(oeori,"||",2) 
 	...S incitm=##class(web.DHCSTPIVAOUTCOMMON).GetIncItm(oeori)
 	...S inci=$P(incitm,"^",1)
 	...S itmdesc=$P(incitm,"^",3)
 	...S qty=$P(^DHCOEDISQTY(dodis),"^",11)
 	...S stkbin=##class(web.DHCSTPIVAOUTCOMMON).GetStkBin(phalocdr,inci)
 	...s adm=$p(^OEORD(ord),"^",1)
    ...s papmidr=$p(^PAADM(adm),"^",1)
    ...S PapmiNo=$p(^PAPER(papmidr,"PAT",1),"^",2)	//add 2013-11-05
	...Q:(PapmiNo'=RegNo)&(RegNo'="")				//add 2013-11-05
    ...s orddate=$p(^DHCOEDISQTY(dodis),"^",21)
    ...s ordtime=$p(^DHCOEDISQTY(dodis),"^",20)
    ...s grpno=$p(^DHCOEDISQTY(dodis),"^",4)
    ...s seqno=$P(^OEORD(ord,"I",chl,3),"^",4)
    ...s index=papmidr_"^"_adm_"^"_orddate_"^"_ordtime_"^"_pogid_"^"_grpno_"^"_oeori_"^"_seqno
    ...s index2=dodis
    ...s ^TMP("dhcpha","DHCSTPIVAOUTOPSTOCK","FindOrdGrpDetail",pid,"index",index,index2)=""
    
    s h=0
    s index=""
    f  s index=$o(^TMP("dhcpha","DHCSTPIVAOUTOPSTOCK","FindOrdGrpDetail",pid,"index",index)) q:index=""  d
    .s adm=$p(index,"^",2)
    .s pogid=$p(index,"^",5)
    .s oeori=$p(index,"^",7)
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
	..q:(labelno'=barcode)&(labelno'="")
    ..i (qty#fac)=0 d
	...s qty=qty/fac   //数量
	...s uomdr=puomdr 
	..s uomdesc=$p($g(^CT("UOM",uomdr)),"^",2) //单位
	..s selectflag=mdodis   //1
	..s packflag=##class(web.DHCSTPIVAOUTCOMMON).GetPackFlag(mdodis) //打包状态 bianshuai
	..s omflag=##class(web.DHCSTPIVAOUTCOMMON).GetOMFlag(dodis) //自备药
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
    ..s data=data_"^"_patno_"^"_patname_"^"_dodis_"^"_pogid_"^"_packflag_"^"_omflag_"^"_barcode_"^"_prescnoT
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
    ...s omflag=$p(data,"^",23)
    ...S barcode=$p(data,"^",24)
    ...S prescnoT=$p(data,"^",25)
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
	...s omflag=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("omflag",omflag)
	...s barcode=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("barcode",barcode)
	...s pogid=##class(web.DHCSTEXTCOMMON).GetJsonLastCell("pogid",pogid)
	...
	...s tmpstr=incidesc_qty_uomdesc_dosage_freq_spec_instruc_dura_form_pri_doctor_orddate_remark_orditm_prescno_prescnoT_selectflag
	...s tmpstr=tmpstr_patno_patname_dsprowid_packflag_omflag_barcode_pogid
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

/// 完成配液减库
ClassMethod OpPIVAStock(pog, user) As %String
{
    s fydr=$o(^DHCPHPERi("USR",user,""))
    Q:fydr="" -99
    s pydr=fydr
	s currdate=+$h
    s currtime=$p($h,",",2)
	S cnumber=60
	S type="O"
	S psdr=$P(^PIVA(pog),"^",6) /// pog的当前状态
	S nownumber=$P(^PIVAS(psdr),"^",1)
	q:cnumber=nownumber -80
	S phlocdr=$P(^PIVA(pog),"^",7)
	S nextstr=##class(web.DHCSTPIVAOUTCOMMON).GetNextStat(psdr,phlocdr,type)
 	S nextnumber=$P(nextstr,"^",2)
    q:nextnumber'=cnumber -1
    S recflag=..CheckIfRec(pog)   //检查是否已接收
    q:recflag'=0 -21
	S ps=##class(web.DHCSTPIVAOUTCOMMON).GetCurrPSDrByNum(cnumber,phlocdr,type)
    s pogsub=$o(^PIVA(pog,"I",""))
    s dodis=$P(^PIVA(pog,"I",pogsub),"^",1)
    s oeori=$p(^DHCOEDISQTY(dodis),"^",1)
    s ord=$p(oeori,"||",1)
	s chl=$p(oeori,"||",2)
	s adm=$p(^OEORD(ord),"^",1)
	s papmidr=$p(^PAADM(adm),"^",1)
    s prescno=$p(^OEORD(ord,"I",chl,1),"^",14)
  
    s prt=""
    s phar=""
	f  s phar=$o(^DHCPHARi("PRESCNO",prescno,phar)) q:(phar="")||(prt'="")  d 
	.s notuse=$p(^DHCPHARW(phar),"^",7)
	.q:notuse=1
	.s prt=$p(^DHCPHARW(phar),"^",1)
	i prt'="" s prt=..GetNewPrtFrOld(prt)   //查到处方对应的最新的发票
	s prt=+prt
	s phalocdr=$p(^OEORD(ord,"I",chl,3),"^",6)
	s phl=$o(^DHCPHLOCi("LOC",phalocdr,"")) q:phl="" -11
	s phw=""
	s pyflag="1",prtflag="1",fyflag="1"
	
	
	l +^DHCOutPhDisp(phl,prescno):10  e  q -12
	
	tstart
	
	//处理 PIVA_OrdGrp系列表
	S ret=..UpdPog(pog,ps,user)	//1 处理 PIVA_OrdGrp系列表
 	I ret'=0 TRo
 	i ret'=0 d unlock
	i ret'=0 q -14

	///处理门诊发药系列表
    s m=0,err=0,phdrow=""
	s pogsub=""
	F  s pogsub=$O(^PIVA(pog,"I",pogsub)) Q:(pogsub="")||(err'=0)  D
	.S dodis=$P(^PIVA(pog,"I",pogsub),"^",1)
	.Q:dodis=""
	.Q:'$D(^DHCOEDISQTY(dodis))
	.S oeori=$p(^DHCOEDISQTY(dodis),"^",1)
	.s ord=$p(oeori,"||",1)
	.s itm=$p(oeori,"||",2)
	.S pri=##class(web.DHCSTPIVAOUTCOMMON).GetOePriority(oeori)
	.S pricode=$P(pri,"^",2)
	.S pricode=$ZCVT(pricode,"U")
	.Q:pricode["OM"
	.S dspstatus=$p(^DHCOEDISQTY(dodis),"^",7)
 	.Q:dspstatus'="TC"	/// 已经确认发药
 	.//S OrdExeRowid=$p(^DHCOEDISQTY(dodis),"^",3) //判断执行记录
    .//q:##class(web.DHCSTCOMMONSRV).GetOrdState(OrdExeRowid)=0
 	.///生成发药主表
 	.i phdrow="" d
 	..&sql(insert into SQLUSER.dhc_phdispen(phd_prtdate,phd_prt_dr,phd_papmi_dr,phd_php_pydr,phd_phl_dr,phd_phw_dr,phd_pydate,phd_pytime,phd_prescno,PHD_PYFLAG,PHD_PRINTFLAG,PHD_FYDATE,PHD_FYTIME,PHD_FYFLAG,PHD_PHP_FYDR) values(:currdate,:prt,:papmidr,:pydr,:phl,:phw,:currdate,:currtime,:prescno,:pyflag,:prtflag,:currdate,:currtime,:fyflag,:fydr))
	..i SQLCODE'=0 s err=SQLCODE
	..i SQLCODE=0 s phdrow=+$g(%ROWID)
	.q:err'=0
	.s qty=$P(^DHCOEDISQTY(dodis),"^",11)
	.s itmmast=$p(^OEORD(ord,"I",itm,1),"^",2)
	.s inci=$o(^INCI(0,"ARCIM_DR",$p(itmmast,"||",1),""))
	.s nouseitm=""
	.i prt=0 d
	..//s HospString=##class(web.DHCSTCOMMONSRV).GetLocHosp(phalocdr)
    ..//s hospdr=$p(HospString,"^",1)
	..//s spice=##class(web.DHCSTCOMMONSRV).GetPriceElse(+inci,+$h,"",hospdr)
	..s CustStr=##Class(web.DHCSTCOMMO).GetLocCust(phalocdr)
    ..s HospID=$p(CustStr,"^",5)
    ..s CustID=$p(CustStr,"^",1)
	..s CatGrpStr=##Class(web.DHCSTCOMINC).GetIncStkCatGrp(+inci)
    ..s StkTypeDesc=$P(CatGrpStr,"^",4)
    ..s Perv="^^^"_StkTypeDesc_"^"_CustID_"^DHC"
    ..s exStr=oeori_"^"_dodis
    ..s spice=##class(web.DHCSTPRICE).GetSp(+inci,+$h,"",HospID,"",exStr)
    ..//s spice=##class(web.DHCSTPRICE).GetCurSp(+inci,"",HospID)
	..s money=spice*qty
    ..s money=##Class(web.DHCSTCOMMPARA).GetNumbDec(money,Perv,"FmtSA",1)
	..//s spice=##Class(web.DHCSTCOMMPARA).GetNumbDec(spice,Perv,"FmtSA",1)
	.e  d
    ..s ordpriceinfo=##class(web.DHCOutPhCommon).GetBasPriceByInv(prt,oeori)
	..s spice=+$p(ordpriceinfo,"^",1)
	..s money=+$p(ordpriceinfo,"^",2)
	.s:money=0 nouseitm=0
	.q:nouseitm=0
	.s m=m+1
	.///生成发药子表
	.&sql(insert into SQLUSER.DHC_PHDISITEM(phdi_phd_parref,phdi_childsub,phdi_qty,phdi_payamount,phdi_oeori_dr,PHDI_PRICE) 
	             values(:phdrow,:m,:qty,:money,:oeori,:spice))
	             
	.i SQLCODE'=0 s err=2
	.q:err'=0
	.s phditm=$g(%ROWID)
	.///更新打包表
	.&sql(update sqluser.dhc_oedispensing set dsp_pointer=:phditm,dsp_type='F',dsp_status='C',dsp_date=:currdate,dsp_time=:currtime where DSP_RowId=:dodis )
	.i SQLCODE'=0 s err=3
	.q:err'=0
	.///处理批次表
	.s err=..Dispensing(phditm,dodis,user)
	.q:err'=0
    i err'=0 tro
    i err'=0 d unlock
    q:err'=0 err
    
    tcommit 
    d unlock
    q 0
	
unlock
   L -^DHCOutPhDisp(phl,prescno)
}

/// 预操作生成门诊发药批次表
ClassMethod Dispensing(phditm, dodis, user) As %String
{
	s oeori=$p(^DHCOEDISQTY(dodis),"^",1)
	s ord=$p(oeori,"||",1)
	s chl=$p(oeori,"||",2)
	s phalocdr=$p(^OEORD(ord,"I",chl,3),"^",6)
	q:phalocdr="" -62
	s arcimid=$p(^OEORD(ord,"I",chl,1),"^",2)  
	s itmmastid=$p(arcimid,"||",1)
	s itmmastver=$p(arcimid,"||",2)
	s inci=$o(^INCI(0,"ARCIM_DR",$p(arcimid,"||",1),""))
	q:inci="" -63
	s ilSub=$o(^INCI("IL_LOC",phalocdr,inci,""))
	q:ilSub="" -64
	s incil=inci_"||"_ilSub
	s HospID=""
 	i phalocdr'="" d
 	.s HospID=$p($g(^CTLOC(phalocdr)),"^",22)
	s RuleFlag=##Class(web.DHCSTCOMMPARA).GetRpRule(HospID)	//进价规则
	l +^DHCINCIL(phalocdr,inci):5  e  q -62   ;加锁
    s pid=##CLASS(web.DHCSTKUTIL).GetInclbCounter()
    s qty=$P(^DHCOEDISQTY(dodis),"^",11)
    s stkqty=0
    i RuleFlag=3 d
    .s dspFlag=##class(web.DHCST01).GetDspClb(dodis,pid)
    .i dspFlag'=1 d
    ..s stkqty=##CLASS(web.DHCST01).GetInclbQty(incil,qty,pid,1)
    .s minusret=##class(web.DHCST01).MinusResQtyByDspBatch(dodis) //yunhaibao20160307,批次价处理在途数,因涉及重新分批次,故先处理原始打包批次表在途数
    e  d
    .s stkqty=##CLASS(web.DHCSTSTKQTY).GetInclbQty(inci,qty,phalocdr,pid)
    i stkqty'=1 d exit
    q:stkqty'=1 -60
    s ret=0
    i RuleFlag=3 d
    .s ret=##Class(web.DHCOutPhDisp).InsertPhdisItmClbByBatch(phditm,pid)
    e  d
    .s ret=..InsertPhdItmClb(phditm,pid)
    i ret'=0 d exit
    q:ret'=0 -61
    ///处理库存表
	s intrtype="F"
    s phdrow=$p(phditm,"||",1)
    s phdsub=$p(phditm,"||",2)
    s phdicsub="0"
    f  s phdicsub=$o(^DHCPHDI(phdrow,"PHDI",phdsub,"INCLB",phdicsub)) q:(phdicsub="")!(phdicsub="0")!(ret'=0)  d
    .s inclb=$p(^DHCPHDI(phdrow,"PHDI",phdsub,"INCLB",phdicsub),"^",3)
    .s incqty=+$p(^DHCPHDI(phdrow,"PHDI",phdsub,"INCLB",phdicsub),"^",1)
    .s inc=$p(inclb,"||",1)
    .s basuom=$p(^INCI(inc,1),"^",10)
    .s pointer=phdrow_"||"_phdsub_"||"_phdicsub
    .s ret=##Class(web.DHCOutPhDisp).DhcOutStkTab(pointer,intrtype)  ;处理该笔发药记录的台帐库存
    .q:ret'=0
    d exit
    q 0
exit
   k ^TMP("DHCST","web.DHCST01","Inclb",pid)
   l -^DHCINCIL(phalocdr,inci)
}

/// Creater: 	zhouyg
/// CreateDate: 	2014-01-27
/// Descript:	判断开医嘱保存的批次库存是否够用
/// Return:		1-够用，0-不够用，需要重新取批次
ClassMethod GetDspClb(DspID As %String, pid As %String) As %String
{
 //n (OeoriID,pid)
 q:DspID="" 0
 s retFlag=1
 s DspSub=0
 f  s DspSub=$o(^DHCOEDISQTY(DspID,"I",DspSub)) q:(DspSub="")!(retFlag'=1)  d
 .s inclb=$p(^DHCOEDISQTY(DspID,"I",DspSub),"^",1)
 .s Dspqty=$p(^DHCOEDISQTY(DspID,"I",DspSub),"^",2)
 .s Curqty=##Class(web.DHCSTSTKQTY).CurQtyINCLB(inclb)
 .i Curqty<Dspqty s retFlag=0
 .q:Curqty<Dspqty
 .s rp=$p(^DHCOEDISQTY(DspID,"I",DspSub),"^",3)
 .s sp=$p(^DHCOEDISQTY(DspID,"I",DspSub),"^",4)
 .s ^TMP("DHCST","OEINCLB",pid,"Inclb",inclb)=Dspqty_"^"_sp_"^"_rp
 i retFlag'=1 k ^TMP("DHCST","OEINCLB",pid,"Inclb")
 q 1
}

/// 生成门诊发药批次表
ClassMethod InsertPhdItmClb(phditm As %Library.String = "", pid)
{
      s newclb="",bb=0,itmclbnum=0
      s phdID=$p(phditm,"||",1)
      q:phdID="" -1
      s phdSub=$p(phditm,"||",2)
      q:phdSub="" -4
      s phlocID=$p(^DHCPHDISP(phdID,1),"^",1)
      q:phlocID="" -2
      s locID=$p(^DHCPHLOC(phlocID),"^",1)
      q:locID="" -3
      s CustStr=##Class(web.DHCSTCOMMO).GetLocCust(locID)
      s HospID=$p(CustStr,"^",5)
	  f  s newclb=$o(^TMPGETINCLB(pid,newclb)) q:(newclb="")!(itmclbnum'=0)  d
	  .s baseqty=0,bb=bb+1
	  .s baseqty=$p(^TMPGETINCLB(pid,newclb),"^",1)
	  .
	  .s inci=+newclb
	  .s buom=$p(^INCI(inci,1),"^",10)
	  .s sp=$p(^DHCPHDI(phdID,"PHDI",phdSub),"^",11)
	  .s rp=+##Class(web.DHCSTPRICE).GetCurRp(newclb,buom,HospID)
	  .s rpamt=rp*baseqty
	  .s spamt=sp*baseqty
	  .&sql(insert into SQLUSER.dhc_phdisitmclb(phdic_phdi_parref,phdic_childsub,phdic_basqty,phdic_inclb_dr,PHDIC_Rp,PHDIC_RpAmt,PHDIC_Sp,PHDIC_SpAmt)
	       values(:phditm,:bb,:baseqty,:newclb,:rp,:rpamt,:sp,:spamt))
	  .i SQLCODE'=0  d
	  ..s itmclbnum=itmclbnum+1
	 
	  i itmclbnum'=0 q -1
	  i bb=0 q -2
	  q 0
}

/// 取最新发票ID
ClassMethod GetNewPrtFrOld(prt)
{
	
	s nprt="0",gnprt=""
	s lprt="",lprt=prt
	f  s nprt=$o(^DHCINVPRT(0,"OldINV",lprt,nprt)) q:(nprt="")!(nprt="0")  d
	  .s lprt=nprt                                                                                                        
	  .s gnprt=nprt
    i (gnprt="")!(gnprt="0") s gnprt=prt
    quit gnprt
}

/// 处理库存,统一的方法
ClassMethod DhcOutStkTab(pointer As %String, intrtype As %String) As %String
{
	;Insert into DHC_Intrans accroding to rowid 
	s phdrow=$p(pointer,"||",1)
	s phdsub=$p(pointer,"||",2) 
	s phdicsub=$p(pointer,"||",3)
	q:'$d(^DHCPHDI(phdrow,"PHDI",phdsub,"INCLB",phdicsub)) -22
	s inclb=$p(^DHCPHDI(phdrow,"PHDI",phdsub,"INCLB",phdicsub),"^",3)
    s incqty=+$p(^DHCPHDI(phdrow,"PHDI",phdsub,"INCLB",phdicsub),"^",1)
    s inc=$p(inclb,"||",1)
    s ItmCode=$p(^INCI(inc,1),"^",1)
    s basuom=$p(^INCI(inc,1),"^",10)
    s UomDesc=$p( ^CT("UOM",basuom),"^",2 )
    s pointer=phdrow_"||"_phdsub_"||"_phdicsub  
	s phper=+$p(^DHCPHDISP(phdrow,1),"^",2)  
	s user=+$p(^DHCPHPER(phper),"^",5)
	s phl=+$p(^DHCPHDISP(phdrow,1),"^",1)
	s locdr=+$p(^DHCPHLOC(phl),"^",1) 
	s LocDesc=$p(^CTLOC(locdr),"^",2)
	s qty=-incqty 			
	s pmoney=$p(^DHCPHDI(phdrow,"PHDI",phdsub),"^",3) 
	s Price= $p(^DHCPHDI(phdrow,"PHDI",phdsub),"^",11)
	s Data=intrtype_"^"_""_"^"_inclb_"^"_qty_"^"_UomDesc_"^"_ItmCode_"^"_Price_"^"_user_"^"_pointer_"^"_LocDesc
	s Err=##class(web.DHCST01).UPDINCI(Data)
    q:Err=0 -23
	q 0
}

ClassMethod UpdPog(pog As %String, ps As %String, puser As %String) As %String
{

	K PLIST
	&SQL(Select * Into :PLIST() From PIVA_OrdGrp Where pog_rowid=:pog)
	S PLIST(7)=ps
	&SQL(Update PIVA_OrdGrp Values :PLIST() Where pog_rowid=:pog)
	Q:SQLCODE -1
	S ret=..InsOrdGrpState(pog,puser,ps)
	Q ret
}

ClassMethod InsOrdGrpState(parref As %String, user As %String, ps As %String) As %String
{

	Q:parref="" -1
	Q:user="" -2
	Q:ps="" -3

	K PLIST
	S PLIST(0)=parref
	S PLIST(2)=$O(^PIVA(parref,"S",""),-1)+1
	S PLIST(3)=ps
	S PLIST(4)=user
	S PLIST(5)=+$H
	S PLIST(6)=$P($H,",",2)
	&SQL(Insert Into PIVA_OrdGrpState Values :PLIST())
	Q SQLCODE
}

/// 判断整组药品是否接收
ClassMethod CheckIfRec(pog) As %String
{
	Q:pog="" ""
	S ret=0
	S pogsub=""
	F  S pogsub=$O(^PIVA(pog,"I",pogsub)) Q:(pogsub="")||(ret'=0)  D
	.S dodis=$P(^PIVA(pog,"I",pogsub),"^",1)
	.Q:dodis=""
	.Q:'$D(^DHCOEDISQTY(dodis))
	.S pdis=$O(^PIVADIS(0,"DODIS",dodis,""))
	.Q:pdis=""
	.S Status=$p(^PIVADIS(pdis),"^",7)
	.Q:Status="REC"
	.S ret=1
	Q ret
}

}
