Import SQLUser

/// 维护ACR用到的公用方法
/// By ZF 2009-06-14
Class web.DHCWMRQuality.BOACRExpBaseEpr Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 79;

/// 检查条件
ClassMethod IsCheck(EpisodeID As %String, Inds As %String) As %String
{
	n (EpisodeID,Inds)
	s ret=0
	q:(EpisodeID="")||(Inds="") ret
	
	s ret=1
	f I=1:1:$l(Inds,"|") d
	.s Ind=$p(Inds,"|",I)
	.i Ind=1 d //在院大于24小时
	..s tmp=##Class(web.DHCWMRQuality.BOACRExpBaseHis).GetRegHour(EpisodeID)
	..s:tmp<=24 ret=-1
	.i Ind=2 d //在院小于等于24小时
	..s tmp=##Class(web.DHCWMRQuality.BOACRExpBaseHis).GetRegHour(EpisodeID)
	..s:tmp>24 ret=-1
	.i Ind=3 d //女性患者
	..s tmp=##Class(web.DHCWMRQuality.BOACRExpBaseHis).GetSex(EpisodeID)
	..s:tmp'["女" ret=-1
	.i Ind=4 d //死亡患者
	..s tmp=##Class(web.DHCWMRQuality.BOACRExpBaseHis).GetDeathDateTime(EpisodeID)
	..s:tmp="" ret=-1
	.i Ind=5 d //正常患者
	..s tmp=##Class(web.DHCWMRQuality.BOACRExpBaseHis).GetDeathDateTime(EpisodeID)
	..s:tmp'="" ret=-1
	.i Ind=6 d //手术患者
	..//暂时没取
	..s ret=-1
	.i Ind=7 d //院感患者
	..s tmp=##Class(web.DHCWMRQuality.BOACRExpBaseHis).IsInHospInf(EpisodeID)
	..s:tmp'["Y" ret=-1
	.i Ind=8 d //转科患者
	..s tmp=##Class(web.DHCWMRQuality.BOACRExpBaseHis).GetTransLocCount(EpisodeID)
	..s:(+tmp)<1 ret=-1
	.i Ind=9 d //使用抗菌药物患者
	..//暂时没取
	..s ret=-1
	.i Ind=10 d //已婚患者
	..s tmp=##Class(web.DHCWMRQuality.BOACRExpBaseHis).GetMaritalStatus(EpisodeID)
	..s:(tmp="未婚")||(tmp="") ret=-1
	q ret
}

/// ****************************************************************
/// 说明: 出院*时间内模板未保存(模板保存过算合格)(唯一模板/可重复模板)
/// 结论: ret<0 出院*时间内模板未保存
/// 调试: w ##Class(web.DHCWMRQuality.BOACRExpBaseEpr).IsSaveTemByDischTime01(EpisodeID,EPRCatIDs,TemplateID,Hours)
/// ****************************************************************
ClassMethod IsSaveTemByDischTime01(EpisodeID As %String, EPRCatIDs As %String, TemplateID As %String, Hours As %String) As %String
{
	n (EpisodeID,EPRCatIDs,TemplateID,Hours)
	s ret=0
	q:(EpisodeID="")||(EPRCatIDs="")||(Hours="") ret
	
	//没到检查时间
	s DateTime=##Class(web.DHCWMRQuality.BOACRExpBaseHis).GetInPatDateTime(EpisodeID)
	q:DateTime="" ret
	s DischDateTime=$list(DateTime,2)
	q:DischDateTime="" ret
	
	s CurrDateTime=$zd(+$h,3)_" "_$zt($p($h,",",2),2)
	s tmpGap=##Class(web.DHCWMRQuality.BOACRExpBaseHis).GetDateTimeGap(CurrDateTime,DischDateTime)
	q:tmpGap<(+Hours) ret
	
	//模板已保存
	s Count=0,Count1=0
	f Ind=1:1:$listlength(EPRCatIDs) d
	.s EPRCatID=$p($list(EPRCatIDs,Ind),":",1)
	.s CheckCont=$p($list(EPRCatIDs,Ind),":",2)
	.s flg=..IsCheck(EpisodeID,CheckCont)
	.q:flg<0
	.s flg=##Class(web.DHCWMRQuality.BOACRExpBaseEpr).IsRightByCatalog(EpisodeID,EPRCatID,TemplateID)
	.q:flg<1   //无有效模板
	.
	.//超过规定时限模板未保存
	.s tmpTemData=##Class(web.DHCWMRQuality.BOACRExpBaseEpr).GetTemplateData(EpisodeID,EPRCatID)
	.s:($p(tmpTemData,"^",1)="")||($p(tmpTemData,"^",8)="UnSave")||($p(tmpTemData,"^",8)="") ret=-1
	.s Count=Count+1
	.s:$p(tmpTemData,"^",8)="Save" Count1=Count1+1
	s:(ret=0)&&(Count>0)&&(Count=Count1) ret=1
	
	q ret
}

