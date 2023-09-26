Class EMRservice.BL.BLAdmRecordStatusLog Extends (%RegisteredObject, %XML.Adaptor)
{

///  Creator:    Donglulu
///  CreateDate: 2019-04-18
///  Desc:       添加病历全部完成信息操作日志表数据
///  Input:      AUserID：操作人  AAction：操作动作  ARecordStatusID：EMRinstance.AdmRecordStatus的ID
///  			 AIPAddress:提交病历IP地址
///  			 AProductSource:产品模块来源（EMRmeta.Products的ProductCode字段）
///  			 ARemark:备注（原因等）
///  return:     result 1：成功  0：失败
///  Debug:      w ##Class(EMRservice.BL.BLAdmRecordStatusLog).AddData("230","","")
ClassMethod AddData(AUserID As %String, AAction As %String, ARecordStatusID As %String, AIPAddress As %String = "", AProductSource As %String = "", ARemark As %String = "", ACompletedStatus As %String = "") As %String
{
	s result = "0"
	q:(AUserID = "")||(AAction = "")||(ARecordStatusID = "") result
	s objLog = ##Class(EMRinstance.AdmRecordStatusLog).%New()
	s objLog.UserID = AUserID
	s objLog.Action = AAction 
	s objLog.RecordStatusID = ARecordStatusID
    s objLog.OperateDate = $p($h,",",1)
    s objLog.OperateTime = $p($h,",",2)
    s objLog.IPAddress = AIPAddress
    s objLog.ProductSource = AProductSource
    s objLog.Remark = ARemark
    s objLog.CompletedStatus = ACompletedStatus
    s sc = objLog.%Save()
    if ($$$ISOK(sc))
    {
	    s result = "1"
    }
    d objLog.%Close()	
	k objLog
	q result
}

///  Creator:    Donglulu
///  CreateDate: 2020-09-10
///  Desc:       获取病历全部完成信息操作日志表数据
///  Input:      AEpisodeID就诊号
///  return:     日志json
///  Debug:      w ##Class(EMRservice.BL.BLAdmRecordStatusLog).GetLogData("4")
ClassMethod GetLogData(AEpisodeID As %String) As %String
{
	s result = ""
	q:(AEpisodeID = "") result
	s json = ""
	s count = 0
	s AdmRecordStatusID = $o(^DHCEMRI.AdmRecordStatusI("IdxEpisodeID"," "_AEpisodeID,""))	
    q:(AdmRecordStatusID = "") result
    
    s logID = ""
    for
    {
    	s logID = $o(^DHCEMRI.AdmRecordStatusLogI("IdxRecordStatusID"," "_AdmRecordStatusID,logID))	
    	q:(logID = "")
    	s objLog = ##Class(EMRinstance.AdmRecordStatusLog).%OpenId(logID)
	    q:(objLog = "")
	    
	    s userName = ##Class(EMRservice.BL.BLPowerUser).GetUserName(objLog.UserID)
	    
	    s actionCode = objLog.Action
	    s actionID = $O(^DHCEMRM.ConfirmActionI("IdxActionCode"," "_$zcvt(actionCode,"U"),""))
	    continue:(actionID = "")
	    s objAction = ##Class(EMRmeta.ConfirmAction).%OpenId(actionID)
	    continue:(objAction = "")
	    s action = objAction.ActionName
	    
	    s productCode = objLog.ProductSource
		s productName = ""
		if (productCode '= "")
		{
			s productID = $O(^DHCEMRM.ProductsI("IdxProductCode"," "_$zcvt(productCode,"U"),""))
			continue:(productID = "")
			s objProduct = ##Class(EMRmeta.Products).%OpenId(productID)
			continue:(objProduct = "")
			s productName = objProduct.ProductName
		}
	    
	    s:(json '= "") json = json_"," 
	    s json = json_"{""EpisodeID"":"""_AEpisodeID_""","
	 	s json = json_"""Action"":"""_action_""","
	 	s json = json_"""IPAddress"":"""_objLog.IPAddress_""","
	 	s json = json_"""OperateDate"":"""_##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Date",objLog.OperateDate)_""","
	 	s json = json_"""OperateTime"":"""_##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Time",objLog.OperateTime)_""","
	 	s json = json_"""ProductSource"":"""_productName_""","
	 	s json = json_"""LogID"":"""_logID_""","
	 	s json = json_"""UserName"":"""_userName_""","
	 	s json = json_"""Remark"":"""_objLog.Remark_""","
	 	s json = json_"""Status"":"""_objLog.CompletedStatus_""","
	 	s json = json_"""RecordStatusID"":"""_objLog.RecordStatusID_"""}"	
	 	s count = count + 1
    }
	s json = $ZSTRIP(json,"*C")
	s:(json '= "") result = "["_json_"]"
	q result
}

}
