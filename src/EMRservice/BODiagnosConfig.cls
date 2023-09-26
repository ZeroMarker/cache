///  名称：		EMRservice.BODiagnosConfig
///  描述：		病种BO层
///  编写者：	yejian
///  编写时间：	2015-12-17
Class EMRservice.BODiagnosConfig Extends %SOAP.WebService
{

///  TODO: change this to actual network address.
///  URL for invoking the WebService.
///  Parameter LOCATION = "http://localhost/trakcarelive/trak/web";
///  TODO: change this to actual SOAP namespace.
///  SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/emr/metaservice";

///  Name of the WebService. 
Parameter SERVICENAME = "DiagnosConfigInfo";

/// 获取病种分组
/// Debug: ##class(EMRservice.BODiagnosConfig).GetAllLoc()
ClassMethod GetAllLoc() As %XML.DataSet [ WebMethod ]
{
	Set result=##class(%XML.DataSet).%New("EMRservice.BL.BLDiagnosConfig:SelectAllLoc")
	Quit result
}

/// 获取病种分组
/// Debug: d ##class(EMRservice.BODiagnosConfig).GetDiagnosCategory()
ClassMethod GetDiagnosCategory() As %XML.DataSet [ WebMethod ]
{
	s result = ##Class(%XML.DataSet).%New("EMRservice.BL.BLDiagnosConfig:GetDiagnosCategory")
	q result
}

/// 根据ID获取病种
ClassMethod GetDiagnosCategoryByID(ARowID As %String) As EMRservice.entity.EDiagnosCategory [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLDiagnosConfig).GetDiagnosCategoryByID(ARowID)
}

/// 检查病种分组
ClassMethod CheckDiagnosCategory(GroupCode As %String) As %String [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLDiagnosConfig).CheckDiagnosCategory(GroupCode)
}

/// 添加病种分组
ClassMethod AddDiagnosCategory(ADiagnosC As EMRservice.entity.EDiagnosCategory) As %String [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLDiagnosConfig).AddDiagnosCategory(ADiagnosC)
}

/// 修改病种分组
ClassMethod ModDiagnosCategory(ADiagnosC As EMRservice.entity.EDiagnosCategory) As %Boolean [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLDiagnosConfig).ModDiagnosCategory(ADiagnosC)
}

///  creator:yejian
///  CreatDate:2016-8-9
///  Description:修改树节点排序顺序号
///  Return: result是否操作成功
///  do ##class(EMRservice.BODiagnosConfig).SwapSequence("1","2")
ClassMethod SwapDiagnosCatSeq(DiagnosCID1 As %String, DiagnosCID2 As %String) As %Boolean [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLDiagnosConfig).SwapDiagnosCatSeq(DiagnosCID1,DiagnosCID2)
}

/// 删除病种分组
ClassMethod DelDiagnosCategory(ADiagnosCID As %String) As %String [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLDiagnosConfig).DelDiagnosCategory(ADiagnosCID)
}

/// 获取所有病种
/// Debug: d ##class(EMRservice.BODiagnosConfig).GetAllDiagnos()
ClassMethod GetAllDiagnos() As %XML.DataSet [ WebMethod ]
{
	s result = ##Class(%XML.DataSet).%New("EMRservice.BL.BLDiagnosConfig:GetAllDiagnos")
	q result
}

/// 根据ID获取病种
/// Debug: d ##class(EMRservice.BODiagnosConfig).GetDiagnosByID(1)
ClassMethod GetDiagnosByID(AID As %String) As EMRservice.entity.EDiagnos [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLDiagnosConfig).GetDiagnosByID(AID)
}

/// 根据Code获取病种
/// Debug: d ##class(EMRservice.BODiagnosConfig).GetDiagnosByCode("1")
ClassMethod GetDiagnosByCode(ACode As %String) As EMRservice.entity.EDiagnos [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLDiagnosConfig).GetDiagnosByCode(ACode)
}

/// 检查病种
ClassMethod CheckDiagnos(Code As %String) As %String [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLDiagnosConfig).CheckDiagnos(Code)
}

/// 添加病种
ClassMethod AddDiagnos(ADiagnos As EMRservice.entity.EDiagnos) As %String [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLDiagnosConfig).AddDiagnos(ADiagnos)
}

