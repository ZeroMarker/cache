Import SQLUser

/// *****************************************************
/// CLASS说明:取唯一模板数据,质量控制ACR函数
/// *****************************************************
Class web.DHCWMRQuality.BOACRExpEprSingle Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 11;

/// ****************************************************************
/// 说明          : 是否创建或保存唯一模板
/// 入参          : 
/// EpisodeID     : 就诊号
/// CatNormName   : 目录标准名称
/// TemplateID    ：要检查模板ID LIST
/// 返回值        ：
/// ret           ：“ret<0”模板未创建、“ret=0”不需要检查、“ret>0”模板已创建
/// 调试          : w ##Class(web.DHCWMRQuality.BOACRExpEprSingle).IsSaveTem(EpisodeID,CatNormName,TemplateID)
/// ****************************************************************
ClassMethod IsSaveTem(EpisodeID As %String, CatNormName As %String, TemplateID As %String) As %String
{
	n (EpisodeID,CatNormName,TemplateID)
	
	//没有对应模板
	s ret=0
	s flg=##Class(web.DHCWMRQuality.BOACRExpBaseEpr).IsRightCatNormName(EpisodeID,CatNormName,TemplateID)
	q:flg<1 ret
	
	//未创建模板或保存模板
	s ret=-1
	s tmpTemData=##Class(web.DHCWMRQuality.BOACRExpBaseEpr).GetTemplateDataByName(EpisodeID,CatNormName)
	q:($p(tmpTemData,"^",1)="")||($p(tmpTemData,"^",8)="UnSave")||($p(tmpTemData,"^",8)="") ret
	
	//模板已创建
	s ret=1
	q ret
}

