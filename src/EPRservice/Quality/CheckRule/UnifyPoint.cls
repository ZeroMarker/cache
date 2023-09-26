/// Class Name:	 	EPRservice.Quality.CheckRule.UnifyPoint
/// Description: 	一致性和时效性检查方法类
/// Author:		 	Zuoxiang Xie
/// Create Date: 	2010-05-18
/// Version:		
Class EPRservice.Quality.CheckRule.UnifyPoint Extends %Library.RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// Desc:	判断唯一模板两元素一致性问题(病案首页中【联系人姓名】与【关系】的一致性检查, 有一个为空则不检查)
/// 		如果第一个单元为空或者为无或不详,则第二个单元可以为空或其他或其它或不详;
/// 		如果第一个单元不为空,则第二个单元不能为空,并且不能为其它或其他或者不详;
/// Input:	AEpisodeID为患者就诊号;
/// 		AElement1为第一个模板单元RowID;
/// 		AElement1为第二个模板单元RowID;
/// Return:	ret<0 不一致
/// Debug:	w ##Class(EPRservice.Quality.CheckRule.UnifyPoint).IsUnify0001("8706","E4432","E4431")
ClassMethod IsUnify0001(AEpisodeID As %String, AElement1 As %String, AElement2 As %String) As %String
{
	s ret = 0
	q:(AEpisodeID = "")||(AElement1 = "")||(AElement2 = "") ret
	
	s ElementData1 = ##Class(EPRservice.Quality.CheckRule.Template).GetSingleValues(AEpisodeID,AElement1)
	q:($e(ElementData1,1,2) = "0^") ret
	s ElementData1 = $e(ElementData1,3,$l(ElementData1))
	
	s ElementData2 = ##Class(EPRservice.Quality.CheckRule.Template).GetSingleValues(AEpisodeID,AElement2)
	q:($e(ElementData2,1,2) = "0^") ret
	s ElementData2 = $e(ElementData2,3,$l(ElementData2))
	
	s ret = 1
	if ((ElementData1 = "")||(ElementData1 = "无")||(ElementData1 = "不详"))
	{
		//如果没有填写联系人姓名,则可以不填写与患者的关系，或者填写"其他"、"其它"、"不详"
		s:(ElementData2'="")&&(ElementData2'="其他")&&(ElementData2'="其它")&&(ElementData2'="不详") ret = -1
	}
	else
	{
		//如果填写了联系人姓名，则必须填写与患者的关系，而不能填写"其他"、"其它"或者"不详"
		s:(ElementData2="")||(ElementData2="其他")||(ElementData2="其它")||(ElementData2="不详") ret = -1
	}
	q ret
}

