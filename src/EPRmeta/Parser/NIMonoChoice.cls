Class EPRmeta.Parser.NIMonoChoice Extends EPRmeta.Parser.NMetaDataItem [ ProcedureBlock ]
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
	ElseIf ( (reader.Name="Text")&&(reader.NodeType = "element") )
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
	Elseif (reader.Name="MIMonoChoice") && (reader.NodeType = "endelement")
    {  Quit  }

}
}

}
