Class web.DHCENS.STBLL.ORDER.METHOD.OEOrderResultStatus Extends (%RegisteredObject, %XML.Adaptor)
{

/// Creator:lipan
/// CreatDate:2016-08-10
/// S0063 候诊中
ClassMethod InsertOEOrdResultObjWait(inputContent As %GlobalCharacterStream) As %GlobalCharacterStream
{
	set $zt="Exception"
	set suCount=0,faCount=0,faInfo=""
	set tSC=##class(%XML.XPATH.Document).CreateFromStream(inputContent,.tDocument)
	set Response=##class(web.DHCENS.STBLL.ORDER.MODEL.Response).%New()
	set header=##class(web.DHCENS.STBLL.ORDER.MODEL.Header).%New()
	set header.MessageID=##class(web.DHCENS.STBLL.UTIL.Common).CreateMessageID(+$h)
	set header.SourceSystem="02"
	set Response.header=header
	set responseBody=##class(web.DHCENS.STBLL.ORDER.MODEL.Respbody).%New()
	if $$$ISERR(tSC) {
		set responseBody.ResultCode="-1"
		set responseBody.ResultContent=tSC
		set Response.Respbody=responseBody
	}else{
		set RISRExamID=""
		set tSC=tDocument.EvaluateExpression("/Request/Body/ReportCompleteRt/RISRExamID","text()",.tRes)					
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
			set fieldValue=tRes.GetAt(1).Value
			set RISRExamID=$tr(fieldValue,$c(0),"")
		}
		set tSC=tDocument.EvaluateExpression("/Request/Body/ReportCompleteRt/OEORIOrderItemIDs","count(OEORIOrderItemID)",.tRes)
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){
			set hsCount=tRes.GetAt(1).Value
			//Quit:hsCount="0" "-1^医嘱信息为空"
			if hsCount="0" {
				set responseBody.ResultCode="-1"
		        set responseBody.ResultContent="-1^医嘱信息为空"
		        set Response.Respbody=responseBody
		        d Response.XMLExportToStream(.stream)
	            Quit stream	
			}
			for i=1:1:hsCount {
				set (OEORROrderItemID,OEORRResultStatusCode,OEORRUpdateUserCode,OEORRUpdateUserDesc,UpdateDate,UpdateTime)=""
				set HosCode="HNSRMYY"	
				set tSC=tDocument.EvaluateExpression("/Request/Body/ReportCompleteRt/OEORIOrderItemIDs/OEORIOrderItemID["_i_"]","text()",.tRes)					
				if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
					set fieldValue=tRes.GetAt(1).Value
					set OEORROrderItemID=$tr(fieldValue,$c(0),"")
					set OEORROrderItemID=$p(OEORROrderItemID,"||",1,2)
				}
				
				set tSC=tDocument.EvaluateExpression("/Request/Body/ReportCompleteRt/UpdateDate","text()",.tRes)					
				if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
					set fieldValue=tRes.GetAt(1).Value
					set UpdateDate=$tr(fieldValue,$c(0),"")
				}

				set tSC=tDocument.EvaluateExpression("/Request/Body/ReportCompleteRt/UpdateTime","text()",.tRes)					
				if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
					set fieldValue=tRes.GetAt(1).Value
					set UpdateTime=$tr(fieldValue,$c(0),"")
				}
				
				set tSC=tDocument.EvaluateExpression("/Request/Body/ReportCompleteRt/UpdateUserCode","text()",.tRes)					
				if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
					set fieldValue=tRes.GetAt(1).Value
					set OEORRUpdateUserCode=$tr(fieldValue,$c(0),"")
					set ExeUserID=$o(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(OEORRUpdateUserCode),""))
					set:ExeUserID'="" OEORRUpdateUserDesc=$p($g(^SSU("SSUSR",ExeUserID)),"^",2)
				}
				
				set tmpInput=OEORROrderItemID_"^"_RISRExamID_"^^"_OEORRUpdateUserCode_"@"_OEORRUpdateUserDesc_"^"_UpdateDate_"^"_UpdateTime
				set Result=..InsertResultStatus(tmpInput,"AW")
				if $p(Result,"^",1)=0{
					set responseBody.ResultCode="0"
					set responseBody.ResultContent="成功"
				}
				else{
					set responseBody.ResultCode="-1"
					set responseBody.ResultContent=$p(Result,"^",2)
				}
			} //for
		} //if
		set Response.Respbody=responseBody
	}  //else
	d Response.XMLExportToStream(.stream)
	Quit stream
