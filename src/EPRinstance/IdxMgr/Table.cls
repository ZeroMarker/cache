Class EPRinstance.IdxMgr.Table Extends %RegisteredObject [ ProcedureBlock ]
{

Property ChartItemID As %String(TRUNCATE = 1);

Property EpisodeID As %String(TRUNCATE = 1);

Property ExistTableSimpleSubItems As list Of EPRinstance.ITableSimple;

Property InstanceDataID As %String(TRUNCATE = 1);

Property ListNo As %String(TRUNCATE = 1);

Property PatientID As %String(TRUNCATE = 1);

Property TemplateID As %String(TRUNCATE = 1);

Property TemplateVersion As %String(TRUNCATE = 1);

Property UpdateISimpleSubItems As list Of EPRinstance.Parser.NITableSimple;

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
 do ..UpdateISimpleSubItems.Clear()

 k ^CacheTempEPRTableSimple($J)

 Set ItemCount= ANInstanceData.SubItems.Count()
 for I = 1:1:ItemCount
 {           
 set obj= ANInstanceData.SubItems.GetAt(I)
 // //B "S"
 if obj.%ClassName()="NITable"
 {
	 //B "S"
	 do ..GetSimpleitemForTable(obj) 
	  }
 elseif obj.%ClassName()="NICluster"
 {
	  do ..GetSimpleitemForCluster(obj)
 } 	  
 }
}

