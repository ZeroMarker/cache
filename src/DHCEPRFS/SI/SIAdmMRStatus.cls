Class DHCEPRFS.SI.SIAdmMRStatus Extends %SOAP.WebService [ ClassType = "", ProcedureBlock ]
{

/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/dhceprfsservice";

/// Name of the WebService.
Parameter SERVICENAME = "SIAdmMRStatus";

/// Debug:  w ##Class(DHCEPRFS.SI.SIAdmMRStatus).PublishFPTOP(就诊号)
ClassMethod PublishFPTOP(AEpisodeID As %String) As %String [ WebMethod ]
{
    s hospitalFlag = ##class(DHCEPRFS.BL.BLSysOption).GetValueByName("HospitalFlag")
    if ((hospitalFlag = "QYFY") || (hospitalFlag = "WLDYRM") || (hospitalFlag = "DYEY"))
    {
        //判断是否出院，若不出院则不加入队列（避免重复生成，统一在出院提交上生成）
        s dischgdate=$P($G(^PAADM(AEpisodeID)),"^",17)   
        q:(dischgdate = "") "1"
    }
    
    s schemeType = ##Class(DHCEPRFS.Const.SchemeType).CreateFPTOP()
    s ret = ##Class(DHCEPRFS.BI.BIAdmMRStatus).RegLQWOStatus(AEpisodeID, schemeType)    
    q ret
}

/// Debug:  w ##Class(DHCEPRFS.SI.SIAdmMRStatus).PublishTop(就诊号)
ClassMethod PublishTop(AEpisodeID As %String) As %String [ WebMethod ]
{
    s hospitalFlag = ##class(DHCEPRFS.BL.BLSysOption).GetValueByName("HospitalFlag")
    if (hospitalFlag = "SZBAFYYY")
    {
        //判断是否出院，若不出院则不加入队列（避免重复生成，统一在出院提交上生成）
        s dischgdate=$P($G(^PAADM(AEpisodeID)),"^",17)   
        q:(dischgdate = "") "1"
    }
    
    s schemeType = ##Class(DHCEPRFS.Const.SchemeType).CreateTop()
    s ret = ##Class(DHCEPRFS.BI.BIAdmMRStatus).RegLQWOStatus(AEpisodeID, schemeType)    
    q ret
}

/// Debug:  w ##Class(DHCEPRFS.SI.SIAdmMRStatus).PublishEKG(就诊号)
ClassMethod PublishEKG(AEpisodeID As %String) As %String [ WebMethod ]
{
    s hospitalFlag = ##class(DHCEPRFS.BL.BLSysOption).GetValueByName("HospitalFlag")
    if ((hospitalFlag = "QYFY") || (hospitalFlag = "WLDYRM"))
    {
        //判断是否出院，若不出院则不加入队列（避免重复生成，统一在出院提交上生成）
        s dischgdate=$P($G(^PAADM(AEpisodeID)),"^",17)   
        q:(dischgdate = "") "1"
    }
    
    s schemeType = ##Class(DHCEPRFS.Const.SchemeType).CreateEKG()
    s ret = ##Class(DHCEPRFS.BI.BIAdmMRStatus).RegLQWOStatus(AEpisodeID, schemeType)    
    q ret
}

/// Debug:  w ##Class(DHCEPRFS.SI.SIAdmMRStatus).PublishRIS(就诊号)
ClassMethod PublishRIS(AEpisodeID As %String) As %String [ WebMethod ]
{
    s hospitalFlag = ##class(DHCEPRFS.BL.BLSysOption).GetValueByName("HospitalFlag")
    if ((hospitalFlag = "QYFY") || (hospitalFlag = "WLDYRM"))
    {
        //判断是否出院，若不出院则不加入队列（避免重复生成，统一在出院提交上生成）
        s dischgdate=$P($G(^PAADM(AEpisodeID)),"^",17)   
        q:(dischgdate = "") "1"
    }
    
    s schemeType = ##Class(DHCEPRFS.Const.SchemeType).CreateRIS()
    s ret = ##Class(DHCEPRFS.BI.BIAdmMRStatus).RegLQWOStatus(AEpisodeID, schemeType)    
    q ret
}

/// Debug:	w ##Class(DHCEPRFS.SI.SIAdmMRStatus).PublishPIS("4579958")
ClassMethod PublishPIS(AEpisodeID As %String) As %String [ WebMethod ]
{
    s hospitalFlag = ##class(DHCEPRFS.BL.BLSysOption).GetValueByName("HospitalFlag")
    if ((hospitalFlag = "QYFY") || (hospitalFlag = "WLDYRM"))
    {
        //判断是否出院，若不出院则不加入队列（避免重复生成，统一在出院提交上生成）
        s dischgdate=$P($G(^PAADM(AEpisodeID)),"^",17)   
        q:(dischgdate = "") "1"
    }
    
    s schemeType = ##Class(DHCEPRFS.Const.SchemeType).CreatePIS()
    s ret = ##Class(DHCEPRFS.BI.BIAdmMRStatus).RegLQWOStatus(AEpisodeID, schemeType)    
    //s ret = ##Class(DHCEPRFS.BI.BIAdmMRStatus).RegLQWOStatusSpecial(AEpisodeID, schemeType, "PIS", AEpisodeID)    
    q ret
}

ClassMethod Publish3rdPartyLIS(AOrderID As %String) As %String [ WebMethod ]
{
	s episodeID = AOrderID
	s schemeType = ##Class(DHCEPRFS.Const.SchemeType).Create3rdPartyLIS()
	s ret = ##Class(DHCEPRFS.BI.BIAdmMRStatus).RegLQWOStatus(episodeID, schemeType)	
	q ret
}

/// Debug:	w ##Class(DHCEPRFS.SI.SIAdmMRStatus).PublishLIS("4579958")
ClassMethod PublishLIS(AEpisodeID As %String) As %String [ WebMethod ]
{
	s schemeType = ##Class(DHCEPRFS.Const.SchemeType).CreateLIS()
	s ret = ##Class(DHCEPRFS.BI.BIAdmMRStatus).RegLQWOStatus(AEpisodeID, schemeType)	
	q ret
}

/// Desc:	发布重症监护单
/// Intput：AEpisodeID 	：就诊rowid
/// Return：1 发布成功，0 发布失败
/// Debug:	w ##Class(DHCEPRFS.SI.SIAdmMRStatus).PublishICU("1")
ClassMethod PublishICU(AEpisodeID As %String) As %String [ WebMethod ]
{
	s schemeType = ##Class(DHCEPRFS.Const.SchemeType).CreateICU()
	s ret = ##Class(DHCEPRFS.BI.BIAdmMRStatus).RegLQWOStatus(AEpisodeID, schemeType)
	q ret
}

/// Desc:	发布日常生活评分
/// Intput：AEpisodeID 	：就诊rowid
/// Return：1 发布成功，0 发布失败
/// Debug:	w ##Class(DHCEPRFS.SI.SIAdmMRStatus).PublishNursePF("1")
ClassMethod PublishNursePF(AEpisodeID As %String) As %String [ WebMethod ]
{
	s schemeType = ##Class(DHCEPRFS.Const.SchemeType).CreateNursePF()
	s ret = ##Class(DHCEPRFS.BI.BIAdmMRStatus).RegLQWOStatus(AEpisodeID, schemeType)
	q ret
}

/// Desc:	发布护理相关
/// Intput：AEpisodeID 	：就诊rowid
/// Return：1 发布成功，0 发布失败
/// Debug:	w ##Class(DHCEPRFS.SI.SIAdmMRStatus).PublishNurse("1")
ClassMethod PublishNurse(AEpisodeID As %String) As %String [ WebMethod ]
{
	s schemeType = ##Class(DHCEPRFS.Const.SchemeType).CreateNurse()
	s ret = ##Class(DHCEPRFS.BI.BIAdmMRStatus).RegLQWOStatus(AEpisodeID, schemeType)
	q ret
}

/// Desc:	发布长期医嘱单
/// Intput：AEpisodeID 	：就诊rowid
/// Return：1 发布成功，0 发布失败
/// Debug:	w ##Class(DHCEPRFS.SI.SIAdmMRStatus).PublishLongOrder("1")
ClassMethod PublishLongOrder(AEpisodeID As %String) As %String [ WebMethod ]
{
	s schemeType = ##Class(DHCEPRFS.Const.SchemeType).CreateLongOrder()
	s ret = ##Class(DHCEPRFS.BI.BIAdmMRStatus).RegLQWOStatus(AEpisodeID, schemeType)
	q ret
}

/// Desc:	发布临时医嘱单
/// Intput：AEpisodeID 	：就诊rowid
/// Return：1 发布成功，0 发布失败
/// Debug:	w ##Class(DHCEPRFS.SI.SIAdmMRStatus).PublishTempOrder("1")
ClassMethod PublishTempOrder(AEpisodeID As %String) As %String [ WebMethod ]
{
	s schemeType = ##Class(DHCEPRFS.Const.SchemeType).CreateTempOrder()
	s ret = ##Class(DHCEPRFS.BI.BIAdmMRStatus).RegLQWOStatus(AEpisodeID, schemeType)
	q ret
}

/// Desc:	发布体温单
/// Intput：AEpisodeID 	：就诊rowid
/// Return：1 发布成功，0 发布失败
/// Debug:	w ##Class(DHCEPRFS.SI.SIAdmMRStatus).PublishTemperature("1")
ClassMethod PublishTemperature(AEpisodeID As %String) As %String [ WebMethod ]
{
	s schemeType = ##Class(DHCEPRFS.Const.SchemeType).CreateTemperature()
	s ret = ##Class(DHCEPRFS.BI.BIAdmMRStatus).RegLQWOStatus(AEpisodeID, schemeType)
	q ret
}

/// Desc:	发布手麻记录
/// Intput：AEpisodeID 	：就诊rowid
/// Return：1 发布成功，0 发布失败
/// Debug:	w ##Class(DHCEPRFS.SI.SIAdmMRStatus).PublishAN("1")
ClassMethod PublishAN(AEpisodeID As %String) As %String [ WebMethod ]
{
	s schemeType = ##Class(DHCEPRFS.Const.SchemeType).CreateAN()
	s ret = ##Class(DHCEPRFS.BI.BIAdmMRStatus).RegLQWOStatus(AEpisodeID, schemeType)
	q ret
}

/// Desc:	发布检查报告
/// Intput：AEpisodeID 	：就诊rowid
/// 		AUserID		：用户rowid
/// Return：1 发布成功，0 发布失败
/// Debug:	w ##Class(DHCEPRFS.SI.SIAdmMRStatus).PublishRISReport("4579958","2")
ClassMethod PublishRISReport(AEpisodeID As %String, AUserID As %String) As %String [ WebMethod ]
{
	s schemeType = ##Class(DHCEPRFS.Const.SchemeType).CreateRIS()
	s ret = ##Class(DHCEPRFS.BI.BIAdmMRStatus).RegLateReturningQueue(AEpisodeID, schemeType)
	q ret
}

/// Desc:   发布检验报告
/// Intput：AEpisodeID   ：就诊rowid
///         AUserID     ：用户rowid
/// Return：1 发布成功，0 发布失败
/// Debug:  w ##Class(DHCEPRFS.SI.SIAdmMRStatus).PublishLISReport("4579958","2")
ClassMethod PublishLISReport(AEpisodeID As %String, AUserID As %String) As %String [ WebMethod ]
{
    s schemeType = ##Class(DHCEPRFS.Const.SchemeType).CreateLIS()
    s ret = ##Class(DHCEPRFS.BI.BIAdmMRStatus).RegLateReturningQueue(AEpisodeID, schemeType)
    q ret
}

/// Desc:   发布病理报告
/// Intput：AEpisodeID   ：就诊rowid
///         AUserID     ：用户rowid
/// Return：1 发布成功，0 发布失败
/// Debug:  w ##Class(DHCEPRFS.SI.SIAdmMRStatus).PublishPISReport("1","2")
ClassMethod PublishPISReport(AEpisodeID As %String, AUserID As %String) As %String [ WebMethod ]
{
    s schemeType = ##Class(DHCEPRFS.Const.SchemeType).CreatePIS()
    s ret = ##Class(DHCEPRFS.BI.BIAdmMRStatus).RegLateReturningQueue(AEpisodeID, schemeType)
    q ret
}

/// Desc:   是否已完成最终结算
/// Input：  AEpisodeID  ：就诊rowid
/// Return：1 已完成最终结算，0 未完成最终结算
/// Debug:  w ##Class(DHCEPRFS.SI.SIAdmMRStatus).HasFinalAccounted("1","2")
ClassMethod HasFinalAccounted(AEpisdoeID As %String) As %String [ WebMethod ]
{
    s ret = ##Class(DHCEPRFS.BI.BIAdmMRStatus).GetFinalAccountFlag(AEpisdoeID)
    q ret
}

}
