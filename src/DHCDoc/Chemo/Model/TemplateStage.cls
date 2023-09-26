/// CTOR: QP
/// DATE: 2020-06-11
/// DESC: 模板周期
Class DHCDoc.Chemo.Model.TemplateStage Extends %RegisteredObject
{

/// 阶段代码
Property TSStage As %String;

/// 阶段描述
Property TSDesc As %String;

/// 阶段开始日期
Property TSStartDate As %String;

/// 阶段结束日期
Property TSEndDate As %String;

/// 周期数
Property TSNextNum As %String;

/// 化疗日期
Property TSChemoDate As %String;

ClassMethod GetInfo(ID) As DHCDoc.Chemo.Model.TemplateStage
{
	S MObj=##class(DHCDoc.Chemo.Model.TemplateStage).%New()
	Q:ID="" MObj
	S DObj=##class(User.ChemoTemplateStage).%OpenId(ID)
	I '$ISObject(DObj) {
		Q MObj
	}
	S MObj.TSStage=DObj.TSStage
	S MObj.TSDesc=DObj.TSDesc
	S MObj.TSStartDate=DObj.TSStartDate
	S MObj.TSEndDate=DObj.TSEndDate
	S MObj.TSChemoDate=DObj.TSChemoDate
	S MObj.TSNextNum=DObj.TSNextNum
	
	Q MObj
}

}
