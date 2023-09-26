/// CTOR: QP
/// DATE: 2019-05-07
/// DESC: 抗菌药物项目本地化的扩展数据DTO
Class DHCAnt.Base.Dto.ModePrj Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLIGNORENULL = 1;

/// 一 过敏史部分
/// 1有无过敏史
Property HasGMis As %Library.String(TRUNCATE = 1);

/// 2过敏药物
Property GMDrug As %Library.String(TRUNCATE = 1);

/// 3过敏分类
Property GMClassify As %Library.String(TRUNCATE = 1);

/// 二 感染情况
/// 4T℃
Property T As %Library.String(TRUNCATE = 1);

/// 5WBC
Property WBC As %Library.String(TRUNCATE = 1);

/// 6N
Property N As %Library.String(TRUNCATE = 1);

/// 7CRP
Property CRP As %Library.String(TRUNCATE = 1);

/// 8PCT
Property PCT As %Library.String(TRUNCATE = 1);

/// 9G
Property G As %Library.String(TRUNCATE = 1);

/// 10GM
Property GM As %Library.String(TRUNCATE = 1);

/// 11GRQT
Property GRQT As %Library.String(TRUNCATE = 1);

/// 三 感染情况
/// 12是否做过病原学检查
Property HasBYX As %Library.String(TRUNCATE = 1);

/// 13病原学结果
Property BYXResult As %Library.String(TRUNCATE = 1);

/// 四 药品通用名称
/// 14是否联用
Property HasCombined As %Library.String(TRUNCATE = 1);

/// 15联用药品通用名
Property CombinedDrug As %Library.String(TRUNCATE = 1);

/// 16联用理由
Property CombinedReason As %Library.String(TRUNCATE = 1);

/// 五 使用方法
/// 17单次剂量
Property JL As %Library.String(TRUNCATE = 1);

/// 21剂量单位
Property JLUom As %Library.String(TRUNCATE = 1);

/// 18频次
Property Freq As %Library.String(TRUNCATE = 1);

/// 20用法
Property Instruc As %Library.String(TRUNCATE = 1);

/// 22医嘱类型
Property Prior As %Library.String(TRUNCATE = 1);

/// 六 药物品种选择理由
/// 19药品品种选择理由
Property DrugReason As %Library.String(TRUNCATE = 1);

}
