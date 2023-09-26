Class web.CDSSEntity.CMKB.DiseJoinDocu Extends (%RegisteredObject, web.DHCEntity.ELAbstract)
{

Parameter PersistentClassName = "web.CDSSEntity.CMKB.DiseJoinDocu";

/// 疾病关联指南表id
Property RowId As %String;

/// 疾病表DR
Property DiseaseDR As %String;

/// 文献指向 文献管理表
Property DocuDR As %String;

/// 修改时间
Property DocuModifyDate As %String;

/// 修改人
Property DocuModifyUser As %String;

/// 识别词指向 识别词字典表[识别条件]
Property IWordsDR As %String;

}
