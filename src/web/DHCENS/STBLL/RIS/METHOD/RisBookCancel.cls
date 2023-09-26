Class web.DHCENS.STBLL.RIS.METHOD.RisBookCancel Extends (%RegisteredObject, %XML.Adaptor)
{

/// 取消预约
ClassMethod RisBookCancelInfo(inputContent As %GlobalCharacterStream) As %GlobalCharacterStream
{
	set $Ztrap="Exception"
	set suCount=0,faCount=0,faInfo=""
	set tSC=##class(%XML.XPATH.Document).CreateFromStream(inputContent,.tDocument)
	set Response=##class(web.DHCENS.STBLL.RIS.MODEL.ResponseInfo).%New()
	set header=##class(web.DHCENS.STBLL.RIS.MODEL.ResponseHeader).%New()
	set header.MessageID=##class(web.DHCENS.STBLL.UTIL.Common).CreateMessageID(+$h)
	set header.SourceSystem="02"
	set Response.header=header
	set responseBody=##class(web.DHCENS.STBLL.RIS.MODEL.ResponseBody).%New()
	if $$$ISERR(tSC) {
		set responseBody.ResultCode="-1"
		set responseBody.ResultContent=tSC
		set Response.Respbody=responseBody
	}else{
		set SourceSystemHer=""
		set tSC=tDocument.EvaluateExpression("/Request/Header/SourceSystem","text()",.tRes)					
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
			set fieldValue=tRes.GetAt(1).Value
			set SourceSystemHer=$tr(fieldValue,$c(0),"")
		}
		set RISRExamID=""
		set tSC=tDocument.EvaluateExpression("/Request/Body/RisBookCancelRt/RISRExamID","text()",.tRes)					
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
			set fieldValue=tRes.GetAt(1).Value
			set RISRExamID=$tr(fieldValue,$c(0),"")
		}
		set tSC=tDocument.EvaluateExpression("/Request/Body/RisBookCancelRt/OEORIOrderItemIDList","count(OEORIOrderItemID)",.tRes)
			if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){
			set hsCount=tRes.GetAt(1).Value
			if hsCount="0" {
				set responseBody.ResultCode="-1"
		        set responseBody.ResultContent="-1^医嘱信息为空"
		        set Response.Respbody=responseBody
		        d Response.XMLExportToStream(.stream)
	            Quit stream	
			}
			for i=1:1:hsCount {
				set (OEORROrderItemID,UpdateUserCode,UpdateUserDesc,UpdateDate,UpdateTime)=""	
				set tSC=tDocument.EvaluateExpression("/Request/Body/RisBookCancelRt/OEORIOrderItemIDList/OEORIOrderItemID["_i_"]","text()",.tRes)					
				if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
					set fieldValue=tRes.GetAt(1).Value
					set OEORROrderItemID=$tr(fieldValue,$c(0),"")
					set OEORROrderItemID=$p(OEORROrderItemID,"||",1,2)
				}
				
				set tSC=tDocument.EvaluateExpression("/Request/Body/RisBookCancelRt/UpdateDate","text()",.tRes)					
				if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
					set fieldValue=tRes.GetAt(1).Value
					set UpdateDate=$tr(fieldValue,$c(0),"")
				}

				set tSC=tDocument.EvaluateExpression("/Request/Body/RisBookCancelRt/UpdateTime","text()",.tRes)					
				if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
					set fieldValue=tRes.GetAt(1).Value
					set UpdateTime=$tr(fieldValue,$c(0),"")
				}
				
				set tSC=tDocument.EvaluateExpression("/Request/Body/RisBookCancelRt/UpdateUserCode","text()",.tRes)					
				if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
					set fieldValue=tRes.GetAt(1).Value
					set UpdateUserCode=$tr(fieldValue,$c(0),"")
					set ExeUserID=$o(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(UpdateUserCode),""))
					set:ExeUserID'="" UpdateUserDesc=$p($g(^SSU("SSUSR",ExeUserID)),"^",2)
				}
				
				set tmpInput=OEORROrderItemID_"^"_RISRExamID_"^^"_UpdateUserCode_"@"_UpdateUserDesc_"^"_UpdateDate_"^"_UpdateTime
				// 更新检查状态20190621
				;set Result=##class(appcom.OEOrdItem).Verify(OEORROrderItemID,ExeUserID) ; 修改医嘱状态
				set UpdateDateTime=UpdateDate_" "_UpdateTime
				set Position=""
				set Status="CBK"
				;set:SourceSystemHer="SYS0003" SourceSystem="EKG"
				set:SourceSystemHer="SYS0004" SourceSystem="PIS"
				if SourceSystemHer="SYS0003" set SourceSystem=##Class(web.DHCENS.STBLL.RIS.METHOD.Common).GetSystemType(OEORROrderItemID) ; 调用pacs组方法取系统编码
				
				set jsonstr="[{""OEOrdItemID"":"""_OEORROrderItemID_""","_"""Position"":"""_Position_""","_"""ExamID"":"""_RISRExamID_""","_"""Status"":"""_Status_""","_"""UserID"":"""_UpdateUserCode_""","_"""UserName"":"""_UpdateUserDesc_""","_"""UpDateTime"":"""_UpdateDateTime_""","_"""SourceSystem"":"""_SourceSystem_""""_"}]"
				set jsonStream=##class(%GlobalCharacterStream).%New()
				d jsonStream.Write(jsonstr)
				set tSC=##class(%GlobalCharacterStream).%New()
				set tSC=##class(web.DHCENS.EnsHISService).DHCHisInterface("UpdateSystemStatus",jsonStream)
				set tSCStr=tSC.Read()
				
				if (tSCStr["成功"){
					set responseBody.ResultCode="0"
					set responseBody.ResultContent="成功"
				}
				else{
					set responseBody.ResultCode="-1"
					set responseBody.ResultContent="^医嘱闭环返回————"_tSCStr
				}
			} //for
		} //if
		if hsCount="0"
		{
			set responseBody.ResultCode="-1"
			set responseBody.ResultContent="失败^核实医嘱rowid的list--OEORIOrderItemIDList，xml节点是否正确"
			}
		set Response.Respbody=responseBody
	}  //else
	d Response.XMLExportToStream(.stream) 
	do stream.Rewind()
	Quit stream
Exception
	set stream=##class(%GlobalCharacterStream).%New()
	d stream.Write("<Response><Header><SourceSystem>SYS0001</SourceSystem><MessageID>5</MessageID></Header><Body><ResultCode>-1</ResultCode><ResultContent>-1^"_$ze_"</ResultContent></Body></Response>")
	Quit stream
}

}
