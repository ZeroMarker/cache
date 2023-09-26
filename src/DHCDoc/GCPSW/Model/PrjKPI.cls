/// CTOR: QP
/// DATE: 2020-09-09
/// DESC: 项目指标模型
Class DHCDoc.GCPSW.Model.PrjKPI Extends %RegisteredObject
{

/// 指标类型
Property PKType As %String;

/// 指标
Property PKKPI As %String;

/// 指标代码
Property KPICode As %String;

/// 是否区间
Property PKSection As %String;

/// 筛选值
Property PKVal As %String;

/// 单位
Property PKKPIUom As %String;

/// 科研项目
Property PKNote As %String;

/// 表达式
Property Express As %String;

ClassMethod GetInfo(id) As DHCDoc.GCPSW.Model.PrjKPI
{
	S MObj=##class(DHCDoc.GCPSW.Model.PrjKPI).%New()
	Q:id="" MObj
	S DObj=##class(User.GCPSWPrjKPI).%OpenId(id)
	I '$ISObject(DObj) {
		Q MObj
	}
	S MObj.PKKPI=DObj.PKKPIGetObjectId()

 	S KTID=+MObj.PKKPI,CH=$p(MObj.PKKPI,"||",2)
 	S Express=$p(^CF.DOC.GCPSW.KPITypeD(KTID,"K",CH),"^",8)
 	S KPICode=$p(^CF.DOC.GCPSW.KPITypeD(KTID,"K",CH),"^",1)
 	S MObj.Express=Express
 	S MObj.KPICode=KPICode
	S MObj.PKType=+MObj.PKKPI
	S MObj.PKSection=DObj.PKSection
	S MObj.PKVal=DObj.PKVal
	S MObj.PKKPIUom=DObj.PKKPIUom
	S MObj.PKNote=DObj.PKNote
	
	Q MObj
}

}
