Class web.DHCENS.STBLL.LIS.METHOD.LisCriticalValues Extends (%RegisteredObject, %XML.Adaptor)
{

/// Creator：lipan
/// CreatDate：2016—06-24
/// Description：保存危机值
/// Table：
/// Input：
/// Return：
/// Others: 
/// w ##class(web.DHCENS.STBLL.LIS.METHOD.LisCriticalValues).SaveCriticalValues()
ClassMethod SaveCriticalValues(Input As %GlobalCharacterStream) As %GlobalCharacterStream
{
	set $zt="Exception"
	set tSC=##class(%XML.XPATH.Document).CreateFromStream(Input,.tDocument)
	d Input.Rewind()
	s ResultCode="-1",ResultContent="失败"
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
		s (PAADMVisitNumber,OEORIOrderItemID,UpdateDate,UpdateTime,UpdateUserCode)=""
		set tSC=tDocument.EvaluateExpression("/Request/Body/LisCriticalValuesRt/PAADMVisitNumber","text()",.tRes)					
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
			set fieldValue=tRes.GetAt(1).Value
			set PAADMVisitNumber=$tr(fieldValue,$c(0),"")
		}
		set tSC=tDocument.EvaluateExpression("/Request/Body/LisCriticalValuesRt/OEORIOrderItemID","text()",.tRes)					
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
			set fieldValue=tRes.GetAt(1).Value
			set OEORIOrderItemID=$tr(fieldValue,$c(0),"")
		}
		set tSC=tDocument.EvaluateExpression("/Request/Body/LisCriticalValuesRt/UpdateDate","text()",.tRes)					
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
			set fieldValue=tRes.GetAt(1).Value
			set UpdateDate=$tr(fieldValue,$c(0),"")
		}
		set tSC=tDocument.EvaluateExpression("/Request/Body/LisCriticalValuesRt/UpdateTime","text()",.tRes)					
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
			set fieldValue=tRes.GetAt(1).Value
			set UpdateTime=$tr(fieldValue,$c(0),"")
		}
		set tSC=tDocument.EvaluateExpression("/Request/Body/LisCriticalValuesRt/UpdateUserCode","text()",.tRes)					
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
			set fieldValue=tRes.GetAt(1).Value
			set UpdateUserCode=$tr(fieldValue,$c(0),"")
		}	
			
		set tSC=tDocument.EvaluateExpression("/Request/Body/LisCriticalValuesRt/CriReports","count(ResultMsg)",.tRes)
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){
			set hsCount=tRes.GetAt(1).Value
			Quit:hsCount="0" "-1^信息为空"
			set (LabNo,TestCode,TestName,Result,Ranges,ResultFlag,CriticalValueId)=""
			for i=1:1:hsCount {
				set tSC=tDocument.EvaluateExpression("/Request/Body/LisCriticalValuesRt/SpecimenID","text()",.tRes)					
				if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){	
					set fieldValue=tRes.GetAt(1).Value
					set LabNo=$tr(fieldValue,$c(0),"")
				}
				set tSC=tDocument.EvaluateExpression("/Request/Body/LisCriticalValuesRt/CriticalValueId","text()",.tRes)					
				if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){	
					set fieldValue=tRes.GetAt(1).Value
					set CriticalValueId=$tr(fieldValue,$c(0),"")
				}
				set tSC=tDocument.EvaluateExpression("/Request/Body/LisCriticalValuesRt/CriReports/ResultMsg["_i_"]/TestCode","text()",.tRes)					
				if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
					set fieldValue=tRes.GetAt(1).Value
					set TestCode=$tr(fieldValue,$c(0),"")
				}
				set tSC=tDocument.EvaluateExpression("/Request/Body/LisCriticalValuesRt/CriReports/ResultMsg["_i_"]/TestName","text()",.tRes)					
				if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
					set fieldValue=tRes.GetAt(1).Value
					set TestName=$tr(fieldValue,$c(0),"")
				}
				set tSC=tDocument.EvaluateExpression("/Request/Body/LisCriticalValuesRt/CriReports/ResultMsg["_i_"]/Result","text()",.tRes)					
				if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
					set fieldValue=tRes.GetAt(1).Value
					set Result=$tr(fieldValue,$c(0),"")
				}
				set tSC=tDocument.EvaluateExpression("/Request/Body/LisCriticalValuesRt/CriReports/ResultMsg["_i_"]/Ranges","text()",.tRes)					
				if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
					set fieldValue=tRes.GetAt(1).Value
					set Ranges=$tr(fieldValue,$c(0),"")
				}
				set tSC=tDocument.EvaluateExpression("/Request/Body/LisCriticalValuesRt/CriReports/ResultMsg["_i_"]/ResultFlag","text()",.tRes)					
				if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
					set fieldValue=tRes.GetAt(1).Value
					set ResultFlag=$tr(fieldValue,$c(0),"")
				}
				set UpdateUserId=""
				set:UpdateUserCode'="" UpdateUserId=$o(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(UpdateUserCode),""))
				if (UpdateUserId=""){
					set ResultCode="-1"
					set ResultContent="人员代码错误!!!"
					q
				}
				set ReportInfo=UpdateDate_"^"_UpdateTime_"^"_UpdateUserId_"^"
				set CriticalContent="项目代码:"_TestCode_" 项目名称:"_TestName_" 结果:"_Result_" 参考范围:"_Ranges_" 结果异常标示:"_ResultFlag
				
				s return= ##Class(web.DHCAntService).SaveCVResult(1,LabNo,PAADMVisitNumber,OEORIOrderItemID,ReportInfo,CriticalContent,CriticalValueId)
				if $p(return,"^")=0
				{
					s ResultCode=0
					s ResultContent="成功"
				}
				else{
					s ResultCode="-1"
					s ResultContent="失败"
				}
			}
			s responseBody.ResultCode=ResultCode
			s responseBody.ResultContent=ResultContent
			s Response.Respbody=responseBody
		}  //if
	}   //else
    
    d Response.XMLExportToStream(.stream)
    q stream
    
