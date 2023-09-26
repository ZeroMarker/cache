Class EPRinstance.Parser.NInstanceData Extends NInstanceItem [ ProcedureBlock ]
{

Property BindKBCode As %String(TRUNCATE = 1);

Property CurrentCount As %Integer;

Property HasAnnotate As %String(TRUNCATE = 1);

Method XMLDeserialize(ByRef reader As %XML.TextReader)
{
	set ..HasAnnotate="False"
		set ..CurrentCount=0
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
	  	Elseif ( (reader.Name="BindKBCode") && (reader.NodeType = "element"))
	  	{ 
	  		s DataValue =""
	    		while reader.Read() 
	    		{
	    		if (reader.Name="")
	      		{ 	S DataValue=DataValue_ reader.Value  } 
	      		if (reader.Name="BindKBCode") && (reader.NodeType = "endelement")
	      		{ 	
	      			s ..BindKBCode =DataValue  
	      			Q  
	      		}
	     		} 	 
	  	}
			elseif ( (reader.Name="SubItems") && (reader.NodeType = "element"))
			{
			While (reader.Read())  
			{ 
				If (reader.NodeType = "element") & (reader.Name = "NISimple") 
		 		{ 
		 			set newNISimple = ##class(NISimple).%New()
		   			d newNISimple.XMLDeserialize(reader)
	         			d ..SubItems.Insert(newNISimple) 
	         		} 
	     			ElseIf (reader.NodeType = "element") & (reader.Name = "NISegment") 
	       		{ 
	       			set newNISegment = ##class(NISegment).%New()
		   			d newNISegment.XMLDeserialize(reader)
	         			d ..SubItems.Insert(newNISegment) 
	         		} 
	     			ElseIf (reader.NodeType = "element") & (reader.Name = "NITextDesc") 
	       		{ 
	       			set newNITextDesc = ##class(NITextDesc).%New()
	       			set newNITextDesc.SessionSign = ..SessionSign 
		   			d newNITextDesc.XMLDeserialize(reader)
	         			d ..SubItems.Insert(newNITextDesc) 
	         		} 
	     			ElseIf (reader.NodeType = "element") & (reader.Name = "NITable") 
	        		{	
	          		set newNITable = ##class(NITable).%New()
					d newNITable.XMLDeserialize(reader)
	          		d ..SubItems.Insert(newNITable) 
	          	} 
	     			ElseIf (reader.NodeType = "element") & (reader.Name = "NIImageAnnotate") 
	        		{	
	          		set newNIAnnotate = ##class(EPRinstance.Parser.NIImageAnnotate).%New()
					s ..CurrentCount = ..CurrentCount+1
					s newNIAnnotate.SessionSign = ..SessionSign             
					d newNIAnnotate.XMLDeserialize(reader)
					s newNIAnnotate.CurrentCount = ..CurrentCount 
	          		d ..SubItems.Insert(newNIAnnotate) 
	          		if (newNIAnnotate.HasAnnotate="True")
	          		{ s ..HasAnnotate="True"}
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
	     			ElseIf (reader.NodeType = "element") & (reader.Name = "NICluster") 
	        		{	
	        			set newNICluster = ##class(NICluster).%New()
	          		s newNICluster.CurrentCount = ..CurrentCount
	          		s newNICluster.SessionSign = ..SessionSign
					d newNICluster.XMLDeserialize(reader)
	          		d ..SubItems.Insert(newNICluster)	
	          		s ..CurrentCount = newNICluster.CurrentCount	
	          		if (newNICluster.HasAnnotate="True")
	          		{ s ..HasAnnotate="True"}
	          	} 
	   			ElseIf (reader.NodeType = "endelement") & (reader.Name = "SubItems") 
		  		{	Quit }
			}
			}
			Elseif (reader.Name="NInstanceData") && (reader.NodeType = "endelement")
			{  	Quit  }
	
	}
}

Method FileImageAnnotate(AInstanceDataStream As %Stream)
{
	
	if (..HasAnnotate="False")	
	{ 
	 Q  }
	elseif (..HasAnnotate="True")
	{
	 Set ItemCount= ..SubItems.Count()
	 for O = 1:1:ItemCount
	{
	  set obj= ..SubItems.GetAt(O)
	  if (obj.%ClassName()="NIImageAnnotate")
	  { 
	  //get 
	  
	  d ..DisassembleStream(AInstanceDataStream,obj)  
	  }
	    elseif (obj.%ClassName()="NICluster")
	    {
	//	for  obj.SubItems
	  do ..DisassembleStreamFromCluster(AInstanceDataStream,obj)
	      } 	  
	  }           
	  }
}

Method DisassembleStreamFromCluster(AInstanceDataStream As %Stream, ACluster As EPRinstance.Parser.NICluster)
{
	for J= 1:1:ACluster.SubItems.Count()
	{
	set obj= ACluster.SubItems.GetAt(J)
	  
	  if obj.%ClassName()="NIImageAnnotate"
	  {
	d ..DisassembleStream(AInstanceDataStream,obj)  
	  }
	elseif obj.%ClassName()="NICluster"
	{
	//	recursion  NICluster
	 do ..DisassembleStreamFromCluster(AInstanceDataStream, obj)
	} 	  
	  }
}

Method DisassembleStream(AInsDataStream As %Stream, ANIAnnotate As EPRinstance.Parser.NIImageAnnotate)
{
	
	s BeginImageDataStartNum=-1
	s EndImageDataStartNum=-1
	d AInsDataStream.Rewind()
	for AnnotateIndex = 1:1:ANIAnnotate.CurrentCount
	{
	
	s BeginImageDataStartNum= AInsDataStream.FindAt(EndImageDataStartNum,"<AnnoData>")
	s EndImageDataStartNum= AInsDataStream.FindAt(BeginImageDataStartNum,"</AnnoData>")  
	  }
	
	d AInsDataStream.Rewind()
	
	
	if (ANIAnnotate.CurrentCount=1)
	{ d AInsDataStream.MoveTo(BeginImageDataStartNum+18)
	 set positon= BeginImageDataStartNum+19}
	Elseif (ANIAnnotate.CurrentCount>1)
	{ d AInsDataStream.MoveTo(BeginImageDataStartNum+17) 
	 set positon= BeginImageDataStartNum+18 }
	
	while (positon<(EndImageDataStartNum-4))
	{
	
	if ((positon+1000)<(EndImageDataStartNum-4))
	{ 
	  
	  s len=100
	  d AInsDataStream.Rewind()
	  d AInsDataStream.MoveTo(positon+1)
	  s Str=AInsDataStream.Read(len)
	  s positon= positon + len
	  d ANIAnnotate.AnnoData.Write(Str)
	}
	elseif ((positon+1000)>=(EndImageDataStartNum-4))    
	{ 
	  
	  s len = EndImageDataStartNum -4 - positon
	  d AInsDataStream.Rewind()
	  d AInsDataStream.MoveTo(positon+1)
	  s Str=AInsDataStream.Read(len)
	  s positon= positon + len
	  d ANIAnnotate.AnnoData.Write(Str) 
	  }  	
	}
}

ClassMethod testDeserialize()
{
	 S AAAStr ="<NInstanceData><Code>A0000</Code><Value /><ValueCode /><BindKBCode /><SubItems><NISimple><Code>S0002</Code><Value /><ValueCode /></NISimple><NISegment><Code>G0003</Code><Value /><ValueCode /><KBNodeID /><SegmentNumber /><SubItems><NISimple><Code>S0004</Code><Value>a</Value><ValueCode /></NISimple><NISimple><Code>S0005</Code><Value>ssss</Value><ValueCode /></NISimple><NISimple><Code>N0006</Code><Value>s</Value><ValueCode /></NISimple><NIFree><Code /><Value>,adfjsdkf.??1,??.</Value><ValueCode /></NIFree></SubItems><FormatRangeCollection><FormatRange><StartPos>20</StartPos><EndPos>25</EndPos><FontStruct><Name></Name><Size>9</Size><Unit>Point</Unit><Bold>False</Bold><GdiCharset>134</GdiCharset><GdiVerticalFont>False</GdiVerticalFont><Italic>False</Italic><Strikeout>False</Strikeout><Underline>False</Underline><Superscript>True</Superscript><Subscript>False</Subscript></FontStruct></FormatRange><FormatRange><StartPos>25</StartPos><EndPos>27</EndPos><FontStruct><Name></Name><Size>9</Size><Unit>Point</Unit><Bold>False</Bold><GdiCharset>134</GdiCharset><GdiVerticalFont>False</GdiVerticalFont><Italic>True</Italic><Strikeout>False</Strikeout><Underline>False</Underline><Superscript>False</Superscript><Subscript>False</Subscript></FontStruct></FormatRange></FormatRangeCollection></NISegment><NITextDesc><Code>E0001</Code><Value /><ValueCode /><SubItems /></NITextDesc><NISimple><Code>D0009</Code><Value>200624</Value><ValueCode>2006-2-4 99:99:99</ValueCode></NISimple></SubItems></NInstanceData>"
	 Set sc = ##class(%XML.TextReader).ParseString(AAAStr,.reader) 
	 Set newNInstanceData=##class(EPRinstance.Parser.NInstanceData).%New()
	 if ($$$ISOK(sc)) 
	 { 
	   do reader.Read()
	   do newNInstanceData.XMLDeserialize(reader) 	   	
	 }
}

}
