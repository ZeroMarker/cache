/// ************************************************************
/// * Class Name:	EPRmeta.Quality.QualityPool
/// * Description:	The model of quality pool
/// * Author:		Zuoxiang Xie
/// * Create Date:	2010-04-26
/// * Version:		
/// ************************************************************/
Class EPRmeta.Quality.QualityPool Extends (%Persistent, User.Abstract) [ ClassType = persistent, ProcedureBlock ]
{

/// 目的是使ID列具有和Code列相同的数据
Index RowIDBasedIDKeyIndex On Code [ IdKey, PrimaryKey, Unique ];

Index IdxType On Type;

Index IdxIsQuery On IsQuery;

Index IdxEMRCode On EMRCode;

/// 代码（完整性项目以E开头，一致性项目以U开头）
Property Code As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2 ];

/// 描述
Property Title As %Library.String(COLLATION = "Exact", MAXLEN = 400, TRUNCATE = 0) [ SqlColumnNumber = 3 ];

/// 表达式
Property Expression As %Library.String(COLLATION = "Exact", MAXLEN = 1000, TRUNCATE = 0) [ SqlColumnNumber = 4 ];

/// 是否有效
Property IsActive As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 5 ];

/// 类型
Property Type As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6 ];

/// 备注
Property ResumeText As %Library.String(COLLATION = "Exact", MAXLEN = 2000, TRUNCATE = 0) [ SqlColumnNumber = 7 ];

/// 是否可查询
Property IsQuery As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 8 ];

/// HIS标版code
Property EMRCode As %Library.String;

/// Return:	Total count that satisify the search condition
/// Debug:	d ##Class(EPRmeta.Quality.QualityPool).GetQualityPoolsOrEntries("U","","","","0","1","b7b2379a-596d-44ca-9576-e9c465bb2d46")
ClassMethod GetQualityPoolsOrEntries(AType As %String, ARuleID As %String, AStructID As %String, ATemplateID As %String, AIsRuleFirst As %String, AIsNewQuery As %String, AUniqueGlobalID As %String, ACode As %String = "") As %String
{
	s ret = 0
	q:($d(AType) = 0)||($d(AIsRuleFirst) = 0)||($d(AIsNewQuery) = 0)||($d(AUniqueGlobalID) = 0) ret
	q:(AType = "")||(AIsRuleFirst = "")||(AIsNewQuery = "")||(AUniqueGlobalID = "") ret
	
	if (AIsNewQuery = "1")
	{
		// AIsNewQuery=1 represent a new query, clear temp data of previous query at first
		k ^CacheTempDHCEPRQualityPool(AUniqueGlobalID)
		
		if (AIsRuleFirst = "1")
		{
			//insert data into glboal ^CacheTempDHCEPRQualityPool(AUniqueGlobalID), not ^CacheTemp
			d ..GetPoolOrEntryByRuleFirst(AType,ARuleID,AStructID,ATemplateID,AUniqueGlobalID,ACode)
		}
		else
		{
			//insert data into glboal ^CacheTempDHCEPRQualityPool(AUniqueGlobalID), not ^CacheTemp
			d ..GetPoolOrEntryByStructFirst(AType,ARuleID,AStructID,ATemplateID,AUniqueGlobalID,ACode)
		}
	}
	
	s ret = $o(^CacheTempDHCEPRQualityPool(AUniqueGlobalID,""),-1)
	s:(ret = "") ret = 0
	q ret
}

/// d ##Class(%ResultSet).RunQuery("EPRmeta.Quality.QualityPool","GetPoolByMultiParams","E","","6","","0","1","3","50","0","")
Query GetPoolByMultiParams(APageNum As %String, APageSize As %String, AResultCount As %String, ByRef AUniqueGlobalID As %String) As %Query(ROWSPEC = "PoolID,Code,Title,Expression,RuleID,RuleName,StructID,StructName,EntryID,Score,Sequence,IsMultiErr,IsVeto,IsActive,ResumeText,VetoGrade,CondtionID,DescScore,IsQuery,EntryConditionID")
{
}

