Import SQLUser

/// 医保门诊结算审核
Class web.DHCINSUDivideAuditCtl Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 133;

/// 保存
/// w ##Class(web.DHCINSUDivideAuditCtl).Save("232018^232019",6)
ClassMethod Save(InvStr As %String, DivID As %String) As %String
{
	s InvStr=$tr(InvStr,$c(0),"")
	q:(InvStr="")||(DivID="") -100
	s rtn="-1"
	
	f i=1:1:$l(InvStr,"^") d
	.s InvDr=$p(InvStr,"^",i)
    .s PLIST(1)=""
	.s PLIST(2)=DivID                        
	.s PLIST(3)=InvDr                            
	.s PLIST(4)="Y"        
    .&sql(insert into INSU_DivideAudit values PLIST())
    .s:SQLCODE=0 rtn="0"
    
    q rtn
}

/// w ##Class(web.DHCINSUDivideAuditCtl).Delete(7)
ClassMethod Delete(DivID As %String) As %String
{
	;s rtn="0"
	&sql(Delete INSU_DivideAudit where INSUDIVAUD_DIVDR=:DivID)
	;s:SQLCODE<0 rtn="-1"
	q SQLCODE
}

}
