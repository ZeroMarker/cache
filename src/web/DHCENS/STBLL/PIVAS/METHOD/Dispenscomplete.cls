Class web.DHCENS.STBLL.PIVAS.METHOD.Dispenscomplete Extends (%RegisteredObject, %XML.Adaptor)
{

// 配液完成信息回传

/// w ##class(web.DHCENS.STBLL.PIVAS.METHOD.Dispenscomplete).DispenscompleteInfo
ClassMethod DispenscompleteInfo(inputContent As %GlobalCharacterStream) As %GlobalCharacterStream
{
	set $zt="Exception"
	set tSC=##class(%XML.XPATH.Document).CreateFromStream(inputContent,.tDocument)
	
	set stream=##class(%GlobalCharacterStream).%New()
	if $$$ISERR(tSC) {
		d stream.Write("<Response><Header><SourceSystem>01</SourceSystem><MessageID></MessageID></Header><Body><ResultCode>-1</ResultCode><ResultContent>xml格式不正确</ResultContent></Body></Response>")
		Quit stream
	}else{
		set tSC=tDocument.EvaluateExpression("/Request/Body/OEORIInfoList","count(OEORIInfo)",.tRes)
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){
			set hsCount=tRes.GetAt(1).Value
			if (hsCount="0"){
				d stream.Write("<Response><Header><SourceSystem>01</SourceSystem><MessageID></MessageID></Header><Body><ResultCode>-1</ResultCode><ResultContent>医嘱执行信息为空</ResultContent></Body></Response>")
			}
			Quit:hsCount="0"
			set Flag=0,OrderExecuteIDStr=""
			for i=1:1:hsCount {
				Quit:Flag=-1
				set (OrderExecuteID)=""	
				set tSC=tDocument.EvaluateExpression("/Request/Body/OEORIInfoList/OEORIInfo["_i_"]/OrderExecuteID","text()",.tRes)				
				if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
					set fieldValue=tRes.GetAt(1).Value
					set OrderExecuteID=$tr(fieldValue,$c(0),"")
					
				}
				set (UserCode)=""	
				set tSC=tDocument.EvaluateExpression("/Request/Body/OEORIInfoList/OEORIInfo["_i_"]/UserCode","text()",.tRes)				
				if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
					set fieldValue=tRes.GetAt(1).Value
					set UserCode=$tr(fieldValue,$c(0),"")
					
				}
				;continue:OrderExecuteID=""
				if (OrderExecuteIDStr="") d
				.set OrderExecuteIDStr=OrderExecuteID
				e  d
				.set OrderExecuteIDStr=$g(OrderExecuteIDStr)_"^"_OrderExecuteID			
#;				set DSPConfirmFlag=""
#;				if ($D(^DHCOEDISQTY(0,"OEORE",OrderExecuteID))){
#;				set OEDispensingRowId=$o(^DHCOEDISQTY(0,"OEORE",OrderExecuteID,""))
#;				set:OEDispensingRowId'="" DSPConfirmFlag=$p(^DHCOEDISQTY(OEDispensingRowId),"^",17)
#;				if (DSPConfirmFlag'="Y")&&(DSPConfirmFlag'="")
#;				{
#;					set Flag=-1
#;				}
#;				}
				
			}
#;			if (Flag="-1")
#;			{
#;				d stream.Write("<Response><Header><SourceSystem>01</SourceSystem><MessageID></MessageID></Header><Body><ResultCode>-1</ResultCode><ResultContent>此记录已经撤销领药审核，不允许计费</ResultContent></Body></Response>")
#;				Quit stream				
#;			}
			;set rtn=##class(web.DHCSTPIVAPRINTLABEL).DispensingPIVAS(OrderExecuteIDStr)
			set rtn=##class(web.DHCSTPCHCOLLS).InsPhaCollByOEORE(OrderExecuteIDStr,"",UserCode)
			set ResultCode=$p(rtn,"^",1)
			set ResultContent=$p(rtn,"^",2)
			if (ResultCode="0")
			{
				d stream.Write("<Response><Header><SourceSystem>HIS</SourceSystem><MessageID></MessageID></Header><Body><ResultCode>0</ResultCode><ResultContent>成功</ResultContent></Body></Response>")
			}
			
			else{
				if (ResultCode="")
				{
					d stream.Write("<Response><Header><SourceSystem>HIS</SourceSystem><MessageID></MessageID></Header><Body><ResultCode>-1</ResultCode><ResultContent>减库存失败</ResultContent></Body></Response>")
				} 
				else
				{
					d stream.Write("<Response><Header><SourceSystem>HIS</SourceSystem><MessageID></MessageID></Header><Body><ResultCode>-1</ResultCode><ResultContent>"_ResultContent_"</ResultContent></Body></Response>")
				}
			}
		}
		else
		{
			d stream.Write("<Response><Header><SourceSystem>HIS</SourceSystem><MessageID></MessageID></Header><Body><ResultCode>-1</ResultCode><ResultContent>医嘱信息结构不对</ResultContent></Body></Response>")
		}
	}
	Quit stream
