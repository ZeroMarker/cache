Class web.DHCENS.STBLL.RIS.METHOD.RisCriticalValues Extends (%RegisteredObject, %XML.Adaptor)
{

/// Creator：lipan
/// CreatDate：2016—06-24
/// Description：保存危机值
/// Table：DHC_AntCVReport
/// Input：危急值入参xml
/// Return：
/// Others: 
/// w ##class(web.DHCENS.STBLL.RIS.METHOD.RisCriticalValues).SaveCriticalValues()
ClassMethod SaveCriticalValues(Input As %GlobalCharacterStream) As %GlobalCharacterStream
{
	set $zt="Exception"
	set tSC=##class(%XML.XPATH.Document).CreateFromStream(Input,.tDocument)
	d Input.Rewind()
	s ResultCode="-1",ResultContent="失败"
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
		s (PATPatientID,PAADMVisitNumber,RISRExamID,RISRReportDocCode,RISRFinalCheckDate,RISRFinalCheckTime,RISPCriticalValueDetail,UpdateDate,UpdateTime,UpdateUserCode)=""
		set tSC=tDocument.EvaluateExpression("/Request/Body/ReCriticalValuesRt/PATPatientID","text()",.tRes)					
		b ;tsc
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
			set fieldValue=tRes.GetAt(1).Value
			set PATPatientID=$tr(fieldValue,$c(0),"")
		}
		set tSC=tDocument.EvaluateExpression("/Request/Body/ReCriticalValuesRt/PAADMVisitNumber","text()",.tRes)					
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
			set fieldValue=tRes.GetAt(1).Value
			set PAADMVisitNumber=$tr(fieldValue,$c(0),"")
		}
		set tSC=tDocument.EvaluateExpression("/Request/Body/ReCriticalValuesRt/RISRExamID","text()",.tRes)					
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
			set fieldValue=tRes.GetAt(1).Value
			set RISRExamID=$tr(fieldValue,$c(0),"")
		}
		set tSC=tDocument.EvaluateExpression("/Request/Body/ReCriticalValuesRt/RISRReportDocCode","text()",.tRes)					
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
			set fieldValue=tRes.GetAt(1).Value
			set RISRReportDocCode=$tr(fieldValue,$c(0),"")
		}
		set tSC=tDocument.EvaluateExpression("/Request/Body/ReCriticalValuesRt/RISRFinalCheckDate","text()",.tRes)					
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
			set fieldValue=tRes.GetAt(1).Value
			set RISRFinalCheckDate=$tr(fieldValue,$c(0),"")
		}	
		set tSC=tDocument.EvaluateExpression("/Request/Body/ReCriticalValuesRt/RISRFinalCheckTime","text()",.tRes)					
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
			set fieldValue=tRes.GetAt(1).Value
			set RISRFinalCheckTime=$tr(fieldValue,$c(0),"")
		}
		set tSC=tDocument.EvaluateExpression("/Request/Body/ReCriticalValuesRt/RISPCriticalValueDetail","text()",.tRes)					
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
			set fieldValue=tRes.GetAt(1).Value
			set RISPCriticalValueDetail=$tr(fieldValue,$c(0),"")
		}
		set tSC=tDocument.EvaluateExpression("/Request/Body/ReCriticalValuesRt/UpdateUserCode","text()",.tRes)					
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
			set fieldValue=tRes.GetAt(1).Value
			set UpdateUserCode=$tr(fieldValue,$c(0),"")
		}
		set UpdateUserId=""
		set:UpdateUserCode'="" UpdateUserId=$o(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(UpdateUserCode),""))
		if (UpdateUserId=""){
			set ResultCode="-1"
			set ResultContent="人员代码错误!!!"
			s responseBody.ResultCode=ResultCode
			s responseBody.ResultContent=ResultContent
			s Response.body=responseBody
		    d Response.XMLExportToStream(.stream)
    		q stream
		}

		set tSC=tDocument.EvaluateExpression("/Request/Body/ReCriticalValuesRt/UpdateDate","text()",.tRes)					
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
			set fieldValue=tRes.GetAt(1).Value
			set UpdateDate=$tr(fieldValue,$c(0),"")
		}
		set tSC=tDocument.EvaluateExpression("/Request/Body/ReCriticalValuesRt/UpdateTime","text()",.tRes)					
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
			set fieldValue=tRes.GetAt(1).Value
			set UpdateTime=$tr(fieldValue,$c(0),"")
		}	
		set tSC=tDocument.EvaluateExpression("/Request/Body/ReCriticalValuesRt/OEORIOrderItemIDList","count(OEORIOrderItemID)",.tRes)
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){
			set hsCount=tRes.GetAt(1).Value
			Quit:hsCount="0" "-1^信息为空"
			set (OEORIOrderItemID,ReportType)=""
			for i=1:1:hsCount {
				set tSC=tDocument.EvaluateExpression("/Request/Body/ReCriticalValuesRt/OEORIOrderItemIDList/OEORIOrderItemID["_i_"]","text()",.tRes)					
				if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
					set fieldValue=tRes.GetAt(1).Value
					set OEORIOrderItemID=$tr(fieldValue,$c(0),"")
				}
				set tSC=tDocument.EvaluateExpression("/Request/Body/ReCriticalValuesRt/OEORIOrderItemIDList/ReportType["_i_"]","text()",.tRes)					
				if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
					set fieldValue=tRes.GetAt(1).Value
					set ReportType=$tr(fieldValue,$c(0),"")
				}
				;(PATPatientID,PAADMVisitNumber,RISRExamID,RISRReportDocCode,RISRFinalCheckDate,RISRFinalCheckTime,RISPCriticalValueDetail,UpdateDate,UpdateTime,UpdateUserCode)=""

				set ReportInfo=UpdateDate_"^"_UpdateTime_"^"_UpdateUserId_"^"
								
				s return= ##Class(web.DHCAntService).SaveCVResult(ReportType,RISRExamID,PAADMVisitNumber,OEORIOrderItemID,ReportInfo,RISPCriticalValueDetail)
				if $p(return,"^")=0
				{
					s ResultCode=0
					s ResultContent="成功"
				}
				else{
					s ResultCode=$p(return,"^",1)
					s ResultContent="失败,"_$p(return,"^",2)
				}
			}
			s responseBody.ResultCode=ResultCode
			s responseBody.ResultContent=ResultContent
			set Response.Respbody=responseBody
		}  //if
	}   //else
    
    d Response.XMLExportToStream(.stream)
    q stream
    
