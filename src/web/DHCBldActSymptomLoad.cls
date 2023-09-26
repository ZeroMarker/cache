Class web.DHCBldActSymptomLoad Extends web.IActionHandler
{

ClassMethod DoAction(ByRef request As %CSP.Request, ByRef response As %CSP.Response, ByRef session As %CSP.Session) As %Boolean [ Final ]
{
	S ret="{'success':"_"true"_",'info':'保存成功'}"
	
	S $ZT="ERR"
	S recordID=$g(request.Data("recordID",1))
	S userCode=$g(request.Data("userCode",1))
	S patAdmID=$g(request.Data("patAdmID",1))
	s ^TMPACTION("web.DHCBldActSymptomLoad","para")=recordID_","_userCode_","_patAdmID
	S ret=##Class(web.DHCBldSymptomLayout).GetLayoutDataByRecordID(recordID,patAdmID,userCode)
	W ret
	Q ret
ERR
  S ^DEBUG($zn)=$ECODE
  Q
}

Parameter ActionID = "BLD.REACTION.LOAD";

Parameter Version = "1.0.0.1";

Storage Default
{
<Data name="DHCBldActSymptomLoadDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCBldActSymptomLoadD</DataLocation>
<DefaultData>DHCBldActSymptomLoadDefaultData</DefaultData>
<IdLocation>^web.DHCBldActSymptomLoadD</IdLocation>
<IndexLocation>^web.DHCBldActSymptomLoadI</IndexLocation>
<StreamLocation>^web.DHCBldActSymptomLoadS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