Exception
	set stream=##class(%GlobalCharacterStream).%New()
	d stream.Write("-1^"_$ze)
	Quit stream
}

/// Creator:lipan
/// CreatDate:2016-08-10
/// S0064 检查中
ClassMethod InsertOEOrdResultObjCheck(inputContent As %GlobalCharacterStream) As %GlobalCharacterStream
{
	set $zt="Exception"
	set suCount=0,faCount=0,faInfo=""
	set tSC=##class(%XML.XPATH.Document).CreateFromStream(inputContent,.tDocument)
	set Response=##class(web.DHCENS.STBLL.ORDER.MODEL.Response).%New()
	set header=##class(web.DHCENS.STBLL.ORDER.MODEL.Header).%New()
	set header.MessageID=##class(web.DHCENS.STBLL.UTIL.Common).CreateMessageID(+$h)
	set header.SourceSystem="02"
	set Response.header=header
	set responseBody=##class(web.DHCENS.STBLL.ORDER.MODEL.Respbody).%New()
	if $$$ISERR(tSC) {
		set responseBody.ResultCode="-1"
		set responseBody.ResultContent=tSC
		set Response.Respbody=responseBody
	}else{
		set RISRExamID=""
		set tSC=tDocument.EvaluateExpression("/Request/Body/ReportCompleteRt/RISRExamID","text()",.tRes)					
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
			set fieldValue=tRes.GetAt(1).Value
			set RISRExamID=$tr(fieldValue,$c(0),"")
		}
		set tSC=tDocument.EvaluateExpression("/Request/Body/ReportCompleteRt/OEORIOrderItemIDs","count(OEORIOrderItemID)",.tRes)
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){
			set hsCount=tRes.GetAt(1).Value
			//Quit:hsCount="0" "-1^医嘱信息为空"
			if hsCount="0" {
				set responseBody.ResultCode="-1"
		        set responseBody.ResultContent="-1^医嘱信息为空"
		        set Response.Respbody=responseBody
		        d Response.XMLExportToStream(.stream)
	            Quit stream	
			}
			for i=1:1:hsCount {
				set (OEORROrderItemID,OEORRResultStatusCode,OEORRUpdateUserCode,OEORRUpdateUserDesc,UpdateDate,UpdateTime)=""
				set HosCode="HNSRMYY"	
				set tSC=tDocument.EvaluateExpression("/Request/Body/ReportCompleteRt/OEORIOrderItemIDs/OEORIOrderItemID["_i_"]","text()",.tRes)					
				if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
					set fieldValue=tRes.GetAt(1).Value
					set OEORROrderItemID=$tr(fieldValue,$c(0),"")
					set OEORROrderItemID=$p(OEORROrderItemID,"||",1,2)
				}
				
				set tSC=tDocument.EvaluateExpression("/Request/Body/ReportCompleteRt/UpdateDate","text()",.tRes)					
				if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
					set fieldValue=tRes.GetAt(1).Value
					set UpdateDate=$tr(fieldValue,$c(0),"")
				}

				set tSC=tDocument.EvaluateExpression("/Request/Body/ReportCompleteRt/UpdateTime","text()",.tRes)					
				if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
					set fieldValue=tRes.GetAt(1).Value
					set UpdateTime=$tr(fieldValue,$c(0),"")
				}
				
				set tSC=tDocument.EvaluateExpression("/Request/Body/ReportCompleteRt/UpdateUserCode","text()",.tRes)					
				if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
					set fieldValue=tRes.GetAt(1).Value
					set OEORRUpdateUserCode=$tr(fieldValue,$c(0),"")
					set ExeUserID=$o(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(OEORRUpdateUserCode),""))
					set:ExeUserID'="" OEORRUpdateUserDesc=$p($g(^SSU("SSUSR",ExeUserID)),"^",2)
				}
				
				set tmpInput=OEORROrderItemID_"^"_RISRExamID_"^^"_OEORRUpdateUserCode_"@"_OEORRUpdateUserDesc_"^"_UpdateDate_"^"_UpdateTime
				set Result=..InsertResultStatus(tmpInput,"EI")
				if $p(Result,"^",1)=0{
					set responseBody.ResultCode="0"
					set responseBody.ResultContent="成功"
				}
				else{
					set responseBody.ResultCode="-1"
					set responseBody.ResultContent=$p(Result,"^",2)
				}
			} //for
		} //if
		set Response.Respbody=responseBody
	}  //else
	d Response.XMLExportToStream(.stream)
	Quit stream
