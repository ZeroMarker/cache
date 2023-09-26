Class web.Entity.MKB.MKBGlobal Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.MKB.MKBGlobal";

/// RowId
Property MKBGRowId As %String;

/// 编码
Property MKBGCode As %String;

/// 中心词
Property MKBGDesc As %String;

/// 英文
Property MKBGEnName As %String;

/// 备注
Property MKBGNote As %String;

/// 拼音码
Property MKBGPYCode As %String;

/// 所属层级
Property MKBGLastLevel As %String;

/// 状态（在用、封闭、删除、合并）
Property MKBGState As %String;

/// 是否确认
Property MKBGConfirm As %String;

Property MKBGMark As %String;

/// 诊断开立总频次
Property MKBGDiaTotalFreq As %String;

}
