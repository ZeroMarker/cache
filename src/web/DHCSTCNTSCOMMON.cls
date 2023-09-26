Import sqluser

Class web.DHCSTCNTSCOMMON Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// 统一取最大进程号
ClassMethod GetPHCNTSPID() As %String
{
   s pid=$I(^DHCSTCOMMENTS("prescno"))
   q pid
}

/// 获取药学大类列表
ClassMethod GetPhcCatDs() As %String
{
	s pid=##class(web.DHCSTCNTSCOMMON).GetPHCNTSPID()
	s h=0
	s phccr=""
	f  s phccr=$o(^PHCC(phccr)) q:phccr=""  d
	.q:+phccr=0
	.s phccatdesc=$p(^PHCC(phccr),"^",2)
	.s h=h+1
    .s data=phccatdesc_"^"_phccr
    .s ^TMP("dhcpha","DHCSTCNTSCOMMON","GetPhcCatDs",pid,h)=data
    q:h=0 ##class(web.DHCSTEXTCOMMON).GetNoJson()
    s maxrow=h
    
    s count=0
    s h=""
    f  s h=$o(^TMP("dhcpha","DHCSTCNTSCOMMON","GetPhcCatDs",pid,h)) q:h=""  d
    .s data=^TMP("dhcpha","DHCSTCNTSCOMMON","GetPhcCatDs",pid,h)
    .s desc=$p(data,"^",1)
    .s rowid=$p(data,"^",2)
    .
    .s drugcatdesc=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("drugcatdesc",desc)
	.s drugcatrowid=##class(web.DHCSTEXTCOMMON).GetJsonLastCell("drugcatrowid",rowid)
	.
	.s tmpstr=drugcatdesc_drugcatrowid
    .s startString=##class(web.DHCSTEXTCOMMON).GetJsonStartString(maxrow)
    .s firstrow=##class(web.DHCSTEXTCOMMON).GetJsonFirstRow(tmpstr)
    .s lastrow=##class(web.DHCSTEXTCOMMON).GetJsonLastRow(tmpstr)
	.s count=count+1
	.i count=1 w startString
    .i count<maxrow w firstrow
    .i count=maxrow w lastrow
	.
	k ^TMP("dhcpha","DHCSTCNTSCOMMON","GetPhcCatDs",pid)
	q ""
}

/// 获取药学子类列表
ClassMethod GetPhcSubCatDs(catdr) As %String
{
	q:catdr="" ##class(web.DHCSTEXTCOMMON).GetNoJson()
	q:'$d(^PHCC(catdr,"SC")) ##class(web.DHCSTEXTCOMMON).GetNoJson()
	s pid=##class(web.DHCSTCNTSCOMMON).GetPHCNTSPID()
	s h=0
	s chl=0
	f  s chl=$o(^PHCC(catdr,"SC",chl) ) q:(chl="")||(chl=0)  d
	.s subdesc=$p(^PHCC(catdr,"SC",chl),"^",2)
	.s rowid=catdr_"||"_chl
	.s h=h+1
    .s data=subdesc_"^"_rowid
    .s ^TMP("dhcpha","DHCSTCNTSCOMMON","GetPhcSubCatDs",pid,h)=data
    q:h=0 ##class(web.DHCSTEXTCOMMON).GetNoJson()
    s maxrow=h
    
    s count=0
    s h=""
    f  s h=$o(^TMP("dhcpha","DHCSTCNTSCOMMON","GetPhcSubCatDs",pid,h)) q:h=""  d
    .s data=^TMP("dhcpha","DHCSTCNTSCOMMON","GetPhcSubCatDs",pid,h)
    .s desc=$p(data,"^",1)
    .s rowid=$p(data,"^",2)
    .
    .s drugsubcatdesc=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("drugsubcatdesc",desc)
	.s drugsubcatrowid=##class(web.DHCSTEXTCOMMON).GetJsonLastCell("drugsubcatrowid",rowid)
	.
	.s tmpstr=drugsubcatdesc_drugsubcatrowid
    .s startString=##class(web.DHCSTEXTCOMMON).GetJsonStartString(maxrow)
    .s firstrow=##class(web.DHCSTEXTCOMMON).GetJsonFirstRow(tmpstr)
    .s lastrow=##class(web.DHCSTEXTCOMMON).GetJsonLastRow(tmpstr)
	.s count=count+1
	.i count=1 w startString
    .i count<maxrow w firstrow
    .i count=maxrow w lastrow
	.
	k ^TMP("dhcpha","DHCSTCNTSCOMMON","GetPhcSubCatDs",pid)
	q ""
}

/// 获取药学子类列表
ClassMethod GetPhcMinCatDs(subcatdr) As %String
{
	s catdr=$p(subcatdr,"||",1)
	s subcatdr=$p(subcatdr,"||",2)
	q:(catdr="")||(subcatdr="") ##class(web.DHCSTEXTCOMMON).GetNoJson()
	q:'$d(^PHCC(catdr,"SC",subcatdr)) ##class(web.DHCSTEXTCOMMON).GetNoJson()
	s pid=##class(web.DHCSTCNTSCOMMON).GetPHCNTSPID()
	s h=0
	s minchl=0
	f  s minchl=$o(^PHCC(catdr,"SC",subcatdr,"MIN",minchl)) q:minchl=""  d
	.s mindesc=$p(^PHCC(catdr,"SC",subcatdr,"MIN",minchl),"^",2)
	.s rowid=catdr_"||"_subcatdr_"||"_minchl
	.s h=h+1
    .s data=mindesc_"^"_rowid
    .s ^TMP("dhcpha","DHCSTCNTSCOMMON","GetPhcMinCatDs",pid,h)=data
    q:h=0 ##class(web.DHCSTEXTCOMMON).GetNoJson()
    s maxrow=h
    
    s count=0
    s h=""
    f  s h=$o(^TMP("dhcpha","DHCSTCNTSCOMMON","GetPhcMinCatDs",pid,h)) q:h=""  d
    .s data=^TMP("dhcpha","DHCSTCNTSCOMMON","GetPhcMinCatDs",pid,h)
    .s desc=$p(data,"^",1)
    .s rowid=$p(data,"^",2)
    .
    .s drugmincatdesc=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("drugmincatdesc",desc)
	.s drugmincatrowid=##class(web.DHCSTEXTCOMMON).GetJsonLastCell("drugmincatrowid",rowid)
	.
	.s tmpstr=drugmincatdesc_drugmincatrowid
    .s startString=##class(web.DHCSTEXTCOMMON).GetJsonStartString(maxrow)
    .s firstrow=##class(web.DHCSTEXTCOMMON).GetJsonFirstRow(tmpstr)
    .s lastrow=##class(web.DHCSTEXTCOMMON).GetJsonLastRow(tmpstr)
	.s count=count+1
	.i count=1 w startString
    .i count<maxrow w firstrow
    .i count=maxrow w lastrow
	.
	k ^TMP("dhcpha","DHCSTCNTSCOMMON","GetPhcMinCatDs",pid)
	q ""
}

/// 获取病人费别列表,此处为社会地位
ClassMethod GetBillTypeDs() As %String
{
	s pid=##class(web.DHCSTCNTSCOMMON).GetPHCNTSPID()
	s h=0
	s billdr=0
	f  s billdr=$o(^CT("SS",billdr)) q:billdr=""  d
	.s billtyp=$p(^CT("SS",billdr),"^",2)
	.s h=h+1
    .s data=billtyp_"^"_billdr
    .s ^TMP("dhcpha","DHCSTCNTSCOMMON","GetBillTypeDs",pid,h)=data
    q:h=0 ##class(web.DHCSTEXTCOMMON).GetNoJson()
    s maxrow=h
    
    s count=0
    s h=""
    f  s h=$o(^TMP("dhcpha","DHCSTCNTSCOMMON","GetBillTypeDs",pid,h)) q:h=""  d
    .s data=^TMP("dhcpha","DHCSTCNTSCOMMON","GetBillTypeDs",pid,h)
    .s desc=$p(data,"^",1)
    .s rowid=$p(data,"^",2)
    .
    .s billdesc=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("billdesc",desc)
	.s billdr=##class(web.DHCSTEXTCOMMON).GetJsonLastCell("billdr",rowid)
	.
	.s tmpstr=billdesc_billdr
    .s startString=##class(web.DHCSTEXTCOMMON).GetJsonStartString(maxrow)
    .s firstrow=##class(web.DHCSTEXTCOMMON).GetJsonFirstRow(tmpstr)
    .s lastrow=##class(web.DHCSTEXTCOMMON).GetJsonLastRow(tmpstr)
	.s count=count+1
	.i count=1 w startString
    .i count<maxrow w firstrow
    .i count=maxrow w lastrow
	.
	k ^TMP("dhcpha","DHCSTCNTSCOMMON","GetBillTypeDs",pid)
	q ""
}

