Class EPRmeta.Parser.NISegment Extends EPRmeta.Parser.NMetaDataItem [ ProcedureBlock ]
{

Property TemplateID As %String(TRUNCATE = 1);

Property TemplateVersion As %String(TRUNCATE = 1);

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
        { S CodeValue= CodeValue_ reader.Value  } 
        if (reader.Name="Code") && (reader.NodeType = "endelement")
       { s ..Code=CodeValue
	     Q }
       } 	 
	}
	
	elseif ((reader.NodeType = "element") &&  (reader.Name="Text"))
	{
      s TextValue =""
      while reader.Read() 
      {
	    if (reader.Name="")
        { S TextValue= TextValue_ reader.Value  } 
        if (reader.Name="Text") && (reader.NodeType = "endelement")
       { 
	     s ..Text=TextValue
	      
	     Q }
       } 	 
		}
	Elseif (reader.NodeType = "element") && (reader.Name = "SubItems") 
	{
	 while reader.Read()
	 {
        If (reader.NodeType = "element") && (reader.Name = "MIString") 
        {
           set newNIString = ##class(EPRmeta.Parser.NIString).%New()
           d newNIString.XMLDeserialize(reader)
           s newNIString.Parent=##this
           s ^CacheTemp($j,"newNIString",newNIString.Code,newNIString.Text)=newNIString.Code_"^"_newNIString.Text_"^"_newNIString.Parent.Code
	       d ..SubItems.Insert(newNIString)
	        }
	    Elseif (reader.Name="MIString") && (reader.NodeType = "endelement")
        {  Quit  }
  
        ElseIf (reader.NodeType = "element") && (reader.Name = "MIQuantity") 
        {
           set newNIQuantity = ##class(EPRmeta.Parser.NIQuantity).%New()
           d newNIQuantity.XMLDeserialize(reader)
           s newNIQuantity.Parent=##this
	       s ^CacheTemp($j,"newNIQuantity",newNIQuantity.Code,newNIQuantity.Text)=newNIQuantity.Code_"^"_newNIQuantity.Text_"^"_newNIQuantity.Parent.Code
	       d ..SubItems.Insert(newNIQuantity)
	        }
	    Elseif (reader.Name="MIQuantity") && (reader.NodeType = "endelement")
        {  Quit  }
	        
        ElseIf (reader.NodeType = "element") && (reader.Name = "MINumber") 
        {
           set newNINumber = ##class(EPRmeta.Parser.NINumber).%New()
           d newNINumber.XMLDeserialize(reader)
           s newNINumber.Parent=##this
	       s ^CacheTemp($j,"newNINumber",newNINumber.Code,newNINumber.Text)=newNINumber.Code_"^"_newNINumber.Text_"^"_newNINumber.Parent.Code
	       d ..SubItems.Insert(newNINumber)
	        }
	     Elseif (reader.Name="MINumber") && (reader.NodeType = "endelement")
         {  Quit  }
	        
	    ElseIf (reader.NodeType = "element") && (reader.Name = "MIMultiChoice") 
        {
           set newNIMultiChoice = ##class(EPRmeta.Parser.NIMultiChoice).%New()
           d newNIMultiChoice.XMLDeserialize(reader)
           s newNIMultiChoice.Parent=##this
	       s ^CacheTemp($j,"newNIMultiChoice",newNIMultiChoice.Code,newNIMultiChoice.Text)=newNIMultiChoice.Code_"^"_newNIMultiChoice.Text_"^"_newNIMultiChoice.Parent.Code
	       d ..SubItems.Insert(newNIMultiChoice)
	        }
	    Elseif (reader.Name="MIMultiChoice") && (reader.NodeType = "endelement")
        {  Quit  }
	        
	    ElseIf (reader.NodeType = "element") && (reader.Name = "MIMonoChoice") 
        {
           set newNIMonoChoice = ##class(EPRmeta.Parser.NIMonoChoice).%New()
           d newNIMonoChoice.XMLDeserialize(reader)
           s newNIMonoChoice.Parent=##this
	       s ^CacheTemp($j,"newNIMonoChoice",newNIMonoChoice.Code,newNIMonoChoice.Text)=newNIMonoChoice.Code_"^"_newNIMonoChoice.Text_"^"_newNIMonoChoice.Parent.Code
	       d ..SubItems.Insert(newNIMonoChoice)
	        } 
	    Elseif (reader.Name="MIMonoChoice") && (reader.NodeType = "endelement")
        {  Quit  }
	        
	    ElseIf (reader.NodeType = "element") && (reader.Name = "MILink") 
        {
           set newNILink = ##class(EPRmeta.Parser.NILink).%New()
           d newNILink.XMLDeserialize(reader)
           s newNILink.Parent=##this
	       s ^CacheTemp($j,"newNILink",newNILink.Code,newNILink.Text)=newNILink.Code_"^"_newNILink.Text_"^"_newNILink.Parent.Code
	       d ..SubItems.Insert(newNILink)
	        } 
	    Elseif (reader.Name="MILink") && (reader.NodeType = "endelement")
        {  Quit  }
	        
	    ElseIf (reader.NodeType = "element") && (reader.Name = "MIDictionary") 
        {
           set newNIDictionary = ##class(EPRmeta.Parser.NIDictionary).%New()
           d newNIDictionary.XMLDeserialize(reader)
	       s newNIDictionary.Parent=##this
	       s ^CacheTemp($j,"newNIDictionary",newNIDictionary.Code,newNIDictionary.Text)=newNIDictionary.Code_"^"_newNIDictionary.Text_"^"_newNIDictionary.Parent.Code
	       d ..SubItems.Insert(newNIDictionary)
	        } 
	    Elseif (reader.Name="MIDictionary") && (reader.NodeType = "endelement")
        {  Quit  }
	     
	    ElseIf (reader.NodeType = "element") && (reader.Name = "MIPosition") 
        {
           set newNIPosition = ##class(EPRmeta.Parser.NIPosition).%New()
           d newNIPosition.XMLDeserialize(reader)
	       s newNIPosition.Parent=##this
	       s ^CacheTemp($j,"newNIPosition",newNIPosition.Code,newNIPosition.Text)=newNIPosition.Code_"^"_newNIPosition.Text_"^"_newNIPosition.Parent.Code
	       d ..SubItems.Insert(newNIPosition)
	        } 
	    Elseif (reader.Name="MIPosition") && (reader.NodeType = "endelement")
        {  Quit  }
	    
	    ElseIf (reader.NodeType = "element") && (reader.Name = "MIDateTime") 
        {
           set newNIDateTime = ##class(EPRmeta.Parser.NIDateTime).%New()
           d newNIDateTime.XMLDeserialize(reader)
           s newNIDateTime.Parent=##this
	       s ^CacheTemp($j,"newNIDateTime",newNIDateTime.Code,newNIDateTime.Text)=newNIDateTime.Code_"^"_newNIDateTime.Text_"^"_newNIDateTime.Parent.Code
	       d ..SubItems.Insert(newNIDateTime)
	        }
	     Elseif (reader.Name="MIDateTime") && (reader.NodeType = "endelement")
         {  Quit  }
	        	        	        	        	               	        	        		
	   If (reader.NodeType = "endelement") & (reader.Name = "SubItems") {									
			Quit	}	 
	 }
	}
	Elseif (reader.Name="MISegment") && (reader.NodeType = "endelement")
    {  Quit  }
  }
}

}
