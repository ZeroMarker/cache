Import sqluser

/// 门诊输液配药申请
Class web.DHCSTPIVAOUTDISPREQ Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// 获取病人姓名
/// Creator:LiangQiang
/// CreatDate:2013-05-23
/// Input:登记号
/// Output:姓名
ClassMethod GetPatInfo(RegNo) As %String
{
	s pid=##class(web.DHCSTPIVAOUTCOMMON).GetPIVAOUTPID()
	s patdata=##class(web.DHCSTPIVAOUTCOMMON).GetPatInfo(RegNo)
	q:patdata="" ##class(web.DHCSTEXTCOMMON).GetNoJson()
	s patid=$p(patdata,"^",1)
	s patname=$p(patdata,"^",2)
	//s patage=$p(patdata,"^",3)
    s pmi=$o(^PAPERi("PAPMI_PatNo",RegNo,""))
    s patage=##class(web.DHCSTKUTIL).GetAge(pmi,"") //年龄统一调用接口wyx 2015-01-29
	s patsex=$p(patdata,"^",4)
	s patid=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("patid",patid)
	s patname=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("patname",patname)
	s patsex=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("patsex",patsex)
	s patage=##class(web.DHCSTEXTCOMMON).GetJsonLastCell("patage",patage)
    s maxrow=1
	s tmpstr=patid_patname_patsex_patage
    s startString=##class(web.DHCSTEXTCOMMON).GetJsonStartString(maxrow)
    
    s lastrow=##class(web.DHCSTEXTCOMMON).GetJsonLastRow(tmpstr)
	w startString
    w lastrow

    q ""
}

