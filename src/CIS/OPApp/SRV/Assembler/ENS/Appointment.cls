Class CIS.OPApp.SRV.Assembler.ENS.Appointment Extends %RegisteredObject
{

/// if debug is 1, then write console logs
Parameter DEBUG = 0;

/// w ##class(CIS.OPApp.SRV.Assembler.ENS.Appointment).Query()
ClassMethod Query(params As CIS.OPApp.DTO.ENS.Request.Arguments) As %ListOfObjects
{
	set collection=##class(%ListOfObjects).%New()
	if ..VerifyInput(params)
	{
		
	}
	
	quit collection
}

ClassMethod VerifyInput(params As CIS.OPApp.DTO.ENS.Request.Arguments) As %Boolean
{
	if params.EpisodeID=""
	{
		if params.StartDate="" quit 0
		if params.EndDate="" quit 0
	}
	
	quit 1
}

/// w ##class(CIS.OPApp.SRV.Assembler.ENS.Appointment).GetInstance(859)
ClassMethod GetInstance(opaId As %String) As CIS.OPApp.DTO.ENS.Request
{
	set model=##class(CIS.OPApp.SRV.Assembler.OP.Appointment).GetInstanceFromOPA(opaId)
	set models=##class(%ListOfObjects).%New()
	do models.Insert(model)
	
	set instance=##class(CIS.OPApp.DTO.ENS.Request).Create()
	do instance.Default()
	do instance.Compose(models)
	
	quit instance
}

/// w ##class(CIS.OPApp.SRV.Assembler.ENS.Appointment).GetInstanceStream(859)
ClassMethod GetInstanceStream(opaId As %String) As %GlobalCharacterStream
{
	set instance=..GetInstance(opaId)
	quit instance.ToXML()
}

}
