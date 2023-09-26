Class EMRservice.FirstPage.BOInterfaceLog Extends %RegisteredObject
{

ClassMethod SaveLog(ArgMessage As %String = "-9^错误", ArgEpisodeID As %String = 99999)
{
	s objinterfacelog=""
	s objinterfacelog=##class(EMRinstance.FirstPage.InterfaceLog).%New()
	s objinterfacelog.CreatDate=+$h
	s objinterfacelog.CreatTime=$p($h,",",2)
	s objinterfacelog.EpisodeID=ArgEpisodeID
	s objinterfacelog.Status=$p(ArgMessage,"^",1)
	s objinterfacelog.Message=ArgMessage
	
	d objinterfacelog.%Save()
	d objinterfacelog.%Close()
}

}
