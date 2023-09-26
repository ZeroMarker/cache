/// CTOR: QP
/// DATE: 2020-09-07
/// DESC: 子项类型模型
Class DHCDoc.GCPSW.Model.Item Extends %RegisteredObject
{

/// 代码
Property ITCode As %String;

/// 描述
Property ITDesc As %String;

/// 备注
Property ITNote As %String;

/// 用户
Property ITUser As %String;

/// 医嘱项
Property ITArcim As %String;

/// w #class(DHCDoc.GCPSW.Model.Item).GetInfo("3||1")
ClassMethod GetInfo(id) As DHCDoc.GCPSW.Model.Item
{
	S MObj=##class(DHCDoc.GCPSW.Model.Item).%New()
	Q:id="" MObj
	S DObj=##class(User.GCPSWItem).%OpenId(id)
	I '$ISObject(DObj) {
		Q MObj
	}
	S MObj.ITCode=DObj.ITCode
	S MObj.ITDesc=DObj.ITDesc
	S MObj.ITNote=DObj.ITNote
	S MObj.ITUser=DObj.ITUserGetObjectId()
	S MObj.ITArcim=DObj.ITArcim
	
	Q MObj
}

}