/// ****************************************************************
/// 说明: 入院*时间内模板未保存(模板保存过算合格)(唯一模板/可重复模板)
/// 结论: ret<0 入院*时间内模板未保存
/// 调试: w ##Class(web.DHCWMRQuality.BOACRExpBaseEpr).IsSaveTemByRegTime01(EpisodeID,EPRCatIDs,TemplateID,Hours)
/// ****************************************************************
ClassMethod IsSaveTemByRegTime01(EpisodeID As %String, EPRCatIDs As %String, TemplateID As %String, Hours As %String) As %String
{
	n (EpisodeID,EPRCatIDs,TemplateID,Hours)
	s ret=0
	q:(EpisodeID="")||(EPRCatIDs="")||(Hours="") ret
	
	//没到检查时间
	s DateTime=##Class(web.DHCWMRQuality.BOACRExpBaseHis).GetInPatDateTime(EpisodeID)
	q:DateTime="" ret
	s RegDateTime=$list(DateTime,1)
	q:RegDateTime="" ret
	
	s CurrDateTime=$zd(+$h,3)_" "_$zt($p($h,",",2),2)
	s tmpGap=##Class(web.DHCWMRQuality.BOACRExpBaseHis).GetDateTimeGap(CurrDateTime,RegDateTime)
	q:tmpGap<(+Hours) ret
	
	//模板已保存
	s Count=0,Count1=0
	f Ind=1:1:$listlength(EPRCatIDs) d
	.s EPRCatID=$p($list(EPRCatIDs,Ind),":",1)
	.s CheckCont=$p($list(EPRCatIDs,Ind),":",2)
	.s flg=..IsCheck(EpisodeID,CheckCont)
	.q:flg<0
	.s flg=##Class(web.DHCWMRQuality.BOACRExpBaseEpr).IsRightByCatalog(EpisodeID,EPRCatID,TemplateID)
	.q:flg<1   //无有效模板
	.
	.//超过规定时限模板未保存
	.s tmpTemData=##Class(web.DHCWMRQuality.BOACRExpBaseEpr).GetTemplateData(EpisodeID,EPRCatID)
	.s:($p(tmpTemData,"^",1)="")||($p(tmpTemData,"^",8)="UnSave")||($p(tmpTemData,"^",8)="") ret=-1
	.s Count=Count+1
	.s:$p(tmpTemData,"^",8)="Save" Count1=Count1+1
	s:(ret=0)&&(Count>0)&&(Count=Count1) ret=1
	
	q ret
}

/// ****************************************************************
/// 说明: 出院*时间内模板未保存(模板保存时间超时算不合格)(唯一模板/可重复模板)
/// 结论: ret<0 出院*时间内模板未保存
/// 调试: w ##Class(web.DHCWMRQuality.BOACRExpBaseEpr).IsSaveTemByDischTime02(EpisodeID,EPRCatIDs,TemplateID,Hours)
/// ****************************************************************
ClassMethod IsSaveTemByDischTime02(EpisodeID As %String, EPRCatIDs As %String, TemplateID As %String, Hours As %String) As %String
{
	n (EpisodeID,EPRCatIDs,TemplateID,Hours)
	s ret=0
	q:(EpisodeID="")||(EPRCatIDs="")||(Hours="") ret
	
	s DateTime=##Class(web.DHCWMRQuality.BOACRExpBaseHis).GetInPatDateTime(EpisodeID)
	q:DateTime="" ret
	s DischDateTime=$list(DateTime,2)
	q:DischDateTime="" ret
	
	s Count=0,Count1=0
	f Ind=1:1:$listlength(EPRCatIDs) d
	.s EPRCatID=$p($list(EPRCatIDs,Ind),":",1)
	.s CheckCont=$p($list(EPRCatIDs,Ind),":",2)
	.s flg=..IsCheck(EpisodeID,CheckCont)
	.q:flg<0
	.s flg=##Class(web.DHCWMRQuality.BOACRExpBaseEpr).IsRightByCatalog(EpisodeID,EPRCatID,TemplateID)
	.q:flg<1   //无有效模板
	.
	.//模板超时未填写或填写时间超时
	.s tmpTemData=##Class(web.DHCWMRQuality.BOACRExpBaseEpr).GetTemplateData(EpisodeID,EPRCatID)
	.s tmpTime=$p(tmpTemData,"^",5)_" "_$p(tmpTemData,"^",6)
	.s:($p(tmpTemData,"^",5)="")||($p(tmpTemData,"^",6)="") tmpTime=$zd(+$h,3)_" "_$zt($p($h,",",2),2)
	.s:($p(tmpTemData,"^",8)="")||($p(tmpTemData,"^",8)="UnSave") tmpTime=$zd(+$h,3)_" "_$zt($p($h,",",2),2)
	.s tmpGap=##Class(web.DHCWMRQuality.BOACRExpBaseHis).GetDateTimeGap(tmpTime,DischDateTime)
	.s:tmpGap>(+Hours) ret=-1
	.s Count=Count+1
	.s:tmpGap<=(+Hours) Count1=Count1+1
	s:(ret=0)&&(Count>0)&&(Count=Count1) ret=1
	
	q ret
}

