/// 加载历史输血记录单
Class web.DHCBldActSymptomHistory Extends web.IActionHandler
{

ClassMethod DoAction(ByRef request As %CSP.Request, ByRef response As %CSP.Response, ByRef session As %CSP.Session) As %Boolean [ Final ]
{
	S userCode=$g(request.Data("userCode",1))
	S patAdmID=$g(request.Data("patAdmID",1))
	s ^TMPACTION=userCode_","_patAdmID
	S retValStr=##class(web.DHCBldSymptom).BuildAllHistoryForms(patAdmID,userCode)
	S ret=##class(web.DHCBldSymptomLayout).BuildStoreData("HISTORY",retValStr)					
	w ret
	Q ret
}

Parameter ActionID = "BLD.REACTION.HISTORY";

Parameter Version = "1.0.0.1";

}
