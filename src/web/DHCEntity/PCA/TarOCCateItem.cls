/// Creator:Lid
/// CreatDate:2012-02-07
/// Description:病人医嘱门诊分类类
Class web.DHCEntity.PCA.TarOCCateItem Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

/// 门诊分类描述
Property TarOCCateDesc As %String(TRUNCATE = 1);

/// 门诊分类金额
Property TarOCCateAmt As %Float;

/// 医嘱明细
Property OEOrdItems As list Of web.DHCEntity.PCA.OEOrdItem;

}
