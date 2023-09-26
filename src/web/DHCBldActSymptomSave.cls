/// 保存输血不良反应记录单信息
Class web.DHCBldActSymptomSave Extends web.IActionHandler
{

ClassMethod DoAction(ByRef request As %CSP.Request, ByRef response As %CSP.Response, ByRef session As %CSP.Session) As %Boolean [ Final ]
{
	S userCode=$g(request.Data("userCode",1))
	S opType=$g(request.Data("opType",1))
	
	S $ZT="ERR"
	S fieldsData=##Class(web.DHCBldSymptomLayout).GetFormFieldData(request)
	S retValStr=##class(web.DHCBldSymptom).Save(opType,fieldsData,userCode)
	S retVal=$P(retValStr,"^",1)
	S recordID=$P(retValStr,"^",2)
	S status=$P(retValStr,"^",3)
	S success="false"
	S:retVal=0 success="true"
	S info=""
	I retVal'=0 D
	.S info="操作失败:"_recordID
	
	S ret="{'success':"_success_",'info':'"_info_"','recordID':'"_recordID_"','status':'"_status_"'}"
	w ret
	Q ret
ERR
   S ^DEBUG($zn)=$ZE
   Q ""
}

Parameter ActionID = "BLD.REACTION.SAVE";

Parameter Version = "1.0.0.1";

}
