/// 名称：		EMRservice.InterfaceService.PrescriptionDatas
/// 描述：		肿瘤规范化诊疗及费用合理接口
/// 编写者：	yejian
/// 编写时间：	2021-11-9
Class EMRservice.InterfaceService.PrescriptionDatas Extends (%RegisteredObject, %XML.Adaptor)
{

/// Desc:      发送病历数据
/// Creator:    yejian
/// CreateDate: 2021-11-9
/// Input:      argArray  命令参数
///             argInData 传入数据
/// OutPut:     1 成功，0 失败
/// Debug: w ##Class(EMRservice.InterfaceService.PrescriptionDatas).SetPrescriptnData("339||1")
ClassMethod SetPrescriptnData(aInstanceID As %String) As %String
{
	s $zt = "Error"
	s strRes = "1"
	q:(aInstanceID="") strRes
	//s ^tempSetPrescriptnData("123")=aInstanceID
	s objInstance = ##class(EMRinstance.InstanceData).%OpenId(aInstanceID)
	q:(objInstance="") strRes
	s strSysPres = ##Class(EMRservice.BL.BLSysOption).GetOptionValueByName2("PrescriptnData","{""ISPost"":""0""}")
	s objJson = ##class(%DynamicAbstractObject).%FromJSON(strSysPres)
	//推送开关关闭则退出
	q:((objJson="")||(objJson.ISPost="0")) strRes
	s strTemID = "^"_objInstance.TemplateID_"^"
	q:((objJson.EMR09'[strTemID)&&(objJson.EMR10'[strTemID)&&(objJson.EMR12'[strTemID)) strRes
	
	s request = ##class(%Net.HttpRequest).%New()
	s request.Timeout = 10
	s request.Server = "127.0.0.1"
	s request.Port = "80"
	s request.ContentType="text/html; charset=UTF-8"
	s request.ContentType="application/json"
	//编码格式
	s request.ContentCharset = "UTF-8" 
	s url="http://114.116.206.123/imedical/web/BSP.GlobalPhrases.BL.InputToolMessageService.cls?CacheNoRedirect=1&CacheUserName=_system&CachePassword=sys"
    
	
	if (objJson.EMR09[strTemID) //入院记录	
	{
		d request.EntityBody.Write("{")
		//入院记录
		s data = ##Class(EMRservice.BL.Interface.TumourStandardInfo).GetAdmRecordInfoByID(aInstanceID)
		s strData ="data:"_data.Read() 
		d request.EntityBody.Write(strData)
		d request.EntityBody.Write(",")
		//入院记录诊断
		s dataDiag = ##Class(EMRservice.BL.Interface.TumourStandardInfo).GetAdmRecordDiagInfoByID(aInstanceID)
		s strDataDiag = "diag:"_dataDiag.Read()
		d request.EntityBody.Write(strDataDiag)
		d request.EntityBody.Write("}")
	}
	elseif(objJson.EMR10[strTemID) //病程记录
	{
		d request.EntityBody.Write("{")
		//病程记录
		s data = ##Class(EMRservice.BL.Interface.TumourStandardInfo).GetCourseRecordInfoByID(aInstanceID)
		s strData ="data:"_data.Read() 
		d request.EntityBody.Write(strData)
		d request.EntityBody.Write("}")
	}
	elseif(objJson.EMR12[strTemID) //出院记录
	{
		d request.EntityBody.Write("{")
		//出院记录
		s data = ##Class(EMRservice.BL.Interface.TumourStandardInfo).GetDischargeRecordInfoByID(aInstanceID)
		s strData ="data:"_data.Read() 
		d request.EntityBody.Write(strData)
		d request.EntityBody.Write(",")
		//诊断
		s dataDiag = ##Class(EMRservice.BL.Interface.TumourStandardInfo).GetDischargeRecordDiagInfoByID(aInstanceID)
		s strDataDiag = "diag:"_dataDiag.Read()
		d request.EntityBody.Write(strDataDiag)
		d request.EntityBody.Write("}")
	}
	else
	{
		q strRes
	}

	s flg=request.Post(url)
	if $system.Status.IsError(flg) {
		s Error = $system.Status.GetErrorText(flg)
		if (Error["#6059")
		{
			 s Error = "网络异常。"_Error
		}
		s strRes = "0"
		q strRes
		//q "{""status"":"""_$system.Status.GetErrorCodes(flg)_""",""message"":"""_Error_"""}"
	}
	/*
	s Data=request.HttpResponse.Data
	s strData=""
	While 'Data.AtEnd {
		s strData=strData_Data.Read(5000)
	}
	*/
	q strRes
Error
	q "0"
}

}
