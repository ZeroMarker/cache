/// DHC Web Medical Record runtime quality monitor 
/// AutoCheckRule expression explain ACR表达式解析
/// By wuqk 2007-12
Class web.DHCWMRQuality.BOACRExpExplain Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 11;

ClassMethod ExplainACRExp(ACRExp As %String, EpisodeID As %String, TemplateID As %String, InstanceID As %String) As %String
{
	New (ACRExp,EpisodeID,TemplateID,InstanceID)
	Set ret=""
	Quit:EpisodeID="" +ret
	Quit:ACRExp="" +ret
	Quit:'$d(^PAADM(+EpisodeID)) +ret
	
	;s ^Cachetemp("BOACRExpExplain",$j,EpisodeID,"EpisodeID")=EpisodeID
	;s ^Cachetemp("BOACRExpExplain",$j,EpisodeID,"ACRExp")=ACRExp
	;Set ACRExp=##class(web.DHCWMRExamACRCtl).GetACRExpByRCode(ACRExp)
	
	;Set $ZT="PutErrorMsg^DHCWMRError"
	Set $ZT="PutErrorMsg"
	
	Set PatientID=+$p($g(^PAADM(+EpisodeID)),"^",1)
	Set EPRSplit="EPR."
	;Set ExpSplit="/"     ;by wuqk 2008-08-07 根据合肥需求，ACR规则表达式用$c(4)分割
	Set ExpSplit=$c(4)
	;"A/$P($g(`PAADM(EpisodeID)),""`"",6)/$P($g(`PAADM(EpisodeID)),""`"",7)/EPR.TemplateID.501.S0001//>/8"
	;
	//转移符表达式中含有"^",但是"^"是cache存储时的关键字,用来作为字段的分隔符
	//因此,在存储ACR表达式时,将"^"存储为"`"
	//解析表达式时,需要将"`"还原成"^"
	Set ACRExp=$tr(ACRExp,"`","^")
	
	Set ACRExpType=$p(ACRExp,ExpSplit,1)
	
	If (ACRExpType="A")
	{
		Set ret=..AExplain()
	}
	ElseIf (ACRExpType="B")
	{}
	ElseIf (ACRExpType="Z")
	{
		Set ret=..ZExplain()
	}
		  
	Quit ret
PutErrorMsg
   Set Val=$ZERROR
   Set Ret="-1 "_Val
   Quit Ret
}