Exception
	set stream=##class(%GlobalCharacterStream).%New()
	d stream.Write("-1^"_$ze)
	Quit stream
}

/// Creator:lipan
/// CreatDate:2016-08-10
/// S0066 打印完
ClassMethod InsertOEOrdResultObjPrint(inputContent As %GlobalCharacterStream) As %GlobalCharacterStream
{
	set $zt="Exception"
	set suCount=0,faCount=0,faInfo=""
	s ^lipan(55)=inputContent.Read()_"^^^"_1
	d inputContent.Rewind()
	set tSC=##class(%XML.XPATH.Document).CreateFromStream(inputContent,.tDocument)
	set Response=##class(web.DHCENS.STBLL.ORDER.MODEL.Response).%New()
	set header=##class(web.DHCENS.STBLL.ORDER.MODEL.Header).%New()
	set header.MessageID=##class(web.DHCENS.STBLL.UTIL.Common).CreateMessageID(+$h)
	set header.SourceSystem="02"
	set Response.header=header
	set responseBody=##class(web.DHCENS.STBLL.ORDER.MODEL.Respbody).%New()
	if $$$ISERR(tSC) {
		set responseBody.ResultCode="-1"
		set responseBody.ResultContent=tSC
		set Response.Respbody=responseBody
	}else{
		set RISRExamID=""
		set tSC=tDocument.EvaluateExpression("/Request/Body/ReportCompleteRt/RISRExamID","text()",.tRes)					
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
			set fieldValue=tRes.GetAt(1).Value
			set RISRExamID=$tr(fieldValue,$c(0),"")
		}
		set tSC=tDocument.EvaluateExpression("/Request/Body/ReportCompleteRt/OEORIOrderItemIDs","count(OEORIOrderItemID)",.tRes)
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){
			set hsCount=tRes.GetAt(1).Value
			//Quit:hsCount="0" "-1^医嘱信息为空"
			if hsCount="0" {
				set responseBody.ResultCode="-1"
		        set responseBody.ResultContent="-1^医嘱信息为空"
		        set Response.Respbody=responseBody
		        d Response.XMLExportToStream(.stream)
	            Quit stream	
			}
			for i=1:1:hsCount {
				set (OEORROrderItemID,OEORRResultStatusCode,OEORRUpdateUserCode,OEORRUpdateUserDesc,UpdateDate,UpdateTime)=""
				set HosCode="HNSRMYY"	
				set tSC=tDocument.EvaluateExpression("/Request/Body/ReportCompleteRt/OEORIOrderItemIDs/OEORIOrderItemID["_i_"]","text()",.tRes)					
				if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
					set fieldValue=tRes.GetAt(1).Value
					set OEORROrderItemID=$tr(fieldValue,$c(0),"")
					set OEORROrderItemID=$p(OEORROrderItemID,"||",1,2)
				}
				
				set tSC=tDocument.EvaluateExpression("/Request/Body/ReportCompleteRt/UpdateDate","text()",.tRes)					
				if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
					set fieldValue=tRes.GetAt(1).Value
					set UpdateDate=$tr(fieldValue,$c(0),"")
				}

				set tSC=tDocument.EvaluateExpression("/Request/Body/ReportCompleteRt/UpdateTime","text()",.tRes)					
				if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
					set fieldValue=tRes.GetAt(1).Value
					set UpdateTime=$tr(fieldValue,$c(0),"")
				}
				
				set tSC=tDocument.EvaluateExpression("/Request/Body/ReportCompleteRt/UpdateUserCode","text()",.tRes)					
				if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
					set fieldValue=tRes.GetAt(1).Value
					set OEORRUpdateUserCode=$tr(fieldValue,$c(0),"")
					set ExeUserID=$o(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(OEORRUpdateUserCode),""))
					set:ExeUserID'="" OEORRUpdateUserDesc=$p($g(^SSU("SSUSR",ExeUserID)),"^",2)
				}
				
				set tmpInput=OEORROrderItemID_"^"_RISRExamID_"^^"_OEORRUpdateUserCode_"@"_OEORRUpdateUserDesc_"^"_UpdateDate_"^"_UpdateTime
				set Result=..InsertResultStatus(tmpInput,"EP")
				if $p(Result,"^",1)=0{
					set responseBody.ResultCode="0"
					set responseBody.ResultContent="成功"
				}
				else{
					set responseBody.ResultCode="-1"
					set responseBody.ResultContent=$p(Result,"^",2)
				}
			} //for
		} //if
		set Response.Respbody=responseBody
	}  //else
	d Response.XMLExportToStream(.stream)
	Quit stream
