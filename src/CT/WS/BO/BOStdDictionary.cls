/// CT.WS.BO.BOStdDictionary
/// 描述:自定义字典BO层
/// 编写者:yejian
/// 编写日期:2013-4-23
Class CT.WS.BO.BOStdDictionary Extends %SOAP.WebService [ ClassType = "", ProcedureBlock ]
{

/// TODO: change this to actual network address.
/// URL for invoking the WebService.
/// Parameter LOCATION = "http://localhost/trakcarelive/trak/web";
/// TODO: change this to actual SOAP namespace.
/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/metaservice";

/// Name of the WebService.
Parameter SERVICENAME = "StdDictionaryService";

ClassMethod GetStdDicitonaryByID(AID As %String) As CT.WS.entity.EStdDictionary [ WebMethod ]
{
	s ret = ""
	q:(AID = "") ret
	
	s objStdDictionary = ##Class(CT.WS.StdDictionary).%OpenId(AID)
	q:(objStdDictionary = "") ret
	
	s Result = ##Class(CT.WS.entity.EStdDictionary).%New()
	s Result.ID = AID
	s Result.Description = objStdDictionary.Description
	s Result.DicAliasCol = objStdDictionary.DicAliasCol
	s Result.DicCodeCol = objStdDictionary.DicCodeCol
	s Result.DicDescCol = objStdDictionary.DicDescCol
	s Result.Name = objStdDictionary.Name
	s Result.TableName = objStdDictionary.TableName
	s Result.IsRuleType = objStdDictionary.IsRuleType
	s Result.RuleTypeTag = objStdDictionary.RuleTypeTag
	s Result.Condition = objStdDictionary.Condition
	s Result.ConditionCode = objStdDictionary.ConditionCode
	s Result.IsDiagnosRuleType = objStdDictionary.IsDiagnosRuleType
	
	q Result
}

ClassMethod CreateStdDictionary(AEStdDictionary As CT.WS.entity.EStdDictionary) As %String [ WebMethod ]
{
	set objStdDictionary = ##class(CT.WS.StdDictionary).%New()
 Quit:(objStdDictionary ="") "" 
 set objStdDictionary.Code = AEStdDictionary.Code
 S UniqueFlag=##class(CT.WS.StdDictionary).CheckCodeUnique(AEStdDictionary.Code)
 if '(UniqueFlag=0)
 { 
 Quit "-1"
 } 
 set objStdDictionary.Description = AEStdDictionary.Description
 set objStdDictionary.DicAliasCol = AEStdDictionary.DicAliasCol
 set objStdDictionary.DicCodeCol = AEStdDictionary.DicCodeCol
 set objStdDictionary.DicDescCol = AEStdDictionary.DicDescCol
 set objStdDictionary.Name = AEStdDictionary.Name
 set objStdDictionary.TableName = AEStdDictionary.TableName
 set objStdDictionary.Condition = AEStdDictionary.Condition
 set objStdDictionary.ConditionCode = AEStdDictionary.ConditionCode
 set objStdDictionary.SystemCode = AEStdDictionary.SystemCode
 set $zt = "SaveError"
 TStart
 if '(objStdDictionary.%Save()){Quit "0" }
 set re = ..SaveSequence(objStdDictionary.%Id())
 if (re = "1")
 {
	 TCOMMIT
	 Quit objStdDictionary.%Id()
 }
 else
 {
	 Trollback
	 Quit "0"
 }
SaveError
 Quit "0"
}

/// Desc: 保存顺序号
/// Creator: Candyxu 20120607
ClassMethod SaveSequence(AID As %String)
{
	set obj = ##class(CT.WS.StdDictionary).%OpenId(AID)
	set obj.Sequence = AID 
	if '(obj.%Save())
	{
		Quit "0"
	}
	else
	{
		Quit "1"
	}
}

ClassMethod DeleteStdDictionary(AID As %String) As %Boolean [ WebMethod ]
{
	set objStdDictionary = ##class(CT.WS.StdDictionary).%OpenId(AID)
	Quit objStdDictionary.%DeleteId(AID)
}

ClassMethod GetStdDicList(ADicCode As %String, AAias As %String, Acode As %String, ADesc As %String, APageNum As %Integer, ARowCount As %Integer) As %XML.DataSet [ WebMethod ]
{
 s ^AAStd("Code") ="ADicCode="_ADicCode_"@@"_"AAias="_AAias_"@@"_"Acode="_Acode_"@@"_"ADesc="_ADesc_"@@"_"APageNum"_APageNum_"@@"_"ARowCount"_ARowCount_"@@"
 ;b "s"
 if (ADicCode=$C(0))
 {
	 s ADicCode= ""
 }

 if (AAias=$C(0))
 {
 s AAias =""
 }

 if (Acode=$C(0))
 {
 S Acode =""
 }
 if (ADesc=$C(0))
 {
	 s ADesc= ""
	 }
 if (APageNum=$C(0))
 { s APageNum = 0
 Quit ""
 }

 if (ARowCount=$C(0))
 { s ARowCount = 0
 Quit ""
 } 
 //b "S"

 Set Result = ##class(EPRservice.dataset.EStdDicListDataset).%New()
 Do Result.SetArgs(ADicCode,AAias,Acode,ADesc,APageNum,ARowCount)
 Quit Result
}

/// Desc:	标准字典单元查询
/// Input:	ADicCode 字典表代码；AItem 查询条件；APageNum 要取的页码；ARowCount 每页的行数；CountFlag ？？；AResultCount 结果总页数；SessionId 与这次字典查询对应的ID
/// Output:	CT.WS.dataset.EStdDicOrListDataset			
ClassMethod GetStdDicOrList(ADicCode As %String, AItem As %String, APageNum As %Integer, ARowCount As %Integer, CountFlag As %String, ByRef AResultCount As %String, ByRef SessionId As %String, AConditionCode As %String = "", ACondition As %String = "") As CT.WS.dataset.EStdDicOrListDataset [ WebMethod ]
{
	//deubg
	//k ^DHCEPRDebug("CT.WS.BO.BOStdDictionary.GetStdDicOrList")
	//s ^DHCEPRDebug("CT.WS.BO.BOStdDictionary.GetStdDicOrList","para") ="ADicCode="_ADicCode_"^"_"AItem="_AItem_"^"_"APageNum="_APageNum_"^"_"ARowCount="_ARowCount_"^"_"CountFlag="_CountFlag_"^"_"AResultCount="_AResultCount_"^"_"SessionId="_SessionId_"^"_"ConditionCode="_AConditionCode_"^"_"Condition="_ACondition
    //s ^DHCEPRDebug("CT.WS.BO.BOStdDictionary.GetStdDicOrList","111") = $ZT($p($H,",",2),3)_"^"_"OK"
    

    //检查参数有效性
 	if (ADicCode=$C(0)) 
 	{ 
 		s ADicCode= ""
   		Quit ""
 	}
 	if (AItem=$C(0))
 	{ 	s AItem= ""}
 	if (APageNum=$C(0))
 	{ 
 		s APageNum = 0
 		Quit ""
 	}
 	if (ARowCount=$C(0))
 	{ 
 		s ARowCount = 0
 		Quit ""
 	} 
 	
 	if (AResultCount=0)				//字典单元点击查询按钮，生成查询结果集存储在临时global中，并取相应页码的结果
 	{ 
   		S ASessionId=$I(^CacheTemp)
   		s SessionId=ASessionId
   		K ^CacheTempStdQuery(ASessionId)
  		//debug	 
    	//s ^DHCEPRDebug("CT.WS.BO.BOStdDictionary.GetStdDicOrList","222") = $ZT($p($H,",",2),3)_"^"_"OK"
   
   		//生成字典查询结果集，并存储在临时global中
   		s PageCount= ##class(CT.WS.StdDictionary).SelectNewStdDicPageCount(ADicCode,AItem,APageNum,ARowCount,ASessionId,AConditionCode,ACondition)
   		set AResultCount =PageCount
   		//debug
   		//s ^DHCEPRDebug("CT.WS.BO.BOStdDictionary.GetStdDicOrList","333") = $ZT($p($H,",",2),3)_"^"_"OK"
   		
   		//取相应页码的结果
  		if (PageCount'=0)
  		{ 
  			Set Result = ##class(CT.WS.dataset.EStdDicOrListDataset).%New()
    		D Result.SetArgs(ADicCode,AItem,APageNum,ARowCount,ASessionId)
  		}
  		else
  		{
			s SessionId=0
			s Result = "" 
		}
 	}
 	Elseif (AResultCount'=0)		//字典单元点击取前页或后页按钮，直接在临时global存储的结果集中取相应页码的结果
 	{
	 	//debug
	 	//s ^DHCEPRDebug("CT.WS.BO.BOStdDictionary.GetStdDicOrList","555") = $ZT($p($H,",",2),3)_"^"_"OK"
   		
   		S ^CacheTempStdQuery(SessionId)="True"
   		s ASessionId= SessionId
   		s TotalRowCount =  $G(^CacheTempStdQueryCount(ASessionId,"StdQueryDataCount"))	  
   		if TotalRowCount '= 0
   		{
    		Set Result = ##class(CT.WS.dataset.EStdDicOrListDataset).%New()
    		D Result.SetArgs(ADicCode,AItem,APageNum,ARowCount,SessionId)
 		}
 		Else
 		{
	  		s SessionId=0
	  		s Result=""	
	 	}
 	 
 	}
 
 	Quit Result
}

ClassMethod DeleteStdQueryTempGlobal(ASessionID As %String) [ WebMethod ]
{
	s sessionID = +ASessionID
	kill ^CacheTempStdQuery(sessionID)
}

ClassMethod GetStdDicPageCount(ADicCode As %String, AAias As %String, ACode As %String, ADesc As %String, ARowCount As %Integer) As %String [ WebMethod ]
{
 if (ADicCode=$C(0))
 {
	 s ADicCode= ""}

 if AAias=$C(0)
 {
	 s AAias =""
 }

 if (ACode=$C(0))
 {
	 S ACode =""
	 }
 if (ADesc=$C(0))
 {
	 s ADesc= ""
	 }
 if (ARowCount=$C(0))
 { s ARowCount = 0
 Quit ""
 }
 
 Set Result = ##class(CT.WS.StdDictionary).SELECTStdDicPageCount(ADicCode,AAias,ACode,ADesc,ARowCount)
 Quit Result
}

ClassMethod SelectALLStdDic() As CT.WS.dataset.EStdDicListDataset [ WebMethod ]
{
 Set result=##class(CT.WS.dataset.EStdDictionaryDataset).%New()
 Quit result
}

ClassMethod UpdateStdDictionary(AEStdDictionary As CT.WS.entity.EStdDictionary) As %String [ WebMethod ]
{
 set objStdDictionary = ##class(CT.WS.StdDictionary).%OpenId(AEStdDictionary.ID)
 Quit:(objStdDictionary ="") 0 
 //set objStdDictionary = ##class(CT.WS.StdDictionary).%OpenId(AEKBTree.ID)
 //B "S"
 set objStdDictionary.Code = AEStdDictionary.Code

 S UniqueFlag=##class(CT.WS.StdDictionary).CheckUpdateCodeUnique(AEStdDictionary.ID,AEStdDictionary.Code)

 if '(UniqueFlag=0)
 { 
 Quit "-1"
 } 

 set objStdDictionary.Description = AEStdDictionary.Description
 set objStdDictionary.DicAliasCol = AEStdDictionary.DicAliasCol
 set objStdDictionary.DicCodeCol = AEStdDictionary.DicCodeCol
 set objStdDictionary.DicDescCol = AEStdDictionary.DicDescCol
 set objStdDictionary.Name = AEStdDictionary.Name
 set objStdDictionary.TableName = AEStdDictionary.TableName
 set objStdDictionary.Condition = AEStdDictionary.Condition
 set objStdDictionary.ConditionCode = AEStdDictionary.ConditionCode
 set objStdDictionary.SystemCode= AEStdDictionary.SystemCode
 if '(objStdDictionary.%Save())
 {Quit "0"}
 Quit "1"
}

ClassMethod Testordlst()
{
  D ##class(CT.WS.BO.BOStdDictionary).GetStdDicOrList("2","jxw","2","12","True",8,2581)
}

ClassMethod icdtest(argTarget As %String) As %String [ WebMethod ]
{
	s hasGB=0
  S ComLength = $L(argTarget)
  for I=1:1:ComLength {
	S GBStr= $E(argTarget,I)  
	if (($A(GBStr)>=19968)&& ($A(GBStr)<=40869))||(($A(GBStr)>=63744)&& ($A(GBStr)<=64045))
	{s hasGB=1}
	q:(hasGB=1)
	}
	
	s rowid="",ttt=""
	for {
		s rowid=$o(^MRC("ID",rowid))
		q:(rowid="")
		s code=$p($g(^MRC("ID",rowid)),"^",4)
		s desc=$p($g(^MRC("ID",rowid)),"^",2)
		s aliasRowid=0,alias=""
		for {
			s aliasRowid=$o(^MRC("ID",rowid,"ALIAS",aliasRowid))
			q:(aliasRowid="")
			s alias=alias_$p($g(^MRC("ID",rowid,"ALIAS",aliasRowid)),"^",1)_$c(2)
		}
		;w code_"^"_desc_"^"_alias,!
		if (hasGB=1) {
			if $$CheckContain(desc,argTarget,hasGB) {s ttt=ttt_code_"^"_desc_$c(10)}
		}
		else {
			if $$CheckContain(desc,argTarget,hasGB)||$$CheckContain(code,argTarget,hasGB)||$$CheckContain(alias,argTarget,hasGB) {s ttt=ttt_code_"^"_desc_$c(10)}
		}
	}
	q ttt
	
CheckContain(AVesselStr,ACompStr,isGB)
  S Result = 0
  S ComLength = $L(ACompStr)
  
  if 'isGB
  {
		if (AVesselStr [ ACompStr)
		{ s Result = 1}
	}
  Elseif isGB
  {s HasConFlag= "True"
	 for I=1:1:ComLength 
     { S GBStr= $E(ACompStr,I)  
	   s GBConFlag= "False"
	   if (I=1)
	   { S ANewVesselStr = AVesselStr  }
        if (ANewVesselStr [GBStr)
        { s GBConFlag= "True"
	      S ANewVesselStr = $E(ANewVesselStr, $F(ANewVesselStr,GBStr),$L(ANewVesselStr))
	      }
			if (GBConFlag="False")
			{ s HasConFlag= "False"	}
    }
	 if (HasConFlag="True")
	 { S Result =1 	 }
	} 	
  Quit Result
}

ClassMethod SelectStdDicByRuleTypeTag(argRuleTypeTag As %String) As EPRservice.dataset.EStdDicByRuleTypeTagDataset [ WebMethod ]
{
 Set result=##class(EPRservice.dataset.EStdDicByRuleTypeTagDataset).%New()
 Do result.SetArgs(argRuleTypeTag)
 Quit result
}

/// Desc:	根据字典代码获取字典默认查询条件
/// Debug：	w ##Class(CT.WS.BO.BOStdDictionary).SelectConditionByStdCode("S06")
ClassMethod SelectConditionByStdCode(AStdDicCode As %String) As %String [ WebMethod ]
{
	s retValue = ""
	
	s stdConditionCode = "", stdCondition = ""
	//&sql(select top 1 ConditionCode, Condition into :stdConditionCode, :stdCondition 
	//	from CT.WS.StdDictionary where Code = :AStdDicCode)
	
	q:(stdConditionCode = "")||(stdConditionCode = $c(0)) retValue
	q:(stdCondition = "")||(stdCondition = $c(0)) retValue
	
	s retValue = stdConditionCode_"^"_stdCondition
	q retValue
	
	q retValue
}

/// Desc:改变记录顺序
/// Creator: Candyxu
/// Date: 2012-06-07
/// input: RowID1 交换记录的第一条记录ID，RowID2 交换记录的第二条记录ID
/// Result:0失败，1成功
/// do ##class(CT.WS.BO.BOStdDictionary).SwapSequence("3","4")
ClassMethod SwapSequence(RowID1 As %String, RowID2 As %String) As %Boolean [ WebMethod ]
{
	set result = 0
	set obj1 = ##class(CT.WS.StdDictionary).%OpenId(RowID1)
	set obj2 = ##class(CT.WS.StdDictionary).%OpenId(RowID2)
	quit:((obj1 = "")||(obj2 = "")) result 
	set TempSequence = obj1.Sequence
	set obj1.Sequence = obj2.Sequence
	set obj2.Sequence = TempSequence
	set $zt = "SwapErrorHandler"
	Tstart
	set sc1=obj1.%Save() 
	if $$$ISERR(sc1)
	{
		quit result
	}
	set sc2=obj2.%Save() 
	if $$$ISERR(sc2)
	{
		Trollback
		quit result
	}
	TCOMMIT
	 do obj1.%Close()
	 do obj2.%Close()
	 set obj1 = ""
	 set obj2 = ""
	 set result = 1
	 quit result
	 
SwapErrorHandler
    quit:0
}

/// Debug:	d ##Class(CT.WS.BO.BOStdDictionary).TestStdDic()
ClassMethod TestStdDic()
{
	s para = $g(^DHCEPRDebug("CT.WS.BO.BOStdDictionary.GetStdDicOrList","para"))
	s ADicCode = $p($p(para,"^",1),"=",2)
	s AItem = $p($p(para,"^",2),"=",2)
	s APageNum = $p($p(para,"^",3),"=",2)
	s ARowCount = $p($p(para,"^",4),"=",2)
	s CountFlag = $p($p(para,"^",5),"=",2)
	s AResultCount = $p($p(para,"^",6),"=",2)
	s SessionId = $p($p(para,"^",7),"=",2)
	s ConditionCode = $p($p(para,"^",8),"=",2)
	s Condition = $p($p(para,"^",9),"=",2)
	b "101"
    s obj = ..GetStdDicOrList(ADicCode,AItem, APageNum, ARowCount, CountFlag, AResultCount, SessionId, ConditionCode, Condition)
}

}
