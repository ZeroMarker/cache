Class EPRinstance.Parser.NISegment Extends NInstanceItem [ ProcedureBlock ]
{

Property FormateInfo As %String(TRUNCATE = 1);

Property KBNodeID As %String(TRUNCATE = 1);

Property SegmentNumber As %String(TRUNCATE = 1);

Property Text As %String(TRUNCATE = 1);

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
	
    elseif ( (reader.Name="Value") && (reader.NodeType = "element"))
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

     elseif ( (reader.Name="KBNodeID") && (reader.NodeType = "element"))  {
        s DataValue =""
        while reader.Read() 
        {
	      if (reader.Name="")
          { S DataValue=DataValue_ reader.Value  } 
            if (reader.Name="KBNodeID") && (reader.NodeType = "endelement")
           {   s ..KBNodeID =DataValue  Q  }
         } 	 
	    }
	  
    elseif ( (reader.Name="SegmentNumber") && (reader.NodeType = "element"))
    {
      s DataValue =""
      while reader.Read() 
      {
	    if (reader.Name="")
        { S DataValue=DataValue_ reader.Value  } 
        if (reader.Name="SegmentNumber") && (reader.NodeType = "endelement")
        { s ..SegmentNumber =DataValue  Q  }
       } 	 
	  }
  Elseif (reader.Name="Normal") && (reader.NodeType = "element")
  {
	 While reader.Read()
	 {
          if ( (reader.Name="Normal") && (reader.NodeType = "endelement"))
	     { Q }		 }  
	  }
  Elseif (reader.Name="AbNormal") && (reader.NodeType = "element")
  {
	 While reader.Read()
	 {
          if ( (reader.Name="AbNormal") && (reader.NodeType = "endelement"))
	     { Q }		 }  
	  }
   elseif ( (reader.Name="SubItems") && (reader.NodeType = "element"))
    {
      While reader.Read()
      {
	     If (reader.NodeType = "element") & (reader.Name = "NISimple")
	     {
			set newNISimple = ##class(NISimple).%New()
			d newNISimple.XMLDeserialize(reader)
            d ..SubItems.Insert(newNISimple)
            If ($p(newNISimple.Code,1,1) = "Q") {
	             s ..Text = ..Text _ newNISimple.Value _ newNISimple.ValueCode	                    
             } else {                    
                      s ..Text = ..Text _ newNISimple.Value
                    }		     
           }
        ElseIf (reader.NodeType = "element") & (reader.Name = "NIFree") {
				set newNIFree = ##class(NIFree).%New()
				d newNIFree.XMLDeserialize(reader)
                d ..SubItems.Insert(newNIFree)
                s ..Text = ..Text _ newNIFree.Value
               } 
        ElseIf (reader.NodeType = "element") & (reader.Name = "NILink") {
				set newNILink = ##class(NILink).%New()
			    d newNILink.XMLDeserialize(reader)
                d ..SubItems.Insert(newNILink)
                s ..Text = ..Text _ newNILink.Value 
                } 
        ElseIf (reader.NodeType = "endelement") & (reader.Name = "SubItems") {									
					;W "seg text"_..Text ,! 
					Quit				
				}	     
	      
	      }
     }
    
 elseif (reader.Name="FormatRangeCollection") && (reader.NodeType = "element")
 {
	s ..FormateInfo = ..FormateInfo _ "<" _ reader.Name _ ">"
	While reader.Read()
	{
	 if (reader.NodeType="element")
	 { 
	  s ..FormateInfo = ..FormateInfo _ "<" _ reader.Name _ ">"
	 }
	 ElseIf (reader.NodeType = "chars")  
	 {	
	   s ..FormateInfo = ..FormateInfo _ reader.Value }
     ElseIf (reader.Name="FormatRangeCollection") && (reader.NodeType = "endelement")
	  { 
	    s ..FormateInfo = ..FormateInfo _ "</" _ reader.Name _ ">"
	    ;w ..FormateInfo ,!
	     Q }
	 Elseif (reader.NodeType = "endelement")  {
					s ..FormateInfo = ..FormateInfo _ "</" _ reader.Name _ ">"					
				} 
	 ElseIf (reader.NodeType = "emptyelement")  
	 {	s ..FormateInfo = ..FormateInfo _ "<" _ reader.Name _ "/>"	 } 						
	 }
  }	  
	  
  elseif (reader.Name="NISegment") && (reader.NodeType = "endelement")
  {  Q  }
 
 }
}

ClassMethod XMLTest()
{
	s strTest = "<NISegment><Code>E0001</Code><Value /><ValueCode /><SubItems><NISimple><Code>S0002</Code><Value>123</Value><ValueCode /></NISimple></SubItems></NISegment>"
	s reader = ""
	S sc = ##class(%XML.TextReader).ParseString(strTest,.reader)
	

 If ($$$ISOK(sc)) {
 d reader.Read()
 s objNISegment = ##class(NISegment).%New()
 d objNISegment.XMLDeserialize(reader)
 set obj = objNISegment.SubItems.GetAt(1)
 w obj.%ClassName(),!
 w obj.Code,!
 w obj.Value,! 		
 }
}

}
