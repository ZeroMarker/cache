/// CTOR: QP
/// DATE: 2020-09-10
/// DESC: 项目指标子项模型
Class DHCDoc.GCPSW.Model.PrjKPIItem Extends %RegisteredObject
{

/// 指标类型
Property Type As %String;

/// 指标
Property KPI As %String;

/// 指标类型
Property KPIType As %String;

/// 指标代码
Property KPICode As %String;

/// 是否区间
Property Section As %String;

/// 筛选值
Property Val As %String;

/// 单位
Property Uom As %String;

/// 备注
Property Note As %String;

/// 标准值
Property StdVal As %String;

/// 匹配模式
Property Rule As %String;

ClassMethod GetInfo(id) As DHCDoc.GCPSW.Model.PrjKPIItem
{
	S MObj=##class(DHCDoc.GCPSW.Model.PrjKPIItem).%New()
	Q:id="" MObj
	S DObj=##class(User.GCPSWPrjKPIItem).%OpenId(id)
	I '$ISObject(DObj) {
		Q MObj
	}
	S MObj.KPI=DObj.PKIKPIGetObjectId()
	S KTID=+MObj.KPI,SUB=$P(MObj.KPI,"||",2)
	S MObj.Type=KTID_"||"_SUB
	S MObj.Section=DObj.PKISection
	S MObj.Uom=DObj.PKIKPIUom
	S MObj.Note=DObj.PKINote
	S MObj.StdVal=DObj.PKIStdVal
	S MObj.Val=DObj.PKIVal
	S MObj.Rule=DObj.PKIRule
	S MObj.KPIType=DObj.PKIKPITypeGetObjectId()
	
	Q MObj
}

}
