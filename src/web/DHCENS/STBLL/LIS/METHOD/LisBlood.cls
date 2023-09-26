Class web.DHCENS.STBLL.LIS.METHOD.LisBlood Extends (%RegisteredObject, %XML.Adaptor)
{

/// w ##class(web.DHCENS.STBLL.LIS.METHOD.LisBlood).LisBlood("").Read()
/// S0028 检验采血
ClassMethod LisBlood(inputContent As %GlobalCharacterStream) As %GlobalCharacterStream
{
	set $Ztrap="Exception"
	;set inputContent=##class(%GlobalCharacterStream).%New()
	;d inputContent.Write("<Request><Header><SourceSystem>SYS0005</SourceSystem><MessageID></MessageID></Header><Body><LisBloodRt><SpecimenID>120122230374</SpecimenID><OEORIOrderItemIDs><OEORIOrderItemID>5||43</OEORIOrderItemID></OEORIOrderItemIDs><PATPatientID>0000000002</PATPatientID><PAADMVisitNumber>5</PAADMVisitNumber><LISReportLink></LISReportLink><ChargeInfos><ChargeInfo><ChargeCode>wz00002</ChargeCode><ChargeCount>1</ChargeCount></ChargeInfo></ChargeInfos><UpdateUserCode>10129</UpdateUserCode><UpdateDate>2020-12-23</UpdateDate><UpdateTime>15:20:00</UpdateTime></LisBloodRt></Body></Request>")
	set suCount=0,faCount=0,faInfo=""
	set tSC=##class(%XML.XPATH.Document).CreateFromStream(inputContent,.tDocument)
	set Response=##class(web.DHCENS.STBLL.LIS.MODEL.Response).%New()
	set header=##class(web.DHCENS.STBLL.LIS.MODEL.Header).%New()
	set header.MessageID=##class(web.DHCENS.STBLL.UTIL.Common).CreateMessageID(+$h)
	set header.SourceSystem="02"
	set Response.header=header
	set responseBody=##class(web.DHCENS.STBLL.LIS.MODEL.Respbody).%New()
	set AmountInput="",Result=""
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
		set SpecimenID=""
		set tSC=tDocument.EvaluateExpression("/Request/Body/LisBloodRt/SpecimenID","text()",.tRes)					
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
			set fieldValue=tRes.GetAt(1).Value
			set SpecimenID=$tr(fieldValue,$c(0),"")
		}
		set tSC=tDocument.EvaluateExpression("/Request/Body/LisBloodRt/OEORIOrderItemIDs","count(OEORIOrderItemID)",.tRes)
			if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){
			set hsCount=tRes.GetAt(1).Value
			if hsCount="0" {
				set responseBody.ResultCode="-1"
		        set responseBody.ResultContent="-1^医嘱信息为空"
		        set Response.Respbody=responseBody
		        d Response.XMLExportToStream(.stream)
	            Quit stream	
			}
			s OrdRowIds=""
			for i=1:1:hsCount {
				set (OEORROrderItemID,UpdateUserCode,UpdateUserDesc,UpdateDate,UpdateTime)=""
				;set HosCode="DHSZHYYZY"	
				set tSC=tDocument.EvaluateExpression("/Request/Body/LisBloodRt/OEORIOrderItemIDs/OEORIOrderItemID["_i_"]","text()",.tRes)					
				if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
					set fieldValue=tRes.GetAt(1).Value
					set OEORROrderItemID=$tr(fieldValue,$c(0),"")
					if OrdRowIds'=""{
						set OrdRowIds=OrdRowIds_"^"_OEORROrderItemID
					}
					else {
						set OrdRowIds=OEORROrderItemID
					}
				}
			}
			set tSC=tDocument.EvaluateExpression("/Request/Body/LisBloodRt/ChargeInfos","count(ChargeInfo)",.tRes)					
			if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){
				set chargeCount=tRes.GetAt(1).Value
				if chargeCount="" {
					set responseBody.ResultCode="0"
					set responseBody.ResultContent="试管数量为空"
					set Response.Respbody=responseBody
			        d Response.XMLExportToStream(.stream)
		            Quit stream	

				}
				else{
					for j=1:1:chargeCount {
						set (ChargeCode,ChargeCount)=""
						set tSC=tDocument.EvaluateExpression("/Request/Body/LisBloodRt/ChargeInfos/ChargeInfo["_j_"]/ChargeCode","text()",.tRes)					
						if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
							set fieldValue=tRes.GetAt(1).Value
							set ChargeCode=$tr(fieldValue,$c(0),"")
							set ChargeCode=$zcvt(ChargeCode,"U")
						}
						set tSC=tDocument.EvaluateExpression("/Request/Body/LisBloodRt/ChargeInfos/ChargeInfo["_j_"]/ChargeCount","text()",.tRes)					
						if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
							set fieldValue=tRes.GetAt(1).Value
							set ChargeCount=$tr(fieldValue,$c(0),"")
						}
						if ((ChargeCode'="")&&(ChargeCount'="")){
							if (AmountInput=""){
								s AmountInput=ChargeCode_"+"_OrdRowIds_"+"_ChargeCount
							}
							else {
								s AmountInput=AmountInput_"###"_ChargeCode_"+"_OrdRowIds_"+"_ChargeCount
							}
						}
					}
				}
			}	
			set tSC=tDocument.EvaluateExpression("/Request/Body/LisBloodRt/UpdateDate","text()",.tRes)					
			if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
				set fieldValue=tRes.GetAt(1).Value
				set UpdateDate=$tr(fieldValue,$c(0),"")
			}

			set tSC=tDocument.EvaluateExpression("/Request/Body/LisBloodRt/UpdateTime","text()",.tRes)					
			if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
				set fieldValue=tRes.GetAt(1).Value
				set UpdateTime=$tr(fieldValue,$c(0),"")
			}
			
			set tSC=tDocument.EvaluateExpression("/Request/Body/LisBloodRt/UpdateUserCode","text()",.tRes)					
			if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
				set fieldValue=tRes.GetAt(1).Value
				set UpdateUserCode=$tr(fieldValue,$c(0),"")
				set ExeUserID=$o(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(UpdateUserCode),""))
				set:ExeUserID'="" UpdateUserDesc=$p($g(^SSU("SSUSR",ExeUserID)),"^",2)
			}
			set OrdRowIdsCount=$l(OrdRowIds,"^")
			set OrdFlag="",ErrorOrd=""
			
			ts
			for iOrd=1:1:OrdRowIdsCount
			{
				set OEORROrderItemID=$p(OrdRowIds,"^",iOrd)
				set tmpInput=OEORROrderItemID_"^"_SpecimenID_"^^"_UpdateUserCode_"@"_UpdateUserDesc_"^"_UpdateDate_"^"_UpdateTime
				
				// 更新检查状态20190621
				set UpdateDateTime=UpdateDate_" "_UpdateTime
				set Position=""
				set Status="BLOOD"
				;set:SourceSystemHer="SYS0006" SourceSystem="LIS"
				set SourceSystem="LIS"
				set jsonstr="[{""OEOrdItemID"":"""_OEORROrderItemID_""","_"""Position"":"""_Position_""","_"""ExamID"":"""_SpecimenID_""","_"""Status"":"""_Status_""","_"""UserID"":"""_UpdateUserCode_""","_"""UserName"":"""_UpdateUserDesc_""","_"""UpDateTime"":"""_UpdateDateTime_""","_"""SourceSystem"":"""_SourceSystem_""""_"}]"
				set jsonStream=##class(%GlobalCharacterStream).%New()
				d jsonStream.Write(jsonstr)
				set tSC=##class(%GlobalCharacterStream).%New()
				set tSC=##class(web.DHCENS.EnsHISService).DHCHisInterface("UpdateSystemStatus",jsonStream)
				set tSCStr=tSC.Read()
				if (tSCStr'["成功")
				{
					set OrdFlag="-1"
					if ErrorOrd=""  set ErrorOrd=OEORROrderItemID_":"_tSCStr
					else  set ErrorOrd=ErrorOrd_"^"_OEORROrderItemID_":"_tSCStr
					q
				}
				else{
					set OrdFlag="0"
				}
			}

		} //for
	} //if
	if (OrdFlag="0"){
		set:AmountInput'="" Result=##class(web.DHCENS.STBLL.LIS.METHOD.LinkLabNoWithOrdRowId).AddTubeOrdItem(AmountInput)
		if ($p(Result,"^",1)=0||(AmountInput=""))
		{
			tc
			set responseBody.ResultCode="0"
			set responseBody.ResultContent="成功"
			set responseBody.OrdItemID=$p(Result,"^",3)
		}
		else
		{
			tro
			set responseBody.ResultCode="-1"
			set responseBody.ResultContent=ErrorOrd_"^"_$p(Result,"^",2)
		}
	}
	else{
		tro
		set responseBody.ResultCode="-1"
		set responseBody.ResultContent=ErrorOrd
	}
	set Response.Respbody=responseBody
	d Response.XMLExportToStream(.stream)
	Quit stream
