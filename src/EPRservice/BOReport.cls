/// EPRservice.BOReport
Class EPRservice.BOReport Extends %SOAP.WebService [ ProcedureBlock ]
{

/// TODO: change this to actual network address.
/// URL for invoking the WebService.
/// Parameter LOCATION = "http://localhost/trakcarelive/trak/web";
/// TODO: change this to actual SOAP namespace.
/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/metaservice";

/// Name of the WebService.
Parameter SERVICENAME = "ReportInfo";

/// TODO: add arguments and implementation.
/// CreateReport
ClassMethod CreateReport(AEReport As EPRservice.entity.EReport) As %String [ WebMethod ]
{
	TSTART
	
	set objReport = ##class(EPRmeta.Report).%New()
 set objReport.Name = AEReport.Name
 set objReport.Description = AEReport.Description
 set objReport.ReportCategoryID = AEReport.ReportCategoryID



 /*
 增加categoryid下reschildid
 /*/
 set objReportCategory = ##class(EPRmeta.ReportCategory).%OpenId(AEReport.ReportCategoryID)
 if (objReportCategory ="")
 {
	  TROLLBACK
 Quit ""
	 } 
 set objReportCategory.ResChildCount = objReportCategory.ResChildCount + 1
 if '(objReportCategory.%Save())
 {
 TROLLBACK
 Quit ""
	 } 
 set objReport.PublishVersion = 0
 set objReport.LastVersion = 0
 set objReport.GUID = AEReport.GUID

 if '(objReport.%Save())
 {
	  TROLLBACK
 Quit ""
	} 
 TCOMMIT
 Quit objReport.%Id()
}

ClassMethod CreateReportVersion(AReportVersion As EPRservice.entity.EReportVersion) As EPRservice.entity.EReportVersion [ WebMethod ]
{
	
	Set NewVersionNumber = ##class(EPRmeta.ReportVersion).SELECTMAXVERSION(AReportVersion.ReportID)
	
	TSTART
	set objReportVersion = ##class(EPRmeta.ReportVersion).%New()
 Quit:(objReportVersion ="") "" 

 set result = ##class(EPRservice.entity.EReportVersion).%New()
 set objReportVersion.ReportID = AReportVersion.ReportID
 set objReportVersion.Author = AReportVersion.Author
 set objReportVersion.Conditions = AReportVersion.Conditions

 set result.Author = AReportVersion.Author
 set result.Conditions = AReportVersion.Conditions

 set objReportVersion.LastSaveDate = $ZDATEH($ZDATE($HOROLOG))

 Do objReportVersion.Data.CopyFrom(AReportVersion.Data)

 if NewVersionNumber=""  
 {set objReportVersion.VersionNumber = 1}
 if NewVersionNumber'="" 
 {set objReportVersion.VersionNumber =NewVersionNumber + 1}

 set objReportVersion.LastSaveTime = $ZTIMEH($ZTIME($PIECE($HOROLOG,",",2),1))
 set objReportVersion.Status = 0
 set objReportVersion.CreateDate = $ZDATEH($ZDATE($HOROLOG))
 set objReportVersion.CreateTime = $ZTIMEH($ZTIME($PIECE($HOROLOG,",",2),1))
 set result.Status = 0
 set result.LastSaveDate = objReportVersion.LastSaveDate //$ZDATEH($ZDATE($HOROLOG))
 set result.LastSaveTime = objReportVersion.LastSaveTime // $ZTIMEH($ZTIME($PIECE($HOROLOG,",",2),1))
 set result.VersionNumber = objReportVersion.VersionNumber
 set result.CreateDate = objReportVersion.CreateDate //$ZDATEH($ZDATE($HOROLOG))
 set result.CreateTime = objReportVersion.CreateTime //$ZTIMEH($ZTIME($PIECE($HOROLOG,",",2),1))
	
	
	set objReport = ##class(EPRmeta.Report).%OpenId(AReportVersion.ReportID)
	Quit:(objReport ="") "" 
	set objReport.LastVersion =objReport.LastVersion + 1
	if '(objReport.%Save())
	{
	  TROLLBACK
 Quit ""
	} 

	
	if '(objReportVersion.%Save())
	{
	  TROLLBACK
 Quit ""
	} 
	
	TCOMMIT

	set result.ID = objReportVersion.%Id()
 set result.Data = objReportVersion.Data
	
	Quit result
}

ClassMethod DeleteReport(AID As %String) As %Boolean [ WebMethod ]
{
 TSTART
	set objReport = ##class(EPRmeta.Report).%OpenId(AID)
 if (objReport ="")
 {
	  TROLLBACK
 Quit 0
	 } 
 Set objReportCategory = ##class(EPRmeta.ReportCategory).%OpenId(objReport.ReportCategoryID)
 if (objReportCategory ="")
 {
	  TROLLBACK
 Quit 0
	 }	
	 
 set objReportCategory.ResChildCount = objReportCategory.ResChildCount - 1
 //do objReportCategory.%Save()
 if '(objReportCategory.%Save())
 {
	  TROLLBACK
 Quit 0
	 }
 if '(objReport.%DeleteId(AID))	
	 {
		TROLLBACK
		Quit 0
		 }
	TCOMMIT	 
	Quit 1
}

ClassMethod DeleteReportVersion(AID As %String) As %Boolean [ WebMethod ]
{
	TSTART
	set objReportVersion = ##class(EPRmeta.ReportVersion).%OpenId(AID)
	if (objReportVersion="")
	{
	  TROLLBACK
 Quit 0
	}
	set objReport = ##class(EPRmeta.Report).%OpenId(objReportVersion.ReportID)
	if (objReport="")
	{
	  TROLLBACK
 Quit 0
	} 
	Set objReport.LastVersion = objReport.LastVersion - 1

	if '(objReport.%Save())
	{
	  TROLLBACK
 Quit 0
	} 
	
	if '(objReportVersion.%DeleteId(AID))
	{
	  TROLLBACK
 Quit 0
 }
	TCOMMIT
 Quit 1
}

ClassMethod GetALLReport(ACategoryID As %String) As EPRservice.dataset.EReportDataset [ WebMethod ]
{
 Set result=##class(EPRservice.dataset.EReportDataset).%New()
 Do result.SetArgs(ACategoryID)
 Quit result
}

ClassMethod GetALLVersionByReportID(AReportID As %String) As EPRservice.dataset.EReportVersionDataset [ WebMethod ]
{
 Set result=##class(EPRservice.dataset.EReportVersionDataset).%New()
 Do result.SetArgs(AReportID)
 Quit result
}

ClassMethod GetReportByGUID(AGUID As %String) As EPRservice.entity.EReport [ WebMethod ]
{
 Set AID = ##Class(EPRmeta.Report).SELECTBYGUID(AGUID)	
 Quit:AID="" ""
 set objReport = ##class(EPRmeta.Report).%OpenId(AID)
 Q:(objReport="") ""

 set Result = ##class(EPRservice.entity.EReport).%New()
 Q:(Result="") ""

 set Result.ID = objReport.%Id()
 set Result.Name = objReport.Name
 set Result.ReportCategoryID = objReport.ReportCategoryID
 set Result.Description = objReport.Description
 set Result.PublishVersion = objReport.PublishVersion
 set Result.GUID = objReport.GUID
 set Result.LastVersion = objReport.LastVersion

 Quit Result
}

ClassMethod GetReportByID(AID As %String) As EPRservice.entity.EReport [ WebMethod ]
{
	set objReport = ##class(EPRmeta.Report).%OpenId(AID)
	Q:(objReport="") ""

 set Result = ##class(EPRservice.entity.EReport).%New()
	Q:(Result="") ""

 set Result.ID = objReport.%Id()
 set Result.Name = objReport.Name
 set Result.ReportCategoryID = objReport.ReportCategoryID
 set Result.Description = objReport.Description
 set Result.PublishVersion = objReport.PublishVersion
 set Result.GUID = objReport.GUID
 set Result.LastVersion = objReport.LastVersion

 Quit Result
}

ClassMethod GetVersionByID(AID As %String, ADataFlag As %Boolean) As EPRservice.entity.EReportVersion [ WebMethod ]
{
	set objReportVersion = ##class(EPRmeta.ReportVersion).%OpenId(AID)
	q:(objReportVersion="") ""
 set Result = ##class(EPRservice.entity.EReportVersion).%New()
 q:(Result="") ""
 set Result.ID = objReportVersion.%Id()
 set Result.ReportID = objReportVersion.ReportID
 set Result.LastSaveDate = objReportVersion.LastSaveDate
 set Result.LastSaveTime = objReportVersion.LastSaveTime

 if ADataFlag  
 {
	 set Result.Conditions = objReportVersion.Conditions
	 do Result.Data.CopyFrom(objReportVersion.Data) 
	}

 set Result.PublicationDate = objReportVersion.PublicationDate
 set Result.PublicationTime = objReportVersion.PublicationTime
 set Result.CreateDate = objReportVersion.CreateDate
 set Result.CreateTime = objReportVersion.CreateTime
 set Result.Status = objReportVersion.Status
 set Result.Author = objReportVersion.Author
 set Result.VersionNumber = objReportVersion.VersionNumber
 Quit Result
}

ClassMethod PublishVersion(AVersion As EPRservice.entity.EReportVersion) As EPRservice.entity.EReportVersion [ WebMethod ]
{
	TSTART
	set objReportVersion = ##class(EPRmeta.ReportVersion).%OpenId(AVersion.ID)
 set objReportVersion.Status = 2
 set objReportVersion.PublicationDate = $ZDATEH($ZDATE($HOROLOG))
 set objReportVersion.PublicationTime = $ZTIMEH($ZTIME($PIECE($HOROLOG,",",2),1))
 set objReportVersion.LastSaveDate = $ZDATEH($ZDATE($HOROLOG))
 set objReportVersion.LastSaveTime = $ZTIMEH($ZTIME($PIECE($HOROLOG,",",2),1))
 set objReport = ##class(EPRmeta.Report).%OpenId(AVersion.ReportID)
 Set objReport.PublishVersion = objReportVersion.VersionNumber
 
 Do objReportVersion.Data.CopyFrom(AVersion.Data)

 set objReportVersion.Author = AVersion.Author
 set objReportVersion.Conditions = AVersion.Conditions


 if '(objReport.%Save())
 {
	  TROLLBACK
 Quit 0
 }

 if '(objReportVersion.%Save())
 {
	  TROLLBACK
 Quit 0
	}  

	TCOMMIT
 set Result = ##class(EPRservice.entity.EReportVersion).%New()
 set Result.ID = objReportVersion.%Id()
 //set Result.Name = objReportVersion.Name
 set Result.ReportID = objReportVersion.ReportID
 set Result.LastSaveDate = objReportVersion.LastSaveDate
 set Result.LastSaveTime = objReportVersion.LastSaveTime


 set Result.PublicationDate = objReportVersion.PublicationDate
 set Result.PublicationTime = objReportVersion.PublicationTime
 set Result.CreateDate = objReportVersion.CreateDate
 set Result.CreateTime = objReportVersion.CreateTime
 set Result.Status = objReportVersion.Status
 set Result.Author = objReportVersion.Author
 set Result.Conditions = objReportVersion.Conditions

 set Result.VersionNumber = objReportVersion.VersionNumber

	Quit Result
}

ClassMethod UpdateCraftVersion(AVersion As EPRservice.entity.EReportVersion) As EPRservice.entity.EReportVersion [ WebMethod ]
{
	TSTART 
	set objReportVersion = ##class(EPRmeta.ReportVersion).%OpenId(AVersion.ID)
 //set objReportVersion.Name = AVersion.Name
 ; B "S"
 if objReportVersion=""
 {	  TROLLBACK
 Quit 0

	  }
 set objReportVersion.ReportID = AVersion.ReportID
 set objReportVersion.Author = AVersion.Author
 set objReportVersion.Conditions = AVersion.Conditions


 set objReportVersion.LastSaveDate = $ZDATEH($ZDATE($HOROLOG))
 set objReportVersion.LastSaveTime = $ZTIMEH($ZTIME($PIECE($HOROLOG,",",2),1))

 do objReportVersion.Data.CopyFrom(AVersion.Data)

 set objReportVersion.Status = 1
 if '(objReportVersion.%Save())
 {
	  TROLLBACK
 Quit 0
	}    
	TCOMMIT
 set Result = ##class(EPRservice.entity.EReportVersion).%New()
 set Result.ID = objReportVersion.%Id()
 //set Result.Name = objReportVersion.Name
 set Result.ReportID = objReportVersion.ReportID
 set Result.LastSaveDate = objReportVersion.LastSaveDate
 set Result.LastSaveTime = objReportVersion.LastSaveTime


 set Result.PublicationDate = objReportVersion.PublicationDate
 set Result.PublicationTime = objReportVersion.PublicationTime
 set Result.CreateDate = objReportVersion.CreateDate
 set Result.CreateTime = objReportVersion.CreateTime
 set Result.Status = objReportVersion.Status
 set Result.Author = objReportVersion.Author
 set Result.Conditions = objReportVersion.Conditions

 set Result.VersionNumber = objReportVersion.VersionNumber

 Quit Result
}

ClassMethod UpdateReport(AEReport As EPRservice.entity.EReport) As %Boolean [ WebMethod ]
{
 TSTART
	
 set objReport = ##class(EPRmeta.Report).%OpenId(AEReport.ID)
 if objReport=""
 { 
 TROLLBACK
 Quit 0}
 set objReport.Name = AEReport.Name
 set objReport.Description = AEReport.Description
 Set TempReportCategoryID = objReport.ReportCategoryID 
 set objReport.ReportCategoryID = AEReport.ReportCategoryID
 set objReport.GUID = AEReport.GUID





 if TempReportCategoryID '= AEReport.ReportCategoryID
 {
	 	if (TempReportCategoryID '="")
	 	{ Set objOldReportCategory = ##class(EPRmeta.ReportCategory).%OpenId(TempReportCategoryID)
 set objOldReportCategory.ResChildCount = objOldReportCategory.ResChildCount - 1
 if '(objOldReportCategory.%Save())
 {
	        TROLLBACK
 Quit 0
	       }    
 }
 if (objReport.ReportCategoryID'="")
	 	{
		 	Set objNewReportCategory = ##class(EPRmeta.ReportCategory).%OpenId(objReport.ReportCategoryID)

 set objNewReportCategory.ResChildCount = objNewReportCategory.ResChildCount + 1
 if '(objNewReportCategory.%Save())
 {
	          TROLLBACK
 Quit 0
	        }    
 }   
 }

 if '(objReport.%Save())
 {
	 TROLLBACK
	 Quit 0
	 }
 TCOMMIT
 Quit 1
}

}
