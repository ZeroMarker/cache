/// 名称：	EPRservice.BODataGateway
/// 描述：	打散数据获取业务类。
/// 		 	电子病历界面加载时自动引用病历数据调用此类，
/// 		 	电子病历打印时获取病历数据调用此类。
/// 创建者：
/// 创建时间：
Class EPRservice.BODataGateway Extends %SOAP.WebService [ ProcedureBlock ]
{

/// TODO: change this to actual SOAP namespace.
/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/metaservice";

/// Name of the WebService.
Parameter SERVICENAME = "DataGatewayInfo";

/// Desc: 根据查询字符串返回相应的打散数据
/// Input: AReciveString: $Head{PatientID:PID,EpisodeID:EID,InstanceDataID:IID,PrintDocID:PDID}
/// 						$Single#Simple{TID|CODE|VTYPE,TID|CODE|VTYPE,…}
/// 						#Segment{TID|GID,TID|GID,….}
/// 						#TextDesc{TID|EID,TID|EID,….}
/// 						#Table{ TID|TCODE[SCODE|VTYPE, SCODE|VTYPE,…], TID|TCODE[SCODE|VTYPE, SCODE|VTYPE,…],… }
/// 						#ImageAnnotate{ TID|YCODE, TID|YCODE, TID|YCODE… }
/// 						#Figure{TID|FCODE|VTYPE,TID|FCODE|VTYPE,…}
/// 						$Multiple
/// 						#Simple:{TID|CODE|VTYPE,TID|CODE|VTYPE,…}
/// 						#Segment{TID|GID,TID|GID,….}
/// 						#TextDesc{TID|EID,TID|EID,….}
/// 						#Table{ TID|TCODE[SCODE|VTYPE, SCODE|VTYPE,…], TID|TCODE[SCODE|VTYPE, SCODE|VTYPE,…],… }
/// 						#ImageAnnotate{ TID|YCODE, TID|YCODE,TID|YCODE… }
/// 						#Figure{ TID|FCODE|VTYPE,TID|FCODE|VTYPE,…}
/// 						#InstanceData{TITLE,HAPPENDATE,HAPPENTIME,AUTHOR}
/// 						$SystemData{DATE,TIME}
/// Output：无
/// Return：EPRservice.entity.ReStreamData：含有要返回打散数据的实体对象，其中流属性StreamData所含字符串格式如下：
/// 						$Head{PatientID:PID,EpisodeID:EID,InstanceDataID:IID,PrintDocID:PDID}
/// 						$Single#Simple{RV@^RV@^...}
/// 						#Segment{Text@|FormateInfo@^ Text@|FormateInfo@^…}
/// 						#TextDesc{Text@|FormateInfo@^ Text@|FormateInfo@^…}
/// 						#Table{[RV@|RV@|...@^ RV@|RV@|..@^...],[RV@|RV@|...@^ RV@|RV@|..@^...],...}
/// 						#ImageAnnotate{ImageData@|AnnoData@^ ImageData@|AnnoData.....}
/// 						$Multiple#Simple{RV@^RV@^...}
/// 						#Segment{Text@|FormateInfo@^ Text@|FormateInfo@^…}
/// 						#TextDesc{Text@|FormateInfo@^ Text@|FormateInfo@^…}
/// 						#Table{[RV@|RV@|...@^ RV@|RV@|..@^...],[RV@|RV@|...@^ RV@|RV@|..@^...],...}
/// 						#ImageAnnotate{ImageData@|AnnoData@^ ImageData@|AnnoData.....}
/// 						#InstanceData{RVALUE,RVALUE}
/// 						$SystemData{RVALUE,RVALUE}
/// Others: 关于输入参数及返回值的更多信息见[代码约定]
/// w ##class(EPRservice.BODataGateway).DBInterFaceByStreamPrivacyInfo(^CacheTemp("debug","rbac","111"),^CacheTemp("debug","rbac","222"))
ClassMethod DBInterFaceByStreamPrivacyInfo(AReciveString As %String, APrivacyLevel As %String) As EPRservice.entity.ReStreamData [ WebMethod ]
{
	//Debug begin
	//k ^DHCEPRDebug("EPRservice.BODataGateway,DBInterFaceByStream")
	/*
	s debugPatientId = "12"
	s debugEpisodeId = "201764"
	s debugstr = "$Head{PatientID:"_debugPatientId_",EpisodeID:"_debugEpisodeId
	if $f(AReciveString,debugstr)>1
	{
		s ^DHCEPRDebug("EPRservice.BODataGateway,DBInterFaceByStream","Input") = AReciveString
	}
	*/
	//s ^DHCEPRDebug("EPRservice.BODataGateway,DBInterFaceByStream","ProcessID") = uniqueEPRGlobalID
	//s ^DHCEPRDebug("EPRservice.BODataGateway,DBInterFaceByStream","Input") = AReciveString
 	s iiid = $I(^DHCEPRDebug)
 	s ^DHCEPRDebug(iiid,"EPRservice.BODataGateway,DBInterFaceByStream","Input") = AReciveString
 	
 	//Debug end
 	
 	s uniqueEPRGlobalID = $I(^CacheTemp)
 	
 	//解析前端传来的查询字符串，将其拆成四个部分
 	set AHeadStrStart = $Find(AReciveString,"$Head{")
 	set ASingleStrStart = $Find(AReciveString,"$Single#Simple")
 	set AMultipleStrStart = $Find(AReciveString,"$Multiple#Simple")
 	set ASystemDateStrStart = $Find(AReciveString,"$SystemData")   
 	if (ASingleStrStart'=0)
 	{ 	set AHeadStr= $EXTRACT(AReciveString,AHeadStrStart,ASingleStrStart-16)	
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
 	{ Quit ""	  }
	
	//生成要返回的流数据 
 	set ResultData= ##class(EPRservice.entity.ReStreamData).%New()
	//commented on 2008-09-08 by houj, 
 	//这句话会改变ResultData.StreamData的Location位置，使得CacheStream中产生冗余数据
 	//set ResultData.StreamData=""
 	
 	//写入基本信息
 	set ResultStr= "$Head{"_AHeadStr_"}"
 	d ResultData.StreamData.Write(ResultStr)
  	
  	//写入唯一病历信息
  	if (ASingleOrigiStr'="")
 	{
 		//s ^DHCEPRDebug("EPRservice.BODataGateway,DBInterFaceByStream","ASingleOrigiStr")=ASingleOrigiStr
 		set ASingleDataStr = ..GetSingleData(uniqueEPRGlobalID,AHeadStr,ASingleOrigiStr,ResultData.StreamData,APrivacyLevel)
 		//set ResultStr = ResultStr_ASingleDataStr
 	} 
 
 	//写入历次病历信息
 	if (AMultipleOrigiStr'="")
 	{
 		//s ^DHCEPRDebug("EPRservice.BODataGateway,DBInterFaceByStream","AMultipleOrigiStr")=AMultipleOrigiStr
 		set AMultipleDataStr = ..GetMultipleData(uniqueEPRGlobalID,AHeadStr,AMultipleOrigiStr,ResultData.StreamData,APrivacyLevel)
 		//set ResultStr = ResultStr_AMultipleDataStr
 	}	 
 	
 	//写入系统信息
 	if (ASystemDateStr'="")
 	{
		//s ^DHCEPRDebug("EPRservice.BODataGateway,DBInterFaceByStream","ASystemDateStr")=ASystemDateStr
		set ReSystemDateStr = ..GetSysData(uniqueEPRGlobalID,AHeadStr,ASystemDateStr,ResultData.StreamData)
		//do ..GetSysData(uniqueEPRGlobalID,AHeadStr,ASystemDateStr,ResultData.StreamData)
		
		//set ResultStr = ResultStr_ReSystemDateStr
		//d ResultData.StreamData.Write(ReSystemDateStr)
 	}
 	
 	//清除临时数据
 	d ..ClearTempGlobal(uniqueEPRGlobalID)
 	
 	//debug begin
 	/*
	s len=1024*15
	s count = 0
	kill ^DHCEPRDebug("EPRservice.BODataGateway.DBInterFaceByStream","ResultData")
	d ResultData.StreamData.Rewind()
	while (ResultData.StreamData.AtEnd = 0)
	{
		s count = count + 1
		s ^DHCEPRDebug("EPRservice.BODataGateway.DBInterFaceByStream","ResultData",count)=ResultData.StreamData.Read(len)
	}
	d ResultData.StreamData.Rewind()
	*/
	//debug end

 	Q ResultData
}

/// Desc: 根据查询字符串返回相应的打散数据
/// Input: AReciveString: $Head{PatientID:PID,EpisodeID:EID,InstanceDataID:IID,PrintDocID:PDID}
/// 						$Single#Simple{TID|CODE|VTYPE,TID|CODE|VTYPE,…}
/// 						#Segment{TID|GID,TID|GID,….}
/// 						#TextDesc{TID|EID,TID|EID,….}
/// 						#Table{ TID|TCODE[SCODE|VTYPE, SCODE|VTYPE,…], TID|TCODE[SCODE|VTYPE, SCODE|VTYPE,…],… }
/// 						#ImageAnnotate{ TID|YCODE, TID|YCODE, TID|YCODE… }
/// 						#Figure{TID|FCODE|VTYPE,TID|FCODE|VTYPE,…}
/// 						$Multiple
/// 						#Simple:{TID|CODE|VTYPE,TID|CODE|VTYPE,…}
/// 						#Segment{TID|GID,TID|GID,….}
/// 						#TextDesc{TID|EID,TID|EID,….}
/// 						#Table{ TID|TCODE[SCODE|VTYPE, SCODE|VTYPE,…], TID|TCODE[SCODE|VTYPE, SCODE|VTYPE,…],… }
/// 						#ImageAnnotate{ TID|YCODE, TID|YCODE,TID|YCODE… }
/// 						#Figure{ TID|FCODE|VTYPE,TID|FCODE|VTYPE,…}
/// 						#InstanceData{TITLE,HAPPENDATE,HAPPENTIME,AUTHOR}
/// 						$SystemData{DATE,TIME}
/// Output：无
/// Return：EPRservice.entity.ReStreamData：含有要返回打散数据的实体对象，其中流属性StreamData所含字符串格式如下：
/// 						$Head{PatientID:PID,EpisodeID:EID,InstanceDataID:IID,PrintDocID:PDID}
/// 						$Single#Simple{RV@^RV@^...}
/// 						#Segment{Text@|FormateInfo@^ Text@|FormateInfo@^…}
/// 						#TextDesc{Text@|FormateInfo@^ Text@|FormateInfo@^…}
/// 						#Table{[RV@|RV@|...@^ RV@|RV@|..@^...],[RV@|RV@|...@^ RV@|RV@|..@^...],...}
/// 						#ImageAnnotate{ImageData@|AnnoData@^ ImageData@|AnnoData.....}
/// 						$Multiple#Simple{RV@^RV@^...}
/// 						#Segment{Text@|FormateInfo@^ Text@|FormateInfo@^…}
/// 						#TextDesc{Text@|FormateInfo@^ Text@|FormateInfo@^…}
/// 						#Table{[RV@|RV@|...@^ RV@|RV@|..@^...],[RV@|RV@|...@^ RV@|RV@|..@^...],...}
/// 						#ImageAnnotate{ImageData@|AnnoData@^ ImageData@|AnnoData.....}
/// 						#InstanceData{RVALUE,RVALUE}
/// 						$SystemData{RVALUE,RVALUE}
/// Others: 关于输入参数及返回值的更多信息见[代码约定]
/// w ##class(EPRservice.BODataGateway).DBInterFaceByStream(^DHCEPRDebug("EPRservice.BODataGateway,DBInterFaceByStream","Input"))
ClassMethod DBInterFaceByStream(AReciveString As %String) As EPRservice.entity.ReStreamData [ WebMethod ]
{
	//Debug begin
	//k ^DHCEPRDebug("EPRservice.BODataGateway,DBInterFaceByStream")
	/*
	s debugPatientId = "12"
	s debugEpisodeId = "201764"
	s debugstr = "$Head{PatientID:"_debugPatientId_",EpisodeID:"_debugEpisodeId
	if $f(AReciveString,debugstr)>1
	{
		s ^DHCEPRDebug("EPRservice.BODataGateway,DBInterFaceByStream","Input") = AReciveString
	}
	*/
	//s ^DHCEPRDebug("EPRservice.BODataGateway,DBInterFaceByStream","ProcessID") = uniqueEPRGlobalID
	s ^DHCEPRDebug("EPRservice.BODataGateway,DBInterFaceByStream","Input") = AReciveString
 	//Debug end
 	
 	s uniqueEPRGlobalID = $I(^CacheTemp)
 	
 	//解析前端传来的查询字符串，将其拆成四个部分
 	set AHeadStrStart = $Find(AReciveString,"$Head{")
 	set ASingleStrStart = $Find(AReciveString,"$Single#Simple")
 	set AMultipleStrStart = $Find(AReciveString,"$Multiple#Simple")
 	set ASystemDateStrStart = $Find(AReciveString,"$SystemData")   
 	if (ASingleStrStart'=0)
 	{ 	set AHeadStr= $EXTRACT(AReciveString,AHeadStrStart,ASingleStrStart-16)	
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
 	{ Quit ""	  }
	
	//生成要返回的流数据 
 	set ResultData= ##class(EPRservice.entity.ReStreamData).%New()
	//commented on 2008-09-08 by houj, 
 	//这句话会改变ResultData.StreamData的Location位置，使得CacheStream中产生冗余数据
 	//set ResultData.StreamData=""
 	
 	//写入基本信息
 	set ResultStr= "$Head{"_AHeadStr_"}"
 	d ResultData.StreamData.Write(ResultStr)
  	
  	//写入唯一病历信息
  	if (ASingleOrigiStr'="")
 	{
 		//s ^DHCEPRDebug("EPRservice.BODataGateway,DBInterFaceByStream","ASingleOrigiStr")=ASingleOrigiStr
 		set ASingleDataStr = ..GetSingleData(uniqueEPRGlobalID,AHeadStr,ASingleOrigiStr,ResultData.StreamData)
 		//set ResultStr = ResultStr_ASingleDataStr
 	} 
 
 	//写入历次病历信息
 	if (AMultipleOrigiStr'="")
 	{
 		//s ^DHCEPRDebug("EPRservice.BODataGateway,DBInterFaceByStream","AMultipleOrigiStr")=AMultipleOrigiStr
 		set AMultipleDataStr = ..GetMultipleData(uniqueEPRGlobalID,AHeadStr,AMultipleOrigiStr,ResultData.StreamData)
 		//set ResultStr = ResultStr_AMultipleDataStr
 	}	 
 	
 	//写入系统信息
 	if (ASystemDateStr'="")
 	{
		//s ^DHCEPRDebug("EPRservice.BODataGateway,DBInterFaceByStream","ASystemDateStr")=ASystemDateStr
		set ReSystemDateStr = ..GetSysData(uniqueEPRGlobalID,AHeadStr,ASystemDateStr,ResultData.StreamData)
		//set ResultStr = ResultStr_ReSystemDateStr
		//d ResultData.StreamData.Write(ReSystemDateStr)
 	}
 	
 	//清除临时数据
 	d ..ClearTempGlobal(uniqueEPRGlobalID)
 	
 	//debug begin
 	/*
	s len=1024*15
	s count = 0
	kill ^DHCEPRDebug("EPRservice.BODataGateway.DBInterFaceByStream","ResultData")
	d ResultData.StreamData.Rewind()
	while (ResultData.StreamData.AtEnd = 0)
	{
		s count = count + 1
		s ^DHCEPRDebug("EPRservice.BODataGateway.DBInterFaceByStream","ResultData",count)=ResultData.StreamData.Read(len)
	}
	d ResultData.StreamData.Rewind()
	*/
	//debug end

 	Q ResultData
}

ClassMethod ClearTempGlobal(uniqueEPRGlobalID As %String)
{
	q:(uniqueEPRGlobalID)
	
	//清除唯一数据查询条件
	K ^TempEPRGetSimple(uniqueEPRGlobalID)
	K ^TempEPRGetSegment(uniqueEPRGlobalID)
	K ^TempEPRGetTextDesc(uniqueEPRGlobalID)
	K ^TempEPRGetTableSimple(uniqueEPRGlobalID)
	K ^TempEPRGetImageAnnotate(uniqueEPRGlobalID)
	K ^TempEPRSingleAnnota(uniqueEPRGlobalID)
	K ^TempEPRGetFigure(uniqueEPRGlobalID)
	K ^TempEPRGetSegmentSimple(uniqueEPRGlobalID) //add by Candyxu			
	
	//清除唯一数据
	K ^TempEPRSingleDataSimple(uniqueEPRGlobalID)
 	K ^TempEPRSingleDataSegment(uniqueEPRGlobalID)
 	K ^TempEPRSingleDataTextDesc(uniqueEPRGlobalID)
 	K ^TempEPRSingleDataTableSimple(uniqueEPRGlobalID)
 	K ^TempEPRSingleDataImageAnnotate(uniqueEPRGlobalID)
 	K ^TempEPRSingleDataFigure(uniqueEPRGlobalID)
    K ^TempEPRSingleDataSegmentSimple(uniqueEPRGlobalID)   //add by Candyxu

	//清除可重复数据查询条件
	K ^TempEPRMultipleGetSimple(uniqueEPRGlobalID)
 	K ^TempEPRMultipleGetSegment(uniqueEPRGlobalID)
 	K ^TempEPRMultipleGetTextDesc(uniqueEPRGlobalID)
 	K ^TempEPRMultipleGetTableSimple(uniqueEPRGlobalID)
 	K ^TempEPRMultipleGetImageAnnotate(uniqueEPRGlobalID)
 	K ^TempEPRMultipleInstanceData(uniqueEPRGlobalID)
 	K ^TempEPRMultipleAnnota(uniqueEPRGlobalID)
    K ^TempEPRMultipleGetSegmentSimple(uniqueEPRGlobalID)  //add by Candyxu
	
	//清除可重复数据
	K ^TempEPRMultipleDataSimple(uniqueEPRGlobalID)
	K ^TempEPRMultipleDataSegment(uniqueEPRGlobalID)
	K ^TempEPRMultipleDataTextDesc(uniqueEPRGlobalID)
	K ^TempEPRMultipleDataTableSim(uniqueEPRGlobalID)
	K ^TempEPRMultipleDataAnnotate(uniqueEPRGlobalID)
	K ^TempEPRMultipleDataSegmentSimple(uniqueEPRGlobalID) //add by Candyxu
}

/// Desc: 获取唯一模板数据
ClassMethod GetSingleData(uniqueEPRGlobalID As %String, AReciveHeadStr As %String, AReciveSingle As %String, ByRef AReStream As %Stream, APrivacyLevel As %String = "") As %String
{
 K ^TempEPRSingleDataSimple(uniqueEPRGlobalID)
 K ^TempEPRSingleDataSegment(uniqueEPRGlobalID)
 K ^TempEPRSingleDataTextDesc(uniqueEPRGlobalID)
 K ^TempEPRSingleDataTableSimple(uniqueEPRGlobalID)
 K ^TempEPRSingleDataImageAnnotate(uniqueEPRGlobalID)
 K ^TempEPRSingleDataFigure(uniqueEPRGlobalID)
 K ^TempEPRSingleDataSegmentSimple(uniqueEPRGlobalID)   //add by Candyxu

 Set PatientID =  $PIECE($PIECE(AReciveHeadStr,",",1),":",2)
 Set PatientTag =  $PIECE($PIECE(AReciveHeadStr,",",1),":",1)
 Set EpisodeID =  $PIECE($PIECE(AReciveHeadStr,",",2),":",2)
 Set EpisodeTag =  $PIECE($PIECE(AReciveHeadStr,",",2),":",1)
 Set AInstanceDataID =  $PIECE($PIECE(AReciveHeadStr,",",3),":",2)
 Set InstanceDataTag =  $PIECE($PIECE(AReciveHeadStr,",",3),":",1) 

 //parse string single 
 do ..ParseSingleList(uniqueEPRGlobalID,AReciveSingle)
 //Merge ^EPRGetSimple=^TempEPRGetSimple(uniqueEPRGlobalID)
 
 //Simple
 set SingleSimpleKey = $ORDER(^TempEPRGetSimple(uniqueEPRGlobalID,""))
 WHILE (SingleSimpleKey'="") 
 {  
 	set ATemplateID= $G(^TempEPRGetSimple(uniqueEPRGlobalID,SingleSimpleKey)) 
 	set ASimpleItemCode= $G(^TempEPRGetSimple(uniqueEPRGlobalID,SingleSimpleKey,"1")) 
 	set AValueCode= $G(^TempEPRGetSimple(uniqueEPRGlobalID,SingleSimpleKey,"2")) 
 	set BlankSimpleItemCode =" "_ASimpleItemCode
 	set BlankEpisodeID =" "_EpisodeID
 	set BlankTemplateID = " "_ATemplateID
 	set ACodeType = $EXTRACT(ASimpleItemCode,1)

 	if $D(^DHCEPRI.ISimpleI)
 	{
	   	Set BlankInstanceDataID=$O(^DHCEPRI.ISimpleI("IdxForLink",BlankEpisodeID,BlankTemplateID,BlankSimpleItemCode,"")) 
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
 		s simpleValue = ..GetISimpleValue(SingleIndex,ACodeType,AValueCode,ATemplateID,ASimpleItemCode,APrivacyLevel)
		set ^TempEPRSingleDataSimple(uniqueEPRGlobalID,SingleSimpleKey) = simpleValue
	}
	Elseif (SingleIndex="")
	{
 		set ^TempEPRSingleDataSimple(uniqueEPRGlobalID,SingleSimpleKey)= "*NULL"
 	}

 	SET SingleSimpleKey = $ORDER(^TempEPRGetSimple(uniqueEPRGlobalID,SingleSimpleKey))	  	
 }
 
 //Segment
 set SingleSegmentKey = $ORDER(^TempEPRGetSegment(uniqueEPRGlobalID,""))
 WHILE (SingleSegmentKey'="") 
 {
 	set ATemplateID= $G(^TempEPRGetSegment(uniqueEPRGlobalID,SingleSegmentKey)) 
 	set BlankTemplateID= " "_ATemplateID
 	set BlankEpisodeID =" "_EpisodeID
 	set ASegmentCode= $G(^TempEPRGetSegment(uniqueEPRGlobalID,SingleSegmentKey,"1")) 
 	Set BlankSegmentCode =" "_ASegmentCode
 	if $D(^DHCEPRI.ISegmentI)	   
 	{
		Set BlankInstanceDataID=$O(^DHCEPRI.ISegmentI("IdxForLink",BlankEpisodeID,BlankTemplateID,BlankSegmentCode,"")) 
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
 	{  	s SingleIndex =""	}

	
 	if (SingleIndex'="")
 	{
		d ..GetSegmentText(SingleIndex, .StrText, .FormateInfoStr)
		set ^TempEPRSingleDataSegment(uniqueEPRGlobalID,SingleSegmentKey)= StrText
		set ^TempEPRSingleDataSegment(uniqueEPRGlobalID,SingleSegmentKey,"1")= FormateInfoStr
	}
	Elseif (SingleIndex="")
	{
	  set ^TempEPRSingleDataSegment(uniqueEPRGlobalID,SingleSegmentKey)= "*NULL"
	  set ^TempEPRSingleDataSegment(uniqueEPRGlobalID,SingleSegmentKey,"1")= "*NULL"
	}
	
 	SET SingleSegmentKey = $ORDER(^TempEPRGetSegment(uniqueEPRGlobalID,SingleSegmentKey))	  	
 }

 //SegmentSimple add by Candyxu
 set SingleSegmentSimpleKey = $ORDER(^TempEPRGetSegmentSimple(uniqueEPRGlobalID,""))
 WHILE(SingleSegmentSimpleKey '="")
 {
	set ATemplateID= $G(^TempEPRGetSegmentSimple(uniqueEPRGlobalID,SingleSegmentSimpleKey)) 
 	set BlankTemplateID= " "_ATemplateID
 	set BlankEpisodeID =" "_EpisodeID
 	set ASegmentCode= $G(^TempEPRGetSegmentSimple(uniqueEPRGlobalID,SingleSegmentSimpleKey,"1")) 
 	Set BlankSegmentCode =" "_ASegmentCode
 	set ASimpleCode = $G(^TempEPRGetSegmentSimple(uniqueEPRGlobalID,SingleSegmentSimpleKey,"1","1")) 
	Set BlankSimpleCode =" "_ASimpleCode 
	set ACodeType = $EXTRACT(ASimpleCode,1)
	set ATypeCode = $G(^TempEPRGetSegmentSimple(uniqueEPRGlobalID,SingleSegmentSimpleKey,"1","2")) 
	if $D(^DHCEPRI.ISegmentSimpleI)
	{
		set BlankInstanceDataID = $o(^DHCEPRI.ISegmentSimpleI("IdxForLink",BlankEpisodeID, BlankTemplateID, BlankSegmentCode, BlankSimpleCode, ""))
	    if (BlankInstanceDataID '="")
	    {
		    set SingleIndex = $o(^DHCEPRI.ISegmentSimpleI("IdxForLink",BlankEpisodeID, BlankTemplateID, BlankSegmentCode, BlankSimpleCode,BlankInstanceDataID,""))
		} 		
		elseif (BlankInstanceDataID=""){ set SingleIndex= ""  }
	}
	else {set SingleIndex= "" }
 	if (SingleIndex'="")
 	{
		set SegmentSimpleValue = ..GetSegmentSimpleText(SingleIndex, ACodeType,ATypeCode)
		set ^TempEPRSingleDataSegmentSimple(uniqueEPRGlobalID,SingleSegmentSimpleKey) = SegmentSimpleValue
	}
	Elseif (SingleIndex="")
	{
 		set ^TempEPRSingleDataSegmentSimple(uniqueEPRGlobalID,SingleSegmentSimpleKey)= "*NULL"
 	}
 	SET SingleSegmentSimpleKey = $ORDER(^TempEPRGetSegmentSimple(uniqueEPRGlobalID,SingleSegmentSimpleKey))
 }

 //TextDesc
 set SingleTextDescKey = $ORDER(^TempEPRGetTextDesc(uniqueEPRGlobalID,""))
 WHILE (SingleTextDescKey'="") 
 {
 	set ATemplateID= $G(^TempEPRGetTextDesc(uniqueEPRGlobalID,SingleTextDescKey)) 
 	set ATextDescCode= $G(^TempEPRGetTextDesc(uniqueEPRGlobalID,SingleTextDescKey,"1")) 

 	set BlankTextDescCode =" "_ATextDescCode
 	set BlankEpisodeID =" "_EpisodeID
 	set BlankTemplateID = " "_ATemplateID

 	if $D(^DHCEPRI.ITextDescI)	   
 	{		 
 		Set BlankInstanceDataID= $O(^DHCEPRI.ITextDescI("IdxForLink",BlankEpisodeID,BlankTemplateID,BlankTextDescCode,""))    
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
	 	//d ..GetTextDescText(SingleIndex, .StrText, .FormateInfoStr)
	  	//set ^TempEPRSingleDataTextDesc(uniqueEPRGlobalID,SingleTextDescKey)= StrText
	  	//set ^TempEPRSingleDataTextDesc(uniqueEPRGlobalID,SingleTextDescKey,"1")= FormateInfoStr
	  	set ^TempEPRSingleDataTextDesc(uniqueEPRGlobalID,SingleTextDescKey)= SingleIndex
	  	set ^TempEPRSingleDataTextDesc(uniqueEPRGlobalID,SingleTextDescKey,"1")= SingleIndex
	}
	Elseif (SingleIndex="")
	{
	 	set ^TempEPRSingleDataTextDesc(uniqueEPRGlobalID,SingleTextDescKey)= "*NULL"
	 	set ^TempEPRSingleDataTextDesc(uniqueEPRGlobalID,SingleTextDescKey,"1")= "*NULL"
	}
	
 	SET SingleTextDescKey = $ORDER(^TempEPRGetTextDesc(uniqueEPRGlobalID,SingleTextDescKey))	  	
 }

 //TableSimple
 set SingleTableSimpleKey = $ORDER(^TempEPRGetTableSimple(uniqueEPRGlobalID,""))
 WHILE (SingleTableSimpleKey'="") 
 {
 	set ATemplateID= $G(^TempEPRGetTableSimple(uniqueEPRGlobalID,SingleTableSimpleKey)) 
 	set ATableCode= $G(^TempEPRGetTableSimple(uniqueEPRGlobalID,SingleTableSimpleKey,"1")) 

 	set BlankTableCode =" "_ATableCode
 	set BlankEpisodeID =" "_EpisodeID
 	set BlankTemplateID = " "_ATemplateID

 	set ARowCount= $G(^TempEPRGetTableSimple(uniqueEPRGlobalID,SingleTableSimpleKey,"SubItems")) 

 	set ^TempEPRSingleDataTableSimple(uniqueEPRGlobalID,SingleTableSimpleKey)= SingleSimpleKey

 	set ^TempEPRSingleDataTableSimple(uniqueEPRGlobalID,SingleTableSimpleKey,"RowItems")= ARowCount

 	For I=1:1:ARowCount
 	{
	 	set ASimpleItemCode= $G(^TempEPRGetTableSimple(uniqueEPRGlobalID,SingleTableSimpleKey,"SubItems",I))   
	 	set ACodeType = $EXTRACT(ASimpleItemCode,1)
	 	set AValueCode= $G(^TempEPRGetTableSimple(uniqueEPRGlobalID,SingleTableSimpleKey,"SubItems",I,"VTYPE"))     
	 	set BlankSimpleItemCode= " "_ASimpleItemCode

 		if $D(^DHCEPRI.ITableSimpleI)	   
 		{
	    	Set BlankInstanceDataID= $O(^DHCEPRI.ITableSimpleI("IdxForLink",BlankEpisodeID,BlankTemplateID,BlankTableCode,BlankSimpleItemCode,""))     
	    	if (BlankInstanceDataID'="")
 			{
	      		set ^TempEPRSingleDataTableSimple(uniqueEPRGlobalID,SingleTableSimpleKey,"RowItems",I)= "RowData"  
	      		Set CowCount = 0
	      		Set BlankRowNumber= $O(^DHCEPRI.ITableSimpleI("IdxForLink",BlankEpisodeID,BlankTemplateID,BlankTableCode,BlankSimpleItemCode,BlankInstanceDataID,""))
	      
	      		WHILE (BlankRowNumber'="") 
	      		{         
	      			Q:(BlankRowNumber="")
	      
		       		Set SingleIndex= $O(^DHCEPRI.ITableSimpleI("IdxForLink",BlankEpisodeID,BlankTemplateID,BlankTableCode,BlankSimpleItemCode,BlankInstanceDataID,BlankRowNumber,""))     
 					Q:(SingleIndex="")
 					set CowCount = CowCount + 1
 					if (SingleIndex'="")
 					{  
 						D ..GetTableSimpleValue(SingleIndex,ACodeType,AValueCode, .simpleValue, .rowNumber)	
 						set ^TempEPRSingleDataTableSimple(uniqueEPRGlobalID,SingleTableSimpleKey,"RowItems",I,rowNumber)= simpleValue
 					}
		    		Set BlankRowNumber= $O(^DHCEPRI.ITableSimpleI("IdxForLink",BlankEpisodeID,BlankTemplateID,BlankTableCode,BlankSimpleItemCode,BlankInstanceDataID,BlankRowNumber))
 				}
	       
	     		set ^TempEPRSingleDataTableSimple(uniqueEPRGlobalID,SingleTableSimpleKey,"RowItems",I,"ItemCount")= CowCount
	    	}
	    	elseif (BlankInstanceDataID="")   
	    	{
		  		set ^TempEPRSingleDataTableSimple(uniqueEPRGlobalID,SingleTableSimpleKey,"RowItems",I)= "*NULL"   
		    }
 		}
 		elseif  '$D(^DHCEPRI.ITableSimpleI)
 		{
	 		set ^TempEPRSingleDataTableSimple(uniqueEPRGlobalID,SingleTableSimpleKey,"RowItems",I)= "*NULL" 
		}
 	}
	   
 	SET SingleTableSimpleKey = $ORDER(^TempEPRGetTableSimple(uniqueEPRGlobalID,SingleTableSimpleKey))	  	
 }


 //ImageAnnotate
 set SingleAnnotateKey = $ORDER(^TempEPRGetImageAnnotate(uniqueEPRGlobalID,""))
 if (SingleAnnotateKey="")
 { 	Set SingleAnnotateStrFlag = "False" }
 WHILE (SingleAnnotateKey'="") 
 {
 	set ATemplateID= $G(^TempEPRGetImageAnnotate(uniqueEPRGlobalID,SingleAnnotateKey)) 
 	set AImageAnnotateCode= $G(^TempEPRGetImageAnnotate(uniqueEPRGlobalID,SingleAnnotateKey,"1")) 
 	set BlankImageAnnotateCode =" "_AImageAnnotateCode
 	set BlankEpisodeID =" "_EpisodeID
 	set BlankTemplateID = " "_ATemplateID

 	if $D(^DHCEPRI.IAnnotateI)	   
 	{	 
 		Set BlankInstanceDataID= $O(^DHCEPRI.IAnnotateI("IdxForLink",BlankEpisodeID,BlankTemplateID,BlankImageAnnotateCode,""))    
	 	if (BlankInstanceDataID'="")
 		{   
 			Set SingleIndex= $O(^DHCEPRI.IAnnotateI("IdxForLink",BlankEpisodeID,BlankTemplateID,BlankImageAnnotateCode,BlankInstanceDataID,""))   
	   	}
	    elseif (BlankInstanceDataID="")   
	    {  	s SingleIndex= ""  }
 	}
 	Else 
 	{  s SingleIndex = ""  }
 	if (SingleIndex'="")
 	{   
 		set objIAnnotate = ##class(EPRinstance.IAnnotate).%OpenId(SingleIndex)
	  	Set StrText= ""
 		Set MetaAnnotateID = ##class(EPRmeta.ImageAnnotate).CheckDataExits(objIAnnotate.TemplateID,objIAnnotate.TemplateVersion,objIAnnotate.ImageAnnotateCode) 
	    set ^TempEPRSingleDataImageAnnotate(uniqueEPRGlobalID,SingleAnnotateKey)= SingleIndex
	    set ^TempEPRSingleDataImageAnnotate(uniqueEPRGlobalID,SingleAnnotateKey,"Add")= objIAnnotate.TemplateID_"!!"_objIAnnotate.TemplateVersion_"@@"_objIAnnotate.ImageAnnotateCode
	    set ^TempEPRSingleDataImageAnnotate(uniqueEPRGlobalID,SingleAnnotateKey,"1")= MetaAnnotateID
	}
 	Elseif (SingleIndex="")
 	{ 
 		set ^TempEPRSingleDataImageAnnotate(uniqueEPRGlobalID,SingleAnnotateKey)= "*NULL"
		set ^TempEPRSingleDataImageAnnotate(uniqueEPRGlobalID,SingleAnnotateKey,"1")= "*NULL"
 	}
 	Set SingleAnnotateStrFlag = "True"
 	SET SingleAnnotateKey = $ORDER(^TempEPRGetImageAnnotate(uniqueEPRGlobalID,SingleAnnotateKey))	  	
 }	

 //Simple write Simple string
 set SimpleResult= "$Single#Simple{" 
 set SingleSimpleDataKey = $ORDER(^TempEPRSingleDataSimple(uniqueEPRGlobalID,""))
 if (SingleSimpleDataKey= "")
 {
	set SimpleFlag = "False"
	 }
 WHILE (SingleSimpleDataKey'="")
 {
 if ($G(^TempEPRSingleDataSimple(uniqueEPRGlobalID,SingleSimpleDataKey))'="")
 {
 set SimpleResult = SimpleResult _ $G(^TempEPRSingleDataSimple(uniqueEPRGlobalID,SingleSimpleDataKey))_"@^"
 }
 if ($G(^TempEPRSingleDataSimple(uniqueEPRGlobalID,SingleSimpleDataKey))="")
 {
	set SimpleResult = SimpleResult _ "*NULL"_"@^" 
	  }
 set SimpleFlag = "True"
 SET SingleSimpleDataKey = $ORDER(^TempEPRSingleDataSimple(uniqueEPRGlobalID,SingleSimpleDataKey))	  		 
 }

 if (SimpleFlag="False")
 {set SimpleResult=SimpleResult_"}" 

 }
 elseif(SimpleFlag = "True")	 
 {set TempStr = SimpleResult
 Set SimpleResult = $EXTRACT(TempStr,1,$L(TempStr)-2) 	 
 set SimpleResult=SimpleResult_"}"	 
 }
 //set Result= SimpleResult 
 D AReStream.Write(SimpleResult)

 
 //write Segment string 
 do AReStream.Write("#Segment{")
 
 set SingleSegmentDataKey = "", SingleSegmentCount = 0
 for {
	set SingleSegmentDataKey = $ORDER(^TempEPRSingleDataSegment(uniqueEPRGlobalID,SingleSegmentDataKey))	  		 
 	quit:(SingleSegmentDataKey = "")
 	
 	//第一个G单元数据不需要插入分隔符
 	set SingleSegmentCount = SingleSegmentCount + 1
 	if (SingleSegmentCount > 1)
 	{
	 	do AReStream.Write("@^")
 	}
 	
 	set segmentValue = $G(^TempEPRSingleDataSegment(uniqueEPRGlobalID,SingleSegmentDataKey))
 	if (segmentValue = "") {set segmentValue = "*NULL"}
 	do AReStream.Write(segmentValue)
 	
 	do AReStream.Write("@|")
 	
 	set segmentFormat = $G(^TempEPRSingleDataSegment(uniqueEPRGlobalID,SingleSegmentDataKey,"1"))
 	if (segmentFormat = "") {set segmentFormat = "*NULL"}
 	do AReStream.Write(segmentFormat)
 }
 do AReStream.Write("}")
 
 //write SegmentSimple string  add by Candyxu
 set SegmentSimpleResult = "#SegmentSimple{"
 set SingleSegmentSimpleDataKey = $ORDER(^TempEPRSingleDataSegmentSimple(uniqueEPRGlobalID,""))
 if (SingleSegmentSimpleDataKey =""){set SegmentSimpleFlag = "False"}
 WHILE(SingleSegmentSimpleDataKey '="")
 {
	   if $G(^TempEPRSingleDataSegmentSimple(uniqueEPRGlobalID,SingleSegmentSimpleDataKey))'=""
	   {
		  set SegmentSimpleResult = SegmentSimpleResult_$G(^TempEPRSingleDataSegmentSimple(uniqueEPRGlobalID,SingleSegmentSimpleDataKey))_"@^"
	   }
	   elseif $G(^TempEPRSingleDataSegmentSimple(uniqueEPRGlobalID,SingleSegmentSimpleDataKey))=""
	   {
		   set SegmentSimpleResult = SegmentSimpleResult_"*NULL"_"@^" 
	   }
	   set SegmentSimpleFlag = "True"
	   set SingleSegmentSimpleDataKey = $ORDER(^TempEPRSingleDataSegmentSimple(uniqueEPRGlobalID,SingleSegmentSimpleDataKey))
 }
 if (SegmentSimpleFlag = "False")
 {set SegmentSimpleResult = SegmentSimpleResult_"}"}
 elseif(SegmentSimpleFlag = "True")
 {
	set TempStr = SegmentSimpleResult
	set SegmentSimpleResult = $EXTRACT(TempStr,1,$L(TempStr)-2)
	set SegmentSimpleResult = SegmentSimpleResult_"}"
 }
 D AReStream.Write(SegmentSimpleResult)
 
 //write TextDesc string 
 /*
 do AReStream.Write("#TextDesc{")
 set SingleTextDescDataKey = "", SingleTextDescCount = 0
 for {
	set SingleTextDescDataKey = $ORDER(^TempEPRSingleDataTextDesc(uniqueEPRGlobalID,SingleTextDescDataKey))	  		 
	quit:(SingleTextDescDataKey = "")
	
	//第一个E单元数据不需要插入分隔符
	set SingleTextDescCount = SingleTextDescCount + 1
	if (SingleTextDescCount > 1)
	{
		do AReStream.Write("@^")
	}
	
	set textDescValue = $G(^TempEPRSingleDataTextDesc(uniqueEPRGlobalID,SingleTextDescDataKey))
 	if (textDescValue = "") { set textDescValue = "*NULL"}
 	do AReStream.Write(textDescValue)
 	
 	do AReStream.Write("@|")
 	
 	set textDescFormat = $G(^TempEPRSingleDataTextDesc(uniqueEPRGlobalID,SingleTextDescDataKey,"1"))
 	if (textDescFormat = "") {	set textDescFormat = "*NULL"}
 	do AReStream.Write(textDescFormat)
 }

 do AReStream.Write("}")
 */
 d AReStream.Write("#TextDesc{")
	
	set SingleTextDescCount = 0
	set SingleTextDescDataKey = ""
	for {
		set SingleTextDescDataKey = $ORDER(^TempEPRSingleDataTextDesc(uniqueEPRGlobalID,SingleTextDescDataKey))	
		q:(SingleTextDescDataKey = "")
		
		set SingleTextDescCount = SingleTextDescCount + 1
		if (SingleTextDescCount > 1)
		{
			d AReStream.Write("@^")
		}
		
		s SingleIndex = $G(^TempEPRSingleDataTextDesc(uniqueEPRGlobalID,SingleTextDescDataKey))
		if (SingleIndex = "*NULL")
		{
			do AReStream.Write("*NULL@|*NULL")	
		}
		else
		{
			do ..GetTextDescData(SingleIndex, .AReStream)
		}
	}
	
	d AReStream.Write("}") 

 //write TableSimple string 
 /*
 set SingleTableSimpleDataKey = $ORDER(^TempEPRSingleDataTableSimple(uniqueEPRGlobalID,""))
 set TableSimpleStr= "#Table{"
 set TableSimpleFlag = ""
 if (SingleTableSimpleDataKey= "")
 {
	set TableSimpleFlag = "False"
	;set ^ABTableSimpleFlag("1")= TableSimpleStr
 }
 WHILE (SingleTableSimpleDataKey'="")
 {
 //set TableSimpleStr= TableSimpleStr_"["
 if ($G(^TempEPRSingleDataTableSimple(uniqueEPRGlobalID,SingleTableSimpleDataKey,"RowItems"))'="")
 { 
 set StrRowCount = $G(^TempEPRSingleDataTableSimple(uniqueEPRGlobalID,SingleTableSimpleDataKey,"RowItems"))
 set TableSimpleStr= TableSimpleStr_"["
 for X=1:1:StrRowCount
 {
	 ;B "S"
	 if ($G(^TempEPRSingleDataTableSimple(uniqueEPRGlobalID,SingleTableSimpleDataKey,"RowItems",X))'="")  
	 { 
	   if ($G(^TempEPRSingleDataTableSimple(uniqueEPRGlobalID,SingleTableSimpleDataKey,"RowItems",X))="RowData")  
	   {
		 if ($G(^TempEPRSingleDataTableSimple(uniqueEPRGlobalID,SingleTableSimpleDataKey,"RowItems",X,"ItemCount"))'="")  
		 {
		   ;B "S"	 
		   set ACowItemCount = $G(^TempEPRSingleDataTableSimple(uniqueEPRGlobalID,SingleTableSimpleDataKey,"RowItems",X,"ItemCount"))	 
		   For Y=1:1:ACowItemCount
		   {
			 ;B "S"	 
			 if ($G(^TempEPRSingleDataTableSimple(uniqueEPRGlobalID,SingleTableSimpleDataKey,"RowItems",X,Y))'="")	   
			 {
			    ;B "S"	 
			    set ADataValue = $G(^TempEPRSingleDataTableSimple(uniqueEPRGlobalID,SingleTableSimpleDataKey,"RowItems",X,Y))
			    if (Y=ACowItemCount)
			    {  
			      if (X=StrRowCount)
			      { set TableSimpleStr= TableSimpleStr_ADataValue_"]," }
			      if (X'=StrRowCount)
			      {set TableSimpleStr= TableSimpleStr_ADataValue_"@^" }
				    }
			    elseif (Y'=ACowItemCount)
			    { 
			      ;B "S"
				   set TableSimpleStr= TableSimpleStr_ADataValue_"@|"
				    } 	
				 
				}
			elseif ($G(^TempEPRSingleDataTableSimple(uniqueEPRGlobalID,SingleTableSimpleDataKey,"RowItems",X,Y))="")	   
			{
			   ;B "S"
			    if (Y=ACowItemCount)
			    {  
			      if (X=StrRowCount)
			      { set TableSimpleStr= TableSimpleStr_"*NULL"_"]," }
			      if (X'=StrRowCount)
			      {set TableSimpleStr= TableSimpleStr_"*NULL"_"@^" }
				    }
			    elseif (Y'=ACowItemCount)
			    {
				   set TableSimpleStr= TableSimpleStr_"*NULL"_"@|"
				    } 	
				}	
			}
			 }
		  }
	    elseif ($G(^TempEPRSingleDataTableSimple(uniqueEPRGlobalID,SingleTableSimpleDataKey,"RowItems",X))="*NULL")  
	    {
 if (X=StrRowCount)
	       { set TableSimpleStr= TableSimpleStr_"*NULL"_"]," }
	         elseif (X'=StrRowCount)
	       {
	        set TableSimpleStr= TableSimpleStr_"*NULL"_"@^"
		   }
	     }	  
	 }
	 elseif ($G(^TempEPRSingleDataTableSimple(uniqueEPRGlobalID,SingleTableSimpleDataKey,"RowItems",X))="")  
	 {  
	   if (X=StrRowCount)
	   { set TableSimpleStr= TableSimpleStr_"*NULL"_"]," }
	   elseif (X'=StrRowCount)
	   {
	     set TableSimpleStr= TableSimpleStr_"*NULL"_"@^"
		 }
	 }
 }
 }

 set TableSimpleFlag = "True"
 SET SingleTableSimpleDataKey = $ORDER(^TempEPRSingleDataTableSimple(uniqueEPRGlobalID,SingleTableSimpleDataKey))
 }
 if (TableSimpleFlag="True")
 { set TableSimpleStr =  $E(TableSimpleStr,0,$L(TableSimpleStr)-1) _ "}"  }
 if (TableSimpleFlag="False")
 { set TableSimpleStr = TableSimpleStr_"}"}


 ;set ^ABTableSimpleFlag("2")= TableSimpleStr
 //w Result
 //set Result= Result_ TableSimpleStr
 D AReStream.Write(TableSimpleStr) 
 */
 	
 	//updated by houj on 2012-11-16 : 解决 TMS Bug #1994 前端表格单元内容较多导致打印字符串超长失败 
 	//write TableSimple string
	do AReStream.Write("#Table{")
  
 	s SingleTableNum = 0
 	s SingleTableSimpleDataKey = ""
 	for {
		SET SingleTableSimpleDataKey = $ORDER(^TempEPRSingleDataTableSimple(uniqueEPRGlobalID,SingleTableSimpleDataKey))
	 	quit:(SingleTableSimpleDataKey="")
	 
 	 	set StrRowCount = $G(^TempEPRSingleDataTableSimple(uniqueEPRGlobalID,SingleTableSimpleDataKey,"RowItems"))
 	 	continue:(StrRowCount="")
 	
 	 	//插入表格与表格之间的分隔符
 	 	s SingleTableNum = SingleTableNum + 1
	 	if (SingleTableNum = 1)
	 	{	do AReStream.Write("[")}
	 	else
	 	{	do AReStream.Write(",[")}
	 	
		for X = 1:1:StrRowCount
 		{
	 		//插入同一个表格不同单元列之间的分隔符
	 		if (X > 1)
	 		{	do AReStream.Write("@^")}
	 		
	 		
	 		s RowDataFlag = $G(^TempEPRSingleDataTableSimple(uniqueEPRGlobalID,SingleTableSimpleDataKey,"RowItems",X))
	 		if (RowDataFlag '= "RowData")  
	 		{  
	   			do AReStream.Write("*NULL")
	 		}
	 		else  
	 		{  
		   		set ACowItemCount = $G(^TempEPRSingleDataTableSimple(uniqueEPRGlobalID,SingleTableSimpleDataKey,"RowItems",X,"ItemCount"))	 
		   		For Y = 1:1:ACowItemCount
		   		{
			   		//插入同一个表格同一单元列的不同单元行之间的分隔符
			 		if (Y > 1)
	 				{	do AReStream.Write("@|")}
	 		
	 				s ADataValue = $G(^TempEPRSingleDataTableSimple(uniqueEPRGlobalID,SingleTableSimpleDataKey,"RowItems",X,Y))
			 		if (ADataValue = "") 
			 		{	s ADataValue = "*NULL"}
			 		
			 		do AReStream.Write(ADataValue)		
			 		
				}  //遍历同一表格同一单元列的不同单元行结束
	   		
	 		}
	 		
 		} //遍历同一表格单元列结束
 		
 		//插入表格与表格之间的分隔符(结束部分)
 		do AReStream.Write("]")
 
 } //遍历表格结束
 
 do AReStream.Write("}") 
 
 
 if (SingleAnnotateStrFlag="True") 
 {
	set SingleAnnotateStream = ##class(%GlobalCharacterStream).%New() 
	d SingleAnnotateStream.Write("#ImageAnnotate{")
	set AnnotateSimpleStr= "#ImageAnnotate{" 
	//B "S" 
 set SingleImageAnnotateKey = $ORDER(^TempEPRSingleDataImageAnnotate(uniqueEPRGlobalID,""))
 WHILE (SingleImageAnnotateKey'="")
 {

 if $G(^TempEPRSingleDataImageAnnotate(uniqueEPRGlobalID,SingleImageAnnotateKey))'=""
 {  set SingleImageAnnotateId= $G(^TempEPRSingleDataImageAnnotate(uniqueEPRGlobalID,SingleImageAnnotateKey))
	  
	  if (SingleImageAnnotateId="*NULL")
	  { d SingleAnnotateStream.Write("*NULL@|")
		s AnnotateSimpleStr =AnnotateSimpleStr_"*NULL@|"
		  }
	  Elseif (SingleImageAnnotateId '="*NULL")
	  {
		   set objIAnnotate = ##class(EPRinstance.IAnnotate).%OpenId(SingleImageAnnotateId)
	   if (objIAnnotate'="")
	   {Set StrText= ""
 //读图片数据
 /*
 While (objIAnnotate.AnnoData.AtEnd = 0) 
 { Set len = 1024
 s TmpStrText=""
 //B "S"
 set TmpStrText= objIAnnotate.AnnoData.Read(len)
 d SingleAnnotateStream.Write(TmpStrText) 
 }
 */
 d ..GetAnnoData(.objIAnnotate, .SingleAnnotateStream)
 //B "S"
 d SingleAnnotateStream.Write("@|")
 set AnnotateSimpleStr= AnnotateSimpleStr_"*NULL@|"  
 s objIAnnotate=""
 }		  
 elseif (objIAnnotate="")
 { d SingleAnnotateStream.Write("*NULL@|")
		  s AnnotateSimpleStr =AnnotateSimpleStr_"*NULL@|"
	     }
	  //set Result = Result _ $G(^TempEPRSingleDataImageAnnotate(uniqueEPRGlobalID,SingleImageAnnotateKey))_"@|"

		  
 }
 }
 Elseif ($G(^TempEPRSingleDataImageAnnotate(uniqueEPRGlobalID,SingleImageAnnotateKey))="")
 {  d SingleAnnotateStream.Write("*NULL@|")
	s AnnotateSimpleStr=AnnotateSimpleStr_"*NULL@|"
 }
 if ($G(^TempEPRSingleDataImageAnnotate(uniqueEPRGlobalID,SingleImageAnnotateKey,"1"))'="")
 { set MetaAnnotateID= $G(^TempEPRSingleDataImageAnnotate(uniqueEPRGlobalID,SingleImageAnnotateKey,"1"))
	  
	 if (MetaAnnotateID'="")
	 { if (MetaAnnotateID'="0")	 
	   { if (MetaAnnotateID="*NULL")
		 { d SingleAnnotateStream.Write("*NULL@^")
		   s AnnotateSimpleStr =AnnotateSimpleStr_"*NULL@^" }
	     elseif '(MetaAnnotateID="*NULL")
	     {  
	     	set objMetaImage = ##class(EPRmeta.ImageAnnotate).%OpenId(MetaAnnotateID)
		    if (objMetaImage'="")  
		    { Set MetaImageStr= ""
  //读图片数据
 /*
 While (objMetaImage.ImageData.AtEnd = 0) 
 { Set len = 1024
 s TmpMetaImageStrText=""
 set TmpMetaImageStrText= objMetaImage.ImageData.Read(len)
 d SingleAnnotateStream.Write(TmpMetaImageStrText) 
 }
 */
 d ..GetImageData(.objMetaImage, .SingleAnnotateStream)
 d SingleAnnotateStream.Write("@^")
 set AnnotateSimpleStr =AnnotateSimpleStr_"*NULL@^" 
 s objMetaImage =""
 }
		 elseif (objMetaImage="")  
		  { d SingleAnnotateStream.Write("*NULL@^")
		    S AnnotateSimpleStr =AnnotateSimpleStr_"*NULL@^"  } 
		  }
		 }
		 elseif (MetaAnnotateID="0")
		 { d SingleAnnotateStream.Write("*NULL@^")
		   S AnnotateSimpleStr =AnnotateSimpleStr_"*NULL@^" } 	 			 
		 }
	 elseif (MetaAnnotateID="") 
	 {
 d SingleAnnotateStream.Write("*NULL@^")
		 s AnnotateSimpleStr =AnnotateSimpleStr_"*NULL@^"
		 }
 }
 Elseif ($G(^TempEPRSingleDataImageAnnotate(uniqueEPRGlobalID,SingleImageAnnotateKey,"1"))="")
 {  d SingleAnnotateStream.Write("*NULL@^")
	 s AnnotateSimpleStr =AnnotateSimpleStr_"*NULL@^"
	  }

 SET SingleImageAnnotateKey = $ORDER(^TempEPRSingleDataImageAnnotate(uniqueEPRGlobalID,SingleImageAnnotateKey))
 } 	  
 }


 if ($D(^TempEPRSingleAnnota(uniqueEPRGlobalID,"HasAnnotate")))
 {  set HasSingleAnnotateFlag="False"

 Set HasSingleAnnotateFlag=$G(^TempEPRSingleAnnota(uniqueEPRGlobalID,"HasAnnotate"))	 
 if (HasSingleAnnotateFlag="True")
 {
	    
	     if (SingleAnnotateStrFlag="True") 
 {  set AnnotateSimpleStr= $E(AnnotateSimpleStr,0,$L(AnnotateSimpleStr)-1) _ "}"
 while (SingleAnnotateStream.AtEnd = 0) 
 { Set len = 10240
 set TmpSingleAnnotateStr= SingleAnnotateStream.Read(len)
 if (SingleAnnotateStream.AtEnd=1)
 { set TmpSingleAnnotateStr= $E(TmpSingleAnnotateStr,0,$L(TmpSingleAnnotateStr)-2)  
 }

 d AReStream.Write(TmpSingleAnnotateStr)    

	   }
 d AReStream.Write("}")     

	   set SingleAnnotateStream="" 
 //set Result= Result_AnnotateSimpleStr_"}"
 } 
 Elseif (SingleAnnotateStrFlag="False") 
 { D AReStream.Write("#ImageAnnotate{}")
	  //s Result= Result_"#ImageAnnotate{}"
	    }  
 }
	 }
	 
 //added on 2008-11-19 by houj
 //为图形单元取数
 s figFlag = "0"		//是否要取图形数据
 s figCount = 0			//图形单元数量
 s figDelimiter = ""	//图形单元返回值间的间隔，第一个为空，第二个及以后为 @^
 s figKey = $O(^TempEPRGetFigure(uniqueEPRGlobalID,""))
 if figKey '= ""
 {	
 	s figFlag = "1"
 	do AReStream.Write("#Figure{")
 }
 while figKey '= ""
 {
	 s figCount = figCount + 1
	 if figCount > 1
	 {	s figDelimiter = "@^"}
	 s tid = $G(^TempEPRGetFigure(uniqueEPRGlobalID,figKey))
	 s fcode = $G(^TempEPRGetFigure(uniqueEPRGlobalID,figKey,"1"))
	 s vtype = $G(^TempEPRGetFigure(uniqueEPRGlobalID,figKey,"2"))
	
	 s rowIdStr = ##class(EPRservice.BOScatterData).GetIFigureId(EpisodeID,tid,fcode)
	 if rowIdStr = ""
	 {
		 do AReStream.Write(figDelimiter)
		 do AReStream.Write("*NULL")
	 }
	 else
	 {
		 s idCount = $Length(rowIdStr,"|")
		 for I = 1:1:idCount
		 {
			 s rowId = $p(rowIdStr,"|",I)
			 s rowId = $P(rowId,"^",2)
			 s objFigure = ##class(EPRinstance.IFigure).%OpenId(rowId)
			 if objFigure '= ""
			 {
				if (I = 1)
				{	do AReStream.Write(figDelimiter)}
				else
				{	do AReStream.Write("@|")}
				if (vtype="V")
				{
					//读图片数据
					//while (objFigure.FigureData.AtEnd = 0)
					//{	do AReStream.Write(objFigure.FigureData.Read(10240))}
					d ..GetFigureData(.objFigure, .AReStream)
				}
				elseif (vtype="C")
				{	do AReStream.Write(objFigure.FigureDesc)}
			 }
		 }
	 }
	 
	 s figKey = $O(^TempEPRGetFigure(uniqueEPRGlobalID,figKey))
 } 
 if figFlag = "1"
 {	do AReStream.Write("}")}


 s Result = ""
 quit Result
}

/// Desc: 解析唯一模板查询字符串
ClassMethod ParseSingleList(uniqueEPRGlobalID As %String, AReciveSingle As %String)
{
 K ^TempEPRGetSimple(uniqueEPRGlobalID)
 K ^TempEPRGetSegment(uniqueEPRGlobalID)
 K ^TempEPRGetTextDesc(uniqueEPRGlobalID)
 K ^TempEPRGetTableSimple(uniqueEPRGlobalID)
 K ^TempEPRGetImageAnnotate(uniqueEPRGlobalID)
 K ^TempEPRSingleAnnota(uniqueEPRGlobalID)
 K ^TempEPRGetFigure(uniqueEPRGlobalID)
 K ^TempEPRGetSegmentSimple(uniqueEPRGlobalID)  //add by Candyxu

 set AImageAnnotateStrStart = 0
 set ASimpleStrStart = $Find(AReciveSingle,"#Simple{")
 set ASegmentStrStart = $Find(AReciveSingle,"#Segment{")
 set ATextDescStrStart = $Find(AReciveSingle,"#TextDesc{")
 set ATableSimpleStrStart = $Find(AReciveSingle,"#Table{")
 set AImageAnnotateStrStart = $Find(AReciveSingle,"#ImageAnnotate{")
 set AFigureStrStart = $find(AReciveSingle,"#Figure{")
 set ASegmentSimpleStrStart = $Find(AReciveSingle,"#SegmentSimple{")    //add by Candyxu

 s ASimpleStr = ""
 s ASegmentStr = ""
 s ATextDescStr =""
 s ATableSimpleStr = ""
 s AImageAnnotateStr=""
 s AFigureStr = ""
 s ASegmentSimpleStr = ""   //add by Candyxu
 
 //get Simple String
 set ASimpleStr= $EXTRACT(AReciveSingle,ASimpleStrStart,ASegmentStrStart-11)
 //s ^gjbtest("ASimpleStr")=ASimpleStr
 //get Segment String   modify by Candyxu	
 set ASegmentStr= $EXTRACT(AReciveSingle,ASegmentStrStart,ASegmentSimpleStrStart-17)
 // get SegmentSimple String  add by Candyxu
 set ASegmentSimpleStr = $EXTRACT(AReciveSingle,ASegmentSimpleStrStart,ATextDescStrStart-12)   

 //get TextDesc String
 if (ATableSimpleStrStart '= 0)
 {	s ATextDescStr = $EXTRACT(AReciveSingle,ATextDescStrStart,ATableSimpleStrStart-9)}
 else
 {	
 	if (AImageAnnotateStrStart '= 0)
 	{	s ATextDescStr = $EXTRACT(AReciveSingle,ATextDescStrStart,AImageAnnotateStrStart-17)}
 	else
 	{
	 	if (AFigureStrStart '= 0)
		{	s ATextDescStr = $EXTRACT(AReciveSingle,ATextDescStrStart,AFigureStrStart-10)}
		else
		{	s ATextDescStr = $EXTRACT(AReciveSingle,ATextDescStrStart,$L(AReciveSingle)-1)}
	}
 }
 
 //get TableSimple String
 if (ATableSimpleStrStart '= 0)
 {
	 if (AImageAnnotateStrStart '= 0)
	 {	s ATableSimpleStr = $EXTRACT(AReciveSingle,ATableSimpleStrStart,AImageAnnotateStrStart-17)}
	 else
	 {
		 if (AFigureStrStart '= 0)
		 {	s ATableSimpleStr = $EXTRACT(AReciveSingle,ATableSimpleStrStart,AFigureStrStart-10)}
		 else
		 {	s ATableSimpleStr = $EXTRACT(AReciveSingle,ATableSimpleStrStart,$L(AReciveSingle)-1)}
	 }
 }
 else
 {	s ATableSimpleStr = ""}
 
 
 //get ImageAnnotate String
 if (AImageAnnotateStrStart '= 0)
 {
	if (AFigureStrStart '= 0)
	{	s AImageAnnotateStr	= $EXTRACT(AReciveSingle,AImageAnnotateStrStart,AFigureStrStart-10)	}
	else
	{	s AImageAnnotateStr = $EXTRACT(AReciveSingle,AImageAnnotateStrStart,$L(AReciveSingle)-1) }
 }
 else
 {	s AImageAnnotateStr = ""}
 
 //get Figure String
 if (AFigureStrStart '= 0)
 {	s AFigureStr = $EXTRACT(AReciveSingle,AFigureStrStart,$L(AReciveSingle)-1) }
 else
 { 	s AFigureStr = ""}	 
	 
 /*
 if (ATableSimpleStrStart=0)
 { 
 if (AImageAnnotateStrStart=0)
 { set ATextDescStr= $EXTRACT(AReciveSingle,ATextDescStrStart,$L(AReciveSingle)-1) 
 set ATableSimpleStr ="" 
 set AImageAnnotateStr ="" }
 elseif '(AImageAnnotateStrStart=0) 
 { set ATableSimpleStr ="" 
	  set ATextDescStr= $EXTRACT(AReciveSingle,ATextDescStrStart,AImageAnnotateStrStart-17)   
	  set AImageAnnotateStr= $EXTRACT(AReciveSingle,AImageAnnotateStrStart,$L(AReciveSingle)-1)  
	  }
 }
 elseif (ATableSimpleStrStart'=0)
 { 
 if (AImageAnnotateStrStart=0)
 { set ATextDescStr= $EXTRACT(AReciveSingle,ATextDescStrStart,ATableSimpleStrStart-9) 	 
 set ATableSimpleStr= $EXTRACT(AReciveSingle,ATableSimpleStrStart,$L(AReciveSingle)-1)
 set AImageAnnotateStr = ""
 } 	 
 elseif '(AImageAnnotateStrStart=0)
 { set ATextDescStr= $EXTRACT(AReciveSingle,ATextDescStrStart,ATableSimpleStrStart-9) 	 
 set ATableSimpleStr= $EXTRACT(AReciveSingle,ATableSimpleStrStart,AImageAnnotateStrStart-17)	   
 set AImageAnnotateStr = $EXTRACT(AReciveSingle,AImageAnnotateStrStart,$L(AReciveSingle)-1)	   
 }
 }
 */

 //split Simple
 if (ASimpleStr'= "")
 {
	 set SimpleItemCount = $LENGTH(ASimpleStr,",")
	 for I=  1 :1:SimpleItemCount
	 {
		 SET ASimpleItem=$PIECE(ASimpleStr,",",I)
		 //templateid
		 set ^TempEPRGetSimple(uniqueEPRGlobalID,I)= $P(ASimpleItem,"|",1)
		 // SimpleItemCode
		 set ^TempEPRGetSimple(uniqueEPRGlobalID,I,"1")= $P(ASimpleItem,"|",2)
		 //ValueCode
		 set ^TempEPRGetSimple(uniqueEPRGlobalID,I,"2")= $P(ASimpleItem,"|",3)
	 } 
 }

 //split Segmentstr
 if (ASegmentStr'="")
 {
	 set SegmentItemCount = $LENGTH(ASegmentStr,",")
	 for I=  1 :1:SegmentItemCount
	 {
		 //Segment
		 SET ASegmentItem=$PIECE(ASegmentStr,",",I)
		 //templateid
		 set ^TempEPRGetSegment(uniqueEPRGlobalID,I)= $P(ASegmentItem,"|",1)
		 //SegmentCode
		 set ^TempEPRGetSegment(uniqueEPRGlobalID,I,"1")= $P(ASegmentItem,"|",2)
	 } 
 }

 // split SegmentSimpleStr    add by Candyxu
 if (ASegmentSimpleStr '= "")
 {
	 set SegmentSimpleItemCount = $LENGTH(ASegmentSimpleStr,",")
	 for I= 1 :1:SegmentSimpleItemCount
	 {
	     set ASegmentSimpleItem = $PIECE(ASegmentSimpleStr,",",I)
	     //templateID
	     set ^TempEPRGetSegmentSimple(uniqueEPRGlobalID,I)= $P(ASegmentSimpleItem,"|",1)
	     //SegmentCode
	     set ^TempEPRGetSegmentSimple(uniqueEPRGlobalID,I,"1")= $P(ASegmentSimpleItem,"|",2)
	     //SimpleCode
	     set ^TempEPRGetSegmentSimple(uniqueEPRGlobalID,I,"1","1")= $P(ASegmentSimpleItem,"|",3)
	     set ^TempEPRGetSegmentSimple(uniqueEPRGlobalID,I,"1","2")=	$P(ASegmentSimpleItem,"|",4)    
	 }
 }

 //split TextDescstr 
 if (ATextDescStr'="") 
 {
	 set TextDescItemCount = $LENGTH(ATextDescStr,",")
	 for I=  1 :1:TextDescItemCount
	 {
		 SET ATextDescItem=$PIECE(ATextDescStr,",",I)
		 //TemplateID
		 set ^TempEPRGetTextDesc(uniqueEPRGlobalID,I)= $P(ATextDescItem,"|",1)
		 //TextDescCode
		 set ^TempEPRGetTextDesc(uniqueEPRGlobalID,I,"1")= $P(ATextDescItem,"|",2)
	 }
 }

 //split table
 if (ATableSimpleStr'="") 
 {
	 set TableSimpleItemCount = $LENGTH(ATableSimpleStr,"],")
	 for I=  1 :1:TableSimpleItemCount
	 {
		 SET ATableSimpleItem=$PIECE(ATableSimpleStr,"],",I)
		 if (I=TableSimpleItemCount)
		 {
			 set ATableSimpleItem=$EXTRACT(ATableSimpleItem,0,$L(ATableSimpleItem)-1)
		 }
		 Set ATableSimpleHeadItem = $PIECE(ATableSimpleItem,"[",1)	  
		 Set ATableSimpleRowItem = $PIECE(ATableSimpleItem,"[",2)
		
		 set RowItemCount = $LENGTH(ATableSimpleRowItem,",")	  
			  
		 //TemplateID
		 set ^TempEPRGetTableSimple(uniqueEPRGlobalID,I)= $P(ATableSimpleHeadItem,"|",1)
		 //TableCode
		 set ^TempEPRGetTableSimple(uniqueEPRGlobalID,I,"1")= $P(ATableSimpleHeadItem,"|",2)
		 //SubItemsCount
		 set ^TempEPRGetTableSimple(uniqueEPRGlobalID,I,"SubItems")= RowItemCount
		 for K = 1:1:RowItemCount
		 {
			 set ARowItem = $PIECE(ATableSimpleRowItem,",",K)
			 //SimpleCODE
			 set ^TempEPRGetTableSimple(uniqueEPRGlobalID,I,"SubItems",K)= $P(ARowItem,"|",1)
			 //VTYPE
			 set ^TempEPRGetTableSimple(uniqueEPRGlobalID,I,"SubItems",K,"VTYPE")= $P(ARowItem,"|",2)   
			}
	 }
 }

 //split ImageAnnotatestr 
 if (AImageAnnotateStrStart'=0)
 { s ^TempEPRSingleAnnota(uniqueEPRGlobalID,"HasAnnotate")="True"  }
 if (AImageAnnotateStr'="") 
 {

	 set ImageAnnotateItemCount = $LENGTH(AImageAnnotateStr,",")
	 for I=1 :1:ImageAnnotateItemCount
	 {
		 SET AImageAnnotateItem=$PIECE(AImageAnnotateStr,",",I)
		 //TemplateID TID
		 set ^TempEPRGetImageAnnotate(uniqueEPRGlobalID,I)= $P(AImageAnnotateItem,"|",1)
		 //YCODE
		 set ^TempEPRGetImageAnnotate(uniqueEPRGlobalID,I,"1")= $P(AImageAnnotateItem,"|",2)
	 }
 }
 
 //split Figure String
 if (AFigureStr '= "")
 {
	 s ItemCount = $Length(AFigureStr,",")
	 for I = 1:1:ItemCount
	 {
		 s FigureItem = $P(AFigureStr,",",I)
		 s ^TempEPRGetFigure(uniqueEPRGlobalID,I) = $P(FigureItem,"|",1)
		 s ^TempEPRGetFigure(uniqueEPRGlobalID,I,"1") = $P(FigureItem,"|",2)
		 s ^TempEPRGetFigure(uniqueEPRGlobalID,I,"2") = $P(FigureItem,"|",3)
	 }
 }
}

/// Desc: 获取可重复模板数据
ClassMethod GetMultipleData(uniqueEPRGlobalID As %String, AReciveHeadStr As %String, AReciveMultiple As %String, ByRef AReStream As %Stream, APrivacyLevel As %String = "") As %String
{
	// 初始化临时global，用于存储要返回的数据	
	K ^TempEPRMultipleDataSimple(uniqueEPRGlobalID)
	K ^TempEPRMultipleDataSegment(uniqueEPRGlobalID)
	K ^TempEPRMultipleDataTextDesc(uniqueEPRGlobalID)
	K ^TempEPRMultipleDataTableSim(uniqueEPRGlobalID)
	K ^TempEPRMultipleDataAnnotate(uniqueEPRGlobalID)
	K ^TempEPRMultipleDataSegmentSimple(uniqueEPRGlobalID)   // add by Candyxu
	
	// 获取查询字符串中的病人就诊和实例数据信息
	set Result=""
	Set PatientID =  $PIECE($PIECE(AReciveHeadStr,",",1),":",2)
	Set PatientTag =  $PIECE($PIECE(AReciveHeadStr,",",1),":",1)
	Set EpisodeID =  $PIECE($PIECE(AReciveHeadStr,",",2),":",2)
	Set EpisodeTag =  $PIECE($PIECE(AReciveHeadStr,",",2),":",1)
	Set AInstanceDataID =  $PIECE($PIECE(AReciveHeadStr,",",3),":",2)
	Set InstanceDataTag =  $PIECE($PIECE(AReciveHeadStr,",",3),":",1) 
	
	// 解析可重复病历数据的查询字符串，放入临时global
	//do ..ParseMultipleList(uniqueEPRGlobalID,AReciveMultiple,AInstanceDataID)
	do ..ParseMultipleList(uniqueEPRGlobalID,AReciveMultiple)
	
	// 获取Simple类型的数据
	set MultipleSimpleKey = $ORDER(^TempEPRMultipleGetSimple(uniqueEPRGlobalID,""))
	WHILE (MultipleSimpleKey '="") 
	{
	 	set ATemplateID = $G(^TempEPRMultipleGetSimple(uniqueEPRGlobalID,MultipleSimpleKey)) 
	 	set ASimpleItemCode = $G(^TempEPRMultipleGetSimple(uniqueEPRGlobalID,MultipleSimpleKey,"1")) 
	 	set AValueCode= $G(^TempEPRMultipleGetSimple(uniqueEPRGlobalID,MultipleSimpleKey,"2")) 
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
		   	s simpleValue = ..GetISimpleValue(MultipleIndex,ACodeType,AValueCode,ATemplateID,ASimpleItemCode,APrivacyLevel)
			set ^TempEPRMultipleDataSimple(uniqueEPRGlobalID,MultipleSimpleKey)= simpleValue
		}
		else
		{	
	 		set ^TempEPRMultipleDataSimple(uniqueEPRGlobalID,MultipleSimpleKey)= "*NULL"
		}
		 
	 	SET MultipleSimpleKey = $ORDER(^TempEPRMultipleGetSimple(uniqueEPRGlobalID,MultipleSimpleKey))	  	
	}
	
	set MultipleSimpleResult= "$Multiple#Simple{" 
	set MultipleSimpleDataKey = $ORDER(^TempEPRMultipleDataSimple(uniqueEPRGlobalID,""))
	if (MultipleSimpleDataKey= "")
	{
	 	set MultipleFlag = "False"
	}
	WHILE (MultipleSimpleDataKey'="")
	{
	 	if $G(^TempEPRMultipleDataSimple(uniqueEPRGlobalID,MultipleSimpleDataKey))'=""
	 	{
		 	set MultipleSimpleResult = MultipleSimpleResult _ $G(^TempEPRMultipleDataSimple(uniqueEPRGlobalID,MultipleSimpleDataKey))_"@^"
	 	}
		else //($G(^TempEPRMultipleDataSimple(uniqueEPRGlobalID,MultipleSimpleDataKey))="")
	 	{
		   set MultipleSimpleResult = MultipleSimpleResult _ "*NULL"_"@^"  
		}
	
	 	set MultipleFlag = "True"
	 	SET MultipleSimpleDataKey = $ORDER(^TempEPRMultipleDataSimple(uniqueEPRGlobalID,MultipleSimpleDataKey))	  		 
	}
	
	if (MultipleFlag="False")
	{
		set MultipleSimpleResult=MultipleSimpleResult_"}" 
	}
	elseif(MultipleFlag = "True")	 
	{
	 	set TempStr = MultipleSimpleResult
	 	Set MultipleSimpleResult = $EXTRACT(TempStr,1,$L(TempStr)-2) 	 
	 	set MultipleSimpleResult=MultipleSimpleResult_"}"	 
	}
	 
	set Result= Result_MultipleSimpleResult
	d AReStream.Write(MultipleSimpleResult)
	
	
	// 获取Segment类型的数据
	Set MultipleSegmentKey = $O(^TempEPRMultipleGetSegment(uniqueEPRGlobalID,""))
	WHILE (MultipleSegmentKey'="") 
	{
	 	set ATemplateID= $G(^TempEPRMultipleGetSegment(uniqueEPRGlobalID,MultipleSegmentKey)) 
	 	set ASegmentCode= $G(^TempEPRMultipleGetSegment(uniqueEPRGlobalID,MultipleSegmentKey,"1")) 
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
		  	d ..GetSegmentText(MultipleIndex, .StrText, .FormateInfoStr)
		  	set ^TempEPRMultipleDataSegment(uniqueEPRGlobalID,MultipleSegmentKey)= StrText
		 	set ^TempEPRMultipleDataSegment(uniqueEPRGlobalID,MultipleSegmentKey,"1")= FormateInfoStr 
		}
		Elseif (MultipleIndex="")
		{
	 		set ^TempEPRMultipleDataSegment(uniqueEPRGlobalID,MultipleSegmentKey)= "*NULL"
	 		set ^TempEPRMultipleDataSegment(uniqueEPRGlobalID,MultipleSegmentKey,"1")= "*NULL"
	 	}
	 
	 	SET MultipleSegmentKey = $ORDER(^TempEPRMultipleGetSegment(uniqueEPRGlobalID,MultipleSegmentKey))	  	
	 }
	
	set MultipleSegmentResult="#Segment{" 
	set MultipleSegmentDataKey = $ORDER(^TempEPRMultipleDataSegment(uniqueEPRGlobalID,""))
	if (MultipleSegmentDataKey= "")
	{
		set MultipleFlag = "False"
	}
	WHILE (MultipleSegmentDataKey'="")
	{
	 	set MultipleSegmentResult = MultipleSegmentResult _ $G(^TempEPRMultipleDataSegment(uniqueEPRGlobalID,MultipleSegmentDataKey))_"@|"
	 	set MultipleSegmentResult = MultipleSegmentResult _ $G(^TempEPRMultipleDataSegment(uniqueEPRGlobalID,MultipleSegmentDataKey,"1"))_"@^"
	
	 	set MultipleFlag = "True"
	 	SET MultipleSegmentDataKey = $ORDER(^TempEPRMultipleDataSegment(uniqueEPRGlobalID,MultipleSegmentDataKey))	  		 
	}
	
	if (MultipleFlag="False")
	{	set MultipleSegmentResult=MultipleSegmentResult_"}"}
	elseif(MultipleFlag = "True")	 
	{
	 	set TempStr = MultipleSegmentResult
	 	Set MultipleSegmentResult = $EXTRACT(TempStr,1,$L(TempStr)-2) 	 
	 	set MultipleSegmentResult=MultipleSegmentResult_"}"	 
	}
	 
	s Result=Result_MultipleSegmentResult
	d AReStream.Write(MultipleSegmentResult) 
	
	//获取SegmentSimple类型的数据   add by Candyxu
	set MultipleSegmentSimpleKey = $ORDER(^TempEPRMultipleGetSegmentSimple(uniqueEPRGlobalID,""))
	WHILE (MultipleSegmentSimpleKey'="") 
	{
	    set ATemplateID= $G(^TempEPRMultipleGetSegmentSimple(uniqueEPRGlobalID,MultipleSegmentSimpleKey)) 
 	    set BlankTemplateID= " "_ATemplateID
     	    set BlankEpisodeID =" "_EpisodeID
 	    set ASegmentCode= $G(^TempEPRMultipleGetSegmentSimple(uniqueEPRGlobalID,MultipleSegmentSimpleKey,"1")) 
 	    set BlankSegmentCode =" "_ASegmentCode
 	    set ASimpleCode = $G(^TempEPRMultipleGetSegmentSimple(uniqueEPRGlobalID,MultipleSegmentSimpleKey,"1","1")) 
	    set BlankSimpleCode =" "_ASimpleCode 
	    set ACodeType = $EXTRACT(ASimpleCode,1)
	    set ATypeCode = $G(^TempEPRMultipleGetSegmentSimple(uniqueEPRGlobalID,MultipleSegmentSimpleKey,"1","2")) 
	    if $D(^DHCEPRI.ISegmentSimpleI)
	    {
	       set BlankInstanceDataID = $o(^DHCEPRI.ISegmentSimpleI("IdxForLink",BlankEpisodeID, BlankTemplateID, BlankSegmentCode, BlankSimpleCode, ""))
	       if (BlankInstanceDataID '="")
	       {
		   set MultipleIndex = $o(^DHCEPRI.ISegmentSimpleI("IdxForLink",BlankEpisodeID, BlankTemplateID, BlankSegmentCode, BlankSimpleCode,BlankInstanceDataID,""))
	       } elseif (BlankInstanceDataID=""){ set MultipleIndex= ""  }
	    }  else {set MultipleIndex= "" }
 	    if (MultipleIndex'="")
 	    {
		set SegmentSimpleValue = ..GetSegmentSimpleText(MultipleIndex, ACodeType,ATypeCode)
		set ^TempEPRMultipleDataSegmentSimple(uniqueEPRGlobalID,MultipleSegmentSimpleKey) = SegmentSimpleValue
	    }
	    Elseif (MultipleIndex="")
	    {
 		set ^TempEPRMultipleDataSegmentSimple(uniqueEPRGlobalID,MultipleSegmentSimpleKey)= "*NULL"
 	    }
 	    SET MultipleSegmentSimpleKey = $ORDER(^TempEPRMultipleGetSegmentSimple(uniqueEPRGlobalID,MultipleSegmentSimpleKey))	
         }
	set MultipleSegmentSimpleResult = "#SegmentSimple{"
	set MultipleSegmentSimpleDataKey = $ORDER(^TempEPRMultipleDataSegmentSimple(uniqueEPRGlobalID,""))
	if (MultipleSegmentSimpleDataKey =""){set MultipleFlag = "False"}
	WHILE(MultipleSegmentSimpleDataKey '="")
	{
	   if $G(^TempEPRMultipleDataSegmentSimple(uniqueEPRGlobalID,MultipleSegmentSimpleDataKey))'=""
	   {
		  set MultipleSegmentSimpleResult = MultipleSegmentSimpleResult_$G(^TempEPRMultipleDataSegmentSimple(uniqueEPRGlobalID,MultipleSegmentSimpleDataKey))_"@^"
	   }
	   elseif $G(^TempEPRMultipleDataSegmentSimple(uniqueEPRGlobalID,MultipleSegmentSimpleDataKey))=""
	   {
		   set MultipleSegmentSimpleResult = MultipleSegmentSimpleResult_"*NULL"_"@^" 
	   }
	   set MultipleFlag = "True"
	   set MultipleSegmentSimpleDataKey = $ORDER(^TempEPRMultipleDataSegmentSimple(uniqueEPRGlobalID,MultipleSegmentSimpleDataKey))
	}
	if (MultipleFlag = "False")
	{set MultipleSegmentSimpleResult = MultipleSegmentSimpleResult_"}"}
	elseif(MultipleFlag = "True")
	{
	    set TempStr = MultipleSegmentSimpleResult
	    set MultipleSegmentSimpleResult = $EXTRACT(TempStr,1,$L(TempStr)-2)
	    set MultipleSegmentSimpleResult = MultipleSegmentSimpleResult_"}"
        }
	D AReStream.Write(MultipleSegmentSimpleResult)


	// 获取TextDesc类型的数据
	Set MultipleTextDescKey = $ORDER(^TempEPRMultipleGetTextDesc(uniqueEPRGlobalID,""))
	
	WHILE (MultipleTextDescKey'="") 
	{
	 	set ATemplateID= $G(^TempEPRMultipleGetTextDesc(uniqueEPRGlobalID,MultipleTextDescKey)) 
	 	set ATextDescCode= $G(^TempEPRMultipleGetTextDesc(uniqueEPRGlobalID,MultipleTextDescKey,"1")) 
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
		 	//modified on 2013-01-02 by houj
		  	//d ..GetTextDescText(MultipleIndex, .StrText, .FormateInfoStr)
			set ^TempEPRMultipleDataTextDesc(uniqueEPRGlobalID,MultipleTextDescKey)= MultipleIndex
			set ^TempEPRMultipleDataTextDesc(uniqueEPRGlobalID,MultipleTextDescKey,"1")= MultipleIndex
		}
		Elseif (MultipleIndex="")
		{
		  	set ^TempEPRMultipleDataTextDesc(uniqueEPRGlobalID,MultipleTextDescKey)= "*NULL"
		  	set ^TempEPRMultipleDataTextDesc(uniqueEPRGlobalID,MultipleTextDescKey,"1")= "*NULL"
		}
	 
	 	SET MultipleTextDescKey = $ORDER(^TempEPRMultipleGetTextDesc(uniqueEPRGlobalID,MultipleTextDescKey))	  	
	}
		
	// Make TextDesc 
	/*set MultipleTextResult = "#TextDesc{"
	set MultipleTextDescDataKey = $ORDER(^TempEPRMultipleDataTextDesc(uniqueEPRGlobalID,""))
	if (MultipleTextDescDataKey= "")
	{
		set MultipleFlag = "False"
	}
	WHILE (MultipleTextDescDataKey'="")
	{
		set MultipleTextResult = MultipleTextResult _ $G(^TempEPRMultipleDataTextDesc(uniqueEPRGlobalID,MultipleTextDescDataKey))_"@|"
		set MultipleTextResult = MultipleTextResult _ $G(^TempEPRMultipleDataTextDesc(uniqueEPRGlobalID,MultipleTextDescDataKey,"1"))_"@^"
		set MultipleFlag = "True"
		SET MultipleTextDescDataKey = $ORDER(^TempEPRMultipleDataTextDesc(uniqueEPRGlobalID,MultipleTextDescDataKey))	  		 
	}
	
	if (MultipleFlag="False")
	{
		set MultipleTextResult=MultipleTextResult_"}" 
	}
	elseif(MultipleFlag = "True")	 
	{
	 	set TempStr = MultipleTextResult
	 	Set MultipleTextResult = $EXTRACT(TempStr,1,$L(TempStr)-2) 	 
	 	set MultipleTextResult=MultipleTextResult_"}"	 
	}
	
	s Result=Result_MultipleTextResult
	d AReStream.Write(MultipleTextResult) 
	*/
	d AReStream.Write("#TextDesc{")
	
	set MultipleTextDescCount = 0
	set MultipleTextDescDataKey = ""
	for {
		set MultipleTextDescDataKey = $ORDER(^TempEPRMultipleDataTextDesc(uniqueEPRGlobalID,MultipleTextDescDataKey))
		q:(MultipleTextDescDataKey = "")
		
		set MultipleTextDescCount = MultipleTextDescCount + 1
		if (MultipleTextDescCount > 1)
		{
			d AReStream.Write("@^")
		}
		
		s MultipleIndex = $G(^TempEPRMultipleDataTextDesc(uniqueEPRGlobalID,MultipleTextDescDataKey))
		do ..GetTextDescData(MultipleIndex, .AReStream)
	}
	
	d AReStream.Write("}") 
	
	// 获取TableSimple类型的数据 - modified by houj
	set MultiTableSimpleKey = $ORDER(^TempEPRMultipleGetTableSimple(uniqueEPRGlobalID,""))
	WHILE (MultiTableSimpleKey'="") 
	{
	 	set ATemplateID= $G(^TempEPRMultipleGetTableSimple(uniqueEPRGlobalID,MultiTableSimpleKey)) 
	 	set ATableCode= $G(^TempEPRMultipleGetTableSimple(uniqueEPRGlobalID,MultiTableSimpleKey,"1")) 
	
	 	set BlankTableCode =" "_ATableCode
	 	set BlankEpisodeID =" "_EpisodeID
	 	set BlankTemplateID = " "_ATemplateID
	 	set BlankInstanceDataID=" "_AInstanceDataID
	
	 	set ARowCount= $G(^TempEPRMultipleGetTableSimple(uniqueEPRGlobalID,MultiTableSimpleKey,"SubItems")) 
	
	 	set ^TempEPRMultipleDataTableSim(uniqueEPRGlobalID,MultiTableSimpleKey)= MultiTableSimpleKey
	
	 	set ^TempEPRMultipleDataTableSim(uniqueEPRGlobalID,MultiTableSimpleKey,"RowItems")= ARowCount
	
	 	For I=1:1:ARowCount
	 	{
		 	set AMultiItemCode= $G(^TempEPRMultipleGetTableSimple(uniqueEPRGlobalID,MultiTableSimpleKey,"SubItems",I))   
		 	set ACodeType = $EXTRACT(AMultiItemCode,1)
		 	set AValueCode= $G(^TempEPRMultipleGetTableSimple(uniqueEPRGlobalID,MultiTableSimpleKey,"SubItems",I,"VTYPE"))     
		 	set BlankMultiItemCode= " "_AMultiItemCode
	
	 		if $D(^DHCEPRI.ITableSimpleI)	   
	 		{ 
	 			set ^TempEPRMultipleDataTableSim(uniqueEPRGlobalID,MultiTableSimpleKey,"RowItems",I)= "RowData"  
		      	Set CowCount = 0
		      	Set BlankRowNumber= $O(^DHCEPRI.ITableSimpleI("IdxForLink",BlankEpisodeID,BlankTemplateID,BlankTableCode,BlankMultiItemCode,BlankInstanceDataID,""))     
		      	While (BlankRowNumber '="")
		       	{
			       	Q:(BlankRowNumber="")
			       	Set MultipleIndex = $O(^DHCEPRI.ITableSimpleI("IdxForLink",BlankEpisodeID,BlankTemplateID,BlankTableCode,BlankMultiItemCode,BlankInstanceDataID,BlankRowNumber,""))     
	 				
	 				set CowCount = CowCount + 1
	 				if (MultipleIndex'="")
	 				{ 
	 					D ..GetTableSimpleValue(MultipleIndex,ACodeType,AValueCode, .simpleValue, .rowNumber)
	 					set ^TempEPRMultipleDataTableSim(uniqueEPRGlobalID,MultiTableSimpleKey,"RowItems",I,rowNumber)= simpleValue
	 				}
	 				
	 				Set BlankRowNumber= $O(^DHCEPRI.ITableSimpleI("IdxForLink",BlankEpisodeID,BlankTemplateID,BlankTableCode,BlankMultiItemCode,BlankInstanceDataID,BlankRowNumber))
			   	}
			    
	 			set ^TempEPRMultipleDataTableSim(uniqueEPRGlobalID,MultiTableSimpleKey,"RowItems",I,"ItemCount")= CowCount
	 		}
	 		elseif  '$D(^DHCEPRI.ITableSimpleI)
	 		{
		 		set ^TempEPRMultipleDataTableSim(uniqueEPRGlobalID,MultiTableSimpleKey,"RowItems",I)= "*NULL" 
			}
	 	}
	 	
	 	set MultiTableSimpleKey = $ORDER(^TempEPRMultipleGetTableSimple(uniqueEPRGlobalID,MultiTableSimpleKey))
	 }
	
	 
	//Make table str
	;B "S"
	set MultipleTableSimpleDataKey = $ORDER(^TempEPRMultipleDataTableSim(uniqueEPRGlobalID,""))
	set MultipleTableSimpleStr= "#Table{"
	set TableSimpleFlag = ""
	if (MultipleTableSimpleDataKey= "")
	{
		set TableSimpleFlag = "False"
	}
	
	WHILE (MultipleTableSimpleDataKey'="")
	{
		if ($G(^TempEPRMultipleDataTableSim(uniqueEPRGlobalID,MultipleTableSimpleDataKey,"RowItems"))'="")
	 	{ 
	 		set StrRowCount = $G(^TempEPRMultipleDataTableSim(uniqueEPRGlobalID,MultipleTableSimpleDataKey,"RowItems"))
	 		for X=1:1:StrRowCount
	 		{
		 		if ($G(^TempEPRMultipleDataTableSim(uniqueEPRGlobalID,MultipleTableSimpleDataKey,"RowItems",X))'="")  
		 		{ 
		   			if ($G(^TempEPRMultipleDataTableSim(uniqueEPRGlobalID,MultipleTableSimpleDataKey,"RowItems",X))="RowData")  
		   			{
			 			if (X=1)
			 			{ set MultipleTableSimpleStr= MultipleTableSimpleStr_"[" }
			 /*elseif (X'=1)
			 { set MultipleTableSimpleStr= MultipleTableSimpleStr_",[" }*/
			 			if ($G(^TempEPRMultipleDataTableSim(uniqueEPRGlobalID,MultipleTableSimpleDataKey,"RowItems",X,"ItemCount"))'="")  
			 			{
			   				set ACowItemCount = $G(^TempEPRMultipleDataTableSim(uniqueEPRGlobalID,MultipleTableSimpleDataKey,"RowItems",X,"ItemCount"))	 
			   				For Y=1:1:ACowItemCount
			   				{
				 ;B "S"
				 if ($G(^TempEPRMultipleDataTableSim(uniqueEPRGlobalID,MultipleTableSimpleDataKey,"RowItems",X,Y))'="")	   
				 {
				    set ADataValue = $G(^TempEPRMultipleDataTableSim(uniqueEPRGlobalID,MultipleTableSimpleDataKey,"RowItems",X,Y))
				    ;B "S"
				    if (Y=ACowItemCount)
				    {  
				      ;B "S"
				      if (X=StrRowCount)		
				      { set MultipleTableSimpleStr= MultipleTableSimpleStr_ADataValue_"]," }
				      if (X'=StrRowCount)
				      {	set MultipleTableSimpleStr= MultipleTableSimpleStr_ADataValue_"@^" }
					}
				    elseif (Y'=ACowItemCount)
				    {
					   set MultipleTableSimpleStr= MultipleTableSimpleStr_ADataValue_"@|"
					    } 	
					 
					}
				elseif ($G(^TempEPRMultipleDataTableSim(uniqueEPRGlobalID,MultipleTableSimpleDataKey,"RowItems",X,Y))="")	   
				{
				    if (Y=ACowItemCount)
				    {  
				      if (X=StrRowCount)		
				      { set MultipleTableSimpleStr= MultipleTableSimpleStr_"*NULL"_"]," }
				      if (X'=StrRowCount)
				      {set MultipleTableSimpleStr= MultipleTableSimpleStr_"*NULL"_"@^" }
					  }
				    elseif (Y'=ACowItemCount)
				    {
					   set MultipleTableSimpleStr= MultipleTableSimpleStr_"*NULL"_"@|"
					  } 	
					}	
				   
				}
			   	 
				 }
			  }
		    elseif ($G(^TempEPRMultipleDataTableSim(uniqueEPRGlobalID,MultipleTableSimpleDataKey,"RowItems",X))="*NULL")  
		    {
	 				if (X=StrRowCount)
		       { set MultipleTableSimpleStr= MultipleTableSimpleStr_"*NULL"_"]," }
		         elseif (X'=StrRowCount)
		       {
		        set MultipleTableSimpleStr= MultipleTableSimpleStr_"*NULL"_"@^"
			   	 }
		     }	  
		 }
		 elseif ($G(^TempEPRMultipleDataTableSim(uniqueEPRGlobalID,MultipleTableSimpleDataKey,"RowItems",X))="")  
		 {  
		   if (X=StrRowCount)
		   { set MultipleTableSimpleStr= MultipleTableSimpleStr_"*NULL"_"]," }
		   elseif (X'=StrRowCount)
		   {
		     set MultipleTableSimpleStr= MultipleTableSimpleStr_"*NULL"_"@^"
			 }
		 }
	
	
	 //set Result = Result _ $G(^TempEPRMultipleDataTableSim(uniqueEPRGlobalID,MultipleTableSimpleDataKey))_"@|"
	 }
	 }
	
	 set TableSimpleFlag = "True"
	
	 SET MultipleTableSimpleDataKey = $ORDER(^TempEPRMultipleDataTableSim(uniqueEPRGlobalID,MultipleTableSimpleDataKey))
	 }
	
	 if (TableSimpleFlag="True")
	 { set MultipleTableSimpleStr =  $E(MultipleTableSimpleStr,0,$L(MultipleTableSimpleStr)-1) _ "}"  }
	 if (TableSimpleFlag="False")
	 { set MultipleTableSimpleStr = MultipleTableSimpleStr_"}"}
	
	 set Result= Result_MultipleTableSimpleStr
	 D AReStream.Write(MultipleTableSimpleStr)
	
	 //Get  Annotate
	 //
	 Set MultipleAnnotateKey = $O(^TempEPRMultipleGetImageAnnotate(uniqueEPRGlobalID,""))
	 if (MultipleAnnotateKey="")
	 {
		S MultipleAnnotateStrFlag ="False"   
		 }
	 WHILE (MultipleAnnotateKey'="") 
	 {
	 set ATemplateID = $G(^TempEPRMultipleGetImageAnnotate(uniqueEPRGlobalID,MultipleAnnotateKey)) 
	
	 set AImageAnnotateCode = $G(^TempEPRMultipleGetImageAnnotate(uniqueEPRGlobalID,MultipleAnnotateKey,"1")) 
	 set BlankImageAnnotateCode = " "_AImageAnnotateCode
	
	
	 set BlankTemplateID = " "_ATemplateID
	 set BlankInstanceDataID=" "_AInstanceDataID
	 set BlankEpisodeID= " "_EpisodeID
	
	 if $D(^DHCEPRI.IAnnotateI)
	 {
		   set MultipleIndex = $O(^DHCEPRI.IAnnotateI("IdxForLink",BlankEpisodeID,BlankTemplateID,BlankImageAnnotateCode,BlankInstanceDataID,""))
	 }
	 else 
	 {
		 s MultipleIndex =""  
		   }
	 if (MultipleIndex'="")
	 {
		  set objIAnnotate = ##class(EPRinstance.IAnnotate).%OpenId(MultipleIndex)
	 if (objIAnnotate'="")
	 {Set MetaAnnotateID = ##class(EPRmeta.ImageAnnotate).CheckDataExits(objIAnnotate.TemplateID,objIAnnotate.TemplateVersion,objIAnnotate.ImageAnnotateCode) }
	 elseif (objIAnnotate="")
	 {
		     set MetaAnnotateID="0"
		     }
		  set ^TempEPRMultipleDataAnnotate(uniqueEPRGlobalID,MultipleAnnotateKey)= MultipleIndex
		  set ^TempEPRMultipleDataAnnotate(uniqueEPRGlobalID,MultipleAnnotateKey,"1")= MetaAnnotateID
		s objIAnnotate =""
		}
		Elseif (MultipleIndex="")
		{
	 set ^TempEPRMultipleDataAnnotate(uniqueEPRGlobalID,MultipleAnnotateKey)= "*NULL"
	 set ^TempEPRMultipleDataAnnotate(uniqueEPRGlobalID,MultipleAnnotateKey,"1")= "*NULL"
	 }
	 s MultipleAnnotateStrFlag="True"  
	 SET MultipleAnnotateKey = $ORDER(^TempEPRMultipleGetImageAnnotate(uniqueEPRGlobalID,MultipleAnnotateKey))	  	
	 }
		
	 // Make AnnotateStr 
	 set MultipleAnnotateKey = $ORDER(^TempEPRMultipleDataAnnotate(uniqueEPRGlobalID,""))
	 if (MultipleAnnotateStrFlag="True")
	 {
		set MultipleAnnotateStream = ##class(%GlobalCharacterStream).%New() 
		d MultipleAnnotateStream.Write("#ImageAnnotate{")
		set AnnotateMultipleStr= "#ImageAnnotate{"  
	 }
	 
	 WHILE (MultipleAnnotateKey'="")
	 {
		
	 if $G(^TempEPRMultipleDataAnnotate(uniqueEPRGlobalID,MultipleAnnotateKey))'=""
	 {  
	 	set MultipleImageAnnotateId= $G(^TempEPRMultipleDataAnnotate(uniqueEPRGlobalID,MultipleAnnotateKey))
		if (MultipleImageAnnotateId="*NULL")
		{ 
			d MultipleAnnotateStream.Write("*NULL@|")
			s AnnotateMultipleStr =AnnotateMultipleStr_"*NULL@|"
		}
	 	
	 	set objIAnnotate = ##class(EPRinstance.IAnnotate).%OpenId(MultipleImageAnnotateId)
		if (objIAnnotate'="")
		{ 
		
		//读图片数据
		/*
		While (objIAnnotate.AnnoData.AtEnd = 0) 
	 	{ 
	 		Set len = 10240
	 		set TmpStrText= objIAnnotate.AnnoData.Read(len)
	 		d MultipleAnnotateStream.Write(TmpStrText) 
	 	}
	 	*/
	 		d ..GetAnnoData(.objIAnnotate, .MultipleAnnotateStream)
	 		d MultipleAnnotateStream.Write("@|")
	 		set AnnotateMultipleStr= AnnotateMultipleStr_"*NULL@|"  
	 	}		  
	 	elseif (objIAnnotate="")
	 	{ 
	 		d MultipleAnnotateStream.Write("*NULL@|")
			s AnnotateMultipleStr =AnnotateMultipleStr_"*NULL@|"
		}
		
	 	s objIAnnotate=""
	 }
	 Elseif ($G(^TempEPRMultipleDataAnnotate(uniqueEPRGlobalID,MultipleAnnotateKey))="")
	 {  
	 	d MultipleAnnotateStream.Write("*NULL@|")
		s AnnotateMultipleStr=AnnotateMultipleStr_"*NULL@|"
	 }
	
	 if ($G(^TempEPRMultipleDataAnnotate(uniqueEPRGlobalID,MultipleAnnotateKey,"1"))'="")
	 { 	
	 	set MetaAnnotateID= $G(^TempEPRMultipleDataAnnotate(uniqueEPRGlobalID,MultipleAnnotateKey,"1"))
		if (MetaAnnotateID'="")
		{ 
			if (MetaAnnotateID'="0")	 
			{ 
				if (MetaAnnotateID="*NULL")
			 	 { 
			 	 	d MultipleAnnotateStream.Write("*NULL@^")
			   	 	s AnnotateMultipleStr =AnnotateMultipleStr_"*NULL@^" 
			   	 }
		     	elseif '(MetaAnnotateID="*NULL")
		     	{
			    	set objMetaImage = ##class(EPRmeta.ImageAnnotate).%OpenId(MetaAnnotateID)
			    	if (objMetaImage'="")  
			    	{ 
			    		Set MetaImageStr= ""
			    		//读图片数据
					 	/*
					 	While (objMetaImage.ImageData.AtEnd = 0) 
					 	{ 
					 		Set len = 10240
					 		set TmpMetaImageStrText= objMetaImage.ImageData.Read(len)
					 		d MultipleAnnotateStream.Write(TmpMetaImageStrText) 
					 	}
					 	*/
					 	d ..GetImageData(.objMetaImage, .MultipleAnnotateStream) 	
					 	d MultipleAnnotateStream.Write("@^")
					 	set AnnotateMultipleStr =AnnotateMultipleStr_"*NULL@^"  
				 	}
				 elseif (objMetaImage="")  
				  { d MultipleAnnotateStream.Write("*NULL@^")
				    S AnnotateMultipleStr =AnnotateMultipleStr_"*NULL@^"  } 
				  s objMetaImage = ""
			  }
			 }
			 elseif (MetaAnnotateID="0")
			 { d MultipleAnnotateStream.Write("*NULL@^")
			   S AnnotateMultipleStr =AnnotateMultipleStr_"*NULL@^" } 	 			 
			 }
		 elseif (MetaAnnotateID="") 
		 {
	 d MultipleAnnotateStream.Write("*NULL@^")
			 s AnnotateMultipleStr =AnnotateMultipleStr_"*NULL@^"
			 }
	 }
	 Elseif ($G(^TempEPRMultipleDataAnnotate(uniqueEPRGlobalID,MultipleAnnotateKey,"1"))="")
	 {  d MultipleAnnotateStream.Write("*NULL@^")
		    s AnnotateMultipleStr =AnnotateMultipleStr_"*NULL@^"
		   }  
		
	 SET MultipleAnnotateKey = $ORDER(^TempEPRMultipleDataAnnotate(uniqueEPRGlobalID,MultipleAnnotateKey))	  		 
	 }
		
		
	 if ($D(^TempEPRMultipleAnnota(uniqueEPRGlobalID,"HasAnnotate")))
	 {  set HasMultipleAnnotateFlag="False"
		 Set HasMultipleAnnotateFlag=$G(^TempEPRMultipleAnnota(uniqueEPRGlobalID,"HasAnnotate"))	 
		 if (HasMultipleAnnotateFlag="True")
		 { if (MultipleAnnotateStrFlag="True") 
			 {  set AnnotateMultipleStr= $E(AnnotateMultipleStr,0,$L(AnnotateMultipleStr)-1) _ "}"
				 while (MultipleAnnotateStream.AtEnd = 0) 
				 { Set len = 10240
					 set TmpMultipleAnnotateStr= MultipleAnnotateStream.Read(len)
					 if (MultipleAnnotateStream.AtEnd=1)
					 { set TmpMultipleAnnotateStr= $E(TmpMultipleAnnotateStr,0,$L(TmpMultipleAnnotateStr)-2)  
					 }
					 d AReStream.Write(TmpMultipleAnnotateStr)    
				 }
				 d AReStream.Write("}")    
				 set SingleAnnotateStream="" 
				 set Result= Result_AnnotateMultipleStr
			 } 
			 Elseif (MultipleAnnotateStrFlag="False") 
			 { 
				 D AReStream.Write("#ImageAnnotate{}")
				 s Result= Result_"#ImageAnnotate{}"
			 }  
		 }
	}
	
	
	//获取F单元数据
	//added on 2008-11-19 by houj
	//为图形单元取数
	s figFlag = "0"		//是否要取图形数据
	s figCount = 0			//图形单元数量
	s figDelimiter = ""	//图形单元返回值间的间隔，第一个为空，第二个及以后为 @^
	s figKey = $O(^TempEPRMultipleFigure(uniqueEPRGlobalID,""))
	if figKey '= ""
	{	
		s figFlag = "1"
		do AReStream.Write("#Figure{")
	}
	while figKey '= ""
	{
		 s figCount = figCount + 1
		 if figCount > 1
		 {	s figDelimiter = "@^"}
		 
		 s tid = $G(^TempEPRMultipleFigure(uniqueEPRGlobalID,figKey))
		 s fcode = $G(^TempEPRMultipleFigure(uniqueEPRGlobalID,figKey,"1"))
		 s vtype = $G(^TempEPRMultipleFigure(uniqueEPRGlobalID,figKey,"2"))
		
		 s rowIdStr = ##class(EPRservice.BOScatterData).GetMultipleIFigureId(EpisodeID,tid,fcode,AInstanceDataID)
		 if rowIdStr = ""
		 {
			 do AReStream.Write(figDelimiter)
			 do AReStream.Write("*NULL")
		 }
		 else
		 {
			 s idCount = $Length(rowIdStr,"|")
			 for I = 1:1:idCount
			 {
				 s rowId = $p(rowIdStr,"|",I)
				 s rowId = $P(rowId,"^",2)
				 s objFigure = ##class(EPRinstance.IFigure).%OpenId(rowId)
				 if objFigure '= ""
				 {
					if (I = 1)
					{	do AReStream.Write(figDelimiter)}
					else
					{	do AReStream.Write("@|")}
					if (vtype="V")
					{
						//读图片数据
						//while (objFigure.FigureData.AtEnd = 0)
						//{	do AReStream.Write(objFigure.FigureData.Read(10240))}
						d ..GetFigureData(.objFigure, .AReStream)
					}
					elseif (vtype="C")
					{	do AReStream.Write(objFigure.FigureDesc)}
				 }
			 }
		 }
		 
		 s figKey = $O(^TempEPRMultipleFigure(uniqueEPRGlobalID,figKey))
	 } 
	 if figFlag = "1"
	 {	do AReStream.Write("}")}
 
	
	
	
	 //instancedata str
 	s AInstanceDataStr = $G(^TempEPRMultipleInstanceData(uniqueEPRGlobalID,"QueryStr"))
 	s AInstanceDataStrStart = $G(^TempEPRMultipleInstanceData(uniqueEPRGlobalID,"QueryStrStart"))
 	if (AInstanceDataStr'="")
 	{
 	 	s retInstanceStr = ..GetInstanceData(uniqueEPRGlobalID,AReciveHeadStr,AInstanceDataStr,AReStream)
 	 	s ^TempEPRMultipleInstanceData(uniqueEPRGlobalID,"InstanceData") = retInstanceStr
 	}
 	Else
 	{	
 		set:(AInstanceDataStrStart>0) ^TempEPRMultipleInstanceData(uniqueEPRGlobalID,"InstanceData")="#InstanceData{}"
 	}
	 
	if ($G(^TempEPRMultipleInstanceData(uniqueEPRGlobalID,"InstanceData"))'= "")
	{
		s ResultInstanceStr=$G(^TempEPRMultipleInstanceData(uniqueEPRGlobalID,"InstanceData"))
		s Result =Result_ ResultInstanceStr
		D AReStream.Write(ResultInstanceStr)
	} 
	 
	 s Result = ""
	 quit Result
}

/// Desc：解析可重复模板查询字符串
ClassMethod ParseMultipleList(uniqueEPRGlobalID As %String, AReciveMultiple As %String)
{
 //B "S"
 
 K ^TempEPRMultipleGetSimple(uniqueEPRGlobalID)
 K ^TempEPRMultipleGetSegment(uniqueEPRGlobalID)
 K ^TempEPRMultipleGetTextDesc(uniqueEPRGlobalID)
 K ^TempEPRMultipleGetTableSimple(uniqueEPRGlobalID)
 K ^TempEPRMultipleGetImageAnnotate(uniqueEPRGlobalID)
 K ^TempEPRMultipleInstanceData(uniqueEPRGlobalID)
 K ^TempEPRMultipleAnnota(uniqueEPRGlobalID)
 K ^TempEPRMultipleFigure(uniqueEPRGlobalID)
 K ^TempEPRMultipleGetSegmentSimple(uniqueEPRGlobalID)   //add by Candyxu
 
 set ASimpleStrStart = $Find(AReciveMultiple,"#Simple{")
 set ASegmentStrStart = $Find(AReciveMultiple,"#Segment{")
 set ATextDescStrStart = $Find(AReciveMultiple,"#TextDesc{")
 set ATableSimpleStrStart = $Find(AReciveMultiple,"#Table{")
 set AImageAnnotateStrStart = $Find(AReciveMultiple,"#ImageAnnotate{")
 set AFigureStrStart = $Find(AReciveMultiple,"#Figure{")
 set AInstanceDataStrStart = $Find(AReciveMultiple,"#InstanceData{")
 set ASegmentSimpleStrStart = $Find(AReciveMultiple,"#SegmentSimple{")   //add by Candyxu

 set ASimpleStr = ""
 set ASegmentStr = ""
 set ATextDescStr = ""
 set ATableSimpleStr=""
 set AImageAnnotateStr =""
 set AFigureStr = ""
 Set AInstanceDataStr = ""
 set ASegmentSimpleStr = ""   //add by Candyxu
 
 set ASimpleStr= $EXTRACT(AReciveMultiple,ASimpleStrStart,ASegmentStrStart-11)

 //modify by Candyxu
 set ASegmentStr= $EXTRACT(AReciveMultiple,ASegmentStrStart,ASegmentSimpleStrStart-17)  
 //add by Candyxu
 set ASegmentSimpleStr = $EXTRACT(AReciveMultiple,ASegmentSimpleStrStart,ATextDescStrStart-12)  

 if (ATextDescStrStart > 0)
 {
	 if (ATableSimpleStrStart > 0)
	 {
		 set ATextDescStr = $EXTRACT(AReciveMultiple,ATextDescStrStart,ATableSimpleStrStart-9)
	 }
	 elseif (AImageAnnotateStrStart > 0)
	 {
		 set ATextDescStr = $EXTRACT(AReciveMultiple,ATextDescStrStart,AImageAnnotateStrStart-17)
	 }
	 elseif (AFigureStrStart > 0)
	 {
		 set ATextDescStr = $EXTRACT(AReciveMultiple,ATextDescStrStart,AFigureStrStart - 10)
	 }
	 elseif (AInstanceDataStrStart > 0)
	 {
		 set ATextDescStr = $EXTRACT(AReciveMultiple,ATextDescStrStart,AInstanceDataStrStart - 16)
	 }
	 else
	 {
		 set ATextDescStr = $EXTRACT(AReciveMultiple,ATextDescStrStart,$L(AReciveMultiple)-1)
	 }
 }
 
 if (ATableSimpleStrStart > 0)
 {
	 if (AImageAnnotateStrStart > 0)
	 {
		 set ATableSimpleStr = $EXTRACT(AReciveMultiple,ATableSimpleStrStart,AImageAnnotateStrStart-17)
	 }
	 elseif (AFigureStrStart > 0)
	 {
		 set ATableSimpleStr = $EXTRACT(AReciveMultiple,ATableSimpleStrStart,AFigureStrStart - 10)
	 }
	 elseif (AInstanceDataStrStart > 0)
	 {
		 set ATableSimpleStr = $EXTRACT(AReciveMultiple,ATableSimpleStrStart,AInstanceDataStrStart - 16)
	 }
	 else
	 {
		 set ATableSimpleStr = $EXTRACT(AReciveMultiple,ATableSimpleStrStart,$L(AReciveMultiple)-1)
	 }
 }
 
 if (AImageAnnotateStrStart > 0)
 {
	 if (AFigureStrStart > 0)
	 {
		 set AImageAnnotateStr = $EXTRACT(AReciveMultiple,AImageAnnotateStrStart,AFigureStrStart - 10)
	 }
	 elseif (AInstanceDataStrStart > 0)
	 {
		 set AImageAnnotateStr = $EXTRACT(AReciveMultiple,AImageAnnotateStrStart,AInstanceDataStrStart - 16)
	 }
	 else
	 {
		 set AImageAnnotateStr = $EXTRACT(AReciveMultiple,AImageAnnotateStrStart,$L(AReciveMultiple)-1)
	 }
 }
 
 if (AFigureStrStart > 0)
 {
	 if (AInstanceDataStrStart > 0)
	 {
		 set AFigureStr = $EXTRACT(AReciveMultiple,AFigureStrStart,AInstanceDataStrStart - 16)
	 }
	 else
	 {
		 set AFigureStr = $EXTRACT(AReciveMultiple,AFigureStrStart,$L(AReciveMultiple)-1)
	 }
 }
 
 if (AInstanceDataStrStart > 0)
 {
	 set AInstanceDataStr = $EXTRACT(AReciveMultiple,AInstanceDataStrStart,$L(AReciveMultiple)-1)
 }
 
 /*
 if (ATableSimpleStrStart=0)
 { 
	 if (AImageAnnotateStrStart=0) 
	 {
		 if (AInstanceDataStrStart=0)
		 { set ATextDescStr= $EXTRACT(AReciveMultiple,ATextDescStrStart,$L(AReciveMultiple)-1)
			 set AInstanceDataStr = ""
			 set AImageAnnotateStr=""
			 Set ATableSimpleStr =""
		 }
		 Elseif (AInstanceDataStrStart '=0)
		 { set ATableSimpleStr=""
			 set ATextDescStr= $EXTRACT(AReciveMultiple,ATextDescStrStart,AInstanceDataStrStart-16)	 
			 set AImageAnnotateStr=""
			 set AInstanceDataStr = $EXTRACT(AReciveMultiple,AInstanceDataStrStart,$L(AReciveMultiple)-1)	 
		 } 
	 }
	 elseif '(AImageAnnotateStrStart=0) 
	 {
		  if (AInstanceDataStrStart=0)
		  {
				set ATableSimpleStr=""
				set AInstanceDataStr=""
				set ATextDescStr= $EXTRACT(AReciveMultiple,ATextDescStrStart,AImageAnnotateStrStart-17)	    
				set AImageAnnotateStr = $EXTRACT(AReciveMultiple,AImageAnnotateStrStart,$L(AReciveMultiple)-1)	   
			  }
		  Elseif '(AInstanceDataStrStart=0)
		  {
				set ATableSimpleStr=""
				
				set ATextDescStr= $EXTRACT(AReciveMultiple,ATextDescStrStart,AImageAnnotateStrStart-17)	    
				set AImageAnnotateStr = $EXTRACT(AReciveMultiple,AInstanceDataStrStart,AInstanceDataStrStart-16)	    
				set AInstanceDataStr= $EXTRACT(AReciveMultiple,AInstanceDataStrStart,$L(AReciveMultiple)-1)	   
			 }
		} 
 }
 elseif (ATableSimpleStrStart'=0)
 {
		set ATextDescStr= $EXTRACT(AReciveMultiple,ATextDescStrStart,ATableSimpleStrStart-9)	   
		if (AImageAnnotateStrStart=0)
		{
			if (AInstanceDataStrStart=0)
		  {set ATableSimpleStr= $EXTRACT(AReciveMultiple,ATableSimpleStrStart,$L(AReciveMultiple)-1)
			 set AInstanceDataStr = ""
			 set AImageAnnotateStr =""
		  }
		  Elseif '(AInstanceDataStrStart =0)
		  {set AImageAnnotateStr =""
		   set ATableSimpleStr= $EXTRACT(AReciveMultiple,ATableSimpleStrStart,AInstanceDataStrStart-16)	 
	 		 set AInstanceDataStr = $EXTRACT(AReciveMultiple,AInstanceDataStrStart,$L(AReciveMultiple)-1)	 
		  }
		}
		 Elseif '(AImageAnnotateStrStart=0)
		 {
		  if (AInstanceDataStrStart=0)
		  {
				set AInstanceDataStr = ""
				set ATableSimpleStr= $EXTRACT(AReciveMultiple,ATableSimpleStrStart,AImageAnnotateStrStart-17)	 
				set AImageAnnotateStr = $EXTRACT(AReciveMultiple,AInstanceDataStrStart,$L(AReciveMultiple)-1)	 
			}
		  Elseif '(AInstanceDataStrStart=0)
		  {
				set ATableSimpleStr= $EXTRACT(AReciveMultiple,ATableSimpleStrStart,AImageAnnotateStrStart-17)	 
				set AImageAnnotateStr = $EXTRACT(AReciveMultiple,AImageAnnotateStrStart,AInstanceDataStrStart-16)	 
				set AInstanceDataStr= $EXTRACT(AReciveMultiple,AInstanceDataStrStart,$L(AReciveMultiple)-1)	 
			}	 
		 }
	} 
*/

 if (ASimpleStr'= "")
 {
	 set SimpleItemCount = $LENGTH(ASimpleStr,",")
	 for I=  1 :1:SimpleItemCount
	 {  SET ASimpleItem=$PIECE(ASimpleStr,",",I)
		 set ^TempEPRMultipleGetSimple(uniqueEPRGlobalID,I)= $P(ASimpleItem,"|",1)
		 set ^TempEPRMultipleGetSimple(uniqueEPRGlobalID,I,"1")= $P(ASimpleItem,"|",2)
		 set ^TempEPRMultipleGetSimple(uniqueEPRGlobalID,I,"2")= $P(ASimpleItem,"|",3)
 }
 } 

 if (ASegmentStr'="")
 { set SegmentItemCount = $LENGTH(ASegmentStr,",")
	 for I=  1 :1:SegmentItemCount
	 { SET ASegmentItem=$PIECE(ASegmentStr,",",I)
		 set ^TempEPRMultipleGetSegment(uniqueEPRGlobalID,I)= $P(ASegmentItem,"|",1)
		 set ^TempEPRMultipleGetSegment(uniqueEPRGlobalID,I,"1")= $P(ASegmentItem,"|",2)
	 } 
 }


 // SegmentSimple   add by Candyxu
 if (ASegmentSimpleStr '="")
 {
	 set SegmentSimpleItemCount = $LENGTH(ASegmentSimpleStr,",")
	 for I=  1 :1:SegmentSimpleItemCount
	 {  
	    set ASegmentSimpleItem=$PIECE(ASegmentSimpleStr,",",I)
	    set ^TempEPRMultipleGetSegmentSimple(uniqueEPRGlobalID,I)= $P(ASegmentSimpleItem,"|",1)
	    set ^TempEPRMultipleGetSegmentSimple(uniqueEPRGlobalID,I,"1")= $P(ASegmentSimpleItem,"|",2)
	    set ^TempEPRMultipleGetSegmentSimple(uniqueEPRGlobalID,I,"1","1")= $P(ASegmentSimpleItem,"|",3)
	    set ^TempEPRMultipleGetSegmentSimple(uniqueEPRGlobalID,I,"1","2")= $P(ASegmentSimpleItem,"|",4)
          }  
  }


 if (ATextDescStr'="")
 { set TextDescItemCount = $LENGTH(ATextDescStr,",")
	 for I=  1 :1:TextDescItemCount
	 {  SET ATextDescItem=$PIECE(ATextDescStr,",",I)
		 set ^TempEPRMultipleGetTextDesc(uniqueEPRGlobalID,I)= $P(ATextDescItem,"|",1)
		 set ^TempEPRMultipleGetTextDesc(uniqueEPRGlobalID,I,"1")= $P(ATextDescItem,"|",2)
	 }
 }

 //tablesimple 
 if (ATableSimpleStr'="") 
 {
 set TableSimpleItemCount = $LENGTH(ATableSimpleStr,"],")
 for I=  1 :1:TableSimpleItemCount
 {
 SET ATableSimpleItem=$PIECE(ATableSimpleStr,"],",I)
 if (I=TableSimpleItemCount)
 {
	 set ATableSimpleItem=$EXTRACT(ATableSimpleItem,0,$L(ATableSimpleItem)-1)
	  }
 Set ATableSimpleHeadItem = $PIECE(ATableSimpleItem,"[",1)	  
 Set ATableSimpleRowItem = $PIECE(ATableSimpleItem,"[",2)

 set RowItemCount = $LENGTH(ATableSimpleRowItem,",")	  
	  
 //TemplateID 
 //   
 set ^TempEPRMultipleGetTableSimple(uniqueEPRGlobalID,I)= $P(ATableSimpleHeadItem,"|",1)
 //TableCode
 set ^TempEPRMultipleGetTableSimple(uniqueEPRGlobalID,I,"1")= $P(ATableSimpleHeadItem,"|",2)
 //SubItemsCount
 set ^TempEPRMultipleGetTableSimple(uniqueEPRGlobalID,I,"SubItems")= RowItemCount
 for K = 1:1:RowItemCount
 {
	 set ARowItem = $PIECE(ATableSimpleRowItem,",",K)
	 //SCODE
	 set ^TempEPRMultipleGetTableSimple(uniqueEPRGlobalID,I,"SubItems",K)= $P(ARowItem,"|",1)
	 //VTYPE
	 set ^TempEPRMultipleGetTableSimple(uniqueEPRGlobalID,I,"SubItems",K,"VTYPE")= $P(ARowItem,"|",2)   
	}
 }
 }

 //splite AImageAnnotateStr 
 if (AImageAnnotateStrStart'=0)
 { s ^TempEPRMultipleAnnota(uniqueEPRGlobalID,"HasAnnotate")="True" }

 if (AImageAnnotateStr'="") 
 { set ImageAnnotateItemCount = $LENGTH(AImageAnnotateStr,",")
	 for I=  1 :1:ImageAnnotateItemCount
	 {  SET AImageAnnotateItem=$PIECE(AImageAnnotateStr,",",I)
	 //TemplateID TID
	 set ^TempEPRMultipleGetImageAnnotate(uniqueEPRGlobalID,I)= $P(AImageAnnotateItem,"|",1)
	 //YCODE
	 set ^TempEPRMultipleGetImageAnnotate(uniqueEPRGlobalID,I,"1")= $P(AImageAnnotateItem,"|",2)
	 }
 }

 if (AFigureStr '= "")
 {
	 s ItemCount = $Length(AFigureStr,",")
	 for I = 1:1:ItemCount
	 {
		 s FigureItem = $P(AFigureStr,",",I)
		 s ^TempEPRMultipleFigure(uniqueEPRGlobalID,I) = $P(FigureItem,"|",1)
		 s ^TempEPRMultipleFigure(uniqueEPRGlobalID,I,"1") = $P(FigureItem,"|",2)
		 s ^TempEPRMultipleFigure(uniqueEPRGlobalID,I,"2") = $P(FigureItem,"|",3)
	 }
 }
 
 //split InstanceData
 s ^TempEPRMultipleInstanceData(uniqueEPRGlobalID,"QueryStr") = AInstanceDataStr
 s ^TempEPRMultipleInstanceData(uniqueEPRGlobalID,"QueryStrStart") = AInstanceDataStrStart
}

/// Author: gaojb
/// Create: 2009-11-11
/// Desc: 根据InstanceDataId和InstanceDataStr取出与病历实例数据相关的信息，包括标题、作者、发生日期时间
///      被ParseMultipleList和ParseSingleList调用
/// Param: parInstanceId--，parInstanceDataStr--取实例相关信息的字串 
/// Debug: d ##Class(EPRservice.BODataGateway).GetInstanceData("207||1","HAPPENDATE,HAPPENTIME,AUTHOR")
/// Return: #InstanceData{60833,#InstanceData{60833,59143,#InstanceData{60833,59143,梁占光}#InstanceData{60833,59143,梁占光} 
///        Or
///        #InstanceData{}
ClassMethod GetInstanceData(uniqueEPRGlobalID As %String, AHeadStr As %String, AInstanceDataStr As %String, ByRef AReStream As %Stream) As %String
{
	//s ReInsStr = "#InstanceData{}"
	//q:(AInstanceDataStr = "#InstanceData{}") ReInsStr
	if (AInstanceDataStr = "#InstanceData{}")
	{
		d AReStream.Write("#InstanceData{}")
		q ""
	}
	
	s episodeID = $P($P(AHeadStr,",",2),":",2)
	s printDocID = $P($P(AHeadStr,",",4),":",2)
	s parInstanceId = $P($P(AHeadStr,",",3),":",2)
	//q:(parInstanceId = "") ReInsStr
	if (parInstanceId = "")
	{
		d AReStream.Write("#InstanceData{}")
		q ""
	}
	
	s objInstance = ##Class(EPRinstance.InstanceData).%OpenId(parInstanceId)
	//q:(objInstance = "") ReInsStr
	if (objInstance = "")
	{
		d AReStream.Write("#InstanceData{}")
		q ""
	}
	
	//s ReInsStr="#InstanceData{"
	d AReStream.Write("#InstanceData{")
	
	s InstanceDataItemCount = $LENGTH(AInstanceDataStr,",") 
	for I = 1:1:InstanceDataItemCount
	{
		s itemVal = "*NULL"
		s itemInfo = $PIECE(AInstanceDataStr,",",I)
		s InstanceDataItem = $PIECE(itemInfo,"|",1)
		s valueType = $P(itemInfo,"|",2) 
		if (InstanceDataItem="TITLE") 
		{	
			s itemVal = objInstance.Title
		}
		elseif (InstanceDataItem="HAPPENDATE") 
		{	
			s itemVal = $ZDATE(objInstance.HappenDate,3)
			if (valueType '= "")
			{	s itemVal = ..ConvertDate(itemVal, valueType)}
		}
		elseif (InstanceDataItem="HAPPENTIME")
		{	
			s itemVal = $ZTIME(objInstance.HappenTime,1)
			if (valueType '= "")
			{	s itemVal = ..ConvertTime(itemVal, valueType)}
		}
		elseif (InstanceDataItem="AUTHOR") 
		{
			//d getData($$getUser(objInstance.CreateUser))
			s itemVal = ..GetMultiUser(episodeID,printDocID,objInstance.ListNo,objInstance.CreateUser)
		}
		elseif (InstanceDataItem="LISTNO") 
		{
		 	s itemVal = ##class(EPRservice.BOInstanceData).ConvertListNo($p(parInstanceId,"||",1),$p(parInstanceId,"||",2),"1")
		}
		elseif (InstanceDataItem="CHECKUSER") 
		{
			//s listNo = ##class(EPRservice.BOInstanceData).ConvertListNo($p(parInstanceId,"||",1),$p(parInstanceId,"||",2),"1")
			s chkInfo = ..GetCheckInfo(episodeID,printDocID,objInstance.ListNo)
			s itemVal = $p(chkInfo,"^",1)
		}
		elseif (InstanceDataItem="CHECKDATE") 
		{
			//s listNo = ##class(EPRservice.BOInstanceData).ConvertListNo($p(parInstanceId,"||",1),$p(parInstanceId,"||",2),"1")
			s chkInfo = ..GetCheckInfo(episodeID,printDocID,objInstance.ListNo)
			s itemVal = $p(chkInfo,"^",2)
			if (valueType '= "")
			{	s itemVal = ..ConvertDate(itemVal, valueType)}
		}
		elseif (InstanceDataItem="CHECKLEVEL") 
		{
			//s listNo = ##class(EPRservice.BOInstanceData).ConvertListNo($p(parInstanceId,"||",1),$p(parInstanceId,"||",2),"1")
			s chkInfo = ..GetCheckInfo(episodeID,printDocID,objInstance.ListNo)
			s itemVal = $p(chkInfo,"^",3)
		}
		elseif (InstanceDataItem="COMMITUSER")
	 	{
		 	s itemVal = ..GetCommitUser(episodeID,printDocID,objInstance.ListNo)
	 	}
	 	elseif (InstanceDataItem="COMMITDATE")
	 	{
		 	s itemVal = ..GetCommitDateTime(episodeID,printDocID,objInstance.ListNo)
		 	s itemVal = $p(itemVal,"^",1)
		 	if (itemVal '= "") {set itemVal = $zd(itemVal,3)}
		 	if (valueType '= "")
		 	{	s itemVal = ..ConvertDate(itemVal, valueType)}
		}
		elseif (InstanceDataItem="ISTITLEPRINT")
		{
			s itemVal = ..IsTitlePrint(objInstance.Title, printDocID)
		}
		elseif (InstanceDataItem="AUTHORSIGN") 
		{
			if ""'=##Class(EPRservice.BLDigitalSignature).CheckValidSign(episodeID,printDocID,objInstance.ListNo)
		 	{
			 	s itemVal = ..GetMultiUser(episodeID,printDocID,objInstance.ListNo,objInstance.CreateUser)
		 	}
		}		
		elseif (InstanceDataItem="AUTHORIMG")
		{
			if ""'=##Class(EPRservice.BLDigitalSignature).CheckValidSign(episodeID,printDocID,objInstance.ListNo)
		 	{
			 	s itemVal=##Class(EPRservice.BLDigitalSignature).GetCreaterImage(episodeID,printDocID,objInstance.ListNo)
		 	}
		}
		elseif (InstanceDataItem="CHECKSIGN") 
		{
			if ""'=##Class(EPRservice.BLDigitalSignature).CheckValidSign(episodeID,printDocID,objInstance.ListNo)
		 	{
			 	s chkInfo = ..GetCheckInfo(episodeID,printDocID,objInstance.ListNo)
			    s itemVal = $p(chkInfo,"^",1)
		 	}
		}		
		elseif (InstanceDataItem="CHECKUSERIMG")
		{
			if ""'=##Class(EPRservice.BLDigitalSignature).CheckValidSign(episodeID,printDocID,objInstance.ListNo)
		 	{
			 	s itemVal=##Class(EPRservice.BLDigitalSignature).GetSuperiorImage(episodeID,printDocID,objInstance.ListNo)		
		 	}
		}
		elseif (InstanceDataItem="LASTSIGNIMG")
		{
			s itemVal=##Class(EPRservice.BLDigitalSignature).GetSignatureImage(episodeID,printDocID,objInstance.ListNo)
		}		
		elseif (InstanceDataItem="AUTHORSIGNDATE")
		{
			s itemVal=##Class(EPRservice.BLDigitalSignature).GetCreaterSignedDateTime(episodeID,printDocID,objInstance.ListNo)
		}
		elseif (InstanceDataItem="CHECKSIGNDATE")
		{
			s itemVal=##Class(EPRservice.BLDigitalSignature).GetCheckerSignedDateTime(episodeID,printDocID,objInstance.ListNo)		
		}	
		elseif (InstanceDataItem="ATTENDINGSIGN")
		{
			if ""'=##Class(EPRservice.BLDigitalSignature).CheckValidSign(episodeID,printDocID,objInstance.ListNo)
		 	{
			 	s itemVal = ##Class(EPRservice.BOEPRLogs).GetUserNameByAction(episodeID,printDocID,objInstance.ListNo,"attendingCheck")
		 	}
		}
		elseif (InstanceDataItem="CHIEFSIGN")
		{
			if ""'=##Class(EPRservice.BLDigitalSignature).CheckValidSign(episodeID,printDocID,objInstance.ListNo)
		 	{
			 	s itemVal = ##Class(EPRservice.BOEPRLogs).GetUserNameByAction(episodeID,printDocID,objInstance.ListNo,"chiefCheck")
		 	}
		}
		elseif (InstanceDataItem="ATTENDINGSIGNIMG")
		{
			if ""'=##Class(EPRservice.BLDigitalSignature).CheckValidSign(episodeID,printDocID,objInstance.ListNo)
		 	{
			 	s UsrID = ##Class(EPRservice.BOEPRLogs).GetUserIDByAction(episodeID,printDocID,objInstance.ListNo,"attendingCheck")
		 	    s itemVal = ##Class(EPRservice.BLDigitalSignature).GetUserSignImage(UsrID)
		 	}
		}
		elseif (InstanceDataItem="CHIEFSIGNIMG")
		{
			if ""'=##Class(EPRservice.BLDigitalSignature).CheckValidSign(episodeID,printDocID,objInstance.ListNo)
		 	{
			 	s UsrID = ##Class(EPRservice.BOEPRLogs).GetUserIDByAction(episodeID,printDocID,objInstance.ListNo,"chiefCheck")
		 	    s itemVal = ##Class(EPRservice.BLDigitalSignature).GetUserSignImage(UsrID)
		 	}
		}
		elseif (InstanceDataItem="COMMITTERIMG")
		{
			if ""'=##Class(EPRservice.BLDigitalSignature).CheckValidSign(episodeID,printDocID,objInstance.ListNo)
		 	{
			 	s UsrID = ##Class(EPRservice.BOEPRLogs).GetUserIDByAction(episodeID,printDocID,objInstance.ListNo,"commit")
		 	    s itemVal = ##Class(EPRservice.BLDigitalSignature).GetUserSignImage(UsrID)
		 	}
		}
		elseif (InstanceDataItem="COMMITTER")
		{
			if ""'=##Class(EPRservice.BLDigitalSignature).CheckValidSign(episodeID,printDocID,objInstance.ListNo)
		 	{
			 	s itemVal = ##Class(EPRservice.BOEPRLogs).GetUserNameByAction(episodeID,printDocID,objInstance.ListNo,"commit")
		 	}
		}						
		elseif (InstanceDataItem="EDITORSIGN")
		{
			s itemVal = ""
			if ""'=##Class(EPRservice.BLDigitalSignature).CheckValidSign(episodeID,printDocID,objInstance.ListNo)
		 	{
			 	s ret = ##Class(EPRservice.BOEPRLogs).GetUserByAction(episodeID,printDocID,objInstance.ListNo,"save^complete")
		     	s retCount = $L(ret, "/")
	         	for iRet = 1:1:retCount
	        	 {
		     	    if (""=itemVal) { s itemVal = $P(ret, "/", iRet) }
		     	    else { s itemVal = $P(ret, "/", iRet)_"/"_itemVal }
	         	}
		 	}
		}		
		elseif (InstanceDataItem="COMMITTERDATE")
		{
			s itemVal = ##Class(EPRservice.BOEPRLogs).GetOperTimeByAction(episodeID,printDocID,objInstance.ListNo,"commit")
		}	
		elseif (InstanceDataItem="COMMITTERLEVEL")
		{
			s UsrID = ##Class(EPRservice.BOEPRLogs).GetUserIDByAction(episodeID,printDocID,objInstance.ListNo,"commit")
			if (UsrID '= "")
			{
				s itemVal = ..GetUserLevel(UsrID)
			}
		}
		elseif(InstanceDataItem="ANYSIGN1IMG")
		{
			s eprNum = $p(parInstanceId,"||",2)
			if (eprNum'="")
			{	
				s objAnySignLog = ##class(EPRinstance.AnySignLog).getValidSign(episodeID, printDocID, eprNum, 1)
				if (objAnySignLog '= "")
				{
					s itemVal = objAnySignLog.SignScript.Read(32000)
				}
			}
		}
		elseif(InstanceDataItem="FINGPRT1IMG")
		{
			s eprNum = $p(parInstanceId,"||",2)
			if (eprNum'="")
			{	
				s objAnySignLog = ##class(EPRinstance.AnySignLog).getValidSign(episodeID, printDocID, eprNum, 1)
				if (objAnySignLog '= "")
				{
					s itemVal = objAnySignLog.FingerPrint.Read(32000)
				}
			}
		}
		elseif(InstanceDataItem="ANYSIGN2IMG")
		{
			s eprNum = $p(parInstanceId,"||",2)
			if (eprNum'="")
			{	
				s objAnySignLog = ##class(EPRinstance.AnySignLog).getValidSign(episodeID, printDocID, eprNum, 2)
				if (objAnySignLog '= "")
				{
					s itemVal = objAnySignLog.SignScript.Read(32000)
				}
			}
		}
		elseif(InstanceDataItem="FINGPRT2IMG")
		{
			s eprNum = $p(parInstanceId,"||",2)
			if (eprNum'="")
			{	
				s objAnySignLog = ##class(EPRinstance.AnySignLog).getValidSign(episodeID, printDocID, eprNum, 2)
				if (objAnySignLog '= "")
				{
					s itemVal = objAnySignLog.FingerPrint.Read(32000)
				}
			}
		}
		elseif(InstanceDataItem="ANYSIGN3IMG")
		{
			s eprNum = $p(parInstanceId,"||",2)
			if (eprNum'="")
			{	
				s objAnySignLog = ##class(EPRinstance.AnySignLog).getValidSign(episodeID, printDocID, eprNum, 3)
				if (objAnySignLog '= "")
				{
					s itemVal = objAnySignLog.SignScript.Read(32000)
				}
			}
		}
		elseif(InstanceDataItem="FINGPRT3IMG")
		{
			s eprNum = $p(parInstanceId,"||",2)
			if (eprNum'="")
			{	
				s objAnySignLog = ##class(EPRinstance.AnySignLog).getValidSign(episodeID, printDocID, eprNum, 3)
				if (objAnySignLog '= "")
				{
					s itemVal = objAnySignLog.FingerPrint.Read(32000)
				}
			}
		}
		elseif(InstanceDataItem="ANYSIGN4IMG")
		{
			s eprNum = $p(parInstanceId,"||",2)
			if (eprNum'="")
			{	
				s objAnySignLog = ##class(EPRinstance.AnySignLog).getValidSign(episodeID, printDocID, eprNum, 4)
				if (objAnySignLog '= "")
				{
					s itemVal = objAnySignLog.SignScript.Read(32000)
				}
			}
		}
		elseif(InstanceDataItem="FINGPRT4IMG")
		{
			s eprNum = $p(parInstanceId,"||",2)
			if (eprNum'="")
			{	
				s objAnySignLog = ##class(EPRinstance.AnySignLog).getValidSign(episodeID, printDocID, eprNum, 4)
				if (objAnySignLog '= "")
				{
					s itemVal = objAnySignLog.FingerPrint.Read(32000)
				}
			}
		}
		elseif(InstanceDataItem="ANYSIGN5IMG")
		{
			s eprNum = $p(parInstanceId,"||",2)
			if (eprNum'="")
			{	
				s objAnySignLog = ##class(EPRinstance.AnySignLog).getValidSign(episodeID, printDocID, eprNum, 5)
				if (objAnySignLog '= "")
				{
					s itemVal = objAnySignLog.SignScript.Read(32000)
				}
			}
		}
		elseif(InstanceDataItem="FINGPRT5IMG")
		{
			s eprNum = $p(parInstanceId,"||",2)
			if (eprNum'="")
			{	
				s objAnySignLog = ##class(EPRinstance.AnySignLog).getValidSign(episodeID, printDocID, eprNum, 5)
				if (objAnySignLog '= "")
				{
					s itemVal = objAnySignLog.FingerPrint.Read(32000)
				}
			}
		}
		elseif(InstanceDataItem="ANYSIGN6IMG")
		{
			s eprNum = $p(parInstanceId,"||",2)
			if (eprNum'="")
			{	
				s objAnySignLog = ##class(EPRinstance.AnySignLog).getValidSign(episodeID, printDocID, eprNum, 6)
				if (objAnySignLog '= "")
				{
					s itemVal = objAnySignLog.SignScript.Read(32000)
				}
			}
		}
		elseif(InstanceDataItem="FINGPRT6IMG")
		{
			s eprNum = $p(parInstanceId,"||",2)
			if (eprNum'="")
			{	
				s objAnySignLog = ##class(EPRinstance.AnySignLog).getValidSign(episodeID, printDocID, eprNum, 6)
				if (objAnySignLog '= "")
				{
					s itemVal = objAnySignLog.FingerPrint.Read(32000)
				}
			}
		}
						
		s:(itemVal = "") itemVal = "*NULL"
		//s ReInsStr = ReInsStr_itemVal_","
		if (I > 1) 
	 	{	d AReStream.Write(",")}
	 	
	 	d AReStream.Write(itemVal)
	} 
	
	//s ReInsStr = $e(ReInsStr,1,$L(ReInsStr)-1)_"}"
	d AReStream.Write("}")
	
	q ""
}

ClassMethod GetUserLevel(UsrID As %String) As %String
{
	s level = ##class(EPRmeta.Privilege.PowerUser).GetUserLevel(userID)
	q:(level="") ""
	
	s levleDEsc = ##Class(EPRmeta.UserLevel).GetLevelDesc(level)
	q levleDEsc
}

/// 	Desc:	转换日期格式
/// 	Input:	AItemData  日期，格式为：2009-1-22 12:32:40
/// 			AValueType 格式，枚举值：YMD,YM,MD,HMS,HM
ClassMethod ConvertDateTime(AItemData As %String, AValueType As %String) As %String
{
}

/// 	Desc:	转换日期格式
/// 	Input:	AItemData  日期，格式为：2009-1-22
/// 			AValueType 格式，枚举值：YMD,YM,MD,V,YMD2,YM2,MD2
ClassMethod ConvertDate(AItemData As %String, AValueType As %String) As %String
{
	q:(AItemData = "")||(AValueType = "") AItemData
	
	if (AValueType = "YMD") 
	{
		q AItemData
	}
	elseif (AValueType = "YM") 
	{
		s year = $P(AItemData, "-", 1)
		s month = $P(AItemData, "-",2)
		q year_"-"_month
	}
	elseif (AValueType = "MD")
	{
		s month = $P(AItemData, "-",2)
		s day = $P(AItemData, "-",3)
		q month_"-"_day
	}
	elseif (AValueType = "V")
	{
		s year = $P(AItemData,"-",1)
		s month = $P(AItemData,"-",2)
		s day = $P(AItemData,"-",3)
		q year_"年"_month_"月"_day_"日"
	}
	elseif (AValueType = "YMD2") 
	{
		q $tr(AItemData,"-",".")
	}
	elseif (AValueType = "YM2") 
	{
		s year = $P(AItemData, "-", 1)
		s month = $P(AItemData, "-",2)
		q year_"."_month
	}
	elseif (AValueType = "MD2") 
	{
		s month = $P(AItemData, "-",2)
		s day = $P(AItemData, "-",3)
		q month_"."_day
	}
	
	q AItemData
}

/// 	Desc:	转换时间格式
/// 	Input:	AItemData  时间，格式为：12:32:40
/// 			AValueType 格式，枚举值：HMS,HM
ClassMethod ConvertTime(AItemData As %String, AValueType As %String) As %String
{
	q:(AItemData = "")||(AValueType = "") AItemData
	
	if (AValueType = "HMS")
	{
		q AItemData
	}
	elseif (AValueType = "HM")
	{
		s hour = $P(AItemData, ":", 1)
		s minute = $P(AItemData, ":", 2)
		q hour_":"_minute
	}
	
	q AItemData
}

/// Desc:获取系统数据
ClassMethod GetSysData(uniqueEPRGlobalID As %String, AHeadStr As %String, ASystemDataStr As %String, ByRef AReStream As %Stream) As %String
{
	//查询串$SystemData{}表示不获取任何系统数据
 	//13为$SystemData{}的长度
 	if ($L(ASystemDataStr)=13) 
 	{
	 	d AReStream.Write("$SystemData{}")
	 	q ""
 	}
 	//s Result ="$SystemData{"
 	d AReStream.Write("$SystemData{")
 	
 	s itemStr = $P(ASystemDataStr,"$SystemData{",2)
 	s itemStr = $E(itemStr,1,$L(itemStr)-1)
 	s itemCount = $L(itemStr,",")
 	s episodeID = $P($P(AHeadStr,",",2),":",2)
 	s printDocID = $P($P(AHeadStr,",",4),":",2)
 	s eprNum = "1"
 	for i = 1:1:itemCount 
 	{
	 	s itemVal = "*NULL"
	 	s tmpitem = $P(itemStr,",",i)
	 	s item = $P(tmpitem,"|",1)
	 	s valueType = $P(tmpitem,"|",2) 
	 	if (item="DATE") 
	 	{
	 		s itemVal = $zd($h,3)
	 		if (valueType '= "")
	 		{	s itemVal = ..ConvertDate(itemVal, valueType)}
	 	}
	 	elseif (item="TIME") 
	 	{	
	 		s itemVal = $zt($p($h,",",2),1)
	 		if (valueType '= "")
	 		{	s itemVal = ..ConvertTime(itemVal, valueType)}
	 	}
	 	elseif (item="SAUTHOR") 
	 	{	
	 		s itemVal = ..GetSingleUser(episodeID,printDocID,eprNum)
	 	}
	 	elseif (item="SCHECKUSER")
	 	{
		 	s chkInfo = ..GetCheckInfo(episodeID,printDocID,eprNum)
		 	s itemVal = $p(chkInfo,"^",1)
	 	}
	 	elseif (item="SCHECKDATE")
	 	{
		 	s chkInfo = ..GetCheckInfo(episodeID,printDocID,eprNum)
		 	s itemVal = $p(chkInfo,"^",2)
		 	if (valueType '= "")
		 	{	s itemVal = ..ConvertDate(itemVal, valueType)}
		}
	 	elseif (item="SCHECKLEVEL")
	 	{
		 	s chkInfo = ..GetCheckInfo(episodeID,printDocID,eprNum)
		 	s itemVal = $p(chkInfo,"^",3)
	 	}
	 	elseif (item="SCOMMITUSER")
	 	{
		 	s itemVal = ..GetCommitUser(episodeID,printDocID,eprNum)
	 	}
	 	elseif (item="SCOMMITDATE")
	 	{
		 	s itemVal = ..GetCommitDateTime(episodeID,printDocID,eprNum)
		 	s itemVal = $p(itemVal,"^",1)
		 	if (itemVal '= "") {set itemVal = $zd(itemVal,3)}
		 	if (valueType '= "")
		 	{	s itemVal = ..ConvertDate(itemVal, valueType)}
		}
	 	elseif (item="SAUTHORIMG")
	 	{
		 	if ""'=##Class(EPRservice.BLDigitalSignature).CheckValidSign(episodeID,printDocID,eprNum)
		 	{
			 	s itemVal = ##Class(EPRservice.BLDigitalSignature).GetCreaterImage(episodeID,printDocID,eprNum)
			} 	
		}
		elseif (item="SAUTHORSIGN")
		{
			if ""'=##Class(EPRservice.BLDigitalSignature).CheckValidSign(episodeID,printDocID,eprNum)
		 	{
			 	s itemVal = ..GetSingleUser(episodeID,printDocID,eprNum)
		 	}
		}
		elseif (item="SCHECKSIGN")
		{
			if ""'=##Class(EPRservice.BLDigitalSignature).CheckValidSign(episodeID,printDocID,eprNum)
		 	{
			 	s chkInfo = ..GetCheckInfo(episodeID,printDocID,eprNum)
		 	    s itemVal = $p(chkInfo,"^",1)
		 	}
		}				
		elseif (item="SCHECKUSERIMG")
		{
			if ""'=##Class(EPRservice.BLDigitalSignature).CheckValidSign(episodeID,printDocID,eprNum)
		 	{
			 	s itemVal = ##Class(EPRservice.BLDigitalSignature).GetSuperiorImage(episodeID,printDocID,eprNum)		
		 	}
		}
		elseif (item="SLASTSIGNIMG")
		{
			s itemVal=##Class(EPRservice.BLDigitalSignature).GetSignatureImage(episodeID,printDocID,eprNum)	
		}		
		elseif (item="SCHAIRMAN")
		{
			if ""'=##Class(EPRservice.BLDigitalSignature).CheckValidSign(episodeID,printDocID,eprNum)
		 	{
			 	s itemVal = ##Class(EPRservice.BOEPRLogs).GetUserNameByAction(episodeID,printDocID,eprNum,"ChairmanCheck")
		 	}
		}
		elseif (item="SQCDOC")
		{
			if ""'=##Class(EPRservice.BLDigitalSignature).CheckValidSign(episodeID,printDocID,eprNum)
		 	{
			 	s itemVal = ##Class(EPRservice.BOEPRLogs).GetUserNameByAction(episodeID,printDocID,eprNum,"QCDocCheck")
		 	}
		}
		elseif (item="SQCNURSE")
		{
			if ""'=##Class(EPRservice.BLDigitalSignature).CheckValidSign(episodeID,printDocID,eprNum)
		 	{
			 	s itemVal = ##Class(EPRservice.BOEPRLogs).GetUserNameByAction(episodeID,printDocID,eprNum,"QCNurseCheck")
		 	}
		} 
		elseif (item="SCHARGENURSE")
		{
			if ""'=##Class(EPRservice.BLDigitalSignature).CheckValidSign(episodeID,printDocID,eprNum)
		 	{
			 	s itemVal = ##Class(EPRservice.BOEPRLogs).GetUserNameByAction(episodeID,printDocID,eprNum,"ChargeNurseCheck")
		 	}
		} 		
		elseif (item="SAUTHORSIGNDATE")
		{
			s itemVal = ##Class(EPRservice.BLDigitalSignature).GetCreaterSignedDateTime(episodeID,printDocID,eprNum)
		    //if (valueType '= "")
		 	//{	s itemVal = ..ConvertDate(itemVal, valueType) }
		}
		elseif (item="SCHECKSIGNDATE")
		{
			s itemVal = ##Class(EPRservice.BLDigitalSignature).GetCheckerSignedDateTime(episodeID,printDocID,eprNum)
		}
		elseif (item="SATTENDINGSIGN")
		{
			if ""'=##Class(EPRservice.BLDigitalSignature).CheckValidSign(episodeID,printDocID,eprNum)
		 	{
			 	s itemVal = ##Class(EPRservice.BOEPRLogs).GetUserNameByAction(episodeID,printDocID,eprNum,"attendingCheck")
			}
		}
		elseif (item="SCHIEFSIGN")
		{
			if ""'=##Class(EPRservice.BLDigitalSignature).CheckValidSign(episodeID,printDocID,eprNum)
		 	{
			 	s itemVal = ##Class(EPRservice.BOEPRLogs).GetUserNameByAction(episodeID,printDocID,eprNum,"chiefCheck")
		 	}		 	
		}
		elseif (item="SCOMMITTER")
		{
			if ""'=##Class(EPRservice.BLDigitalSignature).CheckValidSign(episodeID,printDocID,eprNum)
		 	{
			 	s itemVal = ##Class(EPRservice.BOEPRLogs).GetUserNameByAction(episodeID,printDocID,eprNum,"commit")
		 	}		 	
		}					
		elseif (item="SATTENDINGSIGNIMG")
		{
			if ""'=##Class(EPRservice.BLDigitalSignature).CheckValidSign(episodeID,printDocID,eprNum)
		 	{
			 	s UsrID = ##Class(EPRservice.BOEPRLogs).GetUserIDByAction(episodeID,printDocID,eprNum,"attendingCheck")
		 	    s itemVal = ##Class(EPRservice.BLDigitalSignature).GetUserSignImage(UsrID)
		 	}
		}
		elseif (item="SCHIEFSIGNIMG")
		{
			if ""'=##Class(EPRservice.BLDigitalSignature).CheckValidSign(episodeID,printDocID,eprNum)
		 	{
			 	s UsrID = ##Class(EPRservice.BOEPRLogs).GetUserIDByAction(episodeID,printDocID,eprNum,"chiefCheck")
		 	    s itemVal = ##Class(EPRservice.BLDigitalSignature).GetUserSignImage(UsrID)
		 	}
		}
		elseif (item="SCOMMITTERIMG")
		{
			if ""'=##Class(EPRservice.BLDigitalSignature).CheckValidSign(episodeID,printDocID,eprNum)
		 	{
			 	s UsrID = ##Class(EPRservice.BOEPRLogs).GetUserIDByAction(episodeID,printDocID,eprNum,"commit")
		 	    s itemVal = ##Class(EPRservice.BLDigitalSignature).GetUserSignImage(UsrID)
		 	}
		}	
		
		elseif (item="SCHAIRMANIMG")
		{
			if ""'=##Class(EPRservice.BLDigitalSignature).CheckValidSign(episodeID,printDocID,eprNum)
		 	{
			 	s UsrID = ##Class(EPRservice.BOEPRLogs).GetUserIDByAction(episodeID,printDocID,eprNum,"ChairmanCheck")
			 	s itemVal = ##Class(EPRservice.BLDigitalSignature).GetUserSignImage(UsrID)
		 	}
		}
		elseif (item="SQCDOCIMG")
		{
			if ""'=##Class(EPRservice.BLDigitalSignature).CheckValidSign(episodeID,printDocID,eprNum)
		 	{
			 	s UsrID = ##Class(EPRservice.BOEPRLogs).GetUserIDByAction(episodeID,printDocID,eprNum,"QCDocCheck")
			 	s itemVal = ##Class(EPRservice.BLDigitalSignature).GetUserSignImage(UsrID)
		 	}
		}
		elseif (item="SQCNURSEIMG")
		{
			if ""'=##Class(EPRservice.BLDigitalSignature).CheckValidSign(episodeID,printDocID,eprNum)
		 	{
			 	s UsrID = ##Class(EPRservice.BOEPRLogs).GetUserIDByAction(episodeID,printDocID,eprNum,"QCNurseCheck")
			 	s itemVal = ##Class(EPRservice.BLDigitalSignature).GetUserSignImage(UsrID)
		 	}
		} 
		elseif (item="SCHARGENURSEIMG")
		{
			if ""'=##Class(EPRservice.BLDigitalSignature).CheckValidSign(episodeID,printDocID,eprNum)
		 	{
			 	s UsrID = ##Class(EPRservice.BOEPRLogs).GetUserIDByAction(episodeID,printDocID,eprNum,"ChargeNurseCheck")
			 	s itemVal = ##Class(EPRservice.BLDigitalSignature).GetUserSignImage(UsrID)
		 	}
		} 		
		elseif (item="SCOMMITTERDATE")
		{
			s itemVal = ##Class(EPRservice.BOEPRLogs).GetOperTimeByAction(episodeID,printDocID,eprNum,"commit")
		}						
		elseif (item="SCOMMITTERLEVEL")
		{
			s UsrID = ##Class(EPRservice.BOEPRLogs).GetUserIDByAction(episodeID,printDocID,eprNum,"commit")
			if (UsrID '= "")
			{
				s itemVal = ..GetUserLevel(UsrID)
			}
		}
		elseif(item="SANYSIGN1IMG")
		{
			s objAnySignLog = ##class(EPRinstance.AnySignLog).getValidSign(episodeID, printDocID, eprNum, 1)
			if (objAnySignLog '= "")
			{
				s itemVal = objAnySignLog.SignScript.Read(32000)
			}
		}
		elseif(item="SFINGPRT1IMG")
		{
			s objAnySignLog = ##class(EPRinstance.AnySignLog).getValidSign(episodeID, printDocID, eprNum, 1)
			if (objAnySignLog '= "")
			{
				s itemVal = objAnySignLog.FingerPrint.Read(32000)
			}
		}
		elseif(item="SANYSIGN2IMG")
		{
			s objAnySignLog = ##class(EPRinstance.AnySignLog).getValidSign(episodeID, printDocID, eprNum, 2)
			if (objAnySignLog '= "")
			{
				s itemVal = objAnySignLog.SignScript.Read(32000)
			}
		}
		elseif(item="SFINGPRT2IMG")
		{
			s objAnySignLog = ##class(EPRinstance.AnySignLog).getValidSign(episodeID, printDocID, eprNum, 2)
			if (objAnySignLog '= "")
			{
				s itemVal = objAnySignLog.FingerPrint.Read(32000)
			}
		}
		elseif(item="SANYSIGN3IMG")
		{
			s objAnySignLog = ##class(EPRinstance.AnySignLog).getValidSign(episodeID, printDocID, eprNum, 3)
			if (objAnySignLog '= "")
			{
				s itemVal = objAnySignLog.SignScript.Read(32000)
			}
		}
		elseif(item="SFINGPRT3IMG")
		{
			s objAnySignLog = ##class(EPRinstance.AnySignLog).getValidSign(episodeID, printDocID, eprNum, 3)
			if (objAnySignLog '= "")
			{
				s itemVal = objAnySignLog.FingerPrint.Read(32000)
			}
		}
		elseif(item="SANYSIGN4IMG")
		{
			s objAnySignLog = ##class(EPRinstance.AnySignLog).getValidSign(episodeID, printDocID, eprNum, 4)
			if (objAnySignLog '= "")
			{
				s itemVal = objAnySignLog.SignScript.Read(32000)
			}
		}
		elseif(item="SFINGPRT4IMG")
		{
			s objAnySignLog = ##class(EPRinstance.AnySignLog).getValidSign(episodeID, printDocID, eprNum, 4)
			if (objAnySignLog '= "")
			{
				s itemVal = objAnySignLog.FingerPrint.Read(32000)
			}
		}
		elseif(item="SANYSIGN5IMG")
		{
			s objAnySignLog = ##class(EPRinstance.AnySignLog).getValidSign(episodeID, printDocID, eprNum, 5)
			if (objAnySignLog '= "")
			{
				s itemVal = objAnySignLog.SignScript.Read(32000)
			}
		}
		elseif(item="SFINGPRT5IMG")
		{
			s objAnySignLog = ##class(EPRinstance.AnySignLog).getValidSign(episodeID, printDocID, eprNum, 5)
			if (objAnySignLog '= "")
			{
				s itemVal = objAnySignLog.FingerPrint.Read(32000)
			}
		}
		elseif(item="SANYSIGN6IMG")
		{
			s objAnySignLog = ##class(EPRinstance.AnySignLog).getValidSign(episodeID, printDocID, eprNum, 6)
			if (objAnySignLog '= "")
			{
				s itemVal = objAnySignLog.SignScript.Read(32000)
			}
		}
		elseif(item="SFINGPRT6IMG")
		{
			s objAnySignLog = ##class(EPRinstance.AnySignLog).getValidSign(episodeID, printDocID, eprNum, 6)
			if (objAnySignLog '= "")
			{
				s itemVal = objAnySignLog.FingerPrint.Read(32000)
			}
		}
		
		s:(itemVal="") itemVal= "*NULL"
	 	//s Result = Result_itemVal_","
	 	if (i > 1) 
	 	{	d AReStream.Write(",")}
	 	
	 	d AReStream.Write(itemVal)
 	}
 
 	d AReStream.Write("}")
 	//s Result = $e(Result,1,$L(Result)-1)_"}"
 	//q Result
 	
 	q ""
}

/// Desc:	病历提交者姓名
ClassMethod GetCommitUser(AEpisodeID, APrintDocID, AEPRNum) As %String
{
	s eprLogs = ##class(EPRinstance.EPRLogs).GetCurrLog(AEpisodeID,APrintDocID,AEPRNum)
	q:(eprLogs="") ""
	
	s instanceLog = eprLogs.GetFirstLogByAction("commit")
	q:(instanceLog="") ""
	
	q instanceLog.OperateUserName
}

/// Desc:	病历提交日期时间
ClassMethod GetCommitDateTime(AEpisodeID, APrintDocID, AEPRNum) As %String
{
	s eprLogs = ##class(EPRinstance.EPRLogs).GetCurrLog(AEpisodeID,APrintDocID,AEPRNum)
	q:(eprLogs="") ""
	
	s instanceLog = eprLogs.GetFirstLogByAction("commit")
	q:(instanceLog="") ""
	
	q instanceLog.OperateDate_","_instanceLog.OperateTime
}

/// Author: 	Zuoxiang Xie
/// Create: 	2010-11-11
/// Desc: 		获取上级医师审核信息，包括审核人，审核时间以及审核人职称
/// Debug:		w ##Class(EPRservice.BODataGateway).GetCheckInfo("","","")
ClassMethod GetCheckInfo(argEpisodeID, argPrintDocID, argEPRNum) As %String
{
	s chkUser = "*NULL", chkDate = "*NULL", chkLevel = "*NULL"
	s chkInfo = chkUser_"^"_chkDate_"^"_chkLevel
	s LogID = $o(^DHCEPRI.EPRLogsI("IdxMain"," "_argEpisodeID," "_argPrintDocID,argEPRNum,""))
	q:(LogID="") chkInfo
	
	s flag = 0
	s objEPRLogs = ##Class(EPRinstance.EPRLogs).%OpenId(LogID)
	s objInstanceLog = objEPRLogs.GetFirstLogByAction("chiefCheck")			//主任医师审核
	if (objInstanceLog = "")
	{
		s flag = 1
		s objInstanceLog = objEPRLogs.GetFirstLogByAction("attendingCheck")	//主治医师审核
	}
	
	if objInstanceLog '=""
	{
		s chkUser = objInstanceLog.OperateUserName
		s chkDate = $zd(objInstanceLog.OperateDate,3)
		//s chkLevel = $s(flag=0:"主任医师",1:"主治医师")
		s chkLevelDesc=""
		s chkUser=objInstanceLog.OperateUserID
		s chkLevel = ##class(EPRmeta.Privilege.PowerUser).GetUserLevel(chkUser)		
	    s id=$o(^DHCEPRM.UserLevelI("NameIndex", " "_$zcvt(chkLevel,"U"), ""))
	    if (""'=id)
	    {
		    s UserLevel=##Class(EPRmeta.UserLevel).%OpenId(id)
		    s chkLevelDesc=UserLevel.Description
		    d UserLevel.%Close()
	    }	
		
		s chkInfo = chkUser_"^"_chkDate_"^"_chkLevelDesc
	}
	
	d objEPRLogs.%Close()
	k objEPRLogs
	
	q chkInfo
}

/// Desc:	可重复病历标题是否打印
/// Input:	ATitle : 病历标题
/// 		APrintDocID	：打印模板DocID
/// Output：无
/// Return：1 打印，0 不打印
ClassMethod IsTitlePrint(ATitle As %String, APrintDocID As %String) As %Boolean
{
	s isPrint = "1"
	
	s objEPRTplCategory = ##Class(EPRmeta.EPRTemplateCategory).%OpenId(APrintDocID)
	quit:(objEPRTplCategory = "") isPrint
	quit:(objEPRTplCategory.BindPrnTemplateID = "") isPrint
	s printTemplateID = objEPRTplCategory.BindPrnTemplateID
	
	s unprintTitles = ##Class(EPRservice.BLL.BLCustomDictory).GetUnprintTitle(printTemplateID)
	q:(unprintTitles = "") isPrint
	
	s titleCount = $Length(unprintTitles, "^")
	for i = 1:1:titleCount
	{
		s unprintTitle = $P(unprintTitles, "^", i)
		if (unprintTitle = ATitle)
		{
			s isPrint = "0"
			q
		}
	}
	
	q isPrint
}

/// Desc: 唯一病历作者，只支持新框架
ClassMethod GetSingleUser(argEpisodeID, argPrintDocID, argEPRNum) As %String
{
	s user = ""
	s printDetailOper = ##class(EPRmeta.SysOption).GetOptionValueByName("PrintDetailOper")
	if printDetailOper = "Y"
	{
		s user = ##class(EPRservice.BOEPRLogs).GetUserByAction(argEpisodeID,argPrintDocID,argEPRNum,"save^complete")	
		q:(user="") "*NULL"
	}
	else
	{
		s userId = ##class(EPRinstance.EPRLogs).GetCreateUserID(argEpisodeID,argPrintDocID,argEPRNum)
		q:(userId="") "*NULL"
		s user = $P($G(^SSU("SSUSR",userId)),"^",2)
	}
	
	s user = $tr(user,$c(10),"")
	s user = $tr(user,$c(13),"")
	s:(user = "") user = "*NULL"
	q user
}

/// Desc: 可重复病历作者
ClassMethod GetMultiUser(argEpiosdeID, argPrintDocID, argEPRNum, argUserID)
{
	s oldCount = ##class(EPRinstance.ECRecord).GetOldRecCount(argEpiosdeID)
	s printDetailOper = ##class(EPRmeta.SysOption).GetOptionValueByName("PrintDetailOper")
	if (printDetailOper = "Y")&&(oldCount<=0)
	{
		//新框架支持打印详细操作者
		s user = ##class(EPRservice.BOEPRLogs).GetUserByAction(argEpiosdeID,argPrintDocID,argEPRNum,"save^complete")
	}
	else
	{
		q:(argUserID="") "*NULL"
		s user = $P($G(^SSU("SSUSR",argUserID)),"^",2)
	}
	
	s user = $tr(user,$c(10),"")
	s user = $tr(user,$c(13),"")
	s:(user = "") user = "*NULL"
	q user
}

ClassMethod CheckConfidenceLevel(ACode As %String, ACodeType As %String) As %String
{
	
	s ret = ##class(DHCEPRRBAC.BL.BLResourceElement).GetElementLevel(ACode,ACodeType)
	s:(ret = $c(0)) ret = ""
	q ret
}

ClassMethod ReplacePrivacyInfo(ATemplateID As %String, AItemCode As %String, ATypeCode As %String, AValueString As %String, APrivacyLevel) As %String
{
    s glossaryID = ""
    s glossaryID = ##class(EPRmeta.GlossaryItem).GetGlossayID(ATemplateID,AItemCode,ATypeCode)
    q:((glossaryID = "") || (glossaryID = $c(0))) "0"

    s obj = ##class(EPRmeta.Glossary).%OpenId(glossaryID)
    s internalID = obj.InternalID
    
    s confidenceLevels = ..CheckConfidenceLevel(internalID,ATypeCode)

    if (confidenceLevels '= "")
    {
	    s flag = "false"
	    for index=1:1:$l(confidenceLevels,"^")
	    {
			s confidenceLevel = $p(confidenceLevels,"^",index)
			if ((+confidenceLevel) = (+APrivacyLevel)) 
			{
				s flag = "true"	
				q
			}
			
		}
		
		if (flag = "true")
    	{
	    	s length = $l(AValueString)
	    	if (length = 1)
	    	{
	    		q "*"
			}
	    	elseif (length = 2)
	    	{
				 q "**"   
			}
			else
			{
				q "***"  
			}
    	}
    }
    q "0"
}

/// Desc: 获取简单单元的数据
/// 
/// ModifyDate:	2009-02-17
/// ModifyUser:	HouJian
/// Reason:		为D单元添加取值格式
/// 				YMDHM	代表 YYYY-MM-DD HH:MM
/// 				MDHM	代表 MM-DD HH:MM
/// 				HMS		代表 HH:MM:SS
/// 				HM		代表 HH:MM
/// 				
/// ModifyDate: 2009-12-07
/// ModifyUser: houj
/// Reason: 	转换空日期和空时间，使得日期时间有某项为空时，可以返回正确的值
/// ModifyBy Candyxu 20120530 将数据转换移动到GetSimpleData方法中
/// [Previously private]
ClassMethod GetISimpleValue(ASimpleId As %String, PiCodeType As %String, PiTypeCode As %String, ATemplateID As %String, AItemCode As %String, APrivacyLevel As %String = "") As %String
{
	
    s ReturnDataValue =""
    set objISimple = ##class(EPRinstance.ISimple).%OpenId(ASimpleId)
    quit:(objISimple="") "*NULL"
    s ReturnDataValue = ..GetSimpleData(objISimple.DataValue,objISimple.ValueCode,PiCodeType,	PiTypeCode)
    
    if (APrivacyLevel '= "")
    {
		s ret = ..ReplacePrivacyInfo(ATemplateID,AItemCode,PiTypeCode,ReturnDataValue,APrivacyLevel)
		s:(ret '= "0") ReturnDataValue = ret
    }
    q ReturnDataValue
}

/// Desc: 获取表格单元数据
/// [Previously private]
ClassMethod GetTableSimpleValue(ASimpleId As %String, PiCodeType As %String, PiValueCode As %String, ByRef ReturnDataValue As %String, ByRef ReturnRowNumber As %String)
{
	s ReturnDataValue=""
	s ReturnRowNumber=""
	
 	set objITableSimple = ##class(EPRinstance.ITableSimple).%OpenId(ASimpleId)
 
 	quit:(objITableSimple="") 
 	
 	set ReturnRowNumber = objITableSimple.RowNumber
 	
 	if (PiCodeType="S")||(PiCodeType="N")||(PiCodeType="O")||(PiCodeType="M")||(PiCodeType="Q")||(PiCodeType="I")
 	{  
 		if (PiValueCode="")
		{	s ReturnDataValue = objITableSimple.DataValue     }
 		Elseif (PiValueCode="V")
	 	{ 	set ReturnDataValue= objITableSimple.DataValue    }
	 	elseif (PiValueCode="C")
 		{ 	set ReturnDataValue= objITableSimple.ValueCode }
	 	elseif (PiValueCode="VC")
	 	{   set ReturnDataValue= objITableSimple.DataValue_objITableSimple.ValueCode  }
	 	elseif (PiValueCode="CV")
	 	{  set ReturnDataValue= objITableSimple.ValueCode_objITableSimple.DataValue}
	    elseif (PiValueCode="VANDC")
	    {	set ReturnDataValue= objITableSimple.DataValue_"^"_objITableSimple.ValueCode}
	}
 	elseif (PiCodeType="D")
 	{
		if (PiValueCode="V")
	    {	set ReturnDataValue= objITableSimple.DataValue}
	    elseif (PiValueCode="C")
	    { 	set ReturnDataValue= objITableSimple.ValueCode}
	    elseif (PiValueCode="VANDC")
	    {	set ReturnDataValue= objITableSimple.DataValue_"^"_objITableSimple.ValueCode}
	    elseif (PiValueCode="YEAR")
	    {
 			Set TempDateTime = objITableSimple.ValueCode
		    set AYearValue = $P(TempDateTime,"-",1)
		    set ReturnDataValue= AYearValue
 		}
	    elseif (PiValueCode="Month")
	    {
		     Set TempDateTime = objITableSimple.ValueCode
		     set AMonthValue = $P(TempDateTime,"-",2)
 			 set ReturnDataValue= AMonthValue
 		}
	    elseif (PiValueCode="Day")
	    {
		    Set TempDateTime = objITableSimple.ValueCode
		    set ADayValue = $P($P(TempDateTime," ",1),"-",3)
 			set ReturnDataValue= ADayValue 
 		}
	    elseif (PiValueCode="Hour")
	    {
		    Set TempDateTime = objITableSimple.ValueCode
		    set AHourValue = $P($P(TempDateTime," ",2),":",1)
 			set ReturnDataValue= AHourValue 
 		}
	    elseif (PiValueCode="Minute")
	    { 	
	    	Set TempDateTime = objITableSimple.ValueCode
		    set AMinuteValue = $P($P(TempDateTime," ",2),":",2)
 			set ReturnDataValue= AMinuteValue  
 		}
	    elseif (PiValueCode="Second")
	    { 
	    	Set TempDateTime = objITableSimple.ValueCode
		    set ASecondValue = $P($P(TempDateTime," ",2),":",3)
		    set ReturnDataValue= ASecondValue 
		}
		elseif (PiValueCode="YMDHM")
		{
			//YYYY-MM-DD HH:MM
			Set TempDateTime = objITableSimple.ValueCode
			set ReturnDataValue = $P(TempDateTime," ",1)_" "_$E($P(TempDateTime," ",2), 1, 5)
		}
		elseif (PiValueCode="MDHM")
		{
			//MM-DD HH:MM
			Set TempDateTime = objITableSimple.ValueCode
			set TempDate = $P(TempDateTime," ",1)
			set TempTime = $P(TempDateTime," ",2)
			set ReturnDataValue = $E(TempDate,6,$L(TempDate))_" "_$E(TempTime, 1, 5)
		}
		elseif (PiValueCode="YMD")
		{
			//YYYY-MM-DD
			set ReturnDataValue = $P(objITableSimple.ValueCode," ",1)	
		}
		elseif (PiValueCode="MD")
		{
			//MM-DD
			set TempDate = $P(objISimple.ValueCode," ",1)
			set ReturnDataValue = $E(TempDate,6,$L(TempDate))
		}
		elseif (PiValueCode="HMS")
		{
			//HH:MM:SS
			set ReturnDataValue = $P(objITableSimple.ValueCode," ",2)	
		}
		elseif (PiValueCode="HM")
		{
			//HH:MM
			set ReturnDataValue = $E($P(objITableSimple.ValueCode," ",2),1,5)	
		}
		elseif (PiValueCode="YMDHM2")
		{
			//YYYY-MM-DD HH:MM
			Set TempDateTime = objITableSimple.ValueCode
			set ReturnDataValue = $P(TempDateTime," ",1)_" "_$E($P(TempDateTime," ",2), 1, 5)
			set ReturnDataValue = $tr(ReturnDataValue,"-",".")
		}
		elseif (PiValueCode="MDHM2")
		{
			//MM-DD HH:MM
			Set TempDateTime = objITableSimple.ValueCode
			set TempDate = $P(TempDateTime," ",1)
			set TempTime = $P(TempDateTime," ",2)
			set ReturnDataValue = $E(TempDate,6,$L(TempDate))_" "_$E(TempTime, 1, 5)
			set ReturnDataValue = $tr(ReturnDataValue,"-",".")
		}
		elseif (PiValueCode="YMD2")
		{
			//YYYY.MM.DD
			set ReturnDataValue = $P(objITableSimple.ValueCode," ",1)	
			set ReturnDataValue = $tr(ReturnDataValue,"-",".")
		}
		elseif (PiValueCode="MD2")
		{
			//MM.DD
			set ReturnDataValue = $P(objITableSimple.ValueCode," ",1)
			set ReturnDataValue = $p(ReturnDataValue,"-",2)_"."_$p(ReturnDataValue,"-",3)
		}
	}		  

 	s objITableSimple = ""
 	q
}

/// Desc: 获取G单元数据
/// [Previously private]
ClassMethod GetSegmentText(ASegmentId As %String, ByRef StrText As %String, ByRef StrFormate As %String)
{
 set StrText = ""
 set StrFormate = ""
 
 set objISegment = ##class(EPRinstance.ISegment).%OpenId(ASegmentId)
 q:(objISegment="") 
 
 s newStream = ##class(%GlobalCharacterStream).%New()
 
 d newStream.CopyFrom(objISegment.Text)
 While (newStream.AtEnd = 0) 
 {
 	set StrText= StrText_newStream.Read(3200) 
 }
 
 d newStream.Rewind()
 
 d newStream.CopyFrom(objISegment.FormateInfo)
 While (newStream.AtEnd = 0) 
 {
 	set StrFormate= StrFormate_newStream.Read(3200) 
 }
 
 d newStream.%Close()
 s objISegment = ""
 
 Q
}

/// Desc:获取G单元简单单元数据
/// Add by Candyxu 2012-05-24
/// [Previously private]
ClassMethod GetSegmentSimpleText(ASegmentSimpleId As %String, PiCodeType As %String, PiTypeCode As %String)
{
    s ReturnDataValue =""
    s objISegmentSimple = ##class(EPRinstance.ISegmentSimple).%OpenId(ASegmentSimpleId)
    quit:(objISegmentSimple="") "*NULL"
    s tmpDataValue =objISegmentSimple.DataValue
    s tmpValueCode =objISegmentSimple.ValueCode
    s ReturnDataValue = ..GetSimpleData(tmpDataValue,tmpValueCode,PiCodeType,PiTypeCode)
    q ReturnDataValue
}

/// Desc: 取简单单元数据
ClassMethod GetSimpleData(ADataValue As %String, ADataCode As %String, PiCodeType As %String, PiTypeCode As %String)
{
	s ReturnDataValue =""
	if (PiCodeType="S")||(PiCodeType="N")||(PiCodeType="O")||(PiCodeType="Q")||(PiCodeType="I")||(PiCodeType="R")
 	{
 	    if (PiTypeCode="")
	    {  set ReturnDataValue= ADataValue}
	    Elseif (PiTypeCode="V")
	    { set ReturnDataValue = ADataValue }
	    elseif (PiTypeCode="C")
	    { set ReturnDataValue= ADataCode }
	    elseif (PiTypeCode="VC")
	    { set ReturnDataValue = ADataValue_ADataCode }
	    elseif (PiTypeCode="CV")
	    { set ReturnDataValue = ADataCode_ADataValue }
	    elseif (PiTypeCode="VANDC")
	    { set ReturnDataValue = ADataValue_"^"_ADataCode }
	}
	elseif (PiCodeType="D")
	{
		//整理ValueCode的格式为[2009-1-1 02:23:38],其中2009-1-1和02:23:38可以为空值
		if (ADataCode="")
		{
			s ADataCode = " "
		}
		else
		{
			if ($L(ADataCode," ")=1)
			{
				if ($L(ADataCode,":")=3)
				{
					//只有时间部分，需添加空日期部分
					s ADataCode = " "_ADataCode
				}
				else
				{
					//只有日期部分，需添加空时间部分
					s ADataCode = ADataCode_" "
				}
			}
		}
		
	    if (PiTypeCode="V")
	    { 	set ReturnDataValue = ADataValue   }
	    elseif (PiTypeCode="V0")
	    {
		//YYYY-MM-DD HH:MM月份日期不足两位补零
		set TempDate = $P(ADataCode," ",1)
		set year = $p(TempDate,"-",1)
		set month =$p(TempDate,"-",2)
		if $LENGTH(month)=1 { s month = "0"_month}
		set day =  $p(TempDate,"-",3)
		if $LENGTH(day)=1 { s day = "0"_day}
		set ReturnDataValue = year_"年"_month_"月"_day_"日 "_$E($P(ADataCode," ",2), 1, 5)
	    }
	    elseif (PiTypeCode="C")
	    {  	set ReturnDataValue = ADataCode }
	    elseif (PiTypeCode="VANDC")
	    {  	set ReturnDataValue = ADataValue_"^"_ADataCode   }
	    elseif (PiTypeCode="YEAR")
	    { 	
	    	set TempDateTime = $p(ADataCode," ",1)
		set AYearValue = $P(TempDateTime,"-",1)
		set ReturnDataValue = AYearValue
	    }
	    elseif (PiTypeCode="Month")
	    { 
	    	set TempDateTime = $p(ADataCode," ",1)
		set AMonthValue = $P(TempDateTime,"-",2)
		set ReturnDataValue = AMonthValue
	    }
	    elseif (PiTypeCode="Day")
	    { 
	    	set TempDateTime = $p(ADataCode," ",1)
		set ADayValue = $P(TempDateTime,"-",3)
		set ReturnDataValue = ADayValue 
	    }
	    elseif (PiTypeCode="Hour")
	    { 
	    	set TempDateTime = $p(ADataCode," ",2)
		set AHourValue = $P(TempDateTime,":",1)
		set ReturnDataValue = AHourValue 
	   }
	    elseif (PiTypeCode="Minute")
	    { 
	    	set TempDateTime = $p(ADataCode," ",2)
		set AMinuteValue = $P(TempDateTime,":",2)
		set ReturnDataValue = AMinuteValue 
	    }
	    elseif (PiTypeCode="Second")
	    { 
	    	set TempDateTime = $p(ADataCode," ",2)
		set ASecondValue = $P(TempDateTime,":",3)
		set ReturnDataValue = ASecondValue 
	    }
	    elseif (PiTypeCode="YMDHM")
	    {
		//YYYY-MM-DD HH:MM
		set TempDateTime = ADataCode
		set ReturnDataValue = $P(TempDateTime," ",1)_" "_$E($P(TempDateTime," ",2), 1, 5)
	    }
	    elseif (PiTypeCode="MDHM")
	    {
		//MM-DD HH:MM
		Set TempDateTime = ADataCode
		set TempDate = $P(TempDateTime," ",1)
		set TempTime = $P(TempDateTime," ",2)
		set ReturnDataValue = $E(TempDate,6,$L(TempDate))_" "_$E(TempTime, 1, 5)
	    }
	    elseif (PiTypeCode="YMD")
	    {
		//YYYY-MM-DD
		set ReturnDataValue = $P(ADataCode," ",1)	
	    }
	    elseif (PiTypeCode="YMD0")
	    {
		//YYYY-MM-DD月份日期不足两位补零
		set TempDate = $P(ADataCode," ",1)
		set year = $p(TempDate,"-",1)
		set month =$p(TempDate,"-",2)
		if $LENGTH(month)=1 { s month = "0"_month}
		set day =  $p(TempDate,"-",3)
		if $LENGTH(day)=1 { s day = "0"_day}
		set ReturnDataValue = year_"-"_month_"-"_day
	    }
	    elseif (PiTypeCode="MD")
	    {
		//MM-DD
		set TempDate = $P(ADataCode," ",1)
		set ReturnDataValue = $E(TempDate,6,$L(TempDate))
	     }
	     elseif (PiTypeCode="HMS")
	     {
		 //HH:MM:SS
		 set ReturnDataValue = $P(ADataCode," ",2)	
	     }
	     elseif (PiTypeCode="HM")
	     {
		 //HH:MM
		 set ReturnDataValue = $E($P(ADataCode," ",2),1,5)	
	     }
	     elseif (PiTypeCode="YMDHM2")
	     {
		 //YYYY-MM-DD HH:MM
		 Set TempDateTime = ADataCode
		 set ReturnDataValue = $P(TempDateTime," ",1)_" "_$E($P(TempDateTime," ",2), 1, 5)
		 set ReturnDataValue = $tr(ReturnDataValue,"-",".")
	     }
	     elseif (PiTypeCode="MDHM2")
	     {
		//MM-DD HH:MM
		Set TempDateTime = ADataCode
		set TempDate = $P(TempDateTime," ",1)
		set TempTime = $P(TempDateTime," ",2)
		set ReturnDataValue = $E(TempDate,6,$L(TempDate))_" "_$E(TempTime, 1, 5)
		set ReturnDataValue = $tr(ReturnDataValue,"-",".")
	     }
	     elseif (PiTypeCode="YMD2")
	     {
		//YYYY.MM.DD
		set ReturnDataValue = $P(ADataCode," ",1)	
		set ReturnDataValue = $tr(ReturnDataValue,"-",".")
	     }
	     elseif (PiTypeCode="MD2")
	     {
		//MM.DD
		set ReturnDataValue = $P(ADataCode," ",1)
		set ReturnDataValue = $p(ReturnDataValue,"-",2)_"."_$p(ReturnDataValue,"-",3)
	     }
	}
	elseif (PiCodeType="M")
	{
 	   if (PiTypeCode="")
 	    {  	set ReturnDataValue= ADataValue}
	    elseif (PiTypeCode="V")
	    { 	set ReturnDataValue = ADataValue}
	    elseif (PiTypeCode="C")
	    {  	set ReturnDataValue= ADataCode}
	    elseif (PiTypeCode="VC")
	    { 	set ReturnDataValue = ADataValue_ADataCode }
	    elseif (PiTypeCode="CV")
	    { 	set ReturnDataValue = ADataCode_ADataValue  }
	    elseif (PiTypeCode="VANDC")
	    { 	set ReturnDataValue = ADataValue_"^"_ADataCode   }
	    elseif (PiTypeCode="CN")
	    {
		set ReturnDataValue=##class(EPRservice.BODataGateway).TranslateCodeToDisplay(ADataCode,"True")  
	    }
	}
	
	s ReturnDataValue = ..ConvertChar(ReturnDataValue)
	q ReturnDataValue
}

/// Desc: 获取E单元数据
/// [Previously private]
ClassMethod GetTextDescText(ATextdescID As %String, ByRef StrText As %String, ByRef StrFormate As %String)
{
 set StrText= ""
 set StrFormate = ""
 
 set objITextDesc = ##class(EPRinstance.ITextDesc).%OpenId(ATextdescID)
 q:(objITextDesc="")
  
 s newStream = ##class(%GlobalCharacterStream).%New()
 
 d newStream.CopyFrom(objITextDesc.Text)
 While (newStream.AtEnd = 0) 
 {
 	set StrText= StrText_newStream.Read(3200) 
 }
 
 d newStream.Rewind()
 
 d newStream.CopyFrom(objITextDesc.FormateInfo)
 While (newStream.AtEnd = 0) 
 {
 	set StrFormate= StrFormate_newStream.Read(3200) 
 }
 
 d newStream.%Close()
 s objITextDesc = ""
 q
}

ClassMethod GetTextDescData(ATextDescID As %String, ByRef destStream As %Stream)
{
	 set objITextDesc = ##class(EPRinstance.ITextDesc).%OpenId(ATextDescID)
	 if (objITextDesc="")
	 {
		do destStream.Write("*NULL@|*NULL")
	 	quit
	 }
	 
	 s newStream = ##class(%GlobalCharacterStream).%New()
 
 	d newStream.CopyFrom(objITextDesc.Text)
 	While (newStream.AtEnd = 0) 
 	{
 		do destStream.Write(newStream.Read(102400)) 
 	}
 
 	do destStream.Write("@|")
 	
 	d newStream.Rewind()
 
 	d newStream.CopyFrom(objITextDesc.FormateInfo)
 	While (newStream.AtEnd = 0) 
 	{
 		do destStream.Write(newStream.Read(102400)) 
 	}
 
 	d newStream.%Close()
 	s objITextDesc = ""
 	q
}

/// Desc: 获取图片中的流数据
/// [Previously private]
ClassMethod GetImageData(ByRef objAnnotate As EPRmeta.ImageAnnotate, ByRef destStream As %GlobalCharacterStream)
{
	q:(objAnnotate="")
	
	s newStream = ##class(%GlobalCharacterStream).%New()
 	d newStream.CopyFrom(objAnnotate.ImageData)
 	While (newStream.AtEnd = 0) 
 	{
 		d destStream.Write(newStream.Read(3200)) 
 	}
	d newStream.%Close()
	q
}

/// Desc: 获取图片中的流数据
/// [Previously private]
ClassMethod GetAnnoData(ByRef objIAnnotate As EPRinstance.IAnnotate, ByRef destStream As %GlobalCharacterStream)
{
	q:(objIAnnotate="")
	
	s newStream = ##class(%GlobalCharacterStream).%New()
 	d newStream.CopyFrom(objIAnnotate.AnnoData)
 	While (newStream.AtEnd = 0) 
 	{
 		d destStream.Write(newStream.Read(12000)) 
 	}
	d newStream.%Close()
	q
}

/// Desc: 获取图片中的流数据
/// [Previously private]
ClassMethod GetFigureData(ByRef objFigure As EPRinstance.IFigure, ByRef destStream As %GlobalCharacterStream)
{
	q:(objFigure="")
	
	if (objFigure.FigureType = "CI")||(objFigure.FigureType = "EI")
	{
		s isImageOK = ..GetImageItemData(objFigure.FigureType, objFigure.FigureID, .destStream)
		q:('isImageOK)
		
		d destStream.Write("@%")
		
		s newStream = ##class(%GlobalCharacterStream).%New()
 		d newStream.CopyFrom(objFigure.AnnoData)
		while (newStream.AtEnd = 0)
		{
			d destStream.Write(newStream.Read(12000))
		}
		d newStream.%Close()
	}
	else
	{
		if (objFigure.FigureData.Size < 1)
		{
			d destStream.Write("*NULL")
			quit
		}
		
		s newStream = ##class(%GlobalCharacterStream).%New()
 		d newStream.CopyFrom(objFigure.FigureData)
		while (newStream.AtEnd = 0)
		{
			d destStream.Write(newStream.Read(12000))
		}
		d newStream.%Close()
	}
	
	q
}

/// [Previously private]
ClassMethod GetImageItemData(figureType As %String, figureID As %String, ByRef destStream As %GlobalCharacterStream) As %String
{
	s obj = ""
	if (figureType = "CI")
	{
		s obj = ##Class(EPRmeta.ImageItem).%OpenId(figureID)
	}
	elseif (figureType = "EI")
	{
		s obj = ##Class(EPRinstance.AdmImageItem).%OpenId(figureID)
	}
	q:(obj = "") "0"
	q:(obj.ImageData = "") "0"
	
	s newStream = ##class(%GlobalCharacterStream).%New()
 	d newStream.CopyFrom(obj.ImageData)
	while (newStream.AtEnd = 0)
	{
		d destStream.Write($System.Encryption.Base64Encode(newStream.Read(12000)))
	}
	d newStream.%Close()
	
	s obj = ""
	
	q "1"
}

/// Desc: 转化回车和换行
ClassMethod ConvertChar(str As %String) As %String
{
	//转换 &EnterKey;
	set count = $Length(str, "&KeyEnter;")
    if count > 1
    {
	    set tmpStr = ""
		for I = 1:1:count
		{
			set tmpStr = tmpStr_$p(str,"&KeyEnter;",I)_$c(13) 
		}
		set str = $extract(tmpStr,1,$Length(tmpStr)-1)
    }
	//转换 &nbsp;
	set count = $Length(str, "&nbsp;")
	if count > 1
	{
		set tmpStr=""
		for I = 1:1:count
		{
			set tmpStr = tmpStr_$p(str,"&nbsp;",I)_$c(32)
		}
		set str = $extract(tmpStr,1,$Length(tmpStr)-1)
	}
	
	q str
}

/// ************************* 以下方法可能已停用 ******************************
ClassMethod DBInterFace(AReciveString As %String) As %String [ WebMethod ]
{
	/*
 //first  Splite Recivestr into Four : Head,Single,Multiple ,SystemData
 K ^AR(uniqueEPRGlobalID)
 s ^AR(uniqueEPRGlobalID,$HOROLOG) = AReciveString
 set AHeadStrStart = $Find(AReciveString,"$Head{")
 set ASingleStrStart = $Find(AReciveString,"$Single#Simple")
 set AMultipleStrStart = $Find(AReciveString,"$Multiple#Simple")
 set ASystemDateStrStart = $Find(AReciveString,"$SystemData")

 //first  find ASingleStr location or AMultipleStr or ASystemDateStr
 // return if have str Value  ,return Value
 //SingleStr MultipleStr SystemDateStr are assure   
 if (ASingleStrStart'=0)
 { set AHeadStr= $EXTRACT(AReciveString,AHeadStrStart,ASingleStrStart-16)	

 if (AMultipleStrStart '=0)
 { 
 set ASingleOrigiStr= $EXTRACT(AReciveString,ASingleStrStart-14,AMultipleStrStart-17)
 if (ASystemDateStrStart'=0) 
 {   set AMultipleOrigiStr= $EXTRACT(AReciveString,AMultipleStrStart-16,ASystemDateStrStart-12)  
	   set ASystemDateStr= $EXTRACT(AReciveString,ASystemDateStrStart-11,$L(AReciveString))  
	  }
 elseif (ASystemDateStrStart=0) 
 {   set AMultipleOrigiStr= $EXTRACT(AReciveString,AMultipleStrStart-16,$L(AReciveString))  
	   set ASystemDateStr = ""
	     }
 }
 Elseif (AMultipleStrStart=0)
 { if (ASystemDateStrStart'=0) 
 {   set ASingleOrigiStr= $EXTRACT(AReciveString,ASingleStrStart-14,ASystemDateStrStart-12)	  
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
 //B "S"

 if (AHeadStr="")
 {
 Quit ""	 
	 }
 set ResultStream= ##class(%GlobalCharacterStream).%New()	 
 set ResultStr= "$Head{"_AHeadStr_"}"
 d ResultStream.Write(ResultStr)
 if (ASingleOrigiStr'="")
 {
 //B "S"
 set ASingleDataStr = ..GetSingleData(AHeadStr,ASingleOrigiStr,ResultStream)
 //set ResultStr = ResultStr_ASingleDataStr
 } 
 //get Multipledata
 //B "S"
 if (AMultipleOrigiStr'="")
 {
 set AMultipleDataStr = ..GetMultipleData(AHeadStr,AMultipleOrigiStr,ResultStream)
 //set ResultStr = ResultStr_AMultipleDataStr
 }	 
 //Get Systemdate
 if (ASystemDateStr'="")
 {
	set ReSystemDateStr = ..GetSysData(ASystemDateStr)
	//set ResultStr = ResultStr_ReSystemDateStr
 }
 //Set ^AR("ResultStr1",$h)= ResultStr
 Quit ResultStr
 */
}

ClassMethod GetDataByQueryNameLevel(AClassName As %String, AQueryName As %String, AParameterS As %String) As %XML.DataSet [ WebMethod ]
{
 if (AQueryName = "GetPatientInfo")
 {
	// 在Query中增加相应的隐私函数，并将隐私域按以下配置 
	// s Privacyflag = ##class(EPRservice.BODataGateway).ReplacePrivacyInfo("1","I0106","V","*",1)
	// s:(Privacyflag '= 0) HuKouCityPrint = "***"
	s AQueryName = "GetPrivacyInfo"	 
 }
	
 // Return the results of the Person class' ByName query.
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

ClassMethod GetDataByQueryName(AClassName As %String, AQueryName As %String, AParameterS As %String) As %XML.DataSet [ WebMethod ]
{
 // Return the results of the Person class' ByName query.
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

ClassMethod GetMultipleSimpleData(ByRef AReStream As %Stream)
{
}

ClassMethod GetParameterString(AClassName As %String, AQueryName As %String) As %String [ WebMethod ]
{
	 //comented and updated by houj on 200-12-11
	 /*	
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
	 */
	 
	 q:(($d(AClassName)=0)||($d(AQueryName)=0)) ""
	 s retStr=""
	 
	 s queryId = ##class(EPRmeta.BindQuery).SelectIDByClassName(AClassName,AQueryName)
	 q:(queryId="") ""
	 
	 s dataSet = ##class(%ResultSet).%New("EPRmeta.BindParameter:SelectParameterByQueryID")
	 d dataSet.Execute(queryId)
	 while (dataSet.Next())
	 {
		 if (retStr = "")
		 {	s retStr = dataSet.Data("ParameterName")}
		 else
		 {	s retStr = retStr_","_dataSet.Data("ParameterName")}
	 }
	 
	 q retStr
}

ClassMethod TranslateCodeToDisplay(ACodeValue As %String, NumFlag As %String) As %String
{
 set ResultStr=""
 if (NumFlag="True")
 { if (ACodeValue="")&(ACodeValue=$C(0))
 { Quit "" }	
 s ACodeCount = $L(ACodeValue)

 for I=1:1:ACodeCount
 {
	if ($E(ACodeValue,I)="1")  
	{ 
	  if (I =1)
	  { s ResultStr ="1"  } 
	  elseif ( I>1)
	  {  
	    if (ResultStr '="")
	     { s ResultStr = ResultStr_","_I }
	    elseif (ResultStr="")  
	    {
		  s ResultStr = I  }
	  
	   } 
	}
	 }
	} 
	Q ResultStr
}

/// ************************* 以下为测试代码 *************
/// 
/// Desc: 测试取打散数据接口
///       在Terminal中执行：w ##class(EPRservice.BODataGateway).Test()
ClassMethod Test() As EPRservice.entity.ReStreamData
{
	//将allString使用要测试的输入字符串代替
	//s allString = "$Head{PatientID:107415,EpisodeID:551919,InstanceDataID:}$Single#Simple{}#Segment{}#TextDesc{*NULL|E0001}$Multiple#Simple{}#Segment{}#TextDesc{}#InstanceData{}$SystemData{}"
	s allString = ^DHCEPRDebug("EPRservice.BODataGateway,DBInterFaceByStream","Input")
	s retStream = ..DBInterFaceByStream(allString)
	d retStream.StreamData.Rewind()
	/*
	while retStream.StreamData.AtEnd = 0
	{
		w retStream.StreamData.Read(1000)
	}
	*/
	quit retStream
}

/// TODO: add arguments and implementation.
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

ClassMethod testsplit()
{
	s a="$Single#Simple{340|I0001|V,340|S0002|V,340|S0003|V,340|S0004|V,340|I0097|V,340|S0006|V,340|S0104|V,340|O0105|V,340|D0007|V,340|D0008|V,340|S0095|V,340|S0009|V,340|S0010|V,340|S0011|V,340|S0012|V,340|S0013|V,340|S0014|V}#Segment{340|G0091,340|G0016,340|G0044,340|G0048}#TextDesc{tdtdtd}#Table{tbltbltt}#ImageAnnotate{imgano}#Figure{fffig}"
	s a="$Single#Simple{340|I0001|V,340|S0002|V,340|S0003|V,340|S0004|V,340|I0097|V,340|S0006|V,340|S0104|V,340|O0105|V,340|D0007|V,340|D0008|V,340|S0095|V,340|S0009|V,340|S0010|V,340|S0011|V,340|S0012|V,340|S0013|V,340|S0014|V}#Segment{340|G0091,340|G0016,340|G0044,340|G0048}#TextDesc{tdtdtd}#Table{tbltbltt}#ImageAnnotate{imgano}"
	
	set ASimpleStrStart=0,ASegmentStrStart=0,ATextDescStrStart=0
	set ATableSimpleStrStart=0,AImageAnnotateStrStart=0,AFigureStrStart=0
	set length=0
	
  set ASimpleStrStart = $Find(a,"#Simple{")
  set ASegmentStrStart = $Find(a,"#Segment{")
  set ATextDescStrStart = $Find(a,"#TextDesc{")
  set ATableSimpleStrStart = $Find(a,"#Table{")
  set AImageAnnotateStrStart = $Find(a,"#ImageAnnotate{")
  set AFigureStrStart = $find(a,"#Figure{")
	set length=$l(a)
	
	;w ASimpleStrStart,!,ASegmentStrStart,!,ATextDescStrStart,!
	;w ATableSimpleStrStart,!,AImageAnnotateStrStart,!,AFigureStrStart,!
	;w length,!
	
	if (AFigureStrStart'=0) {w $EXTRACT(a,AFigureStrStart,length-1),!} else {w "AFigureStrStart"}
	if (AImageAnnotateStrStart'=0) {w $EXTRACT(a,AImageAnnotateStrStart,AFigureStrStart-$l("#Figure{")-2),!} else {w "AImageAnnotateStrStart"}
	if (ATableSimpleStrStart'=0) {w $EXTRACT(a,ATableSimpleStrStart,AImageAnnotateStrStart-$l("#ImageAnnotate{")-2),!} else {w "ATableSimpleStrStart"}
	if (ATextDescStrStart'=0) {w $EXTRACT(a,ATextDescStrStart,ATableSimpleStrStart-$l("#Table{")-2),!} else {w "ATextDescStrStart"}
	if (ASegmentStrStart'=0) {w $EXTRACT(a,ASegmentStrStart,ATextDescStrStart-$l("#TextDesc{")-2),!} else {w "ASegmentStrStart"}
	if (ASimpleStrStart'=0) {w $EXTRACT(a,ASimpleStrStart,ASegmentStrStart-$l("#Segment{")-2),!} else {w "ASimpleStrStart"}
}

}
