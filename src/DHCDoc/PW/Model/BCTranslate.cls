/// CTOR: QP
/// DATE: 2021-11-15
/// DESC: 翻译类型模型
Class DHCDoc.PW.Model.BCTranslate Extends %RegisteredObject
{

/// 产品线
Property TProductLine As %String;

/// 表名
Property TCode As %String;

/// 描述
Property TDesc As %String;

ClassMethod GetInfo(id) As DHCDoc.PW.Model.BCTranslate
{
	S MObj=##class(DHCDoc.PW.Model.BCTranslate).%New()
	Q:id="" MObj
	S DObj=##class(User.DHCDocPassWorkTranslate).%OpenId(id)
	I '$ISObject(DObj) {
		Q MObj
	}
	S MObj.TProductLine=DObj.TProductLine
	S MObj.TCode=DObj.TCode
	S MObj.TDesc=DObj.TDesc
	
	Q MObj
}

}
