/// DHCCPMWeb.CPMSevice.BODataGateway
/// 
Class DHCCPMWeb.CPMSevice.BODataGateway Extends %SOAP.WebService [ ClassType = "", ProcedureBlock ]
{

/// Name of the WebService.
Parameter SERVICENAME = "DataGatewayInfo";

/// Parameter LOCATION = "http://10.10.141.117/trakcare/web";
/// TODO: change this to actual network address.
/// URL for invoking the WebService.
/// TODO: change this to actual SOAP namespace.
/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/metaservice";

/// TODO: add arguments and implementation.
/// 
ClassMethod TestQuery() As %XML.DataSet [ WebMethod ]
{
 
 Set rset = ##class(%XML.DataSet).%New()
 Set rset.ClassName = "EPRinstance.ISimple"
 Set rset.QueryName = "SelecSimple"
 set AParameterS= "91,13||1"
 set ParaCount = $LENGTH(AParameterS,",")
 set Args =""
 if (ParaCount >10) 
 {
  Quit ""	 
	 }
 if (ParaCount=1)	 
 {
	Do rset.SetArgs($P(AParameterS,",",1)) 
	 }
 elseif (ParaCount=2)	 
 {
	Do rset.SetArgs($P(AParameterS,",",1),$P(AParameterS,",",2))  
	 }	 
 
 elseif (ParaCount=3)	 
 {
	Do rset.SetArgs($P(AParameterS,",",1),$P(AParameterS,",",2),$P(AParameterS,",",3))  
	 }	 
 
 Quit rset
}

ClassMethod GetDataByQueryName(AClassName As %String, AQueryName As %String, AParameterS As %String) As %XML.DataSet [ WebMethod ]
{
 // Return the results of the Person class' ByName query.
 ;1.需要解析(AClassName||AQueryName)  的输入参数
 ;2.需要把传入的Parameters分解为^TMPCPMPrintPara($j,"")=""
 ;
 Set result=##class(%XML.DataSet).%New()
 
 set result.ClassName =AClassName
 set result.QueryName =AQueryName
 if (AParameterS="")
 {
   Do result.SetArgs() 
   Quit result
	 }
 elseif (AParameterS'="") 	 
 {set ParaCount = $LENGTH(AParameterS,",")
 
 set ParaCount = $LENGTH(AParameterS,",")
 if (ParaCount >10) 
 {
  Quit ""	 
	 }
 if (ParaCount=1)	 
 {
	Do result.SetArgs($P(AParameterS,",",1)) 
	 }
 elseif (ParaCount=2)	 
 {
	Do result.SetArgs($P(AParameterS,",",1),$P(AParameterS,",",2))  
	 }	 
 
 elseif (ParaCount=3)	 
 {
	Do result.SetArgs($P(AParameterS,",",1),$P(AParameterS,",",2),$P(AParameterS,",",3))  
	 }	 
 elseif (ParaCount=4)	 
 {
	Do result.SetArgs($P(AParameterS,",",1),$P(AParameterS,",",2),$P(AParameterS,",",3),$P(AParameterS,",",4))  
	 }	 
 elseif (ParaCount=5)	 
 {
	Do result.SetArgs($P(AParameterS,",",1),$P(AParameterS,",",2),$P(AParameterS,",",3),$P(AParameterS,",",4),$P(AParameterS,",",5))  
	 }	 
 elseif (ParaCount=6)	 
 {
	Do result.SetArgs($P(AParameterS,",",1),$P(AParameterS,",",2),$P(AParameterS,",",3),$P(AParameterS,",",4),$P(AParameterS,",",5),$P(AParameterS,",",6))  
	 }	 
 elseif (ParaCount=7)	 
 {
	Do result.SetArgs($P(AParameterS,",",1),$P(AParameterS,",",2),$P(AParameterS,",",3),$P(AParameterS,",",4),$P(AParameterS,",",5),$P(AParameterS,",",6),$P(AParameterS,",",7))  
	 }	 
 elseif (ParaCount=8)	 
 {
	Do result.SetArgs($P(AParameterS,",",1),$P(AParameterS,",",2),$P(AParameterS,",",3),$P(AParameterS,",",4),$P(AParameterS,",",5),$P(AParameterS,",",6),$P(AParameterS,",",7),$P(AParameterS,",",8))  
	 }	 
 elseif (ParaCount=9)	 
 {
	Do result.SetArgs($P(AParameterS,",",1),$P(AParameterS,",",2),$P(AParameterS,",",3),$P(AParameterS,",",4),$P(AParameterS,",",5),$P(AParameterS,",",6),$P(AParameterS,",",7),$P(AParameterS,",",8),$P(AParameterS,",",9))  
	 }	 
 elseif (ParaCount=10)	 
 {
	Do result.SetArgs($P(AParameterS,",",1),$P(AParameterS,",",2),$P(AParameterS,",",3),$P(AParameterS,",",4),$P(AParameterS,",",5),$P(AParameterS,",",6),$P(AParameterS,",",7),$P(AParameterS,",",8),$P(AParameterS,",",9),$P(AParameterS,",",10))  
	 }	 
 Quit result
 }
}

ClassMethod GetParameterString(AClassName As %String, AQueryName As %String) As %String [ WebMethod ]
{
 Set AQueryId = ##class(EPRmeta.BindQuery).SelectIDByClassName(AClassName,AQueryName)
 if (AQueryId= "")  	
 {
   Quit ""	 
	 }
 elseif (AQueryId'="")
 {
   
    Set AParaDataset=##class(%ResultSet).%New("%DynamicQuery:SQL")
	Do AParaDataset.Prepare("SELECT ID,ParameterName FROM EPRmeta.BindParameter Where QueryID= ?")
	do AParaDataset.Execute(AQueryId)
   
   set ReParaStr= ""
   
	 
  While (AParaDataset.Next()) 
  {
     if (ReParaStr="")
     {
      set ReParaStr= AParaDataset.Data("ParameterName")	     
      }
     elseif (ReParaStr'="") 
     {
       set ReParaStr= ReParaStr_","_ AParaDataset.Data("ParameterName")
     }
   }
	 
   
   Quit ReParaStr	
  }
}

//Get Data Interface

ClassMethod DBInterFace(AReciveString As %String) As %String [ WebMethod ]
{
   //first  Splite Recivestr into Four : Head,Single,Multiple ,SystemData
   K ^AR
   s ^AR($J,$HOROLOG) = AReciveString
  set AHeadStrStart = $Find(AReciveString,"$Head{")
 set ASingleStrStart = $Find(AReciveString,"$Single#Simple")
 set AMultipleStrStart = $Find(AReciveString,"$Multiple#Simple")
 set ASystemDateStrStart = $Find(AReciveString,"$SystemData")
 
 //first  find ASingleStr location or AMultipleStr or ASystemDateStr
 // return if have str Value  ,return Value
 //SingleStr MultipleStr SystemDateStr are assure   
 if (ASingleStrStart'=0)
 {
   
   set AHeadStr= $EXTRACT(AReciveString,AHeadStrStart,ASingleStrStart-16)	
   
   if (AMultipleStrStart '=0)
   { 
     
     set ASingleOrigiStr= $EXTRACT(AReciveString,ASingleStrStart-14,AMultipleStrStart-17)
     if (ASystemDateStrStart'=0) 
     {
	   set AMultipleOrigiStr= $EXTRACT(AReciveString,AMultipleStrStart-16,ASystemDateStrStart-12)  
	   set ASystemDateStr= $EXTRACT(AReciveString,ASystemDateStrStart-11,$L(AReciveString))  
	  }
     elseif (ASystemDateStrStart=0) 
     {
	  
	   set AMultipleOrigiStr= $EXTRACT(AReciveString,AMultipleStrStart-16,$L(AReciveString))  
	   set ASystemDateStr = ""
	     }
   }
   Elseif (AMultipleStrStart=0)
   {
     
     if (ASystemDateStrStart'=0) 
     {
	   set ASingleOrigiStr= $EXTRACT(AReciveString,ASingleStrStart-14,ASystemDateStrStart-12)	  
	   set AMultipleOrigiStr =""
	   set ASystemDateStr= $EXTRACT(AReciveString,ASystemDateStrStart-11,$L(AReciveString))  
	 }
	 if (ASystemDateStrStart=0) 
	 {
	  set ASingleOrigiStr= $EXTRACT(AReciveString,ASingleStrStart-14,$L(AReciveString))	  	
	  set AMultipleOrigiStr =""
	  set ASystemDateStr =""
	 }
   }	
 }
 elseif(ASingleStrStart=0)	 
 {
	set ASingleOrigiStr =""
	if (AMultipleStrStart '=0)
	{
      set AHeadStr= $EXTRACT(AReciveString,AHeadStrStart,AMultipleStrStart-17)
      if (ASystemDateStrStart'=0) 
      {
	   set AMultipleOrigiStr= $EXTRACT(AReciveString,AMultipleStrStart-16,ASystemDateStrStart-12)  
	   set ASystemDateStr= $EXTRACT(AReciveString,ASystemDateStrStart-11,$L(AReciveString))  
	      }
	  elseif (ASystemDateStrStart=0) 
	  {
        set AMultipleOrigiStr= $EXTRACT(AReciveString,AMultipleStrStart-16,$L(AReciveString))  		
		set ASystemDateStr = ""
		  }    
      }
	Elseif (AMultipleStrStart=0)
	{
	  set AMultipleOrigiStr=""
	  if (ASystemDateStrStart'=0) 
	  {
		set AHeadStr=$EXTRACT(AReciveString,AHeadStrStart,ASystemDateStrStart-12)
		set ASystemDateStr= $EXTRACT(AReciveString,ASystemDateStrStart-11,$L(AReciveString))  
	  }
	  elseif (ASystemDateStrStart=0) 
	  {
		set AHeadStr=$EXTRACT(AReciveString,AHeadStrStart,$L(AReciveString))
		set ASystemDateStr = ""  
		  }
	 	
		}
	 }
	 
 
 if (AHeadStr="")
 {
   Quit ""	 
	 }
 set ResultStr= "$Head{"_AHeadStr_"}"
  if (ASingleOrigiStr'="")
 {
  //B "S"
  set ASingleDataStr = ..GetSingleData(AHeadStr,ASingleOrigiStr)
  set ResultStr = ResultStr_ASingleDataStr
 } 
 //get Multipledata
 //B "S"
 if (AMultipleOrigiStr'="")
 {
   set AMultipleDataStr = ..GetMultipleData(AHeadStr,AMultipleOrigiStr)
   set ResultStr = ResultStr_AMultipleDataStr
 }	 
 //Get Systemdate
 if (ASystemDateStr'="")
 {
	set ReSystemDateStr = ..GetSysData(ASystemDateStr)
	set ResultStr = ResultStr_ReSystemDateStr
 }
 Quit ResultStr
}

ClassMethod GetSysData(ASystemDateStr) As %String
{
  // $SystemData{DATE,TIME}
  
  set Result ="$SystemData{"
  Set Tempstr= $P(ASystemDateStr,"{",2)
  if ($F(Tempstr,"}")=2)
  {
    s Result ="$SystemData{"_"}" 
    Quit Result
	  
	  }
  
  if ($F(Tempstr,",")=0)
  {
	s SysStart= $Find(Tempstr,"DATE")
	if (SysStart=5)
	{
		set Result=Result_$ZDATE($HOROLOG)_"}"
		Quit Result
		}
	 elseif (SysStart=0)	
	 {
		set Result=Result_$ZTIME($PIECE($HOROLOG,",",2),1)_"}"
		Quit Result
		  }
	  }
  elseif ($F(Tempstr,",")'=0) 	  
  {
	  
	set ItemCount = $LENGTH(Tempstr,",")	  
	 
    for I=  1 :1:ItemCount
    {
      SET AItemStr=$PIECE(Tempstr,",",I)
      set ItemStart= $Find(AItemStr,"DATE") 
      
      if (I'=ItemCount)
      { 
        if (ItemStart=5)
        {
	     s Result = Result_$ZDATE($HOROLOG)_"," 
	        }
	    elseif (ItemStart'=5)
	    {
		 s Result = Result_$ZTIME($PIECE($HOROLOG,",",2),1)_","    
		    }    
      }
      Elseif (I=ItemCount)
      {
        if (ItemStart=5)
        {
	     s Result = Result_$ZDATE($HOROLOG)_"}" 
	        }
	    elseif (ItemStart'=5)
	    {
		 s Result = Result_$ZTIME($PIECE($HOROLOG,",",2),1)_"}"    
		    }    
	   }
      }
      Quit Result 
}
}

ClassMethod ParseSingleList(AReciveSingle As %String)
{
 
 K ^CacheTempEPRGetSimple($J)
 K ^CacheTempEPRGetSegment($J)
 K ^CacheTempEPRGetTextDesc($J)
 
 set ASimpleStrStart = $Find(AReciveSingle,"#Simple{")
 
 set ASegmentStrStart = $Find(AReciveSingle,"#Segment{")
 
 set ATextDescStrStart = $Find(AReciveSingle,"#TextDesc{")
 
 set ASimpleStr= $EXTRACT(AReciveSingle,ASimpleStrStart,ASegmentStrStart-11)
 
 set ASegmentStr= $EXTRACT(AReciveSingle,ASegmentStrStart,ATextDescStrStart-12)
 
 set ATextDescStr= $EXTRACT(AReciveSingle,ATextDescStrStart,$L(AReciveSingle)-1)
 
 
 //splite Simple
 if (ASimpleStr'= "")
 {
 set SimpleItemCount = $LENGTH(ASimpleStr,",")
 for I=  1 :1:SimpleItemCount
 {
   
   SET ASimpleItem=$PIECE(ASimpleStr,",",I)
   //templateid
   set ^CacheTempEPRGetSimple($J,I)= $P(ASimpleItem,"|",1)
   // SimpleItemCode
   set ^CacheTempEPRGetSimple($J,I,"1")= $P(ASimpleItem,"|",2)
   //ValueCode
   set ^CacheTempEPRGetSimple($J,I,"2")= $P(ASimpleItem,"|",3)
   
 } 
 }

 //splite Segmentstr
 if (ASegmentStr'="")
 {
 set SegmentItemCount = $LENGTH(ASegmentStr,",")
 for I=  1 :1:SegmentItemCount
 {
   //Segment
   SET ASegmentItem=$PIECE(ASegmentStr,",",I)
   //templateid
   set ^CacheTempEPRGetSegment($J,I)= $P(ASegmentItem,"|",1)
   //SegmentCode
   set ^CacheTempEPRGetSegment($J,I,"1")= $P(ASegmentItem,"|",2)
 } 
 }

 //splite TextDescstr 
 if (ATextDescStr'="") 
 {
 set TextDescItemCount = $LENGTH(ATextDescStr,",")
 for I=  1 :1:TextDescItemCount
 {
  SET ATextDescItem=$PIECE(ATextDescStr,",",I)
  //TemplateID
  set ^CacheTempEPRGetTextDesc($J,I)= $P(ATextDescItem,"|",1)
   //TextDescCode
   set ^CacheTempEPRGetTextDesc($J,I,"1")= $P(ATextDescItem,"|",2)
 }
 
 }
}

ClassMethod ParseMultipleList(AReciveMultiple As %String, AInstanceID As %String)
{
 
 K ^CacheTempEPRMultipleGetSimple($J)
 K ^CacheTempEPRMultipleGetSegment($J)
 K ^CacheTempEPRMultipleGetTextDesc($J)
 K ^CacheTempEPRMultipleInstanceData($J)
 
 set ASimpleStrStart = $Find(AReciveMultiple,"#Simple{")
 
 set ASegmentStrStart = $Find(AReciveMultiple,"#Segment{")
 
 set ATextDescStrStart = $Find(AReciveMultiple,"#TextDesc{")
 
 set AInstanceDataStrStart = $Find(AReciveMultiple,"#InstanceData{")

 Set AInstanceDataStr = ""
 
 
 set ASimpleStr= $EXTRACT(AReciveMultiple,ASimpleStrStart,ASegmentStrStart-11)
 
 set ASegmentStr= $EXTRACT(AReciveMultiple,ASegmentStrStart,ATextDescStrStart-12)
 
 if (AInstanceDataStrStart=0)
 {
	 set ATextDescStr= $EXTRACT(AReciveMultiple,ATextDescStrStart,$L(AReciveMultiple)-1)
     set AInstanceDataStr = ""
     //set ^CacheTempEPRMultipleInstanceData($J,"InstanceData")="#InstanceData{}"
 }
 Elseif (AInstanceDataStrStart '=0)
 {
   set ATextDescStr= $EXTRACT(AReciveMultiple,ATextDescStrStart,AInstanceDataStrStart-16)	 
   set AInstanceDataStr = $EXTRACT(AReciveMultiple,AInstanceDataStrStart,$L(AReciveMultiple)-1)	 
   
 } 
 
 
 
 if (ASimpleStr'= "")
 {
 set SimpleItemCount = $LENGTH(ASimpleStr,",")
 for I=  1 :1:SimpleItemCount
 {
	SET ASimpleItem=$PIECE(ASimpleStr,",",I)

   set ^CacheTempEPRMultipleGetSimple($J,I)= $P(ASimpleItem,"|",1)
   
   set ^CacheTempEPRMultipleGetSimple($J,I,"1")= $P(ASimpleItem,"|",2)
   
   set ^CacheTempEPRMultipleGetSimple($J,I,"2")= $P(ASimpleItem,"|",3)
   
 }
 } 
 
 
 
 if (ASegmentStr'="")
 {
 
 set SegmentItemCount = $LENGTH(ASegmentStr,",")
 
 for I=  1 :1:SegmentItemCount
 {
	SET ASegmentItem=$PIECE(ASegmentStr,",",I)

   set ^CacheTempEPRMultipleGetSegment($J,I)= $P(ASegmentItem,"|",1)
  
   set ^CacheTempEPRMultipleGetSegment($J,I,"1")= $P(ASegmentItem,"|",2)
   
 } 
 }
 
 
 if (ATextDescStr'="")
 {
 set TextDescItemCount = $LENGTH(ATextDescStr,",")
 for I=  1 :1:TextDescItemCount
 {
  SET ATextDescItem=$PIECE(ATextDescStr,",",I)
  set ^CacheTempEPRMultipleGetTextDesc($J,I)= $P(ATextDescItem,"|",1)
   
   set ^CacheTempEPRMultipleGetTextDesc($J,I,"1")= $P(ATextDescItem,"|",2)
   
 }
 }
 
 
 //splite InstanceData and return data
 if (AInstanceDataStr'="")
 {
  set ReInsStr="#InstanceData{" 
  set InstanceDataItemCount = $LENGTH(AInstanceDataStr,",")	 
  if (AInstanceID'="")  
  {
	set objInstance=##class(EPRinstance.InstanceData).%OpenId(AInstanceID)
    if objInstance=""
	{
	 set ReInsStr= "#InstanceData{}"  
	 }	
		
    for I=1:1:InstanceDataItemCount
    {
	 SET InstanceDataItem=$PIECE(AInstanceDataStr,",",I) 
	 if InstanceDataItem="TITLE"
	 { 
	   if (I'=InstanceDataItemCount)
	    {
		   if (objInstance.Title'="") 
		   {			   
		    set ReInsStr=ReInsStr_objInstance.Title_","
			}
		   Elseif (objInstance.Title="") 
		   {
			set ReInsStr=ReInsStr_"*NULL"_","   
			   }
	   	}
		elseif (I=InstanceDataItemCount)
		 {
		   if (objInstance.Title'="") 
		   {			   
		   set ReInsStr=ReInsStr_objInstance.Title_"}"	
		  }
		  Elseif (objInstance.Title="") 
		  {
             set ReInsStr=ReInsStr_"*NULL"_"}"				  
			  }
		 }
	 }
	 elseif InstanceDataItem="HAPPENDATE"
	 {
	   if (I'=InstanceDataItemCount)
	    {
		  if (objInstance.HappenDate'="")
		  {  
		   set ReInsStr=ReInsStr_objInstance.HappenDate_","
		  }
		  elseif (objInstance.HappenDate="")
		  {
			set ReInsStr=ReInsStr_"*NULL"_","  
			  }
	   	}
		elseif (I=InstanceDataItemCount)
		 {
		   if (objInstance.HappenDate'="")
		   {
			 set ReInsStr=ReInsStr_objInstance.HappenDate_"}"	
			}
			elseif (objInstance.HappenDate="")
			{
		      set ReInsStr=ReInsStr_"*NULL"_"}"			
			}
		 }
	  }	
	 elseif InstanceDataItem="HAPPENTIME"
	 {
	   if (I'=InstanceDataItemCount)
	    {
		   if (objInstance.HappenTime'="")
		   {set ReInsStr=ReInsStr_objInstance.HappenTime_","}
		   Elseif (objInstance.HappenTime="")
		   {
			 set ReInsStr=ReInsStr_"*NULL"_","  
			   }
	   	}
		elseif (I=InstanceDataItemCount)
		 {
		   if (objInstance.HappenTime'="")
		   {
			   set ReInsStr=ReInsStr_objInstance.HappenTime_"}"	}
			elseif (objInstance.HappenTime="")
			{
				set ReInsStr=ReInsStr_"*NULL"_"}"  
				}   
		 }
	  }	
	 elseif InstanceDataItem="AUTHOR"
	 {
	   if (I'=InstanceDataItemCount)
	    {
		   set ReInsStr=ReInsStr_$P($G(^SSU("SSUSR",objInstance.CreateUser)),"^",2)_","
	   	}
		elseif (I=InstanceDataItemCount)
		 {
		   set ReInsStr=ReInsStr_$P($G(^SSU("SSUSR",objInstance.CreateUser)),"^",2)_"}"	
		 }
	  }	
	  } 
	 }
  set ^CacheTempEPRMultipleInstanceData($J,"InstanceData")=ReInsStr
  
 }
 Elseif (AInstanceDataStr="")
 {if (AInstanceDataStrStart>0)
   {
	 set ^CacheTempEPRMultipleInstanceData($J,"InstanceData")="#InstanceData{}"  
	   }
 }
}

ClassMethod GetMultipleData(AReciveHeadStr As %String, AReciveMultiple As %String) As %String
{
 
 K ^CacheTempEPRMultipleDataSimple($J)
 K ^CacheTempEPRMultipleDataSegment($J)
 K ^CacheTempEPRMultipleDataTextDesc($J)
 
  
 Set PatientID =  $PIECE($PIECE(AReciveHeadStr,",",1),":",2)
 Set PatientTag =  $PIECE($PIECE(AReciveHeadStr,",",1),":",1)
 Set EpisodeID =  $PIECE($PIECE(AReciveHeadStr,",",2),":",2)
 Set EpisodeTag =  $PIECE($PIECE(AReciveHeadStr,",",2),":",1)
 Set AInstanceDataID =  $PIECE($PIECE(AReciveHeadStr,",",3),":",2)
 Set InstanceDataTag =  $PIECE($PIECE(AReciveHeadStr,",",3),":",1) 
 S ^AR("AInstanceDataID",$HOROLOG)= AInstanceDataID 
 
 // parse Multiple single 
 do ..ParseMultipleList(AReciveMultiple,AInstanceDataID)
 
    
     
	set MultipleSimpleKey = $ORDER(^CacheTempEPRMultipleGetSimple($J,""))
    WHILE (MultipleSimpleKey '="") 
    {
     set ATemplateID     = $G(^CacheTempEPRMultipleGetSimple($J,MultipleSimpleKey)) 
     //B "S"
     set ASimpleItemCode = $G(^CacheTempEPRMultipleGetSimple($J,MultipleSimpleKey,"1")) 
     set AValueCode= $G(^CacheTempEPRMultipleGetSimple($J,MultipleSimpleKey,"2")) 
     set BlankTemplateID = " "_ATemplateID
     set BlankSimpleItemCode = " "_ASimpleItemCode
     set BlankEpisodeID= " "_EpisodeID
     set ACodeType = $EXTRACT(ASimpleItemCode,1)
     Set BlankInstanceDataID= " "_AInstanceDataID
     
     if $D(^DHCEPRI.ISimpleI)	     
     {
      set MultipleIndex = $O(^DHCEPRI.ISimpleI("IdxForLink",BlankEpisodeID,BlankTemplateID,BlankSimpleItemCode,BlankInstanceDataID,""))
     }
     else
     { 
      s MultipleIndex =""
      }
     if (MultipleIndex'="")
     {
	   set objISimple = ##class(EPRinstance.ISimple).%OpenId(MultipleIndex)
  	   if (ACodeType="S")||(ACodeType="N")||(ACodeType="O")||(ACodeType="M")||(ACodeType="Q")||(ACodeType="I")
	   {
		if (AValueCode="")
		{
         set ^CacheTempEPRMultipleDataSimple($J,MultipleSimpleKey)= objISimple.DataValue    			}
		Elseif (AValueCode="V")
	    {
		  set ^CacheTempEPRMultipleDataSimple($J,MultipleSimpleKey)= objISimple.DataValue    
		    
		    }
	    elseif (AValueCode="C")
	    {
          set ^CacheTempEPRMultipleDataSimple($J,MultipleSimpleKey)= objISimple.ValueCode    		    
		    }
	    elseif (AValueCode="VC")
	    {
		  set ^CacheTempEPRMultipleDataSimple($J,MultipleSimpleKey)= objISimple.DataValue_objISimple.ValueCode
		  }
	    elseif (AValueCode="CV")
	    {
		  set ^CacheTempEPRMultipleDataSimple($J,MultipleSimpleKey)= objISimple.ValueCode_objISimple.DataValue
		  }
	    elseif (AValueCode="VANDC")
	    {
		  set ^CacheTempEPRMultipleDataSimple($J,MultipleSimpleKey)= objISimple.DataValue_"^"_objISimple.ValueCode  
		  }
		  }
      elseif (ACodeType="D")
      {
		if (AValueCode="V")
	    {
		  set ^CacheTempEPRMultipleDataSimple($J,MultipleSimpleKey)= objISimple.DataValue  
		    }
	    elseif (AValueCode="C")
	    { 
	      set ^CacheTempEPRMultipleDataSimple($J,MultipleSimpleKey)= objISimple.ValueCode
	    }
	    elseif (AValueCode="VANDC")
	    {
		  set ^CacheTempEPRMultipleDataSimple($J,MultipleSimpleKey)= objISimple.DataValue_"^"_objISimple.ValueCode   
		  }
	    elseif (AValueCode="YEAR")
	    {
		  
		  Set TempDateTime = objISimple.DataValue
		  set AYearValue = $P(TempDateTime,"-",1)
		  
		  set ^CacheTempEPRMultipleDataSimple($J,MultipleSimpleKey)= AYearValue
		  }
	    elseif (AValueCode="MONTH")
	    {
		  Set TempDateTime = objISimple.DataValue
		  set AMonthValue = $P(TempDateTime,"-",2)
		  
		  set ^CacheTempEPRMultipleDataSimple($J,MultipleSimpleKey)= AMonthValue
		  }
	     elseif (AValueCode="DAY")
	     {
		  Set TempDateTime = objISimple.DataValue
		  set ADayValue = $P($P(TempDateTime," ",1),"-",3)
		  
		  set ^CacheTempEPRMultipleDataSimple($J,MultipleSimpleKey)= ADayValue
		  }
	    elseif (AValueCode="HOUR")
	    {
		  Set TempDateTime = objISimple.DataValue
		  set AHourValue = $P($P(TempDateTime," ",2),":",1)
		  
		  set ^CacheTempEPRMultipleDataSimple($J,MultipleSimpleKey)= AHourValue
		  }
	    elseif (AValueCode="MINUTE")
	    {
		  Set TempDateTime = objISimple.DataValue
		  set AMinuteValue = $P($P(TempDateTime," ",2),":",2)
		  
		  set ^CacheTempEPRMultipleDataSimple($J,MultipleSimpleKey)= AMinuteValue
		  }
	    elseif (AValueCode="SECOND")
	    {
		  Set TempDateTime = objISimple.DataValue
		  set ASecondValue = $P($P(TempDateTime," ",2),":",3)
		  
		  set ^CacheTempEPRMultipleDataSimple($J,MultipleSimpleKey)= ASecondValue
		  }
	     }		  
	   
	 }
	 Elseif (MultipleIndex="")
	 {
		
       set ^CacheTempEPRMultipleDataSimple($J,MultipleSimpleKey)= "*NULL"
		 } 
    SET MultipleSimpleKey = $ORDER(^CacheTempEPRMultipleGetSimple($J,MultipleSimpleKey))	  	
   }
   
   set Result= "$Multiple#Simple{" 
   set MultipleSimpleDataKey = $ORDER(^CacheTempEPRMultipleDataSimple($J,""))
   if (MultipleSimpleDataKey= "")
   {
	 set MultipleFlag = "False"
   }
   WHILE (MultipleSimpleDataKey'="")
   {
     if $G(^CacheTempEPRMultipleDataSimple($J,MultipleSimpleDataKey))'=""
     {
	     set Result = Result _ $G(^CacheTempEPRMultipleDataSimple($J,MultipleSimpleDataKey))_"@^"
	     }
     if ($G(^CacheTempEPRMultipleDataSimple($J,MultipleSimpleDataKey))="")
     {
	   set Result = Result _ "*NULL"_"@^"  
	     }
     
     set MultipleFlag = "True"
    SET MultipleSimpleDataKey = $ORDER(^CacheTempEPRMultipleDataSimple($J,MultipleSimpleDataKey))	  		 
   }
 
   if (MultipleFlag="False")
   {
	 set Result=Result_"}#Segment{" 
   }
   elseif(MultipleFlag = "True")	 
   {
     set TempStr = Result
     Set Result = $EXTRACT(TempStr,1,$L(TempStr)-2) 	 
     set Result=Result_"}#Segment{"	 
    }
 //}
 
 
 
 
 //Segment SegmentCode
 Set MultipleSegmentKey = $O(^CacheTempEPRMultipleGetSegment($J,""))
 
 WHILE (MultipleSegmentKey'="") 
 {
   set ATemplateID= $G(^CacheTempEPRMultipleGetSegment($J,MultipleSegmentKey)) 
   
   set ASegmentCode= $G(^CacheTempEPRMultipleGetSegment($J,MultipleSegmentKey,"1")) 
   set BlankSegmentCode = " "_ASegmentCode
   
   
   set BlankTemplateID = " "_ATemplateID
   set BlankInstanceDataID=" "_AInstanceDataID
   set BlankEpisodeID= " "_EpisodeID
   
   if $D(^DHCEPRI.ISegmentI)
   {
	   set MultipleIndex = $O(^DHCEPRI.ISegmentI("IdxForLink",BlankEpisodeID,BlankTemplateID,BlankSegmentCode,BlankInstanceDataID,""))
   }
   else 
   {
	 s MultipleIndex =""  
	   }
   if (MultipleIndex'="")
   {
	  set objISegment = ##class(EPRinstance.ISegment).%OpenId(MultipleIndex)
	  Set StrText= ""
      While (objISegment.Text.AtEnd = 0) 
      {
        Set len = 100
        set TmpStrText= objISegment.Text.Read(len)
        set StrText= StrText_TmpStrText  
        }
	  set ^CacheTempEPRMultipleDataSegment($J,MultipleSegmentKey)= StrText
	  
	  Set FormateInfoStr= ""
       While (objISegment.FormateInfo.AtEnd = 0) 
       {
        Set len = 100
        set TempInfoStr= objISegment.FormateInfo.Read(len)
        set FormateInfoStr= FormateInfoStr_TempInfoStr
        }
	 set ^CacheTempEPRMultipleDataSegment($J,MultipleSegmentKey,"1")= FormateInfoStr 
	}
	Elseif (MultipleIndex="")
	{
     set ^CacheTempEPRMultipleDataSegment($J,MultipleSegmentKey)= "*NULL"
     set ^CacheTempEPRMultipleDataSegment($J,MultipleSegmentKey,"1")= "*NULL"
     
     }
   SET MultipleSegmentKey = $ORDER(^CacheTempEPRMultipleGetSegment($J,MultipleSegmentKey))	  	
   
 }
 
 
 // Make Segment 
 set MultipleSegmentDataKey = $ORDER(^CacheTempEPRMultipleDataSegment($J,""))
 if (MultipleSegmentDataKey= "")
 {
	set MultipleFlag = "False"
	 }
 WHILE (MultipleSegmentDataKey'="")
 {
  set Result = Result _ $G(^CacheTempEPRMultipleDataSegment($J,MultipleSegmentDataKey))_"@|"
  set Result = Result _ $G(^CacheTempEPRMultipleDataSegment($J,MultipleSegmentDataKey,"1"))_"@^"
 
  set MultipleFlag = "True"
  SET MultipleSegmentDataKey = $ORDER(^CacheTempEPRMultipleDataSegment($J,MultipleSegmentDataKey))	  		 
 }
 
 if (MultipleFlag="False")
 {set Result=Result_"}#TextDesc{"}
 elseif(MultipleFlag = "True")	 
 {
  set TempStr = Result
  Set Result = $EXTRACT(TempStr,1,$L(TempStr)-2) 	 
  set Result=Result_"}#TextDesc{"	 
 }
 
 s ^BBB("MSegmet")= Result

 //TextDesc
 //
 Set MultipleTextDescKey = $ORDER(^CacheTempEPRMultipleGetTextDesc($J,""))
 
 WHILE (MultipleTextDescKey'="") 
 {
   set ATemplateID= $G(^CacheTempEPRMultipleGetTextDesc($J,MultipleTextDescKey)) 
   set ATextDescCode= $G(^CacheTempEPRMultipleGetTextDesc($J,MultipleTextDescKey,"1")) 
   set BlankTextDescCode = " "_ATextDescCode
   set BlankTemplateID = " "_ATemplateID
   set BlankInstanceDataID=" "_AInstanceDataID
   set BlankEpisodeID= " "_EpisodeID
   if $D(^DHCEPRI.ITextDescI)
   {
	set MultipleIndex = $O(^DHCEPRI.ITextDescI("IdxForLink",BlankEpisodeID,BlankTemplateID,BlankTextDescCode,BlankInstanceDataID,""))   
	   }
	else
	{
	 s MultipleIndex= ""	
		}   
   if (MultipleIndex'="")
   {
	  set objITextDesc = ##class(EPRinstance.ITextDesc).%OpenId(MultipleIndex)
	  Set StrText= ""
      While (objITextDesc.Text.AtEnd = 0) 
      {
        Set len = 100
        set TmpStrText= objITextDesc.Text.Read(len)
        set StrText= StrText_TmpStrText  
        }
	  set ^CacheTempEPRMultipleDataTextDesc($J,MultipleTextDescKey)= StrText
	  
	  Set FormateInfoStr= ""
       While (objITextDesc.FormateInfo.AtEnd = 0) 
       {
        Set len = 100
        set TempInfoStr= objITextDesc.FormateInfo.Read(len)
        set FormateInfoStr= FormateInfoStr_TempInfoStr
        }
	  set ^CacheTempEPRMultipleDataTextDesc($J,MultipleTextDescKey,"1")= FormateInfoStr
	  
	  
	}
	Elseif (MultipleIndex="")
	{
	  set ^CacheTempEPRMultipleDataTextDesc($J,MultipleTextDescKey)= "*NULL"
	  set ^CacheTempEPRMultipleDataTextDesc($J,MultipleTextDescKey,"1")= "*NULL"
		}
   SET MultipleTextDescKey = $ORDER(^CacheTempEPRMultipleGetTextDesc($J,MultipleTextDescKey))	  	
   
 }
 s ^BBB("Mtext")= Result
 
 // Make TextDesc 
 set MultipleTextDescDataKey = $ORDER(^CacheTempEPRMultipleDataTextDesc($J,""))
 if (MultipleTextDescDataKey= "")
 {
	set MultipleFlag = "False"
	 }
 WHILE (MultipleTextDescDataKey'="")
 {
  set Result = Result _ $G(^CacheTempEPRMultipleDataTextDesc($J,MultipleTextDescDataKey))_"@|"
  set Result = Result _ $G(^CacheTempEPRMultipleDataTextDesc($J,MultipleTextDescDataKey,"1"))_"@^"
  set MultipleFlag = "True"
  SET MultipleTextDescDataKey = $ORDER(^CacheTempEPRMultipleDataTextDesc($J,MultipleTextDescDataKey))	  		 
 }
 
 
 if (MultipleFlag="False")
 {
	
	
	set Result=Result_"}" 
	
}
 elseif(MultipleFlag = "True")	 
 {
  set TempStr = Result
  Set Result = $EXTRACT(TempStr,1,$L(TempStr)-2) 	 
  set Result=Result_"}"	 
 }
 if ($G(^CacheTempEPRMultipleInstanceData($J,"InstanceData"))'= "")
  {
	s Result =Result_ $G(^CacheTempEPRMultipleInstanceData($J,"InstanceData"))
	  } 
 //w Result
 quit Result
}

//return Single#Simple

ClassMethod GetSingleData(AReciveHeadStr As %String, AReciveSingle As %String) As %String
{
 //B "OFF"
 K ^CacheTempEPRSingleDataSimple($J)
 K ^CacheTempEPRSingleDataSegment($J)
 K ^CacheTempEPRSingleDataTextDesc($J)
 
 
 
 
 Set PatientID =  $PIECE($PIECE(AReciveHeadStr,",",1),":",2)
 Set PatientTag =  $PIECE($PIECE(AReciveHeadStr,",",1),":",1)
 Set EpisodeID =  $PIECE($PIECE(AReciveHeadStr,",",2),":",2)
 Set EpisodeTag =  $PIECE($PIECE(AReciveHeadStr,",",2),":",1)
 Set AInstanceDataID =  $PIECE($PIECE(AReciveHeadStr,",",3),":",2)
 Set InstanceDataTag =  $PIECE($PIECE(AReciveHeadStr,",",3),":",1) 
 
 //parse string single 
 do ..ParseSingleList(AReciveSingle)
 
 Merge ^EPRGetSimple=^CacheTempEPRGetSimple($J)
 //Simple
 set SingleSimpleKey = $ORDER(^CacheTempEPRGetSimple($J,""))
 
 
 WHILE (SingleSimpleKey'="") 
 { 
   
   set ATemplateID= $G(^CacheTempEPRGetSimple($J,SingleSimpleKey)) 
   
   set ASimpleItemCode= $G(^CacheTempEPRGetSimple($J,SingleSimpleKey,"1")) 
   set AValueCode= $G(^CacheTempEPRGetSimple($J,SingleSimpleKey,"2")) 
   set BlankSimpleItemCode =" "_ASimpleItemCode
   set BlankEpisodeID =" "_EpisodeID
   set BlankTemplateID = " "_ATemplateID
   
   set ACodeType = $EXTRACT(ASimpleItemCode,1)
   
   if $D(^DHCEPRI.ISimpleI)
   {
	 /*if (AInstanceDataID="")
	 {*/
	   Set BlankInstanceDataID=$O(^DHCEPRI.ISimpleI("IdxForLink",BlankEpisodeID,BlankTemplateID,BlankSimpleItemCode,"")) 
	 /*}
	 if (AInstanceDataID'="")
	 {
	   Set BlankInstanceDataID= " "_AInstanceDataID
	 }*/
     if (BlankInstanceDataID'="")
	    {
		  Set SingleIndex= $O(^DHCEPRI.ISimpleI("IdxForLink",BlankEpisodeID,BlankTemplateID,BlankSimpleItemCode,BlankInstanceDataID,""))   
	    }
	    elseif (BlankInstanceDataID="")
	    {
	     s SingleIndex = ""	 
		 }
	   }
	else 
	{
	 s SingleIndex = ""
	} 
	  
   if (SingleIndex'="")
   {
	  set objISimple = ##class(EPRinstance.ISimple).%OpenId(SingleIndex)
	  
	   
	  if (ACodeType="S")||(ACodeType="N")||(ACodeType="O")||(ACodeType="M")||(ACodeType="Q")||(ACodeType="I")
	  {
		if (AValueCode="")
		{
		  set ^CacheTempEPRSingleDataSimple($J,SingleSimpleKey)= objISimple.DataValue    
		}
		Elseif (AValueCode="V")
	    {
		  set ^CacheTempEPRSingleDataSimple($J,SingleSimpleKey)= objISimple.DataValue    
		    
		    }
	    elseif (AValueCode="C")
	    {
          set ^CacheTempEPRSingleDataSimple($J,SingleSimpleKey)= objISimple.ValueCode    		    
		    }
	    elseif (AValueCode="VC")
	    {
		  set ^CacheTempEPRSingleDataSimple($J,SingleSimpleKey)= objISimple.DataValue_objISimple.ValueCode
		  }
	    elseif (AValueCode="CV")
	    {
		  set ^CacheTempEPRSingleDataSimple($J,SingleSimpleKey)= objISimple.ValueCode_objISimple.DataValue
		  }
	    elseif (AValueCode="VANDC")
	    {
		  set ^CacheTempEPRSingleDataSimple($J,SingleSimpleKey)= objISimple.DataValue_"^"_objISimple.ValueCode  
		  }
		  }
     elseif (ACodeType="D")
     {
		if (AValueCode="V")
	    {
		  set ^CacheTempEPRSingleDataSimple($J,SingleSimpleKey)= objISimple.DataValue  
		    }
	    elseif (AValueCode="C")
	    { 
	      set ^CacheTempEPRSingleDataSimple($J,SingleSimpleKey)= objISimple.ValueCode
	    }
	    elseif (AValueCode="VANDC")
	    {
		  set ^CacheTempEPRSingleDataSimple($J,SingleSimpleKey)= objISimple.DataValue_"^"_objISimple.ValueCode   
		  }
	    elseif (AValueCode="YEAR")
	    {
		  
		  Set TempDateTime = objISimple.DataValue
		  set AYearValue = $P(TempDateTime,"-",1)
		  
		  set ^CacheTempEPRSingleDataSimple($J,SingleSimpleKey)= AYearValue
		  }
	    elseif (AValueCode="MONTH")
	    {
		  Set TempDateTime = objISimple.DataValue
		  set AMonthValue = $P(TempDateTime,"-",2)
		  
		  set ^CacheTempEPRSingleDataSimple($J,SingleSimpleKey)= AMonthValue
		  }
	    elseif (AValueCode="DAY")
	    {
		  Set TempDateTime = objISimple.DataValue
		  set ADayValue = $P($P(TempDateTime," ",1),"-",3)
		  
		  set ^CacheTempEPRSingleDataSimple($J,SingleSimpleKey)= ADayValue
		  }
	    elseif (AValueCode="HOUR")
	    {
		  Set TempDateTime = objISimple.DataValue
		  set AHourValue = $P($P(TempDateTime," ",2),":",1)
		  
		  set ^CacheTempEPRSingleDataSimple($J,SingleSimpleKey)= AHourValue
		  }
	    elseif (AValueCode="MINUTE")
	    {
		  Set TempDateTime = objISimple.DataValue
		  set AMinuteValue = $P($P(TempDateTime," ",2),":",2)
		  
		  set ^CacheTempEPRSingleDataSimple($J,SingleSimpleKey)= AMinuteValue
		  }
	    elseif (AValueCode="SECOND")
	    {
		  Set TempDateTime = objISimple.DataValue
		  set ASecondValue = $P($P(TempDateTime," ",2),":",3)
		  
		  set ^CacheTempEPRSingleDataSimple($J,SingleSimpleKey)= ASecondValue
		  }
	     }		  
		  
	  // set ^CacheTempEPRSingleDataSimple($J,SingleSimpleKey)= objISimple.DataValue
	}
	Elseif (SingleIndex="")
	{
     set ^CacheTempEPRSingleDataSimple($J,SingleSimpleKey)= "*NULL"
    }
    
   SET SingleSimpleKey = $ORDER(^CacheTempEPRGetSimple($J,SingleSimpleKey))	  	
   
  }
 
 B "S"
 //Segment
 set SingleSegmentKey = $ORDER(^CacheTempEPRGetSegment($J,""))
 WHILE (SingleSegmentKey'="") 
 {
   set ATemplateID= $G(^CacheTempEPRGetSegment($J,SingleSegmentKey)) 
   set BlankTemplateID= " "_ATemplateID
   set BlankEpisodeID =" "_EpisodeID
   set ASegmentCode= $G(^CacheTempEPRGetSegment($J,SingleSegmentKey,"1")) 
   Set BlankSegmentCode =" "_ASegmentCode
   if $D(^DHCEPRI.ISegmentI)	   
   {
	   /*if (AInstanceDataID="")
	   {*/
		Set BlankInstanceDataID=$O(^DHCEPRI.ISegmentI("IdxForLink",BlankEpisodeID,BlankTemplateID,BlankSegmentCode,"")) 
		  /* }
	   elseif (AInstanceDataID'="")	   
	   {
		  s BlankInstanceDataID=" "_AInstanceDataID
       } */
       if (BlankInstanceDataID'="")
       {
        Set SingleIndex= $O(^DHCEPRI.ISegmentI("IdxForLink",BlankEpisodeID,BlankTemplateID,BlankSegmentCode,BlankInstanceDataID,""))   
       }
       elseif (BlankInstanceDataID="")
       {
	     s SingleIndex= ""  
	       }
       
   }
   else 
   {
	  s SingleIndex =""
	}
   
   if (SingleIndex'="")
   {
	  set objISegment = ##class(EPRinstance.ISegment).%OpenId(SingleIndex)
	  
	  Set StrText= ""
       While (objISegment.Text.AtEnd = 0) 
       {
        Set len = 100
        set TmpStrText= objISegment.Text.Read(len)
        set StrText= StrText_TmpStrText  
        }
	  set ^CacheTempEPRSingleDataSegment($J,SingleSegmentKey)= StrText
	  
	  Set FormateInfoStr= ""
       While (objISegment.FormateInfo.AtEnd = 0) 
       {
        Set len = 100
        set TempInfoStr= objISegment.FormateInfo.Read(len)
        set FormateInfoStr= FormateInfoStr_TempInfoStr
        }
	  set ^CacheTempEPRSingleDataSegment($J,SingleSegmentKey,"1")= FormateInfoStr
	}
	Elseif (SingleIndex="")
	{
	  set ^CacheTempEPRSingleDataSegment($J,SingleSegmentKey)= "*NULL"
	  set ^CacheTempEPRSingleDataSegment($J,SingleSegmentKey,"1")= "*NULL"
		}
   SET SingleSegmentKey = $ORDER(^CacheTempEPRGetSegment($J,SingleSegmentKey))	  	
  }
 
 //TextDesc
 //B "S"
 set SingleTextDescKey = $ORDER(^CacheTempEPRGetTextDesc($J,""))
 WHILE (SingleTextDescKey'="") 
 {
   //B "S"
   set ATemplateID= $G(^CacheTempEPRGetTextDesc($J,SingleTextDescKey)) 
   set ATextDescCode= $G(^CacheTempEPRGetTextDesc($J,SingleTextDescKey,"1")) 
   
   set BlankTextDescCode =" "_ATextDescCode
   set BlankEpisodeID =" "_EpisodeID
   set BlankTemplateID = " "_ATemplateID
   
   if $D(^DHCEPRI.ITextDescI)	   
   {
	   
	   /*if (AInstanceDataID="")
	   { */
		 Set BlankInstanceDataID= $O(^DHCEPRI.ITextDescI("IdxForLink",BlankEpisodeID,BlankTemplateID,BlankTextDescCode,""))    
		/*}
	   elseif (AInstanceDataID'="")
	   {
		 s BlankInstanceDataID= " "_AInstanceDataID
		}*/
	   
	   if (BlankInstanceDataID'="")
       {
	       Set SingleIndex= $O(^DHCEPRI.ITextDescI("IdxForLink",BlankEpisodeID,BlankTemplateID,BlankTextDescCode,BlankInstanceDataID,""))   
	    }
	    elseif (BlankInstanceDataID="")   
	    {
		   s SingleIndex= ""  
		    }
   }
   Else 
   {
	 s SingleIndex = ""  
	}
	   
   if (SingleIndex'="")
   {
	  set objITextDesc = ##class(EPRinstance.ITextDesc).%OpenId(SingleIndex)
	  
	  Set StrText= ""
      While (objITextDesc.Text.AtEnd = 0) 
      {
        Set len = 100
        set TmpStrText= objITextDesc.Text.Read(len)
        set StrText= StrText_TmpStrText  
       }
	  
	  set ^CacheTempEPRSingleDataTextDesc($J,SingleTextDescKey)= StrText

	  Set FormateInfoStr= ""
      While (objITextDesc.FormateInfo.AtEnd = 0) 
      {
        Set len = 100
        set TempInfoStr= objITextDesc.FormateInfo.Read(len)
        set FormateInfoStr= FormateInfoStr_TempInfoStr
       }
	  set ^CacheTempEPRSingleDataTextDesc($J,SingleTextDescKey,"1")= FormateInfoStr
	}
	Elseif (SingleIndex="")
	{
	 set ^CacheTempEPRSingleDataTextDesc($J,SingleTextDescKey)= "*NULL"
	 set ^CacheTempEPRSingleDataTextDesc($J,SingleTextDescKey,"1")= "*NULL"
		}
   SET SingleTextDescKey = $ORDER(^CacheTempEPRGetTextDesc($J,SingleTextDescKey))	  	
  }
  
 Merge ^BABAC= ^CacheTempEPRSingleDataTextDesc
 
 //Simple write Simple string
 set Result= "$Single#Simple{" 
 set SingleSimpleDataKey = $ORDER(^CacheTempEPRSingleDataSimple($J,""))
 if (SingleSimpleDataKey= "")
 {
	set SimpleFlag = "False"
	 }
 WHILE (SingleSimpleDataKey'="")
 {
  if ($G(^CacheTempEPRSingleDataSimple($J,SingleSimpleDataKey))'="")
  {
   set Result = Result _ $G(^CacheTempEPRSingleDataSimple($J,SingleSimpleDataKey))_"@^"
  }
  if ($G(^CacheTempEPRSingleDataSimple($J,SingleSimpleDataKey))="")
  {
	set Result = Result _ "*NULL"_"@^" 
	  }
  set SimpleFlag = "True"
  SET SingleSimpleDataKey = $ORDER(^CacheTempEPRSingleDataSimple($J,SingleSimpleDataKey))	  		 
 }
 
 if (SimpleFlag="False")
 {set Result=Result_"}#Segment{" }
 elseif(SimpleFlag = "True")	 
 {set TempStr = Result
  Set Result = $EXTRACT(TempStr,1,$L(TempStr)-2) 	 
  set Result=Result_"}#Segment{"	 
 }
 
 //write Segment string 
 set SingleSegmentDataKey = $ORDER(^CacheTempEPRSingleDataSegment($J,""))
 if (SingleSegmentDataKey= "")
 {
	set SegmentFlag = "False"
	 }
 WHILE (SingleSegmentDataKey'="")
 {
  if $G(^CacheTempEPRSingleDataSegment($J,SingleSegmentDataKey))'=""
  {
	  set Result = Result _ $G(^CacheTempEPRSingleDataSegment($J,SingleSegmentDataKey))_"@|"
  }
  Elseif ($G(^CacheTempEPRSingleDataSegment($J,SingleSegmentDataKey))="")
  {
	set Result = Result _ "*NULL"_"@|"  
	}
  if ($G(^CacheTempEPRSingleDataSegment($J,SingleSegmentDataKey,"1"))'="")
  {
	  set Result = Result _ $G(^CacheTempEPRSingleDataSegment($J,SingleSegmentDataKey,"1"))_"@^"
  } 	  
  elseif ($G(^CacheTempEPRSingleDataSegment($J,SingleSegmentDataKey,"1"))="")
  {
	 set Result = Result _ "*NULL"_"@^" 
  }
  set SegmentFlag = "True"
  SET SingleSegmentDataKey = $ORDER(^CacheTempEPRSingleDataSegment($J,SingleSegmentDataKey))	  		 
 }
 
 if (SegmentFlag="False")
 {set Result=Result_"}#TextDesc{" }
 elseif(SegmentFlag = "True")	 
 {set TempStr = Result
  Set Result = $EXTRACT(TempStr,1,$L(TempStr)-2) 	 
  set Result=Result_"}#TextDesc{"	 
 }
 
 //write TextDesc string 
 //B "S"
 set SingleTextDescDataKey = $ORDER(^CacheTempEPRSingleDataTextDesc($J,""))
 if (SingleTextDescDataKey= "")
 {
	set TextDescFlag = "False"
	 }
 WHILE (SingleTextDescDataKey'="")
 {
  if ($G(^CacheTempEPRSingleDataTextDesc($J,SingleTextDescDataKey))'="")
  { 
     set Result = Result _ $G(^CacheTempEPRSingleDataTextDesc($J,SingleTextDescDataKey))_"@|"
  }
  Elseif ($G(^CacheTempEPRSingleDataTextDesc($J,SingleTextDescDataKey))="")
  {
	set Result = Result _ "*NULL"_"@|"  
  }
  if ($G(^CacheTempEPRSingleDataTextDesc($J,SingleTextDescDataKey,"1"))'="")
  {
	  set Result = Result _ $G(^CacheTempEPRSingleDataTextDesc($J,SingleTextDescDataKey,"1"))_"@^"
  }	  
  elseif ($G(^CacheTempEPRSingleDataTextDesc($J,SingleTextDescDataKey,"1"))="")
  {
    set Result = Result _ "*NULL"_"@^"	 
	  }
  set TextDescFlag = "True"
  SET SingleTextDescDataKey = $ORDER(^CacheTempEPRSingleDataTextDesc($J,SingleTextDescDataKey))	  		 
 }
 
 if (TextDescFlag="False")
 {set Result=Result_"}" }
 elseif(TextDescFlag = "True")	 
 {set TempStr = Result
  Set Result = $EXTRACT(TempStr,1,$L(TempStr)-2) 	 
  set Result=Result_"}"	 
 }
 //w Result
 quit Result
}

ClassMethod GetTestRepObj(OID As DHCCPMWeb.CPMSevice.entity.DHCEReports) As %String [ WebMethod ]
{
	
	//s obj=##class(DHCCPM.DHCReports).%OpenId(OID)
	
	Quit "0"
}

}
