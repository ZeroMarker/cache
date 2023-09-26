Class EPRinstance.Parser.NIRow Extends EPRinstance.Parser.NInstanceItem [ ProcedureBlock ]
{

Property RowNum As %Integer;

Method XMLDeserialize(ByRef reader As %XML.TextReader)
{
 while reader.Read()
 {
   ; W "IRow=11",!
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
	     ;W "Code="_CodeValue,!
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
         ;W "Valuerow="_DataValue,!
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
    ; w "SubItems  row 1",!
      while reader.Read()
     {
	    
	   if ((reader.Name="NISimple") && (reader.NodeType = "element"))  
	   { 
		 ;W "row NISimple dd ",!
		 set newNITableSimple = ##class(EPRinstance.Parser.NITableSimple).%New()
		 d newNITableSimple.XMLDeserialize(reader)
         d ..SubItems.Insert(newNITableSimple) }  
	     elseif ((reader.NodeType = "endelement") && (reader.Name="SubItems"))  
	     { 
	      ; w "Row SubItems",!
	       Q }
	 }
    }
   elseif ((reader.NodeType = "endelement") && (reader.Name="NIRow"))
   { 
    ; w "Row End",!
    Q } 	     
  }
}

}
