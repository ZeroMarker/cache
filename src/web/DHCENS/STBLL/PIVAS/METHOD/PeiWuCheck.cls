Class web.DHCENS.STBLL.PIVAS.METHOD.PeiWuCheck Extends (%RegisteredObject, %XML.Adaptor)
{

/// w ##class(web.DHCENS.STBLL.PIVAS.METHOD.PeiWuCheck).Test("")
ClassMethod Test(Input As %String) As %String
{
	s stream=##class(%GlobalCharacterStream).%New()
	//d stream.Write("<Request><Header><SourceSystem></SourceSystem><MessageID></MessageID></Header><Body><PATPatientID>0000000015</PATPatientID><PAADMVisitNumber>32</PAADMVisitNumber><OEORIInfoList><OEORIInfo><OEORIOrderItemID>28||3</OEORIOrderItemID><OrderExecuteID>28||3||1</OrderExecuteID><Status>1</Status><DeptCode>1499010400</DeptCode></OEORIInfo><OEORIInfo><OEORIOrderItemID>28||4</OEORIOrderItemID><OrderExecuteID>28||4||1</OrderExecuteID><Status>1</Status><DeptCode>1499010400</DeptCode></OEORIInfo></OEORIInfoList><UpdateUserCode>00872</UpdateUserCode><UpdateDate>2019-05-06</UpdateDate><UpdateTime>20:23:23</UpdateTime></Body></Request>")
	d stream.Write("<Request><Header><SourceSystem>S0089</SourceSystem><MessageID></MessageID></Header><Body><Oeori>2126||24</Oeori><User>D10279</User><Apptype>IA</Apptype><Result>测试配伍</Result><OEORIInfoList><OEORIInfo><OrderExecuteID>2126||23</OrderExecuteID><Result>-1</Result></OEORIInfo><OEORIInfo><OrderExecuteID>2126||24</OrderExecuteID><Result>-1</Result></OEORIInfo></OEORIInfoList></Body></Request>")
	s tsc=..SavePeiWuCheckInfo(stream)
	q tsc.Read(tsc.Size)
}

/// Creator：HHL
/// CreatDate：2021—08-03
/// Description：静配-配伍审核拒绝(药房)
/// Table：
/// Input：XML
/// Output：
/// Return：XML
/// Others：w ##class(web.DHCENS.STBLL.PIVAS.METHOD.PeiWuCheck).SavePeiWuCheckInfo("<Request><Header><SourceSystem>S0089</SourceSystem><MessageID></MessageID></Header><Body><User>D10279</User><Apptype>IA</Apptype><Result>测试配伍</Result><OEORIInfoList><OEORIInfo><OrderExecuteID>2126||23</OrderExecuteID><Result>-1</Result></OEORIInfo><OEORIInfo><OrderExecuteID>2126||24</OrderExecuteID><Result>-1</Result></OEORIInfo></OEORIInfoList></Body></Request>")
ClassMethod SavePeiWuCheckInfo(inputContent As %GlobalCharacterStream) As %GlobalCharacterStream
{
	set $zt="Exception"
	set stream=##class(%GlobalCharacterStream).%New()
	set tSC=##class(%XML.XPATH.Document).CreateFromStream(inputContent,.tDocument)
	if $$$ISERR(tSC) {
		d stream.Write("<Response><Header><SourceSystem>01</SourceSystem><MessageID></MessageID></Header><Body><ResultCode>-1</ResultCode><ResultContent>XML格式不正确</ResultContent></Body></Response>")
		Quit stream
	}else{
		
				
				set (Oeori,User,Apptype,ReasonResult,UserID,ret)=""	
				set tSC=tDocument.EvaluateExpression("/Request/Body/Oeori","text()",.tRes)				
				
				if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
					set fieldValue=tRes.GetAt(1).Value
					set Oeori=$tr(fieldValue,$c(0),"")
				}
				set tSC=tDocument.EvaluateExpression("/Request/Body/User","text()",.tRes)				
				if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
					set fieldValue=tRes.GetAt(1).Value
					set User=$tr(fieldValue,$c(0),"")
				}
				s:User'="" UserID = $O(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(User),""))
				
				set tSC=tDocument.EvaluateExpression("/Request/Body/Apptype","text()",.tRes)				
				if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
					set fieldValue=tRes.GetAt(1).Value
					set Apptype=$tr(fieldValue,$c(0),"")
				}
				
				set tSC=tDocument.EvaluateExpression("/Request/Body/Result","text()",.tRes)				
				if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
					set fieldValue=tRes.GetAt(1).Value
					set ReasonResult=$tr(fieldValue,$c(0),"")
				}
				
