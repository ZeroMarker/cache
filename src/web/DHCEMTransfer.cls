Class web.DHCEMTransfer Extends (%RegisteredObject, %XML.Adaptor) [ Not ProcedureBlock ]
{

/// w ##class(web.DHCEMTransfer).WardUpdateTransfer(1891061,160)
ClassMethod WardUpdateTransfer(AdmIdStr As %String, PAAdmWard As %String) As %String
{
	n (AdmIdStr,PAAdmWard,%session)
	s ret=0	
	i AdmIdStr="" w "入参为空"
	q:AdmIdStr="" ret

	s UserID=%session.Get("LOGON.USERID")
	
	s CareId=$P($G(^SSU("SSUSR",UserID)),"^",14)
	i CareId="" w "登录用户不是医护人员"
	q:CareId="" ret
	s count=1	
	s AdmId=""           
	s len=$l(AdmIdStr,"^")
	f i=1:1:len d
	.s AdmId=$P($G(AdmIdStr),"^",i)
	.q:AdmId=""
	.q:ret'=0	
	.//调用接口 pjf 2015-03-19
	.TStart
	.s ret=##class(web.DHCADTTransaction).MoveAdm(AdmId,UserID, PAAdmWard)
	.i ret=0 TCommit
	.e  TROLLBACK
	w ret
	q ""
}

ClassMethod CheckBeforeTransfer(AdmId As %String, PAAdmWard As %String) As %String
{
	n (AdmId,PAAdmWard,%session)
	i AdmId="" w "请选择病人"
	q:AdmId="" ""
	Set curAdm=$P(^PAADM(AdmId),"^",70)
	q:curAdm="" "非留观/抢救不能直接转诊;" //hxy 2018-09-29 st
	S Type=##class(web.DHCEMPatChange).GetAdmType(AdmId)
	q:Type'="E" "非急诊病人,不予受理;" //ed
	i curAdm=PAAdmWard w "病人当前就在该病区"
	q:curAdm=PAAdmWard ""
	w 1
	q ""
}

}
