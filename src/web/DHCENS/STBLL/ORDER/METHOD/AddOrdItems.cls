Class web.DHCENS.STBLL.ORDER.METHOD.AddOrdItems Extends (%RegisteredObject, %XML.Adaptor)
{

/// Creator：lipan
/// CreatDate：2016—06-20
/// Description：获取医嘱信息
/// Table：
/// Input：
/// Return：医嘱信息集合
/// Others: 
/// w ##class(web.DHCENS.STBLL.ORDER.METHOD.AddOrdItems).AddOEOrder("")
ClassMethod AddOEOrderOld(Input As %GlobalCharacterStream) As %GlobalCharacterStream
{
	set $zt="Exception"
	set suCount=0,faCount=0,faInfo=""
	set tSC=##class(%XML.XPATH.Document).CreateFromStream(Input,.tDocument)
	set Response=##class(web.DHCENS.STBLL.ORDER.MODEL.Response).%New()
	
	set header=##class(web.DHCENS.STBLL.ORDER.MODEL.Header).%New()
	set header.SourceSystem="02"
	set header.MessageID=##class(web.DHCENS.STBLL.UTIL.Common).CreateMessageID(+$h)
	set Response.header=header
	set responseBody=##class(web.DHCENS.STBLL.ORDER.MODEL.Respbody).%New()
	
	
	if $$$ISERR(tSC) {
		set responseBody.ResultCode="-1"
		set responseBody.ResultContent=tSC
		set Response.Respbody=responseBody
	}else{
		set tSC=tDocument.EvaluateExpression("/Request/Body/AddOrdersRt/OEORIInfos","count(OEORIInfo)",.tRes)
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){
			set hsCount=tRes.GetAt(1).Value
			Quit:hsCount="0" "-1^信息为空"
			for i=1:1:hsCount {
				set respBody=##class(web.DHCENS.STBLL.ORDER.MODEL.Respbody).%New()
				
				set (PAADMVisitNumber,ThirdOEORIOrderItemID,OEORIPriorityCode,OEORIARCItmMastCode,OEORIOrderQty,OEORIFreqCode,OEORIDoseUnitCode)=""
				set (OEORIDoseForms,OEORIEnterDeptCode,OEORIExecDeptCode,OEORIEnterDocCode,OEORIRequireExecDate,OEORIRequireExecTime,OEORIRemarks,SourceSystem)=""
				set (OEORIEnterDate,OEORIEnterTime,OEORIOEORIDR)=""
				set HosCode="DHSZHYYZY"	
				set tSC=tDocument.EvaluateExpression("/Request/Body/AddOrdersRt/PAADMVisitNumber","text()",.tRes)					
				if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){	
					set fieldValue=tRes.GetAt(1).Value
					set PAADMVisitNumber=$tr(fieldValue,$c(0),"")
				}
				set tSC=tDocument.EvaluateExpression("/Request/Body/AddOrdersRt/OEORIInfos/OEORIInfo["_i_"]/ThirdOEORIOrderItemID","text()",.tRes)					
				if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){	
					set fieldValue=tRes.GetAt(1).Value
					set ThirdOEORIOrderItemID=$tr(fieldValue,$c(0),"")
				}
				set tSC=tDocument.EvaluateExpression("/Request/Body/AddOrdersRt/OEORIInfos/OEORIInfo["_i_"]/OEORIPriorityCode","text()",.tRes)					
				if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){	
					set fieldValue=tRes.GetAt(1).Value
					set OEORIPriorityCode=$tr(fieldValue,$c(0),"")
				}
				
				set tSC=tDocument.EvaluateExpression("/Request/Body/AddOrdersRt/OEORIInfos/OEORIInfo["_i_"]/OEORIARCItmMastCode","text()",.tRes)					
				if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){	
					set fieldValue=tRes.GetAt(1).Value
					set OEORIARCItmMastCode=$tr(fieldValue,$c(0),"")
				}
				
				set tSC=tDocument.EvaluateExpression("/Request/Body/AddOrdersRt/OEORIInfos/OEORIInfo["_i_"]/OEORIOrderQty","text()",.tRes)					
				if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){	
					set fieldValue=tRes.GetAt(1).Value
					set OEORIOrderQty=$tr(fieldValue,$c(0),"")
				}
				
				set tSC=tDocument.EvaluateExpression("/Request/Body/AddOrdersRt/OEORIInfos/OEORIInfo["_i_"]/OEORIFreqCode","text()",.tRes)					
				if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){	
					set fieldValue=tRes.GetAt(1).Value
					set OEORIFreqCode=$tr(fieldValue,$c(0),"")
				}
				
				set tSC=tDocument.EvaluateExpression("/Request/Body/AddOrdersRt/OEORIInfos/OEORIInfo["_i_"]/OEORIDoseUnitCode","text()",.tRes)					
				if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){	
					set fieldValue=tRes.GetAt(1).Value
					set OEORIDoseUnitCode=$tr(fieldValue,$c(0),"")
				}
				set tSC=tDocument.EvaluateExpression("/Request/Body/AddOrdersRt/OEORIInfos/OEORIInfo["_i_"]/OEORIDoseForms","text()",.tRes)					
				if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){	
					set fieldValue=tRes.GetAt(1).Value
					set OEORIDoseForms=$tr(fieldValue,$c(0),"")
				}
				set tSC=tDocument.EvaluateExpression("/Request/Body/AddOrdersRt/OEORIInfos/OEORIInfo["_i_"]/OEORIEnterDeptCode","text()",.tRes)					
				if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){	
					set fieldValue=tRes.GetAt(1).Value
					set OEORIEnterDeptCode=$tr(fieldValue,$c(0),"")
				}
				set tSC=tDocument.EvaluateExpression("/Request/Body/AddOrdersRt/OEORIInfos/OEORIInfo["_i_"]/OEORIExecDeptCode","text()",.tRes)					
				if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){	
					set fieldValue=tRes.GetAt(1).Value
					set OEORIExecDeptCode=$tr(fieldValue,$c(0),"")
				}
				
				set tSC=tDocument.EvaluateExpression("/Request/Body/AddOrdersRt/OEORIInfos/OEORIInfo["_i_"]/OEORIEnterDocCode","text()",.tRes)					
				if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){	
					set fieldValue=tRes.GetAt(1).Value
					set OEORIEnterDocCode=$tr(fieldValue,$c(0),"")
				}
				set tSC=tDocument.EvaluateExpression("/Request/Body/AddOrdersRt/OEORIInfos/OEORIInfo["_i_"]/OEORIRequireExecDate","text()",.tRes)					
				if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){	
					set fieldValue=tRes.GetAt(1).Value
					set OEORIRequireExecDate=$tr(fieldValue,$c(0),"")
				}
				set tSC=tDocument.EvaluateExpression("/Request/Body/AddOrdersRt/OEORIInfos/OEORIInfo["_i_"]/OEORIRequireExecTime","text()",.tRes)					
				if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){	
					set fieldValue=tRes.GetAt(1).Value
					set OEORIRequireExecTime=$tr(fieldValue,$c(0),"")
				}
				set tSC=tDocument.EvaluateExpression("/Request/Body/AddOrdersRt/OEORIInfos/OEORIInfo["_i_"]/OEORIRemarks","text()",.tRes)					
				if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){	
					set fieldValue=tRes.GetAt(1).Value
					set OEORIRemarks=$tr(fieldValue,$c(0),"")
				}
				set tSC=tDocument.EvaluateExpression("/Request/Header/SourceSystem","text()",.tRes)					
				if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){	
					set fieldValue=tRes.GetAt(1).Value
					set SourceSystem=$tr(fieldValue,$c(0),"")
				}
				set tSC=tDocument.EvaluateExpression("/Request/Body/AddOrdersRt/OEORIInfos/OEORIInfo["_i_"]/OEORIOEORIDR","text()",.tRes)					
				if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){	
					set fieldValue=tRes.GetAt(1).Value
					set OEORIOEORIDR=$tr(fieldValue,$c(0),"")
				}
				set tSC=tDocument.EvaluateExpression("/Request/Body/AddOrdersRt/OEORIInfos/OEORIInfo["_i_"]/OEORIEnterDate","text()",.tRes)					
				if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){	
					set fieldValue=tRes.GetAt(1).Value
					set OEORIEnterDate=$tr(fieldValue,$c(0),"")
				}
				set tSC=tDocument.EvaluateExpression("/Request/Body/AddOrdersRt/OEORIInfos/OEORIInfo["_i_"]/OEORIEnterTime","text()",.tRes)					
				if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){	
					set fieldValue=tRes.GetAt(1).Value
					set OEORIEnterTime=$tr(fieldValue,$c(0),"")
				}
				set InputStr=PAADMVisitNumber_"^"_ThirdOEORIOrderItemID_"^"_OEORIPriorityCode_"^"_OEORIARCItmMastCode_"^"_""      //1-5
				set InputStr=InputStr_"^"_OEORIOrderQty _"^"_OEORIFreqCode_"^"_OEORIDoseUnitCode_"^"_OEORIDoseForms_"^"_""   //6-10
				set InputStr=InputStr_"^"_OEORIEnterDeptCode_"^"_OEORIExecDeptCode_"^"_OEORIEnterDocCode_"^"_"dhcdemo"_"^"_OEORIRequireExecDate     //11-15
				set InputStr=InputStr_"^"_OEORIRequireExecTime_"^"_""_"^"_SourceSystem_"^"_""_"^"_OEORIRemarks    //18-20
				set InputStr=InputStr_"^"_OEORIOEORIDR_"^"_OEORIEnterDate_"^"_OEORIEnterTime
				set respBody=..AddOrderItems(InputStr)
			} 
			s Response.Respbody=respBody
		}  
		
		d Response.XMLExportToStream(.stream)
		q stream
	}
	