Exception
	set stream=##class(%GlobalCharacterStream).%New()
	d stream.Write("-1^"_$ze)
	Quit stream
}

/// Debug:w ##class(web.DHCENS.STBLL.RIS.METHOD.RisCriticalValues).test()
ClassMethod test() As %String
{
	s Input="<Request><Header><SourceSystem>PACS</SourceSystem><MessageID>20190225144910038</MessageID></Header><Body><ReCriticalValuesRt><PATPatientID>0000000881</PATPatientID><PAADMVisitNumber>1439</PAADMVisitNumber><RISRExamID>US1900564</RISRExamID><OEORIOrderItemIDs><OEORIOrderItemID>1416||7</OEORIOrderItemID><ReportType></ReportType></OEORIOrderItemIDs><RISRReportDocCode>3600</RISRReportDocCode><RISRFinalCheckDate>2019-02-25</RISRFinalCheckDate><RISRFinalCheckTime>14:45:27</RISRFinalCheckTime><RISPCriticalValueDetail>123</RISPCriticalValueDetail><UpdateUserCode>3600</UpdateUserCode><UpdateDate>2019-02-25</UpdateDate><UpdateTime>14:45:27</UpdateTime></ReCriticalValuesRt></Body></Request>"
	s stream=##class(%GlobalCharacterStream).%New()
	d stream.Write(Input)
	
	s xx=..SaveCriticalValues(stream)
	q xx.Read()
}

