/// 名称：		EMRservice.BODiagnosKBConfig
/// 描述：		知识关联病种BO层
/// 编写者：	yejian
/// 编写时间：	2016-8-2
Class EMRservice.BODiagnosKBConfig Extends %SOAP.WebService
{

/// TODO: change this to actual network address.
/// URL for invoking the WebService.
/// Parameter LOCATION = "http://localhost/trakcarelive/trak/web";
/// TODO: change this to actual SOAP namespace.
/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/emr/metaservice";

/// Name of the WebService. 
Parameter SERVICENAME = "DiagnosKBConfigInfo";

//根据ID获取知识库关联

/// 根据病种编码获取知识库关联节点集
/// w ##Class(EMRservice.BODiagnosKBConfig).GetNodeIdSByDiagnosID("BINZ001")
ClassMethod GetNodeIdSByDiagnosID(ADiagnosCode As %String) As %String [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLDiagnosKBConfig).GetNodeIdSByDiagnosID("BINZ001")
}

// Debug: s ret = ##Class(EMRservice.BODiagnosKBConfig).GetKBNodeDiagnosByID(1)

ClassMethod GetKBNodeDiagnosByID(ARowID As %String) As EMRservice.entity.EDiagnosKBNode [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLDiagnosKBConfig).GetKBNodeDiagnosByID(ARowID)
}

//根据nodeid获取病种

// do ##Class(EMRservice.BODiagnosKBConfig).GetDiagnosByNodeID("11053")

ClassMethod GetDiagnosByNodeID(NodeID As %String) As %String [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLDiagnosKBConfig).GetDiagnosByNodeID(NodeID)
}

/// Desc:	获取知识库节点与疾病关联的多条件组合
/// Return:	$KBNodeDiagnosID^CtLocID^CtLocDesc^DiagnosID^DiagnosDesc^DictionaryID|DictionaryDesc|Code=Value*Code=Value*Code=Value
/// Debug:	w ##Class(EMRservice.BODiagnosKBConfig).GetKBNodeDiagnosWithRules(7753)
ClassMethod GetKBNodeDiagnosWithRules(AKBNodeID As %String) As %String [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLDiagnosKBConfig).GetKBNodeDiagnosWithRules(AKBNodeID)
}

/// Debug:	d ##Class(EMRservice.BODiagnosKBConfig).SaveKBNodeDiagnos(7753,"2^3",2020)
ClassMethod SaveKBNodeDiagnos(AKBNodeID As %String, AKBTreeID As %String, ADiagnosIDs As %String) [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLDiagnosKBConfig).SaveKBNodeDiagnos(AKBNodeID,AKBTreeID,ADiagnosIDs)
}

/// 保存对应关系
/// do ##Class(EMRservice.BODiagnosKBConfig).SaveBindDiagnos("11053","1^2","3236")
ClassMethod SaveBindDiagnos(KBNodeID As %String, KBDiagnosID As %String, KBTreeID As %String) [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLDiagnosKBConfig).SaveBindDiagnos(KBNodeID,KBDiagnosID,KBTreeID)
}

//插入

ClassMethod InsertNode(KBNodeID As %String, DiagnosCode As %String, KBTreeID As %String) As %String [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLDiagnosKBConfig).InsertNode(KBNodeID,DiagnosCode,KBTreeID)
}

//设为无效

ClassMethod Delete(RowID As %String) As %String [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLDiagnosKBConfig).Delete(RowID)
}

/// 根据TreeID查找数据
ClassMethod GetDataByTreeID(TreeID As %String, DiagnosID As %String, EpisodeID As %String) As EMRservice.dataset.EDiagnosKBConfigDataSet [ WebMethod ]
{
	S result = ##Class(EMRservice.dataset.EDiagnosKBConfigDataSet).%New()
	d result.SetArgs(TreeID,DiagnosID,EpisodeID)
 	q result
}

//插入病种知识库规则

/// Debug:	d ##Class(EMRservice.BOKBNodeDiagnosRule).Insert(2,6,"F","女")
ClassMethod InsertRule(AKBNodeDiagnosID As %String, ARuleID As %String, ARuleParamCode As %String, ARuleParamDesc As %String) As %String [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLDiagnosKBConfig).InsertRule(AKBNodeDiagnosID,ARuleID,ARuleParamCode,ARuleParamDesc)
}

//删除病种知识库规则

ClassMethod DeleteRule(AKBNodeDiagnosID As %String, ARuleID As %String, ARuleParamCode As %String) As %String [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLDiagnosKBConfig).DeleteRule(AKBNodeDiagnosID,ARuleID,ARuleParamCode)
}

}
