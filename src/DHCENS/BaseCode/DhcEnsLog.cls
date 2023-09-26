Class DHCENS.BaseCode.DhcEnsLog Extends (%RegisteredObject, %XML.Adaptor) [ Inheritance = right ]
{

ClassMethod InsertDhcEns(LogType As %String, LogFunName As %String, LogInPut As %GlobalCharacterStream, LogOutPut As %GlobalCharacterStream) As %String
{
	set objDhcEnsLog=##class(User.DhcEnsLog).%New()
	set objDhcEnsLog.LogFunType=LogType
	set objDhcEnsLog.LogFunName=LogFunName
	set objDhcEnsLog.LogInPut=LogInPut
	set objDhcEnsLog.LogOutPut=LogOutPut
	set objDhcEnsLog.LogDate=+$h
	set objDhcEnsLog.LogTime=$p($h,",",2)
    set sc=objDhcEnsLog.%Save()
    do objDhcEnsLog.%Close()
	quit sc
}

}
