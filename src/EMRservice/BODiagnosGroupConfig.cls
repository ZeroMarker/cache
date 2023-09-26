///  名称：		EMRservice.BODiagnosGroupConfig
///  描述：		病种分组BO层
///  编写者：	yejian
///  编写时间：	2016-9-20
Class EMRservice.BODiagnosGroupConfig Extends %SOAP.WebService
{

///  TODO: change this to actual network address.
///  URL for invoking the WebService.
///  Parameter LOCATION = "http://localhost/trakcarelive/trak/web";
///  TODO: change this to actual SOAP namespace.
///  SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/emr/metaservice";

///  Name of the WebService. 
Parameter SERVICENAME = "DiagnosGroupCInfo";

/// 获取病种分组
/// Debug: d ##class(EMRservice.BODiagnosGroupConfig).GetDiagnosGroup("50")
ClassMethod GetDiagnosGroup(ACtLocID As %String) As %XML.DataSet [ WebMethod ]
{
	s result = ##Class(%XML.DataSet).%New("EMRservice.BL.BLDiagnosGroupConfig:GetDiagnosGroup")
	d result.SetArgs(ACtLocID)
	q result
}

/// 获取病种分组明细
/// Debug: d ##class(EMRservice.BODiagnosGroupConfig).GetDiagnosGroupDetail("50")
ClassMethod GetDiagnosGroupDetail(ACtLocID As %String) As %XML.DataSet [ WebMethod ]
{
	s result = ##Class(%XML.DataSet).%New("EMRservice.BL.BLDiagnosGroupConfig:GetDiagnosGroupDetail")
	d result.SetArgs(ACtLocID)
	q result
}

/// 获取病种分组明细
/// Debug: d ##class(EMRservice.BODiagnosGroupConfig).GetDiagnosByCtLocID("50")
ClassMethod GetDiagnosByCtLocID(ACtLocID As %String) As %XML.DataSet [ WebMethod ]
{
	s result = ##Class(%XML.DataSet).%New("EMRservice.BL.BLDiagnosGroupConfig:GetDiagnosByCtLocID")
	d result.SetArgs(ACtLocID)
	q result
}

/// 得到最大code编号
/// w ##class(EMRservice.BODiagnosGroupConfig).GetMaxID()
ClassMethod GetMaxID() As %String [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLDiagnosGroupConfig).GetMaxID()
}

/// 根据ID获取病种
ClassMethod GetDiagnosGroupByID(ARowID As %String) As EMRservice.entity.EDiagnosGroup [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLDiagnosGroupConfig).GetDiagnosGroupByID(ARowID)
}

/// 检查病种分组
ClassMethod CheckDiagnosGroup(GroupCode As %String) As %String [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLDiagnosGroupConfig).CheckDiagnosGroup(GroupCode)
}

/// 添加病种分组
ClassMethod AddDiagnosGroup(ADiagnosC As EMRservice.entity.EDiagnosGroup) As %String [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLDiagnosGroupConfig).AddDiagnosGroup(ADiagnosC)
}

/// 修改病种分组
ClassMethod ModDiagnosGroup(ADiagnosC As EMRservice.entity.EDiagnosGroup) As %Boolean [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLDiagnosGroupConfig).ModDiagnosGroup(ADiagnosC)
}

/// 修改病种分组
/// debug d ##Class(EMRservice.BODiagnosGroupConfig).UpDiagnosGroupDetail("m05","0","56")
ClassMethod UpDiagnosGroupDetail(aDiagnosCode As %String, oldGroupID As %String, newGroupID As %String) As %Boolean [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLDiagnosGroupConfig).UpDiagnosGroupDetail(aDiagnosCode,oldGroupID,newGroupID)
}

///  creator:yejian
///  CreatDate:2016-8-9
///  Description:修改树节点排序顺序号
///  Return: result是否操作成功
///  do ##class(EMRservice.BODiagnosGroupConfig).SwapSequence("1","2")
ClassMethod SwapDiagnosCatSeq(DiagnosCID1 As %String, DiagnosCID2 As %String) As %Boolean [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLDiagnosGroupConfig).SwapDiagnosCatSeq(DiagnosCID1,DiagnosCID2)
}

///  creator:yejian
///  CreatDate:2016-8-9
///  Description:修改树节点排序顺序号
///  Return: result是否操作成功
///  do ##class(EMRservice.BODiagnosGroupConfig).SwapSequence("1","2")
ClassMethod SwapDiagnosDetailSeq(DiagnosCID1 As %String, DiagnosCID2 As %String) As %Boolean [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLDiagnosGroupConfig).SwapDiagnosDetailSeq(DiagnosCID1,DiagnosCID2)
}

/// 删除病种分组
ClassMethod DelDiagnosGroup(ADiagnosCID As %String) As %String [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLDiagnosGroupConfig).DelDiagnosGroup(ADiagnosCID)
}

}
