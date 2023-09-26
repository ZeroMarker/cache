Class EPRinstance.Parser.NITableSimple Extends EPRinstance.Parser.NISimple [ ProcedureBlock ]
{

Property RowNum As %Integer;

Property TableCode As %String(TRUNCATE = 1);

Method XMLDeserialize(ByRef reader As %XML.TextReader)
{

  while reader.Read()
  {
   ; W "NITableSimple kkk",!
    if ( (reader.Name="Code") && (reader.NodeType = "element"))
    {
      s CodeValue =""
      while reader.Read() 
      {
	    if (reader.Name="")
        { S CodeValue= CodeValue_ reader.Value  } 
        if (reader.Name="Code") && (reader.NodeType = "endelement")
       { s ..Code=CodeValue
         ;W "NITableSimple Code ="_CodeValue ,!
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
        { s ..Value =DataValue  
        ; W "NITableSimple Value ="_DataValue ,!
        Q  }
       } 	 
	  }

    Elseif ( (reader.Name="ValueCode") && (reader.NodeType = "element"))
    { s DataValue =""
      while reader.Read() 
      {
	    if (reader.Name="")
        { S DataValue=DataValue_ reader.Value  } 
        if (reader.Name="ValueCode") && (reader.NodeType = "endelement")
        { s ..ValueCode =DataValue 
        ;W "NITableSimple ValueCode ="_DataValue ,!
         Q  }
       } 	 
	  }
  Elseif ((reader.Name="NISimple") && (reader.NodeType = "endelement"))
  {  
   ; W "NITableSimple End =",!
    Q  }
 
 }
}

}
