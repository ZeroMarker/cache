Import sqluser

/// 维护点评管制分类
Class web.DHCSTCNTSADDCTRL Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// 获取点评管制分类集
ClassMethod GetPHCNTSPoison() As %String
{
	s pid=##class(web.DHCSTCNTSCOMMON).GetPHCNTSPID()
	s h=0
	s pccr=""
	f  s pccr=$o(^DHCPCCON(pccr)) q:pccr=""  d
	.s poisondr=$p(^DHCPCCON(pccr),"^",1)
	.q:'$d(^PHCPO(poisondr))
	.s ctrldesc=$p(^PHCPO(poisondr),"^",2)
	.i $f(ctrldesc,$c(13)) s ctrldesc=$p(ctrldesc,$c(13)) 
	.s h=h+1
    .s data=ctrldesc_"^"_pccr
    .s ^TMP("dhcpha","DHCSTCNTSADDCTRL","GetPHCNTSPoison",pid,h)=data
    q:h=0 ##class(web.DHCSTEXTCOMMON).GetNoJson()
    s maxrow=h
    
    s count=0
    s h=""
    f  s h=$o(^TMP("dhcpha","DHCSTCNTSADDCTRL","GetPHCNTSPoison",pid,h)) q:h=""  d
    .s data=^TMP("dhcpha","DHCSTCNTSADDCTRL","GetPHCNTSPoison",pid,h)
    .s ctrldesc=$p(data,"^",1)
    .s ctrlrowid=$p(data,"^",2)
    .
    .s ctrldesc=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("ctrldesc",ctrldesc)
	.s ctrlrowid=##class(web.DHCSTEXTCOMMON).GetJsonLastCell("ctrlrowid",ctrlrowid)
	.
	.s tmpstr=ctrldesc_ctrlrowid
    .s startString=##class(web.DHCSTEXTCOMMON).GetJsonStartString(maxrow)
    .s firstrow=##class(web.DHCSTEXTCOMMON).GetJsonFirstRow(tmpstr)
    .s lastrow=##class(web.DHCSTEXTCOMMON).GetJsonLastRow(tmpstr)
	.s count=count+1
	.i count=1 w startString
    .i count<maxrow w firstrow
    .i count=maxrow w lastrow
	.
	k ^TMP("dhcpha","DHCSTCNTSADDCTRL","GetPHCNTSPoison",pid)
	q ""
}

/// 获取药学管制分类集
ClassMethod GetPHPoison() As %String
{
	s pid=##class(web.DHCSTCNTSCOMMON).GetPHCNTSPID()
	s h=0
	s phcp=0
	f  s phcp=$o(^PHCPO(phcp)) q:(phcp="")||(phcp=0)  d
	.s phcpdesc=$p(^PHCPO(phcp),"^",2)
	.i $f(phcpdesc,$c(13))  s phcpdesc=$p(phcpdesc,$c(13))
	.s h=h+1
    .s data=phcpdesc_"^"_phcp
    .s ^TMP("dhcpha","DHCSTCNTSADDCTRL","GetPHPoison",pid,h)=data
    q:h=0 ##class(web.DHCSTEXTCOMMON).GetNoJson()
    s maxrow=h
    
    s count=0
    s h=""
    f  s h=$o(^TMP("dhcpha","DHCSTCNTSADDCTRL","GetPHPoison",pid,h)) q:h=""  d
    .s data=^TMP("dhcpha","DHCSTCNTSADDCTRL","GetPHPoison",pid,h)
    .s phcpdesc=$p(data,"^",1)
    .s phcp=$p(data,"^",2)
    .
    .s phcpdesc=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("poisondesc",phcpdesc)
	.s phcprowid=##class(web.DHCSTEXTCOMMON).GetJsonLastCell("poisonrowid",phcp)
	.
	.s tmpstr=phcpdesc_phcprowid
    .s startString=##class(web.DHCSTEXTCOMMON).GetJsonStartString(maxrow)
    .s firstrow=##class(web.DHCSTEXTCOMMON).GetJsonFirstRow(tmpstr)
    .s lastrow=##class(web.DHCSTEXTCOMMON).GetJsonLastRow(tmpstr)
	.s count=count+1
	.i count=1 w startString
    .i count<maxrow w firstrow
    .i count=maxrow w lastrow
	.
	k ^TMP("dhcpha","DHCSTCNTSADDCTRL","GetPHPoison",pid)
	q ""
}

/// 增加管制分类
/// w ##class(web.DHCSTCNTSADDCTRL).AddCommontCtrl(11)
ClassMethod AddCommontCtrl(poisondr) As %String
{
	q:poisondr="" -3
	q:'$d(^PHCPO(poisondr)) -4
	&sql(SELECT * FROM DHC_PHCNTSCONTROL WHERE PCC_Poison_Dr=:poisondr)
	q:SQLCODE=0 -2
	&sql(INSERT INTO DHC_PHCNTSCONTROL (PCC_Poison_Dr) VALUES (:poisondr))
 	i SQLCODE'=0 q -1
 	q 0
}

/// 删除管制分类
ClassMethod DelCommontReason(CtrlID) As %String
{
	
	&sql(delete from DHC_PHCNTSCONTROL where  PCC_RowID=:CtrlID )
 	i SQLCODE'=0 q -1
 	q 0
}

}
