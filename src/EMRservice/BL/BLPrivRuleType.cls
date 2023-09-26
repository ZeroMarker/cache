Class EMRservice.BL.BLPrivRuleType Extends (%RegisteredObject, %XML.Adaptor)
{

ClassMethod CheckIdExist(AID As %String) As %Integer
{
 &sql(SELECT Count(ID) into :Result  FROM EMRmeta.PrivRuleType  WHERE ID = :AID)
 if Result=""
 {s Result=0 }
 QUIT Result
}

Query SELECTALL() As %SQLQuery(ROWSPEC = "ID:%String,Name:%String,Description:%String", SELECTMODE = "RUNTIME") [ SqlName = SP_PrivRuleType_SELECTALL, SqlProc ]
{
 SELECT ID, Name, Description
 FROM EMRmeta.PrivRuleType
 ORDER BY ID
}

ClassMethod Add(argPrivRuleType As EMRservice.entity.EPrivRuleType) As %String [ WebMethod ]
{
	q:($d(argPrivRuleType)=0)||(argPrivRuleType="") 0
	s pPrivRuleType=""
	s pPrivRuleType=##class(EMRmeta.PrivRuleType).%New()
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
	s argPrivRuleType=##class(EMRmeta.PrivRuleType).%OpenId(argID)
	q:(argPrivRuleType="") 0
	s argPrivRuleType=""
	s result=##class(EMRmeta.PrivRuleType).%DeleteId(argID)
	q result
}

ClassMethod Update(argPrivRuleType As EMRservice.entity.EPrivRuleType) As %String [ WebMethod ]
{
	q:($d(argPrivRuleType)=0)||(argPrivRuleType="") 0
	s aRuleTypeType="",result=""
	s aRuleTypeType=##class(EMRmeta.PrivRuleType).%OpenId(argPrivRuleType.ID)
	q:(aRuleTypeType="") 0
	s aRuleTypeType.Name=argPrivRuleType.Name
	s aRuleTypeType.Description=argPrivRuleType.Description
	s result=""
	s result=aRuleTypeType.%Save()
	q result
}

ClassMethod GetById(argID As %String) As EMRservice.entity.EPrivRuleType [ WebMethod ]
{
	s result="",id="",tmpResult=""
	k SQLCODE
	&sql(select ID into :id from EMRmeta.PrivRuleType where ID=:argID)
	s result=##class(EMRservice.entity.EPrivRuleType).%New()
	
	if (SQLCODE=0) {
		s tmpResult=##class(EMRmeta.PrivRuleType).%OpenId(id)
		q:(tmpResult="") result
		
		s result.Name=tmpResult.Name
		s result.Description=tmpResult.Description
		s result.ID=id
	}
	q result
}

}