#;		set tSC=tDocument.EvaluateExpression("/Request/Body/OEORIInfoList","count(OEORIInfo)",.tRes)
#;		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){
#;			set hsCount=tRes.GetAt(1).Value
#;			if (hsCount="0"){
#;				d stream.Write("<Response><Header><SourceSystem>01</SourceSystem><MessageID></MessageID></Header><Body><ResultCode>-1</ResultCode><ResultContent>拒绝医嘱为空</ResultContent></Body></Response>")
#;			}
#;			Quit:hsCount="0"
#;			set Flag=0,OrderExecuteIDStr=""
#;			for i=1:1:hsCount {
#;				
#;				set (OrderExecuteID)=""	
#;				set tSC=tDocument.EvaluateExpression("/Request/Body/OEORIInfoList/OEORIInfo["_i_"]/OrderExecuteID","text()",.tRes)				
#;				if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
#;					set fieldValue=tRes.GetAt(1).Value
#;					set OrderExecuteID=$tr(fieldValue,$c(0),"")
#;					
#;				}
#;				if (Oeori=""){
#;					
#;					s Oeori=OrderExecuteID
#;				}else {
#;					
#;					s Oeori=Oeori_"^"_OrderExecuteID
#;				}
#;				
#;			}
#;		}
				
				s ^TMPHHL("GetRefuseInfoForPIVAS")=Oeori_"^"_UserID_"^"_Apptype_"^"_ReasonResult
				//调用药房程序保存配伍审核拒绝	医嘱ID,用户ID,SHJJ,拒绝原因
				set ret=##class(PHA.FACE.OUT.Com).GetRefuseInfoForPIVAS(Oeori,UserID,"SHJJ",ReasonResult)
					
			
			if ($P(ret,"^",1)="0")
			{
				d stream.Write("<Response><Header><SourceSystem>01</SourceSystem><MessageID></MessageID></Header><Body><ResultCode>0</ResultCode><ResultContent>成功</ResultContent></Body></Response>")
			}
			else
			{
				d stream.Write("<Response><Header><SourceSystem>01</SourceSystem><MessageID></MessageID></Header><Body><ResultCode>-1</ResultCode><ResultContent>"_ret_"</ResultContent></Body></Response>")
			}
	}	
	
	Quit stream
Exception
	set stream=##class(%GlobalCharacterStream).%New()
	d stream.Write("<Response><Header><SourceSystem>01</SourceSystem><MessageID></MessageID></Header><Body><ResultCode>-1</ResultCode><ResultContent>"_$ze_"</ResultContent></Body></Response>")
	Quit stream
}

/// Creator：HHL
/// CreatDate：2021—08-03
/// Description：静配-发送配伍审核拒绝申诉(药房)
/// Table：
/// Input：登记号^就诊号^医嘱号^申诉理由^申诉人编码^申诉日期^申诉时间^医嘱执行科室代码
/// Output：w ##class(web.DHCENS.EnsHISService).DHCHisInterface("S00000058","登记号^就诊号^医嘱号^申诉理由^申诉人编码^申诉日期^申诉时间")
/// Return：XML
/// Others：w ##class(web.DHCENS.STBLL.PIVAS.METHOD.PeiWuCheck).SendPeiWuCheckAppInfo("1")
ClassMethod SendPeiWuCheckAppInfo(input As %String) As %String
{
	set $zt="Exception"
	set request=##class(web.DHCENS.STBLL.PIVAS.MODEL.Request).%New()
	set header=##class(web.DHCENS.STBLL.PIVAS.MODEL.Header).%New()
	set header.SourceSystem="02"
	set MessageID=##class(web.DHCENS.STBLL.UTIL.Common).CreateMessageID(+$h)
	set header.MessageID=MessageID
	set request.header=header
	set body=##class(web.DHCENS.STBLL.PIVAS.MODEL.Body).%New()
	s Obj=##class(web.DHCENS.STBLL.PIVAS.MODEL.SendPeiWuCheckAppInfo).%New()
	s Obj.PATPatientID=$P(input,"^",1)
	s Obj.PAADMVisitNumber=$P(input,"^",2)
	s Obj.OEORIParentOrderID=$P(input,"^",3)
	s Obj.PADRemarks=$P(input,"^",4)
	s Obj.UpdateUserCode=$P(input,"^",5)
	s Obj.UpdateDate=$P(input,"^",6)
	s Obj.UpdateTime=$P(input,"^",7)
	s Obj.ReDeptCode=$P(input,"^",8)
	
	s body.PeiWuCheckAppInfoRt=Obj
	set request.body=body
	d request.XMLExportToStream(.stream)
	s soap=##class(web.DHCENS.STBLL.PIVAS.SOAP.PUB0021Soap).%New()
	s ret=soap.HIPMessageServer("MES0041",stream)
	Quit ret.Read()
Exception
	set stream=##class(%GlobalCharacterStream).%New()
	d stream.Write("<Response><Header><SourceSystem>01</SourceSystem><MessageID></MessageID></Header><Body><ResultCode>-1</ResultCode><ResultContent>"_$ze_"</ResultContent></Body></Response>")
	Quit stream
}

}
