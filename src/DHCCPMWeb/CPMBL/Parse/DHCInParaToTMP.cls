/// 使用SAX专门解析成XML
Class DHCCPMWeb.CPMBL.Parse.DHCInParaToTMP Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

ClassMethod XMLDeserialize(ByRef reader As %XML.TextReader)
{
	;^TMPCPMPrintPara($j,"")=""
	while reader.Read()
	{
	 	if ( (reader.Name="Code") && (reader.NodeType = "element"))
	 	{
	 		s CodeValue =""
	 		while reader.Read() 
	 		{
		    	if (reader.Name=""){ S CodeValue= CodeValue_ reader.Value  } 
	 			if (reader.Name="Code") && (reader.NodeType = "endelement")
	 			{
		    		;s ..Code=CodeValue
		    		Q 
				}
	 		}
		}Elseif ( (reader.Name="Value") && (reader.NodeType = "element")){
	 		s DataValue =""
	 		while reader.Read() 
	 		{
		    	if (reader.Name="")
		    	{
		    		S DataValue=DataValue_ reader.Value  
		    	}
	 			if (reader.Name="Value") && (reader.NodeType = "endelement")
	 			{   }
	 		} 	 
		}Elseif ( (reader.Name="ValueCode") && (reader.NodeType = "element")){
	 		s DataValue =""
			while reader.Read(){
		    	if (reader.Name=""){ S DataValue=DataValue_ reader.Value}
	 			if (reader.Name="ValueCode") && (reader.NodeType = "endelement")
	 			{ ;s ..ValueCode =DataValue  Q  
	 			}
	 		}
		}
	 	if (reader.Name="NInstanceItem") && (reader.NodeType = "endelement")
	 	{  Q  }
	}
}

}
