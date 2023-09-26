Class web.DHCENS.STBLL.PIS.METHOD.UpdateOrdersState Extends (%RegisteredObject, %XML.Adaptor)
{

/// Creator：ZhangXinying
/// CreatDate：2021—07-02
/// Description:病理撤销医嘱
/// Table：
/// Input：<Request><Header><SourceSystem></SourceSystem><MessageID></MessageID></Header><Body><CancelOrdersRt><ThirdID></ThirdID><HISOEOrdId>12||1</HISOEOrdId><UserCode>1001</UserCode></CancelOrdersRt></Body></Request>
/// w ##class(web.DHCENS.STBLL.PIS.METHOD.UpdateOrdersState).StopOrdItems("<Request><Header><SourceSystem></SourceSystem><MessageID></MessageID></Header><Body><CancelOrdersRt><ThirdID></ThirdID><HISOEOrdId>12||1</HISOEOrdId><UserCode>1001</UserCode></CancelOrdersRt></Body></Request>").Read()
ClassMethod StopOrdItems(Input As %GlobalCharacterStream) As %GlobalCharacterStream
{
	set $zt="Exception"
	
	set tSC=##class(%XML.XPATH.Document).CreateFromStream(Input,.tDocument)
	d Input.Rewind()
	s ExecFlag=""
	set Response=##class(web.DHCENS.STBLL.PIS.MODEL.Response).%New()
	set header=##class(web.DHCENS.STBLL.PIS.MODEL.Header).%New()
	set header.MessageID=##class(web.DHCENS.STBLL.UTIL.Common).CreateMessageID(+$h)
	set header.SourceSystem="02"
	set Response.header=header
	set responseBody=##class(web.DHCENS.STBLL.PIS.MODEL.Respbody).%New()
	set InvalidFlag=0,InvalidStr=""
	if $$$ISERR(tSC) {
		set responseBody.ResultCode="-1"
		set responseBody.ResultContent=tSC
		set Response.Respbody=responseBody
	}else{
			set ThirdID="",UserCode="",HISOEOrdId=""
				
			set tSC=tDocument.EvaluateExpression("/Request/Body/CancelOrdersRt/ThirdID","text()",.tRes)					
			if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){	
				set fieldValue=tRes.GetAt(1).Value
				set ThirdID=$tr(fieldValue,$c(0),"")
			}
			
			set tSC=tDocument.EvaluateExpression("/Request/Body/CancelOrdersRt/HISOEOrdId","text()",.tRes)					
			if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){	
				set fieldValue=tRes.GetAt(1).Value
				set HISOEOrdId=$tr(fieldValue,$c(0),"")
			}
			set tSC=tDocument.EvaluateExpression("/Request/Body/CancelOrdersRt/UserCode","text()",.tRes)					
			if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){	
				set fieldValue=tRes.GetAt(1).Value
				set UserCode=$tr(fieldValue,$c(0),"")
			}
		
				//for i=1:1:hsCount {
					s OEORIStatusCode="U"   //"D"
					set IsFlag=..IsStopOrder(HISOEOrdId,OEORIStatusCode)
					if 'IsFlag{
						s InvalidFlag=1
						s TmpStr="医嘱号:"_HISOEOrdId_"已收费不能修改医嘱状态为:"_OEORIStatusCode
						if InvalidStr=""{
							s InvalidStr=TmpStr
						}
						else{
							s InvalidStr=InvalidStr_"^^^"_TmpStr
						}
						//continue
					}
					
					set OstatRowid=$o(^OEC("OSTAT",0,"Code",$$ALPHAUP^SSUTIL4(OEORIStatusCode),""))
					set ExeUserID=$o(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(UserCode),""))
					set ExecFlag="" 
					if ((HISOEOrdId'="")&&(ExeUserID'="")&&(OstatRowid'="")){
						//s ExecFlag=##class(appcom.OEOrdItem).UpdateStatus(HISOEOrdId,ExeUserID,OstatRowid)  //只修改医嘱状态
						//取医嘱状态，若为6执行，则调用医技科室取消执行医嘱接口 Verify，将医嘱状态修改为1核实
						s OEORIItemStatDR=$p($g(^OEORD(+HISOEOrdId,"I",$p(HISOEOrdId,"||",2),1)),"^",13)
						i (OEORIItemStatDR="6") { s ExecFlag=##class(appcom.OEOrdItem).Verify(HISOEOrdId,ExeUserID)}
						s ExecFlag= ##class(appcom.OEOrdItem).UnUse(HISOEOrdId,ExeUserID) //包含退费（作废单条医嘱）
					}
					
				//}
				if ((ExecFlag=0)||(ExecFlag=100)){
						s responseBody.ResultCode="0"
						s responseBody.ResultContent="成功"
					
					}
				else {
				    s responseBody.ResultCode="-1"
					s responseBody.ResultContent="失败"
				}
				if (InvalidFlag=1){
					s responseBody.ResultCode="-1"
					s responseBody.ResultContent=InvalidStr
				}
			}
		
		s Response.Respbody=responseBody
	
    
    d Response.XMLExportToStream(.stream)
    q stream
    
Exception
	set stream=##class(%GlobalCharacterStream).%New()
	d stream.Write("-1^"_$ze)
	b ;2
	Quit stream
}

ClassMethod IsStopOrder(ordRowId As %String, OrderStatuCode As %String) As %String
{
	set ord = $P(ordRowId,"||",1)
	set sub = $P(ordRowId,"||",2)
	set ordstr3 = $g(^OEORD(ord,"I",sub,3))
	set OEORIBillStatusCode = $P(ordstr3,"^",5)
	q:((OEORIBillStatusCode="P")&&(OrderStatuCode="U")) "0"
	q:((OEORIBillStatusCode="P")&&(OrderStatuCode="D")) "0"
	q:((OEORIBillStatusCode="P")&&(OrderStatuCode="C")) "0"
	
	q "1"
}

/// w ##class(web.DHCENS.STBLL.PIS.METHOD.UpdateOrdersState).Test()
ClassMethod Test() As %String
{
	s stream=##class(%GlobalCharacterStream).%New()
	d stream.Write("<Request><ThirdID></ThirdID><HISOEOrdId>12||1</HISOEOrdId><UserCode>1001</UserCode></Request>")
	s rtn=..StopOrdItems(stream)
	q rtn.Read()
}

}
