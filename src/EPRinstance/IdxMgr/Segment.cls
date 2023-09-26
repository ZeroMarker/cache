Class EPRinstance.IdxMgr.Segment Extends %RegisteredObject [ ProcedureBlock ]
{

Property ChartItemID As %String(TRUNCATE = 1);

Property EpisodeID As %String(TRUNCATE = 1);

Property ExistISimpleSubItems As list Of EPRinstance.ISegmentSimple;

Property ExistSubItems As list Of EPRinstance.ISegment;

Property InstanceDataID As %String(TRUNCATE = 1);

Property ListNo As %String(TRUNCATE = 1);

Property PatientID As %String(TRUNCATE = 1);

Property TemplateID As %String(TRUNCATE = 1);

Property TemplateVersion As %String(TRUNCATE = 1);

Property UpdateISimpleSubItems As list Of EPRinstance.Parser.NISimple;

Property UpdateSegmentSubItems As list Of EPRinstance.Parser.NISegment;

/// 打散Segment数据
Method BuildIndex(ANInstanceData As EPRinstance.Parser.NInstanceData)
{
 ///解析要打散的Segment数据
 do ..BuildListFromData(ANInstanceData)

 ///分析已打散的Segment数据(那些需要删除，那些需要更新)
 do ..BuildListFromIndexGlobal()

 ///打散Segment数据(更新已存在的，并添加新的)
 do ..UpdateIndex()
}

/// 解析要打散的Segment数据
Method BuildListFromData(ANInstanceData As EPRinstance.Parser.NInstanceData)
{
 do ..UpdateSegmentSubItems.Clear()
 do ..UpdateISimpleSubItems.Clear()

 //The Vessels To Keep New SegmentSimple ,UpdateISimpleSubItems just use to Count the Items Num, NISimple Cann't Hold All infomation to ISegmentsimple
 k ^CacheTempEPRSegmentSimple($J)

 set ItemCount= ANInstanceData.SubItems.Count()
 for I = 1:1:ItemCount
 {           
 	set obj= ANInstanceData.SubItems.GetAt(I)
 	if obj.%ClassName()="NISegment"
 	{
		do ..UpdateSegmentSubItems.Insert(obj)
		///解析Segment的内嵌结构化单元
		do ..GetSimpleItemFromSegment(obj) 
	}
	elseif obj.%ClassName()="NICluster"
 	{
	 	///解析Cluster的内嵌Sgement单元
	 	do ..GetSegmentItemFromCluster(obj)
 	} 	  
  }
}

/// 解析要打散的Cluster的内嵌Sgement单元
Method GetSegmentItemFromCluster(ACluster As EPRinstance.Parser.NICluster)
{
 for J= 1:1:ACluster.SubItems.Count()
 {
	set obj= ACluster.SubItems.GetAt(J)
 	if obj.%ClassName()="NISegment"
 	{
		do ..UpdateSegmentSubItems.Insert(obj) 
		do ..GetSimpleItemFromSegment(obj)
	}
	elseif obj.%ClassName()="NICluster"
 	{
 		//	recursion  NICluster
	 	do ..GetSegmentItemFromCluster(obj)
 	} 	  
 }
}

/// 解析要打散的Segment的内嵌结构化单元
Method GetSimpleItemFromSegment(ASegment As EPRinstance.Parser.NISegment)
{
 for K=1:1:ASegment.SubItems.Count()
 {
	set obj= ASegment.SubItems.GetAt(K)
    if obj.%ClassName()="NISimple"
 	{
   		do ..UpdateISimpleSubItems.Insert(obj)   
	  	set ^CacheTempEPRSegmentSimple($J,obj.Code)= obj.Value
	  	set ^CacheTempEPRSegmentSimple($J,obj.Code,"SegmentCode")= ASegment.Code
	  	set ^CacheTempEPRSegmentSimple($J,obj.Code,"ValueCode")= obj.ValueCode
	}
 }
}

/// 分析已打散的Segment及SegmentSimple数据，确定那些需要删除，那些需要更新
Method BuildListFromIndexGlobal()
{
 // Make segment items to  Wait update Global  and delete the unEqual TemplateID segment items
 do ..BuildSgmListFromIndexGlobal()
 // Make Segment simple  Similar  segment
 do ..BuildSgmSplListFromIndexGlobal()
}

/// 确定哪些已打散的Segment数据需要删除或更新
Method BuildSgmListFromIndexGlobal()
{
 k ^CacheTempEPRExistToDelISegment($J)	
 do ..ExistSubItems.Clear()

 ///comment the code block below on 2008-1-24
 /*
 set ISegmentKey = $ORDER(^DHCEPRI.ISegmentD(""))
 WHILE (ISegmentKey'="") 
 {
 Set LBISegment = $G(^DHCEPRI.ISegmentD(ISegmentKey)) 
 if ($LG(LBISegment,2) = ..InstanceDataID)  
 {
	  //B "S"
	  Set ExistTemplateID = $LG(LBISegment,4)  
	  // if exist item's TemplateID is unequal ,the delete item
	  if (ExistTemplateID '= ..TemplateID) 
	  {
		set ^CacheTempEPRExistToDelISegment($J,ISegmentKey)= ExistTemplateID 
	   }
	  if (ExistTemplateID = ..TemplateID) 	  
	  {
		set objISegment = ##class(EPRinstance.ISegment).%OpenId(ISegmentKey)
		do ..ExistSubItems.Insert(objISegment)
		}
 }
 SET ISegmentKey = $ORDER(^DHCEPRI.ISegmentD(ISegmentKey))	  
 }
 */
 
 ///add the code block below on 2008-1-24
 ///use index to enhance query efficiency
 s BlankInstanceDataID=" "_..InstanceDataID
 q:$d(^DHCEPRI.ISegmentI("IdxForUpdate",BlankInstanceDataID))=0
 s ISegmentCode=$O(^DHCEPRI.ISegmentI("IdxForUpdate",BlankInstanceDataID,""))
 while ISegmentCode '= ""
 {
	 s ISegmentKey=$O(^DHCEPRI.ISegmentI("IdxForUpdate",BlankInstanceDataID,ISegmentCode,""))
	 while ISegmentKey '= ""
	 {
		 s objISegment = ##class(EPRinstance.ISegment).%OpenId(ISegmentKey)
		 if objISegment.TemplateID '= ..TemplateID
		 {
			 set ^CacheTempEPRExistToDelISegment($J,ISegmentKey)= objISegment.TemplateID
		 }
		 else
		 {
			 do ..ExistSubItems.Insert(objISegment)
		 }
		 s ISegmentKey=$O(^DHCEPRI.ISegmentI("IdxForUpdate",BlankInstanceDataID,ISegmentCode,ISegmentKey))
	 }
	 s ISegmentCode=$O(^DHCEPRI.ISegmentI("IdxForUpdate",BlankInstanceDataID,ISegmentCode))
 }
 
 //do delete item
 set DelIDKey = $ORDER(^CacheTempEPRExistToDelISegment($J,""))	
 while (DelIDKey'="") 
 {
 	do ##class(EPRinstance.ISegment).%DeleteId(DelIDKey)   	 
 	set DelIDKey = $ORDER(^CacheTempEPRExistToDelISegment($J,DelIDKey))	   
 }
}

/// 确定哪些已打散的SegmentSimple数据需要删除或更更新
Method BuildSgmSplListFromIndexGlobal()
{
 //load the Same InstanceDataID TemplateID  Segment simple data to ExistISimpleSubItems
 //and push different TemplateID Segment simple to ^CacheTempEPRExistDelISgSimple wait to delete
 k ^CacheTempEPRExistDelISgSimple($J)	
 do ..ExistISimpleSubItems.Clear()
 

 s SgSimpleCount = 0
 s SgSimpleCount = ..UpdateISimpleSubItems.Count()
 
  ///comment the code block below on 2008-1-24
 /*
 //B "S"
 set ISegmentSimpleKey = $ORDER(^DHCEPRI.ISegmentSimpleD(""))
 WHILE (ISegmentSimpleKey'="") 
 {

 Set LBISegment = $G(^DHCEPRI.ISegmentSimpleD(ISegmentSimpleKey)) 
 if ($LG(LBISegment,2) = ..InstanceDataID)  
 {
	 
	  Set ExistTemplateID = $LG(LBISegment,4)
	  set ^CacheTempEPRExistDelISgSimple($J,ISegmentSimpleKey)= ExistTemplateID   
	 //******** if (ExistTemplateID '= ..TemplateID) 
	 // {
	 //	set ^CacheTempEPRExistDelISgSimple($J,ISegmentSimpleKey)= ExistTemplateID 
	 //  }
	 // if (ExistTemplateID = ..TemplateID) 	  
	 //  {
	 //	set objISegmentSimple = ##class(EPRinstance.ISegmentSimple).%OpenId(ISegmentSimpleKey)
	 //	if (SgSimpleCount= 0)
	 //	{
	 //	  set ^CacheTempEPRExistDelISgSimple($J,ISegmentSimpleKey)= ExistTemplateID 
	 //		}
	 //   elseif (SgSimpleCount'=0) 
	 //	 { do ..ExistISimpleSubItems.Insert(objISegmentSimple) }
	 //	}
	 //********
 }
 SET ISegmentSimpleKey = $ORDER(^DHCEPRI.ISegmentSimpleD(ISegmentSimpleKey))	  
 }
 */
 
 ///add the code block below on 2008-1-24
 ///use index to enhance query efficiency
 s BlankInstanceDataID=" "_..InstanceDataID
 q:$d(^DHCEPRI.ISegmentSimpleI("IdxForUpdate",BlankInstanceDataID))=0
 s ISegmentCode=$O(^DHCEPRI.ISegmentSimpleI("IdxForUpdate",BlankInstanceDataID,""))
 while ISegmentCode '= ""
 {
	 s ISgSimpleCode=$O(^DHCEPRI.ISegmentSimpleI("IdxForUpdate",BlankInstanceDataID,ISegmentCode,""))
	 while ISgSimpleCode '= ""
	 {
		 s ISgSimpleKey=$O(^DHCEPRI.ISegmentSimpleI("IdxForUpdate",BlankInstanceDataID,ISegmentCode,ISgSimpleCode,""))
		 while ISgSimpleKey '= ""
		 {
			 s ^CacheTempEPRExistDelISgSimple($J,ISgSimpleKey)= " "
			 s ISgSimpleKey=$O(^DHCEPRI.ISegmentSimpleI("IdxForUpdate",BlankInstanceDataID,ISegmentCode,ISgSimpleCode,ISgSimpleKey))
		 }
		 s ISgSimpleCode=$O(^DHCEPRI.ISegmentSimpleI("IdxForUpdate",BlankInstanceDataID,ISegmentCode,ISgSimpleCode))
	 }
	 
	 s ISegmentCode=$O(^DHCEPRI.ISegmentSimpleI("IdxForUpdate",BlankInstanceDataID,ISegmentCode))
 }
 
 //do delete item 
 set DelIDKey = $ORDER(^CacheTempEPRExistDelISgSimple($J,""))	
 while (DelIDKey'="") 
 {
 do ##class(EPRinstance.ISegmentSimple).%DeleteId(DelIDKey)   	 
 set DelIDKey = $ORDER(^CacheTempEPRExistDelISgSimple($J,DelIDKey))	   
 }
}

/// 打散Segment及SegmentSimple数据
Method UpdateIndex()
{
 do ..UpdateSegmentIndex()	
 do ..UpdateSegmentSimpleIndex()
}

/// 打散Segment数据
Method UpdateSegmentIndex()
{
 k ^CacheTempEPRSegment($J)
 k ^CacheTempEPRUPSegment($J)
 
 set UpdateCount =  ..UpdateSegmentSubItems.Count() 
 For J =1:1:UpdateCount
 {
 	set obj= ..UpdateSegmentSubItems.GetAt(J)
 	//the reason use ^CacheTempEPRSegment  is  Sort                          
 	set ^CacheTempEPRSegment($J,obj.Code)= obj.Text
 	set ^CacheTempEPRSegment($J,obj.Code,"FormateInfo")= obj.FormateInfo	
 }

 set ExistCount= ..ExistSubItems.Count()

 //if has no Old data ,All Data Insert Index table
 //else if has Old data , if  Old data 's SegmentCode equality Updata it
 //else  Push it into  ^CacheTempEPRUPSegment  
 if (ExistCount= 0)  
 { 	
 	Merge ^CacheTempEPRUPSegment($J) = ^CacheTempEPRSegment($J) 
 } 
 elseif (ExistCount> 0)
 {      
 	if UpdateCount> 0
 	{
 		set Key = $ORDER(^CacheTempEPRSegment($J,""))
 		while (Key'="") 
 		{  
 			//insert or update tag
 			//B "S" 
 			Set EquatFlag = "False"

 			Set UpdateText = $G(^CacheTempEPRSegment($J,Key))  
 			Set UpdateFormateInfo = $G(^CacheTempEPRSegment($J,Key,"FormateInfo"))  
 			for K=1:1:ExistCount
 			{
				 //B "S" 
 				set objISegment =  ..ExistSubItems.GetAt(K)
 				if (objISegment.SegmentCode = Key) 
 				{ 
 					Set EquatFlag = "True" 
 					do objISegment.Text.Clear()
 					do objISegment.Text.Rewind() 
 					do objISegment.Text.Write(UpdateText)
 					do objISegment.FormateInfo.Clear()
 					do objISegment.FormateInfo.Rewind() 
 					do objISegment.FormateInfo.Write(UpdateFormateInfo)
 					set objISegment.TemplateVersion = ..TemplateVersion
 					do objISegment.%Save()  
 				}

 			}

 			if (EquatFlag="False")
 			{
	 	 		set ^CacheTempEPRUPSegment($J,Key)= UpdateText  
	 	 		set ^CacheTempEPRUPSegment($J,Key,"FormateInfo")= UpdateFormateInfo  
	 	   	}

 			SET Key = $ORDER(^CacheTempEPRSegment($J,Key))
 		}
	 } 
 }

 
 // set each  item in ^CacheTempEPRUPSegment  to  Index table
 set UpKey = $ORDER(^CacheTempEPRUPSegment($J,""))
 WHILE (UpKey'="") 
 {
	Set NewISegment = ##class(EPRinstance.ISegment).%New()  
	set NewISegment.InstanceDataID = ..InstanceDataID
	set NewISegment.PatientID = ..PatientID
	set NewISegment.EpisodeID = ..EpisodeID
	set NewISegment.ChartItemID = ..ChartItemID
	set NewISegment.ListNo = ..ListNo
	set NewISegment.TemplateID = ..TemplateID
	set NewISegment.TemplateVersion = ..TemplateVersion
	set NewISegment.TemplateID = ..TemplateID
	
	Set NewISegment.SegmentCode = UpKey
	Set TextStr = $G(^CacheTempEPRUPSegment($J,UpKey))
	Set FormateInfoStr = $G(^CacheTempEPRUPSegment($J,UpKey,"FormateInfo"))
	
	Set TextStream= ##class(%GlobalCharacterStream).%New()
	do TextStream.Write(TextStr)
	//do TextStream.SaveStream()
	do NewISegment.Text.CopyFrom(TextStream) 
	Set FormateInfoStream= ##class(%GlobalCharacterStream).%New()
	if (FormateInfoStr'="") 
	{
	 	do FormateInfoStream.Write(FormateInfoStr)
	}
	elseif (FormateInfoStr="") 	
	{
	 	do FormateInfoStream.Write("")	
	}
	//do FormateInfoStream.SaveStream()
	do NewISegment.FormateInfo.CopyFrom(FormateInfoStream) 
	//do NewISegment.FormateInfo.Write(FormateInfoStr)
 	do NewISegment.%Save()	

 	SET UpKey = $ORDER(^CacheTempEPRUPSegment($J,UpKey))	  

 }
}

/// 打散SegmentSimple数据
Method UpdateSegmentSimpleIndex()
{
 //B "S"    
 k ^CacheTempEPRUPSegmentSimple($J)
 set UpdateCount =  ..UpdateISimpleSubItems.Count() 

 set ExistCount= ..ExistISimpleSubItems.Count()

 //if No Exist Item ,Add New item to table  
 if (ExistCount= 0)  
 { 
 	Merge ^CacheTempEPRUPSegmentSimple($J) = ^CacheTempEPRSegmentSimple($J) 
 } 
 elseif (ExistCount> 0)
 {      
 	if UpdateCount> 0
 	{
 		set Key = $ORDER(^CacheTempEPRSegmentSimple($J,""))
 		WHILE (Key'="") 
 		{  
 			// SegmentCode insert update tag
 			Set SegmentCodeEquatFlag = "False"
 			// SimpleCode insert update tag
 			Set SimpleCodeEquatFlag = "False"

 			Set UpdateValue = $G(^CacheTempEPRSegmentSimple($J,Key))  
 			Set UpdateSegmentCode = $G(^CacheTempEPRSegmentSimple($J,Key,"SegmentCode"))  
 			Set UpdateValueCode = $G(^CacheTempEPRSegmentSimple($J,Key,"ValueCode"))  
 			for K=1:1:ExistCount
 			{ 
 				set objISegmentSimple =  ..ExistISimpleSubItems.GetAt(K)
 				if (objISegmentSimple.SegmentCode = UpdateSegmentCode) 
 				{ 
 					Set SegmentCodeEquatFlag = "True" 
 					if (objISegmentSimple.SimpleItemCode = Key)  
 					{
	        			// Update the equal code segment simple item
	        			set SimpleCodeEquatFlag = "True"
	        			set objISegmentSimple.DataValue = UpdateValue
	        			set objISegmentSimple.ValueCode = UpdateValueCode
 						set objISegmentSimple.TemplateVersion = ..TemplateVersion
 						do objISegmentSimple.%Save()  
 					}
 				}
 			}
 			// Add  the  New items noin Exist items to  Global
 			if (SegmentCodeEquatFlag="False")
 			{
	 	  		set ^CacheTempEPRUPSegmentSimple($J,Key)= UpdateValue
	 	  		set ^CacheTempEPRUPSegmentSimple($J,Key,"SegmentCode")= UpdateSegmentCode
	 	  		set ^CacheTempEPRUPSegmentSimple($J,Key,"ValueCode")= UpdateValueCode
	 		}
 			if ((SegmentCodeEquatFlag="True")&(SimpleCodeEquatFlag="False"))
 			{
	 	  		set ^CacheTempEPRUPSegmentSimple($J,Key)= UpdateValue
	 	  		set ^CacheTempEPRUPSegmentSimple($J,Key,"SegmentCode")= UpdateSegmentCode
	 	  		set ^CacheTempEPRUPSegmentSimple($J,Key,"ValueCode")= UpdateValueCode
	 	 	}
 			SET Key = $ORDER(^CacheTempEPRSegmentSimple($J,Key))
	   	} 
 	}
 }
 
 
 // insert  the New Add SegmentSimple item to table
 set UpKey = $ORDER(^CacheTempEPRUPSegmentSimple($J,""))
 WHILE (UpKey'="") 
 {
	
	Set NewISegmentSimple = ##class(EPRinstance.ISegmentSimple).%New()  
	set NewISegmentSimple.InstanceDataID = ..InstanceDataID
	set NewISegmentSimple.PatientID = ..PatientID
	set NewISegmentSimple.EpisodeID = ..EpisodeID
	set NewISegmentSimple.ChartItemID = ..ChartItemID
	set NewISegmentSimple.ListNo = ..ListNo
	set NewISegmentSimple.TemplateID = ..TemplateID
	set NewISegmentSimple.TemplateVersion = ..TemplateVersion
	set NewISegmentSimple.TemplateID = ..TemplateID
	Set NewISegmentSimple.SegmentCode = $G(^CacheTempEPRUPSegmentSimple($J,UpKey,"SegmentCode"))
	Set NewISegmentSimple.SimpleItemCode = UpKey
	Set NewISegmentSimple.DataValue = $G(^CacheTempEPRUPSegmentSimple($J,UpKey))
	Set NewISegmentSimple.ValueCode = $G(^CacheTempEPRUPSegmentSimple($J,UpKey,"ValueCode"))
 	do NewISegmentSimple.%Save()	
	  
 	SET UpKey = $ORDER(^CacheTempEPRUPSegmentSimple($J,UpKey))	  
  }
}

}
