Class CIS.AN.SRV.CacheService Extends %RegisteredObject
{

// w ##class(CIS.AN.SRV.CacheService).ExportProject("CIS-AN")

ClassMethod ExportProject(projectName As %String) As %Status
{
	s project=##class(%Studio.Project).%New()
    s project.Name=projectName
    s sc=project.Export("D:\Documents\"_projectName_".xml","/relatedclasses=1",0)
    quit sc
}

}
