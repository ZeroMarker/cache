/// -------------------------------------------------------
/// purpose：报表查询服务
/// note：首先由查询条件生成查询结果集，然后计算结果集的总行数
/// 和总页数（1000行/页），最后分次取回结果（每次取一页）
/// -------------------------------------------------------
Class EPRservice.BODataQueryService Extends %SOAP.WebService [ Not ProcedureBlock ]
{

/// Parameter LOCATION = "http://10.10.141.136/trakcarelive/trak/web";
/// TODO: change this to actual network address.
/// URL for invoking the WebService.
/// TODO: change this to actual SOAP namespace.
/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/metaservice";

/// Name of the WebService.
Parameter SERVICENAME = "DataQueryServiceInfo";

/// 获取查询结果行数，并计算对应页数(1000行/页), 返回值格式为：
/// $ResultID:^CacheTempGlobalName($J)$ResultCount:ResultPageCount$SystemData{value1,value2}
ClassMethod GetRptDataCount(AQueryStr As %String) As %String [ WebMethod ]
{
	///b "s"
  	set Result=""
  	
  	///global for debug
  	s ^DHCEPRDebug("EPRservice.BODataQueryService","AASessionId")=$J
  	s ^DHCEPRDebug("EPRservice.BODataQueryService","AQueryStringFromClient")=AQueryStr
  	
  	///由查询条件建立查询结果
  	do ..BuildRptData(AQueryStr)  
  
  	///结果集的Id
  	set ResultId= "$ResultID:"_"CacheTempDHCEPRRptLastResult("_$J_")"
  
  	///获取查询结果的总行数,并计算出总页数(1000行/页) 
  	set ResultDataCount = ##class(EPRservice.BODataQueryService).GetResultCount()
  	set ResultPageModulusNum = ResultDataCount # 1000  
  	set ResultPageCount = ResultDataCount \ 1000 
  	if (ResultPageModulusNum>0)
  	{	set ResultPageCount= ResultPageCount + 1}
  	set ResultCount= "$ResultCount:"_ResultPageCount
  	
  	///获取相关的系统信息
  	set ResultSys=Result_ ##class(EPRservice.BODataQueryService).GetSysInfo()
  	
  	///构造返回值
  	set Result=ResultId_ResultCount_ResultSys
  	
  	///global for debug
  	s ^DHCEPRDebug("EPRservice.BODataQueryService","BQueryResultStatToClient")=Result
  	
  	Q Result
}

/// 取回查询结果集的一页数据(1000行/页),返回值格式为：
/// $ResultSet{returnValue@|returnValue@|...}
ClassMethod GetRrtDataOld(AResultName As %String, APageCount As %String, APageNum As %String) As %String [ WebMethod ]
{
 s ^DHCEPRDebug("EPRservice.BODataQueryService","GetRrtData")=AResultName _"@@"_APageCount_"$$$"_APageNum
 set SessionId = $P($P(AResultName,"(",2),")",1)
 set ResultSet= "$ResultSet{"
 //set ResultColItemCount= $G(^CacheTempQueryResultColStr(SessionId,"ResultColCount"))	   
 set ResultColItemCount= $G(^CacheTempDHCEPRRptSysResult(SessionId,"ResultColCount"))	   
 //^CacheTempEPRRptSysData
 if (APageCount'="0")
 {set StartId= (APageNum-1)*1000
 
 set EndId= APageNum*1000
 set ResultId= $O(^CacheTempDHCEPRRptLastResult(SessionId,StartId)) 
 set EachRowStr= ""
 While (ResultId'="")
 {
	if (ResultId < EndId) 
	{
	  set EachRowStr= ""
	  for I=1:1:ResultColItemCount
	  {
		if (I<ResultColItemCount)
		 {
			 set EachRowStr=EachRowStr_$G(^CacheTempDHCEPRRptLastResult(SessionId,ResultId,I))_"@|"  
		 }
		 elseif (I=ResultColItemCount)
		 {
		  set EachRowStr=EachRowStr_$G(^CacheTempDHCEPRRptLastResult(SessionId,ResultId,I))  	 
			 }
		 } 
		}
		
  set ResultSet = ResultSet_ EachRowStr_"@^" 		
  set ResultId= $O(^CacheTempDHCEPRRptLastResult(SessionId,ResultId)) 	 
	 }
 	
  S ResultSet=$E(ResultSet,0,$L(ResultSet)-2)	
  
  }
  Elseif (APageCount="0")
  {
	  set EachRowStr= ""
	  for I=1:1:ResultColItemCount
	  {
		if (I<ResultColItemCount)
		 {
			 set EachRowStr=EachRowStr_"*NULL"_"@|"  
		 }
		 elseif (I=ResultColItemCount)
		 {
		  set EachRowStr=EachRowStr_"*NULL"  	 
			 }
		 } 
	  
	s ResultSet= ResultSet_ EachRowStr 
	  }
  s ResultSet=ResultSet_"}"	
   s ^DHCEPRDebug("EPRservice.BODataQueryService","GetRrtData")=ResultSet
  Quit ResultSet
}

/// Desc:取回查询结果集的一页数据(1000行/页),返回值格式为：
///     $ResultSet{returnValue@|returnValue@|...}
/// ModifyDate: 2008-09-11
/// ModifyUser: houjian@dhcc.com.cn 
ClassMethod GetRrtData(AResultName As %String, APageCount As %String, APageNum As %String) As EPRservice.entity.ReStreamData [ WebMethod ]
{
 	//debug
 	//s ^DHCEPRDebug("EPRservice.BODataQueryService","GetRrtData")=AResultName _", "_APageCount_", "_APageNum
 	
 	//初始化返回值
 	s ObjReStream = ##class(EPRservice.entity.ReStreamData).%New()
 	quit:(ObjReStream = "") ""
 	
 	do ObjReStream.StreamData.Write("$ResultSet{")
 	
 	set RowCount = 0
 	set SessionId = $P($P(AResultName,"(",2),")",1)
 	set ResultColItemCount= $G(^CacheTempDHCEPRRptSysResult(SessionId,"ResultColCount"))	   
 	if (APageCount'="0")
 	{
	 	//结果集不为空，以行为单位取回
	 	set StartId= (APageNum-1)*1000
 		set EndId= APageNum*1000
 		set ResultId= $O(^CacheTempDHCEPRRptLastResult(SessionId,StartId)) 
 		While (ResultId'="")
 		{
			if (ResultId < EndId) 
			{
				//取一行结果
	  			set EachRowStr= ""
	  			for I=1:1:ResultColItemCount
	  			{
					if (I<ResultColItemCount)
		 			{
			 			set EachRowStr=EachRowStr_$G(^CacheTempDHCEPRRptLastResult(SessionId,ResultId,I))_"@|"  
		 			}
		 			elseif (I=ResultColItemCount)
		 			{
		  				set EachRowStr=EachRowStr_$G(^CacheTempDHCEPRRptLastResult(SessionId,ResultId,I))  	 
			 		}
		 		}
		 				
		 		set RowCount = RowCount + 1
  				if RowCount = 1
  				{	do ObjReStream.StreamData.Write(EachRowStr)}
  				else
  				{	do ObjReStream.StreamData.Write("@^"_EachRowStr)} 
			}
		
  			set ResultId= $O(^CacheTempDHCEPRRptLastResult(SessionId,ResultId)) 	 
	 	}
  	}
  	Elseif (APageCount="0")
  	{
	  	//结果集为空，拼一个空的结果行
	  	set EachRowStr= ""
	  	for I=1:1:ResultColItemCount
	  	{
			if (I<ResultColItemCount)
		 	{
			 	set EachRowStr=EachRowStr_"*NULL"_"@|"  
		 	}
		 	elseif (I=ResultColItemCount)
		 	{
		  		set EachRowStr=EachRowStr_"*NULL"  	 
			}
		} 
	  
	  	do ObjReStream.StreamData.Write(EachRowStr)
	}
	
  	do ObjReStream.StreamData.Write("}")
  	
  	//debug	
   	//s ^DHCEPRDebug("EPRservice.BODataQueryService","GetRrtData")=ObjReStream.StreamData.Read(1000)
  	
  	quit ObjReStream
}

//

/// 由查询条件构造查询结果
ClassMethod BuildRptData(AQueryStr As %String) As %String
{
	///解析客户端传来的请求字符串
	do ..ParseQueryCommonStr(AQueryStr)
	
	///筛选符合查询条件的episode集合
	do ..FilterAdmIdByCondition()
  
  	///构造查询结果集
  	do ..BuildEachRowResult()
  
  	///对查询结果集进行聚合操作
	do ..BuildGroupResult()
}

/// 解析客户端传来的查询字符串，其格式为:
/// $QueryCondition#{ ConditionExpression OR ConditionExpression And ConditionExpression OR ConditionExpression }
/// $ResultColumn{ResultExpression, ResultExpression }
/// $SystemData{DATE,TIME}
ClassMethod ParseQueryCommonStr(AQueryStr As %String)
{
  	K ^ARComQuery($J)
 	s ^ARComQuery($J,$HOROLOG) = AQueryStr
	
	///global for debug
	s ^DHCEPRDebug("EPRservice.BODataQueryService","CQueryStringCommon")=AQueryStr
	
	///将请求字符串解析成三部分:
	///QueryCondition, ResultColumn, SystemData
 	set AQueryConStrStart = $Find(AQueryStr,"$QueryCondition#{")
 	set AResultColStrStart = $Find(AQueryStr,"$ResultColumn{")
 	set ASystemDateStrStart = $Find(AQueryStr,"$SystemData") 
 	if (AResultColStrStart'=0)
 	{
		set AQueryConStr = $EXTRACT(AQueryStr,AQueryConStrStart,AResultColStrStart-16)	 
    	if (ASystemDateStrStart'=0)	 
    	{
	 		set AResultColStr = $EXTRACT(AQueryStr,AResultColStrStart,ASystemDateStrStart-13)	 
	 		set ASystemDateStr = $EXTRACT(AQueryStr,ASystemDateStrStart-11,$L(AQueryStr))	 
	 	}
	 	elseif (ASystemDateStrStart =0)	 
	 	{
	 		set AResultColStr = $EXTRACT(AQueryStr,AResultColStrStart-11,$L(AQueryStr))	 
	 		set ASystemDateStr =""	 
		}
	}
 	elseif (AResultColStrStart=0)
 	{
		set AResultColStr = ""
	 	set ASystemDateStr = $EXTRACT(AQueryStr,ASystemDateStrStart-16,$L(AQueryStr))	 
	}
	
	///解析QueryCondition部分（查询条件）
	if (AQueryConStr'="")	 
 	{	do ..ParseQueryConditionStr(AQueryConStr)}
 	///解析ResultColumn部分（报表头）
 	if (AResultColStr'="")
	{	do ..ParseQueryResultColumn(AResultColStr)}
	///解析SystemData部分（日期时间）
	if (ASystemDateStr'="")
 	{	do ..ParseQuerySysInfo(ASystemDateStr)}
}

/// 解析查询条件
ClassMethod ParseQueryConditionStr(AConditionStr As %String)
{
	///global for debug
	s ^DHCEPRDebug("EPRservice.BODataQueryService","DQueryStringCondition")=AConditionStr
	
	///清空临时global
	k ^CacheTempDHCEPRRptCondition($J,"Episode")
 	k ^CacheTempDHCEPRRptCondition($J,"EPR")
 	k ^CacheTempDHCEPRRptCondition($J,"Glossary")
 	k ^CacheTempDHCEPRRptCondition($J,"LIS")
 	k ^CacheTempDHCEPRRptCondition($J,"PACS")
 	
 	///将查询条件解析为五部分:
 	///就诊信息部分, 电子病历数据部分，术语集部分，LIS数据部分，PACS数据部分
 	s EpisodeStrStart = $find(AConditionStr,"#Episode:")
	s EPRStrStart = $find(AConditionStr,"#EPR:")
 	s GlossaryStrStart = $find(AConditionStr,"#Glossary:")
 	s LISStrStart = $find(AConditionStr,"#LIS:")
 	s PACSStrStart = $find(AConditionStr,"#PACS:")
 	
 	s EpisodeStr = $extract(AConditionStr,EpisodeStrStart,EPRStrStart-6)	 
	s EPRStr = $extract(AConditionStr,EPRStrStart,GlossaryStrStart-11)
	s GlossaryStr = ""
	s LISStr = ""
	s PACSStr = ""
	if (LISStrStart '= 0)&&(PACSStrStart'=0)
	{
		s GlossaryStr = $extract(AConditionStr, GlossaryStrStart, LISStrStart-6)
		s LISStr = $extract(AConditionStr, LISStrStart, PACSStrStart-7)
		s PACSStr = $extract(AConditionStr, PACSStrStart, $length(AConditionStr))
	}
	else
	{
		s GlossaryStr = $extract(AConditionStr, GlossaryStrStart, $length(AConditionStr))
	}
	
	///解析查询条件的就诊信息部分
	if (EpisodeStr'="")
 	{ 	do ..ParseQueryEpisodeStr(EpisodeStr)}
    ///解析查询条件的电子病历数据部分
 	if (EPRStr'= "")
 	{	do ..ParseQueryEPRStr(EPRStr)}
 	///解析查询条件的术语集部分
 	if (GlossaryStr'="")
 	{   do ..ParseQueryGlossaryStr(GlossaryStr)}
 	///解析查询条件的LIS数据部分
	if (LISStr '= "")
	{ 	do ..ParseQueryLISStr(LISStr)}
	///解析查询条件的PACS数据部分
	if (PACSStr '= "")
	{ 	do ..ParseQueryPACSStr(PACSStr)}
}

/// 解析查询条件中就诊信息项相关部分
ClassMethod ParseQueryEpisodeStr(AEpisodeStr As %String)
{
	///global for debug
	s ^DHCEPRDebug("EPRservice.BODataQueryService","EQueryStringEpisode")=AEpisodeStr
	
	if (AEpisodeStr'= "")
 	{
 		set AndItemCount = $LENGTH(AEpisodeStr," AND ")
 		Set DischageDataCount = 0
 		Set ADMDataCount = 0
 		for I=  1 :1:AndItemCount
 		{
  		 	set aAndItem=""  
   			SET aAndItem=$PIECE(AEpisodeStr," AND ",I)
   			set AOrStrStart = $Find(aAndItem," OR ")
   			// has  OR  items,Parse Or Items 
   			if (AOrStrStart>0)
   			{
     			set ^CacheTempDHCEPRRptCondition($J,"Episode",I)= "OR"
     
     			set ORItemCount = $LENGTH(aAndItem," OR ")
     			set EPRORCount  = 0
     			set EpisodeORCount  = 0
     
     			For J=1:1:ORItemCount
     			{
	   				SET aORItem = $PIECE(AEpisodeStr," OR ",J) 
	   
	   				//parse the type ,get two  global Episode and epr 
	   				set TypeStr = $P($P(aORItem,"#",2),":",2)
	   				if (TypeStr="Episode")
	   				{
		 				set EpisodeORCount= EpisodeORCount + 1 
		 				set ^CacheTempDHCEPRRptCondition($J,"Episode",I,EpisodeORCount)= "OR" 
       					// Type
        
         				set ^CacheTempDHCEPRRptCondition($J,"Episode",I,EpisodeORCount,"TYPE")= $P($P(aORItem,"#",2),":",2)
       					//Tid Code
         				set ^CacheTempDHCEPRRptCondition($J,"Episode",I,EpisodeORCount,"FTYPE")= $P($P(aORItem,"#",3),":",2)
       					//
         				set ^CacheTempDHCEPRRptCondition($J,"Episode",I,EpisodeORCount,"FNAME")= $P($P(aORItem,"#",4),":",2)
       					//
         				set ^CacheTempDHCEPRRptCondition($J,"Episode",I,EpisodeORCount,"CONDITION")= $P($P(aORItem,"#",5),":",2)
         				set ^CacheTempDHCEPRRptCondition($J,"Episode",I,EpisodeORCount,"VALUE")= $P($P(aORItem,"#",6),":",2)  
		   				
		   			}
	  			}
	  			set ^CacheTempDHCEPRRptCondition($J,"Episode",I,"COUNT")= EpisodeORCount
	 		}
     		// has No or Items ,just A And Item
    		elseif (AOrStrStart=0)
    		{
     			//#TYPE:Simple#TID:XX#SCODE:XX#VTYPE:XX#CONDITION:>=#VALUE:123 
     			//And OR Tag , parse the type ,get two  global Episode and epr 
	  			set TypeStr = $P($P(aAndItem,"#",2),":",2)
	  			if (TypeStr="Episode")
	  			{      
	   				set ^CacheTempDHCEPRRptCondition($J,"Episode",I)= "AND"
       				// Type
       				set ^CacheTempDHCEPRRptCondition($J,"Episode",I,"TYPE")= $P($P(aAndItem,"#",2),":",2)
       				// Tid Code
       				set ^CacheTempDHCEPRRptCondition($J,"Episode",I,"FTYPE")= $P($P(aAndItem,"#",3),":",2)
       				//
       				set FNAMEStr = $P($P(aAndItem,"#",4),":",2)
       				set ^CacheTempDHCEPRRptCondition($J,"Episode",I,"FNAME")= FNAMEStr
       				if $zcvt(FNAMEStr,"U")="DISDATETIME"  
       				{ 
	     				s DischageDataCount= DischageDataCount+1  
	    			}
       				elseif $zcvt(FNAMEStr,"U")="ADMDATATIME" 
       				{ 
	     				s ADMDataCount= ADMDataCount+1  
	    			}	
       			//
       				set ^CacheTempDHCEPRRptCondition($J,"Episode",I,"CONDITION")= $P($P(aAndItem,"#",5),":",2)
       				set ^CacheTempDHCEPRRptCondition($J,"Episode",I,"VALUE")= $P($P(aAndItem,"#",6),":",2)
       			}
   			} 
 		} 
 
 		set ^CacheTempQueryEpisodeCount($J,"DischageDataCount")= DischageDataCount
 		set ^CacheTempQueryEpisodeCount($J,"ADMDataCount")= ADMDataCount
 	}
}

/// 解析查询条件中电子病历数据相关部分，其格式为:
/// " AND #TYPE:TextDescSimple#TID:3#TVER:#TCODE:E0001#SCODE:M0004#VTYPE:V#KBNodeID:32#KBPartNo:1#CONDITION:=#VALUE:发热"
ClassMethod ParseQueryEPRStr(AHeadQueryEPRStr As %String)
{
	///global for debug
	s ^DHCEPRDebug("EPRservice.BODataQueryService","FQueryStringEPR")=AHeadQueryEPRStr
	
	///去掉入参最前面的 " AND "
 	s EPRStr= ""
 	if (AHeadQueryEPRStr'="")
 	{	
 		s EPRStr=$E(AHeadQueryEPRStr,$F(AHeadQueryEPRStr," AND "),$L(AHeadQueryEPRStr))
 	}
 	quit:EPRStr=""
 	
 	///以AND分割查询条件,并遍历每个部分继续解析之
 	set AndItemCount = $LENGTH(EPRStr," AND ")	
 	for I=  1 :1:AndItemCount
 	{
   		SET aAndItem="" 
   		SET aAndItem=$PIECE(EPRStr," AND ",I)
   		set AOrStrStart = $Find(aAndItem," OR ")
   		///若其中有OR项, 解析之 
   		if (AOrStrStart>0)
   		{
     		set ^CacheTempDHCEPRRptCondition($J,"EPR",I)= "OR"
     
     		set ORItemCount = $LENGTH(aAndItem," OR ")
     		set EPRORCount  = 0
     		///解析每个OR项
     		For J=1:1:ORItemCount
     		{
	   			SET aORItem = $PIECE(aAndItem," OR ",J)  
	   			set TypeStr = $P($P(aORItem,"#",2),":",2)
       			if ((TypeStr="Simple")||(TypeStr="Segment")||(TypeStr="TextDesc")||(TypeStr="SegmentSimple")||(TypeStr="TextDescSimple")) 
	   			{ 
	   				set ^CacheTempDHCEPRRptCondition($J,"EPR",I,J)= "OR" 
         			set EPRORCount  = EPRORCount + 1
         			///Type
         			set ^CacheTempDHCEPRRptCondition($J,"EPR",I,EPRORCount,"Type")= $P($P(aORItem,"#",2),":",2)
       				///Tid Code
         			set ^CacheTempDHCEPRRptCondition($J,"EPR",I,EPRORCount,"TID")= $P($P(aORItem,"#",3),":",2)
         			///TVer
         			set ^CacheTempDHCEPRRptCondition($J,"EPR",I,EPRORCount,"TVER")= $P($P(aORItem,"#",4),":",2)
      
       				if (TypeStr="Simple")
       				{
       					set ^CacheTempDHCEPRRptCondition($J,"EPR",I,EPRORCount,"SCODE")= $P($P(aORItem,"#",5),":",2)
       					set ^CacheTempDHCEPRRptCondition($J,"EPR",I,EPRORCount,"VTYPE")= $P($P(aORItem,"#",6),":",2)
       					set ^CacheTempDHCEPRRptCondition($J,"EPR",I,EPRORCount,"CONDITION")= $P($P(aORItem,"#",7),":",2)
       					set ^CacheTempDHCEPRRptCondition($J,"EPR",I,EPRORCount,"VALUE")= $P($P(aORItem,"#",8),":",2)
	       			}
	       			elseif ((TypeStr="Segment")||(TypeStr="TextDesc"))
	       			{
		       			set ^CacheTempDHCEPRRptCondition($J,"EPR",I,EPRORCount,"SCODE")= $P($P(aORItem,"#",5),":",2)
		       			set ^CacheTempDHCEPRRptCondition($J,"EPR",I,EPRORCount,"CONDITION")= $P($P(aORItem,"#",6),":",2)
       					set ^CacheTempDHCEPRRptCondition($J,"EPR",I,EPRORCount,"VALUE")= $P($P(aORItem,"#",7),":",2)
		       		}
       				elseif (TypeStr="SegmentSimple")
       				{
	     				set ^CacheTempDHCEPRRptCondition($J,"EPR",I,EPRORCount,"TCODE")= $P($P(aORItem,"#",5),":",2)
	     				set ^CacheTempDHCEPRRptCondition($J,"EPR",I,EPRORCount,"SCODE")= $P($P(aORItem,"#",6),":",2)
         				set ^CacheTempDHCEPRRptCondition($J,"EPR",I,EPRORCount,"VTYPE")= $P($P(aORItem,"#",7),":",2)
         				set ^CacheTempDHCEPRRptCondition($J,"EPR",I,EPRORCount,"CONDITION")= $P($P(aORItem,"#",8),":",2)
         				set ^CacheTempDHCEPRRptCondition($J,"EPR",I,EPRORCount,"VALUE")= $P($P(aORItem,"#",9),":",2)  
	       			}
	   				elseif ((TypeStr="TextDescSimple")) 
	   				{
	     				set ^CacheTempDHCEPRRptCondition($J,"EPR",I,EPRORCount,"TCODE")= $P($P(aORItem,"#",5),":",2)
	     				set ^CacheTempDHCEPRRptCondition($J,"EPR",I,EPRORCount,"SCODE")= $P($P(aORItem,"#",6),":",2)
         				set ^CacheTempDHCEPRRptCondition($J,"EPR",I,EPRORCount,"VTYPE")= $P($P(aORItem,"#",7),":",2)
         				set ^CacheTempDHCEPRRptCondition($J,"EPR",I,EPRORCount,"KBNodeID")= $P($P(aORItem,"#",8),":",2)
         				set ^CacheTempDHCEPRRptCondition($J,"EPR",I,EPRORCount,"KBPartNo")= $P($P(aORItem,"#",9),":",2)
         				set ^CacheTempDHCEPRRptCondition($J,"EPR",I,EPRORCount,"CONDITION")= $P($P(aORItem,"#",10),":",2)
         				set ^CacheTempDHCEPRRptCondition($J,"EPR",I,EPRORCount,"VALUE")= $P($P(aORItem,"#",11),":",2)  
		   			}   
	   			}
	  		}
	  		set ^CacheTempDHCEPRRptCondition($J,"EPR",I,"COUNT")= EPRORCount
	 	}
     	///没有OR项
    	elseif (AOrStrStart=0)
    	{
	  		set TypeStr = $P($P(aAndItem,"#",2),":",2)
	  		if ((TypeStr="Simple")||(TypeStr="Segment")||(TypeStr="TextDesc")||(TypeStr="SegmentSimple")||(TypeStr="TextDescSimple")) 
      		{
       			set ^CacheTempDHCEPRRptCondition($J,"EPR",I)= "AND"
       			///Type
       			set ^CacheTempDHCEPRRptCondition($J,"EPR",I,"Type")= $P($P(aAndItem,"#",2),":",2)
       			///Tid Code
       			set ^CacheTempDHCEPRRptCondition($J,"EPR",I,"TID")= $P($P(aAndItem,"#",3),":",2)
       			///TVer 
       			set ^CacheTempDHCEPRRptCondition($J,"EPR",I,"TVER")= $P($P(aAndItem,"#",4),":",2)
       			if (TypeStr="Simple")
       			{
       				set ^CacheTempDHCEPRRptCondition($J,"EPR",I,"SCODE")= $P($P(aAndItem,"#",5),":",2)
       				set ^CacheTempDHCEPRRptCondition($J,"EPR",I,"VTYPE")= $P($P(aAndItem,"#",6),":",2)
       				set ^CacheTempDHCEPRRptCondition($J,"EPR",I,"CONDITION")= $P($P(aAndItem,"#",7),":",2)
       				set ^CacheTempDHCEPRRptCondition($J,"EPR",I,"VALUE")= $P($P(aAndItem,"#",8),":",2)
	       		}
	       		elseif ((TypeStr="Segment")||(TypeStr="TextDesc"))
	       		{
		       		set ^CacheTempDHCEPRRptCondition($J,"EPR",I,"SCODE")= $P($P(aAndItem,"#",5),":",2)
		       		set ^CacheTempDHCEPRRptCondition($J,"EPR",I,"CONDITION")= $P($P(aAndItem,"#",6),":",2)
       				set ^CacheTempDHCEPRRptCondition($J,"EPR",I,"VALUE")= $P($P(aAndItem,"#",7),":",2)
		       	}
       			elseif ((TypeStr="SegmentSimple"))
       			{
	   				set ^CacheTempDHCEPRRptCondition($J,"EPR",I,"TCODE")= $P($P(aAndItem,"#",5),":",2)    
       				set ^CacheTempDHCEPRRptCondition($J,"EPR",I,"SCODE")= $P($P(aAndItem,"#",6),":",2)
       				set ^CacheTempDHCEPRRptCondition($J,"EPR",I,"VTYPE")= $P($P(aAndItem,"#",7),":",2)
       				set ^CacheTempDHCEPRRptCondition($J,"EPR",I,"CONDITION")= $P($P(aAndItem,"#",8),":",2)
       				set ^CacheTempDHCEPRRptCondition($J,"EPR",I,"VALUE")= $P($P(aAndItem,"#",9),":",2)
	       		}
	   			elseif (TypeStr="TextDescSimple")
	   			{
	   				set ^CacheTempDHCEPRRptCondition($J,"EPR",I,"TCODE")= $P($P(aAndItem,"#",5),":",2)    
       				set ^CacheTempDHCEPRRptCondition($J,"EPR",I,"SCODE")= $P($P(aAndItem,"#",6),":",2)
       				set ^CacheTempDHCEPRRptCondition($J,"EPR",I,"VTYPE")= $P($P(aAndItem,"#",7),":",2)
       				set ^CacheTempDHCEPRRptCondition($J,"EPR",I,"KBNodeID")= $P($P(aAndItem,"#",8),":",2)
       				set ^CacheTempDHCEPRRptCondition($J,"EPR",I,"KBPartNo")= $P($P(aAndItem,"#",9),":",2)
       				set ^CacheTempDHCEPRRptCondition($J,"EPR",I,"CONDITION")= $P($P(aAndItem,"#",10),":",2)
       				set ^CacheTempDHCEPRRptCondition($J,"EPR",I,"VALUE")= $P($P(aAndItem,"#",11),":",2)
		   		}    
    		}
   		}
   	}
}

/// 解析查询条件中术语集相关部分,其格式为:
/// " AND #TYPE:Glossary#GID:34"
ClassMethod ParseQueryGlossaryStr(AHeadQueryGlossaryStr As %String)
{
	///b "s"
	
	///删除入参最前面的 " AND "
 	s GlossaryStr= ""
 	if (AHeadQueryGlossaryStr'="")
 	{	
 		s GlossaryStr=$E(AHeadQueryGlossaryStr,$F(AHeadQueryGlossaryStr," AND "),$L(AHeadQueryGlossaryStr))
 	}
 	quit:GlossaryStr=""
 	
 	///以 AND 分割查询条件，并解析其中的 OR 项
 	s ANDItemCount = $Length(GlossaryStr," AND ")
 	for I = 1:1:ANDItemCount
 	{
	 	s ANDItem = $Piece(GlossaryStr," AND ",I)
	 	s ORItemStart = $Find(ANDItem," OR ")
	 		 	
	 	if (ORItemStart > 0)	///包含 OR 项
	 	{
		 	s ^CacheTempDHCEPRRptCondition($J,"Glossary",I) = "OR"
		 	
		 	///解析 OR 项
		 	s ORItemCount = $Length(ANDItem," OR ")
		 	for J = 1:1:ORItemCount
		 	{
			 	s ORItem = $Piece(ANDItem," OR ",J)
			 	s ^CacheTempDHCEPRRptCondition($J,"Glossary",I,J) = "OR"
			 	s ^CacheTempDHCEPRRptCondition($J,"Glossary",I,J,"TYPE") = $P($P(ORItem,"#",2),":",2)
			 	s ^CacheTempDHCEPRRptCondition($J,"Glossary",I,J,"GID") = $P($P(ORItem,"#",3),":",2)
			 	s ^CacheTempDHCEPRRptCondition($J,"Glossary",I,J,"CONDITION") = $P($P(ORItem,"#",4),":",2)
			 	s ^CacheTempDHCEPRRptCondition($J,"Glossary",I,J,"VALUE") = $P($P(ORItem,"#",5),":",2)
			}
			//s ^CacheTempDHCEPRRptCondition($J,"Glossary",I,"COUNT") = ORItemCount
		}
	 	else	///不包含 OR 项
	 	{
		 	s ^CacheTempDHCEPRRptCondition($J,"Glossary",I) = "AND"
		 	s ^CacheTempDHCEPRRptCondition($J,"Glossary",I,"TYPE") = $P($P(ANDItem,"#",2),":",2)
		 	s ^CacheTempDHCEPRRptCondition($J,"Glossary",I,"GID") = $P($P(ANDItem,"#",3),":",2)
		 	s ^CacheTempDHCEPRRptCondition($J,"Glossary",I,"CONDITION") = $P($P(ANDItem,"#",4),":",2)
		 	s ^CacheTempDHCEPRRptCondition($J,"Glossary",I,"VALUE") = $P($P(ANDItem,"#",5),":",2)
		}
	 }
	 
	 do ..ParseGlossaryItemOfCondition()
}

/// 解析[术语集]对应的元数据项
ClassMethod ParseGlossaryItemOfCondition()
{
	//debug by houj
	//b "s"
	
	set I=$O(^CacheTempDHCEPRRptCondition($J,"Glossary",""))
	while I'=""
	{
		set nodeType=$G(^CacheTempDHCEPRRptCondition($J,"Glossary",I))
		if nodeType="AND"
		{
			///获取术语对应元数据项
			set glossaryID=^CacheTempDHCEPRRptCondition($J,"Glossary",I,"GID")
			set metaItemStr=##class(EPRmeta.Glossary).GetMetaItem(glossaryID)
			
			set itemCount=$Length(metaItemStr,"^")
			for count = 1:1:itemCount
			{
				set item=$piece(metaItemStr,"^",count)
				if (item'="")
				{
					/// 解析元数据项参数
					set type=$p($p(item,"#",2),":",2)
					set ^CacheTempDHCEPRRptCondition($J,"Glossary",I,"ITEM")=itemCount
					set ^CacheTempDHCEPRRptCondition($J,"Glossary",I,"ITEM",count,"TYPE")=type
					set ^CacheTempDHCEPRRptCondition($J,"Glossary",I,"ITEM",count,"TID")=$p($p(item,"#",3),":",2)
					if (type="Simple")
					{
						set ^CacheTempDHCEPRRptCondition($J,"Glossary",I,"ITEM",count,"SCODE")=$p($p(item,"#",5),":",2)
						set ^CacheTempDHCEPRRptCondition($J,"Glossary",I,"ITEM",count,"VTYPE")=$p($p(item,"#",6),":",2)
					}
					elseif (type="Segment")||(type="TextDesc")
					{
						set ^CacheTempDHCEPRRptCondition($J,"Glossary",I,"ITEM",count,"SCODE")=$p($p(item,"#",5),":",2)
					}
					elseif (type="SegmentSimple")
					{
						set ^CacheTempDHCEPRRptCondition($J,"Glossary",I,"ITEM",count,"TCODE")=$p($p(item,"#",5),":",2)
						set ^CacheTempDHCEPRRptCondition($J,"Glossary",I,"ITEM",count,"SCODE")=$p($p(item,"#",6),":",2)
						set ^CacheTempDHCEPRRptCondition($J,"Glossary",I,"ITEM",count,"VTYPE")=$p($p(item,"#",7),":",2)
					}
					elseif (type="TextDescSimple")
					{
						set ^CacheTempDHCEPRRptCondition($J,"Glossary",I,"ITEM",count,"TCODE")=$p($p(item,"#",5),":",2)
						set ^CacheTempDHCEPRRptCondition($J,"Glossary",I,"ITEM",count,"SCODE")=$p($p(item,"#",6),":",2)
						set ^CacheTempDHCEPRRptCondition($J,"Glossary",I,"ITEM",count,"VTYPE")=$p($p(item,"#",7),":",2)
						set ^CacheTempDHCEPRRptCondition($J,"Glossary",I,"ITEM",count,"KBNodeID")=$p($p(item,"#",8),":",2)
						set ^CacheTempDHCEPRRptCondition($J,"Glossary",I,"ITEM",count,"KBPartNo")=$p($p(item,"#",9),":",2)
					}
				}
			}
		}
		elseif nodeType="OR"
		{
			///遍历[OR]节点下的[术语]
			set J=$O(^CacheTempDHCEPRRptCondition($J,"Glossary",I,""))
			while J'=""
			{
				//debug by houj
				//b "s"
				
				///获取术语对应元数据项
				set glossaryID=^CacheTempDHCEPRRptCondition($J,"Glossary",I,J,"GID")
				set metaItemStr=##class(EPRmeta.Glossary).GetMetaItem(glossaryID)
				
				set itemCount=$Length(metaItemStr,"^")
				set ^CacheTempDHCEPRRptCondition($J,"Glossary",I,J,"ITEM")=itemCount
				for count = 1:1:itemCount
				{
					set item=$piece(metaItemStr,"^",count)
					if (item'="")
					{
						/// 解析元数据项参数
						set type=$p($p(item,"#",2),":",2)
						set ^CacheTempDHCEPRRptCondition($J,"Glossary",I,J,"ITEM",count,"TYPE")=type
						set ^CacheTempDHCEPRRptCondition($J,"Glossary",I,J,"ITEM",count,"TID")=$p($p(item,"#",3),":",2)
						if (type="Simple")
						{
							set ^CacheTempDHCEPRRptCondition($J,"Glossary",I,J,"ITEM",count,"SCODE")=$p($p(item,"#",5),":",2)
							set ^CacheTempDHCEPRRptCondition($J,"Glossary",I,J,"ITEM",count,"VTYPE")=$p($p(item,"#",6),":",2)
						}
						elseif (type="Segment")||(type="TextDesc")
						{
							set ^CacheTempDHCEPRRptCondition($J,"Glossary",I,J,"ITEM",count,"SCODE")=$p($p(item,"#",5),":",2)
						}
						elseif (type="SegmentSimple")
						{
							set ^CacheTempDHCEPRRptCondition($J,"Glossary",I,J,"ITEM",count,"TCODE")=$p($p(item,"#",5),":",2)
							set ^CacheTempDHCEPRRptCondition($J,"Glossary",I,J,"ITEM",count,"SCODE")=$p($p(item,"#",6),":",2)
							set ^CacheTempDHCEPRRptCondition($J,"Glossary",I,J,"ITEM",count,"VTYPE")=$p($p(item,"#",7),":",2)
						}
						elseif (type="TextDescSimple")
						{
							set ^CacheTempDHCEPRRptCondition($J,"Glossary",I,J,"ITEM",count,"TCODE")=$p($p(item,"#",5),":",2)
							set ^CacheTempDHCEPRRptCondition($J,"Glossary",I,J,"ITEM",count,"SCODE")=$p($p(item,"#",6),":",2)
							set ^CacheTempDHCEPRRptCondition($J,"Glossary",I,J,"ITEM",count,"VTYPE")=$p($p(item,"#",7),":",2)
							set ^CacheTempDHCEPRRptCondition($J,"Glossary",I,J,"ITEM",count,"KBNodeID")=$p($p(item,"#",8),":",2)
							set ^CacheTempDHCEPRRptCondition($J,"Glossary",I,J,"ITEM",count,"KBPartNo")=$p($p(item,"#",9),":",2)
						}
					}
				}
				
				set J=$O(^CacheTempDHCEPRRptCondition($J,"Glossary",I,J))
			}
		}
		
		set I=$O(^CacheTempDHCEPRRptCondition($J,"Glossary",I))
	}
}

/// 解析查询条件中LIS数据相关部分
ClassMethod ParseQueryLISStr(ALISStr)
{
}

/// 解析查询条件中PACS数据相关部分
ClassMethod ParseQueryPACSStr(APACSStr)
{
}

/// 解析报表头相关部分
ClassMethod ParseQueryResultColumn(AQueryColStr As %String)
{
	///global for debug
	s ^DHCEPRDebug("EPRservice.BODataQueryService","GQueryResultColumn")=AQueryColStr
	
	///清空需要的临时global
  	K ^CacheTempDHCEPRRptColumn($J)
  	K ^CacheTempDHCEPRRptSysResult($J)
   
  	quit:AQueryColStr=""
  
  	///报表头项总数
  	set ResultColItemCount = $LENGTH(AQueryColStr,",")
  	set ^CacheTempDHCEPRRptSysResult($J,"ResultColCount")= ResultColItemCount
  	
  	///遍历所有报表头项,解析之
  	set ResultColCount = 0  
    for I=  1:1:ResultColItemCount
    { 
    	SET aResultColItem=$PIECE(AQueryColStr,",",I)
      	set ResultColCount = ResultColCount + 1
      	///是否含有聚合条件
      	set AGroupStrStart = $Find(aResultColItem,"#GROUP:")
      	if (AGroupStrStart=0)
       	{ 
       		set TypeStr = $P($P(aResultColItem,"#",2),":",2) 
       	}
      	elseif (AGroupStrStart'=0)
      	{
	    	set TypeStr = $P($P(aResultColItem,"#",3),":",2)   
	    } 
	    
	    ///按照数据的“类型”解析之
      	if (TypeStr="Episode")
      	{ 
        	if (AGroupStrStart=0)
        	{
                set ^CacheTempDHCEPRRptColumn($J,ResultColCount,"Type")= $P($P(aResultColItem,"#",2),":",2)
                set ^CacheTempDHCEPRRptColumn($J,ResultColCount,"FTYPE")= $P($P(aResultColItem,"#",3),":",2)
                set ^CacheTempDHCEPRRptColumn($J,ResultColCount,"FNAME")= $P($P(aResultColItem,"#",4),":",2)    
	  		}
	  		elseif (AGroupStrStart'=0)
	  		{
                set ^CacheTempDHCEPRRptColumn($J,ResultColCount,"GROUP")= $P($P(aResultColItem,"#",2),":",2)
                set ^CacheTempDHCEPRRptColumn($J,ResultColCount,"Type")= $P($P(aResultColItem,"#",3),":",2)
                set ^CacheTempDHCEPRRptColumn($J,ResultColCount,"FTYPE")= $P($P(aResultColItem,"#",4),":",2)
                set ^CacheTempDHCEPRRptColumn($J,ResultColCount,"FNAME")= $P($P(aResultColItem,"#",5),":",2)
        		set SymbolCount = $L(aResultColItem,"#")
        		if (SymbolCount=7)
        		{
	        		set ^CacheTempDHCEPRRptColumn($J,ResultColCount,"CONDITION")= $P($P(aResultColItem,"#",6),":",2)
                  	set ^CacheTempDHCEPRRptColumn($J,ResultColCount,"VALUE")= $P($P(aResultColItem,"#",7),":",2) 
        		}
       
	   		}    
      	}
      	elseif ((TypeStr="Simple")||(TypeStr="Segment")||(TypeStr="TextDesc"))
      	{
	      	if (AGroupStrStart=0)
        	{
                set ^CacheTempDHCEPRRptColumn($J,ResultColCount,"Type")= $P($P(aResultColItem,"#",2),":",2)
                set ^CacheTempDHCEPRRptColumn($J,ResultColCount,"TID")= $P($P(aResultColItem,"#",3),":",2)
                set ^CacheTempDHCEPRRptColumn($J,ResultColCount,"TVER")= $P($P(aResultColItem,"#",4),":",2)
                set ^CacheTempDHCEPRRptColumn($J,ResultColCount,"SCODE")= $P($P(aResultColItem,"#",5),":",2)
        		set ^CacheTempDHCEPRRptColumn($J,ResultColCount,"VTYPE")= $P($P(aResultColItem,"#",6),":",2)
        	}
        	elseif (AGroupStrStart>0)
	  		{
        		set ^CacheTempDHCEPRRptColumn($J,ResultColCount,"GROUP")= $P($P(aResultColItem,"#",2),":",2)
        		set ^CacheTempDHCEPRRptColumn($J,ResultColCount,"Type")= $P($P(aResultColItem,"#",3),":",2)
        		set ^CacheTempDHCEPRRptColumn($J,ResultColCount,"TID")= $P($P(aResultColItem,"#",4),":",2)
        		set ^CacheTempDHCEPRRptColumn($J,ResultColCount,"TVER")= $P($P(aResultColItem,"#",5),":",2)
        		set ^CacheTempDHCEPRRptColumn($J,ResultColCount,"SCODE")= $P($P(aResultColItem,"#",6),":",2)
        		set ^CacheTempDHCEPRRptColumn($J,ResultColCount,"VTYPE")= $P($P(aResultColItem,"#",7),":",2)
        		
        		set SymbolCount = $L(aResultColItem,"#")
        		if (SymbolCount=9)
        		{
         			set ^CacheTempDHCEPRRptColumn($J,ResultColCount,"CONDITION")= $P($P(aResultColItem,"#",8),":",2)
         			set ^CacheTempDHCEPRRptColumn($J,ResultColCount,"VALUE")= $P($P(aResultColItem,"#",9),":",2) 
        		}
        	}	
	    }
	    elseif (TypeStr="SegmentSimple")
	    {
		    if (AGroupStrStart=0)
        	{
	        	set ^CacheTempDHCEPRRptColumn($J,ResultColCount,"Type")= $P($P(aResultColItem,"#",2),":",2)
                set ^CacheTempDHCEPRRptColumn($J,ResultColCount,"TID")= $P($P(aResultColItem,"#",3),":",2)
                set ^CacheTempDHCEPRRptColumn($J,ResultColCount,"TVER")= $P($P(aResultColItem,"#",4),":",2)
                set ^CacheTempDHCEPRRptColumn($J,ResultColCount,"TCODE")= $P($P(aResultColItem,"#",5),":",2)
          		set ^CacheTempDHCEPRRptColumn($J,ResultColCount,"SCODE")= $P($P(aResultColItem,"#",6),":",2)
          		set ^CacheTempDHCEPRRptColumn($J,ResultColCount,"VTYPE")= $P($P(aResultColItem,"#",7),":",2)
	        }
	        elseif (AGroupStrStart>0)
	  		{
        		set ^CacheTempDHCEPRRptColumn($J,ResultColCount,"GROUP")= $P($P(aResultColItem,"#",2),":",2)
        		set ^CacheTempDHCEPRRptColumn($J,ResultColCount,"Type")= $P($P(aResultColItem,"#",3),":",2)
        		set ^CacheTempDHCEPRRptColumn($J,ResultColCount,"TID")= $P($P(aResultColItem,"#",4),":",2)
        		set ^CacheTempDHCEPRRptColumn($J,ResultColCount,"TVER")= $P($P(aResultColItem,"#",5),":",2)
        		set ^CacheTempDHCEPRRptColumn($J,ResultColCount,"TCODE")= $P($P(aResultColItem,"#",6),":",2)
        		set ^CacheTempDHCEPRRptColumn($J,ResultColCount,"SCODE")= $P($P(aResultColItem,"#",7),":",2)
        		set ^CacheTempDHCEPRRptColumn($J,ResultColCount,"VTYPE")= $P($P(aResultColItem,"#",8),":",2)
        		
        		set SymbolCount = $L(aResultColItem,"#")
        		if (SymbolCount=10)
        		{
         			set ^CacheTempDHCEPRRptColumn($J,ResultColCount,"CONDITION")= $P($P(aResultColItem,"#",9),":",2)
         			set ^CacheTempDHCEPRRptColumn($J,ResultColCount,"VALUE")= $P($P(aResultColItem,"#",10),":",2) 
        		}
	  		}
		}
		elseif (TypeStr="TextDescSimple")
	    {
		    if (AGroupStrStart=0)
        	{
	        	set ^CacheTempDHCEPRRptColumn($J,ResultColCount,"Type")= $P($P(aResultColItem,"#",2),":",2)
                set ^CacheTempDHCEPRRptColumn($J,ResultColCount,"TID")= $P($P(aResultColItem,"#",3),":",2)
                set ^CacheTempDHCEPRRptColumn($J,ResultColCount,"TVER")= $P($P(aResultColItem,"#",4),":",2)
                set ^CacheTempDHCEPRRptColumn($J,ResultColCount,"TCODE")= $P($P(aResultColItem,"#",5),":",2)
          		set ^CacheTempDHCEPRRptColumn($J,ResultColCount,"SCODE")= $P($P(aResultColItem,"#",6),":",2)
          		set ^CacheTempDHCEPRRptColumn($J,ResultColCount,"VTYPE")= $P($P(aResultColItem,"#",7),":",2)
	        	set ^CacheTempDHCEPRRptColumn($J,ResultColCount,"KBNodeID")= $P($P(aResultColItem,"#",8),":",2)   
               	set ^CacheTempDHCEPRRptColumn($J,ResultColCount,"KBPartNo")= $P($P(aResultColItem,"#",9),":",2)
	        }
	        elseif (AGroupStrStart'=0)
	        {
        		set ^CacheTempDHCEPRRptColumn($J,ResultColCount,"GROUP")= $P($P(aResultColItem,"#",2),":",2)
        		set ^CacheTempDHCEPRRptColumn($J,ResultColCount,"Type")= $P($P(aResultColItem,"#",3),":",2)
        		set ^CacheTempDHCEPRRptColumn($J,ResultColCount,"TID")= $P($P(aResultColItem,"#",4),":",2)
        		set ^CacheTempDHCEPRRptColumn($J,ResultColCount,"TVER")= $P($P(aResultColItem,"#",5),":",2)
        		set ^CacheTempDHCEPRRptColumn($J,ResultColCount,"TCODE")= $P($P(aResultColItem,"#",6),":",2)
        		set ^CacheTempDHCEPRRptColumn($J,ResultColCount,"SCODE")= $P($P(aResultColItem,"#",7),":",2)
        		set ^CacheTempDHCEPRRptColumn($J,ResultColCount,"VTYPE")= $P($P(aResultColItem,"#",8),":",2)
        		set ^CacheTempDHCEPRRptColumn($J,ResultColCount,"KBNodeID")= $P($P(aResultColItem,"#",9),":",2) 
         		set ^CacheTempDHCEPRRptColumn($J,ResultColCount,"KBPartNo")= $P($P(aResultColItem,"#",10),":",2) 
		        
		        set SymbolCount = $L(aResultColItem,"#")
		        if (SymbolCount=12)
        		{
         			set ^CacheTempDHCEPRRptColumn($J,ResultColCount,"CONDITION")= $P($P(aResultColItem,"#",11),":",2)
         			set ^CacheTempDHCEPRRptColumn($J,ResultColCount,"VALUE")= $P($P(aResultColItem,"#",12),":",2)         
        		}
		    }
		}
		elseif (TypeStr="Glossary")
		{
			if (AGroupStrStart=0)
			{
				set ^CacheTempDHCEPRRptColumn($J,ResultColCount,"Type")= $P($P(aResultColItem,"#",2),":",2)
				set ^CacheTempDHCEPRRptColumn($J,ResultColCount,"GID")= $P($P(aResultColItem,"#",3),":",2)
			}
			else
			{
				set ^CacheTempDHCEPRRptColumn($J,ResultColCount,"GROUP")= $P($P(aResultColItem,"#",2),":",2)
				set ^CacheTempDHCEPRRptColumn($J,ResultColCount,"Type")= $P($P(aResultColItem,"#",3),":",2)
				set ^CacheTempDHCEPRRptColumn($J,ResultColCount,"GID")= $P($P(aResultColItem,"#",4),":",2)
				
				set SymbolCount = $L(aResultColItem,"#")
		        if (SymbolCount=6)
        		{
         			set ^CacheTempDHCEPRRptColumn($J,ResultColCount,"CONDITION")= $P($P(aResultColItem,"#",5),":",2)
         			set ^CacheTempDHCEPRRptColumn($J,ResultColCount,"VALUE")= $P($P(aResultColItem,"#",6),":",2)         
        		}
			}
			
		}
		elseif (TypeStr = "LIS")
		{}
		elseif (TypeStr = "PACS")
		{}
		      	
  	} ///遍历所有报表项结束
  	
  	do ..ParseGlossaryItemOfResult()
}

ClassMethod ParseGlossaryItemOfResult()
{
	set I=$O(^CacheTempDHCEPRRptColumn($J,""))
	while I'=""
	{
		set nodeType=$G(^CacheTempDHCEPRRptColumn($J,I,"Type"))
		if nodeType = "Glossary"
		{
			///获取术语对应元数据项
			set glossaryID=^CacheTempDHCEPRRptColumn($J,I,"GID")
			set metaItemStr=##class(EPRmeta.Glossary).GetMetaItem(glossaryID)
			
			if metaItemStr '= ""
			{
			set itemCount=$Length(metaItemStr,"^")
			set ^CacheTempDHCEPRRptColumn($J,I,"ITEM")=itemCount
			for count = 1:1:itemCount
			{
				//debug by houj
				//b "s"
				set item=$piece(metaItemStr,"^",count)
				if (item'="")
				{
					/// 解析元数据项参数
					set type=$p($p(item,"#",2),":",2)
					set ^CacheTempDHCEPRRptColumn($J,I,"ITEM",count,"TYPE")=type
					set ^CacheTempDHCEPRRptColumn($J,I,"ITEM",count,"TID")=$p($p(item,"#",3),":",2)
					set ^CacheTempDHCEPRRptColumn($J,I,"ITEM",count,"DESC")=$p(item,"#",1)
					if (type="Simple")
					{
						set ^CacheTempDHCEPRRptColumn($J,I,"ITEM",count,"SCODE")=$p($p(item,"#",5),":",2)
						set ^CacheTempDHCEPRRptColumn($J,I,"ITEM",count,"VTYPE")=$p($p(item,"#",6),":",2)
					}
					elseif (type="Segment")||(type="TextDesc")
					{
						set ^CacheTempDHCEPRRptColumn($J,I,"ITEM",count,"SCODE")=$p($p(item,"#",5),":",2)
					}
					elseif (type="SegmentSimple")
					{
						set ^CacheTempDHCEPRRptColumn($J,I,"ITEM",count,"TCODE")=$p($p(item,"#",5),":",2)
						set ^CacheTempDHCEPRRptColumn($J,I,"ITEM",count,"SCODE")=$p($p(item,"#",6),":",2)
						set ^CacheTempDHCEPRRptColumn($J,I,"ITEM",count,"VTYPE")=$p($p(item,"#",7),":",2)
					}
					elseif (type="TextDescSimple")
					{
						set ^CacheTempDHCEPRRptColumn($J,I,"ITEM",count,"TCODE")=$p($p(item,"#",5),":",2)
						set ^CacheTempDHCEPRRptColumn($J,I,"ITEM",count,"SCODE")=$p($p(item,"#",6),":",2)
						set ^CacheTempDHCEPRRptColumn($J,I,"ITEM",count,"VTYPE")=$p($p(item,"#",7),":",2)
						set ^CacheTempDHCEPRRptColumn($J,I,"ITEM",count,"KBNodeID")=$p($p(item,"#",8),":",2)
						set ^CacheTempDHCEPRRptColumn($J,I,"ITEM",count,"KBPartNo")=$p($p(item,"#",9),":",2)
					}
				}
			}
			}
		}
		
		set I=$O(^CacheTempDHCEPRRptColumn($J,I))
	}	//end of while loop
}

/// 筛选符合查询条件的episodeId集合, 将其放到临时global 
ClassMethod FilterAdmIdByCondition()
{
	///筛选符合就诊信息条件的episodeId集合
 	Do ##class(EPRservice.BODataQueryService).FilterAdmIdByPatInfoCondition()
 
 	///筛选符合电子病历信息条件的episodeId集合
 	Do ##class(EPRservice.BODataQueryService).FilterAdmIdByEPRDataCondition()
 	
 	///筛选符合术语集条件的episodeId集合
 	Do ##class(EPRservice.BODataQueryService).FilterAdmIdByGlossaryCondition()
 	
 	///筛选符合LIS数据查询条件的episodeId集合
 	Do ..FilterAdmIdByLISCondition()
 	
 	///筛选符合PACS数据查询条件的episodeId集合
 	Do ..FilterAdmIdByPACSCondition()
}

/// 筛选符合就诊信息条件的episodeId集合,将其放到临时global ^CacheTempDHCEPRRptAdmID($J,"EpisodeFilter")
/// 
/// 筛选时,使用就诊信息条件的优先顺序为: DisDateTime条件 > AdmDateTime条件 > 其它类型就诊信息条件, 
/// (维护端传来的就诊信息条件中至少有一个DisDateTime或者AdmDateTime)
/// 
/// 步骤如下：		
/// <1> 利用PA_Adm表的索引筛选episodeId并将结果集存在临时global ^CacheTempDHCEPRRptAdmID($J,"DateFilter"), 
/// 	索引使用的优先顺序为: 出院日期索引 > 入院日期索引,
/// 	即若有DisDateTime条件就使用出院日期索引,若无DisDateTime条件则使用入院日期索引.
/// <2>	利用除DisDateTime条件之外的其他条件进一步筛选临时global ^CacheTempDHCEPRRptAdmID($J,"DateFilter")中的AdmID
/// 	并将结果集放在临时global ^CacheTempDHCEPRRptAdmID($J,"EpisodeFilter")
ClassMethod FilterAdmIdByPatInfoCondition()
{
	///b "s"
 	
 	K ^CacheTempDHCEPRRptAdmID($J,"DateFilter")
 	K ^CacheTempDHCEPRRptAdmID($J,"EpisodeFilter")
    
 	/// 遍历已解析的就诊信息条件，找到出院日期相关的部分
 	/// 若有DisDateTime条件,利用PA_Adm表的"出院日期索引"筛选episodeId 
 	set BgnDataValue=""
 	set EndDataValue=""
 	set BgnOP=""
 	set EndOP=""
 	Set ADischaDateCount = $G(^CacheTempQueryEpisodeCount($J,"DischageDataCount"))          ///DisDateTime条件的个数
 	set completeDisDateCount = 0    ///完整的DisDateTime条件的个数(即CONDITION和VALUE均不为空的DisDateTime条件的个数) 
 	
 	Set AEpisodeKey = $ORDER(^CacheTempDHCEPRRptCondition($J,"Episode",""))
 	WHILE (AEpisodeKey'="") 
 	{  
  		set LogicFlag = $G(^CacheTempDHCEPRRptCondition($J,"Episode",AEpisodeKey))
  		if (LogicFlag="AND")
  		{ 
    		set DataItemName = $G(^CacheTempDHCEPRRptCondition($J,"Episode",AEpisodeKey,"FNAME"))
    		set CONDITIONOP = $G(^CacheTempDHCEPRRptCondition($J,"Episode",AEpisodeKey,"CONDITION"))
    		set DataValue = $G(^CacheTempDHCEPRRptCondition($J,"Episode",AEpisodeKey,"VALUE"))
    		if ($zcvt(DataItemName,"U")="DISDATETIME")&&(CONDITIONOP'="")&&(DataValue'="")
    		{   
    			s completeDisDateCount=completeDisDateCount + 1
		  		if (completeDisDateCount=1)  
		  		{
			 		s BgnDataValue= DataValue 
			 		s BgnOP= CONDITIONOP
			  	}
		  		Elseif(completeDisDateCount>1)
		  		{
			 		s EndDataValue= DataValue 
			 		s EndOP= CONDITIONOP
			  	}    	  
			}
  		}
  		SET AEpisodeKey = $ORDER(^CacheTempDHCEPRRptCondition($J,"Episode",AEpisodeKey))
 	}

 	if (completeDisDateCount=1)
 	{	d ##class(EPRservice.BODataQueryService).CheckDisDateTime(BgnDataValue,BgnOP,"","") }
 	Elseif (completeDisDateCount>1)
 	{ 	d ##class(EPRservice.BODataQueryService).CheckDisDateTime(BgnDataValue,BgnOP,EndDataValue,EndOP)}
	
 	
 	///若就诊信息条件中无 DisDateTime，则使用PA_Adm表的"入院日期索引"筛选所有episodeId
 	if (completeDisDateCount=0)
 	{
	 	s ADMBgnDataValue=""
   		s ADMEndDataValue=""
   		s ADMBgnOP=""
   		s ADMEndOP=""
   		Set ADMDataTimeCount = $G(^CacheTempQueryEpisodeCount($J,"ADMDataCount"))	           ///AdmDateTime条件的个数	 
  		s completeAdmDateCount = 0     ///完整的AdmDateTime条件的个数(即CONDITION和VALUE均不为空的DisDateTime条件的个数) 
  		
  		Set AEpisodeKey = $ORDER(^CacheTempDHCEPRRptCondition($J,"Episode",""))
  		WHILE (AEpisodeKey'="") 
  		{  
  			set LogicFlag = $G(^CacheTempDHCEPRRptCondition($J,"Episode",AEpisodeKey))
  			if (LogicFlag="AND")
  			{ 
    			set DataItemName = $G(^CacheTempDHCEPRRptCondition($J,"Episode",AEpisodeKey,"FNAME"))
    			set CONDITIONOP = $G(^CacheTempDHCEPRRptCondition($J,"Episode",AEpisodeKey,"CONDITION"))
    			set DataValue = $G(^CacheTempDHCEPRRptCondition($J,"Episode",AEpisodeKey,"VALUE"))
    			if ($zcvt(DataItemName,"U")="ADMDATETIME")&&(CONDITIONOP'="")&&(DataValue'="") 
    			{   
    				s completeAdmDateCount=completeAdmDateCount + 1	    
	     			if (completeAdmDateCount=1)  
		  			{ 
		  				s ADMBgnDataValue= DataValue 
			 			s ADMBgnOP= CONDITIONOP
			  		}
		  			Elseif(completeAdmDateCount>1)
		  			{ 
		  				s ADMEndDataValue= DataValue 
			 			s ADMEndOP= CONDITIONOP
			  		}    	  
				}
  			}
  			SET AEpisodeKey = $ORDER(^CacheTempDHCEPRRptCondition($J,"Episode",AEpisodeKey))
 		}
  
  		if (completeAdmDateCount=1)
  		{	d ##class(EPRservice.BODataQueryService).CheckAdmDateTime(ADMBgnDataValue,ADMBgnOP,"","")   }
  		Elseif (completeAdmDateCount>1)
  		{ 	d ##class(EPRservice.BODataQueryService).CheckAdmDateTime(ADMBgnDataValue,ADMBgnOP,ADMEndDataValue,ADMEndOP) }
 	}
 	
 	///debug
 	///b "s"
 	
 	/// 遍历^CacheTempEPRDateTimeADMID中的episodeId集合,使用除DisDateTime之外的其它就诊信息条件筛选episodeId
    set FilterAdmId = $ORDER(^CacheTempDHCEPRRptAdmID($J,"DateFilter",""))
 	While (FilterAdmId '="")
 	{ 
 		s FilterAdmidFlag ="True"
 		///遍历就诊信息条件，若有任何节点的条件不满足就筛掉该episodeId
   		Set AEpisodeKey = $ORDER(^CacheTempDHCEPRRptCondition($J,"Episode",""))
 		WHILE (AEpisodeKey'="") 
 		{
  			Q:(FilterAdmidFlag ="False")
  			set LogicFlag = $G(^CacheTempDHCEPRRptCondition($J,"Episode",AEpisodeKey))
  			if (LogicFlag="AND")
  			{ 
  				set DataItemName=$G(^CacheTempDHCEPRRptCondition($J,"Episode",AEpisodeKey,"FNAME"))
  				set DataItemType=$G(^CacheTempDHCEPRRptCondition($J,"Episode",AEpisodeKey,"FTYPE"))
    			set CONDITIONOP=$G(^CacheTempDHCEPRRptCondition($J,"Episode",AEpisodeKey,"CONDITION"))
    			set ConValue = $G(^CacheTempDHCEPRRptCondition($J,"Episode",AEpisodeKey,"VALUE"))
				set DataItemValue=##class(EPRservice.SystemData).GetEpisodeInfoByItemName(DataItemName,FilterAdmId)
				///set DataItemType=##class(EPRmeta.EpisodeDataItem).GetDataTypeByFieldName(DataItemName)
				
				if DataItemType="String"
				{
					set FilterAdmidFlag=..CheckConExpressionOfString(DataItemValue,CONDITIONOP,ConValue)
				}
				elseif DataItemType="DateTime"
				{
					///转换成cache内部日期时间格式，再计算逻辑表达式
					if ConValue '= ""
					{	set ConValue=$zdh(ConValue,3)}
					set FilterAdmidFlag=..CheckConExpressionOfDateTime(DataItemValue,CONDITIONOP,ConValue)
				}
				elseif DataItemType="Numeric"
				{
					set FilterAdmidFlag=..CheckConExpressionOfNumeric(DataItemValue,CONDITIONOP,ConValue)
				}
  			}
  			Elseif (LogicFlag="OR" )
  			{
	  			///逻辑运算OR优先
	  			///OR节点中任一条件满足，就认为该节点的条件成立
   				set ORAdmidFlag = "False"
   				Set ORItemCount = $G(^CacheTempDHCEPRRptCondition($J,"Episode",AEpisodeKey,"COUNT"))
   				for I=1:1:ORItemCount
   				{  
   					Q:(ORAdmidFlag="True")
      				set DataItemName = $G(^CacheTempDHCEPRRptCondition($J,"Episode",AEpisodeKey,I,"FNAME"))
      				set DataItemType=$G(^CacheTempDHCEPRRptCondition($J,"Episode",AEpisodeKey,"FTYPE"))
      				set CONDITIONOP = $G(^CacheTempDHCEPRRptCondition($J,"Episode",AEpisodeKey,I,"CONDITION"))
     				set ConValue = $G(^CacheTempDHCEPRRptCondition($J,"Episode",AEpisodeKey,I,"VALUE"))
     				set DataItemValue=##class(EPRservice.SystemData).GetEpisodeInfoByItemName(DataItemName,FilterAdmId)
					///set DataItemType=##class(EPRmeta.EpisodeDataItem).GetDataTypeByFieldName(DataItemName)
				
					if DataItemType="String"
					{
						set ORAdmidFlag=..CheckConExpressionOfString(DataItemValue,CONDITIONOP,ConValue)
					}
					elseif DataItemType="DateTime"
					{
						set ConValue=$zdh(ConValue,3)
						set ORAdmidFlag=..CheckConExpressionOfDateTime(DataItemValue,CONDITIONOP,ConValue)
					}
					elseif DataItemType="Numeric"
					{
						set ORAdmidFlag=..CheckConExpressionOfNumeric(DataItemValue,CONDITIONOP,ConValue)
					}
	 			}
    			
    			if (ORAdmidFlag="False")
     			{ 	s FilterAdmidFlag= "False"  }
     		}
    		SET AEpisodeKey = $ORDER(^CacheTempDHCEPRRptCondition($J,"Episode",AEpisodeKey))
  		}
  		
  		///所有就诊信息条件都满足，将该episodeId存入临时global ^CacheTempEPREpisodeADMID
  		if (FilterAdmidFlag="True")	 
   		{ 	
   			S ^CacheTempDHCEPRRptAdmID($J,"EpisodeFilter",FilterAdmId) =FilterAdmId  
   		}
   		
    	set FilterAdmId = $ORDER(^CacheTempDHCEPRRptAdmID($J,"DateFilter",FilterAdmId))	 
	}
}

/// 利用 就诊日期时间 筛选episodeId
ClassMethod CheckAdmDateTime(ABgnDataValue As %String, ABgnCONDITIONOP As %String, AEndDataValue As %String, AEndCONDITIONOP As %String)
{
	D ##class(EPRservice.BODataQueryService).CheckDATETIME(ABgnDataValue,ABgnCONDITIONOP,AEndDataValue,AEndCONDITIONOP,"PAADM_AdmDate")
}

/// 利用 出院日期时间 筛选episodeId
ClassMethod CheckDisDateTime(ABgnDataValue As %String, ABgnCONDITIONOP As %String, AEndDataValue As %String, AEndCONDITIONOP As %String)
{
	D ##class(EPRservice.BODataQueryService).CheckDATETIME(ABgnDataValue,ABgnCONDITIONOP,AEndDataValue,AEndCONDITIONOP,"DischDate")
}

/// 利用 日期时间 筛选episodeId
ClassMethod CheckDATETIME(BgnDataValue As %String, BgnCONDITIONOP As %String, EndDataValue As %String, EndCONDITIONOP As %String, AIndexName As %String)
{
 if (EndDataValue="")
  { s argDate=$zdh(BgnDataValue,3)
    if ((BgnCONDITIONOP=">="))
    {  s argDate=argDate-1,AdmId=0
	   s argDate=$o(^PAADMi(AIndexName,argDate))
	   While ( argDate'="") 
	   { 
		 s AdmId=$o(^PAADMi(AIndexName,argDate,""))
		 While (AdmId '="")  
		 {s ^CacheTempDHCEPRRptAdmID($J,"DateFilter",AdmId)=AdmId	 
		 s AdmId=$o(^PAADMi(AIndexName,argDate,AdmId))	 }
		
		s argDate=$o(^PAADMi(AIndexName,argDate)) 
		}
	 }
   elseif ((BgnCONDITIONOP="<=" ))
   { s argDate=argDate+1,AdmId=0
	 s argDate=$o(^PAADMi(AIndexName,argDate),-1)
	 While ( argDate'="") 
	{ s AdmId=$o(^PAADMi(AIndexName,argDate,""))
	  While (AdmId '="")  
	  { s ^CacheTempDHCEPRRptAdmID($J,"DateFilter",AdmId)=AdmId	 
		s AdmId=$o(^PAADMi(AIndexName,argDate,AdmId)) }
		
	 s argDate=$o(^PAADMi(AIndexName,argDate),-1) 
	 }
	}
	elseif (BgnCONDITIONOP="=")     
	  { s AdmId=$o(^PAADMi(AIndexName,argDate,""))
		While (AdmId '="")  
		{ s ^CacheTempDHCEPRRptAdmID($J,"DateFilter",AdmId)=AdmId	 
		  s AdmId=$o(^PAADMi(AIndexName,argDate,AdmId))	 }
		     }
	elseif ((BgnCONDITIONOP="<")) 
	{ s argDate=argDate,AdmId=0
	  s argDate=$o(^PAADMi(AIndexName,argDate),-1)
	  While ( argDate'="") 
	  { s AdmId=$o(^PAADMi(AIndexName,argDate,""))
		While (AdmId '="")  
		{ s ^CacheTempDHCEPRRptAdmID($J,"DateFilter",AdmId)=AdmId	 
		  s AdmId=$o(^PAADMi(AIndexName,argDate,AdmId))	 
		 }
		  s argDate=$o(^PAADMi(AIndexName,argDate),-1) 
		}
	}   
	elseif ((BgnCONDITIONOP=">")) 
	{  s argDate=argDate,AdmId=0
	   s argDate=$o(^PAADMi(AIndexName,argDate))
		While ( argDate'="") 
		{ s AdmId=$o(^PAADMi(AIndexName,argDate,""))
			 While (AdmId '="")  
			 {
			  s ^CacheTempDHCEPRRptAdmID($J,"DateFilter",AdmId)=AdmId	 
			  s AdmId=$o(^PAADMi(AIndexName,argDate,AdmId))	 
				 }
			  s argDate=$o(^PAADMi(AIndexName,argDate)) 
			   }
			 }   
	elseif ((BgnCONDITIONOP="<>")) 
	{
		   s argOldDate =argDate
		   s argDate=argOldDate,AdmId=0
		   s argDate=$o(^PAADMi(AIndexName,argDate),-1)
		   While ( argDate'="") 
		   {
			 s AdmId=$o(^PAADMi(AIndexName,argDate,""))
			 While (AdmId '="")  
			 {
			  s ^CacheTempDHCEPRRptAdmID($J,"DateFilter",AdmId)=AdmId	 
			  s AdmId=$o(^PAADMi(AIndexName,argDate,AdmId))	 
				 }
			  s argDate=$o(^PAADMi(AIndexName,argDate),-1) 
			   }
			   
		   s argDate=argOldDate,AdmId=0
		   s argDate=$o(^PAADMi(AIndexName,argDate))
		   While ( argDate'="") 
		   {
			 s AdmId=$o(^PAADMi(AIndexName,argDate,""))
			 While (AdmId '="")  
			 {
			  s ^CacheTempDHCEPRRptAdmID($J,"DateFilter",AdmId)=AdmId	 
			  s AdmId=$o(^PAADMi(AIndexName,argDate,AdmId))	 
				 }
			  s argDate=$o(^PAADMi(AIndexName,argDate)) 
			   }
			}
  }
  elseif (EndDataValue '="")
  {
	s ComBgnDate=$zdh(BgnDataValue,3) 
	s ComEndDate=$zdh(EndDataValue,3) 
	if (ComBgnDate>=ComEndDate )
	{   s argBgnDate = ComEndDate
		S argEndDate = ComBgnDate
		s argBgnOp      = EndCONDITIONOP
		s argEndOp      = BgnCONDITIONOP } 
	 else{	s argBgnDate = ComBgnDate 
		    S argEndDate = ComEndDate
		    s argBgnOp      = BgnCONDITIONOP 
		    s argEndOp      = EndCONDITIONOP }	
	s argBgnComDate=argBgnDate
	s argEndComDate=argEndDate
    if ((argBgnOp=">="))
    { if (argEndOp="=") 
     { 
	     if (argEndComDate= argBgnComDate) 
	     { 
	       // C>=A B=C B=A : C=B 
	      s AdmId=$o(^PAADMi(AIndexName,argEndComDate,""))  
		  While (AdmId '="")  
		  {s ^CacheTempDHCEPRRptAdmID($J,"DateFilter",AdmId)=AdmId	 
		   s AdmId=$o(^PAADMi(AIndexName,argDate,AdmId)) }
	      }
	      Elseif (argEndComDate '= argBgnComDate) 
	      { //C>=A B=C B>A : C=A
	        s AdmId=$o(^PAADMi(AIndexName,argEndComDate,""))  
		    While (AdmId '="")  
		   {s ^CacheTempDHCEPRRptAdmID($J,"DateFilter",AdmId)=AdmId	 
		    s AdmId=$o(^PAADMi(AIndexName,argDate,AdmId)) }
           } 
	 }
     elseif (argEndOp=">=") 
     { if (argEndComDate= argBgnComDate) 
       { //   c>=A B=A C>=B : C >=B  
       s argDate=argEndComDate-1,AdmId=0
	   s argDate=$o(^PAADMi(AIndexName,argDate))
	   While ( argDate'="") 
	   { 
		 s AdmId=$o(^PAADMi(AIndexName,argDate,""))
		 While (AdmId '="")  
		 {s ^CacheTempDHCEPRRptAdmID($J,"DateFilter",AdmId)=AdmId	 
		  s AdmId=$o(^PAADMi(AIndexName,argDate,AdmId))	 
		  }
		 s argDate=$o(^PAADMi(AIndexName,argDate)) 
		}
	       }
       elseif (argEndComDate '= argBgnComDate) 
       { //   c>=A B>A C>=B : C >=B  
       s argDate=argEndComDate-1,AdmId=0
	   s argDate=$o(^PAADMi(AIndexName,argDate))
	   While ( argDate'="") 
	   { 
		 s AdmId=$o(^PAADMi(AIndexName,argDate,""))
		 While (AdmId '="")  
		 {s ^CacheTempDHCEPRRptAdmID($J,"DateFilter",AdmId)=AdmId	 
		  s AdmId=$o(^PAADMi(AIndexName,argDate,AdmId))	 
		  }
		 s argDate=$o(^PAADMi(AIndexName,argDate)) 
		}
	    }
     }
	 elseif (argEndOp=">") 
	 { //C>=A B>A C>B : C>B or //C>=A B=A C> B :  C >B
       s argDate=argEndComDate,AdmId=0
	   s argDate=$o(^PAADMi(AIndexName,argDate))
	   While ( argDate'="") 
	   { 
		 s AdmId=$o(^PAADMi(AIndexName,argDate,""))
		 While (AdmId '="")  
		 {s ^CacheTempDHCEPRRptAdmID($J,"DateFilter",AdmId)=AdmId	 
		  s AdmId=$o(^PAADMi(AIndexName,argDate,AdmId))	 
		  }
		 s argDate=$o(^PAADMi(AIndexName,argDate)) 
		}
	 }
     elseif (argEndOp="<") 
     { // A>=C B>=A B <C : C NULL
	   if (argEndComDate= argBgnComDate) 
	   { // C>=A B=A C < B  : B=A
		 s ^CacheTempDHCEPRRptAdmID($J,"DateFilter")="NULL"   
		}
	    elseif (argEndComDate '= argBgnComDate) 
	    {  // C>=A B>A C < B  :  A<=C<B
	     s argDate=argBgnComDate-1,AdmId=0
	     s argDate=$o(^PAADMi(AIndexName,argDate))
	     While ( argDate '="") 
	     {  if ( argDate <argEndComDate) 
	        { s AdmId=$o(^PAADMi(AIndexName,argDate,""))
		      While (AdmId '="")  
		      { s ^CacheTempDHCEPRRptAdmID($J,"DateFilter",AdmId)=AdmId	 
		        s AdmId=$o(^PAADMi(AIndexName,argDate,AdmId))	 
		      }
		     s argDate=$o(^PAADMi(AIndexName,argDate)) 	    
             }
		    }
		  }	   
	 }
     elseif (argEndOp="<=") 
     { if (argEndComDate= argBgnComDate) 
         { // C>=A B=A C <= B  : B=A
           s AdmId=$o(^PAADMi(AIndexName,argEndComDate,""))  
		   While (AdmId '="")  
		   {s ^CacheTempDHCEPRRptAdmID($J,"DateFilter",AdmId)=AdmId	 
		    s AdmId=$o(^PAADMi(AIndexName,argDate,AdmId))	 
		    }
          }
         elseif (argEndComDate'= argBgnComDate) 
         { // C>=A B>A C =<A : A<=C<=B
	      s argDate=argBgnComDate-1,AdmId=0
	      s argDate=$o(^PAADMi(AIndexName,argDate))
	      While ( argDate '="") 
	      {  
	        if (argDate <=argEndComDate)
	        { s AdmId=$o(^PAADMi(AIndexName,argDate,""))
		      While (AdmId '="")  
		      { s ^CacheTempDHCEPRRptAdmID($J,"DateFilter",AdmId)=AdmId	 
		       s AdmId=$o(^PAADMi(AIndexName,argDate,AdmId))	 
		      }
		     }
		    s argDate=$o(^PAADMi(AIndexName,argDate)) 	    
		   }
	       }
	}
	elseif (argEndOp="<>") 
	{
	  if (argEndComDate= argBgnComDate) 
	  { //C>=A B=A B <>C : C>A
	      s argDate=argBgnComDate,AdmId=0
	      s argDate=$o(^PAADMi(AIndexName,argDate))
	      While ( argDate '="") 
	      {  s AdmId=$o(^PAADMi(AIndexName,argDate,""))
		     While (AdmId '="")  
		    { s ^CacheTempDHCEPRRptAdmID($J,"DateFilter",AdmId)=AdmId	 
		      s AdmId=$o(^PAADMi(AIndexName,argDate,AdmId))	 
		     }
		    s argDate=$o(^PAADMi(AIndexName,argDate)) 	    
		   }
      }
	  Elseif (argEndComDate '= argBgnComDate) 
	  { //C>=A B>A B <>C : C>=A C <> B
		s argDate=argBgnComDate,AdmId=0
	    s argDate=$o(^PAADMi(AIndexName,argDate))
	    While ( argDate '="") 
	    {  
	      if (argDate'=argEndComDate)
	      { s AdmId=$o(^PAADMi(AIndexName,argDate,""))
		    While (AdmId '="")  
		    { s ^CacheTempDHCEPRRptAdmID($J,"DateFilter",AdmId)=AdmId	 
		      s AdmId=$o(^PAADMi(AIndexName,argDate,AdmId))	 
		    }
		    s argDate=$o(^PAADMi(AIndexName,argDate)) 	    
		   }
		 }
	   }	
       }
     }
    Elseif ((argBgnOp=">"))	  
    {
	 if (argEndOp="=") 
	 {  
	   if (argEndComDate= argBgnComDate) 
	   {  //C>A B=A B=C : C NULL
		s ^CacheTempDHCEPRRptAdmID($J,"DateFilter")="NULL"     
       }
	   Elseif (argEndComDate '= argBgnComDate) 
	   { //C>A B>A B=C : C=B
	      s AdmId=$o(^PAADMi(AIndexName,argEndComDate,""))  
		  While (AdmId '="")  
		  {s ^CacheTempDHCEPRRptAdmID($J,"DateFilter",AdmId)=AdmId	 
		   s AdmId=$o(^PAADMi(AIndexName,argDate,AdmId)) 
		   }
		}
      }
	 Elseif (argEndOp=">=") 
	 { 
	  if (argEndComDate= argBgnComDate) 
	  { //C>A B=A C>=B : C>A
		 s argDate= argBgnComDate,AdmId=0 
	     s argDate=$o(^PAADMi(AIndexName,argDate))
	     While ( argEndComDate'="") 
	     { s AdmId=$o(^PAADMi(AIndexName,argDate,""))
		   While (AdmId '="")  
		   {s ^CacheTempDHCEPRRptAdmID($J,"DateFilter",AdmId)=AdmId	 
		    s AdmId=$o(^PAADMi(AIndexName,argDate,AdmId))	 
		    }
		   s argDate=$o(^PAADMi(AIndexName,argDate)) 	    
		}
	   }
	   Elseif (argEndComDate '= argBgnComDate) 
	   { //C>A B>A C>=B : C >=B
		  s argDate=argEndComDate-1,AdmId=0  
	      s argDate=$o(^PAADMi(AIndexName,argDate))
	      While ( argEndComDate'="") 
	      { s AdmId=$o(^PAADMi(AIndexName,argDate,""))
		    While (AdmId '="")  
		    {s ^CacheTempDHCEPRRptAdmID($J,"DateFilter",AdmId)=AdmId	 
		     s AdmId=$o(^PAADMi(AIndexName,argDate,AdmId))	 
		    }
		    s argDate=$o(^PAADMi(AIndexName,argDate)) 	    
		 }
         } 	  
	 }   
	 Elseif (argEndOp=">") 
	 { 
	   //C>A B=A B>C : C <A or A>C B>A B>C : C <A
	   if (argEndComDate= argBgnComDate) 
	   {  //C>A B=A C>B : C >A
		 s argDate= argBgnComDate,AdmId=0 
	     s argDate=$o(^PAADMi(AIndexName,argDate))
	     While ( argEndComDate'="") 
	     { s AdmId=$o(^PAADMi(AIndexName,argDate,""))
		   While (AdmId '="")  
		   {s ^CacheTempDHCEPRRptAdmID($J,"DateFilter",AdmId)=AdmId	 
		    s AdmId=$o(^PAADMi(AIndexName,argDate,AdmId))	 
		    }
		   s argDate=$o(^PAADMi(AIndexName,argDate)) 	    
		}
	   }
	   Elseif (argEndComDate '= argBgnComDate) 
	   { //C>A B>A C>B : C > B
		 s argDate= argEndComDate,AdmId=0 
	     s argDate=$o(^PAADMi(AIndexName,argDate))
	     While ( argEndComDate'="") 
	     { s AdmId=$o(^PAADMi(AIndexName,argDate,""))
		   While (AdmId '="")  
		   {s ^CacheTempDHCEPRRptAdmID($J,"DateFilter",AdmId)=AdmId	 
		    s AdmId=$o(^PAADMi(AIndexName,argDate,AdmId))	 
		    }
		   s argDate=$o(^PAADMi(AIndexName,argDate)) 	    
		}
		   }
	 }   
	 Elseif (argEndOp="<") 
	 { //C>A B=A B<C : C NULL or A>C B>A B<C : C NULL
	   if (argEndComDate= argBgnComDate) 
	   { //C>A B=A C<B :C NULL
	     s ^CacheTempDHCEPRRptAdmID($J,"DateFilter")="NULL" 
		   }
	   Elseif (argEndComDate '= argBgnComDate) 
	   {  //C>A B>A C<B :  A<C<B
	   	 s argDate=argBgnComDate,AdmId=0
	     s argDate=$o(^PAADMi(AIndexName,argDate))
	     While ( argDate '="") 
	     {  
	       if (argDate <argEndComDate)
	       { s AdmId=$o(^PAADMi(AIndexName,argDate,""))
		     While (AdmId '="")  
		     { s ^CacheTempDHCEPRRptAdmID($J,"DateFilter",AdmId)=AdmId	 
		       s AdmId=$o(^PAADMi(AIndexName,argDate,AdmId))	 
		     }
		    s argDate=$o(^PAADMi(AIndexName,argDate)) 	    
		    }
		  }
         } 
	 }   
	 Elseif (argEndOp="<=") 
	 {
	   if (argEndComDate= argBgnComDate) 
	   {  //C>A B=A C<=B : C NULL
         s ^CacheTempDHCEPRRptAdmID($J,"DateFilter")="NULL" 		
       }
	   Elseif (argEndComDate '= argBgnComDate) 
	   { //C>A B>A C<=B :  A<C<=B
	   	 s argDate=argBgnComDate,AdmId=0
	     s argDate=$o(^PAADMi(AIndexName,argDate),-1)
	     While ( argDate '="") 
	     {  
	        if (argDate<=argEndComDate)
	        { s AdmId=$o(^PAADMi(AIndexName,argDate,""))
		     While (AdmId '="")  
		     { s ^CacheTempDHCEPRRptAdmID($J,"DateFilter",AdmId)=AdmId	 
		       s AdmId=$o(^PAADMi(AIndexName,argDate,AdmId))	 
		     }
		    s argDate=$o(^PAADMi(AIndexName,argDate),-1) 	    
		    }
		    }
		   }
	 }   
	 Elseif (argEndOp="<>") 
	 { 
	  if (argEndComDate= argBgnComDate) 
	  { // C>A B=A B<>C : C  > A
	   s argDate=argBgnComDate,AdmId=0
	   s argDate=$o(^PAADMi(AIndexName,argDate))
	   While ( argDate'="") 
	   { s AdmId=$o(^PAADMi(AIndexName,argDate,""))
		 While (AdmId '="")  
		 {s ^CacheTempDHCEPRRptAdmID($J,"DateFilter",AdmId)=AdmId	 
		 s AdmId=$o(^PAADMi(AIndexName,argDate,AdmId))	 }
		 s argDate=$o(^PAADMi(AIndexName,argDate)) 	    
		 }		  
	  }
	  Elseif (argEndComDate '= argBgnComDate) 
	  { // C>A B>A B<>C : C >A C <> B
	   s argDate=argBgnComDate,AdmId=0
	   s argDate=$o(^PAADMi(AIndexName,argDate))
	   While ( argDate'="") 
	   { 
	     if (argDate'=argEndComDate)
	     { s AdmId=$o(^PAADMi(AIndexName,argDate,""))
		   While (AdmId '="")  
		   { s ^CacheTempDHCEPRRptAdmID($J,"DateFilter",AdmId)=AdmId	 
		     s AdmId=$o(^PAADMi(AIndexName,argDate,AdmId))	 
		     }
		     s argDate=$o(^PAADMi(AIndexName,argDate)) 	    
		   }
		 }		  
	 }
	 }   
    }
    Elseif ((argBgnOp="<="))	  
    { 
      if (argEndOp="=") 
	  {  
	     if (argEndComDate= argBgnComDate) 
	     {  //C<=A B=A B=C  : C=B
	        s argDate=argEndComDate,AdmId=0
            s AdmId=$o(^PAADMi(AIndexName,argDate,""))
		    While (AdmId '="")  
		    { s ^CacheTempDHCEPRRptAdmID($J,"DateFilter",AdmId)=AdmId	 
		      s AdmId=$o(^PAADMi(AIndexName,argDate,AdmId))	 
		      }		   
	     }
	     Elseif (argEndComDate '= argBgnComDate) 
	     { //C<=A B>A B=C  : C NULL
		   s ^CacheTempDHCEPRRptAdmID($J,"DateFilter")="NULL" 		 
		      }
      }
	  Elseif (argEndOp=">=") 
	  { 
		if (argEndComDate= argBgnComDate) 
		{ // C <= A  B=A  C>= B  :C =A
	        s argDate=argEndComDate,AdmId=0
            s AdmId=$o(^PAADMi(AIndexName,argDate,""))
		    While (AdmId '="")  
		    { s ^CacheTempDHCEPRRptAdmID($J,"DateFilter",AdmId)=AdmId	 
		      s AdmId=$o(^PAADMi(AIndexName,argDate,AdmId))	 
		      }		   
			}
		Elseif (argEndComDate '= argBgnComDate) 
		{ // C <= A  B>A  C<= B  :   C<=A
	       s argDate=argBgnComDate+1,AdmId=0
	       s argDate=$o(^PAADMi(AIndexName,argDate),-1)
	      While ( argEndComDate <=argEndComDate) 
	      { s AdmId=$o(^PAADMi(AIndexName,argDate,""))
		    While (AdmId '="")  
		    { s ^CacheTempDHCEPRRptAdmID($J,"DateFilter",AdmId)=AdmId	 
		      s AdmId=$o(^PAADMi(AIndexName,argDate,AdmId))	 
		     }
		    s argDate=$o(^PAADMi(AIndexName,argDate),-1) 	    
		    }
			}
	  }  
	  Elseif (argEndOp=">") 
	  { 
	    if (argEndComDate= argBgnComDate) 
	    { // C <= A  B=A   C>B :C NULL
	      s ^CacheTempDHCEPRRptAdmID($J,"DateFilter")="NULL"     
	     }
	    Elseif (argEndComDate'= argBgnComDate) 
	    { // C <= A  B>A   C>B : C NULL
	       s ^CacheTempDHCEPRRptAdmID($J,"DateFilter")="NULL"     
          }
		  }  
	  Elseif (argEndOp="<=") 
	  { 
	    if (argEndComDate= argBgnComDate) 
	    { // C <=A  B=A  C <= B : C<=A
	       s argDate=argBgnComDate+1,AdmId=0
	       s argDate=$o(^PAADMi(AIndexName,argDate),-1)
	       While ( argDate '="") 
	       { s AdmId=$o(^PAADMi(AIndexName,argDate,""))
		     While (AdmId '="")  
		     { s ^CacheTempDHCEPRRptAdmID($J,"DateFilter",AdmId)=AdmId	 
		       s AdmId=$o(^PAADMi(AIndexName,argDate,AdmId))	 
		      }
		    s argDate=$o(^PAADMi(AIndexName,argDate),-1) 	    
		    }
	    }
	    Elseif (argEndComDate '= argBgnComDate) 
	    { // C <=A  B > A  C <= B : C<=A
	       s argDate=argBgnComDate+1,AdmId=0
	       s argDate=$o(^PAADMi(AIndexName,argDate),-1)
	       While ( argDate '="") 
	       { s AdmId=$o(^PAADMi(AIndexName,argDate,""))
		     While (AdmId '="")  
		     { s ^CacheTempDHCEPRRptAdmID($J,"DateFilter",AdmId)=AdmId	 
		       s AdmId=$o(^PAADMi(AIndexName,argDate,AdmId))	 
		      }
		    s argDate=$o(^PAADMi(AIndexName,argDate),-1) 	    
		    }
		 }
	  }  
	  Elseif (argEndOp="<") 
	  { 
		
	    if (argEndComDate= argBgnComDate) 
	    { // C <=A  B=A  C < B : C<A
	       s argDate=argBgnComDate,AdmId=0
	       s argDate=$o(^PAADMi(AIndexName,argDate),-1)
	       While ( argDate '="") 
	       { s AdmId=$o(^PAADMi(AIndexName,argDate,""))
		     While (AdmId '="")  
		     { s ^CacheTempDHCEPRRptAdmID($J,"DateFilter",AdmId)=AdmId	 
		       s AdmId=$o(^PAADMi(AIndexName,argDate,AdmId))	 
		      }
		    s argDate=$o(^PAADMi(AIndexName,argDate),-1) 	    
		    }
	    }
		Elseif (argEndComDate '= argBgnComDate) 
		{ // C <=A  B>A  C < B : C<A
	       s argDate=argBgnComDate,AdmId=0
	       s argDate=$o(^PAADMi(AIndexName,argDate),-1)
	       While ( argDate '="") 
	       { s AdmId=$o(^PAADMi(AIndexName,argDate,""))
		     While (AdmId '="")  
		     { s ^CacheTempDHCEPRRptAdmID($J,"DateFilter",AdmId)=AdmId	 
		       s AdmId=$o(^PAADMi(AIndexName,argDate,AdmId))	 
		      }
		    s argDate=$o(^PAADMi(AIndexName,argDate),-1) 	    
		    }
			}
	  }  
	  Elseif (argEndOp="<>") 
	  { 
		if (argEndComDate= argBgnComDate) 
		{  // C<=A  B=A B <> C : C <A
		  	
		  s argDate=argBgnComDate ,AdmId=0
	      s argDate=$o(^PAADMi(AIndexName,argDate))
	      While ( argDate '= "" ) 
	      { 
		    s AdmId=$o(^PAADMi(AIndexName,argDate,""))
		    While (AdmId '="")  
		    { s ^CacheTempDHCEPRRptAdmID($J,"DateFilter",AdmId)=AdmId	 
		      s AdmId=$o(^PAADMi(AIndexName,argDate,AdmId))	 
		    }
		   s argDate=$o(^PAADMi(AIndexName,argDate),-1) 	   
		   }
		}
		Elseif (argEndComDate '= argBgnComDate) 
		{  // C<=A  B>A B <> C : C <=A
		  s argDate=argBgnComDate+1 ,AdmId=0
	      s argDate=$o(^PAADMi(AIndexName,argDate),-1)
	      While ( argDate '= "" ) 
	      { 
		    if (argDate '= argEndComDate)
		    { s AdmId=$o(^PAADMi(AIndexName,argDate,""))
		      While (AdmId '="")  
		      { s ^CacheTempDHCEPRRptAdmID($J,"DateFilter",AdmId)=AdmId	 
  		        s AdmId=$o(^PAADMi(AIndexName,argDate,AdmId)) }
		    }
		    s argDate=$o(^PAADMi(AIndexName,argDate),-1) 	    
		   }
		}
		 }
	}
    Elseif ((argBgnOp="<"))	  
    {
	 if (argEndOp="=") 
	 { if (argEndComDate= argBgnComDate) 
	   { // C < A  B =A  B=c  : C = NULL
		    s ^CacheTempDHCEPRRptAdmID($J,"DateFilter")="NULL"  }
	   elseif (argEndComDate '= argBgnComDate) 
	   { // C < A  B >A  C=B   : C NULL 
	     s ^CacheTempDHCEPRRptAdmID($J,"DateFilter")="NULL" 
        }
	 }
	 elseif (argEndOp=">=")   
	 { 
	   if (argEndComDate= argBgnComDate) 
	   {  // C < A  B =A  C >= B :C NULL
	   
	   s ^CacheTempDHCEPRRptAdmID($J,"DateFilter")="NULL"}
	   elseif (argEndComDate '= argBgnComDate) 
	   { // C < A  B >A  C  >= B  
	     s ^CacheTempDHCEPRRptAdmID($J,"DateFilter")="NULL"
	    }
	 }
	 elseif (argEndOp=">")   
	 {
       
	   if (argEndComDate= argBgnComDate) 
	   {  // C < A  B =A  C > B : C  NULL
	     s ^CacheTempDHCEPRRptAdmID($J,"DateFilter")="NULL" 
		   }
	   elseif (argEndComDate '= argBgnComDate) 
	   { // C < A  B >A  C > B  : C  NULL
		 s ^CacheTempDHCEPRRptAdmID($J,"DateFilter")="NULL" 
         }
     }
	 elseif (argEndOp="<=")   
	 { 
	   if (argEndComDate= argBgnComDate) 
	   { // C <= B B= A C<A  : C < A
		  s argDate=argEndComDate  ,AdmId=0
		   }
	   elseif (argEndComDate '= argBgnComDate) 
	   { //C <= B B> A C<A  : C < B
		  s argDate=argEndComDate  ,AdmId=0
        }
	   s argDate=$o(^PAADMi(AIndexName,argDate),-1)
	   While ( argDate '= "" ) 
	   {  s AdmId=$o(^PAADMi(AIndexName,argDate,""))
		  While (AdmId '="")  
		  { s ^CacheTempDHCEPRRptAdmID($J,"DateFilter",AdmId)=AdmId	 
  		    s AdmId=$o(^PAADMi(AIndexName,argDate,AdmId)) }
		 }
		 s argDate=$o(^PAADMi(AIndexName,argDate),-1) 	    
	  }
	 elseif (argEndOp="<")   
	 { 
	   
	   // C < B B = A C<A  : C < A or C < B B > A C<A  : C < A
	   
	   
	   s argDate=argBgnComDate  ,AdmId=0
	   s argDate=$o(^PAADMi(AIndexName,argDate),-1)
	   While ( argDate '= "" ) 
	   {  s AdmId=$o(^PAADMi(AIndexName,argDate,""))
		  While (AdmId '="")  
		  { s ^CacheTempDHCEPRRptAdmID($J,"DateFilter",AdmId)=AdmId	 
  		    s AdmId=$o(^PAADMi(AIndexName,argDate,AdmId)) }
		 s argDate=$o(^PAADMi(AIndexName,argDate),-1)
		 }
	 }
	 elseif (argEndOp="<>")   
	 { //C <> B B> A C<A  : C < A C <> B  or C <> B B= A C<A  : C < A
		  s argDate=argBgnComDate  ,AdmId=0
	   s argDate=$o(^PAADMi(AIndexName,argDate),-1)
	   While ( argDate '= "" ) 
	   {  s AdmId=$o(^PAADMi(AIndexName,argDate,""))
		  While (AdmId '="")  
		  { s ^CacheTempDHCEPRRptAdmID($J,"DateFilter",AdmId)=AdmId	 
  		    s AdmId=$o(^PAADMi(AIndexName,argDate,AdmId)) }
		 s argDate=$o(^PAADMi(AIndexName,argDate),-1)
		 }
		}	
	}
    Elseif ((argBgnOp="="))	  
    {
	  if (argEndOp="=")   
	  {
		if (argEndComDate= argBgnComDate) 
		{ // A=C B=A B=C : C=A
	      s argDate=argBgnComDate  ,AdmId=0
          s AdmId=$o(^PAADMi(AIndexName,argDate,""))
		  While (AdmId '="")  
		  { s ^CacheTempDHCEPRRptAdmID($J,"DateFilter",AdmId)=AdmId	 
  		    s AdmId=$o(^PAADMi(AIndexName,argDate,AdmId)) 
  		   }
	      }			
		elseif (argEndComDate '= argBgnComDate) 
		{ //A=C B>A B=C : C NULL
		  s ^CacheTempDHCEPRRptAdmID($J,"DateFilter")="NULL" 	
			}
      }
	  elseif (argEndOp=">=")   
	  { // A=C B=A C>=B  : C =A or  A=C B>A C>=B  : C =A
	     if (argEndComDate= argBgnComDate) 
	     {  // A=C B=A C>=B  : C =A
		   s argDate=argBgnComDate  ,AdmId=0
           s AdmId=$o(^PAADMi(AIndexName,argDate,""))
		   While (AdmId '="")  
		   { s ^CacheTempDHCEPRRptAdmID($J,"DateFilter",AdmId)=AdmId	 
  		     s AdmId=$o(^PAADMi(AIndexName,argDate,AdmId)) 
  		    }
		   }
		  Elseif (argEndComDate= argBgnComDate)  
		  {  //A=C B>A C >=B : C NULL  
			s ^CacheTempDHCEPRRptAdmID($J,"DateFilter")="NULL" 	  
			  } 
	  }  
	  elseif (argEndOp=">")   
	  { if (argEndComDate= argBgnComDate) 
	    { // A=C B=A C>B : C NULL
		  s ^CacheTempDHCEPRRptAdmID($J,"DateFilter")="NULL" }
	    Elseif (argEndComDate '= argBgnComDate) 
	    { // A=C B>A C>B : C NULL  
	      s ^CacheTempDHCEPRRptAdmID($J,"DateFilter")="NULL" }
	  }  
	  elseif (argEndOp="<=")   
	  { //A=C B=A C<=B : A = C  or  //A= C B > A C<=B : C=A
	      s argDate=argBgnComDate  ,AdmId=0
          s AdmId=$o(^PAADMi(AIndexName,argDate,""))
		  While (AdmId '="")  
		  { s ^CacheTempDHCEPRRptAdmID($J,"DateFilter",AdmId)=AdmId	 
  		    s AdmId=$o(^PAADMi(AIndexName,argDate,AdmId)) 
  		   }
      }  
	  elseif (argEndOp="<")   
	  { if (argEndComDate= argBgnComDate) 
		{ //A=C B=A B<C : C NULL
		  s ^CacheTempDHCEPRRptAdmID($J,"DateFilter")="NULL" 	  		
			}
		Elseif (argEndComDate'= argBgnComDate) 
		{ //A= C B>A B<C : C NULL
		  s ^CacheTempDHCEPRRptAdmID($J,"DateFilter")="NULL" 	}  
		  }  
	  elseif (argEndOp="<>")   
	  { if (argEndComDate= argBgnComDate) 
	    { // A=C B=A B<> C : C NULL
		  s ^CacheTempDHCEPRRptAdmID($J,"DateFilter")="NULL"  }
	    Elseif (argEndComDate'= argBgnComDate) 
	    { // A =C B> A B <>C : C =A
	      s argDate=argBgnComDate  ,AdmId=0
          s AdmId=$o(^PAADMi(AIndexName,argDate,""))
		  While (AdmId '="")  
		  { s ^CacheTempDHCEPRRptAdmID($J,"DateFilter",AdmId)=AdmId	 
  		    s AdmId=$o(^PAADMi(AIndexName,argDate,AdmId)) 
  		   }
	     } 
      }  
    }
    Elseif ((argBgnOp="<>"))	  
    { if (argEndOp="=")   
	  { if (argEndComDate= argBgnComDate) 
		{ //A<>C B=A B=A : C NULL
		  s ^CacheTempDHCEPRRptAdmID($J,"DateFilter")="NULL"  }
		Elseif (argEndComDate'= argBgnComDate) 
		{ // A<>C B >A B=C : C =B
	      s argDate=argEndComDate  ,AdmId=0
          s AdmId=$o(^PAADMi(AIndexName,argDate,""))
		  While (AdmId '="")  
		  { s ^CacheTempDHCEPRRptAdmID($J,"DateFilter",AdmId)=AdmId	 
  		    s AdmId=$o(^PAADMi(AIndexName,argDate,AdmId)) 
  		   }
		}  
	  }
	  elseif (argEndOp=">=")   
	  { if (argEndComDate= argBgnComDate) 
	    { // A<>C B =A C>=B : C>B
		  s argDate=argEndComDate ,AdmId=0
	      s argDate=$o(^PAADMi(AIndexName,argDate))
	      While ( argDate '= "" ) 
	      { s AdmId=$o(^PAADMi(AIndexName,argDate,""))
		     While (AdmId '="")  
		     { s ^CacheTempDHCEPRRptAdmID($J,"DateFilter",AdmId)=AdmId	 
  		       s AdmId=$o(^PAADMi(AIndexName,argDate,AdmId)) 
  		     }
		     s argDate=$o(^PAADMi(AIndexName,argDate))
	      }
	    }
	    Elseif (argEndComDate '= argBgnComDate) 
	    { // A<>C B >A C>=B : C >= B 
		  s argDate=argEndComDate -1 ,AdmId=0
	      s argDate=$o(^PAADMi(AIndexName,argDate))
	      While ( argDate '= "" ) 
	      {  s AdmId=$o(^PAADMi(AIndexName,argDate,""))
		      While (AdmId '="")  
		      { s ^CacheTempDHCEPRRptAdmID($J,"DateFilter",AdmId)=AdmId	 
  		        s AdmId=$o(^PAADMi(AIndexName,argDate,AdmId)) 
  		      }
		     s argDate=$o(^PAADMi(AIndexName,argDate,-1))
	      }
		 }
	  }
	  elseif (argEndOp=">")   
	  {  //A<>C A=B C>B :C > B  //A<>C B>A C >B : C > B 
	  	 s argDate=argEndComDate ,AdmId=0
	      s argDate=$o(^PAADMi(AIndexName,argDate))
	      While ( argDate '= "" ) 
	      { s AdmId=$o(^PAADMi(AIndexName,argDate,""))
		      While (AdmId '="")  
		      { s ^CacheTempDHCEPRRptAdmID($J,"DateFilter",AdmId)=AdmId	 
  		        s AdmId=$o(^PAADMi(AIndexName,argDate,AdmId)) 
  		      }
	         s argDate=$o(^PAADMi(AIndexName,argDate))
	      }
       }
	  elseif (argEndOp="<=")   
	  { if (argEndComDate= argBgnComDate) 
	    { //A<>C B=A C <=B : C <B
		  s argDate=argEndComDate  ,AdmId=0
	      s argDate=$o(^PAADMi(AIndexName,argDate),-1)
	      While ( argDate '= "" ) 
	      { 
	          s AdmId=$o(^PAADMi(AIndexName,argDate,""))
		      While (AdmId '="")  
		      { s ^CacheTempDHCEPRRptAdmID($J,"DateFilter",AdmId)=AdmId	 
  		        s AdmId=$o(^PAADMi(AIndexName,argDate,AdmId)) 
  		      }
	         s argDate=$o(^PAADMi(AIndexName,argDate),-1)
	      }
		}
	    Elseif (argEndComDate'= argBgnComDate) 
	    { //A<>C B>A C <=B :  C <=B C <> A
		  s argDate=argEndComDate+1  ,AdmId=0
	      s argDate=$o(^PAADMi(AIndexName,argDate),-1)
	      While ( argDate '= "" ) 
	      { if (argDate'=argBgnComDate)
	         { s AdmId=$o(^PAADMi(AIndexName,argDate,""))
		      While (AdmId '="")  
		      { s ^CacheTempDHCEPRRptAdmID($J,"DateFilter",AdmId)=AdmId	 
  		        s AdmId=$o(^PAADMi(AIndexName,argDate,AdmId)) 
  		      }
	         }
	         s argDate=$o(^PAADMi(AIndexName,argDate),-1)
	      }
		 }
	   }
	  elseif (argEndOp="<")   
	  {  
		 if (argEndComDate= argBgnComDate) 
		 { //A <> C B =A  C < B : C<B
		  s argDate=argEndComDate  ,AdmId=0
	      s argDate=$o(^PAADMi(AIndexName,argDate))
	      While ( argDate '= "" ) 
	         { s AdmId=$o(^PAADMi(AIndexName,argDate,""))
		      While (AdmId '="")  
		      { s ^CacheTempDHCEPRRptAdmID($J,"DateFilter",AdmId)=AdmId	 
  		        s AdmId=$o(^PAADMi(AIndexName,argDate,AdmId)) 
  		      }
	         }
	         s argDate=$o(^PAADMi(AIndexName,argDate))
		}
		Elseif (argEndComDate'= argBgnComDate) 
		{ //A <> C B > A C < B :  C <B   c <> A 
		  s argDate=argEndComDate  ,AdmId=0
	      s argDate=$o(^PAADMi(AIndexName,argDate))
	      While ( argDate '= "" ) 
	      { if (argDate '= argBgnComDate)  
		    { s AdmId=$o(^PAADMi(AIndexName,argDate,""))
		      While (AdmId '="")  
		       { s ^CacheTempDHCEPRRptAdmID($J,"DateFilter",AdmId)=AdmId	 
  		         s AdmId=$o(^PAADMi(AIndexName,argDate,AdmId)) 
  		       }
  		     }
	        s argDate=$o(^PAADMi(AIndexName,argDate))
	        }
		 } 
	 }
	  elseif (argEndOp="<>")   
	  { 
	    if (argEndComDate= argBgnComDate) 
	    { //A<>C B<>C B=A
		  s AdmId=0
	      s argDate=$o(^PAADMi(AIndexName,""))
	      While ( argDate '= "" ) 
	         { 
	          if (argDate'=argBgnComDate)
	          { s AdmId=$o(^PAADMi(AIndexName,argDate,""))
		        While (AdmId '="")  
		       { s ^CacheTempDHCEPRRptAdmID($J,"DateFilter",AdmId)=AdmId	 
  		         s AdmId=$o(^PAADMi(AIndexName,argDate,AdmId)) 
  		       }
	           }
	         }
	         s argDate=$o(^PAADMi(AIndexName,argDate))
		}
	    Elseif (argEndComDate '= argBgnComDate) 
	    { // A <>C  B<>C B > A : C<> A B <> C
		  s AdmId=0
	      s argDate=$o(^PAADMi(AIndexName,""))
	      While ( argDate '= "" ) 
	         { if ((argDate'=argBgnComDate)&&(argDate'=argEndComDate))
	          { s AdmId=$o(^PAADMi(AIndexName,argDate,""))
		        While (AdmId '="")  
		        { s ^CacheTempDHCEPRRptAdmID($J,"DateFilter",AdmId)=AdmId	 
  		          s AdmId=$o(^PAADMi(AIndexName,argDate,AdmId)) 
  		        }
	           }
	         }
	         s argDate=$o(^PAADMi(AIndexName,argDate))
		    }
	  }
    }
}
}

/// 遍历满足就诊信息条件的episodeId集（在^CacheTempDHCEPRRptAdmID($J,"EpisodeFilter")中）,
/// 从中筛选满足电子病历选择条件的episodeId集合，将其放到临时global ^CacheTempDHCEPRRptAdmID($J,"EPRFilter")
ClassMethod FilterAdmIdByEPRDataCondition()
{
	///debug
	///b "s"
	
	K ^CacheTempDHCEPRRptAdmID($J,"EPRFilter")
	
	/// 若电子病历信息选择条件为空，则满足就诊信息条件的episodeId集就是满足所有查询条件的episodeId集
	Set AEPRConKey = $ORDER(^CacheTempDHCEPRRptCondition($J,"EPR",""))
	if AEPRConKey=""
	{
		merge ^CacheTempDHCEPRRptAdmID($J,"EPRFilter")=^CacheTempDHCEPRRptAdmID($J,"EpisodeFilter")
		quit
	}
	
	/// 若电子病历信息条件不为空，遍历满足就诊信息条件的episodeId集
 	Set AEpisodeKey = $ORDER(^CacheTempDHCEPRRptAdmID($J,"EpisodeFilter",""))
 	WHILE (AEpisodeKey'="") 
 	{  
 		set EPRConditionFlag="False"
   		
   		/// 对每个episodeId,遍历存储电子病历选择条件的Glboal的节点
   		/// 若所有节点的选择条件都满足,则对应episodeId为查询所要的episodeId	
   		Set AEPRConKey = $ORDER(^CacheTempDHCEPRRptCondition($J,"EPR",""))
   		WHILE (AEPRConKey'="") 
   		{ 
   			///根据节点类型判断其下的条件是否满足
     		Set LogicFlag = $G(^CacheTempDHCEPRRptCondition($J,"EPR",AEPRConKey))
     		if (LogicFlag="AND")
     		{ 	
       			s EPRConditionFlag=..ValidateEPRConOfNodeAND(AEpisodeKey,AEPRConKey)
	  		}
     		elseif (LogicFlag="OR")
     		{
	  			s EPRConditionFlag=..ValidateEPRConOfNodeOR(AEpisodeKey,AEPRConKey)
	  		}  
	  		
	  		///若任一节点下的条件不满足,则退出循环
	  		quit:(EPRConditionFlag="False")
	  		
     		SET AEPRConKey = $ORDER(^CacheTempDHCEPRRptCondition($J,"EPR",AEPRConKey))   
    	} 
 		
 		///若该episodeId满足所有电子病历信息条件, 存储在临时global中
 		if (EPRConditionFlag="True")
 		{ set ^CacheTempDHCEPRRptAdmID($J,"EPRFilter",AEpisodeKey)=AEpisodeKey }
 		
 		SET AEpisodeKey = $ORDER(^CacheTempDHCEPRRptAdmID($J,"EpisodeFilter",AEpisodeKey))
 	}
}

/// 判断是否满足一个AND节点下的电子病历条件（一个AND节点对应一个查询条件）
/// 首先取到And节点下的条件信息，然后根据其类型调用相应函数判断该条件是否满足
ClassMethod ValidateEPRConOfNodeAND(AEpisodeKey As %String, AEPRConKey As %String) As %String
{
	///debug by houj
	///if AEpisodeKey="49" b "s"
	
	quit:((AEpisodeKey="")||(AEPRConKey="")) "False"
	
	///初始化返回值
	s returnFlag = "False"
	
	///取And节点下的查询条件信息
	s conDataType=$G(^CacheTempDHCEPRRptCondition($J,"EPR",AEPRConKey,"Type"))   	//条件类型（同时也是该Item的存储类型）    
    s templateId=$G(^CacheTempDHCEPRRptCondition($J,"EPR",AEPRConKey,"TID"))    		//模板Id
    s valueType=$G(^CacheTempDHCEPRRptCondition($J,"EPR",AEPRConKey,"VTYPE"))    	//项目的取值类型
    s conOperator=$G(^CacheTempDHCEPRRptCondition($J,"EPR",AEPRConKey,"CONDITION"))  //查询条件运算符 
    s conValue=$G(^CacheTempDHCEPRRptCondition($J,"EPR",AEPRConKey,"VALUE"))    		//查询条件值
    s metaType=""														//项目元数据类型
   	s sampleCode=""														//项目代码
    ///根据[条件类型]取[项目代码]和[项目元数据类型]
    if (conDataType="Simple")||(conDataType="Segment")||(conDataType="TextDesc")
    {
		s sampleCode = $G(^CacheTempDHCEPRRptCondition($J,"EPR",AEPRConKey,"SCODE"))
		s metaType = $E(sampleCode,0,1)
	}
	Elseif (conDataType="SegmentSimple") 
	{ 
		s segmentCode = $G(^CacheTempDHCEPRRptCondition($J,"EPR",AEPRConKey,"TCODE"))
		s segmentSimpleCode = $G(^CacheTempDHCEPRRptCondition($J,"EPR",AEPRConKey,"SCODE"))
		s sampleCode=segmentCode_"."_segmentSimpleCode
		s metaType = $E(segmentSimpleCode,0,1)
	}
	Elseif (conDataType="TextDescSimple") 
	{ 
		s textDescCode = $G(^CacheTempDHCEPRRptCondition($J,"EPR",AEPRConKey,"TCODE"))
		s textDescSimpleCode = $G(^CacheTempDHCEPRRptCondition($J,"EPR",AEPRConKey,"SCODE"))
		s KBNodeID =$G(^CacheTempDHCEPRRptCondition($J,"EPR",AEPRConKey,"KBNodeID"))
		s KBPartNo =$G(^CacheTempDHCEPRRptCondition($J,"EPR",AEPRConKey,"KBPartNo"))
		s sampleCode= textDescCode_"."_textDescSimpleCode_"."_KBNodeID_"."_KBPartNo
		s metaType = $E(textDescSimpleCode,0,1)
	}
	
	//取打散数据
	s itemValue=##class(EPRservice.BOScatterData).GetScatterData(AEpisodeKey, templateId, sampleCode, valueType)
	//排除rowId,不要使用 $p(itemValue,"^",2), 因为value中可能有"^"
	//s itemValue=$e(itemValue,$F(itemValue,"^"),$L(itemValue))
	
	//判断查询条件是否成立
	s returnFlag=..JudgeEPRItem(itemValue, conOperator, conValue, metaType)
	
	quit returnFlag
}

/// 判断是否满足一个OR节点下的电子病历条件(一个OR节点有多个选择条件)
ClassMethod ValidateEPRConOfNodeOR(AEpisodeKey As %String, AEPRConKey As %String) As %String
{
	quit:((AEpisodeKey="")||(AEPRConKey="")) "False"
	
	///初始化返回值
	s returnFlag = "False"
	
	///遍历该OR节点下的所有选择条件,若其中有任何一个满足,则认为该OR节点下的条件满足
	Set ORItemCount = $G(^CacheTempDHCEPRRptCondition($J,"EPR",AEPRConKey,"COUNT"))
	For K=1:1:ORItemCount
	{
		///取OR节点下的第K个查询条件信息
		Set conDataType = $G(^CacheTempDHCEPRRptCondition($J,"EPR",AEPRConKey,K,"Type"))
        set templateId = $G(^CacheTempDHCEPRRptCondition($J,"EPR",AEPRConKey,K,"TID"))
        Set valueType =$G(^CacheTempDHCEPRRptCondition($J,"EPR",AEPRConKey,K,"VTYPE"))
        Set conOperator =$G(^CacheTempDHCEPRRptCondition($J,"EPR",AEPRConKey,K,"CONDITION"))
        Set conValue =$G(^CacheTempDHCEPRRptCondition($J,"EPR",AEPRConKey,K,"VALUE"))
        Set metaType=""																//项目元数据类型
   		Set sampleCode=""															//项目代码
        ///根据[条件类型]取[项目代码]和[项目元数据类型]
        if (conDataType="Simple")||(conDataType="Segment")||(conDataType="TextDesc")
        {
			s sampleCode = $G(^CacheTempDHCEPRRptCondition($J,"EPR",AEPRConKey,K,"SCODE"))
	     	s metaType = $E(sampleCode,0,1)
	   	} 
       	Elseif (conDataType="SegmentSimple")
	    {
		  	s segmentCode = $G(^CacheTempDHCEPRRptCondition($J,"EPR",AEPRConKey,K,"TCODE"))
	     	s segmentSimpleCode = $G(^CacheTempDHCEPRRptCondition($J,"EPR",AEPRConKey,K,"SCODE"))
	     	s sampleCode=segmentCode_"."_segmentSimpleCode
			s metaType = $E(segmentSimpleCode,0,1)
		} 
		Elseif (conDataType="TextDescSimple")
	    {
		  	s textDescCode = $G(^CacheTempDHCEPRRptCondition($J,"EPR",AEPRConKey,K,"TCODE"))
	     	s textDescSimpleCode = $G(^CacheTempDHCEPRRptCondition($J,"EPR",AEPRConKey,K,"SCODE"))
	      	s KBNodeID =$G(^CacheTempDHCEPRRptCondition($J,"EPR",AEPRConKey,K,"KBNodeID"))
	     	s KBPartNo =$G(^CacheTempDHCEPRRptCondition($J,"EPR",AEPRConKey,K,"KBPartNo"))
	      	s sampleCode= textDescCode_"."_textDescSimpleCode_"."_KBNodeID_"."_KBPartNo
			s metaType = $E(textDescSimpleCode,0,1)
		}  
		
		///取打散数据
		s itemValue=##class(EPRservice.BOScatterData).GetScatterData(AEpisodeKey, templateId, sampleCode, valueType)
		//排除rowId,不要使用 $p(itemValue,"^",2), 因为value中可能有"^"
		//s itemValue=$e(itemValue,$F(itemValue,"^"),$L(itemValue))
	
		///判断查询条件是否成立
		s returnFlag=..JudgeEPRItem(itemValue, conOperator, conValue, metaType)
		
		///条件满足,退出循环
		quit:(returnFlag="True")
	}  
	
	quit returnFlag
}

/// 判断EPR型查询条件是否满足
ClassMethod JudgeEPRItem(aItemValue As %String, aConOperator As %String, aConValue As %String, aMetaType As %String) As %String
{
	s returnFlag="False"
	
	///根据元数据类型判断条件表达式的值
	if (aMetaType="S")||(aMetaType="O")||(aMetaType="M")||(aMetaType="I")||(aMetaType="Q")||(aMetaType="G")||(aMetaType="E")
	{
		s returnFlag = ..CheckConExpressionOfString(aItemValue, aConOperator, aConValue)
	}
	elseif aMetaType="N"
	{
		s returnFlag = ..CheckConExpressionOfNumeric(aItemValue, aConOperator, aConValue)
	}
	elseif aMetaType="D"
	{
		///处理以前出现的时间错误
		if ($F(aItemValue,"99:99:99")>0)
		{ 	
			s aItemValue=$E(aItemValue,1,$L(aItemValue)-9)
		}
		
		///若格式为[yyyy年mm月dd日]，转换为cache内部格式，并取日期部分
		if (aItemValue?4N1"年"1.2N1"月"1.2N1"日")
		{
			s aItemValue=$TRANSLATE(aItemValue,"年","-")
			s aItemValue=$TRANSLATE(aItemValue,"月","-")
			s aItemValue=$TRANSLATE(aItemValue,"日","")
			s aItemValue=$p($zdh(aItemValue,3),",",1)
		}
		
		///检测日期时间条件值合法性，[yyyy-mm-dd]或[yyyy-mm-dd hh:mm:ss]
		if (aConValue?4N1"-"1.2N1"-"1.2N)||(aConValue?4N1"-"1.2N1"-"1.2N1" "2N1":"2N1":"2N)
		{	
			s aConValue=$p($zdh(aConValue,3),",",1)
			s returnFlag = ..CheckConExpressionOfDateTime(aItemValue, aConOperator, aConValue)
		}
		///检测日期时间条件值合法性，[yyyy]或[mm]或[dd]或[hh]或[mm]或[ss]
		elseif (aConValue?4N)||(aConValue?1.2N)
		{
			s returnFlag = ..CheckConExpressionOfDateTime(aItemValue, aConOperator, aConValue)
		}
	}
	
	quit returnFlag
}

/// 遍历满足就诊信息和病历数据查询条件的episodeId结果集（^CacheTempDHCEPRRptAdmID($J,"EPRFilter")）
/// 从中筛选满足 术语集 查询条件的的 episodeId（放入^CacheTempDHCEPRRptAdmID($J,"GlossaryFilter")）
ClassMethod FilterAdmIdByGlossaryCondition()
{
	kill ^CacheTempDHCEPRRptAdmID($J,"GlossaryFilter")
	
	/// 若术语集查询条件为空，拷贝 ^CacheTempEPRFiltratedADMID 到 ^CacheTempEPRGlossaryADMID
	set GlossaryConKey=$order(^CacheTempDHCEPRRptCondition($J,"Glossary",""))
	if (GlossaryConKey="")
	{
		merge ^CacheTempDHCEPRRptAdmID($J,"GlossaryFilter")=^CacheTempDHCEPRRptAdmID($J,"EPRFilter")
		quit ""
	}
	
	/// 若术语集查询条件不为空，筛选 ^CacheTempEPRFiltratedADMID 中的 episodeId 集合，
	/// 生成满足 术语集 查询条件的 episodeId 集合，放入 ^CacheTempEPRGlossaryADMID
	set EpisodeIdKey=$order(^CacheTempDHCEPRRptAdmID($J,"EPRFilter",""))
	while (EpisodeIdKey'="")
	{
		set GlossaryConFlag="False"
		
		/// 判断所有 术语集 条件是否满足
		set GlossaryConKey=$order(^CacheTempDHCEPRRptCondition($J,"Glossary",""))
		while (GlossaryConKey'="")
		{
			/// 根据global节点类型判断其中条件是否满足
			set LogicFlag=$g(^CacheTempDHCEPRRptCondition($J,"Glossary",GlossaryConKey))
			if (LogicFlag="AND")
			{
				set GlossaryConFlag=..ValidateGlossaryConOfNodeAND(EpisodeIdKey,GlossaryConKey)
			}
			else
			{
				set GlossaryConFlag=..ValidateGlossaryConOfNodeOR(EpisodeIdKey,GlossaryConKey)
			} 
			
			/// 任一条件不满足，退出循环
			quit:(GlossaryConFlag="False")
			
			set GlossaryConKey=$order(^CacheTempDHCEPRRptCondition($J,"Glossary",GlossaryConKey))
		}
		
		if (GlossaryConFlag="True")
		{
			set ^CacheTempDHCEPRRptAdmID($J,"GlossaryFilter",EpisodeIdKey)=EpisodeIdKey
		}
		set EpisodeIdKey=$order(^CacheTempDHCEPRRptAdmID($J,"EPRFilter",EpisodeIdKey))
	} ///遍历所有episodeId结束
}

ClassMethod ValidateGlossaryConOfNodeAND(EpisodeIdKey As %String, GlossaryConKey As %String) As %String
{
	//b "s"
	
	quit:(EpisodeIdKey="")||(GlossaryConKey="") "False"
	
	set ReturnFlag="False"
	
	set ConditionType=$g(^CacheTempDHCEPRRptCondition($J,"Glossary",GlossaryConKey,"TYPE"))				///查询条件类型
	set GID=$g(^CacheTempDHCEPRRptCondition($J,"Glossary",GlossaryConKey,"GID"))							///术语集ID
	set ConOperator=$g(^CacheTempDHCEPRRptCondition($J,"Glossary",GlossaryConKey,"CONDITION")) 	///查询条件运算符 
    set ConValue=$g(^CacheTempDHCEPRRptCondition($J,"Glossary",GlossaryConKey,"VALUE"))    		///查询条件值
	set ItemCount = $g(^CacheTempDHCEPRRptCondition($J,"Glossary",GlossaryConKey,"ITEM"))
	
	//comment on 080623
	//set ReturnFlag=..JudgeGlossaryItem(EpisodeIdKey,GID,ConOperator,ConValue)
	
	for I = 1:1:ItemCount
	{
		s type = $g(^CacheTempDHCEPRRptCondition($J,"Glossary",GlossaryConKey,"ITEM",I,"TYPE"))
		s tid = $g(^CacheTempDHCEPRRptCondition($J,"Glossary",GlossaryConKey,"ITEM",I,"TID"))
		s sampleCode = "", vtype = ""
		s metaType = ""
		
		if (type = "Simple")
		{
			s sampleCode = $g(^CacheTempDHCEPRRptCondition($J,"Glossary",GlossaryConKey,"ITEM",I,"SCODE"))
			s metaType =  $E(sampleCode,0,1)
			s vtype = $g(^CacheTempDHCEPRRptCondition($J,"Glossary",GlossaryConKey,"ITEM",I,"VTYPE"))
		}
		elseif (type = "Segment") || (type = "TextDesc")
		{
			s sampleCode = $g(^CacheTempDHCEPRRptCondition($J,"Glossary",GlossaryConKey,"ITEM",I,"SCODE"))
			s metaType =  $E(sampleCode,0,1)
		}
		elseif (type = "SegmentSimple")
		{
			s tcode = $g(^CacheTempDHCEPRRptCondition($J,"Glossary",GlossaryConKey,"ITEM",I,"TCODE"))
			s scode = $g(^CacheTempDHCEPRRptCondition($J,"Glossary",GlossaryConKey,"ITEM",I,"SCODE"))
			s sampleCode = tcode_"."_scode
			s metaType =  $E(scode,0,1)
			s vtype = $g(^CacheTempDHCEPRRptCondition($J,"Glossary",GlossaryConKey,"ITEM",I,"VTYPE"))
		}
		elseif (type = "TextDescSimple")
		{
			s tcode = $g(^CacheTempDHCEPRRptCondition($J,"Glossary",GlossaryConKey,"ITEM",I,"TCODE"))
			s scode = $g(^CacheTempDHCEPRRptCondition($J,"Glossary",GlossaryConKey,"ITEM",I,"SCODE"))
			s sampleCode = tcode_"."_scode
			s metaType = $E(scode,0,1)
			s vtype = $g(^CacheTempDHCEPRRptCondition($J,"Glossary",GlossaryConKey,"ITEM",I,"VTYPE"))
			s kbnodeid = $g(^CacheTempDHCEPRRptCondition($J,"Glossary",GlossaryConKey,"ITEM",I,"KBNodeId"))
			s kbpartno = $g(^CacheTempDHCEPRRptCondition($J,"Glossary",GlossaryConKey,"ITEM",I,"KBPartNo"))	
		}
		
		s itemValue=##class(EPRservice.BOScatterData).GetScatterData(EpisodeIdKey, tid, sampleCode, vtype)
		s ReturnFlag = ..JudgeEPRItem(itemValue,ConOperator,ConValue,metaType)
		 
		quit:(ReturnFlag="True") 
	}
	
	
	quit ReturnFlag
}

ClassMethod ValidateGlossaryConOfNodeOR(EpisodeIdKey As %String, GlossaryConKey As %String) As %String
{
	quit:(EpisodeIdKey=""||GlossaryConKey="") "False"
	
	set ReturnFlag="False"
	
	//debug by houj
	//if EpisodeIdKey="53" b "s"
	
	set I=$Order(^CacheTempDHCEPRRptCondition($J,"Glossary",GlossaryConKey,""))
	while (I '= "")
	{  
		//debug by houj
		//if EpisodeIdKey="53" b "s"
		
		set ConditionType=$g(^CacheTempDHCEPRRptCondition($J,"Glossary",GlossaryConKey,I,"TYPE"))				///查询条件类型
		set GID=$g(^CacheTempDHCEPRRptCondition($J,"Glossary",GlossaryConKey,I,"GID"))							///术语集ID
		set ConOperator=$g(^CacheTempDHCEPRRptCondition($J,"Glossary",GlossaryConKey,I,"CONDITION")) 	///查询条件运算符 
    	set ConValue=$g(^CacheTempDHCEPRRptCondition($J,"Glossary",GlossaryConKey,I,"VALUE"))    		///查询条件值
		
		//comment on 08-06-23
		//set ReturnFlag=..JudgeGlossaryItem(EpisodeIdKey,GID,ConOperator,ConValue)
		
		
		set ItemCount = $g(^CacheTempDHCEPRRptCondition($J,"Glossary",GlossaryConKey,I,"ITEM"))
		for J = 1:1:ItemCount
		{
			//debug by houj
			//if EpisodeIdKey="53" b "s"
			//b "s"
			
			s type = $g(^CacheTempDHCEPRRptCondition($J,"Glossary",GlossaryConKey,I,"ITEM",J,"TYPE"))
			s tid = $g(^CacheTempDHCEPRRptCondition($J,"Glossary",GlossaryConKey,I,"ITEM",J,"TID"))
			s sampleCode = "", vtype = ""
			s metaType = ""
		
			if (type = "Simple")
			{
				s sampleCode = $g(^CacheTempDHCEPRRptCondition($J,"Glossary",GlossaryConKey,I,"ITEM",J,"SCODE"))
				s metaType =  $E(sampleCode,0,1)
				s vtype = $g(^CacheTempDHCEPRRptCondition($J,"Glossary",GlossaryConKey,I,"ITEM",J,"VTYPE"))
			}
			elseif (type = "Segment") || (type = "TextDesc")
			{
				s sampleCode = $g(^CacheTempDHCEPRRptCondition($J,"Glossary",GlossaryConKey,I,"ITEM",J,"SCODE"))
				s metaType =  $E(sampleCode,0,1)
			}
			elseif (type = "SegmentSimple")
			{
			s tcode = $g(^CacheTempDHCEPRRptCondition($J,"Glossary",GlossaryConKey,I,"ITEM",J,"TCODE"))
			s scode = $g(^CacheTempDHCEPRRptCondition($J,"Glossary",GlossaryConKey,I,"ITEM",J,"SCODE"))
			s sampleCode = tcode_"."_scode
			s metaType =  $E(scode,0,1)
			s vtype = $g(^CacheTempDHCEPRRptCondition($J,"Glossary",GlossaryConKey,I,"ITEM",J,"VTYPE"))
			}
			elseif (type = "TextDescSimple")
			{
				s tcode = $g(^CacheTempDHCEPRRptCondition($J,"Glossary",GlossaryConKey,I,"ITEM",J,"TCODE"))
				s scode = $g(^CacheTempDHCEPRRptCondition($J,"Glossary",GlossaryConKey,I,"ITEM",J,"SCODE"))
				s sampleCode = tcode_"."_scode
				s metaType = $E(scode,0,1)
				s vtype = $g(^CacheTempDHCEPRRptCondition($J,"Glossary",GlossaryConKey,I,"ITEM",J,"VTYPE"))
				s kbnodeid = $g(^CacheTempDHCEPRRptCondition($J,"Glossary",GlossaryConKey,I,"ITEM",J,"KBNodeId"))
				s kbpartno = $g(^CacheTempDHCEPRRptCondition($J,"Glossary",GlossaryConKey,I,"ITEM",J,"KBPartNo"))	
			}
			
			//debug by houj
			//b "s"
			
			s itemValue=##class(EPRservice.BOScatterData).GetScatterData(EpisodeIdKey, tid, sampleCode, vtype)
			s ReturnFlag = ..JudgeEPRItem(itemValue,ConOperator,ConValue,metaType)
		 
			quit:(ReturnFlag="True") 
		}
		
		quit:(ReturnFlag="True")
		
		set I=$Order(^CacheTempDHCEPRRptCondition($J,"Glossary",GlossaryConKey,I))
	}
	
	quit ReturnFlag
}

ClassMethod JudgeGlossaryItem(aEpisodeKey As %String, aGlossaryID As %String, aOperator As %String, aConditionVale As %String) As %String
{
	//if aEpisodeKey="49" b "s"
	
	quit:(aGlossaryID="") "False"

	set returnFlag="False"	
	
	set itemValue=##class(EPRservice.BOScatterData).GetScatterDataByGlossaryID(aEpisodeKey,aGlossaryID)
	set itemCount=$L(itemValue,"&|")
	for I=1:1:itemCount
	{
		//if aEpisodeKey="49" b "s"
		set item = $p(itemValue,"&|",I)
		set metaType = $e(item,0,1)
		set item = $e(item,3,$L(item))
		set returnFlag=..JudgeEPRItem(item,aOperator,aConditionVale,metaType)
		
		quit:(returnFlag="True")
	}
	quit returnFlag
}

/// 遍历满足就诊信息、病历数据、术语集查询条件的episodeId结果集（^CacheTempDHCEPRRptAdmID($J,"GlossaryFilter")）
/// 从中筛选满足【LIS数据】查询条件的的 episodeId（放入^CacheTempDHCEPRRptAdmID($J,"LISFilter")）
ClassMethod FilterAdmIdByLISCondition()
{
	kill ^CacheTempDHCEPRRptAdmID($J,"LISFilter")
	
	/// 若LIS数据查询条件为空，拷贝 ^CacheTempDHCEPRRptAdmID($J,"GlossaryFilter") 到 ^CacheTempDHCEPRRptAdmID($J,"LISFilter")
	set ConKey=$order(^CacheTempDHCEPRRptCondition($J,"LIS",""))
	if (ConKey="")
	{
		merge ^CacheTempDHCEPRRptAdmID($J,"LISFilter")=^CacheTempDHCEPRRptAdmID($J,"GlossaryFilter")
		quit ""
	}
}

/// 遍历满足就诊信息、病历数据、术语集查询条件的episodeId结果集（^CacheTempDHCEPRRptAdmID($J,"LISFilter")）
/// 从中筛选满足【PACS数据】查询条件的的 episodeId（放入^CacheTempDHCEPRRptAdmID($J,"PACSFilter")）
ClassMethod FilterAdmIdByPACSCondition()
{
	kill ^CacheTempDHCEPRRptAdmID($J,"PACSFilter")
	
	/// 若LIS数据查询条件为空，拷贝 ^CacheTempDHCEPRRptAdmID($J,"LISFilter") 到 ^CacheTempDHCEPRRptAdmID($J,"PACSFilter")
	set ConKey=$order(^CacheTempDHCEPRRptCondition($J,"PACS",""))
	if (ConKey="")
	{
		merge ^CacheTempDHCEPRRptAdmID($J,"PACSFilter")=^CacheTempDHCEPRRptAdmID($J,"LISFilter")
		quit ""
	}
}

/// 为报表取返回值
ClassMethod BuildEachRowResult()
{
 	K ^CacheTempDHCEPRRptEachResult($J)
 	Set resultDataCount = 0 
 	
 	/// 遍历所有满足条件的episodeId集合(每个episodeId就是一条结果)
 	set filtrateEpisodeKey= $O(^CacheTempDHCEPRRptAdmID($J,"GlossaryFilter",""))	
 	WHILE (filtrateEpisodeKey'="") 
 	{
	 	///查询结果的条数
	 	s resultDataCount=resultDataCount+1
	 	
	 	///遍历所有报表项取相应数据
  		Set resultColItemKey=$ORDER(^CacheTempDHCEPRRptColumn($J,""))
  		while (resultColItemKey'="")
  		{
	  		///报表项的数目
			set resultColItemCount= $G(^CacheTempDHCEPRRptSysResult($J,"ResultColCount"))	   
			
			///get item data
			set eachItemDataValue=""
			Set ConDataType= $G(^CacheTempDHCEPRRptColumn($J,resultColItemKey,"Type"))
			if (ConDataType="Episode")
			{ 
     			s EpisodeFTYPE =""
     			S EpisodeFName = $G(^CacheTempDHCEPRRptColumn($J,resultColItemKey,"FNAME"))
	 			S EpisodeFTYPE = $G(^CacheTempDHCEPRRptColumn($J,resultColItemKey,"FTYPE"))
	 			s eachItemDataValue = ##class(EPRservice.SystemData).GetEpisodeInfoByItemName(EpisodeFName,filtrateEpisodeKey)
   				if ((EpisodeFTYPE="DateTime") && (eachItemDataValue'=""))
   				{	s eachItemDataValue=$zd(eachItemDataValue,3)}
   			}
			Elseif (ConDataType="Simple")
			{
	  			set templateId = $G(^CacheTempDHCEPRRptColumn($J,resultColItemKey,"TID"))
	  			Set valueType = $G(^CacheTempDHCEPRRptColumn($J,resultColItemKey,"VTYPE"))
	  			set simpleCode = $G(^CacheTempDHCEPRRptColumn($J,resultColItemKey,"SCODE"))	
	      		set metaType = $EXTRACT($G(^CacheTempDHCEPRRptColumn($J,resultColItemKey,"SCODE")),1)	
	  			
	  			set itemId = ##class(EPRservice.BOScatterData).GetISimpleId(filtrateEpisodeKey,templateId,simpleCode)
	  			if itemId = ""
	  			{	s eachItemDataValue="*NULL"}
	  			else
	  			{	s eachItemDataValue=##class(EPRservice.BOScatterData).GetISimpleValue(itemId,metaType,valueType)}
			}
			Elseif (ConDataType="Segment")
			{
				set templateId = $G(^CacheTempDHCEPRRptColumn($J,resultColItemKey,"TID"))
	  			///Set valueType = $G(^CacheTempDHCEPRRptColumn($J,resultColItemKey,"VTYPE"))
	  			set segmentCode = $G(^CacheTempDHCEPRRptColumn($J,resultColItemKey,"SCODE"))	
	      		set metaType = $EXTRACT($G(^CacheTempDHCEPRRptColumn($J,resultColItemKey,"SCODE")),1)	
	 			
	 			set itemId = ##class(EPRservice.BOScatterData).GetISegmentId(filtrateEpisodeKey,templateId,segmentCode)
	  			if itemId = ""
	  			{	s eachItemDataValue="*NULL"}
	  			else
	  			{	s eachItemDataValue=##class(EPRservice.BOScatterData).GetISegmentValue(itemId)}
  			}
			Elseif (ConDataType="TextDesc")
			{	
   	  			set templateId = $G(^CacheTempDHCEPRRptColumn($J,resultColItemKey,"TID"))
	  			///Set valueType = $G(^CacheTempDHCEPRRptColumn($J,resultColItemKey,"VTYPE"))
	  			set textDescCode = $G(^CacheTempDHCEPRRptColumn($J,resultColItemKey,"SCODE"))	
	      		set metaType = $EXTRACT($G(^CacheTempDHCEPRRptColumn($J,resultColItemKey,"SCODE")),1)	
	 			
	 			set itemId = ##class(EPRservice.BOScatterData).GetITextDescId(filtrateEpisodeKey,templateId,textDescCode)
	  			if itemId = ""
	  			{	s eachItemDataValue="*NULL"}
	  			else
	  			{	s eachItemDataValue=##class(EPRservice.BOScatterData).GetITextDescValue(itemId)	}
			}
   			Elseif (ConDataType="SegmentSimple")
   			{
   	  			set templateId = $G(^CacheTempDHCEPRRptColumn($J,resultColItemKey,"TID"))
	  			Set valueType = $G(^CacheTempDHCEPRRptColumn($J,resultColItemKey,"VTYPE"))
	  			set segmentCode = $G(^CacheTempDHCEPRRptColumn($J,resultColItemKey,"TCODE"))
	  			set sgSimpleCode = $G(^CacheTempDHCEPRRptColumn($J,resultColItemKey,"SCODE"))	
	      		set metaType = $EXTRACT($G(^CacheTempDHCEPRRptColumn($J,resultColItemKey,"SCODE")),1)	
	  			
	  			set itemId = ##class(EPRservice.BOScatterData).GetISegmentSimpleId(filtrateEpisodeKey,templateId,segmentCode,sgSimpleCode)
	  			if itemId = ""
	  			{	s eachItemDataValue="*NULL"}
	  			else
	  			{	s eachItemDataValue=##class(EPRservice.BOScatterData).GetISegmentSimpleValue(itemId,metaType,valueType)}	
	  		}
  			Elseif (ConDataType="TextDescSimple")
   			{
	   			set templateId = $G(^CacheTempDHCEPRRptColumn($J,resultColItemKey,"TID"))
	  			Set valueType = $G(^CacheTempDHCEPRRptColumn($J,resultColItemKey,"VTYPE"))
	  			set textDescCode = $G(^CacheTempDHCEPRRptColumn($J,resultColItemKey,"TCODE"))
	  			set textSimpleCode = $G(^CacheTempDHCEPRRptColumn($J,resultColItemKey,"SCODE"))	
	      		set metaType = $EXTRACT($G(^CacheTempDHCEPRRptColumn($J,resultColItemKey,"SCODE")),1)	
	  			set KBNodeID =$G(^CacheTempDHCEPRRptColumn($J,resultColItemKey,"KBNodeID"))
	  			set KBPartNo =$G(^CacheTempDHCEPRRptColumn($J,resultColItemKey,"KBPartNo"))
	  			
	  			set itemId = ##class(EPRservice.BOScatterData).GetITextDescSimpleId(filtrateEpisodeKey,templateId,textDescCode,textSimpleCode,KBNodeID,KBPartNo)
	  			if itemId = ""
	  			{	s eachItemDataValue="*NULL"}
	  			else
	  			{	s eachItemDataValue=##class(EPRservice.BOScatterData).GetITextDescSimpleValue(itemId)} 	  
    		}
    		Elseif (ConDataType="Glossary")
    		{
	    		//set glossaryId = $G(^CacheTempDHCEPRRptColumn($J,resultColItemKey,"GID"))
	    		//set eachItemDataValue = ##class(EPRservice.BOScatterData).GetScatterDataByGlossaryID(filtrateEpisodeKey,glossaryId)
	    		set eachItemDataValue = ..GetGlossaryValue(resultColItemKey,filtrateEpisodeKey)
	    	}
	    	elseif (ConDataType="LIS")
	    	{
		    }
		    elseif (ConDataType="PACS")
		    {
			} 		  
    		/// 将该条查询记录的一项结果存储在临时global中
			Set ^CacheTempDHCEPRRptEachResult($J,resultDataCount,resultColItemKey) =eachItemDataValue
						
			Set resultColItemKey=$ORDER(^CacheTempDHCEPRRptColumn($J,resultColItemKey))
		}  ///遍历报表项列数完毕 
  
  		Set ^CacheTempDHCEPRRptEachResult($J,resultDataCount) = filtrateEpisodeKey
  
  		SET filtrateEpisodeKey = $ORDER(^CacheTempDHCEPRRptAdmID($J,"GlossaryFilter",filtrateEpisodeKey))
	}  ///遍历满足条件的episodeId集完毕
 
 	set ^CacheTempDHCEPRRptSysResult($J,"ResultCount") = resultDataCount
}

ClassMethod GetGlossaryValue(resultColItemKey As %String, filtrateEpisodeKey As %String) As %String
{
	//debug by houj
	//b 
	
	set retVal = ""
	
	set itemCount = $g(^CacheTempDHCEPRRptColumn($J,resultColItemKey,"ITEM"))
	for count = 1:1:itemCount
	{
		set desc = $g(^CacheTempDHCEPRRptColumn($J,resultColItemKey,"ITEM",count,"DESC"))
		set type = $g(^CacheTempDHCEPRRptColumn($J,resultColItemKey,"ITEM",count,"TYPE"))
		set tid = $g(^CacheTempDHCEPRRptColumn($J,resultColItemKey,"ITEM",count,"TID"))
		set sampleCode = "", vtype = ""
		set metaType = ""
	
		//debug by houj
		//b
		//
		if (type = "Simple")
		{
			set sampleCode = ^CacheTempDHCEPRRptColumn($J,resultColItemKey,"ITEM",count,"SCODE")
			set metaType = $E(sampleCode,0,1)
			set vtype = ^CacheTempDHCEPRRptColumn($J,resultColItemKey,"ITEM",count,"VTYPE")
		}
		elseif (type = "Segment") || (type = "TextDesc")
		{
			set sampleCode = ^CacheTempDHCEPRRptColumn($J,resultColItemKey,"ITEM",count,"SCODE")
			set metaType = $E(sampleCode,0,1)
		}
		elseif (type = "SegmentSimple" )
		{
			set scode = ^CacheTempDHCEPRRptColumn($J,resultColItemKey,"ITEM",count,"SCODE")
			set tcode = ^CacheTempDHCEPRRptColumn($J,resultColItemKey,"ITEM",count,"TCODE")
			set sampleCode = tcode_"."_scode
			set metaType = $E(scode,0,1)
			set vtype = ^CacheTempDHCEPRRptColumn($J,resultColItemKey,"ITEM",count,"VTYPE")
		}
		elseif (type = "TextDescSimple")
		{
			set scode = ^CacheTempDHCEPRRptColumn($J,resultColItemKey,"ITEM",count,"SCODE")
			set tcode = ^CacheTempDHCEPRRptColumn($J,resultColItemKey,"ITEM",count,"TCODE")
			set kbnodeid = ^CacheTempDHCEPRRptColumn($J,resultColItemKey,"ITEM",count,"KBNodeId")
			set kbpartno = ^CacheTempDHCEPRRptColumn($J,resultColItemKey,"ITEM",count,"KBPartNo")
			set sampleCode = tcode_"."_scode_"."_kbnodeid_"."_kbpartno
			set metaType = $E(scode,0,1)
			set vtype = ^CacheTempDHCEPRRptColumn($J,resultColItemKey,"ITEM",count,"VTYPE")
		}
		
		//debug by houj
		//b "s"
		
		s itemValue=##class(EPRservice.BOScatterData).GetScatterData(filtrateEpisodeKey, tid, sampleCode, vtype)
		if (itemValue '= "")&&(itemValue '= "Null")
		{
			s retVal = retVal_desc_"： " _itemValue_$c(13,10)
		}
	}
	
	if (retVal '= "")
	{	s retVal =$E(retVal,0,$L(retVal)-2)}
	
	quit retVal
}

ClassMethod BuildNewRowAggregateResult(AKKey As %String, ADataConType As %String, ALastResultCount As %Integer, AEachResultKey As %String)
{
	Set ADataConType= $G(^CacheTempDHCEPRRptColumn($J,AKKey,"Type"))
	if (ADataConType="Episode")
    {  //get Episode Item Value
       s EpisodeFTYPE =""
       S EpisodeFTYPE = $G(^CacheTempDHCEPRRptColumn($J,AKKey,"FTYPE"))
       s GroupValue=""
       set GroupValue= $G(^CacheTempDHCEPRRptColumn($J,AKKey,"GROUP"))
       if (EpisodeFTYPE="String")
       {
    	if ((GroupValue="SUM")||(GroupValue="AVG"))
        { 
         set ^CacheTempDHCEPRRptGroupResult($J,ALastResultCount,AKKey)  ="*NULL" 	
        }
        Elseif (GroupValue="COUNT")
        {
	      set ^CacheTempDHCEPRRptGroupResult($J,ALastResultCount,AKKey)  = 1
	     }
     Elseif (GroupValue="MAX")
     {
	  set ^CacheTempDHCEPRRptGroupResult($J,ALastResultCount,AKKey)  =$G(^CacheTempDHCEPRRptEachResult($J,AEachResultKey,AKKey)) 	   
	     }
     Elseif (GroupValue="MIN")
     {
	   set ^CacheTempDHCEPRRptGroupResult($J,ALastResultCount,AKKey)  =$G(^CacheTempDHCEPRRptEachResult($J,AEachResultKey,AKKey)) 	 
	     }
	 Elseif (GroupValue="GROUPBY")
	 {
		 set ^CacheTempDHCEPRRptGroupResult($J,ALastResultCount,AKKey)  =$G(^CacheTempDHCEPRRptEachResult($J,AEachResultKey,AKKey)) 	  
		 }    
             }
           Elseif (EpisodeFTYPE="DateTime")
           {
  if ((GroupValue="SUM")||(GroupValue="AVG"))
  { set ^CacheTempDHCEPRRptGroupResult($J,ALastResultCount,AKKey)  =$G(^CacheTempDHCEPRRptEachResult($J,AEachResultKey,AKKey)) 	 
  }
  Elseif (GroupValue="COUNT")
  {
	  set ^CacheTempDHCEPRRptGroupResult($J,ALastResultCount,AKKey)=1
	  }
  Elseif (GroupValue="MAX")
  {
	set ^CacheTempDHCEPRRptGroupResult($J,ALastResultCount,AKKey)  =$G(^CacheTempDHCEPRRptEachResult($J,AEachResultKey,AKKey)) 	 
	  }
   Elseif (GroupValue="MIN")
   {
	 set ^CacheTempDHCEPRRptGroupResult($J,ALastResultCount,AKKey)  =$G(^CacheTempDHCEPRRptEachResult($J,AEachResultKey,AKKey)) 	  
	   }	  
	 Elseif (GroupValue="GROUPBY")
	 {
		 set ^CacheTempDHCEPRRptGroupResult($J,ALastResultCount,AKKey)  =$G(^CacheTempDHCEPRRptEachResult($J,AEachResultKey,AKKey)) 	  
		 }    
             }
           Elseif (EpisodeFTYPE="Numeric")
           {
  if ((GroupValue="SUM")||(GroupValue="AVG"))
  { set ^CacheTempDHCEPRRptGroupResult($J,ALastResultCount,AKKey)  =$G(^CacheTempDHCEPRRptEachResult($J,AEachResultKey,AKKey)) 	 
  }
  Elseif (GroupValue="COUNT")
  {
	  set ^CacheTempDHCEPRRptGroupResult($J,ALastResultCount,AKKey)=1
	  }
  Elseif (GroupValue="MAX")
  {
	set ^CacheTempDHCEPRRptGroupResult($J,ALastResultCount,AKKey)  =$G(^CacheTempDHCEPRRptEachResult($J,AEachResultKey,AKKey)) 	 
	  }
   Elseif (GroupValue="MIN")
   {
	 set ^CacheTempDHCEPRRptGroupResult($J,ALastResultCount,AKKey)  =$G(^CacheTempDHCEPRRptEachResult($J,AEachResultKey,AKKey)) 	  
	   }	  
	 Elseif (GroupValue="GROUPBY")
	 {
		 set ^CacheTempDHCEPRRptGroupResult($J,ALastResultCount,AKKey)  =$G(^CacheTempDHCEPRRptEachResult($J,AEachResultKey,AKKey)) 	  
		 }    
           }
       }
       Elseif (ADataConType="Simple")
         {
        s ACodeType=""
	     set ACodeType = $EXTRACT($G(^CacheTempDHCEPRRptColumn($J,AKKey,"SCODE")),1)	   
 s GroupValue=""
 set GroupValue= $G(^CacheTempDHCEPRRptColumn($J,AKKey,"GROUP"))
 if (ACodeType="S")
 {
    if ((GroupValue="SUM")||(GroupValue="AVG"))
    { 
     set ^CacheTempDHCEPRRptGroupResult($J,ALastResultCount,AKKey)  ="*NULL" 	
    }
     Elseif (GroupValue="COUNT")
     {
	   set ^CacheTempDHCEPRRptGroupResult($J,ALastResultCount,AKKey)  = 1
	     }
     Elseif (GroupValue="MAX")
     {
	  set ^CacheTempDHCEPRRptGroupResult($J,ALastResultCount,AKKey)  =$G(^CacheTempDHCEPRRptEachResult($J,AEachResultKey,AKKey)) 	   
	     }
     Elseif (GroupValue="MIN")
     {
	   set ^CacheTempDHCEPRRptGroupResult($J,ALastResultCount,AKKey)  =$G(^CacheTempDHCEPRRptEachResult($J,AEachResultKey,AKKey)) 	 
	     }
	 Elseif (GroupValue="GROUPBY")
	 {
	  set ^CacheTempDHCEPRRptGroupResult($J,ALastResultCount,AKKey)  =$G(^CacheTempDHCEPRRptEachResult($J,AEachResultKey,AKKey)) 	 	 
		 }    
	 }
 Elseif (ACodeType="N")
  	 { 
  if ((GroupValue="SUM")||(GroupValue="AVG"))
  { set ^CacheTempDHCEPRRptGroupResult($J,ALastResultCount,AKKey)  =$G(^CacheTempDHCEPRRptEachResult($J,AEachResultKey,AKKey)) 	 
  }
  Elseif (GroupValue="COUNT")
  {
	  set ^CacheTempDHCEPRRptGroupResult($J,ALastResultCount,AKKey)=1
	  }
  Elseif (GroupValue="MAX")
  {
	set ^CacheTempDHCEPRRptGroupResult($J,ALastResultCount,AKKey)  =$G(^CacheTempDHCEPRRptEachResult($J,AEachResultKey,AKKey)) 	 
	  }
   Elseif (GroupValue="MIN")
   {
	 set ^CacheTempDHCEPRRptGroupResult($J,ALastResultCount,AKKey)  =$G(^CacheTempDHCEPRRptEachResult($J,AEachResultKey,AKKey)) 	  
	   }
	 Elseif (GroupValue="GROUPBY")
	 {
	  set ^CacheTempDHCEPRRptGroupResult($J,ALastResultCount,AKKey)  =$G(^CacheTempDHCEPRRptEachResult($J,AEachResultKey,AKKey)) 	 	 
		 }    
	 }
          Elseif (ACodeType="Q")
          { 
  if ((GroupValue="SUM")||(GroupValue="AVG"))
  { set ^CacheTempDHCEPRRptGroupResult($J,ALastResultCount,AKKey)  =$G(^CacheTempDHCEPRRptEachResult($J,AEachResultKey,AKKey)) 	 
  }
  Elseif (GroupValue="COUNT")
  {
	  set ^CacheTempDHCEPRRptGroupResult($J,ALastResultCount,AKKey)=1
	  }
  Elseif (GroupValue="MAX")
  {
	set ^CacheTempDHCEPRRptGroupResult($J,ALastResultCount,AKKey)  =$G(^CacheTempDHCEPRRptEachResult($J,AEachResultKey,AKKey)) 	 
	  }
   Elseif (GroupValue="MIN")
   {
	 set ^CacheTempDHCEPRRptGroupResult($J,ALastResultCount,AKKey)  =$G(^CacheTempDHCEPRRptEachResult($J,AEachResultKey,AKKey)) 	  
	   }
	 Elseif (GroupValue="GROUPBY")
	 {
	  set ^CacheTempDHCEPRRptGroupResult($J,ALastResultCount,AKKey)  =$G(^CacheTempDHCEPRRptEachResult($J,AEachResultKey,AKKey)) 	 	 
		 }    
            }				  
        Elseif (ACodeType="D")
        {  
  if ((GroupValue="SUM")||(GroupValue="AVG"))
  { set ^CacheTempDHCEPRRptGroupResult($J,ALastResultCount,AKKey)  =$G(^CacheTempDHCEPRRptEachResult($J,AEachResultKey,AKKey)) 	 
  }
  Elseif (GroupValue="COUNT")
  {
	  set ^CacheTempDHCEPRRptGroupResult($J,ALastResultCount,AKKey)=1
	  }
  Elseif (GroupValue="MAX")
  {
	set ^CacheTempDHCEPRRptGroupResult($J,ALastResultCount,AKKey)  =$G(^CacheTempDHCEPRRptEachResult($J,AEachResultKey,AKKey)) 	 
	  }
   Elseif (GroupValue="MIN")
   {
	 set ^CacheTempDHCEPRRptGroupResult($J,ALastResultCount,AKKey)  =$G(^CacheTempDHCEPRRptEachResult($J,AEachResultKey,AKKey)) 	  
	   }	  
	 Elseif (GroupValue="GROUPBY")
	 {
	  set ^CacheTempDHCEPRRptGroupResult($J,ALastResultCount,AKKey)  =$G(^CacheTempDHCEPRRptEachResult($J,AEachResultKey,AKKey)) 	 	 
		 }    
        }     	  
      Elseif (ACodeType="I")
      {   
    if ((GroupValue="SUM")||(GroupValue="AVG"))
    { 
     set ^CacheTempDHCEPRRptGroupResult($J,ALastResultCount,AKKey)  ="*NULL" 	
    }
     Elseif (GroupValue="COUNT")
     {
	   set ^CacheTempDHCEPRRptGroupResult($J,ALastResultCount,AKKey)  = 1
	     }
     Elseif (GroupValue="MAX")
     {
	  set ^CacheTempDHCEPRRptGroupResult($J,ALastResultCount,AKKey)  = "*NULL"
	     }
     Elseif (GroupValue="MIN")
     {
	   set ^CacheTempDHCEPRRptGroupResult($J,ALastResultCount,AKKey)  = "*NULL"
	     }
	 Elseif (GroupValue="GROUPBY")
	 {
	  set ^CacheTempDHCEPRRptGroupResult($J,ALastResultCount,AKKey)  =$G(^CacheTempDHCEPRRptEachResult($J,AEachResultKey,AKKey)) 	 	 
		 }    

       }
    Elseif (ACodeType="M")||(ACodeType="O")
    { 
    if ((GroupValue="SUM")||(GroupValue="AVG"))
    { 
     set ^CacheTempDHCEPRRptGroupResult($J,ALastResultCount,AKKey)  ="*NULL" 	
    }
     Elseif (GroupValue="COUNT")
     {
	   set ^CacheTempDHCEPRRptGroupResult($J,ALastResultCount,AKKey)  = 1
	     }
     Elseif (GroupValue="MAX")
     {
	  set ^CacheTempDHCEPRRptGroupResult($J,ALastResultCount,AKKey)  ="*NULL"
	     }
     Elseif (GroupValue="MIN")
     {
	   set ^CacheTempDHCEPRRptGroupResult($J,ALastResultCount,AKKey)  ="*NULL" 	 
	     }
	 Elseif (GroupValue="GROUPBY")
	 {
	  set ^CacheTempDHCEPRRptGroupResult($J,ALastResultCount,AKKey)  =$G(^CacheTempDHCEPRRptEachResult($J,AEachResultKey,AKKey)) 	 	 
		 }    
      }   		   	       

 }
}

ClassMethod BuildHasRowAggregateResult(AResultItemSeq As %Integer, AEachResultKey As %String, ALastResultItemKey As %String, ADataConType As %String)
{
   Set AggregateItemValue = $G(^CacheTempDHCEPRRptEachResult($J,AEachResultKey,AResultItemSeq))
   set OldAggItemValue = $G(^CacheTempDHCEPRRptGroupResult($J,ALastResultItemKey,AResultItemSeq)) 
   Set ADataConType= $G(^CacheTempDHCEPRRptColumn($J,ResultColItemKey,"Type"))
   if (ADataConType="Episode")
   {
         //get Episode Item Value
     s EpisodeFTYPE =""
     S EpisodeFTYPE = $G(^CacheTempDHCEPRRptColumn($J,K,"FTYPE"))
     s GroupValue=""
     set GroupValue= $G(^CacheTempDHCEPRRptColumn($J,K,"GROUP"))
	 set AVGCountNum = $G(^CacheTempDHCEPRRptGroupResult($J,ALastResultItemKey,"AVGCOUNT")) 
     if (EpisodeFTYPE="String")
     {
       if ((GroupValue="SUM")||(GroupValue="AVG"))
      { 
       set ^CacheTempDHCEPRRptGroupResult($J,ALastResultItemKey,AResultItemSeq)  ="*NULL" 	
       }
       Elseif (GroupValue="COUNT")
       {
        set ^CacheTempDHCEPRRptGroupResult($J,ALastResultItemKey,AResultItemSeq)  = OldAggItemValue + 1
       }
       Elseif (GroupValue="MAX")
       {
        if (AggregateItemValue>=OldAggItemValue)
 	     {set ^CacheTempDHCEPRRptGroupResult($J,ALastResultItemKey,AResultItemSeq) = AggregateItemValue }
 	     elseif (AggregateItemValue<OldAggItemValue)
 	     { set ^CacheTempDHCEPRRptGroupResult($J,ALastResultItemKey,AResultItemSeq) = OldAggItemValue }
        }
       Elseif (GroupValue="MIN")
       {
         if (AggregateItemValue<=OldAggItemValue)
 	     {set ^CacheTempDHCEPRRptGroupResult($J,ALastResultItemKey,AResultItemSeq) = AggregateItemValue }
 	      elseif (AggregateItemValue>OldAggItemValue)
 	     { set ^CacheTempDHCEPRRptGroupResult($J,ALastResultItemKey,AResultItemSeq) = OldAggItemValue }
        }
       Elseif (GroupValue="GROUPBY")
        { }    
       }
     Elseif (EpisodeFTYPE="DateTime")
     {
       if (GroupValue="SUM")
        { set ^CacheTempDHCEPRRptGroupResult($J,ALastResultItemKey,AResultItemSeq)  =OldAggItemValue + AggregateItemValue
        }
        Elseif (GroupValue="AVG")
        { Set NewAVGItemValue = (OldAggItemValue*AVGCountNum + AggregateItemValue)/(AVGCountNum +1)
	      set ^CacheTempDHCEPRRptGroupResult($J,ALastResultItemKey,AResultItemSeq) = NewAVGItemValue  
	     }
        Elseif (GroupValue="COUNT")
        { set ^CacheTempDHCEPRRptGroupResult($J,ALastResultItemKey,AResultItemSeq)=OldAggItemValue +1
        }
        Elseif (GroupValue="MAX")
        {
           if (AggregateItemValue>=OldAggItemValue)
 	        {set ^CacheTempDHCEPRRptGroupResult($J,ALastResultItemKey,AResultItemSeq) = AggregateItemValue }
 	       elseif (AggregateItemValue<OldAggItemValue)
 	        { set ^CacheTempDHCEPRRptGroupResult($J,ALastResultItemKey,AResultItemSeq) = OldAggItemValue }
          }
         Elseif (GroupValue="MIN")
       {
          if (AggregateItemValue<=OldAggItemValue)
 	      { set ^CacheTempDHCEPRRptGroupResult($J,ALastResultItemKey,AResultItemSeq) = AggregateItemValue }
 	        elseif (AggregateItemValue>OldAggItemValue)
 	     { set ^CacheTempDHCEPRRptGroupResult($J,ALastResultItemKey,AResultItemSeq) = OldAggItemValue }
        }	  
       Elseif (GroupValue="GROUPBY")
       {   }    
      }
      Elseif (EpisodeFTYPE="Numeric")
      {  if (GroupValue="SUM")
          { set ^CacheTempDHCEPRRptGroupResult($J,ALastResultItemKey,AResultItemSeq)  =OldAggItemValue + AggregateItemValue
          }
           Elseif (GroupValue="AVG")
           {
            Set NewAVGItemValue = (OldAggItemValue*AVGCountNum + AggregateItemValue)/(AVGCountNum +1)
	        set ^CacheTempDHCEPRRptGroupResult($J,ALastResultItemKey,AResultItemSeq) = NewAVGItemValue  
	        }
            Elseif (GroupValue="COUNT")
            {
              set ^CacheTempDHCEPRRptGroupResult($J,ALastResultItemKey,AResultItemSeq)= OldAggItemValue + 1
            }
            Elseif (GroupValue="MAX")
            {
              if (AggregateItemValue>=OldAggItemValue)
 	          {set ^CacheTempDHCEPRRptGroupResult($J,ALastResultItemKey,AResultItemSeq) = AggregateItemValue }
 	           elseif (AggregateItemValue<OldAggItemValue)
 	           { set ^CacheTempDHCEPRRptGroupResult($J,ALastResultItemKey,AResultItemSeq) = OldAggItemValue }
              }
            Elseif (GroupValue="MIN")
             { 
              if (AggregateItemValue<=OldAggItemValue)
 	            {set ^CacheTempDHCEPRRptGroupResult($J,ALastResultItemKey,AResultItemSeq) = AggregateItemValue }
 	           elseif (AggregateItemValue>OldAggItemValue)
 	             { set ^CacheTempDHCEPRRptGroupResult($J,ALastResultItemKey,AResultItemSeq) = OldAggItemValue }
                }	  
            Elseif (GroupValue="GROUPBY")
            {
	        }    
       }
     }
     Elseif (ADataConType="Simple")
     { if $D(^CacheTempDHCEPRRptColumn($J,ResultColItemKey,"GROUP"))
	   { 
         set GroupValue= $G(^CacheTempDHCEPRRptColumn($J,ResultColItemKey,"GROUP"))
	     set ACodeType = $EXTRACT($G(^CacheTempDHCEPRRptColumn($J,AResultColItemKey,"SCODE")),1)	 
	     set AVGCountNum = $G(^CacheTempDHCEPRRptGroupResult($J,ALastResultItemKey,"AVGCOUNT")) 
	     if (GroupValue="GROUPBY")
	     {  }
	      Elseif (GroupValue="SUM")
	     {
 	      //if (ACodeType="S")||(ACodeType="N")||(ACodeType="O")||(ACodeType="M")||(ACodeType="Q")||(ACodeType="I")
 	      if ((ACodeType="S")||(ACodeType="O")||(ACodeType="M"))
 	      { set ^CacheTempDHCEPRRptGroupResult($J,ALastResultItemKey,AResultItemSeq) = "*NULL" 	 	}
 	      Elseif (ACodeType="N")
	      { set ^CacheTempDHCEPRRptGroupResult($J,ALastResultItemKey,AResultItemSeq) = OldAggItemValue + AggregateItemValue  }
          Elseif (ACodeType="Q")
          { set ^CacheTempDHCEPRRptGroupResult($J,ALastResultItemKey,AResultItemSeq) = OldAggItemValue + AggregateItemValue     }				  
          Elseif (ACodeType="D")
          { set ^CacheTempDHCEPRRptGroupResult($J,ALastResultItemKey,AResultItemSeq) = "*NULL"  }     	  
          Elseif (ACodeType="I")
          { set ^CacheTempDHCEPRRptGroupResult($J,ALastResultItemKey,AResultItemSeq) = "*NULL"   }
          Elseif (ACodeType="M")
          {set ^CacheTempDHCEPRRptGroupResult($J,ALastResultItemKey,AResultItemSeq) = "*NULL"  }   
         }
	      Elseif (GroupValue="AVG")
	      {
 	        if ((ACodeType="S")||(ACodeType="O")||(ACodeType="M"))
 	        { set ^CacheTempDHCEPRRptGroupResult($J,ALastResultItemKey,AResultItemSeq) = "*NULL" 	 	}
 	        Elseif (ACodeType="N")
	        { Set NewAVGItemValue = (OldAggItemValue*AVGCountNum + AggregateItemValue)/(AVGCountNum +1)
	          set ^CacheTempDHCEPRRptGroupResult($J,ALastResultItemKey,AResultItemSeq) = NewAVGItemValue  }
            Elseif (ACodeType="Q")
            { Set NewAVGItemValue = (OldAggItemValue*AVGCountNum + AggregateItemValue)/(AVGCountNum +1)
	          set ^CacheTempDHCEPRRptGroupResult($J,ALastResultItemKey,AResultItemSeq) = NewAVGItemValue     }				  
              Elseif (ACodeType="D")
              { set ^CacheTempDHCEPRRptGroupResult($J,ALastResultItemKey,AResultItemSeq) = "*NULL"  }     	  
              Elseif (ACodeType="I")
              { set ^CacheTempDHCEPRRptGroupResult($J,ALastResultItemKey,AResultItemSeq) = "*NULL"   }
              Elseif (ACodeType="M")
              { set ^CacheTempDHCEPRRptGroupResult($J,ALastResultItemKey,AResultItemSeq) = "*NULL"  }   
  	        }
	        Elseif (GroupValue="COUNT")
	        {
               set ^CacheTempDHCEPRRptGroupResult($J,ALastResultItemKey,AResultItemSeq) = OldAggItemValue + 1
  	        }
	         Elseif (GroupValue="MAX")
	         {	if ((ACodeType="S"))
 	           { if (AggregateItemValue>=OldAggItemValue)
 	             {set ^CacheTempDHCEPRRptGroupResult($J,ALastResultItemKey,AResultItemSeq) = AggregateItemValue }
 	              elseif (AggregateItemValue<OldAggItemValue)
 	              { set ^CacheTempDHCEPRRptGroupResult($J,ALastResultItemKey,AResultItemSeq) = OldAggItemValue }
 	            }
 	         Elseif (ACodeType="N")
	         { 
               if (AggregateItemValue>=OldAggItemValue)
 	           {set ^CacheTempDHCEPRRptGroupResult($J,ALastResultItemKey,AResultItemSeq) = AggregateItemValue }
 	           elseif (AggregateItemValue<OldAggItemValue)
 	           { set ^CacheTempDHCEPRRptGroupResult($J,ALastResultItemKey,AResultItemSeq) = OldAggItemValue } }
              Elseif (ACodeType="Q")
              {if (AggregateItemValue>=OldAggItemValue)
 	          { set ^CacheTempDHCEPRRptGroupResult($J,ALastResultItemKey,AResultItemSeq) = AggregateItemValue }
 	            elseif (AggregateItemValue<OldAggItemValue)
 	            { set ^CacheTempDHCEPRRptGroupResult($J,ALastResultItemKey,AResultItemSeq) = OldAggItemValue }     }				  
         Elseif (ACodeType="D")
         { if (AggregateItemValue>=OldAggItemValue)
 	       {set ^CacheTempDHCEPRRptGroupResult($J,ALastResultItemKey,AResultItemSeq) = AggregateItemValue }
 	       elseif (AggregateItemValue<OldAggItemValue)
 	       { set ^CacheTempDHCEPRRptGroupResult($J,ALastResultItemKey,AResultItemSeq) = OldAggItemValue }  }     	  
        Elseif (ACodeType="I")
        { set ^CacheTempDHCEPRRptGroupResult($J,ALastResultItemKey,AResultItemSeq) = "*NULL"   }
          Elseif (ACodeType="M")
          { set ^CacheTempDHCEPRRptGroupResult($J,ALastResultItemKey,AResultItemSeq) = "*NULL"  }  
       }
	  Elseif (GroupValue="MIN")
	  {  if ((ACodeType="S"))
	     {if (AggregateItemValue<=OldAggItemValue)
 	      {set ^CacheTempDHCEPRRptGroupResult($J,ALastResultItemKey,AResultItemSeq) = AggregateItemValue }
 	      elseif (AggregateItemValue>OldAggItemValue)
 	      { set ^CacheTempDHCEPRRptGroupResult($J,ALastResultItemKey,AResultItemSeq) = OldAggItemValue }
 	      }
 	     Elseif (ACodeType="N")
	    { 
          if (AggregateItemValue<=OldAggItemValue)
 	      {set ^CacheTempDHCEPRRptGroupResult($J,ALastResultItemKey,AResultItemSeq) = AggregateItemValue }
 	       elseif (AggregateItemValue>OldAggItemValue)
 	       { set ^CacheTempDHCEPRRptGroupResult($J,ALastResultItemKey,AResultItemSeq) = OldAggItemValue } }
         Elseif (ACodeType="Q")
         {if (AggregateItemValue<=OldAggItemValue)
 	      {set ^CacheTempDHCEPRRptGroupResult($J,ALastResultItemKey,AResultItemSeq) = AggregateItemValue }
 	      elseif (AggregateItemValue>OldAggItemValue)
 	      { set ^CacheTempDHCEPRRptGroupResult($J,ALastResultItemKey,AResultItemSeq) = OldAggItemValue }     }				  
         Elseif (ACodeType="D")
         { if (AggregateItemValue<=OldAggItemValue)
 	       {set ^CacheTempDHCEPRRptGroupResult($J,ALastResultItemKey,AResultItemSeq) = AggregateItemValue }
 	       elseif (AggregateItemValue>OldAggItemValue)
 	       { set ^CacheTempDHCEPRRptGroupResult($J,ALastResultItemKey,AResultItemSeq) = OldAggItemValue }  }     	  
          Elseif (ACodeType="I")
          { set ^CacheTempDHCEPRRptGroupResult($J,ALastResultItemKey,AResultItemSeq) = "*NULL"   }
          Elseif (ACodeType="M")
          { set ^CacheTempDHCEPRRptGroupResult($J,ALastResultItemKey,AResultItemSeq) = "*NULL"  }   
	    }
       	}
        }
}

ClassMethod BuildGroupFilerResult()
{
  Set FilerKey= $O(^CacheTempDHCEPRRptGroupResult($J,""))
   While (FilerKey '="")
   {
	   
	   Set FilerKey= $O(^CacheTempDHCEPRRptGroupResult($J,FilerKey))
	}
}

ClassMethod BuildGroupResult()
{
	K ^CacheTempDHCEPRRptLastResult($J)
	
	///by houjian test
	MERGE ^CacheTempDHCEPRRptLastResult($J) = ^CacheTempDHCEPRRptEachResult($J)
	quit
	///end of houjian test
	
	//first  select the Group type = Group 
	//next operator the Func
	// last filter result contion like having
	Set GroupFlag = "False"
	Set AggregateFlag = "False"
	set HavingFlag = "False"
	Set Groupsequence =""
	set ResultColItemKey = $ORDER(^CacheTempDHCEPRRptColumn($J,""))	 	
	//set ResultColItemCount= $G(^CacheTempDHCEPRRptColumn($J,"ResultColCount"))	   
	
	set ResultColItemCount= $G(^CacheTempDHCEPRRptSysResult($J,"ResultColCount"))	   
	
    while (ResultColItemKey'="")
    {
	 if $D(^CacheTempDHCEPRRptColumn($J,ResultColItemKey,"GROUP"))
	 { set GroupValue= $G(^CacheTempDHCEPRRptColumn($J,ResultColItemKey,"GROUP"))	 
	   if (GroupValue="GROUPBY")
	   { set GroupFlag="True" 
	     Set Groupsequence = ResultColItemKey  }
	   Elseif (GroupValue="SUM")||(GroupValue="AVG")||(GroupValue="COUNT")||(GroupValue="MAX")||(GroupValue="MIN")
	   { Set AggregateFlag= "True"  } }
	 if $D(^CacheTempDHCEPRRptColumn($J,ResultColItemKey,"CONDITION"))
	 { set CONDITIONValue= $G(^CacheTempDHCEPRRptColumn($J,ResultColItemKey,"CONDITION"))	 	 
	   if (CONDITIONValue'="")
	   { set HavingFlag= "True"  }
		 } 	 
	 set ResultColItemKey = $ORDER(^CacheTempDHCEPRRptColumn($J,ResultColItemKey))	 	   
	}
	
	if ((GroupFlag="False")&&(AggregateFlag="False"))
	{
	   MERGE ^CacheTempDHCEPRRptLastResult($J) = ^CacheTempDHCEPRRptEachResult($J)	
		}
     if ((GroupFlag="True"))
     {
	   if (AggregateFlag="False")
	   {
    	// this case can't be Exist
    	set EachResultKey = $ORDER(^CacheTempDHCEPRRptEachResult($J))   
		While (EachResultKey'="")
		{
		 //set ^CacheTempDHCEPRRptGroupResult($J,EachResultKey)=EachResultKey 	
		 Set GroupEqualFlag = "False"
   	     //set ResultColItemKey = ^CacheTempDHCEPRRptAdmID($J,"EPRFilter","")
   	     set EachGroupItemValue= $G(^CacheTempDHCEPRRptEachResult($J,EachResultKey,Groupsequence)) 	 	
   	     
   	     Set LastResultItemKey = $ORDER(^CacheTempDHCEPRRptGroupResult($J,""))
   	     While (LastResultItemKey'="")
   	     {
	   	   if $D(^CacheTempDHCEPRRptGroupResult($J,LastResultItemKey,Groupsequence))
	   	   {
		   	 set LastGroupItemValue= $G(^CacheTempDHCEPRRptGroupResult($J,LastResultItemKey,Groupsequence))  
		   	 if (EachGroupItemValue = LastGroupItemValue)
		   	 { Set GroupEqualFlag = "True"  }
		   	 }
	   	    if (GroupEqualFlag = "True")
	   	    {set LastResultItemKey="" }
	   	    else 
	   	    { Set LastResultItemKey =  ^CacheTempDHCEPRRptGroupResult($J,LastResultItemKey) } 
	   	    }
	   	     }
   	     if (GroupEqualFlag '="True")
   	     {
	   	   set ^CacheTempDHCEPRRptGroupResult($J,EachResultKey)= EachResultKey
	   	   // set ResultColItemCount= $G(^CacheTempDHCEPRRptColumn($J,"ResultColCount"))	   
	   	   set ResultColItemCount= $G(^CacheTempDHCEPRRptSysResult($J,"ResultColCount"))	   
	   	   for K=1:1:ResultColItemCount
	   	   {
		   	 set ^CacheTempDHCEPRRptGroupResult($J,EachResultKey,K)  =$G(^CacheTempDHCEPRRptEachResult($J,EachResultKey,K))
		   	   }
	   	     }
	     set EachResultKey = ^CacheTempDHCEPRRptEachResult($J,EachResultKey)   		
	   }
	   elseif (AggregateFlag="True")
	   {
    	 set EachResultKey = $O(^CacheTempDHCEPRRptEachResult($J,""))   
		 set LastResultCount= 0
		 While (EachResultKey'="")
		 {
		  Set GroupEqualFlag = "False"
   	      set EachGroupItemValue= ^CacheTempDHCEPRRptEachResult($J,EachResultKey,Groupsequence) 	 	
   	      Set LastResultItemKey = $O(^CacheTempDHCEPRRptGroupResult($J,""))
   	      While (LastResultItemKey'="")
   	      {
	   	   if $D(^CacheTempDHCEPRRptGroupResult($J,LastResultItemKey,Groupsequence))
	   	   {
		   	 set LastGroupItemValue= $G(^CacheTempDHCEPRRptGroupResult($J,LastResultItemKey,Groupsequence))  
		   	 if (EachGroupItemValue = LastGroupItemValue)
		   	 { Set GroupEqualFlag = "True" 
		   	 //Aggregate each item to  global
		   	   set ResultColItemKey = $O(^CacheTempDHCEPRRptColumn($J,""))
		   	   Set ResultItemSeq = 0
		   	   while (ResultColItemKey'="")
		   	   {
			   	Set ResultItemSeq = ResultItemSeq + 1
                Set DataConType= $G(^CacheTempDHCEPRRptColumn($J,ResultColItemKey,"Type"))
                D ##Class(EPRservice.BODataQueryService).BuildHasRowAggregateResult(ResultItemSeq,EachResultKey,LastResultItemKey,DataConType)
				set ResultColItemKey= $ORDER(^CacheTempDHCEPRRptColumn($J,ResultColItemKey)) 	   	   
			    }
		   	  }
		   	 }
	   	      if (GroupEqualFlag = "True")
	   	      {set LastResultItemKey="" }
	   	      else 
	   	      { Set LastResultItemKey =  $ORDER(^CacheTempDHCEPRRptGroupResult($J,LastResultItemKey) )
	   	      } 
	   	    }
	   	    if (GroupEqualFlag '="True")
   	         { 
   	           s LastResultCount= LastResultCount+1
	   	       set ^CacheTempDHCEPRRptGroupResult($J,LastResultCount)= EachResultKey
	   	       //set ResultColItemCount= $G(^CacheTempDHCEPRRptColumn($J,"ResultColCount"))	   
	   	       set ResultColItemCount= $G(^CacheTempDHCEPRRptSysResult($J,"ResultColCount"))	   
	   	       //^CacheTempEPRRptSysData
	   	       for K=1:1:ResultColItemCount
	   	       { // B "S"
            	 Set DataConType= $G(^CacheTempDHCEPRRptColumn($J,K,"Type"))
	             D ##Class(EPRservice.BODataQueryService).BuildNewRowAggregateResult(K,DataConType,LastResultCount,EachResultKey)
	   	       }
		       //set ^CacheTempDHCEPRRptGroupResult($J,EachResultKey,"AVGCount")  = 1
	   	       }
	   	       set EachResultKey = $ORDER(^CacheTempDHCEPRRptEachResult($J,EachResultKey))
	   	     }
         // end AggregateFlag = False
         // Filer  Having Data 
         
         
         
         }
         }
        elseif ((GroupFlag="False")&&(AggregateFlag="True"))
        {
    	 set EachResultKey = $ORDER(^CacheTempDHCEPRRptEachResult($J,""))   
		 While (EachResultKey'="")
		 {
		 	   set ResultColItemKey = $ORDER(^CacheTempDHCEPRRptColumn($J,""))
		   	   Set ResultItemSeq = 0
		   	   while (ResultColItemKey'="")
		   	   {
			   	Set ResultItemSeq = ResultItemSeq + 1
			   	
			   	Set DataConType= $G(^CacheTempDHCEPRRptColumn($J,ResultColItemKey,"Type"))
	            if (DataConType="Episode")
	            { 
                  //get Episode Item Value
                  s EpisodeFTYPE =""
	              S EpisodeFTYPE = $G(^CacheTempDHCEPRRptColumn($J,K,"FTYPE"))
				  s GroupValue=""
				  set GroupValue= $G(^CacheTempDHCEPRRptColumn($J,K,"GROUP"))

			   	  set AVGCountNum = $G(^CacheTempDHCEPRRptLastResult($J,1,"AVGCOUNT")) 
                  
                  if (EpisodeFTYPE="String")
                  {
				    if ((GroupValue="SUM")||(GroupValue="AVG"))
				    { 
				     set ^CacheTempDHCEPRRptLastResult($J,1,ResultItemSeq)  ="*NULL" 	
				    }
				     Elseif (GroupValue="COUNT")
				     {
					   set ^CacheTempDHCEPRRptLastResult($J,1,ResultItemSeq)  = OldAggItemValue + 1
					     }
				     Elseif (GroupValue="MAX")
				     {
					  if (AggregateItemValue>=OldAggItemValue)
				  	  {set ^CacheTempDHCEPRRptLastResult($J,1,ResultItemSeq) = AggregateItemValue }
				  	  elseif (AggregateItemValue<OldAggItemValue)
				  	  { set ^CacheTempDHCEPRRptLastResult($J,1,ResultItemSeq) = OldAggItemValue }

					     }
				     Elseif (GroupValue="MIN")
				     {
					  if (AggregateItemValue<=OldAggItemValue)
				  	  {set ^CacheTempDHCEPRRptLastResult($J,1,ResultItemSeq) = AggregateItemValue }
				  	  elseif (AggregateItemValue>OldAggItemValue)
				  	  { set ^CacheTempDHCEPRRptLastResult($J,1,ResultItemSeq) = OldAggItemValue }
					     }
	                  }
                  Elseif (EpisodeFTYPE="DateTime")
                  {
				  if (GroupValue="SUM")
				  { set ^CacheTempDHCEPRRptLastResult($J,1,ResultItemSeq)  =OldAggItemValue + AggregateItemValue
				  }
				  Elseif (GroupValue="AVG")
				  {
					Set NewAVGItemValue = (OldAggItemValue*AVGCountNum + AggregateItemValue)/(AVGCountNum +1)
			   	     set ^CacheTempDHCEPRRptLastResult($J,1,ResultItemSeq) = NewAVGItemValue  
			   	     }
				  Elseif (GroupValue="COUNT")
				  { set ^CacheTempDHCEPRRptLastResult($J,1,ResultItemSeq)=OldAggItemValue +1
					  }
				  Elseif (GroupValue="MAX")
				  {
					 if (AggregateItemValue>=OldAggItemValue)
				  	  {set ^CacheTempDHCEPRRptLastResult($J,1,ResultItemSeq) = AggregateItemValue }
				  	  elseif (AggregateItemValue<OldAggItemValue)
				  	  { set ^CacheTempDHCEPRRptLastResult($J,1,ResultItemSeq) = OldAggItemValue }
                   }
				   Elseif (GroupValue="MIN")
				   {
					  if (AggregateItemValue<=OldAggItemValue)
				  	  {set ^CacheTempDHCEPRRptLastResult($J,1,ResultItemSeq) = AggregateItemValue }
				  	  elseif (AggregateItemValue>OldAggItemValue)
				  	  { set ^CacheTempDHCEPRRptLastResult($J,1,ResultItemSeq) = OldAggItemValue }
					}	  
	              }
                  Elseif (EpisodeFTYPE="Numeric")
                  {
				  if (GroupValue="SUM")
				  { set ^CacheTempDHCEPRRptLastResult($J,1,ResultItemSeq)  =OldAggItemValue + AggregateItemValue
				  }
				  Elseif (GroupValue="AVG")
				  {
					Set NewAVGItemValue = (OldAggItemValue*AVGCountNum + AggregateItemValue)/(AVGCountNum +1)
			   	     set ^CacheTempDHCEPRRptLastResult($J,1,ResultItemSeq) = NewAVGItemValue  
			   	     }
				  Elseif (GroupValue="COUNT")
				  {
					  set ^CacheTempDHCEPRRptLastResult($J,1,ResultItemSeq)= OldAggItemValue + 1
					  }
				  Elseif (GroupValue="MAX")
				  {
					if (AggregateItemValue>=OldAggItemValue)
				  	  {set ^CacheTempDHCEPRRptLastResult($J,1,ResultItemSeq) = AggregateItemValue }
				  	  elseif (AggregateItemValue<OldAggItemValue)
				  	  { set ^CacheTempDHCEPRRptLastResult($J,1,ResultItemSeq) = OldAggItemValue }
					  }
				   Elseif (GroupValue="MIN")
				   { 
				     if (AggregateItemValue<=OldAggItemValue)
				  	  {set ^CacheTempDHCEPRRptLastResult($J,1,ResultItemSeq) = AggregateItemValue }
				  	  elseif (AggregateItemValue>OldAggItemValue)
				  	  { set ^CacheTempDHCEPRRptLastResult($J,1,ResultItemSeq) = OldAggItemValue }
                     }	  
	             }
	            }
	            Elseif (DataConType="Simple")
			   	{
			   	if $D(^CacheTempDHCEPRRptColumn($J,ResultColItemKey,"GROUP"))
			   	{ set GroupValue= $G(^CacheTempDHCEPRRptColumn($J,ResultColItemKey,"GROUP"))
			   	  set ACodeType = $EXTRACT($G(^CacheTempDHCEPRRptColumn($J,AResultColItemKey,"SCODE")),1)	 
			   	  Set AggregateItemValue = $G(^CacheTempDHCEPRRptEachResult($J,EachResultKey,ResultItemSeq))
			   	  set OldAggItemValue = $G(^CacheTempDHCEPRRptLastResult($J,1,ResultItemSeq)) 
			   	  set AVGCountNum = $G(^CacheTempDHCEPRRptLastResult($J,1,"AVGCOUNT")) 
			   	  if (GroupValue="SUM")
			   	  {
				  	//if (ACodeType="S")||(ACodeType="N")||(ACodeType="O")||(ACodeType="M")||(ACodeType="Q")||(ACodeType="I")
				  	if ((ACodeType="S")||(ACodeType="O")||(ACodeType="M"))
				  	{ set ^CacheTempDHCEPRRptLastResult($J,1,ResultItemSeq) = "*NULL" 	 	}
				  	Elseif (ACodeType="N")
			   	    { set ^CacheTempDHCEPRRptLastResult($J,1,ResultItemSeq) = OldAggItemValue + AggregateItemValue  }
                    Elseif (ACodeType="Q")
                    { set ^CacheTempDHCEPRRptLastResult($J,1,ResultItemSeq) = OldAggItemValue + AggregateItemValue     }				  
	                Elseif (ACodeType="D")
	                { set ^CacheTempDHCEPRRptLastResult($J,1,ResultItemSeq) = "*NULL"  }     	  
		            Elseif (ACodeType="I")
		            { set ^CacheTempDHCEPRRptLastResult($J,1,ResultItemSeq) = "*NULL"   }
			         Elseif (ACodeType="M")
			        {set ^CacheTempDHCEPRRptLastResult($J,1,ResultItemSeq) = "*NULL"  }   
                  }
			   	  Elseif (GroupValue="AVG")
			   	  {
				  	if ((ACodeType="S")||(ACodeType="O")||(ACodeType="M"))
				  	{ set ^CacheTempDHCEPRRptLastResult($J,1,ResultItemSeq) = "*NULL" 	 	}
				  	Elseif (ACodeType="N")
			   	    { 
			   	     Set NewAVGItemValue = (OldAggItemValue*AVGCountNum + AggregateItemValue)/(AVGCountNum +1)
			   	     set ^CacheTempDHCEPRRptLastResult($J,1,ResultItemSeq) = NewAVGItemValue  }
                    Elseif (ACodeType="Q")
                    { Set NewAVGItemValue = (OldAggItemValue*AVGCountNum + AggregateItemValue)/(AVGCountNum +1)
			   	     set ^CacheTempDHCEPRRptLastResult($J,1,ResultItemSeq) = NewAVGItemValue     }				  
	                Elseif (ACodeType="D")
	                { set ^CacheTempDHCEPRRptLastResult($J,1,ResultItemSeq) = "*NULL"  }     	  
		            Elseif (ACodeType="I")
		            { set ^CacheTempDHCEPRRptLastResult($J,1,ResultItemSeq) = "*NULL"   }
			         Elseif (ACodeType="M")
			        { set ^CacheTempDHCEPRRptLastResult($J,1,ResultItemSeq) = "*NULL"  }   
				   	  }
			   	  Elseif (GroupValue="COUNT")
			   	  {
                    set ^CacheTempDHCEPRRptLastResult($J,1,ResultItemSeq) = OldAggItemValue + 1
				   	  }
			   	  Elseif (GroupValue="MAX")
			   	  {	if ((ACodeType="S"))
				  	{ if (AggregateItemValue>=OldAggItemValue)
				  	  {set ^CacheTempDHCEPRRptLastResult($J,1,ResultItemSeq) = AggregateItemValue }
				  	  elseif (AggregateItemValue<OldAggItemValue)
				  	  { set ^CacheTempDHCEPRRptLastResult($J,1,ResultItemSeq) = OldAggItemValue }}
				  	Elseif (ACodeType="N")
			   	    { 
					if (AggregateItemValue>=OldAggItemValue)
				  	  {set ^CacheTempDHCEPRRptLastResult($J,1,ResultItemSeq) = AggregateItemValue }
				  	  elseif (AggregateItemValue<OldAggItemValue)
				  	  { set ^CacheTempDHCEPRRptLastResult($J,1,ResultItemSeq) = OldAggItemValue } }
                    Elseif (ACodeType="Q")
                    {if (AggregateItemValue>=OldAggItemValue)
				  	  {set ^CacheTempDHCEPRRptLastResult($J,1,ResultItemSeq) = AggregateItemValue }
				  	  elseif (AggregateItemValue<OldAggItemValue)
				  	  { set ^CacheTempDHCEPRRptLastResult($J,1,ResultItemSeq) = OldAggItemValue }     }				  
	                Elseif (ACodeType="D")
	                { if (AggregateItemValue>=OldAggItemValue)
				  	  {set ^CacheTempDHCEPRRptLastResult($J,1,ResultItemSeq) = AggregateItemValue }
				  	  elseif (AggregateItemValue<OldAggItemValue)
				  	  { set ^CacheTempDHCEPRRptLastResult($J,1,ResultItemSeq) = OldAggItemValue }  }     	  
		            Elseif (ACodeType="I")
		            { set ^CacheTempDHCEPRRptLastResult($J,1,ResultItemSeq) = "*NULL"   }
			         Elseif (ACodeType="M")
			        { set ^CacheTempDHCEPRRptLastResult($J,1,ResultItemSeq) = "*NULL"  }   
			        }
			   	  Elseif (GroupValue="MIN")
			   	  { if (AggregateItemValue<=OldAggItemValue)
				  	  {set ^CacheTempDHCEPRRptLastResult($J,1,ResultItemSeq) = AggregateItemValue }
				  	  elseif (AggregateItemValue>OldAggItemValue)
				  	  { set ^CacheTempDHCEPRRptLastResult($J,1,ResultItemSeq) = OldAggItemValue }}
				  	Elseif (ACodeType="N")
			   	    { 
					if (AggregateItemValue<=OldAggItemValue)
				  	  {set ^CacheTempDHCEPRRptLastResult($J,1,ResultItemSeq) = AggregateItemValue }
				  	  elseif (AggregateItemValue>OldAggItemValue)
				  	  { set ^CacheTempDHCEPRRptLastResult($J,1,ResultItemSeq) = OldAggItemValue } }
                    Elseif (ACodeType="Q")
                    {if (AggregateItemValue<=OldAggItemValue)
				  	  {set ^CacheTempDHCEPRRptLastResult($J,1,ResultItemSeq) = AggregateItemValue }
				  	  elseif (AggregateItemValue>OldAggItemValue)
				  	  { set ^CacheTempDHCEPRRptLastResult($J,1,ResultItemSeq) = OldAggItemValue }     }				  
	                Elseif (ACodeType="D")
	                { if (AggregateItemValue<=OldAggItemValue)
				  	  {set ^CacheTempDHCEPRRptLastResult($J,1,ResultItemSeq) = AggregateItemValue }
				  	  elseif (AggregateItemValue>OldAggItemValue)
				  	  { set ^CacheTempDHCEPRRptLastResult($J,1,ResultItemSeq) = OldAggItemValue }  }     	  
		            Elseif (ACodeType="I")
		            { set ^CacheTempDHCEPRRptLastResult($J,1,ResultItemSeq) = "*NULL"   }
			         Elseif (ACodeType="M")
			        { set ^CacheTempDHCEPRRptLastResult($J,1,ResultItemSeq) = "*NULL"  }   
                	}
				   	}
			   	
				  set ResultColItemKey= $ORDER(^CacheTempDHCEPRRptColumn($J,ResultColItemKey)) 	   	   
			   	   }
			set EachResultKey = ^CacheTempDHCEPRRptEachResult($J,EachResultKey) 
			 }	     
	     }
}

/// 解析查询的系统日期时间部分
ClassMethod ParseQuerySysInfo(ADateStr As %String)
{
  K ^CacheTempDHCEPRRptSystem($J)	
  s ^CacheTempDHCEPRRptSystem($J)=	ADateStr
}

/// 获取查询结果集的总行数
ClassMethod GetResultCount() As %String
{
  s ReSultCount= 0
  s ReSultCount= $G(^CacheTempDHCEPRRptSysResult($J,"ResultCount")) 	
  Q ReSultCount
}

/// 获取系统日期时间信息
ClassMethod GetSysInfo()
{
 S ASystemDateStr= $G(^CacheTempDHCEPRRptSystem($J))
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

/// 判断 "数值型" 条件表达式运算的结果
/// 数值型运算支持的运算符：=, > , <, <=, >=, <>
ClassMethod CheckConExpressionOfNumeric(itemValue As %String, operator As %String, conditionValue As %String) As %String
{
	///b "s"
	q:($d(itemValue)=0)||($d(operator)=0)||(operator="")||($d(conditionValue)=0) "False"
	s returnValue="False"
	
	if (operator="=")&&(itemValue=conditionValue)
	{	s returnValue="True"}
	elseif (operator=">")&&(itemValue>conditionValue)
	{	s returnValue="True"}
	elseif (operator="<")&&(itemValue<conditionValue)
	{	s returnValue="True"}
	elseif (operator="<=")&&(itemValue'>conditionValue)
	{	s returnValue="True"}
	elseif (operator=">=")&&(itemValue'<conditionValue)
	{	s returnValue="True"}
	elseif (operator="<>")&&(itemValue'=conditionValue)
	{	s returnValue="True"}
	
	q returnValue
}

/// 判断 "日期型" 运算的结果
/// 日期型运算支持的运算符：=, > , <, <=, >=, <>  (同数值型)
ClassMethod CheckConExpressionOfDateTime(itemValue As %String, operator As %String, conditionValue As %String) As %String
{
	q:(($d(itemValue)=0)||($d(operator)=0)||(operator="")||($d(conditionValue)=0)) "False"
	s returnValue="False"
	
	if (operator="=")&&(itemValue=conditionValue)
	{	s returnValue="True"}
	elseif (operator=">")&&(itemValue>conditionValue)
	{	s returnValue="True"}
	elseif (operator="<")&&(itemValue<conditionValue)
	{	s returnValue="True"}
	elseif (operator="<=")&&(itemValue'>conditionValue)
	{	s returnValue="True"}
	elseif (operator=">=")&&(itemValue'<conditionValue)
	{	s returnValue="True"}
	elseif (operator="<>")&&(itemValue'=conditionValue)
	{	s returnValue="True"}
	
	q returnValue
}

/// 判断 "字符型" 运算的结果
/// 字符型运算支持的运算符：=, <>, like
ClassMethod CheckConExpressionOfString(itemValue As %String, operator As %String, conditionValue As %String) As %String
{
	///debug
	///b "s"
	q:($d(itemValue)=0)||($d(operator)=0)||(operator="")||($d(conditionValue)=0) "False"
	s returnValue="False"
	
	if (operator="=")&&(itemValue=conditionValue)
	{	s returnValue="True"}
	elseif (operator="<>")&&(itemValue'=conditionValue)
	{	s returnValue="True"}
	elseif (operator="like")&&(itemValue[conditionValue)
	{	s returnValue="True"}
	
	q returnValue
}

/// 判断 "代码型" 运算的结果
/// 代码型运算支持的运算符：=, <>
ClassMethod CheckConExpressionOfCode(itemValue As %String, operator As %String, conditionValue As %String) As %String
{
	///b "s"
	q:($d(itemValue)=0)||($d(operator)=0)||(operator="")||($d(conditionValue)=0) "False"
	s returnValue="False"
	
	if (operator="=")&&(itemValue=conditionValue)
	{	s returnValue="True"}
	elseif (operator="<>")&&(itemValue'=conditionValue)
	{	s returnValue="True"}
		
	q returnValue
}

/// 测试代码
/// w ##class(EPRservice.BODataQueryService).TestRptDataCount()
ClassMethod TestRptDataCount()
{
 //s aaa="$QueryCondition#{#Episode:#TYPE:Episode#FTYPE:DateTime#FNAME:AdmDateTime#CONDITION:>#VALUE:2005-1-1#EPR: AND #TYPE:TextDesc#TID:3#TVER:#ECODE:E0001#CONDITION:like#VALUE:发热#Glossary: AND #TYPE:Glossary#GID:16#CONDITION:like#VALUE:怀柔}$ResultColumn{#TYPE:Episode#FTYPE:DateTime#FNAME:AdmDateTime,#TYPE:TextDesc#TID:3#TVER:#ECODE:E0001,#TYPE:Glossary#GID:16,#TYPE:TextDesc#TID:3#TVER:#ECODE:E0001}$SystemData{DATE,TIME}"
 //s aaa="$QueryCondition#{#Episode:#TYPE:Episode#FTYPE:DateTime#FNAME:AdmDateTime#CONDITION:>#VALUE:2005-1-1 AND #TYPE:Episode#FTYPE:DateTime#FNAME:DisDateTime#CONDITION:=#VALUE:#EPR: AND #TYPE:TextDesc#TID:3#TVER:#ECODE:E0001#CONDITION:like#VALUE:发热#Glossary: AND #TYPE:Glossary#GID:16#CONDITION:like#VALUE:怀柔}$ResultColumn{#TYPE:Episode#FTYPE:DateTime#FNAME:AdmDateTime,#TYPE:TextDesc#TID:3#TVER:#ECODE:E0001,#TYPE:Glossary#GID:16,#TYPE:TextDesc#TID:3#TVER:#ECODE:E0001}$SystemData{DATE,TIME}"
 s aaa="$QueryCondition#{#Episode:#TYPE:Episode#FTYPE:DateTime#FNAME:AdmDateTime#CONDITION:>#VALUE:2005-1-1#EPR:#Glossary: AND #TYPE:Glossary#GID:1#CONDITION:like#VALUE:体检发现 OR #TYPE:Glossary#GID:1#CONDITION:like#VALUE:发热}$ResultColumn{#TYPE:Episode#FTYPE:String#FNAME:AdmDept,#TYPE:Episode#FTYPE:DateTime#FNAME:AdmDateTime,#TYPE:Glossary#GID:1}$SystemData{DATE,TIME}"
 s bbb=##class(EPRservice.BODataQueryService).GetRptDataCount(aaa) 	
 w bbb
}

/// 测试代码
/// w ##class(EPRservice.BODataQueryService).TestGetRrtData()
ClassMethod TestGetRrtData()
{
  s bbb= ##class(EPRservice.BODataQueryService).GetRrtData("CacheTempEPRRptLastResult(3520)","1","1") 		
  w bbb
}

}
