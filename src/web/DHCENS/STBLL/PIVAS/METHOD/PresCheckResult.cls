Class web.DHCENS.STBLL.PIVAS.METHOD.PresCheckResult Extends (%RegisteredObject, %XML.Adaptor)
{

// 审方结果回传

ClassMethod SavePresCheckResult(inputContent As %GlobalCharacterStream) As %GlobalCharacterStream
{
	set $zt="Exception"
	set stream=##class(%GlobalCharacterStream).%New()
	set tSC=##class(%XML.XPATH.Document).CreateFromStream(inputContent,.tDocument)
	if $$$ISERR(tSC) {
		d stream.Write("<Response><Header><SourceSystem>01</SourceSystem><MessageID></MessageID></Header><Body><ResultCode>-1</ResultCode><ResultContent>XML格式不正确</ResultContent></Body></Response>")
		Quit stream
	}else{
		set tSC=tDocument.EvaluateExpression("/Request/Body/OEORIInfoList","count(OEORIInfo)",.tRes)
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){
			set hsCount=tRes.GetAt(1).Value
			if (hsCount="0"){
				d stream.Write("<Response><Header><SourceSystem>01</SourceSystem><MessageID></MessageID></Header><Body><ResultCode>-1</ResultCode><ResultContent>医嘱执行信息为空</ResultContent></Body></Response>")
			}
			Quit:hsCount="0" stream
			set ret="0"
			for i=1:1:hsCount {
				set (OrderExecuteID,Result)=""	
				set tSC=tDocument.EvaluateExpression("/Request/Body/OEORIInfoList/OEORIInfo["_i_"]/OrderExecuteID","text()",.tRes)				
				if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
					set fieldValue=tRes.GetAt(1).Value
					set OrderExecuteID=$tr(fieldValue,$c(0),"")
				}
				set tSC=tDocument.EvaluateExpression("/Request/Body/OEORIInfoList/OEORIInfo["_i_"]/OEORIOrderItemID","text()",.tRes)				
				if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
					set fieldValue=tRes.GetAt(1).Value
					set OEORIOrderItemID=$tr(fieldValue,$c(0),"")
				}

				set tSC=tDocument.EvaluateExpression("/Request/Body/OEORIInfoList/OEORIInfo["_i_"]/Result","text()",.tRes)				
				if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
					set fieldValue=tRes.GetAt(1).Value
					set Result=$tr(fieldValue,$c(0),"")
				}
				set ord=$p(OEORIOrderItemID,"||",1)
				set chl=$p(OEORIOrderItemID,"||",2)
				
				if $p(Result,"^",1)="-1" d
				.//调用药房程序保存审方结果
				.set ret=##Class(web.DHCSTCNTSIPMONITOR).SHJJForOther(ord_"||"_chl,$p(Result,"^",2))
					
			}
			if (ret="0")
			{
				d stream.Write("<Response><Header><SourceSystem>01</SourceSystem><MessageID></MessageID></Header><Body><ResultCode>0</ResultCode><ResultContent>成功</ResultContent></Body></Response>")
			}
			else
			{
				d stream.Write("<Response><Header><SourceSystem>01</SourceSystem><MessageID></MessageID></Header><Body><ResultCode>-1</ResultCode><ResultContent>失败</ResultContent></Body></Response>")
			}
				
		}
	}
	Quit stream
Exception
	set stream=##class(%GlobalCharacterStream).%New()
	d stream.Write("<Response><Header><SourceSystem>01</SourceSystem><MessageID></MessageID></Header><Body><ResultCode>-1</ResultCode><ResultContent>"_$ze_"</ResultContent></Body></Response>")
	Quit stream
}

}
