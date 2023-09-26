Class EPRservice.Util.ParserStream Extends %RegisteredObject [ ProcedureBlock ]
{

Property CdataCount As %Integer;

Property BeginFirstLefReserveFlag As %String(TRUNCATE = 1);

Property BeginTwoExclamationFlag As %String(TRUNCATE = 1);

Property BeginThreeLefMidBracketFlag As %String(TRUNCATE = 1);

Property BeginFourGimelFlag As %String(TRUNCATE = 1);

Property BeginFiveDeltaFlag As %String(TRUNCATE = 1);

Property BeginSixAlephFlag As %String(TRUNCATE = 1);

Property BeginSevenTauFlag As %String(TRUNCATE = 1);

Property BeginEightAlephFlag As %String(TRUNCATE = 1);

Property BeginNineLefMidBrackeFlag As %String(TRUNCATE = 1);

Property EndFirstMidBracket As %String(TRUNCATE = 1);

Property EndTwoMidBracket As %String(TRUNCATE = 1);

Property EndThreeRightReserve As %String(TRUNCATE = 1);

Property RightReserve As %String(TRUNCATE = 1);

Property LefMidBracket As %String(TRUNCATE = 1);

Property ReghtMidBracket As %String(TRUNCATE = 1);

Property LefReserve As %String(TRUNCATE = 1);

Property ExclamationMark As %String(TRUNCATE = 1);

Property ALPHAStr As %String(TRUNCATE = 1);

//

Property GIMELStr As %String(TRUNCATE = 1);

Property DELTALtaStr As %String(TRUNCATE = 1);

Property TAUStr As %String(TRUNCATE = 1);

Property BeginFisrtStr As %String(TRUNCATE = 1);

//

Property BeginTwoStr As %String(TRUNCATE = 1);

Property BeginThreeStr As %String(TRUNCATE = 1);

Property BeginFourStr As %String(TRUNCATE = 1);

Property BeginFiveStr As %String(TRUNCATE = 1);

//

Property BeginSixStr As %String(TRUNCATE = 1);

Property BeignSevenStr As %String(TRUNCATE = 1);

Property BeginEightStr As %String(TRUNCATE = 1);

Property BeginNineStr As %String(TRUNCATE = 1);

//

Property EndFirstStr As %String(TRUNCATE = 1);

Property EndTwoStr As %String(TRUNCATE = 1);

Property EndThreeStr As %String(TRUNCATE = 1);

Property CdataSign As %String(TRUNCATE = 1);

//Property CDATAItems As %Stream [ Collection = list ];

Method InitializeStatus()
{
  Do ..RewindStatus()
  Set ..LefReserve ="<" 	
  Set ..RightReserve  =">"
  Set ..LefMidBracket ="["
  set ..ReghtMidBracket ="]"
  set ..ExclamationMark ="!"
  Set ..ALPHAStr="A"
  Set ..GIMELStr="C"
  Set ..DELTALtaStr="D"
  Set ..TAUStr="T"
  
 /* if (..CDATAItems.Count()>0) 
  {
    D ..CDATAItems.Clear() 	   
	  }*/
}

Method InitializaComStr()
{
	D ..InitializaBeginStr()
	D ..InitializaEndStr()
}

Method InitializaBeginStr()
{
 s ..BeginFisrtStr=""
   s ..BeginTwoStr=""
   s ..BeginThreeStr=""
   s ..BeginFourStr=""
   s ..BeginFiveStr=""
   s ..BeginSixStr=""
   S ..BeignSevenStr=""
   s ..BeginEightStr=""
   s ..BeginNineStr =""
}

Method InitializaTwoBeginStr()
{
   s ..BeginFisrtStr=""
   s ..BeginTwoStr=""
}

Method InitializaThreeBeginStr()
{
 s ..BeginFisrtStr=""
   s ..BeginTwoStr=""
   s ..BeginThreeStr=""
}

Method InitializaEndStr()
{
  S ..EndFirstStr=""
   S ..EndTwoStr=""
   S ..EndThreeStr=""
}

Method RewindBeginStatus()
{
  Set ..BeginFirstLefReserveFlag="False" //<
  Set ..BeginTwoExclamationFlag ="False"  //!
  Set ..BeginThreeLefMidBracketFlag="False" //[
  Set ..BeginFourGimelFlag ="False"  //C
  Set ..BeginFiveDeltaFlag="False" //D 
  Set ..BeginSixAlephFlag="False"  // A
  Set ..BeginSevenTauFlag="False" // T
  Set ..BeginEightAlephFlag="False" // A
  Set ..BeginNineLefMidBrackeFlag="False"  // [
}

Method RewindEndStatus()
{
  
  Set ..EndFirstMidBracket="False"
  Set ..EndTwoMidBracket="False"
  Set ..EndThreeRightReserve="False"
}

Method RewindStatus()
{
  Set ..BeginFirstLefReserveFlag="False" //<
  Set ..BeginTwoExclamationFlag ="False"  //!
  Set ..BeginThreeLefMidBracketFlag="False" //[
  Set ..BeginFourGimelFlag ="False"  //C
  Set ..BeginFiveDeltaFlag="False" //D 
  Set ..BeginSixAlephFlag="False"  // A
  Set ..BeginSevenTauFlag="False" // T
  Set ..BeginEightAlephFlag="False" // A
  Set ..BeginNineLefMidBrackeFlag="False"  // [
  
  Set ..EndFirstMidBracket="False"
  Set ..EndTwoMidBracket="False"
  Set ..EndThreeRightReserve="False"
}

Method CheckRightCdataSign() As %Boolean
{
 if ((..EndFirstMidBracket="True")&&(..EndTwoMidBracket="True")&&(..EndThreeRightReserve="True"))
  {
    Q 1
  }
 else
 { Q 0}
}

Method CheckRightOneCdataSign() As %Boolean
{
 if ((..EndFirstMidBracket="True")&&(..EndTwoMidBracket="False"))
  {
    Q 1
  }
 else
 { Q 0}
}

Method CheckRightTwoCdataSign() As %Boolean
{
  //Set Result= "False"	
  if ((..EndFirstMidBracket="True")&&(..EndTwoMidBracket="True")&&(..EndThreeRightReserve="False"))
  {
     Q 1
  }
 else
 { Q 0}
}

Method CheckLeftCDATASign() As %Boolean
{
 //set Result="False"
 if ((..BeginFirstLefReserveFlag="True") && (..BeginTwoExclamationFlag="True") &&(..BeginThreeLefMidBracketFlag="True")&&(..BeginFourGimelFlag="True")&&(..BeginFiveDeltaFlag="True")&&(..BeginSixAlephFlag="True")&&(..BeginSevenTauFlag="True")&&(..BeginEightAlephFlag="True")&&(..BeginNineLefMidBrackeFlag="True"))
 {
   Q 1
	 }  
 else
 { Q 0}
}

Method CheckLeftOneCdataSign() As %Boolean
{
  
  if ((..BeginFirstLefReserveFlag="True")&&(..BeginTwoExclamationFlag="False"))
  {
    Q 1
  }
 else
 { Q 0}
}

Method CheckLeftTwoCdataSign() As %Boolean
{
  if ((..BeginFirstLefReserveFlag="True")&&(..BeginTwoExclamationFlag="True")&&(..BeginThreeLefMidBracketFlag="False"))
  {
    Q 1
  }
 else
 { Q 0}
}

Method CheckLeftThreeCdataSign() As %Boolean
{
  if ((..BeginFirstLefReserveFlag="True")&&(..BeginTwoExclamationFlag="True")&&(..BeginThreeLefMidBracketFlag="True")&&(..BeginFourGimelFlag="False"))
  {
    Q 1
  }
 else
 { Q 0}
}

Method CheckLeftFourCdataSign() As %Boolean
{
  
  if ((..BeginFirstLefReserveFlag="True")&&(..BeginTwoExclamationFlag="True")&&(..BeginThreeLefMidBracketFlag="True")&&(..BeginFourGimelFlag="True")&&(..BeginFiveDeltaFlag="False"))
  {
  Q 1  
  }
 else
 { Q 0}
}

Method CheckLeftFiveCdataSign() As %Boolean
{
  if ((..BeginFirstLefReserveFlag="True")&&(..BeginTwoExclamationFlag="True")&&(..BeginThreeLefMidBracketFlag="True")&&(..BeginFourGimelFlag="True")&&(..BeginFiveDeltaFlag="True")&&(..BeginSixAlephFlag="False"))
  {
    Q 1
  }
 else
 { Q 0}
}

Method CheckLeftSixCdataSign() As %Boolean
{
  if ((..BeginFirstLefReserveFlag="True")&&(..BeginTwoExclamationFlag="True")&&(..BeginThreeLefMidBracketFlag="True")&&(..BeginFourGimelFlag="True")&&(..BeginFiveDeltaFlag="True")&&(..BeginSixAlephFlag="True")&&(..BeginSevenTauFlag="False"))
  {
    Q 1
  }
 else
 { Q 0}
}

Method CheckLeftSevenCdataSign() As %Boolean
{
  if ((..BeginFirstLefReserveFlag="True")&&(..BeginTwoExclamationFlag="True")&&(..BeginThreeLefMidBracketFlag="True")&&(..BeginFourGimelFlag="True")&&(..BeginFiveDeltaFlag="True")&&(..BeginSixAlephFlag="True")&&(..BeginSevenTauFlag="True")&&(..BeginEightAlephFlag="False"))
  {
    Q 1
  }
 else
 { Q 0}
}

Method CheckLeftEightCdataSign() As %Boolean
{
  if ((..BeginFirstLefReserveFlag="True")&&(..BeginTwoExclamationFlag="True")&&(..BeginThreeLefMidBracketFlag="True")&&(..BeginFourGimelFlag="True")&&(..BeginFiveDeltaFlag="True")&&(..BeginSixAlephFlag="True")&&(..BeginSevenTauFlag="True")&&(..BeginEightAlephFlag="True")&&(..BeginNineLefMidBrackeFlag="False"))
  {
    Q 1
  }
 else
 { Q 0}
}

Method AutoMationByStr(AInputStream As %Stream) As %Stream
{
   //s ^AATime("Beginbystr")= $ZTIMESTAMP //$ZTIMEH($ZTIME($PIECE($HOROLOG,",",2),1))
   
   //B "S"
   D ..InitializeStatus()
   D AInputStream.Rewind()
   s ..CdataCount=0
   
   //s acdatastr=""
   //set ACdataAggr.CdataCount=0 
    
   set Len=1024
   
   set ResultStream = ##class(%GlobalCharacterStream).%New()
   set ACDATAStream = ##class(%GlobalCharacterStream).%New()
   //<![CDATA[
   //S TempWriteStr=""
   S ResultWriteStr=""
   S CdataWriteStr=""
   While (AInputStream.AtEnd =0)
   { //Compare < Sign
     
     Set TempReadStr =AInputStream.Read(Len)
     Set LengStr= $L(TempReadStr)
     
     
     
     For I=1:1:LengStr
     {
	    S LeftStatus = ..CheckLeftCDATASign()
	    if '(LeftStatus)
	    {
		  set LeftEightStatus = ..CheckLeftEightCdataSign()	
		  if '(LeftEightStatus)
		  { set LeftSevenStatus= ..CheckLeftSevenCdataSign()
			if '(LeftSevenStatus)
			{  set LeftSixStatus= ..CheckLeftSixCdataSign()
			   if '(LeftSixStatus)
			   { set LeftFiveStatus = ..CheckLeftFiveCdataSign()	
			     if '(LeftFiveStatus)
			     { set LeftFourStatus = ..CheckLeftFourCdataSign()	
			       if '(LeftFourStatus)
			       {  set LeftThreeStatus = ..CheckLeftThreeCdataSign()	
				       if '(LeftThreeStatus)
				       { set LeftTwoStatus = ..CheckLeftTwoCdataSign()	
  				         if '(LeftTwoStatus)
				         { set LeftOneStatus= ..CheckLeftOneCdataSign()
  				           if '(LeftOneStatus)
				           {
					        if (I <= LengStr)
					        { set ..BeginFisrtStr= $E(TempReadStr,I)
						      if (..BeginFisrtStr=..LefReserve)
	                          { 
	                           set ..BeginFirstLefReserveFlag="True"					        
	                           set ResultWriteStr=ResultWriteStr_..BeginFisrtStr
			                   if ($L(ResultWriteStr)=Len)
			                      { D ResultStream.Write(ResultWriteStr)  
			                        S ResultWriteStr=""
			                      }
				               }
				               Elseif '(..BeginFisrtStr=..LefReserve)
				               {
	                             set ResultWriteStr=ResultWriteStr_..BeginFisrtStr
			                      if ($L(ResultWriteStr)=Len)
			                      { D ResultStream.Write(ResultWriteStr)  
			                        S ResultWriteStr=""
			                      }
	                             S ..BeginFisrtStr =""
	                             s ..BeginFirstLefReserveFlag="False"
					            }
					          }
					        }
				           Elseif (LeftOneStatus)
				           { if (I <= LengStr)
	                         {  Set ..BeginTwoStr=$E(TempReadStr,I)
	    						if (..BeginTwoStr= ..ExclamationMark) 
		                        {
			                      s ..BeginTwoExclamationFlag="True" 
			                      set ResultWriteStr=ResultWriteStr_..BeginTwoStr
			                      if ($L(ResultWriteStr)=Len)
			                      { D ResultStream.Write(ResultWriteStr)  
			                        S ResultWriteStr=""
			                      }
			                        } 
			                     elseif '(..BeginTwoStr= ..ExclamationMark) 
			                     {
				                   set ResultWriteStr=ResultWriteStr_..BeginTwoStr
			                      if ($L(ResultWriteStr)=Len)
			                      { D ResultStream.Write(ResultWriteStr)  
			                        S ResultWriteStr=""
			                      }
				                   D ..InitializaTwoBeginStr()
				                   D ..RewindBeginStatus()     
				                     }   
		                         }    
					       }
				         }
				         Elseif (LeftTwoStatus)
				         {
					      if (I <= LengStr)
					      { Set ..BeginThreeStr=$E(TempReadStr,I)
						    if (..BeginThreeStr=..LefMidBracket)  
						    { s ..BeginThreeLefMidBracketFlag="True" 
						      set ResultWriteStr=ResultWriteStr_..BeginThreeStr
			                  if ($L(ResultWriteStr)=Len)
			                  { D ResultStream.Write(ResultWriteStr)  
			                    S ResultWriteStr=""
			                   }
						     }
						    elseif '(..BeginThreeStr=..LefMidBracket)  
						    { 
						      set ResultWriteStr=ResultWriteStr_..BeginThreeStr
			                  if ($L(ResultWriteStr)=Len)
			                  { D ResultStream.Write(ResultWriteStr)  
			                        S ResultWriteStr=""
			                      }
                              D ..InitializaThreeBeginStr()
							  D ..RewindBeginStatus()       
							    }}
					      }
				       }
				       Elseif (LeftThreeStatus)
				       {
					      //Compare <![C Mark
					      if (I <= LengStr)
					      {
						    Set ..BeginFourStr=$E(TempReadStr,I)
						    if (..BeginFourStr=..GIMELStr)  
						    { s ..BeginFourGimelFlag="True"  
						      set ResultWriteStr=ResultWriteStr_..BeginFourStr
			                  if ($L(ResultWriteStr)=Len)
			                  { D ResultStream.Write(ResultWriteStr)  
			                        S ResultWriteStr=""
			                      }
						    }
						      
						    elseif '(..BeginFourStr=..GIMELStr)  
						    { 
						      set ResultWriteStr=ResultWriteStr_..BeginFourStr
			                  if ($L(ResultWriteStr)=Len)
			                  { D ResultStream.Write(ResultWriteStr)  
			                    S ResultWriteStr=""
			                      }
                              D ..InitializaBeginStr()
							  D ..RewindBeginStatus()       
							    }
						      }
					       }
				       }
				    elseif (LeftFourStatus)   
			        {
				       //Compare <![CD Mark
					      if (I <= LengStr)
					      { Set ..BeginFiveStr=$E(TempReadStr,I)
						    if (..BeginFiveStr=..DELTALtaStr)  
						    { s ..BeginFiveDeltaFlag="True"  
						      set ResultWriteStr=ResultWriteStr_..BeginFiveStr
			                  if ($L(ResultWriteStr)=Len)
			                  { D ResultStream.Write(ResultWriteStr)  
			                        S ResultWriteStr=""
			                      }
						    }
						      
						    elseif '(..BeginFiveStr=..DELTALtaStr)  
						    { 
						      set ResultWriteStr=ResultWriteStr_..BeginFiveStr
			                  if ($L(ResultWriteStr)=Len)
			                  { D ResultStream.Write(ResultWriteStr)  
			                        S ResultWriteStr=""
			                      }
                              D ..InitializaBeginStr()
							  D ..RewindBeginStatus()       
							    }
						    }
				      }
				    }
			     elseif (LeftFiveStatus)
			     {
				    //Compare <![CDA Mark
					if (I <= LengStr)
					{  Set ..BeginSixStr=$E(TempReadStr,I)
					   if (..BeginSixStr=..ALPHAStr)  
						{ s ..BeginSixAlephFlag="True"  
						  set ResultWriteStr=ResultWriteStr_..BeginSixStr
			                  if ($L(ResultWriteStr)=Len)
			                  { D ResultStream.Write(ResultWriteStr)  
			                        S ResultWriteStr=""
			                      }
						}
						elseif '(..BeginSixStr=..ALPHAStr)  
						{ 
						  set ResultWriteStr=ResultWriteStr_..BeginSixStr
			                  if ($L(ResultWriteStr)=Len)
			                  { D ResultStream.Write(ResultWriteStr)  
			                        S ResultWriteStr=""
			                      }
                          D ..InitializaBeginStr()
						  D ..RewindBeginStatus()       
						}
				     }   
				    }
				  }
			  Elseif (LeftSixStatus)
			  {
				//Compare <![CDAT Mark
				if (I <= LengStr)
				{  Set ..BeignSevenStr=$E(TempReadStr,I)
				   if (..BeignSevenStr=..TAUStr)  
					{ s ..BeginSevenTauFlag="True"  
					  
					  set ResultWriteStr=ResultWriteStr_..BeignSevenStr
			          if ($L(ResultWriteStr)=Len)
			                  { D ResultStream.Write(ResultWriteStr)  
			                    S ResultWriteStr=""
			                      }
					}
					elseif '(..BeignSevenStr=..TAUStr)  
					{ 
					  set ResultWriteStr=ResultWriteStr_..BeignSevenStr
			          if ($L(ResultWriteStr)=Len)
			          { D ResultStream.Write(ResultWriteStr)  
			            S ResultWriteStr=""
			          }
                      D ..InitializaBeginStr()
					  D ..RewindBeginStatus()       
						}
				     }   
				}	
			}
			Elseif (LeftSevenStatus)
			{
				//Compare <![CDATA Mark
				if (I <= LengStr)
				{  Set ..BeginEightStr=$E(TempReadStr,I)
				   if (..BeginEightStr=..ALPHAStr)   
					{ s ..BeginEightAlephFlag="True"  
					  set ResultWriteStr=ResultWriteStr_..BeginEightStr
			          if ($L(ResultWriteStr)=Len)
			          { D ResultStream.Write(ResultWriteStr)  
			            S ResultWriteStr=""
			          }
					}
					elseif '(..BeginEightStr=..ALPHAStr)  
					{ 
					  set ResultWriteStr=ResultWriteStr_..BeginEightStr
			          if ($L(ResultWriteStr)=Len)
			          { D ResultStream.Write(ResultWriteStr)  
			            S ResultWriteStr=""
			          }
                      D ..InitializaBeginStr()
					  D ..RewindBeginStatus()       
						}
				     }   
				
				}  
			  
			  }
		  elseif (LeftEightStatus)
		  {	//Compare <![CDATA Mark
				if (I <= LengStr)
				{  Set ..BeginNineStr=$E(TempReadStr,I)
				   if (..BeginNineStr=..LefMidBracket)  
					{ s ..BeginNineLefMidBrackeFlag="True"  
					  set ResultWriteStr=ResultWriteStr_..BeginNineStr
					  D ResultStream.Write(ResultWriteStr) 
					  s ResultWriteStr="" 
					}
					elseif '(..BeginNineStr=..LefMidBracket)  
					{ set ResultWriteStr=ResultWriteStr_..BeginNineStr
					  if ($L(ResultWriteStr)=Len)
			          { D ResultStream.Write(ResultWriteStr)  
			            S ResultWriteStr=""
			          }
                      D ..InitializaBeginStr()
					  D ..RewindBeginStatus() 
						}
				     }   
			  }
		  
		  
		    }
	    Elseif (LeftStatus) 
	    {
		  if (..EndFirstMidBracket="False")
		  {
		    set ..EndFirstStr = $E(TempReadStr,I)
		    if '(..EndFirstStr=..ReghtMidBracket)
		    {
		       s CdataWriteStr=CdataWriteStr_..EndFirstStr
		       if ($L(CdataWriteStr)=Len)  
		        {  D ACDATAStream.Write(CdataWriteStr)
			     s CdataWriteStr=""    
			     }
			     s ..EndFirstStr=""
			  }
		    Elseif (..EndFirstStr=..ReghtMidBracket)
		    {
			   set ..EndFirstMidBracket="True"    
			    }	  
			   }
		  Elseif (..EndFirstMidBracket="True")
		  {	if (..EndTwoMidBracket="False")
			{
			  set ..EndTwoStr = $E(TempReadStr,I)
			  if '(..EndTwoStr=..ReghtMidBracket)
			  {
				s CdataWriteStr=CdataWriteStr_..EndFirstStr_..EndTwoStr
		       if ($L(CdataWriteStr)=Len)  
		        {
			     D ACDATAStream.Write(CdataWriteStr)
			     s CdataWriteStr=""    
			     }
			     s ..EndFirstStr=""
			     s ..EndTwoStr=""
			     s ..EndFirstMidBracket="False"
				 }
				elseif (..EndTwoStr=..ReghtMidBracket) 	
				{ set ..EndTwoMidBracket="True"    		
					}
				}
			Elseif (..EndTwoMidBracket="True")
			{
			  if (..EndThreeRightReserve ="False")
			  { 
			    set ..EndThreeStr = $E(TempReadStr,I)
			    if '(..EndThreeStr=..RightReserve)
			    { 
				 s CdataWriteStr=CdataWriteStr_..EndFirstStr_..EndTwoStr_..EndThreeStr
		         if ($L(CdataWriteStr)=Len)  
		         {
			      D ACDATAStream.Write(CdataWriteStr)
			      s CdataWriteStr=""    
			     }
			     s ..EndFirstStr=""
			     s ..EndTwoStr=""
			     s ..EndThreeStr=""
			     s ..EndFirstMidBracket="False"
			     s ..EndTwoMidBracket="False"
			    }
			    Elseif (..EndThreeStr=..RightReserve)
			    {
				  set ..EndThreeRightReserve="True"    		  
				  
                  D ACDATAStream.Write(CdataWriteStr)
				  s CdataWriteStr=""
				  set CdataItem = ##class(EPRservice.Util.CdataItem).%New()
				  d CdataItem.CDATAStream.CopyFrom(ACDATAStream) 
				  
				  d ACDATAStream.Clear()
				  s ..CdataCount= ..CdataCount+1
				  s CdataItem.CdataNum= ..CdataCount
				  s CdataItem.CdataSignNum= ..CdataSign
				  D CdataItem.%Save()
				  
				  Set EndTempStr= ..CdataCount_..EndFirstStr_..EndTwoStr_..EndThreeStr
				  Do ResultStream.Write(EndTempStr) 
				  
				  d ..InitializaComStr()
				  d ..RewindStatus()
				    }
			  }
				}
			  } 
             }
	     }
    }
   if ($L(ResultWriteStr)>0)
	{ D ResultStream.Write(ResultWriteStr)  
	  S ResultWriteStr=""
    }
    Q ResultStream
}

Method Automaton(AInputStream As %Stream) As %Stream
{
   //s ^AATime("Begin")= $ZTIMEH($ZTIME($PIECE($HOROLOG,",",2),1))
   
   D ..InitializeStatus()
   D AInputStream.Rewind()
   s ..CdataCount=0
   //s acdatastr=""
   //set ACdataAggr.CdataCount=0 
    
   set Len=1
   
   set ResultStream = ##class(%GlobalCharacterStream).%New()
   set ACDATAStream = ##class(%GlobalCharacterStream).%New()
   
    
   d ..InitializaComStr()
   //<![CDATA[
   While (AInputStream.AtEnd =0)
   { //Compare < Sign
     
     Set TempReadStr =AInputStream.Read(Len)
     S LeftStatus = ..CheckLeftCDATASign()
     //B "S"
     if '(LeftStatus)
     {
	  
	  set ..BeginFisrtStr= TempReadStr
      //Set ..BeginFisrtStr =AInputStream.Read(Len)
      if (..BeginFisrtStr=..LefReserve)
	  { 
	   set ..BeginFirstLefReserveFlag="True"	
	   if (AInputStream.AtEnd=0)
	   { 
	    //Compare ! Mark
	    Set ..BeginTwoStr=AInputStream.Read(Len)
	    if (..BeginTwoStr= ..ExclamationMark) 
	    { 
	    s ..BeginTwoExclamationFlag="True" 
           //Compare ! Mark
		   if (AInputStream.AtEnd=0)
		   { Set ..BeginThreeStr=AInputStream.Read(Len)
			 //  Compare <![ Mark
			 if (..BeginThreeStr=..LefMidBracket)  
			 {	s ..BeginThreeLefMidBracketFlag="True" 
				// Compare <![ Mark
				//if (..BeginThreeLefMidBracketFlag="True")
				  if (AInputStream.AtEnd=0)
	               {
		            set ..BeginFourStr=AInputStream.Read(Len) 
		            // Compare <![C Mark
		            if (..BeginFourStr=..GIMELStr) 
		            { s ..BeginFourGimelFlag="True"
			          // Compare <![C Mark
			          //if (..BeginFourGimelFlag="True")
			           if (AInputStream.AtEnd=0)
				        {
					     Set ..BeginFiveStr=AInputStream.Read(Len)   
					     // Compare <![CD Mark
					     if (..BeginFiveStr=..DELTALtaStr)   
					     {
						   set ..BeginFiveDeltaFlag= "True"
						   //if (..BeginFiveDeltaFlag="True")
						   // Compare <![CD Mark
							if (AInputStream.AtEnd=0)
							{
						     set ..BeginSixStr=AInputStream.Read(Len) 
						     // Compare <![CDA Mark
						     if (..BeginSixStr=..ALPHAStr)
						     {
							   set ..BeginSixAlephFlag="True"  
							   if (AInputStream.AtEnd=0)
							   {
								    Set ..BeignSevenStr =  AInputStream.Read(Len)
								    // Compare <![CDAT
								    if (..BeignSevenStr=..TAUStr ) 
								    {
									  Set ..BeginSevenTauFlag =  "True"
									  if (AInputStream.AtEnd=0)
									  {
										Set ..BeginEightStr= AInputStream.Read(Len)   
										if (..BeginEightStr = ..ALPHAStr)
										{
										   Set ..BeginEightAlephFlag =  "True"
										   if (AInputStream.AtEnd=0)
										   {
											s ..BeginNineStr =  AInputStream.Read(Len)     
											if (..BeginNineStr= ..LefMidBracket )
											{
											  
											  set ..BeginNineLefMidBrackeFlag="True"
                                                set TempStr=..BeginFisrtStr_..BeginTwoStr_..BeginThreeStr_..BeginFourStr_..BeginFiveStr_..BeginSixStr_..BeignSevenStr_..BeginEightStr_..BeginNineStr
			                                    D ResultStream.Write(TempStr)
			                                  
											  // Compare <![CDATA[ End Mark	  
											  if (AInputStream.AtEnd=1)
											  {
                                                set TempStr=..BeginFisrtStr_..BeginTwoStr_..BeginThreeStr_..BeginFourStr_..BeginFiveStr_..BeginSixStr_..BeignSevenStr_..BeginEightStr_..BeginNineStr
			                                    D ResultStream.Write(TempStr)
   		                                        D ..InitializaBeginStr() 
												  }	 
												}
											// Compare <![CDATA[ Not Mark	  
											elseif '( ..BeginNineStr=..LefMidBracket)
											{
                                              set TempStr=..BeginFisrtStr_..BeginTwoStr_..BeginThreeStr_..BeginFourStr_..BeginFiveStr_..BeginSixStr_..BeignSevenStr_..BeginEightStr_..BeginNineStr
			                                  D ResultStream.Write(TempStr)
		                                      D ..InitializaBeginStr() 
												}
											   }
										   // Compare <![CDATA End Mark	  
										   elseif (AInputStream.AtEnd=1)
										   {
                                              set TempStr=..BeginFisrtStr_..BeginTwoStr_..BeginThreeStr_..BeginFourStr_..BeginFiveStr_..BeginSixStr_..BeignSevenStr_..BeginEightStr
			                                  D ResultStream.Write(TempStr)
		                                      D ..InitializaBeginStr() 
											   }
										}
										// Compare <![CDATA Not Mark	  
										elseif '(..BeginEightStr = ..ALPHAStr)
										{
                                          set TempStr=..BeginFisrtStr_..BeginTwoStr_..BeginThreeStr_..BeginFourStr_..BeginFiveStr_..BeginSixStr_..BeignSevenStr_..BeginEightStr
			                              D ResultStream.Write(TempStr)
		                                  D ..InitializaBeginStr() 
											}  
										  
										  } 
									   // Compare <![CDAT End Mark	  
									  elseif (AInputStream.AtEnd=1)
									  {
                                        set TempStr=..BeginFisrtStr_..BeginTwoStr_..BeginThreeStr_..BeginFourStr_..BeginFiveStr_..BeginSixStr_..BeignSevenStr
			                            D ResultStream.Write(TempStr)
		                                D ..InitializaBeginStr() 
										  }  
									}
								    
								    // Compare <![CDAT Not Mark
								    Elseif '(..BeignSevenStr=..TAUStr ) 
								    {
                                      set TempStr=..BeginFisrtStr_..BeginTwoStr_..BeginThreeStr_..BeginFourStr_..BeginFiveStr_..BeginSixStr_..BeignSevenStr
			                          D ResultStream.Write(TempStr)
		                              D ..InitializaBeginStr() 
									 }
									 
								 }
								 Elseif (AInputStream.AtEnd=1)
								 { set TempStr=..BeginFisrtStr_..BeginTwoStr_..BeginThreeStr_..BeginFourStr_..BeginFiveStr_..BeginSixStr
			                       D ResultStream.Write(TempStr)
		                           D ..InitializaBeginStr() 
                                   }
							     }
                             // Compare <![CDA  Not Mark  							     
						     Elseif '(..BeginSixStr=..ALPHAStr)
						     {
                              set TempStr=..BeginFisrtStr_..BeginTwoStr_..BeginThreeStr_..BeginFourStr_..BeginFiveStr_..BeginSixStr
			                  D ResultStream.Write(TempStr)
		                      D ..InitializaBeginStr() 
		                      }							     
		                     }
							// Compare <![CD Mark End 
							Elseif (AInputStream.AtEnd=1)
							{ set TempStr=..BeginFisrtStr_..BeginTwoStr_..BeginThreeStr_..BeginFourStr_..BeginFiveStr
			                  D ResultStream.Write(TempStr)
		                      D ..InitializaBeginStr() 
		                      }
						}
							// Compare <![CD Mark 
  						 elseif (..BeginFiveStr '=..DELTALtaStr)   
						 { set TempStr=..BeginFisrtStr_..BeginTwoStr_..BeginThreeStr_..BeginFourStr_..BeginFiveStr
			               D ResultStream.Write(TempStr)
		                   D ..InitializaBeginStr() }    
						  }
						  // Compare <![C Mark  End    
				        elseif (AInputStream.AtEnd=1)
				        { set TempStr=..BeginFisrtStr_..BeginTwoStr_..BeginThreeStr_..BeginFourStr
			              D ResultStream.Write(TempStr)
		                  D ..InitializaBeginStr() 
		                  }   
			            }
				     // Compare <![C Mark     
		            elseif '(..BeginFourStr=..GIMELStr)
		            {   set TempStr=..BeginFisrtStr_..BeginTwoStr_..BeginThreeStr_..BeginFourStr
			            D ResultStream.Write(TempStr)
		                D ..InitializaBeginStr() 
			            }
		             
				}
              // Compare <![ Mark End   
              elseif (AInputStream.AtEnd=1)
		              { set TempStr=..BeginFisrtStr_..BeginTwoStr_..BeginThreeStr
			            D ResultStream.Write(TempStr)
		                D ..InitializaThreeBeginStr() 
			           } 

			   }
			   // Compare <![ Mark Not
			  elseif '(..BeginThreeStr=..LefMidBracket)  
			  {
			    set TempStr=..BeginFisrtStr_..BeginTwoStr_..BeginThreeStr
			    D ResultStream.Write(TempStr)
		        D ..InitializaThreeBeginStr() 
			  }

			   
		  }
		// Compare ! Mark  
    	elseif (AInputStream.AtEnd=1)
		 {  D ResultStream.Write(..BeginFisrtStr_..BeginTwoStr)
		   D ..InitializaTwoBeginStr() 
		  }
	     }
	     // Compare ! Mark
	     elseif '(..BeginTwoStr= ..ExclamationMark)
	    {
		  D ResultStream.Write(..BeginFisrtStr_..BeginTwoStr)
		  D ..InitializaTwoBeginStr() 
		    }
	 }
	  // Compare < Sign
	  elseif (AInputStream.AtEnd=1)
	 { D ResultStream.Write(..BeginFisrtStr)
	   S ..BeginFisrtStr =""
		  }
	}
	   // Compare < Sign
	  elseif (..BeginFisrtStr '=..LefReserve)  		
      {
	    D ResultStream.Write(..BeginFisrtStr)
	    S ..BeginFisrtStr =""
	  }
	     }
      Elseif (LeftStatus)
      {
	    //B "S"
	    //s uu="AAAAA"
	    s ..EndFirstStr = TempReadStr
	    
	     
	    if (..EndFirstStr=..ReghtMidBracket)
	    { 
	     set ..EndFirstMidBracket="True"
	     
	     if (AInputStream.AtEnd=0)
	     {
		     
		     set ..EndTwoStr=AInputStream.Read(Len)
		     
		     if (..EndTwoStr=..ReghtMidBracket)
		     {
			   set ..EndTwoMidBracket="True" 
			   
			   if (AInputStream.AtEnd=0)
			   {
				 set ..EndThreeStr=AInputStream.Read(Len) 
				 if (..EndThreeStr=..RightReserve ) 
				 { 
				 // B "S"
				  Set ..EndThreeRightReserve="True"
				  //D ..CDATAItems.Insert(ACDATAStream)
				  
				  set CdataItem = ##class(EPRservice.Util.CdataItem).%New()
				  d CdataItem.CDATAStream.CopyFrom(ACDATAStream) 
				  
				  d ACDATAStream.Clear()
				  
				  
				  //d ACdataAggr.Insert(CdataItem)
				  //s ACdataAggr.CdataCount=ACdataAggr.CdataCount+1
				  //D ACdataAggr.%Save()
				  
				  
				  //set CDATACount= ..CDATAItems.Count()
				  s ..CdataCount= ..CdataCount+1
				  s CdataItem.CdataNum= ..CdataCount
				  s CdataItem.CdataSignNum= ..CdataSign
				  D CdataItem.%Save()
				  //w CDATACount_" CDATACount" ,!
				  Set EndTempStr= ..CdataCount_..EndFirstStr_..EndTwoStr_..EndThreeStr
				  Do ResultStream.Write(EndTempStr) 
				  //w EndTempStr
				  d ..InitializaComStr()
				  D ..InitializeStatus() 
				  }
				 Elseif '(..EndThreeStr=..RightReserve ) 
				 {
		           Set EndTempStr= ..EndFirstStr_..EndTwoStr_..EndThreeStr
		            //D ACDATAStream.Write(EndTempStr)
		            //s acdatastr=acdatastr_ EndTempStr
		            d ..InitializaEndStr()
					  }
				   }
			   Elseif (AInputStream.AtEnd=1)
			   {
				 Set EndTempStr= ..EndFirstStr_..EndTwoStr
				 Do ResultStream.Write(EndTempStr) 
				 d ..InitializaComStr()
				 //D ..InitializeStatus()   
				 //D ResultStream.Write(Set EndTempStr= ..EndFirstStr_..EndTwoStr) 
				  
				   }
              }
			  elseif '(..EndTwoStr=..ReghtMidBracket)
			  {
		           Set EndTempStr= ..EndFirstStr_..EndTwoStr
		            //D ACDATAStream.Write(EndTempStr) 
		            //s acdatastr=acdatastr_ EndTempStr
		            d ..InitializaEndStr()
			  }
           }
	     Elseif (AInputStream.AtEnd=1)
	     {
		   D ResultStream.Write(..EndFirstStr)
		   d ..InitializaComStr()
		     }
	    }
	    elseif '(..EndFirstStr=..ReghtMidBracket)
	    {  
	       s EndTempStr = ..EndFirstStr 
	       //D ACDATAStream.Write(EndTempStr) 
	       //s acdatastr=acdatastr_ EndTempStr
		   d ..InitializaEndStr()
		}
  }

}
 //s ^AATime("End")= $ZTIMEH($ZTIME($PIECE($HOROLOG,",",2),1)) 
 Quit ResultStream
}

/// Desc:	抽取流数据中的CDATA数据节点
/// Optimization：
/// 		1)减少类对象及方法调用(特别是之前状态机初始化方法较多),降低系统调度及堆栈开销
/// 		2)读取流数据时每次读取32000至内存，与Cache流数据保持一致，降低IO读开销
/// 		  尽量在每次全部完成32000字符处理时，再写入流数据，可以最大化降低IO写开销
/// 		3)for循环内的if判断的模式选择，
/// 		  模式1：
/// 		  	if (flag=0)
/// 				{
/// 					if (char="<") 
/// 					{	s flag = 1}
/// 					else
/// 					{	s flag = 0}
/// 				}
/// 				.........
/// 			  模式2：
/// 			    if (flag=0)&&(char="<")
/// 			    {
/// 			    	s flag = 1
/// 				}
/// 				.........
/// 				else
/// 				{
/// 					s flag = 0
/// 				}
/// 		      分析：
/// 			  模式1比模式2在单条件处理上(从百万级到亿级)性能低10%至20%, 
/// 			  但是在我们这个方法中要处理的是一个12组条件的判断，通过优化模式1中的条件判断次序，
/// 			  我们可以使得几乎100%的条件判断在前三个次序中满足，从而在综合性能上模式1比模式2效率要高3至4倍
/// 			  因此我们选择模式1	
ClassMethod AutoMationByString(AInputStream As %Stream, ACDataSign As %String) As %Stream
{
	d AInputStream.Rewind()
	
	s retStream = ##class(%GlobalCharacterStream).%New()
	
	s flag = 0			//状态标识
	s cdataCount = 0	//CDATA数据节点数
	s cdataItem = "" 
	
	s streamStr = ""
	s cdataStr = ""
		
	while (AInputStream.AtEnd = 0)
	{
		s origionStr = AInputStream.Read(32000)
		s length = $Length(origionStr)
		
		
		for i = 1:1:length
		{
			s char = $e(origionStr,i,i)
			
			if (flag=0)
			{
				if (char="<") 
				{	s flag = 1}
				else
				{	s flag = 0}
				s streamStr = streamStr_char
			}
			elseif (flag=1)
			{
				if (char="!") 
				{	s flag = 2}
				else
				{	s flag = 0}
				s streamStr = streamStr_char
			}
			elseif (flag=9)			//flag=9分支移至此处优化性能，大图片流情况下条件判断会优先落入此分支
			{
				if (char="]")
				{	
					s flag = 10
					
					//此处有可能是CDATA的右结束符，也有可能是CDATA数据中的"]"字符，
					//因此此处暂不写入CDATA数据节点的第一个右结束符"]",和CDATA数据节点的最后一位右结束符统一写入
					//s streamStr = streamStr_char 
				}
				else
				{
					//当前状态标识就是CDATA数据节点开始状态标识"9"，此处不需要重置状态标识
					//当前处在CDATA数据节点下，读取到的字符都是CDATA数据
					s cdataStr = cdataStr_char 
				}
			}
			elseif (flag=2)
			{
				if (char="[") 
				{	s flag = 3}
				else
				{	s flag = 0}
				s streamStr = streamStr_char
			}
			elseif (flag=3)
			{
				if (char="C") 
				{	s flag = 4}
				else
				{	s flag = 0}
				s streamStr = streamStr_char
			}
			elseif (flag=4)
			{
				if (char="D") 
				{	s flag = 5}
				else
				{	s flag = 0}
				s streamStr = streamStr_char
			}
			elseif (flag=5)
			{
				if (char="A") 
				{	s flag = 6}
				else
				{	s flag = 0}
				s streamStr = streamStr_char
			}
			elseif (flag=6)
			{
				if (char="T") 
				{	s flag = 7}
				else
				{	s flag = 0}
				s streamStr = streamStr_char
			}
			elseif (flag=7)
			{
				if (char="A") 
				{	s flag = 8}
				else
				{	s flag = 0}
				s streamStr = streamStr_char
			}
			elseif (flag=8)
			{
				if (char="[") 
				{	
					s flag = 9
					
					s cdataCount= cdataCount+1
					s cdataItem = ##class(EPRservice.Util.CdataItem).%New() 
				  	s cdataItem.CdataNum= cdataCount
				  	s cdataItem.CdataSignNum= ACDataSign
				}
				else
				{	s flag = 0}
				s streamStr = streamStr_char
			}
			elseif (flag=10)
			{
				if (char="]")
				{
					s flag = 11
					
					//此处有可能是CDATA的第二个右结束符，也有可能是CDATA数据中的两个连续的"]"字符，
					//此处暂不写入CDATA数据节点的第二个右结束符"]",和CDATA数据节点的最后一位右结束符统一写入
					//s streamStr = streamStr_char 
				}
				else
				{
					//不是CDATA的结束符
					//状态标识跳转至CDATA数据节点开始状态标识"9";
					s flag = 9
					
					//当前处在CDATA数据节点下，读取到的字符都是CDATA数据
					//先补上之前未写入的"]"字符，再写入当前读到的字符，直接写入CData数据流中，防止cdataStr字符串跨边界超长报错
					s cdataStr = cdataStr_"]"_char
					d cdataItem.CDATAStream.Write(cdataStr)
					s cdataStr = ""
				}
			}
			elseif (flag=11)
			{
				if (char=">")
				{
					s flag = 0
					
					//此处是CDATA的结束，保存CData数据
					if (cdataStr '= "")
					{
						d cdataItem.CDATAStream.Write(cdataStr)
						s cdataStr = ""
					}
					d cdataItem.%Save()
					s cdataItem = ""
					
					//补写入之前的两个"]"字符
					//d retStream.Write(streamStr)
					//d retStream.Write(cdataCount_"]]>")
					s streamStr = streamStr_cdataCount_"]]>"
					d retStream.Write(streamStr)
					s streamStr = ""
					
				}
				else
				{
					//不是CDATA的结束符
					//状态标识跳转至CDATA数据节点开始状态标识"9";
					s flag = 9
					
					//当前处在CDATA数据节点下，读取到的字符都是CDATA数据
					//先补上之前未写入的两个"]"字符，再写入当前读到的字符，直接写入CData数据流中，防止cdataStr字符串跨边界超长报错
					s cdataStr = cdataStr_"]]"_char
					d cdataItem.CDATAStream.Write(cdataStr)
					s cdataStr = ""
				}
			}
		}
		
		if (streamStr '= "")
		{	
			d retStream.Write(streamStr)
			s streamStr = ""
		}
		if (cdataStr '= "")&&(cdataItem '= "")
		{	
			d cdataItem.CDATAStream.Write(cdataStr)
			s cdataStr = ""
		}
	}
		
	q retStream
}

}
