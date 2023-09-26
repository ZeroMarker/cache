Class web.CDSS.TreatDecision.Assessment Extends %RegisteredObject
{

/*ClassMethod CreateAssessmentHtml(id) As %String
{
    q:id="" ""
    s count=0
    s baseHtml=""
    s optionHeadHtml=""
    s contentHtml=""
    s optionUlHtml=""
    s MKBABDesc=$LG($G(^CT.WDT.CDSS.AssBaseD(id)),3)
    s MKBABNote=$LG($G(^CT.WDT.CDSS.AssBaseD(id)),4)
    s:MKBABNote="" MKBABNote="备注暂无"
    s MKBABCode=$LG($G(^CT.WDT.CDSS.AssBaseD(id)),2)
    s baseHtml="<div class='assesstitle' style='padding-top: 20px;text-align:center; width:100%'><a href='#' class='assesshead'>"_MKBABDesc_"</a></div>"
    s seq=""
    for
    {
        s seq=$o(^CT.WDT.CDSS.AssBaseFieldI("SeqIndex",id,seq)) q:seq=""
        s childsub=0
        for 
        {
            
            s childsub=$o(^CT.WDT.CDSS.AssBaseFieldI("SeqIndex",id,seq,childsub)) q:childsub=""
            s MKBABFDesc=$LG($G(^CT.WDT.CDSS.AssBaseD(id,"ChildField",childsub)),3)
            s MKBABFType=$LG($G(^CT.WDT.CDSS.AssBaseD(id,"ChildField",childsub)),4)
            s MKBABFConfig=$LG($G(^CT.WDT.CDSS.AssBaseD(id,"ChildField",childsub)),5)
            s optionLiHtml=""
            s option=""
            if (MKBABFConfig'=""){
                s optionLen=$L(MKBABFConfig,"&%")
                for i=1:1:optionLen-1
                {
                  s optioniAndSore = $p($g(MKBABFConfig),"&%",i) 
                  s optioni = $p($g(optioniAndSore),"^",1)
                  s optioniSore = $p($g(optioniAndSore),"^",2)
                  
                  if (MKBABFType="R"){
                      s optionLiHtml = optionLiHtml_"<li><input id='"_i_"-R"_childsub_"' class='hisui-radio' type='radio' label='"_optioni_"' name='R"_childsub_"' value='"_i_"_"_optioniSore_"'></li>"
                  }elseif(MKBABFType="CB"){
                      s optionLiHtml = optionLiHtml_"<li><input id='"_i_"-CB"_childsub_"' class='hisui-checkbox'  type='checkbox' label='"_optioni_"' name='CB"_childsub_"' value='"_i_"_"_optioniSore_"'></li>"
                  }elseif(MKBABFType="C"){
                      s option=option_"<option value='"_i_"_"_optioniSore_"'>"_optioni_"</option>"
                  }
                }
                if (MKBABFType="C"){
                    s optionLiHtml=optionLiHtml_"<li><select  class='hisui-combobox'  style='width:200px;'>"_option_"</select></li>"
                }
            }else{
                if (MKBABFType="TX"){
                      s optionLiHtml = optionLiHtml_"<li><input type='text' style='width:200px' class='textbox'></input><li>"
                  }elseif(MKBABFType="TA"){
                      s optionLiHtml = optionLiHtml_"<li><textarea style='height:150px;width:300px' class='textarea'></textarea></li>"
                }
            } 
            s count=count+1
            s optionUlHtml=optionUlHtml_"<div class='divul'><h3 class='titleh3'><span>"_count_".&nbsp;</span>"_MKBABFDesc_"</h3>"_"<div  class='contentul' id='"_MKBABFType_"_"_id_"_"_childsub_"'><ul>"_optionLiHtml_"</ul></div></div>"
        }
    }
    q baseHtml_"<div class='welcome'>欢迎使用评分系统！这是一份评分问卷。</div>"_"<div class='assesscontent'>"_optionUlHtml_"</div>"
}*/

/*
/// Creator:chenghegui
/// CreatDate:2018-05-09
/// Description：生成评估系统界面
/// Input：注册id
/// Return:html页面代码
/// Other:w ##class(web.DHCBL.MKB.MKBAssessment).CreateAssessmentHtml(1)
ClassMethod CreateAssessmentHtml(id) As %String
{
    q:id="" ""
    s scripthtml = "<script>"
    s count=0
    s baseHtml=""
    s optionHeadHtml=""
    s contentHtml=""
    s optionUlHtml=""
    s MKBABDesc=$LG($G(^CT.WDT.CDSS.AssBaseD(id)),3)
    s MKBABNote=$LG($G(^CT.WDT.CDSS.AssBaseD(id)),4)
    s:MKBABNote="" MKBABNote="备注暂无"
    s MKBABCode=$LG($G(^CT.WDT.CDSS.AssBaseD(id)),2)
    s baseHtml="<div class='assesstitle' style='padding-top: 20px;text-align:center; width:100%'><a href='#' class='assesshead'>"_MKBABDesc_"</a></div>"
    s seq=""
    for
    {
        s seq=$o(^CT.WDT.CDSS.AssBaseFieldI("SeqIndex",id,seq)) q:seq=""
        s childsub=0
        for 
        {
            
            s childsub=$o(^CT.WDT.CDSS.AssBaseFieldI("SeqIndex",id,seq,childsub)) q:childsub=""
            s MKBABFDesc=$LG($G(^CT.WDT.CDSS.AssBaseD(id,"ChildField",childsub)),3)
            s MKBABFType=$LG($G(^CT.WDT.CDSS.AssBaseD(id,"ChildField",childsub)),4)
            s MKBABFConfig=$LG($G(^CT.WDT.CDSS.AssBaseD(id,"ChildField",childsub)),5)
            s optionLiHtml=""
            s option=""
            if (MKBABFConfig'=""){
                s optionLen=$L(MKBABFConfig,"&%")
                for i=1:1:optionLen-1
                {
                  s optioniAndSore = $p($g(MKBABFConfig),"&%",i) 
                  s optioni = $p($g(optioniAndSore),"^",1)
                  s optioniSore = $p($g(optioniAndSore),"^",2)
                  
                  if (MKBABFType="R"){
                      s optionLiHtml = optionLiHtml_"<li><input id='"_i_"-R"_childsub_"' class='hisui-radio' type='radio' label='"_optioni_"' name='R"_childsub_"' value='"_i_"_"_optioniSore_"'></li>"
                  	  //s optionLiHtml = optionLiHtml_"<li><input id='"_i_"-R"_childsub_"' class='hisui-radio' type='radio' label='"_optioni_"' name='CDSS' value='"_i_"_"_optioniSore_"'></li>"
                  	  s midscript = "$HUI.radio(""[name='R"_childsub_"']"",{onCheckChange:function(e,value){getTheCheckBoxValue();}});"
                  }elseif(MKBABFType="CB"){
                      s optionLiHtml = optionLiHtml_"<li><input id='"_i_"-CB"_childsub_"' class='hisui-checkbox'  type='checkbox' label='"_optioni_"' name='CB"_childsub_"' value='"_i_"_"_optioniSore_"'></li>"
                  }elseif(MKBABFType="C"){
                      s option=option_"<option value='"_i_"_"_optioniSore_"'>"_optioni_"</option>"
                  }
                }
                if (MKBABFType="C"){
                    s optionLiHtml=optionLiHtml_"<li><select  class='hisui-combobox'  style='width:200px;'>"_option_"</select></li>"
                }
            }else{
                if (MKBABFType="TX"){
                      s optionLiHtml = optionLiHtml_"<li><input type='text' style='width:200px' class='textbox'></input><li>"
                  }elseif(MKBABFType="TA"){
                      s optionLiHtml = optionLiHtml_"<li><textarea style='height:150px;width:300px' class='textarea'></textarea></li>"
                }
            } 
            s count=count+1
            s optionUlHtml=optionUlHtml_"<div class='divul'><h3 class='titleh3'><span>"_count_".&nbsp;</span>"_MKBABFDesc_"</h3>"_"<div  class='contentul' id='"_MKBABFType_"_"_id_"_"_childsub_"'><ul>"_optionLiHtml_"</ul></div></div>"
            s scripthtml = scripthtml_midscript
        }
    }
    //s midscript = "$HUI.radio(""[name='R"_childsub_"']"",{onCheckChange:function(e,value){getTheCheckBoxValue();}});"
    s scripthtml = scripthtml_"</script>"
    q baseHtml_"<div class='welcome'>欢迎使用评分系统！这是一份评分问卷。</div>"_"<div class='assesscontent'>"_optionUlHtml_"</div>"_scripthtml
}
*/
/// Creator:chenghegui
/// CreatDate:2018-05-09
/// Description：生成评估系统界面
/// Input：注册id
/// Return:html页面代码
/// Other:w ##class(web.DHCBL.MKB.MKBAssessment).CreateAssessmentHtml(1)
ClassMethod CreateAssessmentHtml(id As %String, PatientUserInfo As %String)
{
    q:id="" ""
     //获得评估表的计算方式
    s CalcaluteType = ..GetCalcaluteType(id)
    //s CalcaluteMethod=$case(CalcaluteType,"getTheCheckBoxValue":"Sum","getAverageValue":"Avg","getMaxValue":"Max","getTheCheckBoxValue":"")
    s CalcaluteMethod=$case(CalcaluteType,"Sum":"getTheCheckBoxValue","Avg":"getAverageValue","Max":"getMaxValue","":"getTheCheckBoxValue")
    /*if (PatientUserInfo'="")
    {
	    k ^Tmpautofulllist(PatientUserInfo)
	    //kill掉临时Global 防止数据错误
    	//生成之前 先调用自动填充的方法 实现需自动填充项的判断 然后通过该方法生成的临时global对勾选项进行自动勾选
    	d ##class(web.CDSS.TreatDecision.SmartAssessment).GetRatingScaleFieldNew(id,PatientUserInfo)
	}*/
    s scripthtml = "<script>"
    s midscript =""
    s count=0
    s baseHtml=""
    s optionHeadHtml=""
    s contentHtml=""
    s optionUlHtml=""
    s MKBABDesc=$LG($G(^CT.WDT.CDSS.AssBaseD(id)),3)
    s MKBABNote=$LG($G(^CT.WDT.CDSS.AssBaseD(id)),4)
    s:MKBABNote="" MKBABNote="备注暂无"
    s MKBABCode=$LG($G(^CT.WDT.CDSS.AssBaseD(id)),2)
    s baseHtml="<div class='assesstitle' style='padding-top: 20px;text-align:center; width:100%'><a href='#' class='assesshead'>"_MKBABDesc_"</a></div>"
    s seq=""
    for
    {
        s seq=$o(^CT.WDT.CDSS.AssBaseFieldI("SeqIndex",id,seq)) q:seq=""
        s childsub=0
        for 
        {
            
            s childsub=$o(^CT.WDT.CDSS.AssBaseFieldI("SeqIndex",id,seq,childsub)) q:childsub=""
            s MKBABFDesc=$LG($G(^CT.WDT.CDSS.AssBaseD(id,"ChildField",childsub)),3)
            s MKBABFType=$LG($G(^CT.WDT.CDSS.AssBaseD(id,"ChildField",childsub)),4)
            s MKBABFConfig=$LG($G(^CT.WDT.CDSS.AssBaseD(id,"ChildField",childsub)),5)
            s optionLiHtml=""
            s option=""
            if (MKBABFConfig'=""){
                s optionLen=$L(MKBABFConfig,"&%")
                for i=1:1:optionLen-1
                {
                  s optioniAndSore = $p($g(MKBABFConfig),"&%",i) 
                  s optioni = $p($g(optioniAndSore),"[BDP]",1)
                  s optioniSore = $p($g(optioniAndSore),"[BDP]",2)
                  
                  if (MKBABFType="R"){
	                  if ($d(^Tmpautofulllist(childsub,i)))
	                  {
		                  s optionLiHtml = optionLiHtml_"<li><input id='"_i_"-R"_childsub_"' class='hisui-radio' type='radio' label='"_optioni_"' name='R"_childsub_"' checked='checked' value='"_i_"_"_optioniSore_"'></li>"
		              }
		              else
		              {
			              s optionLiHtml = optionLiHtml_"<li><input id='"_i_"-R"_childsub_"' class='hisui-radio' type='radio' label='"_optioni_"' name='R"_childsub_"' value='"_i_"_"_optioniSore_"'></li>"
			          }
                  	  //s optionLiHtml = optionLiHtml_"<li><input id='"_i_"-R"_childsub_"' class='hisui-radio' type='radio' label='"_optioni_"' name='CDSS' value='"_i_"_"_optioniSore_"'></li>"
                  	  s midscript = "$HUI.radio(""[name='R"_childsub_"']"",{onCheckChange:function(e,value){"_CalcaluteMethod_"(e,value);}});"
                  }elseif(MKBABFType="CB"){
	                  if ($d(^Tmpautofulllist(childsub,i)))
	                  {
		                  s optionLiHtml = optionLiHtml_"<li><input id='"_i_"-CB"_childsub_"' class='hisui-checkbox'  type='checkbox' label='"_optioni_"' name='CB"_childsub_"' checked='checked' value='"_i_"_"_optioniSore_"'></li>"
		              }
		              else
		              {
			              s optionLiHtml = optionLiHtml_"<li><input id='"_i_"-CB"_childsub_"' class='hisui-checkbox'  type='checkbox' label='"_optioni_"' name='CB"_childsub_"' value='"_i_"_"_optioniSore_"'></li>"
			          }
			          s midscript = midscript_"$HUI.checkbox(""[name='CB"_childsub_"']"",{onCheckChange:function(e,value){"_CalcaluteMethod_"();}});"  
                  }elseif(MKBABFType="C"){
                      s option=option_"<option value='"_i_"_"_optioniSore_"'>"_optioni_"</option>"
                      s midscript = midscript_"$HUI.combobox(""[name='C"_childsub_"']"",{onChange:function(e,value){"_CalcaluteMethod_"();}});" 
                  }
                }
                if (MKBABFType="C"){
                    s optionLiHtml=optionLiHtml_"<li><select  class='hisui-combobox'  style='width:200px;' name='C"_childsub_"'>"_option_"</select></li>"
                }
            }else{
                if (MKBABFType="TX"){
                      s optionLiHtml = optionLiHtml_"<li><input type='text' style='width:200px' class='textbox'></input><li>"
                  }elseif(MKBABFType="TA"){
                      s optionLiHtml = optionLiHtml_"<li><textarea style='height:150px;width:300px' class='textarea'></textarea></li>"
                }
            } 
            s count=count+1
            s optionUlHtml=optionUlHtml_"<div class='divul'><h3 class='titleh3'><span>"_count_".&nbsp;</span>"_MKBABFDesc_"</h3>"_"<div  class='contentul' id='"_MKBABFType_"_"_id_"_"_childsub_"'><ul>"_optionLiHtml_"</ul></div></div>"
            s scripthtml = scripthtml_midscript
        }
    }
    //s midscript = "$HUI.radio(""[name='R"_childsub_"']"",{onCheckChange:function(e,value){getTheCheckBoxValue();}});"
    s scripthtml = scripthtml_"</script>"
    k ^Tmpautofulllist 
    q baseHtml_"<div class='welcome'>欢迎使用评分系统！这是一份评分问卷。</div>"_"<div class='assesscontent'>"_optionUlHtml_"</div>"_scripthtml
}

/// Creator:Xuwenhu
/// CreatDate:2020-08-24
/// Description：生成评估系统界面
/// Input：注册id,PatientUserInfo:0000000001^2^1^住院^6465^丁亚男^111^信息部^1^性别^出生日期^姓名^床号^住院号^血型^妊娠状态^身高^体重^患者所在科室编码^患者所在科室名称
/// Return:html页面代码
/// Other:w ##class(web.CDSS.TreatDecision.Assessment).CreateAssessmentHtmlNew("569","2797^0000000251^2^住院^6464^石萧伟^111^信息部^1")
ClassMethod CreateAssessmentHtmlNew1(id As %String, PatientUserInfo As %String)
{
    q:id="" ""
    s MatchItem={}
    //获得评估表的计算方式
    s CalcaluteType = ..GetCalcaluteType(id)
    //s CalcaluteMethod=$case(CalcaluteType,"getTheCheckBoxValue":"Sum","getAverageValue":"Avg","getMaxValue":"Max","getTheCheckBoxValue":"")
    s CalcaluteType=$case(CalcaluteType,"Sum":"getTheCheckBoxValue","Avg":"getAverageValue","Max":"getMaxValue","Special":"SpecialCalculate","":"getTheCheckBoxValue")
    s CalcaluteMethod="CalculateMethod("""_CalcaluteType_""","""_..SpecialItem(id)_""")"
    if (PatientUserInfo'="")
    {

    	//生成之前 先调用自动填充的方法 实现需自动填充项的判断 然后通过该方法生成的临时global对勾选项进行自动勾选
    	//d ##class(web.CDSS.TreatDecision.SmartAssessment).GetRatingScaleFieldNew(id,PatientUserInfo)
    	//s MatchItem = ##class(web.CDSS.TreatDecision.SmartAssessment).GetRatingScaleFieldNew(id,PatientUserInfo)
	}
	if ##class(web.CDSS.Config.MKBConfig).GetConfigValue("CDSSxwh2022081801")="Y"
	{
		s MatchIWds=##class(web.CDSS.IdentifyWords.GetPatientIW).GetPatTriggerIW(PatientUserInfo)
	}
	else
	{
		s MatchIWds="[]"	
	}
	s MatchIWds=[].%FromJSON(MatchIWds)
	//s MatchItem=""					//患者触发识别词
    s scripthtml = "<script>"
    s midscript =""
    s count=0
    s baseHtml=""
    s optionHeadHtml=""
    s contentHtml=""
    s optionUlHtml=""
    s MKBABDesc=$LG($G(^CT.WDT.CDSS.AssBaseD(id)),3)
    // Oswestry功能障碍指数问卷表（ODI） 单独计算方式
    if (MKBABDesc="Oswestry功能障碍指数问卷表（ODI）")
    {
	   s CalcaluteMethod="OswestryScore" 
	}
	//安徽省立该评估表多个题目也只能选择一个选项
    if (MKBABDesc="患者入住ICU的主要疾病分值")
    {
	   s CalcaluteMethod="ClearOtherOption" 
	}
    s MKBABNote=$LG($G(^CT.WDT.CDSS.AssBaseD(id)),4)
    s:MKBABNote="" MKBABNote="备注暂无"
    s MKBABCode=$LG($G(^CT.WDT.CDSS.AssBaseD(id)),2)
    
    s baseHtml="<div class='assesstitle' style='text-align:center; width:100%'><div class='assesshead'>"_MKBABDesc_"</div></div>"
	_"<div class='welcome'>欢迎使用评分系统！这是一份评分问卷。</div>"
    _"<hr style='color:#85c8ff;padding:0 50px;border:none; height: 3px; background-color:#85c8ff;'>"  //蓝色分隔线
    
    s RelatedExplain=""
    s BasicId=$o(^CT.WDT.CDSS.AssBasicInfoI("AssIndex",id,0))
    s:BasicId'="" RelatedExplain=$LG($G(^CT.WDT.CDSS.AssBasicInfoD(BasicId)),12)			//相关解释
    if RelatedExplain'=""
    {
	    s RelatedExplain=$replace(RelatedExplain,$c(13),"<br/>")
    	s baseHtml=baseHtml_"<div style='margin: 0 0 5px 50px;'>"_RelatedExplain_"</div>"
    }
    

    s baseHtml=baseHtml_"<div class='assesscontent'>"
    //判断是否只有一道题
    s singlecount=0
    s seq=0
    for
    {
        s seq=$o(^CT.WDT.CDSS.AssBaseFieldI("SeqIndex",id,seq)) q:seq=""
        q:singlecount>1
        s singlecount=singlecount+1
    }
    s seq=""
    for
    {
        s seq=$o(^CT.WDT.CDSS.AssBaseFieldI("SeqIndex",id,seq)) q:seq=""				//顺序号
        s childsub=0
        for 
        {     
            s childsub=$o(^CT.WDT.CDSS.AssBaseFieldI("SeqIndex",id,seq,childsub)) q:childsub=""
            s MKBABFDesc=$LG($G(^CT.WDT.CDSS.AssBaseD(id,"ChildField",childsub)),3)
            s MKBABFType=$LG($G(^CT.WDT.CDSS.AssBaseD(id,"ChildField",childsub)),4)
            s MKBABFConfig=$LG($G(^CT.WDT.CDSS.AssBaseD(id,"ChildField",childsub)),5)
            s MKBABFExclusion =	$LG($G(^CT.WDT.CDSS.AssBaseD(id,"ChildField",childsub)),7)
			s MKBABFJumpOption = $LG($G(^CT.WDT.CDSS.AssBaseD(id,"ChildField",childsub)),8)
			s MKBABFIdentifyWords=$LG($G(^CT.WDT.CDSS.AssBaseD(id,"ChildField",childsub)),10)		//识别词
			s BackWords=""			//回填内容 
			s optionrule={}			//满足识别词条件的选项
			if MKBABFIdentifyWords'=""
			{
				s fullflag=0		//满足标志
				if $e(MKBABFIdentifyWords,1)="Q"		//题目触发识别词
				{
					s MKBABFIdentifyWords=$e(MKBABFIdentifyWords,3,*)
					//用OR分割条件,先判断AND条件是否满足,全部满足则退出循环
					for coni=1:1:$l(MKBABFIdentifyWords,"OR")
					{
						s condition=$p(MKBABFIdentifyWords,"OR",coni)
						for conj=1:1:$l(condition,"AND")
						{
							s childcon=$p(condition,"AND",conj)
							if MatchIWds.%IsDefined(childcon)
							{
								s fullflag=1
							}
							else
							{
								s fullflag=0
								q	
							}
						}
						if fullflag=1
						{
							q	
						}		
					}
					//满足条件，回填识别词内容
					if fullflag=1
					{
						s BackWords=MatchIWds.%Get("desc")	
					} 	
				}	
				else						//选项触发识别词
				{
					for coni=1:1:$l(MKBABFIdentifyWords,"||")
					{
						s OptionText=$p(MKBABFIdentifyWords,"||",coni)
						s opseq=$e(OptionText,2)		//选项号
						s OptionExp=$e(OptionText,4,*)
						for conj=1:1:$l(OptionExp,"OR")
						{
							s condition=$p(OptionExp,"OR",conj)
							for conz=1:1:$l(condition,"AND")
							{
								s childcon=$p(condition,"AND",conz)
								if MatchIWds.%IsDefined(childcon)
								{
									s fullflag=1
								}
								else
								{
									s fullflag=0
									q	
								}
							}
							if fullflag=1
							{
								q	
							}		
						}
						if fullflag=1
						{
							d optionrule.%Set(opseq,"1")	
						} 	
					}
				}
			}
            s optionLiHtml=""
            s option=""
            
            // 题目换行处理
            s i=0
		    for
		    {
			    s i=$locate(MKBABFDesc,"\（+[1-9]+\）+",i)
			    q:i=0
		    	s $e(MKBABFDesc,i-1)=$e(MKBABFDesc,i-1)_"<br>&nbsp&nbsp&nbsp&nbsp"
		    	s i=i+25  
		   	}
		   	s MKBABFDesc=$replace(MKBABFDesc,$c(10),"<br/>")
		   	s MKBABFDesc=$replace(MKBABFDesc,$c(32),"&nbsp")
            // 题目为空重置样式
            s hstyle=""
            if $replace(MKBABFDesc,$c(32),"")=""
            {
	            s hstyle="float:left"
	        }
            
            if (MKBABFType="M") continue
			if (MKBABFConfig'="")
			{
				s optionLen=$L(MKBABFConfig,"&%")
				s listyle=""
				///单选框 和多选框 ：判断选项长短，决定单选框和多选框 是否要每个选项占一行，还是要都在一行里显示
				if ((MKBABFType="R")||(MKBABFType="CB"))   //单选框radio
				{
					s optionLenTotal=0,LineFeedFlag=0,LongOptionFlag=0
					for optionLeni=1:1:(optionLen-1)
					{
						s optioniAndSore = $p($g(MKBABFConfig),"&%",optionLeni) 
						s optioni = $p($g(optioniAndSore),"[BDP]",1)  //标签
						if ($l(optioni)>30) s LineFeedFlag=1
						if ($l(optioni)>9) s LongOptionFlag=1
						if optionLenTotal=0
						{
							s optionLenTotal=$l(optioni)
						}
						else
						{
							s optionLenTotal=optionLenTotal+$l(optioni)+6
						}
					}
					//总长度超过70且有超过9长度的； 或者是有超过30长度的选项：每个选项单行显示
					if (((optionLenTotal>70)&&(LongOptionFlag=1))||(LineFeedFlag=1))
					{
						s listyle="float:none;"
					}
					//如果只有一道题也单行显示
					if singlecount=1
					{
						s listyle="float:none;"	
					}
					//长度超过70但是没有长度超过9的 ：不换行
					if (optionLenTotal>70)&&(LongOptionFlag=0)
					{
						s listyle=""
					}
				}
				
				//第二部分结束
				for optionLeni=1:1:optionLen-1
				{
					s optioniAndSore = $p($g(MKBABFConfig),"&%",optionLeni) 
					s optioni = $p($g(optioniAndSore),"[BDP]",1)
					s paddingStyle=""				//默认内边距0px
					if $locate(optioni,"[A-z0-9_\u4e00-\u9fa5]")>2
					{
						s spaceNum=$locate(optioni,"[A-z0-9_\u4e00-\u9fa5]")-2
						s paddingStyle="padding-left:"_(spaceNum*15)_"px"	
					}
					s optioniSore = $p($g(optioniAndSore),"[BDP]",2)
					s optionexcu=$p($g(optioniAndSore),"[BDP]",3)	//互斥项
					s optionjump=$p($g(optioniAndSore),"[BDP]",4)	//跳转项
					if $l(optioni)>70   //对选项内容的长度超过80的，设置高度 2021-04-08
					{
						//s height=(($l(optioni)\70)+2.5)*20
						//s heightstyle="height:"_height_"px;"
						s heightstyle="padding-bottom:30px"
					}
					else
					{
						s heightstyle=""	
					}
					if (MKBABFType="R")   //单选框radio
					{
						if optioniSore["data:image"
						{
							s optionLiHtml = optionLiHtml_"<li style='float:none'><img src='"_optioniSore_"'></li>"
						}
						else
						{
							//if (MatchItem.%IsDefined(childsub_"^"_optionLeni))  //$d(^Tmpautofulllist(PatientUserInfo,childsub,optionLeni))
							if (optionrule.%IsDefined(optionLeni))
							{
								s optionLiHtml = optionLiHtml_"<a style='color:black' href='#title"_optionjump_"'><li style='"_listyle_heightstyle_paddingStyle_"'><input id='"_optionLeni_"-R"_childsub_"' class='hisui-radio' type='radio' label='"_optioni_"' name='R"_childsub_"' checked='checked' value='"_optionLeni_"_"_optioniSore_"'></li></a>"
							}
							else
							{
								s optionLiHtml = optionLiHtml_"<a style='color:black' href='#title"_optionjump_"'><li style='"_listyle_heightstyle_paddingStyle_"'><input id='"_optionLeni_"-R"_childsub_"' class='hisui-radio' type='radio' label='"_optioni_"' name='R"_childsub_"' value='"_optionLeni_"_"_optioniSore_"'></li></a>"
							}
							//s midscript = "$HUI.radio(""[name='R"_childsub_"']"",{onCheckChange:function(e,value){getTheCheckBoxValue();}});"
							s midscript = "$HUI.radio(""[name='R"_childsub_"']"",{onCheckChange:function(e,value){"_CalcaluteMethod_";},onChecked:function(e,value){CheckOption(e);}});"
						}
					}
					elseif(MKBABFType="CB")  //复选框
					{
						if optioniSore["data:image"
						{
							s optionLiHtml = optionLiHtml_"<li><img src='"_optioniSore_"'></li>"
						}
						else
						{
							if (MatchItem.%IsDefined(childsub_"^"_optionLeni)) //$d(^Tmpautofulllist(PatientUserInfo,childsub,optionLeni))
							//if (optionrule.%IsDefined(optionLeni))
							{
							    s optionLiHtml = optionLiHtml_"<a style='color:black' href='#title"_optionjump_"'><li style='"_listyle_heightstyle_"'><input id='"_optionLeni_"-CB"_childsub_"-"_optionexcu_"' class='hisui-checkbox'  type='checkbox' label='"_optioni_"' name='CB"_childsub_"' checked='checked' value='"_optionLeni_"_"_optioniSore_"'></li></a>"
							}
							else
							{
								s optionLiHtml = optionLiHtml_"<a style='color:black' href='#title"_optionjump_"'><li style='"_listyle_heightstyle_"'><input id='"_optionLeni_"-CB"_childsub_"-"_optionexcu_"' class='hisui-checkbox'  type='checkbox' label='"_optioni_"' name='CB"_childsub_"' value='"_optionLeni_"_"_optioniSore_"'></li></a>"
							}
							//s midscript = midscript_"$HUI.checkbox(""[name='CB"_childsub_"']"",{onCheckChange:function(e,value){getTheCheckBoxValue();}});"   
							s midscript = midscript_"$HUI.checkbox(""[name='CB"_childsub_"']"",{onCheckChange:function(e,value){"_CalcaluteMethod_";},onChecked:function(e,value){CheckOption(e);}});"
						}
					}
					elseif(MKBABFType="C") //下拉框
					{
						s option=option_"<option value='"_optionLeni_"_"_optioniSore_"'>"_optioni_"</option>"  //下拉框选项
						//s midscript = midscript_"$HUI.combobox(""[name='C"_childsub_"']"",{onChange:function(e,value){"_CalcaluteMethod_";},onSelect:function(e,value){CheckOption($(this));}});" 
					}
				}
				if (MKBABFType="C"){  //下拉框
					s optionLiHtml=optionLiHtml_"<li><select  class='hisui-combobox'  style='width:300px;' name='C"_childsub_"'>"_option_"</select></li>"
					if optioniSore["data:image"
					{
						s optionLiHtml = optionLiHtml_"<li><img src='"_optioniSore_"'></li>"
					}
					s midscript = midscript_"$HUI.combobox(""[name='C"_childsub_"']"",{onChange:function(e,value){"_CalcaluteMethod_";},onSelect:function(e,value){CheckOption($(this));}});"
				}
				s count=count+1
				//只有一道题不显示题号
				if singlecount=2
				{
					s baseHtml=baseHtml_"<div class='divul'><h3 class='titleh3' id='titleQ"_seq_"' style='"_hstyle_"'><a style='color:black' href='#title"_MKBABFJumpOption_"'><span>"_count_".&nbsp;</span>"_MKBABFDesc_"</a></h3>"_"<div id='contentsequlQ"_seq_"' class='contentsequlQ"_seq_"-"_MKBABFExclusion_"'>"_"<div  class='contentul' id='"_MKBABFType_"_"_id_"_"_childsub_"'><ul>"_optionLiHtml_"</ul></div></div></div>"
				}
				else
				{
					s baseHtml=baseHtml_"<div class='divul'><h3 class='titleh3' id='titleQ"_seq_"'><a style='color:black' href='#title"_MKBABFJumpOption_"'>"_MKBABFDesc_"</a></h3>"_"<div id='contentsequlQ"_seq_"' class='contentsequlQ"_seq_"-"_MKBABFExclusion_"'>"_"<div  class='contentul' id='"_MKBABFType_"_"_id_"_"_childsub_"'><ul>"_optionLiHtml_"</ul></div></div></div>"
				}
				//w "<div class='divul'><h3 class='titleh3' id='titleQ"_seq_"'><a style='color:black' href='#title"_MKBABFJumpOption_"'><span>"_count_".&nbsp;</span>"_MKBABFDesc_"</a></h3>"_"<div id='contentsequlQ"_seq_"' class='contentsequlQ"_seq_"-"_MKBABFExclusion_"'>"_"<div  class='contentul' id='"_MKBABFType_"_"_id_"_"_childsub_"'><ul>"_optionLiHtml_"</ul></div></div></div>"
				s scripthtml = scripthtml_midscript
			}
			else
			{
				if (MKBABFType="TX")   //文本
				{
					if BackWords'=""
					{
						s optionLiHtml = optionLiHtml_"<li><input type='text' style='width:680px' class='textbox' onblur='"_CalcaluteMethod_";' value="_BackWords_" onchange='CheckOption($(this))'></input><li>"
					}
					else
					{
						s optionLiHtml = optionLiHtml_"<li><input type='text' style='width:680px' class='textbox' onblur='"_CalcaluteMethod_";' onchange='CheckOption($(this))'></input><li>"
					}
				}
				elseif(MKBABFType="TA")  //长文本
				{
					if BackWords'=""
					{
						s optionLiHtml = optionLiHtml_"<li><textarea style='height:150px;width:680px' class='textarea' onblur='"_CalcaluteMethod_";' value="_BackWords_" onchange='CheckOption($(this))'></textarea></li>"
					}
					else
					{
						s optionLiHtml = optionLiHtml_"<li><textarea style='height:150px;width:680px' class='textarea' onblur='"_CalcaluteMethod_";' onchange='CheckOption($(this))'></textarea></li>"
					}
				}
				s count=count+1
				//只有一道题不显示题号
				if singlecount=2
				{
					s baseHtml=baseHtml_"<div class='divul'><h3 class='titleh3' id='title"_seq_"'><a style='color:black' href='#title"_MKBABFJumpOption_"'><span>"_count_".&nbsp;</span>"_MKBABFDesc_"</a></h3>"_"<div id='contentsequlQ"_seq_"' class='contentsequlQ"_seq_"-"_MKBABFExclusion_"'>"_"<div  class='txtcontentul' id='"_MKBABFType_"_"_id_"_"_childsub_"'><ul>"_optionLiHtml_"</ul></div></div></div>"
				}
				else
				{
					s baseHtml=baseHtml_"<div class='divul'><h3 class='titleh3' id='title"_seq_"'><a style='color:black' href='#title"_MKBABFJumpOption_"'>"_MKBABFDesc_"</a></h3>"_"<div id='contentsequlQ"_seq_"' class='contentsequlQ"_seq_"-"_MKBABFExclusion_"'>"_"<div  class='txtcontentul' id='"_MKBABFType_"_"_id_"_"_childsub_"'><ul>"_optionLiHtml_"</ul></div></div></div>"
				}
				//w "<div class='divul'><h3 class='titleh3' id='title"_seq_"'><a style='color:black' href='#title"_MKBABFJumpOption_"'><span>"_count_".&nbsp;</span>"_MKBABFDesc_"</a></h3>"_"<div class='contentsequlQ"_seq_"-"_MKBABFExclusion_"'>"_"<div  class='txtcontentul' id='"_MKBABFType_"_"_id_"_"_childsub_"'><ul>"_optionLiHtml_"</ul></div></div></div>"
				s scripthtml = scripthtml_midscript
			} 
			
		}
    }
    //s midscript = "$HUI.radio(""[name='R"_childsub_"']"",{onCheckChange:function(e,value){getTheCheckBoxValue();}});"
    s scripthtml = scripthtml_"</script>"
    //k ^Tmpautofulllist 
    s baseHtml=baseHtml_"</div>"
    s baseHtml=baseHtml_scripthtml
   
    //显示页脚 
    //s Footer=##class(web.DHCBL.MKB.MKBAssessment).GetFooterById(id)
    //if Footer'="" w "<div class='assesstitle' style='text-align:left; width:100%'><div style='padding: 20px 30px 20px 50px;font-size: 12px;color: #333;'>"_Footer_"</div></div>"
    q baseHtml
}

/// Creator:Xuwenhu
/// CreatDate:2022-12-19
/// Description: 生成评估表界面
/// other：w ##class(web.CDSS.Access.Assessment).CreateAssessmentHtmlNew("883","2797^0000000251^2^住院^6464^石萧伟^111^信息部^1")
ClassMethod CreateAssessmentHtmlNew(id As %String, PatientUserInfo As %String)
{
	q:id="" ""
    //获得评估表的计算方式
    s CalcaluteType = ..GetCalcaluteType(id)
    //s CalcaluteMethod=$case(CalcaluteType,"getTheCheckBoxValue":"Sum","getAverageValue":"Avg","getMaxValue":"Max","getTheCheckBoxValue":"")
    s CalcaluteType=$case(CalcaluteType,"Sum":"getTheCheckBoxValue","Avg":"getAverageValue","Max":"getMaxValue","Special":"SpecialCalculate","":"getTheCheckBoxValue")
    s CalcaluteMethod="CalculateMethod("""_CalcaluteType_""","""_..SpecialItem(id)_""")"

    s scripthtml = "<script>"
    s midscript =""
    s count=0
    s baseHtml=""
    s optionHeadHtml=""
    s contentHtml=""
    s optionUlHtml=""
    s MKBABDesc=$LG($G(^CT.WDT.CDSS.AssBaseD(id)),3)
    // Oswestry功能障碍指数问卷表（ODI） 单独计算方式
    if (MKBABDesc="Oswestry功能障碍指数问卷表（ODI）")
    {
	   s CalcaluteMethod="OswestryScore" 
	}
	//安徽省立该评估表多个题目也只能选择一个选项
    if (MKBABDesc="患者入住ICU的主要疾病分值")
    {
	   s CalcaluteMethod="ClearOtherOption" 
	}
    s MKBABNote=$LG($G(^CT.WDT.CDSS.AssBaseD(id)),4)
    s:MKBABNote="" MKBABNote="备注暂无"
    s MKBABCode=$LG($G(^CT.WDT.CDSS.AssBaseD(id)),2)
    
    s baseHtml="<div class='assesstitle' style='text-align:center; width:100%'><div class='assesshead'>"_MKBABDesc_"</div></div>"
	_"<div class='welcome'>欢迎使用评分系统！这是一份评分问卷。</div>"
    _"<hr style='color:#85c8ff;padding:0 50px;border:none; height: 3px; background-color:#85c8ff;'>"  //蓝色分隔线
    
    s RelatedExplain=""
    s BasicId=$o(^CT.WDT.CDSS.AssBasicInfoI("AssIndex",id,0))
    s:BasicId'="" RelatedExplain=$LG($G(^CT.WDT.CDSS.AssBasicInfoD(BasicId)),12)			//相关解释
    if RelatedExplain'=""
    {
	    s RelatedExplain=$replace(RelatedExplain,$c(13),"<br/>")
	    s RelatedExplain=$replace(RelatedExplain,$c(32),"&nbsp")
    	s baseHtml=baseHtml_"<div style='margin: 0 0 5px 50px;'>"_RelatedExplain_"</div>"
    }
    s baseHtml=baseHtml_"<div class='assesscontent'>"
    //判断是否只有一道题
    s singlecount=0
    s seq=0
    for
    {
        s seq=$o(^CT.WDT.CDSS.AssBaseFieldI("SeqIndex",id,seq)) q:seq=""
        q:singlecount>1
        s singlecount=singlecount+1
    }
    s seq=""
    for
    {
        s seq=$o(^CT.WDT.CDSS.AssBaseFieldI("SeqIndex",id,seq)) q:seq=""				//顺序号
        s childsub=0
        for 
        {     
            s childsub=$o(^CT.WDT.CDSS.AssBaseFieldI("SeqIndex",id,seq,childsub)) q:childsub=""
            s MKBABFDesc=$LG($G(^CT.WDT.CDSS.AssBaseD(id,"ChildField",childsub)),3)			//题目
            s MKBABFType=$LG($G(^CT.WDT.CDSS.AssBaseD(id,"ChildField",childsub)),4)			//类型
            s MKBABFConfig=$LG($G(^CT.WDT.CDSS.AssBaseD(id,"ChildField",childsub)),5)		
            s MKBABFExclusion =	$LG($G(^CT.WDT.CDSS.AssBaseD(id,"ChildField",childsub)),7)
			s MKBABFJumpOption = $LG($G(^CT.WDT.CDSS.AssBaseD(id,"ChildField",childsub)),8)
			s MKBABFIdentifyWords=$LG($G(^CT.WDT.CDSS.AssBaseD(id,"ChildField",childsub)),10)		//识别词
			
			s optionLiHtml=""
            s option=""
            
            // 题目换行处理
            s i=0
		    for
		    {
			    s i=$locate(MKBABFDesc,"\（+[1-9]+\）+",i)
			    q:i=0
		    	s $e(MKBABFDesc,i-1)=$e(MKBABFDesc,i-1)_"<br>&nbsp&nbsp&nbsp&nbsp"
		    	s i=i+25  
		   	}
		   	s MKBABFDesc=$replace(MKBABFDesc,$c(10),"<br/>")
		   	s MKBABFDesc=$replace(MKBABFDesc,$c(32),"&nbsp")
            // 题目为空重置样式
            s hstyle=""
            if $replace(MKBABFDesc,$c(32),"")=""
            {
	            s hstyle="float:left"
	        }
            
            if (MKBABFType="M") continue
            if (MKBABFType="P") 
            {
	        	s baseHtml=baseHtml_"<div style='font-weight:bold'>"_MKBABFDesc_"</div></br>" 
	        	continue
	        }
			s listyle=""
			s ItemValue=""
			///单选框 和多选框 ：判断选项长短，决定单选框和多选框 是否要每个选项占一行，还是要都在一行里显示
			s optionLenTotal=0,LineFeedFlag=0,LongOptionFlag=0
			if ((MKBABFType="R")||(MKBABFType="CB"))   //单选框radio
			{
				s childseq=0
				for
				{
					s childseq=$o(^CT.WDT.CDSS.AssBaseFieldItemI("SeqIndex",id,childsub,childseq)) q:childseq=""
					s childitem=0
					for
					{
						s childitem=$o(^CT.WDT.CDSS.AssBaseFieldItemI("SeqIndex",id,childsub,childseq,childitem)) q:childitem=""
						s ItemValue = $LG($G(^CT.WDT.CDSS.AssBaseD(id,"ChildField",childsub,"ChildItem",childitem)),2)
						continue:ItemValue["data:image"
						if ($l(ItemValue)>30) s LineFeedFlag=1
						if ($l(ItemValue)>9) s LongOptionFlag=1
						if optionLenTotal=0
						{
							s optionLenTotal=$l(ItemValue)
						}
						else
						{
							s optionLenTotal=optionLenTotal+$l(ItemValue)+6
						}
					}
				}
			}	
			//总长度超过70且有超过9长度的； 或者是有超过30长度的选项：每个选项单行显示
			if (((optionLenTotal>70)&&(LongOptionFlag=1))||(LineFeedFlag=1))
			{
				s listyle="float:none;"
			}
			//如果只有一道题也单行显示
			if singlecount=1
			{
				s listyle="float:none;"	
			}
			//长度超过70但是没有长度超过9的 ：不换行
			if (optionLenTotal>70)&&(LongOptionFlag=0)
			{
				s listyle=""
			}
			
			s paddingStyle=""				//默认内边距0px
			if $locate(ItemValue,"[A-z0-9_\u4e00-\u9fa5]")>2
			{
				s spaceNum=$locate(ItemValue,"[A-z0-9_\u4e00-\u9fa5]")-2
				s paddingStyle="padding-left:"_(spaceNum*15)_"px"	
			}
			if $l(ItemValue)>70   //对选项内容的长度超过80的，设置高度 2021-04-08
			{
				//s height=(($l(ItemValue)\70)+2.5)*20
				//s heightstyle="height:"_height_"px;"
				s heightstyle="padding-bottom:30px"
			}
			else
			{
				s heightstyle=""	
			}
			//循环选项
			s childseq=0
			for
			{
				s childseq=$o(^CT.WDT.CDSS.AssBaseFieldItemI("SeqIndex",id,childsub,childseq)) q:childseq=""
				s childitem=0
				for
				{
					s childitem=$o(^CT.WDT.CDSS.AssBaseFieldItemI("SeqIndex",id,childsub,childseq,childitem)) q:childitem=""
					s ItemValue = $LG($G(^CT.WDT.CDSS.AssBaseD(id,"ChildField",childsub,"ChildItem",childitem)),2)		//选项
					s ItemScore = $LG($G(^CT.WDT.CDSS.AssBaseD(id,"ChildField",childsub,"ChildItem",childitem)),3)		//分数
					s ItemExclusion = $LG($G(^CT.WDT.CDSS.AssBaseD(id,"ChildField",childsub,"ChildItem",childitem)),4)	//互斥
					s ItemJumpOption = $LG($G(^CT.WDT.CDSS.AssBaseD(id,"ChildField",childsub,"ChildItem",childitem)),5)	//跳转
					//s ItemSequence = $LG($G(^CT.WDT.CDSS.AssBaseD(id,"ChildField",childsub,"ChildItem",childitem)),6)	
					s RuleDR =	$LG($G(^CT.WDT.CDSS.AssBaseD(id,"ChildField",childsub,"ChildItem",childitem)),7)		//规则dr
					//判断是否满足规则
					s ISFullFlag=""
					s:RuleDR'="" ISFullFlag=##class(web.CDSS.MedicalRule.GetPatientRule).DealScaleRule(RuleDR,PatientUserInfo)					
					s Remarks = $LG($G(^CT.WDT.CDSS.AssBaseD(id,"ChildField",childsub,"ChildItem",childitem)),8)		//备注
			        if (MKBABFType="TX")
			        {
				        if ItemValue["data:image"
						{
							s optionLiHtml = optionLiHtml_"<li style='float:none'><img src='"_ItemValue_"'></li>"
						}
				    }
					if MKBABFType'="TX"
					{
						if (MKBABFType="R")   //单选框radio
						{
							if ItemValue["data:image"
							{
								s optionLiHtml = optionLiHtml_"<li style='float:none'><img src='"_ItemValue_"'></li>"
							}
							else
							{
								if ISFullFlag="True"
								{
									s optionLiHtml = optionLiHtml_"<a style='color:black' href='#title"_ItemJumpOption_"'><li style='"_listyle_heightstyle_paddingStyle_"'><input id='"_childseq_"-R"_childsub_"' class='hisui-radio' type='radio' label='"_ItemValue_"' name='R"_childsub_"' checked='checked' value='"_childseq_"_"_ItemScore_"'></li></a>"	
								}
								else
								{
									s optionLiHtml = optionLiHtml_"<a style='color:black' href='#title"_ItemJumpOption_"'><li style='"_listyle_heightstyle_paddingStyle_"'><input id='"_childseq_"-R"_childsub_"' class='hisui-radio' type='radio' label='"_ItemValue_"' name='R"_childsub_"' value='"_childseq_"_"_ItemScore_"'></li></a>"
								}
								s midscript = "$HUI.radio(""[name='R"_childsub_"']"",{onCheckChange:function(e,value){"_CalcaluteMethod_";},onChecked:function(e,value){CheckOption(e);}});"
							}
						}
						elseif(MKBABFType="CB")  //复选框
						{
							if ItemValue["data:image"
							{
								s optionLiHtml = optionLiHtml_"<li><img src='"_ItemValue_"'></li>"
							}
							else
							{
								if ISFullFlag="True"
								{
									s optionLiHtml = optionLiHtml_"<a style='color:black' href='#title"_ItemJumpOption_"'><li style='"_listyle_heightstyle_"'><input id='"_childseq_"-CB"_childsub_"-"_ItemExclusion_"' class='hisui-checkbox'  type='checkbox' label='"_ItemValue_"' checked='checked' name='CB"_childsub_"' value='"_childseq_"_"_ItemScore_"'></li></a>"
								}
								else
								{ 
									s optionLiHtml = optionLiHtml_"<a style='color:black' href='#title"_ItemJumpOption_"'><li style='"_listyle_heightstyle_"'><input id='"_childseq_"-CB"_childsub_"-"_ItemExclusion_"' class='hisui-checkbox'  type='checkbox' label='"_ItemValue_"' name='CB"_childsub_"' value='"_childseq_"_"_ItemScore_"'></li></a>"
								}
								s midscript = midscript_"$HUI.checkbox(""[name='CB"_childsub_"']"",{onCheckChange:function(e,value){"_CalcaluteMethod_";},onChecked:function(e,value){CheckOption(e);}});"
							}
						}
						elseif(MKBABFType="C") //下拉框
						{
							continue:ItemValue["data:image"
							s option=option_"<option value='"_childseq_"_"_ItemScore_"'>"_ItemValue_"</option>"  //下拉框选项
							//s midscript = midscript_"$HUI.combobox(""[name='C"_childsub_"']"",{onChange:function(e,value){"_CalcaluteMethod_";},onSelect:function(e,value){CheckOption($(this));}});" 						
						}
					}
				}
			}
			//输出
			if (MKBABFType="C"){  		//下拉框
				s optionLiHtml=optionLiHtml_"<li><select id='C"_childsub_"' class='shdh'  style='width:300px;' name='C"_childsub_"'>"_option_"</select></li>"
				if ItemValue["data:image"
				{
					s optionLiHtml = optionLiHtml_"<li><img src='"_ItemValue_"'></li>"
				}
				//s midscript = midscript_"$(""[class='shdh']"").combobox({onChange:function(e,value){"_CalcaluteMethod_";},onSelect:function(e,value){CheckOption($(this));}});"
				s count=count+1
				//只有一道题不显示题号
				if singlecount=2
				{
					s baseHtml=baseHtml_"<div class='divul'><h3 class='titleh3' id='titleQ"_seq_"' style='"_hstyle_"'><a style='color:black' href='#title"_MKBABFJumpOption_"'><span>"_count_".&nbsp;</span>"_MKBABFDesc_"</a></h3>"_"<div id='contentsequlQ"_seq_"' class='contentsequlQ"_seq_"-"_MKBABFExclusion_"'>"_"<div  class='contentul' id='"_MKBABFType_"_"_id_"_"_childsub_"'><ul>"_optionLiHtml_"</ul></div></div></div>"
				}
				else
				{
					s baseHtml=baseHtml_"<div class='divul'><h3 class='titleh3' id='titleQ"_seq_"'><a style='color:black' href='#title"_MKBABFJumpOption_"'>"_MKBABFDesc_"</a></h3>"_"<div id='contentsequlQ"_seq_"' class='contentsequlQ"_seq_"-"_MKBABFExclusion_"'>"_"<div  class='contentul' id='"_MKBABFType_"_"_id_"_"_childsub_"'><ul>"_optionLiHtml_"</ul></div></div></div>"
				}
				//w "<div class='divul'><h3 class='titleh3' id='titleQ"_seq_"'><a style='color:black' href='#title"_MKBABFJumpOption_"'><span>"_count_".&nbsp;</span>"_MKBABFDesc_"</a></h3>"_"<div id='contentsequlQ"_seq_"' class='contentsequlQ"_seq_"-"_MKBABFExclusion_"'>"_"<div  class='contentul' id='"_MKBABFType_"_"_id_"_"_childsub_"'><ul>"_optionLiHtml_"</ul></div></div></div>"
				s scripthtml = scripthtml_midscript
			}
			elseif (MKBABFType="TX")		//单行文本框
	        {
				s optionLiHtml = "<li><input type='text' style='width:680px' class='textbox' onblur='"_CalcaluteMethod_";' onchange='CheckOption($(this))'></input><li>"_optionLiHtml
				s count=count+1
				//只有一道题不显示题号
				if singlecount=2
				{
					s baseHtml=baseHtml_"<div class='divul'><h3 class='titleh3' id='title"_seq_"'><a style='color:black' href='#title"_MKBABFJumpOption_"'><span>"_count_".&nbsp;</span>"_MKBABFDesc_"</a></h3>"_"<div id='contentsequlQ"_seq_"' class='contentsequlQ"_seq_"-"_MKBABFExclusion_"'>"_"<div  class='txtcontentul' id='"_MKBABFType_"_"_id_"_"_childsub_"'><ul>"_optionLiHtml_"</ul></div></div></div>"
				}
				else
				{
					s baseHtml=baseHtml_"<div class='divul'><h3 class='titleh3' id='title"_seq_"'><a style='color:black' href='#title"_MKBABFJumpOption_"'>"_MKBABFDesc_"</a></h3>"_"<div id='contentsequlQ"_seq_"' class='contentsequlQ"_seq_"-"_MKBABFExclusion_"'>"_"<div  class='txtcontentul' id='"_MKBABFType_"_"_id_"_"_childsub_"'><ul>"_optionLiHtml_"</ul></div></div></div>"
				}
				//w "<div class='divul'><h3 class='titleh3' id='title"_seq_"'><a style='color:black' href='#title"_MKBABFJumpOption_"'><span>"_count_".&nbsp;</span>"_MKBABFDesc_"</a></h3>"_"<div class='contentsequlQ"_seq_"-"_MKBABFExclusion_"'>"_"<div  class='txtcontentul' id='"_MKBABFType_"_"_id_"_"_childsub_"'><ul>"_optionLiHtml_"</ul></div></div></div>"
				s scripthtml = scripthtml_midscript
		    }
		    elseif (MKBABFType="TA")  		//长文本
			{
				s optionLiHtml = optionLiHtml_"<li><textarea style='height:150px;width:680px' class='textarea' onblur='"_CalcaluteMethod_";' onchange='CheckOption($(this))'></textarea></li>"
				s count=count+1
				//只有一道题不显示题号
				if singlecount=2
				{
					s baseHtml=baseHtml_"<div class='divul'><h3 class='titleh3' id='title"_seq_"'><a style='color:black' href='#title"_MKBABFJumpOption_"'><span>"_count_".&nbsp;</span>"_MKBABFDesc_"</a></h3>"_"<div id='contentsequlQ"_seq_"' class='contentsequlQ"_seq_"-"_MKBABFExclusion_"'>"_"<div  class='txtcontentul' id='"_MKBABFType_"_"_id_"_"_childsub_"'><ul>"_optionLiHtml_"</ul></div></div></div>"
				}
				else
				{
					s baseHtml=baseHtml_"<div class='divul'><h3 class='titleh3' id='title"_seq_"'><a style='color:black' href='#title"_MKBABFJumpOption_"'>"_MKBABFDesc_"</a></h3>"_"<div id='contentsequlQ"_seq_"' class='contentsequlQ"_seq_"-"_MKBABFExclusion_"'>"_"<div  class='txtcontentul' id='"_MKBABFType_"_"_id_"_"_childsub_"'><ul>"_optionLiHtml_"</ul></div></div></div>"
				}
				//w "<div class='divul'><h3 class='titleh3' id='title"_seq_"'><a style='color:black' href='#title"_MKBABFJumpOption_"'><span>"_count_".&nbsp;</span>"_MKBABFDesc_"</a></h3>"_"<div class='contentsequlQ"_seq_"-"_MKBABFExclusion_"'>"_"<div  class='txtcontentul' id='"_MKBABFType_"_"_id_"_"_childsub_"'><ul>"_optionLiHtml_"</ul></div></div></div>"
				s scripthtml = scripthtml_midscript
			}
			else
			{
				s count=count+1
				//只有一道题不显示题号
				if singlecount=2
				{
					s baseHtml=baseHtml_"<div class='divul'><h3 class='titleh3' id='titleQ"_seq_"' style='"_hstyle_"'><a style='color:black' href='#title"_MKBABFJumpOption_"'><span>"_count_".&nbsp;</span>"_MKBABFDesc_"</a></h3>"_"<div id='contentsequlQ"_seq_"' class='contentsequlQ"_seq_"-"_MKBABFExclusion_"'>"_"<div  class='contentul' id='"_MKBABFType_"_"_id_"_"_childsub_"'><ul>"_optionLiHtml_"</ul></div></div></div>"
				}
				else
				{
					s baseHtml=baseHtml_"<div class='divul'><h3 class='titleh3' id='titleQ"_seq_"'><a style='color:black' href='#title"_MKBABFJumpOption_"'>"_MKBABFDesc_"</a></h3>"_"<div id='contentsequlQ"_seq_"' class='contentsequlQ"_seq_"-"_MKBABFExclusion_"'>"_"<div  class='contentul' id='"_MKBABFType_"_"_id_"_"_childsub_"'><ul>"_optionLiHtml_"</ul></div></div></div>"
				}
				//w "<div class='divul'><h3 class='titleh3' id='titleQ"_seq_"'><a style='color:black' href='#title"_MKBABFJumpOption_"'><span>"_count_".&nbsp;</span>"_MKBABFDesc_"</a></h3>"_"<div id='contentsequlQ"_seq_"' class='contentsequlQ"_seq_"-"_MKBABFExclusion_"'>"_"<div  class='contentul' id='"_MKBABFType_"_"_id_"_"_childsub_"'><ul>"_optionLiHtml_"</ul></div></div></div>"
				s scripthtml = scripthtml_midscript
			}			
		}
    }
    //s midscript = "$HUI.radio(""[name='R"_childsub_"']"",{onCheckChange:function(e,value){getTheCheckBoxValue();}});"
    s scripthtml = scripthtml_"</script>"
    //k ^Tmpautofulllist 
    s baseHtml=baseHtml_"</div>"
    s baseHtml=baseHtml_scripthtml
   
    //显示页脚 
    //s Footer=##class(web.CDSS.Access.Assessment).GetFooterById(id)
    //if Footer'="" w "<div class='assesstitle' style='text-align:left; width:100%'><div style='padding: 20px 30px 20px 50px;font-size: 12px;color: #333;'>"_Footer_"</div></div>"
    q baseHtml
}

/// Creator:chenying
/// CreatDate:2021-05-10
/// Description：获取评估表页脚
/// Input：评估表注册id
/// Return:Footer
/// Other:w ##class(web.DHCBL.MKB.MKBAssessment).GetFooterById(22)
ClassMethod GetFooterById(id) As %String
{
	s Footer=""
	s RowId=0
	for 
	{
		s RowId=$o(^CT.WDT.CDSS.AssBasicInfoI("AssIndex",id,RowId)) q:RowId=""  //评估表基本信息表
		s Footer=$lg($g(^CT.WDT.CDSS.AssBasicInfoD(RowId)),10) //数据值
	}
	q Footer
}

/// Creator:chenghegui
/// CreatDate:2018-05-10
/// Description：根据分值和注册id获得结论和等级
/// Input：注册id,分值
/// Return:结论和等级
/// Other:w ##class(web.DHCBL.MKB.MKBAssessment).GetDescByIdScore(22,3)
ClassMethod GetDescByIdScore(id, score)
{
    
    Q:(id="")||(score="") "[DANDS]"
    s rowid=0
    s desc=""
    s rank=""
    s result=""
    s min=0
    s max=999999999
    for{
       s rowid=$o(^CT.WDT.CDSS.AssScoringRulesI("ParIndex",id,rowid)) q:rowid=""
       s minscore=$LG($G(^CT.WDT.CDSS.AssBaseD(id,"ChildRules",rowid)),4)
       s maxscore=$LG($G(^CT.WDT.CDSS.AssBaseD(id,"ChildRules",rowid)),5)
        // 创建临时global 获取整张表的最大值和最小值 乘以10  为了排除0.开始的数据变字符串的问题.
       s:minscore'="" ^temp("MKBAssessment","minscore","maxscore",minscore*10)=""
       s:maxscore'="" ^temp("MKBAssessment","minscore","maxscore",maxscore*10)=""
       if (rowid=$o(^CT.WDT.CDSS.AssScoringRulesI("ParIndex",id,""),-1)){
           s min=$o(^temp("MKBAssessment","minscore","maxscore",""))
           s max=$o(^temp("MKBAssessment","minscore","maxscore",""),-1)
           k ^temp("MKBAssessment","minscore","maxscore")
       }
       if ((minscore<=score)&&(score<=maxscore))
       {
         s desc=$LG($G(^CT.WDT.CDSS.AssBaseD(id,"ChildRules",rowid)),3)
         s rank=$LG($G(^CT.WDT.CDSS.AssBaseD(id,"ChildRules",rowid)),6)
         s result= desc_"[DANDS]"_rank
       }elseif((score<(min/10))||((max/10)<score)){
         s result= "分值不合理,请您联系您的医生重新测试"_"[DANDS]"_"失真"
       }
       
      
       
    }
    q result
}

/// Creator:fanwenkai
/// CreatDate:2021-04-19
/// Description：绑定评估表可勾选项和规则
/// Input：注册id,分值
/// Return:结论和等级
/// Other:w ##class(web.DHCBL.MKB.MKBAssessment).BindingRules("120","年龄","41-60岁","1","11590")
ClassMethod BindingRules(MKBTableID, BigItem, MinorItem, MinorItemIndex, RuleID) As %String
{
	s RowID = $o(^CT.WDT.CDSS.AssBaseFieldI("DescIndex",MKBTableID," "_$zcvt(BigItem,"U"),0))
	q:RowID="" ""
	s MinorItemAllDesc = $lg($g(^CT.WDT.CDSS.AssBaseD(MKBTableID,"ChildField",RowID)),5)
	s RuleAllDesc = $lg($g(^CT.WDT.CDSS.AssBaseD(MKBTableID,"ChildField",RowID)),7)
	//s MKBBaseID = $lg($g(^CT.WDT.CDSS.AssBaseD(MKBTableID,"ChildField",RowID)),6)
	if (RuleAllDesc = "")
	{
		s obj = ##class(CT.WDT.CDSS.AssBaseField).%OpenId(MKBTableID_"||"_RowID)
		//s obj.MKBABFJoinRule = MinorItemAllDesc
		s obj.MKBABFJoinRule=MinorItemAllDesc
		d obj.%Save()
		d obj.%Close()
		s RuleAllDesc = MinorItemAllDesc
	}
	//else
	//{
		//s RuleDesc = $p(RuleAllDesc,"&%",MinorItemIndex)
	    //s  = $p(RuleID,"^",1) 
	    if (MinorItemIndex = "1")
	    {
		    s RuleNewDesc = RuleID_"^&%"_$p(RuleAllDesc,"&%",(MinorItemIndex+1),*)
		    b ;;
		}
		else
		{
			s RuleNewDesc = $p(RuleAllDesc,"&%",(MinorItemIndex-1))_"&%"_RuleID_"^&%"_$p(RuleAllDesc,"&%",(MinorItemIndex+1),*)
		}  
	    s obj = ##class(CT.WDT.CDSS.AssBaseField).%OpenId(MKBTableID_"||"_RowID)
		s obj.MKBABFJoinRule = RuleNewDesc
		d obj.%Save()
		d obj.%Close()	    
	//}
	q ""
}

/// Creator:fanwenkai
/// CreatDate:2021-04-26
/// Description：获得该评估表的展示项
/// Input：评估表ID
/// Return:评估表的展示项
/// Other:w ##class(web.DHCBL.MKB.MKBAssessment).GetAssBasicInfo("120")
ClassMethod GetAssBasicInfo(AssessmentID As %String) As %String
{
	//^CT.WDT.CDSS.AssBasicInfoI("AssIndex",147,57)
	s rowid = $o(^CT.WDT.CDSS.AssBasicInfoI("AssIndex",AssessmentID,0))
	q:rowid="" "[{id:'',VisitType:'',ShowScoreFlag:'0',ShowResultFlag:'0',ShowConclusionFlag:'0',ScoreCalcaluteType:'Sum'}]"
	s VisitType = $lg($g(^CT.WDT.CDSS.AssBasicInfoD(rowid)),14)
	s ShowScoreFlag = $lg($g(^CT.WDT.CDSS.AssBasicInfoD(rowid)),15)
	if (ShowScoreFlag = "")
	{
		s ShowScoreFlag=0
	}
	s ShowResultFlag = $lg($g(^CT.WDT.CDSS.AssBasicInfoD(rowid)),16)
	if (ShowResultFlag = "")
	{
		s ShowResultFlag=0
	}
	s ShowConclusionFlag = $lg($g(^CT.WDT.CDSS.AssBasicInfoD(rowid)),17)
	if (ShowConclusionFlag = "")
	{
		s ShowConclusionFlag=0
	}
	s ScoreCalcaluteType = $lg($g(^CT.WDT.CDSS.AssBasicInfoD(rowid)),18)
	s result="[{id:'"_rowid_"',VisitType:'"_VisitType_"',ShowScoreFlag:'"_ShowScoreFlag_"',ShowResultFlag:'"_ShowResultFlag_"',ShowConclusionFlag:'"_ShowConclusionFlag_"',ScoreCalcaluteType:'"_ScoreCalcaluteType_"'}]"
	q result
}

/// Creator:fanwenkai
/// CreatDate:2021-04-26
/// Description：获得该评估表的展示项
/// Input：评估表ID
/// Return:评估表的展示项
/// Other:w ##class(web.DHCBL.MKB.MKBAssessment).GetCalcaluteType("120")
ClassMethod GetCalcaluteType(AssessmentID As %String) As %String
{
	//^CT.WDT.CDSS.AssBasicInfoI("AssIndex",147,57)
	s rowid = $o(^CT.WDT.CDSS.AssBasicInfoI("AssIndex",AssessmentID,0))
	q:rowid="" ""
	s ScoreCalcaluteType = $lg($g(^CT.WDT.CDSS.AssBasicInfoD(rowid)),18)
	q ScoreCalcaluteType
}

/// Creator:陈莹
/// CreatDate:2021-05-12
/// Description：获取服务器IP及访问地址
/// Input：
/// Return: 172.18.15.30/imedical/web
/// Other:w ##class(web.DHCBL.MKB.MKBAssessment).GetWebServerLink()
ClassMethod GetWebServerLink() As %String
{
	s WebServerLink=$lg($g(^websys.ConfigurationD(1)),19)_$lg($g(^websys.ConfigurationD(1)),2)
	q WebServerLink
}

/// Creator:丁亚男
/// CreatDate:2021-06-15
/// Description：根据分值和注册id和患者信息获得"APACHE II评分表"的患者死亡率
/// Input：注册id,分值
/// Return:结论和等级
/// Other:w ##class(web.DHCBL.MKB.MKBAssessment).GetDescByIdScorePatient(81,3,"0000000001^2^1^门诊^6465^丁亚男^111^信息部^1^女^2020-01-01^姓名^","true")
ClassMethod GetDescByIdScorePatient(id, score, PatientUserInfo, addoperaflag)
{
    s ^TMP("FFT")=PatientUserInfo
    Q:(id="")||(score="")||(PatientUserInfo="") ""
    s result=""
    s MKBABDesc=$LG($G(^CT.WDT.CDSS.AssBaseD(id)),3)
    if (MKBABDesc="APACHE II评分表")
    {
    
	    s IDNO = $p(PatientUserInfo,"^",1)
	    s PatientDR = $p(PatientUserInfo,"^",2)
		s VisitID = $p(PatientUserInfo,"^",3)
		s VisitType = $p(PatientUserInfo,"^",4)
		s mainbasedr=""
		if ($d(^CT.WDT.CDSS.AssBaseI("DescIndex"," 患者入住ICU的主要疾病分值")))
		{
			s mainbasedr=$o(^CT.WDT.CDSS.AssBaseI("DescIndex"," 患者入住ICU的主要疾病分值",0))
		}
		if (mainbasedr'="") 
		{
			if ($d(^WDT.CDSS.PatientRatingScaleI("RatingScaleDictDrIndex",PatientDR,VisitID," "_VisitType,mainbasedr)))
			{
				s RatingScaleID = $o(^WDT.CDSS.PatientRatingScaleI("RatingScaleDictDrIndex",PatientDR,VisitID," "_VisitType,mainbasedr,""),-1)
				s RatingScore=$lg($g(^WDT.CDSS.PatientRatingScaleD(RatingScaleID)),12)
				if (addoperaflag="true")
				{
					s middlenum=score*0.146+0.603+RatingScore-3.517
				}
				else
				{
					s middlenum=score*0.146+RatingScore-3.517
				}
				s mortality=$ZEXP(middlenum)/(1+$ZEXP(middlenum))
				s mortality=$FNUMBER(100*mortality,"",2)
				s result="群体患者预计病死率为"_mortality_"%。此数据仅为参考数据。"
					
			}
			else
			{
				s result="如需计算群体患者预计病死率，请先做《患者入住ICU的主要疾病分值》评分表！"
			}
		}
		else
		{
			s result="如需计算群体患者预计病死率，请注册《患者入住ICU的主要疾病分值》评分表并评分！"
		}
    }
    q result
}

/// 获取评估量表的名称
/// w ##class(web.DHCBL.MKB.MKBAssessment).getMKBABDesc()
ClassMethod getMKBABDesc(id) As %String
{
	if (id="") q ""
	s MKBABDesc=$LISTGET($G(^CT.WDT.CDSS.AssBaseD(id)),3)
	q MKBABDesc
}

/// Creator:Xuwenhu
/// CreatDate:2021-11-12
/// Description：获得评估表特殊逻辑的展示项
/// Input：评估表ID
/// Return:评估表的展示项
/// Other:w ##class(web.DHCBL.MKB.MKBAssessment).SpecialItem("194")
ClassMethod SpecialItem(AssessmentID As %String) As %String
{
	s type=""
	s result=""
	for
	{
		s type=$o(^CT.WDT.CDSS.AssConResCondiI("AssTypeIndex",AssessmentID,type))
		q:type=""
		if result=""
		{
			s result=type	
		}
		else
		{
			s result=result_","_type
		}
	}
	q result
}

}
