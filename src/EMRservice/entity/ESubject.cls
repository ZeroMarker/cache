Class EMRservice.entity.ESubject Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

Property ID As %String(TRUNCATE = 1);

/// 订阅项数据编码
Property Code As %String(MAXLEN = 30, TRUNCATE = 1) [ Required ];

/// 术语编码
Property Glossary As %String(MAXLEN = 30, TRUNCATE = 1) [ Required ];

/// 订阅数据项描述
Property Description As %String(MAXLEN = 200, TRUNCATE = 1);

/// 表达式
Property Expression As %String(MAXLEN = 200, TRUNCATE = 1);

/// 订阅数据类型
Property Type As %String(MAXLEN = 30, TRUNCATE = 1) [ Required ];

/// 是否有效 Y/N
Property IsActive As %String(MAXLEN = 3, TRUNCATE = 1);

/// 备注文本
Property ResumeText As %String(MAXLEN = 200, TRUNCATE = 1);

/// 事件
Property Event As %String(TRUNCATE = 1);

}