/// Creator：ZhangXinying
/// CreatDate：2021-12-01
/// Description:检查危机值查看状态
/// Debug:w ##class(web.DHCENS.STBLL.RIS.METHOD.RisCriticalValues).SendRISCriValueStatus("3||APPI2019080800004||1,2,18").Read()
ClassMethod SendRISCriValueStatus(input As %String) As %GlobalCharacterStream
{
	set $zt = "Exception"
	set request=##class(web.DHCENS.STBLL.RIS.MODEL.Request).%New()
	
	set header=##class(web.DHCENS.STBLL.RIS.MODEL.Header).%New()
	set header.SourceSystem="02"
	set header.MessageID=##class(web.DHCENS.STBLL.UTIL.Common).CreateMessageID(+$h)
	set request.header=header
	set body=##class(web.DHCENS.STBLL.RIS.MODEL.Body).%New()
    set objList = ##class(web.DHCENS.STBLL.RIS.MODEL.ReCriticalValuesRt).%New()
    set reportid=$p(input,",",1)
    set ReportType=$p($p(input,","),"||")
    set SpecimenID=$p($p(input,","),"||",2)
    set content=$p(input,",",2)
    set admno=$p(input,",",3)
    
    if (content'="2") {
	    s stream=##class(%GlobalCharacterStream).%New()
	    d stream.Write("-1^此消息不是危急值反馈确认消息")
	    q stream
    }
    //^DHCAntCVReport({DHC_AntCVReport.DPRP_Type},{DHC_AntCVReport.DPRP_LabNo},{DHC_AntCVReport.DPRP_Order},"TR",{DPRT_Order})
    s dprtOrder=$o(^DHCAntCVReport(ReportType,SpecimenID,$p(reportid,"||",3),"TR",""),-1)
    
    //-------分割线-------//取从危急值表收到第三方的标识 2018-06-09    haochenguang
    ;s objList.FreNum=$p($g(^DHCAntCVReport(ReportType,SpecimenID,dprtOrder)),"\",19)
    //-------分割线-------//
    s tmpstr=""
    s:dprtOrder'="" tmpstr=$g(^DHCAntCVReport(ReportType,SpecimenID,$p(reportid,"||",3),"TR",dprtOrder))
    s patRowId=$p($g(^PAADM(admno)),"^",1)
    ;s objList.CriticalValueId=CriticalValueId
	s objList.PATPatientID=$p($g(^PAPER(patRowId,"PAT",1)),"^",1)
    s objList.PAADMVisitNumber=admno
    s objList.SpecimenID=SpecimenID
    s:tmpstr'="" objList.CheckDate=$zd($p(tmpstr,"\",1),3)
    s:tmpstr'="" objList.CheckTime=$zt($p(tmpstr,"\",2))
    s CheckPerRowid=$p(tmpstr,"\",3)
    //s:CheckPerRowid'="" objList.CheckPerson=$p($g(^SSU("SSUSR",CheckPerRowid)),"^",1)
    if CheckPerRowid'="" {
		set UpdateUserId=$o(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(CheckPerRowid),""))
		set:UpdateUserId'="" objList.CheckPersonCode=$p($g(^SSU("SSUSR",UpdateUserId)),"^",1)
		set:UpdateUserId'="" objList.CheckPerson=$p($g(^SSU("SSUSR",UpdateUserId)),"^",2)
    }
    s:CheckPerRowid="" objList.CheckPerson="demo"
    s objList.Telephone=$p(tmpstr,"\",6)
    s objList.Remark=$p(tmpstr,"\",7)
    s objList.Advice=$p(tmpstr,"\",9)
    s objList.UpdateUserCode="demo"
    s objList.UpdateDate=$zd(+$h,3)
    s objList.UpdateTime=$zt($p($h,",",2))
    s objList.ContactPerson=$p(tmpstr,"\",5)
    s body.CriticalValueList=objList
    s request.body=body
    d request.XMLExportToStream(.stream)
    q stream
    
Exception
    s stream=##class(%GlobalCharacterStream).%New()
    d stream.Write("-1^"_$ze)
	Quit stream
}

}
