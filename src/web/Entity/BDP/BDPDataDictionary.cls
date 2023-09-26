/// Function: 数据字典
/// Creator:  sunfengchao
/// CreateDate:2018-08-23
Class web.Entity.BDP.BDPDataDictionary Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.BDP.BDPDataDictionary";

Property BDPDictionaryRowId As %String;

///  代码
Property BDPDictionaryCode As %String;

///  描述
Property BDPDictionaryDesc As %String;

/// 所属字典目录
Property BDPDictionaryDR As %String;

/// 菜单指向
Property BDPParentMenuDr As %String;

/// 开始日期
Property BDPDictionaryDateFrom As %String;

/// 结束日期
Property BDPDictionaryDateTo As %String;

/// 预留字段1  如果是 字典 就存 字段含义 是字典数据就存value值
Property BDPDictionaryText1 As %String;

/// 预留字段2
Property BDPDictionaryText2 As %String;

/// 预留字段3
Property BDPDictionaryText3 As %String;

/// 预留字段4
Property BDPDictionaryText4 As %String;

/// 预留字段5
Property BDPDictionaryText5 As %String;

/// 预留字段6
Property BDPDictionaryText6 As %String;

/// 预留字段7
Property BDPDictionaryText7 As %String;

/// 预留字段8
Property BDPDictionaryText8 As %String;

/// 预留字段9
Property BDPDictionaryText9 As %String;

/// 预留字段10
Property BDPDictionaryText10 As %String;

/// 预留字段11
Property BDPDictionaryText11 As %String;

/// 预留字段12
Property BDPDictionaryText12 As %String;

/// 预留字段13
Property BDPDictionaryText13 As %String;

/// 预留字段14
Property BDPDictionaryText14 As %String;

/// 预留字段15
Property BDPDictionaryText15 As %String;

/// 表结构登记的下拉框
Property BDPMenu As %String;

Property BDPConfigFlag As %String;

/// 自动生成的配置源
Property BDPExtMenuDr As %String;

}
