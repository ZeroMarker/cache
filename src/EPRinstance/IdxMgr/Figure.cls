Class EPRinstance.IdxMgr.Figure Extends %RegisteredObject [ ProcedureBlock ]
{

Property ChartItemID As %String(TRUNCATE = 1);

Property EpisodeID As %String(TRUNCATE = 1);

Property InstanceDataID As %String(TRUNCATE = 1);

Property ListNo As %String(TRUNCATE = 1);

Property PatientID As %String(TRUNCATE = 1);

Property TemplateID As %String(TRUNCATE = 1);

Property TemplateVersion As %String(TRUNCATE = 1);

Property ExistSubItems As list Of EPRinstance.IFigure;

Property UpdateSubItems As list Of EPRinstance.Parser.NIFigureRow;

//Property UpSubItems As %ListOfObject;

Method BuildIndex(ANInstanceData As EPRinstance.Parser.NInstanceData)
{
 	do ..BuildListFromData(ANInstanceData)

 	do ..BuildListFromIndex()

 	do ..UpdateIndex()
}

Method BuildListFromData(ANInstanceData As EPRinstance.Parser.NInstanceData)
{
 	do ..UpdateSubItems.Clear()
 	set ItemCount= ANInstanceData.SubItems.Count()

 	for I = 1:1:ItemCount
 	{           
		set obj= ANInstanceData.SubItems.GetAt(I)
 		if obj.%ClassName()="NIFigure"
 		{
			do ..GetItemFromFigure(obj)
	  	}
 		elseif (obj.%ClassName()="NICluster")
 		{
 			do ..GetItemFromCluster(obj)
 		}  	  
 	}
}

Method GetItemFromFigure(ANIFigure As EPRinstance.Parser.NIFigure)
{
	s ItemCount = ANIFigure.SubItems.Count()
	for I = 1:1:ItemCount
	{
		s obj = ANIFigure.SubItems.GetAt(I)
		if obj.%ClassName() = "NIFigureRow"
		{
			do ..UpdateSubItems.Insert(obj)
		}
	}
}

Method GetItemFromCluster(ANICluster As EPRinstance.Parser.NICluster)
{
	s ItemCount = ANICluster.SubItems.Count()
	for I= 1:1:ItemCount
	{
		s obj = ANICluster.SubItems.GetAt(I)
		if obj.%ClassName() = "NIFigure"
		{
			do ..GetItemFromFigure(obj)
		}
		elseif obj.%ClassName() = "NICluster"
		{
			do ..GetItemFromCluster(obj)
		}
	}
}

Method BuildListFromIndex()
{
	kill ^CacheTempDHCEPRExistToDelFigure($J)
	
	//Index IdxForUpdate On (InstanceDataID, FigureCode, RowNumber) [ Unique ]
	s blankInstanceID = " "_..InstanceDataID
	s figureCode = $O(^DHCEPRI.IFigureI("IdxForUpdate",blankInstanceID,""))
	while figureCode '= ""
	{
		s rowNum = $O(^DHCEPRI.IFigureI("IdxForUpdate",blankInstanceID,figureCode,""))
		while rowNum '= ""
		{
			s rowid = $O(^DHCEPRI.IFigureI("IdxForUpdate",blankInstanceID,figureCode,rowNum,""))
			if rowid '= ""
			{
				s ^CacheTempDHCEPRExistToDelFigure($J,rowid) = rowid
			}
			
			s rowNum = $O(^DHCEPRI.IFigureI("IdxForUpdate",blankInstanceID,figureCode,rowNum))
		} 
		
		s figureCode = $O(^DHCEPRI.IFigureI("IdxForUpdate",blankInstanceID,figureCode))
	}
	
	s rowid = $O(^CacheTempDHCEPRExistToDelFigure($J,""))
	while rowid '= ""
	{
		do ##class(EPRinstance.IFigure).%DeleteId(rowid) 
		s rowid = $O(^CacheTempDHCEPRExistToDelFigure($J,rowid))
	}
}

Method UpdateIndex()
{
	b "s"
	s ItemCount = ..UpdateSubItems.Count()
	for I = 1:1:ItemCount
	{
		b "s"
		
		s obj = ..UpdateSubItems.GetAt(I)
		
		b "s"
		s newIFigure = ##class(EPRinstance.IFigure).%New()
		s newIFigure.InstanceDataID = ..InstanceDataID
		s newIFigure.PatientID = ..PatientID
		s newIFigure.EpisodeID = ..EpisodeID
		s newIFigure.ChartItemID = ..ChartItemID
		s newIFigure.ListNo = ..ListNo
		s newIFigure.TemplateID = ..TemplateID
		s newIFigure.TemplateVersion = ..TemplateVersion
	
		s newIFigure.FigureCode = obj.FigureCode
		s newIFigure.RowNumber = obj.RowNum
		//s newIFigure.DataValue = obj.Value
		//s newIFigure.ValueCode = obj.ValueCode
		s newIFigure.FigureDesc = obj.FigureDesc
		s newIFigure.FigureType = obj.FigureType
		s newIFigure.FigureID = obj.FigureID
		d newIFigure.FigureData.CopyFrom(obj.FigureData)
		d newIFigure.AnnoData.CopyFrom(obj.AnnoData)
    	d newIFigure.%Save()
    	
	}
}

/*
Method NeedDelete(rowNum As %String) As %Boolean
{
	s ItemCount = ..UpdateSubItems.Count()
	for I = 1:1:ItemCount
	{
		s obj = ..UpdateSubItems.GetAt(I)
	}
}
*/
}