Exception
	set stream=##class(%GlobalCharacterStream).%New()
	d stream.Write("-1^"_$ze)
	Quit stream
}

/// Creator:lipan
/// CreatDate:2016-08-10
/// S0067 已删除
ClassMethod InsertOEOrdResultObjDelete(inputContent As %GlobalCharacterStream) As %GlobalCharacterStream
{
	set $zt="Exception"
	set suCount=0,faCount=0,faInfo=""
	set tSC=##class(%XML.XPATH.Document).CreateFromStream(inputContent,.tDocument)
	set Response=##class(web.DHCENS.STBLL.ORDER.MODEL.Response).%New()
	set header=##class(web.DHCENS.STBLL.ORDER.MODEL.Header).%New()
	set header.MessageID=##class(web.DHCENS.STBLL.UTIL.Common).CreateMessageID(+$h)
	set header.SourceSystem="02"
	set Response.header=header
	set responseBody=##class(web.DHCENS.STBLL.ORDER.MODEL.Respbody).%New()
	if $$$ISERR(tSC) {
		set responseBody.ResultCode="-1"
		set responseBody.ResultContent=tSC
		set Response.Respbody=responseBody
	}else{
		set RISRExamID=""
		set tSC=tDocument.EvaluateExpression("/Request/Body/ReportCompleteRt/RISRExamID","text()",.tRes)					
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
			set fieldValue=tRes.GetAt(1).Value
			set RISRExamID=$tr(fieldValue,$c(0),"")
		}
		set tSC=tDocument.EvaluateExpression("/Request/Body/ReportCompleteRt/OEORIOrderItemIDs","count(OEORIOrderItemID)",.tRes)
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){
			set hsCount=tRes.GetAt(1).Value
			//Quit:hsCount="0" "-1^医嘱信息为空"
			if hsCount="0" {
				set responseBody.ResultCode="-1"
		        set responseBody.ResultContent="-1^医嘱信息为空"
		        set Response.Respbody=responseBody
		        d Response.XMLExportToStream(.stream)
	            Quit stream	
			}
			for i=1:1:hsCount {
				set (OEORROrderItemID,OEORRResultStatusCode,OEORRUpdateUserCode,OEORRUpdateUserDesc,UpdateDate,UpdateTime)=""
				set HosCode="HNSRMYY"	
				set tSC=tDocument.EvaluateExpression("/Request/Body/ReportCompleteRt/OEORIOrderItemIDs/OEORIOrderItemID["_i_"]","text()",.tRes)					
				if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
					set fieldValue=tRes.GetAt(1).Value
					set OEORROrderItemID=$tr(fieldValue,$c(0),"")
					set OEORROrderItemID=$p(OEORROrderItemID,"||",1,2)
				}
				
				set tSC=tDocument.EvaluateExpression("/Request/Body/ReportCompleteRt/UpdateDate","text()",.tRes)					
				if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
					set fieldValue=tRes.GetAt(1).Value
					set UpdateDate=$tr(fieldValue,$c(0),"")
				}

				set tSC=tDocument.EvaluateExpression("/Request/Body/ReportCompleteRt/UpdateTime","text()",.tRes)					
				if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
					set fieldValue=tRes.GetAt(1).Value
					set UpdateTime=$tr(fieldValue,$c(0),"")
				}
				
				set tSC=tDocument.EvaluateExpression("/Request/Body/ReportCompleteRt/UpdateUserCode","text()",.tRes)					
				if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
					set fieldValue=tRes.GetAt(1).Value
					set OEORRUpdateUserCode=$tr(fieldValue,$c(0),"")
					set ExeUserID=$o(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(OEORRUpdateUserCode),""))
					set:ExeUserID'="" OEORRUpdateUserDesc=$p($g(^SSU("SSUSR",ExeUserID)),"^",2)
				}
				
				set tmpInput=OEORROrderItemID_"^"_RISRExamID_"^^"_OEORRUpdateUserCode_"@"_OEORRUpdateUserDesc_"^"_UpdateDate_"^"_UpdateTime
				set Result=..InsertResultStatus(tmpInput,"ED")
				if $p(Result,"^",1)=0{
					set responseBody.ResultCode="0"
					set responseBody.ResultContent="成功"
				}
				else{
					set responseBody.ResultCode="-1"
					set responseBody.ResultContent=$p(Result,"^",2)
				}
			} //for
		} //if
		set Response.Respbody=responseBody
	}  //else
	d Response.XMLExportToStream(.stream)
	Quit stream