/// 修改病种分组关联
ClassMethod ModDiagnosCat(AIds As %String, ADiagnosC As EMRservice.entity.EDiagnosCategory) As %Boolean [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLDiagnosConfig).ModDiagnosCat(AIds,ADiagnosC)
}

/// 修改病种
ClassMethod ModDiagnos(ADiagnos As EMRservice.entity.EDiagnos) As %Boolean [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLDiagnosConfig).ModDiagnos(ADiagnos)
}

///  creator:yejian
///  CreatDate:2016-8-9
///  Description:修改树节点排序顺序号
///  Return: result是否操作成功
///  do ##class(EMRservice.BODiagnosConfig).SwapSequence("1","2")
ClassMethod SwapDiagnosSeq(DiagnosID1 As %String, DiagnosID2 As %String) As %Boolean [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLDiagnosConfig).SwapDiagnosSeq(DiagnosID1,DiagnosID2)
}

/// 删除病种
ClassMethod DelDiagnos(ADiagnosCode As %String) As %Boolean [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLDiagnosConfig).DelDiagnos(ADiagnosCode)
}

/// 根据科室ID获取病种
/// 病种科室/// /// /// 
ClassMethod GetDiagnosByCtLocIDOrCode(ACtLocID As %String, aGroupCode As %String) As %XML.DataSet [ WebMethod ]
{
	s result = ##Class(%XML.DataSet).%New("EMRservice.BL.BLDiagnosConfig:GetDiagnosByCtLocIDOrCode")
	d result.SetArgs(ACtLocID,aGroupCode)
	q result
}

/// 检查病种诊断
ClassMethod CheckDiagnosCTLocCode(GroupCode As %String, CTLocID As %String) As %String [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLDiagnosConfig).CheckDiagnosCTLocCode(GroupCode,CTLocID)
}

/// 添加病种科室关联
ClassMethod AddDiagnosCTLoc(DiagnosDisease As EMRservice.entity.EDiagnosCTLoc) As %String [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLDiagnosConfig).AddDiagnosCTLoc(DiagnosDisease)
}

/// 删除病种诊断
ClassMethod DelDiagnosCTLoc(AID As %String) As %Boolean [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLDiagnosConfig).DelDiagnosCTLoc(AID)
}

/// 根据病种ID获取病种关联
/// 病种诊断/// /// /// /
ClassMethod GetDiagnosByICDIDOrDiagnosCode(aDiagnosCode As %String, aICDID As %String) As %XML.DataSet [ WebMethod ]
{
	s result = ##Class(%XML.DataSet).%New("EMRservice.BL.BLDiagnosConfig:GetDiagnosByICDIDOrDiagnosCode")
	d result.SetArgs(aDiagnosCode,aICDID)
	q result
}

/// 检查病种诊断
ClassMethod CheckDiagnosDiseaseCode(DiagnosCode As %String, ICDCode As %String) As %String [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLDiagnosConfig).CheckDiagnosDiseaseCode(DiagnosCode,ICDCode)
}

/// 添加病种诊断
ClassMethod AddDiagnosDisease(DiagnosDisease As EMRservice.entity.EDiagnosDisease) As %String [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLDiagnosConfig).AddDiagnosDisease(DiagnosDisease)
}

/// 删除病种诊断
ClassMethod DelDiagnosDisease(AID As %String) As %Boolean [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLDiagnosConfig).DelDiagnosDisease(AID)
}

/// 删除病种诊断
/// debug  w ##Class(EMRservice.BODiagnosConfig).TestGetDiseasesList("112","6")
ClassMethod TestGetDiseasesList(AEpisodeID As %String, ACtLocID As %String) As %String [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLDiseases).GetDiseasesList(AEpisodeID,ACtLocID)
}

ClassMethod Test()
{
    s obj = ##class(EMRservice.entity.EDiagnos).%New()
	s obj.CTLocID="106"
	s obj.Description="1"
	s obj.ID="91"
	s obj.Diagnos="aaa"
	s obj.GroupName="sdfsdaf"
	s obj.Name="sdfsdaf"
	s obj.GroupDescription="sdfsdaf"
	
	s objre = ##class(EMRservice.entity.EDiagnosDisease).%New()
	;w ..ModKBDiagnos(obj,objre)
	q 1
}

}
