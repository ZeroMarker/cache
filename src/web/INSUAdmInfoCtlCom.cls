Import SQLUser

/// 医保入院登记
Class web.INSUAdmInfoCtlCom Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 41;

ClassMethod QueryElseCom(itmjs As %Library.String = "", itmjsex As %Library.String = "")
{
	
	s ret=##class(web.INSUParaCtl).QueryElse()
	q ret
}

ClassMethod GetPaAdmNOCom(itmjs As %Library.String = "", itmjsex As %Library.String = "", InString As %Library.String = "")
{
	q:InString=""
	s ret=##class(web.INSUBase).GetPaAdmNO(InString)
	q ret
}

ClassMethod GetPaPamasInfoCom(itmjs As %Library.String = "", itmjsex As %Library.String = "", InString As %Library.String = "")
{
	q:InString=""	
	s ret=##class(web.INSUBase).GetPaPamasInfo(InString)
	q ret
}

ClassMethod QueryAdmInfoCom(itmjs As %Library.String = "", itmjsex As %Library.String = "", InString As %Library.String = "")
{
	q:InString=""	
	s ret=##class(web.INSUAdmInfoCtl).QueryAdmInfo(InString)
	q ret
}

ClassMethod GetPaAdmInfoCom(itmjs As %Library.String = "", itmjsex As %Library.String = "", InString As %Library.String = "")
{
	q:InString=""	
	s ret=##class(web.INSUBase).GetPaAdmInfo(InString)
	q ret
}

ClassMethod SaveCom(itmjs As %Library.String = "", itmjsex As %Library.String = "", InString As %Library.String = "")
{
	q:InString=""	
	s ret=##class(web.INSUAdmInfoCtl).Save(InString)
	q ret
}

ClassMethod CheckBillCom(itmjs As %Library.String = "", itmjsex As %Library.String = "", InString As %Library.String = "", User As %Library.String = "")
{
	q:InString=""	
	s ret=##class(web.INSUBase).CheckBill(InString,User)
	q ret
}

ClassMethod UpdateAdmInfozCom(itmjs As %Library.String = "", itmjsex As %Library.String = "", AdmInfoRowid As %Library.String = "", ActiveFlag As %Library.String = "", UpDateUser As %Library.String = "", UpInsuUser As %Library.String = "")
{
	
	s ret=##class(web.INSUAdmInfoCtl).UpdateAdmInfoz(AdmInfoRowid,ActiveFlag,UpDateUser,UpInsuUser)
	q ret
}

ClassMethod CheckStatus(itmjs As %Library.String = "", itmjsex As %Library.String = "", AdmRowid As %String, BillNo As %String)
{
	
	s ret=##class(web.INSUDivideSvr).CheckStatus(AdmRowid , BillNo)
	q ret
}

ClassMethod Query(itmjs As %Library.String = "", itmjsex As %Library.String = "", InfoId As %String)
{
	
	s ret=##class(web.INSUAdmInfoCtl).Query(InfoId)
	q ret
}

/// 描述：修改在院患者医保卡卡号
/// 入参：Paadm->Rowid ,UpdStr:旧医保卡号^新医保卡号
/// 出参：等于 0:成功  负值：失败
/// 操作表:INSU_AdmInfo
/// 其他说明：更新患者必须是医保在院状态(INADM_ActiveFlag=A)
/// 其他说明: XString10 用于存更新之前医保卡号  
/// Creator DingSH 20140917
/// w ##class(web.INSUAdmInfoCtlCom).UpdateINSUCardNo("230","F25453101_FLQQCS001")
ClassMethod UpdateINSUCardNo(PAADM As %Library.String = "", UpdStr As %Library.String = "") As %Library.String
{
	q:(UpdStr="")||(PAADM="") "-1"
	q:$l(UpdStr,"_")<2 "-1"
	s OldCardNo=$tr($p(UpdStr,"_","1"),"^","")
	s NewCardNo=$tr($p(UpdStr,"_","2"),"^","")
	
	&SQL(UPDATE INSU_ADMINFO SET INADM_CARDNO=:NewCardNo,INADM_XSTRING10=:OldCardNo WHERE INADM_ADMDR=:PAADM AND INADM_CARDNO=:OldCardNo AND INADM_ActiveFlag="A")
	Q SQLCODE
}

Storage Default
{
<Data name="INSUAdmInfoCtlComDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.INSUAdmInfoCtlComD</DataLocation>
<DefaultData>INSUAdmInfoCtlComDefaultData</DefaultData>
<IdLocation>^web.INSUAdmInfoCtlComD</IdLocation>
<IndexLocation>^web.INSUAdmInfoCtlComI</IndexLocation>
<StreamLocation>^web.INSUAdmInfoCtlComS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