/// ****************************************************************
/// 说明: 入院*时间内模板未保存(模板保存时间超时算不合格)(唯一模板/可重复模板)
/// 结论: ret<0 入院*时间内模板未保存
/// 调试: w ##Class(web.DHCWMRQuality.BOACRExpBaseEpr).IsSaveTemByRegTime02(EpisodeID,EPRCatID,TemplateID,Hours)
/// ****************************************************************
ClassMethod IsSaveTemByRegTime02(EpisodeID As %String, EPRCatIDs As %String, TemplateID As %String, Hours As %String) As %String
{
	n (EpisodeID,EPRCatIDs,TemplateID,Hours)
	s ret=0
	q:(EpisodeID="")||(EPRCatIDs="")||(Hours="") ret
	
	s DateTime=##Class(web.DHCWMRQuality.BOACRExpBaseHis).GetInPatDateTime(EpisodeID)
	q:DateTime="" ret
	s RegDateTime=$list(DateTime,1)
	q:RegDateTime="" ret
	
	s Count=0,Count1=0
	f Ind=1:1:$listlength(EPRCatIDs) d
	.s EPRCatID=$p($list(EPRCatIDs,Ind),":",1)
	.s CheckCont=$p($list(EPRCatIDs,Ind),":",2)
	.s flg=..IsCheck(EpisodeID,CheckCont)
	.q:flg<0
	.s flg=##Class(web.DHCWMRQuality.BOACRExpBaseEpr).IsRightByCatalog(EpisodeID,EPRCatID,TemplateID)
	.q:flg<1   //无有效模板
	.
	.//模板超时未填写或填写时间超时
	.s tmpTemData=##Class(web.DHCWMRQuality.BOACRExpBaseEpr).GetTemplateData(EpisodeID,EPRCatID)
	.s tmpTime=$p(tmpTemData,"^",5)_" "_$p(tmpTemData,"^",6)
	.s:($p(tmpTemData,"^",5)="")||($p(tmpTemData,"^",6)="") tmpTime=$zd(+$h,3)_" "_$zt($p($h,",",2),2)
	.s:($p(tmpTemData,"^",8)="")||($p(tmpTemData,"^",8)="UnSave") tmpTime=$zd(+$h,3)_" "_$zt($p($h,",",2),2)
	.s tmpGap=##Class(web.DHCWMRQuality.BOACRExpBaseHis).GetDateTimeGap(tmpTime,RegDateTime)
	.s:tmpGap>(+Hours) ret=-1
	.s Count=Count+1
	.s:tmpGap<=(+Hours) Count1=Count1+1
	s:(ret=0)&&(Count>0)&&(Count=Count1) ret=1
	
	q ret
}

/// ****************************************************************
/// 说明: 出院*时间内模板未保存(模板保存时间超时算不合格)
/// 结论: ret<0 出院*时间内模板未保存
/// 调试: w ##Class(web.DHCWMRQuality.BOACRExpBaseEpr).IsSaveTemByDischTime03(EpisodeID,EPRCatIDs,TemplateID,Hours)
/// ****************************************************************
ClassMethod IsSaveTemByDischTime03(EpisodeID As %String, EPRCatIDs As %String, TemplateID As %String, Hours As %String) As %String
{
	n (EpisodeID,EPRCatIDs,TemplateID,Hours)
	s ret=0
	q:(EpisodeID="")||(EPRCatIDs="")||(Hours="") ret
	
	s Count1=0,Count2=0
	f Ind=1:1:$listlength(EPRCatIDs) q:ret=1  d
	.s tmpEPRCatIDs=$list(EPRCatIDs,Ind)
	.s flg=..IsSaveTemByDischTime01(EpisodeID,tmpEPRCatIDs,TemplateID,Hours)
	.s:flg>0 Count1=Count1+1  //已保存
	.s:flg<0 Count2=Count2+1  //未保存
	s:Count1>0 ret=1
	s:(Count1=0)&&(Count2>0) ret=-1
	
	q ret
}

/// ****************************************************************
/// 说明: 入院*时间内模板未保存(模板保存时间超时算不合格)
/// 结论: ret<0 入院*时间内模板未保存
/// 调试: w ##Class(web.DHCWMRQuality.BOACRExpBaseEpr).IsSaveTemByRegTime03(EpisodeID,EPRCatID,TemplateID,Hours)
/// ****************************************************************
ClassMethod IsSaveTemByRegTime03(EpisodeID As %String, EPRCatIDs As %String, TemplateID As %String, Hours As %String) As %String
{
	n (EpisodeID,EPRCatIDs,TemplateID,Hours)
	s ret=0
	q:(EpisodeID="")||(EPRCatIDs="")||(Hours="") ret
	
	s Count1=0,Count2=0
	f Ind=1:1:$listlength(EPRCatIDs) q:ret=1  d
	.s tmpEPRCatIDs=$list(EPRCatIDs,Ind)
	.s flg=..IsSaveTemByRegTime01(EpisodeID,tmpEPRCatIDs,TemplateID,Hours)
	.s:flg>0 Count1=Count1+1  //已保存
	.s:flg<0 Count2=Count2+1  //未保存
	s:Count1>0 ret=1
	s:(Count1=0)&&(Count2>0) ret=-1
	
	q ret
}

/// ****************************************************************
/// 说明: 出院*时间内模板未保存(模板保存时间超时算不合格)
/// 结论: ret<0 出院*时间内模板未保存
/// 调试: w ##Class(web.DHCWMRQuality.BOACRExpBaseEpr).IsSaveTemByDischTime04(EpisodeID,EPRCatIDs,TemplateID,Hours)
/// ****************************************************************
ClassMethod IsSaveTemByDischTime04(EpisodeID As %String, EPRCatIDs As %String, TemplateID As %String, Hours As %String) As %String
{
	n (EpisodeID,EPRCatIDs,TemplateID,Hours)
	s ret=0
	q:(EpisodeID="")||(EPRCatIDs="")||(Hours="") ret
	
	s Count1=0,Count2=0
	f Ind=1:1:$listlength(EPRCatIDs) q:ret=1  d
	.s tmpEPRCatIDs=$list(EPRCatIDs,Ind)
	.s flg=..IsSaveTemByDischTime02(EpisodeID,tmpEPRCatIDs,TemplateID,Hours)
	.s:flg>0 Count1=Count1+1  //已保存
	.s:flg<0 Count2=Count2+1  //未保存
	s:Count1>0 ret=1
	s:(Count1=0)&&(Count2>0) ret=-1
	
	q ret
}

