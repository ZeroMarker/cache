/// CTOR: QP
/// DATE: 2020-12-23
/// DESC: 化疗药品字典
Class DHCDoc.Chemo.Model.DrugDic Extends %RegisteredObject
{

/// 类型
Property DArcimDR As %String;

/// 地址
Property DArcimDesc As %String;

/// 地址
Property DSeqno As %String;

/// 地址
Property DActive As %String;

/// 简写
Property DName As %String;

ClassMethod GetInfo(ID) As DHCDoc.Chemo.Model.DrugDic
{
	S MObj=##class(DHCDoc.Chemo.Model.DrugDic).%New()
	Q:ID="" MObj
	S DObj=##class(User.ChemoDrugDic).%OpenId(ID)
	I '$ISObject(DObj) {
		Q MObj
	}
	S MObj.DActive=DObj.DActive
	S MObj.DName=DObj.DName
	S MObj.DArcimDR=DObj.DArcimDRGetObjectId()
	s ARC=+MObj.DArcimDR,VER=$P(MObj.DArcimDR,"||",2)
	S MObj.DArcimDesc=$p(^ARCIM(ARC,VER,1),"^",2)
	S MObj.DSeqno=DObj.DSeqno
	
	Q MObj
}

}
