Class EMRservice.BOPrivRule Extends %SOAP.WebService [ ClassType = "", ProcedureBlock ]
{

/// TODO: change this to actual network address.
/// URL for invoking the WebService.
/// Parameter LOCATION = "http://192.168.0.15/trakcarejst/web";
/// TODO: change this to actual SOAP namespace.
/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/emr/metaservice";

/// Name of the WebService.
Parameter SERVICENAME = "Privilege.PrivRule";

ClassMethod Add(argPrivRule As EMRservice.entity.EPrivRule, argPrivRuleLog As EMRservice.entity.EPrivRuleLog) As %String [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLPrivRule).Add(argPrivRule,argPrivRuleLog)
}

ClassMethod Delete(argPrivRuleID As %String, argPrivRuleLog As EMRservice.entity.EPrivRuleLog) As %String [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLPrivRule).Delete(argPrivRuleID,argPrivRuleLog)
}

ClassMethod Update(argPrivRule As EMRservice.entity.EPrivRule, argPrivRuleLog As EMRservice.entity.EPrivRuleLog) As %String [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLPrivRule).Update(argPrivRule,argPrivRuleLog)
}

// w ##class(EMRservice.BOPrivRule).Test(5,"userid^3928!admid^201871!patientid^1!instanceid^""!userloc^34!templateid^822!ssgroupid^576!categoryid^642!docid^67!isnewframework^1!eprnum^1")

ClassMethod Test(argRuleID As %String, argEnviromentInfo As %String) As %String [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLPrivRule).Test(argRuleID,argEnviromentInfo)
}

ClassMethod GetById(argPrivRuleID As %String) As EMRservice.entity.EPrivRule [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLPrivRule).GetById(argPrivRuleID)
}

ClassMethod GetAllPrivRule() As EMRservice.dataset.EPrivRuleDataset [ WebMethod ]
{
 Set result=##class(EMRservice.dataset.EPrivRuleDataset).%New()
 Quit result
}

/// Creator：      guozongtao
/// CreatDate：    2010-05-5
/// Description:   依据传入规则ID,获取使用了这条规则的EMRmeta.EMRTemplate记录
/// Table：        
/// Input：        argRuleID：EMRmeta.PrivRule.ROWID
/// Output：       对输出参数的说明
/// Return：       EMRservice.dataset.EPrivRuleEMRTemplate
/// Others：       
ClassMethod GetUsedPrivRule(argPrivRuleID As %String) As EMRservice.dataset.EPrivRuleEMRTemplateDataSet [ WebMethod ]
{
	Set result=##class(EMRservice.dataset.EPrivRuleEMRTemplateDataSet).%New()
 	Do result.SetArgs(argPrivRuleID)
 	Quit result
}

ClassMethod GetPrivRuleStatus(aHosGroupID As %String = "") As EMRservice.dataset.EPivRuleStatusDataSet [ WebMethod ]
{
	Set result=##class(EMRservice.dataset.EPivRuleStatusDataSet).%New()
 	Do result.SetArgs(aHosGroupID)
 	Quit result
}

/// Creator：      guozongtao
/// CreatDate：    2010-05-13
/// Description:   依据规则类型返回规则数据集合
/// Table：        
/// Input：        
/// Output：       对输出参数的说明
/// Return：      
/// Others
/// Debug:w ##Class(EMRservice.BOPrivRule).GetPrivRuleByType("LoadTemplatePrivilege")
ClassMethod GetPrivRuleByType(PrivRuleTypeName As %String) As EMRservice.dataset.EPrivRuleByTypeDataSet [ WebMethod ]
{
	Set result=##class(EMRservice.dataset.EPrivRuleByTypeDataSet).%New()
 	Do result.SetArgs(PrivRuleTypeName)
 	Quit result
}

/// Creator：      houj
/// CreatDate：    2010-10-28
/// Description:   获取授权权限规则
/// Table：        
/// Input：        
/// Output：      	
/// Return：      
/// Others
/// Debug:d ##Class(EMRservice.BOPrivRule).GetAppointPriv()
ClassMethod GetAppointPriv(argEnvInfo As %String) As %ArrayOfDataTypes [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLPrivRule).GetAppointPriv(argEnvInfo)
}

ClassMethod PrivStringToArray(privString As %String) As %ArrayOfDataTypes
{
	q ##Class(EMRservice.BL.BLPrivRule).PrivStringToArray(privString)
}

ClassMethod GetFirstValidRuleByName(ruleName As %String) As EMRmeta.PrivRule
{
	q ##Class(EMRservice.BL.BLPrivRule).GetFirstValidRuleByName(ruleName)
}

/// Creator：      houj
/// CreatDate：    2014-11-18
/// Description:   获取授权级别权限规则
/// Table：        
/// Input：        
/// Output：      	
/// Return：      
/// Others
/// Debug:d ##Class(EMRservice.BOPrivRule).GetAuthLevelPriv()
ClassMethod GetAuthLevelPriv(argEnvInfo As %String) As %ArrayOfDataTypes [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLPrivRule).GetAuthLevelPriv(argEnvInfo)
}

/*
/// 以下为测试代码
/// d ##Class(EMRservice.BOPrivRule).update1()
ClassMethod update1()
{
 &SQL(UPDATE EMRmeta.PrivRule SET PrivRuleTypeDR='' WHERE ID = 3)
}

/// Debug: d ##Class(EMRservice.BOPrivRule).TestParsePrivRuleByID()
ClassMethod TestParsePrivRuleByID() As %String
{
	s par1 = ^DHCEMRDebug("EMRservice.BOPrivRule","Input1")
	s par2 = ^DHCEMRDebug("EMRservice.BOPrivRule","Input2")
	s par1 = "3"
	s par2 = "userid^5972!admid^201764!patientid^1!userloc^34!templateid^0!ssgroupid^576!categoryid^0!docid^25!isnewframework^1!eprnum^1"
	q ..ParsePrivRuleByID(par1,par2)
}

/// Debug: d ##Class(EMRservice.BOPrivRule).TestGetAppointPriv()
ClassMethod TestGetAppointPriv() As %String
{
	s para = "userid^!admid^201764!patientid^1!userloc^34!templateid^0!ssgroupid^576!categoryid^0!docid^!isnewframework^1!eprnum^"
	q ..GetAppointPriv(para)
}
*/
}
