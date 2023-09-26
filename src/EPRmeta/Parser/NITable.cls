Class EPRmeta.Parser.NITable Extends EPRmeta.Parser.NMetaDataItem [ ProcedureBlock ]
{

Property TemplateID As %String(TRUNCATE = 1);

Property TemplateVersion As %String(TRUNCATE = 1);

/// XML反序列化
Method XMLDeserialize(ByRef reader As %XML.TextReader)
{
	while reader.Read()
  	{
	  	///取code
		if ( (reader.Name="Code") && (reader.NodeType = "element"))
	  	{
			s CodeValue =""
      	  	while reader.Read() 
      	  	{
	      		if (reader.Name="")
              	{
	            	S CodeValue= CodeValue_ reader.Value
	          	} 
        	  	if (reader.Name="Code") && (reader.NodeType = "endelement")
       		  	{
	       			s ..Code=CodeValue
	     		  	Q 
	     	  	}
          	}
      	}
      	///取text
	  	ElseIf ( (reader.Name="Text")&&(reader.NodeType = "element") )
	  	{
			s TextValue =""
            while reader.Read() 
          	{
	        	if (reader.Name="")
	          	{
		          	S TextValue= TextValue_ reader.Value
		      	} 
		      	if (reader.Name="Text") && (reader.NodeType = "endelement")
		      	{ 
	     			s ..Text=TextValue 
	     		  	Q
	     	  	}
       	  	} 	 
	  	}
	  	///取嵌套单元
	  	Elseif (reader.NodeType = "element") && (reader.Name = "SubItems") 
	  	{
		    ///解析嵌套的单元
	 	 	while reader.Read()
	 	  	{
		 	 	///字符单元
		 		If (reader.NodeType = "element") && (reader.Name = "MIString") 
        	  	{
	        	  	set newNIString = ##class(EPRmeta.Parser.NIString).%New()
                    d newNIString.XMLDeserialize(reader)
                    s newNIString.Parent=##this
                    d ..SubItems.Insert(newNIString)
	            }
	            Elseif (reader.Name="MIString") && (reader.NodeType = "endelement")
              	{  
              	    Quit  
                }
              	///数量单元
              	ElseIf (reader.NodeType = "element") && (reader.Name = "MIQuantity") 
        	  	{
           		    set newNIQuantity = ##class(EPRmeta.Parser.NIQuantity).%New()
           		    d newNIQuantity.XMLDeserialize(reader)
           		    s newNIQuantity.Parent=##this
	       		    d ..SubItems.Insert(newNIQuantity)
	          	}
	    	  	Elseif (reader.Name="MIQuantity") && (reader.NodeType = "endelement")
              	{  
              	    Quit  
              	}
              	///单选单元
              	ElseIf (reader.NodeType = "element") && (reader.Name = "MIMonoChoice") 
              	{
		            set newNIMonoChoice = ##class(EPRmeta.Parser.NIMonoChoice).%New()
           		    d newNIMonoChoice.XMLDeserialize(reader)
                    s newNIMonoChoice.Parent=##this
	                d ..SubItems.Insert(newNIMonoChoice)
	          	} 
        	  	Elseif (reader.Name="MIMonoChoice") && (reader.NodeType = "endelement")
              	{   
              	    Quit  
              	}
              	///多选单元
              	ElseIf (reader.NodeType = "element") && (reader.Name = "MIMultiChoice") 
        	  	{
           		    set newNIMultiChoice = ##class(EPRmeta.Parser.NIMultiChoice).%New()
                    d newNIMultiChoice.XMLDeserialize(reader)
           		    s newNIMultiChoice.Parent=##this
	        	    d ..SubItems.Insert(newNIMultiChoice)
	        	}
	    		Elseif (reader.Name="MIMultiChoice") && (reader.NodeType = "endelement")
        		{   
        			Quit  
        	    }
        		///日期时间单元
        		ElseIf (reader.NodeType = "element") && (reader.Name = "MIDateTime") 
        		{
           			set newNIDateTime = ##class(EPRmeta.Parser.NIDateTime).%New()
           			d newNIDateTime.XMLDeserialize(reader)
           			s newNIDateTime.Parent=##this
	       			d ..SubItems.Insert(newNIDateTime)
	        	}
	     		Elseif (reader.Name="MIDateTime") && (reader.NodeType = "endelement")
         		{  
         			Quit  
         		}
        		///字典单元
        		ElseIf (reader.NodeType = "element") && (reader.Name = "MIDictionary") 
        		{
           			set newNIDictionary = ##class(EPRmeta.Parser.NIDictionary).%New()
           			d newNIDictionary.XMLDeserialize(reader)
	       			s newNIDictionary.Parent=##this
	       			d ..SubItems.Insert(newNIDictionary)
	        	} 
	    		Elseif (reader.Name="MIDictionary") && (reader.NodeType = "endelement")
        		{  	
        			Quit
        		}   
        		///数值单元
        		ElseIf (reader.NodeType = "element") && (reader.Name = "MINumber") 
        		{
           			set newNINumber = ##class(EPRmeta.Parser.NINumber).%New()
           			d newNINumber.XMLDeserialize(reader)
           			s newNINumber.Parent=##this
	       			d ..SubItems.Insert(newNINumber)
	        	}
	     		Elseif (reader.Name="MINumber") && (reader.NodeType = "endelement")
         		{  
         			Quit
         		}
        		///位置单元
        		ElseIf (reader.NodeType = "element") && (reader.Name = "MIPosition") 
        		{
           			set newNIPosition = ##class(EPRmeta.Parser.NIPosition).%New()
           			d newNIPosition.XMLDeserialize(reader)
           			s newNIPosition.Parent=##this
	       			d ..SubItems.Insert(newNIPosition)
	        	}
	     		Elseif (reader.Name="MIPosition") && (reader.NodeType = "endelement")
         		{  
         			Quit
         		}
         		
        		///解析嵌套单元结束 
	   	  	    If (reader.NodeType = "endelement") & (reader.Name = "SubItems")
	   	  	  	{									
			  	    Quit	
	          	}	 
	      	}
	    }
	  	Elseif (reader.Name="MITable") && (reader.NodeType = "endelement")
      	{  
        	Quit  
      	}
      	      
    }	
 ///end of method XMLDeserialize
}

///  end of class

}
