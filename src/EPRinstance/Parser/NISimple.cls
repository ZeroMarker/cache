Class EPRinstance.Parser.NISimple Extends NInstanceItem [ ProcedureBlock ]
{

Method XMLDeserialize(ByRef reader As %XML.TextReader)
{
  while reader.Read()
  {
    ;W "NISimple",!
    if ( (reader.Name="Code") && (reader.NodeType = "element"))
    {
      s CodeValue =""
      while reader.Read() 
      {
	    if (reader.Name="")
        { S CodeValue= CodeValue_ reader.Value  
          // W "Code="_CodeValue,!
        } 
        if (reader.Name="Code") && (reader.NodeType = "endelement")
       { 
	     s ..Code=CodeValue
	     //W "Code="_CodeValue,!
	     Q }
       } 	 
	}
    if ( (reader.Name="Value") && (reader.NodeType = "element"))
    {
      s DataValue =""
      while reader.Read() 
      {
	    if (reader.Name="")
        { S DataValue=DataValue_ reader.Value  
        // W "Code="_CodeValue,!
        } 
        if (reader.Name="Value") && (reader.NodeType = "endelement")
        { s ..Value =DataValue 
         //W "Value="_DataValue,!
         Q  }
       } 	 
	  }

    if ( (reader.Name="ValueCode") && (reader.NodeType = "element"))
    {
      s DataValue =""
      while reader.Read() 
      {
	    if (reader.Name="")
        { S DataValue=DataValue_ reader.Value  
        // W "ValueCode="_DataValue,!
        } 
        if (reader.Name="ValueCode") && (reader.NodeType = "endelement")
        { s ..ValueCode =DataValue  
        //W "ValueCode="_DataValue,!
        Q  }
       } 	 
	  }
  if (reader.Name="NISimple") && (reader.NodeType = "endelement")
  {  Q  }
 
 }
}

}