/// Desc:	判断唯一模板单元是否为数字(数字单元：输血量，抢救次数，成功次数等)
/// Input:	AEpisodeID为患者就诊号;
/// 		AElement1为界面模板单元RowID;
/// Return:	ret<=0不为数字; ret=1为数字;
/// Debug:	w ##Class(EPRservice.Quality.CheckRule.UnifyPoint).IsUnify0002("8706","E4498")
ClassMethod IsUnify0002(AEpisodeID As %String, AElement1 As %String) As %String
{
	s ret = 0
	q:(AEpisodeID = "")||(AElement1 = "") ret
	
	s ElementData1 = ##Class(EPRservice.Quality.CheckRule.Template).GetSingleValues(AEpisodeID,AElement1)
	q:($e(ElementData1,1,2) = "0^") ret
	
	s ElementData1 = $e(ElementData1,3,$l(ElementData1))
	q:(ElementData1 = "") ret
	
	s ElementData1 = $tr(ElementData1,"零","0")
	
	s ret = 1
	s:((+ElementData1) '= ElementData1) ret = -1
	q ret
}

/// Desc:	判断唯一模板单元是否有空格(为空不判断)
/// Input:	AEpisodeID为患者就诊号;
/// 		AElement1为界面模板单元RowID;
/// Return:	ret<0 不一致
/// Debug:	w ##Class(EPRservice.Quality.CheckRule.UnifyPoint).IsUnify0003("8706","E1")
/// ****************************************************************
ClassMethod IsUnify0003(AEpisodeID As %String, AElement1 As %String) As %String
{
	s ret = 0
	q:(AEpisodeID = "")||(AElement1 = "") ret
	
	s ElementData1 = ##Class(EPRservice.Quality.CheckRule.Template).GetSingleValues(AEpisodeID,AElement1)
	q:($e(ElementData1,1,2) = "0^") ret
	
	s ElementData1 = $e(ElementData1,3,$l(ElementData1))
	q:(ElementData1 = "") ret
	
	s ret = 1
	s:(ElementData1 [ " ") ret = -1
	q ret
}

/// Desc:	判断病案首页中【婚姻状况】与【年龄】是否一致（有一个为空则不判断，小于16岁则只能为未婚或者空）
/// Input:	AEpisodeID为患者就诊号;
/// 		AElement1为婚姻状况模板单元RowID;;
/// 		AElement2为年龄模板单元RowID;
/// 		ADefaultAge为指定成年年龄,默认为18岁;
/// Return:	ret<0 不一致; ret=1一致;
/// Debug:	w ##Class(EPRservice.Quality.CheckRule.UnifyPoint).IsUnify0004("8706","E4419","E4418")
ClassMethod IsUnify0004(AEpisodeID As %String, AElement1 As %String, AElement2 As %String, ADefaultAge As %String = 18) As %String
{
	s ret = 0
	q:(AEpisodeID = "")||(AElement1 = "")||(AElement2 = "") ret
	
	s elementData1 = ##Class(EPRservice.Quality.CheckRule.Template).GetSingleValues(AEpisodeID,AElement1)
	q:($e(elementData1,1,2) = "0^") ret
	s elementData1 = $e(elementData1,3,$l(elementData1))
	
	s elementData2 = ##Class(EPRservice.Quality.CheckRule.Template).GetSingleValues(AEpisodeID,AElement2)
	q:($e(elementData2,1,2) = "0^") ret
	s elementData2 = $e(elementData2,3,$l(elementData2))
	
	q:(elementData1 = "")&&(elementData2 = "") ret
	
	s ret = 1
	s age = $s((elementData2 [ "岁"):+$p(elementData2,"岁",1),1:elementData2)
	s:(+age = 0) ret = -1	
	
	if (age '= 0)&&(age < +$g(ADefaultAge))
	{
		s:(elementData1 '= "未婚") ret = -1
	}
	q ret
}

/// Desc:	病案首页{邮编} "邮编","无","不详"不允许共存;
/// Input:	AEpisodeID为患者就诊号;
/// 		AElement1为病案首页邮编模板单元RowID;
/// Return:	ret<0 不一致
/// Debug:	w ##Class(EPRservice.Quality.CheckRule.UnifyPoint).IsUnify0005(201871,"E282")
ClassMethod IsUnify0005(AEpisodeID As %String, AElement1 As %String) As %String
{
	s ret = 0
	q:(AEpisodeID = "")||(AElement1 = "") ret
	
	s elementData1 = ##Class(EPRservice.Quality.CheckRule.Template).GetSingleValues(AEpisodeID,AElement1)
	q:($e(elementData1,1,2) = "0^") ret
	
	s elementData1 = $e(elementData1,3,$l(elementData1))
	q:(elementData1 = "") ret
	
	s ret = 1
	s:(elementData1 '= "无")&&(elementData1 '= "不详")&&($tr(elementData1,"无","") '= elementData1) ret = -1
	s:(elementData1 '= "无")&&(elementData1 '= "不详")&&($tr(elementData1,"不详","") '= elementData1) ret = -1
	q ret
}

/// Desc:	判断日期单元是否超出入出院时间(比如病案首页中确诊日期、手术日期等，为空则不判断);
/// modify: 20130716 Hanxf;--<出院时间AElement2可以取医生填写的日期时间>
/// Input:	AEpisodeID为患者就诊号;
/// 		AElement1为指定模板单元RowID;
/// 		ARegDate为患者入院日期;
/// 		ADischDate为患者出院日期;
///         AElement2为指定模板日期单元RowID;
/// Return：ret<0:不一致; ret=1一致;  --<Modi Guozt 有歧义 更改返回值>
///         ret<0:传入日期比入院日期早，或者 传入日期比出院日期晚
/// Debug:	w ##Class(EPRservice.Quality.CheckRule.UnifyPoint).IsUnify0006("2487372","E563","2008-12-08 09:38:00","")
ClassMethod IsUnify0006(AEpisodeID As %String, AElement1 As %String, ARegDate As %String, ADischDate As %String, AElement2 As %String = "") As %String
{
	s ret = 0
	q:(AEpisodeID = "")||(AElement1 = "")||(ARegDate = "") ret
	
	s ElementData1 = ##Class(EPRservice.Quality.CheckRule.Template).GetSingleValues(AEpisodeID,AElement1)
	q:($e(ElementData1,1,2) = "0^") ret
	s ElementData1 = $e(ElementData1,3,$l(ElementData1))
	q:(ElementData1 = "") ret
	
	//Add by Liaowp 2010-06-22
	//首页中当日确诊,确诊日期没有时间,默认为00:00:00,此条不通过
	s DateTime1 = ##Class(EPRservice.Quality.CommonHelper).ChangeDateTime(ElementData1)
	s DateTime2 = ##Class(EPRservice.Quality.CommonHelper).ChangeDateTime(ARegDate)
	s Date1 = $p(DateTime1," ",1),Time1 = $p(DateTime1," ",2)
	s Date2 = $p(DateTime2," ",1),Time2 = $p(DateTime2," ",2)
	s:((Date1 = Date2)&&(Time1 = "00:00:00")&&(Time2 '= "00:00:00")) DateTime1 = DateTime2
	//End Add
	
	s ret = 1
	s flag = ##Class(EPRservice.Quality.CommonHelper).GetDateTimeGap(DateTime1,ARegDate)
	s:(flag < 0) ret = -1
	s:(ADischDate = "") ADischDate = $zd(+$h,3)_" "_$zt($p($h,",",2),1)
	s flag = ##Class(EPRservice.Quality.CommonHelper).GetDateTimeGap(ADischDate,DateTime1)
	s:(flag < 0) ret = -1
	
	//Add Hanxf
	if (AElement2 '= "")
	{
	  s ElementData2 = ##Class(EPRservice.Quality.CheckRule.Template).GetSingleValues(AEpisodeID,AElement2)
	  q:($e(ElementData2,1,2) = "0^") ret
	  s ElementData2 = $e(ElementData2,3,$l(ElementData2))
	  q:(ElementData2 = "") ret	
	  s Element2DateTime = ##Class(EPRservice.Quality.CommonHelper).ChangeDateTime(ElementData2)
	  s flag = ##Class(EPRservice.Quality.CommonHelper).GetDateTimeGap(Element2DateTime,DateTime1)
	  s:(flag < 0) ret = -1
	}
	//end add
	q ret
}

/// add by niucaicai 2013-11-12 for TMS Bug#2418:质控要求支持日期时间单元分开控制
/// Desc:	判断最多一对日期时间单元是否超出入出院日期时间(比如病案首页中确诊日期、确诊日期时间、手术日期等，为空则不判断);
/// 			例：
///         判断 确诊日期、确诊日期时间、手术日期、手术日期时间等其中一个单元
/// 			质控表达式：##Class(EPRservice.Quality.CheckRule.UnifyPoint).MoreUnitIsUnify0006(EpisodeID,"E10137","","","",{HISRegTime},{HISDischTime})
/// 		判断 手术开始日期，开始时间，结束日期，结束时间 等多个单元
/// 			质控表达式：##Class(EPRservice.Quality.CheckRule.UnifyPoint).MoreUnitIsUnify0006(EpisodeID,"E10137","E10138","E10139","E10140",{HISRegTime},{HISDischTime})
/// 			E10137、E10138、E10139、E10140以项目为准；
/// Input:	AEpisodeID为患者就诊号;
/// 		AElement1为指定模板单元(日期单元1、日期时间单元1)RowID,不能为空;
/// 		AElement2为指定模板单元(时间单元1)RowID,可为空;
/// 		AElement3为指定模板单元(日期单元2、日期时间单元2)RowID,可为空;
/// 		AElement4为指定模板单元(时间单元2)RowID,可为空;
/// 		ARegDate为患者入院日期;
/// 		ADischDate为患者出院日期;
/// Return：ret<0:不一致; ret=1一致; 
///         ret<0:传入日期比入院日期早，或者 传入日期比出院日期晚
/// Debug:	w ##Class(EPRservice.Quality.CheckRule.UnifyPoint).MoreUnitIsUnify0006("42","E10137","","E10137","","2013-10-05 09:38:00","")
ClassMethod MoreUnitIsUnify0006(AEpisodeID As %String, AElement1 As %String, AElement2 As %String, AElement3 As %String, AElement4 As %String, ARegDate As %String, ADischDate As %String) As %String
{
	
	s ret = 0
	q:(AEpisodeID = "")||(ARegDate = "")||(AElement1 = "") ret
	
	s DateTimeStr1 = ##Class(EPRservice.Quality.CheckRule.Template).GetSingleValues(AEpisodeID,AElement1)
	q:($e(DateTimeStr1,1,2) = "0^") ret
	s DateTime1 = $e(DateTimeStr1,3,$l(DateTimeStr1))
	q:(DateTime1 = "") ret
	
	s TimeStr1 = ##Class(EPRservice.Quality.CheckRule.Template).GetSingleValues(AEpisodeID,AElement2)
	s Time1 = $e(TimeStr1,3,$l(TimeStr1))

	s DateTimeStr2 = ##Class(EPRservice.Quality.CheckRule.Template).GetSingleValues(AEpisodeID,AElement3)
	s DateTime2 = $e(DateTimeStr2,3,$l(DateTimeStr2))
	
	s TimeStr2 = ##Class(EPRservice.Quality.CheckRule.Template).GetSingleValues(AEpisodeID,AElement4)
	s Time2 = $e(TimeStr2,3,$l(TimeStr2))
	
	
	if ($l(DateTime1," ")=2)&&(Time1="")
	{
		s ret = 1
		s DateTimeCheck = DateTime1
		s flag = ##Class(EPRservice.Quality.CommonHelper).GetDateTimeGap(DateTimeCheck,ARegDate)
		s:(flag < 0) ret = -1
		q:(ret=-1) ret
		
		s:(ADischDate = "") ADischDate = $zd(+$h,3)_" "_$zt($p($h,",",2),1)
		s flag = ##Class(EPRservice.Quality.CommonHelper).GetDateTimeGap(ADischDate,DateTimeCheck)
		s:(flag < 0) ret = -1
		q:(ret=-1) ret
	}
	
	if ($l(DateTime1," ")=1)&&(Time1'="")
	{
		s ret = 1
		s DateTimeCheck = DateTime1_" "_Time1
		s flag = ##Class(EPRservice.Quality.CommonHelper).GetDateTimeGap(DateTimeCheck,ARegDate)
		s:(flag < 0) ret = -1
		q:(ret=-1) ret
		
		s:(ADischDate = "") ADischDate = $zd(+$h,3)_" "_$zt($p($h,",",2),1)
		s flag = ##Class(EPRservice.Quality.CommonHelper).GetDateTimeGap(ADischDate,DateTimeCheck)
		s:(flag < 0) ret = -1
		q:(ret=-1) ret
	}
	
	if ($l(DateTime1," ")=1)&&(Time1="")
	{
		s ret = 1
		
		s DateTimeCheck1 = DateTime1_" "_"23:59:59"
		s flag = ##Class(EPRservice.Quality.CommonHelper).GetDateTimeGap(DateTimeCheck1,ARegDate)
		s:(flag < 0) ret = -1
		q:(ret=-1) ret
		
		s DateTimeCheck2 = DateTime1_" "_"00:00:00"
		s:(ADischDate = "") ADischDate = $zd(+$h,3)_" "_$zt($p($h,",",2),1)
		s flag = ##Class(EPRservice.Quality.CommonHelper).GetDateTimeGap(ADischDate,DateTimeCheck2)
		s:(flag < 0) ret = -1
		q:(ret=-1) ret
	}
	
	if ($l(DateTime2," ")=2)&&(Time2="")
	{
		s ret = 1
		s DateTimeCheck = DateTime2
		s flag = ##Class(EPRservice.Quality.CommonHelper).GetDateTimeGap(DateTimeCheck,ARegDate)
		s:(flag < 0) ret = -1
		q:(ret=-1) ret
		
		s:(ADischDate = "") ADischDate = $zd(+$h,3)_" "_$zt($p($h,",",2),1)
		s flag = ##Class(EPRservice.Quality.CommonHelper).GetDateTimeGap(ADischDate,DateTimeCheck)
		s:(flag < 0) ret = -1
		q:(ret=-1) ret
	}
	
	if (DateTime2'="")&&($l(DateTime2," ")=1)&&(Time2'="")
	{
		s ret = 1
		s DateTimeCheck = DateTime2_" "_Time2
		s flag = ##Class(EPRservice.Quality.CommonHelper).GetDateTimeGap(DateTimeCheck,ARegDate)
		s:(flag < 0) ret = -1
		q:(ret=-1) ret
		
		s:(ADischDate = "") ADischDate = $zd(+$h,3)_" "_$zt($p($h,",",2),1)
		s flag = ##Class(EPRservice.Quality.CommonHelper).GetDateTimeGap(ADischDate,DateTimeCheck)
		s:(flag < 0) ret = -1
		q:(ret=-1) ret
	}
	
	if (DateTime2'="")&&($l(DateTime2," ")=1)&&(Time2="")
	{
		s ret = 1
		
		s DateTimeCheck1 = DateTime2_" "_"23:59:59"
		s flag = ##Class(EPRservice.Quality.CommonHelper).GetDateTimeGap(DateTimeCheck1,ARegDate)
		s:(flag < 0) ret = -1
		q:(ret=-1) ret
		
		s DateTimeCheck2 = DateTime2_" "_"00:00:00"
		s:(ADischDate = "") ADischDate = $zd(+$h,3)_" "_$zt($p($h,",",2),1)
		s flag = ##Class(EPRservice.Quality.CommonHelper).GetDateTimeGap(ADischDate,DateTimeCheck2)
		s:(flag < 0) ret = -1
		q:(ret=-1) ret
	}
	
	if (DateTime2="")&&(Time2'="")&&($l(DateTime1," ")=1)
	{
		s ret = 1
		s DateTime2 = DateTime1
		s DateTimeCheck = DateTime2_" "_Time2
		s flag = ##Class(EPRservice.Quality.CommonHelper).GetDateTimeGap(DateTimeCheck,ARegDate)
		s:(flag < 0) ret = -1
		q:(ret=-1) ret
		
		s:(ADischDate = "") ADischDate = $zd(+$h,3)_" "_$zt($p($h,",",2),1)
		s flag = ##Class(EPRservice.Quality.CommonHelper).GetDateTimeGap(ADischDate,DateTimeCheck)
		s:(flag < 0) ret = -1
		s ^tempncc("2") = DateTimeCheck_"&&&"_ADischDate
		q:(ret=-1) ret
	}
	
	q ret
}

/// Desc:	判断病案首页{诊断单元：主要诊断、次要诊断、院感诊断等}与病案首页{疾病转归}是否一致;
/// Input:	AEpisodeID为患者就诊号;
/// 		AElement1为第一个指定模板单元RowID;
/// 		AElement1为第二个指定模板单元RowID;
/// Return:	ret<=0 不一致; ret=1一致;
/// Debug:	w ##Class(EPRservice.Quality.CheckRule.UnifyPoint).IsUnify0007("","","")
ClassMethod IsUnify0007(AEpisodeID As %String, AElement1 As %String, AElement2 As %String) As %String
{
	s ret = 0
	q:(AEpisodeID = "")||(AElement1 = "")||(AElement2 = "") ret
	
	s ElementData1 = ##Class(EPRservice.Quality.CheckRule.Template).GetSingleValues(AEpisodeID,AElement1)
	q:($e(ElementData1,1,2) = "0^") ret
	s ElementData1=$e(ElementData1,3,$l(ElementData1))
	
	s ElementData2 = ##Class(EPRservice.Quality.CheckRule.Template).GetSingleValues(AEpisodeID,AElement2)
	q:($e(ElementData2,1,2) = "0^") ret
	s ElementData2 = $e(ElementData2,3,$l(ElementData2))
	
	q:(ElementData1 = "")&&(ElementData2 = "") ret
	
	s ret = 1
	s ElementData1 = ##Class(EPRservice.Quality.CommonHelper).ClearChar(ElementData1," /-")
	if ((ElementData1 = "")||(ElementData1 = "无")||(ElementData1 = "不详"))
	{
		s:(ElementData2 '= "") ret = -1
	}
	else
	{
		s:(ElementData2 = "") ret = -1
	}
	q ret
}

/// Desc:	病案首页{疾病转归}不一致;
/// Input:	AEpisodeID为患者就诊号;
/// 		AElement1为指定模板单元RowID;
/// Return:	ret<0 不一致;
/// Debug:	w ##Class(EPRservice.Quality.CheckRule.UnifyPoint).IsUnify0008("","")
/// ****************************************************************
ClassMethod IsUnify0008(AEpisodeID As %String, AElement1 As %String) As %String
{
	s ret = 0
	q:(AEpisodeID = "")||(AElement1 = "") ret
	
	s elementData1 = ##Class(EPRservice.Quality.CheckRule.Template).GetSingleValues(AEpisodeID,AElement1)
	q:($e(elementData1,1,2) = "0^") ret
	s elementData1 = $e(elementData1,3,$l(elementData1))
	q:(elementData1 = "") ret
	
	s elementDatals = ##Class(EPRservice.Quality.CommonHelper).GetListFromString(elementData1,"\")
	s (count, count1, count2) = 0
	for ind = 1:1:$listlength(elementDatals) 
	{
		s elementData = $listget(elementDatals,ind)
		continue:(elementData = "")
	
		s count = count + 1
		s:(elementData = "死亡") count1 = count1 + 1
		s:(elementData '= "死亡") count2 = count2 + 1
	}
	
	s ret = 1
	s:(count1 > 0)&&(count2 > 0) ret = -1
	q ret
}

/// Desc:	判断病案首页【抢救次数】与【成功次数】是否一致（抢救次数必须>=成功次数）
/// Input:	AEpisodeID为患者就诊号;
/// 		AElement1为抢救次数模板单元RowID; 
/// 		AElement2为成功次数模板单元RowID;
///         AElement3为出院情况模板单元RowID; 
/// modify: 20130716 Hanxf；根据出院情况是否为死亡，增加抢救与成功次数的关系判断
/// Return:	ret<0 不一致; ret=1一致;
/// Debug:	w ##Class(EPRservice.Quality.CheckRule.UnifyPoint).IsUnify0009("","","")
ClassMethod IsUnify0009(AEpisodeID As %String, AElement1 As %String, AElement2 As %String, AElement3 As %String = "") As %String
{
	s ret = 0
	q:(AEpisodeID = "")||(AElement1 = "")||(AElement2 = "") ret
	
	s elementData1 = ##Class(EPRservice.Quality.CheckRule.Template).GetSingleValues(AEpisodeID,AElement1)
	q:($e(elementData1,1,2) = "0^") ret
	s elementData1 = $e(elementData1,3,$l(elementData1))
	
	s elementData2 = ##Class(EPRservice.Quality.CheckRule.Template).GetSingleValues(AEpisodeID,AElement2)
	q:($e(elementData2,1,2) = "0^") ret
	s elementData2 = $e(elementData2,3,$l(elementData2))
	
	s elementData3 = ##Class(EPRservice.Quality.CheckRule.Template).GetSingleValues(AEpisodeID,AElement3)
	q:($e(elementData3,1,2) = "0^") ret
	s elementData3 = $e(elementData3,3,$l(elementData3))
	
	q:(elementData1 = "")&&(elementData2 = "") ret
	
	s elementData1 = $tr(elementData1,"零","0")
	s elementData2 = $tr(elementData2,"零","0")
	
	s ret = 1
	s:(+elementData1 < +elementData2) ret = -1
	
	if (elementData3'="")
	{
	  s:((elementData3 '= "死亡")&&(+elementData1 '= +elementData2)) ret=-1
	  s:((elementData3 = "死亡")&&(+elementData1 '= (+elementData2+1))) ret=-1	
	}
	
	q ret
}

/// Desc:	病案首页{术前与术后}与病案首页{手术名称1}是否一致;
/// Input:	AEpisodeID为患者就诊号;
/// 		AElement1为术前与术后模板单元RowID; 
/// 		AElement2为指定手术名称1模板单元RowID; 
/// Return:	ret<0 不一致; ret=1一致;
/// Debug:	w ##Class(EPRservice.Quality.CheckRule.UnifyPoint).IsUnify0010(EpisodeID,Element1,Element2)
ClassMethod IsUnify0010(AEpisodeID As %String, AElement1 As %String, AElement2 As %String) As %String
{
	s ret = 0
	q:(AEpisodeID = "")||(AElement1 = "")||(AElement2 = "") ret
	
	s ElementData1 = ##Class(EPRservice.Quality.CheckRule.Template).GetSingleValues(AEpisodeID,AElement1)
	q:($e(ElementData1,1,2) = "0^") ret
	s ElementData1 = $e(ElementData1,3,$l(ElementData1))
	
	s ElementData2 = ##Class(EPRservice.Quality.CheckRule.Template).GetSingleValues(AEpisodeID,AElement2)
	q:($e(ElementData2,1,2) = "0^") ret
	s ElementData2 = $e(ElementData2,3,$l(ElementData2))
	
	q:(ElementData1 = "")&&(ElementData2 = "") ret

	s ret = 1	
	s ElementData2 = ##Class(EPRservice.Quality.CommonHelper).ClearChar(ElementData2," /-")
	if ((ElementData2 = "")||(ElementData2 = "无")||(ElementData2 = "不详"))
	{
		s:(ElementData1 '= "未做") ret = -1
	}
	else
	{
		s:(ElementData1 = "未做") ret = -1
	}
	q ret
}

/// Desc:	判断病案首页{疾病转归:主诊断疾病转归}与病案首页{尸检:尸检}是否一致;
/// Input:	AEpisodeID为患者就诊号;
/// 		AElement1为疾病转归模板单元RowID; 
/// 		AElement2为尸检模板单元RowID; 
/// Return:	ret<0 不一致; ret=1一致;
/// Debug:	w ##Class(EPRservice.Quality.CheckRule.UnifyPoint).IsUnify0011("","","")
/// ****************************************************************
ClassMethod IsUnify0011(AEpisodeID As %String, AElement1 As %String, AElement2 As %String) As %String
{
	s ret = 0
	q:(AEpisodeID = "")||(AElement1 = "")||(AElement2 = "") ret
	
	s ElementData1 = ##Class(EPRservice.Quality.CheckRule.Template).GetSingleValues(AEpisodeID,AElement1)
	q:($e(ElementData1,1,2) = "0^") ret
	s ElementData1 = $e(ElementData1,3,$l(ElementData1))
	
	s ElementData2 = ##Class(EPRservice.Quality.CheckRule.Template).GetSingleValues(AEpisodeID,AElement2)
	q:($e(ElementData2,1,2) = "0^") ret
	s ElementData2 = $e(ElementData2,3,$l(ElementData2))
	
	q:(ElementData1 = "")&&(ElementData2 = "") ret
	
	s ret = 1
	if (ElementData1 = "死亡")
	{
		s:(ElementData2 '= "是")&&(ElementData2 '= "否") ret = -1
	}
	else
	{
		s:(ElementData2 = "是")||(ElementData2 = "否") ret = -1
	}
	q ret
}

/// Desc:	病案首页{是否随诊}与病案首页{随诊期限}是否一致;
/// Input:	AEpisodeID为患者就诊号;
/// 		AElement1为是否随诊模板单元RowID; 
/// 		AElement2为随诊期限模板单元RowID; 
/// Return:	ret<0 不一致; ret=1一致;
/// Debug:	w ##Class(EPRservice.Quality.CheckRule.UnifyPoint).IsUnify0012(AEpisodeID,AElement1,AElement2)
/// ****************************************************************
ClassMethod IsUnify0012(AEpisodeID As %String, AElement1 As %String, AElement2 As %String) As %String
{
	s ret = 0
	q:(AEpisodeID = "")||(AElement1 = "")||(AElement2 = "") ret
	
	s elementData1 = ##Class(EPRservice.Quality.CheckRule.Template).GetSingleValues(AEpisodeID,AElement1)
	q:($e(elementData1,1,2) = "0^") ret
	s elementData1 = $e(elementData1,3,$l(elementData1))
	
	s elementData2 = ##Class(EPRservice.Quality.CheckRule.Template).GetSingleValues(AEpisodeID,AElement2)
	q:($e(elementData2,1,2) = "0^") ret
	s elementData2 = $e(elementData2,3,$l(elementData2))
	
	q:(elementData1 = "")&&(elementData2 = "") ret
	
	s ret = 1
	s elementData2 = ##Class(EPRservice.Quality.CommonHelper).GetListFromString(elementData2,"\")
	if (elementData1 = "是")
	{
		s:($listfind(elementData2,"") > 0) ret = -1
	}
	else
	{
		s:($listfind(elementData2,"") '> 0)||($listfind(elementData2,"无") '= 0) ret = -1
	}
	
	q ret
}

/// Desc:	判断病案首页{手术信息:手术名称1,手术日期,术者,1助等}是否一致;
/// Input:	AEpisodeID为患者就诊号;
/// 		AElement1为一条手术信息模板单元RowID字符串,多个以"\"分隔; 
/// 		ASites指手术名称在模板单元RowID字符串中的位置;
/// Return:	ret<0:不一致; ret=1一致;
/// Debug:	w ##Class(EPRservice.Quality.CheckRule.UnifyPoint).IsUnify0013("","")
ClassMethod IsUnify0013(AEpisodeID As %String, AElement1 As %String, ASites As %String = 2) As %String
{
	s ret = 0
	q:(AEpisodeID = "")||(AElement1 = "") ret
	
	s ElementData1 = ##Class(EPRservice.Quality.CheckRule.Template).GetSingleValues(AEpisodeID,AElement1)
	q:($e(ElementData1,1,2) = "0^") ret
	s ElementData1 = $e(ElementData1,3,$l(ElementData1))
	
	//如果全未填写不判断
	s trElementData1 = $tr(ElementData1," "), trElementData1 = $tr(trElementData1,"\")
	q:(trElementData1 = "") ret
	
	s ElementData1 = ##Class(EPRservice.Quality.CommonHelper).GetListFromString(ElementData1,"\","N")
	
	s ret = 1
	//如果手术名称填"无"不判断
	q:($li(ElementData1,ASites) = "无")&&(trElementData1 = "无") ret
	
	s:($listfind(ElementData1,"") > 0) ret = -1
	q ret
}

/// Creator: Candyxu
/// Date: 20120420
/// Desc:  输入的一组单元,只要有一个单元保存过且符合条件返回 1
/// Input: AEpisodeID为患者就诊号;
///       AElement1 为一组模板单元RowID字符串，多个以"\"分隔
/// Output: ret = -1:一个单元也没有保存过; ret = 1：至少有一个单元保存过; ret = 0 ：参数不对
/// Debug: w ##Class(EPRservice.Quality.CheckRule.UnifyPoint).IsUnify0014("50729","E10111\E10215")
ClassMethod IsUnify0014(AEpisodeID As %String, AElement1 As %String)
{
	s ret = 0
	q:(AEpisodeID = "")||(AElement1 = "") ret
	
	s ElementData1 = ##Class(EPRservice.Quality.CheckRule.Template).GetSingleValues(AEpisodeID,AElement1)
	q:($e(ElementData1,1,2) = "0^") ret
	s tmpElementData = $e(ElementData1,3,$l(ElementData1))
    s trElementData1 = $tr(tmpElementData," "), trElementData1 = $tr(trElementData1,"\")
    i (trElementData1 = "")
    {
	    s ret = -1
	} else
	{
		s ret = 1
	}
	q ret
}

/*
/// ****************************************************************
/// 说明: 患者未出院,不允许打印{病历内容:病案首页,出院记录,死亡记录等}
/// 结论: ret<0 不一致
/// 调试: w ##Class(EPRservice.Quality.CheckRule.UnifyPoint).IsUnify0014(EpisodeID,Content,TemplateID)
/// ****************************************************************
ClassMethod IsUnify0014(EpisodeID As %String, Content As %String, TemplateID As %String) As %String
{
	s ret=0
	q:(EpisodeID="")||(Content="") ret
	s tmpTemplate=##Class(web.DHCEPRQQuality.BOACRExpBaseConfig).GetEPRTemIdListByCont(Content)
	q:tmpTemplate="" ret
	s ret=1,tmpID=""
	s:TemplateID'="" tmpID=$listget(TemplateID,1)
	q:(tmpID'="")&&($listfind(tmpTemplate,tmpID)=0) ret
	s DischDateTime=##Class(EPRservice.Quality.CommonHelper).GetDischDateTime(EpisodeID)
	s:DischDateTime="" ret=-1
	q ret
}
*/
/// Desc:	判断病案首页{死亡时间}与HIS{死亡时间}是否一致;
///     	判断死亡记录{死亡时间}与HIS{死亡时间}是否一致;
///     	判断24小时入院死亡记录{死亡时间}与HIS{死亡时间}是否一致;
/// 		两时间格式"2009-05-23 16:02:00",精确到小时,两时间相同;
/// Input:	AEpisodeID为患者就诊号;
/// 		AElement1为指定模板单元RowID; 
/// 		ADeathDateTime为死亡患者死亡日期时间;
/// Return:	ret<0:不一致; ret=1一致;
/// Debug:	w ##Class(EPRservice.Quality.CheckRule.UnifyPoint).IsUnify0015("","","")
ClassMethod IsUnify0015(AEpisodeID As %String, AElement1 As %String, ADeathDateTime As %String) As %String
{
	s ret = 0
	q:(AEpisodeID = "")||(AElement1 = "")||(ADeathDateTime = "") ret
	
	s elementData1 = ##Class(EPRservice.Quality.CheckRule.Template).GetSingleValues(AEpisodeID,AElement1)
	q:($e(elementData1,1,2) = "0^") ret
	s elementData1 = $e(elementData1,3,$l(elementData1))
	q:(elementData1 = "") ret
	
	s deathDateTime = ##Class(EPRservice.Quality.CommonHelper).ChangeDateTime(ADeathDateTime)
	
	s ret = 1
	if (deathDateTime '= "")
	{
		s:($p(elementData1," ",1) '= $p(deathDateTime," ",1)) ret = -1
		s:($p($p(elementData1," ",2),":",1) '= $p($p(deathDateTime," ",2),":",1)) ret = -1
		//s:($p($p(elementData1," ",2),":",2) '= $p($p(deathDateTime," ",2),":",2)) ret = -1
	}
	else
	{
		s:(elementData1 '= "") ret = -1
	}
	q ret
}

/// Desc:	判断病案首页{是否转科}与{转科科别}是否一致;
/// Input:	AEpisodeID为患者就诊号;
/// 		AElement1为指定是否转科模板单元RowID; 
/// 		AElement2为指定转科科别模板单元RowID; 
/// Return:	ret<0:不一致; ret=1一致;
/// Debug:	w ##Class(EPRservice.Quality.CheckRule.UnifyPoint).IsUnify0016(EpisodeID,Element1,Element2)
/// ****************************************************************
ClassMethod IsUnify0016(AEpisodeID As %String, AElement1 As %String, AElement2 As %String) As %String
{
	s ret = 0
	q:(AEpisodeID = "")||(AElement1 = "")||(AElement2 = "") ret
	
	s ElementData1 = ##Class(EPRservice.Quality.CheckRule.Template).GetSingleValues(AEpisodeID,AElement1)
	q:($e(ElementData1,1,2) = "0^") ret
	s ElementData1 = $e(ElementData1,3,$l(ElementData1))
	
	s ElementData2 = ##Class(EPRservice.Quality.CheckRule.Template).GetSingleValues(AEpisodeID,AElement2)
	q:($e(ElementData2,1,2) = "0^") ret
	s ElementData2 = $e(ElementData2,3,$l(ElementData2))
	
	q:(ElementData1 = "")&&(ElementData2 = "") ret
	
	s ElementData1 = ##Class(EPRservice.Quality.CommonHelper).ClearChar(ElementData1," -/")
	s ElementData2 = ##Class(EPRservice.Quality.CommonHelper).ClearChar(ElementData2," -/")
	
	s ret = 1
	if (ElementData1 = "是")
	{
		s:(ElementData2 = "")||(ElementData2 = "无")||(ElementData2 = "不详") ret = -1
	}
	else
	{
		s:(ElementData2 '= "")&&(ElementData2 '= "无")&&(ElementData2 '= "不详") ret = -1
	}
	
	q ret
}

/// Desc:	判断病案首页{是否院内感染}与{感染诊断}是否一致;
/// Input:	AEpisodeID为患者就诊号;
/// 		AElement1为指定是否院内感染模板单元RowID; 
/// 		AElement2为指定感染诊断模板单元RowID; 
/// Return:	ret<0:不一致; ret=1一致;
/// Debug:	w ##Class(EPRservice.Quality.CheckRule.UnifyPoint).IsUnify0017("","","")
ClassMethod IsUnify0017(AEpisodeID As %String, AElement1 As %String, AElement2 As %String) As %String
{
	s ret = 0
	q:(AEpisodeID = "")||(AElement1 = "")||(AElement2 = "") ret
	
	s ElementData1 = ##Class(EPRservice.Quality.CheckRule.Template).GetSingleValues(AEpisodeID,AElement1)
	q:($e(ElementData1,1,2) = "0^") ret
	s ElementData1 = $e(ElementData1,3,$l(ElementData1))
	
	s ElementData2 = ##Class(EPRservice.Quality.CheckRule.Template).GetSingleValues(AEpisodeID,AElement2)
	q:($e(ElementData2,1,2) = "0^") ret
	s ElementData2=$e(ElementData2,3,$l(ElementData2))
	
	q:(ElementData1="")&&(ElementData2="") ret
	
	s ElementData2 = ##Class(EPRservice.Quality.CommonHelper).ClearChar(ElementData2," -/")
	
	s ret = 1
	if (ElementData1 = "是")||(ElementData1 = "有")
	{
		s:(ElementData2 = "")||(ElementData2 = "无")||(ElementData2 = "不详") ret = -1
	}
	else
	{
		s:(ElementData2 '= "")&&(ElementData2 '= "无")&&(ElementData2 '= "不详") ret = -1
	}
	
	q ret
}

/// Desc:	判断病案首页{血型}与HIS{血型}是否一致;
/// Input:	AEpisodeID为患者就诊号;
/// 		AElement1为病案首页血型模板单元RowID; 
/// 		ABloodGroup为HIS血型; 
/// Return:	ret<0:不一致; ret=1一致;
/// Debug: 	w ##Class(EPRservice.Quality.CheckRule.UnifyPoint).IsUnify0018("","","")
ClassMethod IsUnify0018(AEpisodeID As %String, AElement1 As %String, ABloodGroup As %String) As %String
{
	s ret = 0
	q:(AEpisodeID = "")||(AElement1 = "")||(ABloodGroup = "") ret
	
	s ElementData1 = ##Class(EPRservice.Quality.CheckRule.Template).GetSingleValues(AEpisodeID,AElement1)
	q:($e(ElementData1,1,2) = "0^") ret
	s ElementData1 = $e(ElementData1,3,$l(ElementData1))
	
	s BloodGroup = $g(ABloodGroup)
	s ElementData1 = $tr(ElementData1,"型",""), BloodGroup = $tr(BloodGroup,"型","")
	s ElementData1 = $$ALPHAUP^SSUTIL4(ElementData1), BloodGroup = $$ALPHAUP^SSUTIL4(BloodGroup)
	
	s ret = 1
	if (BloodGroup = "A")||(BloodGroup = "B")||(BloodGroup = "AB")||(BloodGroup = "O")
	{
		s:(ElementData1 '= BloodGroup) ret = -1
	}
	else
	{
		s:(ElementData1 '= "")&&(ElementData1 '= "未查")&&(ElementData1 '= "其他") ret = -1
	}
	
	q ret
}

/// Desc:	病案首页{抢救次数}与HIS{抢救次数}不一致
/// 		病案首页{红细胞输血量}与HIS{红细胞输血量}不一致
///     	病案首页{血小板输血量}与HIS{血小板输血量}不一致
///     	病案首页{血浆输血量}与HIS{血浆输血量}不一致
///     	病案首页{全血输血量}与HIS{全血输血量}不一致
///     	病案首页{其它输血量}与HIS{其它输血量}不一致
/// Input:	AEpisodeID为患者就诊号;
/// 		AElement1为指定病案首页模板单元RowID; 
/// 		ACount为AElement1对应HIS中的参考数量; 
/// Return:	ret<0:不一致; ret=1一致;
/// Debug:	w ##Class(EPRservice.Quality.CheckRule.UnifyPoint).IsUnify0019("","","")
/// ****************************************************************
ClassMethod IsUnify0019(AEpisodeID As %String, AElement1 As %String, ACount As %String) As %String
{
	s ret = 0
	q:(AEpisodeID = "")||(AElement1 = "")||(ACount = "") ret
	
	s ElementData1 = ##Class(EPRservice.Quality.CheckRule.Template).GetSingleValues(AEpisodeID,AElement1)
	q:($e(ElementData1,1,2) = "0^") ret
	s ElementData1 = $e(ElementData1,3,$l(ElementData1))
	
	s ElementData1 = ##Class(EPRservice.Quality.CommonHelper).ClearChar(ElementData1," -/")
	s ElementData1 = $tr(ElementData1,"零","0")
	
	s ret = 1
	if (+ACount = 0)
	{
		s:(ElementData1 '= 0)&&(ElementData1 '= "")&&(ElementData1 '= "无") ret = -1
	}
	else
	{
		s:(ElementData1 '= ACount) ret = -1
	}
	
	q ret
}

/// Desc:	###此方法有待考虑###
/// 		病案首页{是否法定传染病}与病案首页{传染病是否上报}不一致
/// Return:	ret<0:不一致; ret=1一致;
/// Debug:	w ##Class(EPRservice.Quality.CheckRule.UnifyPoint).IsUnify0020("","","")
ClassMethod IsUnify0020(EpisodeID As %String, Element1 As %String, Element2 As %String) As %String
{
	s ret=0
	q:(EpisodeID="")||(Element1="")||(Element2="") ret
	s ElementData1=##Class(EPRservice.Quality.CheckRule.Template).GetSingleValues(EpisodeID,Element1)
	q:$e(ElementData1,1,2)="0^" ret
	s ElementData1=$e(ElementData1,3,$l(ElementData1))
	s ElementData2=##Class(EPRservice.Quality.CheckRule.Template).GetSingleValues(EpisodeID,Element2)
	q:$e(ElementData2,1,2)="0^" ret
	s ElementData2=$e(ElementData2,3,$l(ElementData2))
	q:(ElementData1="")&&(ElementData2="") ret
	s ret=1
	i ElementData1="是" d
	.s:(ElementData2="")||(ElementData2="否") ret=-1
	e  d
	.s:(ElementData2'="")&&(ElementData2'="否") ret=-1
	q ret
}

/// Desc:	###此方法有待考虑###(修正诊断很难在入院24小时内完成)
/// 		病案首页{入院诊断}与{修正诊断}不一致
///     	入院诊断中有"待诊"，"待查"，"?"、修正诊断内容不能为空;
/// Return:	ret<0:不一致; ret=1一致;
/// Debug:	w ##Class(EPRservice.Quality.CheckRule.UnifyPoint).IsUnify0021("","","")
ClassMethod IsUnify0021(EpisodeID As %String, Element1 As %String, Element2 As %String) As %String
{
	s ret=0
	q:(EpisodeID="")||(Element1="")||(Element2="") ret
	s ElementData1=##Class(EPRservice.Quality.CheckRule.Template).GetSingleValues(EpisodeID,Element1)
	q:$e(ElementData1,1,2)="0^" ret
	s ElementData1=$e(ElementData1,3,$l(ElementData1))
	s ElementData2=##Class(EPRservice.Quality.CheckRule.Template).GetSingleValues(EpisodeID,Element2)
	q:$e(ElementData2,1,2)="0^" ret
	s ElementData2=$e(ElementData2,3,$l(ElementData2))
	q:(ElementData1="")&&(ElementData2="") ret
	s ret=1
	i ((ElementData1["待诊")||(ElementData1["待查")||(ElementData1["?")||(ElementData1["？")) d
	.s:(ElementData2="")||(ElementData2="无")||(ElementData2="不详") ret=-1
	q ret
}

/// ****************************************************************
/// 注释：###此方法有待考虑### 修正诊断很难在入院24小时内完成
/// 说明: 病案首页{修正诊断}与{修正诊断签名}不一致
///     : 修正诊断非空修正诊断签名不能为空
///     : 病案首页{修正诊断}与{修正诊断日期}不一致
///     : 修正诊断非空修正诊断日期不能为空
/// 结论: ret<0 不一致
/// 调试: w ##Class(EPRservice.Quality.CheckRule.UnifyPoint).IsUnify0022(EpisodeID,Element1,Element2)
/// ****************************************************************
ClassMethod IsUnify0022(EpisodeID As %String, Element1 As %String, Element2 As %String) As %String
{
	s ret=0
	q:(EpisodeID="")||(Element1="")||(Element2="") ret
	s ElementData1=##Class(EPRservice.Quality.CheckRule.Template).GetSingleValues(EpisodeID,Element1)
	q:$e(ElementData1,1,2)="0^" ret
	s ElementData1=$e(ElementData1,3,$l(ElementData1))
	s ElementData2=##Class(EPRservice.Quality.CheckRule.Template).GetSingleValues(EpisodeID,Element2)
	q:$e(ElementData2,1,2)="0^" ret
	s ElementData2=$e(ElementData2,3,$l(ElementData2))
	q:(ElementData1="")&&(ElementData2="") ret
	s ret=1
	i (ElementData1'="")&&(ElementData1'="无")&&(ElementData1'="不详") d
	.s:(ElementData2="")||(ElementData2="无")||(ElementData2="不详") ret=-1
	q ret
}

/// ****************************************************************
/// 说明: 病案首页{国籍}与{住家地址}填写不一致
/// 结论: ret<0 不一致
/// 调试: w ##Class(EPRservice.Quality.CheckRule.UnifyPoint).IsUnify0023(EpisodeID,Element1,Element2)
/// ****************************************************************
ClassMethod IsUnify0023(EpisodeID As %String, Element1 As %String, Element2 As %String) As %String
{
	s ret=0
	q:(EpisodeID="")||(Element1="")||(Element2="") ret
	s ElementData1=##Class(EPRservice.Quality.CheckRule.Template).GetSingleValues(EpisodeID,Element1)
	q:$e(ElementData1,1,2)="0^" ret
	s ElementData1=$e(ElementData1,3,$l(ElementData1))
	s ElementData2=##Class(EPRservice.Quality.CheckRule.Template).GetSingleValues(EpisodeID,Element2)
	q:$e(ElementData2,1,2)="0^" ret
	s ElementData2=$e(ElementData2,3,$l(ElementData2))
	q:(ElementData1="")&&(ElementData2="") ret
	s ElementData2=##Class(EPRservice.Quality.CommonHelper).GetListFromString(ElementData2,"\")
	s ret=1
	i ElementData1="中国" d
	.s:$listlength(ElementData2)<1 ret=-1
	e  d
	.s:$listlength(ElementData2)>0 ret=-1
	q ret
}

/// ****************************************************************
/// 说明: 病案首页{住址医师、进修医师、实习医师、研究生实习医师}不能同时为空
/// 结论: ret<0 不一致
/// 调试: w ##Class(EPRservice.Quality.CheckRule.UnifyPoint).IsUnify0024(EpisodeID,Element1)
/// ****************************************************************
ClassMethod IsUnify0024(EpisodeID As %String, Element1 As %String) As %String
{
	s ret=0
	q:(EpisodeID="")||(Element1="") ret
	s ElementData1="",Count=1
	s ElementData1=##Class(EPRservice.Quality.CheckRule.Template).GetSingleValues(EpisodeID,Element1)
	q:$e(ElementData1,1,2)="0^" ret
	s ElementData1=$e(ElementData1,3,$l(ElementData1))
	//s ElementData1=##Class(EPRservice.Quality.CommonHelper).GetListFromString(ElementData1,"\")
	s ret=1
	//s:$listlength(ElementData1)<Count ret=-1
	s:(ElementData1="\\\") ret=-1
	q ret
}

/// ****************************************************************
/// 说明: 病案首页{死亡原因}与HIS{死亡时间}不一致
/// 结论: ret<0 不一致
/// 调试: w ##Class(EPRservice.Quality.CheckRule.UnifyPoint).IsUnify0025(EpisodeID,Element1,DeathDateTime)
/// ****************************************************************
ClassMethod IsUnify0025(EpisodeID As %String, Element1 As %String, DeathDateTime As %String) As %String
{
	s ret=0
	q:(EpisodeID="")||(Element1="") ret
	s ElementData1=##Class(EPRservice.Quality.CheckRule.Template).GetSingleValues(EpisodeID,Element1)
	q:$e(ElementData1,1,2)="0^" ret
	s ElementData1=$e(ElementData1,3,$l(ElementData1))
	s ret=1
	i DeathDateTime'="" d
	.s:(ElementData="")||(ElementData="无") ret=-1
	e  d
	.s:(ElementData'="")||(ElementData'="无") ret=-1
	q ret
}

/// ****************************************************************
/// 说明: 病案首页{输血反应}与HIS{输血医嘱}不一致
/// 结论: ret<0 不一致
/// 调试: w ##Class(EPRservice.Quality.CheckRule.UnifyPoint).IsUnify0026(EpisodeID,Element1,TransfuseTimes)
/// ****************************************************************
ClassMethod IsUnify0026(EpisodeID As %String, Element1 As %String, TransfuseTimes As %String) As %String
{
	s ret=0
	q:(EpisodeID="")||(Element1="") ret
	s ElementData1=##Class(EPRservice.Quality.CheckRule.Template).GetSingleValues(EpisodeID,Element1)
	q:$e(ElementData1,1,2)="0^" ret
	s ElementData1=$e(ElementData1,3,$l(ElementData1))
	s ret=1
	i TransfuseTimes>0 d
	.s:(ElementData="")||(ElementData="未输血")||(ElementData="未输") ret=-1
	e  d
	.s:(ElementData'="")&&(ElementData'="未输血")&&(ElementData'="未输") ret=-1
	q ret
}

/// ****************************************************************
/// 说明: 住院病历{是否吸烟}与{是否戒烟}填写不一致
/// 结论: ret<0 不一致
/// 调试: w ##Class(EPRservice.Quality.CheckRule.UnifyPoint).IsUnify0027(EpisodeID,Element1,Element2)
/// ****************************************************************
ClassMethod IsUnify0027(EpisodeID As %String, Element1 As %String, Element2 As %String) As %String
{
	s ret=0
	q:(EpisodeID="")||(Element1="")||(Element2="") ret
	s ElementData1=##Class(EPRservice.Quality.CheckRule.Template).GetSingleValues(EpisodeID,Element1)
	q:$e(ElementData1,1,2)="0^" ret
	s ElementData1=$e(ElementData1,3,$l(ElementData1))
	s ElementData2=##Class(EPRservice.Quality.CheckRule.Template).GetSingleValues(EpisodeID,Element2)
	q:$e(ElementData2,1,2)="0^" ret
	s ElementData2=$e(ElementData2,3,$l(ElementData2))
	q:(ElementData1="")&&(ElementData2="") ret
	s ret=1
	i (ElementData1="否")||(ElementData1="无")||(ElementData1="") d
	.s:(ElementData2="是")||(ElementData2="已")||(ElementData2="未") ret=-1
	q ret
}

/// ****************************************************************
/// 说明: 住院病历{是否吸烟/是否戒烟/是否饮酒}与{吸烟时间/戒烟时间/饮酒时间}填写不一致
/// 结论: ret<0 不一致
/// 调试: w ##Class(EPRservice.Quality.CheckRule.UnifyPoint).IsUnify0028(EpisodeID,Element1,Element2)
/// ****************************************************************
ClassMethod IsUnify0028(EpisodeID As %String, Element1 As %String, Element2 As %String) As %String
{
	s ret=0
	q:(EpisodeID="")||(Element1="")||(Element2="") ret
	s ElementData1=##Class(EPRservice.Quality.CheckRule.Template).GetSingleValues(EpisodeID,Element1)
	q:$e(ElementData1,1,2)="0^" ret
	s ElementData1=$e(ElementData1,3,$l(ElementData1))
	s ElementData2=##Class(EPRservice.Quality.CheckRule.Template).GetSingleValues(EpisodeID,Element2)
	q:$e(ElementData2,1,2)="0^" ret
	s ElementData2=$e(ElementData2,3,$l(ElementData2))
	q:(ElementData1="")&&(ElementData2="") ret
	s ElementData2=##Class(EPRservice.Quality.CommonHelper).ClearChar(ElementData2," -/无")
	s ret=1
	i (ElementData1="")||(ElementData1="无")||(ElementData1="否") d
	.s:(ElementData2'=0)&&(ElementData2'="")&&(ElementData2'="无") ret=-1
	e  d
	.s:(ElementData2=0)||(ElementData2="")||(ElementData2="无") ret=-1
	q ret
}

/// ****************************************************************
/// 说明: 住院病历{是否吸烟/是否饮酒}与{吸烟平均数/饮酒平均数}填写不一致
/// 结论: ret<0 不一致
/// 调试: w ##Class(EPRservice.Quality.CheckRule.UnifyPoint).IsUnify0029(EpisodeID,Element1,Element2)
/// ****************************************************************
ClassMethod IsUnify0029(EpisodeID As %String, Element1 As %String, Element2 As %String) As %String
{
	s ret=0
	q:(EpisodeID="")||(Element1="")||(Element2="") ret
	s ElementData1=##Class(EPRservice.Quality.CheckRule.Template).GetSingleValues(EpisodeID,Element1)
	q:$e(ElementData1,1,2)="0^" ret
	s ElementData1=$e(ElementData1,3,$l(ElementData1))
	s ElementData2=##Class(EPRservice.Quality.CheckRule.Template).GetSingleValues(EpisodeID,Element2)
	q:$e(ElementData2,1,2)="0^" ret
	s ElementData2=$e(ElementData2,3,$l(ElementData2))
	q:(ElementData1="")&&(ElementData2="") ret
	s ElementData2=##Class(EPRservice.Quality.CommonHelper).ClearChar(ElementData2," -/")
	s ret=1
	i (ElementData1="")||(ElementData1="无")||(ElementData1="否") d
	.s:(ElementData2'=0)&&(ElementData2'="")&&(ElementData2'="无") ret=-1
	e  d
	.s:(ElementData2=0)||(ElementData2="")||(ElementData2="无") ret=-1
	q ret
}

/// ****************************************************************
/// 说明: 住院病历{父亲状态/母亲状态}与{父亲死因/母亲死因}填写不一致
/// 结论: ret<0 不一致
/// 调试: w ##Class(EPRservice.Quality.CheckRule.UnifyPoint).IsUnify0030(EpisodeID,Element1,Element2)
/// ****************************************************************
ClassMethod IsUnify0030(EpisodeID As %String, Element1 As %String, Element2 As %String) As %String
{
	s ret=0
	q:(EpisodeID="")||(Element1="")||(Element2="") ret
	s ElementData1=##Class(EPRservice.Quality.CheckRule.Template).GetSingleValues(EpisodeID,Element1)
	q:$e(ElementData1,1,2)="0^" ret
	s ElementData1=$e(ElementData1,3,$l(ElementData1))
	s ElementData2=##Class(EPRservice.Quality.CheckRule.Template).GetSingleValues(EpisodeID,Element2)
	q:$e(ElementData2,1,2)="0^" ret
	s ElementData2=$e(ElementData2,3,$l(ElementData2))
	q:(ElementData1="")&&(ElementData2="") ret
	s ElementData2=##Class(EPRservice.Quality.CommonHelper).ClearChar(ElementData2," -/")
	s ret=1
	i (ElementData1="死亡")||(ElementData1="已故") d
	.s:(ElementData2="")||(ElementData2="无") ret=-1
	e  d
	.s:(ElementData2'="")&&(ElementData2'="无") ret=-1
	q ret
}

/// ****************************************************************
/// 说明: 住院病历{父亲状态/母亲状态}与{父亲所患疾病/母亲所患疾病}填写不一致
/// 
/// 结论: ret<0 不一致
/// 
/// 调试: w ##Class(EPRservice.Quality.CheckRule.UnifyPoint).IsUnify0031(EpisodeID,Element1,Element2)
/// ****************************************************************
ClassMethod IsUnify0031(EpisodeID As %String, Element1 As %String, Element2 As %String) As %String
{
	s ret=0
	q:(EpisodeID="")||(Element1="")||(Element2="") ret
	s ElementData1=##Class(EPRservice.Quality.CheckRule.Template).GetSingleValues(EpisodeID,Element1)
	q:$e(ElementData1,1,2)="0^" ret
	s ElementData1=$e(ElementData1,3,$l(ElementData1))
	s ElementData2=##Class(EPRservice.Quality.CheckRule.Template).GetSingleValues(EpisodeID,Element2)
	q:$e(ElementData2,1,2)="0^" ret
	s ElementData2=$e(ElementData2,3,$l(ElementData2))
	q:(ElementData1="")&&(ElementData2="") ret
	s ElementData2=##Class(EPRservice.Quality.CommonHelper).ClearChar(ElementData2," -/")
	s ret=1
	i ElementData1="患病" d
	.s:(ElementData2="")||(ElementData2="无") ret=-1
	e  d
	.s:(ElementData2'="")&&(ElementData2'="无") ret=-1
	q ret
}

/// ****************************************************************
/// 说明: 病案首页{临床与病理 + 放射与病理}与病案首页{病理诊断}不一致
/// 结论: ret<0 不一致
/// 调试: w ##Class(EPRservice.Quality.CheckRule.UnifyPoint).IsUnify0032(EpisodeID,Elements1,Element2)
/// ****************************************************************
ClassMethod IsUnify0032(EpisodeID As %String, Element1 As %String, Element2 As %String) As %String
{
	s ret=0
	q:(EpisodeID="")||(Element1="")||(Element2="") ret
	s ElementData1=##Class(EPRservice.Quality.CheckRule.Template).GetSingleValues(EpisodeID,Element1)
	q:$e(ElementData1,1,2)="0^" ret
	s ElementData1=$e(ElementData1,3,$l(ElementData1))
	s ElementData2=##Class(EPRservice.Quality.CheckRule.Template).GetSingleValues(EpisodeID,Element2)
	q:$e(ElementData2,1,2)="0^" ret
	s ElementData2=$e(ElementData2,3,$l(ElementData2))
	
	//wwt Comments
	//q:(ElementData1="")&&(ElementData2="") ret
	//wwt update 20100716
	s trElementData1=$tr(ElementData1," "),trElementData1=$tr(trElementData1,"\")
	q:(trElementData1="")&&(ElementData2="") ret
	//wwt end
	
	s ElementData2=##Class(EPRservice.Quality.CommonHelper).ClearChar(ElementData2," /-")
	s ElementData1=##Class(EPRservice.Quality.CommonHelper).GetListFromString(ElementData1,"\")
	s ret=1
	i (ElementData2="无")||(ElementData2="不详")||(ElementData2="") d
	.f Ind=1:1:$listlength(ElementData1) d
	..s tmp=$listget(ElementData1,Ind)
	..s:(tmp'="未做")&&(tmp'="") ret=-1
	e  d
	.s:($listfind(ElementData1,"符合")=0)&&($listfind(ElementData1,"不符合")=0)&&($listfind(ElementData1,"不肯定")=0) ret=-1
	q ret
}

/// Desc:	抢救记录无上级医师意见及参加抢救的医务人员姓名及专业技术职务;
///     	抢救记录内容包含副主任医师,副教授,主任医师,教授,副主任,主任字样;
/// Input:	AEpisodeID为患者就诊号;
/// 		AElement1为节目模板单元RowID;
/// 		ATitles为日常病程记录标题,多个以"#"分隔;
/// 		AKeyWords为关键字,多个以"#"分隔;
/// Return: ret<0 不一致
/// Debug:	w ##Class(EPRservice.Quality.CheckRule.UnifyPoint).IsUnify0033("2408173","E9787","抢救记录#首次查房记录","主任#教授")
ClassMethod IsUnify0033(AEpisodeID As %String, AElement1 As %String, ATitles As %String, AKeyWords As %String) As %String
{
	s ret = 0
	q:(AEpisodeID = "")||(AElement1 = "") ret
	
	s lstTitles = ##Class(EPRservice.Quality.CommonHelper).GetListFromString(ATitles,"#")
	q:($listlength(lstTitles) = 0) ret
	
	s lstKeyWords = ##Class(EPRservice.Quality.CommonHelper).GetListFromString(AKeyWords,"#")
	q:($listlength(lstKeyWords) = 0) ret
	
	s ret = 1
	s result = ##Class(%ResultSet).%New("EPRservice.Quality.DataGather.EPRInfo:GetInstanceData")
	s sc = result.Execute(AEpisodeID, $e(AElement1,2,$l(AElement1))) 
	While (result.Next()) 
	{
		s (Title,InstanceID,HappendDate,HappenTime) = ""
		
		s Title = result.Data("Title")
		s InstanceID = result.Data("InstanceID")
		s HappenDate = result.Data("HappenDate")
		s HappenTime = result.Data("HappenTime")
		
		s flag = ##Class(EPRservice.Quality.CommonHelper).CheckItemExistInList(lstTitles,Title,1)
		continue:(flag = -1)
		
		s ElementData1 = ##Class(EPRservice.Quality.CheckRule.Template).GetMultipleValues(AEpisodeID,AElement1,InstanceID)
		continue:($e(ElementData1,1,2) = "0^")
		
		s lstElementData = $e(ElementData1,3,$l(ElementData1))
		s flag = ..CheckListContainsKeyWords(lstElementData,lstKeyWords)
		if (flag < 0)
		{
			s KeyWords = $tr(AKeyWords,"#","或")
			s ret = -1_"^"_"标题为"_Title_"并且发生日期为"_HappenDate_" "_HappenTime_"的病程记录没有包含"_KeyWords_"关键字"
			q	
		}
	}
	q ret
}

/// Desc:	判断某列表中每一项是否包含至少一个指定的关键字;
/// Input:	ADataList为指定的数据列表;
/// 		AKeyWords为指定的关键字列表;
/// Return:	ret=1存在; ret=-1不存在;
/// Debug:	s dataList = $lb("abc","dbc","ebc")
/// 		s keyWords = $lb("bc","eg")
/// 		w ##Class(EPRservice.Quality.CheckRule.UnifyPoint).CheckListContainsKeyWords(dataList,keyWords)
ClassMethod CheckListContainsKeyWords(ADataList As %List, AKeyWords As %List) As %String
{
	s ret = 1
	
	for i = 1:1:$listlength(ADataList)
	{
		s Data = $listget(ADataList,i)
		continue:(Data = "")
		
		s Count = 0
		for j = 1:1:$listlength(AKeyWords)
		{
			s KeyWord = $listget(AKeyWords,j)
			continue:(KeyWord = "")
			
			if (Data [ KeyWord)
			{
				s Count = Count + 1
			}	
		}
		
		if (Count = 0)
		{
			s ret = -1
			q	
		}	
	}
	
	q ret
}

/// Desc: 	判断身份证号与出生日期的一致性;
/// Input:	AEpisodeID为患者就诊号;
/// 		AElement1为身份证号模板单元RowID;
/// 		AElement2为出生日期模板单元RowID;
/// Output:	ret<0:不一致; ret=1一致;
/// Debug:	w ##Class(EPRservice.Quality.CheckRule.UnifyPoint).IsUnify0034("201871","E148","E144")
ClassMethod IsUnify0034(AEpisodeID As %String, AElement1 As %String, AElement2 As %String) As %String
{
	s ret = 0
	q:($d(AEpisodeID) = 0)||($d(AElement1) = 0)||($d(AElement2) = 0) ret
	q:(AEpisodeID = "")||(AElement1 = "")||(AElement2 = "") ret
	
	s ElementData1 = ##Class(EPRservice.Quality.CheckRule.Template).GetSingleValues(AEpisodeID,AElement1)
	q:($e(ElementData1,1,2) = "0^") ret
	s ElementData1 = $e(ElementData1,3,$l(ElementData1))
	
	s ElementData2 = ##Class(EPRservice.Quality.CheckRule.Template).GetSingleValues(AEpisodeID,AElement2)
	q:($e(ElementData2,1,2) = "0^") ret
	s ElementData2=$e(ElementData2,3,$l(ElementData2))
	
	if (ElementData2 [ "年") 
	{
		s ElementData2 = $tr(ElementData2,"年","-")
		s ElementData2 = $tr(ElementData2,"月","-")
		s ElementData2 = $tr(ElementData2,"日","")	
	}
	s ElementData2 = $zdate($zdh(ElementData2,3),8)
	
	s ret = -1
	s:(ElementData1 [ ElementData2) ret = 1
	q ret
}

/// Desc：判断单元字数及行数(不能超过给定字数及行数）
/// Creator：Candyxu
/// CreatDate:2013-1-15
/// Input:AEpisodeID 就诊号，
/// AElement 质控单元号，
/// AWordCount 单元总字数，
/// AWordRowCount 每行字数，
/// ARowsCount 行数
/// AInstanceID 如果是可重复模板，则需要传入InstanceID
/// OutPut:ret 0 不检查参数有误，-1触犯条目，1检查通过
/// Debuge:w ##Class(EPRservice.Quality.CheckRule.UnifyPoint).IsUnify0035(2462001,"E6849",80,3,3,"")
ClassMethod IsUnify0035(AEpisodeID As %String, AElement As %String, AWordCount As %String, AWordRowCount As %String = "", ARowsCount As %String = "", AInstanceID As %String = "") As %String
{
   s ret = 0
   q:((AEpisodeID = "")||(AElement = "")) ret
   s ret = 1
   s ElementData = ##Class(EPRservice.Quality.CheckRule.Template).GetSingleValues(AEpisodeID,AElement,AInstanceID)
   s ElementData = $p(ElementData,"^",2)
   s ^QualityElementData = ElementData
   s WordCount = $L(ElementData)
   q:( WordCount > AWordCount ) -1
   //根据回车换行判断字数
   if ((AWordRowCount '= "") && (ARowsCount '= ""))
   {
	   s ^QualityElementData = $tr(^QualityElementData,$C(10),$C(13))
	   s ^QualityElementData = $tr(^QualityElementData,$C(13,10),$C(13))
	   s EnterData = ##Class(EPRservice.Quality.CommonHelper).GetListFromString(^QualityElementData,$C(13))
       s TotalCount = 0
       s ^TempEnterData = EnterData
       s ^EnterDataCount = $listlength(EnterData)
       for I=1:1:$listlength(EnterData)
       {
	       s maxCount = $l($listget(EnterData,I))/AWordRowCount
	       s minCount = $l($listget(EnterData,I))\AWordRowCount
	       s TempCount = minCount
	       s:(maxCount > minCount) TempCount = minCount + 1
	       s TotalCount = TotalCount + TempCount
	   }
	   s:(TotalCount > ARowsCount) ret = -1
	   q:(ret = -1) ret
   }
   q ret
}

/// Desc:判断I单元描述值与字典描述是否一致
/// Input:AEpisodeID 就诊号 
/// AElement 质控模板元素ID
/// AInstanceID 如果是可重复模板，则需要传入InstanceID
/// ADicCode 字典代码 电子病历字典维护表 代码
/// Debug:w ##Class(EPRservice.Quality.CheckRule.UnifyPoint).IsUnify0036()
ClassMethod IsUnify0036(AEpisodeID As %String, AElement As %String, AInstanceID As %String = "", ADicCode As %String)
{
   s ret = 0
   q:((AEpisodeID = "")||(AElement = "")) ret
   s ret = 1
   
   s ElementData = ##Class(EPRservice.Quality.CheckRule.Template).GetSingleValues(AEpisodeID,AElement,AInstanceID)
   q:($p(ElementData,"^",1) '= 1) ret
   s DataDesc = $p(ElementData,"^",2)
   q:(DataDesc = "") ret
   
   s AElement = "EC"_$p(AElement,"E",2)
   s ElementCode = ##Class(EPRservice.Quality.CheckRule.Template).GetSingleValues(AEpisodeID,AElement,AInstanceID)
   q:($p(ElementCode,"^",1) '= 1) ret
   s DataCode = $p(ElementCode,"^",2)
   //字典表中的描述
   s relDataDesc = ##Class(EPRservice.Quality.DataGather.EPRInfo).GetDictionaryByCode(ADicCode,DataCode)
   q:(relDataDesc = "") ret
   
   s:(DataDesc '= relDataDesc) ret = -1
   
   q ret _"^"_"字典表描述值："_relDataDesc_" 修改后描述值："_DataDesc
}

/// Desc:	计算住院天数并提示;
/// Input:	AEpisodeID为患者就诊号;
/// 		AElement1为入院日期模板单元RowID;
/// 		AElement2为出院日期模板单元RowID;
/// Return:	ret<=0 不一致; ret=1一致;
/// Debug:	w ##Class(EPRservice.Quality.CheckRule.UnifyPoint).IsUnify0037("","","")
ClassMethod IsUnify0037(AEpisodeID As %String, AElement1 As %String, AElement2 As %String) As %String
{
	s ret = 0
	q:(AEpisodeID = "")||(AElement1 = "")||(AElement2 = "") ret
	
	s ElementData1 = ##Class(EPRservice.Quality.CheckRule.Template).GetSingleValues(AEpisodeID,AElement1)
	q:($e(ElementData1,1,2) = "0^") ret
	s ElementData1=$e(ElementData1,3,$l(ElementData1))
	//为日期格式转换Cache格式
	if ($l(ElementData1,"年")>1)
	{
		s ElementData1 = ##Class(EPRservice.Quality.CommonHelper).ChangeDateTime(ElementData1)
		s ElementData1 = $p(ElementData1," ",1)
		s ElementData1 = $zdh(ElementData1,3) }
	
	s ElementData2 = ##Class(EPRservice.Quality.CheckRule.Template).GetSingleValues(AEpisodeID,AElement2)
	q:($e(ElementData2,1,2) = "0^") ret	
	s ElementData2 = $e(ElementData2,3,$l(ElementData2))	
	//为日期格式转换Cache格式
	if ($l(ElementData2,"年")>1)
	{
		s ElementData2 = ##Class(EPRservice.Quality.CommonHelper).ChangeDateTime(ElementData2)
		s ElementData2 = $p(ElementData2," ",1)
		s ElementData2 = $zdh(ElementData2,3) }
	
	q:(ElementData1 = "")&&(ElementData2 = "") ret
	
	s InDays = ElementData2-ElementData1
	if (InDays=0) { s InDays=1 }
	s ret="0"_"^"_InDays_"天，请确认!"	
	q ret
}

/// Desc:	判断在病历中患者身份证信息与出生日期是否一致;
/// Input:	AEpisodeID为患者就诊号;
/// 		AElement1为身份证模板单元RowID;
/// 		AElement2为出生日期模板单元RowID;
/// Return:	ret<=0 不一致; ret=1一致;
/// Debug:	w ##Class(EPRservice.Quality.CheckRule.UnifyPoint).IsUnify0036("","","")
ClassMethod IsUnify0038(AEpisodeID As %String, AElement1 As %String, AElement2 As %String) As %String
{
	s ret = 0
	q:(AEpisodeID = "")||(AElement1 = "")||(AElement2 = "") ret
	
	s ElementData1 = ##Class(EPRservice.Quality.CheckRule.Template).GetSingleValues(AEpisodeID,AElement1)
	q:($e(ElementData1,1,2) = "0^") ret
	s ElementData1=$e(ElementData1,3,$l(ElementData1))
	//身份证号不是18位则退出
	q:($l(ElementData1)'=18) ret
	
	s ElementData2 = ##Class(EPRservice.Quality.CheckRule.Template).GetSingleValues(AEpisodeID,AElement2)
	q:($e(ElementData2,1,2) = "0^") ret	
	s ElementData2 = $e(ElementData2,3,$l(ElementData2))
	
	q:(ElementData1 = "")&&(ElementData2 = "") ret
	
	//获取身份证上的年月日得到比如19880808
	s TempValue=""
	for i=7:1:14 {
	  s tmpChar=$e(ElementData1,i,i)
	  s TempValue=TempValue_tmpChar
	}
	
	//处理出生日期格式得到比如19880808
	s DateTime2 = ##Class(EPRservice.Quality.CommonHelper).ChangeDateTime(ElementData2)	
	s DateTime2=$p(DateTime2," ",1)
	s DateTime2 = $tr(DateTime2,"-","")
	s ret = 1	
	if (TempValue '=DateTime2) { s ret = -1	}
	q ret
}

/// Desc：判断单元字数及行数(不能少于给定字数及行数）
/// Creator：Lifb
/// CreatDate:2013-09-13
/// Input:AEpisodeID 就诊号，
/// AElement 质控单元号，
/// AWordCount 单元总字数，
/// AWordRowCount 每行字数，
/// ARowsCount 行数
/// AInstanceID 如果是可重复模板，则需要传入InstanceID
/// OutPut:ret 0 不检查参数有误，-1触犯条目，1检查通过
/// Debuge:w ##Class(EPRservice.Quality.CheckRule.UnifyPoint).IsUnify0035(2462001,"E6849",80,3,3,"")
ClassMethod IsUnify0039(AEpisodeID As %String, AElement As %String, AWordCount As %String, AWordRowCount As %String = "", ARowsCount As %String = "", AInstanceID As %String = "") As %String
{
   s ret = 0
   q:((AEpisodeID = "")||(AElement = "")) ret
   s ret = 1
   s ElementData = ##Class(EPRservice.Quality.CheckRule.Template).GetSingleValues(AEpisodeID,AElement,AInstanceID)
   s ElementData = $p(ElementData,"^",2)
   s ^QualityElementData = ElementData
   s WordCount = $L(ElementData)
   q:( WordCount < AWordCount ) -1
   //根据回车换行判断字数
   if ((AWordRowCount '= "") && (ARowsCount '= ""))
   {
	   s ^QualityElementData = $tr(^QualityElementData,$C(10),$C(13))
	   s ^QualityElementData = $tr(^QualityElementData,$C(13,10),$C(13))
	   s EnterData = ##Class(EPRservice.Quality.CommonHelper).GetListFromString(^QualityElementData,$C(13))
       s TotalCount = 0
       s ^TempEnterData = EnterData
       s ^EnterDataCount = $listlength(EnterData)
       for I=1:1:$listlength(EnterData)
       {
	       s maxCount = $l($listget(EnterData,I))/AWordRowCount
	       s minCount = $l($listget(EnterData,I))\AWordRowCount
	       s TempCount = minCount
	       s:(maxCount > minCount) TempCount = minCount + 1
	       s TotalCount = TotalCount + TempCount
	   }
	   s:(TotalCount < ARowsCount) ret = -1
	   q:(ret = -1) ret
   }
   q ret
}

/// ****************************************************************
/// 说明: 同一模板中多元素一致性判断，当Element1为Values1中任意各值，Elements2中各元素有任何一个为Value2时触发
/// 		Element1,Value2为单值；Values1和Elements2为多值
/// lxf
/// 结论: ret<0 
/// 
/// 调试: w ##Class(EPRservice.Quality.CheckRule.UnifyPoint).IsUnify(EpisodeID,Element1,Elements2,Values1,Value2)
/// ****************************************************************
ClassMethod IsUnify(EpisodeID As %String, Element1 As %String, Elements2 As %String, Values1 As %String, Value2 As %String) As %String
{
	s ret=0
	q:(EpisodeID="")||(Element1="")||(Elements2="") ret
	
	s ret=1
	s ElementData1=##Class(EPRservice.Quality.CheckRule.Template).GetSingleValues(EpisodeID,Element1)
	q:$e(ElementData1,1,2)="0^" ret
	s ElementData1=$e(ElementData1,3,$l(ElementData1))
	//w "ElementData1="_ElementData1,!
	 
	s ret=2
	s Elements2Data=##Class(EPRservice.Quality.CheckRule.Template).GetSingleValues(EpisodeID,Elements2)
	q:$e(Elements2Data,1,2)="0^"
	s Elements2Data=$e(Elements2Data,3,$l(Elements2Data))
	//w "Elements2Data="_Elements2Data,!
	
	s ret=3
	f i=1:1:$l(Elements2Data,"\") d
	.s ElementData2=$p(Elements2Data,"\",i)
	.//w "ElementData2="_ElementData2,!
	.f j=1:1:$l(Values1,"\") d
	..s Value1=$p(Values1,"\",j)		//循环Values1中包含的每一个值
	..i ElementData1=Value1 d
	...s:(ElementData2=Value2) ret=-1

	q ret
}

/// Desc:	判断病案首页单条手术录入完整性;
/// Input:	AEpisodeID为患者就诊号;
/// 		AOperDescElement为某条手术中手术名称模板单元RowID;
/// 		AOtherElements为某条手术模板单元RowID字符串,多个以"\"分隔;
/// Output:	ret<0:不一致; ret=1一致;
/// Debug:	w ##Class(EPRservice.Quality.CheckRule.UnifyPoint).IsOperUnify(EpisodeID,OperDescElement,OtherElements)
ClassMethod IsOperUnify(AEpisodeID As %String, AOperDescElement As %String, AOtherElements As %String) As %String
{
	s ret = 0
	q:(AEpisodeID = "")||(AOperDescElement = "")||(AOtherElements = "") ret
	
	s OperDescData = ##Class(EPRservice.Quality.CheckRule.Template).GetSingleValues(AEpisodeID,AOperDescElement)
	q:($e(OperDescData,1,2) = "0^") ret
	s OperDescData = $e(OperDescData,3,$l(OperDescData))
	q:(OperDescData = "") ret
	
	//如果手术名称填无,则不检查其他项目
	s ret = 1
	s OperDescData = $tr(OperDescData," ","")
	q:(OperDescData = "无") ret 			
	
	s ret = 0
	s AllElements = AOperDescElement_"\"_AOtherElements
	s AllElementsData = ##Class(EPRservice.Quality.CheckRule.Template).GetSingleValues(AEpisodeID,AllElements)
	q:($e(AllElementsData,1,2) = "0^") ret
	s AllElementsData = $e(AllElementsData,3,$l(AllElementsData))
	q:(AllElementsData = "") ret
	
	s ret = 1
	s isNullFlag = "N"
	for i = 1:1:$l(AllElementsData,"\")
	{
		s ElementData = $p(AllElementsData,"\",i)
		if (ElementData = "") 
		{
			s isNullFlag = "Y"
			q
		}
	}
	
	s:(IsNullFlag = "Y") ret = -1
	q ret
}

/// ****************************************************************
/// 说明: 病案首页{日期单元:手术日期等}不允许小于入院日期、超出入出院时间
/// modify:hanxf 20130802;出院日期可取模板上医生填写的出院日期单元AElement2
/// 		(只按照日期判断，不参照具体时间，适用于没有具体时间的元素，如果有具体时间，使用IsUnify0006)
/// lxf
/// 结论: ret<0 不一致
/// 
/// 调试: w ##Class(EPRservice.Quality.CheckRule.UnifyPoint).IsOperDateUnify(EpisodeID,Element1,RegDate,DischDate)
/// ****************************************************************
ClassMethod IsOperDateUnify(EpisodeID As %String, Element1 As %String, RegDate As %String, DischDate As %String, AElement2 As %String = "") As %String
{
	s ret=0
	//q:(EpisodeID="")||(Element1="")||(RegDate="")||(DischDate="") ret
	q:(EpisodeID="")||(Element1="")||(RegDate="") ret
	s:DischDate="" DischDate=$zd(+$h,3)
	s ElementData1=##Class(EPRservice.Quality.CheckRule.Template).GetSingleValues(EpisodeID,Element1)
	q:$e(ElementData1,1,2)="0^" ret
	s ElementData1=$e(ElementData1,3,$l(ElementData1))
	
	s ElementData1=$tr(ElementData1,"年","-")
	s ElementData1=$tr(ElementData1,"月","-")
	s ElementData1=$tr(ElementData1,"日","")
	
	s ElementData1=$zdh(ElementData1,3)
	s RegDate=$zdh($p(RegDate," ",1),3)
	s DischDate=$zdh($p(DischDate," ",1),3)
	s ret=1
	s:(ElementData1<RegDate)||(ElementData1>DischDate) ret=-1
	
	//Add Hanxf
	if (AElement2 '= "")
	{
	  s ElementData2 = ##Class(EPRservice.Quality.CheckRule.Template).GetSingleValues(AEpisodeID,AElement2)
	  q:($e(ElementData2,1,2) = "0^") ret
	  s ElementData2 = $e(ElementData2,3,$l(ElementData2))
	  q:(ElementData2 = "") ret	
	  s ElementData2=$tr(ElementData2,"年","-")
	  s ElementData2=$tr(ElementData2,"月","-")
	  s ElementData2=$tr(ElementData2,"日","")
	  
	  s ElementData2=$zdh(ElementData2,3)
	  s:(ElementData1<RegDate)||(ElementData1>ElementData2) ret=-1
	}
	//end add
	
	q ret
}

/// ****************************************************************
/// 说明: 页面某一元素(或多元素)不能为某一值(或多值)
/// lxf
/// 结论: ret<0 不一致
/// 
/// 调试: w ##Class(EPRservice.Quality.CheckRule.UnifyPoint).IsUnifyCanNotBe(EpisodeID,Elements,Values)
/// ****************************************************************
ClassMethod IsUnifyCanNotBe(EpisodeID As %String, Elements As %String, Values As %String) As %String
{
	s ret=0
	q:(EpisodeID="")||(Elements="")||(Values="") ret

	s ret=1
	s ElementsData=##Class(EPRservice.Quality.CheckRule.Template).GetSingleValues(EpisodeID,Elements)

	q:$e(ElementsData,1,2)="0^" ret
	s ElementsData=$e(ElementsData,3,$l(ElementsData))
	//w "ElementsData="_ElementsData,!
	
	s ret=2
	f i=1:1:$l(ElementsData,"\") d
	.s ElementData=$p(ElementsData,"\",i)
	.f j=1:1:$l(Values,"\") d
	..s Value=$p(Values,"\",j)
	..s Value=$tr(Value," ","")
	..s:ElementData=Value ret=-1 
	..//w "ElementData="_ElementData_"//////Value="_Value,!

	q ret
}

/// ****************************************************************
/// 说明: 同一模板中两元素一致性判断，当Element1*不为*Value1时，Element2元素*为*Value2时触发(前非后肯)
/// 		如：当病案首页.出院情况.医院感染诊断 不为 "无"时，出院情况医院感染诊断不能为空
/// lxf
/// 结论: ret<0 
/// 调试: w ##Class(EPRservice.Quality.CheckRule.UnifyPoint).IsUnifyFK(EpisodeID,Element1,Element2,Value1,Value2)
/// ****************************************************************
ClassMethod IsUnifyFK(EpisodeID As %String, Element1 As %String, Element2 As %String, Value1 As %String, Value2 As %String, Value3 As %String = "") As %String
{
	s ret=0
	q:(EpisodeID="")||(Element1="")||(Element2="") ret
	
	s ret=1
	s ElementData1=##Class(EPRservice.Quality.CheckRule.Template).GetSingleValues(EpisodeID,Element1)
	q:$e(ElementData1,1,2)="0^" ret
	s ElementData1=$e(ElementData1,3,$l(ElementData1))
	//w "ElementData1="_ElementData1,!
	 
	s ret=2
	s ElementData2=##Class(EPRservice.Quality.CheckRule.Template).GetSingleValues(EpisodeID,Element2)
	q:$e(ElementData2,1,2)="0^"
	s ElementData2=$e(ElementData2,3,$l(ElementData2))
	//w "ElementData2="_ElementData2,!
	s ElementData1=$tr(ElementData1," ","")
	s ElementData2=$tr(ElementData2," ","")
	
	s ret=3
	q:(ElementData1="")&&(ElementData2="") ret			//Element1为空时不检查，非空由完整性规则去判断
	s:(ElementData1'=Value1)&&(ElementData2=Value2) ret=-1
	//s:(ElementData1'="无")&&(ElementData2="") ret=-1
	i ($f(Value3,"TWOWAY")'=0)
	{
		s:(ElementData1=Value1)&&(ElementData2'=Value2) ret=-1
	}
	i ($f(Value3,"NULL")'=0)
	{
		s:(ElementData1="")&&(ElementData2'=Value2) ret=-1
	}
	q ret
}

/// ****************************************************************
/// 说明: 同一模板中两元素一致性判断，当Element1*不为*Value1时，Elements2中元素*不为*Value2时触发(前非后非)
/// 		如：.病案首页.一般情况.医疗付款方式 不为 "社会基本医疗保险"时,医保号必须为"无"
/// 			注：Elements2为多值
/// lxf
/// 结论: ret<0 
/// 调试: w ##Class(EPRservice.Quality.CheckRule.UnifyPoint).IsUnifyFF(EpisodeID,Element1,Element2,Value1,Value2)
/// ****************************************************************
ClassMethod IsUnifyFF(EpisodeID As %String, Element1 As %String, Elements2 As %String, Value1 As %String, Value2 As %String) As %String
{
	s ret=0
	q:(EpisodeID="")||(Element1="")||(Elements2="") ret
	
	s ret=1
	s ElementData1=##Class(EPRservice.Quality.CheckRule.Template).GetSingleValues(EpisodeID,Element1)
	q:$e(ElementData1,1,2)="0^" ret
	s ElementData1=$e(ElementData1,3,$l(ElementData1))
	//w "ElementData1="_ElementData1,!
	s ElementData1=$tr(ElementData1," ","")
	q:ElementData1="" ret			//Element1为空时不检查，非空由完整性规则去判断
	
	s ret=2
	s ElementsData2=##Class(EPRservice.Quality.CheckRule.Template).GetSingleValues(EpisodeID,Elements2)
	q:$e(ElementsData2,1,2)="0^"
	s ElementsData2=$e(ElementsData2,3,$l(ElementsData2))
	//w "ElementData2="_ElementData2,!
	s ElementsData2=$tr(ElementsData2," ","")
	
	s ret=3
	f i=1:1:$l(ElementsData2,"\") d
	.s ElementData2=$p(ElementsData2,"\",i)
	.s:(ElementData1'=Value1)&&(ElementData2'=Value2) ret=-1
	.//s:(ElementData1'="社会基本医疗保险")&&(ElementData2'="无") ret=-1
	.//w "ElementData="_ElementData_"//////Value="_Value,!
	q ret
}

/// ****************************************************************
/// 说明: 同一模板中两元素一致性判断，当Element1*为*Value1时，Element2元素*不为*Value2时触发(前肯后非)
/// 		如：入院记录.颈部(普通外科).甲状腺 为"异常"时,则该单元必须为"详见专科检查"
/// lxf
/// 结论: ret<0 
/// 调试: w ##Class(EPRservice.Quality.CheckRule.UnifyPoint).IsUnifyKF(EpisodeID,Element1,Element2,Value1,Value2)
/// ****************************************************************
ClassMethod IsUnifyKF(EpisodeID As %String, Element1 As %String, Element2 As %String, Value1 As %String, Value2 As %String) As %String
{
	s ret=0
	q:(EpisodeID="")||(Element1="")||(Element2="") ret
	
	s ret=1
	s ElementData1=##Class(EPRservice.Quality.CheckRule.Template).GetSingleValues(EpisodeID,Element1)
	q:$e(ElementData1,1,2)="0^" ret
	s ElementData1=$e(ElementData1,3,$l(ElementData1))
	//w "ElementData1="_ElementData1,!
	 
	s ret=2
	s ElementData2=##Class(EPRservice.Quality.CheckRule.Template).GetSingleValues(EpisodeID,Element2)
	q:$e(ElementData2,1,2)="0^"
	s ElementData2=$e(ElementData2,3,$l(ElementData2))
	//w "ElementData2="_ElementData2,!
	s ElementData1=$tr(ElementData1," ","")
	s ElementData2=$tr(ElementData2," ","")
	
	s ret=3
	q:ElementData1="" ret			//Element1为空时不检查，非空由完整性规则去判断
	s:(ElementData1=Value1)&&(ElementData2'=Value2) ret=-1
	//s:(ElementData1'="社会基本医疗保险")&&(ElementData2'="无") ret=-1
	q ret
}

/// ****************************************************************
/// 说明: 同一模板中两元素一致性判断，当Element1*为*Value1时，Element2元素*为*Value2时触发(前肯后肯)
/// 		如：
/// lxf
/// 结论: ret<0 
/// 调试: w ##Class(EPRservice.Quality.CheckRule.UnifyPoint).IsUnifyKF(EpisodeID,Element1,Element2,Value1,Value2)
/// ****************************************************************
ClassMethod IsUnifyKK(EpisodeID As %String, Element1 As %String, Element2 As %String, Value1 As %String, Value2 As %String) As %String
{
	s ret=0
	q:(EpisodeID="")||(Element1="")||(Element2="") ret
	
	s ret=1
	s ElementData1=##Class(EPRservice.Quality.CheckRule.Template).GetSingleValues(EpisodeID,Element1)
	q:$e(ElementData1,1,2)="0^" ret
	s ElementData1=$e(ElementData1,3,$l(ElementData1))
	//w "ElementData1="_ElementData1,!
	 
	s ret=2
	s ElementData2=##Class(EPRservice.Quality.CheckRule.Template).GetSingleValues(EpisodeID,Element2)
	q:$e(ElementData2,1,2)="0^"
	s ElementData2=$e(ElementData2,3,$l(ElementData2))
	//w "ElementData2="_ElementData2,!
	s ElementData1=$tr(ElementData1," ","")
	s ElementData2=$tr(ElementData2," ","")
	
	s ret=3
	q:ElementData1="" ret			//Element1为空时不检查，非空由完整性规则去判断
	s:(ElementData1=Value1)&&(ElementData2=Value2) ret=-1
	//s:(ElementData1="社会基本医疗保险")&&(ElementData2="无") ret=-1
	q ret
}

/// 说明：根据给定的<AScheme>来判断给定的条件与单元值的一致性；
/// 参数：AEpisodeID为就诊号；
/// 	  AValue1为指定的条件；
/// 	  AElement1为指定的模板单元ID；
/// 	  AValue1为<AElement1>想要匹配的内容；
/// 	  AOperator为比较运算符，目前支持“=，!=，like，”；
/// 	  AScheme为匹配模式：
/// 	  	1）KK，代表如果<AValue1>为真，则<AElement1>的值要<AOperator>给定的<AValue2>
/// w ##Class(EPRservice.Quality.CheckRule.UnifyPoint).IsUnifyByScheme("201865",{HISRegTime}'="","E163","","!=","KK")
ClassMethod IsUnifyByScheme(AEpisodeID As %String, AValue1, AElement1 As %String, AValue2 As %String, AOperator As %String, AScheme As %String) As %String
{
	s ret = "0^质控规则表达式参数配置异常!"
	q:(AEpisodeID = "")||(AValue1 = "")||(AElement1 = "")||(AScheme = "") ret
	
	s ret = 1
	if ($zcvt(AScheme,"U") = "KK")
	{
		if (AValue1)
		{
			s ElementData = ##Class(EPRservice.Quality.CheckRule.Template).GetSingleValues(AEpisodeID,AElement1)
			q:($e(ElementData,1,2) = "0^") ret="0^模板单元<"_AElement1_">取值异常退出!"
			s ElementData = $e(ElementData,3,$l(ElementData))
			
			s flag = ..QualityComparator(ElementData,AValue2,AOperator)
			if (flag < 0)
			{
				s ret = -1	
			}	
		}
	}
	q ret
}

/// w ##Class(EPRservice.Quality.CheckRule.UnifyPoint).QualityComparator("a","A","=")
ClassMethod QualityComparator(AValue1 As %String, AValue2 As %String, AOperator As %String) As %String
{
	s ret = -1
	if (AOperator = "=")
	{
		s:(AValue1 = AValue2) ret = 1	
	}
	elseif (AOperator = "!=")
	{
		s:(AValue1 '= AValue2) ret = 1	
	}
	elseif (AOperator = "like")
	{
		s:(AValue1 [ AValue2) ret = 1	
	}
	q ret
}

/// ****************************************************************
/// 说明：抢救记录{日期时间LIST}与HIS{死亡时间}
///     ：死亡病人抢救记录未在抢救结束(死亡时间)后4小时内完成
/// 结论：ret<0 不一致
/// 调试：w ##Class(EPRservice.Quality.CheckRule.UnifyPoint).IsUnify0001(DateTimes,DeathDateTime)
/// ****************************************************************
ClassMethod IsUnify1001(DateTimes1 As %String, DeathDateTime As %String, Hours As %Integer = 4) As %String
{
	s ret=0
	q:DeathDateTime="" ret
	
	s DateTimes1=##Class(EPRservice.Quality.CommonHelper).GetListFromString(DateTimes1,"\")
	s CurrDateTime=$ZD(+$H,3)_" "_$ZT($P($H,",",2),1)
	s:DateTimes1="" DateTimes1=$LB(CurrDateTime)
	s ret=1,flg=0
	for Ind=1:1:$ListLength(DateTimes1) 
	.s DateTime1=$ListGet(DateTimes1,Ind)
	.s TimeGap=##Class(EPRservice.Quality.CommonHelper).GetDateTimeGap(DateTime1,DeathDateTime)
	.s:(TimeGap'<0)&&(TimeGap'>Hours) flg=1 ///xuefl 13.10.29 mod

	s:flg=0 ret=-1
	q ret
}

/// ****************************************************************
/// 说明: 缺少每天至少一次的病程记录
/// 结论: ret<0 不一致
/// 调试: w ##Class(EPRservice.Quality.CheckRule.UnifyPoint).IsUnify1003(DateTimes1,RegDateTime,DischDateTime)
/// ****************************************************************
ClassMethod IsUnify1003(DateTimes1 As %String, RegDateTime As %String, DischDateTime As %String) As %String
{
	s ret = 0
	q:(RegDateTime = "") ret
	s DateTimes1 = ##Class(EPRservice.Quality.CommonHelper).GetListFromString(DateTimes1,"\")
	s CurrDateTime = $zd(+$h,3)_" "_$zt($p($h,",",2),2)
	s FromDate = RegDateTime
	s EndDate = $s(DischDateTime="":CurrDateTime,1:DischDateTime)
	s tmpTimeGap = ##Class(EPRservice.Quality.CommonHelper).GetDateTimeGap(EndDate,FromDate)
	s ret = 1
	s:((tmpTimeGap\24)>$listlength(DateTimes1)) ret = -1
	q ret
}

/// Desc:	住院超过一月无阶段小结(默认2天宽限)
/// Return: ret<0 不一致
/// Debug: 	w ##Class(EPRservice.Quality.CheckRule.UnifyPoint).IsUnify0005("","","")
ClassMethod IsUnify1005(ADateTimes1 As %String, ARegDateTime As %String, ADischDateTime As %String, ADays As %Integer = 2) As %String
{
	s ret = 0
	q:(ARegDateTime = "") ret
	
	s ret = -1
	s DateTimes1 = ##Class(EPRservice.Quality.CommonHelper).GetListFromString(ADateTimes1,"\")
	s CurrDateTime = $zd(+$h,3)_" "_$zt($p($h,",",2),2)
	s FromDate = $g(ARegDateTime)
	s EndDate = $s($g(ADischDateTime)="":CurrDateTime,1:$g(ADischDateTime))
	s tmpTimeGap = ##Class(EPRservice.Quality.CommonHelper).GetDateTimeGap(EndDate,FromDate)
	s Times = ((tmpTimeGap\24-$g(ADays))\30)
	q:(Times < 1) ret
	q:(Times > $listlength(DateTimes1)) ret
	
	s ret = 1
	q ret
}

/// ****************************************************************
/// 说明: 危重症患者必须要有上级医师查房记录
/// 结论: ret<0 不一致
/// 调试: w ##Class(EPRservice.Quality.CheckRule.UnifyPoint).IsUnify0006(DateTimes1,IsApogee)
/// ****************************************************************
ClassMethod IsUnify1006(DateTimes1 As %String, IsApogee As %String) As %String
{
	s ret=0
	q:IsApogee="" ret
	
	s DateTimes1=##Class(EPRservice.Quality.CommonHelper).GetListFromString(DateTimes1,"\")
	s ret=1
	q:IsApogee'["Y" ret   //IsApogee'="Yes"表示此患者不是危重患者
	
	s:$listlength(DateTimes1)<1 ret=-1
	q ret
}

/// ****************************************************************
/// 说明: 死亡病人必须写死亡讨论记录
/// 结论: ret<0 不一致
/// 调试: w ##Class(EPRservice.Quality.CheckRule.UnifyPoint).IsUnify0007(Count1,DeathDateTime)
/// ****************************************************************
ClassMethod IsUnify1007(Count1 As %String, DeathDateTime As %String) As %String
{
	s ret=0
	q:DeathDateTime="" ret
	s:Count1<1 ret=-1
	q ret
}

/// Desc:	判断病程记录是否记录合格;
/// 		普通患者每3天记录一次，病重患者每2天记录一次，病危患者每1天记录一次
/// Input:	AEpisodeID : 			患者就诊号
/// 		AHISRegTime :			入院日期时间
/// 		AHISDisTime	:			出院日期时间
/// 		ATerminalOrdDateTimes : 病危医嘱日期时间
/// 		ADangerOrdDateTimes : 	病重医嘱日期时间
/// 		ATitles : 				日常病程记录标题, 格式为: StructID|可重复模板固定标题\可重复模板固定标题#StructID|可重复模板固定标题
/// 		ATerminallyFreq : 		病危病人病程记录记录频率，如1，表示1天记录一次
/// 		ADangerFreq ：			病重病人病程记录频率，如2，表示2天记录一次
/// 		ANormalFreq ：			普通病人病程记录频率，如3，表示3天记录一次
/// Return：ret<0:不一致; ret=1一致;
/// Debug:	w ##Class(EPRservice.Quality.CheckRule.UnifyPoint).IsUnify1008(AEpisodeID,AHISRegDateTime,AHISDisDateTime,ATerminallyOrdDateTimes,ADangerOrdDateTimes,ATitles,"1","2","3")
ClassMethod IsUnify1008(AEpisodeID As %String, AHISRegDateTime As %String, AHISDisDateTime As %String, ATerminalOrdDateTimes As %String, ADangerOrdDateTimes As %String, ATitles As %String, ATerminallyFreq As %String = "1", ADangerFreq As %String = "2", ANormalFreq As %String = "3") As %String
{
	//b "s"
	s ret = 0
	s retCount = 0
	
	q:(AEpisodeID = "")||(AHISRegDateTime = "")||(ATitles = "") ret
	q:(ATerminallyFreq < 1)||(ADangerFreq < 1)||(ANormalFreq < 1) ret
	
	//校验入院日期和出院日期
	s hisRegDate = $P(AHISRegDateTime, " ", 1)
	S hisRegTime = $P(AHISRegDateTime, " ", 2)
	q:(hisRegDate = "")||(hisRegTime = "") ret
	s hisRegDate = $zdh(hisRegDate,3)
	s hisRegTime = $zth(hisRegTime,1)
	
	s hisDisDate = $P(AHISDisDateTime, " ", 1)
	s hisDisTime = $P(AHISDisDateTime, " ", 2)
	if (hisDisDate = "")||(hisDisTime = "") 
	{
		s hisDisDate = $P($h, ",", 1)
		s hisDisTime = $P($h, ",", 2)
	}
	else
	{
		s hisDisDate = $zdh(hisDisDate,3)
		s hisDisTime = $zth(hisDisTime,1)
	}
	
	q:(hisDisDate < hisRegDate) ret
	q:(hisDisDate = hisRegDate)&&(hisDisTime < hisRegTime) ret
	
	//日常病程记录的发生日期时间
	s arrayRecordCountByDate = ##Class(EPRservice.Quality.CheckRule.Course).GetMultiCountByHappenDate(AEpisodeID,ATitles,"","","","")
	
	//HIS动作发生的日期时间：“病危医嘱” 及 “病重医嘱” 的发生日期时间
	s arrayTerminalOrdDate = ##Class(%ArrayOfDataTypes).%New()
	s arrayDangerOrdDate = ##Class(%ArrayOfDataTypes).%New()
	s count = $Length(ATerminalOrdDateTimes,"\")
	for i = 1:1:count
	{
		s dateTime = $P(ATerminalOrdDateTimes, "\", i)
		s date = $P(dateTime, " ", 1)
		if (date '= "") 
		{
			do arrayTerminalOrdDate.SetAt("1",date)
		}
	}
	s count = $Length(ADangerOrdDateTimes,"\")
	for i = 1:1:count
	{
		s dateTime = $P(ADangerOrdDateTimes, "\", i)
		s date = $P(dateTime, " ", 1)
		if (date '= "") 
		{
			do arrayDangerOrdDate.SetAt("2",date)
		}
	}
	
	
	//判断日常病程记录是否合格
	s date = hisRegDate
	for {
		q:(date > hisDisDate)
		
		//已有不合格的病程记录, 直接退出
		//q:(ret < 0)
	
		//下一条日常病程记录应该在哪一天记录
		s nextRecordDate = date + ANormalFreq - 1
		s dangerRecordDate = $$GetNextRecordDate(date, nextRecordDate, ADangerFreq, arrayDangerOrdDate, "")
		s terminRecordDate = $$GetNextRecordDate(date, nextRecordDate, ATerminallyFreq, arrayDangerOrdDate, arrayTerminalOrdDate)
		if (dangerRecordDate '= "")&&(dangerRecordDate < nextRecordDate)
		{	s nextRecordDate = dangerRecordDate}
		if (terminRecordDate '= "")&&(terminRecordDate < nextRecordDate)
		{	s nextRecordDate = terminRecordDate}
		
		//需要的记录是否存在
		q:(nextRecordDate > hisDisDate)
		if (arrayRecordCountByDate.GetAt(nextRecordDate) = "")
		{
			s ret = -1
			s retCount = retCount + 1
		}
		
		s date = nextRecordDate + 1
	}
	
	if (ret = -1)
	{
		s ret = ret_"@"_retCount
	}
	q ret


GetNextRecordDate(startDate, endDate, freq, arrayDangerOrdDate, arrayTerminalOrdDate)
	//b "s"
	//根据"病重"及"病危"医嘱日期判定下一个需要写日常病程的日期
	s nextDate = ""
	
	s dateCount = 0
	for curDate = startDate:1:endDate
	{
		if (arrayTerminalOrdDate '= "")&&(arrayTerminalOrdDate.GetAt(curDate) '= "")
		{
			s dateCount = dateCount + 1
		}
		elseif (arrayDangerOrdDate '= "")&&(arrayDangerOrdDate.GetAt(curDate) '= "")
		{
			s dateCount = dateCount + 1
		}
		else
		{
			s dateCount = 0
		}
		
		if (dateCount >= freq)
		{
			s nextDate = curDate
			q
		}
	}
	
	q nextDate
}

/// Desc:判断告病重、告病危是否写病重、病危知情同意书
/// 规则：病危患者下病危医嘱后30分钟写病危知情同意书，下病重医嘱后2小时内写病重同意书。
///      如果在一个小时内下过病危医嘱则不必写病重同意书
///      如果一个小时内开立过此医嘱，则不必写同意书
/// Creator:Candyxu
/// Createdate:2013-1-16
/// Input:AEpisodeID 就诊号,AOrdItems 判断的医嘱，ATitle 知情同意书标题，AStructID 质控结构ID,APrintDocID 打印模板ID,AAction 取什么的操作时间，如何“打印的”，ATerminallyIll 病危医嘱项，当检查病重医嘱时需要检查是否下过病危医嘱
/// OutPut: -1 触犯条目,1条目检查通过
/// Debug:w ##Class(EPRservice.Quality.CheckRule.UnifyPoint).IsUnify1009("4389","7791||1","抢救记录","346",559,"打印",30)
ClassMethod IsUnify1009(AEpisodeID As %String, AOrdItems As %String, ATitle As %String, AStructID As %String, APrintDocID As %String, AAction As %String, AMinutes As %String, ATerminallyIll As %String = "") As %String
{
	s ret = 1
	s count = 0
	s errinfo = ""
	//查询是否下指定医嘱
	s dsOrder = ##Class(%Library.ResultSet).%New("EPRservice.Quality.DataGather.OrderInfo:QueryOrderItem")
	d dsOrder.Execute(AEpisodeID,AOrdItems,"","Y")
	//停止的医嘱
	s dsStopOrder = ##Class(%Library.ResultSet).%New("EPRservice.Quality.DataGather.OrderInfo:QueryOrderItem")
	d dsStopOrder.Execute(AEpisodeID,AOrdItems,"D")
	while(dsOrder.Next())
	{
		s OrderIDate = dsOrder.Data("IDate")   //开医嘱日期
		s OrderITime = dsOrder.Data("ITime")   //开医嘱时间
		
		s Flag = -1
		//一小时之内是否开立过此医嘱,如果开过不判断
		while(dsStopOrder.Next())
		{
			s StopOrderDate = dsStopOrder.Data("DDate")
			s StopOrderTime = dsStopOrder.Data("DTime")
			
			if ((OrderIDate '= StopOrderDate) && (OrderITime - StopOrderTime <=3600))
			{
				s Flag = 1
				q
			}
		}
		 continue:(Flag = 1)
		//如果是病重医嘱，判断一个小时内是否下过病危医嘱，如果下过则不用写病重同意书
		if (ATerminallyIll '= "")
		{
		   s dsTerminallyIll = ##Class(%Library.ResultSet).%New("EPRservice.Quality.DataGather.OrderInfo:QueryOrderItem")
		   d dsTerminallyIll.Execute(AEpisodeID,ATerminallyIll,"D")
		   while(dsTerminallyIll.Next())
		   {
			   s TerminallyIllIDate = dsTerminallyIll.Data("DDate")
			   s TerminallyIllITime = dsTerminallyIll.Data("DTime")
			   if ((OrderIDate = TerminallyIllIDate) && (OrderITime - TerminallyIllITime <= 3600))
			   {
				   s Flag = 1
				   q
			   }
		   }
		   continue:(Flag = 1) 
		}
		 
		//是否按时写模板
		s tempCount = 0
		s objStruct = $g(^DHCEPRM.QualityStructD(+AStructID))
		s CategoryID = $list(objStruct,5)
		s ds = ##Class(%Library.ResultSet).%New("EPRservice.BOInstanceData:GetMultiDataInfoByCateID")
		d ds.Execute(AEpisodeID,CategoryID,"","","","",ATitle)
		While(ds.Next())
		{
		    s MultiDataInfo = ds.Data("MultiDataInfo")
		    s EPRNum = $p($p(MultiDataInfo,$c(1),2),"||",2)
		    // 取历史记录的操作时间
		    s PDateTime = ##Class(EPRservice.Quality.CheckRule.Course).GetEPRLogsActionTime(AEpisodeID,APrintDocID,EPRNum,AAction)	
		    continue:(PDateTime = "")
		    s EPRDate = $p(PDateTime,"^",1)
		    s EPRTime = $p(PDateTime,"^",2)
		    if ((EPRDate = OrderIDate) && ((EPRTime - OrderITime)/60 <= AMinutes))
		    {
			    s ret = 1
			    s tempCount = tempCount +1
			    q
			}
		}
		s:(tempCount = 0) count = count +1 ,errinfo = errinfo_"缺少"_$zd(OrderIDate,3)_"一次记录"
	}
	s:(count >0) ret = -1
	q ret_"^"_errinfo_"^"_count
}

/// Desc:检查缺少几天一次的可重复模板记录(多次评分)
/// Creator:Candyxu
/// Created:2013-01-16
/// Input:AEpisodeID 就诊号，ATitles 标题，ARegDateTime 入院时间，ADisDateTime 出院时间，ADays 几天一次
///       AWDays 几天一次病历的书写范围,任意一天写为0,最后一天写为1,最后两天内为2...最后n天写为n n<=ADays
/// Output: ret -1 触犯^提示信息^触犯次数
ClassMethod IsUnify1010(AEpisodeID As %String, ATitles As %String, ARegDateTime As %String, ADisDateTime As %String, ADays As %String, AWDays As %String = 0) As %String
{
	s ret = 1, errInfo = "",count = 0
	q:((AEpisodeID = "")||(ATitles = "")||(ARegDateTime = "")||(ADays = "")) ret
    
	s regDateTime = ##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(ARegDateTime)
	s disDateTime = ##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(ADisDateTime)
	
	s checkDate = $p(disDateTime," ",1)
	s:(checkDate = "") checkDate = $p($h,",",1)
	s checkTime = $p(disDateTime," ",2)
	s:(checkTime = "") checkTime = $p($h,",",2)
	
	s fromDate = $p(regDateTime," ",1)
	s fromTime = $p(regDateTime," ",2)
	s:(fromTime = "") fromTime = 0
	s toDate = +checkDate
	s toTime = fromTime
	
	f tmpDate = fromDate:$g(ADays):toDate 
	{
	  s:((toDate - tmpDate) <= ADays) toTime = checkTime  
	  s tmpToDate = tmpDate + ADays //结束检查时间
	  q:(tmpToDate>toDate)
	  s tmpFromDate = $case(+AWDays,0:tmpDate,:tmpToDate-AWDays) // 开始检查时间
	  s result = ##Class(EPRservice.Quality.CheckRule.Course).GetMultiTemReCount(AEpisodeID,ATitles,tmpFromDate,fromTime,tmpToDate,toTime) 
	  q:($e(result,1,2) = "0^")
	  s Tempcount = +$e(result,3,$l(result))
	  continue:(Tempcount > 0) 
	  s count = count + 1
	  s errInfo = errInfo_" 缺少"_$zd(tmpFromDate,3)_" "_$zt(toTime)_"至"_$zd(tmpToDate,3)_" "_$zt(toTime)_"的一次记录!"
	}
	s:(count > 0 ) ret = -1
	q ret_"^"_errInfo_"^"_count
}

/// Desc: 根据可重复模板记录数量判断可重复模板的数量
///      (协和对非计划手术质控：手术记录数量超过2条则判断非计划手术模板记录,非计划手术记录大于2条则提示)
/// creator: Candyxu
/// Createdate:2013-01-23
/// Input:AEpisodeID 就诊号
///       AaDocID 手术记录的DocID，AaCount 手术记录的数量，AbDocID 非计划手术模板的DocID
///       AElement 非计划手术的管理单元(一般为N单元)，AStructID AElement所在模板的structID
/// Output: 0为非法值，-1触发，1没触发
/// Debug:w ##Class(EPRservice.Quality.CheckRule.UnifyPoint).IsUnify1011M("2462001","123","2","62","E6850","461")
ClassMethod IsUnify1011M(AEpisodeID As %String, AaDocID As %String, AaCount As %String, AbDocID As %String, AElement As %String, AStructID As %String) As %String
{
	s ret = 0
	q:((AEpisodeID = "")||(AaDocID = "")||(AaCount = "")||(AbDocID = "")||(AElement = "")) ret 
	//手术记录模板小于某值不检查
	s aReCount = ##Class(EPRservice.Quality.CheckRule.Course).GetMultiRecordCount(AEpisodeID,AaDocID)
	q:(aReCount < AaCount) ret
	s IsSavedTemplate = ##Class(EPRservice.Quality.CheckRule.Category).GetCatalogData(AEpisodeID,AStructID)
	q:($p(IsSavedTemplate,"^",1) = "") -1
	s bReCount = ##Class(EPRservice.Quality.CheckRule.Course).GetMultiRecordCount(AEpisodeID,AbDocID)
	s ElementData = ##Class(EPRservice.Quality.CheckRule.Template).GetSingleValues(AEpisodeID,AElement,"")
	q:($p(ElementData,"^",1) '= 1) ret
	s ret = 1
	s:(bReCount '= +$p(ElementData,"^",2)) ret = -1
	q ret
}

/// Desc:病危、病重患者可重复模板数据判断(几天写一次)
/// Creator: Candyxu
/// Createdate:2013-01-24
/// Input:AEpisodeID 就诊号，AOrdItems 医嘱项，ATitles structID|标题,ADays 天数
ClassMethod IsUnify1012(AEpisodeID As %String, AOrdItems As %String, ATitles As %String, ADays As %String)
{
	s ret = 0,errInfo = "",count = 0
	q:(AEpisodeID = "")||(AOrdItems = "")||(ADays = "") ret
	//查询是否下指定医嘱
	s dsOrder = ##Class(%Library.ResultSet).%New("EPRservice.Quality.DataGather.OrderInfo:QueryOrderItem")
	d dsOrder.Execute(AEpisodeID,AOrdItems,"","Y")
	while(dsOrder.Next())
	{
		s OrderIDate = dsOrder.Data("IDate")   //开医嘱日期
		s OrderITime = dsOrder.Data("ITime")   //开医嘱时间
		s OrderDDate = dsOrder.Data("DDate")   //停止日期
		s:(OrderDDate = "") OrderDDate = $p($h,",",1)
		s OrderDTime = dsOrder.Data("DTime")   //停止时间
		s:(OrderDTime = "") OrderDTime = $p($h,",",2)
		s tepResult = ##Class(EPRservice.Quality.CheckRule.Course).GetMultiTemReCount(AEpisodeID,ATitles,OrderIDate-2,OrderITime,OrderIDate,OrderITime)
		s:($p(tepResult,"^",2) <= 0) errInfo = errInfo_" 缺少"_$zd(OrderIDate,3)_"的一次记录!",OrderIDate = OrderIDate + ADays
	    f tmpDate = OrderIDate:$g(ADays):OrderDDate 
	    {
	       s result = ##Class(EPRservice.Quality.CheckRule.Course).GetMultiTemReCount(AEpisodeID,ATitles,tmpDate,OrderITime,tmpDate+ADays,OrderDTime)	
	       q:($p(result,"^",1) = "0")
	       s Tempcount = +$p(result,"^",2)
	       continue:(Tempcount > 0) 
	       s count = count + 1
	       s errInfo = errInfo_" 缺少"_$zd(tmpDate,3)_"至"_$zd(tmpDate+ADays-1,3)_"的一次记录!"
	    }	
	}
	if (count > 0) {s ret = -1}else{s ret =1}
	q ret_"^"_errInfo_"^"_count
}

/// Desc:判断是否写输血记录(无论当天输血了多少次或者输的什么，一天只要有一次记录就可以)
///      判断会诊执行记录需在会诊完成后24小时完成:只要在会诊结束后24小时内有会诊记录即可
///      当检验检查结果有危急值时，要求在24小时内记录危急值记录
/// Creator:Candyxu
/// Createdate:2013-01-25
/// Input:AEpisodeID 就诊号，AOrdItemsTime 下医嘱时间(使用公共函数)，ATitles structID|标题,ADays 几天一次，可以是24小时的倍数
/// OutPut:ret_"^"_errInfo_"^"_count  状态_"^"_错误信息_"^"_触犯次数
ClassMethod IsUnify1013(AEpisodeID As %String, AOrdItemsTime As %String, ATitles As %String, ADays As %String = "1")
{
	s ret = 1,errInfo = "",count = 0
	q:((AEpisodeID = "")||(AOrdItemsTime = "")||(ATitles = "")) ret
    s ADays = +ADays
	s DateTimes = ##Class(EPRservice.Quality.CommonHelper).GetListFromString(AOrdItemsTime,"\")
	q:(DateTimes = "") ret
	s TempDate = "" 
	for i = 1:1:$listlength(DateTimes)
	{
		continue:(TempDate = $p($ListGet(DateTimes,i)," ",1))
		s TempDate = $p($ListGet(DateTimes,i)," ",1)
		s TempTime = $p($ListGet(DateTimes,i)," ",2)
		s result = ##Class(EPRservice.Quality.CheckRule.Course).GetMultiTemReCount(AEpisodeID,ATitles,TempDate,TempTime,TempDate + ADays,TempTime)
		s:($p(result,"^",2) <= 0) errInfo = errInfo_" 缺少"_$ZD(TempDate)_"的一次记录",ret = -1,count = count + 1
	}
    q ret_"^"_errInfo_"^"_count
}

/// ***********************************************************************************************************************
/// Desc:检查缺少几天一次的可重复模板记录（按创建时间质控）,并显示是否补充(多次评分)
///      先检查是否创建记录如果有则返回真，否则再检查是否补填记录，如果有则提示已补，否则返回缺记录时间
/// Demander：北京协和
/// Creator:Candyxu
/// CreateDate:2013-02-20
/// Input:AEpisodeID 就诊号，ATitles 标题，ARegDateTime 入院时间，ADisDateTime 出院时间，ADays 几天一次
/// OutPut:ret -1 触犯^提示信息^触犯次数
/// Debug: w ##Class(EPRservice.Quality.CheckRule.UnifyPoint).IsUnify1014(35,"348|日常病程记录","2012-02-07 11:38:29","",3)
/// ************************************************************************************************************************
ClassMethod IsUnify1014(AEpisodeID As %String, ATitles As %String, ARegDateTime As %String, ADisDateTime As %String, ADays As %String) As %String
{
	s ret = 1, errInfo = "",count = 0
	q:((AEpisodeID = "")||(ATitles = "")||(ARegDateTime = "")||(ADays = "")) ret
    
	s regDateTime = ##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(ARegDateTime)
	s disDateTime = ##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(ADisDateTime)
	
	s checkDate = $p(disDateTime," ",1)
	s:(checkDate = "") checkDate = $p($h,",",1)
	s checkTime = $p(disDateTime," ",2)
	s:(checkTime = "") checkTime = $p($h,",",2)
	
	s fromDate = $p(regDateTime," ",1)
	s fromTime = $p(regDateTime," ",2)
	s:(fromTime = "") fromTime = 0
	s toDate = +checkDate
	f tmpDate = fromDate:$g(ADays):toDate 
	{
	  s result = ##Class(EPRservice.Quality.CheckRule.Course).GetMultiRecordByTimeType(AEpisodeID,ATitles,tmpDate,fromTime,tmpDate+ADays,checkTime,"N","C")	
	  q:($e(result,1,2) = "0^")
	  s Tempcount = +$e(result,3,$l(result))
	  continue:(Tempcount > 0)
	  s result = ##Class(EPRservice.Quality.CheckRule.Course).GetMultiRecordByTimeType(AEpisodeID,ATitles,tmpDate,fromTime,tmpDate+ADays,checkTime,"N","H") 
	  q:($e(result,1,2) = "0^")
	  s Tempcount = +$e(result,3,$l(result))
	  if (Tempcount > 0) 
	  {
	     s errInfo = errInfo_" 缺少"_$zd(tmpDate,3)_"至"_$zd(tmpDate+ADays-1,3)_"的记录,已补!"
	  }else
	  {
		 s errInfo = errInfo_" 缺少"_$zd(tmpDate,3)_"至"_$zd(tmpDate+ADays-1,3)_"的一次记录!"
	  }
	  s count = count + 1
	}
	s:(count > 0 ) ret = -1
	q ret_"^"_errInfo_"^"_count
}

/// ************************************************************************************************************************
/// Desc:病危、病重患者可重复模板数据判断几天写一次（按创建时间质控）,并显示是否补充(多次评分)
///      根据医嘱开立停止时间先检查是否创建记录如果有则返回真，否则再检查是否补填记录，如果有则提示已补，否则返回缺记录时间
/// Demander：北京协和     
/// Creator: Candyxu
/// Createdate:2013-02-21
/// Input:AEpisodeID:就诊号，AOrdItems:医嘱项，ATitles:structID|标题,ADays:天数
/// OutPut:ret -1 触犯^提示信息^触犯次数
/// Debug:w ##Class(EPRservice.Quality.CheckRule.UnifyPoint).IsUnify1015(35,"719","348|日常病程记录",3)
/// *************************************************************************************************************************
ClassMethod IsUnify1015(AEpisodeID As %String, AOrdItems As %String, ATitles As %String, ADays As %String)
{
	s ret = 0,errInfo = "",count = 0
	q:(AEpisodeID = "")||(AOrdItems = "")||(ADays = "") ret
	//查询是否下指定医嘱
	s dsOrder = ##Class(%Library.ResultSet).%New("EPRservice.Quality.DataGather.OrderInfo:QueryOrderItem")
	d dsOrder.Execute(AEpisodeID,AOrdItems,"","Y")
	while(dsOrder.Next())
	{
		s OrderIDate = dsOrder.Data("IDate")   //开医嘱日期
		s OrderITime = dsOrder.Data("ITime")   //开医嘱时间
		s OrderDDate = dsOrder.Data("DDate")   //停止日期
		s:(OrderDDate = "") OrderDDate = $p($h,",",1)
		s OrderDTime = dsOrder.Data("DTime")   //停止时间
		s:(OrderDTime = "") OrderDTime = $p($h,",",2)
		//判断前一次
		s tepResult = ##Class(EPRservice.Quality.CheckRule.Course).GetMultiRecordByTimeType(AEpisodeID,ATitles,OrderIDate-2,OrderITime,OrderIDate,OrderITime,"N","C")
		if ($p(tepResult,"^",2) <= 0) 
		{
		   s tepResult = ##Class(EPRservice.Quality.CheckRule.Course).GetMultiRecordByTimeType(AEpisodeID,ATitles,OrderIDate-2,OrderITime,OrderIDate,OrderITime,"N","H")	
		   if ($p(tepResult,"^",2) <= 0)
		   {
			   s errInfo = errInfo_" 缺少"_$zd(OrderIDate,3)_"的一次记录!"
		   }else
		   {
			   s errInfo = errInfo_" 缺少"_$zd(OrderIDate,3)_"的一次记录,已补,!"
		   }
		}
		s OrderIDate = OrderIDate + ADays
	    for tmpDate = OrderIDate:$g(ADays):OrderDDate 
	    {
	       s result = ##Class(EPRservice.Quality.CheckRule.Course).GetMultiRecordByTimeType(AEpisodeID,ATitles,tmpDate,OrderITime,tmpDate+ADays,OrderDTime,"N","C")	
	       q:($p(result,"^",1) = "0")
	       s Tempcount = +$p(result,"^",2)
	       continue:(Tempcount > 0) 
	       s result = ##Class(EPRservice.Quality.CheckRule.Course).GetMultiRecordByTimeType(AEpisodeID,ATitles,tmpDate,OrderITime,tmpDate+ADays,OrderDTime,"N","H")	
	       if (+$p(result,"^",2)<= 0)
	       {
		       s errInfo = errInfo_" 缺少"_$zd(tmpDate,3)_"至"_$zd(tmpDate+ADays-1,3)_"的一次记录!"
		   }else
		   {
			   s errInfo = errInfo_" 缺少"_$zd(tmpDate,3)_"至"_$zd(tmpDate+ADays-1,3)_"的一次记录,!已补"
		   }
	       s count = count + 1
	    }	
	}
	if (count > 0) {s ret = -1}else{s ret =1}
	q ret_"^"_errInfo_"^"_count
}

/// *********************************************************************************
/// Desc:多常时间内无什么(质控可重复模板，提示质控标准未到时限提醒，在、出院质控标准到时限触发）
///     例如：入院48小时间内无上级医师查房记录
///           术后24小时内无手术记录
/// Input:AEpisodeID 就诊id，ATitles：structID|标题，ARegDateTime 入院时间，ADisDateTime 出院时间
///      AHours 时限，AFlag 是否是未到时限检查（用于提示质控标准） 值为1(未到时限检查) 或""(到时限检查)
/// OutPut:ret_"^"_errInfo  ret 为-1 触犯该条目，0条目配置有错,1质控通过  errInfo 提示信息
/// Creator:Candyxu
/// CreateDate:2013-9-25
/// Debug: w ##Class(EPRservice.Quality.CheckRule.UnifyPoint).IsUnify1016(.....)
/// *********************************************************************************
ClassMethod IsUnify1016(AEpisodeID As %String, ATitles As %String, ARegDateTime As %String, ADisDateTime As %String, AHours As %String, AFlag As %String = "") As %String
{
	s ret = 0, errInfo = ""
	q:(AEpisodeID = "")||(ATitles = "")||(ARegDateTime = "")||(AHours = "") ret
	
	s regDateTime = ##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(ARegDateTime)
	s disDateTime = ##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(ADisDateTime)
	s curDateTime = $case(disDateTime = "",1:$p($h,",",1)_" "_$p($h,",",2),0:disDateTime)
	s curTimeGap = ##Class(EPRservice.Quality.CommonHelper).GetDateTimeGap(curDateTime,regDateTime)
	s ret = 1
	q:((AFlag '= "1") &&(curTimeGap <= AHours)) ret
	
	s startDate = $p(regDateTime," ",1),startTime =$p(regDateTime," ",2)
	s endDate = startDate + ((startTime + (+AHours * 3600))\86400),endTime = (startTime + (+AHours * 3600))#86400
	s result = ##Class(EPRservice.Quality.CheckRule.Course).GetMultiTemReCount(AEpisodeID,ATitles,startDate,startTime,endDate,endTime)
	q:($e(result,1,2) = "0^") ret
	s count = +$e(result,3,$l(result))
	q:(count > 0) ret
	s ret = -1
	if (curTimeGap < AHours)
	{
		s errInfo = $p(ATitles,"|",2)_"书写时限还剩"_$j(AHours - curTimeGap,1,1)_"小时!"
	}else
	{
		s errInfo = AHours_"小时内无"_ $p(ATitles,"|",2)
	}
    s ret = ret_"^"_errInfo
    q ret
}

/// ****************************************************************
/// 说明：抢救医嘱后6小时未完成抢救记录
/// 结论：ret<0 不一致
/// 调试：w ##Class(EPRservice.Quality.CheckRule.UnifyPoint).IsUnify0054(OrdItemDateTime,DateTimes)
/// ****************************************************************
ClassMethod IsUnify1054(OrdItemDateTime As %String, DateTimes As %String) As %String
{
	s ret=0
	q:OrdItemTime="" ret
	
	s OrdItemTimels=##Class(EPRservice.Quality.CommonHelper).GetListFromString(OrdItemTime,"\")
	s DateTimels=##Class(EPRservice.Quality.CommonHelper).GetListFromString(DateTimes,"\")
	s ret=1
	s CurrDateTime=$zd(+$h,3)_" "_$zt($p($h,",",2),2)
	for Ind=1:1:$listlength(OrdItemTimels) {
		s OrdItemTime=$listget(OrdItemTimels,Ind)
		s DateTime=$s((Ind>$listlength(DateTimels)):CurrDateTime,1:$listget(DateTimels,Ind))
		s tmpTimeGap=##Class(EPRservice.Quality.CommonHelper).GetDateTimeGap(DateTime,OrdItemTime)
		q:(tmpTimeGap'>6)
		s ret=-1
	}
	q ret
}

/// ****************************************************************
/// 说明: 同一模板中两元素一致性判断，当Element1*包含*Values1中值时，Element2元素*为*Values2中值时触发(前肯后肯)
/// 		如： "主要诊断"的编码为"s"、"t"打头时，"损伤中毒"不能为"无",取编码时，Element1以"EC"开头
/// 		注：Element1,Element2为单值；Values1,Values2为多值
/// lxf
/// 结论: ret<0 
/// 调试: w ##Class(EPRservice.Quality.CheckRule.UnifyPoint).IsContainKK(EpisodeID,Element1,Element2,Values1,Values2)
/// ****************************************************************
ClassMethod IsContainKK(EpisodeID As %String, Element1 As %String, Element2 As %String, Values1 As %String, Values2 As %String) As %String
{
	s ret=0
	q:(EpisodeID="")||(Element1="")||(Element2="") ret
	
	s ret=1
	s ElementData1=##Class(EPRservice.Quality.CheckRule.Template).GetSingleValues(EpisodeID,Element1)
	q:$e(ElementData1,1,2)="0^" ret
	s ElementData1=$e(ElementData1,3,$l(ElementData1))
	//w "ElementData1="_ElementData1,!
	 
	//s MainDiagCode=$p($g(^MRC("ID",ElementData1)),"^",4)
	//w !,"MainDiagCode="_MainDiagCode,!
	//s ElementData1=MainDiagCode
	
	//20100919 wangwt update begin
	if Element1="E1039" 
	{
		s ECODE="#TYPE:Simple#TID:2#TVER:0#SCODE:I0002#VTYPE:C"
		s ElementData1=##class(EPRservice.BOScatterData).GetEPRData(EpisodeID,ECODE)
	}
	//20100919 wangwt update end
	
	s ret=2
	s ElementData2=##Class(EPRservice.Quality.CheckRule.Template).GetSingleValues(EpisodeID,Element2)
	q:$e(ElementData2,1,2)="0^"
	s ElementData2=$e(ElementData2,3,$l(ElementData2))
	//w "ElementData2="_ElementData2,!
	s ElementData1=$tr(ElementData1," ","")
	s ElementData2=$tr(ElementData2," ","")
	
	s ret=3
	q:ElementData1="" ret			//Element1为空时不检查，非空由完整性规则去判断
	
	s flag=""
	f j=1:1:$l(Values1,"\") d
	.s Value1=$p(Values1,"\",j)
	.s Value1=$tr(Value1," ","")
	.s:ElementData1[Value1 flag=1 
	.//w "ElementData1="_ElementData1_"//Value1="_Value1,!
	
	i flag=1 d
	.f j=1:1:$l(Values2,"\") d
	..s Value2=$p(Values2,"\",j)
	..s Value2=$tr(Value2," ","")
	..s:ElementData2=Value2 ret=-1 
	..//w "ElementData2="_ElementData2_"//Value2="_Value2,!
	
	q ret
}

/// ****************************************************************
/// 说明：	入院48小时内无上级医师首次查房记录
/// 参数：	ATitles格式为 StructID|可重复模板标题\可重复模板标题#StructID|可重复模板标题\可重复模板标题
/// 		Titles参数前数字为StructID，多个参数#分隔
/// 结论：	ret<0 不一致
/// 调试：	w ##Class(EPRservice.Quality.CheckRule.UnifyPoint).IsUnify201(AEpisodeID,ATitles,ARegDateTime,ADisDateTime,AHours,ACondition)
/// ****************************************************************
ClassMethod IsUnify201(AEpisodeID As %String, ATitles As %String, ARegDateTime As %String, ADisDateTime As %String, AHours As %String = "", ACondition As %String = "1") As %String
{
	s ret = 0, result = ""
	q:(AEpisodeID = "")||(ATitles = "")||(ARegDateTime = "") ret
	
	//wangwentao 20101030 add 带条件项目:质控条件为空不检查
	q:(ACondition = "") ret
	
	//wangwentao 20101030 add 带条件项目:超过入院后指定的时间范围不检查
	s conCurDateTime = $zdt($h,3,1)
	s conTimeGap = ##Class(EPRservice.Quality.CommonHelper).GetDateTimeGap(conCurDateTime,ARegDateTime)
	q:(ACondition '= "1")&&(conTimeGap > +AHours) ret
	
	s checkDateTime = $g(ADisDateTime)
	s:(checkDateTime = "") checkDateTime = $tr($h,","," ")
	s tmpTimeGap = ##Class(EPRservice.Quality.CommonHelper).GetDateTimeGap(checkDateTime,ARegDateTime)
	
	//wwt Comments
	//q:tmpTimeGap<=48 ret  //在院不满48小时不检查
	//wwt end
	
	s regDateTime = ##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(ARegDateTime)
	s checkDateTime = ##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(checkDateTime)
	s startDate = $p(regDateTime," ",1), startTime = $p(regDateTime," ",2)
	s endDate = $p(checkDateTime," ",1), endTime = $p(checkDateTime," ",2)
	
	//20100716 wangwt update 
	s:(AHours '= "") tmpEndDate = AHours/24
	s:(AHours '= "") endDate = startDate + tmpEndDate, endTime = startTime
	//20100716 wangwt end

	s result = ##Class(EPRservice.Quality.CheckRule.Course).GetMultiTemReCount(AEpisodeID,ATitles,startDate,startTime,endDate,endTime)
	q:($e(result,1,2) = "0^") ret
	
	s count = +$e(result,3,$l(result))
	s ret = 1
	s:(count < 1) ret = -1

	//20100716 wangwt update
	s:(ret = -1)&&(AHours '= "")&&(tmpTimeGap <= AHours) errInfo="^ 提示:上级医师查房书写时限还剩"_$j(AHours-tmpTimeGap,1,1)_"小时!" ,ret=ret_errInfo
	s:(ret = -1)&&(AHours '= "")&&(tmpTimeGap > AHours) errInfo="^ 提示:上级医师查房书写已超过时限,请以后注意!" ,ret=ret_errInfo
	//20100716 wangwt end
	
	//20100716 wangwt update
	if (ACondition = "特级护理")||(ACondition = "重症监护") 
	{
		s:(ret = -1)&&(AHours '= "")&&(tmpTimeGap <= AHours) errInfo="^ 提示:当前为"_ACondition_"上级医师查房书写时限还剩"_$j(AHours-tmpTimeGap,1,1)_"小时!" ,ret=ret_errInfo
		s:(ret = -1)&&(AHours '= "")&&(tmpTimeGap > AHours) errInfo="^ 提示:当前为"_ACondition_"上级医师查房书写已超过时限,请以后注意!" ,ret=ret_errInfo
	}
	//20100716 wangwt end

	q ret
}

/// Desc:	交班记录后24小时内未完成接班记录
///     	转科记录后24小时内未完成接收记录
///     	请会诊记录后24小时未完成会诊记录
/// Input:	AEpisodeID为患者就诊号;
/// 		ATitles1为前导标题字符串;
/// 		ATitles2为后置标题字符串;
/// 		AHours为参考小时数(默认为24);
/// Output:	ret<0 不一致
/// Debug:	w ##Class(EPRservice.Quality.CheckRule.UnifyPoint).IsUnify202(AEpisodeID,ATitles1,ATitles2,AHours)
ClassMethod IsUnify202(AEpisodeID As %String, ATitles1 As %String, ATitles2 As %String, AHours As %String = 24) As %String
{
	s ret = 0, errInfo = ""
	q:(AEpisodeID = "")||(ATitles1 = "")||(ATitles2 = "") ret
	
	s checkDateTime = $tr($h,","," ")
	
	s result1 = ##Class(EPRservice.Quality.CheckRule.Course).GetMultiTemHaDateTime(AEpisodeID,ATitles1,"","","","")
	q:($e(result1,1,2) = "0^") ret
	s dateTimes1 = $e(result1,3,$l(result1))
	
	s result2 = ##Class(EPRservice.Quality.CheckRule.Course).GetMultiTemHaDateTime(AEpisodeID,ATitles2,"","","","")
	q:($e(result2,1,2) = "0^") ret
	s dateTimes2 = $e(result2,3,$l(result2))
	
	s dateTimes1 = ##Class(EPRservice.Quality.CommonHelper).GetListFromString(dateTimes1,"\")
	//wwt Comments
	//s:DateTimes2="" DateTimes2=$tr($h,","," ")
	//wwt update 20100716
	s:(dateTimes2 = "") dateTimes2Initial = dateTimes2, dateTimes2 = $tr($h,","," ")
	s:(dateTimes2 '= "") dateTimes2Initial = "NULL"
	//wwt end
	s dateTimes2 = ##Class(EPRservice.Quality.CommonHelper).GetListFromString(dateTimes2,"\")

	s ret = 1
	//wwt Comments
	//f Ind1=1:1:$listlength(DateTimes1) q:ret=-1  d
	//wwt update 20100716
	f ind1 = 1:1:$listlength(dateTimes1) q:(+ret = -1)  d
	.s dateTime1 = $listget(dateTimes1,ind1)
	.q:(dateTime1 = "")
	.s checkTimeGap = ##Class(EPRservice.Quality.CommonHelper).GetDateTimeGap(checkDateTime,dateTime1)
	.//wwt update 20100716 首次交班
	.s:(dateTimes2Initial = "")&&(checkTimeGap <= AHours)&&($p(ATitles1,"|",2) = "交班记录") errInfo = "^ 提示:"_$zd($p(dateTime1," ",1),3)_"交班记录对应的接班记录书写时限还剩"_$j(checkTimeGap,1,1)_"小时!" ,ret = -1, ret = ret_errInfo
	.s:(dateTimes2Initial = "")&&(checkTimeGap <= AHours)&&($p(ATitles1,"|",2) = "转出记录") errInfo = "^ 提示:"_$zd($p(dateTime1," ",1),3)_"转出记录对应的转入记录书写时限还剩"_$j(checkTimeGap,1,1)_"小时!" ,ret = -1, ret = ret_errInfo
	.//wwt end
	.q:(checkTimeGap <= 24)
	.s flag = 0
	.f ind2 = 1:1:$listlength(dateTimes2) q:(flag = 1)  d
	..s dateTime2 = $listget(dateTimes2,ind2)
	..q:(dateTime2 = "")
	..s tmpTimeGap = ##Class(EPRservice.Quality.CommonHelper).GetDateTimeGap(dateTime2,dateTime1)
	..q:(tmpTimeGap < 0)
	..q:(tmpTimeGap > AHours)
	..s flag = 1
	.q:(flag = 1)
	.s ret = -1
	.//wwt update 20100716 历次交班
	.s:($p(ATitles1,"|",2) = "交班记录") errInfo = "^ 提示:未发现"_$zd($p(dateTime1," ",1),3)_"交班记录对应的接班记录!"
	.s:($p(ATitles1,"|",2) = "转出记录") errInfo = "^ 提示:未发现"_$zd($p(dateTime1," ",1),3)_"转出记录对应的转入记录!"
	.s ret = ret_errInfo
	.//wwt end
	
	q ret
}

/// ****************************************************************
/// 说明: 交班病人接班记录数与接班记录数不一致
///     : 转科病人转科记录数与接收记录数不一致
///     : 会诊病人请会诊记录数与会诊记录数不一致
/// 结论: ret<0 不一致
/// Modify By HKY(新增入参AHours，用于判定多少小时内不需要检查相应记录的一致性问题，默认为空) 
/// 调试: w ##Class(EPRservice.Quality.CheckRule.UnifyPoint).IsUnify203(AEpisodeID,ATitles1,ATitles2)
/// ****************************************************************
ClassMethod IsUnify203(AEpisodeID As %String, ATitles1 As %String, ATitles2 As %String, ARegDateTime As %String = "", ADisDateTime As %String = "", AHours As %String = "") As %String
{
	s ret = 0
	q:(AEpisodeID = "")||(ATitles1 = "")||(ATitles2 = "") ret
	if ((ARegDateTime'="")&&(ADisDateTime'="")&&(AHours'=""))
	{
	  s regDateTime = ##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(ARegDateTime)
	  s checkDateTime = $g(ADisDateTime) //出院时间
	  s:(checkDateTime = "") checkDateTime = $tr($h,","," ") //出院时间为空取当前时间
	  s tmpTimeGap = ##Class(EPRservice.Quality.CommonHelper).GetDateTimeGap(checkDateTime,ARegDateTime) 
	  //q:tmpTimeGap<=48 
	  s startDate = $p(regDateTime," ",1), startTime = $p(regDateTime," ",2)
	  s endDate = $p(checkDateTime," ",1), endTime = $p(checkDateTime," ",2)
	
	  //20100716 wangwt update 
	  s:(AHours '= "") tmpEndDate = AHours/24
	  s:(AHours '= "") startDate = startDate + tmpEndDate, startTime = startTime
	}
	
	else 
	{
		s startDate="",startTime="",endDate="",endTime=""
		
	}
	s result1 = ##Class(EPRservice.Quality.CheckRule.Course).GetMultiTemReCount(AEpisodeID,ATitles1,startDate,startTime,endDate,endTime)
	q:($e(result1,1,2) = "0^") ret
	s count1 = +$e(result1,3,$l(result1))
	
	s result2 = ##Class(EPRservice.Quality.CheckRule.Course).GetMultiTemReCount(AEpisodeID,ATitles2,startDate,startTime,endDate,endTime)
	q:($e(result2,1,2) = "0^") ret
	s count2 = +$e(result2,3,$l(result2))
	
	s ret = 1
	s:(count1 '= count2) ret = -1
	
	q ret
}

/// ****************************************************************
/// 说明: 转科病人无转科记录//转科表转科次数<>转科记录次数
///     : 抢救病人无抢救记录//抢救医嘱数<>抢救记录次数
///     : 输血病人无输血记录//输血医嘱数<>输血记录次数
///     : 穿刺病人无穿刺记录//穿刺医嘱数<>穿刺记录次数
/// 结论: ret<0 不一致
/// 调试: w ##Class(EPRservice.Quality.CheckRule.UnifyPoint).IsUnify204(AEpisodeID,AHISCount,ATitles)
/// ****************************************************************
ClassMethod IsUnify204(AEpisodeID As %String, AHISCount As %String, ATitles As %String) As %String
{
	s ret = 0
	q:(AEpisodeID = "")||(AHISCount = "")||(ATitles = "") ret
	
	s hisCount = +$g(AHISCount)
	
	s result = ##Class(EPRservice.Quality.CheckRule.Course).GetMultiTemReCount(AEpisodeID,ATitles,"","","","")
	q:($e(result,1,2) = "0^") ret
	s count = +$e(result,3,$l(result))
	
	s ret = 1
	s:(count '= hisCount) ret = -1
	
	q ret
}

/// ****************************************************************
/// 说明: 手术记录未在术后24小时内完成（手术申请单结束时间）
/// 结论: ret<0 不一致
/// 调试: w ##Class(EPRservice.Quality.CheckRule.UnifyPoint).IsUnify205(AEpisodeID,AHISDateTimes,ATitles,AHours)
/// ****************************************************************
ClassMethod IsUnify205(AEpisodeID As %String, AHISDateTimes As %String, ATitles As %String, AHours As %String) As %String
{
	s ret = 0
	q:(AEpisodeID = "")||(AHISDateTimes = "")||(ATitles = "") ret
	
	s checkDateTime = $tr($h,","," ")
	s hours = 24
	s:($g(AHours) '= "") hours = +$g(AHours)
	
	s result = ##Class(EPRservice.Quality.CheckRule.Course).GetMultiTemHaDateTime(AEpisodeID,ATitles,"","","","")
	q:($e(result,1,2) = "0^") ret
	s dateTimes = $e(result,3,$l(result))
	
	s dateTimes2 = ##Class(EPRservice.Quality.CommonHelper).GetListFromString(dateTimes,"\")
	s dateTimes2 = dateTimes2_$lb($tr($h,","," "))
	s dateTimes1 = ##Class(EPRservice.Quality.CommonHelper).GetListFromString(AHISDateTimes,"\")

	s ret = 1
	f ind1 = 1:1:$listlength(dateTimes1) q:(ret = -1)  d
	.s dateTime1=$listget(dateTimes1,ind1)
	.q:(dateTime1 = "")
	.s dateTime1 = $p(dateTime1," ",3)_" "_$p(dateTime1," ",4)
	.q:(dateTime1 = " ")
	.s checkTimeGap = ##Class(EPRservice.Quality.CommonHelper).GetDateTimeGap(checkDateTime,dateTime1)
	.q:(checkTimeGap <= 24)
	.s flag = 0
	.f ind2 = 1:1:$listlength(dateTimes2) q:(flag = 1)  d
	..s dateTime2=$listget(dateTimes2,ind2)
	..q:(dateTime2 = "")
	..s tmpTimeGap = ##Class(EPRservice.Quality.CommonHelper).GetDateTimeGap(dateTime2,dateTime1)
	..q:(tmpTimeGap < 0)
	..q:(tmpTimeGap > hours)
	..s flag = 1
	.q:(flag = 1)
	.s ret = -1

	q ret
}

/// ****************************************************************
/// 说明: 术前小结记录未在术前*小时内完成（手术申请单开始时间）
///     ：无手术前术者查看病人的病程记录（手术申请单开始时间）
/// 结论: ret<0 不一致
/// 调试: w ##Class(EPRservice.Quality.CheckRule.UnifyPoint).IsUnify206(AEpisodeID,AHISDateTimes,ATitles)
/// ****************************************************************
ClassMethod IsUnify206(AEpisodeID As %String, AHISDateTimes As %String, ATitles As %String) As %String
{
	s ret = 0
	q:(AEpisodeID = "")||(AHISDateTimes = "")||(ATitles = "") ret
	
	s result = ##Class(EPRservice.Quality.CheckRule.Course).GetMultiTemHaDateTime(AEpisodeID,ATitles,"","","","")
	q:($e(result,1,2) = "0^") ret
	s dateTimes = $e(result,3,$l(result))
	
	s dateTimes1 = ##Class(EPRservice.Quality.CommonHelper).GetListFromString(AHISDateTimes,"\")
	s dateTimes2 = ##Class(EPRservice.Quality.CommonHelper).GetListFromString(dateTimes,"\")
	
	s ret = 1
	f ind1 = 1:1:$listlength(dateTimes1) q:(ret = -1)  d
	.s dateTime1 = $listget(dateTimes1,ind1)
	.q:(dateTime1 = "")
	.s dateTime1 = $p(dateTime1," ",1)_" "_$p(dateTime1," ",2)
	.q:(dateTime1 = " ")
	.s flag = 0
	.f ind2 = 1:1:$listlength(dateTimes2) q:(flag = 1)  d
	..s dateTime2 = $listget(dateTimes2,ind2)
	..q:(dateTime2 = "")
	..s tmpTimeGap = ##Class(EPRservice.Quality.CommonHelper).GetDateTimeGap(dateTime1,dateTime2)
	..q:(tmpTimeGap < 0)
	..s flag = 1
	.q:(flag = 1)
	.s ret = -1
	
	q ret
}

/// Desc:	缺少每天至少一次的病程记录
///     	缺少7天一次的主任医师查房记录
///     	缺少30天一次的阶段小结
/// Output:	ret<0 不一致
/// Debug:	w ##Class(EPRservice.Quality.CheckRule.UnifyPoint).IsUnify207(AEpisodeID,ATitles,ARegDateTime,ADisDateTime,ADays,AConditions)
ClassMethod IsUnify207(AEpisodeID As %String, ATitles As %String, ARegDateTime As %String, ADisDateTime As %String, ADays As %String, AConditions As %String = "") As %String
{
	s ret = 0, errInfo = ""
	q:(AEpisodeID = "")||(ATitles = "")||(ARegDateTime = "")||(ADays = "") ret

	s regDateTime = ##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(ARegDateTime)
	s disDateTime = ##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(ADisDateTime)
	
	s checkDate = $p(disDateTime," ",1)
	s:(checkDate = "") checkDate = +$h
	
	s fromDate = $p(regDateTime," ",1)
	s toDate = +checkDate
	
	s ret = 1
	f tmpDate = fromDate:$g(ADays):toDate d
	.q:(checkDate <= (tmpDate + ADays))
	.//wwt update 20100716
	.q:(ret = -1)
	.//wwt and
	.s result = ##Class(EPRservice.Quality.CheckRule.Course).GetMultiTemReCount(AEpisodeID,ATitles,tmpDate,0,tmpDate+ADays,0)
	.q:($e(result,1,2) = "0^")
	.s count = +$e(result,3,$l(result))
	.q:(count > 0)
	.s ret=-1
	.//wwt update 20100716
	.s errInfo=" 提示:缺少"_$zd(tmpDate,3)_"至"_$zd(tmpDate+ADays-1,3)_"的一次记录!"
	.s ret = ret_"^"_errInfo
	
	//b "s"  //Add , Conditions As %String =""
	if (AConditions '= "")&&(+ret = -1)
	{
		s conResult = ##Class(EPRservice.Quality.CheckRule.Course).GetMultiTemReCount(AEpisodeID,AConditions,tmpDate,0,tmpDate+ADays,0)
		q:($e(conResult,1,2) = "0^") ret
		s count = +$e(conResult,3,$l(conResult))
		s:(count > 0) ret = 1
	}
	//wwt and
	
	q ret
}

/// ****************************************************************
/// 说明: 缺少术后当天术后病程记录（手术申请单结束时间）
/// 结论: ret<0 不一致
/// 调试: w ##Class(EPRservice.Quality.CheckRule.UnifyPoint).IsUnify208(EpisodeID,Titles,DateTimes,DischDateTime,Hours)
/// ****************************************************************
ClassMethod IsUnify208(AEpisodeID As %String, ATitles As %String, ADateTimes As %String, ADischDateTime As %String, AHours As %String) As %String
{
	s ret = 0
	q:(AEpisodeID = "")||(ATitles = "")||(ADateTimes = "") ret
	
	s checkDateTime = ##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(ADischDateTime)
	s checkDate = $p(checkDateTime," ",1)
	s:(checkDate = "") checkDate = +$h
	
	s dateTimes = ##Class(EPRservice.Quality.CommonHelper).GetListFromString(ADateTimes,"\")
	
	s ret=1
	f Ind=1:1:$listlength(dateTimes) q:ret=-1  d
	.s dateTime=$listget(dateTimes,Ind)
	.q:dateTime=""
	.s dateTime=$p(dateTime," ",3)_" "_$p(dateTime," ",4)
	.s dateTime=##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(dateTime)
	.q:dateTime=""
	.s fromDate=$p(dateTime," ",1),fromTime=$p(dateTime," ",2)
	.s toDate=fromDate+1,toTime=0
	.q:(+AHours>0)&&(checkDate<=toDate)
	.s result=##Class(EPRservice.Quality.CheckRule.Course).GetMultiTemReCount(AEpisodeID,ATitles,fromDate,fromTime,toDate,toTime)
	.q:$e(result,1,2)="0^"
	.s count=+$e(result,3,$l(result))
	.q:count>0
	.s ret=-1
	
	q ret
}

/// ****************************************************************
/// 说明: 缺少术后三天连续病程记录（手术申请单结束时间）
/// 结论: ret<0 不一致
/// 调试: w ##Class(EPRservice.Quality.CheckRule.UnifyPoint).IsUnify209(AEpisodeID,ATitles,ADateTimes,ADischDateTime,ADays)
/// ****************************************************************
ClassMethod IsUnify209(AEpisodeID As %String, ATitles As %String, ADateTimes As %String, ADischDateTime As %String, ADays As %String = "3") As %String
{
	s ret = 0
	q:(AEpisodeID="")||(ATitles="")||(ADateTimes="") ret
	
	s dischDateTime = ##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(ADischDateTime)
	s checkDate = $p(dischDateTime," ",1)
	s:(checkDate = "") checkDate = +$h
	
	s dateTimes = ##Class(EPRservice.Quality.CommonHelper).GetListFromString(ADateTimes,"\")
	
	s ret = 1
	f Ind=1:1:$listlength(dateTimes) q:ret=-1  d
	.s dateTime=$listget(dateTimes,Ind)
	.s dateTime=$p(dateTime," ",3)_" "_$p(dateTime," ",4)
	.s dateTime=##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(dateTime)
	.q:dateTime=""
	.s fromDate=$p(dateTime," ",1),fromTime=0,toTime=0
	.f Ind1=1:1:$g(ADays) d
	..s fromDate=fromDate+1
	..s toDate=fromDate+1
	..q:checkDate<toDate
	..s result=##Class(EPRservice.Quality.CheckRule.Course).GetMultiTemReCount(AEpisodeID,ATitles,fromDate,fromTime,toDate,toTime)
	..q:$e(result,1,2)="0^"
	..s count=+$e(result,3,$l(result))
	..q:count>0
	..s ret=-1
	
	q ret
}

/// ****************************************************************
/// 说明: 术后三天无上级医师查房记录（手术申请单结束时间）
/// 结论: ret<0 不一致
/// 调试: w ##Class(EPRservice.Quality.CheckRule.UnifyPoint).IsUnify210(AEpisodeID,ATitles,ADateTimes,ADischDateTime,AHours)
/// ****************************************************************
ClassMethod IsUnify210(AEpisodeID As %String, ATitles As %String, ADateTimes As %String, ADischDateTime As %String, AHours As %String = "3") As %String
{
	s ret = 0
	q:(AEpisodeID = "")||(ATitles = "")||(ADateTimes = "") ret
	
	s dischDateTime = ##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(ADischDateTime)
	s checkDate = $p(dischDateTime," ",1)
	s:(checkDate = "") checkDate = +$h
	
	//从HIS得到的时间
	s dateTimes = ##Class(EPRservice.Quality.CommonHelper).GetListFromString(ADateTimes,"\")
	
	s ret = 1
	f ind = 1:1:$listlength(dateTimes) q:ret=-1  d
	.s dateTime=$listget(dateTimes,ind)
	.s dateTime=$p(dateTime," ",3)_" "_$p(dateTime," ",4)
	.s dateTime=##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(dateTime)
	.q:dateTime=""
	.s fromDate=$p(dateTime," ",1)+1,fromTime=0,toTime=0
	.s toDate=fromDate+$g(AHours)
	.q:checkDate<toDate
	.s result=##Class(EPRservice.Quality.CheckRule.Course).GetMultiTemReCount(AEpisodeID,ATitles,fromDate,fromTime,toDate,toTime)
	.q:$e(result,1,2)="0^"
	.s count=+$e(result,3,$l(result))
	.q:count>0
	.s ret=-1
	
	q ret
}

/// Desc:	判断是否缺少出院前一天病程记录(出院前ADelayDays天);
/// Input:	AEpisodeID为患者就诊号;
/// 		ATitles为日常病程记录标题(StructID|可重复模板固定标题\可重复模板固定标题#StructID|可重复模板固定标题);
/// 		ARegDateTime为患者入院日期时间;
/// 		ADisDateTime为患者出院日期时间;
/// 		ADischStatus为患者出院状态;
/// 		ADelayDays为患者出院前日期天数,默认为一天;
/// Return：ret<0:不一致; ret=1一致;
/// Debug:	w ##Class(EPRservice.Quality.CheckRule.UnifyPoint).IsUnify211(AEpisodeID,ATitles,ARegDateTime,ADisDateTime,ADischStatus,ADelayDays)
/// ****************************************************************
ClassMethod IsUnify211(AEpisodeID As %String, ATitles As %String, ARegDateTime As %String, ADisDateTime As %String, ADischStatus As %String, ADelayDays As %String = "1") As %String
{
	s ret = 0
	q:(AEpisodeID = "")||(ATitles = "")||(ARegDateTime = "")||(ADischDateTime = "") ret
	
	q:(ADischStatus [ "自动出院") ret
	
	s regDateTime = ##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(ARegDateTime)
	s disDateTime = ##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(ADisDateTime)
	q:(regDateTime = "")||(disDateTime = "") ret
	
	//同一天入出院不适用于此规则
	q:(($p(disDateTime," ",1) - $p(regDateTime," ",1)) < 1) ret
	
	s ret = 1
	s fromDate = $p(disDateTime," ",1) - (+$g(ADelayDays)),fromTime = 0
	s toDate = $p(disDateTime," ",1),toTime = 0
	s result = ##Class(EPRservice.Quality.CheckRule.Course).GetMultiTemReCount(AEpisodeID,ATitles,fromDate,fromTime,toDate,toTime)
	q:($e(result,1,2) = "0^") ret
	s count = +$e(result,3,$l(result))
	s:(count < 1) ret = -1
	q ret
}

/// Desc:	判断患者死亡6小时后是否完成死亡抢救记录;
/// Input:	AEpisodeID为患者就诊号;
/// 		ATitles为日常病程记录标题(StructID|可重复模板固定标题\可重复模板固定标题#StructID|可重复模板固定标题);
/// 		ADeathDateTime为患者死亡日期时间;
/// 		AHours为死亡后小时数;
/// Return：ret<0:不一致; ret=1一致;
/// Debug:	w ##Class(EPRservice.Quality.CheckRule.UnifyPoint).IsUnify212(AEpisodeID,ATitles,ADeathDateTime,AHours)
ClassMethod IsUnify212(AEpisodeID As %String, ATitles As %String, ADeathDateTime As %String, AHours As %String) As %String
{
	s ret = 0
	q:(AEpisodeID = "")||(ATitles = "")||(ADeathDateTime = "") ret
	
	s deathDateTime = ##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(ADeathDateTime)
	q:(deathDateTime = "") ret

	s checkDateTime = $tr($h,","," ")	
	s checkTimeGap = ##Class(EPRservice.Quality.CommonHelper).GetDateTimeGap(checkDateTime,deathDateTime)
	q:(checkTimeGap <= +$g(AHours)) ret
	
	s fromDate = $p(deathDateTime," ",1), fromTime = $p(deathDateTime," ",2)
	s toDate = +$h, toTime = $p($h,",",2)
	
	s ret = 1
	s result = ##Class(EPRservice.Quality.CheckRule.Course).GetMultiTemReCount(AEpisodeID,ATitles,fromDate,fromTime,toDate,toTime)
	q:($e(result,1,2) = "0^") ret
	s count = +$e(result,3,$l(result))
	s:(count < 1) ret = -1
	
	q ret
}

/// Desc:	判断抢救记录是否在抢救后6小时内完成(抢救医嘱);
/// Input:	AEpisodeID为患者就诊号;
/// 		AHISDateTimes为抢救医嘱日期时间;
/// 		ATitles为日常病程记录标题(StructID|可重复模板固定标题\可重复模板固定标题#StructID|可重复模板固定标题);
/// 		AHours为抢救后小时数;
/// Return：ret<0:不一致; ret=1一致;
/// Debug:	w ##Class(EPRservice.Quality.CheckRule.UnifyPoint).IsUnify213(AEpisodeID,AHISDateTimes,ATitles,AHours)
ClassMethod IsUnify213(AEpisodeID As %String, AHISDateTimes As %String, ATitles As %String, AHours As %String) As %String
{
	s ret = 0
	q:(AEpisodeID = "")||(AHISDateTimes = "")||(ATitles = "") ret
	
	s hours = 24
	s:($g(AHours) '= "") hours = $g(AHours)
	
	s result = ##Class(EPRservice.Quality.CheckRule.Course).GetMultiTemHaDateTime(AEpisodeID,ATitles,"","","","")
	q:($e(result,1,2) = "0^") ret
	
	s dateTimes = $e(result,3,$l(result))
	
	//日常病程记录的发生日期时间
	s dateTimes2 = ##Class(EPRservice.Quality.CommonHelper).GetListFromString(dateTimes,"\")
	
	//HIS动作发生的日期时间,比如抢救医嘱等
	s dateTimes1 = ##Class(EPRservice.Quality.CommonHelper).GetListFromString(AHISDateTimes,"\")
	
	s ret = 1
	for ind = 1:1:$listlength(dateTimes1)
	{
		s dateTime1 = $listget(dateTimes1,ind)
		continue:(dateTime1 = "")
			
		s dateTime2 = $listget(dateTimes2,ind)
		continue:(dateTimes2 = "")
		
		s timeGap = ##Class(EPRservice.Quality.CommonHelper).GetDateTimeGap(dateTime2,dateTime1)
		if (timeGap < 0)||(timeGap > hours)
		{
			s ret = -1	
			q
		}
	}
	
	q ret
}

/// Desc:	判断患者死亡168小时后是否完成唯一模板死亡讨论记录 modify by Candyxu 2013-3-5;
/// Input:	AEpisodeID为患者就诊号;
/// 		AStructID为死亡讨论记录质控结构RowID;
/// 		ADeathDateTime患者死亡日期时间;
/// 		AHours为死亡后小时数;
/// Return：ret<0:不一致; ret=1一致;
/// Debug:	w ##Class(EPRservice.Quality.CheckRule.UnifyPoint).IsUnify214("","","","")
ClassMethod IsUnify214(AEpisodeID As %String, AStructID As %String, ADeathDateTime As %String, AHours As %String) As %String
{
	s ret = 0
	q:(AEpisodeID = "")||(AStructID = "")||(ADeathDateTime = "") ret
	
	s result = ##Class(EPRservice.Quality.CheckRule.Category).IsSaveCatalog2(AEpisodeID,AStructID,ADeathDateTime,AHours)
	
	s:($p(result,"^",1) = 1) ret = 1 
	s:($p(result,"^",1) = -1) errInfo = ($p(result,"^",2)),ret = "1"_errInfo
	q ret
}

/// Desc:	判断病案首页.手术情况同一天最多有且只能有一条主要手术;
/// Input:	AEpisodeID为患者就诊号;
/// 		ADateElements指手术日期字符串,"\"分隔
/// 		AMainOperElements指是否主要手术字符串,"\"分隔;
/// 		注意,手术日期顺序要与是否主要手术顺序一一对应;
/// Return:	条件触发返回-1;
/// Debug:	w ##Class(EPRservice.Quality.CheckRule.UnifyPoint).IsUnify215(AEpisodeID, ADateElements, AMainOperElements)
ClassMethod IsUnify215(AEpisodeID As %String, ADateElements As %String, AMainOperElements As %String) As %String
{
	s ret = 0
	q:(AEpisodeID = "")||(ADateElements = "")||(AMainOperElements = "") ret
	
	s UniqueKey = $i(^CacheTemp)
	k ^CacheTemp("EPRQuality","OperDate",UniqueKey)
	
	s DateElementsData = ##Class(EPRservice.Quality.CheckRule.Template).GetSingleValues(AEpisodeID,ADateElements)
	q:($e(DateElementsData,1,2) = "0^") ret
	s DateElementsData = $e(DateElementsData,3,$l(DateElementsData))
	
	s MainOperElementsData = ##Class(EPRservice.Quality.CheckRule.Template).GetSingleValues(AEpisodeID,AMainOperElements)
	q:($e(MainOperElementsData,1,2) = "0^") ret
	s MainOperElementsData = $e(MainOperElementsData,3,$l(MainOperElementsData))
	
	s ret = 1
	for i = 1:1:$l(DateElementsData)
	{
		s date = $p(DateElementsData,"\",i)
		continue:(date = "")
		
		s date = ##Class(EPRservice.Quality.CommonHelper).ChangeDateToNum(date)

		s mainOper = $p(MainOperElementsData,"\",i)
		s:(mainOper = "") mainOper = "否"
		
		s ^CacheTemp("EPRQuality","OperDate",UniqueKey,date,i) = mainOper
	}
		
	s countList = ""
	s flag = "N"
	
	s tempDate = ""
	for  
	{
		s tempDate = $o(^CacheTemp("EPRQuality","OperDate",UniqueKey,tempDate)) 
		q:(tempDate = "")
		
		s count = 0
		s index = ""
		for  
		{
			s index = $o(^CacheTemp("EPRQuality","OperDate",UniqueKey,tempDate,index)) 
			q:(index = "")
			
			s tempMainOper = $g(^CacheTemp("EPRQuality","OperDate",UniqueKey,tempDate,index))
			s:(tempMainOper = "是") count = count + 1
		}
		s countList = countList_$lb(count)
	}
	
	k ^CacheTemp("EPRQuality","OperDate",UniqueKey)
	
	for j = 1:1:$listlength(countList)
	{
		s tmpCount = $list(countList,j)
		continue:(tmpCount = "")
		
		if (tmpCount '= 1) 
		{
			s ret = -1
			q
		}
	}
	
	q ret
}

/// Desc:	全角数字全角字母
/// Input:	AEpisodeID为就诊号;
/// 		AElement1为界面模板单元代码；      
/// Return:	条件触发返回-1
/// Debug:	w ##class(EPRservice.Quality.CheckRule.UnifyPoint).IsUnify216(AEpisodeID,AElement1)
ClassMethod IsUnify216(AEpisodeID As %String, AElement1 As %String) As %String
{
	s ret = 0
	q:(AEpisodeID = "")||(AElement1 = "") ret

	s ElementData1 = "", tmpElementData1 = ""
	s ElementData1 = ##Class(EPRservice.Quality.CheckRule.Template).GetSingleValues(AEpisodeID,AElement1)
	q:($e(ElementData1,1,2) = "0^") ret
	
	s ElementData1 = $e(ElementData1,3,$l(ElementData1))
	q:(ElementData1 = "") ret

	s ret = 1
	s tmpElementData1 = $tr(ElementData1,"１２３４５６７８９０ＡＢＣＤＥＦＧＨＩＪＫＬＭＮＯＰＱＲＳＴＵＶＷＸＹＺａｂｃｄｅｆｇｈｉｊｋｌｍｎｏｐｑｒｓｔｕｖｗｘｙｚ，。－＋＼／")
	s:(tmpElementData1 '= ElementData1) ret = -1
	
	q ret
}

/// Desc: 	同一模板中多元素一致性判断(当Element1,Operator1或Values1中任意各值,Elements2,Operator2,Value2时触发)
/// 		Value1为多值 ,Values2多值
/// Output: ret<0 
/// Debug: 	w ##Class(EPRservice.Quality.CheckRule.UnifyPoint).IsUnify217(EpisodeID,Element1,Operator1,Values1,Elements2,Operator2,Value2)
ClassMethod IsUnify217(AEpisodeID As %String, AElement1 As %String, AOperator1 As %String = "=", AValues1 As %String, AElements2 As %String, AOperator2 As %String = "=", AValues2 As %String) As %String
{
	s ret = 0
	q:(AEpisodeID = "")||(AElement1 = "")||(AElements2 = "") ret
	
	//AOperator1和AOperator2必须为=,!=,>,<,>=,<=之一
	q:(AOperator1 '= "=")&&(AOperator1 '= "'=")&&(AOperator1 '= ">")&&(AOperator1 '= "<")&&(AOperator1 '= ">=")&&(AOperator1 '= "<=") ret
	q:(AOperator2 '= "=")&&(AOperator2 '= "'=")&&(AOperator2 '= ">")&&(AOperator2 '= "<")&&(AOperator2 '= ">=")&&(AOperator2 '= "<=") ret
	
	s ret = 1
	s ElementData1 = ##Class(EPRservice.Quality.CheckRule.Template).GetSingleValues(AEpisodeID,AElement1)
	q:($e(ElementData1,1,2) = "0^") ret
	s ElementData1 = $e(ElementData1,3,$l(ElementData1))
	 
	s ret = 2
	s ElementData2 = ##Class(EPRservice.Quality.CheckRule.Template).GetSingleValues(AEpisodeID,AElements2)
	q:($e(ElementData2,1,2) = "0^") ret
	s ElementData2 = $e(ElementData2,3,$l(ElementData2))
	
	//b
	s ret = 3
	f i = 1:1:$l($g(AValues1),"\") d               //循环Values1中包含的每一个值
	.//b "s"
	.s ValuesData1 = $p($g(AValues1),"\",i)
	.i (Operator1 = "=") d  q:'(ElementData1 = ValuesData1)
	.i (Operator1 = "'=") d  q:'(ElementData1 '= ValuesData1)
	.i (Operator1 = ">") d  q:'(ElementData1 > ValuesData1)
	.i (Operator1 = "<") d  q:'(ElementData1 < ValuesData1)
	.i (Operator1 = ">=") d  q:'(ElementData1 >= ValuesData1)
	.i (Operator1 = "<=") d  q:'(ElementData1 <= ValuesData1)
	.q:(ret = -1)
	.f j = 1:1:$l($g(AValues2),"\") d
	..//b "s"
	..s ValuesData2 = $p($g(AValues2),"\",j)		//循环Values2中包含的每一个值
	..i (Operator2 = "=") d  s:(ElementData2 = ValuesData2) ret = -1
	..i (Operator2 = "'=") d  s:(ElementData2 '= ValuesData2) ret = -1
	..i (Operator2 = ">") d  s:(ElementData2 > ValuesData2) ret = -1
	..i (Operator2 = "<") d  s:(ElementData2 < ValuesData2) ret = -1
	..i (Operator2 = ">=") d  s:(ElementData2 >= ValuesData2) ret = -1
	..i (Operator2 = "<=") d  s:(ElementData2 <= ValuesData2) ret = -1
	..q:(ret = -1)

	q ret
}

/// Desc: 	判断病案首页费用与HIS病案大类费用是否不符(Value1为多值要求顺序与HIS一致);
/// Input:	AEpisodeID为就诊号;
/// 		AElements1为病案首页上费用单元集合，多个用"\"分隔;
/// 		AValues1为HIS病案大类费用，多个用"\"分隔;	
/// Output: ret<0 
/// Debug: 	w ##Class(EPRservice.Quality.CheckRule.UnifyPoint).IsUnify218("","","")
ClassMethod IsUnify218(AEpisodeID As %String, AElements1 As %String, AValues1 As %String = "") As %String
{
	s ret = 0
	q:(AEpisodeID = "")||(AElements1 = "")||(AValues1 = "") ret
	
	s ElementsData1 = ##Class(EPRservice.Quality.CheckRule.Template).GetSingleValues(AEpisodeID,AElements1)
	q:($e(ElementsData1,1,2) = "0^") ret
	s ElementsData1 = $e(ElementsData1,3,$l(ElementsData1))
	
	s ValuesData1 = $p(AValues1,"^",2)
	q:(ValuesData1 = "") ret
	
	s ret = 1
	for i = 1:1:$length(ValuesData1,"\") 
	{             
		s ValueData = $p(ValuesData1,"\",i)
		s ElementData = $p(ElementsData1,"\",i)
		if (ValueData '= ElementData)
		{
			s ret = -1
			q	
		}
	}
	q ret
}

/// Desc:	如果没有打印住院发票则不允许打印病案首页;如果科主任授权后,打印时才能通过质控检查;
/// 		*目前应用于南通项目*
/// Input:	AEpisodeID为就诊号;
/// 		APrintDocID为EPRTemplateCategoryID(类型为PrtTemplate);
/// 		AEPRAction为病历操作类型；	
/// Output:	ret<0 
/// Debug: 	w ##Class(EPRservice.Quality.CheckRule.UnifyPoint).IsUnify219("","","")
ClassMethod IsUnify219(AEpisodeID As %String, APrintDocID As %String, AEPRAction As %String) As %String
{
	s ret = 0
	q:(AEpisodeID = "")||(APrintDocID = "")||(AEPRAction = "") ret
	
	s QuaAppoint = ""
	s QuaCateCharpterID = ##Class(EPRmeta.EPRTemplateCategory).GetParentIDByDocID(APrintDocID)
	
	s QuaRowID = ""
	for {
		s QuaRowID = $o(^DHCEPRI.EPRActionAppointI("IdxEpisode"," "_AEpisodeID, QuaRowID))
		q:(QuaRowID = "")||(QuaAppoint '= "")
		
		s flag = ##Class(web.eprajax.EPRAction).CheckAppointIsActive(QuaRowID)
		continue:(flag = "-1")
		
		s AppointCateCharpter = $list(^DHCEPRI.EPRActionAppointD(QuaRowID),2)
		continue:(AppointCateCharpter '[ QuaCateCharpterID)
		
		s EPRAction = $list(^DHCEPRI.EPRActionAppointD(QuaRowID),8)
		continue:(EPRAction '[ AEPRAction)
		
		s QuaAppoint = "1"	
	}
	
	s ret = 1
	
	// PayFlag=1表示全付，PayFlag=0表示未付或部分付，如果EpisodeID不存在则PayFlag=1
	s PayFlag = ##Class(web.UDHCJFCOMMON).isPaidByAdm(AEpisodeID)
	s:(PayFlag = "0")&&(QuaAppoint '= "1") ret = -1

	q ret
}

/// Creator:	wangwentao
/// Desc:	唯一模板判断一个日期单元或多个日期单元是否超出入出院日期时间;
/// Input:	AEpisodeID			为患者就诊号;
/// 		AElement1			为指定模板单元RowID;
/// 		ARegDate			为入院日期时间;
/// 		ADischDate			为出院日期时间;
/// 		AIsOneFlag			为一个日期单元:Y(默认); 多个日期单元:N
/// Return：ret<0				触犯条目规则;
/// 		ret>0				正确;
/// Debug:	##Class(EPRservice.Quality.CheckRule.UnifyPoint).IsUnifyN20120501A(EpisodeID,"E13683\E13684",{HISRegTime},{HISDischTime},"N")
ClassMethod IsUnifyN20120501A(AEpisodeID As %String, AElement1 As %String, ARegDate As %String, ADischDate As %String, AIsOneFlag As %String = "Y") As %String
{
	//b "s"
	s ret = 0
	
	q:(AEpisodeID = "")||(AElement1 = "")||(ARegDate = "") ret
	
	s (DischDateTime)=""
	
	s ElementData1 = ##Class(EPRservice.Quality.CheckRule.Template).GetSingleValues(AEpisodeID,AElement1)
	q:($e(ElementData1,1,2) = "0^") ret_"^模板单元<"_AElement1_">取值异常退出!"
	s ElementData1 = $e(ElementData1,3,$l(ElementData1))
	q:(ElementData1 = "") ret
	
	s:(AIsOneFlag="Y") ElementData1 = $p(ElementData1,"\") 

	s ElementData1 = ##Class(EPRservice.Quality.CommonHelper).GetListFromString(ElementData1,"\","Y")
	
	s RegDateTime = ##Class(EPRservice.Quality.CommonHelper).ChangeDateTime(ARegDate)
	s RegDate = $p(RegDateTime," ",1),RegTime = $p(RegDateTime," ",2)
	
	for Ind=1:1:$ll(ElementData1)
	{
		//b "s"
		s tmpDateTimeValue = $lg(ElementData1,Ind)
		s tmpDateTimeValue = ##Class(EPRservice.Quality.CommonHelper).ChangeDateTime(tmpDateTimeValue)
		s tmpDateValue = $p(tmpDateTimeValue," ",1),tmpTimeValue = $p(tmpDateTimeValue," ",2)
		
		//处理检查的日期单元无时间并且与ARegDate同一天的情况
		s:((tmpDateValue = RegDate)&&(tmpTimeValue = "00:00:00")&&(RegTime '= "00:00:00")) tmpDateTimeValue = RegDateTime
		
		s ret = 1
		
		s flag = ##Class(EPRservice.Quality.CommonHelper).GetDateTimeGap(tmpDateTimeValue,RegDateTime)
		s:(flag < 0) ret = -1
		s:(ADischDate = "") ADischDate = $zd(+$h,3)_" "_$zt($p($h,",",2),1)
		s flag = ##Class(EPRservice.Quality.CommonHelper).GetDateTimeGap(ADischDate,tmpDateTimeValue)
		s:(flag < 0) ret = -1
		
		q:(+ret = -1)
	}
	
	q ret
}

/// Creator:	wangwentao
/// Desc:	可重复模板判断一个日期单元或同一模板中的多个日期单元是否超出入出院日期时间;
/// Input:	AEpisodeID			为患者就诊号;
/// 		AElement1			为指定模板单元RowID;如多个单元时,多个单元必须在同一模板上,并用"\"分隔;
/// 		ARegDate			为入院日期时间;
/// 		ADischDate			为出院日期时间;
/// 		AIsOneFlag			为一个日期单元:Y(默认); 多个日期单元:N
/// Return：ret<0				触犯条目规则;
/// 		ret>0				正确;
/// Debug:	##Class(EPRservice.Quality.CheckRule.UnifyPoint).IsUnifyN20120501B(EpisodeID,"E13683\E13684",{HISRegTime},{HISDischTime},"N")
ClassMethod IsUnifyN20120501B(AEpisodeID As %String, AElement1 As %String, ARegDate As %String, ADischDate As %String, AIsOneFlag As %String = "Y") As %String
{
	//b "s"
	s ret = 0
	
	q:(AEpisodeID = "")||(AElement1 = "")||(ARegDate = "") ret
	
	s ret=1
	
	//通常情况
	s:(AIsOneFlag="Y") AElement1 = $p(AElement1,"\") 
	
	//处理入参
	s Parameter =  $e($p(AElement1,"\"),2,$l($p(AElement1,"\")))
	
	s result = ##Class(%ResultSet).%New("EPRservice.Quality.DataGather.EPRInfo:GetInstanceData")
	s sc = result.Execute(AEpisodeID,Parameter) 
	While (result.Next()) 
	{
		s (Title,InstanceID,HappendDate,HappenTime) = ""
		
		s Title = result.Data("Title")
		s InstanceID = result.Data("InstanceID")
		s HappenDate = result.Data("HappenDate")
		s HappenTime = result.Data("HappenTime")
		
		s ret=2
		
		//处理多余的可重复模板,如果标题为"作废",则退出.
		q:(Title="作废")
		
		//返回值格式 Status^List
		s ElementData1 = ##Class(EPRservice.Quality.CheckRule.Template).GetMultipleValues(AEpisodeID,AElement1,InstanceID)
		continue:($e(ElementData1,1,2) = "0^") 
		s ElementData1=$e(ElementData1,3,$l(ElementData1))
		q:($lg(ElementData1) = "")
		
		s ret=3

		s RegDateTime = ##Class(EPRservice.Quality.CommonHelper).ChangeDateTime(ARegDate)
		s RegDate = $p(RegDateTime," ",1),RegTime = $p(RegDateTime," ",2)
		
		for Ind=1:1:$ll(ElementData1)
		{
			//b "s"
			s tmpDateTimeValue = $lg(ElementData1,Ind)
			s tmpDateTimeValue = ##Class(EPRservice.Quality.CommonHelper).ChangeDateTime(tmpDateTimeValue)
			s tmpDateValue = $p(tmpDateTimeValue," ",1),tmpTimeValue = $p(tmpDateTimeValue," ",2)

			//处理检查的日期单元无时间并且与ARegDate同一天的情况
			s:((tmpDateValue = RegDate)&&(tmpTimeValue = "00:00:00")&&(RegTime '= "00:00:00")) tmpDateTimeValue = RegDateTime
			
			s ret = 4
			
			s flag = ##Class(EPRservice.Quality.CommonHelper).GetDateTimeGap(tmpDateTimeValue,RegDateTime)
			s:(flag < 0) ret = -1_"^提示:第"_$p(InstanceID,"||",2)_"条记录!"
			s:(ADischDate = "") ADischDate = $zd(+$h,3)_" "_$zt($p($h,",",2),1)
			s flag = ##Class(EPRservice.Quality.CommonHelper).GetDateTimeGap(ADischDate,tmpDateTimeValue)
			s:(flag < 0) ret = -1_"^提示:第"_$p(InstanceID,"||",2)_"条记录!"
			
			q:(+ret = -1)
		}
			
		q:(+ret=-1)
	
	}
	
	q ret
}

/// Creator:	wangwentao
/// Desc:	判断唯一模板一个单元A值是否等于多个单元ABC...的值之一;如全不等于,则返回-1;
/// Input:	AEpisodeID			为患者就诊号;
/// 		AElement1			为指定模板单元RowID;
/// 		AElement2			为指定模板单元RowID;如多个单元时,用"\"分隔;
/// Return：ret<0				触犯条目规则;
/// 		ret>0				正确;
/// Debug:	##Class(EPRservice.Quality.CheckRule.UnifyPoint).IsUnifyN20120502A(EpisodeID,"E13696","E13686\E13687")
ClassMethod IsUnifyN20120502A(AEpisodeID As %String, AElement1 As %String, AElement2 As %String) As %String
{
	//b "s"
	s ret = 0

	q:(AEpisodeID="")||(AElement1="")||(AElement2="") ret
	
	s ret=1
	
	s ElementData1=##Class(EPRservice.Quality.CheckRule.Template).GetSingleValues(EpisodeID,AElement1)
	q:$e(ElementData1,1,2)="0^" ret_"^模板单元<"_AElement1_">取值异常退出!"
	s ElementData1=$e(ElementData1,3,$l(ElementData1))
	q:(ElementData1 = "") ret
	 
	s ret=2
	
	s ElementData2=##Class(EPRservice.Quality.CheckRule.Template).GetSingleValues(EpisodeID,AElement2)
	q:$e(ElementData2,1,2)="0^" ret_"^模板单元<"_AElement2_">取值异常退出!"
	s ElementData2=$e(ElementData2,3,$l(ElementData2))
	q:(ElementData2 = "") ret
	
	s ret=3
	
	s ElementData2 = ##Class(EPRservice.Quality.CommonHelper).GetListFromString(ElementData2,"\","Y")

	s ret=4
	
	s:($lf(ElementData2,ElementData1)=0) ret=-1
	

	q ret
}

/// Creator:	wangwentao
/// Desc:	判断可重复模板同一个模板一个单元A值是否等于同一个模板多个单元ABC...的值之一;如全不等于,则返回-1;
/// Input:	AEpisodeID			为患者就诊号;
/// 		AElement1			为指定模板单元RowID;
/// 		AElement2			为指定模板单元RowID;如多个单元时,用"\"分隔;
/// Return：ret<0				触犯条目规则;
/// 		ret>0				正确;
/// Debug:	##Class(EPRservice.Quality.CheckRule.UnifyPoint).IsUnifyN20120502A(EpisodeID,"E13696","E13686\E13687")
ClassMethod IsUnifyN20120502B(AEpisodeID As %String, AElement1 As %String, AElement2 As %String) As %String
{
	//b "s"
	s ret = 0

	q:(AEpisodeID="")||(AElement1="")||(AElement2="") ret
	q:($l(AElement1,"\")>1) ret
	
	s ret=1
	
	//处理入参
	s Parameter =  $e(AElement1,2,$l(AElement1))
	
	s result = ##Class(%ResultSet).%New("EPRservice.Quality.DataGather.EPRInfo:GetInstanceData")
	s sc = result.Execute(AEpisodeID,Parameter) 
	While (result.Next()) 
	{
		s (Title,InstanceID,HappendDate,HappenTime) = ""
		
		s Title = result.Data("Title")
		s InstanceID = result.Data("InstanceID")
		s HappenDate = result.Data("HappenDate")
		s HappenTime = result.Data("HappenTime")
		
		s ret=2
		
		//处理多余的可重复模板,如果标题为"作废",则退出.
		q:(Title="作废")
		
		s ElementData1 = ##Class(EPRservice.Quality.CheckRule.Template).GetMultipleValues(AEpisodeID,AElement1,InstanceID)
		continue:($e(ElementData1,1,2) = "0^") 
		s ElementData1=$e(ElementData1,3,$l(ElementData1))
		q:($lg(ElementData1) = "")
		
		s ret=3
		
		s ElementData2 = ##Class(EPRservice.Quality.CheckRule.Template).GetMultipleValues(AEpisodeID,AElement2,InstanceID)
		continue:($e(ElementData2,1,2) = "0^") 
		s ElementData2=$e(ElementData2,3,$l(ElementData2))
		q:($lg(ElementData2) = "")
		
		s ret=4
		
		s ElementData1 = $lg(ElementData1)
	
		s:($lf(ElementData2,ElementData1)=0) ret=-1_"^提示:第"_$p(InstanceID,"||",2)_"条记录!"
		
		q:(+ret=-1)
	
	}
	
	q ret
}

/// Creator:	wangwentao
/// Desc:	判断可重复模板记录次数是否等于唯一模板多个单元等于某值的个数;如全不等于,则返回-1;
/// Input:	AEpisodeID			为患者就诊号;
/// 		AElement1			为指定唯一模板单元RowID;如多个单元时,用"\"分隔;
/// 		ATitles				可重复模板记录次数
/// 			AValue1				唯一模板单元值;如多个单元时,用"\"分隔;
/// Return：ret<0				触犯条目规则;
/// 		ret>0				正确;
/// Debug:	##Class(EPRservice.Quality.CheckRule.UnifyPoint).IsUnifyN20120503B(EpisodeID,"E13686\E13687","561|术前病历")
ClassMethod IsUnifyN20120503B(AEpisodeID As %String, AElement1 As %String, ATitles As %String, AValue1 As %String) As %String
{
	//b "s"
	s ret = 0
	
	q:(AEpisodeID = "")||(AElement1 = "")||(ATitles = "")||(AValue1 = "") ret
	
	s ret = 1
	
	s ElementData1 = ##Class(EPRservice.Quality.CheckRule.Template).GetSingleValues(AEpisodeID,AElement1)
	q:($e(ElementData1,1,2) = "0^") ret_"^模板单元<"_AElement1_">取值异常退出!"
	s ElementData1 = $e(ElementData1,3,$l(ElementData1))
	q:(ElementData1 = "") ret

	s ret = 2
	
	s ElementData1 = ##Class(EPRservice.Quality.CommonHelper).GetListFromString(ElementData1,"\","Y")

	s ret = 3
	
	s count1=0,tmpDataValue=""
   	for i = 1:1:$listlength(ElementData1) {
		
		s tmpDataValue = $listget(ElementData1,i)
		continue:(tmpDataValue= "")
		
		s:($f("\"_AValue1_"\","\"_tmpDataValue_"\")>0) count1=count1+1
	}

	s ret = 4
	
	s count2 =0
	s result = ##Class(EPRservice.Quality.CheckRule.Course).GetMultiTemReCount(AEpisodeID,ATitles,"","","","")
	q:($e(result,1,2) = "0^") ret_"^模板单元<"_AElement1_">取值异常退出!"
	s count2 = +$e(result,3,$l(result))
	
	s ret = 5
	
	s:(count1 '= count2) ret = -1
	
	q ret
}

/// Creator:	wangwentao
/// Desc:	判断可重复模板是否在指定的时间内完成
/// Input:	AEpisodeID				为患者就诊号;
/// 		ATitles					可重复模板的标题;如多个标题时,用"\"分隔;
/// 		ARegDateTime			开始日期;如入院日期	
/// 		ADisDateTime		(默认为空)结束日期;如出院日期;	
/// 		AHours				(默认为空)指定小时内完成;	
/// 		ACondition			(默认为空)当特定的检查条件成立时,调整AHours为特定小时内完成;
/// 								条件{1}
/// 								{"特级护理"}					
/// 								{"重症监护"}	
/// 		AConditionHours		(默认为空)当特定的检查条件成立时,调整AHours为特定小时内完成;
/// 								格式"Today^N^M";ARegDateTime当天剩余小时少于指定剩余N小时,则延长M小时内完成!
/// 								如"Today^8^24",当然16点以后入院的患者,时限质控延长24小时;
/// 		ACheckType			(默认为CheckPrompt)检查类型
/// 								{CheckPrompt}
/// 								{CheckDisch}
/// 								{CheckAdmit}
/// 		AForcedRefFlag		(默认为1)为1时用于CheckPrompt类型中,强制显示参考信息;	
/// 		ATimeoutCtlFlag		(默认为0)为1时用于CheckPrompt类型中,超时之后再提示;
/// 		AAppointTimeCtlFlag	(默认为0)为1时用于CheckPrompt类型中,直到在规定时间内完成,才能通过;
/// Return：ret<0				;触犯条目规则
/// 		ret>0				正确;
/// Debug:	##Class(EPRservice.Quality.CheckRule.UnifyPoint).IsUnifyN20120504B(EpisodeID,"561|主治医师查房记录\主任医师查房记录",{HISRegTime},{HISDischTime},48,{HISCareClass},"Today^8^24","CheckPrompt",1,0,1)
ClassMethod IsUnifyN20120504B(AEpisodeID As %String, ATitles As %String, ARegDateTime As %String, ADisDateTime As %String = "", AHours As %String = "", ACondition As %String = "", AConditionHours As %String = "", ACheckType As %String = "CheckPrompt", AForcedRefFlag As %String = "1", ATimeoutCtlFlag As %String = "0", AAppointTimeCtlFlag As %String = "0") As %String
{
	//b "s"
	s ret = 0, result = ""
	q:(AEpisodeID = "")||(ATitles = "")||(ARegDateTime = "") ret
	
	s ret = 1
	
	//处理相关条件下,要求在当天或规定时间内完成的情况.
	if (ACondition = "1")||(ACondition = "特级护理")||(ACondition = "重症监护") 
	{
		if ($zcvt($p(AConditionHours,"^",1),"U") = "TODAY")
		{
			s Today = $p(ARegDateTime," ")_" 23:59:59"
			s TodayHours = ##Class(EPRservice.Quality.CommonHelper).GetDateTimeGap(Today,ARegDateTime)
			//s AHours = $j(TodayHours,3,1)
			
			//如果当天TodayHours小于指定剩余N小时,则延长M小时内完成!
			if ($p(AConditionHours,"^",2) '= "")&&($p(AConditionHours,"^",2)=+$p(AConditionHours,"^",2))&&($p(AConditionHours,"^",3) '= "")&&($p(AConditionHours,"^",3)=+$p(AConditionHours,"^",3))
			{
				s TodayLeastHours = $p(AConditionHours,"^",2)
				s AddHours = $p(AConditionHours,"^",3)
				s:(TodayHours < TodayLeastHours) AHours = TodayHours + AddHours
			}
		}
		elseif (AConditionHours = +AConditionHours)
		{
			s AHours = AConditionHours
		}		
	}
	
	
	s ret = 2
	
	//处理入院时间
	s regDateTime = ##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(ARegDateTime)
	s startDate = $p(regDateTime," ",1), startTime = $p(regDateTime," ",2)
	
	//处理检查日期 取ATitles一个完成的时间
	s result = ##Class(EPRservice.Quality.CheckRule.Course).GetMultiTemHaDateTime(AEpisodeID,ATitles,"","","","")
	q:($e(result,1,2) = "0^") ret
	s checkDateTimeSys=$p($e(result,3,$l(result)),"\")
	s checkDateTime=""
	s:(checkDateTimeSys'="") checkDateTime = ##Class(EPRservice.Quality.CommonHelper).ChangeDateTime(checkDateTimeSys)
	
	
	s ret = 3
	
	s IsSavedFlag = $s(checkDateTimeSys="":0,1:1)
	
	
	s ret = 4
	
	//处理ATitles没完成或提前完成的情况
	s:(checkDateTime = "") checkDateTime = $g(ADisDateTime)
	s:(checkDateTime = "") checkDateTime = $zdt($h,3,1)
	s tmpTimeGap = ##Class(EPRservice.Quality.CommonHelper).GetDateTimeGap(checkDateTime,ARegDateTime)
	q:(tmpTimeGap < 0) ret_"^模板单元<"_ATitles_">时间取值异常退出!"
	
	
	s ret = 5
		
	s ret = ##Class(EPRservice.Quality.CommonHelper).GetQualityPromptByCheckType("", checkDateTime, ARegDateTime, AHours, IsSavedFlag, ACheckType, AForcedRefFlag, ATimeoutCtlFlag,AAppointTimeCtlFlag)
	
	
	q ret
}

/// Creator:	wangwentao
/// Desc:	判断可重复模板每N天完成指定记录N次,只检查M天,如当天的时间不足指定的小时数N,则延长M小时
/// Input:	AEpisodeID				为患者就诊号;
/// 		ATitles					可重复模板的标题;如多个标题时,用"\"分隔;
/// 		ARegDateTime			开始日期;如入院日期	
/// 		ADisDateTime		(默认为空)结束日期;如出院日期;	
/// 		ADays				(默认为空)指定天数N;
/// 			ATimes				(默认为 1)指定记录的完成次数据N;
/// 			AEndDays			(默认为空)截止天数M
/// 		ACondition			(默认为-1)当特定的检查条件成立时,调整检查的时间范围;
/// 								条件{1}	
/// 		AConditionHours		(默认为空)当特定的检查条件成立时,调整检查的时间范围;
/// 								格式"Today^N^M";ARegDateTime当天剩余小时少于指定剩余N小时,则延长M小时内完成!
/// 								如"Today^8^24",当然16点以后入院的患者,时限质控延长24小时;
/// Return：ret<0				;触犯条目规则
/// 		ret>0				正确;
/// Debug:	##Class(EPRservice.Quality.CheckRule.UnifyPoint).IsUnifyN20120505B(876089,"561|","2011-12-13 16:43:00",$zdt($h,3,1),3,3,3,1,"Today^8^24")
ClassMethod IsUnifyN20120505B(AEpisodeID As %String, ATitles As %String, ARegDateTime As %String, ADisDateTime As %String, ADays As %String, ATimes As %String = 1, AEndDays As %String = "", ACondition As %String = "-1", AConditionHours As %String = "") As %String
{
	s ret = 0, errInfo = ""
	q:(AEpisodeID = "")||(ATitles = "")||(ARegDateTime = "")||(ADays = "") ret

	s regDateTime = ##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(ARegDateTime)
	s disDateTime = ##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(ADisDateTime)
	
	
	s ret = 1
	
	//处理开始检查日期(内部格式)
	s fromDate = $p(regDateTime," ",1)
	
	s ret = 2
	
	s (tmpAddDays,AddHours) =0

	//处理相关条件(AConditions'="")下,当天M时间之后入院患者,推后N小时开始检查.
	if (ACondition '= 0)&&(ACondition '= -1)&&(ACondition '= "")
	{	
		//AConditionHours = "Today^TodayLeastHours^AddHours"
		if ($zcvt($p(AConditionHours,"^",1),"U") = "TODAY")
		{
			s Today = $p(ARegDateTime," ")_" 23:59:59"
			s TodayHours = ##Class(EPRservice.Quality.CommonHelper).GetDateTimeGap(Today,ARegDateTime)
			//s AHours = $j(TodayHours,3,1)
			
			//如果当天TodayHours小于指定剩余N小时,则延长M小时检查
			if ($p(AConditionHours,"^",2) '= "")&&($p(AConditionHours,"^",2)=+$p(AConditionHours,"^",2))&&($p(AConditionHours,"^",3) '= "")&&($p(AConditionHours,"^",3)=+$p(AConditionHours,"^",3))
			{
				s TodayLeastHours = $p(AConditionHours,"^",2)
				s AddHours = $p(AConditionHours,"^",3)
				s:(TodayHours < TodayLeastHours) tmpAddDays =  (AddHours / 24)
			}
		}
		elseif (AConditionHours = +AConditionHours)
		{
			s tmpAddDays =  (AddHours / 24)
		}		
	}
	elseif (ACondition = 0)
	{
		//处理条件返回值为0时退出.
		q ret
	}
	
	s ret = 3
	
	//处理结束检查日期
	s checkDate = $p(disDateTime," ",1)
	s:(checkDate = "") checkDate = +$h
	
	//处理加1约等于toDate的23:59:59
	s toDate = +checkDate + 1
	
	
	s ret = 4
	
	//处理中断检查日期 如入院3天内,至少3次病程记录的情况
	s endDate = $s((AEndDays'="")&&(AEndDays=+AEndDays):fromDate+AEndDays, 1:0)
	
	
	s ret = 5

	f tmpDate = fromDate:$g(ADays):toDate q:(+ret = -1)  d
	. //b "s" w "---------------"_tmpDate_"---------------"
	. q:(toDate < (tmpDate + ADays))
	. q:(tmpDate >= endDate)&&(endDate'=0)
	. s result = ##Class(EPRservice.Quality.CheckRule.Course).GetMultiTemReCount(AEpisodeID,ATitles,tmpDate,0,tmpDate+ADays+tmpAddDays,0)
	. q:($e(result,1,2) = "0^")
	. s count = +$e(result,3,$l(result))
	. q:(count >= ATimes)
	. s ret=-1
	. s:(ATimes'=1) errInfo="提示:"_$zd(tmpDate,3)_"至"_$zd(tmpDate+(ADays-1)+tmpAddDays,3)_"应写"_ATimes_"次记录!系统已找到"_count_"次记录!"_"+"_tmpAddDays_"h"
	. s:(ATimes=1) errInfo="提示:缺少"_$zd(tmpDate,3)_"至"_$zd(tmpDate+(ADays-1)+tmpAddDays,3)_"的"_ATimes_"次记录!"_"+"_tmpAddDays_"h"
	. s ret = ret_"^"_errInfo
	
	
	q ret
}

/// Creator:	wangwentao
/// Desc:	判断唯一模板日期单元是否超出入出院时间(比如病案首页中确诊日期、手术日期等，为空则不判断);
/// Input:	AEpisodeID为患者就诊号;
/// 		AElement1为指定模板单元RowID;
/// 		ARegDate为患者入院日期;
/// 		ADischDate为患者出院日期;
/// Return：ret<0:不一致; ret=1一致;
/// Debug:	w ##Class(EPRservice.Quality.CheckRule.UnifyPoint).IsUnifyN20120506A("201871","","","")
ClassMethod IsUnifyN20120506A(AEpisodeID As %String, AElement1 As %String, ARegDate As %String, ADischDate As %String, AIsOneFlag As %String = "Y") As %String
{
	//b "s"
	s ret = 0
	q:(AEpisodeID = "")||(AElement1 = "")||(ARegDate = "") ret
	
	s (DischDateTime)=""
	
	s ElementData1 = ##Class(EPRservice.Quality.CheckRule.Template).GetSingleValues(AEpisodeID,AElement1)
	q:($e(ElementData1,1,2) = "0^") ret
	s ElementData1 = $e(ElementData1,3,$l(ElementData1))
	q:(ElementData1 = "") ret
	
	s:(AIsOneFlag="Y") ElementData1 = $p(ElementData1,"\") 

	s ElementData1 = ##Class(EPRservice.Quality.CommonHelper).GetListFromString(ElementData1,"\","Y")
	
	//Add by Liaowp 2010-06-22
	//20120524 wangwnetao update
	//遇类似首页中当日确诊,确诊日期没有时间,则时间同入院时间,具体在For循环中处理。
	s RegDateTime = ##Class(EPRservice.Quality.CommonHelper).ChangeDateTime(ARegDate)
	s RegDate = $p(RegDateTime," ",1),RegTime = $p(RegDateTime," ",2)
	//End Add
	
	for Ind=1:1:$ll(ElementData1)
	{
		//b "s"
		s tmpDateTimeVal = $lg(ElementData1,Ind)
		s tmpDateTimeVal = ##Class(EPRservice.Quality.CommonHelper).ChangeDateTime(tmpDateTimeVal)
		s tmpDateVal = $p(tmpDateTimeVal," ",1),tmpTimeVal = $p(tmpDateTimeVal," ",2)
		s:((tmpDateVal = RegDate)&&(tmpTimeVal = "00:00:00")&&(RegTime '= "00:00:00")) tmpDateTimeVal = RegDateTime
		
		s ret = 1
		s flag = ##Class(EPRservice.Quality.CommonHelper).GetDateTimeGap(tmpDateTimeVal,RegDateTime)
		s:(flag < 0) ret = -1
		s:(ADischDate = "") ADischDate = $zd(+$h,3)_" "_$zt($p($h,",",2),1)
		s flag = ##Class(EPRservice.Quality.CommonHelper).GetDateTimeGap(ADischDate,tmpDateTimeVal)
		s:(flag < 0) ret = -1
		
		q:(ret = -1)
	}
	
	q ret
}

/// Creator:	wangwentao
/// Desc:	判断唯一模板单元是否为数字(数字单元：输血量，抢救次数，成功次数等)
/// Input:	AEpisodeID为患者就诊号;
/// 		AElement1为界面模板单元RowID;
/// Return:	ret<=0不为数字; ret=1为数字;
/// Debug:	w ##Class(EPRservice.Quality.CheckRule.UnifyPoint).IsUnifyN20120507A("8706","E4498")
ClassMethod IsUnifyN20120507A(EpisodeID As %String, Element1 As %String, Operator As %String = "", Value As %String = 0, Exception As %String = "") As %String
{
	s ret = 0
	q:(EpisodeID = "")||(Element1 = "") ret
	//b "s"
	s ElementData1 = ##Class(EPRservice.Quality.CheckRule.Template).GetSingleValues(EpisodeID,Element1)
	q:($e(ElementData1,1,2) = "0^") ret
	
	s ElementData1 = $e(ElementData1,3,$l(ElementData1))
	q:(ElementData1 = "") ret
	
	//s ElementData1 = $tr(ElementData1,"零","0")
	s ret = 1
	q:(Exception ] "-") ret
	
	s ret = 2
	s:((+ElementData1)'=ElementData1) ret = -1
	q:(ret = -1) ret
		
	if (Operator="<value") {
		s:(ElementData1<Value) ret = -1
		q:(ret = -1) ret
	}
	elseif (Operator="<=value") {
		s:(ElementData1<=Value) ret = -1
		q:(ret = -1) ret
	}
	if (Operator=">value") {
		s:(ElementData1>Value) ret = -1
		q:(ret = -1) ret
	}
	elseif (Operator=">=value") {
		s:(ElementData1>=Value) ret = -1
		q:(ret = -1) ret
	}
	elseif (Operator="=value") {
		s:(ElementData1=Value) ret = -1
		q:(ret = -1) ret
	}
	elseif (Operator="<>value") {
		s:(ElementData1'=Value) ret = -1
		q:(ret = -1) ret
	}
	
	q ret
}

/// Creator:	wangwentao
/// Desc:	判断唯一模板病案首页【抢救次数】与【成功次数】是否一致（抢救次数必须>=成功次数）
/// Input:	AEpisodeID为患者就诊号;
/// 		AElement1为抢救次数模板单元RowID; 
/// 		AElement2为成功次数模板单元RowID; 
/// Return:	ret<0 不一致; ret=1一致;
/// Debug:	w ##Class(EPRservice.Quality.CheckRule.UnifyPoint).IsUnifyN20120508A("","","")
ClassMethod IsUnifyN20120508A(EpisodeID As %String, Element1 As %String, Element2 As %String, Value As %String = "", Exception1 As %String = "", Exception2 As %String = "") As %String
{
	s ret=0
	q:(EpisodeID="")||(Element1="")||(Element2="") ret
	
	s ElementData1=##Class(EPRservice.Quality.CheckRule.Template).GetSingleValues(EpisodeID,Element1)
	q:$e(ElementData1,1,2)="0^" ret
	s ElementData1=$e(ElementData1,3,$l(ElementData1))
	
	s ElementData2=##Class(EPRservice.Quality.CheckRule.Template).GetSingleValues(EpisodeID,Element2)
	q:$e(ElementData2,1,2)="0^" ret
	s ElementData2=$e(ElementData2,3,$l(ElementData2))
	q:(ElementData1="")&&(ElementData2="") ret
	
	q:(ElementData1=Exception1)&&(ElementData2=Exception2) ret
	
	//s ElementData1=$tr(ElementData1,"零","0")
	//s ElementData2=$tr(ElementData2,"零","0")
	s ret=2
	s:(+ElementData1)<(+ElementData2)||(+ElementData1)>((+ElementData2)+1) ret=-1
	q:(ret = -1) ret
	
	s ret=2
	s:(ElementData1>ElementData2)&&(Value="") ret=-1
	
	q ret
}

/// Creator:	wangwentao
/// Desc:	判断唯一模板病案首页{是否随诊}与病案首页{随诊期限}是否一致;
/// Input:	AEpisodeID为患者就诊号;
/// 		AElement1为是否随诊模板单元RowID; 
/// 		AElement2为随诊期限模板单元RowID; 
/// Return:	ret<0 不一致; ret=1一致;
/// Debug:	w ##Class(EPRservice.Quality.CheckRule.UnifyPoint).IsUnifyN20120509A(AEpisodeID,AElement1,AElement2)
ClassMethod IsUnifyN20120509A(AEpisodeID As %String, AElement1 As %String, AElement2 As %String) As %String
{
	s ret = 0
	q:(AEpisodeID = "")||(AElement1 = "")||(AElement2 = "") ret
	
	s elementData1 = ##Class(EPRservice.Quality.CheckRule.Template).GetSingleValues(AEpisodeID,AElement1)
	q:($e(elementData1,1,2) = "0^") ret
	s elementData1 = $e(elementData1,3,$l(elementData1))
	
	s elementData2 = ##Class(EPRservice.Quality.CheckRule.Template).GetSingleValues(AEpisodeID,AElement2)
	q:($e(elementData2,1,2) = "0^") ret
	s elementData2 = $e(elementData2,3,$l(elementData2))
	
	q:(elementData1 = "")&&(elementData2 = "") ret
	
	s ret = 1
	s elementData2 = ##Class(EPRservice.Quality.CommonHelper).GetListFromString(elementData2,"\","N")
	if (elementData1 = "是")
	{
		s:($listfind(elementData2,"") '= 0)&&($listfind(elementData2,"终生") = 0) ret = -1
	}
	else
	{
		s:($listfind(elementData2,"") '> 0)||($listfind(elementData2,"无") '= 0) ret = -1
	}
	
	q ret
}

/// Creator:	wangwentao
/// Desc:	判断唯一模板病案首页{手术信息:手术名称1,手术日期,术者,1助等}是否一致;
/// Input:	AEpisodeID为患者就诊号;
/// 		AElement1为一条手术信息模板单元RowID字符串,多个以"\"分隔; 
/// 		ASites指手术名称在模板单元RowID字符串中的位置;
/// Return:	ret<0:不一致; ret=1一致;
/// Debug:	w ##Class(EPRservice.Quality.CheckRule.UnifyPoint).IsUnifyN20120510A("","")
ClassMethod IsUnifyN20120510A(AEpisodeID As %String, AElement1 As %String, ASites As %String = 2, AOperName As %String = "无") As %String
{
	s ret = 0
	q:(AEpisodeID = "")||(AElement1 = "") ret
	
	s ElementData1 = ##Class(EPRservice.Quality.CheckRule.Template).GetSingleValues(AEpisodeID,AElement1)
	q:($e(ElementData1,1,2) = "0^") ret
	s ElementData1 = $e(ElementData1,3,$l(ElementData1))
	
	//如果全未填写不判断
	s trElementData1 = $tr(ElementData1," "), trElementData1 = $tr(trElementData1,"\")
	q:(trElementData1 = "") ret
	
	s ElementData1 = ##Class(EPRservice.Quality.CommonHelper).GetListFromString(ElementData1,"\","N")
	
	s ret = 1
	//wwt update 20100716 如果手术名称填"无"不判断
	q:($li(ElementData1,ASites)=AOperName)&&(trElementData1=AOperName) ret
	//wwt end
	
	s:($listfind(ElementData1,"") > 0) ret = -1
	q ret
}

/// Creator:	wangwentao
/// Desc:	判断患者死亡168小时后是否完成唯一模板死亡讨论记录(仅供提示列表使用);
/// Input:	AEpisodeID为患者就诊号;
/// 		AStructID为死亡讨论记录质控结构RowID;
/// 		ADeathDateTime患者死亡日期时间;
/// 		AHours为死亡后小时数;
/// Return：ret<0:不一致; ret=1一致;
/// Debug:	w ##Class(EPRservice.Quality.CheckRule.UnifyPoint).IsUnifyN20120511A("","","","")
ClassMethod IsUnifyN20120511A(AEpisodeID As %String, AStructID As %String, ADeathDateTime As %String, AHours As %String, ACheckType As %String = "IsSaveCatalog1") As %String
{
	s ret = 0
	q:(AEpisodeID = "")||(AStructID = "")||(ADeathDateTime = "") ret
	
	
	if ACheckType = "IsSaveCatalog1"
	{
		s result = ##Class(EPRservice.Quality.CheckRule.Category).IsSaveCatalog1(AEpisodeID,AStructID,ADeathDateTime,AHours)
		if ($p(result,"^",1) < 1)
		{
			s ret = -1
			q ret
		}
	}
	elseif  ACheckType = "IsSaveContent1"
	{
		s result = ##Class(EPRservice.Quality.CheckRule.Category).IsSaveContent1(AEpisodeID,AStructID,ADeathDateTime,AHours)
		if ($p(result,"^",1) < 1)
		{
			s ret = -1
			q ret
		}
	}
	else
	{
		//
	}
	
	s deathDateTime = ##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(ADeathDateTime)
	q:(deathDateTime = "") ret
	
	s checkDateTime = $tr($h,","," ")
	
	s checkTimeGap = ##Class(EPRservice.Quality.CommonHelper).GetDateTimeGap(checkDateTime,deathDateTime)
	//q:(CheckTimeGap <= AHours) ret
	s:(checkTimeGap '= "") checkTimeGap = $j(checkTimeGap,1,1)
	
	s:(+result = -1)&&(checkTimeGap <= +AHours) errInfo = "^ 提示:"_$zdt($tr(deathDateTime," ",","),3,1)_"患者死亡,死亡讨论记录书写时限还剩"_(+AHours-checkTimeGap)_"小时!" ,ret = +result_errInfo
	s:(+result = -1)&&(checkTimeGap > +AHours) errInfo = "^ 提示:"_$zdt($tr(deathDateTime," ",","),3,1)_"患者死亡,死亡讨论记录书写时限已超"_(checkTimeGap-AHours)_"小时!" ,ret = +result_errInfo
	//s:(+result = -1) ret = result
	
	q ret
}

/// Creator:	wangwentao
/// Desc: 判断唯一模板身份证18位或15位	纯数字	
/// Input: Element1为单元，Values1为长度，Values2为例外 如： 无，不详，未提示 等
/// Output: ret<0 
/// Debug: w ##Class(EPRservice.Quality.CheckRule.UnifyPoint).IsUnifyN20120512A(EpisodeID,Element1,Value1)
ClassMethod IsUnifyN20120512A(EpisodeID As %String, Element1 As %String, Values1 As %String = "18", Values2 As %String = "") As %String
{
	s ret=0 ,num=0
	q:(EpisodeID="")||(Element1="") ret
	//b "s"
	s ret=1
	s ElementData1=##Class(EPRservice.Quality.CheckRule.Template).GetSingleValues(EpisodeID,Element1)
	q:$e(ElementData1,1,2)="0^" ret
	s ElementData1=$e(ElementData1,3,$l(ElementData1))
	q:(ElementData1="") ret

	//例外
	s ret=2
	if Values2'="" {
		s Values2List=##Class(EPRservice.Quality.CommonHelper).GetListFromString(Values2,"\")
		q:($listfind(Values2List,ElementData1)'=0) ret
	}
	
	//长度
	s ret=3
	s tmpElementData1=$length(ElementData1)
	for ind = 1:1:$length(Values1,"\")
	{             
		s ValueData = $p(Values1,"\",ind)
		s:(tmpElementData1 '= ValueData) num = num + 1
	}
	s:(num=$length(Values1,"\")) ret=-1
	
	q ret
}

/// 说明: 判断可重复模板某病程记录次数与医嘱开立个数是否相符
/// 		: 转科病人无转科记录//转科表转科次数<>转科记录次数
///     : 抢救病人无抢救记录//抢救医嘱数<>抢救记录次数
///     : 输血病人无输血记录//输血医嘱数<>输血记录次数
///     : 穿刺病人无穿刺记录//穿刺医嘱数<>穿刺记录次数
/// 结论: ret<0 不一致
/// 调试: w ##Class(EPRservice.Quality.CheckRule.UnifyPoint).IsUnifyN20120513A(AEpisodeID,AHISCount,ATitles)
ClassMethod IsUnifyN20120513B(AEpisodeID As %String, AHISCount As %String, ATitles As %String, AIsEqual As %String = "N") As %String
{
	s ret = 0
	q:(AEpisodeID = "")||(AHISCount = "")||(ATitles = "") ret
	
	s hisCount = +$g(AHISCount)
	
	s result = ##Class(EPRservice.Quality.CheckRule.Course).GetMultiTemReCount(AEpisodeID,ATitles,"","","","")
	q:($e(result,1,2) = "0^") ret
	s count = +$e(result,3,$l(result))
	
	s ret = 1
	s:(count '= hisCount) ret = -1_"^提示:医嘱数"_hisCount_"次,"_"记录数"_count_"次!"
	
	q ret
}

/// Creator:	wangwentao
/// 说明: 判断唯一模板同一模板中两元素一致性判断，当Element1*不为*Value1时，Element2元素*为*Value2时触发(前非后肯)
/// 		如：当病案首页.出院情况.医院感染诊断 不为 "无"时，出院情况医院感染诊断不能为空
/// lxf
/// 结论: ret<0 
/// 调试: w ##Class(EPRservice.Quality.CheckRule.UnifyPoint).IsUnifyFK(EpisodeID,Element1,Element2,Value1,Value2)
ClassMethod IsUnifyN20120529A(EpisodeID As %String, Element1 As %String, Element2 As %String, Value1 As %String, Value2 As %String, Value3 As %String = "") As %String
{
	s ret=0
	q:(EpisodeID="")||(Element1="")||(Element2="") ret
	
	s ret=1
	s ElementData1=##Class(EPRservice.Quality.CheckRule.Template).GetSingleValues(EpisodeID,Element1)
	q:$e(ElementData1,1,2)="0^" ret
	s ElementData1=$e(ElementData1,3,$l(ElementData1))
	//w "ElementData1="_ElementData1,!
	 
	s ret=2
	s ElementData2=##Class(EPRservice.Quality.CheckRule.Template).GetSingleValues(EpisodeID,Element2)
	q:$e(ElementData2,1,2)="0^"
	s ElementData2=$e(ElementData2,3,$l(ElementData2))
	//w "ElementData2="_ElementData2,!
	s ElementData1=$tr(ElementData1," ","")
	s ElementData2=$tr(ElementData2," ","")
	
	s ret=3
	q:(ElementData1="")&&(ElementData2="") ret			//Element1为空时不检查，非空由完整性规则去判断
	s:(ElementData1'=Value1)&&(ElementData2=Value2) ret=-1
	//s:(ElementData1'="无")&&(ElementData2="") ret=-1
	i ($f(Value3,"TWOWAY")'=0)
	{
		s:(ElementData1=Value1)&&(ElementData2'=Value2) ret=-1
	}
	i ($f(Value3,"NULL")'=0)
	{
		s:(ElementData1="")&&(ElementData2'=Value2) ret=-1
	}
	i ($f(Value3,"-")'=0)
	{
		s:(ElementData1="-")&&(ElementData2'=Value2) ret=-1
	}
	q ret
}

/// Creator:	wangwentao
/// Desc:	唯一模板判断日期单元A与日期单元B大小,如果日期A大于日期B,则返回-1。
/// Input:	AEpisodeID			为患者就诊号;
/// 		AElement1			为指定模板单元RowID;
/// 		AElement2			为指定模板单元RowID;
/// 		ATypeFlag			为 {"DateTime","Date","Time"}
/// Return：ret<0				触犯条目规则;
/// 		ret>0				正确;
/// Debug:	w ##Class(EPRservice.Quality.CheckRule.UnifyPoint).IsUnifyN20120530A(EpisodeID,"E13683","E13684","DateTime")
ClassMethod IsUnifyN20120530A(AEpisodeID As %String, AElement1 As %String, AElement2 As %String, ATypeFlag As %String = "DateTime") As %String
{
	//b "s"
	s ret = 0
	
	q:(AEpisodeID = "")||(AElement1 = "")||(AElement2 = "") ret
	q:($l(AElement1,"\")>1)||($l(AElement2,"\")>1) ret
	
	s ret = 1

	s ElementData1 = ##Class(EPRservice.Quality.CheckRule.Template).GetSingleValues(AEpisodeID,AElement1)
	q:($e(ElementData1,1,2) = "0^") ret_"^模板单元<"_AElement1_">取值异常退出!"
	s ElementData1 = $e(ElementData1,3,$l(ElementData1))
	q:(ElementData1 = "") ret
	
	s ElementData2 = ##Class(EPRservice.Quality.CheckRule.Template).GetSingleValues(AEpisodeID,AElement2)
	q:($e(ElementData2,1,2) = "0^") ret_"^模板单元<"_AElement1_">取值异常退出!"
	s ElementData2 = $e(ElementData2,3,$l(ElementData2))
	q:(ElementData2 = "") ret

	s ret = 2

	s ElementData1 = ##Class(EPRservice.Quality.CommonHelper).ChangeDateTime(ElementData1)
	s ElementData2 = ##Class(EPRservice.Quality.CommonHelper).ChangeDateTime(ElementData2)

	s tmpDateValue1 = $p(ElementData1," ",1),tmpTimeValue1 = $p(ElementData1," ",2)
	s tmpDateValue2 = $p(ElementData2," ",1),tmpTimeValue2 = $p(ElementData2," ",2)
	s tmpDateValue = $zd(+$h,3)_" ",tmpTimeValue = " "_"00:00:00"
	
	s ret = 3

	if $zcvt(ATypeFlag,"U")= "DATETIME"
	{
		s tmpValue1= ElementData1,tmpValue2=ElementData2
		s flag = ##Class(EPRservice.Quality.CommonHelper).GetDateTimeGap(tmpValue2,tmpValue1)
		s:(flag < 0) ret = -1
	}
	elseif $zcvt(ATypeFlag,"U")= "DATE"
	{
		s tmpValue1= tmpDateValue1_tmpTimeValue,tmpValue2=tmpDateValue2_tmpTimeValue
		s flag = ##Class(EPRservice.Quality.CommonHelper).GetDateTimeGap(tmpValue2,tmpValue1)
		s:(flag < 0) ret = -1
	}
	elseif $zcvt(ATypeFlag,"U")= "TIME"
	{
		s tmpValue1= tmpDateValue_tmpTimeValue1,tmpValue2=tmpDateValue_tmpTimeValue2
		s flag = ##Class(EPRservice.Quality.CommonHelper).GetDateTimeGap(tmpValue2,tmpValue1)
		s:(flag < 0) ret = -1
	}
	else
	{
		q ret
	}
	
			
	q ret
}

/// Creator:	wangwentao
/// Desc:	可重复模板判断同一个模板日期单元A与同一个模板日期单元B大小,如果日期A大于日期B,则返回-1。
/// Input:	AEpisodeID			为患者就诊号;
/// 		AElement1			为指定模板单元RowID;
/// 		AElement2			为指定模板单元RowID;
/// 		ATypeFlag			为 {"DateTime","Date","Time"}
/// Return：ret<0				触犯条目规则;
/// 		ret>0				正确;
/// Debug:	w ##Class(EPRservice.Quality.CheckRule.UnifyPoint).IsUnifyN20120530A(EpisodeID,"E13683","E13684","DateTime")
ClassMethod IsUnifyN20120530B(AEpisodeID As %String, AElement1 As %String, AElement2 As %String, ATypeFlag As %String = "DateTime") As %String
{
	//b "s"
	s ret = 0
	
	q:(AEpisodeID = "")||(AElement1 = "")||(AElement2 = "") ret
	q:($l(AElement1,"\")>1)||($l(AElement2,"\")>1) ret
	
	s ret=1
	
	//处理入参
	s Parameter =  $e($p(AElement1,"\"),2,$l($p(AElement1,"\")))
	
	s result = ##Class(%ResultSet).%New("EPRservice.Quality.DataGather.EPRInfo:GetInstanceData")
	s sc = result.Execute(AEpisodeID,Parameter) 
	While (result.Next()) 
	{
		s (Title,InstanceID,HappendDate,HappenTime) = ""
		
		s Title = result.Data("Title")
		s InstanceID = result.Data("InstanceID")
		s HappenDate = result.Data("HappenDate")
		s HappenTime = result.Data("HappenTime")
		
		s ret=2
		
		//处理多余的可重复模板,如果标题为"作废",则退出.
		q:(Title="作废")
		
		//返回值格式 Status^List
		s ElementData1 = ##Class(EPRservice.Quality.CheckRule.Template).GetMultipleValues(AEpisodeID,AElement1,InstanceID)
		continue:($e(ElementData1,1,2) = "0^") 
		s ElementData1=$e(ElementData1,3,$l(ElementData1))
		q:($lg(ElementData1) = "")
		
		s ret=3
		
		//返回值格式 Status^List
		s ElementData2 = ##Class(EPRservice.Quality.CheckRule.Template).GetMultipleValues(AEpisodeID,AElement2,InstanceID)
		continue:($e(ElementData2,1,2) = "0^") 
		s ElementData2=$e(ElementData2,3,$l(ElementData2))
		q:($lg(ElementData2) = "")
		
		s ret = 4

		s ElementData1 = ##Class(EPRservice.Quality.CommonHelper).ChangeDateTime($lg(ElementData1))
		s ElementData2 = ##Class(EPRservice.Quality.CommonHelper).ChangeDateTime($lg(ElementData2))

		s tmpDateValue1 = $p(ElementData1," ",1),tmpTimeValue1 = $p(ElementData1," ",2)
		s tmpDateValue2 = $p(ElementData2," ",1),tmpTimeValue2 = $p(ElementData2," ",2)
		s tmpDateValue = $zd(+$h,3)_" ",tmpTimeValue = " "_"00:00:00"

		s ret = 5
	
		if $zcvt(ATypeFlag,"U")= "DATETIME"
		{
			s tmpValue1= ElementData1,tmpValue2=ElementData2
			s flag = ##Class(EPRservice.Quality.CommonHelper).GetDateTimeGap(tmpValue2,tmpValue1)
			s:(flag <= 0) ret = -1_"^提示:第"_$p(InstanceID,"||",2)_"条记录!"
		}
		elseif $zcvt(ATypeFlag,"U")= "DATE"
		{
			s tmpValue1= tmpDateValue1_tmpTimeValue,tmpValue2=tmpDateValue2_tmpTimeValue
			s flag = ##Class(EPRservice.Quality.CommonHelper).GetDateTimeGap(tmpValue2,tmpValue1)
			s:(flag <= 0) ret = -1_"^提示:第"_$p(InstanceID,"||",2)_"条记录!"
		}
		elseif $zcvt(ATypeFlag,"U")= "TIME"
		{
			s tmpValue1= tmpDateValue_tmpTimeValue1,tmpValue2=tmpDateValue_tmpTimeValue2
			s flag = ##Class(EPRservice.Quality.CommonHelper).GetDateTimeGap(tmpValue2,tmpValue1)
			s:(flag <= 0) ret = -1_"^提示:第"_$p(InstanceID,"||",2)_"条记录!"
		}
		else
		{
			//
		}	
			
		q:(+ret=-1)		
	}			
	q ret
}

/// Creator:	liaowp modify by Candyxu
/// Desc:	判断唯一模板单元是否匹配于指定长度(数字单元：邮编,电话,健康卡号等)
/// Input:	AEpisodeID为患者就诊号;
/// 		AElement1为界面模板单元RowID;
///         Operator 与指定单元长度关系(>,<,>=,<=,<>)
///         Value 指定的比较长度
///         Exception 指定的例外值(格式为"值1^值2^值3")
///         IsNumber 是否要求值全部为数字(要求为"Y",不要求为"N")
/// Return:	ret=-1违反条目; ret=1符合条目; 
/// Debug:	w ##Class(EPRservice.Quality.CheckRule.UnifyPoint).IsUnifyN20130827("5526888","E10387",">value",6,"-","Y")
ClassMethod IsUnifyN20130827(EpisodeID As %String, Element1 As %String, Operator As %String = "", Value As %String = 0, Exception As %String = "", IsNumber As %String = "N") As %String
{
	s ret = 0
	q:(EpisodeID = "")||(Element1 = "") ret

	s ElementData1 = ##Class(EPRservice.Quality.CheckRule.Template).GetSingleValues(EpisodeID,Element1)
	q:($e(ElementData1,1,2) = "0^") ret

	s ElementData1 = $e(ElementData1,3,$l(ElementData1))
	q:(ElementData1 = "") ret

	//判断单元值是否与例外值相符,如相符直接返回1
	for i = 1:1:$l(Exception,"^")
	{
		s ExVal = $P(Exception,"^",i)
		s:(ExVal = ElementData1) ret = 1
		q:(ret = 1)
	}
	q:(ret = 1) ret
	
	//判断是否要求值为数字
	s ret = 1
	if (IsNumber = "Y")
	{
		for i = 1:1:$l(ElementData1)
		{
		   s tempData = $e(ElementData1,i,i)
		   s:($f("1234567890",tempData)<=0) ret = -1 
		   q:(ret = -1)
		}
		q:(ret = -1) ret
	}
	//判断单元值长度
	s EleLength = $l(ElementData1) 
	if (Operator = "<") {
         s:(EleLength >= Value) ret = -1
	}
	elseif (Operator = "<=") {
		s:(EleLength > Value) ret = -1
	}
	elseif (Operator = ">") {
		s:(EleLength <= Value) ret = -1
	}
	elseif (Operator = ">= ") {
		s:(EleLength < Value) ret = -1
	}
	elseif (Operator = "=") {
		s:(EleLength '= Value) ret = -1
	}
	elseif (Operator = "<>") {
		s:(EleLength = Value) ret = -1
	}	
	q ret
}

/// desc:判断诊断字典单元的ICD编码为value1时，另一个单元不能等于value2；此方法只适用于诊断字典代码列为MRCID_RowId
/// Creator:Hanxf
/// CreatDate:2013-05-02
/// input:EpisodeID为就诊号,如果项目上维护了诊断关联性别的 MRCID_Sex_DR字段，则Value1、Value2、Value3均可以为空
///      AElement1为诊断字典单元的Code；格式为"E0001"
///      Value1为诊断ICD编码所包含的控制字段，默认为空,多个以'\'分开，如：Z01\Z37
///      AElement2为单元的Code，格式："E0002"
///      Value2为AElement2控制内容
///      Value3为Value1的补充值,默认为空,表示一定范围内的诊断ICD编码,格式如：C51-C58\D25-D30    
/// Output：ret<0 不一致
/// example：诊断单元E0001诊断内容的ICD编码以'Z01'开头的，性别E0002单元不能为'男'
/// w ##Class(EPRservice.Quality.CheckRule.UnifyPoint).IsUnifyDiag("58","E0001","E0002","Z01","男","")
ClassMethod IsUnifyDiag(EpisodeID As %String, Element1 As %String, Element2 As %String, Value1 As %String = "", Value2 As %String = "", Value3 As %String = "") As %String
{
 
   s ret=0
   q:(EpisodeID="")||(Element1="")||(Element2="") ret
   
   s ret=1  
   s QtyTemplateID=$e(Element1,2,$Length(Element1))
   s result=##Class(EPRmeta.Quality.QualityTemplate).%OpenId(QtyTemplateID)
   q:result="" "default" 
   s Element1Code=result.ElementCode
   //将单元的ECode变为取单元的代码
   s Element1ECode=$tr(Element1Code,":V",":C")
   //取出表MRC_ICDDx的Rowid
   s MrcIcdRowid=##class(EPRservice.BOScatterData).GetEPRData(EpisodeID, Element1ECode)
   q:MrcIcdRowid="" "not found Rowid"
   //取出诊断对应的ICD编码
   s DiagICDCode=$p($g(^MRC("ID",MrcIcdRowid)),"^",4)
   s ICDCodeTag=0
   //取ICD诊断明细表的诊断与性别关联的字段
   s MRCIdSexDR=$p($g(^MRC("ID",MrcIcdRowid)),"^",10)
   if (MRCIdSexDR=1) {s Value2="女"}
   if (MRCIdSexDR=2) {s Value2="男"}
   if ((MRCIdSexDR="")&&(Value1'=""))
   {
	  f j=1:1:$Length(Value1,"\")
     {
	  s DiagICDValue1=$p($g(Value1),"\",j)
      if ((DiagICDCode [ DiagICDValue1)) {s ICDCodeTag=1}
      if (ICDCodeTag=1)
      { break }
     }  
   }
   
   if ((Value3'="")&&(ICDCodeTag=0)&&(MRCIdSexDR=""))
   {
	   f t=1:1:$length(Value3,"\")
	   {
		  s DiagICDValue3=$p(Value3,"\",t)  
		  s StartICDCode=$p(DiagICDValue3,"-",1) 
		  s StartICDCode3=$e(StartICDCode,2,3)
		  s EndICDCode=$p(DiagICDValue3,"-",2)
		  s EndICDCode3=$e(EndICDCode,2,3)
		  s ControIcd=$e(StartICDCode,1,1)
		  
		  //返回当前诊断ICD代码的第2、3标示符
		  s tmpDiagICDCode=$e(DiagICDCode,2,3)
		  s temIcd=$e(DiagICDCode,1,1)
		  if ((ControIcd=temIcd)&&((tmpDiagICDCode-StartICDCode3)>=0)&&((tmpDiagICDCode-EndICDCode3)<=0))
		   {
			   s ICDCodeTag=1
			}
		  if (ICDCodeTag=1)
		  { break }
		}
	  
	}
   
   s ElementData2=##Class(EPRservice.Quality.CheckRule.Template).GetSingleValues(EpisodeID,Element2)
   q:$e(ElementData2,1,2)="0^"
   s ElementData2=$e(ElementData2,3,$l(ElementData2))
   s ElementData2=$tr(ElementData2," ","")
   
   if (MRCIdSexDR'="")
   {
	  if ((MRCIdSexDR=1)&&(ElementData2="女")) {s ICDCodeTag=1}
      if ((MRCIdSexDR=2)&&(ElementData2="男")) {s ICDCodeTag=1}   
	}
   
   if ((ICDCodeTag=1)&&(ElementData2=Value2)) {s ret=-1}
   
   q ret
}

/// desc:不满一周岁的新生儿年龄小于等于28天，新生儿出生体重不能为"空、-、—"
///     新生儿年龄单元的填写方式为"2 25/30"
/// Creator：HanXF  
/// CreatDate：2013-05-31
/// input: Element1:新生儿年龄单元的Code 如："E0001"
///       Element2:不能为空单元的Code
/// output:ret<0触发
ClassMethod IsUnifyAge(EpisodeID As %String, Element1 As %String, Elements2 As %String) As %String
{
	s ret = 0
	q:(EpisodeID = "")||(Element1 = "")||(Elements2 = "") ret
	
	s ElementData1 = ##Class(EPRservice.Quality.CheckRule.Template).GetSingleValues(EpisodeID,Element1)
	q:($e(ElementData1,1,2) = "0^") ret
	s ElementData1 = $e(ElementData1,3,$l(ElementData1))
	
	s ElementData2 = ##Class(EPRservice.Quality.CheckRule.Template).GetSingleValues(EpisodeID,Elements2)
	q:($e(ElementData2,1,2) = "0^") ret
	s ElementData2 = $e(ElementData2,3,$l(ElementData2))
	if ((ElementData1'="")&&(ElementData1'="-")&&(ElementData1'="—"))
	{
		if ((ElementData1 [ " ")&&(ElementData1 [ "/"))
		{
			s MonthData=$p(ElementData1," ",1)
		    s DayData=$p($p(ElementData1," ",2),"/",1)
		 }
		 elseif ((ElementData1 '[ "/")&&(ElementData1'=""))
		 {
			s MonthData=ElementData1
			s DayData=""  
		 }
		 else
		 {
			 s MonthData=""
			 s DayData=$p(ElementData1,"/",1)
		 }
		s:((MonthData="")||(MonthData=0))&&(+DayData<=28)&&((ElementData2="")||(ElementData2="-")||(ElementData2="—")) ret = -1	
	}
			
	q ret
}

/// Creator:Candyxu   modify by hanxf 2013-02-19
/// Createdate:2013-01-25
/// Input:AEpisodeID 就诊号,ARegDateTime 入院日期,ADays 判断天数
///      AID 可重复模板为DocID;唯一模板为StructID,AType 可重复模板为"M";唯一模板为"S"
/// Output:ret 0配置错误 -1触犯 1没触犯
/// Debuge w ##Class(EPRservice.Quality.CheckRule.UnifyPoint).IsUnify3000("2462001","2008-12-04 11:14:00",60,185,"M")
ClassMethod IsUnify3000(AEpisodeID As %String, ARegDateTime As %String, ADays As %String, AID As %String, AType As %String) As %String
{
	s ret = 0
	q:((AEpisodeID = "")||(ARegDateTime = "")||(ADays = "")) ret
	s ret = 1
	s regDateTime = ##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(ARegDateTime)
	s regDate = $p(regDateTime," ",1)
	s regTime = $p(regDateTime," ",2)
	s sysDate = $p($h,",",1)
	s sysTime = $p($h,",",2)
        
        //modify 取出院时间(最终结算日期时间)和当前时间进行比对，确定判断时间取哪个
	s DisDatetime1 = ##Class(EPRservice.Quality.DataGather.AdmInfo).GetDischTime2(AEpisodeID)
	s DisDatetime = ##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(DisDatetime1)
	s DisDate = $p(DisDatetime," ",1)
	s DisTime = $p(DisDatetime," ",2)
	
	if ((DisDate'="")&&(DisTime'="")&&(DisDate - sysDate < 0) && (DisTime - sysTime < 0))
	{
	   s sysDate = DisDate
	   s sysTime = DisTime
	} 
	//modify end

	q:(((sysDate - regDate = ADays) && (sysTime - regTime)<0)||(sysDate - regDate < ADays)) ret
	if ($zcvt(AType,"U") = "M")
	{
	   s result = ##Class(EPRservice.Quality.CheckRule.Course).GetMultiRecordCount(AEpisodeID,AID)	
	   s:(result <=0) ret = -1
	   q ret
	}elseif ($zcvt(AType,"U") = "S")
	{
	   s result = ##Class(EPRservice.Quality.CheckRule.Category).GetCatalogData(AEpisodeID,AID)
	   s:($p(result,"^",1) = "") ret = -1
	   q ret
	}
	q ret
}

/// ************************************************************************************************************************
/// Desc:专业组查房记录可重复模板数据判断几天写一次（按创建时间质控）,并显示是否补充(多次评分)
///     先检查是否创建记录如果有则返回真，否则再检查是否补填记录，如果有则提示已补，否则返回缺记录时间
/// Creator: YHY
/// Createdate:2013-02-21
/// Input:AEpisodeID 就诊号，ATitles 标题，ARegDateTime 入院时间，ADisDateTime 出院时间，ADays 几天一次
/// OutPut:ret -1 触犯^提示信息^触犯次数
/// Debug:w ##Class(EPRservice.Quality.CheckRule.UnifyPoint).IsUnify1017(76,"348|日常病程记录","2013-05-21 11:13:58","2013-06-21 11:13:58",30)
/// *************************************************************************************************************************
ClassMethod IsUnify1017(AEpisodeID As %String, ATitles As %String, ARegDateTime As %String, ADisDateTime As %String, ADays As %String) As %String
{
	s ret = 1, errInfo = "",count = 0,transDate="",tmpDate=""
	q:((AEpisodeID = "")||(ATitles = "")||(ARegDateTime = "")||(ADays = "")) ret
    
	s regDateTime = ##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(ARegDateTime)
	s disDateTime = ##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(ADisDateTime)
	
	s checkDate = $p(disDateTime," ",1)
	s:(checkDate = "") checkDate = $p($h,",",1)
	s checkTime = $p(disDateTime," ",2)
	s:(checkTime = "") checkTime = $p($h,",",2)
	
	s fromDate = $p(regDateTime," ",1)
	s fromTime = $p(regDateTime," ",2)
	s:(fromTime = "") fromTime = 0
	s hours =  ##Class(EPRservice.Quality.CommonHelper).GetDateTimeGap(ADisDateTime,ARegDateTime)
	q:(hours < 720) ret
	s TransDept = ##class(EPRservice.HISInterface.PatientInfoAssist).TransDeptIDDetail(AEpisodeID,"")
	if (TransDept = "无")
	{
		s toDate = +checkDate
		for tmpDate = fromDate:$g(ADays):((fromDate+(((toDate-fromDate)\ADays)*ADays)-1))
		{
	 		s result = ##Class(EPRservice.Quality.CheckRule.Course).GetMultiRecordByTimeType(AEpisodeID,ATitles,tmpDate,fromTime,tmpDate+ADays,checkTime,"N","C")	
	  		q:($e(result,1,2) = "0^")
	  		s Tempcount = +$e(result,3,$l(result))
	  		continue:(Tempcount > 0)
	  		s result = ##Class(EPRservice.Quality.CheckRule.Course).GetMultiRecordByTimeType(AEpisodeID,ATitles,tmpDate,fromTime,tmpDate+ADays,checkTime,"N","H") 
	  		q:($e(result,1,2) = "0^")
	  		s Tempcount = +$e(result,3,$l(result))
	  		if (Tempcount > 0) 
	  		{
	    		 s errInfo = errInfo_" 缺少"_$zd(tmpDate,3)_"至"_$zd(tmpDate+ADays,3)_"的记录,已补!"
	  		}else
	  		{
				 s errInfo = errInfo_" 缺少"_$zd(tmpDate,3)_"至"_$zd(tmpDate+ADays,3)_"的一次记录!"
	  		}
	 		 s count = count + 1
		}	
	}
	else
	{
		s FromDate = fromDate
		s info = 2
		for key = 1:1:($l(TransDept,"->")-1)
		{
			s tempcount = $p(TransDept,"->",info)
			s TransDate = $p(tempcount,"^",3)
			s TransTime = $p(tempcount,"^",4)
			s TransDateTime = TransDate_" "_TransTime
			s transDateTime = ##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(TransDateTime)
			s transDate = $p(transDateTime," ",1)
			s transTime = $p(transDateTime," ",2)
			s hours1 = ##Class(EPRservice.Quality.CommonHelper).GetDateTimeGap(TransDateTime,ARegDateTime)
			q:(hours1 < 720)
			s toDate = +transDate
			for tmpDate = FromDate:$g(ADays):((FromDate+(((toDate-FromDate)\ADays)*ADays)-1)) 
			{
	  			s result = ##Class(EPRservice.Quality.CheckRule.Course).GetMultiRecordByTimeType(AEpisodeID,ATitles,tmpDate,fromTime,tmpDate+ADays,transTime,"N","C")	
	  			q:($e(result,1,2) = "0^")
	  			s Tempcount = +$e(result,3,$l(result))
	  			continue:(Tempcount > 0)
	  			s result = ##Class(EPRservice.Quality.CheckRule.Course).GetMultiRecordByTimeType(AEpisodeID,ATitles,tmpDate,fromTime,tmpDate+ADays,transTime,"N","H") 
	  			q:($e(result,1,2) = "0^")
	  			s Tempcount = +$e(result,3,$l(result))
	  			if (Tempcount > 0) 
	  			{
	     			s errInfo = errInfo_" 缺少"_$zd(tmpDate,3)_"至"_$zd(tmpDate+ADays,3)_"的记录,已补!"
	  			}else
	  			{
					 s errInfo = errInfo_" 缺少"_$zd(tmpDate,3)_"至"_$zd(tmpDate+ADays,3)_"的一次记录!"
	  			}
	  			s count = count + 1
			}
			s info = info + 1
			s FromDate = transDate
			s fromTime = transTime	
		}
		
		s hours2 = ##Class(EPRservice.Quality.CommonHelper).GetDateTimeGap(ADisDateTime,TransDateTime)
		q:(hours2 < 720) ret
		for tmpDate = transDate:$g(ADays):((transDate+(((checkDate-transDate)\ADays)*ADays)-1))
		{
	  		s result = ##Class(EPRservice.Quality.CheckRule.Course).GetMultiRecordByTimeType(AEpisodeID,ATitles,tmpDate,transTime,tmpDate+ADays,checkTime,"N","C")	
	  		q:($e(result,1,2) = "0^")
	  		s Tempcount = +$e(result,3,$l(result))
	  		continue:(Tempcount > 0)
	  		s result = ##Class(EPRservice.Quality.CheckRule.Course).GetMultiRecordByTimeType(AEpisodeID,ATitles,tmpDate,transTime,tmpDate+ADays,checkTime,"N","H") 
	  		q:($e(result,1,2) = "0^")
	  		s Tempcount = +$e(result,3,$l(result))
	  		if (Tempcount > 0) 
	  		{
	     		s errInfo = errInfo_" 缺少"_$zd(tmpDate,3)_"至"_$zd(tmpDate+ADays,3)_"的记录,已补!"
	  		}else
	  		{
					s errInfo = errInfo_" 缺少"_$zd(tmpDate,3)_"至"_$zd(tmpDate+ADays,3)_"的一次记录!"
	  		}
	  		s count = count + 1
		}	
	}
	s:(count > 0 ) ret = -1
	q ret_"^"_errInfo_"^"_count
}

/// creator:YHY
/// createdate:2013-12-11
/// input:AEpisodeID 就诊号, AElement1 指定模板单元RowID;
/// output:ret 0配置错误  -1触犯  1不触犯
/// debuge:w ##Class(EPRservice.Quality.CheckRule.UnifyPoint).IsUnify220(3946461,I0035)
ClassMethod IsUnify220(AEpisodeID As %String, AElement1 As %String) As %String
{
	s ret = 0
	q:(AEpisodeID = "")||(AElement1 = "") ret
	
	s elementData1 = ##Class(EPRservice.Quality.CheckRule.Template).GetSingleValues(AEpisodeID,AElement1)
	q:$e(elementData1,1,2)="0^" ret
	s elementData1=$e(elementData1,3,$l(elementData1))
	
	s data = ##class(DHCMed.EPDService.Service).CheckDiagnosTextToEpd(AEpisodeID,elementData1)
	if (data = 0)
	{
		s ret = 1
	}
	elseif (data = 1)
	{
		s ret = -1
	}
	q ret
}

/// -----------------------------------------------------------------20140622-------------------------
/// add by lfb 20131111
/// Element 需要控制的首页诊断单元数据
/// Elements 诊断代码
/// Value1	条件值
/// Value2	标准值
/// DiagAboutValue	与Value相关不可以下的诊断集合
/// ACondition $G$ $L$ $E$
/// ##class(EPRservice.Quality.CheckRule.UnifyPoint).IsUnify230(EpisodeID,"E7590",{HISGender},"男",{FemaleDiagIDs},"E")
ClassMethod IsUnify230(AEpisodeID As %String, AElement1 As %String, Value1 As %String, Value2 As %String, DiagValues As %String, ACondition As %String) As %String
{
		s ret=0
		q:(Value1="")||(Value2="")||(DiagValues="")
		s StandardValue=Value2
		i (ACondition="G")&&(Value1<StandardValue) q ret
		i (ACondition="L")&&(Value1>StandardValue) q ret
		i (ACondition="E")&&(Value1'=StandardValue) q ret 
		
		s ElementData1 = ##Class(EPRservice.Quality.CheckRule.Template).GetSingleValues(AEpisodeID,AElement1)
		q:($e(ElementData1,1,2) = "0^") ret
		s ElementData1=$e(ElementData1,3,$l(ElementData1))
		q:(ElementData1="") ret
		
		s ret =1
		s num=$l(DiagValues,"\")
		f i=1:1:num {	
			s DiagValue = $p(DiagValues,"\",i)
			s:(DiagValue =ElementData1) ret = -1 
			q:(ret=-1)
		}
		q ret
}

/// add by lfb 20131111
/// Element1 取体重值
/// Age	取患者年龄
/// Desc 如果患者年龄小于28天,体重不可以大于8000g，体重必须填写数值型通过界面模板正则表达式控制
/// ##class(EPRservice.Quality.CheckRule.UnifyPoint).IsUnify231()
ClassMethod IsUnify231(AEpisodeID As %String, AElement1 As %String, Age As %String = "") As %String
{
		s ret=0,ElementData1=""
		
		q:Age>28 ret
		q:Age="" ret
		s ElementData1 = ##Class(EPRservice.Quality.CheckRule.Template).GetSingleValues(AEpisodeID,AElement1)
		q:($e(ElementData1,1,2) = "0^") ret
		s ElementData1=$e(ElementData1,3,$l(ElementData1))
		
		
		s ret =1
		//内容不是数字
		s len=$l(ElementData1)
		f i=1:1:len  {
			s num=$e(ElementData1,i)
			s:($a(num)<48)||($a(num)>57) ret=-1
			q:(ret=-1)
	
		}
		//首位是0
		s:($e(ElementData1,1)=0) ret=-1
		//体重大于8kg,小于500g
		s:((ElementData1>8000)||(ElementData1<500)) ret=-1
		
		q ret
}

/// Desc:	判断病案首页中【离院方式】为死亡时 【死亡小结时间】是否填写
/// Desc2:	判断病案首页中【离院方式】为死亡时  判断【死亡小结】是否书写
/// Input:	AEpisodeID为患者就诊号;
/// 		AElement1为首页离院方式;
/// 		AElement2为死亡小结死亡时间单元;
/// 		ADefaultValue为"死亡";
/// Return:	ret=-1 死亡小结死亡时间为空,死亡时间未写; ret=1一未触犯;
/// Debug:	w ##Class(EPRservice.Quality.CheckRule.UnifyPoint).IsUnify0050("8706","E4419","E4418")
ClassMethod IsUnify0050(AEpisodeID As %String, AElement1 As %String, AElement2 As %String, ADefaultValue As %String = "死亡") As %String
{
	s ret = 0
	q:(AEpisodeID = "")||(AElement1 = "")||(AElement2 = "") ret
	
	s elementData1 = ##Class(EPRservice.Quality.CheckRule.Template).GetSingleValues(AEpisodeID,AElement1)
	q:($e(elementData1,1,2) = "0^") ret
	s elementData1 = $e(elementData1,3,$l(elementData1))
	
	s elementData2 = ##Class(EPRservice.Quality.CheckRule.Template).GetSingleValues(AEpisodeID,AElement2)
	q:($e(elementData2,1,2) = "0^") ret
	s elementData2 = $e(elementData2,3,$l(elementData2))
	
	q:(elementData1 = "") ret
	
	s ret = 1
	
	if (elementData1=ADefaultValue) {
			
		// 死亡小结，24小时入院死亡记录死亡时间
		s elnum=$l(elementData2,"\")	
		for i=1:1:elnum {
			s elemeteData=$p(elementData2,"\",i)
			q:(ret=2)
			s:(elemeteData="")&&(ret'=2) ret=-1
			s:(elemeteData'="") ret=2
			
		}
	}
	q ret
}

/// 身份证验证
/// add by lifb 20131115
/// 通过身份证规则验证身份证是否合理  
/// 身份证进行验证默认18位
/// d ##class(EPRservice.Quality.CheckRule.UnifyPoint).IsUnify233()
ClassMethod IsUnify232(ArgEpisodeID As %String, ArgElement1 As %String, ArgExtValues As %String = "/", ArgLengthNums As %String = "18") As %String
{

	s ret=0

	q:(ArgEpisodeID="")||(ArgElement1="")
	
	s ElementData1 = ##Class(EPRservice.Quality.CheckRule.Template).GetSingleValues(ArgEpisodeID,ArgElement1)
	q:($e(ElementData1,1,2) = "0^") ret
	s ElementData1=$e(ElementData1,3,$l(ElementData1))
	
	//验证特殊值
	s ExtValuels=##Class(EPRservice.Quality.CommonHelper).GetListFromString(ArgExtValues,"\")
	s ExtInd=1
	for {	
			s ExtValue=$listget(ExtValuels,ExtInd)
			q:ExtValue=""
			s:(ElementData1=ExtValue) ret=1
			s ExtInd=ExtInd+1	
	}
	q:(ret=1) ret
	
	
	//长度验证
	s IDCardLength=$l(ElementData1),LengthInd=1
	s LengthNumls = ##Class(EPRservice.Quality.CommonHelper).GetListFromString(ArgLengthNums,"\")
	for {
		s LengthNum=$listget(LengthNumls,LengthInd)
		q:LengthNum=""
		
		s:(IDCardLength '= LengthNum) ret=-1
		s:(IDCardLength = LengthNum) ret=1
		q:ret=1
		s LengthInd=LengthInd+1
	}
	q:(ret=-1) ret
	
	//验证 15为 身份证是否合理
	//仅验证身份证是否为15位纯数字
	if (IDCardLength=15){
		
		for i=1:1:15 {
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
	
	if (IDCardLength=18){
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
	
	q ret
}

/// add by lfb 20131111
/// EpisodeID 患者Paadm表ID
/// Element1  需要质控单元，此方法中为入院体重或出生体重
/// Element2s 与质控单元关联的单元，此方法中为首页诊断
/// DiagValues	此方法中为诊断中关联值
/// 说明：当Element2s中的值为DiagValues中的关联诊断时，Element1的值不可以为空
/// 说明：依据病案首页中诊断是否为指定的诊断，判定首页中其他内容是否为必填
///         应用：诊断为单胎活产，必须填写新生儿体重
/// ##class(EPRservice.Quality.CheckRule.UnifyPoint).IsUnify233(EpisodeID,"E7546","E7590",{DiagIDs})
ClassMethod IsUnify233(AEpisodeID As %String, AElement1 As %String, AElement2s As %String, DiagValues As %String) As %String
{
		s ret=0
		q:(DiagValues="")
		

		//取质控单元
		s ElementData1 = ##Class(EPRservice.Quality.CheckRule.Template).GetSingleValues(AEpisodeID,AElement1)
		q:($e(ElementData1,1,2) = "0^") ret
		s ElementData1=$e(ElementData1,3,$l(ElementData1))
		
		//质控单元为不允许的值时，进行诊断检验，如果里面有关联诊断返回 -1 否则返回 1
		i (ElementData1 =""){
			
			//取诊断内容
			s Element2ListData = ##Class(EPRservice.Quality.CheckRule.Template).GetSingleValues(AEpisodeID,AElement2s)
			q:($e(Element2ListData,1,2) = "0^") ret
			
			s Element2ListData=$e(Element2ListData,3,$l(Element2ListData))
			q:(Element2ListData="") ret
			
			//诊断内容 与诊断值 进行比较
			s ret=1,DiagNum=$l(DiagValues,"\"),ENum=$l(Element2ListData,"\")	
			for i=1:1:ENum {
			
				s Element2Data=$p(Element2ListData,"\",i)
		
				f j=1:1:DiagNum {	
					s DiagValue = $p(DiagValues,"\",j)
					continue:(DiagValue '= Element2Data)
					s ret=-1
					q
				}
				q:(ret=-1)
		
			}
		
		}
		q ret
}

/// add by lfb 20131111
/// EpisodeID 患者Paadm表ID
/// Element1  质控单元
/// ALocID	  关联科室单元，为公共函数。
/// AValue    特殊科室的
/// 说明：当Element2s中的值为DiagValues中的关联诊断时，Element1的值不可以为空
/// 		  此方法：当患者入院科室为新生儿病室的时候，患者入院体重，出生体重必填
/// ##class(EPRservice.Quality.CheckRule.UnifyPoint).IsUnify234(EpisodeID,"E7590\E7591",{AdmLocID},1271)
ClassMethod IsUnify234(AEpisodeID As %String, AElement1 As %String, ALocID As %String, AValue As %String = 1271) As %String
{
		s ret=0
		//s:(AElement1="E7546") ^LFB=ALocID_"|"_AElement1
		q:(AElement1="")||(ALocID="")||(AValue="") ret
		s LocID=$p(ALocID,"^",1)
		//科室为非质控科室，退出质控程序
		q:(LocID'=AValue) ret
		//取质控单元
		
		s ElementData1 = ##Class(EPRservice.Quality.CheckRule.Template).GetSingleValues(AEpisodeID,AElement1)
		q:($e(ElementData1,1,2) = "0^") ret
		s ElementData1=$e(ElementData1,3,$l(ElementData1))
		//如果质控单元值为空 触犯返回-1
		s:(ElementData1="") ret=-1
		
		
		q ret
}

/// add by lfb 20131111
/// EpisodeID 患者Paadm表ID
/// Element1  首页离院方式
/// ##class(EPRservice.Quality.CheckRule.UnifyPoint).IsUnify235(EpisodeID,E7590)
/// 说明：判断首页离院方式是否与出院结算状态 是否均为死亡
ClassMethod IsUnify235(AEpisodeID As %String, AElement1 As %String) As %String
{
		s ret=0
		q:(AElement1="") ret
		
		//未填写不判断
		s DischTransportDesc=##Class(EPRservice.HISInterface.PatientInfoAssist).GetDischTransport(AEpisodeID)
		q:(DischTransportDesc="") ret
		//取质控单元
		s ElementData1 = ##Class(EPRservice.Quality.CheckRule.Template).GetSingleValues(AEpisodeID,AElement1)
		q:($e(ElementData1,1,2) = "0^") ret
		s ElementData1=$e(ElementData1,3,$l(ElementData1))
		q:(ElementData1="") ret
		//死亡判断不一致
		s:(ElementData1="死亡")&&(DischTransportDesc'="死亡") ret=-1
		s:(ElementData1'="死亡")&&(DischTransportDesc="死亡") ret=-1

		q ret
}

/// （可重复模板，可用于打印，提交，保存 等界面操作的方法）
/// Desc：判断单元字数(不能少于给定字数）
/// Creator：lifengbo
/// CreatDate:2014-2-27
/// Input:AEpisodeID 就诊号，
/// AElement 质控单元号，
/// AWordCount 单元总字数，
/// AWordRowCount 每行字数，
/// ARowsCount 行数
/// AInstanceID 如果是可重复模板，则需要传入InstanceID
/// OutPut:ret 0 不检查参数有误，-1触犯条目，1检查通过
/// Debuge:w ##Class(EPRservice.Quality.CheckRule.UnifyPoint).IsUnify241(559781,"E6379\E6392\E6405",20,"1019872||26")
ClassMethod IsUnify241(AEpisodeID As %String, AElements As %String, AWordCount As %String = 20, AInstanceIDs As %String = "") As %String
{

   s ret = 0, errorInfo="个存在问题病程发生时间如下：",count = 0
   q:((AEpisodeID = "")||(AElements = "")) ret
   s ret = 1
   //s:(AEpisodeID=559781) ^LFB("Init")=AInstanceIDs
   q:AInstanceIDs=""
   s lstInstanceID=##Class(EPRservice.Quality.CommonHelper).GetListFromString(AInstanceIDs,"\")
   for ind=1:1:$ll(lstInstanceID) {
	   
	   s AInstanceID=$listget(lstInstanceID,ind)  
	   s ElementData = ##Class(EPRservice.Quality.CheckRule.Template).GetMultipleValues(AEpisodeID,AElements,AInstanceID)
	   continue:($e(ElementData,1,2)'="1^")
	   //通过临时global 取值
	   s ElementData = ^CacheTemp("EPRQualityTplValue")
	   k ^CacheTemp("EPRQualityTplValue")
	   //将多个对象转换为字符串 多个日常兼容 
	   s ElementData =##Class(EPRservice.Quality.CommonHelper).GetListToString(ElementData,"","Y")
	   s WordCount=$l($tr(ElementData," ",""))
	   
	   continue:( WordCount > AWordCount )
	   //根据回车换行判断字数
	   s ret=-1
	   s InstanceObj=##class(EPRinstance.InstanceData).%OpenId(AInstanceID)
	   continue:(InstanceObj="")
	   s errorInfo=errorInfo_"  "_ind_"."_$zd(InstanceObj.HappenDate,3)_" "_$zt(InstanceObj.HappenTime,1)
	   s count=count+1
   }
   s errorInfo=count_errorInfo
   q ret_"^"_errorInfo
}

/// （可重复模板，可用于提示、自动在院、自动出院等）
/// Desc:判断单元字数(不能少于给定字数）
/// Creator：lifengbo
/// CreatDate:2014-2-27
/// Input:AEpisodeID 就诊号，AStructID 日常病程质控，ARegDateTime 入院时间，ADisDateTime 出院时间，AElements 界面模板记录,AWordCount 字数控制
/// Output: ret -1 触犯^提示信息^触犯次数
/// ##class(EPRservice.Quality.CheckRule.UnifyPoint).IsUnify242(EpisodeID,817,{HISRegTime},{HISDischTime},"E6379\E6392\E6405",20)
/// ##class(EPRservice.Quality.CheckRule.UnifyPoint).IsUnify242(4,817,"2014-01-01 01:00:00","2014-03-05 05:00:00","E6379\E6392\E6405",20)
ClassMethod IsUnify242(AEpisodeID As %String, AStructID As %String, ARegDateTime As %String, ADisDateTime As %String, AElements As %String, AWordCount As %String = 20) As %String
{
	s ret = 0, errorInfo="个存在问题病程发生时间如下：",count = 0
	q:((AEpisodeID = "")||(AStructID = "")||(ARegDateTime = "")||(AWordCount = "")) ret
    
	s regDateTime = ##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(ARegDateTime)
	s disDateTime = ##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(ADisDateTime)
	
	s checkDate = $p(disDateTime," ",1)
	s:(checkDate = "") checkDate = $p($h,",",1)
	s checkTime = $p(disDateTime," ",2)
	s:(checkTime = "") checkTime = $p($h,",",2)
	
	s fromDate = $p(regDateTime," ",1)
	s fromTime = $p(regDateTime," ",2)
	s:(fromTime = "") fromTime = 0
	s toDate = +checkDate

	s result = ##Class(EPRservice.Quality.CheckRule.Course).GetMultiContentIllegal(AEpisodeID,AStructID,fromDate,fromTime,toDate,checkTime,AElements,AWordCount)	
	 
	q:($e(result,1,2) = "0^")
	s Tempstr= $e(result,3,$l(result))
	s Tempcount = $p(Tempstr,"^",1)
	s TemperrorInfo = $p(Tempstr,"^",2)
	  
	q:(Tempcount = 0) 1
	  
	s tmperrorInfo = TemperrorInfo
	
	s:(Tempcount > 0 ) ret = -1
	
	
	s Info=Tempcount_errorInfo_tmperrorInfo
	q ret_"^"_Info
}

/// （可重复模板，可用于打印，提交，保存 等界面操作的方法）
/// Desc:检查病历是否为超过48小时补写病历（适用于发生时间不可以修改的医院）
/// Creator：lifengbo
/// CreatDate:2014-2-27
/// Input:AEpisodeID 就诊号，AStructID 日常病程质控，ARegDateTime 入院时间，ADisDateTime 出院时间，AElements 界面模板记录,AHour 时间控制
/// Output: 
/// w ##class(EPRservice.Quality.CheckRule.UnifyPoint).IsUnify243(559781,"E6381\E6394\E6407",24,"1019872||25")
/// ##class(EPRservice.Quality.CheckRule.UnifyPoint).IsUnify243("4","E6381",48,"18||1")
ClassMethod IsUnify243(AEpisodeID As %String, AElements As %String, AHour As %String = 48, AInstanceIDs As %String = "") As %String
{
	//s ^LFB("QaQ")=$lb(AEpisodeID,AElements,AHour,AInstanceIDs)
	
   s ret = 0, errorInfo="个存在问题病程发生时间如下：",count = 0
   q:((AEpisodeID = "")||(AElements = "")) ret
   s ret = 1
   q:AInstanceIDs=""
   s lstInstanceID=##Class(EPRservice.Quality.CommonHelper).GetListFromString(AInstanceIDs,"\")
   for ind=1:1:$ll(lstInstanceID) {
	   
	   s AInstanceID=$listget(lstInstanceID,ind)  
	   s ElementData = ##Class(EPRservice.Quality.CheckRule.Template).GetMultipleValues(AEpisodeID,AElements,AInstanceID)
	  
	   s ElementData = ^CacheTemp("EPRQualityTplValue")
	   k ^CacheTemp("EPRQualityTplValue") 
	   //将多个对象转换为字符串 多个日常取时间作比较
	   s InstanceObj=##class(EPRinstance.InstanceData).%OpenId(AInstanceID)
	   continue:(InstanceObj="")
	   
	   f ind2=1:1:$ll(ElementData) {
		   
		   
			s tmpDateTime=$listget(ElementData,ind2)
			continue:(tmpDateTime="")
			//转换为系统时间格式
			s tmpDateTime=##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(tmpDateTime)

			s InstanceDateTime=InstanceObj.HappenDate_" "_InstanceObj.HappenTime
			//计算时间差值
			s timeGap = ##Class(EPRservice.Quality.CommonHelper).GetDateTimeGap(InstanceDateTime,tmpDateTime)
			
			//判定时间差是否大于 AHour
			continue:(timeGap<=AHour)
			
	   		s ret=-1
	   		s errorInfo=errorInfo_"  "_ind_"."_$zd(InstanceObj.HappenDate,3)_" "_$zt(InstanceObj.HappenTime,1)
	   		s count=count+1
		}
	      
   }
   s errorInfo=count_errorInfo
   q ret_"^"_errorInfo
}

/// （可重复模板，可用于提示、自动在院、自动出院等）
/// Desc:检查病历是否为超过48小时补写病历（适用于发生时间不可以修改的医院）
/// Creator：lifengbo
/// CreatDate:2014-2-27
/// Input:AEpisodeID 就诊号，AStructID 日常病程质控，ARegDateTime 入院时间，ADisDateTime 出院时间，AElements 界面模板记录,AHour 时间控制
/// Output: ret -1 触犯^提示信息^触犯次数
/// ##class(EPRservice.Quality.CheckRule.UnifyPoint).IsUnify244(EpisodeID,817,{HISRegTime},{HISDischTime},"E6381\E6394\E6407",48)
/// ##class(EPRservice.Quality.CheckRule.UnifyPoint).IsUnify244(4,817,"2014-01-01 18:25:00","","E6381\E6394\E6407",24)
ClassMethod IsUnify244(AEpisodeID As %String, AStructID As %String, ARegDateTime As %String, ADisDateTime As %String, AElements As %String, AHour As %String = 48) As %String
{
	s ret = 1, errorInfo="个为补写的病程发生时间为：",count = 0
	q:((AEpisodeID = "")||(AStructID = "")||(ARegDateTime = "")||(AHour = "")) ret 
	s regDateTime = ##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(ARegDateTime)
	s disDateTime = ##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(ADisDateTime)
	s checkDate = $p(disDateTime," ",1)
	s:(checkDate = "") checkDate = $p($h,",",1)
	s checkTime = $p(disDateTime," ",2)
	s:(checkTime = "") checkTime = $p($h,",",2)
	s fromDate = $p(regDateTime," ",1)
	s fromTime = $p(regDateTime," ",2)
	s:(fromTime = "") fromTime = 0
	s toDate = +checkDate
	
	s result = ##Class(EPRservice.Quality.CheckRule.Course).GetMultiTimeIllegal(AEpisodeID,AStructID,fromDate,fromTime,toDate,checkTime,AElements,AHour)	
	q:($e(result,1,2) = "0^")
	
	s Tempstr= $e(result,3,$l(result))
	s Tempcount = $p(Tempstr,"^",1)
	s TemperrorInfo = $p(Tempstr,"^",2)
	q:(Tempcount = 0) 1 
	s errorInfo = errorInfo_TemperrorInfo
	s:(Tempcount > 0 ) ret = -1
	s Info=Tempcount_errorInfo
	q ret_"^"_Info
}

/// （唯一模板）
/// Desc:检查唯一模板类型的手术记录是否为超过界面单元结束时间24小时补写病历（适用于发生时间不可以修改的医院）
/// Creator：lifengbo
/// CreatDate:2014-3-15
/// Input:AEpisodeID 就诊号，AStructID 日常病程质控，ARegDateTime 入院时间，ADisDateTime 出院时间，AElements 界面模板记录,AHour 时间控制
/// AElement1  只可以配置一个质控单元值
/// 
/// AElement2  只可以配置一个质控单元值
/// 
/// ATimeType 1: 界面上时间由一个单元取得  AElement1 为 日期时间
///          2：界面上时间由二个单元取的  AElement1 为 日期 AElement2 为 时间
/// Output:  -1 超时补写  1 规定时限内完成。
/// w ##class(EPRservice.Quality.CheckRule.UnifyPoint).IsUnify245(559781,"E6381\E6394\E6407",24,"1019872||25")
/// ##class(EPRservice.Quality.CheckRule.UnifyPoint).IsUnify245(559781,822,"E6561","E6563",24,2)
ClassMethod IsUnify245(AEpisodeID As %String, AStructID As %String, AElement1 As %String, AElement2 As %String, AElement3 As %String, AHour As %String = 24, ATimeType As %String = 1) As %String
{

	
   s ret = 0 
   q:((AEpisodeID = "")||(AElement1 = "")) ret
   s ret = 1

	s QualityTID=$e(AElement1,2,$length(AElement1))
	s QualityTIDobj=##class(EPRmeta.Quality.QualityTemplate).%OpenId(QualityTID)
	s ETID=QualityTIDobj.TemplateId
	
	if (ATimeType=2) {
		//s ElementData1 = ##Class(EPRservice.Quality.CheckRule.Template).GetSingleValues(559781,"E6561")
		s ElementData1 = ##Class(EPRservice.Quality.CheckRule.Template).GetSingleValues(AEpisodeID,AElement1)
		q:$e(ElementData1,1,2)'="1^"
		s ElementData2 = ##Class(EPRservice.Quality.CheckRule.Template).GetSingleValues(AEpisodeID,AElement2)
		q:$e(ElementData2,1,2)'="1^"
		s tmpDateTime = $p(ElementData1,"^",2)_" "_$p(ElementData2,"^",2)
	}
	else {
		s ElementData = ##Class(EPRservice.Quality.CheckRule.Template).GetSingleValues(AEpisodeID,AElement1)
		q:$e(ElementData,1,2)'="1^"
		s tmpDateTime = $p(ElementData,"^",2)
	}
	
	s objStruct = $g(^DHCEPRM.QualityStructD(AStructID))
	s IsActive = $list(objStruct,8)
	q:($zcvt(IsActive,"U") '= "Y") ret
		
	s CategoryID = $list(objStruct,5)
	q:(CategoryID = "") ret
	
	// 取ECRecord
	s ecRecordId = ##class(EPRinstance.ECRecord).GetIDByEpisodeAndCategoryID(AEpisodeID, CategoryID)
	q:(ecRecordId="") ret
	
	
	s ecRecordId = ""
	for {
		s ecRecordId  = $o(^DHCEPRI.ECRecordI("IdxEpisodeIDCategoryID"," "_AEpisodeID," "_CategoryID,ecRecordId))
		q:(ecRecordId="")	
	
		// 遍历ECRecord下的所有病历，找到所需的病历
		s childSub = ""
		for {
				s childSub = $O(^DHCEPRI.InstanceDataI("IdxECRecord",ecRecordId,childSub))
				q:(childSub="")
				
				s instanceId = ecRecordId_"||"_childSub
				
				s InstanceObj = ##class(EPRinstance.InstanceData).%OpenId(instanceId)
				if (InstanceObj="") continue
				if (InstanceObj.Status="UnSave") continue
					
				continue:(InstanceObj.TemplateID'=ETID)
				
				
				s InstanceDateTime=InstanceObj.HappenDate_" "_InstanceObj.HappenTime
				//计算时间差值
				//创建时间-手术时间 如果提提前创建 为负值不触犯，如果为补录 则差值大于零 超过24小时触犯！
				s timeGap = ##Class(EPRservice.Quality.CommonHelper).GetDateTimeGap(InstanceDateTime,tmpDateTime)
				
				//判定时间差是否大于 AHour
				continue:(timeGap<AHour)
				s ElementData3 = ##Class(EPRservice.Quality.CheckRule.Template).GetSingleValues(AEpisodeID,AElement3)
				s errorInfo="主刀医生："_$p(ElementData3,"^",2)
	   			s ret=-1
		}
	}
	 
	q ret_"^"_errorInfo
}

/// （唯一模板）
/// Desc:病案首页，控制出生日期与身份证日期一致（18位身份证）。
/// Creator：lifengbo
/// CreatDate:2014-3-17
/// Input:AEpisodeID 就诊号
/// AElement1  病案首页出生日期
/// 
/// AElement2  病案首页身份证
/// Output:  -1 不一致  1 一致。
/// w ##class(EPRservice.Quality.CheckRule.UnifyPoint).IsUnify245(559781,"E6381\E6394\E6407",24,"1019872||25")
/// ##class(EPRservice.Quality.CheckRule.UnifyPoint).IsUnify246(559781,"E7541","E7548")
ClassMethod IsUnify246(AEpisodeID As %String, AElement1 As %String, AElement2 As %String) As %String
{

	
   	s ret = 0 
   	q:((AEpisodeID = "")||(AElement1 = "")||(AElement2 = "")) ret
   	s ret = 1

	s ElementData1 = ##Class(EPRservice.Quality.CheckRule.Template).GetSingleValues(AEpisodeID,AElement1)
	q:$e(ElementData1,1,2)'="1^" ret
	s ElementData2 = ##Class(EPRservice.Quality.CheckRule.Template).GetSingleValues(AEpisodeID,AElement2)
	q:$e(ElementData2,1,2)'="1^" ret
	//身份证号不是18位不质控
	s IDCardNo=$e(ElementData2,3,$l(ElementData2))
	q:($l(IDCardNo)'=18) ret
	
	s IDCardNoBirthDay=$e(IDCardNo,7,14)
	
	//转换取出生日期格式为纯数字
	s ElementData1=$e(ElementData1,3,$l(ElementData1))
	s systypBirthDay = ##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(ElementData1)
	s tpy3Birthday=$zd(systypBirthDay,3)
	s tpy3Birthday=$tr(tpy3Birthday,"-","")
	//验证出生日期是否与身份证件一致
	s:(tpy3Birthday'=IDCardNoBirthDay) ret=-1
	q ret
}

/// Creator:lifb
/// Desc: 验证值为纯数字，应用说明：验证病案首页新生儿体重纯数字。
/// Input: Element1为单元，ExtValues1为例外 如： 无，不详，未提示 等
/// Output: ret<0 
/// Debug: 
/// 出生体重
/// 		w ##Class(EPRservice.Quality.CheckRule.UnifyPoint).IsUnify247(559781,"E7545","0\-")
/// 入院体重
/// 		w ##Class(EPRservice.Quality.CheckRule.UnifyPoint).IsUnify247(EpisodeID,"E7546","0\-")
ClassMethod IsUnify247(EpisodeID As %String, Element1 As %String, ExtValues1 As %String = "0\-") As %String
{
	s ret=0 ,num=0
	q:(EpisodeID="")||(Element1="") ret
	//b "s"
	s ret=1
	s ElementData1=##Class(EPRservice.Quality.CheckRule.Template).GetSingleValues(EpisodeID,Element1)
	q:$e(ElementData1,1,2)="0^" ret
	s ElementData1=$e(ElementData1,3,$l(ElementData1))
	q:(ElementData1="") ret

	//例外
	s ret=2
	if ExtValues1'="" {
		s Values1List=##Class(EPRservice.Quality.CommonHelper).GetListFromString(ExtValues1,"\")
		q:($listfind(Values1List,ElementData1)'=0) ret
	}
	
	//数值验证  纯数字 且第一个 不能为0
	s ret=3
	s tmpElementData1=$length(ElementData1)

	for i=1:1:tmpElementData1 {
		
		s IDCardnum=$E(ElementData1,i)
		s numACode=$a(IDCardnum)
		s:(i=1)&&(numACode=48) ret=-1	
		s:(numACode<48)||(numACode>57) ret=-1
		q:(ret=-1)
	}

	q ret
}

/// -----------------------------------------------------------------20140622-------------------------end
/// Desc：判断是否所有病历均已签名
/// Creator：Donglulu
/// CreatDate:2017-5-5
/// Input:AEpisodeID 就诊号，
/// ADocIDs 模板的docID，以"#"分隔
/// OutPut:ret 0 不检查参数有误，-1触犯条目，1检查通过
/// Debuge:w ##Class(EPRservice.Quality.CheckRule.UnifyPoint).IsUnify249(230,"53#88#51#100#56#97#58#70#62")
ClassMethod IsUnify249(AEpisodeID As %String, ADocIDs As %String) As %String
{
    s ret = 0
    q:((AEpisodeID = "")||(ADocIDs = "")) ret
    s ret = 1
    s errorInfo = ""
    
    s idCount=$l(ADocIDs, "#")
	f i=1:1:idCount 
	{
		s docID = $p(ADocIDs, "#", i)
		s ECRecordID = $o(^DHCEMRI.ECRecordI("IdxEpisodeIDChartItemID"," "_AEpisodeID," "_docID,""))
		continue:(ECRecordID = "")
		s happenDate = ""
		for
		{
			s happenDate = $o(^DHCEMRI.InstanceDataI("IdxHappenDateTime",ECRecordID," SAVE",happenDate))
			q:(happenDate = "")
			s happenTime = ""
			for
			{
				s happenTime = $o(^DHCEMRI.InstanceDataI("IdxHappenDateTime",ECRecordID," SAVE",happenDate,happenTime))
				q:(happenTime = "")
				s listNo = ""
				for
				{
					s listNo = $o(^DHCEMRI.InstanceDataI("IdxHappenDateTime",ECRecordID," SAVE",happenDate,happenTime,listNo))
					q:(listNo = "")
					
					s instanceID = ECRecordID_"||"_listNo
					s objInstance = ##Class(EMRinstance.InstanceData).%OpenId(instanceID)
					q:(objInstance = "")
					s currentLog = ##Class(EMRservice.BL.BLEMRLogs).GetCurrentLog(AEpisodeID,docID,listNo)
					q:(currentLog = "")
					if ((currentLog.EMRStatus = "unfinished")||(currentLog.EMRStatus = "finished"))
					{
						s ret = -1
						if (errorInfo="")
						{
							s errorInfo = objInstance.Title
						}
						else
						{
							s errorInfo = errorInfo_"，"_objInstance.Title
						}
					}
				
				}
			}
		}
	}
    q ret_"^"_errorInfo
}

/// -----------------------------------------------------------------20140622-------------------------end
/// Desc：判断必填病历是否已填好
/// Creator：Donglulu
/// CreatDate:2017-5-10
/// Input:AEpisodeID 就诊号，
/// ADocInfo 普通模板格式：userLocID1^userLocID2|docID|   
///         可重复模板格式：userLocID1^userLocID2|docID|titlecode1^titlecode2
///         docID:病历展现结构《挂靠界面模板的目录》，EMRmeta.EMRTemplateCategory的TempCate
/// 			titlecode：标题维护的code，EMRmeta.Titles的Code
/// OutPut:ret 0 不检查参数有误，-1触犯条目，1检查通过
/// Debuge:w ##Class(EPRservice.Quality.CheckRule.UnifyPoint).IsUnify250(230,"6^5^1|53|")
ClassMethod IsUnify250(AEpisodeID As %String, ADocInfo As %String) As %String
{
    s ret = 0
    q:((AEpisodeID = "")||(ADocInfo = "")) ret
    s ret = 1
    s errorInfo = ""
    
    s userLocID = $P($g(^PAADM(AEpisodeID)),"^",4)
    q:(userLocID = "")
    
    s locInfo = $p(ADocInfo, "|", 1)
    q:(locInfo = "")
    s locIDCount=$l(locInfo, "^")
	f i=1:1:locIDCount 
	{
		s locID = $p(locInfo, "^", i)
		q:(locID = "")
	    continue:(locID '= userLocID)

		s docID = $p(ADocInfo, "|", 2)
		continue:(docID = "")
		s ECRecordID = $o(^DHCEMRI.ECRecordI("IdxEpisodeIDChartItemID"," "_AEpisodeID," "_docID,""))
		s happenDate = ""
		if (ECRecordID '= "")
		{
			s happenDate = $o(^DHCEMRI.InstanceDataI("IdxHappenDateTime",ECRecordID," SAVE",""))
		}
		s titleInfo = $p(ADocInfo, "|", 3)
		if (titleInfo '= "")
		{
			s errorTitle = ""
			if ((ECRecordID = "")||(happenDate = ""))
			{
				s errorTitle = $p(ADocInfo, "|", 3)
			}
			else
			{
				s titileCount=$l(titleInfo, "^")
				f i=1:1:titileCount 
				{
					s titleCode = $p(titleInfo, "^", i)
					q:(titleCode = "")
					if ($o(^DHCEMRI.InstanceDataI("IdxEpisodeTitleCodeStatus"," "_AEpisodeID," "_titleCode," SAVE","")) '= ECRecordID)
					{
						if (errorTitle = "")
						{
							s errorTitle = titleCode
						}
						else
						{
							s errorTitle = errorTitle_"^"_titleCode
						}
					}
				
				
				}
			}
			if (errorTitle '= "")
			{
				s ret = -1
				s titileCount=$l(errorTitle, "^")
				f i=1:1:titileCount 
				{
					s titleCode = $p(errorTitle, "^", i)
					q:(titleCode = "")
					s titleID = $o(^DHCEMRM.TitlesI("IdxCode"," "_titleCode,""))
					continue:(titleID = "")
					s objTitles = ##Class(EMRmeta.Titles).%OpenId(titleID)
					continue:(objTitles = "")
					if (objTitles.Description '= "")
					{
						if (errorInfo="")
						{
							s errorInfo = objTitles.Description
						}
						else
						{
							s errorInfo = errorInfo_"，"_objTitles.Description
						}
					}
				}
			}
		}
		else
		{
			if ((ECRecordID = "")||(happenDate = ""))
			{
				s ret = -1
				s objEMRTemplateCategory = ##Class(EMRmeta.EMRTemplateCategory).%OpenId(docID)
				q:(objEMRTemplateCategory = "")
				if (objEMRTemplateCategory.CategoryName '= "")
				{
					if (errorInfo="")
					{
						s errorInfo = objEMRTemplateCategory.CategoryName
					}
					else
					{
						s errorInfo = errorInfo_"，"_objEMRTemplateCategory.CategoryName
					}
				}
			}
		}
	}
    q ret_"^"_errorInfo
}

/// Desc：判断唯一模板是否至少已填好一份病历
/// Creator：Donglulu
/// CreatDate:2017-5-17
/// Input:AEpisodeID 就诊号，
/// ADocInfo 格式：userLocID1^userLocID2|docID1^docID2  
///         docID:病历展现结构《挂靠界面模板的目录》，EMRmeta.EMRTemplateCategory的TempCate
/// OutPut:ret 0 不检查参数有误，-1触犯条目，1检查通过
/// Debuge:w ##Class(EPRservice.Quality.CheckRule.UnifyPoint).IsUnify251(230,"6^5^1|53^51")
ClassMethod IsUnify251(AEpisodeID As %String, ADocInfo As %String) As %String
{
    s ret = 0
    q:((AEpisodeID = "")||(ADocInfo = "")) ret
    s ret = 1
    s errorInfo = ""
    
    s userLocID = $P($g(^PAADM(AEpisodeID)),"^",4)
    q:(userLocID = "")
    
    s locInfo = $p(ADocInfo, "|", 1)
    q:(locInfo = "")
    s locIDCount=$l(locInfo, "^")
	f i=1:1:locIDCount 
	{
		s locID = $p(locInfo, "^", i)
		q:(locID = "")
	    continue:(locID '= userLocID)

		s docIDs = $p(ADocInfo, "|", 2)
		continue:(docIDs = "")
		s docIDCount=$l(docIDs, "^")
		s happenDate = ""
		f i=1:1:docIDCount 
		{
			s docID = $p(docIDs, "^", i)
			q:(docID = "")
			s ECRecordID = $o(^DHCEMRI.ECRecordI("IdxEpisodeIDChartItemID"," "_AEpisodeID," "_docID,""))
			if (ECRecordID '= "")
			{
				s happenDate = $o(^DHCEMRI.InstanceDataI("IdxHappenDateTime",ECRecordID," SAVE",""))
			}
			q:(happenDate '= "")
		}
		if ((ECRecordID = "")||(happenDate = ""))
		{
			s ret = -1
		}
	}
    q ret_"^"_errorInfo
}

/// Desc：判断可重复模板是否已填好至少其中一份病历
/// Creator：Donglulu
/// CreatDate:2017-5-17
/// Input:AEpisodeID 就诊号，
/// ADocInfo 可重复模板格式：userLocID1^userLocID2|docID|titlecode1^titlecode2
///         docID:病历展现结构《挂靠界面模板的目录》，EMRmeta.EMRTemplateCategory的TempCate
/// 			titlecode：标题维护的code，EMRmeta.Titles的Code
/// OutPut:ret 0 不检查参数有误，-1触犯条目，1检查通过
/// Debuge:w ##Class(EPRservice.Quality.CheckRule.UnifyPoint).IsUnify252(230,"6^5^1|56|1^2^3")
ClassMethod IsUnify252(AEpisodeID As %String, ADocInfo As %String) As %String
{
    s ret = 0
    q:((AEpisodeID = "")||(ADocInfo = "")) ret
    s ret = 1
    s errorInfo = ""
    
    s userLocID = $P($g(^PAADM(AEpisodeID)),"^",4)
    q:(userLocID = "")
    
    s locInfo = $p(ADocInfo, "|", 1)
    q:(locInfo = "")
    s locIDCount=$l(locInfo, "^")
	f i=1:1:locIDCount 
	{
		s locID = $p(locInfo, "^", i)
		q:(locID = "")
	    continue:(locID '= userLocID)

		s docID = $p(ADocInfo, "|", 2)
		continue:(docID = "")
		s ECRecordID = $o(^DHCEMRI.ECRecordI("IdxEpisodeIDChartItemID"," "_AEpisodeID," "_docID,""))
		s happenDate = ""
		if (ECRecordID '= "")
		{
			s happenDate = $o(^DHCEMRI.InstanceDataI("IdxHappenDateTime",ECRecordID," SAVE",""))
		}
		s titleInfo = $p(ADocInfo, "|", 3)
		continue:(titleInfo = "")
		s flag = 0
		s titileCount=$l(titleInfo, "^")
		f i=1:1:titileCount 
		{
			s titleCode = $p(titleInfo, "^", i)
			q:(titleCode = "")
			if ($o(^DHCEMRI.InstanceDataI("IdxEpisodeTitleCodeStatus"," "_AEpisodeID," "_titleCode," SAVE","")) = ECRecordID)
			{
				s flag = 1
				q
			}
		}
		if (flag = 0)
		{
			s ret = -1
		}
	}
    q ret_"^"_errorInfo
}

/// -----------------------------------------------------------------20140622-------------------------end
/// Creator:lifb
/// 判定医生是否归属于某个科室，根据User.RBResource表数据进行数据筛选
/// 对于一个医生，从他多个登陆位置中找到是否与当前要求的科室关联的数据。
/// Debug:	w ##Class(EPRservice.Quality.CheckRule.UnifyPoint).IsWardLocUnity(EpisodeID,"EC10424","EC10422")
ClassMethod IsWardLocUnity(AEpisdoeID, ADischWard, ADischCTLoc) As %String
{
	q:(ADischWard = "")&&(ADischCTLoc = "") "1"
	
	s DischLocInfo = ##Class(EPRservice.Quality.CheckRule.Template).GetSingleValues(AEpisdoeID,ADischCTLoc)	
	q:($e(DischLocInfo,1,2) = "0^") ret
	s DischLocID=$e(DischLocInfo,3,$l(DischLocInfo))
	
	s DischWardInfo = ##Class(EPRservice.Quality.CheckRule.Template).GetSingleValues(AEpisdoeID,ADischWard)	
	q:($e(DischWardInfo,1,2) = "0^") ret
	s DischWardID=$e(DischWardInfo,3,$l(DischWardInfo))
	
	s ctLocDR = $p($g(^PAWARD(DischWardID)),"^",5)
	
	s LINKChildsub=""
	
	s LINKChildsub=$o(^CTLOC(DischLocID,"LINK",0,"Loc",ctLocDR, LINKChildsub))
	
	s:(LINKChildsub="") ret="-1^"
	
	q ret
}

/// w ##Class(EPRservice.Quality.CheckRule.UnifyPoint).IsDischLocDoc(10351379,"EC10422","EC10492")
/// 判定病历数据，病案首页中 医生 是否均为 患者出院科室内医生。
ClassMethod IsDischLocDocNew(AEpisdoeID As %String, AElementDischLoc As %String, AElementDocs As %String) As %String
{
	s ret="0^"
	s DischLocInfo = ##Class(EPRservice.Quality.CheckRule.Template).GetSingleValues(AEpisdoeID,AElementDischLoc)	
	q:($e(DischLocInfo,1,2) = "0^") ret
	s DischLocID=$e(DischLocInfo,3,$L(DischLocInfo))
	
	s DocUserInfo = ##Class(EPRservice.Quality.CheckRule.Template).GetSingleValues(AEpisdoeID,AElementDocs)
	q:($e(DocUserInfo,1,2) = "0^") ret
	s DocUserInit=$e(DocUserInfo,3,$L(DocUserInfo))

	s DocUserID=""
	
	s DocUserID=$o(^SSU("SSUSR",0,"SSUSR_Initials",$ZCVT(DocUserInit,"U"),DocUserID))

	s CTPCPID=$p(^SSU("SSUSR",DocUserID),"^",14)
	
	s RBRowID=""
	s RBRowID=$o(^RB("RES",0,"CTPCP",CTPCPID,DischLocID,RBRowID))

	 s:(RBRowID="") ret="-1^"
	 s:(RBRowID>0) ret="1^"
	 q ret
}

}
