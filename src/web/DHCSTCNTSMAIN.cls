Import sqluser

Class web.DHCSTCNTSMAIN Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// 处方明细JSON数据
/// O16101400024,0,0
/// w ##class(web.DHCSTCNTSMAIN).GetOrdDetailData("O181015000025","0","200")
ClassMethod GetOrdDetailData(prescno, stpage, limit) As %String
{
	s ^TMPDHCSTPARAMS("web.DHCSTCNTSMAIN","GetOrdDetailData")=$lb(prescno, stpage, limit) 
	q:prescno="" ##class(web.DHCSTEXTCOMMON).GetNoJson()
	s pid=##class(web.DHCSTCNTSMAIN).GetPHCNTSPID()
	s endpage=stpage+limit  //结束行
	q:endpage'>0 ##class(web.DHCSTEXTCOMMON).GetNoJson()
	s stpage=stpage+1 //开始行
	s findflag=1
	s h=0
	s ord=""
	f  s ord=$o(^OEORD(0,"PrescNo",prescno,ord))  q:ord=""  d
	.s chl=""
	.f  s chl=$o(^OEORD(0,"PrescNo",prescno,ord,chl)) q:chl=""  d
	..s orditm=ord_"||"_chl
	..s presc=$p(^OEORD(ord,"I",chl,1),"^",14) ;处方号
	..s arcimid=$p(^OEORD(ord,"I",chl,1),"^",2)  ;医嘱 ARC_ItmMast ARCIM_RowId
	..s itmmastid=$p(arcimid,"||",1)
	..s itmmastver=$p(arcimid,"||",2)
	..s arcimdesc=$p(^ARCIM(itmmastid,itmmastver,1),"^",2)
	..s inci=$o(^INCI(0,"ARCIM_DR",$p(arcimid,"||",1),"") ) 
	..q:inci=""  //医嘱名称
	..s inciDesc=$p(^INCI(inci,1),"^",2) //药品名称
	..s inciDesc=arcimdesc
	..s dsp=$o(^DHCOEDISQTY(0,"OEORI",orditm,""))
	..q:dsp=""
    ..s qty=$p(^DHCOEDISQTY(dsp),"^",2)
    ..// 医嘱改造,打包表数量为药学基本单位数量
    ..s uomdesc=""
    ..s phcdfId=$p(^ARCIM(itmmastid,itmmastver,1),"^",12)
    ..i phcdfId'="" d
    ...s uomid=$p(^PHCD(+phcdfId,"DF",+$p(phcdfId,"||",2),2),"^",4)
    ...s uomdesc=$p($g(^CT("UOM",+uomid)),"^",2)
    ..s dosagestr=##class(web.DHCSTCOMMONORDER).OeoriDosage(orditm)
    ..s freq=$p(##class(web.DHCSTCOMMONORDER).OeoriFreq(orditm),"^",4)
    ..s instru=$p(##class(web.DHCSTCOMMONORDER).OeoriInstruc(orditm),"^",2)
    ..s duration=$p(##class(web.DHCSTCOMMONORDER).OeoriDuration(orditm),"^",2)
    ..s priorty=$p(##class(web.DHCSTCOMMONORDER).OeoriPriority(orditm),"^",3)
	..s doctor=$p(##class(web.DHCSTCOMMONORDER).OeoriDoctor(orditm),"^",2)  
	..s skintest=##class(web.DHCSTCOMMONSRV).GetSkinTestResult(orditm)  ;皮试
	..s form=##class(web.DHCSTCOMMONSRV).GetForm(inci)  ;剂型
	..i $f(form,$c(13,10)) s form=$tr(form,$c(13,10),"")
	..s spec="" // 医嘱改造屏蔽 ##class(web.DHCSTCOMMONSRV).getBarcode(inci) ;规格
	..s manf=""
	..//s manf=##class(web.DHCSTITMDESC).GetManfNameByInci(inci) ;厂家
	..//i $f(manf,"-") s manf=$p(manf,"-",2)
	..//i $f(manf,$c(13,10)) s manf=$tr(manf,$c(13,10),"")
	..s remark=##class(web.DHCSTCOMMONSRV).GetOrdItmRemark(orditm) ;备注
	..s realdura=##class(web.DHCSTCNTSCOMMON).GetRealDuration(orditm) ;实际疗程
	..s basflag=##class(web.DHCST.Common.DrugInfoCommon).GetBasicByPhcdf(phcdfId)	// 基本药物
	..s statdr=$p(^OEORD(ord,"I",chl,1),"^",13)
	..s oeflag=$p(^OEC("OSTAT",statdr),"^",1) 
	..s dsp=$o(^DHCOEDISQTY(0,"OEORI",orditm,""))
	..q:dsp=""
	..s status=$p(^DHCOEDISQTY(dsp),"^",7)
	..q:(oeflag'="V")&(oeflag'="E")&(status'="C")
	..s dsp=""
	..f  s dsp=$o(^DHCOEDISQTY(0,"OEORI",orditm,dsp)) q:dsp=""  d
	...s status=$p(^DHCOEDISQTY(dsp),"^",7)
	...q:status="R"
    ...s orddate=$p(^DHCOEDISQTY(dsp),"^",15)
    ...i orddate'="" s orddate=##class(websys.Conversions).DateLogicalToHtml(orddate)
    ...s ordtime=$p(^DHCOEDISQTY(dsp),"^",16)
    ...i ordtime'="" s ordtime=##class(websys.Conversions).TimeLogicalToHtml(ordtime)
    ...s orddatetime=orddate_" "_ordtime  ;开单日期
    ...s h=h+1
    ...s data=skintest_" "_inciDesc_"^"_qty_"^"_uomdesc_"^"_dosagestr_"^"_freq_"^"_spec_"^"_instru_"^"_duration_"^"_form
    ...s data=data_"^"_priorty_"^"_doctor_"^"_orddatetime_"^"_remark_"^"_manf_"^"_basflag_"^"_realdura_"^"_orditm
    ...s ^TMP("dhcpha","DHCSTCNTSMAIN","GetOrdDetailData",pid,h)=data
    
    q:h=0 ##class(web.DHCSTEXTCOMMON).GetNoJson()
    s maxrow=h
    i endpage>maxrow s endpage=maxrow
    s count=0
    s h=""
    f  s h=$o(^TMP("dhcpha","DHCSTCNTSMAIN","GetOrdDetailData",pid,h)) q:h=""  d
    .s data=^TMP("dhcpha","DHCSTCNTSMAIN","GetOrdDetailData",pid,h)
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
    .s oeorditm=$p(data,"^",17)
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
	.s oeorditm=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("oeorditm",oeorditm)
	.s realdura=##class(web.DHCSTEXTCOMMON).GetJsonLastCell("realdura",realdura)
	.
	.
	.s tmpstr=incidesc_qty_uomdesc_dosage_freq_spec_instruc_dura_form_pri_doctor_orddate_remark_manf_basflag_oeorditm_realdura
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
    
    
    k ^TMP("dhcpha","DHCSTCNTSMAIN","GetOrdDetailData",pid)
    q ""
}

/// 获取科室集合
/// w ##class(web.DHCSTCNTSMAIN).GetDocLocStore("fs")
ClassMethod GetDocLocStore(comboText = "", LogonHospId) As %String
{
	//s ^tmyq("GetDocLocStore")=comboText
	s comboText=$zcvt(comboText,"U")
	s pid=##class(web.DHCSTCNTSMAIN).GetPHCNTSPID()
	s h=0
	s locdr=0
	f  s locdr=$o(^CTLOC(locdr)) q:(locdr=0)||(locdr="")  d
	.s locdesc=$p(^CTLOC(locdr),"^",2)
	.s hospdr=$p(^CTLOC(locdr),"^",22)
	.q:(hospdr'="")&(hospdr'=LogonHospId) ;过滤院区
	.s ctlocconname=$zcvt($p(^CTLOC(locdr),"^",43),"U")
	.q:(comboText'="")&&($zcvt(locdesc,"U")'[comboText)&&(ctlocconname'[comboText)
	.s activedate=$p(^CTLOC(locdr),"^",25)
    .q:(activedate'="")&(activedate<+$h)
    .s type=$p(^CTLOC(locdr),"^",13)
    .q:(type'="E")&&(type'="EM")
    .s outunit=$p(^CTLOC(locdr),"^",68)
    .//q:outunit'="Y"
    .s locdr=$p(locdr,$c(13),1)
    .s locdesc=$p(locdesc,$c(13),1)
	.s data=locdesc_"^"_locdr
	.
	.s h=h+1
	.s ^TMP("dhcpha","DHCSTCNTSMAIN","GetDocLocStore",pid,h)=data
	.
	q:h=0 ##class(web.DHCSTEXTCOMMON).GetNoJson()
    s maxrow=h
    s count=0
    s h=""
    f  s h=$o(^TMP("dhcpha","DHCSTCNTSMAIN","GetDocLocStore",pid,h)) q:h=""  d
    .s data=^TMP("dhcpha","DHCSTCNTSMAIN","GetDocLocStore",pid,h)
    .s locdesc=$p(data,"^",1)
    .s locdr=$p(data,"^",2)
    .s DocLocDesc=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("DocLocDesc",locdesc)
	.s DocLocID=##class(web.DHCSTEXTCOMMON).GetJsonLastCell("DocLocID",locdr)
	.s tmpstr=DocLocDesc_DocLocID
    .s startString=##class(web.DHCSTEXTCOMMON).GetJsonStartString(maxrow)
    .s firstrow=##class(web.DHCSTEXTCOMMON).GetJsonFirstRow(tmpstr)
    .s lastrow=##class(web.DHCSTEXTCOMMON).GetJsonLastRow(tmpstr)
	.s count=count+1
	.i count=1 w startString
    .i count<maxrow w firstrow
    .i count=maxrow w lastrow
    
    
    k ^TMP("dhcpha","DHCSTCNTSMAIN","GetDocLocStore",pid)
    q ""
}

/// 获取剂型集合
ClassMethod GetPHCFormStore() As %String
{
	
	s pid=##class(web.DHCSTCNTSMAIN).GetPHCNTSPID()
	s h=0
	s phcfrowid=0
	f  s phcfrowid=$o(^PHCF(phcfrowid)) q:(phcfrowid=0)||(phcfrowid="")  d
	.s phcfdesc=$p(^PHCF(phcfrowid),"^",2)
	.s phcfrowid=$p(phcfrowid,$c(13),1)
    .s phcfdesc=$p(phcfdesc,$c(13),1)
	.s data=phcfrowid_"^"_phcfdesc
	.s h=h+1
	.s ^TMP("dhcpha","DHCSTCNTSMAIN","GetPHCFormStore",pid,h)=data
	.
	q:h=0 ##class(web.DHCSTEXTCOMMON).GetNoJson()
    s maxrow=h
    s count=0
    s h=""
    f  s h=$o(^TMP("dhcpha","DHCSTCNTSMAIN","GetPHCFormStore",pid,h)) q:h=""  d
    .s data=^TMP("dhcpha","DHCSTCNTSMAIN","GetPHCFormStore",pid,h)
    .s phcfrowid=$p(data,"^",1)
    .s phcfdesc=$p(data,"^",2)
    .s PHCFDesc=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("PHCFDesc",phcfdesc)
	.s PHCFID=##class(web.DHCSTEXTCOMMON).GetJsonLastCell("PHCFID",phcfrowid)
	.s tmpstr=PHCFDesc_PHCFID
    .s startString=##class(web.DHCSTEXTCOMMON).GetJsonStartString(maxrow)
    .s firstrow=##class(web.DHCSTEXTCOMMON).GetJsonFirstRow(tmpstr)
    .s lastrow=##class(web.DHCSTEXTCOMMON).GetJsonLastRow(tmpstr)
	.s count=count+1
	.i count=1 w startString
    .i count<maxrow w firstrow
    .i count=maxrow w lastrow
    
    
    k ^TMP("dhcpha","DHCSTCNTSMAIN","GetPHCFormStore",pid)
    q ""
}

/// 获取疗程集
/// d ##class(web.DHCSTCNTSMAIN).GetPHCDUStore()
ClassMethod GetPHCDUStore() As %String
{
	
	s pid=##class(web.DHCSTCNTSMAIN).GetPHCNTSPID()
	s h=0
	s phcdurowid=0
	f  s phcdurowid=$o(^PHCDU(phcdurowid)) q:(phcdurowid=0)||(phcdurowid="")  d
	.s phcdudesc=$p(^PHCDU(phcdurowid),"^",1)
	.s phcdurowid=$p(phcdurowid,$c(13),1)
    .s phcdudesc=$p(phcdudesc,$c(13),1)
	.s data=phcdurowid_"^"_phcdudesc
	.
	.s h=h+1
	.s ^TMP("dhcpha","DHCSTCNTSMAIN","GetPHCDUStore",pid,h)=data
	.
	q:h=0 ##class(web.DHCSTEXTCOMMON).GetNoJson()
    s maxrow=h
    s count=0
    s h=""
    f  s h=$o(^TMP("dhcpha","DHCSTCNTSMAIN","GetPHCDUStore",pid,h)) q:h=""  d
    .s data=^TMP("dhcpha","DHCSTCNTSMAIN","GetPHCDUStore",pid,h)
    .s phcdurowid=$p(data,"^",1)
    .s phcdudesc=$p(data,"^",2)
    .s PHCDUDesc=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("PHCDUDesc",phcdudesc)
	.s PHCDUID=##class(web.DHCSTEXTCOMMON).GetJsonLastCell("PHCDUID",phcdurowid)
	.s tmpstr=PHCDUDesc_PHCDUID
    .s startString=##class(web.DHCSTEXTCOMMON).GetJsonStartString(maxrow)
    .s firstrow=##class(web.DHCSTEXTCOMMON).GetJsonFirstRow(tmpstr)
    .s lastrow=##class(web.DHCSTEXTCOMMON).GetJsonLastRow(tmpstr)
	.s count=count+1
	.i count=1 w startString
    .i count<maxrow w firstrow
    .i count=maxrow w lastrow
    
    
    k ^TMP("dhcpha","DHCSTCNTSMAIN","GetPHCDUStore",pid)
    q ""
}

/// Description:构造某分类药品信息
/// Creator:LiangQiang
/// w ##class(web.DHCSTCNTSMAIN).GetDrugNameDs("amx",0,inciLimit)
ClassMethod GetDrugNameDsOld(input, startpage, limitpage) As %String
{
	
    s endpage=startpage+limitpage
	d killtmp1
	s num=0
	&sql(DECLARE curtt CURSOR FOR
	        select distinct inca_inci_dr from inc_alias 
	         where %ALPHAUP(inca_text) %STARTSWITH %ALPHAUP(:input))  
	&sql(OPEN curtt)
	f  &sql(fetch curtt into :inci )  q:SQLCODE  d
	.q:##class(web.DHCSTITMDESC).CatType(inci)'="G"
	.s num=num+1
	.s ^TMP($j,"Itmrowid",num)=inci
	.s ^TMP($j,"Itmcode",num)=$p(^INCI(inci,1),"^",1)
	.s ^TMP($j,"Itmdesc",num)=$p(^INCI(inci,1),"^",2)
	.s uomdr=$p(^INCI(inci,1),"^",10)
	.s ^TMP($j,"ItmUO",num)="" i uomdr'="" s ^TMP($j,"ItmUO",num)=$p(^CT("UOM",+uomdr),"^",2)
	.
	q:num=0 ##class(web.DHCSTEXTCOMMON).GetNoJson()
	s maxrow=num
	s count=0
	f i=1:1:num  d 
	. s info=##class(web.DHCSTITMDESC).ListItms(i)
	.s incirowid=$p(info,"^",1)
	.s incicode=$p(info,"^",2)
	.s incidesc=$p(info,"^",3)
	.
	.s incirowid=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("rowId",incirowid)
	.s incicode=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("itmcode",incicode)
	.s incidesc=##class(web.DHCSTEXTCOMMON).GetJsonLastCell("itmdesc",incidesc)
	.s tmpstr=incirowid_incicode_incidesc
    .s startString=##class(web.DHCSTEXTCOMMON).GetJsonStartString(maxrow)
    .s firstrow=##class(web.DHCSTEXTCOMMON).GetJsonFirstRow(tmpstr)
    .s lastrow=##class(web.DHCSTEXTCOMMON).GetJsonLastRow(tmpstr)
	.s count=count+1
	.Q:(count<startpage)||(count>endpage)
	.i (count=1)||(count=startpage) w startString 
	.i (count<endpage)||(count<maxrow) w firstrow 
    .i (count=endpage)||(count=maxrow) w lastrow
    d killtmp1
    q ""
    
   
killtmp1
   	k ^TMP($j,"Itmrowid")
	k ^TMP($j,"Itmcode")
	k ^TMP($j,"Itmdesc")
	q
}

/// Author : MYQ
/// CreatDate : 20170316
/// Description : 查询药品信息
/// 
/// w ##class(web.DHCSTCNTSMAIN).GetDrugNameDs("amx",0,100)
ClassMethod GetDrugNameDs(input, startpage, limitpage) As %String
{
	//where %ALPHAUP(inca_text) %STARTSWITH %ALPHAUP(:input))  
    s endpage=startpage+limitpage
    s pid=##class(web.DHCSTCNTSMAIN).GetPHCNTSPID()
	d killtmp
	s num=0
	s input="%"_$$ALPHAUP^SSUTIL4(input)_"%"
	s result = ##class(%Library.ResultSet).%New()
    s sqlStr = ""
    s sqlStr ="select distinct inca_inci_dr from inc_alias " _
            "where %ALPHAUP(inca_text) like '"_input_"' and inca_inci_dr->inci_incsc_dr in "_ 
             "(Select scgr_stkcat_dr from dhc_stkcatgrprelations Where scgr_scg_parref->SCG_Type='G')"
            
    d result.Prepare(sqlStr)
    s sc=result.Execute()
    s err=$$$ISERR(sc)

    If $$$ISERR(sc) q ""
    
    While(result.Next())
    {   
        s inci = result.Data("INCA_INCI_DR")
        s incicode = $p(^INCI(inci,1),"^",1)
        s incidesc = $p(^INCI(inci,1),"^",2)
        s num=num+1
        s ^TMP("dhcpha","web.DHCSTCNTSMAIN","GetDrugNameDs",pid,"DrugInfo",num)=inci_"^"_incicode_"^"_incidesc
        
    }
    
	q:num=0 ##class(web.DHCSTEXTCOMMON).GetNoJson()
	s maxrow=num
	s count=0
	s counter=0
	f  s counter=$o(^TMP("dhcpha","web.DHCSTCNTSMAIN","GetDrugNameDs",pid,"DrugInfo",counter)) q:counter=""  d 
	.s tmpdata=$g(^TMP("dhcpha","web.DHCSTCNTSMAIN","GetDrugNameDs",pid,"DrugInfo",counter))
	.s incirowid=$p(tmpdata,"^",1)
	.s incicode=$p(tmpdata,"^",2)
	.s incidesc=$p(tmpdata,"^",3)
	.
	.s incirowid=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("rowId",incirowid)
	.s incicode=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("itmcode",incicode)
	.s incidesc=##class(web.DHCSTEXTCOMMON).GetJsonLastCell("itmdesc",incidesc)
	.s tmpstr=incirowid_incicode_incidesc
    .s startString=##class(web.DHCSTEXTCOMMON).GetJsonStartString(maxrow)
    .s firstrow=##class(web.DHCSTEXTCOMMON).GetJsonFirstRow(tmpstr)
    .s lastrow=##class(web.DHCSTEXTCOMMON).GetJsonLastRow(tmpstr)
	.s count=count+1
	.Q:(count<startpage)||(count>endpage)
	.i (count=1)||(count=startpage) w startString 
	.i (count<endpage)||(count<maxrow) w firstrow 
    .i (count=endpage)||(count=maxrow) w lastrow
    d killtmp
    q ""
    
   
killtmp
   	k ^TMP("dhcpha","web.DHCSTCNTSMAIN","GetDrugNameDs",pid)
	q
}

/// 获取最大评单号
ClassMethod GetMaxCommentNo(prefix) As %String
{
	 s curdate=$zd(+$h,8)
	 l +^DHCPHCNTS:5 e  q -1
	 i '$d(^DHCPHCOMMENTS("NO",prefix,+$h)) d
	 .k ^DHCPHCOMMENTS("NO",prefix)   
	 .s stream=1
	 .s ^DHCPHCOMMENTS("NO",prefix,+$h)=2
	 e  d
	 .s stream=^DHCPHCOMMENTS("NO",prefix,+$h)
	 .s ^DHCPHCOMMENTS("NO",prefix,+$h)=^DHCPHCOMMENTS("NO",prefix,+$h)+1
	 l -^DHCPHCNTS
	 //s prefix="C"
	 s inno=prefix_curdate_"_"_$tr($j(stream,3)," ","0")
	 s P0=inno
	 q P0
}

/// 保存点评明细数据
ClassMethod SaveCommentItm(pid, main, resaveflag = "") As %String
{
	s ret=0
	s i="" 
	f  s i=$o(^TMP("dhcpha","DHCSTCNTSMAIN","GetPrescData","ForSaveData",pid,i)) q:(i="")||(ret'=0)  d
	.s itmdata=^TMP("dhcpha","DHCSTCNTSMAIN","GetPrescData","ForSaveData",pid,i)
	.s prescno=$p(itmdata,"^",1)
	.s orditem=$p(itmdata,"^",2)
	.s adm=$p(itmdata,"^",3)
	.s ord=$p(orditem,"||",1)
	.s chl=$p(orditem,"||",2)
	.s doclocdr=$p(^OEORD(ord,"I",chl,1),"^",3)
	.s docdr=$p($g(^OEORD(ord,"I",chl,7)),"^",1)
	.s passval=$g(^TMP("dhcpha","DHCSTCNTSMAIN","GetPrescData","PassData",pid,prescno))
	.s ret=..SaveItm(main,prescno,orditem,adm,doclocdr,docdr,passval,resaveflag)
	q:ret'=0 ret
	q 0
}

/// 保存点评明细表
/// resaveflag-重复抽取标记
ClassMethod SaveItm(main, prescno, orditem, adm, doclocdr, docdr, passval = "", resaveflag = "") As %String
{
	s val=$p(passval,"^",1)
	q:($D(^DHCPHCNTS(0,"OrdItem",orditem))&&(resaveflag'="Y")) -10  //已存在
	k PLIST
	s PLIST(0)=main
	s PLIST(2)=+$o(^DHCPHCNTS(main,"I",""),-1)+1
	s PLIST(3)=prescno
	s PLIST(4)=orditem
	s PLIST(5)=adm
	s PLIST(6)=doclocdr
	s PLIST(7)=docdr
	s PLIST(10)=val
	
	&sql(INSERT INTO DHC_PHCOMMENTSITM VALUES :PLIST())
	q:SQLCODE -1
 	q 0
}

/// 保存点评结果
/// reasonstr组织字符串 ：原因ID1^原因ID2 $$$ 药品ID1 ! 药品ID3^原因ID2 
/// 1523||3,Y,1106,,^^^193,1791||1
/// w ##class(web.DHCSTCNTSMAIN).SaveItmResult("1523||3","Y",1106,"","^^^193","1791||1")
ClassMethod SaveItmResult(orditem, result, user, reasonstr, input, otherstr = "") As %String
{
	s advice=$p(input,"^",1)
	s factor=$p(input,"^",2)
	s phnote=$p(input,"^",3)
	s grpdr=$p(input,"^",4)
	s pcntsi=$p(otherstr,"^",1)	
	//MYQ 20160805 
	//根据点评子表id保存点评结果,不再根据医嘱取点评子表id(重复抽取会导致根据医嘱取值不准)
	i pcntsi'="" d
	.s main=+pcntsi
	.s itm=$p(pcntsi,"||",2)
	e  d
	.s main=$o(^DHCPHCNTS(0,"OrdItem",orditem,""))
	q:main="" -1_"^"_"请先保存数据"
	s:pcntsi="" itm=$o(^DHCPHCNTS(0,"OrdItem",orditem,main,""))
	q:itm="" -1
    s PCNTSI=main_"||"_itm
    
    //判断权限
    s curret=$p(^DHCPHCNTS(main,"I",itm),"^",6) 
    s wayid=$p(^DHCPHCNTS(main),"^",7)
    s config=##class(web.DHCSTCNTSCOMMON).GetSecGrpConfigStr(wayid,grpdr)
    s updateflag=$p(config,"^",1)
    q:(curret'="")&(updateflag'="Y") -33  //无权修改
    // 判断是否已经分配
    s allotUserId=$p($g(^DHCPHCNTS(main,"I",itm)),"^",7)
    //已分配点评药师，但不是当前点评人且无修改权限时不允许点评
    q:(allotUserId'="")&&(allotUserId'=user)&&(updateflag'="Y") "-44"

    s currdate=+$h
    s currtime=$p($h,",",2)
	tstart
	&sql(update DHC_PHCOMMENTSITM set PCNTSI_CurrRet=:result where PCNTSI_RowID=:PCNTSI)
	i SQLCODE'=0 tro
	q:SQLCODE'=0 -2
	//
	s sub=""
	f  s sub=$o(^DHCPHCNTS(main,"I",itm,"L",sub),-1) q:sub=""  d
	.s active=$p(^DHCPHCNTS(main,"I",itm,"L",sub),"^",11)
	.s $p(^DHCPHCNTS(main,"I",itm,"L",sub),"^",11)="N"
	.
	s sendreasonstring="",sendordstring=""
	s Active="Y"
	s ret=0
	s tmpstr=reasonstr
	s cnt=$l(tmpstr,"!")
	f h=1:1:cnt q:ret'=0  d
	.s grpno=..GetLogGrpNo(main,itm)
	.s splitstr=$p(tmpstr,"!",h)
	.s tmpreasonstr=$p(splitstr,"$$$",1)
	.s reacnt=$l(tmpreasonstr,"^")
	.f n=1:1:reacnt q:ret'=0  d
	..s reasondr=$p(tmpreasonstr,"^",n)  //原因ID
	..i reasondr'="" d
	...i $d(SaveItmResultReason(h,1)) d
	....s SaveItmResultReason(h,1)=SaveItmResultReason(h,1)_","_$p($g(^DHCPCREASON(+reasondr)),"^",2)
	...e  d
	....s SaveItmResultReason(h,1)=$p($g(^DHCPCREASON(+reasondr)),"^",2)
	..k PLIST
	..s PLIST(0)=PCNTSI
	..s PLIST(2)=+$o(^DHCPHCNTS(main,"I",itm,"L",""),-1)+1
	..s PLIST(3)=reasondr
	..s PLIST(4)=currdate
	..s PLIST(5)=currtime
	..s PLIST(6)=user
	..s PLIST(7)=advice
	..s PLIST(9)=factor
	..s PLIST(10)=result
	..s PLIST(11)=phnote
	..s PLIST(12)="" //医生备注
	..s PLIST(13)=Active
	..s PLIST(14)=grpno
	..&sql(INSERT INTO DHC_PHCOMMENTSLOG VALUES :PLIST())
	..i SQLCODE'=0 tro
	..i SQLCODE'=0 s ret=SQLCODE
	..q:ret'=0
	..s logrowid=%ROWID
	..i n=1 s grplogr=logrowid
	.q:ret'=0
	.q:result'="N"
	.f m=2:1:$l(splitstr,"$$$") q:ret'=0  d
	..s selorditm=$p(splitstr,"$$$",m) //医嘱ID
	..s sendarcitm=$p(^OEORD(+selorditm,"I",$p(selorditm,"||",2),1),"^",2)	//医嘱项id
	..i $d(SaveItmResultReason(h,0)) d
	...s SaveItmResultReason(h,0)=SaveItmResultReason(h,0)_","_$p(^ARCIM(+sendarcitm,$p(sendarcitm,"||",2),1),"^",2)
	..e  d
	...s SaveItmResultReason(h,0)=$p(^ARCIM(+sendarcitm,$p(sendarcitm,"||",2),1),"^",2)
	..s mainorditm=##class(web.DHCSTCNTSCOMMON).GetMainOeori(selorditm)
	..s doctordr=$p($g(^OEORD(+selorditm,"I",$p(selorditm,"||",2),7)),"^",1)
	..s doclocdr=$p(^OEORD(+selorditm,"I",$p(selorditm,"||",2),1),"^",3)
	..&sql(insert into DHC_PHCNTSTABOOLIST (PCT_OrdItem_Dr,PCT_MainOrdItem_Dr,PCT_CLog_Dr,PCT_Doctor_Dr,PCT_DocLoc_Dr,PCT_Date) VALUES (:selorditm,:mainorditm,:grplogr,:doctordr,:doclocdr,:currdate))
	..i SQLCODE'=0 s ret=SQLCODE
	..i SQLCODE'=0 tro
	.q:ret'=0
	.
	q:ret'=0 -3
	tcommit
	// yunhaibao,20180717,消息内容药品与原因对应
	s ConText=""
	s textI=""
	f  s textI=$o(SaveItmResultReason(textI)) q:textI=""  d
	.s incDescStr=$g(SaveItmResultReason(textI,0))
	.s reasonStr=$g(SaveItmResultReason(textI,1))
	.s sendReasonStr=incDescStr_"	原因："_reasonStr
	.s ConText=$s(ConText="":sendReasonStr,1:ConText_"</br>"_sendReasonStr)
	//：发送消息
	s ret1=##class(web.DHCSTInterfaceMessage).SendAppealComment(PCNTSI,"Exec")
	i result="N" d
	.s ConText="  门诊处方点评不通过"_"</br>"_ConText
	.s ret=##class(web.DHCSTInterfaceMessage).SendCommentResult(PCNTSI,"Cancel")
	.s ret=##class(web.DHCSTInterfaceMessage).SendCommentResult(PCNTSI,"Send","",ConText)
	q 0
}

/// 查询处方点评单
/// 2,64141,64159,^,97
/// w ##class(web.DHCSTCNTSMAIN).QueryCommonts(2,64141,64159,"^",97)
/// w ##class(web.DHCSTCNTSMAIN).QueryCommonts(2,64418,64783,"^^^2",306)
ClassMethod QueryCommonts(findflag, stdate, enddate, parstr = "", LogonLocId) As %String
{
	s ^tmyq("QueryCommonts")=findflag_","_stdate_","_enddate_","_parstr_","_LogonLocId
	s pid=##class(web.DHCSTCNTSMAIN).GetPHCNTSPID()
	s LogonHospDr=$p(^CTLOC(LogonLocId),"^",22)
	s pcntstype="F^P"
	i findflag="1" s pcntstype="F"
	i findflag="2" s pcntstype="P"
    s waydr=$p(parstr,"^",1)
    s submitdr=$p(parstr,"^",2) //add by myq 20150601
    s phamaid=$p(parstr,"^",3)
    s retflag=$p(parstr,"^",4)
    
    s phassuserid=""
    s:phamaid'="" phassuserid=$p(^DHCPCALU(phamaid),"^",1)
    s h=0
	f date=stdate:1:enddate d
	.s typecnt=$l(pcntstype,"^")
	.f i=1:1:typecnt d
	..s type=$p(pcntstype,"^",i)
	..s pcnts=""
	..f  s pcnts=$o(^DHCPHCNTS(0,"Date",date,type,pcnts)) q:pcnts=""  d
	...q:..ChkCommonts(pcnts,submitdr)'=1  ;add by myq 20150601
	...s ret=0
	...i retflag'="" d
	....s chl=""
	....f  s chl=$o(^DHCPHCNTS(pcnts,"I",chl)) q:(chl="")||(ret=1)  d
	.....s curret=$p(^DHCPHCNTS(pcnts,"I",chl),"^",6) ;结果
	.....s itmrowid=pcnts_"||"_chl
	.....s curret=..ChkItmResult(curret,retflag,itmrowid)
	.....s:curret="1" ret="1"
	...q:(retflag'="")&&(ret'=1)
	...s pcntshospdr=$p(^DHCPHCNTS(pcnts),"^",8)
	...q:(pcntshospdr'="")&(pcntshospdr'=LogonHospDr) ;过滤院区 add by myq 20140826
	...s tsub=""
	...s:phassuserid'="" tsub=$o(^DHCPHCNTS(0,"AllotUser",phassuserid,pcnts,""))
	...q:(tsub="")&(phassuserid'="")
	...s pcntsno=$p(^DHCPHCNTS(pcnts),"^",1)
	...s pcntsdate=$p(^DHCPHCNTS(pcnts),"^",2)
	...i pcntsdate'="" s pcntsdate=##class(websys.Conversions).DateLogicalToHtml(pcntsdate)
	...s pcntstime=$p(^DHCPHCNTS(pcnts),"^",3)
	...i pcntstime'="" s pcntstime=##class(websys.Conversions).TimeLogicalToHtml(pcntstime)
	...s pcntstext=$p(^DHCPHCNTS(pcnts),"^",4)
	...s dateperiod=$p(pcntstext,",",1)
	...s istdatestr=$p(dateperiod,"至",1)
	...s istdate=$p(istdatestr,":",2)
	...s istdate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(istdate)
	...s ienddatestr=$p(dateperiod,"至",2)
	...s ienddate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(ienddatestr)
	...s tmpnote="日期范围:"_istdate_"至"_ienddate_","
	...s pcntstext=tmpnote_$p(pcntstext,",",2,100)
	...s pcntsuserdr=$p(^DHCPHCNTS(pcnts),"^",6)
	...s pcntsuser=$p(^SSU("SSUSR",pcntsuserdr),"^",2)
	.../// add by myq 20150601 添加变色标记
	...s colorflag=0
	...s pcntsubmit=..GetPCommontsStatus(pcnts)
	...i type="F" s typedesc="门(急)诊"
	...i type="P" s typedesc="住院"
	...s tmpwaydr=$p(^DHCPHCNTS(pcnts),"^",7)
	...s waydesc=""
    ...q:(tmpwaydr'=waydr)&(waydr'="")
	...i tmpwaydr'="" d
	....q:'$d(^DHCPCWAY(tmpwaydr))
	....s waydesc=$p(^DHCPCWAY(tmpwaydr),"^",2)
	...s h=h+1
	...s data=pcntsno_"^"_pcntsdate_"^"_pcntstime_"^"_pcntstext_"^"_pcntsuser_"^"_typedesc_"^"_pcnts_"^"_waydesc_"^"_pcntsubmit
	...s ^TMP("dhcpha","DHCSTCNTSMAIN","QueryCommonts",pid,h)=data
	..
	.
	q:h=0 ##class(web.DHCSTEXTCOMMON).GetNoJson()
    s maxrow=h
    s count=0
    s h=""
    f  s h=$o(^TMP("dhcpha","DHCSTCNTSMAIN","QueryCommonts",pid,h)) q:h=""  d
    .s data=^TMP("dhcpha","DHCSTCNTSMAIN","QueryCommonts",pid,h)
    .s pcntsno=$p(data,"^",1)
    .s pcntsdate=$p(data,"^",2)
    .s pcntstime=$p(data,"^",3)
    .s pcntstext=$p(data,"^",4)
    .s pcntsuser=$p(data,"^",5)
    .s typedesc=$p(data,"^",6)
    .s pcnts=$p(data,"^",7)
    .s waydesc=$p(data,"^",8)
    .s pcntsubmit=$p(data,"^",9)
    .
    .s pcntsno=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("comno",pcntsno)
    .s pcntsdate=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("comdate",pcntsdate)
    .s pcntstime=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("comtime",pcntstime)
    .s pcntsuser=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("comcreator",pcntsuser)
    .s typedesc=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("comtype",typedesc)
	.s pcntstext=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("comtext",pcntstext)
	.s pcnts=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("comrowid",pcnts)
	.s pcntsubmit=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("pcntsubmit",pcntsubmit)
	.s waydesc=##class(web.DHCSTEXTCOMMON).GetJsonLastCell("comway",waydesc)
	.
	.s tmpstr=pcntsno_pcntsdate_pcntstime_pcntsuser_typedesc_pcntstext_pcnts_pcntsubmit_waydesc
    .s startString=##class(web.DHCSTEXTCOMMON).GetJsonStartString(maxrow)
    .s firstrow=##class(web.DHCSTEXTCOMMON).GetJsonFirstRow(tmpstr)
    .s lastrow=##class(web.DHCSTEXTCOMMON).GetJsonLastRow(tmpstr)
	.s count=count+1
	.i count=1 w startString
    .i count<maxrow w firstrow
    .i count=maxrow w lastrow

    k ^TMP("dhcpha","DHCSTCNTSMAIN","QueryCommonts",pid)
    
    
    
	q ""
}

/// 删除点评单
ClassMethod DelCommonts(pcntsno) As %String
{
	//先清除 药品禁忌表 中数据 add by myq 20161226
	&sql(delete from DHC_PHCNTSTABOOLIST where PCT_CLog_Dr->PCNTSL_ParRef_Dr->PCNTSI_ParRef_Dr->PCNTS_No=:pcntsno )
	i (SQLCODE'=0)&&(SQLCODE'=100) q -1
	// SQLCODE=100 代表没有找到满足SQL语句的行,即
	&sql(delete from DHC_PHCOMMENTS where PCNTS_No=:pcntsno)
	i SQLCODE'=0 q -1

	q 0
}

/// 选取点评单,调出点评单内容
/// "1172^^0^200^"
/// w ##class(web.DHCSTCNTSMAIN).QueryCommontItm("1149","","0","200","")
ClassMethod QueryCommontItm(pcnts, retflag, stpage, limit, phama) As %String
{
	//s ^tmyq("QueryCommontItm")=pcnts_"^"_retflag_"^"_stpage_"^"_limit_"^"_phama
	s endpage=stpage+limit  //结束行
	s stpage=stpage+1 //开始行
    s h=0
    s pid=##class(web.DHCSTCNTSMAIN).GetPHCNTSPID()
	s pcntsno=$p(^DHCPHCNTS(pcnts),"^",1)
	s pcntsdate=$p(^DHCPHCNTS(pcnts),"^",2)
	i pcntsdate'="" s pcntsdate=##class(websys.Conversions).DateLogicalToHtml(pcntsdate)
	s pcntstime=$p(^DHCPHCNTS(pcnts),"^",3)
	i pcntstime'="" s pcntstime=##class(websys.Conversions).TimeLogicalToHtml(pcntstime)
	s pcntstext=$p(^DHCPHCNTS(pcnts),"^",4)
	s pcntsuserdr=$p(^DHCPHCNTS(pcnts),"^",6)
	s pcntsuser=$p(^SSU("SSUSR",pcntsuserdr),"^",2)
	s type=$p(^DHCPHCNTS(pcnts),"^",5)
	i type="F" s typedesc="门诊"
	i type="P" s typedesc="住院"
	s waydr=$p(^DHCPHCNTS(pcnts),"^",7)
	s chl=""
	f  s chl=$o(^DHCPHCNTS(pcnts,"I",chl)) q:chl=""  d
	.s prescno=$p(^DHCPHCNTS(pcnts,"I",chl),"^",1)
	.s orditem=$p(^DHCPHCNTS(pcnts,"I",chl),"^",2)
	.s curret=$p(^DHCPHCNTS(pcnts,"I",chl),"^",6)
	.s phamadr=$p(^DHCPHCNTS(pcnts,"I",chl),"^",7)
	.s passval=$p(^DHCPHCNTS(pcnts,"I",chl),"^",8)
	.s phamaindex=""
	.s:phama'="" phamaindex=$p(^DHCPCALU(phama),"^",1)
	.q:(phamadr'=phamaindex)&&(phamaindex'="")
	.s itmrowid=pcnts_"||"_chl
	.s curret=..ChkItmResult(curret,retflag,itmrowid)  ;当前点评结果
	.q:curret=0
	.s adm=$p(^DHCPHCNTS(pcnts,"I",chl),"^",3)
	.q:'$d(^PAADM(adm))
	.s papmi=$p(^PAADM(adm),"^",1)
	.s patname=$p(^PAPER(papmi,"ALL"),"^", 1) ;患者姓名
	.s sex=$p(^PAPER(papmi,"ALL"),"^",7 ) ;姓别
	.s patsex=$p(^CT("SEX",sex),"^",2)
	.s patno=$p(^PAPER(papmi,"PAT",1),"^",1)
	.s patage=##class(web.DHCSTKUTIL).GetAge(papmi)  ;年龄 
	.s type="" 
    .i $p(^DHCPHCNTS(pcnts),"^",5)="F" d 
    ..s ord=$o(^OEORD(0,"PrescNo",prescno,""))
  	..q:ord=""
    ..s itm=$o(^OEORD(0,"PrescNo",prescno,ord,""))
    ..q:itm=""
    ..s typedr=$p($g(^OEORD(ord,"I",itm,11)),"^",18) //门诊患者取医嘱表中费别 20160829 MYQ
	.i $p(^DHCPHCNTS(pcnts),"^",5)="P" d 
	..s typedr=$p(^PAADM(adm,1),"^",7)	//住院患者取pa_adm中费别
	.s:typedr'="" type=$p($g(^PAC("ADMREA",typedr)),"^",2)
    .s diag=##class(web.DHCSTKUTIL).GetMRDiagnosDesc(adm,",") ;诊断
	.s doclocdr=$p(^DHCPHCNTS(pcnts,"I",chl),"^",4)
	.s orddept=""
	.i doclocdr'="" d
    ..s orddept=$p(^CTLOC(doclocdr),"^",2)  ;科室
	.i $f(orddept,"-") s orddept=$p(orddept,"-",2)
	.s doctor=""
	.s docdr=$p(^DHCPHCNTS(pcnts,"I",chl),"^",5)
	.i docdr'="" d
	..s doctor=$p(^SSU("SSUSR",docdr),"^",2)  ;医生
	.s curret=$p(^DHCPHCNTS(pcnts,"I",chl),"^",6) ;结果
	.i curret="Y" s curret="合格"
	.s docremark=""
	.s docacceptflag=""
	.s sub=""
	.f  s sub=$o(^DHCPHCNTS(pcnts,"I",chl,"L",sub)) q:(sub="")||((docremark'="")&&(docremark'="Accept"))  d
	..s activeflag=$p(^DHCPHCNTS(pcnts,"I",chl,"L",sub),"^",11)
	..q:activeflag'="Y"
	..s docremark=$p(^DHCPHCNTS(pcnts,"I",chl,"L",sub),"^",10)
	..s:docremark="Accept" docacceptflag=1
	.i (docremark'="")&&(docremark'="Accept") d
	..i curret="N" s curret="不合格(已申诉)"
	.i (docacceptflag="1") d
	..i curret="N" s curret="不合格(已接受)"
	.e  d
	..i curret="N" s curret="不合格"
	.s quer="",zcyflag=0  //草药标志
	.i prescno'="" d
	..s quer=$o(^PAQUE1(0,"PrescNo",prescno,""))
	..i quer'="" d
	...i $d(^PAQUE1(quer,"DHC")) s zcyflag=1 
	.s h=h+1
    .s data=prescno_"^"_patno_"^"_patname_"^"_patsex_"^"_patage_"^"_type_"^"_diag_"^"_orddept_"^"_adm_"^"_orditem_"^"_curret_"^"_waydr_"^"_zcyflag_"^"_passval_"^"_papmi_"^"_itmrowid
    .s ^TMP("dhcpha","DHCSTCNTSMAIN","QueryCommontItm",pid,h)=data
    q:h=0 ##class(web.DHCSTEXTCOMMON).GetNoJson()
    s maxrow=h
    
    i endpage>maxrow s endpage=maxrow
    s count=0
    s h=""
    f  s h=$o(^TMP("dhcpha","DHCSTCNTSMAIN","QueryCommontItm",pid,h)) q:h=""  d
    .s data=^TMP("dhcpha","DHCSTCNTSMAIN","QueryCommontItm",pid,h)
    .s prescno=$p(data,"^",1)
    .s patno=$p(data,"^",2)
    .s patname=$p(data,"^",3)
    .s patsex=$p(data,"^",4)
    .s patage=$p(data,"^",5)
    .s type=$p(data,"^",6)
    .s diag=$p(data,"^",7)
    .s orddept=$p(data,"^",8)
    .s adm=$p(data,"^",9)
    .s orditem=$p(data,"^",10)
    .s curret=$p(data,"^",11)
    .s waycode=$p(data,"^",12)
    .s zcyflag=$p(data,"^",13)
    .s passval=$p(data,"^",14)
    .s papmi=$p(data,"^",15)
    .s pcntsi=$p(data,"^",16)
    .s passtext=""
    .i passval="0" s passtext=""
    .s prescno=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("prescno",prescno)
	.s patno=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("patno",patno)
	.s patname=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("patname",patname)
	.s patsex=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("patsex",patsex)
	.s patage=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("patage",patage)
	.s type=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("type",type)
	.s dept=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("dept",orddept)
	.s diag=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("diag",diag)
	.s adm=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("adm",adm)
	.s orditem=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("orditem",orditem)
	.s porcess=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("porcess","")
	.s curret=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("curret",curret)
	.s waycode=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("waycode",waycode)
	.s pcntsi=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("pcntsi",pcntsi)
	.s zcyflag=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("zcyflag",zcyflag)
	.s passtext=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("passtext",passtext)
	.s papmi=##class(web.DHCSTEXTCOMMON).GetJsonLastCell("papmi",papmi)
	.s count=count+1
	.q:count<stpage
    .q:count>endpage
	.s tmpstr=prescno_patno_patname_patsex_patage_type_dept_diag_adm_orditem_porcess_curret_waycode_pcntsi_zcyflag_passtext_papmi
    .s startString=##class(web.DHCSTEXTCOMMON).GetJsonStartString(maxrow)
    .s firstrow=##class(web.DHCSTEXTCOMMON).GetJsonFirstRow(tmpstr)
    .s lastrow=##class(web.DHCSTEXTCOMMON).GetJsonLastRow(tmpstr)
	.
	.;i count=1 w startString
    .;i count<maxrow w firstrow
    .;i count=maxrow w lastrow
    .i count=stpage w startString
    .i count<endpage w firstrow
    .i count=endpage w lastrow
	.
	k ^TMP("dhcpha","DHCSTCNTSMAIN","QueryCommontItm",pid)
	
	q ""
}

/// 显示点评日志
/// 664||3,1577||1
/// w ##class(web.DHCSTCNTSMAIN).QueryCommontLog("664||3","1577||1")
ClassMethod QueryCommontLog(orditem, pcntsi = "") As %String
{
	s h=0
	s pid=##class(web.DHCSTCNTSMAIN).GetPHCNTSPID()
	s mainorditm=##class(web.DHCSTCNTSCOMMON).GetMainOeori(orditem)	//获取主医嘱id
	s inpcnts=+pcntsi
	s pcnts=""
	f  s pcnts=$o(^DHCPHCNTS(0,"OrdItem",orditem,pcnts)) q:pcnts=""  d
	.q:(inpcnts'="")&&(inpcnts'=pcnts)
	.s chl=""
	.f  s chl=$o(^DHCPHCNTS(0,"OrdItem",orditem,pcnts,chl)) q:chl=""  d
	..s adm=$p(^DHCPHCNTS(pcnts,"I",chl),"^",3)
	..s pcntsitm=pcnts_"||"_chl
	..s papmi=$p(^PAADM(adm),"^",1)
	..s patname=$p(^PAPER(papmi,"ALL"),"^", 1) ;患者姓名
	..s prescno=$p(^DHCPHCNTS(pcnts,"I",chl),"^",1)
	..s sub=""
	..f  s sub=$o(^DHCPHCNTS(pcnts,"I",chl,"L",sub),-1) q:sub=""  d
	...s logrowid=pcnts_"||"_chl_"||"_sub
	...s comdate=$p(^DHCPHCNTS(pcnts,"I",chl,"L",sub),"^",3)
	...i comdate'="" s comdate=##class(websys.Conversions).DateLogicalToHtml(comdate)
	...s comtime=$p(^DHCPHCNTS(pcnts,"I",chl,"L",sub),"^",4)
	...i comtime'="" s comtime=##class(websys.Conversions).TimeLogicalToHtml(comtime)
	...s comuser=""
	...s userdr=$p(^DHCPHCNTS(pcnts,"I",chl,"L",sub),"^",5)
	...s:userdr'="" comuser=$p(^SSU("SSUSR",userdr),"^",2)
	...s comresult=$p(^DHCPHCNTS(pcnts,"I",chl,"L",sub),"^",2)
	...s tpctr=$o(^DHCPCTABL(0,"LOG",logrowid,""))
	...q:(tpctr="")&&(comresult="N")	//不合理的点评记录只显示和禁忌表关联的那一条
	...s comreason=""
	...s:comresult="N" comreason=..GetOPCommentReason(logrowid)
	...i comresult="Y" s comresult="合格"
	...i comresult="N" s comresult="不合格"
	...//s comreasondr=$p(^DHCPHCNTS(pcnts,"I",chl,"L",sub),"^",1)
	...//i comreasondr'="" d
	...//.i $d(^DHCPCREASON(comreasondr)) d
	...//..s comreason=$p(^DHCPCREASON(comreasondr),"^",2)
	...s comfactor=""
	...s comfactordr=$p(^DHCPHCNTS(pcnts,"I",chl,"L",sub),"^",8)
	...s:comfactordr'="" comfactor=$p($g(^DHCPCFACTOR(comfactordr)),"^",2)
	...s comadvice=""
	...s comadvicedr=$p(^DHCPHCNTS(pcnts,"I",chl,"L",sub),"^",6)
	...s:comadvicedr'="" comadvice=$p($g(^DHCPCADVICE(comadvicedr)),"^",2)   //药师建议
	...s comdocadvice=$p(^DHCPHCNTS(pcnts,"I",chl,"L",sub),"^",7)  //医生建议
	...s comphnote=$p(^DHCPHCNTS(pcnts,"I",chl,"L",sub),"^",9) //药师备注
	...s comdocnote=$p(^DHCPHCNTS(pcnts,"I",chl,"L",sub),"^",10)  //医师备注
	...s comactive=$p(^DHCPHCNTS(pcnts,"I",chl,"L",sub),"^",11)
	...s comgrpno=$p(^DHCPHCNTS(pcnts,"I",chl,"L",sub),"^",12)
	...//s tpctr=$o(^DHCPCTABL(0,"LOG",logrowid,""))
	...//q:tpctr=""
	...s h=h+1
    ...s data=patname_"^"_prescno_"^"_comdate_"^"_comtime_"^"_comuser_"^"_comresult_"^"_comreason_"^"_comfactor_"^"_comadvice_"^"_comdocadvice_"^"_comphnote_"^"_comdocnote_"^"_comactive_"^"_comgrpno
    ...s ^TMP("dhcpha","DHCSTCNTSMAIN","QueryCommontLog",pid,h)=data
	...s pctr=""
	...f  s pctr=$o(^DHCPCTABL(0,"LOG",logrowid,pctr)) q:pctr=""  d 
	....s orditm=$p(^DHCPCTABL(pctr),"^",1)
	....s ord=$p(orditm,"||",1)
	....s ordchl=$p(orditm,"||",2)
	....s arcimid=$p(^OEORD(ord,"I",ordchl,1),"^",2)  ;医嘱 ARC_ItmMast ARCIM_RowId
	....s itmmastid=$p(arcimid,"||",1)
	....s itmmastver=$p(arcimid,"||",2)
	....s arcimdesc=$p(^ARCIM(itmmastid,itmmastver,1),"^",2)
	....//s inci=$o(^INCI(0,"ARCIM_DR",$p(arcimid,"||",1),"") ) q:inci=""  //医嘱名称
	....//s inciDesc=$p(^INCI(inci,1),"^",2) //药品名称
	....s comreason="____"_arcimdesc
	....s h=h+1
    ....s data=""_"^"_""_"^"_""_"^"_""_"^"_""_"^"_""_"^"_comreason_"^"_""_"^"_""_"^"_""_"^"_""_"^"_""_"^"_""_""
    ....s ^TMP("dhcpha","DHCSTCNTSMAIN","QueryCommontLog",pid,h)=data
    q:h=0 ##class(web.DHCSTEXTCOMMON).GetNoJson()
    s maxrow=h
    
    s count=0
    s h=""
    f  s h=$o(^TMP("dhcpha","DHCSTCNTSMAIN","QueryCommontLog",pid,h)) q:h=""  d
    .s data=^TMP("dhcpha","DHCSTCNTSMAIN","QueryCommontLog",pid,h)
    .s patname=$p(data,"^",1)
    .s prescno=$p(data,"^",2)
    .s comdate=$p(data,"^",3)
    .s comtime=$p(data,"^",4)
    .s comuser=$p(data,"^",5)
    .s comresult=$p(data,"^",6)
    .s comreason=$p(data,"^",7)
    .s comfactor=$p(data,"^",8)
    .s comadvice=$p(data,"^",9)
    .s comdocadvice=$p(data,"^",10)
    .s comphnote=$p(data,"^",11)
    .s comdocnote=$p(data,"^",12)
    .s comactive=$p(data,"^",13)
    .s comgrpno=$p(data,"^",14)
    .
    .s patname=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("patname",patname)
	.s prescno=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("prescno",prescno)
	.s comdate=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("comdate",comdate)
	.s comtime=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("comtime",comtime)
	.s comuser=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("comuser",comuser)
	.s comresult=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("comresult",comresult)
	.s comreason=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("comreason",comreason)
	.s comfactor=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("comfactor",comfactor)
	.s comadvice=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("comadvice",comadvice)
	.s comdocadvice=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("comdocadvice",comdocadvice)
	.s comphnote=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("comphnote",comphnote)
	.s comdocnote=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("comdocnote",comdocnote)
	.s comactive=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("comactive",comactive)
	.s comgrpno=##class(web.DHCSTEXTCOMMON).GetJsonLastCell("comgrpno",comgrpno)
	.
	.s tmpstr=patname_prescno_comdate_comtime_comuser_comresult_comreason_comfactor_comadvice_comdocadvice
	.s tmpstr=tmpstr_comphnote_comdocnote_comactive_comgrpno
    .s startString=##class(web.DHCSTEXTCOMMON).GetJsonStartString(maxrow)
    .s firstrow=##class(web.DHCSTEXTCOMMON).GetJsonFirstRow(tmpstr)
    .s lastrow=##class(web.DHCSTEXTCOMMON).GetJsonLastRow(tmpstr)
	.s count=count+1
	.i count=1 w startString
    .i count<maxrow w firstrow
    .i count=maxrow w lastrow
	.
	k ^TMP("dhcpha","DHCSTCNTSMAIN","QueryCommontLog",pid)

    q ""
}

/// 获取不合格警示值集
ClassMethod GetPHCNTSFactor() As %String
{
	s h=0
	s pid=##class(web.DHCSTCNTSMAIN).GetPHCNTSPID()
	s facr=""
	f  s facr=$o(^DHCPCFACTOR(facr)) q:facr=""  d
	.s facdesc=$p(^DHCPCFACTOR(facr),"^",2)
	.s h=h+1
    .s data=facdesc_"^"_facr
    .s ^TMP("dhcpha","DHCSTCNTSMAIN","GetPHCNTSFactor",pid,h)=data
    q:h=0 ##class(web.DHCSTEXTCOMMON).GetNoJson()
    s maxrow=h
    
    s count=0
    s h=""
    f  s h=$o(^TMP("dhcpha","DHCSTCNTSMAIN","GetPHCNTSFactor",pid,h)) q:h=""  d
    .s data=^TMP("dhcpha","DHCSTCNTSMAIN","GetPHCNTSFactor",pid,h)
    .s facdesc=$p(data,"^",1)
    .s facrowid=$p(data,"^",2)
    .
    .s facdesc=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("facdesc",facdesc)
	.s facrowid=##class(web.DHCSTEXTCOMMON).GetJsonLastCell("facrowid",facrowid)
	.
	.s tmpstr=facdesc_facrowid
    .s startString=##class(web.DHCSTEXTCOMMON).GetJsonStartString(maxrow)
    .s firstrow=##class(web.DHCSTEXTCOMMON).GetJsonFirstRow(tmpstr)
    .s lastrow=##class(web.DHCSTEXTCOMMON).GetJsonLastRow(tmpstr)
	.s count=count+1
	.i count=1 w startString
    .i count<maxrow w firstrow
    .i count=maxrow w lastrow
	.
	k ^TMP("dhcpha","DHCSTCNTSMAIN","GetPHCNTSFactor",pid)
	q ""
}

/// 获取药师建议集
ClassMethod GetPHCNTSAdvice() As %String
{
	s h=0
	s pid=##class(web.DHCSTCNTSMAIN).GetPHCNTSPID()
	s pcar=""
	f  s pcar=$o(^DHCPCADVICE(pcar)) q:pcar=""  d
	.s advdesc=$p(^DHCPCADVICE(pcar),"^",2)
	.s h=h+1
    .s data=advdesc_"^"_pcar
    .s ^TMP("dhcpha","DHCSTCNTSMAIN","GetPHCNTSAdvice",pid,h)=data
    q:h=0 ##class(web.DHCSTEXTCOMMON).GetNoJson()
    s maxrow=h
    
    s count=0
    s h=""
    f  s h=$o(^TMP("dhcpha","DHCSTCNTSMAIN","GetPHCNTSAdvice",pid,h)) q:h=""  d
    .s data=^TMP("dhcpha","DHCSTCNTSMAIN","GetPHCNTSAdvice",pid,h)
    .s advdesc=$p(data,"^",1)
    .s advrowid=$p(data,"^",2)
    .
    .s advdesc=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("advdesc",advdesc)
	.s advrowid=##class(web.DHCSTEXTCOMMON).GetJsonLastCell("advrowid",advrowid)
	.
	.s tmpstr=advdesc_advrowid
    .s startString=##class(web.DHCSTEXTCOMMON).GetJsonStartString(maxrow)
    .s firstrow=##class(web.DHCSTEXTCOMMON).GetJsonFirstRow(tmpstr)
    .s lastrow=##class(web.DHCSTEXTCOMMON).GetJsonLastRow(tmpstr)
	.s count=count+1
	.i count=1 w startString
    .i count<maxrow w firstrow
    .i count=maxrow w lastrow
	.
	k ^TMP("dhcpha","DHCSTCNTSMAIN","GetPHCNTSAdvice",pid)
	q ""
}

/// 统一取最大进程号
ClassMethod GetPHCNTSPID() As %String
{
   s pid=$I(^DHCSTCOMMENTS("prescno"))
   q pid
}

/// 根据医嘱ID判断点评结果
/// Input: retflag :仅有结果:1,仅无结果:2,仅合格:3,仅不合格:4
/// Output:1.符合条件, 0.不符
/// w ##class(web.DHCSTCNTSMAIN).ChkItmResult("N","2","7||1")
ClassMethod ChkItmResult(curret, retflag, itmrowid = "") As %String
{
    
	q:retflag="" 1
  
	i (retflag=1)&(curret'="")  q 1
	i (retflag=2)&(curret="") q 1
	i (retflag=3)&(curret="Y") q 1
	i (retflag=4)&(curret="N") q 1
	
	s pcnts=$p(itmrowid,"||",1)
	s chl=$p(itmrowid,"||",2)
	s ret=0
	i retflag=5 d
	.s sub=""
	.f  s sub=$o(^DHCPHCNTS(pcnts,"I",chl,"L",sub),-1) q:sub=""  d
	..s comactive=$p(^DHCPHCNTS(pcnts,"I",chl,"L",sub),"^",11)
	..q:comactive'="Y"
	..s comdocnote=$p(^DHCPHCNTS(pcnts,"I",chl,"L",sub),"^",10)  //医师备注
	..q:comdocnote=""
	..s ret=1
	q:(retflag=5) ret
    q 0
}

/// 获取处方药品列表
ClassMethod GetOrdItms(orditem) As %String
{
	
	q:orditem="" ##class(web.DHCSTEXTCOMMON).GetNoJson()
	s mainorditm=##class(web.DHCSTCNTSCOMMON).GetMainOeori(orditem)
	s pid=##class(web.DHCSTCNTSMAIN).GetPHCNTSPID()
	s h=0
	s ord=$p(orditem,"||",1)
	s chl=$p(orditem,"||",2)
	s adm=$p(^OEORD(ord),"^",1)
    s admtype=$p(^PAADM(adm),"^",2)
    
    i admtype'="I" d
	.s prescno=$p(^OEORD(ord,"I",chl,1),"^",14)
	.s ord=""
	.f  s ord=$o(^OEORD(0,"PrescNo",prescno,ord))  q:ord=""  d
	..s chl=""
	..f  s chl=$o(^OEORD(0,"PrescNo",prescno,ord,chl)) q:chl=""  d
	...s orditm=ord_"||"_chl
	...d getdata
    e  d
    .s orditm=mainorditm
    .s ord=$p(orditm,"||",1)
    .s chl=$p(orditm,"||",2)
    .d getdata
    .s chl=""
 	.F  S chl=$O(^OEORDi(0,"OEORI",ord,mainorditm,chl)) Q:chl=""  d
 	..s orditm=ord_"||"_chl
 	..d getdata
 	
    
    q:h=0 ##class(web.DHCSTEXTCOMMON).GetNoJson()
    s maxrow=h
    
    s count=0
    s h=""
    f  s h=$o(^TMP("dhcpha","DHCSTCNTSMAIN","GetOrdItms",pid,h)) q:h=""  d
    .s data=^TMP("dhcpha","DHCSTCNTSMAIN","GetOrdItms",pid,h)
    .s DrugDesc=$p(data,"^",1)
    .s DrugID=$p(data,"^",2)
    .
    .s DrugDesc=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("DrugDesc",DrugDesc)
	.s DrugID=##class(web.DHCSTEXTCOMMON).GetJsonLastCell("DrugID",DrugID)
	.
	.s tmpstr=DrugDesc_DrugID
    .s startString=##class(web.DHCSTEXTCOMMON).GetJsonStartString(maxrow)
    .s firstrow=##class(web.DHCSTEXTCOMMON).GetJsonFirstRow(tmpstr)
    .s lastrow=##class(web.DHCSTEXTCOMMON).GetJsonLastRow(tmpstr)
	.s count=count+1
	.i count=1 w startString
    .i count<maxrow w firstrow
    .i count=maxrow w lastrow
	.
	k ^TMP("dhcpha","DHCSTCNTSMAIN","GetOrdItms",pid)
	q ""
	
getdata
     s presc=$p(^OEORD(ord,"I",chl,1),"^",14) ;处方号
	 q:presc=""
	 s statdr=$p(^OEORD(ord,"I",chl,1),"^",13)
	 s oeflag=$p(^OEC("OSTAT",statdr),"^",1) 
	 s dsp=$o(^DHCOEDISQTY(0,"OEORI",ord_"||"_chl,""))
	 q:dsp=""
	 s status=$p(^DHCOEDISQTY(dsp),"^",7)
	 q:(oeflag'="V")&(oeflag'="E")&(status'="C")
	 s priordr=+$p(^OEORD(ord,"I",chl,1),"^",8) 
     q:priordr=0 
     s priority=$p(^OECPR(priordr),"^",1) 			;医嘱优先级代码            
     q:priority["OM" ;自备药
	 s arcimid=$p(^OEORD(ord,"I",chl,1),"^",2)  ;医嘱 ARC_ItmMast ARCIM_RowId
	 s itmmastid=$p(arcimid,"||",1)
	 s itmmastver=$p(arcimid,"||",2)
	 s inci=$o(^INCI(0,"ARCIM_DR",$p(arcimid,"||",1),"") ) q:inci=""  //医嘱名称
	 s inciDesc=$p(^INCI(inci,1),"^",2) //药品名称
	 s h=h+1
     s data=inciDesc_"^"_orditm
     s ^TMP("dhcpha","DHCSTCNTSMAIN","GetOrdItms",pid,h)=data
     q
}

/// 获取管制分类列表
ClassMethod GetComBoCtrlDs() As %String
{
	s pid=##class(web.DHCSTCNTSMAIN).GetPHCNTSPID()
	s h=0
	s pccrowid=""
	f  s pccrowid=$o(^DHCPCCON(pccrowid)) q:pccrowid=""  d
	.s poisondr=$p(^DHCPCCON(pccrowid),"^",1)
	.q:'$d(^PHCPO(poisondr))
	.s poison=$p(^PHCPO(poisondr),"^",2)
	.i $f(poison,$c(13)) s poison=$p(poison,$c(13))
	.s h=h+1
    .s data=poison_"^"_poisondr
    .s ^TMP("dhcpha","DHCSTCNTSMAIN","GetComBoCtrlDs",pid,h)=data
    q:h=0 ##class(web.DHCSTEXTCOMMON).GetNoJson()
    s maxrow=h
    
    s count=0
    s h=""
    f  s h=$o(^TMP("dhcpha","DHCSTCNTSMAIN","GetComBoCtrlDs",pid,h)) q:h=""  d
    .s data=^TMP("dhcpha","DHCSTCNTSMAIN","GetComBoCtrlDs",pid,h)
    .s poison=$p(data,"^",1)
    .s poisondr=$p(data,"^",2)
    .
    .s CtrlDesc=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("CtrlDesc",poison)
	.s CtrlID=##class(web.DHCSTEXTCOMMON).GetJsonLastCell("CtrlID",poisondr)
	.
	.s tmpstr=CtrlDesc_CtrlID
    .s startString=##class(web.DHCSTEXTCOMMON).GetJsonStartString(maxrow)
    .s firstrow=##class(web.DHCSTEXTCOMMON).GetJsonFirstRow(tmpstr)
    .s lastrow=##class(web.DHCSTEXTCOMMON).GetJsonLastRow(tmpstr)
	.s count=count+1
	.i count=1 w startString
    .i count<maxrow w firstrow
    .i count=maxrow w lastrow
	.
	k ^TMP("dhcpha","DHCSTCNTSMAIN","GetComBoCtrlDs",pid)
	q ""
}

/// ;检查管制分类
/// 1 - 符合  0 - 不符
ClassMethod ChkPoison(inci, poisonstr) As %String
{
	q:poisonstr="" 1
	s chkflag=0
	s cnt=$l(poisonstr,",")
	f h=1:1:cnt d
	.s poison=$p(poisonstr,",",h)
	.s drugpoison=$p(##class(web.DHCSTCOMMONSRV).getPoisonByInci(inci),"^",1)
	.i poison=drugpoison d
	..s chkflag=1
	q chkflag
}

/// 判断医嘱有效状态
/// 1 有效 0 无效
/// Creator:LiangQiang
ClassMethod GetOrdItmStatus(orditm As %String) As %String
{
	s ret=0
	s ord=$p(orditm,"||",1)
	s chl=$p(orditm,"||",2)
	s prescno=$p(^OEORD(ord,"I",chl,1),"^",14)
	s ord=""
	f  s ord=$o(^OEORD(0,"PrescNo",prescno,ord))  q:ord=""  d
	.s chl=""
    .f  s chl=$o(^OEORD(0,"PrescNo",prescno,ord,chl)) q:chl=""  d
    ..s statdr=$p(^OEORD(ord,"I",chl,1),"^",13)
	..s oeflag=$p(^OEC("OSTAT",statdr),"^",1) 
	..s dsp=$o(^DHCOEDISQTY(0,"OEORI",ord_"||"_chl,""))
	..q:dsp=""
	..s status=$p(^DHCOEDISQTY(dsp),"^",7)
	..q:(oeflag'="V")&(oeflag'="E")&(status'="C")
	..s ret=1
	q ret
}

/// 门诊处方点评数据	
/// parstr="医生科室^药品^随机数^随机百分比^有无结果/全部"
ClassMethod GetPrescData(parstr, LogonLocId) As %String
{
	
	s findflag=1
	s stdate=$p(parstr,"^",1)
	s:stdate'="" stdate=##class(websys.Conversions).DateHtmlToLogical(stdate)
	s enddate=$p(parstr,"^",2)
	s:enddate'="" enddate=##class(websys.Conversions).DateHtmlToLogical(enddate)
    s doclocstrdr=$p(parstr,"^",3) //医生科室
	s drugID=$p(parstr,"^",4)
	s rnum=+$p(parstr,"^",5)
	s rnum=$p(rnum,".")
	s cent=+$p(parstr,"^",6) 
	s optypedr=$p(parstr,"^",7) //就诊类型
    s doctordr=$p(parstr,"^",8) //医生
    s druglevelstr=$p(parstr,"^",9) //抗菌药级别 
    s presctype=$p(parstr,"^",11) //处方类型 
    s billtypedr=$p(parstr,"^",12) //病人费别
    s phaloc=$p(parstr,"^",13) //药房名称
    s poisonstr=$p(parstr,"^",14) //管制分类 
    s phacatstr=$p(parstr,"^",15) //药学分类 
    s phacatdr=$p(phacatstr,"@",2)
    s prescamt=$p(parstr,"^",16) //处方金额大于
    s basicdrug=$p(parstr,"^",17) //基本药物 
    s patagenum=$p(parstr,"^",18) //年龄大于
    s sapceqty=+$p(parstr,"^",19) //间隔数
    
	i findflag=1 s indexcode="PAADM_AdmDate"  //门诊
	i findflag=2 s indexcode="DischDate"  //住院
	s pid=##class(web.DHCSTCNTSMAIN).GetPHCNTSPID()
	s h=0
	f date=stdate:1:enddate d
	.s phl=""
	.f  s phl=$o(^DHCPHDISPi("FYDATE",date,phl)) q:(phl="")  d
	..s phd=""
	..f  s phd=$o(^DHCPHDISPi("FYDATE",date,phl,phd)) q:(phd="")  d
	...s prescno=$p(^DHCPHDISP(phd,2),"^",1)	//处方号
    ...q:prescno=""
    ...s ord=$o(^OEORD(0,"PrescNo",prescno,""),-1)
    ...q:ord=""
    ...s adm=$p(^OEORD(ord),"^",1)
	...s admtype=$p(^PAADM(adm),"^",2)
	...q:(admtype="I")&(findflag=1) 
	...q:(admtype'="I")&(findflag=2)
	...q:(admtype'="O")&(optypedr=1)
	...q:(admtype'="E")&(optypedr=2)
	...s papmi=$p(^PAADM(adm),"^",1)
	...q:(##class(web.DHCSTCNTSCOMMON).GetAgeYear(papmi)<patagenum)&(patagenum'="")
    ...q:..ChkPrescDisp(prescno)'="1"
    ...s itm=$o(^OEORD(0,"PrescNo",prescno,ord,""))
    ...q:itm=""
    ...s orditemrowid=ord_"||"_itm
    ...s admbilltypedr=$p($g(^OEORD(ord,"I",itm,11)),"^",18)
    ...q:(admbilltypedr'=billtypedr)&(billtypedr'="")  //过滤病人费别 MYQ 20160423
    ...q:..ChkPrescData(parstr,prescno,LogonLocId)=0
    ...s h=h+1
    ...s data=prescno_"^"_adm_"^"_orditemrowid
    ...s ^TMP("dhcpha","DHCSTCNTSMAIN","GetPrescData",pid,"Itm",h)=data
    ...
   
    
    q:h=0 0
    
    ///获取随机数
    s maxrow=h
    i cent'=0 s rnum=(maxrow*cent)/100
    s rnum=$p(rnum,".")
    
    i rnum'<(h*0.8) q -100 	// add by myq 20170207 在抽取的时候也判断随机数所占总数的比例
    
    s randflag=0
	f x=maxrow:-1:1 q:randflag=rnum   d
	.i sapceqty'=0 s randflag=rnum
	.q:sapceqty'=0
	.i rnum'<h d
	..s rnum=h
	..s randnum=x
	.e  d
	..s randnum=$R(maxrow)
	.i maxrow=1 s randnum=1
	.//判断是否符合条件
	.s forflag=1
	.i randnum=0 d
	..s forflag=0
	.e  d
	..i $D(^TMP("dhcpha","DHCSTCNTSMAIN","GetPrescData",pid,"RandNum",randnum)) d
	...s forflag=0 
	.//
	.i forflag=0 d
	..f y=1:1:100000 q:forflag'=0  d
	...s randnum=$R(maxrow)
	...q:randnum=0
	...q:$D(^TMP("dhcpha","DHCSTCNTSMAIN","GetPrescData",pid,"RandNum",randnum))
	...s forflag=1
	.
	.s ^TMP("dhcpha","DHCSTCNTSMAIN","GetPrescData",pid,"RandNum",randnum)=""
	.s randflag=randflag+1
	.
	
	
	//按间隔数产生随机数
	i sapceqty'=0 d
    .i (maxrow\sapceqty)'<rnum d
	..f x=1:1:rnum d
	...s forflag=0
	...s startqty=sapceqty*(x-1)+1
	...s endqty=sapceqty*x
	...i x=rnum s endqty=maxrow //最后一次全用上数
	...s currqty=endqty-startqty+1 //区间数
	...s currqty=currqty+1 //随机数前先加1
	...s randnum=$r(currqty)
	...i randnum=0 d 
	....f y=1:1:100000 q:forflag'=0  d
	.....s randnum=$r(currqty)
	.....q:randnum=0
	.....s forflag=1
	...i randnum'=0 d
	....s randnum=randnum+(startqty-1)
	....s ^TMP("dhcpha","DHCSTCNTSMAIN","GetPrescData",pid,"RandNum",randnum)=""
	....
	.

	
	
	///按随机数抽取数据
	s cnt=0
    s h=""
    f  s h=$o(^TMP("dhcpha","DHCSTCNTSMAIN","GetPrescData",pid,"RandNum",h)) q:h=""  d
    .s data=^TMP("dhcpha","DHCSTCNTSMAIN","GetPrescData",pid,"Itm",h)
    .s prescno=$p(data,"^",1)
    .s orditem=$p(data,"^",3)
    .s adm=$p(data,"^",2)
    .s cnt=cnt+1
    .s ^TMP("dhcpha","DHCSTCNTSMAIN","GetPrescData","ForSaveData",pid,h)=prescno_"^"_orditem_"^"_adm
    .
    
    k ^TMP("dhcpha","DHCSTCNTSMAIN","GetPrescData",pid)
    
	q cnt_"^"_pid
}

/// 保存点评数据
/// 1106,1/8/2017^8/8/2017^^^5^^^^^P^^^^^^^0^^^^^,306
/// w ##class(web.DHCSTCNTSMAIN).SaveCommentData(1106,"1/8/2017^8/8/2017^^^5^^^^^P^^^^^^^0^^^^^",306)
ClassMethod SaveCommentData(User, ParStr, LogonLocId) As %String
{
	//s ^tmyq("SaveCommentData")=User_","_ParStr_","_LogonLocId
	s ret=..GetPrescData(ParStr,LogonLocId)
	s cnt=$p(ret,"^",1)
	s pid=$p(ret,"^",2)
	q:cnt=-100 -100_"^"_"随机数超过当前可抽取处方总数的80%，建议调整随机数!"
	q:cnt=0 -99_"^"_"没有抽取到符合要求的处方,请更换规则后再试!"
	s Note=""
    
    s Note="日期范围:"
    s StartDate=$p(ParStr,"^",1)
    s EndDate=$p(ParStr,"^",2)
    s StartDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(StartDate)
    s EndDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(EndDate)
    s Note=Note_StartDate_"至"_EndDate
    s doclocdr=$p(ParStr,"^",3)
    s inci=$p(ParStr,"^",4)
    s rnum=$p(ParStr,"^",5)
    s cent=$p(ParStr,"^",6)
    s optypedr=$p(ParStr,"^",7)
    s doctordr=$p(ParStr,"^",8)
    s ctrlstr=$p(ParStr,"^",9)
    s Prefix=$p(ParStr,"^",10)
    s LogonHospDr=$p(^CTLOC(LogonLocId),"^",22)
    s optypedesc="全部"
    i optypedr=1 s optypedesc="门诊"
    i optypedr=2 s optypedesc="急诊"
    s Note=Note_","_"类型: "_optypedesc
    i rnum'="" d
    .s Note=Note_","_"随机数: "_rnum
    i cent'="" d
    .s Note=Note_","_"随机比: "_cent
    i inci'="" d
    .s Note=Note_","_"药品名称: "_$p(^INCI(inci,1),"^",2)
    i doclocdr'="" d
    .s Note=Note_","_"医生科室: "
    .s LocSum=$l(doclocdr,",")
    .f i=1:1:LocSum d
    ..s LocDr=$p(doclocdr,",",i)
    ..s docloc=$p(^CTLOC(LocDr),"^",2)
    ..i $f(docloc,"-") s docloc=$p(docloc,"-",2)
    ..i i'="1" s docloc="、"_docloc
    ..s Note=Note_docloc
    i doctordr'="" d
    .s doc=$p(^SSU("SSUSR",doctordr),"^",2)
    .s Note=Note_","_"医生: "_doc
    
    s waycode=$p(ParStr,"^",10)		//点评方式代码
    s wayid=$o(^DHCPCWAY(0,"Code",waycode,""),-1)	//获取点评方式代码
    s resaveflag=""
    s:wayid'="" resaveflag=$p(^DHCPCWAY(wayid),"^",5)	//重复抽取标记
	tstart
	s main=..SaveCommentNo(User,Note,Prefix,LogonHospDr,"F")
	i +main'>0 d exitsave
	q:+main'>0 -1_"^"_"保存主表失败"
	s itm=..SaveCommentItm(pid,main,resaveflag)
	i +itm'=0 d exitsave
	q:+itm=-10 -2_"^"_"有部分医嘱不能重复生成点评单,请重新查询后再试!"
	q:+itm'=0 -3_"^"_"保存子表失败"
	tcommit
	s commentno=$p(^DHCPHCNTS(main),"^",1)
	
	q 0_"^"_commentno
exitsave
    tro
    k ^TMP("dhcpha","DHCSTCNTSMAIN","GetPrescData","ForSaveData",pid)
    q
}

/// 生成点评单号
ClassMethod SaveCommentNo(User, Note, Prefix, LogonHospDr, Type = "") As %String
{
	i Type="" s Type="F"
	s waydr=##class(web.DHCSTCNTSADDWAY).GetWayDrByCode(Prefix)
	k PLIST
	s PLIST(2)=..GetMaxCommentNo(Prefix)
	s PLIST(3)=+$h
	s PLIST(4)=$p($h,",",2)
	s PLIST(5)=Note
	s PLIST(6)=Type
	s PLIST(7)=User
	s PLIST(8)=waydr
	s PLIST(9)=LogonHospDr
	&sql(INSERT INTO DHC_PHCOMMENTS VALUES :PLIST())
	q:SQLCODE'=0 -1
 	q +$g(%ROWID)
}

/// 检查药品项目  0 -不符  1 符合
ClassMethod ChkItmByPrescNo(prescno, inci, poisonstr) As %String
{
	q:(inci="")&(poisonstr="") 1
	s ret=0
	s ord=""
	f  s ord=$o(^OEORD(0,"PrescNo",prescno,ord))  q:(ord="")||(ret=1)  d
	.s itm=""
    .f  s itm=$o(^OEORD(0,"PrescNo",prescno,ord,itm)) q:(itm="")||(ret=1)  d
    ..s arcitm=$p(^OEORD(ord,"I",itm,1),"^",2)
    ..s tmpinci=$o(^INCI(0,"ARCIM_DR",$p(arcitm,"||",1),""))
    ..i inci'="" d
	...i tmpinci=inci s ret=1
	..i poisonstr'="" d
	...s chkpoison=..ChkPoison(tmpinci,poisonstr)
	...i chkpoison=1 s ret=1	
	q ret
}

/// 获取医生列表
/// w ##class(web.DHCSTCNTSMAIN).GetDoctorDs()
ClassMethod GetDoctorDs(doclocstr = "") As %String
{
	s pid=##class(web.DHCSTCNTSMAIN).GetPHCNTSPID()
	s docloccnt=$l(doclocstr,",")
	f x=1:1:docloccnt d
	.s doclocdr=$p(doclocstr,",",x) 
	.q:doclocdr=""
	.s ^TMP("dhcpha","DHCSTCNTSMAIN","GetDoctorDs","doclocdr",pid,doclocdr)=""
	s h=0
	s ctpt=""
	f  s ctpt=$o(^CT("CPT",ctpt)) q:ctpt=""  d
	.s active=$p(^CT("CPT",ctpt),"^",3)
	.q:active'="Y"
	.s type=$p(^CT("CPT",ctpt),"^",4)
	.q:type'="DOCTOR"
	.s ctpcp=""
	.f  s ctpcp=$o(^CTPCP(0,"CareProvType",ctpt,ctpcp)) q:ctpcp=""  d 
	..s ssuser=$o(^SSU("SSUSR",0,"CTPCP",ctpcp,""))
	..q:ssuser=""
	..s activestate=$p(^SSU("SSUSR",ssuser),"^",19)
	..q:activestate'="Y"
	..s doceddate=$p(^SSU("SSUSR",ssuser),"^",97)
	..q:(doceddate'="")&&(doceddate<$p($h,",",1))
	..s chkflag=0
	..s reslocdr=""
	..f  s reslocdr=$o(^RB("RES",0,"CTPCP",ctpcp,reslocdr)) q:reslocdr=""  d
	...q:'$d(^TMP("dhcpha","DHCSTCNTSMAIN","GetDoctorDs","doclocdr",pid,reslocdr))
	...s chkflag=1
	..q:(chkflag=0)&($d(^TMP("dhcpha","DHCSTCNTSMAIN","GetDoctorDs","doclocdr",pid))) //不属于该科室
	..s docname=$p(^SSU("SSUSR",ssuser),"^",2)
	..i $f(docname,$c(13)) s docname=$p(docname,$c(13),1)
	..s h=h+1
    ..s data=docname_"^"_ssuser
    ..s ^TMP("dhcpha","DHCSTCNTSMAIN","GetDoctorDs",pid,h)=data
    q:h=0 ##class(web.DHCSTEXTCOMMON).GetNoJson()
    s maxrow=h
    
    s count=0
    s h=""
    f  s h=$o(^TMP("dhcpha","DHCSTCNTSMAIN","GetDoctorDs",pid,h)) q:h=""  d
    .s data=^TMP("dhcpha","DHCSTCNTSMAIN","GetDoctorDs",pid,h)
    .s docname=$p(data,"^",1)
    .s doctordr=$p(data,"^",2)
    .
    .s docname=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("docname",docname)
	.s doctordr=##class(web.DHCSTEXTCOMMON).GetJsonLastCell("doctordr",doctordr)
	.
	.s tmpstr=docname_doctordr
    .s startString=##class(web.DHCSTEXTCOMMON).GetJsonStartString(maxrow)
    .s firstrow=##class(web.DHCSTEXTCOMMON).GetJsonFirstRow(tmpstr)
    .s lastrow=##class(web.DHCSTEXTCOMMON).GetJsonLastRow(tmpstr)
	.s count=count+1
	.i count=1 w startString
    .i count<maxrow w firstrow
    .i count=maxrow w lastrow
	.
	k ^TMP("dhcpha","DHCSTCNTSMAIN","GetDoctorDs",pid)
	k ^TMP("dhcpha","DHCSTCNTSMAIN","GetDoctorDs","doclocdr",pid)
	q ""
}

/// 获取一组随机数序列，放在global中，
/// Input:pid - 进程号, formaxnum - 循环最大次数 , forendnum - 抽出随机数的个数  , maxnum -最大随机数
/// Output:进程号
ClassMethod GetRandNumList(pid, maxnum, formaxnum, forendnum) As %String
{
	k ^TMP("dhcpha","DHCSTCNTSMAIN","GetRandNum",pid)
	s exit=0
	f x=maxnum:-1:1 q:exit=1  d
	.s forexit=0
	.s randnum=$R(maxnum)+1
	.i maxnum'>forendnum s randnum=x
	.i $D(^TMP("dhcpha","DHCSTCNTSMAIN","GetRandNum",pid,"RandNum",randnum)) s randnum=0
	.i randnum=0 d
	..f y=1:1:formaxnum q:forexit=1  d
	...s randnum=$R(maxnum)+1
	...q:randnum=0
	...q:$D(^TMP("dhcpha","DHCSTCNTSMAIN","GetRandNum",pid,"RandNum",randnum))
	...s forexit=1
	.
	.s randindex=+$o(^TMP("dhcpha","DHCSTCNTSMAIN","GetRandNum",pid,"RandList",""),-1)+1
	.s ^TMP("dhcpha","DHCSTCNTSMAIN","GetRandNum",pid,"RandList",randindex,randnum)=""
	.s ^TMP("dhcpha","DHCSTCNTSMAIN","GetRandNum",pid,"RandNum",randnum)=""
	.i randindex=forendnum d
	..s exit=1
	.
	
	k ^TMP("dhcpha","DHCSTCNTSMAIN","GetRandNum",pid,"RandList")
    q exit
}

/// 保存抗菌药点评单
/// 563,18/07/2016^2/08/2016^5^2^^K,97
/// w ##class(web.DHCSTCNTSMAIN).SaveKCommentData(563,"18/07/2016^2/08/2016^5^2^^K",97)
ClassMethod SaveKCommentData(User, ParStr, logonloc) As %String
{
	//s ^tmyq("SaveKCommentData")=User_","_ParStr_","_logonloc
	s stdate=$p(ParStr,"^",1)
	s:stdate'="" stdate=##class(websys.Conversions).DateHtmlToLogical(stdate)
	s enddate=$p(ParStr,"^",2)
	s:enddate'="" enddate=##class(websys.Conversions).DateHtmlToLogical(enddate)
    s prefix=$p(ParStr,"^",6)
	s ret=##class(web.DHCSTCNTSTASK).SaveData(stdate,enddate,prefix,User,ParStr,logonloc)
	q ret
}

/// 检查排除科室
ClassMethod LimitLoc(limitstr, docdr) As %String
{
	 s ret=0
	 s cnt=$l(limitstr,",")
	 f i=1:1:cnt q:ret=1  d
	 .s limitdoc=$p(limitstr,",",i)
	 .i limitdoc=docdr d
	 ..s ret=1
	 .
	 q ret
}

/// 获到病人诊断信息
ClassMethod GetMRDiagnosDesc(adm) As %String
{
	s pid=##class(web.DHCSTCNTSMAIN).GetPHCNTSPID()
	s h=0
	s str=##class(web.DHCSTKUTIL).GetMRDiagnosDesc(adm,"^")
	s cnt=$l(str,"^")
	f i=1:1:cnt d
	.s h=h+1
	.s diag=$p(str,"^",i)
	.s data=diag
	.s ^TMP("dhcpha","DHCSTCNTSMAIN","GetMRDiagnosDesc",pid,h)=data
    q:h=0 ##class(web.DHCSTEXTCOMMON).GetNoJson()
    s maxrow=h
    s count=0
    s h=""
    f  s h=$o(^TMP("dhcpha","DHCSTCNTSMAIN","GetMRDiagnosDesc",pid,h)) q:h=""  d
    .s data=^TMP("dhcpha","DHCSTCNTSMAIN","GetMRDiagnosDesc",pid,h)
    .s diag=$p(data,"^",1)
    .s diag=##class(web.DHCSTEXTCOMMON).GetJsonLastCell("diag",diag)
	.
	.s tmpstr=diag
    .s startString=##class(web.DHCSTEXTCOMMON).GetJsonStartString(maxrow)
    .s firstrow=##class(web.DHCSTEXTCOMMON).GetJsonFirstRow(tmpstr)
    .s lastrow=##class(web.DHCSTEXTCOMMON).GetJsonLastRow(tmpstr)
	.s count=count+1
	.i count=1 w startString
    .i count<maxrow w firstrow
    .i count=maxrow w lastrow
	.
	k ^TMP("dhcpha","DHCSTCNTSMAIN","GetMRDiagnosDesc",pid)
	q ""
	.
}

/// 保存成人专项点评单
ClassMethod SaveACommentData(User, ParStr, logonloc) As %String
{
 
	s ret=##class(web.DHCSTCNTSTASK).SaveAdultData(User,ParStr,logonloc)
	q ret
}

/// 统计处方数
/// w ##class(web.DHCSTCNTSMAIN).GetPrescDataNum("1/08/2016^10/08/2016^^^^^^^^P^^^^^^^0^^^^^","102")
ClassMethod GetPrescDataNum(parstr, LogonLocId) As %String
{
	//s ^tmyq("GetPrescDataNum")=parstr_","_LogonLocId
	s findflag=1
	s stdate=$p(parstr,"^",1)
	s:stdate'="" stdate=##class(websys.Conversions).DateHtmlToLogical(stdate)
	s enddate=$p(parstr,"^",2)
	s:enddate'="" enddate=##class(websys.Conversions).DateHtmlToLogical(enddate)
	s optypedr=$p(parstr,"^",7) //就诊类型
    s billtypedr=$p(parstr,"^",12) //病人费别
    s patagenum=$p(parstr,"^",18) //病人年龄大于
    s patagelt=$p(parstr,"^",20) //病人年龄小于
    
	
	i findflag=1 s indexcode="PAADM_AdmDate"  //门诊
	i findflag=2 s indexcode="DischDate"  //住院
	s pid=##class(web.DHCSTCNTSMAIN).GetPHCNTSPID()
	s starttime=$p($h,",",2)
	s h=0
	s timeoutflag=0   //超时标志
	f date=stdate:1:enddate q:timeoutflag=1  d 
	.s phl=""
	.f  s phl=$o(^DHCPHDISPi("FYDATE",date,phl)) q:(phl="")||(timeoutflag=1)  d
	..s phd=""
	..f  s phd=$o(^DHCPHDISPi("FYDATE",date,phl,phd)) q:(phd="")||(timeoutflag=1)  d
	...s currtime=$p($h,",",2)
    ...i currtime-starttime>45 s timeoutflag=1
    ...s prescno=$p(^DHCPHDISP(phd,2),"^",1)	//处方号
    ...q:prescno=""
    ...s ord=$o(^OEORD(0,"PrescNo",prescno,""),-1)
    ...q:ord=""
    ...s adm=$p(^OEORD(ord),"^",1)	//就诊id
	...s admtype=$p(^PAADM(adm),"^",2)
	...q:(admtype="I")&(findflag=1) 
	...q:(admtype'="I")&(findflag=2)
	...q:(admtype'="O")&(optypedr=1)
	...q:(admtype'="E")&(optypedr=2)
	...s papmi=$p(^PAADM(adm),"^",1)
	...q:(##class(web.DHCSTCNTSCOMMON).GetAgeYear(papmi)<patagenum)&(patagenum'="")
	...q:(##class(web.DHCSTCNTSCOMMON).GetAgeYear(papmi)>patagelt)&(patagelt'="")
    ...q:..ChkPrescDisp(prescno)'="1"
    ...s itm=$o(^OEORD(0,"PrescNo",prescno,ord,""))
    ...q:itm=""
    ...s admbilltypedr=$p($g(^OEORD(ord,"I",itm,11)),"^",18)
    ...q:(admbilltypedr'=billtypedr)&(billtypedr'="")  //过滤病人费别 MYQ 20160423
    ...q:..ChkPrescData(parstr,prescno,LogonLocId)=0
    ...s h=h+1
    q:timeoutflag'=0 -99  //超时
    q h
}

/// 检查处方各类信息是否符合抽查要求
/// Return:1-符合 0不符
ClassMethod ChkPrescData(parstr, prescno, LogonLocId) As %String
{
	s doclocstrdr=$p(parstr,"^",3) //医生科室
	s drugID=$p(parstr,"^",4)
	s rnum=+$p(parstr,"^",5)
	s rnum=$p(rnum,".")
	s cent=+$p(parstr,"^",6) 
	s optypedr=$p(parstr,"^",7) //就诊类型
    s doctordr=$p(parstr,"^",8) //医生
    s druglevelstr=$p(parstr,"^",9) //抗菌药级别 (包含)
    s presctype=$p(parstr,"^",11) //处方类型 (包含)
    s phaloc=$p(parstr,"^",13) //药房名称
    s poisonstr=$p(parstr,"^",14) //管制分类 (包含)
    //s phacatstr=$p(parstr,"^",15) //药学分类 (包含) 修改为新药学分类
    //s phacatdr=$p(phacatstr,"@",2)
    s PhcCatAll=$p(parstr,"^",15) 	//新药学分类
    s prescamt=$p(parstr,"^",16) //处方金额大于
    s basicdrug=$p(parstr,"^",17) //基本药物 (包含)
    s phcformdr=$p(parstr,"^",21)  //剂型
    s phcdu=$p(parstr,"^",22)  //疗程 
    s waycode=$p(parstr,"^",10)		//点评方式代码
    s wayid=$o(^DHCPCWAY(0,"Code",waycode,""),-1)	//获取点评方式代码
    s resaveflag=""
    s:wayid'="" resaveflag=$p(^DHCPCWAY(wayid),"^",5)	//重复抽取标记
    s LogonHospDr=$p(^CTLOC(LogonLocId),"^",22) ;取登陆科室所在院区
    s HospID=LogonHospDr
    s totalamt=0
    s exitflag=0
	s ret=0
	s phcform=""
	s ord=""
	f  s ord=$o(^OEORD(0,"PrescNo",prescno,ord))  q:(ord="")||(exitflag=1)  d
	.s itm=""
    .f  s itm=$o(^OEORD(0,"PrescNo",prescno,ord,itm)) q:(itm="")||(exitflag=1)  d
 	..s orditem=ord_"||"_itm
	..i ($D(^DHCPHCNTS(0,"OrdItem",orditem))&&(resaveflag'="Y")) s exitflag=1 
	..q:($D(^DHCPHCNTS(0,"OrdItem",orditem))&&(resaveflag'="Y")) //已生成过点评单
	..//q:..GetOrdItmStatus(orditem)=0 //停止
	..s statdr=$p(^OEORD(ord,"I",itm,1),"^",13)
	..s oeflag=$p(^OEC("OSTAT",statdr),"^",1) 
	..s dsp=$o(^DHCOEDISQTY(0,"OEORI",orditem,""))
	..q:dsp=""
	..s status=$p(^DHCOEDISQTY(dsp),"^",7)
	..q:(oeflag'="V")&(oeflag'="E")&(status'="C")
	..s orddeptdr=$p(^OEORD(ord,"I",itm,1),"^",3) //医生科室
	..s orddepthospdr=$p(^CTLOC(orddeptdr),"^",22)
	..q:orddepthospdr'=LogonHospDr ;过滤非登陆科室院区的医嘱 add by myq 20140826
	..q:($$chkdocloc(doclocstrdr)=0)&(doclocstrdr'="")
	..i (HospID="")&(orddeptdr'="") s HospID=$p(^CTLOC(orddeptdr),"^",22)
	..s arcimid=$p(^OEORD(ord,"I",itm,1),"^",2)  ;医嘱 ARC_ItmMast ARCIM_RowId
	..s itmmastid=$p(arcimid,"||",1)
	..s itmmastver=$p(arcimid,"||",2)
	..s tmpinci=$o(^INCI(0,"ARCIM_DR",$p(arcimid,"||",1),"") ) 
	..q:tmpinci=""  //医嘱名称
	..s puomdr=$p(^ARCIM(itmmastid,itmmastver,8),"^",14)
	..s dspdate=+$h 
	..s status=$p(^DHCOEDISQTY(dsp),"^",7)
	..i status="C" s dspdate=$p(^DHCOEDISQTY(dsp),"^",8)
	..//s price=##class(web.DHCSTCOMMONSRV).GetPriceElse(+tmpinci,dspdate,puomdr,"")
	..s exStr="^"_dsp
	..s price=##class(web.DHCSTPRICE).GetSp(+tmpinci,dspdate,puomdr,HospID,"",exStr)	//zhouyg 20150113
    ..s qty=$p(^DHCOEDISQTY(dsp),"^",2)
    ..s retQty=..GetOeoriRetQty(orditem)
    ..q:retQty>=qty
    ..s qty=..getPackQty(tmpinci,qty,puomdr)
	..s amt=$fn(price*qty,"",2)
	..s totalamt=totalamt+amt //处方金额
	..q:(tmpinci'=drugID)&(drugID'="")
	..s phcformdesc=##class(web.DHCSTCOMMONSRV).GetForm(tmpinci)  ;剂型描述
	..s:phcformdr'="" phcform=$p(^PHCF(phcformdr),"^",2)
	..q:(phcformdesc'=phcform)&(phcform'="")
	..s dur=+$p(^OEORD(ord,"I",itm,2),"^",6)  ;用药疗程ID
	..s durfac=$p(^PHCDU(dur),"^",2)
	..s tmpdurfac=""
	..i phcdu'="" s tmpdurfac=$p(^PHCDU(phcdu),"^",2)
	..q:(durfac<tmpdurfac)&(tmpdurfac'="")  ;将小于该疗程的都过滤掉
	..s itmcatdr=$p(^ARCIM(itmmastid,itmmastver,1),"^",10)
	..s ordcatdr=$p(^ARC("IC",itmcatdr),"^",8)
	..q:($$chkptype(presctype)=0)&(presctype'="")  //处方类型
	..s doctocid=$p($g(^OEORD(ord,"I",itm,7)),"^",1)
	..q:(doctocid'=doctordr)&(doctordr'="")
	..s drugpoisonstr=##class(web.DHCSTCOMMONSRV).getPoisonByInci(tmpinci)
	..s drugpoisondr=$p(drugpoisonstr,"^",1)
	..q:($$chklevel(druglevelstr)=0)&(druglevelstr'="")  //抗菌药级别
	..q:(drugpoisondr'=poisonstr)&(poisonstr'="") //管制分类 
	..s reclocdr=$p(^OEORD(ord,"I",itm,3),"^",6)
	..q:(phaloc'=reclocdr)&(phaloc'="") //药房
	..//s phccat=##class(web.DHCSTCNTSCOMMON).PhaCatByArcim(arcimid)
	..//s phcsubcat=##class(web.DHCSTCNTSCOMMON).PhaSubCatByArcim(arcimid)
	..//s phcmincat=##class(web.DHCSTCNTSCOMMON).PhaMinorSubCatByArcim(arcimid)
	..//q:(phacatdr'=phccat)&(phacatdr'=phcsubcat)&(phacatdr'=phcmincat)&(phacatdr'="")
	..s PhaCatAllstr=##class(web.DHCST.Common.DrugInfoCommon).GetPhaCatAll(tmpinci)
	..s PhaCatAlls=$p(PhaCatAllstr,"^",1)
	..s retflag=##class(web.DHCST.Common.DrugInfoCommon).CheckNewCatId(PhcCatAll,PhaCatAlls)
	..q:(PhcCatAll'="")&(retflag=0) // 多级药学分类过滤
	..s basflag=""
	..s infor=$o(^DHCITMINFO(0,"INCI",tmpinci,""))
	..i infor'="" s basflag=$p(^DHCITMINFO(infor),"^",4)
	..q:(basflag'="Y")&(basicdrug=1) //基本药物
	..s ret=1

	q:(totalamt<prescamt)&(prescamt'="") 0	
	
	q ret
    
 //检查抗菌药级别   
chklevel(druglevelstr)
  s chklevel=0
  s levelcnt=$l(druglevelstr,",")
  f x=1:1:levelcnt d
  .s level=$p(druglevelstr,",",x)
  .i level=drugpoisondr d
  ..s chklevel=1 
  q chklevel
  
  //检查医生科室
chkdocloc(doclocstrdr)
  s chkdocloc=0
  s docloccnt=$l(doclocstrdr,",")
  f x=1:1:docloccnt d
  .s tdoclocdr=$p(doclocstrdr,",",x)
  .i tdoclocdr=orddeptdr d
  ..s chkdocloc=1 
  q chkdocloc
  
  
 //检查处方类型
chkptype(presctype)
  s chkptype=0
  s ptypecnt=$l(presctype,",")
  f x=1:1:ptypecnt d
  .s ptype=$p(presctype,",",x)
  .i ordcatdr=ptype d
  ..s chkptype=1 
  q chkptype
}

/// 统计抗菌药处方数
/// w ##class(web.DHCSTCNTSMAIN).GetKPrescDataNum("2018-04-26^2018-04-26^50^2^^K")
ClassMethod GetKPrescDataNum(ParStr) As %String
{
	s ^tmyq("GetKPrescDataNum")=ParStr
	s stdate=$p(ParStr,"^",1)
	s:stdate'="" stdate=##class(websys.Conversions).DateHtmlToLogical(stdate)
	s enddate=$p(ParStr,"^",2)
	s:enddate'="" enddate=##class(websys.Conversions).DateHtmlToLogical(enddate)
	s doccent=$p(ParStr,"^",3)
	s prescnum=$p(ParStr,"^",4)
    s posionstr=$p(ParStr,"^",5)
    s prefix=$p(ParStr,"^",6)	
    s wayid=$o(^DHCPCWAY(0,"Code",prefix,""),-1)	//获取点评方式代码
    s resaveflag=""
    s:wayid'="" resaveflag=$p(^DHCPCWAY(wayid),"^",5)	//重复抽取标记
	s formaxnum=100000
	s doccnt=0 //医生数
	s indexcode="PAADM_AdmDate"  //门诊
	s pid=##class(web.DHCSTCNTSMAIN).GetPHCNTSPID()
    s starttime=$p($h,",",2)
    s timeoutflag=0   //超时标志
	s h=0 //本次查询记录数
	f date=stdate:1:enddate q:timeoutflag=1  d
	.s phl=""
	.f  s phl=$o(^DHCPHDISPi("FYDATE",date,phl)) q:(phl="")||(timeoutflag=1)  d
	..s phd=""
	..f  s phd=$o(^DHCPHDISPi("FYDATE",date,phl,phd)) q:(phd="")||(timeoutflag=1)  d
	...s currtime=$p($h,",",2)
    ...i currtime-starttime>45 s timeoutflag=1
    ...s prescno=$p(^DHCPHDISP(phd,2),"^",1)	//处方号
    ...q:prescno=""
    ...s ord=$o(^OEORD(0,"PrescNo",prescno,""),-1)
    ...q:ord=""
    ...s adm=$p(^OEORD(ord),"^",1)	//就诊id
	...s admtype=$p(^PAADM(adm),"^",2)
	...q:admtype="I"
	...s papmi=$p(^PAADM(adm),"^",1)
    ...q:..ChkPrescDisp(prescno)'="1"
	...s chl=$o(^OEORD(0,"PrescNo",prescno,ord,"")) 
	...q:chl=""
	...s orditem=ord_"||"_chl
	...q:##class(web.DHCSTCNTSMAIN).GetOrdItmStatus(orditem)=0
	...q:($D(^DHCPHCNTS(0,"OrdItem",orditem))&&(resaveflag'="Y")) //已生成过点评单
	...s arcimid=$p(^OEORD(ord,"I",chl,1),"^",2)  ;医嘱 ARC_ItmMast ARCIM_RowId
	...s itmmastid=$p(arcimid,"||",1)
	...s itmmastver=$p(arcimid,"||",2)
	...s inci=$o(^INCI(0,"ARCIM_DR",$p(arcimid,"||",1),"") ) 
	...q:inci=""  //医嘱名称
	...q:##class(web.DHCSTCNTSMAIN).GetAntibioticFlag(orditem)=0
	...q:##class(web.DHCSTCNTSMAIN).ChkItmByPrescNo(prescno,"",posionstr)=0
	...s orddeptdr=$p(^OEORD(ord,"I",chl,1),"^",3)
	...s orddept=$p(^CTLOC(orddeptdr),"^",2)
	...i $f(orddept,"-") s orddept=$p(orddept,"-",2)
	...s docdr=$p($g(^OEORD(ord,"I",chl,7)),"^",1) //医生
	...q:docdr=""
	...;s docflag=##class(web.DHCDocOrderCommon).GetDoctorTypePoisonStr(DoctorID,PAAdmType)
	...//每个医生的处方集合
	...i '$d(^TMP("dhcpha","DHCSTCNTSTASK","GetAntimicrobialData",pid,"Presc",prescno)) d
	....s docmaxnum=+$o(^TMP("dhcpha","DHCSTCNTSTASK","GetAntimicrobialData",pid,"Doc",docdr,""),-1)+1 //医生最大处方数量
	....s ^TMP("dhcpha","DHCSTCNTSTASK","GetAntimicrobialData",pid,"Doc",docdr,docmaxnum)=prescno
	....s ^TMP("dhcpha","DHCSTCNTSTASK","GetAntimicrobialData",pid,"Presc",prescno)=""
	...//医生的集合
	...i '$d(^TMP("dhcpha","DHCSTCNTSTASK","GetAntimicrobialData",pid,"Doctor",docdr)) d
	....s ^TMP("dhcpha","DHCSTCNTSTASK","GetAntimicrobialData",pid,"Doctor",docdr)=""
	....s doccnt=doccnt+1
	...s h=h+1
	q:timeoutflag=1 -99
	q:h=0 0
	//取得医生处方数大于50的集合
	s prescnumtotal=0
	s h=0
	s docdr=""
	f  s docdr=$o(^TMP("dhcpha","DHCSTCNTSTASK","GetAntimicrobialData",pid,"Doctor",docdr)) q:docdr=""  d
	.s docmaxnum=$o(^TMP("dhcpha","DHCSTCNTSTASK","GetAntimicrobialData",pid,"Doc",docdr,""),-1)
	.q:docmaxnum<prescnum
	.;s prescnumtotal=prescnumtotal+docmaxnum
	.s prescnumtotal=prescnumtotal+prescnum
	.s h=h+1		//处方张数满足抽取条件的医生数
	.s ^TMP("dhcpha","DHCSTCNTSTASK","GetAntimicrobialData",pid,"DocItm",h,docdr)=""
	//k ^TMP("dhcpha","DHCSTCNTSTASK","GetAntimicrobialData",pid,"Doctor")
	
	k ^TMP("dhcpha","DHCSTCNTSTASK","GetAntimicrobialData",pid)
	q:h=0 0
	///取医生集合
	s doccnt=$p((doccnt*doccent)/100,".") //随机医生总数
	i doccnt<1 s doccnt=1
	q:h<doccnt 0		//满足抽取处方张数的医生数小于抽取的百分比
	
	s prescmaxnum=doccnt*prescnum 
	//s prescmaxnum=prescnumtotal*doccnt
	q prescmaxnum
}

/// 统计成人处方数
/// w ##class(web.DHCSTCNTSMAIN).GetAdultDataNum("17/07/2016^4/08/2016^^^^1")
ClassMethod GetAdultDataNum(ParStr) As %String
{
	//s ^tmyq("GetAdultDataNum")=ParStr
	s stdate=$p(ParStr,"^",1)
	s:stdate'="" stdate=##class(websys.Conversions).DateHtmlToLogical(stdate)
	s enddate=$p(ParStr,"^",2)
	s:enddate'="" enddate=##class(websys.Conversions).DateHtmlToLogical(enddate)
	s limitlocstr=$p(ParStr,"^",4)
	s prescnum=$p(ParStr,"^",3)
	s posionstr=$p(ParStr,"^",5)
	s optype=$p(ParStr,"^",6)
	s waycode=$p(ParStr,"^",7)		//点评方式代码
    s wayid=$o(^DHCPCWAY(0,"Code",waycode,""),-1)	//获取点评方式代码
    s resaveflag=""
    s:wayid'="" resaveflag=$p(^DHCPCWAY(wayid),"^",5)	//重复抽取标记
	
	s formaxnum=100000
	s indexcode="PAADM_AdmDate"  //门诊
    s h=0 //本次查询记录数
	f date=stdate:1:enddate d
	.s phl=""
	.f  s phl=$o(^DHCPHDISPi("FYDATE",date,phl)) q:(phl="")  d
	..s phd=""
	..f  s phd=$o(^DHCPHDISPi("FYDATE",date,phl,phd)) q:(phd="")  d
    ...s prescno=$p(^DHCPHDISP(phd,2),"^",1)	//处方号
    ...q:prescno=""
    ...s ord=$o(^OEORD(0,"PrescNo",prescno,""),-1)
    ...q:ord=""
    ...s adm=$p(^OEORD(ord),"^",1)	//就诊id
	...s admtype=$p(^PAADM(adm),"^",2)
	...q:(optype="1")&(admtype'="O")
	...q:(optype="2")&(admtype'="E")
	...q:admtype="I"  //只考虑门诊
	...s papmi=$p(^PAADM(adm),"^",1)
	...s patage=##class(web.DHCSTKUTIL).GetAgeNum(papmi)  ;年龄 
	...q:patage<16 
    ...q:..ChkPrescDisp(prescno)'="1"
	...s chl=$o(^OEORD(0,"PrescNo",prescno,ord,"")) 
	...q:chl=""
	...s orditem=ord_"||"_chl
	...q:##class(web.DHCSTCNTSMAIN).GetOrdItmStatus(orditem)=0
	...q:($D(^DHCPHCNTS(0,"OrdItem",orditem))&&(resaveflag'="Y")) //已生成过点评单
	...s arcimid=$p(^OEORD(ord,"I",chl,1),"^",2)  ;医嘱 ARC_ItmMast ARCIM_RowId
	...s itmmastid=$p(arcimid,"||",1)
	...s itmmastver=$p(arcimid,"||",2)
	...s inci=$o(^INCI(0,"ARCIM_DR",$p(arcimid,"||",1),"") ) 
	...q:inci=""  //医嘱名称
	...q:##class(web.DHCSTCNTSMAIN).ChkItmByPrescNo(prescno,"",posionstr)=0
	...s orddeptdr=$p(^OEORD(ord,"I",chl,1),"^",3)
	...s orddept=$p(^CTLOC(orddeptdr),"^",2)
	...i $f(orddept,"-") s orddept=$p(orddept,"-",2)
	...s docdr=$p($g(^OEORD(ord,"I",chl,7)),"^",1) //医生
	...q:docdr=""
	...s limitloc=##class(web.DHCSTCNTSMAIN).LimitLoc(limitlocstr,orddeptdr)
	...q:(limitloc=0)&(limitlocstr'="")
	...s h=h+1
	q h
}

/// 获取抗菌药标志  1 是 , 非1 否
ClassMethod GetAntibioticFlag(orditm, parmorditm = "") As %String
{
	s ret=0
	s ord=$p(orditm,"||",1)
	s chl=$p(orditm,"||",2)
	q:'$d(^OEORD(ord,"I",chl,1)) 0
	s prescno=$p(^OEORD(ord,"I",chl,1),"^",14)
	q:prescno="" 0
	s ord=""
	f  s ord=$o(^OEORD(0,"PrescNo",prescno,ord))  q:(ord="")||(ret=1)  d
	.s chl=""
    .f  s chl=$o(^OEORD(0,"PrescNo",prescno,ord,chl)) q:(chl="")||(ret=1)  d
    ..s tmporditm=ord_"||"_chl
    ..s statdr=$p(^OEORD(ord,"I",chl,1),"^",13)
	..s oeflag=$p(^OEC("OSTAT",statdr),"^",1)
	..s dsp=$o(^DHCOEDISQTY(0,"OEORI",tmporditm,""))
	..q:dsp=""
	..s status=$p(^DHCOEDISQTY(dsp),"^",7) 
	..q:(oeflag'="V")&(oeflag'="E")&(status'="C")
	..q:(parmorditm'="")&(parmorditm'=tmporditm)
	..s arcimid=$p(^OEORD(ord,"I",chl,1),"^",2)
	..s itmmastid=$p(arcimid,"||",1)
    ..s itmmastver=$p(arcimid,"||",2)
    ..s phcform=$p(^ARCIM(itmmastid,itmmastver,1),"^",12)
    ..s phc=$p(phcform,"||",1)
    ..s phcsub=$p(phcform,"||",2)
    ..s antibiotic=$p($G(^PHCD(phc,"DF",phcsub,"DHC")),"^",8)
    ..i antibiotic="Y" s ret=1
    q ret
}

/// 获取处方基本信息
/// w ##class(web.DHCSTCNTSMAIN).GetPrescBasicInfo("O12033100005")
ClassMethod GetPrescBasicInfo(PrescNo) As %String
{
   s patstring=""  //处方信息
   s ord=$o(^OEORD(0,"PrescNo",PrescNo,""))
   q:ord="" ""
   s adm=$p(^OEORD(ord),"^",1)
   s papmi=+$p(^PAADM(adm),"^",1)
   s perno=$p(^PAPER(papmi,"PAT",1),"^",2)
   s pname=$p(^PAPER(papmi,"ALL"),"^",1)
   s ptel=$p(^PAPER(papmi,"PER",1),"^",11)
   s paddress=$p($g(^PAPER(papmi,"PER",4)),"^",18)
   s getage=##class(web.DHCOutPhCommon).GetAge(papmi) 
   s sexdr=$p(^PAPER(papmi,"ALL"),"^",7)
   s sex=$p(^CT("SEX",sexdr),"^",2)
   s company=$p(^PAPER(papmi,"PER",4),"^",18) //工作单位
   s cfRowId=$o(^DHCCARDi("CF",0,"PAPMIDR",papmi,""),-1)
   s cardNo=$p($g(^DHCCARD("CF",cfRowId)),"^",2)
   s admord=$o(^OEORD(0,"PrescNo",PrescNo,""))
   s adm=$p(^OEORD(admord),"^",1)
   s admdate=""
   s admdate=$p(^PAADM(adm),"^",6)
   i admdate'="" s admdate=##class(websys.Conversions).DateLogicalToHtml(admdate)
   s diagnodesc=##class(web.DHCOutPhCommon).GetMRDiagnosDesc(adm,",")
   s patW=##class(web.DHCOutPhCommon).GetPatWeight(adm)
   s patH=##class(web.DHCOutPhCommon).GetPatHeight(adm)
   s deplocdr=$p(^PAADM(adm),"^",4)
   s deplocdesc=$p(^CTLOC(deplocdr),"^",2)
   i deplocdesc["-" s deplocdesc=$p(deplocdesc,"-",2)
   s pyname=""
   //配药信息
   s pyname="",fyname="",pydate="",fydate="",phloc="",phwindesc="",recloc=""
   s phdrow=$o(^DHCPHDISPi("PRESCNO",PrescNo,""),-1)
   i phdrow'="" d
   .s pyname=""
   .s pyuserdr=$p(^DHCPHDISP(phdrow,1),"^",3)
   .i pyuserdr'="" s pyname=$p(^DHCPHPER(pyuserdr),"^",2)
   .s fyname=""
   .s fyuserdr=$p(^DHCPHDISP(phdrow,1),"^",2)
   .i fyuserdr'="" s fyname=$p(^DHCPHPER(fyuserdr),"^",2)
   .;
   .s pydate=$p(^DHCPHDISP(phdrow,1),"^",5)
   .i pydate'="" s pydate=##class(websys.Conversions).DateLogicalToHtml(pydate)
   .s pytime=$p(^DHCPHDISP(phdrow,1),"^",7)
   .i pytime'="" s pytime=##class(websys.Conversions).TimeLogicalToHtml(pytime)
   .s pydate=pydate_" "_pytime
   .; 
   .s fydate=$p(^DHCPHDISP(phdrow),"^",3)
   .i fydate'="" s fydate=##class(websys.Conversions).DateLogicalToHtml(fydate)
   .s fytime=$p(^DHCPHDISP(phdrow),"^",5)
   .i fytime'="" s fytime=##class(websys.Conversions).TimeLogicalToHtml(fytime)
   .s fydate=fydate_" "_fytime
   .;
   .s phl=$p(^DHCPHDISP(phdrow,1),"^",1)
   .s phlocdr=$p(^DHCPHLOC(phl),"^",1)
   .s recloc=$p(^CTLOC(phlocdr),"^",2) 
   .i $F(recloc,"-") s recloc=$p(recloc,"-",2)
   .;
   .s phwindesc=""
   .s phwdr=$p(^DHCPHDISP(phdrow),"^",4)
   .i phwdr'="" d 
   ..i $D(^DHCPHWIN(phwdr)) s phwindesc=$p(^DHCPHWIN(phwdr),"^",1)
   ;
   s presctitle=..GetPrescTitle(PrescNo)
   s sysdate=##class(websys.Conversions).DateLogicalToHtml(+$h)_" "_##class(websys.Conversions).TimeLogicalToHtml($p($h,",",2))
   s retstr=..Getpaque(PrescNo)
   s queinst=$p(retstr,"^",1)
   s quefac=$p(retstr,"^",2) 
   s queqty=$p(retstr,"^",3)
   s quedate=$p(retstr,"^",4)
   s quexdate=$p(retstr,"^",5)
   s quenote=$p(retstr,"^",6)  
   s quecook=$p(retstr,"^",7)
   s docstr=##class(web.DHCOutPhCommon).GetOrdDoc(PrescNo,"")
   s docctloc=$p(docstr,"^",1)
   s doctor=$p(docstr,"^",2)
   s orddate=$p(docstr,"^",3)
   s billtype=""
   s typedr=+$p(^PAPER(papmi,"PER",1),"^",10)
   s:typedr'="" billtype=$p(^CT("SS",typedr),"^",2)
   s amt=..GetPrescAmt(PrescNo)
   s singleprice=..GerPrescSinglePrice(PrescNo)
   ;
   s patstring=perno_"^"_pname_"^"_getage_"^"_sex_"^"_diagnodesc_"^"_patW_"^"_pyname_"^"_fyname_"^"_pydate_"^"_fydate_"^"_sysdate_"^"_recloc_"^"_company_"^"_admdate_"^"_cardNo_"^"_PrescNo_"^"_deplocdesc_"^"_phwindesc_"^"_ptel_"^"_paddress_"^"_quecook_"^"_queqty_"^"_presctitle_"^"_docctloc_"^"_doctor   //25结束
   s patstring=patstring_"^"_queinst_"^"_quefac_"^"_queqty_"^"_quedate_"^"_quexdate_"^"_quenote_"^"_orddate_"^"_billtype_"^"_amt_"^"_patH_"^"_quecook_"^"_singleprice //37结
   q patstring
}

/// 获取草药处方单付价格
ClassMethod GerPrescSinglePrice(prescno As %String) As %String
{
   s SinglePrice=0
   s amt=..GetPrescAmt(prescno)
   s questr=..Getpaque(prescno)
   s facqty=+$p(questr,"^",2)
   i facqty'=0 s SinglePrice=$fn(amt/facqty,"",4)
   q SinglePrice
}

ClassMethod Getpaque(prescno As %String) As %String
{
   ;获得中草药信息 PA_Que1 
    
   q:prescno="" ""
   s queid=""
   s questr=""
   f  s queid=$o(^PAQUE1(0,"PrescNo",prescno,queid)) q:queid=""  d
   .q:'$d(^PAQUE1(queid,"DHC"))
   .s insdr=$p(^PAQUE1(queid,"DHC"),"^",11)
   .s Instruc=""
   .s:insdr'="" Instruc=$p(^PHCIN(insdr),"^",2) ;用法
   .s durdr=$p(^PAQUE1(queid,"DHC"),"^",10)
   .s facotor=1
   .s:durdr'="" facotor=$p(^PHCDU(durdr),"^",2) ;剂数
   .s orderqty=$p(^PAQUE1(queid,"DHC"),"^",13) ;用量
   .s quedate=$p(^PAQUE1(queid,"DHC"),"^",6) ;开始时间
   .s quexdate=quedate+facotor-1
   .i $g(quedate)'="" s quedate=##class(websys.Conversions).DateLogicalToHtml(quedate)
   .i $g(quexdate)'="" s quexdate=##class(websys.Conversions).DateLogicalToHtml(quexdate)
   .s preno=$p(^PAQUE1(queid),"^",14) ;处方号
   .s type=$p(^PAQUE1(queid,"DHC"),"^",15) ;方式
   .s notes=$p(^PAQUE1(queid,"DHC"),"^",21) ;备注
   .
   .s questr=Instruc_"^"_facotor_"^"_orderqty_"^"_$g(quedate)_"^"_$g(quexdate)_"^"_notes_"^"_type
   .
   q $g(questr)
}

/// Desc:把处方分类 
/// Creator:LiangQiang
/// Input:处方号
/// Output:1--普通，2--急诊，3--儿科，4--毒麻、精一，5--精二
ClassMethod GetPrescTitle(presc) As %String
{
	I presc["E" Q "急诊"    
	s prescord="",prescitm="",retval=""
	s prescord=$o(^OEORD(0,"PrescNo",presc,""))
	i prescord="" q ""
	s prescitm=$o(^OEORD(0,"PrescNo",presc,prescord,""))
	s prescitmmast=""
    s prescitmmast=$p(^OEORD(prescord,"I",prescitm,1),"^",2)
    s prescdrgform="",prescdrgmast=""
    s prescdrgform=$p(^ARCIM($p(prescitmmast,"||",1),$p(prescitmmast,"||",2),1),"^",12)
    s prescdrgmast=$p(prescdrgform,"||",1)
    s prescpoisondr=""
    i prescdrgmast'=0 s prescpoisondr=+$p(^PHCD(prescdrgmast,1),"^",4)
    i prescpoisondr'="" s poisondesc=$p(^PHCPO(prescpoisondr),"^",2)
    s prescitmcat="",oeccat="",oecatdesc=""
    s prescitmcat=$p(^ARCIM($p(prescitmmast,"||",1),$p(prescitmmast,"||",2),1),"^",10)
	s oeccat=$p(^ARC("IC",prescitmcat),"^",8)
	s oecatdesc=$p(^OEC("ORCAT",oeccat),"^",2)
    i (poisondesc["毒")||(poisondesc["麻")||( (poisondesc["精")&(poisondesc["一") ) q "毒麻、精一"
    i (poisondesc["精")&(poisondesc["二")  q "精二"
    s adm=$p(^OEORD(prescord),"^",1)
    s papmi=+$p(^PAADM(adm),"^",1)
    s argBirthday=$p(^PAPER(papmi,"ALL"),"^",6)
	i (+argBirthday'=0) d
	.s argAdmDate=$p($h,",",1)
	.s tmpAge="",ageYears=0,ageMonths=0,ageDays=0,age=""
	.s tmpAge=$$CalAge^at182(argBirthday,argAdmDate)
	.i (tmpAge'="")&&($l(tmpAge,"|")'<14) d
	..s ageYears=$p(tmpAge,"|",12)
	..s ageMonths=$p(tmpAge,"|",13)
	..s ageDays=$p(tmpAge,"|",14)
	..i ageYears<16 s childflag="儿科"
	i $g(childflag)'="" q $g(childflag)
	q "普通"
}

/// 获取处方总金额
ClassMethod GetPrescAmt(prescno) As %String
{
	 s HospID=""
	 s ret=0
	 s ord=""
     f  s ord=$o(^OEORD(0,"PrescNo",prescno,ord)) q:ord=""  d
     .s itm=""
     .f  s itm=$o(^OEORD(0,"PrescNo",prescno,ord,itm)) q:itm=""  d
     ..s oeori=ord_"||"_itm
     ..s RecLocID=$p(^OEORD(ord,"I",itm,3),"^",6)
	 ..i (RecLocID'="")&(HospID="") s HospID=$p($g(^CTLOC(RecLocID)),"^",22)
     ..s statdr=$p(^OEORD(ord,"I",itm,1),"^",13)
	 ..s oeflag=$p(^OEC("OSTAT",statdr),"^",1) 
	 ..s dsp=$o(^DHCOEDISQTY(0,"OEORI",oeori,""))
	 ..q:dsp=""
	 ..s status=$p(^DHCOEDISQTY(dsp),"^",7) 
	 ..q:(oeflag'="V")&(oeflag'="E")&(status'="C")
	 ..s arcimid=$p(^OEORD(ord,"I",itm,1),"^",2) 
	 ..s itmmastid=$p(arcimid,"||",1)
	 ..s itmmastver=$p(arcimid,"||",2)
	 ..s inci=$o(^INCI(0,"ARCIM_DR",$p(arcimid,"||",1),"")) q:inci=""
	 ..s puomdr=$p(^ARCIM(itmmastid,itmmastver,8),"^",14)
	 ..s dspdate=+$h
	 ..s dsp=$o(^DHCOEDISQTY(0,"OEORI",oeori,""))
	 ..q:dsp="" 
	 ..s status=$p(^DHCOEDISQTY(dsp),"^",7)
	 ..i status="C" s dspdate=$p(^DHCOEDISQTY(dsp),"^",8)
	 ..//s price=##class(web.DHCSTCOMMONSRV).GetPriceElse(+inci,dspdate,puomdr,"")
	 ..s exStr="^"_dsp
	 ..s price=##class(web.DHCSTPRICE).GetSp(+inci,dspdate,puomdr,HospID,"",exStr)	//zhouyg 20150113
     ..s qty=$p(^DHCOEDISQTY(dsp),"^",2)
     ..s qty=..getPackQty(inci,qty,puomdr)
	 ..s amt=$fn(price*qty,"",2)
	 ..s ret=ret+amt 
	 q ret
}

/// 转换门诊发药数量
ClassMethod getPackQty(inci, qty, puom) As %String
{
	s result=""
	s buom=+$p(^INCI(inci,1),"^",10)  ; basic uom
	s buomdesc=$p(^CT("UOM",buom),"^",2)
	s puomdesc=$p(^CT("UOM",puom),"^",2)
	;
	s confac=##class(web.DHCSTCOMMONSRV).UOMFac(puom,buom)
    i qty#confac=0 d
    .s qty=qty/confac
    .s inciuom=puomdesc
    e  d
    .s inciuom=buomdesc
	q qty_"^"_inciuom
}

/// 转换门诊处方明细
ClassMethod GetOrdDetailInfo(prescno, stpage, limit) As %String
{
	s pid=##class(web.DHCSTCNTSMAIN).GetPHCNTSPID()
	;s stpage=0
	;s limit=50
	;s endpage=stpage+limit  //结束行
	;s stpage=stpage+1 //开始行
	s HospID=""
	s findflag=1
	s h=0
	s ord=""
	f  s ord=$o(^OEORD(0,"PrescNo",prescno,ord))  q:ord=""  d
	.s chl=""
	.f  s chl=$o(^OEORD(0,"PrescNo",prescno,ord,chl)) q:chl=""  d
	..s orditm=ord_"||"_chl
	..s RecLocID=$p(^OEORD(ord,"I",chl,3),"^",6)
	..i (RecLocID'="")&(HospID="") s HospID=$p($g(^CTLOC(RecLocID)),"^",22)
	..s presc=$p(^OEORD(ord,"I",chl,1),"^",14) ;处方号
	..s arcimid=$p(^OEORD(ord,"I",chl,1),"^",2)  ;医嘱 ARC_ItmMast ARCIM_RowId
	..s itmmastid=$p(arcimid,"||",1)
	..s itmmastver=$p(arcimid,"||",2)
	..s inci=$o(^INCI(0,"ARCIM_DR",$p(arcimid,"||",1),"") ) q:inci=""  //医嘱名称
	..s inciDesc=$p(^INCI(inci,1),"^",2) //药品名称
	..s dsp=$o(^DHCOEDISQTY(0,"OEORI",orditm,""))
	..q:dsp=""
    ..s qty=$p(^DHCOEDISQTY(dsp),"^",2)
	..s:findflag=1 puomdr=$p(^ARCIM(itmmastid,itmmastver,8),"^",14)
	..s:findflag=2 puomdr=+$p(^INCI(inci,3),"^",6)
	..s buomdr=+$p(^INCI(inci,1),"^",10)
	..s fac=+##Class(web.DHCSTCOMMONSRV).UOMFac(puomdr,buomdr)
	..s uomdr=buomdr
	..i (qty#fac)=0 d
	...s qty=qty/fac   //数量
	...s uomdr=puomdr 
	..s uomdesc=$p($g(^CT("UOM",uomdr)),"^",2) //单位
	..s dosage=$p(^OEORD(ord,"I",chl,2),"^",1) ;剂量
	..i dosage'="" s dosage=$j(dosage,"",3)
    ..s doseuom=""
	..s dosuomID=$p(^OEORD(ord,"I",chl,2),"^",3)
	..i dosuomID'="" d
	...s doseuom=$p($g(^CT("UOM",dosuomID)),"^",2) ;剂量单位
	..s freq=""
	..s freqdr=+$p($g(^OEORD(ord,"I",chl,2)),"^",4) ;OEORI_PHFreq_DR
    ..i freqdr'=0 s freq=$p($g(^PHCFR(freqdr)),"^",3)  ;频率
    ..s instru=""
    ..s instrudr=+$p(^OEORD(ord,"I",chl,2),"^",7)
    ..s:instrudr'=0 instru=$p(^PHCIN(instrudr),"^",2)        	;用法
    ..s duration=""
    ..s dur=+$p(^OEORD(ord,"I",chl,2),"^",6)
	..s:dur'=0 duration=$p(^PHCDU(dur),"^",1)         	;用药疗程
	..s priorty=""
	..s pri=+$p(^OEORD(ord,"I",chl,1),"^",8)
	..s:pri'=0 priorty=$p(^OECPR(pri),"^",2)   		;医嘱优先级
	..s doctor=##class(web.DHCSTCOMMONSRV).getOrdDoctor(orditm)       ;医生
	..s skintest=##class(web.DHCSTCOMMONSRV).GetSkinTestResult(orditm)  ;皮试
	..s form=##class(web.DHCSTCOMMONSRV).GetForm(inci)  ;剂型
	..i $f(form,$c(13,10)) s form=$tr(form,$c(13,10),"")
	..s spec=##class(web.DHCSTCOMMONSRV).getBarcode(inci) ;规格
	..s manf=##class(web.DHCSTITMDESC).GetManfNameByInci(inci) ;厂家
	..i $f(manf,"-") s manf=$p(manf,"-",2)
	..i $f(manf,$c(13,10)) s manf=$tr(manf,$c(13,10),"")
	..s remark=##class(web.DHCSTCOMMONSRV).GetOrdItmRemark(orditm) ;备注
	..s dsp=""
	..s dsp=$o(^DHCOEDISQTY(0,"OEORI",orditm,dsp)) q:dsp=""
	..//s status=$p(^DHCOEDISQTY(dsp),"^",7)
	..//q:status="R"
    ..//s orddate=$p(^OEORD(ord,"I",chl,3),"^",7)
    ..//s ordtime=$p(^OEORD(ord,"I",chl,3),"^",15)
    ..s orddate=$p(^DHCOEDISQTY(dsp),"^",15)
    ..i orddate'="" s orddate=##class(websys.Conversions).DateLogicalToHtml(orddate)
    ..s ordtime=$p(^DHCOEDISQTY(dsp),"^",16)
    ..i ordtime'="" s ordtime=##class(websys.Conversions).TimeLogicalToHtml(ordtime)
    ..s orddatetime=orddate_" "_ordtime  ;开单日期
    ..s status=$p(^DHCOEDISQTY(dsp),"^",7)
    ..s dspdate=+$h
	..i status="C" s dspdate=$p(^DHCOEDISQTY(dsp),"^",8)
	..//s price=##class(web.DHCSTCOMMONSRV).GetPriceElse(+inci,dspdate,puomdr,"")
	..s exStr="^"_dsp
	..s price=##class(web.DHCSTPRICE).GetSp(+inci,dspdate,puomdr,HospID,"",exStr)	//zhouyg 20150113
	..s amt=$fn(price*qty,"",2)
	..s cyqty=$p(^DHCOEDISQTY(dsp),"^",5)
	..s specinstr=$p(^OEORD(ord,"I",chl,2),"^",8)
    ..s h=h+1
    ..s data=inciDesc_"^"_qty_"^"_uomdesc_"^"_dosage_doseuom_"^"_freq_"^"_spec_"^"_instru_"^"_duration_"^"_form
    ..s data=data_"^"_priorty_"^"_doctor_"^"_orddatetime_"^"_remark_"^"_manf_"^"_price_"^"_amt_"^"_specinstr_"^"_skintest
    ..s ^TMP("dhcpha","DHCSTCNTSMAIN","GetOrdDetailData",pid,h)=data
    q h_"^"_pid
}

ClassMethod GetXYOrdDetail(prescno) As %String
{
	s stpage=0
	s limit=50
	s endpage=stpage+limit  //结束行
	s stpage=stpage+1 //开始行
	s ret=..GetOrdDetailInfo(prescno,stpage,limit)
	s h=$p(ret,"^",1)
	s pid=$p(ret,"^",2)
	q:h=0 ##class(web.DHCSTEXTCOMMON).GetNoJson()
    s maxrow=h
    i endpage>maxrow s endpage=maxrow
    s count=0
    s h=""
    f  s h=$o(^TMP("dhcpha","DHCSTCNTSMAIN","GetOrdDetailData",pid,h)) q:h=""  d
    .s data=^TMP("dhcpha","DHCSTCNTSMAIN","GetOrdDetailData",pid,h)
    .s incidesc=$p(data,"^",1)
    .s spec=$p(data,"^",6)
    .s incidesc=incidesc
    .s qty=$p(data,"^",2)
    .s uomdesc=$p(data,"^",3)
    .s qty=qty_" "_uomdesc
    .s dosage=$p(data,"^",4)
    .s dosage="每次"_dosage
    .s freq=$p(data,"^",5)
    .s instruc=$p(data,"^",7)
    .s dura=$p(data,"^",8)
    .s remark=$p(data,"^",13)
    .
    .s freq=freq_"  "_dosage_"  "_instruc_"  "_dura_"  "_remark
    .s price=$p(data,"^",15)
    .s amt=$p(data,"^",16)
    .s skintest=$p(data,"^",18)
    .s:skintest'="" incidesc=skintest_" "_incidesc
    .
    .s count=count+1
    .q:count<stpage
    .q:count>endpage
    .
    .s incidesc=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("drugname",incidesc)
	.s qty=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("qty",qty)
	.s freq=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("freq",freq)
	.s price=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("price",price)
	.s amt=##class(web.DHCSTEXTCOMMON).GetJsonLastCell("amt",amt)
	.
	.s tmpstr=incidesc_qty_freq_price_amt
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
    
    
    k ^TMP("dhcpha","DHCSTCNTSMAIN","GetOrdDetailData",pid)
    q ""
}

ClassMethod GetCYOrdDetail(prescno) As %String
{
	s stpage=0
	s limit=200
	s endpage=stpage+limit  //结束行
	s stpage=stpage+1 //开始行
	s ret=..GetOrdDetailInfo(prescno,stpage,limit)
	s h=$p(ret,"^",1)
	s pid=$p(ret,"^",2)
	q:h=0 ##class(web.DHCSTEXTCOMMON).GetNoJson()
    s maxrow=h
    i endpage>maxrow s endpage=maxrow
    s count=0
    s h=""
    f  s h=$o(^TMP("dhcpha","DHCSTCNTSMAIN","GetOrdDetailData",pid,h)) q:h=""  d
    .s data=^TMP("dhcpha","DHCSTCNTSMAIN","GetOrdDetailData",pid,h)
    .s incidesc=$p(data,"^",1)
    .s qty=$p(data,"^",4)
    .s remark=$p(data,"^",17)
    .s:remark'="" qty=qty_"("_remark_")"
    .
    .s count=count+1
    .q:count<stpage
    .q:count>endpage
    .
    .
    .i count#4=1 d
    ..s drugname=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("drugname",incidesc)
	..s qty=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("qty",qty)
	..i count=endpage  d
	...s splitone=##class(web.DHCSTEXTCOMMON).GetJsonLastCell("splitone","")
	..e  d
	...s splitone=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("splitone","")
	..s tmpstr=drugname_qty_splitone
	.//
	.i count#4=2 d
    ..s drugnametwo=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("drugnametwo",incidesc)
	..s qtytwo=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("qtytwo",qty)
	..i count=endpage  d
	...s splittwo=##class(web.DHCSTEXTCOMMON).GetJsonLastCell("splittwo","")
	..e  d
	...s splittwo=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("splittwo","")
	..s tmpstr=tmpstr_drugnametwo_qtytwo_splittwo
	.//
	.i count#4=3 d
    ..s drugnamethree=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("drugnamethree",incidesc)
	..s qtythree=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("qtythree",qty)
	..i count=endpage  d
	...s qtythree=##class(web.DHCSTEXTCOMMON).GetJsonLastCell("qtythree",qty)
	..e  d
	...s qtythree=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("qtythree",qty)
	..s tmpstr=tmpstr_drugnamethree_qtythree
	.
    .s startString=##class(web.DHCSTEXTCOMMON).GetJsonStartString(maxrow)
    .s firstrow=##class(web.DHCSTEXTCOMMON).GetJsonFirstRow(tmpstr)
    .s lastrow=##class(web.DHCSTEXTCOMMON).GetJsonLastRow(tmpstr)
	. 
    .i count=stpage w startString
    .i (count#4)=0 w firstrow
    .i count=endpage w lastrow
    .
    
    
    k ^TMP("dhcpha","DHCSTCNTSMAIN","GetOrdDetailData",pid)
    q ""
}

/// 获取处方类型(中草药,成药,西药)
ClassMethod GetPresctypeDs() As %String
{
	
	s pid=##class(web.DHCSTCNTSMAIN).GetPHCNTSPID()
	s h=0
	s orcatr=""
    f  s orcatr=$o(^OEC("ORCAT",orcatr)) q:orcatr=""  d
	.s orcatdesc=$p(^OEC("ORCAT",orcatr),"^",2)
	.q:(orcatdesc'="西药")&(orcatdesc'="中成药")&(orcatdesc'="中草药")
	.s h=h+1
    .s data=orcatdesc_"^"_orcatr
    .s ^TMP("dhcpha","DHCSTCNTSMAIN","GetPresctypeDs",pid,h)=data
    q:h=0 ##class(web.DHCSTEXTCOMMON).GetNoJson()
    s maxrow=h
    
    s count=0
    s h=""
    f  s h=$o(^TMP("dhcpha","DHCSTCNTSMAIN","GetPresctypeDs",pid,h)) q:h=""  d
    .s data=^TMP("dhcpha","DHCSTCNTSMAIN","GetPresctypeDs",pid,h)
    .s PTypeDesc=$p(data,"^",1)
    .s PTypeID=$p(data,"^",2)
    .
    .s PTypeDesc=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("PTypeDesc",PTypeDesc)
	.s PTypeID=##class(web.DHCSTEXTCOMMON).GetJsonLastCell("PTypeID",PTypeID)
	.
	.s tmpstr=PTypeDesc_PTypeID
    .s startString=##class(web.DHCSTEXTCOMMON).GetJsonStartString(maxrow)
    .s firstrow=##class(web.DHCSTEXTCOMMON).GetJsonFirstRow(tmpstr)
    .s lastrow=##class(web.DHCSTEXTCOMMON).GetJsonLastRow(tmpstr)
	.s count=count+1
	.i count=1 w startString
    .i count<maxrow w firstrow
    .i count=maxrow w lastrow
	.
	k ^TMP("dhcpha","DHCSTCNTSMAIN","GetPresctypeDs",pid)
	q ""
}

/// 获取点评日志中的原因组号
ClassMethod GetLogGrpNo(main, itm) As %String
{
	s sub=$o(^DHCPHCNTS(main,"I",itm,"L",""),-1)
	q:sub="" 1
	s grpno=+$p(^DHCPHCNTS(main,"I",itm,"L",sub),"^",12)
	s grpno=grpno+1
	q grpno
}

/// 取点评记录所有的不合理处方(医生用)
ClassMethod GetDataForDoctor(input, stpage, limit)
{
	
	s stdate=$p(input,"^",1)
	s:stdate'="" stdate=##class(websys.Conversions).DateHtmlToLogical(stdate)
	s enddate=$p(input,"^",2)
	s:enddate'="" enddate=##class(websys.Conversions).DateHtmlToLogical(enddate)
	s user=$p(input,"^",3)
	
	s pid=##class(web.DHCSTCNTSMAIN).GetPHCNTSPID()
	s endpage=stpage+limit  //结束行
	s stpage=stpage+1 //开始行

	s h=0
	f date=stdate:1:enddate d
    .s ctabl=""
	.f  s ctabl=$o(^DHCPCTABL(0,"Doctor",user,date,ctabl)) q:ctabl=""  d
    ..s oeori=$p(^DHCPCTABL(ctabl),"^",1)
    ..s itmlogdr=$p(^DHCPCTABL(ctabl),"^",2)
    ..s main=$p(itmlogdr,"||",1)
	..s itm=$p(itmlogdr,"||",2)
	..s sub=$p(itmlogdr,"||",3)
	..q:'$d(^DHCPHCNTS(main,"I",itm,"L",sub))
	..s active=$p(^DHCPHCNTS(main,"I",itm,"L",sub),"^",11)
	..q:active'="Y"
    ..s ord=$p(oeori,"||",1)
    ..s chl=$p(oeori,"||",2)
    ..s moeori=$p(^DHCPCTABL(ctabl),"^",3)
    ..s presc=$p(^OEORD(ord,"I",chl,1),"^",14) ;处方号
	..q:presc=""
	..s arcimid=$p(^OEORD(ord,"I",chl,1),"^",2)  ;医嘱 ARC_ItmMast ARCIM_RowId
	..s itmmastid=$p(arcimid,"||",1)
	..s itmmastver=$p(arcimid,"||",2)
	..s inci=$o(^INCI(0,"ARCIM_DR",$p(arcimid,"||",1),"") ) q:inci=""  //医嘱名称
	..s inciDesc=$p(^INCI(inci,1),"^",2) //药品名称
	..s dsp=$o(^DHCOEDISQTY(0,"OEORI",oeori,""))
	..q:dsp=""
	..s qty=$p(^DHCOEDISQTY(dsp),"^",2)
	..s puomdr=+$p(^INCI(inci,3),"^",6)
	..s buomdr=+$p(^INCI(inci,1),"^",10)
	..s fac=+##Class(web.DHCSTCOMMONSRV).UOMFac(puomdr,buomdr)
	..s uomdr=buomdr
	..i (qty#fac)=0 d
	...s qty=qty/fac   //数量
	...s uomdr=puomdr 
	..s uomdesc=$p($g(^CT("UOM",uomdr)),"^",2) //单位
	..s dosage=$p(^OEORD(ord,"I",chl,2),"^",1) ;剂量
	..i dosage'="" s dosage=$j(dosage,"",3)
    ..s doseuom=""
	..s dosuomID=$p(^OEORD(ord,"I",chl,2),"^",3)
	..i dosuomID'="" d
	...s doseuom=$p($g(^CT("UOM",dosuomID)),"^",2) ;剂量单位
	..s freq=""
	..s freqdr=+$p($g(^OEORD(ord,"I",chl,2)),"^",4) ;OEORI_PHFreq_DR
    ..i freqdr'=0 s freq=$p($g(^PHCFR(freqdr)),"^",3)  ;频率
    ..s instru=""
    ..s instrudr=+$p(^OEORD(ord,"I",chl,2),"^",7)
    ..s:instrudr'=0 instru=$p(^PHCIN(instrudr),"^",2)        	;用法
    ..s duration=""
    ..s dur=+$p(^OEORD(ord,"I",chl,2),"^",6)
	..s:dur'=0 duration=$p(^PHCDU(dur),"^",1)         	;用药疗程
	..s priorty=""
	..s pri=+$p(^OEORD(ord,"I",chl,1),"^",8)
	..s:pri'=0 priorty=$p(^OECPR(pri),"^",2)   		;医嘱优先级
	..s doctor=##class(web.DHCSTCOMMONSRV).getOrdDoctor(oeori)       ;医生
	..s skintest=##class(web.DHCSTCOMMONSRV).GetSkinTestResult(oeori)  ;皮试
	..i inciDesc=skintest_skintest
	..s spec=##class(web.DHCSTCOMMONSRV).getBarcode(inci) ;规格
	..s remark=##class(web.DHCSTCOMMONSRV).GetOrdItmRemark(oeori) ;备注
    ..s orddate=$p(^DHCOEDISQTY(dsp),"^",15)
    ..i orddate'="" s orddate=##class(websys.Conversions).DateLogicalToHtml(orddate)
    ..s ordtime=$p(^DHCOEDISQTY(dsp),"^",16)
    ..i ordtime'="" s ordtime=##class(websys.Conversions).TimeLogicalToHtml(ordtime)
    ..s orddatetime=orddate_" "_ordtime  ;开单日期
    ..s logrowid=$p(^DHCPCTABL(ctabl),"^",2)
    ..s data=orddatetime_"^"_inciDesc_"^"_qty_"^"_uomdesc_"^"_dosage_"^"_doseuom_"^"_instru_"^"_freq_"^"_duration_"^"_spec_"^"_priorty_"^"_doctor_"^"_remark_"^"_oeori
    ..s h=h+1
	..s ^TMP("dhcpha","DHCSTCNTSMAIN","GetDataForDoctor",pid,"Itm",h)=data
    .

    q:h=0 ##class(web.DHCSTEXTCOMMON).GetNoJson()

 	s maxrow=h
 	i endpage>maxrow s endpage=maxrow

    s count=0
    s h=""
    f  s h=$o(^TMP("dhcpha","DHCSTCNTSMAIN","GetDataForDoctor",pid,"Itm",h)) q:h=""  d
    .s data=^TMP("dhcpha","DHCSTCNTSMAIN","GetDataForDoctor",pid,"Itm",h)
    .s orddatetime=$p(data,"^",1)
    .s inciDesc=$p(data,"^",2)
    .s qty=$p(data,"^",3)
    .s uomdesc=$p(data,"^",4)
    .s dosage=$p(data,"^",5)
    .s doseuom=$p(data,"^",6)
    .s instru=$p(data,"^",7)
    .s freq=$p(data,"^",8)
    .s duration=$p(data,"^",9)
    .s spec=$p(data,"^",10)
    .s priorty=$p(data,"^",11)
    .s doctor=$p(data,"^",12)
    .s remark=$p(data,"^",13)
    .s oeori=$p(data,"^",14)
    .
    .s count=count+1
    .q:count<stpage
    .q:count>endpage
    .
    .s orddate=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("orddate",orddatetime)
	.s inciDesc=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("inciDesc",inciDesc)
	.s qty=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("qty",qty)
	.s uomdesc=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("uomdesc",uomdesc)
	.s dosage=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("dosage",dosage)
	.s doseuom=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("doseuom",doseuom)
	.s instru=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("instru",instru)
	.s freq=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("freq",freq)
	.s duration=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("duration",duration)
	.s spec=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("spec",spec)
	.s priorty=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("priorty",priorty)
	.s doctor=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("doctor",doctor)
	.s remark=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("remark",remark)
	.s oeori=##class(web.DHCSTEXTCOMMON).GetJsonLastCell("oeori",oeori)
	.
	.s tmpstr=orddate_inciDesc_qty_uomdesc_dosage_doseuom_instru_freq_duration_spec_priorty_doctor_remark_oeori
    .s startString=##class(web.DHCSTEXTCOMMON).GetJsonStartString(maxrow)
    .s firstrow=##class(web.DHCSTEXTCOMMON).GetJsonFirstRow(tmpstr)
    .s lastrow=##class(web.DHCSTEXTCOMMON).GetJsonLastRow(tmpstr)
	.
    .i count=stpage w startString
    .i count<endpage w firstrow
    .i count=endpage w lastrow
	.
	k ^TMP("dhcpha","DHCSTCNTSMAIN","GetDataForDoctor",pid)

    q ""
}

/// 查询不合理原因(医生用)
ClassMethod GetLogForDoctor(input, stpage, limit)
{
    s orditem=$p(input,"^",1)
    q:orditem="" ##class(web.DHCSTEXTCOMMON).GetNoJson()
    s h=0
	s pid=##class(web.DHCSTCNTSMAIN).GetPHCNTSPID()
	
	//门诊
	s pcnts=""
	f  s pcnts=$o(^DHCPHCNTS(0,"OrdItem",orditem,pcnts)) q:pcnts=""  d
	.s chl=""
	.f  s chl=$o(^DHCPHCNTS(0,"OrdItem",orditem,pcnts,chl)) q:chl=""  d
	..s adm=$p(^DHCPHCNTS(pcnts,"I",chl),"^",3)
	..s sub=""
	..f  s sub=$o(^DHCPHCNTS(pcnts,"I",chl,"L",sub),-1) q:sub=""  d
	...s comdate=$p(^DHCPHCNTS(pcnts,"I",chl,"L",sub),"^",3)
	...i comdate'="" s comdate=##class(websys.Conversions).DateLogicalToHtml(comdate)
	...s comtime=$p(^DHCPHCNTS(pcnts,"I",chl,"L",sub),"^",4)
	...i comtime'="" s comtime=##class(websys.Conversions).TimeLogicalToHtml(comtime)
	...s comuser=""
	...s userdr=$p(^DHCPHCNTS(pcnts,"I",chl,"L",sub),"^",5)
	...s:userdr'="" comuser=$p(^SSU("SSUSR",userdr),"^",2)
	...s comresult=$p(^DHCPHCNTS(pcnts,"I",chl,"L",sub),"^",2)
	...i comresult="Y" s comresult="合格"
	...i comresult="N" s comresult="不合格"
	...s comreason=""
	...s comreasondr=$p(^DHCPHCNTS(pcnts,"I",chl,"L",sub),"^",1)
	...i comreasondr'="" d
	....i $d(^DHCPCREASON(comreasondr)) d
	.....s comreason=$p(^DHCPCREASON(comreasondr),"^",2)
	...s comfactor=""
	...s comfactordr=$p(^DHCPHCNTS(pcnts,"I",chl,"L",sub),"^",8)
	...s:comfactordr'="" comfactor=$p($g(^DHCPCFACTOR(comfactordr)),"^",2)
	...s comadvice=""
	...s comadvicedr=$p(^DHCPHCNTS(pcnts,"I",chl,"L",sub),"^",6)
	...s:comadvicedr'="" comadvice=$p($g(^DHCPCADVICE(comadvicedr)),"^",2)   //药师建议
	...s comdocadvice=$p(^DHCPHCNTS(pcnts,"I",chl,"L",sub),"^",7)  //医生建议
	...s comphnote=$p(^DHCPHCNTS(pcnts,"I",chl,"L",sub),"^",9) //药师备注
	...s comdocnote=$p(^DHCPHCNTS(pcnts,"I",chl,"L",sub),"^",10)  //医师备注
	...s comactive=$p(^DHCPHCNTS(pcnts,"I",chl,"L",sub),"^",11)
	...s comgrpno=$p(^DHCPHCNTS(pcnts,"I",chl,"L",sub),"^",12)
	...s comlogrowid=pcnts_"||"_chl_"||"_sub
	...s h=h+1
    ...s data=comdate_"^"_comtime_"^"_comuser_"^"_comresult_"^"_comreason_"^"_comfactor_"^"_comadvice_"^"_comdocadvice_"^"_comphnote_"^"_comdocnote_"^"_comactive_"^"_comgrpno_"^"_comlogrowid
    ...s ^TMP("dhcpha","DHCSTCNTSMAIN","GetLogForDoctor",pid,h)=data
	...s logrowid=pcnts_"||"_chl_"||"_sub
	...s pctr=""
	...f  s pctr=$o(^DHCPCTABL(0,"LOG",logrowid,pctr)) q:pctr=""  d 
	....s orditm=$p(^DHCPCTABL(pctr),"^",1)
	....s ord=$p(orditm,"||",1)
	....s ordchl=$p(orditm,"||",2)
	....s arcimid=$p(^OEORD(ord,"I",ordchl,1),"^",2)  ;医嘱 ARC_ItmMast ARCIM_RowId
	....s itmmastid=$p(arcimid,"||",1)
	....s itmmastver=$p(arcimid,"||",2)
	....s inci=$o(^INCI(0,"ARCIM_DR",$p(arcimid,"||",1),"") ) q:inci=""  //医嘱名称
	....s inciDesc=$p(^INCI(inci,1),"^",2) //药品名称
	....s comreason="____"_inciDesc
	....s h=h+1
    ....s data=""_"^"_""_"^"_""_"^"_""_"^"_comreason_"^"_""_"^"_""_"^"_""_"^"_""_"^"_""_"^"_""_""
    ....s ^TMP("dhcpha","DHCSTCNTSMAIN","GetLogForDoctor",pid,h)=data
    ....s ^TMP("dhcpha","DHCSTCNTSMAIN","GetLogForDoctor","OrdItem",pid,orditem)=""
    
    
    
    //住院
    s moeori=##class(web.DHCSTCNTSCOMMON).GetMainOeori(orditem)
    s ord=+moeori
    q:ord=0 ##class(web.DHCSTEXTCOMMON).GetNoJson()
    s orditmstr=moeori
    s tmpchl=""
 	F  S tmpchl=$O(^OEORDi(0,"OEORI",ord,moeori,tmpchl)) Q:tmpchl=""  d
 	.s suboeori=ord_"||"_tmpchl
 	.s orditmstr=orditmstr_"^"_suboeori
 	i h>0 s orditmstr=""
 	
 	s cntorditm=$l(orditmstr,"^")
 	f x=1:1:cntorditm d
    .s orditem=$p(orditmstr,"^",x)
    .q:orditem=""
	.s itmlogdr=""
	.f  s itmlogdr=$o(^DHCPCTABL(0,"OrdItm",orditem,itmlogdr),-1) q:itmlogdr=""  d 
	..s main=$p(itmlogdr,"||",1)
	..s itm=$p(itmlogdr,"||",2)
	..s sub=$p(itmlogdr,"||",3)
	..q:'$d(^DHCPHCNTS(main,"I",itm,"L",sub))
	..s comgrpno=$p(^DHCPHCNTS(main,"I",itm,"L",sub),"^",12)
	..s ^TMP("dhcpha","DHCSTCNTSMAIN","GetLogForDoctor","GrpNo",pid,comgrpno)=main_"||"_itm_"||"_sub
	.
	s comgrpno=""
	f  s comgrpno=$o(^TMP("dhcpha","DHCSTCNTSMAIN","GetLogForDoctor","GrpNo",pid,comgrpno),-1) q:comgrpno=""  d
	.s itmlogdr=^TMP("dhcpha","DHCSTCNTSMAIN","GetLogForDoctor","GrpNo",pid,comgrpno)
	.s main=$p(itmlogdr,"||",1)
	.s itm=$p(itmlogdr,"||",2)
    .s sub=""
	.f  s sub=$o(^DHCPHCNTS(main,"I",itm,"L",sub),-1) q:sub=""  d
	..s comgrpno=$p(^DHCPHCNTS(main,"I",itm,"L",sub),"^",12)
	..q:'$d(^TMP("dhcpha","DHCSTCNTSMAIN","GetLogForDoctor","GrpNo",pid,comgrpno))
	..s comdate=$p(^DHCPHCNTS(main,"I",itm,"L",sub),"^",3)
	..i comdate'="" s comdate=##class(websys.Conversions).DateLogicalToHtml(comdate)
	..s comtime=$p(^DHCPHCNTS(main,"I",itm,"L",sub),"^",4)
	..i comtime'="" s comtime=##class(websys.Conversions).TimeLogicalToHtml(comtime)
	..s comuser=""
	..s userdr=$p(^DHCPHCNTS(main,"I",itm,"L",sub),"^",5)
	..s:userdr'="" comuser=$p(^SSU("SSUSR",userdr),"^",2)
	..s active=$p(^DHCPHCNTS(main,"I",itm,"L",sub),"^",11)
	..s reasondr=$p(^DHCPHCNTS(main,"I",itm,"L",sub),"^",1)
	..s comreason=$p(^DHCPCREASON(reasondr),"^",2)
	..s comfactor=""
	..s comfactordr=$p(^DHCPHCNTS(main,"I",itm,"L",sub),"^",8)
	..s:comfactordr'="" comfactor=$p($g(^DHCPCFACTOR(comfactordr)),"^",2)
	..s comadvice=""
	..s comadvicedr=$p(^DHCPHCNTS(main,"I",itm,"L",sub),"^",6)
	..s:comadvicedr'="" comadvice=$p($g(^DHCPCADVICE(comadvicedr)),"^",2)   //药师建议
	..s comdocadvice=$p(^DHCPHCNTS(main,"I",itm,"L",sub),"^",7)  //医生建议
	..s comphnote=$p(^DHCPHCNTS(main,"I",itm,"L",sub),"^",9) //药师备注
	..s comdocnote=$p(^DHCPHCNTS(main,"I",itm,"L",sub),"^",10)  //医师备注
	..s comactive=$p(^DHCPHCNTS(main,"I",itm,"L",sub),"^",11)
	..s comresult=$p(^DHCPHCNTS(main,"I",itm,"L",sub),"^",2)
	..i comresult="Y" s comresult="合格"
	..i comresult="N" s comresult="不合格"
	..s comgrpno=$p(^DHCPHCNTS(main,"I",itm,"L",sub),"^",12)
    ..s logrowid=main_"||"_itm_"||"_sub
    ..s h=h+1
	..s data=comdate_"^"_comtime_"^"_comuser_"^"_comresult_"^"_comreason_"^"_comfactor_"^"_comadvice_"^"_comdocadvice_"^"_comphnote_"^"_comdocnote_"^"_comactive_"^"_comgrpno_"^"_logrowid
    ..s ^TMP("dhcpha","DHCSTCNTSMAIN","GetLogForDoctor",pid,h)=data
    ..
    ..s pctr=""
	..f  s pctr=$o(^DHCPCTABL(0,"LOG",logrowid,pctr)) q:pctr=""  d 
	...s orditm=$p(^DHCPCTABL(pctr),"^",1)
	...s ord=$p(orditm,"||",1)
	...s ordchl=$p(orditm,"||",2)
	...s arcimid=$p(^OEORD(ord,"I",ordchl,1),"^",2)  ;医嘱 ARC_ItmMast ARCIM_RowId
	...s itmmastid=$p(arcimid,"||",1)
	...s itmmastver=$p(arcimid,"||",2)
	...s inci=$o(^INCI(0,"ARCIM_DR",$p(arcimid,"||",1),"") ) q:inci=""  //医嘱名称
	...s inciDesc=$p(^INCI(inci,1),"^",2) //药品名称
	...s comreason="____"_inciDesc
	...s h=h+1
    ...s data=""_"^"_""_"^"_""_"^"_""_"^"_comreason_"^"_""_"^"_""_"^"_""_"^"_""_"^"_""_"^"_""_""
    ...s ^TMP("dhcpha","DHCSTCNTSMAIN","GetLogForDoctor",pid,h)=data


    q:h=0 ##class(web.DHCSTEXTCOMMON).GetNoJson()
    s maxrow=h
    
    s count=0
    s h=""
    f  s h=$o(^TMP("dhcpha","DHCSTCNTSMAIN","GetLogForDoctor",pid,h)) q:h=""  d
    .s data=^TMP("dhcpha","DHCSTCNTSMAIN","GetLogForDoctor",pid,h)
    .s comdate=$p(data,"^",1)
    .s comtime=$p(data,"^",2)
    .s comuser=$p(data,"^",3)
    .s comresult=$p(data,"^",4)
    .s comreason=$p(data,"^",5)
    .s comfactor=$p(data,"^",6)
    .s comadvice=$p(data,"^",7)
    .s comdocadvice=$p(data,"^",8)
    .s comphnote=$p(data,"^",9)
    .s comdocnote=$p(data,"^",10)
    .s comactive=$p(data,"^",11)
    .s comgrpno=$p(data,"^",12)
    .s comlogrowid=$p(data,"^",13)
    .
	.s comdate=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("comdate",comdate)
	.s comtime=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("comtime",comtime)
	.s comuser=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("comuser",comuser)
	.s comresult=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("comresult",comresult)
	.s comreason=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("comreason",comreason)
	.s comfactor=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("comfactor",comfactor)
	.s comadvice=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("comadvice",comadvice)
	.s comdocadvice=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("comdocadvice",comdocadvice)
	.s comphnote=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("comphnote",comphnote)
	.s comdocnote=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("comdocnote",comdocnote)
	.s comactive=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("comactive",comactive)
	.s comgrpno=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("comgrpno",comgrpno)
	.s comlogrowid=##class(web.DHCSTEXTCOMMON).GetJsonLastCell("comlogrowid",comlogrowid)
	.
	.s tmpstr=comdate_comtime_comuser_comresult_comreason_comfactor_comadvice_comdocadvice
	.s tmpstr=tmpstr_comphnote_comdocnote_comactive_comgrpno_comlogrowid
    .s startString=##class(web.DHCSTEXTCOMMON).GetJsonStartString(maxrow)
    .s firstrow=##class(web.DHCSTEXTCOMMON).GetJsonFirstRow(tmpstr)
    .s lastrow=##class(web.DHCSTEXTCOMMON).GetJsonLastRow(tmpstr)
	.s count=count+1
	.i count=1 w startString
    .i count<maxrow w firstrow
    .i count=maxrow w lastrow
	.
	k ^TMP("dhcpha","DHCSTCNTSMAIN","GetLogForDoctor",pid)
	k ^TMP("dhcpha","DHCSTCNTSMAIN","GetLogForDoctor","GrpNo",pid)
	k ^TMP("dhcpha","DHCSTCNTSMAIN","GetLogForDoctor","OrdItem",pid)

    q ""
}

/// 提交保存医生申诉备注
/// w ##class(web.DHCSTCNTSMAIN).SaveDocAdvice("1765||1||2^Accept")
ClassMethod SaveDocAdvice(input) As %String
{
	s ^tmyq("SaveDocAdvice")=input
	s logrowid=$p(input,"^",1)
	s docnote=$p(input,"^",2)
	&sql(update DHC_PHCOMMENTSLOG set PCNTSL_DocNote=:docnote where PCNTSL_RowID=:logrowid)
	i SQLCODE'=0 q -1
	s pctoeori=""
	s pctrowid=$o(^DHCPCTABL(0,"LOG",logrowid,""))	 //DHC_PHCNTSTABOOLIST
	s:pctrowid'="" pctoeori=$p(^DHCPCTABL(pctrowid),"^",1)
	s:+$p(pctoeori,"||",2)'="" sendarcitm=$p(^OEORD(+pctoeori,"I",$p(pctoeori,"||",2),1),"^",2)	//医嘱项id
	s ConText="医生申诉:"_$p(^ARCIM(+sendarcitm,$p(sendarcitm,"||",2),1),"^",2)_","_docnote
	s ret1=##class(web.DHCSTInterfaceMessage).SendCommentResult(logrowid,"Exec",pctoeori,ConText)
	s ret2=##class(web.DHCSTInterfaceMessage).SendAppealComment(logrowid,"Send",pctoeori,ConText)	
	q 0
}

/// 审核是否合理
ClassMethod GetPassRetsult(pid) As %String
{
    s userid=""
    s ctlocid=""
    s groupid=""
	s UserInfo=userid_"^"_ctlocid_"^"_groupid
	s h=""
	f  s h=$o(^TMP("dhcpha","DHCSTCNTSMAIN","GetPrescData","ForSaveData",pid,h)) q:h=""  d
	.s str=^TMP("dhcpha","DHCSTCNTSMAIN","GetPrescData","ForSaveData",pid,h)
	.s prescno=$p(str,"^",1)
	.s prescstr=""
	.s ord=""
	.f  s ord=$o(^OEORD(0,"PrescNo",prescno,ord))  q:ord=""  d
	..s adm=$p(^OEORD(ord),"^",1)
	..s chl=""
	..f  s chl=$o(^OEORD(0,"PrescNo",prescno,ord,chl)) q:chl=""  d
	...s orditm=ord_"||"_chl
	...s dsp=$o(^DHCOEDISQTY(0,"OEORI",orditm,""))
	...s status=$p(^DHCOEDISQTY(dsp),"^",7)
	...q:(status'="C")
	...i prescstr="" d
	....s prescstr=orditm
	...e  d
	....s prescstr=prescstr_$c(2)_orditm
	.s Input=prescstr
	.s retinfo=##class(web.DHCSTPHCMPASS).CheckLibPha(.RetStr,"C",Input,UserInfo)
	.s val=$p(retinfo,"^",1)
	.s ^TMP("dhcpha","DHCSTCNTSMAIN","GetPrescData","PassData",pid,prescno)=val
	q ""
}

/// Author : MYQ
/// CreatDate : 20150601
/// Description : 检查该点评单是否符合提交查询条件
/// Input : pcnts - 点评主表ID , subflag - 提交筛选
/// Output : 0 - 不符合 , 1 - 符合
/// DeBug : 
/// w ##class(web.DHCSTCNTSMAIN).ChkCommonts(509)
ClassMethod ChkCommonts(pcnts, subflag) As %String
{
	q:subflag="" 1
	s submitflag=$p(^DHCPHCNTS(pcnts),"^",9) ;提交标记
	q:(subflag=3)&(submitflag'="Y") 0
	q:(subflag'=3)&(submitflag="Y") 0
	q:(subflag=3)&(submitflag="Y") 1
	
	s chkflag=0
	s chl=""
	f  s chl=$o(^DHCPHCNTS(pcnts,"I",chl)) q:(chl="")||(chkflag'=0)  d
	.s curret=$p(^DHCPHCNTS(pcnts,"I",chl),"^",6)
	.s:curret'="" chkflag=1
	; chkflag=1 表示已经有点评结果但是尚未提交
	q:(subflag=2)&(chkflag=0) 0
	q:(subflag=1)&(chkflag=1) 0
	
	q 1
}

/// Author : MYQ
/// CreatDate : 2015-6-1
/// 提交点评单
ClassMethod SubmitCommonts(pcntsno) As %String
{
	s pcnt=$o(^DHCPHCNTS(0,"No",pcntsno,""))
	s subflag=$p(^DHCPHCNTS(pcnt),"^",9)
	q:subflag="Y" -2
	s submitflag="Y"
	&sql(update DHC_PHCOMMENTS set PCNTS_SubmFlag=:submitflag where PCNTS_No=:pcntsno)
	i SQLCODE'=0 q -1
	q 0
}

/// Author : MYQ
/// CreatDate : 2015-6-1
/// 取消提交点评单
ClassMethod CancleSubCommonts(pcntsno) As %String
{
	s pcnt=$o(^DHCPHCNTS(0,"No",pcntsno,""))
	s subflag=$p(^DHCPHCNTS(pcnt),"^",9)
	q:subflag'="Y" -2
	s submitflag="N"
	&sql(update DHC_PHCOMMENTS set PCNTS_SubmFlag=:submitflag where PCNTS_No=:pcntsno)
	i SQLCODE'=0 q -1
	q 0
}

/// Descript:获取点评单当前状态
ClassMethod GetPCommontsStatus(pcnts) As %String
{
	q:pcnts="" ""
	s submitdesc=""
	s submitflag=$p(^DHCPHCNTS(pcnts),"^",9) ;提交标记
	i submitflag'="" s submitdesc="已提交"
	q:submitdesc'="" submitdesc
		
	s chkflag=0
	s chl=""
	f  s chl=$o(^DHCPHCNTS(pcnts,"I",chl)) q:(chl="")||(chkflag'=0)  d
	.s curret=$p(^DHCPHCNTS(pcnts,"I",chl),"^",6)
	.s:curret'="" chkflag=1
	
	i chkflag=1 s submitdesc="点评中"
	e  s submitdesc="未点评"
	q submitdesc
}

/// 获取点评药师列表
/// 取 SS_Use r中的所有人员
ClassMethod GetPhaDs() As %String
{
	s pid=##class(web.DHCSTCNTSMAIN).GetPHCNTSPID()
	s h=0
	s ssuser=0
	f  s ssuser=$o(^SSU("SSUSR",ssuser)) q:ssuser=""  d
	.s docname=$p(^SSU("SSUSR",ssuser),"^",2)
	.i $f(docname,$c(13)) s docname=$p(docname,$c(13),1)
	.s h=h+1
    .s data=docname_"^"_ssuser
    .s ^TMP("dhcpha","DHCSTCNTSMAIN","GetPhaDs",pid,h)=data
    q:h=0 ##class(web.DHCSTEXTCOMMON).GetNoJson()
    s maxrow=h
    
    s count=0
    s h=""
    f  s h=$o(^TMP("dhcpha","DHCSTCNTSMAIN","GetPhaDs",pid,h)) q:h=""  d
    .s data=^TMP("dhcpha","DHCSTCNTSMAIN","GetPhaDs",pid,h)
    .s docname=$p(data,"^",1)
    .s doctordr=$p(data,"^",2)
    .
    .s docname=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("docname",docname)
	.s doctordr=##class(web.DHCSTEXTCOMMON).GetJsonLastCell("doctordr",doctordr)
	.
	.s tmpstr=docname_doctordr
    .s startString=##class(web.DHCSTEXTCOMMON).GetJsonStartString(maxrow)
    .s firstrow=##class(web.DHCSTEXTCOMMON).GetJsonFirstRow(tmpstr)
    .s lastrow=##class(web.DHCSTEXTCOMMON).GetJsonLastRow(tmpstr)
	.s count=count+1
	.i count=1 w startString
    .i count<maxrow w firstrow
    .i count=maxrow w lastrow
	.
	k ^TMP("dhcpha","DHCSTCNTSMAIN","GetPhaDs",pid)
	q ""
}

/// Author : MYQ
/// CreatDate : 20161017
/// Description : 根据点评子表id和点评方式获取是否能够点评
/// Input : pcntsi - 点评字表id , grpdr - 登录安全组
/// Output : -33-不能,1-能  -10 - 入参为空
/// 
ClassMethod GetPCNTSComFlag(pcntsi, grpdr) As %String
{
	
	q:(pcntsi="")||(grpdr="") -10
	s main=+pcntsi
	s itm=$p(pcntsi,"||",2)
	s curret=$p(^DHCPHCNTS(main,"I",itm),"^",6) 
    s wayid=$p(^DHCPHCNTS(main),"^",7)
    s config=##class(web.DHCSTCNTSCOMMON).GetSecGrpConfigStr(wayid,grpdr)
    s updateflag=$p(config,"^",1)
    q:(curret'="")&(updateflag'="Y") -11  //无权修改
    q 1
}

/// Author : MYQ
/// Description : 检查处方是否已发药
/// Return：1 - 已发  0 未发
/// Input : prescno - 处方号
ClassMethod ChkPrescDisp(prescno) As %String
{
	q:prescno="" "0"
	s fyflag=0
	//s phdrowid=""
	//f  s phdrowid=$o(^DHCPHDISPi("PRESCNO",prescno,phdrowid)) q:(phdrowid="")||(fyflag=1)  d 
	//.s fyflag=$p(^DHCPHDISP(phdrowid),"^",4)   ;取发药标志
	//.q:fyflag'="1"                ;过滤掉未发药的处方
	s pharowid=""
	f  s pharowid=$o(^DHCPHARi("PRESCNO",prescno,pharowid)) q:(pharowid="")||(fyflag=1)  d
	.s phanouser=$p(^DHCPHARW(pharowid),"^",7) ;发票是否有效
	.s:phanouser'=1 fyflag=1
	q fyflag
}

/// Author : MYQ
/// CreatDate : 20170302
/// Description : 获取门诊医嘱的不合理原因(不判断点评状态是否为激活状态,供点评日志查询处使用)
/// input : orditem - 医嘱id , pcntslid - 点评孙表id
/// w ##class(web.DHCSTCNTSMAIN).GetOPCommentReason("1577||1||3","664||4")
ClassMethod GetOPCommentReason(pcntslid, orditem = "", delim = " ") As %String
{
	q:pcntslid="" ""
	s i=0
	s ret=""
	s reagrpno=""
	i orditem'="" d
	.s itmlogdr=""
	.f  s itmlogdr=$o(^DHCPCTABL(0,"OrdItm",orditem,itmlogdr)) q:itmlogdr=""  d
	..s main=$p(itmlogdr,"||",1)
	..q:(pcntslid'="")&&(main'=+pcntslid)
	..s itm=$p(itmlogdr,"||",2)
	..s sub=$p(itmlogdr,"||",3)
	..q:'$d(^DHCPHCNTS(main,"I",itm,"L",sub))
	..s reagrpno=$p(^DHCPHCNTS(main,"I",itm,"L",sub),"^",12)	//组号
	e  d
	.s reagrpno=$p(^DHCPHCNTS(+pcntslid,"I",$p(pcntslid,"||",2),"L",$p(pcntslid,"||",3)),"^",12)	//组号
	
	q:reagrpno="" ""
	
	s smain=$p(pcntslid,"||",1)
	s sitm=$p(pcntslid,"||",2)
	s ssub=""
	f  s ssub=$o(^DHCPHCNTS(smain,"I",sitm,"L",ssub)) q:ssub=""  d
	.s sactive=$p(^DHCPHCNTS(smain,"I",sitm,"L",ssub),"^",11)
	.s sreagrpno=$p(^DHCPHCNTS(smain,"I",sitm,"L",ssub),"^",12)
	.q:(reagrpno'=sreagrpno)
	.s reasondr=$p(^DHCPHCNTS(smain,"I",sitm,"L",ssub),"^",1)
	.q:+reasondr="0"
	.s reason=$p($g(^DHCPCREASON(reasondr)),"^",2)
	.s i=i+1
	.i ret="" d
	..s ret=i_"."_reason
	.e  d
	.. s ret=ret_delim_i_"."_reason
	q ret
}

/// description: 门诊获取退药数量(基本单位)
/// return:		w ##class(web.DHCSTCNTSMAIN).GetOeoriRetQty("1523||5")
ClassMethod GetOeoriRetQty(oeori)
{
	q:oeori="" 0
	s retQty=0
	s phrId=""
	f  s phrId=$o(^DHCPHRTIi(oeori,"ORDI",phrId)) q:phrId=""  d
	.q:+phrId=0
	.s phrItm=""
	.f  s phrItm=$o(^DHCPHRTIi(oeori,"ORDI",phrId,phrItm)) q:phrItm=""  d
	..q:+phrItm=0
	..s phrQty=+$p(^DHCPHRTI(phrId,"RTI",phrItm),"^",3)
	..s retQty=retQty+phrQty
	q retQty
}

/// description: 获取医嘱项集合
/// w ##class(web.DHCSTCNTSMAIN).GetArcimDs("apzl","0","50")
ClassMethod GetArcimDs(inputStr, startpage, limitpage) As %String
{
	s $zt="ThrowGetArcimDs"
	s ^TMPDHCSTPARAMS("web.DHCSTCNTSMAIN","GetArcimDs")=$lb(inputStr, startpage, limitpage)
    s endpage=startpage+limitpage
    s filterText=$$ALPHAUP^SSUTIL4(inputStr)
    q:filterText="" ##class(web.DHCSTEXTCOMMON).GetNoJson()
    s count=0
	s aliasText=""
	f  s aliasText=$o(^ARC("ALIAS",0,"Desc",aliasText)) q:aliasText=""  d
	.q:($zcvt(aliasText,"U")'[filterText)
	.s aliasDesc=""
	.f  s aliasDesc=$o(^ARC("ALIAS",0,"Desc",aliasText,aliasDesc)) q:aliasDesc=""  d
	..s aliasId=""
	..f  s aliasId=$o(^ARC("ALIAS",0,"Desc",aliasText,aliasDesc,aliasId)) q:aliasId=""  d
	...q:'$d(^ARC("ALIAS",aliasId))
	...s arcItmId=$p(^ARC("ALIAS",aliasId),"^",1)
	...q:arcItmId=""
	...q:$d(ArcItmMastArr(arcItmId))
	...s arcSub=+arcItmId
	...s arcVer=+$p(arcItmId,"||",2)
	...q:'$d(^ARCIM(arcSub,arcVer,1))
	...s arcItmCatId=$p($g(^ARCIM(arcSub,arcVer,1)),"^",10)
	...q:$P($g(^ARC("IC",+arcItmCatId)),"^",7)'="R"
	...s ArcItmMastData(arcItmId)=""
	...s arcItmCode=$p(^ARCIM(arcSub,arcVer,1),"^",1)
	...s arcItmDesc=$p(^ARCIM(arcSub,arcVer,1),"^",2)	
	...s ArcItmMastData(arcItmCode,arcItmId)=arcItmId_"^"_arcItmCode_"^"_arcItmDesc
	...s ArcItmMastArr(arcItmId)=""
	...s count=count+1
    q:'$d(ArcItmMastData) ##class(web.DHCSTEXTCOMMON).GetNoJson()
    i count<endpage s endpage=count
    s records=0
    s arcItmCode=""
    f  s arcItmCode=$o(ArcItmMastData(arcItmCode)) q:arcItmCode=""  d
    .s arcItmId=""
    .f  s arcItmId=$o(ArcItmMastData(arcItmCode,arcItmId)) q:arcItmId=""  d
    ..s records=records+1
	..Q:(records<startpage)||(records>endpage)
    ..s arcItmDesc=$p(ArcItmMastData(arcItmCode,arcItmId),"^",3)
	..s arcimId=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("arcimId",arcItmId)
	..s arcimCode=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("arcimCode",arcItmCode)
	..s arcimDesc=##class(web.DHCSTEXTCOMMON).GetJsonLastCell("arcimDesc",arcItmDesc)
	..s tmpStr=arcimId_arcimCode_arcimDesc
    ..s startString=##class(web.DHCSTEXTCOMMON).GetJsonStartString(count)
    ..s firstrow=##class(web.DHCSTEXTCOMMON).GetJsonFirstRow(tmpStr)
    ..s lastrow=##class(web.DHCSTEXTCOMMON).GetJsonLastRow(tmpStr)
	..i (records=1)||(records=startpage) w startString 
	..i (records<endpage)||(records<count) w firstrow 
    ..i (records=endpage)||(records=count) w lastrow
    q ""
ThrowGetArcimDs
	q ##class(web.DHCSTEXTCOMMON).GetNoJson()
}

}
