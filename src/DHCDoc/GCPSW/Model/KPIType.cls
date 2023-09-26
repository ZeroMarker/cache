/// CTOR: QP
/// DATE: 2020-09-03
/// DESC: 指标类型模型
Class DHCDoc.GCPSW.Model.KPIType Extends %RegisteredObject
{

/// 代码
Property KTCode As %String;

/// 描述
Property KTDesc As %String;

/// 备注
Property KTNote As %String;

/// 用户
Property KTUser As %String;

ClassMethod GetInfo(id) As DHCDoc.GCPSW.Model.KPIType
{
	S MObj=##class(DHCDoc.GCPSW.Model.KPIType).%New()
	Q:id="" MObj
	S DObj=##class(User.GCPSWKPIType).%OpenId(id)
	I '$ISObject(DObj) {
		Q MObj
	}
	S MObj.KTCode=DObj.KTCode
	S MObj.KTDesc=DObj.KTDesc
	S MObj.KTNote=DObj.KTNote
	S MObj.KTUser=DObj.KTUserGetObjectId()
	
	Q MObj
}

}
