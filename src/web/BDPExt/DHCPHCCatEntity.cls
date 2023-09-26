/// 名称: 药理学分类维护
/// 描述: 实体类
/// 编写者：基础数据平台组-sunfengchao
/// 编写日期: 2016-11-28
/// PHCC_RowId PHCC_Code PHCC_Desc PHCC_ParCat_Dr PHCC_Level PHCC_Hosp_Dr 
Class web.BDPExt.DHCPHCCatEntity Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.BDPExt.DHCPHCCatEntity";

/// RowId
Property PHCCRowId As %String;

/// 代码
Property PHCCCode As %String;

/// 描述
Property PHCCDesc As %String;

/// 上一级分类
Property PHCCParCatDr As %String;

Property PHCCParCatDrCode As %String;

Property PHCCCat1 As %String;

Property PHCCCat2 As %String;

Property PHCCCat3 As %String;

Property PHCCCat4 As %String;

Property PHCCCat5 As %String;

Property PHCCCat6 As %String;

Property PHCCCat7 As %String;

/// PHCC_Level
Property PHCCLevel As %String;

/// 医院
Property PHCCHospDr As %String;

}
