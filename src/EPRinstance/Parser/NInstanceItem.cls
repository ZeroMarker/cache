Class EPRinstance.Parser.NInstanceItem Extends %RegisteredObject [ ProcedureBlock ]
{

Property Code As %String(TRUNCATE = 1);

Property Parent As NInstanceItem;

Property SubItems As list Of NInstanceItem;

Property Value As %String(MAXLEN = 32000, TRUNCATE = 1);

Property ValueCode As %String(TRUNCATE = 1);

Property SessionSign As %String(TRUNCATE = 1);

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
       { 
	     s ..Code=CodeValue
	     Q }
       } 	 
	}
    Elseif ( (reader.Name="Value") && (reader.NodeType = "element"))
    {
      s DataValue =""
      while reader.Read() 
      {
	    if (reader.Name="")
        { S DataValue=DataValue_ reader.Value  } 
        if (reader.Name="Value") && (reader.NodeType = "endelement")
        { s ..Value =DataValue  Q  }
       } 	 
	  }

    Elseif ( (reader.Name="ValueCode") && (reader.NodeType = "element"))
    {
      s DataValue =""
      while reader.Read() 
      {
	    if (reader.Name="")
        { S DataValue=DataValue_ reader.Value  } 
        if (reader.Name="ValueCode") && (reader.NodeType = "endelement")
        { s ..ValueCode =DataValue  Q  }
       } 	 
	  }
  if (reader.Name="NInstanceItem") && (reader.NodeType = "endelement")
  {  Q  }
 
 }
}

}
