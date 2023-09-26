/// CTOR: QP
/// DATE: 2020-06-24
/// DESC: 终身剂量模型类
Class DHCDoc.Chemo.Model.LifeDose Extends %RegisteredObject
{

/// 化疗药品
Property LDArcimDR As %String;

/// 化疗药品
Property LDArcimDesc As %String;

/// 终身剂量
Property LDDosage As %String;

/// 剂量单位
Property LDUomDR As %String;

ClassMethod GetInfo(LDID) As DHCDoc.Chemo.Model.LifeDose
{
	S MObj=##class(DHCDoc.Chemo.Model.LifeDose).%New()
	Q:LDID="" MObj
	S DObj=##class(User.ChemoLifeDose).%OpenId(LDID)
	I '$ISObject(DObj) {
		Q MObj
	}
	S MObj.LDUomDR=DObj.LDUomDR
	S MObj.LDDosage=DObj.LDDosage
	S MObj.LDArcimDR=DObj.LDArcimDRGetObjectId()
	S ARC=+MObj.LDArcimDR,VER=$P(MObj.LDArcimDR,"||",2)
	S MObj.LDArcimDesc=$p(^ARCIM(ARC,VER,1),"^",2)
	
	Q MObj
}

}