Exception
	set stream=##class(%GlobalCharacterStream).%New()
	d stream.Write("-1^"_$ze)
	Quit stream
}

/// Creator：lipan
/// CreatDate：2016—06-26
/// Description:检验危机值查看状态
/// w ##class(web.DHCENS.STBLL.LIS.METHOD.LisCriticalValues).SendCriValueStatus()
ClassMethod SendCriValueStatus(input As %String) As %GlobalCharacterStream
{
	set $zt = "Exception"
	set request=##class(web.DHCENS.STBLL.LIS.MODEL.Request).%New()
	set header=##class(web.DHCENS.STBLL.LIS.MODEL.Header).%New()
	set header.SourceSystem="02"
	set header.MessageID=##class(web.DHCENS.STBLL.UTIL.Common).CreateMessageID(+$h)
	set request.header=header
	set body=##class(web.DHCENS.STBLL.LIS.MODEL.Body).%New()
    set objList = ##class(web.DHCENS.STBLL.LIS.MODEL.CriticalValueInfo).%New()
    set reportid=$p(input,",",1)
    set ReportType=$p($p(input,","),"||")
    set SpecimenID=$p($p(input,","),"||",2)
   	set content=$p(input,",",2)
    set admno=$p(input,",",3)
   	if ((ReportType'="1")||(content'="2")) {
	    s stream=##class(%GlobalCharacterStream).%New()
	    d stream.Write("-1^不符合检验危急值条件")
	    q stream
    }
    //^DHCAntCVReport({DHC_AntCVReport.DPRP_Type},{DHC_AntCVReport.DPRP_LabNo},{DHC_AntCVReport.DPRP_Order},"TR",{DPRT_Order})
   	s dprtOrder=$o(^DHCAntCVReport(ReportType,SpecimenID,$p(reportid,"||",3),"TR",""),-1)
    s tmpstr=$g(^DHCAntCVReport(ReportType,SpecimenID,$p(reportid,"||",3),"TR",dprtOrder))
    s patRowId=$p($g(^PAADM(admno)),"^",1)
    s CriticalValueId=reportid
    s objList.CriticalValueId=CriticalValueId
    s objList.PATPatientID=$p($g(^PAPER(patRowId,"PAT",1)),"^",1)
    s objList.PAADMVisitNumber=admno
    s objList.SpecimenID=SpecimenID
    s objList.CheckDate=$zd($p(tmpstr,"\",1),3)
    s objList.CheckTime=$zt($p($h,",",2))
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
    s objList.UpdateUserCode="demo"
    s objList.UpdateDate=$zd(+$h,3)
    s objList.UpdateTime=$zt($p($h,",",2))
    s objList.CriticalValueId=$p($g(^DHCAntCVReport(ReportType,SpecimenID,$p(reportid,"||",3))),"\",16) //检验危急值保存时传过来的唯一标识，DPRP_LisExamRowid
    s body.CriticalValueList=objList
    s request.body=body
    d request.XMLExportToStream(.stream)
    
    q stream  
Exception
	s stream=##class(%GlobalCharacterStream).%New()
    d stream.Write("-1^"_$ze)
    Quit stream
}

/// w ##class(web.DHCENS.STBLL.LIS.METHOD.LisCriticalValues).test()
ClassMethod test() As %String
{
	s Input="<Request><Header><SourceSystem>LIS</SourceSystem><MessageID>81682A12-595B-11EC-912A-005056BD6915</MessageID></Header><Body><LisCriticalValuesRt><OEORIOrderItemID>3895||371</OEORIOrderItemID><SpecimenID>0000002254</SpecimenID><ReportNumber></ReportNumber><CriticalDate>2021-12-09</CriticalDate><CriticalTime>15:29:59</CriticalTime><ReportUserCode>YS01</ReportUserCode><ReportUserDesc>YS01</ReportUserDesc><CheckDate>2021-12-09</CheckDate><CheckTime>15:30:13</CheckTime><CheckUser>YS01</CheckUser><CheckUserCode>YS01</CheckUserCode><PAADMVisitNumber>4216</PAADMVisitNumber><MainWarnDesc>1</MainWarnDesc><Status></Status><CtLocDesc>临检室</CtLocDesc><CtTelephone></CtTelephone><Notes>结果已复核</Notes><SendDate>2021-12-09</SendDate><SendTime>15:20:11</SendTime><CriticalValueId>3</CriticalValueId><CriReports><ResultMsg><LabNo>0000002254</LabNo><TestCode>L0039</TestCode><TestName>白细胞</TestName><TestEngName>WBC</TestEngName><Result>65.00</Result><Units></Units><ResultFlag>PH</ResultFlag><Ranges>4-10</Ranges><Machine></Machine><Notes></Notes><Sequence></Sequence></ResultMsg><ResultMsg><LabNo>0000002254</LabNo><TestCode>L0063</TestCode><TestName>血小板</TestName><TestEngName>PLT</TestEngName><Result>6.00</Result><Units>*10^9/L</Units><ResultFlag>PL</ResultFlag><Ranges>100-300</Ranges><Machine></Machine><Notes></Notes><Sequence></Sequence></ResultMsg></CriReports><UpdateUserCode>1496</UpdateUserCode><UpdateDate>2021-12-10</UpdateDate><UpdateTime>09:50:12</UpdateTime></LisCriticalValuesRt></Body></Request>"
	s stream=##class(%GlobalCharacterStream).%New()
	d stream.Write(Input)
	
	s xx=..SaveCriticalValues(stream)
	q xx.Read()
}

}
