Class EPRinstance.Parser.NITable Extends NInstanceItem [ ProcedureBlock ]
{

Method XMLDeserialize(ByRef reader As %XML.TextReader)
{
 s ARowNum = 0
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
	    ; W "Code="_CodeValue,!
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
          ;W "Value="_DataValue,!
        Q  }
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
        { s ..ValueCode =DataValue  
          ;W "ValueCode="_DataValue,!
        Q  }
       } 	 
	  }
  elseif ( (reader.Name="SubItems") && (reader.NodeType = "element"))
 {		
   ;W "ValueCode="_DataValue,!
   ;W "SubItems",!
   while reader.Read()
   {
	 if ((reader.Name="NIRow") && (reader.NodeType = "element"))  
	 { 
		S ARowNum = ARowNum +1 
		set newNIRow = ##class(NIRow).%New()
		d newNIRow.XMLDeserialize(reader)
		s newNIRow.RowNum = ARowNum
        d ..SubItems.Insert(newNIRow) }  
	 elseif ((reader.NodeType = "endelement") && (reader.Name="SubItems"))  
	 { 
	   ;W "EndSubItems",! 
	   Q }
	}
 }
 elseif ((reader.NodeType = "endelement") && (reader.Name="NITable"))
 { ; W "nitable",! 
 Q } 	     
}
 ; w "ARowNum="_ARowNum ,!
}

}
