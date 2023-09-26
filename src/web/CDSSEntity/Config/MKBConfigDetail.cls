/// Creator:Xuwenhu
/// CreatDate:2022-04-26
/// Description：平台配置值子表实体类
/// Table：CF.WDT.CDSS.MKBConfigDetail
Class web.CDSSEntity.Config.MKBConfigDetail Extends (%RegisteredObject, web.DHCEntity.ELAbstract)
{

Parameter PersistentClassName = "web.CDSSEntity.Config.MKBConfigDetail";

Property CDetailParRef As %String;

Property RowId As %String;

/// 配置项值	
Property CDetailValue As %String;

/// 是否激活
Property CDetailActive As %String;

/// 类型[全院，院区，科室]
Property CDetailType As %String;

// 医院院区DR

// Property HospitalDR As %String;

// 医院院区

// Property HospAreaDesc As %String;

/// 配置对象
Property HospitalDesc As %String;

/// 编辑人员
Property UpdateUser As %String;

/// 编辑时间
Property UpdateDate As %String;

/// 备注
Property Remarks As %String;

}
