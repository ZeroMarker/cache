Import sqluser

/// 点评统计
Class web.DHCSTCNTSQUERY Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// 查询处方点评单,按处方明细
ClassMethod QueryCommontItm(QueryStr, StartPage, Limit) As %String
{
	s HospID=""
	s pid=##class(web.DHCSTCNTSMAIN).GetPHCNTSPID()
	s endpage=StartPage+Limit  //结束行
	s stpage=StartPage+1 //开始行
	s qstdate=$p(QueryStr,"^",1)
	s qenddate=$p(QueryStr,"^",2)
	s:qstdate'="" qstdate=##class(websys.Conversions).DateHtmlToLogical(qstdate)
   	s:qenddate'="" qenddate=##class(websys.Conversions).DateHtmlToLogical(qenddate)
	s qdoclocdr=$p(QueryStr,"^",3)
	s qinci=$p(QueryStr,"^",4)
	s qresult=$p(QueryStr,"^",5)
	s qcomnostr=$p(QueryStr,"^",6) //单号串
	s pcntstype="F"
	s tmpstr=qinci
	s x=0
	s h=0
	f date=qstdate:1:qenddate d
	.s typecnt=$l(pcntstype,"^")
	.f i=1:1:typecnt d
	..s type=$p(pcntstype,"^",i)
	..s pcnts=""
	..f  s pcnts=$o(^DHCPHCNTS(0,"Date",date,type,pcnts)) q:pcnts=""  d
	...s pcntsno=$p(^DHCPHCNTS(pcnts),"^",1)
	...q:(qcomnostr'="")&(..CheckComNo(qcomnostr,pcntsno)=0)
	...s pcntsdate=$p(^DHCPHCNTS(pcnts),"^",2)
	...i pcntsdate'="" s pcntsdate=##class(websys.Conversions).DateLogicalToHtml(pcntsdate)
	...s pcntstime=$p(^DHCPHCNTS(pcnts),"^",3)
	...i pcntstime'="" s pcntstime=##class(websys.Conversions).TimeLogicalToHtml(pcntstime)
	...s pcntstext=$p(^DHCPHCNTS(pcnts),"^",4)
	...s pcntsuserdr=$p(^DHCPHCNTS(pcnts),"^",6)
	...s pcntsuser=$p(^SSU("SSUSR",pcntsuserdr),"^",2)
	...i type="F" s typedesc="门诊"
	...i type="P" s typedesc="住院"
	...s chl=""
	...f  s chl=$o(^DHCPHCNTS(pcnts,"I",chl)) q:chl=""  d
	....s pcntsitm=pcnts_"||"_chl
	....s prescno=$p(^DHCPHCNTS(pcnts,"I",chl),"^",1)
	....s orditem=$p(^DHCPHCNTS(pcnts,"I",chl),"^",2)
	....s ord=$p(orditem,"||",1)
	....s itm=$p(orditem,"||",2)
	....s adm=$p(^DHCPHCNTS(pcnts,"I",chl),"^",3)
	....s papmi=$p(^PAADM(adm),"^",1)
	....s patname=$p(^PAPER(papmi,"ALL"),"^", 1) ;患者姓名
	....s sex=$p(^PAPER(papmi,"ALL"),"^",7 ) ;姓别
	....s patsex=$p(^CT("SEX",sex),"^",2)
	....s patno=$p(^PAPER(papmi,"PAT",1),"^",1)
	....s patage=##class(web.DHCSTKUTIL).GetAge(papmi)  ;年龄   
    ....s diag=..GetMRDiagnosDesc(adm,",") ;诊断
    ....i $f(diag,$c(13)) s diag=$p(diag,$c(13),1)
    ....s billtype=""
    ....s billtypedr=+$p(^PAPER(papmi,"PER",1),"^",10)
    ....s:billtypedr'="" billtype=$p(^CT("SS",billtypedr),"^",2)
	....s doclocdr=$p(^DHCPHCNTS(pcnts,"I",chl),"^",4)
	....s orddeptcode=$p(^CTLOC(doclocdr),"^",1)  ;科室代码
    ....s orddept=$p(^CTLOC(doclocdr),"^",2)  
    ....q:..ChkDocLocStr(qdoclocdr,doclocdr)=0 ;科室
    ....i HospID="" s HospID=$p(^CTLOC(doclocdr),"^",22)  
	....i $f(orddept,"-") s orddept=$p(orddept,"-",2)
	....s docdr=$p(^DHCPHCNTS(pcnts,"I",chl),"^",5)
	....s doctorcode=$p(^SSU("SSUSR",docdr),"^",1)  ;医生工号
	....s doctor=$p(^SSU("SSUSR",docdr),"^",2)  ;医生
	....s curret=$p(^DHCPHCNTS(pcnts,"I",chl),"^",6) ;结果
	....q:(qresult=1)&(curret'="Y")
	....q:(qresult=2)&(curret'="N")
	....q:(qresult=4)&(curret="") //仅有结果
	....i curret="Y" s curret="合理"
	....i curret="N" s curret="不合理"
	....s username=""
	....s sub=$o(^DHCPHCNTS(pcnts,"I",chl,"L",""),-1)
	....i sub'="" d
	.....s userdr=$p(^DHCPHCNTS(pcnts,"I",chl,"L",sub),"^",5)
	.....s username=$p(^SSU("SSUSR",userdr),"^",2)
	....s chkstr=..ChkItmByPrescNo(prescno,tmpstr)
	....s chkflag=$p(chkstr,"^",1)
	....q:chkflag=0  //检查包含项目是否符合
	....s prescamt=$p(chkstr,"^",2)  //处方金额
	....s sumantamt=$p(chkstr,"^",3)
	....s antamtcent=$p(chkstr,"^",4)
	....s sumbasamt=$p(chkstr,"^",5)
	....s basamtcent=$p(chkstr,"^",6)
	....s reasoninfo=..GetCommentRea(orditem,pcntsitm) //不合理原因
	....s reacode=$p(reasoninfo,"^",1)
	....s reason=$p(reasoninfo,"^",2)
	....s phadvice=$p(reasoninfo,"^",3)
	....s phnote=$p(reasoninfo,"^",4)
	....s y=0 //一个处方的开始
	....s x=x+1
	....s colorflag=0
	....i x#2=1 s colorflag=1
	....s ord=""
	....f  s ord=$o(^OEORD(0,"PrescNo",prescno,ord))  q:ord=""  d
	.....s itm=""
    .....f  s itm=$o(^OEORD(0,"PrescNo",prescno,ord,itm)) q:itm=""  d
    ......s arcitm=$p(^OEORD(ord,"I",itm,1),"^",2)
    ......s inci=$o(^INCI(0,"ARCIM_DR",$p(arcitm,"||",1),""))
    ......s orditm=ord_"||"_itm
    ......//药品
	......s arcimid=$p(^OEORD(ord,"I",itm,1),"^",2)  ;医嘱 ARC_ItmMast ARCIM_RowId
	......s itmmastid=$p(arcimid,"||",1)
	......s itmmastver=$p(arcimid,"||",2)
	......s inci=$o(^INCI(0,"ARCIM_DR",$p(arcimid,"||",1),"") ) q:inci=""  //医嘱名称
	......s incidesc=$p(^INCI(inci,1),"^",2) //药品名称
	......s dsp=$o(^DHCOEDISQTY(0,"OEORI",orditm,""))
	......q:dsp=""
    ......s qty=$p(^DHCOEDISQTY(dsp),"^",2)
    ......s findflag=1
	......s:findflag=1 puomdr=$p(^ARCIM(itmmastid,itmmastver,8),"^",14)
	......s:findflag=2 puomdr=+$p(^INCI(inci,3),"^",6)
	......s buomdr=+$p(^INCI(inci,1),"^",10)
	......s fac=+##Class(web.DHCSTCOMMONSRV).UOMFac(puomdr,buomdr)
	......s uomdr=buomdr
	......i (qty#fac)=0 d
	.......s qty=qty/fac   //数量
	......s uomdr=puomdr 
	......s uomdesc=$p($g(^CT("UOM",uomdr)),"^",2) //单位
	......s dosage=$j($p(^OEORD(ord,"I",itm,2),"^",1)," ",3) ;剂量
    ......s doseuom=""
	......s dosuomID=$p(^OEORD(ord,"I",itm,2),"^",3)
	......i dosuomID'="" d
	.......s doseuom=$p($g(^CT("UOM",dosuomID)),"^",2) ;剂量单位
	......s dosage=dosage_doseuom
	......s freq=""
	......s freqdr=$p($g(^OEORD(ord,"I",itm,2)),"^",4) ;OEORI_PHFreq_DR
    ......i freqdr'="" s freq=$p($g(^PHCFR(freqdr)),"^",3)  ;频率
    ......s instru=$p(^PHCIN($p(^OEORD(ord,"I",itm,2),"^",7)),"^",2)        	;用法
	......s duration=$p(^PHCDU($p(^OEORD(ord,"I",itm,2),"^",6)),"^",1)         	;用药疗程
	......s skintest=##class(web.DHCSTCOMMONSRV).GetSkinTestResult(orditm)  ;皮试
	......s incidesc=skintest_incidesc
	......s remark=##class(web.DHCSTCOMMONSRV).GetOrdItmRemark(orditm) ;备注
	......s retdata=..GetPrescNoInfo(prescno)
	......s pyuser=$p(retdata,"^",3) //配药人
	......s fyuser=$p(retdata,"^",4) //发药人
	......s dspdate=+$h 
	......s status=$p(^DHCOEDISQTY(dsp),"^",7)
	......i status="C" s dspdate=$p(^DHCOEDISQTY(dsp),"^",8)
	......//s price=##class(web.DHCSTCOMMONSRV).GetPriceElse(+inci,dspdate,puomdr,"")
	......s exStr="^"_dsp
	......s price=##class(web.DHCSTPRICE).GetSp(+inci,dspdate,puomdr,HospID,"",exStr)	//zhouyg 20150113
	......s amt=$fn(price*qty,"",2)
	......s h=h+1
	......s y=y+1
    ......i y'=1 s curret="",reason="",phadvice="",phnote=""
    ......s data=pcntsno_"^"_prescno_"^"_patno_"^"_patsex_"^"_patage_"^"_diag_"^"_orddept_"^"_doctor_"^"_curret_"^"_incidesc_"^"_colorflag_"^"_reason_"^"_phadvice_"^"_phnote
    ......s data=data_"^"_qty_"^"_uomdesc_"^"_dosage_"^"_freq_"^"_instru_"^"_duration_"^"_remark_"^"_pyuser_"^"_fyuser_"^"_price_"^"_amt_"^"_prescamt_"^"_doctorcode_"^"_orddeptcode
    ......s data=data_"^"_patname_"^"_sumantamt_"^"_antamtcent_"^"_sumbasamt_"^"_basamtcent_"^"_billtype_"^"_username
    ......s ^TMP("dhcpha","DHCSTCNTSQUERY","QueryCommontItm",pid,h)=data
    ......s ^TMP("dhcpha","DHCSTCNTSQUERY","QueryCommontItm","Export",pid,h)=data
	
	q:h=0 ##class(web.DHCSTEXTCOMMON).GetNoJson()
	
    s maxrow=h
    i endpage>maxrow s endpage=maxrow
    s count=0
    s h=""
    f  s h=$o(^TMP("dhcpha","DHCSTCNTSQUERY","QueryCommontItm",pid,h)) q:h=""  d
    .s data=^TMP("dhcpha","DHCSTCNTSQUERY","QueryCommontItm",pid,h)
    .s pcntsno=$p(data,"^",1)
    .s prescno=$p(data,"^",2)
    .s patno=$p(data,"^",3)
    .s patsex=$p(data,"^",4)
    .s patage=$p(data,"^",5)
    .s diag=$p(data,"^",6)
    .s orddept=$p(data,"^",7)
    .s doctor=$p(data,"^",8)
    .s curret=$p(data,"^",9)
    .s incidesc=$p(data,"^",10)
    .s colorflag=$p(data,"^",11)
    .s reason=$p(data,"^",12)
    .s phadvice=$p(data,"^",13)
    .s phnote=$p(data,"^",14)
    .s qty=$p(data,"^",15)
    .s uomdesc=$p(data,"^",16)
    .s dosage=$p(data,"^",17)
    .s freq=$p(data,"^",18)
    .s instru=$p(data,"^",19)
    .s duration=$p(data,"^",20)
    .s remark=$p(data,"^",21)
    .s pyuser=$p(data,"^",22)
    .s fyuser=$p(data,"^",23)
    .s price=$p(data,"^",24)
    .s amt=$p(data,"^",25)
    .s prescamt=$p(data,"^",26)
    .s doctorcode=$p(data,"^",27)
    .s orddeptcode=$p(data,"^",28)
    .s patname=$p(data,"^",29)
    .s sumantamt=$p(data,"^",30)
    .s antamtcent=$p(data,"^",31)
    .s sumbasamt=$p(data,"^",32)
    .s basamtcent=$p(data,"^",33)
    .s billtype=$p(data,"^",34)
    .s username=$p(data,"^",35)
    .
    .s count=count+1
    .q:count<stpage
    .q:count>endpage
    .
    .s pcntsno=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("pcntsno",pcntsno)
	.s prescno=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("prescno",prescno)
	.s patno=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("patno",patno)
	.s patsex=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("patsex",patsex)
	.s patage=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("patage",patage)
	.s diag=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("diag",diag)
	.s orddept=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("orddept",orddept)
	.s doctor=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("doctor",doctor)
	.s curret=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("curret",curret)
	.s incidesc=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("incidesc",incidesc)
	.s colorflag=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("colorflag",colorflag)
	.s reason=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("reason",reason)
	.s phadvice=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("phadvice",phadvice)
	.s phnote=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("phnote",phnote)
	.s pidnum=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("pid",pid)
	.s qty=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("qty",qty)
	.s uomdesc=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("uomdesc",uomdesc)
	.s dosage=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("dosage",dosage)
	.s freq=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("freq",freq)
	.s instru=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("instru",instru)
	.s duration=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("duration",duration)
	.s remark=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("remark",remark)
	.s pyuser=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("pyuser",pyuser)
	.s fyuser=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("fyuser",fyuser)
	.s price=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("price",price)
	.s amt=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("amt",amt)
	.s prescamt=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("prescamt",prescamt)
	.s doctorcode=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("doctorcode",doctorcode)
	.s orddeptcode=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("orddeptcode",orddeptcode)
	.s sumantamt=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("sumantamt",sumantamt)
	.s antamtcent=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("antamtcent",antamtcent)
	.s sumbasamt=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("sumbasamt",sumbasamt)
	.s basamtcent=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("basamtcent",basamtcent)
	.s billtype=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("billtype",billtype)
	.s patname=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("patname",patname)
	.s username=##class(web.DHCSTEXTCOMMON).GetJsonLastCell("username",username)
	.
	.s tmpstr=pcntsno_prescno_patno_patsex_patage_diag_orddept_doctor_curret_incidesc_colorflag
	.s tmpstr=tmpstr_reason_phadvice_phnote_pidnum_qty_uomdesc_dosage_freq_instru_duration_remark
	.s tmpstr=tmpstr_pyuser_fyuser_price_amt_prescamt_doctorcode_orddeptcode_sumantamt_antamtcent
	.s tmpstr=tmpstr_sumbasamt_basamtcent_billtype_patname_username
	.
    .s startString=##class(web.DHCSTEXTCOMMON).GetJsonStartString(maxrow)
    .s firstrow=##class(web.DHCSTEXTCOMMON).GetJsonFirstRow(tmpstr)
    .s lastrow=##class(web.DHCSTEXTCOMMON).GetJsonLastRow(tmpstr)
    .
    .i count=stpage w startString
    .i count<endpage w firstrow
    .i count=endpage w lastrow
    
    
    k ^TMP("dhcpha","DHCSTCNTSQUERY","QueryCommontItm",pid)
    
	
    q ""
}

/// 查询处方点评,按处方汇总
ClassMethod QueryCommontPrescNo(QueryStr, StartPage, Limit) As %String
{

	s pid=##class(web.DHCSTCNTSMAIN).GetPHCNTSPID()
	s endpage=StartPage+Limit  //结束行
	s stpage=StartPage+1 //开始行
	s qstdate=$p(QueryStr,"^",1)
	s qenddate=$p(QueryStr,"^",2)
	s:qstdate'="" qstdate=##class(websys.Conversions).DateHtmlToLogical(qstdate)
   	s:qenddate'="" qenddate=##class(websys.Conversions).DateHtmlToLogical(qenddate)
	s qdoclocdr=$p(QueryStr,"^",3)
	s qinci=$p(QueryStr,"^",4)
	s qresult=$p(QueryStr,"^",5)
	s qcomnostr=$p(QueryStr,"^",6)  //单号串
	s pcntstype="F"
	s tmpstr=qinci
	s h=0
	f date=qstdate:1:qenddate d
	.s typecnt=$l(pcntstype,"^")
	.f i=1:1:typecnt d
	..s type=$p(pcntstype,"^",i)
	..s pcnts=""
	..f  s pcnts=$o(^DHCPHCNTS(0,"Date",date,type,pcnts)) q:pcnts=""  d
	...s pcntsno=$p(^DHCPHCNTS(pcnts),"^",1)
	...q:(qcomnostr'="")&(..CheckComNo(qcomnostr,pcntsno)=0)
	...s pcntsdate=$p(^DHCPHCNTS(pcnts),"^",2)
	...i pcntsdate'="" s pcntsdate=##class(websys.Conversions).DateLogicalToHtml(pcntsdate)
	...s pcntstime=$p(^DHCPHCNTS(pcnts),"^",3)
	...i pcntstime'="" s pcntstime=##class(websys.Conversions).TimeLogicalToHtml(pcntstime)
	...s pcntstext=$p(^DHCPHCNTS(pcnts),"^",4)
	...s pcntsuserdr=$p(^DHCPHCNTS(pcnts),"^",6)
	...s pcntsuser=$p(^SSU("SSUSR",pcntsuserdr),"^",2)
	...i type="F" s typedesc="门诊"
	...i type="P" s typedesc="住院"
	...s chl=""
	...f  s chl=$o(^DHCPHCNTS(pcnts,"I",chl)) q:chl=""  d
	....s pcntsitm=pcnts_"||"_chl
	....s prescno=$p(^DHCPHCNTS(pcnts,"I",chl),"^",1)
	....s orditem=$p(^DHCPHCNTS(pcnts,"I",chl),"^",2)
	....s ord=$p(orditem,"||",1)
	....s itm=$p(orditem,"||",2)
	....s orddate=$p(^OEORD(ord,"I",itm,3),"^",7)
	....i orddate'="" s orddate=##class(websys.Conversions).DateLogicalToHtml(orddate)  //处方日期
	....s adm=$p(^DHCPHCNTS(pcnts,"I",chl),"^",3)
	....s papmi=$p(^PAADM(adm),"^",1)
	....s patname=$p(^PAPER(papmi,"ALL"),"^", 1) ;患者姓名
	....s patsex=""
	....s patsexdr=$p(^PAPER(papmi,"ALL"),"^",7 ) 
	....s:patsexdr'="" patsex=$p(^CT("SEX",patsexdr),"^",2 ) ;性别
	....s patno=$p(^PAPER(papmi,"PAT",1),"^",1)
	....s patage=##class(web.DHCSTKUTIL).GetAge(papmi)  ;年龄   
    ....s diag=..GetMRDiagnosDesc(adm,",") ;诊断
    ....i $f(diag,$c(13)) s diag=$p(diag,$c(13),1)
	....s doclocdr=$p(^DHCPHCNTS(pcnts,"I",chl),"^",4)
    ....s orddept=$p(^CTLOC(doclocdr),"^",2)  
    ....q:..ChkDocLocStr(qdoclocdr,doclocdr)=0 ;科室
	....i $f(orddept,"-") s orddept=$p(orddept,"-",2)
	....s docdr=$p(^DHCPHCNTS(pcnts,"I",chl),"^",5)
	....s doctor=$p(^SSU("SSUSR",docdr),"^",2)  ;医生
	....//q:..ChkItmByPrescNo(prescno,qinci)=0 ;药品
	....s chkstr=..ChkItmByPrescNo(prescno,tmpstr) ;检查项目
	....s chkflag=$p(chkstr,"^",1)
	....q:chkflag=0  //检查包含项目是否符合
	....s curret=$p(^DHCPHCNTS(pcnts,"I",chl),"^",6) ;结果
	....q:(qresult=1)&(curret'="Y")
	....q:(qresult=2)&(curret'="N")
	....q:(qresult=4)&(curret="") //仅有结果
	....i curret="Y" s curret="1"
	....i curret="N" s curret="0"
	....//药品
	....s arcimid=$p(^OEORD(ord,"I",itm,1),"^",2)  ;医嘱 ARC_ItmMast ARCIM_RowId
	....s itmmastid=$p(arcimid,"||",1)
	....s itmmastver=$p(arcimid,"||",2)
	....s inci=$o(^INCI(0,"ARCIM_DR",$p(arcimid,"||",1),"") ) q:inci=""  //医嘱名称
	....s incidesc=$p(^INCI(inci,1),"^",2) //药品名称
	....s retdata=..GetPrescNoInfo(prescno)
	....s datanum=$p(retdata,"^",1) //品种数
	....s amt=$p(retdata,"^",2)  //处方金额
	....s pyuser=$p(retdata,"^",3) //配药人
	....s fyuser=$p(retdata,"^",4) //发药人
	....s zsnum=$p(retdata,"^",5) //注射
	....s kjnum=$p(retdata,"^",6) //抗菌
	....s bnum=$p(retdata,"^",7) //基本药物
	....s gernum=$p(retdata,"^",8) //通用药品名数
	....s reasoninfo=..GetCommentRea(orditem,pcntsitm) //不合理原因
	....s reacode=$p(reasoninfo,"^",1)
	....s reason=$p(reasoninfo,"^",2)
	....s phadvice=$p(reasoninfo,"^",3)
	....s phnote=$p(reasoninfo,"^",4)
	....s h=h+1
    ....s data=prescno_"^"_patno_"^"_patsex_"^"_patage_"^"_diag_"^"_curret_"^"_doctor
    ....s data=data_"^"_datanum_"^"_gernum_"^"_amt_"^"_pyuser_"^"_fyuser_"^"_zsnum_"^"_kjnum_"^"_bnum
    ....s data=data_"^"_reacode_"^"_orddate_"^"_pid_"^"_patname
    ....s ^TMP("dhcpha","DHCSTCNTSQUERY","QueryCommontPrescNo",pid,h)=data
	
	q:h=0 ##class(web.DHCSTEXTCOMMON).GetNoJson()
	
	
	s totalnum=0,totalzsnum=0,totalkjnum=0,totalbnum=0,totalamt=0,retoktotalnum=0,totalgnum=0
	
	s maxrow=h+3
	i endpage>maxrow s endpage=maxrow
	
   
	s m=0    //统计记录数(不含最下三行总计平均%)
    s num=0  //导出xls数量
    s h=""
    f  s h=$o(^TMP("dhcpha","DHCSTCNTSQUERY","QueryCommontPrescNo",pid,h)) q:h=""  d
    .s data=^TMP("dhcpha","DHCSTCNTSQUERY","QueryCommontPrescNo",pid,h)
    .s prescno=$p(data,"^",1)
    .s patno=$p(data,"^",2)
    .s patsex=$p(data,"^",3)
    .s patage=$p(data,"^",4)
    .s diag=$p(data,"^",5)
    .s curret=$p(data,"^",6)
    .s doctor=$p(data,"^",7)
    .s itmnum=$p(data,"^",8)
    .s gernum=$p(data,"^",9)
    .s amt=$p(data,"^",10)
    .s pyuser=$p(data,"^",11)
    .s fyuser=$p(data,"^",12)
    .s zsnum=$p(data,"^",13)
    .s kjnum=$p(data,"^",14)
    .s bnum=$p(data,"^",15)
    .s reason=$p(data,"^",16)
    .s orddate=$p(data,"^",17)
    .s pidnum=$p(data,"^",18)
    .s patname=$p(data,"^",19)
    .
    .//总计
    .s totalnum=totalnum+itmnum
    .i zsnum>0 s totalzsnum=totalzsnum+zsnum  //含有处方张数
    .i kjnum>0 s totalkjnum=totalkjnum+kjnum   //含有处方张数
    .s totalbnum=totalbnum+bnum 
    .s totalamt=totalamt+amt 
    .i curret="1" s retoktotalnum=retoktotalnum+1  //合理总数 
    .s totalgnum=totalgnum+gernum
    .
    .s m=m+1
    .q:m<stpage
    .q:m>endpage
    .s num=num+1
    .
    .s tmpstr=num_"^"_prescno_"^"_patno_"^"_patsex_"^"_patage_"^"_diag_"^"_curret_"^"_doctor_"^"_kjnum_"^"_zsnum_"^"_bnum_"^"_gernum_"^"_amt_"^"_pyuser_"^"_fyuser_"^"_reason_"^"_itmnum_"^"_orddate
    .s tmpstr=tmpstr_"^"_patname
    .s ^TMP("dhcpha","DHCSTCNTSQUERY","QueryCommontPrescNo","Export",pid,num)=tmpstr
    .
    .s count=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("count",num)
	.s prescno=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("prescno",prescno)
	.s patno=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("patno",patno)
	.s patsex=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("patsex",patsex)
	.s patage=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("patage",patage)
	.s diag=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("diag",diag)
	.s curret=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("curret",curret)
	.s doctor=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("doctor",doctor)
	.s kjnum=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("kjnum",kjnum)
	.;s zsnumdesc=0
	.;i zsnum>0 s zsnumdesc=1
	.s zsnum=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("zsnum",zsnum)
	.s bnum=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("bnum",bnum)
	.s gernum=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("gernum",gernum)
	.s amt=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("amt",amt)
	.s pyuser=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("pyuser",pyuser)
	.s fyuser=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("fyuser",fyuser)
	.s reason=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("reason",reason)
	.s itmnum=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("itmnum",itmnum)
	.s orddate=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("orddate",orddate)
	.s pidnum=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("pid",pidnum)
	.s patname=##class(web.DHCSTEXTCOMMON).GetJsonLastCell("patname",patname)
	.
	.s tmpstr=count_prescno_patno_patsex_patage_diag_curret_doctor_kjnum_zsnum_bnum_gernum_amt_pyuser_fyuser_reason_itmnum_orddate_pidnum_patname
	.
    .s startString=##class(web.DHCSTEXTCOMMON).GetJsonStartString(maxrow)
    .s firstrow=##class(web.DHCSTEXTCOMMON).GetJsonFirstRow(tmpstr)
    .s lastrow=##class(web.DHCSTEXTCOMMON).GetJsonLastRow(tmpstr)
	.
    .i m=stpage w startString
    .i m<endpage w firstrow
    .i (m=endpage)&((StartPage+Limit)<maxrow) w lastrow
    .
    
    s count="总计"
    s prescno=""
    s patno=""
    s patsex=""
    s patage=""
    s diag=""
    s curret=retoktotalnum
    s doctor=""
    s itmnum=totalnum
    s gernum=totalgnum
    s amt=totalamt
    s pyuser=""
    s fyuser=""
    s zsnum=totalzsnum
    s kjnum=totalkjnum
    s bnum=totalbnum
    s reason=""
    s orddate=""
    s patname=""
    
    
    s num=num+1
    s tmpstr=count_"^"_prescno_"^"_patno_"^"_patsex_"^"_patage_"^"_diag_"^"_curret_"^"_doctor_"^"_kjnum_"^"_zsnum_"^"_bnum_"^"_gernum_"^"_amt_"^"_pyuser_"^"_fyuser_"^"_reason_"^"_itmnum_"^"_orddate_"^"_patname
    s ^TMP("dhcpha","DHCSTCNTSQUERY","QueryCommontPrescNo","Export",pid,num)=tmpstr
    
    s count=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("count",count)
	s prescno=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("prescno",prescno)
	s patno=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("patno",patno)
	s patsex=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("patsex",patsex)
	s patage=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("patage",patage)
	s diag=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("diag",diag)
	s curret=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("curret",curret)
	s doctor=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("doctor",doctor)
	s kjnum=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("kjnum",kjnum)
	s zsnum=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("zsnum",zsnum)
	s bnum=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("bnum",bnum)
	s gernum=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("gernum",gernum)
	s amt=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("amt",amt)
	s pyuser=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("pyuser",pyuser)
	s fyuser=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("fyuser",fyuser)
	s reason=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("reason",reason)
	s itmnum=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("itmnum",itmnum)
	s orddate=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("orddate",orddate)
	s patname=##class(web.DHCSTEXTCOMMON).GetJsonLastCell("patname",patname)
	    
   	s tmpstr=count_prescno_patno_patsex_patage_diag_curret_doctor_kjnum_zsnum_bnum_gernum_amt_pyuser_fyuser_reason_itmnum_orddate_pidnum_patname
   
    
    i num=1 d
    .s startString=##class(web.DHCSTEXTCOMMON).GetJsonStartString(maxrow) 
    .w startString //正好此次查询只显示最后汇总三行
    
    
    i (StartPage+Limit)'<endpage d
    .i (m+1)<endpage w ##class(web.DHCSTEXTCOMMON).GetJsonFirstRow(tmpstr)
    .i (m+1)=endpage w ##class(web.DHCSTEXTCOMMON).GetJsonLastRow(tmpstr)
    
    
    s count="平均"
    s prescno=""
    s patno=""
    s patsex=""
    s patage=""
    s diag=""
    s curret=""
    i m'=0 s curret=$Fn(retoktotalnum/(m),"",2) 
    s doctor=""
    s itmnum=""
    i m'=0 s itmnum=$Fn(totalnum/(m),"",2)
    s gernum=""
    s amt=""
    i m'=0 s amt=$Fn(totalamt/(m),"",2)
    s pyuser=""
    s fyuser=""
    s zsnum=""
    s kjnum=""
    s bnum=""
    s reason=""
    s orddate=""
    s patname=""
    
    
    s num=num+1
    s tmpstr=count_"^"_prescno_"^"_patno_"^"_patsex_"^"_patage_"^"_diag_"^"_curret_"^"_doctor_"^"_kjnum_"^"_zsnum_"^"_bnum_"^"_gernum_"^"_amt_"^"_pyuser_"^"_fyuser_"^"_reason_"^"_itmnum_"^"_orddate
    s tmpstr=tmpstr_"^"_patname
    s ^TMP("dhcpha","DHCSTCNTSQUERY","QueryCommontPrescNo","Export",pid,num)=tmpstr
    
    s count=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("count",count)
	s prescno=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("prescno",prescno)
	s patno=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("patno",patno)
	s patsex=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("patsex",patsex)
	s patage=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("patage",patage)
	s diag=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("diag",diag)
	s curret=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("curret",curret)
	s doctor=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("doctor",doctor)
	s kjnum=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("kjnum",kjnum)
	s zsnum=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("zsnum",zsnum)
	s bnum=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("bnum",bnum)
	s gernum=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("gernum",gernum)
	s amt=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("amt",amt)
	s pyuser=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("pyuser",pyuser)
	s fyuser=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("fyuser",fyuser)
	s reason=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("reason",reason)
	s itmnum=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("itmnum",itmnum)
	s orddate=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("orddate",orddate)
	s patname=##class(web.DHCSTEXTCOMMON).GetJsonLastCell("patname",patname)
	    
   	s tmpstr=count_prescno_patno_patsex_patage_diag_curret_doctor_kjnum_zsnum_bnum_gernum_amt_pyuser_fyuser_reason_itmnum_orddate_pidnum_patname
    
    i (StartPage+Limit)'<endpage d
    .i (m+2)<endpage w ##class(web.DHCSTEXTCOMMON).GetJsonFirstRow(tmpstr)
    .i (m+2)=endpage w ##class(web.DHCSTEXTCOMMON).GetJsonLastRow(tmpstr)
    

    s count="%"
    s prescno=""
    s patno=""
    s patsex=""
    s patage=""
    s diag=""
    s curret=""
    s doctor=""
    s itmnum=""
    s gernum=""
    s amt=""
    s pyuser=""
    s fyuser=""
    s zsnum=0
    s kjnum=0
    i m>0 d
    .s zsnum=totalzsnum/(m)   //注射剂药总数/处方总数
    .s kjnum=totalkjnum/(m)   //抗菌药总数/处方总数
    s zsnum=$fn(zsnum,"",2)*100
    s kjnum=$fn(kjnum,"",2)*100
    s bnum=""
    i totalnum>0 d
    .s bnum=$Fn(totalbnum/totalnum,"",2)*100  //基本药物总数/处方品种总数
    .s gernum=$Fn(totalgnum/totalnum,"",2)*100
    s reason=""
    s orddate=""
    s patname=""
    
    
    s num=num+1
    s tmpstr=count_"^"_prescno_"^"_patno_"^"_patsex_"^"_patage_"^"_diag_"^"_curret_"^"_doctor_"^"_kjnum_"^"_zsnum_"^"_bnum_"^"_gernum_"^"_amt_"^"_pyuser_"^"_fyuser_"^"_reason_"^"_itmnum_"^"_orddate
    s tmpstr=tmpstr_"^"_patname
    s ^TMP("dhcpha","DHCSTCNTSQUERY","QueryCommontPrescNo","Export",pid,num)=tmpstr
    
    
    s count=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("count",count)
	s prescno=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("prescno",prescno)
	s patno=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("patno",patno)
	s patsex=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("patsex",patsex)
	s patage=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("patage",patage)
	s diag=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("diag",diag)
	s curret=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("curret",curret)
	s doctor=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("doctor",doctor)
	s kjnum=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("kjnum",kjnum)
	s zsnum=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("zsnum",zsnum)
	s bnum=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("bnum",bnum)
	s gernum=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("gernum",gernum)
	s amt=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("amt",amt)
	s pyuser=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("pyuser",pyuser)
	s fyuser=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("fyuser",fyuser)
	s reason=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("reason",reason)
	s itmnum=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("itmnum",itmnum)
	s orddate=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("orddate",orddate)
	s patname=##class(web.DHCSTEXTCOMMON).GetJsonLastCell("patname",patname)
	    
   	s tmpstr=count_prescno_patno_patsex_patage_diag_curret_doctor_kjnum_zsnum_bnum_gernum_amt_pyuser_fyuser_reason_itmnum_orddate_pidnum_patname
    
    i (StartPage+Limit)'<endpage d
    .i (m+3)=endpage w ##class(web.DHCSTEXTCOMMON).GetJsonLastRow(tmpstr)
    
    k ^TMP("dhcpha","DHCSTCNTSQUERY","QueryCommontPrescNo",pid)
	
	q ""
}

/// 获取处方号的信息
ClassMethod GetPrescNoInfo(prescno) As %String
{
    s zsnum=0,kjnum=0,bnum=0,gennum=0 ;zsnum 注射剂 ;kjnum 抗菌药 ;bnum 国家基本药物 ;gennum 通用名数
	s amt=0
	s h=0
	s ord=""
	f  s ord=$o(^OEORD(0,"PrescNo",prescno,ord))  q:ord=""  d
	.s chl=""
    .f  s chl=$o(^OEORD(0,"PrescNo",prescno,ord,chl)) q:chl=""  d
    ..s arcitm=$p(^OEORD(ord,"I",chl,1),"^",2)
    ..s inci=$o(^INCI(0,"ARCIM_DR",$p(arcitm,"||",1),""))
    ..s oeori=ord_"||"_chl
    ..s dsp=$o(^DHCOEDISQTY(0,"OEORI",oeori,"") )
    ..q:dsp=""
    ..s qty=$p(^DHCOEDISQTY(dsp),"^",5) 
	..s dspdate=$p(^DHCOEDISQTY(dsp),"^",15)
	..s ctlocdr=$p(^OEORD(ord,"I",chl,3),"^",6)
	..s HospString=##class(web.DHCSTCOMMONSRV).GetLocHosp(ctlocdr)
    ..s hospdr=$p(HospString,"^",1)
    ..//s spice=##class(web.DHCSTCOMMONSRV).GetPriceElse(+inci,+dspdate,"",hospdr)
    ..s exStr="^"_dsp
    ..s spice=##class(web.DHCSTPRICE).GetSp(+inci,dspdate,"",hospdr,"",exStr)	//zhouyg 20150113
    ..s money=spice*qty
    ..s h=h+1
    ..s amt=amt+money
    ..s pyuser="",fyuser=""
    ..s phdisp=$o(^DHCPHDISPi("PRESCNO",prescno,""))
    ..i phdisp'="" d
    ...s fyuserdr=$p(^DHCPHDISP(phdisp,1),"^",2)
    ...s:fyuserdr'="" fyuser=$p(^DHCPHPER(fyuserdr),"^",2)
    ...s pyuserdr=$p(^DHCPHDISP(phdisp,1),"^",3)
    ...s:pyuserdr'="" pyuser=$p(^DHCPHPER(pyuserdr),"^",2)
    ..s gen=##class(web.DHCSTCOMMONSRV).getGeneric(inci) ;gennum 通用名数
    ..i gen'="" s gennum=gennum+1
    ..//s poisonstr=##class(web.DHCSTCOMMONSRV).getPoisonByInci(inci)
    ..//s poison=$p(poisonstr,"^",3)
    ..s kjflag=##class(web.DHCSTCNTSMAIN).GetAntibioticFlag(oeori)
    ..i kjflag=1 s kjnum=kjnum+1
    ..s instdr=$p(^OEORD(ord,"I",chl,2),"^",7)
    ..i ##class(web.DHCSTCNTSCOMMON).GetZSDrugFlagByOrd(oeori)=1 s zsnum=zsnum+1
    ..s info=$o(^DHCITMINFO(0,"INCI",inci,""))
    ..s phcdfId=$p(^ARCIM(+arcitm,$p(arcitm,"||",2),1),"^",12)
    ..i phcdfId'="" d
    ...s bflag=$p(^PHCD(+phcdfId,"DF",+$p(phcdfId,"||",2),"DHC"),"^",31)
    ...i bflag="Y" s bnum=bnum+1
    s:amt'=0 amt=$Fn(amt,"",2)
    s data=h_"^"_$G(amt)_"^"_$g(pyuser)_"^"_$g(fyuser)_"^"_$g(zsnum)_"^"_$g(kjnum)_"^"_$g(bnum)_"^"_$g(gennum)
	q data
}

/// 查询处方点评单,按原因各科室汇总
ClassMethod QueryCommontByRea(QueryStr) As %String
{
	
	s pid=##class(web.DHCSTCNTSMAIN).GetPHCNTSPID()
	s qstdate=$p(QueryStr,"^",1)
	s qenddate=$p(QueryStr,"^",2)
	s:qstdate'="" qstdate=##class(websys.Conversions).DateHtmlToLogical(qstdate)
   	s:qenddate'="" qenddate=##class(websys.Conversions).DateHtmlToLogical(qenddate)
	s qdoclocdr=$p(QueryStr,"^",3)
	s qinci=$p(QueryStr,"^",4)
	s qresult=$p(QueryStr,"^",5)
	s qcomnostr=$p(QueryStr,"^",6) //单号串
	s qwaydr=$p(QueryStr,"^",7) 
	i qwaydr="" s qwaydr="3"
	s pcntstype="F"
	s tmpstr=qinci
	
	s reanum=0  //问题数
	s prenum=0  //处方数
	s h=0
	f date=qstdate:1:qenddate d
	.s typecnt=$l(pcntstype,"^")
	.f i=1:1:typecnt d
	..s type=$p(pcntstype,"^",i)
	..s pcnts=""
	..f  s pcnts=$o(^DHCPHCNTS(0,"Date",date,type,pcnts)) q:pcnts=""  d
	...s pcntsno=$p(^DHCPHCNTS(pcnts),"^",1)
	...q:(qcomnostr'="")&(..CheckComNo(qcomnostr,pcntsno)=0)
	...s pcntsdate=$p(^DHCPHCNTS(pcnts),"^",2)
	...i pcntsdate'="" s pcntsdate=##class(websys.Conversions).DateLogicalToHtml(pcntsdate)
	...s pcntstime=$p(^DHCPHCNTS(pcnts),"^",3)
	...i pcntstime'="" s pcntstime=##class(websys.Conversions).TimeLogicalToHtml(pcntstime)
	...s pcntstext=$p(^DHCPHCNTS(pcnts),"^",4)
	...s pcntsuserdr=$p(^DHCPHCNTS(pcnts),"^",6)
	...s pcntsuser=$p(^SSU("SSUSR",pcntsuserdr),"^",2)
	...i type="F" s typedesc="门诊"
	...i type="P" s typedesc="住院"
	...s chl=""
	...f  s chl=$o(^DHCPHCNTS(pcnts,"I",chl)) q:chl=""  d
	....s prescno=$p(^DHCPHCNTS(pcnts,"I",chl),"^",1)
	....s orditem=$p(^DHCPHCNTS(pcnts,"I",chl),"^",2)
	....s ord=$p(orditem,"||",1)
	....s itm=$p(orditem,"||",2)
	....q:'$d(^OEORD(ord,"I",itm,1))
	....s adm=$p(^DHCPHCNTS(pcnts,"I",chl),"^",3)
	....s papmi=$p(^PAADM(adm),"^",1)
	....s patname=$p(^PAPER(papmi,"ALL"),"^", 1) ;患者姓名
	....s patsex=$p(^PAPER(papmi,"ALL"),"^",7 ) ;姓别
	....s patno=$p(^PAPER(papmi,"PAT",1),"^",1)
	....s patage=##class(web.DHCSTKUTIL).GetAge(papmi)  ;年龄   
    ....s diag=..GetMRDiagnosDesc(adm,",") ;诊断
    ....i $f(diag,$c(13)) s diag=$p(diag,$c(13),1)
	....s doclocdr=$p(^DHCPHCNTS(pcnts,"I",chl),"^",4)
    ....s orddept=$p(^CTLOC(doclocdr),"^",2)  
    ....q:..ChkDocLocStr(qdoclocdr,doclocdr)=0 ;科室
    ....//q:..ChkItmByPrescNo(prescno,qinci)=0 ;药品
    ....s chkstr=..ChkItmByPrescNo(prescno,tmpstr) ;检查项目
	....s chkflag=$p(chkstr,"^",1)
	....q:chkflag=0  //检查包含项目是否符合
	....s curret=$p(^DHCPHCNTS(pcnts,"I",chl),"^",6) ;结果
	....q:(qresult=1)&(curret'="Y")
	....q:(qresult=2)&(curret'="N")
	....q:(qresult=4)&(curret="") //仅有结果
	....i $f(orddept,"-") s orddept=$p(orddept,"-",2)
	....s docdr=$p(^DHCPHCNTS(pcnts,"I",chl),"^",5)
	....s doctor=$p(^SSU("SSUSR",docdr),"^",2)  ;医生
	....s curret=$p(^DHCPHCNTS(pcnts,"I",chl),"^",6) ;结果
	....;全院处方总数
	....s prenum=prenum+1  
	....;各科室全部点评处方总数
	....s ^TMP("dhcpha","DHCSTCNTSQUERY","QueryCommontByRea",pid,"docpresc",doclocdr)=+$g(^TMP("dhcpha","DHCSTCNTSQUERY","QueryCommontByRea",pid,"docpresc",doclocdr))+1
	....q:curret'="N"
	....;各科室不合理处方总数
	....s ^TMP("dhcpha","DHCSTCNTSQUERY","QueryCommontByRea",pid,"docprescbed",doclocdr)=+$g(^TMP("dhcpha","DHCSTCNTSQUERY","QueryCommontByRea",pid,"docprescbed",doclocdr))+1
	....s sub=""
	....f  s sub=$o(^DHCPHCNTS(pcnts,"I",chl,"L",sub)) q:sub=""  d
	.....s active=$p(^DHCPHCNTS(pcnts,"I",chl,"L",sub),"^",11)
	.....q:active'="Y"
	.....s reasondr=$p(^DHCPHCNTS(pcnts,"I",chl,"L",sub),"^",1)
	.....s reasonlevel=..QueryReaFirstLevel(reasondr)
	.....
	.....;各科室各级原因处方数
	.....i '$D(^TMP("dhcpha","DHCSTCNTSQUERY","QueryCommontByRea",pid,"doclevel","prescno",prescno)) D
	......s ^TMP("dhcpha","DHCSTCNTSQUERY","QueryCommontByRea",pid,"doclevelpnum",doclocdr,reasonlevel)=+$g(^TMP("dhcpha","DHCSTCNTSQUERY","QueryCommontByRea",pid,"doclevelpnum",doclocdr,reasonlevel))+1
	......;各科室各级原因数
	......s ^TMP("dhcpha","DHCSTCNTSQUERY","QueryCommontByRea",pid,"doclevel",doclocdr,reasonlevel)=+$g(^TMP("dhcpha","DHCSTCNTSQUERY","QueryCommontByRea",pid,"doclevel",doclocdr,reasonlevel))+1
	......;各科室原因总数
	......s ^TMP("dhcpha","DHCSTCNTSQUERY","QueryCommontByRea",pid,"docrea",doclocdr)=+$g(^TMP("dhcpha","DHCSTCNTSQUERY","QueryCommontByRea",pid,"docrea",doclocdr))+1
	.....s ^TMP("dhcpha","DHCSTCNTSQUERY","QueryCommontByRea",pid,"doclevel","prescno",prescno)="" 
	//
	s i=0
	s doclocdr=""
	f  s doclocdr=$o(^TMP("dhcpha","DHCSTCNTSQUERY","QueryCommontByRea",pid,"docpresc",doclocdr)) q:doclocdr=""  d
	.s docloc=$p(^CTLOC(doclocdr),"^",2)
	.i $f(docloc,"-") s docloc=$p(docloc,"-",2)
	.s reanum=+$g(^TMP("dhcpha","DHCSTCNTSQUERY","QueryCommontByRea",pid,"docrea",doclocdr))
	.s locstring=""
	.s level=""
    .f  s level=$o(^DHCPCREASON(0,"Level",qwaydr,0,level)) q:level=""  d
	..s levelnum=0
	..s levelnum=+$g(^TMP("dhcpha","DHCSTCNTSQUERY","QueryCommontByRea",pid,"doclevel",doclocdr,level))
	..s levelcent=0
	..s:reanum'=0 levelcent=($Fn(levelnum/reanum,"",2)*100)
	..i levelcent'=0 s levelcent=levelcent
	..s tmpstr=levelnum_"^"_levelcent  //问题数_"^"_问题比
	..s levelpcent=0
	..s levelpnum=+$g(^TMP("dhcpha","DHCSTCNTSQUERY","QueryCommontByRea",pid,"doclevelpnum",doclocdr,level))
	..s locprenum=+$g(^TMP("dhcpha","DHCSTCNTSQUERY","QueryCommontByRea",pid,"docpresc",doclocdr))
	..i locprenum'=0 s levelpcent=($Fn(levelpnum/locprenum,"",2)*100)
	..s tmpstr=tmpstr_"^"_levelpnum_"^"_levelpcent  //处方数_"^"_处方比
	..i locstring="" d
	...s locstring=docloc_"^"_doclocdr_"^"_tmpstr
	..e  d
	...s locstring=locstring_"^"_tmpstr
	.s locprebednum=+$g(^TMP("dhcpha","DHCSTCNTSQUERY","QueryCommontByRea",pid,"docprescbed",doclocdr))
	.s locprenum=+$g(^TMP("dhcpha","DHCSTCNTSQUERY","QueryCommontByRea",pid,"docpresc",doclocdr))
	.s locbedcent=0
	.s:locprenum'=0 locbedcent=($Fn(locprebednum/locprenum,"",2)*100)
	.i locbedcent'=0 s locbedcent=locbedcent
	.s locstring=locstring_"^"_reanum_"^"_locprebednum_"^"_locprenum_"^"_locbedcent
	.s i=i+1
	.s ^TMP("dhcpha","DHCSTCNTSQUERY","QueryCommontByRea",pid,"locstring",i)=locstring
	.
	q:i=0 ##class(web.DHCSTEXTCOMMON).GetNoJson()

	s totalreason1=0   //原因1汇总数
	s totalreason2=0
	s totalreason3=0
	s totalreapresc1=0
	s totalreapresc2=0
	s totalreapresc3=0
	s totalreson=0
	s totalreapresc=0
	s totalbedpnum=0
	
    s maxrow=i
    s count=0
    s i=""
    f  s i=$o(^TMP("dhcpha","DHCSTCNTSQUERY","QueryCommontByRea",pid,"locstring",i)) q:i=""  d
    .s data=^TMP("dhcpha","DHCSTCNTSQUERY","QueryCommontByRea",pid,"locstring",i)
    .s ^TMP("dhcpha","DHCSTCNTSQUERY","QueryCommontByRea","Export",pid,i)=data
    .s locdesc=$p(data,"^",1)
    .s locrowid=$p(data,"^",2)
    .s reason1=$p(data,"^",3)
    .s centprescn1=$p(data,"^",4)
    .s locrepnum1=$p(data,"^",5)
    .s locrepcent1=$p(data,"^",6)
    .s reason2=$p(data,"^",7)
    .s centprescn2=$p(data,"^",8)
    .s locrepnum2=$p(data,"^",9)
    .s locrepcent2=$p(data,"^",10)
    .s reason3=$p(data,"^",11)
    .s centprescn3=$p(data,"^",12)
    .s locrepnum3=$p(data,"^",13)
    .s locrepcent3=$p(data,"^",14)
    .s locreanum=$p(data,"^",15)
    .s locbedprescnum=$p(data,"^",16)
    .s locallprescnum=$p(data,"^",17)
    .s loccentprescnum=$p(data,"^",18)
    .
    .s totalreason1=totalreason1+reason1
	.s totalreason2=totalreason2+reason2
	.s totalreason3=totalreason3+reason3
	.s totalreapresc1=totalreapresc1+locrepnum1
	.s totalreapresc2=totalreapresc2+locrepnum2
	.s totalreapresc3=totalreapresc3+locrepnum3
	.s totalreson=totalreson+locreanum
	.s totalreapresc=totalreapresc+locallprescnum
	.s totalbedpnum=totalbedpnum+locbedprescnum
    .
    .s locdesc=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("locdesc",locdesc)
    .s locrowid=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("locrowid",locrowid)
    .s reason1=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("reason1",reason1)
	.s centprescn1=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("centprescn1",centprescn1)
	.s locrepnum1=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("locrepnum1",locrepnum1)
	.s locrepcent1=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("locrepcent1",locrepcent1)
	.s reason2=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("reason2",reason2)
	.s centprescn2=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("centprescn2",centprescn2)
	.s locrepnum2=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("locrepnum2",locrepnum2)
	.s locrepcent2=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("locrepcent2",locrepcent2)
	.s reason3=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("reason3",reason3)
	.s centprescn3=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("centprescn3",centprescn3)
	.s locrepnum3=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("locrepnum3",locrepnum3)
	.s locrepcent3=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("locrepcent3",locrepcent3)
	.s locreanum=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("locreanum",locreanum)
	.s locbedprescnum=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("locbedprescnum",locbedprescnum)
	.s locallprescnum=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("locallprescnum",locallprescnum)
	.s loccentprescnum=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("loccentprescnum",loccentprescnum)
	.s piddesc=##class(web.DHCSTEXTCOMMON).GetJsonLastCell("pid",pid)
	.
	.s tmpstr=locdesc_locrowid_reason1_centprescn1_locrepnum1_locrepcent1_reason2_centprescn2_locrepnum2_locrepcent2_reason3_centprescn3_locrepnum3_locrepcent3
	.s tmpstr=tmpstr_locreanum_locbedprescnum_locallprescnum_loccentprescnum_piddesc
	.
    .s startString=##class(web.DHCSTEXTCOMMON).GetJsonStartString(maxrow)
    .s firstrow=##class(web.DHCSTEXTCOMMON).GetJsonFirstRow(tmpstr)
    .s lastrow=##class(web.DHCSTEXTCOMMON).GetJsonLastRow(tmpstr)
	.s count=count+1
	.i count=1 w startString
    .;i count<maxrow w firstrow
    .;i count=maxrow w lastrow
    .w firstrow 
    
    
    
    //总计
    
    
    s locdesc="总计"
    s locrowid=""
    s reason1=totalreason1
    s centprescn1=0
    s:$l(totalreson)>2 centprescn1=($Fn(totalreason1/totalreson,"",2))*100
    s locrepnum1=totalreapresc1
    s locrepcent1=0
    s:$l(totalreapresc)>2 locrepcent1=($Fn(totalreapresc1/totalreapresc,"",2))*100
    s reason2=totalreason2
    s centprescn2=0
    s:$l(totalreson)>2 centprescn2=($Fn(totalreason2/totalreson,"",2))*100
    s locrepnum2=totalreapresc2
    s locrepcent2=0
    s:$l(totalreapresc)>2 locrepcent2=($Fn(totalreapresc2/totalreapresc,"",2))*100
    s reason3=totalreason3
    s centprescn3=0
    s:$l(totalreson)>2 centprescn3=($Fn(totalreason3/totalreson,"",2))*100
    s locrepnum3=totalreapresc3
    s locrepcent3=0
    s:$l(totalreapresc)>2 locrepcent3=($Fn(totalreapresc3/totalreapresc,"",2))*100
    s locreanum=totalreson
    s locbedprescnum=totalbedpnum
    s locallprescnum=totalreapresc
    s loccentprescnum=""

    s locdesc=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("locdesc",locdesc)
    s locrowid=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("locrowid",locrowid)
    s reason1=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("reason1",reason1)
	s centprescn1=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("centprescn1",centprescn1)
	s locrepnum1=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("locrepnum1",locrepnum1)
	s locrepcent1=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("locrepcent1",locrepcent1)
	s reason2=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("reason2",reason2)
	s centprescn2=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("centprescn2",centprescn2)
	s locrepnum2=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("locrepnum2",locrepnum2)
	s locrepcent2=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("locrepcent2",locrepcent2)
	s reason3=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("reason3",reason3)
	s centprescn3=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("centprescn3",centprescn3)
	s locrepnum3=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("locrepnum3",locrepnum3)
	s locrepcent3=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("locrepcent3",locrepcent3)
	s locreanum=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("locreanum",locreanum)
	s locbedprescnum=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("locbedprescnum",locbedprescnum)
	s locallprescnum=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("locallprescnum",locallprescnum)
	s loccentprescnum=##class(web.DHCSTEXTCOMMON).GetJsonLastCell("loccentprescnum",loccentprescnum)

	s tmpstr=locdesc_locrowid_reason1_centprescn1_locrepnum1_locrepcent1_reason2_centprescn2_locrepnum2_locrepcent2_reason3_centprescn3_locrepnum3_locrepcent3
	s tmpstr=tmpstr_locreanum_locbedprescnum_locallprescnum_loccentprescnum
	s lastrow=##class(web.DHCSTEXTCOMMON).GetJsonLastRow(tmpstr)
	w lastrow
    
    
    k ^TMP("dhcpha","DHCSTCNTSQUERY","QueryCommontByRea",pid)
    
	
    q ""
}

/// 查询处方点评单,按处方汇总+明细
ClassMethod QueryCommontTotalItm(QueryStr, StartPage, Limit) As %String
{
	q:QueryStr="" ##class(web.DHCSTEXTCOMMON).GetNoJson()
	s pid=##class(web.DHCSTCNTSMAIN).GetPHCNTSPID()
	s endpage=StartPage+Limit  //结束行
	s stpage=StartPage+1 //开始行
	s qstdate=$p(QueryStr,"^",1)
	s qenddate=$p(QueryStr,"^",2)
	s:qstdate'="" qstdate=##class(websys.Conversions).DateHtmlToLogical(qstdate)
   	s:qenddate'="" qenddate=##class(websys.Conversions).DateHtmlToLogical(qenddate)
	s qdoclocdr=$p(QueryStr,"^",3)
	s qinci=$p(QueryStr,"^",4)
	s qresult=$p(QueryStr,"^",5)
	s qcomnostr=$p(QueryStr,"^",6) //单号串
	s pcntstype="F"
	s x=0
	s h=0
	f date=qstdate:1:qenddate d
	.s typecnt=$l(pcntstype,"^")
	.f i=1:1:typecnt d
	..s type=$p(pcntstype,"^",i)
	..s pcnts=""
	..f  s pcnts=$o(^DHCPHCNTS(0,"Date",date,type,pcnts)) q:pcnts=""  d
	...s pcntsno=$p(^DHCPHCNTS(pcnts),"^",1)
	...q:(qcomnostr'="")&(..CheckComNo(qcomnostr,pcntsno)=0)
	...s pcntsdate=$p(^DHCPHCNTS(pcnts),"^",2)
	...i pcntsdate'="" s pcntsdate=##class(websys.Conversions).DateLogicalToHtml(pcntsdate)
	...s pcntstime=$p(^DHCPHCNTS(pcnts),"^",3)
	...i pcntstime'="" s pcntstime=##class(websys.Conversions).TimeLogicalToHtml(pcntstime)
	...s pcntstext=$p(^DHCPHCNTS(pcnts),"^",4)
	...s pcntsuserdr=$p(^DHCPHCNTS(pcnts),"^",6)
	...s pcntsuser=$p(^SSU("SSUSR",pcntsuserdr),"^",2)
	...i type="F" s typedesc="门诊"
	...i type="P" s typedesc="住院"
	...s chl=""
	...f  s chl=$o(^DHCPHCNTS(pcnts,"I",chl)) q:chl=""  d
	....s pcntsitm=pcnts_"||"_chl
	....s prescno=$p(^DHCPHCNTS(pcnts,"I",chl),"^",1)
	....s orditem=$p(^DHCPHCNTS(pcnts,"I",chl),"^",2)
	....s ord=$p(orditem,"||",1)
	....s itm=$p(orditem,"||",2)
	....s adm=$p(^DHCPHCNTS(pcnts,"I",chl),"^",3)
	....s papmi=$p(^PAADM(adm),"^",1)
	....s patname=$p(^PAPER(papmi,"ALL"),"^", 1) ;患者姓名
	....s sex=$p(^PAPER(papmi,"ALL"),"^",7 ) ;姓别
	....s patsex=$p(^CT("SEX",sex),"^",2)
	....s patno=$p(^PAPER(papmi,"PAT",1),"^",1)
	....s patage=##class(web.DHCSTKUTIL).GetAge(papmi)  ;年龄   
    ....s diag=..GetMRDiagnosDesc(adm,",") ;诊断
    ....i $f(diag,$c(13)) s diag=$p(diag,$c(13),1)
	....s doclocdr=$p(^DHCPHCNTS(pcnts,"I",chl),"^",4)
    ....s orddept=$p(^CTLOC(doclocdr),"^",2)  
    ....q:..ChkDocLocStr(qdoclocdr,doclocdr)=0 ;科室
	....i $f(orddept,"-") s orddept=$p(orddept,"-",2)
	....s docdr=$p(^DHCPHCNTS(pcnts,"I",chl),"^",5)
	....s doctor=$p(^SSU("SSUSR",docdr),"^",2)  ;医生
	....s curret=$p(^DHCPHCNTS(pcnts,"I",chl),"^",6) ;结果
	....q:(qresult=1)&(curret'="Y")
	....q:(qresult=2)&(curret'="N")
	....i curret="Y" s curret="合理"
	....i curret="N" s curret="不合理"
	....q:..ChkItmByPrescNo(prescno,qinci)=0 ;药品
	....s reasoninfo=..GetCommentRea(orditem,pcntsitm) //不合理原因
	....s reacode=$p(reasoninfo,"^",1)
	....s reason=$p(reasoninfo,"^",2)
	....s phadvice=$p(reasoninfo,"^",3)
	....s phnote=$p(reasoninfo,"^",4)
	....s y=0 //一个处方的开始
	....s x=x+1
	....s colorflag=0
	....i x#2=1 s colorflag=1
	....s ord=""
	....f  s ord=$o(^OEORD(0,"PrescNo",prescno,ord))  q:ord=""  d
	.....s itm=""
    .....f  s itm=$o(^OEORD(0,"PrescNo",prescno,ord,itm)) q:itm=""  d
    ......s arcitm=$p(^OEORD(ord,"I",itm,1),"^",2)
    ......s inci=$o(^INCI(0,"ARCIM_DR",$p(arcitm,"||",1),""))
    ......s orditm=ord_"||"_itm
    ......//药品
	......s arcimid=$p(^OEORD(ord,"I",itm,1),"^",2)  ;医嘱 ARC_ItmMast ARCIM_RowId
	......s itmmastid=$p(arcimid,"||",1)
	......s itmmastver=$p(arcimid,"||",2)
	......s inci=$o(^INCI(0,"ARCIM_DR",$p(arcimid,"||",1),"") ) q:inci=""  //医嘱名称
	......s incidesc=$p(^INCI(inci,1),"^",2) //药品名称
	......s dsp=$o(^DHCOEDISQTY(0,"OEORI",orditm,""))
	......q:dsp=""
    ......s qty=$p(^DHCOEDISQTY(dsp),"^",2)
    ......s findflag=1
	......s:findflag=1 puomdr=$p(^ARCIM(itmmastid,itmmastver,8),"^",14)
	......s:findflag=2 puomdr=+$p(^INCI(inci,3),"^",6)
	......s buomdr=+$p(^INCI(inci,1),"^",10)
	......s fac=+##Class(web.DHCSTCOMMONSRV).UOMFac(puomdr,buomdr)
	......s uomdr=buomdr
	......i (qty#fac)=0 d
	.......s qty=qty/fac   //数量
	......s uomdr=puomdr 
	......s uomdesc=$p($g(^CT("UOM",uomdr)),"^",2) //单位
	......s dosage=$j($p(^OEORD(ord,"I",itm,2),"^",1)," ",3) ;剂量
    ......s doseuom=""
	......s dosuomID=$p(^OEORD(ord,"I",itm,2),"^",3)
	......i dosuomID'="" d
	.......s doseuom=$p($g(^CT("UOM",dosuomID)),"^",2) ;剂量单位
	......s dosage=dosage_doseuom
	......s freq=""
	......s freqdr=$p($g(^OEORD(ord,"I",itm,2)),"^",4) ;OEORI_PHFreq_DR
    ......i freqdr'="" s freq=$p($g(^PHCFR(freqdr)),"^",3)  ;频率
    ......s instru=$p(^PHCIN($p(^OEORD(ord,"I",itm,2),"^",7)),"^",2)        	;用法
	......s duration=$p(^PHCDU($p(^OEORD(ord,"I",itm,2),"^",6)),"^",1)         	;用药疗程
	......s skintest=##class(web.DHCSTCOMMONSRV).GetSkinTestResult(orditm)  ;皮试
	......s incidesc=skintest_incidesc
	......s remark=##class(web.DHCSTCOMMONSRV).GetOrdItmRemark(orditm) ;备注
	......s retdata=..GetPrescNoInfo(prescno)
	......s num=$p(retdata,"^",1)  //处方品种数
	......s bnum=$p(retdata,"^",7) //基本药物
	......s zsnum=$p(retdata,"^",5) //注射剂数
    ......i zsnum>0 s zsjflag=1
    ......e  s zsjflag=0
    ......s totalamt=$p(retdata,"^",2)
    ......s generic=##class(web.DHCSTCOMMONSRV).getGeneric(inci) //通用名
    ......s spec=##class(web.DHCSTCOMMONSRV).getBarcode(inci) ;规格
	......s dspdate=$p(^DHCOEDISQTY(dsp),"^",15)
    ......s ctlocdr=$p(^OEORD(ord,"I",itm,3),"^",6)
	......s HospString=##class(web.DHCSTCOMMONSRV).GetLocHosp(ctlocdr)
    ......s hospdr=$p(HospString,"^",1)
    ......//s spice=##class(web.DHCSTCOMMONSRV).GetPriceElse(+inci,+dspdate,"",hospdr)
    ......s exStr="^"_dsp
    ......s spice=##class(web.DHCSTPRICE).GetSp(+inci,+dspdate,"",hospdr,"",exStr)	//zhouyg 20150113
    ......s amt=$Fn(spice*qty,"",2)  //药品金额
	......s h=h+1
	......s y=y+1
    ......;i y'=1 s curret="",reason="",phadvice="",phnote=""
    ......s data=patage_"^"_diag_"^"_num_"^"_bnum_"^"_zsjflag_"^"_generic_"^"_spec_"^"_qty_"^"_amt_"^"_dosage
    ......s data=data_"^"_instru_"^"_totalamt_"^"_prescno_"^"_colorflag
    ......s ^TMP("dhcpha","DHCSTCNTSQUERY","QueryCommontTotalItm",pid,h)=data
	
	q:h=0 ##class(web.DHCSTEXTCOMMON).GetNoJson()
	
    s maxrow=h
    i endpage>maxrow s endpage=maxrow
    s count=0
    s h=""
    f  s h=$o(^TMP("dhcpha","DHCSTCNTSQUERY","QueryCommontTotalItm",pid,h)) q:h=""  d
    .s data=^TMP("dhcpha","DHCSTCNTSQUERY","QueryCommontTotalItm",pid,h)
    .s patage=$p(data,"^",1)
    .s diag=$p(data,"^",2)
    .s num=$p(data,"^",3)
    .s bnum=$p(data,"^",4)
    .s zsjflag=$p(data,"^",5)
    .s generic=$p(data,"^",6)
    .s spec=$p(data,"^",7)
    .s qty=$p(data,"^",8)
    .s amt=$p(data,"^",9)
    .s dosage=$p(data,"^",10)
    .s instru=$p(data,"^",11)
    .s totalamt=$p(data,"^",12)
    .s prescno=$p(data,"^",13)
    .s colorflag=$p(data,"^",14)
    .
    .s count=count+1
    .q:count<stpage
    .q:count>endpage
    .
    .s patage=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("patage",patage)
	.s diag=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("diag",diag)
	.s num=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("num",num)
	.s bnum=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("bnum",bnum)
	.s zsjflag=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("zsjflag",zsjflag)
	.s generic=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("generic",generic)
	.s spec=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("spec",spec)
	.s qty=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("qty",qty)
	.s amt=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("amt",amt)
	.s dosage=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("dosage",dosage)
	.s instru=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("instru",instru)
	.s totalamt=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("totalamt",totalamt)
	.s prescno=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("prescno",prescno)
	.s colorflag=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("colorflag",colorflag)
	.s pidnum=##class(web.DHCSTEXTCOMMON).GetJsonLastCell("pidnum",pid)
	.
	.s tmpstr=patage_diag_num_bnum_zsjflag_generic_spec_qty_amt_dosage_instru
	.s tmpstr=tmpstr_totalamt_prescno_colorflag_pidnum
	.
    .s startString=##class(web.DHCSTEXTCOMMON).GetJsonStartString(maxrow)
    .s firstrow=##class(web.DHCSTEXTCOMMON).GetJsonFirstRow(tmpstr)
    .s lastrow=##class(web.DHCSTEXTCOMMON).GetJsonLastRow(tmpstr)
    .
    .i count=stpage w startString
    .i count<endpage w firstrow
    .i count=endpage w lastrow
    
    
    //k ^TMP("dhcpha","DHCSTCNTSQUERY","QueryCommontTotalItm",pid)
    
	
    q ""
}

/// 获取普通处方点评方式的id
ClassMethod GetPWayId() As %String
{
	s ret=""
	s wayid="0"
	f  s wayid=$o(^DHCPCWAY(wayid)) q:wayid=""  d
	.s waycode=$p(^DHCPCWAY(wayid),"^",1)
	.q:waycode'="P"
	.s ret=wayid
	.
	q ret
}

/// 取最顶级原因ID(普通处方)
ClassMethod QueryReaFirstLevel(reasondr) As %String
{
   
    
	s ret=""
	s level=""
	f h=1:1:1000 q:level=0  d
	.s level=$p(^DHCPCREASON(reasondr),"^",3)
	.i level=0 s ret=reasondr
	.s reasondr=level
	q ret
}

/// 过滤医生科室
/// Input: 医生科室串(间隔符 ","), 科室ID 
/// Output:1 - 成功 0 失败
ClassMethod ChkDocLocStr(locstr, locdr) As %String
{
	q:locstr="" 1
	s exit=0
	s cnt=$l(locstr,",")
	f i=1:1:cnt q:exit=1  d
	.s tmplocdr=$p(locstr,",",i)
	.i tmplocdr=locdr d
	..s exit=1
	.
	q exit
}

/// 获取医嘱原因
/// Input: 医嘱ID , 点评子表id
/// Output:点评不合理原因(间隔符 ,)
ClassMethod GetCommentRea(orditm, pcntsitm = "") As %String
{
	s reacodestr="",reastr="",advice="",phnote=""
	s h=0
	s main=""
	f  s main=$o(^DHCPHCNTS(0,"OrdItem",orditm, main)) q:main=""  d
	.q:(pcntsitm'="")&&(+pcntsitm'=main)
	.s itm=""
	.f  s itm=$o(^DHCPHCNTS(0,"OrdItem",orditm,main,itm)) q:itm=""  d
	..s currret=$p(^DHCPHCNTS(main,"I",itm),"^",6)
	..q:currret'="N"
	..s sub=""
	..f  s sub=$o(^DHCPHCNTS(main,"I",itm,"L",sub)) q:sub=""  d
	...s active=$p(^DHCPHCNTS(main,"I",itm,"L",sub),"^",11)
	...q:active'="Y"
	...s h=h+1
	...s reacode=""
	...s reasondr=$p(^DHCPHCNTS(main,"I",itm,"L",sub),"^",1)
	...s:reasondr'="" reacode=$p(^DHCPCREASON(reasondr) ,"^",1)
	...s logdr=main_"||"_itm_"||"_sub
	...s logdrugstr=""
	...s pctr=""
	...f  s pctr=$o(^DHCPCTABL(0,"LOG",logdr,pctr)) q:pctr=""  d 
	....s oeori=$p(^DHCPCTABL(pctr),"^",1)
	....s ord=$p(oeori,"||",1)
	....s chl=$p(oeori,"||",2)
	....s arcitm=$p(^OEORD(ord,"I",chl,1),"^",2)
    ....s inci=$o(^INCI(0,"ARCIM_DR",$p(arcitm,"||",1),""))
    ....s incidesc=$p(^INCI(inci,1),"^",2) //药品名称
    ....i logdrugstr="" d
    .....s logdrugstr=incidesc
    ....e  d
    .....s logdrugstr=logdrugstr_", "_incidesc
    ...;s:logdrugstr'="" reacode=h_"."_reacode_":"_logdrugstr
    ...i reacode'="" d
	....i reacodestr="" d
	.....s reacodestr=reacode
	....e  d
	.....s reacodestr=reacodestr_","_reacode
	...s reason=""
	...s:reacode'="" reason=$p(^DHCPCREASON(reasondr) ,"^",2)
	...s:logdrugstr'="" reason=h_"."_reason  //_"："_logdrugstr
	...i reason'="" d
	....i reastr="" d
	.....s reastr=reason
	....e  d
	.....s reastr=reastr_","_reason
	...s advice=""
	...s advicedr=$p(^DHCPHCNTS(main,"I",itm,"L",sub),"^",6)
	...i advicedr'="" s advice=$p($g(^DHCPCADVICE(advicedr)),"^",2)
	...s phnote=$p(^DHCPHCNTS(main,"I",itm,"L",sub),"^",9)
	q reacodestr_"^"_reastr_"^"_advice_"^"_phnote
}

/// 过滤处方是否含某药
/// Input: 医嘱处方号,药品ID
/// Output: 1 成功 0  失败
ClassMethod ChkItmByPrescNo(prescno, str) As %String
{
	s HospID=""
	s qinci=$p(str,"^",1)
	s sumamt=0 //处方总额
	s sumantnum=0,sumantamt=0 //抗菌药总额
	s sumbasnum=0,sumbasamt=0 //基本药总额
	s chkflag=1
	i qinci'="" s chkflag=0
	s ord=""
	f  s ord=$o(^OEORD(0,"PrescNo",prescno,ord))  q:ord=""  d
	.s itm=""
    .f  s itm=$o(^OEORD(0,"PrescNo",prescno,ord,itm)) q:itm=""  d
    ..s oeori=ord_"||"_itm
	..s RecLocID=$p(^OEORD(ord,"I",itm,3),"^",6)
	..i (RecLocID'="")&(HospID="") s HospID=$p($g(^CTLOC(RecLocID)),"^",22)
	..s arcimid=$p(^OEORD(ord,"I",itm,1),"^",2) 
	..s itmmastid=$p(arcimid,"||",1)
	..s itmmastver=$p(arcimid,"||",2)
	..s inci=$o(^INCI(0,"ARCIM_DR",$p(arcimid,"||",1),"")) q:inci=""
	..s puomdr=$p(^ARCIM(itmmastid,itmmastver,8),"^",14)
	..s dspdate=+$h
	..s dsp=$o(^DHCOEDISQTY(0,"OEORI",oeori,""))
	..q:dsp="" 
	..i (qinci=inci)&(qinci'="") d
	...s chkflag=1
	..s status=$p(^DHCOEDISQTY(dsp),"^",7)
	..i status="C" s dspdate=$p(^DHCOEDISQTY(dsp),"^",8)
	..//s price=##class(web.DHCSTCOMMONSRV).GetPriceElse(+inci,dspdate,puomdr,"")
	..s exStr="^"_dsp
	..s price=##class(web.DHCSTPRICE).GetSp(+inci,dspdate,puomdr,HospID,"",exStr)	//zhouyg 20150113
    ..s qty=$p(^DHCOEDISQTY(dsp),"^",2)
    ..s qty=##class(web.DHCSTCNTSMAIN).getPackQty(inci,qty,puomdr)
	..s amt=$fn(price*qty,"",2)
	..s sumamt=sumamt+amt 
	..s ant=##class(web.DHCSTCNTSMAIN).GetAntibioticFlag(oeori,oeori)
	..i ant=1 d
	...s sumantnum=sumantnum+1
	...s sumantamt=sumantamt+amt
	..s infor=$o(^DHCITMINFO(0,"INCI",inci,""))
	..s basflag=""
	..s phcdfId=$p(^ARCIM(itmmastid,itmmastver,1),"^",12)
	..s:phcdfId'="" basflag=$p(^PHCD(+phcdfId,"DF",+$p(phcdfId,"||",2),"DHC"),"^",31)
	..i $g(basflag)="Y" d
	...s sumbasnum=sumbasnum+1
	...s sumbasamt=sumbasamt+amt
	s antamtcent=0,basamtcent=0
	s:(sumamt'=0)&(sumantamt'=0) antamtcent=$fn((sumantamt/sumamt)*100,"",2)_"%"  //抗菌药金额百比
	s:(sumamt'=0)&(sumbasamt'=0) basamtcent=$fn((sumbasamt/sumamt)*100,"",2)_"%"  //基本药金额百比
	q chkflag_"^"_sumamt_"^"_sumantamt_"^"_antamtcent_"^"_sumbasamt_"^"_basamtcent
}

ClassMethod GetAudltImtCnt(pid) As %String
{
	s cnt=$o(^TMP("dhcpha","DHCSTCNTSQUERY","QueryCommontTotalItm",pid,""),-1)
	q cnt
}

ClassMethod ListAudltImt(pid) As %String
{
	s i=""
	f  s i=$o(^TMP("dhcpha","DHCSTCNTSQUERY","QueryCommontTotalItm",pid,i)) q:i=""  d
	.s str=^TMP("dhcpha","DHCSTCNTSQUERY","QueryCommontTotalItm",pid,i)
	.s linkStr="@" 
	.s str=str_linkStr
	.w str
	q ""
}

ClassMethod KillQueryData(pid) As %String
{
	k ^TMP("dhcpha","DHCSTCNTSQUERY","QueryCommontItm","Export",pid)
	k ^TMP("dhcpha","DHCSTCNTSQUERY","QueryCommontPrescNo","Export",pid)
	k ^TMP("dhcpha","DHCSTCNTSQUERY","QueryCommontByRea","Export",pid)
	q 0
}

/// 检查用法是否一致  0 假  1真
/// 根据剂型or用法两种判断
ClassMethod CheckInst(instdr, oeori = "") As %String
{
	i $g(oeori)'="" d
	.s ord=$p(oeori,"||",1)
	.s itm=$p(oeori,"||",2)
	.s arcimid=$p(^OEORD(ord,"I",itm,1),"^",2)  ;医嘱 ARC_ItmMast ARCIM_RowId
	.s itmmastid=$p(arcimid,"||",1)
	.s itmmastver=$p(arcimid,"||",2)
	.s phcdr=$p(^ARCIM(itmmastid,itmmastver,1),"^",12)
	.s tmpformdr=$p(^PHCD(+phcdr,"DF",$p(phcdr,"||",2),1),"^",1) 
	s ret=0
	s inst=""
	f  s inst=$o(^DHCPCINST(inst)) q:(inst="")||(ret=1)  d
	.s dhcinstdr=$p(^DHCPCINST(inst),"^",1)
	.s formdr=$p(^DHCPCINST(inst),"^",2)
	.i (instdr=dhcinstdr)||($g(tmpformdr)'=""&(formdr'="")&(formdr=$g(tmpformdr))) d
	..s ret=1
	
	q ret
}

/// 检查单号是否一致  0 假  1真
ClassMethod CheckComNo(str, no) As %String
{
	s ret=0
	s cnt=$l(str,",")
	f i=1:1:cnt q:ret=1  d
	.s tmpno=$p(str,",",i)
	.i tmpno=no d
	..s ret=1
	q ret
}

/// 按医生排名统计处方
ClassMethod SortOrderDataByDoc(QueryStr, QueryFlag) As %String
{
	
	s pid=##class(web.DHCSTCNTSMAIN).GetPHCNTSPID()
	s qstdate=$p(QueryStr,"^",1)
	s qenddate=$p(QueryStr,"^",2)
	s:qstdate'="" qstdate=##class(websys.Conversions).DateHtmlToLogical(qstdate)
   	s:qenddate'="" qenddate=##class(websys.Conversions).DateHtmlToLogical(qenddate)
	s pcntstype="F"
	s qretsult=$p(QueryStr,"^",3)

	s h=0
	f date=qstdate:1:qenddate d
	.s typecnt=$l(pcntstype,"^")
	.f i=1:1:typecnt d
	..s type=$p(pcntstype,"^",i)
	..s pcnts=""
	..f  s pcnts=$o(^DHCPHCNTS(0,"Date",date,type,pcnts)) q:pcnts=""  d
	...s chl=""
	...f  s chl=$o(^DHCPHCNTS(pcnts,"I",chl)) q:chl=""  d
	....s prescno=$p(^DHCPHCNTS(pcnts,"I",chl),"^",1)
	....s orditem=$p(^DHCPHCNTS(pcnts,"I",chl),"^",2)
	....s current=$p(^DHCPHCNTS(pcnts,"I",chl),"^",6)
	....q:current="" 	// add by myq 20170214 仅统计已经点评过的数据
	....s ord=$p(orditem,"||",1)
	....s itm=$p(orditem,"||",2)
	....s doclocdr=$p(^DHCPHCNTS(pcnts,"I",chl),"^",4)
    ....s orddept=$p(^CTLOC(doclocdr),"^",2)  
	....i $f(orddept,"-") s orddept=$p(orddept,"-",2)
	....s docdr=$p(^DHCPHCNTS(pcnts,"I",chl),"^",5)
	....s doctor=$p(^SSU("SSUSR",docdr),"^",2)  ;医生
	....s curret=$p(^DHCPHCNTS(pcnts,"I",chl),"^",6) ;结果
	....s index=1
	....i QueryFlag="1" s index=doctor
	....i QueryFlag="2" s index=orddept
	....i '$D(^TMP("dhcpha","DHCSTCNTSQUERY","QueryOrderByDoc",pid,"OrderBy","TotalPrescno",prescno_pcnts)) d
	.....s ^TMP("dhcpha","DHCSTCNTSQUERY","QueryOrderByDoc",pid,"OrderBy","TotalNum",index)=+$g(^TMP("dhcpha","DHCSTCNTSQUERY","QueryOrderByDoc",pid,"OrderBy","TotalNum",index))+1 
	.....s ^TMP("dhcpha","DHCSTCNTSQUERY","QueryOrderByDoc",pid,"OrderBy","TotalPrescno",prescno_pcnts)=""
	....q:(qretsult'="")&(qretsult="1")&(curret'="Y")
	....q:(qretsult'="")&(qretsult="2")&(curret'="N")
	....s tmpcurret=""
	....i qretsult="1" d
	.....s tmpcurret="Y"
	....i qretsult="2" d
	.....s tmpcurret="N" 
	....s h=h+1
	....// modified by myq 20170302 计算合理处方数
	....i ('$D(^TMP("dhcpha","DHCSTCNTSQUERY","QueryOrderByDoc",pid,"OrderBy","PrescNo",prescno_pcnts))&&((curret=tmpcurret)||(tmpcurret=""))) d
	.....s indexnum=+$g(^TMP("dhcpha","DHCSTCNTSQUERY","QueryOrderByDoc",pid,"OrderBy","Count",index))+1
	.....s indexnum=99999-indexnum
	.....s ^TMP("dhcpha","DHCSTCNTSQUERY","QueryOrderByDoc",pid,"OrderBy","Index",indexnum,index)=""
	.....s ^TMP("dhcpha","DHCSTCNTSQUERY","QueryOrderByDoc",pid,"OrderBy","Count",index)=+$g(^TMP("dhcpha","DHCSTCNTSQUERY","QueryOrderByDoc",pid,"OrderBy","Count",index))+1 
	.....s ^TMP("dhcpha","DHCSTCNTSQUERY","QueryOrderByDoc",pid,"OrderBy","PrescNo",prescno_pcnts)=""
	....
    
    s x=0
	s indexno=""
	f  s indexno=$o(^TMP("dhcpha","DHCSTCNTSQUERY","QueryOrderByDoc",pid,"OrderBy","Index",indexno)) q:(indexno="")||(x>20)  d
	.s index=""
	.f  s index=$o(^TMP("dhcpha","DHCSTCNTSQUERY","QueryOrderByDoc",pid,"OrderBy","Index",indexno,index)) q:(index="")||(x>20)  d
	..s desc=$p(index,"^",1)
	..s num=99999-indexno
	..s totalnum=+$g(^TMP("dhcpha","DHCSTCNTSQUERY","QueryOrderByDoc",pid,"OrderBy","TotalNum",index))
	..s cent=num/totalnum
	..i $f(cent,".") d
	...i $l($p(cent,".",2))>4 d
	....s cent=$fn(cent,"",4)
	..s cent=cent*100
	..s data=desc_"^"_num_"^"_cent
	..q:$d(^TMP("dhcpha","DHCSTCNTSQUERY","QueryOrderByDoc",pid,"OrderBy","OK",index))
	..s x=x+1
	..s ^TMP("dhcpha","DHCSTCNTSQUERY","QueryOrderByDoc",pid,"OrderBy","Num",x)=data
	..s ^TMP("dhcpha","DHCSTCNTSQUERY","QueryOrderByDoc",pid,"OrderBy","OK",index)=""
	
	q x_"^"_pid
}

/// 查询不合格处方点评单,按医生排名
ClassMethod QueryOrderByDoc(QueryStr, StartPage, Limit, QueryFlag) As %String
{
	
    //s ^tmyq("QueryOrderByDoc")=QueryStr_","_StartPage_","_Limit_","_QueryFlag
	s endpage=StartPage+Limit  //结束行
	s stpage=StartPage+1 //开始行
	s retsult=$p(QueryStr,"^",3)
	s sorttype=$p(QueryStr,"^",4)
    s retstr=0
	i sorttype="1" s retstr=..SortOrderDataByDoc(QueryStr,QueryFlag)
	i sorttype="2" s retstr=..SortDataByType(QueryStr,QueryFlag)
	s x=$p(retstr,"^",1)
	s pid=$p(retstr,"^",2)
 
	q:x=0 ##class(web.DHCSTEXTCOMMON).GetNoJson()
    
    s maxrow=x
    i endpage>maxrow s endpage=maxrow
    s count=0
    s h=""
    f  s h=$o(^TMP("dhcpha","DHCSTCNTSQUERY","QueryOrderByDoc",pid,"OrderBy","Num",h)) q:h=""  d
    .s data=^TMP("dhcpha","DHCSTCNTSQUERY","QueryOrderByDoc",pid,"OrderBy","Num",h)
    .s desc=$p(data,"^",1)
    .s descnum=$p(data,"^",2)
    .s desccent=$p(data,"^",3)
    .s count=count+1
    .q:count<stpage
    .q:count>endpage
    .
    .s desc=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("desc",desc)
	.s descnum=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("descnum",descnum)
	.s desccent=##class(web.DHCSTEXTCOMMON).GetJsonLastCell("desccent",desccent)
	.s tmpstr=desc_descnum_desccent
	.
    .s startString=##class(web.DHCSTEXTCOMMON).GetJsonStartString(maxrow)
    .s firstrow=##class(web.DHCSTEXTCOMMON).GetJsonFirstRow(tmpstr)
    .s lastrow=##class(web.DHCSTEXTCOMMON).GetJsonLastRow(tmpstr)
    .
    .i count=stpage w startString
    .i count<endpage w firstrow
    .i count=endpage w lastrow
	
	k ^TMP("dhcpha","DHCSTCNTSQUERY","QueryOrderByDoc",pid)
	q ""
}

// 明细导出xls

// d ##class(%ResultSet).RunQuery("web.DHCSTCNTSQUERY","GetDetailDataForExp","32204")

ClassMethod GetDetailDataForExpExecute(ByRef qHandle As %Binary, pid) As %Status
{
    s repid=$I(^CacheTemp)
    Set qHandle=$lb(0,repid,0)
    s ind=1

    q:pid="" $$$OK
  
    s h=""
    f  s h=$o(^TMP("dhcpha","DHCSTCNTSQUERY","QueryCommontItm","Export",pid,h)) q:h=""  d
    .s data=^TMP("dhcpha","DHCSTCNTSQUERY","QueryCommontItm","Export",pid,h)
    .s cntsno=$p(data,"^",1)
    .s prescno=$p(data,"^",2)
    .s patno=$p(data,"^",3)
    .s patage=$p(data,"^",4)
    .s patsex=$p(data,"^",5)
    .s diag=$p(data,"^",6)
    .s orddept=$p(data,"^",7)
    .s doctor=$p(data,"^",8)
    .s curret=$p(data,"^",9)
    .s incidesc=$p(data,"^",10)
    .s colorflag=$p(data,"^",11)
    .s reason=$p(data,"^",12)
    .s phadvice=$p(data,"^",13)
    .s phnote=$p(data,"^",14)
    .s qty=$p(data,"^",15)
    .s uomdesc=$p(data,"^",16)
    .s dosage=$p(data,"^",17)
    .s freq=$p(data,"^",18)
    .s instru=$p(data,"^",19)
    .s duration=$p(data,"^",20)
    .s remark=$p(data,"^",21)
    .s pyuser=$p(data,"^",22)
    .s fyuser=$p(data,"^",23)
    .s price=$p(data,"^",24)
    .s amt=$p(data,"^",25)
    .s prescamt=$p(data,"^",26)
    .s doctorcode=$p(data,"^",27)
    .s orddeptcode=$p(data,"^",28)
    .s patname=$p(data,"^",29)
    .s sumantamt=$p(data,"^",30)
    .s antamtcent=$p(data,"^",31)
    .s sumbasamt=$p(data,"^",32)
    .s basamtcent=$p(data,"^",33)
    .s billtype=$p(data,"^",34)
    .s username=$p(data,"^",35)
    .d OutRowItm
	Quit $$$OK
OutRowItm
	set Data=$lb(cntsno,prescno,patno,patname,patsex,patage,billtype,diag,orddeptcode,orddept,doctorcode,doctor,pyuser,fyuser,incidesc,qty,price,amt,prescamt,sumantamt,antamtcent,sumbasamt,basamtcent,uomdesc,dosage,freq,instru,duration,remark,username,curret,reason,phadvice,phnote)    
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
}

ClassMethod GetDetailDataForExpFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDetailDataForExpExecute ]
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

Query GetDetailDataForExp(pid As %String) As %Query(ROWSPEC = "Tcntsno,Tprescno,Tpatno,Tpatname,Tpatage,Tpatsex,Tbilltype,Tdiag,Torddeptcode,Torddept,Tdoctorcode,Tdoctor,Tpyuser,Tfyuser,Tincidesc,Tqty,Tprice,Tamt,Tprescamt,Tsumantamt,Tantamtcent,Tsumbasamt,Tbasamtcent,Tuomdesc,Tdosage,Tfreq,Tinstru,Tduration,Tremark,Tusername,Tcurret,Treason,Tphadvice,Tphnote:%String") [ SqlProc ]
{
}

ClassMethod GetDetailDataForExpClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDetailDataForExpExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
    Quit $$$OK
}

// 汇总导出xls

// d ##class(%ResultSet).RunQuery("web.DHCSTCNTSQUERY","GetTotalDataForExp","31099")

ClassMethod GetTotalDataForExpExecute(ByRef qHandle As %Binary, pid) As %Status
{
	
    s repid=$I(^CacheTemp)
    Set qHandle=$lb(0,repid,0)
    s ind=1
    //DHCSTINSTAT  DHCSTOUTSTAT2
    q:pid="" $$$OK
    //num_"^"_prescno_"^"_patno_"^"_patsex_"^"_patage_"^"_diag_"^"_curret_"^"_doctor_"^"_kjnum_"^"_zsnum_"^"_bnum_"^"_gernum_"^"_amt_"^"_pyuser_"^"_fyuser_"^"_reason_"^"_itmnum_"^"_orddate
    s h=""
    f  s h=$o(^TMP("dhcpha","DHCSTCNTSQUERY","QueryCommontPrescNo","Export",pid,h)) q:h=""  d
    .s data=^TMP("dhcpha","DHCSTCNTSQUERY","QueryCommontPrescNo","Export",pid,h)
    .s num=$p(data,"^",1)
    .s prescno=$p(data,"^",2)
    .s patno=$p(data,"^",3)
    .s patsex=$p(data,"^",4)
    .s patage=$p(data,"^",5)
    .s diag=$p(data,"^",6)
    .s curret=$p(data,"^",7)
    .s doctor=$p(data,"^",8)
    .s kjnum=$p(data,"^",9)
    .s zsnum=$p(data,"^",10)
    .s bnum=$p(data,"^",11)
    .s gernum=$p(data,"^",12)
    .s amt=$p(data,"^",13)
    .s pyuser=$p(data,"^",14)
    .s fyuser=$p(data,"^",15)
    .s reason=$p(data,"^",16)
    .s itmnum=$p(data,"^",17)
    .s orddate=$p(data,"^",18)
    .s patname=$p(data,"^",19)
    .
    .d OutRowTotal
	Quit $$$OK
OutRowTotal
	set Data=$lb(num,prescno,patno,patname,patsex,orddate,patage,diag,itmnum,kjnum,zsnum,bnum,gernum,amt,doctor,pyuser,fyuser,curret,reason)    
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
}

ClassMethod GetTotalDataForExpFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetTotalDataForExpExecute ]
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

Query GetTotalDataForExp(pid As %String) As %Query(ROWSPEC = "num,prescno,patno,patname,patsex,orddate,patage,diag,itmnum,kjnum,zsnum,bnum,gernum,amt,doctor,pyuser,fyuser,curret,reason:%String") [ SqlProc ]
{
}

ClassMethod GetTotalDataForExpClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetTotalDataForExpExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
    Quit $$$OK
}

// 原因汇总导出xls

// d ##class(%ResultSet).RunQuery("web.DHCSTCNTSQUERY","GetReasonTotalDataForExp","68110")

ClassMethod GetReasonTotalDataForExpExecute(ByRef qHandle As %Binary, pid) As %Status
{
	
    s repid=$I(^CacheTemp)
    Set qHandle=$lb(0,repid,0)
    s ind=1
    
    q:pid="" $$$OK
    s h=""
    f  s h=$o(^TMP("dhcpha","DHCSTCNTSQUERY","QueryCommontByRea","Export",pid,h)) q:h=""  d
    .s data=^TMP("dhcpha","DHCSTCNTSQUERY","QueryCommontByRea","Export",pid,h)
    .s locdesc=$p(data,"^",1)
    .s locrowid=$p(data,"^",2)
    .s reason1=$p(data,"^",3)
    .s centprescn1=$p(data,"^",4)
    .s locrepnum1=$p(data,"^",5)
    .s locrepcent1=$p(data,"^",6)
    .s reason2=$p(data,"^",7)
    .s centprescn2=$p(data,"^",8)
    .s locrepnum2=$p(data,"^",9)
    .s locrepcent2=$p(data,"^",10)
    .s reason3=$p(data,"^",11)
    .s centprescn3=$p(data,"^",12)
    .s locrepnum3=$p(data,"^",13)
    .s locrepcent3=$p(data,"^",14)
    .s locreanum=$p(data,"^",15)
    .s locbedprescnum=$p(data,"^",16)
    .s locallprescnum=$p(data,"^",17)
    .s loccentprescnum=$p(data,"^",18)
    .
    .d OutRowReaTotal
	Quit $$$OK
OutRowReaTotal
	set Data=$lb(locdesc,reason1,centprescn1,locrepnum1,locrepcent1,reason2,centprescn2,locrepnum2,locrepcent2,reason3,centprescn3,locrepnum3,locrepcent3,locreanum,locbedprescnum,locallprescnum,loccentprescnum)    
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
}

ClassMethod GetReasonTotalDataForExpFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetReasonTotalDataForExpExecute ]
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

Query GetReasonTotalDataForExp(pid As %String) As %Query(ROWSPEC = "Tlocdesc,Treason1:%String,Tcentprescn1:%Float,Tlocrepnum1:%Float,Tlocrepcent1:%Float,Treason2:%Float,Tcentprescn2:%Float,Tlocrepnum2:%Float,Tlocrepcent2:%Float,Treason3:%Float,Tcentprescn3:%Float,Tlocrepnum3:%Float,Tlocrepcent3:%Float,Tlocreanum:%Float,Tlocbedprescnum:%Float ,Tlocallprescnum:%Float,Tloccentprescnum:%Float") [ SqlProc ]
{
}

ClassMethod GetReasonTotalDataForExpClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetReasonTotalDataForExpExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
    Quit $$$OK
}

// 按医生排名xls

// d ##class(%ResultSet).RunQuery("web.DHCSTCNTSQUERY","GetOrderDataByDocForExp","12/03/2011^12/03/2013^^1","1")

ClassMethod GetOrderDataByDocForExpExecute(ByRef qHandle As %Binary, QueryStr, QueryFlag) As %Status
{
	
    s repid=$I(^CacheTemp)
    Set qHandle=$lb(0,repid,0)
    s ind=1
    s sorttype=$p(QueryStr,"^",4)
    
    s retstr=0
    i sorttype="1" s retstr=..SortOrderDataByDoc(QueryStr,QueryFlag)
	i sorttype="2" s retstr=..SortDataByType(QueryStr,QueryFlag)
    s cnt=$p(retstr,"^",1)
    s pid=$p(retstr,"^",2)
    
    q:cnt=0 $$$OK
    s h=""
    f  s h=$o(^TMP("dhcpha","DHCSTCNTSQUERY","QueryOrderByDoc",pid,"OrderBy","Num",h)) q:h=""  d
    .s data=^TMP("dhcpha","DHCSTCNTSQUERY","QueryOrderByDoc",pid,"OrderBy","Num",h)
    .s desc=$p(data,"^",1)
    .s descnum=$p(data,"^",2)
    .s desccent=$p(data,"^",3)
    .
    .d OutRow
    k ^TMP("dhcpha","DHCSTCNTSQUERY","QueryOrderByDoc",pid)
	Quit $$$OK
OutRow
	set Data=$lb(desc,descnum,desccent)    
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
}

ClassMethod GetOrderDataByDocForExpFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetOrderDataByDocForExpExecute ]
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

Query GetOrderDataByDocForExp(QueryStr, QueryFlag) As %Query(ROWSPEC = "desc:%String,descnum:%String,desccent:%String") [ SqlProc ]
{
}

ClassMethod GetOrderDataByDocForExpClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetOrderDataByDocForExpExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// 按处方率排名处方
ClassMethod SortDataByType(QueryStr, QueryFlag) As %String
{
	s pid=##class(web.DHCSTCNTSMAIN).GetPHCNTSPID()
	s qstdate=$p(QueryStr,"^",1)
	s qenddate=$p(QueryStr,"^",2)
	s:qstdate'="" qstdate=##class(websys.Conversions).DateHtmlToLogical(qstdate)
   	s:qenddate'="" qenddate=##class(websys.Conversions).DateHtmlToLogical(qenddate)
	s pcntstype="F"
	s qretsult=$p(QueryStr,"^",3)
	s qsorttype=$p(QueryStr,"^",4)

	s h=0
	f date=qstdate:1:qenddate d
	.s typecnt=$l(pcntstype,"^")
	.f i=1:1:typecnt d
	..s type=$p(pcntstype,"^",i)
	..s pcnts=""
	..f  s pcnts=$o(^DHCPHCNTS(0,"Date",date,type,pcnts)) q:pcnts=""  d
	...s chl=""
	...f  s chl=$o(^DHCPHCNTS(pcnts,"I",chl)) q:chl=""  d
	....s prescno=$p(^DHCPHCNTS(pcnts,"I",chl),"^",1)
	....s orditem=$p(^DHCPHCNTS(pcnts,"I",chl),"^",2)
	....s current=$p(^DHCPHCNTS(pcnts,"I",chl),"^",6)
	....q:current="" 	// add by myq 20170214 仅统计已经点评过的数据
	....s ord=$p(orditem,"||",1)
	....s itm=$p(orditem,"||",2)
	....s doclocdr=$p(^DHCPHCNTS(pcnts,"I",chl),"^",4)
    ....s orddept=$p(^CTLOC(doclocdr),"^",2)  
	....i $f(orddept,"-") s orddept=$p(orddept,"-",2)
	....s docdr=$p(^DHCPHCNTS(pcnts,"I",chl),"^",5)
	....s doctor=$p(^SSU("SSUSR",docdr),"^",2)  ;医生
	....s curret=$p(^DHCPHCNTS(pcnts,"I",chl),"^",6) ;结果
	....s prescno=prescno_pcnts
	....s index=1
	....i QueryFlag="1" s index=doctor
	....i QueryFlag="2" s index=orddept
	....i '$D(^TMP("dhcpha","DHCSTCNTSQUERY","QueryOrderByDoc",pid,"OrderBy","TotalPrescno",prescno)) d
	.....s ^TMP("dhcpha","DHCSTCNTSQUERY","QueryOrderByDoc",pid,"OrderBy","TotalNum",index)=+$g(^TMP("dhcpha","DHCSTCNTSQUERY","QueryOrderByDoc",pid,"OrderBy","TotalNum",index))+1 
	.....s ^TMP("dhcpha","DHCSTCNTSQUERY","QueryOrderByDoc",pid,"OrderBy","TotalPrescno",prescno)=""
	....q:(qretsult'="")&(qretsult="1")&(curret'="Y")
	....q:(qretsult'="")&(qretsult="2")&(curret'="N")
	....s tmpcurret=""
	....i qretsult="1" d
	.....s tmpcurret="Y"
	....i qretsult="2" d
	.....s tmpcurret="N" 
	....s h=h+1
	....i ('$D(^TMP("dhcpha","DHCSTCNTSQUERY","QueryOrderByDoc",pid,"OrderBy","PrescNo",prescno))&&((curret=tmpcurret)||(tmpcurret=""))) d
	.....s ^TMP("dhcpha","DHCSTCNTSQUERY","QueryOrderByDoc",pid,"OrderBy","Count",index)=+$g(^TMP("dhcpha","DHCSTCNTSQUERY","QueryOrderByDoc",pid,"OrderBy","Count",index))+1 
	.....s ^TMP("dhcpha","DHCSTCNTSQUERY","QueryOrderByDoc",pid,"OrderBy","PrescNo",prescno)=""
	....
	s x=0
	s index=""
	f  s index=$o(^TMP("dhcpha","DHCSTCNTSQUERY","QueryOrderByDoc",pid,"OrderBy","Count",index)) q:index=""  d
	.s totalnum=^TMP("dhcpha","DHCSTCNTSQUERY","QueryOrderByDoc",pid,"OrderBy","TotalNum",index)
	.s num=^TMP("dhcpha","DHCSTCNTSQUERY","QueryOrderByDoc",pid,"OrderBy","Count",index)
	.s cent=num/totalnum
	.i $f(cent,".") d
	..i $l($p(cent,".",2))>4 d
	...s cent=$fn(cent,"",4)
	.s indexno=99999-cent
	.s cent=cent*100
	.s data=index_"^"_num_"^"_cent
	.s ^TMP("dhcpha","DHCSTCNTSQUERY","QueryOrderByDoc",pid,"OrderBy","Index",indexno,index)=data
    
    s x=0
	s indexno=""
	f  s indexno=$o(^TMP("dhcpha","DHCSTCNTSQUERY","QueryOrderByDoc",pid,"OrderBy","Index",indexno)) q:(indexno="")||(x>20)  d
	.s index=""
	.f  s index=$o(^TMP("dhcpha","DHCSTCNTSQUERY","QueryOrderByDoc",pid,"OrderBy","Index",indexno,index)) q:(index="")||(x>20)  d
	..s info=^TMP("dhcpha","DHCSTCNTSQUERY","QueryOrderByDoc",pid,"OrderBy","Index",indexno,index)
	..q:$d(^TMP("dhcpha","DHCSTCNTSQUERY","QueryOrderByDoc",pid,"OrderBy","OK",index))
	..s x=x+1
	..s ^TMP("dhcpha","DHCSTCNTSQUERY","QueryOrderByDoc",pid,"OrderBy","Num",x)=info
	..s ^TMP("dhcpha","DHCSTCNTSQUERY","QueryOrderByDoc",pid,"OrderBy","OK",index)=""
	
	q x_"^"_pid
}

/// 查询住院点评明细内容
ClassMethod QueryCommontIPItm(QueryStr) As %String
{
	
	s HospID=""
    s h=0
    s locstr=##class(web.DHCSTCNTSCOMMON).GetPhaLocStr()
    s pid=##class(web.DHCSTCNTSMAIN).GetPHCNTSPID()
	s qstdate=$p(QueryStr,"^",1)
	s qenddate=$p(QueryStr,"^",2)
	s:qstdate'="" qstdate=##class(websys.Conversions).DateHtmlToLogical(qstdate)
   	s:qenddate'="" qenddate=##class(websys.Conversions).DateHtmlToLogical(qenddate)
	s qresult=$p(QueryStr,"^",3)
	s type="P"
	f date=qstdate:1:qenddate d
	.s pcnts=""
	.f  s pcnts=$o(^DHCPHCNTS(0,"Date",date,type,pcnts)) q:pcnts=""  d
	..s pcntsno=$p(^DHCPHCNTS(pcnts),"^",1)
	..s pcntsdate=$p(^DHCPHCNTS(pcnts),"^",2)
	..i pcntsdate'="" s pcntsdate=##class(websys.Conversions).DateLogicalToHtml(pcntsdate)
	..s pcntstime=$p(^DHCPHCNTS(pcnts),"^",3)
	..i pcntstime'="" s pcntstime=##class(websys.Conversions).TimeLogicalToHtml(pcntstime)
	..s pcntstext=$p(^DHCPHCNTS(pcnts),"^",4)
	..s pcntsuserdr=$p(^DHCPHCNTS(pcnts),"^",6)
	..s pcntsuser=$p(^SSU("SSUSR",pcntsuserdr),"^",2)
	..s tchl=""
	..f  s tchl=$o(^DHCPHCNTS(pcnts,"I",tchl)) q:tchl=""  d
	...s curretcode=$p(^DHCPHCNTS(pcnts,"I",tchl),"^",6)
	...s pcntsitm=pcnts_"||"_tchl
	...q:(qresult=1)&(curretcode'="Y")
	...q:(qresult=2)&(curretcode'="N")
	...q:(qresult=4)&(curretcode="") //仅有结果
	...s curret=""
	...i curretcode="Y" s curret="合理"
	...//i curretcode="N" s curret="不合理"		// noted by myq 20170206 不合理的在遍历孙表时赋值
	...s prescno=$p(^DHCPHCNTS(pcnts,"I",tchl),"^",1)
	...s adm=$p(^DHCPHCNTS(pcnts,"I",tchl),"^",3)
	...s papmi=$p(^PAADM(adm),"^",1)
	...s patname=$p(^PAPER(papmi,"ALL"),"^", 1) ;患者姓名
	...s sex=$p(^PAPER(papmi,"ALL"),"^",7 ) ;姓别
	...s patsex=$p(^CT("SEX",sex),"^",2)
	...s patno=$p(^PAPER(papmi,"PAT",1),"^",1)
	...s patage=##class(web.DHCSTKUTIL).GetAge(papmi)  ;年龄   
    ...s diag=..GetMRDiagnosDesc(adm,",") ;诊断
    ...i $f(diag,$c(13)) s diag=$p(diag,$c(13),1)
	...s doclocdr=$p(^DHCPHCNTS(pcnts,"I",tchl),"^",4)
	...s orddeptcode="",orddept=""
	...i doclocdr'="" d
	....s orddeptcode=$p(^CTLOC(doclocdr),"^",1)  ;科室代码
    ....s orddept=$p(^CTLOC(doclocdr),"^",2)
    ...s ord=$o(^OEORD(0,"Adm",adm,""))  q:ord="" 
	...s cnt=$l(locstr,"^")
	...f i=1:1:cnt d
	....s recdpdr=$p(locstr,"^",i)
	....i HospID="" s HospID=$p($g(^CTLOC(recdpdr)),"^",22)
	....s chl=""
	....f  s chl=$o(^OEORDi(0,"RecDepOrd",ord,recdpdr,chl)) q:chl=""  d
	.....s orditm=ord_"||"_chl
	.....s billtype=""
    .....s billtypedr=$p($g(^OEORD(ord,"I",chl,11)),"^",18)
    .....s:billtypedr'="" billtype=$p(^PAC("ADMREA",billtypedr),"^",2)
	.....s qty=##class(web.DHCSTCNTSCOMMON).GetDspQty(orditm)
	.....q:qty=0
	.....i curretcode="N" s curret=""
	.....s arcimid=$p(^OEORD(ord,"I",chl,1),"^",2)  ;医嘱 ARC_ItmMast ARCIM_RowId
	.....s itmmastid=$p(arcimid,"||",1)
	.....s itmmastver=$p(arcimid,"||",2)
	.....s arcimdesc=$p(^ARCIM(itmmastid,itmmastver,1),"^",2)
	.....s inci=$o(^INCI(0,"ARCIM_DR",$p(arcimid,"||",1),"") ) q:inci=""  //医嘱名称
	.....s inciDesc=$p(^INCI(inci,1),"^",2) //药品名称
	.....s inciDesc=arcimdesc
    .....// 医嘱改造,打包表数量为药学基本单位数量
    .....s uomdesc=""
    .....s phcdfId=$p(^ARCIM(itmmastid,itmmastver,1),"^",12)
    .....i phcdfId'="" d
    ......s uomid=$p(^PHCD(+phcdfId,"DF",+$p(phcdfId,"||",2),2),"^",4)
    ......s uomdesc=$p($g(^CT("UOM",+uomid)),"^",2)
    .....s dosagestr=##class(web.DHCSTCOMMONORDER).OeoriDosage(orditm)
    .....s dosageqty=$P($g(^OEORD(ord,"I",chl,2)),"^",1)		//计量
    .....s dosageuomid=$P($g(^OEORD(ord,"I",chl,2)),"^",3)		//计量单位
    .....s dosageuomdesc=$P($g(^CT("UOM",+dosageuomid)),"^",2)
    .....s freq=$p(##class(web.DHCSTCOMMONORDER).OeoriFreq(orditm),"^",4)
    .....s instru=$p(##class(web.DHCSTCOMMONORDER).OeoriInstruc(orditm),"^",2)
    .....s duration=$p(##class(web.DHCSTCOMMONORDER).OeoriDuration(orditm),"^",2)
    .....s priorty=$p(##class(web.DHCSTCOMMONORDER).OeoriPriority(orditm),"^",3)
	.....s doctor=$p(##class(web.DHCSTCOMMONORDER).OeoriDoctor(orditm),"^",2)  
	.....s skintest=##class(web.DHCSTCOMMONSRV).GetSkinTestResult(orditm)  ;皮试
	.....s:skintest'="" incidesc=skintest_" "_inciDesc
	.....s form=##class(web.DHCSTCOMMONSRV).GetForm(inci)  ;剂型
	.....i $F(form,$c(13)) s form=$p(form,$c(13))
	.....s (spec,manf)=""
	.....//s spec=##class(web.DHCSTCOMMONSRV).getBarcode(inci) ;规格
	.....//s manf=##class(web.DHCSTITMDESC).GetManfNameByInci(inci) ;厂家
	.....//i $f(manf,"-") s manf=$p(manf,"-",2)
	.....s remark=##class(web.DHCSTCOMMONSRV).GetOrdItmRemark(orditm) ;备注
	.....s dsp=$o(^DHCOEDISQTY(0,"OEORI",orditm,""))
    .....s orddate=$p(^DHCOEDISQTY(dsp),"^",21)
    .....i orddate'="" s orddate=##class(websys.Conversions).DateLogicalToHtml(orddate)
    .....s ordtime=$p(^DHCOEDISQTY(dsp),"^",20)
    .....i ordtime'="" s ordtime=##class(websys.Conversions).TimeLogicalToHtml(ordtime)
    .....s orddatetime=orddate_" "_ordtime  ;用药日期
    .....s reason=##class(web.DHCSTCNTSIPDATA).GetMainCommentReason(orditm,pcntsitm)
    .....s dspdate=$p(^DHCOEDISQTY(dsp),"^",8)
    .....s (price,amt)=""
    .....s oeoridate=$p($g(^OEORD(+ord,"I",+chl,3)),"^",7)	// yunhaibao,20180619
    .....//s exStr="^"_dsp
    .....//s price=##class(web.DHCSTPRICE).GetSp(+inci,oeoridate,uomdr,HospID,"",exStr)	//zhouyg 20150113
	.....//s amt=$fn(price*qty,"",2)
	.....s basflag=""
	.....s infor=$o(^DHCITMINFO(0,"INCI",inci,""))
	.....// 医嘱结构改造，基本单位在药学项中获取 MaYuqiang 20190109
	.....s basflag=##class(web.DHCST.Common.DrugInfoCommon).GetBasicByPhcdf(phcdfId)
	.....s advice="",phnote="",username=""
	.....s pcntslid=""
	.....s pctclog=""
	.....f  s pctclog=$o(^DHCPCTABL(0,"OrdItm",orditm,pctclog)) q:pctclog=""  d
	......q:pctclog'[(pcnts_"||"_tchl_"||")
	......s pcntslactive=$p(^DHCPHCNTS(pcnts,"I",tchl,"L",$p(pctclog,"||",3)),"^",11)
	......q:pcntslactive'="Y"
	......s pcntslid=pctclog
	.....i curretcode="N" d
	......s tsub=$p(pcntslid,"||",3)
	.....e  d
	......s tsub=$o(^DHCPHCNTS(pcnts,"I",tchl,"L",""),-1)
	.....i tsub'="" d
	......s lbcurretcode=$p(^DHCPHCNTS(pcnts,"I",tchl,"L",tsub),"^",2)	
	......i lbcurretcode="N" s curret="不合理"
	......s advicedr=$p(^DHCPHCNTS(pcnts,"I",tchl,"L",tsub),"^",6)
	......i advicedr'="" s advice=$p($g(^DHCPCADVICE(advicedr)),"^",2)
	......s phnote=$p(^DHCPHCNTS(pcnts,"I",tchl,"L",tsub),"^",9)
	......s userdr=$p(^DHCPHCNTS(pcnts,"I",tchl,"L",tsub),"^",5)
	......s username=$p(^SSU("SSUSR",userdr),"^",2)
    .....s data=patno_"^"_patname_"^"_patage_"^"_patsex_"^"_billtype_"^"_diag_"^"_inciDesc_"^"_qty_"^"_uomdesc_"^"_dosageqty_"^"_dosageuomdesc_"^"_freq_"^"_instru_"^"_priorty_"^"_doctor_"^"_remark_"^"_curret_"^"_reason_"^"_basflag_"^"_price_"^"_amt_"^"_pcntsno_"^"_username_"^"_dosagestr
    .....s h=h+1
    .....s ^TMP("dhcpha","DHCSTCNTSQUERY","QueryCommontIPItm",pid,h)=data
	q h_"^"_pid
}

/// 查询住院点评明细内容
/// 6/02/2017^6/02/2017^,0,200
/// w ##class(web.DHCSTCNTSQUERY).QueryCommontIPDetail("17/10/2018^17/10/2018^,0,200")
ClassMethod QueryCommontIPDetail(QueryStr, StartPage, Limit) As %String
{
	s ^TMPDHCSTPARAMS("web.DHCSTCNTSQUERY","QueryCommontIPDetail")=QueryStr_","_StartPage_","_Limit
	s endpage=StartPage+Limit  //结束行
	s stpage=StartPage+1 //开始行
	s retdata=..QueryCommontIPItm(QueryStr)
	s h=$p(retdata,"^",1)
	s pid=$p(retdata,"^",2)
	q:h=0 ##class(web.DHCSTEXTCOMMON).GetNoJson()
	
	s maxrow=h
    i endpage>maxrow s endpage=maxrow
    s count=0
    s h=""
    f  s h=$o(^TMP("dhcpha","DHCSTCNTSQUERY","QueryCommontIPItm",pid,h)) q:h=""  d
    .s data=^TMP("dhcpha","DHCSTCNTSQUERY","QueryCommontIPItm",pid,h)
	.s patno=$p(data,"^",1)
	.s patname=$p(data,"^",2)
	.s patage=$p(data,"^",3)
	.s patsex=$p(data,"^",4)
	.s billtype=$p(data,"^",5)
	.s diag=$p(data,"^",6)
	.s inciDesc=$p(data,"^",7)
	.s qty=$p(data,"^",8)
	.s uomdesc=$p(data,"^",9)
	.s dosage=$p(data,"^",10)
	.s doseuom=$p(data,"^",11)
	.s freq=$p(data,"^",12)
	.s instru=$p(data,"^",13)
	.s priorty=$p(data,"^",14)
	.s doctor=$p(data,"^",15)
	.s remark=$p(data,"^",16)
	.s curret=$p(data,"^",17)
	.s reason=$p(data,"^",18)
	.s basflag=$p(data,"^",19)
	.s price=$p(data,"^",20)
	.s amt=$p(data,"^",21)
	.s pcntsno=$p(data,"^",22)
	.s username=$p(data,"^",23)
	.s dosagestr=$p(data,"^",24)
	.
	.s count=count+1
    .q:count<stpage
    .q:count>endpage
    .s patno=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("patno",patno)
    .s patname=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("patname",patname)
    .s patage=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("patage",patage)
    .s patsex=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("patsex",patsex)
    .s billtype=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("billtype",billtype)
    .s diag=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("diag",diag)
    .s inciDesc=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("inciDesc",inciDesc)
    .s qty=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("qty",qty)
    .s uomdesc=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("uomdesc",uomdesc)
    .s dosage=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("dosage",dosage)
    .s doseuom=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("doseuom",doseuom)
    .s freq=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("freq",freq)
    .s instru=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("instru",instru)
    .s priorty=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("priorty",priorty)
    .s doctor=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("doctor",doctor)
    .s remark=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("remark",remark)
    .s curret=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("curret",curret)
    .s reason=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("reason",reason)
    .s basflag=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("basflag",basflag)
	.s price=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("price",price)
	.s amt=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("amt",amt)
	.s pcntsno=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("pcntsno",pcntsno)
	.s dosagestr=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("dosagestr",dosagestr)
	.s username=##class(web.DHCSTEXTCOMMON).GetJsonLastCell("username",username)
    .
    .s tmpstr=patno_patname_patage_patsex_billtype_diag_inciDesc_qty_uomdesc_dosage_doseuom_freq_instru_priorty_doctor_remark_curret_reason_basflag_price_amt_pcntsno_dosagestr_username
	.
    .s startString=##class(web.DHCSTEXTCOMMON).GetJsonStartString(maxrow)
    .s firstrow=##class(web.DHCSTEXTCOMMON).GetJsonFirstRow(tmpstr)
    .s lastrow=##class(web.DHCSTEXTCOMMON).GetJsonLastRow(tmpstr)
    .
    .i count=stpage w startString
    .i count<endpage w firstrow
    .i count=endpage w lastrow
    
    
    k ^TMP("dhcpha","DHCSTCNTSQUERY","QueryCommontIPItm",pid)
    q ""
}

// 住院点评导出xls

// d ##class(%ResultSet).RunQuery("web.DHCSTCNTSQUERY","GetIPCNTSDetailByForExp","2019-01-03^2019-01-03^")

ClassMethod GetIPCNTSDetailByForExpExecute(ByRef qHandle As %Binary, QueryStr) As %Status
{
	
    s repid=$I(^CacheTemp)
    Set qHandle=$lb(0,repid,0)
    s ind=1
 	s retdata=..QueryCommontIPItm(QueryStr)
	s h=$p(retdata,"^",1)
	s pid=$p(retdata,"^",2)
	q:h=0 $$$OK

    s h=""
    f  s h=$o(^TMP("dhcpha","DHCSTCNTSQUERY","QueryCommontIPItm",pid,h)) q:h=""  d
    .s data=^TMP("dhcpha","DHCSTCNTSQUERY","QueryCommontIPItm",pid,h)
	.s patno=$p(data,"^",1)
	.s patname=$p(data,"^",2)
	.s patage=$p(data,"^",3)
	.s patsex=$p(data,"^",4)
	.s billtype=$p(data,"^",5)
	.s diag=$p(data,"^",6)
	.s inciDesc=$p(data,"^",7)
	.s qty=$p(data,"^",8)
	.s uomdesc=$p(data,"^",9)
	.s dosage=$p(data,"^",10)
	.s doseuom=$p(data,"^",11)
	.s freq=$p(data,"^",12)
	.s instru=$p(data,"^",13)
	.s priorty=$p(data,"^",14)
	.s doctor=$p(data,"^",15)
	.s remark=$p(data,"^",16)
	.s curret=$p(data,"^",17)
	.s reason=$p(data,"^",18)
    .s basflag=$p(data,"^",19)
    .s price=$p(data,"^",20)
    .s amt=$p(data,"^",21)
    .s pcntsno=$p(data,"^",22)
    .s username=$p(data,"^",23)
    .
    .d OutRow
    k ^TMP("dhcpha","DHCSTCNTSQUERY","QueryCommontIPItm",pid)
	Quit $$$OK
OutRow
	set Data=$lb(patno,patname,patage,patsex,billtype,diag,inciDesc,qty,uomdesc,dosage,doseuom,freq,instru,priorty,doctor,remark,curret,reason,basflag,price,amt,pcntsno,username)    
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
}

ClassMethod GetIPCNTSDetailByForExpFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetIPCNTSDetailByForExpExecute ]
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

Query GetIPCNTSDetailByForExp(QueryStr) As %Query(ROWSPEC = "patno:%String,patname:%String,patage:%String,patsex:%String,billtype:%String,diag:%String,inciDesc:%String,qty:%String,uomdesc:%String,dosage:%String,doseuom:%String,freq:%String,instru:%String,priorty:%String,doctor:%String,remark:%String,curret:%String,reason:%String,basflag:%String,price:%String,amt:%String,pcntsno:%String,username:%String") [ SqlProc ]
{
}

ClassMethod GetIPCNTSDetailByForExpClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetIPCNTSDetailByForExpExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// 查询住院点评明细内容
ClassMethod GetIPRationalUseData(QueryStr) As %String
{
	
    s amtsum=0  //用药总金额 
    s antsum=0  //抗菌药总数
    s bassum=0  //基本药总数
    s zssum=0   //注射药总数
    s itmsum=0  //药品种总数
    s node="dhcpha,DHCSTCNTSQUERY,GetIPRationalUseData"
    s h=0
    s locstr=##class(web.DHCSTCNTSCOMMON).GetPhaLocStr()
    s pid=##class(web.DHCSTCNTSMAIN).GetPHCNTSPID()
	s qstdate=$p(QueryStr,"^",1)
	s qenddate=$p(QueryStr,"^",2)
	s:qstdate'="" qstdate=##class(websys.Conversions).DateHtmlToLogical(qstdate)
   	s:qenddate'="" qenddate=##class(websys.Conversions).DateHtmlToLogical(qenddate)
	s qresult=$p(QueryStr,"^",3)
	s HospID=""
	s type="P"
	f date=qstdate:1:qenddate d
	.s pcnts=""
	.f  s pcnts=$o(^DHCPHCNTS(0,"Date",date,type,pcnts)) q:pcnts=""  d
	..s admsum=0  //就诊总人次
	..s tchl=""
	..f  s tchl=$o(^DHCPHCNTS(pcnts,"I",tchl)) q:tchl=""  d
	...s adm=$p(^DHCPHCNTS(pcnts,"I",tchl),"^",3)
	...s curret=$p(^DHCPHCNTS(pcnts,"I",tchl),"^",6)
	...q:(qresult=1)&(curret'="Y")
	...q:(qresult=2)&(curret'="N")
	...q:(qresult=4)&(curret="") //仅有结果
	...s admsum=admsum+1
    ...s ord=$o(^OEORD(0,"Adm",adm,""))  q:ord="" 
	...s cnt=$l(locstr,"^")
	...f reci=1:1:cnt d
	....s recdpdr=$p(locstr,"^",reci)
	....i (HospID="")&(recdpdr'="") s HospID=$p($g(^CTLOC(recdpdr)),"^",22)
	....s kchl=""
	....f  s kchl=$o(^OEORDi(0,"RecDepOrd",ord,recdpdr,kchl)) q:kchl=""  d
	.....s orditm=ord_"||"_kchl
	.....s qty=##class(web.DHCSTCNTSCOMMON).GetDspQty(orditm)
	.....q:qty=0
	.....s orddata=##class(web.DHCSTPCHCOLLS).getOrdWard(orditm)
	.....s warddr=$p(orddata,"^",1)
	.....s arcimid=$p(^OEORD(ord,"I",kchl,1),"^",2)
	.....s itmmastid=$p(arcimid,"||",1)
	.....s itmmastver=$p(arcimid,"||",2)
	.....s inci=$o(^INCI(0,"ARCIM_DR",$p(arcimid,"||",1),"") ) q:inci=""  //医嘱名称
	.....s incscdr=$p(^INCI(inci,2),"^",2)
	.....s incsctype=$p($g(^INC("SC",incscdr)),"^",3)
	.....q:incsctype'="G"
	.....s buomdr=+$p(^INCI(inci,1),"^",10)
	.....s dsp=$o(^DHCOEDISQTY(0,"OEORI",orditm,""))
    .....s dspdate=$p(^DHCOEDISQTY(dsp),"^",8)
    .....//s price=##class(web.DHCSTCOMMONSRV).GetPriceElse(+inci,dspdate,buomdr,"")
    .....s exStr="^"_dsp
    .....s price=##class(web.DHCSTPRICE).GetSp(+inci,dspdate,buomdr,HospID,"",exStr)	//zhouyg 20150113
	.....s amt=$fn(price*qty,"",2)
	.....s orddeptdr=$p(^OEORD(ord,"I",kchl,1),"^",3)
    .....s ctloc=$p(^CTLOC(orddeptdr),"^",2)
	.....s index=orddeptdr
        .....;科室人数 ;add by myq 20150422
	.....s ^TMP(node,pid,"LocAdm",index,adm)=""
	.....;就诊人数
	.....i '$d(^TMP(node,pid,"AdmSum",adm)) d
	......s ^TMP(node,pid,"AdmSumNum")=+$g(^TMP(node,pid,"AdmSumNum"))+1
	......s ^TMP(node,pid,"AdmSum",adm)=""
	.....;金额
    .....s ^TMP(node,pid,"AmtSum",index)=+$g(^TMP(node,pid,"AmtSum",index))+amt
	.....;抗菌药
	.....s antnum=0
	.....s antflag=##class(web.DHCSTCNTSCOMMON).GetAntibioticFlag(orditm)
	.....i antflag=1 s antnum=1
    .....s ^TMP(node,pid,"AntSum",index)=+$g(^TMP(node,pid,"AntSum",index))+antnum
	.....;注射药
	.....s zsnum=0
	.....s zsflag=##class(web.DHCSTCNTSCOMMON).GetZSDrugFlagByOrd(orditm)
	.....i zsflag=1 s zsnum=1
	.....s ^TMP(node,pid,"ZsSum",index)=+$g(^TMP(node,pid,"ZsSum",index))+zsnum
	.....;基本药
	.....s basnum=0
	.....s basflag=##class(web.DHCSTCNTSCOMMON).GetBasicDrugFlagByOrd(orditm)
	.....i basflag=1 s basnum=1
	.....s ^TMP(node,pid,"BasSum",index)=+$g(^TMP(node,pid,"BasSum",index))+basnum
	.....;品种数
	.....s arcimid=arcimid_"^"_pcnts
	.....i '$d(^TMP(node,pid,"DrugItm",index,arcimid)) d
	......s ^TMP(node,pid,"ItmNum",index)=+$g(^TMP(node,pid,"ItmNum",index))+1
	.....s ^TMP(node,pid,"DrugItm",index,arcimid)=""
	.....s orditm=orditm_"^"_pcnts
    .....s ^TMP(node,pid,"OrdItm",index,orditm)=""
	.....;
	.....s ^TMP(node,pid,"Dept",index)=""
	s itmtotal=0  //合计数
	s amttotal=0
	s anttotal=0
	s zstotal=0
	s bastotal=0
	s admsum=+$g(^TMP(node,pid,"AdmSumNum"))
	s index=""
	f  s index=$o(^TMP(node,pid,"Dept",index)) q:index=""  d
	.s ctlocdr=+index
	.s ctloc=$p(^CTLOC(ctlocdr),"^",2) 
	.i $f(ctloc,"-") s ctloc=$p(ctloc,"-",2)
	.s locadm=..GetGlobalRows(node,pid,"LocAdm",index)
	.s itmsum=..GetGlobalRows(node,pid,"DrugItm",index)            ;^TMP(node,pid,"ItmNum",index)
	.s orditmsum=..GetGlobalRows(node,pid,"OrdItm",index)
	.s amtsum=^TMP(node,pid,"AmtSum",index)
	.s antsum=^TMP(node,pid,"AntSum",index)
	.s zssum=^TMP(node,pid,"ZsSum",index)
	.s bassum=^TMP(node,pid,"BasSum",index)
	.s num1=itmsum/locadm  ;admsum  //1.每次就诊人均用药品种数
	.i $l(num1)>2 s num1=$fn(num1,"",2)
    .s num2=amtsum/locadm  ;admsum  //2.每次就诊人均药费
    .i $l(num2)>2 s num2=$fn(num2,"",2)
    .s num3=antsum/orditmsum  ;admsum //3.就诊使用抗菌药物的百分率
    .i $l(num3)>2 s num3=$fn(num3,"",2)
    .s num4=zssum/orditmsum  ;admsum  //4.就诊使用注射药物的百分率
    .i $l(num4)>2 s num4=$fn(num4,"",2)
    .s num5=bassum/orditmsum   ;admsum   //5.基本药物占处方用药的百分率
    .i $l(num5)>2 s num5=$fn(num5,"",2)
    .s itmtotal=itmtotal+num1
    .s amttotal=amttotal+num2
    .s anttotal=anttotal+num3
    .s zstotal=zstotal+num4
    .s bastotal=bastotal+num5
    .
    .s data=ctloc_"^"_num1_"^"_num2_"^"_(num3*100)_"^"_(num4*100)_"^"_(num5*100)
    .s h=h+1
    .s ^TMP(node,pid,"Itm",h)=data
    //合计
    q:h=0 h_"^"_pid
    //s h=h+1
    //s data="合计"_"^"_itmtotal_"^"_amttotal_"^"_(anttotal*100)_"^"_(zstotal*100)_"^"_(bastotal*100)
    //s ^TMP(node,pid,"Itm",h)=data

	q h_"^"_pid
}

/// Author : 计算global中节点下数值
/// Creator: MYQ
/// CreatDate : 20150414
ClassMethod GetGlobalRows(node1, node2, node3, node4) As %String
{
	//n (node1,node2,node3,node4)
	s counter=0
	s h=""
	f  s h=$o(^TMP(node1,node2,node3,node4,h)) q:h=""  d
	.s counter=counter+1
	
	q counter
}

/// 统计住院点评单合理用药指标
ClassMethod FindIPRationalUseData(QueryStr, StartPage, Limit) As %String
{
	s node="dhcpha,DHCSTCNTSQUERY,GetIPRationalUseData"
	s endpage=StartPage+Limit  //结束行
	s stpage=StartPage+1 //开始行
	s retdata=..GetIPRationalUseData(QueryStr)
	s h=$p(retdata,"^",1)
	s pid=$p(retdata,"^",2)
	q:h=0 ##class(web.DHCSTEXTCOMMON).GetNoJson()
	
	s maxrow=h
    i endpage>maxrow s endpage=maxrow
    s count=0
    
    s h=""
    f  s h=$o(^TMP(node,pid,"Itm",h)) q:h=""  d
    .s data=^TMP(node,pid,"Itm",h)
    .s loc=$p(data,"^",1)
	.s drugnum=$p(data,"^",2)
	.s drugamt=$p(data,"^",3)
	.s antdrug=$p(data,"^",4)
	.s zsdrug=$p(data,"^",5)
	.s basdrug=$p(data,"^",6) 
	.
	.s count=count+1
    .q:count<stpage
    .q:count>endpage
    .s loc=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("loc",loc)
    .s drugnum=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("drugnum",drugnum)
    .s drugamt=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("drugamt",drugamt)
    .s antdrug=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("antdrug",antdrug)
    .s zsdrug=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("zsdrug",zsdrug)
    .s basdrug=##class(web.DHCSTEXTCOMMON).GetJsonLastCell("basdrug",basdrug)
    .
    .s tmpstr=loc_drugnum_drugamt_antdrug_zsdrug_basdrug
	.
    .s startString=##class(web.DHCSTEXTCOMMON).GetJsonStartString(maxrow)
    .s firstrow=##class(web.DHCSTEXTCOMMON).GetJsonFirstRow(tmpstr)
    .s lastrow=##class(web.DHCSTEXTCOMMON).GetJsonLastRow(tmpstr)
    .
    .i count=stpage w startString
    .i count<endpage w firstrow
    .i count=endpage w lastrow
    
    
    k ^TMP(node,pid)
    q ""
}

/// 住院合理用药导出xls
/// d ##class(%ResultSet).RunQuery("web.DHCSTCNTSQUERY","GetIPRationalUseForExp","12/03/2011^12/06/2013")
ClassMethod GetIPRationalUseForExpExecute(ByRef qHandle As %Binary, QueryStr = "") As %Status
{
	
    s repid=$I(^CacheTemp)
    Set qHandle=$lb(0,repid,0)
    s ind=1

 	s retdata=..GetIPRationalUseData(QueryStr)
	s h=$p(retdata,"^",1)
	s pid=$p(retdata,"^",2)
	q:h=0 $$$OK
    s node="dhcpha,DHCSTCNTSQUERY,GetIPRationalUseData"
    s h=""
    f  s h=$o(^TMP(node,pid,"Itm",h)) q:h=""  d
    .s data=^TMP(node,pid,"Itm",h)
    .s loc=$p(data,"^",1)
	.s drugnum=$p(data,"^",2)
	.s drugamt=$p(data,"^",3)
	.s antdrug=$p(data,"^",4)
	.s zsdrug=$p(data,"^",5)
	.s basdrug=$p(data,"^",6)
    .
    .d OutRow
    k ^TMP(node,pid)
	Quit $$$OK
OutRow
	set Data=$lb(loc,drugnum,drugamt,antdrug,zsdrug,basdrug)    
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
}

ClassMethod GetIPRationalUseForExpFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetIPRationalUseForExpExecute ]
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

Query GetIPRationalUseForExp(QueryStr = "") As %Query(ROWSPEC = "loc,drugnum,drugamt,antdrug,zsdrug,basdrug:%String") [ SqlProc ]
{
}

ClassMethod GetIPRationalUseForExpClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetIPRationalUseForExpExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// 统计不合理原因明细
/// d ##class(%ResultSet).RunQuery("web.DHCSTCNTSQUERY","GetReaDetail","2011-1-01","2013-12-01")
ClassMethod GetReaDetailExecute(ByRef qHandle As %Binary, SDate = "", EndDate = "") As %Status
{
	
	s repid=$I(^CacheTemp)
    Set qHandle=$lb(0,repid,0)
    s ind=1
    
	s node="dhcpha,DHCSTCNTSQUERY,GetReaDetail"
  	s pid=##class(web.DHCSTCNTSMAIN).GetPHCNTSPID()

	s qstdate=SDate 
	s qenddate=EndDate 
	s:qstdate'="" qstdate=##class(websys.Conversions).DateHtmlToLogical(qstdate)
   	s:qenddate'="" qenddate=##class(websys.Conversions).DateHtmlToLogical(qenddate)

	s pcntstype="F"
	
	s x=0
	s h=0
	f date=qstdate:1:qenddate d
	.s typecnt=$l(pcntstype,"^")
	.f i=1:1:typecnt d
	..s type=$p(pcntstype,"^",i)
	..s pcnts=""
	..f  s pcnts=$o(^DHCPHCNTS(0,"Date",date,type,pcnts)) q:pcnts=""  d
	...s pcntsno=$p(^DHCPHCNTS(pcnts),"^",1)
	...s pcntsdate=$p(^DHCPHCNTS(pcnts),"^",2)
	...i pcntsdate'="" s pcntsdate=##class(websys.Conversions).DateLogicalToHtml(pcntsdate)
	...s pcntstime=$p(^DHCPHCNTS(pcnts),"^",3)
	...i pcntstime'="" s pcntstime=##class(websys.Conversions).TimeLogicalToHtml(pcntstime)
	...s pcntstext=$p(^DHCPHCNTS(pcnts),"^",4)
	...s pcntsuserdr=$p(^DHCPHCNTS(pcnts),"^",6)
	...s pcntsuser=$p(^SSU("SSUSR",pcntsuserdr),"^",2)
	...i type="F" s typedesc="门诊"
	...i type="P" s typedesc="住院"
	...s chl=""
	...f  s chl=$o(^DHCPHCNTS(pcnts,"I",chl)) q:chl=""  d
	....s prescno=$p(^DHCPHCNTS(pcnts,"I",chl),"^",1)
	....s orditem=$p(^DHCPHCNTS(pcnts,"I",chl),"^",2)
	....s ord=$p(orditem,"||",1)
	....s itm=$p(orditem,"||",2)
	....s adm=$p(^DHCPHCNTS(pcnts,"I",chl),"^",3)
	....q:adm=""
	....q:'$d(^PAADM(adm))
	....s papmi=$p(^PAADM(adm),"^",1)
	....s patname=$p(^PAPER(papmi,"ALL"),"^", 1) ;患者姓名
	....s sex=$p(^PAPER(papmi,"ALL"),"^",7 ) ;姓别
	....s patsex=$p(^CT("SEX",sex),"^",2)
	....s patno=$p(^PAPER(papmi,"PAT",1),"^",1)
	....s patage=##class(web.DHCSTKUTIL).GetAge(papmi)  ;年龄   
    ....s diag=..GetMRDiagnosDesc(adm,",") ;诊断
    ....//i $f(diag,$c(13)) s diag=$p(diag,$c(13),1)
    ....s billtype=""
    ....s billtypedr=+$p(^PAPER(papmi,"PER",1),"^",10)
    ....s:billtypedr'="" billtype=$p(^CT("SS",billtypedr),"^",2)
	....s doclocdr=$p(^DHCPHCNTS(pcnts,"I",chl),"^",4)
	....s orddeptcode=$p(^CTLOC(doclocdr),"^",1)  ;科室代码
    ....s orddept=$p(^CTLOC(doclocdr),"^",2)  
	....i $f(orddept,"-") s orddept=$p(orddept,"-",2)
	....s docdr=$p(^DHCPHCNTS(pcnts,"I",chl),"^",5)
	....s doctorcode=$p(^SSU("SSUSR",docdr),"^",1)  ;医生工号
	....s doctor=$p(^SSU("SSUSR",docdr),"^",2)  ;医生
	....s curret=$p(^DHCPHCNTS(pcnts,"I",chl),"^",6) ;结果
	....q:curret'="N"
	....s username=""
	....s sub=$o(^DHCPHCNTS(pcnts,"I",chl,"L",""),-1)
	....i sub'="" d
	.....s userdr=$p(^DHCPHCNTS(pcnts,"I",chl,"L",sub),"^",5)
	.....s username=$p(^SSU("SSUSR",userdr),"^",2)
	....s doclocdr=$p(^DHCPHCNTS(pcnts,"I",chl),"^",4)
	....s reasoninfo=..GetCommentReaStr(orditem) //不合理原因
	....s reasoncnt=$l(reasoninfo,"^")
	....f y=1:1:reasoncnt d
	.....s reason=$p(reasoninfo,"^",y)
	.....s h=h+1
	.....s index=doclocdr_"^"_reason_"^"_prescno
    .....s ^TMP(node,pid,"Index",index)=reason
    
    s x=0 
    s index=""
    f  s index=$o(^TMP(node,pid,"Index",index)) q:index=""  d
    .s data=^TMP(node,pid,"Index",index)
    .s doclocdr=$p(index,"^",1)
    .s docloc=$p(^CTLOC(doclocdr),"^",2)  
    .s reacode=$p(index,"^",2)
    .s prescnum=1 //$p(index,"^",3)
    .s reason=$p(data,"^",1)
    .i reason="" s reason="无"
    .d OutRow
    .
    k ^TMP(node,pid)
	Quit $$$OK
OutRow
	set Data=$lb(docloc,reacode,reason,prescnum)    
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
}

ClassMethod GetReaDetailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetReaDetailExecute ]
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

Query GetReaDetail(SDate = "", EndDate = "") As %Query(ROWSPEC = "Tdocloc,Treacode,Treason,Tprescnum:%Integer") [ SqlProc ]
{
}

ClassMethod GetReaDetailClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetReaDetailExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// 获取医嘱原因
/// Input: 医嘱ID
/// Output:点评不合理原因(间隔符 ,)
ClassMethod GetCommentReaStr(orditm) As %String
{
	s reastr=""
	s h=0
	s main=""
	f  s main=$o(^DHCPHCNTS(0,"OrdItem",orditm, main)) q:main=""  d
	.s itm=""
	.f  s itm=$o(^DHCPHCNTS(0,"OrdItem",orditm,main,itm)) q:itm=""  d
	..s currret=$p(^DHCPHCNTS(main,"I",itm),"^",6)
	..q:currret'="N"
	..s sub=""
	..f  s sub=$o(^DHCPHCNTS(main,"I",itm,"L",sub)) q:sub=""  d
	...s active=$p(^DHCPHCNTS(main,"I",itm,"L",sub),"^",11)
	...q:active'="Y"
	...s h=h+1
	...s reacode=""
	...s reasondr=$p(^DHCPHCNTS(main,"I",itm,"L",sub),"^",1)
	...s:reasondr'="" reacode=$p(^DHCPCREASON(reasondr) ,"^",1)
	...s reason=""
	...s:reacode'="" reason=$p(^DHCPCREASON(reasondr) ,"^",2)
	...i reacode'="" s reason=reacode_reason
	...i reason'="" d
	....i reastr="" d
	.....s reastr=reason
	....e  d
	.....s reastr=reastr_"^"_reason
	q reastr
}

/// 统计不合理原因明细
/// d ##class(%ResultSet).RunQuery("web.DHCSTCNTSQUERY","GetLocPrescData","","")
ClassMethod GetLocPrescDataExecute(ByRef qHandle As %Binary, SDate = "", EndDate = "") As %Status
{
	
	//s SDate="2011-12-03"
	//s EndDate="2014-12-03"
	
	s repid=$I(^CacheTemp)
    Set qHandle=$lb(0,repid,0)
    s ind=1
    
    q:SDate="" $$$OK
    q:EndDate="" $$$OK
   
	s node="dhcpha,DHCSTCNTSQUERY,GetLocPrescData"
  	s pid=##class(web.DHCSTCNTSMAIN).GetPHCNTSPID()
	s qstdate=SDate 
	s qenddate=EndDate 
	s:qstdate'="" qstdate=##class(websys.Conversions).DateHtmlToLogical(qstdate)
   	s:qenddate'="" qenddate=##class(websys.Conversions).DateHtmlToLogical(qenddate)
	s pcntstype="F"
	
	
	s h=0
	f date=qstdate:1:qenddate d
	.s typecnt=$l(pcntstype,"^")
	.f i=1:1:typecnt d
	..s type=$p(pcntstype,"^",i)
	..s pcnts=""
	..f  s pcnts=$o(^DHCPHCNTS(0,"Date",date,type,pcnts)) q:pcnts=""  d
	...s chl=""
	...f  s chl=$o(^DHCPHCNTS(pcnts,"I",chl)) q:chl=""  d
	....s prescno=$p(^DHCPHCNTS(pcnts,"I",chl),"^",1)
	....s retdata=..GetPrescNoInfo(prescno)
	....s num=$p(retdata,"^",1)  //处方品种数
	....s bnum=$p(retdata,"^",7) //基本药物
	....s zsnum=$p(retdata,"^",5) //注射剂数
    ....s kjnum=$p(retdata,"^",6) 
    ....i kjnum>0 s kjnum=1
    ....i bnum>0 s bnum=1
    ....i zsnum>0 s zsnum=1
    ....s doclocdr=$p(^DHCPHCNTS(pcnts,"I",chl),"^",4)
	....s orddeptcode=$p(^CTLOC(doclocdr),"^",1)  ;科室代码
    ....s orddept=$p(^CTLOC(doclocdr),"^",2) 
    ....i $f(orddept,"-") s orddept=$p(orddept,"-",2)
    ....s prescnum=1
    ....s amt=##class(web.DHCSTCNTSCOMMON).GetPrescAmt(prescno)
    ....s h=h+1
    ....s index=h
    
    ....s ^TMP(node,pid,"Index",index)=orddept_"^"_kjnum_"^"_prescnum_"^"_amt_"^"_bnum_"^"_zsnum_"^"_num
    
    s x=0 
    s index=""
    f  s index=$o(^TMP(node,pid,"Index",index)) q:index=""  d
    .s data=^TMP(node,pid,"Index",index)
    .s orddept=$p(data,"^",1)
    .s kjnum=$p(data,"^",2)
    .s prescnum=$p(data,"^",3)
    .s amt=$p(data,"^",4)
    .s bnum=$p(data,"^",5)
    .s zsnum=$p(data,"^",6)
    .s num=$p(data,"^",7)
    .d OutRow
    .
    k ^TMP(node,pid)
	Quit $$$OK
OutRow
	set Data=$lb(orddept,kjnum,prescnum,amt,bnum,zsnum,num)    
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
}

ClassMethod GetLocPrescDataFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetLocPrescDataExecute ]
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

Query GetLocPrescData(SDate = "", EndDate = "") As %Query(ROWSPEC = "Tdocloc,Tkjnum:%Integer,Tprescnum:%Integer,Tamt:%Float,Tbnum:%Integer,Tzsnum:%Integer,Tnum:%Integer") [ SqlProc ]
{
}

ClassMethod GetLocPrescDataClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetLocPrescDataExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
    Quit $$$OK
}

// d ##class(%ResultSet).RunQuery("web.DHCSTCNTSQUERY","GetAntPrescData","2011-1-01","2013-12-01")

ClassMethod GetAntPrescDataExecute(ByRef qHandle As %Binary, SDate = "", EndDate = "") As %Status
{
	
	//s SDate="2011-12-03"
	//s EndDate="2014-12-03"
	
	s repid=$I(^CacheTemp)
    Set qHandle=$lb(0,repid,0)
    s ind=1
    
    q:SDate="" $$$OK
    q:EndDate="" $$$OK
   
	s node="dhcpha,DHCSTCNTSQUERY,GetAntPrescData"
  	s pid=##class(web.DHCSTCNTSMAIN).GetPHCNTSPID()
	s qstdate=SDate 
	s qenddate=EndDate 
	s:qstdate'="" qstdate=##class(websys.Conversions).DateHtmlToLogical(qstdate)
   	s:qenddate'="" qenddate=##class(websys.Conversions).DateHtmlToLogical(qenddate)
	s pcntstype="F"
	
	s h=0
	f date=qstdate:1:qenddate d
	.s typecnt=$l(pcntstype,"^")
	.f i=1:1:typecnt d
	..s type=$p(pcntstype,"^",i)
	..s pcnts=""
	..f  s pcnts=$o(^DHCPHCNTS(0,"Date",date,type,pcnts)) q:pcnts=""  d
	...s chl=""
	...f  s chl=$o(^DHCPHCNTS(pcnts,"I",chl)) q:chl=""  d
	....s pcntsitm=pcnts_"||"_chl
	....s prescno=$p(^DHCPHCNTS(pcnts,"I",chl),"^",1)
	....s adm=$p(^DHCPHCNTS(pcnts,"I",chl),"^",3)
	....q:adm=""
	....q:'$d(^PAADM(adm))
	....s papmi=$p(^PAADM(adm),"^",1)
	....s patname=$p(^PAPER(papmi,"ALL"),"^", 1) ;患者姓名
	....s patsex=""
	....s patsexdr=$p(^PAPER(papmi,"ALL"),"^",7 ) 
	....s:patsexdr'="" patsex=$p(^CT("SEX",patsexdr),"^",2 ) ;性别
	....s patno=$p(^PAPER(papmi,"PAT",1),"^",1)
	....s patage=##class(web.DHCSTKUTIL).GetAge(papmi)  ;年龄 
	....s diag=..GetMRDiagnosDesc(adm,"") ;诊断
	....s docdr=$p(^DHCPHCNTS(pcnts,"I",chl),"^",5)
	....s doctorcode=$p(^SSU("SSUSR",docdr),"^",1)  ;医生工号
	....s doctor=$p(^SSU("SSUSR",docdr),"^",2)  ;医生
	....s retdata=..GetPrescNoInfo(prescno)
	....s num=$p(retdata,"^",6)
	....s zsnum=$p(retdata,"^",5) //注射剂数
	....i zsnum>0 d
	.....s zsnum=1
	....e  d
	.....s zsnum=0
	....s linkone=0,linktwo=0,linkthree=0
	....i num=1 s linkone=1
	....i num=2 s linktwo=1
	....i num>2 s linkthree=1  //品种数
	....s result=""
	....s curret=$p(^DHCPHCNTS(pcnts,"I",chl),"^",6) ;结果
	....i curret="Y" d
	.....s result=1
	....i curret="N" d
	.....s result=0 
    ....s doclocdr=$p(^DHCPHCNTS(pcnts,"I",chl),"^",4)
	....s orddeptcode=$p(^CTLOC(doclocdr),"^",1)  ;科室代码
    ....s orddept=$p(^CTLOC(doclocdr),"^",2) 
    ....i $f(orddept,"-") s orddept=$p(orddept,"-",2)
    ....s prescnum=1
    ....s amt=##class(web.DHCSTCNTSCOMMON).GetPrescAmt(prescno)
    ....s orditem=$p(^DHCPHCNTS(pcnts,"I",chl),"^",2)
    ....s prescdate=$p(^OEORD(+orditem),"^",2)
    ....s prescdate=##class(websys.Conversions).DateLogicalToHtml(prescdate)
    ....s presctime=$p(^OEORD(+orditem),"^",3)
    ....s presctime=##class(websys.Conversions).TimeLogicalToHtml(presctime)
    ....s prescdate=prescdate	//_" "_presctime
    ....s ant=##class(web.DHCSTCNTSMAIN).GetAntibioticFlag(orditem)
    ....q:ant'=1
    ....s reasoninfo=..GetCommentRea(orditem,pcntsitm) //不合理原因
	....s reacode=$p(reasoninfo,"^",1)
	....s reason=$p(reasoninfo,"^",2)
	....s sub=$o(^DHCPHCNTS(pcnts,"I",chl,"L",""),-1)
	....s comuser=""
	....i sub'="" d
	.....s userdr=$p(^DHCPHCNTS(pcnts,"I",chl,"L",sub),"^",5)
	.....s comuser=$p(^SSU("SSUSR",userdr),"^",2)
    ....d OutRow
    .
    k ^TMP(node,pid)
	Quit $$$OK
OutRow
	set Data=$lb(prescdate,prescno,orddept,doctor,patage,diag,zsnum,linkone,linktwo,linkthree,amt,result,reacode,reason,comuser)    
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
}

ClassMethod GetAntPrescDataFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAntPrescDataExecute ]
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

Query GetAntPrescData(SDate = "", EndDate = "") As %Query(ROWSPEC = "Tprescdate,Tprescno:%String,Torddept,Tdoctor,Tpatage,Tdiag,Tzsnum,Tlinkone,Tlinktwo,Tlinkthree,Tamt:%Float,Tresult,Treacode,Treason,Tcomuser") [ SqlProc ]
{
}

ClassMethod GetAntPrescDataClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAntPrescDataExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// 获取科室合理处方
/// d ##class(%ResultSet).RunQuery("web.DHCSTCNTSQUERY","GetRLocPresc","","")
ClassMethod GetRLocPrescExecute(ByRef qHandle As %Binary, SDate = "", EndDate = "") As %Status
{
	
	//s SDate="2011-12-03"
	//s EndDate="2014-12-03"
	
	s repid=$I(^CacheTemp)
    Set qHandle=$lb(0,repid,0)
    s ind=1
    
    q:SDate="" $$$OK
    q:EndDate="" $$$OK
   
	s node="dhcpha,DHCSTCNTSQUERY,GetReasonablyLocPresc"
  	s pid=##class(web.DHCSTCNTSMAIN).GetPHCNTSPID()
	s qstdate=SDate 
	s qenddate=EndDate 
	s:qstdate'="" qstdate=##class(websys.Conversions).DateHtmlToLogical(qstdate)
   	s:qenddate'="" qenddate=##class(websys.Conversions).DateHtmlToLogical(qenddate)
	s pcntstype="F"
	
	
	s h=0
	f date=qstdate:1:qenddate d
	.s typecnt=$l(pcntstype,"^")
	.f i=1:1:typecnt d
	..s type=$p(pcntstype,"^",i)
	..s pcnts=""
	..f  s pcnts=$o(^DHCPHCNTS(0,"Date",date,type,pcnts)) q:pcnts=""  d
	...s chl=""
	...f  s chl=$o(^DHCPHCNTS(pcnts,"I",chl)) q:chl=""  d
	....s oknum=0
	....s curret=$p(^DHCPHCNTS(pcnts,"I",chl),"^",6) ;结果
	....i curret="Y" s oknum=1
	....s prescno=$p(^DHCPHCNTS(pcnts,"I",chl),"^",1)
    ....s doclocdr=$p(^DHCPHCNTS(pcnts,"I",chl),"^",4)
	....s orddeptcode=$p(^CTLOC(doclocdr),"^",1)  ;科室代码
    ....s orddept=$p(^CTLOC(doclocdr),"^",2) 
    ....i $f(orddept,"-") s orddept=$p(orddept,"-",2)
    ....s prescnum=1
    ....s h=h+1
    ....d OutRow
    .
    k ^TMP(node,pid)
	Quit $$$OK
OutRow
	set Data=$lb(orddept,prescnum,oknum)    
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
}

ClassMethod GetRLocPrescFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetRLocPrescExecute ]
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

Query GetRLocPresc(SDate = "", EndDate = "") As %Query(ROWSPEC = "Torddept,Tprescnum:%Integer,Toknum:%Integer") [ SqlProc ]
{
}

ClassMethod GetRLocPrescClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetRLocPrescExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// 获取科室不合理处方
/// d ##class(%ResultSet).RunQuery("web.DHCSTCNTSQUERY","GetUnRLocPresc","2016-10-13","2016-10-13")
ClassMethod GetUnRLocPrescExecute(ByRef qHandle As %Binary, SDate = "", EndDate = "") As %Status
{

	s repid=$I(^CacheTemp)
    Set qHandle=$lb(0,repid,0)
    s ind=1
    
    q:SDate="" $$$OK
    q:EndDate="" $$$OK
   
	s node="dhcpha,DHCSTCNTSQUERY,GetReasonablyLocPresc"
  	s pid=##class(web.DHCSTCNTSMAIN).GetPHCNTSPID()
	s qstdate=SDate 
	s qenddate=EndDate 
	s:qstdate'="" qstdate=##class(websys.Conversions).DateHtmlToLogical(qstdate)
   	s:qenddate'="" qenddate=##class(websys.Conversions).DateHtmlToLogical(qenddate)
	s pcntstype="F"
	
	
	s h=0
	f date=qstdate:1:qenddate d
	.s typecnt=$l(pcntstype,"^")
	.f i=1:1:typecnt d
	..s type=$p(pcntstype,"^",i)
	..s pcnts=""
	..f  s pcnts=$o(^DHCPHCNTS(0,"Date",date,type,pcnts)) q:pcnts=""  d
	...s chl=""
	...f  s chl=$o(^DHCPHCNTS(pcnts,"I",chl)) q:chl=""  d
	....s bednum=0
	....s curret=$p(^DHCPHCNTS(pcnts,"I",chl),"^",6) ;结果
	....i curret="N" s bednum=1
	....s prescno=$p(^DHCPHCNTS(pcnts,"I",chl),"^",1)
    ....s doclocdr=$p(^DHCPHCNTS(pcnts,"I",chl),"^",4)
	....s orddeptcode=$p(^CTLOC(doclocdr),"^",1)  ;科室代码
    ....s orddept=$p(^CTLOC(doclocdr),"^",2) 
    ....i $f(orddept,"-") s orddept=$p(orddept,"-",2)
    ....s prescnum=1
    ....s retdata=..GetPrescNoInfo(prescno)
	....s num=$p(retdata,"^",1)
	....s bnum=$p(retdata,"^",7) //基本药物
	....i bnum>0 s bnum=1
    ....s h=h+1
    ....s amt=##class(web.DHCSTCNTSCOMMON).GetPrescAmt(prescno)
    ....s reasonone=0 ,reasontwo=0,reasonthree=0
    ....s prescreasonone=0 ,prescreasontwo=0,prescreasonthree=0
    ....s sub=""
	....f  s sub=$o(^DHCPHCNTS(pcnts,"I",chl,"L",sub)) q:sub=""  d
	.....s active=$p(^DHCPHCNTS(pcnts,"I",chl,"L",sub),"^",11)
	.....q:active'="Y"
	.....s reasondr=$p(^DHCPHCNTS(pcnts,"I",chl,"L",sub),"^",1)
	.....q:reasondr=""
	.....q:'$d(^DHCPCREASON(reasondr))
	.....s wayid=..GetPWayId()
	.....s reasonlevel=..QueryReaFirstLevel(reasondr)
	.....s fristlevel=$o(^DHCPCREASON(0,"Level",wayid,0))
	.....s twolevel=$o(^DHCPCREASON(0,"Level",wayid,fristlevel))
	.....s threelevel=$o(^DHCPCREASON(0,"Level",wayid,twolevel))  //按方式显示的原因,将来如果要出各方式原因汇总,需要按原因代码来汇总
	.....i reasonlevel=fristlevel s reasonone=reasonone+1 , prescreasonone=1
	.....i reasonlevel=twolevel s reasontwo=reasontwo+1, prescreasontwo=1
	.....i reasonlevel=threelevel s reasonthree=reasonthree+1, prescreasonthree=1
    ....d OutRow
    .
    k ^TMP(node,pid)
	Quit $$$OK
OutRow
	set Data=$lb(orddept,prescnum,num,bnum,amt,reasonone,prescreasonone,reasontwo,prescreasontwo,reasonthree,prescreasonthree)    
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
}

ClassMethod GetUnRLocPrescFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetUnRLocPrescExecute ]
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

Query GetUnRLocPresc(SDate = "", EndDate = "") As %Query(ROWSPEC = "orddept,prescnum:%Integer,num:%Integer,bnum:%Integer,amt:%Float,reasonone:%Integer,prescreasonone:%Integer,reasontwo:%Integer,prescreasontwo:%Integer,reasonthree:%Integer,prescreasonthree:%Integer") [ SqlProc ]
{
}

ClassMethod GetUnRLocPrescClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetUnRLocPrescExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// d ##class(%ResultSet).RunQuery("web.DHCSTCNTSQUERY","GetPrescData","","")
/// 处方点评报表
ClassMethod GetPrescDataExecute(ByRef qHandle As %Binary, SDate = "", EndDate = "") As %Status
{
	
	//s SDate="2011-12-03"
	//s EndDate="2014-12-03"
	
	s repid=$I(^CacheTemp)
    Set qHandle=$lb(0,repid,0)
    s ind=1
    
    q:SDate="" $$$OK
    q:EndDate="" $$$OK
   
	s node="dhcpha,DHCSTCNTSQUERY,GetLocPrescData"
  	s pid=##class(web.DHCSTCNTSMAIN).GetPHCNTSPID()
	s qstdate=SDate 
	s qenddate=EndDate 
	s:qstdate'="" qstdate=##class(websys.Conversions).DateHtmlToLogical(qstdate)
   	s:qenddate'="" qenddate=##class(websys.Conversions).DateHtmlToLogical(qenddate)
	s pcntstype="F"
	
	
	s h=0
	f date=qstdate:1:qenddate d
	.s typecnt=$l(pcntstype,"^")
	.f i=1:1:typecnt d
	..s type=$p(pcntstype,"^",i)
	..s pcnts=""
	..f  s pcnts=$o(^DHCPHCNTS(0,"Date",date,type,pcnts)) q:pcnts=""  d
	...s chl=""
	...f  s chl=$o(^DHCPHCNTS(pcnts,"I",chl)) q:chl=""  d
	....s pcntsitm=pcnts_"||"_chl
	....s adm=$p(^DHCPHCNTS(pcnts,"I",chl),"^",3)
	....s papmi=$p(^PAADM(adm),"^",1)
	....s patname=$p(^PAPER(papmi,"ALL"),"^", 1) ;患者姓名
	....s sex=$p(^PAPER(papmi,"ALL"),"^",7 ) ;姓别
	....s patsex=$p(^CT("SEX",sex),"^",2)
	....s patno=$p(^PAPER(papmi,"PAT",1),"^",1)
	....s patage=##class(web.DHCSTKUTIL).GetAge(papmi)  ;年龄   
    ....s diag=..GetMRDiagnosDesc(adm,",") ;诊断
    ....i $f(diag,$c(13)) s diag=$p(diag,$c(13),1)
    ....s orditem=$p(^DHCPHCNTS(pcnts,"I",chl),"^",2)
	....s ord=$p(orditem,"||",1)
	....s itm=$p(orditem,"||",2)
	....s orddate=$p(^OEORD(ord,"I",itm,3),"^",7)
	....i orddate'="" s orddate=##class(websys.Conversions).DateLogicalToHtml(orddate)  //处方日期
	....s prescno=$p(^DHCPHCNTS(pcnts,"I",chl),"^",1)
	....s retdata=..GetPrescNoInfo(prescno)
	....s num=$p(retdata,"^",1)  //处方品种数
	....s pyuser=$p(retdata,"^",3) //配药人
	....s fyuser=$p(retdata,"^",4) //发药人
	....s bnum=$p(retdata,"^",7) //基本药物
	....s zsnum=$p(retdata,"^",5) //注射剂数
    ....s kjnum=$p(retdata,"^",6)  //抗菌药数
    ....s gernum=$p(retdata,"^",8) //通用药品名数
    ....i kjnum>0 s kjnum=1
    ....i bnum>0 s bnum=1
    ....i zsnum>0 s zsnum=1
    ....;i gernum>0 s gernum=1
    ....s doclocdr=$p(^DHCPHCNTS(pcnts,"I",chl),"^",4)
	....s orddeptcode=$p(^CTLOC(doclocdr),"^",1)  ;科室代码
    ....s orddept=$p(^CTLOC(doclocdr),"^",2) 
    ....i $f(orddept,"-") s orddept=$p(orddept,"-",2)
    ....s prescnum=1
    ....s docdr=$p(^DHCPHCNTS(pcnts,"I",chl),"^",5)
	....s doctor=$p(^SSU("SSUSR",docdr),"^",2)  ;医生
    ....s amt=##class(web.DHCSTCNTSCOMMON).GetPrescAmt(prescno)
    ....s reasoninfo=..GetCommentRea(orditem,pcntsitm) //不合理原因
	....s reacode=$p(reasoninfo,"^",1)
	....s reason=$p(reasoninfo,"^",2)
	....s curret=$p(^DHCPHCNTS(pcnts,"I",chl),"^",6) ;结果
	....i curret="Y" s curret=1
	....i curret="N" s curret=0
	....;e  s curret=0
	....s sub=$o(^DHCPHCNTS(pcnts,"I",chl,"L",""),-1)
	....s comuser=""
	....i sub'="" d
	.....s userdr=$p(^DHCPHCNTS(pcnts,"I",chl,"L",sub),"^",5)
	.....s comuser=$p(^SSU("SSUSR",userdr),"^",2)
	....s h=h+1
    ....d OutRow
    .
    k ^TMP(node,pid)
	Quit $$$OK
OutRow
	set Data=$lb(h,prescno,orddept,patno,patname,patsex,patage,diag,num,kjnum,zsnum,bnum,gernum,amt,doctor,pyuser,fyuser,orddate,curret,reacode,reason,comuser)    
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
}

ClassMethod GetPrescDataFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPrescDataExecute ]
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

Query GetPrescData(SDate = "", EndDate = "") As %Query(ROWSPEC = "h:%Integer,prescno,orddept,patno,patname,patsex,patage,diag,num:%Integer,kjnum:%Integer,zsnum:%Integer,bnum:%Integer,gernum:%Integer,amt:%Float,doctor,pyuser,fyuser,orddate,curret:%Integer,reacode,reason,comuser") [ SqlProc ]
{
}

ClassMethod GetPrescDataClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPrescDataExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// d ##class(%ResultSet).RunQuery("web.DHCSTCNTSQUERY","GetOutDetail","","")
/// 门诊处方点评报表
ClassMethod GetOutDetailExecute(ByRef qHandle As %Binary, SDate = "", EndDate = "") As %Status
{
	
	//s SDate="2011-12-03"
	//s EndDate="2014-12-03"
	
	s repid=$I(^CacheTemp)
    Set qHandle=$lb(0,repid,0)
    s ind=1
    
    q:SDate="" $$$OK
    q:EndDate="" $$$OK
   
	s node="dhcpha,DHCSTCNTSQUERY,GetLocPrescData"
  	s pid=##class(web.DHCSTCNTSMAIN).GetPHCNTSPID()
	s qstdate=SDate 
	s qenddate=EndDate 
	s:qstdate'="" qstdate=##class(websys.Conversions).DateHtmlToLogical(qstdate)
   	s:qenddate'="" qenddate=##class(websys.Conversions).DateHtmlToLogical(qenddate)
	s pcntstype="F"
	s tmpstr=""
	s HospID=""
	s h=0
	f date=qstdate:1:qenddate d
	.s typecnt=$l(pcntstype,"^")
	.f i=1:1:typecnt d
	..s type=$p(pcntstype,"^",i)
	..s pcnts=""
	..f  s pcnts=$o(^DHCPHCNTS(0,"Date",date,type,pcnts)) q:pcnts=""  d
	...s pcntsno=$p(^DHCPHCNTS(pcnts),"^",1)
	...//q:(qcomnostr'="")&(..CheckComNo(qcomnostr,pcntsno)=0)
	...s pcntsdate=$p(^DHCPHCNTS(pcnts),"^",2)
	...i pcntsdate'="" s pcntsdate=##class(websys.Conversions).DateLogicalToHtml(pcntsdate)
	...s pcntstime=$p(^DHCPHCNTS(pcnts),"^",3)
	...i pcntstime'="" s pcntstime=##class(websys.Conversions).TimeLogicalToHtml(pcntstime)
	...s pcntstext=$p(^DHCPHCNTS(pcnts),"^",4)
	...s pcntsuserdr=$p(^DHCPHCNTS(pcnts),"^",6)
	...s pcntsuser=$p(^SSU("SSUSR",pcntsuserdr),"^",2)
	...i type="F" s typedesc="门诊"
	...i type="P" s typedesc="住院"
	...s chl=""
	...f  s chl=$o(^DHCPHCNTS(pcnts,"I",chl)) q:chl=""  d
	....s pcntsitm=pcnts_"||"_chl
	....s prescno=$p(^DHCPHCNTS(pcnts,"I",chl),"^",1)
	....s orditem=$p(^DHCPHCNTS(pcnts,"I",chl),"^",2)
	....s ord=$p(orditem,"||",1)
	....s itm=$p(orditem,"||",2)
	....s adm=$p(^DHCPHCNTS(pcnts,"I",chl),"^",3)
	....s papmi=$p(^PAADM(adm),"^",1)
	....s patname=$p(^PAPER(papmi,"ALL"),"^", 1) ;患者姓名
	....s sex=$p(^PAPER(papmi,"ALL"),"^",7 ) ;姓别
	....s patsex=$p(^CT("SEX",sex),"^",2)
	....s patno=$p(^PAPER(papmi,"PAT",1),"^",1)
	....s patage=##class(web.DHCSTKUTIL).GetAge(papmi)  ;年龄   
    ....s diag=..GetMRDiagnosDesc(adm,",") ;诊断
    ....//i $f(diag,$c(13)) s diag=$p(diag,$c(13),1)
    ....s billtype=""
    ....s billtypedr=+$p(^PAPER(papmi,"PER",1),"^",10)
    ....s:billtypedr'="" billtype=$p(^CT("SS",billtypedr),"^",2)
	....s doclocdr=$p(^DHCPHCNTS(pcnts,"I",chl),"^",4)
	....s orddeptcode=$p(^CTLOC(doclocdr),"^",1)  ;科室代码
    ....s orddept=$p(^CTLOC(doclocdr),"^",2)  
    ....//q:..ChkDocLocStr(qdoclocdr,doclocdr)=0 ;科室
	....i $f(orddept,"-") s orddept=$p(orddept,"-",2)
	....i HospID="" s HospID=$p(^CTLOC(doclocdr),"^",22)
	....s docdr=$p(^DHCPHCNTS(pcnts,"I",chl),"^",5)
	....s doctorcode=$p(^SSU("SSUSR",docdr),"^",1)  ;医生工号
	....s doctor=$p(^SSU("SSUSR",docdr),"^",2)  ;医生
	....s curret=$p(^DHCPHCNTS(pcnts,"I",chl),"^",6) ;结果
	....//q:(qresult=1)&(curret'="Y")
	....//q:(qresult=2)&(curret'="N")
	....//q:(qresult=4)&(curret="") //仅有结果
	....i curret="Y" s curret="合理"
	....i curret="N" s curret="不合理"
	....s username=""
	....s sub=$o(^DHCPHCNTS(pcnts,"I",chl,"L",""),-1)
	....i sub'="" d
	.....s userdr=$p(^DHCPHCNTS(pcnts,"I",chl,"L",sub),"^",5)
	.....s username=$p(^SSU("SSUSR",userdr),"^",2)
	....s chkstr=..ChkItmByPrescNo(prescno,tmpstr)
	....//s chkflag=$p(chkstr,"^",1)
	....//q:chkflag=0  //检查包含项目是否符合
	....s prescamt=$p(chkstr,"^",2)  //处方金额
	....s sumantamt=$p(chkstr,"^",3)
	....s antamtcent=$p(chkstr,"^",4)
	....s sumbasamt=$p(chkstr,"^",5)
	....s basamtcent=$p(chkstr,"^",6)
	....s reasoninfo=..GetCommentRea(orditem,pcntsitm) //不合理原因
	....s reacode=$p(reasoninfo,"^",1)
	....s reason=$p(reasoninfo,"^",2)
	....s phadvice=$p(reasoninfo,"^",3)
	....s phnote=$p(reasoninfo,"^",4)
	....s ord=""
	....f  s ord=$o(^OEORD(0,"PrescNo",prescno,ord))  q:ord=""  d
	.....s itm=""
    .....f  s itm=$o(^OEORD(0,"PrescNo",prescno,ord,itm)) q:itm=""  d
    ......s arcitm=$p(^OEORD(ord,"I",itm,1),"^",2)
    ......s inci=$o(^INCI(0,"ARCIM_DR",$p(arcitm,"||",1),""))
    ......s orditm=ord_"||"_itm
    ......//药品
	......s arcimid=$p(^OEORD(ord,"I",itm,1),"^",2)  ;医嘱 ARC_ItmMast ARCIM_RowId
	......s itmmastid=$p(arcimid,"||",1)
	......s itmmastver=$p(arcimid,"||",2)
	......s inci=$o(^INCI(0,"ARCIM_DR",$p(arcimid,"||",1),"") ) q:inci=""  //医嘱名称
	......s incidesc=$p(^INCI(inci,1),"^",2) //药品名称
	......s dsp=$o(^DHCOEDISQTY(0,"OEORI",orditm,""))
	......q:dsp=""
    ......s qty=$p(^DHCOEDISQTY(dsp),"^",2)
    ......s findflag=1
	......s:findflag=1 puomdr=$p(^ARCIM(itmmastid,itmmastver,8),"^",14)
	......s:findflag=2 puomdr=+$p(^INCI(inci,3),"^",6)
	......s buomdr=+$p(^INCI(inci,1),"^",10)
	......s fac=+##Class(web.DHCSTCOMMONSRV).UOMFac(puomdr,buomdr)
	......s uomdr=buomdr
	......i (qty#fac)=0 d
	.......s qty=qty/fac   //数量
	......s uomdr=puomdr 
	......s uomdesc=$p($g(^CT("UOM",uomdr)),"^",2) //单位
	......s dosage=$j($p(^OEORD(ord,"I",itm,2),"^",1)," ",3) ;剂量
    ......s doseuom=""
	......s dosuomID=$p(^OEORD(ord,"I",itm,2),"^",3)
	......i dosuomID'="" d
	.......s doseuom=$p($g(^CT("UOM",dosuomID)),"^",2) ;剂量单位
	......s dosage=dosage_doseuom
	......s freq=""
	......s freqdr=$p($g(^OEORD(ord,"I",itm,2)),"^",4) ;OEORI_PHFreq_DR
    ......i freqdr'="" s freq=$p($g(^PHCFR(freqdr)),"^",3)  ;频率
    ......s instru=$p(^PHCIN($p(^OEORD(ord,"I",itm,2),"^",7)),"^",2)        	;用法
	......s duration=$p(^PHCDU($p(^OEORD(ord,"I",itm,2),"^",6)),"^",1)         	;用药疗程
	......s skintest=##class(web.DHCSTCOMMONSRV).GetSkinTestResult(orditm)  ;皮试
	......s incidesc=skintest_incidesc
	......s remark=##class(web.DHCSTCOMMONSRV).GetOrdItmRemark(orditm) ;备注
	......s retdata=..GetPrescNoInfo(prescno)
	......s pyuser=$p(retdata,"^",3) //配药人
	......s fyuser=$p(retdata,"^",4) //发药人
	......s dspdate=+$h 
	......s status=$p(^DHCOEDISQTY(dsp),"^",7)
	......i status="C" s dspdate=$p(^DHCOEDISQTY(dsp),"^",8)
	......//s price=##class(web.DHCSTCOMMONSRV).GetPriceElse(+inci,dspdate,puomdr,"")
	......s exStr="^"_dsp
	......s price=##class(web.DHCSTPRICE).GetSp(+inci,dspdate,puomdr,HospID,"",exStr)	//zhouyg 20150113
	......s amt=$fn(price*qty,"",2)
	......s h=h+1
    ......d OutRow
    .
    k ^TMP(node,pid)
	Quit $$$OK
OutRow
	set Data=$lb(h,prescno,billtype,patno,patname,patsex,patage,diag,orddeptcode,orddept,doctorcode,doctor,incidesc,qty,uomdesc,dosage,freq,instru,duration,remark,price,amt,prescamt,sumantamt,antamtcent,sumbasamt,basamtcent,curret,reacode,reason,pyuser,fyuser,username)    
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
}

ClassMethod GetOutDetailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetOutDetailExecute ]
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

Query GetOutDetail(SDate = "", EndDate = "") As %Query(ROWSPEC = "h:%Integer,prescno,billtype,patno,patname,patsex,patage,diag,orddeptcode,orddept,doctorcode,doctor,incidesc,qty:%Float,uomdesc,dosage,freq,instru,duration,remark,price:%Float,amt:%Float,prescamt:%Float,sumantamt:%Float,antamtcent:%Float,sumbasamt:%Float,basamtcent:%Float,curret,reacode,reason,pyuser,fyuser,username") [ SqlProc ]
{
}

ClassMethod GetOutDetailClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetOutDetailExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// d ##class(%ResultSet).RunQuery("web.DHCSTCNTSQUERY","GetPhaLocPrescData","",""
/// 处方用药基本信息统计，按药房
ClassMethod GetPhaLocPrescDataExecute(ByRef qHandle As %Binary, SDate = "", EndDate = "") As %Status
{
	
	//s SDate="2011-12-03"
	//s EndDate="2014-12-03"
	
	s repid=$I(^CacheTemp)
    Set qHandle=$lb(0,repid,0)
    s ind=1
    
    q:SDate="" $$$OK
    q:EndDate="" $$$OK
   
	s node="dhcpha,DHCSTCNTSQUERY,GetLocPrescData"
  	s pid=##class(web.DHCSTCNTSMAIN).GetPHCNTSPID()
	s qstdate=SDate 
	s qenddate=EndDate 
	s:qstdate'="" qstdate=##class(websys.Conversions).DateHtmlToLogical(qstdate)
   	s:qenddate'="" qenddate=##class(websys.Conversions).DateHtmlToLogical(qenddate)
	s pcntstype="F"
	
	
	s h=0
	f date=qstdate:1:qenddate d
	.s typecnt=$l(pcntstype,"^")
	.f i=1:1:typecnt d
	..s type=$p(pcntstype,"^",i)
	..s pcnts=""
	..f  s pcnts=$o(^DHCPHCNTS(0,"Date",date,type,pcnts)) q:pcnts=""  d
	...s chl=""
	...f  s chl=$o(^DHCPHCNTS(pcnts,"I",chl)) q:chl=""  d
	....s pcntsitm=pcnts_"||"_chl
	....s adm=$p(^DHCPHCNTS(pcnts,"I",chl),"^",3)
	....s papmi=$p(^PAADM(adm),"^",1)
	....s patname=$p(^PAPER(papmi,"ALL"),"^", 1) ;患者姓名
	....s sex=$p(^PAPER(papmi,"ALL"),"^",7 ) ;姓别
	....s patsex=$p(^CT("SEX",sex),"^",2)
	....s patno=$p(^PAPER(papmi,"PAT",1),"^",1)
	....s patage=##class(web.DHCSTKUTIL).GetAge(papmi)  ;年龄   
    ....s diag=..GetMRDiagnosDesc(adm,",") ;诊断
    ....//i $f(diag,$c(13)) s diag=$p(diag,$c(13),1)
    ....s orditem=$p(^DHCPHCNTS(pcnts,"I",chl),"^",2)
	....s ord=$p(orditem,"||",1)
	....s itm=$p(orditem,"||",2)
	....s orddate=$p(^OEORD(ord,"I",itm,3),"^",7)
	....i orddate'="" s orddate=##class(websys.Conversions).DateLogicalToHtml(orddate)  //处方日期
	....s prescno=$p(^DHCPHCNTS(pcnts,"I",chl),"^",1)
	....s retdata=..GetPrescNoInfo(prescno)
	....s num=$p(retdata,"^",1)  //处方品种数
	....s amt=$p(retdata,"^",2)  //处方金额
	....s pyuser=$p(retdata,"^",3) //配药人
	....s fyuser=$p(retdata,"^",4) //发药人
	....s bnum=$p(retdata,"^",7) //基本药物
	....s zsnum=$p(retdata,"^",5) //注射剂数
    ....s kjnum=$p(retdata,"^",6)  //抗菌药数
    ....s gernum=$p(retdata,"^",8) //通用药品名数
    ....i kjnum>0 s kjnum=1
    ....i bnum>0 s bnum=1
    ....i zsnum>0 s zsnum=1
    ....
    ....s doclocdr=$p(^DHCPHCNTS(pcnts,"I",chl),"^",4)
	....s orddeptcode=$p(^CTLOC(doclocdr),"^",1)  ;科室代码
    ....s orddept=$p(^CTLOC(doclocdr),"^",2) 
    ....i $f(orddept,"-") s orddept=$p(orddept,"-",2)
    ....s prescnum=1
    ....s docdr=$p(^DHCPHCNTS(pcnts,"I",chl),"^",5)
	....s doctor=$p(^SSU("SSUSR",docdr),"^",2)  ;医生
    ....s amt=##class(web.DHCSTCNTSCOMMON).GetPrescAmt(prescno)
    ....s reasoninfo=..GetCommentRea(orditem,pcntsitm) //不合理原因
	....s reacode=$p(reasoninfo,"^",1)
	....s reason=$p(reasoninfo,"^",2)
	....s curret=$p(^DHCPHCNTS(pcnts,"I",chl),"^",6) ;结果
	....i curret="Y" s curret=1
	....e  s curret=0
	....s sub=$o(^DHCPHCNTS(pcnts,"I",chl,"L",""),-1)
	....s comuser=""
	....i sub'="" d
	.....s userdr=$p(^DHCPHCNTS(pcnts,"I",chl,"L",sub),"^",5)
	.....s comuser=$p(^SSU("SSUSR",userdr),"^",2)
	....s reclocdr=$p(^OEORD(ord,"I",itm,3),"^",6)
	....s recloc=$p(^CTLOC(reclocdr),"^",2)
	....s phalocnum=1
    ....d OutRow
    .
    k ^TMP(node,pid)
    &sql(select MAX(CONVERT (int,RIGHT(inci_code,3) )) AS MaxValue from inc_itm where   %ALPHAUP(inci_code) %STARTSWITH %ALPHAUP(:inputs))
	Quit $$$OK
OutRow
	set Data=$lb(recloc,phalocnum,num,amt,kjnum,bnum,zsnum,gernum)    
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
}

ClassMethod GetPhaLocPrescDataFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPhaLocPrescDataExecute ]
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

Query GetPhaLocPrescData(SDate = "", EndDate = "") As %Query(ROWSPEC = "recloc,phalocnum:%Integer,num:%Integer,amt:%Float,kjnum:%Integer,bnum:%Integer,zsnum:%Integer,gernum:%Integer") [ SqlProc ]
{
}

ClassMethod GetPhaLocPrescDataClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPhaLocPrescDataExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// d ##class(%ResultSet).RunQuery("web.DHCSTCNTSQUERY","GetIPDetailData","","")
/// 往院医嘱点评明细统计
ClassMethod GetIPDetailDataExecute(ByRef qHandle As %Binary, SDate = "", EndDate = "") As %Status
{
	
	//s SDate="2011-12-03"
	//s EndDate="2014-12-03"
	
	s repid=$I(^CacheTemp)
    Set qHandle=$lb(0,repid,0)
    s ind=1
    
    q:SDate="" $$$OK
    q:EndDate="" $$$OK
    s locstr=##class(web.DHCSTCNTSCOMMON).GetPhaLocStr()
	s node="dhcpha,DHCSTCNTSQUERY,GetIPDetailData"
  	s pid=##class(web.DHCSTCNTSMAIN).GetPHCNTSPID()
	s qstdate=SDate 
	s qenddate=EndDate 
	s:qstdate'="" qstdate=##class(websys.Conversions).DateHtmlToLogical(qstdate)
   	s:qenddate'="" qenddate=##class(websys.Conversions).DateHtmlToLogical(qenddate)
	s HospID=""
	s type="P"
	f date=qstdate:1:qenddate d
	.s pcnts=""
	.f  s pcnts=$o(^DHCPHCNTS(0,"Date",date,type,pcnts)) q:pcnts=""  d
	..s pcntsno=$p(^DHCPHCNTS(pcnts),"^",1)
	..s pcntsdate=$p(^DHCPHCNTS(pcnts),"^",2)
	..i pcntsdate'="" s pcntsdate=##class(websys.Conversions).DateLogicalToHtml(pcntsdate)
	..s pcntstime=$p(^DHCPHCNTS(pcnts),"^",3)
	..i pcntstime'="" s pcntstime=##class(websys.Conversions).TimeLogicalToHtml(pcntstime)
	..s pcntstext=$p(^DHCPHCNTS(pcnts),"^",4)
	..s pcntsuserdr=$p(^DHCPHCNTS(pcnts),"^",6)
	..s pcntsuser=$p(^SSU("SSUSR",pcntsuserdr),"^",2)
	..s tchl=""
	..f  s tchl=$o(^DHCPHCNTS(pcnts,"I",tchl)) q:tchl=""  d
	...s pcntsitm=pcnts_"||"_tchl
	...s curret=$p(^DHCPHCNTS(pcnts,"I",tchl),"^",6)
	...//q:(qresult=1)&(curret'="Y")
	...//q:(qresult=2)&(curret'="N")
	...//q:(qresult=4)&(curret="") //仅有结果
	...i curret="Y" s curret="合理"
	...i curret="N" s curret="不合理"
	...s prescno=$p(^DHCPHCNTS(pcnts,"I",tchl),"^",1)
	...s adm=$p(^DHCPHCNTS(pcnts,"I",tchl),"^",3)
	...s papmi=$p(^PAADM(adm),"^",1)
	...s patname=$p(^PAPER(papmi,"ALL"),"^", 1) ;患者姓名
	...s sex=$p(^PAPER(papmi,"ALL"),"^",7 ) ;姓别
	...s patsex=$p(^CT("SEX",sex),"^",2)
	...s patno=$p(^PAPER(papmi,"PAT",1),"^",1)
	...s patage=##class(web.DHCSTKUTIL).GetAge(papmi)  ;年龄   
    ...s diag=..GetMRDiagnosDesc(adm,",") ;诊断
    ...//i $f(diag,$c(13)) s diag=$p(diag,$c(13),1)
    ...s billtype=""
    ...s billtypedr=+$p(^PAPER(papmi,"PER",1),"^",10)
    ...s:billtypedr'="" billtype=$p(^CT("SS",billtypedr),"^",2)
	...s doclocdr=$p(^DHCPHCNTS(pcnts,"I",tchl),"^",4)
	...s orddeptcode="",orddept=""
	...i doclocdr'="" d
	....s orddeptcode=$p(^CTLOC(doclocdr),"^",1)  ;科室代码
    ....s orddept=$p(^CTLOC(doclocdr),"^",2)
    ...s ord=$o(^OEORD(0,"Adm",adm,""))  q:ord="" 
	...s cnt=$l(locstr,"^")
	...f i=1:1:cnt d
	....s recdpdr=$p(locstr,"^",i)
	....i (HospID="")&(recdpdr'="") s HospID=$p($g(^CTLOC(recdpdr)),"^",22)
	....s chl=""
	....f  s chl=$o(^OEORDi(0,"RecDepOrd",ord,recdpdr,chl)) q:chl=""  d
	.....s orditm=ord_"||"_chl
	.....s qty=##class(web.DHCSTCNTSCOMMON).GetDspQty(orditm)
	.....q:qty=0
	.....s arcimid=$p(^OEORD(ord,"I",chl,1),"^",2)  ;医嘱 ARC_ItmMast ARCIM_RowId
	.....s itmmastid=$p(arcimid,"||",1)
	.....s itmmastver=$p(arcimid,"||",2)
	.....s inci=$o(^INCI(0,"ARCIM_DR",$p(arcimid,"||",1),"") ) q:inci=""  //医嘱名称
	.....s inciDesc=$p(^INCI(inci,1),"^",2) //药品名称
	.....s puomdr=+$p(^INCI(inci,3),"^",6)
	.....s buomdr=+$p(^INCI(inci,1),"^",10)
	.....s fac=+##Class(web.DHCSTCOMMONSRV).UOMFac(puomdr,buomdr)
	.....s uomdr=buomdr
	.....i (qty#fac)=0 d
	......s qty=qty/fac   //数量
	......s uomdr=puomdr 
	.....s uomdesc=$p($g(^CT("UOM",uomdr)),"^",2) //单位
	.....s dosage=$j($p(^OEORD(ord,"I",chl,2),"^",1)," ",3) ;剂量
    .....s doseuom=""
	.....s dosuomID=+$p(^OEORD(ord,"I",chl,2),"^",3)
	.....i dosuomID'=0 d
	......s doseuom=$p($g(^CT("UOM",dosuomID)),"^",2) ;剂量单位
	.....s freq=""
	.....s freqdr=+$p($g(^OEORD(ord,"I",chl,2)),"^",4) ;OEORI_PHFreq_DR
    .....i freqdr'=0 s freq=$p($g(^PHCFR(freqdr)),"^",3)  ;频率
    .....s instru=""
    .....s instrudr=+$p(^OEORD(ord,"I",chl,2),"^",7)
    .....s:instrudr'=0 instru=$p(^PHCIN(instrudr),"^",2)        	;用法
    .....s duration=""
    .....s dur=+$p(^OEORD(ord,"I",chl,2),"^",6)
	.....s:dur'=0 duration=$p(^PHCDU(dur),"^",1)         	;用药疗程
	.....s priorty=""
	.....s pri=+$p(^OEORD(ord,"I",chl,1),"^",8)
	.....s:pri'=0 priorty=$p(^OECPR(pri),"^",2)   		;医嘱优先级
	.....s doctor=##class(web.DHCSTCOMMONSRV).getOrdDoctor(orditm)       ;医生
	.....s skintest=##class(web.DHCSTCOMMONSRV).GetSkinTestResult(orditm)  ;皮试
	.....s:skintest'="" incidesc=skintest_" "_inciDesc
	.....s form=##class(web.DHCSTCOMMONSRV).GetForm(inci)  ;剂型
	.....i $F(form,$c(13)) s form=$p(form,$c(13))
	.....s spec=##class(web.DHCSTCOMMONSRV).getBarcode(inci) ;规格
	.....s manf=##class(web.DHCSTITMDESC).GetManfNameByInci(inci) ;厂家
	.....i $f(manf,"-") s manf=$p(manf,"-",2)
	.....s remark=##class(web.DHCSTCOMMONSRV).GetOrdItmRemark(orditm) ;备注
	.....s dsp=$o(^DHCOEDISQTY(0,"OEORI",orditm,""))
    .....s orddate=$p(^DHCOEDISQTY(dsp),"^",21)
    .....i orddate'="" s orddate=##class(websys.Conversions).DateLogicalToHtml(orddate)
    .....s ordtime=$p(^DHCOEDISQTY(dsp),"^",20)
    .....i ordtime'="" s ordtime=##class(websys.Conversions).TimeLogicalToHtml(ordtime)
    .....s orddatetime=orddate_" "_ordtime  ;开单日期
    .....s reasoncode=""
    .....s reason=##class(web.DHCSTCNTSIPDATA).GetMainCommentReason(orditm,pcntsitm)
    .....s dspdate=$p(^DHCOEDISQTY(dsp),"^",8)
    .....//s price=##class(web.DHCSTCOMMONSRV).GetPriceElse(+inci,dspdate,uomdr,"")
    .....s exStr="^"_dsp
    .....s price=##class(web.DHCSTPRICE).GetSp(+inci,dspdate,uomdr,HospID,"",exStr)	//zhouyg 20150113
	.....s amt=$fn(price*qty,"",2)
	.....s basflag=""
	.....s infor=$o(^DHCITMINFO(0,"INCI",inci,""))
	.....s phcdfId=$p(^ARCIM(itmmastid,itmmastver,1),"^",12)
	.....s:phcdfId'="" basflag=$p(^PHCD(+phcdfId,"DF",+$p(phcdfId,"||",2),"DHC"),"^",31)
	.....i basflag="" s basflag="N"
	.....s advice="",phnote="",username=""
	.....s tsub=$o(^DHCPHCNTS(pcnts,"I",tchl,"L",""),-1)
	.....i tsub'="" d
	......s advicedr=$p(^DHCPHCNTS(pcnts,"I",tchl,"L",tsub),"^",6)
	......i advicedr'="" s advice=$p(^DHCPCADVICE(advicedr),"^",2)
	......s phnote=$p(^DHCPHCNTS(pcnts,"I",tchl,"L",tsub),"^",9)
	......s userdr=$p(^DHCPHCNTS(pcnts,"I",tchl,"L",tsub),"^",5)
	......s username=$p(^SSU("SSUSR",userdr),"^",2)
    .....d OutRow
    .
    k ^TMP(node,pid)
	Quit $$$OK
OutRow
    set Data=$lb(patno,patname,patage,patsex,billtype,diag,inciDesc,qty,uomdesc,dosage,doseuom,freq,instru,priorty,doctor,remark,curret,reasoncode,reason,basflag,price,amt,username)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
}

ClassMethod GetIPDetailDataFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetIPDetailDataExecute ]
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

Query GetIPDetailData(SDate = "", EndDate = "") As %Query(ROWSPEC = "patno,patname,patage,patsex,billtype,diag,inciDesc,qty:%Float,uomdesc,dosage,doseuom,freq,instru,priorty,doctor,remark,curret,reasoncode,reason,basflag,price:%Float,amt:%Float,username") [ SqlProc ]
{
}

ClassMethod GetIPDetailDataClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetIPDetailDataExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// d ##class(%ResultSet).RunQuery("web.DHCSTCNTSQUERY","QueryIPRationalUseData","2017-12-01","2018-01-27")
/// 住院医嘱点评合理用药指标
ClassMethod QueryIPRationalUseDataExecute(ByRef qHandle As %Binary, SDate = "", EndDate = "") As %Status
{
	
	//s SDate="2011-12-03"
	//s EndDate="2014-12-03"

	
	s repid=$I(^CacheTemp)
    Set qHandle=$lb(0,repid,0)
    s ind=1
    s node="dhcpha,DHCSTCNTSQUERY,GetIPRationalUseData"
    q:SDate="" $$$OK
    q:EndDate="" $$$OK
    
    S SDate=$p(SDate,"-",3)_"/"_$p(SDate,"-",2)_"/"_$p(SDate,"-",1)
	S EndDate=$p(EndDate,"-",3)_"/"_$p(EndDate,"-",2)_"/"_$p(EndDate,"-",1)
	
    s QueryStr=SDate_"^"_EndDate
    s retdata=..GetIPRationalUseData(QueryStr)
    s cnt=$p(retdata,"^",1)
    s pid=$p(retdata,"^",2)
    q:pid="" $$$OK
    f i=1:1:cnt d
    .s data=^TMP(node,pid,"Itm",i)
    .s ctloc=$p(data,"^",1)
    .s num1=$p(data,"^",2)
    .s num2=$p(data,"^",3)
    .s num3=$p(data,"^",4)
    .s num4=$p(data,"^",5)
    .s num5=$p(data,"^",6)
    .d OutRow
    
    k ^TMP(node,pid)
	Quit $$$OK
OutRow
    set Data=$lb(ctloc,num1,num2,num3,num4,num5)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
}

ClassMethod QueryIPRationalUseDataFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryIPRationalUseDataExecute ]
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

Query QueryIPRationalUseData(SDate = "", EndDate = "") As %Query(ROWSPEC = "ctloc,num1:%Float,num2:%Float,num3:%Float,num4:%Float,num5:%Float") [ SqlProc ]
{
}

ClassMethod QueryIPRationalUseDataClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryIPRationalUseDataExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// 医生点评情况报表
/// d ##class(%ResultSet).RunQuery("web.DHCSTCNTSQUERY","GetDoctorData","","")
ClassMethod GetDoctorDataExecute(ByRef qHandle As %Binary, SDate = "", EndDate = "") As %Status
{
	
	//s SDate="2011-12-03"
	//s EndDate="2014-12-03"
	
	s repid=$I(^CacheTemp)
    Set qHandle=$lb(0,repid,0)
    s ind=1
    
    q:SDate="" $$$OK
    q:EndDate="" $$$OK
   
	s node="dhcpha,DHCSTCNTSQUERY,GetDoctorData"
  	s pid=##class(web.DHCSTCNTSMAIN).GetPHCNTSPID()
	s qstdate=SDate 
	s qenddate=EndDate 
	s:qstdate'="" qstdate=##class(websys.Conversions).DateHtmlToLogical(qstdate)
   	s:qenddate'="" qenddate=##class(websys.Conversions).DateHtmlToLogical(qenddate)
	s pcntstype="F"
	
	
	s h=0
	f date=qstdate:1:qenddate d
	.s typecnt=$l(pcntstype,"^")
	.f i=1:1:typecnt d
	..s type=$p(pcntstype,"^",i)
	..s pcnts=""
	..f  s pcnts=$o(^DHCPHCNTS(0,"Date",date,type,pcnts)) q:pcnts=""  d
	...s chl=""
	...f  s chl=$o(^DHCPHCNTS(pcnts,"I",chl)) q:chl=""  d
	....s prescno=$p(^DHCPHCNTS(pcnts,"I",chl),"^",1)
	....s retdata=..GetPrescNoInfo(prescno)
	....s num=$p(retdata,"^",1)  //处方品种数
	....s bnum=$p(retdata,"^",7) //基本药物
	....s zsnum=$p(retdata,"^",5) //注射剂数
    ....s kjnum=$p(retdata,"^",6) 
    ....i kjnum>0 s kjnum=1
    ....i bnum>0 s bnum=1
    ....i zsnum>0 s zsnum=1
    ....s doctor="无名"
    ....s doctordr=$p(^DHCPHCNTS(pcnts,"I",chl),"^",5)
    ....s:doctordr'="" doctor=$p(^SSU("SSUSR",doctordr),"^",2)
    ....s prescnum=1
    ....s amt=##class(web.DHCSTCNTSCOMMON).GetPrescAmt(prescno)
    ....s h=h+1
    ....s index=h
    ....s ^TMP(node,pid,"Index",index)=doctor_"^"_kjnum_"^"_prescnum_"^"_amt_"^"_bnum_"^"_zsnum_"^"_num
    
    s x=0 
    s index=""
    f  s index=$o(^TMP(node,pid,"Index",index)) q:index=""  d
    .s data=^TMP(node,pid,"Index",index)
    .s orddept=$p(data,"^",1)
    .s kjnum=$p(data,"^",2)
    .s prescnum=$p(data,"^",3)
    .s amt=$p(data,"^",4)
    .s bnum=$p(data,"^",5)
    .s zsnum=$p(data,"^",6)
    .s num=$p(data,"^",7)
    .d OutRow
    .
    k ^TMP(node,pid)
	Quit $$$OK
OutRow
	set Data=$lb(orddept,kjnum,prescnum,amt,bnum,zsnum,num)    
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
}

ClassMethod GetDoctorDataFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDoctorDataExecute ]
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

Query GetDoctorData(SDate = "", EndDate = "") As %Query(ROWSPEC = "Tdoctor,Tkjnum:%Integer,Tprescnum:%Integer,Tamt:%Float,Tbnum:%Integer,Tzsnum:%Integer,Tnum:%Integer") [ SqlProc ]
{
}

ClassMethod GetDoctorDataClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDoctorDataExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
    Quit $$$OK
}

// 取诊断

// w ##class(web.DHCSTCNTSQUERY).GetMRDiagnosDesc(1998)

ClassMethod GetMRDiagnosDesc(MRAdmRowid As %String, DelimStr As %String) As %String
{
 
 q:MRAdmRowid="" ""
 s MRAdmRowid=$p(^PAADM(MRAdmRowid),"^",61)
 q:MRAdmRowid="" ""
 s retval=""
 s i=0
 Set obj=##class(%ResultSet).%New("web.MRDiagnos:Find")
 d obj.Execute(MRAdmRowid)
 For  Quit:'obj.Next()  Do
 .s Desc=obj.Data("MRDIAICDCodeDRDesc")
 .s Rowid=obj.Data("ID")
 .s CodeRowid=obj.Data("MRDIAICDCodeDR")
 .s MRDesc=obj.Data("MRDIADesc")
 .s MRdiagnosNoteDesc=""
 .S MRdiagnosNoteSubRowid=$G(^MR($P(Rowid,"||",1),"DIA",$P(Rowid,"||",2),"DES",0))
 .I MRdiagnosNoteSubRowid'="" Set MRdiagnosNoteDesc=$G(^MR($P(Rowid,"||",1),"DIA",$P(Rowid,"||",2),"DES",MRdiagnosNoteSubRowid))
 .i Desc="" s Desc=MRdiagnosNoteDesc
 .s i=i+1
 .s Desc=i_","_Desc
 .s retval=retval_""_Desc
 
 d obj.Close()
 q retval
}

/// 医嘱不合理申诉报表
/// d ##class(%ResultSet).RunQuery("web.DHCSTCNTSQUERY","QueryDocAdvData","","")
ClassMethod QueryDocAdvDataExecute(ByRef qHandle As %Binary, SDate = "", EndDate = "", HOSPID As %String = "") As %Status
{
	
	//s SDate="2013-01-01"
	//s EndDate="2013-08-28"
	
	s repid=$I(^CacheTemp)
    Set qHandle=$lb(0,repid,0)
    s ind=1
    s node="dhcpha,DHCSTCNTSQUERY,QueryDocAdvData"
    q:SDate="" $$$OK
    q:EndDate="" $$$OK

    s h=0
    s pid=##class(web.DHCSTCNTSMAIN).GetPHCNTSPID()

	s qstdate=##class(websys.Conversions).DateHtmlToLogical(SDate)
   	s qenddate=##class(websys.Conversions).DateHtmlToLogical(EndDate)

	s pcntstype="F"
	f date=qstdate:1:qenddate d
	.s typecnt=$l(pcntstype,"^")
	.f i=1:1:typecnt d
	..s type=$p(pcntstype,"^",i)
	..s pcnts=""
	..f  s pcnts=$o(^DHCPHCNTS(0,"Date",date,type,pcnts)) q:pcnts=""  d
	...s pcntData=$g(^DHCPHCNTS(pcnts))
	...s hospital=$p(^DHCPHCNTS(pcnts),"^",8)
	...q:(HOSPID'="")&(HOSPID'=hospital)   //过滤病区
	...s reSaveFlag=$p(pcntData,"^",13)		//二次抽取标志
	...q:reSaveFlag="Y"
	...s retnum=0
	...s chl=""
	...f  s chl=$o(^DHCPHCNTS(pcnts,"I",chl)) q:chl=""  d
	....s prescno=$p(^DHCPHCNTS(pcnts,"I",chl),"^",1)
	....s orditem=$p(^DHCPHCNTS(pcnts,"I",chl),"^",2)
	....s doclocdr=$p(^DHCPHCNTS(pcnts,"I",chl),"^",4)
	....s curret=$p(^DHCPHCNTS(pcnts,"I",chl),"^",6) ;结果
	....i curret="N" s retnum=1
	....e  s retnum=0
	....s docadvnum=0
	....s sub=""
	....f  s sub=$o(^DHCPHCNTS(pcnts,"I",chl,"L",sub)) q:sub=""  d 
	.....s docadvice=$p(^DHCPHCNTS(pcnts,"I",chl,"L",sub),"^",10)  //医生建议
	.....i docadvice'="" d
	......s docadvnum=1
	....s orddept=$p(^CTLOC(doclocdr),"^",2)
	....s docdr=$p(^DHCPHCNTS(pcnts,"I",chl),"^",5)
	....s doctor=$p(^SSU("SSUSR",docdr),"^",2)  ;医生 
	....s prescnum=1
	....d OutRow
    
    s locstr=##class(web.DHCSTCNTSCOMMON).GetPhaLocStr()
    s type="P"
	f date=qstdate:1:qenddate d
	.s pcnts=""
	.f  s pcnts=$o(^DHCPHCNTS(0,"Date",date,type,pcnts)) q:pcnts=""  d
	..s pcntData=$g(^DHCPHCNTS(pcnts))
	..s hospital=$p(^DHCPHCNTS(pcnts),"^",8)
	..q:(HOSPID'="")&(HOSPID'=hospital)   //过滤病区
	..s reSaveFlag=$p(pcntData,"^",13)		//二次抽取标志
	..q:reSaveFlag="Y"
	..s tchl=""
	..f  s tchl=$o(^DHCPHCNTS(pcnts,"I",tchl)) q:tchl=""  d
	...s curret=$p(^DHCPHCNTS(pcnts,"I",tchl),"^",6)
	...s prescno=$p(^DHCPHCNTS(pcnts,"I",tchl),"^",1)
	...s adm=$p(^DHCPHCNTS(pcnts,"I",tchl),"^",3)
	...s cnt=$l(locstr,"^")
	...f i=1:1:cnt d
	....s recdpdr=$p(locstr,"^",i)
	....s ord=""
	....f  s ord=$o(^OEORD(0,"Adm",adm,ord))  q:ord=""  d
	.....s chl=""
	.....f  s chl=$o(^OEORDi(0,"RecDepOrd",ord,recdpdr,chl)) q:chl=""  d
	......s orditm=ord_"||"_chl
	......s qty=##class(web.DHCSTCNTSCOMMON).GetDspQty(orditm)
	......q:qty=0
	......s moeori=##class(web.DHCSTCNTSCOMMON).GetMainOeori(orditm)
	......s orddeptdr=$p(^OEORD(+orditm,"I",$p(orditm,"||",2),1),"^",3) //医生科室
	......s orddept=$p(^CTLOC(orddeptdr),"^",2)
	......s doctordr=$p(^OEORD(+orditm,"I",$p(orditm,"||",2),7),"^",1)
	......s doctor=$p(^SSU("SSUSR",doctordr),"^",2)  ;医生 
	......s index=orddept_"^"_doctor_"^"_moeori
	......s prescnum=0
	......s retnum=0
	......s docadvnum=0
	......i '$d(^TMP(node,pid,index)) d
	.......s prescnum=1
	.......//
	.......s orditmstr=moeori
	.......s tmpchl=""
 	.......F  S tmpchl=$O(^OEORDi(0,"OEORI",ord,moeori,tmpchl)) Q:tmpchl=""  d
 	........s suboeori=ord_"||"_tmpchl
 	........s orditmstr=orditmstr_"^"_suboeori
 	.......//
 	.......s cntorditm=$l(orditmstr,"^")
 	.......f x=1:1:cntorditm d
    ........s torditem=$p(orditmstr,"^",x)
    ........q:torditem=""
	........s itmlogdr=""
	........f  s itmlogdr=$o(^DHCPCTABL(0,"OrdItm",torditem,itmlogdr),-1) q:itmlogdr=""  d 
	.........s lmain=$p(itmlogdr,"||",1)
	.........s litm=$p(itmlogdr,"||",2)
	.........s lsub=$p(itmlogdr,"||",3)
	.........q:'$d(^DHCPHCNTS(lmain,"I",litm,"L",lsub))
	.........s active=$p(^DHCPHCNTS(lmain,"I",litm,"L",lsub),"^",11)
	.........q:active'="Y"
	.........s retnum=1
	.........s comdocnote=$p(^DHCPHCNTS(lmain,"I",litm,"L",lsub),"^",10)
	.........i comdocnote'="" d
	..........s docadvnum=1
	.......//
	.......s ^TMP(node,pid,index)=""
	.......d OutRow
    
	Quit $$$OK
	
OutRow
	set Data=$lb(orddept,doctor,prescnum,retnum,docadvnum)    
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
}

ClassMethod QueryDocAdvDataFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryDocAdvDataExecute ]
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

Query QueryDocAdvData(SDate = "", EndDate = "", HOSPID As %String = "") As %Query(ROWSPEC = "orddept,doctor,prescnum:%Float,retnum:%Float,docadvnum:%Float") [ SqlProc ]
{
}

ClassMethod QueryDocAdvDataClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryDocAdvDataExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
    Quit $$$OK
}

}
