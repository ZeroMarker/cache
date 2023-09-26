/// 名称:	EMR.DOC.BL.StdDictionary
/// 描述:	字典表业务类
/// 编写者：yejian
/// 编写日期: 2021-6-3
/// 产品组：电子病历产品组
Class EMR.DOC.BL.StdDictionary Extends EMR.DOC.COM.ActionBase
{

/// Desc:       加载字典内容
/// Creator:    yejian
/// CreateDate: 2021-6-3
/// Input:      argArray  	命令参数 {"action":"LOAD_DICTIONARY","product":"OP","params":{"pageCount":"0","dicCode":"S14","cookieID":"","page":1,"pageSize":20,"searchValue":"","searchType":0,"diseaseID":"0","patientID":"259","episodeID":"713","userID":"6","userCode":"ys01","userName":"医生01","userLocID":"60","userLocCode":"ZYMZ006","userLocName":"内分泌科门诊","sessionID":"","ssgroupID":"28","hospitalID":"1","ipAddress":"127.0.0.1","pmdType":"EMR","pmdCode":"","all":"0","relationID":""}}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData 	返回数据 成功：添加数据的rowID,失败：-1
ClassMethod LoadDictionary(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s argDTO = ##class(EMR.DOC.DTO.StdDicParameter).%New()
	s argDTO.ProductCode = argInJson.product
	s argDTO.DicCode  = argInJson.params.dicCode
	s argDTO.SearchValue  = argInJson.params.searchValue
	///搜索类型 0: 模糊搜索, 1: 精确搜索,2:左查询
	s argDTO.SearchType  = argInJson.params.searchType
	s argDTO.PageCount  = argInJson.params.pageCount
	s argDTO.Page  = argInJson.params.page
	s argDTO.PageSize  = $case(argInJson.params.pageSize,"":10,:argInJson.params.pageSize)
	s argDTO.SearchValue  = argInJson.params.searchValue
	;s argDTO.CookieID  = argInJson.params.sessionId
	s argDTO.CookieID  = argInJson.params.cookieID
	s argDTO.PatientID = argInJson.params.patientID
	s argDTO.EpisodeID = argInJson.params.episodeID
    s argDTO.UserID = argInJson.params.userID
    s argDTO.UserCode = argInJson.params.userCode
    s argDTO.UserName = argInJson.params.userName
	s argDTO.UserLocID = argInJson.params.userLocID
	s argDTO.UserLocCode = argInJson.params.userLocCode
	s argDTO.UserLocName = argInJson.params.userLocName
	s argDTO.SSGroupID = argInJson.params.ssgroupID
	s argDTO.HospitalID = argInJson.params.hospitalID
	s argDTO.IpAddress = argInJson.params.ipAddress
	s argDTO.PmdType = argInJson.params.pmdType
	s argDTO.PmdCode = argInJson.params.pmdCode
	//0:不全部搜索,1、全部搜索
	s argDTO.All = argInJson.params.all
	s argDTO.AllChange = argInJson.params.allChange
	s argDTO.Condition = argInJson.params.relationID
	 //0:不翻页（清缓存）,1、翻页（不清缓存）
	s argDTO.TurnPage = 0
	s:(argDTO.SearchValue="")&&(argDTO.Page'="1") argDTO.TurnPage = 1
	s:(argDTO.AllChange=1) argDTO.TurnPage = 0

	s argDTO.ConditionCode =##Class(EMR.DOC.BL.StdDictionary).SelectConditionByStdCode(argDTO.DicCode)
	
	//如果没有查询条件并且允许带内置默认条件，则检查字典是否设置查询条件关键字
	if (argDTO.Condition="")&&(argDTO.All'=1)
	{	    
		s hospitalID = argInJson.params.hospitalID
	    s ConditionKeyWord =##Class(EMR.DOC.BL.StdDictionary).getConditionByStdCode(argDTO.DicCode)
	    s strCondition = ""
	    if (ConditionKeyWord="{CTLocID}")
	    {
		    s strCondition=argDTO.UserLocID
	    }
	    elseif (ConditionKeyWord="{UserID}")
	    {
		    s strCondition=argDTO.UserID
	    }
	    elseif (ConditionKeyWord="{PatientID}")
	    {
		    s strCondition=argDTO.PatientID
	    }
	    elseif (ConditionKeyWord="{EpisodeID}")
	    {
		    s strCondition=argDTO.EpisodeID
	    }
	    elseif (ConditionKeyWord="{SsgroupID}")
	    {
		    s strCondition=argDTO.SSGroupID
        }
	    elseif (ConditionKeyWord="{HospitalID}")
	    {
		    s strCondition=argDTO.HospitalID
	    }
	    elseif (ConditionKeyWord '[ "{") 
	    {
            s strCondition=ConditionKeyWord
	    }
	    s argDTO.Condition = strCondition
	}
	
	s strRes = ##Class(EMR.DOC.BL.StdDictionary).LoadDictionaryJson(argDTO,.argOutData)
	//-100:获取数据失败 -200:传入参数不能为空
	if (strRes [ "-1")
	{ 
		s strErr = $p(strRes,"^",2)
	    q ..SetOutMessage(argOutMessage,"ERROR",strErr,2)
	}
	else
	{  
	     q argOutMessage.success = ..#OK
	}
Error
	d argOutData.Write(..#NONE)
	q ..SetOutMessage(argOutMessage,"ERROR")
}

/// Desc:       清理字典内容
/// Creator:    yejian
/// CreateDate: 2021-6-3
/// Input:      argArray  	命令参数 {"action":"CLOSE_DICTIONARY_SESSION","product":"OP","params":{"cookieID":"1"}}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData 	返回数据 成功：1,失败：-1
ClassMethod CloseDictionnary(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s strCookieID  = argInJson.params.cookieID
	
	s strRes = ##Class(EMR.DOC.BL.StdDictionary).CloseDictionnaryJson(strCookieID)
	
	q argOutMessage.success = ..#OK
	
Error
	d argOutData.Write(..#NONE)
	q ..SetOutMessage(argOutMessage,"ERROR")
}

/// Desc:       清理字典内容
/// Creator:    yejian
/// CreateDate: 2021-6-3
/// Input:      argDTO.CookieID  global缓存ID
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData 	返回数据 成功：添加数据的rowID,失败：-1
ClassMethod CloseDictionnaryJson(ACookieID As %String)
{
	K ^CacheTempStdQuery(ACookieID)
}

/// Desc:  字典查询xml结果
/// Creator:    yejian
/// CreateDate: 2021-6-3
/// Input:      argDTO  字典参数对象
/// OutPut:     argOutData 返回数据
/// 			返回数据 -1^错误提示信息
/// Debug: w ##Class(EMR.DOC.BL.StdDictionary).GetStdDicXML("S01","",1,10,"true","","")
ClassMethod LoadDictionaryJson(argDTO As EMR.DOC.DTO.StdDicParameter, ByRef argOutData As %GlobalBinaryStream) As %String
{
	s strRes = "1"
    //检查参数有效性
 	q:(argDTO.DicCode = "") "-1^字典编码不能为空"
 	q:(argDTO.Page = "") "-1^当前页码不能为空"
 	q:(argDTO.PageSize = "") "-1^行数不能为空"
 	//字典单元点击查询按钮，生成查询结果集存储在临时global中，并取相应页码的结果
 	if (argDTO.TurnPage = "0") 
 	{ 
   		if (argDTO.CookieID'= "") && (argDTO.CookieID '= $c(0))
 	    {
	 	   K ^CacheTempStdQuery(argDTO.CookieID)
	 	}
	 	else
	 	{
   		   s argDTO.CookieID = $I(^CacheTempStdQuery)
   		   K ^CacheTempStdQuery(argDTO.CookieID)
	 	}
	 	
   		//生成字典查询结果集，并存储在临时global中
   		s argDTO.PageCount= ##class(EMR.DOC.BL.StdDictionary).SelectNewStdDicPageCount(argDTO)
   		
   		//取相应页码的结果
  		if (argDTO.PageCount '= 0)
  		{ 
  			s dataSet = ##class(%ResultSet).%New("EMR.DOC.BL.StdDictionary:GetStdDicOrList")
			d dataSet.Execute(argDTO.DicCode,argDTO.SearchValue,argDTO.Page,argDTO.PageSize,argDTO.CookieID)
  		}
  		else
  		{
			s argDTO.CookieID = 0
		}
 	}
 	else		//字典单元点击取前页或后页按钮，直接在临时global存储的结果集中取相应页码的结果
 	{
	 	if ((argDTO.PageCount '= 0)&&(argDTO.PageCount '= ""))
	 	{
		 	s argDTO.CookieID = argDTO.CookieID
	   		s ^CacheTempStdQuery(argDTO.CookieID) = "True"
	   		s pageStart = $G(^CacheTempStdQuery(argDTO.CookieID,"StdQueryPageStart"))
	   		s pageEnd = $G(^CacheTempStdQuery(argDTO.CookieID,"StdQueryPageEnd"))
	   		
	   		if (argDTO.Page < pageStart)||(argDTO.Page > pageEnd)
	   		{
		   		 K ^CacheTempStdQuery(argDTO.CookieID)
		   		//生成字典查询结果集，并存储在临时global中
   				s argDTO.PageCount= ##class(EMR.DOC.BL.StdDictionary).SelectNewStdDicPageCount(argDTO)
	   		}
	   		
	   		s TotalRowCount =  $G(^CacheTempStdQuery(argDTO.CookieID,"StdQueryDataCount"))	 
	   		s argDTO.Total= TotalRowCount
	   		if TotalRowCount '= 0
	   		{
		   	  	s dataSet = ##class(%ResultSet).%New("EMR.DOC.BL.StdDictionary:GetStdDicOrList")
				d dataSet.Execute(argDTO.DicCode,argDTO.SearchValue,argDTO.Page,argDTO.PageSize,argDTO.CookieID)	
	 		}
	 		else
	 		{
		  		s argDTO.CookieID = 0
		 	}
	 	}
 	}
	s jsonDic  = ##class(%DynamicObject).%New()
	s jsonDic.pageCount = argDTO.PageCount
	s jsonDic.total = argDTO.Total
	;s jsonDic.current = argDTO.PageSize
	;s jsonDic.pageSize = argDTO.Page
	s jsonDic.cookieID = argDTO.CookieID
	s jsonArr = ##class(%DynamicArray).%New()
	if ($g(dataSet) '= "")
	{
		while (dataSet.Next())
		{
			s jsonItem  = ##class(%DynamicObject).%New()
		    s jsonItem.id =dataSet.Data("ID")
		  	s jsonItem.value =dataSet.Data("DicCode")
		    s jsonItem.text =dataSet.Data("DicDesc")
		    s jsonItem.blog =dataSet.Data("DicAlias")
		    //去掉分隔符$c(2)
		    s jsonItem.blog = $tr(jsonItem.blog,$c(2),"")
			d jsonArr.%Push(jsonItem)								
		}
	}
	s jsonDic.choices = jsonArr
	d jsonDic.%ToJSON(argOutData)
	s strRes = "1"
	q strRes
}

/// 重写 SelectNewStdDicPageCount, 若字典单元查询不出记录，请用一下注释内容替换上面的 SelectNewStdDicPageCount 方法
/// For P8
ClassMethod SelectNewStdDicPageCount(argDTO As EMR.DOC.DTO.StdDicParameter) As %Integer
{
 
 //初始化返回值
 s returnPageCount = 0
 
 // 校验入参
 q:(argDTO.DicCode="") returnPageCount
 	
 //取字典及相关配置信息
 s arrDicInfo = ..GetDicInfo(argDTO.DicCode)
 q:(arrDicInfo = "") returnPageCount
 s DicTableName = arrDicInfo.GetAt("TableName")
 s DicAlias = arrDicInfo.GetAt("DicAliasCol")
 s DicCode = arrDicInfo.GetAt("DicCodeCol")
 s DicDesc = arrDicInfo.GetAt("DicDescCol")
	
 //是否保留字典描述列中的横线
 s isKeepMinus="0"
 s strNotRemoveMinus = ##Class(EMR.DOC.BL.SysOption).GetOptionValueByName("NotRemoveMinus",argDTO.ProductCode,"")
 s:'($F(strNotRemoveMinus,DicTableName)=0)&&('$F(strNotRemoveMinus,DicDesc)=0) isKeepMinus="1"
 
 //查询条件中是否含有GB字符
 s hasGB=0
 s ComLength = $L(argDTO.SearchValue)
 for I=1:1:ComLength 
 {
	s GBStr= $E(argDTO.SearchValue,I)  
	if (($A(GBStr)>=19968)&& ($A(GBStr)<=40869))||(($A(GBStr)>=63744)&& ($A(GBStr)<=64045))
	{
		s hasGB=1
		q
	}
 }
 
 s minCount = (argDTO.Page - 1) * argDTO.PageSize + 1
 s maxCount = minCount + (argDTO.PageSize * 10) - 1
 s:(minCount > (argDTO.PageSize * 5)) minCount = minCount - (argDTO.PageSize * 5)
 
 s argDTO.DicTableName = DicTableName
 s argDTO.DicCodeCol=DicCode
 s argDTO.DicAliasCol=DicAlias
 s argDTO.DicDescCol=DicDesc
 s argDTO.IsKeepMinus = isKeepMinus
 s argDTO.HasGB = hasGB
 s argDTO.MinCount = minCount
 s argDTO.MaxCount = maxCount
 
 
 //查询字典内容
 if (argDTO.ConditionCode '= "")&&(argDTO.ConditionCode '= $C(0))
 {
	 s totRowCount = ..SelectStdDicWithDefaultCond(argDTO)
 }
 else
 {
	 s totRowCount = ..SelectStdDicWithoutDefaultCond(argDTO)
 }
  s argDTO.CookieID = argDTO.CookieID
 s ^CacheTempStdQuery(argDTO.CookieID,"StdQueryDataCount") = totRowCount	
 s ^CacheTempStdQuery(argDTO.CookieID) = "True"
 
 s returnPageCount = totRowCount\argDTO.PageSize
 s modulo = totRowCount#argDTO.PageSize
 s:(modulo '= 0) returnPageCount = returnPageCount + 1  
 
 s ^CacheTempStdQuery(argDTO.CookieID,"StdQueryPageStart") = minCount\argDTO.PageSize+1
 s ^CacheTempStdQuery(argDTO.CookieID,"StdQueryPageEnd") = $case(returnPageCount < (argDTO.Page + 10 - 1), 1:returnPageCount, :(argDTO.Page + 10 - 1))
 s argDTO.Total = totRowCount
 q returnPageCount
}

Query GetStdDicOrList(ADicCode As %String, AItem As %String, APageNum As %Integer, ARowCount As %Integer, ACookieID As %String) As %Query(ROWSPEC = "ID:%String,DicAlias:%String,DicCode:%String,DicDesc:%String")
{
}

ClassMethod GetStdDicOrListExecute(ByRef qHandle As %Binary, ADicCode As %String, AItem As %String, APageNum As %Integer, ARowCount As %Integer, ACookieID As %String) As %Status
{
 s qHandle="1" 
 s SQLCODE=0 
 //s %ROWID=0 
 s %counter=0
 s ID=""
 S %ResultID=""
 //S ^CacheTempStdQuery($J)="True"	 
 if ($D(^CacheTempStdQuery(ACookieID)))
 {
	if ($G(^CacheTempStdQuery(ACookieID))="True") 
	{
		Set StartPageID= (APageNum-1)*ARowCount
		Set LastPageId = APageNum*ARowCount
		set PageKey= $O(^CacheTempStdQuery(ACookieID,""))
		
		Set PageNumCounter = PageKey -1
		While ((PageKey '="")&&(PageKey '= "StdQueryDataCount"))
		{
			s PageNumCounter = PageNumCounter + 1
			if (PageNumCounter> StartPageID)&(PageNumCounter <= LastPageId)
			{ 
				Set %ResultID(PageNumCounter-StartPageID)= $G(^CacheTempStdQuery(ACookieID,PageKey))	 
			}

			set PageKey= $O(^CacheTempStdQuery(ACookieID,PageKey)) 	
		 }
		 s qHandle=%ResultID
		 Quit $$$OK
		}
	}
	s qHandle=%ResultID
    Quit $$$OK
}

ClassMethod GetStdDicOrListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetStdDicOrListExecute ]
{
 s SQLCODE=0 
 s $ET="QUIT" 
 s %counter=%counter+1
 if $o(%ResultID(""),-1)<%counter 
 {
	s Row = ""
	s AtEnd=1
 }
 else 
 {
	set Row=%ResultID(%counter)
	;s ^gjbtest(%counter)=Row
	}

 Quit $$$OK
}

ClassMethod GetStdDicOrListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetStdDicOrListExecute ]
{
 s qHandle="" 
 Quit $$$OK
}

/// Desc:	根据字典代码获取字典默认查询条件
/// Debug：	w ##Class(EMR.DOC.BL.StdDictionary).SelectConditionByStdCode("S06")
ClassMethod SelectConditionByStdCode(AStdDicCode As %String) As %String
{
	s retValue = ""
	
	s stdConditionCode = "", stdCondition = ""
	&sql(select top 1 ConditionCode, Condition into :stdConditionCode, :stdCondition 
		from CF_EMR_DOC.StdDictionary where Code = :AStdDicCode)
	
	q:(stdConditionCode = "")||(stdConditionCode = $c(0)) retValue
	//q:(stdCondition = "")||(stdCondition = $c(0)) retValue
	
	;s retValue = stdConditionCode_"^"_stdCondition
	s retValue = stdConditionCode	
	q retValue
}

/// Desc:	根据字典代码获取字典默认查询条件
/// Debug：	w ##Class(EMR.DOC.BL.StdDictionary).getConditionByStdCode("S06")
ClassMethod getConditionByStdCode(AStdDicCode As %String) As %String
{
	s retValue = ""
	
	s stdConditionCode = "", stdCondition = ""
	&sql(select top 1 ConditionCode, Condition into :stdConditionCode, :stdCondition 
		from CF_EMR_DOC.StdDictionary where Code = :AStdDicCode)
	
	q:(stdCondition = "")||(stdCondition = $c(0)) retValue

	s retValue = stdCondition
	q retValue
}

/// Desc:	取字典信息
ClassMethod GetDicInfo(ADicCode As %String) As %ArrayOfDataTypes
{
	s dicInfo = ""
	
 	s dicID = "", dicTableName = "", dicAliasCol = "", dicCodeCol = "", dicDescCol = ""
 	&sql(select top 1 ID, TableName, DicAliasCol, DicCodeCol, DicDescCol
 		into :dicID, :dicTableName, :dicAliasCol, :dicCodeCol, :dicDescCol 
 		from CF_EMR_DOC.StdDictionary where CF_EMR_DOC.StdDictionary.Code = :ADicCode)
 	
 	q:(dicID = "")||(dicID = $c(0)) dicInfo
 
	
	s dicInfo = ##Class(%ArrayOfDataTypes).%New()
	d dicInfo.SetAt(dicTableName,"TableName")
	d dicInfo.SetAt(dicAliasCol,"DicAliasCol") 
	d dicInfo.SetAt(dicCodeCol,"DicCodeCol") 
	d dicInfo.SetAt(dicDescCol,"DicDescCol") 
	
	q dicInfo
}

ClassMethod SwitchWhere(parOldFromTable As %String, parOldWhere As %String) As %String
{
	;ICD and mrcid_dateactiveto<Curdate
	s Curdate=+$h
	q:((parOldFromTable="SQLUser.MRC_ICDDx")&&(parOldWhere="")) " where MRCID_ICD9CM_Code is NOT null AND ALIAS_ParRef=MRCID_Rowid and ((mrcid_dateactiveto='')or (mrcid_dateactiveto is null) or (mrcid_dateactiveto>"_Curdate_")) "
	q:(parOldFromTable="SQLUser.MRC_ICDDx") parOldWhere_" and ALIAS_ParRef=MRCID_Rowid and MRCID_ICD9CM_Code is NOT null and ((mrcid_dateactiveto='') or (mrcid_dateactiveto is null) or (mrcid_dateactiveto>"_Curdate_")) "
	;Operation and oper_activedateto<>''
	q:((parOldFromTable="SQLUser.ORC_Operation")&&(parOldWhere="")) " where OPER_Code is NOT null AND ALIAS_ParRef=OPER_Rowid AND ((oper_activedateto='') or (oper_activedateto is null)"_" or (oper_activedateto>"_Curdate_")) "
	q:(parOldFromTable="SQLUser.ORC_Operation") parOldWhere_" and ALIAS_ParRef=OPER_Rowid and OPER_Code is NOT null AND ((oper_activedateto='') or (oper_activedateto is null)"_" or (oper_activedateto>"_Curdate_")) "
	//update end 08-06-30
	
	//职业
	q:((parOldFromTable="SQLUser.CT_Occupation")&&(parOldWhere="")) " where CTOCC_DateFrom <= "_Curdate_" and ((CTOCC_DateTo is null) or (CTOCC_DateTo >"_Curdate_"))"
	q:((parOldFromTable="SQLUser.CT_Occupation")) parOldWhere_" and CTOCC_DateFrom <= "_Curdate_" and ((CTOCC_DateTo is null) or (CTOCC_DateTo >"_Curdate_"))" 
	
	//联系人关系
	q:((parOldFromTable="SQLUser.CT_Relation")&&(parOldWhere="")) " where CTRLT_DateFrom <= "_Curdate_" and ((CTRLT_DateTo is null) or (CTRLT_DateTo='') or (CTRLT_DateTo >"_Curdate_"))"
	q:((parOldFromTable="SQLUser.CT_Relation")) parOldWhere_" and CTRLT_DateFrom <= "_Curdate_" and ((CTRLT_DateTo is null) or (CTRLT_DateTo='') or (CTRLT_DateTo >"_Curdate_"))" 
	
	//国籍
	q:((parOldFromTable="SQLUser.CT_Country")&&(parOldWhere="")) " where CTCOU_DateActiveFrom <= "_Curdate_" and ((CTCOU_DateActiveTo is null) or (CTCOU_DateActiveTo='') or (CTCOU_DateActiveTo >"_Curdate_"))"
	q:((parOldFromTable="SQLUser.CT_Country")) parOldWhere_" and CTCOU_DateActiveFrom <= "_Curdate_" and ((CTCOU_DateActiveTo is null) or (CTCOU_DateActiveTo='') or (CTCOU_DateActiveTo >"_Curdate_"))" 
	
	//麻醉方式
	q:((parOldFromTable="SQLUser.ORC_AnaestMethod")&&(parOldWhere="")) " where ANMET_DateFrom <= "_Curdate_" and ((ANMET_DateTo is null) or (ANMET_DateTo='') or (ANMET_DateTo >"_Curdate_"))"
	q:((parOldFromTable="SQLUser.ORC_AnaestMethod")) parOldWhere_" and ANMET_DateFrom <= "_Curdate_" and ((ANMET_DateTo is null) or (ANMET_DateTo='') or (ANMET_DateTo >"_Curdate_"))" 
	
	q parOldWhere
}

/// Desc:	处理带有默认查询条件的字典
ClassMethod SelectStdDicWithDefaultCond(argDTO As EMR.DOC.DTO.StdDicParameter) As %Integer
{
	s argDTO.SearchValue=argDTO.SearchType_"^"_argDTO.SearchValue
	s ADicTableName = argDTO.DicTableName
	s AConditionCode = argDTO.ConditionCode
	s totRowCount = 0
	
	if ($zcvt(ADicTableName,"U") = "SQLUSER.SS_USER")&&(AConditionCode = "S001")
	{
		s totRowCount = ..SelectStdDic001(argDTO)
	}
	elseif ($zcvt(ADicTableName,"U") = "SQLUSER.SS_USER")&&(AConditionCode = "S002")
	{
		s totRowCount = ..SelectStdDic002(argDTO)
	}
	elseif ($zcvt(ADicTableName,"U") = "SQLUSER.SS_USER")&&(AConditionCode = "S003")
	{
		s totRowCount = ..SelectStdDic003(argDTO)
	}
	elseif ($zcvt(ADicTableName,"U") = "EMRVIEW.OPERATION")&&(AConditionCode = "C001")
	{
		s totRowCount = ..SelectStdDic004(argDTO)
	}
	elseif ($zcvt(ADicTableName,"U") = "EMRVIEW.OPERATIONCUTSITE")&&(AConditionCode = "C002")
	{
		s totRowCount = ..SelectStdDic005(argDTO)
	}
	elseif ($zcvt(ADicTableName,"U") = "SQLUSER.CT_CITY")&&(AConditionCode = "S004")
	{		
		s totRowCount = ..SelectStdDic006(argDTO)
	}
	elseif ($zcvt(ADicTableName,"U") = "SQLUSER.CT_CITYAREA")&&(AConditionCode = "S005")
	{		
		s totRowCount = ..SelectStdDic007(argDTO)
	}
	elseif ($zcvt(ADicTableName,"U") = "SQLUSER.CT_DICEMR")&&(AConditionCode = "C003")
	{
		s totRowCount = ..SelectStdDic008(argDTO)
	}
	elseif ($zcvt(ADicTableName,"U") = "SQLUSER.PAC_BED")&&(AConditionCode = "C004")
	{
		s totRowCount = ..SelectStdDic009(argDTO)
	}
	elseif ($zcvt(ADicTableName,"U") = "SQLUSER.CT_CARPRVTP")&&(AConditionCode = "S006")
	{
		s totRowCount = ..SelectStdDic010(argDTO)
	}
	elseif ($zcvt(ADicTableName,"U") = "SQLUSER.PAC_WARD_DIC")&&(AConditionCode = "S007")
	{
		s totRowCount = ..SelectStdDic011(argDTO)
	}
	elseif ($zcvt(ADicTableName,"U") = "SQLUSER.ORC_OPERATIONCATEGORY")&&(AConditionCode = "COO5")
	{
		s totRowCount = ..SelectStdDic012(argDTO)
	}
	elseif ($zcvt(ADicTableName,"U") = "SQLUSER.SS_USER")&&(AConditionCode = "S008")
	{
		s totRowCount = ..SelectStdDic013(argDTO)
	}
    elseif ($zcvt(ADicTableName,"U") = "SQLUSER.SS_USER")&&(AConditionCode = "S009")
    {
        s totRowCount = ..SelectStdDic014(argDTO)
    }
    elseif ($zcvt(ADicTableName,"U") = "SQLUSER.SS_USER")&&(AConditionCode = "S010")
    {
        s totRowCount = ..SelectStdDic015(argDTO)
    }
	elseif ($zcvt(ADicTableName,"U") = "SQLUSER.SS_USER")&&(AConditionCode = "S011")
	{
		s totRowCount = ..SelectStdDic060(argDTO)
	}
	elseif ($zcvt(ADicTableName,"U") = "SQLUSER.CT_LOC_DIC")&&(AConditionCode = "S012")
    {
        s totRowCount = ..SelectStdDic016(argDTO)
    }
    elseif ($zcvt(ADicTableName,"U") = "SQLUSER.PAC_WARD_DIC")&&(AConditionCode = "S013")
    {
        s totRowCount = ..SelectStdDic017(argDTO)
    }
    elseif ($zcvt(ADicTableName,"U") = "SQLUSER.CT_CAREPROV")&&(AConditionCode = "S014")
    {
        s totRowCount = ..SelectStdDic018(argDTO)
    }
    /// 医保自费药品字典
    elseif($zcvt(ADicTableName,"U") = "SQLUSER.MRCZFYP")&&(AConditionCode = "S006")
    {
	s totRowCount = ..SelectStdDic019(argDTO)
    }
	
	q totRowCount
}

/// Create:	2011-09-14	HouJ Wangwt
/// Desc:	查询【用户】字典内容：SQLUser.SS_User
/// Input：	argDTO.SearchValue 查询条件；argDTO.DicAliasCol 别名列；argDTO.DicCodeCol 代码列；argDTO.DicDescCol 描述列；ADescHasMinius 描述列是否有横线
ClassMethod SelectStdDic001(argDTO As EMR.DOC.DTO.StdDicParameter) As %Integer
{
	
	//结果行总数
	s totRowCount = 0
	
	//开始查询
	s rowid = 0
	for {
		s rowid=$o(^SSU("SSUSR",rowid))
		quit:(rowid = "")
		
		//取代码列,描述列,别名列
		if ($zcvt(argDTO.DicCodeCol,"U") = "SSUSR_INITIALS")
		{s CodeValue=$p($g(^SSU("SSUSR",rowid)),"^",1)}
		s DescValue=$p($g(^SSU("SSUSR",rowid)),"^",2)
		s AliasValue=$p($g(^SSU("SSUSR",rowid)),"^",11)
		
		s (SSUSRCareProvDR,RESRowId) = ""
		s SSUSRCareProvDR = $p($g(^SSU("SSUSR",rowid)),"^",14)
		if (SSUSRCareProvDR'="")&&(argDTO.Condition'="") 
		{
			s defaultConditionLocIDValue = $O(^CTLOC(0,"Code",$zcvt(argDTO.Condition,"U"),""))
			continue:(defaultConditionLocIDValue="")
			s RESRowId=$o(^RB("RES",0,"CTPCP",SSUSRCareProvDR,defaultConditionLocIDValue,""))
			continue:(RESRowId="")
		}
		//wangwentao 20111020 update end
		
		//是否满足查询条件
		s CodeCom=0, DescCom=0, AliasCom=0
		if (argDTO.SearchValue '= "")
		{	
			
			s CodeCom= ##Class(EMR.DOC.COM.CheckTool).CheckContain($ZCVT(CodeValue,"U"),$ZCVT(argDTO.SearchValue,"U"),argDTO.HasGB)
			S DescCom= ##Class(EMR.DOC.COM.CheckTool).CheckContain($ZCVT(DescValue,"U"),$ZCVT(argDTO.SearchValue,"U"),argDTO.HasGB)
			if ((argDTO.DicAliasCol '="")&&(argDTO.DicAliasCol'=$C(0)))
			{	s AliasCom= ##Class(EMR.DOC.COM.CheckTool).CheckContain($ZCVT(AliasValue,"U"),$ZCVT(argDTO.SearchValue,"U"),argDTO.HasGB)}
			
			if ((CodeCom '= 1)&&(DescCom '= 1)&&(AliasCom '= 1))
			{	continue}
		}
		
		//处理满足条件的结果并存入临时global
		s totRowCount = totRowCount + 1
		if (argDTO.IsKeepMinus = "0")
		{	s DescValue = $E(DescValue,$F(DescValue,"-"),$L(DescValue)) }
		s:((totRowCount >= argDTO.MinCount)&&(totRowCount <= argDTO.MaxCount)) ^CacheTempStdQuery(argDTO.CookieID,totRowCount) =$LB(rowid,AliasValue,CodeValue,DescValue)
	}
	
	s ^CacheTempStdQuery(argDTO.CookieID,"StdQueryDataCount")= totRowCount
	
	q totRowCount
}

/// Create:	2011-09-22	Wangwt [HIS]默认手术室员工字典
/// Desc:	查询【用户】字典内容：SQLUser.SS_User  
/// Input：	argDTO.SearchValue 查询条件；argDTO.DicAliasCol 别名列；argDTO.DicCodeCol 代码列；argDTO.DicDescCol 描述列；ADescHasMinius 描述列是否有横线
ClassMethod SelectStdDic002(argDTO As EMR.DOC.DTO.StdDicParameter) As %Integer
{
	//结果行总数
	s totRowCount = 0
	
	//开始查询
	s rowid = 0
	for {
		s rowid=$o(^SSU("SSUSR",rowid))
		quit:(rowid = "")
		
		//取代码列,描述列,别名列
		if ($zcvt(argDTO.DicCodeCol,"U") = "SSUSR_INITIALS")
		{s CodeValue=$p($g(^SSU("SSUSR",rowid)),"^",1)}
		s DescValue=$p($g(^SSU("SSUSR",rowid)),"^",2)
		s AliasValue=$p($g(^SSU("SSUSR",rowid)),"^",11)
		
		//是否满足默认查询条件
		//wangwentao 20111025 update
		//s defaultDeptID = $p($g(^SSU("SSUSR",rowid)),"^",4)
		//continue:(defaultDeptID '= argDTO.Condition)
		//
		//典默认手术室人员
		s defaultDeptID = argDTO.Condition
		//^RB("RES",0,"CTPCP",{RES_CTPCP_DR},{RES_CTLOC_DR},{RES_RowId})  SQLUser.RB_Resource
		s (SSUSRCareProvDR,RESRowId) = ""
		s SSUSRCareProvDR = $p($g(^SSU("SSUSR",rowid)),"^",14)
		s:(SSUSRCareProvDR'="")&&(defaultDeptID'="") RESRowId=$o(^RB("RES",0,"CTPCP",SSUSRCareProvDR,defaultDeptID,""))
		continue:(RESRowId="")
		//wangwentao 20111025 update end
		
		//是否满足查询条件
		s CodeCom=0, DescCom=0, AliasCom=0
		if (argDTO.SearchValue '= "")
		{	
			
			s CodeCom= ##Class(EMR.DOC.COM.CheckTool).CheckContain($ZCVT(CodeValue,"U"),$ZCVT(argDTO.SearchValue,"U"),argDTO.HasGB)
			S DescCom= ##Class(EMR.DOC.COM.CheckTool).CheckContain($ZCVT(DescValue,"U"),$ZCVT(argDTO.SearchValue,"U"),argDTO.HasGB)
			if ((argDTO.DicAliasCol '="")&&(argDTO.DicAliasCol'=$C(0)))
			{	s AliasCom= ##Class(EMR.DOC.COM.CheckTool).CheckContain($ZCVT(AliasValue,"U"),$ZCVT(argDTO.SearchValue,"U"),argDTO.HasGB)}
			
			if ((CodeCom '= 1)&&(DescCom '= 1)&&(AliasCom '= 1))
			{	continue}
		}
		
		//处理满足条件的结果并存入临时global
		s totRowCount = totRowCount + 1
		if (argDTO.IsKeepMinus = "0")
		{	s DescValue = $E(DescValue,$F(DescValue,"-"),$L(DescValue)) }
		s:((totRowCount >= argDTO.MinCount)&&(totRowCount <= argDTO.MaxCount)) ^CacheTempStdQuery(argDTO.CookieID,totRowCount) =$LB(rowid,AliasValue,CodeValue,DescValue)
	}
	
	s ^CacheTempStdQuery(argDTO.CookieID,"StdQueryDataCount")= totRowCount
	
	q totRowCount
}

/// Create:	2011-09-22	Wangwt [HIS]默认麻醉科员工字典
/// Desc:	查询【用户】字典内容：SQLUser.SS_User  
/// Input：	argDTO.SearchValue 查询条件；argDTO.DicAliasCol 别名列；argDTO.DicCodeCol 代码列；argDTO.DicDescCol 描述列；ADescHasMinius 描述列是否有横线
ClassMethod SelectStdDic003(argDTO As EMR.DOC.DTO.StdDicParameter) As %Integer
{
	//结果行总数
	s totRowCount = 0
	
	//开始查询
	s rowid = 0
	for {
		s rowid=$o(^SSU("SSUSR",rowid))
		quit:(rowid = "")
		
		//取代码列,描述列,别名列
		if ($zcvt(argDTO.DicCodeCol,"U") = "SSUSR_INITIALS")
		{s CodeValue=$p($g(^SSU("SSUSR",rowid)),"^",1)}
		s DescValue=$p($g(^SSU("SSUSR",rowid)),"^",2)
		s AliasValue=$p($g(^SSU("SSUSR",rowid)),"^",11)
		

		//是否满足默认查询条件
		//wangwentao 20111025 update
		//s defaultDeptID = $p($g(^SSU("SSUSR",rowid)),"^",4)
		//continue:(defaultDeptID '= argDTO.Condition)
		//
		//典默认麻醉科人员
		s defaultDeptID = argDTO.Condition
		//^RB("RES",0,"CTPCP",{RES_CTPCP_DR},{RES_CTLOC_DR},{RES_RowId})  SQLUser.RB_Resource
		s (SSUSRCareProvDR,RESRowId) = ""
		s SSUSRCareProvDR = $p($g(^SSU("SSUSR",rowid)),"^",14)
		s:(SSUSRCareProvDR'="")&&(defaultDeptID'="") RESRowId=$o(^RB("RES",0,"CTPCP",SSUSRCareProvDR,defaultDeptID,""))
		continue:(RESRowId="")
		//wangwentao 20111025 update end
		
		//是否满足查询条件
		s CodeCom=0, DescCom=0, AliasCom=0
		if (argDTO.SearchValue '= "")
		{	
			
			s CodeCom= ##Class(EMR.DOC.COM.CheckTool).CheckContain($ZCVT(CodeValue,"U"),$ZCVT(argDTO.SearchValue,"U"),argDTO.HasGB)
			S DescCom= ##Class(EMR.DOC.COM.CheckTool).CheckContain($ZCVT(DescValue,"U"),$ZCVT(argDTO.SearchValue,"U"),argDTO.HasGB)
			if ((argDTO.DicAliasCol '="")&&(argDTO.DicAliasCol'=$C(0)))
			{	s AliasCom= ##Class(EMR.DOC.COM.CheckTool).CheckContain($ZCVT(AliasValue,"U"),$ZCVT(argDTO.SearchValue,"U"),argDTO.HasGB)}
			
			if ((CodeCom '= 1)&&(DescCom '= 1)&&(AliasCom '= 1))
			{	continue}
		}
		
		//处理满足条件的结果并存入临时global
		s totRowCount = totRowCount + 1
		if (argDTO.IsKeepMinus = "0")
		{	s DescValue = $E(DescValue,$F(DescValue,"-"),$L(DescValue)) }
		s:((totRowCount >= argDTO.MinCount)&&(totRowCount <= argDTO.MaxCount)) ^CacheTempStdQuery(argDTO.CookieID,totRowCount) =$LB(rowid,AliasValue,CodeValue,DescValue)
	}
	
	s ^CacheTempStdQuery(argDTO.CookieID,"StdQueryDataCount")= totRowCount
	
	q totRowCount
}

/// Create:	2011-09-22	Wangwt
/// Desc:	查询 [EMR]手术操作字典 内容：EMRview.Operation  EMRmeta.CustomDictionary
/// Input：	argDTO.SearchValue 查询条件；argDTO.DicAliasCol 别名列；argDTO.DicCodeCol 代码列；argDTO.DicDescCol 描述列；ADescHasMinius 描述列是否有横线
///         ^DHCEMRM.CustomDictionaryD(258)=<<$LB("","XQBSYLS","0051","胸腔闭式引流术","^39^41^43^","Y","Operation","","手术操作字典","","","","")>>
ClassMethod SelectStdDic004(argDTO As EMR.DOC.DTO.StdDicParameter) As %Integer
{
	//结果行总数
	s totRowCount = 0
	
	//开始查询
	s rowid = 0
	for {
		s rowid=$o(^DHCEMRM.CustomDictionaryD(rowid))
		quit:(rowid = "")
		
		//取代码列,描述列,别名列
		s CodeValue=$lg(^DHCEMRM.CustomDictionaryD(rowid),3)
		s DescValue=$lg(^DHCEMRM.CustomDictionaryD(rowid),4)
		s AliasValue=$lg(^DHCEMRM.CustomDictionaryD(rowid),2)
		
		//筛选字典
		s defaultCtmDictStatus = $lg(^DHCEMRM.CustomDictionaryD(rowid),6)
		continue:(defaultCtmDictStatus '= "Y")
		s defaultCtmDictType = $lg(^DHCEMRM.CustomDictionaryD(rowid),7)
		continue:(defaultCtmDictType '= "Operation")

		
		//是否满足默认查询条件
		s defaultDeptID = $lg(^DHCEMRM.CustomDictionaryD(rowid),5)
		continue:($f(defaultDeptID , "^"_argDTO.Condition_"^")=0)
		
		//是否满足查询条件
		s CodeCom=0, DescCom=0, AliasCom=0
		if (argDTO.SearchValue '= "")
		{	
			
			s CodeCom= ##Class(EMR.DOC.COM.CheckTool).CheckContain($ZCVT(CodeValue,"U"),$ZCVT(argDTO.SearchValue,"U"),argDTO.HasGB)
			S DescCom= ##Class(EMR.DOC.COM.CheckTool).CheckContain($ZCVT(DescValue,"U"),$ZCVT(argDTO.SearchValue,"U"),argDTO.HasGB)
			if ((argDTO.DicAliasCol '="")&&(argDTO.DicAliasCol'=$C(0)))
			{	s AliasCom= ##Class(EMR.DOC.COM.CheckTool).CheckContain($ZCVT(AliasValue,"U"),$ZCVT(argDTO.SearchValue,"U"),argDTO.HasGB)}
			
			if ((CodeCom '= 1)&&(DescCom '= 1)&&(AliasCom '= 1))
			{	continue}
		}
		
		//处理满足条件的结果并存入临时global
		s totRowCount = totRowCount + 1
		if (argDTO.IsKeepMinus = "0")
		{	s DescValue = $E(DescValue,$F(DescValue,"-"),$L(DescValue)) }
		s:((totRowCount >= argDTO.MinCount)&&(totRowCount <= argDTO.MaxCount)) ^CacheTempStdQuery(argDTO.CookieID,totRowCount) =$LB(rowid,AliasValue,CodeValue,DescValue)
	}
	
	s ^CacheTempStdQuery(argDTO.CookieID,"StdQueryDataCount")= totRowCount
	
	q totRowCount
}

/// Create:	2011-09-22	Wangwt
/// Desc:	查询 [EMR]切口位置字典 内容：EMRview.OperationCutSite  EMRmeta.CustomDictionary
/// Input：	argDTO.SearchValue 查询条件；argDTO.DicAliasCol 别名列；argDTO.DicCodeCol 代码列；argDTO.DicDescCol 描述列；ADescHasMinius 描述列是否有横线
///         ^DHCEMRM.CustomDictionaryD(258)=<<$LB("","XQBSYLS","0051","胸腔闭式引流术","^39^41^43^","Y","Operation","","手术操作字典","","","","")>>
ClassMethod SelectStdDic005(argDTO As EMR.DOC.DTO.StdDicParameter) As %Integer
{
	//结果行总数
	s totRowCount = 0
	
	//开始查询
	s rowid = 0
	for {
		s rowid=$o(^DHCEMRM.CustomDictionaryD(rowid))
		quit:(rowid = "")
		
		//取代码列,描述列,别名列
		s CodeValue=$lg(^DHCEMRM.CustomDictionaryD(rowid),3)
		s DescValue=$lg(^DHCEMRM.CustomDictionaryD(rowid),4)
		s AliasValue=$lg(^DHCEMRM.CustomDictionaryD(rowid),2)
		
		//筛选字典
		s defaultCtmDictStatus = $lg(^DHCEMRM.CustomDictionaryD(rowid),6)
		continue:(defaultCtmDictStatus '= "Y")
		s defaultCtmDictType = $lg(^DHCEMRM.CustomDictionaryD(rowid),7)
		continue:(defaultCtmDictType '= "OperationCutSite")

		
		//是否满足默认查询条件
		s defaultDeptID = $lg(^DHCEMRM.CustomDictionaryD(rowid),5)
		continue:($f(defaultDeptID , "^"_argDTO.Condition_"^")=0)
		
		//是否满足查询条件
		s CodeCom=0, DescCom=0, AliasCom=0
		if (argDTO.SearchValue '= "")
		{	
			
			s CodeCom= ##Class(EMR.DOC.COM.CheckTool).CheckContain($ZCVT(CodeValue,"U"),$ZCVT(argDTO.SearchValue,"U"),argDTO.HasGB)
			S DescCom= ##Class(EMR.DOC.COM.CheckTool).CheckContain($ZCVT(DescValue,"U"),$ZCVT(argDTO.SearchValue,"U"),argDTO.HasGB)
			if ((argDTO.DicAliasCol '="")&&(argDTO.DicAliasCol'=$C(0)))
			{	s AliasCom= ##Class(EMR.DOC.COM.CheckTool).CheckContain($ZCVT(AliasValue,"U"),$ZCVT(argDTO.SearchValue,"U"),argDTO.HasGB)}
			
			if ((CodeCom '= 1)&&(DescCom '= 1)&&(AliasCom '= 1))
			{	continue}
		}
		
		//处理满足条件的结果并存入临时global
		s totRowCount = totRowCount + 1
		if (argDTO.IsKeepMinus = "0")
		{	s DescValue = $E(DescValue,$F(DescValue,"-"),$L(DescValue)) }
		s:((totRowCount >= argDTO.MinCount)&&(totRowCount <= argDTO.MaxCount)) ^CacheTempStdQuery(argDTO.CookieID,totRowCount) =$LB(rowid,AliasValue,CodeValue,DescValue)
	}
	
	s ^CacheTempStdQuery(argDTO.CookieID,"StdQueryDataCount")= totRowCount
	
	q totRowCount
}

/// Create:	2012-07-09	Guozt
/// Desc:	查询 [HIS]城市字典 内容：SQLUser.CT_City
/// Input：	argDTO.SearchValue 查询条件；argDTO.DicAliasCol 别名列；argDTO.DicCodeCol 代码列；argDTO.DicDescCol 描述列；ADescHasMinius 描述列是否有横线
ClassMethod SelectStdDic006(argDTO As EMR.DOC.DTO.StdDicParameter) As %Integer
{
	//结果行总数
	s totRowCount = 0
	
	//开始查询
	s rowid = 0
	for {
		s rowid=$o(^CT("CIT",rowid))
		quit:(rowid = "")
		
		//wangwentao 20121129 add
		s dateFrom="",dateTo="",currentDate=""
		s dateFrom=$p($g(^CT("CIT",rowid)),"^",5)
		s dateTo=$p($g(^CT("CIT",rowid)),"^",6)
		s currentDate=$p($h,",",1)
		if (((dateFrom'="")&&(currentDate<dateFrom))||((dateTo'="")&&(currentDate'<dateTo)))
		{	continue}
		
		//取代码列,描述列,别名列
		s CodeValue=$p($g(^CT("CIT",rowid)),"^",1)
		s DescValue=$p($g(^CT("CIT",rowid)),"^",2)
		s AliasValue=""
		if ((argDTO.DicAliasCol '="")&&(argDTO.DicAliasCol'=$C(0)))
		{ 
			s id=0
			for {
				s id=$o(^User.BDPAliasI("DataRef","CT_City",rowid,id))
				q:(id="")
				s obj=##class(User.BDPAlias).%OpenId(id)
				q:(obj="")
				s AliasValue=AliasValue_obj.DataAlias_$c(2)
			}
		}
		
		
		//是否满足默认查询条件
		//
		//^CT("PROV",0,"Code",$$ALPHAUP({PROV_Code}),{PROV_RowId})  SQLUser.CT_Province
		s CTCITProvinceDR = ""
		s CTCITProvinceDR=$p($g(^CT("CIT",rowid)),"^",4)
		continue:(CTCITProvinceDR="")
		
		s PROVCode=$p($g(^CT("PROV",CTCITProvinceDR)),"^",1)
		continue:(PROVCode="")
		i (PROVCode'="")&&(argDTO.Condition'="")&&(argDTO.Condition'=$c(0)) continue:(PROVCode'=argDTO.Condition)
		
		//是否满足查询条件
		s CodeCom=0, DescCom=0, AliasCom=0
		if (argDTO.SearchValue '= "")
		{	
			
			s CodeCom= ##Class(EMR.DOC.COM.CheckTool).CheckContain($ZCVT(CodeValue,"U"),$ZCVT(argDTO.SearchValue,"U"),argDTO.HasGB)
			S DescCom= ##Class(EMR.DOC.COM.CheckTool).CheckContain($ZCVT(DescValue,"U"),$ZCVT(argDTO.SearchValue,"U"),argDTO.HasGB)
			if ((argDTO.DicAliasCol '="")&&(argDTO.DicAliasCol'=$C(0)))
			{	s AliasCom= ##Class(EMR.DOC.COM.CheckTool).CheckContain($ZCVT(AliasValue,"U"),$ZCVT(argDTO.SearchValue,"U"),argDTO.HasGB)}
			
			if ((CodeCom '= 1)&&(DescCom '= 1)&&(AliasCom '= 1))
			{	continue}
		}
		
		//处理满足条件的结果并存入临时global
		s totRowCount = totRowCount + 1
		if (argDTO.IsKeepMinus = "0")
		{	s DescValue = $E(DescValue,$F(DescValue,"-"),$L(DescValue)) }
		s:((totRowCount >= argDTO.MinCount)&&(totRowCount <= argDTO.MaxCount)) ^CacheTempStdQuery(argDTO.CookieID,totRowCount) =$LB(rowid,AliasValue,CodeValue,DescValue)
	}
	
	s ^CacheTempStdQuery(argDTO.CookieID,"StdQueryDataCount")= totRowCount
	
	q totRowCount
}

/// Create:	2012-07-23	Liaowp
/// Desc:	查询 [HIS]城市字典 内容：SQLUser.CT_CityArea
/// Input：	argDTO.SearchValue 查询条件；argDTO.DicAliasCol 别名列；argDTO.DicCodeCol 代码列；argDTO.DicDescCol 描述列；ADescHasMinius 描述列是否有横线
ClassMethod SelectStdDic007(argDTO As EMR.DOC.DTO.StdDicParameter) As %Integer
{
	//结果行总数
	s totRowCount = 0
	
	//开始查询
	s rowid = 0
	for {
		s rowid=$o(^CT("CITAREA",rowid))
		quit:(rowid = "")
		
		//20131101 wangwentao add
		s dateFrom="",dateTo="",currentDate=""
		s dateFrom=$p($g(^CT("CITAREA",rowid)),"^",4)
		s dateTo=$p($g(^CT("CITAREA",rowid)),"^",5)
		s currentDate=$p($h,",",1)
		if (((dateFrom'="")&&(currentDate<dateFrom))||((dateTo'="")&&(currentDate'<dateTo)))
		{	continue}
		
		//取代码列,描述列,别名列
		s CodeValue=$p($g(^CT("CITAREA",rowid)),"^",1)
		s DescValue=$p($g(^CT("CITAREA",rowid)),"^",2)
		s AliasValue=""
		if ((argDTO.DicAliasCol '="")&&(argDTO.DicAliasCol'=$C(0)))
		{ 
			s id=0
			for {
				s id=$o(^User.BDPAliasI("DataRef","CT_CityArea",rowid,id))
				q:(id="")
				s obj=##class(User.BDPAlias).%OpenId(id)
				q:(obj="")
				s AliasValue=AliasValue_obj.DataAlias_$c(2)
			}
		}
		
		
		//是否满足默认查询条件
		//
		//^CT("PROV",0,"Code",$$ALPHAUP({PROV_Code}),{PROV_RowId})  SQLUser.CT_Province
		s CTCITCityDR = ""
		s CTCITCityDR=$p($g(^CT("CITAREA",rowid)),"^",3)
		//s CityCode=$p($g(^CT("CIT",CTCITCityDR)),"^",1)
		//q:CityCode="" //mod by xuefl17.2.15,global中的数据和表里的数据和索引数据不一致
		if CTCITCityDR="" { continue}  //add by xuefl17.2.15,global中的数据和表里的数据和索引数据不一致
		if CTCITCityDR'="" {s CityCode=$p($g(^CT("CIT",CTCITCityDR)),"^",1)}
		if CityCode="" { continue}
		
		i (CityCode'="")&&(argDTO.Condition'="")&&(argDTO.Condition'=$c(0)) continue:(CityCode'=argDTO.Condition)
		
		//是否满足查询条件
		s CodeCom=0, DescCom=0, AliasCom=0
		if (argDTO.SearchValue '= "")
		{	
			
			s CodeCom= ##Class(EMR.DOC.COM.CheckTool).CheckContain($ZCVT(CodeValue,"U"),$ZCVT(argDTO.SearchValue,"U"),argDTO.HasGB)
			S DescCom= ##Class(EMR.DOC.COM.CheckTool).CheckContain($ZCVT(DescValue,"U"),$ZCVT(argDTO.SearchValue,"U"),argDTO.HasGB)
			if ((argDTO.DicAliasCol '="")&&(argDTO.DicAliasCol'=$C(0)))
			{	s AliasCom= ##Class(EMR.DOC.COM.CheckTool).CheckContain($ZCVT(AliasValue,"U"),$ZCVT(argDTO.SearchValue,"U"),argDTO.HasGB)}
			
			if ((CodeCom '= 1)&&(DescCom '= 1)&&(AliasCom '= 1))
			{	continue}
		}
		
		//处理满足条件的结果并存入临时global
		s totRowCount = totRowCount + 1
		if (argDTO.IsKeepMinus = "0")
		{	s DescValue = $E(DescValue,$F(DescValue,"-"),$L(DescValue)) }
		s:((totRowCount >= argDTO.MinCount)&&(totRowCount <= argDTO.MaxCount)) ^CacheTempStdQuery(argDTO.CookieID,totRowCount) =$LB(rowid,AliasValue,CodeValue,DescValue)
	}
	
	s ^CacheTempStdQuery(argDTO.CookieID,"StdQueryDataCount")= totRowCount
	
	q totRowCount
}

/// Create:	2013-04-25	flc
/// Desc:	查询 科室诊断字典和标准字典 内容：User.DHCMRDiagnosICD  SQLUser.MRC_ICDDx
/// Input：	argDTO.SearchValue 查询条件；argDTO.DicAliasCol 别名列；argDTO.DicCodeCol 代码列；argDTO.DicDescCol 描述列；
///         
ClassMethod SelectStdDic008(argDTO As EMR.DOC.DTO.StdDicParameter) As %Integer
{
	//结果行总数
	s totRowCount = 0	
	s DiaStr=""
	//开始查询默认科室字典
	s rowid = 0
	for {
		s rowid=$o(^DHCDIAICD(rowid))
		q:(rowid = "")
		continue:(rowid="MASTER")
		s MRDid=$p(^DHCDIAICD(rowid),"^",2)
		continue:(MRDid = "")
		s CTrowid=$p(^DHCDIAMAS(MRDid),"^",3)
		continue:(CTrowid = "")
		continue:(CTrowid'=argDTO.Condition)
	
		s DCrowid=$p(^DHCDIAICD(rowid),"^",3)
		continue:(DCrowid = "")
		//取代码列,描述列,别名列
		s CodeValue=$p($g(^MRC("ID",DCrowid)),"^",4)		
		s DescValue=$p($g(^MRC("ID",DCrowid)),"^",2)		
		//取别名列
		s AliasValue=""
		if ((argDTO.DicAliasCol '="")&&(argDTO.DicAliasCol'=$C(0)))
		{ 
			s aliasRowid=0
		  	for {
		  		s aliasRowid=$o(^MRC("ID",DCrowid,"ALIAS",aliasRowid))
				q:(aliasRowid="")
				s AliasValue=AliasValue_$p($g(^MRC("ID",DCrowid,"ALIAS",aliasRowid)),"^",1)_$c(2)
		    }
		}
		
		//是否满足查询条件
		s CodeCom=0, DescCom=0, AliasCom=0
		if (argDTO.SearchValue '= "")
		{	
			s CodeCom= ##Class(EMR.DOC.COM.CheckTool).CheckContain($ZCVT(CodeValue,"U"),$ZCVT(argDTO.SearchValue,"U"),argDTO.HasGB)
			S DescCom= ##Class(EMR.DOC.COM.CheckTool).CheckContain($ZCVT(DescValue,"U"),$ZCVT(argDTO.SearchValue,"U"),argDTO.HasGB)
			if ((argDTO.DicAliasCol '="")&&(argDTO.DicAliasCol'=$C(0)))
			{	s AliasCom= ##Class(EMR.DOC.COM.CheckTool).CheckContain($ZCVT(AliasValue,"U"),$ZCVT(argDTO.SearchValue,"U"),argDTO.HasGB)}
			
			if ((CodeCom '= 1)&&(DescCom '= 1)&&(AliasCom '= 1))
			{	continue}
		}
		
		s totRowCount = totRowCount + 1
		s AliasValue = $P(AliasValue,$C(2),1)
		if (argDTO.IsKeepMinus = "0")
		{	s DescValue = $E(DescValue,$F(DescValue,"-"),$L(DescValue)) }	
		s DiaStr=DiaStr_"^"_CodeValue
		s ^CacheTempStdQueryDiag(argDTO.CookieID)=DiaStr	
		s:((totRowCount >= argDTO.MinCount)&&(totRowCount <= argDTO.MaxCount)) ^CacheTempStdQuery(argDTO.CookieID,totRowCount) =$LB(rowid,AliasValue,CodeValue,DescValue)
		
	  } 	 
	  
	   //开始查询标志字典
	   s rowid = 0
	   for {  
		s rowid=$o(^MRC("ID",rowid))
		quit:(rowid = "")
				
		//get and  validate date of the ICD item.  gjb 2007-12-25
		s dateFrom="",dateTo="",currentDate=""
		s dateFrom=$p($g(^MRC("ID",rowid)),"^",6)
		s dateTo=$p($g(^MRC("ID",rowid)),"^",7)
		s currentDate=$p($h,",",1)
		if (((dateFrom'="")&&(currentDate<dateFrom))||((dateTo'="")&&(currentDate'<dateTo)))
		{	continue}
		
		//取代码列
		if $zcvt(argDTO.DicCodeCol,"U")="MRCID_ROWID"
		{	
			//诊断字典代码列使用rowid，用在病案首页，方便传rowid给医政组做编目
			s CodeValue = rowid	
		}
		else
		{	s CodeValue=$p($g(^MRC("ID",rowid)),"^",4)	}
		
		//取描述列
		s DescValue=""
		if ($zcvt(argDTO.DicDescCol,"U")="MRCID_LONGDESCRIPTION")
		{	s DescValue=$p($g(^MRC("ID",rowid)),"^",36)}		//for 上海华山
		else
		{	s DescValue=$p($g(^MRC("ID",rowid)),"^",2)}
		
		//取代码列附加信息
		//s ICD9Map=" /"_$p($g(^MRC("ID",rowid)),"^",35)  //Comment and updated by Wangwt 2008-06-27
		s ICD9Map=""
		s ICD9MapRowDR=""
		s ICD9MapRowDR=##Class(EMR.DOC.BL.SysOption).GetOptionValueByName("ICDCodeExpand",argDTO.ProductCode)
		if ICD9MapRowDR="Y"
		{
			s ICD9Map=" /"_$p($g(^MRC("ID",rowid)),"^",35) ;The Fourth Node is Parameter Value	
		}
		s CodeValue=CodeValue_ICD9Map
		
		//取别名列
		s AliasValue=""
		if ((argDTO.DicAliasCol '="")&&(argDTO.DicAliasCol'=$C(0)))
		{ 
			s aliasRowid=0
		  	for {
		  		s aliasRowid=$o(^MRC("ID",rowid,"ALIAS",aliasRowid))
				q:(aliasRowid="")
				s AliasValue=AliasValue_$p($g(^MRC("ID",rowid,"ALIAS",aliasRowid)),"^",1)_$c(2)
		    }
		}
		
		//是否满足查询条件
		s CodeCom=0, DescCom=0, AliasCom=0
		if (argDTO.SearchValue '= "")
		{	
			s CodeCom= ##Class(EMR.DOC.COM.CheckTool).CheckContain($ZCVT(CodeValue,"U"),$ZCVT(argDTO.SearchValue,"U"),argDTO.HasGB)
			S DescCom= ##Class(EMR.DOC.COM.CheckTool).CheckContain($ZCVT(DescValue,"U"),$ZCVT(argDTO.SearchValue,"U"),argDTO.HasGB)
			if ((argDTO.DicAliasCol '="")&&(argDTO.DicAliasCol'=$C(0)))
			{	s AliasCom= ##Class(EMR.DOC.COM.CheckTool).CheckContain($ZCVT(AliasValue,"U"),$ZCVT(argDTO.SearchValue,"U"),argDTO.HasGB)}
			
			if ((CodeCom '= 1)&&(DescCom '= 1)&&(AliasCom '= 1))
			{	continue}
		}
		
		//处理满足条件的结果并存入临时global
		s totRowCount = totRowCount + 1
		s AliasValue = $P(AliasValue,$C(2),1)
		if (argDTO.IsKeepMinus = "0")
		{	s DescValue = $E(DescValue,$F(DescValue,"-"),$L(DescValue)) }		
		continue:(DiaStr[CodeValue)
		s:((totRowCount >= argDTO.MinCount)&&(totRowCount <= argDTO.MaxCount)) ^CacheTempStdQuery(argDTO.CookieID,totRowCount) =$LB(rowid,AliasValue,CodeValue,DescValue)
	    } 	
	
	s ^CacheTempStdQuery(argDTO.CookieID,"StdQueryDataCount")= totRowCount
	k ^CacheTempStdQueryDiag(argDTO.CookieID)
	q totRowCount
}

/// Create:	2016-06-16	HouJian
/// Desc:	查询患者所在病区的床位信息， 内容：SQLUser.PAC_Ward
/// Input：	argDTO.SearchValue 查询条件；argDTO.DicAliasCol 别名列；argDTO.DicCodeCol 代码列；argDTO.DicDescCol 描述列；
ClassMethod SelectStdDic009(argDTO As EMR.DOC.DTO.StdDicParameter) As %Integer
{
	//结果行总数
	s totRowCount = 0
	
	if (argDTO.Condition = "")||(argDTO.Condition = $c(0))
	{
		s ^CacheTempStdQuery(argDTO.CookieID,"StdQueryDataCount")= totRowCount
		k ^CacheTempStdQueryDiag(argDTO.CookieID)
		q totRowCount
	}
		
	s pacWardID = argDTO.Condition
	
	//开始查询床号信息
	s childsub = ""
	for {
		s childsub = $o(^PAWARD(pacWardID,"BED",childsub))
		q:(childsub = "")
		
		s dateFrom="",dateTo="",currentDate=""
		s dateFrom=$p($g(^PAWARD(pacWardID,"BED",childsub)),"^",21)
		s dateTo=$p($g(^PAWARD(pacWardID,"BED",childsub)),"^",22)
		s currentDate=$p($h,",",1)
		if (((dateFrom'="")&&(currentDate<dateFrom))||((dateTo'="")&&(currentDate'<dateTo)))
		{	continue}
		
		
		s rowid = pacWardID_"||"_childsub
		
		//取代码列,描述列,别名列
		s CodeValue=$p($g(^PAWARD(pacWardID,"BED",childsub)),"^",1)		
		s DescValue=$p($g(^PAWARD(pacWardID,"BED",childsub)),"^",1)		
		s AliasValue=""
		
		
		//是否满足查询条件
		s CodeCom=0, DescCom=0, AliasCom=0
		if (argDTO.SearchValue '= "")
		{	
			s CodeCom= ##Class(EMR.DOC.COM.CheckTool).CheckContain($ZCVT(CodeValue,"U"),$ZCVT(argDTO.SearchValue,"U"),argDTO.HasGB)
			S DescCom= ##Class(EMR.DOC.COM.CheckTool).CheckContain($ZCVT(DescValue,"U"),$ZCVT(argDTO.SearchValue,"U"),argDTO.HasGB)
			if ((argDTO.DicAliasCol '="")&&(argDTO.DicAliasCol'=$C(0)))
			{	s AliasCom= ##Class(EMR.DOC.COM.CheckTool).CheckContain($ZCVT(AliasValue,"U"),$ZCVT(argDTO.SearchValue,"U"),argDTO.HasGB)}
			
			if ((CodeCom '= 1)&&(DescCom '= 1)&&(AliasCom '= 1))
			{	continue}
		}
		
		s totRowCount = totRowCount + 1
		if (argDTO.IsKeepMinus = "0")
		{	s DescValue = $E(DescValue,$F(DescValue,"-"),$L(DescValue)) }	
		
		s:((totRowCount >= argDTO.MinCount)&&(totRowCount <= argDTO.MaxCount)) ^CacheTempStdQuery(argDTO.CookieID,totRowCount) =$LB(rowid,AliasValue,CodeValue,DescValue)
	  }
	  
	q totRowCount
}

/// Create:	2016-11-23	Donglulu
/// Desc:	查询 [HIS]职称字典（关联医护人员表） 内容：SQLUser.CT_CarPrvTp
/// Input：	argDTO.SearchValue 查询条件；argDTO.DicAliasCol 别名列；argDTO.DicCodeCol 代码列；argDTO.DicDescCol 描述列；ADescHasMinius 描述列是否有横线
/// Debug:  w ##Class(EMR.DOC.BL.StdDictionary).SelectStdDic010("","","CTCPT_Code","CTCPT_Desc","1",1,"","")
ClassMethod SelectStdDic010(argDTO As EMR.DOC.DTO.StdDicParameter) As %Integer
{
	
	//结果行总数
	s totRowCount = 0
	
	//开始查询
	s rowid = 0
	for {
		s rowid=$o(^CT("CPT",rowid))
		quit:(rowid = "")
		
		//取代码列,描述列,别名列
		s CodeValue=$p($g(^CT("CPT",rowid)),"^",1)
		s DescValue=$p($g(^CT("CPT",rowid)),"^",2)
		s AliasValue=""
		
		
		//是否满足默认查询条件
		if ((argDTO.Condition'="")&&(argDTO.Condition'=$c(0)))
		{
			s CTCareProvRowid = $o(^CTPCP(0,"Code",argDTO.Condition,""))
			q:(CTCareProvRowid = "")
			s CTPCPCarPrvTpDR = ""
			s CTPCPCarPrvTpDR=$p($g(^CTPCP(CTCareProvRowid,1)),"^",4)
			continue:(rowid '= CTPCPCarPrvTpDR)
		}
		
		//是否满足查询条件
		s CodeCom=0, DescCom=0, AliasCom=0
		if (argDTO.SearchValue '= "")
		{	
			
			s CodeCom= ##Class(EMR.DOC.COM.CheckTool).CheckContain($ZCVT(CodeValue,"U"),$ZCVT(argDTO.SearchValue,"U"),argDTO.HasGB)
			S DescCom= ##Class(EMR.DOC.COM.CheckTool).CheckContain($ZCVT(DescValue,"U"),$ZCVT(argDTO.SearchValue,"U"),argDTO.HasGB)
			if ((argDTO.DicAliasCol '="")&&(argDTO.DicAliasCol'=$C(0)))
			{	s AliasCom= ##Class(EMR.DOC.COM.CheckTool).CheckContain($ZCVT(AliasValue,"U"),$ZCVT(argDTO.SearchValue,"U"),argDTO.HasGB)}
			
			if ((CodeCom '= 1)&&(DescCom '= 1)&&(AliasCom '= 1))
			{	continue}
		}
		
		//处理满足条件的结果并存入临时global
		s totRowCount = totRowCount + 1
		if (argDTO.IsKeepMinus = "0")
		{	s DescValue = $E(DescValue,$F(DescValue,"-"),$L(DescValue)) }
		s:((totRowCount >= argDTO.MinCount)&&(totRowCount <= argDTO.MaxCount)) ^CacheTempStdQuery(argDTO.CookieID,totRowCount) =$LB(rowid,AliasValue,CodeValue,DescValue)
	}
	
	s ^CacheTempStdQuery(argDTO.CookieID,"StdQueryDataCount")= totRowCount
	
	q totRowCount
}

/// Create:	2016-11-24	Donglulu
/// Desc:	查询【病室】字典内容【关联科室】：SQLUser.PAC_Ward
/// Input：	argDTO.SearchValue 查询条件；argDTO.DicAliasCol 别名列；argDTO.DicCodeCol 代码列；argDTO.DicDescCol 描述列；ADescHasMinius 描述列是否有横线
ClassMethod SelectStdDic011(argDTO As EMR.DOC.DTO.StdDicParameter) As %Integer
{
	
	//结果行总数
	s totRowCount = 0
	
	if ((argDTO.Condition'="")&&(argDTO.Condition'=$c(0)))
	{
		s argDTO.Condition = $o(^CTLOC(0,"Code",argDTO.Condition,""))
	}
			
	//开始查询
	s rowid = 0
	for {
		s rowid=$o(^PAWARD(rowid))
		quit:(rowid = "")
		
		//取代码列,描述列,别名列
		if ($zcvt(argDTO.DicCodeCol,"U") = "WARD_CODE")
		{	s CodeValue=$p($g(^PAWARD(rowid)),"^",1)}
		elseif ($zcvt(argDTO.DicCodeCol,"U") = "WARD_ROWID")
		{	s CodeValue = rowid }
		s DescValue=$p($g(^PAWARD(rowid)),"^",2)
		s AliasValue=""
		
		s WARDLocationDR=$p($g(^PAWARD(rowid)),"^",5)
		
		//是否满足默认查询条件
		if ((argDTO.Condition'="")&&(argDTO.Condition'=$c(0)))
		{
			s linkid = ""
			if (WARDLocationDR '= "")
			{
				s linkid = $o(^CTLOC(argDTO.Condition,"LINK",0,"Loc",WARDLocationDR,""))
			}
			continue:(linkid = "")
		}	
		
		
		//是否满足查询条件
		s CodeCom=0, DescCom=0, AliasCom=0
		if (argDTO.SearchValue '= "")
		{	
			
			s CodeCom= ##Class(EMR.DOC.COM.CheckTool).CheckContain($ZCVT(CodeValue,"U"),$ZCVT(argDTO.SearchValue,"U"),argDTO.HasGB)
			S DescCom= ##Class(EMR.DOC.COM.CheckTool).CheckContain($ZCVT(DescValue,"U"),$ZCVT(argDTO.SearchValue,"U"),argDTO.HasGB)
			if ((argDTO.DicAliasCol '="")&&(argDTO.DicAliasCol'=$C(0)))
			{	s AliasCom= ##Class(EMR.DOC.COM.CheckTool).CheckContain($ZCVT(AliasValue,"U"),$ZCVT(argDTO.SearchValue,"U"),argDTO.HasGB)}
			
			if ((CodeCom '= 1)&&(DescCom '= 1)&&(AliasCom '= 1))
			{	continue}
		}
		
		//处理满足条件的结果并存入临时global
		s totRowCount = totRowCount + 1
		if (argDTO.IsKeepMinus = "0")
		{	s DescValue = $E(DescValue,$F(DescValue,"-"),$L(DescValue)) }
		s:((totRowCount >= argDTO.MinCount)&&(totRowCount <= argDTO.MaxCount)) ^CacheTempStdQuery(argDTO.CookieID,totRowCount) =$LB(rowid,AliasValue,CodeValue,DescValue)
	}
	
	s ^CacheTempStdQuery(argDTO.CookieID,"StdQueryDataCount")= totRowCount
	
	q totRowCount
}

/// Create:	2016-11-24	Donglulu
/// Desc:	查询 [EMR]手术级别字典【关联手术字典】 内容：ORC_OperationCategory
/// Input：	argDTO.SearchValue 查询条件；argDTO.DicAliasCol 别名列；argDTO.DicCodeCol 代码列；argDTO.DicDescCol 描述列；ADescHasMinius 描述列是否有横线
ClassMethod SelectStdDic012(argDTO As EMR.DOC.DTO.StdDicParameter) As %Integer
{
	
	//结果行总数
	s totRowCount = 0
	
	s id = ""
	s ADefaultConditionId = ""
	if ((argDTO.Condition'="")&&(argDTO.Condition'=$c(0)))
	{
		for {
			s id = $o(^ORC("OPER",id))
			quit:(id = "")
			if ($p(^ORC("OPER",id),"^",1) = argDTO.Condition )
			{
				s ADefaultConditionId = id
				quit
			}
		}
	}
	s OPERDefaultCategoryDR = ""
	if (ADefaultConditionId'="")
	{
		s OPERDefaultCategoryDR = $p($g(^ORC("OPER",ADefaultConditionId)),"^",7)
	}

	
	//开始查询
	s rowid = 0
	for {
		s rowid=$o(^ORC("CATEG",(rowid)))
		quit:(rowid = "")
		
		//取代码列,描述列,别名列 ^ORC("CATEG",1)	=	"1^1^64203^^
		s CodeValue=$P(^ORC("CATEG",rowid),"^",1)
		s DescValue=$P(^ORC("CATEG",rowid),"^",2)  //$lg(^DHCEMRM.CustomDictionaryD(rowid),2)
		s AliasValue="" 
		
		//是否满足默认查询条件
		if ((argDTO.Condition'="")&&(argDTO.Condition'=$c(0)))
		{
			continue:(OPERDefaultCategoryDR '= rowid)
		}
		
		//是否满足查询条件
		s CodeCom=0, DescCom=0, AliasCom=0
		if (argDTO.SearchValue '= "")
		{	
			
			s CodeCom= ##Class(EMR.DOC.COM.CheckTool).CheckContain($ZCVT(CodeValue,"U"),$ZCVT(argDTO.SearchValue,"U"),argDTO.HasGB)
			S DescCom= ##Class(EMR.DOC.COM.CheckTool).CheckContain($ZCVT(DescValue,"U"),$ZCVT(argDTO.SearchValue,"U"),argDTO.HasGB)
			if ((argDTO.DicAliasCol '="")&&(argDTO.DicAliasCol'=$C(0)))
			{	s AliasCom= ##Class(EMR.DOC.COM.CheckTool).CheckContain($ZCVT(AliasValue,"U"),$ZCVT(argDTO.SearchValue,"U"),argDTO.HasGB)}
			
			if ((CodeCom '= 1)&&(DescCom '= 1)&&(AliasCom '= 1))
			{	continue}
		}
		
		//处理满足条件的结果并存入临时global
		s totRowCount = totRowCount + 1
		if (argDTO.IsKeepMinus = "0")
		{	s DescValue = $E(DescValue,$F(DescValue,"-"),$L(DescValue)) }
		s:((totRowCount >= argDTO.MinCount)&&(totRowCount <= argDTO.MaxCount)) ^CacheTempStdQuery(argDTO.CookieID,totRowCount) =$LB(rowid,AliasValue,CodeValue,DescValue)
	}
	
	s ^CacheTempStdQuery(argDTO.CookieID,"StdQueryDataCount")= totRowCount
	
	q totRowCount
}

/// Create:	2017-09-19	 [HIS]默认本科室医生字典
/// Desc:	查询【用户】字典内容：SQLUser.SS_User  
/// Input：	argDTO.SearchValue 查询条件；argDTO.DicAliasCol 别名列；argDTO.DicCodeCol 代码列；argDTO.DicDescCol 描述列；ADescHasMinius 描述列是否有横线
ClassMethod SelectStdDic014(argDTO As EMR.DOC.DTO.StdDicParameter) As %Integer
{
	//结果行总数
	s totRowCount = 0
	//开始查询
	s rowid = 0
	for {
		s rowid=$o(^SSU("SSUSR",rowid))
		quit:(rowid = "")
		
		//取代码列,描述列,别名列
		if ($zcvt(argDTO.DicCodeCol,"U") = "SSUSR_INITIALS")
		{s CodeValue=$p($g(^SSU("SSUSR",rowid)),"^",1)}
		s DescValue=$p($g(^SSU("SSUSR",rowid)),"^",2)
		s AliasValue=$p($g(^SSU("SSUSR",rowid)),"^",11)
		

		//是否满足默认查询条件
		//^RB("RES",0,"CTPCP",{RES_CTPCP_DR},{RES_CTLOC_DR},{RES_RowId})  SQLUser.RB_Resource
		s (SSUSRCareProvDR,RESRowId) = ""
		s SSUSRCareProvDR = $p($g(^SSU("SSUSR",rowid)),"^",14)
		continue:(SSUSRCareProvDR="")
		//本科室
		s RESRowId=$o(^RB("RES",0,"CTPCP",SSUSRCareProvDR,argDTO.Condition,""))
		continue:(RESRowId="")
		//判断是否是医生
		s provobj = ##class(User.CTCareProv).%OpenId(SSUSRCareProvDR)
		continue:(provobj="")
		continue:($zcvt(provobj.CTPCPCarPrvTpDR.CTCPTInternalType,"U") '= "DOCTOR")
		
		//是否满足查询条件
		s CodeCom=0, DescCom=0, AliasCom=0
		if (argDTO.SearchValue '= "")
		{	
			
			s CodeCom= ##Class(EMR.DOC.COM.CheckTool).CheckContain($ZCVT(CodeValue,"U"),$ZCVT(argDTO.SearchValue,"U"),argDTO.HasGB)
			S DescCom= ##Class(EMR.DOC.COM.CheckTool).CheckContain($ZCVT(DescValue,"U"),$ZCVT(argDTO.SearchValue,"U"),argDTO.HasGB)
			if ((argDTO.DicAliasCol '="")&&(argDTO.DicAliasCol'=$C(0)))
			{	s AliasCom= ##Class(EMR.DOC.COM.CheckTool).CheckContain($ZCVT(AliasValue,"U"),$ZCVT(argDTO.SearchValue,"U"),argDTO.HasGB)}
			
			if ((CodeCom '= 1)&&(DescCom '= 1)&&(AliasCom '= 1))
			{	continue}
		}
		
		//处理满足条件的结果并存入临时global
		s totRowCount = totRowCount + 1
		if (argDTO.IsKeepMinus = "0")
		{	s DescValue = $E(DescValue,$F(DescValue,"-"),$L(DescValue)) }
		s:((totRowCount >= argDTO.MinCount)&&(totRowCount <= argDTO.MaxCount)) ^CacheTempStdQuery(argDTO.CookieID,totRowCount) =$LB(rowid,AliasValue,CodeValue,DescValue)
	}
	
	s ^CacheTempStdQuery(argDTO.CookieID,"StdQueryDataCount")= totRowCount
	
	q totRowCount
}

/// Create:	2017-09-19 [HIS]默认本科室护士字典
/// Desc:	查询【用户】字典内容：SQLUser.SS_User  
/// Input：	argDTO.SearchValue 查询条件；argDTO.DicAliasCol 别名列；argDTO.DicCodeCol 代码列；argDTO.DicDescCol 描述列；ADescHasMinius 描述列是否有横线
ClassMethod SelectStdDic015(argDTO As EMR.DOC.DTO.StdDicParameter) As %Integer
{
	//结果行总数
	s totRowCount = 0
	
	//获取默认登录科室link的病房
	s LinkCtlocDr = ""
	for {
		//^CTLOC({CT_Loc.CTLOC_RowID},"LINK",0,"Loc",{LINK_CTLOC_DR},{LINK_Childsub}
		s LinkCtlocDr = $o(^CTLOC(argDTO.Condition,"LINK",0,"Loc",LinkCtlocDr))
		q:(LinkCtlocDr = "")
		
		//开始查询
		s rowid = 0
		for {
			s rowid=$o(^SSU("SSUSR",rowid))
			quit:(rowid = "")
			
			//取代码列,描述列,别名列
			if ($zcvt(argDTO.DicCodeCol,"U") = "SSUSR_INITIALS")
			{s CodeValue=$p($g(^SSU("SSUSR",rowid)),"^",1)}
			s DescValue=$p($g(^SSU("SSUSR",rowid)),"^",2)
			s AliasValue=$p($g(^SSU("SSUSR",rowid)),"^",11)
			
			s (SSUSRCareProvDR,RESRowId) = ""
			s SSUSRCareProvDR = $p($g(^SSU("SSUSR",rowid)),"^",14)
			continue:(SSUSRCareProvDR="")
			
			//是否满足默认科室查询条件
			//^RB("RES",0,"CTPCP",{RES_CTPCP_DR},{RES_CTLOC_DR},{RES_RowId})  SQLUser.RB_Resource
			s RESRowId=$o(^RB("RES",0,"CTPCP",SSUSRCareProvDR,LinkCtlocDr,""))
			continue:(RESRowId="")
			//判断是否是护士
			s provobj = ##class(User.CTCareProv).%OpenId(SSUSRCareProvDR)
			continue:(provobj="")
			continue:($zcvt(provobj.CTPCPCarPrvTpDR.CTCPTInternalType,"U") '= "NURSE")
			
			//是否满足查询条件
			s CodeCom=0, DescCom=0, AliasCom=0
			if (argDTO.SearchValue '= "")
			{	
				
				s CodeCom= ##Class(EMR.DOC.COM.CheckTool).CheckContain($ZCVT(CodeValue,"U"),$ZCVT(argDTO.SearchValue,"U"),argDTO.HasGB)
				S DescCom= ##Class(EMR.DOC.COM.CheckTool).CheckContain($ZCVT(DescValue,"U"),$ZCVT(argDTO.SearchValue,"U"),argDTO.HasGB)
				if ((argDTO.DicAliasCol '="")&&(argDTO.DicAliasCol'=$C(0)))
				{	s AliasCom= ##Class(EMR.DOC.COM.CheckTool).CheckContain($ZCVT(AliasValue,"U"),$ZCVT(argDTO.SearchValue,"U"),argDTO.HasGB)}
				
				if ((CodeCom '= 1)&&(DescCom '= 1)&&(AliasCom '= 1))
				{	continue}
			}
			
			//处理满足条件的结果并存入临时global
			s totRowCount = totRowCount + 1
			if (argDTO.IsKeepMinus = "0")
			{	s DescValue = $E(DescValue,$F(DescValue,"-"),$L(DescValue)) }
			s:((totRowCount >= argDTO.MinCount)&&(totRowCount <= argDTO.MaxCount)) ^CacheTempStdQuery(argDTO.CookieID,totRowCount) =$LB(rowid,AliasValue,CodeValue,DescValue)
		}
	}
	
	s ^CacheTempStdQuery(argDTO.CookieID,"StdQueryDataCount")= totRowCount
	
	q totRowCount
}

/// Create:	2019-5-6 yejian [HIS]默认手术室员工字典(包括外院手术医生)
/// Desc:	查询【用户】字典内容：SQLUser.SS_User  
/// Input：	argDTO.SearchValue 查询条件；argDTO.DicAliasCol 别名列；argDTO.DicCodeCol 代码列；argDTO.DicDescCol 描述列；ADescHasMinius 描述列是否有横线
ClassMethod SelectStdDic060(argDTO As EMR.DOC.DTO.StdDicParameter) As %Integer
{
	
	//结果行总数
	s totRowCount = 0
	
	//开始查询
	s rowid = 0
	for {
		s rowid=$o(^SSU("SSUSR",rowid))
		quit:(rowid = "")
		
		//取代码列,描述列,别名列
		if ($zcvt(argDTO.DicCodeCol,"U") = "SSUSR_INITIALS")
		{s CodeValue=$p($g(^SSU("SSUSR",rowid)),"^",1)}
		s DescValue=$p($g(^SSU("SSUSR",rowid)),"^",2)
		s AliasValue=$p($g(^SSU("SSUSR",rowid)),"^",11)
		
		//是否满足查询条件
		s CodeCom=0, DescCom=0, AliasCom=0
		if (argDTO.SearchValue '= "")
		{	
			
			s CodeCom= ##Class(EMR.DOC.COM.CheckTool).CheckContain($ZCVT(CodeValue,"U"),$ZCVT(argDTO.SearchValue,"U"),argDTO.HasGB)
			S DescCom= ##Class(EMR.DOC.COM.CheckTool).CheckContain($ZCVT(DescValue,"U"),$ZCVT(argDTO.SearchValue,"U"),argDTO.HasGB)
			if ((argDTO.DicAliasCol '="")&&(argDTO.DicAliasCol'=$C(0)))
			{	s AliasCom= ##Class(EMR.DOC.COM.CheckTool).CheckContain($ZCVT(AliasValue,"U"),$ZCVT(argDTO.SearchValue,"U"),argDTO.HasGB)}
			
			if ((CodeCom '= 1)&&(DescCom '= 1)&&(AliasCom '= 1))
			{	continue}
		}
		
		//处理满足条件的结果并存入临时global
		s totRowCount = totRowCount + 1
		if (argDTO.IsKeepMinus = "0")
		{	s DescValue = $E(DescValue,$F(DescValue,"-"),$L(DescValue)) }
		s:((totRowCount >= argDTO.MinCount)&&(totRowCount <= argDTO.MaxCount)) ^CacheTempStdQuery(argDTO.CookieID,totRowCount) =$LB(rowid,AliasValue,CodeValue,DescValue)
	}
	s oDoctor = ##Class(web.UDHCANOPArrange).FindOtherCtcp(argDTO.Condition,"","Y")
	s oDocCount = oDoctor.Count()
	for i=1:1:oDocCount
	{
		S odoc = oDoctor.GetAt(i)
		s rowid = $p(odoc,"^",1)
		s AliasValue=$p(odoc,"^",3)
		s CodeValue=$p(odoc,"^",1)
		s DescValue =$p(odoc,"^",2)
		//处理满足条件的结果并存入临时global
		s totRowCount = totRowCount + 1
		if (argDTO.IsKeepMinus = "0")
		{	s DescValue = $E(DescValue,$F(DescValue,"-"),$L(DescValue)) }
		s:((totRowCount >= argDTO.MinCount)&&(totRowCount <= argDTO.MaxCount)) ^CacheTempStdQuery(argDTO.CookieID,totRowCount) =$LB(rowid,AliasValue,CodeValue,DescValue)

	}
	s ^CacheTempStdQuery(argDTO.CookieID,"StdQueryDataCount")= totRowCount
	
	q totRowCount
}

/// Create:	2020-2-17	Donglulu
/// Desc:	查询对应医院【科室】字典内容：SQLUser.CT_Loc，筛选条件hospitalID
/// Input：	argDTO.SearchValue 查询条件；argDTO.DicAliasCol 别名列；argDTO.DicCodeCol 代码列；argDTO.DicDescCol 描述列；ADescHasMinius 描述列是否有横线
ClassMethod SelectStdDic016(argDTO As EMR.DOC.DTO.StdDicParameter) As %Integer
{
	//结果行总数
	s totRowCount = 0
	
	//开始查询
	s rowid = 0
	for {
		s rowid=$o(^CTLOC(rowid))
		quit:(rowid = "")
		s dataactiveto = $p($g(^CTLOC(rowid)),"^",25)
		continue:((dataactiveto '= "")&&(dataactiveto < $p($h,",",1)))
		
		s locHospitalId = $p($g(^CTLOC(rowid)),"^",22)
		continue:((argDTO.Condition '= "")&&(argDTO.Condition '= locHospitalId))
		
		//过滤病区数据
		s wardFlag = $p($g(^CTLOC(rowid)),"^",5)
		continue:(wardFlag="Y")
		
		//取代码列,描述列,别名列
		if ($zcvt(argDTO.DicCodeCol,"U") = "CTLOC_CODE")
		{	s CodeValue=$p($g(^CTLOC(rowid)),"^",1)}
		elseif ($zcvt(argDTO.DicCodeCol,"U") = "CTLOC_ROWID")
		{	s CodeValue=rowid}
		
		s DescValue=$p($g(^CTLOC(rowid)),"^",2)
		
		s AliasValue=""
		if ($zcvt(argDTO.DicAliasCol,"U") = "CTLOC_CONTACTNAME")
		{	s AliasValue = $p($g(^CTLOC(rowid)),"^",43)}
		
		//是否满足查询条件
		s CodeCom=0, DescCom=0, AliasCom=0
		if (argDTO.SearchValue '= "")
		{	
			
			s CodeCom= ##Class(EMR.DOC.COM.CheckTool).CheckContain($ZCVT(CodeValue,"U"),$ZCVT(argDTO.SearchValue,"U"),argDTO.HasGB)
			S DescCom= ##Class(EMR.DOC.COM.CheckTool).CheckContain($ZCVT(DescValue,"U"),$ZCVT(argDTO.SearchValue,"U"),argDTO.HasGB)
			if ((argDTO.DicAliasCol '="")&&(argDTO.DicAliasCol'=$C(0)))
			{	s AliasCom= ##Class(EMR.DOC.COM.CheckTool).CheckContain($ZCVT(AliasValue,"U"),$ZCVT(argDTO.SearchValue,"U"),argDTO.HasGB)}
			
			if ((CodeCom '= 1)&&(DescCom '= 1)&&(AliasCom '= 1))
			{	continue}
		}
		
		//处理满足条件的结果并存入临时global
		s totRowCount = totRowCount + 1
		if (argDTO.IsKeepMinus = "0")
		{	s DescValue = $E(DescValue,$F(DescValue,"-"),$L(DescValue)) }
		//科室字典因前端应用情况（查询、浏览中科室数据）及HIS中基础数据的数据量，所以修改为不做min max控制
		//s:((totRowCount >= argDTO.MinCount)&&(totRowCount <= argDTO.MaxCount)) ^CacheTempStdQuery(argDTO.CookieID,totRowCount) =$LB(rowid,AliasValue,CodeValue,DescValue)
		s ^CacheTempStdQuery(argDTO.CookieID,totRowCount) =$LB(rowid,AliasValue,CodeValue,DescValue)
	
	}
	
	s ^CacheTempStdQuery(argDTO.CookieID,"StdQueryDataCount")= totRowCount
	
	q totRowCount
}

/// Create:	2020-2-17	Donglulu
/// Desc:	查询对应医院【病室】字典内容：SQLUser.PAC_Ward，筛选条件hospitalID
/// Input：	argDTO.SearchValue 查询条件；argDTO.DicAliasCol 别名列；argDTO.DicCodeCol 代码列；argDTO.DicDescCol 描述列；ADescHasMinius 描述列是否有横线
ClassMethod SelectStdDic017(argDTO As EMR.DOC.DTO.StdDicParameter) As %Integer
{
	//结果行总数
	s totRowCount = 0
	
	//开始查询
	s rowid = 0
	for {
		s rowid=$o(^PAWARD(rowid))
		quit:(rowid = "")
		
		s locid = $p($g(^PAWARD(rowid)),"^",5)
		continue:(locid = "")
		s locHospitalId = $p($g(^CTLOC(locid)),"^",22)
		continue:((argDTO.Condition '= "")&&(argDTO.Condition '= locHospitalId))
		
		//取代码列,描述列,别名列
		if ($zcvt(argDTO.DicCodeCol,"U") = "WARD_CODE")
		{	s CodeValue=$p($g(^PAWARD(rowid)),"^",1)}
		elseif ($zcvt(argDTO.DicCodeCol,"U") = "WARD_ROWID")
		{	s CodeValue = rowid }
		s DescValue=$p($g(^PAWARD(rowid)),"^",2)
		//病区描述 把描述列转换为简拼
		s AliasValue=##class(EMR.DOC.COM.CodeTool).GetCNCODE(DescValue,4,"")
		
		//是否满足查询条件
		s CodeCom=0, DescCom=0, AliasCom=0
		if (argDTO.SearchValue '= "")
		{	
			
			s CodeCom= ##Class(EMR.DOC.COM.CheckTool).CheckContain($ZCVT(CodeValue,"U"),$ZCVT(argDTO.SearchValue,"U"),argDTO.HasGB)
			S DescCom= ##Class(EMR.DOC.COM.CheckTool).CheckContain($ZCVT(DescValue,"U"),$ZCVT(argDTO.SearchValue,"U"),argDTO.HasGB)
			if ((argDTO.DicAliasCol '="")&&(argDTO.DicAliasCol'=$C(0)))
			{	s AliasCom= ##Class(EMR.DOC.COM.CheckTool).CheckContain($ZCVT(AliasValue,"U"),$ZCVT(argDTO.SearchValue,"U"),argDTO.HasGB)}
			
			if ((CodeCom '= 1)&&(DescCom '= 1)&&(AliasCom '= 1))
			{	continue}
		}
		
		//处理满足条件的结果并存入临时global
		s totRowCount = totRowCount + 1
		if (argDTO.IsKeepMinus = "0")
		{	s DescValue = $E(DescValue,$F(DescValue,"-"),$L(DescValue)) }
		s:((totRowCount >= argDTO.MinCount)&&(totRowCount <= argDTO.MaxCount)) ^CacheTempStdQuery(argDTO.CookieID,totRowCount) =$LB(rowid,AliasValue,CodeValue,DescValue)
	}
	
	s ^CacheTempStdQuery(argDTO.CookieID,"StdQueryDataCount")= totRowCount
	
	q totRowCount
}

/// Create:	2020-2-17	Donglulu
/// Desc:	查询对应医院【医护人员】字典内容：SQLUser.CT_CareProv，筛选条件hospitalID
/// Input：	argDTO.SearchValue 查询条件；argDTO.DicAliasCol 别名列；argDTO.DicCodeCol 代码列；argDTO.DicDescCol 描述列；ADescHasMinius 描述列是否有横线
ClassMethod SelectStdDic018(argDTO As EMR.DOC.DTO.StdDicParameter) As %Integer
{
	//结果行总数
	s totRowCount = 0
	
	//开始查询
	s rowid = 0
	for {
		s rowid=$o(^CTPCP(rowid))
		quit:(rowid = "")
		
		if (argDTO.Condition '= "")
		{
			continue:(($d(^CTPCP(rowid,"HOSP",0,"Hosp")) > 0)&&($o(^CTPCP(rowid,"HOSP",0,"Hosp",argDTO.Condition,"")) = ""))
		}
		
		//取代码列,描述列,别名列
		if ($zcvt(argDTO.DicCodeCol,"U") = "CTPCP_CODE")
		{	s CodeValue=$p($g(^CTPCP(rowid,1)),"^",1)}
		elseif ($zcvt(argDTO.DicCodeCol,"U") = "CTPCP_ROWID")
		{	s CodeValue = rowid }
		s DescValue=$p($g(^CTPCP(rowid,1)),"^",2)
		s AliasValue=""
		
		//是否满足查询条件
		s CodeCom=0, DescCom=0, AliasCom=0
		if (argDTO.SearchValue '= "")
		{	
			
			s CodeCom= ##Class(EMR.DOC.COM.CheckTool).CheckContain($ZCVT(CodeValue,"U"),$ZCVT(argDTO.SearchValue,"U"),argDTO.HasGB)
			S DescCom= ##Class(EMR.DOC.COM.CheckTool).CheckContain($ZCVT(DescValue,"U"),$ZCVT(argDTO.SearchValue,"U"),argDTO.HasGB)
			if ((argDTO.DicAliasCol '="")&&(argDTO.DicAliasCol'=$C(0)))
			{	s AliasCom= ##Class(EMR.DOC.COM.CheckTool).CheckContain($ZCVT(AliasValue,"U"),$ZCVT(argDTO.SearchValue,"U"),argDTO.HasGB)}
			
			if ((CodeCom '= 1)&&(DescCom '= 1)&&(AliasCom '= 1))
			{	continue}
		}
		
		//处理满足条件的结果并存入临时global
		s totRowCount = totRowCount + 1
		if (argDTO.IsKeepMinus = "0")
		{	s DescValue = $E(DescValue,$F(DescValue,"-"),$L(DescValue)) }
		s:((totRowCount >= argDTO.MinCount)&&(totRowCount <= argDTO.MaxCount)) ^CacheTempStdQuery(argDTO.CookieID,totRowCount) =$LB(rowid,AliasValue,CodeValue,DescValue)
	}
	
	s ^CacheTempStdQuery(argDTO.CookieID,"StdQueryDataCount")= totRowCount
	
	q totRowCount
}

/// Create:	wangyu
/// Desc:	查询【自费药品】
/// Input：	argDTO.SearchValue 查询条件；argDTO.DicAliasCol 别名列；argDTO.DicCodeCol 代码列；argDTO.DicDescCol 描述列；argDTO.HasGB 查询条件是否有中文字符；argDTO.IsKeepMinus 描述列是否有横线
///  w ##class(EMR.DOC.BL.StdDictionary).SelectStdDic019(1,200,"FuzzyMatch^","ALIAS_Text","MRCZFYP_Code","MRCZFYP_Desc","7903","0","0","3466")
ClassMethod SelectStdDic019(argDTO As EMR.DOC.DTO.StdDicParameter) As %Integer
{
	//结果行总数
	s totRowCount = 0
	s episodeID = argDTO.Condition
	s ds = ##Class(%Library.ResultSet).%New("EMR.DOC.HISInterface.StdDictionary:GetStdDictionaryList")
	d ds.Execute(episodeID)
	While (ds.Next())
	{
		//continue:(ds.Data("INTIMxmmc") = "")
		s CodeValue = ds.Data("INTIMxmmc")
		s DescValue = ds.Data("INTIMxmcode")
		s AliasValue = ##class(EMR.DOC.BL.StdDictionary).HZToPin(DescValue)		
		//是否满足查询条件
		s CodeCom=0, DescCom=0, AliasCom=0
		if (argDTO.SearchValue '= "")
		{	
			s CodeCom= ##Class(EMR.DOC.COM.CheckTool).CheckContain($ZCVT(CodeValue,"U"),$ZCVT(argDTO.SearchValue,"U"),argDTO.HasGB)
			S DescCom= ##Class(EMR.DOC.COM.CheckTool).CheckContain($ZCVT(DescValue,"U"),$ZCVT(argDTO.SearchValue,"U"),argDTO.HasGB)
			if ((argDTO.DicAliasCol '="")&&(argDTO.DicAliasCol'=$C(0)))
			{	s AliasCom= ##Class(EMR.DOC.COM.CheckTool).CheckContain($ZCVT(AliasValue,"U"),$ZCVT(argDTO.SearchValue,"U"),argDTO.HasGB)}			
			if ((CodeCom '= 1)&&(DescCom '= 1)&&(AliasCom '= 1))
			{	continue}
		}		
		//处理满足条件的结果并存入临时global
		s totRowCount = totRowCount + 1
		s AliasValue = $P(AliasValue,$C(2),1)
		if (argDTO.IsKeepMinus = "0")
		{	s DescValue = $E(DescValue,$F(DescValue,"-"),$L(DescValue)) }		
		s:((totRowCount >= argDTO.MinCount)&&(totRowCount <= argDTO.MaxCount)) ^CacheTempStdQuery(argDTO.CookieID,totRowCount) = $LB(rowid,AliasValue,CodeValue,DescValue)
	}	
	s ^CacheTempStdQuery(argDTO.CookieID,"StdQueryDataCount")= totRowCount	
	q totRowCount
}

/// Desc:	处理没有默认查询条件的字典
ClassMethod SelectStdDicWithoutDefaultCond(argDTO As EMR.DOC.DTO.StdDicParameter) As %Integer
{
	s argDTO.SearchValue=argDTO.SearchType_"^"_argDTO.SearchValue
	s ADicTableName = argDTO.DicTableName
	s totRowCount = 0
	
	if ($zcvt(ADicTableName,"U")="SQLUSER.MRC_ICDDX")
	{
		s totRowCount = ..SelectStdDicMRCICDDx(argDTO)
	}
	elseif ($zcvt(ADicTableName,"U")="SQLUSER.MRC_ICDDXZXY")
	{
		s totRowCount = ..SelectStdDicMRCICDDxZXY(argDTO)
	}
	elseif ($zcvt(ADicTableName,"U")="SQLUSER.MRC_ICDDXXY")
	{
		s totRowCount = ..SelectStdDicMRCICDDxXY(argDTO)
	}
	elseif ($zcvt(ADicTableName,"U")="SQLUSER.MRC_ICDDXZY")
	{
	 	s totRowCount = ..SelectStdDicMRCICDDxZY(argDTO)
	}
	elseif ($zcvt(ADicTableName,"U")="SQLUSER.MRC_ICDDXZYZB")
	{
		//中医主病字典表  add by niucaicai 2013-06-06
	 	s totRowCount = ..SelectStdDicMRCICDDxZYZB(argDTO)
	}
	elseif ($zcvt(ADicTableName,"U")="SQLUSER.MRC_ICDDXZYZZ")
	{
		//中医主证字典表  add by niucaicai 2013-06-06
	 	s totRowCount = ..SelectStdDicMRCICDDxZYZZ(argDTO)
	}
	elseif ($zcvt(ADicTableName,"U")="SQLUSER.CT_LOC")
 	{
	 	s totRowCount = ..SelectStdDicCTLoc(argDTO)
	}
	elseif ($zcvt(ADicTableName,"U")="SQLUSER.CT_LOC_DIC")
	{
		s totRowCount = ..SelectStdDicCTLoc(argDTO)
	}
	elseif ($zcvt(ADicTableName,"U")="SQLUSER.CT_NATION")
	{
		s totRowCount = ..SelectStdDicCTNation(argDTO)
	}
	elseif ($zcvt(ADicTableName,"U")="SQLUSER.SS_USER")
	{
		s totRowCount = ..SelectStdDicSSUser(argDTO)
	}
	elseif ($zcvt(ADicTableName,"U")="SQLUSER.PAC_WARD")
	{
		s totRowCount = ..SelectStdDicPACWard(argDTO)
	}
	elseif ($zcvt(ADicTableName,"U")="SQLUSER.PAC_WARD_DIC")
	{
		s totRowCount = ..SelectStdDicPACWard(argDTO)
	}	
	elseif ($zcvt(ADicTableName,"U")="SQLUSER.PHC_DRGMAST")
	{
		s totRowCount = ..SelectStdDicPHCDrgMast(argDTO)
	}
	elseif ($zcvt(ADicTableName,"U")="SQLUSER.CT_OCCUPATION")
	{
	 	s totRowCount = ..SelectStdDicCTOccupation(argDTO)
	}
	elseif ($zcvt(ADicTableName,"U")="SQLUSER.CT_COUNTRY")
	{
		s totRowCount = ..SelectStdDicCTCountry(argDTO)
	}
	elseif ($zcvt(ADicTableName,"U")="SQLUSER.CT_PROVINCE")
	{
		s totRowCount = ..SelectStdDicCTProvince(argDTO)
	}
	elseif ($zcvt(ADicTableName,"U")="SQLUSER.CT_CITY")
	{
		s totRowCount = ..SelectStdDicCTCity(argDTO)
	}
	elseif ($zcvt(ADicTableName,"U")="SQLUSER.CT_SEX")
	{
		s totRowCount = ..SelectStdDicCTSex(argDTO)
	}
	elseif ($zcvt(ADicTableName,"U")="SQLUSER.PAC_PATIENTCATEGORY")
	{
		s totRowCount = ..SelectStdDicPACPatientCategory(argDTO)
	}
	elseif ($zcvt(ADicTableName,"U")="SQLUSER.CT_ZIP")
	{
		s totRowCount = ..SelectStdDicCTZip(argDTO)
	}
	elseif ($zcvt(ADicTableName,"U")="SQLUSER.ORC_OPERATION")
	{
		s totRowCount = ..SelectStdDicORCOperation(argDTO)
	}
	elseif ($zcvt(ADicTableName,"U")="SQLUSER.CT_RELATION")
	{
		s totRowCount = ..SelectStdDicCTReleation(argDTO)
	}
	elseif ($zcvt(ADicTableName,"U")="EMRVIEW.PATTYPE") //$zcvt(ADicTableName,"U")="SQLUSER.DHCEMRVPATTYPE")
	{
		s totRowCount = ..SelectStdDicDHCEMRVPatType(argDTO)
	}
	elseif ($zcvt(ADicTableName,"U")="SQLUSER.ORC_ANAESTMETHOD")
	{
		s totRowCount = ..SelectStdDicORCAnaestMethod(argDTO)
	}
	elseif ($zcvt(ADicTableName,"U")="EMRVIEW.OPERATION")
	{
		s totRowCount = ..SelectStdDicEMRviewOperation(argDTO)
	}
	elseif ($zcvt(ADicTableName,"U")="SQLUSER.MRC_ICDDX_DIAGNOSIS")
	{
		//诊断 groupDR = "1"
		s totRowCount = ..SelectStdDicMRCICDDxDiag(argDTO)
	}
	elseif ($zcvt(ADicTableName,"U")="SQLUSER.MRC_ICDDX_INJURG")
	{
		//损伤 groupDR = "4"
		s totRowCount = ..SelectStdDicMRCICDDxInjury(argDTO)
	}
	elseif ($zcvt(ADicTableName,"U")="SQLUSER.MRC_ICDDX_MORPHOLOGY")
	{
		//肿瘤形态学 groupDR = "2"
		s totRowCount = ..SelectStdDicMRCICDDxMorphology(argDTO)
	}
	elseif ($zcvt(ADicTableName,"U")="SQLUSER.MRC_ICDDX_METASTATIC")
	{
		//肿瘤形态
		s totRowCount = ..SelectStdMRCICDDXMetastatic(argDTO)
	}
	elseif ($zcvt(ADicTableName,"U")="SQLUSER.MRC_ICDDX_OPERATION")
	{
		//手术 groupDR = "3"
		s totRowCount = ..SelectStdDicMRCICDDxOperation(argDTO)
	}
	elseif ($zcvt(ADicTableName,"U")="SQLUSER.MRC_ICDDX_ALLERGY")
	{
		//过敏 groupDR = "5"
		s totRowCount = ..SelectStdDicMRCICDDxAllergy(argDTO)
	}
	elseif ($zcvt(ADicTableName,"U")= "MRC_DIAGNOSSIGNSYMPTOM")||(($zcvt(ADicTableName,"U")= "SQLUSER.MRC_DIAGNOSSIGNSYMPTOM"))
	{
		//中医症型字典
		s totRowCount = ..SelectStdDicDiagnosSignSymptom(argDTO)
	}
	elseif ($zcvt(ADicTableName,"U")="SQLUSER.MRC_ICDDXINJURYPOISON")
	{
		//[HIS]ICD10损伤中毒外部因素字典 2012-02-03 wangwentao add
	 	s totRowCount = ..SelectStdMRCICDDxInjuryPoison(argDTO)
	}
	elseif ($zcvt(ADicTableName,"U")="SQLUSER.MRC_ICDDXPATHOLOGY")
	{
		//[HIS]ICD10病理诊断字典 2012-02-03 wangwentao add
	 	s totRowCount = ..SelectStdMRCICDDxPathology(argDTO)
	}
	elseif ($zcvt(ADicTableName,"U")="SQLUSER.MRC_ICDDXMEDALLERGY")
	{
		//[HIS]ICD10过敏类别字典 2012-02-03 wangwentao add
	 	s totRowCount = ..SelectStdMRCICDDxMedAllergy(argDTO)
	}
	elseif ($zcvt(ADicTableName,"U")="SQLUSER.MRC_ICDDXINPATIENT")
	{
		//[HIS]ICD10住院诊断字典 2012-02-03 wangwentao add
	 	s totRowCount = ..SelectStdMRCICDDxInpatient(argDTO)
	}
	elseif ($zcvt(ADicTableName,"U")="SQLUSER.CT_HEALTHCAREREGION")
	{
		//
		s totRowCount = ..SelectStdDicCTHealthCareRegion(argDTO)
	}
	elseif ($zcvt(ADicTableName,"U")="SQLUSER.DHC_WMR_ICDDX_DIAGNOSIS")
	{
		//医政编目字典诊断 groupDR = "1"
		s totRowCount = ..SelectStdDicWMRICDDxDiag(argDTO)
	}
	elseif ($zcvt(ADicTableName,"U")="SQLUSER.DHC_WMR_ICDDX_MORPHOLOGY")
	{
		//医政编目字典肿瘤形态学 groupDR = "2"
		s totRowCount = ..SelectStdDicWMRICDDxMorphology(argDTO)
	}
	elseif ($zcvt(ADicTableName,"U")="SQLUSER.DHC_WMR_ICDDX_OPERATION")
	{
		//医政编目字典手术 groupDR = "3"
		s totRowCount = ..SelectStdDicWMRICDDxOperation(argDTO)
	}
	elseif ($zcvt(ADicTableName,"U")="SQLUSER.DHC_WMR_ICDDX_INJURG")
	{
		//医政编目字典损伤 groupDR = "4"
		s totRowCount = ..SelectStdDicWMRICDDxInjury(argDTO)
	}
	elseif ($zcvt(ADicTableName,"U")="SQLUSER.DHC_WMR_ICDDX_ALLERGY")
	{
		//医政编目字典过敏 groupDR = "5"
		s totRowCount = ..SelectStdDicWMRICDDxAllergy(argDTO)
	}
	elseif ($zcvt(ADicTableName,"U")="SQLUSER.MRC_ICDDXOP")
	{
		//[HIS]ICD10门诊首页诊断字典
		s totRowCount = ..SelectStdDicMRCICDDxOP(argDTO)
	}
	elseif ($zcvt(ADicTableName,"U")="SQLUSER.ORC_OPERATIONOP")
	{
		//[HIS]ICD10门诊首页手术字典
		s totRowCount = ..SelectStdDicORCOperationOP(argDTO)
	}
	elseif ($zcvt(ADicTableName,"U") = "SQLUSER.CT_MARITAL")
	{
		s totRowCount = ..SelectStdDicCTMarital(argDTO)
	}
	elseif ($zcvt(ADicTableName,"U") = "SQLUSER.PAC_BED")
	{
		s totRowCount = ..SelectStdDicBed(argDTO)
	}
	elseif ($zcvt(ADicTableName,"U") = "SQLUSER.SS_USER_INTERN")
	{
		s totRowCount = ..SelectStdDicSSUserIntern(argDTO)
	}
	elseif($zcvt(ADicTableName,"U") = "SQLUSER.INC_Itm")
	{
		s totRowCount = ..SelectStdDicINCItm(argDTO)
	}
	elseif ($zcvt(ADicTableName,"U") = "SQLUSER.INSU_DICDATA")
	{
		s totRowCount = ..SelectStdDicINSUDicData(argDTO)
	}
	elseif($zcvt(ADicTableName,"U") = "SQLUSER.BDTRANSTYPE")
	{
		s totRowCount = ..SelectStdDicBDTransType(argDTO)
	}
	elseif($zcvt(ADicTableName,"U") = "SQLUSER.BDREQPRODUCT")
	{
		s totRowCount = ..SelectStdDicBDReqProduct(argDTO)
	}
	elseif($zcvt(ADicTableName,"U") = "SQLUSER.BDTRANSPURPOSE")
	{
		s totRowCount = ..SelectStdDicBDTransPurpose(argDTO)
	}
	elseif($zcvt(ADicTableName,"U") = "SQLUSER.BDBLOODGROUP")
	{
		s totRowCount = ..SelectStdDicBDBLOODGROUP(argDTO)
	}
	else
	{
		//处理动态字典
		s totRowCount = ..SelectDynamicStdDic(argDTO)
	}	 
		
 
 	q totRowCount
}

ClassMethod SelectStdDicBed(argDTO As EMR.DOC.DTO.StdDicParameter) As %Integer
{
	//结果行总数
	s totRowCount = 0
	
	
	s pacWardID = "0"
	
	for {
		s pacWardID = $o(^PAWARD(pacWardID))
		q:(pacWardID = "")
		
	//开始查询床号信息
	s childsub = ""
	for {
		s childsub = $o(^PAWARD(pacWardID,"BED",childsub))
		q:(childsub = "")
		
		s dateFrom="",dateTo="",currentDate=""
		s dateFrom=$p($g(^PAWARD(pacWardID,"BED",childsub)),"^",21)
		s dateTo=$p($g(^PAWARD(pacWardID,"BED",childsub)),"^",22)
		s currentDate=$p($h,",",1)
		if (((dateFrom'="")&&(currentDate<dateFrom))||((dateTo'="")&&(currentDate'<dateTo)))
		{	continue}
		
		
		s rowid = pacWardID_"||"_childsub
		
		//取代码列,描述列,别名列
		s CodeValue=$p($g(^PAWARD(pacWardID,"BED",childsub)),"^",1)		
		s DescValue=$p($g(^PAWARD(pacWardID,"BED",childsub)),"^",1)		
		s AliasValue=""
		
		
		//是否满足查询条件
		s CodeCom=0, DescCom=0, AliasCom=0
		if (argDTO.SearchValue '= "")
		{	
			s CodeCom= ##Class(EMR.DOC.COM.CheckTool).CheckContain($ZCVT(CodeValue,"U"),$ZCVT(argDTO.SearchValue,"U"),argDTO.HasGB)
			S DescCom= ##Class(EMR.DOC.COM.CheckTool).CheckContain($ZCVT(DescValue,"U"),$ZCVT(argDTO.SearchValue,"U"),argDTO.HasGB)
			if ((argDTO.DicAliasCol '="")&&(argDTO.DicAliasCol'=$C(0)))
			{	s AliasCom= ##Class(EMR.DOC.COM.CheckTool).CheckContain($ZCVT(AliasValue,"U"),$ZCVT(argDTO.SearchValue,"U"),argDTO.HasGB)}
			
			if ((CodeCom '= 1)&&(DescCom '= 1)&&(AliasCom '= 1))
			{	continue}
		}
		
		s totRowCount = totRowCount + 1
		if (argDTO.IsKeepMinus = "0")
		{	s DescValue = $E(DescValue,$F(DescValue,"-"),$L(DescValue)) }	
		
		s:((totRowCount >= argDTO.MinCount)&&(totRowCount <= argDTO.MaxCount)) ^CacheTempStdQuery(argDTO.CookieID,totRowCount) =$LB(rowid,AliasValue,CodeValue,DescValue)
	  }
	  
	}
	
	q totRowCount
}

/// Create:	2017-4-12	Donglulu
/// Desc:	查询【实习医师，见习医师用户】字典内容：SQLUser.SS_User
/// Input：	argDTO.SearchValue 查询条件；argDTO.DicAliasCol 别名列；argDTO.DicCodeCol 代码列；argDTO.DicDescCol 描述列；ADescHasMinius 描述列是否有横线
ClassMethod SelectStdDicSSUserIntern(argDTO As EMR.DOC.DTO.StdDicParameter) As %Integer
{
	//结果行总数
	s totRowCount = 0
	
	//开始查询
	s rowid = 0
	for {
		s rowid=$o(^SSU("SSUSR",rowid))
		quit:(rowid = "")
		
		//取代码列,描述列,别名列
		if ($zcvt(argDTO.DicCodeCol,"U") = "SSUSR_INITIALS")
		{s CodeValue=$p($g(^SSU("SSUSR",rowid)),"^",1)}
		s DescValue=$p($g(^SSU("SSUSR",rowid)),"^",2)
		s AliasValue=$p($g(^SSU("SSUSR",rowid)),"^",11)
		
		s CTCareProvRowid = $p($g(^SSU("SSUSR",rowid)),"^",14)
		continue:(CTCareProvRowid ="")
		s CTPCPCarPrvTpDR = $p($g(^CTPCP(CTCareProvRowid,1)),"^",4)
		continue:(CTPCPCarPrvTpDR'=1)&&(CTPCPCarPrvTpDR'=19)
		
		//是否满足查询条件
		s CodeCom=0, DescCom=0, AliasCom=0
		if (argDTO.SearchValue '= "")
		{	
			
			s CodeCom= ##Class(EMR.DOC.COM.CheckTool).CheckContain($ZCVT(CodeValue,"U"),$ZCVT(argDTO.SearchValue,"U"),argDTO.HasGB)
			S DescCom= ##Class(EMR.DOC.COM.CheckTool).CheckContain($ZCVT(DescValue,"U"),$ZCVT(argDTO.SearchValue,"U"),argDTO.HasGB)
			if ((argDTO.DicAliasCol '="")&&(argDTO.DicAliasCol'=$C(0)))
			{	s AliasCom= ##Class(EMR.DOC.COM.CheckTool).CheckContain($ZCVT(AliasValue,"U"),$ZCVT(argDTO.SearchValue,"U"),argDTO.HasGB)}
			
			if ((CodeCom '= 1)&&(DescCom '= 1)&&(AliasCom '= 1))
			{	continue}
		}
		
		//处理满足条件的结果并存入临时global
		s totRowCount = totRowCount + 1
		if (argDTO.IsKeepMinus = "0")
		{	s DescValue = $E(DescValue,$F(DescValue,"-"),$L(DescValue)) }
		s:((totRowCount >= argDTO.MinCount)&&(totRowCount <= argDTO.MaxCount)) ^CacheTempStdQuery(argDTO.CookieID,totRowCount) =$LB(rowid,AliasValue,CodeValue,DescValue)
	}
	
	s ^CacheTempStdQuery(argDTO.CookieID,"StdQueryDataCount")= totRowCount
	
	q totRowCount
}

/// Create:	2008-11-27	HouJ
/// Desc:	查询【诊断】字典内容：SQLUser.MRC_ICDDx
/// Input：	argDTO.SearchValue 查询条件；argDTO.DicAliasCol 别名列；argDTO.DicCodeCol 代码列；argDTO.DicDescCol 描述列；argDTO.HasGB 查询条件是否有中文字符；argDTO.IsKeepMinus 描述列是否有横线
ClassMethod SelectStdDicMRCICDDx(argDTO As EMR.DOC.DTO.StdDicParameter) As %Integer
{
	
	//结果行总数
	s totRowCount = 0
	
	//开始查询
	s rowid = 0
	for {
		s rowid=$o(^MRC("ID",rowid))
		quit:(rowid = "")
				
		//get and  validate date of the ICD item.  gjb 2007-12-25
		s dateFrom="",dateTo="",currentDate=""
		s dateFrom=$p($g(^MRC("ID",rowid)),"^",6)
		s dateTo=$p($g(^MRC("ID",rowid)),"^",7)
		s currentDate=$p($h,",",1)
		if (((dateFrom'="")&&(currentDate<dateFrom))||((dateTo'="")&&(currentDate'<dateTo)))
		{	continue}
		
		//20120426 wangwentao add
		//校验ICD10,过滤门诊诊断 
		s flagCode = $p($g(^MRC("ID",rowid)),"^",4)
		continue:(flagCode="")||($e(flagCode,1,2) = "MZ")
		
		//20130523 wangwentao add
		//校验ICD10,北京门诊首页过滤门诊诊断
		//MRCID_MorphologyCode {"Y":门诊诊断,"N":住院诊断,"":通用诊断}
		s flagCode = $p($g(^MRC("ID",rowid)),"^",38)
		s HospitalName=##class(EMR.DOC.BL.SysOption).GetOptionValueByName("HospitalName",argDTO.ProductCode)
	 	if HospitalName = "BeiJingFXYY" 
	 	{
			continue:($zcvt(flagCode,"U")="N")
		}
		else
		{
			continue:($zcvt(flagCode,"U")="Y")
		}
		
		//取代码列
		if $zcvt(argDTO.DicCodeCol,"U")="MRCID_ROWID"
		{	
			//诊断字典代码列使用rowid，用在病案首页，方便传rowid给医政组做编目
			s CodeValue = rowid	
		}
		else
		{	s CodeValue=$p($g(^MRC("ID",rowid)),"^",4)	}
		
		//取描述列
		s DescValue=""
		if ($zcvt(argDTO.DicDescCol,"U")="MRCID_LONGDESCRIPTION")
		{	s DescValue=$p($g(^MRC("ID",rowid)),"^",36)}		//for 上海华山
		else
		{	s DescValue=$p($g(^MRC("ID",rowid)),"^",2)}
		
		//取代码列附加信息
		//s ICD9Map=" /"_$p($g(^MRC("ID",rowid)),"^",35)  //Comment and updated by Wangwt 2008-06-27
		s ICD9Map=""
		s ICD9MapRowDR=""
		s ICD9MapRowDR=##Class(EMR.DOC.BL.SysOption).GetOptionValueByName("ICDCodeExpand",argDTO.ProductCode)
		if ICD9MapRowDR="Y"
		{
			s ICD9Map=" /"_$p($g(^MRC("ID",rowid)),"^",35) ;The Fourth Node is Parameter Value	
		}
		s CodeValue=CodeValue_ICD9Map
		
		//取别名列
		s AliasValue=""
		if ((argDTO.DicAliasCol '="")&&(argDTO.DicAliasCol'=$C(0)))
		{ 			
			s aliasRowid=0
			for {
				s aliasRowid=$o(^MRC("ID",rowid,"ALIAS",aliasRowid))
				q:(aliasRowid="")
				s AliasValue=AliasValue_$p($g(^MRC("ID",rowid,"ALIAS",aliasRowid)),"^",1)_$c(2)
			}
		}
		
		//是否满足查询条件
		s CodeCom=0, DescCom=0, AliasCom=0, AliasText=0
		if (argDTO.SearchValue '= "")
		{	
			s CodeCom= ##Class(EMR.DOC.COM.CheckTool).CheckContain($ZCVT(CodeValue,"U"),$ZCVT(argDTO.SearchValue,"U"),argDTO.HasGB)
			S DescCom= ##Class(EMR.DOC.COM.CheckTool).CheckContain($ZCVT(DescValue,"U"),$ZCVT(argDTO.SearchValue,"U"),argDTO.HasGB)
			if ((argDTO.DicAliasCol '="")&&(argDTO.DicAliasCol'=$C(0)))
			{	s AliasCom= ##Class(EMR.DOC.COM.CheckTool).CheckContain($ZCVT(AliasValue,"U"),$ZCVT(argDTO.SearchValue,"U"),argDTO.HasGB)}
			if ((CodeCom '= 1)&&(DescCom '= 1)&&(AliasCom '= 1)&&(AliasText '= 1))
			{	continue}
		}
		
		if ((argDTO.DicAliasCol '="")&&(argDTO.DicAliasCol'=$C(0)))
		{ 
			if HospitalName = "GuangZhouNXRM"
			{
				//获取有效的诊断分值-广东南雄人民项目，别名列显示是否有有效的诊断分值
				s AliasValue="否"
				s sicRowid=0
				for {
					s sicRowid=$o(^SICDCi(0,"ICDDR",rowid,sicRowid))
					q:(sicRowid="")
					s sicScoreDR = $p($g(^SICDC(sicRowid)),"^",1)
					q:(sicScoreDR="")
					s dissStartDate=$p($g(^DISS(sicScoreDR)),"^",3)
					s dissEndDate=$p($g(^DISS(sicScoreDR)),"^",4)
					if (((dissStartDate'="")&&(currentDate<dissStartDate))||((dissEndDate'="")&&(currentDate'<dissEndDate))){
						continue
					}
					s dissDiagmethDR=$p($g(^DISS(sicScoreDR)),"^",2)
					q:(dissDiagmethDR="")
					s diagmethStartDate=$p($g(^DIAGMETH(dissDiagmethDR)),"^",3)
					s diagmethEndDate=$p($g(^DIAGMETH(dissDiagmethDR)),"^",4)
					if (((diagmethStartDate'="")&&(currentDate<diagmethStartDate))||((diagmethEndDate'="")&&(currentDate'<diagmethEndDate))){
						continue
					}
					s AliasValue="是"
					q:(AliasValue="是")
				}	
			}
		}
		
		//处理满足条件的结果并存入临时global
		s totRowCount = totRowCount + 1
		s AliasValue = $P(AliasValue,$C(2),1)
		s:(argDTO.IsKeepMinus = "0") DescValue = $E(DescValue,$F(DescValue,"-"),$L(DescValue))
		
		s:((totRowCount >= argDTO.MinCount)&&(totRowCount <= argDTO.MaxCount)) ^CacheTempStdQuery(argDTO.CookieID,totRowCount) = $LB(rowid,AliasValue,CodeValue,DescValue)
	}
	
	s ^CacheTempStdQuery(argDTO.CookieID,"StdQueryDataCount")= totRowCount
	
	q totRowCount
}

/// Desc:	查询【中西医诊断】字典内容：SQLUser.MRC_ICDDxZXY
///         过滤掉损伤中毒、病理诊断
/// Create:	2018-6-22	
/// Creator: Candy
/// Input：	argDTO.SearchValue 查询条件；argDTO.DicAliasCol 别名列；argDTO.DicCodeCol 代码列；argDTO.DicDescCol 描述列；argDTO.HasGB 查询条件是否有中文字符；argDTO.IsKeepMinus 描述列是否有横线
ClassMethod SelectStdDicMRCICDDxZXY(argDTO As EMR.DOC.DTO.StdDicParameter) As %Integer
{
	
	//结果行总数
	s totRowCount = 0
	
	//开始查询
	s rowid = 0
	for {
		s rowid=$o(^MRC("ID",rowid))
		quit:(rowid = "")
				
		//get and  validate date of the ICD item.  gjb 2007-12-25
		s dateFrom="",dateTo="",currentDate=""
		s dateFrom=$p($g(^MRC("ID",rowid)),"^",6)
		s dateTo=$p($g(^MRC("ID",rowid)),"^",7)
		s currentDate=$p($h,",",1)
		continue:(((dateFrom'="")&&(currentDate<dateFrom))||((dateTo'="")&&(currentDate'<dateTo)))
		
		//20120426 wangwentao add
		//校验ICD10,过滤门诊诊断 
		s flagCode = $p($g(^MRC("ID",rowid)),"^",4)
		continue:(flagCode="")||($e(flagCode,1,2) = "MZ")
		
		//筛选病理
		s flag = $p($g(^MRC("ID",rowid)),"^",40)
		continue:($zcvt(flag,"U") ="Y")
		
		//筛选损伤中毒
		s flag = $p($g(^MRC("ID",rowid)),"^",41)
		continue:($zcvt(flag,"U") ="Y")		

		
		//20130523 wangwentao add
		//校验ICD10,北京门诊首页过滤门诊诊断
		//MRCID_MorphologyCode {"Y":门诊诊断,"N":住院诊断,"":通用诊断}
		s flagCode = $p($g(^MRC("ID",rowid)),"^",38)
		s HospitalName=##class(EMR.DOC.BL.SysOption).GetOptionValueByName("HospitalName",argDTO.ProductCode)
	 	if HospitalName = "BeiJingFXYY" 
	 	{
			continue:($zcvt(flagCode,"U")="N")
		}
		else
		{
			continue:($zcvt(flagCode,"U")="Y")
		}
		
		//取代码列
		if $zcvt(argDTO.DicCodeCol,"U")="MRCID_ROWID"
		{	
			//诊断字典代码列使用rowid，用在病案首页，方便传rowid给医政组做编目
			s CodeValue = rowid	
		}
		else
		{	
			s CodeValue=$p($g(^MRC("ID",rowid)),"^",4)	
		}
		
		//取描述列
		s DescValue=""
		if ($zcvt(argDTO.DicDescCol,"U")="MRCID_LONGDESCRIPTION")
		{	
			s DescValue=$p($g(^MRC("ID",rowid)),"^",36)
		}		//for 上海华山
		else
		{	
			s DescValue=$p($g(^MRC("ID",rowid)),"^",2)
		}
		
		//取代码列附加信息
		//s ICD9Map=" /"_$p($g(^MRC("ID",rowid)),"^",35)  //Comment and updated by Wangwt 2008-06-27
		s ICD9Map=""
		s ICD9MapRowDR=""
		s ICD9MapRowDR=##Class(EMR.DOC.BL.SysOption).GetOptionValueByName("ICDCodeExpand",argDTO.ProductCode)
		if ICD9MapRowDR="Y"
		{
			s ICD9Map=" /"_$p($g(^MRC("ID",rowid)),"^",35) ;The Fourth Node is Parameter Value	
		}
		s CodeValue=CodeValue_ICD9Map
		
		//取别名列
		s AliasValue=""
		if ((argDTO.DicAliasCol '="")&&(argDTO.DicAliasCol'=$C(0)))
		{ 
			s aliasRowid=0
		  	for {
		  		s aliasRowid=$o(^MRC("ID",rowid,"ALIAS",aliasRowid))
				q:(aliasRowid="")
				s AliasValue=AliasValue_$p($g(^MRC("ID",rowid,"ALIAS",aliasRowid)),"^",1)_$c(2)
		    }
		}
		
		//是否满足查询条件
		s CodeCom=0, DescCom=0, AliasCom=0
		if (argDTO.SearchValue '= "")
		{	
			s CodeCom= ##Class(EMR.DOC.COM.CheckTool).CheckContain($ZCVT(CodeValue,"U"),$ZCVT(argDTO.SearchValue,"U"),argDTO.HasGB)
			S DescCom= ##Class(EMR.DOC.COM.CheckTool).CheckContain($ZCVT(DescValue,"U"),$ZCVT(argDTO.SearchValue,"U"),argDTO.HasGB)
			if ((argDTO.DicAliasCol '="")&&(argDTO.DicAliasCol'=$C(0)))
			{	s AliasCom= ##Class(EMR.DOC.COM.CheckTool).CheckContain($ZCVT(AliasValue,"U"),$ZCVT(argDTO.SearchValue,"U"),argDTO.HasGB)}
			
			if ((CodeCom '= 1)&&(DescCom '= 1)&&(AliasCom '= 1))
			{	continue}
		}
		
		//处理满足条件的结果并存入临时global
		s totRowCount = totRowCount + 1
		s AliasValue = $P(AliasValue,$C(2),1)
		s:(argDTO.IsKeepMinus = "0") DescValue = $E(DescValue,$F(DescValue,"-"),$L(DescValue))
		
		s:((totRowCount >= argDTO.MinCount)&&(totRowCount <= argDTO.MaxCount)) ^CacheTempStdQuery(argDTO.CookieID,totRowCount) = $LB(rowid,AliasValue,CodeValue,DescValue)
	}
	
	s ^CacheTempStdQuery(argDTO.CookieID,"StdQueryDataCount")= totRowCount
	
	q totRowCount
}

/// Create:	2012-04-24	HouJ
/// Desc:	查询【诊断】字典内容：SQLUser.MRC_ICDDxXY 西医诊断
/// Input：	argDTO.SearchValue 查询条件；argDTO.DicAliasCol 别名列；argDTO.DicCodeCol 代码列；argDTO.DicDescCol 描述列；argDTO.HasGB 查询条件是否有中文字符；argDTO.IsKeepMinus 描述列是否有横线
ClassMethod SelectStdDicMRCICDDxXY(argDTO As EMR.DOC.DTO.StdDicParameter) As %Integer
{
	//结果行总数
	s totRowCount = 0
	
	//开始查询
	s rowid = 0
	for {
		s rowid=$o(^MRC("ID",rowid))
		quit:(rowid = "")
				
		//get and  validate date of the ICD item.  gjb 2007-12-25
		s dateFrom="",dateTo="",currentDate=""
		s dateFrom=$p($g(^MRC("ID",rowid)),"^",6)
		s dateTo=$p($g(^MRC("ID",rowid)),"^",7)
		s currentDate=$p($h,",",1)
		if (((dateFrom'="")&&(currentDate<dateFrom))||((dateTo'="")&&(currentDate'<dateTo)))
		{	continue}
		
		//筛选校验中医标志
		s zyFlag = $p($g(^MRC("ID",rowid)),"^",15)
		s zyFlag = $zcvt(zyFlag,"U")
		continue:($e(zyFlag,1,1)="Y")
		
		//筛选代码为空的西医诊断
		continue:($p($g(^MRC("ID",rowid)),"^",4)="")
		
		//筛选病理
		s flag = $p($g(^MRC("ID",rowid)),"^",40)
		continue:($zcvt(flag,"U") ="Y")
		
		//筛选损伤中毒
		s flag = $p($g(^MRC("ID",rowid)),"^",41)
		continue:($zcvt(flag,"U") ="Y")		
		
		//取代码列
		if $zcvt(argDTO.DicCodeCol,"U")="MRCID_ROWID"
		{	
			//诊断字典代码列使用rowid，用在病案首页，方便传rowid给医政组做编目
			s CodeValue = rowid	
		}
		else
		{	s CodeValue=$p($g(^MRC("ID",rowid)),"^",4)	}
		
		//取描述列
		s DescValue=""
		if ($zcvt(argDTO.DicDescCol,"U")="MRCID_LONGDESCRIPTION")
		{	s DescValue=$p($g(^MRC("ID",rowid)),"^",36)}		//for 上海华山
		else
		{	s DescValue=$p($g(^MRC("ID",rowid)),"^",2)}
		
		//取代码列附加信息
		//s ICD9Map=" /"_$p($g(^MRC("ID",rowid)),"^",35)  //Comment and updated by Wangwt 2008-06-27
		s ICD9Map=""
		s ICD9MapRowDR=""
		s ICD9MapRowDR=##Class(EMR.DOC.BL.SysOption).GetOptionValueByName("ICDCodeExpand",argDTO.ProductCode)
		if ICD9MapRowDR="Y"
		{
			s ICD9Map=" /"_$p($g(^MRC("ID",rowid)),"^",35) ;The Fourth Node is Parameter Value	
		}
		s CodeValue=CodeValue_ICD9Map
		
		//取别名列
		s AliasValue=""
		if ((argDTO.DicAliasCol '="")&&(argDTO.DicAliasCol'=$C(0)))
		{ 
			s aliasRowid=0
		  	for {
		  		s aliasRowid=$o(^MRC("ID",rowid,"ALIAS",aliasRowid))
				q:(aliasRowid="")
				s AliasValue=AliasValue_$p($g(^MRC("ID",rowid,"ALIAS",aliasRowid)),"^",1)_$c(2)
		    }
		}
		
		//是否满足查询条件
		s CodeCom=0, DescCom=0, AliasCom=0
		if (argDTO.SearchValue '= "")
		{	
			s CodeCom= ##Class(EMR.DOC.COM.CheckTool).CheckContain($ZCVT(CodeValue,"U"),$ZCVT(argDTO.SearchValue,"U"),argDTO.HasGB)
			S DescCom= ##Class(EMR.DOC.COM.CheckTool).CheckContain($ZCVT(DescValue,"U"),$ZCVT(argDTO.SearchValue,"U"),argDTO.HasGB)
			if ((argDTO.DicAliasCol '="")&&(argDTO.DicAliasCol'=$C(0)))
			{	s AliasCom= ##Class(EMR.DOC.COM.CheckTool).CheckContain($ZCVT(AliasValue,"U"),$ZCVT(argDTO.SearchValue,"U"),argDTO.HasGB)}
			
			if ((CodeCom '= 1)&&(DescCom '= 1)&&(AliasCom '= 1))
			{	continue}
		}
		
		//处理满足条件的结果并存入临时global
		s totRowCount = totRowCount + 1
		s AliasValue = $P(AliasValue,$C(2),1)
		if (argDTO.IsKeepMinus = "0")
		{	s DescValue = $E(DescValue,$F(DescValue,"-"),$L(DescValue)) }
		
		s:((totRowCount >= argDTO.MinCount)&&(totRowCount <= argDTO.MaxCount)) ^CacheTempStdQuery(argDTO.CookieID,totRowCount) = $LB(rowid,AliasValue,CodeValue,DescValue)
	}
	
	s ^CacheTempStdQuery(argDTO.CookieID,"StdQueryDataCount")= totRowCount
	
	q totRowCount
}

/// Create:	2008-11-27	HouJ
/// Desc:	查询【诊断】字典内容：SQLUser.MRC_ICDDx
/// Input：	argDTO.SearchValue 查询条件；argDTO.DicAliasCol 别名列；argDTO.DicCodeCol 代码列；argDTO.DicDescCol 描述列；argDTO.HasGB 查询条件是否有中文字符；argDTO.IsKeepMinus 描述列是否有横线
ClassMethod SelectStdDicMRCICDDxZY(argDTO As EMR.DOC.DTO.StdDicParameter) As %Integer
{
	//结果行总数
	s totRowCount = 0
	
	//开始查询
	s rowid = 0
	for {
		s rowid=$o(^MRC("ID",rowid))
		quit:(rowid = "")
				
		//get and  validate date of the ICD item.  gjb 2007-12-25
		s dateFrom="",dateTo="",currentDate=""
		s dateFrom=$p($g(^MRC("ID",rowid)),"^",6)
		s dateTo=$p($g(^MRC("ID",rowid)),"^",7)
		s currentDate=$p($h,",",1)
		if (((dateFrom'="")&&(currentDate<dateFrom))||((dateTo'="")&&(currentDate'<dateTo)))
		{	continue}
		
		//校验中医标志
		s zyFlag = $p($g(^MRC("ID",rowid)),"^",15)
		s zyFlag = $zcvt(zyFlag,"U")
		continue:($e(zyFlag,1,1)'="Y")
		
		//取代码列
		if $zcvt(argDTO.DicCodeCol,"U")="MRCID_ROWID"
		{	
			//诊断字典代码列使用rowid，用在病案首页，方便传rowid给医政组做编目
			s CodeValue = rowid	
		}
		else
		{	s CodeValue=$p($g(^MRC("ID",rowid)),"^",4)	}
		
		//取描述列
		s DescValue=""
		if ($zcvt(argDTO.DicDescCol,"U")="MRCID_LONGDESCRIPTION")
		{	s DescValue=$p($g(^MRC("ID",rowid)),"^",36)}		//for 上海华山
		else
		{	s DescValue=$p($g(^MRC("ID",rowid)),"^",2)}
		
		//取代码列附加信息
		//s ICD9Map=" /"_$p($g(^MRC("ID",rowid)),"^",35)  //Comment and updated by Wangwt 2008-06-27
		s ICD9Map=""
		s ICD9MapRowDR=""
		s ICD9MapRowDR=##Class(EMR.DOC.BL.SysOption).GetOptionValueByName("ICDCodeExpand",argDTO.ProductCode)
		if ICD9MapRowDR="Y"
		{
			s ICD9Map=" /"_$p($g(^MRC("ID",rowid)),"^",35) ;The Fourth Node is Parameter Value	
		}
		s CodeValue=CodeValue_ICD9Map
		
		//取别名列
		s AliasValue=""
		if ((argDTO.DicAliasCol '="")&&(argDTO.DicAliasCol'=$C(0)))
		{ 
			s aliasRowid=0
		  	for {
		  		s aliasRowid=$o(^MRC("ID",rowid,"ALIAS",aliasRowid))
				q:(aliasRowid="")
				s AliasValue=AliasValue_$p($g(^MRC("ID",rowid,"ALIAS",aliasRowid)),"^",1)_$c(2)
		    }
		}
		
		//是否满足查询条件
		s CodeCom=0, DescCom=0, AliasCom=0
		if (argDTO.SearchValue '= "")
		{	
			s CodeCom= ##Class(EMR.DOC.COM.CheckTool).CheckContain($ZCVT(CodeValue,"U"),$ZCVT(argDTO.SearchValue,"U"),argDTO.HasGB)
			S DescCom= ##Class(EMR.DOC.COM.CheckTool).CheckContain($ZCVT(DescValue,"U"),$ZCVT(argDTO.SearchValue,"U"),argDTO.HasGB)
			if ((argDTO.DicAliasCol '="")&&(argDTO.DicAliasCol'=$C(0)))
			{	s AliasCom= ##Class(EMR.DOC.COM.CheckTool).CheckContain($ZCVT(AliasValue,"U"),$ZCVT(argDTO.SearchValue,"U"),argDTO.HasGB)}
			
			if ((CodeCom '= 1)&&(DescCom '= 1)&&(AliasCom '= 1))
			{	continue}
		}
		
		//处理满足条件的结果并存入临时global
		s totRowCount = totRowCount + 1
		s AliasValue = $P(AliasValue,$C(2),1)
		if (argDTO.IsKeepMinus = "0")
		{	s DescValue = $E(DescValue,$F(DescValue,"-"),$L(DescValue)) }
		
		s:((totRowCount >= argDTO.MinCount)&&(totRowCount <= argDTO.MaxCount)) ^CacheTempStdQuery(argDTO.CookieID,totRowCount) =$LB(rowid,AliasValue,CodeValue,DescValue)
	}
	
	s ^CacheTempStdQuery(argDTO.CookieID,"StdQueryDataCount")= totRowCount
	
	q totRowCount
}

/// Create:	2013-06-06	niucaicai
/// Desc:	查询【中医主病】字典内容：SQLUSER.MRC_ICDDXZYZB  只查询中医诊断，并且ICD码是“B”开头的
/// Input：	argDTO.SearchValue 查询条件；argDTO.DicAliasCol 别名列；argDTO.DicCodeCol 代码列；argDTO.DicDescCol 描述列；argDTO.HasGB 查询条件是否有中文字符；argDTO.IsKeepMinus 描述列是否有横线
ClassMethod SelectStdDicMRCICDDxZYZB(argDTO As EMR.DOC.DTO.StdDicParameter) As %Integer
{
	//结果行总数
	s totRowCount = 0
	
	//开始查询
	s rowid = 0
	for {
		s rowid=$o(^MRC("ID",rowid))
		quit:(rowid = "")
				
		s dateFrom="",dateTo="",currentDate=""
		s dateFrom=$p($g(^MRC("ID",rowid)),"^",6)
		s dateTo=$p($g(^MRC("ID",rowid)),"^",7)
		s currentDate=$p($h,",",1)
		if (((dateFrom'="")&&(currentDate<dateFrom))||((dateTo'="")&&(currentDate'<dateTo)))
		{	continue}
		
		//校验中医标志
		s zyFlag = $p($g(^MRC("ID",rowid)),"^",15)
		s zyFlag = $zcvt(zyFlag,"U")
		//校验ICD码是否为B开头
		s isBstartFlag = $e($p($g(^MRC("ID",rowid)),"^",4),1,1)
		s isBstartFlag = $zcvt(isBstartFlag,"U")
		continue:($e(zyFlag,1,1)'="Y")||(isBstartFlag'="B")
		
		//取代码列
		if $zcvt(argDTO.DicCodeCol,"U")="MRCID_ROWID"
		{	
			//诊断字典代码列使用rowid，用在病案首页，方便传rowid给医政组做编目
			s CodeValue = rowid	
		}
		else
		{	s CodeValue=$p($g(^MRC("ID",rowid)),"^",4)	}
		
		//取描述列
		s DescValue=""
		if ($zcvt(argDTO.DicDescCol,"U")="MRCID_LONGDESCRIPTION")
		{	s DescValue=$p($g(^MRC("ID",rowid)),"^",36)}		//for 上海华山
		else
		{	s DescValue=$p($g(^MRC("ID",rowid)),"^",2)}
		
		//取代码列附加信息
		//s ICD9Map=" /"_$p($g(^MRC("ID",rowid)),"^",35)  //Comment and updated by Wangwt 2008-06-27
		s ICD9Map=""
		s ICD9MapRowDR=""
		s ICD9MapRowDR=##Class(EMR.DOC.BL.SysOption).GetOptionValueByName("ICDCodeExpand",argDTO.ProductCode)
		if ICD9MapRowDR="Y"
		{
			s ICD9Map=" /"_$p($g(^MRC("ID",rowid)),"^",35) ;The Fourth Node is Parameter Value	
		}
		s CodeValue=CodeValue_ICD9Map
		
		//取别名列
		s AliasValue=""
		if ((argDTO.DicAliasCol '="")&&(argDTO.DicAliasCol'=$C(0)))
		{ 
			s aliasRowid=0
		  	for {
		  		s aliasRowid=$o(^MRC("ID",rowid,"ALIAS",aliasRowid))
				q:(aliasRowid="")
				s AliasValue=AliasValue_$p($g(^MRC("ID",rowid,"ALIAS",aliasRowid)),"^",1)_$c(2)
		    }
		}
		
		//是否满足查询条件
		s CodeCom=0, DescCom=0, AliasCom=0
		if (argDTO.SearchValue '= "")
		{	
			s CodeCom= ##Class(EMR.DOC.COM.CheckTool).CheckContain($ZCVT(CodeValue,"U"),$ZCVT(argDTO.SearchValue,"U"),argDTO.HasGB)
			S DescCom= ##Class(EMR.DOC.COM.CheckTool).CheckContain($ZCVT(DescValue,"U"),$ZCVT(argDTO.SearchValue,"U"),argDTO.HasGB)
			if ((argDTO.DicAliasCol '="")&&(argDTO.DicAliasCol'=$C(0)))
			{	s AliasCom= ##Class(EMR.DOC.COM.CheckTool).CheckContain($ZCVT(AliasValue,"U"),$ZCVT(argDTO.SearchValue,"U"),argDTO.HasGB)}
			
			if ((CodeCom '= 1)&&(DescCom '= 1)&&(AliasCom '= 1))
			{	continue}
		}
		
		//处理满足条件的结果并存入临时global
		s totRowCount = totRowCount + 1
		s AliasValue = $P(AliasValue,$C(2),1)
		if (argDTO.IsKeepMinus = "0")
		{	s DescValue = $E(DescValue,$F(DescValue,"-"),$L(DescValue)) }
		
		s:((totRowCount >= argDTO.MinCount)&&(totRowCount <= argDTO.MaxCount)) ^CacheTempStdQuery(argDTO.CookieID,totRowCount) =$LB(rowid,AliasValue,CodeValue,DescValue)
	}
	
	s ^CacheTempStdQuery(argDTO.CookieID,"StdQueryDataCount")= totRowCount
	
	q totRowCount
}

/// Create:	2013-06-06	niucaicai
/// Desc:	查询【中医主证】字典内容：SQLUSER.MRC_ICDDXZYZZ 只查询中医诊断，并且ICD码是“Z”开头的
/// Input：	argDTO.SearchValue 查询条件；argDTO.DicAliasCol 别名列；argDTO.DicCodeCol 代码列；argDTO.DicDescCol 描述列；argDTO.HasGB 查询条件是否有中文字符；argDTO.IsKeepMinus 描述列是否有横线
ClassMethod SelectStdDicMRCICDDxZYZZ(argDTO As EMR.DOC.DTO.StdDicParameter) As %Integer
{
	//结果行总数
	s totRowCount = 0
	
	//开始查询
	s rowid = 0
	for {
		s rowid=$o(^MRC("ID",rowid))
		quit:(rowid = "")
				
		s dateFrom="",dateTo="",currentDate=""
		s dateFrom=$p($g(^MRC("ID",rowid)),"^",6)
		s dateTo=$p($g(^MRC("ID",rowid)),"^",7)
		s currentDate=$p($h,",",1)
		if (((dateFrom'="")&&(currentDate<dateFrom))||((dateTo'="")&&(currentDate'<dateTo)))
		{	continue}
		
		//校验中医标志
		s zyFlag = $p($g(^MRC("ID",rowid)),"^",15)
		s zyFlag = $zcvt(zyFlag,"U")
		//校验ICD码是否为Z开头
		s isZstartFlag = $e($p($g(^MRC("ID",rowid)),"^",4),1,1)
		s isZstartFlag = $zcvt(isZstartFlag,"U")
		continue:($e(zyFlag,1,1)'="Y")||(isZstartFlag'="Z")
		
		//取代码列
		if $zcvt(argDTO.DicCodeCol,"U")="MRCID_ROWID"
		{	
			//诊断字典代码列使用rowid，用在病案首页，方便传rowid给医政组做编目
			s CodeValue = rowid	
		}
		else
		{	s CodeValue=$p($g(^MRC("ID",rowid)),"^",4)	}
		
		//取描述列
		s DescValue=""
		if ($zcvt(argDTO.DicDescCol,"U")="MRCID_LONGDESCRIPTION")
		{	s DescValue=$p($g(^MRC("ID",rowid)),"^",36)}		//for 上海华山
		else
		{	s DescValue=$p($g(^MRC("ID",rowid)),"^",2)}
		
		//取代码列附加信息
		//s ICD9Map=" /"_$p($g(^MRC("ID",rowid)),"^",35)  //Comment and updated by Wangwt 2008-06-27
		s ICD9Map=""
		s ICD9MapRowDR=""
		s ICD9MapRowDR=##Class(EMR.DOC.BL.SysOption).GetOptionValueByName("ICDCodeExpand",argDTO.ProductCode)
		if ICD9MapRowDR="Y"
		{
			s ICD9Map=" /"_$p($g(^MRC("ID",rowid)),"^",35) ;The Fourth Node is Parameter Value	
		}
		s CodeValue=CodeValue_ICD9Map
		
		//取别名列
		s AliasValue=""
		if ((argDTO.DicAliasCol '="")&&(argDTO.DicAliasCol'=$C(0)))
		{ 
			s aliasRowid=0
		  	for {
		  		s aliasRowid=$o(^MRC("ID",rowid,"ALIAS",aliasRowid))
				q:(aliasRowid="")
				s AliasValue=AliasValue_$p($g(^MRC("ID",rowid,"ALIAS",aliasRowid)),"^",1)_$c(2)
		    }
		}
		
		//是否满足查询条件
		s CodeCom=0, DescCom=0, AliasCom=0
		if (argDTO.SearchValue '= "")
		{	
			s CodeCom= ##Class(EMR.DOC.COM.CheckTool).CheckContain($ZCVT(CodeValue,"U"),$ZCVT(argDTO.SearchValue,"U"),argDTO.HasGB)
			S DescCom= ##Class(EMR.DOC.COM.CheckTool).CheckContain($ZCVT(DescValue,"U"),$ZCVT(argDTO.SearchValue,"U"),argDTO.HasGB)
			if ((argDTO.DicAliasCol '="")&&(argDTO.DicAliasCol'=$C(0)))
			{	s AliasCom= ##Class(EMR.DOC.COM.CheckTool).CheckContain($ZCVT(AliasValue,"U"),$ZCVT(argDTO.SearchValue,"U"),argDTO.HasGB)}
			
			if ((CodeCom '= 1)&&(DescCom '= 1)&&(AliasCom '= 1))
			{	continue}
		}
		
		//处理满足条件的结果并存入临时global
		s totRowCount = totRowCount + 1
		s AliasValue = $P(AliasValue,$C(2),1)
		if (argDTO.IsKeepMinus = "0")
		{	s DescValue = $E(DescValue,$F(DescValue,"-"),$L(DescValue)) }
		
		s:((totRowCount >= argDTO.MinCount)&&(totRowCount <= argDTO.MaxCount)) ^CacheTempStdQuery(argDTO.CookieID,totRowCount) =$LB(rowid,AliasValue,CodeValue,DescValue)
	}
	
	s ^CacheTempStdQuery(argDTO.CookieID,"StdQueryDataCount")= totRowCount
	
	q totRowCount
}

/// Create:	2008-11-27	HouJ
/// Desc:	查询【科室】字典内容：SQLUser.CT_Loc
/// Input：	argDTO.SearchValue 查询条件；argDTO.DicAliasCol 别名列；argDTO.DicCodeCol 代码列；argDTO.DicDescCol 描述列；ADescHasMinius 描述列是否有横线
ClassMethod SelectStdDicCTLoc(argDTO As EMR.DOC.DTO.StdDicParameter) As %Integer
{

	
	//结果行总数
	s totRowCount = 0
	
	//开始查询
	s rowid = 0
	for {
		s rowid=$o(^CTLOC(rowid))
		quit:(rowid = "")
		s dataactiveto = $p($g(^CTLOC(rowid)),"^",25)
		continue:((dataactiveto '= "")&&(dataactiveto < $p($h,",",1)))
		
		//过滤病区数据
		s wardFlag = $p($g(^CTLOC(rowid)),"^",5)
		continue:(wardFlag="Y")
		
		
		//取代码列,描述列,别名列
		if ($zcvt(argDTO.DicCodeCol,"U") = "CTLOC_CODE")
		{	s CodeValue=$p($g(^CTLOC(rowid)),"^",1)}
		elseif ($zcvt(argDTO.DicCodeCol,"U") = "CTLOC_ROWID")
		{	s CodeValue=rowid}
		
		s DescValue=$p($g(^CTLOC(rowid)),"^",2)
		
		s AliasValue=""
		if ($zcvt(argDTO.DicAliasCol,"U") = "CTLOC_CONTACTNAME")
		{	s AliasValue = $p($g(^CTLOC(rowid)),"^",43)}
		
		//是否满足查询条件
		s CodeCom=0, DescCom=0, AliasCom=0
		if (argDTO.SearchValue '= "")
		{	
			
			s CodeCom= ##Class(EMR.DOC.COM.CheckTool).CheckContain($ZCVT(CodeValue,"U"),$ZCVT(argDTO.SearchValue,"U"),argDTO.HasGB)
			S DescCom= ##Class(EMR.DOC.COM.CheckTool).CheckContain($ZCVT(DescValue,"U"),$ZCVT(argDTO.SearchValue,"U"),argDTO.HasGB)
			if ((argDTO.DicAliasCol '="")&&(argDTO.DicAliasCol'=$C(0)))
			{	s AliasCom= ##Class(EMR.DOC.COM.CheckTool).CheckContain($ZCVT(AliasValue,"U"),$ZCVT(argDTO.SearchValue,"U"),argDTO.HasGB)}
			
			if ((CodeCom '= 1)&&(DescCom '= 1)&&(AliasCom '= 1))
			{	continue}
		}
		
		//处理满足条件的结果并存入临时global
		s totRowCount = totRowCount + 1
		if (argDTO.IsKeepMinus = "0")
		{	s DescValue = $E(DescValue,$F(DescValue,"-"),$L(DescValue)) }
		s:((totRowCount >= argDTO.MinCount)&&(totRowCount <= argDTO.MaxCount)) ^CacheTempStdQuery(argDTO.CookieID,totRowCount) =$LB(rowid,AliasValue,CodeValue,DescValue)
	}
	
	s ^CacheTempStdQuery(argDTO.CookieID,"StdQueryDataCount")= totRowCount
	
	q totRowCount
}

/// Create:	2008-11-27	HouJ
/// Desc:	查询【民族】字典内容：SQLUser.CT_Nation
/// Input：	argDTO.SearchValue 查询条件；argDTO.DicAliasCol 别名列；argDTO.DicCodeCol 代码列；argDTO.DicDescCol 描述列；ADescHasMinius 描述列是否有横线
ClassMethod SelectStdDicCTNation(argDTO As EMR.DOC.DTO.StdDicParameter) As %Integer
{
	//结果行总数
	s totRowCount = 0
	
	//开始查询
	s rowid = 0
	for {
		s rowid=$o(^CT("NAT",rowid))
		quit:(rowid = "")
		
		//取代码列,描述列,别名列
		s CodeValue=$p($g(^CT("NAT",rowid)),"^",1)
		s DescValue=$p($g(^CT("NAT",rowid)),"^",2)
		s AliasValue=""
		
		//是否满足查询条件
		s CodeCom=0, DescCom=0, AliasCom=0
		if (argDTO.SearchValue '= "")
		{	
			
			s CodeCom= ##Class(EMR.DOC.COM.CheckTool).CheckContain($ZCVT(CodeValue,"U"),$ZCVT(argDTO.SearchValue,"U"),argDTO.HasGB)
			S DescCom= ##Class(EMR.DOC.COM.CheckTool).CheckContain($ZCVT(DescValue,"U"),$ZCVT(argDTO.SearchValue,"U"),argDTO.HasGB)
			if ((argDTO.DicAliasCol '="")&&(argDTO.DicAliasCol'=$C(0)))
			{	s AliasCom= ##Class(EMR.DOC.COM.CheckTool).CheckContain($ZCVT(AliasValue,"U"),$ZCVT(argDTO.SearchValue,"U"),argDTO.HasGB)}
			
			if ((CodeCom '= 1)&&(DescCom '= 1)&&(AliasCom '= 1))
			{	continue}
		}
		
		//处理满足条件的结果并存入临时global
		s totRowCount = totRowCount + 1
		if (argDTO.IsKeepMinus = "0")
		{	s DescValue = $E(DescValue,$F(DescValue,"-"),$L(DescValue)) }
		s:((totRowCount >= argDTO.MinCount)&&(totRowCount <= argDTO.MaxCount)) ^CacheTempStdQuery(argDTO.CookieID,totRowCount) =$LB(rowid,AliasValue,CodeValue,DescValue)
	}
	
	s ^CacheTempStdQuery(argDTO.CookieID,"StdQueryDataCount")= totRowCount
	
	q totRowCount
}

/// Create:	2008-11-27	HouJ
/// Desc:	查询【用户】字典内容：SQLUser.SS_User
/// Input：	argDTO.SearchValue 查询条件；argDTO.DicAliasCol 别名列；argDTO.DicCodeCol 代码列；argDTO.DicDescCol 描述列；ADescHasMinius 描述列是否有横线
ClassMethod SelectStdDicSSUser(argDTO As EMR.DOC.DTO.StdDicParameter) As %Integer
{
	//结果行总数
	s totRowCount = 0
	
	//开始查询
	s rowid = 0
	for {
		s rowid=$o(^SSU("SSUSR",rowid))
		quit:(rowid = "")
		
		//取代码列,描述列,别名列
		if ($zcvt(argDTO.DicCodeCol,"U") = "SSUSR_INITIALS")
		{s CodeValue=$p($g(^SSU("SSUSR",rowid)),"^",1)}
		s DescValue=$p($g(^SSU("SSUSR",rowid)),"^",2)
		s AliasValue=$p($g(^SSU("SSUSR",rowid)),"^",11)
		
		//是否满足查询条件
		s CodeCom=0, DescCom=0, AliasCom=0
		if (argDTO.SearchValue '= "")
		{	
			
			s CodeCom= ##Class(EMR.DOC.COM.CheckTool).CheckContain($ZCVT(CodeValue,"U"),$ZCVT(argDTO.SearchValue,"U"),argDTO.HasGB)
			S DescCom= ##Class(EMR.DOC.COM.CheckTool).CheckContain($ZCVT(DescValue,"U"),$ZCVT(argDTO.SearchValue,"U"),argDTO.HasGB)
			if ((argDTO.DicAliasCol '="")&&(argDTO.DicAliasCol'=$C(0)))
			{	s AliasCom= ##Class(EMR.DOC.COM.CheckTool).CheckContain($ZCVT(AliasValue,"U"),$ZCVT(argDTO.SearchValue,"U"),argDTO.HasGB)}
			
			if ((CodeCom '= 1)&&(DescCom '= 1)&&(AliasCom '= 1))
			{	continue}
		}
		
		//处理满足条件的结果并存入临时global
		s totRowCount = totRowCount + 1
		if (argDTO.IsKeepMinus = "0")
		{	s DescValue = $E(DescValue,$F(DescValue,"-"),$L(DescValue)) }
		s:((totRowCount >= argDTO.MinCount)&&(totRowCount <= argDTO.MaxCount)) ^CacheTempStdQuery(argDTO.CookieID,totRowCount) =$LB(rowid,AliasValue,CodeValue,DescValue)
	}
	
	s ^CacheTempStdQuery(argDTO.CookieID,"StdQueryDataCount")= totRowCount
	
	q totRowCount
}

/// Create:	2008-11-27	HouJ
/// Desc:	查询【病室】字典内容：SQLUser.PAC_Ward
/// Input：	argDTO.SearchValue 查询条件；argDTO.DicAliasCol 别名列；argDTO.DicCodeCol 代码列；argDTO.DicDescCol 描述列；ADescHasMinius 描述列是否有横线
ClassMethod SelectStdDicPACWard(argDTO As EMR.DOC.DTO.StdDicParameter) As %Integer
{
	//结果行总数
	s totRowCount = 0
	
	//开始查询
	s rowid = 0
	for {
		s rowid=$o(^PAWARD(rowid))
		quit:(rowid = "")
		
		//取代码列,描述列,别名列
		if ($zcvt(argDTO.DicCodeCol,"U") = "WARD_CODE")
		{	s CodeValue=$p($g(^PAWARD(rowid)),"^",1)}
		elseif ($zcvt(argDTO.DicCodeCol,"U") = "WARD_ROWID")
		{	s CodeValue = rowid }
		s DescValue=$p($g(^PAWARD(rowid)),"^",2)
		//病区描述 把描述列转换为简拼
		s AliasValue=##class(EMR.DOC.COM.CodeTool).GetCNCODE(DescValue,4,"")
		
		//是否满足查询条件
		s CodeCom=0, DescCom=0, AliasCom=0
		if (argDTO.SearchValue '= "")
		{	
			
			s CodeCom= ##Class(EMR.DOC.COM.CheckTool).CheckContain($ZCVT(CodeValue,"U"),$ZCVT(argDTO.SearchValue,"U"),argDTO.HasGB)
			S DescCom= ##Class(EMR.DOC.COM.CheckTool).CheckContain($ZCVT(DescValue,"U"),$ZCVT(argDTO.SearchValue,"U"),argDTO.HasGB)
			// 去掉原先判定 直接匹配查询条件
			s AliasCom= ##Class(EMR.DOC.COM.CheckTool).CheckContain($ZCVT(AliasValue,"U"),$ZCVT(argDTO.SearchValue,"U"),argDTO.HasGB)
			
			if ((CodeCom '= 1)&&(DescCom '= 1)&&(AliasCom '= 1))
			{	continue}
		}
		
		//处理满足条件的结果并存入临时global
		s totRowCount = totRowCount + 1
		if (argDTO.IsKeepMinus = "0")
		{	s DescValue = $E(DescValue,$F(DescValue,"-"),$L(DescValue)) }
		s:((totRowCount >= argDTO.MinCount)&&(totRowCount <= argDTO.MaxCount)) ^CacheTempStdQuery(argDTO.CookieID,totRowCount) =$LB(rowid,AliasValue,CodeValue,DescValue)
	}
	
	s ^CacheTempStdQuery(argDTO.CookieID,"StdQueryDataCount")= totRowCount
	
	q totRowCount
}

/// Create:	2008-11-27	HouJ
/// Desc:	查询【药学项】字典内容：SQLUser.PHC_DrgMast
/// Input：	argDTO.SearchValue 查询条件；argDTO.DicAliasCol 别名列；argDTO.DicCodeCol 代码列；argDTO.DicDescCol 描述列；ADescHasMinius 描述列是否有横线
ClassMethod SelectStdDicPHCDrgMast(argDTO As EMR.DOC.DTO.StdDicParameter) As %Integer
{
	//结果行总数
	s totRowCount = 0
	
	//开始查询
	s rowid = 0
	for {
		s rowid=$o(^PHCD(rowid))
		quit:(rowid = "")
		
		//取代码列,描述列,别名列
		s CodeValue=$p($g(^PHCD(rowid,1)),"^",1)
		s DescValue=$p($g(^PHCD(rowid,1)),"^",2)
		//取别名列
		//phc_drgmast.phcd_code ==> phc_drgmast.phcd_code ==> arc_alias
		s AliasValue=""
		if ((argDTO.DicAliasCol '="")&&(argDTO.DicAliasCol '=$C(0))&&(CodeValue '=""))
		{ 
			s subscript=""
		  	for {
			  	//(^ARCIM(0,"Code",$$ALPHAUP({ARCIM_Code}),{ARCIM_Subscript},{ARCIM_Version})
				s subscript=$O(^ARCIM(0,"Code",$zcvt(CodeValue,"U"),subscript))		  		
				q:(subscript="")
			
				s version=""
				for {
					s version=$O(^ARCIM(0,"Code",$zcvt(CodeValue,"U"),subscript,version))
					q:(version="")
				
					s arcimdr=subscript_"||"_version
					s aliasRowid=""
					for {
						//^ARC("ALIAS",0,"ARCIM",{ALIAS_ARCIM_DR},{ALIAS_RowId})
						s aliasRowid=$O(^ARC("ALIAS",0,"ARCIM",arcimdr,aliasRowid))
						q:(aliasRowid="")
						
						s AliasValue=AliasValue_$p($g(^ARC("ALIAS",aliasRowid)),"^",6)_$c(2)
					}		
				}
		    }
		}
		
		//是否满足查询条件
		s CodeCom=0, DescCom=0, AliasCom=0
		if (argDTO.SearchValue '= "")
		{	
			s CodeCom= ##Class(EMR.DOC.COM.CheckTool).CheckContain($ZCVT(CodeValue,"U"),$ZCVT(argDTO.SearchValue,"U"),argDTO.HasGB)
			S DescCom= ##Class(EMR.DOC.COM.CheckTool).CheckContain($ZCVT(DescValue,"U"),$ZCVT(argDTO.SearchValue,"U"),argDTO.HasGB)
			if ((argDTO.DicAliasCol '="")&&(argDTO.DicAliasCol'=$C(0)))
			{	s AliasCom= ##Class(EMR.DOC.COM.CheckTool).CheckContain($ZCVT(AliasValue,"U"),$ZCVT(argDTO.SearchValue,"U"),argDTO.HasGB)}
			
			if ((CodeCom '= 1)&&(DescCom '= 1)&&(AliasCom '= 1))
			{	continue}
		}
		
		//处理满足条件的结果并存入临时global
		s totRowCount = totRowCount + 1
		s AliasValue = $P(AliasValue,$C(2),1)
		if (argDTO.IsKeepMinus = "0")
		{	s DescValue = $E(DescValue,$F(DescValue,"-"),$L(DescValue)) }
		s:((totRowCount >= argDTO.MinCount)&&(totRowCount <= argDTO.MaxCount)) ^CacheTempStdQuery(argDTO.CookieID,totRowCount) =$LB(rowid,AliasValue,CodeValue,DescValue)
	}
	
	s ^CacheTempStdQuery(argDTO.CookieID,"StdQueryDataCount")= totRowCount
	
	q totRowCount
}

/// Create:	2008-11-27	HouJ
/// Desc:	查询【职业】字典内容：SQLUser.CT_Occupation
/// Input：	argDTO.SearchValue 查询条件；argDTO.DicAliasCol 别名列；argDTO.DicCodeCol 代码列；argDTO.DicDescCol 描述列；ADescHasMinius 描述列是否有横线
ClassMethod SelectStdDicCTOccupation(argDTO As EMR.DOC.DTO.StdDicParameter) As %Integer
{
	//结果行总数
	s totRowCount = 0
	
	//开始查询
	s rowid = 0
	for {
		s rowid=$o(^CT("OCC",rowid))
		quit:(rowid = "")
		
		//wangwentao 20120107 add
		s dateFrom="",dateTo="",currentDate=""
		s dateFrom=$p($g(^CT("OCC",rowid)),"^",3)
		s dateTo=$p($g(^CT("OCC",rowid)),"^",4)
		s currentDate=$p($h,",",1)
		if (((dateFrom'="")&&(currentDate<dateFrom))||((dateTo'="")&&(currentDate'<dateTo)))
		{	continue}
		
		//取代码列,描述列,别名列
		s CodeValue=$p($g(^CT("OCC",rowid)),"^",1)
		s DescValue=$p($g(^CT("OCC",rowid)),"^",2)
		s AliasValue=""
		
		//是否满足查询条件
		s CodeCom=0, DescCom=0, AliasCom=0
		if (argDTO.SearchValue '= "")
		{	
			
			s CodeCom= ##Class(EMR.DOC.COM.CheckTool).CheckContain($ZCVT(CodeValue,"U"),$ZCVT(argDTO.SearchValue,"U"),argDTO.HasGB)
			S DescCom= ##Class(EMR.DOC.COM.CheckTool).CheckContain($ZCVT(DescValue,"U"),$ZCVT(argDTO.SearchValue,"U"),argDTO.HasGB)
			if ((argDTO.DicAliasCol '="")&&(argDTO.DicAliasCol'=$C(0)))
			{	s AliasCom= ##Class(EMR.DOC.COM.CheckTool).CheckContain($ZCVT(AliasValue,"U"),$ZCVT(argDTO.SearchValue,"U"),argDTO.HasGB)}
			
			if ((CodeCom '= 1)&&(DescCom '= 1)&&(AliasCom '= 1))
			{	continue}
		}
		
		//处理满足条件的结果并存入临时global
		s totRowCount = totRowCount + 1
		if (argDTO.IsKeepMinus = "0")
		{	s DescValue = $E(DescValue,$F(DescValue,"-"),$L(DescValue)) }
		s:((totRowCount >= argDTO.MinCount)&&(totRowCount <= argDTO.MaxCount)) ^CacheTempStdQuery(argDTO.CookieID,totRowCount) =$LB(rowid,AliasValue,CodeValue,DescValue)
	}
	
	s ^CacheTempStdQuery(argDTO.CookieID,"StdQueryDataCount")= totRowCount
	
	q totRowCount
}

/// Create:	2008-11-27	HouJ
/// Desc:	查询【国籍】字典内容：SQLUser.CT_Country
/// Input：	argDTO.SearchValue 查询条件；argDTO.DicAliasCol 别名列；argDTO.DicCodeCol 代码列；argDTO.DicDescCol 描述列；ADescHasMinius 描述列是否有横线
/// Debug:  w ##Class(EMR.DOC.BL.StdDictionary).SelectStdDicCTCountry("","","","","11","","")
ClassMethod SelectStdDicCTCountry(argDTO As EMR.DOC.DTO.StdDicParameter) As %Integer
{
	//结果行总数
	s totRowCount = 0
	
	//开始查询
	s rowid = 0
	for {
		s rowid=$o(^CT("COU",rowid))
		quit:(rowid = "")
		
		//取代码列,描述列,别名列
		s CodeValue=$p($g(^CT("COU",rowid)),"^",1)
		s DescValue=$p($g(^CT("COU",rowid)),"^",2)
		s AliasValue=""
		if ((argDTO.DicAliasCol '="")&&(argDTO.DicAliasCol'=$C(0)))
		{ 
			s id=0
			for {
				s id=$o(^User.BDPAliasI("DataRef","CT_Country",rowid,id))
				q:(id="")
				s obj=##class(User.BDPAlias).%OpenId(id)
				q:(obj="")
				s AliasValue=AliasValue_obj.DataAlias_$c(2)
			}
		}
		
		//是否满足查询条件
		s CodeCom=0, DescCom=0, AliasCom=0
		if (argDTO.SearchValue '= "")
		{	
			
			s CodeCom= ##Class(EMR.DOC.COM.CheckTool).CheckContain($ZCVT(CodeValue,"U"),$ZCVT(argDTO.SearchValue,"U"),argDTO.HasGB)
			S DescCom= ##Class(EMR.DOC.COM.CheckTool).CheckContain($ZCVT(DescValue,"U"),$ZCVT(argDTO.SearchValue,"U"),argDTO.HasGB)
			if ((argDTO.DicAliasCol '="")&&(argDTO.DicAliasCol'=$C(0)))
			{	s AliasCom= ##Class(EMR.DOC.COM.CheckTool).CheckContain($ZCVT(AliasValue,"U"),$ZCVT(argDTO.SearchValue,"U"),argDTO.HasGB)}
			
			if ((CodeCom '= 1)&&(DescCom '= 1)&&(AliasCom '= 1))
			{	continue}
		}
		
		//处理满足条件的结果并存入临时global
		s totRowCount = totRowCount + 1
		if (argDTO.IsKeepMinus = "0")
		{	s DescValue = $E(DescValue,$F(DescValue,"-"),$L(DescValue)) }
		s:((totRowCount >= argDTO.MinCount)&&(totRowCount <= argDTO.MaxCount)) ^CacheTempStdQuery(argDTO.CookieID,totRowCount) =$LB(rowid,AliasValue,CodeValue,DescValue)
	}
	
	s ^CacheTempStdQuery(argDTO.CookieID,"StdQueryDataCount")= totRowCount
	
	q totRowCount
}

/// Create:	2008-11-27	HouJ
/// Desc:	查询【省市】字典内容：SQLUser.CT_Province
/// Input：	argDTO.SearchValue 查询条件；argDTO.DicAliasCol 别名列；argDTO.DicCodeCol 代码列；argDTO.DicDescCol 描述列；ADescHasMinius 描述列是否有横线
ClassMethod SelectStdDicCTProvince(argDTO As EMR.DOC.DTO.StdDicParameter) As %Integer
{
	//结果行总数
	s totRowCount = 0
	
	//开始查询
	s rowid = 0
	for {
		s rowid=$o(^CT("PROV",rowid))
		quit:(rowid = "")
		
		//wangwentao 20121129 add
		s dateFrom="",dateTo="",currentDate=""
		s dateFrom=$p($g(^CT("PROV",rowid)),"^",4)
		s dateTo=$p($g(^CT("PROV",rowid)),"^",5)
		s currentDate=$p($h,",",1)
		if (((dateFrom'="")&&(currentDate<dateFrom))||((dateTo'="")&&(currentDate'<dateTo)))
		{	
			continue
		}
		
		
		
		//取代码列,描述列,别名列
		s CodeValue=$p($g(^CT("PROV",rowid)),"^",1)
		s DescValue=$p($g(^CT("PROV",rowid)),"^",2)
		s AliasValue=""
		if ((argDTO.DicAliasCol '="")&&(argDTO.DicAliasCol'=$C(0)))
		{ 
			s id=0
			for {
				s id=$o(^User.BDPAliasI("DataRef","CT_Province",rowid,id))
				q:(id="")
				s obj=##class(User.BDPAlias).%OpenId(id)
				q:(obj="")
				s AliasValue=AliasValue_obj.DataAlias_$c(2)
			}
		}
		
		//是否满足查询条件
		s CodeCom=0, DescCom=0, AliasCom=0
		if (argDTO.SearchValue '= "")
		{	
			
			s CodeCom= ##Class(EMR.DOC.COM.CheckTool).CheckContain($ZCVT(CodeValue,"U"),$ZCVT(argDTO.SearchValue,"U"),argDTO.HasGB)
			S DescCom= ##Class(EMR.DOC.COM.CheckTool).CheckContain($ZCVT(DescValue,"U"),$ZCVT(argDTO.SearchValue,"U"),argDTO.HasGB)
			if ((argDTO.DicAliasCol '="")&&(argDTO.DicAliasCol'=$C(0)))
			{	s AliasCom= ##Class(EMR.DOC.COM.CheckTool).CheckContain($ZCVT(AliasValue,"U"),$ZCVT(argDTO.SearchValue,"U"),argDTO.HasGB)}
			
			if ((CodeCom '= 1)&&(DescCom '= 1)&&(AliasCom '= 1))
			{	continue}
		}
		
		//处理满足条件的结果并存入临时global
		s totRowCount = totRowCount + 1
		if (argDTO.IsKeepMinus = "0")
		{	s DescValue = $E(DescValue,$F(DescValue,"-"),$L(DescValue)) }
		s:((totRowCount >= argDTO.MinCount)&&(totRowCount <= argDTO.MaxCount)) ^CacheTempStdQuery(argDTO.CookieID,totRowCount) =$LB(rowid,AliasValue,CodeValue,DescValue)
	}
	
	s ^CacheTempStdQuery(argDTO.CookieID,"StdQueryDataCount")= totRowCount
	
	q totRowCount
}

/// Create:	2008-11-27	HouJ
/// Desc:	查询【省市】字典内容：SQLUser.CT_City
/// Input：	argDTO.SearchValue 查询条件；argDTO.DicAliasCol 别名列；argDTO.DicCodeCol 代码列；argDTO.DicDescCol 描述列；ADescHasMinius 描述列是否有横线
ClassMethod SelectStdDicCTCity(argDTO As EMR.DOC.DTO.StdDicParameter) As %Integer
{
	//结果行总数
	s totRowCount = 0
	
	//开始查询
	s rowid = 0
	for {
		s rowid=$o(^CT("CIT",rowid))
		quit:(rowid = "")
		
		//wangwentao 20121129 add
		s dateFrom="",dateTo="",currentDate=""
		s dateFrom=$p($g(^CT("CIT",rowid)),"^",5)
		s dateTo=$p($g(^CT("CIT",rowid)),"^",6)
		s currentDate=$p($h,",",1)
		if (((dateFrom'="")&&(currentDate<dateFrom))||((dateTo'="")&&(currentDate'<dateTo)))
		{	continue}
		
		//取代码列,描述列,别名列
		s CodeValue=$p($g(^CT("CIT",rowid)),"^",1)
		s DescValue=$p($g(^CT("CIT",rowid)),"^",2)
		s AliasValue=""
		if ((argDTO.DicAliasCol '="")&&(argDTO.DicAliasCol'=$C(0)))
		{ 
			s id=0
			for {
				s id=$o(^User.BDPAliasI("DataRef","CT_City",rowid,id))
				q:(id="")
				s obj=##class(User.BDPAlias).%OpenId(id)
				q:(obj="")
				s AliasValue=AliasValue_obj.DataAlias_$c(2)
			}
		}
		
		//是否满足查询条件
		s CodeCom=0, DescCom=0, AliasCom=0
		if (argDTO.SearchValue '= "")
		{	
			
			s CodeCom= ##Class(EMR.DOC.COM.CheckTool).CheckContain($ZCVT(CodeValue,"U"),$ZCVT(argDTO.SearchValue,"U"),argDTO.HasGB)
			S DescCom= ##Class(EMR.DOC.COM.CheckTool).CheckContain($ZCVT(DescValue,"U"),$ZCVT(argDTO.SearchValue,"U"),argDTO.HasGB)
			if ((argDTO.DicAliasCol '="")&&(argDTO.DicAliasCol'=$C(0)))
			{	s AliasCom= ##Class(EMR.DOC.COM.CheckTool).CheckContain($ZCVT(AliasValue,"U"),$ZCVT(argDTO.SearchValue,"U"),argDTO.HasGB)}
			
			if ((CodeCom '= 1)&&(DescCom '= 1)&&(AliasCom '= 1))
			{	continue}
		}
		
		//处理满足条件的结果并存入临时global
		s totRowCount = totRowCount + 1
		if (argDTO.IsKeepMinus = "0")
		{	s DescValue = $E(DescValue,$F(DescValue,"-"),$L(DescValue)) }
		s:((totRowCount >= argDTO.MinCount)&&(totRowCount <= argDTO.MaxCount)) ^CacheTempStdQuery(argDTO.CookieID,totRowCount) =$LB(rowid,AliasValue,CodeValue,DescValue)
	}
	
	s ^CacheTempStdQuery(argDTO.CookieID,"StdQueryDataCount")= totRowCount
	
	q totRowCount
}

/// Create:	2008-11-27	HouJ
/// Desc:	查询【性别】字典内容：SQLUser.CT_Sex
/// Input：	argDTO.SearchValue 查询条件；argDTO.DicAliasCol 别名列；argDTO.DicCodeCol 代码列；argDTO.DicDescCol 描述列；ADescHasMinius 描述列是否有横线
ClassMethod SelectStdDicCTSex(argDTO As EMR.DOC.DTO.StdDicParameter) As %Integer
{
	//结果行总数
	s totRowCount = 0
	
	//开始查询
	s rowid = 0
	for {
		s rowid=$o(^CT("SEX",rowid))
		quit:(rowid = "")
		
		//取代码列,描述列,别名列
		s CodeValue=$p($g(^CT("SEX",rowid)),"^",1)
		s DescValue=$p($g(^CT("SEX",rowid)),"^",2)
		s AliasValue=""
		
		//是否满足查询条件
		s CodeCom=0, DescCom=0, AliasCom=0
		if (argDTO.SearchValue '= "")
		{	
			
			s CodeCom= ##Class(EMR.DOC.COM.CheckTool).CheckContain($ZCVT(CodeValue,"U"),$ZCVT(argDTO.SearchValue,"U"),argDTO.HasGB)
			S DescCom= ##Class(EMR.DOC.COM.CheckTool).CheckContain($ZCVT(DescValue,"U"),$ZCVT(argDTO.SearchValue,"U"),argDTO.HasGB)
			if ((argDTO.DicAliasCol '="")&&(argDTO.DicAliasCol'=$C(0)))
			{	s AliasCom= ##Class(EMR.DOC.COM.CheckTool).CheckContain($ZCVT(AliasValue,"U"),$ZCVT(argDTO.SearchValue,"U"),argDTO.HasGB)}
			
			if ((CodeCom '= 1)&&(DescCom '= 1)&&(AliasCom '= 1))
			{	continue}
		}
		
		//处理满足条件的结果并存入临时global
		s totRowCount = totRowCount + 1
		if (argDTO.IsKeepMinus = "0")
		{	s DescValue = $E(DescValue,$F(DescValue,"-"),$L(DescValue)) }
		s:((totRowCount >= argDTO.MinCount)&&(totRowCount <= argDTO.MaxCount)) ^CacheTempStdQuery(argDTO.CookieID,totRowCount) =$LB(rowid,AliasValue,CodeValue,DescValue)
	}
	
	s ^CacheTempStdQuery(argDTO.CookieID,"StdQueryDataCount")= totRowCount
	
	q totRowCount
}

/// Create:	2008-11-27	HouJ
/// Desc:	查询【病人类别】字典内容：SQLUser.PAC_PatientCategory
/// Input：	argDTO.SearchValue 查询条件；argDTO.DicAliasCol 别名列；argDTO.DicCodeCol 代码列；argDTO.DicDescCol 描述列；ADescHasMinius 描述列是否有横线
ClassMethod SelectStdDicPACPatientCategory(argDTO As EMR.DOC.DTO.StdDicParameter) As %Integer
{
	//结果行总数
	s totRowCount = 0
	
	//开始查询
	s rowid = 0
	for {
		s rowid=$o(^PAC("PACT",rowid))
		quit:(rowid = "")
		
		//取代码列,描述列,别名列
		s CodeValue=$p($g(^PAC("PACT",rowid)),"^",1)
		s DescValue=$p($g(^PAC("PACT",rowid)),"^",2)
		s AliasValue=""
		
		//是否满足查询条件
		s CodeCom=0, DescCom=0, AliasCom=0
		if (argDTO.SearchValue '= "")
		{	
			
			s CodeCom= ##Class(EMR.DOC.COM.CheckTool).CheckContain($ZCVT(CodeValue,"U"),$ZCVT(argDTO.SearchValue,"U"),argDTO.HasGB)
			S DescCom= ##Class(EMR.DOC.COM.CheckTool).CheckContain($ZCVT(DescValue,"U"),$ZCVT(argDTO.SearchValue,"U"),argDTO.HasGB)
			if ((argDTO.DicAliasCol '="")&&(argDTO.DicAliasCol'=$C(0)))
			{	s AliasCom= ##Class(EMR.DOC.COM.CheckTool).CheckContain($ZCVT(AliasValue,"U"),$ZCVT(argDTO.SearchValue,"U"),argDTO.HasGB)}
			
			if ((CodeCom '= 1)&&(DescCom '= 1)&&(AliasCom '= 1))
			{	continue}
		}
		
		//处理满足条件的结果并存入临时global
		s totRowCount = totRowCount + 1
		if (argDTO.IsKeepMinus = "0")
		{	s DescValue = $E(DescValue,$F(DescValue,"-"),$L(DescValue)) }
		s:((totRowCount >= argDTO.MinCount)&&(totRowCount <= argDTO.MaxCount)) ^CacheTempStdQuery(argDTO.CookieID,totRowCount) =$LB(rowid,AliasValue,CodeValue,DescValue)
	}
	
	s ^CacheTempStdQuery(argDTO.CookieID,"StdQueryDataCount")= totRowCount
	
	q totRowCount
}

/// Create:	2008-11-27	HouJ
/// Desc:	查询【邮编】字典内容：SQLUser.CT_Zip	CTZIP_Code CTZIP_Desc 
/// Input：	argDTO.SearchValue 查询条件；argDTO.DicAliasCol 别名列；argDTO.DicCodeCol 代码列；argDTO.DicDescCol 描述列；ADescHasMinius 描述列是否有横线
ClassMethod SelectStdDicCTZip(argDTO As EMR.DOC.DTO.StdDicParameter) As %Integer
{
	//结果行总数
	s totRowCount = 0
	
	//开始查询
	s rowid = 0
	for {
		s rowid=$o(^CT("ZIP",rowid))
		quit:(rowid = "")
		
		//取代码列,描述列,别名列
		s CodeValue=$p($g(^CT("ZIP",rowid)),"^",1)
		s DescValue=$p($g(^CT("ZIP",rowid)),"^",2)
		s AliasValue=""
		
		//是否满足查询条件
		s CodeCom=0, DescCom=0, AliasCom=0
		if (argDTO.SearchValue '= "")
		{	
			
			s CodeCom= ##Class(EMR.DOC.COM.CheckTool).CheckContain($ZCVT(CodeValue,"U"),$ZCVT(argDTO.SearchValue,"U"),argDTO.HasGB)
			S DescCom= ##Class(EMR.DOC.COM.CheckTool).CheckContain($ZCVT(DescValue,"U"),$ZCVT(argDTO.SearchValue,"U"),argDTO.HasGB)
			if ((argDTO.DicAliasCol '="")&&(argDTO.DicAliasCol'=$C(0)))
			{	s AliasCom= ##Class(EMR.DOC.COM.CheckTool).CheckContain($ZCVT(AliasValue,"U"),$ZCVT(argDTO.SearchValue,"U"),argDTO.HasGB)}
			
			if ((CodeCom '= 1)&&(DescCom '= 1)&&(AliasCom '= 1))
			{	continue}
		}
		
		//处理满足条件的结果并存入临时global
		s totRowCount = totRowCount + 1
		if (argDTO.IsKeepMinus = "0")
		{	s DescValue = $E(DescValue,$F(DescValue,"-"),$L(DescValue)) }
		s:((totRowCount >= argDTO.MinCount)&&(totRowCount <= argDTO.MaxCount)) ^CacheTempStdQuery(argDTO.CookieID,totRowCount) =$LB(rowid,AliasValue,CodeValue,DescValue)
	}
	
	s ^CacheTempStdQuery(argDTO.CookieID,"StdQueryDataCount")= totRowCount
	
	q totRowCount
}

/// Create:	2008-11-27	HouJ
/// Desc:	查询【手术】字典内容：SQLUser.ORC_Operation, SQLUser.ORC_OperationAlias
/// Input：	argDTO.SearchValue 查询条件；argDTO.DicAliasCol 别名列；argDTO.DicCodeCol 代码列；argDTO.DicDescCol 描述列；argDTO.HasGB 查询条件是否有中文字符；argDTO.IsKeepMinus 描述列是否有横线
ClassMethod SelectStdDicORCOperation(argDTO As EMR.DOC.DTO.StdDicParameter) As %Integer
{
	
	//结果行总数
	s totRowCount = 0
	
	//开始查询
	s rowid = 0
	for {
		s rowid=$o(^ORC("OPER",rowid))
		quit:(rowid = "")
				
		//get and  validate date of the ICD item.  gjb 2007-12-25
		s dateFrom="",dateTo="",currentDate=""
		s dateFrom=$p($g(^ORC("OPER",rowid)),"^",5)
		s dateTo=$p($g(^ORC("OPER",rowid)),"^",6)
		s currentDate=$p($h,",",1)
		if (((dateFrom'="")&&(currentDate<dateFrom))||((dateTo'="")&&(currentDate'<dateTo)))
		{	continue}
		
		//取代码列和描述列
		//s CodeValue=$p($g(^ORC("OPER",rowid)),"^",1)
		if ($zcvt(argDTO.DicCodeCol,"U") = "OPER_CODE")
		{	s CodeValue = $p($g(^ORC("OPER",rowid)),"^",1)}
		elseif ($zcvt(argDTO.DicCodeCol,"U") = "OPER_ICD10")
		{	s CodeValue =  $p($g(^ORC("OPER",rowid)),"^",14)}
		elseif ($zcvt(argDTO.DicCodeCol,"U") = "OPER_ROWID")
		{	S CodeValue = rowid}
		s DescValue=$p($g(^ORC("OPER",rowid)),"^",2)
		
		//取别名列
		s AliasValue=""
		if ((argDTO.DicAliasCol '="")&&(argDTO.DicAliasCol'=$C(0)))
		{ 
			s aliasRowid=0
		  	for {
		  		s aliasRowid=$o(^ORC("OPER",rowid,"ALIAS",aliasRowid))
				q:(aliasRowid="")
				s AliasValue=AliasValue_$g(^ORC("OPER",rowid,"ALIAS",aliasRowid))_$c(2)
		    }
		}
		
		//是否满足查询条件
		s CodeCom=0, DescCom=0, AliasCom=0
		if (argDTO.SearchValue '= "")
		{	
			s CodeCom= ##Class(EMR.DOC.COM.CheckTool).CheckContain($ZCVT(CodeValue,"U"),$ZCVT(argDTO.SearchValue,"U"),argDTO.HasGB)
			S DescCom= ##Class(EMR.DOC.COM.CheckTool).CheckContain($ZCVT(DescValue,"U"),$ZCVT(argDTO.SearchValue,"U"),argDTO.HasGB)
			if ((argDTO.DicAliasCol '="")&&(argDTO.DicAliasCol'=$C(0)))
			{	s AliasCom= ##Class(EMR.DOC.COM.CheckTool).CheckContain($ZCVT(AliasValue,"U"),$ZCVT(argDTO.SearchValue,"U"),argDTO.HasGB)}
			
			if ((CodeCom '= 1)&&(DescCom '= 1)&&(AliasCom '= 1))
			{	continue}
		}
		
		//处理满足条件的结果并存入临时global
		s totRowCount = totRowCount + 1
		s AliasValue = $P(AliasValue,$C(2),1)
		if (argDTO.IsKeepMinus = "0")
		{	s DescValue = $E(DescValue,$F(DescValue,"-"),$L(DescValue)) }
		
		s:((totRowCount >= argDTO.MinCount)&&(totRowCount <= argDTO.MaxCount)) ^CacheTempStdQuery(argDTO.CookieID,totRowCount) =$LB(rowid,AliasValue,CodeValue,DescValue)
	}
	
	s ^CacheTempStdQuery(argDTO.CookieID,"StdQueryDataCount")= totRowCount
	
	q totRowCount
}

/// Create:	2008-11-27	HouJ
/// Desc:	查询【联系人关系】字典内容：SQLUser.CT_Relation 
/// Input：	argDTO.SearchValue 查询条件；argDTO.DicAliasCol 别名列；argDTO.DicCodeCol 代码列；argDTO.DicDescCol 描述列；ADescHasMinius 描述列是否有横线
ClassMethod SelectStdDicCTReleation(argDTO As EMR.DOC.DTO.StdDicParameter) As %Integer
{
	//结果行总数
	s totRowCount = 0
	
	//开始查询
	s rowid = 0
	for {
		s rowid=$O(^CT("RLT",rowid))
		quit:(rowid = "")
		
		//wangwentao 20120107 add
		s dateFrom="",dateTo="",currentDate=""
		s dateFrom=$p($g(^CT("RLT",rowid)),"^",3)
		s dateTo=$p($g(^CT("RLT",rowid)),"^",4)
		s currentDate=$p($h,",",1)
		if (((dateFrom'="")&&(currentDate<dateFrom))||((dateTo'="")&&(currentDate'<dateTo)))
		{	continue}
		
		//取代码列,描述列,别名列
		s CodeValue=$p($g(^CT("RLT",rowid)),"^",1)
		s DescValue=$p($g(^CT("RLT",rowid)),"^",2)
		s AliasValue=""
		
		//是否满足查询条件
		s CodeCom=0, DescCom=0, AliasCom=0
		if (argDTO.SearchValue '= "")
		{	
			
			s CodeCom= ##Class(EMR.DOC.COM.CheckTool).CheckContain($ZCVT(CodeValue,"U"),$ZCVT(argDTO.SearchValue,"U"),argDTO.HasGB)
			S DescCom= ##Class(EMR.DOC.COM.CheckTool).CheckContain($ZCVT(DescValue,"U"),$ZCVT(argDTO.SearchValue,"U"),argDTO.HasGB)
			if ((argDTO.DicAliasCol '="")&&(argDTO.DicAliasCol'=$C(0)))
			{	s AliasCom= ##Class(EMR.DOC.COM.CheckTool).CheckContain($ZCVT(AliasValue,"U"),$ZCVT(argDTO.SearchValue,"U"),argDTO.HasGB)}
			
			if ((CodeCom '= 1)&&(DescCom '= 1)&&(AliasCom '= 1))
			{	continue}
		}
		
		//处理满足条件的结果并存入临时global
		s totRowCount = totRowCount + 1
		if (argDTO.IsKeepMinus = "0")
		{	s DescValue = $E(DescValue,$F(DescValue,"-"),$L(DescValue)) }
		s:((totRowCount >= argDTO.MinCount)&&(totRowCount <= argDTO.MaxCount)) ^CacheTempStdQuery(argDTO.CookieID,totRowCount) =$LB(rowid,AliasValue,CodeValue,DescValue)
	}
	
	s ^CacheTempStdQuery(argDTO.CookieID,"StdQueryDataCount")= totRowCount
	
	q totRowCount
}

/// Create:	2008-11-27	HouJ
/// Desc:	查询【病人类型】字典内容：EMRview.PatType
/// Input：	argDTO.SearchValue 查询条件；argDTO.DicAliasCol 别名列；argDTO.DicCodeCol 代码列；argDTO.DicDescCol 描述列；ADescHasMinius 描述列是否有横线
ClassMethod SelectStdDicDHCEMRVPatType(argDTO As EMR.DOC.DTO.StdDicParameter) As %Integer
{
	//结果行总数
	s totRowCount = 0
	
	s (CodeValue,DescValue,AliasValue) = ""
	
	&sql(DECLARE MyCursor CURSOR FOR
 	SELECT CtmDictID, CtmDictCode,CtmDictDesc,CtmDictAlias 
 	INTO :ID, :CodeValue, :DescValue, :AliasValue
 	FROM EMRview.PatType WHERE CtmDictID IS NULL)
 	
 
 	&sql(OPEN MyCursor)
 	for  &SQL(FETCH MyCursor) QUIT:SQLCODE  do
	.s (CodeCom,DescCom, AliasCom)=1
	.i argDTO.SearchValue '= "" d
	..s CodeCom= ##Class(EMR.DOC.COM.CheckTool).CheckContain($ZCVT(CodeValue,"U"),$ZCVT(argDTO.SearchValue,"U"),argDTO.HasGB)
	..s DescCom= ##Class(EMR.DOC.COM.CheckTool).CheckContain($ZCVT(DescValue,"U"),$ZCVT(argDTO.SearchValue,"U"),argDTO.HasGB)
	..i ((argDTO.DicAliasCol '="")&&(argDTO.DicAliasCol'=$C(0))) s AliasCom= ##Class(EMR.DOC.COM.CheckTool).CheckContain($ZCVT(AliasValue,"U"),$ZCVT(argDTO.SearchValue,"U"),argDTO.HasGB)
	.i ((CodeCom=1)||(DescCom=1)||(AliasCom=1)) d
	..s totRowCount = totRowCount + 1
	..i (argDTO.IsKeepMinus = "0") s DescValue = $E(DescValue,$F(DescValue,"-"),$L(DescValue))
	..s:((totRowCount >= argDTO.MinCount)&&(totRowCount <= argDTO.MaxCount)) ^CacheTempStdQuery(argDTO.CookieID,totRowCount) =$LB(ID,AliasValue,CodeValue,DescValue)
	&sql(CLOSE MyCursor)
	
	s ^CacheTempStdQuery(argDTO.CookieID,"StdQueryDataCount")= totRowCount
	
	q totRowCount
}

/// Create:	2011-03-30	Wangwt
/// Desc:	查询【麻醉】字典内容：SQLUser.ORC_AnaestMethod
/// Input：	argDTO.SearchValue 查询条件；argDTO.DicAliasCol 别名列；argDTO.DicCodeCol 代码列；argDTO.DicDescCol 描述列；ADescHasMinius 描述列是否有横线
ClassMethod SelectStdDicORCAnaestMethod(argDTO As EMR.DOC.DTO.StdDicParameter) As %Integer
{
	//结果行总数
	s totRowCount = 0
	
	//开始查询
	s rowid = 0
	for {
		s rowid=$o(^ORC("ANMET",rowid))
		quit:(rowid = "")
		
		//取起始时间，不符合则不取
		s dateFrom=$p($g(^ORC("ANMET",rowid)),"^",5)
		s dateTo=$p($g(^ORC("ANMET",rowid)),"^",6)
		s currentDate=$p($h,",",1)
		if (((dateFrom'="")&&(currentDate<dateFrom))||((dateTo'="")&&(currentDate'<dateTo)))
		{	continue}
		
		//取代码列,描述列,别名列
		s CodeValue=$p($g(^ORC("ANMET",rowid)),"^",1)
		s DescValue=$p($g(^ORC("ANMET",rowid)),"^",2)
		//麻醉方式 把描述列转换为简拼
		s AliasValue=##class(EMR.DOC.COM.CodeTool).GetCNCODE(DescValue,4,"")
		
		//是否满足查询条件
		s CodeCom=0, DescCom=0, AliasCom=0
		if (argDTO.SearchValue '= "")
		{	
			
			s CodeCom= ##Class(EMR.DOC.COM.CheckTool).CheckContain($ZCVT(CodeValue,"U"),$ZCVT(argDTO.SearchValue,"U"),argDTO.HasGB)
			S DescCom= ##Class(EMR.DOC.COM.CheckTool).CheckContain($ZCVT(DescValue,"U"),$ZCVT(argDTO.SearchValue,"U"),argDTO.HasGB)
			if ((argDTO.DicAliasCol '="")&&(argDTO.DicAliasCol'=$C(0)))
			{	s AliasCom= ##Class(EMR.DOC.COM.CheckTool).CheckContain($ZCVT(AliasValue,"U"),$ZCVT(argDTO.SearchValue,"U"),argDTO.HasGB)}
			
			if ((CodeCom '= 1)&&(DescCom '= 1)&&(AliasCom '= 1))
			{	continue}
		}
		
		//处理满足条件的结果并存入临时global
		s totRowCount = totRowCount + 1
		if (argDTO.IsKeepMinus = "0")
		{	s DescValue = $E(DescValue,$F(DescValue,"-"),$L(DescValue)) }
		s:((totRowCount >= argDTO.MinCount)&&(totRowCount <= argDTO.MaxCount)) ^CacheTempStdQuery(argDTO.CookieID,totRowCount) =$LB(rowid,AliasValue,CodeValue,DescValue)
	}
	
	s ^CacheTempStdQuery(argDTO.CookieID,"StdQueryDataCount")= totRowCount
	
	q totRowCount
}

/// Create:	2011-09-22	Wangwt
/// Desc:	
/// Input：	argDTO.SearchValue 查询条件；argDTO.DicAliasCol 别名列；argDTO.DicCodeCol 代码列；argDTO.DicDescCol 描述列；ADescHasMinius 描述列是否有横线
ClassMethod SelectStdDicEMRviewOperation(argDTO As EMR.DOC.DTO.StdDicParameter) As %Integer
{
	//结果行总数
	s totRowCount = 0
	
	//开始查询
	s rowid = 0
	for {
		s rowid=$o(^DHCEMRM.CustomDictionaryD(rowid))
		quit:(rowid = "")
		
		//取代码列,描述列,别名列
		s CodeValue=$lg(^DHCEMRM.CustomDictionaryD(rowid),3)
		s DescValue=$lg(^DHCEMRM.CustomDictionaryD(rowid),4)
		s AliasValue=$lg(^DHCEMRM.CustomDictionaryD(rowid),2)
		
		//筛选字典
		s defaultCtmDictStatus = $lg(^DHCEMRM.CustomDictionaryD(rowid),6)
		continue:(defaultCtmDictStatus '= "Y")
		s defaultCtmDictType = $lg(^DHCEMRM.CustomDictionaryD(rowid),7)
		continue:(defaultCtmDictType '= "Operation")
		
		//是否满足查询条件
		s CodeCom=0, DescCom=0, AliasCom=0
		if (argDTO.SearchValue '= "")
		{	
			
			s CodeCom= ##Class(EMR.DOC.COM.CheckTool).CheckContain($ZCVT(CodeValue,"U"),$ZCVT(argDTO.SearchValue,"U"),argDTO.HasGB)
			S DescCom= ##Class(EMR.DOC.COM.CheckTool).CheckContain($ZCVT(DescValue,"U"),$ZCVT(argDTO.SearchValue,"U"),argDTO.HasGB)
			if ((argDTO.DicAliasCol '="")&&(argDTO.DicAliasCol'=$C(0)))
			{	s AliasCom= ##Class(EMR.DOC.COM.CheckTool).CheckContain($ZCVT(AliasValue,"U"),$ZCVT(argDTO.SearchValue,"U"),argDTO.HasGB)}
			
			if ((CodeCom '= 1)&&(DescCom '= 1)&&(AliasCom '= 1))
			{	continue}
		}
		
		
		//处理满足条件的结果并存入临时global
		s totRowCount = totRowCount + 1
		if (argDTO.IsKeepMinus = "0")
		{	s DescValue = $E(DescValue,$F(DescValue,"-"),$L(DescValue)) }
		s:((totRowCount >= argDTO.MinCount)&&(totRowCount <= argDTO.MaxCount)) ^CacheTempStdQuery(argDTO.CookieID,totRowCount) =$LB(rowid,AliasValue,CodeValue,DescValue)
	}
	
	s ^CacheTempStdQuery(argDTO.CookieID,"StdQueryDataCount")= totRowCount
	
	q totRowCount
}

/// Create:	2011-09-26	HouJ
/// Desc:	查询【诊断字典：SQLUser.MRC_ICDDx】内容：诊断
/// Input：	argDTO.SearchValue 查询条件；argDTO.DicAliasCol 别名列；argDTO.DicCodeCol 代码列；argDTO.DicDescCol 描述列；argDTO.HasGB 查询条件是否有中文字符；argDTO.IsKeepMinus 描述列是否有横线
ClassMethod SelectStdDicMRCICDDxDiag(argDTO As EMR.DOC.DTO.StdDicParameter) As %Integer
{
	s groupDR = "1"		//诊断
	s totRowCount = ..GetGroupedMRCICDDx(argDTO, groupDR)
	q totRowCount
}

/// Create:	2011-09-26	HouJ
/// Desc:	查询【诊断字典：SQLUser.MRC_ICDDx】内容：损伤
/// Input：	argDTO.SearchValue 查询条件；argDTO.DicAliasCol 别名列；argDTO.DicCodeCol 代码列；argDTO.DicDescCol 描述列；argDTO.HasGB 查询条件是否有中文字符；argDTO.IsKeepMinus 描述列是否有横线
ClassMethod SelectStdDicMRCICDDxInjury(argDTO As EMR.DOC.DTO.StdDicParameter) As %Integer
{
	s groupDR = "4"		//损伤
	s totRowCount = ..GetGroupedMRCICDDx(argDTO, groupDR)
	q totRowCount
}

/// Create:	2011-09-26	HouJ
/// Desc:	查询【诊断字典：SQLUser.MRC_ICDDx】内容：形态学
/// Input：	argDTO.SearchValue 查询条件；argDTO.DicAliasCol 别名列；argDTO.DicCodeCol 代码列；argDTO.DicDescCol 描述列；argDTO.HasGB 查询条件是否有中文字符；argDTO.IsKeepMinus 描述列是否有横线
ClassMethod SelectStdDicMRCICDDxMorphology(argDTO As EMR.DOC.DTO.StdDicParameter) As %Integer
{
	s groupDR = "2"		//形态学
	s totRowCount = ..GetGroupedMRCICDDx(argDTO, groupDR)
	q totRowCount
}

/// Create:	2011-09-26	HouJ
/// Desc:	查询【诊断字典：SQLUser.MRC_ICDDx】内容：手术
/// Input：	argDTO.SearchValue 查询条件；argDTO.DicAliasCol 别名列；argDTO.DicCodeCol 代码列；argDTO.DicDescCol 描述列；argDTO.HasGB 查询条件是否有中文字符；argDTO.IsKeepMinus 描述列是否有横线
ClassMethod SelectStdDicMRCICDDxOperation(argDTO As EMR.DOC.DTO.StdDicParameter) As %Integer
{
	s groupDR = "3"		//手术
	s totRowCount = ..GetGroupedMRCICDDx(argDTO, groupDR)
	q totRowCount
}

/// Create:	2012-04-01	Wangwt
/// Desc:	查询【诊断字典：SQLUser.MRC_ICDDx】内容：过敏
/// Input：	argDTO.SearchValue 查询条件；argDTO.DicAliasCol 别名列；argDTO.DicCodeCol 代码列；argDTO.DicDescCol 描述列；argDTO.HasGB 查询条件是否有中文字符；argDTO.IsKeepMinus 描述列是否有横线
ClassMethod SelectStdDicMRCICDDxAllergy(argDTO As EMR.DOC.DTO.StdDicParameter) As %Integer
{
	s groupDR = "5"		//过敏
	s totRowCount = ..GetGroupedMRCICDDx(argDTO, groupDR)
	q totRowCount
}

/// Desc:	获取指定分组的ICD字典项目
ClassMethod GetGroupedMRCICDDx(argDTO As EMR.DOC.DTO.StdDicParameter, AGroupDR As %String) As %Integer
{
	//结果行总数
	s totRowCount = 0
	
	//开始查询
	s rowid = 0
	for {
		s rowid=$o(^MRC("ID",rowid))
		quit:(rowid = "")
				
		//get and  validate date of the ICD item.  gjb 2007-12-25
		s dateFrom="",dateTo="",currentDate=""
		s dateFrom=$p($g(^MRC("ID",rowid)),"^",6)
		s dateTo=$p($g(^MRC("ID",rowid)),"^",7)
		s currentDate=$p($h,",",1)
		if (((dateFrom'="")&&(currentDate<dateFrom))||((dateTo'="")&&(currentDate'<dateTo)))
		{	continue}
		
		//校验分组标志
		s groupDR = $p($g(^MRC("ID",rowid)),"^",16)
		continue:(groupDR '= AGroupDR)
		
		//取代码列
		if $zcvt(argDTO.DicCodeCol,"U")="MRCID_ROWID"
		{	
			//诊断字典代码列使用rowid，用在病案首页，方便传rowid给医政组做编目
			s CodeValue = rowid	
		}
		else
		{	s CodeValue=$p($g(^MRC("ID",rowid)),"^",4)	}
		
		//取描述列
		s DescValue=""
		if ($zcvt(argDTO.DicDescCol,"U")="MRCID_LONGDESCRIPTION")
		{	s DescValue=$p($g(^MRC("ID",rowid)),"^",36)}		//for 上海华山
		else
		{	s DescValue=$p($g(^MRC("ID",rowid)),"^",2)}
		
		//取代码列附加信息
		//s ICD9Map=" /"_$p($g(^MRC("ID",rowid)),"^",35)  //Comment and updated by Wangwt 2008-06-27
		s ICD9Map=""
		s ICD9MapRowDR=""
		s ICD9MapRowDR=##Class(EMR.DOC.BL.SysOption).GetOptionValueByName("ICDCodeExpand",argDTO.ProductCode)
		if ICD9MapRowDR="Y"
		{
			s ICD9Map=" /"_$p($g(^MRC("ID",rowid)),"^",35) ;The Fourth Node is Parameter Value	
		}
		s CodeValue=CodeValue_ICD9Map
		
		//取别名列
		s AliasValue=""
		if ((argDTO.DicAliasCol '="")&&(argDTO.DicAliasCol'=$C(0)))
		{ 
			s aliasRowid=0
		  	for {
		  		s aliasRowid=$o(^MRC("ID",rowid,"ALIAS",aliasRowid))
				q:(aliasRowid="")
				s AliasValue=AliasValue_$p($g(^MRC("ID",rowid,"ALIAS",aliasRowid)),"^",1)_$c(2)
		    }
		}
		
		//是否满足查询条件
		s CodeCom=0, DescCom=0, AliasCom=0
		if (argDTO.SearchValue '= "")
		{	
			s CodeCom= ##Class(EMR.DOC.COM.CheckTool).CheckContain($ZCVT(CodeValue,"U"),$ZCVT(argDTO.SearchValue,"U"),argDTO.HasGB)
			S DescCom= ##Class(EMR.DOC.COM.CheckTool).CheckContain($ZCVT(DescValue,"U"),$ZCVT(argDTO.SearchValue,"U"),argDTO.HasGB)
			if ((argDTO.DicAliasCol '="")&&(argDTO.DicAliasCol'=$C(0)))
			{	s AliasCom= ##Class(EMR.DOC.COM.CheckTool).CheckContain($ZCVT(AliasValue,"U"),$ZCVT(argDTO.SearchValue,"U"),argDTO.HasGB)}
			
			if ((CodeCom '= 1)&&(DescCom '= 1)&&(AliasCom '= 1))
			{	continue}
		}
		
		//处理满足条件的结果并存入临时global
		s totRowCount = totRowCount + 1
		s AliasValue = $P(AliasValue,$C(2),1)
		if (argDTO.IsKeepMinus = "0")
		{	s DescValue = $E(DescValue,$F(DescValue,"-"),$L(DescValue)) }
		
		s:((totRowCount >= argDTO.MinCount)&&(totRowCount <= argDTO.MaxCount)) ^CacheTempStdQuery(argDTO.CookieID,totRowCount) =$LB(rowid,AliasValue,CodeValue,DescValue)
	}
	
	s ^CacheTempStdQuery(argDTO.CookieID,"StdQueryDataCount")= totRowCount
	
	q totRowCount
}

/// Create:	2008-11-27	HouJ
/// Desc:	查询【用户】字典内容：SQLUser.MRC_DiagnosSignSymptom
/// Input：	argDTO.SearchValue 查询条件；argDTO.DicAliasCol 别名列；argDTO.DicCodeCol 代码列；argDTO.DicDescCol 描述列；ADescHasMinius 描述列是否有横线
ClassMethod SelectStdDicDiagnosSignSymptom(argDTO As EMR.DOC.DTO.StdDicParameter) As %Integer
{
	//结果行总数
	s totRowCount = 0
	
	//开始查询
	s rowid = 0
	for {
		s rowid=$o(^MRC("DSYM",rowid))
		quit:(rowid = "")
		
		s dateFrom=$p($g(^MRC("DSYM",rowid)),"^",5)
		s dateTo=$p($g(^MRC("DSYM",rowid)),"^",6)
		s currentDate=$p($h,",",1)
		if (((dateFrom'="")&&(currentDate<dateFrom))||((dateTo'="")&&(currentDate'<dateTo)))
		{	continue}
		
		
		//取代码列,描述列,别名列
		if ($zcvt(argDTO.DicCodeCol,"U") = "DSYM_ROWID")
		{s CodeValue=rowid}
		elseif ($zcvt(argDTO.DicCodeCol,"U") = "DSYM_CODE")
		{s CodeValue=$p($g(^MRC("DSYM",rowid)),"^",1)}
		s DescValue=$p($g(^MRC("DSYM",rowid)),"^",2)
		
		s AliasValue=""
		if ((argDTO.DicAliasCol '="")&&(argDTO.DicAliasCol'=$C(0)))
		{
			s childSub = "0"
			for {
				s childSub = $O(^MRC("DSYM",rowid,"ALIAS",childSub))
				q:(childSub="")
				
				if (AliasValue = "")
				{
					s AliasValue = $g(^MRC("DSYM",rowid,"ALIAS",childSub))
				}
				else
				{
					s AliasValue = AliasValue_"|"_$g(^MRC("DSYM",rowid,"ALIAS",childSub))
				}
			}
		}
		//是否满足查询条件
		s CodeCom=0, DescCom=0, AliasCom=0
		if (argDTO.SearchValue '= "")
		{	
			s CodeCom= ##Class(EMR.DOC.COM.CheckTool).CheckContain($ZCVT(CodeValue,"U"),$ZCVT(argDTO.SearchValue,"U"),argDTO.HasGB)
			S DescCom= ##Class(EMR.DOC.COM.CheckTool).CheckContain($ZCVT(DescValue,"U"),$ZCVT(argDTO.SearchValue,"U"),argDTO.HasGB)
			if ((argDTO.DicAliasCol '="")&&(argDTO.DicAliasCol'=$C(0)))
			{	s AliasCom= ##Class(EMR.DOC.COM.CheckTool).CheckContain($ZCVT(AliasValue,"U"),$ZCVT(argDTO.SearchValue,"U"),argDTO.HasGB)}
			
			if ((CodeCom '= 1)&&(DescCom '= 1)&&(AliasCom '= 1))
			{	continue}
		}
		//s AliasValue = ""  //匹配完查询条件后将别名置空
		
		//处理满足条件的结果并存入临时global
		s totRowCount = totRowCount + 1
		if (argDTO.IsKeepMinus = "0")
		{	s DescValue = $E(DescValue,$F(DescValue,"-"),$L(DescValue)) }
		s:((totRowCount >= argDTO.MinCount)&&(totRowCount <= argDTO.MaxCount)) ^CacheTempStdQuery(argDTO.CookieID,totRowCount) =$LB(rowid,AliasValue,CodeValue,DescValue)
	}
	
	s ^CacheTempStdQuery(argDTO.CookieID,"StdQueryDataCount")= totRowCount
	
	q totRowCount
}

/// Desc:      肿瘤形态诊断字典
/// Creator:   Candy
/// CreateDate:2018-1-3
ClassMethod SelectStdMRCICDDXMetastatic(argDTO As EMR.DOC.DTO.StdDicParameter) As %Integer
{
	//结果行总数
	s totRowCount = 0
	//开始查询
	s rowid = 0
	for 
	{
		s rowid = $o(^MRC("ID",0,"Metast","Y",rowid)) 
		quit:(rowid = "")
		s dateFrom = "",dateTo = "",currentDate = ""
		s dateFrom = $p($g(^MRC("ID",rowid)),"^",6)
		s dateTo = $p($g(^MRC("ID",rowid)),"^",7)
		s currentDate = $p($h,",",1)
		continue:(((dateFrom '= "")&&(currentDate < dateFrom))||((dateTo '= "")&&(currentDate '< dateTo)))
		//取代码列
		if $zcvt(argDTO.DicCodeCol,"U") = "MRCID_ROWID"
		{	
			//诊断字典代码列使用rowid，用在病案首页，方便传rowid给医政组做编目
			s CodeValue = rowid	
		}
		else
		{	
			s CodeValue = $p($g(^MRC("ID",rowid)),"^",4)	
		}
		//取描述列
		s DescValue=""
		if ($zcvt(argDTO.DicDescCol,"U") = "MRCID_LONGDESCRIPTION")
		{	
			s DescValue = $p($g(^MRC("ID",rowid)),"^",36)
		}		
		else
		{	
			s DescValue = $p($g(^MRC("ID",rowid)),"^",2)
		}
		//取代码列附加信息
		s ICD9Map = ""
		s ICD9MapRowDR = ""
		s ICD9MapRowDR = ##Class(EMR.DOC.BL.SysOption).GetOptionValueByName("ICDCodeExpand",argDTO.ProductCode)
		s:(ICD9MapRowDR = "Y") ICD9Map=" /"_$p($g(^MRC("ID",rowid)),"^",35) 
		s CodeValue = CodeValue_ICD9Map
		
		//取别名列
		s AliasValue=""
		if ((argDTO.DicAliasCol '="")&&(argDTO.DicAliasCol'=$C(0)))
		{ 
			s aliasRowid=0
		  	for {
		  		s aliasRowid = $o(^MRC("ID",rowid,"ALIAS",aliasRowid))
				q:(aliasRowid = "")
				s AliasValue=AliasValue_$p($g(^MRC("ID",rowid,"ALIAS",aliasRowid)),"^",1)_$c(2)
		    }
		}
		
		//是否满足查询条件
		s CodeCom=0, DescCom=0, AliasCom=0
		if (argDTO.SearchValue '= "")
		{	
			s CodeCom= ##Class(EMR.DOC.COM.CheckTool).CheckContain($ZCVT(CodeValue,"U"),$ZCVT(argDTO.SearchValue,"U"),argDTO.HasGB)
			S DescCom= ##Class(EMR.DOC.COM.CheckTool).CheckContain($ZCVT(DescValue,"U"),$ZCVT(argDTO.SearchValue,"U"),argDTO.HasGB)
			s:((argDTO.DicAliasCol '="")&&(argDTO.DicAliasCol'=$C(0))) AliasCom= ##Class(EMR.DOC.COM.CheckTool).CheckContain($ZCVT(AliasValue,"U"),$ZCVT(argDTO.SearchValue,"U"),argDTO.HasGB)
			continue:((CodeCom '= 1)&&(DescCom '= 1)&&(AliasCom '= 1))
		}
		
		//处理满足条件的结果并存入临时global
		s totRowCount = totRowCount + 1
		s AliasValue = $P(AliasValue,$C(2),1)
		s:(argDTO.IsKeepMinus = "0") DescValue = $E(DescValue,$F(DescValue,"-"),$L(DescValue))
		s:((totRowCount >= argDTO.MinCount)&&(totRowCount <= argDTO.MaxCount)) ^CacheTempStdQuery(argDTO.CookieID,totRowCount) =$LB(rowid,AliasValue,CodeValue,DescValue)				
	}
	s ^CacheTempStdQuery(argDTO.CookieID,"StdQueryDataCount")= totRowCount
	q totRowCount
}

/// Create:	2011-12-21	HouJ
/// Desc:	查询【诊断】字典中  [HIS]ICD10损伤中毒外部因素字典  内容：SQLUser.MRC_ICDDx
/// Input：	argDTO.SearchValue 查询条件；argDTO.DicAliasCol 别名列；argDTO.DicCodeCol 代码列；argDTO.DicDescCol 描述列；argDTO.HasGB 查询条件是否有中文字符；argDTO.IsKeepMinus 描述列是否有横线
ClassMethod SelectStdMRCICDDxInjuryPoison(argDTO As EMR.DOC.DTO.StdDicParameter) As %Integer
{
	
	//结果行总数
	s totRowCount = 0
	
	//开始查询
	s rowid = 0
	for {
		s rowid=$o(^MRC("ID",rowid))
		quit:(rowid = "")
				
		//get and  validate date of the ICD item.  gjb 2007-12-25
		s dateFrom="",dateTo="",currentDate=""
		s dateFrom=$p($g(^MRC("ID",rowid)),"^",6)
		s dateTo=$p($g(^MRC("ID",rowid)),"^",7)
		s currentDate=$p($h,",",1)
		if (((dateFrom'="")&&(currentDate<dateFrom))||((dateTo'="")&&(currentDate'<dateTo)))
		{	continue}
		
		//校验是否 损伤中毒
		s flagCode = $p($g(^MRC("ID",rowid)),"^",4)
		s flagCode = $e(flagCode,1,1)
		continue:((flagCode'="V")&&(flagCode'="W")&&(flagCode'="X")&&(flagCode'="Y")&&(flagCode'="-")&&(flagCode'="/"))	//以VWXY开头的为损伤中毒
		
		//取代码列
		if $zcvt(argDTO.DicCodeCol,"U")="MRCID_ROWID"
		{	
			//诊断字典代码列使用rowid，用在病案首页，方便传rowid给医政组做编目
			s CodeValue = rowid	
		}
		else
		{	s CodeValue=$p($g(^MRC("ID",rowid)),"^",4)	}
		
		//取描述列
		s DescValue=""
		if ($zcvt(argDTO.DicDescCol,"U")="MRCID_LONGDESCRIPTION")
		{	s DescValue=$p($g(^MRC("ID",rowid)),"^",36)}		//for 上海华山
		else
		{	s DescValue=$p($g(^MRC("ID",rowid)),"^",2)}
		
		//取代码列附加信息
		//s ICD9Map=" /"_$p($g(^MRC("ID",rowid)),"^",35)  //Comment and updated by Wangwt 2008-06-27
		s ICD9Map=""
		s ICD9MapRowDR=""
		s ICD9MapRowDR=##Class(EMR.DOC.BL.SysOption).GetOptionValueByName("ICDCodeExpand",argDTO.ProductCode)
		if ICD9MapRowDR="Y"
		{
			s ICD9Map=" /"_$p($g(^MRC("ID",rowid)),"^",35) ;The Fourth Node is Parameter Value	
		}
		s CodeValue=CodeValue_ICD9Map
		
		//取别名列
		s AliasValue=""
		if ((argDTO.DicAliasCol '="")&&(argDTO.DicAliasCol'=$C(0)))
		{ 
			s aliasRowid=0
		  	for {
		  		s aliasRowid=$o(^MRC("ID",rowid,"ALIAS",aliasRowid))
				q:(aliasRowid="")
				s AliasValue=AliasValue_$p($g(^MRC("ID",rowid,"ALIAS",aliasRowid)),"^",1)_$c(2)
		    }
		}
		
		//是否满足查询条件
		s CodeCom=0, DescCom=0, AliasCom=0
		if (argDTO.SearchValue '= "")
		{	
			s CodeCom= ##Class(EMR.DOC.COM.CheckTool).CheckContain($ZCVT(CodeValue,"U"),$ZCVT(argDTO.SearchValue,"U"),argDTO.HasGB)
			S DescCom= ##Class(EMR.DOC.COM.CheckTool).CheckContain($ZCVT(DescValue,"U"),$ZCVT(argDTO.SearchValue,"U"),argDTO.HasGB)
			if ((argDTO.DicAliasCol '="")&&(argDTO.DicAliasCol'=$C(0)))
			{	s AliasCom= ##Class(EMR.DOC.COM.CheckTool).CheckContain($ZCVT(AliasValue,"U"),$ZCVT(argDTO.SearchValue,"U"),argDTO.HasGB)}
			
			if ((CodeCom '= 1)&&(DescCom '= 1)&&(AliasCom '= 1))
			{	continue}
		}
		
		//处理满足条件的结果并存入临时global
		s totRowCount = totRowCount + 1
		s AliasValue = $P(AliasValue,$C(2),1)
		if (argDTO.IsKeepMinus = "0")
		{	s DescValue = $E(DescValue,$F(DescValue,"-"),$L(DescValue)) }
		
		s:((totRowCount >= argDTO.MinCount)&&(totRowCount <= argDTO.MaxCount)) ^CacheTempStdQuery(argDTO.CookieID,totRowCount) =$LB(rowid,AliasValue,CodeValue,DescValue)
	}
	
	s ^CacheTempStdQuery(argDTO.CookieID,"StdQueryDataCount")= totRowCount
	
	q totRowCount
}

/// Create:	2012-02-03 Wangwt
/// Desc:	查询【诊断】字典中  [HIS]ICD10病理诊断字典  内容：SQLUser.MRC_ICDDx
/// Input：	argDTO.SearchValue 查询条件；argDTO.DicAliasCol 别名列；argDTO.DicCodeCol 代码列；argDTO.DicDescCol 描述列；argDTO.HasGB 查询条件是否有中文字符；argDTO.IsKeepMinus 描述列是否有横线
ClassMethod SelectStdMRCICDDxPathology(argDTO As EMR.DOC.DTO.StdDicParameter) As %Integer
{
	
	//结果行总数
	s totRowCount = 0
	
	//开始查询
	s rowid = 0
	for {
		s rowid=$o(^MRC("ID",rowid))
		quit:(rowid = "")
				
		//get and  validate date of the ICD item.  gjb 2007-12-25
		s dateFrom="",dateTo="",currentDate=""
		s dateFrom=$p($g(^MRC("ID",rowid)),"^",6)
		s dateTo=$p($g(^MRC("ID",rowid)),"^",7)
		s currentDate=$p($h,",",1)
		if (((dateFrom'="")&&(currentDate<dateFrom))||((dateTo'="")&&(currentDate'<dateTo)))
		{	continue}
		
		
		//校验ICD10是否 病理诊断 以M开头的为损伤中毒
		s flagCode = $p($g(^MRC("ID",rowid)),"^",4)
		//continue:(($e(flagCode,1) '= "M")&&($e(flagCode,1) '= "-")&&($e(flagCode,1) '= "/"))
		s HospitalName=##class(EMR.DOC.BL.SysOption).GetOptionValueByName("HospitalName",argDTO.ProductCode)
	 	if HospitalName = "BeiJingFXYY" 
	 	{
			continue:(($e(flagCode,1,2) '= "M8")&&($e(flagCode,1,2) '= "M9"))
			continue:(flagCode'[ "/")
			continue:(flagCode[ ".")
		}
		elseif HospitalName = "DtHealthXN"
		{
		   s flag =  $p($g(^MRC("ID",rowid)),"^",40) 
		   continue:(flag'="Y") 	
			
		}
		elseif HospitalName = "BeiJingYKYZHongLiuYY"   //医科院肿瘤只要 MRCID_MetastaticSite='Y' 的诊断19.10.10
	 	{
			continue:($p($g(^MRC("ID",rowid)),"^",40)'="Y")
			//continue:(flagCode[ ".")
		}
		else
		{
			continue:(($e(flagCode,1) = "V")||($e(flagCode,1) = "W")||($e(flagCode,1) = "X")||($e(flagCode,1) = "Y"))
		}

		//取代码列
		if $zcvt(argDTO.DicCodeCol,"U")="MRCID_ROWID"
		{	
			//诊断字典代码列使用rowid，用在病案首页，方便传rowid给医政组做编目
			s CodeValue = rowid	
		}
		else
		{	s CodeValue=$p($g(^MRC("ID",rowid)),"^",4)	}
		
		//取描述列
		s DescValue=""
		if ($zcvt(argDTO.DicDescCol,"U")="MRCID_LONGDESCRIPTION")
		{	s DescValue=$p($g(^MRC("ID",rowid)),"^",36)}		//for 上海华山
		else
		{	s DescValue=$p($g(^MRC("ID",rowid)),"^",2)}
		
		//取代码列附加信息
		//s ICD9Map=" /"_$p($g(^MRC("ID",rowid)),"^",35)  //Comment and updated by Wangwt 2008-06-27
		s ICD9Map=""
		s ICD9MapRowDR=""
		s ICD9MapRowDR=##Class(EMR.DOC.BL.SysOption).GetOptionValueByName("ICDCodeExpand",argDTO.ProductCode)
		if ICD9MapRowDR="Y"
		{
			s ICD9Map=" /"_$p($g(^MRC("ID",rowid)),"^",35) ;The Fourth Node is Parameter Value	
		}
		s CodeValue=CodeValue_ICD9Map
		
		//取别名列
		s AliasValue=""
		if ((argDTO.DicAliasCol '="")&&(argDTO.DicAliasCol'=$C(0)))
		{ 
			s aliasRowid=0
		  	for {
		  		s aliasRowid=$o(^MRC("ID",rowid,"ALIAS",aliasRowid))
				q:(aliasRowid="")
				s AliasValue=AliasValue_$p($g(^MRC("ID",rowid,"ALIAS",aliasRowid)),"^",1)_$c(2)
		    }
		}
		
		//是否满足查询条件
		s CodeCom=0, DescCom=0, AliasCom=0
		if (argDTO.SearchValue '= "")
		{	
			s CodeCom= ##Class(EMR.DOC.COM.CheckTool).CheckContain($ZCVT(CodeValue,"U"),$ZCVT(argDTO.SearchValue,"U"),argDTO.HasGB)
			S DescCom= ##Class(EMR.DOC.COM.CheckTool).CheckContain($ZCVT(DescValue,"U"),$ZCVT(argDTO.SearchValue,"U"),argDTO.HasGB)
			if ((argDTO.DicAliasCol '="")&&(argDTO.DicAliasCol'=$C(0)))
			{	s AliasCom= ##Class(EMR.DOC.COM.CheckTool).CheckContain($ZCVT(AliasValue,"U"),$ZCVT(argDTO.SearchValue,"U"),argDTO.HasGB)}
			
			if ((CodeCom '= 1)&&(DescCom '= 1)&&(AliasCom '= 1))
			{	continue}
		}
		
		//处理满足条件的结果并存入临时global
		s totRowCount = totRowCount + 1
		s AliasValue = $P(AliasValue,$C(2),1)
		if (argDTO.IsKeepMinus = "0")
		{	s DescValue = $E(DescValue,$F(DescValue,"-"),$L(DescValue)) }
		
		s:((totRowCount >= argDTO.MinCount)&&(totRowCount <= argDTO.MaxCount)) ^CacheTempStdQuery(argDTO.CookieID,totRowCount) =$LB(rowid,AliasValue,CodeValue,DescValue)
	}
	
	s ^CacheTempStdQuery(argDTO.CookieID,"StdQueryDataCount")= totRowCount
	
	q totRowCount
}

/// Create:	2012-02-03 Wangwt
/// Desc:	查询【诊断】字典中  [HIS]ICD10过敏类别字典  内容：SQLUser.MRC_ICDDx
/// Input：	argDTO.SearchValue 查询条件；argDTO.DicAliasCol 别名列；argDTO.DicCodeCol 代码列；argDTO.DicDescCol 描述列；argDTO.HasGB 查询条件是否有中文字符；argDTO.IsKeepMinus 描述列是否有横线
ClassMethod SelectStdMRCICDDxMedAllergy(argDTO As EMR.DOC.DTO.StdDicParameter) As %Integer
{
	
	//结果行总数
	s totRowCount = 0
	
	//开始查询
	s rowid = 0
	for {
		s rowid=$o(^MRC("ID",rowid))
		quit:(rowid = "")
				
		//get and  validate date of the ICD item.  gjb 2007-12-25
		s dateFrom="",dateTo="",currentDate=""
		s dateFrom=$p($g(^MRC("ID",rowid)),"^",6)
		s dateTo=$p($g(^MRC("ID",rowid)),"^",7)
		s currentDate=$p($h,",",1)
		if (((dateFrom'="")&&(currentDate<dateFrom))||((dateTo'="")&&(currentDate'<dateTo)))
		{	continue}


		//校验ICD10是否 过敏类别 以Y40~Y59开头的为过敏类别
		s flagCode = $p($g(^MRC("ID",rowid)),"^",4)
		continue:(($e(flagCode,1,3) '= "Y40")&&($e(flagCode,1,3) '= "Y41")&&($e(flagCode,1,3) '= "Y42")&&($e(flagCode,1,3) '= "Y43")&&($e(flagCode,1,3) '= "Y44")&&($e(flagCode,1,3) '= "Y45")&&($e(flagCode,1,3) '= "Y46")&&($e(flagCode,1,3) '= "Y47")&&($e(flagCode,1,3) '= "Y48")&&($e(flagCode,1,3) '= "Y49")&&($e(flagCode,1,3) '= "Y50")&&($e(flagCode,1,3) '= "Y51")&&($e(flagCode,1,3) '= "Y52")&&($e(flagCode,1,3) '= "Y53")&&($e(flagCode,1,3) '= "Y54")&&($e(flagCode,1,3) '= "Y55")&&($e(flagCode,1,3) '= "Y56")&&($e(flagCode,1,3) '= "Y57")&&($e(flagCode,1,3) '= "Y58")&&($e(flagCode,1,3) '= "Y59")&&($e(flagCode,1) '= "-")&&($e(flagCode,1) '= "/"))

		
		//取代码列
		if $zcvt(argDTO.DicCodeCol,"U")="MRCID_ROWID"
		{	
			//诊断字典代码列使用rowid，用在病案首页，方便传rowid给医政组做编目
			s CodeValue = rowid	
		}
		else
		{	s CodeValue=$p($g(^MRC("ID",rowid)),"^",4)	}
		
		//取描述列
		s DescValue=""
		if ($zcvt(argDTO.DicDescCol,"U")="MRCID_LONGDESCRIPTION")
		{	s DescValue=$p($g(^MRC("ID",rowid)),"^",36)}		//for 上海华山
		else
		{	s DescValue=$p($g(^MRC("ID",rowid)),"^",2)}
		
		//取代码列附加信息
		//s ICD9Map=" /"_$p($g(^MRC("ID",rowid)),"^",35)  //Comment and updated by Wangwt 2008-06-27
		s ICD9Map=""
		s ICD9MapRowDR=""
		s ICD9MapRowDR=##Class(EMR.DOC.BL.SysOption).GetOptionValueByName("ICDCodeExpand",argDTO.ProductCode)
		if ICD9MapRowDR="Y"
		{
			s ICD9Map=" /"_$p($g(^MRC("ID",rowid)),"^",35) ;The Fourth Node is Parameter Value	
		}
		s CodeValue=CodeValue_ICD9Map
		
		//取别名列
		s AliasValue=""
		if ((argDTO.DicAliasCol '="")&&(argDTO.DicAliasCol'=$C(0)))
		{ 
			s aliasRowid=0
		  	for {
		  		s aliasRowid=$o(^MRC("ID",rowid,"ALIAS",aliasRowid))
				q:(aliasRowid="")
				s AliasValue=AliasValue_$p($g(^MRC("ID",rowid,"ALIAS",aliasRowid)),"^",1)_$c(2)
		    }
		}
		
		//是否满足查询条件
		s CodeCom=0, DescCom=0, AliasCom=0
		if (argDTO.SearchValue '= "")
		{	
			s CodeCom= ##Class(EMR.DOC.COM.CheckTool).CheckContain($ZCVT(CodeValue,"U"),$ZCVT(argDTO.SearchValue,"U"),argDTO.HasGB)
			S DescCom= ##Class(EMR.DOC.COM.CheckTool).CheckContain($ZCVT(DescValue,"U"),$ZCVT(argDTO.SearchValue,"U"),argDTO.HasGB)
			if ((argDTO.DicAliasCol '="")&&(argDTO.DicAliasCol'=$C(0)))
			{	s AliasCom= ##Class(EMR.DOC.COM.CheckTool).CheckContain($ZCVT(AliasValue,"U"),$ZCVT(argDTO.SearchValue,"U"),argDTO.HasGB)}
			
			if ((CodeCom '= 1)&&(DescCom '= 1)&&(AliasCom '= 1))
			{	continue}
		}
		
		//处理满足条件的结果并存入临时global
		s totRowCount = totRowCount + 1
		s AliasValue = $P(AliasValue,$C(2),1)
		if (argDTO.IsKeepMinus = "0")
		{	s DescValue = $E(DescValue,$F(DescValue,"-"),$L(DescValue)) }
		
		s:((totRowCount >= argDTO.MinCount)&&(totRowCount <= argDTO.MaxCount)) ^CacheTempStdQuery(argDTO.CookieID,totRowCount) =$LB(rowid,AliasValue,CodeValue,DescValue)
	}
	
	s ^CacheTempStdQuery(argDTO.CookieID,"StdQueryDataCount")= totRowCount
	
	q totRowCount
}

/// Create:	2012-02-03 Wangwt
/// Desc:	查询【诊断】字典中  [HIS]ICD10住院诊断字典  内容：SQLUser.MRC_ICDDx
/// Input：	argDTO.SearchValue 查询条件；argDTO.DicAliasCol 别名列；argDTO.DicCodeCol 代码列；argDTO.DicDescCol 描述列；argDTO.HasGB 查询条件是否有中文字符；argDTO.IsKeepMinus 描述列是否有横线
ClassMethod SelectStdMRCICDDxInpatient(argDTO As EMR.DOC.DTO.StdDicParameter) As %Integer
{
	
	//结果行总数
	s totRowCount = 0
	
	//开始查询
	s rowid = 0
	for {
		s rowid=$o(^MRC("ID",rowid))
		quit:(rowid = "")
				
		//get and  validate date of the ICD item.  gjb 2007-12-25
		s dateFrom="",dateTo="",currentDate=""
		s dateFrom=$p($g(^MRC("ID",rowid)),"^",6)
		s dateTo=$p($g(^MRC("ID",rowid)),"^",7)
		s currentDate=$p($h,",",1)
		if (((dateFrom'="")&&(currentDate<dateFrom))||((dateTo'="")&&(currentDate'<dateTo)))
		{	continue}

		
		//校验ICD10是否 出院诊断 不包括V或W或X或Y开头
		s flagCode = $p($g(^MRC("ID",rowid)),"^",4)
		continue:(($e(flagCode,1) = "V")||($e(flagCode,1) = "W")||($e(flagCode,1) = "X")||($e(flagCode,1) = "Y"))

		//20130523 wangwentao add
		//校验ICD10,北京门诊首页过滤门诊诊断
		//MRCID_MorphologyCode {"Y":门诊诊断,"N":住院诊断,"":通用诊断}
		s flagCode = $p($g(^MRC("ID",rowid)),"^",38)
		continue:($zcvt(flagCode,"U")="Y")
	
		
		//取代码列
		if $zcvt(argDTO.DicCodeCol,"U")="MRCID_ROWID"
		{	
			//诊断字典代码列使用rowid，用在病案首页，方便传rowid给医政组做编目
			s CodeValue = rowid	
		}
		else
		{	s CodeValue=$p($g(^MRC("ID",rowid)),"^",4)	}
		
		//取描述列
		s DescValue=""
		if ($zcvt(argDTO.DicDescCol,"U")="MRCID_LONGDESCRIPTION")
		{	s DescValue=$p($g(^MRC("ID",rowid)),"^",36)}		//for 上海华山
		else
		{	s DescValue=$p($g(^MRC("ID",rowid)),"^",2)}
		
		//取代码列附加信息
		//s ICD9Map=" /"_$p($g(^MRC("ID",rowid)),"^",35)  //Comment and updated by Wangwt 2008-06-27
		s ICD9Map=""
		s ICD9MapRowDR=""
		s ICD9MapRowDR=##Class(EMR.DOC.BL.SysOption).GetOptionValueByName("ICDCodeExpand",argDTO.ProductCode)
		if ICD9MapRowDR="Y"
		{
			s ICD9Map=" /"_$p($g(^MRC("ID",rowid)),"^",35) ;The Fourth Node is Parameter Value	
		}
		s CodeValue=CodeValue_ICD9Map
		
		//取别名列
		s AliasValue=""
		if ((argDTO.DicAliasCol '="")&&(argDTO.DicAliasCol'=$C(0)))
		{ 
			s aliasRowid=0
		  	for {
		  		s aliasRowid=$o(^MRC("ID",rowid,"ALIAS",aliasRowid))
				q:(aliasRowid="")
				s AliasValue=AliasValue_$p($g(^MRC("ID",rowid,"ALIAS",aliasRowid)),"^",1)_$c(2)
		    }
		}
		
		//是否满足查询条件
		s CodeCom=0, DescCom=0, AliasCom=0
		if (argDTO.SearchValue '= "")
		{	
			s CodeCom= ##Class(EMR.DOC.COM.CheckTool).CheckContain($ZCVT(CodeValue,"U"),$ZCVT(argDTO.SearchValue,"U"),argDTO.HasGB)
			S DescCom= ##Class(EMR.DOC.COM.CheckTool).CheckContain($ZCVT(DescValue,"U"),$ZCVT(argDTO.SearchValue,"U"),argDTO.HasGB)
			if ((argDTO.DicAliasCol '="")&&(argDTO.DicAliasCol'=$C(0)))
			{	s AliasCom= ##Class(EMR.DOC.COM.CheckTool).CheckContain($ZCVT(AliasValue,"U"),$ZCVT(argDTO.SearchValue,"U"),argDTO.HasGB)}
			
			if ((CodeCom '= 1)&&(DescCom '= 1)&&(AliasCom '= 1))
			{	continue}
		}
		
		//处理满足条件的结果并存入临时global
		s totRowCount = totRowCount + 1
		s AliasValue = $P(AliasValue,$C(2),1)
		if (argDTO.IsKeepMinus = "0")
		{	s DescValue = $E(DescValue,$F(DescValue,"-"),$L(DescValue)) }
		
		s:((totRowCount >= argDTO.MinCount)&&(totRowCount <= argDTO.MaxCount)) ^CacheTempStdQuery(argDTO.CookieID,totRowCount) =$LB(rowid,AliasValue,CodeValue,DescValue)
	}
	
	s ^CacheTempStdQuery(argDTO.CookieID,"StdQueryDataCount")= totRowCount
	
	q totRowCount
}

/// Create:	2012-1-4	HouJ
/// Desc:	查询【科室】字典内容：SQLUser.CT_HealthCareRegion
/// Input：	argDTO.SearchValue 查询条件；argDTO.DicAliasCol 别名列；argDTO.DicCodeCol 代码列；argDTO.DicDescCol 描述列；ADescHasMinius 描述列是否有横线
ClassMethod SelectStdDicCTHealthCareRegion(argDTO As EMR.DOC.DTO.StdDicParameter) As %Integer
{
	//结果行总数
	s totRowCount = 0
	
	//开始查询
	s rowid = 0
	for {
		s rowid=$o(^CT("HCR",rowid))
		quit:(rowid = "")
		
		//取代码列,描述列,别名列
		if ($zcvt(argDTO.DicCodeCol,"U") = "HCR_CODE")
		{	s CodeValue=$p($g(^CT("HCR",rowid)),"^",1)}
		elseif ($zcvt(argDTO.DicCodeCol,"U") = "HCR_ROWID")
		{	s CodeValue=rowid}
		
		s DescValue=$p($g(^CT("HCR",rowid)),"^",2)
		
		s AliasValue=""
		
		//是否满足查询条件
		s CodeCom=0, DescCom=0, AliasCom=0
		if (argDTO.SearchValue '= "")
		{	
			s CodeCom= ##Class(EMR.DOC.COM.CheckTool).CheckContain($ZCVT(CodeValue,"U"),$ZCVT(argDTO.SearchValue,"U"),argDTO.HasGB)
			S DescCom= ##Class(EMR.DOC.COM.CheckTool).CheckContain($ZCVT(DescValue,"U"),$ZCVT(argDTO.SearchValue,"U"),argDTO.HasGB)
			if ((argDTO.DicAliasCol '="")&&(argDTO.DicAliasCol'=$C(0)))
			{	s AliasCom= ##Class(EMR.DOC.COM.CheckTool).CheckContain($ZCVT(AliasValue,"U"),$ZCVT(argDTO.SearchValue,"U"),argDTO.HasGB)}
			
			if ((CodeCom '= 1)&&(DescCom '= 1)&&(AliasCom '= 1))
			{	continue}
		}
		
		//处理满足条件的结果并存入临时global
		s totRowCount = totRowCount + 1
		if (argDTO.IsKeepMinus = "0")
		{	s DescValue = $E(DescValue,$F(DescValue,"-"),$L(DescValue)) }
		s:((totRowCount >= argDTO.MinCount)&&(totRowCount <= argDTO.MaxCount)) ^CacheTempStdQuery(argDTO.CookieID,totRowCount) =$LB(rowid,AliasValue,CodeValue,DescValue)
	}
	
	s ^CacheTempStdQuery(argDTO.CookieID,"StdQueryDataCount")= totRowCount
	
	q totRowCount
}

/// Create:	2013-05-14	wangwentao
/// Desc:	查询【诊断字典：SQLUser.DHC_WMR_ICDDx】内容：医政编目诊断
/// Input：	argDTO.SearchValue 查询条件；argDTO.DicAliasCol 别名列；argDTO.DicCodeCol 代码列；argDTO.DicDescCol 描述列；argDTO.HasGB 查询条件是否有中文字符；argDTO.IsKeepMinus 描述列是否有横线
ClassMethod SelectStdDicWMRICDDxDiag(argDTO As EMR.DOC.DTO.StdDicParameter) As %Integer
{
	s groupDR = ..GetStdDicWMRICDDxGroupDR(91)		//医政编目诊断
	s totRowCount = ..GetGroupedDHCWMRICDDx(argDTO, groupDR)
	q totRowCount
}

/// Create:	2013-05-14	wangwentao
/// Desc:	查询【诊断字典：SQLUser.DHC_WMR_ICDDx】内容：医政编目病理形态学
/// Input：	argDTO.SearchValue 查询条件；argDTO.DicAliasCol 别名列；argDTO.DicCodeCol 代码列；argDTO.DicDescCol 描述列；argDTO.HasGB 查询条件是否有中文字符；argDTO.IsKeepMinus 描述列是否有横线
ClassMethod SelectStdDicWMRICDDxMorphology(argDTO As EMR.DOC.DTO.StdDicParameter) As %Integer
{
	s groupDR = ..GetStdDicWMRICDDxGroupDR(92)		//医政编目病理形态学
	s totRowCount = ..GetGroupedDHCWMRICDDx(argDTO, groupDR)
	q totRowCount
}

/// Create:	2013-05-14	wangwentao
/// Desc:	查询【诊断字典：SQLUser.DHC_WMR_ICDDx】内容：医政编目手术
/// Input：	argDTO.SearchValue 查询条件；argDTO.DicAliasCol 别名列；argDTO.DicCodeCol 代码列；argDTO.DicDescCol 描述列；argDTO.HasGB 查询条件是否有中文字符；argDTO.IsKeepMinus 描述列是否有横线
ClassMethod SelectStdDicWMRICDDxOperation(argDTO As EMR.DOC.DTO.StdDicParameter) As %Integer
{
	s groupDR = ..GetStdDicWMRICDDxGroupDR(93)		//医政编目手术
	s totRowCount = ..GetGroupedDHCWMRICDDx(argDTO, groupDR)
	q totRowCount
}

/// Create:	2013-05-14	wangwentao
/// Desc:	查询【诊断字典：SQLUser.DHC_WMR_ICDDx】内容：医政编目损伤
/// Input：	argDTO.SearchValue 查询条件；argDTO.DicAliasCol 别名列；argDTO.DicCodeCol 代码列；argDTO.DicDescCol 描述列；argDTO.HasGB 查询条件是否有中文字符；argDTO.IsKeepMinus 描述列是否有横线
ClassMethod SelectStdDicWMRICDDxInjury(argDTO As EMR.DOC.DTO.StdDicParameter) As %Integer
{
	s groupDR = ..GetStdDicWMRICDDxGroupDR(94)		//医政编目损伤
	s totRowCount = ..GetGroupedDHCWMRICDDx(argDTO, groupDR)
	q totRowCount
}

/// Create:	2013-05-14	wangwentao
/// Desc:	查询【诊断字典：SQLUser.DHC_WMR_ICDDx】内容：医政编目过敏
/// Input：	argDTO.SearchValue 查询条件；argDTO.DicAliasCol 别名列；argDTO.DicCodeCol 代码列；argDTO.DicDescCol 描述列；argDTO.HasGB 查询条件是否有中文字符；argDTO.IsKeepMinus 描述列是否有横线
ClassMethod SelectStdDicWMRICDDxAllergy(argDTO As EMR.DOC.DTO.StdDicParameter) As %Integer
{
	s groupDR = ..GetStdDicWMRICDDxGroupDR(95)		//医政编目过敏
	s totRowCount = ..GetGroupedDHCWMRICDDx(argDTO, groupDR)
	q totRowCount
}

/// Create:	2013-09-18	wangwentao
/// Desc:	查询【诊断字典：SQLUser.DHC_WMR_ICDDx】内容：由SQL修改为Global方式,通过版本代码获取版本RowId
/// Input：	ACode
ClassMethod GetStdDicWMRICDDxGroupDR(ACode As %String) As %Integer
{
	//SQLUser.DHC_WMR_ICDVersion
	//91	诊断(临床版)
	//92	病理(临床版)
	//93	手术(临床版)
	//94	损伤中毒(临床版)
	
	//返回值
	s VersionRowId = ""
	
	//开始查询
	s rowid = 0
	for {
		s rowid=$o(^DHCWMRICDV(rowid))
		quit:(rowid = "")||(VersionRowId'="")
		
		s VersionCode = +$g(^DHCWMRICDV(rowid))
		continue:(VersionCode'=ACode)
		s VersionRowId = rowid		
	}

	q VersionRowId
}

/// Desc:	获取指定分组的ICD字典项目 从医政字典表 SQLUser.DHC_WMR_ICDDx //SQLUser.DHC_WMR_ICDAlias //SQLUser.DHC_WMR_ICDVersion
ClassMethod GetGroupedDHCWMRICDDx(argDTO As EMR.DOC.DTO.StdDicParameter, AGroupDR As %String) As %Integer
{
	//结果行总数
	s totRowCount = 0
	
	//开始查询
	s rowid = 0
	for {
		s rowid=$o(^DHCWMRICD(rowid))
		quit:(rowid = "")
				
		//校验医政字典项目是否可用 [SQLUser.DHC_WMR_ICDDx.IsActive]
		s IsActive = $p($g(^DHCWMRICD(rowid)),"^",6)
		continue:($ZCVT(IsActive,"U") '= "Y")
		
		//校验医政字典分组标志 [SQLUser.DHC_WMR_ICDDx.Version]
		s groupDR = $p($g(^DHCWMRICD(rowid)),"^",4)
		continue:(groupDR '= AGroupDR)
		
		//取代码列
		if $zcvt(argDTO.DicCodeCol,"U")="ICD1"
		{	
			// [SQLUser.DHC_WMR_ICDDx.ICD1]
			s CodeValue = $p($g(^DHCWMRICD(rowid)),"^",2)	
		}
		else
		{
			// [SQLUser.DHC_WMR_ICDDx.ICD]
			s CodeValue = $p($g(^DHCWMRICD(rowid)),"^",1)
		}
		
		//取描述列 [SQLUser.DHC_WMR_ICDDx.Name]
		s DescValue=""
		s DescValue=$p($g(^DHCWMRICD(rowid)),"^",3)
		
		//取别名列
		s AliasValue=""
		if ((argDTO.DicAliasCol '="")&&(argDTO.DicAliasCol'=$C(0)))
		{ 
			s aliasRowid=0
		  	for {
			  	// ^DHCWMRICDA(0,"ICDDxDr",{ICDDxDr},{RowId}) 
		  		s aliasRowid=$o(^DHCWMRICDA(0,"ICDDxDr",rowid,aliasRowid))
				q:(aliasRowid="")
				// [SQLUser.DHC_WMR_ICDAlias.Alias]
				s AliasValue=AliasValue_$p($g(^DHCWMRICDA(aliasRowid)),"^",2)_$c(2)
		    }
		}
		
		//是否满足查询条件
		s CodeCom=0, DescCom=0, AliasCom=0
		if (argDTO.SearchValue '= "")
		{	
			s CodeCom= ##Class(EMR.DOC.COM.CheckTool).CheckContain($ZCVT(CodeValue,"U"),$ZCVT(argDTO.SearchValue,"U"),argDTO.HasGB)
			S DescCom= ##Class(EMR.DOC.COM.CheckTool).CheckContain($ZCVT(DescValue,"U"),$ZCVT(argDTO.SearchValue,"U"),argDTO.HasGB)
			if ((argDTO.DicAliasCol '="")&&(argDTO.DicAliasCol'=$C(0)))
			{	s AliasCom= ##Class(EMR.DOC.COM.CheckTool).CheckContain($ZCVT(AliasValue,"U"),$ZCVT(argDTO.SearchValue,"U"),argDTO.HasGB)}
			
			if ((CodeCom '= 1)&&(DescCom '= 1)&&(AliasCom '= 1))
			{	continue}
		}
		
		//处理满足条件的结果并存入临时global
		s totRowCount = totRowCount + 1
		s AliasValue = $P(AliasValue,$C(2),1)
		if (argDTO.IsKeepMinus = "0")
		{	s DescValue = $E(DescValue,$F(DescValue,"-"),$L(DescValue)) }
		
		s:((totRowCount >= argDTO.MinCount)&&(totRowCount <= argDTO.MaxCount)) ^CacheTempStdQuery(argDTO.CookieID,totRowCount) =$LB(rowid,AliasValue,CodeValue,DescValue)
	}
	
	s ^CacheTempStdQuery(argDTO.CookieID,"StdQueryDataCount")= totRowCount
	
	q totRowCount
}

/// Create:	2013-05-23	wangwentao
/// Desc:	查询【诊断】字典内容：SQLUser.MRC_ICDDxOP
/// Input：	argDTO.SearchValue 查询条件；argDTO.DicAliasCol 别名列；argDTO.DicCodeCol 代码列；argDTO.DicDescCol 描述列；argDTO.HasGB 查询条件是否有中文字符；argDTO.IsKeepMinus 描述列是否有横线
ClassMethod SelectStdDicMRCICDDxOP(argDTO As EMR.DOC.DTO.StdDicParameter) As %Integer
{
	
	//结果行总数
	s totRowCount = 0
	
	//开始查询
	s rowid = 0
	for {
		s rowid=$o(^MRC("ID",rowid))
		quit:(rowid = "")
				
		//get and  validate date of the ICD item.  gjb 2007-12-25
		s dateFrom="",dateTo="",currentDate=""
		s dateFrom=$p($g(^MRC("ID",rowid)),"^",6)
		s dateTo=$p($g(^MRC("ID",rowid)),"^",7)
		s currentDate=$p($h,",",1)
		if (((dateFrom'="")&&(currentDate<dateFrom))||((dateTo'="")&&(currentDate'<dateTo)))
		{	continue}
		
		//20130523 wangwentao add
		//校验ICD10,北京门诊首页过滤住院诊断
		//MRCID_MorphologyCode {"Y":门诊诊断,"N":住院诊断,"":通用诊断}
		s flagCode = $p($g(^MRC("ID",rowid)),"^",38)
		s HospitalName=##class(EMR.DOC.BL.SysOption).GetOptionValueByName("HospitalName",argDTO.ProductCode)
	 	if HospitalName = "BeiJingFXYY" 
	 	{
			//校验ICD10,北京复兴医院过滤住院诊断，MRCID_MorphologyCode {门诊是N，住院是Y}
			continue:($zcvt(flagCode,"U")="Y")
		}
		else
		{
			continue:($zcvt(flagCode,"U")="N")
		}
		
		//取代码列
		if $zcvt(argDTO.DicCodeCol,"U")="MRCID_ROWID"
		{	
			//诊断字典代码列使用rowid，用在病案首页，方便传rowid给医政组做编目
			s CodeValue = rowid	
		}
		else
		{	s CodeValue=$p($g(^MRC("ID",rowid)),"^",4)	}
		
		//取描述列
		s DescValue=""
		if ($zcvt(argDTO.DicDescCol,"U")="MRCID_LONGDESCRIPTION")
		{	s DescValue=$p($g(^MRC("ID",rowid)),"^",36)}		//for 上海华山
		else
		{	s DescValue=$p($g(^MRC("ID",rowid)),"^",2)}
		
		//取代码列附加信息
		//s ICD9Map=" /"_$p($g(^MRC("ID",rowid)),"^",35)  //Comment and updated by Wangwt 2008-06-27
		s ICD9Map=""
		s ICD9MapRowDR=""
		s ICD9MapRowDR=##Class(EMR.DOC.BL.SysOption).GetOptionValueByName("ICDCodeExpand",argDTO.ProductCode)
		if ICD9MapRowDR="Y"
		{
			s ICD9Map=" /"_$p($g(^MRC("ID",rowid)),"^",35) ;The Fourth Node is Parameter Value	
		}
		s CodeValue=CodeValue_ICD9Map
		
		//取别名列
		s AliasValue=""
		if ((argDTO.DicAliasCol '="")&&(argDTO.DicAliasCol'=$C(0)))
		{ 
			s aliasRowid=0
		  	for {
		  		s aliasRowid=$o(^MRC("ID",rowid,"ALIAS",aliasRowid))
				q:(aliasRowid="")
				s AliasValue=AliasValue_$p($g(^MRC("ID",rowid,"ALIAS",aliasRowid)),"^",1)_$c(2)
		    }
		}
		
		//是否满足查询条件
		s CodeCom=0, DescCom=0, AliasCom=0
		if (argDTO.SearchValue '= "")
		{	
			s CodeCom= ##Class(EMR.DOC.COM.CheckTool).CheckContain($ZCVT(CodeValue,"U"),$ZCVT(argDTO.SearchValue,"U"),argDTO.HasGB)
			S DescCom= ##Class(EMR.DOC.COM.CheckTool).CheckContain($ZCVT(DescValue,"U"),$ZCVT(argDTO.SearchValue,"U"),argDTO.HasGB)
			if ((argDTO.DicAliasCol '="")&&(argDTO.DicAliasCol'=$C(0)))
			{	s AliasCom= ##Class(EMR.DOC.COM.CheckTool).CheckContain($ZCVT(AliasValue,"U"),$ZCVT(argDTO.SearchValue,"U"),argDTO.HasGB)}
			
			if ((CodeCom '= 1)&&(DescCom '= 1)&&(AliasCom '= 1))
			{	continue}
		}
		
		//处理满足条件的结果并存入临时global
		s totRowCount = totRowCount + 1
		s AliasValue = $P(AliasValue,$C(2),1)
		if (argDTO.IsKeepMinus = "0")
		{	s DescValue = $E(DescValue,$F(DescValue,"-"),$L(DescValue)) }
		
		s:((totRowCount >= argDTO.MinCount)&&(totRowCount <= argDTO.MaxCount)) ^CacheTempStdQuery(argDTO.CookieID,totRowCount) =$LB(rowid,AliasValue,CodeValue,DescValue)
	}
	
	s ^CacheTempStdQuery(argDTO.CookieID,"StdQueryDataCount")= totRowCount
	
	q totRowCount
}

/// Create:	2013-07-15	wangwentao 北京门诊首页
/// Desc:	查询【手术】字典内容：SQLUser.ORC_Operation, SQLUser.ORC_OperationAlias
/// Input：	argDTO.SearchValue 查询条件；argDTO.DicAliasCol 别名列；argDTO.DicCodeCol 代码列；argDTO.DicDescCol 描述列；argDTO.HasGB 查询条件是否有中文字符；argDTO.IsKeepMinus 描述列是否有横线
ClassMethod SelectStdDicORCOperationOP(argDTO As EMR.DOC.DTO.StdDicParameter) As %Integer
{
	
	//结果行总数
	s totRowCount = 0
	
	//开始查询
	s rowid = 0
	for {
		s rowid=$o(^ORC("OPER",rowid))
		quit:(rowid = "")
				
		//get and  validate date of the ICD item.  gjb 2007-12-25
		s dateFrom="",dateTo="",currentDate=""
		s dateFrom=$p($g(^ORC("OPER",rowid)),"^",5)
		s dateTo=$p($g(^ORC("OPER",rowid)),"^",6)
		s currentDate=$p($h,",",1)
		if (((dateFrom'="")&&(currentDate<dateFrom))||((dateTo'="")&&(currentDate'<dateTo)))
		{	continue}
		
		//取代码列和描述列
		//s CodeValue=$p($g(^ORC("OPER",rowid)),"^",1)
		if ($zcvt(argDTO.DicCodeCol,"U") = "OPER_CODE")
		{	s CodeValue = $p($g(^ORC("OPER",rowid)),"^",1)}
		elseif ($zcvt(argDTO.DicCodeCol,"U") = "OPER_ICD10")
		{	s CodeValue =  $p($g(^ORC("OPER",rowid)),"^",14)}
		elseif ($zcvt(argDTO.DicCodeCol,"U") = "OPER_ROWID")
		{	S CodeValue = rowid}
		s DescValue=$p($g(^ORC("OPER",rowid)),"^",2)
		
		//取别名列
		s AliasValue=""
		if ((argDTO.DicAliasCol '="")&&(argDTO.DicAliasCol'=$C(0)))
		{ 
			s aliasRowid=0
		  	for {
		  		s aliasRowid=$o(^ORC("OPER",rowid,"ALIAS",aliasRowid))
				q:(aliasRowid="")
				s AliasValue=AliasValue_$g(^ORC("OPER",rowid,"ALIAS",aliasRowid))_$c(2)
		    }
		}
		
		//20130715 wangwentao add
		//判断类型(常规性操作:N,诊断性操作:D,治疗性操作:T)
		s AliasOperType = $p($g(^ORC("OPER",rowid,"DHC")),"^",11)
		s AliasOperFlag = $s(AliasOperType="":"手术",AliasOperType'="":"操作",1:"")
		s AliasValue=AliasOperFlag_AliasValue

		
		//是否满足查询条件
		s CodeCom=0, DescCom=0, AliasCom=0
		if (argDTO.SearchValue '= "")
		{	
			s CodeCom= ##Class(EMR.DOC.COM.CheckTool).CheckContain($ZCVT(CodeValue,"U"),$ZCVT(argDTO.SearchValue,"U"),argDTO.HasGB)
			S DescCom= ##Class(EMR.DOC.COM.CheckTool).CheckContain($ZCVT(DescValue,"U"),$ZCVT(argDTO.SearchValue,"U"),argDTO.HasGB)
			if ((argDTO.DicAliasCol '="")&&(argDTO.DicAliasCol'=$C(0)))
			{	s AliasCom= ##Class(EMR.DOC.COM.CheckTool).CheckContain($ZCVT(AliasValue,"U"),$ZCVT(argDTO.SearchValue,"U"),argDTO.HasGB)}
			
			if ((CodeCom '= 1)&&(DescCom '= 1)&&(AliasCom '= 1))
			{	continue}
		}
		
		//处理满足条件的结果并存入临时global
		s totRowCount = totRowCount + 1
		s AliasValue = $P(AliasValue,$C(2),1)
		if (argDTO.IsKeepMinus = "0")
		{	s DescValue = $E(DescValue,$F(DescValue,"-"),$L(DescValue)) }
		
		s:((totRowCount >= argDTO.MinCount)&&(totRowCount <= argDTO.MaxCount)) ^CacheTempStdQuery(argDTO.CookieID,totRowCount) =$LB(rowid,AliasValue,CodeValue,DescValue)
	}
	
	s ^CacheTempStdQuery(argDTO.CookieID,"StdQueryDataCount")= totRowCount
	
	q totRowCount
}

/// Create:	2016-12-30  北京复兴首页  用户字典编码取医护人员表code，过滤编码为空人员
/// Desc:	查询【用户】字典内容：SQLUser.SS_User  
/// Input：	argDTO.SearchValue 查询条件；argDTO.DicAliasCol 别名列；argDTO.DicCodeCol 代码列；argDTO.DicDescCol 描述列；ADescHasMinius 描述列是否有横线
/// w ##class(EMR.DOC.BL.StdDictionary).SelectStdDic013("1","200","","SSUSR_EMailName","SSUSR_Initials","SSUSR_Name","141871","0","0","65")
ClassMethod SelectStdDic013(argDTO As EMR.DOC.DTO.StdDicParameter) As %Integer
{
	
	//结果行总数
	/*s totRowCount = 0
	
	//开始查询
	s rowid = 0
	for {
		s rowid=$o(^SSU("SSUSR",rowid))
		quit:(rowid = "")
		
		//取代码列,描述列,别名列
		if ($zcvt(argDTO.DicCodeCol,"U") = "SSUSR_INITIALS")
		{
			s DoctorDR=$p($g(^SSU("SSUSR",rowid)),"^",14)
			if (DoctorDR'="")
			{s CodeValue=$P($g(^CTPCP(DoctorDR,2)),"^",8)} 
			}
		s DescValue=$p($g(^SSU("SSUSR",rowid)),"^",2)
		s AliasValue=$p($g(^SSU("SSUSR",rowid)),"^",11)
		
		//是否满足默认查询条件
		//wangwentao 20111025 update
		//s defaultDeptID = $p($g(^SSU("SSUSR",rowid)),"^",4)
		//continue:(defaultDeptID '= argDTO.Condition)
		//
		//典默认手术室人员
		s defaultDeptID = argDTO.Condition
		//^RB("RES",0,"CTPCP",{RES_CTPCP_DR},{RES_CTLOC_DR},{RES_RowId})  SQLUser.RB_Resource
		s (SSUSRCareProvDR,RESRowId) = ""
		s SSUSRCareProvDR = $p($g(^SSU("SSUSR",rowid)),"^",14)
		s:(SSUSRCareProvDR'="")&&(defaultDeptID'="") RESRowId=$o(^RB("RES",0,"CTPCP",SSUSRCareProvDR,defaultDeptID,""))
		continue:(RESRowId="")
		//wangwentao 20111025 update end
		
		//是否满足查询条件
		s CodeCom=0, DescCom=0, AliasCom=0
		if (argDTO.SearchValue '= "")
		{	
			
			s CodeCom= ##Class(EMR.DOC.COM.CheckTool).CheckContain($ZCVT(CodeValue,"U"),$ZCVT(argDTO.SearchValue,"U"),argDTO.HasGB)
			S DescCom= ##Class(EMR.DOC.COM.CheckTool).CheckContain($ZCVT(DescValue,"U"),$ZCVT(argDTO.SearchValue,"U"),argDTO.HasGB)
			if ((argDTO.DicAliasCol '="")&&(argDTO.DicAliasCol'=$C(0)))
			{	s AliasCom= ##Class(EMR.DOC.COM.CheckTool).CheckContain($ZCVT(AliasValue,"U"),$ZCVT(argDTO.SearchValue,"U"),argDTO.HasGB)}
			
			if ((CodeCom '= 1)&&(DescCom '= 1)&&(AliasCom '= 1))
			{	continue}
		}
		
		//处理满足条件的结果并存入临时global
		s totRowCount = totRowCount + 1
		if (argDTO.IsKeepMinus = "0")
		{	s DescValue = $E(DescValue,$F(DescValue,"-"),$L(DescValue)) }
		s:((totRowCount >= argDTO.MinCount)&&(totRowCount <= argDTO.MaxCount)) ^CacheTempStdQuery(argDTO.CookieID,totRowCount) =$LB(rowid,AliasValue,CodeValue,DescValue)
	}
	
	s ^CacheTempStdQuery(argDTO.CookieID,"StdQueryDataCount")= totRowCount
	
	q totRowCount*/
	//结果行总数
	s totRowCount = 0
	
	//开始查询
	s rowid = 0
	for {
		s rowid=$o(^SSU("SSUSR",rowid))
		quit:(rowid = "")
		
		//取代码列,描述列,别名列
		//取代码列,描述列,别名列
		if ($zcvt(argDTO.DicCodeCol,"U") = "SSUSR_INITIALS")
		{
			s DoctorDR=$p($g(^SSU("SSUSR",rowid)),"^",14)
			if (DoctorDR'="")
			{s CodeValue=$P($g(^CTPCP(DoctorDR,2)),"^",8)} 
			}
		s DescValue=$p($g(^SSU("SSUSR",rowid)),"^",2)
		s AliasValue=$p($g(^SSU("SSUSR",rowid)),"^",11)
		
		//是否满足查询条件
		s CodeCom=0, DescCom=0, AliasCom=0
		if (argDTO.SearchValue '= "")
		{	
			
			s CodeCom= ##Class(EMR.DOC.COM.CheckTool).CheckContain($ZCVT(CodeValue,"U"),$ZCVT(argDTO.SearchValue,"U"),argDTO.HasGB)
			S DescCom= ##Class(EMR.DOC.COM.CheckTool).CheckContain($ZCVT(DescValue,"U"),$ZCVT(argDTO.SearchValue,"U"),argDTO.HasGB)
			if ((argDTO.DicAliasCol '="")&&(argDTO.DicAliasCol'=$C(0)))
			{	s AliasCom= ##Class(EMR.DOC.COM.CheckTool).CheckContain($ZCVT(AliasValue,"U"),$ZCVT(argDTO.SearchValue,"U"),argDTO.HasGB)}
			
			if ((CodeCom '= 1)&&(DescCom '= 1)&&(AliasCom '= 1))
			{	continue}
		}
		
		if (CodeValue ="")
		{ continue }
		
		//处理满足条件的结果并存入临时global
		s totRowCount = totRowCount + 1
		if (argDTO.IsKeepMinus = "0")
		{	s DescValue = $E(DescValue,$F(DescValue,"-"),$L(DescValue)) }
		s:((totRowCount >= argDTO.MinCount)&&(totRowCount <= argDTO.MaxCount)) ^CacheTempStdQuery(argDTO.CookieID,totRowCount) =$LB(rowid,AliasValue,CodeValue,DescValue)
	}
	
	s ^CacheTempStdQuery(argDTO.CookieID,"StdQueryDataCount")= totRowCount
	
	q totRowCount
}

/// Desc:	   查询耗材
/// Creator:   Candy
/// CreateDate:2018-8-3
/// Input：	   argDTO.SearchValue 查询条件；argDTO.DicAliasCol 别名列；argDTO.DicCodeCol 代码列；argDTO.DicDescCol 描述列；ADescHasMinius 描述列是否有横线
/// Debug:    w ##Class(EMR.DOC.BL.StdDictionary).SelectStdDicCTMarital(100,"","","","","","","")
ClassMethod SelectStdDicINCItm(argDTO As EMR.DOC.DTO.StdDicParameter) As %Integer
{
	//结果行总数
	s totRowCount = 0
	
	//开始查询
	s rowid = 0
	for {
		s rowid = $o(^INCI(rowid))
		quit:(rowid = "")
		
		//取代码列,描述列,别名列
		s CodeValue = $p($g(^INCI(rowid,"1")),"^",1)
		s DescValue = $p($g(^INCI(rowid,"1")),"^",2)
		s AliasValue = ""
		s flag = ##class(web.DHCSTM.Common.DrugInfoCommon).GetIncStkCatGrp(rowid)
		continue:($p(flag,"^",1) '= "7601")
		//是否满足查询条件
		s CodeCom=0, DescCom=0, AliasCom=0
		if (argDTO.SearchValue '= "")
		{	
			s CodeCom = ##Class(EMR.DOC.COM.CheckTool).CheckContain($ZCVT(CodeValue,"U"),$ZCVT(argDTO.SearchValue,"U"),argDTO.HasGB)
			s DescCom = ##Class(EMR.DOC.COM.CheckTool).CheckContain($ZCVT(DescValue,"U"),$ZCVT(argDTO.SearchValue,"U"),argDTO.HasGB)
			s:((argDTO.DicAliasCol '="")&&(argDTO.DicAliasCol'=$C(0))) AliasCom= ##Class(EMR.DOC.COM.CheckTool).CheckContain($ZCVT(AliasValue,"U"),$ZCVT(argDTO.SearchValue,"U"),argDTO.HasGB)
			continue:((CodeCom '= 1)&&(DescCom '= 1)&&(AliasCom '= 1))
		}
		//处理满足条件的结果并存入临时global
		s totRowCount = totRowCount + 1
		s:(argDTO.IsKeepMinus = "0") DescValue = $E(DescValue,$F(DescValue,"-"),$L(DescValue))
		s:((totRowCount >= argDTO.MinCount)&&(totRowCount <= argDTO.MaxCount)) ^CacheTempStdQuery(argDTO.CookieID,totRowCount) =$LB(rowid,AliasValue,CodeValue,DescValue)
	}
	
	s ^CacheTempStdQuery(argDTO.CookieID,"StdQueryDataCount")= totRowCount
	
	q totRowCount
}

/// Create:	2019-1-25	Lina
/// Desc:	查询【医保字典表中离院医院】字典内容：SQLUser.INSU_DicData
/// Input：	argDTO.SearchValue 查询条件；argDTO.DicAliasCol 别名列；argDTO.DicCodeCol 代码列；argDTO.DicDescCol 描述列；ADescHasMinius 描述列是否有横线
ClassMethod SelectStdDicINSUDicData(argDTO As EMR.DOC.DTO.StdDicParameter) As %Integer
{
	//结果行总数
	s totRowCount = 0
	
	//开始查询
	s rowid = 0
	for {
		s rowid=$o(^DHCINDID("0","IType","HospitalsInfo",rowid))
		quit:(rowid = "")
		
		//取代码列,描述列,别名列
		s CodeValue=$p($g(^DHCINDID(rowid)),"^",2)
		s DescValue=$p($g(^DHCINDID(rowid)),"^",3)
		s AliasValue=$p($g(^DHCINDID(rowid)),"^",4)
		
		//是否满足查询条件
		s CodeCom=0, DescCom=0, AliasCom=0
		if (argDTO.SearchValue '= "")
		{
			s CodeCom = ##Class(EMR.DOC.COM.CheckTool).CheckContain($ZCVT(CodeValue,"U"),$ZCVT(argDTO.SearchValue,"U"),argDTO.HasGB)
			s DescCom = ##Class(EMR.DOC.COM.CheckTool).CheckContain($ZCVT(DescValue,"U"),$ZCVT(argDTO.SearchValue,"U"),argDTO.HasGB)
			s:((argDTO.DicAliasCol '="")&&(argDTO.DicAliasCol'=$C(0))) AliasCom= ##Class(EMR.DOC.COM.CheckTool).CheckContain($ZCVT(AliasValue,"U"),$ZCVT(argDTO.SearchValue,"U"),argDTO.HasGB)
			continue:((CodeCom '= 1)&&(DescCom '= 1)&&(AliasCom '= 1))
		}
		
		
		//处理满足条件的结果并存入临时global
		s totRowCount = totRowCount + 1
		s:(argDTO.IsKeepMinus = "0") DescValue = $E(DescValue,$F(DescValue,"-"),$L(DescValue))
		s:((totRowCount >= argDTO.MinCount)&&(totRowCount <= argDTO.MaxCount)) ^CacheTempStdQuery(argDTO.CookieID,totRowCount) =$LB(rowid,AliasValue,CodeValue,DescValue)
	}
	
	s ^CacheTempStdQuery(argDTO.CookieID,"StdQueryDataCount")= totRowCount
	
	q totRowCount
}

/// Desc:	处理动态字典
ClassMethod SelectDynamicStdDic(argDTO As EMR.DOC.DTO.StdDicParameter) As %Integer
{
	s totRowCount = 0
	s ADicTableName = argDTO.DicTableName
 	// 配置要查询的字段
	s sqlColumn = ""
	if (argDTO.DicCodeCol '= "")&&(argDTO.DicCodeCol '= $C(0))
	{	s sqlColumn = argDTO.DicCodeCol_" as MyCode"}
	if (argDTO.DicDescCol '= "")&&(argDTO.DicDescCol '= $C(0))
	{	s sqlColumn = sqlColumn_","_argDTO.DicDescCol_" as MyDesc"}
	if (argDTO.DicAliasCol '= "")&&(argDTO.DicAliasCol '= $C(0))
	{	s sqlColumn = sqlColumn_","_argDTO.DicAliasCol_" as MyAlias"}
	if (sqlColumn '= "")&&($E(sqlColumn,1,1)=",")
	{	s sqlColumn = $E(sqlColumn,2,$L(sqlColumn))}
	
	// 转换要查询的表
	s sqlTable = ##class(EMR.DOC.BL.StdDictionary).SwitchFromTable(ADicTableName)
	
	// 转换查询条件
	s sqlWhere = ""
	s sqlWhere = ..SwitchWhere(ADicTableName, sqlWhere)
	
	// 配置聚合条件
	s sqlOrder = ""
	if ((argDTO.DicCodeCol '= "")&&(argDTO.DicCodeCol '= $C(0)))
	{ s sqlOrder = " Order By  "_argDTO.DicCodeCol }
	
	// 总的sql语句
	s sqlTotal = "select "_sqlColumn_" from "_sqlTable_" "_sqlWhere_sqlOrder
	
	s resultSet = ##class(%Library.ResultSet).%New()
	d resultSet.Prepare(sqlTotal)
	d resultSet.Execute()
	while(resultSet.Next())
	{
		s conCodeValue = resultSet.Data("MyCode")
		s conDescValue = resultSet.Data("MyDesc")
		if (argDTO.DicAliasCol '= "")&&(argDTO.DicAliasCol '= $C(0))
		{	s conAliasValue = resultSet.Data("MyAlias")}
		else
		{	s conAliasValue = ""}
		
		s codeValue =  conCodeValue
		s descValue =  conDescValue
		if (argDTO.IsKeepMinus = 0)
		{	
			// 截掉"-"号及其前面的内容
			s descValue = $E(conDescValue,$F(conDescValue,"-"),$L(conDescValue))
		}		
		s aliasValue = conAliasValue
		
		// 是否满足查询条件
		if ((argDTO.SearchValue '="")&&(argDTO.SearchValue'=$C(0)))
		{
	 		s isCodeContain = ##Class(EMR.DOC.COM.CheckTool).CheckGBContain($ZCVT(conCodeValue,"U"),$ZCVT(argDTO.SearchValue,"U"))
	  		s isDescContain = ##Class(EMR.DOC.COM.CheckTool).CheckGBContain($ZCVT(conDescValue,"U"),$ZCVT(argDTO.SearchValue,"U"))
	  		s isAliasContain = ##Class(EMR.DOC.COM.CheckTool).CheckGBContain($ZCVT(conAliasValue,"U"),$ZCVT(argDTO.SearchValue,"U"))
	  		
	  		if (isCodeContain="True")||(isDescContain="True")||(isAliasContain="True")
			{
				s totRowCount = totRowCount + 1
				s:((totRowCount >= argDTO.MinCount)&&(totRowCount <= argDTO.MaxCount)) ^CacheTempStdQuery(argDTO.CookieID, totRowCount)=$LB(totRowCount, aliasValue, codeValue, descValue)	
			}
		}
		else
		{
			s totRowCount = totRowCount  + 1
			s:((totRowCount >= argDTO.MinCount)&&(totRowCount <= argDTO.MaxCount)) ^CacheTempStdQuery(argDTO.CookieID, totRowCount)=$LB(totRowCount, aliasValue, codeValue, descValue)
		}
	}
		
	q totRowCount
}

ClassMethod SwitchFromTable(parOldFromTable As %String) As %String
{
	//ICD
	q:(parOldFromTable="SQLUser.MRC_ICDDx") "SQLUser.MRC_ICDDx, SQLUser.MRC_ICDAlias"
	//Operation
	q:(parOldFromTable="SQLUser.ORC_Operation") "SQLUser.ORC_Operation, SQLUser.ORC_OperationAlias"
	q parOldFromTable
}

/// Desc:	查询【用户】字典内容：SQLUser.CT_Marital
/// Input：	argDTO.SearchValue 查询条件；argDTO.DicAliasCol 别名列；argDTO.DicCodeCol 代码列；argDTO.DicDescCol 描述列；ADescHasMinius 描述列是否有横线
/// Debug:  w ##Class(EMR.DOC.BL.StdDictionary).SelectStdDicCTMarital(100,"","","","","","","")
ClassMethod SelectStdDicCTMarital(argDTO As EMR.DOC.DTO.StdDicParameter) As %Integer
{
	//结果行总数
	s totRowCount = 0
	
	//开始查询
	s rowid = 0
	for {
		s rowid=$o(^CT("MAR",rowid))
		quit:(rowid = "")
		
		s tmpDate = $p($h,",",1)
		s dateFrom = $p($g(^CT("MAR",rowid)),"^",4)
		s dateTo = $p($g(^CT("MAR",rowid)),"^",5)
		continue:((dateFrom '= "")&&(dateFrom > tmpDate))
		continue:((dateTo '= "")&&(dateTo <tmpDate))
		//取代码列,描述列,别名列
		s CodeValue=$p($g(^CT("MAR",rowid)),"^",1)
		s DescValue=$p($g(^CT("MAR",rowid)),"^",2)
		s AliasValue=""
		
		//是否满足查询条件
		s CodeCom=0, DescCom=0, AliasCom=0
		if (argDTO.SearchValue '= "")
		{	
			
			s CodeCom= ##Class(EMR.DOC.COM.CheckTool).CheckContain($ZCVT(CodeValue,"U"),$ZCVT(argDTO.SearchValue,"U"),argDTO.HasGB)
			S DescCom= ##Class(EMR.DOC.COM.CheckTool).CheckContain($ZCVT(DescValue,"U"),$ZCVT(argDTO.SearchValue,"U"),argDTO.HasGB)
			if ((argDTO.DicAliasCol '="")&&(argDTO.DicAliasCol'=$C(0)))
			{	s AliasCom= ##Class(EMR.DOC.COM.CheckTool).CheckContain($ZCVT(AliasValue,"U"),$ZCVT(argDTO.SearchValue,"U"),argDTO.HasGB)}
			
			if ((CodeCom '= 1)&&(DescCom '= 1)&&(AliasCom '= 1))
			{	continue}
		}
		
		//处理满足条件的结果并存入临时global
		s totRowCount = totRowCount + 1
		if (argDTO.IsKeepMinus = "0")
		{	s DescValue = $E(DescValue,$F(DescValue,"-"),$L(DescValue)) }
		s:((totRowCount >= argDTO.MinCount)&&(totRowCount <= argDTO.MaxCount)) ^CacheTempStdQuery(argDTO.CookieID,totRowCount) =$LB(rowid,AliasValue,CodeValue,DescValue)
	}
	
	s ^CacheTempStdQuery(argDTO.CookieID,"StdQueryDataCount")= totRowCount
	
	q totRowCount
}

/// Desc: 支持查询字典中每一列数据，按照 or 的关系进行查询，区别于上面的 GetStdDicList 这个query中的 And 关系查询；
Query GetStdDicListByOr(ADicCode As %String, AAias As %String, Acode As %String, ADesc As %String, APageNum As %Integer, ARowCount As %Integer) As %Query(ROWSPEC = "ID:%String,Alias:%String,Code:%String,DicDesc:%String")
{
}

ClassMethod GetStdDicListByOrExecute(ByRef qHandle As %Binary, ADicCode As %String, AAias As %String, ACode As %String, ADesc As %String, APageNum As %Integer, ARowCount As %Integer) As %Status
{
	s qHandle="1" 
 s SQLCODE=0 
 //s %ROWID=0 
 s %counter=0
 s ID=""
 S %ResultID=""


 set result = ##class(%Library.ResultSet).%New()
 Set SqlString ="Select Name,TableName,DicAliasCol,DicCodeCol,DicDescCol From CF_EMR_DOC.StdDictionary "
 Set SqlWhereString =""
 if (ADicCode '="")
 {
 set TempCode= ADicCode //##class(CF_EMR_DOC.StdDictionary).ReplaceAsterisk(ADicCode)
 set SqlWhereString = "Where CF_EMR_DOC.StdDictionary.Code Like '"_TempCode_"'" 
 } 
 if (SqlWhereString '="") 
 { Set SqlString = SqlString_SqlWhereString }
 do result.Prepare(SqlString)


 do result.Execute()


 While (result.Next())
 {
 Set DicTableName= result.Data("TableName")
 Set DicAlias = result.Data("DicAliasCol")
 Set DicDesc = result.Data("DicDescCol")
 Set DicCode = result.Data("DicCodeCol")
 }
 do result.Close() 

 set DescBiteoffFlag= ##Class(EMR.DOC.BL.SysOption).CheckMinusFieldExist(DicTableName,DicDesc)

 Set RowCount = 0
 Set StartPageID= (APageNum-1)*ARowCount
 Set LastPageId = APageNum*ARowCount
 Set PageNumCounter = 0 

 set GetDatasetSql = ""
 Set GetDatasetSql = "Select Top "_LastPageId_" "

 set AFieldSql = ""
 if ((DicAlias '=""  )&&(DicAlias'=$C(0))) 
 {
	  if (AFieldSql="")
	  { 
	    Set AFieldSql= AFieldSql_" "_DicAlias_" As Alias"   
	  }
	  elseif (AFieldSql'="")
	  {
		set AFieldSql= AFieldSql_" , "_DicAlias_" As Alias"     
		  }
}

 if ((DicCode '="")&&(DicCode '=$C(0)))
 {
	  if (AFieldSql="")
	  { 
	    Set AFieldSql= AFieldSql_" "_DicCode_" As Code"      
	  }
	  elseif (AFieldSql'="")
	  {
		set AFieldSql= AFieldSql_" , "_DicCode_" As Code"      
		  }
 }
 if ((DicDesc '="")&&(DicDesc'=$C(0)))
 {
	  if (AFieldSql="")
	  { 
	    Set AFieldSql= AFieldSql_" "_DicDesc_" As DicDesc" 
	  }
	  elseif (AFieldSql'="")
	  {
		set AFieldSql= AFieldSql_" , "_DicDesc_" As DicDesc" 
		  }
 }

 //add for PinYin query
 Set GetDatasetSql = GetDatasetSql_AFieldSql_ " From "_##class(EMR.DOC.BL.StdDictionary).SwitchFromTable(DicTableName)
 //Set GetDatasetSql = GetDatasetSql_AFieldSql_ " From "_DicTableName

 Set GetWhereSql =""

 if ((DicAlias'="")&&(DicAlias'=$C(0)))
 { if (AAias '="")&&(AAias'=$C(0))
	    {
		  set TempAias =$ZCVT(##class(EMR.DOC.BL.StdDictionary).ReplaceAsterisk(AAias),"U")
		  
		  Set GetWhereSql =" Where UPPER("_DicAlias_") Like '"_TempAias_"' "
	    }
	}

 if ((DicCode'="")&&(DicCode'=$C(0)))
 {  
 if ((ACode '="")&&(ACode '=$C(0)))
	    {
		  set TempDicCode = $ZCVT(##class(EMR.DOC.BL.StdDictionary).ReplaceAsterisk(ACode),"U")
		  
		  if (GetWhereSql= "")
		  {
			 Set GetWhereSql =" Where UPPER("_DicCode_") Like '"_TempDicCode_"' "
		  } 
		  elseif (GetWhereSql'="")
		  {
			Set GetWhereSql = GetWhereSql _" Or  UPPER("_DicCode_") Like '"_TempDicCode_"' "  
		   }
	    }
	}

 if ((DicDesc'="")&&(DicDesc'=$C(0)))
 {  
 if ((ADesc '="")&&(ADesc '=$C(0)))
	    {
		  set TempDesc =$ZCVT(##class(EMR.DOC.BL.StdDictionary).ReplaceAsterisk(ADesc),"U")
		  
		  if (GetWhereSql= "")
		  {
			 Set GetWhereSql =" Where UPPER("_DicDesc_") Like '"_TempDesc_"' "
		  } 
		  elseif (GetWhereSql'="")
		  {
			Set GetWhereSql = GetWhereSql _" Or  UPPER("_DicDesc_") Like '"_TempDesc_"' "  
		   }
	    }
	}

 if (GetWhereSql '="")
 {
	 //add for PinYin query
 s GetWhereSql = ..SwitchWhere(DicTableName,GetWhereSql)

	 set GetDatasetSql = GetDatasetSql_GetWhereSql
	 if (('DicCode="" )&&(DicCode'=$C(0)))
	 {set GetDatasetSql = GetDatasetSql_" Order By  "_DicCode   
	 }
	
	 }
 Elseif  (GetWhereSql ="")
	 { ;s ^AAStd("DicCode")=DicCode
	  if ((DicCode'="" )&&(DicCode'=$C(0)))
	  {		 
	 	//add for PinYin query
	  ;s ^gjbtest("new")=DicTableName_"=="_GetWhereSql
 		s GetWhereSql = ..SwitchWhere(DicTableName,GetWhereSql)
	 	set GetDatasetSql = GetDatasetSql_GetWhereSql
	 	//
		set GetDatasetSql = GetDatasetSql_" Order By "_DicCode
	  } 
	 }

 set Countresult = ##class(%Library.ResultSet).%New()
 do Countresult.Prepare(GetDatasetSql)

 do Countresult.Execute()


 set AIDNum = 0
 While (Countresult.Next())
 {
	  set PageNumCounter = PageNumCounter + 1
	  set AIDNum= AIDNum+1
	  if (PageNumCounter> StartPageID)&(PageNumCounter <= LastPageId)
	  {
		
		
		if ((DicAlias '="")&&(DicAlias'=$C(0)))
		 { if (DescBiteoffFlag = "0") 
		   {
			 Set %ResultID(PageNumCounter-StartPageID)=$LB(AIDNum,Countresult.Data("Alias"),Countresult.Data("Code"),$E(Countresult.Data("DicDesc"),$F(Countresult.Data("DicDesc"),"-"),$L(Countresult.Data("DicDesc"))))
		   }
		   elseif '(DescBiteoffFlag = "0") 
		   {
		    Set %ResultID(PageNumCounter-StartPageID)=$LB(AIDNum,Countresult.Data("Alias"),Countresult.Data("Code"),Countresult.Data("DicDesc"))  
			   }
		  }
		Else
		{ if (DescBiteoffFlag = "0") 
		   { 
		    Set %ResultID(PageNumCounter-StartPageID)=$LB(AIDNum,"",Countresult.Data("Code"),$E(Countresult.Data("DicDesc"),$F(Countresult.Data("DicDesc"),"-"),$L(Countresult.Data("DicDesc"))))  }
		    elseif '(DescBiteoffFlag = "0") 
		    { Set %ResultID(PageNumCounter-StartPageID)=$LB(AIDNum,"",Countresult.Data("Code"),Countresult.Data("DicDesc")) 
		    } 		 } 
		}
	    
	 }
	 
 do Countresult.Close()

 s qHandle=%ResultID
	Quit $$$OK
}

ClassMethod GetStdDicListByOrClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetStdDicListByOrExecute ]
{
	s qHandle="" 
 	Quit $$$OK
}

ClassMethod GetStdDicListByOrFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetStdDicListByOrExecute ]
{
	s SQLCODE=0 
 s $ET="QUIT" 
 s %counter=%counter+1
 if $o(%ResultID(""),-1)<%counter 
 {
	s Row = ""
	s AtEnd=1
 }
 else 
 {
	set Row=%ResultID(%counter)
	}

 Quit $$$OK
}

/// Create:	2020-01-08	donglulu
/// Desc:	查询【输血方式】
/// Input：	argDTO.SearchValue 查询条件；argDTO.DicAliasCol 别名列；argDTO.DicCodeCol 代码列；argDTO.DicDescCol 描述列；argDTO.HasGB 查询条件是否有中文字符；argDTO.IsKeepMinus 描述列是否有横线
ClassMethod SelectStdDicBDTransType(argDTO As EMR.DOC.DTO.StdDicParameter) As %Integer
{
	//结果行总数
	s totRowCount = 0
	
	s ds = ##Class(%Library.ResultSet).%New("DHCLIS.DHCBDAgreeFormInterface:QryBDTransType")
	d ds.Execute("","","","","","","","","","","","","","","")
	While (ds.Next())
	{
		continue:(ds.Data("code") = "")
		s CodeValue = ds.Data("code")
		s DescValue = ds.Data("cName")
		s AliasValue = ""	
		
		//是否满足查询条件
		s CodeCom=0, DescCom=0, AliasCom=0
		if (argDTO.SearchValue '= "")
		{	
			s CodeCom= ##Class(EMR.DOC.COM.CheckTool).CheckContain($ZCVT(CodeValue,"U"),$ZCVT(argDTO.SearchValue,"U"),argDTO.HasGB)
			S DescCom= ##Class(EMR.DOC.COM.CheckTool).CheckContain($ZCVT(DescValue,"U"),$ZCVT(argDTO.SearchValue,"U"),argDTO.HasGB)
			if ((argDTO.DicAliasCol '="")&&(argDTO.DicAliasCol'=$C(0)))
			{	s AliasCom= ##Class(EMR.DOC.COM.CheckTool).CheckContain($ZCVT(AliasValue,"U"),$ZCVT(argDTO.SearchValue,"U"),argDTO.HasGB)}
			
			if ((CodeCom '= 1)&&(DescCom '= 1)&&(AliasCom '= 1))
			{	continue}
		}
		
		//处理满足条件的结果并存入临时global
		s totRowCount = totRowCount + 1
		s AliasValue = $P(AliasValue,$C(2),1)
		if (argDTO.IsKeepMinus = "0")
		{	s DescValue = $E(DescValue,$F(DescValue,"-"),$L(DescValue)) }
		
		s:((totRowCount >= argDTO.MinCount)&&(totRowCount <= argDTO.MaxCount)) ^CacheTempStdQuery(argDTO.CookieID,totRowCount) = $LB(rowid,AliasValue,CodeValue,DescValue)
	}
	
	s ^CacheTempStdQuery(argDTO.CookieID,"StdQueryDataCount")= totRowCount
	
	q totRowCount
}

/// Create:	2020-01-08	donglulu
/// Desc:	查询【申请血产品】
/// Input：	argDTO.SearchValue 查询条件；argDTO.DicAliasCol 别名列；argDTO.DicCodeCol 代码列；argDTO.DicDescCol 描述列；argDTO.HasGB 查询条件是否有中文字符；argDTO.IsKeepMinus 描述列是否有横线
ClassMethod SelectStdDicBDReqProduct(argDTO As EMR.DOC.DTO.StdDicParameter) As %Integer
{
	//结果行总数
	s totRowCount = 0
	
	s ds = ##Class(%Library.ResultSet).%New("DHCLIS.DHCBDAgreeFormInterface:QryBDReqProduct")
	d ds.Execute("","","","","","","","","","","","","","","")
	While (ds.Next())
	{
		continue:(ds.Data("Code") = "")
		s CodeValue = ds.Data("Code")
		s DescValue = ds.Data("CName")
		s AliasValue = ""	
		
		//是否满足查询条件
		s CodeCom=0, DescCom=0, AliasCom=0
		if (argDTO.SearchValue '= "")
		{	
			s CodeCom= ##Class(EMR.DOC.COM.CheckTool).CheckContain($ZCVT(CodeValue,"U"),$ZCVT(argDTO.SearchValue,"U"),argDTO.HasGB)
			S DescCom= ##Class(EMR.DOC.COM.CheckTool).CheckContain($ZCVT(DescValue,"U"),$ZCVT(argDTO.SearchValue,"U"),argDTO.HasGB)
			if ((argDTO.DicAliasCol '="")&&(argDTO.DicAliasCol'=$C(0)))
			{	s AliasCom= ##Class(EMR.DOC.COM.CheckTool).CheckContain($ZCVT(AliasValue,"U"),$ZCVT(argDTO.SearchValue,"U"),argDTO.HasGB)}
			
			if ((CodeCom '= 1)&&(DescCom '= 1)&&(AliasCom '= 1))
			{	continue}
		}
		
		//处理满足条件的结果并存入临时global
		s totRowCount = totRowCount + 1
		s AliasValue = $P(AliasValue,$C(2),1)
		if (argDTO.IsKeepMinus = "0")
		{	s DescValue = $E(DescValue,$F(DescValue,"-"),$L(DescValue)) }
		
		s:((totRowCount >= argDTO.MinCount)&&(totRowCount <= argDTO.MaxCount)) ^CacheTempStdQuery(argDTO.CookieID,totRowCount) = $LB(rowid,AliasValue,CodeValue,DescValue)
	}
	
	s ^CacheTempStdQuery(argDTO.CookieID,"StdQueryDataCount")= totRowCount
	
	q totRowCount
}

/// Create:	2020-01-08	donglulu
/// Desc:	查询【输血目的】
/// Input：	argDTO.SearchValue 查询条件；argDTO.DicAliasCol 别名列；argDTO.DicCodeCol 代码列；argDTO.DicDescCol 描述列；argDTO.HasGB 查询条件是否有中文字符；argDTO.IsKeepMinus 描述列是否有横线
ClassMethod SelectStdDicBDTransPurpose(argDTO As EMR.DOC.DTO.StdDicParameter) As %Integer
{
	//结果行总数
	s totRowCount = 0
	
	s ds = ##Class(%Library.ResultSet).%New("DHCLIS.DHCBDAgreeFormInterface:QryBDTransPurpose")
	d ds.Execute("","","","","","","","","","","","","","","")
	While (ds.Next())
	{
		continue:(ds.Data("code") = "")
		s CodeValue = ds.Data("code")
		s DescValue = ds.Data("cName")
		s AliasValue = ""	
		
		//是否满足查询条件
		s CodeCom=0, DescCom=0, AliasCom=0
		if (argDTO.SearchValue '= "")
		{	
			s CodeCom= ##Class(EMR.DOC.COM.CheckTool).CheckContain($ZCVT(CodeValue,"U"),$ZCVT(argDTO.SearchValue,"U"),argDTO.HasGB)
			S DescCom= ##Class(EMR.DOC.COM.CheckTool).CheckContain($ZCVT(DescValue,"U"),$ZCVT(argDTO.SearchValue,"U"),argDTO.HasGB)
			if ((argDTO.DicAliasCol '="")&&(argDTO.DicAliasCol'=$C(0)))
			{	s AliasCom= ##Class(EMR.DOC.COM.CheckTool).CheckContain($ZCVT(AliasValue,"U"),$ZCVT(argDTO.SearchValue,"U"),argDTO.HasGB)}
			
			if ((CodeCom '= 1)&&(DescCom '= 1)&&(AliasCom '= 1))
			{	continue}
		}
		
		//处理满足条件的结果并存入临时global
		s totRowCount = totRowCount + 1
		s AliasValue = $P(AliasValue,$C(2),1)
		if (argDTO.IsKeepMinus = "0")
		{	s DescValue = $E(DescValue,$F(DescValue,"-"),$L(DescValue)) }
		
		s:((totRowCount >= argDTO.MinCount)&&(totRowCount <= argDTO.MaxCount)) ^CacheTempStdQuery(argDTO.CookieID,totRowCount) = $LB(rowid,AliasValue,CodeValue,DescValue)
	}
	
	s ^CacheTempStdQuery(argDTO.CookieID,"StdQueryDataCount")= totRowCount
	
	q totRowCount
}

/// Create:	2020-01-08	donglulu
/// Desc:	查询【供着血型】
/// Input：	argDTO.SearchValue 查询条件；argDTO.DicAliasCol 别名列；argDTO.DicCodeCol 代码列；argDTO.DicDescCol 描述列；argDTO.HasGB 查询条件是否有中文字符；argDTO.IsKeepMinus 描述列是否有横线
ClassMethod SelectStdDicBDBLOODGROUP(argDTO As EMR.DOC.DTO.StdDicParameter) As %Integer
{
	//结果行总数
	s totRowCount = 0
	
	s ds = ##Class(%Library.ResultSet).%New("DHCLIS.DHCBDAgreeFormInterface:QryBloodGroup")
	d ds.Execute("","","","","","","","","","","","",20,1,"106^10^^13^1")
	While (ds.Next())
	{
		continue:(ds.Data("code") = "")
		s CodeValue = ds.Data("code")
		s DescValue = ds.Data("cName")
		s AliasValue = ""	
		
		//是否满足查询条件
		s CodeCom=0, DescCom=0, AliasCom=0
		if (argDTO.SearchValue '= "")
		{	
			s CodeCom= ##Class(EMR.DOC.COM.CheckTool).CheckContain($ZCVT(CodeValue,"U"),$ZCVT(argDTO.SearchValue,"U"),argDTO.HasGB)
			S DescCom= ##Class(EMR.DOC.COM.CheckTool).CheckContain($ZCVT(DescValue,"U"),$ZCVT(argDTO.SearchValue,"U"),argDTO.HasGB)
			if ((argDTO.DicAliasCol '="")&&(argDTO.DicAliasCol'=$C(0)))
			{	s AliasCom= ##Class(EMR.DOC.COM.CheckTool).CheckContain($ZCVT(AliasValue,"U"),$ZCVT(argDTO.SearchValue,"U"),argDTO.HasGB)}
			
			if ((CodeCom '= 1)&&(DescCom '= 1)&&(AliasCom '= 1))
			{	continue}
		}
		
		//处理满足条件的结果并存入临时global
		s totRowCount = totRowCount + 1
		s AliasValue = $P(AliasValue,$C(2),1)
		if (argDTO.IsKeepMinus = "0")
		{	s DescValue = $E(DescValue,$F(DescValue,"-"),$L(DescValue)) }
		
		s:((totRowCount >= argDTO.MinCount)&&(totRowCount <= argDTO.MaxCount)) ^CacheTempStdQuery(argDTO.CookieID,totRowCount) = $LB(rowid,AliasValue,CodeValue,DescValue)
	}
	
	s ^CacheTempStdQuery(argDTO.CookieID,"StdQueryDataCount")= totRowCount
	
	q totRowCount
}

}