Method BuildListFromIndexGlobal()
{
 //B "S"  
 k ^CacheTempEPRExistToDelITableSimple($J)	
 do ..ExistTableSimpleSubItems.Clear()
 
 ///comment the code block below on 2008-1-23
 /*
 set ITableSimpleKey = $ORDER(^DHCEPRI.ITableSimpleD(""))
 WHILE (ITableSimpleKey'="") 
 {
 Set LBITableSimple = $G(^DHCEPRI.ITableSimpleD(ITableSimpleKey)) 
 if ($LG(LBITableSimple,2) = ..InstanceDataID)  
 {
	  //B "S"
	  Set ExistTemplateID = $LG(LBITableSimple,5)  
	  set ^CacheTempEPRExistToDelITableSimple($J,ITableSimpleKey)= ExistTemplateID 
 }
 SET ITableSimpleKey = $ORDER(^DHCEPRI.ITableSimpleD(ITableSimpleKey))	  
 }
 */
 
 ///add the code block below on 2008-1-24
 ///use index to enhance the query efficieny
 ///Index IdxForUpdate On (InstanceDataID, TableCode, SimpleItemCode, RowNumber) 
 s BlankInstanceDataID = " "_..InstanceDataID
 q:$d(^DHCEPRI.ITableSimpleI("IdxForUpdate",BlankInstanceDataID))=0
 s ITableCode=$O(^DHCEPRI.ITableSimpleI("IdxForUpdate",BlankInstanceDataID,""))
 while ITableCode '= ""
 {
	 s ITableSimpleCode=$O(^DHCEPRI.ITableSimpleI("IdxForUpdate",BlankInstanceDataID,ITableCode,""))
	 while ITableSimpleCode '= ""
	 {
		 s ITableRowNum=$O(^DHCEPRI.ITableSimpleI("IdxForUpdate",BlankInstanceDataID,ITableCode,ITableSimpleCode,""))
		 while ITableRowNum '= ""
		 {
			 s ITableSimpleKey=$O(^DHCEPRI.ITableSimpleI("IdxForUpdate",BlankInstanceDataID,ITableCode,ITableSimpleCode,ITableRowNum,""))
			 ///对于Table单元，将先删除其下所有已存基本单元
			 while ITableSimpleKey '= ""
			 {
				 s ^CacheTempEPRExistToDelITableSimple($J,ITableSimpleKey)= " "
				 s ITableSimpleKey=$O(^DHCEPRI.ITableSimpleI("IdxForUpdate",BlankInstanceDataID,ITableCode,ITableSimpleCode,ITableRowNum,ITableSimpleKey))
			 }
			 s ITableRowNum=$O(^DHCEPRI.ITableSimpleI("IdxForUpdate",BlankInstanceDataID,ITableCode,ITableSimpleCode,ITableRowNum))
		 }	  
		 s ITableSimpleCode=$O(^DHCEPRI.ITableSimpleI("IdxForUpdate",BlankInstanceDataID,ITableCode,ITableSimpleCode))
	 }
	 s ITableCode=$O(^DHCEPRI.ITableSimpleI("IdxForUpdate",BlankInstanceDataID,ITableCode))
 }

 
 //B "S"
 //do delete item
 set DelIDKey = $ORDER(^CacheTempEPRExistToDelITableSimple($J,""))	
 WHILE (DelIDKey'="") 
 {
 do ##class(EPRinstance.ITableSimple).%DeleteId(DelIDKey)   	 
 SET DelIDKey = $ORDER(^CacheTempEPRExistToDelITableSimple($J,DelIDKey))	   
 }
}

Method GetSimpleitemForCluster(ACluster As EPRinstance.Parser.NICluster)
{
 for J=1:1:ACluster.SubItems.Count()
 {
	set obj= ACluster.SubItems.GetAt(J)
 if obj.%ClassName()="NITable"
 {
	;B "S"
	do ..GetSimpleitemForTable(obj)
	}
 elseif obj.%ClassName()="NICluster"
 {
 //	recursion  NICluster
	 do ..GetSimpleitemForCluster(obj)
 } 	  
 }
}

Method GetSimpleitemForRow(ANIRow As EPRinstance.Parser.NIRow, ATableCode As %String)
{
 for K= 1:1:ANIRow.SubItems.Count()
 {
 set obj= ANIRow.SubItems.GetAt(K)
 if obj.%ClassName()="NITableSimple"
 {
	s obj.TableCode= ATableCode
	s obj.RowNum= ANIRow.RowNum 
	do ..UpdateISimpleSubItems.Insert(obj)
	  }
 }
}

Method GetSimpleitemForTable(ATable As EPRinstance.Parser.NITable)
{
	
 for J=1:1:ATable.SubItems.Count()
 {
	set obj= ATable.SubItems.GetAt(J)
 if obj.%ClassName()="NIRow"
 {
	;B "S"
	do ..GetSimpleitemForRow(obj,ATable.Code)
	}
 }
}

Method UpdateIndex()
{
 k ^CacheTempEPRTableSimple($J)
 ;k ^CacheTempEPRUPTableSimple($J)
 //B "S"
 set UpdateCount =  ..UpdateISimpleSubItems.Count() 
 For J =1:1:UpdateCount
 {
	
    set obj= ..UpdateISimpleSubItems.GetAt(J)
    
	Set NewITableSimple = ##class(EPRinstance.ITableSimple).%New()  
	set NewITableSimple.InstanceDataID = ..InstanceDataID
	set NewITableSimple.PatientID = ..PatientID
	set NewITableSimple.EpisodeID = ..EpisodeID
	set NewITableSimple.ChartItemID = ..ChartItemID
	set NewITableSimple.ListNo = ..ListNo
	set NewITableSimple.TemplateID = ..TemplateID
	set NewITableSimple.TemplateVersion = ..TemplateVersion
	
	set NewITableSimple.SimpleItemCode = obj.Code
	set NewITableSimple.TableCode = obj.TableCode
	set NewITableSimple.RowNumber = obj.RowNum
	set NewITableSimple.DataValue = obj.Value
	set NewITableSimple.ValueCode = obj.ValueCode
    do NewITableSimple.%Save()
 
 }
 
 /*set UpKey = $ORDER(^CacheTempEPRTableSimple($J,""))
 WHILE (UpKey'="") 
 {
	
	Set NewITableSimple = ##class(EPRinstance.ITableSimple).%New()  
	set NewITableSimple.InstanceDataID = ..InstanceDataID
	set NewITableSimple.PatientID = ..PatientID
	set NewITableSimple.EpisodeID = ..EpisodeID
	set NewITableSimple.ChartItemID = ..ChartItemID
	set NewITableSimple.ListNo = ..ListNo
	set NewITableSimple.TemplateID = ..TemplateID
	set NewITableSimple.TemplateVersion = ..TemplateVersion
	
	set NewITableSimple.SimpleItemCode = UpKey
	
	set NewITableSimple.TableCode = $G(^CacheTempEPRTableSimple($J,UpKey,"TableCode"))
	set NewITableSimple.RowNumber = $G(^CacheTempEPRTableSimple($J,UpKey,"RowNum"))
	set NewITableSimple.DataValue = $G(^CacheTempEPRTableSimple($J,UpKey))
	set NewITableSimple.ValueCode = $G(^CacheTempEPRTableSimple($J,UpKey,"ValueCode"))
 do NewITableSimple.%Save()	
	  
 SET UpKey = $ORDER(^CacheTempEPRTableSimple($J,UpKey))	  
	}*/
}

}
