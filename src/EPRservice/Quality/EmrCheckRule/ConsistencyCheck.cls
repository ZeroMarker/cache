/// CreatDate:	2020-01-20
/// Creator:	YK
/// Desc:		住院病案首页质控后台类方法
/// 			时限性质控方法及非住院病案首页一致性条目后台类方法不要添加到此方法中
Class EPRservice.Quality.EmrCheckRule.ConsistencyCheck Extends %RegisteredObject
{

/// CreatDate:	2021-06-22
/// Creator:	GY
/// Desc:		【实际住院天数】=【出院时间】-【入院时间】。
/// Input:		AEpisodeID为患者就诊号;
/// Return:		ret<0:不一致; ret=1一致;
/// Debug:		w ##Class(EPRservice.Quality.EmrCheckRule.ConsistencyCheck).IsUnify0001(EpisodeID,"住院天数code","入院时间code","出院时间code")
ClassMethod IsUnify0001(AEpisodeID As %String, AElement1 As %String, AElement2 As %String, AElement3 As %String) As %String
{
	s ret=0
	q:(AEpisodeID="")||(AElement1="")||(AElement2="")||(AElement3="") ret
	
	s ret=1 
	s ElementData1=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,AElement1,"")
	s ElementData1=+$tr(ElementData1,"-\—","")
	
	s InHospDays=""
	s InHospDays=##Class(EPRservice.Quality.DataGather.AdmInfo).ResidentDaysAdm(AEpisodeID)
	
	s:(InHospDays'=ElementData1) ret=-1
	
	s ElementCode=""
	s:(ret=-1) ElementCode=##Class(EPRservice.Quality.DataAccess.BOQualityPool).GetElementCode(AElement1_"\"_AElement2_"\"_AElement3)
	q ret_"@"_ElementCode
}

/// CreatDate:	2020-01-20
/// Creator:	YK
/// Desc:		病案首页.【药物过敏】为"有"时，【过敏药物】名称不能为空或者-/—。当【药物过敏】为"无"时，【过敏药物】只能是-/—。请检查。
/// 			病案首页.【是否有31天再入院计划】填写"有"时，【目的】不能为空或者-/—。当【是否有31天再入院计划】填写"无"时，【目的】只能为空或者-/—。
/// Input:		AEpisodeID为患者就诊号;
/// Return:		ret<0:不一致; ret=1一致;
/// Debug:		w ##Class(EPRservice.Quality.EmrCheckRule.ConsistencyCheck).IsUnify0002(EpisodeID,"药物过敏code","过敏药物code","有")
ClassMethod IsUnify0002(EpisodeID As %String, Element1 As %String, Elements2 As %String) As %String
{
	s ret=0
	q:(EpisodeID="")||(Element1="")||(Elements2="") ret
	
	s ret=1
	s ElementData1=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(EpisodeID,Element1,"")
	s ElementData1=$tr(ElementData1,"-\—","")
	q:(ElementData1 = "") ret
	
	s ElementsData2=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(EpisodeID,Elements2,"")
	s ElementsData2=$tr(ElementsData2,"-","")
	s ElementsData2=$tr(ElementsData2,"─","") 
	
	// 【药物过敏】为"有"时，【过敏药物】名称不能为空或者-/—。
	// 【是否有31天再入院计划】填写"有"时，【目的】不能为空或者-/—。
	s:(ElementData1="有")&&(ElementsData2="") ret = "-1"
	
	///【离院方式】为”医嘱转院”时，【拟接收医疗机构名称】不能为空或者-/—。
	///【离院方式】为”医嘱转社区卫生服务机构/乡镇卫生院”时，【拟接收医疗机构】不能为空或者-/—。
	s:(ElementData1="医嘱转院")&&(ElementsData2="") ret = "-1"
	s:(ElementData1="医嘱转社区卫生服务机构/乡镇卫生院")&&(ElementsData2="") ret = "-1"
	
	// 【药物过敏】为"无"时，【过敏药物】只能是-/—。
	// 【是否有31天再入院计划】填写"无"时，【目的】只能为空或者-/—。
	s:(ElementData1="无")&&(ElementsData2'="") ret = "-1"
	
	s ElementCode=""
	s:(ret=-1) ElementCode=##Class(EPRservice.Quality.DataAccess.BOQualityPool).GetElementCode(Element1_"\"_Elements2)
	q ret_"@"_ElementCode
}

/// CreatDate:	2020-01-20
/// Creator:	YK
/// Desc:		同一模板中多元素一致性判断，当Element1为Values1中任意各值，Elements2中各元素有任何一个为Value2时触发
/// Input:		AEpisodeID为患者就诊号;
/// Return:		ret<0:不一致; ret=1一致;
/// Debug:		w ##Class(EPRservice.Quality.EmrCheckRule.ConsistencyCheck).IsUnify0003(EpisodeID,Element1,Elements2,Values1,Value2)
ClassMethod IsUnify0003(EpisodeID As %String, Element1 As %String, Elements2 As %String, Values1 As %String, Values2 As %String) As %String
{
	s ret=0
	q:(EpisodeID="")||(Element1="")||(Elements2="") ret
	
	s ret=1 
	s ElementData1=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(EpisodeID,Element1,"")
	s ElementData1=$tr(ElementData1,"-\—","")
	q:(ElementData1 = "") ret
	
	s ElementsData2=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(EpisodeID,Elements2,"")
	//s ElementsData2=$tr(ElementsData2,"-\—","")
	//q:(ElementsData2="") ret
	
	for i=1:1:$l(Values1,"\") 
	{
		s Value1=$p(Values1,"\",i)
		if (ElementData1=Value1)
		{
			for j = 1:1:$l(Values2,"\")
			{
				s Value2=$p(Values2,"\",j)
				s:(ElementsData2=Value2)||(ElementsData2="") ret=-1
			}
		}
	}
	
	s ElementCode=""
	s:(ret=-1) ElementCode=##Class(EPRservice.Quality.DataAccess.BOQualityPool).GetElementCode(Element1_"\"_Elements2)
	q ret_"@"_ElementCode
}

/// CreatDate:	2020-06-22
/// Creator:	GY
/// Desc:		患者【年龄】>0时，【年龄不足1周岁的年龄(天)】应为0或空
///             【年龄不足1周岁的年龄(天)】填写且小于29天时，【年龄】需等于零。
/// Input:		AEpisodeID为患者就诊号,ArgElement1:年龄,ArgElement2：不足一周岁年龄,AQuaPatType 质控患者类型(A 成人，B 婴幼儿)
/// Return:		ret<0:不一致; ret=1一致;
/// d ##class(EPRservice.Quality.EmrCheckRule.ConsistencyCheck).IsUnify0004(EpisodeID,"年龄code","不足一周岁年龄code","A")
ClassMethod IsUnify0004(ArgEpisodeID As %String, ArgElement1 As %String, ArgElement2 As %String, AQuaPatType As %String) As %String
{
	s ret=0
	q:(ArgEpisodeID="")||(ArgElement1="")||(ArgElement2="") ret
	
	s ret=1
	//年龄
	s ElementData1=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(ArgEpisodeID,ArgElement1,"")
	s:(ElementData1["岁") ElementData1=$P(ElementData1,"岁",1)
	q:(ElementData1>0) ret
	//不足一周岁年龄
	s ElementData2=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(ArgEpisodeID,ArgElement1,"")
	s:(AQuaPatType="A")&&(+ElementData1>0)&&(+ElementData2'=0) ret=-1
	s:(AQuaPatType="B")&&($tr(ElementData2,"-\—","")'="")&&(ElementData1'="0") ret=-1
	
	s ElementCode=""
	s:(ret=-1) ElementCode=##Class(EPRservice.Quality.DataAccess.BOQualityPool).GetElementCode(ArgElement1_"\"_ArgElement2)
	q ret_"@"_ElementCode
}

/// CreatDate:	2020-01-20
/// Creator:	YK
/// Desc: 		判断病案首页'离院方式'和'尸检'是否一致
///       		离院方式等于'死亡'时，尸检不能为空
///       		离院方式不等于'死亡'时，尸检必须为空
/// Input:		AEpisodeID为患者就诊号;
/// Return:		ret<0:不一致; ret=1一致;
/// Debug:		w ##Class(EPRservice.Quality.EmrCheckRule.ConsistencyCheck).IsUnify0005(EpisodeID,"离院方式code","尸检code")
ClassMethod IsUnify0005(AEpisodeID As %String, AElement1 As %String, AElement2 As %String) As %String
{
	s ret = 0
	q:((AEpisodeID = "")||(AElement1 = "")) ret
	
	s ret = 1
    s Elementdata1=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,AElement1,"")
    s Elementdata1=$tr(Elementdata1,"-\—","")
    q:Elementdata1="" ret
    
    s Elementdata2=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,AElement2,"")
    s Elementdata2=$tr(Elementdata2,"-\—","")
    
    // 离院方式等于'死亡'时，尸检不能为空。
    s:((Elementdata1="死亡")&&(Elementdata2="")) ret=-1
    
    // 离院方式不等于'死亡'时，尸检必须为空。
    s:((Elementdata1'="死亡")&&(Elementdata2'="")) ret=-1
    
    s ElementCode=""
	s:(ret=-1) ElementCode=##Class(EPRservice.Quality.DataAccess.BOQualityPool).GetElementCode(AElement1_"\"_AElement2)
	q ret_"@"_ElementCode
}

/// CreatDate:	2020-01-20
/// Creator:	YK
/// Desc: 		判断日期单元是否超出入出院时间(比如病案首页中确诊日期、手术日期等，为空则不判断);
/// Input:		AEpisodeID为患者就诊号;
/// Return:		ret<0:不一致; ret=1一致;
/// Debug:		w ##Class(EPRservice.Quality.EmrCheckRule.ConsistencyCheck).IsUnify0006(EpisodeID,"手术日期1code",{HISRegTime1},{HISDischTime2},"出院时间code")
ClassMethod IsUnify0006(AEpisodeID As %String, AElement1 As %String, ARegDate As %String, ADischDate As %String, AElement2 As %String = "") As %String
{
	s ret = 0
	q:(AEpisodeID = "")||(AElement1 = "")||(ARegDate = "") ret
	
	s ElementData1 = ##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,AElement1,"")
	q:(ElementData1 = "") ret
	
	//Add by Liaowp 2010-06-22
	//首页中当日确诊,确诊日期没有时间,默认为00:00:00,此条不通过
	s DateTime1 = ##Class(EPRservice.Quality.CommonHelper).ChangeDateTime(ElementData1)
	s DateTime2 = ##Class(EPRservice.Quality.CommonHelper).ChangeDateTime(ARegDate)
	s Date1 = $p(DateTime1," ",1),Time1 = $p(DateTime1," ",2)
	s Date2 = $p(DateTime2," ",1),Time2 = $p(DateTime2," ",2)
	s:((Date1=Date2)&&(Time1="00:00:00")&&(Time2'="00:00:00")) DateTime1 = DateTime2
	//End Add
	
	s ret = 1
	s flag = ##Class(EPRservice.Quality.CommonHelper).GetDateTimeGap(DateTime1,ARegDate)
	s:(flag < 0) ret = -1
	
	s:(ADischDate="") ADischDate = $zd(+$h,3)_" "_$zt($p($h,",",2),1)
	s flag = ##Class(EPRservice.Quality.CommonHelper).GetDateTimeGap(ADischDate,DateTime1)
	s:(flag < 0) ret = -1
	
	if (AElement2 '= "")
	{
		s ElementData2 = ##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,AElement2,"")
		q:(ElementData2 = "") ret
		
		s Element2DateTime = ##Class(EPRservice.Quality.CommonHelper).ChangeDateTime(ElementData2)
		s flag = ##Class(EPRservice.Quality.CommonHelper).GetDateTimeGap(Element2DateTime,DateTime1)
		s:(flag < 0) ret = -1
	}
	
	s ElementCode=""
	s:(ret=-1) ElementCode=##Class(EPRservice.Quality.DataAccess.BOQualityPool).GetElementCode(AElement1_"\"_AElement2)
	q ret_"@"_ElementCode
}

/// CreatDate:	2020-06-22
/// Creator:	GY
/// Desc:		【新生儿出生体重】>0时，患者应为产妇(主要诊断或其他诊断包含”Z37.0,Z37.2, Z37.3, Z37.5, Z37.6”)或新生儿(年龄为0,年龄不足1周岁的年龄(天)<29天)。
/// Input:		AEpisodeID为患者就诊号;AElementID1 新生儿体重;AElementIDs 诊断;AValues 诊断符合值; AElementID2 年龄;AElementID3 不足一周岁的年龄(天)
/// Return:		ret<0:不一致; ret=1一致;
/// Debug:		w ##Class(EPRservice.Quality.EmrCheckRule.ConsistencyCheck).IsUnify0007(EpisodeID,"新生儿出生体重code",{HISDiagCodes},"Z37.0\Z37.2\Z37.3\Z37.5\Z37.6","年龄code","年龄天code")
ClassMethod IsUnify0007(AEpisodeID As %String, AElementID1 As %String, AElementIDs As %String, AValues As %String, AElementID2 As %String, AElementID3 As %String = "") As %String
{
	s ret = 0
	q:(AEpisodeID = "")||(AElementIDs = "") ret
	
	s ElementData1=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,AElementID1,"")
	q:(+ElementData1=0) ret
	
	s ret=1
	
	///诊断
	s DiagData="",flag=0
	for I=1:1:$l(AElementIDs,"\")
	{
		s ElementID=$p(AElementIDs,"\",I)
		s DiagData=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,ElementID,"")
		continue:($tr(DiagData,"-\—","")="")
		for J=1:1:$l(AValues,"\")
		{
			s Value=$p(AValues,"\",J)
			continue:(Value'=$e(DiagData,1,$l(Value)))
			s flag=1
			q
		}
		continue:(flag=0)
		q
	}
	q:(flag=1) ret
	
	///年龄
	s ElementData2=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,AElementID2,"")
	q:(+ElementData2=0) ret
	
	if (AElementID3'="") 
	{
		s ElementData3=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,AElementID3,"")
		q:(+ElementData3<29) ret
	}
	s ret=-1
	
	s ElementCode=""
	s:(ret=-1) ElementCode=##Class(EPRservice.Quality.DataAccess.BOQualityPool).GetElementCode(AElementID1_"\"_AElementIDs_"\"_AElementID2_"\"_AElementID3)
	q ret_"@"_ElementCode
}

/// CreatDate:	2020-06-22
/// Creator:	GY
/// Desc:	   【新生儿入院体重】>0时，患者【年龄】应=0，且【年龄不足1周岁的年龄(天)】<29天
/// Input:		AEpisodeID为患者就诊号;AElementID1 新生儿体重;AElementID2 年龄;AElementID3 不足一周岁的年龄(天)
/// Return:		ret<0:不一致; ret=1一致;
/// Debug:		w ##Class(EPRservice.Quality.EmrCheckRule.ConsistencyCheck).IsUnify0008(EpisodeID,"新生儿出生体重code","年龄code","年龄天code")
ClassMethod IsUnify0008(AEpisodeID As %String, AElementID1 As %String, AElementID2 As %String, AElementID3 As %String = "") As %String
{
	s ret = 0
	q:(AEpisodeID = "")||(AElementID1 = "") ret
	
	s ElementData1=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,AElementID1,"")
	q:(+ElementData1=0) ret
	
	s ret=1
	
	///年龄
	s ElementData2=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,AElementID2,"")
	//b ;1
	//q:(+ElementData2=0) ret
	
	if (AElementID3'="") 
	{
		s ElementData3=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,AElementID3,"")
		S:(ElementData3="") ret="-1"
		if ElementData3'=""
		{
			s sum=""
			s sum= $P(ElementData3,"/",1)
			s sum= $tr(sum," ","")
			
			s:(sum="") ret= "-1"
			}
		
		q:(+sum<29) ret
	}
	s ret=-1
	
	s ElementCode=""
	s:(ret=-1) ElementCode=##Class(EPRservice.Quality.DataAccess.BOQualityPool).GetElementCode(AElementID1_"\"_AElementID2_"\"_AElementID3)
	q ret_"@"_ElementCode
}

/// 病案首页.护士未做最终结算，则不允许打印首页
/// AHisInterface:HIS最终结算时间（不为空：做完最终结算，为空：未做最终结算）
ClassMethod IsUnify0009(ArgEpisodeID As %String, AHISDischTime2 As %String)
{
	s ret=0
   
	q:(ArgEpisodeID="") ret
	
	s ret=1
	s:(AHISDischTime2="") ret=-1
	
	q ret
}

/// CreatDate:	2021-06-22
/// Creator:	GY
/// Desc:		【主要手术及操作】【其他手术及操作】信息属性为手术时，【手术费】应>0。
/// Input:		AEpisodeID为患者就诊号;AElementID：主要手术及操作名称; AOPType 手术类别要求(N 手术、I 介入治疗); AElementIDs：手术费
/// Return:		ret<0:不一致; ret=1一致;
/// Debug:		w ##class(EPRservice.Quality.EmrCheckRule.ConsistencyCheck).IsUnify0010(EpisodeID,"主要手术及操作名称code","N","手术费code")
ClassMethod IsUnify0010(AEpisodeID As %String, AElementID As %String, AOPType As %String, AElementIDs As %String) As %String
{
	s ret=0
	q:(AEpisodeID="")||(AElementID="")||(AElementIDs="") ret
	
	s ElementData=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,AElementID,"")
    q:(+ElementData="") ret
	
	s ElementIDList="", ret=1
	for I=1:1:$l(AElementIDs,"\")
	{
		s ElementID=$p(AElementIDs,"\",I)
		s tmpElementData=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,ElementID,"")
		
		s OPERType="",OPERRowId=""
		s OperDesc=$$ALPHAUP^SSUTIL4(tmpElementData)
		s OPERRowId=$O(^ORC("OPER",0,"Desc",OperDesc,OPERRowId)) 
		continue:(OPERRowId="")
		s OPERType=$p($g(^ORC("OPER",OPERRowId,"DHC")),"^",11)
		s:(AOPType[OPERType) ret=-1
		s:(ret=-1) ElementIDList=ElementID_"\"_AElementID
		q:(ret=-1)
	}
		
	s ElementCode=""
	s:(ret=-1) ElementCode=##Class(EPRservice.Quality.DataAccess.BOQualityPool).GetElementCode(ElementIDList)
	q ret_"@"_ElementCode
}

/// CreatDate: 2021-06-23
/// Creator:   GY
/// Desc:      当主要诊断或其他诊断【出院情况】为"死亡"时,则【离院方式】必须为死亡
/// Input:     AEpisodeID:就诊号,AElement1 条件单元rowid ,isnt1（"="或者"<>"）,AValue1 条件单元的值,AElement2 限定结果单元rowid ,isnt2（"="或者"<>"）, AValue2 限定结果单元的值
/// Return:	   ret<0:不一致; ret=1一致;
/// Debug:     ##Class(EPRservice.Quality.EmrCheckRule.ConsistencyCheck).IsUnify0011(EpisodeID,"","<>","死亡","","<>","")
ClassMethod IsUnify0011(AEpisodeID As %String, AElement1 As %String, isnt1 As %String, AValue1 As %String = "", AElement2 As %String, isnt2 As %String, AValue2 As %String = "") As %String
{
	s ret = 0
	q:((AEpisodeID = "")||(AElement1 = "")) ret
	s ret = 1
    s Elementdata1=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,AElement1,"")
    s:(AValue1="") Elementdata1=$tr(Elementdata1,"-\—\ ","")
    //q:(Elementdata1="") ret
    s Elementdata2=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,AElement2,"")
    s:(AValue2="") Elementdata2=$tr(Elementdata2,"-\—\ ","")
    //q:(Elementdata2="") ret
    
    if isnt1="="
    {
    	q:Elementdata1'=AValue1 ret
	    if (isnt2="=")
	    {
	    	q:Elementdata2=AValue2 ret
	    	s:Elementdata2'=AValue2 ret=-1
	    }
	    if (isnt2="<>")
	    {
	    	q:Elementdata2'=AValue2 ret
	    	s:Elementdata2=AValue2 ret=-1
	    }
    }
	elseif isnt1="<>"
	{
		q:Elementdata1=AValue1 ret
		if (isnt2="=")
		{
			
	    	q:Elementdata2=AValue2 ret
	    	s:Elementdata2'=AValue2 ret=-1
		}
	    if (isnt2="<>")
	    {
	    	q:Elementdata2'=AValue2 ret
	    	s:Elementdata2=AValue2 ret=-1
		}
    }
	elseif (isnt1="[")
	{
		q:(AValue1'[Elementdata1) ret
		if (isnt2="=")
		{
			
	    	q:(Elementdata2=AValue2) ret
	    	s:(Elementdata2'=AValue2) ret=-1
		}
	    if (isnt2="<>")
	    {
	    	q:(Elementdata2'=AValue2) ret
	    	s:(Elementdata2=AValue2) ret=-1
		}
    }
	elseif (isnt1="![")
	{
		q:(AValue1[Elementdata1) ret
		if (isnt2="=")
		{
			
	    	q:Elementdata2=AValue2 ret
	    	s:Elementdata2'=AValue2 ret=-1
		}
	    if (isnt2="<>")
	    {
	    	q:Elementdata2'=AValue2 ret
	    	s:Elementdata2=AValue2 ret=-1
		}
    }
    
    s ElementCode=""
    s:(ret=-1) ElementCode=##Class(EPRservice.Quality.DataAccess.BOQualityPool).GetElementCode(AElement1_","_AElement2)
	q ret_"@"_ElementCode
}

/// CreatDate:	2020-01-20
/// Creator:	YK
/// Desc:		病案首页.有【病理诊断】,则【病理编码】/【病理号】不允许为空。允许病理编码、病理号是-\—。
/// Input:		AEpisodeID为患者就诊号;
/// 			AElement1为一条手术信息模板单元RowID字符串,多个以"\"分隔; ANoValues 条件元素填写除外的值(如职业填写"无业人员"不判断)
/// Return:		ret<0:不一致; ret=1一致;
/// Debug:		w ##Class(EPRservice.Quality.EmrCheckRule.ConsistencyCheck).IsUnify0013(EpisodeID,"病理诊断code\病理号code\病理诊断编码code")
ClassMethod IsUnify0013(AEpisodeID As %String, AElements As %String, ANoValues As %String = "") As %String
{
	s ret = 0
	q:(AEpisodeID = "")||(AElements = "") ret
	
	s MainElement=$p(AElements,"\",1)
	s ElementData=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,MainElement,"")
	s ElementData=$TR(ElementData,"-\—","")
	s:(ANoValues'="") ElementData=$tr(ElementData,ANoValues,"")
	q:(ElementData="") ret
	
	s num=$l(AElements,"\")
	for Ind = 1:1:num 
	{
		s ElementName = $p(AElements,"\",Ind)
		s ElementDataNew = ##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,ElementName,"")
		s ElementDataNew = $tr(ElementDataNew,"-\—","")
		s:(ElementDataNew="") ret=-1
	}
	
	s ElementCode=""
    s:(ret=-1) ElementCode=##Class(EPRservice.Quality.DataAccess.BOQualityPool).GetElementCode(AElements)
	q ret_"@"_ElementCode
}

/// CreatDate:	2020-01-20
/// Creator:	YK
/// Desc:		病案首页.有【职业】则【工作单位及地址】不允许为空或者-\—。
/// Input:		AEpisodeID为患者就诊号;
/// Return:		ret<0:不一致; ret=1一致;
/// Debug:		w ##Class(EPRservice.Quality.EmrCheckRule.ConsistencyCheck).IsUnify0014(EpisodeID,"职业code\工作单位地址code")
ClassMethod IsUnify0014(AEpisodeID As %String, AElements As %String) As %String
{
	s ret = 0
	q:(AEpisodeID = "")||(AElements = "") ret
	
	s count = 0
	s num=$l(AElements,"\")
	for Ind = 1:1:num 
	{
		s ElementName = $p(AElements,"\",Ind)
		s ElementDataNew = ##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,ElementName,"")
		s ElementDataNew = $tr(ElementDataNew,"-\—","")
		continue:(ElementDataNew="")
		// 不为空的值的个数
		s count=count+1
	}
	s:(count'=num) ret = "-1"
	
	s ElementCode=""
    s:(ret=-1) ElementCode=##Class(EPRservice.Quality.DataAccess.BOQualityPool).GetElementCode(AElements)
	q ret_"@"_ElementCode
}

/// CreatDate:	2020-01-20
/// Creator:	YK
/// Desc:		病案首页.【国籍】为中国时，【民族】不允许为“其他”。
/// 			病案首页.【联系人关系】为"配偶"时，【婚姻】不可填写"未婚"，请检查。
/// Input:		AEpisodeID为患者就诊号;
/// Return:		ret<0:不一致; ret=1一致;
/// Debug:		w ##Class(EPRservice.Quality.EmrCheckRule.ConsistencyCheck).IsUnify0016(EpisodeID,"国籍code","民族code","中国","-\—\其他")
/// 			##class(EPRservice.Quality.EmrCheckRule.ConsistencyCheck).IsUnify0016(EpisodeID,"联系人关系code","婚姻code","配偶","未婚")
ClassMethod IsUnify0016(AEpisodeID As %String, AElement1 As %String, AElement2 As %String, AValues1 As %String, AValues2 As %String) As %String
{
	s ret=0
	q:(AEpisodeID="")||(AElement1="")||(AElement2="")||(AValues1="")||(AValues2="") ret
	
	s ret=1 
	s ElementData1=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,AElement1,"")
	q:($tr(ElementData1,"-\—\ ","") = "") ret
	s ElementData1 = $TR(ElementData1," ","")
 	
	s ElementData2=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,AElement2,"")
	
	s flag1=0,flag2=0 
	for i=1:1:$l(AValues1,"\") 
	{
		s Value1=$p(AValues1,"\",i)
		s:(ElementData1=Value1) flag1=1
    }
    
    for j=1:1:$l(AValues2,"\") 
    {
		s Value2=$p(AValues2,"\",j)
		s:(ElementData2=Value2) flag2=1
    }
	
    s:((flag1=1)&&(flag2=1)) ret=-1
    
	s ElementCode=""
    s:(ret=-1) ElementCode=##Class(EPRservice.Quality.DataAccess.BOQualityPool).GetElementCode(AElement1_"\"_AElement1)
	q ret_"@"_ElementCode
}

/// CreatDate:	2020-01-20
/// Creator:	YK
/// Desc:		病案首页.【身份证】录入内容与公安部身份证验证规则不符(外国国籍可填"-")。
/// Input:		AEpisodeID为患者就诊号;
/// 			AElement1为身份证号; 
/// Return:		ret<0:不一致; ret=1一致;
/// Debug:		w ##class(EPRservice.Quality.EmrCheckRule.ConsistencyCheck).IsUnify0017(EpisodeID,"身份证号code","国籍code\年龄岁code\入院科室code","","18\15")
ClassMethod IsUnify0017(ArgEpisodeID As %String, ArgElement1 As %String, ArgExtElement As %String, ArgExtValues As %String = "", ArgLengthNums As %String = "18") As %String
{
	s ret=0
	q:(ArgEpisodeID="")||(ArgElement1="") ret
	
	// 兼容国籍、年龄小于1岁、新生儿特殊情况可以不填写身份证信息
	if (ArgExtElement'="")
	{
		s ExtElement1=$p(ArgExtElement,"\",1)
		s:(ExtElement1'="") ExtData1=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(ArgEpisodeID,ExtElement1,"")
		q:(ExtElement1'="")&&(ExtData1'="中国") ret
		
		s ExtElement2=$p(ArgExtElement,"\",2)
		s:(ExtElement2'="") ExtData2=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(ArgEpisodeID,ExtElement2,"")
		q:(ExtElement2'="")&&(+ExtData2<1) ret
		
		s ExtElement3=$p(ArgExtElement,"\",3)
		s:(ExtElement3'="") ExtData3=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(ArgEpisodeID,ExtElement3,"")
		q:(ExtElement3'="")&&(ExtData3["新生儿") ret
	}
	
	// 为空直接退出
	s ElementData1=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(ArgEpisodeID,ArgElement1,"")
	q:($tr(ElementData1,"-\—\ ","")="") "-1"
	
	// 验证特殊值
	s ExtValuels=##Class(EPRservice.Quality.CommonHelper).GetListFromString(ArgExtValues,"\")
	s ExtInd=1
	for 
	{
		s ExtValue=$listget(ExtValuels,ExtInd)
		q:ExtValue=""
		s:(ElementData1=ExtValue) ret=1
		s ExtInd=ExtInd+1	
	}
	q:(ret=1) ret
	
	//长度验证
	s flag=0
	s IDCardLength=$l(ElementData1),LengthInd=1
	s LengthNumls = ##Class(EPRservice.Quality.CommonHelper).GetListFromString(ArgLengthNums,"\")
	for
	{
		s LengthNum=$listget(LengthNumls,LengthInd)
		q:LengthNum=""
		
		s:(IDCardLength = LengthNum) flag=1
		s LengthInd=LengthInd+1
	}
	s:(flag=0) ret=-1
	q:(ret=-1) ret
	
	s ret=1
	
	/// 9位，第一位为字母为H/M/R其余8位数字
	if (IDCardLength=9)
	{
		s FirstCardCode="H/M/R"
		s:(FirstCardCode'[$E(ElementData1,1,1)) ret=-1
		q:(ret=-1) ret
		
		for i=2:1:8 
		{
			s IDCardnum=$E(ElementData1,i)
			s numACode=$a(IDCardnum)
			s:(numACode<48)||(numACode>57) ret=-1
			q:(ret=-1)
		}
	}
	
	/// 10位，第一位为字母最后一位为括号; 或第一位为字母其余9位数字; 或第一位是数字，最后一位是括号
	if (IDCardLength=10)
	{
		s TypeFlag=0
		s FirstCardCode = $E(ElementData1,1,1)
		s TypeFlag = $match(FirstCardCode,"[A-Z]")  ///大写字母
		s:(TypeFlag=0)&&(($a(FirstCardCode)>=48)&&($a(FirstCardCode)<=57)) TypeFlag=2  //数字
		s:(TypeFlag=0) ret=-1  ///首字母不能小写
		q:(ret=-1)
		
		s flag=1
		if (TypeFlag=1)  ///字母
		{
			s:($E(ElementData1,8,8)'="(")||($E(ElementData1,10,10)'=")")||(($a($E(ElementData1,9))<48)||($a($E(ElementData1,9))>57)) flag=0  ///第一位为字母最后一位为括号，如(8)
			q:(flag=1) ret

                                                s flag=1
			for i=2:1:9   ///第一位为字母其余9位数字
			{
				s IDCardnum=$E(ElementData1,i)
				s numACode=$a(IDCardnum)
				s:(numACode<48)||(numACode>57) flag=0  
			}
			s:(flag=0) ret=-1
		}
		elseif (TypeFlag=2) ///数字
		{
			s:($E(ElementData1,8,8)'="(")||($E(ElementData1,10,10)'=")")||(($a($E(ElementData1,9))<48)||($a($E(ElementData1,9))>57)) flag=0  ///第一位是数字，最后一位是括号，如(8)
			s:(flag=0) ret=-1
		}
	}
	
	s ret=1
	//验证 15为 身份证是否合理
	//仅验证身份证是否为15位纯数字
	if (IDCardLength=15)
	{
		for i=1:1:15 
		{
			s IDCardnum=$E(ElementData1,i)
			
			s numACode=$a(IDCardnum)
			s:(numACode<48)||(numACode>57) ret=-1
		}
	}
	
	//验证 18位 身份证是否合理
	//校验规则是：
	//（1）十七位数字本体码加权求和公式 
	//S = Sum(Ai * Wi), i = 0, ... , 16 ，先对前17位数字的权求和 
	//Ai:表示第i位置上的身份证号码数字值 
	//Wi:表示第i位置上的加权因子 
	//Wi: 7 9 10 5 8 4 2 1 6 3 7 9 10 5 8 4 2 
	//（2）计算模 
	//Y = mod(S, 11) 
	//（3）通过模得到对应的校验码 
	//Y: 0 1 2 3 4 5 6 7 8 9 10 
	//校验码: 1 0 X 9 8 7 6 5 4 3 2
	if (IDCardLength=18)
	{
		//初始化验证
		s WList=$lb("7","9","10","5","8","4","2","1","6","3","7","9","10","5","8","4","2")
		s YList=$lb("1","0","X","9","8","7","6","5","4","3","2")
		s Sum=0
		s i=1
		//求权和
		f i=1:1:17 {
			s IDCardnum=$e(ElementData1,i)
			s Wnum=$listget(WList,i)
			s Sum=IDCardnum*Wnum+Sum
		}
		//取验证码
		s CardNum18=$listget(YList,Sum#11+1)
		//验证
		i CardNum18'=$e(ElementData1,18) s ret=-1
	}
	
	s ElementCode=""
    s:(ret=-1) ElementCode=##Class(EPRservice.Quality.DataAccess.BOQualityPool).GetElementCode(ArgElement1)
	q ret_"@"_ElementCode
}

/// CreatDate:	2020-01-20
/// Creator:	YK
/// Desc:		病案首页.【出生日期】与【身份证】信息不符。
/// Input:		AEpisodeID为患者就诊号;ArgElement1:身份证单元，ArgElement2：出生日期单元，ArgExtValues:身份证特殊值
/// Return:		ret<0:不一致; ret=1一致;
/// Debug:		w ##class(EPRservice.Quality.EmrCheckRule.ConsistencyCheck).IsUnify0018(EpisodeID,"身份证号code","出生日期code","")
ClassMethod IsUnify0018(ArgEpisodeID As %String, ArgElement1 As %String, ArgElement2 As %String, ArgExtValues As %String = "") As %String
{
	s ret=0
	q:(ArgEpisodeID="")||(ArgElement1="")||(ArgElement2="") ret
	
	s ElementData1=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(ArgEpisodeID,ArgElement1,"")
	s ElementData2=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(ArgEpisodeID,ArgElement2,"")
	q:($tr(ElementData2,"-\—\ ","")="") ret
	s ElementData2=$tr(ElementData2,"年","-")
	s ElementData2=$tr(ElementData2,"月","-")
	s ElementData2=$tr(ElementData2,"日","")
	
	//身份证验证特殊值
	s ExtValuels=##Class(EPRservice.Quality.CommonHelper).GetListFromString(ArgExtValues,"\")
	s ExtInd=1
	for 
	{	
		s ExtValue=$listget(ExtValuels,ExtInd)
		q:ExtValue=""
		s:(ElementData1=ExtValue) ret=1
		s ExtInd=ExtInd+1	
	}
	q:(ret=1) ret
	
	s ret=1
	s IDCardLength=$l(ElementData1)
	s:(IDCardLength=15) birthday=$e(ElementData1,7,12)
	s:(IDCardLength=15) csrq=$e($p(ElementData2,"-",1),3,4)_$p(ElementData2,"-",2)_$p(ElementData2,"-",3)
	
	s:(IDCardLength=18) birthday=$e(ElementData1,7,14)
	s:(IDCardLength=18) csrq=$p(ElementData2,"-",1)_$p(ElementData2,"-",2)_$p(ElementData2,"-",3)
	
	s:(birthday'=csrq) ret=-1
	
	s ElementCode=""
    s:(ret=-1) ElementCode=##Class(EPRservice.Quality.DataAccess.BOQualityPool).GetElementCode(ArgElement1_"\"_ArgElement2)
	q ret_"@"_ElementCode
}

/// CreatDate:	2020-01-20
/// Creator:	YK
/// Desc:		病案首页.【损伤、中毒的外部原因编码】中只能出现"VWXY"区段的编码。
/// 			病案首页.【主要诊断】不允许为Z37—Z38分娩的结局。
/// Input:		AEpisodeID为患者就诊号;ArgElement1:入院日期 ,ArgElement2：出生日期，ArgElement3：新生儿出生体重,ArgElement4:新生儿入院体重
/// Return:		ret<0:不一致; ret=1一致;
/// Debug:		w ##class(EPRservice.Quality.EmrCheckRule.ConsistencyCheck).IsUnify0019(EpisodeID,"损伤、中毒的外部原因编码code","V\W\X\Y","=","")
/// 			w ##class(EPRservice.Quality.EmrCheckRule.ConsistencyCheck).IsUnify0019(EpisodeID,"主要诊断编码code","Z37\Z38","<>")
ClassMethod IsUnify0019(ArgEpisodeID As %String, ArgElement As %String, AValues As %String, Aisnt As %String, ArgExtValues As %String = "") As %String
{
	s ret=0
	q:(ArgEpisodeID="")||(ArgElement="")||(Aisnt="") ret
	
	s ExtValuels=##Class(EPRservice.Quality.CommonHelper).GetListFromString(ArgExtValues,"\")
	for I=1:1:$l(ArgElement,"\")
	{
		s Element=$p(ArgElement,"\",I)
		s ElementData=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(ArgEpisodeID,Element,"")
		s ElementData=$tr(ElementData,"-\—\ ","")
		continue:(ElementData="")
		
		s ret=0,ExtInd=1
		for 
		{
			s ExtValue=$listget(ExtValuels,ExtInd)
			q:ExtValue=""
			s:($e(ElementData,1,$l(ExtValue))=ExtValue) ret=1
			q:(ret=1)
			s ExtInd=ExtInd+1
		}
		continue:(ret=1)
		
		s ret=1
		if (Aisnt="<>")
		{
			s flag=0
			for j=1:1:$l(AValues,"\") 
			{
				s Value=$p(AValues,"\",j)
				s:($e(ElementData,1,$l(Value))=Value) flag=1
				q:(flag=1)
			}
		}
		elseif (Aisnt="=")
		{
			s flag=1
			for j=1:1:$l(AValues,"\") 
			{
				s Value=$p(AValues,"\",j)
				s:($e(ElementData,1,$l(Value))=Value) flag=0
				q:(flag=0)
			}
		}
		s:(flag=1) ret=-1
		q:(ret=-1)
	}
	
	s ElementCode=""
    s:(ret=-1) ElementCode=##Class(EPRservice.Quality.DataAccess.BOQualityPool).GetElementCode(ArgElement)
	q ret_"@"_ElementCode
}

/// CreatDate:	2020-06-22
/// Creator:	GY
/// Desc:		(入院日期-出生日期)与换算年龄不符(误差≤1岁)(不足一周岁，年龄填写"0")
/// Input:		AEpisodeID为患者就诊号;ArgElement1:入院日期，ArgElement2：出生日期，ArgElement3：年龄,AQuaPatType 质控患者类型(A 成人，B 婴幼儿)
/// Return:		ret<0:不一致; ret=1一致;
/// d ##class(EPRservice.Quality.EmrCheckRule.ConsistencyCheck).IsUnify0020()
ClassMethod IsUnify0020(ArgEpisodeID As %String, ArgElement1 As %String, ArgElement2 As %String, ArgElement3 As %String, AQuaPatType As %String) As %String
{
	s ret=0
   
	q:(ArgEpisodeID="")||(ArgElement1="")||(ArgElement2="")||(ArgElement3="") ret
	
	//入院日期
	s ElementData1=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(ArgEpisodeID,ArgElement1,"")
	q:($tr(ElementData1,"-\—\ ","")="") ret
	s ElementData1=$p(ElementData1," ",1)
	s ElementData1=$tr(ElementData1,"年","-")
	s ElementData1=$tr(ElementData1,"月","-")
	s ElementData1=$tr(ElementData1,"日","")
	
	//出生日期
	s ElementData2=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(ArgEpisodeID,ArgElement2,"")
	q:($tr(ElementData2,"-\—\ ","")="") ret
	s ElementData2=$tr(ElementData2,"年","-")
	s ElementData2=$tr(ElementData2,"月","-")
	s ElementData2=$tr(ElementData2,"日","")
	
	//年龄
	s Age=""
	s ElementData3=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(ArgEpisodeID,ArgElement3,"")
	s:(ElementData3["岁") Age=$p(ElementData3,"岁",1)
	
	s ret=1
	s ryrq=##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(ElementData1)
	s csrq=##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(ElementData2)
	s tmpdate=ryrq-csrq
	s tmpage=$fn((tmpdate/365 ),"",0)   ///换算年龄(岁)
	
	//成人年龄(入院日期-出生日期)与换算年龄误差≤1岁
	s:(AQuaPatType="A")&&(tmpdate>=365)&&(tmpage'=Age)&&(Age'=(tmpage+1))&&(Age'=(tmpage-1)) ret=-1
	
	//婴儿年龄(入院日期-出生日期)<365天时，年龄（岁）只能为0
	s:(AQuaPatType="B")&&(tmpdate<365)&&(Age'=0) ret=-1
	
	s ElementCode=""
    s:(ret=-1) ElementCode=##Class(EPRservice.Quality.DataAccess.BOQualityPool).GetElementCode(ArgElement1_"\"_ArgElement2_"\"_ArgElement3)
	q ret_"@"_ElementCode
}

/// CreatDate:	2020-01-20
/// Creator:	YK
/// Desc:		病案首页.患者【年龄】不足28天必须填写【新生儿入院体重】和【新生儿出生体重】，请检查。
/// Input:		AEpisodeID为患者就诊号;ArgElement1:入院日期 ,ArgElement2：出生日期，ArgElement3：新生儿出生体重,ArgElement4:新生儿入院体重
/// Return:		ret<0:不一致; ret=1一致;
/// Debug:		w ##class(EPRservice.Quality.EmrCheckRule.ConsistencyCheck).IsUnify0021(EpisodeID,"入院日期code","出生日期code","新生儿入院体重code","新生儿出生体重code")
ClassMethod IsUnify0021(ArgEpisodeID As %String, ArgElement1 As %String, ArgElement2 As %String, ArgElement3 As %String, ArgElement4 As %String = "")
{
	s ret=0,flag1=0,flag2=0
	
	//(入院日期-出生日期)计算年龄
	s ElementData1=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(ArgEpisodeID,ArgElement1,"")
	s ElementData1=$p(ElementData1," ",1)
	s ElementData1=$tr(ElementData1,"年","-")
	s ElementData1=$tr(ElementData1,"月","-")
	s ElementData1=$tr(ElementData1,"日","")
	
	s ElementData2=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(ArgEpisodeID,ArgElement2,"")
	s ElementData2=$tr(ElementData2,"年","-")
	s ElementData2=$tr(ElementData2,"月","-")
	s ElementData2=$tr(ElementData2,"日","")
	
	s Date1=##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(ElementData1)
	s Date2=##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(ElementData2)
	s AgeDays=Date1-Date2
	q:(AgeDays>28) ret
	
	s ret=1
	if (ArgElement3'="")
	{
		//新生儿入院体重
		s ElementData3=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(ArgEpisodeID,ArgElement3,"")
		s ElementData3=$tr(ElementData3,"-\—","")
		s:(ElementData3="") ret=-1
	}
	if (ArgElement4'="")
	{
		//新生儿出院体重
		s ElementData4=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(ArgEpisodeID,ArgElement4,"")
		s ElementData4=$tr(ElementData4,"-\—","")
		s:(ElementData4="") ret=-1
	}
	
	s ElementCode=""
    s:(ret=-1) ElementCode=##Class(EPRservice.Quality.DataAccess.BOQualityPool).GetElementCode(ArgElement1_"\"_ArgElement2_"\"_ArgElement3_"\"_ArgElement4)
	q ret_"@"_ElementCode
}

/// CreatDate:	2020-01-20
/// Creator:	YK
/// Desc:		病案首页.【年龄】不足14周岁，【联系人关系】不允许为"夫妻\子女\孙子女"。
/// 				病案首页.【年龄】不足14周岁【婚姻】不允许为"已婚\离婚\丧偶"。
/// 				病案首页.【年龄】不足14岁，【职业】不允许为"国家公务员\现役军人\退(离)休人员"。
/// Input:		AEpisodeID为患者就诊号;
/// Return:		ret<0:不一致; ret=1一致;
/// Debug:		##class(EPRservice.Quality.EmrCheckRule.ConsistencyCheck).IsUnify0023(EpisodeID,"年龄code","联系人关系code",14,"配偶\夫\妻\子\女\孙\外孙")
ClassMethod IsUnify0023(AEpisodeID As %String, AElement1 As %String, AElement2 As %String, AValues1 As %String, ANoValues2 As %String) As %String
{
	s ret=0
	s flag1=0,flag2=0
	q:(AEpisodeID="")||(AElement1="")||(AElement2="")||(AValues1="") ret
	
	s ret=1 
	s ElementData1=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,AElement1,"")
	if (ElementData1["岁")
	{
		s age=+ElementData1
		
		s:(age>AValues1) flag1=1
	}
	else
	{
		s flag1 = 1
	}
	
	q:(flag1=1) ret  ///年龄大于14岁
	
	s ElementData2=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,AElement2,"")
	q:($tr(ElementData2,"-\—\ ","")="") ret
	
	for j=1:1:$l(ANoValues2,"\") 
	{
		s Value2=$p(ANoValues2,"\",j)
		s:(ElementData2[Value2) flag2=1
		q:(flag2=1)
    }
    s:(flag2=1) ret=-1
	
	s ElementCode=""
    s:(ret=-1) ElementCode=##Class(EPRservice.Quality.DataAccess.BOQualityPool).GetElementCode(AElement1_"\"_AElement2)
	q ret_"@"_ElementCode
}

/// CreatDate:	2020-01-20
/// Creator:	YK
/// Desc:		病案首页.【邮编】、【电话】必须是指定长度，请检查。
/// Input:		AEpisodeID为患者就诊号;
/// Return:		ret<0:不一致; ret=1一致;
/// Debug:		w ##class(EPRservice.Quality.EmrCheckRule.ConsistencyCheck).IsUnify0024(EpisodeID,"现住址邮编code","6")
/// Debug:		w ##class(EPRservice.Quality.EmrCheckRule.ConsistencyCheck).IsUnify0024(EpisodeID,"现住址电话code","11\7")
ClassMethod IsUnify0024(AEpisodeID As %String, AElement As %String, AValues As %String)
{
	s ret=0
	q:(AEpisodeID="")||(AElement="") ret
	
	s ret=1 
	s ElementData=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,AElement,"")
	s ElementData=$tr(ElementData,"-\—","")
	q:(ElementData = "") ret
	
	s:($num(ElementData,"I")="") ret=-1  ///非纯整数数值
	q:(ret=-1) ret
	
	s length=$l(ElementData)
	s flag=0
	for i=1:1:$l(AValues,"\")
	{
		s Value=$p(AValues,"\",i)
	    s:(length=Value) flag=1
    }
    s:(flag=0) ret=-1
    
    s ElementCode=""
    s:(ret=-1) ElementCode=##Class(EPRservice.Quality.DataAccess.BOQualityPool).GetElementCode(AElement)
	q ret_"@"_ElementCode
}

/// CreatDate:	2020-01-20
/// Creator:	YK
/// Desc:		病案首页.【年龄】(入院日期-出生日期)大于28天，【主要诊断】和【次要诊断】编码中不允许为"P00-P96"的诊断编码。
/// Input:		AEpisodeID为患者就诊号;AElement1：入院日期,AElement2:出生日期，AElement3：诊断,ANoValues：指定的不能出现的诊断编码，AExtValues：诊断例外
/// Return:		ret<0:不一致; ret=1一致;
/// Debug:		w ##class(EPRservice.Quality.EmrCheckRule.ConsistencyCheck).IsUnify0028(EpisodeID,"入院日期code","出生日期code",{HISDiagCodes},"P","P97\P98\P99")
ClassMethod IsUnify0028(AEpisodeID As %String, AElement1 As %String, AElement2 As %String, AElement3 As %String, ANoValues As %String, AExtValues As %String)
{
	s ret=0
	q:(AEpisodeID="")||(AElement1="")||(AElement3="")||(ANoValues="") ret
    
	//入院日期
	s ElementData1=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,AElement1,"")
	s ElementData1=$p(ElementData1," ",1)
	s ElementData1=$tr(ElementData1,"年","-")
	s ElementData1=$tr(ElementData1,"月","-")
	s ElementData1=$tr(ElementData1,"日","")
	
	//出生日期
	s ElementData2=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,AElement2,"")
	s ElementData2=$tr(ElementData2,"年","-")
	s ElementData2=$tr(ElementData2,"月","-")
	s ElementData2=$tr(ElementData2,"日","")
	
	q:(ElementData1="")||(ElementData2="") ret
	
	//年龄
	s Age=$p($zdh(ElementData1,3)," ",1)-$p($zdh(ElementData2,3)," ",1)
	q:(Age<=28) ret
	
	s ret=1,ElementList=""
	for I=1:1:$l(AElement3,"\")
	{
	    s Element3=$p(AElement3,"\",I)
		s ElementData3=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,Element3,"")
		s ElementData3=$tr(ElementData3,"-\—","")
		s:(ElementData3'="")&&(ANoValues[$e(ElementData3,1,1)) ret=-1
		continue:(ret=1)
		
		s ExtValuels=##Class(EPRservice.Quality.CommonHelper).GetListFromString(AExtValues,"\")
	    s ExtInd=1
	    for 
	    {	
		    s ExtValue=$listget(ExtValuels,ExtInd)
		    q:ExtValue=""
		    s:($e(ElementData3,1,$l(ExtValue))=ExtValue) ret=1
		    s ExtInd=ExtInd+1	
		    q:(ret=1)
		}
		s:(ret=-1) ElementList=AElement1_"\"_AElement2_"\"_Element3
		q:(ret=-1)
	}
	
	s ElementCode=""
    s:(ret=-1) ElementCode=##Class(EPRservice.Quality.DataAccess.BOQualityPool).GetElementCode(ElementList)
	q ret_"@"_ElementCode
}

/// CreatDate:	2020-01-20
/// Creator:	YK
/// Desc:		病案首页.【性别】为男，【手术和操作编码】中不应出现以65-75开头的编码。
/// 			病案首页.【性别】为女，【手术和操作编码】中不应出现以60-64开头的编码。
/// Input:		AEpisodeID为患者就诊号;
/// Return:		ret<0:不一致; ret=1一致;
/// Debug:		w ##class(EPRservice.Quality.EmrCheckRule.ConsistencyCheck).IsUnify0029(EpisodeID,"性别code","男",{HISOperCodes},"65\66\67\68\69\70\71\72\73\74\75")
/// 			w ##class(EPRservice.Quality.EmrCheckRule.ConsistencyCheck).IsUnify0029(EpisodeID,"性别code","女",{HISOperCodes},"60\61\62\63\64")
ClassMethod IsUnify0029(AEpisodeID As %String, AElement1 As %String, AGender As %String, AElements2 As %String, ANoValues As %String)
{
	s ret=0
	q:(AEpisodeID="")||(AElement1="")||(AGender="")||(AElements2="") ret
    
	//性别
	s ElementData1=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,AElement1,"")
	s ElementData1=$tr(ElementData1,"-\—","")
	q:(ElementData1="")||(ElementData1'=AGender) ret
	
	///取首页手术编码
	s ElementList="",ret=1
	for I=1:1:$l(AElements2,"\")
	{
		s Element2=$p(AElements2,"\",I)
		s ElementData2=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,Element2,"")
		s ElementData2=$tr(ElementData2,"-\—","")
		s:(ElementData2'="")&&(ANoValues[$e(ElementData2,0,2)) ret="-1"
		s:(ret=-1) ElementList=AElement1_"\"_Element2
		q:(ret=-1)
	}
	
	s ElementCode=""
    s:(ret=-1) ElementCode=##Class(EPRservice.Quality.DataAccess.BOQualityPool).GetElementCode(ElementList)
	q ret_"@"_ElementCode
}

/// CreatDate:	2020-01-20
/// Creator:	YK
/// 病案首页.出院诊断编码包含有S00—S99、T00—T98的患者，“损伤、中毒的外部原因”必填
/// 病案首页.【主要诊断编码】是C开头的诊断，【临床分期】不允许为空。
/// Input:AElement1:诊断编码单元，AElement2：损伤、中毒的外部原因单元，AValues；编码中指定包含的值，ArgExtValues：诊断例外,AReverseVerify:反向验证 Y，不需要反向验证 N
/// d ##class(EPRservice.Quality.EmrCheckRule.IntegrityCheck).IsUnify0030(EpisodeID,10332,"10111","C","")
ClassMethod IsUnify0030(ArgEpisodeID As %String, AElement1 As %String, AElement2 As %String, AValues As %String, ArgExtValues As %String, AFillSign As %String = "All", AReverseVerify As %String = "N")
{
	s ret=0
   
	q:(ArgEpisodeID="")||(AElement1="")||(AElement2="")||(AValues="") ret
	
	s flag=0
	for i=1:1:$l(AElement1,"\")
	{
		s Element1=$p(AElement1,"\",i)
		s ElementData1=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(ArgEpisodeID,Element1,"")
		continue:(ElementData1="")||(ElementData1="—")
		
		s Values=##Class(EPRservice.Quality.CommonHelper).GetListFromString(AValues,"\")
		s Ind=1
		for 
		{
			s Value=$listget(Values,Ind)
			q:Value=""
			s:($e(ElementData1,1,$l(Value))=Value) flag=1
			s Ind=Ind+1	
		}
		continue:(flag=0)
		
		s ExtValuels=##Class(EPRservice.Quality.CommonHelper).GetListFromString(ArgExtValues,"\")
		s ExtInd=1
		for 
		{
			s ExtValue=$listget(ExtValuels,ExtInd)
			q:ExtValue=""
			
			s:($e(ElementData1,1,$l(ExtValue))=ExtValue) flag=0
			s ExtInd=ExtInd+1
		}
			q:(flag=1)
	}
	q:(flag=0)&&(AReverseVerify'="Y") ret
	
	if (AFillSign="All")
	{
		s flag2=1
		for I=1:1:$l(AElement2,"\")
		{
			s Element2=$p(AElement2,"\",I)
			s ElementData2=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(ArgEpisodeID,Element2,"")
			s:(ElementData2="")||(ElementData2="—") flag2=-1
			q:(flag2=-1)
		}
	}
	elseif (AFillSign="Part")
	{
		s flag2=-1
		for I=1:1:$l(AElement2,"\")
		{
			s Element2=$p(AElement2,"\",I)
			s ElementData2=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(ArgEpisodeID,Element2,"")
			s:($tr(ElementData2,"-\—","")'="") flag2=1
			q:(flag2=1)
		}
	}
	s:((AReverseVerify="Y")&&(flag2="1")&&(flag=0)) ret="-1"
	s:((AReverseVerify="Y")&&(flag2="-1")&&(flag=1)) ret="-1"
	s:((flag2="-1")&&(AReverseVerify'="Y")) ret="-1"
	s ElementCode=""
	s:(ret=-1) ElementCode=##Class(EPRservice.Quality.DataAccess.BOQualityPool).GetElementCode(AElement1_"\"_AElement2)
	q ret_"@"_ElementCode
}

/// 说明: 病案首页.新生儿出生体重应精确到10g
///  AElements为多个用"^"分割
/// 结论: ret<0 
/// 调试: w ##Class(EPRservice.Quality.EmrCheckRule.IntegrityCheck).IsUnify0032(EpisodeID,"10320")
/// AElement1 以"^"分割
ClassMethod IsUnify0032(AEpisodeID As %String, AElement As %String) As %String
{
	s ret=0
	q:(AEpisodeID="")||(AElement="") ret
	
	s ret=1
	s ElementData=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,AElement,"")
	q:(ElementData="")||(ElementData="—") ret
	
	s:((ElementData/10)[".") ret=-1

	q ret
}

/// CreatDate:	2020-01-20
/// Creator:	YK
/// Desc:		病案首页.出院【主要诊断编码】包含有C00—C97、D00—D48并且做了手术的患者，【病理诊断】不允许为空
/// Input:		AEpisodeID为患者就诊号;AElement1:主要诊断编码单元，AElement2：病理诊断单元，AElement3:入院次数单元编码，AValues；编码中指定包含的值，ArgExtValues：诊断例外
/// Return:		ret<0:不一致; ret=1一致;
/// Debug:		w ##class(EPRservice.Quality.EmrCheckRule.ConsistencyCheck).IsUnify0033(EpisodeID,"手术名称1code","主要诊断编码code","病理诊断编码code","C\D0\D1\D2\D3\D4","D49")
ClassMethod IsUnify0033(AEpisodeID As %String, AHISOperName As %String, AElement1 As %String, AElement2 As %String, AValues As %String, ArgExtValues As %String) As %String
{
	s ret=0
	q:(AEpisodeID="")||(AHISOperName="")||(AElement1="")||(AElement2="") ret
	
	s ret=1
	s OperName=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,AHISOperName,"")
	s OperName=$tr(OperName,"-\—","")
	q:(OperName="") ret
	
	s ElementData1=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,AElement1,"")
	s ElementData1=$tr(ElementData1,"-\—","")
	q:(ElementData1="") ret
	
	s Values=##Class(EPRservice.Quality.CommonHelper).GetListFromString(AValues,"\")
	s flag=0
	s Ind=1
	for 
	{	
		s Value=$listget(Values,Ind)
		q:Value=""
		s:($e(ElementData1,1,$l(Value))=Value) flag=1
		s Ind=Ind+1	
		continue:(flag=0)
		s ExtValuels=##Class(EPRservice.Quality.CommonHelper).GetListFromString(ArgExtValues,"\")
		s ExtInd=1
		for 
		{
			s ExtValue=$listget(ExtValuels,ExtInd)
			q:ExtValue=""
			
			s:($e(ElementData1,1,$l(ExtValue))=ExtValue) flag=0
			q:(flag=0)
			s ExtInd=ExtInd+1
		}
		q:(flag=1)
	}
	q:(flag=0) ret
	
	s ElementData2=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,AElement2,"")
	s ElementData2=$tr(ElementData2,"-\—","")
	s:(ElementData2="") ret=-1

	s ElementCode=""
    s:(ret=-1) ElementCode=##Class(EPRservice.Quality.DataAccess.BOQualityPool).GetElementCode(AElement1_"\"_AElement2)
	q ret_"@"_ElementCode
}

/// CreatDate:	2020-01-20
/// Creator:	YK
/// Desc:		病案首页.【出院诊断编码】包含"Z37.001\Z37.002\Z37.201\Z37.202\Z37.203\Z37.301\Z37.501\Z37.502\Z37.601\Z37.901\Z37.902\Z37.903\Z37.904",则【新生儿出生体重】不允许为空。
/// Input:		AEpisodeID为患者就诊号;AElement1：入院科室code,AElement2：出院诊断编码,AElement3：新生儿出生体重code
/// Return:		ret<0:不一致; ret=1一致;
/// Debug:		w ##class(EPRservice.Quality.EmrCheckRule.ConsistencyCheck).IsUnify0034(EpisodeID,"入院科室code",{HISDiagCodes},"新生儿出生体重code","Z37","")
ClassMethod IsUnify0034(AEpisodeID As %String, AElement1 As %String, AElement2 As %String, AElement3 As %String, AValues As %String, AExtValues As %String = "") As %String
{
	s ret=0
	q:(AEpisodeID="")||(AElement1="")||(AElement2="")||(AElement3="")||(AValues="") ret
	
	s ret=1
	s ElementData1=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,AElement1,"")
	s ElementData1=$tr(ElementData1,"-\—","")
	//q:(ElementData1="")||(ElementData1'="产科") ret
	
	s:(AValues="Z37") AValues="Z37.00\Z37.001\Z37.002\Z37.201\Z37.202\Z37.203\Z37.301\Z37.501\Z37.502\Z37.601\Z37.901\Z37.902\Z37.903\Z37.904"
	
	s ElementList=""
	///取首页诊断编码
	for I=1:1:$l(AElement2,"\")
	{
		s Element=$p(AElement2,"\",I)
		s ElementData=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,Element,"") 
		
		s ElementData=$tr(ElementData,"-\—","")
		continue:(ElementData="")
		for j=1:1:$L(AValues,"\")
		{
			s AValue =$P(AValues,"\",j)
			s:(ElementData[AValue) ret=-1
			
			s:(ret=-1) ElementList=Element
			q:(ret=-1)
		}
		q:(ret=-1)
	}
    q:(ret=1) ret
	
	///新生儿体重
	s ElementData3=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,AElement3,"")
	s ElementData3=$tr(ElementData3,"-\—","")
	
	s:(ElementData3'="") ret=1
	
	s ElementCode=""
    s:(ret=-1) ElementCode=##Class(EPRservice.Quality.DataAccess.BOQualityPool).GetElementCode(AElement3_"\"_ElementList)
	q ret_"@"_ElementCode
}

/// CreatDate:	2020-01-20
/// Creator:	YK
/// Desc:		病案首页.【（不足一周岁）年龄】(入院日期-出生日期)小于28天新生儿，疾病请用新生儿诊断（新生儿诊断编码应为P开头）。
/// Input:		AEpisodeID为患者就诊号;
/// Return:		ret<0:不一致; ret=1一致;
/// Debug:		w ##class(EPRservice.Quality.EmrCheckRule.ConsistencyCheck).IsUnify0035(EpisodeID,"入院日期code","出生日期code",{HISDiagCodes},"P","")
ClassMethod IsUnify0035(AEpisodeID As %String, AElement1 As %String, AElement2 As %String, AElement3 As %String, AValues As %String, AExtValues As %String)
{
	s ret=0
	q:(AEpisodeID="")||(AElement1="")||(AElement3="")||(AValues="") ret
    
	//入院日期
	s ElementData1=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,AElement1,"")
	q:($tr(ElementData1,"-\—","")="") ret
	
	s ElementData1=$p(ElementData1," ",1)
	s ElementData1=$tr(ElementData1,"年","-")
	s ElementData1=$tr(ElementData1,"月","-")
	s ElementData1=$tr(ElementData1,"日","")
	
	//出生日期
	s ElementData2=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,AElement2,"")
	q:($tr(ElementData2,"-\—","")="") ret
	
	s ElementData2=$tr(ElementData2,"年","-")
	s ElementData2=$tr(ElementData2,"月","-")
	s ElementData2=$tr(ElementData2,"日","")
	
	//年龄
	s Age=$p($zdh(ElementData1,3)," ",1)-$p($zdh(ElementData2,3)," ",1)
	q:(Age>28) ret

	s ret=1,ElementList=""
	for I=1:1:$l(AElement3,"\")
	{
	    s Element3=$p(AElement3,"\",I)
		s ElementData3=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,Element3,"")
		continue:($tr(ElementData3,"-\—","")="")
		s:(AValues'[$e(ElementData3,1,1)) ret=-1
		
		s ExtValuels=##Class(EPRservice.Quality.CommonHelper).GetListFromString(AExtValues,"\")
	    s ExtInd=1
	    for 
	    {	
		    s ExtValue=$listget(ExtValuels,ExtInd)
		    q:ExtValue=""
		    s:(ExtValue=$e(ElementData3,1,$l(ExtValue))) ret=-1
		    s ExtInd=ExtInd+1	
		    q:(ret=-1)
		}
		s:(ret=-1) ElementList=AElement1_"\"_AElement2_"\"_Element3
		q:(ret=-1)
	}
	
	s ElementCode=""
    s:(ret=-1) ElementCode=##Class(EPRservice.Quality.DataAccess.BOQualityPool).GetElementCode(ElementList)
	q ret_"@"_ElementCode
}

/// CreatDate:	2020-01-20
/// Creator:	YK
/// Desc:		病案首页.【主要诊断】及所有【其他诊断】不允许重复。
/// Input:		AEpisodeID为患者就诊号;AElements:诊断单元（可将出院诊断单元全部维护进去，用"\"分隔）
/// Return:		ret<0:不一致; ret=1一致;
/// Debug:		w ##class(EPRservice.Quality.EmrCheckRule.ConsistencyCheck).IsUnify0036(EpisodeID,{HISDiagCodes})
ClassMethod IsUnify0036(ArgEpisodeID As %String, AElements As %String)
{
	s ret=0
   	
	q:(ArgEpisodeID="")||(AElements="") ret
	s diagEleList=$lfs(AElements,"\")
	
	SET ptr=0,count=0,diagValueList=""
	s ret=1
	WHILE $LISTNEXT(diagEleList,ptr,eleCode) 
	{
		s count=count+1
		//逐项取值,不一向依据代码取值
		s diagNoseValue=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(ArgEpisodeID,eleCode,"") 
		continue:(diagNoseValue="")||(diagNoseValue="-")
		if ('$listfind(diagValueList,diagNoseValue))
		{
			s diagValueList=diagValueList_$lb(diagNoseValue)
		}
		elseif($listfind(diagValueList,diagNoseValue)&&(diagNoseValue'=""))
		{
			s ElementList=eleCode
			s ret=-1
			q
		}
	}
	s ElementCode=""
    s:(ret=-1) ElementCode=##Class(EPRservice.Quality.DataAccess.BOQualityPool).GetElementCode(ElementList)
	q ret_"@"_ElementCode
}

/// CreatDate:	2020-01-20
/// Creator:	YK
/// Desc:		病案首页.首页费用没有同步，则不允许打印首页。
/// Input:		AEpisodeID为患者就诊号;
/// Return:		ret<0:不一致; ret=1一致;
/// Debug:		w ##class(EPRservice.Quality.EmrCheckRule.ConsistencyCheck).IsUnify0038(EpisodeID,"总费用code","自付费用code")
ClassMethod IsUnify0038(ArgEpisodeID As %String, AElementID1 As %String, AElementID2 As %String) As %String
{
	s ret = 0 , FeeData=""
	q:(ArgEpisodeID = "")||(AElementID1="")||(AElementID2="") ret
	
    s ElementData1=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(ArgEpisodeID,AElementID1,"")
	s ElementData1=$tr(ElementData1," ","")
	s ElementData2=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(ArgEpisodeID,AElementID2,"")
	s ElementData2=$tr(ElementData2," ","")
	
	// 患者费用(病案费用子类)
	s InPatFee="",CheckTotal=""
	s InPatFee=##class(EMRservice.HISInterface.PatientInfoAssist).InPatCostTrakCareSubNew(ArgEpisodeID,"DtHealth")
	//取总费用
	s CheckTotal=$p($p(InPatFee,"!",1),"^",3)
	s:(+ElementData1'=+CheckTotal) ret = "-1"
	
	//取自付费用
	//s zffy=##class(web.DHCBillInterface).IGetIPCashPaySumByAdm(ArgEpisodeID)
	//s:(+ElementData2'=+zffy) ret=-1
	
	s ElementCode=""
    s:(ret=-1) ElementCode=##Class(EPRservice.Quality.DataAccess.BOQualityPool).GetElementCode(AElementID1_"\"_AElementID2)
	q ret_"@"_ElementCode
}

/// CreatDate:	2020-01-20
/// Creator:	YK
/// Desc:		病案首页.请同时填写【联系人姓名】、【关系】、【住址】和【电话】，否则请右键写短横线。
/// Input:		AEpisodeID为患者就诊号;AElementID：手术编码; AOPType 手术类别要求(N 手术、I 介入治疗); AElementIDs：手术相关信息(如:手术日期,手术级别,手术者,I助,II助等...);AValues 空以外不能填写的值(如"-\—")
/// Return:		ret<0:不一致; ret=1一致;
/// Debug:		w ##class(EPRservice.Quality.EmrCheckRule.ConsistencyCheck).IsUnify0063(EpisodeID,"手术编码1code","I","手术级别code\术者code\I助code\II助code","-\—")
/// w ##class(EPRservice.Quality.EmrCheckRule.ConsistencyCheck).IsUnify0063(EpisodeID,"11647","","11648\11649","")
ClassMethod IsUnify0039(AEpisodeID As %String, AElementIDs As %String) As %String
{
	s ret=0
	q:(AEpisodeID="")||(AElementIDs="") ret
	s ret=1
	
    s ElementIDs=##Class(EPRservice.Quality.CommonHelper).GetListFromString(AElementIDs,"\")
	s flag=0
	s Ind=1
	for 
	{	
		s ElementID=$listget(ElementIDs,Ind)
		q:ElementID=""
		
		s ElementValue=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,ElementID,"")
		//s ElementValue=$tr(ElementValue,"-\—","")
		
		s Ind=Ind+1	
		s:(ElementValue'="") flag=flag+1
		
		s:((flag'=0)&&(flag'=(Ind-1))) ret=-1	
	}
	
	s ElementCode=""
    s:(ret=-1) ElementCode=##Class(EPRservice.Quality.DataAccess.BOQualityPool).GetElementCode(AElementIDs)
	q ret_"@"_ElementCode
}

/// CreatDate:	2020-01-20
/// Creator:	YK
/// Desc:		病案首页.【主要诊断】各项填写不完整（诊断名称\诊断编码和入院病情需同时填写）
/// Input:		AEpisodeID为患者就诊号;
/// Return:		ret<0:不一致; ret=1一致;
/// Debug:		w ##Class(EPRservice.Quality.EmrCheckRule.ConsistencyCheck).IsUnify0040(EpisodeID,"主要诊断名称code\主要诊断编码code\主要诊断入院病情code\主要诊断出院情况code")
ClassMethod IsUnify0040(AEpisodeID As %String, AElementIDs As %String) As %String
{
	s ret=0
	q:(AEpisodeID="")||(AElementIDs="") ret
	
	s ret=1
    s ElementIDs=##Class(EPRservice.Quality.CommonHelper).GetListFromString(AElementIDs,"\")
    
	s flag=0
	s Ind=1,ElementList=""
	for 
	{
		s ElementID=$listget(ElementIDs,Ind)
		q:ElementID=""
		
		s ElementValue=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,ElementID,"")
		//s ElementValue=$tr(ElementValue,"-\—","")	注释此句，兼容部分项目可以诊断可以录非标准诊断的时候，诊断编码录入短横线的问题。
		
		s Ind=Ind+1
		s:(ElementValue'="") flag=flag+1
		s:((flag'=0)&&(flag'=(Ind-1))) ret=-1
		s:(ret=-1) ElementList=ElementID
		q:(ret=-1)
	}
	
	s ElementCode=""
    s:(ret=-1) ElementCode=##Class(EPRservice.Quality.DataAccess.BOQualityPool).GetElementCode(ElementList)
	q ret_"@"_ElementCode
}

/// CreatDate:	2020-01-20
/// Creator:	YK
/// Desc:		病案首页.【手术信息】各项填写不完整。不允许为-，如果有手术编码要求可以不写或者写-，在质控条目里去掉编码code即可！
/// Input:		AEpisodeID为患者就诊号;
/// Return:		ret<0:不一致; ret=1一致;
/// Debug:		w ##Class(EPRservice.Quality.EmrCheckRule.ConsistencyCheck).IsUnify0041(EpisodeID,"手术名称code\手术编码code\手术术者code\手术日期code",1)
ClassMethod IsUnify0041(AEpisodeID As %String, AElements As %String, ASites As %String = 1) As %String
{
	s ret = 0
	q:(AEpisodeID = "")||(AElements = "") ret
	
	s OperName = $p(AElements,"\",ASites)
	s ElementData=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,OperName,"")
	s ElementData=$tr(ElementData,"-\—","")
	q:(ElementData = "") ret
	
	s ElementList=""
	s num=$l(AElements,"\")
	for Ind = 1:1:num 
	{
		s ElementName = $p(AElements,"\",Ind)
		s ElementDataNew = ##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,ElementName,"")
		s ElementDataNew = $tr(ElementDataNew,"-\—","")
		s:(ElementDataNew="") ret=-1
		s:(ret=-1) ElementList=ElementID
		q:(ret=-1)
	}
	
	s ElementCode=""
    s:(ret=-1) ElementCode=##Class(EPRservice.Quality.DataAccess.BOQualityPool).GetElementCode(ElementList)
	q ret_"@"_ElementCode
}

/// CreatDate:	2020-01-20
/// Creator:	YK
/// Desc:		病案首页.【入/出院科室】不一致，【转科科室】不允许为空，请检查。
/// Input:		AEpisodeID为患者就诊号;
/// Return:		ret<0:不一致; ret=1一致;
/// Debug:		w ##class(EPRservice.Quality.EmrCheckRule.ConsistencyCheck).IsUnify0041(EpisodeID,"入院科室code","出院科室code","转科科室code")
ClassMethod IsUnify0042(AEpisodeID As %String, AElementID1 As %String, AElementID2 As %String, AElementID3 As %String) As %String
{
	s ret="0"
	q:(AElementID1="")||(AElementID2="")||(AElementID3="")
	
	s AdmLoc=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,AElementID1,"")
	s AdmLoc=$tr(AdmLoc,"-\—","")
	s DischLoc=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,AElementID2,"")
	s DischLoc=$tr(DischLoc,"-\—","")
	q:(AdmLoc="")||(DischLoc="") ret
	
	s ret="1"
	q:(AdmLoc=DischLoc) ret
	
	s TransLoc=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,AElementID3,"")
	s TransLoc=$tr(TransLoc,"-\—","")
	s:((TransLoc="")||(TransLoc="无")) ret="-1"
	
	s ElementCode=""
    s:(ret=-1) ElementCode=##Class(EPRservice.Quality.DataAccess.BOQualityPool).GetElementCode(AElementID1_"\"_AElementID2_"\"_AElementID3)
	q ret_"@"_ElementCode
}

/// CreatDate:	2020-01-20
/// Creator:	YK
/// Desc:		病案首页:【病理诊断费】大于0时，【病理号】不可为空，请检查。
/// Input:		AEpisodeID为患者就诊号;
/// Return:		ret<0:不一致; ret=1一致;
/// Debug:		w ##class(EPRservice.Quality.EmrCheckRule.ConsistencyCheck).IsUnify0042(EpisodeID,"病理诊断费code","病理号code")
ClassMethod IsUnify0043(AEpisodeID As %String, AElementID1 As %String, AElementID2 As %String) As %String
{
	s ret="0"
	q:(AElementID1="")||(AElementID2="")
	
	s ret="1"
	s PhFee=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,AElementID1,"")
	q:(+PhFee=0) ret
	
	s PhNo=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,AElementID2,"")
	s PhNo=$tr(PhNo,"-\—","")
	s:(PhNo="") ret=-1
	
	s ElementCode=""
    s:(ret=-1) ElementCode=##Class(EPRservice.Quality.DataAccess.BOQualityPool).GetElementCode(AElementID1_"\"_AElementID2)
	q ret_"@"_ElementCode
}

/// CreatDate:	2020-01-20
/// Creator:	YK
/// Desc:		病案首页:【医疗付费方式】为职工医保时,【工作单位】和【工作单位电话】以及【工作邮编】不能为空，请检查。
/// Input:		AEpisodeID为患者就诊号;AElementID1:离院方式,AElementIDs:病历单元，其中任意一个值不为空，则必须全部填写(多个用"\"分隔)。
/// Return:		ret<0:不一致; ret=1一致;
/// Debug:		w ##class(EPRservice.Quality.EmrCheckRule.ConsistencyCheck).IsUnify0043(EpisodeID,"医疗付费方式code","工作单位code\工作单位电话code\工作邮编code")
ClassMethod IsUnify0044(AEpisodeID As %String, AElementID1 As %String, AElementIDs As %String) As %String
{
	s ret="0"
	q:(AEpisodeID="")||(AElementID1="")||(AElementIDs="") ret
	
	s DischWay=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,AElementID1,"")
	q:(DischWay'["城镇职工基本医疗保险") ret
	
	s elemIDList=$lfs(AElementIDs,"\")
	SET ptr=0,count=0,eleValueList=""
	WHILE $LISTNEXT(elemIDList,ptr,eleID) 
	{
		//逐项取值,不一向依据代码取值
		s eleValue=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,eleID,"") 
		s eleValue=$tr(eleValue,"-\—","")
		continue:(eleValue'="")
		s ret=-1
		q 
	}
	
	s ElementCode=""
    s:(ret=-1) ElementCode=##Class(EPRservice.Quality.DataAccess.BOQualityPool).GetElementCode(AElementID1_"\"_AElementIDs)
	q ret_"@"_ElementCode
}

/// CreatDate:	2020-10-22
/// Creator:	YK
/// Desc:		病案首页.【婚姻状况】须与入院记录中一致。
/// Input:		AEpisodeID为患者就诊号;AElementID:离院方式,AElementID:首页婚姻单元，AElementIDs:入院记录婚姻单元
/// Return:		ret<0:不一致; ret=1一致;
/// Debug:      ##class(EPRservice.Quality.EmrCheckRule.IntegrityCheck).IsUnify0045(EpisodeID,"首页婚姻code","入院记录婚姻code\入院记录婚姻code")
ClassMethod IsUnify0045(AEpisodeID As %String, AElementID As %String, AElementIDs As %String) As %String
{
	s ret=0
	q:(AEpisodeID="")||(AElementID="")||(AElementIDs="") ret
	
	s ret=1 
	s ElementData=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,AElementID,"")
	q:($tr(ElementData,"-\—","")="") ret
	
	for I=1:1:$l(AElementIDs,"\")
	{
		s ElementID=$p(AElementIDs,"\",I)
		s tmpElementData=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,ElementID,"")
		continue:($tr(tmpElementData,"-\—","")="")
		s:(tmpElementData'=ElementData) ret=-1
		q
	}
	
    q ret
}

/// CreatDate:	2020-01-20
/// Creator:	YK
/// Desc:		病案首页.【质控日期】应大于【出院时间】，且在出院后三天内，请检查。
/// Input:		AEpisodeID为患者就诊号;AElement1:质控日期，AElement2：出院时间，ADays：出院后几天内
/// Return:		ret<0:不一致; ret=1一致;
/// Debug:		w ##class(EPRservice.Quality.EmrCheckRule.ConsistencyCheck).IsUnify0046(AEpisodeID,"质控日期code","出院日期code",3)
ClassMethod IsUnify0046(AEpisodeID As %String, AElement1 As %String, AElement2 As %String, ADays As %String = 3) As %String
{
	s ret=0
	q:(AEpisodeID="")||(AElement1="")||(AElement2="") ret
	s ret=1 
	
	//质控日期
	s ElementData1=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,AElement1,"")
	q:($tr(ElementData1,"-\—","")="") ret
	s ElementData1=$p(ElementData1," ",1)
	
	//出院日期
	s ElementData2=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,AElement2,"")
	q:($tr(ElementData2,"-\—","")="") ret
    s ElementData2=$p(ElementData2," ",1)
  	
	s Date1=##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(ElementData1)
	s Date2=##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(ElementData2)
	s Date1=$p(Date1," ",1)
	s Date2=$p(Date2," ",1)
	
	s:(Date1<Date2)||(Date1>(Date2+ADays)) ret=-1
	
    s ElementCode=""
    s:(ret=-1) ElementCode=##Class(EPRservice.Quality.DataAccess.BOQualityPool).GetElementCode(AElement1_"\"_AElement2)
	q ret_"@"_ElementCode
}

/// CreatDate:	2021-06-23
/// Creator:	GY
/// Desc:       病案首页.入院【抢救次数】不得小于【抢救成功次数】，请检查。
/// Input:      AElement1:抢救次数，AElement2:抢救成功次数,AFlagElementID 离院方式，AFlagValue "死亡"
/// Debug:      ##class(EPRservice.Quality.EmrCheckRule.ConsistencyCheck).IsUnify0047(EpisodeID,"抢救次数code","成功次数code","离院方式code","死亡")
ClassMethod IsUnify0047(AEpisodeID As %String, AElement1 As %String, AElement2 As %String, AFlagElementID As %String = "", AFlagValue As %String = "") As %String
{
	s ret=0
	q:(AEpisodeID="")||(AElement1="")||(AElement2="") ret
	
	s ret=1
	s ElementData1=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,AElement1,"") //抢救次数
	s ElementData2=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,AElement2,"") //成功次数
	
	s EleFlagData=""
	s:(AFlagElementID'="") EleFlagData=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,AFlagElementID,"")
	
	q:((EleFlagData="")||(EleFlagData'=AFlagValue))&&(ElementData1=ElementData2) ret
	q:(EleFlagData=AFlagValue)&&(ElementData1=(ElementData2+1)) ret
	
	s ret="-1"
	
    s ElementCode=""
    s:(ret=-1) ElementCode=##Class(EPRservice.Quality.DataAccess.BOQualityPool).GetElementCode(AElement1_"\"_AElement2_"\"_AFlagElementID)
	q ret_"@"_ElementCode
}

/// CreatDate:	2020-01-20
/// Creator:	YK
/// Desc:		病案首页.死亡患者【主要诊断】不允许为Z51、Z49的诊断。
/// Input:		AEpisodeID为患者就诊号;AHisDeathDateTime:公共函数中维护的患者死亡时间接口，ArgElement：主要诊断编码单元，AValues ：不允许出现的诊断编码值，ArgExtValues：例外的诊断编码
/// Return:		ret<0:不一致; ret=1一致;
/// Debug:		w ##class(EPRservice.Quality.EmrCheckRule.ConsistencyCheck).IsUnify0049(EpisodeID,{HisDeathTime2},"主要诊断编码code","Z51\Z49","")
ClassMethod IsUnify0049(AEpisodeID As %String, AHisDeathDateTime As %String, ArgElement As %String, AValues As %String, ArgExtValues As %String = "") As %String
{
	s ret=0
	q:(AEpisodeID="")||(ArgElement="")||(AHisDeathDateTime="") ret
	
	s ElementData=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,ArgElement,"")
	q:(ElementData="") ret
	
    s ExtValuels=##Class(EPRservice.Quality.CommonHelper).GetListFromString(ArgExtValues,"\")
	s ExtInd=1
	for 
	{	
		s ExtValue=$listget(ExtValuels,ExtInd)
		q:ExtValue=""
		s:(ElementData[ExtValue) ret=1
		s ExtInd=ExtInd+1	
	}
	q:(ret=1) ret
	
	s ret=1
	s flag=0
	for i=1:1:$l(AValues,"\") 
	{
		s Value=$p(AValues,"\",i)
		s:(ElementData[Value) flag=1
	}
	s:(flag=1) ret=-1
	
	s ElementCode=""
    s:(ret=-1) ElementCode=##Class(EPRservice.Quality.DataAccess.BOQualityPool).GetElementCode(ArgElement)
	q ret_"@"_ElementCode
}

/// CreatDate:	2021-06-25
/// Creator:	GY
/// Desc:		病案首页.【入院时间】应小于【首次病程记录记录时间】。
/// Input:		AEpisodeID为患者就诊号;AElement1:病案首页入院时间,ATemplateDocID:首次病程记录展现结构DocumentID(三版，条纹方块层ID),ATemplateID:首次病程记录模板ID
/// Return:		ret<0:不一致; ret=1一致;
/// Debug:      ##class(EPRservice.Quality.EmrCheckRule.ConsistencyCheck).IsUnify0050()
ClassMethod IsUnify0050(AEpisodeID As %String, AElement1 As %String, ATemplateDocID As %String, ATemplateID As %String) As %String
{
	s ret=0
	q:(AEpisodeID="")||(ATemplateDocID="")||(ATemplateID="")||(AElement1="") ret
	s ECRecordID=""
	
	//入院时间
	s FPAdmDateTime=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,AElement1,"")
	q:(FPAdmDateTime="") ret

	
	s ECRecordID=$o(^DHCEMRI.ECRecordI("IdxEpisodeIDChartItemID"," "_AEpisodeID," "_ATemplateDocID,ECRecordID))
	q:(ECRecordID="") ret
	
	s IsFinishDocument=$d(^DHCEMRI.InstanceDataI("IdxEcrecordTemplateStatus",ECRecordID," "_ATemplateID," SAVE"))

	q:(IsFinishDocument'="10") ret
	s DocumentSubID=$o(^DHCEMRI.InstanceDataI("IdxEcrecordTemplateStatus",ECRecordID," "_ATemplateID," SAVE",""))
	
	s InstanceObj=##class(EMRinstance.InstanceData).%OpenId(ECRecordID_"||"_DocumentSubID)
	s IntHappenDate=$zd(InstanceObj.HappenDate,3)
	s IntHappenTime=$zt(InstanceObj.HappenTime,1)
	
	s ret=1
	s tmpTimeGap = ##Class(EPRservice.Quality.CommonHelper).GetDateTimeGap(IntHappenDate_" "_IntHappenTime,FPAdmDateTime)
	q:(tmpTimeGap>0) ret
	
	s ret=-1
	s ElementCode=""
    s:(ret=-1) ElementCode=##Class(EPRservice.Quality.DataAccess.BOQualityPool).GetElementCode(AElement1)
	q ret_"@"_ElementCode
}

/// CreatDate:	2020-01-20
/// Creator:	YK
/// Desc:		病案首页.【主要诊断编码】中包含C00—D48且为首次入院，【病理诊断】不允许为空。
/// Input:		AEpisodeID为患者就诊号;AElement1:主要诊断编码单元，AElement2：病理诊断单元，AElement3:入院次数单元编码，AValues；编码中指定包含的值，ArgExtValues：诊断例外
/// Return:		ret<0:不一致; ret=1一致;
/// Debug:		w ##class(EPRservice.Quality.EmrCheckRule.ConsistencyCheck).IsUnify0051(EpisodeID,"主要诊断编码code","病理诊断编码code","入院次数code","C\D0\D1\D2\D3\D4","D49")
ClassMethod IsUnify0051(AEpisodeID As %String, AElement1 As %String, AElement2 As %String, AElement3 As %String, AValues As %String, ArgExtValues As %String) As %String
{
	s ret=0
	q:(AEpisodeID="")||(AElement1="")||(AElement2="") ret
	
	s ElementData3=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,AElement3,"")
	s ElementData3=$tr(ElementData3,"-\—","")
	q:(ElementData3>1)&&(ElementData3'="") ret
	
	s ElementData1=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,AElement1,"")
	s ElementData1=$tr(ElementData1,"-\—","")
	q:(ElementData1="") ret
	
	// 判断主要诊断是不是 C\D0\D1\D2\D3\D4 开头的
	s Values=##Class(EPRservice.Quality.CommonHelper).GetListFromString(AValues,"\")
	s flag=0
	s Ind=1
	for 
	{	
		s Value=$listget(Values,Ind)
		q:Value=""
		s:($e(ElementData1,1,$l(Value))=Value) flag=1
		s Ind=Ind+1	
		continue:(flag=0)
		s ExtValuels=##Class(EPRservice.Quality.CommonHelper).GetListFromString(ArgExtValues,"\")
		s ExtInd=1
		for 
		{
			s ExtValue=$listget(ExtValuels,ExtInd)
			q:ExtValue=""
			
			s:($e(ElementData1,1,$l(ExtValue))=ExtValue) flag=0
			q:(flag=0)
			s ExtInd=ExtInd+1
		}
		q:(flag=1)
	}
	q:(flag=0) ret
	
	s ret=1
	s ElementData2=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,AElement2,"")
	s ElementData2=$tr(ElementData2,"-\—","")
	s:(ElementData2="") ret=-1
   	
	s ElementCode=""
    s:(ret=-1) ElementCode=##Class(EPRservice.Quality.DataAccess.BOQualityPool).GetElementCode(AElement1_"\"_AElement2)
	q ret_"@"_ElementCode
}

/// CreatDate:	2020-01-20
/// Creator:	YK
/// Desc:		病案首页.【新生儿出生体重】【新生儿入院体重】填写范围须在"100-9999"之间(单位:克)。
///             病案首页.实际【住院天数】一般应大于0小于8000天且为整数，请检查。
/// Input:		AEpisodeID为患者就诊号;AElementIDs:新生儿出生体重单元ID(多个用"\"分隔)，AMin：单元填写范围最小值，AMax：单元填写范围最大值, ADataType 数据类型(为"I"表示必须整数，默认为"")
/// Return:		ret<0:不一致; ret=1一致;
/// Debug:		w ##class(EPRservice.Quality.EmrCheckRule.ConsistencyCheck).IsUnify0052(EpisodeID,"新生儿出生体重code\新生儿入院体重code","100","9999")
ClassMethod IsUnify0052(AEpisodeID As %String, AElementIDs As %String, AMin As %String, AMax As %String, ADataType As %String = "") As %String
{
	s ret=0
	q:(AEpisodeID="")||(AElementIDs="") ret
	
	s ret=1
	for I=1:1:$l(AElementIDs,"\")
	{
		s ElementID=$p(AElementIDs,"\",I)
		s ElementData=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,ElementID,"")
		s ElementData=$tr(ElementData,"-\—\ ","")
		continue:(ElementData="")
		
		s:(ADataType="I")&&($num(ElementData,"I")="") ret=-1
		q:(ret=-1)
		
		s:(AMin'="")&&(+ElementData<AMin) ret=-1
		s:(AMax'="")&&(+ElementData>AMax) ret=-1
		q:(ret=-1)
	}
	
	s ElementCode=""
    s:(ret=-1) ElementCode=##Class(EPRservice.Quality.DataAccess.BOQualityPool).GetElementCode(AElementIDs)
	q ret_"@"_ElementCode
}

/// CreatDate:	2020-01-20
/// Creator:	YK
/// Desc:		病案首页.【总费用】必须>=【自付金额】，请检查。
/// Input:		AEpisodeID为患者就诊号;
/// Return:		ret<0:不一致; ret=1一致;
/// Debug:		w ##Class(EPRservice.Quality.EmrCheckRule.ConsistencyCheck).IsUnify0054(EpisodeID,"总费用code","自付金额code",">=")
ClassMethod IsUnify0054(AEpisodeID As %String, AElement1 As %String, AElement2 As %String, AFlag As %String = "=") As %String
{
	s ret = 0
	q:(AEpisodeID = "")||(AElement1 = "")||(AElement2 = "")||(AFlag="") ret
	
	s ret = 1
	s ElementData1 = ##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,AElement1,"") // 总费用
	q:($tr(ElementData1,"-\—\ ","")="") ret
	
	//分项费用合计
	s AllPrice = 0
	for I=1:1:$l(AElement2,"\")
	{
		s Element2 = $p(AElement2,"\",I)
		s ElementData2 = ##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,Element2,"")
		continue:(+ElementData2=0)
		s AllPrice = AllPrice + ElementData2
	}
	
	s:(AFlag="=")&&($num(ElementData1)'=$num(AllPrice)) ret=-1
	s:(AFlag="<")&&($num(ElementData1)>=$num(AllPrice)) ret=-1
	s:(AFlag=">=")&&($num(ElementData1)<$num(AllPrice)) ret=-1
	
	s ElementCode=""
    s:(ret=-1) ElementCode=##Class(EPRservice.Quality.DataAccess.BOQualityPool).GetElementCode(AElement1_"\"_AElement2)
	q ret_"@"_ElementCode
}

/// CreatDate:	2021-06-25
/// Creator:	GY
/// Desc:		病案首页.【治疗类别】为"中医\中西医"，【主病】必填。
/// Input:		AEpisodeID为患者就诊号;AElement1  条件单元-治疗类别,AValues 条件单元符合值(多个用"\"分隔)，AElement2 判断单元-主病
/// Return:		ret<0:不一致; ret=1一致;
/// Debug:      ##class(EPRservice.Quality.EmrCheckRule.IntegrityCheck).IsUnify0055(EpisodeID,"治疗类别code","中医\中西医","主病code")
ClassMethod IsUnify0055(AEpisodeID As %String, AElement1 As %String, AValues As %String, AElement2 As %String) As %String
{
	s ret=0
	q:(AElement1="")||(AElement1="")||(AElement2="") ret
	
	s ret=1
	s ElementData1 = ##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,AElement1,"")
	q:(AValues[ElementData1) ret
	
	for I=1:1:$l(AElement2,"\")
	{
		s Element2=$P(AElement2,"\",I)
		s ElementData2 = ##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,Element2,"")
		s:($tr(ElementData2,"-\—","")="") ret=-1
		q:(ret=-1)
	}
	
	s ElementCode=""
	s:(ret=-1) ElementCode=##Class(EPRservice.Quality.DataAccess.BOQualityPool).GetElementCode(AElement1_"\"_AElement2)
	q ret_"@"_ElementCode
}

/// CreatDate:	2021-06-24
/// Creator:	GY
/// Desc:	   【是否因同一病种再入院】选择"是"，【与上次出院日期间隔天数】应大于"0"，否则应为空。
/// Input:		AEpisodeID为患者就诊号;
/// Return:		ret<0:不一致; ret=1一致;
/// Input:      AElementID1:是否因同一病种再入院，AElementID2：与上次出院日期间隔天数
/// Debug:      ##class(EPRservice.Quality.EmrCheckRule.ConsistencyCheck).IsUnify0056(EpisodeID,"是否因同一病种再入院","是","与上次出院日期间隔天数")
ClassMethod IsUnify0056(AEpisodeID As %String, AElementID1 As %String, AValue As %String, AElementID2 As %String) As %String
{
	s ret=0
	q:(AEpisodeID="")||(AElementID1="")||(AElementID2="") ret
	
	s ret=1
	s ElementData1=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,AElementID1,"")
	s ElementData2=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,AElementID2,"")
	s:(ElementData1=AValue)&&((+ElementData2)<=0) ret=-1
	s:(ElementData1'=AValue)&&($tr(ElementData2,"-\—","")'="") ret=-1
	
	s ElementCode=""
    s:(ret=-1) ElementCode=##Class(EPRservice.Quality.DataAccess.BOQualityPool).GetElementCode(AElementID1_"\"_AElementID2)
	q ret_"@"_ElementCode
}

/// CreatDate:	2021-06-25
/// Creator:	GY
/// Desc:		病案首页.【主病\门急诊诊断(中医诊断)】只能为"B"开头的中医编码。
/// Input:		AEpisodeID为患者就诊号;AElementIDs:主病ID，ADiagCode：允许编码开头字母
/// Return:		ret<0:不一致; ret=1一致;
/// Debug:      ##class(EPRservice.Quality.EmrCheckRule.IntegrityCheck).IsUnify0057(EpisodeID,"诊断","B")
ClassMethod IsUnify0057(AEpisodeID As %String, AElementIDs As %String, ADiagCode As %String) As %String
{
	s ret=0
	q:(AEpisodeID="")||(AElementIDs="")||(ADiagCode="") ret
	
	s ret=1,ElementList=""
	for I=1:1:$l(AElementIDs,"\")
	{
		s ElementID=$p(AElementIDs,"\",I)
		s ElementData=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,ElementID,"")
		continue:($tr(ElementData,"-\—","")="")
		s DiagCode=$e(ElementData,1,1)
		s:(DiagCode'=ADiagCode) ret=-1
		s:(ret=-1) ElementList=ElementID
		q:(ret=-1)
	}
	
	s ElementCode=""
    s:(ret=-1) ElementCode=##Class(EPRservice.Quality.DataAccess.BOQualityPool).GetElementCode(ElementList)
	q ret_"@"_ElementCode
}

/// CreatDate:	2021-06-25
/// Creator:	GY
/// Desc:		诊断(中医/西医)请按顺序填写。(如：填写【主证】前，请先填写【主病】。）
/// Input:		AEpisodeID为患者就诊号;AElements:诊断编码 (用"\"分隔)
/// Return:		ret<0:不一致; ret=1一致;
/// Debug:      ##class(EPRservice.Quality.EmrCheckRule.IntegrityCheck).IsUnify0058(EpisodeID,"主病code\主证code")
ClassMethod IsUnify0058(AEpisodeID As %String, AElements As %String) As %String
{
	s ret=0
	q:(AEpisodeID="")||(AElements="") ret
	
	s ret=1,ElementList=""
	for I=2:1:$l(AElements,"\")
	{
		s Element1=$p(AElements,"\",I-1)
		s Element2=$p(AElements,"\",I)
		s ElementData1=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,Element1,"")
		s ElementData1=$tr(ElementData1,"-\—","")
		s ElementData2=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,Element2,"")
		s ElementData2=$tr(ElementData2,"-\—","")
		s:(ElementData1="")&&(ElementData2'="") ret=-1
		s:(ret=-1) ElementList=Element1_"\"_Element2
		q:(ret=-1)
	}  
	
	s ElementCode=""
    s:(ret=-1) ElementCode=##Class(EPRservice.Quality.DataAccess.BOQualityPool).GetElementCode(ElementList)
	q ret_"@"_ElementCode
}

/// CreatDate:	2021-06-25
/// Creator:	GY
/// Desc:		单元只能填写数值，不能字符
/// Input:		AEpisodeID为患者就诊号;AElements:颅脑损伤时间编码 (用"\"分隔),AChars 可填写的特殊字符
/// Return:		ret<0:不一致; ret=1一致;
/// Debug:      ##class(EPRservice.Quality.EmrCheckRule.IntegrityCheck).IsUnify0059(EpisodeID,"颅脑损伤天code\小时code")
ClassMethod IsUnify0059(AEpisodeID As %String, AElements As %String, AChars As %String) As %String
{
	s ret=0
	q:(AEpisodeID="")||(AElements="") ret
	
	s ret=1
	for I=2:1:$l(AElements,"\")
	{
		s Element=$p(AElements,"\",I)
		s ElementData=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,Element,"")
		s ElementData=$tr(ElementData,AChars,"")
		continue:(ElementData="")
		s:($num(ElementData)="") ret=-1
		q:(ret=-1)
	}  
	
	s ElementCode=""
    s:(ret=-1) ElementCode=##Class(EPRservice.Quality.DataAccess.BOQualityPool).GetElementCode(AElements)
	q ret_"@"_ElementCode
}

/// CreatDate:	2021-06-25
/// Creator:	GY
/// Desc:		病案首页.【住院天数】大于"1"时,【**费用(或多项费用合计)】应大于"0"。
/// Input:		AEpisodeID为患者就诊号;AElement1：住院天数; AElement2：**费用(或多项费用合计);AElement3:总费用(默认为空,不为空时须判断小于总费用)
/// Return:		ret<0:不一致; ret=1一致;
/// Debug:      ##Class(EPRservice.Quality.EmrCheckRule.ConsistencyCheck).IsUnify0060(EpisodeID,"住院天数code","**费用code","")
ClassMethod IsUnify0060(AEpisodeID As %String, AElement1 As %String, AElement2 As %String, AElement3 As %String = "") As %String
{
	s ret = 0
	q:(AEpisodeID = "")||(AElement1 = "")||(AElement2 = "") ret
	
	s ret = 1
	///住院天数
	s ElementData1 = ##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,AElement1,"") // 总费用
	q:(+$num(ElementData1)<="1") ret
	
	//分项费用合计
	s AllPrice = 0
	for I=1:1:$l(AElement2,"^")
	{
		s Element2 = $p(AElement2,"^",I)
		s ElementData2 = ##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,Element2,"")
		continue:(+ElementData2=0)
		s AllPrice = AllPrice + ElementData2
	}
	s:(AElement3="")&&($num(AllPrice)<=0) ret=-1
	if (AElement3'="")
	{
		s ElementData3= ##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,AElement3,"")
		q:(+ElementData3=0) ret
		s:($num(AllPrice)>=$num(ElementData3)) ret=-1
	}
	
	s ElementCode=""
    s:(ret=-1) ElementCode=##Class(EPRservice.Quality.DataAccess.BOQualityPool).GetElementCode(AElement1_"\"_AElement2_"\"_AElement3)
	q ret_"@"_ElementCode
}

/// CreatDate:	
/// Creator:	GY
/// Desc:		
/// Input:		AEpisodeID为患者就诊号;AElement1：住院天数; AElement2：**费用(或多项费用合计);AElement3:总费用(默认为空,不为空时须判断小于总费用)
/// Return:		ret<0:不一致; ret=1一致;
/// Debug:      ##Class(EPRservice.Quality.EmrCheckRule.ConsistencyCheck).IsUnify0060(EpisodeID,"住院天数code","**费用code","")
ClassMethod IsUnify006001(AEpisodeID As %String, AElement1 As %String, AElement2 As %String, AElement3 As %String = "") As %String
{
	s ret = 0
	q:(AEpisodeID = "")||(AElement1 = "")||(AElement2 = "") ret
	
	s ret = 1
	///抢救次数
	s ElementData1 = ##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,AElement1,"") 
	//s ElementData1 = $tr($tr(ElementData1,"-",""),"-","")
	//b ;22
	q:(+$num(ElementData1)<"1") ret
	//b ;1
	///抢救原因
	s ElementData2 = ##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,AElement2,"") 
	s ElementData2 = $tr($tr(ElementData2,"-",""),"-","")
	s:(ElementData2="") ret="-1"
	s ElementCode=""
    s:(ret=-1) ElementCode=##Class(EPRservice.Quality.DataAccess.BOQualityPool).GetElementCode(AElement1_"\"_AElement2)
	q ret_"@"_ElementCode
}

/// CreatDate:	2021-06-25
/// Creator:	GY
/// Desc:		病案首页.【使用医疗机构中药制剂】为"是"时,【医疗机构中药制剂费】必填，且应大于"0"。
/// Input:		AEpisodeID为患者就诊号;AElement1：使用医疗机构中药制剂; AValue 条件符合值; AElement2：**费用
/// Return:		ret<0:不一致; ret=1一致;
/// Debug:      ##Class(EPRservice.Quality.EmrCheckRule.IntegrityCheck).IsUnify0061(EpisodeID,"使用医疗机构中药制剂code","是","医疗机构中药制剂费code")
ClassMethod IsUnify0061(AEpisodeID As %String, AElement1 As %String, AValue As %String, AElement2 As %String = "") As %String
{
	s ret = 0
	q:(AEpisodeID = "")||(AElement1 = "")||(AValue="")||(AElement2 = "") ret
	
	s ret = 1
	///使用医疗机构中药制剂
	s ElementData1 = ##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,AElement1,"") // 总费用
	q:(ElementData1'=AValue) ret
	
	//分项费用合计
	for I=1:1:$l(AElement2,"^")
	{
		s Element2 = $p(AElement2,"^",I)
		s ElementData2 = ##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,Element2,"")
		s:(+$num(ElementData2)<=0) ret=-1
		q:(ret=-1)
	}
	
	s ElementCode=""
    s:(ret=-1) ElementCode=##Class(EPRservice.Quality.DataAccess.BOQualityPool).GetElementCode(AElement1_"\"_AElement2)
	q ret_"@"_ElementCode
}

/// CreatDate:	2021-06-24
/// Creator:	GY
/// Desc:	   【主要手术操作】类型为手术时，【一般治疗操作费】+【手术治疗费】应>0。
/// Input:		AEpisodeID为患者就诊号;AElementID：主要手术操作名称; AOPType 手术类别要求(N 手术、I 介入治疗); AElementIDs：一般治疗操作费\手术治疗费
/// Return:		ret<0:不一致; ret=1一致;
/// Debug:		##class(EPRservice.Quality.EmrCheckRule.ConsistencyCheck).IsUnify0062(EpisodeID,"主要手术操作名称code","N","一般治疗操作费code\手术治疗费code")
ClassMethod IsUnify0062(AEpisodeID As %String, AElementID As %String, AOPType As %String, AElementIDs As %String) As %String
{
	s ret=0
	q:(AEpisodeID="")||(AElementID="")||(AElementIDs="") ret
	
	s ret=1
	s ElementData=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,AElementID,"")
    q:(ElementData="") ret
    
	s flag=1
	if (AOPType'="")
	{
		s OPERType="",OPERRowId=""
		s OperDesc=$$ALPHAUP^SSUTIL4(ElementData)
		s OPERRowId=$O(^ORC("OPER",0,"Desc",OperDesc,OPERRowId)) 
		q:(OPERRowId="") ret
		s OPERType=$p($g(^ORC("OPER",OPERRowId,"DHC")),"^",11)
		s:(AOPType'[OPERType) flag=0
	}
	q:(flag=0) ret
	
	//分项费用合计
	s AllPrice = 0
	for I=1:1:$l(AElementIDs,"\")
	{
		s ElementID = $p(AElementIDs,"\",I)
		s tmpElementData = ##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,ElementID,"")
		continue:(+tmpElementData=0)
		s AllPrice = AllPrice + tmpElementData
	}
	s:(AllPrice<=0) ret=-1
		
	s ElementCode=""
    s:(ret=-1) ElementCode=##Class(EPRservice.Quality.DataAccess.BOQualityPool).GetElementCode(AElementID_"\"_AElementIDs)
	q ret_"@"_ElementCode
}

/// CreatDate:	2020-01-20
/// Creator:	YK
/// Desc:		病案首页.【主要手术及操作编码】为"介入治疗"类别时，【手术级别】【术者】【I助】【II助】必填(不可填"-")。
/// Input:		AEpisodeID为患者就诊号;AElementID：手术编码; AOPType 手术类别要求(N 手术、I 介入治疗); AElementIDs：手术相关信息(如:手术日期,手术级别,手术者,I助,II助等...);AValues 空以外不能填写的值(如"-\—")
/// Return:		ret<0:不一致; ret=1一致;
/// Debug:		w ##class(EPRservice.Quality.EmrCheckRule.ConsistencyCheck).IsUnify0063(EpisodeID,"手术编码1code","I","手术级别code\术者code\I助code\II助code","-\—")
/// w ##class(EPRservice.Quality.EmrCheckRule.ConsistencyCheck).IsUnify0063(EpisodeID,"11647","","11648\11649","")
ClassMethod IsUnify0063(AEpisodeID As %String, AElementID As %String, AOPType As %String, AElementIDs As %String, AValues As %String = "") As %String
{
	s ret=0
	q:(AEpisodeID="")||(AElementID="")||(AElementIDs="") ret
	
	s ret=1
	s ElementData=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,AElementID,"")
    q:(ElementData="") ret
    
	s flag=1
	if (AOPType'="")
	{
		s OPERType="",OPERRowId=""
		s OperDesc=$$ALPHAUP^SSUTIL4(ElementData)
		s OPERRowId=$O(^ORC("OPER",0,"Desc",OperDesc,OPERRowId)) 
		q:(OPERRowId="") ret
		s OPERType=$p($g(^ORC("OPER",OPERRowId,"DHC")),"^",11)
		s:(AOPType'[OPERType) flag=0
	}
	q:(flag=0) ret
	
	s ElementList=""
	for I=1:1:$l(AElementIDs,"\")
	{
		s ElementID=$p(AElementIDs,"\",I)
		s tmpElementData=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,ElementID,"")
		s:(AValues'="") tmpElementData=$tr(tmpElementData,AValues,"")
		continue:(tmpElementData'="")
		s ElementList=ElementID_"\"_AElementID
		s ret=-1
		q
	}
		
	s ElementCode=""
    s:(ret=-1) ElementCode=##Class(EPRservice.Quality.DataAccess.BOQualityPool).GetElementCode(ElementList)
	q ret_"@"_ElementCode
}

/// CreatDate:	2020-01-20
/// Creator:	YK
/// Desc:		病案首页.【出院诊断编码】为"D10-D36",【病理诊断编码】必须是包含"/0"的(良性肿瘤)。
/// 			病案首页.【出院诊断编码】为"D37-D48",【病理诊断编码】必须是包含"/1"的(动态未肯定或未知的肿瘤)。
/// 			病案首页.【出院诊断编码】为"D00-D09",【病理诊断编码】必须是包含"/2"的(原位肿瘤)。
/// 			病案首页.【出院诊断编码】为"C00-C76",【病理诊断编码】必须是包含"/3"的(恶性肿瘤，被陈述或定为原发性)。
/// 			病案首页.【出院诊断编码】为"C80-C97",【病理诊断编码】必须是包含"/4"的(恶性肿瘤，被陈述或定为原发性)。
/// 			病案首页.【出院诊断编码】为"C77-C79",【病理诊断编码】必须是包含"/6"的(恶性肿瘤，被陈述或定为继发性)。
/// Input:		AEpisodeID为患者就诊号;
/// Return:		ret<0:不一致; ret=1一致;
/// Debug:		w ##class(EPRservice.Quality.EmrCheckRule.ConsistencyCheck).IsUnify0064(EpisodeID,{HISDiagCodes},"D","10^36","病理诊断编码code","/0")
/// 			w ##class(EPRservice.Quality.EmrCheckRule.ConsistencyCheck).IsUnify0064(EpisodeID,{HISDiagCodes},"D","37^48","病理诊断编码code","/1")
/// 			w ##class(EPRservice.Quality.EmrCheckRule.ConsistencyCheck).IsUnify0064(EpisodeID,{HISDiagCodes},"D","00^09","病理诊断编码code","/2")
/// 			w ##class(EPRservice.Quality.EmrCheckRule.ConsistencyCheck).IsUnify0064(EpisodeID,{HISDiagCodes},"C","00^76","病理诊断编码code","/3")
/// 			w ##class(EPRservice.Quality.EmrCheckRule.ConsistencyCheck).IsUnify0064(EpisodeID,{HISDiagCodes},"C","80^97","病理诊断编码code","/4")
/// 			w ##class(EPRservice.Quality.EmrCheckRule.ConsistencyCheck).IsUnify0064(EpisodeID,{HISDiagCodes},"C","77^79","病理诊断编码code","/6")
ClassMethod IsUnify0064(AEpisodeID As %String, AElements1 As %String, ACode As %String, ANum As %String, AElement2 As %String, AValue2 As %String)
{
	s ret=0,flag=0
	q:(AEpisodeID="")||(AElements1="")||(ANum="")||(ACode="")||(AElement2="") ret 
	
	s ret=1
	s NumMin=$p(ANum,"^",1)
	s NumMax=$p(ANum,"^",2)
	for i=1:1:$l(AElements1,"\")
	{
		s Element1=$p(AElements1,"\",i)
		s ElementData1=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,Element1,"")
		s ElementData1=$tr(ElementData1,"-\—\ ","")
		continue:(ElementData1="")||($e(ElementData1,1,1)'=ACode)
		
		s:($e(ElementData1,2,3)>=NumMin)&&($e(ElementData1,2,3)<=NumMax) flag=1
		q:(flag=1)
	}
	q:flag=0 ret
	
	s ElementData2=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,AElement2,"")
	s:(ElementData2'[AValue2) ret=-1
	
	s ElementCode=""
    s:(ret=-1) ElementCode=##Class(EPRservice.Quality.DataAccess.BOQualityPool).GetElementCode(AElements1_"\"_AElement2)
	q ret_"@"_ElementCode
}

/// CreatDate:	2021-06-25
/// Creator:	GY
/// Desc:		病案首页.【治疗类别】为"中医/中西医",且【住院天数】大于"1"时,【**费用】应大于"0"。
/// Input:		AEpisodeID为患者就诊号;AElement1：治疗类别; AElement2：住院天数; AElement3：**费用(多个用"^"分隔);
/// Return:		ret<0:不一致; ret=1一致;
/// Debug:      ##Class(EPRservice.Quality.EmrCheckRule.IntegrityCheck).IsUnify0065(EpisodeID,"治疗类别code","住院天数code","**费用code")
ClassMethod IsUnify0065(AEpisodeID As %String, AElement1 As %String, AElement2 As %String, AElement3 As %String = "") As %String
{
	s ret = 0
	q:(AEpisodeID = "")||(AElement1 = "")||(AElement2="")||(AElement3 = "") ret
	
	s ret = 1
	///治疗类别
	s ElementData1 = ##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,AElement1,"") // 总费用
	q:(ElementData1'="中医")&&((ElementData1'="中西医")) ret
	
	///住院天数
	s ElementData1 = ##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,AElement1,"") // 总费用
	q:(ElementData1<="1") ret
	
	//分项费用合计
	s AllPrice = 0
	for I=1:1:$l(AElement3,"^")
	{
		s Element3 = $p(AElement3,"^",I)
		s ElementData3 = ##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,Element3,"")
		continue:(+ElementData3=0)
		s AllPrice = AllPrice + ElementData3
	}
	s:(AllPrice<=0) ret=-1
	
	s ElementCode=""
    s:(ret=-1) ElementCode=##Class(EPRservice.Quality.DataAccess.BOQualityPool).GetElementCode(AElement1_"\"_AElement2_"\"_AElement3)
	q ret_"@"_ElementCode
}

/// CreatDate:	2020-01-20
/// Creator:	YK
/// Desc:		病案首页.【手术费】大于0时，【手术操作名称1】不允许为空请检查
/// 				病案首页:【麻醉费】大于0时，【麻醉方式1】一般不可为空，请检查。
/// Input:		AEpisodeID为患者就诊号;AElement1:麻醉费 ，AElement2:麻醉方式(多个有"\"分隔), AQuaFlag ALL 全部不可为空 ONE 一个不为空即可
/// Input:		AEpisodeID为患者就诊号;AElement1:手术费 ，AElement2:手术名称(多个有"\"分隔)
/// Return:		ret<0:不一致; ret=1一致;
/// Debug:		w ##class(EPRservice.Quality.EmrCheckRule.ConsistencyCheck).IsUnify0066(EpisodeID,"手术费code","手术名称1code")
ClassMethod IsUnify0066(AEpisodeID As %String, AElement1 As %String, AElement2 As %String, AQuaFlag As %String = "All")
{
	s ret=0
	q:(AEpisodeID="")||(AElement1="")||(AElement2="") ret
	
	s ElementData1=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,AElement1,"") 
	q:(+ElementData1<=0) ret
	
	s ElementList=""
	if (AQuaFlag="ALL")
	{
		s ret=1
		for I=1:1:$l(AElement2,"\")
		{
			s Element2=$p(AElement2,"\",I)
			s ElementData2=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,Element2,"") 
			s:($tr(ElementData2,"-\—\ ","")="") ret="-1"
			s:(ret=-1) ElementList=Element2_"\"_AElement1
			q:(ret="-1")
		}
	}
	elseif (AQuaFlag="ONE")
	{
		s ret=-1
		for I=1:1:$l(AElement2,"\")
		{
			s Element2=$p(AElement2,"\",I)
			s ElementData2=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,Element2,"") 
			s:($tr(ElementData2,"-\—\ ","")'="") ret="1"
			q:(ret="1")
		}
		s:(ret=-1) ElementList=AElement2_"\"_AElement1
	}
	
	s ElementCode=""
    s:(ret=-1) ElementCode=##Class(EPRservice.Quality.DataAccess.BOQualityPool).GetElementCode(ElementList)
	q ret_"@"_ElementCode
}

/// CreatDate:	2021-06-25
/// Creator:	GY
/// Desc:		病案首页:填了【麻醉方式】【麻醉医生】，【麻醉费】必须大于0，请检查是否漏收麻醉费。
/// Input:		AEpisodeID为患者就诊号;AElement1:麻醉费 ，AElement2:麻醉方式，AElement3：麻醉医生
/// Return:		ret<0:不一致; ret=1一致;
/// Debug:      ##class(EPRservice.Quality.EmrCheckRule.ConsistencyCheck).IsUnify0067(EpisodeID,11957,12491,12490)
ClassMethod IsUnify0067(AEpisodeID As %String, AElement1 As %String, AElement2 As %String, AElement3 As %String)
{
	s ret=0
   
	q:(AEpisodeID="")||(AElement1="")||(AElement2="")||(AElement3="") ret
	
	s ElementData1=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,AElement1,"") 
	q:(+ElementData1>0) ret
	
	s ret=1,ElementList=""
	for I=1:1:$l(AElement2,"\")
	{
		s Element2=$p(AElement2,"\",I)
		s ElementData2=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,Element2,"") 
		continue:($tr(ElementData2,"-\—\ ","")="")
		s ElementList=Element2
		s ret=-1
		q
	}
	q:(ret=-1) ret
	
	if (AElement3'="")
	{
		
		for J=1:1:$l(AElement3,"\")
		{
			s Element3=$p(AElement3,"\",J)
			s ElementData3=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,Element3,"") 
			continue:($tr(ElementData3,"-\—\ ","")="")
			s:(ElementList'="") ElementList=ElementList_"\"_Element2
			s:(ElementList="") ElementList=Element2
			s ret=-1
			q
		}
	}
	
	s ElementCode=""
    s:(ret=-1) ElementCode=##Class(EPRservice.Quality.DataAccess.BOQualityPool).GetElementCode(ElementList)
	q ret_"@"_ElementCode
}

/// CreatDate:	2021-06-25
/// Creator:	GY
/// Desc:		自付金额<总费用且自付金额大于0，付费方式不应为自费（两费用误差小于1元除外）
/// Input:		AEpisodeID为患者就诊号;AElement1:付费方式单元 ， AElement2:总费用单元，AElement3:自付费用单元
/// Return:		ret<0:不一致; ret=1一致;
/// Debug:      ##class(EPRservice.Quality.EmrCheckRule.ConsistencyCheck).IsUnify0068(EpisodeID,"付费方式code","总费用code","自付费用code")
ClassMethod IsUnify0068(AEpisodeID As %String, AElement1 As %String, AElement2 As %String, AElement3 As %String)
{
	s ret=0
   
	q:(AEpisodeID="")||(AElement1="")||(AElement2="")||(AElement3="") ret
	
	s ret=1
	s ElementData1=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,AElement1,"") 
	q:(ElementData1'="自费") ret
	
	s ElementData2=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,AElement2,"") 
	s ElementData3=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,AElement3,"")
	q:(ElementData2="")||(ElementData3="") ret
	q:(+ElementData2<=(+ElementData3)+1) ret
	s:(+ElementData2>+ElementData3)&&(+ElementData3>0) ret=-1
	
	s ElementCode=""
    s:(ret=-1) ElementCode=##Class(EPRservice.Quality.DataAccess.BOQualityPool).GetElementCode(AElement1_"\"_AElement2_"\"_AElement3)
	q ret_"@"_ElementCode
}

/// CreatDate:	2021-06-25
/// Creator:	GY
/// Desc:		病案首页.【医疗机构中药制剂费】>0时，【使用医疗机构中药制剂】应为"是"。
/// Input:		AEpisodeID为患者就诊号;AElementIDs:医疗机构中药制剂费 ， AElementID:使用医疗机构中药制剂
/// Return:		ret<0:不一致; ret=1一致;
/// Debug:      ##class(EPRservice.Quality.EmrCheckRule.IntegrityCheck).IsUnify0069(EpisodeID,"医疗机构中药制剂费code",">","使用医疗机构中药制剂code","是")
ClassMethod IsUnify0069(AEpisodeID As %String, AElementIDs As %String, AFlag As %String = ">", AElementID As %String, AValue As %String)
{
	s ret=0
   
	q:(AEpisodeID="")||(AElementIDs="")||(AElementID="") ret
	
	s ret=1,TotalFee=0
	for I=1:1:$l(AElementIDs,"\")
	{
		s ElementID=$p(AElementIDs,"\",I)
		s tmpFee=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,ElementID,"")
		s TotalFee=TotalFee+tmpFee
	}
	q:(AFlag=">")&&(+TotalFee=0) ret
	q:(AFlag="=")&&(+TotalFee>0) ret
	
	s ElementData=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,AElementID,"") 
	s:(ElementData'=AValue) ret=-1
	
	s ElementCode=""
    s:(ret=-1) ElementCode=##Class(EPRservice.Quality.DataAccess.BOQualityPool).GetElementCode(AElementIDs_"\"_AElementID)
	q ret_"@"_ElementCode
}

/// CreatDate:	2020-01-20
/// Creator:	YK
/// Desc:		病案首页.【性别】男性【年龄】小于22岁,【性别】女性【年龄】小于20岁，【婚姻】只允许填写"2-未婚"，请检查。
/// Input:		AEpisodeID为患者就诊号;AElement1:年龄，AElement2:婚姻，AElement3:性别，AValue:条件值
/// Return:		ret<0:不一致; ret=1一致;
/// Debug:		w ##class(EPRservice.Quality.EmrCheckRule.ConsistencyCheck).IsUnify0071(EpisodeID,"年龄code","婚姻code","性别code","未婚")
ClassMethod IsUnify0071(AEpisodeID As %String, AElement1 As %String, AElement2 As %String, AElement3 As %String, AValue As %String) As %String
{
	s ret=0
	q:(AEpisodeID="")||(AElement1="")||(AElement2="")||(AElement3="")||(AValue="") ret
	
	s ret=1 
	//年龄
	s ElementData1=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,AElement1,"")
	s age=+ElementData1
	s:(ElementData1["月")||(ElementData1["天") age=0
	
	//婚姻
	s ElementData2=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,AElement2,"")
	
	//性别
	s ElementData3=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,AElement3,"")
	q:($tr(ElementData3,"-\—\ ","")="") ret
    
    s:(ElementData3="男")&&(age<22)&&(ElementData2'=AValue) ret=-1
    s:(ElementData3="女")&&(age<20)&&(ElementData2'=AValue) ret=-1
    
	s ElementCode=""
    s:(ret=-1) ElementCode=##Class(EPRservice.Quality.DataAccess.BOQualityPool).GetElementCode(AElement1_"\"_AElement2_"\"_AElement3)
	q ret_"@"_ElementCode
}

/// 说明: 【血型】与【RH】填写规则。
/// Input: AEpisodeID为患者就诊号 , AElement1:血型编码 , AElement2:RH编码
/// OutPut: 0 不用检查或配置错误 ; -1 触犯条目 ; 1  符合条件 
/// Debug:	##class(EPRservice.Quality.EmrCheckRule.ConsistencyCheck).IsUnify0072(EpisodeID,"血型code","RHcode")
ClassMethod IsUnify0072(AEpisodeID As %String, AElement1 As %String, AElement2 As %String) As %String
{
	s ret=0
	q:(AEpisodeID="")||(AElement1="")||(AElement2="") ret
	
	s ret=1
	///取血型编码
	s ElementData1=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,AElement1,"") 
	s ElementData2=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,AElement2,"")
	
	s:($tr(ElementData2,"-\—","")="")&&($tr(ElementData1,"-\—","")'="") ret=-1    ///血型填写,RH必填，不能为空
	s:($tr(ElementData2,"-\—","")'="")&&($tr(ElementData1,"-\—","")="") ret=-1    ///RH填写,血型必填，不能为空
	s:($tr(ElementData1,"A\B\O\AB","")="")&&($tr(ElementData2,"阴\阳\阴性\阳性","")'="") ret=-1   ///血型为"A\B\O\AB",RH只能填写"阴\阳"
	s:($tr(ElementData1,"a\b\o\ab","")="")&&($tr(ElementData2,"阴\阳\阴性\阳性","")'="") ret=-1   ///血型为"A\B\O\AB",RH只能填写"阴\阳"
	s:($tr(ElementData1,"不详","")="")&&($tr(ElementData2,"不详","")'="") ret=-1     ///血型为"不祥",RH只能填写"不祥"
	s:($tr(ElementData1,"不祥","")="")&&($tr(ElementData2,"不祥","")'="") ret=-1     ///血型为"不祥",RH只能填写"不祥"
	s:($tr(ElementData1,"未查","")="")&&($tr(ElementData2,"未查","")'="") ret=-1     ///血型为"未查",RH只能填写"未查"
	
	s ElementCode=""
    s:(ret=-1) ElementCode=##Class(EPRservice.Quality.DataAccess.BOQualityPool).GetElementCode(AElement1_"\"_AElement2)
	q ret_"@"_ElementCode
}

/// CreatDate:	2020-01-20
/// Creator:	YK
/// Desc:		病案首页.【性别】为"女",【门急诊诊断】【入院诊断】和【出院诊断】中不应出现男性化疾病诊断名称（C60-C63,N40-N51）；B26.0；C60-C63；D07.4-D07.6；D17.6；D29；D40；E29；E89.5；F52.4；I86.1；L29.1；N40-N51；Q53-Q55；R86；S31.2-S31.3；Z12.5
/// Input:		AEpisodeID为患者就诊号;AElement1 性别; AElement2 诊断1code\诊断2code
/// Return:		ret<0:不一致; ret=1一致;
/// Debug:		w ##Class(EPRservice.Quality.EmrCheckRule.ConsistencyCheck).IsUnify0074(EpisodeID,"性别code",{HISDiagCodes})
ClassMethod IsUnify0074(AEpisodeID As %String, AElement1 As %String, AElement2 As %String) As %String
{
	s ret = 0
	q:(AEpisodeID = "")||(AElement1 = "")||(AElement2="") ret
    
	s ElementData1 = ##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,AElement1,"")
	q:(ElementData1'="女") ret
	
	s ElementList = ""
	for P=1:1:$l(AElement2,"\")
	{
		s Element2=$p(AElement2,"\",P)
		s ElementData2=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,Element2,"")
		continue:($tr(ElementData2,"-\—\ ","")="")
		s:(($E(ElementData2,1,1)="C")&&(($E(ElementData2,2,3)>="60")&&($E(ElementData2,2,3)<="63"))) ret = "-1"
		;s:(($E(ElementData2,1,1)="D")&&(($E(ElementData2,2,5)>="07.4")&&($E(ElementData2,2,5)<="07.6"))) ret = "-1"
		s:(($E(ElementData2,1,1)="N")&&(($E(ElementData2,2,3)>="40")&&($E(ElementData2,2,3)<="51"))) ret = "-1"
		;s:(($E(ElementData2,1,1)="Q")&&(($E(ElementData2,2,3)>="53")&&($E(ElementData2,2,3)<="55"))) ret = "-1"
		s:(ret=-1) ElementList=AElement1_"\"_Element2
		q:(ret=-1)
	}
	/*
	s:((ElementData2Str["B26.0")||(ElementData2Str["D17.6")) ret = "-1"
	s:((ElementData2Str["D29")||(ElementData2Str["D40")) ret = "-1"
	s:((ElementData2Str["E29")||(ElementData2Str["E89.5")) ret = "-1"
	s:((ElementData2Str["F52.4")||(ElementData2Str["I86.1")) ret = "-1"
	s:((ElementData2Str["L29.1")||(ElementData2Str["R86")) ret = "-1"
	s:((ElementData2Str["S31.2")||(ElementData2Str["S31.3")) ret = "-1"
	s:(ElementData2Str["Z12.5") ret = "-1"
	*/
	
	s ElementCode=""
    s:(ret=-1) ElementCode=##Class(EPRservice.Quality.DataAccess.BOQualityPool).GetElementCode(ElementList)
	q ret_"@"_ElementCode
}

/// CreatDate:	2020-01-20
/// Creator:	YK
/// Desc:		病案首页.【性别】为"男",【门急诊诊断】【入院诊断】和【出院诊断】中不应出现女性化疾病诊断名称(C51-C58,N70-N77,N80-N98,O00-O99)；A34；B37.3；C51-C58；C79.6；D06；D07.0-D07.3；D25-D28；D39；E28；E89.4；F52.5；F53；I86.3；L29.2；M80.0-M80.1；M81.0-M81.1；M83.0；N70-N98；N99.2-N99.3；O00-O99；P54.6；Q50-Q52；R87；S31.4；S37.4-S37.6；T19.2-T19.3；T83.3；Z01.4；Z12.4；Z30.1；Z30.3；Z30.5；Z31.1-Z31.2；Z32- Z37；Z39；Z87.5；Z97.5
/// Input:		AEpisodeID为患者就诊号;AElement1 性别; AElement2 诊断1code\诊断2code
/// Return:		ret<0:不一致; ret=1一致;
/// Debug:		w ##Class(EPRservice.Quality.EmrCheckRule.ConsistencyCheck).IsUnify0074(EpisodeID,"性别code",{HISDiagCodes})
ClassMethod IsUnify0075(AEpisodeID As %String, AElement1 As %String, AElement2 As %String) As %String
{
	s ret = 0
	q:(AEpisodeID = "")||(AElement1 = "")||(AElement2="") ret
	
	s ElementData1 = ##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,AElement1,"")
	q:(ElementData1'="男") ret
	
	s ElementList = ""
	for P=1:1:$l(AElement2,"\")
	{
		s Element2=$p(AElement2,"\",P)
		s ElementData2=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,Element2,"")
		continue:($tr(ElementData2,"-\—\ ","")="")
		
		s:(($E(ElementData2,1,1)="C")&&(($E(ElementData2,2,3)>="51")&&($E(ElementData2,2,3)<="58"))) ret = "-1"
		;s:(($E(ElementData2,1,1)="D")&&(($E(ElementData2,2,5)>="07.0")&&($E(ElementData2,2,5)<="07.3"))) ret = "-1"
		;s:(($E(ElementData2,1,1)="D")&&(($E(ElementData2,2,3)>="25")&&($E(ElementData2,2,3)<="28"))) ret = "-1"
		;s:(($E(ElementData2,1,1)="M")&&(($E(ElementData2,2,5)>="80.0")&&($E(ElementData2,2,5)<="80.1"))) ret = "-1"
		;s:(($E(ElementData2,1,1)="M")&&(($E(ElementData2,2,5)>="81.0")&&($E(ElementData2,2,5)<="81.1"))) ret = "-1"
		s:(($E(ElementData2,1,1)="N")&&(($E(ElementData2,2,3)>="70")&&($E(ElementData2,2,3)<="77"))) ret = "-1"
		s:(($E(ElementData2,1,1)="N")&&(($E(ElementData2,2,3)>="80")&&($E(ElementData2,2,3)<="98"))) ret = "-1"
		s:(($E(ElementData2,1,1)="O")&&(($E(ElementData2,2,3)>="00")&&($E(ElementData2,2,3)<="99"))) ret = "-1"
		;s:(($E(ElementData2,1,1)="Q")&&(($E(ElementData2,2,3)>="50")&&($E(ElementData2,2,3)<="52"))) ret = "-1"
	    ;s:(($E(ElementData2,1,1)="T")&&(($E(ElementData2,2,5)>="19.2")&&($E(ElementData2,2,5)<="19.3"))) ret = "-1"
		;s:(($E(ElementData2,1,1)="Z")&&(($E(ElementData2,2,5)>="31.1")&&($E(ElementData2,2,5)<="31.2"))) ret = "-1"
		;s:(($E(ElementData2,1,1)="S")&&(($E(ElementData2,2,5)>="37.4")&&($E(ElementData2,2,5)<="37.6"))) ret = "-1"
		;s:(($E(ElementData2,1,1)="Z")&&(($E(ElementData2,2,3)>="32")&&($E(ElementData2,2,3)<="37"))) ret = "-1"
		s:(ret=-1) ElementList=AElement1_"\"_Element2
		q:(ret=-1)
	}
	
	//C51-C58,N70-N77,N80-N98,O00-O99
	/*
	s:((ElementData2Str["A34")||(ElementData2Str["B37.3")) ret = "-1"
	s:((ElementData2Str["C79.6")||(ElementData2Str["D06")) ret = "-1"
	s:((ElementData2Str["D39")||(ElementData2Str["E28")) ret = "-1"
	s:((ElementData2Str["E89.4")||(ElementData2Str["F52.5")) ret = "-1"
	s:((ElementData2Str["F53")||(ElementData2Str["I86.3")) ret = "-1"
	s:((ElementData2Str["L29.2")||(ElementData2Str["M83.0")) ret = "-1"
	s:((ElementData2Str["P54.6")||(ElementData2Str["R87")) ret = "-1"
	s:((ElementData2Str["S31.4")||(ElementData2Str["T83.3")) ret = "-1"
	s:((ElementData2Str["Z01.4")||(ElementData2Str["Z12.4")) ret = "-1"
	s:((ElementData2Str["Z30.1")||(ElementData2Str["Z30.3")) ret = "-1"
	s:((ElementData2Str["Z30.5")||(ElementData2Str["Z39")) ret = "-1"
	s:((ElementData2Str["Z87.5")||(ElementData2Str["Z97.5")) ret = "-1"
	*/
	
	s ElementCode=""
    s:(ret=-1) ElementCode=##Class(EPRservice.Quality.DataAccess.BOQualityPool).GetElementCode(ElementList)
	q ret_"@"_ElementCode
}

/// CreatDate:	2020-01-20
/// Creator:	YK
/// Desc:		病案首页.12岁及以下儿童【出院诊断】不允许为"C50-C63"(乳房、女性及男性生殖器恶性肿瘤)。
/// Input:		AEpisodeID为患者就诊号;AElement1：性别，AElement2：出院诊断
/// Return:		ret<0:不一致; ret=1一致;
/// Debug:		w ##Class(EPRservice.Quality.EmrCheckRule.ConsistencyCheck).IsUnify0076(EpisodeID,"年龄code",{HISDiagCodes},"12","C5\C61\C62\C63")
ClassMethod IsUnify0076(AEpisodeID As %String, AElement1 As %String, AElement2 As %String, AValues1 As %String, ANoValues2 As %String, AElement3 As %String = "", AElement4 As %String = "") As %String
{
	s ret=0
	q:(AEpisodeID="")||(AElement1="")||(AElement2="")||(AValues1="")||(ANoValues2="") ret
    
	s ret=1 
	s ElementData1=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,AElement1,"")
	s:(ElementData1["岁") Age=+ElementData1
	s:(ElementData1'["岁") Age=0
	q:(Age>AValues1) ret
	
	///取需判断单元
	s ElementList=""
	for num=1:1:$l(AElement2,"\")
	{
		s Element2=$p(AElement2,"\",num)
		s ElementData2=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,Element2,"")
		continue:($tr(ElementData2,"-\—","")="")
		for j=1:1:$l(ANoValues2,"\") 
        {
			s Value2=$p(ANoValues2,"\",j)
			s:($e(ElementData2,1,$l(Value2))=Value2) ret=-1
			q:(ret=-1)
        }
        s:(ret=-1) ElementList=AElement1_"\"_Element2
        q:(ret=-1)
	}
	
	s ElementCode=""
    s:(ret=-1) ElementCode=##Class(EPRservice.Quality.DataAccess.BOQualityPool).GetElementCode(ElementList)
	q ret_"@"_ElementCode
}

/// CreatDate:	2020-01-20
/// Creator:	YK
/// Desc:		病案首页.【主要诊断】或【其他诊断】编码出现"O80-O84"，【其他诊断编码】必须有分娩结局编码Z37。
/// Input:		AEpisodeID为患者就诊号;AElement1：出院诊断,AValues：指定出现的诊断编码，AValue2：指定的另一个诊断编码
/// Return:		ret<0:不一致; ret=1一致;
/// Debug:		w ##class(EPRservice.Quality.EmrCheckRule.ConsistencyCheck).IsUnify0078(EpisodeID,{HISDiagCodes},"O80\O81\O82\O83\O84","Z37")
ClassMethod IsUnify0078(ArgEpisodeID As %String, AElements As %String, AValue1s As %String, AValue2 As %String)
{
	s ret=0
	q:(ArgEpisodeID="")||(AElements="")||(AValue1s="")||(AValue2="") ret
	
	///取首页诊断编码
	s ElementList="",flag1=0,flag2=0
	for I=1:1:$l(AElements,"\")
	{
		s Element=$p(AElements,"\",I)
		s ElementData=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(ArgEpisodeID,Element,"") 
		s ElementData=$tr(ElementData,"-\—","")
		continue:(ElementData="")
		s ElementData=$e(ElementData,1,3)
		
		if (flag1=0)
		{
			for J=1:1:$l(AValue1s,"\")
			{
				s Value1=$p(AValue1s,"\",J)
				continue:(ElementData'=Value1)
				s flag1=1
				s ElementList=Element
				q
			}
		}
		s:(ElementData=AValue2) flag2=1
		q:(flag1=1)&&(flag2=1)
	}
	
	s ret=1
	s:(flag1=1)&&(flag2=0) ret=-1
	
	s ElementCode=""
    s:(ret=-1) ElementCode=##Class(EPRservice.Quality.DataAccess.BOQualityPool).GetElementCode(ElementList)
	q ret_"@"_ElementCode
}

/// CreatDate:	2020-01-20
/// Creator:	YK
/// Desc:		病案首页.【病理诊断编码】中只允许填写以M开头并且中间带‘/’的ICD诊断。
/// Input:		AEpisodeID为患者就诊号;AElements：病理诊断
/// Return:		ret<0:不一致; ret=1一致;
/// Debug:		w ##class(EPRservice.Quality.EmrCheckRule.ConsistencyCheck).IsUnify0073(EpisodeID,"病理诊断code")
ClassMethod IsUnify0073(AEpisodeID As %String, AElement As %String) As %String
{
	s ret=0
	q:(AEpisodeID="")||(AElement="") ret
	
	s ret=1
	///取病理诊断编码
	s ElementData=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,AElement,"") 
	s ElementData=$tr(ElementData,"-\—","")
	q:(ElementData="") ret
	
	s:($e(ElementData,1,1)'="M")||(ElementData'["/") ret=-1
	
	s ElementCode=""
    s:(ret=-1) ElementCode=##Class(EPRservice.Quality.DataAccess.BOQualityPool).GetElementCode(AElement)
	q ret_"@"_ElementCode
}

/// CreatDate:	2020-01-20
/// Creator:	YK
/// Desc:		病案首页.【麻醉方式】不为空，且非局麻时，【麻醉费】不能为"0"，请检查。
/// Input:		AEpisodeID为患者就诊号;AElementIDs：麻醉方式, AElementID：麻醉费
/// Return:		ret<0:不一致; ret=1一致;
/// Debug:		w ##class(EPRservice.Quality.EmrCheckRule.ConsistencyCheck).IsUnify0079(EpisodeID,"麻醉方式1code\麻醉方式2code","局","麻醉费code")
ClassMethod IsUnify0079(AEpisodeID As %String, AElementIDs As %String, ANoValue As %String, AElementID As %String)
{
	s ret=0
	q:(AEpisodeID="")||(AElementIDs="")||(ANoValue="")||(AElementID="") ret
	
	s flag=0,ElementList=""
	for I=1:1:$l(AElementIDs,"\")
	{
		s ElementID1=$p(AElementIDs,"\",I)
		s ElementData1=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,ElementID1,"")
		continue:($tr(ElementData1,"-\—\ ","")="") 
		s:(ElementData1'[ANoValue) flag=1
		s:(flag=1) ElementList=ElementID1
		q:(flag=1)
	}
	q:(flag=0)
	
	s ElementData=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,AElementID,"")
	s:(+ElementData<=0) ret=-1
	
	s ElementCode=""
    s:(ret=-1) ElementCode=##Class(EPRservice.Quality.DataAccess.BOQualityPool).GetElementCode(ElementList_"\"_AElementID)
	q ret_"@"_ElementCode
}

/// CreatDate:	2020-01-20
/// Creator:	YK
/// Desc:		病案首页.有【血费】时【ABO血型】不允许填写"不详和未查"，请检查。
///             病案首页.有【血费】时【Rh血型】不允许填写"不详和未查"，请检查。
/// Input:		AEpisodeID为患者就诊号;AElements：出院诊断
/// Return:		ret<0:不一致; ret=1一致;
/// Debug:		w ##class(EPRservice.Quality.EmrCheckRule.ConsistencyCheck).IsUnify0080(EpisodeID,"血费code","ABO血型code","不详\未查")
///             w ##class(EPRservice.Quality.EmrCheckRule.ConsistencyCheck).IsUnify0080(EpisodeID,"血费code","RH血型code","不详\未查")
ClassMethod IsUnify0080(AEpisodeID As %String, AElement1 As %String, AElement2 As %String, ANoValues As %String)
{
	s ret=0
	q:(AEpisodeID="")||(AElement1="")||(AElement2="")||(ANoValues="") ret
	
	s ElementData1 = ##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,AElement1,"")
	q:(+ElementData1=0) ret
	
	s ElementData2 = ##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,AElement2,"")
	s:(ANoValues[ElementData2) ret=-1
	
	s ElementCode=""
    s:(ret=-1) ElementCode=##Class(EPRservice.Quality.DataAccess.BOQualityPool).GetElementCode(AElement1_"\"_AElement2)
	q ret_"@"_ElementCode
}

/// CreatDate:	2021-06-22
/// Creator:	GY
/// Desc:		病案首页.请按顺序填写【诊断/手术】信息。
/// Input:		AElement1:质控单元[诊断(名称)编码/手术(名称)编码]rowid 
/// Return:		ret<0:不一致; ret=1一致;
/// d ##class(EPRservice.Quality.EmrCheckRule.ConsistencyCheck).IsUnify06(EpisodeID,"10313") 
ClassMethod IsUnify0087(AEpisodeID As %String, AElements As %String) As %String
{
	s ret=0
	q:(AEpisodeID="")||(AElements="") ret
	
	s ret=1,ElementList=""
	for I=1:1:$l(AElements,"\")
	{
		s Element1=$P(AElements,"\",I)
		s Element2=$P(AElements,"\",I+1)
		q:(Element2="")
		
		s ElementData1=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,Element1,"")
		s ElementData1=$tr(ElementData1,"-\—\－","")
		s ElementData2=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,Element2,"") 
		s ElementData2=$tr(ElementData2,"-\—\－","")
		
		s:(ElementData1="")&&(ElementData2'="") ret=-1
		s:(ret=-1) ElementList=Element1_"\"_Element2
		q:(ret="-1")
	}
	
	s ElementCode=""
    s:(ret=-1) ElementCode=##Class(EPRservice.Quality.DataAccess.BOQualityPool).GetElementCode(ElementList)
	q ret_"@"_ElementCode
}

/// CreatDate:	2020-01-20
/// Creator:	YK
/// Desc:		病案首页.【门（急）诊诊断】【出院诊断编码】中不能出现"M"开头并且中间带‘/’的ICD编码。
/// Input:		AEpisodeID为患者就诊号;AElements：出院诊断
/// Return:		ret<0:不一致; ret=1一致;
/// Debug:		w ##class(EPRservice.Quality.EmrCheckRule.ConsistencyCheck).IsUnify0088(EpisodeID,{HISDiagCodes})
ClassMethod IsUnify0088(AEpisodeID As %String, AElements As %String) As %String
{
	s ret=0
	q:(AEpisodeID="")||(AElements="") ret
	
	s ret=1,ElementList=""
	for I=1:1:$l(AElements,"\")
	{
		s Element=$P(AElements,"\",I)
		s ElementData=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,Element,"")
		s ElementData=$tr(ElementData,"-\—\ ","")
		continue:(ElementData="")
		s:($e(ElementData,1,1)="M")&&(ElementData["/") ret=-1
		s:(ret=-1) ElementList=Element
		q:(ret="-1")
	}
	
	s ElementCode=""
    s:(ret=-1) ElementCode=##Class(EPRservice.Quality.DataAccess.BOQualityPool).GetElementCode(ElementList)
	q ret_"@"_ElementCode
}

/// CreatDate:	2020-01-20
/// Creator:	YK
/// Desc:		病案首页.出院诊断（主要诊断或次要诊断）中，"A54.0"与"N34.0或N75.1"不能同时存在，应编码为A54.1。
/// Input:		AEpisodeID为患者就诊号;
/// Return:		ret<0:不一致; ret=1一致;
/// Debug:		w ##class(EPRservice.Quality.EmrCheckRule.ConsistencyCheck).IsUnify0089(EpisodeID,{HISDiagCodes},"A54.0","N34.0^N75.1")
ClassMethod IsUnify0089(AEpisodeID As %String, AElements As %String, ADiagCode1 As %String, ADiagCode2 As %String) As %String
{
	s ret=0
	q:(AEpisodeID="")||(AElements="") ret
	
	s ret=1,flag1=0,flag2=0,ElementList=""
	for I=1:1:$l(AElements,"\")
	{
		s Element=$P(AElements,"\",I)
		s ElementData=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,Element,"")
		s ElementData=$tr(ElementData,"-\—\－","")
		continue:(ElementData="")
		
		if (ADiagCode1["-")
		{
		    s Diag01=$p(ADiagCode1,"-",1)
			s Code01=$e(Diag01,1,1)
			s Num01=$e(Diag01,2,$l(Diag01))
			s Diag02=$p(ADiagCode1,"-",2)
			s Code02=$e(Diag02,1,1)
			s Num02=$e(Diag02,2,$l(Diag02))
			
			s ElementCode=$e(ElementData,1,1)
			s ElementNum=$e(ElementData,2,$l(ElementData))
			s:(ElementCode=Code01)&&(ElementNum>=Num01)&&(ElementNum<=Num02) flag1=1
			s:(flag1=1)&&(ElementList'="") ElementList=ElementList_"\"_Element
			s:(flag1=1)&&(ElementList="") ElementList=Element
		}
		else
		{
		    for J=1:1:$L(ADiagCode1,"^")
			{
			    s DiagCode1=$p(ADiagCode1,"^",1)
			    s ElementCode1=$e(ElementData,1,$l(DiagCode1))
			    s:(ElementCode1=DiagCode1) flag1=1
			    s:(flag1=1)&&(ElementList'="") ElementList=ElementList_"\"_Element
			    s:(flag1=1)&&(ElementList="") ElementList=Element
				q:(flag1=1)
			}
		}
		
		if (ADiagCode2["-")
		{    
		    s Diag01=$p(ADiagCode2,"-",1)
			s Code01=$e(Diag01,1,1)
			s Num01=$e(Diag01,2,$l(Diag01))
			s Diag02=$p(ADiagCode2,"-",2)
			s Code02=$e(Diag02,1,1)
			s Num02=$e(Diag02,2,$l(Diag02))
			
			s ElementCode=$e(ElementData,1,1)
			s ElementNum=$e(ElementData,2,$l(ElementData))
			s:(ElementCode=Code01)&&(ElementNum>=Num01)&&(ElementNum<=Num02) flag2=1
			s:(flag2=1)&&(ElementList'="") ElementList=ElementList_"\"_Element
			s:(flag2=1)&&(ElementList="") ElementList=Element
		}
		else
		{
		    for K=1:1:$l(ADiagCode2,"^")
			{
			    s DiagCode2=$p(ADiagCode2,"^",1)
			    s ElementCode2=$e(ElementData,1,$l(DiagCode2))
			    s:(ElementCode2=DiagCode2) flag2=1
			    s:(flag2=1)&&(ElementList'="") ElementList=ElementList_"\"_Element
			    s:(flag2=1)&&(ElementList="") ElementList=Element
				q:(flag2=1)
			}
		}
		
		s:(flag1=1)&&(flag2=1) ret=-1
		q:(ret=-1)
	}
	
	s ElementCode=""
    s:(ret=-1) ElementCode=##Class(EPRservice.Quality.DataAccess.BOQualityPool).GetElementCode(ElementList)
	q ret_"@"_ElementCode
}

/// CreatDate:	2020-01-20
/// Creator:	YK
/// Desc:		病案首页.当手术编码出现02.9301,02.9303时，必须同时编码86.9401-86.9801中的一条
/// Input:		AEpisodeID为患者就诊号;
/// Return:		ret<0:不一致; ret=1一致;
/// Debug:		w ##class(EPRservice.Quality.EmrCheckRule.ConsistencyCheck).IsUnify0090(EpisodeID,{HISOperCodes},"02.9301^02.9303","86.9401-86.9801")
ClassMethod IsUnify0090(AEpisodeID As %String, AElements As %String, AOperCode1 As %String, AOperCode2 As %String) As %String
{
	s ret=0
	q:(AEpisodeID="")||(AElements="") ret
	
	s ret=1,flag1=0,flag2=0,ElementList=""
	for I=1:1:$l(AElements,"\")
	{
		s Element=$P(AElements,"\",I)
		s ElementData=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,Element,"")
		s ElementData=$tr(ElementData,"-\—\","")
		continue:(ElementData="")
		s ElementCode=$p(ElementData,".",1)
		s ElementNum=$e(ElementData,".",2)
		
		for J=1:1:$L(AOperCode1,"^")
		{
		    s OperCode1=$p(AOperCode1,"^",1)
		    if (OperCode1["-")
			{
			    s OperCode01=$p(OperCode1,"-",1)
				s Code01=$p(OperCode01,".",1)
				s Num01=$e($p(OperCode01,".",2),1,2)
				
				s OperCode02=$p(OperCode1,"-",2)
				s Code02=$p(OperCode02,".",1)
				s Num02=$e($p(OperCode02,".",2),1,2)
				s:(ElementCode=Code01)&&(ElementNum>=Num01)&&(ElementNum<=Num02) flag1=1
				s:(flag1=1)&&(ElementList'="") ElementList=ElementList_"\"_Element
				s:(flag1=1)&&(ElementList="") ElementList=Element
			}
			else
			{
			    s ElementCode1=$e(ElementData,1,$l(OperCode1))
				s:(ElementCode1=OperCode1) flag1=1
				s:(flag1=1)&&(ElementList'="") ElementList=ElementList_"\"_Element
				s:(flag1=1)&&(ElementList="") ElementList=Element
			}
			q:(flag1=1)
		}
		
		for K=1:1:$L(AOperCode2,"^")
		{
		    s OperCode2=$p(AOperCode2,"^",1)
		    if (OperCode2["-")
			{
			    s OperCode01=$p(OperCode2,"-",1)
				s Code01=$p(OperCode01,".",1)
				s Num01=$e($p(OperCode01,".",2),1,2)
				
				s OperCode02=$p(OperCode2,"-",2)
				s Code02=$p(OperCode02,".",1)
				s Num02=$e($p(OperCode02,".",2),1,2)
				s:(ElementCode=Code01)&&(ElementNum>=Num01)&&(ElementNum<=Num02) flag2=1
				s:(flag2=1)&&(ElementList'="") ElementList=ElementList_"\"_Element
				s:(flag2=1)&&(ElementList="") ElementList=Element
			}
			else
			{
			    s ElementCode2=$e(ElementData,1,$l(OperCode2))
				s:(ElementCode2=OperCode2) flag2=1
				s:(flag2=1)&&(ElementList'="") ElementList=ElementList_"\"_Element
				s:(flag2=1)&&(ElementList="") ElementList=Element
			}
			q:(flag2=1)
		}
		
		s:(flag1=1)&&(flag2=0) ret=-1
		q:(ret=-1)
	}
	
	s ElementCode=""
    s:(ret=-1) ElementCode=##Class(EPRservice.Quality.DataAccess.BOQualityPool).GetElementCode(ElementList)
	q ret_"@"_ElementCode
}

/// CreatDate:	2021-06-23
/// Creator:	GY
/// Hospital:   安徽蚌埠第二医院
/// Desc:		【入院时情况】填写"危"，请到<病案首页附页>中填写【抢救次数】和【抢救成功次数】，若患者无抢救需填写"-"。
/// Input:		AEpisodeID为患者就诊号;AElementID 入院时情况，AElementIDs 抢救次数、抢救成功次数
/// Return:		ret<0:不一致; ret=1一致;
/// Debug:      ##class(EPRservice.Quality.EmrCheckRule.ConsistencyCheck).IsUnify0091(EpisodeID,"入院时情况code","危","抢救次数code\成功次数code")
ClassMethod IsUnify0091(AEpisodeID As %String, AElementID As %String, AValue As %String, AElementIDs As %String, ANoValues As %String = "") As %String
{
	s ret=0
	q:(AEpisodeID="")||(AElementID="")||(AElementIDs="") ret
	
	s ret=1
	s ElementData=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,AElementID,"")
	q:(ElementData'=AValue) ret
	
	for I=1:1:$l(AElementIDs,"\")
	{
		s ElementID=$p(AElementIDs,"\",I)
		s tmpElementData=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,ElementID,"")
		continue:($tr(tmpElementData,ANoValues,"")'="")
		s ret=-1
		q
	}
	
	s ElementCode=""
    s:(ret=-1) ElementCode=##Class(EPRservice.Quality.DataAccess.BOQualityPool).GetElementCode(AElementID_"\"_AElementIDs)
	q ret_"@"_ElementCode
}

/// CreatDate:	2021-06-23
/// Creator:	GY
/// Hospital:   广州增城区中医院
/// Desc:		当费用中的【医疗机构中药制剂费】为"0"元时，【中药医疗机构中药制剂】需选择"2.否"。
/// Input:		AEpisodeID为患者就诊号;AElementID1 医疗机构中药制剂费，AElementID2 中药医疗机构中药制剂，AValues "否"
/// Return:		ret<0:不一致; ret=1一致;
/// Debug:      ##class(EPRservice.Quality.EmrCheckRule.ConsistencyCheck).IsUnify0092(EpisodeID,"医疗机构中药制剂费code","中药医疗机构中药制剂code","否")
ClassMethod IsUnify0092(AEpisodeID As %String, AElementID1 As %String, AElementID2 As %String, AValues As %String) As %String
{
	s ret=0
	q:(AEpisodeID="")||(AElementID1="")||(AElementID2="") ret
	
	s ret=1
	s ElementData1=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,AElementID1,"")
	q:(ElementData1'=0) ret
	
	s ElementData2=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,AElementID2,"")
	s ret=-1
	for I=1:1:$l(AValues,"\")
	{
	    s Value=$p(AValues,"\",I)
		continue:(ElementData2'=Value)
		s ret=1
		q
	}
	
	s ElementCode=""
    s:(ret=-1) ElementCode=##Class(EPRservice.Quality.DataAccess.BOQualityPool).GetElementCode(AElementID1_"\"_AElementID2)
	q ret_"@"_ElementCode
}

/// CreatDate:	2021-06-23
/// Creator:	GY
/// Hospital:   青海西宁大通、佳大四院
/// Desc:       有"死亡"医嘱，【离院方式】必须是"死亡"/有"呼吸机医嘱"，附页中【呼吸机使用时间】必填
/// Input:      AOrderDate 医嘱时间(取公共函数)，AElementIDs 离院方式/呼吸机使用时间，AValue "死亡"或空
/// Debug:      ##class(EPRservice.Quality.EmrCheckRule.ConsistencyCheck).IsUnify0093(EpisodeID,{HISOrdTime},"呼吸机使用时间code")
ClassMethod IsUnify0093(AEpisodeID As %String, AOrderDate As %String, AElementIDs As %String, AValue As %String = "") As %String
{
	s ret=0
	q:(AEpisodeID="")||(AOrderDate="")||(AElementIDs="") ret
	
	s ret=1
	for I=1:1:$l(AElementIDs,"\")
	{
	    s ElementID=$p(AElementIDs,"\",I)
		s ElementData=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,ElementID,"")
		s ElementData=$tr(ElementData,"-\—","")
		continue:(AValue'="")&&(ElementData=AValue)
		continue:(AValue="")&&(ElementData'="")
		s ret=-1
		q
	}
	
	s ElementCode=""
    s:(ret=-1) ElementCode=##Class(EPRservice.Quality.DataAccess.BOQualityPool).GetElementCode(AElementIDs)
	q ret_"@"_ElementCode
}

/// CreatDate:	2021-06-23
/// Creator:	GY
/// Hospital:   南昌二院
/// Desc:      【血费】大于"0"，附页上【输血反应】必须填"1.有"或"2.无"，不能填"0.未输"或空。
/// Input:      AElementID1 血费元素ID，AElementID2 输血反应元素ID，AValue 元素2填写符合值(是或否)
/// Debug:      ##class(EPRservice.Quality.EmrCheckRule.ConsistencyCheck).IsUnify0094(EpisodeID,"血费code","输血反应code","有\无")
ClassMethod IsUnify0094(AEpisodeID As %String, AElementID1 As %String, AElementID2 As %String, AValues As %String) As %String
{
	s ret=0
	q:(AEpisodeID="")||(AElementID1="")||(AElementID2="")||(AValues="") ret
	
	s ret=1
	s ElementData1=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,AElementID1,"")
	q:(+ElementData1=0) ret
	
	s ElementData2=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,AElementID2,"")
	
	s ret=-1
	for I=1:1:$l(AValues,"\")
	{
		s Value=$p(AValues,"\",I)
		continue:(ElementData2'=Value)
		s ret=1
		q
	}
	
	s ElementCode=""
    s:(ret=-1) ElementCode=##Class(EPRservice.Quality.DataAccess.BOQualityPool).GetElementCode(AElementID1_"\"_AElementID2)
	q ret_"@"_ElementCode
}

/// CreatDate:	2021-06-23
/// Creator:	GY
/// Hospital:   南昌二院
/// Desc:      【麻醉费】和【中医治疗费】都大于"0"时，【手术及操作】部分至少有两条数据。
/// Input:      AElementID1 麻醉费元素ID，AElementID1 中医治疗费元素ID， AElementIDs 手术及操作名称元素ID（名称1元素ID\名称2元素ID）
/// Debug:      ##class(EPRservice.Quality.EmrCheckRule.ConsistencyCheck).IsUnify0095(EpisodeID,"麻醉费code","中医治疗费code","手术及操作名称1code\手术及操作名称2code")
ClassMethod IsUnify0095(AEpisodeID As %String, AElementID1 As %String, AElementID2 As %String, AElementIDs As %String) As %String
{
	s ret=0
	q:(AEpisodeID="")||(AElementID1="")||(AElementID2="")||(AElementIDs="") ret
	
	s ret=1
	s ElementData1=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,AElementID1,"")
	q:(+ElementData1=0) ret
	
	s ElementData2=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,AElementID2,"")
	q:(+ElementData2=0) ret
	
	s ret=1
	for I=1:1:$l(AElementIDs,"\")
	{
		s ElementID=$p(AElementIDs,"\",I)
		s ElementData=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,ElementID,"")
		s:($tr(ElementData,"-\—","")="") ret=-1
		q:(ret=-1)
	}
	
	s ElementCode=""
    s:(ret=-1) ElementCode=##Class(EPRservice.Quality.DataAccess.BOQualityPool).GetElementCode(AElementID1_"\"_AElementID2_"\"_AElementIDs)
	q ret_"@"_ElementCode
}

/// CreatDate:	2021-06-23
/// Creator:	GY
/// Hospital:   南昌二院
/// Desc:       结算中心没有最终结算打印发票，病案首页不能打印
/// Input:      AEpisodeID 就诊ID
/// Debug:      ##class(EPRservice.Quality.EmrCheckRule.ConsistencyCheck).IsUnify0096(EpisodeID)
ClassMethod IsUnify0096(AEpisodeID As %String) As %String
{
	s ret=0
	q:(AEpisodeID="") ret
	
	s ret=1
	s IsSettle=""
	s IsSettle = $p($g(^PAADM(+AEpisodeID)),"^",100)  ///最终打印发票 PAADM_BillFlag

	s:(IsSettle'="Y") ret=-1
	
	q ret
}

/// CreatDate:	2021-06-23
/// Creator:	GY
/// Hospital:   南昌二院
/// Desc:      【总费用】与"发票总费用"不一致，不能打印。
/// Input:      AEpisodeID 就诊ID，AElementID 总费用，ASettleFee 发票总费用(取公共函数接口)
///            {SettleFeeData} ##class(BILL.Interface.Inside.Method).GetIPChgAmountByAdm(EpisodeID,"")
/// Debug:     ##class(EPRservice.Quality.EmrCheckRule.ConsistencyCheck).IsUnify0097(EpisodeID,"总费用code",{SettleFeeData})
ClassMethod IsUnify0097(AEpisodeID As %String, AElementID As %String, ASettleFee As %String) As %String
{
	s ret=0
	q:(AEpisodeID="")||(AElementID="") ret
	
	s ret=1
	s ElementData=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,AElementID,"")
	s:(ElementData'=AFeeData) ret=-1
	
	s ElementCode=""
    s:(ret=-1) ElementCode=##Class(EPRservice.Quality.DataAccess.BOQualityPool).GetElementCode(AElementID)
	q ret_"@"_ElementCode
}

/// CreatDate:	2021-06-23
/// Creator:	GY
/// Hospital:   内蒙古包钢医院
/// Desc:       6个【输血品种】(红细胞、白细胞、血小板、血浆、全血、自体回输)，只能录入纯数值，不能录入单位。
/// Input:      AEpisodeID 就诊ID，AElementIDs 红细胞、白细胞、血小板、血浆、全血、自体回输
/// Debug:     ##class(EPRservice.Quality.EmrCheckRule.ConsistencyCheck).IsUnify0098(EpisodeID,"红细胞\code白细胞\code血小板\code血浆\code全血\code自体回输code")
ClassMethod IsUnify0098(AEpisodeID As %String, AElementIDs As %String) As %String
{
	s ret=0
	q:(AEpisodeID="")||(AElementIDs="") ret
	
	s ret=1
	for I=1:1:$l(AElementIDs,"\")
	{
		s ElementID=$p(AElementIDs,"\",I)
		s ElementData=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,ElementID,"")
		continue:($tr(ElementData,"-\—","")="")
		s:(+ElementCode<0) ret=-1
		q:(ret=-1)
		
		s ElementCode=$a(ElementData)
		s:(ElementCode<48)||(ElementCode>57) ret=-1
		q:(ret=-1)
	}
	
	s ElementCode=""
    s:(ret=-1) ElementCode=##Class(EPRservice.Quality.DataAccess.BOQualityPool).GetElementCode(AElementIDs)
	q ret_"@"_ElementCode
}

/// CreatDate:	2020-01-20
/// Creator:	YK
/// Desc:		病案首页附页未填写，则不允许打印病案首页。
/// Input:		AEpisodeID为患者就诊号;
/// Return:		ret<0:不一致; ret=1一致;
/// Debug:		w ##class(EPRservice.Quality.EmrCheckRule.ConsistencyCheck).IsUnify0099(EpisodeID,"附页DocID","附页TemplateID")
ClassMethod IsUnify0099(AEpisodeID As %String, ATemplateDocID As %String, ATemplateID As %String) As %String
{
	s ret=0
	q:(AEpisodeID="")||(ATemplateDocID="")||(ATemplateID="") ret
	
	s ret=1
	s ECRecordID=""
	s ECRecordID=$o(^DHCEMRI.ECRecordI("IdxEpisodeIDChartItemID"," "_AEpisodeID," "_ATemplateDocID,""))
	s:(ECRecordID="") ret="-1"
	q:(ret=-1) ret
	
	s IsFinishDocument=$d(^DHCEMRI.InstanceDataI("IdxEcrecordTemplateStatus",ECRecordID," "_ATemplateID," SAVE"))
	s:(IsFinishDocument'="10") ret="-1"
	
	q ret
}

/// CreatDate:	2021-07-16
/// Creator:	GY
/// Desc:       【结构化元素1\结构化元素2\结构化元素3...】，不允许为"**"。
/// Input:		AEpisodeID 就诊号,AElementIDs 结构化元素(多个用"\"分隔)，AInstanceID 实例ID 用于可重复模板，AValue 空以外不允许填写的值 如:"-\—"
/// Return:     0 不用检查或配置错误, -1 触犯条目,1  符合条件 
/// Debug:      ##Class(EPRservice.Quality.EmrCheckRule.ConsistencyCheck).IsUnify0100(EpisodeID,"10010","","-\—")
ClassMethod IsUnify0100(AEpisodeID As %String, AElementIDs As %String, AInstanceID As %String, AValue As %String = "") As %String
{
	s ret=0
	q:(AEpisodeID="")||(AElementIDs="")||(AValue="") ret
	
	s ret=1,ElementList=""
	for I=1:1:$l(AElementIDs,"\")
	{
		s ElementID=$p(AElementIDs,"\",I)
		s ElementData=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,ElementID,AInstanceID)
		continue:($tr(ElementData,"-\—","")="")
		s ElementData=$tr(ElementData,AValue,"")
		continue:(ElementData'="")
		s ret=-1
		s:(ElementList'="") ElementList=ElementList_"\"_ElementID
		s:(ElementList="") ElementList=ElementID
	}
	
	s ElementCode=""
    s:(ret=-1) ElementCode=##Class(EPRservice.Quality.DataAccess.BOQualityPool).GetElementCode(ElementList)
    q ret_"@"_ElementCode
}

/// CreatDate:	2021-07-16
/// Creator:	GY
/// Desc:		病案首页.出院情况有一个为"死亡"，则全部应该为"死亡"
/// Input:		AEpisodeID为患者就诊号;AElementIDs 出院情况元素ID
/// Return:		ret<0:不一致; ret=1一致;
/// Debug:		w ##class(EPRservice.Quality.EmrCheckRule.ConsistencyCheck).IsUnify0101(EpisodeID,"","死亡")
ClassMethod IsUnify0101(AEpisodeID As %String, AElementIDs As %String, AValue As %String) As %String
{
	s ret=0
	q:(AEpisodeID="")||(AElementIDs="") ret
	
	s Num=0,Count=0,ret=1
	for I=1:1:$l(AElementIDs,"\")
	{
		s ElementID=$p(AElementIDs,"\",I)
		s ElementData=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,ElementID,"")
		continue:($tr(ElementData,"-\—","")="")
		s Count=count+1
		s:(ElementData=AValue) Num=Num+1
	}
	s:(Num>0)&&(Num'=Count) ret=-1
	
	s ElementCode=""
    s:(ret=-1) ElementCode=##Class(EPRservice.Quality.DataAccess.BOQualityPool).GetElementCode(AElementIDs)
    q ret_"@"_ElementCode
}

/// CreatDate:	2021-07-16
/// Creator:	GY
/// Desc:		病案首页.手术及有创操作类别为"手术",且【手术切口等级】为"III"时，【抗生素费用】应大于"0"。
/// Input:		AEpisodeID为患者就诊号;
/// Return:		ret<0:不一致; ret=1一致;
/// Debug:		w ##class(EPRservice.Quality.EmrCheckRule.ConsistencyCheck).IsUnify0102(EpisodeID,"","")
ClassMethod IsUnify0102(AEpisodeID As %String, AElementIDs As %String, AElementID As %String) As %String
{
	s ret=0
	q:(AEpisodeID="")||(AElementIDs="")||(AElementID="") ret
	
	s flag=0,ret=1
	for I=1:1:$l(AElementIDs,"#")
	{
		s ElementIDs=$p(AElementIDs,"#",I)
		s OperName=$p(ElementIDs,"\",1)
		s OperLevel=$p(ElementIDs,"\",2)
		s ElementOPName=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,OperName,"")
		continue:($tr(ElementOPName,"-\—","")="")
		s OPERType="",OPERRowId=""
		s OperDesc=$$ALPHAUP^SSUTIL4(ElementOPName)
		s OPERRowId=$O(^ORC("OPER",0,"Desc",OperDesc,OPERRowId)) 
		continue:(OPERRowId="")
		s OPERType=$p($g(^ORC("OPER",OPERRowId,"DHC")),"^",11)
		continue:(OPERType'="N")
		
		s ElementOPLevel=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,OperLevel,"")
		continue:(ElementOPLevel'="III")
		
		s flag=1
		q
	}
	q:(flag=0) ret
	
	s ElementData=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,AElementID,"")
	s:(+ElementData<=0) ret=-1
	
	s ElementCode=""
    s:(ret=-1) ElementCode=##Class(EPRservice.Quality.DataAccess.BOQualityPool).GetElementCode(AElementIDs_"\"_AElementID)
    q ret_"@"_ElementCode
}

/// CreatDate:	2021-07-16
/// Creator:	GY
/// Desc:		病案首页.患者本次就诊入过"重症医学科（ICU）"，则【入住重症监护病房】不能为"否"。
/// Input:		AEpisodeID为患者就诊号;
/// Return:		ret<0:不一致; ret=1一致;
/// Debug:		w ##class(EPRservice.Quality.EmrCheckRule.ConsistencyCheck).IsUnify0103(EpisodeID,"","否")
ClassMethod IsUnify0103(AEpisodeID As %String, AElementID As %String, AValue As %String) As %String
{
	s ret=0
	q:(AEpisodeID="")||(AElementID="")||(AValue="") ret
	
	s TransferInfos=""
	s TransferInfos=##Class(EMRservice.HISInterface.PatientInfoAssist).TransDeptDetail(AEpisodeID,"")
	q:(TransferInfos="")
	
	for I=1:1:$l(TransferInfos,"->")
	{
		s TransferInfo=$p(TransferInfos,"->",I)
		s DeptCode=$p(TransferInfo,"^",1)
		s DeptDesc=$p(TransferInfo,"^",2)
		s:(DeptDesc="重症医学科（ICU）")||(DeptCode=47) ret=-1
		q:(ret=-1)
	}
	q:(ret'="-1") ret
	
	s ElementData=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,AElementID,"")
	s:(ElementData'=AValue) ret=1
	
	s ElementCode=""
    s:(ret=-1) ElementCode=##Class(EPRservice.Quality.DataAccess.BOQualityPool).GetElementCode(AElementID)
    q ret_"@"_ElementCode
}

/// CreatDate:	2021-07-22
/// Creator:	GY
/// Desc:	   【现住址电话】应为11位数字(手机号码),或3到4位(区号位)+7到8位(电话位),区号位与电话为之间用"-"连接。
/// InPut:      AEpisodeID 就诊号; AElementID:电话单元编码，AValues：指定的位数（可以为多个用“\”分隔）
/// Return:     0 不用检查或配置错误, -1 触犯条目,1  符合条件 
/// Debug:      ##class(EPRservice.Quality.EmrCheckRule.ConsistencyCheck).IsUnify0104(EpisodeID,10024)
ClassMethod IsUnify0104(AEpisodeID As %String, AElementID As %String)
{
	
	s ret=0
	q:(AEpisodeID="")||(AElementID="") ret
	s ret=1 
	s ElementData=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,AElementID,"")
	q:($tr(ElementData,"-\—","")="") ret
	s flag=$MATCH(ElementData,"1(3|4|5|6|7|8|9)\d{9}|0\d{2,3}-[1-9]\d{6,7}\Z")
	s:flag=0 ret=-1
	
	s ElementCode=""
    s:(ret=-1) ElementCode=##Class(EPRservice.Quality.DataAccess.BOQualityPool).GetElementCode(AElementID)
    q ret_"@"_ElementCode
}

/// CreatDate:	2021-08-06
/// Creator:	GY
/// Desc:	   【出院诊断疾病编码】属于医保灰码：
/// InPut:      AEpisodeID 就诊号; AElementIDs:出院诊断疾病名称元素RowID(多个用"\"分隔)
/// Return:     0 不用检查或配置错误, -1 触犯条目,1  符合条件 
/// Debug:	##class(EPRservice.Quality.EmrCheckRule.ConsistencyCheck).IsUnify0105(EpisodeID,"疾病名称code")
ClassMethod IsUnify0105(AEpisodeID As %String, AElementIDs As %String) As %String
{
	s ret=0
	q:(AEpisodeID="")||(AElementIDs="") ret
	
	s ElementCodeStr="",ElementList=""
	for I=1:1:$l(AElementIDs,"\")
	{
		s ElementID=$p(AElementIDs,"\",I)
		s ElementData=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,ElementID,"") 
		s ElementData=$tr(ElementData,"-\—\ ","")
		continue:(ElementData="")
		
		s DiagName=$$ALPHAUP^SSUTIL4(ElementData)
		
		s MRCID=""
		s MRCID=$o(^MRC("ID",0,"Desc",DiagName,MRCID))
		continue:(MRCID="")
		s LongDesc=$p($g(^MRC("ID",MRCID)),"^",36)
		continue:(LongDesc'="医保灰码")
		
		s ret=-1
		s:(ElementCodeStr'="") ElementCodeStr=ElementCodeStr_","_DiagName
		s:(ElementCodeStr="") ElementCodeStr=DiagName
		
		s:(ElementList'="") ElementList=ElementList_"\"_ElementID
		s:(ElementList="") ElementList=ElementID
	}
	s:(ElementCodeStr'="") ret=ret_"^"_ElementCodeStr_"@"_ElementList
	q ret
}

/// CreatDate:	2021-08-06
/// Creator:	GY
/// Desc:	   【科别】若出现"ICU",【重症监护病房类型及时间(入/出/合计时常)】必填。
///      	   【手术信息栏】若出现"有创呼吸机治疗",则【有创呼吸机使用时间(天/小时/分钟)】至少有一个不为空。
/// InPut:      AEpisodeID 就诊号; AElementID1:条件元素RowID(多个用"\"分隔);AValue 条件值; AElementID2:判断结果元素RowID(多个用"\"分隔);AFlag 必填标志("ALL"全部必填、"ONE"填写一个即可)
/// Return:     0 不用检查或配置错误, -1 触犯条目,1  符合条件 
/// Debug:	##class(EPRservice.Quality.EmrCheckRule.ConsistencyCheck).IsUnify0106(EpisodeID,"科别code","ICU","重症监护病房类型code\时间code","ALL")
ClassMethod IsUnify0106(AEpisodeID As %String, AElementID1 As %String, AValue As %String, AElementID2 As %String, AFlag As %String) As %String
{
	s ret=0
   
	q:(AEpisodeID="")||(AElementID1="")||(AElementID2="") ret
	
	s ElementCodeStr="",ElementList=""
	for I=1:1:$l(AElementID1,"\")
	{
		s tmpElementID=$p(AElementID1,"\",I)
		s tmpElementData=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,tmpElementID,"") 
		s tmpElementData=$tr(tmpElementData,"-\—\ ","")
		continue:(tmpElementData="")||(tmpElementData'[AValue)
		s ElementList=tmpElementID
		
		s:(AFlag="ONE") ret=-1
		s:(AFlag="ALL") ret=1
		for J=1:1:$l(AElementID2,"\")
		{
			s ElementID=$p(AElementID2,"\",I)
			s ElementData=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,ElementID,"")
			if (AFlag="ONE")
			{
				continue:(ElementData="")
				s ret=1
				q
			}
			elseif (AFlag="ALL")
			{
				continue:(ElementData'="")
				s ret=-1
				q
			}
		}
		q:(AFlag="ONE")&&(ret=1)
		q:(AFlag="ALL")&&(ret=-1)
	}
	
	s:(ret=-1) ElementCode=ElementList_"\"_AElementID2
	q ret_"@"_ElementCode
}

/// CreatDate:	2021-08-24
/// Creator:	GY
/// Desc:	   【手术编码】属于医保灰码：
/// InPut:      AEpisodeID 就诊号; AElementIDs:手术及操作名称元素RowID(多个用"\"分隔)
/// Return:     0 不用检查或配置错误, -1 触犯条目,1  符合条件 
/// Debug:	    ##class(EPRservice.Quality.EmrCheckRule.ConsistencyCheck).IsUnify0107(EpisodeID,"名称code")
ClassMethod IsUnify0107(AEpisodeID As %String, AElementIDs As %String) As %String
{
	s ret=0
	q:(AEpisodeID="")||(AElementIDs="") ret
	
	s ElementCodeStr="",ElementList=""
	for I=1:1:$l(AElementIDs,"\")
	{
		s ElementID=$p(AElementIDs,"\",I)
		s ElementData=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,ElementID,"") 
		s ElementData=$tr(ElementData,"-\—\ ","")
		continue:(ElementData="")
		
		s OperName=$$ALPHAUP^SSUTIL4(ElementData)
		
		s OperID=""
		s OperID=$o(^ORC("OPER",0,"Desc",OperName,OperID))
		continue:(OperID="")
		s LongDesc=$p($g(^ORC("OPER",OperID)),"^",35)
		continue:(LongDesc'="医保灰码")
		
		s ret=-1
		s:(ElementCodeStr'="") ElementCodeStr=ElementCodeStr_","_OperName
		s:(ElementCodeStr="") ElementCodeStr=OperName
		
		s:(ElementList'="") ElementList=ElementList_"\"_ElementID
		s:(ElementList="") ElementList=ElementID
	}
	s:(ElementCodeStr'="") ret=ret_"^"_ElementCodeStr_"@"_ElementList
	q ret
}

/// CreatDate:	2021-09-03
/// Creator:	GY
/// Desc:	   【**元素】必须包含"***"内容
/// InPut:      AEpisodeID 就诊号; AElementID:元素RowID
/// Return:     0 不用检查或配置错误, -1 触犯条目,1  符合条件 
/// Debug:	    ##class(EPRservice.Quality.EmrCheckRule.ConsistencyCheck).IsUnify0108(EpisodeID,"元素code","中医诊断")
ClassMethod IsUnify0108(AEpisodeID As %String, AElementID As %String, AValue As %String) As %String
{
	s ret=0,flag=0
    
	q:(AEpisodeID="")||(AElementID="")||(AValue="") ret
    
    s ElementData=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,AElementID,"")
    q:($tr(ElementData,"-\—\ ","")="") ret
    
    s:(ElementData'[AValue) ret=-1
	
	s ElementCode=""
	s:(ret=-1) ElementCode=##Class(EPRservice.Quality.DataAccess.BOQualityPool).GetElementCode(AElementID)
	q ret_"@"_ElementCode
}

/// CreatDate:	2021-10-22
/// Creator:	GY
/// Desc:	   【身份证号】与患者实际性别不符(身份证号第"17"位为奇数表示"男",为偶数表示"女")
/// InPut:      AEpisodeID 就诊号; AElementID1:元素RowID; AElementID2:元素RowID
/// Return:     0 不用检查或配置错误, -1 触犯条目,1  符合条件 
/// Debug:	    ##class(EPRservice.Quality.EmrCheckRule.ConsistencyCheck).IsUnify0109(EpisodeID,"元素code","元素code")
ClassMethod IsUnify0109(AEpisodeID As %String, AElementID1 As %String, AElementID2 As %String) As %String
{
	s ret=0,flag=0
    
	q:(AEpisodeID="")||(AElementID1="")||(AElementID2="") ret
    
    ///性别
    s ElementData=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,AElementID1,"")
    q:($tr(ElementData,"-\—\ ","")="") ret
    
    ///身份证号码
    s IDCard=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,AElementID2,"")
    q:($tr(IDCard,"-\—\ ","")="") ret
    q:($l(IDCard)'=18) ret ///非18位身份证号码不判断
    
    s SexDR=($e(IDCard,17,17))#2
    s:(SexDR=0)&&(ElementData="男") ret=-1
    s:(SexDR=1)&&(ElementData="女") ret=-1
	
	s ElementCode=""
	s:(ret=-1) ElementCode=##Class(EPRservice.Quality.DataAccess.BOQualityPool).GetElementCode(AElementID1_"\"_AElementID2)
	q ret_"@"_ElementCode
}

/// CreatDate:	2021-10-22
/// Creator:	GY
/// Desc:	   【职业】为"无业人员"时【单位地址】及【电话】【邮编】不能填写。
/// InPut:      AEpisodeID 就诊号; AElementID:职业RowID;AValue:条件元素的值 AElementIDs:单位地址code\电话code\邮编RowID
/// Return:     0 不用检查或配置错误, -1 触犯条目,1  符合条件 
/// Debug:      ##class(EPRservice.Quality.EmrCheckRule.ConsistencyCheck).IsUnify0110(EpisodeID,"职业","无业人员","单位地址\电话\邮编")
ClassMethod IsUnify0110(AEpisodeID As %String, AElementID As %String, AValue As %String, AElementIDs As %String) As %String
{
	s ret=0
	q:(AEpisodeID="")||(AElementID="")||(AElementIDs="") ret
	
	s ElementData=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,AElementID,"")
	q:(ElementData'=AValue) ret
	
	s ret=1
	for I=1:1:$l(AElementIDs,"\")
	{
		s ElementID=$p(AElementIDs,"\",I)
		s ElementData=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,ElementID,"")
		s ElementData=$tr(ElementData,"-\—\ ","")
		continue:(ElementData="")
		s ret=-1
		q
	}  
	
	s ElementCode=""
	s:(ret=-1) ElementCode=##Class(EPRservice.Quality.DataAccess.BOQualityPool).GetElementCode(AElementID_"\"_AElementIDs)
	q ret_"@"_ElementCode
}

/// CreatDate:	2021-10-22
/// Creator:	GY
/// Desc:	    【年龄】"3-14"岁，【职业】只能选"学生"
/// Input:      AEpisodeID为患者就诊号;AElementID1:年龄RowID;AValue:质控元素的值 
/// Return:     0 不用检查或配置错误 ; -1 触犯条目 ; 1  符合条件 
/// Debug:	    ##class(EPRservice.Quality.EmrCheckRule.ConsistencyCheck).IsUnify0111(EpisodeID,"年龄code","职业code","学生")
ClassMethod IsUnify0111(AEpisodeID As %String, AElementID1 As %String, AElementID2 As %String, AValue As %String) As %String
{
	s ret=0
	q:(AEpisodeID="")||(AElementID1="")||(AElementID2="") ret
	
	s ElementData1=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,AElementID1,"")
	q:(+ElementData1<3)||(+ElementData1>14) ret
	
	s ElementData2=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,AElementID2,"")
	s:(ElementData2'=AValue) ret=-1
	 
	s ElementCode=""
	s:(ret=-1) ElementCode=##Class(EPRservice.Quality.DataAccess.BOQualityPool).GetElementCode(AElementID1_"\"_AElementID2)
	q ret_"@"_ElementCode
}

/// CreatDate:	2021-10-25
/// Creator:	GY
/// Desc:	    【联系人姓名】与患者【姓名】相同时,【联系人关系】只能为"本人"
///             【联系人关系】为"本人",【联系人姓名】与患者【姓名】必须相同
/// Input:      AEpisodeID为患者就诊号;AElementIDs:"联系人姓名RowID\姓名RowID";AElementID:联系人关系RowID,AValue:"本人" 
/// Return:     0 不用检查或配置错误 ; -1 触犯条目 ; 1  符合条件 
/// Debug:	    ##class(EPRservice.Quality.EmrCheckRule.ConsistencyCheck).IsUnify0112(EpisodeID,"联系人姓名code\姓名code","联系人关系code","本人")
ClassMethod IsUnify0112(AEpisodeID As %String, AElementIDs As %String, AElementID As %String, AValue As %String) As %String
{
	s ret=0
	q:(AEpisodeID="")||(AElementIDs="")||(AElementID="") ret
	
	s ElementData1=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,$p(AElementIDs,"\",1),"")
	s ElementData1=$tr(ElementData1,"-\—\ ","")
	s ElementData2=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,$p(AElementIDs,"\",2),"")
	s ElementData2=$tr(ElementData2,"-\—\ ","")
	q:(ElementData1="")||(ElementData2="") ret
	
	s ret=1
	s ElementData=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,AElementID,"")
	s:(ElementData1=ElementData2)&&(ElementData'=AValue) ret=-1
	s:(ElementData=AValue)&&(ElementData1'=ElementData2) ret=-1
	
	s ElementCode=""
	s:(ret=-1) ElementCode=##Class(EPRservice.Quality.DataAccess.BOQualityPool).GetElementCode(AElementID_"\"_AElementIDs)
	q ret_"@"_ElementCode
}

/// CreatDate:	2022-02-21
/// Creator:	GY
/// Desc:	    【血费】>0，【输血反应】必填。
///             【血费】>0，输血相关信息【红细胞】【血小板】【血浆】【全血】【自体回输】(没有请划"-")。
/// Input:      AEpisodeID为患者就诊号;AElementID:"血费RowID\"; AElementIDs:输血反应RowID,AExtValue:不允许填写的值 
/// Return:     0 不用检查或配置错误 ; -1 触犯条目 ; 1  符合条件 
/// Debug:	    ##class(EPRservice.Quality.EmrCheckRule.ConsistencyCheck).IsUnify0113(EpisodeID,"血费code","输血反应code","未输")
///             ##class(EPRservice.Quality.EmrCheckRule.ConsistencyCheck).IsUnify0113(EpisodeID,"血费code","红细胞code\血小板code\血浆code\全血code\自体回输code","")
ClassMethod IsUnify0113(AEpisodeID As %String, AElementID As %String, AElementIDs As %String, AExtValue As %String) As %String
{
	s ret=0,ElementList=""
	q:(AEpisodeID="")||(AElementIDs="")||(AElementID="") ret
	
	if (AElementID'="")
	{
		s ElementData=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,AElementID,"")
		s ElementData=$tr(ElementData,"-\—\ ","")
		q:(+ElementData="0") ret
	}
	else
	{
		s BloodFee="",InPatFee=""
		s InPatFee=##class(EMRservice.HISInterface.PatientInfoAssist).InPatCostTrakCareSubNew(AEpisodeID,"")
		s BloodFee=$p($p(InPatFee,"!",21),"^",3)
		q:(+BloodFee="0") ret
	}
	
	for I=1:1:$l(AElementIDs,"\")
	{
		s ElementID=$p(AElementIDs,"\")
		s tmpElementData=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,ElementID,"")
		s:(AExtValue'="") tmpElementData=$tr(tmpElementData,AExtValue,"")
		continue:(tmpElementData'="")
		s ret=-1
		s ElementList=ElementID
		q
	}
	
	s ElementCode=""
	s:(ret=-1) ElementCode=##Class(EPRservice.Quality.DataAccess.BOQualityPool).GetElementCode(AElementID_"\"_ElementList)
	q ret_"@"_ElementCode
}

/// CreatDate:	2022-04-02
/// Creator:	GY
/// Desc:	   【入院途径】为"其他医疗机构转入",【转诊机构】必填不可填"-"。
/// Input:		AEpisodeID 就诊号,AElementID:入院途径rowid ,AElementIDs 转诊机构rowid
/// Return:     0 不用检查或配置错误, -1 触犯条目,1  符合条件
/// Debug:      ##class(EPRservice.Quality.EmrCheckRule.ConsistencyCheck).IsUnify0114(EpisodeID,"入院途径code","其他医疗机构转入","转诊机构code")
ClassMethod IsUnify0114(AEpisodeID As %String, AElementID As %String, AValue As %String, AElementIDs As %String) As %String
{
	s ret=0
	q:(AEpisodeID="")||(AElementID="")||(AElementIDs="") ret
	
	s ElementData=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,AElementID,"")
	q:(ElementData'=AValue) ret
	
	s ret=1,ElementList=""
	for I=1:1:$l(AElementIDs,"\")
	{
		s ElementID=$P(AElementIDs,"\",I)
		s ElementData=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,ElementID,"")
		s ElementData=$tr(ElementData,"-\—\－","")
		continue:(ElementData'="")
		s ret=-1
		s:(ElementList'="") ElementList=ElementList_"\"_ElementID
		s:(ElementList="") ElementList=ElementID
		q
	}
	
	s ElementCode=""
    s:(ret=-1) ElementCode=##Class(EPRservice.Quality.DataAccess.BOQualityPool).GetElementCode(AElementID_"\"_ElementList)
    
	q ret_"@"_ElementCode
}

/// CreatDate:	2022-04-02
/// Creator:	GY
/// Desc:	   【年龄】不足60岁的"非老年病人",【诊断编码】不能填"60","G30.100x001\G30.100x002+F00.1*\G30.100x003+F00.1*"阿尔茨海默病(老年型)的相关诊断编码。
/// Input:		AEpisodeID 就诊号,AElementID:年龄rowid ,AValueAge:年龄限制值, AElementIDs 诊断编码rowid, AValues 不可填写得诊断编码
/// Return:     0 不用检查或配置错误, -1 触犯条目,1  符合条件
/// Debug:      ##class(EPRservice.Quality.EmrCheckRule.ConsistencyCheck).IsUnify0115(EpisodeID,"年龄code","60","诊断编码code","G30.100x001\G30.100x002+F00.1*\G30.100x003+F00.1*")
ClassMethod IsUnify0115(AEpisodeID As %String, AElementID As %String, AValueAge As %String, AElementIDs As %String, AValues As %String) As %String
{
	s ret=0
	q:(AEpisodeID="")||(AElementID="")||(AElementIDs="") ret
	
	s ElementData=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,AElementID,"")
	s Age=""
	if (ElementData["岁") 
	{
		s Age=+ElementData
	}
	else
	{
		s Age=0
	}
	q:(Age>=AValueAge) ret
	
	s ret=1,ElementList=""
	for I=1:1:$l(AElementIDs,"\")
	{
		s ElementID=$P(AElementIDs,"\",I)
		s ElementData=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,ElementID,"")
		s ElementData=$tr(ElementData,"-\—\－","")
		continue:(ElementData="")
		for M=1:1:$l(AValues,"\")
		{
			s Value=$p(AValues,"\",M)
			s:($e(ElementData,1,$l(Value))=Value) ret=-1
			q:(ret=-1)
		}
		continue:(ret=1)
		s:(ElementList'="") ElementList=ElementList_"\"_ElementID
		s:(ElementList="") ElementList=ElementID
	}
	
	s ElementCode=""
    s:(ret=-1) ElementCode=##Class(EPRservice.Quality.DataAccess.BOQualityPool).GetElementCode(AElementID_"\"_ElementList)
    
	q ret_"@"_ElementCode
}

/// 病案首页所有的地址信息增加质控，必须包含省、市
/// Debug: w ##Class(EPRservice.Quality.EmrCheckRule.IntegrityCheck).IsUnify0116(EpisodeID,"现住址code","省\市")
/// w ##Class(EPRservice.Quality.EmrCheckRule.ConsistencyCheck).IsUnify0116(1532979,10710,"省\市")
ClassMethod IsUnify0116(AEpisodeID As %String, AElement As %String, AValues As %String) As %String
{
	s ret = 0
	q:((AEpisodeID = "")||(AElement = "")||(AValues="")) ret

    s Elementdata=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,AElement,"")
	s Elementdata=$tr(Elementdata,"—\-\ ","")

	q:Elementdata="" ret
	s flag=0
	s ret=1
	for i=1:1:$l(AValues,"\")
    {
	    s AValue=$p(AValues,"\",i)
	    q:AValue=""
	    s:(Elementdata[AValue) flag=flag+1
    }
    s:(flag'=$l(AValues,"\")) ret="-1"
    
    s ElementCode=""
    s:(ret=-1) ElementCode=##Class(EPRservice.Quality.DataAccess.BOQualityPool).GetElementCode(AElement)
    
	q ret_"@"_ElementCode
}

/// CreatDate:	2023-02-07
/// Creator:	GY
/// Desc:	    【离院方式】为"死亡"，全部诊断【治疗结果】必须填"死亡"。
/// Input:		AEpisodeID 就诊号; AElementID 离院方式单元rowid; AValue AElementID符合的值("死亡");AElementIDs 治疗结果单元rowid集合(用"\"分隔)
/// Return:     0 不用检查或配置错误, -1 触犯条目,1  符合条件  
/// Debug:      ##class(EPRservice.Quality.EmrCheckRule.ConsistencyCheck).IsUnify0117(EpisodeID,"离院方式code","死亡",{ElementDiagRes})
ClassMethod IsUnify0117(AEpisodeID As %String, AElementID As %String, AValue As %String, AElementIDs As %String) As %String
{
	s ret=0
	q:(AEpisodeID="")||(AElementID="")||(AElementIDs="") ret
	
	s ElementData=""
	s ElementData = ##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,AElementID,"")  //离院方式
	q:(ElementData'=AValue) ret
	
	s ret=1,ElementList=""
	for I=1:1:$l(AElementIDs,"\")
	{
		s tmpElementID=$p(AElementIDs,"\",I)
		s tmpElementData = ##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,tmpElementID,"")
		s tmpElementData=$tr(tmpElementData,"-\—","")
		continue:(tmpElementData="")||(tmpElementData=AValue)
		s:(ElementList'="") ElementList=ElementList_"\"_tmpElementID
		s:(ElementList="") ElementList=tmpElementID
	}
	s:(ElementList'="") ret=-1
    
	s ElementCode=""
    s:(ret=-1) ElementCode=##Class(EPRservice.Quality.DataAccess.BOQualityPool).GetElementCode(AElementID_"\"_ElementList)
    
	q ret_"@"_ElementCode
}

/// CreatDate:	2023-02-07
/// Creator:	GY
/// Desc:	    【新生儿出生体重】"999g"以下与【疾病编码】"P07"或"P05"对应，请检查。
///             【新生儿出生体重】"1000g-1499g"与【疾病编码】"P07"或"P05"对应，请检查。
///             【新生儿出生体重】"1499g-2499g"以下与【疾病编码】"P07"或"P05"对应，请检查。
/// Input:		AEpisodeID 就诊号; AElementID 新生儿出生体重单元rowid; ARangeValue AElementID符合范围值("0-999");AElementIDs 疾病编码单元rowid集合(用"\"分隔); ADiagCodes 诊断编码符合要求编码("P05^P07")
/// Return:     0 不用检查或配置错误, -1 触犯条目,1  符合条件  
/// Debug:      ##class(EPRservice.Quality.EmrCheckRule.ConsistencyCheck).IsUnify0118(EpisodeID,"新生儿出生体重code","0-999",{ElementDiagRes},"P05^P07")
ClassMethod IsUnify0118(AEpisodeID As %String, AElementID As %String, ARangeValue As %String, AElementIDs As %String, ADiagCodes As %String) As %String
{
	s ret=0
	q:(AEpisodeID="")||(AElementID="")||(AElementIDs="") ret
	
	s ElementData="",MinValue="",MaxValue=""
	s ElementData = ##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,AElementID,"")  //离院方式
	s MinValue=$p(ARangeValue,"-",1)
	s MaxValue=$p(ARangeValue,"-",2)
	q:(ElementData<MinValue)||(ElementData>MaxValue) ret
	
	s ret=-1,ElementList=""
	for I=1:1:$l(AElementIDs,"\")
	{
		s tmpElementID=$p(AElementIDs,"\",I)
		s tmpElementData = ##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,tmpElementID,"")
		s tmpElementData=$tr(tmpElementData,"-\—","")
		continue:(tmpElementData="")
		
		s flag=0
		for M=1:1:$l(ADiagCodes,"^")
		{
			s DiagCode=$p(ADiagCodes,"^",M)
			s:($e(tmpElementData,1,$l(DiagCode)=DiagCode)) flag=1
			q:(flag=1)
		}
		s:(flag=1) ret=1
		q:(ret=1)
	}
	
	s ElementCode=""
    s:(ret=-1) ElementCode=##Class(EPRservice.Quality.DataAccess.BOQualityPool).GetElementCode(AElementID_"\"_AElementIDs)
    
	q ret_"@"_ElementCode
}

/// CreatDate:	2023-04-18
/// Creator:	GY
/// Desc:	    患者有手术，【手术信息】未填写，请检查。
/// Input:		AEpisodeID 就诊号; AElementIDs 手术名称单元rowid集合; ADateTime 手术申请单日期;
/// Return:     0 不用检查或配置错误, -1 触犯条目,1  符合条件  
/// Debug:      ##class(EPRservice.Quality.EmrCheckRule.ConsistencyCheck).IsUnify0119(EpisodeID,{HISOperCodes},{HISPatOPArranges})
ClassMethod IsUnify0119(AEpisodeID As %String, AElementIDs As %String, ADateTime As %String) As %String
{
	s ret=0
	q:(AEpisodeID="")||(ADateTime="")||(AElementIDs="") ret
	
	s ret=-1,ElementList=""
	for I=1:1:$l(AElementIDs,"\")
	{
		s ElementID=$p(AElementIDs,"\",I)
		s ElementData = ##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,ElementID,"")
		s ElementData=$tr(ElementData,"-\—","")
		continue:(ElementData="")
		s ret=1
		q
	}
	
	s ElementCode=""
    s:(ret=-1) ElementCode=##Class(EPRservice.Quality.DataAccess.BOQualityPool).GetElementCode(AElementIDs)
    
	q ret_"@"_ElementCode
}

/// CreatDate:	2023-04-18
/// Creator:	GY
/// Desc:	    病案首页.【术者】与<手术记录>中，填写不一致。
///     	    病案首页.【术者】与<手术同意书>中，填写不一致。
/// InPut:      AEpisodeID 就诊号,ASYElementIDs 首页手术名称术者ElementID集合(格式:名称code\术者code^名称code\术者code), ARecElementIDs 手术记录手术名称术者ElementID集合(格式:名称code\术者code),ADocID 手术记录DocID, ATitle 手术记录模板名称
/// Return:     0 不用检查或配置错误, -1 触犯条目,1  符合条件 
/// Debug:	    ##class(EPRservice.Quality.EmrCheckRule.ConsistencyCheck).IsUnify0120(EpisodeID,{SYOperCodes},{SSJLOperCodes},"","手术记录")
ClassMethod IsUnify0120(AEpisodeID As %String, ASYElementIDs As %String, ARecElementIDs As %String, ADocID As %String, ATitle As %String = "") As %String
{
	s ret=0
	q:(AEpisodeID="")||(ASYElementIDs="")||(ARecElementIDs="")||(ADocID="") ret
	
	s ret=1
	s SYElementData="" ///病案首页:"名称|术者#名称|术者"
	for I=1:1:$l(ASYElementIDs,"^")
	{
		s SYEleIDOper=$p($p(ASYElementIDs,"^",I),"\",1) //首页手术名称
		s SYEleIDUser=$p($p(ASYElementIDs,"^",I),"\",2) //首页术者
		s SYElementOper=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,SYEleIDOper,"")
		s SYElementUser=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,SYEleIDUser,"")
		continue:(SYElementOper="")&&(SYElementUser="")
		s:(SYElementData'="") SYElementData=SYElementData_"#"_SYElementOper_"|"_SYElementUser
		s:(SYElementData="") SYElementData=SYElementOper_"|"_SYElementUser
	}
	
	//手术记录实例ID
	s InstanceIDs=""
	s InstanceIDs=##Class(EPRservice.Quality.EmrCheckRule.Template).GetInstanceIDByDocID(AEpisodeID,ADocID,ATitle)
	q:(InstanceIDs="") ret
	
	s RecElementData="" ///手术记录:"名称|术者#名称|术者"
	for M=1:1:$l(ARecElementIDs,"^")
	{
		s RecEleIDOper=$p($p(ARecElementIDs,"^",M),"\",1) //手术记录手术名称
		s RecEleIDUser=$p($p(ARecElementIDs,"^",M),"\",2) //手术记录术者
		
		s RecElementOper="",RecElementUser=""
		for N=1:1:$l(InstanceIDs,"\")
		{
			s InstanceID=$p(InstanceIDs,"\",N)
			s RecElementOper=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,InstanceID,"")
			s RecElementUser=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,InstanceID,"")
			continue:(RecElementOper="")&&(RecElementUser="")
			s RecElementData=RecElementOper_"|"_RecElementUser
			continue:(SYElementData[RecElementData)
			s ret=-1
			q
		}
		continue:(ret=1)
		q
	}
	
	q ret
}

/// CreatDate:	2023-04-21
/// Creator:	GY
/// Desc:	    病案首页.【出院诊断疾病编码】为"O80-O84.0"(顺产)，对应【出院情况】只能为"其他"。
/// InPut:      AElementID1:诊断编码单元，AElementID2：出院情况单元，AValues；编码中指定包含的值，ArgExtValues：诊断例外,AQuaFlag 质控标志("="只能填写,"<>"不能填写)
/// Return:     0 不用检查或配置错误, -1 触犯条目,1  符合条件 
/// Test:       ##class(EPRservice.Quality.EmrCheckRule.ConsistencyCheck).IsUnify0121(EpisodeID,10332,"10111","O80\O81\O82\O83\O84.0","其他","=")
ClassMethod IsUnify0121(AEpisodeID As %String, AElementID1 As %String, AElementID2 As %String, AValues As %String, AExtValues As %String, AValue2 As %String, AQuaFlag As %String = "=")
{
	s ret=0
   
	q:(AEpisodeID="")||(AElementID1="")||(AElementID2="")||(AValues="") ret
	
	s ret=1
	for I=1:1:$l(AElementID1,"\")
	{
		s ElementID1=$p(AElementID1,"\",I)
		s ElementData1=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,ElementID1,"")
		s ElementData1=$tr(ElementData1,"-\—","")
		continue:(ElementData1="")
		
		s flag=0
		s Values=##Class(EPRservice.Quality.CommonHelper).GetListFromString(AValues,"\")
		s Ind=1
		for 
		{
			s Value=$listget(Values,Ind)
			q:Value=""
			s:($e(ElementData1,1,$l(Value))=Value) flag=1
			s Ind=Ind+1	
		}
		continue:(flag=0)
		
		s ExtValuels=##Class(EPRservice.Quality.CommonHelper).GetListFromString(AExtValues,"\")
		s ExtInd=1
		for 
		{
			s ExtValue=$listget(ExtValuels,ExtInd)
			q:ExtValue=""
			
			s:($e(ElementData1,1,$l(ExtValue))=ExtValue) flag=0
			s ExtInd=ExtInd+1
		}
		continue:(flag=0)
		
		s ElementID2=$p(AElementID2,"\",I)
		s ElementData2=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(ArgEpisodeID,ElementID2,"")
		s:(AQuaFlag="=")&&(ElementData2'=AValue2) ret=-1
		s:(AQuaFlag="<>")&&(ElementData2=AValue2) ret=-1
		continue:(ret=1)
		s ElementList=Element1_"\"_Element2
		q
	}
	
	s ElementCode=""
	s:(ret=-1) ElementCode=##Class(EPRservice.Quality.DataAccess.BOQualityPool).GetElementCode(ElementList)
	q ret_"@"_ElementCode
}

/// CreatDate:	2021-06-22
/// Creator:	GY
/// Desc:	   【抗菌药使用情况】只能选一个，不能选多个。
/// Input:		AEpisodeID 就诊号; AElement1  抗菌药使用情况单元rowid(这是一个多选单元)
/// Return:     0 不用检查或配置错误, -1 触犯条目,1  符合条件  
/// Debug:      ##class(EPRservice.Quality.EmrCheckRule.ConsistencyCheck).IsUnifyFY0001(EpisodeID,"条件单元code","=","条件值","结果单元","<>","结果值")
ClassMethod IsUnifyFY0001(AEpisodeID As %String, AElement1 As %String) As %String
{
		s ret=0
		q:(AEpisodeID="")||(AElement1="") ret
		
		s ret=1
		s ElementData1 = ##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,AElement1,"")
		s:($l(ElementData1,",")>1) ret=-1  
		
        s ElementCode=""
        s:(ret=-1) ElementCode=##Class(EPRservice.Quality.DataAccess.BOQualityPool).GetElementCode(AElement1)
        q ret_"@"_ElementCode
}

/// CreatDate:	2021-06-22
/// Creator:	GY
/// Desc:	    当AElement1等于(或不等)某值时，限制AElement2必须等于(或不等)某值
/// Input:		AEpisodeID 就诊号,AElement1:条件单元,isnt1("="或"<>"),AValue1:条件值,AElement2:结果单元,isnt2("="或"<>"),AValue2:限定结果值
/// Return:     0 不用检查或配置错误, -1 触犯条目,1  符合条件  
/// Debug:      ##class(EPRservice.Quality.EmrCheckRule.ConsistencyCheck).IsUnifyFY0002(EpisodeID,"条件单元code","=","条件值","结果单元","<>","结果值")
ClassMethod IsUnifyFY0002(AEpisodeID As %String, AElement1 As %String, isnt1 As %String, AValue1 As %String, AElement2 As %String, isnt2 As %String, AValue2 As %String) As %String
{
	s ret = 0
	q:((AEpisodeID = "")||(AElement1 = "")||(AElement2="")) ret
	
    s ElementData1=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,AElement1,"")
    s ElementData2=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,AElement2,"")
	s:(isnt1="<>")&&(AValue1="") ElementData1=$tr(ElementData1,"-\—","")
	s:(isnt2="<>")&&(AValue2="") ElementData2=$tr(ElementData2,"-\—","")
	
	s ret=1
    if (isnt1="=")
    {
    	q:(ElementData1'=AValue1) ret
	    s:(isnt2="=")&&(ElementData2'=AValue2) ret=-1
	    s:(isnt2="<>")&&(ElementData2=AValue2) ret=-1
    }
	elseif (isnt1="<>")
	{
		q:(ElementData1=AValue1) ret
		s:(isnt2="=")&&(ElementData2'=AValue2) ret=-1
	    s:(isnt2="<>")&&(ElementData2=AValue2) ret=-1
    }
	
    s ElementCode=""
    s:(ret=-1) ElementCode=##Class(EPRservice.Quality.DataAccess.BOQualityPool).GetElementCode(AElement1_"\"_AElement2)
    q ret_"@"_ElementCode
}

/// CreatDate:	2021-06-22
/// Creator:	GY
/// Desc:	    患者有"呼吸机医嘱"，则须完成<首页附页>
/// Input:		AEpisodeID 就诊号,AOrderInfo 呼吸机医嘱信息(不为空时质控), ADocID 附页展现结果模板ID ,ATemplateID 附页模板ID
/// Return:     0 不用检查或配置错误, -1 触犯条目,1  符合条件  
/// Debug:      ##class(EPRservice.Quality.EmrCheckRule.ConsistencyCheck).IsUnifyFY0003(EpisodeID,{HISORDInfo},"DocID","TemplateID")
ClassMethod IsUnifyFY0003(AEpisodeID As %String, AOrderInfo As %String, ADocID As %String, ATemplateID As %String) As %String
{
	
	s ret = 0
	q:(AEpisodeID = "")||(AOrderInfo="")||(ADocID="")||(ATemplateID="") ret
	
	s ret = 1
	
	///是否完成附页
	s ECRecordID=""
	s ECRecordID=$o(^DHCEMRI.ECRecordI("IdxEpisodeIDChartItemID"," "_AEpisodeID," "_ADocID,ECRecordID))
	q:(ECRecordID="") "-1"
	
	s IsFinishDocument=$d(^DHCEMRI.InstanceDataI("IdxEcrecordTemplateStatus",ECRecordID," "_ATemplateID," SAVE"))
	s:(IsFinishDocument'="10") ret=-1
	
	q ret
}

/// CreatDate:	2021-06-22
/// Creator:	GY
/// Desc:	    患者有"呼吸机医嘱"，则必须填写【呼吸机使用时间】
/// Input:		AEpisodeID 就诊号,AOrderInfo 呼吸机医嘱信息(不为空时质控), AElementIDs 呼吸机时间
/// Return:     0 不用检查或配置错误, -1 触犯条目,1  符合条件  
/// Debug:      ##class(EPRservice.Quality.EmrCheckRule.ConsistencyCheck).IsUnifyFY0004(EpisodeID,{HISORDInfo},"呼吸机时间code")                          
ClassMethod IsUnifyFY0004(AEpisodeID As %String, AOrderInfo As %String, AElementIDs As %String) As %String
{
	
	s ret = 0
	q:(AEpisodeID = "")||(AOrderInfo="")||(AElementIDs="") ret
	
	s ret = 1
	
	///呼吸机时间
	for I=1:1:$l(AElementIDs,"\")
	{
		s ElementID=$p(AElementIDs,"\",I)
		s ElementData=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,ElementID,"")
		s ElementData=$tr(ElementData,"-\—","")
		s:(ElementData="") ret="-1"
		q:(ret=-1)
	}
	
	s ElementCode=""
    s:(ret=-1) ElementCode=##Class(EPRservice.Quality.DataAccess.BOQualityPool).GetElementCode(AElementIDs)
    q ret_"@"_ElementCode
}

/// CreatDate:	2021-07-16
/// Creator:	GY
/// Desc:	    【麻醉方式】不为时，【手术后镇痛】必填
/// Input:	AEpisodeID为患者就诊号, AElementIDs1 条件元素ID集合, AElementIDs2 判断结果元素ID集合
/// Output:	ret=-1没填写; ret=1已填写; ret=0参数错误或无效;
/// Debug: ##Class(EPRservice.Quality.EmrCheckRule.ConsistencyCheck).IsUnifyFY0005(EpisodeID,"","","","","","")
ClassMethod IsUnifyFY0005(AEpisodeID As %String, AElementIDs1 As %String, Aisnt1 As %String, AValues1 As %String, AElementIDs2 As %String, Aisnt2 As %String, AValues2 As %String) As %String
{
	
	s ret = 0
	q:(AEpisodeID = "")||(AElementIDs1="")||(Aisnt1="")||(AElementIDs2="")||(Aisnt2="") ret
	
	s ret = 1
	
	s flag=0,ElementList=""
	for I=1:1:$l(AElementIDs1,"\")
	{
		s ElementID1=$p(AElementIDs1,"\",I)
		s ElementData1=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,ElementID1,"")
		
		for J=1:1:$l(AValues1,"\")
		{
			s Value1=$p(AValues1,"\",J)
			s:(Value1="") ElementData1=$tr(ElementData1,"-\—","")
			s:(Aisnt1="=")&&(ElementData1=Value1) flag=1
			s:(Aisnt1="<>")&&(ElementData1'=Value1) flag=1
			q:(flag1=1)
		}
		s:(flag=1) ElementList=ElementID1
		q:(flag=1)
	}
	q:(flag=0) ret
	
	for I=1:1:$l(AElementIDs2,"\")
	{
		s ElementID2=$p(AElementIDs2,"\",I)
		s ElementData2=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,ElementID2,"")
		
		if (Aisnt2="=") 
		{
			s ret=-1
			for J=1:1:$l(AValues2,"\")
			{
				s Value2=$p(AValues2,"\",J)
				s:(Value2="") ElementData2=$tr(ElementData2,"-\—","")
				s:(ElementData2=Value2) ret=1
				q:(ret=1)
			}
			s:(ret=-1) ElementList=ElementList_"\"_ElementID2
		}
		if (Aisnt2="<>") 
		{
			s ret=1
			for J=1:1:$l(AValues2,"\")
			{
				s Value2=$p(AValues2,"\",J)
				s:(Value2="") ElementData2=$tr(ElementData2,"-\—","")
				s:(ElementData2=Value2) ret=-1
				q:(ret=-1)
			}
			s:(ret=-1) ElementList=ElementList_"\"_ElementID2
		}
		q:(ret=-1)
	}
		
	s ElementCode=""
    s:(ret=-1) ElementCode=##Class(EPRservice.Quality.DataAccess.BOQualityPool).GetElementCode(ElementList)
    q ret_"@"_ElementCode
}

/// CreatDate:	2021-07-16
/// Creator:	GY
/// 抢救次数”减去“成功次数”值为0或1
/// Input:	AEpisodeID为患者就诊号, AElementID1 抢救次数元素ID集合, AElementID2 成功次数元素ID集合
/// Output:	ret=-1没填写; ret=1已填写; ret=0参数错误或无效;
/// Debug: ##Class(EPRservice.Quality.EmrCheckRule.ConsistencyCheck).IsUnifyFY0006(EpisodeID,"","","","死亡")
ClassMethod IsUnifyFY0006(AEpisodeID As %String, AElementID1 As %String, AElementID2 As %String) As %String
{
	
	s ret = 0
	q:(AEpisodeID = "")||(AElementID1="")||(AElementID2="") ret
	
	s ret = 1
	
	s ElementData1=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,AElementID1,"")
	s ElementData1=$tr(ElementData1,"-\—","")
	s ElementData2=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,AElementID2,"")
	s ElementData2=$tr(ElementData2,"-\—","")
	//q:(ElementData1="")||(ElementData2="") ret
	
	s num=""
	s num=(+ElementData1)-(+ElementData2)
	s:(num'=0)&&(num'=1) ret=-1
	
	s ElementCode=""
    s:(ret=-1) ElementCode=##Class(EPRservice.Quality.DataAccess.BOQualityPool).GetElementCode(AElementID1_"\"_AElementID2)
    q ret_"@"_ElementCode
}

/// CreatDate:	2021-07-16
/// Creator:	GY
/// 【输血情况】有任一项不为空且不为"0"时，【是否发生输血反应】不可填"未输"
/// Input:	AEpisodeID为患者就诊号, AElementIDs 抢救次数元素ID集合, AElementID 成功次数元素ID集合
/// Output:	ret=-1没填写; ret=1已填写; ret=0参数错误或无效;
/// Debug: ##Class(EPRservice.Quality.EmrCheckRule.ConsistencyCheck).IsUnifyFY0007(EpisodeID,"","","未输")
ClassMethod IsUnifyFY0007(AEpisodeID As %String, AElementIDs As %String, AElementID As %String, AValue As %String) As %String
{
	
	s ret = 0
	q:(AEpisodeID = "")||(AElementIDs="")||(AElementID="") ret
	
	s ret = 1
	s flag=0,ElementList=""
	for I=1:1:$l(AElementIDs,"\")
	{
		s ElementID=$p(AElementIDs,"\",I)
		s tmpElementData=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,ElementID,"")
		continue:(+tmpElementData=0)
		s ElementList=ElementID
		s flag=1
		q
	}
	q:(flag=0)
	
	s ElementData=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,AElementID,"")
	s:(ElementData=AValue) ret=-1
	s ElementList=ElementList_"\"_AElementID
	
	s ElementCode=""
    s:(ret=-1) ElementCode=##Class(EPRservice.Quality.DataAccess.BOQualityPool).GetElementCode(ElementList)
    q ret_"@"_ElementCode
}

/// CreatDate:	2021-07-16
/// Creator:	GY
/// 抢救次数”减去“成功次数”值为1,离院方式应为"死亡"
/// Input:	AEpisodeID为患者就诊号, AElementID1 抢救次数元素ID集合, AElementID2 成功次数元素ID集合
/// Output:	ret=-1没填写; ret=1已填写; ret=0参数错误或无效;
/// Debug: ##Class(EPRservice.Quality.EmrCheckRule.ConsistencyCheck).IsUnifyFY0006(EpisodeID,"","","","死亡")
ClassMethod IsUnifyFY0008(AEpisodeID As %String, AElementID1 As %String, AElementID2 As %String, AElementID3 As %String, AValue As %String) As %String
{
	
	s ret = 0
	q:(AEpisodeID = "")||(AElementID1="")||(AElementID2="") ret
	
	s ret = 1
	
	s ElementData1=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,AElementID1,"")
	s ElementData1=$tr(ElementData1,"-\—","")
	s ElementData2=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,AElementID2,"")
	s ElementData2=$tr(ElementData2,"-\—","")
	q:(ElementData1="")||(ElementData2="") ret
	
	s num=""
	s num=(+ElementData1)-(+ElementData2)
	
	if (num=1)
	{
		s ElementData3=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,AElementID3,"")
		s:(ElementData3'=AValue) ret=-1
	}
	
	s ElementCode=""
    s:(ret=-1) ElementCode=##Class(EPRservice.Quality.DataAccess.BOQualityPool).GetElementCode(AElementID1_"\"_AElementID2_"\"_AElementID3)
    q ret_"@"_ElementCode
}

/// CreatDate:	2021-07-16
/// Creator:	GY
/// 胎别判断新生儿情况填写
/// Input:	AEpisodeID为患者就诊号, AElementIDs1 胎别, AElementIDs2 新生儿情况信息
/// Output:	ret=-1没填写; ret=1已填写; ret=0参数错误或无效;
/// Debug: ##Class(EPRservice.Quality.EmrCheckRule.ConsistencyCheck).IsUnifyFY0009(EpisodeID,"","","")
ClassMethod IsUnifyFY0009(AEpisodeID As %String, AElementID As %String, AElementIDs As %String, AValues As %String) As %String
{
	
	s ret = 0
	q:(AEpisodeID = "")||(AElementID="")||(AElementIDs="") ret
	
	s ret = 1
	s ElementData=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,AElementID,"")
	q:($tr(ElementData,"-\—","")="") ret
	
	s num=0
	for I=1:1:$l(AValues,"\")
	{
		s Value=$p(AValues,"\",I)
		continue:(ElementData'=Value)
		s num=I
		q
	}
	q:(num=0) ret
	
	s ElementList=""
	for J=1:1:num
	{
		s ElementIDs=$p(AElementIDs,"#",J)
		for K=1:1:$l(ElementIDs,"\")
		{
			s ElementID=$p(ElementIDs,"\",K)
			s ElementData=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,ElementID,"")
			s ElementData=$tr(ElementData,"-\—","")
			s:(ElementData="") ret=-1
			s:(ret=-1)&&(ElementList'="") ElementList=ElementList_"\"_ElementID
			s:(ret=-1)&&(ElementList="") ElementList=ElementID
		}
		q:(ret=-1)
	}
	
	s ElementCode=""
    s:(ret=-1) ElementCode=##Class(EPRservice.Quality.DataAccess.BOQualityPool).GetElementCode(ElementList_"\"_AElementID)
    q ret_"@"_ElementCode
}

/// CreatDate:	2021-08-06
/// Creator:	GY
/// Desc:	   【手术患者术后并发症】为"是"，并发症【诊断描述1】【诊断编码1】必填，不可填"-"。
/// Input:		AEpisodeID 就诊号,AElementID:手术并发症rowid ,AElementIDs 手术并发症诊断信息
/// Return:     0 不用检查或配置错误, -1 触犯条目,1  符合条件
/// Debug:      ##class(EPRservice.Quality.EmrCheckRule.ConsistencyCheck).IsUnifyFY0010(EpisodeID,"手术并发症code","是","诊断描述1code\诊断编码1code")
ClassMethod IsUnifyFY0010(AEpisodeID As %String, AElementID As %String, AValue As %String, AElementIDs As %String) As %String
{
	s ret=0
	q:(AEpisodeID="")||(AElementID="")||(AElementIDs="") ret
	
	s ElementData=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,AElementID,"")
	q:(ElementData'=AValue) ret
	
	s ret=1,ElementList=""
	for I=1:1:$l(AElementIDs,"\")
	{
		s ElementID=$P(AElementIDs,"\",I)
		s ElementData=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,ElementID,"")
		s ElementData=$tr(ElementData,"-\—\－","")
		continue:(ElementData'="")
		s ret=-1
		s:(ElementList'="") ElementList=ElementList_"\"_ElementID
		s:(ElementList="") ElementList=ElementID
		q
	}
	
	s ElementCode=""
    s:(ret=-1) ElementCode=##Class(EPRservice.Quality.DataAccess.BOQualityPool).GetElementCode(AElementID_"\"_ElementList)
    
	q ret_"@"_ElementCode
}

/// CreatDate:	2021-10-22
/// Creator:	GY
/// Desc:	   【是否实施临床路径管理】为"是"且【是否完成临床路径】为"否"，【退出原因】必填。
/// Input:		AEpisodeID 就诊号,AElementID1:是否实施临床路径管理rowid ,AElementID2 是否完成临床路径rowid,AElementID3 退出原因rowid
/// Return:     0 不用检查或配置错误, -1 触犯条目,1  符合条件
/// Debug:      ##class(EPRservice.Quality.EmrCheckRule.ConsistencyCheck).IsUnifyFY0011(EpisodeID,"是否实施临床路径管理code","是","是否完成临床路径code","否","退出原因code")
ClassMethod IsUnifyFY0011(AEpisodeID As %String, AElementID1 As %String, AValue1 As %String, AElementID2 As %String, AValue2 As %String, AElementID3 As %String)
{
    s ret = 0
    q:(AEpisodeID="")||(AElementID1="")||(AElementID2="")||(AElementID3="") ret
    s ElementData1=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,AElementID1,"")
    s ElementData1 = $tr(ElementData1,"-\—\－","")
    
    s ElementData2=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,AElementID2,"")
    s ElementData2 = $tr(ElementData2,"-\—\－","")
    
    s ElementData3=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,AElementID3,"")
    s ElementData3 = $tr(ElementData3,"-\—\－","")
    
    if (ElementData1=AValue1)&&(ElementData2=AValue2)
    {
        s:(ElementData3="") ret=-1
    }
    
    s ElementCode=""
    s:(ret=-1) ElementCode=##Class(EPRservice.Quality.DataAccess.BOQualityPool).GetElementCode(AElementID1_"\"_AElementID2_"\"_AElementID3)
	q ret_"@"_ElementCode
}

/// CreatDate:	2023-03-29
/// Creator:	GY
/// Desc:	    特级、一级、二级、三级【护理天数】只能填写整数(小于10的天数前不允许加"0"，如"01")，请检查。
/// Input:		AEpisodeID 就诊号; AElementIDs 护理天数单元rowid;
/// Return:     0 不用检查或配置错误, -1 触犯条目,1  符合条件  
/// Debug:      ##class(EPRservice.Quality.EmrCheckRule.ConsistencyCheck).IsUnifyFY0012(EpisodeID,"护理天数code")
ClassMethod IsUnifyFY0012(AEpisodeID As %String, AElementIDs As %String, AValue As %String) As %String
{
	s ret=0
	q:(AEpisodeID="")||(AElementIDs="") ret
	
	s ret=1,IsInteger=""
	for I=1:1:$l(AElementIDs,"\")
	{
		s ElementID=$P(AElementIDs,"\",I)
		s ElementData=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,ElementID,"")
		continue:($tr(ElementData,"-\—\－","")="")
		
		s IsInteger=$num(ElementData,"I")
		s:(IsInteger="") ret=-1  //不允许非整数
		s:(+ElementData<10)&&($e(ElementData,1,1)=0) ret=-1  ///小于"10"的数字前边不允许加"0"
		q:(ret=-1)
	}
	q ret
}

/// CreatDate:	2021-06-22
/// Creator:	GY
/// Desc:	   【时间2】大于【时间1】，小于【时间3】。
/// Input:		AEpisodeID 就诊号,AElement1 时间1,AElement2 时间2,AElement3 时间3
/// Return:     0 不用检查或配置错误, -1 触犯条目,1  符合条件  
/// Debug:      ##class(EPRservice.Quality.EmrCheckRule.ConsistencyCheck).IsUnifyTime01(EpisodeID,"","","")                          
ClassMethod IsUnifyTime01(AEpisodeID As %String, AElement1 As %String, AElement2 As %String, AElement3 As %String) As %String
{
	s ret = 0
	q:(AEpisodeID="")||(AElement1="")||(AElement2="")||(AElement3="") ret
	
	s ElementData1=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,AElement1,"")
	s ElementData2=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,AElement2,"")
	q:($tr(ElementData1,"-\—","")="")||($tr(ElementData2,"-\—","")="") ret
	
	s ElementData1=##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(ElementData1)
	s ElementData2=##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(ElementData2)
	s:($p(ElementData2," ",2)=0) ElementData1=$p(ElementData1," ",1)_" "_"0"
	
	s TimeGap1=##Class(EPRservice.Quality.CommonHelper).GetDateTimeGap(ElementData2,ElementData1)
	s:(TimeGap1<0) ret=-1
	
	if (AElement3'="")
	{
		s ElementData3=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,AElement3,"")
		s ElementData3=##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(ElementData3)
		s:($p(ElementData2," ",2)=0) ElementData3=$p(ElementData3," ",1)_" "_"0"
		s TimeGap2=##Class(EPRservice.Quality.CommonHelper).GetDateTimeGap(ElementData3,ElementData2)
		s:(TimeGap2<0) ret=-1
	}
	
	s ElementCode=""
    s:(ret=-1) ElementCode=##Class(EPRservice.Quality.DataAccess.BOQualityPool).GetElementCode(AElement1_"\"_AElement2_"\"_AElement3)
    q ret_"@"_ElementCode
}

/// CreatDate:	2021-06-22
/// Creator:	GY
/// Desc:      【时间】大于【时间1】，小于【时间2】。
/// Input:		AEpisodeID 就诊号,AElement1 时间1,AElement2 时间2,AElement3 时间3
/// Return      0 不用检查或配置错误, -1 触犯条目,1  符合条件  
/// Debug:      ##class(EPRservice.Quality.EmrCheckRule.ConsistencyCheck).IsUnifyTime02(EpisodeID,"","",InstanceID)                          
ClassMethod IsUnifyTime02(AEpisodeID As %String, AElement1 As %String, AElement2 As %String, AInstanceID As %String) As %String
{
	s ret = 0
	q:(AEpisodeID="")||(AElement1="")||(AElement2="")||(AInstanceID="") ret
	
	s ElementData1=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,AElement1,"")
	s ElementData2=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,AElement2,"")
	q:(ElementData1="")||(ElementData2="") ret
	
	s DateTime="",ret=1
	s objInstance=##Class(EMRinstance.InstanceData).%OpenId(AInstanceID)
	s DateTime=objInstance.HappenDate_" "_objInstance.HappenTime
	q:(DateTime="") ret
	
	s TimeGap1=##Class(EPRservice.Quality.CommonHelper).GetDateTimeGap(DateTime,ElementData1)
	s TimeGap2=##Class(EPRservice.Quality.CommonHelper).GetDateTimeGap(ElementData2,DateTime)
	s:(TimeGap1<=0)||(TimeGap2<=0) ret=-1
	
	s ElementCode=""
    s:(ret=-1) ElementCode=##Class(EPRservice.Quality.DataAccess.BOQualityPool).GetElementCode(AElement1_"\"_AElement2)
    q ret_"@"_ElementCode
}

/// CreatDate:	2021-06-22
/// Creator:	GY
/// Desc:      【时间2】大于【时间1】，小于【时间】。
/// Input:		AEpisodeID 就诊号,AElement1 时间1,AElement2 时间2,AElement3 时间3
/// Return:     0 不用检查或配置错误, -1 触犯条目,1  符合条件  
/// Debug:      ##class(EPRservice.Quality.EmrCheckRule.ConsistencyCheck).IsUnifyTime03(EpisodeID,"","",InstanceID)                          
ClassMethod IsUnifyTime03(AEpisodeID As %String, AElement1 As %String, AElement2 As %String, AInstanceID As %String) As %String
{
	s ret = 0
	q:(AEpisodeID="")||(AElement1="")||(AElement2="")||(AInstanceID="") ret
	
	s ElementData1=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,AElement1,"")
	s ElementData2=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,AElement2,"")
	q:(ElementData1="")||(ElementData2="") ret
	
	s DateTime="",ret=1
	s objInstance=##Class(EMRinstance.InstanceData).%OpenId(AInstanceID)
	s DateTime=objInstance.HappenDate_" "_objInstance.HappenTime
	q:(DateTime="") ret
	
	s TimeGap1=##Class(EPRservice.Quality.CommonHelper).GetDateTimeGap(ElementData2,ElementData1)
	s TimeGap2=##Class(EPRservice.Quality.CommonHelper).GetDateTimeGap(DateTime,ElementData2)
	s:(TimeGap1<=0)||(TimeGap2<=0) ret=-1
	
	s ElementCode=""
    s:(ret=-1) ElementCode=##Class(EPRservice.Quality.DataAccess.BOQualityPool).GetElementCode(AElement1_"\"_AElement2)
    q ret_"@"_ElementCode
}

/// CreatDate:	2021-06-22
/// Creator:	GY
/// Desc:      【时间1】小于【时间】。
/// Input:		AEpisodeID 就诊号,AElement1 时间1,AElement2 时间2,AElement3 时间3
/// Return      0 不用检查或配置错误, -1 触犯条目,1  符合条件  
/// Debug:      ##class(EPRservice.Quality.EmrCheckRule.ConsistencyCheck).IsUnifyTime04(EpisodeID,"",InstanceID)                          
ClassMethod IsUnifyTime04(AEpisodeID As %String, AElement1 As %String, AInstanceID As %String) As %String
{
	s ret = 0
	q:(AEpisodeID="")||(AElement1="")||(AInstanceID="") ret
	
	s ElementData1=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,AElement1,"")
	q:(ElementData1="") ret
	
	s DateTime="",ret=1
	s objInstance=##Class(EMRinstance.InstanceData).%OpenId(AInstanceID)
	s DateTime=objInstance.HappenDate_" "_objInstance.HappenTime
	q:(DateTime="") ret
	
	s TimeGap=##Class(EPRservice.Quality.CommonHelper).GetDateTimeGap(DateTime,ElementData1)
	s:(TimeGap1<=0) ret=-1
	
	s ElementCode=""
    s:(ret=-1) ElementCode=##Class(EPRservice.Quality.DataAccess.BOQualityPool).GetElementCode(AElement1)
    q ret_"@"_ElementCode
}

/// CreatDate:	2021-06-22
/// Creator:	GY
/// Cesc:       入院记录.【末月月经】应≥【入院日期-14】且≤【入院日期+301天】。
/// Input:		AEpisodeID 就诊号,AElement1 时间1,AElement2 时间2,AMinDay 天数差,AMaxDay 天数差
/// Return:     0 不用检查或配置错误, -1 触犯条目,1  符合条件  
/// Debug:      ##class(EPRservice.Quality.EmrCheckRule.ConsistencyCheck).IsUnifyTime05(EpisodeID,"","入院时间code","14","301")                          
ClassMethod IsUnifyTime05(AEpisodeID As %String, AElement1 As %String, AElement2 As %String, AMinDay As %String, AMaxDay As %String) As %String
{
	s ret = 0
	q:(AEpisodeID="")||(AElement1="")||(AElement2="") ret
	
	s QualityDate="",RegDate=""
	s ElementData1=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,AElement1,"")
	q:($tr(ElementData1,"-\—","")="") ret
	s QualityDate=$p(##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(ElementData1)," ",1)
	
	s ElementData2=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,AElement2,"")
	q:($tr(ElementData2,"-\—","")="") ret
	s RegDate=$p(##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(ElementData2)," ",1)
	
	s ret=1
	s:((RegDate-QualityDate)>AMinDay) ret=-1
	s:((QualityDate-RegDate)>AMaxDay) ret=-1
	
	s ElementCode=""
    s:(ret=-1) ElementCode=##Class(EPRservice.Quality.DataAccess.BOQualityPool).GetElementCode(AElement1_"\"_AElement1)
    q ret_"@"_ElementCode
}

/// CreatDate:	2021-06-22
/// Creator:	GY
/// Desc:       【结构化元素1\结构化元素2\结构化元素3...】必填，(不)允许为"-"。
/// Input:		AEpisodeID 就诊号,AElementIDs 结构化元素(多个用"\"分隔)，AInstanceID 实例ID 用于可重复模板，AValue 空以外不允许填写的值 如:"-\—"
/// Return:     0 不用检查或配置错误, -1 触犯条目,1  符合条件 
/// Debug:      ##Class(EPRservice.Quality.EmrCheckRule.ConsistencyCheck).IsSaveElement(EpisodeID,"10010","","-\—")
ClassMethod IsSaveElement(AEpisodeID As %String, AElementIDs As %String, AInstanceID As %String, AValue As %String = "") As %String
{
	s ret=0
	q:(AEpisodeID="")||(AElementIDs="") ret
	
	s ret=1,ElementList=""
	for I=1:1:$l(AElementIDs,"\")
	{
		s ElementID=$p(AElementIDs,"\",I)
		s ElementData=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,ElementID,AInstanceID)
		s:(AValue'="") ElementData=$tr(ElementData,AValue,"")
		continue:(ElementData'="")
		s ret=-1
		s:(ElementList'="") ElementList=ElementList_"\"_ElementID
		s:(ElementList="") ElementList=ElementID
	}
	
	s ElementCode=""
    s:(ret=-1) ElementCode=##Class(EPRservice.Quality.DataAccess.BOQualityPool).GetElementCode(ElementList)
    q ret_"@"_ElementCode
}

/// CreatDate:	2021-08-24
/// Creator:	GY
/// Desc:	    有分娩的产妇,【新生儿出生体重】必填，不可填"-"。
/// InPut:      AEpisodeID 就诊号; AIsQuaFlag 是否符合质控条件(N-不符合、Y-符合，由公共函数返回); AElementIDs:判断必填元素RowID(多个用"\"分隔);AInstanceID 实例ID 用于可重复模板; AValue 空以外不允许填写的值 如:"-\—"
/// Return:     0 不用检查或配置错误, -1 触犯条目,1  符合条件 
/// Debug:	    ##class(EPRservice.Quality.EmrCheckRule.ConsistencyCheck).IsSaveElementInS(EpisodeID,{IsDelivery},"新生儿出生体重code","","-\—")
ClassMethod IsSaveElementInS(AEpisodeID As %String, AIsQuaFlag As %String, AElementIDs As %String, AInstanceID As %String, AValue As %String) As %String
{
	s ret=0
	q:(AEpisodeID="")||(AIsQuaFlag="N")||(AElementIDs="") ret
	
	s ret=..IsSaveElement(AEpisodeID,AElementIDs,AInstanceID,AValue)
	q ret
}

/// 说明: 病案首页.死亡患者主诊断不能为该诊断
/// Input: AEpisodeID为患者就诊号 , DeathDate:死亡患者死亡日期 , AElement1:主诊断编码模板元素ID , Desc:不能出现的诊断编码
/// OutPut: 0 不用检查或配置错误 ; -1 触犯条目 ; 1  符合条件 
ClassMethod IsUnify202207121(AEpisodeID As %String, DeathDate As %String, AElement1 As %String, Desc As %String)
{
	q:(DeathDate="") 1
	s ElementData=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,AElement1,"")
	s flag=1
	for i=1:1:$l(Desc,"/")
	{
		s ADesc=$p(Desc,"/",i)
		s:(ADesc=$e(ElementData,1,$l(ADesc))) flag=-1
		q:(flag=-1)
	}
	q flag
}

/// 说明: 某个元素为什么时，另一个元素只能为什么
/// 举例:【联系人关系】为"配偶"时，【婚姻】只能为"已婚"。
/// Input: AEpisodeID为患者就诊号 , AElement1:元素编码 , Avalue1:元素值,AElement2:元素编码,Avalue2:元素值
/// OutPut: 0 不用检查或配置错误 ; -1 触犯条目 ; 1  符合条件 
/// Debug:	##class(EPRservice.Quality.EmrCheckRule.ConsistencyCheck).IsUnify202208161(EpisodeID,"联系人关系code","配偶","婚姻code","已婚")
ClassMethod IsUnify202208161(AEpisodeID As %String, AElement1 As %String, Avalue1 As %String, AElement2 As %String, Avalue2 As %String) As %String
{
	s ret=0
	q:(AEpisodeID="")||(AElement1="")||(AElement2="") ret
	
	s ret=1

	s ElementData1=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,AElement1,"") 
	s ElementData2=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,AElement2,"")
	if (ElementData1=Avalue1)
	{
		q:(ElementData2=Avalue2) 1
		s ElementCode=##Class(EPRservice.Quality.DataAccess.BOQualityPool).GetElementCode(AElement1_"\"_AElement2)
		q "-1@"_ElementCode
	}
	else
	{
		q 1
	}
}

/// 中医病案首页.实际住院天数大于等于两天，日间手术不能选择“是”
/// AElement1：日间手术元素
ClassMethod IsUnify202211031(AEpisodeID As %String, AElement1 As %String)
{
	s Elementdata1=##Class(EPRservice.Quality.EmrCheckRule.Template).GetElementValue(AEpisodeID,AElement1)
	s ret=##class(%ResultSet).%New("EMRservice.SystemData:GetATDInfo")
	d ret.Execute(AEpisodeID)
	s ResidentDays=0
	while ret.Next()
	{
		s ResidentDays=ret.Data("ResidentDays")
	}
	s ResidentDays=+ResidentDays
	q:(ResidentDays>=2)&&(Elementdata1["是") -1
	q 1
}

}
