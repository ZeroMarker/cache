Class EPRmeta.Parser.NICluster Extends EPRmeta.Parser.NMetaDataItem [ ProcedureBlock ]
{

Property TemplateID As %String(TRUNCATE = 1);

Property TemplateVersion As %String(TRUNCATE = 1);

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
	   If (reader.NodeType = "element") && (reader.Name = "MIImageAnnotate") 
	   {  set newNIAnnotate = ##class(EPRmeta.Parser.NIAnnotate).%New()
	    s ..CurrentCount = ..CurrentCount + 1
	    s newNIAnnotate.SessionSign=..SessionSign
	    d newNIAnnotate.XMLDeserialize(reader)
	    s newNIAnnotate.TemplateID = ..TemplateID 
		s newNIAnnotate.CurrentCount = ..CurrentCount
		s newNIAnnotate.TemplateVersion = ..TemplateVersion
        d ..SubItems.Insert(newNIAnnotate) 
        s ..HasAnnotate="True"
        } 
        ElseIf (reader.NodeType = "element") && (reader.Name = "MITextDesc") 
        {
           set newNITextDesc = ##class(EPRmeta.Parser.NITextDesc).%New()
           d newNITextDesc.XMLDeserialize(reader)
	       d ..SubItems.Insert(newNITextDesc)
	        }
        ElseIf (reader.NodeType = "element") && (reader.Name = "MISegment") 
        {
           set newNISegment = ##class(EPRmeta.Parser.NISegment).%New()
           d newNISegment.XMLDeserialize(reader)
	       d ..SubItems.Insert(newNISegment)
	        }
        ElseIf (reader.NodeType = "element") && (reader.Name = "MITable") 
        {
           set newNITable = ##class(EPRmeta.Parser.NITable).%New()
           d newNITable.XMLDeserialize(reader)
	       d ..SubItems.Insert(newNITable)
	        }
       ElseIf (reader.NodeType = "element") && (reader.Name = "NICluster") 
      { set newNICluster = ##class(NICluster).%New()
       S newNICluster.CurrentCount= ..CurrentCount 
       s newNICluster.SessionSign=..SessionSign
	   d newNICluster.XMLDeserialize(reader)
	   S ..CurrentCount= newNICluster.CurrentCount 
         if (newNICluster.HasAnnotate="True")
         { s ..HasAnnotate="True"}
       d ..SubItems.Insert(newNICluster) } 
     ElseIf (reader.NodeType = "endelement") & (reader.Name = "SubItems") {									
					Quit	}
     }
				
	}
    Elseif (reader.Name="NICluster") && (reader.NodeType = "endelement")
    {  Quit  }
 }
}

}
