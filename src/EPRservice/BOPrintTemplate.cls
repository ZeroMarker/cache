Class EPRservice.BOPrintTemplate Extends %SOAP.WebService [ Not ProcedureBlock ]
{

/// TODO: change this to actual network address.
/// URL for invoking the WebService.
/// Parameter LOCATION = "http://localhost/trakcarelive/trak/web";
/// TODO: change this to actual SOAP namespace.
/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/metaservice";

/// Name of the WebService.
Parameter SERVICENAME = "PrintTemplateInfo";

ClassMethod CreateCraftVersion(AVersion As EPRservice.entity.EPrintTemplateVersion) As EPRservice.entity.EPrintTemplateVersion [ WebMethod ]
{
	set dateNow = $p($H,",",1)
	set timeNow = $p($H,",",2)
	
	TSTART
	
	//新增版本
	set objPrintTemplateVersion = ##class(EPRmeta.PrintTemplateVersion).%New()
	if (objPrintTemplateVersion = "")
	{
	  	TROLLBACK
 		Quit ""
	}
	
	set objPrintTemplateVersion.PrintTemplateID = AVersion.PrintTemplateID
	set objPrintTemplateVersion.Author = AVersion.Author
	set objPrintTemplateVersion.ShapeNames = AVersion.ShapeNames
	set objPrintTemplateVersion.FootRepeatRowStart  = AVersion.FootRepeatRowStart
	set objPrintTemplateVersion.FootRepeatRowEnd  = AVersion.FootRepeatRowEnd
	set objPrintTemplateVersion.LastSaveDate = dateNow
	set objPrintTemplateVersion.LastSaveTime = timeNow
	set objPrintTemplateVersion.CreateDate = dateNow
	set objPrintTemplateVersion.CreateTime = timeNow
	set objPrintTemplateVersion.Status = 0
	set objPrintTemplateVersion.Duplex = AVersion.Duplex
	set objPrintTemplateVersion.MultiplePagesOption = AVersion.MultiplePagesOption
	set objPrintTemplateVersion.NewPageStartOdd = AVersion.NewPageStartOdd
	set objPrintTemplateVersion.BlankPageStyle = AVersion.BlankPageStyle	//<+add on 2014-11-12 by houj>空白页格式
	do objPrintTemplateVersion.Data.CopyFrom(AVersion.Data)
	
	if (AVersion.HeadStartPageNum = "")||((AVersion.HeadStartPageNum = $C(0)))
	{	
		set objPrintTemplateVersion.HeadStartPageNum ="1"
	}
	else 
	{
		set objPrintTemplateVersion.HeadStartPageNum = AVersion.HeadStartPageNum
	} 
	
	if ((AVersion.OnePageRowCount="")||(AVersion.OnePageRowCount=$C(0)))
	{ 
		set objPrintTemplateVersion.OnePageRowCount= "0"
	}
	else
	{ 
		set objPrintTemplateVersion.OnePageRowCount  = AVersion.OnePageRowCount 
	}
	
	set NewVersionNumber = ##class(EPRmeta.PrintTemplateVersion).SELECTMAXVERSION(AVersion.PrintTemplateID)	
	if (NewVersionNumber = "")  
	{
		set objPrintTemplateVersion.VersionNumber = 1
	}
	else
	{	
		set objPrintTemplateVersion.VersionNumber =NewVersionNumber + 1
	}
	
	//更新模板信息
	set objPrintTemplate = ##class(EPRmeta.PrintTemplate).%OpenId(AVersion.PrintTemplateID)
	if (objPrintTemplate ="")
	{
		TROLLBACK
		quit ""
	}
	set objPrintTemplate.LastVersion =objPrintTemplate.LastVersion + 1
	if ('objPrintTemplate.%Save())
	{
	  	TROLLBACK
 		Quit ""
	} 

	//保存新建版本
	if ('objPrintTemplateVersion.%Save())
	{
	  	TROLLBACK
      	Quit ""
	} 
	
	TCOMMIT
	
	 
	//构造返回值
	set result = ##class(EPRservice.entity.EPrintTemplateVersion).%New()
	set result.Author = objPrintTemplateVersion.Author
	set result.ShapeNames = objPrintTemplateVersion.ShapeNames
	set result.HeadStartPageNum = objPrintTemplateVersion.HeadStartPageNum
	set result.FootRepeatRowStart= objPrintTemplateVersion.FootRepeatRowStart
	set result.FootRepeatRowEnd= objPrintTemplateVersion.FootRepeatRowEnd
	set result.OnePageRowCount= objPrintTemplateVersion.OnePageRowCount
	set result.Status = objPrintTemplateVersion.Status
	set result.LastSaveDate = objPrintTemplateVersion.LastSaveDate
	set result.LastSaveTime = objPrintTemplateVersion.LastSaveTime
	set result.VersionNumber = objPrintTemplateVersion.VersionNumber
	set result.CreateDate = objPrintTemplateVersion.CreateDate
	set result.CreateTime = objPrintTemplateVersion.CreateTime
	set result.Duplex = objPrintTemplateVersion.Duplex
	set result.MultiplePagesOption = objPrintTemplateVersion.MultiplePagesOption
	set result.NewPageStartOdd = objPrintTemplateVersion.NewPageStartOdd
	set result.BlankPageStyle = objPrintTemplateVersion.BlankPageStyle	//<+add on 2014-11-12 by houj>空白页格式
	set result.ID = objPrintTemplateVersion.%Id()
 	//set result.Data = objPrintTemplateVersion.Data	//无需返回流数据信息
	
	Quit result
}

ClassMethod CreateTemplate(APrintTemplate As EPRservice.entity.EPrintTemplate) As %String [ WebMethod ]
{
	TSTART
	set objPrintTemplate = ##class(EPRmeta.PrintTemplate).%New()
 set objPrintTemplate.Name = APrintTemplate.Name
 set objPrintTemplate.Description = APrintTemplate.Description
 set objPrintTemplate.PrintTemplateCategoryID = APrintTemplate.PrintTemplateCategoryID

 set objPrintTemplate.PrintTemplateFormat = APrintTemplate.PrintTemplateFormat


 set objPrintTemplate.ChartItemType = APrintTemplate.ChartItemType
 set objPrintTemplate.ContinuePrint = APrintTemplate.ContinuePrint
 set objPrintTemplate.NewPage = APrintTemplate.NewPage
 set objPrintTemplate.BindTemplateID = APrintTemplate.BindTemplateID
 set objPrintTemplate.BindTemplateName = APrintTemplate.BindTemplateName
 set objPrintTemplate.UnderLine = APrintTemplate.UnderLine
 set objPrintTemplate.BlankRowWithBorder = APrintTemplate.BlankRowWithBorder

 /*
 增加categoryid下reschildid
 /*/
 set objPrintTemplateCategory = ##class(EPRmeta.PrintTemplateCategory).%OpenId(APrintTemplate.PrintTemplateCategoryID)
 if (objPrintTemplateCategory ="")
 {
	  TROLLBACK
 	Quit ""
	 } 
	  
	set objPrintTemplateCategory.ResChildCount = objPrintTemplateCategory.ResChildCount + 1
 if '(objPrintTemplateCategory.%Save())
 {
 TROLLBACK
 Quit ""
	 } 
	  
 set objPrintTemplate.PublishVersion = 0
 set objPrintTemplate.LastVersion = 0
 set objPrintTemplate.GUID = APrintTemplate.GUID

 if '(objPrintTemplate.%Save())
 {
	  TROLLBACK
 Quit ""
	} 
	
 /*bind to templateid
 */
 if (objPrintTemplate.BindTemplateID'="")
 {
 S BindTemplate =##class(EPRmeta.Template).%OpenId(objPrintTemplate.BindTemplateID)
 if (BindTemplate= "")
 {
	   TROLLBACK 
	   Quit ""  //"Error Open BindTemplate"}	 
 }	
  
 S BindTemplate.BindPrintTemplateID = objPrintTemplate.%Id()
 S BindTemplate.BindPrintName = objPrintTemplate.Name
 if '(BindTemplate.%Save())
 {
	  TROLLBACK
 Quit ""
	} 
 }
 
 TCOMMIT
 Quit objPrintTemplate.%Id()
}

ClassMethod DeleteCraftVersion(AID As %String) As %Boolean [ WebMethod ]
{
	TSTART
	set objPrintTemplateVersion = ##class(EPRmeta.PrintTemplateVersion).%OpenId(AID)
	
	set objPrintTemplate = ##class(EPRmeta.PrintTemplate).%OpenId(objPrintTemplateVersion.PrintTemplateID)
	/*if (objPrintTemplate="")
	{
	  TROLLBACK
 Quit 0
	} */
	Set objPrintTemplate.LastVersion = objPrintTemplate.LastVersion - 1

	if '(objPrintTemplate.%Save())
	{
	  TROLLBACK
 Quit 0
	} 
	
	if '(objPrintTemplateVersion.%DeleteId(AID))
	{
	  TROLLBACK
 Quit 0
 }
	TCOMMIT
	Quit 1
}

ClassMethod DeleteTemplate(AID As %String) As %Boolean [ WebMethod ]
{
 TSTART
	set objPrintTemplate = ##class(EPRmeta.PrintTemplate).%OpenId(AID)
 if (objPrintTemplate ="")
 {
	  TROLLBACK
 Quit 0
	 } 
 Set objPrintTemplateCategory = ##class(EPRmeta.PrintTemplateCategory).%OpenId(objPrintTemplate.PrintTemplateCategoryID)
 if (objPrintTemplateCategory ="")
 {
	  TROLLBACK
 Quit 0
	 }	
	 
 set objPrintTemplateCategory.ResChildCount = objPrintTemplateCategory.ResChildCount - 1
 //do objPrintTemplateCategory.%Save()
 if '(objPrintTemplateCategory.%Save())
 {
	  TROLLBACK
 Quit 0
	 }

 if (objPrintTemplate.BindTemplateID '="")
 {
 S BindTemplate =##class(EPRmeta.Template).%OpenId(objPrintTemplate.BindTemplateID)
 if (BindTemplate= "")
 {
	   TROLLBACK 
	   Quit 0  //"Error Open BindTemplate"}	 
 }	
 S BindTemplate.BindPrintTemplateID = ""
 S BindTemplate.BindPrintName = ""
 if '(BindTemplate.%Save())
 {
	  TROLLBACK
 Quit 0
	} 
	  }

	 if '(objPrintTemplate.%DeleteId(AID))	
	 {
		TROLLBACK
		Quit 0
		 }
		 
		 
		 
	TCOMMIT	 
	Quit 1
}

ClassMethod GetALLTemplate(ACategoryID As %String) As EPRservice.dataset.EPrintTemplateDataset [ WebMethod ]
{
 Set result=##class(EPRservice.dataset.EPrintTemplateDataset).%New()
 Do result.SetArgs(ACategoryID)
 Quit result
}

ClassMethod GetALLVersion(ATemplateID As %String) As EPRservice.dataset.EPrintTemplateVersionDataset [ WebMethod ]
{
 Set result=##class(EPRservice.dataset.EPrintTemplateVersionDataset).%New()
 Do result.SetArgs(ATemplateID)
 Quit result
}

ClassMethod GetTemplateByGUID(AGUID As %String) As EPRservice.entity.EPrintTemplate [ WebMethod ]
{
 Set AID = ##Class(EPRmeta.PrintTemplate).SELECTBYGUID(AGUID)	
 Quit:AID="" ""
 set objPrintTemplate = ##class(EPRmeta.PrintTemplate).%OpenId(AID)
 Q:(objPrintTemplate="") ""

 set Result = ##class(EPRservice.entity.EPrintTemplate).%New()
 Q:(Result="") ""

 set Result.ID = objPrintTemplate.%Id()
 set Result.Name = objPrintTemplate.Name
 set Result.PrintTemplateCategoryID = objPrintTemplate.PrintTemplateCategoryID
 set Result.Description = objPrintTemplate.Description
 set Result.PublishVersion = objPrintTemplate.PublishVersion
 set Result.GUID = objPrintTemplate.GUID
 set Result.LastVersion = objPrintTemplate.LastVersion

 set Result.PrintTemplateFormat = objPrintTemplate.PrintTemplateFormat

 set Result.ChartItemType = objPrintTemplate.ChartItemType
 set Result.ContinuePrint = objPrintTemplate.ContinuePrint
 set Result.NewPage = objPrintTemplate.NewPage
 set Result.BindTemplateID = objPrintTemplate.BindTemplateID
 set Result.BindTemplateName = objPrintTemplate.BindTemplateName
 set Result.UnderLine = objPrintTemplate.UnderLine
 set Result.BlankRowWithBorder = objPrintTemplate.BlankRowWithBorder



 Quit Result
}

ClassMethod GetTemplateByID(AID As %String) As EPRservice.entity.EPrintTemplate [ WebMethod ]
{
	set objPrintTemplate = ##class(EPRmeta.PrintTemplate).%OpenId(AID)
	Q:(objPrintTemplate="") ""

 set Result = ##class(EPRservice.entity.EPrintTemplate).%New()
	Q:(Result="") ""

 set Result.ID = objPrintTemplate.%Id()
 set Result.Name = objPrintTemplate.Name
 set Result.PrintTemplateCategoryID = objPrintTemplate.PrintTemplateCategoryID
 set Result.Description = objPrintTemplate.Description
 set Result.PublishVersion = objPrintTemplate.PublishVersion
 set Result.GUID = objPrintTemplate.GUID
 set Result.LastVersion = objPrintTemplate.LastVersion

 set Result.PrintTemplateFormat = objPrintTemplate.PrintTemplateFormat

 set Result.ChartItemType = objPrintTemplate.ChartItemType
 set Result.ContinuePrint = objPrintTemplate.ContinuePrint
 set Result.NewPage = objPrintTemplate.NewPage
 set Result.BindTemplateID = objPrintTemplate.BindTemplateID
 set Result.BindTemplateName = objPrintTemplate.BindTemplateName
 set Result.UnderLine = objPrintTemplate.UnderLine
 set Result.BlankRowWithBorder = objPrintTemplate.BlankRowWithBorder
 
 Quit Result
}

ClassMethod GetVersionByID(AID As %String, ADataFlag As %Boolean) As EPRservice.entity.EPrintTemplateVersion [ WebMethod ]
{
	set objPrintTemplateVersion = ##class(EPRmeta.PrintTemplateVersion).%OpenId(AID)
	q:(objPrintTemplateVersion="") ""
	
 	set Result = ##class(EPRservice.entity.EPrintTemplateVersion).%New()
 	q:(Result="") ""
 
 	set Result.ID = objPrintTemplateVersion.%Id()
 	//set Result.Name = objPrintTemplateVersion.Name
 	set Result.PrintTemplateID = objPrintTemplateVersion.PrintTemplateID
 	set Result.LastSaveDate = objPrintTemplateVersion.LastSaveDate
 	set Result.LastSaveTime = objPrintTemplateVersion.LastSaveTime
 	set Result.ShapeNames = objPrintTemplateVersion.ShapeNames 
 	if ADataFlag  
 	{
	 	do Result.Data.CopyFrom(objPrintTemplateVersion.Data) 
	}

 	set Result.PublicationDate = objPrintTemplateVersion.PublicationDate
 	set Result.PublicationTime = objPrintTemplateVersion.PublicationTime
 	set Result.CreateDate = objPrintTemplateVersion.CreateDate
 	set Result.CreateTime = objPrintTemplateVersion.CreateTime
 	set Result.Status = objPrintTemplateVersion.Status
 	set Result.Author = objPrintTemplateVersion.Author
 	set Result.VersionNumber = objPrintTemplateVersion.VersionNumber
 
 	//set Result.FootRepeatRowEnd = objPrintTemplateVersion.FootRepeatRowEnd
 	//set Result.FootRepeatRowStart = objPrintTemplateVersion.FootRepeatRowStart
 
   	if ((objPrintTemplateVersion.FootRepeatRowEnd="")||(objPrintTemplateVersion.FootRepeatRowEnd = $C(0)))
  	{ 
   		set Result.FootRepeatRowEnd = "0"
  	}
 	else
 	{	
 		set Result.FootRepeatRowEnd = objPrintTemplateVersion.FootRepeatRowEnd  
	}
 
 	if ((objPrintTemplateVersion.FootRepeatRowStart="") ||((objPrintTemplateVersion.FootRepeatRowStart=$C(0))))
 	{ 
 		set Result.FootRepeatRowStart = "0"
	}
 	Else
 	{ 
 		set Result.FootRepeatRowStart = objPrintTemplateVersion.FootRepeatRowStart   
	}

 	if ((objPrintTemplateVersion.OnePageRowCount="") ||((objPrintTemplateVersion.OnePageRowCount=$C(0))))
 	{ 
 		set Result.OnePageRowCount = "0"
	}
 	Else
 	{ 
 		set Result.OnePageRowCount = objPrintTemplateVersion.OnePageRowCount   
	}

 
 	set Result.HeadStartPageNum = objPrintTemplateVersion.HeadStartPageNum
  	if (Result.HeadStartPageNum="")
  	{
		set Result.HeadStartPageNum="1"  
	}

	set Result.Duplex = objPrintTemplateVersion.Duplex
 	set Result.MultiplePagesOption = objPrintTemplateVersion.MultiplePagesOption
 	set Result.NewPageStartOdd = objPrintTemplateVersion.NewPageStartOdd
 	set Result.BlankPageStyle = objPrintTemplateVersion.BlankPageStyle  //<+add on 2014-11-12 by houj>空白页格式
 	
 	Quit Result
}

ClassMethod PublishVersion(AVersion As EPRservice.entity.EPrintTemplateVersion) As EPRservice.entity.EPrintTemplateVersion [ WebMethod ]
{
	//TSTART
	set objPrintTemplateVersion = ##class(EPRmeta.PrintTemplateVersion).%OpenId(AVersion.ID)
 	set objPrintTemplateVersion.Status = 2
 	set objPrintTemplateVersion.PublicationDate = $ZDATEH($ZDATE($HOROLOG))
 	set objPrintTemplateVersion.PublicationTime = $ZTIMEH($ZTIME($PIECE($HOROLOG,",",2),1))
 	set objPrintTemplateVersion.LastSaveDate = $ZDATEH($ZDATE($HOROLOG))
 	set objPrintTemplateVersion.LastSaveTime = $ZTIMEH($ZTIME($PIECE($HOROLOG,",",2),1))
 	set objPrintTemplate = ##class(EPRmeta.PrintTemplate).%OpenId(AVersion.PrintTemplateID)
 	Set objPrintTemplate.PublishVersion = objPrintTemplateVersion.VersionNumber
 	Do objPrintTemplateVersion.Data.CopyFrom(AVersion.Data)

 	set objPrintTemplateVersion.Author = AVersion.Author
 	set objPrintTemplateVersion.ShapeNames = AVersion.ShapeNames
 
 	set objPrintTemplateVersion.HeadStartPageNum = AVersion.HeadStartPageNum
 
 
   	if ((AVersion.FootRepeatRowEnd="")||(AVersion.FootRepeatRowEnd = $C(0)))
  	{
   		s objPrintTemplateVersion.FootRepeatRowEnd = AVersion.FootRepeatRowEnd
  	}
 	else
 	{	
		s objPrintTemplateVersion.FootRepeatRowEnd = AVersion.FootRepeatRowEnd
	}
 
 	if ((AVersion.FootRepeatRowStart="") ||((AVersion.FootRepeatRowStart=$C(0))))
 	{ 
   		set objPrintTemplateVersion.FootRepeatRowStart = "0"
	}
 	Else
 	{ 
   		set objPrintTemplateVersion.FootRepeatRowStart = AVersion.FootRepeatRowStart 
	}

 	if ((AVersion.OnePageRowCount="") ||((AVersion.OnePageRowCount=$C(0))))
 	{ 
   		set objPrintTemplateVersion.OnePageRowCount = "0"
	}
 	Else
 	{ 
   		set objPrintTemplateVersion.OnePageRowCount = AVersion.OnePageRowCount 
	}


 	set objPrintTemplateVersion.Duplex = AVersion.Duplex
 	set objPrintTemplateVersion.MultiplePagesOption = AVersion.MultiplePagesOption
 	set objPrintTemplateVersion.NewPageStartOdd = AVersion.NewPageStartOdd
 	set objPrintTemplateVersion.BlankPageStyle = AVersion.BlankPageStyle		//<+add on 2014-11-12 by houj>空白页格式
 	//set objPrintTemplateVersion.FootRepeatRowEnd = AVersion.FootRepeatRowEnd
 	//set objPrintTemplateVersion.FootRepeatRowStart = AVersion.FootRepeatRowStart


 	if '(objPrintTemplate.%Save())
 	{
	  	//TROLLBACK
 		Quit 0
 	}

 	if '(objPrintTemplateVersion.%Save())
 	{
	 	// TROLLBACK
 		Quit 0
	}  

 	//	TCOMMIT
 	set Result = ##class(EPRservice.entity.EPrintTemplateVersion).%New()
 	set Result.ID = objPrintTemplateVersion.%Id()
	//set Result.Name = objPrintTemplateVersion.Name
	set Result.PrintTemplateID = objPrintTemplateVersion.PrintTemplateID
 	set Result.LastSaveDate = objPrintTemplateVersion.LastSaveDate
 	set Result.LastSaveTime = objPrintTemplateVersion.LastSaveTime


 	set Result.PublicationDate = objPrintTemplateVersion.PublicationDate
 	set Result.PublicationTime = objPrintTemplateVersion.PublicationTime
 	set Result.CreateDate = objPrintTemplateVersion.CreateDate
 	set Result.CreateTime = objPrintTemplateVersion.CreateTime
 	set Result.Status = objPrintTemplateVersion.Status
 	set Result.Author = objPrintTemplateVersion.Author
 	set Result.ShapeNames = objPrintTemplateVersion.ShapeNames

 	set Result.VersionNumber = objPrintTemplateVersion.VersionNumber
 
 	set Result.HeadStartPageNum = objPrintTemplateVersion.HeadStartPageNum
 	set Result.FootRepeatRowEnd = objPrintTemplateVersion.FootRepeatRowEnd
 	set Result.FootRepeatRowStart = objPrintTemplateVersion.FootRepeatRowStart
  	set Result.OnePageRowCount = objPrintTemplateVersion.OnePageRowCount
 	set Result.Duplex = objPrintTemplateVersion.Duplex
	set Result.MultiplePagesOption = objPrintTemplateVersion.MultiplePagesOption
	set Result.NewPageStartOdd = objPrintTemplateVersion.NewPageStartOdd
	set Result.BlankPageStyle = objPrintTemplateVersion.BlankPageStyle
	
	Quit Result
}

ClassMethod UpdateCraftVersion(AVersion As EPRservice.entity.EPrintTemplateVersion) As EPRservice.entity.EPrintTemplateVersion [ WebMethod ]
{
	TSTART 
	
	set objPrintTemplateVersion = ##class(EPRmeta.PrintTemplateVersion).%OpenId(AVersion.ID)
 	//set objPrintTemplateVersion.Name = AVersion.Name
 	set objPrintTemplateVersion.PrintTemplateID = AVersion.PrintTemplateID
 	set objPrintTemplateVersion.Author = AVersion.Author
 	set objPrintTemplateVersion.ShapeNames = AVersion.ShapeNames
 
 	set objPrintTemplateVersion.HeadStartPageNum = AVersion.HeadStartPageNum
 	set objPrintTemplateVersion.FootRepeatRowEnd = AVersion.FootRepeatRowEnd
 	set objPrintTemplateVersion.FootRepeatRowStart = AVersion.FootRepeatRowStart
 
 	if (AVersion.OnePageRowCount="0")||(AVersion.OnePageRowCount=$C(0))
 	{ 
 		set objPrintTemplateVersion.OnePageRowCount = "0"
	}
 	else
 	{
 		set objPrintTemplateVersion.OnePageRowCount = AVersion.OnePageRowCount
 	}

 	set objPrintTemplateVersion.LastSaveDate = $ZDATEH($ZDATE($HOROLOG))
 	set objPrintTemplateVersion.LastSaveTime = $ZTIMEH($ZTIME($PIECE($HOROLOG,",",2),1))

 	do objPrintTemplateVersion.Data.CopyFrom(AVersion.Data)

 	set objPrintTemplateVersion.Status = 1
 
 	set objPrintTemplateVersion.Duplex = AVersion.Duplex
 	set objPrintTemplateVersion.MultiplePagesOption =AVersion.MultiplePagesOption
 	set objPrintTemplateVersion.NewPageStartOdd =AVersion.NewPageStartOdd
 	set objPrintTemplateVersion.BlankPageStyle =AVersion.BlankPageStyle			//<+add on 2014-11-12 by houj>空白页格式
 	
 	if '(objPrintTemplateVersion.%Save())
 	{
	  	TROLLBACK
 		Quit 0
	}
	    
	TCOMMIT
 
 	set Result = ##class(EPRservice.entity.EPrintTemplateVersion).%New()
 	set Result.ID = objPrintTemplateVersion.%Id()
 	//set Result.Name = objPrintTemplateVersion.Name
 	set Result.PrintTemplateID = objPrintTemplateVersion.PrintTemplateID
 	set Result.LastSaveDate = objPrintTemplateVersion.LastSaveDate
 	set Result.LastSaveTime = objPrintTemplateVersion.LastSaveTime


 	set Result.PublicationDate = objPrintTemplateVersion.PublicationDate
 	set Result.PublicationTime = objPrintTemplateVersion.PublicationTime
 	set Result.CreateDate = objPrintTemplateVersion.CreateDate
 	set Result.CreateTime = objPrintTemplateVersion.CreateTime
 	set Result.Status = objPrintTemplateVersion.Status
	set Result.Author = objPrintTemplateVersion.Author
 	set Result.ShapeNames = objPrintTemplateVersion.ShapeNames

 	set Result.VersionNumber = objPrintTemplateVersion.VersionNumber
 
 	set Result.HeadStartPageNum = objPrintTemplateVersion.HeadStartPageNum

 	//set Result.FootRepeatRowEnd = objPrintTemplateVersion.FootRepeatRowEnd
 	//set Result.FootRepeatRowStart = objPrintTemplateVersion.FootRepeatRowStart

  	if ((objPrintTemplateVersion.FootRepeatRowEnd="")||(objPrintTemplateVersion.FootRepeatRowEnd = $C(0)))
  	{ 
   		set Result.FootRepeatRowEnd = "0"
  	}
 	else
 	{	
 		set Result.FootRepeatRowEnd = objPrintTemplateVersion.FootRepeatRowEnd  
	}
 
 	if ((objPrintTemplateVersion.FootRepeatRowStart="") ||((objPrintTemplateVersion.FootRepeatRowStart=$C(0))))
 	{ 
 		set Result.FootRepeatRowStart = "0"
	}
 	Else
 	{ 
 		set Result.FootRepeatRowStart = objPrintTemplateVersion.FootRepeatRowStart   
	}

  	if ((objPrintTemplateVersion.OnePageRowCount="")||(objPrintTemplateVersion.OnePageRowCount = $C(0)))
  	{ 
   		set Result.OnePageRowCount = "0"
  	}
 	else
 	{	
 		set Result.OnePageRowCount = objPrintTemplateVersion.OnePageRowCount  
	}

  	if (Result.HeadStartPageNum="")
  	{
		set Result.HeadStartPageNum="1"  
	}

	set Result.Duplex = objPrintTemplateVersion.Duplex
	set Result.MultiplePagesOption = objPrintTemplateVersion.MultiplePagesOption
	set Result.NewPageStartOdd = objPrintTemplateVersion.NewPageStartOdd
	set Result.BlankPageStyle = objPrintTemplateVersion.BlankPageStyle		//<+add on 2014-11-12 by houj>空白页格式
	
 	Quit Result
}

ClassMethod UpdateTemplate(APrintTemplate As EPRservice.entity.EPrintTemplate) As %Boolean [ WebMethod ]
{
 TSTART
	//New TempPrintTemplateCategoryID
 set objPrintTemplate = ##class(EPRmeta.PrintTemplate).%OpenId(APrintTemplate.ID)
 set objPrintTemplate.Name = APrintTemplate.Name
 set objPrintTemplate.Description = APrintTemplate.Description
 Set TempPrintTemplateCategoryID = objPrintTemplate.PrintTemplateCategoryID 
 set objPrintTemplate.PrintTemplateCategoryID = APrintTemplate.PrintTemplateCategoryID

 set objPrintTemplate.ChartItemType = APrintTemplate.ChartItemType
 set objPrintTemplate.ContinuePrint = APrintTemplate.ContinuePrint
 set objPrintTemplate.NewPage = APrintTemplate.NewPage

 set objPrintTemplate.PrintTemplateFormat = APrintTemplate.PrintTemplateFormat

 S TmpBindTemplateID = objPrintTemplate.BindTemplateID
 set objPrintTemplate.BindTemplateID = APrintTemplate.BindTemplateID
 set objPrintTemplate.BindTemplateName = APrintTemplate.BindTemplateName
 set objPrintTemplate.UnderLine = APrintTemplate.UnderLine
 set objPrintTemplate.BlankRowWithBorder = APrintTemplate.BlankRowWithBorder

 if TempPrintTemplateCategoryID '= APrintTemplate.PrintTemplateCategoryID
 {
	 	if (TempPrintTemplateCategoryID '="")
	 	{ Set objOldPrintTemplateCategory = ##class(EPRmeta.PrintTemplateCategory).%OpenId(TempPrintTemplateCategoryID)
 set objOldPrintTemplateCategory.ResChildCount = objOldPrintTemplateCategory.ResChildCount - 1
 if '(objOldPrintTemplateCategory.%Save())
 {
	        TROLLBACK
 Quit 0
	       }    
 }
 if (objPrintTemplate.PrintTemplateCategoryID'="")
	 	{
		 	Set objNewPrintTemplateCategory = ##class(EPRmeta.PrintTemplateCategory).%OpenId(objPrintTemplate.PrintTemplateCategoryID)

 set objNewPrintTemplateCategory.ResChildCount = objNewPrintTemplateCategory.ResChildCount + 1
 if '(objNewPrintTemplateCategory.%Save())
 {
	          TROLLBACK
 Quit 0
	        }    
 }   
 }

 /* update bindTemplateID  
 */
 //if (objPrintTemplate.BindTemplateID '= TmpBindTemplateID)
 if (APrintTemplate.BindTemplateID '= TmpBindTemplateID)
 {
 if (TmpBindTemplateID '="")
 {
	  if (objPrintTemplate.BindTemplateID ="")
	  {

 S BindTemplate =##class(EPRmeta.Template).%OpenId(TmpBindTemplateID)

 if (BindTemplate= "")
 {
	        TROLLBACK 
	        Quit 0  //"Error Open BindTemplate"}	 
 }	
 S BindTemplate.BindPrintTemplateID = ""
 S BindTemplate.BindPrintName = ""
 if '(BindTemplate.%Save())
 {
	         TROLLBACK
 Quit 0
	       } 
		}
	   Elseif (objPrintTemplate.BindTemplateID '="")	
	    {

 S NewBindTemplate =##class(EPRmeta.Template).%OpenId(objPrintTemplate.BindTemplateID)


 if (NewBindTemplate= "")
 {
	        TROLLBACK 
	        Quit 0  //"Error Open BindTemplate"}	 
 }	
 S NewBindTemplate.BindPrintTemplateID = objPrintTemplate.%Id()


 S NewBindTemplate.BindPrintName = objPrintTemplate.Name


 if '(NewBindTemplate.%Save())
 {
	         TROLLBACK
 Quit 0
	       } 
	       
	     
 S OldBindTemplate =##class(EPRmeta.Template).%OpenId(TmpBindTemplateID)

 if (OldBindTemplate= "")
 {
	        TROLLBACK 
	        Quit 0  //"Error Open BindTemplate"}	 
 }	

 S OldBindTemplate.BindPrintTemplateID = ""
 S OldBindTemplate.BindPrintName = ""

 if '(OldBindTemplate.%Save())
 {
	         TROLLBACK
 Quit 0
	       } 
	       
		   }
	 }
 Elseif (TmpBindTemplateID ="")
 {
	if (objPrintTemplate.BindTemplateID '="") 
	 {
 S BindTemplate =##class(EPRmeta.Template).%OpenId(objPrintTemplate.BindTemplateID)
 if (BindTemplate= "")
 {
	        TROLLBACK 
	        Quit 0  //"Error Open BindTemplate"}	 
 }	
 S BindTemplate.BindPrintTemplateID = objPrintTemplate.%Id()
 S BindTemplate.BindPrintName = objPrintTemplate.Name
 if '(BindTemplate.%Save())
 {
	         TROLLBACK
 Quit 0
	       } 
		 }
	 }
 }

 if '(objPrintTemplate.%Save())
 {
	 TROLLBACK
	 Quit 0
	 }
 TCOMMIT
 Quit 1
}

ClassMethod GetMaxVIDByTempID(ATEMPLATEID As %String) As %String [ WebMethod ]
{

 Set Result = ##Class(EPRmeta.PrintTemplateVersion).SELECTMAXVERSIONID(ATEMPLATEID)	
 
 Quit Result
}

/// 	Desc:	根据指定ID取打印模板和打印模板联合信息
/// 			AIDFlag="Template" 表示指定打印模板ID, 取最新发布的打印模板版本信息
/// 			AIDFlag="Version"  表示指定打印模板版本ID, 取该版本的打印模板版本信息
ClassMethod GetMixPrintVersion(AMixId As %String, AIDFlag As %String) As EPRservice.entity.EMixPrintVersion [ WebMethod ]
{
	q:(AMixId = "")||(AIDFlag = "") ""
 
 	if (AIDFlag = "Template")
 	{
 		q ..GetMixVersionByPrintTemlateID(AMixId)
 	}
 	Elseif (AIDFlag="Version")
 	{
 	  	q ..GetMixVersionByPTVersionID(AMixId)
	}
}

/// Desc:	根据指定PrintTemplateID获取打印模板和其已发布最大版本打印模板版本信息
ClassMethod GetMixVersionByPrintTemlateID(APrintTemplateID As %String) As EPRservice.entity.EMixPrintVersion
{
	q:(APrintTemplateID = "") ""
	
	s objPrintTemplate = ##Class(EPRmeta.PrintTemplate).%OpenId(APrintTemplateID)
	q:(objPrintTemplate = "") ""
	
	s versionNumber = objPrintTemplate.PublishVersion
	q:(versionNumber < 1) ""
	s objPrintTemplate = ""
	
	s printTemplateVersionID = ##class(EPRmeta.PrintTemplateVersion).GetMaxPublishVersionID(APrintTemplateID, versionNumber)
	q:(printTemplateVersionID="")||(printTemplateVersionID="0") ""
	
	s objEMixPrintVersion = ..GetMixVersionByPTVersionID(printTemplateVersionID)
	q objEMixPrintVersion
}

/// Desc: 	根据指定PrintTemplateID和VersionNumber获取打印模板和打印模板版本的联合信息
/// Input：	APrintTemplateID ：指定的PrintTemplateID
/// 		AVersionNumber ：指定的VersionNumber
/// Output：EPRservice.entity.EMixPrintVersion
ClassMethod GetMixVersionByPTVersionNum(APrintTemplateID As %String, AVersionNumber As %String) As EPRservice.entity.EMixPrintVersion
{
	q:(APrintTemplateID="")||(AVersionNumber="") ""
	
	s printTemplateVersionID = ##class(EPRmeta.PrintTemplateVersion).GetMaxPublishVersionID(APrintTemplateID, AVersionNumber)
	q:(printTemplateVersionID="")||(printTemplateVersionID="0") ""
	
	s objEMixPrintVersion = ..GetMixVersionByPTVersionID(printTemplateVersionID)
	q objEMixPrintVersion
}

/// Desc: 	根据指定打印模板版本ID获取打印模板和打印模板版本的联合信息
/// Input:	APrintTemplateVersionID : 指定的打印模板版本ID
/// Output：EPRservice.entity.EMixPrintVersion
ClassMethod GetMixVersionByPTVersionID(APrintTemplateVersionID As %String) As EPRservice.entity.EMixPrintVersion
{
	q:(APrintTemplateVersionID = "") ""
	
	s objPrintTemplateVersion = ##Class(EPRmeta.PrintTemplateVersion).%OpenId(APrintTemplateVersionID)
	q:(objPrintTemplateVersion = "") ""
	q:(objPrintTemplateVersion.PrintTemplateID = "") ""
	
	s objPrintTemplate = ##Class(EPRmeta.PrintTemplate).%OpenId(objPrintTemplateVersion.PrintTemplateID)
	q:(objPrintTemplate = "") ""
	
	//初始化返回值
 	set objResult = ##class(EPRservice.entity.EMixPrintVersion).%New()
 	quit:(objResult="") ""
 	
 	//打印模板信息
 	set objResult.Name = objPrintTemplate.Name
 	set objResult.Description = objPrintTemplate.Description
 	set objResult.PublishVersion = objPrintTemplate.PublishVersion
 	set objResult.GUID = objPrintTemplate.GUID
 	set objResult.LastVersion = objPrintTemplate.LastVersion
 	set objResult.PrintTemplateFormat = objPrintTemplate.PrintTemplateFormat
 	set objResult.ChartItemType = objPrintTemplate.ChartItemType
 	set objResult.ContinuePrint = objPrintTemplate.ContinuePrint
 	set objResult.NewPage = objPrintTemplate.NewPage
 	set objResult.BindTemplateID = objPrintTemplate.BindTemplateID
 	set objResult.BindTemplateName = objPrintTemplate.BindTemplateName
 	set objResult.UnderLine = objPrintTemplate.UnderLine
 	set objResult.BlankRowWithBorder = objPrintTemplate.BlankRowWithBorder
 	
 	//打印模板版本信息
 	set objResult.LastSaveDate = objPrintTemplateVersion.LastSaveDate
 	set objResult.LastSaveTime = objPrintTemplateVersion.LastSaveTime
 	set objResult.PrintTemplateID = objPrintTemplateVersion.PrintTemplateID
 	set objResult.ShapeNames = objPrintTemplateVersion.ShapeNames 
 	set objResult.PublicationDate = objPrintTemplateVersion.PublicationDate
 	set objResult.PublicationTime = objPrintTemplateVersion.PublicationTime
	set objResult.CreateDate = objPrintTemplateVersion.CreateDate
 	set objResult.CreateTime = objPrintTemplateVersion.CreateTime
 	set objResult.Status = objPrintTemplateVersion.Status
 	set objResult.Author = objPrintTemplateVersion.Author
 	set objResult.VersionNumber = objPrintTemplateVersion.VersionNumber
 	do objResult.Data.CopyFrom(objPrintTemplateVersion.Data) 
 	
 	set objResult.FootRepeatRowStart = objPrintTemplateVersion.FootRepeatRowStart   
 	if ((objResult.FootRepeatRowStart="") ||((objResult.FootRepeatRowStart=$C(0))))
 	{ 
 		set objResult.FootRepeatRowStart = "0"
 	}
 	set objResult.FootRepeatRowEnd = objPrintTemplateVersion.FootRepeatRowEnd 
   	if ((objResult.FootRepeatRowEnd="")||(objResult.FootRepeatRowEnd = $C(0)))
  	{ 
   		set objResult.FootRepeatRowEnd = "0"
  	}
	set objResult.OnePageRowCount = objPrintTemplateVersion.OnePageRowCount
 	if ((objResult.OnePageRowCount="") ||((objResult.OnePageRowCount=$C(0))))
 	{ 
 		set objResult.OnePageRowCount = "0"
	}
 	set objResult.HeadStartPageNum = objPrintTemplateVersion.HeadStartPageNum
 	if (objResult.HeadStartPageNum="")||(objResult.HeadStartPageNum=$C(0))
  	{
		set objResult.HeadStartPageNum="1"  
	}
	set objResult.Duplex = objPrintTemplateVersion.Duplex
	set objResult.MultiplePagesOption = objPrintTemplateVersion.MultiplePagesOption
	set objResult.NewPageStartOdd = objPrintTemplateVersion.NewPageStartOdd
	set objResult.BlankPageStyle = objPrintTemplateVersion.BlankPageStyle	//<+add on 2014-11-12 by houj>空白页格式
	
	set objPrintTemplate = ""
	set objPrintTemplateVersion = ""
	
	q objResult
}

/// Desc:	取发布的最大版本的PrintTemplateVersionD
ClassMethod GetMaxPublishVersionID(APrintTemplateID As %String) As %String
{
	s objPrintTemplate = ##Class(EPRmeta.PrintTemplate).%OpenId(APrintTemplateID)
	q:(objPrintTemplate = "") ""
	
	s versionNumber = objPrintTemplate.PublishVersion
	q:(versionNumber < 1) ""
	s objPrintTemplate = ""
	
	s printTemplateVersionID = ##class(EPRmeta.PrintTemplateVersion).GetMaxPublishVersionID(APrintTemplateID, versionNumber)
	q:(printTemplateVersionID="")||(printTemplateVersionID="0") ""
	q printTemplateVersionID
}

/// Desc:	取打印模板打印类型
/// Debug:	w ##Class(EPRservice.BOPrintTemplate).GetPrintType("27")
ClassMethod GetPrintType(APrintTemplateID As %String) As %String
{
	q:(APrintTemplateID="") ""
	
	s objPrintTemplate = ##Class(EPRmeta.PrintTemplate).%OpenId(APrintTemplateID)
	q:(objPrintTemplate = "") ""
	
	q objPrintTemplate.ChartItemType
}

/// 	+++++++++++	测试方法 +++++++++++
/// w ##class(EPRservice.BOPrintTemplate).TestCrateTemplate()
ClassMethod TestCrateTemplate()
{
	s obj = ##class(EPRservice.entity.EPrintTemplate).%New()
	
	s obj.BindTemplateID	=""	
	s obj.BindTemplateName	="" //null	
	s obj.ChartItemType	="Multiple"	
	s obj.ContinuePrint	=1	
	//s obj.ContinuePrintSpecified=1
	s obj.Description=	""	
	s obj.GUID=	"4c3-f373-4d64-93a2-b2210daf6b9f"	
	s obj.ID=	""	
	s obj.LastVersion=	0	
	//s obj.LastVersionSpecified=	1	
	s obj.Name	="产时记录单"	
	s obj.NewPage=	0	
	//s obj.NewPageSpecified=1	
	s obj.PrintTemplateCategoryID=	"195"	
	s obj.PrintTemplateFormat=	"Text"
	s obj.PublishVersion=	0	
	//s obj.PublishVersionSpecified=	1	
	s obj.UnderLine	=0	
	//s obj.UnderLineSpecified=	0	
	
	s id = ..CreateTemplate(obj)
	w id
}

}