Exception
	set stream=##class(%GlobalCharacterStream).%New()
	d stream.Write("-1^"_$ze)
	Quit stream
}

/// Creator：chenjiang
/// CreatDate：2016-07-22
/// Description：获取医嘱信息
/// Table：
/// Input：
/// Return：医嘱信息集合
/// Others: 
/// w ##class(web.DHCENS.STBLL.ORDER.METHOD.AddOrdItems).AddOEOrder("")
ClassMethod AddOEOrder(Input As %GlobalCharacterStream) As %GlobalCharacterStream
{
	set $zt="Exception"
	set suCount=0,faCount=0,faInfo=""
	set tSC=##class(%XML.XPATH.Document).CreateFromStream(Input,.tDocument)
	set Response=##class(web.DHCENS.STBLL.ORDER.MODEL.Response).%New()
	
	set header=##class(web.DHCENS.STBLL.ORDER.MODEL.Header).%New()
	set header.SourceSystem="02"
	set header.MessageID=##class(web.DHCENS.STBLL.UTIL.Common).CreateMessageID(+$h)
	set Response.header=header
	set responseBody=##class(web.DHCENS.STBLL.ORDER.MODEL.Respbody).%New()
	
	
	if $$$ISERR(tSC) {
		set responseBody.ResultCode="-1"
		set responseBody.ResultContent=tSC
		set Response.Respbody=responseBody
	}
	else{
		set PAADMVisitNumber=""
		set tSC=tDocument.EvaluateExpression("/Request/Body/AddOrdersRt/PAADMVisitNumber","text()",.tRes)					
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){	
			set fieldValue=tRes.GetAt(1).Value
			set PAADMVisitNumber=$tr(fieldValue,$c(0),"")
		}
		set IsFlag=..IsHaveDiagose(PAADMVisitNumber)
		if 'IsFlag{
			set responseBody.ResultCode="-1"
			set responseBody.ResultContent="诊断不存在!!!"
			set Response.Respbody=responseBody
			d Response.XMLExportToStream(.stream)
		    q stream		
		}
		
		set tSC=tDocument.EvaluateExpression("/Request/Body/AddOrdersRt/OEORIInfos","count(OEORIInfo)",.tRes)
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){
			set hsCount=tRes.GetAt(1).Value
			Quit:hsCount="0" "-1^信息为空"
			s MainInputStr=""
			for i=1:1:hsCount {
				set respBody=##class(web.DHCENS.STBLL.ORDER.MODEL.Respbody).%New()
				
				set (ThirdOEORIOrderItemID,OEORIPriorityCode,OEORIARCItmMastCode,OEORIOrderQty,OEORIFreqCode,OEORIDoseUnitCode)=""
				set (OEORIDoseForms,OEORIEnterDeptCode,OEORIExecDeptCode,OEORIEnterDocCode,OEORIRequireExecDate,OEORIRequireExecTime,OEORIRemarks,SourceSystem)=""
				set (OEORIEnterDate,OEORIEnterTime,OEORIOEORIDR,OEORISpecimenCode,OEORIDoseQty,OEORIInstrCode,OEORIDurationCode,OEORIQtyPackUOM)=""
				set HosCode="DHSZHYYZY"	
				set tSC=tDocument.EvaluateExpression("/Request/Body/AddOrdersRt/OEORIInfos/OEORIInfo["_i_"]/OEORIOrderItemID","text()",.tRes)					
				if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){	
					set fieldValue=tRes.GetAt(1).Value
					set ThirdOEORIOrderItemID=$tr(fieldValue,$c(0),"")
				}
				set tSC=tDocument.EvaluateExpression("/Request/Body/AddOrdersRt/OEORIInfos/OEORIInfo["_i_"]/ThirdOEORIOrderItemID","text()",.tRes)					
				if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){	
					set fieldValue=tRes.GetAt(1).Value
					set ThirdOEORIOrderItemID=$tr(fieldValue,$c(0),"")
				}
				set tSC=tDocument.EvaluateExpression("/Request/Body/AddOrdersRt/OEORIInfos/OEORIInfo["_i_"]/OEORIPriorityCode","text()",.tRes)					
				if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){	
					set fieldValue=tRes.GetAt(1).Value
					set OEORIPriorityCode=$tr(fieldValue,$c(0),"")
				}
				
				set tSC=tDocument.EvaluateExpression("/Request/Body/AddOrdersRt/OEORIInfos/OEORIInfo["_i_"]/OEORIARCItmMastCode","text()",.tRes)					
				if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){	
					set fieldValue=tRes.GetAt(1).Value
					set OEORIARCItmMastCode=$tr(fieldValue,$c(0),"")
				}
				
				set tSC=tDocument.EvaluateExpression("/Request/Body/AddOrdersRt/OEORIInfos/OEORIInfo["_i_"]/OEORIOrderQty","text()",.tRes)					
				if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){	
					set fieldValue=tRes.GetAt(1).Value
					set OEORIOrderQty=$tr(fieldValue,$c(0),"")
				}
				
				set tSC=tDocument.EvaluateExpression("/Request/Body/AddOrdersRt/OEORIInfos/OEORIInfo["_i_"]/OEORIFreqCode","text()",.tRes)					
				if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){	
					set fieldValue=tRes.GetAt(1).Value
					set OEORIFreqCode=$tr(fieldValue,$c(0),"")
				}
				set tSC=tDocument.EvaluateExpression("/Request/Body/AddOrdersRt/OEORIInfos/OEORIInfo["_i_"]/OEORIDoseQty","text()",.tRes)					
				if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){	
					set fieldValue=tRes.GetAt(1).Value
					set OEORIDoseQty=$tr(fieldValue,$c(0),"")
				}
				
				set tSC=tDocument.EvaluateExpression("/Request/Body/AddOrdersRt/OEORIInfos/OEORIInfo["_i_"]/OEORIDoseUnitCode","text()",.tRes)					
				if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){	
					set fieldValue=tRes.GetAt(1).Value
					set OEORIDoseUnitCode=$tr(fieldValue,$c(0),"")
				}
				set tSC=tDocument.EvaluateExpression("/Request/Body/AddOrdersRt/OEORIInfos/OEORIInfo["_i_"]/OEORIDoseForms","text()",.tRes)					
				if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){	
					set fieldValue=tRes.GetAt(1).Value
					set OEORIDoseForms=$tr(fieldValue,$c(0),"")
				}
				set tSC=tDocument.EvaluateExpression("/Request/Body/AddOrdersRt/OEORIInfos/OEORIInfo["_i_"]/OEORIEnterDeptCode","text()",.tRes)					
				if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){	
					set fieldValue=tRes.GetAt(1).Value
					set OEORIEnterDeptCode=$tr(fieldValue,$c(0),"")
				}
				set tSC=tDocument.EvaluateExpression("/Request/Body/AddOrdersRt/OEORIInfos/OEORIInfo["_i_"]/OEORIExecDeptCode","text()",.tRes)					
				if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){	
					set fieldValue=tRes.GetAt(1).Value
					set OEORIExecDeptCode=$tr(fieldValue,$c(0),"")
				}
				
				set tSC=tDocument.EvaluateExpression("/Request/Body/AddOrdersRt/OEORIInfos/OEORIInfo["_i_"]/OEORIEnterDocCode","text()",.tRes)					
				if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){	
					set fieldValue=tRes.GetAt(1).Value
					set OEORIEnterDocCode=$tr(fieldValue,$c(0),"")
				}
				set tSC=tDocument.EvaluateExpression("/Request/Body/AddOrdersRt/OEORIInfos/OEORIInfo["_i_"]/OEORIRequireExecDate","text()",.tRes)					
				if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){	
					set fieldValue=tRes.GetAt(1).Value
					set OEORIRequireExecDate=$tr(fieldValue,$c(0),"")
				}
				set tSC=tDocument.EvaluateExpression("/Request/Body/AddOrdersRt/OEORIInfos/OEORIInfo["_i_"]/OEORIRequireExecTime","text()",.tRes)					
				if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){	
					set fieldValue=tRes.GetAt(1).Value
					set OEORIRequireExecTime=$tr(fieldValue,$c(0),"")
				}
				set tSC=tDocument.EvaluateExpression("/Request/Body/AddOrdersRt/OEORIInfos/OEORIInfo["_i_"]/OEORIRemarks","text()",.tRes)					
				if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){	
					set fieldValue=tRes.GetAt(1).Value
					set OEORIRemarks=$tr(fieldValue,$c(0),"")
				}
				set tSC=tDocument.EvaluateExpression("/Request/Header/SourceSystem","text()",.tRes)					
				if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){	
					set fieldValue=tRes.GetAt(1).Value
					set SourceSystem=$tr(fieldValue,$c(0),"")
				}
				set tSC=tDocument.EvaluateExpression("/Request/Body/AddOrdersRt/OEORIInfos/OEORIInfo["_i_"]/OEORIOEORIDR","text()",.tRes)					
				if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){	
					set fieldValue=tRes.GetAt(1).Value
					set OEORIOEORIDR=$tr(fieldValue,$c(0),"")
				}
				set tSC=tDocument.EvaluateExpression("/Request/Body/AddOrdersRt/OEORIInfos/OEORIInfo["_i_"]/OEORIEnterDate","text()",.tRes)					
				if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){	
					set fieldValue=tRes.GetAt(1).Value
					set OEORIEnterDate=$tr(fieldValue,$c(0),"")
				}
				set tSC=tDocument.EvaluateExpression("/Request/Body/AddOrdersRt/OEORIInfos/OEORIInfo["_i_"]/OEORIEnterTime","text()",.tRes)					
				if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){	
					set fieldValue=tRes.GetAt(1).Value
					set OEORIEnterTime=$tr(fieldValue,$c(0),"")
				}
				set tSC=tDocument.EvaluateExpression("/Request/Body/AddOrdersRt/OEORIInfos/OEORIInfo["_i_"]/OEORISpecimenCode","text()",.tRes)					
				if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){	
					set fieldValue=tRes.GetAt(1).Value
					set OEORISpecimenCode=$tr(fieldValue,$c(0),"")
				}
				set tSC=tDocument.EvaluateExpression("/Request/Body/AddOrdersRt/OEORIInfos/OEORIInfo["_i_"]/OEORIInstrCode","text()",.tRes)					
				if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){	
					set fieldValue=tRes.GetAt(1).Value
					set OEORIInstrCode=$tr(fieldValue,$c(0),"")
				}
				set tSC=tDocument.EvaluateExpression("/Request/Body/AddOrdersRt/OEORIInfos/OEORIInfo["_i_"]/OEORIDurationCode","text()",.tRes)					
				if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){	
					set fieldValue=tRes.GetAt(1).Value
					set OEORIDurationCode=$tr(fieldValue,$c(0),"")
				}
				set tSC=tDocument.EvaluateExpression("/Request/Body/AddOrdersRt/OEORIInfos/OEORIInfo["_i_"]/OEORIQtyPackUOM","text()",.tRes)					
				if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){	
					set fieldValue=tRes.GetAt(1).Value
					set OEORIQtyPackUOM=$tr(fieldValue,$c(0),"")
				}
				set InputStr=PAADMVisitNumber_"^"_ThirdOEORIOrderItemID_"^"_OEORIPriorityCode_"^"_OEORIARCItmMastCode_"^"_""      //1-5
				set InputStr=InputStr_"^"_OEORIOrderQty _"^"_OEORIFreqCode_"^"_OEORIDoseUnitCode_"^"_OEORIDoseForms_"^"_""   //6-10
				set InputStr=InputStr_"^"_OEORIEnterDeptCode_"^"_OEORIExecDeptCode_"^"_OEORIEnterDocCode_"^"_"demo"_"^"_OEORIRequireExecDate     //11-15
				set InputStr=InputStr_"^"_OEORIRequireExecTime_"^"_""_"^"_SourceSystem_"^"_""_"^"_OEORIRemarks    //18-20
				set InputStr=InputStr_"^"_OEORIOEORIDR_"^"_OEORIEnterDate_"^"_OEORIEnterTime_"^"_OEORISpecimenCode_"^"_OEORIDoseQty_"^"_OEORIInstrCode_"^"_OEORIDurationCode // 21-27
				set InputStr=InputStr_"^"_OEORIQtyPackUOM //28
				i MainInputStr="" {
					set MainInputStr=InputStr
				}
				else {
					s MainInputStr=MainInputStr_"@"_InputStr
				}
			} 
			set respBody=..AddOrderItemsMutil(MainInputStr)
			
			s Response.Respbody=respBody
		}  
		
		d Response.XMLExportToStream(.stream)
		q stream
	}
	
