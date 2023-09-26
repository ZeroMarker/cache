Class EPRinstance.Parser.NIFigure Extends EPRinstance.Parser.NInstanceItem [ ProcedureBlock ]
{

Property CurrentCount As %Integer;

Property HasFigure As %String(TRUNCATE = 1);

Method XMLDeserialize(ByRef reader As %XML.TextReader)
{
	s ARowNum = 0
	while reader.Read()
 	{
    	if ( (reader.Name="Code") && (reader.NodeType = "element"))
    	{
      		s CodeValue =""
      		while reader.Read() 
      		{
	    		if (reader.Name="")
        		{ 	S CodeValue= CodeValue_ reader.Value  } 
        		if (reader.Name="Code") && (reader.NodeType = "endelement")
       			{ 
	     			s ..Code=CodeValue
	     			Q 
	     		}
       		} 	 
		}
    	Elseif ( (reader.Name="Value") && (reader.NodeType = "element"))
    	{
      		s DataValue =""
      		while reader.Read() 
      		{
	    		if (reader.Name="")
        		{ 	S DataValue=DataValue_ reader.Value  } 
        		if (reader.Name="Value") && (reader.NodeType = "endelement")
        		{ 
        			s ..Value =DataValue  
         			Q  
         		}
       		} 	 
	  	}
    	Elseif ( (reader.Name="ValueCode") && (reader.NodeType = "element"))
    	{
      		s DataValue =""
      		while reader.Read() 
      		{
	    		if (reader.Name="")
        		{ 	S DataValue=DataValue_ reader.Value  } 
        		if (reader.Name="ValueCode") && (reader.NodeType = "endelement")
        		{ 
        			s ..ValueCode =DataValue 
        			Q  
        		}
       		} 	 
	  	}
  		elseif ( (reader.Name="SubItems") && (reader.NodeType = "element"))
 		{		
   			while reader.Read()
   			{
	 			if ((reader.Name="NIFigureRow") && (reader.NodeType = "element"))  
	 			{ 
					s ARowNum = ARowNum +1 
					s newNIFigureRow = ##class(EPRinstance.Parser.NIFigureRow).%New()
					s newNIFigureRow.SessionSign = ..SessionSign
					d newNIFigureRow.XMLDeserialize(reader)
					s newNIFigureRow.FigureCode = ..Code
					s newNIFigureRow.RowNum = ARowNum
        			d ..SubItems.Insert(newNIFigureRow) 
        		}  
	 			elseif ((reader.NodeType = "endelement") && (reader.Name="SubItems"))  
	 			{ 	Q }
			}
 		}
 		elseif ((reader.NodeType = "endelement") && (reader.Name="NIFigure"))
 		{ 	Q } 	     
	}
}

}
