/// CTOR: QP
/// DATE: 2020-11-09
/// DESC: 预警信息模型类
Class DHCDoc.GCPSW.Model.Warning Extends %RegisteredObject
{

/// 禁用类型
Property WType As %String;

/// 禁用项目
Property WItem As %String;

/// 预警信息
Property WMsg As %String;

/// 备注
Property WNote As %String;

/// 禁用项目Dr
Property WItemDr As %String;

ClassMethod GetInfo(id) As DHCDoc.GCPSW.Model.Warning
{
	S MObj=##class(DHCDoc.GCPSW.Model.Warning).%New()
	Q:id="" MObj
	S DObj=##class(User.GCPSWarning).%OpenId(id)
	I '$ISObject(DObj) {
		Q MObj
	}
	s MObj.WType=DObj.WType
	i DObj.WType="A" {
		s itemDr=DObj.WItem
		s arc=+itemDr,sub=$p(itemDr,"||",2)
		s item=$p(^ARCIM(arc,sub,1),"^",2)
		S MObj.WItem=item
	} else {
		S MObj.WItem=DObj.WItem	
	}
	S MObj.WItemDr=DObj.WItem	
	S MObj.WMsg=DObj.WMsg
	S MObj.WNote=DObj.WNote
	
	Q MObj
}

}
