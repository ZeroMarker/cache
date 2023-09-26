Import sqluser

/// 维护点评不合格警示值
Class web.DHCSTCNTSADDFACTOR Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// 不合格警示值集
ClassMethod GetCNTSFACTOR() As %String
{
	s pid=##class(web.DHCSTCNTSCOMMON).GetPHCNTSPID()
	s h=0
	s pcfr=""
	f  s pcfr=$o(^DHCPCFACTOR(pcfr)) q:pcfr=""  d
	.s facdesc=$p(^DHCPCFACTOR(pcfr),"^",2)
	.i $f(facdesc,$c(13))  s facdesc=$p(facdesc,$c(13))
	.s h=h+1
    .s data=facdesc_"^"_pcfr
    .s ^TMP("dhcpha","DHCSTCNTSADDFACTOR","GetCNTSFACTOR",pid,h)=data
    q:h=0 ##class(web.DHCSTEXTCOMMON).GetNoJson()
    s maxrow=h
    
    s count=0
    s h=""
    f  s h=$o(^TMP("dhcpha","DHCSTCNTSADDFACTOR","GetCNTSFACTOR",pid,h)) q:h=""  d
    .s data=^TMP("dhcpha","DHCSTCNTSADDFACTOR","GetCNTSFACTOR",pid,h)
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
	k ^TMP("dhcpha","DHCSTCNTSADDFACTOR","GetCNTSFACTOR",pid)
	q ""
}

/// 增加不合格警示值
ClassMethod AddCommontFactor(facdesc) As %String
{
		
	k PLIST
	s PLIST(2)=facdesc
	s PLIST(3)=facdesc
	
	&sql(INSERT INTO DHC_PHCNTSFACTOR VALUES :PLIST())
 	i SQLCODE'=0 q -1
 	q 0
}

/// 修改不合格警示值
ClassMethod UpdCommontAdvice(newfac, facrowid) As %String
{
	
	&sql(update  DHC_PHCNTSFACTOR set PCF_Code=:newfac,PCF_Desc=:newfac where  PCF_RowID=:facrowid)
 	i SQLCODE'=0 q -1
 	q 0
}

/// 删除不合格警示值
ClassMethod DelCommontAdvice(facrowid) As %String
{
	
	&sql(delete from DHC_PHCNTSFACTOR where PCF_RowID=:facrowid )
 	i SQLCODE'=0 q -1
 	q 0
}

}
