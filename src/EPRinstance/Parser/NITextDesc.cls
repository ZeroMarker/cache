Class EPRinstance.Parser.NITextDesc Extends NInstanceItem [ ProcedureBlock ]
{

//Property FormateInfo As %String;

//Property Text As %String;

/// modified on 2014-01-02 by houj
Property FormateInfo As %GlobalCharacterStream(LOCATION = "^CacheTempDHCEPRTextStream($J)");

Property Text As %GlobalCharacterStream(LOCATION = "^CacheTempDHCEPRTextStream($J)");

Method XMLDeserialize(ByRef reader As %XML.TextReader)
{
	while reader.Read()
  	{
	  	//b "s"
    	if ((reader.Name="Code") && (reader.NodeType = "element"))
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
   		Elseif ( (reader.Name="SubItems") && (reader.NodeType = "element"))
    	{
      		While reader.Read()
      		{ 
         		If (reader.NodeType = "element") && (reader.Name = "NISegment") 
         		{ 	
         			set newNISegment = ##class(NISegment).%New()
		   			d newNISegment.XMLDeserialize(reader)
           			d ..SubItems.Insert(newNISegment)
           			
           			//modified on 2014-01-02 by houj
           			//s ..Text = ..Text _ newNISegment.Text
           			do ..Text.Write(newNISegment.Text)
           		} 
         		ElseIf (reader.NodeType = "element") && (reader.Name = "NIFree") 
         		{ 
         			set newNIFree = ##class(NIFree).%New()
		   			d newNIFree.XMLDeserialize(reader)
           			d ..SubItems.Insert(newNIFree)
           			
           			//modified on 2014-01-02 by houj 
           			//s ..Text = ..Text _ newNIFree.Value 
           			do ..Text.Write(newNIFree.Value)
	     		}  
	     		Elseif ( (reader.Name="SubItems") && (reader.NodeType = "endelement"))
	     		{ 	Q } 
	   		}
   		}
  		Elseif (reader.Name="FormatRangeCollection") && (reader.NodeType = "element")
  		{
	  		//modified on 2014-01-02 by houj 
			//s ..FormateInfo = ..FormateInfo _ "<" _ reader.Name _ ">"  
			do ..FormateInfo.Write("<" _ reader.Name _ ">")
			
			While reader.Read()
			{
				if ( (reader.Name="RtfImageString") && (reader.NodeType = "element"))  
     			{	
     				do ..FormateInfo.Write("<" _ reader.Name _ ">")
     				
     				while reader.Read() 
        			{ 
        				b "s"
        				s tempNum= reader.Value
	      				if (tempNum'="")
	      				{
		     				set ACdataId= ##class(EPRservice.Util.CdataItem).GetCdataItemId(tempNum,..SessionSign)
		     				if '(ACdataId="0")
		     				{
			   					s ACdataItem= ##class(EPRservice.Util.CdataItem).%OpenId(ACdataId)  
			   					if (ACdataItem '= "")
			   					{
				   					do ACdataItem.CDATAStream.Rewind()
				   					while (ACdataItem.CDATAStream.AtEnd = 0)
				   					{
										d ..FormateInfo.Write(ACdataItem.CDATAStream.Read(10240)) 
				   					}
				   					s ACdataItem="" 
				   				}
			     			} 
		      			}
		      				      
	       				if (reader.Name="RtfImageString") && (reader.NodeType = "endelement")
           				{
	           				do ..FormateInfo.Write("</" _ reader.Name _ ">")   
           					Q  
           				}
         			} 	 
	    		}
	 			elseif (reader.NodeType="element")
	 			{ 	
	 				//modified on 2014-01-02 by houj 
	 				//s ..FormateInfo = ..FormateInfo _ "<" _ reader.Name _ ">" 
	 				do ..FormateInfo.Write("<" _ reader.Name _ ">")
	 			}
	 			ElseIf (reader.NodeType = "chars")  
	 			{ 	
	 				//modified on 2014-01-02 by houj 
	 				//s ..FormateInfo = ..FormateInfo _ reader.Value 
	 				do ..FormateInfo.Write(reader.Value)
	 			}
     			ElseIf (reader.Name="FormatRangeCollection") && (reader.NodeType = "endelement")
	 			{  	
	 				//modified on 2014-01-02 by houj 
	 				//s ..FormateInfo = ..FormateInfo _ "</" _ reader.Name _ ">"
	     			do ..FormateInfo.Write("</" _ reader.Name _ ">")
	     			Q 
	     		}
	 			Elseif (reader.NodeType = "endelement")  
	 			{	
	 				//modified on 2014-01-02 by houj 
	 				//s ..FormateInfo = ..FormateInfo _ "</" _ reader.Name _ ">"
	 				do ..FormateInfo.Write("</" _ reader.Name _ ">")
	 			}
		 		ElseIf (reader.NodeType = "emptyelement")  
	 			{	
	 				//modified on 2014-01-02 by houj 
	 				//s ..FormateInfo = ..FormateInfo _ "<" _ reader.Name _ "/>"
	 				do ..FormateInfo.Write("<" _ reader.Name _ "/>")	 
	 			} 	
	 		}
  		}	 
  		Elseif (reader.Name="NITextDesc") && (reader.NodeType = "endelement")
  		{  	Q  }
 
 	}
}

}
