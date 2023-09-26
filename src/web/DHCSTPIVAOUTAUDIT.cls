Import sqluser

/// 门诊配液配伍审核
Class web.DHCSTPIVAOUTAUDIT Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// 查询配液申请明细	
/// Creator:LiangQiang
/// CreatDate:2013-05-27
/// Input:登记号,开始行,限制行,参数串
/// Output:明细
/// w ##class(web.DHCSTPIVAOUTAUDIT).FindReqDetailData("","0","30","1/11/2015^18/11/2015^101^^false")
ClassMethod FindReqDetailData(RegNo, StPage, Limit, Input) As %String
{
	s pid=##class(web.DHCSTPIVAOUTCOMMON).GetPIVAOUTPID()
	s stdate=$p(Input,"^",1)
	s stdate=$zdh(stdate,4)
	s enddate=$p(Input,"^",2)
	s enddate=$zdh(enddate,4)
    s phalocdr=$p(Input,"^",3)
    s patID=$p(Input,"^",4)
    s onlyadt=$p(Input,"^",5)
    s endpage=StPage+Limit  //结束行
	s stpage=StPage+1 //开始行
	
	s h=0
	f date=stdate:1:enddate  d
	.s pdis=""
	.f  s pdis=$o(^PIVADIS(0,"Date",phalocdr,date,pdis)) q:pdis=""  d
	..s oeori=$p(^PIVADIS(pdis),"^",1)
	..s ord=$p(oeori,"||",1)
	..s chl=$p(oeori,"||",2)
	..q:'$d(^OEORD(ord,"I",chl))
	..s adtresult=$p($g(^OEORD(ord,"I",chl,7)),"^",3)
	..q:(onlyadt="true")&(adtresult="")  //已审核
    ..q:(onlyadt'="true")&(adtresult'="")
	..s dodis=$p(^PIVADIS(pdis),"^",2)
	..s prescno=$p(^OEORD(ord,"I",chl,1),"^",14)
	..q:prescno="" 
	..s adm=$p(^OEORD(ord),"^",1)
    ..s papmidr=$p(^PAADM(adm),"^",1)
    ..S PapmiNo=$p(^PAPER(papmidr,"PAT",1),"^",2)
	..Q:(PapmiNo'=RegNo)&(RegNo'="")
    ..s sttdate=$P(^OEORD(ord,"I",chl,1),"^",9)
    ..s index=papmidr_"^"_adm_"^"_""_"^"_prescno_"^"_oeori
    ..i $p(^PIVADIS(pdis),"^",7)'="REC" s ^TMP("dhcpha","DHCSTPIVAOUTRECDRUG","FindReqDetailData","Rec",pid,prescno)=""  //当处方中有一个为未接收状态则不允许配伍审核,yunhaibao,20151224
    ..s ^TMP("dhcpha","DHCSTPIVAOUTRECDRUG",pid,"index",index)=""
    s index=""
    f  s index=$o(^TMP("dhcpha","DHCSTPIVAOUTRECDRUG",pid,"index",index)) q:index=""  d
    .s adm=$p(index,"^",2)
    .s prescno=$p(index,"^",4)
    .q:$d(^TMP("dhcpha","DHCSTPIVAOUTRECDRUG","FindReqDetailData","Rec",pid,prescno))
    .s oeori=$p(index,"^",5)
   	.s ord=$p(oeori,"||",1)
	.s chl=$p(oeori,"||",2)
    .s priordr=$p(^OEORD(ord,"I",chl,1),"^",8) 
    .q:priordr="" 
    .s adtinfo=##Class(web.DHCSTPIVAOUTCOMMON).GetAdtResultInfo(oeori)
    .s adtuser=$p(adtinfo,"^",1)
    .s adtdate=$p(adtinfo,"^",2)_" "_$p(adtinfo,"^",3)
    .s result=$p(adtinfo,"^",4)
    .s papmi=+$p(^PAADM(adm),"^",1)
    .s patno=$p(^PAPER(papmi,"PAT",1),"^",2)
    .s patname=$p(^PAPER(papmi,"ALL"),"^",1)
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
	.s dodisstr=""
	.s qty=0
	.s dodis=""
    .f  s dodis=$o(^DHCOEDISQTY(0,"OEORI",oeori,dodis)) q:dodis=""  d
    ..s qty=qty+$P(^DHCOEDISQTY(dodis),"^",11)
    ..i dodisstr="" s dodisstr=dodis
    ..e  s dodisstr=dodisstr_"$"_dodis
    .S dsprowid=$o(^DHCOEDISQTY(0,"OEORI",oeori,""))
    .s orddate=$p(^DHCOEDISQTY(dsprowid),"^",21)
    .i orddate="" s orddate=$p(^DHCOEDISQTY(dsprowid),"^",15)
    .i orddate'="" s orddate=$zd(orddate,3)
    .s ordtime=$p(^DHCOEDISQTY(dsprowid),"^",20)
    .i ordtime="" s ordtime=$p(^DHCOEDISQTY(dsprowid),"^",16)
    .i ordtime'="" s ordtime=$zt(ordtime,1)
    .s orddatetime=orddate_" "_ordtime  ;开单日期
    .S grpno=$p(^DHCOEDISQTY(dsprowid),"^",4)
    .S mdodis=##class(web.DHCSTPIVA).GetMainOEDispID(dsprowid,grpno)
    .i (qty#fac)=0 d
	..s qty=qty/fac   //数量
	..s uomdr=puomdr 
	.s uomdesc=$p($g(^CT("UOM",uomdr)),"^",2) //单位
	.s selectflag=mdodis
	.s h=h+1
	.s tmpindex=prescno //_"^"_mdodis
	.s prescnoT=prescno
    .i $D(^TMP("dhcpha","DHCSTPIVAOUTAUDIT","FindReqDetailData","PrescNo",pid,tmpindex)) d
    ..s orddatetime=""
    ..s prescno=""
    ..s patno="",patname=""
    .e  d
    ..s ^TMP("dhcpha","DHCSTPIVAOUTAUDIT","FindReqDetailData","PrescNo",pid,tmpindex)=""
	.s data=inciDesc_"^"_qty_"^"_uomdesc_"^"_dosage_doseuom_"^"_freq_"^"_spec_"^"_instru_"^"_duration_"^"_form
    .s data=data_"^"_priorty_"^"_doctor_"^"_orddatetime_"^"_remark_"^"_oeori_"^"_prescno_"^"_selectflag
    .s data=data_"^"_patno_"^"_patname_"^"_adtuser_"^"_adtdate_"^"_result_"^"_dodisstr_"^"_dsprowid_"^"_prescnoT
    .s ^TMP("dhcpha","DHCSTPIVAOUTRECDRUG","FindReqDetailData",pid,"Itm",h)=data
	k ^TMP("dhcpha","DHCSTPIVAOUTRECDRUG","FindReqDetailData","Rec",pid)
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
    .s orditm=$p(data,"^",14)
    .s prescno=$p(data,"^",15)
    .s selectflag=$p(data,"^",16)
    .s patno=$p(data,"^",17)
    .s patname=$p(data,"^",18)
    .s adtuser=$p(data,"^",19)
    .s adtdate=$p(data,"^",20) 
    .s result=$p(data,"^",21)
    .s dodisstr=$p(data,"^",22)
    .s dodis=$p(data,"^",23)
    .s prescnoT=$p(data,"^",24)
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
	.s prescnoT=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("prescnoT",prescnoT)
	.s selectflag=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("selectflag",selectflag)
	.s patno=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("patid",patno)
	.s patname=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("patname",patname)
	.s adtuser=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("adtuser",adtuser)
	.s adtdate=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("adtdate",adtdate)
	.s result=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("result",result)
	.s dodis=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("dodis",dodis)
	.s dodisstr=##class(web.DHCSTEXTCOMMON).GetJsonLastCell("dodisstr",dodisstr)
	.
	.s tmpstr=incidesc_qty_uomdesc_dosage_freq_spec_instruc_dura_form_pri_doctor_orddate_remark_orditm_prescno_prescnoT_selectflag
	.s tmpstr=tmpstr_patno_patname_adtuser_adtdate_result_dodis_dodisstr
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
}

/// 保存审核不合格结果
/// reasonstr组织字符串 ：原因ID1^原因ID2 $$$ 药品ID1 $$$ 药品ID2 ! 原因ID3^ ... 
ClassMethod SaveResult(reasonstr, input) As %String
{
    
	s result=$p(input,",",1)
	i result="N" s status="SHJJ"
	i result="Y" s status="SHTG" 
	s user=$p(input,",",2)
	s orditmstr=$p(input,",",3) 
	s currdate=+$h
	s currtime=$p($h,",",2)
	s locdr=$p(input,",",4) 
	s apptype=$p(input,",",5)
	s data=user_","_currdate_","_currtime_","_status
	//
	s pid=##class(web.DHCSTPIVAOUTCOMMON).GetPIVAOUTPID()
	/////tstart
	s chkflag=0
	//门诊按处方处理
	s m=0
	s cnt=$l(orditmstr,"^")
	f i=1:1:cnt d
	.s oeori=$p(orditmstr,"^",i)
	.s ord=$p(oeori,"||",1)
	.s itm=$p(oeori,"||",2)
	.s adm=$p(^OEORD(ord),"^",1)
	.s prescno=$p(^OEORD(ord,"I",itm,1),"^",14)
	.s ord=""
	.f  s ord=$o(^OEORD(0,"PrescNo",prescno,ord))  q:ord=""  d
	..s chl=""
    ..f  s chl=$o(^OEORD(0,"PrescNo",prescno,ord,chl)) q:chl=""  d
    ...s orditem=ord_"||"_chl
    ...s auditflag=$p(^OEORD(ord,"I",chl,7),"^",3)
    ...q:auditflag'=""
    ...s statdr=$p(^OEORD(ord,"I",chl,1),"^",13)
	...s oeflag=$p(^OEC("OSTAT",statdr),"^",1) 
	...q:(oeflag'="V")&(oeflag'="E")
	...s priordr=$p(^OEORD(ord,"I",chl,1),"^",8) 
    ...q:priordr="" 
    ...s priority=$p(^OECPR(priordr),"^",1) 			;医嘱优先级代码              
    ...q:$p(^OEORD(ord,"I",chl,7),"^",3)'=""
	...s $p(^OEORD(ord,"I",chl,7),"^",3)=data
	...s chkflag=1
	//q:chkflag=0 0
    //
	tstart
	s err=0
	k PLIST
	s PLIST(2)=user
	s PLIST(3)=result
	
	s PLIST(4)=currdate
	s PLIST(5)=currtime
	s PLIST(6)=locdr
	s PLIST(10)=apptype
	&sql(INSERT INTO DHC_PHAORDMONITOR  VALUES :PLIST())
	i SQLCODE'=0  tro 
	i SQLCODE'=0 s err=1
	q:err'=0 -2
	s phaomr=+%ROWID
	
	//审核不通过,插入问题列表
	s tmpstr=reasonstr
	s cnt=$l(tmpstr,"!")
	i reasonstr="" s cnt=0
	f h=1:1:cnt q:err'=0  d
	.s splitstr=$p(tmpstr,"!",h)
	.s grpno=h
	.s tmpreasonstr=$p(splitstr,"$$$",1)
	.s reacnt=$l(tmpreasonstr,"^")
	.f n=1:1:reacnt q:err'=0  d
	..s reasondr=$p(tmpreasonstr,"^",n)  //原因ID
	..f m=2:1:$l(splitstr,"$$$") q:err'=0  d
	...s oeori=$p(splitstr,"$$$",m) //医嘱ID
	...s ord=$p(oeori,"||",1)
	...s chl=$p(oeori,"||",2)
	...k PLIST
	...s PLIST(0)=phaomr
	...s PLIST(2)=oeori
	...s PLIST(4)=reasondr
	...s PLIST(3)=grpno
	...s PLIST(5)=+$o(^DHCPHORDM(phaomr,"I",""),-1)+1
	...s PLIST(6)=$p(^OEORD(+oeori,"I",$p(oeori,"||",2),1),"^",14)
	...&sql(INSERT INTO DHC_PHAORDMONITORLIST  VALUES :PLIST())
	...i SQLCODE'=0  tro 
	...i SQLCODE'=0 s err=1
	...q:SQLCODE'=0
	...s data=user_","_currdate_","_currtime_","_status
	...s $p(^OEORD(ord,"I",chl,7),"^",3)=data
	...
    //审核通过,只插一条记录
	i result="Y" d
	.k PLIST
	.s PLIST(0)=phaomr
	.s PLIST(2)=oeori
	.s PLIST(3)=1
	.s PLIST(5)=+$o(^DHCPHORDM(phaomr,"I",""),-1)+1
	.s PLIST(6)=$p(^OEORD(+oeori,"I",$p(oeori,"||",2),1),"^",14)
	.&sql(INSERT INTO DHC_PHAORDMONITORLIST  VALUES :PLIST())
	.i SQLCODE'=0  tro 
	.i SQLCODE'=0 s err=1
	.q:SQLCODE'=0
	
	q:err'=0 -1

	tcommit

	q 0
}

/// 获取不合格药品名称集合
ClassMethod GetBedOrdItmDs(orditmstr) As %String
{
	s h=0
	s pid=##class(web.DHCSTPIVAOUTCOMMON).GetPIVAOUTPID()
    s cnt=$l(orditmstr,"^")
    f i=1:1:cnt d
    .s orditm=$p(orditmstr,"^",i)
    .s ord=$p(orditm,"||",1)
    .s chl=$p(orditm,"||",2)
	.s arcimid=$p(^OEORD(ord,"I",chl,1),"^",2)  ;医嘱 ARC_ItmMast ARCIM_RowId
	.s itmmastid=$p(arcimid,"||",1)
	.s itmmastver=$p(arcimid,"||",2)
	.s inci=$o(^INCI(0,"ARCIM_DR",$p(arcimid,"||",1),"") ) q:inci=""  //医嘱名称
	.s inciDesc=$p(^INCI(inci,1),"^",2) //药品名称
	.s h=h+1
    .s data=inciDesc_"^"_orditm
    .s ^TMP("dhcpha","DHCSTPIVAOUTAUDIT","GetBedOrdItmDs",pid,h)=data
    q:h=0 ##class(web.DHCSTEXTCOMMON).GetNoJson()
    s maxrow=h
    
    s count=0
    s h=""
    f  s h=$o(^TMP("dhcpha","DHCSTPIVAOUTAUDIT","GetBedOrdItmDs",pid,h)) q:h=""  d
    .s data=^TMP("dhcpha","DHCSTPIVAOUTAUDIT","GetBedOrdItmDs",pid,h)
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
	k ^TMP("dhcpha","DHCSTPIVAOUTAUDIT","GetBedOrdItmDs",pid)
	q ""
}

/// 取审核日志
ClassMethod GetOrdItmAuditLog(orditem, stpage, limit) As %String
{
	
	s pid=##class(web.DHCSTPIVAOUTCOMMON).GetPIVAOUTPID()
	s endpage=stpage+limit  //结束行
	s stpage=stpage+1 //开始行
	
    q:orditem="" ##class(web.DHCSTEXTCOMMON).GetNoJson()
    s prescno=$p(^OEORD(+orditem,"I",$p(orditem,"||",2),1),"^",14)
    s h=0
    s ord=+orditem
    s chl=$p(orditem,"||",2)
    s adm=$p(^OEORD(ord),"^",1)
    s admtype=$p(^PAADM(adm),"^",2)
    s phor=""
 	F  S phor=$O(^DHCPHORDM(0,"PrescNo",prescno,phor),-1) Q:phor=""  d
 	.d getData
 	
 	q:h=0 ##class(web.DHCSTEXTCOMMON).GetNoJson()
	
 	s maxrow=h
 	i endpage>maxrow s endpage=maxrow
    
    s count=0
    s h=""
    f  s h=$o(^TMP("dhcpha","DHCSTPIVAOUTAUDIT","GetOrdItmAuditLog",pid,h)) q:h=""  d
    .s data=^TMP("dhcpha","DHCSTPIVAOUTAUDIT","GetOrdItmAuditLog",pid,h)
    .s auditdate=$p(data,"^",2)
    .s audittime=$p(data,"^",3)
    .s audituser=$p(data,"^",1)
    .s result=$p(data,"^",4)
    .s factor=$p(data,"^",6)
    .s advice=$p(data,"^",5)
    .s docadvice=$p(data,"^",8)
    .s phnote=$p(data,"^",7)
    .s docnote=$p(data,"^",9)
    .s rowid=$p(data,"^",10)
    .
    .s count=count+1
    .q:count<stpage
    .q:count>endpage
    .
    .s auditdate=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("auditdate",auditdate)
	.s audittime=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("audittime",audittime)
	.s audituser=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("audituser",audituser)
	.s result=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("result",result)
	.s factor=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("factor",factor)
	.s advice=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("advice",advice)
	.s docadvice=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("docadvice",docadvice)
	.s phnote=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("phnote",phnote)
	.s docnote=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("docnote",docnote)
	.s rowid=##class(web.DHCSTEXTCOMMON).GetJsonLastCell("rowid",rowid)
	.
	.s tmpstr=auditdate_audittime_audituser_result_factor_advice_docadvice_phnote_docnote_rowid
	.
    .s startString=##class(web.DHCSTEXTCOMMON).GetJsonStartString(maxrow)
    .s firstrow=##class(web.DHCSTEXTCOMMON).GetJsonFirstRow(tmpstr)
    .s lastrow=##class(web.DHCSTEXTCOMMON).GetJsonLastRow(tmpstr)
	.
    .i count=stpage w startString
    .i count<endpage w firstrow
    .i count=endpage w lastrow
	.
	
 	k ^TMP("dhcpha","DHCSTPIVAOUTAUDIT","GetOrdItmAuditLog",pid)

    q ""

    
getData 

 	s Audituser=""
 	s userdr=$p(^DHCPHORDM(phor),"^",1)
 	s:userdr'="" Audituser=$p(^SSU("SSUSR",userdr),"^",2)
 	s result=$p(^DHCPHORDM(phor),"^",2)
 	i result="Y" s result="通过"
 	i result="N" s result="拒绝"
 	i result=""  s result="撤消"
 	s Auditdate=$p(^DHCPHORDM(phor),"^",3)
 	i Auditdate'="" s Auditdate=$zd(Auditdate,3)
 	s Audittime=$p(^DHCPHORDM(phor),"^",4)
 	i Audittime'="" s Audittime=$zt(Audittime,1)
 	s advice=$p(^DHCPHORDM(phor),"^",7)
 	s docadvice=$p(^DHCPHORDM(phor),"^",8)
 	s factor=$p(^DHCPHORDM(phor),"^",9)
 	s phnote=$p(^DHCPHORDM(phor),"^",10)
 	s docnote=$p(^DHCPHORDM(phor),"^",11)
 	s rowid=phor
 	s data=Audituser_"^"_Auditdate_"^"_Audittime_"^"_result_"^"_advice_"^"_factor_"^"_phnote_"^"_docadvice_"^"_docnote_"^"_rowid
 	s h=h+1
    s ^TMP("dhcpha","DHCSTPIVAOUTAUDIT","GetOrdItmAuditLog",pid,h)=data
}

/// 取点评记录日志
ClassMethod GetOrdItmAuditItmLog(phomdr, stpage, limit) As %String
{
	
	s pid=##class(web.DHCSTPIVAOUTCOMMON).GetPIVAOUTPID()
	s endpage=stpage+limit  //结束行
	s stpage=stpage+1 //开始行
	
    q:phomdr="" ##class(web.DHCSTEXTCOMMON).GetNoJson()
    s result=$p(^DHCPHORDM(phomdr),"^",2)
    q:result="Y" ##class(web.DHCSTEXTCOMMON).GetNoJson() //通过不显示问题列表
    s h=0
    s sub=""
 	F  S sub=$O(^DHCPHORDM(phomdr,"I",sub)) Q:sub=""  d
 	.s grpno=$p(^DHCPHORDM(phomdr,"I",sub),"^",1)
 	.i grpno="" s grpno="-"
 	.s orditm=$p(^DHCPHORDM(phomdr,"I",sub),"^",2)
 	.q:orditm=""
 	.s reasondr=$p(^DHCPHORDM(phomdr,"I",sub),"^",3)
	.s index=grpno_","_reasondr
	.s ^TMP("dhcpha","DHCSTPIVAOUTAUDIT","GetOrdItmAuditItmLog","Rea",pid,grpno,index)=""
	.s ^TMP("dhcpha","DHCSTPIVAOUTAUDIT","GetOrdItmAuditItmLog","Itm",pid,grpno,orditm)=""
	
	
	s grpno=""
	f  s grpno=$o(^TMP("dhcpha","DHCSTPIVAOUTAUDIT","GetOrdItmAuditItmLog","Rea",pid,grpno)) q:grpno=""  d
	.s index=""
	.f  s index=$o(^TMP("dhcpha","DHCSTPIVAOUTAUDIT","GetOrdItmAuditItmLog","Rea",pid,grpno,index)) q:index=""  d
	..s reason=""
	..s reasondr=$p(index,",",2)
	..i reasondr'="" s reason=$p(^DHCPCREASON(reasondr),"^",2)
	..s itmdesc=reason
	..s h=h+1
	..s data=grpno_"^"_itmdesc
	..s ^TMP("dhcpha","DHCSTPIVAOUTAUDIT","GetOrdItmAuditItmLog",pid,h)=data
	.s orditm=""
	.f  s orditm=$o(^TMP("dhcpha","DHCSTPIVAOUTAUDIT","GetOrdItmAuditItmLog","Itm",pid,grpno,orditm)) q:orditm=""  d
	..s ord=$p(orditm,"||",1)
	..s ordchl=$p(orditm,"||",2)
	..s arcimid=$p(^OEORD(ord,"I",ordchl,1),"^",2)  ;医嘱 ARC_ItmMast ARCIM_RowId
	..s itmmastid=$p(arcimid,"||",1)
	..s itmmastver=$p(arcimid,"||",2)
	..s inci=$o(^INCI(0,"ARCIM_DR",$p(arcimid,"||",1),"") ) q:inci=""  //医嘱名称
	..s inciDesc=$p(^INCI(inci,1),"^",2) //药品名称
	..i grpno'="-" s itmdesc="_____"_inciDesc
	..e  s itmdesc=inciDesc
	..s h=h+1
	..s data=grpno_"^"_itmdesc
	..s ^TMP("dhcpha","DHCSTPIVAOUTAUDIT","GetOrdItmAuditItmLog",pid,h)=data
    
    q:h=0 ##class(web.DHCSTEXTCOMMON).GetNoJson()
	
 	s maxrow=h
 	i endpage>maxrow s endpage=maxrow
 
    s count=0
    s h=""
    f  s h=$o(^TMP("dhcpha","DHCSTPIVAOUTAUDIT","GetOrdItmAuditItmLog",pid,h)) q:h=""  d
    .s data=^TMP("dhcpha","DHCSTPIVAOUTAUDIT","GetOrdItmAuditItmLog",pid,h)
    .s grpno=$p(data,"^",1)
    .s itmdesc=$p(data,"^",2)
    .
    .s count=count+1
    .q:count<stpage
    .q:count>endpage
    .
    .s grpno=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("grpno",grpno)
	.s itmdesc=##class(web.DHCSTEXTCOMMON).GetJsonLastCell("itmdesc",itmdesc)
	.
	.s tmpstr=grpno_itmdesc
	.
    .s startString=##class(web.DHCSTEXTCOMMON).GetJsonStartString(maxrow)
    .s firstrow=##class(web.DHCSTEXTCOMMON).GetJsonFirstRow(tmpstr)
    .s lastrow=##class(web.DHCSTEXTCOMMON).GetJsonLastRow(tmpstr)
	.
    .i count=stpage w startString
    .i count<endpage w firstrow
    .i count=endpage w lastrow
	.
	k ^TMP("dhcpha","DHCSTPIVAOUTAUDIT","GetOrdItmAuditItmLog",pid)
	k ^TMP("dhcpha","DHCSTPIVAOUTAUDIT","GetOrdItmAuditItmLog","Rea",pid)
	k ^TMP("dhcpha","DHCSTPIVAOUTAUDIT","GetOrdItmAuditItmLog","Index",pid)
	k ^TMP("dhcpha","DHCSTPIVAOUTAUDIT","GetOrdItmAuditItmLog","Itm",pid)

    q ""
}

/// 撤消审核结果
ClassMethod CancelOrdAudit(Input) As %String
{
	s pid=##class(web.DHCSTPIVAOUTCOMMON).GetPIVAOUTPID()
	s user=$p(Input,"^",1)
	s ordmr=$p(Input,"^",2)
	s currdate=+$h
	s currtime=$p($h,",",2)
	//
	s result=$p(^DHCPHORDM(ordmr),"^",2)
	q:result="" -99
	s chkflag=0
	s sub=""
 	F  S sub=$O(^DHCPHORDM(ordmr,"I",sub)) Q:sub=""  d
	.s prescno=$p(^DHCPHORDM(ordmr,"I",sub),"^",4)
	.s phordm=$o(^DHCPHORDM(0,"PrescNo",prescno,""),-1)
	.q:phordm'=ordmr  //不是最后一次日志,不能撤消
	.s ^TMP("dhcpha","DHCSTPIVAOUTAUDIT","CancelOrdAudit",pid,"PrescNo",prescno)=""  //有可能上次拒绝中,问题列表含多个处方药品,所以要以处方号整理撤消
	
	q:'$d(^TMP("dhcpha","DHCSTPIVAOUTAUDIT","CancelOrdAudit",pid,"PrescNo")) -98
	
	s err=0
	tstart
	
	k PLIST
	s PLIST(2)=user
	s PLIST(4)=currdate
	s PLIST(5)=currtime
	&sql(INSERT INTO DHC_PHAORDMONITOR  VALUES :PLIST())
	i SQLCODE'=0 s err=-96
	q:err'=0 err
	s phaomr=+%ROWID
	
	s prescno=""
	f  s prescno=$o(^TMP("dhcpha","DHCSTPIVAOUTAUDIT","CancelOrdAudit",pid,"PrescNo",prescno)) q:(prescno="")||(err'=0)  d
	.s ord=""
	.f  s ord=$o(^OEORD(0,"PrescNo",prescno,ord))  q:(ord="")||(err'=0)  d
	..s chl=""
    ..f  s chl=$o(^OEORD(0,"PrescNo",prescno,ord,chl)) q:(chl="")||(err'=0)  d
    ...s orditem=ord_"||"_chl
    ...s auditflag=$p(^OEORD(ord,"I",chl,7),"^",3)
    ...//q:auditflag'=""
    ...s statdr=$p(^OEORD(ord,"I",chl,1),"^",13)
	...s oeflag=$p(^OEC("OSTAT",statdr),"^",1) 
	...q:(oeflag'="V")&(oeflag'="E")
	...s priordr=$p(^OEORD(ord,"I",chl,1),"^",8) 
    ...q:priordr="" 
    ...s priority=$p(^OECPR(priordr),"^",1) 			;医嘱优先级代码              
	...s $p(^OEORD(ord,"I",chl,7),"^",3)=""
	...s dsp=""
	...f  s dsp=$o(^DHCOEDISQTY(0,"OEORI",orditem,dsp)) q:(dsp="")||(err'=0)  d
	....i $d(^PIVA(0,"OEGRP",dsp)) d   //已打签不允许撤消
	.....s err=-97
	....q:err'=0
	.q:err'=0
	.//
	.//
	.k PLIST
	.s PLIST(0)=phaomr
	.s PLIST(3)=1
	.s PLIST(5)=+$o(^DHCPHORDM(phaomr,"I",""),-1)+1
	.s PLIST(6)=prescno
	.&sql(INSERT INTO DHC_PHAORDMONITORLIST  VALUES :PLIST())
	.i SQLCODE'=0  s err=-95
	.q:err'=0
	.
	
	i err'=0 tro 
	k ^TMP("dhcpha","DHCSTPIVAOUTAUDIT","CancelOrdAudit",pid)
	q:err'=0 err	
	tcommit	

	q 0
}

ClassMethod tt() As %String
{
	s mrowid=""
	f  s mrowid=$o(^DHCPHORDM(mrowid)) q:mrowid=""  d
	.s oeori=$p(^DHCPHORDM(mrowid),"^",5)
	.k PLIST
	.s PLIST(0)=mrowid
	.s PLIST(3)=1
	.s PLIST(5)=+$o(^DHCPHORDM(mrowid,"I",""),-1)+1
	.s PLIST(2)=oeori
	.&sql(INSERT INTO DHC_PHAORDMONITORLIST  VALUES :PLIST())
	. 
	q 0
}

}
