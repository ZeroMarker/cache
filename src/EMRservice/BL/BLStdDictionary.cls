/// 名称:EMRservice.BL.BLStdDictionary
/// 描述:系统参数配置服务
/// 编写者：yejian
/// 编写日期: 2014-2-11
Class EMRservice.BL.BLStdDictionary Extends %RegisteredObject
{

ClassMethod GetStdDicitonaryByID(AID As %String) As EMRservice.entity.EStdDictionary [ WebMethod ]
{
	s ret = ""
	q:(AID = "") ret
	
	s objStdDictionary = ##Class(EMRmeta.StdDictionary).%OpenId(AID)
	q:(objStdDictionary = "") ret
	
	s Result = ##Class(EMRservice.entity.EStdDictionary).%New()
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

ClassMethod CreateStdDictionary(AEStdDictionary As EMRservice.entity.EStdDictionary) As %String [ WebMethod ]
{
	set objStdDictionary = ##class(EMRmeta.StdDictionary).%New()
	Quit:(objStdDictionary ="") "" 
	set objStdDictionary.Code = AEStdDictionary.Code
	S UniqueFlag=..CheckCodeUnique(AEStdDictionary.Code)
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
	set objStdDictionary.IsRuleType = AEStdDictionary.IsRuleType
	set objStdDictionary.RuleTypeTag = AEStdDictionary.RuleTypeTag
	set objStdDictionary.Condition = AEStdDictionary.Condition
	set objStdDictionary.ConditionCode = AEStdDictionary.ConditionCode
	set objStdDictionary.IsDiagnosRuleType = AEStdDictionary.IsDiagnosRuleType
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
	set obj = ##class(EMRmeta.StdDictionary).%OpenId(AID)
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
	set objStdDictionary = ##class(EMRmeta.StdDictionary).%OpenId(AID)
	Quit objStdDictionary.%DeleteId(AID)
}

ClassMethod GetStdDicList(ADicCode As %String, AAias As %String, Acode As %String, ADesc As %String, APageNum As %Integer, ARowCount As %Integer) As %XML.DataSet [ WebMethod ]
{
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

 Set Result = ##class(EMRservice.dataset.EStdDicListDataset).%New()
 Do Result.SetArgs(ADicCode,AAias,Acode,ADesc,APageNum,ARowCount)
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
 
 Set Result = ##class(EMRservice.BL.BLStdDictionary).SELECTStdDicPageCount(ADicCode,AAias,ACode,ADesc,ARowCount)
 Quit Result
}

ClassMethod SelectALLStdDic() As EMRservice.dataset.EStdDictionaryDataset [ WebMethod ]
{
 Set result=##class(EMRservice.dataset.EStdDictionaryDataset).%New()
 Quit result
}

/// modify by Candyxu 20120607 按顺序排列
Query SELECTALL() As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID:%Integer,Code:%String,Name:%String,Description:%String,TableName:%String,DicCodeCol:%String,DicDescCol:%String,DicAliasCol:%String,IsRuleType:%String,RuleTypeTag:%String,Condition:%String,ConditionCode:%String,IsDiagnosRuleType:%String", SELECTMODE = "RUNTIME") [ SqlName = SP_StdDictionary_SELECTALL, SqlProc ]
{
SELECT %ID,Code,Name,Description,TableName,DicCodeCol,DicDescCol,DicAliasCol,IsRuleType,RuleTypeTag,Condition,ConditionCode,IsDiagnosRuleType
 FROM EMRmeta.StdDictionary
 ORDER BY Sequence
}

ClassMethod UpdateStdDictionary(AEStdDictionary As EMRservice.entity.EStdDictionary) As %String [ WebMethod ]
{
 set objStdDictionary = ##class(EMRmeta.StdDictionary).%OpenId(AEStdDictionary.ID)
 Quit:(objStdDictionary ="") 0 
 //set objStdDictionary = ##class(EMRmeta.StdDictionary).%OpenId(AEKBTree.ID)
 //B "S"
 set objStdDictionary.Code = AEStdDictionary.Code

 S UniqueFlag=##class(EMRservice.BL.BLStdDictionary).CheckUpdateCodeUnique(AEStdDictionary.ID,AEStdDictionary.Code)

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
 set objStdDictionary.IsRuleType = AEStdDictionary.IsRuleType
 set objStdDictionary.RuleTypeTag = AEStdDictionary.RuleTypeTag
 set objStdDictionary.Condition = AEStdDictionary.Condition
 set objStdDictionary.ConditionCode = AEStdDictionary.ConditionCode
 set objStdDictionary.IsDiagnosRuleType = AEStdDictionary.IsDiagnosRuleType
 
 if '(objStdDictionary.%Save())
 {Quit "0"}
 Quit "1"
}

ClassMethod CheckUpdateCodeUnique(AID As %String, ACode As %String) As %Integer
{
 //B "S"
 s Result = ""
 s OldID = ""
 
 &sql(SELECT Count(Code)
 into :Result 
 FROM EMRmeta.StdDictionary
 WHERE Code = :ACode)
 if ((Result="")!(Result=0))
 {
 s Result=0
 }
 elseif '(Result=0) 
 {
 &sql(SELECT ID
 into :OldID
 FROM EMRmeta.StdDictionary
 WHERE Code = :ACode)
 if ('OldID=AID)     
 { 
 s Result= 1
	  }

 if (OldID=AID)     
 { 
 s Result= 0
	  }
 }


 QUIT Result
}

ClassMethod SelectStdDicByRuleTypeTag(argRuleTypeTag As %String) As EMRservice.dataset.EStdDicByRuleTypeTagDataset [ WebMethod ]
{
 Set result=##class(EMRservice.dataset.EStdDicByRuleTypeTagDataset).%New()
 Do result.SetArgs(argRuleTypeTag)
 Quit result
}

/// Desc:	根据字典代码获取字典默认查询条件
/// Debug：	w ##Class(EMRservice.BL.BLStdDictionary).SelectConditionByStdCode("S06")
ClassMethod SelectConditionByStdCode(AStdDicCode As %String) As %String [ WebMethod ]
{
	s retValue = ""
	
	s stdConditionCode = "", stdCondition = ""
	&sql(select top 1 ConditionCode, Condition into :stdConditionCode, :stdCondition 
		from EMRmeta.StdDictionary where Code = :AStdDicCode)
	
	q:(stdConditionCode = "")||(stdConditionCode = $c(0)) retValue
	//q:(stdCondition = "")||(stdCondition = $c(0)) retValue
	
	;s retValue = stdConditionCode_"^"_stdCondition
	s retValue = stdConditionCode	
	q retValue
}

/// Desc:	根据字典代码获取字典默认查询条件
/// Debug：	w ##Class(EMRservice.BL.BLStdDictionary).getConditionByStdCode("S06")
ClassMethod getConditionByStdCode(AStdDicCode As %String) As %String [ WebMethod ]
{
	s retValue = ""
	
	s stdConditionCode = "", stdCondition = ""
	&sql(select top 1 ConditionCode, Condition into :stdConditionCode, :stdCondition 
		from EMRmeta.StdDictionary where Code = :AStdDicCode)
	
	//q:(stdConditionCode = "")||(stdConditionCode = $c(0)) retValue
	q:(stdCondition = "")||(stdCondition = $c(0)) retValue
	
	;s retValue = stdConditionCode_"^"_stdCondition
	s retValue = stdCondition
	q retValue
}

/// Desc:改变记录顺序
/// Creator: Candyxu
/// Date: 2012-06-07
/// input: RowID1 交换记录的第一条记录ID，RowID2 交换记录的第二条记录ID
/// Result:0失败，1成功
/// do ##class(EMRservice.BOStdDictionary).SwapSequence("3","4")
ClassMethod SwapSequence(RowID1 As %String, RowID2 As %String) As %Boolean [ WebMethod ]
{
	set result = 0
	set obj1 = ##class(EMRmeta.StdDictionary).%OpenId(RowID1)
	set obj2 = ##class(EMRmeta.StdDictionary).%OpenId(RowID2)
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

// 以下方法都移动到EMRservice.BL.BLStdDictionary

ClassMethod CheckCodeUnique(ACode As %String) As %Integer
{
 new Result
 &sql(SELECT Count(Code)
 into :Result 
 FROM EMRmeta.StdDictionary
 WHERE Code = :ACode)
 if Result=""
 {s Result=0 }
 QUIT Result
}

ClassMethod SwitchFromTable(parOldFromTable As %String) As %String
{
	//ICD
	q:(parOldFromTable="SQLUser.MRC_ICDDx") "SQLUser.MRC_ICDDx, SQLUser.MRC_ICDAlias"
	//Operation
	q:(parOldFromTable="SQLUser.ORC_Operation") "SQLUser.ORC_Operation, SQLUser.ORC_OperationAlias"
	q parOldFromTable
}

ClassMethod ReplaceAsterisk(AStr As %String) As %String
{
 Set AsteriskStr ="*"
 Set TempStr= AStr
 set PositionAsterisk =$FIND(TempStr,AsteriskStr,1) 
 if (PositionAsterisk=2)
 {Set $EXTRACT(TempStr,1,1)="%" }
 set PositionAsterisk =$FIND(TempStr,AsteriskStr,$LENGTH(TempStr))
 if (PositionAsterisk=($LENGTH(TempStr)+1))
 {Set $EXTRACT(TempStr,$LENGTH(TempStr),$LENGTH(TempStr))="%"}
 Elseif (PositionAsterisk=0)
 {Set $EXTRACT(TempStr,$LENGTH(TempStr)+1,$LENGTH(TempStr)+1)="%" }
 
 Quit "%"_TempStr
}

ClassMethod SwitchWhere(parOldFromTable As %String, parOldWhere As %String) As %String
{
	//commented and updated on 2008-06-30, suggested by WangWT, executed by HouJ
	/***comment begin 08-06-30***
	;ICD and mrcid_dateactiveto<Curdate
	s Curdate=+$h
	q:((parOldFromTable="SQLUser.MRC_ICDDx")&&(parOldWhere="")) " where MRCID_ICD9CM_Code is NOT null AND ALIAS_ParRef=MRCID_Rowid and (mrcid_dateactiveto=''or mrcid_dateactiveto is null or mrcid_dateactiveto>"_Curdate_") "
	q:(parOldFromTable="SQLUser.MRC_ICDDx") parOldWhere_" and ALIAS_ParRef=MRCID_Rowid and MRCID_ICD9CM_Code is NOT null and (mrcid_dateactiveto='' or mrcid_dateactiveto is null or mrcid_dateactiveto>"_Curdate_") "
	;Operation and oper_activedateto<>''
	q:((parOldFromTable="SQLUser.ORC_Operation")&&(parOldWhere="")) " where OPER_Code is NOT null AND ALIAS_ParRef=OPER_Rowid AND (oper_activedateto='' or oper_activedateto is null"_" or oper_activedateto>"_Curdate_") "
	q:(parOldFromTable="SQLUser.ORC_Operation") parOldWhere_" and ALIAS_ParRef=OPER_Rowid and OPER_Code is NOT null AND (oper_activedateto='' or oper_activedateto is null"_" or oper_activedateto>"_Curdate_") "
	***comment end 08-06-30***/ 
	
	//update begin 08-06-30
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

Query GetStdDicList(ADicCode As %String, AAias As %String, Acode As %String, ADesc As %String, APageNum As %Integer, ARowCount As %Integer) As %Query(ROWSPEC = "ID:%String,Alias:%String,Code:%String,DicDesc:%String")
{
}

ClassMethod GetStdDicListExecute(ByRef qHandle As %Binary, ADicCode As %String, AAias As %String, ACode As %String, ADesc As %String, APageNum As %Integer, ARowCount As %Integer) As %Status
{
 s qHandle="1" 
 s SQLCODE=0 
 //s %ROWID=0 
 s %counter=0
 s ID=""
 S %ResultID=""


 set result = ##class(%Library.ResultSet).%New()
 Set SqlString ="Select Name,TableName,DicAliasCol,DicCodeCol,DicDescCol From EMRmeta.StdDictionary "
 Set SqlWhereString =""
 if (ADicCode '="")
 {
 set TempCode= ADicCode //##class(EMRmeta.StdDictionary).ReplaceAsterisk(ADicCode)
 set SqlWhereString = "Where EMRmeta.StdDictionary.Code Like '"_TempCode_"'" 
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

 set DescBiteoffFlag= ##Class(EMRservice.BL.BLSysOption).CheckMinusFieldExist(DicTableName,DicDesc)

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
 Set GetDatasetSql = GetDatasetSql_AFieldSql_ " From "_##class(EMRservice.BL.BLStdDictionary).SwitchFromTable(DicTableName)
 //Set GetDatasetSql = GetDatasetSql_AFieldSql_ " From "_DicTableName

 Set GetWhereSql =""

 if ((DicAlias'="")&&(DicAlias'=$C(0)))
 { if (AAias '="")&&(AAias'=$C(0))
	    {
		  set TempAias =$ZCVT(##class(EMRservice.BL.BLStdDictionary).ReplaceAsterisk(AAias),"U")
		  
		  Set GetWhereSql =" Where UPPER("_DicAlias_") Like '"_TempAias_"' "
	    }
	}

 if ((DicCode'="")&&(DicCode'=$C(0)))
 {  
 if ((ACode '="")&&(ACode '=$C(0)))
	    {
		  set TempDicCode = $ZCVT(##class(EMRservice.BL.BLStdDictionary).ReplaceAsterisk(ACode),"U")
		  
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
		  set TempDesc =$ZCVT(##class(EMRservice.BL.BLStdDictionary).ReplaceAsterisk(ADesc),"U")
		  
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

ClassMethod GetStdDicListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetStdDicListExecute ]
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

ClassMethod GetStdDicListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetStdDicListExecute ]
{
 s qHandle="" 
 Quit $$$OK
}

/// Desc:  字典查询xml结果
/// Input: ADicCode 字典表代码
///       AItem 查询条件
///       APageNum 要取的页码
///       ARowCount 每页的行数
///       CountFlag true
///       AResultCount 结果总页数
///       SessionId 与这次字典查询对应的ID
/// OutPut:<DataSet><PageCount>20</PageCount><SessionId>190</SessionId><Items><Item><ID>1</ID><DicAlias>HBS</DicAlias><DicCode>00001</DicCode><DicDesc>河北省</DicDesc></Item>...</Items></DataSet>
/// Debug: w ##Class(EMRservice.BL.BLStdDictionary).GetStdDicXML("S01","",1,10,"true","","")
ClassMethod GetStdDicXML(ADicCode As %String, AItem As %String, APageNum As %Integer, ARowCount As %Integer, CountFlag As %String, AResultCount As %String, SessionId As %String, ATurnPage As %String, AConditionCode As %String = "", ACondition As %String = "", AConditionType As %String = "", ASessionArray As %ArrayOfDataTypes = "") As %GlobalBinaryStream
{
	s result = ##Class(%GlobalBinaryStream).%New()
    //检查参数有效性
 	s:(ADicCode = $C(0)) ADicCode = ""
 	s:(AItem = $C(0)) AItem = ""
 	s:(APageNum = $C(0)) APageNum = 0
 	s:(ARowCount = $C(0)) ARowCount = 0
 	q:((ADicCode = "")||(APageNum = "")||(ARowCount = "")) result
 	if (ATurnPage '= "true")				//字典单元点击查询按钮，生成查询结果集存储在临时global中，并取相应页码的结果
 	{ 
   		if (SessionId '= "") && (SessionId '= $c(0))
 	    {
	 	   s ASessionId = SessionId
	 	   K ^CacheTempStdQuery(SessionId)
	 	}
	 	else
	 	{
   		   s ASessionId = $I(^CacheTempStdQuery)
   		   s SessionId = ASessionId
   		   K ^CacheTempStdQuery(ASessionId)
	 	}
	 	
   		//生成字典查询结果集，并存储在临时global中
   		s PageCount= ..SelectNewStdDicPageCount(ADicCode,AItem,APageNum,ARowCount,ASessionId,AConditionCode,ACondition,AConditionType,ASessionArray)
   		s AResultCount = PageCount
   		
   		//取相应页码的结果
  		if (PageCount '= 0)
  		{ 
  			s dataSet = ##class(%ResultSet).%New("EMRservice.BL.BLStdDictionary:GetStdDicOrList")
			d dataSet.Execute(ADicCode,AItem,APageNum,ARowCount,ASessionId)
  		}
  		else
  		{
			s SessionId = 0
		}
 	}
 	else		//字典单元点击取前页或后页按钮，直接在临时global存储的结果集中取相应页码的结果
 	{
	 	if ((AResultCount '= 0)&&(AResultCount '= ""))
	 	{
	   		s ^CacheTempStdQuery(SessionId) = "True"
	   		s ASessionId = SessionId
	   		
	   		s pageStart = $G(^CacheTempStdQuery(ASessionId,"StdQueryPageStart"))
	   		s pageEnd = $G(^CacheTempStdQuery(ASessionId,"StdQueryPageEnd"))
	   		
	   		if (APageNum < pageStart)||(APageNum > pageEnd)
	   		{
		   		 K ^CacheTempStdQuery(SessionId)
		   		 
		   		//生成字典查询结果集，并存储在临时global中
   				s PageCount= ..SelectNewStdDicPageCount(ADicCode,AItem,APageNum,ARowCount,ASessionId,AConditionCode,ACondition, AConditionType, ASessionArray)
   				s AResultCount = PageCount
	   		}
	   		
	   		s TotalRowCount =  $G(^CacheTempStdQuery(ASessionId,"StdQueryDataCount"))	  
	   		if TotalRowCount '= 0
	   		{
		   	  	s dataSet = ##class(%ResultSet).%New("EMRservice.BL.BLStdDictionary:GetStdDicOrList")
				d dataSet.Execute(ADicCode,AItem,APageNum,ARowCount,SessionId)	
	 		}
	 		else
	 		{
		  		s SessionId = 0
		 	}
	 	}
 	}
 	
		s writer=##class(%XML.Writer).%New()
		d writer.OutputToStream(result)
		s writer.Charset="UTF-8"
		s status = writer.StartDocument()
		s status = writer.RootElement("DataSet")
		s status = writer.Element("PageCount")
		s status = writer.WriteChars(AResultCount)
		s status = writer.EndElement()
		s status = writer.Element("SessionId")
		s status = writer.WriteChars(SessionId)
		s status = writer.EndElement()
		
		if ($g(dataSet) '= "")
		{
			while (dataSet.Next())
			{
				s status = writer.Element("Item")
					s status = writer.Element("ID")
					s status = writer.WriteChars(dataSet.Data("ID"))
					s status = writer.EndElement()	
					s status = writer.Element("DicAlias")
					s status = writer.WriteChars(dataSet.Data("DicAlias"))
					s status = writer.EndElement()		
					s status = writer.Element("DicCode")
					s status = writer.WriteChars(dataSet.Data("DicCode"))
					s status = writer.EndElement()	
					s status = writer.Element("DicDesc")
					s status = writer.WriteChars(dataSet.Data("DicDesc"))
					s status = writer.EndElement()	
				s status = writer.EndElement()												
			}
		}
		
		s status = writer.EndRootElement()
		s status = writer.EndDocument()
	   	
	
	q result
}

Query GetStdDicOrList(ADicCode As %String, AItem As %String, APageNum As %Integer, ARowCount As %Integer, ASessionId As %String) As %Query(ROWSPEC = "ID:%String,DicAlias:%String,DicCode:%String,DicDesc:%String")
{
}

ClassMethod GetStdDicOrListExecute(ByRef qHandle As %Binary, ADicCode As %String, AItem As %String, APageNum As %Integer, ARowCount As %Integer, ASessionId As %String) As %Status
{
 s qHandle="1" 
 s SQLCODE=0 
 //s %ROWID=0 
 s %counter=0
 s ID=""
 S %ResultID=""
 //S ^CacheTempStdQuery($J)="True"	 
 if ($D(^CacheTempStdQuery(ASessionId)))
 {
	if ($G(^CacheTempStdQuery(ASessionId))="True") 
	{
		Set StartPageID= (APageNum-1)*ARowCount
		Set LastPageId = APageNum*ARowCount
		set PageKey= $O(^CacheTempStdQuery(ASessionId,""))
		
		Set PageNumCounter = PageKey -1
		While ((PageKey '="")&&(PageKey '= "StdQueryDataCount"))
		{
			s PageNumCounter = PageNumCounter + 1
			if (PageNumCounter> StartPageID)&(PageNumCounter <= LastPageId)
			{ 
				Set %ResultID(PageNumCounter-StartPageID)= $G(^CacheTempStdQuery(ASessionId,PageKey))	 
			}

			set PageKey= $O(^CacheTempStdQuery(ASessionId,PageKey)) 	
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

/// For P8
/// 重写 SelectNewStdDicPageCount 结束
ClassMethod SELECTStdDicPageCount(ADicCode As %String, AAias As %String, ACode As %String, ADesc As %String, ARowCount As %Integer) As %Integer
{
 set result = ##class(%Library.ResultSet).%New()
 Set SqlString ="Select Name,TableName,DicAliasCol,DicCodeCol,DicDescCol From EMRmeta.StdDictionary "
 Set SqlWhereString =""
 if (ADicCode '="")
 {
 set TempCode= ##class(EMRservice.BL.BLStdDictionary).ReplaceAsterisk(ADicCode)
 set SqlWhereString = "Where EMRmeta.StdDictionary.Code Like '"_TempCode_"'" 
 } 
 if (SqlWhereString '="") 
 { Set SqlString = SqlString_SqlWhereString }


 do result.Prepare(SqlString)
 do result.Execute()
 Set RowCount = 0
 While (result.Next())
 { 
 set GetCountSql = ""

 //Add for PinYin query
 Set GetCountSql = "Select Count(*) As ADataCount  From "_##class(EMRservice.BL.BLStdDictionary).SwitchFromTable(result.Data("TableName"))
 //

 //comment for PinYin query
 //Set GetCountSql = "Select Count(*) As ADataCount  From "_result.Data("TableName")

 Set GetWhereSql =""
 if (result.Data("DicAliasCol")'="")
 { if (AAias '="")
	    {
		  set TempAias =$ZCVT(##class(EMRservice.BL.BLStdDictionary).ReplaceAsterisk(AAias),"U")
		  
		  Set GetWhereSql =" Where UPPER("_result.Data("DicAliasCol")_") Like '"_TempAias_"' "
	    }
	}
 if (result.Data("DicCodeCol")'="")
 {  
 if (ACode '="")
	    {
		  set TempDicCode = $ZCVT(##class(EMRservice.BL.BLStdDictionary).ReplaceAsterisk(ACode),"U")
		  
		  if (GetWhereSql= "")
		  {
			 Set GetWhereSql =" Where UPPER("_result.Data("DicCodeCol")_") Like '"_TempDicCode_"' "
		  } 
		  elseif (GetWhereSql'="")
		  {
			Set GetWhereSql = GetWhereSql _" And  UPPER("_result.Data("DicCodeCol")_") Like '"_TempDicCode_"' "  
		   }
	    }
	}
 if (result.Data("DicDescCol")'="")
 {  
 if (ADesc '="")
	    {
		  set TempDesc =$ZCVT(##class(EMRservice.BL.BLStdDictionary).ReplaceAsterisk(ADesc),"U")
		  
		  if (GetWhereSql= "")
		  {
			 Set GetWhereSql =" Where UPPER("_result.Data("DicDescCol")_") Like '"_TempDesc_"' "
		  } 
		  elseif (GetWhereSql'="")
		  {
			Set GetWhereSql = GetWhereSql _" And  UPPER("_result.Data("DicDescCol")_") Like '"_TempDesc_"' "  
		   }
	    }
	}

 //Add for PinYin query
 ;s ^gjbtest("count")=result.Data("TableName")_"  "_GetWhereSql
 s GetWhereSql = ..SwitchWhere(result.Data("TableName"),GetWhereSql)
 //

 if GetWhereSql '=""
 {
	 set GetCountSql = GetCountSql_GetWhereSql   
	 }

 set Countresult = ##class(%Library.ResultSet).%New()
 do Countresult.Prepare(GetCountSql)
 do Countresult.Execute()
 While (Countresult.Next())
 {
	 Set RowCount = RowCount + Countresult.Data("ADataCount") 
	 }
	do Countresult.Close() 
 }
 do result.Close()

 Set RetureNum = 0
 Set TempModulo =0
 if ARowCount= 0
 {Quit 0}

 if RowCount '= 0
 {
 set RetureNum =RowCount\ARowCount
 Set TempModulo = RowCount#ARowCount
 if TempModulo'=0
 { Set RetureNum = RetureNum + 1} 
 }
 ;s ^gjbtest("RetureNum")=RetureNum
 Quit RetureNum
}

/// 重写 SelectNewStdDicPageCount, 若字典单元查询不出记录，请用一下注释内容替换上面的 SelectNewStdDicPageCount 方法
/// For P8
ClassMethod SelectNewStdDicPageCount(ADicCode As %String, AConditon As %String, APageNum As %Integer, ARowCount As %Integer, ASessionId As %String, ADefaultConditionCode As %String = "", ADefaultCondition As %String = "", AConditionType As %String = "", ASessionArray As %ArrayOfDataTypes = "") As %Integer
{
 
 //初始化返回值
 s returnPageCount = 0
 
 // 校验入参
 q:(ADicCode="") returnPageCount
 
 // 转换入参
 if ARowCount= 0	
 {	s ARowCount = 12}
 	
 //取字典及相关配置信息
 s arrDicInfo = ..GetDicInfo(ADicCode)
 q:(arrDicInfo = "") returnPageCount
 s DicTableName = arrDicInfo.GetAt("TableName")
 s DicAlias = arrDicInfo.GetAt("DicAliasCol")
 s DicCode = arrDicInfo.GetAt("DicCodeCol")
 s DicDesc = arrDicInfo.GetAt("DicDescCol")
	
 //是否保留字典描述列中的横线
 set isKeepMinus = ##Class(EMRservice.BL.BLSysOption).CheckMinusFieldExist(DicTableName,DicDesc)
 
 //查询条件中是否含有GB字符
 s hasGB=0
 s ComLength = $L(AConditon)
 for I=1:1:ComLength 
 {
	s GBStr= $E(AConditon,I)  
	if (($A(GBStr)>=19968)&& ($A(GBStr)<=40869))||(($A(GBStr)>=63744)&& ($A(GBStr)<=64045))
	{
		s hasGB=1
		q
	}
 }
 
 s minCount = (APageNum - 1) * ARowCount + 1
 s maxCount = minCount + (ARowCount * 10) - 1
 s:(minCount > (ARowCount * 5)) minCount = minCount - (ARowCount * 5)
 //s maxCount = ""
 
 //查询字典内容
 if (ADefaultConditionCode '= "")&&(ADefaultConditionCode '= $C(0))
 {
	 s totRowCount = ..SelectStdDicWithDefaultCond(minCount,maxCount,DicTableName, AConditon, DicAlias, DicCode, DicDesc, ASessionId, hasGB, isKeepMinus, ADefaultConditionCode, ADefaultCondition,AConditionType,ASessionArray)
 }
 else
 {
	 s totRowCount = ..SelectStdDicWithoutDefaultCond(minCount,maxCount,DicTableName, AConditon, DicAlias, DicCode, DicDesc, ASessionId, hasGB, isKeepMinus, AConditionType,ASessionArray)
 }
 
 s ^CacheTempStdQuery(ASessionId,"StdQueryDataCount") = totRowCount	
 s ^CacheTempStdQuery(ASessionId) = "True"
 
 s returnPageCount = totRowCount\ARowCount
 s modulo = totRowCount#ARowCount
 s:(modulo '= 0) returnPageCount = returnPageCount + 1  
 
 s ^CacheTempStdQuery(ASessionId,"StdQueryPageStart") = minCount\ARowCount+1
 s ^CacheTempStdQuery(ASessionId,"StdQueryPageEnd") = $case(returnPageCount < (APageNum + 10 - 1), 1:returnPageCount, :(APageNum + 10 - 1))
 
 q returnPageCount
}

/// Desc:	取字典信息
ClassMethod GetDicInfo(ADicCode As %String) As %ArrayOfDataTypes
{
	s dicInfo = ""
	
 	s dicID = "", dicTableName = "", dicAliasCol = "", dicCodeCol = "", dicDescCol = ""
 	&sql(select top 1 ID, TableName, DicAliasCol, DicCodeCol, DicDescCol
 		into :dicID, :dicTableName, :dicAliasCol, :dicCodeCol, :dicDescCol 
 		from EMRmeta.StdDictionary where EMRmeta.StdDictionary.Code = :ADicCode)
 	
 	q:(dicID = "")||(dicID = $c(0)) dicInfo
 
	
	s dicInfo = ##Class(%ArrayOfDataTypes).%New()
	d dicInfo.SetAt(dicTableName,"TableName")
	d dicInfo.SetAt(dicAliasCol,"DicAliasCol") 
	d dicInfo.SetAt(dicCodeCol,"DicCodeCol") 
	d dicInfo.SetAt(dicDescCol,"DicDescCol") 
	
	q dicInfo
}

/// Desc:	处理带有默认查询条件的字典
ClassMethod SelectStdDicWithDefaultCond(AMinCount As %String, AMaxCount As %String, ADicTableName As %String, AConditon As %String, ADicAliasCol As %String, ADicCodeCol As %String, ADicDescCol As %String, ASessionId As %String, AHasGB As %String, AIsKeepMinus As %String, ADefaultConditionCode As %String = "", ADefaultCondition As %String = "", AConditionType As %String = "", ASessionArray As %ArrayOfDataTypes = "") As %Integer
{
	s AConditon=AConditionType_"^"_AConditon
	s totRowCount = 0
	
	if ($zcvt(ADicTableName,"U") = "SQLUSER.SS_USER")&&(ADefaultConditionCode = "S001")
	{
		s totRowCount = ..SelectStdDic001(AMinCount, AMaxCount, AConditon, ADicAliasCol, ADicCodeCol, ADicDescCol, ASessionId, AHasGB, AIsKeepMinus, ADefaultCondition, ASessionArray)
	}
	elseif ($zcvt(ADicTableName,"U") = "SQLUSER.SS_USER")&&(ADefaultConditionCode = "S002")
	{
		s totRowCount = ..SelectStdDic002(AMinCount, AMaxCount, AConditon, ADicAliasCol, ADicCodeCol, ADicDescCol, ASessionId, AHasGB, AIsKeepMinus, ADefaultCondition, ASessionArray)
	}
	elseif ($zcvt(ADicTableName,"U") = "SQLUSER.SS_USER")&&(ADefaultConditionCode = "S003")
	{
		s totRowCount = ..SelectStdDic003(AMinCount, AMaxCount, AConditon, ADicAliasCol, ADicCodeCol, ADicDescCol, ASessionId, AHasGB, AIsKeepMinus, ADefaultCondition, ASessionArray)
	}
	elseif ($zcvt(ADicTableName,"U") = "EMRVIEW.OPERATION")&&(ADefaultConditionCode = "C001")
	{
		s totRowCount = ..SelectStdDic004(AMinCount, AMaxCount, AConditon, ADicAliasCol, ADicCodeCol, ADicDescCol, ASessionId, AHasGB, AIsKeepMinus, ADefaultCondition, ASessionArray)
	}
	elseif ($zcvt(ADicTableName,"U") = "EMRVIEW.OPERATIONCUTSITE")&&(ADefaultConditionCode = "C002")
	{
		s totRowCount = ..SelectStdDic005(AMinCount, AMaxCount, AConditon, ADicAliasCol, ADicCodeCol, ADicDescCol, ASessionId, AHasGB, AIsKeepMinus, ADefaultCondition, ASessionArray)
	}
	elseif ($zcvt(ADicTableName,"U") = "SQLUSER.CT_CITY")&&(ADefaultConditionCode = "S004")
	{		
		s totRowCount = ..SelectStdDic006(AMinCount, AMaxCount, AConditon, ADicAliasCol, ADicCodeCol, ADicDescCol, ASessionId, AHasGB, AIsKeepMinus, ADefaultCondition, ASessionArray)
	}
	elseif ($zcvt(ADicTableName,"U") = "SQLUSER.CT_CITYAREA")&&(ADefaultConditionCode = "S005")
	{		
		s totRowCount = ..SelectStdDic007(AMinCount, AMaxCount, AConditon, ADicAliasCol, ADicCodeCol, ADicDescCol, ASessionId, AHasGB, AIsKeepMinus, ADefaultCondition, ASessionArray)
	}
	elseif ($zcvt(ADicTableName,"U") = "SQLUSER.CT_DICEMR")&&(ADefaultConditionCode = "C003")
	{
		s totRowCount = ..SelectStdDic008(AMinCount, AMaxCount, AConditon, ADicAliasCol, ADicCodeCol, ADicDescCol, ASessionId, AHasGB, AIsKeepMinus, ADefaultCondition, ASessionArray)
	}
	elseif ($zcvt(ADicTableName,"U") = "SQLUSER.PAC_BED")&&(ADefaultConditionCode = "C004")
	{
		s totRowCount = ..SelectStdDic009(AMinCount, AMaxCount, AConditon, ADicAliasCol, ADicCodeCol, ADicDescCol, ASessionId, AHasGB, AIsKeepMinus, ADefaultCondition, ASessionArray)
	}
	elseif ($zcvt(ADicTableName,"U") = "SQLUSER.CT_CARPRVTP")&&(ADefaultConditionCode = "S006")
	{
		s totRowCount = ..SelectStdDic010(AMinCount, AMaxCount, AConditon, ADicAliasCol, ADicCodeCol, ADicDescCol, ASessionId, AHasGB, AIsKeepMinus, ADefaultCondition, ASessionArray)
	}
	elseif ($zcvt(ADicTableName,"U") = "SQLUSER.PAC_WARD_DIC")&&(ADefaultConditionCode = "S007")
	{
		s totRowCount = ..SelectStdDic011(AMinCount, AMaxCount, AConditon, ADicAliasCol, ADicCodeCol, ADicDescCol, ASessionId, AHasGB, AIsKeepMinus, ADefaultCondition, ASessionArray)
	}
	elseif ($zcvt(ADicTableName,"U") = "SQLUSER.ORC_OPERATIONCATEGORY")&&(ADefaultConditionCode = "COO5")
	{
		s totRowCount = ..SelectStdDic012(AMinCount, AMaxCount, AConditon, ADicAliasCol, ADicCodeCol, ADicDescCol, ASessionId, AHasGB, AIsKeepMinus, ADefaultCondition, ASessionArray)
	}
	elseif ($zcvt(ADicTableName,"U") = "SQLUSER.SS_USER")&&(ADefaultConditionCode = "S008")
	{
		s totRowCount = ..SelectStdDic013(AMinCount, AMaxCount, AConditon, ADicAliasCol, ADicCodeCol, ADicDescCol, ASessionId, AHasGB, AIsKeepMinus, ADefaultCondition, ASessionArray)
	}
    elseif ($zcvt(ADicTableName,"U") = "SQLUSER.SS_USER")&&(ADefaultConditionCode = "S009")
    {
        s totRowCount = ..SelectStdDic014(AMinCount, AMaxCount, AConditon, ADicAliasCol, ADicCodeCol, ADicDescCol, ASessionId, AHasGB, AIsKeepMinus, ADefaultCondition, ASessionArray)
    }
    elseif ($zcvt(ADicTableName,"U") = "SQLUSER.SS_USER")&&(ADefaultConditionCode = "S010")
    {
        s totRowCount = ..SelectStdDic015(AMinCount, AMaxCount, AConditon, ADicAliasCol, ADicCodeCol, ADicDescCol, ASessionId, AHasGB, AIsKeepMinus, ADefaultCondition, ASessionArray)
    }
	elseif ($zcvt(ADicTableName,"U") = "SQLUSER.SS_USER")&&(ADefaultConditionCode = "S011")
	{
		s totRowCount = ..SelectStdDic060(AMinCount, AMaxCount, AConditon, ADicAliasCol, ADicCodeCol, ADicDescCol, ASessionId, AHasGB, AIsKeepMinus, ADefaultCondition, ASessionArray)
	}
	elseif ($zcvt(ADicTableName,"U") = "SQLUSER.CT_LOC_DIC")&&(ADefaultConditionCode = "S012")
    {
        s totRowCount = ..SelectStdDic016(AMinCount, AMaxCount, AConditon, ADicAliasCol, ADicCodeCol, ADicDescCol, ASessionId, AHasGB, AIsKeepMinus, ADefaultCondition, ASessionArray)
    }
    elseif ($zcvt(ADicTableName,"U") = "SQLUSER.CT_LOC_DIC")&&(ADefaultConditionCode = "S012EX")
    {
        s totRowCount = ..SelectStdDic020(AMinCount, AMaxCount, AConditon, ADicAliasCol, ADicCodeCol, ADicDescCol, ASessionId, AHasGB, AIsKeepMinus, ADefaultCondition, ASessionArray)
    }
    elseif ($zcvt(ADicTableName,"U") = "SQLUSER.PAC_WARD_DIC")&&(ADefaultConditionCode = "S013")
    {
        s totRowCount = ..SelectStdDic017(AMinCount, AMaxCount, AConditon, ADicAliasCol, ADicCodeCol, ADicDescCol, ASessionId, AHasGB, AIsKeepMinus, ADefaultCondition, ASessionArray)
    }
    elseif ($zcvt(ADicTableName,"U") = "SQLUSER.CT_CAREPROV")&&(ADefaultConditionCode = "S014")
    {
        s totRowCount = ..SelectStdDic018(AMinCount, AMaxCount, AConditon, ADicAliasCol, ADicCodeCol, ADicDescCol, ASessionId, AHasGB, AIsKeepMinus, ADefaultCondition, ASessionArray)
    }
    /// 医保自费药品字典
    elseif($zcvt(ADicTableName,"U") = "SQLUSER.MRCZFYP")&&(ADefaultConditionCode = "S006")
    {
	s totRowCount = ..SelectStdDic019(AMinCount, AMaxCount, AConditon, ADicAliasCol, ADicCodeCol, ADicDescCol, ASessionId, AHasGB, AIsKeepMinus,ADefaultCondition, ASessionArray)
    }
	
	q totRowCount
}

/// Create:	2011-09-14	HouJ Wangwt
/// Desc:	查询【用户】字典内容：SQLUser.SS_User
/// Input：	AComItem 查询条件；ADicAliasCol 别名列；ADicCodeCol 代码列；ADicDescCol 描述列；ADescHasMinius 描述列是否有横线
ClassMethod SelectStdDic001(AMinCount As %String, AMaxCount As %String, AComItem As %String, ADicAliasCol As %String, ADicCodeCol As %String, ADicDescCol As %String, ASessionId As %String, AHasGB As %String, AIsKeepMinus As %String, ADefaultConditionValue As %String, ASessionArray As %ArrayOfDataTypes = "") As %Integer
{
	
	//结果行总数
	s totRowCount = 0
	
	//开始查询
	s rowid = 0
	for {
		s rowid=$o(^SSU("SSUSR",rowid))
		quit:(rowid = "")
		
		//取代码列,描述列,别名列
		if ($zcvt(ADicCodeCol,"U") = "SSUSR_INITIALS")
		{s CodeValue=$p($g(^SSU("SSUSR",rowid)),"^",1)}
		s DescValue=$p($g(^SSU("SSUSR",rowid)),"^",2)
		s AliasValue=$p($g(^SSU("SSUSR",rowid)),"^",11)
		
		//是否满足默认查询条件
		//wangwentao 20111020 update
		//s defaultDeptID = $p($g(^SSU("SSUSR",rowid)),"^",4)
		//continue:(defaultDeptID '= ADefaultConditionValue)
		//
		//^RB("RES",0,"CTPCP",{RES_CTPCP_DR},{RES_CTLOC_DR},{RES_RowId})  SQLUser.RB_Resource
		s (SSUSRCareProvDR,RESRowId) = ""
		s SSUSRCareProvDR = $p($g(^SSU("SSUSR",rowid)),"^",14)
		if (SSUSRCareProvDR'="")&&(ADefaultConditionValue'="") 
		{
			s defaultConditionLocIDValue = $O(^CTLOC(0,"Code",$zcvt(ADefaultConditionValue,"U"),""))
			continue:(defaultConditionLocIDValue="")
			s RESRowId=$o(^RB("RES",0,"CTPCP",SSUSRCareProvDR,defaultConditionLocIDValue,""))
			continue:(RESRowId="")
		}
		//wangwentao 20111020 update end
		
		//是否满足查询条件
		s CodeCom=0, DescCom=0, AliasCom=0
		if (AComItem '= "")
		{	
			
			s CodeCom= ##Class(EMRservice.Utility).CheckContain($ZCVT(CodeValue,"U"),$ZCVT(AComItem,"U"),AHasGB)
			S DescCom= ##Class(EMRservice.Utility).CheckContain($ZCVT(DescValue,"U"),$ZCVT(AComItem,"U"),AHasGB)
			if ((ADicAliasCol '="")&&(ADicAliasCol'=$C(0)))
			{	s AliasCom= ##Class(EMRservice.Utility).CheckContain($ZCVT(AliasValue,"U"),$ZCVT(AComItem,"U"),AHasGB)}
			
			if ((CodeCom '= 1)&&(DescCom '= 1)&&(AliasCom '= 1))
			{	continue}
		}
		
		//处理满足条件的结果并存入临时global
		s totRowCount = totRowCount + 1
		if (AIsKeepMinus = "0")
		{	s DescValue = $E(DescValue,$F(DescValue,"-"),$L(DescValue)) }
		s:((totRowCount >= AMinCount)&&(totRowCount <= AMaxCount)) ^CacheTempStdQuery(ASessionId,totRowCount) =$LB(rowid,AliasValue,CodeValue,DescValue)
	}
	
	s ^CacheTempStdQuery(ASessionId,"StdQueryDataCount")= totRowCount
	
	q totRowCount
}

/// Create:	2011-09-22	Wangwt [HIS]默认手术室员工字典
/// Desc:	查询【用户】字典内容：SQLUser.SS_User  
/// Input：	AComItem 查询条件；ADicAliasCol 别名列；ADicCodeCol 代码列；ADicDescCol 描述列；ADescHasMinius 描述列是否有横线
ClassMethod SelectStdDic002(AMinCount As %String, AMaxCount As %String, AComItem As %String, ADicAliasCol As %String, ADicCodeCol As %String, ADicDescCol As %String, ASessionId As %String, AHasGB As %String, AIsKeepMinus As %String, ADefaultConditionValue As %String, ASessionArray As %ArrayOfDataTypes = "") As %Integer
{
	//结果行总数
	s totRowCount = 0
	
	//开始查询
	s rowid = 0
	for {
		s rowid=$o(^SSU("SSUSR",rowid))
		quit:(rowid = "")
		
		//取代码列,描述列,别名列
		if ($zcvt(ADicCodeCol,"U") = "SSUSR_INITIALS")
		{s CodeValue=$p($g(^SSU("SSUSR",rowid)),"^",1)}
		s DescValue=$p($g(^SSU("SSUSR",rowid)),"^",2)
		s AliasValue=$p($g(^SSU("SSUSR",rowid)),"^",11)
		
		//是否满足默认查询条件
		//wangwentao 20111025 update
		//s defaultDeptID = $p($g(^SSU("SSUSR",rowid)),"^",4)
		//continue:(defaultDeptID '= ADefaultConditionValue)
		//
		//典默认手术室人员
		s defaultDeptID = ADefaultConditionValue
		//^RB("RES",0,"CTPCP",{RES_CTPCP_DR},{RES_CTLOC_DR},{RES_RowId})  SQLUser.RB_Resource
		s (SSUSRCareProvDR,RESRowId) = ""
		s SSUSRCareProvDR = $p($g(^SSU("SSUSR",rowid)),"^",14)
		s:(SSUSRCareProvDR'="")&&(defaultDeptID'="") RESRowId=$o(^RB("RES",0,"CTPCP",SSUSRCareProvDR,defaultDeptID,""))
		continue:(RESRowId="")
		//wangwentao 20111025 update end
		
		//是否满足查询条件
		s CodeCom=0, DescCom=0, AliasCom=0
		if (AComItem '= "")
		{	
			
			s CodeCom= ##Class(EMRservice.Utility).CheckContain($ZCVT(CodeValue,"U"),$ZCVT(AComItem,"U"),AHasGB)
			S DescCom= ##Class(EMRservice.Utility).CheckContain($ZCVT(DescValue,"U"),$ZCVT(AComItem,"U"),AHasGB)
			if ((ADicAliasCol '="")&&(ADicAliasCol'=$C(0)))
			{	s AliasCom= ##Class(EMRservice.Utility).CheckContain($ZCVT(AliasValue,"U"),$ZCVT(AComItem,"U"),AHasGB)}
			
			if ((CodeCom '= 1)&&(DescCom '= 1)&&(AliasCom '= 1))
			{	continue}
		}
		
		//处理满足条件的结果并存入临时global
		s totRowCount = totRowCount + 1
		if (AIsKeepMinus = "0")
		{	s DescValue = $E(DescValue,$F(DescValue,"-"),$L(DescValue)) }
		s:((totRowCount >= AMinCount)&&(totRowCount <= AMaxCount)) ^CacheTempStdQuery(ASessionId,totRowCount) =$LB(rowid,AliasValue,CodeValue,DescValue)
	}
	
	s ^CacheTempStdQuery(ASessionId,"StdQueryDataCount")= totRowCount
	
	q totRowCount
}

/// Create:	2011-09-22	Wangwt [HIS]默认麻醉科员工字典
/// Desc:	查询【用户】字典内容：SQLUser.SS_User  
/// Input：	AComItem 查询条件；ADicAliasCol 别名列；ADicCodeCol 代码列；ADicDescCol 描述列；ADescHasMinius 描述列是否有横线
ClassMethod SelectStdDic003(AMinCount As %String, AMaxCount As %String, AComItem As %String, ADicAliasCol As %String, ADicCodeCol As %String, ADicDescCol As %String, ASessionId As %String, AHasGB As %String, AIsKeepMinus As %String, ADefaultConditionValue As %String, ASessionArray As %ArrayOfDataTypes = "") As %Integer
{
	//结果行总数
	s totRowCount = 0
	
	//开始查询
	s rowid = 0
	for {
		s rowid=$o(^SSU("SSUSR",rowid))
		quit:(rowid = "")
		
		//取代码列,描述列,别名列
		if ($zcvt(ADicCodeCol,"U") = "SSUSR_INITIALS")
		{s CodeValue=$p($g(^SSU("SSUSR",rowid)),"^",1)}
		s DescValue=$p($g(^SSU("SSUSR",rowid)),"^",2)
		s AliasValue=$p($g(^SSU("SSUSR",rowid)),"^",11)
		

		//是否满足默认查询条件
		//wangwentao 20111025 update
		//s defaultDeptID = $p($g(^SSU("SSUSR",rowid)),"^",4)
		//continue:(defaultDeptID '= ADefaultConditionValue)
		//
		//典默认麻醉科人员
		s defaultDeptID = ADefaultConditionValue
		//^RB("RES",0,"CTPCP",{RES_CTPCP_DR},{RES_CTLOC_DR},{RES_RowId})  SQLUser.RB_Resource
		s (SSUSRCareProvDR,RESRowId) = ""
		s SSUSRCareProvDR = $p($g(^SSU("SSUSR",rowid)),"^",14)
		s:(SSUSRCareProvDR'="")&&(defaultDeptID'="") RESRowId=$o(^RB("RES",0,"CTPCP",SSUSRCareProvDR,defaultDeptID,""))
		continue:(RESRowId="")
		//wangwentao 20111025 update end
		
		//是否满足查询条件
		s CodeCom=0, DescCom=0, AliasCom=0
		if (AComItem '= "")
		{	
			
			s CodeCom= ##Class(EMRservice.Utility).CheckContain($ZCVT(CodeValue,"U"),$ZCVT(AComItem,"U"),AHasGB)
			S DescCom= ##Class(EMRservice.Utility).CheckContain($ZCVT(DescValue,"U"),$ZCVT(AComItem,"U"),AHasGB)
			if ((ADicAliasCol '="")&&(ADicAliasCol'=$C(0)))
			{	s AliasCom= ##Class(EMRservice.Utility).CheckContain($ZCVT(AliasValue,"U"),$ZCVT(AComItem,"U"),AHasGB)}
			
			if ((CodeCom '= 1)&&(DescCom '= 1)&&(AliasCom '= 1))
			{	continue}
		}
		
		//处理满足条件的结果并存入临时global
		s totRowCount = totRowCount + 1
		if (AIsKeepMinus = "0")
		{	s DescValue = $E(DescValue,$F(DescValue,"-"),$L(DescValue)) }
		s:((totRowCount >= AMinCount)&&(totRowCount <= AMaxCount)) ^CacheTempStdQuery(ASessionId,totRowCount) =$LB(rowid,AliasValue,CodeValue,DescValue)
	}
	
	s ^CacheTempStdQuery(ASessionId,"StdQueryDataCount")= totRowCount
	
	q totRowCount
}

/// Create:	2011-09-22	Wangwt
/// Desc:	查询 [EMR]手术操作字典 内容：EMRview.Operation  EMRmeta.CustomDictionary
/// Input：	AComItem 查询条件；ADicAliasCol 别名列；ADicCodeCol 代码列；ADicDescCol 描述列；ADescHasMinius 描述列是否有横线
///         ^DHCEMRM.CustomDictionaryD(258)=<<$LB("","XQBSYLS","0051","胸腔闭式引流术","^39^41^43^","Y","Operation","","手术操作字典","","","","")>>
ClassMethod SelectStdDic004(AMinCount As %String, AMaxCount As %String, AComItem As %String, ADicAliasCol As %String, ADicCodeCol As %String, ADicDescCol As %String, ASessionId As %String, AHasGB As %String, AIsKeepMinus As %String, ADefaultConditionValue As %String, ASessionArray As %ArrayOfDataTypes = "") As %Integer
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
		continue:($f(defaultDeptID , "^"_ADefaultConditionValue_"^")=0)
		
		//是否满足查询条件
		s CodeCom=0, DescCom=0, AliasCom=0
		if (AComItem '= "")
		{	
			
			s CodeCom= ##Class(EMRservice.Utility).CheckContain($ZCVT(CodeValue,"U"),$ZCVT(AComItem,"U"),AHasGB)
			S DescCom= ##Class(EMRservice.Utility).CheckContain($ZCVT(DescValue,"U"),$ZCVT(AComItem,"U"),AHasGB)
			if ((ADicAliasCol '="")&&(ADicAliasCol'=$C(0)))
			{	s AliasCom= ##Class(EMRservice.Utility).CheckContain($ZCVT(AliasValue,"U"),$ZCVT(AComItem,"U"),AHasGB)}
			
			if ((CodeCom '= 1)&&(DescCom '= 1)&&(AliasCom '= 1))
			{	continue}
		}
		
		//处理满足条件的结果并存入临时global
		s totRowCount = totRowCount + 1
		if (AIsKeepMinus = "0")
		{	s DescValue = $E(DescValue,$F(DescValue,"-"),$L(DescValue)) }
		s:((totRowCount >= AMinCount)&&(totRowCount <= AMaxCount)) ^CacheTempStdQuery(ASessionId,totRowCount) =$LB(rowid,AliasValue,CodeValue,DescValue)
	}
	
	s ^CacheTempStdQuery(ASessionId,"StdQueryDataCount")= totRowCount
	
	q totRowCount
}

/// Create:	2011-09-22	Wangwt
/// Desc:	查询 [EMR]切口位置字典 内容：EMRview.OperationCutSite  EMRmeta.CustomDictionary
/// Input：	AComItem 查询条件；ADicAliasCol 别名列；ADicCodeCol 代码列；ADicDescCol 描述列；ADescHasMinius 描述列是否有横线
///         ^DHCEMRM.CustomDictionaryD(258)=<<$LB("","XQBSYLS","0051","胸腔闭式引流术","^39^41^43^","Y","Operation","","手术操作字典","","","","")>>
ClassMethod SelectStdDic005(AMinCount As %String, AMaxCount As %String, AComItem As %String, ADicAliasCol As %String, ADicCodeCol As %String, ADicDescCol As %String, ASessionId As %String, AHasGB As %String, AIsKeepMinus As %String, ADefaultConditionValue As %String, ASessionArray As %ArrayOfDataTypes = "") As %Integer
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
		continue:($f(defaultDeptID , "^"_ADefaultConditionValue_"^")=0)
		
		//是否满足查询条件
		s CodeCom=0, DescCom=0, AliasCom=0
		if (AComItem '= "")
		{	
			
			s CodeCom= ##Class(EMRservice.Utility).CheckContain($ZCVT(CodeValue,"U"),$ZCVT(AComItem,"U"),AHasGB)
			S DescCom= ##Class(EMRservice.Utility).CheckContain($ZCVT(DescValue,"U"),$ZCVT(AComItem,"U"),AHasGB)
			if ((ADicAliasCol '="")&&(ADicAliasCol'=$C(0)))
			{	s AliasCom= ##Class(EMRservice.Utility).CheckContain($ZCVT(AliasValue,"U"),$ZCVT(AComItem,"U"),AHasGB)}
			
			if ((CodeCom '= 1)&&(DescCom '= 1)&&(AliasCom '= 1))
			{	continue}
		}
		
		//处理满足条件的结果并存入临时global
		s totRowCount = totRowCount + 1
		if (AIsKeepMinus = "0")
		{	s DescValue = $E(DescValue,$F(DescValue,"-"),$L(DescValue)) }
		s:((totRowCount >= AMinCount)&&(totRowCount <= AMaxCount)) ^CacheTempStdQuery(ASessionId,totRowCount) =$LB(rowid,AliasValue,CodeValue,DescValue)
	}
	
	s ^CacheTempStdQuery(ASessionId,"StdQueryDataCount")= totRowCount
	
	q totRowCount
}

/// Create:	2012-07-09	Guozt
/// Desc:	查询 [HIS]城市字典 内容：SQLUser.CT_City
/// Input：	AComItem 查询条件；ADicAliasCol 别名列；ADicCodeCol 代码列；ADicDescCol 描述列；ADescHasMinius 描述列是否有横线
ClassMethod SelectStdDic006(AMinCount As %String, AMaxCount As %String, AComItem As %String, ADicAliasCol As %String, ADicCodeCol As %String, ADicDescCol As %String, ASessionId As %String, AHasGB As %String, AIsKeepMinus As %String, ADefaultConditionValue As %String, ASessionArray As %ArrayOfDataTypes = "") As %Integer
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
		if ((ADicAliasCol '="")&&(ADicAliasCol'=$C(0)))
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
		i (PROVCode'="")&&(ADefaultConditionValue'="")&&(ADefaultConditionValue'=$c(0)) continue:(PROVCode'=ADefaultConditionValue)
		
		//是否满足查询条件
		s CodeCom=0, DescCom=0, AliasCom=0
		if (AComItem '= "")
		{	
			
			s CodeCom= ##Class(EMRservice.Utility).CheckContain($ZCVT(CodeValue,"U"),$ZCVT(AComItem,"U"),AHasGB)
			S DescCom= ##Class(EMRservice.Utility).CheckContain($ZCVT(DescValue,"U"),$ZCVT(AComItem,"U"),AHasGB)
			if ((ADicAliasCol '="")&&(ADicAliasCol'=$C(0)))
			{	s AliasCom= ##Class(EMRservice.Utility).CheckContain($ZCVT(AliasValue,"U"),$ZCVT(AComItem,"U"),AHasGB)}
			
			if ((CodeCom '= 1)&&(DescCom '= 1)&&(AliasCom '= 1))
			{	continue}
		}
		
		//处理满足条件的结果并存入临时global
		s totRowCount = totRowCount + 1
		if (AIsKeepMinus = "0")
		{	s DescValue = $E(DescValue,$F(DescValue,"-"),$L(DescValue)) }
		s:((totRowCount >= AMinCount)&&(totRowCount <= AMaxCount)) ^CacheTempStdQuery(ASessionId,totRowCount) =$LB(rowid,AliasValue,CodeValue,DescValue)
	}
	
	s ^CacheTempStdQuery(ASessionId,"StdQueryDataCount")= totRowCount
	
	q totRowCount
}

/// Create:	2012-07-23	Liaowp
/// Desc:	查询 [HIS]城市字典 内容：SQLUser.CT_CityArea
/// Input：	AComItem 查询条件；ADicAliasCol 别名列；ADicCodeCol 代码列；ADicDescCol 描述列；ADescHasMinius 描述列是否有横线
ClassMethod SelectStdDic007(AMinCount As %String, AMaxCount As %String, AComItem As %String, ADicAliasCol As %String, ADicCodeCol As %String, ADicDescCol As %String, ASessionId As %String, AHasGB As %String, AIsKeepMinus As %String, ADefaultConditionValue As %String, ASessionArray As %ArrayOfDataTypes = "") As %Integer
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
		if ((ADicAliasCol '="")&&(ADicAliasCol'=$C(0)))
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
		
		i (CityCode'="")&&(ADefaultConditionValue'="")&&(ADefaultConditionValue'=$c(0)) continue:(CityCode'=ADefaultConditionValue)
		
		//是否满足查询条件
		s CodeCom=0, DescCom=0, AliasCom=0
		if (AComItem '= "")
		{	
			
			s CodeCom= ##Class(EMRservice.Utility).CheckContain($ZCVT(CodeValue,"U"),$ZCVT(AComItem,"U"),AHasGB)
			S DescCom= ##Class(EMRservice.Utility).CheckContain($ZCVT(DescValue,"U"),$ZCVT(AComItem,"U"),AHasGB)
			if ((ADicAliasCol '="")&&(ADicAliasCol'=$C(0)))
			{	s AliasCom= ##Class(EMRservice.Utility).CheckContain($ZCVT(AliasValue,"U"),$ZCVT(AComItem,"U"),AHasGB)}
			
			if ((CodeCom '= 1)&&(DescCom '= 1)&&(AliasCom '= 1))
			{	continue}
		}
		
		//处理满足条件的结果并存入临时global
		s totRowCount = totRowCount + 1
		if (AIsKeepMinus = "0")
		{	s DescValue = $E(DescValue,$F(DescValue,"-"),$L(DescValue)) }
		s:((totRowCount >= AMinCount)&&(totRowCount <= AMaxCount)) ^CacheTempStdQuery(ASessionId,totRowCount) =$LB(rowid,AliasValue,CodeValue,DescValue)
	}
	
	s ^CacheTempStdQuery(ASessionId,"StdQueryDataCount")= totRowCount
	
	q totRowCount
}

/// Create:	2013-04-25	flc
/// Desc:	查询 科室诊断字典和标准字典 内容：User.DHCMRDiagnosICD  SQLUser.MRC_ICDDx
/// Input：	AComItem 查询条件；ADicAliasCol 别名列；ADicCodeCol 代码列；ADicDescCol 描述列；
///         
ClassMethod SelectStdDic008(AMinCount As %String, AMaxCount As %String, AComItem As %String, ADicAliasCol As %String, ADicCodeCol As %String, ADicDescCol As %String, ASessionId As %String, AHasGB As %String, AIsKeepMinus As %String, ADefaultConditionValue As %String, ASessionArray As %ArrayOfDataTypes = "") As %Integer
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
		continue:(CTrowid'=ADefaultConditionValue)
	
		s DCrowid=$p(^DHCDIAICD(rowid),"^",3)
		continue:(DCrowid = "")
		//取代码列,描述列,别名列
		s CodeValue=$p($g(^MRC("ID",DCrowid)),"^",4)		
		s DescValue=$p($g(^MRC("ID",DCrowid)),"^",2)		
		//取别名列
		s AliasValue=""
		if ((ADicAliasCol '="")&&(ADicAliasCol'=$C(0)))
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
		if (AComItem '= "")
		{	
			s CodeCom= ##Class(EMRservice.Utility).CheckContain($ZCVT(CodeValue,"U"),$ZCVT(AComItem,"U"),AHasGB)
			S DescCom= ##Class(EMRservice.Utility).CheckContain($ZCVT(DescValue,"U"),$ZCVT(AComItem,"U"),AHasGB)
			if ((ADicAliasCol '="")&&(ADicAliasCol'=$C(0)))
			{	s AliasCom= ##Class(EMRservice.Utility).CheckContain($ZCVT(AliasValue,"U"),$ZCVT(AComItem,"U"),AHasGB)}
			
			if ((CodeCom '= 1)&&(DescCom '= 1)&&(AliasCom '= 1))
			{	continue}
		}
		
		s totRowCount = totRowCount + 1
		s AliasValue = $P(AliasValue,$C(2),1)
		if (AIsKeepMinus = "0")
		{	s DescValue = $E(DescValue,$F(DescValue,"-"),$L(DescValue)) }	
		s DiaStr=DiaStr_"^"_CodeValue
		s ^CacheTempStdQueryDiag(ASessionId)=DiaStr	
		s:((totRowCount >= AMinCount)&&(totRowCount <= AMaxCount)) ^CacheTempStdQuery(ASessionId,totRowCount) =$LB(rowid,AliasValue,CodeValue,DescValue)
		
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
		if $zcvt(ADicCodeCol,"U")="MRCID_ROWID"
		{	
			//诊断字典代码列使用rowid，用在病案首页，方便传rowid给医政组做编目
			s CodeValue = rowid	
		}
		else
		{	s CodeValue=$p($g(^MRC("ID",rowid)),"^",4)	}
		
		//取描述列
		s DescValue=""
		if ($zcvt(ADicDescCol,"U")="MRCID_LONGDESCRIPTION")
		{	s DescValue=$p($g(^MRC("ID",rowid)),"^",36)}		//for 上海华山
		else
		{	s DescValue=$p($g(^MRC("ID",rowid)),"^",2)}
		
		//取代码列附加信息
		//s ICD9Map=" /"_$p($g(^MRC("ID",rowid)),"^",35)  //Comment and updated by Wangwt 2008-06-27
		s ICD9Map=""
		s ICD9MapRowDR=""
		s ICD9MapRowDR=##Class(EMRservice.BL.BLSysOption).GetOptionValueByName("ICDCodeExpand")
		if ICD9MapRowDR="Y"
		{
			s ICD9Map=" /"_$p($g(^MRC("ID",rowid)),"^",35) ;The Fourth Node is Parameter Value	
		}
		s CodeValue=CodeValue_ICD9Map
		
		//取别名列
		s AliasValue=""
		if ((ADicAliasCol '="")&&(ADicAliasCol'=$C(0)))
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
		if (AComItem '= "")
		{	
			s CodeCom= ##Class(EMRservice.Utility).CheckContain($ZCVT(CodeValue,"U"),$ZCVT(AComItem,"U"),AHasGB)
			S DescCom= ##Class(EMRservice.Utility).CheckContain($ZCVT(DescValue,"U"),$ZCVT(AComItem,"U"),AHasGB)
			if ((ADicAliasCol '="")&&(ADicAliasCol'=$C(0)))
			{	s AliasCom= ##Class(EMRservice.Utility).CheckContain($ZCVT(AliasValue,"U"),$ZCVT(AComItem,"U"),AHasGB)}
			
			if ((CodeCom '= 1)&&(DescCom '= 1)&&(AliasCom '= 1))
			{	continue}
		}
		
		//处理满足条件的结果并存入临时global
		s totRowCount = totRowCount + 1
		s AliasValue = $P(AliasValue,$C(2),1)
		if (AIsKeepMinus = "0")
		{	s DescValue = $E(DescValue,$F(DescValue,"-"),$L(DescValue)) }		
		continue:(DiaStr[CodeValue)
		s:((totRowCount >= AMinCount)&&(totRowCount <= AMaxCount)) ^CacheTempStdQuery(ASessionId,totRowCount) =$LB(rowid,AliasValue,CodeValue,DescValue)
	    } 	
	
	s ^CacheTempStdQuery(ASessionId,"StdQueryDataCount")= totRowCount
	k ^CacheTempStdQueryDiag(ASessionId)
	q totRowCount
}

/// Create:	2016-06-16	HouJian
/// Desc:	查询患者所在病区的床位信息， 内容：SQLUser.PAC_Ward
/// Input：	AComItem 查询条件；ADicAliasCol 别名列；ADicCodeCol 代码列；ADicDescCol 描述列；
ClassMethod SelectStdDic009(AMinCount As %String, AMaxCount As %String, AComItem As %String, ADicAliasCol As %String, ADicCodeCol As %String, ADicDescCol As %String, ASessionId As %String, AHasGB As %String, AIsKeepMinus As %String, ADefaultConditionValue As %String, ASessionArray As %ArrayOfDataTypes = "") As %Integer
{
	//结果行总数
	s totRowCount = 0
	
	if (ADefaultConditionValue = "")||(ADefaultConditionValue = $c(0))
	{
		s ^CacheTempStdQuery(ASessionId,"StdQueryDataCount")= totRowCount
		k ^CacheTempStdQueryDiag(ASessionId)
		q totRowCount
	}
		
	s pacWardID = ADefaultConditionValue
	
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
		if (AComItem '= "")
		{	
			s CodeCom= ##Class(EMRservice.Utility).CheckContain($ZCVT(CodeValue,"U"),$ZCVT(AComItem,"U"),AHasGB)
			S DescCom= ##Class(EMRservice.Utility).CheckContain($ZCVT(DescValue,"U"),$ZCVT(AComItem,"U"),AHasGB)
			if ((ADicAliasCol '="")&&(ADicAliasCol'=$C(0)))
			{	s AliasCom= ##Class(EMRservice.Utility).CheckContain($ZCVT(AliasValue,"U"),$ZCVT(AComItem,"U"),AHasGB)}
			
			if ((CodeCom '= 1)&&(DescCom '= 1)&&(AliasCom '= 1))
			{	continue}
		}
		
		s totRowCount = totRowCount + 1
		if (AIsKeepMinus = "0")
		{	s DescValue = $E(DescValue,$F(DescValue,"-"),$L(DescValue)) }	
		
		s:((totRowCount >= AMinCount)&&(totRowCount <= AMaxCount)) ^CacheTempStdQuery(ASessionId,totRowCount) =$LB(rowid,AliasValue,CodeValue,DescValue)
	  }
	  
	q totRowCount
}

/// Create:	2016-11-23	Donglulu
/// Desc:	查询 [HIS]职称字典（关联医护人员表） 内容：SQLUser.CT_CarPrvTp
/// Input：	AComItem 查询条件；ADicAliasCol 别名列；ADicCodeCol 代码列；ADicDescCol 描述列；ADescHasMinius 描述列是否有横线
/// Debug:  w ##Class(EMRservice.BL.BLStdDictionary).SelectStdDic010("","","CTCPT_Code","CTCPT_Desc","1",1,"","")
ClassMethod SelectStdDic010(AMinCount As %String, AMaxCount As %String, AComItem As %String, ADicAliasCol As %String, ADicCodeCol As %String, ADicDescCol As %String, ASessionId As %String, AHasGB As %String, AIsKeepMinus As %String, ADefaultConditionValue As %String, ASessionArray As %ArrayOfDataTypes = "") As %Integer
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
		if ((ADefaultConditionValue'="")&&(ADefaultConditionValue'=$c(0)))
		{
			s CTCareProvRowid = $o(^CTPCP(0,"Code",ADefaultConditionValue,""))
			q:(CTCareProvRowid = "")
			s CTPCPCarPrvTpDR = ""
			s CTPCPCarPrvTpDR=$p($g(^CTPCP(CTCareProvRowid,1)),"^",4)
			continue:(rowid '= CTPCPCarPrvTpDR)
		}
		
		//是否满足查询条件
		s CodeCom=0, DescCom=0, AliasCom=0
		if (AComItem '= "")
		{	
			
			s CodeCom= ##Class(EMRservice.Utility).CheckContain($ZCVT(CodeValue,"U"),$ZCVT(AComItem,"U"),AHasGB)
			S DescCom= ##Class(EMRservice.Utility).CheckContain($ZCVT(DescValue,"U"),$ZCVT(AComItem,"U"),AHasGB)
			if ((ADicAliasCol '="")&&(ADicAliasCol'=$C(0)))
			{	s AliasCom= ##Class(EMRservice.Utility).CheckContain($ZCVT(AliasValue,"U"),$ZCVT(AComItem,"U"),AHasGB)}
			
			if ((CodeCom '= 1)&&(DescCom '= 1)&&(AliasCom '= 1))
			{	continue}
		}
		
		//处理满足条件的结果并存入临时global
		s totRowCount = totRowCount + 1
		if (AIsKeepMinus = "0")
		{	s DescValue = $E(DescValue,$F(DescValue,"-"),$L(DescValue)) }
		s:((totRowCount >= AMinCount)&&(totRowCount <= AMaxCount)) ^CacheTempStdQuery(ASessionId,totRowCount) =$LB(rowid,AliasValue,CodeValue,DescValue)
	}
	
	s ^CacheTempStdQuery(ASessionId,"StdQueryDataCount")= totRowCount
	
	q totRowCount
}

/// Create:	2016-11-24	Donglulu
/// Desc:	查询【病室】字典内容【关联科室】：SQLUser.PAC_Ward
/// Input：	AComItem 查询条件；ADicAliasCol 别名列；ADicCodeCol 代码列；ADicDescCol 描述列；ADescHasMinius 描述列是否有横线
ClassMethod SelectStdDic011(AMinCount As %String, AMaxCount As %String, AComItem As %String, ADicAliasCol As %String, ADicCodeCol As %String, ADicDescCol As %String, ASessionId As %String, AHasGB As %String, AIsKeepMinus As %String, ADefaultConditionValue As %String, ASessionArray As %ArrayOfDataTypes = "") As %Integer
{
	
	//结果行总数
	s totRowCount = 0
	
	if ((ADefaultConditionValue'="")&&(ADefaultConditionValue'=$c(0)))
	{
		s ADefaultConditionValue = $o(^CTLOC(0,"Code",ADefaultConditionValue,""))
	}
			
	//开始查询
	s rowid = 0
	for {
		s rowid=$o(^PAWARD(rowid))
		quit:(rowid = "")
		
		//取代码列,描述列,别名列
		if ($zcvt(ADicCodeCol,"U") = "WARD_CODE")
		{	s CodeValue=$p($g(^PAWARD(rowid)),"^",1)}
		elseif ($zcvt(ADicCodeCol,"U") = "WARD_ROWID")
		{	s CodeValue = rowid }
		s DescValue=$p($g(^PAWARD(rowid)),"^",2)
		s AliasValue=""
		
		s WARDLocationDR=$p($g(^PAWARD(rowid)),"^",5)
		
		//是否满足默认查询条件
		if ((ADefaultConditionValue'="")&&(ADefaultConditionValue'=$c(0)))
		{
			s linkid = ""
			if (WARDLocationDR '= "")
			{
				s linkid = $o(^CTLOC(ADefaultConditionValue,"LINK",0,"Loc",WARDLocationDR,""))
			}
			continue:(linkid = "")
		}	
		
		
		//是否满足查询条件
		s CodeCom=0, DescCom=0, AliasCom=0
		if (AComItem '= "")
		{	
			
			s CodeCom= ##Class(EMRservice.Utility).CheckContain($ZCVT(CodeValue,"U"),$ZCVT(AComItem,"U"),AHasGB)
			S DescCom= ##Class(EMRservice.Utility).CheckContain($ZCVT(DescValue,"U"),$ZCVT(AComItem,"U"),AHasGB)
			if ((ADicAliasCol '="")&&(ADicAliasCol'=$C(0)))
			{	s AliasCom= ##Class(EMRservice.Utility).CheckContain($ZCVT(AliasValue,"U"),$ZCVT(AComItem,"U"),AHasGB)}
			
			if ((CodeCom '= 1)&&(DescCom '= 1)&&(AliasCom '= 1))
			{	continue}
		}
		
		//处理满足条件的结果并存入临时global
		s totRowCount = totRowCount + 1
		if (AIsKeepMinus = "0")
		{	s DescValue = $E(DescValue,$F(DescValue,"-"),$L(DescValue)) }
		s:((totRowCount >= AMinCount)&&(totRowCount <= AMaxCount)) ^CacheTempStdQuery(ASessionId,totRowCount) =$LB(rowid,AliasValue,CodeValue,DescValue)
	}
	
	s ^CacheTempStdQuery(ASessionId,"StdQueryDataCount")= totRowCount
	
	q totRowCount
}

/// Create:	2016-11-24	Donglulu
/// Desc:	查询 [EMR]手术级别字典【关联手术字典】 内容：ORC_OperationCategory
/// Input：	AComItem 查询条件；ADicAliasCol 别名列；ADicCodeCol 代码列；ADicDescCol 描述列；ADescHasMinius 描述列是否有横线
ClassMethod SelectStdDic012(AMinCount As %String, AMaxCount As %String, AComItem As %String, ADicAliasCol As %String, ADicCodeCol As %String, ADicDescCol As %String, ASessionId As %String, AHasGB As %String, AIsKeepMinus As %String, ADefaultConditionValue As %String, ASessionArray As %ArrayOfDataTypes = "") As %Integer
{
	
	//结果行总数
	s totRowCount = 0
	
	s id = ""
	s ADefaultConditionId = ""
	if ((ADefaultConditionValue'="")&&(ADefaultConditionValue'=$c(0)))
	{
		for {
			s id = $o(^ORC("OPER",id))
			quit:(id = "")
			if ($p(^ORC("OPER",id),"^",1) = ADefaultConditionValue )
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
		if ((ADefaultConditionValue'="")&&(ADefaultConditionValue'=$c(0)))
		{
			continue:(OPERDefaultCategoryDR '= rowid)
		}
		
		//是否满足查询条件
		s CodeCom=0, DescCom=0, AliasCom=0
		if (AComItem '= "")
		{	
			
			s CodeCom= ##Class(EMRservice.Utility).CheckContain($ZCVT(CodeValue,"U"),$ZCVT(AComItem,"U"),AHasGB)
			S DescCom= ##Class(EMRservice.Utility).CheckContain($ZCVT(DescValue,"U"),$ZCVT(AComItem,"U"),AHasGB)
			if ((ADicAliasCol '="")&&(ADicAliasCol'=$C(0)))
			{	s AliasCom= ##Class(EMRservice.Utility).CheckContain($ZCVT(AliasValue,"U"),$ZCVT(AComItem,"U"),AHasGB)}
			
			if ((CodeCom '= 1)&&(DescCom '= 1)&&(AliasCom '= 1))
			{	continue}
		}
		
		//处理满足条件的结果并存入临时global
		s totRowCount = totRowCount + 1
		if (AIsKeepMinus = "0")
		{	s DescValue = $E(DescValue,$F(DescValue,"-"),$L(DescValue)) }
		s:((totRowCount >= AMinCount)&&(totRowCount <= AMaxCount)) ^CacheTempStdQuery(ASessionId,totRowCount) =$LB(rowid,AliasValue,CodeValue,DescValue)
	}
	
	s ^CacheTempStdQuery(ASessionId,"StdQueryDataCount")= totRowCount
	
	q totRowCount
}

/// Create:	2017-09-19	 [HIS]默认本科室医生字典
/// Desc:	查询【用户】字典内容：SQLUser.SS_User  
/// Input：	AComItem 查询条件；ADicAliasCol 别名列；ADicCodeCol 代码列；ADicDescCol 描述列；ADescHasMinius 描述列是否有横线
ClassMethod SelectStdDic014(AMinCount As %String, AMaxCount As %String, AComItem As %String, ADicAliasCol As %String, ADicCodeCol As %String, ADicDescCol As %String, ASessionId As %String, AHasGB As %String, AIsKeepMinus As %String, ADefaultConditionValue As %String, ASessionArray As %ArrayOfDataTypes = "") As %Integer
{
	//结果行总数
	s totRowCount = 0
	//开始查询
	s rowid = 0
	for {
		s rowid=$o(^SSU("SSUSR",rowid))
		quit:(rowid = "")
		
		//取代码列,描述列,别名列
		if ($zcvt(ADicCodeCol,"U") = "SSUSR_INITIALS")
		{s CodeValue=$p($g(^SSU("SSUSR",rowid)),"^",1)}
		s DescValue=$p($g(^SSU("SSUSR",rowid)),"^",2)
		s AliasValue=$p($g(^SSU("SSUSR",rowid)),"^",11)
		

		//是否满足默认查询条件
		//^RB("RES",0,"CTPCP",{RES_CTPCP_DR},{RES_CTLOC_DR},{RES_RowId})  SQLUser.RB_Resource
		s (SSUSRCareProvDR,RESRowId) = ""
		s SSUSRCareProvDR = $p($g(^SSU("SSUSR",rowid)),"^",14)
		continue:(SSUSRCareProvDR="")
		//本科室
		s RESRowId=$o(^RB("RES",0,"CTPCP",SSUSRCareProvDR,ADefaultConditionValue,""))
		continue:(RESRowId="")
		//判断是否是医生
		s provobj = ##class(User.CTCareProv).%OpenId(SSUSRCareProvDR)
		continue:(provobj="")
		continue:($zcvt(provobj.CTPCPCarPrvTpDR.CTCPTInternalType,"U") '= "DOCTOR")
		
		//是否满足查询条件
		s CodeCom=0, DescCom=0, AliasCom=0
		if (AComItem '= "")
		{	
			
			s CodeCom= ##Class(EMRservice.Utility).CheckContain($ZCVT(CodeValue,"U"),$ZCVT(AComItem,"U"),AHasGB)
			S DescCom= ##Class(EMRservice.Utility).CheckContain($ZCVT(DescValue,"U"),$ZCVT(AComItem,"U"),AHasGB)
			if ((ADicAliasCol '="")&&(ADicAliasCol'=$C(0)))
			{	s AliasCom= ##Class(EMRservice.Utility).CheckContain($ZCVT(AliasValue,"U"),$ZCVT(AComItem,"U"),AHasGB)}
			
			if ((CodeCom '= 1)&&(DescCom '= 1)&&(AliasCom '= 1))
			{	continue}
		}
		
		//处理满足条件的结果并存入临时global
		s totRowCount = totRowCount + 1
		if (AIsKeepMinus = "0")
		{	s DescValue = $E(DescValue,$F(DescValue,"-"),$L(DescValue)) }
		s:((totRowCount >= AMinCount)&&(totRowCount <= AMaxCount)) ^CacheTempStdQuery(ASessionId,totRowCount) =$LB(rowid,AliasValue,CodeValue,DescValue)
	}
	
	s ^CacheTempStdQuery(ASessionId,"StdQueryDataCount")= totRowCount
	
	q totRowCount
}

/// Create:	2017-09-19 [HIS]默认本科室护士字典
/// Desc:	查询【用户】字典内容：SQLUser.SS_User  
/// Input：	AComItem 查询条件；ADicAliasCol 别名列；ADicCodeCol 代码列；ADicDescCol 描述列；ADescHasMinius 描述列是否有横线
ClassMethod SelectStdDic015(AMinCount As %String, AMaxCount As %String, AComItem As %String, ADicAliasCol As %String, ADicCodeCol As %String, ADicDescCol As %String, ASessionId As %String, AHasGB As %String, AIsKeepMinus As %String, ADefaultConditionValue As %String, ASessionArray As %ArrayOfDataTypes = "") As %Integer
{
	//结果行总数
	s totRowCount = 0
	
	//获取默认登录科室link的病房
	s LinkCtlocDr = ""
	for {
		//^CTLOC({CT_Loc.CTLOC_RowID},"LINK",0,"Loc",{LINK_CTLOC_DR},{LINK_Childsub}
		s LinkCtlocDr = $o(^CTLOC(ADefaultConditionValue,"LINK",0,"Loc",LinkCtlocDr))
		q:(LinkCtlocDr = "")
		
		//开始查询
		s rowid = 0
		for {
			s rowid=$o(^SSU("SSUSR",rowid))
			quit:(rowid = "")
			
			//取代码列,描述列,别名列
			if ($zcvt(ADicCodeCol,"U") = "SSUSR_INITIALS")
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
			if (AComItem '= "")
			{	
				
				s CodeCom= ##Class(EMRservice.Utility).CheckContain($ZCVT(CodeValue,"U"),$ZCVT(AComItem,"U"),AHasGB)
				S DescCom= ##Class(EMRservice.Utility).CheckContain($ZCVT(DescValue,"U"),$ZCVT(AComItem,"U"),AHasGB)
				if ((ADicAliasCol '="")&&(ADicAliasCol'=$C(0)))
				{	s AliasCom= ##Class(EMRservice.Utility).CheckContain($ZCVT(AliasValue,"U"),$ZCVT(AComItem,"U"),AHasGB)}
				
				if ((CodeCom '= 1)&&(DescCom '= 1)&&(AliasCom '= 1))
				{	continue}
			}
			
			//处理满足条件的结果并存入临时global
			s totRowCount = totRowCount + 1
			if (AIsKeepMinus = "0")
			{	s DescValue = $E(DescValue,$F(DescValue,"-"),$L(DescValue)) }
			s:((totRowCount >= AMinCount)&&(totRowCount <= AMaxCount)) ^CacheTempStdQuery(ASessionId,totRowCount) =$LB(rowid,AliasValue,CodeValue,DescValue)
		}
	}
	
	s ^CacheTempStdQuery(ASessionId,"StdQueryDataCount")= totRowCount
	
	q totRowCount
}

/// Create:	2019-5-6 yejian [HIS]默认手术室员工字典(包括外院手术医生)
/// Desc:	查询【用户】字典内容：SQLUser.SS_User  
/// Input：	AComItem 查询条件；ADicAliasCol 别名列；ADicCodeCol 代码列；ADicDescCol 描述列；ADescHasMinius 描述列是否有横线
ClassMethod SelectStdDic060(AMinCount As %String, AMaxCount As %String, AComItem As %String, ADicAliasCol As %String, ADicCodeCol As %String, ADicDescCol As %String, ASessionId As %String, AHasGB As %String, AIsKeepMinus As %String, ADefaultConditionValue As %String, ASessionArray As %ArrayOfDataTypes = "") As %Integer
{
	
	//结果行总数
	s totRowCount = 0
	
	//开始查询
	s rowid = 0
	for {
		s rowid=$o(^SSU("SSUSR",rowid))
		quit:(rowid = "")
		
		//取代码列,描述列,别名列
		if ($zcvt(ADicCodeCol,"U") = "SSUSR_INITIALS")
		{s CodeValue=$p($g(^SSU("SSUSR",rowid)),"^",1)}
		s DescValue=$p($g(^SSU("SSUSR",rowid)),"^",2)
		s AliasValue=$p($g(^SSU("SSUSR",rowid)),"^",11)
		
		//是否满足查询条件
		s CodeCom=0, DescCom=0, AliasCom=0
		if (AComItem '= "")
		{	
			
			s CodeCom= ##Class(EMRservice.Utility).CheckContain($ZCVT(CodeValue,"U"),$ZCVT(AComItem,"U"),AHasGB)
			S DescCom= ##Class(EMRservice.Utility).CheckContain($ZCVT(DescValue,"U"),$ZCVT(AComItem,"U"),AHasGB)
			if ((ADicAliasCol '="")&&(ADicAliasCol'=$C(0)))
			{	s AliasCom= ##Class(EMRservice.Utility).CheckContain($ZCVT(AliasValue,"U"),$ZCVT(AComItem,"U"),AHasGB)}
			
			if ((CodeCom '= 1)&&(DescCom '= 1)&&(AliasCom '= 1))
			{	continue}
		}
		
		//处理满足条件的结果并存入临时global
		s totRowCount = totRowCount + 1
		if (AIsKeepMinus = "0")
		{	s DescValue = $E(DescValue,$F(DescValue,"-"),$L(DescValue)) }
		s:((totRowCount >= AMinCount)&&(totRowCount <= AMaxCount)) ^CacheTempStdQuery(ASessionId,totRowCount) =$LB(rowid,AliasValue,CodeValue,DescValue)
	}
	s oDoctor = ##Class(web.UDHCANOPArrange).FindOtherCtcp(ADefaultConditionValue,"","Y")
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
		if (AIsKeepMinus = "0")
		{	s DescValue = $E(DescValue,$F(DescValue,"-"),$L(DescValue)) }
		s:((totRowCount >= AMinCount)&&(totRowCount <= AMaxCount)) ^CacheTempStdQuery(ASessionId,totRowCount) =$LB(rowid,AliasValue,CodeValue,DescValue)

	}
	s ^CacheTempStdQuery(ASessionId,"StdQueryDataCount")= totRowCount
	
	q totRowCount
}

/// Create:	2020-2-17	Donglulu
/// Desc:	查询对应医院【科室】字典内容：SQLUser.CT_Loc，筛选条件hospitalID
/// Input：	AComItem 查询条件；ADicAliasCol 别名列；ADicCodeCol 代码列；ADicDescCol 描述列；ADescHasMinius 描述列是否有横线
ClassMethod SelectStdDic016(AMinCount As %String, AMaxCount As %String, AComItem As %String, ADicAliasCol As %String, ADicCodeCol As %String, ADicDescCol As %String, ASessionId As %String, AHasGB As %String, AIsKeepMinus As %String, ADefaultConditionValue As %String, ASessionArray As %ArrayOfDataTypes = "") As %Integer
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
		continue:((ADefaultConditionValue '= "")&&(ADefaultConditionValue '= locHospitalId))
		
		//过滤病区数据
		s wardFlag = $p($g(^CTLOC(rowid)),"^",5)
		continue:(wardFlag="Y")
		
		//取代码列,描述列,别名列
		if ($zcvt(ADicCodeCol,"U") = "CTLOC_CODE")
		{	s CodeValue=$p($g(^CTLOC(rowid)),"^",1)}
		elseif ($zcvt(ADicCodeCol,"U") = "CTLOC_ROWID")
		{	s CodeValue=rowid}
		
		s DescValue=$p($g(^CTLOC(rowid)),"^",2)
		
		s AliasValue=""
		if ($zcvt(ADicAliasCol,"U") = "CTLOC_CONTACTNAME")
		{	s AliasValue = $p($g(^CTLOC(rowid)),"^",43)}
		
		//是否满足查询条件
		s CodeCom=0, DescCom=0, AliasCom=0
		if (AComItem '= "")
		{	
			
			s CodeCom= ##Class(EMRservice.Utility).CheckContain($ZCVT(CodeValue,"U"),$ZCVT(AComItem,"U"),AHasGB)
			S DescCom= ##Class(EMRservice.Utility).CheckContain($ZCVT(DescValue,"U"),$ZCVT(AComItem,"U"),AHasGB)
			if ((ADicAliasCol '="")&&(ADicAliasCol'=$C(0)))
			{	s AliasCom= ##Class(EMRservice.Utility).CheckContain($ZCVT(AliasValue,"U"),$ZCVT(AComItem,"U"),AHasGB)}
			
			if ((CodeCom '= 1)&&(DescCom '= 1)&&(AliasCom '= 1))
			{	continue}
		}
		
		//处理满足条件的结果并存入临时global
		s totRowCount = totRowCount + 1
		if (AIsKeepMinus = "0")
		{	s DescValue = $E(DescValue,$F(DescValue,"-"),$L(DescValue)) }
		//科室字典因前端应用情况（查询、浏览中科室数据）及HIS中基础数据的数据量，所以修改为不做min max控制
		//s:((totRowCount >= AMinCount)&&(totRowCount <= AMaxCount)) ^CacheTempStdQuery(ASessionId,totRowCount) =$LB(rowid,AliasValue,CodeValue,DescValue)
		s ^CacheTempStdQuery(ASessionId,totRowCount) =$LB(rowid,AliasValue,CodeValue,DescValue)
	
	}
	
	s ^CacheTempStdQuery(ASessionId,"StdQueryDataCount")= totRowCount
	
	q totRowCount
}

/// Create:	2020-2-17	Donglulu
/// Desc:	查询对应医院【病室】字典内容：SQLUser.PAC_Ward，筛选条件hospitalID
/// Input：	AComItem 查询条件；ADicAliasCol 别名列；ADicCodeCol 代码列；ADicDescCol 描述列；ADescHasMinius 描述列是否有横线
ClassMethod SelectStdDic017(AMinCount As %String, AMaxCount As %String, AComItem As %String, ADicAliasCol As %String, ADicCodeCol As %String, ADicDescCol As %String, ASessionId As %String, AHasGB As %String, AIsKeepMinus As %String, ADefaultConditionValue As %String, ASessionArray As %ArrayOfDataTypes = "") As %Integer
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
		continue:((ADefaultConditionValue '= "")&&(ADefaultConditionValue '= locHospitalId))
		
		//取代码列,描述列,别名列
		if ($zcvt(ADicCodeCol,"U") = "WARD_CODE")
		{	s CodeValue=$p($g(^PAWARD(rowid)),"^",1)}
		elseif ($zcvt(ADicCodeCol,"U") = "WARD_ROWID")
		{	s CodeValue = rowid }
		s DescValue=$p($g(^PAWARD(rowid)),"^",2)
		//病区描述 把描述列转换为简拼
		s AliasValue=##class(web.DHCINSUPort).GetCNCODE(DescValue,4,"")
		
		//是否满足查询条件
		s CodeCom=0, DescCom=0, AliasCom=0
		if (AComItem '= "")
		{	
			
			s CodeCom= ##Class(EMRservice.Utility).CheckContain($ZCVT(CodeValue,"U"),$ZCVT(AComItem,"U"),AHasGB)
			S DescCom= ##Class(EMRservice.Utility).CheckContain($ZCVT(DescValue,"U"),$ZCVT(AComItem,"U"),AHasGB)
			if ((ADicAliasCol '="")&&(ADicAliasCol'=$C(0)))
			{	s AliasCom= ##Class(EMRservice.Utility).CheckContain($ZCVT(AliasValue,"U"),$ZCVT(AComItem,"U"),AHasGB)}
			
			if ((CodeCom '= 1)&&(DescCom '= 1)&&(AliasCom '= 1))
			{	continue}
		}
		
		//处理满足条件的结果并存入临时global
		s totRowCount = totRowCount + 1
		if (AIsKeepMinus = "0")
		{	s DescValue = $E(DescValue,$F(DescValue,"-"),$L(DescValue)) }
		s:((totRowCount >= AMinCount)&&(totRowCount <= AMaxCount)) ^CacheTempStdQuery(ASessionId,totRowCount) =$LB(rowid,AliasValue,CodeValue,DescValue)
	}
	
	s ^CacheTempStdQuery(ASessionId,"StdQueryDataCount")= totRowCount
	
	q totRowCount
}

/// Create:	2020-2-17	Donglulu
/// Desc:	查询对应医院【医护人员】字典内容：SQLUser.CT_CareProv，筛选条件hospitalID
/// Input：	AComItem 查询条件；ADicAliasCol 别名列；ADicCodeCol 代码列；ADicDescCol 描述列；ADescHasMinius 描述列是否有横线
ClassMethod SelectStdDic018(AMinCount As %String, AMaxCount As %String, AComItem As %String, ADicAliasCol As %String, ADicCodeCol As %String, ADicDescCol As %String, ASessionId As %String, AHasGB As %String, AIsKeepMinus As %String, ADefaultConditionValue As %String, ASessionArray As %ArrayOfDataTypes = "") As %Integer
{
	//结果行总数
	s totRowCount = 0
	
	//开始查询
	s rowid = 0
	for {
		s rowid=$o(^CTPCP(rowid))
		quit:(rowid = "")
		
		if (ADefaultConditionValue '= "")
		{
			continue:(($d(^CTPCP(rowid,"HOSP",0,"Hosp")) > 0)&&($o(^CTPCP(rowid,"HOSP",0,"Hosp",ADefaultConditionValue,"")) = ""))
		}
		
		//取代码列,描述列,别名列
		if ($zcvt(ADicCodeCol,"U") = "CTPCP_CODE")
		{	s CodeValue=$p($g(^CTPCP(rowid,1)),"^",1)}
		elseif ($zcvt(ADicCodeCol,"U") = "CTPCP_ROWID")
		{	s CodeValue = rowid }
		s DescValue=$p($g(^CTPCP(rowid,1)),"^",2)
		s AliasValue=""
		
		//是否满足查询条件
		s CodeCom=0, DescCom=0, AliasCom=0
		if (AComItem '= "")
		{	
			
			s CodeCom= ##Class(EMRservice.Utility).CheckContain($ZCVT(CodeValue,"U"),$ZCVT(AComItem,"U"),AHasGB)
			S DescCom= ##Class(EMRservice.Utility).CheckContain($ZCVT(DescValue,"U"),$ZCVT(AComItem,"U"),AHasGB)
			if ((ADicAliasCol '="")&&(ADicAliasCol'=$C(0)))
			{	s AliasCom= ##Class(EMRservice.Utility).CheckContain($ZCVT(AliasValue,"U"),$ZCVT(AComItem,"U"),AHasGB)}
			
			if ((CodeCom '= 1)&&(DescCom '= 1)&&(AliasCom '= 1))
			{	continue}
		}
		
		//处理满足条件的结果并存入临时global
		s totRowCount = totRowCount + 1
		if (AIsKeepMinus = "0")
		{	s DescValue = $E(DescValue,$F(DescValue,"-"),$L(DescValue)) }
		s:((totRowCount >= AMinCount)&&(totRowCount <= AMaxCount)) ^CacheTempStdQuery(ASessionId,totRowCount) =$LB(rowid,AliasValue,CodeValue,DescValue)
	}
	
	s ^CacheTempStdQuery(ASessionId,"StdQueryDataCount")= totRowCount
	
	q totRowCount
}

/// Create:	wangyu
/// Desc:	查询【自费药品】
/// Input：	AComItem 查询条件；ADicAliasCol 别名列；ADicCodeCol 代码列；ADicDescCol 描述列；AHasGB 查询条件是否有中文字符；AIsKeepMinus 描述列是否有横线
///  w ##class(EMRservice.BL.BLStdDictionary).SelectStdDic019(1,200,"FuzzyMatch^","ALIAS_Text","MRCZFYP_Code","MRCZFYP_Desc","7903","0","0","3466")
ClassMethod SelectStdDic019(AMinCount As %String, AMaxCount As %String, AComItem As %String, ADicAliasCol As %String, ADicCodeCol As %String, ADicDescCol As %String, ASessionId As %String, AHasGB As %String, AIsKeepMinus As %String, ADefaultCondition As %String) As %Integer
{
	//结果行总数
	s totRowCount = 0
	s episodeID = ADefaultCondition
	s ds = ##Class(%Library.ResultSet).%New("EMRservice.HISInterface.StdDictionary:GetStdDictionaryList")
	d ds.Execute(episodeID)
	While (ds.Next())
	{
		//continue:(ds.Data("INTIMxmmc") = "")
		s CodeValue = ds.Data("INTIMxmmc")
		s DescValue = ds.Data("INTIMxmcode")
		s AliasValue = ##class(EMRservice.BL.BLStdDictionary).HZToPin(DescValue)		
		//是否满足查询条件
		s CodeCom=0, DescCom=0, AliasCom=0
		if (AComItem '= "")
		{	
			s CodeCom= ##Class(EMRservice.Utility).CheckContain($ZCVT(CodeValue,"U"),$ZCVT(AComItem,"U"),AHasGB)
			S DescCom= ##Class(EMRservice.Utility).CheckContain($ZCVT(DescValue,"U"),$ZCVT(AComItem,"U"),AHasGB)
			if ((ADicAliasCol '="")&&(ADicAliasCol'=$C(0)))
			{	s AliasCom= ##Class(EMRservice.Utility).CheckContain($ZCVT(AliasValue,"U"),$ZCVT(AComItem,"U"),AHasGB)}			
			if ((CodeCom '= 1)&&(DescCom '= 1)&&(AliasCom '= 1))
			{	continue}
		}		
		//处理满足条件的结果并存入临时global
		s totRowCount = totRowCount + 1
		s AliasValue = $P(AliasValue,$C(2),1)
		if (AIsKeepMinus = "0")
		{	s DescValue = $E(DescValue,$F(DescValue,"-"),$L(DescValue)) }		
		s:((totRowCount >= AMinCount)&&(totRowCount <= AMaxCount)) ^CacheTempStdQuery(ASessionId,totRowCount) = $LB(rowid,AliasValue,CodeValue,DescValue)
	}	
	s ^CacheTempStdQuery(ASessionId,"StdQueryDataCount")= totRowCount	
	q totRowCount
}

/// Desc:	处理没有默认查询条件的字典
ClassMethod SelectStdDicWithoutDefaultCond(AMinCount As %String, AMaxCount As %String, ADicTableName As %String, AConditon As %String, ADicAliasCol As %String, ADicCodeCol As %String, ADicDescCol As %String, ASessionId As %String, AHasGB As %String, AIsKeepMinus As %String, AConditionType As %String, ASessionArray As %ArrayOfDataTypes = "") As %Integer
{
	s AConditon=AConditionType_"^"_AConditon
	s totRowCount = 0
	
	if ($zcvt(ADicTableName,"U")="SQLUSER.MRC_ICDDX")
	{
		s totRowCount = ..SelectStdDicMRCICDDx(AMinCount, AMaxCount, AConditon, ADicAliasCol, ADicCodeCol, ADicDescCol, ASessionId, AHasGB, AIsKeepMinus,ASessionArray)
	}
	elseif ($zcvt(ADicTableName,"U")="SQLUSER.MRC_ICDDXZXY")
	{
		s totRowCount = ..SelectStdDicMRCICDDxZXY(AMinCount, AMaxCount, AConditon, ADicAliasCol, ADicCodeCol, ADicDescCol, ASessionId, AHasGB, AIsKeepMinus,ASessionArray)
	}
	elseif ($zcvt(ADicTableName,"U")="SQLUSER.MRC_ICDDXXY")
	{
		s totRowCount = ..SelectStdDicMRCICDDxXY(AMinCount, AMaxCount, AConditon, ADicAliasCol, ADicCodeCol, ADicDescCol, ASessionId, AHasGB, AIsKeepMinus,ASessionArray)
	}
	elseif ($zcvt(ADicTableName,"U")="SQLUSER.MRC_ICDDXZY")
	{
	 	s totRowCount = ..SelectStdDicMRCICDDxZY(AMinCount, AMaxCount, AConditon, ADicAliasCol, ADicCodeCol, ADicDescCol, ASessionId, AHasGB, AIsKeepMinus,ASessionArray)
	}
	elseif ($zcvt(ADicTableName,"U")="SQLUSER.MRC_ICDDXZYZB")
	{
		//中医主病字典表  add by niucaicai 2013-06-06
	 	s totRowCount = ..SelectStdDicMRCICDDxZYZB(AMinCount, AMaxCount, AConditon, ADicAliasCol, ADicCodeCol, ADicDescCol, ASessionId, AHasGB, AIsKeepMinus,ASessionArray)
	}
	elseif ($zcvt(ADicTableName,"U")="SQLUSER.MRC_ICDDXZYZZ")
	{
		//中医主证字典表  add by niucaicai 2013-06-06
	 	s totRowCount = ..SelectStdDicMRCICDDxZYZZ(AMinCount, AMaxCount, AConditon, ADicAliasCol, ADicCodeCol, ADicDescCol, ASessionId, AHasGB, AIsKeepMinus,ASessionArray)
	}
	elseif ($zcvt(ADicTableName,"U")="SQLUSER.CT_LOC")
 	{
	 	s totRowCount = ..SelectStdDicCTLoc(AMinCount, AMaxCount, AConditon, ADicAliasCol, ADicCodeCol, ADicDescCol, ASessionId, AHasGB, AIsKeepMinus,ASessionArray)
	}
	elseif ($zcvt(ADicTableName,"U")="SQLUSER.CT_LOC_DIC")
	{
		s totRowCount = ..SelectStdDicCTLoc(AMinCount, AMaxCount, AConditon, ADicAliasCol, ADicCodeCol, ADicDescCol, ASessionId, AHasGB, AIsKeepMinus,ASessionArray)
	}
	elseif ($zcvt(ADicTableName,"U")="SQLUSER.CT_NATION")
	{
		s totRowCount = ..SelectStdDicCTNation(AMinCount, AMaxCount, AConditon, ADicAliasCol, ADicCodeCol, ADicDescCol, ASessionId, AHasGB, AIsKeepMinus, ASessionArray)
	}
	elseif ($zcvt(ADicTableName,"U")="SQLUSER.SS_USER")
	{
		s totRowCount = ..SelectStdDicSSUser(AMinCount, AMaxCount, AConditon, ADicAliasCol, ADicCodeCol, ADicDescCol, ASessionId, AHasGB, AIsKeepMinus, ASessionArray)
	}
	elseif ($zcvt(ADicTableName,"U")="SQLUSER.PAC_WARD")
	{
		s totRowCount = ..SelectStdDicPACWard(AMinCount, AMaxCount, AConditon, ADicAliasCol, ADicCodeCol, ADicDescCol, ASessionId, AHasGB, AIsKeepMinus, ASessionArray)
	}
	elseif ($zcvt(ADicTableName,"U")="SQLUSER.PAC_WARD_DIC")
	{
		s totRowCount = ..SelectStdDicPACWard(AMinCount, AMaxCount, AConditon, ADicAliasCol, ADicCodeCol, ADicDescCol, ASessionId, AHasGB, AIsKeepMinus, ASessionArray)
	}	
	elseif ($zcvt(ADicTableName,"U")="SQLUSER.PHC_DRGMAST")
	{
		s totRowCount = ..SelectStdDicPHCDrgMast(AMinCount, AMaxCount, AConditon, ADicAliasCol, ADicCodeCol, ADicDescCol, ASessionId, AHasGB, AIsKeepMinus, ASessionArray)
	}
	elseif ($zcvt(ADicTableName,"U")="SQLUSER.CT_OCCUPATION")
	{
	 	s totRowCount = ..SelectStdDicCTOccupation(AMinCount, AMaxCount, AConditon, ADicAliasCol, ADicCodeCol, ADicDescCol, ASessionId, AHasGB, AIsKeepMinus, ASessionArray)
	}
	elseif ($zcvt(ADicTableName,"U")="SQLUSER.CT_COUNTRY")
	{
		s totRowCount = ..SelectStdDicCTCountry(AMinCount, AMaxCount, AConditon, ADicAliasCol, ADicCodeCol, ADicDescCol, ASessionId, AHasGB, AIsKeepMinus, ASessionArray)
	}
	elseif ($zcvt(ADicTableName,"U")="SQLUSER.CT_PROVINCE")
	{
		s totRowCount = ..SelectStdDicCTProvince(AMinCount, AMaxCount, AConditon, ADicAliasCol, ADicCodeCol, ADicDescCol, ASessionId, AHasGB, AIsKeepMinus, ASessionArray)
	}
	elseif ($zcvt(ADicTableName,"U")="SQLUSER.CT_CITY")
	{
		s totRowCount = ..SelectStdDicCTCity(AMinCount, AMaxCount, AConditon, ADicAliasCol, ADicCodeCol, ADicDescCol, ASessionId, AHasGB, AIsKeepMinus, ASessionArray)
	}
	elseif ($zcvt(ADicTableName,"U")="SQLUSER.CT_SEX")
	{
		s totRowCount = ..SelectStdDicCTSex(AMinCount, AMaxCount, AConditon, ADicAliasCol, ADicCodeCol, ADicDescCol, ASessionId, AHasGB, AIsKeepMinus, ASessionArray)
	}
	elseif ($zcvt(ADicTableName,"U")="SQLUSER.PAC_PATIENTCATEGORY")
	{
		s totRowCount = ..SelectStdDicPACPatientCategory(AMinCount, AMaxCount, AConditon, ADicAliasCol, ADicCodeCol, ADicDescCol, ASessionId, AHasGB, AIsKeepMinus, ASessionArray)
	}
	elseif ($zcvt(ADicTableName,"U")="SQLUSER.CT_ZIP")
	{
		s totRowCount = ..SelectStdDicCTZip(AMinCount, AMaxCount, AConditon, ADicAliasCol, ADicCodeCol, ADicDescCol, ASessionId, AHasGB, AIsKeepMinus, ASessionArray)
	}
	elseif ($zcvt(ADicTableName,"U")="SQLUSER.ORC_OPERATION")
	{
		s totRowCount = ..SelectStdDicORCOperation(AMinCount, AMaxCount, AConditon, ADicAliasCol, ADicCodeCol, ADicDescCol, ASessionId, AHasGB, AIsKeepMinus, ASessionArray)
	}
	elseif ($zcvt(ADicTableName,"U")="SQLUSER.CT_RELATION")
	{
		s totRowCount = ..SelectStdDicCTReleation(AMinCount, AMaxCount, AConditon, ADicAliasCol, ADicCodeCol, ADicDescCol, ASessionId, AHasGB, AIsKeepMinus, ASessionArray)
	}
	elseif ($zcvt(ADicTableName,"U")="EMRVIEW.PATTYPE") //$zcvt(ADicTableName,"U")="SQLUSER.DHCEMRVPATTYPE")
	{
		s totRowCount = ..SelectStdDicDHCEMRVPatType(AMinCount, AMaxCount, AConditon, ADicAliasCol, ADicCodeCol, ADicDescCol, ASessionId, AHasGB, AIsKeepMinus, ASessionArray)
	}
	elseif ($zcvt(ADicTableName,"U")="SQLUSER.ORC_ANAESTMETHOD")
	{
		s totRowCount = ..SelectStdDicORCAnaestMethod(AMinCount, AMaxCount, AConditon, ADicAliasCol, ADicCodeCol, ADicDescCol, ASessionId, AHasGB, AIsKeepMinus, ASessionArray)
	}
	elseif ($zcvt(ADicTableName,"U")="EMRVIEW.OPERATION")
	{
		s totRowCount = ..SelectStdDicEMRviewOperation(AMinCount, AMaxCount, AConditon, ADicAliasCol, ADicCodeCol, ADicDescCol, ASessionId, AHasGB, AIsKeepMinus, ASessionArray)
	}
	elseif ($zcvt(ADicTableName,"U")="SQLUSER.MRC_ICDDX_DIAGNOSIS")
	{
		//诊断 groupDR = "1"
		s totRowCount = ..SelectStdDicMRCICDDxDiag(AMinCount, AMaxCount, AConditon, ADicAliasCol, ADicCodeCol, ADicDescCol, ASessionId, AHasGB, AIsKeepMinus, ASessionArray)
	}
	elseif ($zcvt(ADicTableName,"U")="SQLUSER.MRC_ICDDX_INJURG")
	{
		//损伤 groupDR = "4"
		s totRowCount = ..SelectStdDicMRCICDDxInjury(AMinCount, AMaxCount, AConditon, ADicAliasCol, ADicCodeCol, ADicDescCol, ASessionId, AHasGB, AIsKeepMinus, ASessionArray)
	}
	elseif ($zcvt(ADicTableName,"U")="SQLUSER.MRC_ICDDX_MORPHOLOGY")
	{
		//肿瘤形态学 groupDR = "2"
		s totRowCount = ..SelectStdDicMRCICDDxMorphology(AMinCount, AMaxCount, AConditon, ADicAliasCol, ADicCodeCol, ADicDescCol, ASessionId, AHasGB, AIsKeepMinus, ASessionArray)
	}
	elseif ($zcvt(ADicTableName,"U")="SQLUSER.MRC_ICDDX_METASTATIC")
	{
		//肿瘤形态
		s totRowCount = ..SelectStdMRCICDDXMetastatic(AMinCount, AMaxCount, AConditon, ADicAliasCol, ADicCodeCol, ADicDescCol, ASessionId, AHasGB, AIsKeepMinus, ASessionArray)
	}
	elseif ($zcvt(ADicTableName,"U")="SQLUSER.MRC_ICDDX_OPERATION")
	{
		//手术 groupDR = "3"
		s totRowCount = ..SelectStdDicMRCICDDxOperation(AMinCount, AMaxCount, AConditon, ADicAliasCol, ADicCodeCol, ADicDescCol, ASessionId, AHasGB, AIsKeepMinus, ASessionArray)
	}
	elseif ($zcvt(ADicTableName,"U")="SQLUSER.MRC_ICDDX_ALLERGY")
	{
		//过敏 groupDR = "5"
		s totRowCount = ..SelectStdDicMRCICDDxAllergy(AMinCount, AMaxCount, AConditon, ADicAliasCol, ADicCodeCol, ADicDescCol, ASessionId, AHasGB, AIsKeepMinus, ASessionArray)
	}
	elseif ($zcvt(ADicTableName,"U")= "MRC_DIAGNOSSIGNSYMPTOM")||(($zcvt(ADicTableName,"U")= "SQLUSER.MRC_DIAGNOSSIGNSYMPTOM"))
	{
		//中医症型字典
		s totRowCount = ..SelectStdDicDiagnosSignSymptom(AMinCount, AMaxCount, AConditon, ADicAliasCol, ADicCodeCol, ADicDescCol, ASessionId, AHasGB, AIsKeepMinus, ASessionArray)
	}
	elseif ($zcvt(ADicTableName,"U")="SQLUSER.MRC_ICDDXINJURYPOISON")
	{
		//[HIS]ICD10损伤中毒外部因素字典 2012-02-03 wangwentao add
	 	s totRowCount = ..SelectStdMRCICDDxInjuryPoison(AMinCount, AMaxCount, AConditon, ADicAliasCol, ADicCodeCol, ADicDescCol, ASessionId, AHasGB, AIsKeepMinus, ASessionArray)
	}
	elseif ($zcvt(ADicTableName,"U")="SQLUSER.MRC_ICDDXPATHOLOGY")
	{
		//[HIS]ICD10病理诊断字典 2012-02-03 wangwentao add
	 	s totRowCount = ..SelectStdMRCICDDxPathology(AMinCount, AMaxCount, AConditon, ADicAliasCol, ADicCodeCol, ADicDescCol, ASessionId, AHasGB, AIsKeepMinus, ASessionArray)
	}
	elseif ($zcvt(ADicTableName,"U")="SQLUSER.MRC_ICDDXMEDALLERGY")
	{
		//[HIS]ICD10过敏类别字典 2012-02-03 wangwentao add
	 	s totRowCount = ..SelectStdMRCICDDxMedAllergy(AMinCount, AMaxCount, AConditon, ADicAliasCol, ADicCodeCol, ADicDescCol, ASessionId, AHasGB, AIsKeepMinus, ASessionArray)
	}
	elseif ($zcvt(ADicTableName,"U")="SQLUSER.MRC_ICDDXINPATIENT")
	{
		//[HIS]ICD10住院诊断字典 2012-02-03 wangwentao add
	 	s totRowCount = ..SelectStdMRCICDDxInpatient(AMinCount, AMaxCount, AConditon, ADicAliasCol, ADicCodeCol, ADicDescCol, ASessionId, AHasGB, AIsKeepMinus, ASessionArray)
	}
	elseif ($zcvt(ADicTableName,"U")="SQLUSER.CT_HEALTHCAREREGION")
	{
		//
		s totRowCount = ..SelectStdDicCTHealthCareRegion(AMinCount, AMaxCount, AConditon, ADicAliasCol, ADicCodeCol, ADicDescCol, ASessionId, AHasGB, AIsKeepMinus, ASessionArray)
	}
	elseif ($zcvt(ADicTableName,"U")="SQLUSER.DHC_WMR_ICDDX_DIAGNOSIS")
	{
		//医政编目字典诊断 groupDR = "1"
		s totRowCount = ..SelectStdDicWMRICDDxDiag(AMinCount, AMaxCount, AConditon, ADicAliasCol, ADicCodeCol, ADicDescCol, ASessionId, AHasGB, AIsKeepMinus, ASessionArray)
	}
	elseif ($zcvt(ADicTableName,"U")="SQLUSER.DHC_WMR_ICDDX_MORPHOLOGY")
	{
		//医政编目字典肿瘤形态学 groupDR = "2"
		s totRowCount = ..SelectStdDicWMRICDDxMorphology(AMinCount, AMaxCount, AConditon, ADicAliasCol, ADicCodeCol, ADicDescCol, ASessionId, AHasGB, AIsKeepMinus, ASessionArray)
	}
	elseif ($zcvt(ADicTableName,"U")="SQLUSER.DHC_WMR_ICDDX_OPERATION")
	{
		//医政编目字典手术 groupDR = "3"
		s totRowCount = ..SelectStdDicWMRICDDxOperation(AMinCount, AMaxCount, AConditon, ADicAliasCol, ADicCodeCol, ADicDescCol, ASessionId, AHasGB, AIsKeepMinus, ASessionArray)
	}
	elseif ($zcvt(ADicTableName,"U")="SQLUSER.DHC_WMR_ICDDX_INJURG")
	{
		//医政编目字典损伤 groupDR = "4"
		s totRowCount = ..SelectStdDicWMRICDDxInjury(AMinCount, AMaxCount, AConditon, ADicAliasCol, ADicCodeCol, ADicDescCol, ASessionId, AHasGB, AIsKeepMinus, ASessionArray)
	}
	elseif ($zcvt(ADicTableName,"U")="SQLUSER.DHC_WMR_ICDDX_ALLERGY")
	{
		//医政编目字典过敏 groupDR = "5"
		s totRowCount = ..SelectStdDicWMRICDDxAllergy(AMinCount, AMaxCount, AConditon, ADicAliasCol, ADicCodeCol, ADicDescCol, ASessionId, AHasGB, AIsKeepMinus, ASessionArray)
	}
	elseif ($zcvt(ADicTableName,"U")="SQLUSER.MRC_ICDDXOP")
	{
		//[HIS]ICD10门诊首页诊断字典
		s totRowCount = ..SelectStdDicMRCICDDxOP(AMinCount, AMaxCount, AConditon, ADicAliasCol, ADicCodeCol, ADicDescCol, ASessionId, AHasGB, AIsKeepMinus, ASessionArray)
	}
	elseif ($zcvt(ADicTableName,"U")="SQLUSER.ORC_OPERATIONOP")
	{
		//[HIS]ICD10门诊首页手术字典
		s totRowCount = ..SelectStdDicORCOperationOP(AMinCount, AMaxCount, AConditon, ADicAliasCol, ADicCodeCol, ADicDescCol, ASessionId, AHasGB, AIsKeepMinus, ASessionArray)
	}
	elseif ($zcvt(ADicTableName,"U") = "SQLUSER.CT_MARITAL")
	{
		s totRowCount = ..SelectStdDicCTMarital(AMinCount, AMaxCount, AConditon, ADicAliasCol, ADicCodeCol, ADicDescCol, ASessionId, AHasGB, AIsKeepMinus, ASessionArray)
	}
	elseif ($zcvt(ADicTableName,"U") = "SQLUSER.PAC_BED")
	{
		s totRowCount = ..SelectStdDicBed(AMinCount, AMaxCount, AConditon, ADicAliasCol, ADicCodeCol, ADicDescCol, ASessionId, AHasGB, AIsKeepMinus, ASessionArray)
	}
	elseif ($zcvt(ADicTableName,"U") = "SQLUSER.SS_USER_INTERN")
	{
		s totRowCount = ..SelectStdDicSSUserIntern(AMinCount, AMaxCount, AConditon, ADicAliasCol, ADicCodeCol, ADicDescCol, ASessionId, AHasGB, AIsKeepMinus, ASessionArray)
	}
	elseif($zcvt(ADicTableName,"U") = "SQLUSER.INC_Itm")
	{
		s totRowCount = ..SelectStdDicINCItm(AMinCount, AMaxCount, AConditon, ADicAliasCol, ADicCodeCol, ADicDescCol, ASessionId, AHasGB, AIsKeepMinus, ASessionArray)
	}
	elseif ($zcvt(ADicTableName,"U") = "SQLUSER.INSU_DICDATA")
	{
		s totRowCount = ..SelectStdDicINSUDicData(AMinCount, AMaxCount, AConditon, ADicAliasCol, ADicCodeCol, ADicDescCol, ASessionId, AHasGB, AIsKeepMinus, ASessionArray)
	}
	elseif($zcvt(ADicTableName,"U") = "SQLUSER.BDTRANSTYPE")
	{
		s totRowCount = ..SelectStdDicBDTransType(AMinCount, AMaxCount, AConditon, ADicAliasCol, ADicCodeCol, ADicDescCol, ASessionId, AHasGB, AIsKeepMinus, ASessionArray)
	}
	elseif($zcvt(ADicTableName,"U") = "SQLUSER.BDREQPRODUCT")
	{
		s totRowCount = ..SelectStdDicBDReqProduct(AMinCount, AMaxCount, AConditon, ADicAliasCol, ADicCodeCol, ADicDescCol, ASessionId, AHasGB, AIsKeepMinus, ASessionArray)
	}
	elseif($zcvt(ADicTableName,"U") = "SQLUSER.BDTRANSPURPOSE")
	{
		s totRowCount = ..SelectStdDicBDTransPurpose(AMinCount, AMaxCount, AConditon, ADicAliasCol, ADicCodeCol, ADicDescCol, ASessionId, AHasGB, AIsKeepMinus, ASessionArray)
	}
	elseif($zcvt(ADicTableName,"U") = "SQLUSER.BDBLOODGROUP")
	{
		s totRowCount = ..SelectStdDicBDBLOODGROUP(AMinCount, AMaxCount, AConditon, ADicAliasCol, ADicCodeCol, ADicDescCol, ASessionId, AHasGB, AIsKeepMinus, ASessionArray)
	}
	
	elseif ($zcvt(ADicTableName,"U")="SQLUSER.MRC_TCMTREATMENT")
	{
		s totRowCount = ..SelectStdDicMRCTCMTreatment(AMinCount, AMaxCount, AConditon, ADicAliasCol, ADicCodeCol, ADicDescCol, ASessionId, AHasGB, AIsKeepMinus, ASessionArray)
	}
	else
	{
		//处理动态字典
		s totRowCount = ..SelectDynamicStdDic(AMinCount, AMaxCount, ADicTableName, AConditon, ADicAliasCol, ADicCodeCol, ADicDescCol, ASessionId, AHasGB, AIsKeepMinus, ASessionArray)
	}	 
		
 
 	q totRowCount
}

ClassMethod SelectStdDicBed(AMinCount As %String, AMaxCount As %String, AComItem As %String, ADicAliasCol As %String, ADicCodeCol As %String, ADicDescCol As %String, ASessionId As %String, AHasGB As %String, AIsKeepMinus As %String, ASessionArray As %ArrayOfDataTypes = "") As %Integer
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
		if (AComItem '= "")
		{	
			s CodeCom= ##Class(EMRservice.Utility).CheckContain($ZCVT(CodeValue,"U"),$ZCVT(AComItem,"U"),AHasGB)
			S DescCom= ##Class(EMRservice.Utility).CheckContain($ZCVT(DescValue,"U"),$ZCVT(AComItem,"U"),AHasGB)
			if ((ADicAliasCol '="")&&(ADicAliasCol'=$C(0)))
			{	s AliasCom= ##Class(EMRservice.Utility).CheckContain($ZCVT(AliasValue,"U"),$ZCVT(AComItem,"U"),AHasGB)}
			
			if ((CodeCom '= 1)&&(DescCom '= 1)&&(AliasCom '= 1))
			{	continue}
		}
		
		s totRowCount = totRowCount + 1
		if (AIsKeepMinus = "0")
		{	s DescValue = $E(DescValue,$F(DescValue,"-"),$L(DescValue)) }	
		
		s:((totRowCount >= AMinCount)&&(totRowCount <= AMaxCount)) ^CacheTempStdQuery(ASessionId,totRowCount) =$LB(rowid,AliasValue,CodeValue,DescValue)
	  }
	  
	}
	
	q totRowCount
}

/// Create:	2017-4-12	Donglulu
/// Desc:	查询【实习医师，见习医师用户】字典内容：SQLUser.SS_User
/// Input：	AComItem 查询条件；ADicAliasCol 别名列；ADicCodeCol 代码列；ADicDescCol 描述列；ADescHasMinius 描述列是否有横线
ClassMethod SelectStdDicSSUserIntern(AMinCount As %String, AMaxCount As %String, AComItem As %String, ADicAliasCol As %String, ADicCodeCol As %String, ADicDescCol As %String, ASessionId As %String, AHasGB As %String, AIsKeepMinus As %String, ASessionArray As %ArrayOfDataTypes = "") As %Integer
{
	//结果行总数
	s totRowCount = 0
	
	//开始查询
	s rowid = 0
	for {
		s rowid=$o(^SSU("SSUSR",rowid))
		quit:(rowid = "")
		
		//取代码列,描述列,别名列
		if ($zcvt(ADicCodeCol,"U") = "SSUSR_INITIALS")
		{s CodeValue=$p($g(^SSU("SSUSR",rowid)),"^",1)}
		s DescValue=$p($g(^SSU("SSUSR",rowid)),"^",2)
		s AliasValue=$p($g(^SSU("SSUSR",rowid)),"^",11)
		
		s CTCareProvRowid = $p($g(^SSU("SSUSR",rowid)),"^",14)
		continue:(CTCareProvRowid ="")
		s CTPCPCarPrvTpDR = $p($g(^CTPCP(CTCareProvRowid,1)),"^",4)
		continue:(CTPCPCarPrvTpDR'=1)&&(CTPCPCarPrvTpDR'=19)
		
		//是否满足查询条件
		s CodeCom=0, DescCom=0, AliasCom=0
		if (AComItem '= "")
		{	
			
			s CodeCom= ##Class(EMRservice.Utility).CheckContain($ZCVT(CodeValue,"U"),$ZCVT(AComItem,"U"),AHasGB)
			S DescCom= ##Class(EMRservice.Utility).CheckContain($ZCVT(DescValue,"U"),$ZCVT(AComItem,"U"),AHasGB)
			if ((ADicAliasCol '="")&&(ADicAliasCol'=$C(0)))
			{	s AliasCom= ##Class(EMRservice.Utility).CheckContain($ZCVT(AliasValue,"U"),$ZCVT(AComItem,"U"),AHasGB)}
			
			if ((CodeCom '= 1)&&(DescCom '= 1)&&(AliasCom '= 1))
			{	continue}
		}
		
		//处理满足条件的结果并存入临时global
		s totRowCount = totRowCount + 1
		if (AIsKeepMinus = "0")
		{	s DescValue = $E(DescValue,$F(DescValue,"-"),$L(DescValue)) }
		s:((totRowCount >= AMinCount)&&(totRowCount <= AMaxCount)) ^CacheTempStdQuery(ASessionId,totRowCount) =$LB(rowid,AliasValue,CodeValue,DescValue)
	}
	
	s ^CacheTempStdQuery(ASessionId,"StdQueryDataCount")= totRowCount
	
	q totRowCount
}

/// Create:	2008-11-27	HouJ
/// Desc:	查询【诊断】字典内容：SQLUser.MRC_ICDDx
/// Input：	AComItem 查询条件；ADicAliasCol 别名列；ADicCodeCol 代码列；ADicDescCol 描述列；AHasGB 查询条件是否有中文字符；AIsKeepMinus 描述列是否有横线
ClassMethod SelectStdDicMRCICDDx(AMinCount As %String, AMaxCount As %String, AComItem As %String, ADicAliasCol As %String, ADicCodeCol As %String, ADicDescCol As %String, ASessionId As %String, AHasGB As %String, AIsKeepMinus As %String, ASessionArray As %ArrayOfDataTypes = "") As %Integer
{
	
	//结果行总数
	s totRowCount = 0
	
	//开始查询
	s rowid = 0
	for {
		s rowid=$o(^MRC("ID",rowid))
		quit:(rowid = "")
		if (ASessionArray.Count()'=0)
		{
			set hospId= ASessionArray.GetAt("HospitalID")
		}
		else
		{
			s hospId = 2
		}
		s:(rowid<100) ^CacheTemp("Debugger","EMR",$i(^CacheTemp))=$lb(hospId)
		continue:("N"=##Class(DHCDoc.Common.Hospital).GetHospShowDataFlag("MRC_ICDDx",rowid,hospId))
	
		//get and  validate date of the ICD item.  gjb 2007-12-25
		s dateFrom="",dateTo="",currentDate=""
		s dateFrom=$p($g(^MRC("ID",rowid)),"^",6)
		s dateTo=$p($g(^MRC("ID",rowid)),"^",7)
		s currentDate=$p($h,",",1)
		if (((dateFrom'="")&&(currentDate<dateFrom))||((dateTo'="")&&(currentDate>dateTo)))
		{	continue}
		
		//过滤掉无效诊断
		s IsValid = $p($g(^MRC("ID",rowid)),"^",27)
		continue:(IsValid = "N")
		
		//20120426 wangwentao add
		//校验ICD10,过滤门诊诊断 
		s flagCode = $p($g(^MRC("ID",rowid)),"^",4)
		continue:(flagCode="")||($e(flagCode,1,2) = "MZ")
		
		//20130523 wangwentao add
		//校验ICD10,北京门诊首页过滤门诊诊断
		//MRCID_MorphologyCode {"Y":门诊诊断,"N":住院诊断,"":通用诊断}
		s flagCode = $p($g(^MRC("ID",rowid)),"^",38)
		s HospitalName=##class(EMRservice.BL.BLSysOption).GetOptionValueByName("HospitalName")
	 	if HospitalName = "BeiJingFXYY" 
	 	{
			continue:($zcvt(flagCode,"U")="N")
		}
		else
		{
			continue:($zcvt(flagCode,"U")="Y")
		}
		
		//取代码列
		if $zcvt(ADicCodeCol,"U")="MRCID_ROWID"
		{	
			//诊断字典代码列使用rowid，用在病案首页，方便传rowid给医政组做编目
			s CodeValue = rowid	
		}
		else
		{	s CodeValue=$p($g(^MRC("ID",rowid)),"^",4)	}
		
		//取描述列
		s DescValue=""
		if ($zcvt(ADicDescCol,"U")="MRCID_LONGDESCRIPTION")
		{	s DescValue=$p($g(^MRC("ID",rowid)),"^",36)}		//for 上海华山
		else
		{	s DescValue=$p($g(^MRC("ID",rowid)),"^",2)}
		
		//取代码列附加信息
		//s ICD9Map=" /"_$p($g(^MRC("ID",rowid)),"^",35)  //Comment and updated by Wangwt 2008-06-27
		s ICD9Map=""
		s ICD9MapRowDR=""
		s ICD9MapRowDR=##Class(EMRservice.BL.BLSysOption).GetOptionValueByName("ICDCodeExpand")
		if ICD9MapRowDR="Y"
		{
			s ICD9Map=" /"_$p($g(^MRC("ID",rowid)),"^",35) ;The Fourth Node is Parameter Value	
		}
		s CodeValue=CodeValue_ICD9Map
		
		//取别名列
		s AliasValue=""
		if ((ADicAliasCol '="")&&(ADicAliasCol'=$C(0)))
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
		if (AComItem '= "")
		{	
			s CodeCom= ##Class(EMRservice.Utility).CheckContain($ZCVT(CodeValue,"U"),$ZCVT(AComItem,"U"),AHasGB)
			S DescCom= ##Class(EMRservice.Utility).CheckContain($ZCVT(DescValue,"U"),$ZCVT(AComItem,"U"),AHasGB)
			if ((ADicAliasCol '="")&&(ADicAliasCol'=$C(0)))
			{	s AliasCom= ##Class(EMRservice.Utility).CheckContain($ZCVT(AliasValue,"U"),$ZCVT(AComItem,"U"),AHasGB)}
			if ((CodeCom '= 1)&&(DescCom '= 1)&&(AliasCom '= 1)&&(AliasText '= 1))
			{	continue}
		}
		
		if ((ADicAliasCol '="")&&(ADicAliasCol'=$C(0)))
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
		s:(AIsKeepMinus = "0") DescValue = $E(DescValue,$F(DescValue,"-"),$L(DescValue))
		
		s:((totRowCount >= AMinCount)&&(totRowCount <= AMaxCount)) ^CacheTempStdQuery(ASessionId,totRowCount) = $LB(rowid,AliasValue,CodeValue,DescValue)
	}
	
	s ^CacheTempStdQuery(ASessionId,"StdQueryDataCount")= totRowCount
	
	q totRowCount
}

/// Desc:	查询【中西医诊断】字典内容：SQLUser.MRC_ICDDxZXY
///         过滤掉损伤中毒、病理诊断
/// Create:	2018-6-22	
/// Creator: Candy
/// Input：	AComItem 查询条件；ADicAliasCol 别名列；ADicCodeCol 代码列；ADicDescCol 描述列；AHasGB 查询条件是否有中文字符；AIsKeepMinus 描述列是否有横线
ClassMethod SelectStdDicMRCICDDxZXY(AMinCount As %String, AMaxCount As %String, AComItem As %String, ADicAliasCol As %String, ADicCodeCol As %String, ADicDescCol As %String, ASessionId As %String, AHasGB As %String, AIsKeepMinus As %String, ASessionArray As %ArrayOfDataTypes = "") As %Integer
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
		s HospitalName=##class(EMRservice.BL.BLSysOption).GetOptionValueByName("HospitalName")
	 	if HospitalName = "BeiJingFXYY" 
	 	{
			continue:($zcvt(flagCode,"U")="N")
		}
		else
		{
			continue:($zcvt(flagCode,"U")="Y")
		}
		
		//取代码列
		if $zcvt(ADicCodeCol,"U")="MRCID_ROWID"
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
		if ($zcvt(ADicDescCol,"U")="MRCID_LONGDESCRIPTION")
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
		s ICD9MapRowDR=##Class(EMRservice.BL.BLSysOption).GetOptionValueByName("ICDCodeExpand")
		if ICD9MapRowDR="Y"
		{
			s ICD9Map=" /"_$p($g(^MRC("ID",rowid)),"^",35) ;The Fourth Node is Parameter Value	
		}
		s CodeValue=CodeValue_ICD9Map
		
		//取别名列
		s AliasValue=""
		if ((ADicAliasCol '="")&&(ADicAliasCol'=$C(0)))
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
		if (AComItem '= "")
		{	
			s CodeCom= ##Class(EMRservice.Utility).CheckContain($ZCVT(CodeValue,"U"),$ZCVT(AComItem,"U"),AHasGB)
			S DescCom= ##Class(EMRservice.Utility).CheckContain($ZCVT(DescValue,"U"),$ZCVT(AComItem,"U"),AHasGB)
			if ((ADicAliasCol '="")&&(ADicAliasCol'=$C(0)))
			{	s AliasCom= ##Class(EMRservice.Utility).CheckContain($ZCVT(AliasValue,"U"),$ZCVT(AComItem,"U"),AHasGB)}
			
			if ((CodeCom '= 1)&&(DescCom '= 1)&&(AliasCom '= 1))
			{	continue}
		}
		
		//处理满足条件的结果并存入临时global
		s totRowCount = totRowCount + 1
		s AliasValue = $P(AliasValue,$C(2),1)
		s:(AIsKeepMinus = "0") DescValue = $E(DescValue,$F(DescValue,"-"),$L(DescValue))
		
		s:((totRowCount >= AMinCount)&&(totRowCount <= AMaxCount)) ^CacheTempStdQuery(ASessionId,totRowCount) = $LB(rowid,AliasValue,CodeValue,DescValue)
	}
	
	s ^CacheTempStdQuery(ASessionId,"StdQueryDataCount")= totRowCount
	
	q totRowCount
}

/// Create:	2012-04-24	HouJ
/// Desc:	查询【诊断】字典内容：SQLUser.MRC_ICDDxXY 西医诊断
/// Input：	AComItem 查询条件；ADicAliasCol 别名列；ADicCodeCol 代码列；ADicDescCol 描述列；AHasGB 查询条件是否有中文字符；AIsKeepMinus 描述列是否有横线
ClassMethod SelectStdDicMRCICDDxXY(AMinCount As %String, AMaxCount As %String, AComItem As %String, ADicAliasCol As %String, ADicCodeCol As %String, ADicDescCol As %String, ASessionId As %String, AHasGB As %String, AIsKeepMinus As %String, ASessionArray As %ArrayOfDataTypes = "") As %Integer
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
		if $zcvt(ADicCodeCol,"U")="MRCID_ROWID"
		{	
			//诊断字典代码列使用rowid，用在病案首页，方便传rowid给医政组做编目
			s CodeValue = rowid	
		}
		else
		{	s CodeValue=$p($g(^MRC("ID",rowid)),"^",4)	}
		
		//取描述列
		s DescValue=""
		if ($zcvt(ADicDescCol,"U")="MRCID_LONGDESCRIPTION")
		{	s DescValue=$p($g(^MRC("ID",rowid)),"^",36)}		//for 上海华山
		else
		{	s DescValue=$p($g(^MRC("ID",rowid)),"^",2)}
		
		//取代码列附加信息
		//s ICD9Map=" /"_$p($g(^MRC("ID",rowid)),"^",35)  //Comment and updated by Wangwt 2008-06-27
		s ICD9Map=""
		s ICD9MapRowDR=""
		s ICD9MapRowDR=##Class(EMRservice.BL.BLSysOption).GetOptionValueByName("ICDCodeExpand")
		if ICD9MapRowDR="Y"
		{
			s ICD9Map=" /"_$p($g(^MRC("ID",rowid)),"^",35) ;The Fourth Node is Parameter Value	
		}
		s CodeValue=CodeValue_ICD9Map
		
		//取别名列
		s AliasValue=""
		if ((ADicAliasCol '="")&&(ADicAliasCol'=$C(0)))
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
		if (AComItem '= "")
		{	
			s CodeCom= ##Class(EMRservice.Utility).CheckContain($ZCVT(CodeValue,"U"),$ZCVT(AComItem,"U"),AHasGB)
			S DescCom= ##Class(EMRservice.Utility).CheckContain($ZCVT(DescValue,"U"),$ZCVT(AComItem,"U"),AHasGB)
			if ((ADicAliasCol '="")&&(ADicAliasCol'=$C(0)))
			{	s AliasCom= ##Class(EMRservice.Utility).CheckContain($ZCVT(AliasValue,"U"),$ZCVT(AComItem,"U"),AHasGB)}
			
			if ((CodeCom '= 1)&&(DescCom '= 1)&&(AliasCom '= 1))
			{	continue}
		}
		
		//处理满足条件的结果并存入临时global
		s totRowCount = totRowCount + 1
		s AliasValue = $P(AliasValue,$C(2),1)
		if (AIsKeepMinus = "0")
		{	s DescValue = $E(DescValue,$F(DescValue,"-"),$L(DescValue)) }
		
		s:((totRowCount >= AMinCount)&&(totRowCount <= AMaxCount)) ^CacheTempStdQuery(ASessionId,totRowCount) = $LB(rowid,AliasValue,CodeValue,DescValue)
	}
	
	s ^CacheTempStdQuery(ASessionId,"StdQueryDataCount")= totRowCount
	
	q totRowCount
}

/// Create:	2008-11-27	HouJ
/// Desc:	查询【诊断】字典内容：SQLUser.MRC_ICDDx
/// Input：	AComItem 查询条件；ADicAliasCol 别名列；ADicCodeCol 代码列；ADicDescCol 描述列；AHasGB 查询条件是否有中文字符；AIsKeepMinus 描述列是否有横线
ClassMethod SelectStdDicMRCICDDxZY(AMinCount As %String, AMaxCount As %String, AComItem As %String, ADicAliasCol As %String, ADicCodeCol As %String, ADicDescCol As %String, ASessionId As %String, AHasGB As %String, AIsKeepMinus As %String, ASessionArray As %ArrayOfDataTypes = "") As %Integer
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
		if $zcvt(ADicCodeCol,"U")="MRCID_ROWID"
		{	
			//诊断字典代码列使用rowid，用在病案首页，方便传rowid给医政组做编目
			s CodeValue = rowid	
		}
		else
		{	s CodeValue=$p($g(^MRC("ID",rowid)),"^",4)	}
		
		//取描述列
		s DescValue=""
		if ($zcvt(ADicDescCol,"U")="MRCID_LONGDESCRIPTION")
		{	s DescValue=$p($g(^MRC("ID",rowid)),"^",36)}		//for 上海华山
		else
		{	s DescValue=$p($g(^MRC("ID",rowid)),"^",2)}
		
		//取代码列附加信息
		//s ICD9Map=" /"_$p($g(^MRC("ID",rowid)),"^",35)  //Comment and updated by Wangwt 2008-06-27
		s ICD9Map=""
		s ICD9MapRowDR=""
		s ICD9MapRowDR=##Class(EMRservice.BL.BLSysOption).GetOptionValueByName("ICDCodeExpand")
		if ICD9MapRowDR="Y"
		{
			s ICD9Map=" /"_$p($g(^MRC("ID",rowid)),"^",35) ;The Fourth Node is Parameter Value	
		}
		s CodeValue=CodeValue_ICD9Map
		
		//取别名列
		s AliasValue=""
		if ((ADicAliasCol '="")&&(ADicAliasCol'=$C(0)))
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
		if (AComItem '= "")
		{	
			s CodeCom= ##Class(EMRservice.Utility).CheckContain($ZCVT(CodeValue,"U"),$ZCVT(AComItem,"U"),AHasGB)
			S DescCom= ##Class(EMRservice.Utility).CheckContain($ZCVT(DescValue,"U"),$ZCVT(AComItem,"U"),AHasGB)
			if ((ADicAliasCol '="")&&(ADicAliasCol'=$C(0)))
			{	s AliasCom= ##Class(EMRservice.Utility).CheckContain($ZCVT(AliasValue,"U"),$ZCVT(AComItem,"U"),AHasGB)}
			
			if ((CodeCom '= 1)&&(DescCom '= 1)&&(AliasCom '= 1))
			{	continue}
		}
		
		//处理满足条件的结果并存入临时global
		s totRowCount = totRowCount + 1
		s AliasValue = $P(AliasValue,$C(2),1)
		if (AIsKeepMinus = "0")
		{	s DescValue = $E(DescValue,$F(DescValue,"-"),$L(DescValue)) }
		
		s:((totRowCount >= AMinCount)&&(totRowCount <= AMaxCount)) ^CacheTempStdQuery(ASessionId,totRowCount) =$LB(rowid,AliasValue,CodeValue,DescValue)
	}
	
	s ^CacheTempStdQuery(ASessionId,"StdQueryDataCount")= totRowCount
	
	q totRowCount
}

/// Create:	2013-06-06	niucaicai
/// Desc:	查询【中医主病】字典内容：SQLUSER.MRC_ICDDXZYZB  只查询中医诊断，并且ICD码是“B”开头的
/// Input：	AComItem 查询条件；ADicAliasCol 别名列；ADicCodeCol 代码列；ADicDescCol 描述列；AHasGB 查询条件是否有中文字符；AIsKeepMinus 描述列是否有横线
ClassMethod SelectStdDicMRCICDDxZYZB(AMinCount As %String, AMaxCount As %String, AComItem As %String, ADicAliasCol As %String, ADicCodeCol As %String, ADicDescCol As %String, ASessionId As %String, AHasGB As %String, AIsKeepMinus As %String, ASessionArray As %ArrayOfDataTypes = "") As %Integer
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
		
		s zyBZFlag = $p($g(^MRC("ID",rowid)),"^",13)
		s zyBZFlag = $zcvt(zyBZFlag,"U")
		//修改验证规则zyBZFlag=N，zyFlag=Y 主病
		//校验ICD码是否为Z开头
		//s isZstartFlag = $e($p($g(^MRC("ID",rowid)),"^",4),1,1)
		//s isZstartFlag = $zcvt(isZstartFlag,"U")
		//continue:($e(zyFlag,1,1)'="Y")||(isZstartFlag'="Z")
		continue:($e(zyFlag,1,1)'="Y")||(zyBZFlag'="N")
		
		
		
		//取代码列
		if $zcvt(ADicCodeCol,"U")="MRCID_ROWID"
		{	
			//诊断字典代码列使用rowid，用在病案首页，方便传rowid给医政组做编目
			s CodeValue = rowid	
		}
		else
		{	s CodeValue=$p($g(^MRC("ID",rowid)),"^",4)	}
		
		//取描述列
		s DescValue=""
		if ($zcvt(ADicDescCol,"U")="MRCID_LONGDESCRIPTION")
		{	s DescValue=$p($g(^MRC("ID",rowid)),"^",36)}		//for 上海华山
		else
		{	s DescValue=$p($g(^MRC("ID",rowid)),"^",2)}
		
		//取代码列附加信息
		//s ICD9Map=" /"_$p($g(^MRC("ID",rowid)),"^",35)  //Comment and updated by Wangwt 2008-06-27
		s ICD9Map=""
		s ICD9MapRowDR=""
		s ICD9MapRowDR=##Class(EMRservice.BL.BLSysOption).GetOptionValueByName("ICDCodeExpand")
		if ICD9MapRowDR="Y"
		{
			s ICD9Map=" /"_$p($g(^MRC("ID",rowid)),"^",35) ;The Fourth Node is Parameter Value	
		}
		s CodeValue=CodeValue_ICD9Map
		
		//取别名列
		s AliasValue=""
		if ((ADicAliasCol '="")&&(ADicAliasCol'=$C(0)))
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
		if (AComItem '= "")
		{	
			s CodeCom= ##Class(EMRservice.Utility).CheckContain($ZCVT(CodeValue,"U"),$ZCVT(AComItem,"U"),AHasGB)
			S DescCom= ##Class(EMRservice.Utility).CheckContain($ZCVT(DescValue,"U"),$ZCVT(AComItem,"U"),AHasGB)
			if ((ADicAliasCol '="")&&(ADicAliasCol'=$C(0)))
			{	s AliasCom= ##Class(EMRservice.Utility).CheckContain($ZCVT(AliasValue,"U"),$ZCVT(AComItem,"U"),AHasGB)}
			
			if ((CodeCom '= 1)&&(DescCom '= 1)&&(AliasCom '= 1))
			{	continue}
		}
		
		//处理满足条件的结果并存入临时global
		s totRowCount = totRowCount + 1
		s AliasValue = $P(AliasValue,$C(2),1)
		if (AIsKeepMinus = "0")
		{	s DescValue = $E(DescValue,$F(DescValue,"-"),$L(DescValue)) }
		
		s:((totRowCount >= AMinCount)&&(totRowCount <= AMaxCount)) ^CacheTempStdQuery(ASessionId,totRowCount) =$LB(rowid,AliasValue,CodeValue,DescValue)
	}
	
	s ^CacheTempStdQuery(ASessionId,"StdQueryDataCount")= totRowCount
	
	q totRowCount
}

/// Create:	2013-06-06	niucaicai
/// Desc:	查询【中医主证】字典内容：SQLUSER.MRC_ICDDXZYZZ 只查询中医诊断，并且ICD码是“Z”开头的
/// Input：	AComItem 查询条件；ADicAliasCol 别名列；ADicCodeCol 代码列；ADicDescCol 描述列；AHasGB 查询条件是否有中文字符；AIsKeepMinus 描述列是否有横线
ClassMethod SelectStdDicMRCICDDxZYZZ(AMinCount As %String, AMaxCount As %String, AComItem As %String, ADicAliasCol As %String, ADicCodeCol As %String, ADicDescCol As %String, ASessionId As %String, AHasGB As %String, AIsKeepMinus As %String, ASessionArray As %ArrayOfDataTypes = "") As %Integer
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
		
		s zyBZFlag = $p($g(^MRC("ID",rowid)),"^",13)
		s zyBZFlag = $zcvt(zyBZFlag,"U")
		
		//修改验证规则zyBZFlag=Y，zyFlag=Y 主症
		//校验ICD码是否为Z开头
		//s isZstartFlag = $e($p($g(^MRC("ID",rowid)),"^",4),1,1)
		//s isZstartFlag = $zcvt(isZstartFlag,"U")
		//continue:($e(zyFlag,1,1)'="Y")||(isZstartFlag'="Z")
		continue:($e(zyFlag,1,1)'="Y")||(zyBZFlag'="Y")
		//取代码列
		if $zcvt(ADicCodeCol,"U")="MRCID_ROWID"
		{	
			//诊断字典代码列使用rowid，用在病案首页，方便传rowid给医政组做编目
			s CodeValue = rowid	
		}
		else
		{	s CodeValue=$p($g(^MRC("ID",rowid)),"^",4)	}
		
		//取描述列
		s DescValue=""
		if ($zcvt(ADicDescCol,"U")="MRCID_LONGDESCRIPTION")
		{	s DescValue=$p($g(^MRC("ID",rowid)),"^",36)}		//for 上海华山
		else
		{	s DescValue=$p($g(^MRC("ID",rowid)),"^",2)}
		
		//取代码列附加信息
		//s ICD9Map=" /"_$p($g(^MRC("ID",rowid)),"^",35)  //Comment and updated by Wangwt 2008-06-27
		s ICD9Map=""
		s ICD9MapRowDR=""
		s ICD9MapRowDR=##Class(EMRservice.BL.BLSysOption).GetOptionValueByName("ICDCodeExpand")
		if ICD9MapRowDR="Y"
		{
			s ICD9Map=" /"_$p($g(^MRC("ID",rowid)),"^",35) ;The Fourth Node is Parameter Value	
		}
		s CodeValue=CodeValue_ICD9Map
		
		//取别名列
		s AliasValue=""
		if ((ADicAliasCol '="")&&(ADicAliasCol'=$C(0)))
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
		if (AComItem '= "")
		{	
			s CodeCom= ##Class(EMRservice.Utility).CheckContain($ZCVT(CodeValue,"U"),$ZCVT(AComItem,"U"),AHasGB)
			S DescCom= ##Class(EMRservice.Utility).CheckContain($ZCVT(DescValue,"U"),$ZCVT(AComItem,"U"),AHasGB)
			if ((ADicAliasCol '="")&&(ADicAliasCol'=$C(0)))
			{	s AliasCom= ##Class(EMRservice.Utility).CheckContain($ZCVT(AliasValue,"U"),$ZCVT(AComItem,"U"),AHasGB)}
			
			if ((CodeCom '= 1)&&(DescCom '= 1)&&(AliasCom '= 1))
			{	continue}
		}
		
		//处理满足条件的结果并存入临时global
		s totRowCount = totRowCount + 1
		s AliasValue = $P(AliasValue,$C(2),1)
		if (AIsKeepMinus = "0")
		{	s DescValue = $E(DescValue,$F(DescValue,"-"),$L(DescValue)) }
		
		s:((totRowCount >= AMinCount)&&(totRowCount <= AMaxCount)) ^CacheTempStdQuery(ASessionId,totRowCount) =$LB(rowid,AliasValue,CodeValue,DescValue)
	}
	
	s ^CacheTempStdQuery(ASessionId,"StdQueryDataCount")= totRowCount
	
	q totRowCount
}

/// Create:	2008-11-27	HouJ
/// Desc:	查询【科室】字典内容：SQLUser.CT_Loc
/// Input：	AComItem 查询条件；ADicAliasCol 别名列；ADicCodeCol 代码列；ADicDescCol 描述列；ADescHasMinius 描述列是否有横线
ClassMethod SelectStdDicCTLoc(AMinCount As %String, AMaxCount As %String, AComItem As %String, ADicAliasCol As %String, ADicCodeCol As %String, ADicDescCol As %String, ASessionId As %String, AHasGB As %String, AIsKeepMinus As %String, ASessionArray As %ArrayOfDataTypes = "") As %Integer
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
		if ($zcvt(ADicCodeCol,"U") = "CTLOC_CODE")
		{	s CodeValue=$p($g(^CTLOC(rowid)),"^",1)}
		elseif ($zcvt(ADicCodeCol,"U") = "CTLOC_ROWID")
		{	s CodeValue=rowid}
		
		s DescValue=$p($g(^CTLOC(rowid)),"^",2)
		
		s AliasValue=""
		if ($zcvt(ADicAliasCol,"U") = "CTLOC_CONTACTNAME")
		{	s AliasValue = $p($g(^CTLOC(rowid)),"^",43)}
		
		//是否满足查询条件
		s CodeCom=0, DescCom=0, AliasCom=0
		if (AComItem '= "")
		{	
			
			s CodeCom= ##Class(EMRservice.Utility).CheckContain($ZCVT(CodeValue,"U"),$ZCVT(AComItem,"U"),AHasGB)
			S DescCom= ##Class(EMRservice.Utility).CheckContain($ZCVT(DescValue,"U"),$ZCVT(AComItem,"U"),AHasGB)
			if ((ADicAliasCol '="")&&(ADicAliasCol'=$C(0)))
			{	s AliasCom= ##Class(EMRservice.Utility).CheckContain($ZCVT(AliasValue,"U"),$ZCVT(AComItem,"U"),AHasGB)}
			
			if ((CodeCom '= 1)&&(DescCom '= 1)&&(AliasCom '= 1))
			{	continue}
		}
		
		//处理满足条件的结果并存入临时global
		s totRowCount = totRowCount + 1
		if (AIsKeepMinus = "0")
		{	s DescValue = $E(DescValue,$F(DescValue,"-"),$L(DescValue)) }
		s:((totRowCount >= AMinCount)&&(totRowCount <= AMaxCount)) ^CacheTempStdQuery(ASessionId,totRowCount) =$LB(rowid,AliasValue,CodeValue,DescValue)
	}
	
	s ^CacheTempStdQuery(ASessionId,"StdQueryDataCount")= totRowCount
	
	q totRowCount
}

/// Create:	2008-11-27	HouJ
/// Desc:	查询【民族】字典内容：SQLUser.CT_Nation
/// Input：	AComItem 查询条件；ADicAliasCol 别名列；ADicCodeCol 代码列；ADicDescCol 描述列；ADescHasMinius 描述列是否有横线
ClassMethod SelectStdDicCTNation(AMinCount As %String, AMaxCount As %String, AComItem As %String, ADicAliasCol As %String, ADicCodeCol As %String, ADicDescCol As %String, ASessionId As %String, AHasGB As %String, AIsKeepMinus As %String, ASessionArray As %ArrayOfDataTypes = "") As %Integer
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
		if (AComItem '= "")
		{	
			
			s CodeCom= ##Class(EMRservice.Utility).CheckContain($ZCVT(CodeValue,"U"),$ZCVT(AComItem,"U"),AHasGB)
			S DescCom= ##Class(EMRservice.Utility).CheckContain($ZCVT(DescValue,"U"),$ZCVT(AComItem,"U"),AHasGB)
			if ((ADicAliasCol '="")&&(ADicAliasCol'=$C(0)))
			{	s AliasCom= ##Class(EMRservice.Utility).CheckContain($ZCVT(AliasValue,"U"),$ZCVT(AComItem,"U"),AHasGB)}
			
			if ((CodeCom '= 1)&&(DescCom '= 1)&&(AliasCom '= 1))
			{	continue}
		}
		
		//处理满足条件的结果并存入临时global
		s totRowCount = totRowCount + 1
		if (AIsKeepMinus = "0")
		{	s DescValue = $E(DescValue,$F(DescValue,"-"),$L(DescValue)) }
		s:((totRowCount >= AMinCount)&&(totRowCount <= AMaxCount)) ^CacheTempStdQuery(ASessionId,totRowCount) =$LB(rowid,AliasValue,CodeValue,DescValue)
	}
	
	s ^CacheTempStdQuery(ASessionId,"StdQueryDataCount")= totRowCount
	
	q totRowCount
}

/// Create:	2008-11-27	HouJ
/// Desc:	查询【用户】字典内容：SQLUser.SS_User
/// Input：	AComItem 查询条件；ADicAliasCol 别名列；ADicCodeCol 代码列；ADicDescCol 描述列；ADescHasMinius 描述列是否有横线
ClassMethod SelectStdDicSSUser(AMinCount As %String, AMaxCount As %String, AComItem As %String, ADicAliasCol As %String, ADicCodeCol As %String, ADicDescCol As %String, ASessionId As %String, AHasGB As %String, AIsKeepMinus As %String, ASessionArray As %ArrayOfDataTypes = "") As %Integer
{
	//结果行总数
	s totRowCount = 0
	
	//开始查询
	s rowid = 0
	for {
		s rowid=$o(^SSU("SSUSR",rowid))
		quit:(rowid = "")
		
		//取代码列,描述列,别名列
		if ($zcvt(ADicCodeCol,"U") = "SSUSR_INITIALS")
		{s CodeValue=$p($g(^SSU("SSUSR",rowid)),"^",1)}
		s DescValue=$p($g(^SSU("SSUSR",rowid)),"^",2)
		s AliasValue=$p($g(^SSU("SSUSR",rowid)),"^",11)
		
		//是否满足查询条件
		s CodeCom=0, DescCom=0, AliasCom=0
		if (AComItem '= "")
		{	
			
			s CodeCom= ##Class(EMRservice.Utility).CheckContain($ZCVT(CodeValue,"U"),$ZCVT(AComItem,"U"),AHasGB)
			S DescCom= ##Class(EMRservice.Utility).CheckContain($ZCVT(DescValue,"U"),$ZCVT(AComItem,"U"),AHasGB)
			if ((ADicAliasCol '="")&&(ADicAliasCol'=$C(0)))
			{	s AliasCom= ##Class(EMRservice.Utility).CheckContain($ZCVT(AliasValue,"U"),$ZCVT(AComItem,"U"),AHasGB)}
			
			if ((CodeCom '= 1)&&(DescCom '= 1)&&(AliasCom '= 1))
			{	continue}
		}
		
		//处理满足条件的结果并存入临时global
		s totRowCount = totRowCount + 1
		if (AIsKeepMinus = "0")
		{	s DescValue = $E(DescValue,$F(DescValue,"-"),$L(DescValue)) }
		s:((totRowCount >= AMinCount)&&(totRowCount <= AMaxCount)) ^CacheTempStdQuery(ASessionId,totRowCount) =$LB(rowid,AliasValue,CodeValue,DescValue)
	}
	
	s ^CacheTempStdQuery(ASessionId,"StdQueryDataCount")= totRowCount
	
	q totRowCount
}

/// Create:	2008-11-27	HouJ
/// Desc:	查询【病室】字典内容：SQLUser.PAC_Ward
/// Input：	AComItem 查询条件；ADicAliasCol 别名列；ADicCodeCol 代码列；ADicDescCol 描述列；ADescHasMinius 描述列是否有横线
ClassMethod SelectStdDicPACWard(AMinCount As %String, AMaxCount As %String, AComItem As %String, ADicAliasCol As %String, ADicCodeCol As %String, ADicDescCol As %String, ASessionId As %String, AHasGB As %String, AIsKeepMinus As %String, ASessionArray As %ArrayOfDataTypes = "") As %Integer
{
	//结果行总数
	s totRowCount = 0
	
	//开始查询
	s rowid = 0
	for {
		s rowid=$o(^PAWARD(rowid))
		quit:(rowid = "")
		
		//取代码列,描述列,别名列
		if ($zcvt(ADicCodeCol,"U") = "WARD_CODE")
		{	s CodeValue=$p($g(^PAWARD(rowid)),"^",1)}
		elseif ($zcvt(ADicCodeCol,"U") = "WARD_ROWID")
		{	s CodeValue = rowid }
		s DescValue=$p($g(^PAWARD(rowid)),"^",2)
		//病区描述 把描述列转换为简拼
		s AliasValue=##class(web.DHCINSUPort).GetCNCODE(DescValue,4,"")
		
		//是否满足查询条件
		s CodeCom=0, DescCom=0, AliasCom=0
		if (AComItem '= "")
		{	
			
			s CodeCom= ##Class(EMRservice.Utility).CheckContain($ZCVT(CodeValue,"U"),$ZCVT(AComItem,"U"),AHasGB)
			S DescCom= ##Class(EMRservice.Utility).CheckContain($ZCVT(DescValue,"U"),$ZCVT(AComItem,"U"),AHasGB)
			// 去掉原先判定 直接匹配查询条件
			s AliasCom= ##Class(EMRservice.Utility).CheckContain($ZCVT(AliasValue,"U"),$ZCVT(AComItem,"U"),AHasGB)
			
			if ((CodeCom '= 1)&&(DescCom '= 1)&&(AliasCom '= 1))
			{	continue}
		}
		
		//处理满足条件的结果并存入临时global
		s totRowCount = totRowCount + 1
		if (AIsKeepMinus = "0")
		{	s DescValue = $E(DescValue,$F(DescValue,"-"),$L(DescValue)) }
		s:((totRowCount >= AMinCount)&&(totRowCount <= AMaxCount)) ^CacheTempStdQuery(ASessionId,totRowCount) =$LB(rowid,AliasValue,CodeValue,DescValue)
	}
	
	s ^CacheTempStdQuery(ASessionId,"StdQueryDataCount")= totRowCount
	
	q totRowCount
}

/// Create:	2008-11-27	HouJ
/// Desc:	查询【药学项】字典内容：SQLUser.PHC_DrgMast
/// Input：	AComItem 查询条件；ADicAliasCol 别名列；ADicCodeCol 代码列；ADicDescCol 描述列；ADescHasMinius 描述列是否有横线
ClassMethod SelectStdDicPHCDrgMast(AMinCount As %String, AMaxCount As %String, AComItem As %String, ADicAliasCol As %String, ADicCodeCol As %String, ADicDescCol As %String, ASessionId As %String, AHasGB As %String, AIsKeepMinus As %String, ASessionArray As %ArrayOfDataTypes = "") As %Integer
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
		if ((ADicAliasCol '="")&&(ADicAliasCol '=$C(0))&&(CodeValue '=""))
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
		if (AComItem '= "")
		{	
			s CodeCom= ##Class(EMRservice.Utility).CheckContain($ZCVT(CodeValue,"U"),$ZCVT(AComItem,"U"),AHasGB)
			S DescCom= ##Class(EMRservice.Utility).CheckContain($ZCVT(DescValue,"U"),$ZCVT(AComItem,"U"),AHasGB)
			if ((ADicAliasCol '="")&&(ADicAliasCol'=$C(0)))
			{	s AliasCom= ##Class(EMRservice.Utility).CheckContain($ZCVT(AliasValue,"U"),$ZCVT(AComItem,"U"),AHasGB)}
			
			if ((CodeCom '= 1)&&(DescCom '= 1)&&(AliasCom '= 1))
			{	continue}
		}
		
		//处理满足条件的结果并存入临时global
		s totRowCount = totRowCount + 1
		s AliasValue = $P(AliasValue,$C(2),1)
		if (AIsKeepMinus = "0")
		{	s DescValue = $E(DescValue,$F(DescValue,"-"),$L(DescValue)) }
		s:((totRowCount >= AMinCount)&&(totRowCount <= AMaxCount)) ^CacheTempStdQuery(ASessionId,totRowCount) =$LB(rowid,AliasValue,CodeValue,DescValue)
	}
	
	s ^CacheTempStdQuery(ASessionId,"StdQueryDataCount")= totRowCount
	
	q totRowCount
}

/// Create:	2008-11-27	HouJ
/// Desc:	查询【职业】字典内容：SQLUser.CT_Occupation
/// Input：	AComItem 查询条件；ADicAliasCol 别名列；ADicCodeCol 代码列；ADicDescCol 描述列；ADescHasMinius 描述列是否有横线
ClassMethod SelectStdDicCTOccupation(AMinCount As %String, AMaxCount As %String, AComItem As %String, ADicAliasCol As %String, ADicCodeCol As %String, ADicDescCol As %String, ASessionId As %String, AHasGB As %String, AIsKeepMinus As %String, ASessionArray As %ArrayOfDataTypes = "") As %Integer
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
		if (AComItem '= "")
		{	
			
			s CodeCom= ##Class(EMRservice.Utility).CheckContain($ZCVT(CodeValue,"U"),$ZCVT(AComItem,"U"),AHasGB)
			S DescCom= ##Class(EMRservice.Utility).CheckContain($ZCVT(DescValue,"U"),$ZCVT(AComItem,"U"),AHasGB)
			if ((ADicAliasCol '="")&&(ADicAliasCol'=$C(0)))
			{	s AliasCom= ##Class(EMRservice.Utility).CheckContain($ZCVT(AliasValue,"U"),$ZCVT(AComItem,"U"),AHasGB)}
			
			if ((CodeCom '= 1)&&(DescCom '= 1)&&(AliasCom '= 1))
			{	continue}
		}
		
		//处理满足条件的结果并存入临时global
		s totRowCount = totRowCount + 1
		if (AIsKeepMinus = "0")
		{	s DescValue = $E(DescValue,$F(DescValue,"-"),$L(DescValue)) }
		s:((totRowCount >= AMinCount)&&(totRowCount <= AMaxCount)) ^CacheTempStdQuery(ASessionId,totRowCount) =$LB(rowid,AliasValue,CodeValue,DescValue)
	}
	
	s ^CacheTempStdQuery(ASessionId,"StdQueryDataCount")= totRowCount
	
	q totRowCount
}

/// Create:	2008-11-27	HouJ
/// Desc:	查询【国籍】字典内容：SQLUser.CT_Country
/// Input：	AComItem 查询条件；ADicAliasCol 别名列；ADicCodeCol 代码列；ADicDescCol 描述列；ADescHasMinius 描述列是否有横线
/// Debug:  w ##Class(EMRservice.BL.BLStdDictionary).SelectStdDicCTCountry("","","","","11","","")
ClassMethod SelectStdDicCTCountry(AMinCount As %String, AMaxCount As %String, AComItem As %String, ADicAliasCol As %String, ADicCodeCol As %String, ADicDescCol As %String, ASessionId As %String, AHasGB As %String, AIsKeepMinus As %String, ASessionArray As %ArrayOfDataTypes = "") As %Integer
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
		if ((ADicAliasCol '="")&&(ADicAliasCol'=$C(0)))
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
		if (AComItem '= "")
		{	
			
			s CodeCom= ##Class(EMRservice.Utility).CheckContain($ZCVT(CodeValue,"U"),$ZCVT(AComItem,"U"),AHasGB)
			S DescCom= ##Class(EMRservice.Utility).CheckContain($ZCVT(DescValue,"U"),$ZCVT(AComItem,"U"),AHasGB)
			if ((ADicAliasCol '="")&&(ADicAliasCol'=$C(0)))
			{	s AliasCom= ##Class(EMRservice.Utility).CheckContain($ZCVT(AliasValue,"U"),$ZCVT(AComItem,"U"),AHasGB)}
			
			if ((CodeCom '= 1)&&(DescCom '= 1)&&(AliasCom '= 1))
			{	continue}
		}
		
		//处理满足条件的结果并存入临时global
		s totRowCount = totRowCount + 1
		if (AIsKeepMinus = "0")
		{	s DescValue = $E(DescValue,$F(DescValue,"-"),$L(DescValue)) }
		s:((totRowCount >= AMinCount)&&(totRowCount <= AMaxCount)) ^CacheTempStdQuery(ASessionId,totRowCount) =$LB(rowid,AliasValue,CodeValue,DescValue)
	}
	
	s ^CacheTempStdQuery(ASessionId,"StdQueryDataCount")= totRowCount
	
	q totRowCount
}

/// Create:	2008-11-27	HouJ
/// Desc:	查询【省市】字典内容：SQLUser.CT_Province
/// Input：	AComItem 查询条件；ADicAliasCol 别名列；ADicCodeCol 代码列；ADicDescCol 描述列；ADescHasMinius 描述列是否有横线
ClassMethod SelectStdDicCTProvince(AMinCount As %String, AMaxCount As %String, AComItem As %String, ADicAliasCol As %String, ADicCodeCol As %String, ADicDescCol As %String, ASessionId As %String, AHasGB As %String, AIsKeepMinus As %String, ASessionArray As %ArrayOfDataTypes = "") As %Integer
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
		if ((ADicAliasCol '="")&&(ADicAliasCol'=$C(0)))
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
		if (AComItem '= "")
		{	
			
			s CodeCom= ##Class(EMRservice.Utility).CheckContain($ZCVT(CodeValue,"U"),$ZCVT(AComItem,"U"),AHasGB)
			S DescCom= ##Class(EMRservice.Utility).CheckContain($ZCVT(DescValue,"U"),$ZCVT(AComItem,"U"),AHasGB)
			if ((ADicAliasCol '="")&&(ADicAliasCol'=$C(0)))
			{	s AliasCom= ##Class(EMRservice.Utility).CheckContain($ZCVT(AliasValue,"U"),$ZCVT(AComItem,"U"),AHasGB)}
			
			if ((CodeCom '= 1)&&(DescCom '= 1)&&(AliasCom '= 1))
			{	continue}
		}
		
		//处理满足条件的结果并存入临时global
		s totRowCount = totRowCount + 1
		if (AIsKeepMinus = "0")
		{	s DescValue = $E(DescValue,$F(DescValue,"-"),$L(DescValue)) }
		s:((totRowCount >= AMinCount)&&(totRowCount <= AMaxCount)) ^CacheTempStdQuery(ASessionId,totRowCount) =$LB(rowid,AliasValue,CodeValue,DescValue)
	}
	
	s ^CacheTempStdQuery(ASessionId,"StdQueryDataCount")= totRowCount
	
	q totRowCount
}

/// Create:	2008-11-27	HouJ
/// Desc:	查询【省市】字典内容：SQLUser.CT_City
/// Input：	AComItem 查询条件；ADicAliasCol 别名列；ADicCodeCol 代码列；ADicDescCol 描述列；ADescHasMinius 描述列是否有横线
ClassMethod SelectStdDicCTCity(AMinCount As %String, AMaxCount As %String, AComItem As %String, ADicAliasCol As %String, ADicCodeCol As %String, ADicDescCol As %String, ASessionId As %String, AHasGB As %String, AIsKeepMinus As %String, ASessionArray As %ArrayOfDataTypes = "") As %Integer
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
		if ((ADicAliasCol '="")&&(ADicAliasCol'=$C(0)))
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
		if (AComItem '= "")
		{	
			
			s CodeCom= ##Class(EMRservice.Utility).CheckContain($ZCVT(CodeValue,"U"),$ZCVT(AComItem,"U"),AHasGB)
			S DescCom= ##Class(EMRservice.Utility).CheckContain($ZCVT(DescValue,"U"),$ZCVT(AComItem,"U"),AHasGB)
			if ((ADicAliasCol '="")&&(ADicAliasCol'=$C(0)))
			{	s AliasCom= ##Class(EMRservice.Utility).CheckContain($ZCVT(AliasValue,"U"),$ZCVT(AComItem,"U"),AHasGB)}
			
			if ((CodeCom '= 1)&&(DescCom '= 1)&&(AliasCom '= 1))
			{	continue}
		}
		
		//处理满足条件的结果并存入临时global
		s totRowCount = totRowCount + 1
		if (AIsKeepMinus = "0")
		{	s DescValue = $E(DescValue,$F(DescValue,"-"),$L(DescValue)) }
		s:((totRowCount >= AMinCount)&&(totRowCount <= AMaxCount)) ^CacheTempStdQuery(ASessionId,totRowCount) =$LB(rowid,AliasValue,CodeValue,DescValue)
	}
	
	s ^CacheTempStdQuery(ASessionId,"StdQueryDataCount")= totRowCount
	
	q totRowCount
}

/// Create:	2008-11-27	HouJ
/// Desc:	查询【性别】字典内容：SQLUser.CT_Sex
/// Input：	AComItem 查询条件；ADicAliasCol 别名列；ADicCodeCol 代码列；ADicDescCol 描述列；ADescHasMinius 描述列是否有横线
ClassMethod SelectStdDicCTSex(AMinCount As %String, AMaxCount As %String, AComItem As %String, ADicAliasCol As %String, ADicCodeCol As %String, ADicDescCol As %String, ASessionId As %String, AHasGB As %String, AIsKeepMinus As %String, ASessionArray As %ArrayOfDataTypes = "") As %Integer
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
		if (AComItem '= "")
		{	
			
			s CodeCom= ##Class(EMRservice.Utility).CheckContain($ZCVT(CodeValue,"U"),$ZCVT(AComItem,"U"),AHasGB)
			S DescCom= ##Class(EMRservice.Utility).CheckContain($ZCVT(DescValue,"U"),$ZCVT(AComItem,"U"),AHasGB)
			if ((ADicAliasCol '="")&&(ADicAliasCol'=$C(0)))
			{	s AliasCom= ##Class(EMRservice.Utility).CheckContain($ZCVT(AliasValue,"U"),$ZCVT(AComItem,"U"),AHasGB)}
			
			if ((CodeCom '= 1)&&(DescCom '= 1)&&(AliasCom '= 1))
			{	continue}
		}
		
		//处理满足条件的结果并存入临时global
		s totRowCount = totRowCount + 1
		if (AIsKeepMinus = "0")
		{	s DescValue = $E(DescValue,$F(DescValue,"-"),$L(DescValue)) }
		s:((totRowCount >= AMinCount)&&(totRowCount <= AMaxCount)) ^CacheTempStdQuery(ASessionId,totRowCount) =$LB(rowid,AliasValue,CodeValue,DescValue)
	}
	
	s ^CacheTempStdQuery(ASessionId,"StdQueryDataCount")= totRowCount
	
	q totRowCount
}

/// Create:	2008-11-27	HouJ
/// Desc:	查询【病人类别】字典内容：SQLUser.PAC_PatientCategory
/// Input：	AComItem 查询条件；ADicAliasCol 别名列；ADicCodeCol 代码列；ADicDescCol 描述列；ADescHasMinius 描述列是否有横线
ClassMethod SelectStdDicPACPatientCategory(AMinCount As %String, AMaxCount As %String, AComItem As %String, ADicAliasCol As %String, ADicCodeCol As %String, ADicDescCol As %String, ASessionId As %String, AHasGB As %String, AIsKeepMinus As %String, ASessionArray As %ArrayOfDataTypes = "") As %Integer
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
		if (AComItem '= "")
		{	
			
			s CodeCom= ##Class(EMRservice.Utility).CheckContain($ZCVT(CodeValue,"U"),$ZCVT(AComItem,"U"),AHasGB)
			S DescCom= ##Class(EMRservice.Utility).CheckContain($ZCVT(DescValue,"U"),$ZCVT(AComItem,"U"),AHasGB)
			if ((ADicAliasCol '="")&&(ADicAliasCol'=$C(0)))
			{	s AliasCom= ##Class(EMRservice.Utility).CheckContain($ZCVT(AliasValue,"U"),$ZCVT(AComItem,"U"),AHasGB)}
			
			if ((CodeCom '= 1)&&(DescCom '= 1)&&(AliasCom '= 1))
			{	continue}
		}
		
		//处理满足条件的结果并存入临时global
		s totRowCount = totRowCount + 1
		if (AIsKeepMinus = "0")
		{	s DescValue = $E(DescValue,$F(DescValue,"-"),$L(DescValue)) }
		s:((totRowCount >= AMinCount)&&(totRowCount <= AMaxCount)) ^CacheTempStdQuery(ASessionId,totRowCount) =$LB(rowid,AliasValue,CodeValue,DescValue)
	}
	
	s ^CacheTempStdQuery(ASessionId,"StdQueryDataCount")= totRowCount
	
	q totRowCount
}

/// Create:	2008-11-27	HouJ
/// Desc:	查询【邮编】字典内容：SQLUser.CT_Zip	CTZIP_Code CTZIP_Desc 
/// Input：	AComItem 查询条件；ADicAliasCol 别名列；ADicCodeCol 代码列；ADicDescCol 描述列；ADescHasMinius 描述列是否有横线
ClassMethod SelectStdDicCTZip(AMinCount As %String, AMaxCount As %String, AComItem As %String, ADicAliasCol As %String, ADicCodeCol As %String, ADicDescCol As %String, ASessionId As %String, AHasGB As %String, AIsKeepMinus As %String, ASessionArray As %ArrayOfDataTypes = "") As %Integer
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
		if (AComItem '= "")
		{	
			
			s CodeCom= ##Class(EMRservice.Utility).CheckContain($ZCVT(CodeValue,"U"),$ZCVT(AComItem,"U"),AHasGB)
			S DescCom= ##Class(EMRservice.Utility).CheckContain($ZCVT(DescValue,"U"),$ZCVT(AComItem,"U"),AHasGB)
			if ((ADicAliasCol '="")&&(ADicAliasCol'=$C(0)))
			{	s AliasCom= ##Class(EMRservice.Utility).CheckContain($ZCVT(AliasValue,"U"),$ZCVT(AComItem,"U"),AHasGB)}
			
			if ((CodeCom '= 1)&&(DescCom '= 1)&&(AliasCom '= 1))
			{	continue}
		}
		
		//处理满足条件的结果并存入临时global
		s totRowCount = totRowCount + 1
		if (AIsKeepMinus = "0")
		{	s DescValue = $E(DescValue,$F(DescValue,"-"),$L(DescValue)) }
		s:((totRowCount >= AMinCount)&&(totRowCount <= AMaxCount)) ^CacheTempStdQuery(ASessionId,totRowCount) =$LB(rowid,AliasValue,CodeValue,DescValue)
	}
	
	s ^CacheTempStdQuery(ASessionId,"StdQueryDataCount")= totRowCount
	
	q totRowCount
}

/// Create:	2008-11-27	HouJ
/// Desc:	查询【手术】字典内容：SQLUser.ORC_Operation, SQLUser.ORC_OperationAlias
/// Input：	AComItem 查询条件；ADicAliasCol 别名列；ADicCodeCol 代码列；ADicDescCol 描述列；AHasGB 查询条件是否有中文字符；AIsKeepMinus 描述列是否有横线
ClassMethod SelectStdDicORCOperation(AMinCount As %String, AMaxCount As %String, AComItem As %String, ADicAliasCol As %String, ADicCodeCol As %String, ADicDescCol As %String, ASessionId As %String, AHasGB As %String, AIsKeepMinus As %String, ASessionArray As %ArrayOfDataTypes = "") As %Integer
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
		if ($zcvt(ADicCodeCol,"U") = "OPER_CODE")
		{	s CodeValue = $p($g(^ORC("OPER",rowid)),"^",1)}
		elseif ($zcvt(ADicCodeCol,"U") = "OPER_ICD10")
		{	s CodeValue =  $p($g(^ORC("OPER",rowid)),"^",14)}
		elseif ($zcvt(ADicCodeCol,"U") = "OPER_ROWID")
		{	S CodeValue = rowid}
		s DescValue=$p($g(^ORC("OPER",rowid)),"^",2)
		
		//取别名列
		s AliasValue=""
		if ((ADicAliasCol '="")&&(ADicAliasCol'=$C(0)))
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
		if (AComItem '= "")
		{	
			s CodeCom= ##Class(EMRservice.Utility).CheckContain($ZCVT(CodeValue,"U"),$ZCVT(AComItem,"U"),AHasGB)
			S DescCom= ##Class(EMRservice.Utility).CheckContain($ZCVT(DescValue,"U"),$ZCVT(AComItem,"U"),AHasGB)
			if ((ADicAliasCol '="")&&(ADicAliasCol'=$C(0)))
			{	s AliasCom= ##Class(EMRservice.Utility).CheckContain($ZCVT(AliasValue,"U"),$ZCVT(AComItem,"U"),AHasGB)}
			
			if ((CodeCom '= 1)&&(DescCom '= 1)&&(AliasCom '= 1))
			{	continue}
		}
		
		//处理满足条件的结果并存入临时global
		s totRowCount = totRowCount + 1
		s AliasValue = $P(AliasValue,$C(2),1)
		if (AIsKeepMinus = "0")
		{	s DescValue = $E(DescValue,$F(DescValue,"-"),$L(DescValue)) }
		
		s:((totRowCount >= AMinCount)&&(totRowCount <= AMaxCount)) ^CacheTempStdQuery(ASessionId,totRowCount) =$LB(rowid,AliasValue,CodeValue,DescValue)
	}
	
	s ^CacheTempStdQuery(ASessionId,"StdQueryDataCount")= totRowCount
	
	q totRowCount
}

/// Create:	2008-11-27	HouJ
/// Desc:	查询【联系人关系】字典内容：SQLUser.CT_Relation 
/// Input：	AComItem 查询条件；ADicAliasCol 别名列；ADicCodeCol 代码列；ADicDescCol 描述列；ADescHasMinius 描述列是否有横线
ClassMethod SelectStdDicCTReleation(AMinCount As %String, AMaxCount As %String, AComItem As %String, ADicAliasCol As %String, ADicCodeCol As %String, ADicDescCol As %String, ASessionId As %String, AHasGB As %String, AIsKeepMinus As %String, ASessionArray As %ArrayOfDataTypes = "") As %Integer
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
		if (((dateFrom'="")&&(currentDate<dateFrom))||((dateTo'="")&&(currentDate>dateTo)))
		{	continue}
		
		//取代码列,描述列,别名列
		s CodeValue=$p($g(^CT("RLT",rowid)),"^",1)
		s DescValue=$p($g(^CT("RLT",rowid)),"^",2)
		s AliasValue=""
		
		//是否满足查询条件
		s CodeCom=0, DescCom=0, AliasCom=0
		if (AComItem '= "")
		{	
			
			s CodeCom= ##Class(EMRservice.Utility).CheckContain($ZCVT(CodeValue,"U"),$ZCVT(AComItem,"U"),AHasGB)
			S DescCom= ##Class(EMRservice.Utility).CheckContain($ZCVT(DescValue,"U"),$ZCVT(AComItem,"U"),AHasGB)
			if ((ADicAliasCol '="")&&(ADicAliasCol'=$C(0)))
			{	s AliasCom= ##Class(EMRservice.Utility).CheckContain($ZCVT(AliasValue,"U"),$ZCVT(AComItem,"U"),AHasGB)}
			
			if ((CodeCom '= 1)&&(DescCom '= 1)&&(AliasCom '= 1))
			{	continue}
		}
		
		//处理满足条件的结果并存入临时global
		s totRowCount = totRowCount + 1
		if (AIsKeepMinus = "0")
		{	s DescValue = $E(DescValue,$F(DescValue,"-"),$L(DescValue)) }
		s:((totRowCount >= AMinCount)&&(totRowCount <= AMaxCount)) ^CacheTempStdQuery(ASessionId,totRowCount) =$LB(rowid,AliasValue,CodeValue,DescValue)
	}
	
	s ^CacheTempStdQuery(ASessionId,"StdQueryDataCount")= totRowCount
	
	q totRowCount
}

/// Create:	2008-11-27	HouJ
/// Desc:	查询【病人类型】字典内容：EMRview.PatType
/// Input：	AComItem 查询条件；ADicAliasCol 别名列；ADicCodeCol 代码列；ADicDescCol 描述列；ADescHasMinius 描述列是否有横线
ClassMethod SelectStdDicDHCEMRVPatType(AMinCount As %String, AMaxCount As %String, AComItem As %String, ADicAliasCol As %String, ADicCodeCol As %String, ADicDescCol As %String, ASessionId As %String, AHasGB As %String, AIsKeepMinus As %String, ASessionArray As %ArrayOfDataTypes = "") As %Integer
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
	.i AComItem '= "" d
	..s CodeCom= ##Class(EMRservice.Utility).CheckContain($ZCVT(CodeValue,"U"),$ZCVT(AComItem,"U"),AHasGB)
	..s DescCom= ##Class(EMRservice.Utility).CheckContain($ZCVT(DescValue,"U"),$ZCVT(AComItem,"U"),AHasGB)
	..i ((ADicAliasCol '="")&&(ADicAliasCol'=$C(0))) s AliasCom= ##Class(EMRservice.Utility).CheckContain($ZCVT(AliasValue,"U"),$ZCVT(AComItem,"U"),AHasGB)
	.i ((CodeCom=1)||(DescCom=1)||(AliasCom=1)) d
	..s totRowCount = totRowCount + 1
	..i (AIsKeepMinus = "0") s DescValue = $E(DescValue,$F(DescValue,"-"),$L(DescValue))
	..s:((totRowCount >= AMinCount)&&(totRowCount <= AMaxCount)) ^CacheTempStdQuery(ASessionId,totRowCount) =$LB(ID,AliasValue,CodeValue,DescValue)
	&sql(CLOSE MyCursor)
	
	s ^CacheTempStdQuery(ASessionId,"StdQueryDataCount")= totRowCount
	
	q totRowCount
}

/// Create:	2011-03-30	Wangwt
/// Desc:	查询【麻醉】字典内容：SQLUser.ORC_AnaestMethod
/// Input：	AComItem 查询条件；ADicAliasCol 别名列；ADicCodeCol 代码列；ADicDescCol 描述列；ADescHasMinius 描述列是否有横线
ClassMethod SelectStdDicORCAnaestMethod(AMinCount As %String, AMaxCount As %String, AComItem As %String, ADicAliasCol As %String, ADicCodeCol As %String, ADicDescCol As %String, ASessionId As %String, AHasGB As %String, AIsKeepMinus As %String, ASessionArray As %ArrayOfDataTypes = "") As %Integer
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
		s AliasValue=##class(web.DHCINSUPort).GetCNCODE(DescValue,4,"")
		
		//是否满足查询条件
		s CodeCom=0, DescCom=0, AliasCom=0
		if (AComItem '= "")
		{	
			
			s CodeCom= ##Class(EMRservice.Utility).CheckContain($ZCVT(CodeValue,"U"),$ZCVT(AComItem,"U"),AHasGB)
			S DescCom= ##Class(EMRservice.Utility).CheckContain($ZCVT(DescValue,"U"),$ZCVT(AComItem,"U"),AHasGB)
			if ((ADicAliasCol '="")&&(ADicAliasCol'=$C(0)))
			{	s AliasCom= ##Class(EMRservice.Utility).CheckContain($ZCVT(AliasValue,"U"),$ZCVT(AComItem,"U"),AHasGB)}
			
			if ((CodeCom '= 1)&&(DescCom '= 1)&&(AliasCom '= 1))
			{	continue}
		}
		
		//处理满足条件的结果并存入临时global
		s totRowCount = totRowCount + 1
		if (AIsKeepMinus = "0")
		{	s DescValue = $E(DescValue,$F(DescValue,"-"),$L(DescValue)) }
		s:((totRowCount >= AMinCount)&&(totRowCount <= AMaxCount)) ^CacheTempStdQuery(ASessionId,totRowCount) =$LB(rowid,AliasValue,CodeValue,DescValue)
	}
	
	s ^CacheTempStdQuery(ASessionId,"StdQueryDataCount")= totRowCount
	
	q totRowCount
}

/// Create:	2011-09-22	Wangwt
/// Desc:	
/// Input：	AComItem 查询条件；ADicAliasCol 别名列；ADicCodeCol 代码列；ADicDescCol 描述列；ADescHasMinius 描述列是否有横线
ClassMethod SelectStdDicEMRviewOperation(AMinCount As %String, AMaxCount As %String, AComItem As %String, ADicAliasCol As %String, ADicCodeCol As %String, ADicDescCol As %String, ASessionId As %String, AHasGB As %String, AIsKeepMinus As %String, ASessionArray As %ArrayOfDataTypes = "") As %Integer
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
		if (AComItem '= "")
		{	
			
			s CodeCom= ##Class(EMRservice.Utility).CheckContain($ZCVT(CodeValue,"U"),$ZCVT(AComItem,"U"),AHasGB)
			S DescCom= ##Class(EMRservice.Utility).CheckContain($ZCVT(DescValue,"U"),$ZCVT(AComItem,"U"),AHasGB)
			if ((ADicAliasCol '="")&&(ADicAliasCol'=$C(0)))
			{	s AliasCom= ##Class(EMRservice.Utility).CheckContain($ZCVT(AliasValue,"U"),$ZCVT(AComItem,"U"),AHasGB)}
			
			if ((CodeCom '= 1)&&(DescCom '= 1)&&(AliasCom '= 1))
			{	continue}
		}
		
		
		//处理满足条件的结果并存入临时global
		s totRowCount = totRowCount + 1
		if (AIsKeepMinus = "0")
		{	s DescValue = $E(DescValue,$F(DescValue,"-"),$L(DescValue)) }
		s:((totRowCount >= AMinCount)&&(totRowCount <= AMaxCount)) ^CacheTempStdQuery(ASessionId,totRowCount) =$LB(rowid,AliasValue,CodeValue,DescValue)
	}
	
	s ^CacheTempStdQuery(ASessionId,"StdQueryDataCount")= totRowCount
	
	q totRowCount
}

/// Create:	2011-09-26	HouJ
/// Desc:	查询【诊断字典：SQLUser.MRC_ICDDx】内容：诊断
/// Input：	AComItem 查询条件；ADicAliasCol 别名列；ADicCodeCol 代码列；ADicDescCol 描述列；AHasGB 查询条件是否有中文字符；AIsKeepMinus 描述列是否有横线
ClassMethod SelectStdDicMRCICDDxDiag(AMinCount As %String, AMaxCount As %String, AComItem As %String, ADicAliasCol As %String, ADicCodeCol As %String, ADicDescCol As %String, ASessionId As %String, AHasGB As %String, AIsKeepMinus As %String, ASessionArray As %ArrayOfDataTypes = "") As %Integer
{
	s groupDR = "1"		//诊断
	s totRowCount = ..GetGroupedMRCICDDx(AMinCount, AMaxCount, AComItem, ADicAliasCol, ADicCodeCol, ADicDescCol, ASessionId, AHasGB, AIsKeepMinus, groupDR)
	q totRowCount
}

/// Create:	2011-09-26	HouJ
/// Desc:	查询【诊断字典：SQLUser.MRC_ICDDx】内容：损伤
/// Input：	AComItem 查询条件；ADicAliasCol 别名列；ADicCodeCol 代码列；ADicDescCol 描述列；AHasGB 查询条件是否有中文字符；AIsKeepMinus 描述列是否有横线
ClassMethod SelectStdDicMRCICDDxInjury(AMinCount As %String, AMaxCount As %String, AComItem As %String, ADicAliasCol As %String, ADicCodeCol As %String, ADicDescCol As %String, ASessionId As %String, AHasGB As %String, AIsKeepMinus As %String, ASessionArray As %ArrayOfDataTypes = "") As %Integer
{
	s groupDR = "4"		//损伤
	s totRowCount = ..GetGroupedMRCICDDx(AMinCount, AMaxCount, AComItem, ADicAliasCol, ADicCodeCol, ADicDescCol, ASessionId, AHasGB, AIsKeepMinus, groupDR)
	q totRowCount
}

/// Create:	2011-09-26	HouJ
/// Desc:	查询【诊断字典：SQLUser.MRC_ICDDx】内容：形态学
/// Input：	AComItem 查询条件；ADicAliasCol 别名列；ADicCodeCol 代码列；ADicDescCol 描述列；AHasGB 查询条件是否有中文字符；AIsKeepMinus 描述列是否有横线
ClassMethod SelectStdDicMRCICDDxMorphology(AMinCount As %String, AMaxCount As %String, AComItem As %String, ADicAliasCol As %String, ADicCodeCol As %String, ADicDescCol As %String, ASessionId As %String, AHasGB As %String, AIsKeepMinus As %String, ASessionArray As %ArrayOfDataTypes = "") As %Integer
{
	s groupDR = "2"		//形态学
	s totRowCount = ..GetGroupedMRCICDDx(AMinCount, AMaxCount, AComItem, ADicAliasCol, ADicCodeCol, ADicDescCol, ASessionId, AHasGB, AIsKeepMinus, groupDR)
	q totRowCount
}

/// Create:	2011-09-26	HouJ
/// Desc:	查询【诊断字典：SQLUser.MRC_ICDDx】内容：手术
/// Input：	AComItem 查询条件；ADicAliasCol 别名列；ADicCodeCol 代码列；ADicDescCol 描述列；AHasGB 查询条件是否有中文字符；AIsKeepMinus 描述列是否有横线
ClassMethod SelectStdDicMRCICDDxOperation(AMinCount As %String, AMaxCount As %String, AComItem As %String, ADicAliasCol As %String, ADicCodeCol As %String, ADicDescCol As %String, ASessionId As %String, AHasGB As %String, AIsKeepMinus As %String, ASessionArray As %ArrayOfDataTypes = "") As %Integer
{
	s groupDR = "3"		//手术
	s totRowCount = ..GetGroupedMRCICDDx(AMinCount, AMaxCount, AComItem, ADicAliasCol, ADicCodeCol, ADicDescCol, ASessionId, AHasGB, AIsKeepMinus, groupDR)
	q totRowCount
}

/// Create:	2012-04-01	Wangwt
/// Desc:	查询【诊断字典：SQLUser.MRC_ICDDx】内容：过敏
/// Input：	AComItem 查询条件；ADicAliasCol 别名列；ADicCodeCol 代码列；ADicDescCol 描述列；AHasGB 查询条件是否有中文字符；AIsKeepMinus 描述列是否有横线
ClassMethod SelectStdDicMRCICDDxAllergy(AMinCount As %String, AMaxCount As %String, AComItem As %String, ADicAliasCol As %String, ADicCodeCol As %String, ADicDescCol As %String, ASessionId As %String, AHasGB As %String, AIsKeepMinus As %String, ASessionArray As %ArrayOfDataTypes = "") As %Integer
{
	s groupDR = "5"		//过敏
	s totRowCount = ..GetGroupedMRCICDDx(AMinCount, AMaxCount, AComItem, ADicAliasCol, ADicCodeCol, ADicDescCol, ASessionId, AHasGB, AIsKeepMinus, groupDR)
	q totRowCount
}

/// Desc:	获取指定分组的ICD字典项目
ClassMethod GetGroupedMRCICDDx(AMinCount As %String, AMaxCount As %String, AComItem As %String, ADicAliasCol As %String, ADicCodeCol As %String, ADicDescCol As %String, ASessionId As %String, AHasGB As %String, AIsKeepMinus As %String, AGroupDR As %String) As %Integer
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
		if $zcvt(ADicCodeCol,"U")="MRCID_ROWID"
		{	
			//诊断字典代码列使用rowid，用在病案首页，方便传rowid给医政组做编目
			s CodeValue = rowid	
		}
		else
		{	s CodeValue=$p($g(^MRC("ID",rowid)),"^",4)	}
		
		//取描述列
		s DescValue=""
		if ($zcvt(ADicDescCol,"U")="MRCID_LONGDESCRIPTION")
		{	s DescValue=$p($g(^MRC("ID",rowid)),"^",36)}		//for 上海华山
		else
		{	s DescValue=$p($g(^MRC("ID",rowid)),"^",2)}
		
		//取代码列附加信息
		//s ICD9Map=" /"_$p($g(^MRC("ID",rowid)),"^",35)  //Comment and updated by Wangwt 2008-06-27
		s ICD9Map=""
		s ICD9MapRowDR=""
		s ICD9MapRowDR=##Class(EMRservice.BL.BLSysOption).GetOptionValueByName("ICDCodeExpand")
		if ICD9MapRowDR="Y"
		{
			s ICD9Map=" /"_$p($g(^MRC("ID",rowid)),"^",35) ;The Fourth Node is Parameter Value	
		}
		s CodeValue=CodeValue_ICD9Map
		
		//取别名列
		s AliasValue=""
		if ((ADicAliasCol '="")&&(ADicAliasCol'=$C(0)))
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
		if (AComItem '= "")
		{	
			s CodeCom= ##Class(EMRservice.Utility).CheckContain($ZCVT(CodeValue,"U"),$ZCVT(AComItem,"U"),AHasGB)
			S DescCom= ##Class(EMRservice.Utility).CheckContain($ZCVT(DescValue,"U"),$ZCVT(AComItem,"U"),AHasGB)
			if ((ADicAliasCol '="")&&(ADicAliasCol'=$C(0)))
			{	s AliasCom= ##Class(EMRservice.Utility).CheckContain($ZCVT(AliasValue,"U"),$ZCVT(AComItem,"U"),AHasGB)}
			
			if ((CodeCom '= 1)&&(DescCom '= 1)&&(AliasCom '= 1))
			{	continue}
		}
		
		//处理满足条件的结果并存入临时global
		s totRowCount = totRowCount + 1
		s AliasValue = $P(AliasValue,$C(2),1)
		if (AIsKeepMinus = "0")
		{	s DescValue = $E(DescValue,$F(DescValue,"-"),$L(DescValue)) }
		
		s:((totRowCount >= AMinCount)&&(totRowCount <= AMaxCount)) ^CacheTempStdQuery(ASessionId,totRowCount) =$LB(rowid,AliasValue,CodeValue,DescValue)
	}
	
	s ^CacheTempStdQuery(ASessionId,"StdQueryDataCount")= totRowCount
	
	q totRowCount
}

/// Create:	2008-11-27	HouJ
/// Desc:	查询【用户】字典内容：SQLUser.MRC_DiagnosSignSymptom
/// Input：	AComItem 查询条件；ADicAliasCol 别名列；ADicCodeCol 代码列；ADicDescCol 描述列；ADescHasMinius 描述列是否有横线
ClassMethod SelectStdDicDiagnosSignSymptom(AMinCount As %String, AMaxCount As %String, AComItem As %String, ADicAliasCol As %String, ADicCodeCol As %String, ADicDescCol As %String, ASessionId As %String, AHasGB As %String, AIsKeepMinus As %String, ASessionArray As %ArrayOfDataTypes = "") As %Integer
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
		if ($zcvt(ADicCodeCol,"U") = "DSYM_ROWID")
		{s CodeValue=rowid}
		elseif ($zcvt(ADicCodeCol,"U") = "DSYM_CODE")
		{s CodeValue=$p($g(^MRC("DSYM",rowid)),"^",1)}
		s DescValue=$p($g(^MRC("DSYM",rowid)),"^",2)
		
		s AliasValue=""
		if ((ADicAliasCol '="")&&(ADicAliasCol'=$C(0)))
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
		if (AComItem '= "")
		{	
			s CodeCom= ##Class(EMRservice.Utility).CheckContain($ZCVT(CodeValue,"U"),$ZCVT(AComItem,"U"),AHasGB)
			S DescCom= ##Class(EMRservice.Utility).CheckContain($ZCVT(DescValue,"U"),$ZCVT(AComItem,"U"),AHasGB)
			if ((ADicAliasCol '="")&&(ADicAliasCol'=$C(0)))
			{	s AliasCom= ##Class(EMRservice.Utility).CheckContain($ZCVT(AliasValue,"U"),$ZCVT(AComItem,"U"),AHasGB)}
			
			if ((CodeCom '= 1)&&(DescCom '= 1)&&(AliasCom '= 1))
			{	continue}
		}
		//s AliasValue = ""  //匹配完查询条件后将别名置空
		
		//处理满足条件的结果并存入临时global
		s totRowCount = totRowCount + 1
		if (AIsKeepMinus = "0")
		{	s DescValue = $E(DescValue,$F(DescValue,"-"),$L(DescValue)) }
		s:((totRowCount >= AMinCount)&&(totRowCount <= AMaxCount)) ^CacheTempStdQuery(ASessionId,totRowCount) =$LB(rowid,AliasValue,CodeValue,DescValue)
	}
	
	s ^CacheTempStdQuery(ASessionId,"StdQueryDataCount")= totRowCount
	
	q totRowCount
}

/// Desc:      肿瘤形态诊断字典
/// Creator:   Candy
/// CreateDate:2018-1-3
ClassMethod SelectStdMRCICDDXMetastatic(AMinCount As %String, AMaxCount As %String, AComItem As %String, ADicAliasCol As %String, ADicCodeCol As %String, ADicDescCol As %String, ASessionId As %String, AHasGB As %String, AIsKeepMinus As %String, ASessionArray As %ArrayOfDataTypes = "") As %Integer
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
		if $zcvt(ADicCodeCol,"U") = "MRCID_ROWID"
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
		if ($zcvt(ADicDescCol,"U") = "MRCID_LONGDESCRIPTION")
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
		s ICD9MapRowDR = ##Class(EMRservice.BL.BLSysOption).GetOptionValueByName("ICDCodeExpand")
		s:(ICD9MapRowDR = "Y") ICD9Map=" /"_$p($g(^MRC("ID",rowid)),"^",35) 
		s CodeValue = CodeValue_ICD9Map
		
		//取别名列
		s AliasValue=""
		if ((ADicAliasCol '="")&&(ADicAliasCol'=$C(0)))
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
		if (AComItem '= "")
		{	
			s CodeCom= ##Class(EMRservice.Utility).CheckContain($ZCVT(CodeValue,"U"),$ZCVT(AComItem,"U"),AHasGB)
			S DescCom= ##Class(EMRservice.Utility).CheckContain($ZCVT(DescValue,"U"),$ZCVT(AComItem,"U"),AHasGB)
			s:((ADicAliasCol '="")&&(ADicAliasCol'=$C(0))) AliasCom= ##Class(EMRservice.Utility).CheckContain($ZCVT(AliasValue,"U"),$ZCVT(AComItem,"U"),AHasGB)
			continue:((CodeCom '= 1)&&(DescCom '= 1)&&(AliasCom '= 1))
		}
		
		//处理满足条件的结果并存入临时global
		s totRowCount = totRowCount + 1
		s AliasValue = $P(AliasValue,$C(2),1)
		s:(AIsKeepMinus = "0") DescValue = $E(DescValue,$F(DescValue,"-"),$L(DescValue))
		s:((totRowCount >= AMinCount)&&(totRowCount <= AMaxCount)) ^CacheTempStdQuery(ASessionId,totRowCount) =$LB(rowid,AliasValue,CodeValue,DescValue)				
	}
	s ^CacheTempStdQuery(ASessionId,"StdQueryDataCount")= totRowCount
	q totRowCount
}

/// Create:	2011-12-21	HouJ
/// Desc:	查询【诊断】字典中  [HIS]ICD10损伤中毒外部因素字典  内容：SQLUser.MRC_ICDDx
/// Input：	AComItem 查询条件；ADicAliasCol 别名列；ADicCodeCol 代码列；ADicDescCol 描述列；AHasGB 查询条件是否有中文字符；AIsKeepMinus 描述列是否有横线
ClassMethod SelectStdMRCICDDxInjuryPoison(AMinCount As %String, AMaxCount As %String, AComItem As %String, ADicAliasCol As %String, ADicCodeCol As %String, ADicDescCol As %String, ASessionId As %String, AHasGB As %String, AIsKeepMinus As %String, ASessionArray As %ArrayOfDataTypes = "") As %Integer
{
	
	//结果行总数
	s totRowCount = 0
	
	//开始查询
	s rowid = 0
	for {
		s rowid=$o(^MRC("ID",rowid))
		quit:(rowid = "")
		
		if (ASessionArray.Count()'=0)
		{
			set hospId= ASessionArray.GetAt("HospitalID")
		}
		else
		{
			s hospId = 2
		}
		continue:(##Class(DHCDoc.Common.Hospital).GetHospShowDataFlag("MRC_ICDDx",rowid,hospId)="N")
				
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
		if $zcvt(ADicCodeCol,"U")="MRCID_ROWID"
		{	
			//诊断字典代码列使用rowid，用在病案首页，方便传rowid给医政组做编目
			s CodeValue = rowid	
		}
		else
		{	s CodeValue=$p($g(^MRC("ID",rowid)),"^",4)	}
		
		//取描述列
		s DescValue=""
		if ($zcvt(ADicDescCol,"U")="MRCID_LONGDESCRIPTION")
		{	s DescValue=$p($g(^MRC("ID",rowid)),"^",36)}		//for 上海华山
		else
		{	s DescValue=$p($g(^MRC("ID",rowid)),"^",2)}
		
		//取代码列附加信息
		//s ICD9Map=" /"_$p($g(^MRC("ID",rowid)),"^",35)  //Comment and updated by Wangwt 2008-06-27
		s ICD9Map=""
		s ICD9MapRowDR=""
		s ICD9MapRowDR=##Class(EMRservice.BL.BLSysOption).GetOptionValueByName("ICDCodeExpand")
		if ICD9MapRowDR="Y"
		{
			s ICD9Map=" /"_$p($g(^MRC("ID",rowid)),"^",35) ;The Fourth Node is Parameter Value	
		}
		s CodeValue=CodeValue_ICD9Map
		
		//取别名列
		s AliasValue=""
		if ((ADicAliasCol '="")&&(ADicAliasCol'=$C(0)))
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
		if (AComItem '= "")
		{	
			s CodeCom= ##Class(EMRservice.Utility).CheckContain($ZCVT(CodeValue,"U"),$ZCVT(AComItem,"U"),AHasGB)
			S DescCom= ##Class(EMRservice.Utility).CheckContain($ZCVT(DescValue,"U"),$ZCVT(AComItem,"U"),AHasGB)
			if ((ADicAliasCol '="")&&(ADicAliasCol'=$C(0)))
			{	s AliasCom= ##Class(EMRservice.Utility).CheckContain($ZCVT(AliasValue,"U"),$ZCVT(AComItem,"U"),AHasGB)}
			
			if ((CodeCom '= 1)&&(DescCom '= 1)&&(AliasCom '= 1))
			{	continue}
		}
		
		//处理满足条件的结果并存入临时global
		s totRowCount = totRowCount + 1
		s AliasValue = $P(AliasValue,$C(2),1)
		if (AIsKeepMinus = "0")
		{	s DescValue = $E(DescValue,$F(DescValue,"-"),$L(DescValue)) }
		
		s:((totRowCount >= AMinCount)&&(totRowCount <= AMaxCount)) ^CacheTempStdQuery(ASessionId,totRowCount) =$LB(rowid,AliasValue,CodeValue,DescValue)
	}
	
	s ^CacheTempStdQuery(ASessionId,"StdQueryDataCount")= totRowCount
	
	q totRowCount
}

/// Create:	2012-02-03 Wangwt
/// Desc:	查询【诊断】字典中  [HIS]ICD10病理诊断字典  内容：SQLUser.MRC_ICDDx
/// Input：	AComItem 查询条件；ADicAliasCol 别名列；ADicCodeCol 代码列；ADicDescCol 描述列；AHasGB 查询条件是否有中文字符；AIsKeepMinus 描述列是否有横线
ClassMethod SelectStdMRCICDDxPathology(AMinCount As %String, AMaxCount As %String, AComItem As %String, ADicAliasCol As %String, ADicCodeCol As %String, ADicDescCol As %String, ASessionId As %String, AHasGB As %String, AIsKeepMinus As %String, ASessionArray As %ArrayOfDataTypes = "") As %Integer
{
	
	//结果行总数
	s totRowCount = 0
	
	//开始查询
	s rowid = 0
	for {
		s rowid=$o(^MRC("ID",rowid))
		quit:(rowid = "")
		
		if (ASessionArray.Count()'=0)
		{
			set hospId= ASessionArray.GetAt("HospitalID")
		}
		else
		{
			s hospId = 2
		}
		continue:(##Class(DHCDoc.Common.Hospital).GetHospShowDataFlag("MRC_ICDDx",rowid,hospId)="N")
			
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
		s HospitalName=##class(EMRservice.BL.BLSysOption).GetOptionValueByName("HospitalName")
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
		if $zcvt(ADicCodeCol,"U")="MRCID_ROWID"
		{	
			//诊断字典代码列使用rowid，用在病案首页，方便传rowid给医政组做编目
			s CodeValue = rowid	
		}
		else
		{	s CodeValue=$p($g(^MRC("ID",rowid)),"^",4)	}
		
		//取描述列
		s DescValue=""
		if ($zcvt(ADicDescCol,"U")="MRCID_LONGDESCRIPTION")
		{	s DescValue=$p($g(^MRC("ID",rowid)),"^",36)}		//for 上海华山
		else
		{	s DescValue=$p($g(^MRC("ID",rowid)),"^",2)}
		
		//取代码列附加信息
		//s ICD9Map=" /"_$p($g(^MRC("ID",rowid)),"^",35)  //Comment and updated by Wangwt 2008-06-27
		s ICD9Map=""
		s ICD9MapRowDR=""
		s ICD9MapRowDR=##Class(EMRservice.BL.BLSysOption).GetOptionValueByName("ICDCodeExpand")
		if ICD9MapRowDR="Y"
		{
			s ICD9Map=" /"_$p($g(^MRC("ID",rowid)),"^",35) ;The Fourth Node is Parameter Value	
		}
		s CodeValue=CodeValue_ICD9Map
		
		//取别名列
		s AliasValue=""
		if ((ADicAliasCol '="")&&(ADicAliasCol'=$C(0)))
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
		if (AComItem '= "")
		{	
			s CodeCom= ##Class(EMRservice.Utility).CheckContain($ZCVT(CodeValue,"U"),$ZCVT(AComItem,"U"),AHasGB)
			S DescCom= ##Class(EMRservice.Utility).CheckContain($ZCVT(DescValue,"U"),$ZCVT(AComItem,"U"),AHasGB)
			if ((ADicAliasCol '="")&&(ADicAliasCol'=$C(0)))
			{	s AliasCom= ##Class(EMRservice.Utility).CheckContain($ZCVT(AliasValue,"U"),$ZCVT(AComItem,"U"),AHasGB)}
			
			if ((CodeCom '= 1)&&(DescCom '= 1)&&(AliasCom '= 1))
			{	continue}
		}
		
		//处理满足条件的结果并存入临时global
		s totRowCount = totRowCount + 1
		s AliasValue = $P(AliasValue,$C(2),1)
		if (AIsKeepMinus = "0")
		{	s DescValue = $E(DescValue,$F(DescValue,"-"),$L(DescValue)) }
		
		s:((totRowCount >= AMinCount)&&(totRowCount <= AMaxCount)) ^CacheTempStdQuery(ASessionId,totRowCount) =$LB(rowid,AliasValue,CodeValue,DescValue)
	}
	
	s ^CacheTempStdQuery(ASessionId,"StdQueryDataCount")= totRowCount
	
	q totRowCount
}

/// Create:	2012-02-03 Wangwt
/// Desc:	查询【诊断】字典中  [HIS]ICD10过敏类别字典  内容：SQLUser.MRC_ICDDx
/// Input：	AComItem 查询条件；ADicAliasCol 别名列；ADicCodeCol 代码列；ADicDescCol 描述列；AHasGB 查询条件是否有中文字符；AIsKeepMinus 描述列是否有横线
ClassMethod SelectStdMRCICDDxMedAllergy(AMinCount As %String, AMaxCount As %String, AComItem As %String, ADicAliasCol As %String, ADicCodeCol As %String, ADicDescCol As %String, ASessionId As %String, AHasGB As %String, AIsKeepMinus As %String, ASessionArray As %ArrayOfDataTypes = "") As %Integer
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
		if $zcvt(ADicCodeCol,"U")="MRCID_ROWID"
		{	
			//诊断字典代码列使用rowid，用在病案首页，方便传rowid给医政组做编目
			s CodeValue = rowid	
		}
		else
		{	s CodeValue=$p($g(^MRC("ID",rowid)),"^",4)	}
		
		//取描述列
		s DescValue=""
		if ($zcvt(ADicDescCol,"U")="MRCID_LONGDESCRIPTION")
		{	s DescValue=$p($g(^MRC("ID",rowid)),"^",36)}		//for 上海华山
		else
		{	s DescValue=$p($g(^MRC("ID",rowid)),"^",2)}
		
		//取代码列附加信息
		//s ICD9Map=" /"_$p($g(^MRC("ID",rowid)),"^",35)  //Comment and updated by Wangwt 2008-06-27
		s ICD9Map=""
		s ICD9MapRowDR=""
		s ICD9MapRowDR=##Class(EMRservice.BL.BLSysOption).GetOptionValueByName("ICDCodeExpand")
		if ICD9MapRowDR="Y"
		{
			s ICD9Map=" /"_$p($g(^MRC("ID",rowid)),"^",35) ;The Fourth Node is Parameter Value	
		}
		s CodeValue=CodeValue_ICD9Map
		
		//取别名列
		s AliasValue=""
		if ((ADicAliasCol '="")&&(ADicAliasCol'=$C(0)))
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
		if (AComItem '= "")
		{	
			s CodeCom= ##Class(EMRservice.Utility).CheckContain($ZCVT(CodeValue,"U"),$ZCVT(AComItem,"U"),AHasGB)
			S DescCom= ##Class(EMRservice.Utility).CheckContain($ZCVT(DescValue,"U"),$ZCVT(AComItem,"U"),AHasGB)
			if ((ADicAliasCol '="")&&(ADicAliasCol'=$C(0)))
			{	s AliasCom= ##Class(EMRservice.Utility).CheckContain($ZCVT(AliasValue,"U"),$ZCVT(AComItem,"U"),AHasGB)}
			
			if ((CodeCom '= 1)&&(DescCom '= 1)&&(AliasCom '= 1))
			{	continue}
		}
		
		//处理满足条件的结果并存入临时global
		s totRowCount = totRowCount + 1
		s AliasValue = $P(AliasValue,$C(2),1)
		if (AIsKeepMinus = "0")
		{	s DescValue = $E(DescValue,$F(DescValue,"-"),$L(DescValue)) }
		
		s:((totRowCount >= AMinCount)&&(totRowCount <= AMaxCount)) ^CacheTempStdQuery(ASessionId,totRowCount) =$LB(rowid,AliasValue,CodeValue,DescValue)
	}
	
	s ^CacheTempStdQuery(ASessionId,"StdQueryDataCount")= totRowCount
	
	q totRowCount
}

/// Create:	2012-02-03 Wangwt
/// Desc:	查询【诊断】字典中  [HIS]ICD10住院诊断字典  内容：SQLUser.MRC_ICDDx
/// Input：	AComItem 查询条件；ADicAliasCol 别名列；ADicCodeCol 代码列；ADicDescCol 描述列；AHasGB 查询条件是否有中文字符；AIsKeepMinus 描述列是否有横线
ClassMethod SelectStdMRCICDDxInpatient(AMinCount As %String, AMaxCount As %String, AComItem As %String, ADicAliasCol As %String, ADicCodeCol As %String, ADicDescCol As %String, ASessionId As %String, AHasGB As %String, AIsKeepMinus As %String, ASessionArray As %ArrayOfDataTypes = "") As %Integer
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
		if $zcvt(ADicCodeCol,"U")="MRCID_ROWID"
		{	
			//诊断字典代码列使用rowid，用在病案首页，方便传rowid给医政组做编目
			s CodeValue = rowid	
		}
		else
		{	s CodeValue=$p($g(^MRC("ID",rowid)),"^",4)	}
		
		//取描述列
		s DescValue=""
		if ($zcvt(ADicDescCol,"U")="MRCID_LONGDESCRIPTION")
		{	s DescValue=$p($g(^MRC("ID",rowid)),"^",36)}		//for 上海华山
		else
		{	s DescValue=$p($g(^MRC("ID",rowid)),"^",2)}
		
		//取代码列附加信息
		//s ICD9Map=" /"_$p($g(^MRC("ID",rowid)),"^",35)  //Comment and updated by Wangwt 2008-06-27
		s ICD9Map=""
		s ICD9MapRowDR=""
		s ICD9MapRowDR=##Class(EMRservice.BL.BLSysOption).GetOptionValueByName("ICDCodeExpand")
		if ICD9MapRowDR="Y"
		{
			s ICD9Map=" /"_$p($g(^MRC("ID",rowid)),"^",35) ;The Fourth Node is Parameter Value	
		}
		s CodeValue=CodeValue_ICD9Map
		
		//取别名列
		s AliasValue=""
		if ((ADicAliasCol '="")&&(ADicAliasCol'=$C(0)))
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
		if (AComItem '= "")
		{	
			s CodeCom= ##Class(EMRservice.Utility).CheckContain($ZCVT(CodeValue,"U"),$ZCVT(AComItem,"U"),AHasGB)
			S DescCom= ##Class(EMRservice.Utility).CheckContain($ZCVT(DescValue,"U"),$ZCVT(AComItem,"U"),AHasGB)
			if ((ADicAliasCol '="")&&(ADicAliasCol'=$C(0)))
			{	s AliasCom= ##Class(EMRservice.Utility).CheckContain($ZCVT(AliasValue,"U"),$ZCVT(AComItem,"U"),AHasGB)}
			
			if ((CodeCom '= 1)&&(DescCom '= 1)&&(AliasCom '= 1))
			{	continue}
		}
		
		//处理满足条件的结果并存入临时global
		s totRowCount = totRowCount + 1
		s AliasValue = $P(AliasValue,$C(2),1)
		if (AIsKeepMinus = "0")
		{	s DescValue = $E(DescValue,$F(DescValue,"-"),$L(DescValue)) }
		
		s:((totRowCount >= AMinCount)&&(totRowCount <= AMaxCount)) ^CacheTempStdQuery(ASessionId,totRowCount) =$LB(rowid,AliasValue,CodeValue,DescValue)
	}
	
	s ^CacheTempStdQuery(ASessionId,"StdQueryDataCount")= totRowCount
	
	q totRowCount
}

/// Create:	2012-1-4	HouJ
/// Desc:	查询【科室】字典内容：SQLUser.CT_HealthCareRegion
/// Input：	AComItem 查询条件；ADicAliasCol 别名列；ADicCodeCol 代码列；ADicDescCol 描述列；ADescHasMinius 描述列是否有横线
ClassMethod SelectStdDicCTHealthCareRegion(AMinCount As %String, AMaxCount As %String, AComItem As %String, ADicAliasCol As %String, ADicCodeCol As %String, ADicDescCol As %String, ASessionId As %String, AHasGB As %String, AIsKeepMinus As %String, ASessionArray As %ArrayOfDataTypes = "") As %Integer
{
	//结果行总数
	s totRowCount = 0
	
	//开始查询
	s rowid = 0
	for {
		s rowid=$o(^CT("HCR",rowid))
		quit:(rowid = "")
		
		//取代码列,描述列,别名列
		if ($zcvt(ADicCodeCol,"U") = "HCR_CODE")
		{	s CodeValue=$p($g(^CT("HCR",rowid)),"^",1)}
		elseif ($zcvt(ADicCodeCol,"U") = "HCR_ROWID")
		{	s CodeValue=rowid}
		
		s DescValue=$p($g(^CT("HCR",rowid)),"^",2)
		
		s AliasValue=""
		
		//是否满足查询条件
		s CodeCom=0, DescCom=0, AliasCom=0
		if (AComItem '= "")
		{	
			s CodeCom= ##Class(EMRservice.Utility).CheckContain($ZCVT(CodeValue,"U"),$ZCVT(AComItem,"U"),AHasGB)
			S DescCom= ##Class(EMRservice.Utility).CheckContain($ZCVT(DescValue,"U"),$ZCVT(AComItem,"U"),AHasGB)
			if ((ADicAliasCol '="")&&(ADicAliasCol'=$C(0)))
			{	s AliasCom= ##Class(EMRservice.Utility).CheckContain($ZCVT(AliasValue,"U"),$ZCVT(AComItem,"U"),AHasGB)}
			
			if ((CodeCom '= 1)&&(DescCom '= 1)&&(AliasCom '= 1))
			{	continue}
		}
		
		//处理满足条件的结果并存入临时global
		s totRowCount = totRowCount + 1
		if (AIsKeepMinus = "0")
		{	s DescValue = $E(DescValue,$F(DescValue,"-"),$L(DescValue)) }
		s:((totRowCount >= AMinCount)&&(totRowCount <= AMaxCount)) ^CacheTempStdQuery(ASessionId,totRowCount) =$LB(rowid,AliasValue,CodeValue,DescValue)
	}
	
	s ^CacheTempStdQuery(ASessionId,"StdQueryDataCount")= totRowCount
	
	q totRowCount
}

/// Create:	2013-05-14	wangwentao
/// Desc:	查询【诊断字典：SQLUser.DHC_WMR_ICDDx】内容：医政编目诊断
/// Input：	AComItem 查询条件；ADicAliasCol 别名列；ADicCodeCol 代码列；ADicDescCol 描述列；AHasGB 查询条件是否有中文字符；AIsKeepMinus 描述列是否有横线
ClassMethod SelectStdDicWMRICDDxDiag(AMinCount As %String, AMaxCount As %String, AComItem As %String, ADicAliasCol As %String, ADicCodeCol As %String, ADicDescCol As %String, ASessionId As %String, AHasGB As %String, AIsKeepMinus As %String, ASessionArray As %ArrayOfDataTypes = "") As %Integer
{
	s groupDR = ..GetStdDicWMRICDDxGroupDR(91)		//医政编目诊断
	s totRowCount = ..GetGroupedDHCWMRICDDx(AMinCount, AMaxCount, AComItem, ADicAliasCol, ADicCodeCol, ADicDescCol, ASessionId, AHasGB, AIsKeepMinus, groupDR)
	q totRowCount
}

/// Create:	2013-05-14	wangwentao
/// Desc:	查询【诊断字典：SQLUser.DHC_WMR_ICDDx】内容：医政编目病理形态学
/// Input：	AComItem 查询条件；ADicAliasCol 别名列；ADicCodeCol 代码列；ADicDescCol 描述列；AHasGB 查询条件是否有中文字符；AIsKeepMinus 描述列是否有横线
ClassMethod SelectStdDicWMRICDDxMorphology(AMinCount As %String, AMaxCount As %String, AComItem As %String, ADicAliasCol As %String, ADicCodeCol As %String, ADicDescCol As %String, ASessionId As %String, AHasGB As %String, AIsKeepMinus As %String, ASessionArray As %ArrayOfDataTypes = "") As %Integer
{
	s groupDR = ..GetStdDicWMRICDDxGroupDR(92)		//医政编目病理形态学
	s totRowCount = ..GetGroupedDHCWMRICDDx(AMinCount, AMaxCount, AComItem, ADicAliasCol, ADicCodeCol, ADicDescCol, ASessionId, AHasGB, AIsKeepMinus, groupDR)
	q totRowCount
}

/// Create:	2013-05-14	wangwentao
/// Desc:	查询【诊断字典：SQLUser.DHC_WMR_ICDDx】内容：医政编目手术
/// Input：	AComItem 查询条件；ADicAliasCol 别名列；ADicCodeCol 代码列；ADicDescCol 描述列；AHasGB 查询条件是否有中文字符；AIsKeepMinus 描述列是否有横线
ClassMethod SelectStdDicWMRICDDxOperation(AMinCount As %String, AMaxCount As %String, AComItem As %String, ADicAliasCol As %String, ADicCodeCol As %String, ADicDescCol As %String, ASessionId As %String, AHasGB As %String, AIsKeepMinus As %String, ASessionArray As %ArrayOfDataTypes = "") As %Integer
{
	s groupDR = ..GetStdDicWMRICDDxGroupDR(93)		//医政编目手术
	s totRowCount = ..GetGroupedDHCWMRICDDx(AMinCount, AMaxCount, AComItem, ADicAliasCol, ADicCodeCol, ADicDescCol, ASessionId, AHasGB, AIsKeepMinus, groupDR)
	q totRowCount
}

/// Create:	2013-05-14	wangwentao
/// Desc:	查询【诊断字典：SQLUser.DHC_WMR_ICDDx】内容：医政编目损伤
/// Input：	AComItem 查询条件；ADicAliasCol 别名列；ADicCodeCol 代码列；ADicDescCol 描述列；AHasGB 查询条件是否有中文字符；AIsKeepMinus 描述列是否有横线
ClassMethod SelectStdDicWMRICDDxInjury(AMinCount As %String, AMaxCount As %String, AComItem As %String, ADicAliasCol As %String, ADicCodeCol As %String, ADicDescCol As %String, ASessionId As %String, AHasGB As %String, AIsKeepMinus As %String, ASessionArray As %ArrayOfDataTypes = "") As %Integer
{
	s groupDR = ..GetStdDicWMRICDDxGroupDR(94)		//医政编目损伤
	s totRowCount = ..GetGroupedDHCWMRICDDx(AMinCount, AMaxCount, AComItem, ADicAliasCol, ADicCodeCol, ADicDescCol, ASessionId, AHasGB, AIsKeepMinus, groupDR)
	q totRowCount
}

/// Create:	2013-05-14	wangwentao
/// Desc:	查询【诊断字典：SQLUser.DHC_WMR_ICDDx】内容：医政编目过敏
/// Input：	AComItem 查询条件；ADicAliasCol 别名列；ADicCodeCol 代码列；ADicDescCol 描述列；AHasGB 查询条件是否有中文字符；AIsKeepMinus 描述列是否有横线
ClassMethod SelectStdDicWMRICDDxAllergy(AMinCount As %String, AMaxCount As %String, AComItem As %String, ADicAliasCol As %String, ADicCodeCol As %String, ADicDescCol As %String, ASessionId As %String, AHasGB As %String, AIsKeepMinus As %String, ASessionArray As %ArrayOfDataTypes = "") As %Integer
{
	s groupDR = ..GetStdDicWMRICDDxGroupDR(95)		//医政编目过敏
	s totRowCount = ..GetGroupedDHCWMRICDDx(AMinCount, AMaxCount, AComItem, ADicAliasCol, ADicCodeCol, ADicDescCol, ASessionId, AHasGB, AIsKeepMinus, groupDR)
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
ClassMethod GetGroupedDHCWMRICDDx(AMinCount As %String, AMaxCount As %String, AComItem As %String, ADicAliasCol As %String, ADicCodeCol As %String, ADicDescCol As %String, ASessionId As %String, AHasGB As %String, AIsKeepMinus As %String, AGroupDR As %String) As %Integer
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
		if $zcvt(ADicCodeCol,"U")="ICD1"
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
		if ((ADicAliasCol '="")&&(ADicAliasCol'=$C(0)))
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
		if (AComItem '= "")
		{	
			s CodeCom= ##Class(EMRservice.Utility).CheckContain($ZCVT(CodeValue,"U"),$ZCVT(AComItem,"U"),AHasGB)
			S DescCom= ##Class(EMRservice.Utility).CheckContain($ZCVT(DescValue,"U"),$ZCVT(AComItem,"U"),AHasGB)
			if ((ADicAliasCol '="")&&(ADicAliasCol'=$C(0)))
			{	s AliasCom= ##Class(EMRservice.Utility).CheckContain($ZCVT(AliasValue,"U"),$ZCVT(AComItem,"U"),AHasGB)}
			
			if ((CodeCom '= 1)&&(DescCom '= 1)&&(AliasCom '= 1))
			{	continue}
		}
		
		//处理满足条件的结果并存入临时global
		s totRowCount = totRowCount + 1
		s AliasValue = $P(AliasValue,$C(2),1)
		if (AIsKeepMinus = "0")
		{	s DescValue = $E(DescValue,$F(DescValue,"-"),$L(DescValue)) }
		
		s:((totRowCount >= AMinCount)&&(totRowCount <= AMaxCount)) ^CacheTempStdQuery(ASessionId,totRowCount) =$LB(rowid,AliasValue,CodeValue,DescValue)
	}
	
	s ^CacheTempStdQuery(ASessionId,"StdQueryDataCount")= totRowCount
	
	q totRowCount
}

/// Create:	2013-05-23	wangwentao
/// Desc:	查询【诊断】字典内容：SQLUser.MRC_ICDDxOP
/// Input：	AComItem 查询条件；ADicAliasCol 别名列；ADicCodeCol 代码列；ADicDescCol 描述列；AHasGB 查询条件是否有中文字符；AIsKeepMinus 描述列是否有横线
ClassMethod SelectStdDicMRCICDDxOP(AMinCount As %String, AMaxCount As %String, AComItem As %String, ADicAliasCol As %String, ADicCodeCol As %String, ADicDescCol As %String, ASessionId As %String, AHasGB As %String, AIsKeepMinus As %String, ASessionArray As %ArrayOfDataTypes = "") As %Integer
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
		s HospitalName=##class(EMRservice.BL.BLSysOption).GetOptionValueByName("HospitalName")
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
		if $zcvt(ADicCodeCol,"U")="MRCID_ROWID"
		{	
			//诊断字典代码列使用rowid，用在病案首页，方便传rowid给医政组做编目
			s CodeValue = rowid	
		}
		else
		{	s CodeValue=$p($g(^MRC("ID",rowid)),"^",4)	}
		
		//取描述列
		s DescValue=""
		if ($zcvt(ADicDescCol,"U")="MRCID_LONGDESCRIPTION")
		{	s DescValue=$p($g(^MRC("ID",rowid)),"^",36)}		//for 上海华山
		else
		{	s DescValue=$p($g(^MRC("ID",rowid)),"^",2)}
		
		//取代码列附加信息
		//s ICD9Map=" /"_$p($g(^MRC("ID",rowid)),"^",35)  //Comment and updated by Wangwt 2008-06-27
		s ICD9Map=""
		s ICD9MapRowDR=""
		s ICD9MapRowDR=##Class(EMRservice.BL.BLSysOption).GetOptionValueByName("ICDCodeExpand")
		if ICD9MapRowDR="Y"
		{
			s ICD9Map=" /"_$p($g(^MRC("ID",rowid)),"^",35) ;The Fourth Node is Parameter Value	
		}
		s CodeValue=CodeValue_ICD9Map
		
		//取别名列
		s AliasValue=""
		if ((ADicAliasCol '="")&&(ADicAliasCol'=$C(0)))
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
		if (AComItem '= "")
		{	
			s CodeCom= ##Class(EMRservice.Utility).CheckContain($ZCVT(CodeValue,"U"),$ZCVT(AComItem,"U"),AHasGB)
			S DescCom= ##Class(EMRservice.Utility).CheckContain($ZCVT(DescValue,"U"),$ZCVT(AComItem,"U"),AHasGB)
			if ((ADicAliasCol '="")&&(ADicAliasCol'=$C(0)))
			{	s AliasCom= ##Class(EMRservice.Utility).CheckContain($ZCVT(AliasValue,"U"),$ZCVT(AComItem,"U"),AHasGB)}
			
			if ((CodeCom '= 1)&&(DescCom '= 1)&&(AliasCom '= 1))
			{	continue}
		}
		
		//处理满足条件的结果并存入临时global
		s totRowCount = totRowCount + 1
		s AliasValue = $P(AliasValue,$C(2),1)
		if (AIsKeepMinus = "0")
		{	s DescValue = $E(DescValue,$F(DescValue,"-"),$L(DescValue)) }
		
		s:((totRowCount >= AMinCount)&&(totRowCount <= AMaxCount)) ^CacheTempStdQuery(ASessionId,totRowCount) =$LB(rowid,AliasValue,CodeValue,DescValue)
	}
	
	s ^CacheTempStdQuery(ASessionId,"StdQueryDataCount")= totRowCount
	
	q totRowCount
}

/// Create:	2013-07-15	wangwentao 北京门诊首页
/// Desc:	查询【手术】字典内容：SQLUser.ORC_Operation, SQLUser.ORC_OperationAlias
/// Input：	AComItem 查询条件；ADicAliasCol 别名列；ADicCodeCol 代码列；ADicDescCol 描述列；AHasGB 查询条件是否有中文字符；AIsKeepMinus 描述列是否有横线
ClassMethod SelectStdDicORCOperationOP(AMinCount As %String, AMaxCount As %String, AComItem As %String, ADicAliasCol As %String, ADicCodeCol As %String, ADicDescCol As %String, ASessionId As %String, AHasGB As %String, AIsKeepMinus As %String, ASessionArray As %ArrayOfDataTypes = "") As %Integer
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
		if ($zcvt(ADicCodeCol,"U") = "OPER_CODE")
		{	s CodeValue = $p($g(^ORC("OPER",rowid)),"^",1)}
		elseif ($zcvt(ADicCodeCol,"U") = "OPER_ICD10")
		{	s CodeValue =  $p($g(^ORC("OPER",rowid)),"^",14)}
		elseif ($zcvt(ADicCodeCol,"U") = "OPER_ROWID")
		{	S CodeValue = rowid}
		s DescValue=$p($g(^ORC("OPER",rowid)),"^",2)
		
		//取别名列
		s AliasValue=""
		if ((ADicAliasCol '="")&&(ADicAliasCol'=$C(0)))
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
		if (AComItem '= "")
		{	
			s CodeCom= ##Class(EMRservice.Utility).CheckContain($ZCVT(CodeValue,"U"),$ZCVT(AComItem,"U"),AHasGB)
			S DescCom= ##Class(EMRservice.Utility).CheckContain($ZCVT(DescValue,"U"),$ZCVT(AComItem,"U"),AHasGB)
			if ((ADicAliasCol '="")&&(ADicAliasCol'=$C(0)))
			{	s AliasCom= ##Class(EMRservice.Utility).CheckContain($ZCVT(AliasValue,"U"),$ZCVT(AComItem,"U"),AHasGB)}
			
			if ((CodeCom '= 1)&&(DescCom '= 1)&&(AliasCom '= 1))
			{	continue}
		}
		
		//处理满足条件的结果并存入临时global
		s totRowCount = totRowCount + 1
		s AliasValue = $P(AliasValue,$C(2),1)
		if (AIsKeepMinus = "0")
		{	s DescValue = $E(DescValue,$F(DescValue,"-"),$L(DescValue)) }
		
		s:((totRowCount >= AMinCount)&&(totRowCount <= AMaxCount)) ^CacheTempStdQuery(ASessionId,totRowCount) =$LB(rowid,AliasValue,CodeValue,DescValue)
	}
	
	s ^CacheTempStdQuery(ASessionId,"StdQueryDataCount")= totRowCount
	
	q totRowCount
}

/// Create:	2016-12-30  北京复兴首页  用户字典编码取医护人员表code，过滤编码为空人员
/// Desc:	查询【用户】字典内容：SQLUser.SS_User  
/// Input：	AComItem 查询条件；ADicAliasCol 别名列；ADicCodeCol 代码列；ADicDescCol 描述列；ADescHasMinius 描述列是否有横线
/// w ##class(EMRservice.BL.BLStdDictionary).SelectStdDic013("1","200","","SSUSR_EMailName","SSUSR_Initials","SSUSR_Name","141871","0","0","65")
ClassMethod SelectStdDic013(AMinCount As %String, AMaxCount As %String, AComItem As %String, ADicAliasCol As %String, ADicCodeCol As %String, ADicDescCol As %String, ASessionId As %String, AHasGB As %String, AIsKeepMinus As %String, ADefaultConditionValue As %String, ASessionArray As %ArrayOfDataTypes = "") As %Integer
{
	
	//结果行总数
	/*s totRowCount = 0
	
	//开始查询
	s rowid = 0
	for {
		s rowid=$o(^SSU("SSUSR",rowid))
		quit:(rowid = "")
		
		//取代码列,描述列,别名列
		if ($zcvt(ADicCodeCol,"U") = "SSUSR_INITIALS")
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
		//continue:(defaultDeptID '= ADefaultConditionValue)
		//
		//典默认手术室人员
		s defaultDeptID = ADefaultConditionValue
		//^RB("RES",0,"CTPCP",{RES_CTPCP_DR},{RES_CTLOC_DR},{RES_RowId})  SQLUser.RB_Resource
		s (SSUSRCareProvDR,RESRowId) = ""
		s SSUSRCareProvDR = $p($g(^SSU("SSUSR",rowid)),"^",14)
		s:(SSUSRCareProvDR'="")&&(defaultDeptID'="") RESRowId=$o(^RB("RES",0,"CTPCP",SSUSRCareProvDR,defaultDeptID,""))
		continue:(RESRowId="")
		//wangwentao 20111025 update end
		
		//是否满足查询条件
		s CodeCom=0, DescCom=0, AliasCom=0
		if (AComItem '= "")
		{	
			
			s CodeCom= ##Class(EMRservice.Utility).CheckContain($ZCVT(CodeValue,"U"),$ZCVT(AComItem,"U"),AHasGB)
			S DescCom= ##Class(EMRservice.Utility).CheckContain($ZCVT(DescValue,"U"),$ZCVT(AComItem,"U"),AHasGB)
			if ((ADicAliasCol '="")&&(ADicAliasCol'=$C(0)))
			{	s AliasCom= ##Class(EMRservice.Utility).CheckContain($ZCVT(AliasValue,"U"),$ZCVT(AComItem,"U"),AHasGB)}
			
			if ((CodeCom '= 1)&&(DescCom '= 1)&&(AliasCom '= 1))
			{	continue}
		}
		
		//处理满足条件的结果并存入临时global
		s totRowCount = totRowCount + 1
		if (AIsKeepMinus = "0")
		{	s DescValue = $E(DescValue,$F(DescValue,"-"),$L(DescValue)) }
		s:((totRowCount >= AMinCount)&&(totRowCount <= AMaxCount)) ^CacheTempStdQuery(ASessionId,totRowCount) =$LB(rowid,AliasValue,CodeValue,DescValue)
	}
	
	s ^CacheTempStdQuery(ASessionId,"StdQueryDataCount")= totRowCount
	
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
		if ($zcvt(ADicCodeCol,"U") = "SSUSR_INITIALS")
		{
			s DoctorDR=$p($g(^SSU("SSUSR",rowid)),"^",14)
			if (DoctorDR'="")
			{s CodeValue=$P($g(^CTPCP(DoctorDR,2)),"^",8)} 
			}
		s DescValue=$p($g(^SSU("SSUSR",rowid)),"^",2)
		s AliasValue=$p($g(^SSU("SSUSR",rowid)),"^",11)
		
		//是否满足查询条件
		s CodeCom=0, DescCom=0, AliasCom=0
		if (AComItem '= "")
		{	
			
			s CodeCom= ##Class(EMRservice.Utility).CheckContain($ZCVT(CodeValue,"U"),$ZCVT(AComItem,"U"),AHasGB)
			S DescCom= ##Class(EMRservice.Utility).CheckContain($ZCVT(DescValue,"U"),$ZCVT(AComItem,"U"),AHasGB)
			if ((ADicAliasCol '="")&&(ADicAliasCol'=$C(0)))
			{	s AliasCom= ##Class(EMRservice.Utility).CheckContain($ZCVT(AliasValue,"U"),$ZCVT(AComItem,"U"),AHasGB)}
			
			if ((CodeCom '= 1)&&(DescCom '= 1)&&(AliasCom '= 1))
			{	continue}
		}
		
		if (CodeValue ="")
		{ continue }
		
		//处理满足条件的结果并存入临时global
		s totRowCount = totRowCount + 1
		if (AIsKeepMinus = "0")
		{	s DescValue = $E(DescValue,$F(DescValue,"-"),$L(DescValue)) }
		s:((totRowCount >= AMinCount)&&(totRowCount <= AMaxCount)) ^CacheTempStdQuery(ASessionId,totRowCount) =$LB(rowid,AliasValue,CodeValue,DescValue)
	}
	
	s ^CacheTempStdQuery(ASessionId,"StdQueryDataCount")= totRowCount
	
	q totRowCount
}

/// Desc:	   查询耗材
/// Creator:   Candy
/// CreateDate:2018-8-3
/// Input：	   AComItem 查询条件；ADicAliasCol 别名列；ADicCodeCol 代码列；ADicDescCol 描述列；ADescHasMinius 描述列是否有横线
/// Debug:    w ##Class(EMRservice.BL.BLStdDictionary).SelectStdDicCTMarital(100,"","","","","","","")
ClassMethod SelectStdDicINCItm(AMinCount As %String, AMaxCount As %String, AComItem As %String, ADicAliasCol As %String, ADicCodeCol As %String, ADicDescCol As %String, ASessionId As %String, AHasGB As %String, AIsKeepMinus As %String, ASessionArray As %ArrayOfDataTypes = "") As %Integer
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
		
		s flag = ##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncStkCatGrp(rowid)
		continue:($p(flag,"^",1) '= "7601")
		//是否满足查询条件
		s CodeCom=0, DescCom=0, AliasCom=0
		if (AComItem '= "")
		{	
			s CodeCom = ##Class(EMRservice.Utility).CheckContain($ZCVT(CodeValue,"U"),$ZCVT(AComItem,"U"),AHasGB)
			s DescCom = ##Class(EMRservice.Utility).CheckContain($ZCVT(DescValue,"U"),$ZCVT(AComItem,"U"),AHasGB)
			s:((ADicAliasCol '="")&&(ADicAliasCol'=$C(0))) AliasCom= ##Class(EMRservice.Utility).CheckContain($ZCVT(AliasValue,"U"),$ZCVT(AComItem,"U"),AHasGB)
			continue:((CodeCom '= 1)&&(DescCom '= 1)&&(AliasCom '= 1))
		}
		//处理满足条件的结果并存入临时global
		s totRowCount = totRowCount + 1
		s:(AIsKeepMinus = "0") DescValue = $E(DescValue,$F(DescValue,"-"),$L(DescValue))
		s:((totRowCount >= AMinCount)&&(totRowCount <= AMaxCount)) ^CacheTempStdQuery(ASessionId,totRowCount) =$LB(rowid,AliasValue,CodeValue,DescValue)
	}
	
	s ^CacheTempStdQuery(ASessionId,"StdQueryDataCount")= totRowCount
	
	q totRowCount
}

/// Create:	2019-1-25	Lina
/// Desc:	查询【医保字典表中离院医院】字典内容：SQLUser.INSU_DicData
/// Input：	AComItem 查询条件；ADicAliasCol 别名列；ADicCodeCol 代码列；ADicDescCol 描述列；ADescHasMinius 描述列是否有横线
ClassMethod SelectStdDicINSUDicData(AMinCount As %String, AMaxCount As %String, AComItem As %String, ADicAliasCol As %String, ADicCodeCol As %String, ADicDescCol As %String, ASessionId As %String, AHasGB As %String, AIsKeepMinus As %String, ASessionArray As %ArrayOfDataTypes = "") As %Integer
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
		if (AComItem '= "")
		{
			s CodeCom = ##Class(EMRservice.Utility).CheckContain($ZCVT(CodeValue,"U"),$ZCVT(AComItem,"U"),AHasGB)
			s DescCom = ##Class(EMRservice.Utility).CheckContain($ZCVT(DescValue,"U"),$ZCVT(AComItem,"U"),AHasGB)
			s:((ADicAliasCol '="")&&(ADicAliasCol'=$C(0))) AliasCom= ##Class(EMRservice.Utility).CheckContain($ZCVT(AliasValue,"U"),$ZCVT(AComItem,"U"),AHasGB)
			continue:((CodeCom '= 1)&&(DescCom '= 1)&&(AliasCom '= 1))
		}
		
		
		//处理满足条件的结果并存入临时global
		s totRowCount = totRowCount + 1
		s:(AIsKeepMinus = "0") DescValue = $E(DescValue,$F(DescValue,"-"),$L(DescValue))
		s:((totRowCount >= AMinCount)&&(totRowCount <= AMaxCount)) ^CacheTempStdQuery(ASessionId,totRowCount) =$LB(rowid,AliasValue,CodeValue,DescValue)
	}
	
	s ^CacheTempStdQuery(ASessionId,"StdQueryDataCount")= totRowCount
	
	q totRowCount
}

/// Desc:	处理动态字典
ClassMethod SelectDynamicStdDic(AMinCount As %String, AMaxCount As %String, ADicTableName As %String, AConditon As %String, ADicAliasCol As %String, ADicCodeCol As %String, ADicDescCol As %String, ASessionId As %String, AHasGB As %String, AIsKeepMinus As %String, ASessionArray As %ArrayOfDataTypes = "") As %Integer
{
	s totRowCount = 0
	 
 	// 配置要查询的字段
	s sqlColumn = ""
	if (ADicCodeCol '= "")&&(ADicCodeCol '= $C(0))
	{	s sqlColumn = ADicCodeCol_" as MyCode"}
	if (ADicDescCol '= "")&&(ADicDescCol '= $C(0))
	{	s sqlColumn = sqlColumn_","_ADicDescCol_" as MyDesc"}
	if (ADicAliasCol '= "")&&(ADicAliasCol '= $C(0))
	{	s sqlColumn = sqlColumn_","_ADicAliasCol_" as MyAlias"}
	if (sqlColumn '= "")&&($E(sqlColumn,1,1)=",")
	{	s sqlColumn = $E(sqlColumn,2,$L(sqlColumn))}
	
	// 转换要查询的表
	s sqlTable = ##class(EMRservice.BL.BLStdDictionary).SwitchFromTable(ADicTableName)
	
	// 转换查询条件
	s sqlWhere = ""
	s sqlWhere = ..SwitchWhere(ADicTableName, sqlWhere)
	
	// 配置聚合条件
	s sqlOrder = ""
	if ((ADicCodeCol '= "")&&(ADicCodeCol '= $C(0)))
	{ s sqlOrder = " Order By  "_ADicCodeCol }
	
	// 总的sql语句
	s sqlTotal = "select "_sqlColumn_" from "_sqlTable_" "_sqlWhere_sqlOrder
	
	s resultSet = ##class(%Library.ResultSet).%New()
	d resultSet.Prepare(sqlTotal)
	d resultSet.Execute()
	while(resultSet.Next())
	{
		s conCodeValue = resultSet.Data("MyCode")
		s conDescValue = resultSet.Data("MyDesc")
		if (ADicAliasCol '= "")&&(ADicAliasCol '= $C(0))
		{	s conAliasValue = resultSet.Data("MyAlias")}
		else
		{	s conAliasValue = ""}
		
		s codeValue =  conCodeValue
		s descValue =  conDescValue
		if (AIsKeepMinus = 0)
		{	
			// 截掉"-"号及其前面的内容
			s descValue = $E(conDescValue,$F(conDescValue,"-"),$L(conDescValue))
		}		
		s aliasValue = conAliasValue
		
		// 是否满足查询条件
		if ((AConditon '="")&&(AConditon'=$C(0)))
		{
	 		s isCodeContain = ##Class(EMRservice.Utility).CheckGBContain($ZCVT(conCodeValue,"U"),$ZCVT(AConditon,"U"))
	  		s isDescContain = ##Class(EMRservice.Utility).CheckGBContain($ZCVT(conDescValue,"U"),$ZCVT(AConditon,"U"))
	  		s isAliasContain = ##Class(EMRservice.Utility).CheckGBContain($ZCVT(conAliasValue,"U"),$ZCVT(AConditon,"U"))
	  		
	  		if (isCodeContain="True")||(isDescContain="True")||(isAliasContain="True")
			{
				s totRowCount = totRowCount + 1
				s:((totRowCount >= AMinCount)&&(totRowCount <= AMaxCount)) ^CacheTempStdQuery(ASessionId, totRowCount)=$LB(totRowCount, aliasValue, codeValue, descValue)	
			}
		}
		else
		{
			s totRowCount = totRowCount  + 1
			s:((totRowCount >= AMinCount)&&(totRowCount <= AMaxCount)) ^CacheTempStdQuery(ASessionId, totRowCount)=$LB(totRowCount, aliasValue, codeValue, descValue)
		}
	}
		
	q totRowCount
}

/// Desc:	查询【用户】字典内容：SQLUser.CT_Marital
/// Input：	AComItem 查询条件；ADicAliasCol 别名列；ADicCodeCol 代码列；ADicDescCol 描述列；ADescHasMinius 描述列是否有横线
/// Debug:  w ##Class(EMRservice.BL.BLStdDictionary).SelectStdDicCTMarital(100,"","","","","","","")
ClassMethod SelectStdDicCTMarital(AMinCount As %String, AMaxCount As %String, AComItem As %String, ADicAliasCol As %String, ADicCodeCol As %String, ADicDescCol As %String, ASessionId As %String, AHasGB As %String, AIsKeepMinus As %String, ASessionArray As %ArrayOfDataTypes = "") As %Integer
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
		if (AComItem '= "")
		{	
			
			s CodeCom= ##Class(EMRservice.Utility).CheckContain($ZCVT(CodeValue,"U"),$ZCVT(AComItem,"U"),AHasGB)
			S DescCom= ##Class(EMRservice.Utility).CheckContain($ZCVT(DescValue,"U"),$ZCVT(AComItem,"U"),AHasGB)
			if ((ADicAliasCol '="")&&(ADicAliasCol'=$C(0)))
			{	s AliasCom= ##Class(EMRservice.Utility).CheckContain($ZCVT(AliasValue,"U"),$ZCVT(AComItem,"U"),AHasGB)}
			
			if ((CodeCom '= 1)&&(DescCom '= 1)&&(AliasCom '= 1))
			{	continue}
		}
		
		//处理满足条件的结果并存入临时global
		s totRowCount = totRowCount + 1
		if (AIsKeepMinus = "0")
		{	s DescValue = $E(DescValue,$F(DescValue,"-"),$L(DescValue)) }
		s:((totRowCount >= AMinCount)&&(totRowCount <= AMaxCount)) ^CacheTempStdQuery(ASessionId,totRowCount) =$LB(rowid,AliasValue,CodeValue,DescValue)
	}
	
	s ^CacheTempStdQuery(ASessionId,"StdQueryDataCount")= totRowCount
	
	q totRowCount
}

/// Desc:	    清理后台字典临时global
/// Creator:    Donglulu
/// CreateDate: 2016-8-16
ClassMethod CleanDictionarySession(ASessionId As %String)
{
	K ^CacheTempStdQuery(ASessionId)
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
 Set SqlString ="Select Name,TableName,DicAliasCol,DicCodeCol,DicDescCol From EMRmeta.StdDictionary "
 Set SqlWhereString =""
 if (ADicCode '="")
 {
 set TempCode= ADicCode //##class(EMRmeta.StdDictionary).ReplaceAsterisk(ADicCode)
 set SqlWhereString = "Where EMRmeta.StdDictionary.Code Like '"_TempCode_"'" 
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

 set DescBiteoffFlag= ##Class(EMRservice.BL.BLSysOption).CheckMinusFieldExist(DicTableName,DicDesc)

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
 Set GetDatasetSql = GetDatasetSql_AFieldSql_ " From "_##class(EMRservice.BL.BLStdDictionary).SwitchFromTable(DicTableName)
 //Set GetDatasetSql = GetDatasetSql_AFieldSql_ " From "_DicTableName

 Set GetWhereSql =""

 if ((DicAlias'="")&&(DicAlias'=$C(0)))
 { if (AAias '="")&&(AAias'=$C(0))
	    {
		  set TempAias =$ZCVT(##class(EMRservice.BL.BLStdDictionary).ReplaceAsterisk(AAias),"U")
		  
		  Set GetWhereSql =" Where UPPER("_DicAlias_") Like '"_TempAias_"' "
	    }
	}

 if ((DicCode'="")&&(DicCode'=$C(0)))
 {  
 if ((ACode '="")&&(ACode '=$C(0)))
	    {
		  set TempDicCode = $ZCVT(##class(EMRservice.BL.BLStdDictionary).ReplaceAsterisk(ACode),"U")
		  
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
		  set TempDesc =$ZCVT(##class(EMRservice.BL.BLStdDictionary).ReplaceAsterisk(ADesc),"U")
		  
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
/// Input：	AComItem 查询条件；ADicAliasCol 别名列；ADicCodeCol 代码列；ADicDescCol 描述列；AHasGB 查询条件是否有中文字符；AIsKeepMinus 描述列是否有横线
ClassMethod SelectStdDicBDTransType(AMinCount As %String, AMaxCount As %String, AComItem As %String, ADicAliasCol As %String, ADicCodeCol As %String, ADicDescCol As %String, ASessionId As %String, AHasGB As %String, AIsKeepMinus As %String, ASessionArray As %ArrayOfDataTypes = "") As %Integer
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
		if (AComItem '= "")
		{	
			s CodeCom= ##Class(EMRservice.Utility).CheckContain($ZCVT(CodeValue,"U"),$ZCVT(AComItem,"U"),AHasGB)
			S DescCom= ##Class(EMRservice.Utility).CheckContain($ZCVT(DescValue,"U"),$ZCVT(AComItem,"U"),AHasGB)
			if ((ADicAliasCol '="")&&(ADicAliasCol'=$C(0)))
			{	s AliasCom= ##Class(EMRservice.Utility).CheckContain($ZCVT(AliasValue,"U"),$ZCVT(AComItem,"U"),AHasGB)}
			
			if ((CodeCom '= 1)&&(DescCom '= 1)&&(AliasCom '= 1))
			{	continue}
		}
		
		//处理满足条件的结果并存入临时global
		s totRowCount = totRowCount + 1
		s AliasValue = $P(AliasValue,$C(2),1)
		if (AIsKeepMinus = "0")
		{	s DescValue = $E(DescValue,$F(DescValue,"-"),$L(DescValue)) }
		
		s:((totRowCount >= AMinCount)&&(totRowCount <= AMaxCount)) ^CacheTempStdQuery(ASessionId,totRowCount) = $LB(rowid,AliasValue,CodeValue,DescValue)
	}
	
	s ^CacheTempStdQuery(ASessionId,"StdQueryDataCount")= totRowCount
	
	q totRowCount
}

/// Create:	2020-01-08	donglulu
/// Desc:	查询【申请血产品】
/// Input：	AComItem 查询条件；ADicAliasCol 别名列；ADicCodeCol 代码列；ADicDescCol 描述列；AHasGB 查询条件是否有中文字符；AIsKeepMinus 描述列是否有横线
ClassMethod SelectStdDicBDReqProduct(AMinCount As %String, AMaxCount As %String, AComItem As %String, ADicAliasCol As %String, ADicCodeCol As %String, ADicDescCol As %String, ASessionId As %String, AHasGB As %String, AIsKeepMinus As %String, ASessionArray As %ArrayOfDataTypes = "") As %Integer
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
		if (AComItem '= "")
		{	
			s CodeCom= ##Class(EMRservice.Utility).CheckContain($ZCVT(CodeValue,"U"),$ZCVT(AComItem,"U"),AHasGB)
			S DescCom= ##Class(EMRservice.Utility).CheckContain($ZCVT(DescValue,"U"),$ZCVT(AComItem,"U"),AHasGB)
			if ((ADicAliasCol '="")&&(ADicAliasCol'=$C(0)))
			{	s AliasCom= ##Class(EMRservice.Utility).CheckContain($ZCVT(AliasValue,"U"),$ZCVT(AComItem,"U"),AHasGB)}
			
			if ((CodeCom '= 1)&&(DescCom '= 1)&&(AliasCom '= 1))
			{	continue}
		}
		
		//处理满足条件的结果并存入临时global
		s totRowCount = totRowCount + 1
		s AliasValue = $P(AliasValue,$C(2),1)
		if (AIsKeepMinus = "0")
		{	s DescValue = $E(DescValue,$F(DescValue,"-"),$L(DescValue)) }
		
		s:((totRowCount >= AMinCount)&&(totRowCount <= AMaxCount)) ^CacheTempStdQuery(ASessionId,totRowCount) = $LB(rowid,AliasValue,CodeValue,DescValue)
	}
	
	s ^CacheTempStdQuery(ASessionId,"StdQueryDataCount")= totRowCount
	
	q totRowCount
}

/// Create:	2020-01-08	donglulu
/// Desc:	查询【输血目的】
/// Input：	AComItem 查询条件；ADicAliasCol 别名列；ADicCodeCol 代码列；ADicDescCol 描述列；AHasGB 查询条件是否有中文字符；AIsKeepMinus 描述列是否有横线
ClassMethod SelectStdDicBDTransPurpose(AMinCount As %String, AMaxCount As %String, AComItem As %String, ADicAliasCol As %String, ADicCodeCol As %String, ADicDescCol As %String, ASessionId As %String, AHasGB As %String, AIsKeepMinus As %String, ASessionArray As %ArrayOfDataTypes = "") As %Integer
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
		if (AComItem '= "")
		{	
			s CodeCom= ##Class(EMRservice.Utility).CheckContain($ZCVT(CodeValue,"U"),$ZCVT(AComItem,"U"),AHasGB)
			S DescCom= ##Class(EMRservice.Utility).CheckContain($ZCVT(DescValue,"U"),$ZCVT(AComItem,"U"),AHasGB)
			if ((ADicAliasCol '="")&&(ADicAliasCol'=$C(0)))
			{	s AliasCom= ##Class(EMRservice.Utility).CheckContain($ZCVT(AliasValue,"U"),$ZCVT(AComItem,"U"),AHasGB)}
			
			if ((CodeCom '= 1)&&(DescCom '= 1)&&(AliasCom '= 1))
			{	continue}
		}
		
		//处理满足条件的结果并存入临时global
		s totRowCount = totRowCount + 1
		s AliasValue = $P(AliasValue,$C(2),1)
		if (AIsKeepMinus = "0")
		{	s DescValue = $E(DescValue,$F(DescValue,"-"),$L(DescValue)) }
		
		s:((totRowCount >= AMinCount)&&(totRowCount <= AMaxCount)) ^CacheTempStdQuery(ASessionId,totRowCount) = $LB(rowid,AliasValue,CodeValue,DescValue)
	}
	
	s ^CacheTempStdQuery(ASessionId,"StdQueryDataCount")= totRowCount
	
	q totRowCount
}

/// Create:	2020-01-08	donglulu
/// Desc:	查询【供着血型】
/// Input：	AComItem 查询条件；ADicAliasCol 别名列；ADicCodeCol 代码列；ADicDescCol 描述列；AHasGB 查询条件是否有中文字符；AIsKeepMinus 描述列是否有横线
ClassMethod SelectStdDicBDBLOODGROUP(AMinCount As %String, AMaxCount As %String, AComItem As %String, ADicAliasCol As %String, ADicCodeCol As %String, ADicDescCol As %String, ASessionId As %String, AHasGB As %String, AIsKeepMinus As %String, ASessionArray As %ArrayOfDataTypes = "") As %Integer
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
		if (AComItem '= "")
		{	
			s CodeCom= ##Class(EMRservice.Utility).CheckContain($ZCVT(CodeValue,"U"),$ZCVT(AComItem,"U"),AHasGB)
			S DescCom= ##Class(EMRservice.Utility).CheckContain($ZCVT(DescValue,"U"),$ZCVT(AComItem,"U"),AHasGB)
			if ((ADicAliasCol '="")&&(ADicAliasCol'=$C(0)))
			{	s AliasCom= ##Class(EMRservice.Utility).CheckContain($ZCVT(AliasValue,"U"),$ZCVT(AComItem,"U"),AHasGB)}
			
			if ((CodeCom '= 1)&&(DescCom '= 1)&&(AliasCom '= 1))
			{	continue}
		}
		
		//处理满足条件的结果并存入临时global
		s totRowCount = totRowCount + 1
		s AliasValue = $P(AliasValue,$C(2),1)
		if (AIsKeepMinus = "0")
		{	s DescValue = $E(DescValue,$F(DescValue,"-"),$L(DescValue)) }
		
		s:((totRowCount >= AMinCount)&&(totRowCount <= AMaxCount)) ^CacheTempStdQuery(ASessionId,totRowCount) = $LB(rowid,AliasValue,CodeValue,DescValue)
	}
	
	s ^CacheTempStdQuery(ASessionId,"StdQueryDataCount")= totRowCount
	
	q totRowCount
}

/// Create:	2021-03-01	lifengbo
/// Desc:	查询【用户】字典内容：SQLUser.MRC_TCMTreatment
/// Input：	AComItem 查询条件；ADicAliasCol 别名列；ADicCodeCol 代码列；ADicDescCol 描述列；ADescHasMinius 描述列是否有横线
ClassMethod SelectStdDicMRCTCMTreatment(AMinCount As %String, AMaxCount As %String, AComItem As %String, ADicAliasCol As %String, ADicCodeCol As %String, ADicDescCol As %String, ASessionId As %String, AHasGB As %String, AIsKeepMinus As %String, ASessionArray As %ArrayOfDataTypes = "") As %Integer
{
	//结果行总数
	s totRowCount = 0
	
	//开始查询
	s rowid = 0
	for {
		s rowid=$o(^MRC("TCMT",rowid))
		quit:(rowid = "")
		
		//取代码列,描述列,别名列
		s CodeValue=$p($g(^MRC("TCMT",rowid)),"^",1)

		s DescValue=$p($g(^MRC("TCMT",rowid)),"^",2)
		s AliasValue=$p($g(^MRC("TCMT",rowid)),"^",8)
		
		//无效状态退出
		s TCMTValid = $p($g(^MRC("TCMT",rowid)),"^",5)
		if (TCMTValid="N")
		{	
			continue
		}
		
		//是否满足查询条件
		s CodeCom=0, DescCom=0, AliasCom=0
		if (AComItem '= "")
		{	
			
			s CodeCom= ##Class(EMRservice.Utility).CheckContain($ZCVT(CodeValue,"U"),$ZCVT(AComItem,"U"),AHasGB)
			S DescCom= ##Class(EMRservice.Utility).CheckContain($ZCVT(DescValue,"U"),$ZCVT(AComItem,"U"),AHasGB)
			if ((ADicAliasCol '="")&&(ADicAliasCol'=$C(0)))
			{	
				s AliasCom= ##Class(EMRservice.Utility).CheckContain($ZCVT(AliasValue,"U"),$ZCVT(AComItem,"U"),AHasGB)
			}
			
			if ((CodeCom '= 1)&&(DescCom '= 1)&&(AliasCom '= 1))
			{	
				continue
			}
		}
		
		//处理满足条件的结果并存入临时global
		s totRowCount = totRowCount + 1
		if (AIsKeepMinus = "0")
		{	s DescValue = $E(DescValue,$F(DescValue,"-"),$L(DescValue)) }
		s:((totRowCount >= AMinCount)&&(totRowCount <= AMaxCount)) ^CacheTempStdQuery(ASessionId,totRowCount) =$LB(rowid,AliasValue,CodeValue,DescValue)
	}
	
	s ^CacheTempStdQuery(ASessionId,"StdQueryDataCount")= totRowCount
	
	q totRowCount
}

/// Create:	2021-03-09	lifengbo
/// Desc:	查询对应医院【病区（CTLOC）】字典内容：SQLUser.CT_Loc，筛选条件hospitalID
/// Input：	AComItem 查询条件；ADicAliasCol 别名列；ADicCodeCol 代码列；ADicDescCol 描述列；ADescHasMinius 描述列是否有横线
ClassMethod SelectStdDic020(AMinCount As %String, AMaxCount As %String, AComItem As %String, ADicAliasCol As %String, ADicCodeCol As %String, ADicDescCol As %String, ASessionId As %String, AHasGB As %String, AIsKeepMinus As %String, ADefaultConditionValue As %String, ASessionArray As %ArrayOfDataTypes = "") As %Integer
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
		continue:((ADefaultConditionValue '= "")&&(ADefaultConditionValue '= locHospitalId))
		
		//过滤病区数据
		s wardFlag = $p($g(^CTLOC(rowid)),"^",5)
		continue:(wardFlag'="Y")
		
		//取代码列,描述列,别名列
		if ($zcvt(ADicCodeCol,"U") = "CTLOC_CODE")
		{	s CodeValue=$p($g(^CTLOC(rowid)),"^",1)}
		elseif ($zcvt(ADicCodeCol,"U") = "CTLOC_ROWID")
		{	s CodeValue=rowid}
		
		s DescValue=$p($g(^CTLOC(rowid)),"^",2)
		
		s AliasValue=""
		if ($zcvt(ADicAliasCol,"U") = "CTLOC_CONTACTNAME")
		{	s AliasValue = $p($g(^CTLOC(rowid)),"^",43)}
		
		//是否满足查询条件
		s CodeCom=0, DescCom=0, AliasCom=0
		if (AComItem '= "")
		{	
			
			s CodeCom= ##Class(EMRservice.Utility).CheckContain($ZCVT(CodeValue,"U"),$ZCVT(AComItem,"U"),AHasGB)
			S DescCom= ##Class(EMRservice.Utility).CheckContain($ZCVT(DescValue,"U"),$ZCVT(AComItem,"U"),AHasGB)
			if ((ADicAliasCol '="")&&(ADicAliasCol'=$C(0)))
			{	s AliasCom= ##Class(EMRservice.Utility).CheckContain($ZCVT(AliasValue,"U"),$ZCVT(AComItem,"U"),AHasGB)}
			
			if ((CodeCom '= 1)&&(DescCom '= 1)&&(AliasCom '= 1))
			{	continue}
		}
		
		//处理满足条件的结果并存入临时global
		s totRowCount = totRowCount + 1
		if (AIsKeepMinus = "0")
		{	s DescValue = $E(DescValue,$F(DescValue,"-"),$L(DescValue)) }
		//科室字典因前端应用情况（查询、浏览中科室数据）及HIS中基础数据的数据量，所以修改为不做min max控制
		//s:((totRowCount >= AMinCount)&&(totRowCount <= AMaxCount)) ^CacheTempStdQuery(ASessionId,totRowCount) =$LB(rowid,AliasValue,CodeValue,DescValue)
		s ^CacheTempStdQuery(ASessionId,totRowCount) =$LB(rowid,AliasValue,CodeValue,DescValue)
	
	}
	
	s ^CacheTempStdQuery(ASessionId,"StdQueryDataCount")= totRowCount
	
	q totRowCount
}

}
