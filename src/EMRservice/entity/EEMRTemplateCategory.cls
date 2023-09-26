Class EMRservice.entity.EEMRTemplateCategory Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

/// rowid
Property ID As %String(TRUNCATE = 1);

Property CategoryName As %String(TRUNCATE = 1);

Property CategoryType As %String(TRUNCATE = 1);

Property ParentCategoryID As %String(TRUNCATE = 1);

Property CategorySeq As %Integer;

/// 互斥标示
Property IsMutex As %String(TRUNCATE = 1);

/// 引导框标示
Property IsLeadframe As %String(TRUNCATE = 1);

/// 待签，0或空：显示待签，1：不显示待签.
Property IsWaitsign As %String(TRUNCATE = 1);

/// 小图标路径
Property ImageUrl As %String(TRUNCATE = 1);

/// 内部表示符
Property InternalID As %String(TRUNCATE = 1);

/// 模板描述简拼
Property JaneSpell As %String(TRUNCATE = 1);

/// 模板描述全拼
Property FullFight As %String(TRUNCATE = 1);

}
