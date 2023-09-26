Class EPRservice.BOSelfPrint Extends %SOAP.WebService [ ProcedureBlock ]
{

/// TODO: change this to actual network address.
/// URL for invoking the WebService.
/// Parameter LOCATION = "http://localhost/trakcarelive/trak/web";
/// TODO: change this to actual SOAP namespace.
/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/metaservice";

/// Name of the WebService.
Parameter SERVICENAME = "SelfPrintInfo";

ClassMethod GetRegNoByCardNo(ACardNo As %String, ACardType As %String) As %String [ WebMethod ]
{
	s regNo = ##Class(EPRservice.BLL.BLSelfPrint).GetRegNoByCardNo(ACardNo,ACardType)
	q regNo
}

ClassMethod GetAdmListByRegNo(ARegNo As %String, AAdmType As %String, AUserID, ASelfPrintSchemeName) As EPRservice.dataset.SelfPrintAdmListDataset [ WebMethod ]
{
	s ds = ##Class(EPRservice.dataset.SelfPrintAdmListDataset).%New()
	d ds.SetArgs(ARegNo, AAdmType, AUserID, ASelfPrintSchemeName)
	q ds
}

ClassMethod GetPrintItem(AEpisodeID, AUserID, ASelfPrintSchemeName) As EPRservice.dataset.SelfPrintItemDetails [ WebMethod ]
{
	s ds = ##Class(EPRservice.dataset.SelfPrintItemDetails).%New()
	d ds.SetArgs(AEpisodeID, AUserID, ASelfPrintSchemeName)
	q ds
}

ClassMethod GetPageInfo(AUserID) As %String [ WebMethod ]
{
	s obj = ##class(EPRmeta.CentralizedPrint.CentralizedPrintInfo).%New()
	q:(obj="") "-1"
	
	s isPageQueue = "0"
	
	//设置起始页码为1
	s obj.SchemeID = ""
	s obj.UserID = AUserID
	s obj.PageInfo = ""
	s obj.PageNumber = "1"
	s obj.IsQueue = isPageQueue
	
	s sc = obj.%Save()
	if ($$$ISOK(sc)) 
	{	
		q obj.%Id() 
	}
	else
	{	
		q "-1"
	}
}

ClassMethod ClearPageInfo(APageInfoID) As %String [ WebMethod ]
{
	q:(APageInfoID="") "1"
	q:(APageInfoID=$C(0)) "1"
	
	s sc = ##class(EPRmeta.CentralizedPrint.CentralizedPrintInfo).%DeleteId(APageInfoID)
	q sc
}

ClassMethod SetPrintRecord(AEpisodeID, AUserID, ASelfPrintSchemeName, APrintedItems) As %String [ WebMethod ]
{
	s ret =  ##Class(EPRservice.BLL.BLSelfPrintRecord).AddPrintRecord(AEpisodeID,ASelfPrintSchemeName,APrintedItems,AUserID)
	q ret
}

ClassMethod GetEpisodeInfo(AEpisodeID As %String) As %String [ WebMethod ]
{
	s admInfo = ##Class(EPRservice.BLL.BLSelfPrint).GetAdmInfo(AEpisodeID)
	q admInfo
}

ClassMethod GetToday() As %String [ WebMethod ]
{
	q $zd($p($h,",",1),3)
}

}