/// ;(ACRExp, EPRSplit, EpisodeID)
/// ;
/// Set EpisodeID=120296
/// Set EPRSplit="EPR."
/// set ACRExp="A/$P($g(^PAADM(EpisodeID)),""^"",6)/$P($g(^PAADM(EpisodeID)),""^"",7)/EPR.TemplateID.501.S0001//>/8"
ClassMethod AExplain()
{
	;n (ACRExp,EPRSplit,EpisodeID)
	/*
	set ttACRExp="A/$P($g(^PAADM(EpisodeID)),""^"",6)/$P($g(^PAADM(EpisodeID)),""^"",7)/EPR.TId.501.S0001//>/8"
	w !,"ACRExp="_ACRExp
	w !,"tCRExp="_ttACRExp
	*/
	Set ret=""
	Set Operator=$p(ACRExp,ExpSplit,6)
	Set OperatVal=$p(ACRExp,ExpSplit,7)    ;unit Hour
	
	for index=2:1:5 
	{
		Set tmpPara=$p(ACRExp,ExpSplit,index)
		
		If tmpPara[EPRSplit
		{
			;Set Val=##class(web.DHCWMRQuality.BOSystemData).GetEPRData(tmpPara,EpisodeID)
			Set Val=..GetEPRElement(tmpPara,EPRSplit,EpisodeID)
			Set Val=""""_Val_""""
		}
		ElseIf tmpPara=""
		{
		    Set Val=""""_tmpPara_""""
		}
		Else
		{
			Set Val=tmpPara
		}
		Set:Val["-" Val=$zdh(Val,3)          //Add by wuqk 2008-08-06 解析描述性日期和时间格式的参数
		Set:Val[":" Val=$zth(Val)
		Set Para="Para"_index_"="_Val
		Set @Para
	}
	
	If OperatVal[EPRSplit
	{
		Set OperatVal=..GetEPRElement(OperatVal,EPRSplit,EpisodeID)
	}
	
	Set NewExpression="result1=##class(web.DHCWMRQuality.BOCommonFunctions).GetHours(Para2,Para3,Para4,Para5)"
	Set @NewExpression
	Set NewExpression="result2="_OperatVal
	Set @NewExpression
	If ($ISVALIDNUM(result1))&($ISVALIDNUM(result2))
	{
		Set result1=+result1
		Set result2=+result2
	}
	Set NewResult="ret=(result1"_Operator_"result2)"	
	Set @NewResult
	
	Quit +ret
}

ClassMethod ZExplain()
{
	/*
	Set EpisodeID=120296
	Set EPRSplit="EPR."
	set ACRExp="Z/##class(web.DHCWMRQuality.BOSystemData).GetEPRData(EPR.IstCreateUser.501,EpisodeID)/=/$h"
	*/
	;n (ACRExp,EPRSplit,EpisodeID)
	;
	
	Set ret=""
	Set tmpExp=$p(ACRExp,ExpSplit,2)
	Set Operator=$p(ACRExp,ExpSplit,3)
	Set OperatVal=$p(ACRExp,ExpSplit,4)    
	;Set TransfExp=$p(tmpExp,EPRSplit)
	If tmpExp[EPRSplit
	{
		Set tmpExp=..GetEPRElement(tmpExp,EPRSplit,EpisodeID)
		/*
		Set tmpLen=$l(tmpExp,EPRSplit)
		for index=2:1:tmpLen
		{
			Set tmpPara=$p(tmpExp,EPRSplit,index)
			Set tmpParaLen=$l(tmpPara)
			Set tmpEPRElement=""
			Set ElseElement=""
			Set outFlag=1
			for jndex=1:1:tmpParaLen
			{
				Set sLetter=$e(tmpPara,jndex,jndex)
				If outFlag
				{
					Set outFlag=##class(web.DHCWMRQuality.BOCommonFunctions).IsAccordLetter(sLetter)
					If outFlag {Set tmpEPRElement=tmpEPRElement_sLetter}
					Else {Set ElseElement=ElseElement_sLetter}
				}
				Else{
					Set ElseElement=ElseElement_sLetter
				}
			}
			
			Set EPRElement=EPRSplit_tmpEPRElement
			Set Val=##class(web.DHCWMRQuality.BOSystemData).GetEPRData(EPRElement,EpisodeID)
			Set Val=""""_Val_""""
			Set TransfExp=TransfExp_Val_ElseElement
		}
		*/
	}
	If OperatVal[EPRSplit
	{
		Set OperatVal=..GetEPRElement(OperatVal,EPRSplit,EpisodeID)
		
	}
	If OperatVal=" "
		{
		    Set OperatVal=""
		}
	/*     //remove by wuqk 2008-08-06 数值类型判断放在转移符操作之后进行
    If '($ISVALIDNUM(OperatVal))
	{
		Set OperatVal=""""_OperatVal_""""
	}
	*/
	//If (OperatVal'["##class")&(OperatVal'["$p")&(OperatVal'["##CLASS")
	/*
	If (OperatVal'["##")&(OperatVal'["$")
	{
		If '($ISVALIDNUM(OperatVal))
		{
			//为字符串类型增加引号
			Set OperatVal=""""_OperatVal_""""
		}
	}
	//If (tmpExp'["##class")&(tmpExp'["$p")&(tmpExp'["##CLASS")
	If (tmpExp'["##")&(tmpExp'["$")
	{
		If '($ISVALIDNUM(tmpExp))
		{
			//为字符串类型增加引号
			Set tmpExp=""""_tmpExp_""""
		}
	}
	*/
	Set NewExpression="result1="_tmpExp
	Set @NewExpression
	Set NewExpression="result2="_OperatVal
	Set @NewExpression
	
	If ($ISVALIDNUM(result1))&($ISVALIDNUM(result2))
	{
		Set result1=+result1
		Set result2=+result2
	}
	else      ;add  by wuqk 2008-08-06 数值类型判断
	{
		if $ISVALIDNUM(result1)
		{
			set result1=""""_result1_""""
        }
		if $ISVALIDNUM(result2)
		{
			set result2=""""_result2_""""
        }
    }
	Set NewResult="ret=(result1"_Operator_"result2)"
	Set @NewResult
	Quit +ret
}

ClassMethod GetEPRElement(tmpExp, EPRSplit, EpisodeID, PatientID)
{
	n (tmpExp,EPRSplit,EpisodeID,PatientID)
	Set TransfExp=$p(tmpExp,EPRSplit)
	
    Set tmpLen=$l(tmpExp,EPRSplit)
    for index=2:1:tmpLen
    {
	    Set tmpPara=$p(tmpExp,EPRSplit,index)
	    Set tmpParaLen=$l(tmpPara)
	    Set tmpEPRElement=""
	    Set ElseElement=""
	    Set outFlag=1
	    for jndex=1:1:tmpParaLen
	    {
		    
		    Set sLetter=$e(tmpPara,jndex,jndex)
		    If outFlag
		    {
					Set outFlag=##class(web.DHCWMRQuality.BOCommonFunctions).IsAccordLetter(sLetter)
					If outFlag {Set tmpEPRElement=tmpEPRElement_sLetter}
					Else {Set ElseElement=ElseElement_sLetter}
		    }
		    Else{
					Set ElseElement=ElseElement_sLetter
		    }
	    }
			
	    Set EPRElement=EPRSplit_tmpEPRElement
	    Set Val=##class(web.DHCWMRQuality.BOSystemData).GetEPRData(EPRElement,EpisodeID)
	    Set Val=""""_Val_""""
	    Set TransfExp=TransfExp_Val_ElseElement
	}
	Quit TransfExp
}

}
