/// CTOR: QP
/// DATE: 2020-06-11
/// DESC: 模板
Class DHCDoc.Chemo.Model.Template Extends %RegisteredObject
{

/// 模板类型
Property TPType As %String;

/// 模板描述
Property TPDesc As %String;

/// 化疗单名称
Property TPName As %String;

/// 总阶段数
Property TPStageNum As %Numeric;

/// 有效标志
Property TPActive As %String;

/// 化疗方案主药信息备注
Property TPMainNote As %String;

/// 化疗方案标题
Property TPTitle As %String;

/// 化疗方案别名
Property TPOtherName As %String;

/// 其它描述
Property TPOtherDesc As %String;

/// 其它科室
Property TPOtherLoc As %String;

ClassMethod GetInfo(TPID) As DHCDoc.Chemo.Model.Template
{
	S MObj=##class(DHCDoc.Chemo.Model.Template).%New()
	Q:TPID="" MObj
	S DObj=##class(User.ChemoTemplate).%OpenId(TPID)
	I '$ISObject(DObj) {
		Q MObj
	}
	S MObj.TPType=DObj.TPType
	S MObj.TPDesc=DObj.TPDesc
	S MObj.TPName=DObj.TPName
	S MObj.TPStageNum=DObj.TPStageNum
	S MObj.TPActive=DObj.TPActive
	S MObj.TPMainNote=DObj.TPMainNote
	S MObj.TPTitle=DObj.TPTitle
	S MObj.TPOtherName=DObj.TPOtherName
	S MObj.TPOtherDesc=DObj.TPOtherDesc
	S MObj.TPOtherLoc=DObj.TPOtherLoc
	
	Q MObj
}

}
