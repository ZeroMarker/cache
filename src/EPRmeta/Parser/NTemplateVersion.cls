Class EPRmeta.Parser.NTemplateVersion Extends EPRmeta.Parser.NMetaDataItem [ ProcedureBlock ]
{

Property TemplateID As %String(TRUNCATE = 1);

Property TemplateVersion As %Integer;

Property Text As %String(TRUNCATE = 1);

Property GUID As %String(MAXLEN = 36, TRUNCATE = 1);

Property CurrentCount As %Integer;

Property HasAnnotate As %String(TRUNCATE = 1);

Method XMLDeserialize(ByRef reader As %XML.TextReader)
{
  set ..HasAnnotate="False"
  set ..CurrentCount=0
  
  While (reader.Read())	
  {
	if ((reader.NodeType = "element") &&  (reader.Name="Code"))
    {
      s CodeValue =""
      while reader.Read() 
      {
	    if (reader.Name="")
        { S CodeValue= CodeValue_ reader.Value  } 
        if (reader.Name="Code") && (reader.NodeType = "endelement")
       { 
	     s ..Code=CodeValue
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
	elseif ((reader.NodeType = "element") &&  (reader.Name="GUID"))
	{
      s GUIDValue =""
      while reader.Read() 
      {
	    if (reader.Name="")
        { S GUIDValue= GUIDValue_ reader.Value  } 
        if (reader.Name="GUID") && (reader.NodeType = "endelement")
       { s ..GUID=GUIDValue
	      
	     Q }
       } 	 
		}
	elseif ((reader.Name="SubItems") && (reader.NodeType = "element")) 	
	{
	   While (reader.Read())  
	   { 
	     If (reader.NodeType = "element") & (reader.Name = "MIImageAnnotate") 
		 { 
		   ;w "MIImageAnnotate Name = "_reader.Name,!
		   ;s ^AA($J,"MIImageAnnotate")="OK"
		   set newNIAnnotate = ##class(EPRmeta.Parser.NIAnnotate).%New()
		   set newNIAnnotate.SessionSign=..SessionSign
		   d newNIAnnotate.XMLDeserialize(reader)
		   
		   s ..CurrentCount = ..CurrentCount+1
		   ;S ^AA($J,"NIAnnotate")= ..CurrentCount
		   ;s ^AA($J,"MIImageAnnotate","CurrentCount")=..CurrentCount
		   s newNIAnnotate.TemplateID = ..TemplateID
		   ;s ^AA($J,"MIImageAnnotate","TemplateID")=..TemplateID
		   s newNIAnnotate.TemplateVersion = ..TemplateVersion
		   s newNIAnnotate.CurrentCount = ..CurrentCount
           d ..SubItems.Insert(newNIAnnotate) 
           s ..HasAnnotate="True"
           } 
       ElseIf (reader.NodeType = "element") & (reader.Name = "MICluster") 
	   { s newNICluster = ##class(EPRmeta.Parser.NICluster).%New()
 		 s newNICluster.TemplateID = ..TemplateID
 		 s newNICluster.SessionSign =..SessionSign
		 s newNICluster.TemplateVersion = ..TemplateVersion
		 s newNICluster.CurrentCount = ..CurrentCount
		 d newNICluster.XMLDeserialize(reader)
         d ..SubItems.Insert(newNICluster)
         s ..CurrentCount = newNICluster.CurrentCount	
         if (newNICluster.HasAnnotate="True")
         { s ..HasAnnotate="True"}
         }
        ElseIf (reader.NodeType = "element") && (reader.Name = "MISegment") 
        {
           set newNISegment = ##class(EPRmeta.Parser.NISegment).%New()
           d newNISegment.XMLDeserialize(reader)
           s newNISegment.Parent=##this
	       d ..SubItems.Insert(newNISegment)
	        }
        ElseIf (reader.NodeType = "element") && (reader.Name = "MITextDesc") 
        {
           set newNITextDesc = ##class(EPRmeta.Parser.NITextDesc).%New()
           d newNITextDesc.XMLDeserialize(reader)
	       d ..SubItems.Insert(newNITextDesc)
	        }
        ElseIf (reader.NodeType = "element") && (reader.Name = "MITable") 
        {
           set newNITable = ##class(EPRmeta.Parser.NITable).%New()
           d newNITable.XMLDeserialize(reader)
           s newNITable.Parent=##this
	       d ..SubItems.Insert(newNITable)
	        }
        ElseIf (reader.NodeType = "element") && (reader.Name = "MIString") 
        {
           set newNIString = ##class(EPRmeta.Parser.NIString).%New()
           d newNIString.XMLDeserialize(reader)
	       s newNIString.Parent=##this
	       d ..SubItems.Insert(newNIString)
	        }
        ElseIf (reader.NodeType = "element") && (reader.Name = "MIQuantity") 
        {
           set newNIQuantity = ##class(EPRmeta.Parser.NIQuantity).%New()
           d newNIQuantity.XMLDeserialize(reader)
           s newNIQuantity.Parent=##this
	       d ..SubItems.Insert(newNIQuantity)
	        }
        ElseIf (reader.NodeType = "element") && (reader.Name = "MINumber") 
        {
           set newNINumber = ##class(EPRmeta.Parser.NINumber).%New()
           d newNINumber.XMLDeserialize(reader)
           s newNINumber.Parent=##this
	       d ..SubItems.Insert(newNINumber)
	        }
	    ElseIf (reader.NodeType = "element") && (reader.Name = "MIMultiChoice") 
        {
           set newNIMultiChoice = ##class(EPRmeta.Parser.NIMultiChoice).%New()
           d newNIMultiChoice.XMLDeserialize(reader)
           s newNIMultiChoice.Parent=##this
	       d ..SubItems.Insert(newNIMultiChoice)
	        }
	        
	    ElseIf (reader.NodeType = "element") && (reader.Name = "MIMonoChoice") 
        {
           set newNIMonoChoice = ##class(EPRmeta.Parser.NIMonoChoice).%New()
           d newNIMonoChoice.XMLDeserialize(reader)
           s newNIMonoChoice.Parent=##this
	       d ..SubItems.Insert(newNIMonoChoice)
	        } 
	    ElseIf (reader.NodeType = "element") && (reader.Name = "MILink") 
        {
           set newNILink = ##class(EPRmeta.Parser.NILink).%New()
           d newNILink.XMLDeserialize(reader)
           s newNILink.Parent=##this
	       d ..SubItems.Insert(newNILink)
	        } 
	    ElseIf (reader.NodeType = "element") && (reader.Name = "MIDictionary") 
        {
           set newNIDictionary = ##class(EPRmeta.Parser.NIDictionary).%New()
           d newNIDictionary.XMLDeserialize(reader)
           s newNIDictionary.Parent=##this
	       d ..SubItems.Insert(newNIDictionary)
	        } 
	        
	    ElseIf (reader.NodeType = "element") && (reader.Name = "MIDateTime") 
        {
           set newNIDateTime = ##class(EPRmeta.Parser.NIDateTime).%New()
           d newNIDateTime.XMLDeserialize(reader)
           s newNIDateTime.Parent=##this
	       d ..SubItems.Insert(newNIDateTime)
	        }
	    ElseIf (reader.NodeType = "element") && (reader.Name = "MIPosition") 
        {
           set newNIPosition = ##class(EPRmeta.Parser.NIPosition).%New()
           d newNIPosition.XMLDeserialize(reader)
           s newNIPosition.Parent=##this
	       d ..SubItems.Insert(newNIPosition)
	        }	        	        	        
	    	        	        	        	               	        	        		
		ElseIf (reader.NodeType = "endelement") & (reader.Name = "SubItems") 
		{Q}
     }
	  }
}
}

Method FileImageAnnotate(AMetaStream As %Stream)
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
	  if (obj.%ClassName()="NIAnnotate")
	  { 
	  //get 
	  d ..DisassembleStream(AMetaStream,obj)  
	  }
      elseif (obj.%ClassName()="NICluster")
      {
 //	for  obj.SubItems
	  do ..DisassembleStreamFromCluster(obj)
        } 	  
 	  }           
	  }
}

Method DisassembleStreamFromCluster(AMetaStream As %Stream, ACluster As EPRmeta.Parser.NICluster)
{
 for J= 1:1:ACluster.SubItems.Count()
 {
	set obj= ACluster.SubItems.GetAt(J)
    if obj.%ClassName()="NIAnnotate"
    {
	d ..DisassembleStream(AMetaStream,obj)  
	  }
 elseif obj.%ClassName()="NICluster"
 {
 //	recursion  NICluster
	 do ..DisassembleStreamFromCluster(AMetaStream, obj)
 } 	  
	  }
}

Method DisassembleStream(AMetaDataStream As %Stream, ANIAnnotate As EPRmeta.Parser.NIAnnotate)
{
  ;B "S"
  s BeginImageDataStartNum=-1
  s EndImageDataStartNum=-1
  d AMetaDataStream.Rewind()
  for AnnotateIndex = 1:1:ANIAnnotate.CurrentCount
  {
	;B "S"
	s BeginImageDataStartNum= AMetaDataStream.FindAt(EndImageDataStartNum,"<ImageData>")
	s EndImageDataStartNum= AMetaDataStream.FindAt(BeginImageDataStartNum,"</ImageData>")  
	  }
 ;B "S"	  
 d AMetaDataStream.Rewind()
 
 
 if (ANIAnnotate.CurrentCount=1)
 { d AMetaDataStream.MoveTo(BeginImageDataStartNum+20)
	 set positon= BeginImageDataStartNum+20}
 Elseif (ANIAnnotate.CurrentCount>1)
 { d AMetaDataStream.MoveTo(BeginImageDataStartNum+19) 
   set positon= BeginImageDataStartNum+19 }
 
 while (positon<(EndImageDataStartNum-4))
 {
  
  if ((positon+1024)<(EndImageDataStartNum-4))
  { 
    
    s len=1024
    d AMetaDataStream.Rewind()
    d AMetaDataStream.MoveTo(positon+1)
    s Str=AMetaDataStream.Read(len)
    s positon= positon + len
    d ANIAnnotate.ImageData.Write(Str)
  }
  elseif ((positon+1024)>=(EndImageDataStartNum-4))    
  { 
    
    s len = EndImageDataStartNum -4 - positon
    d AMetaDataStream.Rewind()
    d AMetaDataStream.MoveTo(positon+1)
    s Str=AMetaDataStream.Read(len)
    s positon= positon + len
    d ANIAnnotate.ImageData.Write(Str) 
	  }  	
}
}

Method UpdateMetaData()
{
 Set ItemCount= ..SubItems.Count()
 for I = 1:1:ItemCount
 {           
   set obj= ..SubItems.GetAt(I)
   
   if obj.%ClassName()="NIAnnotate"
   { 
	  
	  set AAnnotateID = ##class(EPRmeta.ImageAnnotate).CheckDataExits(obj.TemplateID , obj.TemplateVersion, obj.Code)
	  //S ^AA(UpdateMetaData,I)=AAnnotateID
	  if (AAnnotateID=0)
	  {
	    Set ResultAnnotate= ##class(EPRmeta.ImageAnnotate).CreateAnnotate(obj) 
		 }
	   elseif '(AAnnotateID=0)
	 {
	   Set ResultAnnotate= ##class(EPRmeta.ImageAnnotate).UpdateAnnotate(obj,AAnnotateID) 	
		 }
	 
	  }
     elseif obj.%ClassName()="NICluster"
    {
	  do ..UpdateAnnotateFromCluer(obj)
   } 	  
  }
}

Method UpdateAnnotateFromCluer(ANICluster As EPRmeta.Parser.NICluster) As %String
{
 for J=1:1:ACluster.SubItems.Count()
 {	set obj= ACluster.SubItems.GetAt(J)
  if obj.%ClassName()="NIAnnotate"
  {  set AAnnotateID = ##class(EPRmeta.ImageAnnotate).CheckDataExits(obj.TemplateID , obj.TemplateVersion, obj.Code)
	if (AAnnotateID=0)
	{ Set ResultAnnotate= ##class(EPRmeta.ImageAnnotate).CreateAnnotate(obj) 
	} elseif '(AAnnotateID=0)
	 { Set ResultAnnotate= ##class(EPRmeta.ImageAnnotate).UpdateAnnotate(obj,AAnnotateID) }
   }
   elseif obj.%ClassName()="NICluster"
   { //	recursion  NICluster
	  do ..UpdateAnnotateFromCluer(obj) }
   }
}

ClassMethod testclass()
{
	Set sc = ##class(%XML.TextReader).ParseFile("d:\83.xml",.reader) 
	Set newNTemplateVersion=##class(EPRmeta.Parser.NTemplateVersion).%New()
	set newNTemplateVersion.TemplateID= "146"
	set newNTemplateVersion.TemplateVersion=1
	set newNTemplateVersion.SessionSign=3936
	//While (reader.Read())
	if ($$$ISOK(sc)) 
	{ 
	  
	  do reader.Read()
	  
	  do newNTemplateVersion.XMLDeserialize(reader) 	   	
	}

  s ^AA($j,"bbbb")	= newNTemplateVersion.CurrentCount
}

}
