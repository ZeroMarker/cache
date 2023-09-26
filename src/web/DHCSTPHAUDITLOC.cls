Import sqluser

Class web.DHCSTPHAUDITLOC Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// Creator : MYQ 
/// CreatDate : 2014-10-23
/// 获取药房列表
/// 
/// w ##class(web.DHCSTPHAUDITLOC).GetPhaLocDs(484)
ClassMethod GetPhaLocDs(logonloc, comboText = "", hosp = "") As %String
{
	k GetPhaLocDsMD
	s comboText=$zcvt(comboText,"U")
	i hosp'="" s logonhospdr=hosp
	e  s logonhospdr=$p(^CTLOC(logonloc),"^",22)
	s h=0
	s ctlocdr=0
	f  s ctlocdr=$o(^CTLOC(ctlocdr)) q:ctlocdr=""  d
	.s hospdr=$p(^CTLOC(ctlocdr),"^",22)
	.q:logonhospdr'=hospdr
	.s loctype=$p(^CTLOC(ctlocdr),"^",13)
	.q:loctype'="D"
	.s frDate=$p(^CTLOC(ctlocdr),"^",24)
	.q:(frDate'="")&&(frDate>(+$h)) 
	.s toDate=$p(^CTLOC(ctlocdr),"^",25)
	.q:(toDate'="")&&(toDate<(+$h)) 
	.s ctlocdesc=$p(^CTLOC(ctlocdr),"^",2)
	.s ctlocconname=$zcvt($p(^CTLOC(ctlocdr),"^",43),"U")
	.q:(comboText'="")&&($zcvt(ctlocdesc,"U")'[comboText)&&(ctlocconname'[comboText)
	.s h=h+1
    .s data=ctlocdesc_"^"_ctlocdr
    .s GetPhaLocDsMD(h)=data
    q:h=0 ##class(web.DHCSTEXTCOMMON).GetNoJson()
    s maxrow=h
    
    s count=0
    s h=""
    f  s h=$o(GetPhaLocDsMD(h)) q:h=""  d
    .s data=GetPhaLocDsMD(h)
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
	q ""
}

/// Creator : MYQ 
/// CreatDate : 2014-10-23
/// 获取科室列表
/// 
/// w ##class(web.DHCSTPHAUDITLOC).GetOrdLocDs(484)
ClassMethod GetOrdLocDs(logonloc, comboText = "", hosp = "") As %String
{
	s comboText=$zcvt(comboText,"U")
	s pid=##class(web.DHCSTPCHCOLLS).NewPid()
	i hosp'="" s logonhospdr=hosp
	e  s logonhospdr=$p(^CTLOC(logonloc),"^",22)
	s h=0
	s ctlocdr=0
	f  s ctlocdr=$o(^CTLOC(ctlocdr)) q:ctlocdr=""  d
	.s hospdr=$p(^CTLOC(ctlocdr),"^",22)
	.q:logonhospdr'=hospdr
	.s loctype=$p(^CTLOC(ctlocdr),"^",13)
	.q:loctype'="E"
	.s frDate=$p(^CTLOC(ctlocdr),"^",24)
	.q:(frDate'="")&&(frDate>(+$h)) 
	.s toDate=$p(^CTLOC(ctlocdr),"^",25)
	.q:(toDate'="")&&(toDate<(+$h)) 
	.s ctlocdesc=$p(^CTLOC(ctlocdr),"^",2)
	.s ctlocconname=$zcvt($p(^CTLOC(ctlocdr),"^",43),"U")
	.q:(comboText'="")&&($zcvt(ctlocdesc,"U")'[comboText)&&(ctlocconname'[comboText)
	.s h=h+1
    .s data=ctlocdesc_"^"_ctlocdr
    .s ^TMP("dhcpha","web.DHCSTPHAUDITLOC","GetOrdLocDs",pid,h)=data
    q:h=0 ##class(web.DHCSTEXTCOMMON).GetNoJson()
    s maxrow=h
    
    s count=0
    s h=""
    f  s h=$o(^TMP("dhcpha","web.DHCSTPHAUDITLOC","GetOrdLocDs",pid,h)) q:h=""  d
    .s data=^TMP("dhcpha","web.DHCSTPHAUDITLOC","GetOrdLocDs",pid,h)
    .s desc=$p(data,"^",1)
    .s rowid=$p(data,"^",2)
    .
    .s ordlocdesc=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("ordlocdesc",desc)
	.s ordlocdr=##class(web.DHCSTEXTCOMMON).GetJsonLastCell("ordlocdr",rowid)
	.
	.s tmpstr=ordlocdesc_ordlocdr
    .s startString=##class(web.DHCSTEXTCOMMON).GetJsonStartString(maxrow)
    .s firstrow=##class(web.DHCSTEXTCOMMON).GetJsonFirstRow(tmpstr)
    .s lastrow=##class(web.DHCSTEXTCOMMON).GetJsonLastRow(tmpstr)
	.s count=count+1
	.i count=1 w startString
    .i count<maxrow w firstrow
    .i count=maxrow w lastrow
	.
	k ^TMP("dhcpha","web.DHCSTPHAUDITLOC","GetOrdLocDs",pid)
	q ""
}

/// Creator : MYQ 
/// CreatDate : 2014-10-28
/// 药师列表
/// 
/// w ##class(web.DHCSTPHAUDITLOC).GetPhaDs(484)
ClassMethod GetPhaDs(logonloc, hosp = "") As %String
{
	s pid=##class(web.DHCSTPCHCOLLS).NewPid()
	i hosp'="" s logonhospdr=hosp
	e  s logonhospdr=$p(^CTLOC(logonloc),"^",22)
	s h=0
	s ssusrid=""
	f  s ssusrid=$o(^SSU("SSUSR",ssusrid)) q:ssusrid=""  d
	.s hospdr=$p(^SSU("SSUSR",ssusrid),"^",98)
	.q:logonhospdr'=hospdr
	.s ssusrname=$p(^SSU("SSUSR",ssusrid),"^",2)
	.s h=h+1
    .s data=ssusrname_"^"_ssusrid
    .s ^TMP("dhcpha","web.DHCSTPHAUDITLOC","GetPhaDs",pid,h)=data
    q:h=0 ##class(web.DHCSTEXTCOMMON).GetNoJson()
    s maxrow=h
    
    s count=0
    s h=""
    f  s h=$o(^TMP("dhcpha","web.DHCSTPHAUDITLOC","GetPhaDs",pid,h)) q:h=""  d
    .s data=^TMP("dhcpha","web.DHCSTPHAUDITLOC","GetPhaDs",pid,h)
    .s desc=$p(data,"^",1)
    .s rowid=$p(data,"^",2)
    .
    .s ssusrname=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("ssusrname",desc)
	.s ssusrid=##class(web.DHCSTEXTCOMMON).GetJsonLastCell("ssusrid",rowid)
	.
	.s tmpstr=ssusrname_ssusrid
    .s startString=##class(web.DHCSTEXTCOMMON).GetJsonStartString(maxrow)
    .s firstrow=##class(web.DHCSTEXTCOMMON).GetJsonFirstRow(tmpstr)
    .s lastrow=##class(web.DHCSTEXTCOMMON).GetJsonLastRow(tmpstr)
	.s count=count+1
	.i count=1 w startString
    .i count<maxrow w firstrow
    .i count=maxrow w lastrow
	.
	k ^TMP("dhcpha","web.DHCSTPHAUDITLOC","GetPhaDs",pid)
	q ""
}

/// CreateDate : 2014-10-23
/// Creator : MYQ
/// Function : 查询已维护的需审核科室
/// 
/// w ##class(web.DHCSTPHAUDITLOC).QueryAuditLocDetail(484,484,"")
ClassMethod QueryAuditLocDetail(logonloc, PhaLocDr, OrdLocDr, hosp = "") As %String
{
	s pid=##class(web.DHCSTPCHCOLLS).NewPid()
	i hosp'="" s logonhospdr=hosp
	e  s logonhospdr=$p(^CTLOC(logonloc),"^",22)
	s h=0
	i (PhaLocDr="")&(OrdLocDr="") d
	.s palid=0
	.f  s palid=$o(^DHCSTPAL(palid)) q:(palid="")||(palid=0)  d
	..s phalocdr=$p(^DHCSTPAL(palid),"^",1)
	..s hospdr=$p(^CTLOC(phalocdr),"^",22)
	..q:logonhospdr'=hospdr
	..s ordlocdr=$p(^DHCSTPAL(palid),"^",2)
	..s phalocdesc="",ordlocdesc=""
	..s:phalocdr'="" phalocdesc=$p(^CTLOC(phalocdr),"^",2)
	..s:ordlocdr'="" ordlocdesc=$p(^CTLOC(ordlocdr),"^",2)
	..s h=h+1
    ..s data=phalocdr_"^"_phalocdesc_"^"_ordlocdr_"^"_ordlocdesc_"^"_palid
    ..s ^TMP("dhcpha","web.DHCSTPHAUDITLOC","QueryAuditLocDetail",pid,h)=data
    
    e  i (PhaLocDr'="")&(OrdLocDr="") d
    .s plaordloc=""
    .f  s plaordloc=$o(^DHCSTPAL(0,"PhOrdLoc",PhaLocDr,plaordloc)) q:plaordloc=""  d
	..s palid=""
	..f  s palid=$o(^DHCSTPAL(0,"PhOrdLoc",PhaLocDr,plaordloc,palid)) q:palid=""  d
	...s phalocdr=$p(^DHCSTPAL(palid),"^",1)
	...s hospdr=$p(^CTLOC(phalocdr),"^",22)
	...q:logonhospdr'=hospdr
	...s ordlocdr=$p(^DHCSTPAL(palid),"^",2)
	...s phalocdesc="",ordlocdesc=""
	...s:phalocdr'="" phalocdesc=$p(^CTLOC(phalocdr),"^",2)
	...s:ordlocdr'="" ordlocdesc=$p(^CTLOC(ordlocdr),"^",2)
	...s h=h+1
    ...s data=phalocdr_"^"_phalocdesc_"^"_ordlocdr_"^"_ordlocdesc_"^"_palid
    ...s ^TMP("dhcpha","web.DHCSTPHAUDITLOC","QueryAuditLocDetail",pid,h)=data
    
    e  d
    .s plaphloc=""
    .f  s plaphloc=$o(^DHCSTPAL(0,"OrdPhLoc",OrdLocDr,plaphloc)) q:plaphloc=""  d
	..s palid=""
	..f  s palid=$o(^DHCSTPAL(0,"OrdPhLoc",OrdLocDr,plaphloc,palid)) q:palid=""  d
	...s phalocdr=$p(^DHCSTPAL(palid),"^",1)
	...q:(PhaLocDr'="")&(PhaLocDr'=phalocdr)
	...s hospdr=$p(^CTLOC(phalocdr),"^",22)
	...q:logonhospdr'=hospdr
	...s ordlocdr=$p(^DHCSTPAL(palid),"^",2)
	...s phalocdesc="",ordlocdesc=""
	...s:phalocdr'="" phalocdesc=$p(^CTLOC(phalocdr),"^",2)
	...s:ordlocdr'="" ordlocdesc=$p(^CTLOC(ordlocdr),"^",2)
	...s h=h+1
    ...s data=phalocdr_"^"_phalocdesc_"^"_ordlocdr_"^"_ordlocdesc_"^"_palid
    ...s ^TMP("dhcpha","web.DHCSTPHAUDITLOC","QueryAuditLocDetail",pid,h)=data
    
    q:h=0 ##class(web.DHCSTEXTCOMMON).GetNoJson()
    s maxrow=h
    s count=0
    s h=""
    f  s h=$o(^TMP("dhcpha","web.DHCSTPHAUDITLOC","QueryAuditLocDetail",pid,h)) q:h=""  d
    .s data=^TMP("dhcpha","web.DHCSTPHAUDITLOC","QueryAuditLocDetail",pid,h)
    .s phalocdr=$p(data,"^",1)
    .s phalocdesc=$p(data,"^",2)
    .s ordlocdr=$p(data,"^",3)
    .s ordlocdesc=$p(data,"^",4)
    .s palid=$p(data,"^",5)
    .
    .s phalocdr=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("phalocdr",phalocdr)
    .s phalocdesc=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("phalocdesc",phalocdesc)
	.s ordlocdr=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("ordlocdr",ordlocdr)
	.s ordlocdesc=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("ordlocdesc",ordlocdesc)
	.s palid=##class(web.DHCSTEXTCOMMON).GetJsonLastCell("palid",palid)
	.
	.s tmpstr=phalocdr_phalocdesc_ordlocdr_ordlocdesc_palid
    .s startString=##class(web.DHCSTEXTCOMMON).GetJsonStartString(maxrow)
    .s firstrow=##class(web.DHCSTEXTCOMMON).GetJsonFirstRow(tmpstr)
    .s lastrow=##class(web.DHCSTEXTCOMMON).GetJsonLastRow(tmpstr)
	.s count=count+1
	.i count=1 w startString
    .i count<maxrow w firstrow
    .i count=maxrow w lastrow
	.
	k ^TMP("dhcpha","web.DHCSTPHAUDITLOC","QueryAuditLocDetail",pid)
	q ""
}

/// 增加需审核科室
/// w ##class(web.DHCSTPHAUDITLOC).AddAuditLoc("484","436") 
ClassMethod AddAuditLoc(NPhaLocDr, NOrdLocDr) As %String
{
	s ^tmyq("AddAuditLoc")=NPhaLocDr_","_NOrdLocDr
	s flag=0
	s palid=0
	f  s palid=$o(^DHCSTPAL(palid)) q:(palid="")||(palid=0)||(flag=1)  d
	.s phalocdr=$p(^DHCSTPAL(palid),"^",1)
	.s ordlocdr=$p(^DHCSTPAL(palid),"^",2)
	.s:(NPhaLocDr=phalocdr)&&(NOrdLocDr=ordlocdr) flag=1
	i (flag=1) q 100
	
	k PLIST
	s PLIST(2)=NPhaLocDr
	s PLIST(3)=NOrdLocDr
	&sql(INSERT INTO DHC_StPhAuditLoc VALUES :PLIST()) 
 	i SQLCODE'=0 q -1
 	q 0
}

/// 删除需审核科室
/// w ##class(web.DHCSTPHAUDITLOC).AuditLocDel("1")
ClassMethod AuditLocDel(palid) As %String
{
    
    &sql(delete from DHC_StPhAuditLoc where PAL_RowId = :palid )
 	i SQLCODE'=0 q -1
 	q 0
}

/// CreateDate : 2014-10-27
/// Creator : MYQ
/// Function : 统计医嘱审核明细
/// Input : 时间段,datestr;审核人,auditor;开单科室,ordlocdr
/// w ##class(web.DHCSTPHAUDITLOC).QueryAuditedDetail("2014-10-22^2014-11-22","879","","484")
ClassMethod QueryAuditedDetail(datestr, auditor, ordlocdr, phalocdr) As %String
{
	//n (auditor,datestr,ordlocdr,phalocdr)
	q:datestr="" ""
	s pid=##class(web.DHCSTPCHCOLLS).NewPid()
	;s ^tmyq("QueryAuditedDetail")=datestr_","_auditor_","_ordlocdr_","_phalocdr
	s startdate=$p(datestr,"^",1)
	s enddate=$p(datestr,"^",2)
	s:startdate["-" stdate=$zdh(startdate,3)
	s:enddate["-" eddate=$zdh(enddate,3)
	s:startdate["/" stdate=$zdh(startdate,4)
	s:enddate["/" eddate=$zdh(enddate,4)
	
	s h=0
	f date=stdate:1:eddate d
	.s phaomid=""
	.f  s phaomid=$o(^DHCPHORDM(0,"DateLoc",date,phalocdr,phaomid)) q:phaomid=""  d
	..s audituser=$p(^DHCPHORDM(phaomid),"^",1)  ;审核人
	..s auditusername=$p(^SSU("SSUSR",audituser),"^",2)  ;审核人姓名
	..q:(auditor'="")&(auditor'=audituser)
	..s phaomch=""
	..f  s phaomch=$o(^DHCPHORDM(phaomid,"I",phaomch)) q:phaomch=""  d
	...s orditemdr=$p(^DHCPHORDM(phaomid,"I",phaomch),"^",2)  ;医嘱明细ID
	...s orderloc=$p(^OEORD(+orditemdr,"I",$p(orditemdr,"||",2),1),"^",3)
	...q:(ordlocdr'="")&(ordlocdr'=orderloc)
	...s ordlocdesc=$p(^CTLOC(orderloc),"^",2) ;开单科室
	...s phalocdesc=$p(^CTLOC(phalocdr),"^",2) ;发药科室
	...s h=h+1
	...s datastr=date_"^"_auditusername_"^"_ordlocdesc_"^"_phalocdesc
	...s ^TMP("dhcpha","web.DHCSTPHAUDITLOC","QueryAuditedDetail",pid,audituser,orderloc,h)=datastr

    s h=0
    s audituser=""
    f  s audituser=$o(^TMP("dhcpha","web.DHCSTPHAUDITLOC","QueryAuditedDetail",pid,audituser)) q:audituser=""  d
    .s orderloc=""
    .f  s orderloc=$o(^TMP("dhcpha","web.DHCSTPHAUDITLOC","QueryAuditedDetail",pid,audituser,orderloc)) q:orderloc=""  d
    ..s num=""
    ..s auditqty=0
    ..f  s num=$o(^TMP("dhcpha","web.DHCSTPHAUDITLOC","QueryAuditedDetail",pid,audituser,orderloc,num)) q:num=""  d
    ...s data=^TMP("dhcpha","web.DHCSTPHAUDITLOC","QueryAuditedDetail",pid,audituser,orderloc,num)
    ...s date=$p(data,"^",1)
    ...s date=$zd(date,3)
    ...s auditusername=$p(data,"^",2)
    ...s ordlocdesc=$p(data,"^",3)
    ...s phalocdesc=$p(data,"^",4)
    ...s auditqty=auditqty+1
    ..s h=h+1
    ..s datastr=date_"^"_auditusername_"^"_ordlocdesc_"^"_phalocdesc_"^"_auditqty
    ..s ^TMP("dhcpha","web.DHCSTPHAUDITLOC","QueryAuditedDetailByQty",pid,h)=datastr

    k ^TMP("dhcpha","web.DHCSTPHAUDITLOC","QueryAuditedDetail",pid)
    
	q:h=0 ##class(web.DHCSTEXTCOMMON).GetNoJson()
	s count=0
    s maxrow=h
    s num=""
    s auditqty=0
    f  s num=$o(^TMP("dhcpha","web.DHCSTPHAUDITLOC","QueryAuditedDetailByQty",pid,num)) q:num=""  d
    .s data=^TMP("dhcpha","web.DHCSTPHAUDITLOC","QueryAuditedDetailByQty",pid,num)
    .s date=$p(data,"^",1)
    .s audituser=$p(data,"^",2)
    .s ordlocdesc=$p(data,"^",3)
    .s phalocdesc=$p(data,"^",4)
    .s auditqty=$p(data,"^",5)
    .
    .s date=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("date",date)
    .s audituser=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("audituser",audituser)
	.s ordlocdesc=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("ordlocdesc",ordlocdesc)
	.s phalocdesc=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("phalocdesc",phalocdesc)
	.s auditqty=##class(web.DHCSTEXTCOMMON).GetJsonLastCell("auditqty",auditqty)
	.
	.s tmpstr=date_phalocdesc_audituser_ordlocdesc_auditqty
    .s startString=##class(web.DHCSTEXTCOMMON).GetJsonStartString(maxrow)
    .s firstrow=##class(web.DHCSTEXTCOMMON).GetJsonFirstRow(tmpstr)
    .s lastrow=##class(web.DHCSTEXTCOMMON).GetJsonLastRow(tmpstr)
    .
	.s count=count+1
	.i count=1 w startString
    .i count<maxrow w firstrow
    .i count=maxrow w lastrow
	.
	k ^TMP("dhcpha","web.DHCSTPHAUDITLOC","QueryAuditedDetailByQty",pid)
	q ""
}

}
