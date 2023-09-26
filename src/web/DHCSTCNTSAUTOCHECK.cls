Import sqluser

Class web.DHCSTCNTSAUTOCHECK Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// 检查本此就诊医嘱是否有重复项
/// Input:处方号	
/// Return:重复-处方号1^处方号2 ,非重复 -空
ClassMethod CheckArcExist(prescno) As %String
{
	q:prescno="" ""
	s existflag=0
	s pid=##class(web.DHCSTCNTSMAIN).GetPHCNTSPID()
	s ord=""
	f  s ord=$o(^OEORD(0,"PrescNo",prescno,ord))  q:ord=""  d
	.s chl=""
	.f  s chl=$o(^OEORD(0,"PrescNo",prescno,ord,chl)) q:chl=""  d
	..s arcimid=$p(^OEORD(ord,"I",chl,1),"^",2)
	..s statdr=$p(^OEORD(ord,"I",chl,1),"^",13)
	..s oeflag=$p(^OEC("OSTAT",statdr),"^",1)
	..q:(oeflag'="V")&(oeflag'="E")
	..s orditm=ord_"||"_chl
	..s incdex=ord_","_arcimid
	..i '$d(^TMP("dhcpha","DHCSTCNTSMAIN","CheckArcExist",pid,incdex)) d
	...s ^TMP("dhcpha","DHCSTCNTSMAIN","CheckArcExist",pid,incdex)=""
	..e  d
	...s ^TMP("dhcpha","DHCSTCNTSMAIN","CheckArcExist","ExistArr",pid,orditm)=""
	
	s incdex=""
	f  s incdex=$o(^TMP("dhcpha","DHCSTCNTSMAIN",pid,incdex)) q:incdex=""  d
	.s ord=$p(incdex,",",1)
	.s arc=$p(incdex,",",2)
	.s stt=""
	.f  s stt=$o(^OEORDi(0,"ARCIM",ord,arc,stt)) q:stt=""  d 
	..s chl=""
	..f  s chl=$o(^OEORDi(0,"ARCIM",ord,arc,stt,chl)) q:chl=""  d
	...s pre=$p(^OEORD(ord,"I",chl,1),"^",14)
	...q:pre=""
	...s statdr=$p(^OEORD(ord,"I",chl,1),"^",13)
	...s oeflag=$p(^OEC("OSTAT",statdr),"^",1)
	...q:(oeflag'="V")&(oeflag'="E")
	...q:pre=prescno
	...s oeori=ord_"||"_chl
	...q:$d(^TMP("dhcpha","DHCSTCNTSAUTOCHECK","CheckArcExist",pid,incdex))
	...s ^TMP("dhcpha","DHCSTCNTSAUTOCHECK","CheckArcExist","ExistArr",pid,oeori)=""
	
	s ret=""
	s oeori=""
	f  s oeori=$o(^TMP("dhcpha","DHCSTCNTSAUTOCHECK","CheckArcExist","ExistArr",pid,oeori)) q:oeori=""  d
	.i ret="" d
	..s ret=oeori
	.e  d
	..s ret=ret_"^"_oeori
	k ^TMP("dhcpha","DHCSTCNTSAUTOCHECK","CheckArcExist",pid)
	k ^TMP("dhcpha","DHCSTCNTSAUTOCHECK","CheckArcExist","ExistArr",pid)
	q ret
}

