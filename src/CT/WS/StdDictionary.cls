/// CT.WS.StdDictionary
/// 描述:自定义字典定义表
/// 编写者:yejian
/// 编写日期:2013-4-23
Class CT.WS.StdDictionary Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Index IdxStdDictionaryID On TableName;

/// 字典编码
Property Code As %String(TRUNCATE = 1);

/// 字典描述
Property Description As %String(TRUNCATE = 1);

/// 字典别名列
Property DicAliasCol As %String(TRUNCATE = 1);

/// 字典代码列
Property DicCodeCol As %String(TRUNCATE = 1);

/// 字典描述列
Property DicDescCol As %String(TRUNCATE = 1);

/// 字典名称
Property Name As %String(TRUNCATE = 1);

/// 字典表名
Property TableName As %String(MAXLEN = 100, TRUNCATE = 1);

/// 默认查询条件编码
Property ConditionCode As %String(TRUNCATE = 1);

/// 默认查询条件内容
Property Condition As %String(MAXLEN = 1000, TRUNCATE = 1);

/// 系统编码
Property SystemCode As %String(TRUNCATE = 1);

/// 顺序号为排序
Property Sequence As %Integer;

ClassMethod CheckCodeUnique(ACode As %String) As %Integer
{
 new Result
 &sql(SELECT Count(Code)
 into :Result 
 FROM CT_WS.StdDictionary
 WHERE Code = :ACode)
 if Result=""
 {s Result=0 }
 QUIT Result
}

