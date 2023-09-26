/// Desc:		图库目录
/// Creator:	yejian
/// CreateDate:	2017-8-9
Class EMRservice.entity.Image.ECategory Extends (%RegisteredObject, %XML.Adaptor)
{

Property ID As %String(TRUNCATE = 1);

/// 编码
Property Code As %String(TRUNCATE = 1);

/// 名称
Property Name As %String(MAXLEN = 20, TRUNCATE = 1);

/// 描述
Property Description As %String(MAXLEN = 200, TRUNCATE = 1);

/// 父节点RowID
Property ParentID As %String;

/// 顺序
Property Sequence As %String;

}
