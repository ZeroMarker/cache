/// Description：检验标本字典表 
/// Table：CT.WDT.CDSS.LabSpecimenDict
Class web.CDSSEntity.CMKB.LabSpecimenDict Extends (%RegisteredObject, web.DHCEntity.ELAbstract)
{

Parameter PersistentClassName = "web.CDSSEntity.CMKB.LabSpecimenDict";

/// SpecimenRowId
Property SpecimenRowId As %String;

/// 标本编码
Property SpecimenCode As %String;

/// 标本名称
Property SpecimenName As %String;

/// 标本描述
Property SpecimenDesc As %String;

/// 标本采集标准
Property SpecimenNorm As %String;

Property UseFlag As %String;

Property CreateDate As %String;

Property CreateUserID As %String;

Property Remarks As %String;

/// 标本类型
Property SpecimenType As %String;

/// 英文名称
Property EnglishName As %String;

/// 单位
Property Unit As %String;

/// 检验单名称
Property InspectionSheet As %String;

/// 标本别名
Property SpecimenAlias As %String;

}
