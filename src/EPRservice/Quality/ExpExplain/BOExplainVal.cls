/// ************************************************************
/// * Class Name:	EPRservice.Quality.ExpExplain.BOExplainVal
/// * Description:	解析表达式
/// * Author:		Zuoxiang Xie
/// * Create Date:	2010-05-23
/// * Version:		
/// ************************************************************/
Class EPRservice.Quality.ExpExplain.BOExplainVal Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Desc:	解析并执行质控规则表达式;
/// Input:	AEpisodeID为患者就诊号;
/// 		AEntryID为质控项目RowID;
/// 		AInstanceID为实例数据RowID;
/// Output:	满足条件则返回1;否则返回-1;
/// Debug:	w ##Class(EPRservice.Quality.ExpExplain.BOExplainVal).GetExplainVal("76","2","")
ClassMethod GetExplainVal(AEpisodeID As %String, AEntryID As %String, AInstanceID As %String, AUniqueKey As %String) As %String
{
	n (AEpisodeID, AEntryID, AInstanceID,AUniqueKey)

	s ret = 0
	q:(AEpisodeID = "")||(AEntryID = "") ret
	q:($d(AEpisodeID) = 0)||($d(AEntryID) = 0) ret
	
	s $zt = "CatchExplainEntryError"
	
	s EpisodeID  = $g(AEpisodeID)
	s EntryID 	 = $g(AEntryID)
	s InstanceID = $g(AInstanceID)
	s UniqueKey = $g(AUniqueKey)
		
	s PoolID = $list($g(^DHCEPRM.QualityEntryD(+EntryID)),1)
	q:(PoolID = "") ret
	
	s StructID = $list($g(^DHCEPRM.QualityEntryD(+EntryID)),3)
	q:(StructID = "") ret
	
	s Expression = $list($g(^DHCEPRM.QualityPoolD(PoolID)),3)
	s tmpExp = Expression
	q:(tmpExp = "") ret

	s flag = 1
	While ((..IsExpError(tmpExp))&&(flag = 1))
	{
		s left  = $p(tmpExp,"{",1)
		s param = $p($p(tmpExp,"{",2),"}",1)
		s right = $p(tmpExp,"}",2)

		if ($e(param,1,1) = "EC")&&(+$e(param,3,$l(param)) = $e(param,3,$l(param))) 
		{
			s tmpVal = ##Class(EPRservice.Quality.CheckRule.Template).GetSingleValues(EpisodeID,param)
		} 
		elseif ($e(param,1,1) = "E")&&(+$e(param,2,$l(param)) = $e(param,2,$l(param))) 
		{
			s tmpVal = ##Class(EPRservice.Quality.CheckRule.Template).GetSingleValues(EpisodeID,param)
		} 
		elseif($e(param,1,1) = "M") && (+$e(param,2,$l(param))=$e(param,2,$l(param)))
		{
			s tmpVal = ##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(EpisodeID,param,"")
		}	
		else 
		{
			s tmpVal = ..GetQualityParamValue(EpisodeID,param,StructID)
		}
		
		s:($e(tmpVal,1,2) = "0^") flag = 0
		q:($e(tmpVal,1,2) = "0^")
		
		s tmpVal = $e(tmpVal,3,$l(tmpVal))
		s:(tmpVal["##C")||(tmpVal["##c") tmpVal = $tr(tmpVal,"#","")
		s:(tmpVal [ """") tmpVal = ##Class(EPRservice.Quality.CommonHelper).ChangeString(tmpVal,"""","""""")
		//s:'$ISVALIDNUM(tmpVal) tmpVal=""""_tmpVal_""""
		s param = "{"_param_"}"
		s:(tmpExp '= param) tmpVal = """"_tmpVal_""""

		s tmpExp11 = ""
		for Ind = 1:1:($l(tmpExp,param) - 1) 
		{
			s:(Ind = 1) tmpExp11 = $p(tmpExp,param,1)
			s tmpExp11 = tmpExp11_tmpVal_$p(tmpExp,param,Ind+1)
		}
		s tmpExp = tmpExp11
	}
	q:(tmpExp [ "{")||(tmpExp [ "}") ret
	q:(flag = 0) ret

	if ((tmpExp["##C")||(tmpExp["##c"))	
	{	 
		s newExp = "ret="_tmpExp
		s @newExp
	} 
	elseif ($ISVALIDNUM(tmpExp)) 
	{
		s ret = +tmpExp
	} 
	else 
	{
		s ret = tmpExp
	}
	q ret
	
CatchExplainEntryError
   	s error = $ZERROR
   	s ^CacheTemp("EPRQuality","ExplainEntryError",EpisodeID,EntryID) = $zd($h,3)_":"_error
   	q ret
}

/// Desc:	解析并执行质控规则表达式;
/// Input:	AEpisodeID为患者就诊号;
/// 		AEntryID为质控项目RowID;
/// 		AInstanceID为实例数据RowID;
/// Output:	满足条件则返回1;否则返回-1;
/// Debug:	w ##Class(EPRservice.Quality.ExpExplain.BOExplainVal).GetExplainValNew("76","2","")
ClassMethod GetExplainValNew(AEpisodeID As %String, AEntryID As %String, AInstanceID As %String, AUniqueKey As %String) As %String
{
	n (AEpisodeID, AEntryID, AInstanceID,AUniqueKey)

	s ret = 0
	q:(AEpisodeID = "")||(AEntryID = "") ret
	q:($d(AEpisodeID) = 0)||($d(AEntryID) = 0) ret
	
	s $zt = "CatchExplainEntryErrorNew"
	
	s EpisodeID  = $g(AEpisodeID)
	s EntryID 	 = $g(AEntryID)
	s InstanceID = $g(AInstanceID)
	s UniqueKey = $g(AUniqueKey)	
	s PoolID = $list($g(^CT.MA.QC.QualityEntryD(+EntryID)),3)
	q:(PoolID = "") ret
	
	s StructID = $list($g(^CT.MA.QC.QualityEntryD(+EntryID)),4)
	q:(StructID = "") ret
	
	s Expression = $list($g(^CT.MA.QC.QualityPoolD(PoolID)),3)
	s tmpExp = Expression
	q:(tmpExp = "") ret

	s flag = 1
	While ((..IsExpError(tmpExp))&&(flag = 1))
	{
		s left  = $p(tmpExp,"{",1)
		s param = $p($p(tmpExp,"{",2),"}",1)
		s right = $p(tmpExp,"}",2)

		if ($e(param,1,1) = "EC")&&(+$e(param,3,$l(param)) = $e(param,3,$l(param))) 
		{
			s tmpVal = ##Class(EPRservice.Quality.CheckRule.Template).GetSingleValues(EpisodeID,param)
		} 
		elseif ($e(param,1,1) = "E")&&(+$e(param,2,$l(param)) = $e(param,2,$l(param))) 
		{
			s tmpVal = ##Class(EPRservice.Quality.CheckRule.Template).GetSingleValues(EpisodeID,param)
		} 
		elseif($e(param,1,1) = "M") && (+$e(param,2,$l(param))=$e(param,2,$l(param)))
		{
			s tmpVal = ##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValueNew(EpisodeID,param,"")
		}	
		else 
		{
			s tmpVal = ..GetQualityParamValueNew(EpisodeID,param,StructID)
		}
		
		s:($e(tmpVal,1,2) = "0^") flag = 0
		q:($e(tmpVal,1,2) = "0^")
		
		s tmpVal = $e(tmpVal,3,$l(tmpVal))
		s:(tmpVal["##C")||(tmpVal["##c") tmpVal = $tr(tmpVal,"#","")
		s:(tmpVal [ """") tmpVal = ##Class(EPRservice.Quality.CommonHelper).ChangeString(tmpVal,"""","""""")
		//s:'$ISVALIDNUM(tmpVal) tmpVal=""""_tmpVal_""""
		s param = "{"_param_"}"
		s:(tmpExp '= param) tmpVal = """"_tmpVal_""""

		s tmpExp11 = ""
		for Ind = 1:1:($l(tmpExp,param) - 1) 
		{
			s:(Ind = 1) tmpExp11 = $p(tmpExp,param,1)
			s tmpExp11 = tmpExp11_tmpVal_$p(tmpExp,param,Ind+1)
		}
		s tmpExp = tmpExp11
	}
	q:(tmpExp [ "{")||(tmpExp [ "}") ret
	q:(flag = 0) ret

	if ((tmpExp["##C")||(tmpExp["##c"))	
	{	 
		s newExp = "ret="_tmpExp
		s @newExp
	} 
	elseif ($ISVALIDNUM(tmpExp)) 
	{
		s ret = +tmpExp
	} 
	else 
	{
		s ret = tmpExp
	}
	q ret
	
CatchExplainEntryErrorNew
   	s error = $ZERROR
   	s ^CacheTemp("EPRQuality","ExplainEntryError",EpisodeID,EntryID) = $zd($h,3)_":"_error
   	q ret
}

/// Desc:	解析并执行质控检查条件表达式;
/// Input:	AEpisodeID为患者就诊号;
/// 		AQueryID为检查条件RowID;
/// Output:	满足条件返回1;否则返回-1;
/// Debug:	w ##Class(EPRservice.Quality.ExpExplain.BOExplainVal).GetQualityQueryValue("76","1")
ClassMethod GetQualityQueryValue(AEpisodeID As %String, AQueryID As %String, AStructID As %String)
{
	n (AEpisodeID, AQueryID, AStructID)
		
	s ret = 0
	q:(AEpisodeID = "")||(AQueryID = "") ret
	q:($d(AEpisodeID) = 0)||($d(AQueryID) = 0) ret
	
	s $zt = "CatchExplainQueryError"
	
	s EpisodeID = $g(AEpisodeID)
	s QueryID 	= $g(AQueryID)
	s StructID  = $g(AStructID)
	
	s Expression = $list($g(^DHCEPRM.QualityQueryD(QueryID)),3)
	q:(Expression = "") ret
	
	s flag = 1
	While ((..IsExpError(Expression)) && (flag = 1))
	{
		s left  = $p(Expression,"{",1)
		s param = $p($p(Expression,"{",2),"}",1)
		s right = $p(Expression,"}",2)
		
		if ($e(param,1,1) = "EC") && (+$e(param,3,$l(param))=$e(param,3,$l(param)))
		{
			s tmpVal = ##Class(EPRservice.Quality.CheckRule.Template).GetSingleValues(EpisodeID,param)
		} 
		elseif ($e(param,1,1) = "E") && (+$e(param,2,$l(param))=$e(param,2,$l(param)))
		{
			s tmpVal = ##Class(EPRservice.Quality.CheckRule.Template).GetSingleValues(EpisodeID,param)
		} 
		elseif($e(param,1,1) = "M") && (+$e(param,2,$l(param))=$e(param,2,$l(param)))
		{
			s tmpVal = ##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(EpisodeID,param,"")
		}
		else 
		{
			s tmpVal = ..GetQualityParamValue(EpisodeID,param,StructID)
		}
		
		s:($e(tmpVal,1,2) = "0^") flag = 0
		q:($e(tmpVal,1,2) = "0^")
		
		s tmpVal = $e(tmpVal,3,$l(tmpVal))
		s:(tmpVal["##C")||(tmpVal["##c") tmpVal = $tr(tmpVal,"#","")
		s:(tmpVal [ """") tmpVal = ##Class(EPRservice.Quality.CommonHelper).ChangeString(tmpVal,"""","""""")
		//s:'$ISVALIDNUM(tmpVal) tmpVal=""""_tmpVal_""""
		s param = "{"_param_"}"
		s:(Expression '= param) tmpVal = """"_tmpVal_""""
		s tmpExp11 = ""
		for Ind = 1:1:($l(Expression,param) - 1) 
		{
			s:(Ind = 1) tmpExp11 = $p(Expression,param,1)
			s tmpExp11 = tmpExp11_tmpVal_$p(Expression,param,Ind+1)
		}
		s Expression = tmpExp11
	}
	q:(Expression [ "{")||(Expression [ "}") ret
	q:(flag = 0) ret
		
	if ($ISVALIDNUM(Expression))
	{  
		s ret = +Expression
	}
	else
	{               
		s newExp = "ret=+("_Expression_")"
		s @newExp
	}
	q ret
	
CatchExplainQueryError
   	s error = $ZERROR
   	s ^CacheTemp("EPRQuality","ExplainQueryError",EpisodeID,QueryID) = $zd($h,3)_":"_error
	q ret
}

/// Desc:	解析并执行质控检查条件表达式;
/// Input:	AEpisodeID为患者就诊号;
/// 		AQueryID为检查条件RowID;
/// Output:	满足条件返回1;否则返回-1;
/// Debug:	w ##Class(EPRservice.Quality.ExpExplain.BOExplainVal).GetQualityQueryValueNew("70","9","14")
ClassMethod GetQualityQueryValueNew(AEpisodeID As %String, AQueryID As %String, AStructID As %String)
{
	n (AEpisodeID, AQueryID, AStructID)
		
	s ret = 0
	q:(AEpisodeID = "")||(AQueryID = "") ret
	q:($d(AEpisodeID) = 0)||($d(AQueryID) = 0) ret
	
	s $zt = "CatchExplainQueryErrorNew"
	
	s EpisodeID = $g(AEpisodeID)
	s QueryID 	= $g(AQueryID)
	s StructID  = $g(AStructID)
	
	s Expression = $list($g(^CT.MA.QC.QualityQueryD(QueryID)),4)
	q:(Expression = "") ret

	s flag = 1
	While ((..IsExpError(Expression)) && (flag = 1))
	{
		s left  = $p(Expression,"{",1)
		s param = $p($p(Expression,"{",2),"}",1)
		s right = $p(Expression,"}",2)
		
		if ($e(param,1,1) = "EC") && (+$e(param,3,$l(param))=$e(param,3,$l(param))) 
		{
			s tmpVal = ##Class(EPRservice.Quality.CheckRule.Template).GetSingleValues(EpisodeID,param)
		} 
		elseif ($e(param,1,1) = "E") && (+$e(param,2,$l(param))=$e(param,2,$l(param)))
		{
			s tmpVal = ##Class(EPRservice.Quality.CheckRule.Template).GetSingleValues(EpisodeID,param)
		} 
		elseif($e(param,1,1) = "M") && (+$e(param,2,$l(param))=$e(param,2,$l(param)))
		{
			s tmpVal = ##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValueNew(EpisodeID,param,"")
		}
		else 
		{
			s tmpVal = ..GetQualityParamValueNew(EpisodeID,param,StructID)
		}
		
		s:($e(tmpVal,1,2) = "0^") flag = 0
		q:($e(tmpVal,1,2) = "0^")
		
		s tmpVal = $e(tmpVal,3,$l(tmpVal))
		s:(tmpVal["##C")||(tmpVal["##c") tmpVal = $tr(tmpVal,"#","")
		s:(tmpVal [ """") tmpVal = ##Class(EPRservice.Quality.CommonHelper).ChangeString(tmpVal,"""","""""")
		//s:'$ISVALIDNUM(tmpVal) tmpVal=""""_tmpVal_""""
		s param = "{"_param_"}"
		s:(Expression '= param) tmpVal = """"_tmpVal_""""
		s tmpExp11 = ""
		for Ind = 1:1:($l(Expression,param) - 1) 
		{
			s:(Ind = 1) tmpExp11 = $p(Expression,param,1)
			s tmpExp11 = tmpExp11_tmpVal_$p(Expression,param,Ind+1)
		}
		s Expression = tmpExp11
	}
	q:(Expression [ "{")||(Expression [ "}") ret
	q:(flag = 0) ret
		
	if ($ISVALIDNUM(Expression))
	{  
		s ret = +Expression
	}
	else
	{               
		s newExp = "ret=+("_Expression_")"
		s @newExp
	}
	q ret
	
CatchExplainQueryErrorNew
   	s error = $ZERROR
   	s ^CacheTemp("EPRQuality","ExplainQueryError",EpisodeID,QueryID) = $zd($h,3)_":"_error
	q ret
}

/// Desc:	解析并执行质控公共函数表达式;
/// Input:	AEpisodeID为患者就诊号;
/// 		AParamCode为公共函数代码;
/// Output:	满足条件返回1;否则返回-1;
/// Debug:	w ##Class(EPRservice.Quality.ExpExplain.BOExplainVal).GetQualityParamValue("2408173","HISAdmitInRecord","312")
ClassMethod GetQualityParamValue(AEpisodeID As %String, AParamCode As %String, AStructID As %String) As %String
{
	n (AEpisodeID, AParamCode, AStructID)
	
	s ret = "0^"
	q:(AEpisodeID = "")||(AParamCode = "") ret
	q:($d(AEpisodeID) = 0)||($d(AParamCode) = 0) ret
	
	s $zt = "CatchExplainParamError"
	
	s EpisodeID = $g(AEpisodeID)
	s ParamCode = $g(AParamCode)
	s StructID  = $g(AStructID)
	
	s ParamID = $o(^DHCEPRM.QualityParamsI("IdxCode",ParamCode,""))
	q:(+ParamID = 0) ret
	
	s Expression = $list($g(^DHCEPRM.QualityParamsD(ParamID)),2)
	q:(Expression = "") ret
	s Expression = $tr(Expression,$c(13),"")
	s Expression = $tr(Expression,$c(10),"")
	
	s flag = 1
	While ((..IsExpError(Expression))&&(flag = 1))
	{
		s left  = $p(Expression,"{",1)
		s param = $p($p(Expression,"{",2),"}",1)
		s right = $p(Expression,"}",2)
		
		if ($e(param,1,1) = "EC")&&(+$e(param,3,$l(param)) = $e(param,3,$l(param))) 
		{
			s tmpVal = ##Class(EPRservice.Quality.CheckRule.Template).GetSingleValues(EpisodeID,param)
		} 
		elseif ($e(param,1,1) = "E")&&(+$e(param,2,$l(param)) = $e(param,2,$l(param))) 
		{
			s tmpVal = ##Class(EPRservice.Quality.CheckRule.Template).GetSingleValues(EpisodeID,param)
		}
		elseif($e(param,1,1) = "M") && (+$e(param,2,$l(param))=$e(param,2,$l(param)))
		{
			s tmpVal = ##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(EpisodeID,param,"")
		}		 
		else 
		{
			s tmpVal = ..GetQualityParamValue(EpisodeID,param,StructID)
		}
		
		s:($e(tmpVal,1,2) = "0^") flag = 0
		q:($e(tmpVal,1,2) = "0^")
		
		s tmpVal = $e(tmpVal,3,$l(tmpVal))
		s:(tmpVal [ "##C")||(tmpVal [ "##c") tmpVal = $tr(tmpVal,"#","")
		s:(tmpVal [ """") tmpVal = ##Class(EPRservice.Quality.CommonHelper).ChangeString(tmpVal,"""","""""")
		//s:'$ISVALIDNUM(tmpVal) tmpVal=""""_tmpVal_""""
		s param = "{"_param_"}"
		s:(Expression '= param) tmpVal = """"_tmpVal_""""
		
		s tmpExp11 = ""
		for Ind = 1:1:($l(Expression,param) - 1) 
		{
			s:(Ind = 1) tmpExp11 = $p(Expression,param,1)
			s tmpExp11 = tmpExp11_tmpVal_$p(Expression,param,Ind+1)
		}
		s Expression = tmpExp11
	}
	q:(Expression["{")||(Expression["}") ret
	q:(flag = 0) ret

	if ((Expression [ "##C")||(Expression [ "##c"))
	{  
		s newExp = "ret="_Expression
		s @newExp
	} 
	elseif $ISVALIDNUM(Expression)
	{  
		s ret = Expression
	} 
	else
	{   
		s ret = Expression
	}
	
	// 公共函数返回值带 ^ 的情况处理
	s:($e(ret,0,3) '[ "^") ret = "1^"_ret
	q ret
	
CatchExplainParamError
   	s error = $ZERROR
   	s ^CacheTemp("EPRQuality","ExplainParamError",EpisodeID,ParamID) = $zd($h,3)_":"_error
	q ret
}

/// Desc:	解析并执行质控公共函数表达式;
/// Input:	AEpisodeID为患者就诊号;
/// 		AParamCode为公共函数代码;
/// Output:	满足条件返回1;否则返回-1;
/// Debug:	w ##Class(EPRservice.Quality.ExpExplain.BOExplainVal).GetQualityParamValueNew("2408173","HISAdmitInRecord","312")
ClassMethod GetQualityParamValueNew(AEpisodeID As %String, AParamCode As %String, AStructID As %String) As %String
{
	n (AEpisodeID, AParamCode, AStructID)
	
	s ret = "0^"
	q:(AEpisodeID = "")||(AParamCode = "") ret
	q:($d(AEpisodeID) = 0)||($d(AParamCode) = 0) ret
	
	s $zt = "CatchExplainParamErrorNew"
	
	s EpisodeID = $g(AEpisodeID)
	s ParamCode = $g(AParamCode)
	s StructID  = $g(AStructID)
	
	s ParamID = $o(^CT.MA.QC.QualityParamsI("IdxCode",ParamCode,""))
	q:(+ParamID = 0) ret
	
	s Expression = $list($g(^CT.MA.QC.QualityParamsD(ParamID)),2)
	q:(Expression = "") ret
	s Expression = $tr(Expression,$c(13),"")
	s Expression = $tr(Expression,$c(10),"")
	
	s flag = 1
	While ((..IsExpError(Expression))&&(flag = 1))
	{
		s left  = $p(Expression,"{",1)
		s param = $p($p(Expression,"{",2),"}",1)
		s right = $p(Expression,"}",2)
		
		if ($e(param,1,1) = "EC")&&(+$e(param,3,$l(param)) = $e(param,3,$l(param))) 
		{
			s tmpVal = ##Class(EPRservice.Quality.CheckRule.Template).GetSingleValues(EpisodeID,param)
		} 
		elseif ($e(param,1,1) = "E")&&(+$e(param,2,$l(param)) = $e(param,2,$l(param))) 
		{
			s tmpVal = ##Class(EPRservice.Quality.CheckRule.Template).GetSingleValues(EpisodeID,param)
		}
		elseif($e(param,1,1) = "M") && (+$e(param,2,$l(param))=$e(param,2,$l(param)))
		{
			s tmpVal = ##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValueNew(EpisodeID,param,"")
		}		 
		else 
		{
			s tmpVal = ..GetQualityParamValueNew(EpisodeID,param,StructID)
		}
		
		s:($e(tmpVal,1,2) = "0^") flag = 0
		q:($e(tmpVal,1,2) = "0^")
		
		s tmpVal = $e(tmpVal,3,$l(tmpVal))
		s:(tmpVal [ "##C")||(tmpVal [ "##c") tmpVal = $tr(tmpVal,"#","")
		s:(tmpVal [ """") tmpVal = ##Class(EPRservice.Quality.CommonHelper).ChangeString(tmpVal,"""","""""")
		//s:'$ISVALIDNUM(tmpVal) tmpVal=""""_tmpVal_""""
		s param = "{"_param_"}"
		s:(Expression '= param) tmpVal = """"_tmpVal_""""
		
		s tmpExp11 = ""
		for Ind = 1:1:($l(Expression,param) - 1) 
		{
			s:(Ind = 1) tmpExp11 = $p(Expression,param,1)
			s tmpExp11 = tmpExp11_tmpVal_$p(Expression,param,Ind+1)
		}
		s Expression = tmpExp11
	}
	q:(Expression["{")||(Expression["}") ret
	q:(flag = 0) ret

	if ((Expression [ "##C")||(Expression [ "##c"))
	{  
		s newExp = "ret="_Expression
		s @newExp
	} 
	elseif $ISVALIDNUM(Expression)
	{  
		s ret = Expression
	} 
	else
	{   
		s ret = Expression
	}
	s:(ret '[ "^") ret = "1^"_ret
	q ret
	
CatchExplainParamErrorNew
   	s error = $ZERROR
   	s ^CacheTemp("EPRQuality","ExplainParamError",EpisodeID,ParamID) = $zd($h,3)_":"_error
	q ret
}

/// Desc:	判断表达式是否合法有效
/// Input:	待检查表达式
/// Output:	1:有效;0:不合法;
/// Debug:	w ##Class(EPRservice.Quality.ExpExplain.BOExplainVal).IsExpError("")
ClassMethod IsExpError(AExpression As %String) As %String
{
	n (AExpression)
	
	s ret = 1	
	s Expression = $g(AExpression)
	s tmpExpls = ##Class(EPRservice.Quality.CommonHelper).GetListFromString(Expression,"{")
	for Ind = 2:1:$listlength(tmpExpls)
	{
		s tmpExp = $listget(tmpExpls,Ind)
		if (tmpExp '[ "}") 
		{
			s ret = 0
			q
		}
	}
	s tmpExpls = ##Class(EPRservice.Quality.CommonHelper).GetListFromString(Expression,"}")
	for Ind = 1:1:($listlength(tmpExpls) - 1)
	{
		s tmpExp = $listget(tmpExpls,Ind)
		if (tmpExp '[ "{")
		{
			s ret = 0
			q
		}
	}
	s:(Expression '[ "{")||(Expression '[ "}") ret = 0
	q ret
}

}
