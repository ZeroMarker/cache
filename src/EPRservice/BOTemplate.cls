Class EPRservice.BOTemplate Extends %SOAP.WebService [ Not ProcedureBlock ]
{

/// TODO: change this to actual network address.
/// URL for invoking the WebService.
/// TODO: change this to actual SOAP namespace.
/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/metaservice";

/// Name of the WebService.
Parameter SERVICENAME = "TemplateInfo";

ClassMethod CreateCraftVersion(AVersion As EPRservice.entity.ETemplateVersion) As EPRservice.entity.ETemplateVersion [ WebMethod ]
{
	Set NewMaxVersion = ##class(EPRmeta.TemplateVersion).SELECTMAXVERSION(AVersion.TemplateID)
	
	TSTART
	set objTemplateVersion = ##class(EPRmeta.TemplateVersion).%New()
	set Result = ##class(EPRservice.entity.ETemplateVersion).%New()
 Quit:(objTemplateVersion ="") "" 


 set objTemplateVersion.TemplateID = AVersion.TemplateID
 set Result.TemplateID = AVersion.TemplateID

 set objTemplateVersion.Author = AVersion.Author
 set Result.Author = AVersion.Author

 set objTemplateVersion.LastSaveDate = $ZDATEH($ZDATE($HOROLOG))
 //$ZDATEH($ZDATE($HOROLOG))
 set Result.LastSaveDate = objTemplateVersion.LastSaveDate //$ZDATE($HOROLOG)

 //set Result.LastSaveTime = $ZTIME($PIECE($HOROLOG,",",2),1)
 set objTemplateVersion.LastSaveTime = $ZTIMEH($ZTIME($PIECE($HOROLOG,",",2),1))
 
 set Result.LastSaveTime = objTemplateVersion.LastSaveTime


 do objTemplateVersion.InitialData.CopyFrom(AVersion.InitialData)
 do objTemplateVersion.MetaData.CopyFrom(AVersion.MetaData)
 do objTemplateVersion.PresentationData.CopyFrom(AVersion.PresentationData)
 do objTemplateVersion.GridData.CopyFrom(AVersion.GridData) //lingchen Grid模板信息

 set objTemplateVersion.Status = 0
 set Result.Status = 0

 if NewMaxVersion= ""
 {
	 	set objTemplateVersion.VersionNumber = 1
	} elseif '(NewMaxVersion="")
	{
		set objTemplateVersion.VersionNumber =NewMaxVersion + 1}
	 	
 set Result.VersionNumber = objTemplateVersion.VersionNumber

 set objTemplateVersion.CreateDate = $ZDATEH($ZDATE($HOROLOG))
 //set Result.CreateDate = $ZDATE($HOROLOG)
 set Result.CreateDate = objTemplateVersion.CreateDate

 set objTemplateVersion.CreateTime = $ZTIMEH($ZTIME($PIECE($HOROLOG,",",2),1))
 //
 set Result.CreateTime = objTemplateVersion.CreateTime  //$ZTIME($PIECE($HOROLOG,",",2),1)
 
 //set objTemplateVersion.PublicationDate = AVersion.PublicationDate
 //set objTemplateVersion.PublicationTime = AVersion.PublicationTime  
	
 set objTemplate = ##class(EPRmeta.Template).%OpenId(AVersion.TemplateID)
 if (objTemplate ="")
 {
	  TROLLBACK
 Quit ""
	}
	
	set objTemplate.LastVersion = objTemplate.LastVersion + 1
	if '(objTemplate.%Save())
	{
	  TROLLBACK
 Quit ""
	} 

	
	if '(objTemplateVersion.%Save())
	 { TROLLBACK 
	  Quit ""
	} 
	
 /*Set sc = ##class(%XML.TextReader).ParseStream(AVersion.MetaData,.reader) 
	Set newNTemplateVersion=##class(EPRmeta.Parser.NTemplateVersion).%New()
	set newNTemplateVersion.TemplateID=objTemplateVersion.%Id()
	set newNTemplateVersion.TemplateVersion=objTemplateVersion.VersionNumber
	
	if ($$$ISOK(sc)) 
	{ do reader.Read()
	  do newNTemplateVersion.XMLDeserialize(reader) 	   	
	}
	d newNTemplateVersion.FileImageAnnotate(AVersion.MetaData)
	d newNTemplateVersion.UpdateMetaData()*/	
	
	TCOMMIT

	set Result.ID = objTemplateVersion.%Id()
 	//set Result.InitialData = objTemplateVersion.InitialData
 	//set Result.MetaData = objTemplateVersion.MetaData
 	//set Result.PresentationData = objTemplateVersion.PresentationData

    do Result.InitialData.CopyFrom(objTemplateVersion.InitialData)
 	do Result.MetaData.CopyFrom(objTemplateVersion.MetaData)
 	do Result.PresentationData.CopyFrom(objTemplateVersion.PresentationData)

	Quit Result
}

ClassMethod CreateTemplate(ATemplate As EPRservice.entity.ETemplate) As %String [ WebMethod ]
{
	TSTART
	set objTemplate = ##class(EPRmeta.Template).%New()
 if (objTemplate ="")
 {
	  TROLLBACK
 Quit ""
 }
 set objTemplate.Description = ATemplate.Description
 set objTemplate.TemplateCategoryID = ATemplate.TemplateCategoryID
 set objTemplate.Name = ATemplate.Name
 set objTemplate.LastVersion = 0
 set objTemplate.GUID = ATemplate.GUID
 set objTemplate.PublishVersion = 0

 set objTemplate.TemplateProperty = ATemplate.TemplateProperty


 set objTemplate.ChartItemType = ATemplate.ChartItemType
 set objTemplate.BindPrintTemplateID = ATemplate.BindPrintTemplateID
 set objTemplate.BindPrintName = ATemplate.BindPrintName



 set objTemplateCategory = ##class(EPRmeta.TemplateCategory).%OpenId(objTemplate.TemplateCategoryID)
 if (objTemplateCategory ="")
 {
	  TROLLBACK
 Quit ""
 }
 set objTemplateCategory.ResChildCount = objTemplateCategory.ResChildCount + 1
 if '(objTemplateCategory.%Save())
 {
 TROLLBACK
 Quit ""
 } 
 //set ATemplate.PublishVersion = 0
 //set ATemplate.LastVersion = 1
 if '(objTemplate.%Save())
 {
	  TROLLBACK
 Quit ""
	 } 
	 TCOMMIT
	 //set ATemplate.ID = objTemplate.%Id()
	 Quit objTemplate.%Id()
}

/// w ##class(EPRservice.BOTemplate).DelTemplate(templateid)
ClassMethod DelTemplate(AID As %String) As %Boolean [ WebMethod ]
{

	TSTART
	set objTemplate = ##class(EPRmeta.Template).%OpenId(AID)
	if (objTemplate ="")
	{
		TROLLBACK
		Quit 0
	}
	Set objTemplateCategory = ##class(EPRmeta.TemplateCategory).%OpenId(objTemplate.TemplateCategoryID)
	if (objTemplateCategory ="")
	{
		TROLLBACK
		Quit 0
	}	
	set objTemplateCategory.ResChildCount = objTemplateCategory.ResChildCount - 1
	if '(objTemplateCategory.%Save())
	{
		TROLLBACK
		Quit 0
	}	

	if ((objTemplate.BindPrintTemplateID '= "") && (objTemplate.BindPrintTemplateID '= $c(0))) 
	{
		S BindPrintTemplate= ##class(EPRmeta.PrintTemplate).%OpenId(objTemplate.BindPrintTemplateID)
		if (BindPrintTemplate="") 
		{
			TROLLBACK
			Quit 0
		}
		s BindPrintTemplate.BindTemplateID =""
		s BindPrintTemplate.BindTemplateName =""
		if '(BindPrintTemplate.%Save())
 		{
			TROLLBACK
			Quit 0
		}	
	}
	 
	if '(objTemplate.%DeleteId(AID))
	{
		TROLLBACK
		Quit 0
	}
	TCOMMIT
	Quit 1
}

ClassMethod DeleteCraftVersion(AID As %String) As %Boolean [ WebMethod ]
{
	TSTART
	set objTemplateVersion = ##class(EPRmeta.TemplateVersion).%OpenId(AID)
	
	set objTemplate = ##class(EPRmeta.Template).%OpenId(objTemplateVersion.TemplateID)
	/*if (objTemplate="")
	{
	  TROLLBACK
 Quit 0
	} */
	Set objTemplate.LastVersion = objTemplateVersion.VersionNumber - 1

	if '(objTemplate.%Save())
	{
	  TROLLBACK
 Quit 0
	} 
	D ##class(EPRmeta.ImageAnnotate).DeleteAnnotateByVersion(AID,objTemplateVersion.TemplateID)
	
	if '(objTemplateVersion.%DeleteId(AID))
	{
	  TROLLBACK
 Quit 0
 }
	TCOMMIT
	Quit 1
}

ClassMethod GetInitialDataByID(AID As %String) As EPRservice.entity.ETemplateVersion [ WebMethod ]
{
 set objTemplateVersion = ##class(EPRmeta.TemplateVersion).%OpenId(AID)
 q:(objTemplateVersion="") ""

 set Result = ##class(EPRservice.entity.ETemplateVersion).%New()
 q:(Result="") ""
 set Result.ID = objTemplateVersion.%Id()
 //set Result.Name = objPrintTemplateVersion.Name

 set Result.InitialData = objTemplateVersion.InitialData
 //set Result.MetaData = objTemplateVersion.MetaData
 //set Result.PresentationData = objTemplateVersion.PresentationData
 Quit Result
}

ClassMethod GetInitialDataByTemplateID(ATemplateID As %String) As EPRservice.entity.ETemplateVersion [ WebMethod ]
{
 set AID= ##class(EPRmeta.TemplateVersion).GetMaxPubVrnID(ATemplateID) 

 s ^AAA($J,"AID") = AID	_"@@"_ATemplateID
 Q:(AID="") ""  

	
 set objTemplateVersion = ##class(EPRmeta.TemplateVersion).%OpenId(AID)
 q:(objTemplateVersion="") ""

 set Result = ##class(EPRservice.entity.ETemplateVersion).%New()
 q:(Result="") ""
 set Result.ID = objTemplateVersion.%Id()
 //set Result.Name = objPrintTemplateVersion.Name

 set Result.InitialData = objTemplateVersion.InitialData
 //set Result.MetaData = objTemplateVersion.MetaData
 //set Result.PresentationData = objTemplateVersion.PresentationData
 Quit Result
}

ClassMethod GetMetadataByID(AID As %String) As EPRservice.entity.ETemplateVersion [ WebMethod ]
{
 set objTemplateVersion = ##class(EPRmeta.TemplateVersion).%OpenId(AID)
 q:(objTemplateVersion="") ""

 set Result = ##class(EPRservice.entity.ETemplateVersion).%New()
 q:(Result="") ""
 set Result.ID = objTemplateVersion.%Id()
 //set Result.Name = objPrintTemplateVersion.Name

 //set Result.InitialData = objTemplateVersion.InitialData
 d Result.MetaData.CopyFrom(objTemplateVersion.MetaData)
 //set Result.PresentationData = objTemplateVersion.PresentationData
 Quit Result
}

ClassMethod GetMetadataByTemplateID(ATemplateID As %String) As EPRservice.entity.ETemplateVersion [ WebMethod ]
{
 if ATemplateID =""
 {
	 Quit "" }
 set objTemplate = ##class(EPRmeta.Template).%OpenId(ATemplateID)	 
 if (objTemplate="")	 
 {
	 Quit "" }
	 
 Set AVersionNum = objTemplate.PublishVersion
 if (AVersionNum="")
 {
	Quit ""  
	  }
 if (AVersionNum=0)	  
 {
	Quit ""  
	  }	  
 s Rusult = ##class(EPRservice.entity.ETemplateVersion).%New()
 s Rusult.MetaData= ##class(EPRmeta.TemplateVersion).GetMetaData(ATemplateID,AVersionNum)
 Quit Rusult
}

ClassMethod GetPresentationDataByID(AID As %String) As EPRservice.entity.ETemplateVersion [ WebMethod ]
{
 set objTemplateVersion = ##class(EPRmeta.TemplateVersion).%OpenId(AID)
 q:(objTemplateVersion="") ""

 set Result = ##class(EPRservice.entity.ETemplateVersion).%New()
 q:(Result="") ""
 set Result.ID = objTemplateVersion.%Id()
 //set Result.Name = objPrintTemplateVersion.Name

 //set Result.InitialData = objTemplateVersion.InitialData
 //set Result.MetaData = objTemplateVersion.MetaData
 d Result.PresentationData.CopyFrom(objTemplateVersion.PresentationData)
 Quit Result
}

/// 取得所有template
ClassMethod GetTemplateAll(ACategoryID As %String) As EPRservice.dataset.ETemplateDataset [ WebMethod ]
{
 Set result=##class(EPRservice.dataset.ETemplateDataset).%New()
 Do result.SetArgs(ACategoryID)
 Quit result
}

/// 取得所有template用于选择模板
ClassMethod GetTemplateAllForSlt(ACategoryID As %String, AEpisodeID As %String) As EPRservice.dataset.ETempForSltDataset [ WebMethod ]
{
 Set result=##class(EPRservice.dataset.ETempForSltDataset).%New()
 Do result.SetArgs(ACategoryID,AEpisodeID)
 Quit result
}

/// 取得所有带有模板组信息的template 
ClassMethod GetTemplateWithGroupAll(ACategoryID As %String) As %XML.DataSet [ WebMethod ]
{
 Set result=##class(EPRservice.dataset.ETemplateWithGroupDataset).%New()
 Do result.SetArgs(ACategoryID)
 Quit result
}

ClassMethod GetTemplateByGUID(AGUID As %String) As EPRservice.entity.ETemplate [ WebMethod ]
{
 Set AID = ##Class(EPRmeta.Template).SELECTBYGUID(AGUID)	
 Quit:AID="" ""
 set objTemplate = ##class(EPRmeta.Template).%OpenId(AID)
 Q:(objTemplate="") ""

 set Result = ##class(EPRservice.entity.ETemplate).%New()
 Q:(Result="") ""

 set Result.ID = objTemplate.%Id()
 set Result.Name = objTemplate.Name
 set Result.TemplateCategoryID = objTemplate.TemplateCategoryID
 set Result.Description = objTemplate.Description
 set Result.PublishVersion = objTemplate.PublishVersion
 set Result.GUID = objTemplate.GUID
 set Result.LastVersion = objTemplate.LastVersion


 set Result.TemplateProperty = objTemplate.TemplateProperty



 set Result.ChartItemType = objTemplate.ChartItemType
 set Result.BindPrintTemplateID = objTemplate.BindPrintTemplateID
 set Result.BindPrintName = objTemplate.BindPrintName


 Quit Result
}

ClassMethod GetTemplateByID(AID As %String) As EPRservice.entity.ETemplate [ WebMethod ]
{
	set objTemplate = ##class(EPRmeta.Template).%OpenId(AID)
	Q:(objTemplate="") ""

 set Result = ##class(EPRservice.entity.ETemplate).%New()
	Q:(Result="") ""

 set Result.ID = objTemplate.%Id()
 set Result.Name = objTemplate.Name
 set Result.TemplateCategoryID = objTemplate.TemplateCategoryID
 set Result.Description = objTemplate.Description
 set Result.PublishVersion = objTemplate.PublishVersion
 set Result.GUID = objTemplate.GUID
 set Result.LastVersion = objTemplate.LastVersion

 set Result.TemplateProperty = objTemplate.TemplateProperty

 set Result.ChartItemType = objTemplate.ChartItemType
 set Result.BindPrintTemplateID = objTemplate.BindPrintTemplateID
 set Result.BindPrintName = objTemplate.BindPrintName

 Quit Result
}

ClassMethod GetTemplateVersionAll(ATemplateId As %String) As EPRservice.dataset.ETemplateVersionDataset [ WebMethod ]
{
 Set result=##class(EPRservice.dataset.ETemplateVersionDataset).%New()
 Do result.SetArgs(ATemplateId)
 Quit result
}

ClassMethod GetVersionByID(AID As %String, ADataFlag As %Boolean) As EPRservice.entity.ETemplateVersion [ WebMethod ]
{
	set objTemplateVersion = ##class(EPRmeta.TemplateVersion).%OpenId(AID)
	q:(objTemplateVersion="") ""
 set Result = ##class(EPRservice.entity.ETemplateVersion).%New()
 q:(Result="") ""
 set Result.ID = objTemplateVersion.%Id()
 //set Result.Name = objPrintTemplateVersion.Name
 set Result.TemplateID = objTemplateVersion.TemplateID
 set Result.LastSaveDate = objTemplateVersion.LastSaveDate
 set Result.LastSaveTime = objTemplateVersion.LastSaveTime
 if ADataFlag 
 {
 d Result.InitialData.CopyFrom(objTemplateVersion.InitialData)
 d Result.MetaData.CopyFrom(objTemplateVersion.MetaData)
 d Result.PresentationData.CopyFrom(objTemplateVersion.PresentationData)
 d Result.GridData.CopyFrom(objTemplateVersion.GridData)
 }
 set Result.PublicationDate = objTemplateVersion.PublicationDate
 set Result.PublicationTime = objTemplateVersion.PublicationTime
 set Result.CreateDate = objTemplateVersion.CreateDate
 set Result.CreateTime = objTemplateVersion.CreateTime
 set Result.Status = objTemplateVersion.Status
 set Result.Author = objTemplateVersion.Author
 set Result.VersionNumber = objTemplateVersion.VersionNumber
 Quit Result
}

ClassMethod GetVersionByTemplateID(ATemplateID As %String) As EPRservice.entity.ETemplateVersion [ WebMethod ]
{
 set AID= ##class(EPRmeta.TemplateVersion).GetMaxPubVrnID(ATemplateID) 

 s ^AAA($J,"AID") = AID	_"@@"_ATemplateID
 Q:(AID="") ""  

	
 set objTemplateVersion = ##class(EPRmeta.TemplateVersion).%OpenId(AID)
 Q:(objTemplateVersion="") ""

 set Result = ##class(EPRservice.entity.ETemplateVersion).%New()
 q:(Result="") ""
 set Result.ID = objTemplateVersion.%Id()
 //set Result.Name = objPrintTemplateVersion.Name

 set Result.InitialData = objTemplateVersion.InitialData
 set Result.MetaData = objTemplateVersion.MetaData
 set Result.PresentationData = objTemplateVersion.PresentationData
 Quit Result
}

ClassMethod GuidMap2ID(AGuidStr As %String) As %String [ WebMethod ]
{
 //B "S"
 if (AGuidStr="")
 {
	Quit ""  
	 }	
 elseif (AGuidStr'="") 	  
	{
	 S IDCount =$L(AGuidStr,",")
	 S AIDStr= ""	 
	 For I=1:1:IDCount
	 {
		//B "S"
		S AGuidItem= $P(AGuidStr,",",I)
		S AGuidItem = $ZCONVERT(AGuidItem,"U")
		S ABlankGuidItem =" "_AGuidItem
		 
		 if $D(^DHCEPRM.TemplateI)
		 {
		  //B "S"
		  Set AID = $O(^DHCEPRM.TemplateI("TplGuidIdx",ABlankGuidItem,""))	 
			 }
	      else{
		       s AID = "" 
		      }		 
		
	   if (I=1)
	   {
		//B "S"
		if (AID="")
		{s AIDStr="*NULL"	
			}
		elseif '(AID="")
		{
		  s AIDStr=AID	
			}	
		}
	    Elseif (I>1)
	    {
		 if (AID="")
		  {s AIDStr=AIDStr_","_"*NULL"	
			}
		elseif '(AID="")
		{
		  s AIDStr=AIDStr_","_AID	
			}	
		    
		 } 	
	 }
	 
	 Quit AIDStr
	 }
}

ClassMethod IDMap2Guid(AIDStr As %String) As %String [ WebMethod ]
{
 if (AIDStr="")
 {
	Quit ""  
	 }	
 elseif (AIDStr'="") 	  
	{
	 S IDCount =$L(AIDStr,",")
	 S AGuidStr= ""	 
	 For I=1:1:IDCount
	 {
		S AIDItem= $P(AIDStr,",",I)
		S objTempleta = ##class(EPRmeta.Template).%OpenId(AIDItem)
	   if (I=1)
	   {
		if '(objTempleta="")
		{
		  if '(objTempleta.GUID="")	
		  {
			 S AGuidStr= objTempleta.GUID
		   }
		   elseif (objTempleta.GUID="")	
		   {
			 S AGuidStr="*NULL"	  
			}
		}
		Elseif (objTempleta="")
		{
		  S AGuidStr="*NULL"	
		}
		}
	    Elseif (I>0)
	    {
		if '(objTempleta="")
		{
		  if '(objTempleta.GUID="")	
		  {
			 S AGuidStr= AGuidStr_","_ objTempleta.GUID
		   }
		   elseif (objTempleta.GUID="")	
		   {
			 S AGuidStr=AGuidStr_","_ "*NULL"	  
			}
		}
		Elseif (objTempleta="")
		{
		  S AGuidStr=AGuidStr_","_ "*NULL"	
		}
		 }	   	 
		 
		 } 	
		Quit AGuidStr
		}
}

ClassMethod PublishVersion(AVersion As EPRservice.entity.ETemplateVersion) As EPRservice.entity.ETemplateVersion [ WebMethod ]
{
	TSTART
	set objTemplateVersion = ##class(EPRmeta.TemplateVersion).%OpenId(AVersion.ID)
 set objTemplateVersion.Status = 2
 set objTemplateVersion.PublicationDate =$ZDATEH($ZDATE($HOROLOG))
 set objTemplateVersion.PublicationTime = $ZTIMEH($ZTIME($PIECE($HOROLOG,",",2),1))
 set objTemplateVersion.LastSaveDate = $ZDATEH($ZDATE($HOROLOG))
 set objTemplateVersion.LastSaveTime = $ZTIMEH($ZTIME($PIECE($HOROLOG,",",2),1))
 set objTemplate = ##class(EPRmeta.Template).%OpenId(AVersion.TemplateID)
 Set objTemplate.PublishVersion = objTemplateVersion.VersionNumber
 do objTemplateVersion.InitialData.CopyFrom(AVersion.InitialData)

 do objTemplateVersion.MetaData.CopyFrom(AVersion.MetaData)

 do objTemplateVersion.PresentationData.CopyFrom(AVersion.PresentationData)
 set objTemplateVersion.Author = AVersion.Author

 if '(objTemplate.%Save())
 {
	  TROLLBACK
 Quit 0
 }

 if '(objTemplateVersion.%Save())
 {
	  TROLLBACK
 Quit 0
	} 
 d ##class(EPRservice.BOTemplate).UpdateImage(objTemplateVersion.MetaData,AVersion.TemplateID,objTemplateVersion.VersionNumber)
 //if ( ##class(EPRservice.BOTemplate).UpdateImage(objTemplateVersion.MetaData,objTemplateVersion.TemplateID,objTemplateVersion.VersionNumber)="0" )
 //{  TROLLBACK
 // Quit 0
 //}
	
	   
	TCOMMIT
	set Result = ##class(EPRservice.entity.ETemplateVersion).%New()
	set Result.ID = objTemplateVersion.%Id()
 //set Result.Name = objPrintTemplateVersion.Name
 set Result.TemplateID = objTemplateVersion.TemplateID
 set Result.LastSaveDate = objTemplateVersion.LastSaveDate
 set Result.LastSaveTime = objTemplateVersion.LastSaveTime
 set Result.PublicationDate = objTemplateVersion.PublicationDate
 set Result.PublicationTime = objTemplateVersion.PublicationTime
 set Result.CreateDate = objTemplateVersion.CreateDate
 set Result.CreateTime = objTemplateVersion.CreateTime
 set Result.Status = objTemplateVersion.Status
 set Result.Author = objTemplateVersion.Author
 set Result.VersionNumber = objTemplateVersion.VersionNumber 

 Quit Result
}

ClassMethod UpdateCraftVersion(AVersion As EPRservice.entity.ETemplateVersion) As EPRservice.entity.ETemplateVersion [ WebMethod ]
{
	//debug begin
	/*
	k ^DHCEPRDebug("EPRservice.BOTemplate.UpdateCraftVersion")
	
	s len=1024*15
	s count = 0
	d AVersion.InitialData.Rewind()
	while (AVersion.InitialData.AtEnd = 0)
	{
		s count = count + 1
		s ^DHCEPRDebug("EPRservice.BOTemplate.UpdateCraftVersion","initdata",count)=AVersion.InitialData.Read(len)
	}
	d AVersion.InitialData.Rewind()
	
	s count = 0
	d AVersion.MetaData.Rewind()
	while (AVersion.MetaData.AtEnd = 0)
	{
		s count = count + 1
		s ^DHCEPRDebug("EPRservice.BOTemplate.UpdateCraftVersion","metadata",count)=AVersion.MetaData.Read(len)
	}
	d AVersion.MetaData.Rewind()
	
	s count = 0
	d AVersion.PresentationData.Rewind()
	while (AVersion.PresentationData.AtEnd = 0)
	{
		s count = count + 1
		s ^DHCEPRDebug("EPRservice.BOTemplate.UpdateCraftVersion","presentdata",count)=AVersion.PresentationData.Read(len)
	}
	d AVersion.PresentationData.Rewind()
	
	s ^DHCEPRDebug("EPRservice.BOTemplate.UpdateCraftVersion","id")=AVersion.ID
	*/
	//debug end

 TSTART 
 set objTemplateVersion = ##class(EPRmeta.TemplateVersion).%OpenId(AVersion.ID) 

 set objTemplateVersion.TemplateID = AVersion.TemplateID

 set objTemplateVersion.Author = AVersion.Author  //AVersion.Author

 set objTemplateVersion.LastSaveDate =  $ZDATEH($ZDATE($HOROLOG))

 set objTemplateVersion.LastSaveTime = $ZTIMEH($ZTIME($PIECE($HOROLOG,",",2),1))


 do objTemplateVersion.InitialData.CopyFrom(AVersion.InitialData) //.CopyFrom(

 do objTemplateVersion.MetaData.CopyFrom(AVersion.MetaData)

 do objTemplateVersion.PresentationData.CopyFrom(AVersion.PresentationData)
 
 do objTemplateVersion.GridData.CopyFrom(AVersion.GridData)

 set objTemplateVersion.Status = 1

 if '(objTemplateVersion.%Save())
 {
 TROLLBACK
 Quit 0
 }
 //*B "S"
 d ##class(EPRservice.BOTemplate).UpdateImage(objTemplateVersion.MetaData,AVersion.TemplateID,objTemplateVersion.VersionNumber)
 /*s UpdataImageValue=##class(EPRservice.BOTemplate).UpdateImage(objTemplateVersion.MetaData,objTemplateVersion.TemplateID,objTemplateVersion.VersionNumber)
 if ( UpdataImageValue="0" )
 {  TROLLBACK
 Quit 0
 } */

 TCOMMIT
	set Result = ##class(EPRservice.entity.ETemplateVersion).%New()
	set Result.ID = objTemplateVersion.%Id()
 //set Result.Name = objPrintTemplateVersion.Name
 set Result.TemplateID = objTemplateVersion.TemplateID
 set Result.LastSaveDate = objTemplateVersion.LastSaveDate
 set Result.LastSaveTime = objTemplateVersion.LastSaveTime
 set Result.PublicationDate = objTemplateVersion.PublicationDate
 set Result.PublicationTime = objTemplateVersion.PublicationTime
 set Result.CreateDate = objTemplateVersion.CreateDate
 set Result.CreateTime = objTemplateVersion.CreateTime
 set Result.Status = objTemplateVersion.Status
 set Result.Author = objTemplateVersion.Author
 set Result.VersionNumber = objTemplateVersion.VersionNumber

 Quit Result
}

ClassMethod UpdateImage(AStream As %Stream, AID As %String, AVerNum As %String) As %String
{
 Set Result = "1" 
 ; s ^AA("AID") = AID
 /*s AFileName=##class(EPRservice.Utility).GetFileName(AID)  
 Set file=##class(%File).%New(AFileName)
	Do file.Open("WNU")
	d file.WriteLine("<?xml version=""1.0"" encoding=""UTF-8""?>")
	d AStream.Rewind()
	while (AStream.AtEnd = 0)
	{ s readstring=AStream.Read(1000)
	  d file.Write(readstring)
	}
	//d file.CopyFrom(AStream)
	D file.%Close()
	Set file = ##class(%File).%New(AFileName)
 Do file.Open("RS") 
	
	set ASearchStream = ##class(%GlobalCharacterStream).%New()
	set AScissorStream = ##class(%GlobalCharacterStream).%New()
	
	d ASearchStream.CopyFrom(file)
	
 D file.%Close()  */



 // new  anto
 set ASearchStream = ##class(%GlobalCharacterStream).%New()
 d ASearchStream.CopyFrom(AStream)


 //W "Size= "_ASearchStream.Size ,!
 S AAutoParserStream=  ##class(EPRservice.Util.ParserStream).%New()

 s AAutoParserStream.CdataSign=$J

 S DissolveStream =  AAutoParserStream.AutoMationByStr(ASearchStream)


 //W "Size= "_DissolveStream.Size ,!

 s AFileName=##class(EPRservice.Utility).GetFileName(AID)

 Set stream=##class(%FileCharacterStream).%New()
	Set stream.Filename=AFileName
	D stream.TranslateTableSet("UTF8")
	d DissolveStream.Rewind()
	d stream.WriteLine("<?xml version=""1.0"" encoding=""UTF-8""?>")
	while (DissolveStream.AtEnd = 0)
	{ s readstring=DissolveStream.Read(1024)
	  d stream.Write(readstring)
	}
	d stream.SaveStream()
	D stream.%Close()
	
 /* s ^AA("AFileName") = AFileName 
 Set file=##class(%File).%New(AFileName)
	Do file.Open("WNU")
	d file.WriteLine("<?xml version=""1.0"" encoding=""UTF-8""?>")
	d DissolveStream.Rewind()
	while (DissolveStream.AtEnd = 0)
	{ s readstring=DissolveStream.Read(1024)
	  d file.Write(readstring)
	}
	D file.Close()*/
	

 // end new  anto 


 d DissolveStream.Rewind()
 Set sc = ##class(%XML.TextReader).ParseFile(AFileName,.reader) 
	//set sc = ##class(%XML.TextReader).ParseStream(DissolveStream,.reader) 
	Set newNTemplateVersion=##class(EPRmeta.Parser.NTemplateVersion).%New()
	set newNTemplateVersion.TemplateID= AID
	set newNTemplateVersion.TemplateVersion=AVerNum
	set newNTemplateVersion.SessionSign=$J
	;s ^AA("sc")=sc
	if ($$$ISOK(sc)) 
	{ do reader.Read()
	  do newNTemplateVersion.XMLDeserialize(reader) 	   	
	}
	Else{ 
	;s ^AA("sc")=sc
	Quit "0" }
	
	
	;s ^AA($J,"HasAnnotate")=newNTemplateVersion.HasAnnotate
	if (newNTemplateVersion.HasAnnotate="True")
	{ 
	 //s ^AA("HasAnnotate")=newNTemplateVersion.HasAnnotate
	
	//d newNTemplateVersion.FileImageAnnotate(ASearchStream)
	//
	
	d newNTemplateVersion.UpdateMetaData() }
	d ##class(EPRservice.Util.CdataItem).DeleteCdataItems(newNTemplateVersion.SessionSign)
	If (##class(%File).Exists(AFileName))
	{ 
	 s file = ""
	 d ##class(%File).Delete(AFileName)
	 }
		
 Quit Result
}

ClassMethod UpdateTemplate(ATemplate As EPRservice.entity.ETemplate) As %Boolean [ WebMethod ]
{
 New TempTemplateCategoryID
 TSTART
 set objTemplate = ##class(EPRmeta.Template).%OpenId(ATemplate.ID)
 set objTemplate.Name = ATemplate.Name
 set objTemplate.Description = ATemplate.Description
 Set TempTemplateCategoryID = objTemplate.TemplateCategoryID 
 set objTemplate.TemplateCategoryID = ATemplate.TemplateCategoryID
 set objTemplate.GUID = ATemplate.GUID

 set objTemplate.TemplateProperty = ATemplate.TemplateProperty


 set objTemplate.ChartItemType = ATemplate.ChartItemType
 set objTemplate.BindPrintTemplateID = ATemplate.BindPrintTemplateID
 set objTemplate.BindPrintName = ATemplate.BindPrintName

 // update the resChildCount
 if (TempTemplateCategoryID '= ATemplate.TemplateCategoryID)
 {
	 if (TempTemplateCategoryID '="")
	  { Set objOldTemplateCategory = ##class(EPRmeta.TemplateCategory).%OpenId(TempTemplateCategoryID)
 /*If (objOldTemplateCategory ="")
 {TROLLBACK
 Quit 0}   */ 
 set objOldTemplateCategory.ResChildCount = objOldTemplateCategory.ResChildCount - 1
 if '(objOldTemplateCategory.%Save())
 {TROLLBACK
 Quit 0}    
 }
 if (objTemplate.TemplateCategoryID'="")
	 	{
		 Set objNewTemplateCategory = ##class(EPRmeta.TemplateCategory).%OpenId(objTemplate.TemplateCategoryID)
 set objNewTemplateCategory.ResChildCount = objNewTemplateCategory.ResChildCount + 1
 if '(objNewTemplateCategory.%Save())
 {TROLLBACK
 Quit 0}    
 }   
 }
 if '(objTemplate.%Save())
 {
	 TROLLBACK
	 Quit 0
	 }
 TCOMMIT
 Quit 1
}

Query SELECTALLWithGroupByCategoryID(ACategoryID As %String) As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID:%Integer,Name:%String,GUID:%String,TemplateCategoryID:%String,Description:%String,PublishVersion:%Integer,LastVersion:%Integer,ChartItemType:%String,BindPrintTemplateID:%String,BindPrintName:%String,TemplateProperty:%String,GroupId:%String,GroupName:%String", SELECTMODE = "RUNTIME") [ SqlName = SP_Template_SELECTALLWithGroupByCategoryID, SqlProc ]
{
	SELECT t.ID, t.Name, t.GUID,t.TemplateCategoryID, t.Description,t.PublishVersion,t.LastVersion,t.ChartItemType,t.BindPrintTemplateID,t.BindPrintName,t.TemplateProperty,g.TemplateGroup,g.TemplateGroup->GroupName
	 FROM EPRmeta.Template t
	 left join EPRmeta_TemplatePriv.TemplatesInGroup g on (t.ID = g.template) where t.TemplateCategoryID = :ACategoryID
	 ORDER BY t.ID
}

/// Desc: 取打印模板设计时的常用系统参数
ClassMethod GetPrtSysData() As EPRservice.dataset.EPrintTemplateSysDataset [ WebMethod ]
{
	Set ds=##class(EPRservice.dataset.EPrintTemplateSysDataset).%New()
	Quit ds
}

/// 以下为测试代码 *****************************
/// W ##class(EPRservice.BOTemplate).TestUpdateVersion({850)
ClassMethod TestUpdateVersion(templateVersionID As %String) As EPRservice.entity.ETemplateVersion [ WebMethod ]
{
	//b "s"
	
	//取界面模板版本实体对象
	s objITVersion = ..GetVersionByID(templateVersionID,"0")
	
	//附上流数据
	s count = 0
	for {
		s count = $O(^DHCEPRDebug("EPRservice.BOTemplate.UpdateCraftVersion","metadata",count))
		q:(count = "")
		do objITVersion.MetaData.Write(^DHCEPRDebug("EPRservice.BOTemplate.UpdateCraftVersion","metadata",count))
	}
	s count = 0
	for {
		s count = $O(^DHCEPRDebug("EPRservice.BOTemplate.UpdateCraftVersion","initdata",count))
		q:(count="")
		do objITVersion.InitialData.Write(^DHCEPRDebug("EPRservice.BOTemplate.UpdateCraftVersion","initdata",count))
	}
	s count = 0
	for {
		s count = $O(^DHCEPRDebug("EPRservice.BOTemplate.UpdateCraftVersion","presentdata",count))
		q:(count="")
		do objITVersion.PresentationData.Write(^DHCEPRDebug("EPRservice.BOTemplate.UpdateCraftVersion","presentdata",count))
	}
	
	//保存
	s result =  ..UpdateCraftVersion(objITVersion)
	q result
}

}