Exception
	set stream=##class(%GlobalCharacterStream).%New()
	d stream.Write("<Response><Header><SourceSystem>HIS</SourceSystem><MessageID></MessageID></Header><Body><ResultCode>-1</ResultCode><ResultContent>"_$ze_"</ResultContent></Body></Response>")
	Quit stream
}

// w ##class(web.DHCENS.STBLL.PIVAS.METHOD.Dispenscomplete).Test()

ClassMethod Test(Input As %String) As %String
{
	s stream=##class(%GlobalCharacterStream).%New()
	//d stream.Write("<Request><Header><SourceSystem></SourceSystem><MessageID></MessageID></Header><Body><PATPatientID>0000000015</PATPatientID><PAADMVisitNumber>32</PAADMVisitNumber><OEORIInfoList><OEORIInfo><OEORIOrderItemID>28||3</OEORIOrderItemID><OrderExecuteID>28||3||1</OrderExecuteID><Status>1</Status><DeptCode>1499010400</DeptCode></OEORIInfo><OEORIInfo><OEORIOrderItemID>28||4</OEORIOrderItemID><OrderExecuteID>28||4||1</OrderExecuteID><Status>1</Status><DeptCode>1499010400</DeptCode></OEORIInfo></OEORIInfoList><UpdateUserCode>00872</UpdateUserCode><UpdateDate>2019-05-06</UpdateDate><UpdateTime>20:23:23</UpdateTime></Body></Request>")
	d stream.Write("<Request><Header><SourceSystem>PIVAS</SourceSystem><MessageID>360</MessageID></Header><Body><OEORIInfoList><OEORIInfo><OrderExecuteID>9552||52||1</OrderExecuteID></OEORIInfo><OEORIInfo><OrderExecuteID>9552||53||1</OrderExecuteID></OEORIInfo><OEORIInfo><OrderExecuteID>9552||54||1</OrderExecuteID></OEORIInfo><OEORIInfo><OrderExecuteID>9552||55||1</OrderExecuteID></OEORIInfo><OEORIInfo><OrderExecuteID>9552||56||1</OrderExecuteID></OEORIInfo><OEORIInfo><OrderExecuteID>9552||57||1</OrderExecuteID></OEORIInfo><OEORIInfo><OrderExecuteID>9552||58||1</OrderExecuteID></OEORIInfo><OEORIInfo><OrderExecuteID>9552||59||1</OrderExecuteID></OEORIInfo></OEORIInfoList></Body></Request>")
	s tsc=##class(web.DHCENS.STBLL.PIVAS.METHOD.Dispenscomplete).DispenscompleteInfo(stream)
	q tsc.Read(tsc.Size)
}

}
