Import SQLUser

Class web.DHCWMRAdmitVisitCtl Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 59;

ClassMethod GetChinese(Ind)
{
	s ret=""
	s:Ind="DHC.WMR.AdmitVisit" ret="请认真选择就诊记录重新接诊!^请输入医护人员签名!"
	s:Ind="DHC.WMR.AdmitVisit.Qry" ret="入院日期^出院日期"
	q ret
}

}
