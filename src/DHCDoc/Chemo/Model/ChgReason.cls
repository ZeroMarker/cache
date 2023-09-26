/// CTOR: QP
/// DATE: 2020-06-12
/// DESC: 变更原因模型类
Class DHCDoc.Chemo.Model.ChgReason Extends %RegisteredObject
{

/// 变更原因
Property CRReason As %String;

/// 化疗模板
Property CRTemplateDR As %String;

/// 有效标志
Property CRActive As %String;

ClassMethod GetInfo(CRID) As DHCDoc.Chemo.Model.ChgReason
{
	S MObj=##class(DHCDoc.Chemo.Model.ChgReason).%New()
	Q:CRID="" MObj
	S DObj=##class(User.ChemoChgReason).%OpenId(CRID)
	I '$ISObject(DObj) {
		Q MObj
	}
	S MObj.CRActive=DObj.CRActive
	S MObj.CRReason=DObj.CRReason
	S MObj.CRTemplateDR=DObj.CRTemplateDRGetObjectId()
	
	Q MObj
}

}
