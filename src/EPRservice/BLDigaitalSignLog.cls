Class EPRservice.BLDigaitalSignLog Extends CA.LogBase [ ClassType = "", LegacyInstanceContext, Not ProcedureBlock ]
{

Property LogData As EPRinstance.DigitalSignLog;

Method SaveLog(signID As %String)
{
	s %this.LogData.SignID=signID
	d %this.LogData.%Save()
}

}
