Class web.DHCBL.MKB.MKBAssessment Extends %RegisteredObject
{

/// Creator:chenghegui
/// CreatDate:2018-05-09
/// Description：生成评估系统界面
/// Input：注册id,PatientUserInfo:0000000001^2^1^住院^6465^丁亚男^111^信息部^1^性别^出生日期^姓名^床号^住院号^血型^妊娠状态^身高^体重^患者所在科室编码^患者所在科室名称
/// Return:html页面代码
/// Other:w ##class(web.DHCBL.MKB.MKBAssessment).CreateAssessmentHtml("120")
ClassMethod CreateAssessmentHtml(id As %String, PatientUserInfo As %String)
{
    q:id="" ""
    //获得评估表的计算方式
    s CalcaluteType = ..GetCalcaluteType(id)
    //s CalcaluteMethod=$case(CalcaluteType,"getTheCheckBoxValue":"Sum","getAverageValue":"Avg","getMaxValue":"Max","getTheCheckBoxValue":"")
    s CalcaluteMethod=$case(CalcaluteType,"Sum":"getTheCheckBoxValue","Avg":"getAverageValue","Max":"getMaxValue","":"getTheCheckBoxValue")
    
    if (PatientUserInfo'="")
    {
	    k ^Tmpautofulllist(PatientUserInfo)
	    //kill掉临时Global 防止数据错误
    	//生成之前 先调用自动填充的方法 实现需自动填充项的判断 然后通过该方法生成的临时global对勾选项进行自动勾选
    	d ##class(web.CDSS.TreatDecision.SmartAssessment).GetRatingScaleFieldNew(id,PatientUserInfo)
	}
    s scripthtml = "<script>"
    s midscript =""
    s count=0
    s baseHtml=""
    s optionHeadHtml=""
    s contentHtml=""
    s optionUlHtml=""
    s MKBABDesc=$LG($G(^User.MKBAssessmentBaseD(id)),3)
    //安徽省立该评估表多个题目也只能选择一个选项
    if (MKBABDesc="患者入住ICU的主要疾病分值")
    {
	   s CalcaluteMethod="ClearOtherOption" 
	}
	
	// Oswestry功能障碍指数问卷表（ODI） 单独计算方式
    if (MKBABDesc="Oswestry功能障碍指数问卷表（ODI）")
    {
	   s CalcaluteMethod="OswestryScore" 
	}
	
    s MKBABNote=$LG($G(^User.MKBAssessmentBaseD(id)),4)
    s:MKBABNote="" MKBABNote="备注暂无"
    s MKBABCode=$LG($G(^User.MKBAssessmentBaseD(id)),2)
    s HOSPID="",HOSPDesc=""
    if $d(%session) s HOSPID=$g(%session.Data("LOGON.HOSPID"))
    if HOSPID'="" s HOSPDesc=$p($g(^CT("HOSP",HOSPID)),"^",2)
    ///港大加评估表医院logo
    if (HOSPDesc["香港大学深圳医院")
    {
	    //s UrlLink=".."
	    s UrlLink="http://"_##class(web.DHCBL.MKB.MKBAssessment).GetWebServerLink()  //医为浏览器，需要写成这种路径才能打印出来
	    w "<div style='text-align:center;'><img style='margin-top:20px;' src='"_UrlLink_"/scripts/bdp/Framework/icons/mkb/pgb_logo.jpg'/></div>"
	    //w "<div style='text-align:center;'><img style='margin-top:20px;' src='../scripts/bdp/Framework/icons/mkb/pgb_logo.jpg'/></div>"     
    }
    w "<div class='assesstitle' style='text-align:center; width:100%'><div class='assesshead'>"_MKBABDesc_"</div></div>"
    if (HOSPDesc["香港大学深圳医院")
    {
	    s IDNO=$p(PatientUserInfo,"^",1)
	    
	    if IDNO'=""
	    {
		    s GenderC=$p(PatientUserInfo,"^",10)  //性别
		    s Gender=$SELECT(GenderC="0":"女",GenderC="1":"男",GenderC="2":"其他",1:GenderC)
		    
		    s BirthDate=$p(PatientUserInfo,"^",11)
		    if (BirthDate["-")
		    {
			    s BirthDate=$zdh(BirthDate,"3")
			}
			
		    //s Age=$Select(BirthDate="":"",1:($ZD($H,8)-$ZD(BirthDate,8)\10000))
		    //取年龄
		    s PAADMPAPMIDR=$P($G(^PAADM(IDNO)),"^",1)
		    s Age=##class(web.DHCBillInterface).GetPapmiAge(PAADMPAPMIDR,IDNO)
		    //取电话
		    s MobPhone=""
		    s:PAADMPAPMIDR'="" MobPhone=$P($G(^PAPER(PAADMPAPMIDR,"PER",4)),"^",21)
		    
		   	//取病人号
		    s PatientNO="" //$P($G(^PAADM(IDNO)),"^",81)
		    if (PAADMPAPMIDR'="")
		    {
			    s PAPMIIPNo=$P($G(^PAPER(PAADMPAPMIDR,"PAT",1)),"^",1)
				s PAPMIOPNo=$P($G(^PAPER(PAADMPAPMIDR,"PAT",1)),"^",2)
				if (PAPMIIPNo'="")
				{
					s PatientNO=PAPMIIPNo 
				}
				else
				{
					s PatientNO=PAPMIOPNo 
				}
			}
		    
		    
		    s Name=$p(PatientUserInfo,"^",12) //患者姓名
		    //取床号
		    s BedNum=$p(PatientUserInfo,"^",13)
		    s PAADMCurrentBedDR=$p($G(^PAADM(IDNO)),"^",73)
		    if (BedNum="")
	    	{
	    		s:PAADMCurrentBedDR'="" BedNum=$P($G(^PAWARD(+PAADMCurrentBedDR,"BED",+$P(PAADMCurrentBedDR,"||",2))),"^",1)
	    	}
		    s PatientDeptName=$p(PatientUserInfo,"^",20)
		    //取病区
		    s WARDDesc=""
	    	s PAADMCurrentWardDR=$P($G(^PAADM(IDNO)),"^",70)
	    	s:PAADMCurrentWardDR'="" WARDDesc=$P($G(^PAWARD(PAADMCurrentWardDR)),"^",2)
	    	
		    s VisitType=$p(PatientUserInfo,"^",4)
		    s VisitType=$case(VisitType,1:"急诊",2:"门诊",3:"住院",:VisitType)
		    if (VisitType="住院")
		    {
		    	///输出患者信息
	    		w "<div class='tabletitle' ><table style='padding:4px;' ><tr><td class='titlelabel2'>姓名："_Name_"</td><td class='titlelabel'>病人号："_PatientNO_"</td><td class='titlelabel'>病区："_WARDDesc_"</td><td class='titlelabel2'>性别："_Gender_"</td></tr>"
	    		w "<tr><td class='titlelabel2'>年龄："_Age_"</td><td class='titlelabel'>电话："_MobPhone_"</td><td class='titlelabel'>科室："_PatientDeptName_"</td><td class='titlelabel2'>床号："_BedNum_"</td></tr></table ></div> "
		    }
		    else
		    {
			    ///输出患者信息
	    		w "<div class='tabletitle' ><table style='padding:4px;' ><tr><td class='titlelabel'>姓名："_Name_"</td><td class='titlelabel'>病人号："_PatientNO_"</td><td class='titlelabel'>性别："_Gender_"</td></tr><tr><td class='titlelabel'>年龄："_Age_"</td><td class='titlelabel'>电话："_MobPhone_"</td><td class='titlelabel'>科室："_PatientDeptName_"</td></tr></table ></div> "
		    }
	    }
    }
    else
    {
	    w "<div class='welcome'>欢迎使用评分系统！这是一份评分问卷。</div>"
    }
    w "<hr style='color:#85c8ff;padding:0 50px;border:none; height: 3px; background-color:#85c8ff;'>"  //蓝色分隔线
    w "<div class='assesscontent'>"
    s seq=""
    for
    {
        s seq=$o(^User.MKBAssessmentBaseFieldI("SeqIndex",id,seq)) q:seq=""
        s childsub=0
        for 
        {
            
            s childsub=$o(^User.MKBAssessmentBaseFieldI("SeqIndex",id,seq,childsub)) q:childsub=""
            s MKBABFDesc=$LG($G(^User.MKBAssessmentBaseD(id,"ChildField",childsub)),3)
            s MKBABFType=$LG($G(^User.MKBAssessmentBaseD(id,"ChildField",childsub)),4)
            s MKBABFConfig=$LG($G(^User.MKBAssessmentBaseD(id,"ChildField",childsub)),5)
            s optionLiHtml=""
            s option=""
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
					//长度超过70但是没有长度超过9的 ：不换行
					if (optionLenTotal>70)&&(LongOptionFlag=0)
					{
						s listyle=""
					}
				}
				for optionLeni=1:1:optionLen-1
				{
					s optioniAndSore = $p($g(MKBABFConfig),"&%",optionLeni) 
					s optioni = $p($g(optioniAndSore),"[BDP]",1)
					s optioniSore = $p($g(optioniAndSore),"[BDP]",2)
					if $l(optioni)>80   //对选项内容的长度超过80的，设置高度 2021-04-08
					{
						S height=(($l(optioni)\80)+1)*20
						s heightstyle="height:"_height_"px;"
						
					}
					else
					{
						s heightstyle=""
						
					}
				
					if (MKBABFType="R")   //单选框radio
					{
						if ($d(^Tmpautofulllist))  //$d(^Tmpautofulllist(PatientUserInfo,childsub,optionLeni))
						{
							   s optionLiHtml = optionLiHtml_"<li style='"_listyle_heightstyle_"'><input id='"_optionLeni_"-R"_childsub_"' class='hisui-radio' type='radio' label='"_optioni_"' name='R"_childsub_"' checked='checked' value='"_optionLeni_"_"_optioniSore_"'></li>"
						}
						 else
						 {
							s optionLiHtml = optionLiHtml_"<li style='"_listyle_heightstyle_"'><input id='"_optionLeni_"-R"_childsub_"' class='hisui-radio' type='radio' label='"_optioni_"' name='R"_childsub_"' value='"_optionLeni_"_"_optioniSore_"'></li>"
						 }
						//s midscript = "$HUI.radio(""[name='R"_childsub_"']"",{onCheckChange:function(e,value){getTheCheckBoxValue();}});"
						s midscript = "$HUI.radio(""[name='R"_childsub_"']"",{onCheckChange:function(e,value){"_CalcaluteMethod_"(e,value);}});"
					}
					elseif(MKBABFType="CB")  //复选框
					{
						if ($d(^Tmpautofulllist)) //$d(^Tmpautofulllist(PatientUserInfo,childsub,optionLeni))
						{
						    s optionLiHtml = optionLiHtml_"<li style='"_listyle_heightstyle_"'><input id='"_optionLeni_"-CB"_childsub_"' class='hisui-checkbox'  type='checkbox' label='"_optioni_"' name='CB"_childsub_"' checked='checked' value='"_optionLeni_"_"_optioniSore_"'></li>"
						}
						else
						{
							s optionLiHtml = optionLiHtml_"<li style='"_listyle_heightstyle_"'><input id='"_optionLeni_"-CB"_childsub_"' class='hisui-checkbox'  type='checkbox' label='"_optioni_"' name='CB"_childsub_"' value='"_optionLeni_"_"_optioniSore_"'></li>"
						}
						//s midscript = midscript_"$HUI.checkbox(""[name='CB"_childsub_"']"",{onCheckChange:function(e,value){getTheCheckBoxValue();}});"   
						s midscript = midscript_"$HUI.checkbox(""[name='CB"_childsub_"']"",{onCheckChange:function(e,value){"_CalcaluteMethod_"();}});"
					}
					elseif(MKBABFType="C") //下拉框
					{
						s option=option_"<option value='"_optionLeni_"_"_optioniSore_"'>"_optioni_"</option>"  //下拉框选项
						s midscript = midscript_"$HUI.combobox(""[name='C"_childsub_"']"",{onChange:function(e,value){"_CalcaluteMethod_"();}});" 
					}
				}
				if (MKBABFType="C"){  //下拉框
					s optionLiHtml=optionLiHtml_"<li><select  class='hisui-combobox'  style='width:300px;' name='C"_childsub_"'>"_option_"</select></li>"
				}
				s count=count+1
				w "<div class='divul'><h3 class='titleh3'><span>"_count_".&nbsp;</span>"_MKBABFDesc_"</h3>"_"<div  class='contentul' id='"_MKBABFType_"_"_id_"_"_childsub_"'><ul>"_optionLiHtml_"</ul></div></div>"
				s scripthtml = scripthtml_midscript
			}
			else
			{
				if (MKBABFType="TX")   //文本
				{
					s optionLiHtml = optionLiHtml_"<li><input type='text' style='width:680px' class='textbox'></input><li>"
				}
				elseif(MKBABFType="TA")  //长文本
				{
					s optionLiHtml = optionLiHtml_"<li><textarea style='height:150px;width:680px' class='textarea'></textarea></li>"
				}
				s count=count+1
				w "<div class='divul'><h3 class='titleh3'><span>"_count_".&nbsp;</span>"_MKBABFDesc_"</h3>"_"<div  class='txtcontentul' id='"_MKBABFType_"_"_id_"_"_childsub_"'><ul>"_optionLiHtml_"</ul></div></div>"
				s scripthtml = scripthtml_midscript
			} 
			
		}
    }
    //s midscript = "$HUI.radio(""[name='R"_childsub_"']"",{onCheckChange:function(e,value){getTheCheckBoxValue();}});"
    s scripthtml = scripthtml_"</script>"
    //k ^Tmpautofulllist 
    w "</div>"
    w scripthtml
   
    //显示页脚 
    //s Footer=##class(web.DHCBL.MKB.MKBAssessment).GetFooterById(id)
    //if Footer'="" w "<div class='assesstitle' style='text-align:left; width:100%'><div style='padding: 20px 30px 20px 50px;font-size: 12px;color: #333;'>"_Footer_"</div></div>"
    q ""
}

/// Creator:Xuwenhu
/// CreatDate:2020-08-24
/// Description：生成评估系统界面
/// Input：注册id,PatientUserInfo:0000000001^2^1^住院^6465^丁亚男^111^信息部^1^性别^出生日期^姓名^床号^住院号^血型^妊娠状态^身高^体重^患者所在科室编码^患者所在科室名称
/// Return:html页面代码
/// Other:w ##class(web.DHCBL.MKB.MKBAssessment).CreateAssessmentHtmlNew("120")
ClassMethod CreateAssessmentHtmlNew(id As %String, PatientUserInfo As %String)
{
    q:id="" ""
    //获得评估表的计算方式
    s CalcaluteType = ..GetCalcaluteType(id)
    //s CalcaluteMethod=$case(CalcaluteType,"getTheCheckBoxValue":"Sum","getAverageValue":"Avg","getMaxValue":"Max","getTheCheckBoxValue":"")
    s CalcaluteMethod=$case(CalcaluteType,"Sum":"getTheCheckBoxValue","Avg":"getAverageValue","Max":"getMaxValue","":"getTheCheckBoxValue")
    
    if (PatientUserInfo'="")
    {
	    k ^Tmpautofulllist(PatientUserInfo)
	    //kill掉临时Global 防止数据错误
    	//生成之前 先调用自动填充的方法 实现需自动填充项的判断 然后通过该方法生成的临时global对勾选项进行自动勾选
    	d ##class(web.CDSS.TreatDecision.SmartAssessment).GetRatingScaleFieldNew(id,PatientUserInfo)
	}
    s scripthtml = "<script>"
    s midscript =""
    s count=0
    s baseHtml=""
    s optionHeadHtml=""
    s contentHtml=""
    s optionUlHtml=""
    s MKBABDesc=$LG($G(^User.MKBAssessmentBaseD(id)),3)
    // Oswestry功能障碍指数问卷表（ODI） 单独计算方式
    if (MKBABDesc="Oswestry功能障碍指数问卷表（ODI）")
    {
	   s CalcaluteMethod="OswestryScore" 
	}
	
    s MKBABNote=$LG($G(^User.MKBAssessmentBaseD(id)),4)
    s:MKBABNote="" MKBABNote="备注暂无"
    s MKBABCode=$LG($G(^User.MKBAssessmentBaseD(id)),2)
    
    w "<div class='assesstitle' style='text-align:center; width:100%'><div class='assesshead'>"_MKBABDesc_"</div></div>"
	w "<div class='welcome'>欢迎使用评分系统！这是一份评分问卷。</div>"
    
    w "<hr style='color:#85c8ff;padding:0 50px;border:none; height: 3px; background-color:#85c8ff;'>"  //蓝色分隔线
    w "<div class='assesscontent'>"
    s seq=""
    for
    {
        s seq=$o(^User.MKBAssessmentBaseFieldI("SeqIndex",id,seq)) q:seq=""
        s childsub=0
        for 
        {
            
            s childsub=$o(^User.MKBAssessmentBaseFieldI("SeqIndex",id,seq,childsub)) q:childsub=""
            s MKBABFDesc=$LG($G(^User.MKBAssessmentBaseD(id,"ChildField",childsub)),3)
            s MKBABFType=$LG($G(^User.MKBAssessmentBaseD(id,"ChildField",childsub)),4)
            s MKBABFConfig=$LG($G(^User.MKBAssessmentBaseD(id,"ChildField",childsub)),5)
            s optionLiHtml=""
            s option=""
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
					//长度超过70但是没有长度超过9的 ：不换行
					if (optionLenTotal>70)&&(LongOptionFlag=0)
					{
						s listyle=""
					}
				}
				for optionLeni=1:1:optionLen-1
				{
					s optioniAndSore = $p($g(MKBABFConfig),"&%",optionLeni) 
					s optioni = $p($g(optioniAndSore),"[BDP]",1)
					s optioniSore = $p($g(optioniAndSore),"[BDP]",2)
					if $l(optioni)>80   //对选项内容的长度超过80的，设置高度 2021-04-08
					{
						S height=(($l(optioni)\80)+1)*20
						s heightstyle="height:"_height_"px;"
						
					}
					else
					{
						s heightstyle=""
						
					}
				
					if (MKBABFType="R")   //单选框radio
					{
						if ($d(^Tmpautofulllist))  //$d(^Tmpautofulllist(PatientUserInfo,childsub,optionLeni))
						{
							   s optionLiHtml = optionLiHtml_"<li style='"_listyle_heightstyle_"'><input id='"_optionLeni_"-R"_childsub_"' class='hisui-radio' type='radio' label='"_optioni_"' name='R"_childsub_"' checked='checked' value='"_optionLeni_"_"_optioniSore_"'></li>"
						}
						 else
						 {
							s optionLiHtml = optionLiHtml_"<li style='"_listyle_heightstyle_"'><input id='"_optionLeni_"-R"_childsub_"' class='hisui-radio' type='radio' label='"_optioni_"' name='R"_childsub_"' value='"_optionLeni_"_"_optioniSore_"'></li>"
						 }
						//s midscript = "$HUI.radio(""[name='R"_childsub_"']"",{onCheckChange:function(e,value){getTheCheckBoxValue();}});"
						s midscript = "$HUI.radio(""[name='R"_childsub_"']"",{onCheckChange:function(e,value){"_CalcaluteMethod_"(e,value);}});"
					}
					elseif(MKBABFType="CB")  //复选框
					{
						if ($d(^Tmpautofulllist)) //$d(^Tmpautofulllist(PatientUserInfo,childsub,optionLeni))
						{
						    s optionLiHtml = optionLiHtml_"<li style='"_listyle_heightstyle_"'><input id='"_optionLeni_"-CB"_childsub_"' class='hisui-checkbox'  type='checkbox' label='"_optioni_"' name='CB"_childsub_"' checked='checked' value='"_optionLeni_"_"_optioniSore_"'></li>"
						}
						else
						{
							s optionLiHtml = optionLiHtml_"<li style='"_listyle_heightstyle_"'><input id='"_optionLeni_"-CB"_childsub_"' class='hisui-checkbox'  type='checkbox' label='"_optioni_"' name='CB"_childsub_"' value='"_optionLeni_"_"_optioniSore_"'></li>"
						}
						//s midscript = midscript_"$HUI.checkbox(""[name='CB"_childsub_"']"",{onCheckChange:function(e,value){getTheCheckBoxValue();}});"   
						s midscript = midscript_"$HUI.checkbox(""[name='CB"_childsub_"']"",{onCheckChange:function(e,value){"_CalcaluteMethod_"();}});"
					}
					elseif(MKBABFType="C") //下拉框
					{
						s option=option_"<option value='"_optionLeni_"_"_optioniSore_"'>"_optioni_"</option>"  //下拉框选项
						s midscript = midscript_"$HUI.combobox(""[name='C"_childsub_"']"",{onChange:function(e,value){"_CalcaluteMethod_"();}});" 
					}
				}
				if (MKBABFType="C"){  //下拉框
					s optionLiHtml=optionLiHtml_"<li><select  class='hisui-combobox'  style='width:300px;' name='C"_childsub_"'>"_option_"</select></li>"
				}
				s count=count+1
				w "<div class='divul'><h3 class='titleh3'><span>"_count_".&nbsp;</span>"_MKBABFDesc_"</h3>"_"<div  class='contentul' id='"_MKBABFType_"_"_id_"_"_childsub_"'><ul>"_optionLiHtml_"</ul></div></div>"
				s scripthtml = scripthtml_midscript
			}
			else
			{
				if (MKBABFType="TX")   //文本
				{
					s optionLiHtml = optionLiHtml_"<li><input type='text' style='width:680px' class='textbox'></input><li>"
				}
				elseif(MKBABFType="TA")  //长文本
				{
					s optionLiHtml = optionLiHtml_"<li><textarea style='height:150px;width:680px' class='textarea'></textarea></li>"
				}
				s count=count+1
				w "<div class='divul'><h3 class='titleh3'><span>"_count_".&nbsp;</span>"_MKBABFDesc_"</h3>"_"<div  class='txtcontentul' id='"_MKBABFType_"_"_id_"_"_childsub_"'><ul>"_optionLiHtml_"</ul></div></div>"
				s scripthtml = scripthtml_midscript
			} 
			
		}
    }
    //s midscript = "$HUI.radio(""[name='R"_childsub_"']"",{onCheckChange:function(e,value){getTheCheckBoxValue();}});"
    s scripthtml = scripthtml_"</script>"
    //k ^Tmpautofulllist 
    w "</div>"
    w scripthtml
   
    //显示页脚 
    //s Footer=##class(web.DHCBL.MKB.MKBAssessment).GetFooterById(id)
    //if Footer'="" w "<div class='assesstitle' style='text-align:left; width:100%'><div style='padding: 20px 30px 20px 50px;font-size: 12px;color: #333;'>"_Footer_"</div></div>"
    q ""
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
		s RowId=$o(^User.DHCDSSAssBasicInfoI("AssIndex",id,RowId)) q:RowId=""  //评估表基本信息表
		s Footer=$lg($g(^User.DHCDSSAssBasicInfoD(RowId)),10) //数据值
	}
	q Footer
}

/// Creator:chenghegui
/// CreatDate:2018-05-10
/// Description：根据分值和注册id获得结论和等级
/// Input：注册id,分值
/// Return:结论和等级
/// Other:w ##class(web.DHCBL.MKB.MKBAssessment).GetDescByIdScore(22,4)
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
       s rowid=$o(^User.MKBAssessmentScoringRulesI("ParIndex",id,rowid)) q:rowid=""
       s minscore=$LG($G(^User.MKBAssessmentBaseD(id,"ChildRules",rowid)),4)
       s maxscore=$LG($G(^User.MKBAssessmentBaseD(id,"ChildRules",rowid)),5)
       //w minscore,!,maxscore,!
       // 创建临时global 获取整张表的最大值和最小值 乘以10  为了排除0.开始的数据变字符串的问题.
       s:minscore'="" Arr("minscore")=minscore*10
       s:maxscore'="" Arr("maxscore")=maxscore*10
       if (rowid=$o(^User.MKBAssessmentScoringRulesI("ParIndex",id,""),-1)){
           s min=Arr("minscore")
           s max=Arr("maxscore")
           k Arr
       }
       if ((minscore<=score)&&(score<=maxscore))
       {
           s desc=$LG($G(^User.MKBAssessmentBaseD(id,"ChildRules",rowid)),3)
           s rank=$LG($G(^User.MKBAssessmentBaseD(id,"ChildRules",rowid)),6)
           s result= desc_"[DANDS]"_rank
           q
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
	s RowID = $o(^User.MKBAssessmentBaseFieldI("DescIndex",MKBTableID," "_$zcvt(BigItem,"U"),0))
	q:RowID="" ""
	s MinorItemAllDesc = $lg($g(^User.MKBAssessmentBaseD(MKBTableID,"ChildField",RowID)),5)
	s RuleAllDesc = $lg($g(^User.MKBAssessmentBaseD(MKBTableID,"ChildField",RowID)),7)
	//s MKBBaseID = $lg($g(^User.MKBAssessmentBaseD(MKBTableID,"ChildField",RowID)),6)
	if (RuleAllDesc = "")
	{
		s obj = ##class(User.MKBAssessmentBaseField).%OpenId(MKBTableID_"||"_RowID)
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
	    s obj = ##class(User.MKBAssessmentBaseField).%OpenId(MKBTableID_"||"_RowID)
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
	//^User.DHCDSSAssBasicInfoI("AssIndex",147,57)
	s rowid = $o(^User.DHCDSSAssBasicInfoI("AssIndex",AssessmentID,0))
	q:rowid="" "[{id:'',VisitType:'',ShowScoreFlag:'0',ShowResultFlag:'0',ShowConclusionFlag:'0',ScoreCalcaluteType:'Sum'}]"
	s VisitType = $lg($g(^User.DHCDSSAssBasicInfoD(rowid)),14)
	s ShowScoreFlag = $lg($g(^User.DHCDSSAssBasicInfoD(rowid)),15)
	if (ShowScoreFlag = "")
	{
		s ShowScoreFlag=0
	}
	s ShowResultFlag = $lg($g(^User.DHCDSSAssBasicInfoD(rowid)),16)
	if (ShowResultFlag = "")
	{
		s ShowResultFlag=0
	}
	s ShowConclusionFlag = $lg($g(^User.DHCDSSAssBasicInfoD(rowid)),17)
	if (ShowConclusionFlag = "")
	{
		s ShowConclusionFlag=0
	}
	s ScoreCalcaluteType = $lg($g(^User.DHCDSSAssBasicInfoD(rowid)),18)
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
	//^User.DHCDSSAssBasicInfoI("AssIndex",147,57)
	s rowid = $o(^User.DHCDSSAssBasicInfoI("AssIndex",AssessmentID,0))
	q:rowid="" ""
	s ScoreCalcaluteType = $lg($g(^User.DHCDSSAssBasicInfoD(rowid)),18)
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
    s MKBABDesc=$LG($G(^User.MKBAssessmentBaseD(id)),3)
    if (MKBABDesc="APACHE II评分表")
    {
    
	    s IDNO = $p(PatientUserInfo,"^",1)
	    s PatientDR = $p(PatientUserInfo,"^",2)
		s VisitID = $p(PatientUserInfo,"^",3)
		s VisitType = $p(PatientUserInfo,"^",4)
		s mainbasedr=""
		if ($d(^User.MKBAssessmentBaseI("DescIndex"," 患者入住ICU的主要疾病分值")))
		{
			s mainbasedr=$o(^User.MKBAssessmentBaseI("DescIndex"," 患者入住ICU的主要疾病分值",0))
		}
		if (mainbasedr'="") 
		{
			if ($d(^User.DHCDSSPatientRatingScaleI("RatingScaleDictDrIndex",PatientDR,VisitID," "_VisitType,mainbasedr)))
			{
				s RatingScaleID = $o(^User.DHCDSSPatientRatingScaleI("RatingScaleDictDrIndex",PatientDR,VisitID," "_VisitType,mainbasedr,""),-1)
				s RatingScore=$lg($g(^User.DHCDSSPatientRatingScaleD(RatingScaleID)),12)
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
	s MKBABDesc=$LISTGET($G(^User.MKBAssessmentBaseD(id)),3)
	q MKBABDesc
}

}