/// ****************************************************************
/// 说明          : 模板已创建的前提下检查模板单元是否填写或填写错误
/// 入参          : 
/// EpisodeID     : 就诊号
/// CatNormName   : 目录标准名称
/// ElNormName    : 单元标准名称
/// TemplateID    ：要检查模板ID
/// 返回值        ：
/// ret           ：“ret<0”模板单元未填或填写错误、“ret=0”不需要检查、“ret>0”模板单元已填
/// 调试          : w ##Class(web.DHCWMRQuality.BOACRExpEprSingle).IsSaveTemEl(EpisodeID,CatNormName,ElNormName,TemplateID)
/// ****************************************************************
ClassMethod IsSaveTemEl(EpisodeID As %String, CatNormName As %String, ElNormName As %String, TemplateID As %String) As %String
{
	n (EpisodeID,CatNormName,ElNormName,TemplateID)
	
	//是否有对应模板单元
	s ret=0
	s flg=##Class(web.DHCWMRQuality.BOACRExpBaseEpr).IsRightElNormName(EpisodeID,CatNormName,ElNormName,TemplateID)
	q:flg<1 ret
	
	//是否需要检查非空,非法值,合法值
	s TemplateID=$p(##Class(web.DHCWMRQuality.BOACRExpBaseEpr).GetTemplateDataByName(EpisodeID,CatNormName),"^",1)
	s tmp=##Class(web.DHCWMRQuality.BOACRExpBaseEpr).GetEPRTemplate(TemplateID,ElNormName)
	s IsNull=$p(tmp,"^",4)         //是否允许为空
	s AllowValue=$p(tmp,"^",5)     //允许填写内容  多个值"|"分割
	s DisallowValue=$p(tmp,"^",6)  //不允许填写内容  多个值"|"分割
	q:(IsNull="Y")&&(AllowValue="")&&(DisallowValue="") ret   //无检查内容、不需要检查 "Y"表示可以为空
	
	//检查模板单元值的非空,非法值,合法值
	s ret=-1
	s tmpElData=##Class(web.DHCWMRQuality.BOACRExpBaseEpr).GetElementDataByName(EpisodeID,CatNormName,ElNormName,"")
	q:(IsNull'="Y")&&(tmpElData="") ret   //不允许为空、模板单元值为空
	q:(tmpElData'="")&&(AllowValue'="")&&(("|"_AllowValue_"|")'[("|"_tmpElData_"|")) ret    //有限定允许填写值、模板单元值不在限定范围内
	q:(tmpElData'="")&&(DisallowValue'="")&&(("|"_DisallowValue_"|")[("|"_tmpElData_"|")) ret    //有限定不允许填写值、模板单元值在限定范围内
	
	//模板单元值填写正确
	s ret=1
	q ret
}

/// ****************************************************************
/// 说明          : 唯一模板保存一致性检查(模板是否保存和HIS数据一致性检查)
///               : 例：已婚人员才填婚育史模板
/// 入参          : 
/// EpisodeID     : 就诊号
/// UnifyCode     : 一致性编码
/// CatNormName   : 目录标准名称
/// DataCode      ：数据编码
/// TemplateID    : 检查模板ID
/// 返回值        ：
/// ret           ：“ret<0”不一致、“ret=0”不需要检查、“ret>0”一致
/// 调试          : w ##Class(web.DHCWMRQuality.BOACRExpEprSingle).IsUnifyTem01(EpisodeID,UnifyCode,CatNormName,DataCode,TemplateID)
/// ****************************************************************
ClassMethod IsUnifyTem01(EpisodeID As %String, UnifyCode As %String, CatNormName As %String, DataCode As %String, TemplateID As %String) As %String
{
	n (EpisodeID,UnifyCode,CatNormName,DataCode,TemplateID)
	s ret=0
	q:(EpisodeID="")||(UnifyCode="")||(CatNormName="")||(DataCode="") ret
	s flg=##Class(web.DHCWMRQuality.BOACRExpBaseEpr).IsRightCatNormName(EpisodeID,CatNormName,TemplateID)
	q:flg<1 ret
	s tmpValue1=##Class(web.DHCWMRQuality.BOACRExpEprSingle).IsSaveTem(EpisodeID,CatNormName,TemplateID)
	s tmpValue2=##Class(web.DHCWMRQuality.BOACRExpBaseArg).GetDataByCode(EpisodeID,DataCode,"","","")  //HIS数据
	s ret=##Class(web.DHCWMRQuality.BOACRExpBaseArg).IsUnifyByCode(UnifyCode,tmpValue1,tmpValue2)
	q ret
}

/// ****************************************************************
/// 说明          : 唯一模板单元一致性检查(两模板单元一致性检查)
/// 入参          : 
/// EpisodeID     : 就诊号
/// UnifyCode     : 一致性编码
/// CatNormName1  : 目录标准名称1
/// ElNormName1   ：单元标准名称1
/// CatNormName2  : 目录标准名称2
/// ElNormName2   ：单元标准名称2
/// TemplateID    : 检查模板ID
/// 返回值        ：
/// ret           ：“ret<0”不一致、“ret=0”不需要检查、“ret>0”一致
/// 调试          : w ##Class(web.DHCWMRQuality.BOACRExpEprSingle).IsUnifyTemEl01(EpisodeID,UnifyCode,CatNormName1,ElNormName1,CatNormName2,ElNormName2,TemplateID)
/// ****************************************************************
ClassMethod IsUnifyTemEl01(EpisodeID As %String, UnifyCode As %String, CatNormName1 As %String, ElNormName1 As %String, CatNormName2 As %String, ElNormName2 As %String, TemplateID As %String) As %String
{
	n (EpisodeID,UnifyCode,CatNormName1,ElNormName1,CatNormName2,ElNormName2,TemplateID)
	s ret=0
	q:(EpisodeID="")||(UnifyCode="") ret
	q:(CatNormName1="")||(ElNormName1="") ret
	q:(CatNormName2="")||(ElNormName2="") ret
	s flg1=##Class(web.DHCWMRQuality.BOACRExpBaseEpr).IsRightElNormName(EpisodeID,CatNormName1,ElNormName1,TemplateID)
	s flg11=##Class(web.DHCWMRQuality.BOACRExpBaseEpr).IsRightElNormName(EpisodeID,CatNormName1,ElNormName1,"")
	s flg2=##Class(web.DHCWMRQuality.BOACRExpBaseEpr).IsRightElNormName(EpisodeID,CatNormName2,ElNormName2,TemplateID)
	s flg22=##Class(web.DHCWMRQuality.BOACRExpBaseEpr).IsRightElNormName(EpisodeID,CatNormName2,ElNormName2,"")
	q:((flg1<1)&&(flg22<1))&&((flg11<1)&&(flg2<1)) ret
	s tmpValue1=##Class(web.DHCWMRQuality.BOACRExpBaseEpr).GetElementDataByName(EpisodeID,CatNormName1,ElNormName1,"")
	s tmpValue2=##Class(web.DHCWMRQuality.BOACRExpBaseEpr).GetElementDataByName(EpisodeID,CatNormName2,ElNormName2,"")
	s ret=##Class(web.DHCWMRQuality.BOACRExpBaseArg).IsUnifyByCode(UnifyCode,tmpValue1,tmpValue2)
	q ret
}

/// ****************************************************************
/// 说明          : 唯一模板单元一致性检查(模板单元和HIS数据一致性检查)
/// 入参          : 
/// EpisodeID     : 就诊号
/// UnifyCode     : 一致性编码
/// CatNormName   : 目录标准名称1
/// ElNormName    ：单元标准名称1
/// DataCode      : 数据编码
/// TemplateID    : 检查模板ID
/// 返回值        ：
/// ret           ：“ret<0”不一致、“ret=0”不需要检查、“ret>0”一致
/// 调试          : w ##Class(web.DHCWMRQuality.BOACRExpEprSingle).IsUnifyTemEl02(EpisodeID,UnifyCode,CatNormName,ElNormName,DataCode,TemplateID)
/// ****************************************************************
ClassMethod IsUnifyTemEl02(EpisodeID As %String, UnifyCode As %String, CatNormName As %String, ElNormName As %String, DataCode As %String, TemplateID As %String) As %String
{
	n (EpisodeID,UnifyCode,CatNormName,ElNormName,DataCode,TemplateID)
	s ret=0
	q:(EpisodeID="")||(UnifyCode="")||(DataCode="") ret
	q:(CatNormName="")||(ElNormName="") ret
	s flg1=##Class(web.DHCWMRQuality.BOACRExpBaseEpr).IsRightElNormName(EpisodeID,CatNormName,ElNormName,TemplateID)
	q:flg1<1 ret
	s tmpValue1=##Class(web.DHCWMRQuality.BOACRExpBaseEpr).GetElementDataByName(EpisodeID,CatNormName,ElNormName,"")
	s tmpValue2=##Class(web.DHCWMRQuality.BOACRExpBaseArg).GetDataByCode(EpisodeID,DataCode,"","","")  //HIS数据
	s ret=##Class(web.DHCWMRQuality.BOACRExpBaseArg).IsUnifyByCode(UnifyCode,tmpValue1,tmpValue2)
	q ret
}

}
