/// 名称:	EMR.DOC.DTO.DPData
/// 描述:	个人短语传输对象
/// 编写者：yejian
/// 编写日期: 2022-11-1
/// 产品组：电子病历产品组
Class EMR.DOC.DTO.DPData Extends %RegisteredObject
{

/// rowID
Property ID As %String;

/// rowID
Property ContentID As %String;

/// 项目标识编码
Property Product As %String(TRUNCATE = 1);

/// 名称
Property Name As %String(TRUNCATE = 1);

/// 描述
Property Description As %String(TRUNCATE = 1);

/// 类型（个人目录:"DPTree",个人节点:"DPNode"）
Property Type As %String(TRUNCATE = 1);

/// 用户ID
Property UserID As %String(TRUNCATE = 1);

/// 科室ID
Property UserLocID As %String(TRUNCATE = 1);

/// 父节点
Property ParentID As %Integer;

/// 目录顺序
Property Sequence As %Integer;

/// 是否有效 （Y：有效-默认，N：无效）
Property IsValid As %String(TRUNCATE = 1);

/// 使用状态 0 新建，1 保存，2 发布, 3 申请审核,4 重新申请审核,5 审核不通过,-1 已删除
Property Status As %String(TRUNCATE = 1);

/// 备注
Property Remark As %String(MAXLEN = 2000, TRUNCATE = 1);

Property Langid As %String(TRUNCATE = 1);

/// 科室短语内容
Property Content As %GlobalCharacterStream;

}
