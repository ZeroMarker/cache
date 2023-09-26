/// CTOR: QP
/// DATE: 2020-09-04
/// DESC: 指标模型
Class DHCDoc.GCPSW.Model.KPI Extends %RegisteredObject
{

/// 代码
Property KPICode As %String;

/// 描述
Property KPIName As %String;

/// 描述
Property KPIComplex As %String;

/// 备注
Property KPINote As %String;

/// 表达式
Property KPIExpress As %String;

ClassMethod GetInfo(id) As DHCDoc.GCPSW.Model.KPI
{
	S MObj=##class(DHCDoc.GCPSW.Model.KPI).%New()
	Q:id="" MObj
	S DObj=##class(User.GCPSWKPI).%OpenId(id)
	I '$ISObject(DObj) {
		Q MObj
	}
	S MObj.KPICode=DObj.KPICode
	S MObj.KPIName=DObj.KPIName
	S MObj.KPIComplex=DObj.KPIComplex
	S MObj.KPINote=DObj.KPINote
	S MObj.KPIExpress=DObj.KPIExpress
	
	Q MObj
}

}