ClassMethod CheckUpdateCodeUnique(AID As %String, ACode As %String) As %Integer
{
 //B "S"
 new Result
 new OldID 
 &sql(SELECT Count(Code)
 into :Result 
 FROM CT_WS.StdDictionary
 WHERE Code = :ACode)
 if ((Result="")!(Result=0))
 {
 s Result=0
 }
 elseif '(Result=0) 
 {
 &sql(SELECT ID
 into :OldID
 FROM CT_WS.StdDictionary
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

ClassMethod GetStdDicListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetStdDicListExecute ]
{
 s qHandle="" 
 Quit $$$OK
}

ClassMethod GetStdDicOrListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetStdDicOrListExecute ]
{
 s qHandle="" 
 Quit $$$OK
}

ClassMethod GetStdDicOrListExecute(ByRef qHandle As %Binary, ADicCode As %String, AItem As %String, APageNum As %Integer, ARowCount As %Integer, ASessionId As %String) As %Status
{
 s qHandle="1" 
 s SQLCODE=0 
 //s %ROWID=0 
 s %counter=0
 s ID=""
 S %ResultID=""
 s ^AA("baaa")=ASessionId
 //S ^CacheTempStdQuery($J)="True"	 
 if ($D(^CacheTempStdQuery(ASessionId)))
 {
	
	if ($G(^CacheTempStdQuery(ASessionId))="True") 
	{
   Set StartPageID= (APageNum-1)*ARowCount
   s ^AA("BBB")=StartPageID
   Set LastPageId = APageNum*ARowCount
   Set PageNumCounter = 0 
   s ^AA("ccc")=LastPageId
	 set PageKey= $O(^CacheTempStdQuery(ASessionId,""))
	 s ^AA("iii")=PageKey
	 While (PageKey '="")
	 {
	   s PageNumCounter = PageNumCounter + 1
	   if (PageNumCounter> StartPageID)&(PageNumCounter <= LastPageId)
	   { 
	    s ^AA("qqq")=PageNumCounter _"@@@"_PageKey
	    Set %ResultID(PageNumCounter-StartPageID)= $G(^CacheTempStdQuery(ASessionId,PageKey))	 
	   }
		
	   set PageKey= $O(^CacheTempStdQuery(ASessionId,PageKey)) 	
		 }
	 	 ;s ^gjbtest("ASessionId",ASessionId)=""
	 	 s qHandle=%ResultID
     Quit $$$OK
		}
	}
}

ClassMethod GetStdDicListExecute(ByRef qHandle As %Binary, ADicCode As %String, AAias As %String, ACode As %String, ADesc As %String, APageNum As %Integer, ARowCount As %Integer) As %Status
{
 s qHandle="1" 
 s SQLCODE=0 
 //s %ROWID=0 
 s %counter=0
 s ID=""
 S %ResultID=""
 s ^testst = ADicCode_","_ AAias_","_ ACode_","_ ADesc_","_ APageNum_","_ ARowCount

 set result = ##class(%Library.ResultSet).%New()
 Set SqlString ="Select Name,TableName,DicAliasCol,DicCodeCol,DicDescCol From CT_WS.StdDictionary "
 Set SqlWhereString =""
 if (ADicCode '="")
 {
 set TempCode= ADicCode //##class(CT_WS.StdDictionary).ReplaceAsterisk(ADicCode)
 set SqlWhereString = "Where CT_WS.StdDictionary.Code Like '"_TempCode_"'" 
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

 set DescBiteoffFlag= ##Class(EPRmeta.SysOption).CheckMinusFieldExist(DicTableName,DicDesc)

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
 Set GetDatasetSql = GetDatasetSql_AFieldSql_ " From "_##class(CT.WS.StdDictionary).SwitchFromTable(DicTableName)
 //Set GetDatasetSql = GetDatasetSql_AFieldSql_ " From "_DicTableName

 Set GetWhereSql =""

 if ((DicAlias'="")&&(DicAlias'=$C(0)))
 { if (AAias '="")&&(AAias'=$C(0))
	    {
		  set TempAias =$ZCVT(##class(CT.WS.StdDictionary).ReplaceAsterisk(AAias),"U")
		  
		  Set GetWhereSql =" Where UPPER("_DicAlias_") Like '"_TempAias_"' "
	    }
	}

 if ((DicCode'="")&&(DicCode'=$C(0)))
 {  
 if ((ACode '="")&&(ACode '=$C(0)))
	    {
		  set TempDicCode = $ZCVT(##class(CT.WS.StdDictionary).ReplaceAsterisk(ACode),"U")
		  
		  if (GetWhereSql= "")
		  {
			 Set GetWhereSql =" Where UPPER("_DicCode_") Like '"_TempDicCode_"' "
		  } 
		  elseif (GetWhereSql'="")
		  {
			Set GetWhereSql = GetWhereSql _" And  UPPER("_DicCode_") Like '"_TempDicCode_"' "  
		   }
	    }
	}

 if ((DicDesc'="")&&(DicDesc'=$C(0)))
 {  
 if ((ADesc '="")&&(ADesc '=$C(0)))
	    {
		  set TempDesc =$ZCVT(##class(CT.WS.StdDictionary).ReplaceAsterisk(ADesc),"U")
		  
		  if (GetWhereSql= "")
		  {
			 Set GetWhereSql =" Where UPPER("_DicDesc_") Like '"_TempDesc_"' "
		  } 
		  elseif (GetWhereSql'="")
		  {
			Set GetWhereSql = GetWhereSql _" And  UPPER("_DicDesc_") Like '"_TempDesc_"' "  
		   }
	    }
	}

 s ^AAStd("GetWhereSql")=GetWhereSql
 if (GetWhereSql '="")
 {
	 //add for PinYin query
 s GetWhereSql=##class(CT.WS.StdDictionary).SwitchWhere(DicTableName,GetWhereSql)

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
 		s GetWhereSql=##class(CT.WS.StdDictionary).SwitchWhere(DicTableName,GetWhereSql)
	 	set GetDatasetSql = GetDatasetSql_GetWhereSql
	 	//
		set GetDatasetSql = GetDatasetSql_" Order By "_DicCode
	  } 
	 }

 s ^AAStd("GetDatasetSql")=GetDatasetSql
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
	b
	set Row=%ResultID(%counter)
	}

 Quit $$$OK
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

/// 重写 SelectNewStdDicPageCount, 若字典单元查询不出记录，请用一下注释内容替换上面的 SelectNewStdDicPageCount 方法
/// For P8
ClassMethod SelectNewStdDicPageCount(ADicCode As %String, AConditon As %String, APageNum As %Integer, ARowCount As %Integer, ASessionId As %String, ADefaultConditionCode As %String = "", ADefaultCondition As %String = "") As %Integer
{
 //b "s"
 //s ^CacheTempDHCEPRDebug("CT.WS.StdDictionary.SelecNewStdDicPageCount","Input")=ADicCode_"^"_AConditon_"^"_APageNum_"^"_ARowCount_"^"_ASessionId
 
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
 set isKeepMinus = ##Class(EPRmeta.SysOption).CheckMinusFieldExist(DicTableName,DicDesc)
 
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
 
 //查询字典内容
 if (ADefaultConditionCode '= "")&&(ADefaultConditionCode '= $C(0))
 {
	 s totRowCount = ..SelectStdDicWithDefaultCond(DicTableName, AConditon, DicAlias, DicCode, DicDesc, ASessionId, hasGB, isKeepMinus, ADefaultConditionCode, ADefaultCondition)
 }
 else
 {
	 s totRowCount = ..SelectStdDicWithoutDefaultCond(DicTableName, AConditon, DicAlias, DicCode, DicDesc, ASessionId, hasGB, isKeepMinus)
 }
 
 s ^CacheTempStdQueryCount(ASessionId,"StdQueryDataCount")=totRowCount	
 s ^CacheTempStdQuery(ASessionId)="True"
 
 s returnPageCount = totRowCount\ARowCount
 s modulo = totRowCount#ARowCount
 if modulo'=0
 { 	s returnPageCount = returnPageCount + 1}  
 	
 q returnPageCount
}

/// Desc:	取字典信息
ClassMethod GetDicInfo(ADicCode As %String) As %ArrayOfDataTypes
{
	s dicInfo = ""
	
 	s dicID = "", dicTableName = "", dicAliasCol = "", dicCodeCol = "", dicDescCol = ""
 	&sql(select top 1 ID, TableName, DicAliasCol, DicCodeCol, DicDescCol
 		into :dicID, :dicTableName, :dicAliasCol, :dicCodeCol, :dicDescCol 
 		from CT_WS.StdDictionary where CT_WS.StdDictionary.Code = :ADicCode)
 	
 	q:(dicID = "")||(dicID = $c(0)) dicInfo
 
	
	s dicInfo = ##Class(%ArrayOfDataTypes).%New()
	d dicInfo.SetAt(dicTableName,"TableName")
	d dicInfo.SetAt(dicAliasCol,"DicAliasCol") 
	d dicInfo.SetAt(dicCodeCol,"DicCodeCol") 
	d dicInfo.SetAt(dicDescCol,"DicDescCol") 
	
	q dicInfo
}

/// Desc:	处理带有默认查询条件的字典
ClassMethod SelectStdDicWithDefaultCond(ADicTableName As %String, AConditon As %String, ADicAliasCol As %String, ADicCodeCol As %String, ADicDescCol As %String, ASessionId As %String, AHasGB As %String, AIsKeepMinus As %String, ADefaultConditionCode As %String = "", ADefaultCondition As %String = "") As %Integer
{
	s totRowCount = 0
	
	if ($zcvt(ADicTableName,"U") = "SQLUSER.SS_USER")&&(ADefaultConditionCode = "S001")
	{
		s totRowCount = ..SelectStdDic001(AConditon, ADicAliasCol, ADicCodeCol, ADicDescCol, ASessionId, AHasGB, AIsKeepMinus, ADefaultCondition)
	}
	elseif ($zcvt(ADicTableName,"U") = "SQLUSER.SS_USER")&&(ADefaultConditionCode = "S002")
	{
		s totRowCount = ..SelectStdDic002(AConditon, ADicAliasCol, ADicCodeCol, ADicDescCol, ASessionId, AHasGB, AIsKeepMinus, ADefaultCondition)
	}
	elseif ($zcvt(ADicTableName,"U") = "SQLUSER.SS_USER")&&(ADefaultConditionCode = "S003")
	{
		s totRowCount = ..SelectStdDic003(AConditon, ADicAliasCol, ADicCodeCol, ADicDescCol, ASessionId, AHasGB, AIsKeepMinus, ADefaultCondition)
	}
	elseif ($zcvt(ADicTableName,"U") = "EPRVIEW.OPERATION")&&(ADefaultConditionCode = "C001")
	{
		s totRowCount = ..SelectStdDic004(AConditon, ADicAliasCol, ADicCodeCol, ADicDescCol, ASessionId, AHasGB, AIsKeepMinus, ADefaultCondition)
	}
	elseif ($zcvt(ADicTableName,"U") = "EPRVIEW.OPERATIONCUTSITE")&&(ADefaultConditionCode = "C002")
	{
		s totRowCount = ..SelectStdDic005(AConditon, ADicAliasCol, ADicCodeCol, ADicDescCol, ASessionId, AHasGB, AIsKeepMinus, ADefaultCondition)
	}
	
	q totRowCount
}

/// Desc:	处理没有默认查询条件的字典
ClassMethod SelectStdDicWithoutDefaultCond(ADicTableName As %String, AConditon As %String, ADicAliasCol As %String, ADicCodeCol As %String, ADicDescCol As %String, ASessionId As %String, AHasGB As %String, AIsKeepMinus As %String) As %Integer
{
	s totRowCount = 0
	
	if ($zcvt(ADicTableName,"U")="SQLUSER.MRC_ICDDX")
	{
		s totRowCount = ..SelectStdDicMRCICDDx(AConditon, ADicAliasCol, ADicCodeCol, ADicDescCol, ASessionId, AHasGB, AIsKeepMinus)
	}
	elseif ($zcvt(ADicTableName,"U")="SQLUSER.MRC_ICDDXXY")
	{
		s totRowCount = ..SelectStdDicMRCICDDxXY(AConditon, ADicAliasCol, ADicCodeCol, ADicDescCol, ASessionId, AHasGB, AIsKeepMinus)
	}
	elseif ($zcvt(ADicTableName,"U")="SQLUSER.MRC_ICDDXZY")
	{
	 	s totRowCount = ..SelectStdDicMRCICDDxZY(AConditon, ADicAliasCol, ADicCodeCol, ADicDescCol, ASessionId, AHasGB, AIsKeepMinus)
	}
	elseif ($zcvt(ADicTableName,"U")="SQLUSER.CT_LOC")
 	{
	 	s totRowCount = ..SelectStdDicCTLoc(AConditon, ADicAliasCol, ADicCodeCol, ADicDescCol, ASessionId, AHasGB, AIsKeepMinus)
	}
	elseif ($zcvt(ADicTableName,"U")="SQLUSER.CT_NATION")
	{
		s totRowCount = ..SelectStdDicCTNation(AConditon, ADicAliasCol, ADicCodeCol, ADicDescCol, ASessionId, AHasGB, AIsKeepMinus)
	}
	elseif ($zcvt(ADicTableName,"U")="SQLUSER.SS_USER")
	{
		s totRowCount = ..SelectStdDicSSUser(AConditon, ADicAliasCol, ADicCodeCol, ADicDescCol, ASessionId, AHasGB, AIsKeepMinus)
	}
	elseif ($zcvt(ADicTableName,"U")="SQLUSER.PAC_WARD")
	{
		s totRowCount = ..SelectStdDicPACWard(AConditon, ADicAliasCol, ADicCodeCol, ADicDescCol, ASessionId, AHasGB, AIsKeepMinus)
	}
	elseif ($zcvt(ADicTableName,"U")="SQLUSER.PHC_DRGMAST")
	{
		s totRowCount = ..SelectStdDicPHCDrgMast(AConditon, ADicAliasCol, ADicCodeCol, ADicDescCol, ASessionId, AHasGB, AIsKeepMinus)
	}
	elseif ($zcvt(ADicTableName,"U")="SQLUSER.CT_OCCUPATION")
	{
	 	s totRowCount = ..SelectStdDicCTOccupation(AConditon, ADicAliasCol, ADicCodeCol, ADicDescCol, ASessionId, AHasGB, AIsKeepMinus)
	}
	elseif ($zcvt(ADicTableName,"U")="SQLUSER.CT_COUNTRY")
	{
		s totRowCount = ..SelectStdDicCTCountry(AConditon, ADicAliasCol, ADicCodeCol, ADicDescCol, ASessionId, AHasGB, AIsKeepMinus)
	}
	elseif ($zcvt(ADicTableName,"U")="SQLUSER.CT_PROVINCE")
	{
		s totRowCount = ..SelectStdDicCTProvince(AConditon, ADicAliasCol, ADicCodeCol, ADicDescCol, ASessionId, AHasGB, AIsKeepMinus)
	}
	elseif ($zcvt(ADicTableName,"U")="SQLUSER.CT_CITY")
	{
		s totRowCount = ..SelectStdDicCTCity(AConditon, ADicAliasCol, ADicCodeCol, ADicDescCol, ASessionId, AHasGB, AIsKeepMinus)
	}
	elseif ($zcvt(ADicTableName,"U")="SQLUSER.CT_SEX")
	{
		s totRowCount = ..SelectStdDicCTSex(AConditon, ADicAliasCol, ADicCodeCol, ADicDescCol, ASessionId, AHasGB, AIsKeepMinus)
	}
	elseif ($zcvt(ADicTableName,"U")="SQLUSER.PAC_PATIENTCATEGORY")
	{
		s totRowCount = ..SelectStdDicPACPatientCategory(AConditon, ADicAliasCol, ADicCodeCol, ADicDescCol, ASessionId, AHasGB, AIsKeepMinus)
	}
	elseif ($zcvt(ADicTableName,"U")="SQLUSER.CT_ZIP")
	{
		s totRowCount = ..SelectStdDicCTZip(AConditon, ADicAliasCol, ADicCodeCol, ADicDescCol, ASessionId, AHasGB, AIsKeepMinus)
	}
	elseif ($zcvt(ADicTableName,"U")="SQLUSER.ORC_OPERATION")
	{
		s totRowCount = ..SelectStdDicORCOperation(AConditon, ADicAliasCol, ADicCodeCol, ADicDescCol, ASessionId, AHasGB, AIsKeepMinus)
	}
	elseif ($zcvt(ADicTableName,"U")="SQLUSER.CT_RELATION")
	{
		s totRowCount = ..SelectStdDicCTReleation(AConditon, ADicAliasCol, ADicCodeCol, ADicDescCol, ASessionId, AHasGB, AIsKeepMinus)
	}
	elseif ($zcvt(ADicTableName,"U")="EPRVIEW.PATTYPE") //$zcvt(ADicTableName,"U")="SQLUSER.DHCEPRVPATTYPE")
	{
		s totRowCount = ..SelectStdDicDHCEPRVPatType(AConditon, ADicAliasCol, ADicCodeCol, ADicDescCol, ASessionId, AHasGB, AIsKeepMinus)
	}
	elseif ($zcvt(ADicTableName,"U")="SQLUSER.ORC_ANAESTMETHOD")
	{
		s totRowCount = ..SelectStdDicORCAnaestMethod(AConditon, ADicAliasCol, ADicCodeCol, ADicDescCol, ASessionId, AHasGB, AIsKeepMinus)
	}
	elseif ($zcvt(ADicTableName,"U")="EPRVIEW.OPERATION")
	{
		s totRowCount = ..SelectStdDicEPRviewOperation(AConditon, ADicAliasCol, ADicCodeCol, ADicDescCol, ASessionId, AHasGB, AIsKeepMinus)
	}
	elseif ($zcvt(ADicTableName,"U")="SQLUSER.MRC_ICDDX_DIAGNOSIS")
	{
		//诊断 groupDR = "1"
		s totRowCount = ..SelectStdDicMRCICDDxDiag(AConditon, ADicAliasCol, ADicCodeCol, ADicDescCol, ASessionId, AHasGB, AIsKeepMinus)
	}
	elseif ($zcvt(ADicTableName,"U")="SQLUSER.MRC_ICDDX_INJURG")
	{
		//损伤 groupDR = "4"
		s totRowCount = ..SelectStdDicMRCICDDxInjury(AConditon, ADicAliasCol, ADicCodeCol, ADicDescCol, ASessionId, AHasGB, AIsKeepMinus)
	}
	elseif ($zcvt(ADicTableName,"U")="SQLUSER.MRC_ICDDX_MORPHOLOGY")
	{
		//肿瘤形态学 groupDR = "2"
		s totRowCount = ..SelectStdDicMRCICDDxMorphology(AConditon, ADicAliasCol, ADicCodeCol, ADicDescCol, ASessionId, AHasGB, AIsKeepMinus)
	}
	elseif ($zcvt(ADicTableName,"U")="SQLUSER.MRC_ICDDX_OPERATION")
	{
		//手术 groupDR = "3"
		s totRowCount = ..SelectStdDicMRCICDDxOperation(AConditon, ADicAliasCol, ADicCodeCol, ADicDescCol, ASessionId, AHasGB, AIsKeepMinus)
	}
	elseif ($zcvt(ADicTableName,"U")="SQLUSER.MRC_ICDDX_ALLERGY")
	{
		//过敏 groupDR = "5"
		s totRowCount = ..SelectStdDicMRCICDDxAllergy(AConditon, ADicAliasCol, ADicCodeCol, ADicDescCol, ASessionId, AHasGB, AIsKeepMinus)
	}
	elseif ($zcvt(ADicTableName,"U")= "MRC_DIAGNOSSIGNSYMPTOM")||(($zcvt(ADicTableName,"U")= "SQLUSER.MRC_DIAGNOSSIGNSYMPTOM"))
	{
		//中医症型字典
		s totRowCount = ..SelectStdDicDiagnosSignSymptom(AConditon, ADicAliasCol, ADicCodeCol, ADicDescCol, ASessionId, AHasGB, AIsKeepMinus)
	}
	elseif ($zcvt(ADicTableName,"U")="SQLUSER.MRC_ICDDXINJURYPOISON")
	{
		//[HIS]ICD10损伤中毒外部因素字典 2012-02-03 wangwentao add
	 	s totRowCount = ..SelectStdMRCICDDxInjuryPoison(AConditon, ADicAliasCol, ADicCodeCol, ADicDescCol, ASessionId, AHasGB, AIsKeepMinus)
	}
	elseif ($zcvt(ADicTableName,"U")="SQLUSER.MRC_ICDDXPATHOLOGY")
	{
		//[HIS]ICD10病理诊断字典 2012-02-03 wangwentao add
	 	s totRowCount = ..SelectStdMRCICDDxPathology(AConditon, ADicAliasCol, ADicCodeCol, ADicDescCol, ASessionId, AHasGB, AIsKeepMinus)
	}
	elseif ($zcvt(ADicTableName,"U")="SQLUSER.MRC_ICDDXMEDALLERGY")
	{
		//[HIS]ICD10过敏类别字典 2012-02-03 wangwentao add
	 	s totRowCount = ..SelectStdMRCICDDxMedAllergy(AConditon, ADicAliasCol, ADicCodeCol, ADicDescCol, ASessionId, AHasGB, AIsKeepMinus)
	}
	elseif ($zcvt(ADicTableName,"U")="SQLUSER.MRC_ICDDXINPATIENT")
	{
		//[HIS]ICD10住院诊断字典 2012-02-03 wangwentao add
	 	s totRowCount = ..SelectStdMRCICDDxInpatient(AConditon, ADicAliasCol, ADicCodeCol, ADicDescCol, ASessionId, AHasGB, AIsKeepMinus)
	}
	elseif ($zcvt(ADicTableName,"U")="SQLUSER.CT_HEALTHCAREREGION")
	{
		//
		s totRowCount = ..SelectStdDicCTHealthCareRegion(AConditon, ADicAliasCol, ADicCodeCol, ADicDescCol, ASessionId, AHasGB, AIsKeepMinus)
	}
	else
	{
		//处理动态字典
		s totRowCount = ..SelectDynamicStdDic(ADicTableName, AConditon, ADicAliasCol, ADicCodeCol, ADicDescCol, ASessionId, AHasGB, AIsKeepMinus)
	}	 
		
 
 	q totRowCount
}

/// Desc:	处理动态字典
ClassMethod SelectDynamicStdDic(ADicTableName As %String, AConditon As %String, ADicAliasCol As %String, ADicCodeCol As %String, ADicDescCol As %String, ASessionId As %String, AHasGB As %String, AIsKeepMinus As %String) As %Integer
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
	s sqlTable = ##class(CT.WS.StdDictionary).SwitchFromTable(ADicTableName)
	
	// 转换查询条件
	s sqlWhere = ""
	s sqlWhere = ##class(CT.WS.StdDictionary).SwitchWhere(ADicTableName, sqlWhere)
	
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
	 		s isCodeContain = ##Class(EPRservice.Utility).CheckGBContain($ZCVT(conCodeValue,"U"),$ZCVT(AConditon,"U"))
	  		s isDescContain = ##Class(EPRservice.Utility).CheckGBContain($ZCVT(conDescValue,"U"),$ZCVT(AConditon,"U"))
	  		s isAliasContain = ##Class(EPRservice.Utility).CheckGBContain($ZCVT(conAliasValue,"U"),$ZCVT(AConditon,"U"))
	  		
	  		if (isCodeContain="True")||(isDescContain="True")||(isAliasContain="True")
			{
				s totRowCount = totRowCount + 1
				s ^CacheTempStdQuery(ASessionId, totRowCount)=$LB(totRowCount, aliasValue, codeValue, descValue)	
			}
		}
		else
		{
			s totRowCount = totRowCount  + 1
			s ^CacheTempStdQuery(ASessionId, totRowCount)=$LB(totRowCount, aliasValue, codeValue, descValue)
		}
	}
		
	q totRowCount
}

/// Create:	2008-11-27	HouJ
/// Desc:	查询【用户】字典内容：SQLUser.MRC_DiagnosSignSymptom
/// Input：	AComItem 查询条件；ADicAliasCol 别名列；ADicCodeCol 代码列；ADicDescCol 描述列；ADescHasMinius 描述列是否有横线
ClassMethod SelectStdDicDiagnosSignSymptom(AComItem As %String, ADicAliasCol As %String, ADicCodeCol As %String, ADicDescCol As %String, ASessionId As %String, AHasGB As %String, AIsKeepMinus As %String) As %Integer
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
			s CodeCom= ##Class(EPRservice.Utility).CheckContain($ZCVT(CodeValue,"U"),$ZCVT(AComItem,"U"),AHasGB)
			S DescCom= ##Class(EPRservice.Utility).CheckContain($ZCVT(DescValue,"U"),$ZCVT(AComItem,"U"),AHasGB)
			if ((ADicAliasCol '="")&&(ADicAliasCol'=$C(0)))
			{	s AliasCom= ##Class(EPRservice.Utility).CheckContain($ZCVT(AliasValue,"U"),$ZCVT(AComItem,"U"),AHasGB)}
			
			if ((CodeCom '= 1)&&(DescCom '= 1)&&(AliasCom '= 1))
			{	continue}
		}
		//s AliasValue = ""  //匹配完查询条件后将别名置空
		
		//处理满足条件的结果并存入临时global
		s totRowCount = totRowCount + 1
		if (AIsKeepMinus = "0")
		{	s DescValue = $E(DescValue,$F(DescValue,"-"),$L(DescValue)) }
		s ^CacheTempStdQuery(ASessionId,totRowCount) =$LB(totRowCount,AliasValue,CodeValue,DescValue)
	}
	
	s ^CacheTempStdQueryCount(ASessionId,"StdQueryDataCount")= totRowCount
	
	q totRowCount
}

/// Create:	2008-11-27	HouJ
/// Desc:	查询【诊断】字典内容：SQLUser.MRC_ICDDx
/// Input：	AComItem 查询条件；ADicAliasCol 别名列；ADicCodeCol 代码列；ADicDescCol 描述列；AHasGB 查询条件是否有中文字符；AIsKeepMinus 描述列是否有横线
ClassMethod SelectStdDicMRCICDDx(AComItem As %String, ADicAliasCol As %String, ADicCodeCol As %String, ADicDescCol As %String, ASessionId As %String, AHasGB As %String, AIsKeepMinus As %String) As %Integer
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
		s ICD9MapRowDR=##Class(EPRmeta.SysOption).GetOptionValueByName("ICDCodeExpand")
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
			s CodeCom= ##Class(EPRservice.Utility).CheckContain($ZCVT(CodeValue,"U"),$ZCVT(AComItem,"U"),AHasGB)
			S DescCom= ##Class(EPRservice.Utility).CheckContain($ZCVT(DescValue,"U"),$ZCVT(AComItem,"U"),AHasGB)
			if ((ADicAliasCol '="")&&(ADicAliasCol'=$C(0)))
			{	s AliasCom= ##Class(EPRservice.Utility).CheckContain($ZCVT(AliasValue,"U"),$ZCVT(AComItem,"U"),AHasGB)}
			
			if ((CodeCom '= 1)&&(DescCom '= 1)&&(AliasCom '= 1))
			{	continue}
		}
		
		//处理满足条件的结果并存入临时global
		s totRowCount = totRowCount + 1
		s AliasValue = $P(AliasValue,$C(2),1)
		if (AIsKeepMinus = "0")
		{	s DescValue = $E(DescValue,$F(DescValue,"-"),$L(DescValue)) }
		
		s ^CacheTempStdQuery(ASessionId,totRowCount) =$LB(totRowCount,AliasValue,CodeValue,DescValue)
	}
	
	s ^CacheTempStdQueryCount(ASessionId,"StdQueryDataCount")= totRowCount
	
	q totRowCount
}

/// Create:	2008-11-27	HouJ
/// Desc:	查询【诊断】字典内容：SQLUser.MRC_ICDDx
/// Input：	AComItem 查询条件；ADicAliasCol 别名列；ADicCodeCol 代码列；ADicDescCol 描述列；AHasGB 查询条件是否有中文字符；AIsKeepMinus 描述列是否有横线
ClassMethod SelectStdDicMRCICDDxZY(AComItem As %String, ADicAliasCol As %String, ADicCodeCol As %String, ADicDescCol As %String, ASessionId As %String, AHasGB As %String, AIsKeepMinus As %String) As %Integer
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
		s ICD9MapRowDR=##Class(EPRmeta.SysOption).GetOptionValueByName("ICDCodeExpand")
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
			s CodeCom= ##Class(EPRservice.Utility).CheckContain($ZCVT(CodeValue,"U"),$ZCVT(AComItem,"U"),AHasGB)
			S DescCom= ##Class(EPRservice.Utility).CheckContain($ZCVT(DescValue,"U"),$ZCVT(AComItem,"U"),AHasGB)
			if ((ADicAliasCol '="")&&(ADicAliasCol'=$C(0)))
			{	s AliasCom= ##Class(EPRservice.Utility).CheckContain($ZCVT(AliasValue,"U"),$ZCVT(AComItem,"U"),AHasGB)}
			
			if ((CodeCom '= 1)&&(DescCom '= 1)&&(AliasCom '= 1))
			{	continue}
		}
		
		//处理满足条件的结果并存入临时global
		s totRowCount = totRowCount + 1
		s AliasValue = $P(AliasValue,$C(2),1)
		if (AIsKeepMinus = "0")
		{	s DescValue = $E(DescValue,$F(DescValue,"-"),$L(DescValue)) }
		
		s ^CacheTempStdQuery(ASessionId,totRowCount) =$LB(totRowCount,AliasValue,CodeValue,DescValue)
	}
	
	s ^CacheTempStdQueryCount(ASessionId,"StdQueryDataCount")= totRowCount
	
	q totRowCount
}

/// Create:	2012-04-24	HouJ
/// Desc:	查询【诊断】字典内容：SQLUser.MRC_ICDDxXY 西医诊断
/// Input：	AComItem 查询条件；ADicAliasCol 别名列；ADicCodeCol 代码列；ADicDescCol 描述列；AHasGB 查询条件是否有中文字符；AIsKeepMinus 描述列是否有横线
ClassMethod SelectStdDicMRCICDDxXY(AComItem As %String, ADicAliasCol As %String, ADicCodeCol As %String, ADicDescCol As %String, ASessionId As %String, AHasGB As %String, AIsKeepMinus As %String) As %Integer
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
		s ICD9MapRowDR=##Class(EPRmeta.SysOption).GetOptionValueByName("ICDCodeExpand")
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
			s CodeCom= ##Class(EPRservice.Utility).CheckContain($ZCVT(CodeValue,"U"),$ZCVT(AComItem,"U"),AHasGB)
			S DescCom= ##Class(EPRservice.Utility).CheckContain($ZCVT(DescValue,"U"),$ZCVT(AComItem,"U"),AHasGB)
			if ((ADicAliasCol '="")&&(ADicAliasCol'=$C(0)))
			{	s AliasCom= ##Class(EPRservice.Utility).CheckContain($ZCVT(AliasValue,"U"),$ZCVT(AComItem,"U"),AHasGB)}
			
			if ((CodeCom '= 1)&&(DescCom '= 1)&&(AliasCom '= 1))
			{	continue}
		}
		
		//处理满足条件的结果并存入临时global
		s totRowCount = totRowCount + 1
		s AliasValue = $P(AliasValue,$C(2),1)
		if (AIsKeepMinus = "0")
		{	s DescValue = $E(DescValue,$F(DescValue,"-"),$L(DescValue)) }
		
		s ^CacheTempStdQuery(ASessionId,totRowCount) =$LB(totRowCount,AliasValue,CodeValue,DescValue)
	}
	
	s ^CacheTempStdQueryCount(ASessionId,"StdQueryDataCount")= totRowCount
	
	q totRowCount
}

/// Create:	2011-12-21	HouJ
/// Desc:	查询【诊断】字典中  [HIS]ICD10损伤中毒外部因素字典  内容：SQLUser.MRC_ICDDx
/// Input：	AComItem 查询条件；ADicAliasCol 别名列；ADicCodeCol 代码列；ADicDescCol 描述列；AHasGB 查询条件是否有中文字符；AIsKeepMinus 描述列是否有横线
ClassMethod SelectStdMRCICDDxInjuryPoison(AComItem As %String, ADicAliasCol As %String, ADicCodeCol As %String, ADicDescCol As %String, ASessionId As %String, AHasGB As %String, AIsKeepMinus As %String) As %Integer
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
		s ICD9MapRowDR=##Class(EPRmeta.SysOption).GetOptionValueByName("ICDCodeExpand")
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
			s CodeCom= ##Class(EPRservice.Utility).CheckContain($ZCVT(CodeValue,"U"),$ZCVT(AComItem,"U"),AHasGB)
			S DescCom= ##Class(EPRservice.Utility).CheckContain($ZCVT(DescValue,"U"),$ZCVT(AComItem,"U"),AHasGB)
			if ((ADicAliasCol '="")&&(ADicAliasCol'=$C(0)))
			{	s AliasCom= ##Class(EPRservice.Utility).CheckContain($ZCVT(AliasValue,"U"),$ZCVT(AComItem,"U"),AHasGB)}
			
			if ((CodeCom '= 1)&&(DescCom '= 1)&&(AliasCom '= 1))
			{	continue}
		}
		
		//处理满足条件的结果并存入临时global
		s totRowCount = totRowCount + 1
		s AliasValue = $P(AliasValue,$C(2),1)
		if (AIsKeepMinus = "0")
		{	s DescValue = $E(DescValue,$F(DescValue,"-"),$L(DescValue)) }
		
		s ^CacheTempStdQuery(ASessionId,totRowCount) =$LB(totRowCount,AliasValue,CodeValue,DescValue)
	}
	
	s ^CacheTempStdQueryCount(ASessionId,"StdQueryDataCount")= totRowCount
	
	q totRowCount
}

/// Create:	2012-02-03 Wangwt
/// Desc:	查询【诊断】字典中  [HIS]ICD10病理诊断字典  内容：SQLUser.MRC_ICDDx
/// Input：	AComItem 查询条件；ADicAliasCol 别名列；ADicCodeCol 代码列；ADicDescCol 描述列；AHasGB 查询条件是否有中文字符；AIsKeepMinus 描述列是否有横线
ClassMethod SelectStdMRCICDDxPathology(AComItem As %String, ADicAliasCol As %String, ADicCodeCol As %String, ADicDescCol As %String, ASessionId As %String, AHasGB As %String, AIsKeepMinus As %String) As %Integer
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
		continue:(($e(flagCode,1) = "V")||($e(flagCode,1) = "W")||($e(flagCode,1) = "X")||($e(flagCode,1) = "Y"))


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
		s ICD9MapRowDR=##Class(EPRmeta.SysOption).GetOptionValueByName("ICDCodeExpand")
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
			s CodeCom= ##Class(EPRservice.Utility).CheckContain($ZCVT(CodeValue,"U"),$ZCVT(AComItem,"U"),AHasGB)
			S DescCom= ##Class(EPRservice.Utility).CheckContain($ZCVT(DescValue,"U"),$ZCVT(AComItem,"U"),AHasGB)
			if ((ADicAliasCol '="")&&(ADicAliasCol'=$C(0)))
			{	s AliasCom= ##Class(EPRservice.Utility).CheckContain($ZCVT(AliasValue,"U"),$ZCVT(AComItem,"U"),AHasGB)}
			
			if ((CodeCom '= 1)&&(DescCom '= 1)&&(AliasCom '= 1))
			{	continue}
		}
		
		//处理满足条件的结果并存入临时global
		s totRowCount = totRowCount + 1
		s AliasValue = $P(AliasValue,$C(2),1)
		if (AIsKeepMinus = "0")
		{	s DescValue = $E(DescValue,$F(DescValue,"-"),$L(DescValue)) }
		
		s ^CacheTempStdQuery(ASessionId,totRowCount) =$LB(totRowCount,AliasValue,CodeValue,DescValue)
	}
	
	s ^CacheTempStdQueryCount(ASessionId,"StdQueryDataCount")= totRowCount
	
	q totRowCount
}

/// Create:	2012-02-03 Wangwt
/// Desc:	查询【诊断】字典中  [HIS]ICD10过敏类别字典  内容：SQLUser.MRC_ICDDx
/// Input：	AComItem 查询条件；ADicAliasCol 别名列；ADicCodeCol 代码列；ADicDescCol 描述列；AHasGB 查询条件是否有中文字符；AIsKeepMinus 描述列是否有横线
ClassMethod SelectStdMRCICDDxMedAllergy(AComItem As %String, ADicAliasCol As %String, ADicCodeCol As %String, ADicDescCol As %String, ASessionId As %String, AHasGB As %String, AIsKeepMinus As %String) As %Integer
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
		s ICD9MapRowDR=##Class(EPRmeta.SysOption).GetOptionValueByName("ICDCodeExpand")
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
			s CodeCom= ##Class(EPRservice.Utility).CheckContain($ZCVT(CodeValue,"U"),$ZCVT(AComItem,"U"),AHasGB)
			S DescCom= ##Class(EPRservice.Utility).CheckContain($ZCVT(DescValue,"U"),$ZCVT(AComItem,"U"),AHasGB)
			if ((ADicAliasCol '="")&&(ADicAliasCol'=$C(0)))
			{	s AliasCom= ##Class(EPRservice.Utility).CheckContain($ZCVT(AliasValue,"U"),$ZCVT(AComItem,"U"),AHasGB)}
			
			if ((CodeCom '= 1)&&(DescCom '= 1)&&(AliasCom '= 1))
			{	continue}
		}
		
		//处理满足条件的结果并存入临时global
		s totRowCount = totRowCount + 1
		s AliasValue = $P(AliasValue,$C(2),1)
		if (AIsKeepMinus = "0")
		{	s DescValue = $E(DescValue,$F(DescValue,"-"),$L(DescValue)) }
		
		s ^CacheTempStdQuery(ASessionId,totRowCount) =$LB(totRowCount,AliasValue,CodeValue,DescValue)
	}
	
	s ^CacheTempStdQueryCount(ASessionId,"StdQueryDataCount")= totRowCount
	
	q totRowCount
}

/// Create:	2012-02-03 Wangwt
/// Desc:	查询【诊断】字典中  [HIS]ICD10住院诊断字典  内容：SQLUser.MRC_ICDDx
/// Input：	AComItem 查询条件；ADicAliasCol 别名列；ADicCodeCol 代码列；ADicDescCol 描述列；AHasGB 查询条件是否有中文字符；AIsKeepMinus 描述列是否有横线
ClassMethod SelectStdMRCICDDxInpatient(AComItem As %String, ADicAliasCol As %String, ADicCodeCol As %String, ADicDescCol As %String, ASessionId As %String, AHasGB As %String, AIsKeepMinus As %String) As %Integer
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
		s ICD9MapRowDR=##Class(EPRmeta.SysOption).GetOptionValueByName("ICDCodeExpand")
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
			s CodeCom= ##Class(EPRservice.Utility).CheckContain($ZCVT(CodeValue,"U"),$ZCVT(AComItem,"U"),AHasGB)
			S DescCom= ##Class(EPRservice.Utility).CheckContain($ZCVT(DescValue,"U"),$ZCVT(AComItem,"U"),AHasGB)
			if ((ADicAliasCol '="")&&(ADicAliasCol'=$C(0)))
			{	s AliasCom= ##Class(EPRservice.Utility).CheckContain($ZCVT(AliasValue,"U"),$ZCVT(AComItem,"U"),AHasGB)}
			
			if ((CodeCom '= 1)&&(DescCom '= 1)&&(AliasCom '= 1))
			{	continue}
		}
		
		//处理满足条件的结果并存入临时global
		s totRowCount = totRowCount + 1
		s AliasValue = $P(AliasValue,$C(2),1)
		if (AIsKeepMinus = "0")
		{	s DescValue = $E(DescValue,$F(DescValue,"-"),$L(DescValue)) }
		
		s ^CacheTempStdQuery(ASessionId,totRowCount) =$LB(totRowCount,AliasValue,CodeValue,DescValue)
	}
	
	s ^CacheTempStdQueryCount(ASessionId,"StdQueryDataCount")= totRowCount
	
	q totRowCount
}

/// Desc:	获取指定分组的ICD字典项目
ClassMethod GetGroupedMRCICDDx(AComItem As %String, ADicAliasCol As %String, ADicCodeCol As %String, ADicDescCol As %String, ASessionId As %String, AHasGB As %String, AIsKeepMinus As %String, AGroupDR As %String) As %Integer
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
		s ICD9MapRowDR=##Class(EPRmeta.SysOption).GetOptionValueByName("ICDCodeExpand")
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
			s CodeCom= ##Class(EPRservice.Utility).CheckContain($ZCVT(CodeValue,"U"),$ZCVT(AComItem,"U"),AHasGB)
			S DescCom= ##Class(EPRservice.Utility).CheckContain($ZCVT(DescValue,"U"),$ZCVT(AComItem,"U"),AHasGB)
			if ((ADicAliasCol '="")&&(ADicAliasCol'=$C(0)))
			{	s AliasCom= ##Class(EPRservice.Utility).CheckContain($ZCVT(AliasValue,"U"),$ZCVT(AComItem,"U"),AHasGB)}
			
			if ((CodeCom '= 1)&&(DescCom '= 1)&&(AliasCom '= 1))
			{	continue}
		}
		
		//处理满足条件的结果并存入临时global
		s totRowCount = totRowCount + 1
		s AliasValue = $P(AliasValue,$C(2),1)
		if (AIsKeepMinus = "0")
		{	s DescValue = $E(DescValue,$F(DescValue,"-"),$L(DescValue)) }
		
		s ^CacheTempStdQuery(ASessionId,totRowCount) =$LB(totRowCount,AliasValue,CodeValue,DescValue)
	}
	
	s ^CacheTempStdQueryCount(ASessionId,"StdQueryDataCount")= totRowCount
	
	q totRowCount
}

/// Create:	2011-09-26	HouJ
/// Desc:	查询【诊断字典：SQLUser.MRC_ICDDx】内容：诊断
/// Input：	AComItem 查询条件；ADicAliasCol 别名列；ADicCodeCol 代码列；ADicDescCol 描述列；AHasGB 查询条件是否有中文字符；AIsKeepMinus 描述列是否有横线
ClassMethod SelectStdDicMRCICDDxDiag(AComItem As %String, ADicAliasCol As %String, ADicCodeCol As %String, ADicDescCol As %String, ASessionId As %String, AHasGB As %String, AIsKeepMinus As %String) As %Integer
{
	s groupDR = "1"		//诊断
	s totRowCount = ..GetGroupedMRCICDDx(AComItem, ADicAliasCol, ADicCodeCol, ADicDescCol, ASessionId, AHasGB, AIsKeepMinus, groupDR)
	q totRowCount
}

/// Create:	2011-09-26	HouJ
/// Desc:	查询【诊断字典：SQLUser.MRC_ICDDx】内容：损伤
/// Input：	AComItem 查询条件；ADicAliasCol 别名列；ADicCodeCol 代码列；ADicDescCol 描述列；AHasGB 查询条件是否有中文字符；AIsKeepMinus 描述列是否有横线
ClassMethod SelectStdDicMRCICDDxInjury(AComItem As %String, ADicAliasCol As %String, ADicCodeCol As %String, ADicDescCol As %String, ASessionId As %String, AHasGB As %String, AIsKeepMinus As %String) As %Integer
{
	s groupDR = "4"		//损伤
	s totRowCount = ..GetGroupedMRCICDDx(AComItem, ADicAliasCol, ADicCodeCol, ADicDescCol, ASessionId, AHasGB, AIsKeepMinus, groupDR)
	q totRowCount
}

/// Create:	2011-09-26	HouJ
/// Desc:	查询【诊断字典：SQLUser.MRC_ICDDx】内容：形态学
/// Input：	AComItem 查询条件；ADicAliasCol 别名列；ADicCodeCol 代码列；ADicDescCol 描述列；AHasGB 查询条件是否有中文字符；AIsKeepMinus 描述列是否有横线
ClassMethod SelectStdDicMRCICDDxMorphology(AComItem As %String, ADicAliasCol As %String, ADicCodeCol As %String, ADicDescCol As %String, ASessionId As %String, AHasGB As %String, AIsKeepMinus As %String) As %Integer
{
	s groupDR = "2"		//形态学
	s totRowCount = ..GetGroupedMRCICDDx(AComItem, ADicAliasCol, ADicCodeCol, ADicDescCol, ASessionId, AHasGB, AIsKeepMinus, groupDR)
	q totRowCount
}

/// Create:	2011-09-26	HouJ
/// Desc:	查询【诊断字典：SQLUser.MRC_ICDDx】内容：手术
/// Input：	AComItem 查询条件；ADicAliasCol 别名列；ADicCodeCol 代码列；ADicDescCol 描述列；AHasGB 查询条件是否有中文字符；AIsKeepMinus 描述列是否有横线
ClassMethod SelectStdDicMRCICDDxOperation(AComItem As %String, ADicAliasCol As %String, ADicCodeCol As %String, ADicDescCol As %String, ASessionId As %String, AHasGB As %String, AIsKeepMinus As %String) As %Integer
{
	s groupDR = "3"		//手术
	s totRowCount = ..GetGroupedMRCICDDx(AComItem, ADicAliasCol, ADicCodeCol, ADicDescCol, ASessionId, AHasGB, AIsKeepMinus, groupDR)
	q totRowCount
}

/// Create:	2012-04-01	Wangwt
/// Desc:	查询【诊断字典：SQLUser.MRC_ICDDx】内容：过敏
/// Input：	AComItem 查询条件；ADicAliasCol 别名列；ADicCodeCol 代码列；ADicDescCol 描述列；AHasGB 查询条件是否有中文字符；AIsKeepMinus 描述列是否有横线
ClassMethod SelectStdDicMRCICDDxAllergy(AComItem As %String, ADicAliasCol As %String, ADicCodeCol As %String, ADicDescCol As %String, ASessionId As %String, AHasGB As %String, AIsKeepMinus As %String) As %Integer
{
	s groupDR = "5"		//过敏
	s totRowCount = ..GetGroupedMRCICDDx(AComItem, ADicAliasCol, ADicCodeCol, ADicDescCol, ASessionId, AHasGB, AIsKeepMinus, groupDR)
	q totRowCount
}

/// Create:	2008-11-27	HouJ
/// Desc:	查询【手术】字典内容：SQLUser.ORC_Operation, SQLUser.ORC_OperationAlias
/// Input：	AComItem 查询条件；ADicAliasCol 别名列；ADicCodeCol 代码列；ADicDescCol 描述列；AHasGB 查询条件是否有中文字符；AIsKeepMinus 描述列是否有横线
ClassMethod SelectStdDicORCOperation(AComItem As %String, ADicAliasCol As %String, ADicCodeCol As %String, ADicDescCol As %String, ASessionId As %String, AHasGB As %String, AIsKeepMinus As %String) As %Integer
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
			s CodeCom= ##Class(EPRservice.Utility).CheckContain($ZCVT(CodeValue,"U"),$ZCVT(AComItem,"U"),AHasGB)
			S DescCom= ##Class(EPRservice.Utility).CheckContain($ZCVT(DescValue,"U"),$ZCVT(AComItem,"U"),AHasGB)
			if ((ADicAliasCol '="")&&(ADicAliasCol'=$C(0)))
			{	s AliasCom= ##Class(EPRservice.Utility).CheckContain($ZCVT(AliasValue,"U"),$ZCVT(AComItem,"U"),AHasGB)}
			
			if ((CodeCom '= 1)&&(DescCom '= 1)&&(AliasCom '= 1))
			{	continue}
		}
		
		//处理满足条件的结果并存入临时global
		s totRowCount = totRowCount + 1
		s AliasValue = $P(AliasValue,$C(2),1)
		if (AIsKeepMinus = "0")
		{	s DescValue = $E(DescValue,$F(DescValue,"-"),$L(DescValue)) }
		
		s ^CacheTempStdQuery(ASessionId,totRowCount) =$LB(totRowCount,AliasValue,CodeValue,DescValue)
	}
	
	s ^CacheTempStdQueryCount(ASessionId,"StdQueryDataCount")= totRowCount
	
	q totRowCount
}

/// Create:	2008-11-27	HouJ
/// Desc:	查询【用户】字典内容：SQLUser.SS_User
/// Input：	AComItem 查询条件；ADicAliasCol 别名列；ADicCodeCol 代码列；ADicDescCol 描述列；ADescHasMinius 描述列是否有横线
ClassMethod SelectStdDicSSUser(AComItem As %String, ADicAliasCol As %String, ADicCodeCol As %String, ADicDescCol As %String, ASessionId As %String, AHasGB As %String, AIsKeepMinus As %String) As %Integer
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
			
			s CodeCom= ##Class(EPRservice.Utility).CheckContain($ZCVT(CodeValue,"U"),$ZCVT(AComItem,"U"),AHasGB)
			S DescCom= ##Class(EPRservice.Utility).CheckContain($ZCVT(DescValue,"U"),$ZCVT(AComItem,"U"),AHasGB)
			if ((ADicAliasCol '="")&&(ADicAliasCol'=$C(0)))
			{	s AliasCom= ##Class(EPRservice.Utility).CheckContain($ZCVT(AliasValue,"U"),$ZCVT(AComItem,"U"),AHasGB)}
			
			if ((CodeCom '= 1)&&(DescCom '= 1)&&(AliasCom '= 1))
			{	continue}
		}
		
		//处理满足条件的结果并存入临时global
		s totRowCount = totRowCount + 1
		if (AIsKeepMinus = "0")
		{	s DescValue = $E(DescValue,$F(DescValue,"-"),$L(DescValue)) }
		s ^CacheTempStdQuery(ASessionId,totRowCount) =$LB(totRowCount,AliasValue,CodeValue,DescValue)
	}
	
	s ^CacheTempStdQueryCount(ASessionId,"StdQueryDataCount")= totRowCount
	
	q totRowCount
}

/// Create:	2011-09-14	HouJ Wangwt
/// Desc:	查询【用户】字典内容：SQLUser.SS_User
/// Input：	AComItem 查询条件；ADicAliasCol 别名列；ADicCodeCol 代码列；ADicDescCol 描述列；ADescHasMinius 描述列是否有横线
ClassMethod SelectStdDic001(AComItem As %String, ADicAliasCol As %String, ADicCodeCol As %String, ADicDescCol As %String, ASessionId As %String, AHasGB As %String, AIsKeepMinus As %String, ADefaultConditionValue As %String) As %Integer
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
		s:(SSUSRCareProvDR'="")&&(ADefaultConditionValue'="") RESRowId=$o(^RB("RES",0,"CTPCP",SSUSRCareProvDR,ADefaultConditionValue,""))
		continue:(RESRowId="")
		//wangwentao 20111020 update end
		
		//是否满足查询条件
		s CodeCom=0, DescCom=0, AliasCom=0
		if (AComItem '= "")
		{	
			
			s CodeCom= ##Class(EPRservice.Utility).CheckContain($ZCVT(CodeValue,"U"),$ZCVT(AComItem,"U"),AHasGB)
			S DescCom= ##Class(EPRservice.Utility).CheckContain($ZCVT(DescValue,"U"),$ZCVT(AComItem,"U"),AHasGB)
			if ((ADicAliasCol '="")&&(ADicAliasCol'=$C(0)))
			{	s AliasCom= ##Class(EPRservice.Utility).CheckContain($ZCVT(AliasValue,"U"),$ZCVT(AComItem,"U"),AHasGB)}
			
			if ((CodeCom '= 1)&&(DescCom '= 1)&&(AliasCom '= 1))
			{	continue}
		}
		
		//处理满足条件的结果并存入临时global
		s totRowCount = totRowCount + 1
		if (AIsKeepMinus = "0")
		{	s DescValue = $E(DescValue,$F(DescValue,"-"),$L(DescValue)) }
		s ^CacheTempStdQuery(ASessionId,totRowCount) =$LB(totRowCount,AliasValue,CodeValue,DescValue)
	}
	
	s ^CacheTempStdQueryCount(ASessionId,"StdQueryDataCount")= totRowCount
	
	q totRowCount
}

/// Create:	2011-09-22	Wangwt [HIS]默认手术室员工字典
/// Desc:	查询【用户】字典内容：SQLUser.SS_User  
/// Input：	AComItem 查询条件；ADicAliasCol 别名列；ADicCodeCol 代码列；ADicDescCol 描述列；ADescHasMinius 描述列是否有横线
ClassMethod SelectStdDic002(AComItem As %String, ADicAliasCol As %String, ADicCodeCol As %String, ADicDescCol As %String, ASessionId As %String, AHasGB As %String, AIsKeepMinus As %String, ADefaultConditionValue As %String) As %Integer
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
			
			s CodeCom= ##Class(EPRservice.Utility).CheckContain($ZCVT(CodeValue,"U"),$ZCVT(AComItem,"U"),AHasGB)
			S DescCom= ##Class(EPRservice.Utility).CheckContain($ZCVT(DescValue,"U"),$ZCVT(AComItem,"U"),AHasGB)
			if ((ADicAliasCol '="")&&(ADicAliasCol'=$C(0)))
			{	s AliasCom= ##Class(EPRservice.Utility).CheckContain($ZCVT(AliasValue,"U"),$ZCVT(AComItem,"U"),AHasGB)}
			
			if ((CodeCom '= 1)&&(DescCom '= 1)&&(AliasCom '= 1))
			{	continue}
		}
		
		//处理满足条件的结果并存入临时global
		s totRowCount = totRowCount + 1
		if (AIsKeepMinus = "0")
		{	s DescValue = $E(DescValue,$F(DescValue,"-"),$L(DescValue)) }
		s ^CacheTempStdQuery(ASessionId,totRowCount) =$LB(totRowCount,AliasValue,CodeValue,DescValue)
	}
	
	s ^CacheTempStdQueryCount(ASessionId,"StdQueryDataCount")= totRowCount
	
	q totRowCount
}

/// Create:	2011-09-22	Wangwt [HIS]默认麻醉科员工字典
/// Desc:	查询【用户】字典内容：SQLUser.SS_User  
/// Input：	AComItem 查询条件；ADicAliasCol 别名列；ADicCodeCol 代码列；ADicDescCol 描述列；ADescHasMinius 描述列是否有横线
ClassMethod SelectStdDic003(AComItem As %String, ADicAliasCol As %String, ADicCodeCol As %String, ADicDescCol As %String, ASessionId As %String, AHasGB As %String, AIsKeepMinus As %String, ADefaultConditionValue As %String) As %Integer
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
			
			s CodeCom= ##Class(EPRservice.Utility).CheckContain($ZCVT(CodeValue,"U"),$ZCVT(AComItem,"U"),AHasGB)
			S DescCom= ##Class(EPRservice.Utility).CheckContain($ZCVT(DescValue,"U"),$ZCVT(AComItem,"U"),AHasGB)
			if ((ADicAliasCol '="")&&(ADicAliasCol'=$C(0)))
			{	s AliasCom= ##Class(EPRservice.Utility).CheckContain($ZCVT(AliasValue,"U"),$ZCVT(AComItem,"U"),AHasGB)}
			
			if ((CodeCom '= 1)&&(DescCom '= 1)&&(AliasCom '= 1))
			{	continue}
		}
		
		//处理满足条件的结果并存入临时global
		s totRowCount = totRowCount + 1
		if (AIsKeepMinus = "0")
		{	s DescValue = $E(DescValue,$F(DescValue,"-"),$L(DescValue)) }
		s ^CacheTempStdQuery(ASessionId,totRowCount) =$LB(totRowCount,AliasValue,CodeValue,DescValue)
	}
	
	s ^CacheTempStdQueryCount(ASessionId,"StdQueryDataCount")= totRowCount
	
	q totRowCount
}

/// Create:	2011-09-22	Wangwt
/// Desc:	查询 [EPR]手术操作字典 内容：EPRview.Operation  EPRmeta.CustomDictionary
/// Input：	AComItem 查询条件；ADicAliasCol 别名列；ADicCodeCol 代码列；ADicDescCol 描述列；ADescHasMinius 描述列是否有横线
///         ^DHCCTWS.CustomDictionaryD(258)=<<$LB("","XQBSYLS","0051","胸腔闭式引流术","^39^41^43^","Y","Operation","","手术操作字典","","","","")>>
ClassMethod SelectStdDic004(AComItem As %String, ADicAliasCol As %String, ADicCodeCol As %String, ADicDescCol As %String, ASessionId As %String, AHasGB As %String, AIsKeepMinus As %String, ADefaultConditionValue As %String) As %Integer
{
	//结果行总数
	s totRowCount = 0
	
	//开始查询
	s rowid = 0
	for {
		s rowid=$o(^DHCCTWS.CustomDictionaryD(rowid))
		quit:(rowid = "")
		
		//取代码列,描述列,别名列
		s CodeValue=$lg(^DHCCTWS.CustomDictionaryD(rowid),3)
		s DescValue=$lg(^DHCCTWS.CustomDictionaryD(rowid),4)
		s AliasValue=$lg(^DHCCTWS.CustomDictionaryD(rowid),2)
		
		//筛选字典
		s defaultCtmDictStatus = $lg(^DHCCTWS.CustomDictionaryD(rowid),6)
		continue:(defaultCtmDictStatus '= "Y")
		s defaultCtmDictType = $lg(^DHCCTWS.CustomDictionaryD(rowid),7)
		continue:(defaultCtmDictType '= "Operation")

		
		//是否满足默认查询条件
		s defaultDeptID = $lg(^DHCCTWS.CustomDictionaryD(rowid),5)
		continue:($f(defaultDeptID , "^"_ADefaultConditionValue_"^")=0)
		
		//是否满足查询条件
		s CodeCom=0, DescCom=0, AliasCom=0
		if (AComItem '= "")
		{	
			
			s CodeCom= ##Class(EPRservice.Utility).CheckContain($ZCVT(CodeValue,"U"),$ZCVT(AComItem,"U"),AHasGB)
			S DescCom= ##Class(EPRservice.Utility).CheckContain($ZCVT(DescValue,"U"),$ZCVT(AComItem,"U"),AHasGB)
			if ((ADicAliasCol '="")&&(ADicAliasCol'=$C(0)))
			{	s AliasCom= ##Class(EPRservice.Utility).CheckContain($ZCVT(AliasValue,"U"),$ZCVT(AComItem,"U"),AHasGB)}
			
			if ((CodeCom '= 1)&&(DescCom '= 1)&&(AliasCom '= 1))
			{	continue}
		}
		
		//处理满足条件的结果并存入临时global
		s totRowCount = totRowCount + 1
		if (AIsKeepMinus = "0")
		{	s DescValue = $E(DescValue,$F(DescValue,"-"),$L(DescValue)) }
		s ^CacheTempStdQuery(ASessionId,totRowCount) =$LB(totRowCount,AliasValue,CodeValue,DescValue)
	}
	
	s ^CacheTempStdQueryCount(ASessionId,"StdQueryDataCount")= totRowCount
	
	q totRowCount
}

/// Create:	2011-09-22	Wangwt
/// Desc:	查询 [EPR]切口位置字典 内容：EPRview.OperationCutSite  EPRmeta.CustomDictionary
/// Input：	AComItem 查询条件；ADicAliasCol 别名列；ADicCodeCol 代码列；ADicDescCol 描述列；ADescHasMinius 描述列是否有横线
///         ^DHCCTWS.CustomDictionaryD(258)=<<$LB("","XQBSYLS","0051","胸腔闭式引流术","^39^41^43^","Y","Operation","","手术操作字典","","","","")>>
ClassMethod SelectStdDic005(AComItem As %String, ADicAliasCol As %String, ADicCodeCol As %String, ADicDescCol As %String, ASessionId As %String, AHasGB As %String, AIsKeepMinus As %String, ADefaultConditionValue As %String) As %Integer
{
	//结果行总数
	s totRowCount = 0
	
	//开始查询
	s rowid = 0
	for {
		s rowid=$o(^DHCCTWS.CustomDictionaryD(rowid))
		quit:(rowid = "")
		
		//取代码列,描述列,别名列
		s CodeValue=$lg(^DHCCTWS.CustomDictionaryD(rowid),3)
		s DescValue=$lg(^DHCCTWS.CustomDictionaryD(rowid),4)
		s AliasValue=$lg(^DHCCTWS.CustomDictionaryD(rowid),2)
		
		//筛选字典
		s defaultCtmDictStatus = $lg(^DHCCTWS.CustomDictionaryD(rowid),6)
		continue:(defaultCtmDictStatus '= "Y")
		s defaultCtmDictType = $lg(^DHCCTWS.CustomDictionaryD(rowid),7)
		continue:(defaultCtmDictType '= "OperationCutSite")

		
		//是否满足默认查询条件
		s defaultDeptID = $lg(^DHCCTWS.CustomDictionaryD(rowid),5)
		continue:($f(defaultDeptID , "^"_ADefaultConditionValue_"^")=0)
		
		//是否满足查询条件
		s CodeCom=0, DescCom=0, AliasCom=0
		if (AComItem '= "")
		{	
			
			s CodeCom= ##Class(EPRservice.Utility).CheckContain($ZCVT(CodeValue,"U"),$ZCVT(AComItem,"U"),AHasGB)
			S DescCom= ##Class(EPRservice.Utility).CheckContain($ZCVT(DescValue,"U"),$ZCVT(AComItem,"U"),AHasGB)
			if ((ADicAliasCol '="")&&(ADicAliasCol'=$C(0)))
			{	s AliasCom= ##Class(EPRservice.Utility).CheckContain($ZCVT(AliasValue,"U"),$ZCVT(AComItem,"U"),AHasGB)}
			
			if ((CodeCom '= 1)&&(DescCom '= 1)&&(AliasCom '= 1))
			{	continue}
		}
		
		//处理满足条件的结果并存入临时global
		s totRowCount = totRowCount + 1
		if (AIsKeepMinus = "0")
		{	s DescValue = $E(DescValue,$F(DescValue,"-"),$L(DescValue)) }
		s ^CacheTempStdQuery(ASessionId,totRowCount) =$LB(totRowCount,AliasValue,CodeValue,DescValue)
	}
	
	s ^CacheTempStdQueryCount(ASessionId,"StdQueryDataCount")= totRowCount
	
	q totRowCount
}

/// Create:	2012-1-4	HouJ
/// Desc:	查询【科室】字典内容：SQLUser.CT_HealthCareRegion
/// Input：	AComItem 查询条件；ADicAliasCol 别名列；ADicCodeCol 代码列；ADicDescCol 描述列；ADescHasMinius 描述列是否有横线
ClassMethod SelectStdDicCTHealthCareRegion(AComItem As %String, ADicAliasCol As %String, ADicCodeCol As %String, ADicDescCol As %String, ASessionId As %String, AHasGB As %String, AIsKeepMinus As %String) As %Integer
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
			s CodeCom= ##Class(EPRservice.Utility).CheckContain($ZCVT(CodeValue,"U"),$ZCVT(AComItem,"U"),AHasGB)
			S DescCom= ##Class(EPRservice.Utility).CheckContain($ZCVT(DescValue,"U"),$ZCVT(AComItem,"U"),AHasGB)
			if ((ADicAliasCol '="")&&(ADicAliasCol'=$C(0)))
			{	s AliasCom= ##Class(EPRservice.Utility).CheckContain($ZCVT(AliasValue,"U"),$ZCVT(AComItem,"U"),AHasGB)}
			
			if ((CodeCom '= 1)&&(DescCom '= 1)&&(AliasCom '= 1))
			{	continue}
		}
		
		//处理满足条件的结果并存入临时global
		s totRowCount = totRowCount + 1
		if (AIsKeepMinus = "0")
		{	s DescValue = $E(DescValue,$F(DescValue,"-"),$L(DescValue)) }
		s ^CacheTempStdQuery(ASessionId,totRowCount) =$LB(totRowCount,AliasValue,CodeValue,DescValue)
	}
	
	s ^CacheTempStdQueryCount(ASessionId,"StdQueryDataCount")= totRowCount
	
	q totRowCount
}

/// Create:	2008-11-27	HouJ
/// Desc:	查询【科室】字典内容：SQLUser.CT_Loc
/// Input：	AComItem 查询条件；ADicAliasCol 别名列；ADicCodeCol 代码列；ADicDescCol 描述列；ADescHasMinius 描述列是否有横线
ClassMethod SelectStdDicCTLoc(AComItem As %String, ADicAliasCol As %String, ADicCodeCol As %String, ADicDescCol As %String, ASessionId As %String, AHasGB As %String, AIsKeepMinus As %String) As %Integer
{
	//结果行总数
	s totRowCount = 0
	
	//开始查询
	s rowid = 0
	for {
		s rowid=$o(^CTLOC(rowid))
		quit:(rowid = "")
		
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
			
			s CodeCom= ##Class(EPRservice.Utility).CheckContain($ZCVT(CodeValue,"U"),$ZCVT(AComItem,"U"),AHasGB)
			S DescCom= ##Class(EPRservice.Utility).CheckContain($ZCVT(DescValue,"U"),$ZCVT(AComItem,"U"),AHasGB)
			if ((ADicAliasCol '="")&&(ADicAliasCol'=$C(0)))
			{	s AliasCom= ##Class(EPRservice.Utility).CheckContain($ZCVT(AliasValue,"U"),$ZCVT(AComItem,"U"),AHasGB)}
			
			if ((CodeCom '= 1)&&(DescCom '= 1)&&(AliasCom '= 1))
			{	continue}
		}
		
		//处理满足条件的结果并存入临时global
		s totRowCount = totRowCount + 1
		if (AIsKeepMinus = "0")
		{	s DescValue = $E(DescValue,$F(DescValue,"-"),$L(DescValue)) }
		s ^CacheTempStdQuery(ASessionId,totRowCount) =$LB(totRowCount,AliasValue,CodeValue,DescValue)
	}
	
	s ^CacheTempStdQueryCount(ASessionId,"StdQueryDataCount")= totRowCount
	
	q totRowCount
}

/// Create:	2008-11-27	HouJ
/// Desc:	查询【病室】字典内容：SQLUser.PAC_Ward
/// Input：	AComItem 查询条件；ADicAliasCol 别名列；ADicCodeCol 代码列；ADicDescCol 描述列；ADescHasMinius 描述列是否有横线
ClassMethod SelectStdDicPACWard(AComItem As %String, ADicAliasCol As %String, ADicCodeCol As %String, ADicDescCol As %String, ASessionId As %String, AHasGB As %String, AIsKeepMinus As %String) As %Integer
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
		s AliasValue=""
		
		//是否满足查询条件
		s CodeCom=0, DescCom=0, AliasCom=0
		if (AComItem '= "")
		{	
			
			s CodeCom= ##Class(EPRservice.Utility).CheckContain($ZCVT(CodeValue,"U"),$ZCVT(AComItem,"U"),AHasGB)
			S DescCom= ##Class(EPRservice.Utility).CheckContain($ZCVT(DescValue,"U"),$ZCVT(AComItem,"U"),AHasGB)
			if ((ADicAliasCol '="")&&(ADicAliasCol'=$C(0)))
			{	s AliasCom= ##Class(EPRservice.Utility).CheckContain($ZCVT(AliasValue,"U"),$ZCVT(AComItem,"U"),AHasGB)}
			
			if ((CodeCom '= 1)&&(DescCom '= 1)&&(AliasCom '= 1))
			{	continue}
		}
		
		//处理满足条件的结果并存入临时global
		s totRowCount = totRowCount + 1
		if (AIsKeepMinus = "0")
		{	s DescValue = $E(DescValue,$F(DescValue,"-"),$L(DescValue)) }
		s ^CacheTempStdQuery(ASessionId,totRowCount) =$LB(totRowCount,AliasValue,CodeValue,DescValue)
	}
	
	s ^CacheTempStdQueryCount(ASessionId,"StdQueryDataCount")= totRowCount
	
	q totRowCount
}

/// Create:	2008-11-27	HouJ
/// Desc:	查询【民族】字典内容：SQLUser.CT_Nation
/// Input：	AComItem 查询条件；ADicAliasCol 别名列；ADicCodeCol 代码列；ADicDescCol 描述列；ADescHasMinius 描述列是否有横线
ClassMethod SelectStdDicCTNation(AComItem As %String, ADicAliasCol As %String, ADicCodeCol As %String, ADicDescCol As %String, ASessionId As %String, AHasGB As %String, AIsKeepMinus As %String) As %Integer
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
			
			s CodeCom= ##Class(EPRservice.Utility).CheckContain($ZCVT(CodeValue,"U"),$ZCVT(AComItem,"U"),AHasGB)
			S DescCom= ##Class(EPRservice.Utility).CheckContain($ZCVT(DescValue,"U"),$ZCVT(AComItem,"U"),AHasGB)
			if ((ADicAliasCol '="")&&(ADicAliasCol'=$C(0)))
			{	s AliasCom= ##Class(EPRservice.Utility).CheckContain($ZCVT(AliasValue,"U"),$ZCVT(AComItem,"U"),AHasGB)}
			
			if ((CodeCom '= 1)&&(DescCom '= 1)&&(AliasCom '= 1))
			{	continue}
		}
		
		//处理满足条件的结果并存入临时global
		s totRowCount = totRowCount + 1
		if (AIsKeepMinus = "0")
		{	s DescValue = $E(DescValue,$F(DescValue,"-"),$L(DescValue)) }
		s ^CacheTempStdQuery(ASessionId,totRowCount) =$LB(totRowCount,AliasValue,CodeValue,DescValue)
	}
	
	s ^CacheTempStdQueryCount(ASessionId,"StdQueryDataCount")= totRowCount
	
	q totRowCount
}

/// Create:	2008-11-27	HouJ
/// Desc:	查询【药学项】字典内容：SQLUser.PHC_DrgMast
/// Input：	AComItem 查询条件；ADicAliasCol 别名列；ADicCodeCol 代码列；ADicDescCol 描述列；ADescHasMinius 描述列是否有横线
ClassMethod SelectStdDicPHCDrgMast(AComItem As %String, ADicAliasCol As %String, ADicCodeCol As %String, ADicDescCol As %String, ASessionId As %String, AHasGB As %String, AIsKeepMinus As %String) As %Integer
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
			s CodeCom= ##Class(EPRservice.Utility).CheckContain($ZCVT(CodeValue,"U"),$ZCVT(AComItem,"U"),AHasGB)
			S DescCom= ##Class(EPRservice.Utility).CheckContain($ZCVT(DescValue,"U"),$ZCVT(AComItem,"U"),AHasGB)
			if ((ADicAliasCol '="")&&(ADicAliasCol'=$C(0)))
			{	s AliasCom= ##Class(EPRservice.Utility).CheckContain($ZCVT(AliasValue,"U"),$ZCVT(AComItem,"U"),AHasGB)}
			
			if ((CodeCom '= 1)&&(DescCom '= 1)&&(AliasCom '= 1))
			{	continue}
		}
		
		//处理满足条件的结果并存入临时global
		s totRowCount = totRowCount + 1
		s AliasValue = $P(AliasValue,$C(2),1)
		if (AIsKeepMinus = "0")
		{	s DescValue = $E(DescValue,$F(DescValue,"-"),$L(DescValue)) }
		s ^CacheTempStdQuery(ASessionId,totRowCount) =$LB(totRowCount,AliasValue,CodeValue,DescValue)
	}
	
	s ^CacheTempStdQueryCount(ASessionId,"StdQueryDataCount")= totRowCount
	
	q totRowCount
}

/// Create:	2008-11-27	HouJ
/// Desc:	查询【职业】字典内容：SQLUser.CT_Occupation
/// Input：	AComItem 查询条件；ADicAliasCol 别名列；ADicCodeCol 代码列；ADicDescCol 描述列；ADescHasMinius 描述列是否有横线
ClassMethod SelectStdDicCTOccupation(AComItem As %String, ADicAliasCol As %String, ADicCodeCol As %String, ADicDescCol As %String, ASessionId As %String, AHasGB As %String, AIsKeepMinus As %String) As %Integer
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
			
			s CodeCom= ##Class(EPRservice.Utility).CheckContain($ZCVT(CodeValue,"U"),$ZCVT(AComItem,"U"),AHasGB)
			S DescCom= ##Class(EPRservice.Utility).CheckContain($ZCVT(DescValue,"U"),$ZCVT(AComItem,"U"),AHasGB)
			if ((ADicAliasCol '="")&&(ADicAliasCol'=$C(0)))
			{	s AliasCom= ##Class(EPRservice.Utility).CheckContain($ZCVT(AliasValue,"U"),$ZCVT(AComItem,"U"),AHasGB)}
			
			if ((CodeCom '= 1)&&(DescCom '= 1)&&(AliasCom '= 1))
			{	continue}
		}
		
		//处理满足条件的结果并存入临时global
		s totRowCount = totRowCount + 1
		if (AIsKeepMinus = "0")
		{	s DescValue = $E(DescValue,$F(DescValue,"-"),$L(DescValue)) }
		s ^CacheTempStdQuery(ASessionId,totRowCount) =$LB(totRowCount,AliasValue,CodeValue,DescValue)
	}
	
	s ^CacheTempStdQueryCount(ASessionId,"StdQueryDataCount")= totRowCount
	
	q totRowCount
}

/// Create:	2008-11-27	HouJ
/// Desc:	查询【国籍】字典内容：SQLUser.CT_Country
/// Input：	AComItem 查询条件；ADicAliasCol 别名列；ADicCodeCol 代码列；ADicDescCol 描述列；ADescHasMinius 描述列是否有横线
ClassMethod SelectStdDicCTCountry(AComItem As %String, ADicAliasCol As %String, ADicCodeCol As %String, ADicDescCol As %String, ASessionId As %String, AHasGB As %String, AIsKeepMinus As %String) As %Integer
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
		
		//是否满足查询条件
		s CodeCom=0, DescCom=0, AliasCom=0
		if (AComItem '= "")
		{	
			
			s CodeCom= ##Class(EPRservice.Utility).CheckContain($ZCVT(CodeValue,"U"),$ZCVT(AComItem,"U"),AHasGB)
			S DescCom= ##Class(EPRservice.Utility).CheckContain($ZCVT(DescValue,"U"),$ZCVT(AComItem,"U"),AHasGB)
			if ((ADicAliasCol '="")&&(ADicAliasCol'=$C(0)))
			{	s AliasCom= ##Class(EPRservice.Utility).CheckContain($ZCVT(AliasValue,"U"),$ZCVT(AComItem,"U"),AHasGB)}
			
			if ((CodeCom '= 1)&&(DescCom '= 1)&&(AliasCom '= 1))
			{	continue}
		}
		
		//处理满足条件的结果并存入临时global
		s totRowCount = totRowCount + 1
		if (AIsKeepMinus = "0")
		{	s DescValue = $E(DescValue,$F(DescValue,"-"),$L(DescValue)) }
		s ^CacheTempStdQuery(ASessionId,totRowCount) =$LB(totRowCount,AliasValue,CodeValue,DescValue)
	}
	
	s ^CacheTempStdQueryCount(ASessionId,"StdQueryDataCount")= totRowCount
	
	q totRowCount
}

/// Create:	2008-11-27	HouJ
/// Desc:	查询【省市】字典内容：SQLUser.CT_Province
/// Input：	AComItem 查询条件；ADicAliasCol 别名列；ADicCodeCol 代码列；ADicDescCol 描述列；ADescHasMinius 描述列是否有横线
ClassMethod SelectStdDicCTProvince(AComItem As %String, ADicAliasCol As %String, ADicCodeCol As %String, ADicDescCol As %String, ASessionId As %String, AHasGB As %String, AIsKeepMinus As %String) As %Integer
{
	//结果行总数
	s totRowCount = 0
	
	//开始查询
	s rowid = 0
	for {
		s rowid=$o(^CT("PROV",rowid))
		quit:(rowid = "")
		
		//取代码列,描述列,别名列
		s CodeValue=$p($g(^CT("PROV",rowid)),"^",1)
		s DescValue=$p($g(^CT("PROV",rowid)),"^",2)
		s AliasValue=""
		
		//是否满足查询条件
		s CodeCom=0, DescCom=0, AliasCom=0
		if (AComItem '= "")
		{	
			
			s CodeCom= ##Class(EPRservice.Utility).CheckContain($ZCVT(CodeValue,"U"),$ZCVT(AComItem,"U"),AHasGB)
			S DescCom= ##Class(EPRservice.Utility).CheckContain($ZCVT(DescValue,"U"),$ZCVT(AComItem,"U"),AHasGB)
			if ((ADicAliasCol '="")&&(ADicAliasCol'=$C(0)))
			{	s AliasCom= ##Class(EPRservice.Utility).CheckContain($ZCVT(AliasValue,"U"),$ZCVT(AComItem,"U"),AHasGB)}
			
			if ((CodeCom '= 1)&&(DescCom '= 1)&&(AliasCom '= 1))
			{	continue}
		}
		
		//处理满足条件的结果并存入临时global
		s totRowCount = totRowCount + 1
		if (AIsKeepMinus = "0")
		{	s DescValue = $E(DescValue,$F(DescValue,"-"),$L(DescValue)) }
		s ^CacheTempStdQuery(ASessionId,totRowCount) =$LB(totRowCount,AliasValue,CodeValue,DescValue)
	}
	
	s ^CacheTempStdQueryCount(ASessionId,"StdQueryDataCount")= totRowCount
	
	q totRowCount
}

/// Create:	2008-11-27	HouJ
/// Desc:	查询【省市】字典内容：SQLUser.CT_City
/// Input：	AComItem 查询条件；ADicAliasCol 别名列；ADicCodeCol 代码列；ADicDescCol 描述列；ADescHasMinius 描述列是否有横线
ClassMethod SelectStdDicCTCity(AComItem As %String, ADicAliasCol As %String, ADicCodeCol As %String, ADicDescCol As %String, ASessionId As %String, AHasGB As %String, AIsKeepMinus As %String) As %Integer
{
	//结果行总数
	s totRowCount = 0
	
	//开始查询
	s rowid = 0
	for {
		s rowid=$o(^CT("CIT",rowid))
		quit:(rowid = "")
		
		//取代码列,描述列,别名列
		s CodeValue=$p($g(^CT("CIT",rowid)),"^",1)
		s DescValue=$p($g(^CT("CIT",rowid)),"^",2)
		s AliasValue=""
		
		//是否满足查询条件
		s CodeCom=0, DescCom=0, AliasCom=0
		if (AComItem '= "")
		{	
			
			s CodeCom= ##Class(EPRservice.Utility).CheckContain($ZCVT(CodeValue,"U"),$ZCVT(AComItem,"U"),AHasGB)
			S DescCom= ##Class(EPRservice.Utility).CheckContain($ZCVT(DescValue,"U"),$ZCVT(AComItem,"U"),AHasGB)
			if ((ADicAliasCol '="")&&(ADicAliasCol'=$C(0)))
			{	s AliasCom= ##Class(EPRservice.Utility).CheckContain($ZCVT(AliasValue,"U"),$ZCVT(AComItem,"U"),AHasGB)}
			
			if ((CodeCom '= 1)&&(DescCom '= 1)&&(AliasCom '= 1))
			{	continue}
		}
		
		//处理满足条件的结果并存入临时global
		s totRowCount = totRowCount + 1
		if (AIsKeepMinus = "0")
		{	s DescValue = $E(DescValue,$F(DescValue,"-"),$L(DescValue)) }
		s ^CacheTempStdQuery(ASessionId,totRowCount) =$LB(totRowCount,AliasValue,CodeValue,DescValue)
	}
	
	s ^CacheTempStdQueryCount(ASessionId,"StdQueryDataCount")= totRowCount
	
	q totRowCount
}

/// Create:	2008-11-27	HouJ
/// Desc:	查询【性别】字典内容：SQLUser.CT_Sex
/// Input：	AComItem 查询条件；ADicAliasCol 别名列；ADicCodeCol 代码列；ADicDescCol 描述列；ADescHasMinius 描述列是否有横线
ClassMethod SelectStdDicCTSex(AComItem As %String, ADicAliasCol As %String, ADicCodeCol As %String, ADicDescCol As %String, ASessionId As %String, AHasGB As %String, AIsKeepMinus As %String) As %Integer
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
			
			s CodeCom= ##Class(EPRservice.Utility).CheckContain($ZCVT(CodeValue,"U"),$ZCVT(AComItem,"U"),AHasGB)
			S DescCom= ##Class(EPRservice.Utility).CheckContain($ZCVT(DescValue,"U"),$ZCVT(AComItem,"U"),AHasGB)
			if ((ADicAliasCol '="")&&(ADicAliasCol'=$C(0)))
			{	s AliasCom= ##Class(EPRservice.Utility).CheckContain($ZCVT(AliasValue,"U"),$ZCVT(AComItem,"U"),AHasGB)}
			
			if ((CodeCom '= 1)&&(DescCom '= 1)&&(AliasCom '= 1))
			{	continue}
		}
		
		//处理满足条件的结果并存入临时global
		s totRowCount = totRowCount + 1
		if (AIsKeepMinus = "0")
		{	s DescValue = $E(DescValue,$F(DescValue,"-"),$L(DescValue)) }
		s ^CacheTempStdQuery(ASessionId,totRowCount) =$LB(totRowCount,AliasValue,CodeValue,DescValue)
	}
	
	s ^CacheTempStdQueryCount(ASessionId,"StdQueryDataCount")= totRowCount
	
	q totRowCount
}

/// Create:	2008-11-27	HouJ
/// Desc:	查询【病人类别】字典内容：SQLUser.PAC_PatientCategory
/// Input：	AComItem 查询条件；ADicAliasCol 别名列；ADicCodeCol 代码列；ADicDescCol 描述列；ADescHasMinius 描述列是否有横线
ClassMethod SelectStdDicPACPatientCategory(AComItem As %String, ADicAliasCol As %String, ADicCodeCol As %String, ADicDescCol As %String, ASessionId As %String, AHasGB As %String, AIsKeepMinus As %String) As %Integer
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
			
			s CodeCom= ##Class(EPRservice.Utility).CheckContain($ZCVT(CodeValue,"U"),$ZCVT(AComItem,"U"),AHasGB)
			S DescCom= ##Class(EPRservice.Utility).CheckContain($ZCVT(DescValue,"U"),$ZCVT(AComItem,"U"),AHasGB)
			if ((ADicAliasCol '="")&&(ADicAliasCol'=$C(0)))
			{	s AliasCom= ##Class(EPRservice.Utility).CheckContain($ZCVT(AliasValue,"U"),$ZCVT(AComItem,"U"),AHasGB)}
			
			if ((CodeCom '= 1)&&(DescCom '= 1)&&(AliasCom '= 1))
			{	continue}
		}
		
		//处理满足条件的结果并存入临时global
		s totRowCount = totRowCount + 1
		if (AIsKeepMinus = "0")
		{	s DescValue = $E(DescValue,$F(DescValue,"-"),$L(DescValue)) }
		s ^CacheTempStdQuery(ASessionId,totRowCount) =$LB(totRowCount,AliasValue,CodeValue,DescValue)
	}
	
	s ^CacheTempStdQueryCount(ASessionId,"StdQueryDataCount")= totRowCount
	
	q totRowCount
}

/// Create:	2008-11-27	HouJ
/// Desc:	查询【邮编】字典内容：SQLUser.CT_Zip	CTZIP_Code CTZIP_Desc 
/// Input：	AComItem 查询条件；ADicAliasCol 别名列；ADicCodeCol 代码列；ADicDescCol 描述列；ADescHasMinius 描述列是否有横线
ClassMethod SelectStdDicCTZip(AComItem As %String, ADicAliasCol As %String, ADicCodeCol As %String, ADicDescCol As %String, ASessionId As %String, AHasGB As %String, AIsKeepMinus As %String) As %Integer
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
			
			s CodeCom= ##Class(EPRservice.Utility).CheckContain($ZCVT(CodeValue,"U"),$ZCVT(AComItem,"U"),AHasGB)
			S DescCom= ##Class(EPRservice.Utility).CheckContain($ZCVT(DescValue,"U"),$ZCVT(AComItem,"U"),AHasGB)
			if ((ADicAliasCol '="")&&(ADicAliasCol'=$C(0)))
			{	s AliasCom= ##Class(EPRservice.Utility).CheckContain($ZCVT(AliasValue,"U"),$ZCVT(AComItem,"U"),AHasGB)}
			
			if ((CodeCom '= 1)&&(DescCom '= 1)&&(AliasCom '= 1))
			{	continue}
		}
		
		//处理满足条件的结果并存入临时global
		s totRowCount = totRowCount + 1
		if (AIsKeepMinus = "0")
		{	s DescValue = $E(DescValue,$F(DescValue,"-"),$L(DescValue)) }
		s ^CacheTempStdQuery(ASessionId,totRowCount) =$LB(totRowCount,AliasValue,CodeValue,DescValue)
	}
	
	s ^CacheTempStdQueryCount(ASessionId,"StdQueryDataCount")= totRowCount
	
	q totRowCount
}

/// Create:	2008-11-27	HouJ
/// Desc:	查询【联系人关系】字典内容：SQLUser.CT_Relation 
/// Input：	AComItem 查询条件；ADicAliasCol 别名列；ADicCodeCol 代码列；ADicDescCol 描述列；ADescHasMinius 描述列是否有横线
ClassMethod SelectStdDicCTReleation(AComItem As %String, ADicAliasCol As %String, ADicCodeCol As %String, ADicDescCol As %String, ASessionId As %String, AHasGB As %String, AIsKeepMinus As %String) As %Integer
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
		if (AComItem '= "")
		{	
			
			s CodeCom= ##Class(EPRservice.Utility).CheckContain($ZCVT(CodeValue,"U"),$ZCVT(AComItem,"U"),AHasGB)
			S DescCom= ##Class(EPRservice.Utility).CheckContain($ZCVT(DescValue,"U"),$ZCVT(AComItem,"U"),AHasGB)
			if ((ADicAliasCol '="")&&(ADicAliasCol'=$C(0)))
			{	s AliasCom= ##Class(EPRservice.Utility).CheckContain($ZCVT(AliasValue,"U"),$ZCVT(AComItem,"U"),AHasGB)}
			
			if ((CodeCom '= 1)&&(DescCom '= 1)&&(AliasCom '= 1))
			{	continue}
		}
		
		//处理满足条件的结果并存入临时global
		s totRowCount = totRowCount + 1
		if (AIsKeepMinus = "0")
		{	s DescValue = $E(DescValue,$F(DescValue,"-"),$L(DescValue)) }
		s ^CacheTempStdQuery(ASessionId,totRowCount) =$LB(totRowCount,AliasValue,CodeValue,DescValue)
	}
	
	s ^CacheTempStdQueryCount(ASessionId,"StdQueryDataCount")= totRowCount
	
	q totRowCount
}

/// Create:	2008-11-27	HouJ
/// Desc:	查询【病人类型】字典内容：EPRview.PatType
/// Input：	AComItem 查询条件；ADicAliasCol 别名列；ADicCodeCol 代码列；ADicDescCol 描述列；ADescHasMinius 描述列是否有横线
ClassMethod SelectStdDicDHCEPRVPatType(AComItem As %String, ADicAliasCol As %String, ADicCodeCol As %String, ADicDescCol As %String, ASessionId As %String, AHasGB As %String, AIsKeepMinus As %String) As %Integer
{
	//结果行总数
	s totRowCount = 0
	
	s (CodeValue,DescValue,AliasValue) = ""
	
	&sql(DECLARE MyCursor CURSOR FOR
 	SELECT CtmDictCode,CtmDictDesc,CtmDictAlias 
 	INTO :CodeValue, :DescValue, :AliasValue
 	FROM EPRview.PatType WHERE CtmDictID IS NULL)
 	//FROM SQLUser.DHCEPRVPatType WHERE CtmDictID IS NULL)
 	
 
 	&sql(OPEN MyCursor)
 	for  &SQL(FETCH MyCursor) QUIT:SQLCODE  do
	.s (CodeCom,DescCom, AliasCom)=1
	.i AComItem '= "" d
	..s CodeCom= ##Class(EPRservice.Utility).CheckContain($ZCVT(CodeValue,"U"),$ZCVT(AComItem,"U"),AHasGB)
	..s DescCom= ##Class(EPRservice.Utility).CheckContain($ZCVT(DescValue,"U"),$ZCVT(AComItem,"U"),AHasGB)
	..i ((ADicAliasCol '="")&&(ADicAliasCol'=$C(0))) s AliasCom= ##Class(EPRservice.Utility).CheckContain($ZCVT(AliasValue,"U"),$ZCVT(AComItem,"U"),AHasGB)
	.i ((CodeCom=1)||(DescCom=1)||(AliasCom=1)) d
	..s totRowCount = totRowCount + 1
	..i (AIsKeepMinus = "0") s DescValue = $E(DescValue,$F(DescValue,"-"),$L(DescValue))
	..s ^CacheTempStdQuery(ASessionId,totRowCount) =$LB(totRowCount,AliasValue,CodeValue,DescValue)
	&sql(CLOSE MyCursor)
	
	s ^CacheTempStdQueryCount(ASessionId,"StdQueryDataCount")= totRowCount
	
	q totRowCount
}

/// Create:	2011-03-30	Wangwt
/// Desc:	查询【麻醉】字典内容：SQLUser.ORC_AnaestMethod
/// Input：	AComItem 查询条件；ADicAliasCol 别名列；ADicCodeCol 代码列；ADicDescCol 描述列；ADescHasMinius 描述列是否有横线
ClassMethod SelectStdDicORCAnaestMethod(AComItem As %String, ADicAliasCol As %String, ADicCodeCol As %String, ADicDescCol As %String, ASessionId As %String, AHasGB As %String, AIsKeepMinus As %String) As %Integer
{
	//结果行总数
	s totRowCount = 0
	
	//开始查询
	s rowid = 0
	for {
		s rowid=$o(^ORC("ANMET",rowid))
		quit:(rowid = "")
		
		//取代码列,描述列,别名列
		s CodeValue=$p($g(^ORC("ANMET",rowid)),"^",1)
		s DescValue=$p($g(^ORC("ANMET",rowid)),"^",2)
		s AliasValue=""
		
		//是否满足查询条件
		s CodeCom=0, DescCom=0, AliasCom=0
		if (AComItem '= "")
		{	
			
			s CodeCom= ##Class(EPRservice.Utility).CheckContain($ZCVT(CodeValue,"U"),$ZCVT(AComItem,"U"),AHasGB)
			S DescCom= ##Class(EPRservice.Utility).CheckContain($ZCVT(DescValue,"U"),$ZCVT(AComItem,"U"),AHasGB)
			if ((ADicAliasCol '="")&&(ADicAliasCol'=$C(0)))
			{	s AliasCom= ##Class(EPRservice.Utility).CheckContain($ZCVT(AliasValue,"U"),$ZCVT(AComItem,"U"),AHasGB)}
			
			if ((CodeCom '= 1)&&(DescCom '= 1)&&(AliasCom '= 1))
			{	continue}
		}
		
		//处理满足条件的结果并存入临时global
		s totRowCount = totRowCount + 1
		if (AIsKeepMinus = "0")
		{	s DescValue = $E(DescValue,$F(DescValue,"-"),$L(DescValue)) }
		s ^CacheTempStdQuery(ASessionId,totRowCount) =$LB(totRowCount,AliasValue,CodeValue,DescValue)
	}
	
	s ^CacheTempStdQueryCount(ASessionId,"StdQueryDataCount")= totRowCount
	
	q totRowCount
}

/// Create:	2011-09-22	Wangwt
/// Desc:	
/// Input：	AComItem 查询条件；ADicAliasCol 别名列；ADicCodeCol 代码列；ADicDescCol 描述列；ADescHasMinius 描述列是否有横线
ClassMethod SelectStdDicEPRviewOperation(AComItem As %String, ADicAliasCol As %String, ADicCodeCol As %String, ADicDescCol As %String, ASessionId As %String, AHasGB As %String, AIsKeepMinus As %String) As %Integer
{
	//结果行总数
	s totRowCount = 0
	
	//开始查询
	s rowid = 0
	for {
		s rowid=$o(^DHCCTWS.CustomDictionaryD(rowid))
		quit:(rowid = "")
		
		//取代码列,描述列,别名列
		s CodeValue=$lg(^DHCCTWS.CustomDictionaryD(rowid),3)
		s DescValue=$lg(^DHCCTWS.CustomDictionaryD(rowid),4)
		s AliasValue=""
		
		//筛选字典
		s defaultCtmDictStatus = $lg(^DHCCTWS.CustomDictionaryD(rowid),6)
		continue:(defaultCtmDictStatus '= "Y")
		s defaultCtmDictType = $lg(^DHCCTWS.CustomDictionaryD(rowid),7)
		continue:(defaultCtmDictType '= "Operation")
		
		//是否满足查询条件
		s CodeCom=0, DescCom=0, AliasCom=0
		if (AComItem '= "")
		{	
			
			s CodeCom= ##Class(EPRservice.Utility).CheckContain($ZCVT(CodeValue,"U"),$ZCVT(AComItem,"U"),AHasGB)
			S DescCom= ##Class(EPRservice.Utility).CheckContain($ZCVT(DescValue,"U"),$ZCVT(AComItem,"U"),AHasGB)
			if ((ADicAliasCol '="")&&(ADicAliasCol'=$C(0)))
			{	s AliasCom= ##Class(EPRservice.Utility).CheckContain($ZCVT(AliasValue,"U"),$ZCVT(AComItem,"U"),AHasGB)}
			
			if ((CodeCom '= 1)&&(DescCom '= 1)&&(AliasCom '= 1))
			{	continue}
		}
		
		
		//处理满足条件的结果并存入临时global
		s totRowCount = totRowCount + 1
		if (AIsKeepMinus = "0")
		{	s DescValue = $E(DescValue,$F(DescValue,"-"),$L(DescValue)) }
		s ^CacheTempStdQuery(ASessionId,totRowCount) =$LB(totRowCount,AliasValue,CodeValue,DescValue)
	}
	
	s ^CacheTempStdQueryCount(ASessionId,"StdQueryDataCount")= totRowCount
	
	q totRowCount
	
	/*
	//结果行总数
	s totRowCount = 0
	
	s (CodeValue,DescValue,AliasValue) = ""
	
	&sql(DECLARE MyCursorOperation CURSOR FOR
 	SELECT CtmDictCode,CtmDictDesc,CtmDictAlias 
 	INTO :CodeValue, :DescValue, :AliasValue
 	FROM EPRview.Operation )
 	
 
 	&sql(OPEN MyCursorOperation)
 	for  &SQL(FETCH MyCursorOperation) QUIT:SQLCODE  do
	.s (CodeCom,DescCom, AliasCom)=1
	.i AComItem '= "" d
	..s CodeCom= ##Class(EPRservice.Utility).CheckContain($ZCVT(CodeValue,"U"),$ZCVT(AComItem,"U"),AHasGB)
	..s DescCom= ##Class(EPRservice.Utility).CheckContain($ZCVT(DescValue,"U"),$ZCVT(AComItem,"U"),AHasGB)
	..i ((ADicAliasCol '="")&&(ADicAliasCol'=$C(0))) s AliasCom= ##Class(EPRservice.Utility).CheckContain($ZCVT(AliasValue,"U"),$ZCVT(AComItem,"U"),AHasGB)
	.i ((CodeCom=1)||(DescCom=1)||(AliasCom=1)) d
	..s totRowCount = totRowCount + 1
	..i (AIsKeepMinus = "0") s DescValue = $E(DescValue,$F(DescValue,"-"),$L(DescValue))
	..s ^CacheTempStdQuery(ASessionId,totRowCount) =$LB(totRowCount,AliasValue,CodeValue,DescValue)
	&sql(CLOSE MyCursorOperation)
	
	s ^CacheTempStdQueryCount(ASessionId,"StdQueryDataCount")= totRowCount
	
	q totRowCount
	*/
}

/// Create:	2011-12-29 HouJ
/// Desc:	查询【省市】字典内容：SQLUser.CT_CityArea
/// Input：	AComItem 查询条件；ADicAliasCol 别名列；ADicCodeCol 代码列；ADicDescCol 描述列；ADescHasMinius 描述列是否有横线
ClassMethod SelectStdDicCTCityArea(AComItem As %String, ADicAliasCol As %String, ADicCodeCol As %String, ADicDescCol As %String, ASessionId As %String, AHasGB As %String, AIsKeepMinus As %String) As %Integer
{
	//结果行总数
	s totRowCount = 0
	
	//开始查询
	s rowid = 0
	for {
		s rowid=$o(^CT("CITAREA",rowid))
		quit:(rowid = "")
		
		//取代码列,描述列,别名列
		s CodeValue=$p($g(^CT("CITAREA",rowid)),"^",1)
		s DescValue=$p($g(^CT("CITAREA",rowid)),"^",2)
		s AliasValue=""
		
		//是否满足查询条件
		s CodeCom=0, DescCom=0, AliasCom=0
		if (AComItem '= "")
		{	
			
			s CodeCom= ##Class(EPRservice.Utility).CheckContain($ZCVT(CodeValue,"U"),$ZCVT(AComItem,"U"),AHasGB)
			S DescCom= ##Class(EPRservice.Utility).CheckContain($ZCVT(DescValue,"U"),$ZCVT(AComItem,"U"),AHasGB)
			if ((ADicAliasCol '="")&&(ADicAliasCol'=$C(0)))
			{	s AliasCom= ##Class(EPRservice.Utility).CheckContain($ZCVT(AliasValue,"U"),$ZCVT(AComItem,"U"),AHasGB)}
			
			if ((CodeCom '= 1)&&(DescCom '= 1)&&(AliasCom '= 1))
			{	continue}
		}
		
		//处理满足条件的结果并存入临时global
		s totRowCount = totRowCount + 1
		if (AIsKeepMinus = "0")
		{	s DescValue = $E(DescValue,$F(DescValue,"-"),$L(DescValue)) }
		s ^CacheTempStdQuery(ASessionId,totRowCount) =$LB(totRowCount,AliasValue,CodeValue,DescValue)
	}
	
	s ^CacheTempStdQueryCount(ASessionId,"StdQueryDataCount")= totRowCount
	
	q totRowCount
}

/// For P8
/// 重写 SelectNewStdDicPageCount 结束
ClassMethod SELECTStdDicPageCount(ADicCode As %String, AAias As %String, ACode As %String, ADesc As %String, ARowCount As %Integer) As %Integer
{
 set result = ##class(%Library.ResultSet).%New()
 Set SqlString ="Select Name,TableName,DicAliasCol,DicCodeCol,DicDescCol From CT_WS.StdDictionary "
 Set SqlWhereString =""
 if (ADicCode '="")
 {
 set TempCode= ##class(CT.WS.StdDictionary).ReplaceAsterisk(ADicCode)
 set SqlWhereString = "Where CT_WS.StdDictionary.Code Like '"_TempCode_"'" 
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
 Set GetCountSql = "Select Count(*) As ADataCount  From "_##class(CT.WS.StdDictionary).SwitchFromTable(result.Data("TableName"))
 //

 //comment for PinYin query
 //Set GetCountSql = "Select Count(*) As ADataCount  From "_result.Data("TableName")

 Set GetWhereSql =""
 if (result.Data("DicAliasCol")'="")
 { if (AAias '="")
	    {
		  set TempAias =$ZCVT(##class(CT.WS.StdDictionary).ReplaceAsterisk(AAias),"U")
		  
		  Set GetWhereSql =" Where UPPER("_result.Data("DicAliasCol")_") Like '"_TempAias_"' "
	    }
	}
 if (result.Data("DicCodeCol")'="")
 {  
 if (ACode '="")
	    {
		  set TempDicCode = $ZCVT(##class(CT.WS.StdDictionary).ReplaceAsterisk(ACode),"U")
		  
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
		  set TempDesc =$ZCVT(##class(CT.WS.StdDictionary).ReplaceAsterisk(ADesc),"U")
		  
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
 s GetWhereSql=##class(CT.WS.StdDictionary).SwitchWhere(result.Data("TableName"),GetWhereSql)
 //

 if GetWhereSql '=""
 {
	 set GetCountSql = GetCountSql_GetWhereSql   
	 }
 ;s ^gjbtest("GetCountSql")=GetCountSql
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

ClassMethod SwitchFromTable(parOldFromTable As %String) As %String
{
	//ICD
	q:(parOldFromTable="SQLUser.MRC_ICDDx") "SQLUser.MRC_ICDDx, SQLUser.MRC_ICDAlias"
	//Operation
	q:(parOldFromTable="SQLUser.ORC_Operation") "SQLUser.ORC_Operation, SQLUser.ORC_OperationAlias"
	q parOldFromTable
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

/* bak
	q:((parOldFromTable="SQLUser.MRC_ICDDx")&&(parOldWhere="")) " where MRCID_ICD9CM_Code is NOT null AND ALIAS_ParRef=MRCID_Rowid "
	q:(parOldFromTable="SQLUser.MRC_ICDDx") parOldWhere_" and ALIAS_ParRef=MRCID_Rowid and MRCID_ICD9CM_Code is NOT null "
	;Operation
	q:((parOldFromTable="SQLUser.ORC_Operation")&&(parOldWhere="")) " where OPER_Code is NOT null AND ALIAS_ParRef=OPER_Rowid "
	q:(parOldFromTable="SQLUser.ORC_Operation") parOldWhere_" and ALIAS_ParRef=OPER_Rowid and OPER_Code is NOT null "

*/
ClassMethod CheckGBContain(AVesselStr As %String, ACompStr As %String) As %String
{
  s Result = 0
  if ((AVesselStr="")||(AVesselStr=$C(0)))
  {
	s Result = 0 
	  }
  Elseif ((AVesselStr="")||(AVesselStr=$C(0)))
  {
	s Result = 0 
	  }
   else
   {
	 s ReCom =##class(EPRservice.Utility).CheckGBContain(AVesselStr,ACompStr) 
	 if (ReCom="True")
	 {
	   s Result = 1 	 
		 }
		 
	   }	  
  	  
  Q:Result
}

Query GetStdDicList(ADicCode As %String, AAias As %String, Acode As %String, ADesc As %String, APageNum As %Integer, ARowCount As %Integer) As %Query(ROWSPEC = "ID:%String,Alias:%String,Code:%String,DicDesc:%String")
{
}

Query GetStdDicOrList(ADicCode As %String, AItem As %String, APageNum As %Integer, ARowCount As %Integer, ASessionId As %String) As %Query(ROWSPEC = "ID:%String,DicAlias:%String,DicCode:%String,DicDesc:%String")
{
}

/// modify by Candyxu 20120607 按顺序排列
Query SELECTALL() As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID:%Integer,Code:%String,Name:%String,Description:%String,TableName:%String,DicCodeCol:%String,DicDescCol:%String,DicAliasCol:%String,Condition:%String,ConditionCode:%String,SystemCode:%String", SELECTMODE = "RUNTIME") [ SqlName = SP_StdDictionary_SELECTALL, SqlProc ]
{
SELECT %ID,Code,Name,Description,TableName,DicCodeCol,DicDescCol,DicAliasCol,Condition,ConditionCode,SystemCode
 FROM CT_WS.StdDictionary
 ORDER BY Sequence
}

/*
/// modify by Candyxu 20120607 按顺序排列
Query SELECTALL() As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID:%Integer,Code:%String,Name:%String,Description:%String,TableName:%String,DicCodeCol:%String,DicDescCol:%String,DicAliasCol:%String,Condition:%String,ConditionCode:%String", SELECTMODE = "RUNTIME") [ SqlName = SP_StdDictionary_SELECTALL, SqlProc ]
{
SELECT %ID,Code,Name,Description,TableName,DicCodeCol,DicDescCol,DicAliasCol,Condition,ConditionCode
 FROM eprmeta.StdDictionary
 ORDER BY Sequence
}
*/

//Query SELECTALLByRuleTypeTag(RuleTypeTag As %String) As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID:%Integer,Code:%String,Name:%String,Description:%String,TableName:%String,DicCodeCol:%String,DicDescCol:%String,DicAliasCol:%String,Condition:%String,ConditionCode:%String", SELECTMODE = "RUNTIME") [ SqlName = SP_StdDictionary_SELECTALLByRuleTypeTag, SqlProc ]

//{

// SELECT %ID,Code,Name,Description,TableName,DicCodeCol,DicDescCol,DicAliasCol,Condition,ConditionCode

// FROM CT_WS.StdDictionary

// WHERE RuleTypeTag=:RuleTypeTag

//}

///          d ##Class(%ResultSet).RunQuery("CT.WS.StdDictionary","SELECTALLByRuleTypeTag","PATDEPT")

Storage Default
{
<Data name="StdDictionaryDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Code</Value>
</Value>
<Value name="3">
<Value>Description</Value>
</Value>
<Value name="4">
<Value>DicAliasCol</Value>
</Value>
<Value name="5">
<Value>DicCodeCol</Value>
</Value>
<Value name="6">
<Value>DicDescCol</Value>
</Value>
<Value name="7">
<Value>IsRuleType</Value>
</Value>
<Value name="8">
<Value>Name</Value>
</Value>
<Value name="9">
<Value>RuleTypeTag</Value>
</Value>
<Value name="10">
<Value>TableName</Value>
</Value>
<Value name="11">
<Value>ConditionCode</Value>
</Value>
<Value name="12">
<Value>Condition</Value>
</Value>
<Value name="13">
<Value>IsDiagnosRuleType</Value>
</Value>
<Value name="14">
<Value>Sequence</Value>
</Value>
<Value name="15">
<Value>SystemCode</Value>
</Value>
</Data>
<DataLocation>^DHCCTWS.StdDictionaryD</DataLocation>
<DefaultData>StdDictionaryDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCCTWS.StdDictionaryD</IdLocation>
<IndexLocation>^DHCCTWS.StdDictionaryI</IndexLocation>
<StreamLocation>^DHCCTWS.StdDictionaryS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
