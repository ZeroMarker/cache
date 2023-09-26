Import sqluser

/// 门诊配液瓶签打印
Class web.DHCSTPIVAOUTPRTLABEL Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// 查询配液打瓶签明细	
/// Creator:LiangQiang
/// CreatDate:2013-05-27
/// Input:登记号,开始行,限制行,参数串
/// Output:明细
ClassMethod FindReqPrtDetail(RegNo, StPage, Limit, Input) As %String
{
	
	S cnumber=10  /// 10固定为打签状态
	s pid=##class(web.DHCSTPIVAOUTCOMMON).GetPIVAOUTPID()
	s stdate=$p(Input,"^",1)
	s stdate=$zdh(stdate,4)
	s enddate=$p(Input,"^",2)
	s enddate=$zdh(enddate,4)
    s phalocdr=$p(Input,"^",3)
    s patID=$p(Input,"^",4)
    s type="O"

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
	..s dodis=$p(^PIVADIS(pdis),"^",2)
	..s prescno=$p(^OEORD(ord,"I",chl,1),"^",14) 
	..q:prescno="" 
	..s adtinfo=##class(web.DHCSTPIVAOUTCOMMON).GetAdtResultInfo(oeori)
	..s adtresult=$p(adtinfo,"^",4)
	..q:adtresult'="审核通过"  //过滤审核不通过
	..S nextnumber=cnumber
 	..S specstate=""
 	..S pogi=##class(web.DHCSTPIVAOUTCOMMON).GetOGrpI(dodis)
 	..I pogi'="" D
 	...S psdr=$P(^PIVA(+pogi),"^",6)
 	...S nextstr=##class(web.DHCSTPIVAOUTCOMMON).GetNextStat(psdr,phalocdr,type)	 ///下一个状态
 	...S nextnumber=$P(nextstr,"^",2)
 	...S specstate=$P(^PIVA(+pogi),"^",8)
 	..Q:nextnumber'=cnumber
	..s adm=$p(^OEORD(ord),"^",1)
    ..s papmidr=$p(^PAADM(adm),"^",1)
    ..s patno=$p(^PAPER(papmidr,"PAT",1),"^",2)
    ..q:(RegNo'="")&(patno'=RegNo)
    ..s orddate=$p(^DHCOEDISQTY(dodis),"^",21)
    ..s ordtime=$p(^DHCOEDISQTY(dodis),"^",20)
    ..s grpno=$p(^DHCOEDISQTY(dodis),"^",4)
    ..s seqno=$P(^OEORD(ord,"I",chl,3),"^",4)
    ..s mainindex=prescno_"^"_grpno
    ..i $p(^PIVADIS(pdis),"^",7)'="REC" s ^TMP("dhcpha","DHCSTPIVAOUTRECDRUG","FindReqPrtDetail","Rec",pid,mainindex)=""
    ..s index=papmidr_"^"_adm_"^"_orddate_"^"_ordtime_"^"_grpno_"^"_oeori_"^"_seqno
    ..s index2=dodis
    ..s ^TMP("dhcpha","DHCSTPIVAOUTRECDRUG",pid,"index",index,index2)=""

    s index=""
    f  s index=$o(^TMP("dhcpha","DHCSTPIVAOUTRECDRUG",pid,"index",index)) q:index=""  d
    .s adm=$p(index,"^",2)
    .s oeori=$p(index,"^",6)
   	.s ord=$p(oeori,"||",1)
	.s chl=$p(oeori,"||",2)
	.s prescno=$p(^OEORD(ord,"I",chl,1),"^",14)
    .s priordr=$p(^OEORD(ord,"I",chl,1),"^",8) 
    .q:priordr="" 
    .s tmpgrpno=$p(index,"^",5)
    .s mainindex=prescno_"^"_tmpgrpno
    .q:$d(^TMP("dhcpha","DHCSTPIVAOUTRECDRUG","FindReqPrtDetail","Rec",pid,mainindex))
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
	.s qty=0
	.s index2=""
    .f  s index2=$o(^TMP("dhcpha","DHCSTPIVAOUTRECDRUG",pid,"index",index,index2)) q:index2=""  d
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
    ..i (qty#fac)=0 d
	...s qty=qty/fac   //数量
	...s uomdr=puomdr 
	..s uomdesc=$p($g(^CT("UOM",uomdr)),"^",2) //单位
	..s selectflag=mdodis   //1
	..s packflag=##class(web.DHCSTPIVAOUTCOMMON).GetPackFlag(dodis) //打包标志 bianshuai
	..s omflag=##class(web.DHCSTPIVAOUTCOMMON).GetOMFlag(dodis) //自备药
	..s h=h+1
	..s tmpindex=prescno_"||"_orddatetime //_"||"_mdodis
	..s prescnoT=prescno
	..i $D(^TMP("dhcpha","DHCSTPIVAOUTPRTLABEL","FindReqPrtDetail","PrescNo","mdodis",pid,mdodis)) d
    ...s selectflag=""
    ..e  d
    ...s ^TMP("dhcpha","DHCSTPIVAOUTPRTLABEL","FindReqPrtDetail","PrescNo","mdodis",pid,mdodis)=""
    ..
    ..i $D(^TMP("dhcpha","DHCSTPIVAOUTPRTLABEL","FindReqPrtDetail","PrescNo",pid,tmpindex)) d
    ...s orddatetime=""
    ...s prescno=""
    ...s patno="",patname=""
    ..e  d
    ...s ^TMP("dhcpha","DHCSTPIVAOUTPRTLABEL","FindReqPrtDetail","PrescNo",pid,tmpindex)=""
	..s data=inciDesc_"^"_qty_"^"_uomdesc_"^"_dosage_doseuom_"^"_freq_"^"_spec_"^"_instru_"^"_duration_"^"_form
    ..s data=data_"^"_priorty_"^"_doctor_"^"_orddatetime_"^"_remark_"^"_"^"_oeori_"^"_prescno_"^"_selectflag
    ..s data=data_"^"_patno_"^"_patname_"^"_dodis_"^"_packflag_"^"_omflag_"^"_prescnoT
    ..s ^TMP("dhcpha","DHCSTPIVAOUTPRTLABEL","FindReqPrtDetail",pid,"Itm",prescnoT,mdodis,h)=data
    k ^TMP("dhcpha","DHCSTPIVAOUTRECDRUG","FindReqPrtDetail","Rec",pid)
	q:h=0 ##class(web.DHCSTEXTCOMMON).GetNoJson()
    s maxrow=h
    i endpage>maxrow s endpage=maxrow
    s count=0
    s prescnox=""
    f  s prescnox=$o(^TMP("dhcpha","DHCSTPIVAOUTPRTLABEL","FindReqPrtDetail",pid,"Itm",prescnox)) q:prescnox=""  d
    .s mdodis=""
    .f  s mdodis=$o(^TMP("dhcpha","DHCSTPIVAOUTPRTLABEL","FindReqPrtDetail",pid,"Itm",prescnox,mdodis)) q:mdodis=""  d
    ..s h=""
    ..f  s h=$o(^TMP("dhcpha","DHCSTPIVAOUTPRTLABEL","FindReqPrtDetail",pid,"Itm",prescnox,mdodis,h)) q:h=""  d
    ...s data=^TMP("dhcpha","DHCSTPIVAOUTPRTLABEL","FindReqPrtDetail",pid,"Itm",prescnox,mdodis,h)
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
    ...s packflag=$p(data,"^",21)
    ...s omflag=$p(data,"^",22)
    ...s prescnoT=$p(data,"^",23)
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
	...s packflag=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("packflag",packflag)
	...s omflag=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("omflag",omflag)
	...s dsprowid=##class(web.DHCSTEXTCOMMON).GetJsonLastCell("dsprowid",dsprowid)
	...
	...s tmpstr=incidesc_qty_uomdesc_dosage_freq_spec_instruc_dura_form_pri_doctor_orddate_remark_orditm_prescno_prescnoT_selectflag
	...s tmpstr=tmpstr_patno_patname_packflag_omflag_dsprowid
	...
    ...s startString=##class(web.DHCSTEXTCOMMON).GetJsonStartString(maxrow)
    ...s firstrow=##class(web.DHCSTEXTCOMMON).GetJsonFirstRow(tmpstr)
    ...s lastrow=##class(web.DHCSTEXTCOMMON).GetJsonLastRow(tmpstr)
	...
    ...
    ...i count=stpage w startString
    ...i count<endpage w firstrow
    ...i count=endpage w lastrow
    
    
    k ^TMP("dhcpha","DHCSTPIVAOUTPRTLABEL","FindReqPrtDetail",pid)
    q ""
}

/// 保存配液打瓶签明细	
/// Creator:LiangQiang
/// CreatDate:2013-05-29
/// Input:dsp串,人员ID
/// Output:0
ClassMethod SavePrtLabelData(printno, dspstr, puser, pno) As %String
{
    s dodis=$p(dspstr,",",1)
    s oeori=$p(^DHCOEDISQTY(dodis),"^",1)
    s stdate=$p(^DHCOEDISQTY(dodis),"^",21)
    s sttime=$p(^DHCOEDISQTY(dodis),"^",20)
    s moeori=##class(web.DHCSTPIVAOUTCOMMON).GetMainOeori(oeori)
    s ord=$p(moeori,"||",1)
    s itm=$p(moeori,"||",2)
    s ploc=$p(^OEORD(ord,"I",itm,3),"^",6)
    s grpno=$p(^DHCOEDISQTY(dodis),"^",4)
	S PSNumber="10"
	s cnt=$l(dspstr,",")
	//S dispconfig=##class(web.DHCSTPIVA).GetPSNumberProByLoc(ploc,PSNumber)
	
	
	L +^DHCSTLOCK("PIVA",stdate,moeori,grpno):5  E  Q -100
	TSTART
	I printno="" S printno=..GetDispNo(ploc)
	S pharowid=""
	S quitflag=0
	S dodis=""
	F i=1:1:cnt  D
	.S dodis=$p(dspstr,",",i)
	.S grpno=$p(^DHCOEDISQTY(dodis),"^",4)
	.S moedisp=##class(web.DHCSTPIVA).GetMainOEDispID(dodis,grpno)
	.S batno=""
	.S pogid=..GetOrdGrpID(moedisp,grpno)
	.I pogid="" D
	..S pogid=..InsOrdGrp(ploc,moedisp,grpno,batno,stdate,sttime,pharowid,pno,puser,printno)
	.E  D
	..S pogid=..UpdOrdGrp(pogid,ploc,batno,stdate,sttime,pharowid,pno,puser,printno)
	.I +pogid<0 S quitflag=-1
	.Q:quitflag'=0
	./// 保存医嘱组子表
	.S pogiid=..InsOrdGrpItm(pogid,dodis)
	.I +pogiid<0 S quitflag=-2
	.Q:quitflag'=0
	.
	///  根据配置,即刻配液,减库存
	//i (dispconfig="Y")&(quitflag=0) S quitflag=##class(web.DHCSTPIVARECHECK).SaveCheckOK(pid,pogid,PSNumber)
	
	I quitflag'=0 TROLLBACK
	I quitflag'=0 L -^DHCSTLOCK("PIVA",stdate,moeori,grpno)
	I quitflag'=0 Q -3
	TCOMMIT
	
	L -^DHCSTLOCK("PIVA",stdate,moeori,grpno)
 	Q pogid_"^"_printno
}

ClassMethod GetDispNo(phaloc As %String) As %String
{
    /*
	S phalocset=$O(^DHCPL(0,"Loc",phaloc,""))
	Q:phalocset="" ""
	L +^DHCPL(phalocset):3
	S prefix=$P(^DHCPL(phalocset),"^",13)   
	S finaldate=$P(^DHCPL(phalocset),"^",15)   
	S countnum=$P(^DHCPL(phalocset),"^",12) 	
	I finaldate'=+$h d
	.s $P(^DHCPL(phalocset),"^",15)=+$h
	.s countnum=0
	S finaldate=$P(^DHCPL(phalocset),"^",15) 
	S countnum=countnum+1
	S $P(^DHCPL(phalocset),"^",12)=+countnum
	*/
	S prefix="10"
	S finaldate=+$h
	S countnum=$I(^TMP("GetDispNo",phaloc))
	S dispno=prefix_$E($ZD(finaldate,8),3,8)_$tr($j(countnum,4)," ","0")
	Q dispno
}

/// 取PIVA_OrdGrp对应记录RowID
ClassMethod GetOrdGrpID(moeori As %String, grpno As %String) As %String
{

	Q:moeori="" ""
	Q:grpno="" ""
	Q $O(^PIVA(0,"OEGRP",moeori,grpno,""))
}

ClassMethod InsOrdGrp(ploc As %String, moedisp As %String, grpno As %String, batno As %String, stdate As %String, sttime As %String, pharowid As %String, pno As %String, puser As %String, printno As %String) As %String
{

	K PLIST
	S PLIST(2)=moedisp  //关联dhc_oedispensing
	S PLIST(3)=grpno
	S PLIST(4)=batno
	S PLIST(5)=stdate
	S PLIST(6)=sttime
	S PLIST(7)=##class(web.DHCSTPIVAOUTCOMMON).GetCurrPSDrByNum(10,ploc,"O") /// 10固定为打签的顺序号
	S PLIST(8)=ploc
	S PLIST(9)="N"
	S PLIST(11)=pharowid
	S PLIST(12)=pno
	S PLIST(17)=printno_pno
	&SQL(Insert Into PIVA_OrdGrp Values :PLIST())
	Q:SQLCODE'=0 -99999
 	S pogid=$P(%ROWID,$C(1))
 	/// 保存医嘱组执行状态表
	S pogsid=..InsOrdGrpState(pogid,puser,printno)
	Q:+pogsid<0 -1
	Q pogid
}

ClassMethod InsOrdGrpState(parref As %String, user As %String, printno) As %String
{

	Q:parref="" -1
	Q:user="" -2
	s phalocdr=$p(^PIVA(parref),"^",7)
	S psdr=##class(web.DHCSTPIVAOUTCOMMON).GetCurrPSDrByNum(10,phalocdr,"O") /// 10固定为打签的顺序号
	Q:psdr="" -3
	K PLIST
	S PLIST(0)=parref
	S PLIST(2)=$O(^PIVA(parref,"S",""),-1)+1
	S PLIST(3)=psdr
	S PLIST(4)=user
	S PLIST(5)=+$H
	S PLIST(6)=$P($H,",",2)
	S PLIST(7)=phalocdr
	S PLIST(8)=printno
	&SQL(Insert Into PIVA_OrdGrpState Values :PLIST())
	Q:SQLCODE'=0 -99999
 	Q $P(%ROWID,$C(1))
}

ClassMethod GetOrdGrpItmID(parref As %String, dodis As %String) As %String
{

	Q:parref="" ""
	Q:dodis="" ""
	S sub=$O(^PIVA(0,"DSP",dodis,parref,""))
	Q:sub="" ""
	Q parref_"||"_sub
}

ClassMethod InsOrdGrpItm(parref As %String, dodis As %String) As %String
{

	Q:parref="" -1
	Q:dodis="" -2
	S pogi=..GetOrdGrpItmID(parref,dodis)
	;Q:pogi'="" pogi
	Q:pogi'="" -3
	K PLIST
	S PLIST(0)=parref
	S PLIST(2)=$O(^PIVA(parref,"I",""),-1)+1
	S PLIST(3)=dodis
	&SQL(Insert Into PIVA_OrdGrpItm Values :PLIST())
	Q:SQLCODE'=0 -99999
 	Q $P(%ROWID,$C(1))
}

ClassMethod UpdOrdGrp(pogid As %String, ploc As %String, batno As %String, stdate As %String, sttime As %String, pharowid As %String, pno As %String, puser As %String, printno As %String) As %String
{

	Q:..ChkPogState(pogid)=1 pogid
	K PLIST
	&SQL(Select * Into :PLIST() From PIVA_OrdGrp Where POG_RowId=:pogid)
	S PLIST(4)=batno
	S PLIST(5)=stdate
	S PLIST(6)=sttime
	S PLIST(7)=##class(web.DHCSTPIVAOUTCOMMON).GetCurrPSDrByNum(10,ploc,"O") /// 10固定为打签的顺序号
	S PLIST(8)=ploc
	S PLIST(9)="N"
	S PLIST(11)=pharowid
	S PLIST(12)=pno
	S PLIST(18)=printno_pno
	&SQL(Update PIVA_OrdGrp Values :PLIST() Where POG_RowId=:pogid)
	Q:SQLCODE'=0 -99999
 	S pogid=$P(%ROWID,$C(1))
 	/// 保存医嘱组执行状态表3
	S pogsid=..InsOrdGrpState(pogid,puser,printno)
	Q:+pogsid<0 -1
	Q pogid
}

/// 判断配液状态是否合法 1 -非法 0 -合法
ClassMethod ChkPogState(pog As %String) As %String
{
	S type="O"
	S cnumber="10"
	S psdr=$P(^PIVA(+pog),"^",6)
	S plocdr=$P(^PIVA(+pog),"^",7)
 	S nextstr=##class(web.DHCSTPIVAOUTCOMMON).GetNextStat(psdr,plocdr,type)	 ///下一个状态
 	S nextnumber=$P(nextstr,"^",2)
 	S specstate=$P(^PIVA(+pog),"^",8)
 	Q:nextnumber'=cnumber 1
 	Q 0
}

/// 自动查询保存配液打瓶签明细	
/// Creator:LiangQiang
/// CreatDate:2013-05-30
/// Input:登记号,开始行,限制行,参数串,用户ID
/// Return:Rowid串
ClassMethod AutoFindPrtLabelData(Input, User) As %String
{

	s pid=##class(web.DHCSTPIVAOUTCOMMON).GetPIVAOUTPID()
	s stdate=$p(Input,"^",1)
	s stdate=$zdh(stdate,4)
	s enddate=$p(Input,"^",2)
	s enddate=$zdh(enddate,4)
    s phalocdr=$p(Input,"^",3)

	s h=0
	f date=stdate:1:enddate  d
	.s pdis=""
	.f  s pdis=$o(^PIVADIS(0,"Date",phalocdr,date,pdis)) q:pdis=""  d
	..s oeori=$p(^PIVADIS(pdis),"^",1)
	..s ord=$p(oeori,"||",1)
	..s chl=$p(oeori,"||",2)
	..q:'$d(^OEORD(ord,"I",chl))
	..s dodis=$p(^PIVADIS(pdis),"^",2)
	..s prescno=$p(^OEORD(ord,"I",chl,1),"^",14) 
	..q:prescno=""
	..s adtinfo=##class(web.DHCSTPIVAOUTCOMMON).GetAdtResultInfo(oeori)
	..s adtresult=$p(adtinfo,"^",4)
	..q:adtresult'="审核通过"  //过滤审核不通过
	..s adm=$p(^OEORD(ord),"^",1)
    ..s papmidr=$p(^PAADM(adm),"^",1)
    ..s orddate=$p(^DHCOEDISQTY(dodis),"^",21)
    ..s ordtime=$p(^DHCOEDISQTY(dodis),"^",20)
    ..s grpno=$p(^DHCOEDISQTY(dodis),"^",4)
    ..s seqno=$P(^OEORD(ord,"I",chl,3),"^",4)
    ..//s index=papmidr_"^"_adm_"^"_orddate_"^"_ordtime_"^"_grpno_"^"_seqno_"^"_oeori
    ..s index=papmidr_"^"_adm_"^"_orddate_"^"_ordtime_"^"_grpno_"^"_prescno
    ..s index2=dodis
    ..s h=h+1
    ..s ^TMP("dhcpha","DHCSTPIVAOUTPRTLABEL","AutoSavePrtData",pid,"index",index,index2)=""
    q:h=0 ""
    //保存
    s h=0
    s retstr="",printno=""
    s index=""
    f  s index=$o(^TMP("dhcpha","DHCSTPIVAOUTPRTLABEL","AutoSavePrtData",pid,"index",index)) q:index=""  d
    .s index2="",dspstr="",h=h+1
    .f  s index2=$o(^TMP("dhcpha","DHCSTPIVAOUTPRTLABEL","AutoSavePrtData",pid,"index",index,index2)) q:index2=""  d
    ..s dsp=$p(index2,"^",1)
    ..i dspstr="" d
    ...s dspstr=dsp
    ..e  d
    ...s dspstr=dspstr_","_dsp
    .s ret=..SavePrtLabelData(printno,dspstr,User,h)
    .s retid=+$p(ret,"^",1)
    .s printno=$p(ret,"^",2)
    .i retid>0 d
    ..i retstr="" d
    ...s retstr=retid
    ..e  d
    ...s retstr=retstr_"^"_retid
    k ^TMP("dhcpha","DHCSTPIVAOUTPRTLABEL","AutoSavePrtData",pid)
    q retstr
}

/// 取标签主信息
ClassMethod GetPrintPog(pog As %String) As %String
{
	S moedisp=$P(^PIVA(pog),"^",1)
	S moeori=$P(^DHCOEDISQTY(moedisp),"^",1) /// 主医嘱ID
	S adm=$P(^OEORD(+moeori),"^",1)
    s info=##class(web.DHCSTPIVAOUTCOMMON).GetAdmBasicInfo(adm)
    s patno=$p(info,"^",1)
    s patname=$p(info,"^",2)
    s patage=$p(info,"^",3)
    s patsex=$p(info,"^",4)
    S grpno=$P(^PIVA(pog),"^",2)
    s grpno="第"_grpno_"次"
    //s barcode=$P(^PIVA(pog),"^",17)
    s orddata=$zd($P(^PIVA(pog),"^",4),3)    //用药日期by hw
    s OrdExecRowid=$p(^DHCOEDISQTY(moedisp),"^",3)
    s barcode=$REPLACE(OrdExecRowid,"||","-")
	S retstr=pog_"^"_moeori_"^"_adm_"^"_patno_"^"_patname_"^"_patsex_"^"_patage_"^"_grpno_"^"_barcode_"^"_orddata
	Q retstr
}

/// 取标签明细信息
ClassMethod GetPrintPogItm(pog As %String) As %String
{
	S pogsub="0",pogistr=""
	F  S pogsub=$O(^PIVA(pog,"I",pogsub)) Q:(pogsub="")||(pogsub="0")  D
	.S dsp=$P(^PIVA(pog,"I",pogsub),"^",1)
	.Q:'$D(^DHCOEDISQTY(dsp))
	.S oeori=$P(^DHCOEDISQTY(dsp),"^",1) Q:oeori=""
	.S incitm=##class(web.DHCSTPIVAOUTCOMMON).GetIncItm(oeori)
 	.S inci=$P(incitm,"^",1)
 	.S incidesc=$P(incitm,"^",3)
	.S spec=##class(web.DHCSTPIVAOUTCOMMON).GetSpec(inci)
	.S dosage=##class(web.DHCSTPIVAOUTCOMMON).GetDosage(oeori)
	.S dosageml=##class(web.DHCSTPIVAOUTCOMMON).GetDosageML(oeori)
	.i dosageml'="" s dosage=dosageml
	.S sign=##class(web.DHCSTPIVAOUTCOMMON).GetPrintSign(oeori)
	.S incidesc=sign_incidesc
	.S comp=##class(web.DHCSTPIVAOUTCOMMON).GetCompFlag(oeori)	/// 剂量是否整包装
	.S BuomQtyStr=##Class(web.DHCSTPIVAOUTCOMMON).GetDosageBUom(oeori)
	.S BQty=$P(BuomQtyStr,"^",1)
	.S BUom=$P(BuomQtyStr,"^",2)
    .S pri=##class(web.DHCSTPIVAOUTCOMMON).GetOePriority(oeori)
	.S pricode=$P(pri,"^",2)
	.S pricode=$ZCVT(pricode,"U")
	.i pricode["OM" s pricode="[自备]"
	.e  s pricode=""
	.I pogistr="" S pogistr=incidesc_"^"_dosage_"^"_spec_"^"_comp_"^"_BQty_"^"_BUom_"^"_pricode
	.E  S pogistr=pogistr_"||"_incidesc_"^"_dosage_"^"_spec_"^"_comp_"^"_BQty_"^"_BUom_"^"_pricode
	Q pogistr
}

ClassMethod GetPrintDetail(pog As %String) As %String
{
    s retstr=""
	S moedisp=$P(^PIVA(pog),"^",1)
	S moeori=$P(^DHCOEDISQTY(moedisp),"^",1)
	S instruc=##class(web.DHCSTPIVA).GetInstruc(moeori)	/// 用法
	S adm=$P(^OEORD(+moeori),"^",1)
    s info=##class(web.DHCSTPIVAOUTCOMMON).GetAdmBasicInfo(adm)
    s patno=$p(info,"^",1)
    s patname=$p(info,"^",2)
	S doctor=##class(web.DHCSTPIVAOUTCOMMON).GetDoctor(moeori)	/// 医生
	S odate=$P(^PIVA(pog),"^",4)
	S:odate'="" odate=$ZD(odate,3)
	S otime=$P(^PIVA(pog),"^",5)
	S:otime'="" otime=$ZT(otime,1)
	S dt=odate
	S freq=##class(web.DHCSTPIVAOUTCOMMON).GetFreq(moeori)	/// 频率
	S freq=$P(freq,"^",5)
	S pogsub=""
	F  S pogsub=$O(^PIVA(pog,"I",pogsub)) Q:pogsub=""  D
	.S dsp=$P(^PIVA(pog,"I",pogsub),"^",1)
	.Q:'$D(^DHCOEDISQTY(dsp))
	.S oeori=$P(^DHCOEDISQTY(dsp),"^",1) Q:oeori=""
	.s ord=$p(oeori,"||",1)
	.s chl=$p(oeori,"||",2)
	.q:'$d(^OEORD(ord,"I",chl))
	.S incitm=##class(web.DHCSTPIVAOUTCOMMON).GetIncItm(oeori)
 	.S inci=$P(incitm,"^",1)
 	.S incidesc=$P(incitm,"^",3)
	.S spec=##class(web.DHCSTPIVAOUTCOMMON).GetSpec(inci)
	.S dosage=##class(web.DHCSTPIVAOUTCOMMON).GetDosage(oeori)
	.S dosageml=##class(web.DHCSTPIVAOUTCOMMON).GetDosageML(oeori)
	.i dosageml'="" s dosage=dosageml
	.s prescno=$p(^OEORD(ord,"I",chl,1),"^",14)
	.s arcimid=$p(^OEORD(ord,"I",chl,1),"^",2)  ;医嘱 ARC_ItmMast ARCIM_RowId
	.s itmmastid=$p(arcimid,"||",1)
	.s itmmastver=$p(arcimid,"||",2)
	.s inci=$o(^INCI(0,"ARCIM_DR",$p(arcimid,"||",1),"") ) q:inci=""  //医嘱名称
	.s inciDesc=$p(^INCI(inci,1),"^",2) //药品名称
	.s puomdr=$p(^ARCIM(itmmastid,itmmastver,8),"^",14)
	.s buomdr=+$p(^INCI(inci,1),"^",10)
	.s fac=+##Class(web.DHCSTCOMMONSRV).UOMFac(puomdr,buomdr)
	.s uomdr=buomdr 
	.s qty=$P(^DHCOEDISQTY(dsp),"^",11)
	.i (qty#fac)=0 d
	..s qty=qty/fac   //数量
	..s uomdr=puomdr 
	.s uomdesc=$p($g(^CT("UOM",uomdr)),"^",2) //单位
	.s qty=qty_uomdesc
	.
	.s retdata=patname_"^"_patno_"^"_dt_"^"_incidesc_"^"_dosage_"^"_doctor_"^"_freq_"^"_prescno_"^"_qty
	.i retstr="" d
	..S retstr=retdata
	.e  d
	..S retstr=retstr_"||"_retdata
	q retstr
}

}
