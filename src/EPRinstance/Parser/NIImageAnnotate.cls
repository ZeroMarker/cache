Class EPRinstance.Parser.NIImageAnnotate Extends EPRinstance.Parser.NInstanceItem [ ProcedureBlock ]
{

Property CurrentCount As %Integer;

Property HasAnnotate As %String(TRUNCATE = 1);

Property AnnoData As %GlobalCharacterStream(LOCATION = "^CacheTempDHCEPRAnnoDataStream($J)");

Method XMLDeserialize(ByRef reader As %XML.TextReader)
{
  set ..HasAnnotate="True"
  while reader.Read()
  {
    if ( (reader.Name="Code") && (reader.NodeType = "element"))
    { s CodeValue =""
      while reader.Read() 
      { if (reader.Name="")
        { S CodeValue= CodeValue_ reader.Value  } 
        if (reader.Name="Code") && (reader.NodeType = "endelement")
       { s ..Code=CodeValue
	     Q }
       } 	 
	}
    elseif ( (reader.Name="Value") && (reader.NodeType = "element"))
    {
      s DataValue =""
      while reader.Read() 
      { if (reader.Name="")
        { S DataValue=DataValue_ reader.Value  } 
        if (reader.Name="Value") && (reader.NodeType = "endelement")
        { s ..Value =DataValue  Q  }
       } 	 
	  }
    elseif ( (reader.Name="ValueCode") && (reader.NodeType = "element"))
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
     elseif ( (reader.Name="AnnoData") && (reader.NodeType = "element"))  
     {	while reader.Read() 
        { /*if (reader.NodeType="cdata")
	      { set ..AnnoData= reader.Value  } */
          //B "S"
          s tempNum= reader.Value
	      
	      if (tempNum'="")
	      {
		     set ACdataId= ##class(EPRservice.Util.CdataItem).GetCdataItemId(tempNum,..SessionSign)
		     if '(ACdataId="0")
		     {
			   s ACdataItem= ##class(EPRservice.Util.CdataItem).%OpenId(ACdataId)  
			   if '(ACdataItem="")
			   {
				d ..AnnoData.CopyFrom(ACdataItem.CDATAStream) 
				s ACdataItem="" 
				   }
			     } 
		      }	      
	       if (reader.Name="AnnoData") && (reader.NodeType = "endelement")
           {   Q  }
         } 	 
	    }
	    elseif ( (reader.Name="SubItems") && (reader.NodeType = "element"))
	    {
		  while reader.Read()
		  {
			if ((reader.Name="NISimple")&&(reader.NodeType="element"))
			{
              set newNISimple = ##class(NISimple).%New()
		      d newNISimple.XMLDeserialize(reader)
               d ..SubItems.Insert(newNISimple) 				
               }
			elseif ( (reader.Name="SubItems") && (reader.NodeType = "endelement"))
			{ Q 	}  
			  }  
		    }
	  elseif ( (reader.Name="NIImageAnnotate") && (reader.NodeType = "endelement"))
	  { Q  }
}
}

}
