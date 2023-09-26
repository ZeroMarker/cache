/// DHC Web Medical Record runtime quality monitor 
/// DHC_WMR_ExamEntry.Expression explain
/// By wuqk 2007-12
Class web.DHCWMRQuality.BOEntryExpExplain Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 24;

ClassMethod ExplainExamEntry(ExamEntry As %String, EpisodeID As %String, TemplateID As %String, InstanceID As %String) As %String
{
	n (ExamEntry,EpisodeID,TemplateID,InstanceID)
	Set ret=""
	
	Set ExamRuleDr=+ExamEntry
	Set ExamSecSub=+$p(ExamEntry,"||",2)
	Set ExamEntrySub=+$p(ExamEntry,"||",3)
	Set ExamSecDr=ExamRuleDr_"||"_ExamSecSub
		
	;ExamRule
	Set sExamRule=##class(web.DHCWMRQualityBaseCtl).GetERById(ExamRuleDr)
	Set RuleDicDr=$p(sExamRule,"^",2)
	Set Active=$p(sExamRule,"^",9)
	Quit:Active'["Y" ret
	
	;RuleDic
	Set sRuleDic=##class(web.DHCWMRQualityBaseCtl).GetDicRById(RuleDicDr)
	Set RuleTitle=$p(sRuleDic,"^",3)
	Set Active=$p(sRuleDic,"^",5)
	Quit:Active'["Y" ret
		
	;ExamSection
	Set sExamSec=##class(web.DHCWMRQualityBaseCtl).GetESById(ExamSecDr)
	Set SecDicDr=$p(sExamSec,"^",2)
	Set Active=$p(sExamSec,"^",5)
	Quit:Active'["Y" ret
	
	;SectionDic
	Set sSecDic=##class(web.DHCWMRQualityBaseCtl).GetDicSById(SecDicDr)
	Set SecTitle=$p(sSecDic,"^",3)
	Set Active=$p(sSecDic,"^",5)
	Quit:Active'["Y" ret
	
	;ExamEntry
	Set sExamEntry=##class(web.DHCWMRQualityBaseCtl).GetEEById(ExamEntry)
	Set EntryDr=+$p(sExamEntry,"^",2)
	Set EntryExpression=$p(sExamEntry,"^",13)
	Quit:EntryExpression="" ret
	Set Active=$p(sExamEntry,"^",11)
	Quit:Active'["Y" ret
	
	;根据是否允许多次评分和质控结果判断是否还需要检查此项内容
	s MultiErr=$p(sExamEntry,"^",6)
	s MultiFlg=1
	i ((MultiErr'["Y")&&$d(^DHCWMRERST(0,"RuleAdm",ExamRuleDr,EpisodeID))) d
	.s RstId=0
	.f  s RstId=$o(^DHCWMRERST(0,"RuleAdm",ExamRuleDr,EpisodeID,RstId)) q:RstId=""  d
	..s:$d(^DHCWMRERST(RstId,"0","RstDtlEntryDr",ExamEntry,"Y")) MultiFlg=0
	q:MultiFlg=0 ret
	
	;EntryDic
	Set sEntryDic=##class(web.DHCWMRQualityBaseCtl).GetDicEById(EntryDr)
	Set EntryTitle=$p(sEntryDic,"^",3)
	Set Active=$p(sEntryDic,"^",5)
	Quit:Active'["Y" ret
	
	Set RCodeList=##class(web.DHCWMRExamACRCtl).ExpEntryExpression(EntryExpression)
	Quit:RCodeList="" ret
	For index=1:1:$l(RCodeList,$c(1))
	{
		Set tmpRCode=$p(RCodeList,$c(1),index)
		Quit:tmpRCode=""
        Set ACRExp=##class(web.DHCWMRExamACRCtl).GetACRExpByRCode(tmpRCode)
        ;Explain ACRExpression return value
        Set tmpVal=##class(web.DHCWMRQuality.BOACRExpExplain).ExplainACRExp(ACRExp,EpisodeID,TemplateID,InstanceID)
        If +tmpVal<0   ;Explain ACRExp error
        {
	        Set ErrList=""
	        Set Err=tmpVal_" "_tmpRCode_"  "_ACRExp
	        Set:$d(^CacheTemp("DHCWMRQuality",$j,"ERROR")) ErrList=$g(^CacheTemp("DHCWMRQuality",$j,"ERROR"))
	        Set:ErrList='"" ErrList=ErrList_$c(13)_Err
	        Set:ErrList="" ErrList=tmpVal
	        Set ^CacheTemp("DHCWMRQuality",$j,"ERROR")=Err
	        Set tmpVal=0
	    }
        ;If return value is true,record the description and template index of the ACRExpression
        If tmpVal
        {
            Set ACRRowid=$o(^DHCWMRACR(0,"RCode",tmpRCode,""))
            Set ACRDescription=$p($g(^DHCWMRACR(+ACRRowid)),"^",1)
	        Set TemplateList=##class(web.DHCWMRExamACRCtl).GetACRExpTempIndex(ACRExp)
	        ;Desccription of Entry
	        Set TempIndex($j)=""
	        
	        For jIndex=1:1:$l(TemplateList,$c(2))
	        {
		        Set TemplateIndex=$p(TemplateList,$c(2),jIndex)
		        Quit:TemplateIndex=""
		        ;ACRTemplateIndex and ACRDescription
		        set:$l(TemplateIndex)>200 TemplateIndex=$e(TemplateIndex,1,200)
		        Set TempIndex($j,TemplateIndex)=ACRDescription
		    }
	    }
	    
        Set tmpPara=tmpRCode_"="_tmpVal
        Set @tmpPara
        //w !,tmpRCode_"="_tmpVal
	}
	Set NewExpression="ret="_EntryExpression
	Set @NewExpression
	//w !,"Entryret="_ret,!
	
	If (+ret)
	{
		//w !,"tmpRCode="_tmpRCode_"  "_EntryTitle
		Set ^CacheTemp("DHCWMRQuality",$j,EpisodeID,ExamRuleDr)=RuleTitle
		Set ^CacheTemp("DHCWMRQuality",$j,EpisodeID,ExamRuleDr,ExamSecSub)=SecTitle
		M ^CacheTemp("DHCWMRQuality",$j,EpisodeID,ExamRuleDr,ExamSecSub,ExamEntrySub)=TempIndex($j)
		Set ^CacheTemp("DHCWMRQuality",$j,EpisodeID,ExamRuleDr,ExamSecSub,ExamEntrySub)=EntryTitle
		//m ^ZF("DHCWMRQuality")=^CacheTemp("DHCWMRQuality")
		//w !,$g(^CacheTemp("DHCWMRQuality",$j,EpisodeID,ExamRuleDr,ExamSecSub,ExamEntrySub))
	}
	
	Quit ret
}

ClassMethod ExplainEntry(ExamEntry As %String, EpisodeID As %String, ByRef TempIndex) As %String
{
	n (ExamEntry,EpisodeID,TempIndex)
	Set ret=""
	Kill TempIndex($j)
	;Set TempIndex=""
	
	Set sExamEntry=##class(web.DHCWMRQualityBaseCtl).GetEEById(ExamEntry)
	Set EntryDr=+$p(sExamEntry,"^",2)
	Set EntryActive=$p(sExamEntry,"^",11)
	Quit:EntryActive'["Y" ret
	Set EntryExpression=$p(sExamEntry,"^",13)
	Quit:EntryExpression="" ret
	;Set sEntryDic=##class(web.DHCWMRQualityBaseCtl).GetDicEById(EntryDr)
	;Set EntryDesc=$p(sEntryDic,"^",3)
	;Set TempIndex($j)=EntryDesc
	Set RCodeList=##class(web.DHCWMRExamACRCtl).ExpEntryExpression(EntryExpression)
	Quit:RCodeList="" ret
	For index=1:1:$l(RCodeList,$c(1))
	{
		Set tmpRCode=$p(RCodeList,$c(1),index)
		Quit:tmpRCode=""
        Set ACRExp=##class(web.DHCWMRExamACRCtl).GetACRExpByRCode(tmpRCode)
        ;Explain ACRExpression return value
        Set tmpVal=+##class(web.DHCWMRQuality.BOACRExpExplain).ExplainACRExp(ACRExp,EpisodeID)
        
        ;If return value is true,record the description and template index of the ACRExpression
        If tmpVal
        {
            Set ACRRowid=$o(^DHCWMRACR(0,"RCode",tmpRCode,""))
            Set ACRDescription=$p($g(^DHCWMRACR(+ACRRowid)),"^",1)
	        Set TemplateList=##class(web.DHCWMRExamACRCtl).GetACRExpTempIndex(ACRExp)
	        ;Desccription of Entry
	        Set TempIndex($j)=""
	        
	        For jIndex=1:1:$l(TemplateList,$c(2))
	        {
		        Set TemplateIndex=$p(TemplateList,$c(2),jIndex)
		        Quit:TemplateIndex=""
		        ;ACRTemplateIndex and ACRDescription
		        Set TempIndex($j,TemplateIndex)=ACRDescription
		    }
	    }
	    
        Set tmpPara=tmpRCode_"="_tmpVal
        Set @tmpPara
	}
	Set NewExpression="ret="_EntryExpression
	
	Set @NewExpression
	
	Quit ret
}

}
