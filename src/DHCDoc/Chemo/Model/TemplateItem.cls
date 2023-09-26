/// CTOR: QP
/// DATE: 2020-04-28
/// DESC: 模板化疗组项目模型类
Class DHCDoc.Chemo.Model.TemplateItem Extends %RegisteredObject
{

/// 模板类型
Property TPGIArcimDR As %String;

/// 模板类型
Property TPGIArcimDesc As %String;

/// 剂量
Property TPGIDosage As %Float;

/// 剂量单位
Property TPGIDosageUomDR As %String;

/// 频次
Property TPGIFreqDR As %String;

/// 用法
Property TPGIInstrucDR As %String;

/// 疗程
Property TPGIDuratDR As %String;

/// 数量
Property TPGIQty As %Float;

/// 单位
Property TPGIUomDR As %String;

/// 关联
Property TPGILinkItem As %String;

/// 备注
Property TPGINote As %String;

/// 医嘱类型
Property TPGIPriorDR As %String;

/// 标本
Property TPGISimpleDR As %String;

/// 附加说明
Property TPGIRemark As %String;

/// 接受科室
Property TPGIRecLoc As %String;

/// 医嘱阶段
Property TPGIStage As %String;

/// 输液流速
Property TPGIFlowRate As %String;

/// 流速单位
Property TPGIFlowRateDR As %String;

/// 皮试
Property TPGISkinTest As %String;

/// 皮试备注
Property TPGISkinAction As %String;

/// 是否主药
Property TPGIMainDrug As %String;

/// 计算公式
Property TPGIFormula As %String;

/// 标准值
Property TPGIBSAUnitSTD As %String;

/// 输入值
Property TPGIBSAUnit As %String;

/// 主药备注
Property TPGIMainDrugNote As %String;

/// 显示日期
Property TPGIShowDate As %String;

/// 医嘱子类
Property TPGIItemDr As %String;

ClassMethod GetInfo(TPGIID) As DHCDoc.Chemo.Model.TemplateItem
{
	S MObj=##class(DHCDoc.Chemo.Model.TemplateItem).%New()
	Q:TPGIID="" MObj
	S DObj=##class(User.ChemoTemplateItem).%OpenId(TPGIID)
	I '$ISObject(DObj) {
		Q MObj
	}
	s MObj.TPGIArcimDR=DObj.TPGIArcimDRGetObjectId()
	S ARC=+MObj.TPGIArcimDR,VER=$P(MObj.TPGIArcimDR,"||",2)
	S MObj.TPGIArcimDesc=$p(^ARCIM(ARC,VER,1),"^",2)
	S ItemDr=$p(^ARCIM(ARC,VER,1),"^",10)
	S MObj.TPGIItemDr=ItemDr
	S MObj.TPGIDosage=DObj.TPGIDosage
	S MObj.TPGIDosageUomDR=DObj.TPGIDosageUomDRGetObjectId()
	S MObj.TPGIDuratDR=DObj.TPGIDuratDRGetObjectId()
	S MObj.TPGIFlowRate=DObj.TPGIFlowRate
	S MObj.TPGIFlowRateDR=DObj.TPGIFlowRateDRGetObjectId()
	S MObj.TPGIFreqDR=DObj.TPGIFreqDRGetObjectId()
	S MObj.TPGIInstrucDR=DObj.TPGIInstrucDRGetObjectId()
	S MObj.TPGILinkItem=DObj.TPGILinkItem
	S MObj.TPGINote=DObj.TPGINote
	S MObj.TPGIPriorDR=DObj.TPGIPriorDRGetObjectId()
	S MObj.TPGIQty=DObj.TPGIQty
	S MObj.TPGIRecLoc=DObj.TPGIRecLocGetObjectId()
	S MObj.TPGIRemark=DObj.TPGIRemark
	S MObj.TPGISimpleDR=DObj.TPGISimpleDR
	S MObj.TPGISkinAction=DObj.TPGISkinActionGetObjectId()
	S MObj.TPGISkinTest=DObj.TPGISkinTest
	S MObj.TPGIStage=DObj.TPGIStage
	S MObj.TPGIUomDR=DObj.TPGIUomDRGetObjectId()
	S MObj.TPGIMainDrug=DObj.TPGIMainDrug
	S MObj.TPGIFormula=DObj.TPGIFormula
	S MObj.TPGIBSAUnitSTD=DObj.TPGIBSAUnitSTD
	S MObj.TPGIBSAUnit=DObj.TPGIBSAUnit
	S MObj.TPGIMainDrugNote=DObj.TPGIMainDrugNote
	S MObj.TPGIShowDate=DObj.TPGIShowDate
	Q MObj
}

}