Exception
	set stream=##class(%GlobalCharacterStream).%New()
	d stream.Write("-1^"_$ze)
	Quit stream
}

ClassMethod InsertResultStatus(tmpStr As %String, ResultFlag As %String) As %String
{
	
	s $ZTrap = "SendMessageET"
	s OrdRowID=$p(tmpStr,"^",1)
	s StudyNo=$p(tmpStr,"^",2)
	s PicturePath=$p(tmpStr,"^",3)
	s OperatorCode=$p($p(tmpStr,"^",4),"@",1)
	s Operator=$p($p(tmpStr,"^",4),"@",2)
	s CheckUpDate=$p(tmpStr,"^",5)
	s CheckUpTime=$p(tmpStr,"^",6)
	s:CheckUpDate="" CheckUpDate=$zd(+$h,3)
	s:CheckUpTime="" CheckUpTime=$zt($p($h,",",2),1)
    i Operator="" 
    {
        set Result= "-1^操作人员不能为空"
        q Result
    }
    
	//改变医嘱Rowid为RIS接受的形式
	s RisRowid=..ReplaceStr(OrdRowID,"||","_")
	//判断医嘱是否已经停止,停止则退出
	s ItemStatDr=$p($g(^OEORD(+RisRowid,"I",$p(RisRowid,"_",2),1)),"^",13)
	s:ItemStatDr'="" OrdStatus=$p($g(^OEC("OSTAT",ItemStatDr)),"^",1)
	i OrdStatus="D"
	{
		s Result="-1^医嘱号"_RisRowid_"已经停止！"
		q Result
	}
	
	//查询操作人信息，不存在Code默认是daijia，名称必须存在        
    if OperatorCode=""
    {
    	s OperatorAll = "daijia"_"@"_Operator
    }
    else
    {
    	s OperatorAll = OperatorCode_"@"_Operator
    }
    
	// RIS中参数格式：Info=医嘱ID^资源^更改日期^更改时间^操作员^注意事项^其他信息^检查号^检查状态^是否执行医嘱
	s tmpStr=RisRowid_"^^"_CheckUpDate_"^"_CheckUpTime_"^"_OperatorAll_"^^^"_StudyNo_"^"_ResultFlag_"^Y"
	b ; tmpStr
	s Result=##class(RISService.TrakRISService).SetExamStatusInfo(tmpStr)
	s ^DHCENSTMP("web.DHCENS.STBLL.ORDER.METHOD.OEOrderResultStatus",tmpStr)=Result
	b ;888888
	if (Result=0)||(Result=-209)
	{
		s Result="0^成功"
	}
	else
	{
		s Result="-1^更新医嘱表状态失败"	
	}
	Quit Result
SendMessageET
    Quit "-1^"_$ze
}

/// 字符串替换 
ClassMethod ReplaceStr(inStr As %String, idStr As %String, ass As %String) As %String(MAXLEN=32767)
{
	s retStr=""
	s len=$l(inStr,idStr)
	f i=1:1:len
	{
		i i'=len d
		.s retStr=retStr_$p(inStr,idStr,i)_ass
		e  d
		.s retStr=retStr_$p(inStr,idStr,i)
	}
	q retStr
}

// w ##class(web.DHCENS.STBLL.ORDER.METHOD.OEOrderResultStatus).test(1)

ClassMethod test(input As %String) As %String
{
	s stream=##class(%GlobalCharacterStream).%New()
	i input=1
	{
		d stream.Write("<Request><Header><SourceSystem>ES</SourceSystem> <MessageID>S0064</MessageID></Header><Body><ReportCompleteRt><PATPatientID>0006476510</PATPatientID><PAADMVisitNumber>21462</PAADMVisitNumber><RISRExamID>19774||4</RISRExamID><OEORIOrderItemIDs><OEORIOrderItemID>19774||4</OEORIOrderItemID></OEORIOrderItemIDs><RISRLink></RISRLink><UpdateUserCode>005929</UpdateUserCode><UpdateDate>2016-09-12</UpdateDate><UpdateTime>14:58:48</UpdateTime></ReportCompleteRt></Body></Request>")
		s ret=..InsertOEOrdResultObjCheck(stream)
	}
	d ret.OutputToDevice()
	w !
	q 0
}

}
