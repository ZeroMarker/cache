Class EMRservice.Ajax.logdetailrecord Extends %CSP.Page
{

ClassMethod OnPreHTTP() As %Boolean [ ServerOnly = 1 ]
{
	i ##Class(websys.SessionEvents).SessionExpired() q 1
	q 1
}

ClassMethod OnPage() As %Status
{
    s action = $Get(%request.Data("Action",1),"")
    s episodeId = $Get(%request.Data("EpisodeID",1),"")
    s emrDocId = $Get(%request.Data("EMRDocID",1),"")
    s emrNum = $Get(%request.Data("EMRNum",1),"")
    
    //日志明细
	if (action = "getDetialLog")
	{
		w ..GetDetailLog(episodeId,emrDocId,emrNum)
	}
	elseif (action = "getAllLog")
	{
		w ..getAllLog(episodeId)
	}
	
	Quit $$$OK
}

/// 日志操作记录明细
/// w ##Class(EMRservice.Ajax.logdetailrecord).GetDetailLog(441,56,1)
ClassMethod GetDetailLog(argEpisodeID As %String, argDocID As %String, argEMRNum As %String)
{
	s ds = ##Class(%Library.ResultSet).%New("EMRservice.BL.BLEMRLogs:GetDetialLog")
	d ds.Execute(argEpisodeID,argDocID,argEMRNum)
	s json = ""
	s count = 0
	While (ds.Next())
	{
		s:(count '=0) json = json_","
		s json = json_"{"
		s json = json_"""OrderID"":"""_ds.Data("OrderID")_""","
		s json = json_"""LoginUserName"":"""_ds.Data("LoginUser")_""","
		s json = json_"""OperUserName"":"""_ds.Data("OperUser")_""","
		s json = json_"""OperDate"":"""_##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Date",ds.Data("OperDate"))_""","
		s json = json_"""OperTime"":"""_##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Time",ds.Data("OperTime"))_""","
		s json = json_"""MachineIP"":"""_ds.Data("MachineIP")_""","
		if (ds.Data("Action") = "打印")
		{
			s actionName = ##Class(EMRservice.BL.BLOperationNameBasedProduct).GetOperationName("print",ds.Data("ProductSourceCode"))
			s:(actionName = "") actionName = "已打印"
			s json = json_"""Action"":"""_actionName_""","
		}else{
			s json = json_"""Action"":"""_ds.Data("Action")_""","
		}
		s json = json_"""TplName"":"""_ds.Data("TplName")_""","
		s json = json_"""CASignID"":"""_ds.Data("CASignID")_""","
		s json = json_"""ProductSource"":"""_ds.Data("ProductSource")_""","
		s json = json_"""TplCreateDate"":"""_##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Date",ds.Data("TplCreateDate"))_""","
        s json = json_"""TplCreateTime"":"""_##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Time",ds.Data("TplCreateTime"))_""","
        s json = json_"""TplHappenDate"":"""_##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Date",ds.Data("TplHappenDate"))_""","
        s json = json_"""TplHappenTime"":"""_##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Time",ds.Data("TplHappenTime"))_""""
		s json = json_"}"
		s count = count + 1
	}
	//s json = "{""total"":"_count_",""rows"":["_json_"]}"
	s json = "["_json_"]"
	q json
}

/// w ##Class(EMRservice.Ajax.logdetailrecord).getAllLog(8651)
ClassMethod getAllLog(adm As %String) As %String
{
	s ret = "", count = 0
	q:(""=adm) ret
	Set langid=20
	if ($d(%session)){
		set langid=+$g(%session.Data("LOGON.LANGID"))
	}
	s CategoryID = ""
	for {
		s CategoryID = $O(^DHCEMRI.ECRecordI("IdxEpisodeIDCategoryID", adm, CategoryID))
		q:(""=CategoryID)
		
		s ECRecordId = ""
		for {
			s ECRecordId = $O(^DHCEMRI.ECRecordI("IdxEpisodeIDCategoryID", adm, CategoryID, ECRecordId))
			q:(ECRecordId="")
			
			s ECRecord = ##Class(EMRinstance.ECRecord).%OpenId(ECRecordId)
			s incCount = ECRecord.Instances.Count()
			s idx = 0
			while (idx < incCount + 1) {
				s Instance = ECRecord.Instances.GetNext(.idx)
				q:(""=idx)
				continue:(""=Instance)||("UnSave"=Instance.Status)
				s EMRDocID = ECRecord.RealChartItemID
				s EMRNum = Instance.ListNo
				s EMRLogsId = $O(^DHCEMRI.EMRLogsI("IdxMain",adm,EMRDocID, EMRNum, "")) 
				continue:(""=EMRLogsId)
				
				s EMRLogs = ##Class(EMRinstance.EMRLogs).%OpenId(EMRLogsId)
				s insLogId = ""
			 	for {
			    	s insLogId = $o(^DHCEMRI.InstanceLogI("IdxParRef", EMRLogsId, insLogId))
			    	q:(insLogId = "")
			    	s rowId = EMRLogsId_"||"_insLogId
			    	s InstanceLog = ##Class(EMRinstance.InstanceLog).%OpenId(rowId)
			    	
					s operUserName = InstanceLog.OperateUserName
					s operUserName = ##Class(EMRservice.HISInterface.Translation).GetTranByDesc("User.SSUser","SSUSRName",InstanceLog.OperateUserName,langid)
					s loginUserName = InstanceLog.LoginUserName
					s loginUserName = ##Class(EMRservice.HISInterface.Translation).GetTranByDesc("User.SSUser","SSUSRName",InstanceLog.LoginUserName,langid)
					s operDate = InstanceLog.OperateDate
					s:(operDate '= "") operDate = $zd(operDate,3)
					s operTime = InstanceLog.OperateTime
					s:(operTime '= "") operTime = $zt(operTime,1)
					s machineIP = InstanceLog.OperateMachineIP
					s EMRSignLogID = InstanceLog.EMRSignLogID
    				s caSignID=""
    				if (EMRSignLogID'="")
    				{
	    				s isSignValid=0
	    				s signLogObj = ##Class(EMRinstance.EMRSignLog).%OpenId(EMRSignID)
	    				s:(signLogObj'="") isSignValid = signLogObj.isSignValid
	    				s:(signLogObj'="")&(isSignValid=1) caSignID = signLogObj.SignID
	    			}  
					s action = InstanceLog.Action
					s actionName = ##Class(EMRservice.BL.BLEMRAction).GetActionNameByCode(action)
                    s tplName = "",tplCreateDate = "",tplCreateTime = "",tplHappenDate="",tplHappenTime=""
					s tplName = ##Class(EMRservice.HISInterface.Translation).GetTranByDesc("EMRinstance.InstanceData","Title",Instance.Title,langid)
                    s tplCreateDate = $case(Instance.CreateDate,"":"",:$zd(Instance.CreateDate,3))
                    s tplCreateTime = $case(Instance.CreateTime,"":"",:$zt(Instance.CreateTime))
                    s tplHappenDate = $case(Instance.HappenDate,"":"",:$zd(Instance.HappenDate,3))
                    s tplHappenTime = $case(Instance.HappenTime,"":"",:$zt(Instance.HappenTime))
					s productSourceCode = InstanceLog.ProductSource
					if (action = "print")
					{
						s actionName = ##Class(EMRservice.BL.BLOperationNameBasedProduct).GetOperationName(action,productSourceCode)
						s:(actionName = "") actionName = "已打印"
					}
					if (productSourceCode = "")
					{
						s productSource = ##Class(EMRservice.HISInterface.Translation).GetTranByDesc("EMRmeta.Products","ProductName","电子病历",langid)
					}
					else
					{
						s productId = $O(^DHCEMRM.ProductsI("IdxProductCode"," "_$zcvt(productSourceCode,"U"),""))
				    	continue:(productId = "")
				    	s objProduct = ##Class(EMRmeta.Products).%OpenId(productId)
				    	s productSource = ##Class(EMRservice.HISInterface.Translation).GetTranByDesc("EMRmeta.Products","ProductName",objProduct.ProductName,langid)
					}
					s count = count + 1
					s json = "{"
					s json = json_"""OrderID"":"""_count_""","
					s json = json_"""LoginUserName"":"""_loginUserName_""","
					s json = json_"""OperUserName"":"""_operUserName_""","
					s json = json_"""OperDate"":"""_##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Date",operDate)_""","
					s json = json_"""OperTime"":"""_##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Time",operTime)_""","
					s json = json_"""MachineIP"":"""_machineIP_""","
					s json = json_"""Action"":"""_actionName_""","
					s json = json_"""TplName"":"""_tplName_""","
					s json = json_"""CASignID"":"""_caSignID_""","
					s json = json_"""ProductSource"":"""_productSource_""","
					s json = json_"""TplCreateDate"":"""_##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Date",tplCreateDate)_""","
                    s json = json_"""TplCreateTime"":"""_##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Time",tplCreateTime)_""","
                    s json = json_"""TplHappenDate"":"""_##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Date",tplHappenDate)_""","
                    s json = json_"""TplHappenTime"":"""_##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Time",tplHappenTime)_""""
					s json = json_"}"							
			    	
			    	if (""=ret) { s ret = json }
			    	else { s ret = ret_","_json }
			 	}
			}
			
		}
	}
	
	q "["_ret_"]"
}

}