Exception
	set stream=##class(%GlobalCharacterStream).%New()
	d stream.Write("-1^"_$ze)
	Quit stream
}

// 多个医嘱一次插入  chenjiang 20160722

ClassMethod AddOrderItemsMutil(ordInfo As %String) As web.DHCENS.STBLL.ORDER.MODEL.Respbody
{
	Set $ZTrap = "SendMessageET"
	s tmpMainStr=""
	set response=##class(web.DHCENS.STBLL.ORDER.MODEL.Respbody).%New()
	s AddOrdersRp=##class(web.DHCENS.STBLL.ORDER.MODEL.RespOrderList).%New()
	s OrderCount=$l(ordInfo,"@")
	f tmpOrderCount=1:1:OrderCount
	{
		s SubOrdInfo=$p(ordInfo,"@",tmpOrderCount)
		if SubOrdInfo=""{
			s OEORIInfos=##class(web.DHCENS.STBLL.ORDER.MODEL.RespOrder).%New()
			set response.ResultCode="-1"
			set response.ResultContent="输入信息格式不正确"
			set OEORIInfos.HISOEORIOrderItemID=""
			set OEORIInfos.OEORIOrderItemID=""
			d AddOrdersRp.OEORIInfos.Insert(OEORIInfos)
			set response.AddOrdersRp=AddOrdersRp
			goto FailResponse
		}	
		set AdmNo=$p(SubOrdInfo,"^",1)
		set AdmStr=$g(^PAADM(AdmNo))	
		if (AdmStr'="") 
		{
			set status=$P(AdmStr,"^",20)
			set ExtRowID=$p(SubOrdInfo,"^",2)
			if (status="D") {		
				s OEORIInfos=##class(web.DHCENS.STBLL.ORDER.MODEL.RespOrder).%New()
				set response.ResultCode="-2"
				set response.ResultContent="病人已出院"
				set OEORIInfos.HISOEORIOrderItemID=""
	    		set OEORIInfos.OEORIOrderItemID=ExtRowID
	    		d AddOrdersRp.OEORIInfos.Insert(OEORIInfos)
				set response.AddOrdersRp=AddOrdersRp
				goto FailResponse
			}
			elseif(ExtRowID="") {
				s OEORIInfos=##class(web.DHCENS.STBLL.ORDER.MODEL.RespOrder).%New()
				set response.ResultCode="-1"
				set response.ResultContent="请输入产生该费用的唯一标识"
				set OEORIInfos.HISOEORIOrderItemID=""
		   		set OEORIInfos.OEORIOrderItemID=""
		   		d AddOrdersRp.OEORIInfos.Insert(OEORIInfos)
				set response.AddOrdersRp=AddOrdersRp
				goto FailResponse
			}
			else
		 	{
				set Source=$p(SubOrdInfo,"^",18)
				set LinkOrdID=$p(SubOrdInfo,"^",21)
				// 查询医嘱是否在DHC_ORDSContrast中存在
				set OEORIRowId=..SelectDHCORDSContrast(ExtRowID,Source)
				// 判断医嘱是否存在
				if OEORIRowId = ""
				 {
					i tmpMainStr=""
					{
						s tmpMainStr=SubOrdInfo
					}
					else
					{
						s tmpMainStr=tmpMainStr_"@"_SubOrdInfo
					}
				}
				else
				 {
					s OEORIInfos=##class(web.DHCENS.STBLL.ORDER.MODEL.RespOrder).%New()
					set response.ResultCode="-4"
					set response.ResultContent="医嘱已增加"
					set OEORIInfos.HISOEORIOrderItemID=""
					set OEORIInfos.OEORIOrderItemID=""
					d AddOrdersRp.OEORIInfos.Insert(OEORIInfos)
					set response.AddOrdersRp=AddOrdersRp
					goto FailResponse
				}
			}
		}
		else
		{
			s OEORIInfos=##class(web.DHCENS.STBLL.ORDER.MODEL.RespOrder).%New()
			set response.ResultCode="-3"
			set response.ResultContent="病人就诊信息不存在"
			set OEORIInfos.HISOEORIOrderItemID=""
			set OEORIInfos.OEORIOrderItemID=""
			d AddOrdersRp.OEORIInfos.Insert(OEORIInfos)
			set response.AddOrdersRp=AddOrdersRp
			goto FailResponse
		}
	}
		
	// 将该信息添加到OE_ORDItem中
	ts
	set RowId =..AddOrderItemMutil(tmpMainStr)

	b //判断是否添加成功
	if ($p(RowId,"^")<0)
	 {
		tro
		s OEORIInfos=##class(web.DHCENS.STBLL.ORDER.MODEL.RespOrder).%New()
		set response.ResultCode="-1"
		set response.ResultContent=RowId
		set OEORIInfos.HISOEORIOrderItemID=""
		set OEORIInfos.OEORIOrderItemID=$p(RowId,"#",2)
		d AddOrdersRp.OEORIInfos.Insert(OEORIInfos)
		set response.AddOrdersRp=AddOrdersRp
		goto FailResponse
	}
	else
	{
		tc
		s ResultCount=$l(RowId,"^")
		for tmpResultCount=1:1:ResultCount
		{
			
			s tmpRowId=$p(RowId,"^",tmpResultCount)
			s tmpExtRowID=""
			s tmpExtRowID=$p($p(tmpMainStr,"@",tmpResultCount),"^",2) ;$p(tmpRowId,"*",5)
			i tmpExtRowID'=""
			{				
				s OEORIInfos=##class(web.DHCENS.STBLL.ORDER.MODEL.RespOrder).%New()
				s OeordRowID=$p(tmpRowId,"*",2)
				/*
				s docDr=$P(^OEORD(+OeordRowID,"I",$p(OeordRowID,"||",2),1),"^",11)
				s AdmRowId=$p(^OEORD(+OeordRowID),"^",1)
				set AdmTypeCode=$p($g(^PAADM(AdmRowId)),"^",2)
				if AdmTypeCode="I" {
					set ExecFlag=##class(appcom.OEOrdItem).Execute(OeordRowID,docDr)
					set Billeturn=##class(web.UDHCJFBILLIP).BILL(AdmRowId,"","",0)					
				}
				*/
				
				set ContrastStr=OeordRowID_"^"_tmpExtRowID_"^"_Source_"^"_LinkOrdID
				// 添加信息到DHC_ORDSContrast，进行信息对照
	    		set SQLCODE=..InsertDHCORDSContrast(ContrastStr)
	    				    		
	    		set response.ResultCode="0"
				set response.ResultContent="成功"
				set OEORIInfos.HISOEORIOrderItemID=OeordRowID
				set OEORIInfos.OEORIOrderItemID=tmpExtRowID
				set:OeordRowID'="" OEORIInfos.PrescNo=$p($g(^OEORD(+OeordRowID,"I",$p(OeordRowID,"||",2),1)),"^",14)
				set:OEORIInfos.PrescNo="" OEORIInfos.PrescNo=OeordRowID
				set:OeordRowID'="" OEORIInfos.ARCItmMastID=$p($g(^OEORD(+OeordRowID,"I",$p(OeordRowID,"||",2),1)),"^",2)
				set:OeordRowID'="" OEORIInfos.Price=##class(web.DHCENS.STBLL.LIS.METHOD.PatLisOrdInfo).GetPrice(OeordRowID)
				d AddOrdersRp.OEORIInfos.Insert(OEORIInfos)
			}
		}
		set response.AddOrdersRp=AddOrdersRp			
		goto FailResponse
	}
FailResponse
	q response
	
SendMessageET
	tro
	s OEORIInfos=##class(web.DHCENS.STBLL.ORDER.MODEL.RespOrder).%New()
	set response.ResultCode="-1"
	set response.ResultContent="补录费用程序异常"_$ze
	set OEORIInfos.HISOEORIOrderItemID=""
	set OEORIInfos.OEORIOrderItemID=""
	d AddOrdersRp.OEORIInfos.Insert(OEORIInfos)
	set response.AddOrdersRp=AddOrdersRp
	Quit response
}

ClassMethod AddOrderItemMutil(ordinfo As %String) As %String
{
	set rowid = -1
	s MainOrderItemStr=""
	s OrdCount=$l(ordinfo,"@")
	for tmpOrdCount=1:1:OrdCount
	{
		s Subordinfo=$p(ordinfo,"@",tmpOrdCount)
		set admNo = $P(Subordinfo,"^",1)             //就诊号
		set arcimCode = $P(Subordinfo,"^",4)         //医嘱项代码
		set qty = $P(Subordinfo,"^",6)               //数量
		set ordDept = $P(Subordinfo,"^",11) //开单科室代码
		set doc = $ZCVT($P(Subordinfo,"^",13),"U")     //开单医生代码
		set user = $ZCVT($P(Subordinfo,"^",14),"U")    //录入者代码
		set recDept = $P(Subordinfo,"^",12) //接受科室代码
		set OEORIPriorityCode=$P(Subordinfo,"^",3)
		set OEORIPriorityRowId=$o(^OECPR(0,"Code",$$ALPHAUP^SSUTIL4(OEORIPriorityCode),""))
		i ('$D(^ARCIM(0,"Code",arcimCode))) 
		{
			s rowid="-2^医嘱项目不存在:"_arcimCode_"#"_$p(Subordinfo,"^",2)
		}
		q:($p(rowid,"^")="-2")
		set sub = $O(^ARCIM(0,"Code",$$ALPHAUP^SSUTIL4(arcimCode),""))
		set ver = $O(^ARCIM(0,"Code",$$ALPHAUP^SSUTIL4(arcimCode),sub,""))
		set itemMast = sub_"||"_ver //医嘱项Rowid
		set itemCat=$p($g(^ARCIM(sub,ver,1)),"^",10)  //医嘱子类
		set ordDept=$$ALPHAUP^SSUTIL4(ordDept),recDept=$$ALPHAUP^SSUTIL4(recDept)
		if (('$D(^CTLOC(0,"Code",ordDept)))||('$D(^CTLOC(0,"Code",recDept)))) {
			s rowid="-3^科室代码不存在:"_ordDept_"^"_recDept_"#"_$p(Subordinfo,"^",2)
		}
		q:($p(rowid,"^")="-3")		
		set ordDeptDr = $O(^CTLOC(0,"Code",ordDept,""))
		set recDeptDr = $O(^CTLOC(0,"Code",recDept,""))
		/*对于补录的医嘱，一般由操作人员直接录入，所以医生的DR仍从ss_user里面查找*/
		if (('$D(^SSU("SSUSR",0,"SSUSR_Initials",doc)))||('$D(^SSU("SSUSR",0,"SSUSR_Initials",user)))) {
	    		s rowid="-4^人员代码无效:"_doc_"^"_user_"#"_$p(Subordinfo,"^",2)
		}
		q:($p(rowid,"^")="-4")
	
		set docDr = $O(^SSU("SSUSR",0,"SSUSR_Initials",doc,""))
		if docDr'="" {
			set docDr=$P($G(^SSU("SSUSR",docDr)),"^",14)
		}
		set userDr = $O(^SSU("SSUSR",0,"SSUSR_Initials",doc,"")) //$O(^SSU("SSUSR",0,"SSUSR_Initials",user,""))
		set OrderStartDate=$P(Subordinfo,"^",22)
		set OrderStartTime=$P(Subordinfo,"^",23)
		set OrderSeqNo=tmpOrdCount
		set OrderType=$p($g(^ARC("IC",itemCat)),"^",7)
		set BillTypeRowid="1"
		set OrderLabSpecRowid=$P(Subordinfo,"^",24)
		//set OrderLabSpecCode=$P(Subordinfo,"^",24)
		//set OrderLabSpecRowid=$o(^dbo.BTSpecimenI("IndexCode",1,##Class(LIS.Util.Common).IndexData(OrderLabSpecCode),""))
		set (OrderDrugFormRowid,OrderDepProcNotes,OrderDoseQty,OrderDoseUOMRowid,OrderQtySum,OrderFreqRowid)=""
		set (OrderDurRowid,OrderInstrRowid,PHPrescType,OrderMasterSeqNo,OrderSkinTest,OrderPhSpecInstr,OrderCoverMainIns)=""
		set (OrderActionRowid,OrderARCOSRowid,OrderEndDate,OrderEndTime)=""
		set:OrderStartDate'="" OrderStartDate=$zdh(OrderStartDate,3)
		set:OrderStartDate'="" OrderStartDate=$zd(OrderStartDate,4)
		set:OrderStartTime'="" OrderStartTime=$p(OrderStartTime,":",1,2)
		set OEORIFreqCode=$P(Subordinfo,"^",7)
		set:OEORIFreqCode'="" OrderFreqRowid=$o(^PHCFR(0,"Code",$$ALPHAUP^SSUTIL4(OEORIFreqCode),""))
		set OrderDoseQty=$P(Subordinfo,"^",25)
		set OEORIDoseUnitCode=$P(Subordinfo,"^",8)
		set:OEORIDoseUnitCode'="" OrderDoseUOMRowid=$o(^CT("UOM",0,"Code",$$ALPHAUP^SSUTIL4(OEORIDoseUnitCode),""))
		set OEORIInstrCode=$P(Subordinfo,"^",26)
		set:OEORIInstrCode'="" OrderInstrRowid=$o(^PHCIN(0,"Code",$$ALPHAUP^SSUTIL4(OEORIInstrCode),""))
		set OEORIDurationCode=$P(Subordinfo,"^",27)
		set:OEORIDurationCode'="" OrderDurRowid=$o(^PHCDU(0,"Code",$$ALPHAUP^SSUTIL4(OEORIDurationCode),""))
		set OrderQtySum=qty
		set OEORIQtyPackUOM=$P(Subordinfo,"^",28)
		Set OrderItemStr=""
		Set OrderItemStr=itemMast_"^"_OrderType_"^"_OEORIPriorityRowId_"^"_OrderStartDate_"^"_OrderStartTime_"^"_qty_"^"_""      //1-7
		Set OrderItemStr=OrderItemStr_"^"_recDeptDr_"^"_BillTypeRowid_"^"_OrderDrugFormRowid_"^"_OrderDepProcNotes              //8-11
		Set OrderItemStr=OrderItemStr_"^"_OrderDoseQty_"^"_OrderDoseUOMRowid_"^"_OrderQtySum_"^"_OrderFreqRowid_"^"_OrderDurRowid_"^"_OrderInstrRowid    //12-17
		Set OrderItemStr=OrderItemStr_"^"_PHPrescType_"^"_OrderMasterSeqNo_"^"_OrderSeqNo_"^"_OrderSkinTest_"^"_OrderPhSpecInstr_"^"_OrderCoverMainIns    //18-23
		Set OrderItemStr=OrderItemStr_"^"_OrderActionRowid_"^"_OrderARCOSRowid_"^"_OrderEndDate_"^"_OrderEndTime_"^"_OrderLabSpecRowid   //24-28
		Set OrderItemStr=OrderItemStr_"^^^^^^^^^^^^^^^^^^^^^^^^^^^"_OEORIQtyPackUOM_"^^^"     //29-58
		//61位 传入外部标示 
		i MainOrderItemStr=""
		{
			s MainOrderItemStr=OrderItemStr
		}
		else
		{
			s MainOrderItemStr=MainOrderItemStr_$c(1)_OrderItemStr
		}
	
		
	}
	i $p(rowid,"^")="-1"
	{
		set rowid = ##class(DHCDoc.Interface.Inside.ServiceOrd).SaveOrderItems(admNo,MainOrderItemStr,userDr,ordDeptDr,docDr,"","")
	}
	Q rowid
}

ClassMethod AddOrderItems(ordInfo As %String) As web.DHCENS.STBLL.ORDER.MODEL.Respbody
{
	Set $ZTrap = "SendMessageET"
	set response=##class(web.DHCENS.STBLL.ORDER.MODEL.Respbody).%New()
	s AddOrdersRp=##class(web.DHCENS.STBLL.ORDER.MODEL.RespOrderList).%New()
	s OEORIInfos=##class(web.DHCENS.STBLL.ORDER.MODEL.RespOrder).%New()
	s OEORIInfos.HISOEORIOrderItemID=""
	s OEORIInfos.OEORIOrderItemID=""
	
	if ordInfo=""{
		set response.ResultCode="-1"
		set response.ResultContent="输入信息格式不正确"
		set OEORIInfos.HISOEORIOrderItemID=""
		set OEORIInfos.OEORIOrderItemID=""
		d AddOrdersRp.OEORIInfos.Insert(OEORIInfos)
		set response.AddOrdersRp=AddOrdersRp
		Quit response
	}
	set AdmNo=$p(ordInfo,"^",1)
	set AdmStr=$g(^PAADM(AdmNo))
	if (AdmStr'="") {
		set status=$P(AdmStr,"^",20)
		set ExtRowID=$p(ordInfo,"^",2)
		if (status="D") {		
			set response.ResultCode="-2"
			set response.ResultContent="病人已出院"
			set OEORIInfos.HISOEORIOrderItemID=""
		    set OEORIInfos.OEORIOrderItemID=ExtRowID
		    d AddOrdersRp.OEORIInfos.Insert(OEORIInfos)
			set response.AddOrdersRp=AddOrdersRp
			Quit response
		}		
		elseif(ExtRowID="") {
			set response.ResultCode="-1"
			set response.ResultContent="请输入产生该费用的唯一标识"
			set OEORIInfos.HISOEORIOrderItemID=""
		    set OEORIInfos.OEORIOrderItemID=""
		    d AddOrdersRp.OEORIInfos.Insert(OEORIInfos)
			set response.AddOrdersRp=AddOrdersRp
			Quit response
		}
		else {
			set Source=$p(ordInfo,"^",18)
			set LinkOrdID=$p(ordInfo,"^",21)
			// 查询医嘱是否在DHC_ORDSContrast中存在
			set OEORIRowId=..SelectDHCORDSContrast(ExtRowID,Source)
			// 判断医嘱是否存在
			if OEORIRowId = "" {
				// 将该信息添加到OE_ORDItem中
				ts
		    	set RowId =..AddOrderItem(ordInfo)
				//判断是否添加成功
				if ($F(RowId,"-1^")) {
					tro
					set response.ResultCode="-1"
					set response.ResultContent=RowId
				    set OEORIInfos.HISOEORIOrderItemID=""
					set OEORIInfos.OEORIOrderItemID=ExtRowID
					d AddOrdersRp.OEORIInfos.Insert(OEORIInfos)
					set response.AddOrdersRp=AddOrdersRp
					Quit response
				}
				else{
					tc
					set ContrastStr=RowId_"^"_ExtRowID_"^"_Source_"^"_LinkOrdID
					// 添加信息到DHC_ORDSContrast，进行信息对照
		    		set SQLCODE=..InsertDHCORDSContrast(ContrastStr)		    		
		    		set response.ResultCode="0"
					set response.ResultContent="成功"
					set OEORIInfos.HISOEORIOrderItemID=RowId
					set OEORIInfos.OEORIOrderItemID=ExtRowID
					d AddOrdersRp.OEORIInfos.Insert(OEORIInfos)
					set response.AddOrdersRp=AddOrdersRp			
					Quit response
				}
			}
			else {
				set response.ResultCode="-4"
				set response.ResultContent="医嘱已增加"
				set OEORIInfos.HISOEORIOrderItemID=""
				set OEORIInfos.OEORIOrderItemID=""
				d AddOrdersRp.OEORIInfos.Insert(OEORIInfos)
				set response.AddOrdersRp=AddOrdersRp
				Quit response
			}
		}
	}
	else{
		set response.ResultCode="-3"
		set response.ResultContent="病人就诊信息不存在"
		set OEORIInfos.HISOEORIOrderItemID=""
		set OEORIInfos.OEORIOrderItemID=""
		d AddOrdersRp.OEORIInfos.Insert(OEORIInfos)
		set response.AddOrdersRp=AddOrdersRp
		Quit response
	}
SendMessageET
	tro
	set response.ResultCode="-1"
	set response.ResultContent="补录费用程序异常"
	set OEORIInfos.HISOEORIOrderItemID=""
	set OEORIInfos.OEORIOrderItemID=""
	d AddOrdersRp.OEORIInfos.Insert(OEORIInfos)
	set response.AddOrdersRp=AddOrdersRp
	Quit response
}

ClassMethod SelectDHCORDSContrast(OrdID As %String, CompanyName As %String)
{
	q:OrdID="" ""
	s RowID=$o(^User.DHCORDSContrastI("IndexOfContrast"," "_CompanyName," "_OrdID,""))
	q RowID
}

ClassMethod AddOrderItem(ordinfo As %String) As %String
{
	set rowid = -1	
	set admNo = $P(ordinfo,"^",1)             //就诊号
	set arcimCode = $P(ordinfo,"^",4)         //医嘱项代码
	set qty = $P(ordinfo,"^",6)               //数量
	set ordDept = $P(ordinfo,"^",11) //开单科室代码
	set doc = $ZCVT($P(ordinfo,"^",13),"U")     //开单医生代码
	set user = $ZCVT($P(ordinfo,"^",14),"U")    //录入者代码
	set recDept = $P(ordinfo,"^",12) //接受科室代码
	set OEORIPriorityCode=$P(ordinfo,"^",3)
	set OEORIPriorityRowId=$o(^OECPR(0,"Code",$$ALPHAUP^SSUTIL4(OEORIPriorityCode),""))
	if ('$D(^ARCIM(0,"Code",arcimCode))) {
		Q "-1^医嘱项代码无效"
	}
		
	set sub = $O(^ARCIM(0,"Code",$$ALPHAUP^SSUTIL4(arcimCode),""))
	set ver = $O(^ARCIM(0,"Code",$$ALPHAUP^SSUTIL4(arcimCode),sub,""))
	set itemMast = sub_"||"_ver //医嘱项Rowid
	set itemCat=$p($g(^ARCIM(sub,ver,1)),"^",10)  //医嘱子类
	set ordDept=$$ALPHAUP^SSUTIL4(ordDept),recDept=$$ALPHAUP^SSUTIL4(recDept)
	if (('$D(^CTLOC(0,"Code",ordDept)))||('$D(^CTLOC(0,"Code",recDept)))) {
		Q "-1^科室代码无效"
	}
	
	set ordDeptDr = $O(^CTLOC(0,"Code",ordDept,""))
	set recDeptDr = $O(^CTLOC(0,"Code",recDept,""))
	set doc=$$ALPHAUP^SSUTIL4(doc),user=$$ALPHAUP^SSUTIL4(user)
	/*对于补录的医嘱，一般由操作人员直接录入，所以医生的DR仍从ss_user里面查找*/
	if (('$D(^SSU("SSUSR",0,"SSUSR_Initials",doc)))||('$D(^SSU("SSUSR",0,"SSUSR_Initials",user)))) {
	    Q "-1^人员代码无效"	
	}
	
	set docDr = $O(^SSU("SSUSR",0,"SSUSR_Initials",doc,""))
	if docDr'="" {
		set docDr=$P($G(^SSU("SSUSR",docDr)),"^",14)
	}
	
	set userDr = $O(^SSU("SSUSR",0,"SSUSR_Initials",user,""))
	set OrderStartDate=$P(ordinfo,"^",22)
	set OrderStartTime=$P(ordinfo,"^",23)
	set OrderSeqNo=1
	set OrderType=$p($g(^ARC("IC",itemCat)),"^",7)
	set BillTypeRowid="1"
	set (OrderDrugFormRowid,OrderDepProcNotes,OrderDoseQty,OrderDoseUOMRowid,OrderQtySum,OrderFreqRowid)=""
	set (OrderDurRowid,OrderInstrRowid,PHPrescType,OrderMasterSeqNo,OrderSkinTest,OrderPhSpecInstr,OrderCoverMainIns)=""
	set (OrderActionRowid,OrderARCOSRowid,OrderEndDate,OrderEndTime,OrderLabSpecRowid)=""
	set:OrderStartDate'="" OrderStartDate=$zdh(OrderStartDate,3)
	set:OrderStartDate'="" OrderStartDate=$zd(OrderStartDate,4)
	set:OrderStartTime'="" OrderStartTime=$p(OrderStartTime,":",1,2)
	Set OrderItemStr=itemMast_"^"_OrderType_"^"_OEORIPriorityRowId_"^"_OrderStartDate_"^"_OrderStartTime_"^"_qty_"^"_"" 
	Set OrderItemStr=OrderItemStr_"^"_recDeptDr_"^"_BillTypeRowid_"^"_OrderDrugFormRowid_"^"_OrderDepProcNotes
	Set OrderItemStr=OrderItemStr_"^"_OrderDoseQty_"^"_OrderDoseUOMRowid_"^"_OrderQtySum_"^"_OrderFreqRowid_"^"_OrderDurRowid_"^"_OrderInstrRowid
	Set OrderItemStr=OrderItemStr_"^"_PHPrescType_"^"_OrderMasterSeqNo_"^"_OrderSeqNo_"^"_OrderSkinTest_"^"_OrderPhSpecInstr_"^"_OrderCoverMainIns
	Set OrderItemStr=OrderItemStr_"^"_OrderActionRowid_"^"_OrderARCOSRowid_"^"_OrderEndDate_"^"_OrderEndTime_"^"_OrderLabSpecRowid
	set res = ##class(DHCDoc.Interface.Inside.ServiceOrd).SaveOrderItems(admNo,OrderItemStr,userDr,ordDeptDr,docDr,"","")
	if ($p(res,"*",2)'="") {
		set rowid = $P(res,"*",2)
		//将住院类型医嘱状态变为“执行”(血库接口需要)
		set AdmTypeCode=$p($g(^PAADM(admNo)),"^",2)
		if AdmTypeCode="I"{
			set ExecFlag=##class(appcom.OEOrdItem).Execute(rowid,docDr)
		}
	}
	Q rowid
}