/// ****************************************************************
/// 说明: 入院*时间内模板未保存(模板保存时间超时算不合格)
/// 结论: ret<0 入院*时间内模板未保存
/// 调试: w ##Class(web.DHCWMRQuality.BOACRExpBaseEpr).IsSaveTemByRegTime04(EpisodeID,EPRCatID,TemplateID,Hours)
/// ****************************************************************
ClassMethod IsSaveTemByRegTime04(EpisodeID As %String, EPRCatIDs As %String, TemplateID As %String, Hours As %String) As %String
{
	n (EpisodeID,EPRCatIDs,TemplateID,Hours)
	s ret=0
	q:(EpisodeID="")||(EPRCatIDs="")||(Hours="") ret
	
	s Count1=0,Count2=0
	f Ind=1:1:$listlength(EPRCatIDs) q:ret=1  d
	.s tmpEPRCatIDs=$list(EPRCatIDs,Ind)
	.s flg=..IsSaveTemByRegTime02(EpisodeID,tmpEPRCatIDs,TemplateID,Hours)
	.s:flg>0 Count1=Count1+1  //已保存
	.s:flg<0 Count2=Count2+1  //未保存
	s:Count1>0 ret=1
	s:(Count1=0)&&(Count2>0) ret=-1
	
	q ret
}

/// ****************************************************************
/// 说明: 是否创建或保存模板(唯一模板/可重复模板)
/// 结论: ret<0 模板未保存
/// 调试: w ##Class(web.DHCWMRQuality.BOACRExpBaseEpr).IsSaveTemplate(EpisodeID,EPRCatID,TemplateID)
/// ****************************************************************
ClassMethod IsSaveTemplate(EpisodeID As %String, EPRCatID As %String, TemplateID As %String) As %String
{
	n (EpisodeID,EPRCatID,TemplateID)
	s ret=0
	q:(EpisodeID="")||(EPRCatID="") ret
	
	//没有对应模板
	s flg=##Class(web.DHCWMRQuality.BOACRExpBaseEpr).IsRightByCatalog(EpisodeID,EPRCatID,TemplateID)
	q:flg<1 ret
	
	//未创建模板或保存模板
	s ret=-1
	s tmpTemData=##Class(web.DHCWMRQuality.BOACRExpBaseEpr).GetTemplateData(EpisodeID,EPRCatID)
	q:($p(tmpTemData,"^",1)="")||($p(tmpTemData,"^",8)="UnSave")||($p(tmpTemData,"^",8)="") ret
	
	//模板已创建
	s ret=1
	q ret
}

