Import sqluser

Class web.DHCSTCNTSIPDATA Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// 统计离院人数
/// w ##class(web.DHCSTCNTSIPDATA).GetLeavePersonNum("2017-06-07^2018-06-07^^^^^^^^^^^^^false^IP")
ClassMethod GetLeavePersonNum(parstr) As %String
{
	//s ^tmyq("GetLeavePersonNum")=parstr
	s stdate=$p(parstr,"^",1)
	s:stdate'="" stdate=##class(websys.Conversions).DateHtmlToLogical(stdate)
	s enddate=$p(parstr,"^",2)
	s:enddate'="" enddate=##class(websys.Conversions).DateHtmlToLogical(enddate)
	s prefix=$p(parstr,"^",16)	
    s wayid=$o(^DHCPCWAY(0,"Code",prefix,""),-1)	//获取点评方式代码
    s resaveflag=""
    s:wayid'="" resaveflag=$p(^DHCPCWAY(wayid),"^",5)	//重复抽取标记
	s indexcode="DischDate"  //住院 
	//i $D(^DHCDishChargeSet("Disch","ifGetDischgDateTimeByDoc")) s indexcode="AdminDateExt"  //住院 liangqiang 2016-02-17
	s pid=##class(web.DHCSTCNTSMAIN).GetPHCNTSPID()
	s h=0
	s starttime=$p($h,",",2)
	s timeoutflag=0   //超时标志
	f date=stdate:1:enddate  q:timeoutflag=1  d
	.s adm=""
	.f  s adm=$o(^PAADMi(indexcode,date,adm)) q:adm=""  d
	..s admtype=$p(^PAADM(adm),"^",2)
    ..q:admtype'="I"
    ..s currtime=$p($h,",",2)
    ..i currtime-starttime>45 s timeoutflag=1
    ..s chkpcnts=0
    ..s cnts=""
    ..f  s cnts=$o(^DHCPHCNTS(0,"Adm",adm,cnts)) q:cnts=""  d
    ...s type=$p(^DHCPHCNTS(cnts),"^",5)
    ...q:type'="P"
    ...s:resaveflag'="Y" chkpcnts=1		//根据配置判断是否允许重复抽取 MYQ 20160802
    ..q:chkpcnts=1
    ..q:..ChkExistDsp(adm,parstr)=0
    ..s h=h+1
    q:timeoutflag'=0 -99  //超时
    q h
}

