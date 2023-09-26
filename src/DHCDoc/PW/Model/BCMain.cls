/// CTOR: QP
/// DATE: 2020-09-03
/// DESC: 交班本配置模型
Class DHCDoc.PW.Model.BCMain Extends %RegisteredObject
{

/// 类型
Property BMType As %String;

/// 描述
Property BMDesc As %String;

/// 激活
Property BMActive As %String;

ClassMethod GetInfo(id) As DHCDoc.PW.Model.BCMain
{
	S MObj=##class(DHCDoc.PW.Model.BCMain).%New()
	Q:id="" MObj
	S DObj=##class(User.DHCDocPassWorkBCMain).%OpenId(id)
	I '$ISObject(DObj) {
		Q MObj
	}
	s MObj.BMActive=DObj.BMActive
	s MObj.BMDesc=DObj.BMDesc
	S MObj.BMType=DObj.BMType
	
	Q MObj
}

}