Exception
	if $TLEVEL>0
	{
	 	tro	
	}
	set stream=##class(%GlobalCharacterStream).%New()
	d stream.Write("-1^"_$ze)
	Quit stream
}

/// w ##class(web.DHCENS.STBLL.RIS.METHOD.RegInfo).ReportVerify()
/// S0028 检验取消采血
ClassMethod LisCancelBlood(inputContent As %GlobalCharacterStream) As %GlobalCharacterStream
{
	set $Ztrap="Exception"
	ts
	set suCount=0,faCount=0,faInfo=""
	set tSC=##class(%XML.XPATH.Document).CreateFromStream(inputContent,.tDocument)
	set Response=##class(web.DHCENS.STBLL.LIS.MODEL.Response).%New()
	set header=##class(web.DHCENS.STBLL.LIS.MODEL.Header).%New()
	set header.MessageID=##class(web.DHCENS.STBLL.UTIL.Common).CreateMessageID(+$h)
	set header.SourceSystem="02"
	set Response.header=header
	set responseBody=##class(web.DHCENS.STBLL.LIS.MODEL.Respbody).%New()
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
		set SpecimenID=""
		set tSC=tDocument.EvaluateExpression("/Request/Body/LisCancelBloodRt/SpecimenID","text()",.tRes)					
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
			set fieldValue=tRes.GetAt(1).Value
			set SpecimenID=$tr(fieldValue,$c(0),"")
		}
		set tSC=tDocument.EvaluateExpression("/Request/Body/LisCancelBloodRt/OEORIOrderItemIDs","count(OEORIOrderItemID)",.tRes)
			if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){
			set hsCount=tRes.GetAt(1).Value
			if hsCount="0" {
				set responseBody.ResultCode="-1"
		        set responseBody.ResultContent="-1^医嘱信息为空"
		        set Response.Respbody=responseBody
		        d Response.XMLExportToStream(.stream)
	            Quit stream	
			}
			s OrdRowIds=""
			for i=1:1:hsCount {
				set (OEORROrderItemID,UpdateUserCode,UpdateUserDesc,UpdateDate,UpdateTime)=""
				;set HosCode="DHSZHYYZY"	
				set tSC=tDocument.EvaluateExpression("/Request/Body/LisCancelBloodRt/OEORIOrderItemIDs/OEORIOrderItemID["_i_"]","text()",.tRes)					
				if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
					set fieldValue=tRes.GetAt(1).Value
					set OEORROrderItemID=$tr(fieldValue,$c(0),"")
					if OrdRowIds'=""{
						set OrdRowIds=OrdRowIds_"^"_OEORROrderItemID
					}
					else {
						set OrdRowIds=OEORROrderItemID
					}
				}
			}
			set tSC=tDocument.EvaluateExpression("/Request/Body/LisCancelBloodRt/UpdateDate","text()",.tRes)					
			if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
				set fieldValue=tRes.GetAt(1).Value
				set UpdateDate=$tr(fieldValue,$c(0),"")
			}

			set tSC=tDocument.EvaluateExpression("/Request/Body/LisCancelBloodRt/UpdateTime","text()",.tRes)					
			if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
				set fieldValue=tRes.GetAt(1).Value
				set UpdateTime=$tr(fieldValue,$c(0),"")
			}
			
			set tSC=tDocument.EvaluateExpression("/Request/Body/LisCancelBloodRt/UpdateUserCode","text()",.tRes)					
			if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
				set fieldValue=tRes.GetAt(1).Value
				set UpdateUserCode=$tr(fieldValue,$c(0),"")
				set ExeUserID=$o(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(UpdateUserCode),""))
				set:ExeUserID'="" UpdateUserDesc=$p($g(^SSU("SSUSR",ExeUserID)),"^",2)
			}
			
			set OrdRowIdsCount=$l(OrdRowIds,"^")
			set OrdFlag="",ErrorOrd=""
		
			for iOrd=1:1:OrdRowIdsCount
			{
				set OEORROrderItemID=$p(OrdRowIds,"^",iOrd)
				set tmpInput=OEORROrderItemID_"^"_SpecimenID_"^^"_UpdateUserCode_"@"_UpdateUserDesc_"^"_UpdateDate_"^"_UpdateTime
				
				// 更新检查状态20190621
				set UpdateDateTime=UpdateDate_" "_UpdateTime
				set Position=""
				set Status="CBLOOD"
				;set:SourceSystemHer="SYS0006" SourceSystem="LIS"
				set SourceSystem="LIS"
				set jsonstr="[{""OEOrdItemID"":"""_OEORROrderItemID_""","_"""Position"":"""_Position_""","_"""ExamID"":"""_SpecimenID_""","_"""Status"":"""_Status_""","_"""UserID"":"""_UpdateUserCode_""","_"""UserName"":"""_UpdateUserDesc_""","_"""UpDateTime"":"""_UpdateDateTime_""","_"""SourceSystem"":"""_SourceSystem_""""_"}]"
				set jsonStream=##class(%GlobalCharacterStream).%New()
				d jsonStream.Write(jsonstr)
				set tSC=##class(%GlobalCharacterStream).%New()
				set tSC=##class(web.DHCENS.EnsHISService).DHCHisInterface("UpdateSystemStatus",jsonStream)
				set tSCStr=tSC.Read()
				if (tSCStr'["成功")
				{
					set OrdFlag="-1"
					if ErrorOrd=""  set ErrorOrd=OEORROrderItemID_":"_tSCStr
					else  set ErrorOrd=ErrorOrd_"^"_OEORROrderItemID_":"_tSCStr
					q
				}
				else{
					set OrdFlag="0"
				}
			}

		} //for
	} //if
	if (OrdFlag="0"){
		tc
		set responseBody.ResultCode="0"
		set responseBody.ResultContent="成功"
	}
	else{
		tro
		set responseBody.ResultCode="-1"
		set responseBody.ResultContent=ErrorOrd
	}
	set Response.Respbody=responseBody
	d Response.XMLExportToStream(.stream)
	Quit stream
Exception
	if $TLEVEL>0
	{
	 	tro	
	}
	set stream=##class(%GlobalCharacterStream).%New()
	d stream.Write("-1^"_$ze)
	Quit stream
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

}
