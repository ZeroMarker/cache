Import SQLUser

/// Description:静配中心相关类报表
/// Creator:    hulihua
/// CreateDate: 2018-07-19
/// Table:
Class web.DHCST.ReportForms.PIVAStat Extends (%RegisteredObject, websys.Abstract) [ ClassType = "", ProcedureBlock ]
{

/// 医嘱审核拒绝原因统计
/// d ##class(%ResultSet).RunQuery("web.DHCST.ReportForms.PIVAStat","Queryszkjcyzshjj","2018-11-22 9:59:48","2018-11-22","","7")
Query Queryszkjcyzshjj(startDate As %String = "", endDate As %String = "", jpflag As %String = "", wardid As %String = "", HOSPID As %String = "") As websys.Query(ROWSPEC = "username:%String,ret:%String,DSPRowId:%String,pivasflag1:%String,dosage:%String,freq:%String,instru:%String,patno:%String,patname:%String,warddesc:%String,oeorditmdr:%String,OEORIOEORIDR:%String,itmdesc:%String") [ SqlProc ]
{
}

ClassMethod QueryszkjcyzshjjExecute(ByRef qHandle As %Binary, startDate As %String = "", endDate As %String = "", jpflag As %String = "", wardid As %String = "", HOSPID As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1
	q:(startDate="")||(endDate="") $$$OK
	s startDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(startDate)
	s endDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(endDate)
	//q:(endDate-startDate)>31 $$$OK
	s pid=..NewPid()
	d ..ClearTmp("Queryszkjcyzshjj",pid,"AuditRefuse")
	s locstr=..GetPivaLocStr(HOSPID)
	f date=startDate:1:endDate d
	.s cnt=$l(locstr,"^")
	.f kk=1:1:cnt  d
	..s pivaloc=$p(locstr,"^",kk)
	..s DSPStatus=""
	..f  s DSPStatus=$o(^DHCOEDISQTY(0,"ADM",pivaloc,date,DSPStatus)) q:DSPStatus=""  d
	...q:DSPStatus="R"
	...s DSPAdmDR=""
	...f  s DSPAdmDR=$o(^DHCOEDISQTY(0,"ADM",pivaloc,date,DSPStatus,DSPAdmDR)) q:DSPAdmDR=""  d
	....s DSPRowId=""
	....f  s DSPRowId=$o(^DHCOEDISQTY(0,"ADM",pivaloc,date,DSPStatus,DSPAdmDR,DSPRowId)) q:DSPRowId=""  d
	.....s oeori=$p($g(^DHCOEDISQTY(DSPRowId)),"^",1)
	.....q:oeori="" 
	.....s ord=$p(oeori,"||",1)
	.....s itm=$p(oeori,"||",2)
	.....s result=$p(^OEORD(ord,"I",itm,7),"^",3)
	.....q:result=""
	.....s userid=$p(result,",",1)
	.....s username=$p(^SSU("SSUSR",userid),"^",2)
	.....//s status=$p(result,",",4)
	.....s statusStr=##Class(web.DHCSTPIVAS.Common).GetOrdPassState(oeori,"","")
	.....s status=$p(statusStr,"^",1)
	.....q:(status="SHTG")||(status="")
	.....s oeorditmdr=$p(^DHCOEDISQTY(DSPRowId),"^",1)
	.....s OEORIItmMastDR=$p(^OEORD(+oeorditmdr,"I",$p(oeorditmdr,"||",2),1),"^",2)
	.....s itmdesc=$p(^ARCIM(+OEORIItmMastDR,$p(OEORIItmMastDR,"||",2),1),"^",2)
	.....s itmdesc=..GetLinkLine(oeorditmdr)_itmdesc
	.....s dosage=##class(web.DHCSTCOMMONORDER).OeoriDosage(oeorditmdr)
	.....s freq=""
	.....s freqdr=+$p($g(^OEORD(+oeorditmdr,"I",$p(oeorditmdr,"||",2),2)),"^",4) ;OEORI_PHFreq_DR
	.....i freqdr'=0 s freq=$p($g(^PHCFR(freqdr)),"^",3)  ;频率
	.....s instru=""
	.....s instrudr=+$p(^OEORD(+oeorditmdr,"I",$p(oeorditmdr,"||",2),2),"^",7)
	.....s:instrudr'=0 instru=$p(^PHCIN(instrudr),"^",2)        	;用法
	.....s patid=$p(^PAADM(DSPAdmDR),"^",1)
	.....s patname=$p(^PAPER(patid,"ALL"),"^",1)
	.....s patno=$p(^PAPER(patid,"PAT",1),"^",1)
	.....s warddr=$p(^PAADM(DSPAdmDR),"^",70)
	.....q:(wardid'="")&&(warddr'=wardid)
	.....s warddesc=$p(^PAWARD(warddr),"^",2)
	.....s OEORIOEORIDR=$p(^OEORD(+oeorditmdr,"I",$p(oeorditmdr,"||",2),11),"^",39)
	.....i OEORIOEORIDR="" d
	......s chek=$o(^OEORDi(0,"OEORI",+oeorditmdr,oeorditmdr,"0"))
	......i chek'="" s OEORIOEORIDR="主医嘱"
	.....s PHAOMROWID=$o(^DHCPHORDM(0,"OrdItem",oeorditmdr,""),-1)
	.....q:$g(PHAOMROWID)=""
	.....s PHAOMROWIDsub=$o(^DHCPHORDM(0,"OrdItem",oeorditmdr,PHAOMROWID,""))
	.....s DSPOEOREDR=$p(^DHCOEDISQTY(DSPRowId),"^",3)
	.....//s POGROWID=$O(^PIVA(0,"DSP",DSPRowId,"")) q:DSPRowId=""
	.....//s grpNo=$p($g(^PIVA(POGROWID)),"^",2)
    .....s exelabel=$P(DSPOEOREDR,"||")_"-"_$P(DSPOEOREDR,"||",2)_"-"_$P(DSPOEOREDR,"||",3) //_"-"_grpNo  //与扫描执行条码对应
	.....s pivasflag=$p(^DHCOEDISQTY(DSPRowId),"^",27)
	.....s apptype=$p(^DHCPHORDM(PHAOMROWID),"^",9)
	.....s pivasflag1="病区药房"
	.....//s reasonDesc=""
	.....i (pivasflag=0)&&(apptype="PIVAS") s pivasflag1="静配" 
	.....i (((pivasflag=0)&&(apptype'="PIVAS"))||(pivasflag'=0)) s pivasflag=1 
	.....i (jpflag=0)&&(apptype="PIVAS")  d
	......//s reasondr=$p($p(^OEORD(ord,"I",itm,7),"^",3),",",6)
	......s reasondr=$p(^DHCPHORDM(PHAOMROWID,"I",PHAOMROWIDsub),"^",3)
	......//i reasondr'="" s reasonDesc=$p($g(^PIVAOR(reasondr)),"^",2)
	......s reasonDesc=$s(reasondr'="":$p($G(^DHCPCREASON(reasondr)),"^",2),1:"")
	.....i (jpflag=1)&&(apptype'="PIVAS")  d
	......s reasondr=$p(^DHCPHORDM(PHAOMROWID,"I",PHAOMROWIDsub),"^",3)
	......s reasonDesc=$s(reasondr'="":$p($G(^DHCPCREASON(reasondr)),"^",2),1:"")
	.....i jpflag=""  d
	......i apptype="PIVAS"  d
	.......//s reasondr=$p($p(^OEORD(ord,"I",itm,7),"^",3),",",6)
	.......s reasondr=$p(^DHCPHORDM(PHAOMROWID,"I",PHAOMROWIDsub),"^",3)
	.......//i reasondr'="" s reasonDesc=$p($g(^PIVAOR(reasondr)),"^",2)
	.......s reasonDesc=$s(reasondr'="":$p($G(^DHCPCREASON(reasondr)),"^",2),1:"")
	......e  d
	.......s reasondr=$p(^DHCPHORDM(PHAOMROWID,"I",PHAOMROWIDsub),"^",3)
	.......s reasonDesc=$s(reasondr'="":$p($G(^DHCPCREASON(reasondr)),"^",2),1:"")
	.....q:(jpflag'="")&&(jpflag'=pivasflag)
	.....s barcode=""
	.....s mainoroei=OEORIOEORIDR
	.....i mainoroei="主医嘱" s mainoroei=oeorditmdr,barcode=exelabel
	.....e  i mainoroei="" s mainoroei=oeorditmdr,barcode=exelabel
	.....s dosdate=$p(^DHCOEDISQTY(DSPRowId),"^",21)
	.....s dostime=$p(^DHCOEDISQTY(DSPRowId),"^",20)
	.....s index=mainoroei_","_dosdate_","_dostime_","_DSPRowId
	.....s Data1=username_"^"_reasonDesc_"^"_barcode_"^"_pivasflag1_"^"_dosage
	.....s Data2=freq_"^"_instru_"^"_patno_"^"_patname_"^"_warddesc
	.....s Data3=oeorditmdr_"^"_OEORIOEORIDR_"^"_itmdesc
	.....s ^||TMP("DHCPIVA",$this,"Queryszkjcyzshjj",pid,"AuditRefuse",index)=Data1_"^"_Data2_"^"_Data3
	...
	..
	.
	s index="" 
	f  s index=$o(^||TMP("DHCPIVA",$this,"Queryszkjcyzshjj",pid,"AuditRefuse",index)) q:index=""  d
	.Set data=^||TMP("DHCPIVA",$this,"Queryszkjcyzshjj",pid,"AuditRefuse",index)
	.Set Data=$LISTFROMSTRING(data,"^")
	.d QueryOutRow
	d ..ClearTmp("Queryszkjcyzshjj",pid,"AuditRefuse")
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
QueryOutRow           
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
}

/// 静配配液量类别统计
/// d ##class(%ResultSet).RunQuery("web.DHCST.ReportForms.PIVAStat","PivasWorks","2019-01-01","2019-08-22","")
Query PivasWorks(startDate As %String = "", endDate As %String = "", wardid As %String = "", HOSPID As %String = "") As websys.Query(ROWSPEC = "seq:%Integer,status:%String,qty:%Integer") [ SqlProc ]
{
}

ClassMethod PivasWorksExecute(ByRef qHandle As %Binary, startDate As %String = "", endDate As %String = "", wardid As %String = "", HOSPID As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1
	q:(startDate="")||(endDate="") $$$OK
	s startDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(startDate)
	s endDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(endDate)
	s pid=..NewPid()
	d ..ClearTmp("PivasWorks",pid)
    s locstr=..GetPivaLocStr(HOSPID)
    f date=startDate:1:endDate d
    .s cnt=$l(locstr,"^")
	.f kk=1:1:cnt  d
	..s pivaloc=$p(locstr,"^",kk)
	..s PZStaDr=$o(^PIVAS(0,"LOCTYPENUMBER",pivaloc,"I",60,""))
	..q:PZStaDr=""
    ..s pog=""
    ..f  s pog=$o(^PIVA(0,"DATELOC",pivaloc,date,PZStaDr,pog)) q:pog=""  d
    ...s dsp=$p(^PIVA(pog),"^",1)
    ...s admloc=$p(^DHCOEDISQTY(dsp),"^",22)
    ...q:(wardid'="")&&(admloc'=wardid)
	...s oeori=$p(^DHCOEDISQTY(dsp),"^",1)
	...//s drugtype=$p(##class(web.DHCSTPIVA).GetPivaCatType(oeori),"^",2)
	...s drugtype=$p(##class(web.DHCSTPIVAS.Common).GetOrdPivaCat(oeori),"^",2)
	...s index=drugtype
	...i index="" s index="其他"
	...s ^||TMP("DHCPIVA",$this,"PivasWorks",pid,index)=+$G(^||TMP("DHCPIVA",$this,"PivasWorks",pid,index))+1
	..
	.
	s PivaCat="",Count=0
	f  s PivaCat=$o(^||TMP("DHCPIVA",$this,"PivasWorks",pid,PivaCat))  q:PivaCat=""  d
	.s PivaCatNum=^||TMP("DHCPIVA",$this,"PivasWorks",pid,PivaCat)
	.s Count=Count+1
	.s Data=$lb(Count,PivaCat,PivaCatNum)
	.d PivasWorksOutRow 
    d ..ClearTmp("PivasWorks",pid)
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
PivasWorksOutRow            
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
}

/// 静配执行记录时间点统计分析
/// d ##class(%ResultSet).RunQuery("web.DHCST.ReportForms.PIVAStat","QueryszkjcPIVASTIME","2020-06-01","2020-06-10","","","2")
Query QueryszkjcPIVASTIME(startDate As %String = "", endDate As %String = "", WardID As %String = "", limittime As %String = "", HOSPID As %String = "") As websys.Query(ROWSPEC = "warddesc:%String,patno:%String,patname:%String,arcitmdesc:%String,dos:%String,peizhi:%String,dabao:%String,jieshou:%String,OEOREExecuted:%String,DSPOEOREDR:%String,peizitodabao:%String,dabaotojieshou:%String,jieshoutozhixing:%String,peizhitozhixing:%String") [ SqlProc ]
{
}

ClassMethod QueryszkjcPIVASTIMEExecute(ByRef qHandle As %Binary, startDate As %String = "", endDate As %String = "", WardID As %String = "", limittime As %String = "", HOSPID As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1
	q:startDate="" $$$OK
	q:endDate="" $$$OK
	//s ^hlh($h)=$lb(startDate,endDate,WardID,limittime)
	s startDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(startDate)
	s endDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(endDate)
	s pid=..NewPid()
	d ..ClearTmp("QueryszkjcPIVASTIME",pid,"PIVASTIME")
	s locstr=..GetPivaLocStr(HOSPID)
    f date=startDate:1:endDate d
    .s cnt=$l(locstr,"^")
	.f kk=1:1:cnt  d
	..s pivaloc=$p(locstr,"^",kk)
    ..s admloc="" 
    ..f  s admloc=$o(^DHCOEDISQTY(0,"REC",pivaloc,date,"C",admloc))  q:admloc=""  d
    ...q:($g(WardID)'="")&&($g(WardID)'=admloc)
    ...s dsp=""  
    ...f  s dsp=$o(^DHCOEDISQTY(0,"REC",pivaloc,date,"C",admloc,"0",dsp)) q:dsp=""  d
    ....s (dosdate,dostime,peizhidate,peizhitime,dabaodate,dabaotime,jieshoudate,jieshoutime,OEOREDateExecuted,OEORETimeExecuted,peizitodabao,dabaotojieshou,jieshoutozhixing,peizhitozhixing)=""
    ....s warddesc=$p(^CTLOC(admloc),"^",2)
    ....s admdr=$p(^DHCOEDISQTY(dsp),"^",26)
    ....q:($p(^PAADM(admdr), "^", 2)'="I")
    ....s patid=$p(^PAADM(admdr),"^",1)
    ....s patname=$p(^PAPER(patid,"ALL"),"^",1)
    ....s patno=$p(^PAPER(patid,"PAT",1),"^",1)
    ....s DSPOEORIDR=$p(^DHCOEDISQTY(dsp),"^",1)
    ....s OEORIItmMastDR=$p(^OEORD(+DSPOEORIDR,"I",$p(DSPOEORIDR,"||",2),1),"^",2)
    ....s arcitmdesc=$p(^ARCIM(+OEORIItmMastDR,$p(OEORIItmMastDR,"||",2),1),"^",2)
    ....s DSPOEOREDR=$p(^DHCOEDISQTY(dsp),"^",3)
    ....s arcitmdesc=..GetLinkLine(DSPOEORIDR)_arcitmdesc
    ....s dosdate=$p(^DHCOEDISQTY(dsp),"^",21)
	....s dostime=$p(^DHCOEDISQTY(dsp),"^",20)
	....s OEOREDateExecuted=$p(^OEORD(+DSPOEOREDR,"I",$p(DSPOEOREDR,"||",2),"X",$p(DSPOEOREDR,"||",3)),"^",19)
	....s OEORETimeExecuted=$p(^OEORD(+DSPOEOREDR,"I",$p(DSPOEOREDR,"||",2),"X",$p(DSPOEOREDR,"||",3)),"^",20)
	....s POGROWID=$O(^PIVA(0,"DSP",dsp,""))
	....i $g(POGROWID)'=""  d
	.....//s grpNo=$p(^PIVA(POGROWID),"^",2)
    .....s exelabel=$P(DSPOEOREDR,"||")_"-"_$P(DSPOEOREDR,"||",2)_"-"_$P(DSPOEOREDR,"||",3) //_"-"_grpNo  //与扫描执行条码对应
    .....s PZStaId=$o(^PIVAS(0,"LOCTYPENUMBER",pivaloc,"I",60,""),-1)
	.....s subpeizhi=$o(^PIVA(0,"PS",PZStaId,POGROWID,""))
	.....s:subpeizhi'="" peizhidate=$p(^PIVA(POGROWID,"S",subpeizhi),"^",4)
	.....s:subpeizhi'="" peizhitime=$p(^PIVA(POGROWID,"S",subpeizhi),"^",5)
	.....s DBStaId=$o(^PIVAS(0,"LOCTYPENUMBER",pivaloc,"I",80,""),-1)
	.....s subdabao=$o(^PIVA(0,"PS",DBStaId,POGROWID,""))
	.....s:subdabao'="" dabaodate=$p(^PIVA(POGROWID,"S",subdabao),"^",4)
	.....s:subdabao'="" dabaotime=$p(^PIVA(POGROWID,"S",subdabao),"^",5)
	.....s JSStaId=$o(^PIVAS(0,"LOCTYPENUMBER",pivaloc,"I",90,""),-1)
	.....q:JSStaId=""  //可能没有这个流程，此处要判断下，2020-06-11
	.....s subjieshou=$o(^PIVA(0,"PS",JSStaId,POGROWID,""))
	.....s:subjieshou'="" jieshoudate=$p(^PIVA(POGROWID,"S",subjieshou),"^",4)
	.....s:subjieshou'="" jieshoutime=$p(^PIVA(POGROWID,"S",subjieshou),"^",5)
	....s peizitodabao=..TIMEANNAZY(peizhidate,peizhitime,dabaodate,dabaotime)
	....s dabaotojieshou=..TIMEANNAZY(dabaodate,dabaotime,jieshoudate,jieshoutime)
	....s jieshoutozhixing=..TIMEANNAZY(jieshoudate,jieshoutime,OEOREDateExecuted,OEORETimeExecuted)
	....s peizhitozhixing=..TIMEANNAZY(peizhidate,peizhitime,OEOREDateExecuted,OEORETimeExecuted)
	....s:peizitodabao'="" peizitodabao=$fn(peizitodabao,"",0)_"分钟"
	....s:dabaotojieshou'="" dabaotojieshou=$fn(dabaotojieshou,"",0)_"分钟"
	....s:jieshoutozhixing'="" jieshoutozhixing=$fn(jieshoutozhixing,"",0)_"分钟"
	....s wendingtime=..GetPivawendingTime(POGROWID)
	....i wendingtime=0 s wendingtime=999
	....q:(limittime="Y")&&((peizhitozhixing<=(wendingtime*60))||(peizhitozhixing=""))
	....s:peizhitozhixing'="" peizhitozhixing=$fn(peizhitozhixing,"",0)_"分钟"
	....s:dosdate'="" dosdate=$zd(dosdate,3)
	....s:peizhidate'="" peizhidate=$zd(peizhidate,3)
	....s:dabaodate'="" dabaodate=$zd(dabaodate,3)
	....s:jieshoudate'="" jieshoudate=$zd(jieshoudate,3)
	....s:OEOREDateExecuted'="" OEOREDateExecuted=$zd(OEOREDateExecuted,3)
	....s:dostime'="" dostime=$zt(dostime,1)
	....s:peizhitime'="" peizhitime=$zt(peizhitime,1)
	....s:dabaotime'="" dabaotime=$zt(dabaotime,1)
	....s:jieshoutime'="" jieshoutime=$zt(jieshoutime,1)
	....s:OEORETimeExecuted'="" OEORETimeExecuted=$zt(OEORETimeExecuted,1)
	....s mainoroei=$p(^OEORD(+DSPOEORIDR,"I",$p(DSPOEORIDR,"||",2),11),"^",39)
	....i mainoroei="" s mainoroei=DSPOEORIDR
    ....s index=mainoroei_","_dosdate_","_dostime_","_dsp
    ....s Data1=warddesc_"^"_patno_"^"_patname_"^"_arcitmdesc_"^"_dosdate_" "_dostime
    ....s Data2=peizhidate_" "_peizhitime_"^"_dabaodate_" "_dabaotime_"^"_jieshoudate_" "_jieshoutime_"^"_OEOREDateExecuted_" "_OEORETimeExecuted_"^"_exelabel
    ....s Data3=peizitodabao_"^"_dabaotojieshou_"^"_jieshoutozhixing_"^"_peizhitozhixing
    ....s ^||TMP("DHCPIVA",$this,"QueryszkjcPIVASTIME",pid,"PIVASTIME",index)=Data1_"^"_Data2_"^"_Data3
    ...
	..
	. 
    s index="" 
    f  s index=$o(^||TMP("DHCPIVA",$this,"QueryszkjcPIVASTIME",pid,"PIVASTIME",index)) q:index=""  d
    .set data=^||TMP("DHCPIVA",$this,"QueryszkjcPIVASTIME",pid,"PIVASTIME",index)
    .Set Data=$LISTFROMSTRING(data,"^")
	.d QueryszkjcPIVASTIMEOutRow
    d ..ClearTmp("QueryszkjcPIVASTIME",pid,"PIVASTIME")
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
QueryszkjcPIVASTIMEOutRow   
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
}

/// 静配停止执行记录分析统计
/// d ##class(%ResultSet).RunQuery("web.DHCST.ReportForms.PIVAStat","PivasStopOrdexcs","2019-03-15","2019-04-01","")
Query PivasStopOrdexcs(startDate As %String = "", endDate As %String = "", wardid As %String = "", HOSPID As %String = "") As websys.Query(ROWSPEC = "seq:%Integer,status:%String,qty:%Integer") [ SqlProc ]
{
}

ClassMethod PivasStopOrdexcsExecute(ByRef qHandle As %Binary, startDate As %String = "", endDate As %String = "", wardid As %String = "", HOSPID As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1
	q:(startDate="")||(endDate="") $$$OK
	s startDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(startDate)
	s endDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(endDate)
    s beforshenhe=0  ;审核前停止数量
    s beforpaipi=0   ;排批钱停止数量
    s befordaqian=0  ;打签前停止数量
    s beforpeizhi=0  ;配置前停止数量
    s afterpeizhi=0  ;配置后停止数量
    s sum=0
    f date=startDate:1:endDate d
    .s OEOREXTime=""
    .f  s OEOREXTime=$o(^OEORDi(0,"StopExecE",date,OEOREXTime)) q:OEOREXTime=""  d
    ..s OEORDRowId=""
    ..f  s OEORDRowId=$o(^OEORDi(0,"StopExecE",date,OEOREXTime,OEORDRowId)) q:OEORDRowId=""  d
    ...s adm=$P(^OEORD(OEORDRowId),"^",1)
    ...s deploc=$P(^PAADM(adm),"^",4)
    ...q:(HOSPID'="")&&(HOSPID'=$P(^CTLOC(deploc),"^",22))  //按院区过滤
    ...s OEORIChildsub=""
    ...f  s OEORIChildsub=$o(^OEORDi(0,"StopExecE",date,OEOREXTime,OEORDRowId,OEORIChildsub)) q:OEORIChildsub=""  d
    ....s OEORIOEORIDR=$p(^OEORD(+OEORDRowId,"I",OEORIChildsub,11),"^",39)
    ....q:OEORIOEORIDR'=""
    ....s OEOREChildsub=""
    ....f  s OEOREChildsub=$o(^OEORDi(0,"StopExecE",date,OEOREXTime,OEORDRowId,OEORIChildsub,OEOREChildsub)) q:OEOREChildsub=""  d
    .....s DSPRowId=$O(^DHCOEDISQTY(0,"OEORE",OEORDRowId_"||"_OEORIChildsub_"||"_OEOREChildsub,""))
    .....q:$g(DSPRowId)=""
    .....s DSPCategory=$p(^DHCOEDISQTY(DSPRowId),"^",27)
    .....q:DSPCategory'=0
    .....s admloc=$p(^DHCOEDISQTY(DSPRowId),"^",22)
    .....q:(wardid'="")&&(admloc'=wardid)
    .....s sum=sum+1
    .....s grpno=$p(^DHCOEDISQTY(DSPRowId),"^",4)
    .....s POG=$o(^PIVA(0,"OEGRP",+DSPRowId,+grpno,""))
    .....i POG'="" d
    ......//打签过的
    ......s orddate=$p(^PIVA(POG),"^",4)
    ......s POGSChildSub=$o(^PIVA(POG,"S",""),-1)
    ......s POGSPSDr=$p(^PIVA(POG,"S",POGSChildSub),"^",2)
    ......s PSNumber=$p(^PIVAS(POGSPSDr),"^",1)
    ......i PSNumber<10 s befordaqian=befordaqian+1 ;打签前
    ......i (PSNumber>10)&&(PSNumber<60)   s beforpeizhi=beforpeizhi+1 ;配置前
    ......i PSNumber>=60 d
    .......s check=""
    .......s PHARRowid=""
    .......f  s PHARRowid=$o(^PHARET(0,"OEDIS",OEORDRowId_"||"_OEORIChildsub,orddate,PHARRowid)) q:PHARRowid=""  d
    ........s PHARIChildSub=""  
    ........f  s PHARIChildSub=$o(^PHARET(0,"OEDIS",OEORDRowId_"||"_OEORIChildsub,orddate,PHARRowid,PHARIChildSub)) q:PHARIChildSub=""  d
    .........s PHARIDoDisDr=$p($G(^PHARET(PHARRowid,"I",PHARIChildSub)),"^",13)
    .........i PHARIDoDisDr=DSPRowId s check=1
    .......i check=1 s afterpeizhi=afterpeizhi+1 ;配置后
    .....e  d
    ......//没打过签的
    ......S AuditFlag=##class(web.DHCSTKUTIL).GetOrdAuditResult(DSPRowId)
    ......S ParmacyAudit=$S(AuditFlag="Y":1,AuditFlag="N":2,1:0)
    ......i ParmacyAudit=0 s beforshenhe=beforshenhe+1 ;审核前
    ......e  d
    .......s orditm=$p(^DHCOEDISQTY(DSPRowId),"^",1)
    .......s mOeori=##class(web.DHCSTCNTSCOMMON).GetMainOeori(orditm)
	.......s dspID=$o(^DHCOEDISQTY(0,"OEORI",mOeori,""))
    .......s paipi=..GetCurUpBatState(DSPRowId)
    .......i paipi'="Y" s beforpaipi=beforpaipi+1 ;排批前
    .......e  s befordaqian=befordaqian+1 ;打签前
   	d PivasStopOrdexcsOutRow(2,"排批前",beforpaipi)
	d PivasStopOrdexcsOutRow(3,"打签前",befordaqian)
	d PivasStopOrdexcsOutRow(4,"配置前",beforpeizhi)
	d PivasStopOrdexcsOutRow(5,"配置后(退药)",afterpeizhi)
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
PivasStopOrdexcsOutRow(seq,status,qty)         
	set Data=$lb(seq,status,qty)    
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
}

/// ////////////////////// ////////////////////// ////////////////////// ///////////////////
/// ///////////////////上面为Query方法,下面为过程函数,请按此规则////////////////////////////
/// ////////////////////// ////////////////////// ////////////////////// ///////////////////
ClassMethod GetLinkLine(orditm)
{
	s flag=..GetOeordLevel(orditm)				
    i flag=2 q "┋    "
    i flag=3 q "┕┉┉"
    i flag=1 q "┍┉┉"
    q ""
}

// w ##class(web.DHCST.ReportForms.PIVAStat).GetOeordLevel("135||322||1")

ClassMethod GetOeordLevel(OeorEDr)
{
	
	s n="" 
	s a=+OeorEDr
	s b=$p(OeorEDr,"||",2)
	q:'$d(^OEORD(a,"I",b,11)) n
	S ArcimRowid=$P($g(^OEORD(a,"I",b,1)),"^",2)
	s ItemCatDR=$p(^ARCIM(+ArcimRowid,$p(ArcimRowid,"||",2),1),"^",10)
	s OrderType=$P(^ARC("IC",ItemCatDR),"^",7)
	q:OrderType'="R" n
	S DRDR=$P($g(^OEORD(a,"I",b,11)),"^",39)
	i DRDR="" D
	.//代表这个有可能是主医嘱
	.i $d(^OEORDi(0,"OEORI",a,a_"||"_b)) D
	..s tb="" f  s tb=$o(^OEORDi(0,"OEORI",a,a_"||"_b,tb)) q:tb=""  d
	...s LuserId=$P($G(^OEORD(a,"I",tb,7)),"^",1)
    ...q:LuserId=""
	...s LctcpId=$P(^SSU("SSUSR",LuserId),"^",14)
	...q:LctcpId=""
    ...s LctcptId=$P(^CTPCP(LctcpId,1),"^",4)  ;CTPCP_CarPrvTp_DR
	...q:LctcptId=""
    ...s LctcptType=$P(^CT("CPT",LctcptId),"^",4)	
    ...q:LctcptType'="DOCTOR"
	...s n=1
	e  d
	.//代表这个一定是子医嘱
	.//判断是不是最后一个子医嘱
	.s Flag=0,FID="",LastID=""
	.s ID="" f  s ID=$o(^OEORDi(0,"OEORI",a,DRDR,ID),-1) q:((ID="")!(Flag))  d
	..s ArcimRowid=$P($g(^OEORD(a,"I",ID,1)),"^",2)
	..s ItemCatDR=$p(^ARCIM(+ArcimRowid,$p(ArcimRowid,"||",2),1),"^",10)
	..s OrderType=$P(^ARC("IC",ItemCatDR),"^",7)
	..;b ;;11
	..I ID'=""  D
	...;S:OrderType'="R"&&(LastID="") LastID=FID
	...S:OrderType="R"&&(LastID="") LastID=ID
	...S FID=ID
	.i (b=LastID) d
	..s n=3
	.e  d
	..s n=2
	q n
}

/// w ##class(web.SZKJCYY.Query.JCQuery).TIMEANNAZY("2016-05-17","2017-12-12")
ClassMethod TIMEANNAZY(STADATE As %String, STATIME As %String, ENDDATE As %String, ENDTIME As %String) As %String
{
	q:(STADATE="")||(STATIME="")||(ENDDATE="")||(ENDTIME="") ""
	s ret=""
	s ret=86400*(ENDDATE-STADATE)-STATIME+ENDTIME
	q ret/60
}

/// w ##class(web.SZKJCYY.Query.JCQuery).GetPivawendingTime(152073)
ClassMethod GetPivawendingTime(pog As %String)
{
	s pogsub=""
	s ret=0
	F  S pogsub=$O(^PIVA(pog,"I",pogsub)) Q:pogsub=""  D
	.s incitime=..GetExeTimeByPogi(pog_"||"_pogsub)
	.i ret=0 s ret=incitime
	.e  i (incitime<ret)&&(incitime'=0)  s ret=incitime
	q ret
}

ClassMethod GetExeTimeByPogi(pogi)
{
	s pog=+pogi
	s pogsub=$p(pogi,"||",2)
	S plocdr=$P(^PIVA(pog),"^",7)
	s dsp=$p(^PIVA(pog,"I",pogsub),"^",1)
	s oeori=$p(^DHCOEDISQTY(dsp),"^",1)
	s arcim=$P(^OEORD(+oeori,"I",$p(oeori,"||",2),1),"^",2)
	q:arcim="" 0
	s inci=$O(^INCI(0,"ARCIM_DR",+arcim,""))
	q:inci="" 0
	s il=$o(^INCI("IL_LOC",plocdr,inci,0))
	q:il="" 0
	s incil=inci_"||"_il
	s rowid=$o(^PIVAD(0,"INCIL",incil,""))
	q:rowid="" 0
	s time=+$p(^PIVAD(rowid),"^",6)
	q time
}

/// 获取排批状态
/// w ##class(web.DHCST.ReportForms.PIVAStat).GetCurUpBatState(975)
ClassMethod GetCurUpBatState(dodis)
{
	S grpno=$O(^PIVABU(0,"OEGRP",dodis,""))
	Q:grpno="" ""
	s batno=""
	s updflag=""
	s bupddr=$o(^PIVABU(0,"OEGRP",dodis,grpno,""),-1)
	i bupddr'="" d
	.s upinfo=$g(^PIVABU(bupddr))
	.s updflag=$p(upinfo,"^",7) ;"S"是系统排批;"N"是护士修改批次;"NY"是护士排批确认;"P"静配中心修改批次,"Y"是静配中心完成排批
	q updflag
}

/// 获取配液中心的科室ID串
ClassMethod GetPivaLocStr(HOSPID = "")
{
	s locstr=""
	s str="%静脉药物配置%"
	&sql(declare xxx cursor for select CTLOC_RowID from ct_loc where ctloc_desc like :str)
    s result=""
    &sql(open xxx)
    f  &sql(fetch xxx into :ctlocrowid) q:SQLCODE  d
    .q:(HOSPID'="")&&(HOSPID'=$P(^CTLOC(ctlocrowid),"^",22))  //按院区过滤
    .i locstr="" s locstr=ctlocrowid
    .e  s locstr=locstr_"^"_ctlocrowid
	&sql(close xxx)
	q locstr
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
  	q ##class(web.DHCSTKUTIL).NewPid($ClassName(),"PIVA")
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
	.K ^||TMP("DHCPIVA",$this,MethodName,pid,PAR)
	.K ^TEMP("DHCPIVA",$this,MethodName,pid,PAR)
	E  D
	.K ^||TMP("DHCPIVA",$this,MethodName,pid)
	.K ^TEMP("DHCPIVA",$this,MethodName,pid)
	Q ""
}

}