/// 通过用户代码取用户Rowid
ClassMethod GetUserDrByUserCode(UserCode As %String) As %String
{
	q:UserCode="" ""
	s UserCode=$$ALPHAUP^SSUTIL4(UserCode)
	s RowId=$o(^SSU("SSUSR",0,"SSUSR_Initials",UserCode,"")) 
    q RowId
}

ClassMethod InsertDHCORDSContrast(Input As %String) As %String
{
	s OEORIRowId="",OrdID="",CompanyName="",SendDate="",SendTime="",ExtRowID=""
	s OEORIRowId=$p(Input,"^",1)   //HIS产生id
	s ExtRowID=$p(Input,"^",2)     //外部id
	s CompanyName=$p(Input,"^",3)
	s SendDate=$p($h,",",1)
	s SendTime=$p($h,",",2)
	s OrdID=$p(Input,"^",4)        //关联id
    &sql( INSERT INTO SQLUSER.DHC_ORDSContrast(Company_Name,OEORI_RowId,OrdID,Ext_RowID,senddate,sendtime) VALUES(:CompanyName,:OEORIRowId,:OrdID,:ExtRowID,:SendDate,:SendTime))
    q SQLCODE
}

ClassMethod IsHaveDiagose(argAdmId As %String) As %String
{
	s mainmradmdr = $p($g(^PAADM(argAdmId)),"^",61)
	q:(mainmradmdr = "") "0"
	q:($d(^MR(mainmradmdr)) = 0) "0"
	
	s mrdiachildsub = ""
	s mrdiachildsub=$o(^MR(mainmradmdr,"DIA",mrdiachildsub))
	q:mrdiachildsub="" "0"
	
	q "1"
}

