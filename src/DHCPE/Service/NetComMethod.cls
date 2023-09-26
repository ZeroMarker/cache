Class DHCPE.Service.NetComMethod Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// w ##Class(DHCPE.Service.NetComMethod).RunRequestMethod("HS10222","<Request></Request>")
ClassMethod RunRequestMethod(ActionCode As %String = "", Param As %String = "") As %String
{
	Set $ZTRAP = "MessageCatch"
	Set ResultCode=0
	Set ResultDesc="成功"
	Set RetStr=""
	Set Action=""
	If ActionCode="" Do
	.Set ResultCode=100
	.Set ResultDesc="业务代码为空!"
	e  Do
	.Set ID=$ORDER(^User.DHCPEServiceActionI("ActionCode",ActionCode,""))
	.If ID'="" Do
	..Set ActionObj=##class(User.DHCPEServiceAction).%OpenId(ID)
	..Set ClassName=ActionObj.ClassName
	..Set MethodName=ActionObj.MethodName
	..If (MethodName="")||(ClassName="") Do
	...Set ResultCode=101
	...Set ResultDesc="业务代码未定义!"
	..e  Do
	...Set Action="##Class("_ClassName_")."_MethodName
	If Action="" Do
	.Set ResultCode=101
	.Set ResultDesc="业务代码未定义!"
	e  Do
	.Set CommandStr="RetStr="_Action_"("""_Param_""")"
	.Break ;begin
	.Set @CommandStr
	.Break ;end
	Break ;RetStr
	If (RetStr'="")&&($PIECE(RetStr,"<",2)="") Set ResultDesc=RetStr
	If $PIECE(RetStr,"^",2)'="" Set ResultDesc=$PIECE(RetStr,"^",2)
	If (+RetStr)'=0 Do 
	.Set ResultCode=+RetStr
	.Set ResultDesc=$PIECE(RetStr,"^",2)
	.Set RetStr=""
	e  Set ResultDesc="成功"
	Set RetXML="<Response><ResultCode>"_ResultCode_"</ResultCode><ResultDesc>"_ResultDesc_"</ResultDesc><ResultList>"_RetStr_"</ResultList></Response>"	
	Quit RetXML
MessageCatch
	Set ResultCode=-200
	Set ResultDesc=$ZERROR
	Set ResultDesc=$TRANSLATE(ResultDesc,"<"," ")
	Set ResultDesc=$TRANSLATE(ResultDesc,">"," ")
	Set RetXML="<Response><ResultCode>"_ResultCode_"</ResultCode><ResultDesc>"_ResultDesc_"</ResultDesc></Response>"
  	Quit RetXML
}

/// w ##Class(DHCPE.Service.NetComMethod).RunRequestMethodNew("HS10324","<Request><reportDateBegin>2017-12-06</reportDateBegin><reportDateEnd>2019-12-06</reportDateEnd></Request>")
ClassMethod RunRequestMethodNew(ActionCode As %String = "", Param As %String = "") As %GlobalCharacterStream
{
	
	Set $ZTRAP = "MessageCatchNew"
	Set ResultCode=0
	Set ResultDesc="成功"
	Set RetStr=""
	Set Action=""
	Set RetStream=##class(%GlobalCharacterStream).%New()	
	If ActionCode="" Do
	.Set ReurnCode=100
	.Set ReurnDesc="业务代码为空!"
	e  Do
	.Set ID=$ORDER(^User.DHCPEServiceActionI("ActionCode",ActionCode,""))
	.If ID'="" Do
	..Set ActionObj=##class(User.DHCPEServiceAction).%OpenId(ID)
	..Set ClassName=ActionObj.ClassName
	..Set MethodName=ActionObj.MethodName
	..If (MethodName="")||(ClassName="") Do
	...Set ReurnCode=101
	...Set ReurnDesc="业务代码未定义!"
	..e  Do
	...Set Action="##Class("_ClassName_")."_MethodName
	If Action="" Do
	.Set ResultCode=101
	.Set ResultDesc="业务代码未定义!"
	e  Do
	.Set CommandStr="RetStream="_Action_"("""_Param_""")"	
	.Set @CommandStr
	
	Set IsStream=##class(web.DHCPE.Utils.StreamUtil).IsStream(RetStream)
	If IsStream=0
	{
		Set TempStr=RetStream
		Set RetStream=##class(%GlobalCharacterStream).%New()	
		Do RetStream.Write(TempStr)
		Do RetStream.Rewind()
	}Else{
		Set TempStream=RetStream
		Set RetStream=##class(%GlobalCharacterStream).%New()	
		Do RetStream.CopyFrom(TempStream)
		Do RetStream.Rewind()
	}
	If ##class(web.DHCPE.Settings.Param).GetParamDefualt("DirectReturn",ActionCode) = 1
	{
		Quit RetStream	
	}
	Set RetStr=RetStream.Read(1000)
	If (RetStr'="")&&($PIECE(RetStr,"<",2)="") Set ResultDesc=RetStr
	If $PIECE(RetStr,"^",2)'="" Set ResultDesc=$PIECE(RetStr,"^",2)
	If (+RetStr)'=0 Do 
	.Set ResultCode=+RetStr
	.Set ResultDesc=$PIECE(RetStr,"^",2)
	.Do RetStream.Clear()
	e  Do 
	.Set ResultDesc="成功"
	Set RetXML="<Response><ResultCode>"_ResultCode_"</ResultCode><ResultDesc>"_ResultDesc_"</ResultDesc><ResultList>"
	If RetStream.SizeGet()=0
	{
		Do RetStream.Write(RetXML_"</ResultList></Response>")
	}Else{
		Do RetStream.Rewind()
		Set RetStream=##class(web.DHCPE.Utils.StreamUtil).InsertStream(RetStream,RetXML,1)
		Do RetStream.MoveToEnd()
		Do RetStream.Write("</ResultList></Response>")	
	}
	
	Quit RetStream
MessageCatchNew
	Set stream=##class(%GlobalCharacterStream).%New()	
	Set ResultCode=-200
	Set ResultDesc=$ZERROR
	Set ResultDesc=$TRANSLATE(ResultDesc,"<"," ")
	Set ResultDesc=$TRANSLATE(ResultDesc,">"," ")
	Set RetXML="<Response><ResultCode>"_ResultCode_"</ResultCode><ResultDesc>"_ResultDesc_"</ResultDesc></Response>"
  	Do stream.Write(RetXML)
  	Quit stream
}

}
