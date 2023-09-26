Import SQLUser

/// 维护ACR表达式用到的函数或方法
/// By ZF 2009-06-14
Class web.DHCWMRQuality.BOACRExpBaseFun Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 65;

/// ****************************************************************
/// *********************START 中国医大 20090614********************
/// ****************************************************************
/// 
/// ****************************************************************
/// 说明: 病案首页{联系人姓名:患者家属等}与病案首页{关系:患者与联系人关系}一致性检查
/// 结论: ret<0 不一致
/// 调试: w ##Class(web.DHCWMRQuality.BOACRExpBaseFun).IsUnify0001(EpisodeID,Element1,Element2,TemplateID)
/// ****************************************************************
ClassMethod IsUnify0001(EpisodeID As %String, Element1 As %String, Element2 As %String, TemplateID As %String) As %String
{
	n (EpisodeID,Element1,Element2,TemplateID)
	s ret=0
	q:(EpisodeID="")||(Element1="")||(Element2="") ret
	s CatName1=$list(Element1,1),ElName1=$list(Element1,2)
	s CatName2=$list(Element2,1),ElName2=$list(Element2,2)
	s flg1=##Class(web.DHCWMRQuality.BOACRExpBaseEpr).IsRightElNormName(EpisodeID,CatName1,ElName1,TemplateID)
	s flg2=##Class(web.DHCWMRQuality.BOACRExpBaseEpr).IsRightElNormName(EpisodeID,CatName2,ElName2,TemplateID)
	q:(flg1<1)||(flg2<1) ret
	s ElementData1=##Class(web.DHCWMRQuality.BOACRExpBaseEpr).GetElementDataByName(EpisodeID,CatName1,ElName1,"")
	s ElementData2=##Class(web.DHCWMRQuality.BOACRExpBaseEpr).GetElementDataByName(EpisodeID,CatName2,ElName2,"")
	s:ElementData1'="" ElementData1=$list(ElementData1,1)
	s:ElementData2'="" ElementData2=$list(ElementData2,1)
	q:(ElementData1="")&&(ElementData2="") ret
	s ElementData1=##Class(web.DHCWMRQuality.BOACRExpBaseHis).ClearUselessChar(ElementData1," /-")
	s ret=1
	i (ElementData1="")||(ElementData1="无")||(ElementData1="不详") d
	.s:(ElementData2'="")&&(ElementData2'="其他")&&(ElementData2'="其它")&&(ElementData2'="不详") ret=-1
	e  d
	.s:(ElementData2="")||(ElementData2="其他")||(ElementData2="其它")||(ElementData2="不详") ret=-1
	q ret
}

/// ****************************************************************
/// 说明: 病案首页{数字单元:输血量,抢救次数,成功次数等}是否为数字
/// 结论: ret<0 不一致
/// 调试: w ##Class(web.DHCWMRQuality.BOACRExpBaseFun).IsUnify0002(EpisodeID,Element,TemplateID)
/// ****************************************************************
ClassMethod IsUnify0002(EpisodeID As %String, Element As %String, TemplateID As %String) As %String
{
	n (EpisodeID,Element,TemplateID)
	s ret=0
	q:(EpisodeID="")||(Element="") ret
	s CatName=$list(Element,1),ElName=$list(Element,2)
	s flg=##Class(web.DHCWMRQuality.BOACRExpBaseEpr).IsRightElNormName(EpisodeID,CatName,ElName,TemplateID)
	q:flg<1 ret
	s ElementData=##Class(web.DHCWMRQuality.BOACRExpBaseEpr).GetElementDataByName(EpisodeID,CatName,ElName,"")
	s:ElementData'="" ElementData=$list(ElementData,1)
	q:ElementData="" ret
	s ElementData=$tr(ElementData,"零","0")
	s ret=1
	s:(+ElementData)'=ElementData ret=-1
	q ret
}