///  *****************************************************
///  功能: 模板单元完整性检查(唯一模板/可重复模板)
///  结论：ret<0 模板单元未填写或填写错误
///  调试: w ##Class(web.DHCWMRQuality.BOACRExpBaseEpr).IsSaveElement(EpisodeID, EPRCatID, EPRElID, TemplateID, InstanceID)
///  *****************************************************
ClassMethod IsSaveElement(EpisodeID As %String, EPRCatID As %String, EPRElID As %String, TemplateID As %String, InstanceID As %String) As %String
{
	n (EpisodeID,EPRCatID,EPRElID,TemplateID,InstanceID)
	s ret=0
	q:(EpisodeID="")||(EPRCatID="")||(EPRElID="") ret
	
	//无有效模板单元,不检查
	s flg=##Class(web.DHCWMRQuality.BOACRExpBaseEpr).IsRightByElement(EpisodeID,EPRCatID,EPRElID,TemplateID)
	q:flg<1 ret
	//有有效模板单元,无检查内容,不检查
	s ret=0
	s tmp=$g(^DHCWMREPRTEM(+EPRElID))
	s ElementCode=$p(tmp,"^",2)    //模板单元Code
	s IsNull=$p(tmp,"^",4)         //是否允许为空
	s AllowValue=$p(tmp,"^",5)     //允许填写内容  多个值"|"分割
	s DisallowValue=$p(tmp,"^",6)  //不允许填写内容  多个值"|"分割
	q:((IsNull="Y")&&(AllowValue="")&&(DisallowValue="")) ret   //无检查内容、不需要检查 "Y"表示可以为空
	
	//模板单元完整性检查
	s tmpElData=##Class(web.DHCWMRQuality.BOACRExpBaseEpr).GetElementData(EpisodeID,EPRElID,InstanceID)
	s tmpElData=##Class(web.DHCWMRQuality.BOACRExpBaseHis).ClearUselessChar(tmpElData," /-")
	s ret=1
	f Ind=1:1:$listlength(tmpElData) d
	.s tmpData=$list(tmpElData,Ind)
	.s:(IsNull'="Y")&&(tmpData="") ret=-1   //不允许为空、模板单元值为空
	.s:(tmpData'="")&&(AllowValue'="")&&(("|"_AllowValue_"|")'[("|"_tmpData_"|")) ret=-1    //有限定允许填写值、模板单元值不在限定范围内
	.s:(tmpData'="")&&(DisallowValue'="")&&(("|"_DisallowValue_"|")[("|"_tmpData_"|")) ret=-1    //有限定不允许填写值、模板单元值在限定范围内
	
	q ret
}

/// ****************************************************************
/// 说明          : 取模板保存结果(唯一模板/可重复模板)
/// 入参          : 
/// EpisodeID     : 就诊号
/// EPRCatID      : 目录维护表ID
/// 调试          : w ##Class(web.DHCWMRQuality.BOACRExpBaseEpr).GetTemplateData(EpisodeID,EPRCatID)
/// ****************************************************************
ClassMethod GetTemplateData(EpisodeID As %String, EPRCatID As %String) As %String
{
	n (EpisodeID,EPRCatID)
	s ret=""
	q:(EpisodeID="")||(EPRCatID="") ret
	
	s tmp1=$g(^DHCWMREPRCAT(EPRCatID))
	q:tmp1="" ret
	q:$p(tmp1,"^",4)'="Y" ret
	s MountCategoryId=$p(tmp1,"^",1),CategoryId=$p(tmp1,"^",2)
	s:CategoryId="" CategoryId=MountCategoryId
	q:(MountCategoryId="")||(CategoryId="") ret
	//s MountCategoryId=CategoryId  //update by zf 20090915 还需要跟电子病历组确认下
	s tmp2=##class(EPRservice.BOInstanceData).GetSingleDataInfoByCateID(EpisodeID,MountCategoryId,CategoryId)
	s tmp2=$tr(tmp2,$c(1),"^")
	q:(tmp2="")||($p(tmp2,"^",1)="") ret
	
	s ret=tmp2
	q ret
}

/// ****************************************************************
/// 说明          : 取模板单元保存结果(唯一模板/可重复模板)
/// 入参          : 
/// EpisodeID     : 就诊号
/// EPRElID       : 模板单元维护表ID
/// InstanceID    : InstanceID $lb()
/// 调试          : w ##Class(web.DHCWMRQuality.BOACRExpBaseEpr).GetElementData(EpisodeID,EPRElID,InstanceID)
/// ****************************************************************
ClassMethod GetElementData(EpisodeID As %String, EPRElID As %String, InstanceID As %String) As %String
{
	n (EpisodeID,EPRElID,InstanceID)
	s ret=""
	q:(EpisodeID="")||(EPRElID="") ret
	
	s tmp1=$g(^DHCWMREPRTEM(EPRElID))
	q:$p(tmp1,"^",7)'="Y" ret
	s TemplateID=$p(tmp1,"^",1)
	s ElementCode=$p(tmp1,"^",2)
	q:(TemplateID="")||(ElementCode="") ret
	s objTemplate=##class(EPRmeta.Template).%OpenId(TemplateID)
	q:objTemplate="" ret
	s ChartItemType=objTemplate.ChartItemType
	i ChartItemType="Single" d   //唯一模板
	.s tmpData=##class(EPRservice.BOScatterData).GetEPRData(EpisodeID,ElementCode)
	.s ret=ret_$lb(tmpData)
	i ChartItemType="Multiple" d   //可重复模板
	.f Ind=1:1:$listlength(InstanceID) d
	..s tmpID=$list(InstanceID,Ind)
	..s tmpData=##class(EPRservice.BOScatterData).GetEPRMultipleData(EpisodeID,ElementCode,tmpID)
	..s ret=ret_$lb(tmpData)
	
	q ret
}

/// ****************************************************************
/// 说明          : 取模板保存结果(唯一模板/可重复模板)
/// 入参          : 
/// EpisodeID     : 就诊号
/// EPRCatName    : 目录标准名称
/// 调试          : w ##Class(web.DHCWMRQuality.BOACRExpBaseEpr).GetTemplateDataByName(EpisodeID,EPRCatName)
/// ****************************************************************
ClassMethod GetTemplateDataByName(EpisodeID As %String, EPRCatName As %String) As %String
{
	n (EpisodeID,EPRCatName)
	s ret=""
	q:(EpisodeID="")||(EPRCatName="") ret
	
	s tmp1=##Class(web.DHCWMRQuality.BOACRExpBaseConfig).GetEPRCatalog(EPRCatName)
	q:tmp1="" ret
	q:$p(tmp1,"^",4)'="Y" ret
	s MountCategoryId=$p(tmp1,"^",1),CategoryId=$p(tmp1,"^",2)
	s:CategoryId="" CategoryId=MountCategoryId
	q:(MountCategoryId="")||(CategoryId="") ret
	s tmp2=##class(EPRservice.BOInstanceData).GetSingleDataInfoByCateID(EpisodeID,MountCategoryId,CategoryId)
	s tmp2=$tr(tmp2,$c(1),"^")
	q:(tmp2="")||($p(tmp2,"^",1)="") ret
	
	s ret=tmp2
	q ret
}

/// ****************************************************************
/// 说明          : 取模板单元保存结果(唯一模板/可重复模板)
/// 入参          : 
/// EpisodeID     : 就诊号
/// EPRCatName    : 目录标准名称
/// EPRElName     : 模板单元标准名称
/// InstanceID    : InstanceID $lb()
/// 调试          : w ##Class(web.DHCWMRQuality.BOACRExpBaseEpr).GetElementDataByName(EpisodeID,EPRCatName,EPRElName,InstanceID)
/// ****************************************************************
ClassMethod GetElementDataByName(EpisodeID As %String, EPRCatName As %String, EPRElName As %String, InstanceID As %String) As %String
{
	n (EpisodeID,EPRCatName,EPRElName,InstanceID)
	s ret=""
	q:(EpisodeID="")||(EPRCatName="")||(EPRElName="") ret
	
	s TemplateID=$p(..GetTemplateDataByName(EpisodeID,EPRCatName),"^",1)
	q:TemplateID="" ret
	s tmp1=##Class(web.DHCWMRQuality.BOACRExpBaseConfig).GetEPRTemplate(TemplateID,EPRElName)
	q:$p(tmp1,"^",7)'="Y" ret
	s TemplateID=$p(tmp1,"^",1)
	s ElementCode=$p(tmp1,"^",2)
	q:(TemplateID="")||(ElementCode="") ret
	s objTemplate=##class(EPRmeta.Template).%OpenId(TemplateID)
	q:objTemplate="" ret
	s ChartItemType=objTemplate.ChartItemType
	i ChartItemType="Single" d   //唯一模板
	.s tmpData=##class(EPRservice.BOScatterData).GetEPRData(EpisodeID,ElementCode)
	.s ret=ret_$lb(tmpData)
	i ChartItemType="Multiple" d   //可重复模板
	.f Ind=1:1:$listlength(InstanceID) d
	..s tmpID=$list(InstanceID,Ind)
	..s tmpData=##class(EPRservice.BOScatterData).GetEPRMultipleData(EpisodeID,ElementCode,tmpID)
	..s ret=ret_$lb(tmpData)
	
	q ret
}

/// ****************************************************************
/// 说明          : 检查目录标准名称的合法性
/// 入参          : 
/// EpisodeID     : 就诊号
/// CatNormName   : 目录标准名称
/// TemplateID    : 检查模板ID
/// 返回值        ："-1":无有效模板  "0":数据问题  "1":存在有效模板
/// 调试          : w ##Class(web.DHCWMRQuality.BOACRExpBaseEpr).IsRightCatNormName(EpisodeID,CatNormName,TemplateID)
/// ****************************************************************
ClassMethod IsRightCatNormName(EpisodeID As %String, CatNormName As %String, TemplateID As %String) As %String
{
	n (EpisodeID,CatNormName,TemplateID)
	s ret=0
	q:(EpisodeID="")||(CatNormName="") ret
	s ret=-1
	s tmp=..GetTemplateDataByName(EpisodeID,CatNormName)
	q:(tmp="")||($p(tmp,"^",1)="") ret   //无对应模板
	q:((TemplateID'="")&&($listfind(TemplateID,$p(tmp,"^",1))=0)) ret   //与检查模板不一致
	s ret=1
	q ret
}

/// ****************************************************************
/// 说明          : 检查模板单元标准名称的合法性
/// 入参          : 
/// EpisodeID     : 就诊号
/// CatNormName   : 目录标准名称
/// ElNormName    : 单元标准名称
/// TemplateID    : 检查模板ID
/// 返回值        ："-2":无有效单元  "-1":无有效模板  "0":数据问题  "1":存在有效单元
/// 调试          : w ##Class(web.DHCWMRQuality.BOACRExpBaseEpr).IsRightElNormName(EpisodeID,CatNormName,ElNormName,TemplateID)
/// ****************************************************************
ClassMethod IsRightElNormName(EpisodeID As %String, CatNormName As %String, ElNormName As %String, TemplateID As %String) As %String
{
	n (EpisodeID,CatNormName,ElNormName,TemplateID)
	s ret=0
	q:(EpisodeID="")||(CatNormName="")||(ElNormName="") ret
	
	s ret=-1
	s tmp=..GetTemplateDataByName(EpisodeID,CatNormName)
	q:(tmp="")||($p(tmp,"^",1)="") ret   //无对应模板
	q:((TemplateID'="")&&($listfind(TemplateID,$p(tmp,"^",1))=0)) ret   //与检查模板不一致
	
	s ret=-2
	s TemplateID=$p(tmp,"^",1)
	s tmp=##Class(web.DHCWMRQuality.BOACRExpBaseConfig).GetEPRTemplate(TemplateID,ElNormName)
	q:(tmp="")||($p(tmp,"^",2)="") ret    //无此模板单元、不需要检查
	q:$p(tmp,"^",7)'="Y" ret
	
	s ret=1
	q ret
}

/// ****************************************************************
/// 说明          : 检查目录标准名称的合法性
/// 入参          : 
/// EpisodeID     : 就诊号
/// EPRCatID      : 目录维护表ID
/// TemplateID    : 检查模板ID
/// 返回值        ："-1":无有效模板  "0":参数不合法  "1":存在有效模板
/// 调试          : w ##Class(web.DHCWMRQuality.BOACRExpBaseEpr).IsRightByCatalog(EpisodeID,EPRCatID,TemplateID)
/// ****************************************************************
ClassMethod IsRightByCatalog(EpisodeID As %String, EPRCatID As %String, TemplateID As %String) As %String
{
	n (EpisodeID,EPRCatID,TemplateID)
	//参数不合法
	s ret=0
	q:(EpisodeID="")||(EPRCatID="") ret
	s tmp1=$g(^DHCWMREPRCAT(EPRCatID))
	q:tmp1="" ret
	q:$p(tmp1,"^",4)'="Y" ret
	s MountCategoryId=$p(tmp1,"^",1),CategoryId=$p(tmp1,"^",2)
	s:CategoryId="" CategoryId=MountCategoryId
	q:(MountCategoryId="")||(CategoryId="") ret
	//无有效模板
	s ret=-1
	s tmp2=##class(EPRservice.BOInstanceData).GetSingleDataInfoByCateID(EpisodeID,MountCategoryId,CategoryId)
	s tmp2=$tr(tmp2,$c(1),"^")
	q:(tmp2="")||($p(tmp2,"^",1)="") ret
	q:((TemplateID'="")&&($listfind(TemplateID,$p(tmp2,"^",1))=0)) ret   //与检查模板不一致
	//有有效模板
	s ret=1
	q ret
}

/// ****************************************************************
/// 说明          : 检查模板单元标准名称的合法性
/// 入参          : 
/// EpisodeID     : 就诊号
/// CatNormName   : 目录标准名称
/// ElNormName    : 单元标准名称
/// TemplateID    : 检查模板ID
/// 返回值        ："-2":无有效单元  "-1":无有效模板  "0":参数不合法  "1":存在有效单元
/// 调试          : w ##Class(web.DHCWMRQuality.BOACRExpBaseEpr).IsRightByElement(EpisodeID,EPRCatID,EPRElID,TemplateID)
/// ****************************************************************
ClassMethod IsRightByElement(EpisodeID As %String, EPRCatID As %String, EPRElID As %String, TemplateID As %String) As %String
{
	n (EpisodeID,EPRCatID,EPRElID,TemplateID)
	//参数不合法
	s ret=0
	q:(EpisodeID="")||(EPRCatID="")||(EPRElID="") ret
	
	//1.EPR模板单元数据无效
	s tmp2=$g(^DHCWMREPRTEM(EPRElID))
	q:(tmp2="")||($p(tmp2,"^",2)="") ret
	q:($p(tmp2,"^",7)'="Y") ret
	q:((TemplateID'="")&&($listfind(TemplateID,$p(tmp2,"^",1))=0)) ret  //与检查模板不一致
	//2.EPR目录数据无效
	s tmp=$g(^DHCWMREPRCAT(EPRCatID))
	q:tmp="" ret
	q:$p(tmp,"^",4)'="Y" ret
	s MountCategoryId=$p(tmp,"^",1),CategoryId=$p(tmp,"^",2)
	s:CategoryId="" CategoryId=MountCategoryId
	q:(MountCategoryId="")||(CategoryId="") ret
	//3.无有效模板
	s ret=-1
	s tmp1=##class(EPRservice.BOInstanceData).GetSingleDataInfoByCateID(EpisodeID,MountCategoryId,CategoryId)
	s tmp1=$tr(tmp1,$c(1),"^")
	q:(tmp1="")||($p(tmp1,"^",1)="") ret
	q:((TemplateID'="")&&($listfind(TemplateID,$p(tmp1,"^",1))=0)) ret   //与检查模板不一致
	//4.检查模板与保存模板不一致
	s ret=-2
	q:($p(tmp2,"^",1)'=$p(tmp1,"^",1)) ret
	//5.有有效模板单元
	s ret=1
	q ret
}

/// ************************************************************
/// **************************没事不要做************************
/// ************************************************************
/// 
/// 做数据生成模板单元完整性控制的ACRExp和EntryDic
/// w ##Class(web.DHCWMRQuality.BOACRExpBaseEpr).ProcessData()
ClassMethod ProcessData()
{
    n
	
	//备份数据 一天只备份最新的一次
    s tmpDate=$zd(+$h,3)
    k:$d(^DHCWMRACRBAK1(tmpDate)) ^DHCWMRACRBAK1(tmpDate)
    m ^DHCWMRACRBAK1(tmpDate)=^DHCWMRACR
    k:$d(^DHCWMREDICBAK1(tmpDate)) ^DHCWMREDICBAK1(tmpDate)
    m ^DHCWMREDICBAK1(tmpDate)=^DHCWMREDIC
    k:$d(^DHCWMRERBAK1(tmpDate)) ^DHCWMRERBAK1(tmpDate)
    m ^DHCWMRERBAK1(tmpDate)=^DHCWMRER
    k:$d(^DHCWMREPRTEMBAK1(tmpDate)) ^DHCWMREPRTEMBAK1(tmpDate)
    m ^DHCWMREPRTEMBAK1(tmpDate)=^DHCWMREPRTEM
    
    Set Config=##Class(websys.Configuration).%OpenId(1)
    Set MEDDATA=Config.DataNamespace
    Set LABDATA=Config.LabDataNamespace
    Set CurrentNS=$ZNSPACE
    d Config.%Close()
    
    zn MEDDATA
    s ^mdata("DHCWMRAUTOCHECKRULE")=(+$o(^DHCWMRACR(""),-1))
    s FromID=(+$o(^DHCWMRACR(""),-1))
    s:FromID=0 FromID=1
    s ToID=(+$o(^DHCWMREPRTEM(""),-1))+2000
    i FromID<ToID d
    .f Ind=FromID:1:ToID d
	..s RRowid=Ind
	..s RExp="Z"_$c(4)_"0"_$c(4)_"="_$c(4)_"0"
    ..s InPut=""_"^"_"备用"_RRowid_"^"_RExp_"^"_"N"_"^"_""
    ..s ret=$$UpdateACRule^DHCWMRExamRule(InPut)
    ..w:(ret'=RRowid) !,"RRet="_ret_"!RInPut="_InPut
	
	s ^mdata("DHCWMRENTRYDIC")=(+$o(^DHCWMREDIC(""),-1))
    s FromID=(+$o(^DHCWMREDIC(""),-1))
    s:FromID=0 FromID=1
    s ToID=(+$o(^DHCWMREPRTEM(""),-1))+2000
    i FromID<ToID d
    .f Ind=FromID:1:ToID d
	..s ERowid=Ind
	..s ECode="D"
	..s ETitle="备用"_ERowid
	..s EEntryType=19
	..s EIsActive="N"
	..s EResumeText=""
    ..s InPut=""_"^"_ECode_"^"_ETitle_"^"_EEntryType_"^"_EIsActive_"^"_EResumeText
    ..s ret=$$UpdateEntryDic^DHCWMRQualityDic(InPut)
    ..w:(ret'=ERowid) !,"ERet="_ret_"!EInPut="_InPut
	zn CurrentNS
	
	s tmpStr="00000"
    s ret=0,EndID=$o(^DHCWMREPRTEM(""),-1)
    f Ind=1:1:EndID d
    .s EPRCatID=""
    .s tmpElement=$g(^DHCWMREPRTEM(Ind))
    .i tmpElement'="" d
    ..s TemplateID=$p(tmpElement,"^",1)
    ..q:TemplateID=""
	..s objTemplate=##class(EPRmeta.Template).%OpenId(TemplateID)
	..q:objTemplate=""
	..s CategoryID=objTemplate.TemplateCategoryID
	..q:CategoryID=""
	..s MCategoryID=CategoryID
	..i '$d(^DHCWMREPRCAT(0,"CatSub",MCategoryID,CategoryID)) d
	...s objCat=##class(EPRmeta.TemplateCategory).%OpenId(CategoryID)
	...q:objCat=""
	...s MCategoryID=objCat.ParentID
	...q:MCategoryID=""
	...q:'$d(^DHCWMREPRCAT(0,"CatSub",MCategoryID,CategoryID))
	...s EPRCatID=$o(^DHCWMREPRCAT(0,"CatSub",MCategoryID,CategoryID,"Y",0))
	..e  d
	...s EPRCatID=$o(^DHCWMREPRCAT(0,"CatSub",MCategoryID,CategoryID,"Y",0))
	.s RRowid=Ind+2000
	.s ERowid=Ind+2000
	.i (EPRCatID="")||($p(tmpElement,"^",7)'="Y")||($p(tmpElement,"^",4)="Y") d
	..s RExp="Z"_$c(4)_"0"_$c(4)_"="_$c(4)_"0"
	..s ECode="D"_$e(tmpStr,1,5-$l(ERowid))_ERowid
	..s ETitle=$p(tmpElement,"^",3)_"未填或填写错误 请及时填写或更正!"
	..s EEntryType=19
	..s EIsActive="N"
	..s EResumeText="(R"_ERowid_")"
    ..zn MEDDATA
    ..s InPut=RRowid_"^"_$p(tmpElement,"^",3)_"未填或填写错误"_"^"_RExp_"^"_"N"_"^"_""
    ..s ret=$$UpdateACRule^DHCWMRExamRule(InPut)
    ..w:(ret'=RRowid) !,"RRet="_ret_"!RInPut="_InPut
    ..s InPut=ERowid_"^"_ECode_"^"_ETitle_"^"_EEntryType_"^"_EIsActive_"^"_EResumeText
    ..s ret=$$UpdateEntryDic^DHCWMRQualityDic(InPut)
    ..w:(ret'=ERowid) !,"ERet="_ret_"!EInPut="_InPut
	..zn CurrentNS
	.e  d
	..s RExp="Z"_$c(4)_"##Class(web.DHCWMRQuality.BOACRExpBaseEpr).IsSaveElement(EpisodeID,"_EPRCatID_","_Ind_",TemplateID,InstanceID)"_$c(4)_"<"_$c(4)_"0"
	..s RExp=$tr(RExp,"^","`")
	..s RDesc=$p(tmpElement,"^",3)_"未填或填写错误"
	..s ECode="D"_$e(tmpStr,1,5-$l(ERowid))_ERowid
	..s ETitle=$p(tmpElement,"^",3)_"未填或填写错误 请及时填写或更正!"
	..s EEntryType=19
	..s EIsActive="Y"
	..s EResumeText="(R"_ERowid_")"
    ..zn MEDDATA
    ..s InPut=RRowid_"^"_RDesc_"^"_RExp_"^"_"Y"_"^"_""
    ..s ret=$$UpdateACRule^DHCWMRExamRule(InPut)
    ..w:(ret'=RRowid) !,"RRet="_ret_"!RInPut="_InPut
    ..s InPut=ERowid_"^"_ECode_"^"_ETitle_"^"_EEntryType_"^"_EIsActive_"^"_EResumeText
    ..s ret=$$UpdateEntryDic^DHCWMRQualityDic(InPut)
    ..w:(ret'=ERowid) !,"ERet="_ret_"!EInPut="_InPut
	..zn CurrentNS
	
	s ^mdata("DHCWMRAUTOCHECKRULE")=0
	s ^mdata("DHCWMRENTRYDIC")=0
	q "Import Over!"
}

}
