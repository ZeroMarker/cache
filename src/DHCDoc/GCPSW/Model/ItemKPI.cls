/// CTOR: QP
/// DATE: 2020-09-08
/// DESC: 子项指标模型
Class DHCDoc.GCPSW.Model.ItemKPI Extends %RegisteredObject
{

/// 代码
Property IKCode As %String;

/// 描述
Property IKName As %String;

/// 描述
Property IKComplex As %String;

/// 备注
Property IKNote As %String;

/// 表达式
Property IKExpress As %String;

/// 医嘱名称
Property IKArcim As %String;

ClassMethod GetInfo(id) As DHCDoc.GCPSW.Model.ItemKPI
{
	S MObj=##class(DHCDoc.GCPSW.Model.ItemKPI).%New()
	Q:id="" MObj
	S DObj=##class(User.GCPSWItemKPI).%OpenId(id)
	I '$ISObject(DObj) {
		Q MObj
	}
	S MObj.IKCode=DObj.IKCode
	S MObj.IKName=DObj.IKName
	S MObj.IKComplex=DObj.IKComplex
	S MObj.IKNote=DObj.IKNote
	S MObj.IKExpress=DObj.IKExpress
	S MObj.IKArcim=DObj.IKArcim
	
	Q MObj
}

}