/// 获取药房列表
ClassMethod GetPhaLocDs(comboText = "", LogonHospId) As %String
{
	//s ^tmyq("GetPhaLocDs")=comboText
	s comboText=$zcvt(comboText,"U")
	s pid=##class(web.DHCSTCNTSCOMMON).GetPHCNTSPID()
	s h=0,NowDate=+$h
	s ctlocdr=""
	f  s ctlocdr=$o(^DHCPHLOCi("LOC",ctlocdr)) q:ctlocdr=""  d
	.s ctlocdesc=$p(^CTLOC(ctlocdr),"^",2)
	.s hospdr=$p(^CTLOC(ctlocdr),"^",22)
	.q:(hospdr'="")&(hospdr'=LogonHospId) ;过滤院区
	.s EndDate=$p(^CTLOC(ctlocdr),"^",25)
    .q:(EndDate'="")&(EndDate<NowDate) //lbb 2018/9/4 过滤截止日期小于当期日期
	.s ctlocconname=$zcvt($p(^CTLOC(ctlocdr),"^",43),"U") 
	.q:(comboText'="")&&($zcvt(ctlocdesc,"U")'[comboText)&&(ctlocconname'[comboText)
	.s h=h+1
    .s data=ctlocdesc_"^"_ctlocdr
    .s ^TMP("dhcpha","DHCSTCNTSCOMMON","GetPhaLocDs",pid,h)=data
    q:h=0 ##class(web.DHCSTEXTCOMMON).GetNoJson()
    s maxrow=h
    
    s count=0
    s h=""
    f  s h=$o(^TMP("dhcpha","DHCSTCNTSCOMMON","GetPhaLocDs",pid,h)) q:h=""  d
    .s data=^TMP("dhcpha","DHCSTCNTSCOMMON","GetPhaLocDs",pid,h)
    .s desc=$p(data,"^",1)
    .s rowid=$p(data,"^",2)
    .
    .s phalocdesc=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("phalocdesc",desc)
	.s phalocdr=##class(web.DHCSTEXTCOMMON).GetJsonLastCell("phalocdr",rowid)
	.
	.s tmpstr=phalocdesc_phalocdr
    .s startString=##class(web.DHCSTEXTCOMMON).GetJsonStartString(maxrow)
    .s firstrow=##class(web.DHCSTEXTCOMMON).GetJsonFirstRow(tmpstr)
    .s lastrow=##class(web.DHCSTEXTCOMMON).GetJsonLastRow(tmpstr)
	.s count=count+1
	.i count=1 w startString
    .i count<maxrow w firstrow
    .i count=maxrow w lastrow
	.
	k ^TMP("dhcpha","DHCSTCNTSCOMMON","GetPhaLocDs",pid)
	q ""
}

/// 获取药房列表
ClassMethod GetIPPhaLocDs(comboText = "", LogonHospId) As %String
{
	//s ^tmyq("GetPhaLocDs")=comboText
	s comboText=$zcvt(comboText,"U")
	s pid=##class(web.DHCSTCNTSCOMMON).GetPHCNTSPID()
	s h=0,NowDate=+$h
	s plid="0"
	f  s plid=$o(^DHCPL(plid)) q:plid=""  d
	.s ctlocdr=$p(^DHCPL(plid),"^",1)
	.s ctlocdesc=$p(^CTLOC(ctlocdr),"^",2)
	.s hospdr=$p(^CTLOC(ctlocdr),"^",22)
	.q:(hospdr'="")&(hospdr'=LogonHospId) ;过滤院区
	.s EndDate=$p(^CTLOC(ctlocdr),"^",25)
    .q:(EndDate'="")&(EndDate<NowDate) //lbb 2018/9/4 过滤截止日期小于当期日期
	.s ctlocconname=$zcvt($p(^CTLOC(ctlocdr),"^",43),"U")
	.q:(comboText'="")&&($zcvt(ctlocdesc,"U")'[comboText)&&(ctlocconname'[comboText)
	.s h=h+1
    .s data=ctlocdesc_"^"_ctlocdr
    .s ^TMP("dhcpha","DHCSTCNTSCOMMON","GetIPPhaLocDs",pid,h)=data
    q:h=0 ##class(web.DHCSTEXTCOMMON).GetNoJson()
    s maxrow=h
    
    s count=0
    s h=""
    f  s h=$o(^TMP("dhcpha","DHCSTCNTSCOMMON","GetIPPhaLocDs",pid,h)) q:h=""  d
    .s data=^TMP("dhcpha","DHCSTCNTSCOMMON","GetIPPhaLocDs",pid,h)
    .s desc=$p(data,"^",1)
    .s rowid=$p(data,"^",2)
    .
    .s phalocdesc=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("phalocdesc",desc)
	.s phalocdr=##class(web.DHCSTEXTCOMMON).GetJsonLastCell("phalocdr",rowid)
	.
	.s tmpstr=phalocdesc_phalocdr
    .s startString=##class(web.DHCSTEXTCOMMON).GetJsonStartString(maxrow)
    .s firstrow=##class(web.DHCSTEXTCOMMON).GetJsonFirstRow(tmpstr)
    .s lastrow=##class(web.DHCSTEXTCOMMON).GetJsonLastRow(tmpstr)
	.s count=count+1
	.i count=1 w startString
    .i count<maxrow w firstrow
    .i count=maxrow w lastrow
	.
	k ^TMP("dhcpha","DHCSTCNTSCOMMON","GetIPPhaLocDs",pid)
	q ""
}

/// 获取管制分类列表
ClassMethod GetPosionDs() As %String
{
	s pid=##class(web.DHCSTCNTSCOMMON).GetPHCNTSPID()
	s h=0
	s poisondr=0
	f  s poisondr=$o(^PHCPO(poisondr)) q:(poisondr="")||(poisondr=0)  d
	.s chkflag=0
	.s pccrowid=""
	.f  s pccrowid=$o(^DHCPCCON(pccrowid)) q:pccrowid=""  d
	..s tmppoisondr=$p(^DHCPCCON(pccrowid),"^",1)
	..i tmppoisondr=poisondr s chkflag=1
	.q:chkflag=1
	.s poisondesc=$p(^PHCPO(poisondr),"^",2)
	.i $f(poisondesc,$c(13,10)) s poisondesc=$p(poisondesc,$c(13,10))
	.s h=h+1
    .s data=poisondesc_"^"_poisondr
    .s ^TMP("dhcpha","DHCSTCNTSCOMMON","GetPosionDs",pid,h)=data
    q:h=0 ##class(web.DHCSTEXTCOMMON).GetNoJson()
    s maxrow=h
 
    s count=0
    s h=""
    f  s h=$o(^TMP("dhcpha","DHCSTCNTSCOMMON","GetPosionDs",pid,h)) q:h=""  d
    .s data=^TMP("dhcpha","DHCSTCNTSCOMMON","GetPosionDs",pid,h)
    .s desc=$p(data,"^",1)
    .s rowid=$p(data,"^",2)
    .
    .s posiondesc=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("posiondesc",desc)
	.s posiondr=##class(web.DHCSTEXTCOMMON).GetJsonLastCell("posiondr",rowid)
	.
	.s tmpstr=posiondesc_posiondr
    .s startString=##class(web.DHCSTEXTCOMMON).GetJsonStartString(maxrow)
    .s firstrow=##class(web.DHCSTEXTCOMMON).GetJsonFirstRow(tmpstr)
    .s lastrow=##class(web.DHCSTEXTCOMMON).GetJsonLastRow(tmpstr)
	.s count=count+1
	.i count=1 w startString
    .i count<maxrow w firstrow
    .i count=maxrow w lastrow
	.
	k ^TMP("dhcpha","DHCSTCNTSCOMMON","GetPosionDs",pid)
	q ""
}

// 获取药学大类

ClassMethod PhaCatByArcim(arcim)
{
 s sub=$p(arcim,"||",1)
 s ver=$p(arcim,"||",2)
 s phcdf=$P(^ARCIM(sub,ver,1),"^",12) q:phcdf="" ""
 s phcd=+phcdf
 s phasubcat=$p(^PHCD(phcd,1),"^",3) q:phasubcat="" ""
 s phacat=+phasubcat
 q phacat
}

// 获取药学子类

ClassMethod PhaSubCatByArcim(arcim)
{
 s sub=$p(arcim,"||",1)
 s ver=$p(arcim,"||",2)
 s phcdf=$P(^ARCIM(sub,ver,1),"^",12) q:phcdf="" ""
 s phcd=+phcdf
 s phasubcat=$p(^PHCD(phcd,1),"^",3)     
 q phasubcat
}

// 获取药学小类

ClassMethod PhaMinorSubCatByArcim(arcim)
{
 s sub=$p(arcim,"||",1)
 s ver=$p(arcim,"||",2)
 s phcdf=$P(^ARCIM(sub,ver,1),"^",12) q:phcdf="" ""
 s phcd=+phcdf
 s phaminorsubcat=$p(^PHCD(phcd,1),"^",6) 
 q phaminorsubcat
}

// 根据患者rowid取出年龄

ClassMethod GetAgeYear(papmidr As %String) As %String
{
	 s ageYears=0
	 s argBirthday=$p(^PAPER(papmidr,"ALL"),"^",6)
	 q:(+argBirthday=0) ""
	 q:(+papmidr=0) ""
	 s argAdmDate=$p($h,",",1)
	 s tmpAge="",ageYears=0,ageMonths=0,ageDays=0,age=""
	 s tmpAge=$$CalAge^at182(argBirthday,argAdmDate)
	 i (tmpAge'="")&&($l(tmpAge,"|")'<14) d
	 .s ageYears=$p(tmpAge,"|",12)

	 q ageYears
}

/// 
/// Creator:Zhouyg
/// CreatDate:2010-12-22
/// 转换为基本数量
/// Input:医嘱rowid
/// Output:基本单位数量^基本单位
ClassMethod GetDosageBUom(oeori As %String) As %String
{
	S ord=$p(oeori,"||",1) Q:ord="" ""
	S itm=$p(oeori,"||",2) Q:itm="" ""
	Q:'$D(^OEORD(ord,"I",itm,1)) ""
	Q:'$D(^OEORD(ord,"I",itm,2)) ""
	S dosqty=$P(^OEORD(ord,"I",itm,2),"^",1) //剂量
	S DosUnit=$p(^OEORD(ord,"I",itm,2),"^",3)
	S arcim=$p(^OEORD(ord,"I",itm,1),"^",2)
	S arcimm=$P(arcim,"||",1)
	Q:arcimm="" ""
	S arcims=$P(arcim,"||",2)
	Q:arcims="" ""
	Q:'$D(^ARCIM(arcimm,arcims,1)) ""
	S phcdf=$P(^ARCIM(arcimm,arcims,1),"^",12)
	S phc=$P(phcdf,"||",1)
	Q:phc="" ""
	S formsub=$P(phcdf,"||",2)
	Q:formsub="" ""
	S BuomID=$P(^PHCD(phc,"DF",formsub,2),"^",4)
	Q:BuomID="" ""
	S BQty=+$P(^PHCD(phc,"DF",formsub,2),"^",5)
	Q:BQty=0 ""
	S BuomDesc=$P($G(^CT("UOM",BuomID)),"^",2)
	Q:DosUnit=BuomID dosqty_"^"_BuomDesc
	s eqsub="0",eqqty=0
	f  s eqsub=$O(^PHCD(phc,"DF",formsub,"EQ",eqsub)) q:eqsub=""  d
	.S equomdr=$P(^PHCD(phc,"DF",formsub,"EQ",eqsub),"^",1)
	.Q:equomdr'=DosUnit
	.s eqqty=+$P(^PHCD(phc,"DF",formsub,"EQ",eqsub),"^",2) //等效数量
	Q:eqqty=0 ""
	S RetQty=dosqty/(eqqty/BQty)
	I RetQty["." D
	.S RetQty=$FN(RetQty,"",2)
	Q RetQty_"^"_BuomDesc
}

/// 取门诊处方医嘱实际疗程
/// w ##class(web.DHCSTCNTSCOMMON).GetRealDuration("2004||8")
ClassMethod GetRealDuration(oeori)
{
   
	S ord=$p(oeori,"||",1) Q:ord="" ""
	S itm=$p(oeori,"||",2) Q:itm="" ""
	s buomstr=..GetDosageBUom(oeori)
	s buomqty=$p(buomstr,"^",1)
	s buomdesc=$p(buomstr,"^",2)
    s arcimid=$p(^OEORD(ord,"I",itm,1),"^",2)  ;医嘱 ARC_ItmMast ARCIM_RowId
	s itmmastid=$p(arcimid,"||",1)
	s itmmastver=$p(arcimid,"||",2)
	s inci=$o(^INCI(0,"ARCIM_DR",$p(arcimid,"||",1),"") ) q:inci=""  //医嘱名称
	//s buomdr=$p(^INCI(inci,1),"^",10) 
	//s puomdr=$p(^ARCIM(itmmastid,itmmastver,8),"^",14)
	//s puomdesc=$p(^CT("UOM",puomdr),"^",2)
	//s confac=##class(web.DHCSTCOMMONSRV).UOMFac(puomdr,buomdr)
	s dsp=$o(^DHCOEDISQTY(0,"OEORI",oeori,""))
    s qty=$p(^DHCOEDISQTY(dsp),"^",2)
	s freqcnt=1
	s freqdr=$p($g(^OEORD(ord,"I",itm,2)),"^",4) ;OEORI_PHFreq_DR
    i freqdr'="" s freqcnt=$p($g(^PHCFR(freqdr)),"^",2)  ;频率
    s buomqty=buomqty*freqcnt
    i +buomqty=0 s buomqty=1
    i qty/buomqty>1 d 
    .s qty=qty\buomqty
    e  d
    .s qty=qty/buomqty
	q qty
}

/// 取基本药物标志
ClassMethod GetBasicDrugflag(inci)
{
	
    s basflag=""
	s infor=$o(^DHCITMINFO(0,"INCI",inci,""))
	i infor'="" s basflag=$p(^DHCITMINFO(infor),"^",4)
	q basflag
}

/// 获取安全组数据集合
ClassMethod GetSecGrpDs()
{
	s pid=##class(web.DHCSTCNTSCOMMON).GetPHCNTSPID()
	s h=0
	s grpdr="0"
	f  s grpdr=$o(^SSU("SSGRP",grpdr)) q:grpdr=""  d
	.s grpdesc=$p(^SSU("SSGRP",grpdr),"^",1) 
	.s h=h+1
    .s data=grpdesc_"^"_grpdr
    .s ^TMP("dhcpha","DHCSTCNTSCOMMON","GetSecGrpDs",pid,h)=data
    q:h=0 ##class(web.DHCSTEXTCOMMON).GetNoJson()
    s maxrow=h
 
    s count=0
    s h=""
    f  s h=$o(^TMP("dhcpha","DHCSTCNTSCOMMON","GetSecGrpDs",pid,h)) q:h=""  d
    .s data=^TMP("dhcpha","DHCSTCNTSCOMMON","GetSecGrpDs",pid,h)
    .s desc=$p(data,"^",1)
    .s rowid=$p(data,"^",2)
    .
    .s grpdesc=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("grpdesc",desc)
	.s grpdr=##class(web.DHCSTEXTCOMMON).GetJsonLastCell("grpdr",rowid)
	.
	.s tmpstr=grpdesc_grpdr
    .s startString=##class(web.DHCSTEXTCOMMON).GetJsonStartString(maxrow)
    .s firstrow=##class(web.DHCSTEXTCOMMON).GetJsonFirstRow(tmpstr)
    .s lastrow=##class(web.DHCSTEXTCOMMON).GetJsonLastRow(tmpstr)
	.s count=count+1
	.i count=1 w startString
    .i count<maxrow w firstrow
    .i count=maxrow w lastrow
	.
	k ^TMP("dhcpha","DHCSTCNTSCOMMON","GetSecGrpDs",pid)
	q ""
}

/// 取点评方式的配置
ClassMethod GetSecGrpConfigStr(wayid, secgrp)
{
	q:wayid="" ""
	s sub="0"
	f  s sub=$o(^DHCPCWAY(wayid,"I",sub)) q:sub=""  d
	.s grpdr=$p(^DHCPCWAY(wayid,"I",sub),"^",1)
	.q:secgrp'=grpdr
	.s updateflag=$p(^DHCPCWAY(wayid,"I",sub),"^",2)
	.
	q $g(updateflag)
}

/// 取主医嘱Rowid
ClassMethod GetMainOeori(oeori As %String) As %String
{
	Q:oeori="" ""
 	S ord=$p(oeori,"||",1) Q:ord="" ""
 	S chl=$p(oeori,"||",2) Q:chl="" ""
 	Q:'$D(^OEORD(ord,"I",chl,1)) ""
 	Q:'$D(^OEORD(ord,"I",chl,11)) ""
 	S loeori=$P(^OEORD(ord,"I",chl,11),"^",39)
 	Q:loeori'="" loeori
 	Q oeori
}

/// 获取安全组关联科室
ClassMethod GetStockPhlocDs(grpdr As %String, hospid As %String = "") As %String
{
	s pid=##class(web.DHCSTCNTSCOMMON).GetPHCNTSPID()
	s h=0
	s sub=""
	f  s sub=$o(^SSU("SSGRP",grpdr,"ST",sub)) q:sub=""  d
	.s ctlocdr=$p(^SSU("SSGRP",grpdr,"ST",sub),"^",1)
	.s ctlocdesc=$p(^CTLOC(ctlocdr),"^",2)
	.s ctloctype=$p(^CTLOC(ctlocdr),"^",13)
	.q:ctloctype'="D"
	.s ctlochospdr=$p(^CTLOC(ctlocdr),"^",22)
	.q:(hospid'="")&&(hospid'=ctlochospdr)
	.s h=h+1
    .s data=ctlocdesc_"^"_ctlocdr
    .s ^TMP("dhcpha","DHCSTCNTSCOMMON","GetStockPhlocDs",pid,h)=data
    q:h=0 ##class(web.DHCSTEXTCOMMON).GetNoJson()
    s maxrow=h
    
    s count=0
    s h=""
    f  s h=$o(^TMP("dhcpha","DHCSTCNTSCOMMON","GetStockPhlocDs",pid,h)) q:h=""  d
    .s data=^TMP("dhcpha","DHCSTCNTSCOMMON","GetStockPhlocDs",pid,h)
    .s phlocdesc=$p(data,"^",1)
    .s rowId=$p(data,"^",2)
    .
    .s phlocdesc=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("phlocdesc",phlocdesc)
	.s rowId=##class(web.DHCSTEXTCOMMON).GetJsonLastCell("rowId",rowId)
	.
	.s tmpstr=phlocdesc_rowId
    .s startString=##class(web.DHCSTEXTCOMMON).GetJsonStartString(maxrow)
    .s firstrow=##class(web.DHCSTEXTCOMMON).GetJsonFirstRow(tmpstr)
    .s lastrow=##class(web.DHCSTEXTCOMMON).GetJsonLastRow(tmpstr)
	.s count=count+1
	.i count=1 w startString
    .i count<maxrow w firstrow
    .i count=maxrow w lastrow
	.
	k ^TMP("dhcpha","DHCSTCNTSCOMMON","GetStockPhlocDs",pid)
	q ""
}

/// 获取session科室
ClassMethod GetSessionLoc(ctlocdr) As %String
{
	s ctlocdesc=$p(^CTLOC(ctlocdr),"^",2)
	q ctlocdesc
}

/// 获取安全组关联科室
ClassMethod GetWardDs() As %String
{
	s pid=##class(web.DHCSTCNTSCOMMON).GetPHCNTSPID()
	s h=0
	s warddr=0
	f  s warddr=$o(^PAWARD(warddr)) q:(warddr="")||(+warddr=0)  d
	.s warddesc=$p(^PAWARD(warddr),"^",2)
	.s h=h+1
    .s data=warddesc_"^"_warddr
    .s ^TMP("dhcpha","DHCSTCNTSCOMMON","GetWardDs",pid,h)=data
    q:h=0 ##class(web.DHCSTEXTCOMMON).GetNoJson()
    s maxrow=h
    
    s count=0
    s h=""
    f  s h=$o(^TMP("dhcpha","DHCSTCNTSCOMMON","GetWardDs",pid,h)) q:h=""  d
    .s data=^TMP("dhcpha","DHCSTCNTSCOMMON","GetWardDs",pid,h)
    .s warddesc=$p(data,"^",1)
    .s rowId=$p(data,"^",2)
    .s warddesc=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("warddesc",warddesc)
	.s rowId=##class(web.DHCSTEXTCOMMON).GetJsonLastCell("rowId",rowId)
	.
	.s tmpstr=warddesc_rowId
    .s startString=##class(web.DHCSTEXTCOMMON).GetJsonStartString(maxrow)
    .s firstrow=##class(web.DHCSTEXTCOMMON).GetJsonFirstRow(tmpstr)
    .s lastrow=##class(web.DHCSTEXTCOMMON).GetJsonLastRow(tmpstr)
	.s count=count+1
	.i count=1 w startString
    .i count<maxrow w firstrow
    .i count=maxrow w lastrow
	.
	k ^TMP("dhcpha","DHCSTCNTSCOMMON","GetWardDs",pid)
	q ""
}

/// w ##class(web.DHCSTCNTSCOMMON).GetAdmDs("0000000719")
ClassMethod GetAdmDs(RegNo As %String, style = "") As %Integer
{
	 s pid=##class(web.DHCSTCNTSCOMMON).GetPHCNTSPID()
	 s n=0
	 q:(RegNo="")&(style'="") ##class(web.DHCSTJQUERYCOMMON).getJsonEmptySign(0)
	 q:RegNo="" ##class(web.DHCSTEXTCOMMON).GetNoJson()
	 q:('$d(^PAPERi("PAPMI_PatNo",RegNo))&(style'="")) ##class(web.DHCSTJQUERYCOMMON).getJsonEmptySign(0)
	 q:'$d(^PAPERi("PAPMI_PatNo",RegNo)) ##class(web.DHCSTEXTCOMMON).GetNoJson()
	 s papmi=$o(^PAPERi("PAPMI_PatNo",RegNo,""))
	 q:(style="jqGrid")&&(papmi="") ##class(web.DHCSTJQUERYCOMMON).getJsonEmptySign(0)
	 q:papmi="" ##class(web.DHCSTEXTCOMMON).GetNoJson()
	 s adm="" 
	 f  s adm=$o(^PAPERdr(papmi,"ADM","I",adm),-1) q:adm=""  d
	 .q:$p(^PAADM(adm),"^",2)'="I"  
	 .s depDesc=""    
	 .s depcodedr=$p(^PAADM(adm),"^",4) 
	 .i depcodedr'="" s depDesc=$p(^CTLOC(depcodedr),"^",2)
	 .i depDesc'="" s depDesc=$p(depDesc,"-",2)
	 .s admdate=$p(^PAADM(adm),"^",6) 
	 .i +admdate>0 s admdate=##class(websys.Conversions).DateLogicalToHtml(admdate)
	 .s admtime=$p(^PAADM(adm),"^",7) 
	 .i +admtime>0 s admtime=##class(websys.Conversions).TimeLogicalToHtml(admtime)
	 .s curWardDesc=""
	 .s curWard=$p(^PAADM(adm),"^",70) 
	 .i curWard'="" s curWardDesc=$p(^PAWARD(+curWard),"^",2)
	 .i curWardDesc'="" s curWardDesc=$p(curWardDesc,"-",2)
	 .s curBedcode=""
	 .s curBed=$p(^PAADM(adm),"^",73) i curBed'="" d
	 ..s w=+curBed,b=$p(curBed,"||",2) q:(w="")!(b="")
	 ..s curBedcode=$p(^PAWARD(w,"BED",b),"^",1)
	 .s doctor=$p(^PAADM(adm),"^",9)
	 .i doctor'=""  s doctor=$p(^CTPCP(doctor,1),"^",2 )
	 .s n=n+1
	 .s data=$g(adm)_"^"_$g(depDesc)_"^"_$g(admdate)_" "_$g(admtime)_"^"_$g(curWardDesc)_"^"_$g(curBedcode)_"^"_$g(doctor)
	 .s ^TMP("dhcpha","DHCSTCNTSCOMMON","GetAdmDs",pid,n)=data
     q:(style="jqGrid")&&(n=0) ##class(web.DHCSTJQUERYCOMMON).getJsonEmptySign(0)
     q:n=0 ##class(web.DHCSTEXTCOMMON).GetNoJson()
     s maxrow=n
     s count=0
     s h=""
     f  s h=$o(^TMP("dhcpha","DHCSTCNTSCOMMON","GetAdmDs",pid,h)) q:h=""  d
     .s data=^TMP("dhcpha","DHCSTCNTSCOMMON","GetAdmDs",pid,h)
     .s adm=$p(data,"^",1)
     .s admdate=$p(data,"^",3)
     .s admloc=$p(data,"^",2)
     .s currward=$p(data,"^",4)
     .s currbed=$p(data,"^",5)
     .s currdoc=$p(data,"^",6)
     .s papmi=$p($g(^PAADM(adm)),"^",1)
     .s adm=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("adm",adm)
	 .s admdate=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("admdate",admdate)
	 .s admloc=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("admloc",admloc)
	 .s currward=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("currward",currward)
	 .s currbed=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("currbed",currbed)
	 .s papmi=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("papmi",papmi)
	 .s currdoc=##class(web.DHCSTJQUERYCOMMON).GetJsonLastCell("currdoc",currdoc)
	 .
	 .s tmpstr=adm_admdate_admloc_currward_currbed_papmi_currdoc
     .s startString=##class(web.DHCSTJQUERYCOMMON).GetJsonStartString(maxrow)
     .s firstrow=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstRow(tmpstr)
     .s lastrow=##class(web.DHCSTJQUERYCOMMON).GetJsonLastRow(tmpstr)
	 .s count=count+1
	 .i count=1 w startString
     .i count<maxrow w firstrow
     .i count=maxrow w lastrow
	 .
	 k ^TMP("dhcpha","DHCSTCNTSCOMMON","GetAdmDs",pid)
     q ""
}

/// 获取病人登记号长度
ClassMethod GetPatRegNoLen()
{
	 s PatLen=$p(^CF("PATCF",1,3),"^",5)
	 q PatLen
}

/// 获取医嘱的审核结果
ClassMethod GetOrdAuditResult(orditm) As %String
{
	s orditm=##class(web.DHCSTCNTSCOMMON).GetMainOeori(orditm)
	s ord=$p(orditm,"||",1)
	s itm=$p(orditm,"||",2)
	s result=$p(^OEORD(ord,"I",itm,7),"^",3)
	q result
}

/// 获取病人基本信息
/// w ##class(web.DHCSTCNTSCOMMON).GetPrescBasicInfo("O12033100005")
ClassMethod GetAdmBasicInfo(adm) As %String
{
   q:adm="" ""
   s papmi=+$p(^PAADM(adm),"^",1)
   s perno=$p(^PAPER(papmi,"PAT",1),"^",2)
   s pname=$p(^PAPER(papmi,"ALL"),"^",1)
   s ptel=$p(^PAPER(papmi,"PER",1),"^",11)
   s paddress=$p($g(^PAPER(papmi,"PER",4)),"^",18)
   s getage=##class(web.DHCOutPhCommon).GetAge(papmi) 
   s sexdr=$p(^PAPER(papmi,"ALL"),"^",7)
   s sex=$p(^CT("SEX",sexdr),"^",2)
   s company=$p(^PAPER(papmi,"PER",4),"^",18) //工作单位
   s cardNo=""
   s cfRowId=$o(^DHCCARDi("CF",0,"PAPMIDR",papmi,""),-1)
   i cfRowId'="" d
   .s cardNo=$p($g(^DHCCARD("CF",cfRowId)),"^",2)
   s admdate=""
   s admdate=$p(^PAADM(adm),"^",6)
   i admdate'="" s admdate=##class(websys.Conversions).DateLogicalToHtml(admdate)
   s diagnodesc=##class(web.DHCOutPhCommon).GetMRDiagnosDesc(adm,",")
   s patW=##class(web.DHCOutPhCommon).GetPatWeight(adm)
   s patH=##class(web.DHCOutPhCommon).GetPatHeight(adm)
   s ward=""
   s admwarddr=$p(^PAADM(adm),"^",70)
   i admwarddr'="" d
   .s ward=$p(^PAWARD(admwarddr),"^",2)
   .i $f(ward,"-") s ward=$p(ward,"-",2)
   s billtype=""
   s typedr=$p(^PAADM(adm,1),"^",7)	//住院患者取pa_adm中费别
   s:typedr'="" billtype=$p($g(^PAC("ADMREA",typedr)),"^",2)

   ;
   s patstring=perno_"^"_pname_"^"_getage_"^"_sex_"^"_diagnodesc_"^"_patW_"^"_company_"^"_cardNo_"^"_admdate_"^"_ptel_"^"_paddress
   s patstring=patstring_"^"_billtype_"^"_patH_"^"_ward
   q patstring
}

/// 获取药师建议集
ClassMethod GetPHCNTSAdvice() As %String
{
	s h=0
	s pid=##class(web.DHCSTCNTSCOMMON).GetPHCNTSPID()
	s pcar=""
	f  s pcar=$o(^DHCPCADVICE(pcar)) q:pcar=""  d
	.s advdesc=$p(^DHCPCADVICE(pcar),"^",2)
	.s h=h+1
    .s data=advdesc_"^"_pcar
    .s ^TMP("dhcpha","DHCSTCNTSCOMMON","GetPHCNTSAdvice",pid,h)=data
    q:h=0 ##class(web.DHCSTEXTCOMMON).GetNoJson()
    s maxrow=h
    
    s count=0
    s h=""
    f  s h=$o(^TMP("dhcpha","DHCSTCNTSCOMMON","GetPHCNTSAdvice",pid,h)) q:h=""  d
    .s data=^TMP("dhcpha","DHCSTCNTSCOMMON","GetPHCNTSAdvice",pid,h)
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
	k ^TMP("dhcpha","DHCSTCNTSCOMMON","GetPHCNTSAdvice",pid)
	q ""
}

/// 获取不合格警示值集
ClassMethod GetPHCNTSFactor() As %String
{
	s h=0
	s pid=##class(web.DHCSTCNTSCOMMON).GetPHCNTSPID()
	s facr=""
	f  s facr=$o(^DHCPCFACTOR(facr)) q:facr=""  d
	.s facdesc=$p(^DHCPCFACTOR(facr),"^",2)
	.s h=h+1
    .s data=facdesc_"^"_facr
    .s ^TMP("dhcpha","DHCSTCNTSCOMMON","GetPHCNTSFactor",pid,h)=data
    q:h=0 ##class(web.DHCSTEXTCOMMON).GetNoJson()
    s maxrow=h
    
    s count=0
    s h=""
    f  s h=$o(^TMP("dhcpha","DHCSTCNTSCOMMON","GetPHCNTSFactor",pid,h)) q:h=""  d
    .s data=^TMP("dhcpha","DHCSTCNTSCOMMON","GetPHCNTSFactor",pid,h)
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
	k ^TMP("dhcpha","DHCSTCNTSCOMMON","GetPHCNTSFactor",pid)
	q ""
}

/// 获取处方药品列表
/// w ##class(web.DHCSTCNTSCOMMON).GetOrdItms("153||2",6)
ClassMethod GetOrdItms(orditemstr, waycode = "") As %String
{
	s orditem=$p(orditemstr,"^",1)
	q:orditem="" ##class(web.DHCSTEXTCOMMON).GetNoJson()	
	s pid=##class(web.DHCSTCNTSCOMMON).GetPHCNTSPID()
	s h=0
	i orditem["||" d
	.s ord=$p(orditem,"||",1)
	.s chl=$p(orditem,"||",2)
	e  d
	.s ord=$o(^OEORD(0,"PrescNo",orditem,""))
	.s chl=$o(^OEORD(0,"PrescNo",orditem,ord,""))
	s orditm=ord_"||"_chl
	s mainorditm=##class(web.DHCSTCNTSCOMMON).GetMainOeori(orditm)
	s adm=$p(^OEORD(ord),"^",1)
    s admtype=$p(^PAADM(adm),"^",2)
    i admtype'="I" d
	.s prescno=$p(^OEORD(ord,"I",chl,1),"^",14)
	.s ord=""
	.f  s ord=$o(^OEORD(0,"PrescNo",prescno,ord))  q:ord=""  d
	..s chl=""
	..f  s chl=$o(^OEORD(0,"PrescNo",prescno,ord,chl)) q:chl=""  d
	...s orditm=ord_"||"_chl
	...//过滤-未审核状态下停止或者作废的医嘱
	...s dspId=$o(^DHCOEDISQTY(0,"OEORI",orditm,""))
	...q:dspId=""
	...s dspStatus=$p(^DHCOEDISQTY(dspId),"^",7) 
	...s oeoriStatStr=##class(PHA.COM.Order).OeoriStat(orditm)		   
	...s oeFlag=$P(oeoriStatStr,"^",1)
	...q:(dspStatus'="C")&&(oeFlag'="V")&&(oeFlag'="E")
	...d getdata
    e  d
    .s orditmList=orditemstr
 	.s len=$l(orditmList,"^")
 	.f i=1:1:len d
 	..s orditm=$p(orditmList,"^",i)
 	..s ord=$p(orditm,"||",1)
    ..s chl=$p(orditm,"||",2)
 	..d getdata
    q:h=0 ##class(web.DHCSTEXTCOMMON).GetNoJson()
    s maxrow=h
    s count=0
    s h=""
    f  s h=$o(^TMP("dhcpha","DHCSTCNTSCOMMON","GetOrdItms",pid,h)) q:h=""  d
    .s data=^TMP("dhcpha","DHCSTCNTSCOMMON","GetOrdItms",pid,h)
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
	k ^TMP("dhcpha","DHCSTCNTSCOMMON","GetOrdItms",pid)
	q ""
	
getdata
     s presc=$p(^OEORD(ord,"I",chl,1),"^",14) ;处方号
	 q:presc=""
	 s dsp=$o(^DHCOEDISQTY(0,"OEORI",orditm,""))
	 q:dsp=""
	 s status=$p(^DHCOEDISQTY(dsp),"^",7)
	 S waycodeIP=##Class(web.DHCSTCNTSCOMMON).GetWayIdByCode("IP")
	 s qty=##class(web.DHCSTCNTSCOMMON).GetDspQty(orditm)
	 q:(qty=0)&&(waycode=waycodeIP)  //住院点评按已发药
	 //q:(status'="C")&(waycode=waycodeIP)  //住院点评按已发药
	 s priordr=+$p(^OEORD(ord,"I",chl,1),"^",8) 
     q:priordr=0 
     s priority=$p(^OECPR(priordr),"^",1) 			;医嘱优先级代码  
     q:priority["OM" ;自备药
	 s arcimid=$p(^OEORD(ord,"I",chl,1),"^",2)  ;医嘱 ARC_ItmMast ARCIM_RowId
	 s itmmastid=$p(arcimid,"||",1)
	 s itmmastver=$p(arcimid,"||",2)
	 s inci=$o(^INCI(0,"ARCIM_DR",$p(arcimid,"||",1),"") )
	 q:inci=""  //医嘱名称
	 s arcimDesc=$p(^ARCIM(itmmastid,itmmastver,1),"^",2)
	 s h=h+1
     s data=arcimDesc_"^"_orditm
     s ^TMP("dhcpha","DHCSTCNTSCOMMON","GetOrdItms",pid,h)=data
     q
}

// 获取处方基本信息

/// w ##class(web.DHCSTCNTSCOMMON).GetPrescBasicInfo("E16102600004")
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
   i cfRowId'="" s cardNo=$p($g(^DHCCARD("CF",cfRowId)),"^",2)
   e  s cardNo=""
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
   s billtype=##class(web.DHCOutPhCommon).GetPrescFeeType(PrescNo)
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

/// 获取处方总金额
/// w ##class(web.DHCSTCNTSCOMMON).GetPrescAmt("O16012900003")
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
	 ..s arcimid=$p(^OEORD(ord,"I",itm,1),"^",2) 
	 ..s itmmastid=$p(arcimid,"||",1)
	 ..s itmmastver=$p(arcimid,"||",2)
	 ..s inci=$o(^INCI(0,"ARCIM_DR",$p(arcimid,"||",1),"")) q:inci=""
	 ..s puomdr=$p(^ARCIM(itmmastid,itmmastver,8),"^",14) //计价单位
	 ..s dspdate=+$h
	 ..s dsp=$o(^DHCOEDISQTY(0,"OEORI",oeori,""))
	 ..q:dsp="" 
	 ..s status=$p(^DHCOEDISQTY(dsp),"^",7)
	 ..i status="C" s dspdate=$p(^DHCOEDISQTY(dsp),"^",8)
	 ..q:(oeflag'="V")&(oeflag'="E")&(status'="C")
	 ..// 医嘱结构改造后价格取打包批次表中的
	 ..s amtstr=..GetAmtByDsp(dsp)
	 ..s amt=$p(amtstr,"^",2)
	 ..s ret=ret+amt 
	 q ret
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

/// 获到病人诊断信息
/// w ##class(web.DHCSTCNTSCOMMON).GetMRDiagnosDesc(2143)
ClassMethod GetMRDiagnosDesc(adm) As %String
{
	//s ^yunhaibao($this,"GetMRDiagnosDesc")=adm
	s pid=##class(web.DHCSTCNTSCOMMON).GetPHCNTSPID()
	s h=0
	//s str=##class(web.DHCSTKUTIL).GetMRDiagnosDesc(adm,"^")
	s str=..GetMRDiagnosDescAndSign(adm,"^")    //中医辩证
	s cnt=$l(str,"^")
	f i=1:1:cnt d
	.s h=h+1
	.s diag=$p(str,"^",i)
	.s data=diag
	.s ^TMP("dhcpha","DHCSTCNTSCOMMON","GetMRDiagnosDesc",pid,h)=data
    q:h=0 ##class(web.DHCSTEXTCOMMON).GetNoJson()
    s maxrow=h
    s count=0
    s h=""
    f  s h=$o(^TMP("dhcpha","DHCSTCNTSCOMMON","GetMRDiagnosDesc",pid,h)) q:h=""  d
    .s data=^TMP("dhcpha","DHCSTCNTSCOMMON","GetMRDiagnosDesc",pid,h)
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
	k ^TMP("dhcpha","DHCSTCNTSCOMMON","GetMRDiagnosDesc",pid)
	q ""
}

/// w ##class(web.DHCSTCNTSCOMMON).GetXYOrdDetail("O181105000016")
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
    f  s h=$o(^TMP("dhcpha","DHCSTCNTSCOMMON","GetOrdDetailData",pid,h)) q:h=""  d
    .s data=^TMP("dhcpha","DHCSTCNTSCOMMON","GetOrdDetailData",pid,h)
    .s incidesc=$p(data,"^",1)
    .s spec=$p(data,"^",6)
    .s incidesc=incidesc
    .s qty=$p(data,"^",2)
    .s uomdesc=$p(data,"^",3)
    .s qty=qty_" "_uomdesc
    .s dosage=$p(data,"^",4)
    .i dosage'="" s dosage="每次"_dosage
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
    
    
    k ^TMP("dhcpha","DHCSTCNTSCOMMON","GetOrdDetailData",pid)
    q ""
}

/// w ##class(web.DHCSTCNTSCOMMON).GetXYOrdDetail("O18101300005")
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
    f  s h=$o(^TMP("dhcpha","DHCSTCNTSCOMMON","GetOrdDetailData",pid,h)) q:h=""  d
    .s data=^TMP("dhcpha","DHCSTCNTSCOMMON","GetOrdDetailData",pid,h)
    .s incidesc=$p(data,"^",1)
    .;s qty=$p(data,"^",4)
    .s qty=$p(data,"^",2)
    .s uomdesc=$p(data,"^",3)
    .s:qty'=0 qty=qty_uomdesc
    .s remark=$p(data,"^",17)
    .s count=count+1
    .q:count<stpage
    .q:count>endpage
    .
    .i count#3=1 d
    ..s drugname=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("drugname",incidesc)
	..s qty=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("qty",qty)
	..i count=endpage  d
	...s splitone=##class(web.DHCSTEXTCOMMON).GetJsonLastCell("splitone","")
	..e  d
	...s splitone=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("splitone","")
	..s tmpstr=drugname_qty_splitone
	..
	.//
	.i count#3=2 d
    ..s drugnametwo=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("drugnametwo",incidesc)
	..s qtytwo=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("qtytwo",qty)
	..i count=endpage  d
	...s splittwo=##class(web.DHCSTEXTCOMMON).GetJsonLastCell("splittwo","")
	..e  d
	...s splittwo=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("splittwo","")
	..s tmpstr=tmpstr_drugnametwo_qtytwo_splittwo
	.//
	.i count#3=0 d
    ..s drugnamethree=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("drugnamethree",incidesc)
	..s qtythree=##class(web.DHCSTEXTCOMMON).GetJsonLastCell("qtythree",qty)
	..s tmpstr=tmpstr_drugnamethree_qtythree
	.
    .s startString=##class(web.DHCSTEXTCOMMON).GetJsonStartString(maxrow)
    .s firstrow=##class(web.DHCSTEXTCOMMON).GetJsonFirstRow(tmpstr)
    .s lastrow=##class(web.DHCSTEXTCOMMON).GetJsonLastRow(tmpstr)
	.
    .i count=stpage w startString
    .i (count'=endpage)&&((count#3)=0) w firstrow
    .i count=endpage w lastrow
    k ^TMP("dhcpha","DHCSTCNTSCOMMON","GetOrdDetailData",pid)
    q ""
}

/// 转换门诊处方明细
/// 处方点评的预览都是已发
ClassMethod GetOrdDetailInfo(prescno, stpage, limit) As %String
{
	s pid=##class(web.DHCSTCNTSCOMMON).GetPHCNTSPID()
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
	..s inci=$o(^INCI(0,"ARCIM_DR",$p(arcimid,"||",1),"") ) 
	..q:inci=""  //医嘱名称
	..s arcItmDesc=$p(^ARCIM(itmmastid,itmmastver,1),"^",2)
	..s dsp=$o(^DHCOEDISQTY(0,"OEORI",orditm,""))
	..q:dsp=""
    ..// 医嘱改造,打包表数量为药学基本单位数量
	..s qtyUomStr=##class(web.DHCSTCOMMONORDER).OeoriQtyUom(orditm)
	..s qty=$p(qtyUomStr,"^",1)
	..s uomdesc=$p(qtyUomStr,"^",2)
	..s dosage=$p(^OEORD(ord,"I",chl,2),"^",1) ;剂量
	..i (dosage'="")&&(dosage<1)&&($p(dosage,".",1)=0) s dosage=0_dosage
    ..s doseuom=""
	..s dosuomID=+$p(^OEORD(ord,"I",chl,2),"^",3)
	..i dosuomID'=0 d
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
	..i $F(form,$c(13)) s form=$p(form,$c(13))
	..s spec="" //##class(web.DHCSTCOMMONSRV).getBarcode(inci) ;规格
	..s manf="" //##class(web.DHCSTITMDESC).GetManfNameByInci(inci) ;厂家
	..i $f(manf,"-") s manf=$p(manf,"-",2)
	..s remark=##class(web.DHCSTCOMMONSRV).GetOrdItmRemark(orditm) ;备注
	..s dsp=""
	..s dsp=$o(^DHCOEDISQTY(0,"OEORI",orditm,dsp)) 
	..q:dsp=""
    ..s orddate=$p(^DHCOEDISQTY(dsp),"^",15)
    ..i orddate'="" s orddate=##class(websys.Conversions).DateLogicalToHtml(orddate)
    ..s ordtime=$p(^DHCOEDISQTY(dsp),"^",16)
    ..i ordtime'="" s ordtime=##class(websys.Conversions).TimeLogicalToHtml(ordtime)
    ..s orddatetime=orddate_" "_ordtime  ;开单日期
    ..s status=$p(^DHCOEDISQTY(dsp),"^",7)
    ..s dspdate=+$h
	..i status="C" s dspdate=$p(^DHCOEDISQTY(dsp),"^",8)
	..s amt=0
	..s dspSub=0
	..f  s dspSub=$o(^DHCOEDISQTY(dsp,"I",dspSub)) q:dspSub=""  d
	...s dspSubData=^DHCOEDISQTY(dsp,"I",dspSub)
	...s subSp=$p(dspSubData,"^",4)
	...s subQty=$p(dspSubData,"^",2)
	...s subSpAmt=subSp*subQty
	...s amt=amt+subSpAmt
	..s price=amt/qty
	..s amt=$fn(amt,"",2)
	..s cyqty=$p(^DHCOEDISQTY(dsp),"^",5)
	..s specinstr=$p(^OEORD(ord,"I",chl,2),"^",8)
    ..s h=h+1
    ..s data=arcItmDesc_"^"_qty_"^"_uomdesc_"^"_dosage_doseuom_"^"_freq_"^"_spec_"^"_instru_"^"_duration_"^"_form
    ..s data=data_"^"_priorty_"^"_doctor_"^"_orddatetime_"^"_remark_"^"_manf_"^"_price_"^"_amt_"^"_specinstr_"^"_skintest
    ..s ^TMP("dhcpha","DHCSTCNTSCOMMON","GetOrdDetailData",pid,h)=data
    q h_"^"_pid
}

/// 取住院药房集合
ClassMethod GetPhaLocStr() As %String
{
  
    s ret=""
    s ctlocdr=""
	f  s ctlocdr=$o(^DHCPL(0,"Loc",ctlocdr)) q:ctlocdr=""  d
	.i ret="" d
	..s ret=ctlocdr
	.e  d
	..s ret=ret_"^"_ctlocdr
	q ret
}

/// 取医嘱发药数量
/// w ##class(web.DHCSTCNTSCOMMON).GetDspQty("153||2")
ClassMethod GetDspQty(oeori) As %String
{
	s qty=0
	s dsp=""
	f  s dsp=$o(^DHCOEDISQTY(0,"OEORI",oeori,dsp)) q:dsp=""  d
	.s status=$p(^DHCOEDISQTY(dsp),"^",7)
	.q:status'="C"
	.s dspqty=+$p(^DHCOEDISQTY(dsp),"^",5)
	.s qty=qty+dspqty
	q qty
}

/// 获取抗菌药标志  1 是 , 非1 否
ClassMethod GetAntibioticFlag(orditm) As %String
{
	s ret=0
	s ord=$p(orditm,"||",1)
	s chl=$p(orditm,"||",2)
	s arcimid=$p(^OEORD(ord,"I",chl,1),"^",2)
	s itmmastid=$p(arcimid,"||",1)
    s itmmastver=$p(arcimid,"||",2)
    s phcform=$p(^ARCIM(itmmastid,itmmastver,1),"^",12)
    s phc=$p(phcform,"||",1)
    s phcsub=$p(phcform,"||",2)
    s antibiotic=$p($G(^PHCD(phc,"DF",phcsub,"DHC")),"^",8)
    i antibiotic="Y" s ret=1
    q ret
}

/// 获取基本药标志  1 是 , 非1 否
ClassMethod GetBasicDrugFlagByOrd(orditm) As %String
{
	
	s ord=$p(orditm,"||",1)
	s itm=$p(orditm,"||",2)
	s arcimid=$p(^OEORD(ord,"I",itm,1),"^",2) 
	s itmmastid=$p(arcimid,"||",1)
	s itmmastver=$p(arcimid,"||",2)
	s inci=$o(^INCI(0,"ARCIM_DR",$p(arcimid,"||",1),"")) q:inci="" ""
	s phcdfId=$p(^ARCIM(itmmastid,itmmastver,1),"^",12)
	i phcdfId'="" d
	.s basflag=$p(^PHCD(+phcdfId,"DF",+$p(phcdfId,"||",2),"DHC"),"^",31)
	q:basflag="Y" 1
	q 0
}

/// 获取注射药标志  1 是 , 非1 否
ClassMethod GetZSDrugFlagByOrd(orditm) As %String
{
	s ret=""
	s ord=$p(orditm,"||",1)
	s itm=$p(orditm,"||",2)
	
    i ..CheckDrugZsFlag(orditm)=1 q 1
    q 0
}

/// 判断医嘱是否属于注射剂
ClassMethod CheckDrugZsFlag(oeori) As %String
{
	q:oeori="" 0
	s hospID = ""
	i $g(oeori)'="" d
	.s ord=$p(oeori,"||",1)
	.s itm=$p(oeori,"||",2)
	.s arcimid=$p(^OEORD(ord,"I",itm,1),"^",2)  ;医嘱 ARC_ItmMast ARCIM_RowId
	.s itmmastid=$p(arcimid,"||",1)
	.s itmmastver=$p(arcimid,"||",2)
	.s phcdr=$p(^ARCIM(itmmastid,itmmastver,1),"^",12)
	.s tmpformdr=$p($g(^PHCD(+phcdr,"DF",$p(phcdr,"||",2),1)),"^",1) 
	.s instdr=$p($g(^OEORD(ord,"I",itm,2)),"^",7)
	.s hospID=$p($g(^CTLOC(+$p($g(^OEORD(ord,"I",itm,1)),"^",3))),"^",22)
	s ret=0
	s inst=""
	f  s inst=$o(^DHCPCINST(inst)) q:(inst="")||(ret=1)  d
	.q:(##class(PHA.FACE.IN.Com).GetShowDataFlag("DHC_PHCNTSINSTRUC",inst,hospID)="N")
	.s dhcinstdr=$p(^DHCPCINST(inst),"^",1)
	.s formdr=$p(^DHCPCINST(inst),"^",2)
	.i (instdr=dhcinstdr)||($g(tmpformdr)'=""&(formdr'="")&(formdr=$g(tmpformdr))) d
	..s ret=1
	
	q ret
}

/// Description:取患者体重
ClassMethod GetPatWeight(paadm) As %String
{
	
	Q:paadm="" ""
	Q:'$D(^PAADM(paadm)) ""
	S mradm=$P(^PAADM(paadm),"^",61)
	Q:mradm="" ""
	Q:'$D(^MR(mradm,"PRO",1)) ""
	S weight=$P(^MR(mradm,"PRO",1),"^",27)
	S:weight'="" weight=weight_"KG"
	Q weight
}

/// Description:取患者身高
ClassMethod GetPatHeight(paadm) As %String
{
	
	Q:paadm="" ""
	Q:'$D(^PAADM(paadm)) ""
	S mradm=$P(^PAADM(paadm),"^",61)
	Q:mradm="" ""
	Q:'$D(^MR(mradm,"PRO",1)) ""
	S Height=$P(^MR(mradm,"PRO",1),"^",20)
	S:Height'="" Height=Height_"CM"
	Q Height
}

/// description: 体温单体重身高等
/// input:		 admId:就诊id,obsItmCode:信息类型,obsDate:录入日期(空时取最新)
/// tables:		 MR_Observations,MRC_ObservationItem
/// output:		 数据(标准单位)
/// w ##class(web.DHCSTCNTSCOMMON).GetMrObsItm(1143,"weight",64880)
ClassMethod GetMrObsItm(admId, obsItmCode, obsDate = "")
{
	i obsDate="" s obsDate=+$h+1
	e  s obsDate=obsDate+1
	Q:(admId="")||(obsItmCode="") ""
	Q:'$D(^PAADM(admId)) ""
	S mrAdmId=$P(^PAADM(admId),"^",61)
	Q:mrAdmId="" ""	
	s obsItmId=$o(^MRC("OBITM",0,"Code",$$ALPHAUP^SSUTIL4(obsItmCode),""))
	q:obsItmId="" ""
	s obsLastDate=$o(^MR(mrAdmId,"OBS",0,"Item",obsItmId,obsDate),-1)
	q:obsLastDate="" ""
	s obsTime=$o(^MR(mrAdmId,"OBS",0,"Item",obsItmId,obsLastDate,""),-1)
	q:obsTime="" ""
	s obsSub=$o(^MR(mrAdmId,"OBS",0,"Item",obsItmId,obsLastDate,obsTime,""),-1)
	q:obsSub="" ""
	s obsValue=$p($g(^MR(mrAdmId,"OBS",obsSub)),"^",2)
	i obsValue'="" d
	.i ($ZCVT(obsItmCode,"U")="WEIGHT")&&($zcvt(obsValue,"U")'["KG") s obsValue=obsValue_"kg"
	.i ($ZCVT(obsItmCode,"U")="HEIGHT")&&($zcvt(obsValue,"U")'["CM") s obsValue=obsValue_"cm"
	q obsValue
}

/// 获取本次医嘱列表
/// 810,0,200,,1
/// w ##class(web.DHCSTCNTSCOMMON).GetOrdItemDsByAdm(1769,0,200,"",1)
ClassMethod GetOrdItemDsByAdm(adm, stpage, limit, prival, findflag) As %String
{
	//s ^tmyq("GetOrdItemDsByAdm")=adm_","_stpage_","_limit_","_prival_","_findflag
	s pid=##class(web.DHCSTCNTSCOMMON).GetPHCNTSPID()
	s endpage=stpage+limit  //结束行
	s stpage=stpage+1 //开始行
	s h=0
	s ord=""
	f  s ord=$o(^OEORD(0,"Adm",adm,ord)) q:ord=""  d
	.s chl=0
	.f  s chl=$o(^OEORD(ord,"I",chl)) q:(chl=0)||(chl="")  d
	..s orditm=ord_"||"_chl
	..s presc=$p(^OEORD(ord,"I",chl,1),"^",14) ;处方号
	..q:presc=""
	..s arcimid=$p(^OEORD(ord,"I",chl,1),"^",2)  ;医嘱 ARC_ItmMast ARCIM_RowId
	..s itmmastid=$p(arcimid,"||",1)
	..s itmmastver=$p(arcimid,"||",2)
	..s inci=$o(^INCI(0,"ARCIM_DR",$p(arcimid,"||",1),"") ) q:inci=""  //医嘱名称
	..s stkcatdr=$p(^INCI(inci,2),"^",2)	//库存分类 INC_StkCat
	..q:stkcatdr="" 	//过滤掉库存分类不存在
	..;类组与库存分类关联表 DHC_StkCatGrpRelations
	..s scgdr=$o(^DHCSCG("STKCAT",stkcatdr,""))	
	..q:scgdr=""
	..s scgtype=$p(^DHCSCG(scgdr),"^",3)	//DHC_StkCatGroup
	..q:scgtype'="G"	//过滤掉非药品医嘱
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
	..q:'$d(^OEORD(ord,"I",chl,2))
	..s dosage=$p($g(^OEORD(ord,"I",chl,2)),"^",1) ;剂量
	..i (dosage'="")&&($l($p(dosage,",",2))>3) s dosage=$j(dosage,"",3)
    ..s doseuom=""
	..s dosuomID=$p(^OEORD(ord,"I",chl,2),"^",3)
	..i dosuomID'="" d
	...s doseuom=$p($g(^CT("UOM",dosuomID)),"^",2) ;剂量单位
	..s freq=""
	..s freqdr=$p($g(^OEORD(ord,"I",chl,2)),"^",4) ;OEORI_PHFreq_DR
    ..i freqdr'="" s freq=$p($g(^PHCFR(freqdr)),"^",3)  ;频率
    ..s instru=""
    ..s instrudr=+$p(^OEORD(ord,"I",chl,2),"^",7)
    ..s:instrudr'=0 instru=$p(^PHCIN(instrudr),"^",2)        	;用法
    ..s duration=""
    ..s durationdr=+$p(^OEORD(ord,"I",chl,2),"^",6)
	..s:durationdr'=0 duration=$p(^PHCDU(durationdr),"^",1)         	;用药疗程
	..s priorty="",priortycode=""
	..s pri=+$p(^OEORD(ord,"I",chl,1),"^",8)
	..i pri'=0 d
	...s priorty=$p(^OECPR(pri),"^",2)   		;医嘱优先级
	...s priortycode=$p(^OECPR(pri),"^",1)  		;医嘱优先级
	..q:(prival="1")&(priortycode'="S")
	..q:(prival="2")&(priortycode="S")
	..s doctor=##class(web.DHCSTCOMMONSRV).getOrdDoctor(orditm)       ;医生
	..s skintest=##class(web.DHCSTCOMMONSRV).GetSkinTestResult(orditm)  ;皮试
	..s form=##class(web.DHCSTCOMMONSRV).GetForm(inci)  ;剂型
	..i $F(form,$c(13)) s form=$p(form,$c(13))
	..s spec=##class(web.DHCSTCOMMONSRV).getBarcode(inci) ;规格
	..s manf=##class(web.DHCSTITMDESC).GetManfNameByInci(inci) ;厂家
	..i $f(manf,"-") s manf=$p(manf,"-",2)
	..s remark=##class(web.DHCSTCOMMONSRV).GetOrdItmRemark(orditm) ;备注
	..i remark="" s remark=$p($g(^OEORD(ord,"I",chl,2)),"^",8) //草药备注
	..s realdura=1  //##class(web.DHCSTCNTSCOMMON).GetRealDuration(orditm) ;实际疗程
	..s realdura=realdura*qty
	..s statdr=$p(^OEORD(ord,"I",chl,1),"^",13)
	..s ordstatus=$p(^OEC("OSTAT",statdr),"^",2) 
	..q:ordstatus="停止"
	..s basflag=""
	..s infor=$o(^DHCITMINFO(0,"INCI",inci,""))
	..i infor'="" s basflag=$p(^DHCITMINFO(infor),"^",4)
	..s orddate=$p(^OEORD(ord,"I",chl,3),"^",7)
	..i orddate'="" s orddate=##class(websys.Conversions).DateLogicalToHtml(orddate)
    ..s ordtime=$p(^OEORD(ord,"I",chl,3),"^",15)
    ..i ordtime'="" s ordtime=##class(websys.Conversions).TimeLogicalToHtml(ordtime)
    ..s orddatetime=orddate_" "_ordtime  ;开单日期
	..//s dsp=""
	..//f  s dsp=$o(^DHCOEDISQTY(0,"OEORI",orditm,dsp)) q:dsp=""  d
	...//s status=$p(^DHCOEDISQTY(dsp),"^",7)
	...//q:status="R"
    ..//.s orddate=$p(^DHCOEDISQTY(dsp),"^",15)
    ..//.i orddate'="" s orddate=$zd(orddate,3)
    ..//.s ordtime=$p(^DHCOEDISQTY(dsp),"^",16)
    ..//.i ordtime'="" s ordtime=$zt(ordtime,1)
    ..//.s orddatetime=orddate_" "_ordtime  ;开单日期
    ..//.s h=h+1
    ..//.s data=skintest_" "_inciDesc_"^"_qty_"^"_uomdesc_"^"_dosage_doseuom_"^"_freq_"^"_spec_"^"_instru_"^"_duration_"^"_form
    ..//.s data=data_"^"_priorty_"^"_doctor_"^"_orddatetime_"^"_remark_"^"_manf_"^"_basflag_"^"_presc
    ..//.s ^TMP("dhcpha","DHCSTCNTSCOMMON","GetOrdItemDsByAdm",pid,h)=data
    ..s h=h+1
    ..s data=skintest_" "_inciDesc_"^"_qty_"^"_uomdesc_"^"_dosage_doseuom_"^"_freq_"^"_spec_"^"_instru_"^"_duration_"^"_form
    ..s data=data_"^"_priorty_"^"_doctor_"^"_orddatetime_"^"_remark_"^"_manf_"^"_basflag_"^"_presc_"^"_ordstatus
    ..s ^TMP("dhcpha","DHCSTCNTSCOMMON","GetOrdItemDsByAdm",pid,h)=data
    
    q:h=0 ##class(web.DHCSTEXTCOMMON).GetNoJson()
    s maxrow=h
    i endpage>maxrow s endpage=maxrow
    s count=0
    s h=""
    f  s h=$o(^TMP("dhcpha","DHCSTCNTSCOMMON","GetOrdItemDsByAdm",pid,h)) q:h=""  d
    .s data=^TMP("dhcpha","DHCSTCNTSCOMMON","GetOrdItemDsByAdm",pid,h)
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
    .s presc=$p(data,"^",16)
    .s ordstatus=$p(data,"^",17)
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
	.s presc=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("presc",presc)
	.s ordstatus=##class(web.DHCSTEXTCOMMON).GetJsonLastCell("ordstatus",ordstatus)
	.s tmpstr=incidesc_qty_uomdesc_dosage_freq_spec_instruc_dura_form_pri_doctor_orddate_remark_manf_basflag_presc_ordstatus
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
    
    
    k ^TMP("dhcpha","DHCSTCNTSCOMMON","GetOrdItemDsByAdm",pid)
    q ""
}

/// 获取处方金额信息
ClassMethod GetPreAmtData(prescno) As %String
{
	s HospID=""
	s totalamt=0,anttotalamt=0
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
	..s arcimid=$p(^OEORD(ord,"I",chl,1),"^",2)  ;医嘱 ARC_ItmMast ARCIM_RowId
	..s itmmastid=$p(arcimid,"||",1)
	..s itmmastver=$p(arcimid,"||",2)
	..s tmpinci=$o(^INCI(0,"ARCIM_DR",$p(arcimid,"||",1),"") ) 
	..q:tmpinci=""  //医嘱名称
	..s puomdr=$p(^ARCIM(itmmastid,itmmastver,8),"^",14)
	..s buomdr=$p(^INCI(inci,1),"^",10)
	..s dspdate=+$h
	..s payflag=$p(^OEORD(ord,"I",chl,3),"^",5)	
	..s status=$p(^DHCOEDISQTY(dsp),"^",7)
	..s statdr=$p(^OEORD(ord,"I",chl,1),"^",13)
	..s oeflag=$p(^OEC("OSTAT",statdr),"^",1) 
	..i status="C" s dspdate=$p(^DHCOEDISQTY(dsp),"^",8)
	..q:(payflag'="P")&(oeflag'="V")&(oeflag'="E")&(status'="C")
	..//s price=##class(web.DHCSTCOMMONSRV).GetPriceElse(+tmpinci,dspdate,buomdr,"")
	..//s exStr="^"_dsp
	..//s price=##class(web.DHCSTPRICE).GetSp(+tmpinci,dspdate,buomdr,HospID,"",exStr)	//zhouyg 20150113
    ..//s qty=$p(^DHCOEDISQTY(dsp),"^",2)
	..//s amt=$fn(price*qty,"",2)
	..// 医嘱结构改造后价格取打包批次表中的
	..s amtstr=..GetAmtByDsp(dsp)
	..s amt=$p(amtstr,"^",2)
	..s antflag=..GetAntibioticFlag(orditm)
	..i antflag=1 s anttotalamt=anttotalamt+amt
	..s totalamt=totalamt+amt //处方金额
	s totalamt=..ChangToNum(totalamt)
	s anttotalamt=..ChangToNum(anttotalamt)
	q totalamt_"^"_anttotalamt
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
	q 1
}

/// 获取方式ID
ClassMethod GetWayIdByCode(Code) As %String
{
  
   s ret=""
   s way="0"
   f  s way=$o(^DHCPCWAY(way)) q:way=""  d
   .s waycode=$p(^DHCPCWAY(way),"^",1)
   .q:waycode'=Code
   .s ret=way
   q ret
}

/// 是否审核通过 1拒绝  2申诉  3通过  0未审 　4拒绝接受 5拒绝发药
/// Creator:LiangQiang 
/// 2014-12-25
/// w ##class(web.DHCSTCNTSCOMMON).CheckPrescNoStatus("O17041000001","OR")
ClassMethod CheckPrescNoStatus(prescno, type = "") As %String
{
   q:prescno="" 0
   s retstr=""
   s status=""
   s DocNote=""
   s argflag=""
   s exit=0
   s ret=0
   s phaomid=""
   f  s phaomid=$o(^DHCPHORDM(0,"PrescNo",prescno,phaomid),-1) q:(phaomid="")||(exit=1)  d
   .s apptype=$p(^DHCPHORDM(phaomid),"^",9)
   .q:(apptype'=type)&(type'="")
   .s canceluser=$p(^DHCPHORDM(phaomid),"^",12)
   .q:(canceluser'="")
   .s status=$p(^DHCPHORDM(phaomid),"^",2)
   .s DocNote=$p(^DHCPHORDM(phaomid),"^",7)
   .s agreeflag=$p(^DHCPHORDM(phaomid),"^",8)
   .i (status="N")&(DocNote="") s ret=1
   .i (status="N")&(DocNote'="") s ret=2
   .i (status="A")&(DocNote'="")&&(agreeflag'="Y") s ret=2
   .i status="Y" s ret=3
   .i agreeflag="Y"  s ret=4
   .s exit=1
   .i status="" s ret=0 //yunhaibao20160519
   q ret
}

/// Author : MYQ
/// CreatDate : 2015-04-28
/// Description : 取诊断以及辩证
/// w ##class(web.DHCSTCNTSCOMMON).GetMRDiagnosDescAndSign("4177",",")
ClassMethod GetMRDiagnosDescAndSign(MRAdmRowid As %String, DelimStr As %String) As %String
{
 // n (MRAdmRowid,DelimStr)
 q:MRAdmRowid="" ""
 s MRAdmRowid=$p($g(^PAADM(MRAdmRowid)),"^",61)
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
 .if MRDesc'="" s MRDesc=$LIST(MRDesc,1)
 .s sign=""
 .s sign=##class(web.DHCSTCNTSCOMMON).GetSignSymByDiagnos(MRAdmRowid,Rowid)
 .i (Desc'="")&(sign'="") s Desc=Desc_sign
 .i Desc="" s Desc=MRDesc_sign
 .e  d
 ..i MRDesc'="" s Desc=Desc_"("_MRDesc_sign_")"
 .s i=i+1
 .s Desc=i_"."_Desc
 .if retval="" s retval=Desc
 .e  s retval=retval_DelimStr_Desc
 d obj.Close()
 q $ZCVT($g(retval),"O","JS")
}

/// 获取诊断对应的证
ClassMethod GetSignSymByDiagnos(MRAdmRowid As %String, MRDiagnoseRowid As %String) As %String
{
	s SyndRowid="", DescList=""
	s Adm=$p(^MR(MRAdmRowid,"PRO",1),"^",9)
	f  s SyndRowid=$o(^DHCDocSYND("0","ADMDiagnos",Adm,MRDiagnoseRowid,SyndRowid))  q:SyndRowid=""  d
	.s Sign1=$p(^DHCDocSYND(SyndRowid),"^",7)
	.s Sign2=$p(^DHCDocSYND(SyndRowid),"^",8)
	.s Sign3=$p(^DHCDocSYND(SyndRowid),"^",9)  
	.s Sign4=$p(^DHCDocSYND(SyndRowid),"^",10)
	.i Sign1'="" s Sign1Desc1=$p($g(^MRC("DSYM",Sign1)),"^",2) ,DescList=DescList_" "_Sign1Desc1
	.i Sign2'="" s Sign1Desc2=$p($g(^MRC("DSYM",Sign2)),"^",2) ,DescList=DescList_" "_Sign1Desc2
	.i Sign3'="" s Sign1Desc3=$p($g(^MRC("DSYM",Sign3)),"^",2) ,DescList=DescList_" "_Sign1Desc3
	.i Sign4'="" s Sign1Desc4=$p($g(^MRC("DSYM",Sign4)),"^",2) ,DescList=DescList_" "_Sign1Desc4
	q DescList
}

/// w ##class(web.DHCSTCNTSCOMMON).GetCurPhoResultByPresc("O17021600003")
ClassMethod GetCurPhoResultByPresc(prescno As %String, type = "") As %String
{
	 s result=..CheckPrescNoStatus(prescno,type)
     i result="1" s result="拒绝"
     e  i result="2" s result="申诉"
     e  i result="3" s result="通过"
     e  i result="4" s result="拒绝(接受)"
     e  i result="0" s result=""
     e  s result=""
     q result
}

/// Description:根据处方号获取医生申诉信息
/// Creator:	yunhaibao
/// CreatDate:	2016-03-28
/// Input：		处方号
/// Output:	　　申诉内容
/// w ##class(web.DHCSTCNTSCOMMON).GetOrdAppealReasonByPresc("O17041000001","OR")
ClassMethod GetOrdAppealReasonByPresc(prescno, type = "") As %String
{
   q:prescno="" ""
   s retstr=""
   s status=""
   s DocNote=""
   s argflag=""
   s exit=0
   s ret=0
   s phaomid=""
   f  s phaomid=$o(^DHCPHORDM(0,"PrescNo",prescno,phaomid),-1) q:(phaomid="")||(exit=1)  d
   .s apptype=$p(^DHCPHORDM(phaomid),"^",9)
   .q:(apptype'=type)&(type'="")
   .s status=$p(^DHCPHORDM(phaomid),"^",2)
   .s DocNote=$p(^DHCPHORDM(phaomid),"^",7)
   .s argflag=$p(^DHCPHORDM(phaomid),"^",8)
   .i (status="N")&(DocNote="") s ret=1
   .i (status="N")&(DocNote'="") s ret=2
   .i (status="A")&(DocNote'="") s ret=2
   .q:ret'=2
   .s exit=1
   q DocNote
}

/// Author : MYQ
/// CreatDate : 20160617
/// Description : 获取病人费别列表
/// Table : APC_AdmReason
/// w ##class(web.DHCSTCNTSCOMMON).GetAdmReasonDs()
ClassMethod GetAdmReasonDs() As %String
{
	s pid=##class(web.DHCSTCNTSCOMMON).GetPHCNTSPID()
	s h=0
	s reaid=0
	f  s reaid=$o(^PAC("ADMREA",reaid)) q:reaid=""  d
	.s todate=$p(^PAC("ADMREA",reaid),"^",4)
	.q:(todate'="")&&(todate'>+$h)
	.s readesc=$p(^PAC("ADMREA",reaid),"^",2)
	.s h=h+1
    .s data=readesc_"^"_reaid
    .s ^TMP("dhcpha","DHCSTCNTSCOMMON","GetAdmReasonDs",pid,h)=data
    q:h=0 ##class(web.DHCSTEXTCOMMON).GetNoJson()
    s maxrow=h
    
    s count=0
    s h=""
    f  s h=$o(^TMP("dhcpha","DHCSTCNTSCOMMON","GetAdmReasonDs",pid,h)) q:h=""  d
    .s data=^TMP("dhcpha","DHCSTCNTSCOMMON","GetAdmReasonDs",pid,h)
    .s desc=$p(data,"^",1)
    .s rowid=$p(data,"^",2)
    .
    .s billdesc=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("billdesc",desc)
	.s billdr=##class(web.DHCSTEXTCOMMON).GetJsonLastCell("billdr",rowid)
	.
	.s tmpstr=billdesc_billdr
    .s startString=##class(web.DHCSTEXTCOMMON).GetJsonStartString(maxrow)
    .s firstrow=##class(web.DHCSTEXTCOMMON).GetJsonFirstRow(tmpstr)
    .s lastrow=##class(web.DHCSTEXTCOMMON).GetJsonLastRow(tmpstr)
	.s count=count+1
	.i count=1 w startString
    .i count<maxrow w firstrow
    .i count=maxrow w lastrow
	.
	k ^TMP("dhcpha","DHCSTCNTSCOMMON","GetAdmReasonDs",pid)
	q ""
}

/// Author : MaYuqiang
/// Date Created : 20181214
/// Description : 根据打包表id获取进售价金额
/// Input : 打包主表id(DHC_OEDispensing)
/// Output : 进价金额^售价金额
/// 
ClassMethod GetAmtByDsp(dspid) As %String
{
	q:+dspid="" ""
	s reclocid=$p($g(^DHCOEDISQTY(dspid)),"^",24)
	s hospid=$s(+reclocid'=0:$p($g(^CTLOC(reclocid)),"^",22),1:"")
	s rpamtsum=0,spamtsum=0
	s dspsub="0"
	f  s dspsub=$o(^DHCOEDISQTY(dspid,"I",dspsub)) q:dspsub=""  d
	.s dspbatchdata=$g(^DHCOEDISQTY(dspid,"I",dspsub))
	.s qty=$p(dspbatchdata,"^",2)
	.s rp=$p(dspbatchdata,"^",3)
	.s sp=$p(dspbatchdata,"^",4)
	.s rpamt=rp*qty
	.s spamt=sp*qty
	.s rpamt=##class(web.DHCST.Common.AppCommon).FormatRpAmt(rpamt,hospid)
	.s spamt=##class(web.DHCST.Common.AppCommon).FormatSpAmt(spamt,hospid)
	.s rpamtsum=rpamtsum+rpamt
	.s spamtsum=spamtsum+spamt
	
	q rpamtsum_"^"_spamtsum
}

/// Author : MaYuqiang
/// Date Created : 20190107
/// Description : 根据点评子表获取医嘱id点评原因串
/// Input : pcntsitm - 点评子表id
/// Output : 医嘱id1,医嘱id2$$不合理原因1；不合理原因2^医嘱id3$$不合理原因3^医嘱id4$$不合理原因4...
/// w ##class(web.DHCSTCNTSCOMMON).GetCommonReason("43||3")
ClassMethod GetCommonReason(pcntsitm) As %String
{
	s cpcnts=+pcntsitm
	s citm=$p(pcntsitm,"||",2)
	q:+citm=0 ""
	k ComLogData			//点评数据信息
	s clitm=""
	f  s clitm=$o(^DHCPHCNTS(cpcnts,"I",citm,"L",clitm)) q:clitm=""  d
	.s clogdata=$g(^DHCPHCNTS(cpcnts,"I",citm,"L",clitm))
	.s cavtive=$p(clogdata,"^",11)
	.q:cavtive'="Y"
	.s grpno=$p(clogdata,"^",12)
	.s creasondr=+$p(clogdata,"^",1)		//点评原因
	.i $d(ComLogData(grpno,"creasondr")) d
	..s lastData=$g(ComLogData(grpno,"creasondr"))
	..s ComLogData(grpno,"creasondr")=lastData_","_creasondr
	.e  d
	..s ComLogData(grpno,"creasondr")=creasondr
	.s cpcntsil=cpcnts_"||"_citm_"||"_clitm
	.s pctid=""
	.f  s pctid=$o(^DHCPCTABL(0,"LOG",cpcntsil,pctid)) q:pctid=""  d
	..s corditm=$p(^DHCPCTABL(pctid),"^",1)		//医嘱id
	..i $d(ComLogData(grpno,"corditm")) d
	...s lastOrdData=$g(ComLogData(grpno,"corditm"))
	...s ComLogData(grpno,"corditm")=lastOrdData_","_corditm
	..e  d
	...s ComLogData(grpno,"corditm")=corditm
	..
	s reasonstr=""	//医嘱id+原因
	s grpno=0
	f  s grpno=$o(ComLogData(grpno)) q:grpno=""  d
	.s creasonStr="",corditmStr=""		//原因串，医嘱串
	.s reasonIdStr=$g(ComLogData(grpno,"creasondr"))
	.f reasonIdNum=1:1:$l(reasonIdStr,",") d
	..s creasondr=$p(reasonIdStr,",",reasonIdNum)
	..s cReasonDesc=$p($g(^DHCPCREASON(+creasondr)),"^",2)
	..i creasonStr="" d
	...s creasonStr=cReasonDesc
	..e  d
	...s creasonStr=creasonStr_"；"_cReasonDesc
	.s corditmStr=$g(ComLogData(grpno,"corditm"))
	.s logReaOrdData=corditmStr_"$$"_creasonStr
	.i reasonstr="" d
	..s reasonstr=logReaOrdData
	.e  d
	..s reasonstr=reasonstr_"^"_logReaOrdData
	
	k ComLogData
	q reasonstr
}

/// Description		-1~1 之间的补0
/// w ##class(web.DHCSTCNTSCOMMON).ChangToNum(0.1)
ClassMethod ChangToNum(val)
{
	s val=+val
	i (val>0)&(val<1) s val=0_val
	i (val<0)&(val>-1) d
	.s val=-val
	.s val="-0"_val
	q val
}

}