ClassMethod GetRepeatOrdList(str, stpage, limit) As %String
{
	
	s endpage=stpage+limit  //结束行
	s stpage=stpage+1 //开始行
	s pid=##class(web.DHCSTCNTSMAIN).GetPHCNTSPID()
	s findflag=1
	s h=0,colorflag=0
	s cnt=$l(str,"^")
	f i=1:1:cnt d 
	.s qorditm=$p(str,"^",i)
	.s qord=$p(qorditm,"||",1)
	.s qitm=$p(qorditm,"||",2)
	.s prescno=$p(^OEORD(qord,"I",qitm,1),"^",14)
	.s ord=""
	.f  s ord=$o(^OEORD(0,"PrescNo",prescno,ord))  q:ord=""  d
	..s chl=""
	..f  s chl=$o(^OEORD(0,"PrescNo",prescno,ord,chl)) q:chl=""  d
	...s orditm=ord_"||"_chl
	...i qorditm=orditm s colorflag=1
	...e  s colorflag=0
	...s presc=$p(^OEORD(ord,"I",chl,1),"^",14) ;处方号
	...s arcimid=$p(^OEORD(ord,"I",chl,1),"^",2)  ;医嘱 ARC_ItmMast ARCIM_RowId
	...s itmmastid=$p(arcimid,"||",1)
	...s itmmastver=$p(arcimid,"||",2)
	...s inci=$o(^INCI(0,"ARCIM_DR",$p(arcimid,"||",1),"") ) q:inci=""  //医嘱名称
	...s inciDesc=$p(^INCI(inci,1),"^",2) //药品名称
	...s dsp=$o(^DHCOEDISQTY(0,"OEORI",orditm,""))
	...q:dsp=""
    ...s qty=$p(^DHCOEDISQTY(dsp),"^",2)
	...s:findflag=1 puomdr=$p(^ARCIM(itmmastid,itmmastver,8),"^",14)
	...s:findflag=2 puomdr=+$p(^INCI(inci,3),"^",6)
	...s buomdr=+$p(^INCI(inci,1),"^",10)
	...s fac=+##Class(web.DHCSTCOMMONSRV).UOMFac(puomdr,buomdr)
	...s uomdr=buomdr
	...i (qty#fac)=0 d
	....s qty=qty/fac   //数量
	....s uomdr=puomdr 
	...s uomdesc=$p($g(^CT("UOM",uomdr)),"^",2) //单位
	...s dosage=$j($p(^OEORD(ord,"I",chl,2),"^",1)," ",3) ;剂量
    ...s doseuom=""
	...s dosuomID=+$p(^OEORD(ord,"I",chl,2),"^",3)
	...i dosuomID'=0 d
	....s doseuom=$p($g(^CT("UOM",dosuomID)),"^",2) ;剂量单位
	...s freq=""
	...s freqdr=+$p($g(^OEORD(ord,"I",chl,2)),"^",4) ;OEORI_PHFreq_DR
    ...i freqdr'=0 s freq=$p($g(^PHCFR(freqdr)),"^",3)  ;频率
    ...s instru=""
    ...s instrudr=+$p(^OEORD(ord,"I",chl,2),"^",7)
    ...s:instrudr'=0 instru=$p(^PHCIN(instrudr),"^",2)        	;用法
    ...s duration=""
    ...s dur=+$p(^OEORD(ord,"I",chl,2),"^",6)
	...s:dur'=0 duration=$p(^PHCDU(dur),"^",1)         	;用药疗程
	...s priorty=""
	...s pri=+$p(^OEORD(ord,"I",chl,1),"^",8)
	...s:pri'=0 priorty=$p(^OECPR(pri),"^",2)   		;医嘱优先级
	...s doctor=##class(web.DHCSTCOMMONSRV).getOrdDoctor(orditm)       ;医生
	...s skintest=##class(web.DHCSTCOMMONSRV).GetSkinTestResult(orditm)  ;皮试
	...s form=##class(web.DHCSTCOMMONSRV).GetForm(inci)  ;剂型
	...i $F(form,$c(13)) s form=$p(form,$c(13))
	...s spec=##class(web.DHCSTCOMMONSRV).getBarcode(inci) ;规格
	...s manf=##class(web.DHCSTITMDESC).GetManfNameByInci(inci) ;厂家
	...i $f(manf,"-") s manf=$p(manf,"-",2)
	...s remark=##class(web.DHCSTCOMMONSRV).GetOrdItmRemark(orditm) ;备注
	...s realdura=##class(web.DHCSTCNTSCOMMON).GetRealDuration(orditm) ;实际疗程
	...s basflag=""
	...s infor=$o(^DHCITMINFO(0,"INCI",inci,""))
	...i infor'="" s basflag=$p(^DHCITMINFO(infor),"^",4)
	...s dsp=""
	...f  s dsp=$o(^DHCOEDISQTY(0,"OEORI",orditm,dsp)) q:dsp=""  d
	....s status=$p(^DHCOEDISQTY(dsp),"^",7)
	....q:status="R"
    ....//s orddate=$p(^OEORD(ord,"I",chl,3),"^",7)
    ....//s ordtime=$p(^OEORD(ord,"I",chl,3),"^",15)
    ....s orddate=$p(^DHCOEDISQTY(dsp),"^",15)
    ....i orddate'="" s orddate=##class(websys.Conversions).DateLogicalToHtml(orddate)
    ....s ordtime=$p(^DHCOEDISQTY(dsp),"^",16)
    ....i ordtime'="" s ordtime=##class(websys.Conversions).TimeLogicalToHtml(ordtime)
    ....s orddatetime=orddate_" "_ordtime  ;开单日期
    ....s h=h+1
    ....s data=skintest_" "_inciDesc_"^"_qty_"^"_uomdesc_"^"_dosage_doseuom_"^"_freq_"^"_spec_"^"_instru_"^"_duration_"^"_form
    ....s data=data_"^"_priorty_"^"_doctor_"^"_orddatetime_"^"_remark_"^"_manf_"^"_basflag_"^"_realdura_"^"_colorflag_"^"_prescno
    ....s ^TMP("dhcpha","DHCSTCNTSAUTOCHECK","GetRepeatOrdList",pid,h)=data
    
    q:h=0 ##class(web.DHCSTEXTCOMMON).GetNoJson()
    s maxrow=h
    i endpage>maxrow s endpage=maxrow
    s count=0
    s h=""
    f  s h=$o(^TMP("dhcpha","DHCSTCNTSAUTOCHECK","GetRepeatOrdList",pid,h)) q:h=""  d
    .s data=^TMP("dhcpha","DHCSTCNTSAUTOCHECK","GetRepeatOrdList",pid,h)
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
    .s basflag=$p(data,"^",15)
    .s realdura=$p(data,"^",16)
    .s colorflag=$p(data,"^",17)
    .s prescno=$p(data,"^",18)
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
	.s manf=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("manf",manf)
	.s basflag=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("basflag",basflag)
	.s realdura=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("realdura",realdura)
	.s colorflag=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("colorflag",colorflag)
	.s prescno=##class(web.DHCSTEXTCOMMON).GetJsonLastCell("prescno",prescno)
	.
	.s tmpstr=incidesc_qty_uomdesc_dosage_freq_spec_instruc_dura_form_pri_doctor_orddate_remark_manf_basflag_realdura_colorflag_prescno
	.
    .s startString=##class(web.DHCSTEXTCOMMON).GetJsonStartString(maxrow)
    .s firstrow=##class(web.DHCSTEXTCOMMON).GetJsonFirstRow(tmpstr)
    .s lastrow=##class(web.DHCSTEXTCOMMON).GetJsonLastRow(tmpstr)
	.
	.;i count=1 w startString
    .;i count<maxrow w firstrow
    .;i count=maxrow w lastrow
    .
    .i count=stpage w startString
    .i count<endpage w firstrow
    .i count=endpage w lastrow
    
    
    k ^TMP("dhcpha","DHCSTCNTSAUTOCHECK ","GetRepeatOrdList",pid)
    q ""
	.
}

}
