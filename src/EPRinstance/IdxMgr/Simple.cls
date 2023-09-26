Class EPRinstance.IdxMgr.Simple Extends %RegisteredObject [ ProcedureBlock ]
{

Property ChartItemID As %String(TRUNCATE = 1);

Property EpisodeID As %String(TRUNCATE = 1);

Property ExistSubItems As list Of EPRinstance.ISimple;

Property InstanceDataID As %String(TRUNCATE = 1);

Property ListNo As %String(TRUNCATE = 1);

Property PatientID As %String(TRUNCATE = 1);

Property TemplateID As %String(TRUNCATE = 1);

Property TemplateVersion As %String(TRUNCATE = 1);

Property UpdateSubItems As list Of EPRinstance.Parser.NISimple;

Method BuildIndex(ANInstanceData As EPRinstance.Parser.NInstanceData)
{
 do ..BuildListFromData(ANInstanceData)	

 //sort global
 //do ..BuildListFromIndex()

 do ..BuildListFromIndexGlobal()

 do ..UpdateIndex()
}

Method BuildListFromData(ANInstanceData As EPRinstance.Parser.NInstanceData)
{
 do ..UpdateSubItems.Clear()
 Set ItemCount= ANInstanceData.SubItems.Count()

 for I = 1:1:ItemCount
 {           

 set obj= ANInstanceData.SubItems.GetAt(I)
 if obj.%ClassName()="NISimple"
 {
	//B "S"
	do ..UpdateSubItems.Insert(obj) 
	  }
 elseif (obj.%ClassName()="NIImageAnnotate")
 {
   D ..GetSimpleitemForAnnotate(obj)	  
	 }
 elseif (obj.%ClassName()="NICluster")
 {
 //	for  obj.SubItems
	 do ..GetSimpleitemForCluster(obj)
 }
 
  	  
 }
}

Method GetSimpleitemForAnnotate(AImageAnnotate As EPRinstance.Parser.NIImageAnnotate)
{
 for O= 1:1:AImageAnnotate.SubItems.Count()
 {
	set obj= AImageAnnotate.SubItems.GetAt(O)
   if obj.%ClassName()="NISimple"
   {
	 do ..UpdateSubItems.Insert(obj) 
	  }
 }
}

Method BuildListFromIndexGlobal()
{
 k ^CacheTempEPRExistToDelISimple($J)
 do ..ExistSubItems.Clear()
 
 ///add the code block below on 2008-1-24
 /*
 s BlankInstanceDataID=" "_..InstanceDataID
 i '$d(^DHCEPRI.ISimpleI("IdxForUpdate",BlankInstanceDataID))=0 d
 .s SimpleItemCode=""
 .f  s SimpleItemCode=$O(^DHCEPRI.ISimpleI("IdxForUpdate",BlankInstanceDataID,SimpleItemCode))  q:SimpleItemCode=""  d
 ..s ISimpleKey=""
 ..f  s ISimpleKey=$O(^DHCEPRI.ISimpleI("IdxForUpdate",BlankInstanceDataID,SimpleItemCode,ISimpleKey))  q:ISimpleKey=""  d
 ...s objISimple = ##class(EPRinstance.ISimple).%OpenId(ISimpleKey)
 ...i objISimple.TemplateID '= ..TemplateID  d
 ....s ^CacheTempEPRExistToDelISimple($J,ISimpleKey)= objISimple.TemplateID
 ...i objISimple.TemplateID = ..TemplateID  d
 ....d ..ExistSubItems.Insert(objISimple)
 */
 
 /*
 set ISimpleKey = $ORDER(^DHCEPRI.ISimpleD(""))
 WHILE (ISimpleKey'="") 
 {
 Set LBISimple = $G(^DHCEPRI.ISimpleD(ISimpleKey)) 

 if ($LG(LBISimple,2) = ..InstanceDataID)  
 {
	  
	  Set ExistTemplateID = $LG(LBISimple,4)
	  if (ExistTemplateID '= ..TemplateID) 
	  {
		set ^CacheTempEPRExistToDelISimple($J,ISimpleKey)= ExistTemplateID 
	   }
	  if (ExistTemplateID = ..TemplateID) 	  
	  {
		set objISimple = ##class(EPRinstance.ISimple).%OpenId(ISimpleKey)
		do ..ExistSubItems.Insert(objISimple)
		}
 }
 SET ISimpleKey = $ORDER(^DHCEPRI.ISimpleD(ISimpleKey))	  
 }
*/
 ///add the code block below on 2008-1-24
 ///use index to enhance the query efficieny 
 s BlankInstanceDataID=" "_..InstanceDataID
 q:$d(^DHCEPRI.ISimpleI("IdxForUpdate",BlankInstanceDataID))=0
 s SimpleItemCode=$O(^DHCEPRI.ISimpleI("IdxForUpdate",BlankInstanceDataID,""))
 while SimpleItemCode '= ""
 {
	 s ISimpleKey=$O(^DHCEPRI.ISimpleI("IdxForUpdate",BlankInstanceDataID,SimpleItemCode,""))
	 while ISimpleKey '= ""
	 {
		 s objISimple = ##class(EPRinstance.ISimple).%OpenId(ISimpleKey)
		 if objISimple.TemplateID '= ..TemplateID
		 {
			s ^CacheTempEPRExistToDelISimple($J,ISimpleKey)= objISimple.TemplateID 
		 }
		 else
		 {
			d ..ExistSubItems.Insert(objISimple)
		 }
		 s ISimpleKey=$O(^DHCEPRI.ISimpleI("IdxForUpdate",BlankInstanceDataID,SimpleItemCode,ISimpleKey))
	 }
	 s SimpleItemCode=$O(^DHCEPRI.ISimpleI("IdxForUpdate",BlankInstanceDataID,SimpleItemCode))
 }

 //delete isimple item 
 set DelIDKey = $ORDER(^CacheTempEPRExistToDelISimple($J,""))	
 WHILE (DelIDKey'="") 
 {
 do ##class(EPRinstance.ISimple).%DeleteId(DelIDKey)   	 
 SET DelIDKey = $ORDER(^CacheTempEPRExistToDelISimple($J,DelIDKey))	   
 }
}

Method GetSimpleitemForCluster(ACluster As EPRinstance.Parser.NICluster)
{
 for J= 1:1:ACluster.SubItems.Count()
 {
	set obj= ACluster.SubItems.GetAt(J)
 if obj.%ClassName()="NISimple"
 {
	do ..UpdateSubItems.Insert(obj) 
	  }
 elseif obj.%ClassName()="NICluster"
 {
 //	recursion  NICluster
	 do ..GetSimpleitemForCluster(obj)
 } 
 elseif obj.%ClassName()="NIImageAnnotate"
 {
	  D ..GetSimpleitemForAnnotate(obj)
  }	  	  
	  }
}

Method UpdateIndex()
{
 k ^CacheTempEPRSimple($J)
 k ^CacheTempEPRUPSimple($J)

 set UpdateCount =  ..UpdateSubItems.Count() 
 //New items add to global to sort
 For J =1:1:UpdateCount
 {
	 set obj= ..UpdateSubItems.GetAt(J)
	
	 set ^CacheTempEPRSimple($J,obj.Code)= obj.Value
	 set ^CacheTempEPRSimple($J,obj.Code,"ValueCode")= obj.ValueCode
 }

 set ExistCount= ..ExistSubItems.Count()

 //if No Exist Item ,Add New item to table 
 if (ExistCount= 0)  
 { Merge ^CacheTempEPRUPSimple($J) = ^CacheTempEPRSimple($J) } 
 elseif (ExistCount> 0)
 {      
	   if UpdateCount> 0
	 {
		 set Key = $ORDER(^CacheTempEPRSimple($J,""))
		 WHILE (Key'="") 
	 	 {  
			 //insert update tag
			
			 Set EquatFlag = "False"
			
			 Set UpdateDataValue = $G(^CacheTempEPRSimple($J,Key)) 
			 
			 Set UpdateValueCode = $G(^CacheTempEPRSimple($J,Key,"ValueCode")) 
			 
			 for K=1:1:ExistCount
			 {
				 set objISimple =  ..ExistSubItems.GetAt(K)
				
				 if (objISimple.SimpleItemCode = Key) 
				 { 
					 Set EquatFlag = "True"
					 // B "S" 
					 // update item Version  
					 if (objISimple.DataValue =UpdateDataValue)
					 { 
						 s objISimple.ValueCode = UpdateValueCode
						 s objISimple.TemplateVersion = ..TemplateVersion
						 do objISimple.%Save()  
					 }
					 elseif (objISimple.DataValue '=UpdateDataValue)
					 {
						 //update item value 
						 set objISimple.DataValue = UpdateDataValue
						 set objISimple.ValueCode = UpdateValueCode
						 set objISimple.TemplateVersion = ..TemplateVersion
						 do objISimple.%Save()  
					 }
					
				 }
			 }
			
			 if (EquatFlag= "False")
			 {
			   set ^CacheTempEPRUPSimple($J,Key)= UpdateDataValue
				 set ^CacheTempEPRUPSimple($J,Key,"ValueCode")= UpdateValueCode
			 }
			 SET Key = $ORDER(^CacheTempEPRSimple($J,Key))
	   } 
	 }
 }
 // 
 set UpKey = $ORDER(^CacheTempEPRUPSimple($J,""))
 WHILE (UpKey'="") 
 {
	
		Set NewISimple = ##class(EPRinstance.ISimple).%New()  
		set NewISimple.InstanceDataID = ..InstanceDataID
		set NewISimple.PatientID = ..PatientID
		set NewISimple.EpisodeID = ..EpisodeID
		set NewISimple.ChartItemID = ..ChartItemID
		set NewISimple.ListNo = ..ListNo
		set NewISimple.TemplateID = ..TemplateID
		set NewISimple.TemplateVersion = ..TemplateVersion
		set NewISimple.TemplateID = ..TemplateID
		
		Set NewISimple.SimpleItemCode = UpKey
		Set NewISimple.DataValue=$G(^CacheTempEPRUPSimple($J,UpKey))  
		Set NewISimple.ValueCode=$G(^CacheTempEPRUPSimple($J,UpKey,"ValueCode"))  
		
	  do NewISimple.%Save()	
		  
	  SET UpKey = $ORDER(^CacheTempEPRSimple($J,UpKey))	  
	}
}

}
