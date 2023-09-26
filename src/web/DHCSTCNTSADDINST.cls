Import sqluser

/// 维护用法
Class web.DHCSTCNTSADDINST Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// 获取药品用法集合
ClassMethod QueryPhcInstDs() As %String
{
	s pid=##class(web.DHCSTCNTSCOMMON).GetPHCNTSPID()
	s h=0
	s phcin=0
	f  s phcin=$o(^PHCIN(phcin)) q:(phcin="")||(phcin=0)   d ;之前只有一个空，这样会多出一条rid=0的垃圾数据
	.s instdesc=$p(^PHCIN(phcin),"^",1)
	.i $f(instdesc,$c(13))  s instdesc=$p(instdesc,$c(13))
	.s instrowid=phcin
	.s h=h+1
    .s data=instdesc_"^"_instrowid
    .s ^TMP("dhcpha","DHCSTCNTSADDINST","QueryPhcInstDs",pid,h)=data
    q:h=0 ##class(web.DHCSTEXTCOMMON).GetNoJson()
    s maxrow=h
    
    s count=0
    s h=""
    f  s h=$o(^TMP("dhcpha","DHCSTCNTSADDINST","QueryPhcInstDs",pid,h)) q:h=""  d
    .s data=^TMP("dhcpha","DHCSTCNTSADDINST","QueryPhcInstDs",pid,h)
    .s instdesc=$p(data,"^",1)
    .s instrowid=$p(data,"^",2)
    .
    .s instdesc=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("instdesc",instdesc)
	.s instrowid=##class(web.DHCSTEXTCOMMON).GetJsonLastCell("instrowid",instrowid)
	.
	.s tmpstr=instdesc_instrowid
    .s startString=##class(web.DHCSTEXTCOMMON).GetJsonStartString(maxrow)
    .s firstrow=##class(web.DHCSTEXTCOMMON).GetJsonFirstRow(tmpstr)
    .s lastrow=##class(web.DHCSTEXTCOMMON).GetJsonLastRow(tmpstr)
	.s count=count+1
	.i count=1 w startString
    .i count<maxrow w firstrow
    .i count=maxrow w lastrow
	.
	k ^TMP("dhcpha","DHCSTCNTSADDINST","QueryPhcInstDs",pid)
	q ""
}

/// 获取注射剂集合
ClassMethod QueryInstDs() As %String
{
	s pid=##class(web.DHCSTCNTSCOMMON).GetPHCNTSPID()
	s h=0
	s inst=""
	f  s inst=$o(^DHCPCINST(inst)) q:inst=""  d
	.s instdr=$p(^DHCPCINST(inst),"^",1)
	.s formdr=$p(^DHCPCINST(inst),"^",2)
	.;q:formdr=""
	.;q:instdr=""
	.s instdesc=""
	.i instdr'=""  d
	..s:$d(^PHCIN(instdr)) instdesc=$p(^PHCIN(instdr),"^",1) 
	..i $f(instdesc,$c(13))  s instdesc=$p(instdesc,$c(13))
	.e  d
	..s instdesc=""
	.
	.s formdesc=""
	.i formdr'=""  d
	..s:$d(^PHCF(formdr)) formdesc=$p(^PHCF(formdr),"^",1) 
	..i $f(formdesc,$c(13))  s formdesc=$p(formdesc,$c(13))
	.e  d
	..s formdesc=""
	.s h=h+1
    .s data=instdesc_"^"_inst_"^"_formdesc
    .s ^TMP("dhcpha","DHCSTCNTSADDINST","QueryInstDs",pid,h)=data
    q:h=0 ##class(web.DHCSTEXTCOMMON).GetNoJson()
    s maxrow=h
    
    s count=0
    s h=""
    f  s h=$o(^TMP("dhcpha","DHCSTCNTSADDINST","QueryInstDs",pid,h)) q:h=""  d
    .s data=^TMP("dhcpha","DHCSTCNTSADDINST","QueryInstDs",pid,h)
    .s instdesc=$p(data,"^",1)
    .s instrowid=$p(data,"^",2)
    .s formdesc=$p(data,"^",3)
    .
    .s instdesc=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("instdesc",instdesc)
	.s formdesc=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("formdesc",formdesc)
	.s instrowid=##class(web.DHCSTEXTCOMMON).GetJsonLastCell("instrowid",instrowid)
	.
	.s tmpstr=instdesc_formdesc_instrowid
    .s startString=##class(web.DHCSTEXTCOMMON).GetJsonStartString(maxrow)
    .s firstrow=##class(web.DHCSTEXTCOMMON).GetJsonFirstRow(tmpstr)
    .s lastrow=##class(web.DHCSTEXTCOMMON).GetJsonLastRow(tmpstr)
	.s count=count+1
	.i count=1 w startString
    .i count<maxrow w firstrow
    .i count=maxrow w lastrow
	.
	k ^TMP("dhcpha","DHCSTCNTSADDINST","QueryInstDs",pid)
	q ""
}