ClassMethod GetPoolByMultiParamsExecute(ByRef qHandle As %Binary, APageNum As %String, APageSize As %String, AResultCount As %String, ByRef AUniqueGlobalID As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	
	//fetch paged data from ^CacheTempDHCEPRQualityPool into ^CacheTemp
	s StartRow = (+APageNum-1)*(+APageSize)+1
	s EndRow = (+APageNum)*(+APageSize)
	s Count=0
	if ($d(^CacheTempDHCEPRQualityPool(AUniqueGlobalID)))
	{
		s Count=$o(^CacheTempDHCEPRQualityPool(AUniqueGlobalID,""),-1)
		if (EndRow > Count)
		{
			s EndRow = Count	
		}
		for i = StartRow:1:EndRow 
		{
			s ^CacheTemp(repid,ind) = $g(^CacheTempDHCEPRQualityPool(AUniqueGlobalID,i))
			s ind = ind + 1
		}
	}
	q $$$OK
}

ClassMethod GetPoolByMultiParamsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPoolByMultiParamsExecute ]
{
	s AtEnd=$list(qHandle,1)
 	s repid=$list(qHandle,2)
 	s ind=$list(qHandle,3)
 	
 	s ind=$o(^CacheTemp(repid,ind))
 	if ind="" 
 	{	
 		s AtEnd=1
 		s Row=""
 		k ^CacheTemp(repid) 
 	} 
 	else 
 	{
 		s Row=^CacheTemp(repid,ind)
 	}
 	
 	s qHandle=$lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod GetPoolByMultiParamsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPoolByMultiParamsExecute ]
{
	s repid=$list(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

/// d ##Class(EPRmeta.Quality.QualityPool).GetPoolOrEntryByRuleFirst("E","2","10","704","1")
ClassMethod GetPoolOrEntryByRuleFirst(AType As %String, ARuleID As %String, AStructID As %String, ATemplateID As %String, AUniqueGlobalID As %String, ACode As %String = "")
{
	s ind=1
	s EntryID=$o(^DHCEPRM.QualityEntryI("IdxRuleDR"," "_ARuleID,""))
	While(EntryID'="")
	{
		s (PoolID,Code,Title,Expression,RuleID,RuleName,StructID,StructName,Score,Sequence,IsMultiErr,IsVeto,IsActive,ResumeText,VetoGrade,CondtionID,DescScore,IsQuery,EntryConditionID)=$C(0)
		 
		s objEntry=##Class(EPRmeta.Quality.QualityEntry).%OpenId(EntryID) //$g(^DHCEPRM.QualityEntryD(EntryID))
		
		//质控规则RowID
		s PoolID=objEntry.PoolDR //$list(objEntry,1)
		if (ACode'="")&&(ACode'=$c(0))
		{
			if (PoolID'=ACode)
			{
				s EntryID=$o(^DHCEPRM.QualityEntryI("IdxRuleDR"," "_ARuleID,EntryID))
				continue
			}
		}
												
		//质控标准RowID
		s RuleID=objEntry.RuleDR //$list(objEntry,2)										
		//质控病历结构RowID
		s StructID=objEntry.StructDR //$list(objEntry,3)									
		//质控项目分数
		//根据策略显示等级分数
		s objResult = ##Class(EPRservice.Quality.OperationLogic.EvaluationResult).CreateInstance()
		s Score = objEntry.Score //$list(objEntry,4)
		s DescScore = objResult.GetEvaluationValue(Score)
		d objResult.%Close()
		s objResult = ""										
		//质控项目显示位置
		s Sequence=objEntry.Sequence //$list(objEntry,5)									
		//质控项目是否允许被多次评分
		s IsMultiErr=objEntry.IsMultiErr //$list(objEntry,6)									
		//质控项目是否单项否决
		s IsVeto=objEntry.IsVeto //$list(objEntry,7)										
		//质控项目是否有效
		s IsActive=objEntry.IsActive //$list(objEntry,8)									
		//质控项目备注
		s ResumeText=objEntry.ResumeText //$list(objEntry,9)									
		//质控项目单项否决级别
        s VetoGrade=objEntry.VetoGrade //$list(objEntry,11)									
        //预警条件
        s CondtionID = $case(objEntry.ChkConditionDR," ":0,"":0,$c(0):0,:objEntry.ChkConditionDR) //$list(objEntry,13)
        //执行条目条件
        s EntryConditionID = $case(objEntry.EntryConditionDR,"":0," ":0,$c(0):0,:objEntry.EntryConditionDR)
        s objEntry=""
        
        //质控标准名称
		s objRule=##Class(EPRmeta.Quality.QualityRule).%OpenId(+RuleID)
		s RuleName=objRule.Name  //$list($g(^DHCEPRM.QualityRuleD(+RuleID)),2)  
		s objRule=""
		//质控病历结构标准名称
		s objStruct=##Class(EPRmeta.Quality.QualityStruct).%OpenId(StructID)
        s StructName =""
	    if (objStruct'="")
	    {
		    s StructName=objStruct.StandardName
	    }
		s objStruct=""	
	      
	    s objPool=##Class(EPRmeta.Quality.QualityPool).%OpenId(PoolID)  
		s Type=objPool.Type  //$list($g(^DHCEPRM.QualityPoolD(PoolID)),5)
		
		if (Type=AType) 
		{
			s Title=..GetTitleByPoolID(PoolID)
			s Code=objPool.Code  //$list($g(^DHCEPRM.QualityPoolD(PoolID)),1)
			s Expression=objPool.Expression  //$list($g(^DHCEPRM.QualityPoolD(PoolID)),3)
			s IsQuery = $case(objPool.IsQuery,"Y":"Y",:"N")
			if (AStructID'="") 
			{
				if (..IsEntryExist(EntryID,AStructID)) 
				{
					if (ATemplateID'="") 
					{
						s UnitID=$ZSTRIP(PoolID,"*A")
						s objTemplate=##Class(EPRmeta.Quality.QualityTemplate).%OpenId(UnitID)  
						s TemplateID=objTemplate.TemplateId  //$list($g(^DHCEPRM.QualityTemplateD(UnitID)),1)
						if (TemplateID=ATemplateID) 
						{
							d SetOutputRow1
						}
						s objTemplate=""
					} 
					else 
					{
						d SetOutputRow1
					}
				}
			} 
			else 
			{
				d SetOutputRow1
			}
		}
		s objPool= ""
		s EntryID=$o(^DHCEPRM.QualityEntryI("IdxRuleDR"," "_ARuleID,EntryID))
	}
	q $$$OK
	
SetOutputRow1
	s Data=$lb(PoolID,Code,Title,Expression,RuleID,RuleName,StructID,StructName,EntryID,Score,Sequence,IsMultiErr,IsVeto,IsActive,ResumeText,VetoGrade,CondtionID,DescScore,IsQuery,EntryConditionID)
	s ^CacheTempDHCEPRQualityPool(AUniqueGlobalID,ind) = Data
	s ind = ind + 1
	q
}

/// d ##Class(EPRmeta.Quality.QualityPool).GetPoolOrEntryByStructFirst("E","","","","1")
ClassMethod GetPoolOrEntryByStructFirst(AType As %String, ARuleID As %String, AStructID As %String, ATemplateID As %String, AUniqueGlobalID As %String, ACode As %String)
{
	s ind=1
	s PoolID = ""
	s PoolID=$o(^DHCEPRM.QualityPoolI("IdxType",AType,""))
	While(PoolID'="")
	{
		s (Code,Title,Expression,RuleID,RuleName,StructID,StructName,EntryID,Score,Sequence,IsMultiErr,IsVeto,IsActive,ResumeText,VetoGrade,CondtionID,DescScore,IsQuery,EntryConditionID)=$C(0)
		if (ACode'="")&&(ACode'=$c(0))
		{
			if (PoolID'=ACode)
			{
				s PoolID=$o(^DHCEPRM.QualityPoolI("IdxType",AType,PoolID))	
				continue
			}
		}
		s objPool=##Class(EPRmeta.Quality.QualityPool).%OpenId(PoolID)
		if (objPool="")
		{
			s PoolID=$o(^DHCEPRM.QualityPoolI("IdxType",AType,PoolID))
			continue
		}
		s Code = objPool.Code  
		s Title = ..GetTitleByPoolID(PoolID)
		s Expression = objPool.Expression 
		s ResumeText = objPool.ResumeText  
		s IsQuery = $case(objPool.IsQuery,"Y":"Y",:"N")    //add by Candy
		s objPool="" 
		if (AStructID'="") 
		{
			s PoolExist=..IsPoolExist(PoolID,AStructID)
			if (PoolExist) 
			{
				if (ATemplateID'="") 
				{
					s UnitID=$ZSTRIP(PoolID,"*A")		
					s objTemplate=##Class(EPRmeta.Quality.QualityTemplate).%OpenId(UnitID)  
					s TemplateID=objTemplate.TemplateId  
						
					if (TemplateID=ATemplateID) 
					{
						if (ARuleID'="") 
						{
							s EntryID=$o(^DHCEPRM.QualityEntryI("IdxPoolDR"," "_PoolID,""))
							While (EntryID'="")
							{
								s (RuleID,RuleName,StructID,StructName,Score,Sequence,IsMultiErr,IsVeto,IsActive,ResumeText,VetoGrade)=$C(0)
								s objEntry=##Class(EPRmeta.Quality.QualityEntry).%OpenId(EntryID)
								s RuleID=objEntry.RuleDR //$list($g(^DHCEPRM.QualityEntryD(EntryID)),2)
								if (+RuleID=+ARuleID) {	d SetOutPutFields }
								s objEntry=""
								s EntryID=$o(^DHCEPRM.QualityEntryI("IdxPoolDR"," "_PoolID,EntryID))
							}
						} 
						else 
						{
							s EntryID=$o(^DHCEPRM.QualityEntryI("IdxPoolDR"," "_PoolID,""))
							if (EntryID'="") 
							{
								While (EntryID'="")
								{
									s (RuleID,RuleName,StructID,StructName,Score,Sequence,IsMultiErr,IsVeto,IsActive,ResumeText)=$C(0)
									s objEntry=##Class(EPRmeta.Quality.QualityEntry).%OpenId(EntryID)
									s RuleID=objEntry.RuleDR  									
									d SetOutPutFields
									s objEntry=""
									s EntryID=$o(^DHCEPRM.QualityEntryI("IdxPoolDR"," "_PoolID,EntryID))
								}
							} 
							else 
							{
								s EntryID=$C(0)
								d SetOutputRow2
							}	
						}
					}
					s objTemplate=""
				} 
				else 
				{
					if (ARuleID'="") 
					{
						s EntryID=$o(^DHCEPRM.QualityEntryI("IdxPoolDR"," "_PoolID,""))
						While (EntryID'="")
						{
							s (RuleID,RuleName,StructID,StructName,Score,Sequence,IsMultiErr,IsVeto,IsActive,ResumeText,DescScore)=$C(0)
							s objEntry=##Class(EPRmeta.Quality.QualityEntry).%OpenId(EntryID)
							s RuleID=objEntry.RuleDR  
							if (+RuleID=+ARuleID) { d SetOutPutFields }
							s objEntry=""
							s EntryID=$o(^DHCEPRM.QualityEntryI("IdxPoolDR"," "_PoolID,EntryID))
						}
					} 
					else 
					{
						s EntryID=$o(^DHCEPRM.QualityEntryI("IdxPoolDR"," "_PoolID,""))
						if (EntryID'="") 
						{
							While (EntryID'="")
							{
								s (RuleID,RuleName,StructID,StructName,Score,Sequence,IsMultiErr,IsVeto,IsActive,ResumeText,DescScore)=$C(0)
								s objEntry=##Class(EPRmeta.Quality.QualityEntry).%OpenId(EntryID)
							    s RuleID=objEntry.RuleDR  //$list($g(^DHCEPRM.QualityEntryD(EntryID)),2)						
				                d SetOutPutFields
								s objEntry=""
								s EntryID=$o(^DHCEPRM.QualityEntryI("IdxPoolDR"," "_PoolID,EntryID))
							}
						} 
						else 
						{
							s (EntryID,RuleID,RuleName,Score,Sequence,IsMultiErr,IsVeto,IsActive,DescScore)=$C(0)
							d SetOutputRow2
						}	
					}
				}
			}
		} 
		else 
		{
			s EntryID=$o(^DHCEPRM.QualityEntryI("IdxPoolDR"," "_PoolID,""))
			if (EntryID'="") 
			{
				While (EntryID'="")
				{
					s (RuleID,RuleName,StructID,StructName,Score,Sequence,IsMultiErr,IsVeto,IsActive,ResumeText,DescScore)=$C(0)
					
					s objEntry=##Class(EPRmeta.Quality.QualityEntry).%OpenId(EntryID)
					s RuleID=objEntry.RuleDR  						
                    d SetOutPutFields
					s objEntry=""
					s EntryID=$o(^DHCEPRM.QualityEntryI("IdxPoolDR"," "_PoolID,EntryID))
				}
			} 
			else 
			{
				s (EntryID,RuleID,RuleName,Score,Sequence,IsMultiErr,IsVeto,IsActive,DescScore)=$C(0)
				d SetOutputRow2
			}	
		}
		s PoolID=$o(^DHCEPRM.QualityPoolI("IdxType",AType,PoolID))	
	}
	q $$$OK
SetOutPutFields
    s StructID=objEntry.StructDR
	//根据策略显示分数等级
	s objResult = ##Class(EPRservice.Quality.OperationLogic.EvaluationResult).CreateInstance()
	s Score = objEntry.Score
	s DescScore = objResult.GetEvaluationValue(Score)
	d objResult.%Close()
	s objResult = ""
	s Sequence=objEntry.Sequence
    s IsMultiErr=objEntry.IsMultiErr
    s IsVeto=objEntry.IsVeto
    s IsActive=objEntry.IsActive
    s ResumeText=objEntry.ResumeText
    s VetoGrade=objEntry.VetoGrade 
    s CondtionID = $case(objEntry.ChkConditionDR," ":0,"":0,$c(0):0,:objEntry.ChkConditionDR) //预警条件
    s EntryConditionID = $case(objEntry.EntryConditionDR,"":0," ":0,$c(0):0,:objEntry.EntryConditionDR) //执行条目条件
    s objRule=##Class(EPRmeta.Quality.QualityRule).%OpenId(+RuleID)
    s RuleName=objRule.Name   
	s objRule=""
    s objStruct=##Class(EPRmeta.Quality.QualityStruct).%OpenId(StructID)
    s StructName =""
    if (objStruct'="")
    {
	    s StructName=objStruct.StandardName
    }
	s objStruct=""
    d SetOutputRow2
    q
    
SetOutputRow2
	s Data=$lb(PoolID,Code,Title,Expression,RuleID,RuleName,StructID,StructName,EntryID,Score,Sequence,IsMultiErr,IsVeto,IsActive,ResumeText,VetoGrade,CondtionID,DescScore,IsQuery,EntryConditionID)
	s ^CacheTempDHCEPRQualityPool(AUniqueGlobalID,ind)=Data
	s ind=ind+1
	q
}

/// w ##Class(EPRmeta.Quality.QualityPool).IsPoolExist("E10","52")
ClassMethod IsPoolExist(APoolID As %String, AStructID As %String)
{
	s ret = 0
	q:(APoolID = "")||(AStructID = "") ret
	
	if (APoolID [ "E") 
	{
		s UnitID = $ZSTRIP(APoolID,"*A")
		
		s objUnit = $g(^DHCEPRM.QualityTemplateD(UnitID))
		q:(objUnit = "") ret
		
		s TemplateID = $list(objUnit,1)
		q:(TemplateID = "") ret
		
		s objTemplate = $g(^DHCEPRM.TemplateD(TemplateID))
		q:(objTemplate = "") ret
		
		s TemplateCategoryID = $list(objTemplate,7)
		q:(TemplateCategoryID = "") ret
		
		s StructID = $o(^DHCEPRM.QualityStructI("IdxCategoryId"," "_TemplateCategoryID,""))
		q:(StructID = "") ret
		
		s flag = ..CheckSubStruct(StructID, AStructID)
		s ret = flag
	} 
	else 
	{
		s EntryID = $o(^DHCEPRM.QualityEntryI("IdxPoolDR"," "_APoolID,""))
		if (EntryID '= "") 
		{
			While (EntryID '= "")
			{
				s objEntry = $g(^DHCEPRM.QualityEntryD(EntryID))
				q:(objEntry = "")
				
				s StructID = $list(objEntry,3)
				q:(StructID = "")
				
				s flag = ..CheckSubStruct(StructID, AStructID)
				if (flag = 1) 
				{
					s ret = 1
					q	
				}
				s EntryID = $o(^DHCEPRM.QualityEntryI("IdxPoolDR"," "_APoolID,EntryID))
			}
		} 
		else 
		{
			s ret = 1		
		}
	}
	
	q ret
}

/// Debug:	w ##Class(EPRmeta.Quality.QualityPool).IsEntryExist("10","52")
ClassMethod IsEntryExist(AEntryID As %String, AStructID As %String)
{
	s ret = 0
	q:($d(AEntryID) = 0)||($d(AStructID) = 0) ret
	q:(AEntryID = "")||(AStructID = "") ret
	
	s objEntry = $g(^DHCEPRM.QualityEntryD(AEntryID))
	q:(objEntry = "") ret
	
	s StructID = $list(objEntry,3)
	q:(StructID = "") ret
	
	s ret = ..CheckSubStruct(StructID, AStructID)
	q ret
}

/// Debug:	w ##Class(EPRmeta.Quality.QualityPool).CheckSubStruct("10","10")
ClassMethod CheckSubStruct(AStructID As %String, AParentStructID As %String)
{
	s ret = 0
	q:($d(AStructID) = 0)||($d(AParentStructID) = 0) ret
	q:(AStructID = "")||(AParentStructID = "") ret
	
	if (AStructID = AParentStructID) 
	{
		s ret = 1
	} 
	else 
	{
		s flag = 0
		s StructID = ""
		for {
			s StructID = $o(^DHCEPRM.QualityStructI("IdxParentId"," "_AParentStructID,StructID))
			q:(StructID = "")
			
			if (StructID '= AStructID) 
			{
				// Recursive invoke
				s flag = ..CheckSubStruct(AStructID,StructID)
				q:(flag = 1)
			} 
			else 
			{
				s flag = 1
				q	
			}	
		}
		s ret = flag	
	}
	
	q ret
}

/// Debug:	w ##Class(EPRmeta.Quality.QualityPool).GetTitleByPoolID("U001")
ClassMethod GetTitleByPoolID(APoolID As %String) As %String
{
	s ret = ""
	q:($d(APoolID) = 0)||(APoolID = "") ret
	
	s Type = $e(APoolID,1)
	if ($zcvt(Type,"U") = "E") 
	{
		s UnitID = $ZSTRIP(APoolID,"*A")
		s objTemplate=##Class(EPRmeta.Quality.QualityTemplate).%OpenId(UnitID)
		s Title = objTemplate.SimpleName // $list($g(^DHCEPRM.QualityTemplateD(UnitID)),4)
		s objTemplate=""
	} 
	else 
	{
		s objPool=##Class(EPRmeta.Quality.QualityPool).%OpenId(APoolID)
		s Title = objPool.Title  //$list($g(^DHCEPRM.QualityPoolD(APoolID)),2)
		s objPool=""
	}
	s ret = Title
	q ret
}

/// **************************************************
/// 描述：判断质控规则的Code是否唯一
/// 结论：ret=0代表唯一，其它代表不唯一
/// 调试：w ##Class(EPRmeta.Quality.QualityPool).CheckCodeUnique("E1")
/// **************************************************
ClassMethod CheckCodeUnique(ACode As %String) As %Integer
{
	s ret = 0
 	&sql(SELECT COUNT(Code) INTO:ret FROM EPRmeta_Quality.QualityPool WHERE Code = :ACode)
 	q ret
}

/// debug: w ##class(EPRmeta.Quality.QualityPool).InsertSomeTestPools("S",149,5,"首页--门（急）诊诊断填写不正确（0.5）","1","Y","U","1")
ClassMethod InsertSomeTestPools(FCode, StartIndex, Nums, Title, Expression, IsActive, Type, ResumeText)
{
	s ret="fail"
	
	///获取最新的手工评分Code
	
	s num=0
	for i=StartIndex:1:StartIndex+Nums
	{
		s Code=FCode_i
		
		&sql(INSERT INTO EPRmeta_Quality.QualityPool(Code, Title, Expression, IsActive, Type, ResumeText)
			VALUES (:Code, :Title, :Expression, :IsActive, :Type, :ResumeText) )
		s num=num+1
		
	}
	
	s:(num=Nums) ret="successful"
	
	q ret
}

Storage Default
{
<Data name="QualityPoolDefaultData">
<Value name="1">
<Value>Code</Value>
</Value>
<Value name="2">
<Value>Title</Value>
</Value>
<Value name="3">
<Value>Expression</Value>
</Value>
<Value name="4">
<Value>IsActive</Value>
</Value>
<Value name="5">
<Value>Type</Value>
</Value>
<Value name="6">
<Value>ResumeText</Value>
</Value>
<Value name="7">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="8">
<Value>IsQuery</Value>
</Value>
<Value name="9">
<Value>HISCode</Value>
</Value>
<Value name="10">
<Value>EMRCode</Value>
</Value>
</Data>
<DataLocation>^DHCEPRM.QualityPoolD</DataLocation>
<DefaultData>QualityPoolDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEPRM.QualityPoolD</IdLocation>
<IndexLocation>^DHCEPRM.QualityPoolI</IndexLocation>
<StreamLocation>^DHCEPRM.QualityPoolS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
