/// Creator:胡宜良
/// CreatDate:2022-02-21
/// Description：中医疾病关联证候表
Class web.CDSSEntity.CMKB.TCMDiseJSym Extends (%RegisteredObject, web.DHCEntity.ELAbstract)
{

Parameter PersistentClassName = "web.CDSSEntity.CMKB.TCMDiseJSym";

/// 中医疾病关联证候表id
Property RowId As %String;

/// 中医疾病id
Property TCMDiseDR As %String;

/// 证型（中医证候字典id）
Property TCMSymDR As %String;

/// 最后操作时间
Property UpdateDate As %String;

/// 责任人
Property ResponUser As %String;

/// 审核人
Property ReviewUser As %String;

/// 状态（初始、编辑中、待审核、审核不通过、已上线、已下线，默认初始）
Property State As %String;

/// 备注
Property Remarks As %String(MAXLEN = "");

/// 西医名称 指向疾病字典
Property DiseaseDR As %String;

}
