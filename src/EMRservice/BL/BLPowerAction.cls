Class EMRservice.BL.BLPowerAction Extends (%RegisteredObject, %XML.Adaptor)
{

ClassMethod checkTraceTrigger() As %Library.Integer
{
 k %msql
 s Num=0,traceYes="Y"
 &sql(SELECT count(*) into :Num FROM EMRmeta.PowerAction WHERE TraceTrigger=:traceYes)
 Quit Num
}

/// ,BeforeStatus,AfterStatus
/// BeforeStatus:%Library.String,AfterStatus:%Library.String,
Query selectAll() As %Library.SQLQuery(CONTAINID = 1, ROWSPEC = "ID,Alias:%Library.String,Code:%Library.String,Description:%Library.String,TraceTrigger:%Library.String,BeforeStatus:%Library.String,AfterStatus:%Library.String")
{
SELECT ID, Alias, Code, Description, TraceTrigger ,BeforeStatus,AfterStatus
FROM EMRmeta.PowerAction
}

/// ,BeforeStatus,AfterStatus
Query selectByDesc(argDescription As %String) As %SQLQuery(CONTAINID = 1)
{
SELECT %ID,Alias,Code,Description,TraceTrigger,BeforeStatus,AfterStatus
 FROM EMRmeta.PowerAction
 WHERE (Description = :argDescription)
}

Query selectStatusExist(argStatusID As %String) As %Library.SQLQuery(CONTAINID = 1, ROWSPEC = "BeforeStatus:%Library.String")
{
SELECT BeforeStatus 
FROM EMRmeta.PowerAction
where BeforeStatus like :argStatusID
}

ClassMethod Add(argPowerAction As EMRservice.entity.EPowerAction) As %String [ WebMethod ]
{
	q:($d(argPowerAction)=0)||(argPowerAction="") 0
	s aPowerAction=""
	s aPowerAction=##class(EMRmeta.PowerAction).%New()
	q:(aPowerAction="") 0
	
	s aPowerAction.Alias=argPowerAction.Alias
	s aPowerAction.Code=argPowerAction.Code
	s aPowerAction.BeforeStatus=argPowerAction.BeforeStatus
	s aPowerAction.AfterStatus=argPowerAction.AfterStatus
	s aPowerAction.Description=argPowerAction.Description
	s aPowerAction.TraceTrigger=argPowerAction.TraceTrigger
	
	s result=""
	s result=aPowerAction.%Save()
	q result
}

ClassMethod Delete(argPowerActionID As %String) As %String [ WebMethod ]
{
	q:($d(argPowerActionID)=0)||(argPowerActionID="") 0
	s aPowerAction="",result=""
	s aPowerAction=##class(EMRmeta.PowerAction).%OpenId(argPowerActionID)
	q:(aPowerAction="") 0
	s aPowerAction=""
	s result=##class(EMRmeta.PowerAction).%DeleteId(argPowerActionID)
	q result
}

ClassMethod Update(argPowerActionID As %String, argPowerAction As EMRservice.entity.EPowerAction) As %String [ WebMethod ]
{
	q:($d(argPowerActionID)=0)||($d(argPowerAction)=0)||(argPowerActionID="")||(argPowerAction="") 0
	s aPowerAction="",result=""
	s aPowerAction=##class(EMRmeta.PowerAction).%OpenId(argPowerActionID)
	q:(aPowerAction="") 0
	
	s aPowerAction.Alias=argPowerAction.Alias
	s aPowerAction.Code=argPowerAction.Code
	s aPowerAction.BeforeStatus=argPowerAction.BeforeStatus
	s aPowerAction.AfterStatus=argPowerAction.AfterStatus
	s aPowerAction.Description=argPowerAction.Description
	s aPowerAction.TraceTrigger=argPowerAction.TraceTrigger
	
	s result=""
	s result=aPowerAction.%Save()
	q result
}

ClassMethod GetById(argPowerActionID As %String) As EMRservice.entity.EPowerAction [ WebMethod ]
{
	s result="",id="",tmpResult=""
	k SQLCODE
	&sql(select ID into :id from EMRmeta.PowerAction where %ID=:argPowerActionID)
	s result=##class(EMRservice.entity.EPowerAction).%New()
	
	if (SQLCODE=0) {
		s tmpResult=##class(EMRmeta.PowerAction).%OpenId(id)
		q:(tmpResult="") result
		
		s result.Alias=tmpResult.Alias
		s result.Code=tmpResult.Code
		s result.BeforeStatus=tmpResult.BeforeStatus
		s result.AfterStatus=tmpResult.AfterStatus
		s result.Description=tmpResult.Description
		s result.TraceTrigger=tmpResult.TraceTrigger
		
	}
	q result
}

}
