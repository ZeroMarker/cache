/// Creator:Candyxu
/// CreateDate:2012-08
/// Desc:知情同意书web层
Class EPRservice.BORecordScan Extends %SOAP.WebService [ ProcedureBlock ]
{

/// TODO: change this to actual network address.
/// URL for invoking the WebService.
/// Parameter LOCATION = "http://localhost/trakcarelive/trak/web";
/// TODO: change this to actual SOAP namespace.
/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/metaservice";

/// Name of the WebService. 
Parameter SERVICENAME = "RecordScanInfo";

ClassMethod GetPatientList(AStartDate As %String, AStartTime As %String, AEndDate As %String, AEndTime As %String, AWard As %String, APatientNo As %String, APatientName As %String, ALocID As %String, ADoctor As %String, AAdmVStatus As %String, AAdmType As %String, AMedicare As %String) As EPRservice.dataset.EPatientListDataset [ WebMethod ]
{
	s result = ##class(EPRservice.dataset.EPatientListDataset).%New()
	d result.SetArgs(AStartDate,AStartTime,AEndDate,AEndTime,AWard,APatientNo,APatientName,ALocID,ADoctor,AAdmVStatus,AAdmType,AMedicare)
	q result
}

/// Desc:病区
/// Creator :Candyxu
/// Create Date: 2012-08
/// Input:ALocID
/// OutPut:病区列表
/// Debug:d ##Class(EPRservice.BORecordScan).GetWardList("")
ClassMethod GetWardList(ALocID As %String, ALocName As %String) As EPRservice.dataset.EWardListDataset [ WebMethod ]
{
	if ALocID = $c(0) s ALocID = ""
	if ALocName = $c(0) s ALocName = ""
	s result = ##Class(EPRservice.dataset.EWardListDataset).%New()
	d result.SetArgs("W",ALocID,ALocName)
	q result
}

/// Desc:科室
/// Creator :Candyxu
/// Create Date: 2012-08
/// Input:ALocID
/// OutPut:科室列表
ClassMethod GetLocList(ALocID As %String) As EPRservice.dataset.EWardListDataset [ WebMethod ]
{
	s:( ALocID = $c(0)) ALocID = ""
	s result = ##Class(EPRservice.dataset.EWardListDataset).%New()
	d result.SetArgs("E",ALocID)
	q result
}

/// Desc:医生
/// Creator : Candyxu 
/// Create Date:2012-08
/// Input:AUserName,ALocID
/// OutPut:医生列表
ClassMethod GetDocList(ALocID As %String) As EPRservice.dataset.EDoctorListDataset [ WebMethod ]
{
	if ALocID = $c(0) s ALocID = ""
	s result = ##Class(EPRservice.dataset.EDoctorListDataset).%New()
	d result.SetArgs(ALocID)
	q result
}

/// Desc:保存图片信息(知情同意书)
/// Creator:Candyxu
/// Create Date 2012-08
/// Input : AERecordScan  持久化类对应entity
/// OutPut :成功返回其ID,否则返回空
/// Degbu : w ##Class(EPRservice.BORecordScan).SaveRecordScan("")
ClassMethod SaveRecordScan(AERecordScan As EPRservice.entity.ERecordScan) As %String [ WebMethod ]
{
	s RowID = ""
	s obj = ##Class(EPRinstance.RecordScan).%New()
	q:(obj = "")
	s obj.Name = AERecordScan.Name
	s obj.Description =  AERecordScan.Description
	s obj.Postion = AERecordScan.Postion
	s obj.ParentID = AERecordScan.ParentID
	s obj.UserID = AERecordScan.UserID
	s obj.PatientID = AERecordScan.PatientID
	s obj.EpisodeID = AERecordScan.EpisodeID
	s obj.AliasName = AERecordScan.AliasName
	s sc = obj.%Save() 
	if $$$ISOK(sc)
	{
	   s RowID = obj.%Id()
	   &sql(update EPRinstance.RecordScan set Sequence = :RowID where ID = :RowID )
	}
	d obj.%Close()
	s obj = ""
	q RowID
ERROR
   s ErrorMsg = $ZE
   TROLLBACK
   q "<ERROR>"
}

/// Desc: 查询EPRinstance.RecordScan 
/// Creator:Candyxu
/// Create Date:2012-08
/// Input :PParentID 父节点，PPatientID 病人PatientID，PEpisodeID 就诊ID
/// Output: 符合查询条件表信息
ClassMethod GetRecordScanList(AParentID As %String, APatientID As %String, AEpisodeID As %String) As EPRservice.dataset.ERecordScanTreeDataset [ WebMethod ]
{
	if AParentID = $c(0) s AParentID = ""
	if APatientID = $c(0) s APatientID = ""
	if AEpisodeID = $c(0) s AEpisodeID = ""
	s result = ##Class(EPRservice.dataset.ERecordScanTreeDataset).%New()
	d result.SetArgs(AParentID,APatientID,AEpisodeID)
	q result
}

/// Desc:修改EPRinstance.RecordScan 修改其图片FTP存储位置
/// Creator:Candyxu
/// Create Date:2012-08
/// Input :AID 表ROWID,  AERecordScan entity 表
/// Return :ID 成功，-1 失败
ClassMethod UpdateRecordScan(AID As %String, AERecordScan As EPRservice.entity.ERecordScan) As %String [ WebMethod ]
{
	q:((AID = "")||(AID = $c(0)))
	s obj = ##Class(EPRinstance.RecordScan).%OpenId(AID)
	q:(obj = "")
	s obj.Name = AERecordScan.Name
	s obj.Description = AERecordScan.Description
	if (( AERecordScan.Postion '= "") && ( AERecordScan.Postion '= $c(0))) 	s obj.Postion = AERecordScan.Postion
	s obj.UserID = AERecordScan.UserID
	s obj.ParentID = AERecordScan.ParentID
	s sc = obj.%Save()
	if $system.Status.IsError(sc) {                               //检查Save是否成功
   		d $system.OBJ.DisplayError(sc) 
   		s id=-1
	}
	else{
		s id=obj.%Id()
		}
	d obj.%Close()
	q id
}

/// Desc:删除EPRinstance.RecordScan存储数据
/// Creator:Candyxu
/// Creator:2012-08-13
/// Input:AID :EPRinstance.RecordScan 的ROWID，AParentID：其父节点
/// Return:1 成功,0 失败
/// Debug: w ##Class(EPRservice.BORecordScan).DeleteRecordScan(1,152)
ClassMethod DeleteRecordScan(AID As %String, AParentID As %String) As %String [ WebMethod ]
{
	q:((AID = "") ||(AID = $c(0)) || (AParentID = "")||(AParentID = $c(0))) "0"
	s obj = ##Class(EPRinstance.RecordScan).%OpenId(AID)
	q:(obj = "") "0"
	TSTART
	s sc = obj.%DeleteId(AID)
	d obj.%Close()
	if $$$ISOK(sc)
	{
	   &sql(update EPRmeta.TemplateCategory set ResChildCount = ResChildCount -1 where ID = :AParentID)
	   if (SQLCODE = 0)
	   {
		   TCOMMIT
		   q "1"
	   } 
	   else
	   {
		   TROLLBACK
		   q "0"
	   }
	}else
	{
		q "0"
	}
}

/// Creator:Candyxu
/// Create Date:2012-09-28
/// Desc:  修改顺序
ClassMethod SwapSquence(AID1 As %String, AID2 As %String) As %String [ WebMethod ]
{
	if AID1 = $c(0) s AID1 = ""
	if AID2 = $c(0) s AID2 = ""
	q:((AID1 = "") ||( AID2 = ""))
	s obj1 = ##Class(EPRinstance.RecordScan).%OpenId(AID1)
	s obj2 = ##Class(EPRinstance.RecordScan).%OpenId(AID2)
	s TempSequence = obj1.Sequence
	s obj1.Sequence = obj2.Sequence
	s obj2.Sequence = TempSequence
	s $ZT = "SEQUEERROR"
	TStart
	s sc1 = obj1.%Save()
	if $$$ISOK(sc1)
	{
		s sc2 = obj2.%Save()
		if $$$ISOK(sc2)
		{
			TCOMMIT
			q "1"
		}else
		{
			TROLLBACK
			q "0"
		}
	}
    d obj1.%Close()
    d obj2.%Close()
SEQUEERROR
   s ErrorMsg = $ZE
   TROLLBACK
   q "<SEQUEERROR>"
}

/// Desc:取PDF存储服务器地址
ClassMethod GetPdfFtp(AName As %String) As %String [ WebMethod ]
{
	q ##Class(DHCEPRFS.Srv.SrvSysOption).GetValueByName(AName)
}

}
