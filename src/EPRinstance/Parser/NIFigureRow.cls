Class EPRinstance.Parser.NIFigureRow Extends EPRinstance.Parser.NInstanceItem [ ProcedureBlock ]
{

Property FigureCode As %String(TRUNCATE = 1);

Property RowNum As %Integer;

Property FigureDesc As %String(TRUNCATE = 1);

Property FigureData As %GlobalCharacterStream(LOCATION = "^CacheTempDHCEPRFigureDataStream($J)");

Property FigureType As %String(TRUNCATE = 1);

Property FigureID As %String(TRUNCATE = 1);

Property AnnoData As %GlobalCharacterStream(LOCATION = "^CacheTempDHCEPRFigureDataStream($J)");

Method XMLDeserialize(ByRef reader As %XML.TextReader)
{
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
        		{ 	S DataValue = DataValue_ reader.Value  } 
        		if (reader.Name="ValueCode") && (reader.NodeType = "endelement")
        		{ 
        			s ..ValueCode = DataValue 
        			Q  
        		}
       		} 	 
	  	}
  		elseif ( (reader.Name="FigureDesc") && (reader.NodeType = "element"))
 		{	
 			s DataValue = ""	
   			while reader.Read()
   			{
	 			if (reader.Name="")  
	 			{ 
					 s DataValue = DataValue_reader.Value
        		}  
	 			elseif ((reader.Name="FigureDesc")&&(reader.NodeType = "endelement"))  
	 			{ 	
	 				s ..FigureDesc = DataValue
	 				Q 
	 			}
			}
 		}
 		elseif ((reader.Name="FigureData")&&(reader.NodeType = "element"))
 		{
	 		while reader.Read() 
        	{
          		s tempNum = reader.Value
	      		if (tempNum '= "")
	      		{
		     		s ACdataId= ##class(EPRservice.Util.CdataItem).GetCdataItemId(tempNum,..SessionSign)
		     		if (ACdataId '= "0")
		     		{
			   			s ACdataItem= ##class(EPRservice.Util.CdataItem).%OpenId(ACdataId)  
			   			if (ACdataItem '= "")
			   			{
							d ..FigureData.CopyFrom(ACdataItem.CDATAStream) 
							s ACdataItem="" 
				  	 	}
			     	} 
		      	}	      
	       		if (reader.Name="FigureData") && (reader.NodeType = "endelement")
           		{   Q  }
         	} 	 
	 	}
	 	elseif ((reader.Name="FigureType")&&(reader.NodeType = "element"))
 		{
	 		s DataValue =""
      		while reader.Read() 
      		{
	    		if (reader.Name="")
        		{ 	S DataValue = DataValue_ reader.Value  } 
        		if (reader.Name="FigureType") && (reader.NodeType = "endelement")
        		{ 
        			s ..FigureType = DataValue 
        			Q  
        		}
       		} 	 
	 	}
	 	elseif ((reader.Name="FigureID")&&(reader.NodeType = "element"))
 		{
	 		s DataValue =""
      		while reader.Read() 
      		{
	    		if (reader.Name="")
        		{ 	S DataValue = DataValue_ reader.Value  } 
        		if (reader.Name="FigureID") && (reader.NodeType = "endelement")
        		{ 
        			s ..FigureID = DataValue 
        			Q  
        		}
       		} 	 
	 	}
	 	elseif ((reader.Name="AnnoData")&&(reader.NodeType = "element"))
 		{
	 		while reader.Read() 
        	{
          		s tempNum = reader.Value
	      		if (tempNum '= "")
	      		{
		      		//b "s"
		     		s ACdataId= ##class(EPRservice.Util.CdataItem).GetCdataItemId(tempNum,..SessionSign)
		     		if (ACdataId '= "0")
		     		{
			   			s ACdataItem= ##class(EPRservice.Util.CdataItem).%OpenId(ACdataId)  
			   			if (ACdataItem '= "")
			   			{
							d ..AnnoData.CopyFrom(ACdataItem.CDATAStream) 
							s ACdataItem="" 
				  	 	}
			     	} 
		      	}	      
	       		if (reader.Name="AnnoData") && (reader.NodeType = "endelement")
           		{   Q  }
         	} 	 
	 	}
 		elseif ((reader.NodeType = "endelement") && (reader.Name="NIFigureRow"))
 		{ 	Q } 	     
	}
}

}