/// 随机抽取住院点嘱
/// w ##class(web.DHCSTCNTSIPDATA).SaveIPCommentData("01/02/2017^07/03/2017^^^80^^^^^^^^^^false^IP",1106,97)
ClassMethod GetIPCommentData(parstr) As %String
{
	s stdate=$p(parstr,"^",1)
	s:stdate'="" stdate=##class(websys.Conversions).DateHtmlToLogical(stdate)
	s enddate=$p(parstr,"^",2)
	s:enddate'="" enddate=##class(websys.Conversions).DateHtmlToLogical(enddate)
	s rnum=$p(parstr,"^",3)
	s sapceqty=+$p(parstr,"^",11)
    s cent=$p(parstr,"^",5)
	s prefix=$p(parstr,"^",16)	
    s wayid=$o(^DHCPCWAY(0,"Code",prefix,""),-1)	//获取点评方式代码
    s resaveflag="" 
    s:wayid'="" resaveflag=$p(^DHCPCWAY(wayid),"^",5)	//重复抽取标记   
    
	s indexcode="DischDate"  //住院 
	//i $D(^DHCDishChargeSet("Disch","ifGetDischgDateTimeByDoc")) s indexcode="AdminDateExt"  //住院 liangqiang 2016-02-17
	s pid=##class(web.DHCSTCNTSMAIN).GetPHCNTSPID()
	s h=0
	f date=stdate:1:enddate d
	.s adm=""
	.f  s adm=$o(^PAADMi(indexcode,date,adm)) q:adm=""  d
	..s admtype=$p(^PAADM(adm),"^",2)
    ..q:admtype'="I"
    ..q:($d(^DHCPHCNTS(0,"Adm",adm))&&(resaveflag'="Y"))
    ..q:..ChkExistDsp(adm,parstr)=0
    ..s h=h+1
    ..s ^TMP("dhcpha","DHCSTCNTSIPDATA","GetIPCommentData",pid,"Itm",h)=adm
    
    ///获取随机数
    s maxrow=h
    i +rnum=0 s rnum=$p((maxrow*cent)/100,".")
    
    i +rnum<1 q -200
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
	..i $D(^TMP("dhcpha","DHCSTCNTSIPDATA","GetIPCommentData",pid,"RandNum",randnum)) d
	...s forflag=0 
	.//
	.i forflag=0 d
	..f y=1:1:100000 q:forflag'=0  d
	...s randnum=$R(maxrow)
	...q:randnum=0
	...q:$D(^TMP("dhcpha","DHCSTCNTSIPDATA","GetIPCommentData",pid,"RandNum",randnum))
	...s forflag=1
	.
	.s ^TMP("dhcpha","DHCSTCNTSIPDATA","GetIPCommentData",pid,"RandNum",randnum)=""
	.s randflag=randflag+1
	.
    
	//按间隔数产生随机数
	i sapceqty'=0 d
    .i (maxrow\sapceqty)'<rnum d
	..f x=1:1:rnum d
	...s forflag=0
	...s startqty=sapceqty*(x-1)+1
	...s endqty=sapceqty*x
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
	....s ^TMP("dhcpha","DHCSTCNTSIPDATA","GetIPCommentData",pid,"RandNum",randnum)=""
	....
	.
	
	///按随机数抽取数据
	s cnt=0
    s h=""
    f  s h=$o(^TMP("dhcpha","DHCSTCNTSIPDATA","GetIPCommentData",pid,"RandNum",h)) q:h=""  d
    .s data=^TMP("dhcpha","DHCSTCNTSIPDATA","GetIPCommentData",pid,"Itm",h)
    .s adm=$p(data,"^",1)
    .s cnt=cnt+1
    .s ^TMP("dhcpha","DHCSTCNTSMAIN","GetPrescData","ForSaveData",pid,h)=adm
    .
	
	q cnt_"^"_pid
}

// 生成住院医嘱点评单

// 1/09/2016^11/10/2016^1^^^^^^^^^^^^false^IP,1106,97

// 01/02/2017^07/03/2017^^^80^^^^^^^^^^false^IP,1106,97

/// w ##class(web.DHCSTCNTSIPDATA).SaveIPCommentData("01/02/2017^07/03/2017^^^80^^^^^^^^^^false^IP",1106,97)
ClassMethod SaveIPCommentData(parstr, user, logonloc) As %String
{
	//s ^tmyq("SaveIPCommentData")=parstr_","_user_","_logonloc
	s ret=..GetIPCommentData(parstr)
	s cnt=$p(ret,"^",1)
	s pid=$p(ret,"^",2)
	q:cnt=-100 -100_"^"_"随机数超过当前可抽取处方总数的80%，建议调整随机数!"
	q:cnt=-200 -200_"^"_"抽取数量小于1,不能抽取!"
	q:cnt=0 -99_"^"_"没有抽取到符合条件的医嘱,请更换规则后再试!"
	s stdate=$p(parstr,"^",1)
	s stdate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(stdate)
	s enddate=$p(parstr,"^",2)
	s enddate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(enddate)
	s rnum=$p(parstr,"^",3)
    s cent=$p(parstr,"^",5)
	s note="日期范围:"_stdate_"至"_enddate
	i rnum'="" d
    .s note=note_","_"随机数:"_rnum
    i cent'="" d
    .s note=note_","_"随机比:"_cent
	s Prefix="IP"
	s logonhospdr=""
	s:logonloc'="" logonhospdr=$p(^CTLOC(logonloc),"^",22)
	tstart
	s main=##class(web.DHCSTCNTSMAIN).SaveCommentNo(user,note,Prefix,logonhospdr,"P")
	i +main'>0 d exitsave
	q:+main'>0 -1_"^"_"保存主表失败"
	s itm=..SaveCommentItm(pid,main,Prefix)
	i +itm'=0 d exitsave
	q:+itm=-10 -2_"^"_"有部分医嘱不能重复生成点评单,请重新查询后再试!"
	q:+itm'=0 -3_"^"_"保存子表失败"
	tcommit
	s commentno=$p(^DHCPHCNTS(main),"^",1)
	q 0_"^"_commentno
	
exitsave
    tro
    k ^TMP("dhcpha","DHCSTCNTSIPDATA","GetIPCommentData","ForSaveData",pid)
    q
}

/// 保存点评明细数据
ClassMethod SaveCommentItm(pid, main, prefix = "") As %String
{
	s ret=0
	s i="" 
	f  s i=$o(^TMP("dhcpha","DHCSTCNTSMAIN","GetPrescData","ForSaveData",pid,i)) q:(i="")||(ret'=0)  d
	.s itmdata=^TMP("dhcpha","DHCSTCNTSMAIN","GetPrescData","ForSaveData",pid,i)
	.k ^TMP("dhcpha","DHCSTCNTSMAIN","GetPrescData","ForSaveData",pid,i)
	.s adm=$p(itmdata,"^",1)
	.s ret=..SaveItm(main,adm,prefix)
	q:ret'=0 ret
	q 0
}

/// 保存点评明细表
ClassMethod SaveItm(main, adm, prefix = "") As %String
{
	s wayid=$o(^DHCPCWAY(0,"Code",prefix,""),-1)	//获取点评方式代码
    s resaveflag="" 
    s:wayid'="" resaveflag=$p(^DHCPCWAY(wayid),"^",5)	//重复抽取标记
	q:($d(^DHCPHCNTS(0,"Adm",adm)))&&(resaveflag'="Y") -99 //已存在
	k PLIST
	s PLIST(0)=main
	s PLIST(2)=+$o(^DHCPHCNTS(main,"I",""),-1)+1
	s PLIST(5)=adm
	&sql(INSERT INTO DHC_PHCOMMENTSITM VALUES :PLIST())
	q:SQLCODE -1
 	q 0
}

/// description: 点评住院医嘱-插询-医嘱明细
/// w ##class(web.DHCSTCNTSIPDATA).FindIPOrdDetailNum("1","5||1")
ClassMethod FindIPOrdDetailNum(adm, pcntsitm = "") As %String
{
	//s ^TMPDHCSTPARAMS("web.DHCSTCNTSIPDATA","FindIPOrdDetailNum")=$lb(adm,pcntsitm)
	s pid=##class(web.DHCSTCNTSMAIN).GetPHCNTSPID()
	s HospID=""
	s findflag=1
	s h=0
	s ord=""
	f  s ord=$o(^OEORD(0,"Adm",adm,ord))  q:ord=""  d
	.s locstr=##class(web.DHCSTCNTSCOMMON).GetPhaLocStr()
	.s cnt=$l(locstr,"^")
	.f i=1:1:cnt d
	..s recdpdr=$p(locstr,"^",i)
	..s HospID=$p($g(^CTLOC(recdpdr)),"^",22)
	..s chl=""
	..f  s chl=$o(^OEORDi(0,"RecDepOrd",ord,recdpdr,chl)) q:chl=""  d
	...s orditm=ord_"||"_chl
	...s presc=$p(^OEORD(ord,"I",chl,1),"^",14) ;处方号
	...q:presc=""
	...s arcimid=$p(^OEORD(ord,"I",chl,1),"^",2)  ;医嘱 ARC_ItmMast ARCIM_RowId
	...s itmmastid=$p(arcimid,"||",1)
	...s itmmastver=$p(arcimid,"||",2)
	...s inci=$o(^INCI(0,"ARCIM_DR",$p(arcimid,"||",1),"") ) q:inci=""  //医嘱名称
	...s inciDesc=$p(^INCI(inci,1),"^",2) //药品名称
	...s arcimdesc=$p(^ARCIM(itmmastid,itmmastver,1),"^",2)
	...s inciDesc=arcimdesc
	...s dsp=$o(^DHCOEDISQTY(0,"OEORI",orditm,""))
	...q:dsp=""
    ...s qty=##class(web.DHCSTCNTSCOMMON).GetDspQty(orditm)
	...q:qty=0
    ...// 医嘱改造,打包表数量为药学基本单位数量
    ...s uomdesc=""
    ...s phcdfId=$p(^ARCIM(itmmastid,itmmastver,1),"^",12)
    ...i phcdfId'="" d
    ....s uomid=$p(^PHCD(+phcdfId,"DF",+$p(phcdfId,"||",2),2),"^",4)
    ....s uomdesc=$p($g(^CT("UOM",+uomid)),"^",2)
    ...s dosagestr=##class(web.DHCSTCOMMONORDER).OeoriDosage(orditm)
    ...s freq=$p(##class(web.DHCSTCOMMONORDER).OeoriFreq(orditm),"^",4)
    ...s instru=$p(##class(web.DHCSTCOMMONORDER).OeoriInstruc(orditm),"^",2)
    ...s duration=$p(##class(web.DHCSTCOMMONORDER).OeoriDuration(orditm),"^",2)
    ...s priorty=$p(##class(web.DHCSTCOMMONORDER).OeoriPriority(orditm),"^",3)
	...s doctor=$p(##class(web.DHCSTCOMMONORDER).OeoriDoctor(orditm),"^",2)
	...s doctor=##class(web.DHCSTCOMMONSRV).getOrdDoctor(orditm)       ;医生
	...s skintest=##class(web.DHCSTCOMMONSRV).GetSkinTestResult(orditm)  ;皮试
	...s form=##class(web.DHCSTCOMMONSRV).GetForm(inci)  ;剂型
	...i $F(form,$c(13)) s form=$p(form,$c(13))
	...s (spec,manf)=""
	...//s spec=##class(web.DHCSTCOMMONSRV).getBarcode(inci) ;规格
	...//s manf=##class(web.DHCSTITMDESC).GetManfNameByInci(inci) ;厂家
	...//i $f(manf,"-") s manf=$p(manf,"-",2)
	...s remark=##class(web.DHCSTCOMMONSRV).GetOrdItmRemark(orditm) ;备注
    ...s orddate=$p(^DHCOEDISQTY(dsp),"^",15)
    ...i orddate'="" s orddate=##class(websys.Conversions).DateLogicalToHtml(orddate)
    ...s ordtime=$p(^DHCOEDISQTY(dsp),"^",16)
    ...i ordtime'="" s ordtime=##class(websys.Conversions).TimeLogicalToHtml(ordtime)
    ...s orddatetime=orddate_" "_ordtime  ;开单日期
    ...s status=$p(^DHCOEDISQTY(dsp),"^",7)
    ...s dspdate=+$h
	...i status="C" s dspdate=$p(^DHCOEDISQTY(dsp),"^",8)
	...s (price,amt)=""
	...//s exStr=orditm
	...//s price=##class(web.DHCSTPRICE).GetSp(+inci,dspdate,buomdr,HospID,"",exStr)	//zhouyg 20150113
	...//s price=$fn(price,"",2) 
	...//s amt=$fn(price*qty,"",2)
	...s cyqty=$p(^DHCOEDISQTY(dsp),"^",5)
	...s specinstr=$p(^OEORD(ord,"I",chl,2),"^",8)
	...// 医嘱结构改造，基本药物标志在药学项中获取
	...s basflag=##class(web.DHCST.Common.DrugInfoCommon).GetBasicByPhcdf(phcdfId)
    ...s h=h+1
    ...s moeori=##class(web.DHCSTCNTSCOMMON).GetMainOeori(orditm)
    ...s reason=..GetMainCommentReason(orditm,pcntsitm)
	...i reason="" s reason=..GetCommentReason(orditm,pcntsitm)
	...s colorflag=0
	...i reason'="" s colorflag=1
	...i moeori'=orditm s inciDesc="_____"_inciDesc
    ...s data=inciDesc_"^"_qty_"^"_uomdesc_"^"_dosagestr_"^"_freq_"^"_spec_"^"_instru_"^"_duration_"^"_form
    ...s data=data_"^"_priorty_"^"_doctor_"^"_orddatetime_"^"_remark_"^"_manf_"^"_price_"^"_amt_"^"_specinstr_"^"_skintest
    ...s data=data_"^"_basflag_"^"_orditm_"^"_colorflag
    ...s index=orddatetime_"^"_moeori_"^"_orditm
    ...s ^TMP("dhcpha","DHCSTCNTSIPDATA","OrdDetailData",pid,index,h)=data
    ...
    s h=0
    s index=""
    f  s index=$o(^TMP("dhcpha","DHCSTCNTSIPDATA","OrdDetailData",pid,index)) q:index=""  d
    .s num=""
    .f  s num=$o(^TMP("dhcpha","DHCSTCNTSIPDATA","OrdDetailData",pid,index,num)) q:num=""  d
    ..s data=^TMP("dhcpha","DHCSTCNTSIPDATA","OrdDetailData",pid,index,num)
    ..s h=h+1
    ..s ^TMP("dhcpha","DHCSTCNTSIPDATA","FindIPOrdDetailData",pid,h)=data
    
    q h_"^"_pid
}

/// 7,0,,3||1
/// w ##class(web.DHCSTCNTSIPDATA).FindIPOrdDetailData(7,0,"","3||1")
ClassMethod FindIPOrdDetailData(adm, stpage, limit, pcntsitm = "") As %String
{
	s ^tmyq($this,"FindIPOrdDetailData")=adm_","_stpage_","_limit_","_pcntsitm
	s endpage=stpage+limit  //结束行
	s stpage=stpage+1 //开始行
	q:adm="" ##class(web.DHCSTEXTCOMMON).GetNoJson()
	s ret=..FindIPOrdDetailNum(adm,pcntsitm)
	s h=$p(ret,"^",1)
	s pid=$p(ret,"^",2)
	q:h=0 ##class(web.DHCSTEXTCOMMON).GetNoJson()
	
	s maxrow=h
    i endpage>maxrow s endpage=maxrow
    s count=0
    s h=""
    f  s h=$o(^TMP("dhcpha","DHCSTCNTSIPDATA","FindIPOrdDetailData",pid,h)) q:h=""  d
    .s data=^TMP("dhcpha","DHCSTCNTSIPDATA","FindIPOrdDetailData",pid,h)
    .s incidesc=$p(data,"^",1)
    .s spec=$p(data,"^",6)
    .s qty=$p(data,"^",2)
    .s uomdesc=$p(data,"^",3)
    .s dosage=$p(data,"^",4)

    .s freq=$p(data,"^",5)
    .s instruc=$p(data,"^",7)
    .s remark=$p(data,"^",13)
    .s price=$p(data,"^",15)
    .s amt=$p(data,"^",16)
    .s skintest=$p(data,"^",18)
    .s:skintest'="" incidesc=skintest_" "_incidesc
    .s pri=$p(data,"^",10)
    .s doctor=$p(data,"^",11)
    .s orddatetime=$p(data,"^",12)
    .s manf=$p(data,"^",14)
    .s price=$p(data,"^",15)
    .s form=$p(data,"^",9)
    .s basflag=$p(data,"^",19)
    .s orditem=$p(data,"^",20)
    .s colorflag=$p(data,"^",21)
    .s prescno=""
    .s:+$p(orditem,"||",2)'=0 prescno=$p($g(^OEORD(+orditem,"I",$p(orditem,"||",2),1)),"^",14)
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
	.s form=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("form",form)
	.s ordpri=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("ordpri",pri)
	.s basflag=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("basflag",basflag)
	.s doctor=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("doctor",doctor)
	.s orddate=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("orddate",orddatetime)
	.s remark=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("remark",remark)
	.s manf=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("manf",manf)
	.s price=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("price",price)
	.s amt=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("amt",amt)
	.s orditem=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("orditem",orditem)
	.s prescno=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("prescno",prescno)
	.s colorflag=##class(web.DHCSTEXTCOMMON).GetJsonLastCell("colorflag",colorflag)
	.
	.s tmpstr=incidesc_qty_uomdesc_dosage_freq_spec_instruc_form_ordpri_basflag_doctor_orddate_remark_manf_price_amt_orditem_prescno_colorflag
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

/// 检查是否有已执行的药品医嘱
/// Return:0-未执行 1-已执行
ClassMethod ChkExistDsp(adm, parstr = "") As %String
{
	s doclocstrdr=$p(parstr,"^",4) //医生科室
	s drugID=$p(parstr,"^",6) //药品
	s doctordr=$p(parstr,"^",7) //医生
	s poisonstr=$p(parstr,"^",8)   //管制分类
	s druglevelstr=$p(parstr,"^",9)  //抗菌药物级别
	s patagenum=$p(parstr,"^",10) //病人年龄大于 
	s billtypedr=$p(parstr,"^",12)  //病人费别
	//s phacatstr=$p(parstr,"^",13) //药学分类
	//s phacatdr=$p(phacatstr,"@",2) 
	s PhcCatAll=$p(parstr,"^",13) 	//新药学分类
	s phaloc=$p(parstr,"^",14) //药房名称
	s basicdrug=$p(parstr,"^",15) //基本药物
	i basicdrug="true" s basicdrug=1
	
	s exit=0
	s locstr=##class(web.DHCSTCNTSCOMMON).GetPhaLocStr()
	q:locstr="" exit
	s ord=$o(^OEORD(0,"Adm",adm,""))
	q:ord="" exit
	s papmi=$p(^PAADM(adm),"^",1) 
    q:(##class(web.DHCSTCNTSCOMMON).GetAgeYear(papmi)<patagenum)&(patagenum'="") exit   //年龄的过滤条件
	s patbilltype="" 
	s patbilltypedr=+$p($g(^PAPER(papmi,"PER",1)),"^",10) 
	s:patbilltypedr'="" patbilltype=$p(^CT("SS",patbilltypedr),"^",2) //病人费别 
	q:(patbilltypedr'=billtypedr)&(billtypedr'="") exit 
	f i=1:1:$l(locstr,"^") d
	.s recdpdr=$p(locstr,"^",i)
	.s chl=""
	.f  s chl=$o(^OEORDi(0,"RecDepOrd",ord,recdpdr,chl)) q:(chl="")||(exit=1)  d
    ..s orditm=ord_"||"_chl
    ..s qty=##class(web.DHCSTCNTSCOMMON).GetDspQty(orditm)
    ..q:qty=0
    ..s orddeptdr=$p(^OEORD(ord,"I",chl,1),"^",3) //医生科室
    ..q:($$chkdocloc(doclocstrdr)=0)&(doclocstrdr'="")
    ..s doctocid=$p($g(^OEORD(ord,"I",chl,7)),"^",1)  ///
	..q:(doctocid'=doctordr)&(doctordr'="")  //医生
    ..s arcimid=$p(^OEORD(ord,"I",chl,1),"^",2)  ;医嘱 ARC_ItmMast ARCIM_RowId
	..s itmmastid=$p(arcimid,"||",1)
	..s itmmastver=$p(arcimid,"||",2)
	..s tmpinci=$o(^INCI(0,"ARCIM_DR",$p(arcimid,"||",1),"") ) 
	..q:tmpinci=""  //医嘱名称
	..q:(tmpinci'=drugID)&(drugID'="")
	..s drugpoisonstr=##class(web.DHCSTCOMMONSRV).getPoisonByInci(tmpinci)
	..s drugpoisondr=$p(drugpoisonstr,"^",1)
	..q:($$chklevel(druglevelstr)=0)&(druglevelstr'="")   //抗菌药级别
	..q:(drugpoisondr'=poisonstr)&(poisonstr'="")   //管制分类
	..s reclocdr=$p(^OEORD(ord,"I",chl,3),"^",6)
	..q:(phaloc'=reclocdr)&(phaloc'="") //药房
	..s PhaCatAllstr=##class(web.DHCST.Common.DrugInfoCommon).GetPhaCatAll(tmpinci)
	..s PhaCatAlls=$p(PhaCatAllstr,"^",1)
	..s retflag=##class(web.DHCST.Common.DrugInfoCommon).CheckNewCatId(PhcCatAll,PhaCatAlls)
	..q:(PhcCatAll'="")&(retflag=0) // 多级药学分类过滤
	..s basflag=""
	..s infor=$o(^DHCITMINFO(0,"INCI",tmpinci,""))
	..i infor'="" s basflag=$p(^DHCITMINFO(infor),"^",4)
	..q:(basflag'="Y")&(basicdrug=1)  //基本药物
	..s exit=1
	
	q exit
	
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
}

/// 保存点评结果
/// Modified by MYQ 20160811 (添加点评单子表id)
/// w ##class(web.DHCSTCNTSIPDATA).SaveItmResult("93$$$1362||1","1459^N^563^^^^121^1362||1")
ClassMethod SaveItmResult(reasonstr, input, otherstr = "") As %String
{
	s adm=$p(input,"^",1)
	s result=$p(input,"^",2)
	s user =$p(input,"^",3)
	s advice=$p(input,"^",4)
	s factor=$p(input,"^",5)
	s phnote=$p(input,"^",6)
	s grpdr=$p(input,"^",7)
	s orditm=$p(input,"^",8)
	s orditm=$p(orditm,"^",1)

	s currdate=+$h
	s currtime=$p($h,",",2)
	s ipcntsi=$p(otherstr,"^",1)
	s main=+ipcntsi	//$o(^DHCPHCNTS(0,"Adm",adm,"")) 
	q:main="" -1
    s itm=$p(ipcntsi,"||",2) 	//$o(^DHCPHCNTS(0,"Adm",adm,main,"")) 
    q:itm="" -2
    s PCNTSI=main_"||"_itm
    s apptype=""
    
    //判断权限
    s curresult=..GetItmResult(PCNTSI)
    s itmresult=..GetCommentReason(orditm)
    s wayid=$p(^DHCPHCNTS(main),"^",7)
    s config=##class(web.DHCSTCNTSCOMMON).GetSecGrpConfigStr(wayid,grpdr)    
    //s config=""
    s updateflag=$p(config,"^",1)
    q:(itmresult'="")&(updateflag'="Y") -33 //无权修改
    q:(curresult="Y")&(updateflag'="Y") -33 //无权修改
    // 判断是否已经分配
    s allotUserId=$p($g(^DHCPHCNTS(main,"I",itm)),"^",7)
    //已分配点评药师，但不是当前点评人且无修改权限时不允许点评
    q:(allotUserId'="")&&(allotUserId'=user)&&(updateflag'="Y") "-44"		
    
	tstart
	/*
	&sql(update DHC_PHCOMMENTSITM set PCNTSI_CurrRet=:result where PCNTSI_RowID=:PCNTSI)
	i SQLCODE'=0 tro
	q:SQLCODE'=0 -2
	*/
	//
	s sub="0"
	f  s sub=$o(^DHCPHCNTS(main,"I",itm,"L",sub)) q:sub=""  d
	.s active=$p(^DHCPHCNTS(main,"I",itm,"L",sub),"^",11)
	.s pcntslresult=$p(^DHCPHCNTS(main,"I",itm,"L",sub),"^",2)
	.;i (result="Y")||(pcntslresult="Y") s $p(^DHCPHCNTS(main,"I",itm,"L",sub),"^",11)="N" 
	.i (pcntslresult="Y") s $p(^DHCPHCNTS(main,"I",itm,"L",sub),"^",11)="N" 
	.i (result="Y")&&(orditm="") d
	..s $p(^DHCPHCNTS(main,"I",itm,"L",sub),"^",11)="N"
	
	i orditm'="" d	//当按照医嘱点评时，之前的所有点评都置为未激活
    .s pctlog="0"
    .f  s pctlog=$o(^DHCPCTABL(0,"OrdItm",orditm,pctlog)) q:pctlog=""  d
    ..s pctlogitm=+pctlog_"||"_$p(pctlog,"||",2)
    ..q:pctlogitm'=PCNTSI
    ..s $p(^DHCPHCNTS(+pctlog,"I",$p(pctlog,"||",2),"L",$p(pctlog,"||",3)),"^",11)="N"  //这里还不能注释,有可能是不同的医嘱 liangqiang
	
	s sendreasonstring="",sendordstring=""
	s Active="Y"
	s ret=0
	s tmpstr=reasonstr
	s cnt=$l(tmpstr,"!")
	f h=1:1:cnt q:ret'=0  d
	.s grpno=##class(web.DHCSTCNTSMAIN).GetLogGrpNo(main,itm)
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
	
	s pcntslsub="",unflag=0
	f  s pcntslsub=$o(^DHCPHCNTS(+PCNTSI,"I",$p(PCNTSI,"||",2),"L",pcntslsub)) q:(pcntslsub="")||(unflag'=0)  d
	.s pcntsldata=^DHCPHCNTS(+PCNTSI,"I",$p(PCNTSI,"||",2),"L",pcntslsub)
	.s pcntslactive=$p(pcntsldata,"^",11)
	.q:pcntslactive'="Y"
	.s pcntslresult=$p(pcntsldata,"^",2)
	.s:pcntslresult="N" unflag=1
	.
	
	i (result="Y")&(unflag=0) d
	.&sql(update DHC_PHCOMMENTSITM set PCNTSI_CurrRet=:result where PCNTSI_RowID=:PCNTSI)
	.i SQLCODE'=0 tro
	i (result="N") d
	.&sql(update DHC_PHCOMMENTSITM set PCNTSI_CurrRet=:result where PCNTSI_RowID=:PCNTSI)
	.i SQLCODE'=0 tro
	q:SQLCODE'=0 -2
	
	q:ret'=0 -3
	tcommit
	
	//发送消息
    s Context=""
    i apptype="" d
    .s Context="处方点评不通过"
    .s ActionCode="1002"
    i apptype="OR" d
    .s Context="拒绝发药"
    .s ActionCode="1003"
    i apptype="OA" d
    .s Context="处方审核不通过"
    .s ActionCode="1003"
	// yunhaibao,20180717,消息内容药品与原因对应
	s ConText=""
	s textI=""
	f  s textI=$o(SaveItmResultReason(textI)) q:textI=""  d
	.s incDescStr=$g(SaveItmResultReason(textI,0))
	.s reasonStr=$g(SaveItmResultReason(textI,1))
	.s sendReasonStr=incDescStr_"	原因："_reasonStr
	.s ConText=$s(ConText="":sendReasonStr,1:ConText_"</br>"_sendReasonStr)
    
    //s ret1=##class(web.DHCSTInterfaceMessage).SendAppealComment(PCNTSI,"Exec")
	i result="N" d
	.s ConText="住院医嘱点评不通过</br>"_ConText
	.s ret=##class(web.DHCSTInterfaceMessage).SendCommentResult(PCNTSI,"Cancel",orditm)
	.s ret=##class(web.DHCSTInterfaceMessage).SendCommentResult(PCNTSI,"Send",orditm,ConText)
	
	q 0
}

/// 返回住院子医嘱的不合理原因
ClassMethod GetCommentReason(orditem, pcntsitm = "") As %String
{
	s i=0
	s ret=""
	s moeori=##class(web.DHCSTCNTSCOMMON).GetMainOeori(orditem)
	q:moeori="" ""
	s ord=+moeori
	s tmpchl=""
 	F  S tmpchl=$O(^OEORDi(0,"OEORI",ord,moeori,tmpchl)) Q:tmpchl=""  d
 	.s orditem=ord_"||"_tmpchl
	.s itmlogdr=""
	.f  s itmlogdr=$o(^DHCPCTABL(0,"OrdItm",orditem,itmlogdr)) q:itmlogdr=""  d
	..s main=$p(itmlogdr,"||",1)
	..q:(pcntsitm'="")&&(+pcntsitm'=main)
	..s itm=$p(itmlogdr,"||",2)
	..s sub=$p(itmlogdr,"||",3)
	..q:'$d(^DHCPHCNTS(main,"I",itm,"L",sub))
	..s active=$p(^DHCPHCNTS(main,"I",itm,"L",sub),"^",11)
	..q:active'="Y"
	..s reasondr=$p(^DHCPHCNTS(main,"I",itm,"L",sub),"^",1)
	..s reason=$p(^DHCPCREASON(reasondr),"^",2)
	..s i=i+1
	..i ret="" d
	...s ret=i_"."_reason
	..e  d
	... s ret=ret_" "_i_"."_reason
	q ret
}

/// 返回住院主医嘱的不合理原因
/// 363||3,1553||1
/// w ##class(web.DHCSTCNTSIPDATA).GetMainCommentReason("338||2","1552||1")
ClassMethod GetMainCommentReason(orditem, pcntsitm = "") As %String
{
	s i=0
	s moeori=##class(web.DHCSTCNTSCOMMON).GetMainOeori(orditem)
	s ret=""
	s reagrpno=""
	s itmlogdr=""
	f  s itmlogdr=$o(^DHCPCTABL(0,"OrdItm",orditem,itmlogdr)) q:itmlogdr=""  d
	.s main=$p(itmlogdr,"||",1)
	.q:(pcntsitm'="")&&(main'=+pcntsitm)
	.s itm=$p(itmlogdr,"||",2)
	.s sub=$p(itmlogdr,"||",3)
	.q:'$d(^DHCPHCNTS(main,"I",itm,"L",sub))
	.s active=$p(^DHCPHCNTS(main,"I",itm,"L",sub),"^",11)
	.q:active'="Y"
	.s reagrpno=$p(^DHCPHCNTS(main,"I",itm,"L",sub),"^",12)	//组号
	
	q:reagrpno="" ""
	
	s smain=$p(pcntsitm,"||",1)
	s sitm=$p(pcntsitm,"||",2)
	s ssub=""
	f  s ssub=$o(^DHCPHCNTS(smain,"I",sitm,"L",ssub)) q:ssub=""  d
	.s sactive=$p(^DHCPHCNTS(smain,"I",sitm,"L",ssub),"^",11)
	.q:sactive'="Y"
	.s sreagrpno=$p(^DHCPHCNTS(smain,"I",sitm,"L",ssub),"^",12)
	.q:(reagrpno'=sreagrpno)
	.s reasondr=$p(^DHCPHCNTS(smain,"I",sitm,"L",ssub),"^",1)
	.s reason=$p(^DHCPCREASON(reasondr),"^",2)
	.s i=i+1
	.i ret="" d
	..s ret=i_"."_reason
	.e  d
	.. s ret=ret_" "_i_"."_reason
	q ret
}

/// 取点评记录日志
ClassMethod GetIPCommentLog(orditem, stpage, limit, pcntsitm = "") As %String
{
	//s ^tmyq("GetIPCommentLog")=orditem_","_stpage_","_limit_","_pcntsitm
	s pid=##class(web.DHCSTCNTSMAIN).GetPHCNTSPID()
	s endpage=stpage+limit  //结束行
	s stpage=stpage+1 //开始行
	
    s moeori=##class(web.DHCSTCNTSCOMMON).GetMainOeori(orditem)
    s ord=+moeori
    q:ord=0 ##class(web.DHCSTEXTCOMMON).GetNoJson()
    s orditmstr=moeori
    s tmpchl=""
 	F  S tmpchl=$O(^OEORDi(0,"OEORI",ord,moeori,tmpchl)) Q:tmpchl=""  d
 	.s suboeori=ord_"||"_tmpchl
 	.s orditmstr=orditmstr_"^"_suboeori
 	
 	s cntorditm=$l(orditmstr,"^")
 	f x=1:1:cntorditm d
    .s orditem=$p(orditmstr,"^",x)
	.s itmlogdr=""
	.f  s itmlogdr=$o(^DHCPCTABL(0,"OrdItm",orditem,itmlogdr),-1) q:itmlogdr=""  d 
	..s main=$p(itmlogdr,"||",1)
	..q:(pcntsitm'="")&&(+pcntsitm'=main)
	..s itm=$p(itmlogdr,"||",2)
	..s sub=$p(itmlogdr,"||",3)
	..q:'$d(^DHCPHCNTS(main,"I",itm,"L",sub))
	..s comgrpno=$p(^DHCPHCNTS(main,"I",itm,"L",sub),"^",12)
	..s ^TMP("dhcpha","DHCSTCNTSIPDATA","GetIPCommentLog","GrpNo",pid,comgrpno)=main_"||"_itm_"||"_sub
	.
	s comgrpno=$o(^TMP("dhcpha","DHCSTCNTSIPDATA","GetIPCommentLog","GrpNo",pid,""),-1)
	s itmlogdr=^TMP("dhcpha","DHCSTCNTSIPDATA","GetIPCommentLog","GrpNo",pid,comgrpno)
	s main=$p(itmlogdr,"||",1)
	s itm=$p(itmlogdr,"||",2)
	s h=0
    s sub=""
	f  s sub=$o(^DHCPHCNTS(main,"I",itm,"L",sub),-1) q:sub=""  d
	.s comgrpno=$p(^DHCPHCNTS(main,"I",itm,"L",sub),"^",12)
	.q:'$d(^TMP("dhcpha","DHCSTCNTSIPDATA","GetIPCommentLog","GrpNo",pid,comgrpno))
	.s comdate=$p(^DHCPHCNTS(main,"I",itm,"L",sub),"^",3)
	.i comdate'="" s comdate=##class(websys.Conversions).DateLogicalToHtml(comdate)
	.s comtime=$p(^DHCPHCNTS(main,"I",itm,"L",sub),"^",4)
	.i comtime'="" s comtime=##class(websys.Conversions).TimeLogicalToHtml(comtime)
	.s comuser=""
	.s userdr=$p(^DHCPHCNTS(main,"I",itm,"L",sub),"^",5)
	.s:userdr'="" comuser=$p(^SSU("SSUSR",userdr),"^",2)
	.s active=$p(^DHCPHCNTS(main,"I",itm,"L",sub),"^",11)
	.//s reasondr=$p(^DHCPHCNTS(main,"I",itm,"L",sub),"^",1)
	.//s reason=$p(^DHCPCREASON(reasondr),"^",2)
	.s comfactor=""
	.s comfactordr=$p(^DHCPHCNTS(main,"I",itm,"L",sub),"^",8)
	.s:comfactordr'="" comfactor=$p($g(^DHCPCFACTOR(comfactordr)),"^",2)
	.s comadvice=""
	.s comadvicedr=$p(^DHCPHCNTS(main,"I",itm,"L",sub),"^",6)
	.s:comadvicedr'="" comadvice=$p($g(^DHCPCADVICE(comadvicedr)),"^",2)   //药师建议
	.s comdocadvice=$p(^DHCPHCNTS(main,"I",itm,"L",sub),"^",7)  //医生建议
	.s comphnote=$p(^DHCPHCNTS(main,"I",itm,"L",sub),"^",9) //药师备注
	.s comdocnote=$p(^DHCPHCNTS(main,"I",itm,"L",sub),"^",10)  //医师备注
	.s comactive=$p(^DHCPHCNTS(main,"I",itm,"L",sub),"^",11)
	.s comresult=$p(^DHCPHCNTS(main,"I",itm,"L",sub),"^",2)
	.s logrowid=main_"||"_itm_"||"_sub
	.s tpctr=$o(^DHCPCTABL(0,"LOG",logrowid,""))
	.q:(tpctr="")&&(comresult="N")	//不合理的点评记录只显示和禁忌表关联的那一条
	.s reason=""
	.s:comresult="N" reason=##class(web.DHCSTCNTSMAIN).GetOPCommentReason(logrowid)
	.s comgrpno=$p(^DHCPHCNTS(main,"I",itm,"L",sub),"^",12)
	.i comresult="Y" s comresult="合格"
	.i comresult="N" s comresult="不合格"
    .s h=h+1
	.s data=""_"^"_reason_"^"_comdate_"^"_comtime_"^"_comuser_"^"_comresult_"^"_comfactor_"^"_comadvice_"^"_comdocadvice_"^"_comphnote_"^"_comdocnote_"^"_comactive_"^"_comgrpno
    .s ^TMP("dhcpha","DHCSTCNTSIPDATA","GetIPCommentLog",pid,h)=data
    .
    .s logrowid=main_"||"_itm_"||"_sub
    .s pctr=""
	.f  s pctr=$o(^DHCPCTABL(0,"LOG",logrowid,pctr)) q:pctr=""  d 
	..s orditm=$p(^DHCPCTABL(pctr),"^",1)
	..s ord=$p(orditm,"||",1)
	..s ordchl=$p(orditm,"||",2)
	..s arcimid=$p(^OEORD(ord,"I",ordchl,1),"^",2)  ;医嘱 ARC_ItmMast ARCIM_RowId
	..s itmmastid=$p(arcimid,"||",1)
	..s itmmastver=$p(arcimid,"||",2)
	..s inciDesc=$p($g(^ARCIM(itmmastid,itmmastver,1)),"^",2)		//MaYuqiang 20190109 应该显示医嘱项名称
	..s reason="____"_inciDesc
	..s h=h+1
    ..//s data=""_"^"_reason_"^"_comdate_"^"_comtime_"^"_comuser_"^"_comresult_"^"_comfactor_"^"_comadvice_"^"_comdocadvice_"^"_comphnote_"^"_comdocnote_"^"_comactive_"^"_comgrpno
    ..s data=""_"^"_reason_"^^^^^^^^^^"
    ..s ^TMP("dhcpha","DHCSTCNTSIPDATA","GetIPCommentLog",pid,h)=data
    
    q:h=0 ##class(web.DHCSTEXTCOMMON).GetNoJson()
	
 	s maxrow=h
 	i endpage>maxrow s endpage=maxrow
 
    s count=0
    s h=""
    f  s h=$o(^TMP("dhcpha","DHCSTCNTSIPDATA","GetIPCommentLog",pid,h)) q:h=""  d
    .s data=^TMP("dhcpha","DHCSTCNTSIPDATA","GetIPCommentLog",pid,h)
    .s incidesc=$p(data,"^",1)
    .s comreason=$p(data,"^",2)
    .s comdate=$p(data,"^",3)
    .s comtime=$p(data,"^",4)
    .s comuser=$p(data,"^",5)
    .s comresult=$p(data,"^",6)
    .s comfactor=$p(data,"^",7)
    .s comadvice=$p(data,"^",8)
    .s comdocadvice=$p(data,"^",9)
    .s comphnote=$p(data,"^",10)
    .s comdocnote=$p(data,"^",11)
    .s comactive=$p(data,"^",12)
    .s comgrpno=$p(data,"^",13)
    .
    .s count=count+1
    .q:count<stpage
    .q:count>endpage
    .
    .s incidesc=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("incidesc",incidesc)
	.s comreason=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("comreason",comreason)
	.s comdate=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("comdate",comdate)
	.s comtime=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("comtime",comtime)
	.s comuser=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("comuser",comuser)
	.s comresult=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("comresult",comresult)
	.s comfactor=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("comfactor",comfactor)
	.s comadvice=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("comadvice",comadvice)
	.s comdocadvice=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("comdocadvice",comdocadvice)
	.s comphnote=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("comphnote",comphnote)
	.s comdocnote=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("comdocnote",comdocnote)
	.s comactive=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("comactive",comactive)
	.s comgrpno=##class(web.DHCSTEXTCOMMON).GetJsonLastCell("comgrpno",comgrpno)
	.
	.s tmpstr=incidesc_comreason_comdate_comtime_comuser_comresult_comfactor_comadvice_comdocadvice
	.s tmpstr=tmpstr_comphnote_comdocnote_comactive_comgrpno
    .s startString=##class(web.DHCSTEXTCOMMON).GetJsonStartString(maxrow)
    .s firstrow=##class(web.DHCSTEXTCOMMON).GetJsonFirstRow(tmpstr)
    .s lastrow=##class(web.DHCSTEXTCOMMON).GetJsonLastRow(tmpstr)
	.
    .i count=stpage w startString
    .i count<endpage w firstrow
    .i count=endpage w lastrow
	.
	k ^TMP("dhcpha","DHCSTCNTSIPDATA","GetIPCommentLog",pid)
	k ^TMP("dhcpha","DHCSTCNTSIPDATA","GetIPCommentLog","GrpNo",pid)

    q ""
}

/// 取点评记录结果
ClassMethod GetItmResult(pcntsi)
{
	s pcnts=$p(pcntsi,"||",1)
	s chl=$p(pcntsi,"||",2)
	s curret=$p(^DHCPHCNTS(pcnts,"I",chl),"^",6) 
	q curret
}

/// 取点评记录所有的日志
ClassMethod GetIPCommentAllLog(adm, stpage, limit, pcntsitm = "")
{
	
	s pid=##class(web.DHCSTCNTSMAIN).GetPHCNTSPID()
	s endpage=stpage+limit  //结束行
	s stpage=stpage+1 //开始行
     
    s main=+pcntsitm	//$o(^DHCPHCNTS(0,"Adm",adm,"")) 
	q:main="" ##class(web.DHCSTEXTCOMMON).GetNoJson()
    s itm=$p(pcntsitm,"||",2)	//$o(^DHCPHCNTS(0,"Adm",adm,main,"")) 
    q:itm="" ##class(web.DHCSTEXTCOMMON).GetNoJson()
    
	s h=0
    s sub=""
	f  s sub=$o(^DHCPHCNTS(main,"I",itm,"L",sub),-1) q:sub=""  d
	.s comgrpno=$p(^DHCPHCNTS(main,"I",itm,"L",sub),"^",12)
	.s comdate=$p(^DHCPHCNTS(main,"I",itm,"L",sub),"^",3)
	.i comdate'="" s comdate=##class(websys.Conversions).DateLogicalToHtml(comdate)
	.s comtime=$p(^DHCPHCNTS(main,"I",itm,"L",sub),"^",4)
	.i comtime'="" s comtime=##class(websys.Conversions).TimeLogicalToHtml(comtime)
	.s comuser=""
	.s userdr=$p(^DHCPHCNTS(main,"I",itm,"L",sub),"^",5)
	.s:userdr'="" comuser=$p(^SSU("SSUSR",userdr),"^",2)
	.s active=$p(^DHCPHCNTS(main,"I",itm,"L",sub),"^",11)
	.//s reason=""
	.//s reasondr=$p(^DHCPHCNTS(main,"I",itm,"L",sub),"^",1)
	.//i reasondr'="" s reason=$p(^DHCPCREASON(reasondr),"^",2)
	.s comfactor=""
	.s comfactordr=$p(^DHCPHCNTS(main,"I",itm,"L",sub),"^",8)
	.s:comfactordr'="" comfactor=$p($g(^DHCPCFACTOR(comfactordr)),"^",2)
	.s comadvice=""
	.s comadvicedr=$p(^DHCPHCNTS(main,"I",itm,"L",sub),"^",6)
	.s:comadvicedr'="" comadvice=$p($g(^DHCPCADVICE(comadvicedr)),"^",2)   //药师建议
	.s comdocadvice=$p(^DHCPHCNTS(main,"I",itm,"L",sub),"^",7)  //医生建议
	.s comphnote=$p(^DHCPHCNTS(main,"I",itm,"L",sub),"^",9) //药师备注
	.s comdocnote=$p(^DHCPHCNTS(main,"I",itm,"L",sub),"^",10)  //医师备注
	.s comactive=$p(^DHCPHCNTS(main,"I",itm,"L",sub),"^",11)
	.s comresult=$p(^DHCPHCNTS(main,"I",itm,"L",sub),"^",2)
	.s logrowid=main_"||"_itm_"||"_sub
	.s tpctr=$o(^DHCPCTABL(0,"LOG",logrowid,""))
	.q:(tpctr="")&&(comresult="N")	//不合理的点评记录只显示和禁忌表关联的那一条
	.s reason=""
	.s:comresult="N" reason=##class(web.DHCSTCNTSMAIN).GetOPCommentReason(logrowid)
	.i comresult="Y" s comresult="合格"
	.i comresult="N" s comresult="不合格"
	.s comgrpno=$p(^DHCPHCNTS(main,"I",itm,"L",sub),"^",12)
    .s h=h+1
	.s data=""_"^"_reason_"^"_comdate_"^"_comtime_"^"_comuser_"^"_comresult_"^"_comfactor_"^"_comadvice_"^"_comdocadvice_"^"_comphnote_"^"_comdocnote_"^"_comactive_"^"_comgrpno
    .s ^TMP("dhcpha","DHCSTCNTSIPDATA","GetIPCommentAllLog",pid,h)=data
    .
    .s logrowid=main_"||"_itm_"||"_sub
    .s pctr=""
	.f  s pctr=$o(^DHCPCTABL(0,"LOG",logrowid,pctr)) q:pctr=""  d 
	..s orditm=$p(^DHCPCTABL(pctr),"^",1)
	..s ord=$p(orditm,"||",1)
	..s ordchl=$p(orditm,"||",2)
	..s arcimid=$p(^OEORD(ord,"I",ordchl,1),"^",2)  ;医嘱 ARC_ItmMast ARCIM_RowId
	..s itmmastid=$p(arcimid,"||",1)
	..s itmmastver=$p(arcimid,"||",2)
	..s inciDesc=$p($g(^ARCIM(itmmastid,itmmastver,1)),"^",2)		//MaYuqiang 20190109 应该显示医嘱项名称
	..s reason="____"_inciDesc
	..s h=h+1
    ..//s data=""_"^"_reason_"^"_comdate_"^"_comtime_"^"_comuser_"^"_comresult_"^"_comfactor_"^"_comadvice_"^"_comdocadvice_"^"_comphnote_"^"_comdocnote_"^"_comactive_"^"_comgrpno
    ..s data=""_"^"_reason_"^^^^^^^^^^"
    ..s ^TMP("dhcpha","DHCSTCNTSIPDATA","GetIPCommentAllLog",pid,h)=data

    q:h=0 ##class(web.DHCSTEXTCOMMON).GetNoJson()

 	s maxrow=h
 	i endpage>maxrow s endpage=maxrow

    s count=0
    s h=""
    f  s h=$o(^TMP("dhcpha","DHCSTCNTSIPDATA","GetIPCommentAllLog",pid,h)) q:h=""  d
    .s data=^TMP("dhcpha","DHCSTCNTSIPDATA","GetIPCommentAllLog",pid,h)
    .s incidesc=$p(data,"^",1)
    .s comreason=$p(data,"^",2)
    .s comdate=$p(data,"^",3)
    .s comtime=$p(data,"^",4)
    .s comuser=$p(data,"^",5)
    .s comresult=$p(data,"^",6)
    .s comfactor=$p(data,"^",7)
    .s comadvice=$p(data,"^",8)
    .s comdocadvice=$p(data,"^",9)
    .s comphnote=$p(data,"^",10)
    .s comdocnote=$p(data,"^",11)
    .s comactive=$p(data,"^",12)
    .s comgrpno=$p(data,"^",13)
    .
    .s count=count+1
    .q:count<stpage
    .q:count>endpage
    .
    .s incidesc=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("incidesc",incidesc)
	.s comreason=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("comreason",comreason)
	.s comdate=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("comdate",comdate)
	.s comtime=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("comtime",comtime)
	.s comuser=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("comuser",comuser)
	.s comresult=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("comresult",comresult)
	.s comfactor=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("comfactor",comfactor)
	.s comadvice=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("comadvice",comadvice)
	.s comdocadvice=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("comdocadvice",comdocadvice)
	.s comphnote=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("comphnote",comphnote)
	.s comdocnote=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("comdocnote",comdocnote)
	.s comactive=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("comactive",comactive)
	.s comgrpno=##class(web.DHCSTEXTCOMMON).GetJsonLastCell("comgrpno",comgrpno)
	.
	.s tmpstr=incidesc_comreason_comdate_comtime_comuser_comresult_comfactor_comadvice_comdocadvice
	.s tmpstr=tmpstr_comphnote_comdocnote_comactive_comgrpno
    .s startString=##class(web.DHCSTEXTCOMMON).GetJsonStartString(maxrow)
    .s firstrow=##class(web.DHCSTEXTCOMMON).GetJsonFirstRow(tmpstr)
    .s lastrow=##class(web.DHCSTEXTCOMMON).GetJsonLastRow(tmpstr)
	.
    .i count=stpage w startString
    .i count<endpage w firstrow
    .i count=endpage w lastrow
	.
	k ^TMP("dhcpha","DHCSTCNTSIPDATA","GetIPCommentAllLog",pid)

    q ""
}

/// 检查医嘱的所有主子医嘱是否可以修改点评结果 
/// 1- 不可以 0-可以
ClassMethod ChkUpdateFlag(adm, grpdr, orditm)
{
	q:orditm="" 0
	s main=$o(^DHCPHCNTS(0,"Adm",adm,"")) 
	q:main="" -1
    s itm=$o(^DHCPHCNTS(0,"Adm",adm,main,"")) 
    q:itm="" -2
    s wayid=$p(^DHCPHCNTS(main),"^",7)
    s config=##class(web.DHCSTCNTSCOMMON).GetSecGrpConfigStr(wayid,grpdr)
    s updateflag=$p(config,"^",1)
    s existflag=0
    s moeori=##class(web.DHCSTCNTSCOMMON).GetMainOeori(orditm)
    s itmlogdr=$o(^DHCPCTABL(0,"OrdItm",moeori,""))
    i itmlogdr'="" s existflag=1
    s ord=+moeori
    s tmpchl=""
 	F  S tmpchl=$O(^OEORDi(0,"OEORI",ord,moeori,tmpchl)) Q:(tmpchl="")||(existflag=1)  d
 	.s suboeori=ord_"||"_tmpchl
 	.s itmlogdr=$o(^DHCPCTABL(0,"OrdItm",suboeori,""))
 	.i itmlogdr'="" s existflag=1
 	q:(updateflag'="Y")&(existflag=1) 1
 	q 0
}

}