/// w ##class(web.DHCENS.STBLL.ORDER.METHOD.AddOrdItems).test()
ClassMethod test() As %String
{
	s stream=##class(%GlobalCharacterStream).%New()
	d stream.Write("<Request><Header><SourceSystem>LIS</SourceSystem><MessageID>00BCB482-5E56-11EC-AFBA-005056BD6915</MessageID></Header><Body><AddOrdersRt><PATPatientID>0000001028</PATPatientID><PAADMVisitNumber>2305</PAADMVisitNumber><OEORIInfos><OEORIInfo><RecipeID></RecipeID><OEORIOrderItemID>IT</OEORIOrderItemID><OEORIOEORIDR></OEORIOEORIDR><OEORIARCItmMastCode>BXK0021</OEORIARCItmMastCode><OEORIPriorityCode>NORM</OEORIPriorityCode><OEORIStatus>E</OEORIStatus><OEORIDoseForms></OEORIDoseForms><OEORIDoseQty></OEORIDoseQty><OEORIDoseUnitCode></OEORIDoseUnitCode><OEORIFreqCode></OEORIFreqCode><OEORIInstrCode></OEORIInstrCode><OEORIDurationCode></OEORIDurationCode><OEORIOrderQty>1</OEORIOrderQty><OEORIResultStatus></OEORIResultStatus><OEORIRemarks></OEORIRemarks><OEORIEnterDocCode>LIS01</OEORIEnterDocCode><OEORIEnterDate>2021-12-16</OEORIEnterDate><OEORIEnterTime>17:53:21</OEORIEnterTime><OEORIEnterDeptCode>ZYYJ020</OEORIEnterDeptCode><OEORIExecDeptCode>ZYYJ020</OEORIExecDeptCode><OEORIRequireExecDate>2021-12-16</OEORIRequireExecDate><OEORIRequireExecTime>17:53:21</OEORIRequireExecTime><OEORIStopDate></OEORIStopDate><OEORIStopTime></OEORIStopTime><OEORIStopDocCode></OEORIStopDocCode><OEORIIsSkinTest></OEORIIsSkinTest><OEORIISEmergency></OEORIISEmergency><OEORISpecimenCode></OEORISpecimenCode></OEORIInfo></OEORIInfos><UpdateUserCode>LIS01</UpdateUserCode><UpdateDate>2021-12-16</UpdateDate><UpdateTime>17:53:21</UpdateTime></AddOrdersRt></Body></Request>")
	;d stream.Write("<Request><Body><AddOrdersRt><PATPatientID>0000000676</PATPatientID><PAADMVisitNumber>1457</PAADMVisitNumber><OEORIInfos><OEORIInfo><RecipeID></RecipeID><OEORIOrderItemID>IT</OEORIOrderItemID><OEORIOEORIDR></OEORIOEORIDR><OEORIARCItmMastCode>BBL039</OEORIARCItmMastCode><OEORIPriorityCode>NORM</OEORIPriorityCode><OEORIStatus>E</OEORIStatus><OEORIDoseForms></OEORIDoseForms><OEORIDoseQty></OEORIDoseQty><OEORIDoseUnitCode></OEORIDoseUnitCode><OEORIFreqCode></OEORIFreqCode><OEORIInstrCode></OEORIInstrCode><OEORIDurationCode>1天</OEORIDurationCode><OEORIOrderQty>3</OEORIOrderQty><OEORIResultStatus></OEORIResultStatus><OEORIRemarks></OEORIRemarks><OEORIEnterDocCode>2646</OEORIEnterDocCode><OEORIEnterDate>2021-12-08</OEORIEnterDate><OEORIEnterTime>15:33:26</OEORIEnterTime><OEORIEnterDeptCode>ZYYJ013</OEORIEnterDeptCode><OEORIExecDeptCode>ZYYJ013</OEORIExecDeptCode><OEORIRequireExecDate>2021-12-08</OEORIRequireExecDate><OEORIRequireExecTime>15:33:26</OEORIRequireExecTime><OEORIStopDate></OEORIStopDate><OEORIStopTime></OEORIStopTime><OEORIStopDocCode></OEORIStopDocCode><OEORIIsSkinTest></OEORIIsSkinTest><OEORIISEmergency></OEORIISEmergency><OEORISpecimenCode></OEORISpecimenCode></OEORIInfo></OEORIInfos><UpdateUserCode>2646</UpdateUserCode><UpdateDate>2021-12-08</UpdateDate><UpdateTime>15:33:26</UpdateTime></AddOrdersRt></Body><Header><MessageID>21ECA684-57F9-11EC-ABDB-005056BD6915</MessageID><SourceSystem>PIS</SourceSystem></Header></Request>")
	s rtn=..AddOEOrder(stream)
	q rtn
}

