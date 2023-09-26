Class DHCCL.Mobile.Web.RunMethod Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

ClassMethod RunMethod(ActionCode As %String = "", Param As %String = "") As %String
{
	// w ##class(DHCCL.Mobile.Web.WebService).RunMethod(ActionCode,Param)
	Set $ZTrap = "MessageCatch"
	//s Param=$P($P(Param,"<Request>",2),"</Request>",1)
	s ^tmpmobiledebug("RunMethod")=ActionCode_"^"_Param_"  "_$h
	s ResultCode=0
	s ResultDesc="成功"
	s RetStr=""
	s Action=""
	i ActionCode="" d
	.s ReurnCode=100
	.s ReurnDesc="业务代码为空!"
	e  d
	.s ID=$O(^User.ServiceActionI("ActionCode",ActionCode,""))
	.i ID'="" d
	..s ActionObj=##class(User.ServiceAction).%OpenId(ID)
	..s ClassName=ActionObj.ClassName
	..s MethodName=ActionObj.MethodName
	..i (MethodName="")||(ClassName="") d
	...s ReurnCode=101
	...s ReurnDesc="'"_ActionCode_"'未定义!"
	..e  d
	...s Action="##Class("_ClassName_")."_MethodName
	.e  d
	..//s Action=ActionCode
	i Action="" d
	.s ResultCode=101
	.s ResultDesc="'"_ActionCode_"'未定义!"
	e  d
	.s CommandStr="RetStr="_Action_"("""_Param_""")"
	.s ^WKZTemp(1)=CommandStr
	.s @CommandStr
	.b ///////////////////////////////////////
	/*
	*Action 在执行之后,如果失败返回 错误代码^错误描述，错误代码 > 200
	*                  如果成功返回为空、字符串、或者XML串
	*/

	//s HMCIndex=$I(^DHCMHCTest(+$H,ActionCode,"HMCIndex"))
	//s ^DHCMHCTest(+$H,ActionCode,HMCIndex,"Requst")=CommandStr
	//s ^DHCMHCTest(+$H,ActionCode,HMCIndex,"Response")=$G(RetStr)
	b // start
	s sPos=$F(RetStr,"<total>")
	i (sPos-7)=1  d
	.s ePos=$F(RetStr,"</total>")
	.s total=+$E(RetStr,sPos,ePos-8)
	.s RetStr=$E(RetStr,ePos,$L(RetStr))
	.
	;b ;end
	i (RetStr'="")&&($P(RetStr,"<",2)="") s ResultDesc=RetStr
	i $P(RetStr,"^",2)'="" s ResultDesc=$P(RetStr,"^",2)
	i (+RetStr)'=0 d 
	.s ResultCode=+RetStr
	.s ResultDesc=$P(RetStr,"^",2)
	.
	//XECUTE CommandStr
	//s RetXML="<Response><ResultCode>"_ResultCode_"</ResultCode><ResultDesc>"_ResultDesc_"</ResultDesc><ResultList>"_RetStr_"</ResultList></Response>"	
	s RetXML="<Response><ResultCode>"_ResultCode_"</ResultCode><ResultDesc>"_ResultDesc_"</ResultDesc><TotalCount>"_$g(total)_"</TotalCount><ResultList>"_RetStr_"</ResultList></Response>"	
	q RetXML
MessageCatch
	s ResultCode=-200
	s ResultDesc=$ZError //$$$ERROR($$$GeneralError,"Error in OnProcessInput():  "_$ZError)
	s HMCIndex=$I(^DHCMHCExc(+$H,ActionCode,"HMCIndex"))
	s ^DHCMHCExc(+$H,ActionCode,HMCIndex,"Param")=Param
	s ^DHCMHCExc(+$H,ActionCode,HMCIndex,"Result")=ResultDesc
	s ResultDesc=$TR(ResultDesc,"<"," ")
	s ResultDesc=$TR(ResultDesc,">"," ")
	s RetXML="<Response><ResultCode>"_ResultCode_"</ResultCode><ResultDesc>"_ResultDesc_"</ResultDesc></Response>"
  	Quit RetXML
}

}
