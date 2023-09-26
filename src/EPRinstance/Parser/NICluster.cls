Class EPRinstance.Parser.NICluster Extends NInstanceItem [ ProcedureBlock ]
{

Property HasAnnotate As %String(TRUNCATE = 1);

Property CurrentCount As %Integer;

Method XMLDeserialize(ByRef reader As %XML.TextReader)
{
	S HasAnnotate="False"
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
		Elseif (reader.NodeType = "element") && (reader.Name = "SubItems") 
		{
	 		while reader.Read()
	 	{
	   		If (reader.NodeType = "element") && (reader.Name = "NISimple") 
	   		{  	
	   			set newNISimple = ##class(NISimple).%New()
	    		d newNISimple.XMLDeserialize(reader)
        		d ..SubItems.Insert(newNISimple) 
        	} 
      		ElseIf (reader.NodeType = "element") && (reader.Name = "NISegment") 
      		{ 
      			set newNISegment = ##class(NISegment).%New()
	    		d newNISegment.XMLDeserialize(reader)
        		d ..SubItems.Insert(newNISegment) 
        	} 
       		ElseIf (reader.NodeType = "element") && (reader.Name = "NITextDesc") 
       		{ 
       			set newNITextDesc = ##class(NITextDesc).%New()
	     		d newNITextDesc.XMLDeserialize(reader)
         		d ..SubItems.Insert(newNITextDesc) 
         	}
       		ElseIf (reader.NodeType = "element") && (reader.Name = "NITable") 
       		{ 
       			set newNITable = ##class(NITable).%New()
	     		d newNITable.XMLDeserialize(reader)
         		d ..SubItems.Insert(newNITable) 
         	} 
       		ElseIf (reader.NodeType = "element") & (reader.Name = "NIImageAnnotate") 
          	{	
            	set newNIAnnotate = ##class(EPRinstance.Parser.NIImageAnnotate).%New()
				s ..CurrentCount = ..CurrentCount + 1
				s newNIAnnotate.SessionSign=..SessionSign
				d newNIAnnotate.XMLDeserialize(reader)
				s newNIAnnotate.CurrentCount = ..CurrentCount
            	d ..SubItems.Insert(newNIAnnotate) 
            	s ..HasAnnotate="True"
            }
            elseif (reader.NodeType = "element")&(reader.Name = "NIFigure")
            {
	            //added on 2008-11-17 by houj
	            s newNIFigure = ##class(EPRinstance.Parser.NIFigure).%New()
	            //s newNIFigure.CurrentCount = ..CurrentCount
	            s newNIFigure.SessionSign = ..SessionSign
	            d newNIFigure.XMLDeserialize(reader)
	            d ..SubItems.Insert(newNIFigure)
	            //s ..CurrentCount = newNIFIgure.CurrentCount
	        }  
       		ElseIf (reader.NodeType = "element") && (reader.Name = "NICluster") 
      		{ 
      			set newNICluster = ##class(NICluster).%New()
	   			S newNICluster.SessionSign= ..SessionSign 
	   			S newNICluster.CurrentCount= ..CurrentCount 
	   			d newNICluster.XMLDeserialize(reader)
	   			S ..CurrentCount= newNICluster.CurrentCount 
       			d ..SubItems.Insert(newNICluster) 
         		if (newNICluster.HasAnnotate="True")
         		{ 	s ..HasAnnotate="True"}
       		} 
      		ElseIf (reader.NodeType = "endelement") & (reader.Name = "SubItems") 
       		{	Quit }
	  	}
	}
    Elseif (reader.Name="NICluster") && (reader.NodeType = "endelement")
    {  Quit  }
 }
}

}
