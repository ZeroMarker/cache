Class EPRmeta.Parser.NIAnnotate Extends EPRmeta.Parser.NMetaDataItem [ ProcedureBlock ]
{

Property TemplateID As %String(TRUNCATE = 1);

Property TemplateVersion As %String(TRUNCATE = 1);

Property CurrentCount As %Integer;

Property ImageData As %GlobalCharacterStream(LOCATION = "^CacheTempDHCEPRAnnotateStream($J)");

Method XMLDeserialize(ByRef reader As %XML.TextReader)
{
  while reader.Read()
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
	      ;W "Code="_CodeValue,!
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
	elseif ((reader.NodeType = "element") &&  (reader.Name="ImageData"))
	{
	  while reader.Read() 
      {
	     if ((reader.NodeType="endelement") &&(reader.Name="ImageData")    )
	     {Q }
	      s tempNum= reader.Value
	      
	      if (tempNum'="")
	      {
		      
		     set ACdataId= ##class(EPRservice.Util.CdataItem).GetCdataItemId(tempNum,..SessionSign)
		     if '(ACdataId="0")
		     {
			   s ACdataItem= ##class(EPRservice.Util.CdataItem).%OpenId(ACdataId)  
			  // s ^AA($J,"ACdataItem")= ACdataItem
			   ;W "ACdataId ="_ ACdataId,!
			   if '(ACdataItem="")
			   {
				d ..ImageData.CopyFrom(ACdataItem.CDATAStream) 
				s ACdataItem="" 
				   }
			     } 
		      }
	      }
	 	}
	Elseif (reader.NodeType = "element") && (reader.Name = "SubItems") 
	{
	 while reader.Read()
	 {
	   If (reader.NodeType = "endelement") && (reader.Name = "SubItems") 
       { Q }
      }	
	
	} 	
	elseif ((reader.NodeType = "endelement") &&  (reader.Name="MIImageAnnotate"))
	{ Q	}
	 }
}

ClassMethod TestParser()
{
  set aa="<MIImageAnnotate><Code>Y0001</Code><ImageData><![CDATA[5]]></ImageData><HotSpotData><![CDATA[2]]></HotSpotData></MIImageAnnotate>"	
  Set sc = ##class(%XML.TextReader).ParseString(aa,.reader) 
  Set NewNIAnnotate=##class(EPRmeta.Parser.NIAnnotate).%New()
  s NewNIAnnotate.SessionSign="1100"
  if ($$$ISOK(sc)) 
  {while reader.Read()
   {
	   
   If (reader.NodeType = "element") & (reader.Name = "MIImageAnnotate")	   
    {do NewNIAnnotate.XMLDeserialize(reader)}
   } 	   	
  }
}

}
