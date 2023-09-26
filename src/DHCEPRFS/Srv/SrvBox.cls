Class DHCEPRFS.Srv.SrvBox Extends %SOAP.WebService [ ClassType = "", ProcedureBlock ]
{

/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/dhceprfsservice";

/// Name of the WebService.
Parameter SERVICENAME = "SrvBox";

/// 获取箱就诊列表
ClassMethod GetMREpisodeListByBoxID(ABoxID As %String) As DHCEPRFS.DataSet.EBoxMREpisodeListDS [ WebMethod ]
{
	s dataset = ##class(DHCEPRFS.DataSet.EBoxMREpisodeListDS).%New()
	d dataset.SetArgs(ABoxID)
	q dataset
}

/// 获取生成成功列表
ClassMethod GetBoxListByStatus(AStatus As %String = "") As DHCEPRFS.DataSet.EBoxListDS [ WebMethod ]
{
	s dataset = ##class(DHCEPRFS.DataSet.EBoxListDS).%New()
	d dataset.SetArgs(AStatus)
	q dataset
}

/// 以就诊或病案查询箱
ClassMethod GetBoxInfo(AEpisodeID As %String, AMedRecordNo As %String) As DHCEPRFS.DataSet.EBoxInfoDS [ WebMethod ]
{
	s dataset = ##class(DHCEPRFS.DataSet.EBoxInfoDS).%New()
	d dataset.SetArgs(AEpisodeID, AMedRecordNo)
	q dataset
}

ClassMethod AddNewBox(ABoxName As %String, ABoxCode As %String, ABoxDesc As %String, ABoxLocationCode As %String, ABoxLocationDesc As %String, ABoxTag As %String, ABoxBarCode As %String, AUserID As %String) As %String [ WebMethod ]
{
	s ret = ##class(DHCEPRFS.BL.BLBox).AddNewBox(ABoxName,ABoxCode,ABoxDesc,ABoxLocationCode,ABoxLocationDesc,ABoxTag,ABoxBarCode,AUserID)
	q ret
}

ClassMethod ModifyBox(ABoxName As %String, ABoxCode As %String, ABoxDesc As %String, ABoxLocationCode As %String, ABoxLocationDesc As %String, ABoxTag As %String, ABoxBarCode As %String, AUserID As %String) As %String [ WebMethod ]
{
	s ret = ##class(DHCEPRFS.BL.BLBox).ModifyBox(ABoxName,ABoxCode,ABoxDesc,ABoxLocationCode,ABoxLocationDesc,ABoxTag,ABoxBarCode,AUserID)
	q ret
}

ClassMethod AddEpisode2Box(ABoxID As %String, AMREpisodeID As %String, AActUserID As %String) As %String [ WebMethod ]
{
	s ret = ##class(DHCEPRFS.BL.BLBox).AddEpisode2Box(ABoxID,AMREpisodeID,AActUserID)
	q ret
}

ClassMethod ModifyEpisode2Box(ABoxID As %String, AMREpisodeID As %String, AActUserID As %String) As %String [ WebMethod ]
{
	s ret = ##class(DHCEPRFS.BL.BLBox).ModifyEpisode2Box(ABoxID,AMREpisodeID,AActUserID)
	q ret
}

ClassMethod SealBox(ABoxID As %String, AActUserID As %String) As %String [ WebMethod ]
{
	s ret = ##class(DHCEPRFS.BL.BLBox).SealBox(ABoxID,AActUserID)
	q ret
}

}
