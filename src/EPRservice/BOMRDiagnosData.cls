/// Name:EPRservice.BOMRDiagnosData
/// Describe:Get or Set 
/// table: Mr_diagnos 
/// Globle: ^MR({MR_Adm.MRADM_RowId},"DIA",{MRDIA_Childsub},"EPR")=Level^Sequence^TherapeuticEffects^DiagnosticEvaluation
/// Creator:Candyxu
/// Date:20111027
/// 
Class EPRservice.BOMRDiagnosData Extends %SOAP.WebService [ ProcedureBlock ]
{

/// TODO: change this to actual network address.
/// URL for invoking the WebService.
/// Parameter LOCATION = "http://localhost/trakcarelive/trak/web";
/// Parameter LOCATION = "http://127.0.0.1/trakcarelive/trak/web";
/// TODO: change this to actual SOAP namespace.
/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/metaservice";

/// Name of the WebService.
Parameter SERVICENAME = "MRDiagnosDataInfo";

/// 诊断列表
/// Input :pEpisodeID 就诊号，PTypeID 单元绑定诊断类型 ，PCurrentTypeID 当前诊断，PUserID当前用户
/// do ##Class(EPRservice.BOMRDiagnosData).GetMRDiagnosDataset("201876")
ClassMethod GetMRDiagnosDataset(pEpisodeID As %String, PTypeID As %String, PCurrentTypeID As %String, PUserID As %String) As EPRservice.dataset.EMRDiagnosDataSet [ WebMethod ]
{
	if pEpisodeID = $c(0) s pEpisodeID = ""
	if PTypeID = $c(0) s PTypeID = ""
	if PCurrentTypeID = $c(0) s PCurrentTypeID = ""
	if PTypeID '= ""
	{
	   s count = 0
	   s rs = ##class(%ResultSet).%New("EPRservice.BLL.MRDiagnos.BLMRDiagnosData:GetMRDiagnosList")
	   d rs.Execute(pEpisodeID,PTypeID)
	   while (rs.Next())
	   {
		   s count = count + 1
	   }
	   if ((count <= 0) && (PTypeID '= "") && (pEpisodeID '= ""))
	   {
		   d ..PresentDiagnosCopyed(PCurrentTypeID,PTypeID,pEpisodeID,PUserID)
	   }
	}
	s result=##class(EPRservice.dataset.EMRDiagnosDataSet).%New()
	d result.SetArgs(pEpisodeID,"")
	q result
}

/// 获得诊断类型列表用于维护程序
ClassMethod GetDiagnosTypeDataset() As EPRservice.dataset.EMRDiagnosTypeDataset [ WebMethod ]
{
  Set resType=##class(EPRservice.dataset.EMRDiagnosTypeDataset).%New()
  Do resType.SetArgs()
  Quit resType
}

/// 诊断类型、转归类型、状态类型
ClassMethod GetDiagnosTypesDataset() As EPRservice.dataset.EMRDiagnosStatuesTypeDataset [ WebMethod ]
{
	Set resType=##class(EPRservice.dataset.EMRDiagnosStatuesTypeDataset).%New()
	do resType.SetArgs()
	Quit resType
}

/// 删除记录
/// do ##Class(EPRservice.BOMRDiagnosData).DeleteDiagnos("^&201876^6")
ClassMethod DeleteDiagnos(AMRID As %String, SubID As %String) As %String [ WebMethod ]
{
   q ##Class(EPRservice.BLL.MRDiagnos.BLMRDiagnosData).DiagnosDelete(AMRID,SubID)
}

/// 保存级别、顺序 (RowID(MEDIAref,SubID),Evaluation,Effects,Level,sequnece)
/// do ##Class(EPRservice.BOMRDiagnosData).SaveDiagnos("201876^2^1^0^355&201876^13^3^1^5","201871")
ClassMethod SaveDiagnos(AResult As %String, AUserID As %String) [ WebMethod ]
{
   do ##Class(EPRservice.BLL.MRDiagnos.BLMRDiagnosData).SaveDiagnos(AResult,AUserID)
}

/// 保存为当前就诊
ClassMethod SaveAsPresentDiagnos(AResult As %String, EpsodeID As %String, AUserID As %String) [ WebMethod ]
{
	 do ##Class(EPRservice.BLL.MRDiagnos.BLMRDiagnosData).SaveAsPresentDiagnos(AResult,EpsodeID,AUserID)
}

/// 添加或修改诊断数据
/// 
ClassMethod UpdateOrInsertMrDiagnos(AEpsodeID As %String, ADiagnosID As %String, ASubID As %String, AType As %String, AIcdCode As %String, AIcdDesc, AEvaluation As %String, AEffect As %String, AUserID As %String, ASequence As %String) As %String [ WebMethod ]
{
   q ##Class(EPRservice.BLL.MRDiagnos.BLMRDiagnosData).UpdateOrInsertDiagnos(AEpsodeID,ADiagnosID,ASubID,AType,AIcdCode,AIcdDesc,AEvaluation,AEffect,AUserID,ASequence)
}

/// 复制目前诊断
ClassMethod PresentDiagnosCopyed(ApresentType As %String, AType As %String, EpsodeID As %String, UserID As %String) [ WebMethod ]
{
   do ##Class(EPRservice.BLL.MRDiagnos.BLMRDiagnosData).PrensetDiagnosCopyed(ApresentType,AType,EpsodeID,UserID)
}

/// 诊断模板
/// input: UserID登陆用户,DeptID登陆科室
ClassMethod GetModleTabs(UserID As %String, DeptID As %String) As EPRservice.dataset.EMRDiagnosModleDataset [ WebMethod ]
{
	s result=##class(EPRservice.dataset.EMRDiagnosModleDataset).%New()
	d result.SetArgs(UserID,DeptID)
	q result
}

/// 诊断模板内容
/// input:模板ID
ClassMethod GetModleTabsDetail(ID As %String) As EPRservice.dataset.EMRDiagnosModleDetailDataset [ WebMethod ]
{
	s result=##class(EPRservice.dataset.EMRDiagnosModleDetailDataset).%New()
	d result.SetArgs(ID)
	q result
}

/// 历史诊断
/// input:PatientID病人ID,ICDType诊断代码
/// outPut:不重复的诊断列表
ClassMethod GetHistoryData(PatientID As %String, ICDType As %String) As EPRservice.dataset.EMRDiagnosHistoryDataset [ WebMethod ]
{
	s result=##class(EPRservice.dataset.EMRDiagnosHistoryDataset).%New()
	d result.SetArgs(PatientID,ICDType)
	q result
}

/// 所有诊断历史
/// input:PatientID病人ID,ICDType诊断代码
/// outPut:所有诊断列表
/// debug:do ##Class(EPRservice.BOMRDiagnosData).GetAllHistoryData(PatientID,ICDID)
ClassMethod GetAllHistoryData(PatientID As %String, ICDType As %String) As EPRservice.dataset.EMRDiagnosAllHistoryDataset [ WebMethod ]
{
	s result=##class(EPRservice.dataset.EMRDiagnosAllHistoryDataset).%New()
	d result.SetArgs(PatientID,ICDType)
	q result
}

/// desc:获取ICD信息
/// input:code、icd描述、icd字母简写
/// ouput:icd列表
ClassMethod GetICDDXData(QueryText As %String) As EPRservice.dataset.EMRDiagnosICDDataset [ WebMethod ]
{
	s result = ##class(EPRservice.dataset.EMRDiagnosICDDataset).%New()
	d result.SetArgs(QueryText)
	q result
}

}
