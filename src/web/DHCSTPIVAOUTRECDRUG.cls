Import sqluser

/// 门诊输液接收自备药
Class web.DHCSTPIVAOUTRECDRUG Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// 查询配液申请明细	
/// Creator:LiangQiang
/// CreatDate:2013-05-27
/// Input:登记号,开始行,限制行,参数串
/// Output:明细
/// w ##class(web.DHCSTPIVAOUTRECDRUG).FindReqDetailData(0000000001,0,30,"1/11/2015^17/11/2015^101^0000000001^true^")
ClassMethod FindReqDetailData(RegNo, StPage, Limit, Input) As %String
{
	s pid=##class(web.DHCSTPIVAOUTCOMMON).GetPIVAOUTPID()
	s stdate=$p(Input,"^",1)
	s stdate=$zdh(stdate,4)
	s enddate=$p(Input,"^",2)
	s enddate=$zdh(enddate,4)
    s phalocdr=$p(Input,"^",3)
    s patID=$p(Input,"^",4)
    s onlyrec=$p(Input,"^",5)
    s emlocdr=$p(Input,"^",6) //急诊留观室
    
    s endpage=StPage+Limit  //结束行
	s stpage=StPage+1 //开始行
	s h=0
	f date=stdate:1:enddate  d
	.s pdis=""
	.f  s pdis=$o(^PIVADIS(0,"Date",phalocdr,date,pdis)) q:pdis=""  d
	..d getdata
		  
	s index=""
    f  s index=$o(^TMP("dhcpha","DHCSTPIVAOUTRECDRUG",pid,"index",index)) q:index=""  d
    .s adm=$p(index,"^",2)
    .s oeori=$p(index,"^",5)
    .s prescno=$p(index,"^",4)
   	.s ord=$p(oeori,"||",1)
	.s chl=$p(oeori,"||",2)
	.q:'$d(^OEORD(ord,"I",chl))
    .s priordr=$p(^OEORD(ord,"I",chl,1),"^",8) 
    .q:priordr="" 
    .s priority=$p(^OECPR(priordr),"^",1) 			;医嘱优先级代码              
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
	.s pdisstring=""
	.s qty=0
	.s index2=""
    .f  s index2=$o(^TMP("dhcpha","DHCSTPIVAOUTRECDRUG",pid,"index",index,index2)) q:index2=""  d
    ..s pdis=$p(index2,"^",1)
    ..s status=$p(^PIVADIS(pdis),"^",7)
    ..i status="REC" s status="已收"
    ..i status="REF" s status="拒收"
    ..s dodis=$p(^PIVADIS(pdis),"^",2)
    ..s orddate=$p(^DHCOEDISQTY(dodis),"^",21)
    ..i orddate="" s orddate=$p(^DHCOEDISQTY(dodis),"^",15)
    ..i orddate'="" s orddate=$zd(orddate,3)
    ..s ordtime=$p(^DHCOEDISQTY(dodis),"^",20)
    ..i ordtime="" s ordtime=$p(^DHCOEDISQTY(dodis),"^",16)
    ..i ordtime'="" s ordtime=$zt(ordtime,1)
    ..s orddatetime=orddate_" "_ordtime  ;开单日期
    ..s qty=qty+$P(^DHCOEDISQTY(dodis),"^",11)
    ..i pdisstring'="" d
    ...s pdisstring=pdisstring_","_pdis
    ..e  d
    ...s pdisstring=pdis
    ..s reqrecinfo=##class(web.DHCSTPIVAOUTCOMMON).GetReqRecInfo(dodis)
    ..s recuser=$p(reqrecinfo,"^",1)
    ..s recdate=$p(reqrecinfo,"^",2)_" "_$p(reqrecinfo,"^",3)  //接收时间
    ..S grpno=$p(^DHCOEDISQTY(dodis),"^",4)
    ..S mdodis=##class(web.DHCSTPIVA).GetMainOEDispID(dodis,grpno)
    ..
    .i (qty#fac)=0 d
	..s qty=qty/fac   //数量
	..s uomdr=puomdr 
	.s uomdesc=$p($g(^CT("UOM",uomdr)),"^",2) //单位
	.s h=h+1
	.s tmpindex=prescno_"^"_mdodis
	.s selectflag=mdodis   //prescno
	.i $D(^TMP("dhcpha","DHCSTPIVAOUTRECDRUG","FindReqDetailData",pid,"PrescNo",tmpindex)) d
    ..s orddatetime=""
    ..s prescno=""
    .e  d
    ..s ^TMP("dhcpha","DHCSTPIVAOUTRECDRUG","FindReqDetailData",pid,"PrescNo",tmpindex)=""
	.s data=inciDesc_"^"_qty_"^"_uomdesc_"^"_dosage_doseuom_"^"_freq_"^"_spec_"^"_instru_"^"_duration_"^"_form
    .s data=data_"^"_priorty_"^"_doctor_"^"_orddatetime_"^"_remark_"^"_"^"_oeori_"^"_prescno_"^"_selectflag_"^"_pdisstring
    .s data=data_"^"_recuser_"^"_recdate_"^"_status
    .s ^TMP("dhcpha","DHCSTPIVAOUTRECDRUG","FindReqDetailData",pid,"Itm",h)=data
	
	q:h=0 ##class(web.DHCSTEXTCOMMON).GetNoJson()
    s maxrow=h
    i endpage>maxrow s endpage=maxrow
    s count=0
    s h=""
    f  s h=$o(^TMP("dhcpha","DHCSTPIVAOUTRECDRUG","FindReqDetailData",pid,"Itm",h)) q:h=""  d
    .s data=^TMP("dhcpha","DHCSTPIVAOUTRECDRUG","FindReqDetailData",pid,"Itm",h)
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
    .s pdisstring=$p(data,"^",18)
    .s recuser=$p(data,"^",19)
    .s recdate=$p(data,"^",20)
    .s status=$p(data,"^",21)
    .
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
	.s pdisstring=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("pdisstring",pdisstring)
	.s recuser=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("recuser",recuser)
	.s recdate=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("recdate",recdate)
	.s recstatus=##class(web.DHCSTEXTCOMMON).GetJsonLastCell("recstatus",status)
	.
	.s tmpstr=incidesc_qty_uomdesc_dosage_freq_spec_instruc_dura_form_pri_doctor_orddate_remark_orditm_prescno_selectflag_pdisstring
	.s tmpstr=tmpstr_recuser_recdate_recstatus
	.
    .s startString=##class(web.DHCSTEXTCOMMON).GetJsonStartString(maxrow)
    .s firstrow=##class(web.DHCSTEXTCOMMON).GetJsonFirstRow(tmpstr)
    .s lastrow=##class(web.DHCSTEXTCOMMON).GetJsonLastRow(tmpstr)
	.
    .
    .i count=stpage w startString
    .i count<endpage w firstrow
    .i count=endpage w lastrow
    
    
    k ^TMP("dhcpha","DHCSTPIVAOUTRECDRUG","FindReqDetailData",pid)
    q ""
    
    
	
getdata	

	s recflag=$p(^PIVADIS(pdis),"^",7)
	q:(onlyrec="true")&(recflag="")  //已完成接收
    q:(onlyrec'="true")&(recflag'="")
	s oeori=$p(^PIVADIS(pdis),"^",1)
	s ord=$p(oeori,"||",1)
	s chl=$p(oeori,"||",2)
	q:'$d(^OEORD(ord,"I",chl))
	s dodis=$p(^PIVADIS(pdis),"^",2)
	s prescno=$p(^OEORD(ord,"I",chl,1),"^",14) 
	S PriDr=$p(^OEORD(ord,"I",chl,1),"^",8)
    Q:PriDr="" 
    S priority=$p(^OECPR(PriDr),"^",1) 			;医嘱优先级代码   
    Q:(prescno="")&(priority'["OM")
    q:priority'["OM"
	s adm=$p(^OEORD(ord),"^",1)
	s chkdocloc=1
	s:emlocdr'="" chkdocloc=##class(web.DHCOutPhDisp).ChkLGDocLoc(emlocdr,adm) //留观室
	q:chkdocloc=0
    s papmidr=$p(^PAADM(adm),"^",1)
    S PapmiNo=$p(^PAPER(papmidr,"PAT",1),"^",2)
    q:(PapmiNo'=RegNo)&(RegNo'="")
    s seqno=$P(^OEORD(ord,"I",chl,3),"^",4)
    s sttdate=$P(^OEORD(ord,"I",chl,1),"^",9)
    s index=papmidr_"^"_adm_"^"_sttdate_"^"_prescno_"^"_oeori
    s index2=pdis
    s ^TMP("dhcpha","DHCSTPIVAOUTRECDRUG",pid,"index",index,index2)=""
    q
}

/// 接收自备药配液申请	
/// Creator:LiangQiang
/// CreatDate:2013-05-27
/// Input:医嘱ID,接收人ID
/// Output:0失功
ClassMethod ReceiveDrug(pdisstring, recuser, oprecflag) As %String
{
	
	s cnt=$l(pdisstring,",")
	s currdate=+$h
	s currtime=+$p($h,",",2)
    tstart
    s exit=0
    f i=1:1:cnt q:exit=1  d
    .s pdis=$p(pdisstring,",",i)
	.s recflag=$p(^PIVADIS(pdis),"^",7)
	.q:recflag'=""
	.&sql(update PIVA_DispRequest set PIVADIS_OpStatus=:oprecflag,PIVADIS_OpUser_Dr=:recuser, PIVADIS_OpDate=:currdate ,PIVADIS_OpTime=:currtime where PIVADIS_Rowid=:pdis )
	.i SQLCODE'=0  d
    ..s ret=$$SqlErrorRecord^DHCSTERROR("ReceiveDrug:DHCSTPIVAOUTRECDRUG",pdis,SQLCODE_":"_%msg)
	..i SQLCODE'=0  s exit=1
	.i exit=1 tro
	.q:exit=1
	
	q:exit=1 
	tcommit
	q 0
}

}