/// Creator:LJJ
/// CreateTime：2020-03-09
/// Desc:插入医嘱(草药)
/// w ##class(web.DHCENS.STBLL.ORDER.METHOD.AddOrdItems).AddOrdItemCM("<Request><Header><SourceSystem>SYS0007</SourceSystem><MessageID></MessageID></Header><Body><AddOrdersRt><OEORIInfos><Adm>667</Adm><User>10127</User><Loc>KS000007</Loc><Doc>10127</Doc><OrderPriorRowid>3</OrderPriorRowid><PrescDurRowid>38</PrescDurRowid><PrescInstrRowid>38</PrescInstrRowid><PrescFreqRowid>35</PrescFreqRowid><PrescCookMode>1</PrescCookMode><PrescOrderQty>150ml</PrescOrderQty><OrderRecDepRowid>KS000016</OrderRecDepRowid><OrderBillTypeRowid>1</OrderBillTypeRowid><PrescNotes></PrescNotes><PrescEmergency></PrescEmergency><PrescStartDate>2021-01-12</PrescStartDate><PrescStartTime>17:44:49</PrescStartTime><ARCOSRowId></ARCOSRowId><DPrescNo>20210112174448022</DPrescNo><Consignee></Consignee><SendAddress></SendAddress><SendTel></SendTel><OEORIInfo><OrderARCIMRowid>CY000415</OrderARCIMRowid><OrderDoseQty>6.0000</OrderDoseQty><OrderDoseUOMRowid>1</OrderDoseUOMRowid><OrderPhSpecInstr></OrderPhSpecInstr></OEORIInfo><OEORIInfo><OrderARCIMRowid>CY000165</OrderARCIMRowid><OrderDoseQty>10.0000</OrderDoseQty><OrderDoseUOMRowid>1</OrderDoseUOMRowid><OrderPhSpecInstr></OrderPhSpecInstr></OEORIInfo><OEORIInfo><OrderARCIMRowid>CY000461</OrderARCIMRowid><OrderDoseQty>15.0000</OrderDoseQty><OrderDoseUOMRowid>1</OrderDoseUOMRowid><OrderPhSpecInstr></OrderPhSpecInstr></OEORIInfo><OEORIInfo><OrderARCIMRowid>CY000416</OrderARCIMRowid><OrderDoseQty>10.0000</OrderDoseQty><OrderDoseUOMRowid>1</OrderDoseUOMRowid><OrderPhSpecInstr></OrderPhSpecInstr></OEORIInfo><OEORIInfo><OrderARCIMRowid>CY000402</OrderARCIMRowid><OrderDoseQty>10.0000</OrderDoseQty><OrderDoseUOMRowid>1</OrderDoseUOMRowid><OrderPhSpecInstr></OrderPhSpecInstr></OEORIInfo><OEORIInfo><OrderARCIMRowid>CY000394</OrderARCIMRowid><OrderDoseQty>40.0000</OrderDoseQty><OrderDoseUOMRowid>1</OrderDoseUOMRowid><OrderPhSpecInstr></OrderPhSpecInstr></OEORIInfo><OEORIInfo><OrderARCIMRowid>CY000065</OrderARCIMRowid><OrderDoseQty>10.0000</OrderDoseQty><OrderDoseUOMRowid>1</OrderDoseUOMRowid><OrderPhSpecInstr></OrderPhSpecInstr></OEORIInfo></OEORIInfos></AddOrdersRt></Body></Request>").Read()
ClassMethod AddOrdItemCM(Input As %GlobalCharacterStream) As %GlobalCharacterStream
{
	set $zt="Exception"
	set tSC=##class(%XML.XPATH.Document).CreateFromStream(Input,.tDocument)
	set Response=##class(web.DHCENS.STBLL.ORDER.MODEL.Response).%New()
	
	set header=##class(web.DHCENS.STBLL.ORDER.MODEL.Header).%New()
	set header.SourceSystem="02"
	set header.MessageID=##class(web.DHCENS.STBLL.UTIL.Common).CreateMessageID(+$h)
	set Response.header=header
	set responseBody=##class(web.DHCENS.STBLL.ORDER.MODEL.Respbody).%New()
	set respBodyList = ##class(web.DHCENS.STBLL.ORDER.MODEL.RespOrderList).%New()
	if $$$ISERR(tSC) {
		set responseBody.ResultCode="-1"
		set responseBody.ResultContent=tSC
		set Response.Respbody=responseBody
		do Response.XMLExportToStream(.xml)
		q xml
	}else{
			set respBody=##class(web.DHCENS.STBLL.ORDER.MODEL.Respbody).%New()	
			set (Adm,User,Loc,Doc,OrderPriorRowid,PrescDurRowid,PrescInstrRowid)=""
			set (PrescFreqRowid,PrescCookMode,PrescOrderQty,OrderRecDepRowid,OrderBillTypeRowid,PrescNotes,PrescEmergency,PrescStartDate)=""
			set (PrescStartTime,ARCOSRowId)=""
			///就诊表Rowid(PA_Adm)
			set tSC=tDocument.EvaluateExpression("/Request/Body/AddOrdersRt/OEORIInfos/PAADMVisitNumber","text()",.tRes)					
			if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){	
				set fieldValue=tRes.GetAt(1).Value
				set Adm=$tr(fieldValue,$c(0),"")
			}
			///下医嘱用户指针(SS_User)
			set tSC=tDocument.EvaluateExpression("/Request/Body/AddOrdersRt/OEORIInfos/OEORIEnterDocCode","text()",.tRes)					
			if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){	
				set fieldValue=tRes.GetAt(1).Value
				set User=$tr(fieldValue,$c(0),"")
				set DocID=$o(^CTPCP(0,"Code",$$ALPHAUP^SSUTIL4(User),""))
				set CTPCPCode= $p(^CTPCP(DocID,1),"^",1)
				set User=$o(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(CTPCPCode),""))   //传医护人员ID
			}
			///下医嘱科室指针(CT_Loc)
			set tSC=tDocument.EvaluateExpression("/Request/Body/AddOrdersRt/OEORIInfos/OEORIEnterDeptCode","text()",.tRes)					
			if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){	
				set fieldValue=tRes.GetAt(1).Value
				set Loc=$tr(fieldValue,$c(0),"")
				set Loc=$o(^CTLOC(0,"Code",Loc,""))   //入参传科室code
			}
			///下医嘱医生指针(CT_CareProv)
			set tSC=tDocument.EvaluateExpression("/Request/Body/AddOrdersRt/OEORIInfos/OEORIEnterDocCode","text()",.tRes)					
			if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){	
				set fieldValue=tRes.GetAt(1).Value
				set Doc=$tr(fieldValue,$c(0),"")
				set Doc=$o(^CTPCP(0,"Code",Doc,""))   //传医护人员ID
			}
			///医嘱优先级(OEC_Priority)
			set tSC=tDocument.EvaluateExpression("/Request/Body/AddOrdersRt/OEORIInfos/OrderPriorRowid","text()",.tRes)					
			if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){	
				set fieldValue=tRes.GetAt(1).Value
				set OrderPriorRowid=$tr(fieldValue,$c(0),"")
			}
			///疗程指针(PHC_Duration),指的草药副数
			set tSC=tDocument.EvaluateExpression("/Request/Body/AddOrdersRt/OEORIInfos/PrescDurRowid","text()",.tRes)					
			if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){	
				set fieldValue=tRes.GetAt(1).Value
				set PrescDurRowid=$tr(fieldValue,$c(0),"")
			}
			///用法指针(PHC_Instruc),指的草药使用方式
			set tSC=tDocument.EvaluateExpression("/Request/Body/AddOrdersRt/OEORIInfos/PrescInstrRowid","text()",.tRes)					
			if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){	
				set fieldValue=tRes.GetAt(1).Value
				set PrescInstrRowid=$tr(fieldValue,$c(0),"")
			}
			///频次指针(PHC_Freq)
			set tSC=tDocument.EvaluateExpression("/Request/Body/AddOrdersRt/OEORIInfos/PrescFreqRowid","text()",.tRes)					
			if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){	
				set fieldValue=tRes.GetAt(1).Value
				set PrescFreqRowid=$tr(fieldValue,$c(0),"")
			}
			///煎药方式(01 自煎, 02 代煎),传01或02
			set tSC=tDocument.EvaluateExpression("/Request/Body/AddOrdersRt/OEORIInfos/PrescCookMode","text()",.tRes)					
			if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){	
				set fieldValue=tRes.GetAt(1).Value
				set PrescCookMode=$tr(fieldValue,$c(0),"")
			}
			///一次用量
			set tSC=tDocument.EvaluateExpression("/Request/Body/AddOrdersRt/OEORIInfos/PrescOrderQty","text()",.tRes)					
			if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){	
				set fieldValue=tRes.GetAt(1).Value
				set PrescOrderQty=$tr(fieldValue,$c(0),"")
			}
			///接收科室指针(CT_Loc)
			set tSC=tDocument.EvaluateExpression("/Request/Body/AddOrdersRt/OEORIInfos/OrderRecDepRowid","text()",.tRes)					
			if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){	
				set fieldValue=tRes.GetAt(1).Value
				set OrderRecDepRowid=$tr(fieldValue,$c(0),"")
				set OrderRecDepRowid=$o(^CTLOC(0,"Code",$$ALPHAUP^SSUTIL4(OrderRecDepRowid),""))   //入参传科室代码
			}
			///费别指针(PAC_AdmReason)
			set tSC=tDocument.EvaluateExpression("/Request/Body/AddOrdersRt/OEORIInfos/OrderBillTypeRowid","text()",.tRes)					
			if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){	
				set fieldValue=tRes.GetAt(1).Value
				set OrderBillTypeRowid=$tr(fieldValue,$c(0),"")
			}
			///备注
			set tSC=tDocument.EvaluateExpression("/Request/Body/AddOrdersRt/OEORIInfos/PrescNotes","text()",.tRes)					
			if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){	
				set fieldValue=tRes.GetAt(1).Value
				set PrescNotes=$tr(fieldValue,$c(0),"")
			}
			///加急
			set tSC=tDocument.EvaluateExpression("/Request/Body/AddOrdersRt/OEORIInfos/PrescEmergency","text()",.tRes)					
			if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){	
				set fieldValue=tRes.GetAt(1).Value
				set PrescEmergency=$tr(fieldValue,$c(0),"")
			}
			///开始日期
			set tSC=tDocument.EvaluateExpression("/Request/Body/AddOrdersRt/OEORIInfos/PrescStartDate","text()",.tRes)					
			if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){	
				set fieldValue=tRes.GetAt(1).Value
				set PrescStartDate=$tr(fieldValue,$c(0),"")
			}
			///开始时间
			set tSC=tDocument.EvaluateExpression("/Request/Body/AddOrdersRt/OEORIInfos/PrescStartTime","text()",.tRes)					
			if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){	
				set fieldValue=tRes.GetAt(1).Value
				set PrescStartTime=$tr(fieldValue,$c(0),"")
			}
			///医嘱套(ARC_OrdSets)
			set tSC=tDocument.EvaluateExpression("/Request/Body/AddOrdersRt/OEORIInfos/ARCOSRowId","text()",.tRes)					
			if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){	
				set fieldValue=tRes.GetAt(1).Value
				set ARCOSRowId=$tr(fieldValue,$c(0),"")
			}
			/// DPrescNo 第三方处方号
			set DPrescNo=""
			set tSC=tDocument.EvaluateExpression("/Request/Body/AddOrdersRt/OEORIInfos/DPrescNo","text()",.tRes)					
			if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){	
				set fieldValue=tRes.GetAt(1).Value
				set DPrescNo=$tr(fieldValue,$c(0),"")
			}
			/// Consignee 邮寄人
			set Consignee=""
			set tSC=tDocument.EvaluateExpression("/Request/Body/AddOrdersRt/OEORIInfos/Consignee","text()",.tRes)					
			if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){	
				set fieldValue=tRes.GetAt(1).Value
				set Consignee=$tr(fieldValue,$c(0),"")
			}
			/// SendAddress 邮寄地址
			set SendAddress=""
			set tSC=tDocument.EvaluateExpression("/Request/Body/AddOrdersRt/OEORIInfos/SendAddress","text()",.tRes)					
			if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){	
				set fieldValue=tRes.GetAt(1).Value
				set SendAddress=$tr(fieldValue,$c(0),"")
			}
			/// SendTel 邮寄电话
			set SendTel=""
			set tSC=tDocument.EvaluateExpression("/Request/Body/AddOrdersRt/OEORIInfos/SendTel","text()",.tRes)					
			if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){	
				set fieldValue=tRes.GetAt(1).Value
				set SendTel=$tr(fieldValue,$c(0),"")
			}
			s SourceSystem=""
			set tSC=tDocument.EvaluateExpression("/Request/Header/SourceSystem","text()",.tRes)					
				if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){	
					set fieldValue=tRes.GetAt(1).Value
					set SourceSystem=$tr(fieldValue,$c(0),"")
				}
			set tSC=tDocument.EvaluateExpression("/Request/Body/AddOrdersRt/OEORIInfos","count(OEORIInfo)",.tRes)
			if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){
				set hsCount=tRes.GetAt(1).Value
				Quit:hsCount="0"
				s PrescStr=""
				set PrescStr = OrderPriorRowid_"^"_PrescDurRowid_"^"_PrescInstrRowid_"^"_PrescFreqRowid_"^"_PrescCookMode
				_"^"_PrescOrderQty_"^"_OrderRecDepRowid_"^"_OrderBillTypeRowid_"^"_PrescNotes_"^"_PrescEmergency_"^"
				_PrescStartDate_"^"_PrescStartTime_"^"_ARCOSRowId_"^"
				set OrderInfoStr = ""
				for i=1:1:hsCount {
					set (OEORIARCItmMastCode,OrderDoseQty,OrderDoseUOMRowid,OrderPhSpecInstr,OEORIOrderItemID) = ""
					set tSC=tDocument.EvaluateExpression("/Request/Body/AddOrdersRt/OEORIInfos/OEORIInfo["_i_"]/OEORIARCItmMastCode","text()",.tRes)					
					///医嘱项指针(ARC_ItmMast) 
					if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){	
						set fieldValue=tRes.GetAt(1).Value
						set OEORIARCItmMastCode=$tr(fieldValue,$c(0),"")
						set OEORIARCItmMastCode=$$ALPHAUP^SSUTIL4(OEORIARCItmMastCode)
						set ARCIMSubscript=$o(^ARCIM(0,"Code",OEORIARCItmMastCode,""))
			            set ARCIMVersion=$o(^ARCIM(0,"Code",OrderARCIMRowid,ARCIMSubscript,""))
			            set OrderARCIMRowid=ARCIMSubscript_"||"_ARCIMVersion
						}
					///单次剂量
					set tSC=tDocument.EvaluateExpression("/Request/Body/AddOrdersRt/OEORIInfos/OEORIInfo["_i_"]/OrderDoseQty","text()",.tRes)					
					if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){	
						set fieldValue=tRes.GetAt(1).Value
						set OrderDoseQty=$tr(fieldValue,$c(0),"")
						}
					
					///单次剂量单位
					set tSC=tDocument.EvaluateExpression("/Request/Body/AddOrdersRt/OEORIInfos/OEORIInfo["_i_"]/OrderDoseUOMRowid","text()",.tRes)					
					if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){	
						set fieldValue=tRes.GetAt(1).Value
						set OrderDoseUOMRowid=$tr(fieldValue,$c(0),"")
					}
					///草药用法备注
					set tSC=tDocument.EvaluateExpression("/Request/Body/AddOrdersRt/OEORIInfos/OEORIInfo["_i_"]/OrderPhSpecInstr","text()",.tRes)					
					if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){	
						set fieldValue=tRes.GetAt(1).Value
						set OrderPhSpecInstr=$tr(fieldValue,$c(0),"")
					}
					///医嘱明细id
					set tSC=tDocument.EvaluateExpression("/Request/Body/AddOrdersRt/OEORIInfos/OEORIInfo["_i_"]/OEORIOrderItemID","text()",.tRes)					
					if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){	
						set fieldValue=tRes.GetAt(1).Value
						set OEORIOrderItemID=$tr(fieldValue,$c(0),"")
					}
					
					set SingleOrderItemStr = OrderARCIMRowid_"^"_OrderDoseQty_"^"_OrderDoseUOMRowid_"^"_OrderPhSpecInstr
					if (OrderInfoStr = ""){
						set OrderInfoStr = SingleOrderItemStr
					}
					else {
						set OrderInfoStr = OrderInfoStr_$c(1)_SingleOrderItemStr
						}
				}
					
				Set OrderItemStr=PrescStr_$CHAR(2)_OrderInfoStr
				
				/// 调产品组方法返回医嘱项id和医嘱id
				set SavePrescNo=0,SavePrescPat=0
				set ResultInfo = ##class(DHCDoc.Interface.Inside.ServiceOrd).SaveOrderItemsCM(Adm,OrderItemStr,User,Loc,Doc)			
				
				set valueStr1=$p(ResultInfo,"^",1)
				if (valueStr1'="")&&($p($p(valueStr1,"*",2),"||",1)'="")
				{
					set OEORDItemID1 = $p(valueStr1,"*",2)
					set OEORDID1 = $p(valueStr1,"*",1)
					set Oeord1=$p(OEORDItemID1,"||",1)
					set OeOrdSub1=$p(OEORDItemID1,"||",2)
					set PrescNo1=$p($g(^OEORD(Oeord1,"I",OeOrdSub1,1)),"^",14)
					set patDr = $P($g(^PAADM(Adm)),"^",1)
					
					// 2021-02-19
					// 查询医嘱是否在DHC_ORDSContrast中存在
					set OEORIRowId=..SelectDHCORDSContrast(OEORIOrderItemID,SourceSystem)
					// 判断医嘱是否存在
					if OEORIRowId = ""
				 	{
						set ContrastStr=OEORDID1_"^"_OEORIOrderItemID_"^"_SourceSystem_"^"
						// 添加信息到DHC_ORDSContrast，进行信息对照
		    			set SQLCODE=..InsertDHCORDSContrast(ContrastStr)		    		
		    			set response.ResultCode="0"
						set response.ResultContent="成功"
						set OEORIInfos.HISOEORIOrderItemID=OEORDID1
						set OEORIInfos.OEORIOrderItemID=OEORIOrderItemID
						d AddOrdersRp.OEORIInfos.Insert(OEORIInfos)
						set response.AddOrdersRp=AddOrdersRp			
						Quit response
					}
					else
				 	{
						s OEORIInfos=##class(web.DHCENS.STBLL.ORDER.MODEL.RespOrder).%New()
						set response.ResultCode="-4"
						set response.ResultContent="医嘱已增加"
						set OEORIInfos.HISOEORIOrderItemID=""
						set OEORIInfos.OEORIOrderItemID=""
						d AddOrdersRp.OEORIInfos.Insert(OEORIInfos)
						set response.AddOrdersRp=AddOrdersRp
						goto FailResponse
					}
				
					// 2021-02-19
					s SavePrescNo=##class(web.DHCOEOrdItem).SavePrescNo(OEORDItemID1,DPrescNo)
					s SavePrescPat=##class(User.DHCDrugaddress).save(Adm,patDr,Consignee,SendAddress,SendTel,PrescNo1)
					if (SavePrescNo'=0)||(SavePrescPat'=0)
					{
						set responseBody.ResultCode = "-1"
						set responseBody.ResultContent = "失败"_SavePrescNo_"^"_SavePrescPat
						set Response.Respbody = responseBody
						do Response.XMLExportToStream(.xml)
						q xml
					}
					else
					{
						set count = $l(ResultInfo,"^")
						set (OEORDItemID,OEORDID) = ""
						for i = 1:1:count {
							set OEORIInfos = ##class(web.DHCENS.STBLL.ORDER.MODEL.RespOrder).%New()
							set valueStr = $p(ResultInfo,"^",i)
							set OEORDItemID = $p(valueStr,"*",2)
							set OEORDID = $p(valueStr,"*",1)
							set Oeord=$p(OEORDItemID,"||",1)
							set OeOrdSub=$p(OEORDItemID,"||",2)
							continue:Oeord=""
							set PrescNo=$p($g(^OEORD(Oeord,"I",OeOrdSub,1)),"^",14)					
							set OEORIInfos.HISOEORIOrderItemID=OEORDItemID
							set OEORIInfos.OEORIOrderItemID=OEORDID
							set OEORIInfos.PrescNo=PrescNo
							d respBodyList.OEORIInfos.Insert(OEORIInfos)
					}
					
				}
			}
			else 
			{	
			}
	}			
	set responseBody.AddOrdersRp = respBodyList
	set responseBody.ResultCode = "0"
	set responseBody.ResultContent = "成功"
	set Response.Respbody = responseBody
	do Response.XMLExportToStream(.xml)
	q xml
}
FailResponse
	q response
Exception	

	set Response=##class(web.DHCENS.STBLL.ORDER.MODEL.Response).%New()
	set header=##class(web.DHCENS.STBLL.ORDER.MODEL.Header).%New()
	set header.SourceSystem="02"
	set header.MessageID=##class(web.DHCENS.STBLL.UTIL.Common).CreateMessageID(+$h)
	set Response.header=header
	set responseBody=##class(web.DHCENS.STBLL.ORDER.MODEL.Respbody).%New()	
	set responseBody.ResultCode="-1"
	set responseBody.ResultContent=$ze
	set Response.Respbody=responseBody
	do Response.XMLExportToStream(.xml)
	q xml
}

}
