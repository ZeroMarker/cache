Class CIS.AN.SRV.Assembler.OP.KeyTime Extends %RegisteredObject
{

/// 数据表名
Parameter TableName = "CIS.AN.OperSchedule";

/// 外部系统
Parameter ExternalSystem = "OPApp";

/// if debug is 1, then write console logs
Parameter DEBUG = 0;

/// w ##class(CIS.AN.SRV.Assembler.OP.KeyTime).Query()
ClassMethod Query(params As CIS.OPApp.DTO.ENS.Request.Arguments) As %ListOfObjects
{
}

/// w ##class(CIS.AN.SRV.Assembler.OP.KeyTime).VerifyInput()
ClassMethod VerifyInput(params As CIS.OPApp.DTO.ENS.Request.Arguments) As %Boolean
{
	quit 1
}

/// w ##class(CIS.AN.SRV.Assembler.OP.KeyTime).GetInstance(4166)
ClassMethod GetInstance(opsId As %String) As CIS.AN.DTO.OP.KeyTime
{
}

}
