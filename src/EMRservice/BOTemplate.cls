Class EMRservice.BOTemplate Extends %SOAP.WebService [ ClassType = "", Not ProcedureBlock ]
{

/// TODO: change this to actual network address.
/// URL for invoking the WebService.
/// TODO: change this to actual SOAP namespace.
/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/emr/metaservice";

/// Name of the WebService.
Parameter SERVICENAME = "TemplateInfo";

ClassMethod CreateCraftVersion(AVersion As EMRservice.entity.ETemplateVersion) As EMRservice.entity.ETemplateVersion [ WebMethod ]
{
		
	Set NewMaxVersion = ##class(EMRservice.BL.BLTemplateVersion).SELECTMAXVERSION(AVersion.TemplateID)
	
	TSTART
	set objTemplateVersion = ##class(EMRmeta.TemplateVersion).%New()
	set Result = ##class(EMRservice.entity.ETemplateVersion).%New()
	Quit:(objTemplateVersion ="") "" 


	set objTemplateVersion.TemplateID = AVersion.TemplateID
	set Result.TemplateID = AVersion.TemplateID

	set objTemplateVersion.Author = AVersion.Author
	set Result.Author = AVersion.Author

	set objTemplateVersion.LastSaveDate = $ZDATEH($ZDATE($HOROLOG))
	set Result.LastSaveDate = objTemplateVersion.LastSaveDate //$ZDATE($HOROLOG)
	
	set objTemplateVersion.LastSaveTime = $ZTIMEH($ZTIME($PIECE($HOROLOG,",",2),1))
	set Result.LastSaveTime = objTemplateVersion.LastSaveTime

	do objTemplateVersion.MetaData.CopyFrom(AVersion.MetaData)
	
	do objTemplateVersion.PresentationData.CopyFrom(AVersion.PresentationData)
	do objTemplateVersion.GridData.CopyFrom(AVersion.GridData) //lingchen Grid模板信息
 	do objTemplateVersion.ScriptData.CopyFrom(AVersion.ScriptData)
 	do objTemplateVersion.MediasData.CopyFrom(AVersion.MediasData)
 	do objTemplateVersion.InitialData.CopyFrom(AVersion.InitialData)
	set objTemplateVersion.Status = 0
	set Result.Status = 0
 
	if NewMaxVersion= ""
	{
		set objTemplateVersion.VersionNumber = 1
	} 
	elseif '(NewMaxVersion="")
	{
		set objTemplateVersion.VersionNumber =NewMaxVersion + 1
	} 	
 	set Result.VersionNumber = objTemplateVersion.VersionNumber

	set objTemplateVersion.TemplateSummary = AVersion.TemplateSummary
	set Result.TemplateSummary = AVersion.TemplateSummary

 	set objTemplateVersion.CreateDate = $ZDATEH($ZDATE($HOROLOG))
 	set Result.CreateDate = objTemplateVersion.CreateDate

 	set objTemplateVersion.CreateTime = $ZTIMEH($ZTIME($PIECE($HOROLOG,",",2),1))
 	set Result.CreateTime = objTemplateVersion.CreateTime  //$ZTIME($PIECE($HOROLOG,",",2),1)
 
	//set objTemplateVersion.PublicationDate = AVersion.PublicationDate
	//set objTemplateVersion.PublicationTime = AVersion.PublicationTime  
	
	set objTemplate = ##class(EMRmeta.Template).%OpenId(AVersion.TemplateID)
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
	{
	 	TROLLBACK 
		Quit ""
	} 
	
	/*Set sc = ##class(%XML.TextReader).ParseStream(AVersion.MetaData,.reader) 
	Set newNTemplateVersion=##class(EMRmeta.Parser.NTemplateVersion).%New()
	set newNTemplateVersion.TemplateID=objTemplateVersion.%Id()
	set newNTemplateVersion.TemplateVersion=objTemplateVersion.VersionNumber
	
	if ($$$ISOK(sc)) 
	{
		do reader.Read()
		do newNTemplateVersion.XMLDeserialize(reader) 	   	
	}
	d newNTemplateVersion.FileImageAnnotate(AVersion.MetaData)
	d newNTemplateVersion.UpdateMetaData()*/	
	
	TCOMMIT

	set Result.ID = objTemplateVersion.%Id()

	//set Result.MetaData = objTemplateVersion.MetaData
	//set Result.PresentationData = objTemplateVersion.PresentationData

 	do Result.MetaData.CopyFrom(objTemplateVersion.MetaData)
 	do Result.PresentationData.CopyFrom(objTemplateVersion.PresentationData)
 	do Result.ScriptData.CopyFrom(objTemplateVersion.ScriptData)
 	do Result.MediasData.CopyFrom(objTemplateVersion.MediasData)
 	do Result.InitialData.CopyFrom(objTemplateVersion.InitialData)
	Quit Result
}

ClassMethod CreateTemplate(ATemplate As EMRservice.entity.ETemplate) As %String [ WebMethod ]
{
	TSTART
	set objTemplate = ##class(EMRmeta.Template).%New()
	if (objTemplate ="")
 	{
		TROLLBACK
		Quit ""
	}
	set objTemplate.TypeCode = ATemplate.TypeCode
 	set objTemplate.Description = ATemplate.Description
 	set objTemplate.TemplateCategoryID = ATemplate.TemplateCategoryID
 	set objTemplate.Name = ATemplate.Name
 	set objTemplate.LastVersion = 0
 	set objTemplate.GUID = ATemplate.GUID
 	set objTemplate.PublishVersion = 0
 	set objTemplate.ChartItemType = ATemplate.ChartItemType
 	set objTemplate.DocumentType = ATemplate.DocumentType
  	set objTemplate.Code = ATemplate.Code
 	set objTemplate.DisplayName = ATemplate.DisplayName	
 	set objTemplate.TemplateProperty = ATemplate.TemplateProperty	
 		
	set objTemplateCategory = ##class(EMRmeta.TemplateCategory).%OpenId(objTemplate.TemplateCategoryID)
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
	if '(objTemplate.%Save())
 	{
		TROLLBACK
		Quit ""
	} 
	TCOMMIT
	Quit objTemplate.%Id()
}

/// w ##class(EMRservice.BOTemplate).DelTemplate(templateid)
ClassMethod DelTemplate(AID As %String) As %Boolean [ WebMethod ]
{

	TSTART
	set objTemplate = ##class(EMRmeta.Template).%OpenId(AID)
	if (objTemplate ="")
	{
		TROLLBACK
		Quit 0
	}
	Set objTemplateCategory = ##class(EMRmeta.TemplateCategory).%OpenId(objTemplate.TemplateCategoryID)
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
	set objTemplateVersion = ##class(EMRmeta.TemplateVersion).%OpenId(AID)
	
	set objTemplate = ##class(EMRmeta.Template).%OpenId(objTemplateVersion.TemplateID)
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
	if '(objTemplateVersion.%DeleteId(AID))
	{
	    TROLLBACK
 	    Quit 0
 	}
	TCOMMIT
	Quit 1
}

ClassMethod GetMetadataByID(AID As %String) As EMRservice.entity.ETemplateVersion [ WebMethod ]
{
 set objTemplateVersion = ##class(EMRmeta.TemplateVersion).%OpenId(AID)
 q:(objTemplateVersion="") ""

 set Result = ##class(EMRservice.entity.ETemplateVersion).%New()
 q:(Result="") ""
 set Result.ID = objTemplateVersion.%Id()
 //set Result.Name = objPrintTemplateVersion.Name

 d Result.MetaData.CopyFrom(objTemplateVersion.MetaData)
 //set Result.PresentationData = objTemplateVersion.PresentationData
 Quit Result
}

ClassMethod GetMetadataByTemplateID(ATemplateID As %String) As EMRservice.entity.ETemplateVersion [ WebMethod ]
{
	/* test
	q:(ATemplateID ="") ""
	s objTemplate = ##class(EMRmeta.Template).%OpenId(ATemplateID)	 
	q:(objTemplate ="") ""
	s AVersionNum = objTemplate.PublishVersion
	q:(AVersionNum ="") ""
	q:(AVersionNum =0) "" 
	*/
	s Rusult = ##class(EMRservice.entity.ETemplateVersion).%New()
	s objTemplate = ##class(EMRmeta.Template).%OpenId(ATemplateID)
	s AVersionNum = objTemplate.PublishVersion

	//test
	//s ATemplateID = 1
	//s AVersionNum = 1
	s Rusult.VersionNumber=AVersionNum	
	
	s Rusult.MetaData = ##class(EMRservice.BL.BLTemplateVersion).GetMetaData(ATemplateID,AVersionNum)
	Quit Rusult
}

ClassMethod GetMetadataByTemIDVerID(ATemplateID As %String, AVersionNum As %String) As EMRservice.entity.ETemplateVersion [ WebMethod ]
{
	s Rusult = ##class(EMRservice.entity.ETemplateVersion).%New()

	s Rusult.VersionNumber=AVersionNum	
	
	s Rusult.MetaData = ##class(EMRservice.BL.BLTemplateVersion).GetMetaData(ATemplateID,AVersionNum)
	Quit Rusult
}

ClassMethod GetMetadataByTemplateIDByBinary(ATemplateID As %String) As EMRservice.entity.ETemplateVersion [ WebMethod ]
{

	s Rusult = ##class(EMRservice.entity.ETemplateVersion).%New()
	s objTemplate = ##class(EMRmeta.Template).%OpenId(ATemplateID)
	s AVersionNum = objTemplate.PublishVersion

	//test
	s Rusult.VersionNumber=AVersionNum	
	s objstreamF=##Class(%GlobalBinaryStream).%New()
	//d objstreamF.TranslateTableSet("UTF8")
	s objstreamF =##class(EMRservice.BL.BLTemplateVersion).GetMetaData(ATemplateID,AVersionNum)
	//d objstreamF.SaveStream()
	d Rusult.MetaData.CopyFrom(objstreamF)
	d Rusult.MetaData.OutputToDevice()
	Quit Rusult
}

ClassMethod GetPresentationDataByID(AID As %String) As EMRservice.entity.ETemplateVersion [ WebMethod ]
{
 set objTemplateVersion = ##class(EMRmeta.TemplateVersion).%OpenId(AID)
 q:(objTemplateVersion="") ""

 set Result = ##class(EMRservice.entity.ETemplateVersion).%New()
 q:(Result="") ""
 set Result.ID = objTemplateVersion.%Id()
 //set Result.Name = objPrintTemplateVersion.Name

 //d Result.MetaData.CopyFrom(objTemplateVersion.MetaData)
 d Result.PresentationData.CopyFrom(objTemplateVersion.PresentationData)
 Quit Result
}

/// 取得所有template
ClassMethod GetTemplateAll(ACategoryID As %String) As EMRservice.dataset.ETemplateDataset [ WebMethod ]
{
 Set result=##class(EMRservice.dataset.ETemplateDataset).%New()
 Do result.SetArgs(ACategoryID)
 Quit result
}

/// 取得所有template
ClassMethod GetAllTemplateData() As %XML.DataSet [ WebMethod ]
{
	s result=##class(%XML.DataSet).%New("EMRservice.BL.BLTemplate:SELECTALLTemplate")
	d result.SetArgs()
	q result
}

/// 取得所有template用于选择模板
ClassMethod GetTemplateAllForSlt(ACategoryID As %String, AEpisodeID As %String) As EMRservice.dataset.ETempForSltDataset [ WebMethod ]
{
 Set result=##class(EMRservice.dataset.ETempForSltDataset).%New()
 Do result.SetArgs(ACategoryID,AEpisodeID)
 Quit result
}

/// 取得所有带有模板组信息的template 
ClassMethod GetTemplateWithGroupAll(ACategoryID As %String) As %XML.DataSet [ WebMethod ]
{
 Set result=##class(EMRservice.dataset.ETemplateWithGroupDataset).%New()
 Do result.SetArgs(ACategoryID)
 Quit result
}

ClassMethod GetTemplateByGUID(AGUID As %String) As EMRservice.entity.ETemplate [ WebMethod ]
{
 Set AID = ##Class(EMRmeta.Template).SELECTBYGUID(AGUID)	
 Quit:AID="" ""
 set objTemplate = ##class(EMRmeta.Template).%OpenId(AID)
 Q:(objTemplate="") ""

 set Result = ##class(EMRservice.entity.ETemplate).%New()
 Q:(Result="") ""

 set Result.ID = objTemplate.%Id()
 set Result.Name = objTemplate.Name
 set Result.TemplateCategoryID = objTemplate.TemplateCategoryID
 set Result.Description = objTemplate.Description
 set Result.PublishVersion = objTemplate.PublishVersion
 set Result.GUID = objTemplate.GUID
 set Result.LastVersion = objTemplate.LastVersion
 set Result.DocumentType = objTemplate.DocumentType
 set Result.ChartItemType = objTemplate.ChartItemType
 set Result.Code = objTemplate.Code 
 set Result.DisplayName = objTemplate.DisplayName
 set Result.TemplateProperty = objTemplate.TemplateProperty

 Quit Result
}

ClassMethod GetTemplateByID(AID As %String) As EMRservice.entity.ETemplate [ WebMethod ]
{
	set objTemplate = ##class(EMRmeta.Template).%OpenId(AID)
	Q:(objTemplate="") ""

	set Result = ##class(EMRservice.entity.ETemplate).%New()
	Q:(Result="") ""

	set Result.ID = objTemplate.%Id()
	set Result.TypeCode = objTemplate.TypeCode
	set Result.Name = objTemplate.Name
	set Result.TemplateCategoryID = objTemplate.TemplateCategoryID
	set Result.Description = objTemplate.Description
	set Result.PublishVersion = objTemplate.PublishVersion
	set Result.GUID = objTemplate.GUID
	set Result.LastVersion = objTemplate.LastVersion
	set Result.Code = objTemplate.Code
	set Result.ChartItemType = objTemplate.ChartItemType
	set Result.DisplayName = objTemplate.DisplayName
	set Result.DocumentType = objTemplate.DocumentType
	set Result.TemplateProperty = objTemplate.TemplateProperty

	Quit Result
}

// 获取所有模板ID以^分隔

// w ##Class(EMRservice.BOTemplate).SelectAllTID()

ClassMethod SelectAllTID() As %String [ WebMethod ]
{
	s RowIDs = ""
	s strRowID = ""
	for {
		s strRowID = $o(^DHCEMRM.TemplateD(strRowID))
		q:(strRowID = "")
		s RowIDs = RowIDs_"^"_strRowID
	}
	s RowIDs = RowIDs_"^"
	q RowIDs
}

ClassMethod GetTemplateVersionAll(ATemplateId As %String) As EMRservice.dataset.ETemplateVersionDataset [ WebMethod ]
{
 Set result=##class(EMRservice.dataset.ETemplateVersionDataset).%New()
 Do result.SetArgs(ATemplateId)
 Quit result
}

/// 取得所有template
ClassMethod GetAllTemplateVersion() As %XML.DataSet [ WebMethod ]
{
	s result=##class(%XML.DataSet).%New("EMRservice.BL.BLTemplateVersion:SELECTALLVersion")
	d result.SetArgs()
	q result
}

/// w ##Class(EMRservice.BOTemplate).GetVersionByID(13, 1)
ClassMethod GetVersionByID(AID As %String, ADataFlag As %Boolean) As EMRservice.entity.ETemplateVersion [ WebMethod ]
{
	set objTemplateVersion = ##class(EMRmeta.TemplateVersion).%OpenId(AID)
	q:(objTemplateVersion="") ""
	set Result = ##class(EMRservice.entity.ETemplateVersion).%New()
	q:(Result="") ""
	set Result.ID = objTemplateVersion.%Id()
	//set Result.Name = objPrintTemplateVersion.Name
	set Result.TemplateID = objTemplateVersion.TemplateID
	set Result.LastSaveDate = objTemplateVersion.LastSaveDate
	set Result.LastSaveTime = $ZTIME(objTemplateVersion.LastSaveTime)
	if ADataFlag
	{
		//s Result.MetaData = ##Class(%GlobalBinaryStream).%New()
		d Result.MetaData.CopyFrom(objTemplateVersion.MetaData)
		d Result.PresentationData.CopyFrom(objTemplateVersion.PresentationData)
		d Result.GridData.CopyFrom(objTemplateVersion.GridData)
		d Result.ScriptData.CopyFrom(objTemplateVersion.ScriptData)
		d Result.MediasData.CopyFrom(objTemplateVersion.MediasData)
		d Result.InitialData.CopyFrom(objTemplateVersion.InitialData)		
	}
	set Result.PublicationDate = objTemplateVersion.PublicationDate
	set Result.PublicationTime = $ZTIME(objTemplateVersion.PublicationTime)
	set Result.CreateDate = objTemplateVersion.CreateDate
	set Result.CreateTime = $ZTIME(objTemplateVersion.CreateTime)
	set Result.Status = objTemplateVersion.Status
	set Result.Author = objTemplateVersion.Author
	set Result.TemplateSummary = objTemplateVersion.TemplateSummary
	set Result.VersionNumber = objTemplateVersion.VersionNumber
	Quit Result
}

ClassMethod GetVersionByTemplateID(ATemplateID As %String) As EMRservice.entity.ETemplateVersion [ WebMethod ]
{
 set AID= ##class(EMRservice.BL.BLTemplateVersion).GetMaxPubVrnID(ATemplateID) 

 s ^AAA($J,"AID") = AID	_"@@"_ATemplateID
 Q:(AID="") ""  

	
 set objTemplateVersion = ##class(EMRmeta.TemplateVersion).%OpenId(AID)
 Q:(objTemplateVersion="") ""

 set Result = ##class(EMRservice.entity.ETemplateVersion).%New()
 q:(Result="") ""
 set Result.ID = objTemplateVersion.%Id()
 //set Result.Name = objPrintTemplateVersion.Name

 set Result.MetaData = objTemplateVersion.MetaData
 set Result.PresentationData = objTemplateVersion.PresentationData
 set Result.MediasData = objTemplateVersion.MediasData
 Quit Result
}

/// 获取模板最新版本信息
/// creator: yejian
/// input: templateid:模板ID
/// debug w ##class(EMRservice.BOTemplate).GetMaxVersionByTemplateID("1")
ClassMethod GetMaxVersionByTemplateID(ATemplateID As %String) As EMRservice.entity.ETemplateVersion [ WebMethod ]
{
 q ##class(EMRservice.BL.BLTemplateVersion).GetMaxVrnID(ATemplateID)
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
		  Set AID = $O(^DHCEMRM.TemplateI("TplGuidIdx",ABlankGuidItem,""))	 
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
		S objTempleta = ##class(EMRmeta.Template).%OpenId(AIDItem)
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

ClassMethod PublishVersion(AVersion As EMRservice.entity.ETemplateVersion) As EMRservice.entity.ETemplateVersion [ WebMethod ]
{
	TSTART
	 set objTemplateVersion = ##class(EMRmeta.TemplateVersion).%OpenId(AVersion.ID)
	 set objTemplateVersion.Status = 2
	 set objTemplateVersion.PublicationDate =$ZDATEH($ZDATE($HOROLOG))
	 set objTemplateVersion.PublicationTime = $ZTIMEH($ZTIME($PIECE($HOROLOG,",",2),1))
	 set objTemplateVersion.LastSaveDate = $ZDATEH($ZDATE($HOROLOG))
	 set objTemplateVersion.LastSaveTime = $ZTIMEH($ZTIME($PIECE($HOROLOG,",",2),1))
	 set objTemplate = ##class(EMRmeta.Template).%OpenId(AVersion.TemplateID)
	 Set objTemplate.PublishVersion = objTemplateVersion.VersionNumber

	 do objTemplateVersion.MetaData.CopyFrom(AVersion.MetaData)
	 
	 do objTemplateVersion.PresentationData.CopyFrom(AVersion.PresentationData)
	 do objTemplateVersion.MediasData.CopyFrom(AVersion.MediasData)
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
	 
	 ;d ##class(EMRservice.BOTemplate).UpdateImage(objTemplateVersion.MetaData,AVersion.TemplateID,objTemplateVersion.VersionNumber)
	 //if ( ##class(EMRservice.BOTemplate).UpdateImage(objTemplateVersion.MetaData,objTemplateVersion.TemplateID,objTemplateVersion.VersionNumber)="0" )
	 //{  TROLLBACK
	 // Quit 0
	 //}
	
	   
	TCOMMIT
	 set Result = ##class(EMRservice.entity.ETemplateVersion).%New()
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

ClassMethod UpdateCraftVersion(AVersion As EMRservice.entity.ETemplateVersion) As EMRservice.entity.ETemplateVersion [ WebMethod ]
{
	//debug begin
	/*
	k ^DHCEPRDebug("EMRservice.BOTemplate.UpdateCraftVersion")
	
	s len=1024*15
	
	s count = 0
	d AVersion.MetaData.Rewind()
	while (AVersion.MetaData.AtEnd = 0)
	{
		s count = count + 1
		s ^DHCEPRDebug("EMRservice.BOTemplate.UpdateCraftVersion","metadata",count)=AVersion.MetaData.Read(len)
	}
	d AVersion.MetaData.Rewind()
	
	s count = 0
	d AVersion.PresentationData.Rewind()
	while (AVersion.PresentationData.AtEnd = 0)
	{
		s count = count + 1
		s ^DHCEPRDebug("EMRservice.BOTemplate.UpdateCraftVersion","presentdata",count)=AVersion.PresentationData.Read(len)
	}
	d AVersion.PresentationData.Rewind()
	
	s ^DHCEPRDebug("EMRservice.BOTemplate.UpdateCraftVersion","id")=AVersion.ID
	*/
	//debug end

 TSTART 
 set objTemplateVersion = ##class(EMRmeta.TemplateVersion).%OpenId(AVersion.ID) 

 set objTemplateVersion.TemplateID = AVersion.TemplateID

 set objTemplateVersion.Author = AVersion.Author  //AVersion.Author

 set objTemplateVersion.LastSaveDate =  $ZDATEH($ZDATE($HOROLOG))

 set objTemplateVersion.LastSaveTime = $ZTIMEH($ZTIME($PIECE($HOROLOG,",",2),1))
 
 set objTemplateVersion.TemplateSummary = AVersion.TemplateSummary

 do objTemplateVersion.MetaData.CopyFrom(AVersion.MetaData)

 do objTemplateVersion.PresentationData.CopyFrom(AVersion.PresentationData)
 
 do objTemplateVersion.GridData.CopyFrom(AVersion.GridData)

 do objTemplateVersion.ScriptData.CopyFrom(AVersion.ScriptData)
 
 do objTemplateVersion.MediasData.CopyFrom(AVersion.MediasData)
 
 set objTemplateVersion.Status = 1
 
 if '(objTemplateVersion.%Save())
 {
 TROLLBACK
 Quit 0
 }
 
 //*B "S"
 //d ##class(EMRservice.BOTemplate).UpdateImage(objTemplateVersion.MetaData,AVersion.TemplateID,objTemplateVersion.VersionNumber)
 /*s UpdataImageValue=##class(EMRservice.BOTemplate).UpdateImage(objTemplateVersion.MetaData,objTemplateVersion.TemplateID,objTemplateVersion.VersionNumber)
 if ( UpdataImageValue="0" )
 {  TROLLBACK
 Quit 0
 } */

 TCOMMIT
 
 set Result = ##class(EMRservice.entity.ETemplateVersion).%New()
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
 set Result.TemplateSummary = objTemplateVersion.TemplateSummary
 
 do Result.MetaData.CopyFrom(objTemplateVersion.MetaData)
 do Result.PresentationData.CopyFrom(objTemplateVersion.PresentationData)
 do Result.ScriptData.CopyFrom(objTemplateVersion.ScriptData)
 do Result.MediasData.CopyFrom(objTemplateVersion.MediasData)
 
 Quit Result
}

ClassMethod UpdateImage(AStream As %Stream, AID As %String, AVerNum As %String) As %String
{
 Set Result = "1" 
 ; s ^AA("AID") = AID
 /*s AFileName=##class(EMRservice.Utility).GetFileName(AID)  
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
 S AAutoParserStream=  ##class(EMRservice.Util.ParserStream).%New()

 s AAutoParserStream.CdataSign=$J

 S DissolveStream =  AAutoParserStream.AutoMationByStr(ASearchStream)


 //W "Size= "_DissolveStream.Size ,!

 s AFileName=##class(EMRservice.Utility).GetFileName(AID)

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
	Set newNTemplateVersion=##class(EMRmeta.Parser.NTemplateVersion).%New()
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
	d ##class(EMRservice.Util.CdataItem).DeleteCdataItems(newNTemplateVersion.SessionSign)
	If (##class(%File).Exists(AFileName))
	{ 
	 s file = ""
	 d ##class(%File).Delete(AFileName)
	 }
		
 Quit Result
}

ClassMethod UpdateTemplate(ATemplate As EMRservice.entity.ETemplate) As %Boolean [ WebMethod ]
{
 New TempTemplateCategoryID
 TSTART
 set objTemplate = ##class(EMRmeta.Template).%OpenId(ATemplate.ID)
 set objTemplate.Name = ATemplate.Name
 set objTemplate.TypeCode = ATemplate.TypeCode
 set objTemplate.Description = ATemplate.Description
 Set TempTemplateCategoryID = objTemplate.TemplateCategoryID 
 set objTemplate.TemplateCategoryID = ATemplate.TemplateCategoryID
 set objTemplate.GUID = ATemplate.GUID
 set objTemplate.Code = ATemplate.Code


 set objTemplate.ChartItemType = ATemplate.ChartItemType
 set objTemplate.DisplayName = ATemplate.DisplayName
 set objTemplate.DocumentType = ATemplate.DocumentType
 set objTemplate.TemplateProperty = ATemplate.TemplateProperty

 // update the resChildCount
 if (TempTemplateCategoryID '= ATemplate.TemplateCategoryID)
 {
	 if (TempTemplateCategoryID '="")
	  { Set objOldTemplateCategory = ##class(EMRmeta.TemplateCategory).%OpenId(TempTemplateCategoryID)
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
		 Set objNewTemplateCategory = ##class(EMRmeta.TemplateCategory).%OpenId(objTemplate.TemplateCategoryID)
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

ClassMethod IsTemplateVersionSaved(versionID As %String, docType As %String) As %Boolean [ WebMethod ]
{
	set objTemplateVersion = ##class(EMRmeta.TemplateVersion).%OpenId(versionID)
	if (objTemplateVersion="") { q 0 }
	if (docType="DOC")
	{
		q:(objTemplateVersion.MetaData="") 0
		q 1
	}
	else
	{
		q:(objTemplateVersion.GridData="") 0
		q 1
	}
}

ClassMethod UpdateTemVSummary(AVersionID As %String, ASummary As %String) As %String [ WebMethod ]
{
	q:(AVersionID="") "-1"
	q ##Class(EMRservice.BL.BLTemplateVersion).UpdateTemVSummary(AVersionID,ASummary)
}

ClassMethod TestVersion(AVersion As EMRservice.entity.ETemplateVersion) [ WebMethod ]
{
	set objTemplateVersion = ##class(EMRmeta.TemplateVersion).%OpenId(1)
	do objTemplateVersion.MetaData.CopyFrom(AVersion.MetaData)
	d objTemplateVersion.%Save()
}

/*
Query SELECTALLWithGroupByCategoryID(ACategoryID As %String) As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID:%Integer,Name:%String,GUID:%String,TemplateCategoryID:%String,Description:%String,PublishVersion:%Integer,LastVersion:%Integer,ChartItemType:%String,DisplayName:%String,DocumentType:%String,Code:%String,GroupId:%String,GroupName:%String", SELECTMODE = "RUNTIME") [ SqlName = SP_Template_SELECTALLWithGroupByCategoryID, SqlProc ]
{
	SELECT t.ID, t.Name, t.GUID,t.TemplateCategoryID, t.Description,t.PublishVersion,t.LastVersion,t.ChartItemType,t.DisplayName,t.DocumentType,t.Code,g.TemplateGroup,g.TemplateGroup->GroupName
	 FROM EMRmeta.Template t
	 left join EMRmeta_TemplatePriv.TemplatesInGroup g on (t.ID = g.template) where t.TemplateCategoryID = :ACategoryID
	 ORDER BY t.ID
}


/// Desc: 取打印模板设计时的常用系统参数
ClassMethod GetPrtSysData() As EMRservice.dataset.EPrintTemplateSysDataset [ WebMethod ]
{
	Set ds=##class(EMRservice.dataset.EPrintTemplateSysDataset).%New()
	Quit ds
}
*/
/// 以下为测试代码 *****************************
/// W ##class(EMRservice.BOTemplate).TestUpdateVersion(63)
ClassMethod TestUpdateVersion(templateVersionID As %String) As EMRservice.entity.ETemplateVersion [ WebMethod ]
{
	//b "s"
	
	//取界面模板版本实体对象
	s objITVersion = ..GetVersionByID(templateVersionID,"0")
	
	//附上流数据
	s count = 0
	for {
		s count = $O(^DHCEPRDebug("EMRservice.BOTemplate.UpdateCraftVersion","metadata",count))
		q:(count = "")
		do objITVersion.MetaData.Write(^DHCEPRDebug("EMRservice.BOTemplate.UpdateCraftVersion","metadata",count))
	}
	s count = 0
	s count = 0
	for {
		s count = $O(^DHCEPRDebug("EMRservice.BOTemplate.UpdateCraftVersion","presentdata",count))
		q:(count="")
		do objITVersion.PresentationData.Write(^DHCEPRDebug("EMRservice.BOTemplate.UpdateCraftVersion","presentdata",count))
	}
	
	//保存
	s result =  ..UpdateCraftVersion(objITVersion)
	q result
}

ClassMethod GetPatientIDByEpisodeID(aEpisodeID As %String) As %String [ WebMethod ]
{
	s patientID = "-1"
	q:(aEpisodeID="") patientID
	s patientID = ##Class(EMRservice.HISInterface.PatientInfoAssist).GetPapmiDR(aEpisodeID)
	q patientID
}

/// w ##Class(EMRservice.Tools.DailyWorkTool).GetDocument("4||6")
ClassMethod GetDocument(AInstanceID As %String) As %FileBinaryStream [ WebMethod ]
{


	s argOutData = ##class(%FileBinaryStream).%New() 

	s objInstance = ##Class(EMRinstance.InstanceData).%OpenId(AInstanceID) 
	d argOutData.CopyFrom(##Class(EMRservice.BL.BLTemplate).GetRecordXML(objInstance.RealTemplateID,"Document",objInstance.Title,objInstance.TitleCode,objInstance.InstanceMetaData,objInstance.InstanceScriptData,objInstance.InstanceData,objInstance.InstanceMedia))
	
	s AStream=##Class(%FileBinaryStream).%New()

	d AStream.CopyFrom(argOutData)

	q AStream
}

/// d ##Class(EMRservice.BOTemplate).test() 
ClassMethod test()
{
	s AVersion = ##class(EMRservice.entity.ETemplateVersion).%New()
	s AVersion.TemplateID = 63
	s AVersion.Author = "北京"
	
	s obj = ..CreateCraftVersion(AVersion)
	q 
	
	s ^CacheTemp("CreateCraftVersion")="CreateCraftVersion"
	s $zt = "ErrorHandler"
		
	Set NewMaxVersion = ##class(EMRservice.BL.BLTemplateVersion).SELECTMAXVERSION(AVersion.TemplateID)
	
	TSTART
	set objTemplateVersion = ##class(EMRmeta.TemplateVersion).%New()
	set Result = ##class(EMRservice.entity.ETemplateVersion).%New()
	Quit:(objTemplateVersion ="") "" 


	set objTemplateVersion.TemplateID = AVersion.TemplateID
	set Result.TemplateID = AVersion.TemplateID

	set objTemplateVersion.Author = AVersion.Author
	set Result.Author = AVersion.Author

	set objTemplateVersion.LastSaveDate = $ZDATEH($ZDATE($HOROLOG))
	set Result.LastSaveDate = objTemplateVersion.LastSaveDate //$ZDATE($HOROLOG)
	
	set objTemplateVersion.LastSaveTime = $ZTIMEH($ZTIME($PIECE($HOROLOG,",",2),1))
	set Result.LastSaveTime = objTemplateVersion.LastSaveTime

	do objTemplateVersion.MetaData.CopyFrom(AVersion.MetaData)
	
	do objTemplateVersion.PresentationData.CopyFrom(AVersion.PresentationData)
	do objTemplateVersion.GridData.CopyFrom(AVersion.GridData) //lingchen Grid模板信息
 
	set objTemplateVersion.Status = 0
	set Result.Status = 0
	b
	if NewMaxVersion= ""
	{
		set objTemplateVersion.VersionNumber = 1
	} 
	elseif '(NewMaxVersion="")
	{
		set objTemplateVersion.VersionNumber =NewMaxVersion + 1} 	
 		set Result.VersionNumber = objTemplateVersion.VersionNumber

 		set objTemplateVersion.CreateDate = $ZDATEH($ZDATE($HOROLOG))
 		set Result.CreateDate = objTemplateVersion.CreateDate

 		set objTemplateVersion.CreateTime = $ZTIMEH($ZTIME($PIECE($HOROLOG,",",2),1))
 		set Result.CreateTime = objTemplateVersion.CreateTime  //$ZTIME($PIECE($HOROLOG,",",2),1)
 
		//set objTemplateVersion.PublicationDate = AVersion.PublicationDate
		//set objTemplateVersion.PublicationTime = AVersion.PublicationTime  
	
		set objTemplate = ##class(EMRmeta.Template).%OpenId(AVersion.TemplateID)
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
	 	{
		 	TROLLBACK 
			Quit ""
		} 
	
		/*Set sc = ##class(%XML.TextReader).ParseStream(AVersion.MetaData,.reader) 
		Set newNTemplateVersion=##class(EMRmeta.Parser.NTemplateVersion).%New()
		set newNTemplateVersion.TemplateID=objTemplateVersion.%Id()
		set newNTemplateVersion.TemplateVersion=objTemplateVersion.VersionNumber
	
		if ($$$ISOK(sc)) 
		{
			do reader.Read()
			do newNTemplateVersion.XMLDeserialize(reader) 	   	
		}
		d newNTemplateVersion.FileImageAnnotate(AVersion.MetaData)
		d newNTemplateVersion.UpdateMetaData()*/	
	
		TCOMMIT

		set Result.ID = objTemplateVersion.%Id()
		//set Result.MetaData = objTemplateVersion.MetaData
		//set Result.PresentationData = objTemplateVersion.PresentationData

 		do Result.MetaData.CopyFrom(objTemplateVersion.MetaData)
 		do Result.PresentationData.CopyFrom(objTemplateVersion.PresentationData)

		Quit Result
ErrorHandler
   w "$zerror"_$zerror,!
}

}
