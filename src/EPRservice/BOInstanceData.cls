/// EPRservice.BOInstanceData
Class EPRservice.BOInstanceData Extends %SOAP.WebService [ ProcedureBlock ]
{

/// TODO: change this to actual network address.
/// URL for invoking the WebService.
/// Parameter LOCATION = "http://localhost/trakcarelive/trak/web";
/// TODO: change this to actual SOAP namespace.
/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/metaservice";

/// Name of the WebService. 
Parameter SERVICENAME = "InstanceDataInfo";

/// w ##Class(EPRservice.BOInstanceData).GetKBDiagnosIDByEpisodeID(201871)
ClassMethod GetKBDiagnosIDByEpisodeID(AEpisodeID As %String) As %String [ WebMethod ]
{
	s diagnosID = ""
	s admPatTypeRowID = $o(^DHCEPRI.AdmPatTypeI("EpisodeIDIdx"," "_AEpisodeID,""))
	if (admPatTypeRowID '= "")
	{
		s diagnosID = $list($g(^DHCEPRI.AdmPatTypeD(admPatTypeRowID)),5)
	}	
	q diagnosID
}

ClassMethod GetData(APatientID As %String, AEpisodeID As %String, AChartItemID As %String, AChartItemType As %String, AChartListNo As %String, ATemplateID As %String) As EPRservice.entity.EInstanceData [ WebMethod ]
{
 //s ^AA("GetData")="APatientID="_APatientID_" AEpisodeID="_AEpisodeID_" AChartItemID ="_AChartItemID_" AChartItemType="_AChartItemType_" AChartListNo=" _AChartListNo_" ATemplateID =" _ATemplateID
 S CheckDataExist = ##class(EPRinstance.ECRecord).CheckInstanceExist(APatientID,AEpisodeID,AChartItemID)
 s Result = ##class(EPRservice.entity.EInstanceData).%New()
 s Result.PatientID = APatientID	  
 s Result.EpisodeID = AEpisodeID	  
 s Result.ChartItemID = AChartItemID	  
 s Result.ListNo = AChartListNo	
 s Result.TemplateID = ATemplateID
 set Result.HappenDate = $ZDATE($HOROLOG,3)
 set Result.HappenTime = $ZTIME($PIECE($HOROLOG,",",2),1)

 /*
Property TemplateVersion As %Integer;
*/
 if (CheckDataExist=0)
 {
 s Result.TemplateVersion = ##class(EPRmeta.Template).GetVersionBYID(ATemplateID)
 s Result.Title =  ##class(EPRmeta.Template).GetTitleBYID(ATemplateID) //objInstanceData.Title 
 //modified on 2010-07-17 by houj
 //s Result.MetaData  =  ##class(EPRmeta.TemplateVersion).GetMetaData(ATemplateID,Result.TemplateVersion)
 //s Result.PresentationData  =  ##class(EPRmeta.TemplateVersion).GetPresentationData(ATemplateID,Result.TemplateVersion)
 //s Result.InstanceData  =  ##class(EPRmeta.TemplateVersion).GetInitialData(ATemplateID,Result.TemplateVersion)
 d Result.MetaData.CopyFrom(##class(EPRmeta.TemplateVersion).GetMetaData(ATemplateID,Result.TemplateVersion))
 d Result.PresentationData.CopyFrom(##class(EPRmeta.TemplateVersion).GetPresentationData(ATemplateID,Result.TemplateVersion))
 d Result.InstanceData.CopyFrom(##class(EPRmeta.TemplateVersion).GetInitialData(ATemplateID,Result.TemplateVersion))
 
 s Result.Status = "UnSave"	  
 }
 Elseif (CheckDataExist '=0)
 {
	 if (AChartListNo="-1")
	 {
		 s Result.TemplateVersion = ##class(EPRmeta.Template).GetVersionBYID(ATemplateID)
		 //s Result.Title = objInstanceData.Title
		 s Result.Title =  ##class(EPRmeta.Template).GetTitleBYID(ATemplateID) //objInstanceData.Title 
		 //modified on 2010-07-17 by houj
		 //s Result.MetaData  =  ##class(EPRmeta.TemplateVersion).GetMetaData(ATemplateID,Result.TemplateVersion)
		 //s Result.PresentationData  =  ##class(EPRmeta.TemplateVersion).GetPresentationData(ATemplateID,Result.TemplateVersion)
		 //s Result.InstanceData  =  ##class(EPRmeta.TemplateVersion).GetInitialData(ATemplateID,Result.TemplateVersion)
		 d Result.MetaData.CopyFrom(##class(EPRmeta.TemplateVersion).GetMetaData(ATemplateID,Result.TemplateVersion))
		 d Result.PresentationData.CopyFrom(##class(EPRmeta.TemplateVersion).GetPresentationData(ATemplateID,Result.TemplateVersion))
		 d Result.InstanceData.CopyFrom(##class(EPRmeta.TemplateVersion).GetInitialData(ATemplateID,Result.TemplateVersion))
		 
		 s Result.Status = "UnSave"	  
	 }
	 Elseif (AChartListNo'="-1")
	 {
	   S AECRecord = ##class(EPRinstance.ECRecord).GetECRecordID(APatientID,AEpisodeID,AChartItemID)  
	   if AECRecord =""
	   { 
	    Quit ""
	  	}
	   	s OBJECRecord = ##class(EPRinstance.ECRecord).%OpenId(AECRecord)  
	   
	   	s Result.CategoryID = OBJECRecord.CategoryID 
 			s Result.CategoryType = OBJECRecord.CategoryType 

	   	Set key = ""
 			do
 			{ 
	     S objInstanceData = OBJECRecord.Instances.GetNext(.key)
	
	     if (objInstanceData '= "")
	     { if (objInstanceData.ListNo = AChartListNo)
	       {
		     	s Result.TemplateVersion = objInstanceData.TemplateVersion
		     	
		     	//modified on 2010-07-17 by houj
		     	//s Result.MetaData  =  ##class(EPRmeta.TemplateVersion).GetMetaData(ATemplateID,Result.TemplateVersion)
 				//s Result.PresentationData  =  ##class(EPRmeta.TemplateVersion).GetPresentationData(ATemplateID,Result.TemplateVersion)
		      	//s Result.InstanceData = objInstanceData.InstanceData
		    	d Result.MetaData.CopyFrom(##class(EPRmeta.TemplateVersion).GetMetaData(ATemplateID,Result.TemplateVersion))
 				d Result.PresentationData.CopyFrom(##class(EPRmeta.TemplateVersion).GetPresentationData(ATemplateID,Result.TemplateVersion))
		      	d Result.InstanceData.CopyFrom(objInstanceData.InstanceData)
		    
		      	s Result.Title = objInstanceData.Title 
 				s Result.Status = objInstanceData.Status //"Save"  ;gjb 2008-03-26
		      	set Result.ID = objInstanceData.%Id()
		      	q
		    }
		  	} 
 			} while (key '="" )
 		} 
 }
 Quit Result
}

ClassMethod GetDataByID(AID As %String) As EPRservice.entity.EInstanceData [ WebMethod ]
{
	
 set objInstanceData = ##class(EPRinstance.InstanceData).%OpenId(AID) 

 if (objInstanceData= "")
 {
	Quit "" 
 }
 s Result =##class(EPRservice.entity.EInstanceData).%New()


 if (Result="")
 {
	Quit ""
 }

 s Result.TemplateVersion = objInstanceData.TemplateVersion

 //modified on 2010-07-17 by houj
 //s Result.MetaData  =  ##class(EPRmeta.TemplateVersion).GetMetaData(objInstanceData.TemplateID,objInstanceData.TemplateVersion)
 //s Result.PresentationData  =  ##class(EPRmeta.TemplateVersion).GetPresentationData(objInstanceData.TemplateID,objInstanceData.TemplateVersion)
 d Result.MetaData.CopyFrom(##class(EPRmeta.TemplateVersion).GetMetaData(objInstanceData.TemplateID,objInstanceData.TemplateVersion))
 d Result.PresentationData.CopyFrom(##class(EPRmeta.TemplateVersion).GetPresentationData(objInstanceData.TemplateID,objInstanceData.TemplateVersion))


 s Result.Title = objInstanceData.Title 
 
 // added on 2010-11-05 by Zuoxiang
 s Result.Remark = objInstanceData.Remark
 
 s Result.ID = AID
 s Result.Status = objInstanceData.Status

 s Result.HappenDate = objInstanceData.HappenDate 
 s Result.HappenTime = objInstanceData.HappenTime
 ;s Result.HappenDate = $ZDATE(objInstanceData.HappenDate,3)
 ;s Result.HappenTime = $ZTIME(objInstanceData.HappenTime,1)
 s Result.ListNo = objInstanceData.ListNo 


 s Result.CreateDate = objInstanceData.CreateDate 
 s Result.CreateTime = objInstanceData.CreateTime 
 s Result.CreateUser = objInstanceData.CreateUser 


 s Result.TemplateID = objInstanceData.TemplateID 
 s Result.TemplateVersion = objInstanceData.TemplateVersion 

 s Result.ModifyTime = objInstanceData.ModifyTime 
 s Result.ModifyUser = objInstanceData.ModifyUser 


 s Result.ChartItemID = objInstanceData.TheECRecord.ChartItemID
 s Result.EpisodeID = objInstanceData.TheECRecord.EpisodeID 
 s Result.PatientID = objInstanceData.TheECRecord.PatientID 
 s Result.TheECRecord = objInstanceData.TheECRecord.%Id()
 s Result.ChartItemType = objInstanceData.TheECRecord.ChartItemType
 s Result.CategoryID = objInstanceData.TheECRecord.CategoryID 
 s Result.CategoryType = objInstanceData.TheECRecord.CategoryType 
 //s Result.CategoryType = objInstanceData.TheECRecord.CategoryType 
 D Result.InstanceData.CopyFrom(objInstanceData.InstanceData)



 Quit Result
}

//get instance data without XML for privilege use

ClassMethod GetDescDataByID(AID As %String) As EPRservice.entity.EInstanceData [ WebMethod ]
{
 set objInstanceData = ##class(EPRinstance.InstanceData).%OpenId(AID) 
 Quit:(objInstanceData= "") ""
 
 s Result =##class(EPRservice.entity.EInstanceData).%New()
 Quit:(Result="") ""

 s Result.TemplateVersion = objInstanceData.TemplateVersion

 s Result.MetaData  =  "" ;##class(EPRmeta.TemplateVersion).GetMetaData(objInstanceData.TemplateID,objInstanceData.TemplateVersion)
 s Result.PresentationData  = "" ;##class(EPRmeta.TemplateVersion).GetPresentationData(objInstanceData.TemplateID,objInstanceData.TemplateVersion)
		    
 s Result.Title = objInstanceData.Title 
 s Result.ID = AID
 s Result.Status = objInstanceData.Status

 s Result.HappenDate = objInstanceData.HappenDate 
 s Result.HappenTime = objInstanceData.HappenTime 
 s Result.ListNo = objInstanceData.ListNo 

 s Result.CreateDate = objInstanceData.CreateDate 
 s Result.CreateTime = objInstanceData.CreateTime 
 s Result.CreateUser = objInstanceData.CreateUser 

 s Result.TemplateID = objInstanceData.TemplateID 
 s Result.TemplateVersion = objInstanceData.TemplateVersion 

 s Result.ModifyTime = objInstanceData.ModifyTime 
 s Result.ModifyUser = objInstanceData.ModifyUser 

 s Result.ChartItemID = objInstanceData.TheECRecord.ChartItemID
 s Result.EpisodeID = objInstanceData.TheECRecord.EpisodeID 
 s Result.PatientID = objInstanceData.TheECRecord.PatientID 
 s Result.TheECRecord = objInstanceData.TheECRecord.%Id()
 s Result.ChartItemType = objInstanceData.TheECRecord.ChartItemType
 s Result.CategoryID = objInstanceData.TheECRecord.CategoryID 
 s Result.CategoryType = objInstanceData.TheECRecord.CategoryType 
 s Result.InstanceData=""

 Quit Result
}

ClassMethod GetGroupDataByID(AID As %String) As EPRservice.entity.EInstanceData [ WebMethod ]
{
 set objInstanceData = ##class(EPRinstance.InstanceData).%OpenId(AID) 
 if (objInstanceData= "")
 {
	Quit "" 
 }
 s Result =##class(EPRservice.entity.EInstanceData).%New()
 if (Result="")
 {
	Quit ""
 }
 
 if (objInstanceData.TemplateID '="")  
 {
 	s Result.TemplateVersion = objInstanceData.TemplateVersion

 	//s Result.MetaData  =  ##class(EPRmeta.TemplateVersion).GetMetaData(objInstanceData.TemplateID,objInstanceData.TemplateVersion)
 	//s Result.PresentationData  =  ##class(EPRmeta.TemplateVersion).GetPresentationData(objInstanceData.TemplateID,objInstanceData.TemplateVersion)
	d Result.MetaData.CopyFrom(##class(EPRmeta.TemplateVersion).GetMetaData(objInstanceData.TemplateID,objInstanceData.TemplateVersion))
 	d Result.PresentationData.CopyFrom(##class(EPRmeta.TemplateVersion).GetPresentationData(objInstanceData.TemplateID,objInstanceData.TemplateVersion))
	
		    
 	if (objInstanceData.Status ="UnSave")  
 	{
	 	//modified on 2008-10-15 by houj
 		//s Result.InstanceData = ##class(EPRmeta.TemplateVersion).GetInitialData(objInstanceData.TemplateID,objInstanceData.TemplateVersion) 
 		do Result.InstanceData.CopyFrom(##class(EPRmeta.TemplateVersion).GetInitialData(objInstanceData.TemplateID,objInstanceData.TemplateVersion)) 
 	}
 	Elseif (objInstanceData.Status '="UnSave") //="Save")  ;gjb 2008-03-26
 	{
	 	s Result.InstanceData = objInstanceData.InstanceData
	}


 	s Result.Title = objInstanceData.Title 
 	s Result.ID = AID
 	s Result.Status = objInstanceData.Status

 	s Result.HappenDate = objInstanceData.HappenDate 
 	s Result.HappenTime = objInstanceData.HappenTime 
 	s Result.ListNo = objInstanceData.ListNo 


 	s Result.CreateDate = objInstanceData.CreateDate 
 	s Result.CreateTime = objInstanceData.CreateTime 
	s Result.CreateUser = objInstanceData.CreateUser 


 	s Result.GroupItemID = objInstanceData.GroupItemID 
 	s Result.GroupItemName = objInstanceData.GroupItemName 

 	s Result.TemplateID = objInstanceData.TemplateID 
 	s Result.TemplateVersion = objInstanceData.TemplateVersion 
 	s Result.ModifyTime = objInstanceData.ModifyTime 
 	s Result.ModifyUser = objInstanceData.ModifyUser 


 	s Result.ChartItemID = objInstanceData.TheECRecord.ChartItemID
 	s Result.EpisodeID = objInstanceData.TheECRecord.EpisodeID 
 	s Result.PatientID = objInstanceData.TheECRecord.PatientID 
	s Result.TheECRecord = objInstanceData.TheECRecord.%Id()
 	s Result.ChartItemType = objInstanceData.TheECRecord.ChartItemType
 	s Result.CategoryID = objInstanceData.TheECRecord.CategoryID 
 	s Result.CategoryType = objInstanceData.TheECRecord.CategoryType 


 	Quit Result	 
	 
 }
 elseif (objInstanceData.TemplateID ="")  
 {
 	Set ACategoryID = objInstanceData.GroupItemID
 	set AEpisodeType = objInstanceData.TheECRecord.EpisodeType

 	//search  Template 
 	//通过权限控制查找当前AChartItemID下的模板，如果没有权限控制则采用原方式取ATemplateID
 	s rtnTemplate = ##class(EPRservice.TPrivLogic.PrivLogic).GetTempForView(objInstanceData.TheECRecord.EpisodeID,"",ACategoryID)
 	s privateActivity = $p(rtnTemplate,"^",1)
 	s ATemplateID = $p(rtnTemplate,"^",2)
 	if (privateActivity = "N")
 	{ 
 		if (AEpisodeType="O")
 	 	{S ATemplateProperty ="OutPatient" }
 	 	elseif (AEpisodeType="E")
 	 	{S ATemplateProperty ="Emergency" }
 	 	elseif (AEpisodeType="I")
 	 	{S ATemplateProperty ="InPatient" }

 		Set ATemplateID= ##class(EPRmeta.Template).GetIDBYCATEGORY(ACategoryID,ATemplateProperty)
 	 	if (ATemplateID="")
 	 	{ 
 	 		s ATemplateProperty = "Default"
 	 		Set ATemplateID= ##class(EPRmeta.Template).GetIDBYCATEGORY(ACategoryID,ATemplateProperty) 
 	 	}
 	}

	if (ATemplateID'="")  
 	{
	  Set objTemplate = ##class(EPRmeta.Template).%OpenId(ATemplateID)
	  if (objTemplate'= "")
	  {
		  set objInstanceData.TemplateID = ATemplateID
		  set objInstanceData.Title = objTemplate.Name 
		  set objInstanceData.TemplateVersion = objTemplate.PublishVersion

		  set Result.TemplateID = ATemplateID
		  set Result.Title = objTemplate.Name 
		  set Result.TemplateVersion = objTemplate.PublishVersion
		  
		 if (objInstanceData.TemplateVersion '= "0")  
		 {
			 //modified on 2010-07-17 by houj
			 //s Result.MetaData  =  ##class(EPRmeta.TemplateVersion).GetMetaData(ATemplateID,Result.TemplateVersion)
			 //s Result.PresentationData  =  ##class(EPRmeta.TemplateVersion).GetPresentationData(ATemplateID,Result.TemplateVersion)
			 d Result.MetaData.CopyFrom(##class(EPRmeta.TemplateVersion).GetMetaData(ATemplateID,Result.TemplateVersion))
			 d Result.PresentationData.CopyFrom(##class(EPRmeta.TemplateVersion).GetPresentationData(ATemplateID,Result.TemplateVersion))
			 
			 //modified on 2008-10-15 by houj
			 //s Result.InstanceData  =  ##class(EPRmeta.TemplateVersion).GetInitialData(ATemplateID,Result.TemplateVersion)
		 	 do Result.InstanceData.CopyFrom(##class(EPRmeta.TemplateVersion).GetInitialData(ATemplateID,Result.TemplateVersion))
		 }
		  
		  Elseif (objInstanceData.TemplateVersion = "0")
		  {
			  	 //comment on 2008-10-15 by houj
				 //s Result.MetaData = ""
				 //s Result.PresentationData  =  ""
				 //s Result.InstanceData  =  ""
		   }
	   }
	}
	elseif  (ATemplateID ="")  
	{
		set objInstanceData.TemplateID = ""
		set objInstanceData.Title = ""
		set objInstanceData.TemplateVersion = ""
		set Result.TemplateID = ""
		set Result.Title = ""
		set Result.TemplateVersion = ""
		
		//comment on 2008-10-15 by houj
		//s Result.MetaData  =  ""
		//s Result.PresentationData  =  ""
		//s Result.InstanceData  =  ""
	}

 	set objInstanceData.Status = "UnSave" //AEInstanceData.Status
 	//set OBJECRecord=##class(EPRinstance.ECRecord).()     
 	//Set objInstanceData.TheECRecord = OBJECRecord
 	if '(objInstanceData.%Save())  
	{
 		//TROLLBACK
 		Quit 0
	}
	
 	s Result.Status ="UnSave"
 	s Result.ID = AID
 	s Result.TheECRecord= objInstanceData.%Id()
 	s Result.ListNo= objInstanceData.ListNo
 	s Result.ChartItemID = objInstanceData.TheECRecord.ChartItemID
 	s Result.EpisodeID = objInstanceData.TheECRecord.EpisodeID 
 	s Result.PatientID = objInstanceData.TheECRecord.PatientID 
 	s Result.TheECRecord = objInstanceData.TheECRecord.%Id()
 	s Result.ChartItemType = objInstanceData.TheECRecord.ChartItemType
 	s Result.CategoryID = objInstanceData.TheECRecord.CategoryID 
 	s Result.CategoryType = objInstanceData.TheECRecord.CategoryType 
 	s Result.GroupItemID = objInstanceData.GroupItemID 
 	s Result.GroupItemName = objInstanceData.GroupItemName 
 	Quit Result

}
}

ClassMethod GetGroupItemList(APatientID As %String, AEpisodeID As %String, AEpisodeType As %String, AChartItemID As %String, AChartItemType As %String, ACategoryType As %String, ACategoryID As %String) As EPRservice.dataset.EInsGroupNewDataSet [ WebMethod ]
{
 //s ^DHCEPRDebug("BOInstance","GetNormalData","para")=APatientID_"^"_AEpisodeID_"^"_AEpisodeType_"^"_AChartItemID_"^"_AChartItemType_"^"_ACategoryType_"^"_ACategoryID
 Set CheckInstanceExist = ##class(EPRinstance.ECRecord).CheckInstanceExist(APatientID,AEpisodeID,AChartItemID)
 if (CheckInstanceExist'=0)
 {
 Set AECRecordID = ##class(EPRinstance.ECRecord).GetECRecordID(APatientID,AEpisodeID,AChartItemID)
 }
 Elseif (CheckInstanceExist=0)
 {
	  //new OBJECRecord
 S OBJECRecord = ##class(EPRinstance.ECRecord).%New()  
 if (OBJECRecord '="")   
 {
	s OBJECRecord.PatientID= APatientID
	s OBJECRecord.EpisodeID= AEpisodeID
	s OBJECRecord.EpisodeType= AEpisodeType
	s OBJECRecord.CategoryType= ACategoryType
	s OBJECRecord.CategoryID= ACategoryID
	s OBJECRecord.ChartItemID= AChartItemID
	s OBJECRecord.ChartItemType= AChartItemType
	s OBJECRecord.InstanceCount = 0
	
	/*
	//To use M For Query(Modified By cwj)
	 
	Set TPCategoryDataset = ##class(%ResultSet).%New("%DynamicQuery:SQL")
    Do TPCategoryDataset.Prepare("SELECT ID,Name,CategoryType,CategoryProperty FROM EPRmeta.TemplateCategory Where ParentID= ? ORDER BY ID")
	Do TPCategoryDataset.Execute(ACategoryID)
	For  {
	       If 'TPCategoryDataset.Next() Quit
	       set objInstanceData = ##class(EPRinstance.InstanceData).%New()
	       set OBJECRecord.InstanceCount = OBJECRecord.InstanceCount+1
	       set objInstanceData.GroupItemID = TPCategoryDataset.Data("ID")
	       set objInstanceData.GroupItemName = TPCategoryDataset.Data("Name")
	       Set objInstanceData.TheECRecord = OBJECRecord
	       set objInstanceData.Status ="UnSave"
	       if (OBJECRecord.%Save())
	       {
			 S TempObjID = objInstanceData.%Id()
			 S TempListNo = $PIECE(TempObjID,"||",2)
			 set objInstanceData.ListNo = TempListNo
		       }
		   do OBJECRecord.%Save()     
	
	}
	set AECRecordID = OBJECRecord.%Id()
	
	*/
	  //b "s"
	 s IdxCategoryId = " "_ACategoryID
	 s curTempCategoryId = 0
	 s curTempCategoryId = $o(^DHCEPRM.TemplateCategoryI("IdxParentId",IdxCategoryId,curTempCategoryId))
	 WHILE (curTempCategoryId '= "") 
	 {
		set objInstanceData = ##class(EPRinstance.InstanceData).%New()
	    set OBJECRecord.InstanceCount = OBJECRecord.InstanceCount + 1
	    
	    set curTempCategoryNote = $g(^DHCEPRM.TemplateCategoryD(curTempCategoryId))
	    
	    set objInstanceData.GroupItemID = curTempCategoryId
	    set objInstanceData.GroupItemName = $lg(curTempCategoryNote,3)
	    Set objInstanceData.TheECRecord = OBJECRecord
	    set objInstanceData.Status ="UnSave"
	    if (OBJECRecord.%Save())
	    {
			S TempObjID = objInstanceData.%Id()
			S TempListNo = $PIECE(TempObjID,"||",2)
			s objInstanceData.ListNo = TempListNo
		}
		do OBJECRecord.%Save()
		
  		s curTempCategoryId = $o(^DHCEPRM.TemplateCategoryI("IdxParentId",IdxCategoryId,curTempCategoryId))
	 }
	 
	 set AECRecordID = OBJECRecord.%Id()
	 
	}
 }

 Set AGroupItemList=##class(EPRservice.dataset.EInsGroupNewDataSet).%New()
 Do AGroupItemList.SetArgs(AECRecordID, AEpisodeID) //多传入参数AEpisodeID--Modified By cwj On 080223
 Quit AGroupItemList
}

/// TODO: add arguments and implementation.
/// CreateInstanceData
ClassMethod GetMultipleData(APatientID As %String, AEpisodeID As %String, AChartItemID As %String, AChartItemType As %String, AChartListNo As %String, ATemplateID As %String, ACategoryID As %String, ACategoryType As %String) As EPRservice.entity.EInstanceData [ WebMethod ]
{
	//debug begin
	//s ^CacheTempDHCEPRDebug("EPRservice.BOInstanceData","GetMultipleData","Input")="APatientID="_APatientID_"^AEpisodeID="_AEpisodeID_"^AChartItemID="_AChartItemID_"^AChartItemType="_AChartItemType_"^AChartListNo=" _AChartListNo_"^ATemplateID=" _ATemplateID _"^ACategoryID=" _ ACategoryID _"^ACategoryType="_ACategoryType
	//debug end
		
	S CheckDataExist = ##class(EPRinstance.ECRecord).CheckInstanceExist(APatientID,AEpisodeID,AChartItemID)
	 s Result = ##class(EPRservice.entity.EInstanceData).%New()
	 s Result.PatientID = APatientID	  
	 s Result.EpisodeID = AEpisodeID	  
	 s Result.ChartItemID = AChartItemID	  
	 s Result.ListNo = AChartListNo	
	 s Result.TemplateID = ATemplateID
	 S Result.CategoryType = ACategoryType
	 s Result.CategoryID = ACategoryID
	
	 set Result.HappenDate = $ZDATEH($ZDATE($HOROLOG))
	 set Result.HappenTime = $ZTIMEH($ZTIME($PIECE($HOROLOG,",",2),1))
	
	 /*
	Property TemplateVersion As %Integer;
	*/
	 if (CheckDataExist=0)
	 {
	
	 S AECRecord = ##class(EPRinstance.ECRecord).%New()
	 S AECRecord.PatientID= APatientID
	 S AECRecord.EpisodeID= AEpisodeID
	 S AECRecord.ChartItemID= AChartItemID
	 S AECRecord.ChartItemType= AChartItemType
	 S AECRecord.CategoryID= ACategoryID
	 S AECRecord.CategoryType= ACategoryType
	
	 D AECRecord.%Save()
	 S Result.TheECRecord = AECRecord.%Id() 
	
	
	 s Result.TemplateVersion = ##class(EPRmeta.Template).GetVersionBYID(ATemplateID)
	 s Result.Title =  ##class(EPRmeta.Template).GetTitleBYID(ATemplateID) //objInstanceData.Title 
	 //modified on 2010-07-17 by houj
	 //s Result.MetaData  =  ##class(EPRmeta.TemplateVersion).GetMetaData(ATemplateID,Result.TemplateVersion)
	 //s Result.PresentationData  =  ##class(EPRmeta.TemplateVersion).GetPresentationData(ATemplateID,Result.TemplateVersion)
	 //s Result.InstanceData  =  ##class(EPRmeta.TemplateVersion).GetInitialData(ATemplateID,Result.TemplateVersion)
	 d Result.MetaData.CopyFrom(##class(EPRmeta.TemplateVersion).GetMetaData(ATemplateID,Result.TemplateVersion))
	 d Result.PresentationData.CopyFrom(##class(EPRmeta.TemplateVersion).GetPresentationData(ATemplateID,Result.TemplateVersion))
	 d Result.InstanceData.CopyFrom(##class(EPRmeta.TemplateVersion).GetInitialData(ATemplateID,Result.TemplateVersion))
	 
	 s Result.Status = "UnSave"	  
	 }
	 Elseif (CheckDataExist '=0)
	 {
		 if (AChartListNo="-1")
		 {
			 S AECRecord = ##class(EPRinstance.ECRecord).GetECRecordID(APatientID,AEpisodeID,AChartItemID)  
					 s Result.TemplateVersion = ##class(EPRmeta.Template).GetVersionBYID(ATemplateID)
			 //s Result.Title = objInstanceData.Title
			 s Result.Title =  ##class(EPRmeta.Template).GetTitleBYID(ATemplateID) //objInstanceData.Title 
			 //modified on 2010-07-17 by houj
			 //s Result.MetaData  =  ##class(EPRmeta.TemplateVersion).GetMetaData(ATemplateID,Result.TemplateVersion)
			 //s Result.PresentationData  =  ##class(EPRmeta.TemplateVersion).GetPresentationData(ATemplateID,Result.TemplateVersion)
			 //s Result.InstanceData  =  ##class(EPRmeta.TemplateVersion).GetInitialData(ATemplateID,Result.TemplateVersion)
			 d Result.MetaData.CopyFrom(##class(EPRmeta.TemplateVersion).GetMetaData(ATemplateID,Result.TemplateVersion))
			 d Result.PresentationData.CopyFrom(##class(EPRmeta.TemplateVersion).GetPresentationData(ATemplateID,Result.TemplateVersion))
			 d Result.InstanceData.CopyFrom(##class(EPRmeta.TemplateVersion).GetInitialData(ATemplateID,Result.TemplateVersion))
			 
			 s Result.Status = "UnSave"	
			 S Result.TheECRecord =AECRecord   
		 }
		 Elseif (AChartListNo'="-1")
		 {
		   S AECRecord = ##class(EPRinstance.ECRecord).GetECRecordID(APatientID,AEpisodeID,AChartItemID)  
		   if AECRecord =""
		   { 
		    Quit ""
		  	}
		   	s OBJECRecord = ##class(EPRinstance.ECRecord).%OpenId(AECRecord)  
		   
		   	//s Result.CategoryID = OBJECRecord.CategoryID 
	 			//s Result.CategoryType = OBJECRecord.CategoryType 
	 			s Result.TheECRecord = AECRecord
		   
		   
		  	 Set key = ""
	 			do
	 			{ 
		     S objInstanceData = OBJECRecord.Instances.GetNext(.key)
		
		     if (objInstanceData '= "")
		     { if (objInstanceData.ListNo = AChartListNo)
		       {
			     	s Result.TemplateVersion = objInstanceData.TemplateVersion
			     	
			     	//modified 2010-07-17 by houj
			     	//s Result.MetaData  =  ##class(EPRmeta.TemplateVersion).GetMetaData(ATemplateID,Result.TemplateVersion)
					//s Result.PresentationData  =  ##class(EPRmeta.TemplateVersion).GetPresentationData(ATemplateID,Result.TemplateVersion)
			    	//s Result.InstanceData = objInstanceData.InstanceData
			    	d Result.MetaData.CopyFrom(##class(EPRmeta.TemplateVersion).GetMetaData(ATemplateID,Result.TemplateVersion))
					d Result.PresentationData.CopyFrom(##class(EPRmeta.TemplateVersion).GetPresentationData(ATemplateID,Result.TemplateVersion))
			      	d Result.InstanceData.CopyFrom(objInstanceData.InstanceData)
			    
			      	s Result.Title = objInstanceData.Title
			      	s Result.Remark = objInstanceData.Remark 	// "Remark"	;Zuoxiang 2010-11-05
	 				s Result.Status = objInstanceData.Status 	//"Save"  ;gjb 2008-03-26
			      	set Result.ID = objInstanceData.%Id()
			      	q
			    }
			  } 
	 		} while (key '="" )
	 	} 
	 }
	 Quit Result
}

/// CreateTime: 
/// CreateUser: 
/// Desc:		前台DLL取出普通模板的模板及病历内容的InstanceData
/// Input:		APatientID:APatientID
/// 			AEpisodeID:就诊号
/// 			AEpisodeType：就诊类型（住院、门诊等）
/// 			AChartItemID:TrakCare的横排子项ID
/// 			ACategoryType：电子病历界面模板类型（普通、直接、分组、分组子项）
/// 			ACategoryID: 电子病历界面模板的目录ID
/// Output:		EPRservice.entity.EInstanceData
/// Debug: w ##class(EPRservice.BOInstanceData).GetNormalData("431","65","I","4","Single","Normal","")
ClassMethod GetNormalData(APatientID As %String, AEpisodeID As %String, AEpisodeType As %String, AChartItemID As %String, AChartItemType As %String, ACategoryType As %String, ACategoryID As %String) As EPRservice.entity.EInstanceData [ WebMethod ]
{
	//s ^DHCEPRDebug("EPRservice.BOInstanceData","Input") =  APatientID_"^"_AEpisodeID_"^"_AEpisodeType_"^"_AChartItemID_"^"_AChartItemType_"^"_ACategoryType_"^"_ACategoryID
	
	//老框架获取Instance数据
	if (($d(ACategoryID) '= 0) && (ACategoryID '= $c(0)) && (ACategoryID '= ""))
	{
		q ..GetNormalDataOld(APatientID, AEpisodeID, AEpisodeType, AChartItemID, AChartItemType, ACategoryType, ACategoryID)	
	}
	else
	{
		 //新框架获取Instance数据
		 /*
		 *注：在新框架中,AChartItemID表示EPRTemplateID
		 *
		 */
		q:(AChartItemID="") ""
		
		s objERPTemplate = ##class(EPRmeta.EPRTemplate).%OpenId(AChartItemID)
		q:(objERPTemplate="") ""
		s bindTemplateID = objERPTemplate.BindTemplateID
		s bindTemplateCategoryID = objERPTemplate.BindTemplateCategoryID
		s EPRCategoryID=objERPTemplate.EPRCategoryID
		d objERPTemplate.%Close()
		k objERPTemplate
		
		s objCategory = ##class(EPRmeta.TemplateCategory).%OpenId(bindTemplateCategoryID)
		q:(objCategory="") ""
		s bindCategoryType = objCategory.CategoryType
		if (bindCategoryType = "GroupItem")
		{
			s chartTemplateCategoryID = objCategory.ParentID	
		}
		else
		{
			s chartTemplateCategoryID = bindTemplateCategoryID	
		}
		d objCategory.%Close()
		k objCategory
		
		//兼容新老框架数据
		/*
		if ($d(^EPRCatIDToChartID(chartTemplateCategoryID)) = 1)
		{
			s chartItemID = ^EPRCatIDToChartID(chartTemplateCategoryID)
		}
		else
		{
			s chartItemID =	"CG"_chartTemplateCategoryID
		}
		*/
		s chartItemID = chartTemplateCategoryID	
		q ..GetItemECRecordData(APatientID, AEpisodeID, AEpisodeType, chartItemID, bindCategoryType, bindTemplateCategoryID, bindTemplateID)
		
	}
}

/// CreateTime:2009-06-20 
/// CreateUser:Chenwenjun
/// Desc:		获取老框架的Instance数据
/// Input:		APatientID:APatientID
/// 			AEpisodeID:就诊号
/// 			AEpisodeType：就诊类型（住院、门诊等）
/// 			AChartItemID:TrakCare的横排子项ID
/// 			ACategoryType：电子病历界面模板类型（普通、直接、分组、分组子项）
/// 			ACategoryID: 电子病历界面模板的目录ID
/// Output:		EPRservice.entity.EInstanceData
ClassMethod GetNormalDataOld(APatientID As %String, AEpisodeID As %String, AEpisodeType As %String, AChartItemID As %String, AChartItemType As %String, ACategoryType As %String, ACategoryID As %String) As EPRservice.entity.EInstanceData [ WebMethod ]
{
	
 //取出当前普通模板的InstancesId	
 s TempObjID = ""
 Set CheckInstanceExist = ##class(EPRinstance.ECRecord).CheckInstanceExist(APatientID,AEpisodeID,AChartItemID)
 
 if (CheckInstanceExist'=0)
 {
 	Set AECRecordID = ##class(EPRinstance.ECRecord).GetECRecordID(APatientID,AEpisodeID,AChartItemID)
 
    if AECRecordID =""
	{ 
	   q ""
	}
	s OBJECRecord = ##class(EPRinstance.ECRecord).%OpenId(AECRecordID) 

	S key = ""
	do
	{ 
	  S objInstanceData = OBJECRecord.Instances.GetNext(.key)
	 
	  if (objInstanceData '= "")
	  { 
	  	//为了防止之前保存的数据不合法，加上此处理
	  	if (objInstanceData.GroupItemID = "" && ACategoryID '="")
	  	{
	  		s objInstanceData.GroupItemID = ACategoryID
	  		d objInstanceData.%Save()
	  	}
	  	//
	  	//
	  	s TempObjID = objInstanceData.%Id()	
	  	q
	  }
	} while (key '="" )
 }
 Elseif (CheckInstanceExist=0)
 {
 	S OBJECRecord = ##class(EPRinstance.ECRecord).%New()  
	if (OBJECRecord '="")   
 	{
		s OBJECRecord.PatientID= APatientID
		s OBJECRecord.EpisodeID= AEpisodeID
		s OBJECRecord.EpisodeType= AEpisodeType
		s OBJECRecord.CategoryType= ACategoryType
		s OBJECRecord.CategoryID= ACategoryID
		s OBJECRecord.ChartItemID= AChartItemID
		s OBJECRecord.ChartItemType= AChartItemType
		s OBJECRecord.InstanceCount = 1
	
		s objInstanceData = ##class(EPRinstance.InstanceData).%New()
		s objInstanceData.GroupItemID = ACategoryID
		s objInstanceData.GroupItemName = ""
		S objInstanceData.TheECRecord = OBJECRecord
		s objInstanceData.Status ="UnSave"
		s objInstanceData.ListNo = 1
		
		d OBJECRecord.%Save()

		S TempObjID = objInstanceData.%Id()
	}
	else
	{
		q ""
	}
 }
 
 //根据InstancesId返回EInstanceData
 if (TempObjID '="")
 {
   q ..GetGroupDataByID(TempObjID)
 }
 else
 {
 	q ""
 }
}

ClassMethod GetParentGroupList(APatientID As %String, AEpisodeID As %String, AEpisodeType As %String, AChartItemID As %String, AChartItemType As %String, ACategoryType As %String, ACategoryID As %String) As EPRservice.dataset.EInsGroupNewDataSet [ WebMethod ]
{
 ;S ^AABluebdyGetNormalData("GetParentGroupList")=APatientID_"^"_AEpisodeID_"^"_AEpisodeType_"^"_AChartItemID_ "^"_ AChartItemType_"^"_ACategoryType_"^"_ACategoryID	

 Set CheckInstanceExist = ##class(EPRinstance.ECRecord).CheckInstanceExist(APatientID,AEpisodeID,AChartItemID)
 if (CheckInstanceExist'=0)
 {
 Set AECRecordID = ##class(EPRinstance.ECRecord).GetECRecordID(APatientID,AEpisodeID,AChartItemID)
 }
 Elseif (CheckInstanceExist=0)
 {
	 	  //new OBJECRecord
 S OBJECRecord = ##class(EPRinstance.ECRecord).%New()  
 if (OBJECRecord '="")   
 {
	s OBJECRecord.PatientID= APatientID
	s OBJECRecord.EpisodeID= AEpisodeID
	s OBJECRecord.EpisodeType= AEpisodeType
	s OBJECRecord.CategoryType= ACategoryType
	s OBJECRecord.CategoryID= ACategoryID
	s OBJECRecord.ChartItemID= AChartItemID
	s OBJECRecord.ChartItemType= AChartItemType
	
	s OBJECRecord.InstanceCount = 0     

 if (AEpisodeType="O")
 {S ACategoryProperty ="OutPatient" }
 elseif (AEpisodeType="E")
 {S ACategoryProperty ="Emergency" }
 elseif (AEpisodeType="I")
 {S ACategoryProperty ="InPatient" }

 Set AGroupCategoryID= ##class(EPRmeta.TemplateCategory).GetGCIDByParentID(ACategoryID,ACategoryProperty) 



 s OBJECRecord.GroupCategoryID= AGroupCategoryID

 Set TPCategoryDataset = ##class(%ResultSet).%New("%DynamicQuery:SQL")
	
 Do TPCategoryDataset.Prepare("SELECT ID,Name,CategoryType,CategoryProperty FROM EPRmeta.TemplateCategory Where ParentID= ? ORDER BY ID")
	Do TPCategoryDataset.Execute(AGroupCategoryID)
	For  {
			
	       If 'TPCategoryDataset.Next() Quit	       
	       set objInstanceData = ##class(EPRinstance.InstanceData).%New()
	       set OBJECRecord.InstanceCount = OBJECRecord.InstanceCount+1
	       set objInstanceData.GroupItemID = TPCategoryDataset.Data("ID")
	       set objInstanceData.GroupItemName = TPCategoryDataset.Data("Name")
	       Set objInstanceData.TheECRecord = OBJECRecord
	       set objInstanceData.Status ="UnSave"
	       if (OBJECRecord.%Save())
	       {
			 S TempObjID = objInstanceData.%Id()
			 S TempListNo = $PIECE(TempObjID,"||",2)
			 set objInstanceData.ListNo = TempListNo
		    }
		   do OBJECRecord.%Save()     
	
	}
	do OBJECRecord.%Save()
	set AECRecordID = OBJECRecord.%Id()     
 }	
 }

 Set AGroupItemList=##class(EPRservice.dataset.EInsGroupNewDataSet).%New()
 Do AGroupItemList.SetArgs(AECRecordID, AEpisodeID)
 Quit AGroupItemList
}

/// Desc: 切换成组模板，使用新成组模板初始化病历，并删除原有数据
/// Input:	AInstanceID:实例数据rowid
/// 		ATemplateID：新界面模板rowid
/// 		ATemplateName: 新界面模板的名称
/// Output：无
/// Return：EPRservice.entity.EInstanceData
/// 
/// ModifyUser：HouJ
/// ModifyTime: 2009-07-27
/// ModifyDesc: 切换模板后立即清除原有数据
ClassMethod ReplaceGroupData(AInstanceID As %String, ATemplateID As %String, ATemplateName As %String) As EPRservice.entity.EInstanceData [ WebMethod ]
{
 //构造要返回的实体对象
 s Result = ##class(EPRservice.entity.EInstanceData).%New()
 s Result.ID=AInstanceID
 
 s objInstanceData= ##class(EPRinstance.InstanceData).%OpenId(AInstanceID)
 q:(objInstanceData="") ""
 
 s Result.Title = objInstanceData.Title 
 s Result.ListNo = objInstanceData.ListNo 
 s Result.HappenDate = $ZDATEH($ZDATE($HOROLOG))
 s Result.HappenTime = $ZTIMEH($ZTIME($PIECE($HOROLOG,",",2),1))
 s Result.ModifyUser = objInstanceData.ModifyUser 
 s Result.ModifyDate = $ZDATEH($ZDATE($HOROLOG))
 s Result.ModifyTime = $ZTIMEH($ZTIME($PIECE($HOROLOG,",",2),1))

 s Result.CreateTime = objInstanceData.CreateTime 
 s Result.CreateDate = objInstanceData.CreateDate 
 s Result.CreateUser = objInstanceData.CreateUser
 s Result.TheECRecord = objInstanceData.TheECRecord.%Id()
 s Result.Status ="UnSave" 

 s Result.ChartItemID = objInstanceData.TheECRecord.ChartItemID
 s Result.EpisodeID = objInstanceData.TheECRecord.EpisodeID 
 s Result.PatientID = objInstanceData.TheECRecord.PatientID 
 s Result.ChartItemType = objInstanceData.TheECRecord.ChartItemType
 s Result.CategoryID = objInstanceData.TheECRecord.CategoryID 
 s Result.CategoryType = objInstanceData.TheECRecord.CategoryType 
 s Result.GroupItemID = objInstanceData.GroupItemID
 s Result.GroupItemName = objInstanceData.GroupItemName

 s Result.TemplateID= ATemplateID 
 s Result.TemplateVersion= ##class(EPRmeta.Template).GetVersionBYID(ATemplateID)  
 //modified on 2010-07-17 by houj
 //s Result.MetaData  =  ##class(EPRmeta.TemplateVersion).GetMetaData(ATemplateID,Result.TemplateVersion)
 //s Result.PresentationData  =  ##class(EPRmeta.TemplateVersion).GetPresentationData(ATemplateID,Result.TemplateVersion)
 //s Result.InstanceData  =  ##class(EPRmeta.TemplateVersion).GetInitialData(ATemplateID,Result.TemplateVersion)
 d Result.MetaData.CopyFrom(##class(EPRmeta.TemplateVersion).GetMetaData(ATemplateID,Result.TemplateVersion))
 d Result.PresentationData.CopyFrom(##class(EPRmeta.TemplateVersion).GetPresentationData(ATemplateID,Result.TemplateVersion))
 d Result.InstanceData.CopyFrom(##class(EPRmeta.TemplateVersion).GetInitialData(ATemplateID,Result.TemplateVersion))

 //使用新界面模板初始化病历，并清空打散数据
 s objInstanceData.TemplateID= ATemplateID
 s objInstanceData.TemplateVersion= Result.TemplateVersion
 s objInstanceData.Status="UnSave"
 S AECRecordID = Result.TheECRecord
 d objInstanceData.InstanceData.CopyFrom(Result.InstanceData)
 d objInstanceData.%Save()
 
 do ..ClearScatterDataByInstanceID(AInstanceID)

 //使用新界面模板初始化本组其它病历，并清空其打散数据
 q:(ATemplateName="") Result
 
 set ReplaceDataset = ##class(%ResultSet).%New("EPRinstance.InstanceData:SELECTGroupList")
 Do ReplaceDataset.Execute(AECRecordID)
 While (ReplaceDataset.Next())  
 {
 	set AGroupItemID = ReplaceDataset.Data("GroupItemID") 
 	set AGroupInstanceID = ReplaceDataset.Data("ID") 
 	if (AGroupItemID'="")
 	{
	 	s AGroupTemplateID=##class(EPRmeta.Template).GetReplaceIDBYCATEGORY(AGroupItemID,ATemplateName) 
	    if (AGroupTemplateID'= "")
	    {
		    s AGroupTemplateVersion= ##class(EPRmeta.Template).GetVersionBYID(AGroupTemplateID) 
		   	s objGroupInstanceData =##class(EPRinstance.InstanceData).%OpenId(AGroupInstanceID)
		   	if (objGroupInstanceData'="")
		    { 
		    	s objGroupInstanceData.TemplateID = AGroupTemplateID
		      	s objGroupInstanceData.TemplateVersion = AGroupTemplateVersion
		        s objGroupInstanceData.Status= "UnSave"
		      	d objGroupInstanceData.InstanceData.Clear()
		      	do objGroupInstanceData.%Save()
		      	
		      	do ..ClearScatterDataByInstanceID(objGroupInstanceData.%Id())
		     } 
		 }  
	}
 }   
 do ReplaceDataset.Close()

 Quit Result
}

/// Desc: 切换模板，使用新模板初始化病历，并删除原有数据
/// Input:	AInstanceID:实例数据rowid
/// 		ATemplateID：新界面模板rowid
/// Output：无
/// Return：EPRservice.entity.EInstanceData
/// 
/// ModifyUser：HouJ
/// ModifyTime: 2009-07-27
/// ModifyDesc: 切换模板后立即清除原有数据
ClassMethod ReplaceTemplateData(AInstanceID As %String, ATemplateID As %String) As EPRservice.entity.EInstanceData [ WebMethod ]
{
	//q:(($d(aInstanceID)=0)||($d(aTemplateID)=0)) ""
	
	//取原实例数据
	s objInstanceData= ##class(EPRinstance.InstanceData).%OpenId(AInstanceID)
 	quit:(objInstanceData="") ""
 
 	//取切换模板后的实体对象，并修改相应属性，构造返回值
 	s Result = ##class(EPRservice.entity.EInstanceData).%New()
 	s Result.ID = AInstanceID
 	s Result.Title = objInstanceData.Title 
 	s Result.ListNo = objInstanceData.ListNo 
 	s Result.HappenDate = objInstanceData.HappenDate
 	s Result.HappenTime = objInstanceData.HappenTime
 	s Result.ModifyUser = objInstanceData.ModifyUser 
 	s Result.CreateTime = objInstanceData.CreateTime 
 	s Result.CreateDate = objInstanceData.CreateDate 
 	s Result.CreateUser = objInstanceData.CreateUser
 	s Result.TheECRecord = objInstanceData.TheECRecord.%Id()
 	s Result.ChartItemID = objInstanceData.TheECRecord.ChartItemID
 	s Result.EpisodeID = objInstanceData.TheECRecord.EpisodeID 
 	s Result.PatientID = objInstanceData.TheECRecord.PatientID 
 	s Result.ChartItemType = objInstanceData.TheECRecord.ChartItemType
 	s Result.CategoryID = objInstanceData.TheECRecord.CategoryID 
 	s Result.CategoryType = objInstanceData.TheECRecord.CategoryType 
 	s Result.GroupItemID = objInstanceData.GroupItemID
 	s Result.GroupItemName = objInstanceData.GroupItemName

 	s Result.Status ="UnSave"
 	s Result.ModifyDate = $ZDATEH($ZDATE($HOROLOG))
 	s Result.ModifyTime = $ZTIMEH($ZTIME($PIECE($HOROLOG,",",2),1))
 	s Result.TemplateID= ATemplateID 
 	s Result.TemplateVersion= ##class(EPRmeta.Template).GetVersionBYID(ATemplateID)  
 	//modified on 2010-07-17 by houj
 	//s Result.MetaData  =  ##class(EPRmeta.TemplateVersion).GetMetaData(ATemplateID,Result.TemplateVersion)
 	//s Result.PresentationData  =  ##class(EPRmeta.TemplateVersion).GetPresentationData(ATemplateID,Result.TemplateVersion)
 	//s Result.InstanceData  =  ##class(EPRmeta.TemplateVersion).GetInitialData(ATemplateID,Result.TemplateVersion)
 	d Result.MetaData.CopyFrom(##class(EPRmeta.TemplateVersion).GetMetaData(ATemplateID,Result.TemplateVersion))
 	d Result.PresentationData.CopyFrom(##class(EPRmeta.TemplateVersion).GetPresentationData(ATemplateID,Result.TemplateVersion))
 	d Result.InstanceData.CopyFrom(##class(EPRmeta.TemplateVersion).GetInitialData(ATemplateID,Result.TemplateVersion))
 	
 	//修改原实例数据的相应属性
 	s objInstanceData.Status="UnSave"
 	s objInstanceData.ModifyDate=Result.ModifyDate
 	s objInstanceData.ModifyTime=Result.ModifyTime
 	s objInstanceData.TemplateID= ATemplateID
 	s objInstanceData.TemplateVersion= Result.TemplateVersion
 	d objInstanceData.InstanceData.CopyFrom(Result.InstanceData)
 	d objInstanceData.%Save()
 	
 	//清空原打散数据
 	do ..ClearScatterDataByInstanceID(AInstanceID)
 	
 	Quit Result
}

ClassMethod ClearScatterDataByInstanceID(aInstanceID As %String)
{
	q:(($d(aInstanceID)=0)||(aInstanceID=""))
	
	&sql(delete from EPRinstance.ISimple where InstanceDataID = :aInstanceID)
	
	&sql(delete from EPRinstance.ISegment where InstanceDataID = :aInstanceID)
	
	&sql(delete from EPRinstance.ISegmentSimple where InstanceDataID = :aInstanceID)
	
	&sql(delete from EPRinstance.ITextDesc where InstanceDataID = :aInstanceID)
	
	&sql(delete from EPRinstance.ITextDescSimple where InstanceDataID = :aInstanceID)
	
	&sql(delete from EPRinstance.ITableSimple where InstanceDataID = :aInstanceID)
	
	&sql(delete from EPRinstance.IAnnotate where InstanceDataID = :aInstanceID)
	
	&sql(delete from EPRinstance.IFigure where InstanceDataID = :aInstanceID)
}

/// ModifyDate : 2008-09-09
/// Description: 保存唯一模板的实例数据，并打散元数据内容
/// Table: EPRinstance.InstanceData	
ClassMethod SaveData(AEInstanceData As EPRservice.entity.EInstanceData, ByRef AEMixInstanceLog As EPRservice.entity.EMixInstanceLog, ByRef AErrorMessage As %String) As EPRservice.entity.EInstanceData [ WebMethod ]
{
	//b "s"
	//---debug begin
	/*
 	S ^CacheTempDHCEPRDebug("EPRservice.BOInstanceData","SaveData","InputStatus") = AEInstanceData.Status
 	s ^CacheTempDHCEPRDebug("EPRservice.BOInstanceData","SaveData","InputID") =  AEInstanceData.ID
 	s debuglen=1024*15
 	k ^CacheTempDHCEPRDebug("EPRservice.BOInstanceData","SaveData","InputInstanceData")
	s debugcount = 0
 	while (AEInstanceData.InstanceData.AtEnd = 0)
 	{
	 	s debugcount = debugcount + 1
	 	s ^CacheTempDHCEPRDebug("EPRservice.BOInstanceData","SaveData","InputInstanceData",debugcount) = AEInstanceData.InstanceData.Read(debuglen)
	}
	*/	
	//---debug end
	
	s $zt = "OnErrorHandlerSaveData"
	
	s AErrorMessage = ""
	
	//是否新框架
	if AEInstanceData.ChartItemID = +(AEInstanceData.ChartItemID)
	{	
		s isNewFramework = "0"
	}
	else
	{
		s isNewFramework = "1"
	}
	
	set now = $H
	set date = $P(now,",",1)
	set time = $P(now,",",2)
	
	if (AEInstanceData.Status = "UnSave")
 	{	 	
	 	s objInstanceData = ##class(EPRinstance.InstanceData).%OpenId(AEInstanceData.ID)
 		if objInstanceData = ""
 		{
	 		s AErrorMessage = "Error-EPRservice.BOInstanceData.SaveData-001:"
	 		s AErrorMessage = AErrorMessage_"InstanceData "_AEInstanceData.ID_" is not existed"
	 		//w AErrorMessage
	 		q AEInstanceData
	 	}
	 	
	 	s objInstanceData.ListNo = AEInstanceData.ListNo
	 	s objInstanceData.Title = AEInstanceData.Title
	 	s objInstanceData.TemplateID = AEInstanceData.TemplateID
	 	s objInstanceData.TemplateVersion = AEInstanceData.TemplateVersion
	 	s objInstanceData.CreateDate = date
	 	s objInstanceData.CreateTime = time
	 	s objInstanceData.CreateUser = AEInstanceData.CreateUser
	 	s objInstanceData.ModifyDate = date
	 	s objInstanceData.ModifyTime = time
	 	//s objInstanceData.ModifyUser = AEInstanceData.ModifyUser
	 	s objInstanceData.ModifyUser = AEInstanceData.CreateUser  //新建病历时，创建者和修改者是同一个用户
	 	s objInstanceData.HappenDate = date
	 	s objInstanceData.HappenTime = time
	 	d objInstanceData.InstanceData.CopyFrom(AEInstanceData.InstanceData)
	 	
	 	//更新病历状态，此处状态只能是Save
	 	//对于新旧框架来说，该状态都是必须的
	 	s objInstanceData.Status = "Save"
	 		
	 	//更新实体数据的状态，供自动保存使用
	 	//因为自动保存不更新数据状态、不写日志，但新建病历比较特殊，必须更改其状态下次加载时才能获取到保存后的数据
	 	s AEInstanceData.Status = objInstanceData.Status
 	}
 	else
 	{
 		s objInstanceData = ##class(EPRinstance.InstanceData).%OpenId(AEInstanceData.ID)
 		if objInstanceData = ""
 		{
	 		s AErrorMessage = "Error-EPRservice.BOInstanceData.SaveData-001:"
	 		s AErrorMessage = AErrorMessage_"InstanceData "_AEInstanceData.ID_" is not existed"
	 		//w AErrorMessage
	 		q AEInstanceData
	 	}
	 	
	 	s objInstanceData.ListNo = AEInstanceData.ListNo
	 	s objInstanceData.Title = AEInstanceData.Title
	 	s objInstanceData.TemplateID = AEInstanceData.TemplateID
	 	s objInstanceData.TemplateVersion = AEInstanceData.TemplateVersion
	 	s objInstanceData.ModifyUser = AEInstanceData.ModifyUser
	 	s objInstanceData.ModifyDate = date
	 	s objInstanceData.ModifyTime = time
	 	//s objInstanceData.HappenDate = AEInstanceData.HappenDate
	 	//s objInstanceData.HappenTime = AEInstanceData.HappenTime
	 	d objInstanceData.InstanceData.CopyFrom(AEInstanceData.InstanceData)
	 	
	 	//更新旧框架病历状态，新框架只需要区分UnSave和非UnSave状态
	 	if ('isNewFramework)&&(AEMixInstanceLog.FinalStatus'="") 
	 	{	s objInstanceData.Status = AEMixInstanceLog.FinalStatus}
 	}
	 		
	//todo:开启事务
	//执行保存操作
	s sc = objInstanceData.%Save()
	if $$$ISERR(sc)
	{
		s AErrorMessage = "Error-EPRservice.BOInstanceData.SaveData-002:"
	 	s AErrorMessage = AErrorMessage_"Failed in saving InstanceData "_AEInstanceData.ID
	 	//w AErrorMessage
	 	q AEInstanceData
	}
	
	//生成日志
	s AEMixInstanceLog.OperateDate = $zd(date,3)	//操作时间以服务器时间为准
	s AEMixInstanceLog.OperateTime = $zt(time,1)	//操作时间以服务器时间为准
	if isNewFramework
	{
		s action = AEMixInstanceLog.Action
		s episodeID = AEMixInstanceLog.EpisodeID
		s printDocID = AEMixInstanceLog.PrintTemplateDocID
		//s eprNum = objInstanceData.ListNo
		s eprNum = "1"
		s templateDocID = AEMixInstanceLog.TemplateDocID
		s happenDate = $zd(date,3)
		s happenTime = $zt(time,1)
		s machineIP = AEMixInstanceLog.OperateMachineIP
		s userID = AEMixInstanceLog.OperateUserID
		s templateID = AEInstanceData.TemplateID
		s sc = ..InitAfterSingleOper(action, episodeID, printDocID, eprNum, templateDocID, happenDate, happenTime, machineIP, userID, templateID)
		
		if (sc="")||(sc = "Error")
		{
			s AErrorMessage = "Error-EPRservice.BOInstanceData.SaveData-003:"
	 		s AErrorMessage = AErrorMessage_"Failed in generate log:"_action_"^"_episodeID_"^"_printDocID_"^"_eprNum_"^"_templateDocID_"^"_happenDate_"^"_happenTime_"^"_machineIP_"^"_userID_"^"_templateID
	 		//w AErrorMessage
	 		q AEInstanceData
		}
		
		//"success^"_divStateServer_"^"_logID_"^"_currState
		//s AEMixInstanceLog.FinalStatus = $P(sc,"^",4)
		s AEMixInstanceLog.StateInfo = sc
		
	}
	else
	{
		s sc = ..AddInstanceLog(objInstanceData.%Id(), AEMixInstanceLog)
		if sc '= "1"
		{
			s AErrorMessage = "Error-EPRservice.BOInstanceData.SaveData-003:"
	 		s AErrorMessage = AErrorMessage_"Failed in generate log: InstanceDataID: "_objInstanceData.%Id()
	 		//w AErrorMessage
	 		q AEInstanceData
		}
		
		s tmpLog = ..GetFinalLog(objInstanceData.%Id())
		if tmpLog '= ""
		{
			s AEMixInstanceLog.OperateDate = tmpLog.OperateDate
			s AEMixInstanceLog.OperateTime = tmpLog.OperateTime
			s AEMixInstanceLog.RealOperateUserID = AEMixInstanceLog.OperateUserID
			s AEMixInstanceLog.OperateUserName = tmpLog.OperateUserName
		}
	}
	
	
	//打散元数据
	s sc = ##class(EPRinstance.InstanceData).UpdateIndexByAutomaton(AEInstanceData)
 	if sc '= "1"
 	{
	 	s AErrorMessage = "Error-EPRservice.BOInstanceData.SaveData-004:"
	 	s AErrorMessage = AErrorMessage_"Failed in scattering data: InstanceDataID: "_objInstanceData.%Id()_sc
	 	//w AErrorMessage
	 	q AEInstanceData
	}	
 	
 	//保存自动生成的病案号，仅为 安徽省立医院
 	s Automake=##class(EPRmeta.SysOption).GetOptionValueByName("AutomakeCaseRecordNo")
 	if Automake="Y"
 	{
	    do ..SaveGeneratedCaseRecordNo(AEInstanceData.TemplateID,AEInstanceData.EpisodeID)
 	}
 	
 	//口腔专科病历映射
	s MappingToothData=##class(EPRmeta.SysOption).GetOptionValueByName("MappingToothData")
 	if (MappingToothData="Y")&&(isNewFramework)
 	{
		do ##Class(EPRservice.BLL.Dental.BLToothRecord).SetToothRecord(AEInstanceData.PatientID,AEInstanceData.EpisodeID, AEInstanceData.ID, AEInstanceData.TemplateID,AEMixInstanceLog.PrintTemplateDocID,AEInstanceData.ListNo,AEMixInstanceLog.OperateUserID)
	}
	
	//不良事件上报
	s MonitorAdverseEvent=##class(EPRmeta.SysOption).GetOptionValueByName("MonitorAdverseEvent")
 	if (MonitorAdverseEvent = "Y")&&(isNewFramework)
 	{
		do ##Class(EPRservice.AdverseEvent.BLMonitorMessage).Monitor(AEInstanceData.EpisodeID, AEMixInstanceLog.PrintTemplateDocID,AEInstanceData.ListNo,AEInstanceData.TemplateID,AEInstanceData.ID,AEMixInstanceLog.OperateUserID,"save")
	}

	//为质控推送保存操作信息
	s QCOperationInfo=##class(EPRmeta.SysOption).GetOptionValueByName("QCOperationInfo")
	if (isNewFramework)&&(QCOperationInfo="Y")
	{
		do ##Class(EPRservice.Quality.BLRecordModifyLog).RegLogEPR(AEInstanceData.EpisodeID,AEMixInstanceLog.PrintTemplateDocID,AEInstanceData.ListNo,"SAVE",AEMixInstanceLog.OperateUserID)
	}
	
 	//初始化返回值
 	s AEInstanceData.CreateUser = objInstanceData.CreateUser
	s AEInstanceData.ModifyUser = objInstanceData.ModifyUser
	s AEInstanceData.CreateDate = objInstanceData.CreateDate
	s AEInstanceData.CreateTime = objInstanceData.CreateTime
	s AEInstanceData.ModifyDate = objInstanceData.ModifyDate
	s AEInstanceData.ModifyTime = objInstanceData.ModifyTime
	s AEInstanceData.HappenDate = objInstanceData.HappenDate
	s AEInstanceData.HappenTime = objInstanceData.HappenTime
	s AEInstanceData.Status = objInstanceData.Status		
 	
 	Quit AEInstanceData
 	
OnErrorHandlerSaveData
	s AErrorMessage = "Error-EPRservice.BOInstanceData.SaveMultiData-100:"
	s AErrorMessage = AErrorMessage_"Error info: "_$ZError
	q AEInstanceData
}

/// ------------------------------------------------------------
/// Description: 保存可重复模板的实例数据，并打散元数据内容
/// Table	  : EPRinstance.InstanceData
/// 
/// ModifyDate: 2008-09-09
/// ModifyUser: houj
/// Purpose   : 重写类方法，改变实例数据的存储方法
/// 
/// ModifyDate: 2008-10-30
/// ModifyUser: houj
/// purpose   : 以 EInstanceData.ID 判断是否为新建病历
/// ------------------------------------------------------------
ClassMethod SaveMultipleData(AEInstanceData As EPRservice.entity.EInstanceData, ByRef AEMixInstanceLog As EPRservice.entity.EMixInstanceLog, ByRef AErrorMessage As %String) As EPRservice.entity.EInstanceData [ WebMethod ]
{
	//---debug begin
 	//S ^CacheTempDHCEPRDebug("EPRservice.BOInstanceData","SaveMultipleData","Status") = AEInstanceData.Status
 	//s ^CacheTempDHCEPRDebug("EPRservice.BOInstanceData","SaveMultipleData","ID") =  AEInstanceData.ID
 	//s ^CacheTempDHCEPRDebug("EPRservice.BOInstanceData","SaveMultipleData","ModifyDate") =  AEInstanceData.ModifyDate
 	//s ^CacheTempDHCEPRDebug("EPRservice.BOInstanceData","SaveMultipleData","ModifyTime") =  AEInstanceData.ModifyTime
 	//s ^CacheTempDHCEPRDebug("EPRservice.BOInstanceData","SaveMultipleData","HappenDate") =  AEInstanceData.HappenDate
 	//s ^CacheTempDHCEPRDebug("EPRservice.BOInstanceData","SaveMultipleData","HappenTime") =  AEInstanceData.HappenTime
 	//s len = 32000
 	//s ^CacheTempDHCEPRDebug("EPRservice.BOInstanceData","SaveMultipleData","InstanceData") =  AEInstanceData.InstanceData.Read(.len)	
 	//---debug end
 	
 	s transactionStatus = "0"
 	 
	s $zt = "OnErrorSaveMultiple"
 	
 	s AErrorMessage = ""
 	
 	//是否新框架
	if AEInstanceData.ChartItemID = +(AEInstanceData.ChartItemID)
	{	
		s isNewFramework = "0"
	}
	else
	{
		s isNewFramework = "1"
	}
	
	set now = $H
	set date = $P(now,",",1)
	set time = $P(now,",",2)
 	
 	//检查发生日期时间是否合法
 	set isDTValid = ..CheckHappenDateTimeValid(AEInstanceData.TheECRecord,AEInstanceData.ID,AEInstanceData.HappenDate,AEInstanceData.HappenTime)
 	if (isDTValid '= "1")
 	{
 		s AErrorMessage = "Error-EPRservice.BOInstanceData.SaveMultipleData-001:"
 		s AErrorMessage = AErrorMessage_"HappenDateTime is not valid : "_AEInstanceData.HappenDate_" "_AEInstanceData.HappenTime_" "_isDTValid
 		q AEInstanceData
 	}
 	
 	
 	//检查标题和备注是否有特殊字符
 	s AEInstanceData.Title = ##Class(EPRservice.Util.StringHelper).FilterSpecialChar(AEInstanceData.Title)
 	s AEInstanceData.Remark = ##Class(EPRservice.Util.StringHelper).FilterSpecialChar(AEInstanceData.Remark)
 	
 	//新建病历 
 	if (AEInstanceData.ID = "")
 	{	
	 	set objInstanceData =##class(EPRinstance.InstanceData).%New()
	 	if objInstanceData = ""
	 	{
		 	s AErrorMessage = "Error-EPRservice.BOInstanceData.SaveMultipleData-002:"
	 		s AErrorMessage = AErrorMessage_"Error occured in create new InstanceData"
	 		//w AErrorMessage
			q AEInstanceData
	 	}
	 	set objInstanceData.Title = AEInstanceData.Title
	 	set objInstanceData.Remark = AEInstanceData.Remark
	 	set objInstanceData.TemplateID = AEInstanceData.TemplateID
	 	set objInstanceData.TemplateVersion = AEInstanceData.TemplateVersion
	 	set objInstanceData.CreateDate = date
	 	set objInstanceData.CreateTime = time
	 	set objInstanceData.CreateUser = AEInstanceData.CreateUser
	 	set objInstanceData.ModifyDate = date
	 	set objInstanceData.ModifyTime = time
	 	//set objInstanceData.ModifyUser = AEInstanceData.ModifyUser
	 	set objInstanceData.ModifyUser = AEInstanceData.CreateUser		//新建病历时，创建者和修改者是同一个用户
	 	set objInstanceData.HappenDate = AEInstanceData.HappenDate
	 	set objInstanceData.HappenTime = AEInstanceData.HappenTime
		do objInstanceData.InstanceData.CopyFrom(AEInstanceData.InstanceData)
	 	
	 	//这里先更新status，设置为"Save",
	 	//对于旧框架来说，这个状态很重要
	 	//对于新框架来说这个状态只需要区分"UnSave"和"Save"即可
	 	set objInstanceData.Status = "Save"
		
		//更新实体数据的状态，供自动保存使用
	 	//因为自动保存不更新数据状态、不写日志，但新建病历比较特殊，必须更改其状态下次加载时才能获取到保存后的数据
	 	set AEInstanceData.Status = objInstanceData.Status
 	}
 	else
 	{
	 	//已有病历
	 	set objInstanceData = ##class(EPRinstance.InstanceData).%OpenId(AEInstanceData.ID) 
	 	if objInstanceData = ""
	 	{
		 	s AErrorMessage = "Error-EPRservice.BOInstanceData.SaveMultipleData-001:"
	 		s AErrorMessage = AErrorMessage_"InstanceData is not existed : "_AEInstanceData.ID
	 		//w AErrorMessage
			q AEInstanceData
	 	}
		s objInstanceData.Title = AEInstanceData.Title	
		s objInstanceData.Remark = AEInstanceData.Remark	
		s objInstanceData.TemplateID = AEInstanceData.TemplateID
		s objInstanceData.TemplateVersion = AEInstanceData.TemplateVersion
		//s objInstanceData.CreateDate = AEInstanceData.CreateDate	//此值不变
	 	//s objInstanceData.CreateTime = AEInstanceData.CreateTime  //此值不变
	 	//s objInstanceData.CreateUser = AEInstanceData.CreateUser  //此值不变
		s objInstanceData.ModifyDate = date
		s objInstanceData.ModifyTime = time
		s objInstanceData.ModifyUser = AEInstanceData.ModifyUser
		s objInstanceData.HappenDate = AEInstanceData.HappenDate
		s objInstanceData.HappenTime = AEInstanceData.HappenTime
		d objInstanceData.InstanceData.CopyFrom(AEInstanceData.InstanceData)
	 	
	 	//更新病历状态，新框架只需要区分UnSave和非UnSave状态
	 	if (isNewFramework)
	 	{	s:(objInstanceData.Status="UnSave") objInstanceData.Status = "Save"}
	 	else 
	 	{	s:(AEMixInstanceLog.FinalStatus'="") objInstanceData.Status = AEMixInstanceLog.FinalStatus}
	}
	
		
	s OBJECRecord = ##class(EPRinstance.ECRecord).%OpenId(AEInstanceData.TheECRecord)  
	if (OBJECRecord = "") 
	{
	 	s AErrorMessage = "Error-EPRserviece.BOInstanceData.SaveMultipleData-004:"
	 	s AErrorMessage = AErrorMessage_"ECRecord is not existed : "_AEInstanceData.TheECRecord
	 	//w AErrorMessage
		q AEInstanceData
	}
	 	
	//开启事务
	TSTART
	
	s transactionStatus = 1
	
	if (AEInstanceData.ID="")
	{
		//处理新建病历	
		Set objInstanceData.TheECRecord = OBJECRecord
		set OBJECRecord.InstanceCount = OBJECRecord.InstanceCount + 1
		set objInstanceData.ListNo = OBJECRecord.InstanceCount
		set AEInstanceData.ListNo = objInstanceData.ListNo
		 
		s sc = OBJECRecord.%Save()
	 	if $$$ISERR(sc)
		{
			TROLLBACK
			s transactionStatus = 3	
			s AErrorMessage = "Error-EPRserviece.BOInstanceData.SaveMultipleData-005:"
	 		s AErrorMessage = AErrorMessage_"Error occured in saving ECRecord, ECRecordID:"_AEInstanceData.TheECRecord_", ListNo:"_objInstanceData.ListNo
	 		//w AErrorMessage
			q AEInstanceData
		}  
		
		//更新ID，该ID是区分可重复病历是否保存过的标志
		set AEInstanceData.ID = objInstanceData.%Id()
	}
	else
	{
		s sc = objInstanceData.%Save()
	 	if $$$ISERR(sc)
		{
			TROLLBACK
			s transactionStatus = 3	
			s AErrorMessage = "Error-EPRserviece.BOInstanceData.SaveMultipleData-005:"
	 		s AErrorMessage = AErrorMessage_"Error occured in saving objInstanceData, InstanceData:"_AEInstanceData.ID
	 		//w AErrorMessage
			q AEInstanceData
		}  
	}
	
	
	//生成日志
	s AEMixInstanceLog.OperateDate = $zd(date,3)	//操作时间以服务器时间为准
	s AEMixInstanceLog.OperateTime = $zt(time,1)	//操作时间以服务器时间为准
	if isNewFramework
	{
		s action = AEMixInstanceLog.Action
		s episodeID = AEMixInstanceLog.EpisodeID
		s printDocID = AEMixInstanceLog.PrintTemplateDocID
		s eprNum = objInstanceData.ListNo
		//s templateDocID = AEMixInstanceLog.TemplateDocID	//此值不一定有用
		s happenDate = $zd(AEInstanceData.HappenDate,3)
		s happenTime = $zt(AEInstanceData.HappenTime,1)
		s machineIP = AEMixInstanceLog.OperateMachineIP
		s userID = AEMixInstanceLog.OperateUserID
		s templateID = AEInstanceData.TemplateID
		
		s sc = ..InitAfterMultiOper(action, episodeID, printDocID, eprNum, machineIP, happenDate, happenTime, userID, templateID)
		if (sc="")||(sc = "Error")
		{
			TROLLBACK
			s transactionStatus = 3	
			s AErrorMessage = "Error-EPRservice.BOInstanceData.SaveMultiData-006:"
	 		s AErrorMessage = AErrorMessage_"Failed in generate log:"_action_"^"_episodeID_"^"_printDocID_"^"_eprNum_"^"_templateID_"^"_happenDate_"^"_happenTime_"^"_machineIP_"^"_userID
	 		//w AErrorMessage
	 		q AEInstanceData
		}
		
		//"success^"_divStateServer_"^"_logID_"^"_currState
		//s AEMixInstanceLog.FinalStatus = $P(sc,"^",4)
		s AEMixInstanceLog.StateInfo = sc
	}
	else
	{
		s sc = ..AddInstanceLog(objInstanceData.%Id(), AEMixInstanceLog)
		if sc '= "1"
		{
			TROLLBACK
			s transactionStatus = 3	
			s AErrorMessage = "Error-EPRservice.BOInstanceData.SaveMultiData-007:"
	 		s AErrorMessage = AErrorMessage_"Failed in generate log: InstanceDataID: "_objInstanceData.%Id()
	 		//w AErrorMessage
	 		q AEInstanceData
		}
		
		s tmpLog = ..GetFinalLog(objInstanceData.%Id())
		if tmpLog '= ""
		{
			s AEMixInstanceLog.OperateDate = tmpLog.OperateDate
			s AEMixInstanceLog.OperateTime = tmpLog.OperateTime
			s AEMixInstanceLog.RealOperateUserID = AEMixInstanceLog.OperateUserID
			s AEMixInstanceLog.OperateUserName = tmpLog.OperateUserName
		}
	}
		
	//打散元数据
	s statusCode = ##class(EPRinstance.InstanceData).UpdateIndexByAutomaton(AEInstanceData)	
	if statusCode'="1"
	{	
			TROLLBACK
			s transactionStatus = 3		
			s AErrorMessage = "Error-EPRservice.BOInstanceData.SaveMultiData-008:"
	 		s AErrorMessage = AErrorMessage_"Error in data scattering !"_statusCode
	 		//w AErrorMessage
			q AEInstanceData
	}
	
	
	//提交事务
	TCOMMIT
	
	s transactionStatus = 2
	
	//口腔专科病历映射
	s MappingToothData=##class(EPRmeta.SysOption).GetOptionValueByName("MappingToothData")
 	if (MappingToothData="Y")&&(isNewFramework)
 	{
		do ##Class(EPRservice.BLL.Dental.BLToothRecord).SetToothRecord(AEInstanceData.PatientID,AEInstanceData.EpisodeID, AEInstanceData.ID, AEInstanceData.TemplateID,AEMixInstanceLog.PrintTemplateDocID,AEInstanceData.ListNo,AEMixInstanceLog.OperateUserID)
	}
	
	//为质控推送保存操作信息
	s QCOperationInfo=##class(EPRmeta.SysOption).GetOptionValueByName("QCOperationInfo")
	if (isNewFramework)&&(QCOperationInfo="Y")
	{
		do ##Class(EPRservice.Quality.BLRecordModifyLog).RegLogEPR(AEInstanceData.EpisodeID,AEMixInstanceLog.PrintTemplateDocID,AEInstanceData.ListNo,"SAVE",AEMixInstanceLog.OperateUserID)
	}
	
	//初始化返回值
 	//s AEInstanceData.CreateUser = objInstanceData.CreateUser
	//s AEInstanceData.ModifyUser = objInstanceData.ModifyUser
	s AEInstanceData.CreateDate = objInstanceData.CreateDate
	s AEInstanceData.CreateTime = objInstanceData.CreateTime
	s AEInstanceData.ModifyDate = objInstanceData.ModifyDate
	s AEInstanceData.ModifyTime = objInstanceData.ModifyTime
	s AEInstanceData.HappenDate = objInstanceData.HappenDate
	s AEInstanceData.HappenTime = objInstanceData.HappenTime
	s AEInstanceData.Status = objInstanceData.Status
	
	Quit AEInstanceData
	
OnErrorSaveMultiple
	if (transactionStatus = 1)
	{
		TROLLBACK		
	}
	s AErrorMessage = "Error-EPRservice.BOInstanceData.SaveMultiData-100:"
	s AErrorMessage = AErrorMessage_"Error info: "_$ZError
	//w AErrorMessage
	q AEInstanceData
}

/// Desc: 检查历次病历的发生日期时间的合法性
/// Creator: houj
/// Input:	AECRecord: ECRecord的ID，格式 20
/// 		AInstanceID: InstnaceData的ID，格式 20||2
/// 		AHappendDate: 发生时间，格式 Cache日期内部格式
/// 		AHappendTime: 发生时间，格式 Cache时间内部格式
/// Return: 1 合法，0 非法, -1 质控不允许提前书写病历
/// Debug: 	w ##class(EPRservice.BOInstanceData).CheckHappenDateTimeValid("20","20||2", "61727","65789")
/// 			w ##class(EPRservice.BOInstanceData).CheckHappenDateTimeValid("8","", "2016-9-8","12:10:13")
ClassMethod CheckHappenDateTimeValid(AECRecord As %String, AInstanceID As %String, AHappendDate As %String, AHappendTime As %String) As %String [ WebMethod ]
{
          
	s AInstanceID = $g(AInstanceID)
	
	q:(AECRecord="") "病历主索引不能为空"
	q:((AHappendDate="")||(AHappendTime="")) "病历日期时间不能为空"
	
	s:($f(AHappendDate,"-")>1) AHappendDate = $zdh(AHappendDate,3)
	s:($f(AHappendTime,":")>1) AHappendTime = $zth(AHappendTime,1)
	
	//质控不允许提前书写病历
	s WriteRecordInAdvance = ##class(EPRmeta.SysOption).GetOptionValueByName("WriteRecordInAdvance")
	if (WriteRecordInAdvance = "Y")&&(AHappenDate > $p($h,",",1))
	{
		q "不允许提前书写大于当前日期("_$zd($p($h,",",1),3)_")的病历!"
	}
	
	//保证日期时间唯一才合法
 	s sameTimeCount = 0, uniqueInstanceId = ""
 	s childSub = ""
 	for {
	 	s childSub = $O(^DHCEPRI.InstanceDataI("IdxECRecord", AECRecord, childSub))
	 	q:(childSub = "")
	 	
	 	s obj = ##Class(EPRinstance.InstanceData).%OpenId(AECRecord_"||"_childSub)
	 	continue:(obj = "")
	 	
	 	continue:(obj.HappenDate '= AHappendDate)||(obj.HappenTime '= AHappendTime)
	 	
	 	s sameTimeCount = sameTimeCount + 1
	 	s uniqueInstanceId = AECRecord_"||"_childSub
 	}
 			
	if sameTimeCount = 0
	{
		//没有发生日期时间相同的InstanceData，时间日期合法	
		q "1"
	}
	elseif (sameTimeCount=1)&&(AInstanceID'="")&&(uniqueInstanceId=AInstanceID)
	{
		//只有一份发生日期时间相同的InstanceData，且为自己，时间日期合法	
		q "1"
	}
	else
	{
		//其它情况非法
		q "病历日期时间不允许与已有其他病历重复"
	}
}

ClassMethod GetFinalLog(AInstanceID As %String) As EPRservice.entity.EInstanceLog [ WebMethod ]
{
	q:($d(AInstanceID)=0)||(AInstanceID="") ""
	s aInstance="",result="",aLog=""
	s aInstance=##class(EPRinstance.InstanceData).%OpenId(AInstanceID)
	s result=##class(EPRservice.entity.EInstanceLog).%New()
	q:(aInstance="") ""
	q:(result="") ""
	s aLog=aInstance.GetFinalLog()
	q:(aLog="") ""
	;s result.ID=aLog.%Id()
	s result.Action=aLog.Action
	s result.OperateDate=aLog.OperateDate
	s result.FinalStatus=aLog.FinalStatus
	s result.InitStatus=aLog.InitStatus
	s result.OperateTime=aLog.OperateTime
	s result.OperateUserID=aLog.OperateUserID
	s result.OperateMachineIP=aLog.OperateMachineIP
	s result.RealOperateUserID=aLog.RealOperateUserID
	s result.OperateUserName=aLog.OperateUserName		//<+added on 2010-08-02 by houj>
	q result
}

ClassMethod GetAllLogs(AInstanceID As %String) As %String [ WebMethod ]
{
	q:($d(AInstanceID)=0)||(AInstanceID="") ""
	s aInstance="",logs="",result=""
	s aInstance=##class(EPRinstance.InstanceData).%OpenId(AInstanceID)
	q:(aInstance="") ""
	s logs=aInstance.GetAllLogs()
	q:(logs="") ""
	
	s count=logs.Count()
	for i=1:1:count {
		s log=logs.GetAt(i)
		//<modified on 2010-08-02 by houj>
		//s result=result_log.OperateDate_" "_log.OperateTime_" 由用户"_log.OperateUserID_"在"_log.OperateMachineIP_log.Action_"，病历当前状态为"_log.FinalStatus_$c(10,10)
		s result=result_log.OperateDate_" "_log.OperateTime_" 由用户"_log.OperateUserName_"在"_log.OperateMachineIP_log.Action_"，病历当前状态为"_log.FinalStatus_$c(10,10)
	}
	q result
}

ClassMethod CheckFinalStatus(AInstanceID As %String, parStatusStr As %String) As %String [ WebMethod ]
{
	q:($d(AInstanceID)=0)||(AInstanceID="") "0"
	s aInstance="",aLog=""
	s aInstance=##class(EPRinstance.InstanceData).%OpenId(AInstanceID)
	q:(aInstance="") "0"
	s aLog=aInstance.GetFirstLogByFinalStatus(parStatusStr)
	q:(aLog'="") "1"
	q "0"
}

ClassMethod AddLog(parInstanceID As %String, parLog As EPRservice.entity.EInstanceLog) As %String [ WebMethod ]
{
	set objInstanceData = ""
  	set objInstanceData = ##class(EPRinstance.InstanceData).%OpenId(parInstanceID)
  	q:(objInstanceData ="") "0"
  
	set PItemlog =##class(EPRinstance.InstanceLog).%New()
	set PItemlog.Action= parLog.Action
	set PItemlog.OperateDate= parLog.OperateDate
	set PItemlog.FinalStatus= parLog.FinalStatus
	set PItemlog.InitStatus= parLog.InitStatus
	set PItemlog.OperateTime= parLog.OperateTime
	set PItemlog.OperateUserID= parLog.OperateUserID
	set PItemlog.OperateMachineIP=parLog.OperateMachineIP
	d objInstanceData.AddLog(PItemlog)
	
 	s status=objInstanceData.%Save()
 	
 	q:($$$ISOK(status)) "1"
 	q "0"
}

ClassMethod AddInstanceLog(parInstanceID As %String, parLog As EPRservice.entity.EMixInstanceLog) As %String [ WebMethod ]
{
	
	set objInstanceData = ""
  	set objInstanceData = ##class(EPRinstance.InstanceData).%OpenId(parInstanceID)
  	q:(objInstanceData ="") "0"
  
	set PItemlog =##class(EPRinstance.InstanceLog).%New()
	set PItemlog.Action= parLog.Action
	set PItemlog.FinalStatus= parLog.FinalStatus
	set PItemlog.InitStatus= parLog.InitStatus
	set PItemlog.OperateDate= parLog.OperateDate
	set PItemlog.OperateTime= parLog.OperateTime
	set PItemlog.OperateUserID= parLog.OperateUserID
	set PItemlog.OperateMachineIP=parLog.OperateMachineIP
	d objInstanceData.AddLog(PItemlog)
	
 	s status=objInstanceData.%Save()
 	
 	q:($$$ISOK(status)) "1"
 	q "0"
}

ClassMethod ClearLog(parInstanceID As %String) As %String [ WebMethod ]
{
	set objInstanceData = ""
  set objInstanceData = ##class(EPRinstance.InstanceData).%OpenId(parInstanceID)
  q:(objInstanceData ="") "0"
  
  d objInstanceData.ClearLog()
  s status=objInstanceData.%Save()
  q:($$$ISOK(status)) "1"
 	q "0"
}

ClassMethod ChangeStatus(parInstanceID As %String, parStatus As %String) As %String [ WebMethod ]
{
	set objInstanceData = ""
  set objInstanceData = ##class(EPRinstance.InstanceData).%OpenId(parInstanceID)
  q:(objInstanceData ="") "0"
  
  d objInstanceData.ChangeStatus(parStatus)
  s status=objInstanceData.%Save()
  q:($$$ISOK(status)) "1"
 	q "0"
}

ClassMethod GetCurrentStatus(parInstanceID As %String) As %String [ WebMethod ]
{
	set objInstanceData = ""
  	set objInstanceData = ##class(EPRinstance.InstanceData).%OpenId(parInstanceID)
  	q:(objInstanceData ="") ""
  
  	q objInstanceData.GetCurrentStatus()
}

/// CreateTime: 2009-09-14
/// Creator: Gaojb
/// Desc: 保存时生成唯一模板的日志并取得操作后病历状态，用于dll的保存后日志操作
ClassMethod InitAfterSingleOper(parAction As %String, parEpisodeID As %String, parEprDocID As %String, parEprNum As %String, parTemplateDocID As %String, parHappenDate As %String, parHappenTime As %String, parIP As %String, parUserID As %String, parTemplateID As %String) As %String [ WebMethod ]
{
	;s ^gjbtest("InitAfterSaveSingle")=parEpisodeID_"^"_parEprDocID_"^"_parEprNum_"^"_parTemplateDocID_"^"_parHappenDate_"^"_parHappenTime_"^"_"^"_parIP_"^"_parUserID
	q:(($d(parAction)=0)||(parAction="")||$d(parEpisodeID)=0)||(parEpisodeID="")||($d(parEprDocID)=0)||(parEprDocID="")||($d(parEprNum)=0)||(parEprNum="")||($d(parTemplateDocID)=0)||(parTemplateDocID="")||($d(parHappenDate)=0)||(parHappenDate="")||($d(parHappenTime)=0)||(parHappenTime="")||($d(parIP)=0)||(parIP="")||($d(parUserID)=0)||(parUserID="") ""
	q:($d(parTemplateID)=0) ""
	
	s ret = ##class(EPRinstance.EPRLogs).InitAfterSingleOper(parAction, parEpisodeID,parEprDocID,parEprNum,parTemplateDocID,
													   parHappenDate,parHappenTime,parIP,parUserID, parTemplateID)
	//不良事件上报
	//do ##class(EPRservice.AdverseEvent.BLMonitorMessage).Monitor(AEpisodeID, AEPRDocID, AEPRNum, ATemplateID, AInstanceDataID, AUserID, AAction)
 	s MonitorAdverseEvent=##class(EPRmeta.SysOption).GetOptionValueByName("MonitorAdverseEvent")
 	if (MonitorAdverseEvent = "Y")&&(parAction = "commit")
 	{
		do ##Class(EPRservice.AdverseEvent.BLMonitorMessage).Monitor(parEpisodeID, parEprDocID, parEprNum, parTemplateID,"",parUserID,"commit")
	}
	
	q ret
}

/// CreateTime: 2009-09-14
/// Creator: Gaojb
/// Desc: 保存时生成历次模板的日志并取得操作后病历状态，用于dll的保存后日志操作
ClassMethod InitAfterMultiOper(parAction As %String, parEpisodeID As %String, parEprDocID As %String, parEprNum As %String, parIP As %String, parHappenDate As %String, parHappenTime As %String, parUserID As %String, parTemplateID As %String) As %String [ WebMethod ]
{
	q:(($d(parAction)=0)||(parAction="")||$d(parEpisodeID)=0)||(parEpisodeID="")||($d(parEprDocID)=0)||(parEprDocID="")||($d(parEprNum)=0)||(parEprNum="")||($d(parHappenDate)=0)||(parHappenDate="")||($d(parHappenTime)=0)||(parHappenTime="")||($d(parIP)=0)||(parIP="")||($d(parUserID)=0)||(parUserID="") ""
	q:($d(parTemplateID)=0) ""
	
	q ##class(EPRinstance.EPRLogs).InitAfterMultiOper(parAction, parEpisodeID,parEprDocID,parEprNum,parIP,parHappenDate,parHappenTime,parUserID,parTemplateID)
}

ClassMethod UpdateEPRLogs(parEpisodeID As %String, parAllStr As %String, parAction As %String, parIP As %String, parUserID As %String) As %String [ WebMethod ]
{
  q:(($d(parEpisodeID)=0)||(parEpisodeID="")||$d(parAllStr)=0)||(parAllStr="")||($d(parAction)=0)||(parAction="")||($d(parIP)=0)||(parIP="")||($d(parUserID)=0)||(parUserID="") "0"
  
  q ##class(EPRinstance.EPRLogs).UpdateEPRLogs(parEpisodeID, parAllStr, parAction, parIP, parUserID)
}

/// CreateTime: 2009-02-07
/// CreateUser: HouJian	
/// Desc:		取病历数据(在报表查询结果中浏览病历使用)
/// Input:		aEpisodeId: 病人就诊Rowid
/// 			aTemplateId: 界面模板Id
/// 			aMountCategoryId: 挂载目录Id，即模板所属Normal或Group类型目录的Id
/// Output:		EPRservice.entity.EInstanceData
ClassMethod GetInstanceData(aEpisodeId As %String, aTemplateId As %String, aMountCategoryId As %String) As EPRservice.entity.EInstanceData [ WebMethod ]
{
	s objEInstanceData = ##class(EPRservice.entity.EInstanceData).%New()

	q:(($d(aEpisodeId)=0)||($d(aTemplateId)=0)||($d(aMountCategoryId)=0)) objEInstanceData
	q:((aEpisodeId="")||(aTemplateId="")||(aMountCategoryId="")) objEInstanceData
	
	// 取ECRecord
	s ecRecordId = ##class(EPRinstance.ECRecord).GetIDByEpisodeAndCategoryID(aEpisodeId, aMountCategoryId)
	q:(ecRecordId="") objEInstanceData
	
	// 遍历ECRecord下的所有病历，找到所需的病历
	s childSub = ""
	for {
		s childSub = $O(^DHCEPRI.InstanceDataI("IdxECRecord",ecRecordId,childSub))
		q:(childSub="")
		
		s instanceId = ecRecordId_"||"_childSub
		s objInstance = ##class(EPRinstance.InstanceData).%OpenId(instanceId)
		if (objInstance '= "")
		{
			// TemplateId相同为所需病历
			if (objInstance.Status '= "UnSave")&&(objInstance.TemplateID = aTemplateId)
			{
				//s objEInstanceData.MetaData  =  ##class(EPRmeta.TemplateVersion).GetMetaData(objInstance.TemplateID,objInstance.TemplateVersion)
 				//s objEInstanceData.PresentationData  =  ##class(EPRmeta.TemplateVersion).GetPresentationData(objInstance.TemplateID,objInstance.TemplateVersion)
 				d objEInstanceData.MetaData.CopyFrom(##class(EPRmeta.TemplateVersion).GetMetaData(objInstance.TemplateID,objInstance.TemplateVersion))
 				d objEInstanceData.PresentationData.CopyFrom(##class(EPRmeta.TemplateVersion).GetPresentationData(objInstance.TemplateID,objInstance.TemplateVersion))
 				d objEInstanceData.InstanceData.CopyFrom(objInstance.InstanceData)
 				q
			}
		}
	}
	
	q objEInstanceData
}

/// Desc:		取一个时间段内病历数据的Title、CreateDate、CreateTime、Creator等信息
/// 			[给医务管理组的接口]
/// CreateTime:	2009-03-25
/// Creator：	HouJian
/// Input:		aEpisodeId: 就诊RowId
/// 			aMountCategoryId: 挂载目录Id，即模板所属Normal或Group类型目录的Id
/// 			aType: 病历类型，Single唯一病历，Multi可重复病历
/// 			aStartDate：起始日期[Cache内部格式]
/// 			aEndDate: 截止日期[Cache内部格式]
/// 			aTitle：病历标题
/// Output:		模板ID $c(1) InstanceDataID $c(1) 标题 $c(1) 修改日期 $c(1) 修改时间 $c(1) 修改人 $c(1) 发生日期 $c(1) 发生时间
/// Debug:	d ##class(%ResultSet).RunQuery("EPRservice.BOInstanceData","GetMultiDataInfoByCateID","49","29","61608","43450","61608","43480","历次病程记录(通用)")		
Query GetMultiDataInfoByCateID(aEpisodeId As %String, aMountCategoryId As %String, aStartDate As %String, aStartTime As %String, aEndDate As %String, aEndTime As %String, aTitle As %String = "") As %Query(ROWSPEC = "MultiDataInfo")
{
}

ClassMethod GetMultiDataInfoByCateIDExecute(ByRef qHandle As %Binary, aEpisodeId As %String, aMountCategoryId As %String, aStartDate As %String, aStartTime As %String, aEndDate As %String, aEndTime As %String, aTitle As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	Set qHandle=$lb(0,repid,0)
	
	q:(($d(aEpisodeId)=0)||($d(aMountCategoryId)=0)||($d(aStartDate)=0)||($d(aEndDate)=0)||($d(aStartTime)=0)||($d(aEndTime)=0)) $$$OK
	q:((aEpisodeId="")||(aMountCategoryId="")) $$$OK
	
	//是否使用时间做筛选
	s isTimeFilterOK = "1"
	if (aStartDate="")||(aEndDate="")||(aStartTime="")||(aEndTime="")
	{	s isTimeFilterOK = "0"}
	
	// 取ECRecord
	s ecRecordId = ##class(EPRinstance.ECRecord).GetIDByEpisodeAndCategoryID(aEpisodeId, aMountCategoryId)
	q:(ecRecordId="") $$$OK
	
	//20120819 wangwentao add loop
	s ecRecordId = ""
	for {
		s ecRecordId  = $o(^DHCEPRI.ECRecordI("IdxEpisodeIDCategoryID"," "_aEpisodeId," "_aMountCategoryId,ecRecordId))
		q:(ecRecordId="")	
	
		// 遍历ECRecord下的所有病历，找到所需的病历
		s childSub = ""
		for {
			s childSub = $O(^DHCEPRI.InstanceDataI("IdxECRecord",ecRecordId,childSub))
			q:(childSub="")
			
			s instanceId = ecRecordId_"||"_childSub
			
			s objInstance = ##class(EPRinstance.InstanceData).%OpenId(instanceId)
			if (objInstance="") continue
			if (objInstance.Status="UnSave") continue
				
			if (isTimeFilterOK="1")
			{
				//使用时间做筛选条件
				//s isDateOK = (objInstance.HappenDate > aStartDate)&&(objInstance.HappenDate < aEndDate)
				//s isDateEqual = (objInstance.HappenDate = aStartDate)&&(objInstance.HappenDate = aEndDate)
				//s isTimeOK = (objInstance.HappenTime >= aStartTime)&&(objInstance.HappenTime <= aEndTime)
				//if '(isDateOK || (isDateEqual && isTimeOK))	continue
				s isDateTime1OK = (objInstance.HappenDate > aStartDate)||((objInstance.HappenDate = aStartDate)&&(objInstance.HappenTime >= aStartTime))
				s isDateTime2OK = (objInstance.HappenDate < aEndDate)||((objInstance.HappenDate = aEndDate)&&(objInstance.HappenTime <= aEndTime))
				if '(isDateTime1OK && isDateTime2OK) continue
			}
	
			
			if (aTitle '= "")
			{
				//使用标题做筛选条件
				//if (objInstance.Title '= aTitle) continue
				if '(objInstance.Title [ aTitle) continue
			}
			
			s templateId = objInstance.TemplateID
			s title = objInstance.Title
			s modifyUser = objInstance.ModifyUser
			s modifyDate = objInstance.ModifyDate
			s modifyTime = objInstance.ModifyTime
			s happenDate = objInstance.HappenDate
			s happenTime = objInstance.HappenTime
			
			d OutputRow()
		}
	
	}
	
	Quit $$$OK
	
	
OutputRow()
    // 模板ID $c(1) InstanceDataID $c(1) 标题 $c(1) 修改日期 $c(1) 修改时间 $c(1) 修改人 $c(1) 发生日期 $c(1) 发生时间
    set dataInfo = templateId_$c(1)_instanceId_$c(1)_title_$c(1)_modifyDate_$c(1)_modifyUser_$c(1)_modifyTime_$c(1)_happenDate_$c(1)_happenTime
	set ^CacheTemp(repid, ind) = $LB(dataInfo)
	set ind = ind + 1
}

ClassMethod GetMultiDataInfoByCateIDFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetMultiDataInfoByCateIDExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetMultiDataInfoByCateIDClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetMultiDataInfoByCateIDExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
	Quit $$$OK
}

/// Desc:		由实例数据的目录ID取其模板ID[给医务管理组的接口]
/// 			过程如下：
/// 			（1）判断病历是否保存过，若保存过，返回相关信息
/// 			（2）若未保存过，判断是否应该写该病历，若应该写，返回默认的模板ID，其余信息为空
/// 			（3）若不应该写此份病历，返回空值 			
/// CreateTime:	2009-05-21
/// Creator:	HouJian
/// Input:		aEpisodeID: 就诊RowId
/// 			aMountCategoryId: 挂载目录Id,即模板所属Normal或Group类型目录的Id
/// 			aCategoryId: 父目录Id,即模板直接所属目录Id，当模板为Normal类型时，它与挂载目录Id相同
/// Output:		模板ID $c(1) 创建日期 $c(1) 创建时间 $c(1) 创建人 $c(1) 修改日期 $c(1) 修改时间 $c(1) 修改人 $c(1) 病历状态
/// Debug:		w ##class(EPRservice.BOInstanceData).GetSingleDataInfoByCateID("49","36","37")
ClassMethod GetSingleDataInfoByCateID(aEpisodeId As %String, aMountCategoryId As %String, aCategoryId As %String) As %String
{
	q:(($d(aEpisodeId)=0)||($d(aMountCategoryId)=0)||($d(aCategoryId)=0)) ""
	q:((aEpisodeId="")||(aMountCategoryId="")||(aCategoryId="")) ""
	
	s retVal = ""
	s instanceStatus = ""
	
	// 取ECRecord
	s oldRecCount = ##class(EPRinstance.ECRecord).GetOldRecCount(aEpisodeId)
	if oldRecCount > 0
	{	
		//旧框架，使用 [挂载目录Id] 获取 [ECRecord]
		s ecRecordId = ##class(EPRinstance.ECRecord).GetIDByEpisodeAndCategoryID(aEpisodeId, aMountCategoryId)
	}
	else
	{	
		//新框架，使用 [父目录Id] 获取 [ECRecord]
		s ecRecordId = ##class(EPRinstance.ECRecord).GetIDByEpisodeAndCategoryID(aEpisodeId, aCategoryId)
	}
	
	
	// 判断病历是否保存过，若保存过，取其详细信息
	if (ecRecordId '= "")
	{
		// 遍历ECRecord下的所有病历，找到所需的病历
		s childSub = ""
		for {
			s childSub = $O(^DHCEPRI.InstanceDataI("IdxECRecord",ecRecordId,childSub))
			q:(childSub="")
			
			s instanceId = ecRecordId_"||"_childSub
			
			s objInstance = ##class(EPRinstance.InstanceData).%OpenId(instanceId)
			if (objInstance="") continue
			if (objInstance.Status="UnSave") continue
	
			if (objInstance.GroupItemID = aCategoryId)
			{
				s templateId = objInstance.TemplateID
				s createDate = objInstance.CreateDate
				s createTime = objInstance.CreateTime
				s createUser = objInstance.CreateUser
				s modifyDate = objInstance.ModifyDate
				s modifyTime = objInstance.ModifyTime
				s modifyUser = objInstance.ModifyUser
				s instanceStatus = objInstance.Status
				s retVal = templateId_$c(1)_createDate_$c(1)_createTime_$c(1)_createUser_$c(1)_modifyDate_$c(1)_modifyTime_$c(1)_modifyUser_$c(1)_instanceStatus
				//s retVal = templateId_"^"_createDate_"^"_createTime_"^"_createUser_"^"_modifyDate_"^"_modifyTime_"^"_modifyUser_"^"_instanceStatus
				quit
			}
		}
	}
	
	// 病历未保存过，判断是否应该写，应该写哪个模板
	if (instanceStatus="")||(instanceStatus="UnSave")
	{	
		/*
		if oldRecCount > 0
		{
			// 根据旧框架默认模板规则取要写的界面模板
			s tempId = ..GetDefaultTempInOldFrame(aEpisodeId, aCategoryId)
		}
		else
		{
			// 根据新框架默认模板规则取要写的界面模板
			s tempId = ..GetDefaultTempInNewFrame(aEpisodeId, aCategoryId)
		}
		*/
		// 根据旧框架默认模板规则取要写的界面模板
		s tempId = ..GetDefaultTempInOldFrame(aEpisodeId, aCategoryId)
		
		// 若应该写但无合适的模板，返回空值
		// 若应该写且有合适的模板，返回模板Id
		if tempId = ""
		{	s retVal = ""	}		
		else
		{	s retVal = tempId_$c(1)_""_$c(1)_""_$c(1)_""_$c(1)_""_$c(1)_""_$c(1)_""_$c(1)_""	}
	}
		
	q retVal
}

/// 根据旧框架默认模板规则取要写的界面模板
ClassMethod GetDefaultTempInOldFrame(aEpisodeID As %String, aCategoryID As %String) As %String
{
	s tempId = ""
	s tempInfo = ##class(EPRservice.TPrivLogic.PrivLogic).GetTempForView(aEpisodeId,"",aCategoryId) 
	s isUseTPriv=$P(tempInfo,"^",1)
	if isUseTPriv'="Y"
	{	
		//未开启模板权限，取第一个适用的模板ID
		s tempId = $o(^DHCEPRM.TemplateI("IndexCategoryId"," "_aCategoryId,0))
	}	
	else
	{	
		//已开启模板权限，取第一个满足模板权限的模板ID
		s tempId = $P(tempInfo,"^",2)
	}
	q tempId
}

/// 根据新框架默认模板规则取要写的界面模板
ClassMethod GetDefaultTempInNewFrame(aEpisodeID As %String, aCategoryID As %String) As %String
{
	s priActivity = ##class(EPRservice.DocRestLogic.PrivLogic).CheckTPrivActivity()
	s curPatInfo = ##class(EPRservice.DocRestLogic.PrivLogic).GetPatInfo(aEpisodeID)
	
	s curTemplateID = ""
	
	s eprCategoryID = ""
	for {
		s eprCategoryID = $O(^DHCEPRM.EPRTemplateI("IdxBindTemplateCategoryID"," "_aCategoryID,eprCategoryID))
		q:(eprCategoryID="")
		
		if $zcvt(priActivity,"U") '= "Y"
		{
			//未开启默认模板控制，取第一个界面模板
			s templateDocID = $O(^DHCEPRM.EPRTemplateI("IdxBindTemplateCategoryID"," "_aCategoryID,eprCategoryID,""))
			s curTemplateID = $$GetTemplateID(templateDocID)
			q	
		}
		
		s cateID = $e(eprCategoryID, "2", $L(eprCategoryID))
		s canAct = ##class(EPRservice.DocRestLogic.TempActLogic).CanTempAct(cateID, "READ", curPatInfo)
		if canAct = "1"
		{
			//b "s"
			//开启了默认模板控制，取满足默认控制条件的界面模板
			s templateDocID = $O(^DHCEPRM.EPRTemplateI("IdxBindTemplateCategoryID"," "_aCategoryID,eprCategoryID,""))
			s curTemplateID = $$GetTemplateID(templateDocID)
			q	
		}
	}
	
	q curTemplateID
	
GetTemplateID(templateDocID)
	//取TemplateID
	q:(templateDocID="") ""
	s obj = ##class(EPRmeta.EPRTemplate).%OpenId(templateDocID)
	q:(obj="") ""
	q obj.BindTemplateID
}

ClassMethod GetTemplateIDByID(argInstanceId As %String) As %String [ WebMethod ]
{
	q:(argInstanceId="") ""
	q ##class(EPRinstance.InstanceData).GetTemplateIDByID(argInstanceId)
}

/// Desc	 : 保存自动生成的病案号
/// Input	 ：实例数据对应的TemplateID和EpisodeID
/// Creator	 : houjian@dhcc.com.cn
/// CreateTime: 2008-09-09
/// Others	 ：仅为 安徽省立医院
ClassMethod SaveGeneratedCaseRecordNo(aTemplateID As %String, aEpisodeID As %String)
{
 	//取病案室专用二的参数
 	s paraRecRoom=""
 	&sql(select OptionValue into :paraRecRoom
	 	from EPRmeta.SysOption where Name='ParaRecordRoom2')
 	quit:(paraRecRoom="")
 	
 	set templateId=$p(paraRecRoom,"^",1)            ///id of "病案室专用二"
 	//当前实例数据对应的界面模板为病案室专用二模板
 	if aTemplateID = templateId 
 	{
	 	s itemCodeDisDeptBA=$p(paraRecRoom,"^",2)   ///simple item code of "病案室出院科室" （病案室专用二）
	 	s itemCodeDisYear=$p(paraRecRoom,"^",3)     ///simple item code of "病案室出院年份" （病案室专用二）
	 	s itemCodeDiagICDCode=$p(paraRecRoom,"^",4) ///simple item code of "病案室主诊断ICD码" （病案室专用二）
	 	s itemCodeDiseaseNo=$p(paraRecRoom,"^",5)   ///simple item code of "病案室疾病顺序号" （病案室专用二）
	 	do ##class(EPRinstance.CaseRecordNo).CaseRecordNoService(aEpisodeID,templateId,itemCodeDisDeptBA,itemCodeDisYear,itemCodeDiagICDCode,itemCodeDiseaseNo) 
 	}
 	
 	quit
}

/// CreateTime: 2009-02-07
/// CreateUser: ChenWenJun
/// Desc:		根据病历结构的节点取出界面模板的Category、Template、ChartItem信息，新旧版兼容也在该函数内处理
/// Input:		aEpisodeId: 病人就诊Rowid
/// 			aEPRTemplateDocID: 绑定界面模板节点DocID
/// 			aIsNew: 是否是新建操作(1--是 0--否 2--均有可能),依据其判断是否需要进行兼容处理
/// Return:		EPRservice.entity.ETAndCFromEPRTempate
ClassMethod GetTAndCFromEPRTemplate(aEpisodeID As %String, aEPRTemplateDocID As %String, aIsNew As %String) As EPRservice.entity.ETAndCFromEPRTempate
{
	s objResult = ##class(EPRservice.entity.ETAndCFromEPRTempate).%New()
	q:(aEPRTemplateDocID="") objResult
	
	s objTemplateDoc = ##class(EPRmeta.EPRTemplate).%OpenId(aEPRTemplateDocID)
	q:(objTemplateDoc="") objResult
	s bindTemplateID = objTemplateDoc.BindTemplateID
	s bindTemplateCategoryID = objTemplateDoc.BindTemplateCategoryID
	s templateDocName = objTemplateDoc.EPRTemplateName
	s prtDocID = objTemplateDoc.EPRCategoryID
	d objTemplateDoc.%Close()
	k objTemplateDoc

	s objPrtDoc = ##class(EPRmeta.EPRTemplateCategory).%OpenId(prtDocID)
	q:(objPrtDoc="") objResult
	s prtDocName = objPrtDoc.CategoryName
	s chapterDocId = objPrtDoc.ParentCategoryID
	d objPrtDoc.%Close()
	k objPrtDoc
	
	s objChapterDoc = ##class(EPRmeta.EPRTemplateCategory).%OpenId(chapterDocId)
	q:(objChapterDoc="") objResult
	s chapterDocName = objChapterDoc.CategoryName
	d objChapterDoc.%Close()
	k objChapterDoc
	
	q:(bindTemplateCategoryID="") objResult
	s objTemplate = ##class(EPRmeta.Template).%OpenId(bindTemplateID)
	q:(objTemplate="") objResult
	s chartItemType = objTemplate.ChartItemType
	s templateName = objTemplate.Name
	d objTemplate.%Close()
	k objTemplate

	q:(bindTemplateCategoryID="") objResult
	s objCategory = ##class(EPRmeta.TemplateCategory).%OpenId(bindTemplateCategoryID)
	q:(objCategory="") objResult
	s categoryType = objCategory.CategoryType
	s categoryName = objCategory.Name
	d objCategory.%Close()
	k objCategory
	
	s objResult.TemplateID = bindTemplateID
	s objResult.CategoryID = bindTemplateCategoryID
	s objResult.CategoryType = categoryType
	if (chartItemType = "Single")
	{
		s objResult.ChartItemID = "CG"_bindTemplateCategoryID	//如果是唯一模板，那么ECRecord的ChartItemID需采用 ”CG + 界面模板的界面模板TemplateID“
	}
	elseif (chartItemType = "Multiple")
	{
		s objResult.ChartItemID = "ML"_prtDocID	//如果是可重复模板，那么ECRecord的ChartItemID需采用 ”ML + 打印模板DocID“
	}
	s objResult.ChartItemType = chartItemType
	s objResult.TemplateName = templateName
	s objResult.CategoryName = categoryName
	s objResult.EPRTemplateName = templateDocName
	s objResult.EPRCategoryName = chapterDocName

	q objResult
}

/// CreateTime: 2009-04-29
/// CreateUser: ChenWenJun
/// Desc:		取出某个Instance的数据(用于新框架)
/// Input:		AID:InstanceData的ID
/// Output:		EPRservice.entity.EInstanceData
ClassMethod GetItemDataByID(AID As %String) As EPRservice.entity.EInstanceData
{
 set objInstanceData = ##class(EPRinstance.InstanceData).%OpenId(AID) 
 if (objInstanceData= "")
 {
	Quit "" 
 }
 s Result =##class(EPRservice.entity.EInstanceData).%New()
 if (Result="")
 {
	Quit ""
 }
 
 if (objInstanceData.TemplateID '="")  
 {
 	s Result.TemplateVersion = objInstanceData.TemplateVersion
	
	//modified on 2010-07-17 by houj
 	//s Result.MetaData  =  ##class(EPRmeta.TemplateVersion).GetMetaData(objInstanceData.TemplateID,objInstanceData.TemplateVersion)
 	//s Result.PresentationData  =  ##class(EPRmeta.TemplateVersion).GetPresentationData(objInstanceData.TemplateID,objInstanceData.TemplateVersion)
	d Result.MetaData.CopyFrom(##class(EPRmeta.TemplateVersion).GetMetaData(objInstanceData.TemplateID,objInstanceData.TemplateVersion))
 	d Result.PresentationData.CopyFrom(##class(EPRmeta.TemplateVersion).GetPresentationData(objInstanceData.TemplateID,objInstanceData.TemplateVersion))
	
	   
 	if (objInstanceData.Status="")||(objInstanceData.Status ="UnSave") 
 	{
 		do Result.InstanceData.CopyFrom(##class(EPRmeta.TemplateVersion).GetInitialData(objInstanceData.TemplateID,objInstanceData.TemplateVersion)) 
 	}
 	Else
 	{
	 	d Result.InstanceData.CopyFrom(objInstanceData.InstanceData)
	}
	/*
	s instanceDataFirstChar = objInstanceData.InstanceData.Read(1)
	if ((instanceDataFirstChar = "") || (instanceDataFirstChar = $c(0)))
	{
		do Result.InstanceData.CopyFrom(##class(EPRmeta.TemplateVersion).GetInitialData(objInstanceData.TemplateID,objInstanceData.TemplateVersion)) 
	}
	else
	{
		s Result.InstanceData = objInstanceData.InstanceData
	}
	*/
	
 	s Result.Title = objInstanceData.Title 
 	s Result.ID = AID
 	s Result.Status = objInstanceData.Status

 	s Result.HappenDate = objInstanceData.HappenDate 
 	s Result.HappenTime = objInstanceData.HappenTime 
 	s Result.ListNo = objInstanceData.ListNo 


 	s Result.CreateDate = objInstanceData.CreateDate 
 	s Result.CreateTime = objInstanceData.CreateTime 
	s Result.CreateUser = objInstanceData.CreateUser 


 	s Result.GroupItemID = objInstanceData.GroupItemID 
 	s Result.GroupItemName = objInstanceData.GroupItemName 

 	s Result.TemplateID = objInstanceData.TemplateID 
 	s Result.TemplateVersion = objInstanceData.TemplateVersion 
 	s Result.ModifyTime = objInstanceData.ModifyTime 
 	s Result.ModifyUser = objInstanceData.ModifyUser 


 	s Result.ChartItemID = objInstanceData.TheECRecord.ChartItemID
 	s Result.EpisodeID = objInstanceData.TheECRecord.EpisodeID 
 	s Result.PatientID = objInstanceData.TheECRecord.PatientID 
	s Result.TheECRecord = objInstanceData.TheECRecord.%Id()
 	s Result.ChartItemType = objInstanceData.TheECRecord.ChartItemType
 	s Result.CategoryID = objInstanceData.TheECRecord.CategoryID 
 	s Result.CategoryType = objInstanceData.TheECRecord.CategoryType 


 	Quit Result	 
	 
 }
 else
 {
	q ""	 
 }
}

/// CreateTime: 2009-04-29
/// CreateUser: ChenWenJun
/// Desc:		取出某个绑定界面节点的数据(用于新框架的唯一模板)
/// Input:		APatientID:APatientID
/// 			AEpisodeID:就诊号
/// 			AEpisodeType：就诊类型（住院、门诊等）
/// 			AChartItemID:TrakCare的横排子项ID
/// 			ACategoryType：电子病历界面模板类型（普通、直接、分组、分组子项）
/// 			ACategoryID: 电子病历界面模板的目录ID
/// 			ATemplateID: 界面模板ID
/// Output:		EPRservice.entity.EInstanceData
ClassMethod GetItemECRecordData(APatientID As %String, AEpisodeID As %String, AEpisodeType As %String, AChartItemID As %String, ACategoryType As %String, ACategoryID As %String, ATemplateID As %String) As EPRservice.entity.EInstanceData
{
	//b "s"
 s newFWChartItemID = "CG"_ATemplateID
 s chartItemID = AChartItemID	
 s TempObjID = ""
 
 //先查看是否有老框架数据
 Set CheckInstanceExist = ##class(EPRinstance.ECRecord).CheckInstanceExist(APatientID,AEpisodeID,chartItemID)
 //如果没有老框架数据，则判断新框架是否已保存(老框架保存的数据优先)
 if (CheckInstanceExist = 0)  
 {
	 s chartItemID = newFWChartItemID
	 Set CheckInstanceExist = ##class(EPRinstance.ECRecord).CheckInstanceExist(APatientID,AEpisodeID,chartItemID)
 }
 
 //如果存在数据（不管是数或老框架数据，），则取出
 if (CheckInstanceExist'=0)
 {
 	Set AECRecordID = ##class(EPRinstance.ECRecord).GetECRecordID(APatientID,AEpisodeID,chartItemID)
 
    if AECRecordID =""
	{ 
	   q ""
	}
	s OBJECRecord = ##class(EPRinstance.ECRecord).%OpenId(AECRecordID) 
	
	S isAvalid = 0
	s instanceCount=OBJECRecord.Instances.Count()
	for i=1:1:instanceCount {
		//b "s"
	  s objInstanceData = ""
	  S objInstanceData = OBJECRecord.Instances.GetAt(i)

	  //此处分开两种条件处理，主要是为了兼容老框架数据（采用这种写法新框架也可兼容）
	  if ((ACategoryType = "Normal") && (objInstanceData '= ""))
	  {
		 //在老框架如果是Normal数据，那么ECRecord下只有一个Instance,则可以直接取出
		 S isAvalid = 1
	  }
	  elseif ((ACategoryType = "GroupItem") && (objInstanceData '= ""))
	  {
		  //在老框架如果是Group数据，那么ECRecord下有多个Instance,此时需要根据GroupItem的CategoryID来作为依据取出数据
		  if (objInstanceData.GroupItemID = ACategoryID)
		  {
			 S isAvalid = 1 
		  }
	  }

	  if (isAvalid = 1)
	  { 
	  	if ((objInstanceData.GroupItemID = "") && (ACategoryID '=""))
	  	{
	  		s objInstanceData.GroupItemID = ACategoryID
	  		d objInstanceData.%Save()
	  	}

	  	s TempObjID = objInstanceData.%Id()
	  }
	  
	  q:(isAvalid = 1)
	  
	  if (objInstanceData '= "")
	  {
		  d objInstanceData.%Close()
		  k objInstanceData
	  }
	}
	
	if (OBJECRecord '= "")
	{
		d OBJECRecord.%Close()
		k OBJECRecord
	}
 }
 Elseif (CheckInstanceExist=0)
 {
 	S OBJECRecord = ##class(EPRinstance.ECRecord).%New()  
	if (OBJECRecord '="")   
 	{
	 	s objTemplate = ##class(EPRmeta.Template).%OpenId(ATemplateID)
	 	s templateTitle = "",templateVersion="",chartItemType=""
	  	if (objTemplate'= "")
	  	{
		  	s templateTitle = objTemplate.Name 
		  	s templateVersion = objTemplate.PublishVersion
		  	s chartItemType = objTemplate.ChartItemType
		 
		 	d objTemplate.%Close()
			k objTemplate
	  	}
	 	
		s OBJECRecord.PatientID= APatientID
		s OBJECRecord.EpisodeID= AEpisodeID
		s OBJECRecord.EpisodeType= AEpisodeType
		s OBJECRecord.CategoryType= ACategoryType
		s OBJECRecord.CategoryID= ACategoryID
		s OBJECRecord.ChartItemID= newFWChartItemID //AChartItemID  如果是新框架新创建的数据，那么ECRecord的ChartItemID均采用"CG" + TemplateID
		s OBJECRecord.ChartItemType= chartItemType
		s OBJECRecord.InstanceCount = 1
	
		s objInstanceData = ##class(EPRinstance.InstanceData).%New()
		s objInstanceData.GroupItemID = ACategoryID
		s objInstanceData.GroupItemName = ""
		S objInstanceData.TheECRecord = OBJECRecord
		s objInstanceData.Status ="UnSave"
		s objInstanceData.ListNo = 1
		
		s objInstanceData.TemplateID = ATemplateID
		s objInstanceData.Title = templateTitle
		s objInstanceData.TemplateVersion = templateVersion

		d OBJECRecord.%Save()

		S TempObjID = objInstanceData.%Id()
		
		if (objInstanceData '= "")
		{
			d objInstanceData.%Close()
			k objInstanceData
		}
		
		if (OBJECRecord '= "")
		{
			d OBJECRecord.%Close()
			k OBJECRecord
		}
	}
	else
	{
		q ""
	}
 }
 
 //根据InstancesId返回EInstanceData
 if (TempObjID '="")
 {
   q ..GetItemDataByID(TempObjID)
 }
 else
 {
 	q ""
 }
}

/// Desc: 转换可重复病历顺序号，有两种方式：
/// 
/// 		 1 将系统顺序号转换为发生日期时间顺序号
/// 			比如实例数据15||4，其对应ECRecordID为15，其默认子表subID为4，即它的系统顺序号为4，
/// 			但按照发生日期时间排序它可能是第3条，即它的发生日期时间顺序号为3
/// 			此时入参为:15,4,1	返回值为:3
/// 			
/// 		 2 将发生日期时间顺序号转换为系统顺序号
/// 		 	比如要查找某实例数据，其对应ECRecordID为15，按照发生日期时间排序它是第3条，即它的发生日期时间顺序号为3，
/// 		 	但在Cache系统中它的默认子表subID为4，即它的系统顺序号为4
/// 			此时入参为:15,3,2	返回值为:4
/// 
/// Input: 	argECRecordID: ECRecord表的rowid
/// 			argNum: 系统顺序号 或 发生日期时间顺序号
/// 			argType: 1 将系统顺序号转换为发生日期时间顺序号
/// 					 2 将发生日期时间顺序号转换为系统顺序号
/// 		
/// Return:	转换后的系统顺序号 或 发生日期时间顺序号
ClassMethod ConvertListNo(argECRecordID As %String, argNum As %String, argType As %String) As %String
{
	s repid = $I(^CacheTemp) 

	//将历次病历的InstanceData按发生日期时间排序	
	s childSub = "0"
	for {
		s childSub = $O(^DHCEPRI.InstanceDataI("IdxECRecord",argECRecordID,childSub))
		q:(childSub="")
		
		s instanceid = argECRecordID_"||"_childSub
		s objInstance = ##class(EPRinstance.InstanceData).%OpenId(instanceid)
		if objInstance '= ""
		{
			if (objInstance.HappenDate = "")
			{	s date = $p($H,",",1)}
			else 
			{	s date = objInstance.HappenDate}
			if (objInstance.HappenTime = "")
			{	s time = $p($H,",",2)}
			else
			{	s time = objInstance.HappenTime}
			s ^CacheTemp(repid, date, time) = instanceid
		}
	}
	
	s repidSort = $I(^CacheTemp) 
	s date =""
	s dateSeqCount = 0
	for {
		s date = $O(^CacheTemp(repid,date))
		q:(date="")
		
		
		s time = ""
		for {
			s time = $O(^CacheTemp(repid,date,time))
			q:(time="")
			
			s dateSeqCount = dateSeqCount + 1
			s ^CacheTemp(repidSort, "DateSeqToInstSeq",dateSeqCount) = $g(^CacheTemp(repid,date,time))
			s ^CacheTemp(repidSort, "InstSeqToDateSeq",$g(^CacheTemp(repid,date,time)))=dateSeqCount
		}
	}
	
	s retSeq = ""
	if argType = "1"
	{	
		s retSeq = $g(^CacheTemp(repidSort, "InstSeqToDateSeq",argECRecordID_"||"_argNum))
	}
	elseif argType = "2"
	{	
		s retSeq = $g(^CacheTemp(repidSort, "DateSeqToInstSeq",argNum))
		s retSeq = $p(retSeq,"||",2)
	}
	
	kill ^CacheTemp(repid)
	kill ^CacheTemp(repidSort)
	
	q retSeq
}

/// Desc: 判断唯一界面模板是否保存过
/// Input: 	EpisodeId 就诊rowid
/// 		TemplateId 界面模板id
/// CreateUser: zhuj 
/// CreateTime: 2009-12-15
ClassMethod IsSaveSingle(EpisodeId As %String, TemplateId As %String) As %String
{
	s ECRecordID = ""
	s ChartItemID = "CG"_TemplateId
	&sql(select ID into:ECRecordID from EPRinstance.ECRecord where EpisodeID = :EpisodeId and ChartItemID = :ChartItemID)
	if (ECRecordID = "")
	{
		q "0"	
	}
	
	s status = ""
	&sql(select Status into:status from EPRinstance.InstanceData where TheECRecord = :ECRecordID and TemplateID = :TemplateId)
	if ((status = "") || (status = "UnSave"))
	{
		q "0"	
	}
	q "1"
}

ClassMethod ImportInstanceData(aEInstanceData As EPRservice.entity.EInstanceData) As %String [ WebMethod ]
{
	q:(aEInstanceData="") "0"
	q:(aEInstanceData.ID) "0"
	
	s objInstance = ##class(EPRinstance.InstanceData).%OpenId(aEInstanceData.ID)
	q:(objInstance="") "0"
	
	d objInstance.InstanceData.CopyFrom(aEInstanceData.InstanceData)
	if $$$ISOK(objInstance.%Save())
	{	Q "1"}
	else
	{	q "0"}
}

ClassMethod GetDataByInstanceID(AInstanceDataID As %String) As EPRservice.entity.ReStreamData [ WebMethod ]
{
	q:(AInstanceDataID = "") ""
	
	s objInstance = ##Class(EPRinstance.InstanceData).%OpenId(AInstanceDataID)
	q:(objInstance = "") ""
	
	s reStream = ##Class(EPRservice.entity.ReStreamData).%New()
	d reStream.StreamData.CopyFrom(objInstance.InstanceData)
	
	q reStream
}

/// Author:	Kumon Xie
/// Date:	2011-05-27
/// Desc:	根据就诊号和界面模板号获取唯一模板实例数据RowID,如果没有则返回空
/// Input:	AEpisodeID为就诊号;
/// 		ATemplateID为唯一模板RowID;
/// Output:	实例数据RowID
/// Debug:	w ##Class(EPRservice.BOInstanceData).GetRefInstanceID(201764,822)
ClassMethod GetRefInstanceID(AEpisodeID As %String, ATemplateID As %String) As %String [ WebMethod ]
{
	s ret = ""
	q:($g(AEpisodeID) = "")||($g(ATemplateID) = "") ret
	
	s ecrecordID = $o(^DHCEPRI.ECRecordI("IdxEpisodeIDChartItemID"," "_AEpisodeID," CG"_ATemplateID,""))
	q:(ecrecordID = "") ret
	
	s childSub = $o(^DHCEPRI.InstanceDataI("IdxEcRecordAndListNo",ecrecordID," 1",""))
	q:(childSub = "") ret
	
	s ret = ecrecordID_"||"_childSub
	q ret
}

/// Desc:		取一个时间段内病历数据的Title、CreateDate、CreateTime、Creator等信息
/// CreateTime:	2013-02-19
/// Creator：	Candyxu
/// Input:		aEpisodeId: 就诊RowId
/// 			aMountCategoryId: 挂载目录Id，即模板所属Normal或Group类型目录的Id
/// 			aType: 病历类型，Single唯一病历，Multi可重复病历
/// 			aStartDate：起始日期[Cache内部格式]
/// 			aEndDate: 截止日期[Cache内部格式]
/// 			aTitle：病历标题
///             aDateTimeFlag:按时间取数据（创建时间 C  发生时间 H  修改时间 M）
/// Output:		模板ID $c(1) InstanceDataID $c(1) 标题 $c(1)创建日期 $c(1)创建时间$c(1)修改日期 $c(1) 修改时间 $c(1) 修改人 $c(1) 发生日期 $c(1) 发生时间
/// Debug:	d ##class(%ResultSet).RunQuery("EPRservice.BOInstanceData","GetMultiDataByTimeFlag","35","55","62860","41909","62870","62082","日常病程记录","C")		
Query GetMultiDataByTimeFlag(aEpisodeId As %String, aMountCategoryId As %String, aStartDate As %String, aStartTime As %String, aEndDate As %String, aEndTime As %String, aTitle As %String = "", aDateTimeFlag As %String) As %Query(ROWSPEC = "MultiDataInfo")
{
}

ClassMethod GetMultiDataByTimeFlagExecute(ByRef qHandle As %Binary, aEpisodeId As %String, aMountCategoryId As %String, aStartDate As %String, aStartTime As %String, aEndDate As %String, aEndTime As %String, aTitle As %String = "", aDateTimeFlag As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	Set qHandle=$lb(0,repid,0)
	
	q:(($d(aEpisodeId)=0)||($d(aMountCategoryId)=0)||($d(aStartDate)=0)||($d(aEndDate)=0)||($d(aStartTime)=0)||($d(aEndTime)=0)) $$$OK
	q:((aEpisodeId="")||(aMountCategoryId="")) $$$OK
	
	//是否使用时间做筛选
	s isTimeFilterOK = "1"
	if (aStartDate="")||(aEndDate="")||(aStartTime="")||(aEndTime="")
	{	s isTimeFilterOK = "0"}
	
	// 取ECRecord
	s ecRecordId = ##class(EPRinstance.ECRecord).GetIDByEpisodeAndCategoryID(aEpisodeId, aMountCategoryId)
	q:(ecRecordId="") $$$OK
	s ecRecordId = ""
	for {
		s ecRecordId  = $o(^DHCEPRI.ECRecordI("IdxEpisodeIDCategoryID"," "_aEpisodeId," "_aMountCategoryId,ecRecordId))
		q:(ecRecordId="")	
	
		// 遍历ECRecord下的所有病历，找到所需的病历
		s childSub = ""
		for {
			s childSub = $O(^DHCEPRI.InstanceDataI("IdxECRecord",ecRecordId,childSub))
			q:(childSub="")
			
			s instanceId = ecRecordId_"||"_childSub
			
			s objInstance = ##class(EPRinstance.InstanceData).%OpenId(instanceId)
			if (objInstance="") continue
			if (objInstance.Status="UnSave") continue
				
			if (isTimeFilterOK="1")
			{
				s isDateTime1OK = 0,isDateTime2OK = 0
                if ($zcvt(aDateTimeFlag,"U") = "H")
                {
				    s isDateTime1OK = (objInstance.HappenDate > aStartDate)||((objInstance.HappenDate = aStartDate)&&(objInstance.HappenTime < aStartTime))
				    s isDateTime2OK = (objInstance.HappenDate < aEndDate)||((objInstance.HappenDate = aEndDate)&&(objInstance.HappenTime > aEndTime))
				}elseif ($zcvt(aDateTimeFlag,"U") = "C")
                {
				    s isDateTime1OK = (objInstance.CreateDate > aStartDate)||((objInstance.CreateDate = aStartDate)&&(objInstance.CreateTime < aStartTime))
				    s isDateTime2OK = (objInstance.CreateDate < aEndDate)||((objInstance.CreateDate = aEndDate)&&(objInstance.CreateTime > aEndTime))
                }
                if '(isDateTime1OK && isDateTime2OK) continue
			}
	
			
			if (aTitle '= "")
			{
				//使用标题做筛选条件
				if '(objInstance.Title [ aTitle) continue
			}
			
			s templateId = objInstance.TemplateID
			s title = objInstance.Title
			s createDate = objInstance.CreateDate
			s createTime = objInstance.CreateTime
			s modifyUser = objInstance.ModifyUser
			s modifyDate = objInstance.ModifyDate
			s modifyTime = objInstance.ModifyTime
			s happenDate = objInstance.HappenDate
			s happenTime = objInstance.HappenTime
			
			d OutputRow()
		}
	}
	
	Quit $$$OK
	
OutputRow()
    // 模板ID $c(1) InstanceDataID $c(1) 标题 $c(1) 修改日期 $c(1) 修改时间 $c(1) 修改人 $c(1) 发生日期 $c(1) 发生时间
    set dataInfo = templateId_$c(1)_instanceId_$c(1)_title_$c(1)_createDate_$c(1)_createTime_$c(1)_modifyDate_$c(1)_modifyUser_$c(1)_modifyTime_$c(1)_happenDate_$c(1)_happenTime
	set ^CacheTemp(repid, ind) = $LB(dataInfo)
	set ind = ind + 1
}

ClassMethod GetMultiDataByTimeFlagFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetMultiDataByTimeFlagExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetMultiDataByTimeFlagClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetMultiDataByTimeFlagExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
	Quit $$$OK
}

/// Desc:	病历预览图片是否应该生成, 如上需求所述，非为两种情况，默认为第一种：
///    		配置1：打印模板下有一个界面模板保存，则生成病历浏览图片
///    		配置2：打印模板下全部必填界面模板都保存时(病历为"完成"状态)，才生成病历浏览图片；
/// Input:	AEpisodeID  : 就诊rowid,  AEPRLogsID : 日志ID
/// Return:	1 应该生成图片，0 应该删除图片，-1 异常
/// Debug:	w ##Class(EPRservice.BOEPImage).GetEPRImageCheckStatus("201764","2")
ClassMethod GetEPRImageCheckStatus(AEpisodeID As %String, AEPRLogsID As %String) As %String [ WebMethod ]
{
	q:(AEpisodeID = "")||(AEPRLogsID="") ""	
	
	s needSavePrintImage = ##Class(EPRservice.BOEPImage).GetEPRImageCheckStatus(AEpisodeID,AEPRLogsID)
	q needSavePrintImage
}

/// Debug:	w ##class(EPRservice.BOEPImage).DeleteEPImage(aEpisodeID,aEPRLogsID)
ClassMethod DeleteEPImage(AEpisodeID As %String, AEPRLogsID As %String) As %String [ WebMethod ]
{
	q:(AEpisodeID = "")||(AEPRLogsID="") ""	
	
	s status = ##Class(EPRservice.BOEPImage).DeleteEPImage(AEpisodeID,AEPRLogsID)
	q status
}

/// ******************* 以下为测试代码 ***************
/// w ##class(EPRservice.BOInstanceData).TestSaveData("118||1")
ClassMethod TestSaveData(id)
{
	//b "s"
	s objInstance = ##class(EPRservice.BOInstanceData).GetDataByID(id)
		
	s objEMixInstanceLog = ##class(EPRservice.entity.EMixInstanceLog).%New()
	s objEMixInstanceLog.Action = "Save"
	s objEMixInstanceLog.OperateUserID = "83"
	s objEMixInstanceLog.EpisodeID = "201868"
	s objEMixInstanceLog.PrintTemplateDocID = "335"
	s objEMixInstanceLog.TemplateDocID = "522"
	s objEMixInstanceLog.OperateMachineIP = "127.0.0.1"
	
	s errorMsg = ""
	//b "s"
	do ##class(EPRservice.BOInstanceData).SaveData(objInstance,objEMixInstanceLog,errorMsg)
	
	
	/*从文件中获取InstanceData数据
	if obj '= ""
	{
		Set file=##class(%File).%New("E:\textfile.txt")
	    d file.Open("RS")
		Do obj.InstanceData.CopyFrom(file)

		do ##class(EPRservice.BOInstanceData).SaveData(obj)
		//do ##class(EPRservice.BOInstanceData).SaveMultipleData(obj)
	}
	*/
	w "succeed!"
}

/// w ##class(EPRservice.BOInstanceData).TestSaveData2("715692||1")
ClassMethod TestSaveData2(id)
{
	s obj = ##class(EPRservice.BOInstanceData).GetDataByID(id)	
	
	s str = "<NInstanceData><Code>A0000</Code><Value /><ValueCode /><BindKBCode /><SubItems><NISimple><Code>I0001</Code><Value>中西医结合科医疗单元</Value><ValueCode>4400</ValueCode><FormatRangeCollection /></NISimple><NISimple><Code>S0002</Code><Value>011床</Value><ValueCode /><FormatRangeCollection /></NISimple><NISimple><Code>S0003</Code><Value>1257271</Value><ValueCode /><FormatRangeCollection /></NISimple><NISimple><Code>S0104</Code><Value>工人</Value><ValueCode /><FormatRangeCollection /></NISimple><NISimple><Code>S0004</Code><Value>周潮</Value><ValueCode /><FormatRangeCollection /></NISimple><NISimple><Code>O0105</Code><Value>未婚</Value><ValueCode>0</ValueCode><FormatRangeCollection /></NISimple><NISimple><Code>I0097</Code><Value>男</Value><ValueCode>M</ValueCode><FormatRangeCollection /></NISimple><NISimple><Code>O0005</Code><Value /><ValueCode /><FormatRangeCollection /></NISimple><NISimple><Code>S0006</Code><Value>52岁10月</Value><ValueCode /><FormatRangeCollection /></NISimple><NISimple><Code>D0007</Code><Value>2008-12-1</Value><ValueCode>2008-12-1 00:00:00</ValueCode><FormatRangeCollection /></NISimple><NISimple><Code>D0008</Code><Value /><ValueCode /><FormatRangeCollection /></NISimple><NISimple><Code>S0095</Code><Value /><ValueCode /><FormatRangeCollection /></NISimple><NISimple><Code>S0009</Code><Value>无</Value><ValueCode /><FormatRangeCollection /></NISimple><NISimple><Code>S0010</Code><Value>无</Value><ValueCode /><FormatRangeCollection /></NISimple><NISimple><Code>S0011</Code><Value>无</Value><ValueCode /><FormatRangeCollection /></NISimple><NISimple><Code>S0012</Code><Value>无</Value><ValueCode /><FormatRangeCollection /></NISimple><NISimple><Code>S0013</Code><Value>无</Value><ValueCode /><FormatRangeCollection /></NISimple><NISimple><Code>S0014</Code><Value>无</Value><ValueCode /><FormatRangeCollection /></NISimple><NISegment><Code>G0091</Code><Value /><ValueCode /><KBNodeID /><SegmentNumber /><SubItems><NILink><Code>L0092</Code><Value /><ValueCode /><FormatRangeCollection /></NILink></SubItems><FormatRangeCollection /></NISegment><NISegment><Code>G0016</Code><Value /><ValueCode /><KBNodeID /><SegmentNumber /><SubItems><NILink><Code>L0099</Code><Value /><ValueCode /><FormatRangeCollection /></NILink></SubItems><FormatRangeCollection /></NISegment><NISegment><Code>G0044</Code><Value /><ValueCode /><KBNodeID /><SegmentNumber /><SubItems><NILink><Code>L0107</Code><Value>,慢性胰腺炎急性发作</Value><ValueCode /><FormatRangeCollection /></NILink></SubItems><FormatRangeCollection /><AbNormalSupport>True</AbNormalSupport><IsAbNormal>False</IsAbNormal><Normal><SubItems><NILink><Code>L0107</Code><Value /><ValueCode /><FormatRangeCollection /></NILink></SubItems><FormatRangeCollection /></Normal><AbNormal><SubItems /><FormatRangeCollection /></AbNormal></NISegment><NISegment><Code>G0048</Code><Value /><ValueCode /><KBNodeID /><SegmentNumber /><SubItems><NIFree><Code /><Value>ddddddddddddddddddddd&amp;KeyEnter;e&amp;KeyEnter;e&amp;KeyEnter;e&amp;KeyEnter;&amp;KeyEnter;e&amp;KeyEnter;e&amp;KeyEnter;&amp;KeyEnter;e&amp;KeyEnter;e&amp;KeyEnter;e&amp;KeyEnter;e&amp;KeyEnter;e&amp;KeyEnter;&amp;KeyEnter;e&amp;KeyEnter;ee&amp;KeyEnter;&amp;KeyEnter;e&amp;KeyEnter;e&amp;KeyEnter;e&amp;KeyEnter;e&amp;KeyEnter;e&amp;KeyEnter;e&amp;KeyEnter;e&amp;KeyEnter;ee&amp;KeyEnter;e&amp;KeyEnter;e&amp;KeyEnter;e&amp;KeyEnter;&amp;KeyEnter;</Value><ValueCode /><FormatRangeCollection /></NIFree></SubItems><FormatRangeCollection /></NISegment><NISimple><Code>S0049</Code><Value /><ValueCode /><FormatRangeCollection /></NISimple><NISimple><Code>S0050</Code><Value /><ValueCode /><FormatRangeCollection /></NISimple><NISimple><Code>S0112</Code><Value /><ValueCode /><FormatRangeCollection /></NISimple><NISimple><Code>S0111</Code><Value /><ValueCode /><FormatRangeCollection /></NISimple><NISimple><Code>S0110</Code><Value /><ValueCode /><FormatRangeCollection /></NISimple><NISimple><Code>S0109</Code><Value /><ValueCode /><FormatRangeCollection /></NISimple><NISimple><Code>D0051</Code><Value>2010-7-21</Value><ValueCode>2010-7-21 00:00:00</ValueCode><FormatRangeCollection /></NISimple></SubItems></NInstanceData>"
	if obj '=""
	{	
		d obj.InstanceData.Clear()
		d obj.InstanceData.Rewind()
		d obj.InstanceData.Write(str)
		
		do ..SaveData(obj)
	}
	w "succeed!"
}

/// w ##class(EPRservice.BOInstanceData).TestSaveMultipleData("67||1")
ClassMethod TestSaveMultipleData(aId) As %String [ WebMethod ]
{
	if aId '= ""
	{	s eInstanceData=..GetDataByID(aId)}
	else
	{ 	
		s parStr=^CacheTempDHCEPRDebug("EPRservice.BOInstanceData","GetMultipleData","Input")
		s APatientID=$p($p(parStr,"^",1),"=",2)
		s AEpisodeID=$p($p(parStr,"^",2),"=",2)
		s AChartItemID=$p($p(parStr,"^",3),"=",2)
		s AChartItemType=$p($p(parStr,"^",4),"=",2)
		s AChartListNo=$p($p(parStr,"^",5),"=",2)
		s ATemplateID=$p($p(parStr,"^",6),"=",2)
		s ACategoryID=$p($p(parStr,"^",7),"=",2)
		s ACategoryType=$p($p(parStr,"^",8),"=",2)
		s eInstanceData=..GetMultipleData(APatientID,AEpisodeID,AChartItemID,AChartItemType,AChartListNo,ATemplateID,ACategoryID,ACategoryType)
		d eInstanceData.InstanceData.Rewind()
		//d eInstanceData.InstanceData.Write(^CacheTempDHCEPRDebug("EPRservice.BOInstanceData","SaveMultipleData","InstanceData"))
	}
	
	s objEMixInstanceLog = ##class(EPRservice.entity.EMixInstanceLog).%New()
	s objEMixInstanceLog.Action = "Save"
	s objEMixInstanceLog.InitStatus = "Commit"
	s objEMixInstanceLog.FinalStatus = "Commit" 
	s objEMixInstanceLog.OperateUserID = "83"
	if aId = ""
	{
		s objEMixInstanceLog.EpisodeID = AEpisodeID
		s objEMixInstanceLog.PrintTemplateDocID = $e(AChartItemID,3,$l(AChartItemID))
		s objEMixInstanceLog.TemplateDocID = ""
	}
	s objEMixInstanceLog.OperateMachineIP = "127.0.0.1"
	
	s errorMsg = ""
	
	d ..SaveMultipleData(eInstanceData, .objEMixInstanceLog, .errorMsg)
	
	b
	q "OK"
}

/// w ##class(EPRservice.BOInstanceData).Test()
ClassMethod Test2()
{
	//8^56^I^85^Single^Normal^179
	s obj = ..GetNormalData("8","56","I","85","Single","Normal","179")
	s str = "<NInstanceData><Code>A0000</Code><Value /><ValueCode /><BindKBCode /><SubItems><NISegment><Code>G0001</Code><Value /><ValueCode /><KBNodeID /><SegmentNumber /><SubItems /><FormatRangeCollection /></NISegment><NITextDesc><Code>E0002</Code><Value /><ValueCode /><SubItems /><FormatRangeCollection /></NITextDesc><NISimple><Code>S0003</Code><Value /><ValueCode /><FormatRangeCollection /></NISimple><NIFigure><Code>F0005</Code><Value /><ValueCode /><SubItems><NIFigureRow><Code /><Value /><ValueCode /><FigureDesc>说明</FigureDesc><FigureData><![CDATA[/9j/4AA]]></FigureData></NIFigureRow></SubItems></NIFigure></SubItems></NInstanceData>"
	if obj '=""
	{	
		d obj.InstanceData.Clear()
		d obj.InstanceData.Rewind()
		d obj.InstanceData.Write(str)
		
		do ..SaveData(obj)
	}
}

}