/// 取医嘱明细
/// Creator:LiangQiang
/// CreatDate:2013-05-23
/// Input:登记号,开始行,限制行,参数串
/// Output:取医嘱明细
ClassMethod GetOrdDetailData(RegNo, StPage, Limit, Input) As %String
{
	s pid=##class(web.DHCSTPIVAOUTCOMMON).GetPIVAOUTPID()
	s stdate=$p(Input,"^",1)
	s stdate=$zdh(stdate,4)
	s enddate=$p(Input,"^",2)
	s enddate=$zdh(enddate,4)
    s phalocdr=$p(Input,"^",3)
    s patID=$p(Input,"^",4)
    s onlyreq=$p(Input,"^",5)
    s endpage=StPage+Limit  //结束行
	s stpage=StPage+1 //开始行
	
    //
    s h=0
    f date=stdate:1:enddate  d
    .s dspstatus=""
    .f  s dspstatus=$o(^DHCOEDISQTY(0,"ADM",phalocdr,date,dspstatus)) q:dspstatus=""  d
    ..q:dspstatus="R"
    ..s adm=""
    ..f  s adm=$o(^DHCOEDISQTY(0,"ADM",phalocdr,date,dspstatus,adm)) q:adm=""  d
    ...s papmidr=$p(^PAADM(adm),"^",1)
    ...s papmino=$p(^PAPER(papmidr,"PAT",1),"^",2)
	...q:(papmino'=RegNo)&(RegNo'="")
	...s dsprowid=""
    ...f  s dsprowid=$o(^DHCOEDISQTY(0,"ADM",phalocdr,date,dspstatus,adm,dsprowid)) q:dsprowid=""  d
    ....s reqcompflag=##class(web.DHCSTPIVAOUTCOMMON).GetReqCompStatus(dsprowid)
    ....s dspstatus=$p(^DHCOEDISQTY(dsprowid),"^",7)
    ....q:dspstatus="R" //过滤退药
	....s oeori=$p(^DHCOEDISQTY(dsprowid),"^",1)
	....s ord=$p(oeori,"||",1)
	....s chl=$p(oeori,"||",2)
	....q:'$d(^OEORD(ord,"I",chl))
	....s prescno=$p(^OEORD(ord,"I",chl,1),"^",14) 
	....q:prescno=""
	....q:(onlyreq="true")&(reqcompflag'=1)  //已完成申请
    ....q:(onlyreq'="true")&((reqcompflag=1)||(dspstatus="C")) //过滤已发药 //正式库放开
	....s dspstatus=$p(^DHCOEDISQTY(dsprowid),"^",7)
    ....s statdr=$p(^OEORD(ord,"I",chl,1),"^",13)
	....//s oeflag=$p(^OEC("OSTAT",statdr),"^",1) 
	....//q:(oeflag'="V")&(oeflag'="E")
	....S OrdExeRowid=$p(^DHCOEDISQTY(dsprowid),"^",3) //判断执行记录
    ....q:##class(web.DHCSTCOMMONSRV).GetOrdState(OrdExeRowid)=0
	....s priordr=$p(^OEORD(ord,"I",chl,1),"^",8) 
    ....q:priordr="" 
    ....s priority=$p(^OECPR(priordr),"^",1) 			;医嘱优先级代码              
    ....//q:priority["OM" ;自备药
    ....q:##class(web.DHCSTPIVAOUTCOMMON).IfPIVA(oeori)'=1  // 不是配液  //正式库放开
    ....s arcimid=$p(^OEORD(ord,"I",chl,1),"^",2)  ;医嘱 ARC_ItmMast ARCIM_RowId
	....s itmmastid=$p(arcimid,"||",1)
	....s itmmastver=$p(arcimid,"||",2)
	....s inci=$o(^INCI(0,"ARCIM_DR",$p(arcimid,"||",1),"") ) q:inci=""  //医嘱名称
	....s inciDesc=$p(^INCI(inci,1),"^",2) //药品名称
	....s puomdr=$p(^ARCIM(itmmastid,itmmastver,8),"^",14)
	....s buomdr=+$p(^INCI(inci,1),"^",10)
	....s fac=+##Class(web.DHCSTCOMMONSRV).UOMFac(puomdr,buomdr)
	....s uomdr=buomdr
	....s dosage=$j($p(^OEORD(ord,"I",chl,2),"^",1)," ",3) ;剂量
    ....s doseuom=""
	....s dosuomID=$p(^OEORD(ord,"I",chl,2),"^",3)
	....i dosuomID'="" d
	.....s doseuom=$p($g(^CT("UOM",dosuomID)),"^",2) ;剂量单位
	....s freq=""
	....s freqdr=$p($g(^OEORD(ord,"I",chl,2)),"^",4) ;OEORI_PHFreq_DR
    ....i freqdr'="" s freq=$p($g(^PHCFR(freqdr)),"^",3)  ;频率
    ....s instru=$p(^PHCIN($p(^OEORD(ord,"I",chl,2),"^",7)),"^",2)        	;用法
	....s duration=$p(^PHCDU($p(^OEORD(ord,"I",chl,2),"^",6)),"^",1)         	;用药疗程
	....s priorty=$p(^OECPR($p(^OEORD(ord,"I",chl,1),"^",8)),"^",2)   		;医嘱优先级
	....s doctor=##class(web.DHCSTCOMMONSRV).getOrdDoctor(oeori)       ;医生
	....s skintest=##class(web.DHCSTCOMMONSRV).GetSkinTestResult(oeori)  ;皮试
	....s form=##class(web.DHCSTCOMMONSRV).GetForm(inci)  ;剂型
	....i $F(form,$c(13)) s form=$p(form,$c(13))
	....s spec=##class(web.DHCSTCOMMONSRV).getBarcode(inci) ;规格
	....s manf=##class(web.DHCSTITMDESC).GetManfNameByInci(inci) ;厂家
	....s manf=$tr(manf,$c(13,10),"")
	....i $f(manf,"-") s manf=$p(manf,"-",2)
	....s remark=##class(web.DHCSTCOMMONSRV).GetOrdItmRemark(oeori) ;备注
	....s qty=$p(^DHCOEDISQTY(dsprowid),"^",2)
	....i (qty#fac)=0 d
	.....s qty=qty/fac   //数量
	.....s uomdr=puomdr 
	.....s uomdesc=$p($g(^CT("UOM",uomdr)),"^",2) //单位
	....s orddate=$p(^DHCOEDISQTY(dsprowid),"^",21)
    ....i orddate="" s orddate=$p(^DHCOEDISQTY(dsprowid),"^",15)
    ....i orddate'="" s orddate=$zd(orddate,3)
    ....s ordtime=$p(^DHCOEDISQTY(dsprowid),"^",20)   //22->20
    ....i ordtime="" s ordtime=$p(^DHCOEDISQTY(dsprowid),"^",16)
    ....i ordtime'="" s ordtime=$zt(ordtime,1)
    ....s orddatetime=orddate_" "_ordtime  ;开单日期
    ....s requserinfo=##class(web.DHCSTPIVAOUTCOMMON).GetReqUserInfo(dsprowid)
    ....s requser=$p(requserinfo,"^",1)  //申请人
    ....s reqdate=$p(requserinfo,"^",2)_" "_$p(requserinfo,"^",3)
    ....S grpno=$p(^DHCOEDISQTY(dsprowid),"^",4)
    ....S mdodis=##class(web.DHCSTPIVA).GetMainOEDispID(dsprowid,grpno)
    ....s tmpindex=prescno_"||"_orddatetime
    ....s selectflag=mdodis   //prescno
    ....s h=h+1
    ....i $D(^TMP("dhcpha","DHCSTPIVAOUTDISPREQ","GetOrdDetailData","PrescNo",pid,tmpindex)) d
    .....s orddatetime=""
    .....s prescno=""
    ....e  d
    .....s ^TMP("dhcpha","DHCSTPIVAOUTDISPREQ","GetOrdDetailData","PrescNo",pid,tmpindex)=""
    ....s data=skintest_" "_inciDesc_"^"_qty_"^"_uomdesc_"^"_dosage_doseuom_"^"_freq_"^"_spec_"^"_instru_"^"_duration_"^"_form
    ....s data=data_"^"_priorty_"^"_doctor_"^"_orddatetime_"^"_remark_"^"_manf_"^"_dsprowid_"^"_prescno_"^"_selectflag_"^"_requser
    ....s data=data_"^"_reqdate
    ....s ^TMP("dhcpha","DHCSTPIVAOUTDISPREQ","GetOrdDetailData",pid,"Itm",tmpindex,h)=data
    
    q:h=0 ##class(web.DHCSTEXTCOMMON).GetNoJson()
    s maxrow=h
    i endpage>maxrow s endpage=maxrow
    s count=0
    s index=""
    f  s index=$o(^TMP("dhcpha","DHCSTPIVAOUTDISPREQ","GetOrdDetailData",pid,"Itm",index)) q:index=""  d
    .s h=""
    .f  s h=$o(^TMP("dhcpha","DHCSTPIVAOUTDISPREQ","GetOrdDetailData",pid,"Itm",index,h)) q:h=""  d
    ..s data=^TMP("dhcpha","DHCSTPIVAOUTDISPREQ","GetOrdDetailData",pid,"Itm",index,h)
    ..s incidesc=$p(data,"^",1)
    ..s qty=$p(data,"^",2)
    ..s uomdesc=$p(data,"^",3)
    ..s dosage=$p(data,"^",4)
    ..s freq=$p(data,"^",5)
    ..s spec=$p(data,"^",6)
    ..s instruc=$p(data,"^",7)
    ..s dura=$p(data,"^",8)
    ..s form=$p(data,"^",9)
    ..s pri=$p(data,"^",10)
    ..s doctor=$p(data,"^",11)
    ..s orddate=$p(data,"^",12)
    ..s remark=$p(data,"^",13)
    ..s manf=$p(data,"^",14)
    ..s dsprowid=$p(data,"^",15)
    ..s prescno=$p(data,"^",16)
    ..s selectflag=$p(data,"^",17)
    ..s requser=$p(data,"^",18)
    ..s reqdate=$p(data,"^",19)
    ..
    ..s count=count+1
    ..q:count<stpage
    ..q:count>endpage
    ..
    ..s incidesc=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("incidesc",incidesc)
	..s qty=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("qty",qty)
	..s uomdesc=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("uomdesc",uomdesc)
	..s dosage=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("dosage",dosage)
	..s freq=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("freq",freq)
	..s spec=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("spec",spec)
	..s instruc=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("instruc",instruc)
	..s dura=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("dura",dura)
	..s form=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("form",form)
	..s pri=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("pri",pri)
	..s doctor=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("doctor",doctor)
	..s orddate=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("orddate",orddate)
	..s remark=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("remark",remark)
	..s manf=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("manf",manf)
	..s dsprowid=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("dsprowid",dsprowid)
	..s prescno=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("prescno",prescno)
	..s selectflag=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("selectflag",selectflag)
	..s requser=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("requser",requser)
	..s reqdate=##class(web.DHCSTEXTCOMMON).GetJsonLastCell("reqdate",reqdate)
	..
	..s tmpstr=incidesc_qty_uomdesc_dosage_freq_spec_instruc_dura_form_pri_doctor_orddate_remark_manf_dsprowid_prescno_selectflag
	..s tmpstr=tmpstr_requser_reqdate
	..
    ..s startString=##class(web.DHCSTEXTCOMMON).GetJsonStartString(maxrow)
    ..s firstrow=##class(web.DHCSTEXTCOMMON).GetJsonFirstRow(tmpstr)
    ..s lastrow=##class(web.DHCSTEXTCOMMON).GetJsonLastRow(tmpstr)
	..
    ..
    ..i count=stpage w startString
    ..i count<endpage w firstrow
    ..i count=endpage w lastrow
    
    
    k ^TMP("dhcpha","DHCSTPIVAOUTDISPREQ","GetOrdDetailData",pid)
    q ""
}

/// 保存配液申请单
/// Creator:LiangQiang
/// CreatDate:2013-05-23
/// Input:打包表ID,打包标志,申请人ID
/// Output:0失功
ClassMethod SaveRequest(dsprowid, packflag, requesr) As %String
{
	s reqcompflag=##class(web.DHCSTPIVAOUTCOMMON).GetReqCompStatus(dsprowid)
	q:reqcompflag=1 -1
	s oeori=$p(^DHCOEDISQTY(dsprowid),"^",1)
	s dspstatus=$p(^DHCOEDISQTY(dsprowid),"^",7)
	q:dspstatus="C" -2   //正式库放开
	s ord=$p(oeori,"||",1)
	s chl=$p(oeori,"||",2)
	s priordr=$p(^OEORD(ord,"I",chl,1),"^",8) 
    s priority=$p(^OECPR(priordr),"^",1)
    S pricode=$ZCVT(priority,"U") 
    s reclocdr=$p(^OEORD(ord,"I",chl,3),"^",6)
    
    s (opuser,opstatus,opdate,optime)=""
    i pricode'="OM" d
	.s opuser=requesr
	.s opstatus="REC"
	.s opdate=+$h
	.s optime=+$p($h,",",2)
	
	s currdate=+$h
	s currtime=+$p($h,",",2)
	
	tstart
	k PLIST
	s PLIST(2)=oeori 
	s PLIST(3)=dsprowid 
	s PLIST(4)=packflag
	s PLIST(5)=currdate
	s PLIST(6)=currtime
	s PLIST(7)=requesr
	s PLIST(8)=opstatus
	s PLIST(9)=opuser
	s PLIST(10)=opdate
	s PLIST(11)=optime
    s PLIST(12)=reclocdr
    
    &sql(INSERT INTO PIVA_DispRequest VALUES :PLIST())
	i SQLCODE'=0  d
    .s ret=$$SqlErrorRecord^DHCSTERROR("SaveRequest:DHCSTPIVAOUTDISPREQ",dsprowid,SQLCODE_":"_%msg)
    q:SQLCODE'=0 SQLCODE
    tcommit
 	q +$g(%ROWID)
}

/// w ##class(web.DHCSTPIVAOUTDISPREQ).GetWaitReqDspPatInfo("","0","200","30/08/2015^6/11/2015^101^true^^false")
ClassMethod GetWaitReqDspPatInfo(RegNo, StPage, Limit, Input) As %String
{
	S pid=##class(web.DHCSTPIVAOUTCOMMON).GetPIVAOUTPID()
	S tStartDate=$p(Input,"^",1)
	S tStartDate=$zdh(tStartDate,4)
	S tEndDate=$p(Input,"^",2)
	S tEndDate=$zdh(tEndDate,4)
    S tPLocID=$p(Input,"^",3)
    S OnlyReq=$p(Input,"^",4)
    s emlocdr=$p(Input,"^",5) //急诊留观室
    s pivaaudit=$p(Input,"^",6)  //配伍审核
    S endpage=StPage+Limit  //结束行
	S stpage=StPage+1 //开始行
	S DspStatStr="TC"
	S:OnlyReq="true" DspStatStr="TC^C"
	//S Len=$L(DspStatStr,"^")
	S h=0

	F date=tStartDate:1:tEndDate D
	.S k=1
	.F  S DspStatus=$P(DspStatStr,"^",k) Q:DspStatus=""  D
	..S k=k+1
	..S DeptLocDr=""
	..F  S DeptLocDr=$O(^DHCOEDISQTY(0,"REC",tPLocID,date,DspStatus,DeptLocDr)) q:DeptLocDr=""  d
	...S flag=0
	...S DspId=""
	...F  S DspId=$O(^DHCOEDISQTY(0,"REC",tPLocID,date,DspStatus,DeptLocDr,0,DspId)) q:DspId=""  d
	....S AdmDr=$p(^DHCOEDISQTY(DspId),"^",26)
	....s chkdocloc=1
	....s:emlocdr'="" chkdocloc=##class(web.DHCOutPhDisp).ChkLGDocLoc(emlocdr,AdmDr) //留观室
	....q:chkdocloc=0
	....S PapmiDr=$p(^PAADM(AdmDr),"^",1)
	....S AdmType=$p($g(^PAADM(AdmDr)),"^",2)
	....Q:(AdmType'="E")&(AdmType'="O")		//非门诊病人退出
    ....S PapmiNo=$p(^PAPER(PapmiDr,"PAT",1),"^",2)
	....Q:(PapmiNo'=RegNo)&(RegNo'="")
	....S PatName=$P(^PAPER(PapmiDr,"ALL"),"^",1)
	....S reqcompflag=##class(web.DHCSTPIVAOUTCOMMON).GetReqCompStatus(DspId)
	....S oeori=$p(^DHCOEDISQTY(DspId),"^",1)
	....S ord=$p(oeori,"||",1)
	....S chl=$p(oeori,"||",2)
	....Q:'$d(^OEORD(ord,"I",chl))
	....S PrescNo=$p(^OEORD(ord,"I",chl,1),"^",14) 
	....s pivastate=""  //处方审核表状态
	....i PrescNo'="" d
	.....///i $d(^DHCPHORDM(0,"PrescNo",PrescNo)) s pivastate="1" //审核表有记录代表已经下一步操作
	.....i ..GetMonitorStatus(PrescNo)'="" s pivastate="1"								
	....Q:(OnlyReq="true")&&(pivaaudit'="true")&&((pivastate'="")||(reqcompflag'="1"))  //已申请未审核
	....Q:(OnlyReq="true")&&(pivaaudit="true")&&(reqcompflag'=1)  //已申请
    ....Q:(OnlyReq'="true")&&(pivaaudit'="true")&&(reqcompflag=1)  //未申请
    ....q:(OnlyReq'="true")&&(pivaaudit="true")					//已审核未申请,不存在此种情况
	....S dspstatus=$p(^DHCOEDISQTY(DspId),"^",7)
    ....S statdr=$p(^OEORD(ord,"I",chl,1),"^",13)
	....S oeflag=$p(^OEC("OSTAT",statdr),"^",1) 
	....//Q:(oeflag'="V")&(oeflag'="E")
	....S OrdExeRowid=$p(^DHCOEDISQTY(DspId),"^",3) //判断执行记录
    ....q:##class(web.DHCSTPIVAOUTCOMMON).GetOrdState(OrdExeRowid)=0
	....s payflag=$p(^OEORD(ord,"I",chl,3),"^",5)
	....S PriDr=$p(^OEORD(ord,"I",chl,1),"^",8)
    ....Q:PriDr="" 
    ....S priority=$p(^OECPR(PriDr),"^",1) 			;医嘱优先级代码   
    ....//Q:(PrescNo="")&(priority'["OM")
    ....s EmLGflag=$p($g(^OEORD(ord,"I",chl,"DHC")),"^",17)
    ....q:$d(^TMP("dhcpha","DHCSTPIVAOUTDISPREQ","GetWaitReqDspPatInfo","NoPayPrescNo",pid,PrescNo))
    ....s ordhavepay=0
    ....s tmporditm=""
    ....f  s tmporditm=$o(^OEORD(0,"PrescNo",PrescNo,ord,tmporditm)) q:(tmporditm="")||(ordhavepay=1)  d
    .....q:+tmporditm=0
    .....s tmppayflag=$p(^OEORD(ord,"I",tmporditm,3),"^",5)
    .....s tmpEmLGflag=$p($g(^OEORD(ord,"I",tmporditm,"DHC")),"^",17)
	.....S tmpPriDr=$p(^OEORD(ord,"I",tmporditm,1),"^",8)
    .....Q:tmpPriDr="" 
    .....S tmppriority=$p(^OECPR(tmpPriDr),"^",1) 
    .....i (tmppayflag'="P")&(tmppriority'["OM")&(tmpEmLGflag'=1) d
    ......s ordhavepay=1
    ......s ^TMP("dhcpha","DHCSTPIVAOUTDISPREQ","GetWaitReqDspPatInfo","NoPayPrescNo",pid,PrescNo)=""	 
    ....q:ordhavepay=1 //未收费的不予显示除了自备药和急诊留观
    ....//q:priority["OM" ;自备药
    ....Q:##class(web.DHCSTPIVAOUTCOMMON).IfPIVA(oeori)'=1  // 不是配液  //正式库放开
    ....S arcimid=$p(^OEORD(ord,"I",chl,1),"^",2)  ;医嘱 ARC_ItmMast ARCIM_RowId
	....S itmmastid=$p(arcimid,"||",1)
	....S itmmastver=$p(arcimid,"||",2)
	....S inci=$o(^INCI(0,"ARCIM_DR",$p(arcimid,"||",1),"") ) q:inci=""  //医嘱名称
	....S inciDesc=$p(^INCI(inci,1),"^",2) //药品名称
	....S puomdr=$p(^ARCIM(itmmastid,itmmastver,8),"^",14)
	....S buomdr=+$p(^INCI(inci,1),"^",10)
	....S fac=+##Class(web.DHCSTCOMMONSRV).UOMFac(puomdr,buomdr)
	....S uomdr=buomdr
	....S dosage=$j($p(^OEORD(ord,"I",chl,2),"^",1)," ",3) ;剂量
    ....S doseuom=""
	....S dosuomID=$p(^OEORD(ord,"I",chl,2),"^",3)
	....If dosuomID'="" d
	.....S doseuom=$p($g(^CT("UOM",dosuomID)),"^",2) ;剂量单位
	....S freq=""
	....S freqdr=$p($g(^OEORD(ord,"I",chl,2)),"^",4) ;OEORI_PHFreq_DR
    ....If freqdr'="" s freq=$p($g(^PHCFR(freqdr)),"^",3)  ;频率
    ....S instru=$p(^PHCIN($p(^OEORD(ord,"I",chl,2),"^",7)),"^",2)        	;用法
	....S duration=$p(^PHCDU($p(^OEORD(ord,"I",chl,2),"^",6)),"^",1)         	;用药疗程
	....S priorty=$p(^OECPR($p(^OEORD(ord,"I",chl,1),"^",8)),"^",2)   		;医嘱优先级
	....S doctor=##class(web.DHCSTCOMMONSRV).getOrdDoctor(oeori)       ;医生
	....S skintest=##class(web.DHCSTCOMMONSRV).GetSkinTestResult(oeori)  ;皮试
	....S form=##class(web.DHCSTCOMMONSRV).GetForm(inci)  ;剂型
	....If $F(form,$c(13)) s form=$p(form,$c(13))
	....S spec=##class(web.DHCSTCOMMONSRV).getBarcode(inci) ;规格
	....S manf=##class(web.DHCSTITMDESC).GetManfNameByInci(inci) ;厂家
	....S manf=$tr(manf,$c(13,10),"")
	....If $f(manf,"-") s manf=$p(manf,"-",2)
	....S remark=##class(web.DHCSTCOMMONSRV).GetOrdItmRemark(oeori) ;备注
	....S qty=$p(^DHCOEDISQTY(DspId),"^",2)
	....If (qty#fac)=0 d
	.....S qty=qty/fac   //数量
	.....S uomdr=puomdr 
	.....S uomdesc=$p($g(^CT("UOM",uomdr)),"^",2) //单位
	....S orddate=$p(^DHCOEDISQTY(DspId),"^",21)
    ....If orddate="" s orddate=$p(^DHCOEDISQTY(DspId),"^",15)
    ....If orddate'="" s orddate=$zd(orddate,3)
    ....S ordtime=$p(^DHCOEDISQTY(DspId),"^",20)   //22->20
    ....If ordtime="" s ordtime=$p(^DHCOEDISQTY(DspId),"^",16)
    ....if ordtime'="" s ordtime=$zt(ordtime,1)
    ....S orddatetime=orddate_" "_ordtime  ;开单日期
    ....S requserinfo=##class(web.DHCSTPIVAOUTCOMMON).GetReqUserInfo(DspId)
    ....S requser=$p(requserinfo,"^",1)  //申请人
    ....S reqdate=$p(requserinfo,"^",2)_" "_$p(requserinfo,"^",3)
    ....S grpno=$p(^DHCOEDISQTY(DspId),"^",4)
    ....S mdodis=##class(web.DHCSTPIVA).GetMainOEDispID(DspId,grpno)
    ....S psname=##class(web.DHCSTPIVAOUTCOMMON).GetCurStat(mdodis)
    ....i (psname="已申请")&&(pivastate'="") s psname="已申请已审核" 
    ....s moeori=##class(web.DHCSTKUTIL).GetMainOeori(oeori) //主医嘱
    ....S index=PrescNo_"||"_orddatetime //_"||"_moeori
    ....i PrescNo="" s index=moeori_"||"_orddatetime  
    ....S selectflag=mdodis   //prescno
    ....s prescnoT=PrescNo
    ....i PrescNo="" s index=moeori_"||"_orddatetime,prescnoT=moeori  //针对自备药
    ....s pack=##class(web.DHCSTPIVAOUTCOMMON).GetPackFlag(mdodis) //打包标志 bianshuai
    ....S h=h+1
    ....If $D(^TMP("dhcpha","DHCSTPIVAOUTDISPREQ","GetWaitReqDspPatInfo","PrescNo",pid,index)) d
    .....S orddatetime="",PrescNo="",PapmiNo="",PatName=""
    ....e  d
    .....S ^TMP("dhcpha","DHCSTPIVAOUTDISPREQ","GetWaitReqDspPatInfo","PrescNo",pid,index)=""
    ....S data=PapmiNo_"^"_PatName_"^"_skintest_" "_inciDesc_"^"_qty_"^"_uomdesc_"^"_dosage_doseuom_"^"_freq_"^"_spec_"^"_instru_"^"_duration_"^"_form
    ....S data=data_"^"_priorty_"^"_doctor_"^"_orddatetime_"^"_remark_"^"_manf_"^"_DspId_"^"_PrescNo_"^"_selectflag_"^"_requser
    ....S data=data_"^"_reqdate_"^"_psname_"^"_pack_"^"_prescnoT
    ....S ^TMP("dhcpha","DHCSTPIVAOUTDISPREQ","GetWaitReqDspPatInfo",pid,"Itm",index,h)=data
   
    Q:h=0 ##class(web.DHCSTEXTCOMMON).GetNoJson()
    S maxrow=h
    If endpage>maxrow S endpage=maxrow
    S count=0
    S index=""
    F  S index=$o(^TMP("dhcpha","DHCSTPIVAOUTDISPREQ","GetWaitReqDspPatInfo",pid,"Itm",index)) Q:index=""  d
    .S h=""
    .F  S h=$o(^TMP("dhcpha","DHCSTPIVAOUTDISPREQ","GetWaitReqDspPatInfo",pid,"Itm",index,h)) Q:h=""  d
    ..S data=^TMP("dhcpha","DHCSTPIVAOUTDISPREQ","GetWaitReqDspPatInfo",pid,"Itm",index,h)
    ..S PapmiNo=$p(data,"^",1)
    ..S PatName=$p(data,"^",2)
    ..S incidesc=$p(data,"^",3)
    ..S qty=$p(data,"^",4)
    ..S uomdesc=$p(data,"^",5)
    ..S dosage=$p(data,"^",6)
    ..S freq=$p(data,"^",7)
    ..S spec=$p(data,"^",8)
    ..S instruc=$p(data,"^",9)
    ..S dura=$p(data,"^",10)
    ..S form=$p(data,"^",11)
    ..S pri=$p(data,"^",12)
    ..S doctor=$p(data,"^",13)
    ..S orddate=$p(data,"^",14)
    ..S remark=$p(data,"^",15)
    ..S manf=$p(data,"^",16)
    ..S dsprowid=$p(data,"^",17)
    ..S prescno=$p(data,"^",18)
    ..S selectflag=$p(data,"^",19)
    ..S requser=$p(data,"^",20)
    ..S reqdate=$p(data,"^",21)
    ..S psname=$p(data,"^",22)
    ..s pack=$p(data,"^",23)
    ..s prescnoT=$p(data,"^",24)
    ..
    ..S count=count+1
    ..Q:count<stpage
    ..Q:count>endpage
    ..
    ..S patno=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("patno",PapmiNo)
	..S patname=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("patname",PatName)
    ..S incidesc=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("incidesc",incidesc)
	..S qty=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("qty",qty)
	..S uomdesc=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("uomdesc",uomdesc)
	..S dosage=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("dosage",dosage)
	..S freq=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("freq",freq)
	..S spec=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("spec",spec)
	..S instruc=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("instruc",instruc)
	..S dura=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("dura",dura)
	..S form=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("form",form)
	..S pri=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("pri",pri)
	..S doctor=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("doctor",doctor)
	..S orddate=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("orddate",orddate)
	..S remark=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("remark",remark)
	..S manf=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("manf",manf)
	..S dsprowid=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("dsprowid",dsprowid)
	..S prescno=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("prescno",prescno)
	..S prescnoT=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("prescnoT",prescnoT)
	..S selectflag=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("selectflag",selectflag)
	..S requser=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("requser",requser)
	..S psname=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("psname",psname)
	..S reqdate=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("reqdate",reqdate)
	..s pack=##class(web.DHCSTEXTCOMMON).GetJsonLastCell("pack",pack)
	..
	..S tmpstr=patno_patname_incidesc_qty_uomdesc_dosage_freq_spec_instruc_dura_form_pri_doctor_orddate_remark_manf_dsprowid_prescno_prescnoT_selectflag
	..S tmpstr=tmpstr_requser_psname_reqdate_pack
	..
    ..S startString=##class(web.DHCSTEXTCOMMON).GetJsonStartString(maxrow)
    ..S firstrow=##class(web.DHCSTEXTCOMMON).GetJsonFirstRow(tmpstr)
    ..S lastrow=##class(web.DHCSTEXTCOMMON).GetJsonLastRow(tmpstr)
	..
    ..i count=stpage w startString
    ..i count<endpage w firstrow
    ..i count=endpage w lastrow
    k ^TMP("dhcpha","DHCSTPIVAOUTDISPREQ","GetWaitReqDspPatInfo","NoPayPrescNo",pid)
    k ^TMP("dhcpha","DHCSTPIVAOUTDISPREQ","GetWaitReqDspPatInfo","PrescNo",pid)
    k ^TMP("dhcpha","DHCSTPIVAOUTDISPREQ","GetOrdDetailData",pid)
    k ^TMP("dhcpha","DHCSTPIVAOUTDISPREQ","GetWaitReqDspPatInfo",pid)
    
    Q ""
}

ClassMethod CheckBillStatus(dsprowidstr)
{
	s retstr=""
	S pid=##class(web.DHCSTPIVAOUTCOMMON).GetPIVAOUTPID()
	//wyx 增加loclog取自登录科室session里的科室
	s loclog=%session.Data("LOGON.CTLOCID")
	//s loclog=63
	s cnt=$l(dsprowidstr,"^")
	f num=1:1:cnt d
	.//add wyx 2015-02-28 急诊留观病人增加欠费控制
    .s dsprowid=$p(dsprowidstr,"^",num)
    .s Oeori=$p(^DHCOEDISQTY(dsprowid),"^",1)
    .s ord=+Oeori
    .s itm=$p(Oeori,"||",2)
    .s PrescNo=$p(^OEORD(ord,"I",itm,1),"^",14)
    .q:PrescNo=""
    .s EmLGflag=$p($g(^OEORD(ord,"I",itm,"DHC")),"^",17)
    .s patadm=##class(web.DHCOutPhDisp).getadm(PrescNo)
    .S Papmi=$p(^PAADM(patadm),"^",1)
    .s patname=$p(^PAPER(Papmi,"ALL"),"^",1)
    .q:$d(^TMP("dhcpha","DHCSTPIVAOUTDISPREQ","CheckBillStatus",pid,Papmi))
    .s AmtRet=##class(web.DHCSTPCHCOLLS2).CheckArrearsNew("",patadm,"",loclog)
    .i (EmLGflag="1")&(AmtRet="N") d 
    ..s ^TMP("dhcpha","DHCSTPIVAOUTDISPREQ","CheckBillStatus",pid,Papmi)=patname
	s Papmit=""
	f  s Papmit=$o(^TMP("dhcpha","DHCSTPIVAOUTDISPREQ","CheckBillStatus",pid,Papmit)) q:Papmit=""  d
	.s name=^TMP("dhcpha","DHCSTPIVAOUTDISPREQ","CheckBillStatus",pid,Papmit)
	.i retstr="" s retstr=name
	.e  s retstr=retstr_","_name
	.
	k ^TMP("dhcpha","DHCSTPIVAOUTDISPREQ","CheckBillStatus",pid)
	q retstr
}

/// 修改配液申请打包状态
/// Creator:yunhaibao
/// CreatDate:2015-10-26
/// Input:打包表ID,打包标志,申请人ID
/// Output:0失功
ClassMethod UpdateRequestPack(dsprowid, packflag, requesr) As %String
{
	s reqcompflag=##class(web.DHCSTPIVAOUTCOMMON).GetReqCompStatus(dsprowid)
	q:reqcompflag=0 -1
	s oeori=$p(^DHCOEDISQTY(dsprowid),"^",1)
	s dspstatus=$p(^DHCOEDISQTY(dsprowid),"^",7)
	//q:dspstatus="C" -2   //正式库放开
	//s prescno=$p(^OEORD(+oeori,"I",$p(oeori,"||",2),1),"^",14)
	//q:(prescno'="")&&($d(^DHCPHORDM(0,"PrescNo",prescno))) -3
    S grpno=$p(^DHCOEDISQTY(dsprowid),"^",4)
    S mdodis=##class(web.DHCSTPIVA).GetMainOEDispID(dsprowid,grpno)
    S psname=##class(web.DHCSTPIVAOUTCOMMON).GetCurStat(mdodis)
    s prescno=$p(^OEORD(+oeori,"I",$p(oeori,"||",2),1),"^",14)
    s pivastate=""
    i (prescno'="")&&(..GetMonitorStatus(prescno)'="") s pivastate="1"	
    q:(psname'="已申请")||(pivastate="1") -3
    s mpackflag=##Class(web.DHCSTPIVAOUTCOMMON).GetPackFlag(dsprowid) ///申请人员未修改打包状态的情况下,不执行下列操作 bianshuai 2015-12-07
    q:mpackflag=packflag -5
	s pivarequest=$o(^PIVADIS(0,"DODIS",dsprowid,""))  //申请表id
	tstart
    &sql(UPDATE PIVA_DispRequest SET PIVADIS_PackFlag=:packflag WHERE PIVADIS_Rowid=:pivarequest)
	i SQLCODE'=0  d
    .s ret=$$SqlErrorRecord^DHCSTERROR("UpdateRequestPack:DHCSTPIVAOUTDISPREQ",dsprowid,SQLCODE_":"_%msg)
    q:SQLCODE'=0 SQLCODE
    tcommit
 	q +$g(%ROWID)
}

/// Descript:获取当前处方最后一个状态
/// w ##class(web.DHCSTPIVAOUTDISPREQ).GetMonitorStatus("O15122300003")
ClassMethod GetMonitorStatus(PrescNo As %String) As %String
{
	///N (PrescNo)
 	S monitorID=$O(^DHCPHORDM(0,"PrescNo",PrescNo,""),-1)
 	Q:monitorID="" ""
 	S result=$p(^DHCPHORDM(monitorID),"^",2)
 	Q result
}

}
