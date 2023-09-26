Class EPRinstance.IdxMgr.Annotate Extends %RegisteredObject [ ProcedureBlock ]
{

Property ChartItemID As %String(TRUNCATE = 1);

Property EpisodeID As %String(TRUNCATE = 1);

Property ExistSubItems As list Of EPRinstance.IAnnotate;

Property InstanceDataID As %String(TRUNCATE = 1);

Property ListNo As %String(TRUNCATE = 1);

Property PatientID As %String(TRUNCATE = 1);

Property TemplateID As %String(TRUNCATE = 1);

Property TemplateVersion As %String(TRUNCATE = 1);

Property UpdateSubItems As list Of EPRinstance.Parser.NIImageAnnotate;

Property UpSubItems As list Of EPRinstance.Parser.NIImageAnnotate;

Method BuildIndex(ANInstanceData As EPRinstance.Parser.NInstanceData)
{
 do ..BuildListFromData(ANInstanceData)

 do ..BuildListFromIndex()
 ;do ..BuildListFromIndexGlobal()

 do ..UpdateIndex()
}

Method BuildListFromData(ANInstanceData As EPRinstance.Parser.NInstanceData)
{
 
 do ..UpdateSubItems.Clear()
 Set ItemCount= ANInstanceData.SubItems.Count()
 for I = 1:1:ItemCount
 { set obj= ANInstanceData.SubItems.GetAt(I)
 if obj.%ClassName()="NIImageAnnotate"
 { do ..UpdateSubItems.Insert(obj)  }
 elseif obj.%ClassName()="NICluster"
 { //	for  obj.SubItems
	 do ..GetAnnotateFromCluster(obj)
 } 	  
 }
}

Method GetAnnotateFromCluster(ANICluster As EPRinstance.Parser.NICluster)
{
  for J= 1:1:ACluster.SubItems.Count()
  {	set obj= ACluster.SubItems.GetAt(J)
  if obj.%ClassName()="NIImageAnnotate"
  {do ..UpdateSubItems.Insert(obj) 
	  }
 elseif obj.%ClassName()="NICluster"
 { //	recursion  NICluster
	 do ..GetAnnotateFromCluster(obj)
 }
 }
}

Method BuildListFromIndex()
{
 k ^CacheTempEPRExistToDelIAnnotate($J)	
 
 if (..UpdateSubItems.Count()=0)
 { Q }
 
 do ..ExistSubItems.Clear()

 ///comment the code block below on 2008-1-24
 /*
 set IAnnotateKey = $ORDER(^DHCEPRI.IAnnotateD(""))
 WHILE (IAnnotateKey'="") 
 {
 Set LBIAnnotate = $G(^DHCEPRI.IAnnotateD(IAnnotateKey)) 

 if ($LG(LBIAnnotate,2) = ..InstanceDataID)  
 {	  Set ExistTemplateID = $LG(LBIAnnotate,4)
	  if (ExistTemplateID '= ..TemplateID) 
	  {
		set ^CacheTempEPRExistToDelIAnnotate($J,IAnnotateKey)= ExistTemplateID 
	   }
	  if (ExistTemplateID = ..TemplateID) 	  
	  {
		set objIAnnotate = ##class(EPRinstance.IAnnotate).%OpenId(IAnnotateKey)
		do ..ExistSubItems.Insert(objIAnnotate)
		}
 }
 SET IAnnotateKey = $ORDER(^DHCEPRI.IAnnotateD(IAnnotateKey))	  
 }
 */
 
 ///add the code block below on 2008-1-24
 ///use index to enhance query efficiency
 s BlankInstanceDataID=" "_..InstanceDataID
 q:$d(^DHCEPRI.IAnnotateI("IdxForUpdate",BlankInstanceDataID))=0
 s ImageAnnotateCode=$O(^DHCEPRI.IAnnotateI("IdxForUpdate",BlankInstanceDataID,""))
 while ImageAnnotateCode '= ""
 {
	 s IAnnotateKey=$O(^DHCEPRI.IAnnotateI("IdxForUpdate",BlankInstanceDataID,ImageAnnotateCode,""))
	 while IAnnotateKey '= ""
	 {
		 s objIAnnotate = ##class(EPRinstance.IAnnotate).%OpenId(IAnnotateKey)
		 if objIAnnotate.TemplateID '= ..TemplateID
		 {
			 s ^CacheTempEPRExistToDelIAnnotate($J,IAnnotateKey)= objIAnnotate.TemplateID
		 }
		 else
		 {
			 do ..ExistSubItems.Insert(objIAnnotate)
		 }
		 s IAnnotateKey=$O(^DHCEPRI.IAnnotateI("IdxForUpdate",BlankInstanceDataID,ImageAnnotateCode,IAnnotateKey))
	 }
	 s ImageAnnotateCode=$O(^DHCEPRI.IAnnotateI("IdxForUpdate",BlankInstanceDataID,ImageAnnotateCode))
 }
 
 //delete isimple item 
 set DelIDKey = $ORDER(^CacheTempEPRExistToDelIAnnotate($J,""))	
 WHILE (DelIDKey'="") 
 {
 do ##class(EPRinstance.IAnnotate).%DeleteId(DelIDKey)   	 
 SET DelIDKey = $ORDER(^CacheTempEPRExistToDelIAnnotate($J,DelIDKey))	   
 }
}

Method UpdateIndex()
{
 if (..UpdateSubItems.Count()=0)
 { Q }
 k ^CacheTempEPRAnnotate($J)
 k ^CacheTempEPRUPAnnotate($J)
 d ..UpSubItems.Clear()
 set UpdateCount =  ..UpdateSubItems.Count() 

 //if has no Old data ,All Data Insert Index table
 //else if has Old data , if  Old data 's SegmentCode equality Updata it
 //else  Push it into  ^CacheTempEPRUPAnnotate  
 set ExistCount= ..ExistSubItems.Count()
 
 if (ExistCount= 0)  
 {  
  For J =1:1:UpdateCount
  {  
    set obj= ..UpdateSubItems.GetAt(J)
    do ..UpSubItems.Insert(obj)
  }
 
 } 

 elseif (ExistCount> 0)
 {      
 if UpdateCount> 0
 {
   for O=1:1: UpdateCount  
   {
    Set EquatFlag = "False"

    set objImageAnnotate= ..UpdateSubItems.GetAt(O)
    
    for K=1:1:ExistCount
    { 
     set objIAnnotate =  ..ExistSubItems.GetAt(K)
     if (objIAnnotate.ImageAnnotateCode = objImageAnnotate.Code) 
     { Set EquatFlag = "True" 
       do objIAnnotate.AnnoData.Clear()
       
       do objIAnnotate.AnnoData.CopyFrom(objImageAnnotate.AnnoData)
       set objIAnnotate.TemplateVersion = ..TemplateVersion
       do objIAnnotate.%Save()   }
     }
    if (EquatFlag="False")
    { do ..UpSubItems.Insert(objImageAnnotate)   }

    
    }
   } 
  }

 for P=1:1:..UpSubItems.Count() 
 {	
    set objImageAnnotate= ..UpSubItems.GetAt(P)
    Set NewIAnnotate = ##class(EPRinstance.IAnnotate).%New()  
	set NewIAnnotate.InstanceDataID = ..InstanceDataID
	set NewIAnnotate.PatientID = ..PatientID
	set NewIAnnotate.EpisodeID = ..EpisodeID
	set NewIAnnotate.ChartItemID = ..ChartItemID
	set NewIAnnotate.ListNo = ..ListNo
	set NewIAnnotate.TemplateID = ..TemplateID
	set NewIAnnotate.TemplateVersion = ..TemplateVersion
	set NewIAnnotate.TemplateID = ..TemplateID
	
	Set NewIAnnotate.ImageAnnotateCode = objImageAnnotate.Code
	do NewIAnnotate.AnnoData.CopyFrom(objImageAnnotate.AnnoData) 
    do NewIAnnotate.%Save()	
	}
}

}
