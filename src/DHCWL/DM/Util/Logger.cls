Class DHCWL.DM.Util.Logger Extends %RegisteredObject
{

Property IsLogging As %Boolean;

Property IsDebug As %Boolean;

//$h  

Property StartDate As %String;

Property StageTime As %ListOfDataTypes;

Property StageLogMessage As %ListOfDataTypes;

Method %OnNew(isLogging As %Boolean = 1, isDebug As %Boolean = 1) As %Status [ Private, ServerOnly = 1 ]
{
}

Method AddStage(logMessage As %String = "")
{
}

Method WriteLog()
{
}

}
