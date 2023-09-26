/// CTOR: QP
/// DATE: 2020-06-11
/// DESC: 化疗组
Class DHCDoc.Chemo.Model.TemplateGroup Extends %RegisteredObject
{

/// 化疗单名称
Property TPGCode As %String;

/// 总阶段数
Property TPGDesc As %String;

/// 有效标志
Property TPGPlanDate As %String;

/// 有效标志
Property TPGNote As %String;

/// 有效标志
Property TPGVeinFlag As %String;

/// 是否主要组
Property TPGMainDrug As %String;

ClassMethod GetInfo(TPGID) As DHCDoc.Chemo.Model.TemplateGroup
{
	S MObj=##class(DHCDoc.Chemo.Model.TemplateGroup).%New()
	Q:TPGID="" MObj
	S DObj=##class(User.ChemoTemplateGroup).%OpenId(TPGID)
	I '$ISObject(DObj) {
		Q MObj
	}
	S MObj.TPGCode=DObj.TPGCode
	S DescDR=DObj.TPGDescGetObjectId()
	S MObj.TPGDesc=DescDR	//##class(DHCDoc.Chemo.COM.Func2).GetChemoDicDesc(DescDR)
	S MObj.TPGPlanDate=DObj.TPGPlanDate
	S MObj.TPGNote=DObj.TPGNote
	S MObj.TPGVeinFlag=DObj.TPGVeinFlag
	S MObj.TPGMainDrug=DObj.TPGMainDrug
	
	Q MObj
}

}
