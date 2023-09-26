Import SQLUser

/// 配液踪合查询
Class web.DHCSTPIVAOUTQUERY Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// 踪合查询	
/// Creator:LiangQiang
/// CreatDate:2013-05-31
/// Input:登记号,开始行,限制行,参数串
/// Output:明细
ClassMethod FindOrdGrpDetail(RegNo, StPage, Limit, Input) As %String
{
	S cnumber=10  /// 10固定为打签状态
	s pid=##class(web.DHCSTPIVAOUTCOMMON).GetPIVAOUTPID()
	s stdate=$p(Input,"^",1)
	s stdate=$zdh(stdate,4)
	s enddate=$p(Input,"^",2)
	s enddate=$zdh(enddate,4)
    s phalocdr=$p(Input,"^",3)
    s patID=$p(Input,"^",4)
    s prtnostr=$p(Input,"^",5)
    s labelno=$p(Input,"^",6)
    s type="O"
    
    s endpage=StPage+Limit  //结束行
	s stpage=StPage+1 //开始行
	s pogspsdr=##class(web.DHCSTPIVAOUTCOMMON).GetCurrPSDrByNum(cnumber,phalocdr,type)

	f date=stdate:1:enddate  d
	.s pogspsdr=""
	.f  s pogspsdr=$o(^PIVA(0,"LOCSTATE",phalocdr,date,pogspsdr)) q:pogspsdr=""  d
	..s pogid=""
	..f  s pogid=$o(^PIVA(0,"LOCSTATE",phalocdr,date,pogspsdr,pogid)) q:pogid=""  d
	...s barcode=$p(^PIVA(pogid),"^",17)
	...//q:(barcode'=labelno)&(labelno'="")  //检查瓶签号
	...// s pogschl=$o(^PIVA(0,"PS",pogspsdr,pogid,""))
	...//s pogno=$p(^PIVA(pogid,"S",pogschl),"^",7)
	...s pogno=$p(^PIVA(pogid),"^",16) //默认取第一条记录的瓶签号 bianshuai 2015-12-07 
	...q:##class(web.DHCSTPIVAOUTCOMMON).ChkPrtNo(prtnostr,pogno)=0 //检查单号
 	...///下一个配药状态
 	...S psdr=$P(^PIVA(pogid),"^",6)
 	...S nextstr=##class(web.DHCSTPIVAOUTCOMMON).GetNextStat(psdr,phalocdr,type)
 	...S nextnumber=$P(nextstr,"^",2)
 	.../// 明细
	...s pogsub=""
	...F  s pogsub=$O(^PIVA(pogid,"I",pogsub)) Q:pogsub=""  D
	....S dodis=$P(^PIVA(pogid,"I",pogsub),"^",1)
	....Q:dodis=""
	....Q:'$D(^DHCOEDISQTY(dodis))
	....S oeori=$p(^DHCOEDISQTY(dodis),"^",1)
	....S pri=##class(web.DHCSTPIVAOUTCOMMON).GetOePriority(oeori)
	....S pricode=$P(pri,"^",2)
	....S pricode=$ZCVT(pricode,"U")
	....//Q:pricode["OM"
	....S ord=$P(oeori,"||",1)
 	....S chl=$P(oeori,"||",2) 
 	....S incitm=##class(web.DHCSTPIVAOUTCOMMON).GetIncItm(oeori)
 	....S inci=$P(incitm,"^",1)
 	....S itmdesc=$P(incitm,"^",3)
 	....S qty=$P(^DHCOEDISQTY(dodis),"^",11)
 	....S stkbin=##class(web.DHCSTPIVAOUTCOMMON).GetStkBin(phalocdr,inci)
 	....s adm=$p(^OEORD(ord),"^",1)
    ....s papmidr=$p(^PAADM(adm),"^",1)
    ....s paadmtype=$p(^PAADM(adm),"^",2)
    ....Q:(paadmtype'="E")&(paadmtype'="O")		//非门诊病人退出
    ....s orddate=$p(^DHCOEDISQTY(dodis),"^",21)
    ....s ordtime=$p(^DHCOEDISQTY(dodis),"^",20)
    ....s grpno=$p(^DHCOEDISQTY(dodis),"^",4)
    ....s seqno=$P(^OEORD(ord,"I",chl,3),"^",4) //
    ....s prescno=$p(^OEORD(ord,"I",chl,1),"^",14)
    ....s index=papmidr_"^"_adm_"^"_orddate_"^"_ordtime_"^"_grpno_"^"_pogid_"^"_oeori_"^"_seqno //seqno要在最后否则主医嘱不在第一条,oeori参与排序可能错乱
    ....s index2=dodis
    ....s ^TMP("dhcpha","DHCSTPIVAOUTQUERY","FindOrdGrpDetail",pid,"index",index,index2)=pogid
    s h=0
    s index=""
    f  s index=$o(^TMP("dhcpha","DHCSTPIVAOUTQUERY","FindOrdGrpDetail",pid,"index",index)) q:index=""  d
    .s adm=$p(index,"^",2)
    .s oeori=$p(index,"^",7)
   	.s ord=$p(oeori,"||",1)
	.s chl=$p(oeori,"||",2)
	.s prescno=$p(^OEORD(ord,"I",chl,1),"^",14)
    .s papmi=+$p(^PAADM(adm),"^",1)
    .s patno=$p(^PAPER(papmi,"PAT",1),"^",2)
    .q:(patno'=patID)&(patID'="")
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
    .f  s index2=$o(^TMP("dhcpha","DHCSTPIVAOUTQUERY","FindOrdGrpDetail",pid,"index",index,index2)) q:index2=""  d
    ..s pogid=^TMP("dhcpha","DHCSTPIVAOUTQUERY","FindOrdGrpDetail",pid,"index",index,index2)
    ..s dodis=$p(index2,"^",1)
    ..s qty=$P(^DHCOEDISQTY(dodis),"^",11)
    ..s orddate=$p(^DHCOEDISQTY(dodis),"^",21)
    ..i orddate="" s orddate=$p(^DHCOEDISQTY(dodis),"^",15)
    ..i orddate'="" s orddate=$zd(orddate,3)
    ..s ordtime=$p(^DHCOEDISQTY(dodis),"^",22)
    ..i ordtime="" s ordtime=$p(^DHCOEDISQTY(dodis),"^",16)
    ..i ordtime'="" s ordtime=$zt(ordtime,1)
    ..s orddatetime=orddate  //_" "_ordtime  ;开单日期
    ..S grpno=$p(^DHCOEDISQTY(dodis),"^",4)
    ..S mdodis=##class(web.DHCSTPIVA).GetMainOEDispID(dodis,grpno)
    ..S psname=##class(web.DHCSTPIVAOUTCOMMON).GetCurStat(mdodis)
	..S OrdExecRowid=$p(^DHCOEDISQTY(mdodis),"^",3)
	..S barcode=$REPLACE(OrdExecRowid,"||","-")
	..q:(barcode'=labelno)&(labelno'="")
    ..
    ..i (qty#fac)=0 d
	...s qty=qty/fac   //数量
	...s uomdr=puomdr 
	..s uomdesc=$p($g(^CT("UOM",uomdr)),"^",2) //单位
	..s selectflag=mdodis    //1
	..s h=h+1
	..s tmpindex=prescno_"||"_mdodis
    ..i $D(^TMP("dhcpha","DHCSTPIVAOUTQUERY","FindOrdGrpDetail","PrescNo",pid,tmpindex)) d
    ...s orddatetime=""
    ...s prescno=""
    ...s patno="",patname=""
    ..e  d
    ...s ^TMP("dhcpha","DHCSTPIVAOUTQUERY","FindOrdGrpDetail","PrescNo",pid,tmpindex)=""
	..s data=inciDesc_"^"_qty_"^"_uomdesc_"^"_dosage_doseuom_"^"_freq_"^"_spec_"^"_instru_"^"_duration_"^"_form
    ..s data=data_"^"_priorty_"^"_doctor_"^"_orddatetime_"^"_remark_"^"_"^"_oeori_"^"_prescno_"^"_selectflag
    ..s data=data_"^"_patno_"^"_patname_"^"_dodis_"^"_pogid_"^"_psname_"^"_barcode
    ..s ^TMP("dhcpha","DHCSTPIVAOUTQUERY","FindOrdGrpDetail",pid,"Itm",h)=data
	
	q:h=0 ##class(web.DHCSTEXTCOMMON).GetNoJson()
    s maxrow=h
    i endpage>maxrow s endpage=maxrow
    s count=0
    s h=""
    f  s h=$o(^TMP("dhcpha","DHCSTPIVAOUTQUERY","FindOrdGrpDetail",pid,"Itm",h)) q:h=""  d
    .s data=^TMP("dhcpha","DHCSTPIVAOUTQUERY","FindOrdGrpDetail",pid,"Itm",h)
    .s incidesc=$p(data,"^",1)
    .s qty=$p(data,"^",2)
    .s uomdesc=$p(data,"^",3)
    .s dosage=$p(data,"^",4)
    .s freq=$p(data,"^",5)
    .s spec=$p(data,"^",6)
    .s instruc=$p(data,"^",7)
    .s dura=$p(data,"^",8)
    .s form=$p(data,"^",9)
    .s pri=$p(data,"^",10)
    .s doctor=$p(data,"^",11)
    .s orddate=$p(data,"^",12)
    .s remark=$p(data,"^",13)
    .s manf=$p(data,"^",14)
    .s orditm=$p(data,"^",15)
    .s prescno=$p(data,"^",16)
    .s selectflag=$p(data,"^",17)
    .s patno=$p(data,"^",18)
    .s patname=$p(data,"^",19)
    .s dsprowid=$p(data,"^",20)
    .s pogid=$p(data,"^",21)
    .s psname=$p(data,"^",22)
    .s barcode=$p(data,"^",23)
    .s count=count+1
    .q:count<stpage
    .q:count>endpage
    .
    .s incidesc=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("incidesc",incidesc)
	.s qty=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("qty",qty)
	.s uomdesc=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("uomdesc",uomdesc)
	.s dosage=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("dosage",dosage)
	.s freq=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("freq",freq)
	.s spec=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("spec",spec)
	.s instruc=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("instruc",instruc)
	.s dura=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("dura",dura)
	.s form=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("form",form)
	.s pri=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("pri",pri)
	.s doctor=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("doctor",doctor)
	.s orddate=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("orddate",orddate)
	.s remark=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("remark",remark)
	.s orditm=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("orditm",orditm)
	.s prescno=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("prescno",prescno)
	.s selectflag=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("selectflag",selectflag)
	.s patno=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("patid",patno)
	.s patname=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("patname",patname)
	.s dsprowid=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("dsprowid",dsprowid)
	.s psname=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("psname",psname)
	.s barcode=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("barcode",barcode)
	.s pogid=##class(web.DHCSTEXTCOMMON).GetJsonLastCell("pogid",pogid)
	.
	.s tmpstr=incidesc_qty_uomdesc_dosage_freq_spec_instruc_dura_form_pri_doctor_orddate_remark_orditm_prescno_selectflag
	.s tmpstr=tmpstr_patno_patname_dsprowid_psname_barcode_pogid
	.
    .s startString=##class(web.DHCSTEXTCOMMON).GetJsonStartString(maxrow)
    .s firstrow=##class(web.DHCSTEXTCOMMON).GetJsonFirstRow(tmpstr)
    .s lastrow=##class(web.DHCSTEXTCOMMON).GetJsonLastRow(tmpstr)
	.
    .
    .i count=stpage w startString
    .i count<endpage w firstrow
    .i count=endpage w lastrow
    
    
    k ^TMP("dhcpha","DHCSTPIVAOUTQUERY","FindOrdGrpDetail",pid)
    q ""
}

/// 获取安全组关联科室
ClassMethod QueryPogStatusDs(Pog, Dsp = "") As %String
{
	s h=0
	s pid=##class(web.DHCSTPIVAOUTCOMMON).GetPIVAOUTPID()
	i Dsp'="" d
	.s grpno=$p(^DHCOEDISQTY(Dsp),"^",4) //1->4   Modified By BianShuai
	.s Pog=$o(^PIVA(0,"OEGRP",Dsp,grpno,""))
	i Pog'="" s Dsp=$p(^PIVA(Pog),"^",1)
	s reqdata=##class(web.DHCSTPIVAOUTCOMMON).GetReqUserInfo(Dsp)
    s h=h+1
    s psName="护士申请"
    s psUser=$p(reqdata,"^",1)
    s psDate=$p(reqdata,"^",2)_" "_$p(reqdata,"^",3)
    s data=psName_"^"_psUser_"^"_psDate
    s ^TMP("dhcpha","DHCSTPIVAOUTQUERY","QueryPogStatusDs",pid,h)=data
    s oeori=$p(^DHCOEDISQTY(Dsp),"^",1)
	s adtdata=##class(web.DHCSTPIVAOUTCOMMON).GetAdtResultInfo(oeori)
    s psUser=$p(adtdata,"^",1)
    i psUser'="" d
    .s h=h+1
    .s psDate=$p(adtdata,"^",2)_" "_$p(adtdata,"^",3)
    .s psName=$p(adtdata,"^",4)
    .s data=psName_"^"_psUser_"^"_psDate
    .s ^TMP("dhcpha","DHCSTPIVAOUTQUERY","QueryPogStatusDs",pid,h)=data
    
    i Pog'="" d
	.S PogsSub="0"
 	.F  S PogsSub=$O(^PIVA(Pog,"S",PogsSub)) Q:(PogsSub="")||(PogsSub="0")  D
 	..S psID=$P(^PIVA(Pog,"S",PogsSub),"^",2)
 	..S (psName,psNumber)=""
 	..I psID'="" D
 	...S psName=$P($G(^PIVAS(psID)),"^",2)
 	...S psNumber=$P($G(^PIVAS(psID)),"^",1)
 	..S psUser=$P(^PIVA(Pog,"S",PogsSub),"^",3)
 	..I psUser'="" S psUser=$P($G(^SSU("SSUSR",psUser)),"^",2)
 	..S psDate=$P(^PIVA(Pog,"S",PogsSub),"^",4)
 	..I psDate'="" S psDate=$ZD(psDate,3)
 	..S psTime=$P(^PIVA(Pog,"S",PogsSub),"^",5)
 	..I psTime'="" S psTime=$ZT(psTime,1)
 	..s psDate=psDate_" "_psTime
	..s h=h+1
    ..s data=psName_"^"_psUser_"^"_psDate
    ..s ^TMP("dhcpha","DHCSTPIVAOUTQUERY","QueryPogStatusDs",pid,h)=data
    
    q:h=0 ##class(web.DHCSTEXTCOMMON).GetNoJson()
    s maxrow=h
    
    s count=0
    s h=""
    f  s h=$o(^TMP("dhcpha","DHCSTPIVAOUTQUERY","QueryPogStatusDs",pid,h)) q:h=""  d
    .s data=^TMP("dhcpha","DHCSTPIVAOUTQUERY","QueryPogStatusDs",pid,h)
    .s psName=$p(data,"^",1)
    .s psUser=$p(data,"^",2)
    .s psDate=$p(data,"^",3)
    .
    .s psName=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("psName",psName)
    .s psUser=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("psUser",psUser)
	.s psDate=##class(web.DHCSTEXTCOMMON).GetJsonLastCell("psDate",psDate)
	.
	.s tmpstr=psName_psUser_psDate
    .s startString=##class(web.DHCSTEXTCOMMON).GetJsonStartString(maxrow)
    .s firstrow=##class(web.DHCSTEXTCOMMON).GetJsonFirstRow(tmpstr)
    .s lastrow=##class(web.DHCSTEXTCOMMON).GetJsonLastRow(tmpstr)
	.s count=count+1
	.i count=1 w startString
    .i count<maxrow w firstrow
    .i count=maxrow w lastrow
	.
	k ^TMP("dhcpha","DHCSTPIVAOUTQUERY","QueryPogStatusDs",pid)
	q ""
}

}