/// 增加注射剂集合
ClassMethod AddInst(instrowid) As %String
{
	s formdr=""	
	k PLIST
	s PLIST(2)=instrowid
	s inst=""
	f  s inst=$o(^DHCPCINST(inst)) q:inst=""  d
	.s formdr=$p(^DHCPCINST(inst),"^",2)
	s exist=0
	i formdr'=""  d     ;如果之前按剂型维护的，就按剂型维护
	.s SQLCODE=9999
	e  d
	.s instcnt=0
	.&SQL(SELECT count(*) into :instcnt FROM DHC_PHCNTSINSTRUC WHERE PINST_Inst_Dr=:instrowid)
	.i instcnt>0 s exist=1
	.e  &sql(INSERT INTO DHC_PHCNTSINSTRUC VALUES :PLIST())
	q:exist=1 -3
	i SQLCODE=9999 q -2
	i SQLCODE=0 q 0
 	i (SQLCODE'=0)&(SQLCODE=9999) q -1
}

/// 删除注射剂集合
ClassMethod DelInst(pinstrowid) As %String
{
	
	&sql(delete from DHC_PHCNTSINSTRUC where PINST_RowID=:pinstrowid )
 	i SQLCODE'=0 q -1
 	q 0
}

/// pengzhikun
/// 获取剂型集合
ClassMethod QueryPhcform() As %String
{
	s pid=##class(web.DHCSTCNTSCOMMON).GetPHCNTSPID()
	s h=0
	s phcformRid=0
	f  s phcformRid=$o(^PHCF(phcformRid)) q:(phcformRid="")||(phcformRid=0)  d
	.s phcformdesc=$p(^PHCF(phcformRid),"^",1)
	.i $f(phcformdesc,$c(13))  s phcformdesc=$p(phcformdesc,$c(13))
	.s h=h+1
    .s data=phcformdesc_"^"_phcformRid
    .s ^TMP("dhcpha","DHCSTCNTSADDINST","QueryPhcform",pid,h)=data
    q:h=0 ##class(web.DHCSTEXTCOMMON).GetNoJson()
    s maxrow=h
    
    s count=0
    s h=""
    f  s h=$o(^TMP("dhcpha","DHCSTCNTSADDINST","QueryPhcform",pid,h)) q:h=""  d
    .s data=^TMP("dhcpha","DHCSTCNTSADDINST","QueryPhcform",pid,h)
    .s phcformdesc=$p(data,"^",1)
    .s phcformRid=$p(data,"^",2)
    .
    .s phcformdesc=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("phcformdesc",phcformdesc)
	.s phcformRid=##class(web.DHCSTEXTCOMMON).GetJsonLastCell("phcformRid",phcformRid)
	.
	.s tmpstr=phcformdesc_phcformRid
    .s startString=##class(web.DHCSTEXTCOMMON).GetJsonStartString(maxrow)
    .s firstrow=##class(web.DHCSTEXTCOMMON).GetJsonFirstRow(tmpstr)
    .s lastrow=##class(web.DHCSTEXTCOMMON).GetJsonLastRow(tmpstr)
	.s count=count+1
	.i count=1 w startString
    .i count<maxrow w firstrow
    .i count=maxrow w lastrow
	.
	k ^TMP("dhcpha","DHCSTCNTSADDINST","QueryPhcform",pid)
	q ""
}

/// pengzhikun
/// 增加剂型集合
ClassMethod AddForm(phcformRid) As %String
{
	s instdr=""	
	k PLIST
	s PLIST(3)=phcformRid
	s inst=""
	f  s inst=$o(^DHCPCINST(inst)) q:inst=""  d
	.s instdr=$p(^DHCPCINST(inst),"^",1)
	s exist=0
	i instdr'=""  d    ;如果之前有按用法维护的，就按用法维护
	.s SQLCODE=9999
	e  d
	.s formcnt=0
	.&SQL(SELECT count(*) into :formcnt FROM DHC_PHCNTSINSTRUC WHERE PINST_Form_Dr=:phcformRid)
	.i formcnt>0 s exist=1
	.q:exist'=0
	.&sql(INSERT INTO DHC_PHCNTSINSTRUC VALUES :PLIST())
	q:exist=1 -3
	i SQLCODE=9999 q -2
	i SQLCODE=0 q 0
 	i (SQLCODE'=0)&(SQLCODE=9999) q -1
 	;q 0
}

}