/// ****************************************************************
/// 说明: 病案首页{模板单元:姓名等}不允许有空格
/// 结论: ret<0 不一致
/// 调试: w ##Class(web.DHCWMRQuality.BOACRExpBaseFun).IsUnify0003(EpisodeID,Element,TemplateID)
/// ****************************************************************
ClassMethod IsUnify0003(EpisodeID As %String, Element As %String, TemplateID As %String) As %String
{
	n (EpisodeID,Element,TemplateID)
	s ret=0
	q:(EpisodeID="")||(Element="") ret
	s CatName=$list(Element,1),ElName=$list(Element,2)
	s flg=##Class(web.DHCWMRQuality.BOACRExpBaseEpr).IsRightElNormName(EpisodeID,CatName,ElName,TemplateID)
	q:flg<1 ret
	s ElementData=##Class(web.DHCWMRQuality.BOACRExpBaseEpr).GetElementDataByName(EpisodeID,CatName,ElName,"")
	s:ElementData'="" ElementData=$list(ElementData,1)
	q:ElementData="" ret
	s ret=1
	s:ElementData[" " ret=-1
	q ret
}

/// ****************************************************************
/// 说明: 病案首页{婚姻状况}与病案首页{年龄}不一致
/// 结论: ret<0 不一致
/// 调试: w ##Class(web.DHCWMRQuality.BOACRExpBaseFun).IsUnify0004(EpisodeID,Element1,Element2,TemplateID)
/// ****************************************************************
ClassMethod IsUnify0004(EpisodeID As %String, Element1 As %String, Element2 As %String, TemplateID As %String) As %String
{
	n (EpisodeID,Element1,Element2,TemplateID)
	s ret=0
	q:(EpisodeID="")||(Element1="")||(Element2="") ret
	s CatName1=$list(Element1,1),ElName1=$list(Element1,2)
	s CatName2=$list(Element2,1),ElName2=$list(Element2,2)
	s flg1=##Class(web.DHCWMRQuality.BOACRExpBaseEpr).IsRightElNormName(EpisodeID,CatName1,ElName1,TemplateID)
	s flg2=##Class(web.DHCWMRQuality.BOACRExpBaseEpr).IsRightElNormName(EpisodeID,CatName2,ElName2,TemplateID)
	q:(flg1<1)||(flg2<1) ret
	s ElementData1=##Class(web.DHCWMRQuality.BOACRExpBaseEpr).GetElementDataByName(EpisodeID,CatName1,ElName1,"")
	s ElementData2=##Class(web.DHCWMRQuality.BOACRExpBaseEpr).GetElementDataByName(EpisodeID,CatName2,ElName2,"")
	s:ElementData1'="" ElementData1=$list(ElementData1,1)
	s:ElementData2'="" ElementData2=$list(ElementData2,1)
	q:(ElementData1="")&&(ElementData2="") ret
	s ret=1
	s:ElementData2["岁" Age=+$p(ElementData2,"岁",1)
	s:ElementData2'["岁" Age=1
	i Age<16 d
	.s:(ElementData1'="未婚")&&(ElementData1'="") ret=-1
	q ret
}

/// ****************************************************************
/// 说明: 病案首页{邮编} "邮编","无","不详"不允许共存
/// 结论: ret<0 不一致
/// 调试: w ##Class(web.DHCWMRQuality.BOACRExpBaseFun).IsUnify0005(EpisodeID,Element,TemplateID)
/// ****************************************************************
ClassMethod IsUnify0005(EpisodeID As %String, Element As %String, TemplateID As %String) As %String
{
	n (EpisodeID,Element,TemplateID)
	s ret=0
	q:(EpisodeID="")||(Element="") ret
	s CatName=$list(Element,1),ElName=$list(Element,2)
	s flg=##Class(web.DHCWMRQuality.BOACRExpBaseEpr).IsRightElNormName(EpisodeID,CatName,ElName,TemplateID)
	q:flg<1 ret
	s ElementData=##Class(web.DHCWMRQuality.BOACRExpBaseEpr).GetElementDataByName(EpisodeID,CatName,ElName,"")
	s:ElementData'="" ElementData=$list(ElementData,1)
	q:ElementData="" ret
	s ElementData=##Class(web.DHCWMRQuality.BOACRExpBaseHis).ClearUselessChar(ElementData," /-")
	s ret=1
	s:(ElementData'="无")&&(ElementData'="不详")&&($tr(ElementData,"无","")'=ElementData) ret=-1
	s:(ElementData'="无")&&(ElementData'="不详")&&($tr(ElementData,"不详","")'=ElementData) ret=-1
	q ret
}

/// ****************************************************************
/// 说明: 病案首页{日期单元:确诊日期,手术日期等}不允许超出入出院时间
/// 结论: ret<0 不一致
/// 调试: w ##Class(web.DHCWMRQuality.BOACRExpBaseFun).IsUnify0006(EpisodeID,Element,TemplateID)
/// ****************************************************************
ClassMethod IsUnify0006(EpisodeID As %String, Element As %String, TemplateID As %String) As %String
{
	n (EpisodeID,Element,TemplateID)
	s ret=0
	q:(EpisodeID="")||(Element="") ret
	s CatName=$list(Element,1),ElName=$list(Element,2)
	s flg=##Class(web.DHCWMRQuality.BOACRExpBaseEpr).IsRightElNormName(EpisodeID,CatName,ElName,TemplateID)
	q:flg<1 ret
	s DateTime=##Class(web.DHCWMRQuality.BOACRExpBaseHis).GetInPatDateTime(EpisodeID)
	q:DateTime="" ret
	s ElementData=##Class(web.DHCWMRQuality.BOACRExpBaseEpr).GetElementDataByName(EpisodeID,CatName,ElName,"")
	s:ElementData'="" ElementData=$list(ElementData,1)
	q:ElementData="" ret
	s ElementData=##Class(web.DHCWMRQuality.BOACRExpBaseHis).ChangeDateTime(ElementData)
	q:ElementData="" ret
	s RegDate=$p($list(DateTime,1)," ",1)
	q:RegDate="" ret
	s ret=1
	s flg=##Class(web.DHCWMRQuality.BOACRExpBaseHis).GetDateTimeGap(ElementData,RegDate)
	s:flg<0 ret=-1
	s DischDate=$p($list(DateTime,2)," ",1)
	q:DischDate="" ret
	s flg=##Class(web.DHCWMRQuality.BOACRExpBaseHis).GetDateTimeGap(DischDate,ElementData)
	s:flg<0 ret=-1
	q ret
}

/// ****************************************************************
/// 说明: 病案首页{诊断单元:主要诊断,次要诊断,院感诊断等}与病案首页{疾病转归}不一致
/// 结论: ret<0 不一致
/// 调试: w ##Class(web.DHCWMRQuality.BOACRExpBaseFun).IsUnify0007(EpisodeID,Element1,Element2,TemplateID)
/// ****************************************************************
ClassMethod IsUnify0007(EpisodeID As %String, Element1 As %String, Element2 As %String, TemplateID As %String) As %String
{
	n (EpisodeID,Element1,Element2,TemplateID)
	s ret=0
	q:(EpisodeID="")||(Element1="")||(Element2="") ret
	s CatName1=$list(Element1,1),ElName1=$list(Element1,2)
	s CatName2=$list(Element2,1),ElName2=$list(Element2,2)
	s flg1=##Class(web.DHCWMRQuality.BOACRExpBaseEpr).IsRightElNormName(EpisodeID,CatName1,ElName1,TemplateID)
	s flg2=##Class(web.DHCWMRQuality.BOACRExpBaseEpr).IsRightElNormName(EpisodeID,CatName2,ElName2,TemplateID)
	q:(flg1<1)||(flg2<1) ret
	s ElementData1=##Class(web.DHCWMRQuality.BOACRExpBaseEpr).GetElementDataByName(EpisodeID,CatName1,ElName1,"")
	s ElementData2=##Class(web.DHCWMRQuality.BOACRExpBaseEpr).GetElementDataByName(EpisodeID,CatName2,ElName2,"")
	s:ElementData1'="" ElementData1=$list(ElementData1,1)
	s:ElementData2'="" ElementData2=$list(ElementData2,1)
	q:(ElementData1="")&&(ElementData2="") ret
	s ElementData1=##Class(web.DHCWMRQuality.BOACRExpBaseHis).ClearUselessChar(ElementData1," /-")
	s ret=1
	i (ElementData1="")||(ElementData1="无")||(ElementData1="不详") d
	.s:ElementData2'="" ret=-1
	e  d
	.s:ElementData2="" ret=-1
	q ret
}

/// ****************************************************************
/// 说明: 病案首页{疾病转归}不一致
/// 结论: ret<0 不一致
/// 调试: w ##Class(web.DHCWMRQuality.BOACRExpBaseFun).IsUnify0008(EpisodeID,Element,TemplateID)
/// ****************************************************************
ClassMethod IsUnify0008(EpisodeID As %String, Element As %String, TemplateID As %String) As %String
{
	n (EpisodeID,Element,TemplateID)
	s ret=0
	q:(EpisodeID="")||(Element="") ret
	s CatName=$list(Element,1),ElNames=$list(Element,2)
	s Count=0,Count1=0,Count2=0
	f Ind=1:1:$listlength(ElNames) d
	.s ElName=$list(ElNames,Ind)
	.s flg=##Class(web.DHCWMRQuality.BOACRExpBaseEpr).IsRightElNormName(EpisodeID,CatName,ElName,TemplateID)
	.q:flg<0
	.s ElementData=##Class(web.DHCWMRQuality.BOACRExpBaseEpr).GetElementDataByName(EpisodeID,CatName,ElName,"")
	.s:ElementData'="" ElementData=$list(ElementData,1)
	.q:ElementData=""
	.s Count=Count+1
	.s:ElementData="死亡" Count1=Count1+1
	.s:ElementData'="死亡" Count2=Count2+1
	s DeathDateTime=""
	s IsLastAdm=##Class(web.DHCWMRQuality.BOACRExpBaseHis).IsLastAdm(EpisodeID,"")
	i IsLastAdm>0 d
	.s DeathDateTime=##Class(web.DHCWMRQuality.BOACRExpBaseHis).GetDeathDateTime(EpisodeID)
	s ret=1
	s:(Count1>0)&&(Count2>0) ret=-1
	//s:(DeathDateTime'="")&&(Count'=Count1) ret=-1
	//s:(DeathDateTime="")&&(Count'=Count2) ret=-1
	
	q ret
}

/// ****************************************************************
/// 说明: 病案首页{抢救次数}与病案首页{成功次数}不一致
/// 结论: ret<0 不一致
/// 调试: w ##Class(web.DHCWMRQuality.BOACRExpBaseFun).IsUnify0009(EpisodeID,Element1,Element2,TemplateID)
/// ****************************************************************
ClassMethod IsUnify0009(EpisodeID As %String, Element1 As %String, Element2 As %String, TemplateID As %String) As %String
{
	n (EpisodeID,Element1,Element2,TemplateID)
	s ret=0
	q:(EpisodeID="")||(Element1="")||(Element2="") ret
	s CatName1=$list(Element1,1),ElName1=$list(Element1,2)
	s CatName2=$list(Element2,1),ElName2=$list(Element2,2)
	s flg1=##Class(web.DHCWMRQuality.BOACRExpBaseEpr).IsRightElNormName(EpisodeID,CatName1,ElName1,TemplateID)
	s flg2=##Class(web.DHCWMRQuality.BOACRExpBaseEpr).IsRightElNormName(EpisodeID,CatName2,ElName2,TemplateID)
	q:(flg1<1)||(flg2<1) ret
	s ElementData1=##Class(web.DHCWMRQuality.BOACRExpBaseEpr).GetElementDataByName(EpisodeID,CatName1,ElName1,"")
	s ElementData2=##Class(web.DHCWMRQuality.BOACRExpBaseEpr).GetElementDataByName(EpisodeID,CatName2,ElName2,"")
	s:ElementData1'="" ElementData1=$list(ElementData1,1)
	s:ElementData2'="" ElementData2=$list(ElementData2,1)
	q:(ElementData1="")&&(ElementData2="") ret
	s ElementData1=$tr(ElementData1,"零","0")
	s ElementData2=$tr(ElementData2,"零","0")
	s ret=1
	s:(+ElementData1)<(+ElementData2) ret=-1
	q ret
}

/// ****************************************************************
/// 说明: 病案首页{术前与术后}与病案首页{手术名称1}不一致
/// 结论: ret<0 不一致
/// 调试: w ##Class(web.DHCWMRQuality.BOACRExpBaseFun).IsUnify0010(EpisodeID,Element1,Element2,TemplateID)
/// ****************************************************************
ClassMethod IsUnify0010(EpisodeID As %String, Element1 As %String, Element2 As %String, TemplateID As %String) As %String
{
	n (EpisodeID,Element1,Element2,TemplateID)
	s ret=0
	q:(EpisodeID="")||(Element1="")||(Element2="") ret
	s CatName1=$list(Element1,1),ElName1=$list(Element1,2)
	s CatName2=$list(Element2,1),ElName2=$list(Element2,2)
	s flg1=##Class(web.DHCWMRQuality.BOACRExpBaseEpr).IsRightElNormName(EpisodeID,CatName1,ElName1,TemplateID)
	s flg2=##Class(web.DHCWMRQuality.BOACRExpBaseEpr).IsRightElNormName(EpisodeID,CatName2,ElName2,TemplateID)
	q:(flg1<1)||(flg2<1) ret
	s ElementData1=##Class(web.DHCWMRQuality.BOACRExpBaseEpr).GetElementDataByName(EpisodeID,CatName1,ElName1,"")
	s ElementData2=##Class(web.DHCWMRQuality.BOACRExpBaseEpr).GetElementDataByName(EpisodeID,CatName2,ElName2,"")
	s:ElementData1'="" ElementData1=$list(ElementData1,1)
	s:ElementData2'="" ElementData2=$list(ElementData2,1)
	q:(ElementData1="")&&(ElementData2="") ret
	s ElementData2=##Class(web.DHCWMRQuality.BOACRExpBaseHis).ClearUselessChar(ElementData2," /-")
	s ret=1
	i (ElementData2="无")||(ElementData2="不详")||(ElementData2="") d
	.s:ElementData1'="未做" ret=-1
	e  d
	.s:ElementData1="未做" ret=-1
	q ret
}

/// ****************************************************************
/// 说明: 病案首页{疾病转归:主诊断疾病转归}与病案首页{尸检:尸检}不一致
/// 结论: ret<0 不一致
/// 调试: w ##Class(web.DHCWMRQuality.BOACRExpBaseFun).IsUnify0011(EpisodeID,Element1,Element2,TemplateID)
/// ****************************************************************
ClassMethod IsUnify0011(EpisodeID As %String, Element1 As %String, Element2 As %String, TemplateID As %String) As %String
{
	n (EpisodeID,Element1,Element2,TemplateID)
	s ret=0
	q:(EpisodeID="")||(Element1="")||(Element2="") ret
	s CatName1=$list(Element1,1),ElName1=$list(Element1,2)
	s CatName2=$list(Element2,1),ElName2=$list(Element2,2)
	s flg1=##Class(web.DHCWMRQuality.BOACRExpBaseEpr).IsRightElNormName(EpisodeID,CatName1,ElName1,TemplateID)
	s flg2=##Class(web.DHCWMRQuality.BOACRExpBaseEpr).IsRightElNormName(EpisodeID,CatName2,ElName2,TemplateID)
	q:(flg1<1)||(flg2<1) ret
	s ElementData1=##Class(web.DHCWMRQuality.BOACRExpBaseEpr).GetElementDataByName(EpisodeID,CatName1,ElName1,"")
	s ElementData2=##Class(web.DHCWMRQuality.BOACRExpBaseEpr).GetElementDataByName(EpisodeID,CatName2,ElName2,"")
	s:ElementData1'="" ElementData1=$list(ElementData1,1)
	s:ElementData2'="" ElementData2=$list(ElementData2,1)
	q:(ElementData1="")&&(ElementData2="") ret
	s ret=1
	i ElementData1="死亡" d
	.s:(ElementData2'="是")&&(ElementData2'="否") ret=-1
	e  d
	.s:(ElementData2="是")||(ElementData2="否") ret=-1
	q ret
}

/// ****************************************************************
/// 说明: 病案首页{是否随诊}与病案首页{随诊期限}不一致
/// 结论: ret<0 不一致
/// 调试: w ##Class(web.DHCWMRQuality.BOACRExpBaseFun).IsUnify0012(EpisodeID,Element1,Element2,TemplateID)
/// ****************************************************************
ClassMethod IsUnify0012(EpisodeID As %String, Element1 As %String, Element2 As %String, TemplateID As %String) As %String
{
	n (EpisodeID,Element1,Element2,TemplateID)
	s ret=0
	q:(EpisodeID="")||(Element1="")||(Element2="") ret
	s CatName1=$list(Element1,1),ElName1=$list(Element1,2)
	s CatName2=$list(Element2,1),ElNames2=$list(Element2,2)
	s flg1=##Class(web.DHCWMRQuality.BOACRExpBaseEpr).IsRightElNormName(EpisodeID,CatName1,ElName1,TemplateID)
	q:flg1<1 ret
	s ElementData1=##Class(web.DHCWMRQuality.BOACRExpBaseEpr).GetElementDataByName(EpisodeID,CatName1,ElName1,"")
	s ElementData2=""
	f Ind=1:1:$listlength(ElNames2) d
	.s ElName2=$list(ElNames2,Ind)
	.s flg2=##Class(web.DHCWMRQuality.BOACRExpBaseEpr).IsRightElNormName(EpisodeID,CatName2,ElName2,TemplateID)
	.q:flg2<1
	.s tmp=##Class(web.DHCWMRQuality.BOACRExpBaseEpr).GetElementDataByName(EpisodeID,CatName2,ElName2,"")
	.s:tmp'="" tmp=$list(tmp,1)
	.q:(+tmp)'>0
	.s ElementData2=ElementData2_$lb(tmp)
	s:ElementData1'="" ElementData1=$list(ElementData1,1)
	q:(ElementData1="")&&(ElementData2="") ret
	s ret=1
	i ElementData1="是" d
	.s:$listlength(ElementData2)'>0 ret=-1
	e  d
	.s:$listlength(ElementData2)>0 ret=-1
	q ret
}

/// ****************************************************************
/// 说明: 病案首页{手术信息S:手术名称1,手术日期,术者,1助等}不一致
/// 结论: ret<0 不一致
/// 调试: w ##Class(web.DHCWMRQuality.BOACRExpBaseFun).IsUnify0013(EpisodeID,Element,TemplateID)
/// ****************************************************************
ClassMethod IsUnify0013(EpisodeID As %String, Element As %String, TemplateID As %String) As %String
{
	n (EpisodeID,Element,TemplateID)
	s ret=0
	q:(EpisodeID="")||(Element="") ret
	s CatName=$list(Element,1),ElNames=$list(Element,2)
	s ElementData="",Count=0
	f Ind=1:1:$listlength(ElNames) d
	.s ElName=$list(ElNames,Ind)
	.s flg=##Class(web.DHCWMRQuality.BOACRExpBaseEpr).IsRightElNormName(EpisodeID,CatName,ElName,TemplateID)
	.q:flg<1
	.s Count=Count+1
	.s tmp=##Class(web.DHCWMRQuality.BOACRExpBaseEpr).GetElementDataByName(EpisodeID,CatName,ElName,"")
	.s:tmp'="" tmp=$list(tmp,1)
	.s:tmp'="" tmp=##Class(web.DHCWMRQuality.BOACRExpBaseHis).ClearUselessChar(tmp," /-")
	.q:(tmp="")||(tmp="无")||(tmp="不详")
	.s ElementData=ElementData_$lb(tmp)
	s ret=1
	s:($listlength(ElementData)'=Count)&&(ElementData'="") ret=-1
	q ret
}

/// ****************************************************************
/// 说明: 患者未出院,不允许打印{病历内容:病案首页,出院记录,死亡记录等}
/// 结论: ret<0 不一致
/// 调试: w ##Class(web.DHCWMRQuality.BOACRExpBaseFun).IsUnify0014(EpisodeID,Content,TemplateID)
/// ****************************************************************
ClassMethod IsUnify0014(EpisodeID As %String, Content As %String, TemplateID As %String) As %String
{
	n (EpisodeID,Content,TemplateID)
	s ret=0
	q:(EpisodeID="")||(Content="") ret
	s tmpTemplate=##Class(web.DHCWMRQuality.BOACRExpBaseConfig).GetEPRTemIdListByCont(Content)
	q:tmpTemplate="" ret
	s ret=1,tmpID=""
	s:TemplateID'="" tmpID=$list(TemplateID,1)
	q:(tmpID'="")&&($listfind(tmpTemplate,tmpID)=0) ret
	s DischDateTime=##Class(web.DHCWMRQuality.BOACRExpBaseHis).GetDischDateTime(EpisodeID)
	s:DischDateTime="" ret=-1
	q ret
}

/// ****************************************************************
/// *********************START 华西医院 20090614********************
/// ****************************************************************
/// 
/// ****************************************************************
/// 说明: 病案首页{死亡时间}与HIS{死亡时间}不一致
///     : 死亡记录{死亡时间}与HIS{死亡时间}不一致
///     : 24小时入院死亡记录{死亡时间}与HIS{死亡时间}不一致
/// 注释: 两时间格式"2009-05-23 16:02:00",精确到小时,两时间相同
/// 结论: ret<0 不一致
/// 调试: w ##Class(web.DHCWMRQuality.BOACRExpBaseFun).IsUnify0015(EpisodeID,Element,TemplateID)
/// ****************************************************************
ClassMethod IsUnify0015(EpisodeID As %String, Element As %String, TemplateID As %String) As %String
{
	n (EpisodeID,Element,TemplateID)
	s ret=0
	q:(EpisodeID="")||(Element="") ret
	s CatName=$list(Element,1),ElName=$list(Element,2)
	s flg=##Class(web.DHCWMRQuality.BOACRExpBaseEpr).IsRightElNormName(EpisodeID,CatName,ElName,TemplateID)
	q:flg<1 ret
	s ElementData=##Class(web.DHCWMRQuality.BOACRExpBaseEpr).GetElementDataByName(EpisodeID,CatName,ElName,"")
	s:ElementData'="" ElementData=$list(ElementData,1)
	q:ElementData="" ret
	s ElementData=##Class(web.DHCWMRQuality.BOACRExpBaseHis).ChangeDateTime(ElementData)
	s DeathTime=##Class(web.DHCWMRQuality.BOACRExpBaseHis).GetDeathDateTime(EpisodeID)
	s DeathTime=##Class(web.DHCWMRQuality.BOACRExpBaseHis).ChangeDateTime(DeathTime)
	s ret=1
	i DeathTime'="" d
	.s:$p(ElementData," ",1)'=$p(DeathTime," ",1) ret=-1
	.s:$p($p(ElementData," ",2),":",1)'=$p($p(DeathTime," ",2),":",1) ret=-1
	.//s:$p($p(ElementData," ",2),":",2)'=$p($p(DeathTime," ",2),":",2) ret=-1
	e  d
	.s:ElementData'="" ret=-1
	q ret
}

/// ****************************************************************
/// 说明: 病案首页{是否转科}与{转科科别}不一致
/// 结论: ret<0 不一致
/// 调试: w ##Class(web.DHCWMRQuality.BOACRExpBaseFun).IsUnify0016(EpisodeID,Element1,Element2,TemplateID)
/// ****************************************************************
ClassMethod IsUnify0016(EpisodeID As %String, Element1 As %String, Element2 As %String, TemplateID As %String) As %String
{
	n (EpisodeID,Element1,Element2,TemplateID)
	s ret=0
	q:(EpisodeID="")||(Element1="")||(Element2="") ret
	s CatName1=$list(Element1,1),ElName1=$list(Element1,2)
	s CatName2=$list(Element2,1),ElName2=$list(Element2,2)
	s flg1=##Class(web.DHCWMRQuality.BOACRExpBaseEpr).IsRightElNormName(EpisodeID,CatName1,ElName1,TemplateID)
	s flg2=##Class(web.DHCWMRQuality.BOACRExpBaseEpr).IsRightElNormName(EpisodeID,CatName2,ElName2,TemplateID)
	q:(flg1<1)||(flg2<1) ret
	s ElementData1=##Class(web.DHCWMRQuality.BOACRExpBaseEpr).GetElementDataByName(EpisodeID,CatName1,ElName1,"")
	s ElementData2=##Class(web.DHCWMRQuality.BOACRExpBaseEpr).GetElementDataByName(EpisodeID,CatName2,ElName2,"")
	s:ElementData1'="" ElementData1=$list(ElementData1,1)
	s:ElementData2'="" ElementData2=$list(ElementData2,1)
	q:(ElementData1="")&&(ElementData2="") ret
	s ElementData1=##Class(web.DHCWMRQuality.BOACRExpBaseHis).ClearUselessChar(ElementData1," -/")
	s ElementData2=##Class(web.DHCWMRQuality.BOACRExpBaseHis).ClearUselessChar(ElementData2," -/")
	s ret=1
	i ElementData1="是" d
	.s:(ElementData2="")||(ElementData2="无")||(ElementData2="不详") ret=-1
	e  d
	.s:(ElementData2'="")&&(ElementData2'="无")&&(ElementData2'="不详") ret=-1
	q ret
}

/// ****************************************************************
/// 说明: 病案首页{是否院内感染}与{感染诊断}不一致
/// 结论: ret<0 不一致
/// 调试: w ##Class(web.DHCWMRQuality.BOACRExpBaseFun).IsUnify0017(EpisodeID,Element1,Element2,TemplateID)
/// ****************************************************************
ClassMethod IsUnify0017(EpisodeID As %String, Element1 As %String, Element2 As %String, TemplateID As %String) As %String
{
	n (EpisodeID,Element1,Element2,TemplateID)
	s ret=0
	q:(EpisodeID="")||(Element1="")||(Element2="") ret
	s CatName1=$list(Element1,1),ElName1=$list(Element1,2)
	s CatName2=$list(Element2,1),ElName2=$list(Element2,2)
	s flg1=##Class(web.DHCWMRQuality.BOACRExpBaseEpr).IsRightElNormName(EpisodeID,CatName1,ElName1,TemplateID)
	s flg2=##Class(web.DHCWMRQuality.BOACRExpBaseEpr).IsRightElNormName(EpisodeID,CatName2,ElName2,TemplateID)
	q:(flg1<1)||(flg2<1) ret
	s ElementData1=##Class(web.DHCWMRQuality.BOACRExpBaseEpr).GetElementDataByName(EpisodeID,CatName1,ElName1,"")
	s ElementData2=##Class(web.DHCWMRQuality.BOACRExpBaseEpr).GetElementDataByName(EpisodeID,CatName2,ElName2,"")
	s:ElementData1'="" ElementData1=$list(ElementData1,1)
	s:ElementData2'="" ElementData2=$list(ElementData2,1)
	q:(ElementData1="")&&(ElementData2="") ret
	s ElementData2=##Class(web.DHCWMRQuality.BOACRExpBaseHis).ClearUselessChar(ElementData2," -/")
	s ret=1
	i (ElementData1="是")||(ElementData1="有") d
	.s:(ElementData2="")||(ElementData2="无")||(ElementData2="不详") ret=-1
	e  d
	.s:(ElementData2'="")&&(ElementData2'="无")&&(ElementData2'="不详") ret=-1
	q ret
}

/// ****************************************************************
/// 说明: 病案首页{血型}与HIS{血型}不一致
/// 结论: ret<0 不一致
/// 调试: w ##Class(web.DHCWMRQuality.BOACRExpBaseFun).IsUnify0018(EpisodeID,Element,TemplateID)
/// ****************************************************************
ClassMethod IsUnify0018(EpisodeID As %String, Element As %String, TemplateID As %String) As %String
{
	n (EpisodeID,Element,TemplateID)
	s ret=0
	q:(EpisodeID="")||(Element="") ret
	s CatName=$list(Element,1),ElName=$list(Element,2)
	s flg=##Class(web.DHCWMRQuality.BOACRExpBaseEpr).IsRightElNormName(EpisodeID,CatName,ElName,TemplateID)
	q:flg<1 ret
	s ElementData=##Class(web.DHCWMRQuality.BOACRExpBaseEpr).GetElementDataByName(EpisodeID,CatName,ElName,"")
	s:ElementData'="" ElementData=$list(ElementData,1)
	s HISData=##Class(web.DHCWMRQuality.BOACRExpBaseHis).GetBloodGroup(EpisodeID)
	s ElementData=$tr(ElementData,"型",""),HISData=$tr(HISData,"型","")
	s ElementData=$$ALPHAUP^SSUTIL4(ElementData),HISData=$$ALPHAUP^SSUTIL4(HISData)
	s ret=1
	i (HISData="A")||(HISData="B")||(HISData="AB")||(HISData="O") d
	.s:ElementData'=HISData ret=-1
	e  d
	.s:(ElementData'="未查")&&(ElementData'="其他")&&(ElementData'="") ret=-1
	q ret
}

/// ****************************************************************
/// 说明: 病案首页{抢救次数}与HIS{抢救次数}不一致
/// 结论: ret<0 不一致
/// 调试: w ##Class(web.DHCWMRQuality.BOACRExpBaseFun).IsUnify0019(EpisodeID,Element,TemplateID)
/// ****************************************************************
ClassMethod IsUnify0019(EpisodeID As %String, Element As %String, TemplateID As %String) As %String
{
	n (EpisodeID,Element,TemplateID)
	s ret=0
	q:(EpisodeID="")||(Element="") ret
	s CatName=$list(Element,1),ElName=$list(Element,2)
	s flg=##Class(web.DHCWMRQuality.BOACRExpBaseEpr).IsRightElNormName(EpisodeID,CatName,ElName,TemplateID)
	q:flg<1 ret
	s ElementData=##Class(web.DHCWMRQuality.BOACRExpBaseEpr).GetElementDataByName(EpisodeID,CatName,ElName,"")
	s:ElementData'="" ElementData=$list(ElementData,1)
	s HISData=##Class(web.DHCWMRQuality.BOACRExpBaseHis).GetSaveTimes(EpisodeID)
	s ElementData=##Class(web.DHCWMRQuality.BOACRExpBaseHis).ClearUselessChar(ElementData," -/")
	s ElementData=$tr(ElementData,"零","0")
	s ret=1
	i (+HISData)=0 d
	.s:(ElementData'=0)&&(ElementData'="")&&(ElementData'="无") ret=-1
	e  d
	.s:ElementData'=HISData ret=-1
	q ret
}

/// ****************************************************************
/// 说明: 病案首页{红细胞输血量}与HIS{红细胞输血量}不一致
/// 结论: ret<0 不一致
/// 调试: w ##Class(web.DHCWMRQuality.BOACRExpBaseFun).IsUnify0020(EpisodeID,Element,TemplateID)
/// ****************************************************************
ClassMethod IsUnify0020(EpisodeID As %String, Element As %String, TemplateID As %String) As %String
{
	n (EpisodeID,Element,TemplateID)
	s ret=0
	q:(EpisodeID="")||(Element="") ret
	s CatName=$list(Element,1),ElName=$list(Element,2)
	s flg=##Class(web.DHCWMRQuality.BOACRExpBaseEpr).IsRightElNormName(EpisodeID,CatName,ElName,TemplateID)
	q:flg<1 ret
	s ElementData=##Class(web.DHCWMRQuality.BOACRExpBaseEpr).GetElementDataByName(EpisodeID,CatName,ElName,"")
	s:ElementData'="" ElementData=$list(ElementData,1)
	s ElementData=##Class(web.DHCWMRQuality.BOACRExpBaseHis).ClearUselessChar(ElementData," -/")
	s HISData=##Class(web.DHCWMRQuality.BOACRExpBaseHis).GetRBCTransfuse(EpisodeID)
	s ret=1
	i (+HISData)=0 d
	.s:(ElementData'=0)&&(ElementData'="")&&(ElementData'="无") ret=-1
	e  d
	.s:ElementData'=HISData ret=-1
	q ret
}

/// ****************************************************************
/// 说明: 病案首页{血小板输血量}与HIS{血小板输血量}不一致
/// 结论: ret<0 不一致
/// 调试: w ##Class(web.DHCWMRQuality.BOACRExpBaseFun).IsUnify0021(EpisodeID,Element,TemplateID)
/// ****************************************************************
ClassMethod IsUnify0021(EpisodeID As %String, Element As %String, TemplateID As %String) As %String
{
	n (EpisodeID,Element,TemplateID)
	s ret=0
	q:(EpisodeID="")||(Element="") ret
	s CatName=$list(Element,1),ElName=$list(Element,2)
	s flg=##Class(web.DHCWMRQuality.BOACRExpBaseEpr).IsRightElNormName(EpisodeID,CatName,ElName,TemplateID)
	q:flg<1 ret
	s ElementData=##Class(web.DHCWMRQuality.BOACRExpBaseEpr).GetElementDataByName(EpisodeID,CatName,ElName,"")
	s:ElementData'="" ElementData=$list(ElementData,1)
	s ElementData=##Class(web.DHCWMRQuality.BOACRExpBaseHis).ClearUselessChar(ElementData," -/")
	s HISData=##Class(web.DHCWMRQuality.BOACRExpBaseHis).GetPlateletTransfuse(EpisodeID)
	s ret=1
	i (+HISData)=0 d
	.s:(ElementData'=0)&&(ElementData'="")&&(ElementData'="无") ret=-1
	e  d
	.s:ElementData'=HISData ret=-1
	q ret
}

/// ****************************************************************
/// 说明: 病案首页{血浆输血量}与HIS{血浆输血量}不一致
/// 结论: ret<0 不一致
/// 调试: w ##Class(web.DHCWMRQuality.BOACRExpBaseFun).IsUnify0022(EpisodeID,Element,TemplateID)
/// ****************************************************************
ClassMethod IsUnify0022(EpisodeID As %String, Element As %String, TemplateID As %String) As %String
{
	n (EpisodeID,Element,TemplateID)
	s ret=0
	q:(EpisodeID="")||(Element="") ret
	s CatName=$list(Element,1),ElName=$list(Element,2)
	s flg=##Class(web.DHCWMRQuality.BOACRExpBaseEpr).IsRightElNormName(EpisodeID,CatName,ElName,TemplateID)
	q:flg<1 ret
	s ElementData=##Class(web.DHCWMRQuality.BOACRExpBaseEpr).GetElementDataByName(EpisodeID,CatName,ElName,"")
	s:ElementData'="" ElementData=$list(ElementData,1)
	s ElementData=##Class(web.DHCWMRQuality.BOACRExpBaseHis).ClearUselessChar(ElementData," -/")
	s HISData=##Class(web.DHCWMRQuality.BOACRExpBaseHis).GetPlasmaTransfuse(EpisodeID)
	s ret=1
	i (+HISData)=0 d
	.s:(ElementData'=0)&&(ElementData'="")&&(ElementData'="无") ret=-1
	e  d
	.s:ElementData'=HISData ret=-1
	q ret
}

/// ****************************************************************
/// 说明: 病案首页{全血输血量}与HIS{全血输血量}不一致
/// 结论: ret<0 不一致
/// 调试: w ##Class(web.DHCWMRQuality.BOACRExpBaseFun).IsUnify0023(EpisodeID,Element,TemplateID)
/// ****************************************************************
ClassMethod IsUnify0023(EpisodeID As %String, Element As %String, TemplateID As %String) As %String
{
	n (EpisodeID,Element,TemplateID)
	s ret=0
	q:(EpisodeID="")||(Element="") ret
	s CatName=$list(Element,1),ElName=$list(Element,2)
	s flg=##Class(web.DHCWMRQuality.BOACRExpBaseEpr).IsRightElNormName(EpisodeID,CatName,ElName,TemplateID)
	q:flg<1 ret
	s ElementData=##Class(web.DHCWMRQuality.BOACRExpBaseEpr).GetElementDataByName(EpisodeID,CatName,ElName,"")
	s:ElementData'="" ElementData=$list(ElementData,1)
	s ElementData=##Class(web.DHCWMRQuality.BOACRExpBaseHis).ClearUselessChar(ElementData," -/")
	s HISData=##Class(web.DHCWMRQuality.BOACRExpBaseHis).GetWholeBloodTransfuse(EpisodeID)
	s ret=1
	i (+HISData)=0 d
	.s:(ElementData'=0)&&(ElementData'="")&&(ElementData'="无") ret=-1
	e  d
	.s:ElementData'=HISData ret=-1
	q ret
}

/// ****************************************************************
/// 说明: 病案首页{其它输血量}与HIS{其它输血量}不一致
/// 结论: ret<0 不一致
/// 调试: w ##Class(web.DHCWMRQuality.BOACRExpBaseFun).IsUnify0024(EpisodeID,Element,TemplateID)
/// ****************************************************************
ClassMethod IsUnify0024(EpisodeID As %String, Element As %String, TemplateID As %String) As %String
{
	n (EpisodeID,Element,TemplateID)
	s ret=0
	q:(EpisodeID="")||(Element="") ret
	s CatName=$list(Element,1),ElName=$list(Element,2)
	s flg=##Class(web.DHCWMRQuality.BOACRExpBaseEpr).IsRightElNormName(EpisodeID,CatName,ElName,TemplateID)
	q:flg<1 ret
	s ElementData=##Class(web.DHCWMRQuality.BOACRExpBaseEpr).GetElementDataByName(EpisodeID,CatName,ElName,"")
	s:ElementData'="" ElementData=$list(ElementData,1)
	s ElementData=##Class(web.DHCWMRQuality.BOACRExpBaseHis).ClearUselessChar(ElementData," -/")
	s HISData=##Class(web.DHCWMRQuality.BOACRExpBaseHis).GetOtherTransfuse(EpisodeID)
	s ret=1
	i (+HISData)=0 d
	.s:(ElementData'=0)&&(ElementData'="")&&(ElementData'="无") ret=-1
	e  d
	.s:ElementData'=HISData ret=-1
	q ret
}

/// ****************************************************************
/// 注释：###此方法有待考虑###
/// 说明: 病案首页{是否法定传染病}与病案首页{传染病是否上报}不一致
/// 结论: ret<0 不一致
/// 调试: w ##Class(web.DHCWMRQuality.BOACRExpBaseFun).IsUnify0025(EpisodeID,Element1,Element2,TemplateID)
/// ****************************************************************
ClassMethod IsUnify0025(EpisodeID As %String, Element1 As %String, Element2 As %String, TemplateID As %String) As %String
{
	n (EpisodeID,Element1,Element2,TemplateID)
	s ret=0
	q:(EpisodeID="")||(Element1="")||(Element2="") ret
	s CatName1=$list(Element1,1),ElName1=$list(Element1,2)
	s CatName2=$list(Element2,1),ElName2=$list(Element2,2)
	s flg1=##Class(web.DHCWMRQuality.BOACRExpBaseEpr).IsRightElNormName(EpisodeID,CatName1,ElName1,TemplateID)
	s flg2=##Class(web.DHCWMRQuality.BOACRExpBaseEpr).IsRightElNormName(EpisodeID,CatName2,ElName2,TemplateID)
	q:(flg1<1)||(flg2<1) ret
	s ElementData1=##Class(web.DHCWMRQuality.BOACRExpBaseEpr).GetElementDataByName(EpisodeID,CatName1,ElName1,"")
	s ElementData2=##Class(web.DHCWMRQuality.BOACRExpBaseEpr).GetElementDataByName(EpisodeID,CatName2,ElName2,"")
	q:(ElementData1="")&&(ElementData2="") ret
	s:ElementData1'="" ElementData1=$list(ElementData1,1)
	s:ElementData2'="" ElementData2=$list(ElementData2,1)
	s ret=1
	i ElementData1="是" d
	.s:(ElementData2="")||(ElementData2="否") ret=-1
	e  d
	.s:(ElementData2'="")&&(ElementData2'="否") ret=-1
	q ret
}

/// ****************************************************************
/// 注释：###此方法有待考虑### 修正诊断很难在入院24小时内完成
/// 说明: 病案首页{入院诊断}与{修正诊断}不一致
///     : 入院诊断中有“待诊”，“待查”，“？”、修正诊断内容不能为空
/// 结论: ret<0 不一致
/// 调试: w ##Class(web.DHCWMRQuality.BOACRExpBaseFun).IsUnify0026(EpisodeID,Element1,Element2,TemplateID)
/// ****************************************************************
ClassMethod IsUnify0026(EpisodeID As %String, Element1 As %String, Element2 As %String, TemplateID As %String) As %String
{
	n (EpisodeID,Element1,Element2,TemplateID)
	s ret=0
	q:(EpisodeID="")||(Element1="")||(Element2="") ret
	s CatName1=$list(Element1,1),ElName1=$list(Element1,2)
	s CatName2=$list(Element2,1),ElName2=$list(Element2,2)
	s flg1=##Class(web.DHCWMRQuality.BOACRExpBaseEpr).IsRightElNormName(EpisodeID,CatName1,ElName1,TemplateID)
	s flg2=##Class(web.DHCWMRQuality.BOACRExpBaseEpr).IsRightElNormName(EpisodeID,CatName2,ElName2,TemplateID)
	q:(flg1<1)||(flg2<1) ret
	s ElementData1=##Class(web.DHCWMRQuality.BOACRExpBaseEpr).GetElementDataByName(EpisodeID,CatName1,ElName1,"")
	s ElementData2=##Class(web.DHCWMRQuality.BOACRExpBaseEpr).GetElementDataByName(EpisodeID,CatName2,ElName2,"")
	q:(ElementData1="")&&(ElementData2="") ret
	s:ElementData1'="" ElementData1=$list(ElementData1,1)
	s:ElementData2'="" ElementData2=$list(ElementData2,1)
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
/// 调试: w ##Class(web.DHCWMRQuality.BOACRExpBaseFun).IsUnify0027(EpisodeID,Element1,Element2,TemplateID)
/// ****************************************************************
ClassMethod IsUnify0027(EpisodeID As %String, Element1 As %String, Element2 As %String, TemplateID As %String) As %String
{
	n (EpisodeID,Element1,Element2,TemplateID)
	s ret=0
	q:(EpisodeID="")||(Element1="")||(Element2="") ret
	s CatName1=$list(Element1,1),ElName1=$list(Element1,2)
	s CatName2=$list(Element2,1),ElName2=$list(Element2,2)
	s flg1=##Class(web.DHCWMRQuality.BOACRExpBaseEpr).IsRightElNormName(EpisodeID,CatName1,ElName1,TemplateID)
	s flg2=##Class(web.DHCWMRQuality.BOACRExpBaseEpr).IsRightElNormName(EpisodeID,CatName2,ElName2,TemplateID)
	q:(flg1<1)||(flg2<1) ret
	s ElementData1=##Class(web.DHCWMRQuality.BOACRExpBaseEpr).GetElementDataByName(EpisodeID,CatName1,ElName1,"")
	s ElementData2=##Class(web.DHCWMRQuality.BOACRExpBaseEpr).GetElementDataByName(EpisodeID,CatName2,ElName2,"")
	q:(ElementData1="")&&(ElementData2="") ret
	s:ElementData1'="" ElementData1=$tr($list(ElementData1,1)," ","")
	s:ElementData2'="" ElementData2=$tr($list(ElementData2,1)," ","")
	s ret=1
	i (ElementData1'="")&&(ElementData1'="无")&&(ElementData1'="不详") d
	.s:(ElementData2="")||(ElementData2="无")||(ElementData2="不详") ret=-1
	q ret
}

/// ****************************************************************
/// 说明: 抢救记录{日期时间LIST}与HIS{死亡时间}
///     : 死亡病人抢救记录未在抢救结束(死亡时间)后4小时内完成;
/// 结论: ret<0 不一致
/// 调试: w ##Class(web.DHCWMRQuality.BOACRExpBaseFun).IsUnify0028(EpisodeID,CatName,TemplateID)
/// ****************************************************************
ClassMethod IsUnify0028(EpisodeID As %String, CatName As %String, TemplateID As %String) As %String
{
	n (EpisodeID,CatName,TemplateID)
	s ret=0
	q:(EpisodeID="")||(CatName="") ret
	s CatName=$list(CatName,1)
	s flg=##Class(web.DHCWMRQuality.BOACRExpBaseEpr).IsRightCatNormName(EpisodeID,CatName,TemplateID)
	q:flg<1 ret
	s HISData=##Class(web.DHCWMRQuality.BOACRExpBaseHis).GetDeathDateTime(EpisodeID)
	q:HISData="" ret
	s ElementDatas=##Class(web.DHCWMRQuality.BOACRExpEprMulti).GetMultiTemHaDateTime(EpisodeID,CatName,"","","","","05009")
	s ret=1,flg=0
	f Ind=1:1:$listlength(ElementDatas) d
	.s ElementData=$list(ElementDatas,Ind)
	.s TimeGap=##Class(web.DHCWMRQuality.BOACRExpBaseHis).GetDateTimeGap(ElementData,HISData)
	.s:(TimeGap'<0)&&(TimeGap'>4) flg=1
	s:flg=0 ret=-1
	s:ElementDatas="" ret=-1
	q ret
}

/// ****************************************************************
/// 说明: 交班记录后24小时内未完成接班记录
/// 结论: ret<0 不一致
/// 调试: w ##Class(web.DHCWMRQuality.BOACRExpBaseFun).IsUnify0029(EpisodeID,CatName,TemplateID)
/// ****************************************************************
ClassMethod IsUnify0029(EpisodeID As %String, CatName As %String, TemplateID As %String) As %String
{
	n (EpisodeID,CatName,TemplateID)
	s ret=0
	q:(EpisodeID="")||(CatName="") ret
	s CatName=$list(CatName,1)
	s flg=##Class(web.DHCWMRQuality.BOACRExpBaseEpr).IsRightCatNormName(EpisodeID,CatName,TemplateID)
	q:flg<1 ret
	s ElementDatas1=##Class(web.DHCWMRQuality.BOACRExpEprMulti).GetMultiTemHaDateTime(EpisodeID,CatName,"","","","","05003")
	q:ElementDatas1="" ret
	s ElementDatas2=##Class(web.DHCWMRQuality.BOACRExpEprMulti).GetMultiTemHaDateTime(EpisodeID,CatName,"","","","","05004")
	s ret=1
	s CurrDateTime=$zd(+$h,3)_" "_$zt($p($h,",",2),2)
	f Ind=1:1:$listlength(ElementDatas1) d
	.s ElementData1=$list(ElementDatas1,Ind)
	.s ElementData2=$s((Ind>$listlength(ElementDatas2)):CurrDateTime,1:$list(ElementDatas2,Ind))
	.s tmpTimeGap=##Class(web.DHCWMRQuality.BOACRExpBaseHis).GetDateTimeGap(ElementData2,ElementData1)
	.q:(tmpTimeGap'>24)
	.s ret=-1
	q ret
}

/// ****************************************************************
/// 说明: 转科记录后24小时内未完成接收记录
/// 结论: ret<0 不一致
/// 调试: w ##Class(web.DHCWMRQuality.BOACRExpBaseFun).IsUnify0030(EpisodeID,CatName,TemplateID)
/// ****************************************************************
ClassMethod IsUnify0030(EpisodeID As %String, CatName As %String, TemplateID As %String) As %String
{
	n (EpisodeID,CatName,TemplateID)
	s ret=0
	q:(EpisodeID="")||(CatName="") ret
	s CatName=$list(CatName,1)
	s flg=##Class(web.DHCWMRQuality.BOACRExpBaseEpr).IsRightCatNormName(EpisodeID,CatName,TemplateID)
	q:flg<1 ret
	s ElementDatas1=##Class(web.DHCWMRQuality.BOACRExpEprMulti).GetMultiTemHaDateTime(EpisodeID,CatName,"","","","","05005")
	q:ElementDatas1="" ret
	s ElementDatas2=##Class(web.DHCWMRQuality.BOACRExpEprMulti).GetMultiTemHaDateTime(EpisodeID,CatName,"","","","","05006")
	s ret=1
	s CurrDateTime=$zd(+$h,3)_" "_$zt($p($h,",",2),2)
	f Ind=1:1:$listlength(ElementDatas1) d
	.s ElementData1=$list(ElementDatas1,Ind)
	.s ElementData2=$s((Ind>$listlength(ElementDatas2)):CurrDateTime,1:$list(ElementDatas2,Ind))
	.s tmpTimeGap=##Class(web.DHCWMRQuality.BOACRExpBaseHis).GetDateTimeGap(ElementData2,ElementData1)
	.q:(tmpTimeGap'>24)
	.s ret=-1
	q ret
}

/// ****************************************************************
/// 说明: 请会诊记录后24小时未完成会诊记录
/// 结论: ret<0 不一致
/// 调试: w ##Class(web.DHCWMRQuality.BOACRExpBaseFun).IsUnify0031(EpisodeID,CatName,TemplateID)
/// ****************************************************************
ClassMethod IsUnify0031(EpisodeID As %String, CatName As %String, TemplateID As %String) As %String
{
	n (EpisodeID,CatName,TemplateID)
	s ret=0
	q:(EpisodeID="")||(CatName="") ret
	s CatName=$list(CatName,1)
	s flg=##Class(web.DHCWMRQuality.BOACRExpBaseEpr).IsRightCatNormName(EpisodeID,CatName,TemplateID)
	q:flg<1 ret
	s ElementDatas1=##Class(web.DHCWMRQuality.BOACRExpEprMulti).GetMultiTemHaDateTime(EpisodeID,CatName,"","","","","05010")
	q:ElementDatas1="" ret
	s ElementDatas2=##Class(web.DHCWMRQuality.BOACRExpEprMulti).GetMultiTemHaDateTime(EpisodeID,CatName,"","","","","05011")
	s ret=1
	s CurrDateTime=$zd(+$h,3)_" "_$zt($p($h,",",2),2)
	f Ind=1:1:$listlength(ElementDatas1) d
	.s ElementData1=$list(ElementDatas1,Ind)
	.s ElementData2=$s((Ind>$listlength(ElementDatas2)):CurrDateTime,1:$list(ElementDatas2,Ind))
	.s tmpTimeGap=##Class(web.DHCWMRQuality.BOACRExpBaseHis).GetDateTimeGap(ElementData2,ElementData1)
	.q:(tmpTimeGap'>24)
	.s ret=-1
	q ret
}

/// ****************************************************************
/// 说明: 缺少每天至少一次的病程记录
/// 结论: ret<0 不一致
/// 调试: w ##Class(web.DHCWMRQuality.BOACRExpBaseFun).IsUnify0032(EpisodeID,CatName,TemplateID)
/// ****************************************************************
ClassMethod IsUnify0032(EpisodeID As %String, CatName As %String, TemplateID As %String) As %String
{
	n (EpisodeID,CatName,TemplateID)
	s ret=0
	q:(EpisodeID="")||(CatName="") ret
	s CatName=$list(CatName,1)
	s flg=##Class(web.DHCWMRQuality.BOACRExpBaseEpr).IsRightCatNormName(EpisodeID,CatName,TemplateID)
	q:flg<1 ret
	s HISData=##Class(web.DHCWMRQuality.BOACRExpBaseHis).GetInPatDateTime(EpisodeID)
	q:HISData="" ret
	s ElementDatas=##Class(web.DHCWMRQuality.BOACRExpEprMulti).GetMultiTemHaDate(EpisodeID,CatName,"","","","","05001")
	s CurrDateTime=$zd(+$h,3)_" "_$zt($p($h,",",2),2)
	s FromDate=$list(HISData,1)
	s EndDate=$s($list(HISData,2)="":CurrDateTime,1:$list(HISData,2))
	s tmpTimeGap=##Class(web.DHCWMRQuality.BOACRExpBaseHis).GetDateTimeGap(EndDate,FromDate)
	s DischHour=##Class(web.DHCWMRQuality.BOACRExpBaseHis).GetDischHour(EpisodeID)
	s ret=1
	//s:(DischHour>24)&&((tmpTimeGap\24-1)>$listlength(ElementDatas))&&((tmpTimeGap\24-1)>=0) ret=-1
	//s:(DischHour<=24)&&((tmpTimeGap\24-1)>$listlength(ElementDatas))&&((tmpTimeGap\24-1)>=0) ret=-1
	s:(tmpTimeGap\24)>$listlength(ElementDatas) ret=-1
	q ret
}

/// ****************************************************************
/// 说明: 入院48小时内无上级医师首次查房记录
/// 结论: ret<0 不一致
/// 调试: w ##Class(web.DHCWMRQuality.BOACRExpBaseFun).IsUnify0033(EpisodeID,CatName,TemplateID)
/// ****************************************************************
ClassMethod IsUnify0033(EpisodeID As %String, CatName As %String, TemplateID As %String) As %String
{
	n (EpisodeID,CatName,TemplateID)
	s ret=0
	q:(EpisodeID="")||(CatName="") ret
	s CatName=$list(CatName,1)
	s flg=##Class(web.DHCWMRQuality.BOACRExpBaseEpr).IsRightCatNormName(EpisodeID,CatName,TemplateID)
	q:flg<1 ret
	s HISData=##Class(web.DHCWMRQuality.BOACRExpBaseHis).GetInPatDateTime(EpisodeID)
	q:HISData="" ret
	s ret=1
	s CurrDateTime=$zd(+$h,3)_" "_$zt($p($h,",",2),2)
	s FromDate=$list(HISData,1)
	s EndDate=$s($list(HISData,2)="":CurrDateTime,1:$list(HISData,2))
	s tmpTimeGap=##Class(web.DHCWMRQuality.BOACRExpBaseHis).GetDateTimeGap(EndDate,FromDate)
	q:tmpTimeGap<=48 ret
	s ElementDatas=##Class(web.DHCWMRQuality.BOACRExpEprMulti).GetMultiTemHaDateTime(EpisodeID,CatName,"","","","","05002")
	s:ElementDatas="" ret=-1
	q:ElementDatas="" ret
	s ElementData=$list(ElementDatas,1)
	s tmpTimeGap=##Class(web.DHCWMRQuality.BOACRExpBaseHis).GetDateTimeGap(ElementData,FromDate)
	s:tmpTimeGap>48 ret=-1
	q ret
}

/// ****************************************************************
/// 说明: 住院超过一月无阶段小结(2天宽限)
/// 结论: ret<0 不一致
/// 调试: w ##Class(web.DHCWMRQuality.BOACRExpBaseFun).IsUnify0034(EpisodeID,CatName,TemplateID)
/// ****************************************************************
ClassMethod IsUnify0034(EpisodeID As %String, CatName As %String, TemplateID As %String) As %String
{
	n (EpisodeID,CatName,TemplateID)
	s ret=0
	q:(EpisodeID="")||(CatName="") ret
	s CatName=$list(CatName,1)
	s flg=##Class(web.DHCWMRQuality.BOACRExpBaseEpr).IsRightCatNormName(EpisodeID,CatName,TemplateID)
	q:flg<1 ret
	s HISData=##Class(web.DHCWMRQuality.BOACRExpBaseHis).GetInPatDateTime(EpisodeID)
	q:HISData="" ret
	s ret=1
	s CurrDateTime=$zd(+$h,3)_" "_$zt($p($h,",",2),2)
	s FromDate=$list(HISData,1)
	s EndDate=$s($list(HISData,2)="":CurrDateTime,1:$list(HISData,2))
	s tmpTimeGap=##Class(web.DHCWMRQuality.BOACRExpBaseHis).GetDateTimeGap(EndDate,FromDate)
	s Times=((tmpTimeGap\24-2)\30)
	q:Times<1 ret
	s ElementDatas=##Class(web.DHCWMRQuality.BOACRExpEprMulti).GetMultiTemHaDate(EpisodeID,CatName,"","","","","05007")
	s:Times>$listlength(ElementDatas) ret=-1
	q ret
}

/// ****************************************************************
/// 说明: 危重症患者必须要有上级医师查房记录
/// 结论: ret<0 不一致
/// 调试: w ##Class(web.DHCWMRQuality.BOACRExpBaseFun).IsUnify0035(EpisodeID,CatName,TemplateID)
/// ****************************************************************
ClassMethod IsUnify0035(EpisodeID As %String, CatName As %String, TemplateID As %String) As %String
{
	n (EpisodeID,CatName,TemplateID)
	s ret=0
	q:(EpisodeID="")||(CatName="") ret
	s CatName=$list(CatName,1)
	s flg=##Class(web.DHCWMRQuality.BOACRExpBaseEpr).IsRightCatNormName(EpisodeID,CatName,TemplateID)
	q:flg<1 ret
	s HISData=##Class(web.DHCWMRQuality.BOACRExpBaseHis).IsApogeeInPat(EpisodeID)
	q:HISData="" ret
	s ElementDatas=##Class(web.DHCWMRQuality.BOACRExpEprMulti).GetMultiTemHaDateTime(EpisodeID,CatName,"","","","","05002")
	s ret=1
	q:HISData'["Y" ret   //HISData'="Yes"表示此患者不是危重患者
	s:$listlength(ElementDatas)<1 ret=-1
	q ret
}

/// ****************************************************************
/// 说明: 抢救记录无上级医师意见及参加抢救的医务人员姓名及专业技术职务
///     : 抢救记录内容包含副主任医师,副教授,主任医师,教授,副主任,主任字样
/// 结论: ret<0 不一致
/// 调试: w ##Class(web.DHCWMRQuality.BOACRExpBaseFun).IsUnify0036(EpisodeID,CatName,TemplateID,InstanceID)
/// ****************************************************************
ClassMethod IsUnify0036(EpisodeID As %String, Element As %String, TemplateID As %String, InstanceID As %String) As %String
{
	n (EpisodeID,Element,TemplateID,InstanceID)
	s ret=0
	q:(EpisodeID="")||(CatName="") ret
	s CatName=$list(CatName,1),ElName=$list(CatName,2)
	s flg=##Class(web.DHCWMRQuality.BOACRExpBaseEpr).IsRightCatNormName(EpisodeID,CatName,TemplateID)
	q:flg<1 ret
	s ElementDatas=##Class(web.DHCWMRQuality.BOACRExpEprMulti).GetMultiTemElData(EpisodeID,CatName,ElName,"","","","","05009")
	q:ElementDatas="" ret
	s ret=1
	f Ind=1:1:$listlength(ElementDatas) d
	.s ElementData=$list(ElementDatas,Ind)
	.s:(ElementData'="主任")&&(ElementData'="教授") ret=-1
	q ret
}

/// ****************************************************************
/// 说明: 死亡病人必须写死亡讨论记录
/// 结论: ret<0 不一致
/// 调试: w ##Class(web.DHCWMRQuality.BOACRExpBaseFun).IsUnify0037(EpisodeID,CatName,TemplateID)
/// ****************************************************************
ClassMethod IsUnify0037(EpisodeID As %String, CatName As %String, TemplateID As %String) As %String
{
	n (EpisodeID,CatName,TemplateID)
	s ret=0
	q:(EpisodeID="")||(CatName="") ret
	s CatName=$list(CatName,1)
	s flg=##Class(web.DHCWMRQuality.BOACRExpBaseEpr).IsRightCatNormName(EpisodeID,CatName,TemplateID)
	q:flg<1 ret
	s ret=1
	s HISData=##Class(web.DHCWMRQuality.BOACRExpBaseHis).GetDeathDateTime(EpisodeID)
	q:HISData="" ret
	s DischHour=##Class(web.DHCWMRQuality.BOACRExpBaseHis).GetDischHour(EpisodeID)
	q:DischHour<=24 ret
	s ElementData=##Class(web.DHCWMRQuality.BOACRExpEprMulti).GetMultiTemReCount(EpisodeID,CatName,"","","","","05015")
	s:ElementData<1 ret=-1
	q ret
}

/// ****************************************************************
/// 说明: 交班病人接班记录数与接班记录数不一致
/// 结论: ret<0 不一致
/// 调试: w ##Class(web.DHCWMRQuality.BOACRExpBaseFun).IsUnify0038(EpisodeID,CatName,TemplateID)
/// ****************************************************************
ClassMethod IsUnify0038(EpisodeID As %String, CatName As %String, TemplateID As %String) As %String
{
	n (EpisodeID,CatName,TemplateID)
	s ret=0
	q:(EpisodeID="")||(CatName="") ret
	s CatName=$list(CatName,1)
	s flg=##Class(web.DHCWMRQuality.BOACRExpBaseEpr).IsRightCatNormName(EpisodeID,CatName,TemplateID)
	q:flg<1 ret
	s DischHour=##Class(web.DHCWMRQuality.BOACRExpBaseHis).GetDischHour(EpisodeID)
	s ElementData1=##Class(web.DHCWMRQuality.BOACRExpEprMulti).GetMultiTemReCount(EpisodeID,CatName,"","","","","05003")
	s ElementData2=##Class(web.DHCWMRQuality.BOACRExpEprMulti).GetMultiTemReCount(EpisodeID,CatName,"","","","","05004")
	s tmp=ElementData1-ElementData2
	s ret=1
	//s:(DischHour'>24)&&((tmp<0)||(tmp>1)) ret=-1
	//s:(DischHour>24)&&(tmp'=0) ret=-1
	s:tmp'=0 ret=-1
	q ret
}

/// ****************************************************************
/// 说明: 转科病人转科记录数与接收记录数不一致
/// 结论: ret<0 不一致
/// 调试: w ##Class(web.DHCWMRQuality.BOACRExpBaseFun).IsUnify0039(EpisodeID,CatName,TemplateID)
/// ****************************************************************
ClassMethod IsUnify0039(EpisodeID As %String, CatName As %String, TemplateID As %String) As %String
{
	n (EpisodeID,CatName,TemplateID)
	s ret=0
	q:(EpisodeID="")||(CatName="") ret
	s CatName=$list(CatName,1)
	s flg=##Class(web.DHCWMRQuality.BOACRExpBaseEpr).IsRightCatNormName(EpisodeID,CatName,TemplateID)
	q:flg<1 ret
	s DischHour=##Class(web.DHCWMRQuality.BOACRExpBaseHis).GetDischHour(EpisodeID)
	s ElementData1=##Class(web.DHCWMRQuality.BOACRExpEprMulti).GetMultiTemReCount(EpisodeID,CatName,"","","","","05005")
	s ElementData2=##Class(web.DHCWMRQuality.BOACRExpEprMulti).GetMultiTemReCount(EpisodeID,CatName,"","","","","05006")
	s tmp=ElementData1-ElementData2
	s ret=1
	//s:(DischHour'>24)&&((tmp<0)||(tmp>1)) ret=-1
	//s:(DischHour>24)&&(tmp'=0) ret=-1
	s:tmp'=0 ret=-1
	q ret
}

/// ****************************************************************
/// 说明: 会诊病人请会诊记录数与会诊记录数不一致
/// 结论: ret<0 不一致
/// 调试: w ##Class(web.DHCWMRQuality.BOACRExpBaseFun).IsUnify0040(EpisodeID,CatName,TemplateID)
/// ****************************************************************
ClassMethod IsUnify0040(EpisodeID As %String, CatName As %String, TemplateID As %String) As %String
{
	n (EpisodeID,CatName,TemplateID)
	s ret=0
	q:(EpisodeID="")||(CatName="") ret
	s CatName=$list(CatName,1)
	s flg=##Class(web.DHCWMRQuality.BOACRExpBaseEpr).IsRightCatNormName(EpisodeID,CatName,TemplateID)
	q:flg<1 ret
	s DischHour=##Class(web.DHCWMRQuality.BOACRExpBaseHis).GetDischHour(EpisodeID)
	s ElementData1=##Class(web.DHCWMRQuality.BOACRExpEprMulti).GetMultiTemReCount(EpisodeID,CatName,"","","","","05010")
	s ElementData2=##Class(web.DHCWMRQuality.BOACRExpEprMulti).GetMultiTemReCount(EpisodeID,CatName,"","","","","05011")
	s tmp=ElementData1-ElementData2
	s ret=1
	//s:(DischHour'>24)&&((tmp<0)||(tmp>1)) ret=-1
	//s:(DischHour>24)&&(tmp'=0) ret=-1
	s:tmp'=0 ret=-1
	q ret
}

/// ****************************************************************
/// 说明: 转科病人无转科记录;转科表转科次数<>转科记录次数
/// 结论: ret<0 不一致
/// 调试: w ##Class(web.DHCWMRQuality.BOACRExpBaseFun).IsUnify0041(EpisodeID,CatName,TemplateID)
/// ****************************************************************
ClassMethod IsUnify0041(EpisodeID As %String, CatName As %String, TemplateID As %String) As %String
{
	n (EpisodeID,CatName,TemplateID)
	s ret=0
	q:(EpisodeID="")||(CatName="") ret
	s CatName=$list(CatName,1)
	s flg=##Class(web.DHCWMRQuality.BOACRExpBaseEpr).IsRightCatNormName(EpisodeID,CatName,TemplateID)
	q:flg<1 ret
	s HISData=##Class(web.DHCWMRQuality.BOACRExpBaseHis).GetTransLocCount(EpisodeID)
	s DischHour=##Class(web.DHCWMRQuality.BOACRExpBaseHis).GetDischHour(EpisodeID)
	s ElementData=##Class(web.DHCWMRQuality.BOACRExpEprMulti).GetMultiTemReCount(EpisodeID,CatName,"","","","","05005")
	s tmp=ElementData-HISData
	s ret=1
	//s:(DischHour'>24)&&((tmp<0)||(tmp>1)) ret=-1
	//s:(DischHour>24)&&(tmp'=0) ret=-1
	s:tmp'=0 ret=-1
	q ret
}

/// ****************************************************************
/// 说明: 抢救病人无抢救记录;抢救医嘱数<>抢救记录次数
/// 结论: ret<0 不一致
/// 调试: w ##Class(web.DHCWMRQuality.BOACRExpBaseFun).IsUnify0042(EpisodeID,CatName,TemplateID)
/// ****************************************************************
ClassMethod IsUnify0042(EpisodeID As %String, CatName As %String, TemplateID As %String) As %String
{
	n (EpisodeID,CatName,TemplateID)
	s ret=0
	q:(EpisodeID="")||(CatName="") ret
	s CatName=$list(CatName,1)
	s flg=##Class(web.DHCWMRQuality.BOACRExpBaseEpr).IsRightCatNormName(EpisodeID,CatName,TemplateID)
	q:flg<1 ret
	s HISData=##Class(web.DHCWMRQuality.BOACRExpBaseHis).GetSaveTimes(EpisodeID)
	s DischHour=##Class(web.DHCWMRQuality.BOACRExpBaseHis).GetDischHour(EpisodeID)
	s ElementData=##Class(web.DHCWMRQuality.BOACRExpEprMulti).GetMultiTemReCount(EpisodeID,CatName,"","","","","05009")
	s tmp=HISData-ElementData
	s ret=1
	//s:(DischHour'>24)&&((tmp<-1)||(tmp>1)) ret=-1
	//s:(DischHour>24)&&(tmp'=0) ret=-1
	s:tmp'=0 ret=-1
	q ret
}

/// ****************************************************************
/// 说明: 输血病人无输血记录;输血医嘱数<>输血记录次数
/// 结论: ret<0 不一致
/// 调试: w ##Class(web.DHCWMRQuality.BOACRExpBaseFun).IsUnify0043(EpisodeID,CatName,TemplateID)
/// ****************************************************************
ClassMethod IsUnify0043(EpisodeID As %String, CatName As %String, TemplateID As %String) As %String
{
	n (EpisodeID,CatName,TemplateID)
	s ret=0
	q:(EpisodeID="")||(CatName="") ret
	s CatName=$list(CatName,1)
	s flg=##Class(web.DHCWMRQuality.BOACRExpBaseEpr).IsRightCatNormName(EpisodeID,CatName,TemplateID)
	q:flg<1 ret
	s HISData=##Class(web.DHCWMRQuality.BOACRExpBaseHis).GetTransfuseTimes(EpisodeID)
	s DischHour=##Class(web.DHCWMRQuality.BOACRExpBaseHis).GetDischHour(EpisodeID)
	s ElementData=##Class(web.DHCWMRQuality.BOACRExpEprMulti).GetMultiTemReCount(EpisodeID,CatName,"","","","","05012")
	s tmp=HISData-ElementData
	s ret=1
	//s:(DischHour<=24)&&((tmp<0)||(tmp>1)) ret=-1
	//s:(DischHour>24)&&(tmp'=0) ret=-1
	s:tmp'=0 ret=-1
	q ret
}

/// ****************************************************************
/// 说明: 穿刺病人无穿刺记录;穿刺医嘱数<>穿刺记录次数
/// 结论: ret<0 不一致
/// 调试: w ##Class(web.DHCWMRQuality.BOACRExpBaseFun).IsUnify0044(EpisodeID,CatName,TemplateID)
/// ****************************************************************
ClassMethod IsUnify0044(EpisodeID As %String, CatName As %String, TemplateID As %String) As %String
{
	n (EpisodeID,CatName,TemplateID)
	s ret=0
	q:(EpisodeID="")||(CatName="") ret
	s CatName=$list(CatName,1)
	s flg=##Class(web.DHCWMRQuality.BOACRExpBaseEpr).IsRightCatNormName(EpisodeID,CatName,TemplateID)
	q:flg<1 ret
	s HISData=##Class(web.DHCWMRQuality.BOACRExpBaseHis).GetPunctureTimes(EpisodeID)
	s DischHour=##Class(web.DHCWMRQuality.BOACRExpBaseHis).GetDischHour(EpisodeID)
	s ElementData=##Class(web.DHCWMRQuality.BOACRExpEprMulti).GetMultiTemReCount(EpisodeID,CatName,"","","","","05013")
	s tmp=HISData-ElementData
	s ret=1
	//s:(DischHour<=24)&&((tmp<0)||(tmp>1)) ret=-1
	//s:(DischHour>24)&&(tmp'=0) ret=-1
	s:tmp'=0 ret=-1
	q ret
}

/// ****************************************************************
/// *********************START 中国医大 20090624加******************
/// ****************************************************************
/// 
/// ****************************************************************
/// 说明: 病案首页{国籍}与{住家地址}填写不一致
/// 结论: ret<0 不一致
/// 调试: w ##Class(web.DHCWMRQuality.BOACRExpBaseFun).IsUnify0045(EpisodeID,Element1,Element2,TemplateID)
/// ****************************************************************
ClassMethod IsUnify0045(EpisodeID As %String, Element1 As %String, Element2 As %String, TemplateID As %String) As %String
{
	n (EpisodeID,Element1,Element2,TemplateID)
	s ret=0
	q:(EpisodeID="")||(Element1="")||(Element2="") ret
	s CatName1=$list(Element1,1),ElName1=$list(Element1,2)
	s CatName2=$list(Element2,1),ElNames2=$list(Element2,2)
	s flg1=##Class(web.DHCWMRQuality.BOACRExpBaseEpr).IsRightElNormName(EpisodeID,CatName1,ElName1,TemplateID)
	q:flg1<1 ret
	s ElementData1=##Class(web.DHCWMRQuality.BOACRExpBaseEpr).GetElementDataByName(EpisodeID,CatName1,ElName1,"")
	s ElementData2=""
	f Ind=1:1:$listlength(ElNames2) d
	.s ElName2=$list(ElNames2,Ind)
	.s flg2=##Class(web.DHCWMRQuality.BOACRExpBaseEpr).IsRightElNormName(EpisodeID,CatName2,ElName2,TemplateID)
	.q:flg2<1
	.s tmp=##Class(web.DHCWMRQuality.BOACRExpBaseEpr).GetElementDataByName(EpisodeID,CatName2,ElName2,"")
	.s:tmp'="" tmp=$list(tmp,1)
	.q:tmp=""
	.s ElementData2=ElementData2_$lb(tmp)
	q:(ElementData1="")&&(ElementData2="") ret
	s:ElementData1'="" ElementData1=$list(ElementData1,1)
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
/// 调试: w ##Class(web.DHCWMRQuality.BOACRExpBaseFun).IsUnify0046(EpisodeID,Element,TemplateID)
/// ****************************************************************
ClassMethod IsUnify0046(EpisodeID As %String, Element As %String, TemplateID As %String) As %String
{
	n (EpisodeID,Element,TemplateID)
	s ret=0
	q:(EpisodeID="")||(Element="") ret
	s CatName=$list(Element,1),ElNames=$list(Element,2)
	s TemplateData=##Class(web.DHCWMRQuality.BOACRExpBaseEpr).GetTemplateDataByName(EpisodeID,CatName)
	q:($p(TemplateData,"^",1)="")||($p(TemplateData,"^",8)="UnSave")||($p(TemplateData,"^",8)="") ret
	s Count=0
	f Ind=1:1:$listlength(ElNames) d
	.s ElName=$list(ElNames,Ind)
	.s flg=##Class(web.DHCWMRQuality.BOACRExpBaseEpr).IsRightElNormName(EpisodeID,CatName,ElName,TemplateID)
	.q:flg<1
	.s Count=Count+1
	.s tmp=##Class(web.DHCWMRQuality.BOACRExpBaseEpr).GetElementDataByName(EpisodeID,CatName,ElName,"")
	.s:tmp'="" tmp=$list(tmp,1)
	.q:tmp=""
	.s ElementData=ElementData_$lb(tmp)
	s ret=1
	s:$listlength(ElementData)<Count ret=-1
	q ret
}

/// ****************************************************************
/// *********************START 华西医院 20090630加******************
/// ****************************************************************
/// 
/// ****************************************************************
/// 说明: 病案首页{死亡原因}与HIS{死亡时间}不一致
/// 结论: ret<0 不一致
/// 调试: w ##Class(web.DHCWMRQuality.BOACRExpBaseFun).IsUnify0047(EpisodeID,Element,TemplateID)
/// ****************************************************************
ClassMethod IsUnify0047(EpisodeID As %String, Element As %String, TemplateID As %String) As %String
{
	n (EpisodeID,Element,TemplateID)
	s ret=0
	q:(EpisodeID="")||(Element="") ret
	s CatName=$list(Element,1),ElName=$list(Element,2)
	s flg=##Class(web.DHCWMRQuality.BOACRExpBaseEpr).IsRightElNormName(EpisodeID,CatName,ElName,TemplateID)
	q:flg<1 ret
	s ElementData=##Class(web.DHCWMRQuality.BOACRExpBaseEpr).GetElementDataByName(EpisodeID,CatName,ElName,"")
	s:ElementData'="" ElementData=$list(ElementData,1)
	s ElementData=##Class(web.DHCWMRQuality.BOACRExpBaseHis).ClearUselessChar(ElementData," -/")
	s DeathTime=##Class(web.DHCWMRQuality.BOACRExpBaseHis).GetDeathDateTime(EpisodeID)
	s ret=1
	i DeathTime'="" d
	.s:(ElementData="")||(ElementData="无") ret=-1
	e  d
	.s:(ElementData'="")||(ElementData'="无") ret=-1
	q ret
}

/// ****************************************************************
/// 说明: 病案首页{输血反应}与HIS{输血医嘱}不一致
/// 结论: ret<0 不一致
/// 调试: w ##Class(web.DHCWMRQuality.BOACRExpBaseFun).IsUnify0048(EpisodeID,Element,TemplateID)
/// ****************************************************************
ClassMethod IsUnify0048(EpisodeID As %String, Element As %String, TemplateID As %String) As %String
{
	n (EpisodeID,Element,TemplateID)
	s ret=0
	q:(EpisodeID="")||(Element="") ret
	s CatName=$list(Element,1),ElName=$list(Element,2)
	s flg=##Class(web.DHCWMRQuality.BOACRExpBaseEpr).IsRightElNormName(EpisodeID,CatName,ElName,TemplateID)
	q:flg<1 ret
	s ElementData=##Class(web.DHCWMRQuality.BOACRExpBaseEpr).GetElementDataByName(EpisodeID,CatName,ElName,"")
	s:ElementData'="" ElementData=$list(ElementData,1)
	s TransfuseTimes=##Class(web.DHCWMRQuality.BOACRExpBaseHis).GetTransfuseTimes(EpisodeID)
	s ^ZF(11)=$lb(TransfuseTimes,ElementData)
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
/// 调试: w ##Class(web.DHCWMRQuality.BOACRExpBaseFun).IsUnify0049(EpisodeID,Element1,Element2,TemplateID)
/// ****************************************************************
ClassMethod IsUnify0049(EpisodeID As %String, Element1 As %String, Element2 As %String, TemplateID As %String) As %String
{
	n (EpisodeID,Element1,Element2,TemplateID)
	s ret=0
	q:(EpisodeID="")||(Element1="")||(Element2="") ret
	s CatName1=$list(Element1,1),ElName1=$list(Element1,2)
	s CatName2=$list(Element2,1),ElName2=$list(Element2,2)
	s flg1=##Class(web.DHCWMRQuality.BOACRExpBaseEpr).IsRightElNormName(EpisodeID,CatName1,ElName1,TemplateID)
	s flg2=##Class(web.DHCWMRQuality.BOACRExpBaseEpr).IsRightElNormName(EpisodeID,CatName2,ElName2,TemplateID)
	q:(flg1<1)||(flg2<1) ret
	s ElementData1=##Class(web.DHCWMRQuality.BOACRExpBaseEpr).GetElementDataByName(EpisodeID,CatName1,ElName1,"")
	s ElementData2=##Class(web.DHCWMRQuality.BOACRExpBaseEpr).GetElementDataByName(EpisodeID,CatName2,ElName2,"")
	q:(ElementData1="")&&(ElementData2="") ret
	s:ElementData1'="" ElementData1=$list(ElementData1,1)
	s:ElementData2'="" ElementData2=$list(ElementData2,1)
	s ret=1
	i (ElementData1="否")||(ElementData1="无")||(ElementData1="") d
	.s:(ElementData2="是")||(ElementData2="已")||(ElementData2="未") ret=-1
	q ret
}

/// ****************************************************************
/// 说明: 住院病历{是否吸烟/是否戒烟/是否饮酒}与{吸烟时间/戒烟时间/饮酒时间}填写不一致
/// 结论: ret<0 不一致
/// 调试: w ##Class(web.DHCWMRQuality.BOACRExpBaseFun).IsUnify0050(EpisodeID,Element1,Element2,TemplateID)
/// ****************************************************************
ClassMethod IsUnify0050(EpisodeID As %String, Element1 As %String, Element2 As %String, TemplateID As %String) As %String
{
	n (EpisodeID,Element1,Element2,TemplateID)
	s ret=0
	q:(EpisodeID="")||(Element1="")||(Element2="") ret
	s CatName1=$list(Element1,1),ElName1=$list(Element1,2)
	s CatName2=$list(Element2,1),ElName2=$list(Element2,2)
	s flg1=##Class(web.DHCWMRQuality.BOACRExpBaseEpr).IsRightElNormName(EpisodeID,CatName1,ElName1,TemplateID)
	s flg2=##Class(web.DHCWMRQuality.BOACRExpBaseEpr).IsRightElNormName(EpisodeID,CatName2,ElName2,TemplateID)
	q:(flg1<1)||(flg2<1) ret
	s ElementData1=##Class(web.DHCWMRQuality.BOACRExpBaseEpr).GetElementDataByName(EpisodeID,CatName1,ElName1,"")
	s ElementData2=##Class(web.DHCWMRQuality.BOACRExpBaseEpr).GetElementDataByName(EpisodeID,CatName2,ElName2,"")
	q:(ElementData1="")&&(ElementData2="") ret
	s:ElementData1'="" ElementData1=$list(ElementData1,1)
	s:ElementData2'="" ElementData2=$list(ElementData2,1)
	s ElementData2=##Class(web.DHCWMRQuality.BOACRExpBaseHis).ClearUselessChar(ElementData2," -/无")
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
/// 调试: w ##Class(web.DHCWMRQuality.BOACRExpBaseFun).IsUnify0051(EpisodeID,Element1,Element2,TemplateID)
/// ****************************************************************
ClassMethod IsUnify0051(EpisodeID As %String, Element1 As %String, Element2 As %String, TemplateID As %String) As %String
{
	n (EpisodeID,Element1,Element2,TemplateID)
	s ret=0
	q:(EpisodeID="")||(Element1="")||(Element2="") ret
	s CatName1=$list(Element1,1),ElName1=$list(Element1,2)
	s CatName2=$list(Element2,1),ElName2=$list(Element2,2)
	s flg1=##Class(web.DHCWMRQuality.BOACRExpBaseEpr).IsRightElNormName(EpisodeID,CatName1,ElName1,TemplateID)
	s flg2=##Class(web.DHCWMRQuality.BOACRExpBaseEpr).IsRightElNormName(EpisodeID,CatName2,ElName2,TemplateID)
	q:(flg1<1)||(flg2<1) ret
	s ElementData1=##Class(web.DHCWMRQuality.BOACRExpBaseEpr).GetElementDataByName(EpisodeID,CatName1,ElName1,"")
	s ElementData2=##Class(web.DHCWMRQuality.BOACRExpBaseEpr).GetElementDataByName(EpisodeID,CatName2,ElName2,"")
	q:(ElementData1="")&&(ElementData2="") ret
	s:ElementData1'="" ElementData1=$list(ElementData1,1)
	s:ElementData2'="" ElementData2=$list(ElementData2,1)
	s ElementData2=##Class(web.DHCWMRQuality.BOACRExpBaseHis).ClearUselessChar(ElementData2," -/")
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
/// 调试: w ##Class(web.DHCWMRQuality.BOACRExpBaseFun).IsUnify0052(EpisodeID,Element1,Element2,TemplateID)
/// ****************************************************************
ClassMethod IsUnify0052(EpisodeID As %String, Element1 As %String, Element2 As %String, TemplateID As %String) As %String
{
	n (EpisodeID,Element1,Element2,TemplateID)
	s ret=0
	q:(EpisodeID="")||(Element1="")||(Element2="") ret
	s CatName1=$list(Element1,1),ElName1=$list(Element1,2)
	s CatName2=$list(Element2,1),ElName2=$list(Element2,2)
	s flg1=##Class(web.DHCWMRQuality.BOACRExpBaseEpr).IsRightElNormName(EpisodeID,CatName1,ElName1,TemplateID)
	s flg2=##Class(web.DHCWMRQuality.BOACRExpBaseEpr).IsRightElNormName(EpisodeID,CatName2,ElName2,TemplateID)
	q:(flg1<1)||(flg2<1) ret
	s ElementData1=##Class(web.DHCWMRQuality.BOACRExpBaseEpr).GetElementDataByName(EpisodeID,CatName1,ElName1,"")
	s ElementData2=##Class(web.DHCWMRQuality.BOACRExpBaseEpr).GetElementDataByName(EpisodeID,CatName2,ElName2,"")
	q:(ElementData1="")&&(ElementData2="") ret
	s:ElementData1'="" ElementData1=$list(ElementData1,1)
	s:ElementData2'="" ElementData2=$list(ElementData2,1)
	s ElementData2=##Class(web.DHCWMRQuality.BOACRExpBaseHis).ClearUselessChar(ElementData2," -/")
	s ret=1
	i (ElementData1="死亡")||(ElementData1="已故") d
	.s:(ElementData2="")||(ElementData2="无") ret=-1
	e  d
	.s:(ElementData2'="")&&(ElementData2'="无") ret=-1
	q ret
}

/// ****************************************************************
/// 说明: 住院病历{父亲状态/母亲状态}与{父亲所患疾病/母亲所患疾病}填写不一致
/// 结论: ret<0 不一致
/// 调试: w ##Class(web.DHCWMRQuality.BOACRExpBaseFun).IsUnify0053(EpisodeID,Element1,Element2,TemplateID)
/// ****************************************************************
ClassMethod IsUnify0053(EpisodeID As %String, Element1 As %String, Element2 As %String, TemplateID As %String) As %String
{
	n (EpisodeID,Element1,Element2,TemplateID)
	s ret=0
	q:(EpisodeID="")||(Element1="")||(Element2="") ret
	s CatName1=$list(Element1,1),ElName1=$list(Element1,2)
	s CatName2=$list(Element2,1),ElName2=$list(Element2,2)
	s flg1=##Class(web.DHCWMRQuality.BOACRExpBaseEpr).IsRightElNormName(EpisodeID,CatName1,ElName1,TemplateID)
	s flg2=##Class(web.DHCWMRQuality.BOACRExpBaseEpr).IsRightElNormName(EpisodeID,CatName2,ElName2,TemplateID)
	q:(flg1<1)||(flg2<1) ret
	s ElementData1=##Class(web.DHCWMRQuality.BOACRExpBaseEpr).GetElementDataByName(EpisodeID,CatName1,ElName1,"")
	s ElementData2=##Class(web.DHCWMRQuality.BOACRExpBaseEpr).GetElementDataByName(EpisodeID,CatName2,ElName2,"")
	q:(ElementData1="")&&(ElementData2="") ret
	s:ElementData1'="" ElementData1=$list(ElementData1,1)
	s:ElementData2'="" ElementData2=$list(ElementData2,1)
	s ElementData2=##Class(web.DHCWMRQuality.BOACRExpBaseHis).ClearUselessChar(ElementData2," -/")
	s ret=1
	i ElementData1="患病" d
	.s:(ElementData2="")||(ElementData2="无") ret=-1
	e  d
	.s:(ElementData2'="")&&(ElementData2'="无") ret=-1
	q ret
}

/// ****************************************************************
/// 说明: 抢救医嘱后6小时未完成抢救记录
/// 结论: ret<0 不一致
/// 调试: w ##Class(web.DHCWMRQuality.BOACRExpBaseFun).IsUnify0054(EpisodeID,CatName,TemplateID)
/// ****************************************************************
ClassMethod IsUnify0054(EpisodeID As %String, CatName As %String, TemplateID As %String) As %String
{
	n (EpisodeID,CatName,TemplateID)
	s ret=0
	q:(EpisodeID="")||(CatName="") ret
	s CatName=$list(CatName,1)
	s flg=##Class(web.DHCWMRQuality.BOACRExpBaseEpr).IsRightCatNormName(EpisodeID,CatName,TemplateID)
	q:flg<1 ret
	s ElementDatas=##Class(web.DHCWMRQuality.BOACRExpEprMulti).GetMultiTemHaDateTime(EpisodeID,CatName,"","","","","05009")
	s SaveDatas=##Class(web.DHCWMRQuality.BOACRExpBaseHis).GetSaveDateTime(EpisodeID)
	s ret=1
	s CurrDateTime=$zd(+$h,3)_" "_$zt($p($h,",",2),2)
	f Ind=1:1:$listlength(SaveDatas) d
	.s SaveData=$list(SaveDatas,Ind)
	.s ElementData=$s((Ind>$listlength(ElementDatas)):CurrDateTime,1:$list(ElementDatas,Ind))
	.s tmpTimeGap=##Class(web.DHCWMRQuality.BOACRExpBaseHis).GetDateTimeGap(ElementData,SaveData)
	.q:(tmpTimeGap'>6)
	.s ret=-1
	q ret
}

/// ****************************************************************
/// ******************START 长春妇产医院 20090706加*****************
/// ****************************************************************
/// 
/// ****************************************************************
/// 说明: 病案首页{临床与病理 + 放射与病理}与病案首页{病理诊断}不一致
/// 结论: ret<0 不一致
/// 调试: w ##Class(web.DHCWMRQuality.BOACRExpBaseFun).IsUnify0055(EpisodeID,Elements1,Element2,TemplateID)
/// ****************************************************************
ClassMethod IsUnify0055(EpisodeID As %String, Elements1 As %String, Element2 As %String, TemplateID As %String) As %String
{
	n (EpisodeID,Elements1,Element2,TemplateID)
	s ret=0
	q:(EpisodeID="")||(Elements1="")||(Element2="") ret
	s CatName1=$list(Elements1,1),ElNames1=$list(Elements1,2)
	s CatName2=$list(Element2,1),ElName2=$list(Element2,2)
	s flg2=##Class(web.DHCWMRQuality.BOACRExpBaseEpr).IsRightElNormName(EpisodeID,CatName2,ElName2,TemplateID)
	q:flg2<1 ret
	s ElementData2=##Class(web.DHCWMRQuality.BOACRExpBaseEpr).GetElementDataByName(EpisodeID,CatName2,ElName2,"")
	s:ElementData2'="" ElementData2=$list(ElementData2,1)
	s ElementData1=""
	f Ind=1:1:$listlength(ElNames1) d
	.s ElName1=$list(ElNames1,Ind)
	.s flg1=##Class(web.DHCWMRQuality.BOACRExpBaseEpr).IsRightElNormName(EpisodeID,CatName1,ElName1,TemplateID)
	.q:flg1<1
	.s tmp=##Class(web.DHCWMRQuality.BOACRExpBaseEpr).GetElementDataByName(EpisodeID,CatName1,ElName1,"")
	.s:tmp'="" tmp=$list(tmp,1)
	.q:tmp=""
	.s ElementData1=ElementData1_$lb(tmp)
	q:(ElementData1="")&&(ElementData2="") ret
	s ElementData2=##Class(web.DHCWMRQuality.BOACRExpBaseHis).ClearUselessChar(ElementData2," /-")
	s ret=1
	i (ElementData2="无")||(ElementData2="不详")||(ElementData2="") d
	.f Ind=1:1:$listlength(ElementData1) d
	..s tmp=$list(ElementData1,Ind)
	..s:(tmp'="未做")&&(tmp'="") ret=-1
	e  d
	.s:($listfind(ElementData1,"符合")=0)&&($listfind(ElementData1,"不符合")=0)&&($listfind(ElementData1,"不肯定")=0) ret=-1
	q ret
}

}
