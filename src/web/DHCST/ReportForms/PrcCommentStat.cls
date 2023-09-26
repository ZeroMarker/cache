/// Description:处方点评相关类报表
/// Creator:    hulihua
/// CreateDate: 2018-07-11
/// Table:
Class web.DHCST.ReportForms.PrcCommentStat Extends (%RegisteredObject, websys.Abstract) [ ClassType = "", ProcedureBlock ]
{

///  抗菌药明细（住院）  by suiguoyang20180122
///  last modified by MaYuqiang 20190110 能区分出门诊和住院的统计
/// d ##class(%ResultSet).RunQuery("web.DHCST.ReportForms.PrcCommentStat","GetKJInfoByPhaData","2018-07-07","2018-08-01","1","","","","")
Query GetKJInfoByPhaData(SDate = "", EndDate = "", Ctype = "", PcntsNo = "", poisonstr = "", Cphcsubcat = "", Carcitmid = "", HOSPID As %String = "") As websys.Query(ROWSPEC = "inciDesc,spec,manf,uomdesc,price:%Float,qty:%Float,amt:%Float") [ SqlProc ]
{
}

ClassMethod GetKJInfoByPhaDataExecute(ByRef qHandle As %Binary, SDate = "", EndDate = "", Ctype = "", PcntsNo = "", poisonstr = "", Cphcsubcat = "", Carcitmid = "", HOSPID As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
    Set qHandle=$lb(0,repid,0)
    s ind=1
    q:SDate="" $$$OK
    q:EndDate="" $$$OK
    q:Ctype="" $$$OK
    //s ^hlh($h)=$lb(SDate, EndDate, Ctype, PcntsNo, poisonstr, Cphcsubcat, Carcitmid)
    i Ctype=0  s Ctype="F"
    e  s Ctype="P"
	s HospID=""
    s h=0
    s PhaLocId="",PhaLocStr=""
	f  s PhaLocId=$o(^CTLOC(0,"LocType","D",PhaLocId)) q:PhaLocId=""  d
	.s dhclocdr=$o(^DHCLOC(0,"LOC",PhaLocId,""))
 	.s loctype=$s(dhclocdr'="":$p(^DHCLOC(dhclocdr),"^",5),1:"") //库房类别（"R"-"药库";"I"-"住院药房";"O"-"门诊药房";"A"-"器械材料";"G"-"总务药房";"E"-"其他";）
	.q:(loctype'="I")&&(loctype'="O")
	.s PhaLocStr=$s(PhaLocStr'="":PhaLocStr_","_PhaLocId,1:PhaLocId)
	q:PhaLocStr="" $$$OK
    s pid=..NewPid()
	d ..ClearTmp("GetKJInfoByPhaData",pid,"Index")
	s qstdate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(SDate)
	s qenddate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(EndDate)
	s type=Ctype
	
	
	f date=qstdate:1:qenddate d
	.s pcnts=""
	.f  s pcnts=$o(^DHCPHCNTS(0,"Date",date,type,pcnts)) q:pcnts=""  d
	..s pcntData=$g(^DHCPHCNTS(pcnts))
	..s hospital=$p(^DHCPHCNTS(pcnts),"^",8)
	..q:(HOSPID'="")&(HOSPID'=hospital)   //过滤病区
	..s reSaveFlag=$p(pcntData,"^",13)		//二次抽取标志
	..q:reSaveFlag="Y"
	..s pcntsno=$p(^DHCPHCNTS(pcnts),"^",1)
	..q:(PcntsNo'="")&&(pcntsno'=PcntsNo)   ;添加单号查询条件 
	..s pcntsdate=$p(^DHCPHCNTS(pcnts),"^",2)
	..i pcntsdate'="" s pcntsdate=##class(websys.Conversions).DateLogicalToHtml(pcntsdate)
	..s pcntstime=$p(^DHCPHCNTS(pcnts),"^",3)
	..i pcntstime'="" s pcntstime=##class(websys.Conversions).TimeLogicalToHtml(pcntstime)
	..s pcntstext=$p(^DHCPHCNTS(pcnts),"^",4)
	..s pcntsuserdr=$p(^DHCPHCNTS(pcnts),"^",6)
	..s pcntsuser=$p(^SSU("SSUSR",pcntsuserdr),"^",2)
	..s tchl=""
	..f  s tchl=$o(^DHCPHCNTS(pcnts,"I",tchl)) q:tchl=""  d
	...s prescno=$p(^DHCPHCNTS(pcnts,"I",tchl),"^",1)
	...s pcntsitm=pcnts_"||"_tchl
	...s adm=$p(^DHCPHCNTS(pcnts,"I",tchl),"^",3)
    ...s ord=$o(^OEORD(0,"Adm",adm,""))  
    ...q:ord="" 
    ...s prescno=$p(^DHCPHCNTS(pcnts,"I",tchl),"^",1)	//处方号
    ...i type="P" d
    ....d GetIPCommentData
    ...e  d
    ....d GetOPCommentData
    ....
    s inciDesc=""
    f  s inciDesc=$o(^TMP("DHCPRC",$this,"GetKJInfoByPhaData",pid,"Index",inciDesc)) q:(inciDesc="")  d
    .s spec=^TMP("DHCPRC",$this,"GetKJInfoByPhaData",pid,"Index",inciDesc,"spec")
    .s manf=^TMP("DHCPRC",$this,"GetKJInfoByPhaData",pid,"Index",inciDesc,"manf")
    .s qty=^TMP("DHCPRC",$this,"GetKJInfoByPhaData",pid,"Index",inciDesc,"qty")
    .s uomdesc=^TMP("DHCPRC",$this,"GetKJInfoByPhaData",pid,"Index",inciDesc,"uomdesc")
    .s price=^TMP("DHCPRC",$this,"GetKJInfoByPhaData",pid,"Index",inciDesc,"price")
    .s amt=^TMP("DHCPRC",$this,"GetKJInfoByPhaData",pid,"Index",inciDesc,"amt")
    .d OutRow
    d ..ClearTmp("GetKJInfoByPhaData",pid,"Index")
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
    
    
GetIPCommentData    
	s cnt=$l(PhaLocStr,",")
	f i=1:1:cnt d
	.s recdpdr=$p(PhaLocStr,",",i)
	.i HospID="" s HospID=$p($g(^CTLOC(recdpdr)),"^",22)
	.s chl=""
	.f  s chl=$o(^OEORDi(0,"RecDepOrd",ord,recdpdr,chl)) q:chl=""  d
	..s orditm=ord_"||"_chl
	..s arcimid=$p(^OEORD(ord,"I",chl,1),"^",2)  ;医嘱 ARC_ItmMast ARCIM_RowId
	..s phcsubcat=##class(web.DHCSTCNTSCOMMON).PhaSubCatByArcim(arcimid)
	..q:(Cphcsubcat'="")&&(phcsubcat'=Cphcsubcat)
	..s itmmastid=$p(arcimid,"||",1)
	..s itmmastver=$p(arcimid,"||",2)
	..s arcitmid=$p(^ARCIM(itmmastid,itmmastver,1),"^",10)
	..q:(Carcitmid'="")&&(arcitmid'=Carcitmid)
    ..s PhcdfId=##class(web.DHCST.Common.DrugInfoCommon).GetPhcdfByArcim(arcimid)
	..s antibiotic=##class(web.DHCST.Common.DrugInfoCommon).GetAntiFlagByPhcdf(PhcdfId) 
    ..q:antibiotic'="Y"
    ..s dspid=""
    ..f  s dspid=$o(^DHCOEDISQTY(0,"OEORI",orditm,dspid)) q:dspid=""  d
    ...s dspsub=""
    ...f  s dspsub=$o(^DHCOEDISQTY(dspid,"I",dspsub)) q:dspsub=""  d
    ....q:'$d(^DHCOEDISQTY(dspid,"I",dspsub))
    ....s inci=$p(^DHCOEDISQTY(dspid,"I",dspsub),"^",5)		//库存项id
    ....s drugpoisonstr=##class(web.DHCSTCOMMONSRV).getPoisonByInci(inci)
	....s drugpoisondr=$p(drugpoisonstr,"^",1)
	....q:(poisonstr'="")&&(drugpoisondr'=poisonstr)  //管制分类
    ....s bqty=$p(^DHCOEDISQTY(dspid,"I",dspsub),"^",2)
    ....q:+bqty=0
    ....s brp=$p(^DHCOEDISQTY(dspid,"I",dspsub),"^",3)
    ....s bsp=$p(^DHCOEDISQTY(dspid,"I",dspsub),"^",4)
    ....s rpamt=bqty*bqty
    ....s rpamt=##class(web.DHCST.Common.AppCommon).FormatRpAmt(rpamt,HospID)
    ....s spamt=bqty*bsp
    ....s spamt=##class(web.DHCST.Common.AppCommon).FormatSpAmt(spamt,HospID)
    ....s inciDesc=$p(^INCI(inci,1),"^",2) //药品名称
    ....s buomid=$p(^INCI(inci,1),"^",10)	//基本单位
    ....s buomdesc=$p($g(^CT("UOM",buomid)),"^",2)
    ....s spec=##class(PHA.COM.Drug).GetSpec(inci) ;规格
	....s manf=$lg(##class(PHA.COM.Drug).GetManf(inci),3)    ;厂家
	....i $f(manf,"-") s manf=$p(manf,"-",2)
    ....
	....s ^TMP("DHCPRC",$this,"GetKJInfoByPhaData",pid,"Index",inciDesc,"spec")=spec
    ....s ^TMP("DHCPRC",$this,"GetKJInfoByPhaData",pid,"Index",inciDesc,"manf")=manf
    ....s ^TMP("DHCPRC",$this,"GetKJInfoByPhaData",pid,"Index",inciDesc,"qty")=$g(^TMP("DHCPRC",$this,"GetKJInfoByPhaData",pid,"Index",inciDesc,"qty"))+bqty
    ....s ^TMP("DHCPRC",$this,"GetKJInfoByPhaData",pid,"Index",inciDesc,"uomdesc")=buomdesc
    ....s ^TMP("DHCPRC",$this,"GetKJInfoByPhaData",pid,"Index",inciDesc,"price")=bsp
    ....s ^TMP("DHCPRC",$this,"GetKJInfoByPhaData",pid,"Index",inciDesc,"amt")=$g(^TMP("DHCPRC",$this,"GetKJInfoByPhaData",pid,"Index",inciDesc,"amt"))+spamt
	q ""
	
GetOPCommentData
	s ord=$o(^OEORD(0,"PrescNo",prescno,""),-1)
	s chl=""
	f  s chl=$o(^OEORD(0,"PrescNo",prescno,ord,chl)) q:chl=""  d
	.s orditm=ord_"||"_chl
	.s arcimid=$p(^OEORD(ord,"I",chl,1),"^",2)  ;医嘱 ARC_ItmMast ARCIM_RowId
	.s phcsubcat=##class(web.DHCSTCNTSCOMMON).PhaSubCatByArcim(arcimid)
	.q:(Cphcsubcat'="")&&(phcsubcat'=Cphcsubcat)
	.s itmmastid=$p(arcimid,"||",1)
	.s itmmastver=$p(arcimid,"||",2)
	.s arcitmid=$p(^ARCIM(itmmastid,itmmastver,1),"^",10)
	.q:(Carcitmid'="")&&(arcitmid'=Carcitmid)
    .s PhcdfId=##class(web.DHCST.Common.DrugInfoCommon).GetPhcdfByArcim(arcimid)
	.s antibiotic=##class(web.DHCST.Common.DrugInfoCommon).GetAntiFlagByPhcdf(PhcdfId) 
    .q:antibiotic'="Y"
    .s dspid=""
    .f  s dspid=$o(^DHCOEDISQTY(0,"OEORI",orditm,dspid)) q:dspid=""  d
    ..s dspsub=""
    ..f  s dspsub=$o(^DHCOEDISQTY(dspid,"I",dspsub)) q:dspsub=""  d
    ...q:'$d(^DHCOEDISQTY(dspid,"I",dspsub))
    ...s inci=$p(^DHCOEDISQTY(dspid,"I",dspsub),"^",5)		//库存项id
    ...s drugpoisonstr=##class(web.DHCSTCOMMONSRV).getPoisonByInci(inci)
	...s drugpoisondr=$p(drugpoisonstr,"^",1)
	...q:(poisonstr'="")&&(drugpoisondr'=poisonstr)  //管制分类
    ...s bqty=$p(^DHCOEDISQTY(dspid,"I",dspsub),"^",2)
    ...q:+bqty=0
    ...s brp=$p(^DHCOEDISQTY(dspid,"I",dspsub),"^",3)
    ...s bsp=$p(^DHCOEDISQTY(dspid,"I",dspsub),"^",4)
    ...s rpamt=bqty*bqty
    ...s rpamt=##class(web.DHCST.Common.AppCommon).FormatRpAmt(rpamt,HospID)
    ...s spamt=bqty*bsp
    ...s spamt=##class(web.DHCST.Common.AppCommon).FormatSpAmt(spamt,HospID)
    ...s inciDesc=$p(^INCI(inci,1),"^",2) //药品名称
    ...s buomid=$p(^INCI(inci,1),"^",10)	//基本单位
    ...s buomdesc=$p($g(^CT("UOM",buomid)),"^",2)
    ...s spec=##class(PHA.COM.Drug).GetSpec(inci) ;规格
	...s manf=$lg(##class(PHA.COM.Drug).GetManf(inci),3)    ;厂家
	...i $f(manf,"-") s manf=$p(manf,"-",2)
    ...
	...s ^TMP("DHCPRC",$this,"GetKJInfoByPhaData",pid,"Index",inciDesc,"spec")=spec
    ...s ^TMP("DHCPRC",$this,"GetKJInfoByPhaData",pid,"Index",inciDesc,"manf")=manf
    ...s ^TMP("DHCPRC",$this,"GetKJInfoByPhaData",pid,"Index",inciDesc,"qty")=$g(^TMP("DHCPRC",$this,"GetKJInfoByPhaData",pid,"Index",inciDesc,"qty"))+bqty
    ...s ^TMP("DHCPRC",$this,"GetKJInfoByPhaData",pid,"Index",inciDesc,"uomdesc")=buomdesc
    ...s ^TMP("DHCPRC",$this,"GetKJInfoByPhaData",pid,"Index",inciDesc,"price")=bsp
    ...s ^TMP("DHCPRC",$this,"GetKJInfoByPhaData",pid,"Index",inciDesc,"amt")=$g(^TMP("DHCPRC",$this,"GetKJInfoByPhaData",pid,"Index",inciDesc,"amt"))+spamt
	q ""    
    
OutRow
	set Data=$lb(inciDesc,spec,manf,uomdesc,price,qty,amt)    
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
}

Query GetLocPrescData(SDate = "", EndDate = "", HOSPID As %String = "") As websys.Query(ROWSPEC = "Tdocloc,Tkjnum:%Integer,Tprescnum:%Integer,Tamt:%Float,Tbnum:%Integer,Tzsnum:%Integer,Tnum:%Integer") [ SqlProc ]
{
}

ClassMethod GetLocPrescDataExecute(ByRef qHandle As %Binary, SDate = "", EndDate = "", HOSPID As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
    Set qHandle=$lb(0,repid,0)
    s ind=1
    q:SDate="" $$$OK
    q:EndDate="" $$$OK
  	s pid=..NewPid()
  	d ..ClearTmp("GetLocPrescData",pid,"Index")
	s qstdate=SDate 
	s qenddate=EndDate
	s qstdate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(SDate)
	s qenddate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(EndDate) 
	s pcntstype="F"
	s h=0
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
    
    ....s ^TMP("DHCPRC",$this,"GetLocPrescData",pid,"Index",index)=orddept_"^"_kjnum_"^"_prescnum_"^"_amt_"^"_bnum_"^"_zsnum_"^"_num
    
    s x=0 
    s index=""
    f  s index=$o(^TMP("DHCPRC",$this,"GetLocPrescData",pid,"Index",index)) q:index=""  d
    .s data=^TMP("DHCPRC",$this,"GetLocPrescData",pid,"Index",index)
    .s orddept=$p(data,"^",1)
    .s kjnum=$p(data,"^",2)
    .s prescnum=$p(data,"^",3)
    .s amt=$p(data,"^",4)
    .s bnum=$p(data,"^",5)
    .s zsnum=$p(data,"^",6)
    .s num=$p(data,"^",7)
    .d OutRow
    .
    d ..ClearTmp("GetLocPrescData",pid,"Index")
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutRow
	set Data=$lb(orddept,kjnum,prescnum,amt,bnum,zsnum,num)    
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
}

///  人次比例  by suiguoyang20180122
/// d ##class(%ResultSet).RunQuery("web.DHCST.ReportForms.PrcCommentStat","GetLocPrescPersonData","2020-04-22","2020-05-22")
Query GetLocPrescPersonData(SDate = "", EndDate = "", PcntsNo = "", HOSPID As %String = "") As websys.Query(ROWSPEC = "Torddept,Tkjnum:%Integer,Tbnum:%Integer,Tzsnum:%Integer,Tnum:%Integer") [ SqlProc ]
{
}

ClassMethod GetLocPrescPersonDataExecute(ByRef qHandle As %Binary, SDate = "", EndDate = "", PcntsNo = "", HOSPID As %String = "") As %Status
{
	
	s repid=$I(^CacheTemp)
    Set qHandle=$lb(0,repid,0)
    s ind=1
    q:SDate="" $$$OK
    q:EndDate="" $$$OK
  	s pid=..NewPid()
  	d ..ClearTmp("GetLocPrescPersonData",pid,"Index")
	s qstdate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(SDate)
	s qenddate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(EndDate)
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
	...s pcntsno=$p(^DHCPHCNTS(pcnts),"^",1)
	...q:(pcntsno'=PcntsNo)&(PcntsNo'="")   ;添加单号查询条件  
	...s chl=""
	...f  s chl=$o(^DHCPHCNTS(pcnts,"I",chl)) q:chl=""  d
	....s prescno=$p(^DHCPHCNTS(pcnts,"I",chl),"^",1)
	....s doclocdr=$p(^DHCPHCNTS(pcnts,"I",chl),"^",4)
	....s orddeptcode=$p(^CTLOC(doclocdr),"^",1)  ;科室代码
    ....s orddept=$p(^CTLOC(doclocdr),"^",2) 
    ....i $f(orddept,"-") s orddept=$p(orddept,"-",2)
	....s adm=$p(^DHCPHCNTS(pcnts,"I",chl),"^",3)
	....q:adm=""
	....q:'$d(^PAADM(adm))    //处方点评获取就诊信息
	....s retdata=..GetPrescNoInfo(prescno)
	....s num=$p(retdata,"^",1)  //处方品种数
	....s bnum=$p(retdata,"^",7) //基本药物
	....s zsnum=$p(retdata,"^",5) //注射剂数
    ....s kjnum=$p(retdata,"^",6) 
    ....i kjnum>0 s ^TMP("DHCPRC",$this,"GetLocPrescPersonData",pid,"Index",orddept,adm,"kjnum")=1
    ....i bnum>0 s ^TMP("DHCPRC",$this,"GetLocPrescPersonData",pid,"Index",orddept,adm,"bnum")=1
    ....i zsnum>0 s ^TMP("DHCPRC",$this,"GetLocPrescPersonData",pid,"Index",orddept,adm,"zsnum")=1
    
    ....s prescnum=1
    ....s amt=##class(web.DHCSTCNTSCOMMON).GetPrescAmt(prescno)
    
    ....s ^TMP("DHCPRC",$this,"GetLocPrescPersonData",pid,"Index",orddept,adm,"total")=1
    
    
    s orddept=""
    f  s orddept=$o(^TMP("DHCPRC",$this,"GetLocPrescPersonData",pid,"Index",orddept)) q:(orddept="")  d 
    .s index="",total=0,kjnum=0,bnum=0,zsnum=0
    .f  s index=$o(^TMP("DHCPRC",$this,"GetLocPrescPersonData",pid,"Index",orddept,index)) q:index=""  d
    ..s total=total+$g(^TMP("DHCPRC",$this,"GetLocPrescPersonData",pid,"Index",orddept,index,"total"))
    ..s kjnum=kjnum+$g(^TMP("DHCPRC",$this,"GetLocPrescPersonData",pid,"Index",orddept,index,"kjnum"))
    ..s bnum=bnum+$g(^TMP("DHCPRC",$this,"GetLocPrescPersonData",pid,"Index",orddept,index,"bnum"))
    ..s zsnum=zsnum+$g(^TMP("DHCPRC",$this,"GetLocPrescPersonData",pid,"Index",orddept,index,"zsnum"))
    
    .d OutRow
    d ..ClearTmp("GetLocPrescPersonData",pid,"Index")
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutRow
	set Data=$lb(orddept,kjnum,bnum,zsnum,total)    
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
}

/// ////////////////////// ////////////////////// ////////////////////// ///////////////////
/// ///////////////////上面为Query方法,下面为过程函数,请按此规则////////////////////////////
/// ////////////////////// ////////////////////// ////////////////////// ///////////////////
/// 获取处方号的信息
/// d ##class(web.DHCSTCNTSQUERY).GetPrescNoInfo("E18061600752")
ClassMethod GetPrescNoInfo(prescno) As %String
{
	
    s zsnum=0,kjnum=0,bnum=0,gennum=0,dsnum=0 ;zsnum 注射剂 ;kjnum 抗菌药 ;bnum 国家基本药物 ;gennum 通用名数 ;dsnum大输液数
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
    ..s poisonstr=##class(web.DHCSTCOMMONSRV).getPoisonByInci(inci)
    ..s poison=$p(poisonstr,"^",3)
    ..i poison["菌" s kjnum=kjnum+1
    ..s instdr=$p($g(^OEORD(ord,"I",chl,2)),"^",7)
    ..i ##class(web.DHCSTCNTSCOMMON).GetZSDrugFlagByOrd(oeori)=1 s zsnum=zsnum+1
    ..s info=$o(^DHCITMINFO(0,"INCI",inci,""))
    ..s itmmastid=$p(arcitm,"||",1)
    ..s itmmastver=$p(arcitm,"||",2)
    ..s phcdfId=$p(^ARCIM(itmmastid,itmmastver,1),"^",12)
    ..i phcdfId'="" d
    ...s bflag=$p(^PHCD(+phcdfId,"DF",+$p(phcdfId,"||",2),"DHC"),"^",31)
    ...i bflag="Y" s bnum=bnum+1
    ..s INCIINCSCDR=$p(^INCI(inci,2),"^",2)
    ..i INCIINCSCDR="8" s dsnum=dsnum+1
    s:amt'=0 amt=$Fn(amt,"",2)
    s data=h_"^"_$G(amt)_"^"_$g(pyuser)_"^"_$g(fyuser)_"^"_$g(zsnum)_"^"_$g(kjnum)_"^"_$g(bnum)_"^"_$g(gennum)_"^"_$g(dsnum)
	q data
}

/// Description:新建临时global的计数器
/// Creator:	hulihua
/// CreateDate:	2016-06-05
/// Table:      
/// Input:      
/// Output:		
/// Return：
/// w ##class(web.DHCST.ReportForms.ReportCommon).NewPid()
ClassMethod NewPid() As %String
{
  	Q $I(^DHCPRCPID("DHCPRC",$this))
}

/// Description:Kill临时global的公共方法
/// Creator:	hulihua
/// CreateDate:	2016-06-05
/// Table:      
/// Input:      
/// Output:		
/// Return：
/// w ##class(web.DHCST.ReportForms.ReportCommon).ClearTmp()
ClassMethod ClearTmp(MethodName As %String, pid As %String, PAR As %String = "") As %String
{
	I PAR'="" D
	.K ^TMP("DHCPRC",$this,MethodName,pid,PAR)
	.K ^TEMP("DHCPRC",$this,MethodName,pid,PAR)
	E  D
	.K ^TMP("DHCPRC",$this,MethodName,pid)
	.K ^TEMP("DHCPRC",$this,MethodName,pid)
	Q ""
}

}
