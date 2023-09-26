/// 名称:EPRmeta.Privilege.PrivRuleType
/// 描述:持久化类EPRmeta.Privilege.PrivRuleType的业务类 CRUD
/// 编写者:guozongtao
/// 编写日期:2010-05-10
Class EPRservice.Privilege.BOPrivRuleType Extends %SOAP.WebService [ ProcedureBlock ]
{

/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/metaservice";

/// Name of the WebService.
Parameter SERVICENAME = "Privilege.BOPrivRuleType";

ClassMethod Add(argPrivRuleType As EPRservice.entity.Privilege.EPrivRuleType) As %String [ WebMethod ]
{
	q:($d(argPrivRuleType)=0)||(argPrivRuleType="") 0
	s pPrivRuleType=""
	s pPrivRuleType=##class(EPRmeta.Privilege.PrivRuleType).%New()
	q:(pPrivRuleType="") 0

	s pPrivRuleType.Name=argPrivRuleType.Name
	s pPrivRuleType.Description=argPrivRuleType.Description
	if '(pPrivRuleType.%Save())
	{
		Quit 0
	} 
	Quit pPrivRuleType.%Id()
}

ClassMethod Delete(argID As %String) As %String [ WebMethod ]
{
	q:($d(argID)=0)||(argID="") 0
	s argPrivRuleType="",result=""
	s argPrivRuleType=##class(EPRmeta.Privilege.PrivRuleType).%OpenId(argID)
	q:(argPrivRuleType="") 0
	s argPrivRuleType=""
	s result=##class(EPRmeta.Privilege.PrivRuleType).%DeleteId(argID)
	q result
}

ClassMethod Update(argPrivRuleType As EPRservice.entity.Privilege.EPrivRuleType) As %String [ WebMethod ]
{
	q:($d(argPrivRuleType)=0)||(argPrivRuleType="") 0
	s aRuleTypeType="",result=""
	s aRuleTypeType=##class(EPRmeta.Privilege.PrivRule).%OpenId(argPrivRuleType.ID)
	q:(aRuleTypeType="") 0
	s aRuleTypeType.Name=argPrivRuleType.Name
	s aRuleTypeType.Description=argPrivRuleType.Description
	s result=""
	s result=aRuleTypeType.%Save()
	q result
}

ClassMethod GetById(argID As %String) As EPRservice.entity.Privilege.EPrivRuleType [ WebMethod ]
{
	s result="",id="",tmpResult=""
	k SQLCODE
	&sql(select ID into :id from EPRmeta_Privilege.PrivRuleType where ID=:argID)
	s result=##class(EPRservice.entity.Privilege.EPrivRuleType).%New()
	
	if (SQLCODE=0) {
		s tmpResult=##class(EPRmeta.Privilege.PrivRuleType).%OpenId(id)
		q:(tmpResult="") result
		
		s result.Name=tmpResult.Name
		s result.Description=tmpResult.Description
		s result.ID=id
	}
	q result
}

ClassMethod SelectAll() As EPRservice.dataset.EPrivRuleTypeDataSet [ WebMethod ]
{
 Set result=##class(EPRservice.dataset.EPrivRuleTypeDataSet).%New()
 Quit result
}

}
