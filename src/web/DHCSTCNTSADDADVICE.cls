Import sqluser

/// 维护点评药师建议
Class web.DHCSTCNTSADDADVICE Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// 获取药师建议集
ClassMethod GetPHAdvice() As %String
{
	s pid=##class(web.DHCSTCNTSCOMMON).GetPHCNTSPID()
	s h=0
	s pcar=""
	f  s pcar=$o(^DHCPCADVICE(pcar)) q:pcar=""  d
	.s advdesc=$p(^DHCPCADVICE(pcar),"^",2)
	.i $f(advdesc,$c(13))  s advdesc=$p(advdesc,$c(13))
	.s h=h+1
    .s data=advdesc_"^"_pcar
    .s ^TMP("dhcpha","DHCSTCNTSADDADVICE","GetPHAdvice",pid,h)=data
    q:h=0 ##class(web.DHCSTEXTCOMMON).GetNoJson()
    s maxrow=h
    
    s count=0
    s h=""
    f  s h=$o(^TMP("dhcpha","DHCSTCNTSADDADVICE","GetPHAdvice",pid,h)) q:h=""  d
    .s data=^TMP("dhcpha","DHCSTCNTSADDADVICE","GetPHAdvice",pid,h)
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
	k ^TMP("dhcpha","DHCSTCNTSADDADVICE","GetPHAdvice",pid)
	q ""
}

/// 增加药师建议集
ClassMethod AddCommontAdvice(advdesc) As %String
{
	s existflag=0
	s pcar=""
	f  s pcar=$o(^DHCPCADVICE(pcar)) q:pcar=""  d
	.s code=$p(^DHCPCADVICE(pcar),"^",1)
	.i code=advdesc d
	..s existflag=1
	q:existflag=1 -99
		
	k PLIST
	s PLIST(2)=advdesc
	s PLIST(3)=advdesc
	
	&sql(INSERT INTO DHC_PHCNTSADVICE VALUES :PLIST())
 	i SQLCODE'=0 q -1
 	q 0
}

/// 修改药师建议集
ClassMethod UpdCommontAdvice(newadv, advrowid) As %String
{
	s existflag=0
	s pcar=""
	f  s pcar=$o(^DHCPCADVICE(pcar)) q:pcar=""  d
	.s code=$p(^DHCPCADVICE(pcar),"^",1)
	.q:advrowid=pcar
	.i code=newadv d
	..s existflag=1
	q:existflag=1 -99	
	&sql(update  DHC_PHCNTSADVICE set PCA_Code=:newadv,PCA_Desc=:newadv where  PCA_RowID=:advrowid )
 	i SQLCODE'=0 q -1
 	q 0
}

/// 删除药师建议集
ClassMethod DelCommontAdvice(advrowid) As %String
{
	
	&sql(delete from DHC_PHCNTSADVICE where PCA_RowID=:advrowid )
 	i SQLCODE'=0 q -1
 	q 0
}

}
