Class DHCEPRFS.DHCC.Srv.SrvAnesthesia Extends %SOAP.WebService [ ClassType = "", ProcedureBlock ]
{

/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/dhceprfsservice";

/// Name of the WebService.
Parameter SERVICENAME = "DHCCAnesthesia";

/// 麻醉记录单
ClassMethod GetANPDFPath(AEpisodeID As %String) As %String [ WebMethod ]
{
	//s ret = ##Class(DHCEPRFS.BL.HISInfo.BLANInfo).GetANPDFPath(AEpisodeID)
	s ret = ##Class(DHCEPRFS.BL.HISInfo.BLANInfo).GetAnaestRecordPathNew(AEpisodeID)
	q ret
}

/// 手术清点单
ClassMethod GetOperCountPath(AEpisodeID As %String) As %String [ WebMethod ]
{
	//s ret = ##Class(DHCEPRFS.BL.HISInfo.BLANInfo).GetOperCountPath(AEpisodeID)
	s ret = ##Class(DHCEPRFS.BL.HISInfo.BLANInfo).GetOPCountPathNew(AEpisodeID)
	q ret
}

/// 手术术前访视
ClassMethod GetPREPDFPath(AEpisodeID As %String) As %String [ WebMethod ]
{
	//s ret = ##Class(DHCEPRFS.BL.HISInfo.BLANInfo).GetPREPDFPath(AEpisodeID)
	s ret = ##Class(DHCEPRFS.BL.HISInfo.BLANInfo).GetPREPDFPathNew(AEpisodeID)
	q ret
}

/// 手术术后访视
ClassMethod GetPOSTPDFPath(AEpisodeID As %String) As %String [ WebMethod ]
{
	s ret = ##Class(DHCEPRFS.BL.HISInfo.BLANInfo).GetPOSTPDFPath(AEpisodeID)
	q ret
}

/// 麻醉前访视
ClassMethod GetPrevVisitPath(AEpisodeID As %String) As %String [ WebMethod ]
{
	//s ret = ##Class(DHCEPRFS.BL.HISInfo.BLANInfo).GetPrevVisitPath(AEpisodeID)
	s ret = ##Class(DHCEPRFS.BL.HISInfo.BLANInfo).GetPrevVisitPDFPathNew(AEpisodeID)
	q ret
}

/// 麻醉后访视
ClassMethod GetPostVisitPath(AEpisodeID As %String) As %String [ WebMethod ]
{
	//s ret = ##Class(DHCEPRFS.BL.HISInfo.BLANInfo).GetPostVisitPath(AEpisodeID)
	s ret = ##Class(DHCEPRFS.BL.HISInfo.BLANInfo).GetPostANVisitPathNew(AEpisodeID)
	q ret
}

/// 安全核查表
ClassMethod GetOPSPDFPath(AEpisodeID As %String) As %String [ WebMethod ]
{
	//s ret = ##Class(DHCEPRFS.BL.HISInfo.BLANInfo).GetOPSPDFPath(AEpisodeID)
	s ret = ##Class(DHCEPRFS.BL.HISInfo.BLANInfo).GetOperSafetyCheckPathNew(AEpisodeID)
	q ret
}

/// 风险评估单
ClassMethod GetCHARecordPath(AEpisodeID As %String) As %String [ WebMethod ]
{
	//s ret = ##Class(DHCEPRFS.BL.HISInfo.BLANInfo).GetCHARecordPath(AEpisodeID)
	s ret = ##Class(DHCEPRFS.BL.HISInfo.BLANInfo).GetOperRiskAssessmentPathNew(AEpisodeID)
	q ret
}

/// 手术护理记录单
ClassMethod GetANHLPath(AEpisodeID As %String) As %String [ WebMethod ]
{
	s ret = ##Class(DHCEPRFS.BL.HISInfo.BLANInfo).GetANHLPath(AEpisodeID)
	q ret
}

/// 恢复室记录单
ClassMethod GetPACUPath(AEpisodeID As %String) As %String [ WebMethod ]
{
	//s ret = ##Class(DHCEPRFS.BL.HISInfo.BLANInfo).GetPACUPath(AEpisodeID)
	s ret = ##Class(DHCEPRFS.BL.HISInfo.BLANInfo).GetPACUNurseRecordPathNew(AEpisodeID)
	q ret
}

/// 重症监护单
ClassMethod GetICUPath(AEpisodeID As %String) As %String [ WebMethod ]
{
	//s ret = ##Class(DHCEPRFS.BL.HISInfo.BLANInfo).GetICUPDFPath(AEpisodeID)
	s ret = ##Class(DHCEPRFS.BL.HISInfo.BLANInfo).GetDHCICUPathNew(AEpisodeID)
	q ret
}

}
