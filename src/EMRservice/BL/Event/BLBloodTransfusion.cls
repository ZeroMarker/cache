/// Desc:       输血事件逻辑类
/// Creator:    Candy
/// CreateDate: 2015-3-25 
Class EMRservice.BL.Event.BLBloodTransfusion Extends (%RegisteredObject, %XML.Adaptor)
{

/// Desc:       输血记录
/// Creator:    Candy
/// CreateDate: 2015-3-23
/// Input:      APatientID 病人ID
///             AEpisodeID 就诊号
///             AOEordItemID 输血医嘱
///             ATransDate (cache内部格式) 输血日期
///             ATransTime (cache内部格式) 输血时间
///             ABloodTypeabo abo型血
///             ABloodTyperh rh型血
///             AContent 申请内容
///             ADescription 描述
/// Output:     result 1成功 0失败
/// Debug:      w ##Class(EMRservice.BL.Event.BLBloodTransfusion).SetData(48,76,"1||1","身体检查",63634,36676,"O","N","test","testDesc")
ClassMethod SetData(APatientID As %String, AEpisodeID As %String, AOEordItemID As %String, AOEordItemDesc As %String, ATransDate As %String, ATransTime As %String, ABloodTypeabo As %String, ABloodTyperh As %String, AContent As %String, ADescription As %String, ABloodID As %String = "") As %String
{
		s result = "0"
		q:(APatientID = "")||(AEpisodeID = "")||((AOEordItemID = "")&&(ABloodID = "")) result
		s obj = ##Class(EMRinstance.Events.BloodTransfusion).%New()
		s obj.PatientID = APatientID
		s obj.EpisodeID = AEpisodeID
		s obj.BloodTypeabo = ABloodTypeabo
		s obj.BloodTyperh = ABloodTyperh
		s obj.Content = AContent
		s obj.Description = ADescription
		s obj.OEordItemID = AOEordItemID
		s obj.OEordItemDesc = AOEordItemDesc
		s obj.TransDate = ATransDate
		s obj.TransTime = ATransTime
		s obj.CreateDate = $p($h,",",1)
		s obj.CreateTime = $p($h,",",2)
		s obj.IsActive = "Y"
		s obj.BloodID = ABloodID	
		s sc = obj.%Save()
		s:($$$ISOK(sc)) result = "1"
		q result
}

/// Desc:        取输血记录
/// Creator:     Candy
/// CreateDate:  2013-3-23
/// Input:       AEpisodeID 就诊ID
/// Output:      result 
/// Debug:       w ##Class(EMRservice.BL.Event.BLBloodTransfusion).GetData(76)
ClassMethod GetData(AEpisodeID As %String) As %String
{
	s result = ""
	s count = 0
	q:(AEpisodeID = "") result
	s flag = ""
	for
	{
		s flag = $o(^DHCEMRI.Events.BloodI("IdxEpisodeIsActive"," "_AEpisodeID,flag),-1)
		q:(flag = "")
		s date = ""
		for
		{
		    s date = $o(^DHCEMRI.Events.BloodI("IdxEpisodeIsActive"," "_AEpisodeID,flag,date),-1)
		    q:(date = "")
		    s time = ""
		    for
		    {
		    	s time = $o(^DHCEMRI.Events.BloodI("IdxEpisodeIsActive"," "_AEpisodeID,flag,date,time),-1)
		    	q:(time = "")
		    	s rowId = "" 
			    for
			    {
			    	s rowId = $o(^DHCEMRI.Events.BloodI("IdxEpisodeIsActive"," "_AEpisodeID,flag,date,time,rowId))
			    	q:(rowId = "")
			    	s obj = ##Class(EMRinstance.Events.BloodTransfusion).%OpenId(rowId)
			    	continue:(obj = "")
			    	
			    	s textField = obj.OEordItemDesc
			    	
			    	s:(count '= 0) result = result_","
			    	s result = result_"{"
			    	s result = result_"""ID"":"""_rowId_""""
			    	s result = result_",""BloodTypeabo"":"""_obj.BloodTypeabo_""""
			    	s result = result_",""BloodTyperh"":"""_obj.BloodTyperh_""""
			    	s result = result_",""Content"":"""_obj.Content_""""
			    	s result = result_",""Description"":"""_obj.Description_""""
			    	s result = result_",""OEordItemID"":"""_obj.OEordItemID_""""
			    	s result = result_",""OEordItemDesc"":"""_obj.OEordItemDesc_""""
			    	s result = result_",""TransDate"":"""_##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Date",$zd(obj.TransDate,3))_""""
			    	s result = result_",""TransTime"":"""_##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Time",$zt(obj.TransTime))_""""
			    	s result = result_",""TextField"":"""_textField_""""
			    	s result = result_",""IsActive"":"""_$case(obj.IsActive,"Y":"提示",:"不提示")_""""
			    	s result = result_"}"
			    	s count = count + 1
				}
		    }
		}			
	}
	q result
}

/// Desc:       更改已完成状态并关联病历
/// Creator:    Candy
/// CreateDate: 2015-3-25
/// Input:      AIDs 以","分隔
///             AEpisodeID 就诊号
/// OutPut:     result 
ClassMethod SetFinish(AIDs As %String, AInstanceID As %String) As %String
{
	s result = "0"
	q:(AIDs = "") result
	d ..SetUnActive(AIDs)
	for i=1:1:$l(AIDs,"@")
	{
		s rowId = $p(AIDs,"@",i)
		continue:(rowId = "")
		s result = ##Class(EMRservice.BL.Event.BLLinkDocument).SaveLinkDocumnet(AInstanceID,"BloodTransfusion",rowId)
        q:(result = "0")
	}
	q result
}

/// Desc:       设置条目不再提示
/// Creator:    Candy
/// CreateDate: 2015-4-8
/// Input:      AID 表的rowID
/// Output:     result 1成功 0失败
ClassMethod SetUnActive(AIDs As %String) As %String
{
	s result = "0"
	q:(AIDs = "") result
	for i=1:1:$l(AIDs,"@")
	{
		s id = $p(AIDs,"@",i)
		s obj = ##Class(EMRinstance.Events.BloodTransfusion).%OpenId(id)
		continue:(obj = "")
		s obj.IsActive = "N"
		s:($$$ISOK(obj.%Save())) result = "1"
		q:(result = "0")
	}
	q result
}

/// Desc:保存输血ID与instanceID关系
/// Creator:Donglulu
/// CreateDate:2019-1-15
ClassMethod SaveDataLink(ABloodID As %String, AInstanceID As %String) As %String
{
	s result = "0"
	q:(ABloodID = "")||(AInstanceID = "") result
	
	s objInstance = ##Class(EMRinstance.InstanceData).%OpenId(AInstanceID)
	q:(objInstance = "") result
	s epsiodeId = objInstance.TheECRecord.RealEpisodeID
	q:(epsiodeId = "") result
	
	s patientID = $P($g(^PAADM(epsiodeId)),"^",1)
	
	s eventID = $o(^DHCEMRI.Events.BloodI("IdxBloodID"," "_ABloodID,""))
	if (eventID = "")
	{
		TStart
		
		s dataFlag = ##Class(EMRservice.BL.Event.BLBloodTransfusion).SetData(patientID, epsiodeId, "", "", "", "", "", "", "", "", ABloodID)
		if (dataFlag '= "1")
		{
			TRollback
			q result
		}
		
		s eventID = $o(^DHCEMRI.Events.BloodI("IdxBloodID"," "_ABloodID,""))
		if (eventID = "")
		{
			TRollback
			q result
		}
		
		s linkFlag = ##Class(EMRservice.BL.Event.BLBloodTransfusion).SetFinish(eventID,AInstanceID)
		if ((dataFlag = "1")&&(linkFlag = "1"))
		{
			TCommit
			s result = "1"
		}
		else
		{
			TRollback
		}
	}
	else
	{
		s result = ##Class(EMRservice.BL.Event.BLBloodTransfusion).ChangeLink(eventID,AInstanceID)
	}
	q result
}

/// Desc:取输血知情同意数据内容接口
/// Creator:Donglulu
/// CreateDate:2019-1-15
/// Input:      AInstanceID 病历实例ID
/// Output:     json串
/// Debug:      w ##Class(EMRservice.BL.Event.BLBloodTransfusion).GetInformedConsentContent("340||1")
ClassMethod GetInformedConsentContent(AInstanceID As %String) As %String
{
	s json = ""
	q:(AInstanceID = "") json 
	s objInstance = ##Class(EMRinstance.InstanceData).%OpenId(AInstanceID)
	q:(objInstance = "") json
	
	s epsiodeId = objInstance.TheECRecord.RealEpisodeID
	q:(epsiodeId = "") json
	
	s title = ##Class(EMRservice.Util.EscapeSpecialWord).JsonEscape(objInstance.Title)
	s docId = objInstance.TheECRecord.RealChartItemID
	s num = objInstance.ListNo
	s log = ##Class(EMRservice.BL.BLEMRLogs).GetLogStatus(epsiodeId,docId,num)
	s creator = $tr($p(log,"^",1)," ","")
	
	s happendate = objInstance.HappenDate
	s happentime = objInstance.HappenTime
	
	s signInfo = ""
	s signID = ""
	for
	{
		s signID = $o(^DHCEMRI.EMRSignI("IdxInstance"," "_AInstanceID,signID))
		q:(signID = "")
		
		s objSign = ##Class(EMRinstance.EMRSign).%OpenId(signID)
		q:(objSign = "")
		continue:(objSign.isSignValid '= "1")
		continue:(objSign.Action = "patientSign")
		
		s SignUser = objSign.UsrID
		s SignUser = ##class(EMRservice.BL.BLPowerUser).GetUserName(SignUser)
		s SignDate = objSign.SignDate
		s SignTime = objSign.SignTime
		
		s signInfo = signInfo_"""SignUser"":"""_SignUser_""","
		s signInfo = signInfo_"""SignDate"":"""_SignDate_""","
		s signInfo = signInfo_"""SignTime"":"""_SignTime_""","
	}
	
	if (signInfo = "")
	{
		s signInfo = signInfo_"""SignUser"":"""","
		s signInfo = signInfo_"""SignDate"":"""","
		s signInfo = signInfo_"""SignTime"":"""","
	}
	
	s transData = ##Class(EMRservice.BL.BLScatterData).GetNewStdDataByGlossary(epsiodeId,"HDSD00.10.03",AInstanceID)
	
	s SurName = transData.GetAt("HDSD00.10.016")
	s Sex = transData.GetAt("HDSD00.10.051")
	s Age = transData.GetAt("HDSD00.10.030")
	s AdmDateTime = transData.GetAt("HDSD00.10.100")
	s BedNo = transData.GetAt("HDSD00.10.001")
	s WardDR = transData.GetAt("HDSD00.10.004")
	s LocationDR = transData.GetAt("HDSD00.10.020")
	s Diagnosis = transData.GetAt("HDSD00.10.018")
	s IsTransHistory = transData.GetAt("HDSD00.10.043")
	s LastTransDate = transData.GetAt("HDSD00.10.101")
	s ISUntowardEffect = transData.GetAt("HDSD00.10.102")
	s UntowardEffectNote = transData.GetAt("HDSD00.10.103")
	s IsPregHistory = transData.GetAt("HDSD00.10.104")
	s Pregnancies = transData.GetAt("HDSD00.10.105")
	s ChildBirths = transData.GetAt("HDSD00.10.106")
	s ISDrugHistory = transData.GetAt("HDSD00.10.107")
	s DrugList = transData.GetAt("HDSD00.10.108")
	s IsKeestExplant = transData.GetAt("HDSD00.10.109")
	s KeestBloodGroupDR = transData.GetAt("HDSD00.10.110")
	s IsOrganExplant = transData.GetAt("HDSD00.10.111")
	s OrganBloodGroupDR = transData.GetAt("HDSD00.10.112")
	s TransfusionMode = transData.GetAt("HDSD00.10.039")
	s PurposeList = transData.GetAt("HDSD00.10.113")
	s ReqProductList = transData.GetAt("HDSD00.10.041")
	s NotifyContent = transData.GetAt("HDSD00.10.114")
	s NotifyRisk = transData.GetAt("HDSD00.10.115")
	s Remark = transData.GetAt("HDSD00.10.116")
	s ALT = transData.GetAt("HDSD00.10.117")
	s HBeAg = transData.GetAt("HDSD00.10.118")
	s HCVAb = transData.GetAt("HDSD00.10.119")
	s HBsAg = transData.GetAt("HDSD00.10.120")
	s HBeAb = transData.GetAt("HDSD00.10.121")
	s HIVAb = transData.GetAt("HDSD00.10.122")
	s HBsAb = transData.GetAt("HDSD00.10.123")
	s HBcAb = transData.GetAt("HDSD00.10.124")
	s TPAb = transData.GetAt("HDSD00.10.125")	
	
	s json = json_"{"
	s json = json_"""InstanceID"":"""_AInstanceID_""","
 	s json = json_"""Title"":"""_title_""","
 	s json = json_"""CreateUser"":"""_creator_""","
 	s json = json_"""HappenDate"":"""_happendate_""","
 	s json = json_"""HappenTime"":"""_happentime_""","
 	s json = json_signInfo
 	s json = json_"""HDSD00.10.016"":"""_SurName_""","
	s json = json_"""HDSD00.10.051"":"""_Sex_""","
 	s json = json_"""HDSD00.10.030"":"""_Age_""","
 	s json = json_"""HDSD00.10.100"":"""_AdmDateTime_""","
 	s json = json_"""HDSD00.10.001"":"""_BedNo_""","
 	s json = json_"""HDSD00.10.004"":"""_WardDR_""","
 	s json = json_"""HDSD00.10.020"":"""_LocationDR_""","
 	s json = json_"""HDSD00.10.018"":"""_Diagnosis_""","
 	s json = json_"""HDSD00.10.043"":"""_IsTransHistory_""","
 	s json = json_"""HDSD00.10.101"":"""_LastTransDate_""","
 	s json = json_"""HDSD00.10.102"":"""_ISUntowardEffect_""","
 	s json = json_"""HDSD00.10.103"":"""_UntowardEffectNote_""","
 	s json = json_"""HDSD00.10.104"":"""_IsPregHistory_""","
 	s json = json_"""HDSD00.10.105"":"""_Pregnancies_""","
 	s json = json_"""HDSD00.10.106"":"""_ChildBirths_""","
 	s json = json_"""HDSD00.10.107"":"""_ISDrugHistory_""","
 	s json = json_"""HDSD00.10.108"":"""_DrugList_""","
 	s json = json_"""HDSD00.10.109"":"""_IsKeestExplant_""","
 	s json = json_"""HDSD00.10.110"":"""_KeestBloodGroupDR_""","
 	s json = json_"""HDSD00.10.111"":"""_IsOrganExplant_""","
 	s json = json_"""HDSD00.10.112"":"""_OrganBloodGroupDR_""","
 	s json = json_"""HDSD00.10.039"":"""_TransfusionMode_""","
 	s json = json_"""HDSD00.10.113"":"""_PurposeList_""","
 	s json = json_"""HDSD00.10.041"":"""_ReqProductList_""","
 	s json = json_"""HDSD00.10.114"":"""_NotifyContent_""","
 	s json = json_"""HDSD00.10.115"":"""_NotifyRisk_""","
 	s json = json_"""HDSD00.10.116"":"""_Remark_""","
 	s json = json_"""HDSD00.10.117"":"""_ALT_""","
 	s json = json_"""HDSD00.10.118"":"""_HBeAg_""","
 	s json = json_"""HDSD00.10.119"":"""_HCVAb_""","
 	s json = json_"""HDSD00.10.120"":"""_HBsAg_""","
 	s json = json_"""HDSD00.10.121"":"""_HBeAb_""","
 	s json = json_"""HDSD00.10.122"":"""_HIVAb_""","
 	s json = json_"""HDSD00.10.123"":"""_HBsAb_""","
 	s json = json_"""HDSD00.10.124"":"""_HBcAb_""","
 	s json = json_"""HDSD00.10.125"":"""_TPAb_""""
 	s json = json_"}"
 	s json = $ZSTRIP(json,"*C")
	q json
}

/// Desc:修改输血ID与instanceID关系
/// Creator:Donglulu
/// CreateDate:2020-2-26
ClassMethod ChangeLink(AEventID As %String, AInstanceID As %String) As %String
{
	s result = "0"
	q:(AEventID = "")||(AInstanceID = "") result
	
	s objInstance = ##Class(EMRinstance.InstanceData).%OpenId(AInstanceID)
	q:(objInstance = "") result
	s episodeID = objInstance.RealEpisodeID
	q:(episodeID = "") result
	s instanceId = $o(^DHCEMRI.Events.LinkDocumnentsI("IdxMain"," "_episodeID," "_$zcvt("BloodTransfusion","U")," "_AEventID,""))
	q:(instanceId = "") result
	s linkId = $o(^DHCEMRI.Events.LinkDocumnentsI("IdxMain"," "_episodeID," "_$zcvt("BloodTransfusion","U")," "_AEventID,instanceId,""))
	q:(linkId = "") result
	s obj = ##Class(EMRinstance.Events.LinkDocumnents).%OpenId(linkId)
	s obj.InstanceID  = AInstanceID
    s obj.ChartItemID = objInstance.TheECRecord.RealChartItemID
    s obj.TitleCode = objInstance.TitleCode
    s:($$$ISOK(obj.%Save())) result = "1"
	q result
}

/// Desc:       设置条目再次提示
/// Creator:    王煜
/// CreateDate: 2021-09-07
/// Input:      AID 表的rowID
/// Output:     result 1成功 0失败
/// Debug:      w ##Class(EMRservice.BL.Event.BLBloodTransfusion).SetActive(1)
ClassMethod SetActive(AIDs As %String) As %String
{
	s result = "0"
	q:(AIDs = "") result
	for i=1:1:$l(AIDs,"@")
	{
		s id = $p(AIDs,"@",i)
		s obj = ##Class(EMRinstance.Events.BloodTransfusion).%OpenId(id)
		continue:(obj = "")
		s obj.IsActive = "Y"
		s:($$$ISOK(obj.%Save())) result = "1"
		q:(result = "0")
	}
	q result
}

}
