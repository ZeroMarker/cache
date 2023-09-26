Class EPRinstance.IdxMgr.TextDesc Extends %RegisteredObject [ ProcedureBlock ]
{

Property ChartItemID As %String(TRUNCATE = 1);

Property EpisodeID As %String(TRUNCATE = 1);

Property ExistISimpleSubItems As list Of EPRinstance.ITextDescSimple;

Property ExistTextDescSubItems As list Of EPRinstance.ITextDesc;

Property InstanceDataID As %String(TRUNCATE = 1);

Property ListNo As %String(TRUNCATE = 1);

Property PatientID As %String(TRUNCATE = 1);

Property TemplateID As %String(TRUNCATE = 1);

Property TemplateVersion As %String(TRUNCATE = 1);

Property UpdateISimpleSubItems As list Of EPRinstance.Parser.NISimple;

Property UpdateTextDescSubItems As list Of EPRinstance.Parser.NITextDesc;

/// 打散TextDesc和TextDescSimple数据
Method BuildIndex(ANInstanceData As EPRinstance.Parser.NInstanceData)
{
 ///解析要打散的TextDesc和TextDescSimple数据
 do ..BuildListFromData(ANInstanceData)

 ///分析已经打散的TextDesc和TextDescSimple数据(哪些需要删除，哪些需要更新)
 do ..BuildListFromIndexGlobal()
	
 ///打散数据
 do ..UpdateIndex()
}

/// 解析要打散的TextDescSimple和TextDescSimple数据
Method BuildListFromData(ANInstanceData As EPRinstance.Parser.NInstanceData)
{
 ///初始化
 do ..UpdateTextDescSubItems.Clear()
 do ..UpdateISimpleSubItems.Clear()
 k ^CacheTempEPRTextDescSimple($J)

 set ABindKBCode = ANInstanceData.BindKBCode
 //debug
 set ^DHCEPRDebug("EPRinstance.IdxMgr.TextDesc","BindKBNode") = ABindKBCode  
 
 Set ItemCount= ANInstanceData.SubItems.Count()              
 for I = 1:1:ItemCount
 {           
 	set obj= ANInstanceData.SubItems.GetAt(I)
 	if obj.%ClassName()="NITextDesc"
 	{
	 	do ..UpdateTextDescSubItems.Insert(obj)
	 	///解析TextDesc内嵌的Segment	 
	 	do ..GetSegMentItemFormTextDesc(obj,ABindKBCode) 
	}
 	elseif obj.%ClassName()="NICluster"
 	{
	 	///解析Cluster内嵌的TextDesc
	 	do ..GetTextDescItemFormCluster(obj,ABindKBCode)
    } 	  
 }
}

/// 解析Cluster内嵌的TextDesc
Method GetTextDescItemFormCluster(ACluster As EPRinstance.Parser.NICluster, ABindKBCode As %String)
{
 for J=1:1:ACluster.SubItems.Count()
 {
	set obj= ACluster.SubItems.GetAt(J)
 	if obj.%ClassName()="NITextDesc"
 	{

		do ..UpdateTextDescSubItems.Insert(obj)
		///解析TextDesc内嵌的Segment	
		do ..GetSegMentItemFormTextDesc(obj,ABindKBCode) 
	}
 	elseif obj.%ClassName()="NICluster"
 	{
 		//recursion  NICluster
	 	do ..GetTextDescItemFormCluster(obj,ABindKBCode)
 	} 	  
  }
}

/// 解析TextDesc的内嵌Segment
Method GetSegMentItemFormTextDesc(ATextDesc As EPRinstance.Parser.NITextDesc, ABindKBCode As %String)
{
 set ATextDescCode = ATextDesc.Code
 for X=1:1:ATextDesc.SubItems.Count()
 {
	set obj= ATextDesc.SubItems.GetAt(X)
	if obj.%ClassName()="NISegment"
 	{
	  	Set AKBNodeID = obj.KBNodeID 
	  	Set ASegmentNumber = obj.SegmentNumber 
	  	///解析Segment的内嵌Simple单元数据
	  	do ..GetSimpleItemFromSegment(obj,ABindKBCode,AKBNodeID,ASegmentNumber,ATextDescCode) 
	}
 }
}

/// 解析Segment的内嵌Simple单元数据
Method GetSimpleItemFromSegment(ASegment As EPRinstance.Parser.NISegment, ABindKBCode As %String, AKBNodeID As %String, ASegmentNumber As %String, ATextDescCode As %String)
{
 for K=1:1:ASegment.SubItems.Count()
 {
	set obj= ASegment.SubItems.GetAt(K)
	if obj.%ClassName()="NISimple"
 	{
	  	do ..UpdateISimpleSubItems.Insert(obj)
	  	
	  	/******* comment on 2008-08-13 by houj             
	  	set ^CacheTempEPRTextDescSimple($J,obj.Code)= obj.Value
	  	set ^CacheTempEPRTextDescSimple($J,obj.Code,"TextDescCode")= ATextDescCode
	  	set ^CacheTempEPRTextDescSimple($J,obj.Code,"ValueCode")= obj.ValueCode
	  	set ^CacheTempEPRTextDescSimple($J,obj.Code,"BindKBCode")= ABindKBCode
	  	set ^CacheTempEPRTextDescSimple($J,obj.Code,"KBNodeID")= AKBNodeID
	  	set ^CacheTempEPRTextDescSimple($J,obj.Code,"KBPartNo")= ASegmentNumber
	  	*******/ 
	  	
	  	//added on 2008-08-13 by houj
	  	//引用知识库的多个节点时，不同节点(不同KBNodeID)下的结构化单元的SimpleItemCode可能相同
	  	//所以将^CacheTempEPRTextDescSimple的结构实现为：
	  	//^CacheTempEPRTextDescSimple($J,TextDescCode,KBNodeID,KBPartNo,SimpleItemCode)=Value
	  	if ((ATextDescCode'="")&&(AKBNodeID'="")&&(ASegmentNumber'="")&&(obj.Code'=""))
	  	{
	  	s ^CacheTempEPRTextDescSimple($J,ATextDescCode,AKBNodeID,ASegmentNumber,obj.Code)= obj.Value
	  	s ^CacheTempEPRTextDescSimple($J,ATextDescCode,AKBNodeID,ASegmentNumber,obj.Code,"ValueCode")= obj.ValueCode
	  	s ^CacheTempEPRTextDescSimple($J,ATextDescCode,AKBNodeID,ASegmentNumber,obj.Code,"BindKBCode")=ABindKBCode
	  	}
	}
 }
}

/// 分析已打散TextDesc和TexDescSimple数据，确定哪些需要删除，哪些需要更新
Method BuildListFromIndexGlobal()
{
 do ..BuildTextDescListFromIdxGlobal()
 
 do ..BuildTDSimpleFromIdxGlobal()
}

Method BuildTextDescListFromIdxGlobal()
{
 k ^CacheTempEPRExistToDelITextDesc($J)	
 do ..ExistTextDescSubItems.Clear()
 
 /******* comment on 2008-1-24 by houj, 对数据库表的遍历未使用索引
 set ITextDescKey = $ORDER(^DHCEPRI.ITextDescD(""))
 WHILE (ITextDescKey'="") 
 {
 Set LBITextDesc = $G(^DHCEPRI.ITextDescD(ITextDescKey)) 
 if ($LG(LBITextDesc,2) = ..InstanceDataID)  
 {
	 // set AID = $LG(LBISimple,1) 
	  Set ExistTemplateID = $LG(LBITextDesc,4)  
	  if (ExistTemplateID '= ..TemplateID) 
	  {
		set ^CacheTempEPRExistToDelITextDesc($J,ITextDescKey)= ExistTemplateID 
	   }
	  if (ExistTemplateID = ..TemplateID) 	  
	  {
		set objITextDesc = ##class(EPRinstance.ITextDesc).%OpenId(ITextDescKey)
		do ..ExistTextDescSubItems.Insert(objITextDesc)
		}
 }
 SET ITextDescKey = $ORDER(^DHCEPRI.ITextDescD(ITextDescKey))	  
 }
 *******/
 
 /// added on 2008-1-24 by houj
 /// use index to enhance the query efficiency
 s BlankInstanceDataID = " "_..InstanceDataID
 q:$d(^DHCEPRI.ITextDescI("IdxForUpdate",BlankInstanceDataID))=0
 s ITextDescCode=$O(^DHCEPRI.ITextDescI("IdxForUpdate",BlankInstanceDataID,""))
 while ITextDescCode '= ""
 {
	 s ITextDescKey=$O(^DHCEPRI.ITextDescI("IdxForUpdate",BlankInstanceDataID,ITextDescCode,""))
	 while ITextDescKey '= ""
	 {
		 s objITextDesc = ##class(EPRinstance.ITextDesc).%OpenId(ITextDescKey)
		 if objITextDesc.TemplateID '= ..TemplateID
		 {
			 set ^CacheTempEPRExistToDelITextDesc($J,ITextDescKey)= objITextDesc.TemplateID
		 }
		 else
		 {
			 do ..ExistTextDescSubItems.Insert(objITextDesc)
		 }
		 s ITextDescKey=$O(^DHCEPRI.ITextDescI("IdxForUpdate",BlankInstanceDataID,ITextDescCode,ITextDescKey))
	 }
	 s ITextDescCode=$O(^DHCEPRI.ITextDescI("IdxForUpdate",BlankInstanceDataID,ITextDescCode))
 }
 
 ///delete item
 set DelIDKey = $ORDER(^CacheTempEPRExistToDelITextDesc($J,""))	
 while (DelIDKey'="") 
 {
 	do ##class(EPRinstance.ITextDesc).%DeleteId(DelIDKey)   	 
 	set DelIDKey = $ORDER(^CacheTempEPRExistToDelITextDesc($J,DelIDKey))	   
 }
}

Method BuildTDSimpleFromIdxGlobal()
{
 k ^CacheTempEPRExistToDelITDSimple($J)	
 do ..ExistISimpleSubItems.Clear()
 
 /******* commnet on 2008-1-24 by houj, 对数据库表的遍历未使用索引 
 set ITDSimpleKey = $ORDER(^DHCEPRI.ITextDescSimpleD(""))
 WHILE (ITDSimpleKey'="") 
 {
 Set LBITDSimple = $G(^DHCEPRI.ITextDescSimpleD(ITDSimpleKey)) 
 if ($LG(LBITDSimple,2) = ..InstanceDataID)  
 {
	 // set AID = $LG(LBISimple,1) 
	  Set ExistTemplateID = $LG(LBITDSimple,4)
	 // set ^CacheTempEPRExistToDelITDSimple($J,ITDSimpleKey)= ExistTemplateID   
	  if (ExistTemplateID '= ..TemplateID) 
	  {
		set ^CacheTempEPRExistToDelITDSimple($J,ITDSimpleKey)= ExistTemplateID 
	   }
	  if (ExistTemplateID = ..TemplateID) 	  
	  {
		set objITDSimple = ##class(EPRinstance.ITextDescSimple).%OpenId(ITDSimpleKey)
		do ..ExistISimpleSubItems.Insert(objITDSimple)
		}
		
 }
 SET ITDSimpleKey = $ORDER(^DHCEPRI.ITextDescSimpleD(ITDSimpleKey))	  
 }
 *******/
 
 ///added on 2008-1-24 by houj
 ///use index to enhance the query efficiency
 s BlankInstanceDataID = " "_..InstanceDataID
 q:$d(^DHCEPRI.ITextDescSimpleI("IdxForUpdate",BlankInstanceDataID))=0
 s ITextDescCode=$O(^DHCEPRI.ITextDescSimpleI("IdxForUpdate",BlankInstanceDataID,""))
 while ITextDescCode '= ""
 {
	 s IKBNodeID=$O(^DHCEPRI.ITextDescSimpleI("IdxForUpdate",BlankInstanceDataID,ITextDescCode,""))
	 while IKBNodeID '= ""
	 {
		 s IKBPartNo=$O(^DHCEPRI.ITextDescSimpleI("IdxForUpdate",BlankInstanceDataID,ITextDescCode,IKBNodeID,""))
		 while IKBPartNo '= ""
		 {
			 s ISimpleItemCode=$O(^DHCEPRI.ITextDescSimpleI("IdxForUpdate",BlankInstanceDataID,ITextDescCode,IKBNodeID,IKBPartNo,""))
			 while ISimpleItemCode '= ""	
			 {
				 s ITDSimpleKey=$O(^DHCEPRI.ITextDescSimpleI("IdxForUpdate",BlankInstanceDataID,ITextDescCode,IKBNodeID,IKBPartNo,ISimpleItemCode,""))
				 while ITDSimpleKey '= ""
				 {
				 	s objITextDescSimple=##class(EPRinstance.ITextDescSimple).%OpenId(ITDSimpleKey)
				 	if objITextDescSimple.TemplateID '= ..TemplateID
		            {
			 			 set ^CacheTempEPRExistToDelITDSimple($J,ITDSimpleKey)= objITextDescSimple.TemplateID
		 			}
		 			else
		 			{
			 			 ///comment code blow by houjian@dhcc.com.cn, on 2008-3-11
			 			 ///do ..ExistISimpleSubItems.Insert(objITextDescSimple)
						 ///added by houjian@dhcc.com.cn, on 2008-3-11
 						 ///将所有和要保存的InstanceData相关的TextDescSimple项目删除
 						 set ^CacheTempEPRExistToDelITDSimple($J,ITDSimpleKey)= objITextDescSimple.TemplateID
		 			}
		 			s ITDSimpleKey=$O(^DHCEPRI.ITextDescSimpleI("IdxForUpdate",BlankInstanceDataID,ITextDescCode,IKBNodeID,IKBPartNo,ISimpleItemCode,ITDSimpleKey))
				 }
				 s ISimpleItemCode=$O(^DHCEPRI.ITextDescSimpleI("IdxForUpdate",BlankInstanceDataID,ITextDescCode,IKBNodeID,IKBPartNo,ISimpleItemCode))
			 }
			 s IKBPartNo=$O(^DHCEPRI.ITextDescSimpleI("IdxForUpdate",BlankInstanceDataID,ITextDescCode,IKBNodeID,IKBPartNo))
		 }
		 
		 s IKBNodeID=$O(^DHCEPRI.ITextDescSimpleI("IdxForUpdate",BlankInstanceDataID,ITextDescCode,IKBNodeID))
	 }
	 s ITextDescCode=$O(^DHCEPRI.ITextDescSimpleI("IdxForUpdate",BlankInstanceDataID,ITextDescCode))
 }
 
 
 ///delete the item
 set DelIDKey = $ORDER(^CacheTempEPRExistToDelITDSimple($J,""))	
 while (DelIDKey'="") 
 {
 	do ##class(EPRinstance.ITextDescSimple).%DeleteId(DelIDKey)   	 
 	set DelIDKey = $ORDER(^CacheTempEPRExistToDelITDSimple($J,DelIDKey))	   
 }
}

/// 打散数据
Method UpdateIndex()
{
 do ..UpdateTextDescIndex()	

 do ..UpdateTextDescSimpleIndex()
}

Method UpdateTextDescIndex()
{
 k ^CacheTempEPRTextDesc($J)
 k ^CacheTempEPRUPTextDesc($J)
 
 /// 初始化要保存的TextDesc信息到^CacheTempEPRTextDesc
 set UpdateCount =  ..UpdateTextDescSubItems.Count() 
 for J =1:1:UpdateCount
 {
 	set objNITextDesc= ..UpdateTextDescSubItems.GetAt(J)
 	//set ^CacheTempEPRTextDesc($J,objNITextDesc.Code)= objNITextDesc.Text
 	//set ^CacheTempEPRTextDesc($J,objNITextDesc.Code,"FormateInfo")= objNITextDesc.FormateInfo
 	set ^CacheTempEPRTextDesc($J,objNITextDesc.Code)= J
 	set ^CacheTempEPRTextDesc($J,objNITextDesc.Code,"FormateInfo")= J 
 }                                                       

 /// 将要保存的TextDesc单元分为两部分：
 /// 一、已保存过的，更新之；二、未保存过的，添加之
 set ExistCount= ..ExistTextDescSubItems.Count()
 if (ExistCount= 0)  
 { 	
 	/// 已保存的TextDesc单元为0，则所有要保存的单元都是需添加的单元
 	Merge ^CacheTempEPRUPTextDesc($J) = ^CacheTempEPRTextDesc($J) 
 } 
 elseif (ExistCount> 0)
 {      
 	if UpdateCount> 0
 	{
 		set Key = $ORDER(^CacheTempEPRTextDesc($J,""))
 		while (Key'="") 
 		{  
 			//是否为已保存过要更新的TextDesc单元
 			Set EquatFlag = "False"

			//modified on 2014-01-02 by houj
 			//Set UpdateText = $G(^CacheTempEPRTextDesc($J,Key))  
 			//Set UpdateFormateInfo = $G(^CacheTempEPRTextDesc($J,Key,"FormateInfo"))  
			set updateSubItemsIndex = $G(^CacheTempEPRTextDesc($J,Key)) 
			set updateNITextDesc = ..UpdateTextDescSubItems.GetAt(updateSubItemsIndex)
			
 			for K=1:1:ExistCount
 			{
 				set objNITextDesc =  ..ExistTextDescSubItems.GetAt(K)
 				///更新已保存过的TextDesc单元
 				if (objNITextDesc.TextDescCode = Key) 
 				{ 
 					Set EquatFlag = "True" 

	      			//Set TextStream= ##class(%GlobalCharacterStream).%New()
	      			//do TextStream.Write(UpdateText)
	      			//do objNITextDesc.Text.CopyFrom(TextStream) 
	      			do objNITextDesc.Text.CopyFrom(updateNITextDesc.Text)
	      			
	      			/*Set FormateInfoStream= ##class(%GlobalCharacterStream).%New()
	      			if (UpdateFormateInfo'="") 
	      			{
	      				do FormateInfoStream.Write(UpdateFormateInfo)
	      			}
	      			elseif (UpdateFormateInfo="") 	
	      			{
	      				do FormateInfoStream.Write("")	
		  			}
	      			do objNITextDesc.FormateInfo.CopyFrom(FormateInfoStream) 
					*/
					do objNITextDesc.FormateInfo.CopyFrom(updateNITextDesc.FormateInfo)
					
 					set objNITextDesc.TemplateVersion = ..TemplateVersion
 					
 					do objNITextDesc.%Save()  
 				}
 			}
 			
 			///创建将要添加的TextDesc单元列表
 			if (EquatFlag="False")
 			{
	 	 		set ^CacheTempEPRUPTextDesc($J, Key)= updateSubItemsIndex  
	 	 		set ^CacheTempEPRUPTextDesc($J, Key,"FormateInfo")= updateSubItemsIndex  
	 	   	}
	 	   	
 			SET Key = $ORDER(^CacheTempEPRTextDesc($J,Key))
	   } 
 	}
 }
 
 ///插入要添加的TextDesc单元
 set UpKey = $ORDER(^CacheTempEPRUPTextDesc($J,""))
 WHILE (UpKey'="") 
 {
	Set NewITextDesc = ##class(EPRinstance.ITextDesc).%New()  
	set NewITextDesc.InstanceDataID = ..InstanceDataID
	set NewITextDesc.PatientID = ..PatientID
	set NewITextDesc.EpisodeID = ..EpisodeID
	set NewITextDesc.ChartItemID = ..ChartItemID
	set NewITextDesc.ListNo = ..ListNo
	set NewITextDesc.TemplateID = ..TemplateID
	set NewITextDesc.TemplateVersion = ..TemplateVersion
	set NewITextDesc.TemplateID = ..TemplateID
	Set NewITextDesc.TextDescCode = UpKey
	
	/*
	Set TextStr = $G(^CacheTempEPRUPTextDesc($J,UpKey))
	Set TextStream= ##class(%GlobalCharacterStream).%New()
	do TextStream.Write(TextStr)
	do NewITextDesc.Text.CopyFrom(TextStream)
	 
	Set FormateInfoStr = $G(^CacheTempEPRUPTextDesc($J,UpKey,"FormateInfo")) 
	Set FormateInfoStream= ##class(%GlobalCharacterStream).%New()
	if (FormateInfoStr'="") 
	{
		do FormateInfoStream.Write(FormateInfoStr)
	}
	elseif (FormateInfoStr="") 	
	{
		do FormateInfoStream.Write("")	
	}
	do NewITextDesc.FormateInfo.CopyFrom(FormateInfoStream) 
	*/
	set updateSubItemsIndex = $G(^CacheTempEPRUPTextDesc($J,UpKey)) 
	set updateNITextDesc = ..UpdateTextDescSubItems.GetAt(updateSubItemsIndex)
	do NewITextDesc.Text.CopyFrom(updateNITextDesc.Text)
	do NewITextDesc.FormateInfo.CopyFrom(updateNITextDesc.FormateInfo) 
			
 	do NewITextDesc.%Save()	
	  
 	SET UpKey = $ORDER(^CacheTempEPRUPTextDesc($J,UpKey))	  
 }
}

Method UpdateTextDescSimpleIndex()
{
 K ^CacheTempEPRDelExistTextDescSimple($J)
 k ^CacheTempEPRUPTextDescSimple($J)

 /// 在BuildTDSimpleFromIdxGlobal()中已删除了所有相关的TextDescSimple单元数据
 /// 需插入所有要保存的TextDescSimple单元数据
 Merge ^CacheTempEPRUPTextDescSimple($J) = ^CacheTempEPRTextDescSimple($J)
 
 /// added on 2008-08-13 by houj
 /// 插入所有需要添加的TextDescSimple单元数据
 s TDCode = $O(^CacheTempEPRTextDescSimple($J,""))
 while TDCode '= ""
 {
	 s KBNodeID = $O(^CacheTempEPRTextDescSimple($J,TDCode,""))
	 while KBNodeID '= ""
	 {
		 s KBPartNo = $O(^CacheTempEPRTextDescSimple($J,TDCode,KBNodeID,""))
		 while KBPartNo '= ""
		 {
			 s SICode = $O(^CacheTempEPRTextDescSimple($J,TDCode,KBNodeID,KBPartNo,""))
			 while SICode '= ""
			 {
				 s NewITDSimple = ##class(EPRinstance.ITextDescSimple).%New()
				 if NewITDSimple '= ""
				 {
					 s NewITDSimple.InstanceDataID = ..InstanceDataID
					 s NewITDSimple.PatientID = ..PatientID
					 s NewITDSimple.EpisodeID = ..EpisodeID
					 s NewITDSimple.ChartItemID = ..ChartItemID
					 s NewITDSimple.ListNo = ..ListNo
					 s NewITDSimple.TemplateID = ..TemplateID
					 s NewITDSimple.TemplateVersion = ..TemplateVersion
					 
					 s NewITDSimple.TextDescCode = TDCode
					 s NewITDSimple.KBNodeID = KBNodeID
					 s NewITDSimple.KBPartNo = KBPartNo
					 s NewITDSimple.SimpleItemCode = SICode
					 s NewITDSimple.DataValue = ^CacheTempEPRTextDescSimple($J,TDCode,KBNodeID,KBPartNo,SICode)
					 s NewITDSimple.ValueCode = ^CacheTempEPRTextDescSimple($J,TDCode,KBNodeID,KBPartNo,SICode,"ValueCode")
                     s NewITDSimple.BindKBCode = ^CacheTempEPRTextDescSimple($J,TDCode,KBNodeID,KBPartNo,SICode,"BindKBCode")					 
	
 	                 d NewITDSimple.%Save()	
				 }  
				 s SICode = $O(^CacheTempEPRTextDescSimple($J,TDCode,KBNodeID,KBPartNo,SICode))
			 }
			 s KBPartNo = $O(^CacheTempEPRTextDescSimple($J,TDCode,KBNodeID,KBPartNo))
		 }
		 s KBNodeID = $O(^CacheTempEPRTextDescSimple($J,TDCode,KBNodeID))
	 }
	 s TDCode = $O(^CacheTempEPRTextDescSimple($J,TDCode))
 }
  
 /******* commented on 2008-08-13 by houj
 set UpKey = $ORDER(^CacheTempEPRUPTextDescSimple($J,""))
 WHILE (UpKey'="") 
 {
	Set NewITDSimple = ##class(EPRinstance.ITextDescSimple).%New()  
	set NewITDSimple.InstanceDataID = ..InstanceDataID
	set NewITDSimple.PatientID = ..PatientID
	set NewITDSimple.EpisodeID = ..EpisodeID
	set NewITDSimple.ChartItemID = ..ChartItemID
	set NewITDSimple.ListNo = ..ListNo
	set NewITDSimple.TemplateID = ..TemplateID
	set NewITDSimple.TemplateVersion = ..TemplateVersion
	
	set NewITDSimple.SimpleItemCode = UpKey
	
	set NewITDSimple.TextDescCode = $G(^CacheTempEPRUPTextDescSimple($J,UpKey,"TextDescCode"))
	set NewITDSimple.BindKBCode = $G(^CacheTempEPRUPTextDescSimple($J,UpKey,"BindKBCode"))
	set NewITDSimple.KBNodeID = $G(^CacheTempEPRUPTextDescSimple($J,UpKey,"KBNodeID"))
	set NewITDSimple.KBPartNo = $G(^CacheTempEPRUPTextDescSimple($J,UpKey,"KBPartNo"))
	set NewITDSimple.DataValue = $G(^CacheTempEPRUPTextDescSimple($J,UpKey))
	set NewITDSimple.ValueCode = $G(^CacheTempEPRUPTextDescSimple($J,UpKey,"ValueCode"))
 	do NewITDSimple.%Save()	
	  
 	SET UpKey = $ORDER(^CacheTempEPRUPTextDescSimple($J,UpKey))	  
 }
 *******/
}

/// ****************** Methods below are not used ***********************
Method OldBuildTDSimpleFromIdxGlobal()
{
 k ^CacheTempEPRExistToDelITDSimple($J)	
 // do ..ExistTextDescSubItems.Clear()
 do ..ExistISimpleSubItems.Clear()
 set ITDSimpleKey = $ORDER(^DHCEPRI.ITextDescSimpleD(""))

 WHILE (ITDSimpleKey'="") 
 {
 Set LBITDSimple = $G(^DHCEPRI.ITextDescSimpleD(ITDSimpleKey)) 
 if ($LG(LBITDSimple,2) = ..InstanceDataID)  
 {
	 // set AID = $LG(LBISimple,1) 
	  Set ExistTemplateID = $LG(LBITDSimple,4)  
	  if (ExistTemplateID '= ..TemplateID) 
	  {
		set ^CacheTempEPRExistToDelITDSimple($J,ITDSimpleKey)= ExistTemplateID 
	   }
	  if (ExistTemplateID = ..TemplateID) 	  
	  {
		set objITDSimple = ##class(EPRinstance.ITextDescSimple).%OpenId(ITDSimpleKey)
		do ..ExistISimpleSubItems.Insert(objITDSimple)
		}
 }
 SET ITDSimpleKey = $ORDER(^DHCEPRI.ITextDescSimpleD(ITDSimpleKey))	  
 }

 set DelIDKey = $ORDER(^CacheTempEPRExistToDelITDSimple($J,""))	
 WHILE (DelIDKey'="") 
 {
 do ##class(EPRinstance.ITextDescSimple).%DeleteId(DelIDKey)   	 
 SET DelIDKey = $ORDER(^CacheTempEPRExistToDelITDSimple($J,DelIDKey))	   
 }
}

Method OldUpdateTextDescSimpleIndex()
{
 //B "S"
 //k ^CacheTempEPRTDSimple($J)
 //^CacheTempEPRTextDescSimple
 //k ^CacheTempEPRUPTextDescSimple($J)
 K ^CacheTempEPRDelExistTextDescSimple($J)

 set UpdateCount =  ..UpdateISimpleSubItems.Count() 

 set ExistCount= ..ExistISimpleSubItems.Count()

 if (ExistCount= 0)  
 { Merge ^CacheTempEPRUPTextDescSimple($J) = ^CacheTempEPRTextDescSimple($J) } 
 elseif (ExistCount> 0)
 {      
 if UpdateCount> 0
 {
 set Key = $ORDER(^CacheTempEPRTextDescSimple($J,""))
 WHILE (Key'="") 
 {  
 //B "S"
 //insert update tag
 Set TextDescCodeEquatFlag = "False"
 set BindKBCodeEquatFlag = "False"
 set SimpleItemCodeEquatFlag = "False"
 set KBNodeIDEquatFlag = "False"
 set KBPartNoEquatFlag = "False"


 Set UpdateSimpleItemCode = Key 
 Set UpdateDataValue = $G(^CacheTempEPRTextDescSimple($J,Key)) 
 Set UpdateValueCode = $G(^CacheTempEPRTextDescSimple($J,Key,"ValueCode")) 
 Set UpdateTextDescCode = $G(^CacheTempEPRTextDescSimple($J,Key,"TextDescCode"))  
 Set UpdateBindKBCode = $G(^CacheTempEPRTextDescSimple($J,Key,"BindKBCode"))  
 Set UpdateKBNodeID = $G(^CacheTempEPRTextDescSimple($J,Key,"KBNodeID"))  
 Set UpdateKBPartNo = $G(^CacheTempEPRTextDescSimple($J,Key,"KBPartNo"))  


 for K=1:1:ExistCount
 {
 // //B "S"
 set objITDSimple =  ..ExistISimpleSubItems.GetAt(K)
 if (objITDSimple.TextDescCode = UpdateTextDescCode) 
 { 
 Set TextDescCodeEquatFlag = "True" 

 if (objITDSimple.BindKBCode = UpdateBindKBCode)
 {
	        Set BindKBCodeEquatFlag = "True"   
	        if (objITDSimple.KBNodeID = UpdateKBNodeID)
	        {
		      Set KBNodeIDEquatFlag = "True"  
		      if (objITDSimple.KBPartNo = UpdateKBPartNo)
		      {
			     set KBPartNoEquatFlag = "True" 
			     if (objITDSimple.SimpleItemCode = UpdateSimpleItemCode)
			     {
				   set SimpleItemCodeEquatFlag = "True"
				   //B "S"
				   if (objITDSimple.DataValue = UpdateDataValue)
				   {
					if (objITDSimple.ValueCode '= UpdateValueCode)
					{
					  Set objITDSimple.ValueCode= UpdateValueCode
					  Set objITDSimple.TemplateVersion = ..TemplateVersion
					  Do objITDSimple.%Save()	
						} 
					   
					 }
					 elseif (objITDSimple.DataValue '= UpdateDataValue)
					 {
					  Set objITDSimple.ValueCode= UpdateValueCode
					  Set objITDSimple.DataValue= UpdateDataValue
					  Set objITDSimple.TemplateVersion = ..TemplateVersion
					  Do objITDSimple.%Save()	
					 }  
				     
				     } 
			      }
		        
		        }  
	          }
 }
 }
 if (TextDescCodeEquatFlag="False")
 {
	 	 do ..UpdateTdSimpleCode(Key,UpdateDataValue,UpdateValueCode,UpdateTextDescCode,UpdateBindKBCode,UpdateKBNodeID,UpdateKBPartNo)
	 	 }
	 	 if (TextDescCodeEquatFlag="True") &(BindKBCodeEquatFlag="False")
	 	 {
		 do ..UpdateTdSimpleCode(Key,UpdateDataValue,UpdateValueCode,UpdateTextDescCode,UpdateBindKBCode,UpdateKBNodeID,UpdateKBPartNo)	 
		 }
		 if (TextDescCodeEquatFlag="True") &(BindKBCodeEquatFlag="True")&(KBNodeIDEquatFlag="False")
		 {
		 do ..UpdateTdSimpleCode(Key,UpdateDataValue,UpdateValueCode,UpdateTextDescCode,UpdateBindKBCode,UpdateKBNodeID,UpdateKBPartNo)	 	 
			 }	 
	 	 
		 if (TextDescCodeEquatFlag="True") &(BindKBCodeEquatFlag="True")&(KBNodeIDEquatFlag="True")&(KBPartNoEquatFlag="False")
		 {
		  do ..UpdateTdSimpleCode(Key,UpdateDataValue,UpdateValueCode,UpdateTextDescCode,UpdateBindKBCode,UpdateKBNodeID,UpdateKBPartNo)	 	 	 
	 	 	 }	 
		 if (TextDescCodeEquatFlag="True") &(BindKBCodeEquatFlag="True")&(KBNodeIDEquatFlag="True")&(KBPartNoEquatFlag="True")&(SimpleItemCodeEquatFlag="False")
		 {
			do ..UpdateTdSimpleCode(Key,UpdateDataValue,UpdateValueCode,UpdateTextDescCode,UpdateBindKBCode,UpdateKBNodeID,UpdateKBPartNo) 
	 	 }	 
	 	   
	 	   
 SET Key = $ORDER(^CacheTempEPRTextDescSimple($J,Key))
	   } 
 }

 for K=1:1:ExistCount
 {
 set objITDSimple =  ..ExistISimpleSubItems.GetAt(K)

 Set TextDescCodeEquatFlag = "False"
 set BindKBCodeEquatFlag = "False"
 set SimpleItemCodeEquatFlag = "False"
 set KBNodeIDEquatFlag = "False"
 set KBPartNoEquatFlag = "False"

 set Key = $ORDER(^CacheTempEPRTextDescSimple($J,""))
 WHILE (Key'="") 
 {
	       
	       Set UpdateSimpleItemCode = Key 
 Set UpdateDataValue = $G(^CacheTempEPRTextDescSimple($J,Key)) 
 Set UpdateValueCode = $G(^CacheTempEPRTextDescSimple($J,Key,"ValueCode")) 
 Set UpdateTextDescCode = $G(^CacheTempEPRTextDescSimple($J,Key,"TextDescCode"))  
 Set UpdateBindKBCode = $G(^CacheTempEPRTextDescSimple($J,Key,"BindKBCode"))  
 Set UpdateKBNodeID = $G(^CacheTempEPRTextDescSimple($J,Key,"KBNodeID"))  
 Set UpdateKBPartNo = $G(^CacheTempEPRTextDescSimple($J,Key,"KBPartNo"))  
	       
	       if (objITDSimple.TextDescCode =UpdateTextDescCode )
	       {
		     Set TextDescCodeEquatFlag = "True"  
 if (objITDSimple.BindKBCode = UpdateBindKBCode)
 {
	           Set BindKBCodeEquatFlag = "True"   
	           if (objITDSimple.KBNodeID = UpdateKBNodeID)
	           {
		         Set KBNodeIDEquatFlag = "True"  
		         if (objITDSimple.KBPartNo = UpdateKBPartNo)
		         {
			     set KBPartNoEquatFlag = "True" 
			     if (objITDSimple.SimpleItemCode = UpdateSimpleItemCode)
			      {
				   set SimpleItemCodeEquatFlag = "True"  
			      }
	             }
		       
		       }
		       } 
	       }
	       
	       
	       
 SET Key = $ORDER(^CacheTempEPRTextDescSimple($J,Key)) 	         
	    }
 if (TextDescCodeEquatFlag="False")
 {
	 	set ^CacheTempEPRDelExistTextDescSimple($J,objITDSimple.%Id())=objITDSimple.SimpleItemCode
	 	 }
	   if (TextDescCodeEquatFlag="True") &(BindKBCodeEquatFlag="False")
	 	 {
		 set ^CacheTempEPRDelExistTextDescSimple($J,objITDSimple.%Id())=objITDSimple.SimpleItemCode
		 }
	   if (TextDescCodeEquatFlag="True") &(BindKBCodeEquatFlag="True")&(KBNodeIDEquatFlag="False")
		 {
		set ^CacheTempEPRDelExistTextDescSimple($J,objITDSimple.%Id())=objITDSimple.SimpleItemCode
			 }	 
	 	 
		if (TextDescCodeEquatFlag="True") &(BindKBCodeEquatFlag="True")&(KBNodeIDEquatFlag="True")&&(KBPartNoEquatFlag="False")
		 {
		set ^CacheTempEPRDelExistTextDescSimple($J,objITDSimple.%Id())=objITDSimple.SimpleItemCode
	 	 	 }	 
		 if (TextDescCodeEquatFlag="True") &(BindKBCodeEquatFlag="True")&(KBNodeIDEquatFlag="True")&&(KBPartNoEquatFlag="True")&(SimpleItemCodeEquatFlag="False")
		 {
		set ^CacheTempEPRDelExistTextDescSimple($J,objITDSimple.%Id())=objITDSimple.SimpleItemCode
	 	 }	 

 }   




 }
 
 
 set UpKey = $ORDER(^CacheTempEPRUPTextDescSimple($J,""))
 WHILE (UpKey'="") 
 {
	
	Set NewITDSimple = ##class(EPRinstance.ITextDescSimple).%New()  
	set NewITDSimple.InstanceDataID = ..InstanceDataID
	set NewITDSimple.PatientID = ..PatientID
	set NewITDSimple.EpisodeID = ..EpisodeID
	set NewITDSimple.ChartItemID = ..ChartItemID
	set NewITDSimple.ListNo = ..ListNo
	set NewITDSimple.TemplateID = ..TemplateID
	set NewITDSimple.TemplateVersion = ..TemplateVersion
	//set NewITDSimple.SimpleItemCode = UpKey
	
	set NewITDSimple.SimpleItemCode = UpKey
	
	set NewITDSimple.TextDescCode = $G(^CacheTempEPRUPTextDescSimple($J,UpKey,"TextDescCode"))
	set NewITDSimple.BindKBCode = $G(^CacheTempEPRUPTextDescSimple($J,UpKey,"BindKBCode"))
	set NewITDSimple.KBNodeID = $G(^CacheTempEPRUPTextDescSimple($J,UpKey,"KBNodeID"))
	set NewITDSimple.KBPartNo = $G(^CacheTempEPRUPTextDescSimple($J,UpKey,"KBPartNo"))
	//set NewITDSimple.DataValue = $G(^CacheTempEPRUPTextDescSimple($J,UpKey,"DataValue"))
	set NewITDSimple.DataValue = $G(^CacheTempEPRUPTextDescSimple($J,UpKey))
	set NewITDSimple.ValueCode = $G(^CacheTempEPRUPTextDescSimple($J,UpKey,"ValueCode"))
 do NewITDSimple.%Save()	
	  
 SET UpKey = $ORDER(^CacheTempEPRUPTextDescSimple($J,UpKey))	  
	}
	
 set DelKey = $ORDER(^CacheTempEPRDelExistTextDescSimple($J,""))
 WHILE (DelKey'="") 
 {
 do ##class(EPRinstance.ITextDescSimple).%DeleteId(DelKey)

 SET UpKey = $ORDER(^CacheTempEPRDelExistTextDescSimple($J,DelKey))	    	  
	  }
}

Method UpdateTdSimpleCode(Akey As %String, ADataValue As %String, AValueCode As %String, ATextDescCode As %String, ABindKBCode As %String, AKBNodeID As %String, AKBPartNo As %String)
{
 set ^CacheTempEPRUPTextDescSimple($J,Akey)= ADataValue  
 set ^CacheTempEPRUPTextDescSimple($J,Akey,"ValueCode")= AValueCode  
 set ^CacheTempEPRUPTextDescSimple($J,Akey,"TextDescCode")= ATextDescCode  
 set ^CacheTempEPRUPTextDescSimple($J,Akey,"BindKBCode")= ABindKBCode  
 set ^CacheTempEPRUPTextDescSimple($J,Akey,"KBNodeID")= AKBNodeID  
 set ^CacheTempEPRUPTextDescSimple($J,Akey,"KBPartNo")= AKBPartNo
}

}
