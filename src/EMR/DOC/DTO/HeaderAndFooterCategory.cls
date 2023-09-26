/// 名称:EMR.DOC.DTO.HeaderAndFooterCategory
/// 描述:通用文档管理模块 Document(Doc) 数据传输对象
/// 编写者：Guozongtao@mediway.cn
/// 编写日期: 2020-07-09
/// 产品组：电子病历产品组
Class EMR.DOC.DTO.HeaderAndFooterCategory Extends %RegisteredObject
{

Property Code As %String(MAXLEN = 200, TRUNCATE = 1);

Property Name As %String(MAXLEN = 200, TRUNCATE = 1);

Property Description As %String(MAXLEN = 200, TRUNCATE = 1);

Property ParentID As %String;

Property ResChildCount As %Integer;

}
