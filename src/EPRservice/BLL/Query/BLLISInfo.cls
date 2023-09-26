/// 描述：检验数据信息查询业务对象
/// 创建者：houjian
/// 创建日期：2011-08-16
Class EPRservice.BLL.Query.BLLISInfo Extends %RegisteredObject [ ClassType = "", LegacyInstanceContext, ProcedureBlock ]
{

/// 就诊指针
Property EpisodeID As %String(TRUNCATE = 1);

Property PatientID As %String(TRUNCATE = 1) [ Private ];

Property AdmDateTime As %String(TRUNCATE = 1) [ Private ];

Property PapmiNo As %String(TRUNCATE = 1) [ Private ];

/// Desc:	实例化业务逻辑对象
/// Debug:	w ##Class(EPRservice.BLL.Query.BLEPRInfo).CreateInstance()
ClassMethod CreateInstance(AEpisodeID As %String) As EPRservice.BLL.Query.BLEPRInfo
{
	s obj = ##Class(EPRservice.BLL.Query.BLLISInfo).%New()
	d obj.SetEpisodeID(AEpisodeID)
	q obj
}

/// Desc:	更新业务逻辑对象对应的就诊指针
Method SetEpisodeID(AEpisodeID As %String) As %Status
{
	s %this.EpisodeID = AEpisodeID
	s %this.PatientID = ##Class(EPRservice.HISInterface.DAEpisodeInfo).GetPapmiDR(AEpisodeID)
	s %this.PapmiNo = ##Class(EPRservice.HISInterface.DAPatientInfo).GetPapmiNo(%this.PatientID)
	q $$$OK
}

Method GetLISData(AItemPara As %String)
{
	s ret = ""
	///Result:%String,OrderDateTime:%String,SampleDateTime:%String,ReportDateTime:%String
	s rset=##class(%ResultSet).%New("EPRservice.LISInterface.DALISInfo:GetLabReuslt")
	do rset.Execute(%this.PapmiNo, %this.EpisodeID, "^", AItemPara)
	While (rset.Next()) {
		s ret = rset.Data("Result")
		q:(ret = "")
		s char = $e(ret,1,1)
		if (char?1N)
		{
			s ret=ret_rset.Data("Spliter")_rset.Data("ItemUnit") //" "_rset.Data("SampleDateTime")
		}
		q
	}
	d rset.Close()
	q ret
}

Method GetLISDataResult(AItemPara)
{
	s ret = ""
	///Result:%String,OrderDateTime:%String,SampleDateTime:%String,ReportDateTime:%String
	s rset=##class(%ResultSet).%New("EPRservice.LISInterface.DALISInfo:GetLabReuslt")
	do rset.Execute(%this.PapmiNo, %this.EpisodeID, "^", AItemPara)
	While (rset.Next()) {
		s ret = rset.Data("Result")
		q
	}
	d rset.Close()
	q ret
}

}
